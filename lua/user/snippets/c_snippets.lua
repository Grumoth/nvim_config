local ls = require("luasnip")

ls.add_snippets("c", {
    ls.snippet("rayinit", {
        ls.text_node({ "#include <raylib.h>", "", "int main() {" }),
        ls.insert_node(1, "InitWindow(800, 600, \"Hello Raylib\");"),
        ls.text_node({ "", "while (!WindowShouldClose()) {", "" }),
        ls.insert_node(2, "BeginDrawing(); ClearBackground(RAYWHITE); EndDrawing();"),
        ls.text_node({ "", "}", "CloseWindow(); return 0;", "}" }),
    }),
})