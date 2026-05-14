local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('nvim-lualine/lualine.nvim')
Plug('dracula/vim')
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('romgrk/barbar.nvim')
Plug('neovim/nvim-lspconfig')
-- Plug('williamboman/mason.nvim')          -- Deshabilitado: usando binarios manuales
-- Plug('williamboman/mason-lspconfig.nvim') -- Deshabilitado: usando binarios manuales
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')

vim.call('plug#end')

home = os.getenv('HOME')
package.path = home .. '/.config/nvim/?.lua;' .. package.path

require 'common'
require 'theme'
require 'vimtree'
require 'barbar'
require 'lua_line'
require 'lsp'

-- Cargar cmp de forma diferida para evitar problemas de carga
vim.defer_fn(function()
    require 'cmp'
end, 100)
