local wezterm = require 'wezterm'
    wezterm.on('gui-startup', function(cmd)
    local mux = wezterm.mux
    local tab, pane, window = mux.spawn_window(cmd or {})

    -- Establecer fullscreen al iniciar
--     window:gui_window():toggle_fullscreen()
    window:gui_window():maximize()
    -- Mover la ventana al monitor deseado (index del monitor)
    local screen_index = 1 -- Cambia esto al índice de tu monitor objetivo
    local screens = wezterm.gui.screens()
    if #screens >= screen_index then
        local screen = screens[screen_index]
        window:gui_window():set_position(screen.x, screen.y)
    end
    end)
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--   -- Divide el panel inicial en dos verticalmente
--   pane:split {
--     direction = 'Right',
--   }
-- end)
local config = {}
-- -- -- config.skip_close_confirmation_for_processes_named = { "" }
-- config.skip_close_confirmation = true
config.window_close_confirmation = "NeverPrompt"
-- config.color_scheme = 'Batman'
--Batman
-- config.color_scheme = 'AdventureTime'
config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'ayu'

config.keys = {
    {
        key = "Backspace",
        mods = "CTRL",
        action = wezterm.action.SendString("\x17"), -- Ctrl+W (borrar palabra hacia atrás)
    },
}

return config
