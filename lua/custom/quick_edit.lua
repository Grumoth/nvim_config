local M = {}

M.quick_edit = function()
    -- Obtener la palabra bajo el cursor
    local word = vim.fn.expand("<cword>")

    -- Solicitar la definición de la función al LSP
    local results = vim.lsp.buf_request_sync(0, "textDocument/definition", vim.lsp.util.make_position_params(), 1000)

    if not results or vim.tbl_isempty(results) then
        vim.notify("No definition found for '" .. word .. "'", vim.log.levels.WARN)
        return
    end

    -- Obtener la primera ubicación válida
    local location = nil
    for _, res in pairs(results) do
        if res.result and not vim.tbl_isempty(res.result) then
            location = res.result[1]
            break
        end
    end

    if not location then
        vim.notify("No valid location for '" .. word .. "'", vim.log.levels.WARN)
        return
    end

    -- Extraer la información de la ubicación
    local uri = location.uri or location.targetUri
    local range = location.range or location.targetRange

    if not uri or not range then
        vim.notify("Invalid location data for '" .. word .. "'", vim.log.levels.WARN)
        return
    end

    -- Convertir URI a ruta del sistema
    local filepath = vim.uri_to_fname(uri)
    local line = range.start.line

    -- Crear un buffer y una ventana flotante
    local buf = vim.api.nvim_create_buf(false, true) -- Crear un buffer sin nombre
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile") -- Evitar guardar accidentalmente

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
    })

    -- Cargar el archivo y saltar a la línea de la definición
    vim.api.nvim_command("edit " .. filepath)
    vim.api.nvim_win_set_cursor(0, { line + 1, 0 })

    -- Centrar la línea en la ventana
    vim.cmd("normal! zz")

    -- Cerrar el buffer con `q`
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd!<CR>", { noremap = true, silent = true, desc = "Close quick edit" })
end

return M
