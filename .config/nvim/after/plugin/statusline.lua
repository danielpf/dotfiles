-- winbar -------------------

local function apply_hi(grp,s)
  return "%#"..grp.."#"..s.."%*"
end

 local function get_filename(bufnr, winwidth)
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
   if vim.api.nvim_buf_get_option(bufnr, 'modified') then
     filename = filename.."*"
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
vim.cmd("hi MyWinBarLight guibg=#6373a5 guifg=#ffffff")
vim.cmd("hi MyWinBarActiv guibg=#3d5090 guifg=#ffffff gui=underline")
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

      local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if not DU.is_editor(filetype) then
        vim.opt_local.winbar = nil
        return
      end

      local winhandle = vim.api.nvim_get_current_win()
      local winnr = vim.api.nvim_win_get_number(winhandle)
      local winwidth = vim.api.nvim_win_get_width(winhandle)
      local winheight = vim.api.nvim_win_get_height(winhandle)

      local filename = get_filename(bufnr, winwidth)

      local val = ""
      val = val..apply_hi("MyWinBarLight",winnr)
      val = val.." "..apply_hi("MyWinBarActiv",filename)
      if (winwidth - #filename) > 15 and not DU.is_empty(filetype) then
        -- local extension = vim.fn.expand("%:e")
        -- val = val..apply_hi("MyWinBarLight",get_icon(filename,extension))
        val = val.." "..apply_hi("MyWinBarLight",filetype)
      end
      if not vim.api.nvim_buf_get_option(bufnr, 'modifiable') then
        local icons = require("nvim-web-devicons")
        if icons ~= nil then
          val = val.." "..icons.get_icon("lock")
        else
          val = val.." [unmod.]"
        end
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
        local pos = vim.api.nvim_win_get_cursor(winhandle)[1]
        local bar = line_count_bar(pos, linecount, slots)
        val = val..apply_hi('MyWinBarLight', bar)
      end
      val = val.." "

      pcall(vim.api.nvim_set_option_value, "winbar", val, { scope = "local" })
    end
})

-- lualine --------------------------

local function tmux_status()
  local s = DU.get_os_command_output({
    "tmux",
    "display-message",
    "-p",
    "#S:#{active_window_index}"
  })
  return s[1]
end

local function registers()
  local maxlen = 8
  local contents = { }
  for i = 1, 3, 1 do
    local s = vim.fn.eval("@"..i)
    s = string.gsub(s, " +", "")
    s = string.gsub(s, "%s+", "∅")
    s = string.sub(s, 1, maxlen)
    table.insert(contents, s)
  end
  return table.concat(contents, "|")
end


-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  extensions = {'fugitive'},
  sections = {
    lualine_a = {'branch'},
    lualine_b = { function() return "["..vim.fn.getcwd().."]" end },
    lualine_c = {
      {
        'buffers',
        mode = 4,
        symbols = {
          modified = "*",
          directory = "/"
        },
        buffers_color = {
          inactive = {fg="#5a5a5a"},
          active = {fg="afafaf"},
        }
      }
    },
    lualine_x = {'diff'},
    lualine_y = { registers },
    lualine_z = { tmux_status }
  },
}

