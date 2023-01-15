local function tmux_status()
  local s = DU.get_os_command_output({
    "tmux",
    "display-message",
    "-p",
    -- "#S:#{active_window_index}"
    "#{active_window_index}"
  })
  return s[1] or "no tmux"
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
    lualine_b = { function()
      local cwd = vim.fn.getcwd()
      local home = os.getenv("HOME")
      return "["..string.gsub(cwd,home.."/?","~/",1).."]"
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

