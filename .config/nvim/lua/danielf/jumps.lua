local M = {}

local function raw_jumplist()
  local raw = vim.fn.getjumplist()
  local raw_list = raw[1]
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
      table.insert(reduced_list, {
        bufnr = elem.bufnr,
        filename = vim.api.nvim_buf_get_name(elem.bufnr),
        lnum = {elem.lnum}
      })
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

  local curr_filename = vim.api.nvim_buf_get_name(0)
  local curr_entry = {
    filename = curr_filename,
    current = true
  }
  local skip_left = 0
  local skip_right = 0
  if curr_idx > 1 then
    local prev_entry = curr_list[curr_idx-1]
    if prev_entry.filename == curr_filename then
      skip_left = 1
      curr_entry.lnum = prev_entry.lnum
    end
  end
  if curr_idx < #curr_list then
    local next_entry = curr_list[curr_idx+1]
    if next_entry.filename == curr_filename then
      skip_right = 1
      curr_entry.rlnum = next_entry.rlnum
    end
  end
  if (curr_idx-skip_left-2) >= 1 then
    table.insert(slots, curr_list[curr_idx-skip_left-2])
  end
  if (curr_idx-skip_left-1) >= 1 then
    table.insert(slots, curr_list[curr_idx-skip_left-1])
  end
  table.insert(slots, curr_entry)
  if (curr_idx+skip_right+1) < #curr_list then
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

-- proj -------------------

local function not_in_dir(dir, elem)
  local path = DU.Path.new(elem.filename)
  return path:is_absolute() and not path:is_subdir(dir)
end

local function restrict_to_dir(dir, curr_list, curr_idx)
  if DU.is_empty(dir) then
    return curr_list, curr_idx
  end
  local new_first_idx = curr_idx
  if curr_idx > 1 then
    for i=curr_idx-1,1,-1 do
      if not_in_dir(dir, curr_list[i]) then
        break
      end
      new_first_idx = i
    end
  end
  local new_curr_idx = curr_idx - (new_first_idx-1)

  local new_list = {}
  for i=new_first_idx,#curr_list,1 do
    table.insert(new_list, curr_list[i])
  end

  return new_list, new_curr_idx
end

function M.proj_jumplist()
  local curr_list, curr_idx = compressed_jumplist()
  curr_list, curr_idx = restrict_to_dir(DP.root_dir, curr_list, curr_idx)
  return short_version(curr_list, curr_idx)
end

function M.proj_back()
  local lst, next_back_idx = raw_jumplist()
  if next_back_idx ~= nil and #lst > 1 then
    local next = lst[next_back_idx]
    if not not_in_dir(DP.root_dir, vim.api.nvim_buf_get_name(next.bufnr)) then
      vim.cmd("execute \"normal! \\<c-o>\"")
    end
  end
end

function M.proj_forward()
  local lst, next_back_idx = raw_jumplist()
  if next_back_idx ~= nil and #lst >= next_back_idx+2 then
    local next = lst[next_back_idx+2]
    P(next)
    if not not_in_dir(DP.root_dir, vim.api.nvim_buf_get_name(next.bufnr)) then
      vim.cmd("execute \"normal! \\<c-i>\"")
    end
  end
end

return M
