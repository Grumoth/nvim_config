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
-------------------------------------------------------------------------- F5

-- Función para ejecutar un proyecto de Godot normal (sin tocar Rust)
local function run_godot_project()
    local cwd = vim.fn.getcwd()
    local godot_project = cwd .. "/project.godot"

    if vim.fn.filereadable(godot_project) == 1 then
        vim.notify("Ejecutando Godot...", vim.log.levels.INFO)
        require("godot.godot_launcher").launch_game()
    else
        vim.notify("No se encontró un proyecto de Godot.", vim.log.levels.WARN)
    end
end

local function run_godot_with_rust()
    local cwd = vim.fn.getcwd() -- Directorio actual
    local file_path = vim.fn.expand("%:p") -- Ruta completa del archivo actual

    -- Si el cwd ya está dentro de `rust/`, subimos un nivel para obtener la raíz del proyecto
    if cwd:match("/rust$") then
        cwd = cwd:gsub("/rust$", "") -- Elimina "/rust" al final para obtener la carpeta raíz
    end

    local rust_path = cwd .. "/rust"
    local cargo_toml = rust_path .. "/Cargo.toml"
    local godot_project = cwd .. "/godot/project.godot"

    -- Si estamos editando un archivo en rust/src/, compilar Rust en un pane de WezTerm
    if file_path:match(rust_path .. "/src/") and vim.fn.filereadable(cargo_toml) == 1 and vim.fn.filereadable(godot_project) == 1 then
        vim.notify("Compilando Rust en WezTerm...", vim.log.levels.INFO)

        local wezterm_cmd = string.format(
            "wezterm cli split-pane --bottom --percent 30 -- bash -c 'cd %s && cargo build && godot --path %s; exit'",
            rust_path, cwd .. "/godot"
        )

        local result = os.execute(wezterm_cmd)

        if result == 0 then
            vim.notify("Compilación y ejecución lanzadas en WezTerm.", vim.log.levels.INFO)
        else
            vim.notify("Error al lanzar WezTerm.", vim.log.levels.ERROR)
        end
    else
        vim.notify("No se detectó un proyecto válido de Rust+Godot.", vim.log.levels.WARN)
    end
end

local function run_c_project()
    local cwd = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(cwd, ":t") -- Nombre del proyecto (igual que la carpeta)

    -- Comando base para ejecutar el juego después de compilar
    local run_command = string.format("exec ./%s", project_name)

    -- Definir el comando de compilación según el tipo de proyecto
    local compile_cmd
    if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        compile_cmd = string.format("mkdir -p build && cd build && cmake .. && make && cd .. && cd build && %s", run_command)
        vim.notify("Compilando y ejecutando con CMake en WezTerm...", vim.log.levels.INFO)
    elseif vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        compile_cmd = string.format("make && %s", run_command)
        vim.notify("Compilando y ejecutando con Make en WezTerm...", vim.log.levels.INFO)
    else
        local c_files = vim.fn.glob("*.c", false, true)
        if #c_files > 0 then
            compile_cmd = string.format("gcc *.c -o %s -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 && %s", project_name, run_command)
            vim.notify("Compilando y ejecutando con GCC en WezTerm...", vim.log.levels.INFO)
        else
            vim.notify("No se detectó un proyecto de C válido.", vim.log.levels.WARN)
            return
        end
    end

    -- Comando para abrir WezTerm y cerrar el panel automáticamente cuando el juego termine
    local wezterm_launch_cmd = string.format("wezterm cli split-pane --bottom --percent 30 -- bash -c '%s'", compile_cmd)

    -- Ejecutar el comando en WezTerm
    local result = os.execute(wezterm_launch_cmd)
    if result == 0 then
        vim.notify("Ejecución lanzada en WezTerm.", vim.log.levels.INFO)
    else
        vim.notify("Error al lanzar WezTerm.", vim.log.levels.ERROR)
    end
end




-- Mapeo de <F5>: Ejecuta Godot normal o Rust+Godot según el contexto
vim.keymap.set("n", "<F5>", function()
    local file_path = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()

    if file_path:match("/rust/src/") then
        run_godot_with_rust()
    elseif vim.fn.filereadable(cwd .. "/project.godot") == 1 then
        run_godot_project()
    elseif file_path:match("%.c$") or vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 or vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        run_c_project()
    else
        vim.notify("No se detectó un proyecto válido para ejecutar.", vim.log.levels.WARN)
    end
end, { noremap = true, silent = true, desc = "Run Godot, Rust, or C project depending on context" })
---------------------------------------------------- F4 RUST BUILD

