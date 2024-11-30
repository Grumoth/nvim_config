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
--------------------------------------------------------------------------- GUARDAR
-- Ctrl+s para guardar el buffer actual
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true, desc = "Save current buffer" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true, desc = "Save current buffer in insert mode" })

-- Ctrl+Shift+s para guardar todos los buffers
vim.keymap.set("n", "<C-S-s>", ":wa<CR>", { noremap = true, silent = true, desc = "Save all buffers" })
vim.keymap.set("i", "<C-S-s>", "<Esc>:wa<CR>a", { noremap = true, silent = true, desc = "Save all buffers in insert mode" })
--------------------------------------------------------------------------- MOVER LINEAS PARRIBA O PABAIXO
-- Mover líneas hacia abajo
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })

-- Mover bloques de código seleccionados hacia abajo o arriba en modo visual
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move block up" })
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

---------------------------------------------------------------------------    GODOT STUFF
-- vim.keymap.set("n", "<F5>", function()
--     print('fucking f5')
--     require("lua.godot.godot_launcher")._test()
-- end, { desc = "Run Godot game on second monitor" })
-- vim.keymap.set(
--     "n",
--     "<F5>",
--     require("godot.godot_launcher")._test()
--     -- require("telescope.builtin").lsp_document_symbols,
--     { desc = "[S]earch [S]ymbols" }
-- )
--
vim.keymap.set("n", "<F5>", function()
    vim.cmd(":wa")
    require("godot.godot_launcher").launch_game()
end, { desc = "Launch Godot in floating terminal" })
---------------------------------------------------------------------------- SHOW PARAM INFO

vim.keymap.set("i", "<C-k>", function()
    vim.lsp.buf.signature_help()
end, { desc = "Show function signature" })

---------------------------------------------------------------------------- QUICK EDIT

vim.keymap.set("n", "ge", function()
    require("custom.quick_edit").quick_edit()
end, { desc = "Quick edit function definition in floating window" })
---------------------------------------------------------------------------- LAZYGIT

vim.keymap.set("n", "<leader>g", function()
    -- local Terminal = require("toggleterm.terminal").Terminal
    -- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    vim.cmd(":LazyGit")
end, { desc = "Open LazyGit" })