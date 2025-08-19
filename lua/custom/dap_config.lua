-- lua/custom/dap_config.lua

local M = {}

-- Cargar plugins necesarios
local dap = require("dap")
local dapui = require("dapui")

-- Configuración de nvim-dap para Godot
M.setup_dap = function()
    -- Adaptador para Godot
    dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
    }

    -- Configuración de lanzamiento para Godot
    dap.configurations.gdscript = {
        {
            type = "godot",
            request = "launch",
            name = "Launch Godot",
            project = "${workspaceFolder}",
            port = 6006,
        },
    }
end

-- Configuración de nvim-dap-ui
M.setup_dapui = function()
    dapui.setup({
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.15 },
                    { id = "breakpoints", size = 0.15 },
                    { id = "stacks", size = 0.15 },
                    { id = "watches", size = 0.55 },
                },
                position = "bottom",
                size = 5,
            },
            {
                elements = {
                    { id = "repl", size = 0.9 },
                    { id = "console", size = 0.1 },
                },
                position = "right",
                size = 35,
            },
        },
    })
end

-- Configuración de listeners para abrir/cerrar dapui automáticamente
M.setup_listeners = function()
    -- Abrir dapui automáticamente al iniciar la depuración
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()

        -- Configurar autoscroll y pruebas después de abrir dapui
        -- M.enable_repl_autoscroll()
        -- M.test_repl()
    end

    -- Cerrar dapui automáticamente al terminar la depuración
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end

    -- Cerrar dapui automáticamente al salir de la depuración
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

-- Habilitar autoscroll en el REPL
M.enable_repl_autoscroll = function()
    -- Obtener el buffer del REPL
    local repl = dapui.elements.repl.terminal
    if not repl then
        print("REPL no encontrado. Asegúrate de que dapui esté abierto.")  -- Mensaje de depuración
        return
    end

    print("Configurando autoscroll para el REPL...")  -- Mensaje de depuración

    -- Configurar autoscroll para el buffer del REPL
    vim.api.nvim_create_autocmd("TermEnter", {
        buffer = repl.bufnr,
        callback = function()
            print("Desplazando REPL hacia abajo...")  -- Mensaje de depuración
            vim.api.nvim_command("normal! G")
        end,
    })
end

-- Función para probar la modificación del REPL
M.test_repl = function()
    local repl = dapui.elements.repl.terminal
    if repl then
        print("Escribiendo en el REPL...")  -- Mensaje de depuración
        vim.api.nvim_chan_send(repl.bufnr, "print('Hola desde el REPL')\n")
    else
        print("REPL no encontrado. Asegúrate de que dapui esté abierto.")  -- Mensaje de depuración
    end
end

-- Inicializar toda la configuración de DAP
M.setup = function()
    M.setup_dap()               -- Configurar nvim-dap
    M.setup_dapui()             -- Configurar nvim-dap-ui
    M.setup_listeners()         -- Configurar listeners
end

return M