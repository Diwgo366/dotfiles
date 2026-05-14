local vim = vim
local Plug = vim.fn['plug#']

local plug_dir = vim.fn.expand('~/.local/share/nvim/site/plugged')

vim.call('plug#begin', plug_dir)

Plug('nvim-lualine/lualine.nvim')
Plug('dracula/vim')
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('romgrk/barbar.nvim')

vim.call('plug#end')

home = os.getenv('HOME')
package.path = home .. '/.config/nvim/?.lua;' .. package.path

require 'common'
require 'theme'
require 'vimtree'
require 'barbar'
require 'lua_line'

-- Treesitter es opcional
pcall(require, 'treesitter')

