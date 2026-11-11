# Rice — Discord themes

Twelve Discord themes from a Hyprland rice: each one puts its wallpaper behind frosted-glass panels,
recolours Discord to its palette and swaps the home button for its own pixel icon.

Blood Moon · Moonlight · Wreck · Citadel · Neon · Ashen · Violet · Ink · Bonfire · Hunter · Shards · Vale

## Install (Linux Mint / Ubuntu / any distro with Flatpak)

```sh
curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash
```

That installs [Vesktop](https://github.com/Vencord/Vesktop) (Discord with Vencord built in) from Flathub for
your user only, so no password, then downloads the themes and turns on **Blood Moon**. Open Vesktop and log in.

Start with another theme by naming it:

```sh
curl -fsSL https://raw.githubusercontent.com/Abdullahalmutairi97/rice-discord/main/install.sh | bash -s -- neon
```

Switch any time in Vesktop: **User Settings → Vencord → Themes**, turn one Rice theme off and another on.
Running the command again updates the themes and keeps your other settings.

Already use Vencord or Vesktop elsewhere? Drop any file from [`themes/`](themes) into its themes folder.

## Uninstall

```sh
flatpak uninstall --user dev.vencord.Vesktop
```

and delete `~/.var/app/dev.vencord.Vesktop` to remove its settings and the themes.
