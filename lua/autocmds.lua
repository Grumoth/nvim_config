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
