-- KeyForge: this script must be run from a Roblox executor
return (function()
  local _m = "this script must be run from a Roblox executor"
  if type(warn) == "function" then warn("[KeyForge] " .. _m) end
  if type(print) == "function" then print("[KeyForge] " .. _m) end
  if type(error) == "function" then error(_m, 0) end
  return nil
end)()