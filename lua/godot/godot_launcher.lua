local M = {}

-- Función para ejecutar Godot en un pane de WezTerm
M.launch_game = function()
    -- Ruta al ejecutable de Godot (ajusta según sea necesario)
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

return M

