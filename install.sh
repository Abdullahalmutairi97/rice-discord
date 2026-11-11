#!/usr/bin/env bash
# Rice Discord themes — installs Vesktop (Discord with Vencord built in) and the 12 rice themes.
#   curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash                  # asks which theme (Enter = Blood Moon)
#   curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash -s -- neon       # or name one:
#   blood-moon moonlight wreck citadel neon ashen violet ink bonfire hunter shards vale
# Switch later in Vesktop: User Settings → Vencord → Themes.
set -euo pipefail

BASE="${RICE_DISCORD_BASE:-https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main}"
THEMES=(blood-moon moonlight wreck citadel neon ashen violet ink bonfire hunter shards vale)
NAMES=("Blood Moon" "Moonlight" "Wreck" "Citadel" "Neon" "Ashen" "Violet" "Ink" "Bonfire" "Hunter" "Shards" "Vale")
APP=dev.vencord.Vesktop

say() { printf '\n\033[1;35m»\033[0m %s\n' "$*"; }
die() { printf '\n\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

# which theme: the one named after the command, else ask (the keyboard still works when piped from curl)
PICK="${1:-}"
if [[ -z "$PICK" ]] && { exec 3</dev/tty; } 2>/dev/null; then
    printf '\n\033[1mWhich theme do you want?\033[0m\n\n'
    for i in "${!NAMES[@]}"; do printf '  %2d) %s\n' $((i + 1)) "${NAMES[$i]}"; done
    printf '\nType a number and press Enter (just Enter = Blood Moon): '
    read -r n <&3 || n=""
    exec 3<&-
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= 1 && n <= ${#THEMES[@]} )); then PICK="${THEMES[$((n - 1))]}"; fi
fi
PICK="${PICK:-blood-moon}"
[[ " ${THEMES[*]} " == *" $PICK "* ]] || die "There's no theme called '$PICK'. Pick one of: ${THEMES[*]}"
for i in "${!THEMES[@]}"; do [[ "${THEMES[$i]}" == "$PICK" ]] && NAME="${NAMES[$i]}"; done

command -v curl >/dev/null || die "Something is missing (curl). Run: sudo apt install curl   then try again."
command -v python3 >/dev/null || die "Something is missing (python3). Run: sudo apt install python3   then try again."

# 1. Vesktop: use one that's already installed, else the Flathub one (just for this user, no password)
if command -v vesktop >/dev/null && [[ -d "$HOME/.config/vesktop" || ! -x "$(command -v flatpak)" ]]; then
    CFG="$HOME/.config/vesktop"; RUN=(vesktop)
else
    command -v flatpak >/dev/null || die "Something is missing (flatpak). Run: sudo apt install flatpak   then try again."
    if ! flatpak info "$APP" >/dev/null 2>&1; then
        say "Installing Vesktop (Discord with themes). This takes a few minutes the first time — leave this window open."
        flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install --user -y --noninteractive flathub "$APP"
    fi
    CFG="$HOME/.var/app/$APP/config/vesktop"; RUN=(flatpak run "$APP")
fi

# 2. Vesktop rewrites its settings when it quits, so it has to be closed while they change
if pgrep -f -i '(^|/)vesktop( |$)|dev\.vencord\.Vesktop' >/dev/null; then
    say "Closing Vesktop for a moment…"
    flatpak kill "$APP" 2>/dev/null || pkill -x vesktop 2>/dev/null || true
    for _ in $(seq 20); do pgrep -f -i '(^|/)vesktop( |$)|dev\.vencord\.Vesktop' >/dev/null || break; sleep 0.5; done
fi

# 3. the themes
mkdir -p "$CFG/themes" "$CFG/settings"
say "Downloading the themes…"
for t in "${THEMES[@]}"; do
    curl -fsSL "$BASE/themes/rice-$t.theme.css" -o "$CFG/themes/rice-$t.theme.css.part"
    mv "$CFG/themes/rice-$t.theme.css.part" "$CFG/themes/rice-$t.theme.css"
done

# 4. turn the picked one on (and any other rice theme off)
python3 - "$CFG/settings/settings.json" "rice-$PICK.theme.css" <<'PY'
import json, os, sys
path, pick = sys.argv[1], sys.argv[2]
try:
    s = json.load(open(path))
except Exception:
    s = {}
s['enabledThemes'] = [x for x in s.get('enabledThemes', []) if not x.startswith('rice-')] + [pick]
tmp = path + '.part'
json.dump(s, open(tmp, 'w'), indent=4)
os.replace(tmp, path)
PY

# 5. open it
if [[ -z "${RICE_NO_LAUNCH:-}" ]] && [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
    setsid "${RUN[@]}" >/dev/null 2>&1 < /dev/null &
    disown 2>/dev/null || true
    OPENED=" It's opening now."
fi

printf '\n\033[1;32m✓ All done! The %s theme is on.%s\033[0m\n' "$NAME" "${OPENED:-}"
printf '  Log in to Discord in the Vesktop window. Next time, open it from the menu: search "Vesktop".\n'
printf '  To change theme: click the ⚙ next to your name → Themes → turn one Rice theme off and another on.\n'
printf '  You can close this window.\n\n'
