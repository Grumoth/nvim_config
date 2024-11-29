require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
        -- Detectar la raíz del proyecto basado en `project.godot` o `.git`
        file_ignore_patterns = { "node_modules", ".git" },
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
            -- cwd = require("project_nvim").get_project_root(),
            -- cwd = require("projec"),
            -- cwd = require("project").get_project_root(),
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set(
    "n",
    "<leader>?",
    require("telescope.builtin").oldfiles,
    { desc = "[?] Find recently opened files" }
)
vim.keymap.set(
    "n",
    "<leader><space>",
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


vim.keymap.set("n", "<leader>.", function()
    require("telescope.builtin").find_files({
        prompt_title = "Search .gd files in Project",
        find_command = { "rg", "--files", "--hidden", "--glob", "*.gd", "--glob", "!.git/*" },
    })
end, { desc = "[.] Search .gd files in project" })
