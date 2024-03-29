local M = {}

function M.getVisualSelection ()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

function M.is_empty(x)
  return (not x) or #x == 0
end

function M.at_home(dir)
  if M.is_empty(dir) then
    dir = vim.fn.getcwd()
  end
  return string.match(dir, os.getenv("HOME")..'/?$')
end

function M.make_string_of_size(s, n)
  if s == nil or #s == n then
    return s
  elseif #s < n then
    return string.rep(" ", #s-n)..s
  else
    return "‥"..string.sub(s, #s - n + 1, #s)
  end
end

function M.get_os_command_output(cmd, cwd)
  local Job = require("plenary.job")

  if type(cmd) ~= "table" then
    print("must receive a table command arg")
    return {}
  end
  if cwd == nil then
    cwd = '.'
  end
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

function M.cfg_git_command(git_cmd)
  if type(git_cmd) ~= "string" then
    print("error: must receive a string command arg")
    return {}
  end
  local home = os.getenv("HOME")
  return {
    "git",
    "--git-dir="..home.."/.cfg",
    "--work-tree="..home,
    git_cmd
  }
end

function M.cfg_files()
  local lst = DC.List.new(M.get_os_command_output(M.cfg_git_command("ls-files")))
  local r = lst:iter():partition(function(s)
    return string.match(s, '.*packer_compiled.*') == nil
  end)
  return r
end

M.NONEDITOR_FILETYPES = {
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
  "undotree",
  "TelescopePrompt",
  "harpoon",
  "lspinfo",
  "qf",
  "fugitive",
}

function M.is_editor(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  if vim.tbl_contains(M.NONEDITOR_FILETYPES, filetype) then
    return false
  end
  local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  return buftype ~= "nofile"
end

return M
