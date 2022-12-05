local nnoremap = require("danielf.keymap").nnoremap;

local harpoon_ui = require("harpoon.ui");
local harpoon_mark = require("harpoon.mark");

nnoremap("<leader>a", function() harpoon_mark.add_file() end)
nnoremap("\\", function() harpoon_ui.toggle_quick_menu() end)
nnoremap("<F1>", function() harpoon_ui.nav_file(1) end)
nnoremap("<F2>", function() harpoon_ui.nav_file(2) end)
nnoremap("<F3>", function() harpoon_ui.nav_file(3) end)

