-- Intentar cargar dracula, si no funciona usar el default
local ok, _ = pcall(vim.cmd, "colorscheme dracula")
if not ok then
    -- Usar colorscheme por defecto si dracula no está disponible
    vim.cmd("colorscheme default")
end

vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NormalNC guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

