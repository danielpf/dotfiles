
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

local function requireOpt(modname)
  return Maybe:of(require(modname))
end

return {
  List = require("plenary.collections.py_list"),
  Maybe = Maybe,
  requireOpt = requireOpt
}
