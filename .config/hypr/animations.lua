-- ╔══════════════════════╗
-- ║     ANIMATIONS       ║
-- ╚══════════════════════╝
hl.config({
    animations = {
        enabled = false,
        bezier = {
            { name = "instant",      p1x = 0.0,  p1y = 1.0,  p2x = 0.0,  p2y = 1.0  }, -- near-instant
            { name = "linear",       p1x = 0.0,  p1y = 0.0,  p2x = 1.0,  p2y = 1.0  },
            { name = "almostLinear", p1x = 0.5,  p1y = 1.0,  p2x = 0.5,  p2y = 1.0  },
        },
        animation = {
            { leaf = "windows",       enabled = true, speed = 20, curve = "instant",      style = "popin 95%" },
            { leaf = "windowsIn",     enabled = true, speed = 20, curve = "instant",      style = "popin 95%" },
            { leaf = "windowsOut",    enabled = true, speed = 20, curve = "instant",      style = "popin 95%" },
            { leaf = "windowsMove",   enabled = true, speed = 20, curve = "instant"                           },
            { leaf = "fade",          enabled = true, speed = 20, curve = "instant"                           },
            { leaf = "fadeIn",        enabled = true, speed = 20, curve = "instant"                           },
            { leaf = "fadeOut",       enabled = true, speed = 20, curve = "instant"                           },
            { leaf = "fadeLayersIn",  enabled = true, speed = 20, curve = "instant"                           },
            { leaf = "fadeLayersOut", enabled = true, speed = 20, curve = "instant"                           },
            { leaf = "workspaces",    enabled = true, speed = 20, curve = "instant",      style = "slide"     },
            { leaf = "workspacesIn",  enabled = true, speed = 20, curve = "instant",      style = "slide"     },
            { leaf = "workspacesOut", enabled = true, speed = 20, curve = "instant",      style = "slide"     },
            { leaf = "layers",        enabled = true, speed = 20, curve = "instant",      style = "popin 95%" },
            { leaf = "border",        enabled = true, speed = 20, curve = "linear"                            },
            { leaf = "borderangle",   enabled = true, speed = 20, curve = "linear"                            },
        }
    }
})