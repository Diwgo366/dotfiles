-- Manual appearance configuration
local paths = dofile(os.getenv("HOME") .. "/.config/hypr/config/paths.lua")
local theme = dofile(paths.hypr .. "/config/theme.lua")

-- Cursor
hl.env("XCURSOR_THEME", "Future-cursors-cyan")
hl.env("XCURSOR_SIZE", "24")

-- Settings
hl.config({
  animations = {
    enabled = true,
  },
  decoration = {
    active_opacity = theme.active_opacity,
    blur = {
      enabled = false,
    },
    inactive_opacity = theme.inactive_opacity,
    rounding = 10,
    shadow = {
      enabled = false,
    },
  },
  general = {
    border_size = 2,
    col = {
      active_border = theme.active_border,
      inactive_border = theme.inactive_border,
    },
    gaps_out = theme.outer_gap,
    layout = "master",
  },
  master = {
    mfact = 0.65,
    new_status = "slave",
    new_on_top = false,
    orientation = "left",
  },
})

-- Animations
hl.animation({
  leaf = "global",
  enabled = false,
})
hl.animation({
  leaf = "windowsIn",
  enabled = true,
  speed = 8.0,
  bezier = "default",
  style = "popin",
})
hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = 8.0,
  bezier = "default",
  style = "popin",
})
hl.animation({
  leaf = "windowsMove",
  enabled = true,
  speed = 8.0,
  bezier = "default",
})
hl.animation({
  leaf = "layersIn",
  enabled = true,
  speed = 8.0,
  bezier = "default",
  style = "slide top",
})
hl.animation({
  leaf = "layersOut",
  enabled = true,
  speed = 8.0,
  bezier = "default",
  style = "slide top",
})
hl.animation({
  leaf = "fade",
  enabled = true,
  speed = 1.0,
  bezier = "default",
})
hl.animation({
  leaf = "fadeIn",
  enabled = true,
  speed = 8.0,
  bezier = "default",
})
hl.animation({
  leaf = "fadeOut",
  enabled = true,
  speed = 8.0,
  bezier = "default",
})
hl.animation({
  leaf = "fadeLayersIn",
  enabled = true,
  speed = 8.0,
  bezier = "default",
})
hl.animation({
  leaf = "fadeLayersOut",
  enabled = true,
  speed = 8.0,
  bezier = "default",
})
hl.animation({
  leaf = "border",
  enabled = true,
  speed = 10.0,
  bezier = "default",
})
hl.animation({
  leaf = "borderangle",
  enabled = true,
  speed = 1.0,
  bezier = "default",
})
hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 6.0,
  bezier = "default",
  style = "slide",
})
hl.animation({
  leaf = "zoomFactor",
  enabled = false,
})
hl.animation({
  leaf = "monitorAdded",
  enabled = true,
  speed = 1.0,
  bezier = "default",
})
