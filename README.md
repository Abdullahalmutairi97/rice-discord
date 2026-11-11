# Rice — Discord themes

Twelve Discord themes from a Hyprland rice: each one puts its wallpaper behind frosted-glass panels,
recolours Discord to its palette and swaps the home button for its own pixel icon.

Blood Moon · Moonlight · Wreck · Citadel · Neon · Ashen · Violet · Ink · Bonfire · Hunter · Shards · Vale

## Install (Linux Mint)

1. Press **Ctrl + Alt + T**. A black window opens.
2. Copy this line, click in the black window and press **Ctrl + Shift + V** to paste it:

   ```sh
   curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash
   ```

3. Press **Enter**. Type the number of the theme you want and press **Enter** again (or just Enter for Blood Moon).
4. Wait until it says **All done**. Vesktop opens by itself; log in to Discord there.

Next time, open **Vesktop** from the menu. It installs [Vesktop](https://github.com/Vencord/Vesktop) (Discord
with Vencord built in) from Flathub for your user only, so it never asks for a password.

Switch any time in Vesktop: click **⚙** next to your name → **Themes**, turn one Rice theme off and another on.
Running the command again updates the themes and keeps your other settings.

Already use Vencord or Vesktop elsewhere? Drop any file from [`themes/`](themes) into its themes folder.

## Uninstall

```sh
flatpak uninstall --user dev.vencord.Vesktop
```

and delete `~/.var/app/dev.vencord.Vesktop` to remove its settings and the themes.
