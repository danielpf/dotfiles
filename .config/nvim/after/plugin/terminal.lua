local k = require("danielf.keymap")

-- work in progress
local terminal_buffer_id
local terminal_window_id
local function open_terminal()
  local isListed = true
  local isScratch = true
  if terminal_buffer_id == nil then
    terminal_buffer_id = vim.api.nvim_create_buf(isListed,isScratch)
  end
  terminal_window_id = vim.api.nvim_open_win(terminal_buffer_id, true, {
    relative="editor",
    anchor="NE",
    width=120,
    height=120,
    col=100,
    row=10,
  })
  vim.api.nvim_open_term(terminal_buffer_id, {})
end

require("toggleterm").setup {
  start_in_insert = true,
  direction = "float"
}
k.nnoremap(k.alt_enter, function() vim.cmd("ToggleTerm") end)
k.tnoremap(k.alt_enter, function() vim.cmd("ToggleTerm") end) -- deactivate in term mode

k.tnoremap(k.esc, k.c_leftbar..k.c_n)

-- bottom command line navigation
k.cnoremap("<C-f>", "<Right>");
k.cnoremap("<C-b>", "<Left>");
k.cnoremap("<C-a>", "<Home>");
k.cnoremap("<M-b>", "<C-Left>");
k.cnoremap("<M-f>", "<C-Right>");

k.nnoremap(k.lead..k.lead, ":");
k.nnoremap(k.c_p, ":"..k.up)
