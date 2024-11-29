-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set(
    "n",
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true }
)
vim.keymap.set(
    "n",
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true }
)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- ----------------------------------------------------------------------------- CHELESCOPE
-- Buscar Texto en el Proyecto
vim.keymap.set(
    "n",
    "<leader>sg",
    require("telescope.builtin").live_grep,
    { desc = "[S]earch by [G]rep" }
)

-- Buscar Símbolos en el Proyecto
vim.keymap.set(
    "n",
    "<leader>ss",
    require("telescope.builtin").lsp_document_symbols,
    { desc = "[S]earch [S]ymbols" }
)
vim.cmd([[
    " Habilitar autocompletado automático en la línea de comandos
    set wildmenu
    set wildmode=longest:full,full

    " Navegar con las flechas
    cnoremap <Down> <C-n>
    cnoremap <Up> <C-p>


]])
-- vim.keymap.set(
--     "n",
--     "<leader>sp",
--         require("telescope.builtin").project,
--     { desc = "[S]Search th:is shite [P]rojekt" }
-- )





--------------------------------------------------------------------------- ALT D PARA COMENTAR
-- Modo normal: Alternar comentario en la línea actual
vim.keymap.set("n", "<M-d>", function()
    require('Comment.api').toggle.linewise.current()
end, { desc = "Toggle comment on current line" })

-- Modo visual: Emular el comportamiento de 'gc'
vim.keymap.set("v", "<M-d>", function()
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false) -- Salir del modo visual
    require('Comment.api').toggle.linewise(vim.fn.visualmode()) -- Toggle linewise for selected block
end, { desc = "Toggle comment on selected lines" })
