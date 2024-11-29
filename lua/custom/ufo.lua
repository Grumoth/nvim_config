-- Configuración básica para nvim-ufo
vim.o.foldenable = true            -- Habilitar plegado
vim.o.foldlevel = 99               -- Nivel de plegado inicial
vim.o.foldlevelstart = 99          -- Mantén todos los pliegues abiertos al iniciar
vim.o.foldmethod = 'expr'          -- Método de plegado basado en expresiones
vim.o.foldexpr = 'nvim_treesitter#foldexpr()' -- Usa Treesitter para plegar

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' } -- Usa Treesitter e indentación
    end
})