vim.g['rooter_patterns'] = {'.git','.cfg','build.gradle','build.kts','Makefile'}

local M = {
  root_dir = ""
}

function M.set_root_as_cwd()
  M.root_dir = vim.fn.getcwd()
end
M.set_root_as_cwd()

vim.api.nvim_create_autocmd('User', {
  pattern = 'RooterChDir',
  callback = function()
    M.set_root_as_cwd()
    vim.notify('Set project root at '..DP.root_dir)
  end
})

return M
