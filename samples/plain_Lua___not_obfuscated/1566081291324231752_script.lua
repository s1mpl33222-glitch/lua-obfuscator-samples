if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait() end
local gui = Players.LocalPlayer:WaitForChild("PlayerGui", 30)
if gui and time() < 45 then
  local last, calm, waited = -1, 0, 0
  while calm < 3 and waited < 45 do
    local n = #gui:GetChildren()
    if n > 0 and n == last then calm = calm + 1 else calm = 0 end
    last = n
    task.wait(1)
    waited = waited + 1
  end
end
task.wait(1)
local KEY = "MNTL-W46B-9X7Y-NFLN"
local Http = game:GetService("HttpService")
local SRC = "c"
local ok, hwid = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
if not ok or type(hwid) ~= "string" or hwid == "" then
  SRC = "g"
  ok, hwid = pcall(function() return gethwid and gethwid() end)
end
if not ok or type(hwid) ~= "string" or hwid == "" then error("[Mentally] Could not read your PC id. Try another executor.", 0) end
local src = game:HttpGet("https://mentally.lol/api/script?key=" .. KEY .. "&src=" .. SRC .. "&hwid=" .. Http:UrlEncode(hwid))
local fn, err = loadstring(src)
if not fn then error("[Mentally] Could not load the script: " .. tostring(err), 0) end
return fn()