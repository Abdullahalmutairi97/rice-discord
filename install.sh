#!/usr/bin/env bash
# Rice Discord themes — installs Vesktop (Discord with Vencord built in) and the 12 rice themes.
#   curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash                  # Blood Moon
#   curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash -s -- neon       # or pick one:
#   blood-moon moonlight wreck citadel neon ashen violet ink bonfire hunter shards vale
# Switch later in Vesktop: User Settings → Vencord → Themes.
set -euo pipefail

BASE="${RICE_DISCORD_BASE:-https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main}"
THEMES=(blood-moon moonlight wreck citadel neon ashen violet ink bonfire hunter shards vale)
PICK="${1:-blood-moon}"
APP=dev.vencord.Vesktop

say() { printf '\033[1;35m::\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; exit 1; }

[[ " ${THEMES[*]} " == *" $PICK "* ]] || die "unknown theme '$PICK' — pick one of: ${THEMES[*]}"
command -v curl >/dev/null || die "curl is missing: sudo apt install curl"
command -v python3 >/dev/null || die "python3 is missing: sudo apt install python3"

# 1. Vesktop: use one that's already installed, else the Flathub one (per-user, no sudo)
if command -v vesktop >/dev/null && [[ -d "$HOME/.config/vesktop" || ! -x "$(command -v flatpak)" ]]; then
    CFG="$HOME/.config/vesktop"
    say "using the installed Vesktop"
else
    command -v flatpak >/dev/null || die "flatpak is missing: sudo apt install flatpak"
    if ! flatpak info "$APP" >/dev/null 2>&1; then
        say "installing Vesktop from Flathub (a few hundred MB, one time)"
        flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install --user -y --noninteractive flathub "$APP"
    fi
    CFG="$HOME/.var/app/$APP/config/vesktop"
fi

# 2. Vesktop rewrites its settings when it quits, so it has to be closed while they change
if pgrep -f -i '(^|/)vesktop( |$)|dev\.vencord\.Vesktop' >/dev/null; then
    say "closing Vesktop for a moment"
    flatpak kill "$APP" 2>/dev/null || pkill -x vesktop 2>/dev/null || true
    for _ in $(seq 20); do pgrep -f -i '(^|/)vesktop( |$)|dev\.vencord\.Vesktop' >/dev/null || break; sleep 0.5; done
fi

# 3. the themes
mkdir -p "$CFG/themes" "$CFG/settings"
say "downloading the 12 themes"
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

say "done — Rice ${PICK} is on. Open Vesktop and log in to Discord."
say "other themes: User Settings → Vencord → Themes (switch Rice ${PICK} off, another on)."
