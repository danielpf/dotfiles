
local Maybe = {}
function Maybe:of(val)
  local obj = {val=val}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Maybe:if_present(yesfunc,elsefunc)
  if self.val then
    return yesfunc(self.val)
  else
    if elsefunc then
      return elsefunc()
    end
  end
end

function Maybe:is_empty()
  return self.val == nil
end

function Maybe:empty()
  return Maybe:of(nil)
end

local function requireOpt(modname)
  local result = pcall(function() require(modname) end)
  if result then
    return Maybe:of(result)
  end
  return Maybe:empty()
end

return {
  List = require("plenary.collections.py_list"),
  Maybe = Maybe,
  requireOpt = requireOpt
}
