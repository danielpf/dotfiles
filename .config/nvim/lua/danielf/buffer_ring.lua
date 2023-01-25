local group = vim.api.nvim_create_augroup('buffer_ring', { clear = true })
local M = {}

local function should_ignore(bufnr, path)
  -- todo: filter non-project files
  if (vim.api.nvim_buf_get_option(bufnr, 'filetype') == "") or not DU.is_editor(bufnr) then
    return true
  end
  -- return path
  return false
end

local function proj_rel_path(filename)
  local path = DP.Path.new(filename)
  return tostring(path:normalize()), path
end

local function accept(bufnr, func)
  local filename, path = proj_rel_path(vim.api.nvim_buf_get_name(bufnr))
  if not should_ignore(bufnr, path) then
    func(bufnr, filename)
  end
end

local function hit_entry_store(entries, key, points)
  if points == nil then points = 0 end
  local entry = entries[key]
  if entry ~= nil then
    entry.points = entry.points + points
  else
    entry = { points = points }
    entries[key] = entry
  end
  return entry
end

-------

local persistent_file_entries = {}

-- vim.api.nvim_create_autocmd('VimEnter', { group = group,
--   callback = function()
--     -- load_project()
--   end
-- })
-- vim.api.nvim_create_autocmd('VimLeave', { group = group,
--   callback = function()
--     -- save_project()
--   end
-- })

------------

-- we need this to close buffers automatically
local buffer_entries = {}

local function hit_buffer(bufnr, file, points)
  if points == nil then
    points = 0
  end
  -- P("key "..bufnr)
  local buffer_entry = hit_entry_store(buffer_entries, bufnr, points*2)
  buffer_entry.filename = file
  hit_entry_store(persistent_file_entries, file, points)
end

local function remove_buffer(bufnr)
  buffer_entries[bufnr] = nil
  -- todo: iterate and remove only if unmodified
  if #previous_files == 1 then
    previous_files = {}
  else
    previous_files = previous_files:slice(2,#previous_files)
  end
end

vim.api.nvim_create_autocmd('BufEnter', { group = group,
  callback = function(ev)
    -- P("add "..vim.api.nvim_buf_get_option(ev.buf, 'filetype'))
    accept(ev.buf, function(bufnr, file)
      -- P("add yes "..vim.api.nvim_buf_get_option(bufnr, 'filetype'))
      hit_buffer(bufnr, file, 1)
    end)
  end
})
vim.api.nvim_create_autocmd('BufUnload', { group = group,
  callback = function(ev)
    -- P("unload "..ev.buf.." "..vim.api.nvim_buf_get_option(ev.buf, 'filetype'))
    accept(ev.buf, function(bufnr, file)
      -- P("unload yes "..ev.buf.." "..vim.api.nvim_buf_get_option(ev.buf, 'filetype'))
      hit_buffer(bufnr, file, -1)
    end)
  end
})

-- todo: every 2 min
local function schedule_unload()
  -- vim.defer_fn(function()
  --   vim.cmd("Bwipeout "..bufnr)
  -- end, 1000) -- todo: less time
  -- if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
  -- end
  -- if #previous_files > MAX_OPEN_BUFFERS then
  --   vim.defer_fn(function()
  --     vim.cmd("Bwipeout "..previous_files[1].bufnr)
  --   end, 1000) -- todo: less time
  -- end
end

local last_changed_file = nil
vim.api.nvim_create_autocmd({'TextChanged'}, {
  group = group,
  callback = function(ev)
    accept(ev.buf, function(_, file)
      last_changed=file
    end)
  end
})

------------

local function get_suggestions(exclude_set)
  local suggestion_set = {}

  for k,v in pairs(buffer_entries) do
    local is_excluded = vim.tbl_contains(exclude_set, v.filename)
    if not is_excluded then
      table.insert(suggestion_set, {
        filename = v.filename,
        points = v.points,
        modified = vim.api.nvim_buf_get_option(k, 'modified'),
      })
    end
  end

  -- local files = vim.tbl_map(function (e)
  --   return e
  -- end,
  -- file_ring)

  return suggestion_set
end

function M.statusline()
  local exclude_suggested = { }
  local line = ""

  local current_filename
  local curr_file_path = DP.root_dir_path
  accept(0, function (bufnr, filename)
    table.insert(exclude_suggested, filename)
    curr_file_path = DP.Path.new(current_filename):parent()
  end)

  local marks = {}
  -- local marks = vim.tbl_map(function(e)
  --   return proj_rel_path(e.filename)
  -- end, require("harpoon").get_mark_config().marks)

  local for_display = function(filename)
    local normalized_filename, path = proj_rel_path(filename)
    table.insert(exclude_suggested, normalized_filename)
    filename = DP.relativize_to(path, curr_file_path)
    filename = tostring(filename)
    if DU.is_empty(filename) then
      return ""
    else
      filename = DP.compact_name(filename)
      return DU.make_string_of_size(filename, 20)
    end
  end

  if last_changed_file ~= nil then
    line = line.."last-mod="..for_display(last_changed_file).." "
  end

  line = line.." ["
  local jumps = {}
  for _,e in ipairs(require("danielf.jumps").proj_jumplist()) do
    local lnum = e.lnum or {}
    local rlnum = e.rlnum or {}
    local s = ""
    if e.current then
      for i=1,#lnum,1 do
        s = s.."■"
      end
      s = s.."."
      for i=1,#rlnum,1 do
        s = s.."□"
      end
    else
      s = s..for_display(e.filename)
    end
    table.insert(jumps, s)
  end
  line = line..table.concat(jumps, " ")
  line = line.."]"

  local suggested_entries = {}
  for _,v in ipairs(get_suggestions(exclude_suggested)) do
    table.insert(suggested_entries, for_display(v.filename))
  end
  line = line.." "..table.concat(suggested_entries, " | ")
  return line
end

return M
