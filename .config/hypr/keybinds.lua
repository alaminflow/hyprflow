-- ╔══════════════════════╗
-- ║      KEYBINDS        ║
-- ╚══════════════════════╝

-- Core Applications
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + E",      hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + B",      hl.dsp.exec_cmd("brave"))
hl.bind("SUPER + C",      hl.dsp.exec_cmd("code"))
hl.bind("SUPER + Space",  hl.dsp.exec_cmd("walker"))

-- Clipboard Management
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | walker --stdin | cliphist decode | wl-copy"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))

-- Wallpaper randomizer
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/random_wall.sh"))

-- Compositor Window Management Actions
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))

-- Structural Focus Switching
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "d" }))

-- Window Movement Map Controls
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

-- Hardware Pointer Controls (Mouse Bindings)
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Mouse Wheel Workspace Cycle
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))

-- Scratchpad Dropdownsnv
hl.bind("SUPER + S",       hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Dynamic Numeric Workspace Mapping (Loop iteration setup 1-9)
for i = 1, 9 do
    hl.bind("SUPER + " .. i,       hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Workspace 10 Definition
hl.bind("SUPER + 0",       hl.dsp.focus({ workspace = "10" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

-- =========================================================
-- THE FIXED SYSTEM HOOKS (UWSM Exit & Bulletproof Screen Off)
-- =========================================================

-- emergency escape
hl.bind("SUPER + CTRL + Escape", hl.dsp.exit())

-- The Ultimate Lock + DPMS Fix (with isolated shell delay)
--hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock & bash -c 'sleep 0.5 && hyprctl dispatch dpms off'"))
--hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock & bash -c 'sleep 0.5 && brightnessctl -s set 0%'"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))



-- =========================================================
-- HARDWARE MULTIMEDIA KEYS (Audio & Brightness)
-- =========================================================

-- Volume Controls (Using WirePlumber backend)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Audio Player Controls (Optional - tracks skips)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Display Brightness Controls (Using brightnessctl backend)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Pin window

hl.bind("SUPER + P", hl.dsp.window.pin({ action = "toggle" }))
