-- Importar las capacidades de cmp para el autocompletado
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Rutas a los servidores LSP (instalados manualmente)
local mason_path = os.getenv("HOME") .. "/.local/share/nvim/mason/bin"

-- Función auxiliar para encontrar root del proyecto
local function find_root(markers)
    local cwd = vim.fn.getcwd()
    for _, marker in ipairs(markers) do
        if vim.fn.findfile(marker, cwd .. ";") ~= "" then
            return vim.fn.fnamemodify(vim.fn.findfile(marker, cwd .. ";"), ":h")
        end
    end
    return cwd
end

-- Configurar cada servidor LSP manualmente con vim.lsp.start
local function setup_lsp()
    -- Lua LS
    vim.lsp.start({
        name = "lua_ls",
        cmd = { mason_path .. "/lua-language-server" },
        filetypes = { "lua" },
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
        root_dir = find_root({ ".git", ".lua-project" }),
    })
    
    -- Pyright
    vim.lsp.start({
        name = "pyright",
        cmd = { mason_path .. "/pyright-langserver", "--stdio" },
        filetypes = { "python" },
        capabilities = capabilities,
        root_dir = find_root({ ".git", "pyproject.toml", "setup.py" }),
    })
    
    -- Bash LS
    vim.lsp.start({
        name = "bashls",
        cmd = { mason_path .. "/bash-language-server", "start" },
        filetypes = { "bash", "sh" },
        capabilities = capabilities,
        root_dir = find_root({ ".git" }),
    })
end

-- Autocomando para iniciar LSP automáticamente
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("InitLsp", { clear = true }),
    callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        if filetype == "lua" or filetype == "python" or filetype == "bash" or filetype == "sh" then
            setup_lsp()
        end
    end,
})

-- Keymaps de LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
