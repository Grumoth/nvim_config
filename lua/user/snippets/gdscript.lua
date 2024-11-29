-- ~/.config/nvim/lua/user/snippets/gdscript.lua

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("gd", {
    s("func", {
        t("func "),
        i(1, "function_name"),
        t("("),
        i(2, "params"),
        t("):"),
        t({"", "\t"}),
        i(0),
    }),
    -- Añade más snippets según tus necesidades
})
