-- ╔══════════════════════╗
-- ║  SETTINGS / LOOK     ║
-- ╚══════════════════════╝

hl.config({
    general = {
        gaps_in              = 1,
        gaps_out             = 2,
        border_size          = 2,
        col = {
            active_border    = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
            inactive_border  = { colors = { "rgba(3b4261aa)" } },
        },
        resize_on_border     = true,
        allow_tearing        = false,
        layout               = "dwindle",
    },
    xwayland = {
        force_zero_scaling = true,
    },

    decoration = {
        rounding             = 0,
        active_opacity       = 1.0,
        inactive_opacity     = 0.92,

        shadow = {
            enabled          = true,
            range            = 16,
            render_power     = 3,
            color            = "rgba(1a1b2699)",
        },

        blur = {
            enabled          = true,
            size             = 6,
            passes           = 3,
            xray             = false,
            noise            = 0.02,
            contrast         = 1.0,
            brightness       = 0.85,
            vibrancy         = 0.2,
        },
    },

    dwindle = {
        preserve_split       = true,
        smart_split          = false,
    },

    master = {
        new_status           = "master",
        mfact                = 0.55,
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
        focus_on_activate        = false,
    },

    -- FIXED: vfr has its own primary table scope block
    --render = {
    --  vfr = true,
    --}
})