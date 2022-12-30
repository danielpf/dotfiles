local k = require("danielf.keymap");

local builtin = require('telescope.builtin');

k.nnoremap(k.lead..'th', builtin.help_tags);
k.nnoremap(k.lead..'tc', builtin.command_history);

-- look for pickers
k.nnoremap(k.lead..'ta', builtin.builtin);
k.nnoremap(k.lead..'ta', builtin.builtin);
k.nnoremap(k.lead.."tr", builtin.resume);
k.nnoremap(k.tab.."tp", builtin.pickers);

-- text search
k.nnoremap(k.lead..'tg', function()
  require('telescope').extensions.live_grep_args.live_grep_args({"--smart-case"});
end);
k.nnoremap(k.lead..'tG', builtin.grep_string);
k.nnoremap('<M-/>', builtin.search_history);
k.nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")});
end);

-- look for files
k.nnoremap(k.lead..'tb', function() builtin.buffers({ignore_current_buffer=true}) end);
k.nnoremap(k.lead..'to', builtin.oldfiles);
k.nnoremap(k.lead..'tf', function() builtin.find_files({hidden=true, no_ignore=true}) end);
k.nnoremap(k.c_f, builtin.current_buffer_fuzzy_find);
k.nnoremap(k.alt_f, function()
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




