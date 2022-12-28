local filetype = require "vim.filetype"
local M = {};

local function echo(s)
  vim.cmd("echo '"..s.."'")
end

M.get_entity_type = function (filepath)
  local buf_id = vim.api.nvim_get_current_buf()
  echo(buf_id)
end

return M;
