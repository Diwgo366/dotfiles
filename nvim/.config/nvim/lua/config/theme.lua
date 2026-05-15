local colors = require('utils.colors')
require('utils.highlight')

vim.opt.termguicolors = true

vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight FoldColumn guibg=NONE ctermbg=NONE
  highlight StatusLine guibg=NONE ctermbg=NONE
  highlight StatusLineNC guibg=NONE ctermbg=NONE
  highlight TabLineFill guibg=NONE ctermbg=NONE
  highlight BufferLineFill guibg=NONE ctermbg=NONE
]])

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 4
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = ''

return {}
