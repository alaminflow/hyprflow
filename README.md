# Arch Linux • Hyprland (TokyoNight) Dotfiles 🌌

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00aaee?style=for-the-badge&logo=wayland&logoColor=white)
![TokyoNight](https://img.shields.io/badge/Theme-TokyoNight-7aa2f7?style=for-the-badge)
![Shell](https://img.shields.io/badge/Shell-Zsh%20%2B%20Starship-blueviolet?style=for-the-badge&logo=gnu-bash&logoColor=white)

A clean, modular, and error-free dotfiles configuration for **Arch Linux** running **Hyprland** with modern Lua configuration, Waybar, Walker application launcher, Ghostty/Kitty terminals, and a unified **TokyoNight** aesthetic.

Includes an automated, interactive installer script with safety checks, timestamped backups, AUR bootstrapping, and dconf desktop preference loading.

---

## 🎨 Overview & Components

| Component | Software | Description |
| :--- | :--- | :--- |
| **Compositor** | [Hyprland](https://hyprland.org/) | Dynamic Wayland compositor configured with native Lua scripts (`v0.55+`) |
| **Session Manager** | [UWSM](https://github.com/Vladimir-csp/uwsm) | Universal Wayland Session Manager |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Top floating glassmorphism bar styled with TokyoNight palette |
| **Application Launcher** | [Walker](https://github.com/abenz1267/walker) + [Elephant](https://github.com/abenz1267/elephant) | Blazing-fast fuzzy runner, application launcher, and clipboard browser |
| **Terminals** | [Ghostty](https://ghostty.org/) & [Kitty](https://sw.kovidgoyal.net/kitty/) | Modern GPU-accelerated terminal emulators with TokyoNight theme |
| **Shell & Prompt** | [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) | Fast shell with autosuggestions, syntax highlighting, and custom prompt |
| **Notifications** | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) | Wayland notification daemon and control center |
| **Wallpaper** | [Hyprpaper](https://github.com/hyprwm/hyprpaper) | Lightweight Wayland wallpaper daemon with randomizer script |
| **Lockscreen & Idle** | [Hyprlock](https://github.com/hyprwm/hyprlock) & [Hypridle](https://github.com/hyprwm/hypridle) | Screen locking and power management |
| **File Manager** | [Thunar](https://docs.xfce.org/xfce/thunar/start) | Lightweight XFCE file manager with custom actions and thumbnailing |
| **GTK Theme** | `Tokyonight-Dark` | Complete GTK 3 & GTK 4 dark theme integration |
| **Icon Theme** | `Tokyonight-Moon` / `Papirus` | Matching dark icon sets |
| **Cursor Theme** | `Bibata-Modern-Classic` | Elegant modern cursor |
| **System Monitor** | [btop](https://github.com/aristocratos/btop) & [fastfetch](https://github.com/fastfetch-cli/fastfetch) | TokyoNight styled resource monitor & system fetch |

---

## ⌨️ Keybindings Cheatsheet

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `Super + Return` | Launch Terminal | Opens `ghostty` (or `kitty`) |
| `Super + Space` | App Launcher | Opens `walker` application runner |
| `Super + V` | Clipboard History | Opens `walker` with clipboard history via `cliphist` |
| `Super + E` | File Manager | Opens `thunar` |
| `Super + B` | Web Browser | Opens `brave` (or default browser) |
| `Super + C` | Code Editor | Opens `code` |
| `Super + Q` | Close Window | Closes focused window |
| `Super + F` | Fullscreen | Toggles fullscreen mode |
| `Super + T` | Floating Mode | Toggles floating window |
| `Super + P` | Pin Window | Pins window across all workspaces |
| `Super + S` | Scratchpad | Toggles special scratchpad dropdown |
| `Super + Shift + S` | Move to Scratchpad | Sends focused window to scratchpad |
| `Super + Shift + W` | Random Wallpaper | Switches wallpaper randomly via script |
| `Super + L` | Lock Screen | Triggers `hyprlock` |
| `Super + [1-9, 0]` | Workspace 1-10 | Switch workspace |
| `Super + Shift + [1-9, 0]` | Move Workspace | Move active window to workspace |
| `Print` | Screenshot Region | Select area (`slurp`) and edit with `swappy` |
| `Super + Left/Right/Up/Down` | Window Focus | Move focus in direction |
| `Super + Shift + Arrows` | Move Window | Move window position |
| `Super + Mouse Drag` | Move Floating Window | Left mouse drag |
| `Super + Mouse Resize` | Resize Window | Right mouse drag |
| `Super + Ctrl + Escape` | Exit Hyprland | Emergency exit compositor |

---

## 🚀 Installation on a New System

### Step 1: Install Arch Linux Base
Install Arch Linux using `archinstall` or manually. Ensure your network connection is active.

### Step 2: Clone Dotfiles
Clone your repository into your home directory:

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Step 3: Run the Installer

Make sure the installer has execute permissions and run it as your **normal user** (never with `sudo` directly):

```bash
chmod +x install.sh
./install.sh
```

The interactive installer will provide options:
- **`[1] Full Installation`**: Creates a backup, installs all official + AUR packages, deploys dotfiles, copies wallpapers, sets up themes/dconf, and configures the default shell.
- **`[2] Deploy Dotfiles Only`**: Backs up existing configs and lets you choose between **Copy** or **Symlink**.
- **`[3] Install Packages Only`**: Installs official packages via `pacman` and AUR packages via `yay`/`paru`.
- **`[4] Restore Previous Backup`**: Easily rolls back to your pre-install state.

### Unattended / Non-Interactive Mode
To run without interactive prompts:
```bash
./install.sh --noconfirm
```

---

## 📁 Repository Structure

```text
dotfiles/
├── .config/
│   ├── btop/                  # btop.conf + TokyoNight theme
│   ├── Code/                  # VS Code User/settings.json
│   ├── fastfetch/             # System fetch layout & modules
│   ├── featherpad/            # Lightweight text editor config
│   ├── ghostty/               # Ghostty terminal config
│   ├── gtk-3.0/ & gtk-4.0/    # GTK dark theme & font settings
│   ├── hypr/                  # Hyprland Lua modular configs
│   │   ├── hyprland.lua       # Main orchestrator
│   │   ├── autostart.lua      # Startup daemons (uwsm, waybar, etc.)
│   │   ├── keybinds.lua       # All keyboard & mouse shortcuts
│   │   ├── settings.lua       # Window styling, borders, blur, gaps
│   │   ├── animations.lua     # Window & workspace transition curves
│   │   ├── rules.lua          # Window & layer rules
│   │   ├── monitors.lua       # Display layout & scaling
│   │   ├── hyprpaper.conf     # Wallpaper daemon settings
│   │   ├── hyprlock.conf      # Lockscreen configuration
│   │   ├── hypridle.conf      # Idle timeouts & DPMS power saving
│   │   └── scripts/           # random_wall.sh wallpaper switcher
│   ├── kitty/                 # Kitty terminal config
│   ├── nwg-look/              # GTK settings exporter
│   ├── qalculate/             # Scientific calculator preferences
│   ├── starship.toml          # Custom Starship prompt layout
│   ├── systemd/user/          # Elephant daemon systemd user service
│   ├── Thunar/ & xfce4/       # File manager preferences & custom actions
│   ├── walker/                # Application launcher config
│   ├── waybar/                # Waybar config.jsonc & style.css
│   └── xsettingsd/            # X11 desktop setting daemon
├── .zshrc                     # Zsh configuration with plugins & history
├── .bashrc                    # Bash fallback configuration
├── .gtkrc-2.0                 # GTK2 theme configuration
├── assets/
│   └── wallpapers/            # High-res curated wallpapers
├── dconf/
│   └── dconf-settings.ini     # Exported desktop & theme preferences
├── packages/
│   ├── pacman-pkgs.txt        # Official Arch repository packages
│   ├── aur-pkgs.txt           # AUR packages (themes, walker, elephant)
│   └── apps-pkgs.txt          # Recommended productivity applications
├── scripts/
│   ├── backup.sh              # Creates timestamped backup in ~/.dotfiles_backup_*
│   ├── install_pkgs.sh        # Handles pacman & AUR package installation
│   ├── deploy_configs.sh      # Deploys configs, sets permissions & applies dconf
│   └── restore.sh             # Restores configs from previous backup
├── install.sh                 # Master installation script
├── .gitignore                 # Excludes logs, secrets, and caches
├── LICENSE                    # MIT License
└── README.md                  # This documentation
```

---

## 🔒 Security & Privacy Verified

This repository has been sanitized:
- **No private keys or tokens**: Stripped KeeShare private RSA keys, browser session cookies, and electron caches.
- **No personal credentials**: Removed zoom IDs, MAC addresses, and private configuration files.
- **Portable paths**: All hardcoded username paths (`/home/<user>`) have been dynamically converted to portable `$HOME` references.

---

## 🛠️ Post-Installation & Customization

1. **Monitor Setup**: Edit `~/.config/hypr/monitors.lua` to adjust display resolution, refresh rate, and scaling factor for your specific hardware.
2. **Wallpapers**: Place any extra wallpapers into `~/Pictures/Wallpapers/` and press `Super + Shift + W` to shuffle them.
3. **Default Apps**: Adjust default web browser or terminal in `~/.config/hypr/keybinds.lua` and `~/.config/mimeapps.list`.

---

## 📜 License
Distributed under the [MIT License](file:///home/asf/anti/dotfiles/LICENSE).
