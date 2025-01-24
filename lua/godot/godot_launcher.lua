local M = {}

-- Función para ejecutar Godot en un pane de WezTerm
M.launch_game = function()
    -- Ruta al ejecutable de Godot (ajusta según sea necesario)
    -- ACTUALIZAR ALIAS SI TAL
    -- alias godot-dev='home/kike/apps/Godot_v4.4-dev6_linux.x86_64'
    -- editar .bashrc con este alias para que sea permanente
    -- local godot_executable = "godot-dev"
    local godot_executable = "godot-dev"
    local project_path = vim.fn.getcwd() -- Usa el directorio actual como raíz del proyecto

    -- Comando para dividir un pane en WezTerm y lanzar Godot
    local wezterm_cmd = string.format(
        "wezterm cli split-pane --right --percent 30 -- bash -c '%s --no-window --monitor 1 %s'",
        godot_executable,
        project_path
    )

    -- Ejecutar el comando desde Neovim
    local result = os.execute(wezterm_cmd)
    if result == 0 then
        vim.notify("Godot started in a WezTerm pane", vim.log.levels.INFO)
        print('sirl')
    else
        vim.notify("Failed to start Godot in WezTerm", vim.log.levels.ERROR)
        print('nel')
    end
end

-- Función para arrancar Godot en modo DAP
-- -- Función para ejecutar Godot en modo DAP y mostrar la consola en WezTerm
-- M.launch_game_with_dap = function()
--     local godot_executable = "/home/kike/APPS/Godot_v4.4-dev6_linux.x86_64"
--     local project_path = vim.fn.getcwd()
--     local debug_port = 6006 -- Puerto predeterminado para DAP en Godot

--     -- Comando para dividir un pane en WezTerm y lanzar Godot en modo DAP
--     local wezterm_cmd = string.format(
--         "wezterm cli split-pane --right --percent 30 -- bash -c '%s --no-window --monitor 1 --remote-debug %d %s'",
--         godot_executable,
--         debug_port,
--         project_path
--     )

--     -- Ejecutar el comando desde Neovim
--     local result = os.execute(wezterm_cmd)
--     if result == 0 then
--         vim.notify("Godot (DAP) started in a WezTerm pane on port " .. debug_port, vim.log.levels.INFO)
--     else
--         vim.notify("Failed to start Godot (DAP) in WezTerm", vim.log.levels.ERROR)
--     end
-- end




return M

