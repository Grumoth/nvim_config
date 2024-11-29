vim.keymap.set('n', '<leader>nb', function()
    require('nvim-navbuddy').open()
end, { desc = "Abrir navegador de estructura JSON" })