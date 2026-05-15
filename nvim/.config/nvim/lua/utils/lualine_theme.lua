local colors = require('utils.colors')

local lualine_theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.current_line },
    c = { fg = colors.fg },
    x = { fg = colors.fg, bg = colors.current_line },
    y = { fg = colors.fg, bg = colors.current_line },
    z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.current_line },
    c = { fg = colors.fg },
    x = { fg = colors.fg, bg = colors.current_line },
    y = { fg = colors.fg, bg = colors.current_line },
    z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.current_line },
    c = { fg = colors.fg },
    x = { fg = colors.fg, bg = colors.current_line },
    y = { fg = colors.fg, bg = colors.current_line },
    z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.current_line },
    c = { fg = colors.fg },
    x = { fg = colors.fg, bg = colors.current_line },
    y = { fg = colors.fg, bg = colors.current_line },
    z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
  },
  command = {
    a = { fg = colors.bg, bg = colors.orange, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.current_line },
    c = { fg = colors.fg },
    x = { fg = colors.fg, bg = colors.current_line },
    y = { fg = colors.fg, bg = colors.current_line },
    z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
  },
  terminal = {
    a = { fg = colors.bg, bg = colors.pink, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.current_line },
    c = { fg = colors.fg },
    x = { fg = colors.fg, bg = colors.current_line },
    y = { fg = colors.fg, bg = colors.current_line },
    z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
  },
  inactive = {
    a = { fg = colors.comment },
    b = { fg = colors.comment },
    c = { fg = colors.comment },
    x = { fg = colors.comment },
    y = { fg = colors.comment },
    z = { fg = colors.comment },
  },
}

return lualine_theme
