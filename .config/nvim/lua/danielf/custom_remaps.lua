local k = require("danielf.keymap");

vim.g.mapleader = " ";

local function will_exit()
  local count = 0
  for _,bufnr in pairs(vim.api.nvim_list_bufs()) do
    local isloaded = vim.api.nvim_buf_is_loaded(bufnr)
    if DU.is_editor(bufnr) and isloaded then
      count = count + 1
      if count > 1 then
        return false
      end
    end
  end
  local current = vim.api.nvim_get_current_buf()
  return DU.is_editor(current) and DU.is_empty(vim.api.nvim_buf_get_name(current))
end

-- k.inoremap(k.esc, k.c_c); -- to get out of dialogs; doesnt seem to work
-- todo: map esc to c-c for terminal?
k.nnoremap("<c-q>", k.command(":close<cr>"))
k.nnoremap("<s-q>", function()
  if will_exit() then
    if vim.fn.input("exit? y/n: ") == "y" then
      vim.cmd("qa")
    end
  else
    DC.requireOpt('bufdelete'):if_present(
      function(_) vim.cmd("Bdelete") end,
      function() vim.cmd("bd") end)
  end
end);
k.nnoremap("<s-w>",k.command("w"));
k.nnoremap("+",    k.command("noh"));
k.nnoremap(k.lead.."pv", "<cmd>Ex<CR>"); -- netrw

-- move selection in visual mode
k.vnoremap("J", ":m '>+1<CR>gv=gv");
k.vnoremap("K", ":m '<-2<CR>gv=gv");
k.vnoremap("H", "");
k.vnoremap("L", "");

k.nnoremap(k.c_a, "_");
k.nnoremap(k.c_j, "*");

k.nnoremap(k.c_d, k.c_d.."zz") -- keep cursor centered while scrolling
k.nnoremap(k.c_u, k.c_u.."zz")

k.nnoremap("n", "nzzzv"); -- keep cursor centered while searching
k.nnoremap("N", "Nzzzv");

-- editing
k.nnoremap("J", "mzJ`z"); -- join line

k.xnoremap(k.lead.."p", "\"_dP");
k.nnoremap(k.lead.."d", "\"_d");
k.vnoremap(k.lead.."d", "\"_d");

k.nnoremap("p", "p==")
k.nnoremap("P", "P==")
k.nnoremap(k.lead .. k.c_l, vim.lsp.buf.format);
k.nnoremap(k.c_l, "==");
k.vnoremap(k.c_l, "=");

-- window
k.nnoremap(k.up,     ":vert resize +5"..k.enter);
k.nnoremap(k.down,   ":vert resize -5"..k.enter);
k.nnoremap(k.s_up,   ":resize +5"..k.enter);
k.nnoremap(k.s_down, ":resize -5"..k.enter);


k.nnoremap(k.lead.."qn", ":cn<CR>");
k.nnoremap(k.lead.."qp", ":cN<CR>");


