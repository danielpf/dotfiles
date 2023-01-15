-- winbar -------------------
local function apply_hi(grp,s)
  return "%#"..grp.."#"..s.."%*"
end

 local function get_filename(bufnr, winwidth)
   local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
   local filename = vim.fn.expand("%")
   if DU.is_empty(filename) then
     return "[No Name]"
   end
   filename = require("plenary.path"):new(filename):make_relative(vim.fn.getcwd())
   local maxsize = math.ceil(0.75 * math.min(winwidth, 120))
   local excess_size = #filename - maxsize
   -- TODO
   if excess_size > 0 then
     filename = string.gsub(filename, string.rep(".", excess_size), "┅", 1)
   end
   if modified then
     filename = filename.."*"
   end
   return filename, modified
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
   if (solid_slots % 1) < 0.1 then
     solid_slots = math.floor(solid_slots)
   else
     solid_slots = math.ceil(solid_slots)
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

 local function compute_num_slots(winheight, linecount)
   local num_screens = linecount / (winheight+1)
   local slots = math.ceil(num_screens)
   local max_slots = 25
   if slots > max_slots then slots = max_slots end -- not so big
   return slots
 end

 local function compute_free_space(current_string, winwidth, num_hi_grps)
   return (winwidth - #current_string + (18*num_hi_grps))
 end

 -- lua bg 1 = 2c323c, lua bg 2 = 3e4452
--vim.cmd("hi MyWinBarFg1 guibg=#3e4452 guifg=#abb2bf")
--vim.cmd("hi MyWinBarFg2 guibg=#3e4452 guifg=#6272a4")
--vim.cmd("hi Winbar      guibg=#3e4452")
vim.cmd("hi MyWinBarDark  guibg=#6272a4 guifg=#000000")
vim.cmd("hi MyWinBarLight guibg=#6373a5 guifg=#bdcbfc")
-- vim.cmd("hi MyWinBarActiv guibg=#506097 guifg=#ffffff gui=bold")
vim.cmd("hi MyWinBarActiv guibg=#6373a5 guifg=#ffffff gui=underline")
vim.cmd("hi Winbar guibg=#6373a5 guifg=#efefef")
local winbar_group = vim.api.nvim_create_augroup('winbar_group', {clear = true})
vim.api.nvim_create_autocmd({
  'WinEnter', 'BufEnter', 'BufWritePost', 'WinScrolled', 'WinResized',
  'TextChanged', 'TextChangedI' },
  {
    group = winbar_group,
    once = false,
    callback = function(ev)
      local bufnr = ev.buf
      local winhandle = vim.api.nvim_get_current_win()
      local winnr = vim.api.nvim_win_get_number(winhandle)
      local winid = vim.fn.win_getid(winnr)

      if not DU.is_editor(bufnr) or "" == vim.api.nvim_buf_get_option(bufnr, 'filetype') then
        -- vim.api.nvim_buf_set_option(bufnr, 'winbar', "")
        -- pcall(vim.api.nvim_set_option_value, "winbar", nil, {
        --   scope = "local",
        --   win = winhandle
        -- })
        return
      end

      local winwidth = vim.api.nvim_win_get_width(winhandle)
      local winheight = vim.api.nvim_win_get_height(winhandle)

      local filename, modified = get_filename(bufnr, winwidth)

      local val = ""
      val = val..apply_hi("MyWinBarLight",winnr)
      local filename_color
      if modified then
        filename_color = "DiffAdd"
      else
        filename_color = "MyWinBarActiv"
      end
      val = val.." "..apply_hi(filename_color,filename)
      if not vim.api.nvim_buf_get_option(bufnr, 'modifiable') then
        local icons = require("nvim-web-devicons")
        if icons ~= nil then
          val = val.." "..icons.get_icon("lock")
        else
          val = val.." [unmod.]"
        end
      end
      local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if (winwidth - #filename) > 15 and not DU.is_empty(filetype) then
        -- local extension = vim.fn.expand("%:e")
        -- val = val..apply_hi("MyWinBarLight",get_icon(filename,extension))
        val = val.." "..apply_hi("MyWinBarLight",filetype)
      end

      -- val = val.." "..apply_hi("MyWinBarLight", vim.api.nvim_win_get_cursor(winhandle)[1].."/")
      local linecount = vim.api.nvim_buf_line_count(bufnr)
      val = val.." "..apply_hi("MyWinBarLight", linecount.."L")
      -- val = val.." "..apply_hi("MyWinBarLight", vim.api.nvim_win_get_cursor(winhandle).."L")

      local free_width = compute_free_space(val, winwidth, 5)
      local slots = compute_num_slots(winheight, linecount)
      if free_width == slots then
        slots = slots / 2
      end
      if slots > 1 and free_width > slots+2 then
        val = val.." "
        local pos = vim.api.nvim_win_get_cursor(winhandle)[1] - vim.fn.winline() + 1
        local bar = line_count_bar(pos, linecount, slots)
        val = val..apply_hi('MyWinBarLight', bar)
      end
      val = val.." "

      pcall(vim.api.nvim_set_option_value, "winbar", val, {
        scope = "local",
        win = winid
      })
    end
})
