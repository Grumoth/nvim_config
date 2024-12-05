--#########################################
--############# FORMAT JSON
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.json",
    callback = function()
        vim.cmd("%!jq .") -- Ejecuta jq para formatear el JSON
    end,
    desc = "Autoformat JSON on open with jq",
})

--#########################################
-- automatically source and re-compile packer whenever you save this init.lua
local packer_augroup = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
    group = packer_augroup,
    pattern = vim.fn.expand("$MYVIMRC"),
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_augroup =
    vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_augroup,
    pattern = "*",
})
-- -- CONTROLAR LA JUGADA DE SPLITEAR AUTOMÁTICAMENTE EN V O EN H
-- vim.api.nvim_create_autocmd("BufReadPost", {
--     pattern = "*.gd", -- Ajusta el patrón si necesitas otros archivos
--     callback = function()
--         local current_win_count = #vim.api.nvim_tabpage_list_wins(0) -- Número de ventanas actuales

--         if current_win_count == 1 then
--             -- Si solo hay una ventana, divide verticalmente
--             vim.cmd("vsp")
--         elseif current_win_count == 2 then
--             -- Si ya hay dos ventanas, divide horizontalmente
--             vim.cmd("sp")
--         else
--             -- Si hay más de dos ventanas, enfoca la última
--             vim.cmd("wincmd p")
--         end

--         -- Opcional: Ajusta el tamaño del nuevo pane
--         vim.cmd("resize 20") -- Ajusta el tamaño vertical
--     end,
--     desc = "Dynamic pane splitting for GDScript files",
-- })
