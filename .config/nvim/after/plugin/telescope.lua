local telescope = require("telescope")
if not telescope then return end
telescope.setup {
  defaults = {
  }
}

local builtin = require('telescope.builtin');

-- TODO: MAYBE_MODULE()

-- look for pickers
DK.nnoremap(DK.lead..'t', builtin.builtin);
DK.nnoremap(DK.lead..'ta', builtin.builtin);
DK.nnoremap(DK.lead.."tr", builtin.resume);
DK.nnoremap(DK.lead.."tp", builtin.pickers);

-- text search
DK.nnoremap(DK.lead..'sg', function()
  if DU.at_home() then
    builtin.live_grep({ search_dirs = DU.cfg_files() })
  else
    require('telescope').extensions.live_grep_args.live_grep_args({
      layout_config = {
        horizontal = {
          width = 200
        }
      }, "--smart-case", "--no-ignore-git",
    })
  end
end)
DK.nnoremap('<M-/>', builtin.search_history);
DK.nnoremap('<leader>sS', function()
  -- the advantage of this one is that the screen is unobstructed, I guess
  builtin.grep_string({ search = vim.fn.input("Grep > ")});
end);
DK.nnoremap(DK.lead..'ss', builtin.grep_string); -- search exact string?
DK.nnoremap(DK.lead..'/', builtin.search_history);

-- look for files
DK.nnoremap(DK.lead..'fo', function () builtin.oldfiles({only_cwd=true}) end);
DK.nnoremap(DK.lead..'ff', function() builtin.find_files({hidden=true, no_ignore=true}) end);
DK.nnoremap(DK.c_f, builtin.current_buffer_fuzzy_find);
DK.nnoremap(DK.alt_f, function()
  if DU.at_home() then
    builtin.find_files {
      find_command = DU.cfg_git_command('ls-files'),
      hidden=true,
      no_ignore=false,
    }
  else
    builtin.find_files({hidden=true, no_ignore=false})
  end
end);
DK.nnoremap(DK.lead..'fg', builtin.git_files);
-- DK.nnoremap(DK.lead..'fh', function () vim.cmd("Telescope harpoon marks") end);

-- vim
DK.nnoremap(DK.lead..'vh', builtin.help_tags);
DK.nnoremap(DK.lead..'vc', builtin.command_history);
DK.nnoremap(DK.lead..'vo', builtin.vim_options);
DK.nnoremap(DK.lead..'vl', builtin.loclist);
DK.nnoremap(DK.lead..'vr', builtin.registers);
DK.nnoremap(DK.lead..'vj', builtin.jumplist);
local telebuffer = function()
  builtin.buffers({ ignore_current_buffer=true })
end
DK.nnoremap(DK.lead..'vb', telebuffer);
DK.nnoremap(DK.c_b, telebuffer);
