local configDir = os.getenv("HOME") .. "/.config/hypr/config"
local paths = dofile(configDir .. "/paths.lua")

-- Environment
hl.env("GTK_THEME", "Tokyonight-BL-LB-Dark")
hl.env("GTK_ICON_THEME", "Papirus")
hl.env("AGS_DIR", paths.agsbar)

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
	hl.exec_cmd("/usr/lib/xdg-desktop-portal --replace")
	-- AGS usa su propio CSS; Adwaita como base evita que herede el tema GTK global.
	hl.exec_cmd('env GTK_THEME=Adwaita ags run "$AGS_DIR/src/app.ts"')
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)

dofile(configDir .. "/input.lua")
dofile(configDir .. "/window-rules.lua")
dofile(configDir .. "/keybinds.lua")
dofile(configDir .. "/appearance.lua")
