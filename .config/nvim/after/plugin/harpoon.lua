local k = require("danielf.keymap");

local harpoon_ui = require("harpoon.ui");
local harpoon_mark = require("harpoon.mark");

local file_ring = {}
local function add_entry(filename)
  if file_ring[filename] ~= nil then
    return
  end
  file_ring[filename] = { points = 0 }
end

local function add_points(filename, points)
  local entry = file_ring[filename]
  if entry == nil then
    return
  end
  entry.points = entry.points + points
end

local function process_file_ring()
end

local harpoon_group = vim.api.nvim_create_augroup('harpoon_group', { clear = true })
local windows = vim.fn.getwininfo();
vim.api.nvim_create_autocmd('BufWritePost', {
  group = harpoon_group,
  callback = function()
  end
})

k.nnoremap("<leader>a", function() harpoon_mark.add_file() end)
--k.nnoremap("\\", function() harpoon_ui.toggle_quick_menu() end)
k.nnoremap(k.tab .. k.tab, function() harpoon_ui.toggle_quick_menu() end);
k.nnoremap("<F1>", function() harpoon_ui.nav_file(1) end)
k.nnoremap("<F2>", function() harpoon_ui.nav_file(2) end)
k.nnoremap("<F3>", function() harpoon_ui.nav_file(3) end)
