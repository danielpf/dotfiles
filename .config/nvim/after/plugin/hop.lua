local hop = require("hop")
hop.setup()

local directions = require("hop.hint").HintDirection

DK.nnoremap('f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end,
{remap=true})

DK.nnoremap('F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end,
{remap=true})

DK.nnoremap('t', 'HopPatternMW',
{remap=true})

-- vim.keymap.set('', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set('', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, {remap=true})
