-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd("colorscheme everforest")

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- Ajustar la posición de la ayuda de firma
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--     border = "rounded", -- Opcional: para bordes redondeados
--     focusable = false, -- La ventana no puede ser seleccionada
--     close_events = { "CursorMoved", "InsertCharPre" }, -- Cierra la ventana al mover el cursor
--     relative = "cursor", -- Relativo al cursor (puedes cambiar a 'editor' si prefieres fijo)
--     row = 2, -- Mueve hacia abajo 2 filas (ajusta según prefieras)
--     col = 0,
-- })
-- vim.keymap.set("i", "<M-s>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
--------------------------------------------------------------------------------------------------OPACIDAD POPUPS
-- vim.o.winblend = 85 -- Nivel de transparencia (ajusta entre 0 y 100)
-- vim.o.pumblend = 85 -- Transparencia para menús emergentes
