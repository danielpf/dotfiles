-- winbar -------------------

local function apply_hi(grp,s)
  return "%#"..grp.."#"..s.."%*"
end
-- lua bg 1 = 2c323c, lua bg 2 = 3e4452
--vim.cmd("hi MyWinBarFg1 guibg=#3e4452 guifg=#abb2bf")
--vim.cmd("hi MyWinBarFg2 guibg=#3e4452 guifg=#6272a4")
--vim.cmd("hi Winbar      guibg=#3e4452")
vim.cmd("hi MyWinBarDark  guibg=#6272a4 guifg=#000000")
vim.cmd("hi MyWinBarLight guibg=#6272a4 guifg=#ececec")
vim.cmd("hi Winbar guibg=#6272a4 guifg=#ffffff")

local winbar_filetype_exclude = {
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "neo-tree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
  "NvimTree",
}

-- local get_filename = function()
--   local extension = vim.fn.expand("%:e")

--   if not DU.is_empty(filename) then
--     local file_icon, file_icon_color =
--       require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

--     local hl_group = "FileIconColor" .. extension

--     vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
--     if DU.is_empty(file_icon) then
--       file_icon = ""
--       file_icon_color = ""
--     end

--     return " %#"..hl_group.."#"..file_icon.."%* %#LineNr#"..filename.."%* "..extension
--   end
-- end

-- set title on top of each window; %= → right align, %m → modified, ..
 -- vim.opt.winbar=" "..apply_hi("MyWinBarLight","%LL").." | "..apply_hi("MyWinBarLight","%f").." %m%r%w%h%*"



 local function get_filename(bufnr, maxsize)
   local filename = vim.fn.expand("%")
   if DU.is_empty(filename) then
     return "[No Name]"
   end
   filename = require("plenary.path"):new(filename):make_relative(vim.fn.getcwd())
   local excess_size = #filename - maxsize
   if excess_size > 2 then
     filename = string.gsub(filename, string.rep(".", excess_size), "┅", 1)
   end
   return filename
 end

 local function get_icon(filename,extension)
   local file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
   if DU.is_empty(file_icon) then
      file_icon = ""
      file_icon_color = ""
    end
    return file_icon, file_icon_color
 end

 local function line_count_bar(i,n,slots)
   local fraction = i/n
   if n > 0 then
     fraction = i/n
   else
     fraction = 0
   end
   local solid_slots = fraction * slots
   if solid_slots % 1 > 0.5 then
     solid_slots = math.ceil(solid_slots)
   else
     solid_slots = math.floor(solid_slots)
   end
   local empty_slots = slots - solid_slots
   local bar = ""
   while solid_slots > 0 do
     bar = bar.."■"
     solid_slots = solid_slots - 1
   end
   while empty_slots > 0 do
     bar = bar.."□"
     empty_slots = empty_slots - 1
   end
   return bar
 end

local winbar_group = vim.api.nvim_create_augroup('winbar_group', {clear = true})
vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter', 'BufWrite', 'WinScrolled', 'WinResized' }, {
    group = winbar_group,
    once = false,
    callback = function(ev)
      local bufnr = ev.buf

      local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if vim.tbl_contains(winbar_filetype_exclude, filetype) then
        vim.opt_local.winbar = nil
        return
      end

      local winhandle = vim.api.nvim_get_current_win()
      local winnr = vim.api.nvim_win_get_number(winhandle)

      local filename = get_filename(bufnr, 50)
      local extension = vim.fn.expand("%:e")

      local val = ""
      val = val..apply_hi("MyWinBarLight",winnr)
      val = val.." "..apply_hi("MyWinBarLight",get_icon(filename,extension))

      val = val.." "..apply_hi("MyWinBarLight",filename)
      if vim.api.nvim_buf_get_option(bufnr, 'modified') then
        val = val.."*"
      end
      if not vim.api.nvim_buf_get_option(bufnr, 'modifiable') then
        val = val.." [unmodifiable]"
      end

      -- val = val.." "..apply_hi("MyWinBarLight", vim.api.nvim_win_get_cursor(winhandle)[1].."/")
      local linecount = vim.api.nvim_buf_line_count(bufnr)
      val = val.." "..apply_hi("MyWinBarLight", linecount.."L")
      -- val = val.." "..apply_hi("MyWinBarLight", vim.api.nvim_win_get_cursor(winhandle).."L")

      local width = vim.api.nvim_win_get_width(winhandle)
      local free_width = (width - #val + (18*4))
      local slots = free_width -2  -- for safety
      local max_slots = 25
      if slots > max_slots then slots = max_slots end -- but not so big
      if slots > 3 then
        val = val.." "
        local pos = vim.api.nvim_win_get_cursor(winhandle)[1]
        bar = line_count_bar(pos, linecount, slots)
        val = val..apply_hi('MyWinBarLight', bar)
      end
      val = val.." "

      pcall(vim.api.nvim_set_option_value, "winbar", val, { scope = "local" })
    end
})

-- lualine --------------------------

local function my_statusline()
  return "["..vim.fn.getcwd().."]"
end

-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'branch'},
    lualine_b = { my_statusline },
    lualine_c = {'progress'},
    --lualine_c = {{'filename', file_status = true}},   --, path = 2
    lualine_x = {'diff'},
    lualine_y = {'filetype', 'encoding', 'fileformat'},
    lualine_z = {'mode'}
  },
}

