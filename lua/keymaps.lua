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

vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true, desc = " COPIA AL CLIPBOARD" })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true ,desc = " COPIA AL CLIPBOARD"})

vim.keymap.set("i", "<C-l>", "<C-o>a", { noremap = true, silent = true, desc = "Move cursor right in insert mode" })
-- En modo normal: Agrega `;` al final de la línea y no vuelve atrás
vim.keymap.set("n", "<C-,>", "A;<Esc>", { noremap = true, silent = true, desc = "Insert ; at end of line" })

-- En modo insert: Agrega `;`, pero manteniéndote en modo insert
vim.keymap.set("i", "<C-,>", "<Esc>A;<Esc>a", { noremap = true, silent = true, desc = "Insert ; at end of line in insert mode" })

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

local function find_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/Cargo.toml") == 1
            or vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1
            or vim.fn.filereadable(dir .. "/Makefile") == 1
            or vim.fn.isdirectory(dir .. "/build") == 1 then
            return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    return vim.fn.getcwd()
end

-------------------------------------------------------------------------- F5

-- Función para ejecutar un proyecto de Godot normal (sin tocar Rust)
local function run_godot_project()
    local cwd = find_project_root()
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
    local cwd = find_project_root()
    local project_name = vim.fn.fnamemodify(cwd, ":t")
    local run_command = string.format("exec ./%s", project_name)
    local compile_cmd

    local cpp_files = vim.fn.globpath(cwd, "*.cpp", false, true)
    local c_files = vim.fn.globpath(cwd, "*.c", false, true)

    if #cpp_files > 0 then
        compile_cmd = string.format("cd %s && g++ *.cpp -o %s -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 && %s", cwd, project_name, run_command)
        vim.notify("Compilando y ejecutando con G++ y Raylib en WezTerm...", vim.log.levels.INFO)
    elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        compile_cmd = string.format("cd %s && mkdir -p build && cd build && cmake .. && make && cd .. && cd build && %s", cwd, run_command)
        vim.notify("Compilando y ejecutando con CMake en WezTerm...", vim.log.levels.INFO)
    elseif vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        compile_cmd = string.format("cd %s && make && %s", cwd, run_command)
        vim.notify("Compilando y ejecutando con Make en WezTerm...", vim.log.levels.INFO)
    elseif #c_files > 0 then
        compile_cmd = string.format("cd %s && gcc *.c -o %s -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 && %s", cwd, project_name, run_command)
        vim.notify("Compilando y ejecutando con GCC en WezTerm...", vim.log.levels.INFO)
    else
        vim.notify("No se detectó un proyecto de C válido.", vim.log.levels.WARN)
        return
    end

    local wezterm_launch_cmd = string.format("wezterm cli split-pane --bottom --percent 30 -- bash -c '%s'", compile_cmd)
    local result = os.execute(wezterm_launch_cmd)

    if result == 0 then
        vim.notify("Ejecución lanzada en WezTerm.", vim.log.levels.INFO)
    else
        vim.notify("Error al lanzar WezTerm.", vim.log.levels.ERROR)
    end
end

-- Función para ejecutar un proyecto de Rust normal
local function run_rust_project()
    local cwd = find_project_root()
    local cargo_toml = cwd .. "/Cargo.toml"

    if vim.fn.filereadable(cargo_toml) == 1 then
        vim.notify("Compilando y ejecutando Rust...", vim.log.levels.INFO)
        local wezterm_cmd = string.format(
            "wezterm cli split-pane --bottom --percent 30 -- bash -c 'cd %s && cargo build && cargo run; exit'",
            cwd
        )
        local result = os.execute(wezterm_cmd)
        if result == 0 then
            vim.notify("Rust ejecutado en WezTerm.", vim.log.levels.INFO)
        else
            vim.notify("Error al ejecutar Rust.", vim.log.levels.ERROR)
        end
    else
        vim.notify("No se detectó un proyecto válido de Rust.", vim.log.levels.WARN)
    end
end

-- Mapeo de <F5>: Ejecuta Godot, Rust o C según el contexto
vim.keymap.set({ "n", "v", "i" }, "<F5>", function()
    vim.cmd("wa")
    local cwd = find_project_root()
    local file_path = vim.fn.expand("%:p")

    if file_path:match("/rust/src/") and vim.fn.isdirectory(cwd .. "/godot") then
        run_godot_with_rust()
    elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
        run_rust_project()
    elseif vim.fn.filereadable(cwd .. "/project.godot") == 1 then
        run_godot_project()
    else
        run_c_project()
    end
end, { noremap = true, silent = true, desc = "Run project depending on context" })

---------------------------------------------------- F4 RUST BUILD
vim.keymap.set({ "n", "v", "i" }, "<F4>", function()
    vim.cmd("wa")
    local cwd = find_project_root()

    if vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
        vim.notify("Compilando Rust con Cargo Build en " .. cwd, vim.log.levels.INFO)
        local wezterm_cmd = string.format(
            "wezterm cli split-pane --bottom --percent 30 -- bash -c 'cd %s && cargo build > build_log.txt 2>&1; " ..
            "if grep -qE \"(error:|warning:)\" build_log.txt; then cat build_log.txt; echo \"\\nPresiona ENTER para cerrar...\"; read; exit; else rm build_log.txt; exit; fi'",
            cwd
        )
        local result = os.execute(wezterm_cmd)
        if result == 0 then
            vim.notify("Cargo Build sin errores. Pane cerrado.", vim.log.levels.INFO)
        else
            vim.notify("Errores detectados en Cargo Build. WezTerm se mantiene abierto.", vim.log.levels.WARN)
        end

    elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        vim.notify("Compilando C con CMake...", vim.log.levels.INFO)
        local wezterm_cmd = string.format(
            "wezterm cli split-pane --bottom --percent 30 -- bash -c 'cd %s && mkdir -p build && cd build && cmake .. && make > build_log.txt 2>&1; " ..
            "if grep -qE \"(error:|warning:)\" build_log.txt; then cat build_log.txt; echo \"\\nPresiona ENTER para cerrar...\"; read; exit; else rm build_log.txt; exit; fi'",
            cwd
        )
        os.execute(wezterm_cmd)

    elseif vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        vim.notify("Compilando C con Makefile...", vim.log.levels.INFO)
        local wezterm_cmd = string.format(
            "wezterm cli split-pane --bottom --percent 30 -- bash -c 'cd %s && make > build_log.txt 2>&1; " ..
            "if grep -qE \"(error:|warning:)\" build_log.txt; then cat build_log.txt; echo \"\\nPresiona ENTER para cerrar...\"; read; exit; else rm build_log.txt; exit; fi'",
            cwd
        )
        os.execute(wezterm_cmd)

    else
        vim.notify("No se detectó un proyecto válido de Rust o C.", vim.log.levels.WARN)
    end
end, { noremap = true, silent = true, desc = "Build Rust or C project" })

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
