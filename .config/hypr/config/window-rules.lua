-- Window rules
local paths = dofile(os.getenv("HOME") .. "/.config/hypr/config/paths.lua")
local theme = dofile(paths.hypr .. "/config/theme.lua")
local pip_width = 320
local bar_height = 54

-- Workspace placement
hl.window_rule({
  match = { class = "^(Spotify|spotify)$" },
  workspace = "10 silent",
})

-- Application behavior
hl.window_rule({
  match = { class = "^(kitty)$" },
  suppress_event = "maximize",
})

hl.window_rule({
  match = { class = "^(wofi)$" },
  stay_focused = true,
  suppress_event = "change_focused",
})

-- Dialogs and utility windows
hl.window_rule({
  match = {
    class = "^(xdg-desktop-portal-gtk|xarchiver)$",
  },
  stay_focused = true,
  opaque = true,
  center = true,
  float = true,
  size = "700 500",
})

hl.window_rule({
  match = {
    class = "^Zotero$",
  },
  opaque = true,
  center = true,
  float = true,
  size = "700 500",
})

hl.window_rule({
  match = {
    class = "^Zotero$",
    title = "^.* - Zotero$",
  },
  opaque = false,
  tile = true,
})

hl.window_rule({
  match = {
    class = "^file-png$",
  },
  center = true,
  size = "700 500",
})

-- Browsers
hl.window_rule({
  match = {
    class = "^(firefox|chromium|google-chrome|brave-browser|brave-origin)$",
  },
  opaque = true,
})

hl.window_rule({
  match = {
    class = "^(firefox|chromium|google-chrome|brave-browser|brave-origin)$",
    title = "^Inicia Sesión:.*"
  },
  float = true,
  center = true,
  size = "700 500",
})

-- Opaque picture-in-picture windows
hl.window_rule({
  match = {
    title = "^(Pantalla en pantalla|Imagen en imagen)$",
  },
  opaque = true,
  float = true,
  size = "320 180",
  move = "monitor_w-" .. (pip_width + theme.outer_gap) .. " " .. (bar_height + theme.outer_gap),
})

-- Opaque image viewers
hl.window_rule({
  match = {
    class = "^(org[.]gnome[.]gThumb)$",
  },
  opaque = true,
})

hl.window_rule({
  match = {
    class = "^steam$",
  },
  center = true,
  float = true,
  opaque = true,
  size = "700 660",
})

hl.window_rule({
  match = {
    class = "^steam$",
    title = "^Steam$",
  },
  opaque = false,
  tile = true,
})

hl.window_rule({
  match = {
    class = "^com[.]pokemmo[.]PokeMMO$",
  },
  opaque = false,
})

-- Layer rules
hl.layer_rule({
  match = {
    namespace = "hyprpicker",
  },
  no_anim = true,
})
hl.layer_rule({
  match = {
    namespace = "mpvpaper",
  },
  no_anim = true,
})
hl.layer_rule({
  match = {
    namespace = "selection",
  },
  animation = "popin",
})
hl.layer_rule({
  match = {
    namespace = "ags-overlay",
  },
  no_anim = true,
})
