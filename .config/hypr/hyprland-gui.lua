--[[
  Hyprland config — GUI / appearance
  Generated reference for Hyprland settings
  Contains: environment, visuals, animations, layer rules, window rules
--]]

-- Environment
hl.env("XCURSOR_THEME", "Future-cyan-cursors")
hl.env("XCURSOR_SIZE", "24")

-- Visual settings
hl.config({
  decoration = {
    active_opacity = 0.9,
    inactive_opacity = 0.9,
    rounding = 10,
    blur = {
      contrast = 0.9,
      enabled = false,
      ignore_opacity = false,
      new_optimizations = true,
      noise = 0.015,
      passes = 1,
      size = 1,
      vibrancy = 0.1,
    },
    shadow = {
      color = "0xff0d315a",
      color_inactive = "0xff000000",
      enabled = false,
      range = 3,
      render_power = 2,
    },
  },
  general = {
    border_size = 2,
    col = {
      active_border = { colors = { "0xfff8f8f2" }, angle = 0 },
      inactive_border = "0xff7a7a7a",
    },
    gaps_out = 10,
    layout = "master",
  },
  input = {
    sensitivity = 1.0,
  },
  master = {
    mfact = 0.5,
    new_status = "slave",
  },
})

-- Bezier curves
hl.config({
  bezier = {
    easeInSine = { 0.12, 0.0, 0.39, 0.0 },
  },
})

-- Animations
hl.config({
  animations = { enabled = true },
})

hl.animation({ leaf = "global", enabled = false })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 8.0, bezier = "default", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8.0, bezier = "default", style = "popin" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 8.0, bezier = "default" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 8.0, bezier = "default", style = "slide top" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 8.0, bezier = "default", style = "slide top" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.0, bezier = "default" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 8.0, bezier = "default" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 8.0, bezier = "default" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 8.0, bezier = "default" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 8.0, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 1.0, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1.0, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6.0, bezier = "default", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = false })
hl.animation({ leaf = "monitorAdded", enabled = true, speed = 1.0, bezier = "default" })

-- Layer rules
hl.layer_rule({
  match = { namespace = "hyprpicker" },
  no_anim = true,
})

hl.layer_rule({
  match = { namespace = "selection" },
  animation = "popin",
})

hl.layer_rule({
  match = { namespace = "overlay" },
  animation = "fade",
})

-- Window rules
hl.window_rule({
  match = { class = "^(brave-browser)$" },
  opaque = true,
})

hl.window_rule({
  match = { class = "^(wofi)$" },
  stay_focused = true,
})

hl.window_rule({
  match = { class = "^(wofi)$" },
  suppress_event = "change_focused",
})

hl.window_rule({
  match = { class = "^(firefox)$" },
  opaque = true,
})

hl.window_rule({
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  size = { 700, 500 },
  center = true,
})

hl.window_rule({
  match = { class = "^$" },
  no_blur = true,
})

hl.window_rule({
  match = { class = "^(xarchiver)$" },
  float = true,
  size = { 700, 500 },
  center = true,
})
