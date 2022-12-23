local function bind(mode, outer_opts)
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", {}, outer_opts or {}, opts or {});
    vim.keymap.set(mode, lhs, rhs, opts);
  end
end

local M = {};

M.nnoremap = bind("n");
M.vnoremap = bind("v");
M.inoremap = bind("i");
M.xnoremap = bind("x");
M.tnoremap = bind("t");

--[[
-- Allow buffer to only be bound to current buffer.
--]]
M.buf_nnoremap = bind("n", {buffer = 0});
M.buf_vnoremap = bind("v", {buffer = 0});
M.buf_inoremap = bind("i", {buffer = 0});
M.buf_xnoremap = bind("x", {buffer = 0});
M.buf_tnoremap = bind("t", {buffer = 0});

M.k_leader = "<leader>"
M.k_esc = "<Esc>"
M.k_enter = "<CR>"
M.k_c_leftbar = "<C-\\>"
M.k_c_n = "<C-n>"

M.f_leader = function(k)
  return M.k_leader .. k
end

M.f_control = function(k)
  return "<C-" .. k .. ">"
end

return M

