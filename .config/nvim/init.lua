local vim = vim
local Plug = vim.fn['plug#']

local plug_dir = vim.fn.expand('~/.local/share/nvim/site/plugged')

-- Plugins
vim.call('plug#begin', plug_dir)

Plug('nvim-lualine/lualine.nvim')
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('romgrk/barbar.nvim')

vim.call('plug#end')

-- Setup Lua path
home = os.getenv('HOME')
package.path = home .. '/.config/nvim/lua/?.lua;' .. package.path

-- Cargar configuración
require 'config.theme'
require 'config.common'
require 'config.keymaps'

-- Cargar plugins
require 'plugins.nvim-tree'
require 'plugins.barbar'
require 'plugins.lualine'

-- Treesitter es opcional
pcall(require, 'plugins.treesitter')
