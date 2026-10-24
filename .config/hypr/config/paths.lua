
local home = os.getenv("HOME")
local hypr = home .. "/.config/hypr"

return {
  home = home,
  hypr = hypr,
  scripts = hypr .. "/scripts",
  agsbar = home .. "/Proyectos/ags",
}
