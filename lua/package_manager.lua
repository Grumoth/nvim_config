local plugins_install_path = vim.fn.stdpath("data")
    .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false

-- `packer` is our package manager and it needs to be downloaded externally
-- before loading any plugin
local bootstrap_packer = function()
    if vim.fn.empty(vim.fn.glob(plugins_install_path)) > 0 then
        is_bootstrap = true
        vim.fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            plugins_install_path,
        }
        vim.cmd([[packadd packer.nvim]])
    end
end

bootstrap_packer()

-- for each package listed here, you can search on github for their
-- name to know more
require("packer").startup(function(use)
    --##############################################################
    ------------------------------------------------------------------- yorl de marras
    use { 
        "nvim-lualine/lualine.nvim", 
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "everforest",
                    section_separators = '',
                    component_separators = '',
                },
                sections = {
                    lualine_c = { "filename" }, -- Muestra el nombre del archivo en el centro
                },
            })
        end,
    }
    -- use { 
    --     "akinsho/bufferline.nvim", 
    --     requires = "nvim-tree/nvim-web-devicons", 
    --     config = function()
    --         require("bufferline").setup({
    --             options = {
    --                 diagnostics = "nvim_lsp", -- Muestra errores y advertencias de LSP
    --                 separator_style = "slant", -- Estilo visual de separación
    --                 show_close_icon = false,  -- Oculta el ícono de cerrar
    --                 offsets = {
    --                     { filetype = "NvimTree", text = "File Explorer", text_align = "center" }
    --                 },
    --             },
    --         })
    --     end,
    -- }
    -- use { "simrat39/rust-tools.nvim" }
    -- use {
    --     'mrcjkb/rustaceanvim',
    --     requires = { 'nvim-lua/plenary.nvim' },
    --     config = function()
    --         -- Configuración adicional si es necesaria
    --     end
    -- }
    use {
        "lvimuser/lsp-inlayhints.nvim",
        config = function()
            require("lsp-inlayhints").setup({
                commands = { enable = true },
                autocmd = {enable = true}
            })
        end
    }
    use { "anuvyklack/windows.nvim",
        requires = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim"
        },
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require('windows').setup()
        end
    }
    use {
       "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
        require("trouble").setup {}
    end,
}
    use("windwp/nvim-autopairs")
    use("ahmedkhalf/project.nvim")
    use 'kdheepak/lazygit.nvim'
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
    use { 
        'kevinhwang91/nvim-ufo',
        requires = 'kevinhwang91/promise-async'
    }
    use {
        'SmiteshP/nvim-navbuddy',
        requires = {
            'SmiteshP/nvim-navic',
            'MunifTanjim/nui.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('nvim-navbuddy').setup(
                {
                    lsp = {
                        auto_attach = true,
                    }
                }
            )
        end
    }

    require("custom.themes").setup(use)
    use "b0o/schemastore.nvim"
    --##################################################################
    -- package manger
    use { "wbthomason/packer.nvim" }

    -- lsp: language server protocol
    use { "folke/neodev.nvim" }
    use { "neovim/nvim-lspconfig" }
    use { "williamboman/mason-lspconfig.nvim" }
    use { "williamboman/mason.nvim" }
    -- use { "jose-elias-alvarez/null-ls.nvim" }

    -- dap: debug adapter protocol (debugger)
-- packer.nvim configuration

use {
    "nvim-neotest/nvim-nio",  -- Agrega nvim-nio como dependencia
}
use {
    "mfussenegger/nvim-dap",
    -- config = function()
    --     require("custom.dap_config").setup()
    -- end
}
use {
    "rcarriga/nvim-dap-ui",
    requires = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",  -- Dependencia de nvim-dap-ui
    },
}
use {
    "theHamsta/nvim-dap-virtual-text",
    requires = "mfussenegger/nvim-dap",
    config = function()
        require("nvim-dap-virtual-text").setup({
            enabled = true,
            show_logs = true,
        })
    end
}
    -- nvim-cmp: autocompletion
    use { "hrsh7th/nvim-cmp" }
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "L3MON4D3/LuaSnip" }
    use { "saadparwaiz1/cmp_luasnip" }
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use {
    "ray-x/lsp_signature.nvim",
    config = function()
        require("lsp_signature").setup({})
    end
    }
    -- use("ray-x/lsp_signature.nvim")
    -- treesitter: code highlighting
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update {
                with_sync = true,
            })
        end,
    }
    use { -- Additional text objects via treesitter
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
    }

    -- git
    use { "lewis6991/gitsigns.nvim" }
    use { "tpope/vim-fugitive" }
    use { "tpope/vim-rhubarb" }

    -- ui
    use("lukas-reineke/indent-blankline.nvim")
    -- use { "lukas-reineke/indent-blankline.nvim" } -- add indentation guides even on blank lines
    use { "numToStr/Comment.nvim" } -- "gc" to comment visual regions/lines
    -- use { "nvim-lualine/lualine.nvim" }
    use { "sainnhe/everforest" }
    use { "tpope/vim-sleuth" } -- detect tabstop and shiftwidth automatically

    -- telescope
    use { "nvim-telescope/telescope.nvim" }
    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        cond = vim.fn.executable("make") == 1,

        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim', -- Opcional: soporte FZF
            run = 'make'
    }
    }

    -- misc
    use { "nvim-lua/plenary.nvim" }
    use { "folke/which-key.nvim" }

    if is_bootstrap then
        require("packer").sync()
    end
end)

-- when we are bootstrapping a configuration, it doesn"t
-- make sense to execute the rest of the init.lua.
-- you"ll need to restart nvim, and then it will work.
if is_bootstrap then
    print("==================================")
    print("    plugins are being installed")
    print("    wait until packer completes,")
    print("       then restart nvim")
    print("==================================")
end

return is_bootstrap
