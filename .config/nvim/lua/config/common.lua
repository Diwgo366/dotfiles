-- Configuración general de Neovim
vim.wo.number = true
vim.g.mouse = 'a'
vim.cmd('syntax enable')
vim.opt.showcmd = true
vim.opt.encoding = 'utf-8'
vim.opt.showmatch = true
vim.opt.swapfile = false
vim.opt.termguicolors = true

-- Desplazamiento y indentación
vim.opt.scrolloff = 7
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

-- Formato de archivo
vim.opt.fileformat = "unix"
