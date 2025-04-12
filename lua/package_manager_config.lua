-- [[ Configure Lualine ]]
-- Inicia nvim-autopairs
require("nvim-autopairs").setup {
    -- Configuraciones opcionales
    disable_filetype = { "TelescopePrompt", "vim" }, -- Deshabilitar en ciertos tipos de archivo
}

-- Integrar con nvim-cmp si usas un completador
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- See `:help lualine`
require("lualine").setup {
    options = {
        icons_enabled = true,
        theme = "everforest",
        component_separators = "|",
        section_separators = "",
    },
}

-- [[ Configure Comment.nvim ]]
-- See `:help comment-nvim`
require("Comment").setup()

-- [[ Configure indent-blankline.nvim ]]
-- See `:help indent_blankline`
-- require("indent_blankline").setup {
--     char = "┊",
--     show_trailing_blankline_indent = false,
-- }
require("ibl").setup()
-- [[ Configure Gitsigns ]]
-- See `:help gitsigns`
require("gitsigns").setup {
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
-- require("telescope").setup {
--     defaults = {
--         mappings = {
--             i = {
--                 ["<C-u>"] = false,
--                 ["<C-d>"] = false,
--             },
--         },
--     },
--
-- }


-- [[ Configure Treesitter ]]
-- See `:help which-key.nvim`
require("which-key").setup()

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup {
    -- Add languages to be installed here that you want installed for treesitter
    -- Uncomment other languagues if needed
    -- build: ':TSUpdate',
    ignore_install = { "help" },
    ensure_installed = {
        "c",
        "cpp",
        "rust",
        "glsl",
        "c_sharp",
        "gdscript",
        "lua",
        "help",
        "vim",
        'json',
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = nil,
            node_incremental = nil,

            -- init_selection = "<c-space>",
            -- node_incremental = "<c-space>",
            -- scope_incremental = "<c-s>",
            -- node_decremental = "<c-backspace>",
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
}

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don"t have to repeat yourself
    -- many times.
    -----------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------
    -- **Integrar lsp_signature.nvim**
    require("lsp_signature").on_attach({
        bind = true,
        handler_opts = {
            border = "rounded",
        },
    }, bufnr)
    -----------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap(
        "gr",
        require("telescope.builtin").lsp_references,
        "[G]oto [R]eferences"
    )
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap(
        "<leader>ds",
        require("telescope.builtin").lsp_document_symbols,
        "[D]ocument [S]ymbols"
    )
    nmap(
        "<leader>ws",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        "[W]orkspace [S]ymbols"
    )

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap(
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        "[W]orkspace [A]dd Folder"
    )
    nmap(
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        "[W]orkspace [R]emove Folder"
    )
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")
end

-- Enable the following language servers
--  feel free to add/remove any lsps that you want here. they will automatically be installed.
--  add any additional override configuration in the following tables. they will be passed to
--  the `settings` field of the server config. you must look up that documentation yourself.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},

    gdscript = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

local ensure_installed_servers = { "lua_ls","jsonls" }

-- [[ Configure null-ls ]]
local null_ls = require("null-ls")

local lsp_format = function(bufnr)
    vim.lsp.buf.format {
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    }
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local null_ls_on_attach = function(client, bufnr)
    if not client.supports_method("textDocument/formatting") then
        return
    end

    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
            lsp_format(bufnr)
        end,
    })
end

null_ls.setup {
    on_attach = null_ls_on_attach,
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gdformat,
    },
}

-- [[ Configure Neodev ]]
require("neodev").setup()

-- [[ Configure Cmp (1) ]]
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- [[ Configure Mason / Mason-LSPconfig ]]
-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
mason_lspconfig.setup {
    ensure_installed = ensure_installed_servers,
}
lspconfig.jsonls.setup {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(), -- Opcional: auto-esquemas
            validate = { enable = true },
        },
    },
}

for server, opts in pairs(servers) do
    require("lspconfig")[server].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = opts,
    
    }
end

-- [[ Configure Cmp (2), Luasnip ]]
-- See `:help nvim-cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
}
----------------------------------------------------------------------------
----------------------------------------------------------------------------
cmp.setup.filetype("gd", {
    sources = {
        { name = "buffer" },
        { name = "path" },
    },
})
-- local setup_godot_dap = function()
--     local dap = require("dap")

--     dap.adapters.godot = {
--         type = "server",
--         host = "127.0.0.1",
--         port = 6006, -- Puerto por defecto para el debugger de Godot
--     }

--     dap.configurations.gdscript = {
--         {
--             type = "godot",
--             request = "launch",
--             name = "Launch Godot Game with DAP",
--             project = "${workspaceFolder}", -- Ruta al proyecto
--             launch_options = {
--                 executable = "/home/kike/APPS/Godot_v4.4-dev6_linux.x86_64", -- Ruta al ejecutable de Godot
--                 args = { "--remote-debug", "127.0.0.1:6006" }, -- Habilitar el modo DAP
--             },
--         },
--     }
-- end
-- OLD DAP
local setup_godot_dap = function()
    -- local dap = require("dap")

    -- dap.adapters.godot = {
    --     type = "server",
    --     host = "127.0.0.1",
    --     port = 6006,
    -- }

    -- dap.configurations.gdscript = {
    --     {
    --         launch_game_instance = false,
    --         launch_scene = true,
    --         name = "Launch scene",
    --         project = "${workspaceFolder}",
    --         request = "launch",
    --         type = "godot",
    --     },
    -- }
end

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- [[ Configure project.nvim ]]
require("project_nvim").setup {
    -- **Configurar los patrones para detectar la raíz del proyecto**
    detection_methods = { "pattern" }, -- "pattern" o "lsp"
    patterns = { ".git", "project.godot", ".svn", "Makefile", "package.json" },
    -- Directorios donde buscar proyectos
    silent_chdir = false, -- Cambiar el directorio de trabajo de Neovim automáticamente
    ignore_lsp = {}, -- No ignorar ningún servidor LSP
    -- Puedes añadir más configuraciones según tus necesidades
}
-- **Configuración de lsp_signature.nvim**
require("lsp_signature").setup {
    bind = true, -- Usar los mapeos de <C-x> para cerrar la ventana
    handler_opts = {
        border = "rounded", -- Estilo de borde de la ventana flotante
    },
    hint_enable = true,
    floating_window = true,
    floating_window_above_cur_line = true,
    fix_pos = true,
    -- Puedes agregar más opciones según tus preferencias
}
require("luasnip.loaders.from_lua").load {
    paths = "~/.config/nvim/lua/user/snippets/",
}
----------------------------------------------------------------------------
----------------------------------------------------------------------------
setup_godot_dap()


-- ---------------------------- INLAYS RUST
-- require("rust-tools").setup({
--     server = {
--         on_attach = function(_, bufnr)
--             -- Mapea <leader>ih para alternar hints
--             vim.keymap.set("n", "<leader>ih", require("rust-tools.inlay_hints").toggle_inlay_hints, { buffer = bufnr })
--         end,
--     },
--     tools = {
--         inlay_hints = {
--             auto = true, -- Desactiva inlay hints automáticos
--         },
--     },
-- })
vim.g.rustaceanvim = {
  server = {
    settings = {
      ["rust-analyzer"] = {
        inlayHints = {
          bindingModeHints = {
            enable = false,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = {
            enable = "never",
          },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = {
            enable = true,
          },
          reborrowHints = {
            enable = "never",
          },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  },
}
require("lspconfig").rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "never",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
    }
  }
})
require("lspconfig").clangd.setup({
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
    on_attach = function(client, bufnr)
        -- Activar formateo automático al guardar
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,
})