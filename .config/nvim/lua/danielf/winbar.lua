local M = {}

M.winbar_filetype_exclude = {
  "help",
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

local get_filename = function()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if not DU.is_empty(filename) then
    local file_icon, file_icon_color =
      require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if DU.is_empty(file_icon) then
      file_icon = ""
      file_icon_color = ""
    end

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#LineNr#" .. filename .. "%*"
  end
end

local get_gps = function()
  local status_gps_ok, gps = pcall(require, "nvim-navic")
  if not status_gps_ok then return "" end

  local status_ok, gps_location = pcall(gps.get_location, {})
  if not status_ok then return "" end

  if not gps.is_available() or gps_location == "error" then return "" end

  if not DU.is_empty(gps_location) then
    return require("config.icons").ui.ChevronRight .. " " .. gps_location
  else
    return ""
  end
end

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

M.get_winbar = function()
  if excludes() then return end
  local value = get_filename()

  local gps_added = false
  if not f.isempty(value) then
    local gps_value = get_gps()
    value = value .. " " .. gps_value
    if not f.isempty(gps_value) then gps_added = true end
  end

  if not DU.is_empty(value) and f.get_buf_option("mod") then
    local mod = "%#LineNr#" .. require("config.icons").ui.Circle .. "%*"
    if gps_added then
      value = value .. " " .. mod
    else
      value = value .. mod
    end
  end

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then return end
end


---- set up highlighting
--local function apply_hi_group(grp,s)
--  return "%#"..grp.."#"..s.."%*"
--end
---- lua bg 1 = 2c323c, lua bg 2 = 3e4452
----vim.cmd("hi MyWinBarFg1 guibg=#3e4452 guifg=#abb2bf")
----vim.cmd("hi MyWinBarFg2 guibg=#3e4452 guifg=#6272a4")
----vim.cmd("hi Winbar      guibg=#3e4452")
--vim.cmd("hi MyWinBarDark  guibg=#2c323c guifg=#abb2bf")
--vim.cmd("hi MyWinBarLight guibg=#6272a4 guifg=#ffffff")
--vim.cmd("hi Winbar        guibg=#6272a4")
---- set title on top of each window; %= → right align, %m → modified, ..
----"%="..
--vim.opt.winbar=" "..apply_hi_group("MyWinBarLight","%LL").." | "..apply_hi_group("MyWinBarLight","%f").." %m%r%w%h%*"

----- Set lualine as statusline

--local function my_statusline()
--  return "["..vim.fn.getcwd().."]"
--end

---- See `:help lualine.txt`
--require('lualine').setup {
--  options = {
--    icons_enabled = false,
--    theme = 'onedark',
--    component_separators = '|',
--    section_separators = '',
--  },
--  sections = {
--    lualine_a = {'branch'},
--    lualine_b = { my_statusline },
--    lualine_c = {'progress'},
--    --lualine_c = {{'filename', file_status = true}},   --, path = 2
--    lualine_x = {'diff'},
--    lualine_y = {'filetype', 'encoding', 'fileformat'},
--    lualine_z = {'mode'}
--  },
--}



return M
