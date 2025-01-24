local dap = require("dap")

-- Configurar el adaptador de Godot
dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = 6006, -- Puerto predeterminado para Godot DAP
}

-- Configurar el debugger para GDScript
dap.configurations.gdscript = {
    {
        type = "godot",
        request = "launch",
        name = "Launch Godot DAP",
        project = "${workspaceFolder}", -- Directorio del proyecto actual
    },
}

local dapui = require("dapui")

dapui.setup({
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 40, -- Pane derecho
            position = "right",
        },
        {
            elements = {
                "repl", -- Consola interactiva
                "console", -- Consola de salida
            },
            size = 10, -- Pane inferior
            position = "bottom",
        },
    },
    controls = {
        element = "repl", -- Asegurarse de que los controles interactúen con el REPL
    },
    floating = {
        border = "rounded",
    },
    render = {
        max_type_length = nil, -- No limitar la longitud de los tipos en la consola
    },
})

-- Activar auto-scroll en la consola
-- Configurar autoscroll
vim.api.nvim_create_autocmd("User", {
    pattern = "DapUiEventUpdate", -- Evento que dispara una actualización de la consola
    callback = function()
        vim.cmd("normal! G") -- Ir al final de la consola
    end,
})
-- Listeners para abrir y cerrar automáticamente la UI
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end


local function strip_bbcode(message)
    -- Elimina códigos BBCode comunes
    return message
        :gsub("%[color=#[0-9a-fA-F]+%]", "") -- Quitar etiquetas de color
        :gsub("%[b%]", "")                   -- Quitar etiquetas de negrita
        :gsub("%[/b%]", "")                  -- Quitar cierre de negrita
        :gsub("%[/color%]", "")              -- Quitar cierre de color
end

-- Interceptar mensajes para procesar BBCode
vim.api.nvim_create_autocmd("User", {
    pattern = "DapUiEventUpdate",
    callback = function()
        local lines = vim.fn.getbufline(vim.fn.bufnr("%"), 1, "$")
        for i, line in ipairs(lines) do
            lines[i] = strip_bbcode(line)
        end
        vim.fn.setbufline(vim.fn.bufnr("%"), 1, lines)
    end,
})