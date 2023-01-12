local k = require("danielf.keymap");

local harpoon_ui = require("harpoon.ui");
local harpoon_mark = require("harpoon.mark");


require("telescope").load_extension('harpoon')

k.nnoremap("<leader>a", function() harpoon_mark.add_file() end)
--k.nnoremap("\\", function() harpoon_ui.toggle_quick_menu() end)
k.nnoremap(k.tab .. k.tab, function() harpoon_ui.toggle_quick_menu() end);
k.nnoremap("<F1>", function() harpoon_ui.nav_file(1) end)
k.nnoremap("<F2>", function() harpoon_ui.nav_file(2) end)
k.nnoremap("<F3>", function() harpoon_ui.nav_file(3) end)
