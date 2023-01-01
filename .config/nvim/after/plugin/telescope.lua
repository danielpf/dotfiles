local k = require("danielf.keymap");

local builtin = require('telescope.builtin');

-- look for pickers
k.nnoremap(k.lead..'t', builtin.builtin);
k.nnoremap(k.lead..'ta', builtin.builtin);
k.nnoremap(k.lead.."tr", builtin.resume);
k.nnoremap(k.tab.."tp", builtin.pickers);

-- text search
k.nnoremap(k.lead..'sg', function()
  require('telescope').extensions.live_grep_args.live_grep_args({
    "--smart-case",
    "--no-ignore-git"
  });
end);
k.nnoremap(k.lead..'ss', builtin.grep_string); -- search exact string?
k.nnoremap(k.lead..'/', builtin.search_history);
k.nnoremap('<M-/>', builtin.search_history);
k.nnoremap('<leader>sS', function()
  -- the advantage of this one is that the screen is unobstructed, I guess
  builtin.grep_string({ search = vim.fn.input("Grep > ")});
end);

-- look for files
k.nnoremap(k.lead..'vb', function() builtin.buffers({
  ignore_current_buffer=false
}) end);
k.nnoremap(k.lead..'fo', function () builtin.oldfiles({only_cwd=true}) end);
k.nnoremap(k.lead..'ff', function() builtin.find_files({hidden=true, no_ignore=true}) end);
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
k.nnoremap(k.lead..'fg', builtin.git_files);

-- vim
k.nnoremap(k.lead..'vh', builtin.help_tags);
k.nnoremap(k.lead..'vc', builtin.command_history);
k.nnoremap(k.lead..'vo', builtin.vim_options);
k.nnoremap(k.lead..'vl', builtin.loclist);

