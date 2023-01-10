
local project = {}
local function load_project()
end
local function save_project()
end

local function add_points(filename, points)
  local entry = project[filename]
  if entry ~= nil then
    entry.points = entry.points + points
  else
    project[filename] = { points = 0 }
  end
end
local function get_points(filename)
  local entry = project[filename]
  if entry ~= nil then
    return entry.points
  else
    return 0
  end
end

local pinned = {}
local function init_pinned()
end

local MAX_OPEN_BUFFERS = 5

local container = DU.List.new({})
local function find_entry(bufnr)
  for idx,v in ipairs(container) do
    if v.bufnr == bufnr then
      return idx
    end
  end
  return nil
end
local function add_entry(bufnr)
  local idx = find_entry(bufnr)
    if idx == nil then
      container:push({ bufnr = bufnr, })
    end
end
local function rm_entry(bufnr)
  local idx = find_entry(bufnr)
  if idx ~= nil then
    container:remove(idx)
  end
end

local group = vim.api.nvim_create_augroup('buffer_ring', { clear = true })

vim.api.nvim_create_autocmd('BufAdd', { group = group,
  callback = function(ev)
    if not DU.is_editor(ev.buf) then
      return
    end
    add_entry(ev.buf)
    if #container > MAX_OPEN_BUFFERS then
      vim.schedule(function()
        vim.cmd("Bwipeout "..container[1].bufnr)
      end)
    end
  end
})
vim.api.nvim_create_autocmd('BufUnload', { group = group,
  callback = function(ev)
    if DU.is_editor(ev.buf) then
      rm_entry(ev.buf)
    end
  end
})

vim.api.nvim_create_autocmd('VimEnter', { group = group,
  callback = function()
    load_project()
  end
})
vim.api.nvim_create_autocmd('VimLeave', { group = group,
  callback = function()
    save_project()
  end
})


local M = {}
function M.list_buffers()
  return container
end
return M
