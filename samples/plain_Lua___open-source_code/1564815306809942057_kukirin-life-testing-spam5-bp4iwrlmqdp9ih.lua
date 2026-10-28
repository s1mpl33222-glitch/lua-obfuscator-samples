-- utility module
local M = {}
function M.round(n, dp)
  local mult = 10 ^ (dp or 0)
  return math.floor(n * mult + 0.5) / mult
end
return M