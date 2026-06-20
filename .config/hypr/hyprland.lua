--[[
  Hyprland config — main
  Includes: environment, input, autostart, window rules, keybinds
--]]

-- Environment
hl.env("GTK_THEME", "Papirus")
hl.env("GTK_ICON_THEME", "Papirus")

-- Input
hl.config({
  input = {
    kb_layout = "latam",
    kb_variant = "",
    kb_model = "pc105",
    kb_options = "terminate:ctrl_alt_bspc",
    numlock_by_default = true,
    follow_mouse = 1,
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
    },
  },
})

-- Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("~/.config/hypr/scripts/wallpaper.sh")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal --replace")
  hl.exec_cmd("ags run /home/diego/Proyectos/ags/proyecto.js")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)

-- Window rules
hl.window_rule({
  match = { class = "^(spotify)$" },
  workspace = 10,
})

-- Variables
local mainMod = "SUPER"
local terminal = "/home/diego/.local/bin/ws-run kitty"
local fileManager = "/home/diego/.local/bin/ws-run thunar"
local menu = "~/.config/hypr/scripts/wofi.sh"
local clipboard = "~/.config/hypr/scripts/cliphist.sh"

-- Program binds
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-ags.sh"))

-- Focus movement
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Workspace switching
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd("~/.config/hypr/scripts/workspace10.sh"))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize windows
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -40, y = 0 }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 40, y = 0 }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -40 }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 40 }))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh down"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh mute"), { locked = true })
hl.bind("F3", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh up"), { repeating = true, locked = true })
hl.bind("F2", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh down"), { repeating = true, locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh clipboard"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh file"))

-- Include GUI/appearance config
dofile("/home/diego/Dotfiles/.config/hypr/hyprland-gui.lua")
