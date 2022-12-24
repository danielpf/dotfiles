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

M.k = {
  lead = "<leader>",
  leftbar = "\\",
  esc = "<Esc>",
  enter = "<CR>",
  c_a = "<C-a>",
  c_b = "<C-b>",
  c_c = "<C-c>",
  c_d = "<C-d>",
  c_e = "<C-e>",
  c_f = "<C-f>",
  c_g = "<C-g>",
  c_h = "<C-h>",
  c_i = "<C-i>",
  c_j = "<C-j>",
  c_k = "<C-k>",
  c_l = "<C-l>",
  c_m = "<C-m>",
  c_n = "<C-n>",
  c_o = "<C-o>",
  c_p = "<C-p>",
  c_k = "<C-k>",
  c_r = "<C-r>",
  c_s = "<C-s>",
  c_t = "<C-t>",
  c_u = "<C-u>",
  c_v = "<C-v>",
  c_x = "<C-x>",
  c_y = "<C-y>",
  c_z = "<C-z>",
  c_0 = "<C-0>",
  c_1 = "<C-1>",
  c_2 = "<C-2>",
  c_3 = "<C-3>",
  c_4 = "<C-4>",
  c_5 = "<C-5>",
  c_6 = "<C-6>",
  c_7 = "<C-7>",
  c_8 = "<C-8>",
  c_9 = "<C-9>",
  c_leftbar = "<C-\\>"
}

return M

