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
  return #x == 0
end

function M.at_home()
  return vim.fn.getcwd() == os.getenv("HOME")
end

function M.get_os_command_output(cmd, cwd)
  local Job = require("plenary.job")

  if type(cmd) ~= "table" then
    print("must receive a table command arg")
    return {}
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
  return M.get_os_command_output(M.cfg_git_command("ls-files"), os.getenv("HOME"))
end

return M
