-- This file was generated at discord.gg/syncrypt

local s1 = "https://sparkhub.wtf/key"
if getgenv().SparkHubKeySystem then
	return
end
getgenv().SparkHubKeySystem = true
getgenv().UI_CLOSED = false
local TweenService = game:GetService("TweenService")
local _ = game:GetService("UserInputService")
local _ = game:GetService("CoreGui")
local _ = game:GetService("RunService")
local PlaceId = game.PlaceId
local function v7()
	local v8 = (identifyexecutor or (getexecutorname or function()
		return "Unknown"
	end))():lower()

	return (v8:find("xeno") or v8:find("solara")) and "xeno_solara" or "default"
end
PlaceId = ({
	["142823291"] = "ab0a4b56eabc57c167e7ac114e4a7e46"
})[tostring(PlaceId)]

if not PlaceId then
	PlaceId = (function()
		local v9 = tostring(game.PlaceId)

		if v9 == "11815767793" and true or v9 == "101993432229107" then
			return v7() == "xeno_solara" and "d40809af9c8a9656fe4de72793008c15" or "33ae7de816736908dbce2232d3f9f4b8"
		else
			if v9 == "94217045453265" and true or v9 == "100484168444874" then
				if v7() == "xeno_solara" then
					game.Players.LocalPlayer:Kick("unsupported executor")

					return nil
				else
					return "0f1e1ed816bba3a52ed4b62fae059a96"
				end

				return
			else
				return (v9 == "10449761463" or (v9 == "12360882630" or v9 == "13635175275")) and "4f3ce5ad68f12541980ad94d636140e1" or ((v9 == "606849621" or (v9 == "17190407811" or (v9 == "17190408132" or (v9 == "108098425719662" and true or v9 == "9780994092")))) and "929e5fcc132d987d208489e1ecd54c8b" or nil)
			end

			return
		end
	end)()

	if not PlaceId then
		s1 = warn
		TweenService = game.PlaceId
		s1("[Spark Hub] Unsupported game (PlaceId: " .. tostring(TweenService) .. ")")
		getgenv().SparkHubKeySystem = nil

		return
	end
end
s1, TweenService = pcall(function()
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. PlaceId .. ".lua"))()
end)

if s1 then
	getgenv().SparkHubKeySystem = nil

	return
end
warn("[Spark Hub] Keyless loader failed: " .. tostring(TweenService))
getgenv().SparkHubKeySystem = nil
