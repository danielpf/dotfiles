local M = {
  root_dir = "",
  root_dir_path = nil
}

M.Path = require("plenary.path")

M.Path.is_subdir = function(self, parent)
  if string.sub(parent, -1) ~= '/' then
    parent = parent .. '/'
  end
  return 1 == string.find(self.filename, parent, 1, true)
end

function M.basename(filename)
  local path = M.Path.new("/"..filename)
  local parent = path:parent()
  local basename = path:make_relative(tostring(parent))
  return tostring(basename)
end

function M.with_tilda(file_or_dir)
  local home = os.getenv("HOME")
  return string.gsub(file_or_dir,home.."/?","~/",1)
end

function M.relativize_to(path_to_print, base_path)
  if DU.is_empty(path_to_print) then
    return path_to_print
  end
  path_to_print = path_to_print:absolute()
  base_path = base_path:absolute()
  return path_to_print:make_relative(tostring(base_path))
end

function M.compact_name(filename)
  filename = string.gsub(filename, "components", "c")
  filename = string.gsub(filename, "templates", "t")
  filename = string.gsub(filename, "index", "ix")
  filename = string.gsub(filename, "dataset", "dset")
  filename = string.gsub(filename, "java", "j")
  return filename
end

---------- rooter ------

vim.g['rooter_patterns'] = {
  '!^node_modules',
  '!^fugitive://',
  '.git',
  '.cfg',
  'worktrees',
  'build.gradle',
  'build.kts',
}
vim.g['rooter_silent_chdir'] = 1
vim.g['rooter_buftypes'] = {''}

function M.set_root_as_cwd()
  M.root_dir = vim.fn.getcwd()
  M.root_dir_path = M.Path.new(M.root_dir)
end
M.set_root_as_cwd()

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.g['rooter_manual_only'] = 1
  end
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'RooterChDir',
  callback = function()
    M.set_root_as_cwd()
    vim.notify('Set project root at '..DP.root_dir)
  end
})

return M
