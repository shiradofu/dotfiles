local M = {
  table = {}
}

--- Get table keys.
--@param t table
M.table.getkeys = function(t)
  local r = {}
  for key,_ in pairs(t) do
    table.insert(r, key)
  end
  return r
end

--- Merge tables shallowly.
--@param ... tables
M.table.merge = function (...)
  local r = {}
  local va = {...}
  for _,t in pairs(va) do
    for k,v in pairs(t) do r[k] = v end
  end
  return r
end

return M
