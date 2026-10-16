-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local _http_request = http_request
if not _http_request then
	_http_request = request

	if not _http_request then
		_http_request = syn.request or httprequest
	end
end
if not _http_request then
	error("BAN!")
end
local ClientId = game:GetService("RbxAnalyticsService"):GetClientId()
local PlaceId = game.PlaceId
local v5 = (function(p1)
	local s1 = ""

	for _ = 1, p1 do
		local v9 = math.random(1, 62)

		s1 ..= ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").sub("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", v9, v9)
	end

	return s1
end)(32)

print("Server response:", _http_request({
	Url = "https://invshbloader.capsov.workers.dev/",
	Method = "GET",
	Headers = {
		hwid = ClientId,
		placeid = tostring(PlaceId),
		nonce = v5,
		["User-Agent"] = "HitBoxWare"
	}
}).Body)
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("ACS_Engine"):WaitForChild("Events"):WaitForChild("FDMG"):FireServer(v1({ unpack({ -1E+24 }) }))
