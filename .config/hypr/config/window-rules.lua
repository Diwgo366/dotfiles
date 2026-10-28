-- Window rules
local paths = dofile(os.getenv("HOME") .. "/.config/hypr/config/paths.lua")
local theme = dofile(paths.hypr .. "/config/theme.lua")
local pip_width = 320
local bar_height = 54

-- Música
-- Spotify
hl.window_rule({
  match = { class = "^(Spotify|spotify)$" },
  workspace = "10 silent",
})

-- Navegadores
-- Firefox, Chromium, Google Chrome y Brave
hl.window_rule({
  match = {
    class = "^(firefox|chromium|google-chrome|brave-browser|brave-origin)$",
  },
  opaque = true,
})

-- Diálogos de inicio de sesión de navegadores
hl.window_rule({
  match = {
    class = "^(firefox|chromium|google-chrome|brave-browser|brave-origin)$",
    title = "^Inicia Sesión:.*"
  },
  float = true,
  center = true,
  size = "700 500",
})

-- Ventanas picture-in-picture
hl.window_rule({
  match = {
    title = "^(Pantalla en pantalla|Imagen en imagen)$",
  },
  opaque = true,
  float = true,
  size = "320 180",
  move = "monitor_w-" .. (pip_width + theme.outer_gap) .. " " .. (bar_height + theme.outer_gap),
})

-- Documentos y productividad
-- Zotero
hl.window_rule({
  match = {
    class = "^Zotero$",
  },
  opaque = true,
  center = true,
  float = true,
  size = "700 500",
})

-- Documentos de Zotero
hl.window_rule({
  match = {
    class = "^Zotero$",
    title = "^.* - Zotero$",
  },
  opaque = false,
  tile = true,
})

-- Escritorio y utilidades
-- Kitty
hl.window_rule({
  match = { class = "^(kitty)$" },
  suppress_event = "maximize",
})

-- Wofi
hl.window_rule({
  match = { class = "^(wofi)$" },
  stay_focused = true,
  suppress_event = "change_focused",
})

-- Portales por nombre
hl.window_rule({
  match = {
    title = "^(Renombrar.*)$",
  },
  stay_focused = true,
  opaque = true,
  center = true,
  float = true,
  size = "700 500",
})

-- Portales por clase
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

-- Visor file-png
hl.window_rule({
  match = {
    class = "^file-png$",
  },
  center = true,
  size = "700 500",
})

-- gThumb
hl.window_rule({
  match = {
    class = "^(org.gnome.gThumb)$",
  },
  opaque = true,
})

-- Juegos
-- Steam
hl.window_rule({
  match = {
    class = "^steam$",
  },
  center = true,
  float = true,
  opaque = true,
  size = "700 660",
})

-- Ventana Steam
hl.window_rule({
  match = {
    class = "^steam$",
    title = "^Steam$",
  },
  opaque = false,
  tile = true,
})

-- PokeMMO
hl.window_rule({
  match = {
    class = "^com.pokemmo.PokeMMO$",
  },
  opaque = true,
})

-- Diseño
-- Krita
hl.window_rule({
  match = {
	class = "^krita$",
  },
  opaque = true,
})

hl.window_rule({
  match = {
	class = "^krita$",
	initial_title = "^Editor de pincel — Krita$",
  },
  float = true,
  center = true,
  size = "1100 500",
})


-- Hyprpicker
hl.layer_rule({
  match = {
    namespace = "hyprpicker",
  },
  no_anim = true,
})

-- mpvpaper
hl.layer_rule({
  match = {
    namespace = "mpvpaper",
  },
  no_anim = true,
})

-- Capa selection
hl.layer_rule({
  match = {
    namespace = "selection",
  },
  animation = "popin",
})

-- AGS overlay
hl.layer_rule({
  match = {
    namespace = "ags-overlay",
  },
  no_anim = true,
})

-- Dunst: las notificaciones entran desde la derecha hacia la izquierda.
hl.layer_rule({
  match = {
    namespace = "notifications",
  },
  animation = "slide right",
})
