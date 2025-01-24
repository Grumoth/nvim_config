local actions = require("telescope.actions")
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<Tab>"] = actions.select_default,
            },
        },
        -- Detectar la raíz del proyecto basado en `project.godot` o `.git`
        file_ignore_patterns = { "node_modules", ".git" },
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden","-L", "--glob", "!.git/*" },
            follow = true,
            -- cwd = require("project_nvim").get_project_root(),
            -- cwd = require("projec"),
            -- cwd = require("project").get_project_root(),
        },
        colorscheme = {
            enable_preview = true
        }
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
        '-L',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--follow' -- Esta opción permite seguir enlaces simbólicos.
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        -- file_browser = {
        --   hijack_netrw = true,
        --   respect_gitignore = false,
        --   hidden = true, -- Mostrar archivos ocultos
        --   follow = true, -- Seguir enlaces simbólicos
        -- },
    },
}

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
----------------------------------------------------------------- BROWSER
-- Cargar la extensión del navegador de archivos
require("telescope").load_extension("file_browser")

local function search_project_files()
    local cwd = vim.fn.getcwd()
    local is_godot_project = vim.fn.filereadable(cwd .. "/project.godot") == 1
    local is_rust_project = vim.fn.filereadable(cwd .. "/Cargo.toml") == 1

    if is_godot_project then
        require("telescope.builtin").find_files {
            prompt_title = "Search .gd files in Project",
            find_command = {
                "rg",
                "--files",
                "--hidden",
                "--glob",
                "*.gd",
                "--glob",
                "!.git/*",
            },
        }
    elseif is_rust_project then
        require("telescope.builtin").find_files {
            prompt_title = "Search .rs files in Project",
            find_command = {
                "rg",
                "--files",
                "--hidden",
                "--glob",
                "*.rs",
                "--glob",
                "!.git/*",
            },
        }
    else
        require("telescope.builtin").find_files {
            prompt_title = "Search Files in Project",
            find_command = {
                "rg",
                "--files",
                "--hidden",
                "--glob",
                "!.git/*",
            },
        }
    end
end

vim.keymap.set("n", "<leader><space>", search_project_files, { desc = "[.] Search project files" })

-- Keymap para abrir el navegador de archivos
vim.keymap.set("n", "<leader>,", function()
    require("telescope").extensions.file_browser.file_browser {
        path = vim.fn.expand("%:p:h"), -- Usa la ruta del archivo actual como raíz
        cwd = vim.fn.expand("%:p:h"), -- Configura el directorio de trabajo
        hidden = true, -- Mostrar archivos oculto
        -- follow = true, -- Seguir enlaces simbólicos
        grouped = true, -- Agrupar carpetas primero
        respect_gitignore = false, -- Ignorar .gitignore
    }
end, { desc = "[,] File Browser" })


vim.keymap.set(
    "n","<leader>?",require("telescope.builtin").oldfiles,
    { desc = "[?] Find recently opened files" }
)
vim.keymap.set("n","<leader>.",
    require("telescope.builtin").buffers,
    { desc = "[ ] Find existing buffers" }
)




vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown {
            winblend = 10,
            previewer = false,
        }
    )
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set(
    "n",
    "<leader>sf",
    require("telescope.builtin").find_files,
    { desc = "[S]earch [F]iles" }
)
vim.keymap.set(
    "n",
    "<leader>sh",
    require("telescope.builtin").help_tags,
    { desc = "[S]earch [H]elp" }
)
vim.keymap.set(
    "n",
    "<leader>sw",
    require("telescope.builtin").grep_string,
    { desc = "[S]earch current [W]ord" }
)
vim.keymap.set(
    "n",
    "<leader>sg",
    require("telescope.builtin").live_grep,
    { desc = "[S]earch by [G]rep" }
)
vim.keymap.set(
    "n",
    "<leader>sd",
    require("telescope.builtin").diagnostics,
    { desc = "[S]earch [D]iagnostics" }
)



------------------------------------------------------------------------------
----------------------------------------------------------------- COMMANDS
vim.keymap.set("n", "<M-x>", function()
    require("telescope.builtin").commands({
        prompt_title = "Command Palette",
        attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            -- Mapear <CR> (Enter) para comportarse como Tab
            -- map("i", "<CR>", function(prompt_bufnr)
            --     local selection = action_state.get_selected_entry()
            --     if selection and selection.value then
            --         -- Completar la línea de comandos con el comando seleccionado
            --         vim.api.nvim_feedkeys(":" .. selection.value, "n", false)
            --     else
            --         vim.notify("No command selected", vim.log.levels.WARN)
            --     end
            --     actions.close(prompt_bufnr) -- Cierra Telescope
            -- end)

            -- -- Asegurarse de que Tab siga funcionando
            -- map("i", "<Tab>", actions.move_selection_next)

            return true
        end,
    })
end, { desc = "Fuzzy find commands and complete on Enter" })
----------------------------------------------------------------



--------------------------------------------------------------------- JSON  KEYS
vim.keymap.set('n', '<leader>fs', function()
    require('telescope.builtin').live_grep({
        prompt_title = "Search JSON keys",
        search_dirs = { vim.fn.expand('%:p') }, -- Buscar solo en el archivo actual
    })
end, { desc = "Buscar claves en JSON" })