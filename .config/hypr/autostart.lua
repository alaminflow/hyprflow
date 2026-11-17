-- ╔══════════════════════╗
-- ║      AUTOSTART       ║
-- ╚══════════════════════╝

hl.on("hyprland.start", function()
    -- Core Audio Services
    hl.exec_cmd("uwsm app -- systemctl --user start pipewire pipewire-pulse wireplumber")
    
    -- Auth & Security
    hl.exec_cmd("uwsm app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    
    -- Desktop Environment & Idle Management
    hl.exec_cmd("uwsm app -- hyprpaper")
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- swaync")
    
    -- Clipboard Daemons
    hl.exec_cmd("uwsm app -- wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
    
    -- System Tray & Extras
    hl.exec_cmd("uwsm app -- nm-applet --indicator")
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    

    -- udiskie for automounting removable media
    hl.exec_cmd("uwsm app -- udiskie &")
    -- Environment adjustments
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 20")
end)

    
