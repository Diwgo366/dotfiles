-- Definición de leader
vim.g.mapleader = ' '

-- Navegación entre buffers (pestañas)
vim.keymap.set('n', '<Tab>', ':BufferNext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':BufferPrevious<CR>', { silent = true })
vim.keymap.set('n', '<leader>q', ':BufferClose<CR>', { silent = true })
vim.keymap.set('n', '<leader>1', ':BufferGoto 1<CR>', { silent = true })
vim.keymap.set('n', '<leader>2', ':BufferGoto 2<CR>', { silent = true })
vim.keymap.set('n', '<leader>3', ':BufferGoto 3<CR>', { silent = true })
vim.keymap.set('n', '<leader>4', ':BufferGoto 4<CR>', { silent = true })
vim.keymap.set('n', '<leader>5', ':BufferGoto 5<CR>', { silent = true })

-- Navegación entre ventanas (editor / panel lateral / telescope)
vim.keymap.set('n', '<C-a>', '<C-w>h', { desc = 'Ir a ventana izquierda' })
vim.keymap.set('n', '<C-s>', '<C-w>l', { desc = 'Ir a ventana derecha' })

-- Nvim-tree toggle
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
