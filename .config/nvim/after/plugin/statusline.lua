local function tmux_status()
  local s = DU.get_os_command_output({
    "tmux",
    "display-message",
    "-p",
    -- "#S:#{active_window_index}"
    "#{active_window_index} #{session_windows}"
  })[1]
  if DU.is_empty(s) then return "no tmux" end
  local w_id = tonumber(string.match(s, "%d+"))
  local delim_pos = string.find(s, " +", 2)
  local w_num = tonumber(string.match(s, "%d+", delim_pos))
  local windows = {}
  for i=0,w_num-1 do
    local e_str = i
    if i==w_id then e_str = "["..i.."]" end
    table.insert(windows, e_str)
  end
  return table.concat(windows," ")
end

local function status_registers()
  local getreg = function(r) return vim.fn.eval("@"..r) end
  local minify = function(txt)
    local maxlen = 17
    local s = txt
    s = string.gsub(txt, " +", " ")
    -- s = string.gsub(s, "%s+", "∅")
    s = string.sub(s, 1, maxlen)
    return s
  end
  local contents = { }
  table.insert(contents, minify(getreg("\"")))
  table.insert(contents, minify(getreg("1")))
  return table.concat(contents, "|")
end

local function swap_registers()
end

local function gitline()
  local repo = vim.fn.FugitiveGitDir()
  if repo ~= nil and repo ~= "" then
    return "git"
  end
end

-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  extensions = { 'fugitive' },
  sections = {
    lualine_a = { gitline },
    lualine_b = { function()
      return "["..DP.with_tilda(vim.fn.getcwd()).."]"
    end },
    lualine_c = { {
      require("danielf.buffer_ring").statusline,
      -- function () return 'a' end,
      separator = nil,
      section_separators = "%#lualine_c_normal# %0*",
      component_separators = "%#lualine_c_normal# %0*",
      -- color = function(section)
      --   return { fg = '#ffaa88', gui='bold' }
      -- end
    }},
    -- lualine_c = {
    --   {
    --     'buffers',
    --     mode = 4,
    --     symbols = {
    --       modified = "*",
    --       directory = "/"
    --     },
    --     buffers_color = {
    --       inactive = {fg="#5a5a5a"},
    --       active = {fg="afafaf"},
    --     }
    --   }
    -- },
    lualine_x = {'diff'},
    lualine_y = { tmux_status },
    lualine_z = { 'mode' }
  },
}

