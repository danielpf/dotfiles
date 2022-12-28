local k = require("danielf.keymap");

local builtin = require('telescope.builtin');

k.nnoremap(k.tab..k.tab, builtin.pickers);
k.nnoremap(k.lead..k.tab, builtin.resume);
k.nnoremap(k.lead..'ta', builtin.builtin);
k.nnoremap(k.lead..'tb', function() builtin.buffers({ignore_current_buffer=true}) end);
k.nnoremap(k.lead..'th', builtin.search_history);
k.nnoremap(k.lead..'to', builtin.oldfiles);
k.nnoremap(k.lead..'tc', builtin.command_history);
k.nnoremap(k.lead..'tv', function() builtin.find_files({hidden=true, cwd='~/.config/nvim'}) end);
k.nnoremap(k.lead..'tg', function() require('telescope').extensions.live_grep_args.live_grep_args({"--smart-case"}); end);
k.nnoremap(k.lead..'tf', function() builtin.find_files({hidden=true}) end);
k.nnoremap(k.c_f, builtin.current_buffer_fuzzy_find);

k.nnoremap('<C-p>', function()
  local home = os.getenv("HOME")
  if vim.fn.getcwd() == home then
    builtin.find_files {
      find_command = {
        "git",
        "--git-dir="..home.."/.cfg",
        "--work-tree="..home,
        "ls-files"
      },
      hidden=true,
      no_ignore=false,
    }
  else
    builtin.find_files({hidden=true, no_ignore=false})
  end
end);

k.nnoremap(k.lead..'gf', builtin.git_files);

k.nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")});
end);



