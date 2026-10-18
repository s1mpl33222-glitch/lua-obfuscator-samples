-- This file was generated at discord.gg/syncrypt

local _ = game:GetService("HttpService")
local _ = game:GetService("TweenService")

local function _(p1, p2)
	local t1 = {}

	for i = 1, #p1 do
		local v6 = (p1[i] - p2[(i - 1) % #p2 + 1] + 256) % 256

		t1[i] = string.char(v6)
	end

	return table.concat(t1)
end
if not (function()
	local ok, result = pcall(function()
		return game.PlaceId
	end)

	if not ok or (type(result) ~= "number" and true or result <= 0) then
		return false
	end
end)() then
	return
end
