local M = {}

M.setup = function(use)
    -- Lista de temas para instalar
    use { "gruvbox-community/gruvbox" } -- Gruvbox
    use { "folke/tokyonight.nvim" } -- Tokyo Night
    use { "dracula/vim", as = "dracula" } -- Dracula
    use { "shaunsingh/nord.nvim" } -- Nord
    use { "rose-pine/neovim", as = "rose-pine" } -- Rose Pine
    -- use { "catppuccin/nvim", as = "catppuccin" } -- Catppuccin
    use {
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- Opciones: latte, frappe, macchiato, mocha
                transparent_background = true,
            })
        end,
    }
end
vim.g.tokyonight_style = "storm" -- Opciones: "storm", "night", "day"
vim.g.tokyonight_transparent = true -- Transparencia

vim.g.gruvbox_contrast_dark = "hard" -- Opciones: "soft", "medium", "hard"
vim.g.gruvbox_invert_selection = false





vim.cmd("colorscheme catppuccin")
return M
