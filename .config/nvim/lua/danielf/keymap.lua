local function bind(mode, outer_opts)
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", {}, outer_opts or {}, opts or {});
    vim.keymap.set(mode, lhs, rhs, opts);
  end
end

local M = {
  lead = "<leader>",
  tab = "<Tab>",
  leftbar = "\\",
  esc = "<Esc>",
  enter = "<CR>",
  c_leftbar = "<C-\\>",
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
  c_q = "<C-q>",
  c_r = "<C-r>",
  c_s = "<C-s>",
  c_t = "<C-t>",
  c_u = "<C-u>",
  c_v = "<C-v>",
  c_w = "<C-w>",
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
  alt_a = "<M-a>",
  alt_b = "<M-b>",
  alt_c = "<M-c>",
  alt_d = "<M-d>",
  alt_e = "<M-e>",
  alt_f = "<M-f>",
  alt_g = "<M-g>",
  alt_h = "<M-h>",
  alt_i = "<M-i>",
  alt_j = "<M-j>",
  alt_k = "<M-k>",
  alt_l = "<M-l>",
  alt_m = "<M-m>",
  alt_n = "<M-n>",
  alt_o = "<M-o>",
  alt_p = "<M-p>",
  alt_q = "<M-q>",
  alt_r = "<M-r>",
  alt_s = "<M-s>",
  alt_t = "<M-t>",
  alt_u = "<M-u>",
  alt_v = "<M-v>",
  alt_w = "<M-w>",
  alt_x = "<M-x>",
  alt_y = "<M-y>",
  alt_z = "<M-z>",
  alt_0 = "<M-0>",
  alt_1 = "<M-1>",
  alt_2 = "<M-2>",
  alt_3 = "<M-3>",
  alt_4 = "<M-4>",
  alt_5 = "<M-5>",
  alt_6 = "<M-6>",
  alt_7 = "<M-7>",
  alt_8 = "<M-8>",
  alt_9 = "<M-9>",
  s_a = "<S-a>",
  s_b = "<S-b>",
  s_c = "<S-c>",
  s_d = "<S-d>",
  s_e = "<S-e>",
  s_f = "<S-f>",
  s_g = "<S-g>",
  s_h = "<S-h>",
  s_i = "<S-i>",
  s_j = "<S-j>",
  s_k = "<S-k>",
  s_l = "<S-l>",
  s_m = "<S-m>",
  s_n = "<S-n>",
  s_o = "<S-o>",
  s_p = "<S-p>",
  s_q = "<S-q>",
  s_r = "<S-r>",
  s_s = "<S-s>",
  s_t = "<S-t>",
  s_u = "<S-u>",
  s_v = "<S-v>",
  s_w = "<S-w>",
  s_x = "<S-x>",
  s_y = "<S-y>",
  s_z = "<S-z>",
  left      = "<Left>",
  right     = "<Right>",
  up        = "<Up>",
  down      = "<Down>",
  c_left    = "<C-Left>",
  c_right   = "<C-Right>",
  c_up      = "<C-Up>",
  c_down    = "<C-Down>",
  s_left    = "<S-Left>",
  s_right   = "<S-Right>",
  s_up      = "<S-Up>",
  s_down    = "<S-Down>",
  alt_left  = "<M-Left>",
  alt_right = "<M-Right>",
  alt_up    = "<M-Up>",
  alt_down  = "<M-Down>"
};

M.nnoremap = bind("n");
M.vnoremap = bind("v");
M.inoremap = bind("i");
M.xnoremap = bind("x");
M.tnoremap = bind("t");
M.cnoremap = bind("c");

--[[
-- Allow buffer to only be bound to current buffer.
--]]
M.buf_nnoremap = bind("n", {buffer = 0});
M.buf_vnoremap = bind("v", {buffer = 0});
M.buf_inoremap = bind("i", {buffer = 0});
M.buf_xnoremap = bind("x", {buffer = 0});
M.buf_tnoremap = bind("t", {buffer = 0});
M.buf_cnoremap = bind("c", {buffer = 0});

M.k = M;

return M

