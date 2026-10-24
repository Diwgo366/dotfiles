-- Keybinds
local paths = dofile(os.getenv("HOME") .. "/.config/hypr/config/paths.lua")
local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "thunar"
local menu = paths.scripts .. "/ui/wofi.sh"
local clipboard = paths.scripts .. "/ui/cliphist.sh"

-- Program binds
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(paths.scripts .. "/ui/toggle-ags.sh"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("ags toggle theme-selector"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(paths.scripts .. "/system/toggle-monitor-mode.sh"))

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
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd(paths.scripts .. "/workspace/workspace10.sh"))
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
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(paths.scripts .. "/media/volume.sh up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(paths.scripts .. "/media/volume.sh down"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(paths.scripts .. "/media/volume.sh mute"), { locked = true })
hl.bind("F3", hl.dsp.exec_cmd(paths.scripts .. "/media/brightness.sh up"), { repeating = true, locked = true })
hl.bind("F2", hl.dsp.exec_cmd(paths.scripts .. "/media/brightness.sh down"), { repeating = true, locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd(paths.scripts .. "/screenshots/screenshot.sh clipboard"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(paths.scripts .. "/screenshots/screenshot.sh file"))