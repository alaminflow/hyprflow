-- ╔══════════════════════╗
-- ║    WINDOW RULES      ║
-- ╚══════════════════════╝
-- Verify classes/titles with:  hyprctl clients
-- Verify layer namespaces with: hyprctl layers

-- Floating utility windows
hl.window_rule({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" }, float = true, size = "800 500" })
hl.window_rule({ match = { class = "^(blueman-manager)$"      }, float = true, size = "700 500" })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = "^(file-roller)$"          }, float = true })
hl.window_rule({ match = { class = "^(swappy)$"               }, float = true })
hl.window_rule({ match = { class = "^(nwg-look)$"             }, float = true })
hl.window_rule({ match = { class = "^(kvantummanager)$"       }, float = true })
hl.window_rule({ match = { class = "^(thunar)$", title = "^(File Operation).*$" }, float = true })

-- Browser size (only affects floating windows). Brave's class is "brave-browser".
hl.window_rule({ match = { class = "^(chromium)$" }, size = "1200 750" })

-- Picture-in-Picture (Firefox: "Picture-in-Picture", Chromium/Brave: "Picture in picture")
hl.window_rule({
    name = "browser-pip",
    match = { title = "^([Pp]icture[- ]in[- ]picture)$" },
    float = true,
    pin = true,
    size = "480 270",
    move = { "monitor_w-window_w-20", "monitor_h-window_h-20" },
    keep_aspect_ratio = true,                  -- remove for freeform resizing
    opacity = "1.0 override 1.0 override",     -- ignore global inactive_opacity
})

-- Terminal opacity: active 1.0, inactive 0.90 (override global decoration opacity)
hl.window_rule({ match = { class = "^(kitty)$"   }, opacity = "1.0 override 0.90 override" })
hl.window_rule({ match = { class = "^(ghostty)$" }, opacity = "1.0 override 0.90 override" })
hl.window_rule({ match = { class = "^(neovide)$" }, opacity = "1.0 override" })

-- Layer rules (match on namespace, as a table)
hl.layer_rule({ match = { namespace = "^waybar$" }, blur = true })
hl.layer_rule({ match = { namespace = "^(swaync-control-center|swaync-notification-window)$" }, blur = true })
hl.layer_rule({ match = { namespace = "^walker$" }, blur = true })

-- Idle inhibit
hl.window_rule({ match = { class = "^(firefox)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^(mpv)$"     }, idle_inhibit = "focus" })
