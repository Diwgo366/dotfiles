-- Configuración de nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require('nvim-tree').setup({
  sort = {
    sorter = 'case_sensitive',
  },

  view = {
    width = 25,
  },

  renderer = {
    group_empty = true,
  },

  filters = {
    dotfiles = true,
  }
})

-- Keybindings
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
