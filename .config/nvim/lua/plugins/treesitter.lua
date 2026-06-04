-- Configuración de nvim-treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "markdown",
        "python",
    },

    highlight = {
        enable = true,
    },

    incremental_selection = {
        enable = true,
    },
})
