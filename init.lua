-- config based on `https://github.com/nvim-lua/kickstart.nvim`

-- `require` is a lua method that loads a given module, in this case,
-- the `package_manager` file in the `lua` directory
local is_bootstraping_package_manager = require("package_manager")
if is_bootstraping_package_manager then
    return
end

-- each string passed to the `require` function loads the respective file in
-- the `lua` directory, consult them in order to better understand the config :D
require("settings")
require("autocmds")
require("keymaps")
require("package_manager_config")
require("custom.dap_config").setup()
-- require("custom.dap_config")
-- require("custom.dap_virtual_text")
-- require("lua.custom.godot")
local custom_path = vim.fn.stdpath("config") .. "/lua/custom/"
for _, file in ipairs(vim.fn.glob(custom_path .. "*.lua", true, true)) do
    local module_name = file:match("lua/(.*)%.lua$"):gsub("/", ".")
    require(module_name)
end
