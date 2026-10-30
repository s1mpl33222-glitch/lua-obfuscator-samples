-- Behaviour trace of a Unknown obfuscator script
-- NOTE: reconstructed from observed behaviour; branches that were not taken
--       during the trace are missing and conditions are only noted in comments.
-- run status: finished
-- 11 statements recorded in 0.02s
-- URLs requested:
--   https://api.obscuravm.com/k/5265db7b5d216d3e37dfff56b1dc806814a6fac996fb07b8?rx=1&op=hsnonce&c=dd0a8c1f4adb44df&r=ac2aa5&uid=0&pid=0
-- non-standard globals touched: gethwid

-- loadstring() of 2553 bytes: "local _HG=game.HttpGet local function _get(u) if _HG then return _HG(game,u) else return game:HttpGet(u) end end local B,PT,DL=\"https://api.obscuravm.com\",\"5265db7b5d216d3e37dfff56b1dc806814a6fac996fb"
local Players = game:GetService("Players")
local response = game:HttpGet("https://api.obscuravm.com/k/5265db7b5d216d3e37dfff56b1dc806814a6fac996fb07b8?rx=1&op=hsnonce&c=dd0a8c1f4adb44df&r=ac2aa5&uid=0&pid=0")
local result = response:match("\"nonce\"%s*:%s*\"([0-9a-f]+)\"")
-- identifyexecutor() -> "Wave"
gethwid()
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
RbxAnalyticsService:GetClientId()
game:HttpGet("https://api.obscuravm.com/fd707e33e0e945282997405a/5265db7b5d216d3e37dfff56b1dc806814a6fac996fb07b8/download" .. "?rt=1&n=" .. result)
local response2 = game:HttpGet("https://api.obscuravm.com/fd707e33e0e945282997405a/5265db7b5d216d3e37dfff56b1dc806814a6fac996fb07b8/download" .. "?n=" .. result .. "" .. "&plr=" .. Players.LocalPlayer.Name .. "&pid=0" .. "&exec=Wave" .. "&drt=")
loadstring(response2)()
