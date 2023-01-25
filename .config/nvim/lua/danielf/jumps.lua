local M = {}

local function raw_jumplist()
  local raw = vim.fn.getjumplist()
  return raw[1], raw[2]
end

local function compressed_jumplist()
  local function add_pointer_at_end(lst)
    table.insert(lst, { })
    return lst, #lst
  end

  local raw_list, next_idx = raw_jumplist()
  if vim.tbl_isempty(raw_list) then
    return add_pointer_at_end({})
  end
  local function isCurr(elem)
    if next_idx == #raw_list then
      return false
    end
    local curr = raw_list[next_idx+1]
    return curr.bufnr == elem.bufnr and curr.lnum == elem.lnum
  end

  local reduced_list = {}
  local reduced_curr_idx
  for _,elem in pairs(raw_list) do
    local reduced_tail = reduced_list[#reduced_list]
    if isCurr(elem) then
      reduced_list, reduced_curr_idx = add_pointer_at_end(reduced_list)
    elseif reduced_tail == nil or reduced_tail.bufnr ~= elem.bufnr then
      local new_elem = {
        bufnr = elem.bufnr,
        lnum = {elem.lnum}
      }
      pcall(function() new_elem.filename = vim.api.nvim_buf_get_name(elem.bufnr) end)
      if not new_elem.filename then new_elem.filename = '?' end
      table.insert(reduced_list, new_elem)
    else
      table.insert(reduced_tail.lnum, elem.lnum)
    end
  end
  if reduced_curr_idx == nil then
    return add_pointer_at_end(reduced_list)
  end
  return reduced_list, reduced_curr_idx
end

local function short_version(curr_list, curr_idx)
  local slots = {}

  local curr_entry = curr_list[curr_idx]
  curr_entry.filename = vim.api.nvim_buf_get_name(0)
  curr_entry.current = true
  local skip_left = 0
  local skip_right = 0
  if curr_idx > 1 then
    local prev_entry = curr_list[curr_idx-1]
    if prev_entry.filename == curr_entry.filename then
      skip_left = 1
      curr_entry.lnum = prev_entry.lnum
    end
  end
  if curr_idx < #curr_list then
    local next_entry = curr_list[curr_idx+1]
    if next_entry.filename == curr_entry.filename then
      skip_right = 1
      curr_entry.rlnum = next_entry.lnum
    end
  end
  if (curr_idx-skip_left-2) >= 1 then
    table.insert(slots, curr_list[curr_idx-skip_left-2])
  end
  if (curr_idx-skip_left-1) >= 1 then
    table.insert(slots, curr_list[curr_idx-skip_left-1])
  end
  table.insert(slots, curr_entry)

  if (curr_idx+skip_right) < #curr_list then
    table.insert(slots, curr_list[curr_idx+skip_right+1])
  end
  -- if (curr_idx+skip_right+2) < #curr_list then
  --   table.insert(slots, curr_list[curr_idx+skip_right+2])
  -- end
  return slots
end

function M.jumplist()
  local curr_list, curr_idx = compressed_jumplist()
  return short_version(curr_list, curr_idx)
end

---- proj -------------------

local function is_proj_jump(dir, elem)
  local filename = elem.filename
  if filename == '?' then return false end
  if DU.is_empty(filename) then
    pcall(function() filename = vim.api.nvim_buf_get_name(elem.bufnr) end)
    if filename == nil then return false end
  end
  local is_editor = true
  pcall(function() is_editor = DU.is_editor(elem.bufnr) end)
  if not is_editor then return false end
  local path = DP.Path.new(filename)
  return (not path:is_absolute()) or path:is_subdir(dir)
end

local function filter_jumplist_to_dir(dir, curr_list, curr_idx)
  if DU.is_empty(dir) then return curr_list, curr_idx end

  local new_list = {}
  local new_curr_idx = 1

  local idx = 1
  for i=1,#curr_list,1 do
    local is_new_curr_idx = i == curr_idx
    if is_proj_jump(dir, curr_list[i]) or is_new_curr_idx then
      table.insert(new_list, curr_list[i])
      if is_new_curr_idx then new_curr_idx = idx end
      idx = idx + 1
    end
  end

  return new_list, new_curr_idx
end


function M.proj_jumplist()
  local curr_list, curr_idx = compressed_jumplist()
  curr_list, curr_idx = filter_jumplist_to_dir(DP.root_dir, curr_list, curr_idx)
  return short_version(curr_list, curr_idx)
end

function M.proj_back()
  local lst, next_back_idx = raw_jumplist()
  local count = 1
  for i=next_back_idx,1,-1 do
    if is_proj_jump(DP.root_dir, lst[i]) then
      vim.cmd("execute \"normal! "..count.."\\<c-o>\"")
      return true
    end
    count = count + 1
  end
  return false
end

function M.proj_forward()
  local lst, next_back_idx = raw_jumplist()
  local count = 1
  for i=next_back_idx+2,#lst,1 do
    if is_proj_jump(DP.root_dir, lst[i]) then
      vim.cmd("execute \"normal! "..count.."\\<c-i>\"")
      return true
    end
    count = count + 1
  end
  return false
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if DU.is_empty(vim.api.nvim_buf_get_name(0)) then
      vim.defer_fn(function()
        if M.proj_back() then
          vim.cmd("Bwipeout 1")
        end
      end, 200)
    end
  end
})

return M
