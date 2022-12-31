local M = {};

local find_mapping = function(maps, lhs)
  for _,value in pairs(maps) do
    if value.lhs == lhs then
      return value
    end
  end
end

M._stack = {}

M.push = function(name, mode, new_mappings)
  local maps = vim.api.nvim_get_keymap(mode)

  local existing_maps = {};
  for lhs, rhs in pairs(new_mappings) do
    print("searching for:", lhs)
    local existing = find_mapping(maps, lhs)
    if existing then
      table.insert(existing_maps, existing);
    end
  end
  M._stack[name] = existing_maps;

  for lhs,rhs in pairs(new_mappings) do
    vim.keymap.set(mode, lhs, rhs)
  end
end

M.pop = function(name)
end


M.push("debug_mode","n",{
  ["Q"] = "echo 'hello'",
  ["<leader>st"] = "echo 'hello'",
  ["<leader>sz"] = "echo 'Goodbye'"
})

return M;
