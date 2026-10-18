-- RONIHUB SOURCE PROTECTOR :: bootstrapper
local Key = (getgenv and (getgenv().Key or getgenv().RONIHUB_KEY)) or _G.Key or shared.Key
if not Key or Key == '' then
  warn("[RONIHUB] no key set. get a key: https://ronihubprotection.lovable.app/getkey/d12df2b1f08d")
  warn("[RONIHUB] then: getgenv().Key = 'YOUR-KEY' before running the loadstring.")
  return
end
local ok, body = pcall(function() return game:HttpGet("https://ronihubprotection.lovable.app/api/public/raw/d12df2b1f08d?key=" .. tostring(Key)) end)
if not ok then warn('[RONIHUB] request failed: ' .. tostring(body)) return end
local fn, err = loadstring(body)
if not fn then warn('[RONIHUB] load failed: ' .. tostring(err)) return end
return fn()