vim.keymap.set({ "n", "v", "i" }, "<F4>", function()
    local cwd = vim.fn.getcwd()
    local file_path = vim.fn.expand("%:p")

    -- Si estamos dentro de `rust/`, subimos un nivel para obtener la raíz del proyecto
    if cwd:match("/rust$") then
        cwd = cwd:gsub("/rust$", "")
    end

    local rust_path = cwd .. "/rust"
    local cargo_toml = rust_path .. "/Cargo.toml"

    if file_path:match(rust_path .. "/src/") and vim.fn.filereadable(cargo_toml) == 1 then
        vim.notify("Compilando Rust...", vim.log.levels.INFO)

        -- Comando que deja `exit` preescrito en la terminal
        local wezterm_cmd = string.format(
            "wezterm cli split-pane --bottom --percent 30 -- bash -c 'cd %s && cargo build > build_log.txt 2>&1; " ..
            "if grep -qE \"(error:|warning:)\" build_log.txt; then cat build_log.txt; echo \"\\nPresiona ENTER para cerrar...\"; read; exit; else rm build_log.txt; exit; fi'",
            rust_path
        )

        local result = os.execute(wezterm_cmd)

        if result == 0 then
            vim.notify("Compilación sin errores ni warnings. Pane cerrado.", vim.log.levels.INFO)
        else
            vim.notify("Errores o warnings detectados. WezTerm se mantiene abierto (presiona ENTER para cerrar).", vim.log.levels.WARN)
        end
    else
        vim.notify("No se detectó un proyecto válido de Rust.", vim.log.levels.WARN)
    end
end, { noremap = true, silent = true, desc = "Build Rust project" })

-------------------------------------------------------------------------- F6
-- -- Ejecutar Godot con DAP en una segunda pantalla
-- vim.keymap.set({ "n", "v", "i" }, "<F6>", function()
--     require("godot.godot_launcher").launch_game_with_dap()
-- end, { noremap = true, silent = true, desc = "Run Godot with DAP on second monitor" })

vim.keymap.set("n", "<F6>", function()
    require("dap").continue()
end, { desc = "Start Godot Debug with Console" })

-- init.lua or keymaps.lua
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua require("dapui").toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', '<cmd>lua require("dap").continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>', { noremap = true, silent = true })







-- Opcional: un atajo para abrir/cerrar la UI manualmente
vim.keymap.set("n", "<leader>du", function()
    require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

local godotlauncher = require("godot.godot_launcher")

-- Mapeo para detener el juego y cerrar la UI
vim.keymap.set("n", "<C-c>", godotlauncher.stop_game, { noremap = true, silent = true, desc = "Stop game and hide DAP UI" })
---------------------------------------------------------------------------- SHOW PARAM INFO

vim.keymap.set("i", "<C-k>", function()
    vim.lsp.buf.signature_help()
end, { desc = "Show function signature" })

---------------------------------------------------------------------------- QUICK EDIT

-- vim.keymap.set("n", "ge", function()
--     require("custom.quick_edit").quick_edit()
-- end, { desc = "Quick edit function definition in floating window" })
---------------------------------------------------------------------------- LAZYGIT

vim.keymap.set("n", "<leader>g", function()
    vim.cmd(":LazyGit")
end, { desc = "Open LazyGit" })

----------------------------------------------------------------------------- UNDO REDO PARA POBRES
-- Mapeos para Undo y Redo
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo" })       -- Ctrl+Z como Undo
vim.keymap.set("n", "<C-S-z>", "<C-r>", { noremap = true, silent = true, desc = "Redo" }) -- Ctrl+Shift+Z como Redo

----------------------------------------------------------------------------- TOGGLE MAXIMIZE
vim.keymap.set({ "n", "v", "i" }, "<C-leader>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Space>", ":WindowsMaximize<CR>", { noremap = true, silent = true, desc = "Maximize current window" })
----------------------------------------------------------------------------- CTRL BACKSPACE
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete word backward in insert mode" })
----------------- jump end
vim.keymap.set("i", "<S-Right>", "<C-o>$", { noremap = true, silent = true, desc = "Move to end of line in insert mode" })




-- -- Alternar inlay hints
-- vim.keymap.set("n", "<leader>ih", ":lua require('lsp-inlayhints').toggle()<CR>", { noremap = true, silent = true, desc = "Toggle inlay hints" })

-- -- Formatear con Rust Analyzer
-- vim.keymap.set("n", "<leader>rf", ":lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true, desc = "Format Rust file" })
