-- This file was generated at discord.gg/syncrypt

local function v1(...)
	return {
		...,
		["n"] = select("#", ...),
	}
end
local function v2(p1, p2, p3, p4)
	for i = p4, p3.n do
		local v4 = p3[i]

		p1[i - p4 + p2] = v4
	end
end

pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LynX99-9/komtolmmek2/refs/heads/main/Adonis"))()
end)
pcall(function()
	game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]:Destroy()
end)
getgenv().WindUI = nil

local ok, windUI = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if ok and windUI then
	getgenv().WindUI = windUI
else
	ok, windUI = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
	end)

	if ok and windUI then
		getgenv().WindUI = windUI
	end
end

if not getgenv().WindUI then
	getgenv().WindUI = {
		["Notify"] = function(p5)
			game:GetService("StarterGui"):SetCore("SendNotification", {
				["Title"] = p5.Title or "Notification",
				["Text"] = p5.Content or "",
				["Duration"] = p5.Duration or 3,
			})
		end,
	}
end

getgenv().Players = game:GetService("Players")
getgenv().Workspace = game:GetService("Workspace")
getgenv().VIM = game:GetService("VirtualInputManager")
getgenv().RS = game:GetService("ReplicatedStorage")
getgenv().TweenService = game:GetService("TweenService")
getgenv().RunService = game:GetService("RunService")
getgenv().UserInputService = game:GetService("UserInputService")
getgenv().LP = Players.LocalPlayer
getgenv().HttpService = game:GetService("HttpService")
getgenv().ProximityPromptService = game:GetService("ProximityPromptService")
getgenv().VirtualUser = game:GetService("VirtualUser")
getgenv().noclipConn = nil
getgenv().pauseBypassEnabled = false
getgenv().pauseCheckConnection = nil
getgenv().instantInteractEnabled = false
getgenv().START_JOB = Vector3.new(-5110, 5, -3759)
getgenv().DESTINATIONS = {
	["1"] = {
		["name"] = "Faroka",
		["pos"] = Vector3.new(-6795, 3, -446),
	},
	["2"] = {
		["name"] = "Karangasem",
		["pos"] = Vector3.new(-8385, 2, -3821),
	},
	["3"] = {
		["name"] = "Kleco",
		["pos"] = Vector3.new(-8779, 3, 647),
	},
	["4"] = {
		["name"] = "Manahan",
		["pos"] = Vector3.new(1123, 3, -4162),
	},
	["5"] = {
		["name"] = "Pajang",
		["pos"] = Vector3.new(-6741, 4, 7172),
	},
	["6"] = {
		["name"] = "Klodran",
		["pos"] = Vector3.new(-3351, 30, -8161),
	},
	["7"] = {
		["name"] = "Colomandu",
		["pos"] = Vector3.new(-9964, 3, -4054),
	},
	["8"] = {
		["name"] = "Klaten",
		["pos"] = Vector3.new(-17052, 105, 6567),
	},
}
getgenv().CourierAutoFarm = false
getgenv().CurrentDest = nil
getgenv().HasJob = false
getgenv().WaitingForNextQuest = false
getgenv().isFrozen = false
getgenv().OfficeAutoFarm = false
getgenv().OfficeAnswerCount = 0
getgenv().OfficeAnsweredIDs = {}
getgenv().OFFICE_CHAIR_POS = Vector3.new(-5943.5, 4.5, -261)
getgenv().OFFICE_CHAIR_ROT = 3.141592653589793
getgenv().OFFICE_EARN_LIMIT = 1000000
getgenv().officeResetting = false
getgenv()._officeWatchConn = nil
getgenv()._officePrinterBusy = false
getgenv()._lastPrinterState = false
getgenv()._questionEventConn = nil
getgenv()._correctAnswerConn = nil
getgenv().QuestAutoFarm = false
getgenv().CurrentQuest = nil
getgenv().QuestCompleted = 0
getgenv().AutoDriveEnabled = false
getgenv().autoDriveThread = nil
getgenv().AUTO_DRIVE_POS1 = Vector3.new(-757, 2, -638)
getgenv().AUTO_DRIVE_POS2 = Vector3.new(3741, 2, -653)
getgenv().AUTO_DRIVE_SPEED = 200
getgenv().AUTO_DRIVE_HEIGHT = 2
getgenv().AUTO_DRIVE_MOTOR = "Yamahax-MioSporty"
getgenv().AUTO_DRIVE_START = Vector3.new(-716, 3, -706)
getgenv().AUTO_DRIVE_ENTER = Vector3.new(-717, 3, -722)
getgenv().AutoGPEnabled = false
getgenv().autoGPThread = nil
ok = getgenv()
windUI = {}

local vector3 = Vector3.new(591, -5, -1207)
local vector32 = Vector3.new(1216, -5, -1200)
local vector33 = Vector3.new(1509, -5, -1213)
local vector34 = Vector3.new(1697, -5, -1095)
local vector35 = Vector3.new(1728, -5, -294)
local vector36 = Vector3.new(2496, -5, 253)
local vector37 = Vector3.new(3442, -5, 920)
local vector38 = Vector3.new(3302, -5, 1247)
local vector39 = Vector3.new(3157, -5, 1211)
local vector310 = Vector3.new(2705, -5, 744)
local vector311 = Vector3.new(2326, -5, 330)
local vector312 = Vector3.new(1370, -5, -226)
local vector313 = Vector3.new(1451, -5, -380)
local vector314 = Vector3.new(1409, -5, -473)
local vector315 = Vector3.new(603, -5, -484)
local vector316 = Vector3.new(-185, -5, -516)

windUI[1] = vector3
windUI[2] = vector32
windUI[3] = vector33
windUI[4] = vector34
windUI[5] = vector35
windUI[6] = vector36
windUI[7] = vector37
windUI[8] = vector38
windUI[9] = vector39
windUI[10] = vector310
windUI[11] = vector311
windUI[12] = vector312
windUI[13] = vector313
windUI[14] = vector314
windUI[15] = vector315
windUI[16] = vector316
vector3 = Vector3.new(-350, -5, -962)
vector32 = Vector3.new(-493, -5, -992)
vector33 = Vector3.new(-1779, -5, -751)
vector34 = Vector3.new(-1867, -5, -931)
vector35 = Vector3.new(-1685, -5, -1214)
vector36 = Vector3.new(-637, -5, -1208)
vector37 = v1(Vector3.new(704, -5, -1205))
windUI[17] = vector3
windUI[18] = vector32
windUI[19] = vector33
windUI[20] = vector34
windUI[21] = vector35
windUI[22] = vector36
v2(windUI, 23, vector37, 1)
ok.GP_TRACK = windUI
getgenv().GP_MOTOR = "Yamahax-MioSporty"
getgenv().GP_SPEED = 150
getgenv().VEHICLE_ENTER_HOLD = 1.5
getgenv().AutoDragEnabled = false
getgenv().autoDragThread = nil
getgenv().AutoDragRaceEnabled = false
getgenv().autoDragRaceThread = nil
getgenv().DRAG_MODE = "time_trial"
getgenv().DRAG_SLOT = 1
getgenv().DRAG_SPEED = 150
ok = getgenv()
windUI = {
	["time_trial"] = {
		{
			["start"] = Vector3.new(78, -5, -867),
			["mid"] = Vector3.new(695, -5, -868),
			["finish"] = Vector3.new(1296, -5, -866),
		},
		{
			["start"] = Vector3.new(78, -5, -838),
			["mid"] = Vector3.new(696, -5, -838),
			["finish"] = Vector3.new(1296, -5, -837),
		},
	},
	["tournament"] = {
		{
			["start"] = Vector3.new(75, -5, -795),
			["mid"] = Vector3.new(696, -5, -794),
			["finish"] = Vector3.new(1296, -5, -796),
		},
		{
			["start"] = Vector3.new(72, -5, -766),
			["mid"] = Vector3.new(695, -5, -766),
			["finish"] = Vector3.new(1296, -5, -766),
		},
	},
}
ok.DragSlotData = windUI
getgenv().DRAG_RACE_FAST_DELAY1 = 3.7
getgenv().DRAG_RACE_FAST_DELAY2 = 3.7
getgenv().AutoPettaraniEnabled = false
getgenv().autoPettaraniThread = nil
getgenv().PETTARANI_MOTOR = "Yamahax-MioSporty"
getgenv().PETTARANI_SPEED = 150
getgenv().PETTARANI_SPAWN_POS = Vector3.new(202, 14, -2713)
getgenv().PETTARANI_ENTER_POS = Vector3.new(201, 14, -2728)
getgenv().PETTARANI_START_POS = Vector3.new(-56, 14, 1206)
ok = getgenv()
windUI = {}
vector3 = Vector3.new(-56, 14, 1206)
vector32 = Vector3.new(-67, 14, 992)
vector33 = Vector3.new(-70, 14, 7)
vector34 = Vector3.new(-65, 14, -819)
vector35 = Vector3.new(-100, 14, -1479)
vector36 = Vector3.new(-184, 14, -2469)
vector37 = Vector3.new(-219, 14, -2782)
vector38 = Vector3.new(-197, 14, -2791)
vector39 = Vector3.new(-121, 14, -2833)
vector310 = Vector3.new(-63, 14, -2838)
vector311 = Vector3.new(226, 14, -2861)
vector312 = Vector3.new(875, 14, -2916)
vector313 = Vector3.new(962, 14, -2924)
vector314 = Vector3.new(971, 14, -2871)
vector315 = Vector3.new(718, 14, -2846)
vector316 = Vector3.new(-140, 14, -2775)
windUI[1] = vector3
windUI[2] = vector32
windUI[3] = vector33
windUI[4] = vector34
windUI[5] = vector35
windUI[6] = vector36
windUI[7] = vector37
windUI[8] = vector38
windUI[9] = vector39
windUI[10] = vector310
windUI[11] = vector311
windUI[12] = vector312
windUI[13] = vector313
windUI[14] = vector314
windUI[15] = vector315
windUI[16] = vector316
vector3 = Vector3.new(-231, 14, -2785)
vector32 = Vector3.new(-227, 14, -2860)
vector33 = Vector3.new(-283, 14, -3544)
vector34 = Vector3.new(-337, 14, -4801)
vector35 = Vector3.new(-355, 14, -5985)
vector36 = Vector3.new(-383, 14, -7247)
vector37 = Vector3.new(-419, 14, -8295)
vector38 = Vector3.new(-421, 14, -8460)
vector39 = Vector3.new(-420, 15, -8488)
vector310 = Vector3.new(-422, 16, -8507)
vector311 = Vector3.new(-423, 23, -8646)
vector312 = Vector3.new(-437, 53, -9215)
vector313 = Vector3.new(-437, 53, -9238)
vector314 = Vector3.new(-432, 53, -9288)
vector315 = Vector3.new(-430, 53, -9341)
vector316 = Vector3.new(-404, 53, -9583)
windUI[17] = vector3
windUI[18] = vector32
windUI[19] = vector33
windUI[20] = vector34
windUI[21] = vector35
windUI[22] = vector36
windUI[23] = vector37
windUI[24] = vector38
windUI[25] = vector39
windUI[26] = vector310
windUI[27] = vector311
windUI[28] = vector312
windUI[29] = vector313
windUI[30] = vector314
windUI[31] = vector315
windUI[32] = vector316
vector3 = Vector3.new(-398, 53, -9637)
vector32 = Vector3.new(-397, 53, -9682)
vector33 = Vector3.new(-404, 54, -9833)
vector34 = Vector3.new(-360, 54, -9835)
vector35 = Vector3.new(-359, 53, -9797)
vector36 = Vector3.new(-340, 53, -8643)
vector37 = Vector3.new(-324, 53, -7749)
vector38 = Vector3.new(-292, 53, -7630)
vector39 = Vector3.new(-282, 53, -7515)
vector310 = Vector3.new(-269, 53, -7362)
vector311 = Vector3.new(-268, 50, -7304)
vector312 = Vector3.new(-264, 37, -7109)
vector313 = Vector3.new(-260, 16, -6816)
vector314 = Vector3.new(-260, 14, -6741)
vector315 = Vector3.new(-259, 14, -6539)
vector316 = Vector3.new(-280, 14, -6416)
windUI[33] = vector3
windUI[34] = vector32
windUI[35] = vector33
windUI[36] = vector34
windUI[37] = vector35
windUI[38] = vector36
windUI[39] = vector37
windUI[40] = vector38
windUI[41] = vector39
windUI[42] = vector310
windUI[43] = vector311
windUI[44] = vector312
windUI[45] = vector313
windUI[46] = vector314
windUI[47] = vector315
windUI[48] = vector316
vector3 = Vector3.new(-256, 14, -4766)
vector32 = Vector3.new(-189, 14, -3282)
vector33 = Vector3.new(-90, 14, -2131)
vector34 = Vector3.new(-17, 14, -837)
vector35 = Vector3.new(11, 14, -810)
vector36 = Vector3.new(26, 14, -808)
vector37 = Vector3.new(119, 14, -811)
vector38 = Vector3.new(702, 14, -833)
vector39 = Vector3.new(788, 14, -836)
vector310 = Vector3.new(795, 14, -797)
vector311 = Vector3.new(615, 14, -791)
vector312 = Vector3.new(14, 14, -773)
vector313 = Vector3.new(-6, 14, -733)
vector314 = Vector3.new(-7, 14, -697)
vector315 = Vector3.new(-4, 14, 791)
vector316 = Vector3.new(-12, 14, 1036)
windUI[49] = vector3
windUI[50] = vector32
windUI[51] = vector33
windUI[52] = vector34
windUI[53] = vector35
windUI[54] = vector36
windUI[55] = vector37
windUI[56] = vector38
windUI[57] = vector39
windUI[58] = vector310
windUI[59] = vector311
windUI[60] = vector312
windUI[61] = vector313
windUI[62] = vector314
windUI[63] = vector315
windUI[64] = vector316
vector3 = Vector3.new(-72, 14, 1145)
vector32 = v1(Vector3.new(-70, 14, 1175))
windUI[65] = vector3
v2(windUI, 66, vector32, 1)
ok.PETTARANI_TRACK = windUI
getgenv().AutoDragPettaraniEnabled = false
getgenv().autoDragPettaraniThread = nil
getgenv().DRAG_PETTARANI_MOTOR = "Yamahax-MioSporty"
getgenv().DRAG_PETTARANI_SPEED = 150
getgenv().DRAG_PETTARANI_SPAWN_POS = Vector3.new(202, 14, -2713)
getgenv().DRAG_PETTARANI_ENTER_POS = Vector3.new(201, 14, -2728)
ok = getgenv()
windUI = {}
vector3 = Vector3.new(-44, 53, -150)
vector32 = Vector3.new(-42, 53, -751)
vector33 = Vector3.new(-48, 53, -853)
vector34 = Vector3.new(-68, 53, -1281)
vector35 = Vector3.new(-105, 53, -1772)
vector36 = Vector3.new(-206, 53, -2900)
vector37 = Vector3.new(-241, 53, -3313)
vector38 = Vector3.new(-298, 53, -4439)
vector39 = Vector3.new(-305, 53, -4789)
vector310 = Vector3.new(-351, 53, -7331)
vector311 = v1(Vector3.new(-384, 53, -9520))
__set_list(windUI, 1, { vector3, vector32, vector33, vector34, vector35, vector36, vector37, vector38, vector39, vector310, unpack(vector311, 1, vector311.n) })
ok.DRAG_PETTARANI_TRACK = windUI
getgenv().webhookURL = ""
getgenv().kickWebhookEnabled = false
getgenv().earnWebhookEnabled = false
getgenv().earnWebhookInterval = 60
getgenv().earnWebhookThread = nil
getgenv().webhookTotalEarnings = 0
getgenv().webhookLastNotif = ""
getgenv()._kickDetectConn = nil
getgenv().antiAdminEnabled = false
getgenv().antiAdminConn = nil
getgenv().ADMIN_USERS = {
	["PAK_BODONQ"] = 2617603293,
	["ADVRN12345"] = 1658383033,
}
getgenv()._cyraaLogoCache = nil

function GetCyraaLogoURL()
	if getgenv()._cyraaLogoCache then
		return getgenv()._cyraaLogoCache
	end
end
function GetAvatarURL(p6)
	return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(p6) .. "&width=420&height=420&format=png"
end
function SendWebhook(p7, _)
	if not (p7 and p7 ~= "") then
		return false, "No URL"
	end
end
function BuildEmbed(p8, p9, p10)
	return {
		["title"] = p8,
		["description"] = p9,
		["color"] = 3066993,
		["fields"] = p10 or {},
		["footer"] = {
			["text"] = "Cyraa Hub v1.0.7 | by komtolmmek2",
			["icon_url"] = GetCyraaLogoURL(),
		},
		["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
	}
end
function GetPlayerCash()
	local s1

	pcall(function()
		local leaderstats = LP:FindFirstChild("leaderstats")

		if not leaderstats then
			return
		end
		local v25, v26

		leaderstats, v25, v26 = pairs(leaderstats:GetChildren())

		while true do
			local v27

			v26, v27 = leaderstats(v25, v26)

			if v26 == nil then
				break
			end

			if v27:IsA("IntValue") or (v27:IsA("NumberValue") or v27:IsA("StringValue")) then
				leaderstats = v27.Value
				s1 = tostring(leaderstats)

				return
			end
		end
	end)

	return "N/A"
end
function SendKickWebhook(p11)
	if kickWebhookEnabled and webhookURL ~= "" then
		local BuildEmbed_ = BuildEmbed
		local t2 = {
			["name"] = "Player Name :",
			["value"] = "> ||**" .. LP.Name .. "**||",
			["inline"] = false,
		}
		local t3 = {
			["name"] = "User ID :",
		}
		local UserId = LP.UserId

		t3.value = "> ||`" .. tostring(UserId) .. "`||"
		t3.inline = false
		UserId = {
			["name"] = "Kick Reason :",
			["value"] = "> `" .. ((p11 == "" or not p11) and "unknown" or p11) .. "`",
			["inline"] = false,
		}

		local t4 = {
			["name"] = "Server ID :",
		}
		local JobId = game.JobId

		t4.value = "> `" .. tostring(JobId):sub(1, 18) .. "`"
		t4.inline = false

		local t1 = {
			t2,
			t3,
			UserId,
			t4,
			{
				["name"] = "Game :",
				["value"] = "> `Drag Drive Simulator`",
				["inline"] = false,
			},
		}

		BuildEmbed_ = BuildEmbed("Cyraa Hub | Player Kicked", "You have been removed from the server.", t1)
		pcall(SendWebhook, webhookURL, {
			["username"] = "Cyraa Hub - Kick Alert",
			["avatar_url"] = GetCyraaLogoURL(),
			["embeds"] = { BuildEmbed_ },
		})

		return
	else
		return
	end
end

ok = function()
	if _kickDetectConn then
		pcall(function()
			_kickDetectConn:Disconnect()
		end)
	end

	_kickDetectConn = LP.AncestryChanged:Connect(function(_, parent)
		if not (parent == nil and (kickWebhookEnabled and webhookURL ~= "")) then
			return
		end
		local s2

		pcall(function()
			local v36, v37, v38 = pairs(game:GetService("CoreGui"):GetDescendants())

			while true do
				local Text

				v38, Text = v36(v37, v38)

				if v38 == nil then
					break
				end

				if (Text:IsA("TextLabel") or Text:IsA("TextButton")) and Text.Visible then
					Text = Text.Text or ""

					if not ((#Text <= 10 or not Text:lower():find("kick")) and not (Text:lower():find("removed") or Text:lower():find("banned"))) then
						s2 = Text

						return
					end
				end
			end
		end)
		SendKickWebhook("You were removed from the server.")
	end)
end
ok()
windUI = LP.CharacterAdded

local v40 = ok

windUI:Connect(function()
	v40()
end)

function IsAdminPlayer(p12)
	if ADMIN_USERS[p12.Name] then
		return true
	else
		local v41, v42, v43 = pairs(ADMIN_USERS)

		while true do
			local v44

			v43, v44 = v41(v42, v43)

			if v43 == nil then
				break
			end

			if p12.UserId == v44 then
				return true
			end
		end

		return false
	end
end
function SendAdminWebhook(p13)
	if antiAdminEnabled and webhookURL ~= "" then
		local UserId = p13.UserId

		UserId = tostring(UserId)

		local Name = p13.Name
		local JobId = game.JobId

		JobId = tostring(JobId):sub(1, 18)

		local BuildEmbed_ = BuildEmbed

		Name = {
			["name"] = "Admin Name :",
			["value"] = "> **" .. Name .. "**",
			["inline"] = false,
		}
		UserId = {
			["name"] = "Admin ID :",
			["value"] = "> `" .. UserId .. "`",
			["inline"] = false,
		}
		JobId = {
			["name"] = "Server JobID :",
			["value"] = "> `" .. JobId .. "`",
			["inline"] = false,
		}

		local t5 = {
			Name,
			UserId,
			JobId,
		}

		UserId = BuildEmbed("Admin Detected - Cyraa Hub", "An admin has joined your server! Auto-leaving now...", t5)
		pcall(SendWebhook, webhookURL, {
			["username"] = "Cyraa Hub - Admin Alert",
			["avatar_url"] = GetCyraaLogoURL(),
			["embeds"] = { UserId },
		})

		return
	else
		return
	end
end
function DoAntiAdminLeave(p14, p15)
	local spawn = task.spawn
	local v51 = p15

	spawn(function()
		if not (antiAdminEnabled and (webhookURL ~= "" and v51)) then
			return
		end

		SendAdminWebhook(v51)
	end)
	WindUI:Notify({
		["Title"] = "Admin Detected!",
		["Content"] = p14 .. " joined! Auto-leaving server...",
		["Duration"] = 4,
	})
	task.wait(1.5)
	pcall(function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
	end)
end
function EnableAntiAdmin()
	local v52, v53, v54 = pairs(Players:GetPlayers())

	while true do
		local v55

		v54, v55 = v52(v53, v54)

		if v54 == nil then
			break
		end

		if not (v55 == LP or not IsAdminPlayer(v55)) then
			task.spawn(DoAntiAdminLeave, v55.Name, v55)

			return
		end
	end

	if antiAdminConn then
		antiAdminConn:Disconnect()
	end

	antiAdminConn = Players.PlayerAdded:Connect(function(player)
		if not antiAdminEnabled then
			return
		end

		if not IsAdminPlayer(player) then
			return
		end

		task.spawn(DoAntiAdminLeave, player.Name, player)
	end)
end
function DisableAntiAdmin()
	if not antiAdminConn then
		return
	end

	antiAdminConn:Disconnect()
	antiAdminConn = nil
end

getgenv().savedBaristaSeats = {}

function removeBaristaSeats()
	getgenv().savedBaristaSeats = {}
	pcall(function()
		local v56 = workspace.BUILDING_JAJAR_SELATAN:GetChildren()[8]

		if not v56 then
			return
		end
	end)
end
function restoreBaristaSeats()
	pcall(function()
		local v57, v58, v59 = pairs(getgenv().savedBaristaSeats)

		while true do
			local v60

			v59, v60 = v57(v58, v59)

			if v59 == nil then
				break
			end

			if v60.instance and v60.parent then
				local pcall_ = pcall
				local v62 = v60

				pcall(function()
					v62.instance.Parent = v62.parent
				end)
			end
		end
	end)
	getgenv().savedBaristaSeats = {}
end
function GetHRP()
	local Character = LP.Character

	if not Character then
		return Character
	end

	Character = LP.Character:FindFirstChild("HumanoidRootPart")

	return Character
end
function GetHum()
	local Character = LP.Character

	if not Character then
		return Character
	end

	Character = LP.Character:FindFirstChildOfClass("Humanoid")

	return Character
end
function Char()
	return LP.Character or LP.CharacterAdded:Wait()
end
function PressE()
	VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.25)
	VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end
function HoldE(p16)
	VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(p16)
	VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end
function WalkThroughWaypoints(p17, p18, p19, p20, p21, p22)
	local v65, v66, v67 = ipairs(p19)
	local v68 = p20 or 16
	local v69 = p21 or 20

	while true do
		local v70

		v67, v70 = v65(v66, v67)

		if v67 == nil or p22 and p22() then
			break
		end

		WalkTo(p17, p18, v70, v68, v69, p22)

		if p22 and p22() then
			p17:MoveTo(p18.Position)
			p17.WalkSpeed = 16

			return
		end
	end

	p17:MoveTo(p18.Position)
	p17.WalkSpeed = 16
end
function WalkTo(p23, p24, p25, p26, p27, p28)
	local v71 = p27 or 20

	p23.WalkSpeed = p26 or 16

	local waypoints = game:GetService("PathfindingService"):CreatePath({
		["AgentRadius"] = 2,
		["AgentHeight"] = 5,
		["AgentCanJump"] = true,
		["AgentCanClimb"] = false,
		["WaypointSpacing"] = 4,
	})
	local pcall_ = pcall
	local v74 = waypoints
	local v75 = p24
	local v76 = p25
	local pcall_2

	pcall_, pcall_2 = pcall(function()
		v74:ComputeAsync(v75.Position, v76)
	end)

	if pcall_ then
		waypoints = waypoints.Status == Enum.PathStatus.Success and waypoints:GetWaypoints() or nil
	else
		waypoints = nil
	end

	local connection

	if waypoints and #waypoints > 1 then
		v71, waypoints, pcall_ = ipairs(waypoints)

		while true do
			pcall_, pcall_2 = v71(waypoints, pcall_)

			if pcall_ == nil or p28 and p28() then
				break
			end

			if pcall_2.Action == Enum.PathWaypointAction.Jump then
				p23:ChangeState(Enum.HumanoidStateType.Jumping)
			end

			p23:MoveTo(pcall_2.Position)

			local u79 = false

			connection = p23.MoveToFinished:Connect(function()
				u79 = true
			end)

			local v80 = tick() + 4
			local Position = p24.Position
			local v82 = false
			local n1 = 0

			while not u79 and (tick() < v80 and not (p28 and p28())) and (p24.Position - pcall_2.Position).Magnitude >= 3 do
				if (p24.Position - Position).Magnitude >= 0.05 then
					n1 = 0

					if v82 then
						v82 = false

						if not noclipEnabled then
							toggleNoclip(false)
						end
					end
				else
					n1 = n1 + 0.1

					if n1 >= 0.4 and not v82 then
						toggleNoclip(true)
						v82 = true
					end
				end

				Position = p24.Position
				task.wait(0.1)
			end

			if v82 and not noclipEnabled then
				toggleNoclip(false)
			end

			pcall_2 = pcall

			local v84 = connection

			pcall(function()
				v84:Disconnect()
			end)

			if p28 and p28() then
				p23:MoveTo(p24.Position)
				task.wait(0.1)
				p23.WalkSpeed = 16

				return
			end
		end
	else
		p23:MoveTo(p25)

		local u85 = false

		waypoints = p23.MoveToFinished:Connect(function()
			u85 = true
		end)
		v71 = tick() + v71
		pcall_ = p24.Position
		pcall_2 = false
		connection = 0

		while not u85 and tick() < v71 do
			if p28 and p28() then
				u85 = true

				break
			end

			if not ((p24.Position - p25).Magnitude >= 3) then
				u85 = true

				break
			end

			if (p24.Position - pcall_).Magnitude >= 0.05 then
				connection = 0

				if pcall_2 then
					pcall_2 = false

					if not noclipEnabled then
						toggleNoclip(false)
					end
				end
			else
				connection = connection + 0.15

				if connection >= 0.4 and not pcall_2 then
					toggleNoclip(true)
					pcall_2 = true
				end
			end

			pcall_ = p24.Position
			p23:MoveTo(p25)
			task.wait(0.15)
		end

		if pcall_2 and not noclipEnabled then
			toggleNoclip(false)
		end

		v71 = pcall

		local v86 = waypoints

		pcall(function()
			v86:Disconnect()
		end)
	end

	p23:MoveTo(p24.Position)
	task.wait(0.1)
	p23.WalkSpeed = 16
end
function InstantTP(p29)
	if GetHRP() then
		GetHum():ChangeState(Enum.HumanoidStateType.Physics)
		GetHRP().CFrame = CFrame.new(p29 + Vector3.new(0, 3, 0))
		task.wait(0.15)
		GetHum():ChangeState(Enum.HumanoidStateType.Running)

		return
	else
		return
	end
end
function SitJumpTP(p30)
	local v87 = GetHRP()
	local v88 = GetHum()

	if v87 and v88 then
		v87.CFrame = CFrame.new(p30 + Vector3.new(0, 3, 0))
		task.wait(0.3)
		v88.Sit = true
		task.wait(0.8)
		v88.Sit = false
		task.wait(0.2)
		v88:ChangeState(Enum.HumanoidStateType.Jumping)
		task.wait(0.4)
		v88:ChangeState(Enum.HumanoidStateType.Landed)

		return
	else
		return
	end
end

getgenv().BaristaMinigameThread = nil
getgenv().BaristaMinigameConn = nil

function StopBaristaMinigame()
	if getgenv().BaristaMinigameConn then
		pcall(function()
			getgenv().BaristaMinigameConn:Disconnect()
		end)
		getgenv().BaristaMinigameConn = nil
	end

	if not getgenv().BaristaMinigameThread then
		return
	end

	pcall(function()
		task.cancel(getgenv().BaristaMinigameThread)
	end)
	getgenv().BaristaMinigameThread = nil
end
function StartBaristaMinigame()
	StopBaristaMinigame()
	getgenv().BaristaMinigameThread = task.spawn(function()
		local MinigameFrame = LP.PlayerGui:WaitForChild("BaristaGUI"):WaitForChild("MinigameFrame")
		local BackgroundBar = MinigameFrame:WaitForChild("BackgroundBar")
		local _ = BackgroundBar:WaitForChild("PlayerCursor")
		BackgroundBar:WaitForChild("TargetZone")

		local TapZone = MinigameFrame:WaitForChild("TapZone")
		local u93 = nil
		local Function = nil

		for _ = 1, 20 do
			local pcall_ = pcall
			local v97 = TapZone

			pcall(function()
				u93 = getconnections(v97.MouseButton1Down)
			end)

			if u93 and (u93[1] and u93[1].Function) then
				Function = u93[1].Function

				break
			end

			task.wait(0.3)
		end

		if not Function then
			return
		end
	end)
end

getgenv().BaristaAutoFarm = false
getgenv().BaristaState = "Idle"
getgenv().FixingMachine = false
getgenv().LastRestart = 0
ok = getgenv()
windUI = {}
vector3 = {}
vector32 = Vector3.new(-5005, 4, -701)
vector33 = Vector3.new(-5004, 4, -716)
vector34 = v1(Vector3.new(-4990, 4, -715))
__set_list(vector3, 1, { vector32, vector33, unpack(vector34, 1, vector34.n) })
windUI.JobWalk = vector3
windUI.Start = Vector3.new(-4990, 4, -715)
vector3 = {}
vector32 = Vector3.new(-5005, 4, -759)
vector33 = Vector3.new(-5005, 4, -803)
vector34 = v1(Vector3.new(-4996, 4, -803))
__set_list(vector3, 1, { vector32, vector33, unpack(vector34, 1, vector34.n) })
windUI.BrewWalk = vector3
windUI.Brew = Vector3.new(-4997, 4, -795)
windUI.Cash = Vector3.new(-4995, 4, -760)
ok.BaristaPos = windUI
getgenv().FixMachinePos = Vector3.new(-5114, 3, -673)

function HasBaristaMission()
	local BaristaMissionUI = LP.PlayerGui:FindFirstChild("BaristaMissionUI")

	if BaristaMissionUI then
		BaristaMissionUI = BaristaMissionUI:FindFirstChild("Container")

		if BaristaMissionUI == nil then
			BaristaMissionUI = false
		else
			BaristaMissionUI = BaristaMissionUI.Visible ~= false
		end

		return BaristaMissionUI
	else
		return false
	end
end
function IsMachineBroken()
	local BaristaGUI = LP.PlayerGui:FindFirstChild("BaristaGUI")

	if not BaristaGUI then
		return false
	end

	BaristaGUI = BaristaGUI:FindFirstChild("StatusFrame")

	if not BaristaGUI then
		return false
	end

	BaristaGUI = BaristaGUI:FindFirstChild("OrderText")

	if not BaristaGUI then
		return BaristaGUI
	end

	BaristaGUI = BaristaGUI.Text == "Machine broke down!"

	return BaristaGUI
end
function FixBrokenMachine()
	if FixingMachine then
		return
	else
		FixingMachine = true

		local v100 = GetHRP()
		local v101 = GetHum()

		if not (v100 and v101) then
			FixingMachine = false

			return
		end

		return
	end
end
function RestartBaristaJob()
	if tick() - LastRestart >= 4 then
		LastRestart = tick()
		SitJumpTP(BaristaPos.Start)
		task.wait(0.5)
		PressE()
		task.wait(1.2)
		StartBaristaMinigame()
		BaristaState = "Brew"

		return
	else
		return
	end
end
function HasDrink()
	local v102, v103, v104 = pairs(Char():GetChildren())
	local v105

	while true do
		v104, v105 = v102(v103, v104)

		if v104 == nil then
			break
		end

		if v105:IsA("Tool") then
			return true
		end
	end

	v102, v103, v104 = pairs(LP.Backpack:GetChildren())

	while true do
		v104, v105 = v102(v103, v104)

		if v104 == nil then
			break
		end

		if v105:IsA("Tool") then
			return true
		end
	end

	return false
end

getgenv().antiAFKEnabled = false
getgenv().antiAFKConnection = nil
getgenv().flyEnabled = false
getgenv().flying = false
getgenv().speed = 50
getgenv().flyConnection = nil
getgenv().courierLoopRunning = false
getgenv().officeLoopRunning = false
getgenv().questLoopRunning = false
getgenv().baristaLoopRunning = false
getgenv().hidePlayersEnabled = false
getgenv().hidePlayerConnections = {
	["playerAdded"] = nil,
	["characterAdded"] = {},
}

function applyHideToCharacter(p31)
	local v106, v107, v108 = pairs(p31:GetDescendants())

	while true do
		local v109

		v108, v109 = v106(v107, v108)

		if v108 == nil then
			break
		end

		if v109:IsA("BasePart") then
			v109.LocalTransparencyModifier = 1
			v109.CastShadow = false
			v109.CanCollide = false
		end

		if v109:IsA("Animator") then
			local v110, v111, v112 = pairs(v109:GetPlayingAnimationTracks())

			while true do
				local v113

				v112, v113 = v110(v111, v112)

				if v112 == nil then
					break
				end

				v113:Stop()
			end
		end

		if v109:IsA("ParticleEmitter") or (v109:IsA("Trail") or (v109:IsA("Smoke") or v109:IsA("Fire"))) then
			v109.Enabled = false
		end
	end
end
function revertHideFromCharacter(p32)
	local v114, v115, v116 = pairs(p32:GetDescendants())

	while true do
		local v117

		v116, v117 = v114(v115, v116)

		if v116 == nil then
			break
		end

		if v117:IsA("BasePart") then
			v117.LocalTransparencyModifier = 0
			v117.CastShadow = true
			v117.CanCollide = true
		end

		if v117:IsA("ParticleEmitter") or (v117:IsA("Trail") or (v117:IsA("Smoke") or v117:IsA("Fire"))) then
			v117.Enabled = true
		end
	end
end
function applyHideToPlayer(p33)
	if p33 == LP then
		return
	end

	local connection = p33.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		applyHideToCharacter(character)
	end)

	hidePlayerConnections.characterAdded[p33] = connection

	if not p33.Character then
		return
	end

	applyHideToCharacter(p33.Character)
end
function revertHideFromPlayer(p34)
	if p34 == LP then
		return
	end

	if not p34.Character then
		return
	end

	revertHideFromCharacter(p34.Character)
end
function enableHidePlayers()
	hidePlayersEnabled = true

	local v119, v120, v121 = pairs(Players:GetPlayers())

	while true do
		local v122

		v121, v122 = v119(v120, v121)

		if v121 == nil then
			break
		end

		applyHideToPlayer(v122)
	end

	hidePlayerConnections.playerAdded = Players.PlayerAdded:Connect(applyHideToPlayer)
end
function disableHidePlayers()
	hidePlayersEnabled = false

	local v123

	if not hidePlayerConnections.playerAdded then
		v159, v160, v161 = pairs(hidePlayerConnections.characterAdded)

		while true do
			v161, v123 = v159(v160, v161)

			if v161 == nil then
				break
			end

			v123:Disconnect()
			revertHideFromPlayer(v161)
		end

		hidePlayerConnections.characterAdded = {}

		return
	end

	hidePlayerConnections.playerAdded:Disconnect()
	hidePlayerConnections.playerAdded = nil

	local v124, v125, v126 = pairs(hidePlayerConnections.characterAdded)

	while true do
		v126, v123 = v124(v125, v126)

		if v126 == nil then
			break
		end

		v123:Disconnect()
		revertHideFromPlayer(v126)
	end

	hidePlayerConnections.characterAdded = {}
end
function RandomDelay(p35, p36)
	task.wait(p35 + math.random() * (p36 - p35))
end
function GetGroundHeight(p37)
	local v127 = p37 + Vector3.new(0, 50, 0)
	local vector317 = Vector3.new(0, -100, 0)
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = { LP.Character }
	v127 = Workspace:Raycast(v127, vector317, raycastParams)

	return v127 and v127.Position.Y or p37.Y
end

getgenv()._noclipPartsCache = {}
getgenv()._noclipCharCacheConn = nil

local function v130()
	getgenv()._noclipPartsCache = {}

	if not LP.Character then
		return
	end

	local v131, v132, v133 = pairs(LP.Character:GetDescendants())

	while true do
		local v134

		v133, v134 = v131(v132, v133)

		if v133 == nil then
			break
		end

		if v134:IsA("BasePart") then
			local _noclipPartsCache = getgenv()._noclipPartsCache

			table.insert(_noclipPartsCache, v134)
		end
	end
end
local function v136()
	if getgenv()._noclipCharCacheConn then
		pcall(function()
			getgenv()._noclipCharCacheConn:Disconnect()
		end)
	end

	v130()
	getgenv()._noclipCharCacheConn = LP.CharacterAdded:Connect(function(_)
		task.wait(0.5)
		v130()
	end)
end

function toggleNoclip(p38)
	if p38 then
		if noclipConn then
			noclipConn:Disconnect()
		end

		v136()
		noclipConn = RunService.Stepped:Connect(function()
			local _noclipPartsCache = getgenv()._noclipPartsCache

			for i = 1, #_noclipPartsCache do
				local v139 = _noclipPartsCache[i]

				if v139 then
					if v139.Parent then
						v139.CanCollide = false
					end
				end
			end
		end)

		return
	end

	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end

	if not getgenv()._noclipCharCacheConn then
		getgenv()._noclipPartsCache = {}

		return
	end

	pcall(function()
		getgenv()._noclipCharCacheConn:Disconnect()
	end)
	getgenv()._noclipCharCacheConn = nil
	getgenv()._noclipPartsCache = {}
end
function OfficeFindChairPrompt()
	local ProximityPrompt = nil

	pcall(function()
		ProximityPrompt = Workspace.Computers.Setup.Chair.Handle:FindFirstChildOfClass("ProximityPrompt")
	end)

	if nil then
		return nil
	end
end
function OfficeSitOnChair(p39)
	local pcall_ = GetHRP()
	local v142 = GetHum()

	if not (pcall_ and v142) then
		return
	end

	toggleNoclip(true)

	local pcall_2 = pcall
	local v144 = v142

	pcall(function()
		v144:ChangeState(Enum.HumanoidStateType.GettingUp)
	end)
	task.wait(p39 and 0.05 or 0.15)
	pcall_.CFrame = CFrame.new(OFFICE_CHAIR_POS) * CFrame.Angles(0, OFFICE_CHAIR_ROT, 0)
	task.wait(p39 and 0.1 or 0.3)
	pcall_2 = OfficeFindChairPrompt()

	if pcall_2 then
		local v146 = pcall_2

		pcall(function()
			v146.Enabled = true
		end)
		fireproximityprompt(pcall_2)
		task.wait(p39 and 0.05 or 0.1)

		local v147 = pcall_2

		pcall(function()
			fireproximityprompt(v147, false)
		end)
		task.wait(p39 and 0.3 or 0.8)
	end

	pcall_2 = pcall

	local v148 = v142

	pcall(function()
		v148:ChangeState(Enum.HumanoidStateType.Seated)
	end)
	task.wait(p39 and 0.1 or 0.2)

	if v142.Sit or v142:GetState() == Enum.HumanoidStateType.Seated then
		toggleNoclip(false)

		return
	end

	pcall_.CFrame = CFrame.new(OFFICE_CHAIR_POS) * CFrame.Angles(0, OFFICE_CHAIR_ROT, 0)
	task.wait(0.15)
	pcall_ = OfficeFindChairPrompt()

	if pcall_ then
		pcall_2 = pcall

		local v149 = pcall_

		pcall(function()
			v149.Enabled = true
		end)
		fireproximityprompt(pcall_)
		task.wait(p39 and 0.3 or 0.6)
	end

	pcall_ = pcall

	local v150 = v142

	pcall(function()
		v150:ChangeState(Enum.HumanoidStateType.Seated)
	end)
	task.wait(0.15)
	toggleNoclip(false)
end
function IsOfficeWorker()
	local Team = LP.Team

	if not Team then
		return Team
	end

	Team = LP.Team.Name == "Office Worker"

	return Team
end
function ChangeTeamToOfficeWorker()
	RS.JobEvents.TeamChangeRequest:FireServer("Office Worker", 0, 0, 0, "MainMenu")
	task.wait(3)
end
local function v178()
	local v179, v180, v181 = pairs(LP.PlayerGui:GetChildren())

	while true do
		local v182

		v181, v182 = v179(v180, v181)

		if v181 == nil then
			break
		end

		if v182:IsA("ScreenGui") then
			local v183, v184

			v182, v183, v184 = pairs(v182:GetDescendants())

			while true do
				local v185

				v184, v185 = v182(v183, v184)

				if v184 == nil then
					break
				end

				if v185.Visible and (v185:IsA("TextLabel") or v185:IsA("TextButton")) then
					v185 = (v185.Text or ""):lower()

					if v185:find("printer") or v185:find("go to the printer") then
						return true
					end
				end
			end
		end
	end

	return false
end

function OfficeStopWatcher()
	if not _officeWatchConn then
		_lastPrinterState = false
		_officePrinterBusy = false

		return
	end

	pcall(function()
		_officeWatchConn:Disconnect()
	end)
	_officeWatchConn = nil
	_lastPrinterState = false
	_officePrinterBusy = false
end

local function v186()
	if _officePrinterBusy then
		return
	end

	_officePrinterBusy = true

	local v187 = GetHum()
	local v188 = GetHRP()

	if not (v187 and v188) then
		_officePrinterBusy = false

		return
	end

	local pcall_ = pcall
	local v190 = v187

	pcall(function()
		v190:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
	task.wait(0.4)
	pcall_ = pcall

	local v191 = v187

	pcall(function()
		v191:ChangeState(Enum.HumanoidStateType.Landed)
	end)
	task.wait(0.2)

	if not OfficeAutoFarm then
		_officePrinterBusy = false

		return
	end

	pcall_ = GetHRP()

	local pcall_2

	if pcall_ then
		local u193 = (1 / 0)
		local u194
		local Position = nil

		pcall_2 = pcall

		local v196 = pcall_

		pcall(function()
			local v197, v198, v199 = pairs(Workspace:GetDescendants())

			while true do
				local v200

				v199, v200 = v197(v198, v199)

				if v199 == nil then
					break
				end

				local Parent, v202

				if v200:IsA("ProximityPrompt") then
					Parent = v200.Parent

					if Parent and Parent:IsA("BasePart") then
						Parent = (Parent.Position - v196.Position).Magnitude
						v202 = Parent.Name:lower()

						local v203 = (v200.ActionText or ""):lower()

						if (v202:find("printer") or v203:find("print")) and Parent < u193 then
							u193 = Parent
							u194 = v200
							Position = Parent.Position
						end
					end
				end

				if v200:IsA("BasePart") and v200.Name:lower():find("printer") then
					Parent = (v200.Position - v196.Position).Magnitude
					v202 = v200:FindFirstChildOfClass("ProximityPrompt")

					if Parent < u193 then
						u193 = Parent
						Position = v200.Position

						if v202 then
							u194 = v202
						end
					end
				end
			end
		end)
		pcall_ = nil
		pcall_2 = nil
	else
		pcall_2 = nil
		pcall_ = nil
	end

	if pcall_2 then
		WalkThroughWaypoints(v187, v188, { pcall_2 }, 16, 20, function()
			return not OfficeAutoFarm
		end)
		task.wait(0.3)
	end

	if not OfficeAutoFarm then
		_officePrinterBusy = false

		return
	end

	if not pcall_ then
		pcall_ = GetHRP()

		if pcall_ then
			local u204 = (1 / 0)
			local u205
			local Position = nil

			pcall_2 = pcall

			local v207 = pcall_

			pcall(function()
				local v208, v209, v210 = pairs(Workspace:GetDescendants())

				while true do
					local v211

					v210, v211 = v208(v209, v210)

					if v210 == nil then
						break
					end

					local Parent, v213

					if v211:IsA("ProximityPrompt") then
						Parent = v211.Parent

						if Parent and Parent:IsA("BasePart") then
							Parent = (Parent.Position - v207.Position).Magnitude
							v213 = Parent.Name:lower()

							local v214 = (v211.ActionText or ""):lower()

							if (v213:find("printer") or v214:find("print")) and Parent < u204 then
								u204 = Parent
								u205 = v211
								Position = Parent.Position
							end
						end
					end

					if v211:IsA("BasePart") and v211.Name:lower():find("printer") then
						Parent = (v211.Position - v207.Position).Magnitude
						v213 = v211:FindFirstChildOfClass("ProximityPrompt")

						if Parent < u204 then
							u204 = Parent
							Position = v211.Position

							if v213 then
								u205 = v213
							end
						end
					end
				end
			end)
			pcall_ = nil
		else
			pcall_ = nil
		end
	end

	if pcall_ then
		pcall(function()
			pcall_.Enabled = true
		end)
		fireproximityprompt(pcall_)
		task.wait(5)
		pcall(function()
			fireproximityprompt(pcall_, false)
		end)
	else
		HoldE(5)
	end

	task.wait(0.3)

	if not OfficeAutoFarm then
		_officePrinterBusy = false

		return
	end

	WalkThroughWaypoints(v187, v188, { Vector3.new(OFFICE_CHAIR_POS.X + 2, OFFICE_CHAIR_POS.Y, OFFICE_CHAIR_POS.Z) }, 16, 20, function()
		return not OfficeAutoFarm
	end)
	task.wait(0.2)

	if not OfficeAutoFarm then
		_lastPrinterState = false
		_officePrinterBusy = false

		return
	end

	OfficeSitOnChair()
	_lastPrinterState = false
	_officePrinterBusy = false
end

function OfficeStartWatcher()
	OfficeStopWatcher()

	local n3 = 0
	local n4 = 0

	_officeWatchConn = RunService.Heartbeat:Connect(function(dt)
		if not OfficeAutoFarm then
			OfficeStopWatcher()

			return
		end

		n3 = n3 + dt
		n4 = n4 + dt

		if not (n3 >= 0.3) then
			return
		end

		n3 = 0

		if not officeResetting then
			local n5 = 0

			pcall(function()
				local function v218(...)
					return {
						...,
						["n"] = select("#", ...),
					}
				end
				local pairs_
				local v220 = v218(LP.PlayerGui:GetChildren())
				local v221

				pairs_, v220, v221 = pairs(unpack(v220, 1, v220.n))

				while true do
					local v222

					v221, v222 = pairs_(v220, v221)

					if v221 == nil then
						break
					end

					local pairs_2 = pairs

					v222 = v218(v222:GetDescendants())

					local v224

					v222, pairs_2, v224 = pairs(unpack(v222, 1, v222.n))

					while true do
						local v225

						v224, v225 = v222(pairs_2, v224)

						if v224 == nil then
							break
						end

						if v225:IsA("TextLabel") and v225.Name == "EarningLabel" then
							v225 = v218((v225.Text or ""):gsub("[^%d]", ""))

							local value = select(4, unpack(v225, 1, 4))

							v225 = tonumber(unpack(v225, 1, v225.n)) or 0

							if n5 < v225 then
								n5 = v225
							end
						end
					end
				end
			end)

			if not (0 < OFFICE_EARN_LIMIT) then
				officeResetting = true
				task.spawn(OfficeDoTeamReset)

				return
			end
		end

		local v227 = v178()

		if v227 and not (_lastPrinterState or (_officePrinterBusy or officeResetting)) then
			_lastPrinterState = true
			task.spawn(v186)
		elseif not v227 then
			_lastPrinterState = false
		end

		if n4 < 5 then
			return
		end

		n4 = 0

		if _officePrinterBusy or officeResetting then
			return
		end

		v227 = GetHum()

		if not (v227 and (not v227.Sit and v227:GetState() ~= Enum.HumanoidStateType.Seated)) then
			return
		end

		task.spawn(OfficeSitOnChair)
	end)
end
function OfficeDoTeamReset()
	OfficeStopWatcher()

	local v228 = GetHum()

	if not (v228 and (GetHRP() and (v228.Sit or v228:GetState() == Enum.HumanoidStateType.Seated))) then
		RS.JobEvents.TeamChangeRequest:FireServer("Police", 0, 0, 0, "MainMenu")
		task.wait(4)

		if OfficeAutoFarm then
			RS.JobEvents.TeamChangeRequest:FireServer("Office Worker", 0, 0, 0, "MainMenu")
			task.wait(3)

			if OfficeAutoFarm then
				OfficeAnsweredIDs = {}
				OfficeAnswerCount = 0
				OfficeSitOnChair()
				officeResetting = false
				OfficeStartWatcher()

				return
			else
				officeResetting = false

				return
			end

			return
		else
			officeResetting = false

			return
		end

		return
	end

	local pcall_ = pcall
	local v230 = v228

	pcall(function()
		v230:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
	task.wait(0.5)
	pcall_ = pcall

	local v231 = v228

	pcall(function()
		v231:ChangeState(Enum.HumanoidStateType.Landed)
	end)
	task.wait(0.3)
	RS.JobEvents.TeamChangeRequest:FireServer("Police", 0, 0, 0, "MainMenu")
	task.wait(4)

	if OfficeAutoFarm then
		RS.JobEvents.TeamChangeRequest:FireServer("Office Worker", 0, 0, 0, "MainMenu")
		task.wait(3)

		if OfficeAutoFarm then
			OfficeAnsweredIDs = {}
			OfficeAnswerCount = 0
			OfficeSitOnChair()
			officeResetting = false
			OfficeStartWatcher()

			return
		else
			officeResetting = false

			return
		end

		return
	else
		officeResetting = false

		return
	end
end

ok = function()
	if _questionEventConn then
		pcall(function()
			_questionEventConn:Disconnect()
		end)
		_questionEventConn = nil
	end
	local n6, GenerateQuestion

	if _correctAnswerConn then
		pcall(function()
			_correctAnswerConn:Disconnect()
		end)
		_correctAnswerConn = nil
		n6 = 0
		GenerateQuestion = nil
	else
		n6 = 0
		GenerateQuestion = nil
	end

	while true do
		n6 = n6 + 1
		pcall(function()
			GenerateQuestion = RS:WaitForChild("JobEvents", 5):WaitForChild("GenerateQuestion", 5)
		end)

		if not GenerateQuestion then
			task.wait(1)
		end

		if GenerateQuestion or n6 >= 5 then
			if not GenerateQuestion then
				return
			end

			return
		end
	end
end
ok()

function setFrozen(p42)
	local v238 = GetHRP()
	local v239 = GetHum()

	if v238 and v239 then
		if p42 then
			v238.Anchored = true
			v239:ChangeState(Enum.HumanoidStateType.PlatformStanding)
			v239.WalkSpeed = 0
			v239.JumpPower = 0

			if not (v238 and v238:IsA("BasePart")) then
				isFrozen = p42

				return
			end

			v238.Velocity = Vector3.new(0, 0, 0)
		else
			v239:ChangeState(Enum.HumanoidStateType.Landed)
			v239.WalkSpeed = 16
			v239.JumpPower = 50
			task.wait(0.1)
			v238.Anchored = false
		end

		isFrozen = p42

		return
	else
		return
	end
end
function TweenTP(p43)
	local tween = GetHRP()
	local v241 = GetHum()

	if not (tween and v241) then
		return false
	end

	if isFrozen then
		setFrozen(false)
	end

	v241:ChangeState(Enum.HumanoidStateType.PlatformStanding)

	local Position = tween.Position
	local vector317 = GetGroundHeight(p43)

	vector317 = Vector3.new(p43.X, vector317 + 4, p43.Z)

	local vector318 = Vector3.new(Position.X, -50, Position.Z)
	local vector319 = Vector3.new(vector317.X, -50, vector317.Z)

	tween.CFrame = CFrame.new(vector318)
	task.wait(0.2)
	Position = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(vector317.X, 0, vector317.Z)).Magnitude / 350
	Position = math.max(Position, 1.2)
	vector318 = CFrame.Angles

	local v246 = math.random(-45, 45)

	vector318 = vector318(0, math.rad(v246), 0)
	vector319 = CFrame.new(vector319) * vector318
	Position = TweenService:Create(tween, TweenInfo.new(Position, Enum.EasingStyle.Linear), {
		["CFrame"] = vector319,
	})
	Position:Play()
	Position.Completed:Wait()
	Position = CFrame.new(vector317) * vector318
	tween = TweenService:Create(tween, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		["CFrame"] = Position,
	})
	tween:Play()
	tween.Completed:Wait()
	v241:ChangeState(Enum.HumanoidStateType.Jumping)
	task.wait(0.1)
	v241:ChangeState(Enum.HumanoidStateType.Landed)

	if not isFrozen then
		task.wait(0.2)
		RandomDelay(1.5, 4)

		return true
	end

	setFrozen(true)
	task.wait(0.2)
	RandomDelay(1.5, 4)

	return true
end
function PressF()
	VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
	task.wait(0.25)
	VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end
function IsCourier()
	local Team = LP.Team

	if not Team then
		return Team
	end

	Team = LP.Team.Name == "Courier"

	return Team
end
function ChangeTeamToCourier()
	local TeamChangeRequest = RS.JobEvents:FindFirstChild("TeamChangeRequest")

	if not TeamChangeRequest then
		return
	end

	local pcall_ = pcall
	local v250 = TeamChangeRequest

	pcall(function()
		v250:FireServer("Courier", 11378976, 0, 0, "Detector")
	end)
	task.wait(4)
end
function IsBarista()
	local Team = LP.Team

	if not Team then
		return Team
	end

	Team = LP.Team.Name == "Barista"

	return Team
end
function EquipAndGrabNewBox()
	task.wait(0.4)

	local Box = LP.Backpack:FindFirstChild("Box")

	if Box and GetHum() then
		GetHum():EquipTool(Box)
		task.wait(0.2)
		PressF()

		return true
	else
		return false
	end
end
function GetQuestBoard()
	return Workspace:FindFirstChild("QuestBoard") or (Workspace:FindFirstChild("Quests") or Workspace:FindFirstChild("Quest"))
end
function AcceptQuest()
	local ProximityPrompt = GetQuestBoard()

	ProximityPrompt = ProximityPrompt and ProximityPrompt:FindFirstChildWhichIsA("ProximityPrompt")

	if ProximityPrompt then
		fireproximityprompt(ProximityPrompt)

		return true
	else
		return false
	end
end
function CompleteQuest()
	local ProximityPrompt = GetQuestBoard()

	ProximityPrompt = ProximityPrompt and ProximityPrompt:FindFirstChildWhichIsA("ProximityPrompt")

	if ProximityPrompt then
		fireproximityprompt(ProximityPrompt)

		return true
	else
		return false
	end
end
function startFly()
	if not (GetHRP() and GetHum()) then
		return
	end
end
function stopFly()
	flying = false

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if not GetHRP() then
		return
	end

	local v255, v256, v257 = pairs(GetHRP():GetChildren())

	while true do
		local v258

		v257, v258 = v255(v256, v257)

		if v257 == nil then
			break
		end

		if v258:IsA("BodyVelocity") or v258:IsA("BodyGyro") then
			v258:Destroy()
		end
	end
end
function enableAntiAFK()
	if antiAFKConnection then
		return
	else
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		return
	end
end
function disableAntiAFK()
	if not antiAFKConnection then
		getgenv().SimpleAntiAFK = false

		return
	end

	antiAFKConnection:Disconnect()
	antiAFKConnection = nil
	getgenv().SimpleAntiAFK = false
end
function startAutoDrive()
	local Character = LP.Character or LP.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")

	HumanoidRootPart.CFrame = CFrame.new(AUTO_DRIVE_START + Vector3.new(0, 3, 0))
	task.wait(1)

	if not AutoDriveEnabled then
		return
	end

	RS:WaitForChild("SpawnCarEvents"):WaitForChild("SpawnCar"):FireServer(AUTO_DRIVE_MOTOR)
	task.wait(2.5)

	if not AutoDriveEnabled then
		return
	end

	HumanoidRootPart.CFrame = CFrame.new(AUTO_DRIVE_ENTER + Vector3.new(0, 3, 0))
	task.wait(0.5)
	VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(VEHICLE_ENTER_HOLD)
	VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)

	local v264 = false

	for _ = 1, 20 do
		if Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") then
			v264 = true

			break
		end

		task.wait(0.2)
	end

	if not v264 then
		HumanoidRootPart.CFrame = CFrame.new(AUTO_DRIVE_ENTER + Vector3.new(0, 3, 0))
		task.wait(0.3)
		VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(VEHICLE_ENTER_HOLD)
		VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
		task.wait(1)

		if not (Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model")) then
			WindUI:Notify({
				["Title"] = "Auto Drive",
				["Content"] = "Failed to seat on vehicle",
				["Duration"] = 4,
			})
			AutoDriveEnabled = false

			return
		end

		return
	end
end

getgenv().SENTUL_PLACE_ID = 114069860751320
getgenv().MAIN_PLACE_ID = 131378148336503

function GPFindVehiclePrompt(p44, p45)
	local u266 = nil
	local n7 = 25
	local pcall_ = pcall
	local v269 = p45

	pcall(function()
		local v270, v271, v272 = pairs(Workspace:GetDescendants())

		while true do
			local v273

			v272, v273 = v270(v271, v272)

			if v272 == nil then
				return
			end

			if v273:IsA("Model") and v273.Name == p44 then
				local Magnitude = (v273:GetPivot().Position - v269).Magnitude

				if Magnitude < n7 then
					local VehicleSeat = v273:FindFirstChildWhichIsA("VehicleSeat", true)

					VehicleSeat = VehicleSeat and VehicleSeat:FindFirstChildOfClass("ProximityPrompt")

					if VehicleSeat then
						u266 = VehicleSeat
						n7 = Magnitude
					end

					if not u266 then
						local v276

						v273, VehicleSeat, v276 = pairs(v273:GetDescendants())

						while true do
							local v277

							v276, v277 = v273(VehicleSeat, v276)

							if v276 == nil then
								break
							end

							if v277:IsA("ProximityPrompt") then
								u266 = v277
								n7 = Magnitude

								break
							end
						end
					end
				end
			end
		end
	end)

	return nil
end
function GPInstantEnterVehicle(p46, p47)
	local v278 = GPFindVehiclePrompt(p46, p47.Position)

	if not v278 then
		VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(0.3)
		VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)

		return false
	end
end
function spawnAndSitForDrag()
	local Character = LP.Character or LP.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

	Character = Character:WaitForChild("Humanoid")
	HumanoidRootPart.CFrame = CFrame.new(-160, -4, -713)
	task.wait(1)
	RS:WaitForChild("SpawnCarEvents"):WaitForChild("SpawnCar"):FireServer(GP_MOTOR)
	task.wait(3)
	HumanoidRootPart.CFrame = CFrame.new(-160, -4, -729)
	task.wait(0.5)
	VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(VEHICLE_ENTER_HOLD)
	VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)

	local v281 = false

	for i = 1, 30 do
		if Character.SeatPart and Character.SeatPart:FindFirstAncestorOfClass("Model") then
			return true
		end

		task.wait(0.1)
	end

	return v281
end
function startAutoDragRaceFast()
	if game.PlaceId == MAIN_PLACE_ID then
		game:GetService("TeleportService"):Teleport(SENTUL_PLACE_ID, LP)
		AutoDragRaceEnabled = false

		return
	end

	if not spawnAndSitForDrag() then
		WindUI:Notify({
			["Title"] = "Auto Drag Race Fast",
			["Content"] = "Failed to seat on vehicle",
			["Duration"] = 4,
		})
		AutoDragRaceEnabled = false

		return
	end
	local DetectorStart
	local DetectorFinish

	if
		not (
			pcall(function()
				DetectorStart = Workspace.DragRace.Detector.DetectorStart
				DetectorFinish = Workspace.DragRace.Detector.DetectorFinish
			end) and nil
		)
	then
		if not AutoDragRaceEnabled then
			AutoDragRaceEnabled = false

			return
		end

		WindUI:Notify({
			["Title"] = "Auto Drag Race Fast",
			["Content"] = "DragRace Detector not found!",
			["Duration"] = 4,
		})
		AutoDragRaceEnabled = false

		return
	end
end
function startAutoGPRace()
	if game.PlaceId == MAIN_PLACE_ID then
		game:GetService("TeleportService"):Teleport(SENTUL_PLACE_ID, LP)
		AutoGPEnabled = false

		return
	end

	local Character = LP.Character or LP.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

	HumanoidRootPart.CFrame = CFrame.new(GP_TRACK[1] + Vector3.new(0, 3, 0))
	task.wait(1)
	RS:WaitForChild("SpawnCarEvents"):WaitForChild("SpawnCar"):FireServer(GP_MOTOR)

	local u288 = (function()
		local v289, v290, v291 = pairs(Workspace:GetDescendants())

		while true do
			local v292

			v291, v292 = v289(v290, v291)

			if v291 == nil then
				break
			end

			if v292:IsA("Model") and (v292.Name == GP_MOTOR and v292:FindFirstChildWhichIsA("VehicleSeat", true)) then
				return v292
			end
		end

		return nil
	end)()

	if not u288 then
		local u293 = false

		v347 = Workspace.DescendantAdded:Connect(function(descendant)
			if u293 then
				return
			end

			if not (descendant:IsA("Model") and (descendant.Name == GP_MOTOR and descendant:FindFirstChildWhichIsA("VehicleSeat", true))) then
				return
			end

			u288 = descendant
			u293 = true
		end)
		v348 = tick() + 5

		while not u293 and tick() < v348 do
			task.wait(0.1)
		end

		v347:Disconnect()
	end

	if u288 then
		v347 = u288:GetPivot().Position
		HumanoidRootPart.CFrame = CFrame.new(v347 + Vector3.new(0, 2, -3))
		task.wait(0.5)
	else
		v347 = Vector3.new(GP_TRACK[1].X, GP_TRACK[1].Y, GP_TRACK[1].Z - 16)
		HumanoidRootPart.CFrame = CFrame.new(v347)
		task.wait(0.5)
	end

	GPInstantEnterVehicle(GP_MOTOR, HumanoidRootPart)

	local VEHICLE_ENTER_HOLD_ = VEHICLE_ENTER_HOLD

	VEHICLE_ENTER_HOLD_ = math.max(VEHICLE_ENTER_HOLD, 2)

	local n8 = 0
	local v296 = false

	while true do
		n8 = n8 + 1
		VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(VEHICLE_ENTER_HOLD_)
		VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
		task.wait(0.4)

		for i = 1, 15 do
			if Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") then
				v296 = true

				return
			end

			task.wait(0.1)
		end

		local Position

		if not v296 and (n8 < 3 and (u288 and u288.Parent)) then
			Position = u288:GetPivot().Position
			HumanoidRootPart.CFrame = CFrame.new(Position + Vector3.new(0, 2, -2))
			task.wait(0.4)
			GPInstantEnterVehicle(GP_MOTOR, HumanoidRootPart)
		end

		if v296 or n8 >= 3 then
			if not v296 then
				AutoGPEnabled = false

				return
			end

			VEHICLE_ENTER_HOLD_ = LP:WaitForChild("PlayerGui")
			n8 = nil
			v296 = nil

			while true do
				task.wait(0.3)

				if not AutoGPEnabled then
					break
				end

				v296 = VEHICLE_ENTER_HOLD_:FindFirstChild("RaceGui")

				if v296 then
					Position = v296:FindFirstChild("RaceInfoFrame")

					if Position then
						Position = Position:FindFirstChild("Timers")

						if Position then
							n8 = Position:FindFirstChild("TotalLabel")
						end
					end
				end

				if not AutoGPEnabled or n8 ~= nil then
					break
				end
			end

			if not AutoGPEnabled then
				return
			end

			if not n8 then
				AutoGPEnabled = false

				return
			end

			function getTimerSeconds(p48)
				local match, v300, v301 = p48:match("(%d+):(%d+)%.(%d+)")

				return not (match and (v300 and v301)) and 0 or tonumber(match) * 60 + tonumber(v300) + tonumber(v301) / 100
			end

			local v302 = Humanoid
			local v303 = Character

			function getGPModel()
				return v302.SeatPart and v302.SeatPart:FindFirstAncestorOfClass("Model") or (u288 or v303)
			end
			function gpMoveTo(p49)
				local v304 = getGPModel()
				local Position2 = v304:GetPivot().Position
				local n9 = 0

				local function v307(...)
					return {
						...,
						["n"] = select("#", ...),
					}
				end

				while AutoGPEnabled do
					local Position3 = v304:GetPivot().Position

					if Vector3.new(p49.X - Position3.X, 0, p49.Z - Position3.Z).Magnitude < 6 then
						return
					end

					local result = RunService.Heartbeat:Wait()

					if (Vector3.new(Position3.X, 0, Position3.Z) - Vector3.new(Position2.X, 0, Position2.Z)).Magnitude >= 0.3 then
						Position2 = Position3
						n9 = 0
					else
						n9 = n9 + result

						if not (n9 <= 1.5) then
							Position2 = CFrame.new
							n9 = v307(Vector3.new(p49.X, Position3.Y, p49.Z))
							Position2 = v307(Position2(unpack(n9, 1, n9.n)))
							n9 = select(8, unpack(Position2, 1, 8))
							v304:PivotTo(unpack(Position2, 1, Position2.n))

							return
						end
					end

					local Unit = Vector3.new(p49.X - Position3.X, 0, p49.Z - Position3.Z).Unit

					Position3 = Vector3.new(Position3.X + Unit.X * GP_SPEED * result, Position3.Y, Position3.Z + Unit.Z * GP_SPEED * result)
					Position3 = v307(CFrame.new(Position3))
					result = select(6, unpack(Position3, 1, 6))
					v304:PivotTo(unpack(Position3, 1, Position3.n))
				end
			end

			local v311 = nil
			local v312 = Character
			local v313 = Humanoid

			function tweenVehicleToStart(p50)
				local function v314(...)
					return {
						...,
						["n"] = select("#", ...),
					}
				end

				if not (p50 and p50 ~= v312) then
					return false
				end

				local v315 = GP_SPEED * 1.2
				local vector317 = GP_TRACK[1]
				local Y = vector317.Y

				vector317 = Vector3.new(vector317.X, Y, vector317.Z)

				local Position2 = p50:GetPivot().Position
				local n10 = 0

				while AutoGPEnabled do
					local Position3 = p50:GetPivot().Position

					if Vector3.new(vector317.X - Position3.X, 0, vector317.Z - Position3.Z).Magnitude < 8 then
						break
					end

					if (Position3 - Position2).Magnitude >= 0.1 then
						n10 = 0
					else
						n10 = n10 + 0.1

						if not (n10 <= 2) then
							v315 = v314(CFrame.new(vector317))
							Y = select(5, unpack(v315, 1, 5))
							p50:PivotTo(unpack(v315, 1, v315.n))

							break
						end
					end

					Position2 = RunService.Heartbeat:Wait()
					Position2 = Position3 + (vector317 - Position3).Unit * v315 * Position2
					Position2 = Vector3.new(Position2.X, Y, Position2.Z)
					Position2 = v314(CFrame.new(Position2))

					local value = select(2, unpack(Position2, 1, 2))

					p50:PivotTo(unpack(Position2, 1, Position2.n))
					Position2 = Position3
				end

				v314 = v314(CFrame.new(vector317))
				v315 = select(7, unpack(v314, 1, 7))
				p50:PivotTo(unpack(v314, 1, v314.n))
				task.wait(1)

				if v313.SeatPart then
					return true
				end

				v311()

				return true
			end

			local v322 = HumanoidRootPart
			local v323 = Humanoid

			v311 = function()
				local function v324(...)
					return {
						...,
						["n"] = select("#", ...),
					}
				end

				if u288 and u288.Parent then
					v324 = v324(CFrame.new(GP_TRACK[1] + Vector3.new(0, 3, 0)))

					local value = select(7, unpack(v324, 1, 7))

					u288:PivotTo(unpack(v324, 1, v324.n))
					task.wait(0.3)
					v322.CFrame = CFrame.new(GP_TRACK[1] + Vector3.new(0, 3, -3))
					task.wait(0.3)
					GPInstantEnterVehicle(GP_MOTOR, v322)
					task.wait(1)

					if v323.SeatPart and v323.SeatPart:FindFirstAncestorOfClass("Model") then
						return true
					else
						AutoGPEnabled = false

						return false
					end

					return
				else
					AutoGPEnabled = false

					return false
				end
			end
			Character = v296:FindFirstChild("Laps")

			if Character then
				Character = v296.Laps:FindFirstChild("LapsLabel")
			end

			local v327 = v311

			HumanoidRootPart = 1

			while true do
				if not AutoGPEnabled then
					AutoGPEnabled = false

					return
				end

				repeat
					task.wait(0.2)
				until not AutoGPEnabled or (not AutoGPEnabled or (not n8.Visible or getTimerSeconds(n8.Text) == 0))

				if not AutoGPEnabled then
					AutoGPEnabled = false

					return
				end

				repeat
					task.wait(0.2)
				until not AutoGPEnabled or (not AutoGPEnabled or n8.Visible and getTimerSeconds(n8.Text) > 0)

				if not AutoGPEnabled then
					AutoGPEnabled = false

					return
				end

				u288 = math.random(0, 40) * 0.1

				if u288 > 0 then
					task.wait(u288)
				end

				if not AutoGPEnabled then
					AutoGPEnabled = false

					return
				end

				if Character then
					u288 = Character.Text:match("^(%d+)/%d+")
					HumanoidRootPart = tonumber(u288) or (HumanoidRootPart or false)
				end

				for i = 1, HumanoidRootPart do
					if not AutoGPEnabled then
						break
					end

					for i2 = 2, #GP_TRACK do
						if not AutoGPEnabled then
							break
						end

						gpMoveTo(GP_TRACK[i2])
					end
				end

				if not AutoGPEnabled then
					AutoGPEnabled = false

					return
				end

				u288 = getGPModel()

				if not tweenVehicleToStart(u288) then
					if not v327() then
						AutoGPEnabled = false

						return
					end

					tweenVehicleToStart(getGPModel())
				end

				if not ((Humanoid.SeatPart or v327()) and AutoGPEnabled) then
					AutoGPEnabled = false

					return
				end

				task.wait(1)
			end
		end
	end
end

local function v330(p51, p52, p53, p54)
	local function v331(...)
		return {
			...,
			["n"] = select("#", ...),
		}
	end

	local v332 = p51()

	if v332 then
		v405 = pcall

		local v333 = v332
		local anchored = true

		pcall(function()
			local v335
			local v336, v337

			v335, v336, v337 = pairs(v333:GetDescendants())

			while true do
				local v338

				v337, v338 = v335(v336, v337)

				if v337 == nil then
					break
				end

				if v338:IsA("BasePart") then
					v338.Anchored = anchored
				end
			end
		end)
	end

	local n11 = 0
	local Position

	if v332 then
		Position = v332:GetPivot().Position or p52
	else
		Position = p52
	end

	local Unit = nil

	if v332 then
		v332 = p52 - v332:GetPivot().Position

		if v332.Magnitude > 1 then
			Unit = v332.Unit
		end
	end

	while true do
		v332 = AutoPettaraniEnabled and not (p54 and p54()) and p51()

		if not v332 then
			break
		end

		local Position2 = v332:GetPivot().Position
		local v343 = p52 - Position2

		if v343.Magnitude < 6 then
			break
		end

		if Unit and Unit:Dot(v343.Unit) < -0.1 then
			v331 = v331(CFrame.new(p52))
			n11 = select(4, unpack(v331, 1, 4))
			v332:PivotTo(unpack(v331, 1, v331.n))

			break
		end

		local result = RunService.Heartbeat:Wait()

		if (Position2 - Position).Magnitude >= 0.3 then
			Position = Position2
			n11 = 0
		else
			n11 = n11 + result

			if not (n11 <= 1.5) then
				v331 = v331(CFrame.new(p52))
				n11 = select(4, unpack(v331, 1, 4))
				v332:PivotTo(unpack(v331, 1, v331.n))

				break
			end
		end

		Position2 = Position2 + v343.Unit * p53 * result
		Position2 = v331(CFrame.new(Position2))
		v343 = select(2, unpack(Position2, 1, 2))
		v332:PivotTo(unpack(Position2, 1, Position2.n))
	end

	v331 = p51()

	if not v331 then
		return
	end

	v332 = pcall

	local anchored = false
	local v346 = v331

	pcall(function()
		local v349
		local v350, v351

		v349, v350, v351 = pairs(v346:GetDescendants())

		while true do
			local v352

			v351, v352 = v349(v350, v351)

			if v351 == nil then
				break
			end

			if v352:IsA("BasePart") then
				v352.Anchored = anchored
			end
		end
	end)
end
local function v353(p55)
	local function v354(...)
		return {
			...,
			["n"] = select("#", ...),
		}
	end

	local v355 = PETTARANI_SPEED * 1.2
	local value = PETTARANI_TRACK[1]
	local Position = p55()

	if Position then
		v429 = pcall

		local v356 = Position
		local anchored = true

		pcall(function()
			local v358
			local v359, v360

			v358, v359, v360 = pairs(v356:GetDescendants())

			while true do
				local v361

				v360, v361 = v358(v359, v360)

				if v360 == nil then
					break
				end

				if v361:IsA("BasePart") then
					v361.Anchored = anchored
				end
			end
		end)
	end

	if Position then
		Position = Position:GetPivot().Position or value
	else
		Position = value
	end

	local n12 = 0

	while AutoPettaraniEnabled do
		local v363 = p55()
		local Position2 = v363:GetPivot().Position

		if (value - Position2).Magnitude < 8 then
			break
		end

		if (Position2 - Position).Magnitude >= 0.1 then
			n12 = 0
		else
			n12 = n12 + 0.1

			if not (n12 <= 2) then
				v355 = v354(CFrame.new(value))
				value = select(5, unpack(v355, 1, 5))
				v363:PivotTo(unpack(v355, 1, v355.n))

				break
			end
		end

		Position = RunService.Heartbeat:Wait()
		Position = Position2 + (value - Position2).Unit * v355 * Position
		Position = v354(CFrame.new(Position))

		local value2 = select(2, unpack(Position, 1, 2))

		v363:PivotTo(unpack(Position, 1, Position.n))
		Position = Position2
	end

	v355 = p55()

	if not v355 then
		task.wait(1)

		return
	end

	v354 = v354(CFrame.new(PETTARANI_START_POS + Vector3.new(0, 2, 0)))
	value = select(7, unpack(v354, 1, 7))
	v355:PivotTo(unpack(v354, 1, v354.n))
	v354 = pcall

	local anchored = false
	local v367 = v355

	pcall(function()
		local v368
		local v369, v370

		v368, v369, v370 = pairs(v367:GetDescendants())

		while true do
			local v371

			v370, v371 = v368(v369, v370)

			if v370 == nil then
				break
			end

			if v371:IsA("BasePart") then
				v371.Anchored = anchored
			end
		end
	end)
	task.wait(1)
end

function startAutoPettaraniRace()
	local function v372(...)
		return {
			...,
			["n"] = select("#", ...),
		}
	end

	local Character = LP.Character or LP.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

	HumanoidRootPart.CFrame = CFrame.new(PETTARANI_SPAWN_POS + Vector3.new(0, 3, 0))
	task.wait(0.5)

	if not AutoPettaraniEnabled then
		return
	end

	WindUI:Notify({
		["Title"] = "Auto Pettarani",
		["Content"] = "Spawning vehicle...",
		["Duration"] = 2,
	})
	RS:WaitForChild("SpawnCarEvents"):WaitForChild("SpawnCar"):FireServer(PETTARANI_MOTOR)
	task.wait(2.5)

	if not AutoPettaraniEnabled then
		return
	end

	HumanoidRootPart.CFrame = CFrame.new(PETTARANI_ENTER_POS + Vector3.new(0, 3, 0))
	task.wait(0.5)
	HoldE(VEHICLE_ENTER_HOLD)

	local v376 = false

	for i = 1, 20 do
		task.wait(0.2)

		if Humanoid.SeatPart then
			if Humanoid.SeatPart:FindFirstAncestorOfClass("Model") then
				v376 = true

				break
			end
		end
	end

	if not v376 then
		HumanoidRootPart.CFrame = CFrame.new(PETTARANI_ENTER_POS + Vector3.new(0, 3, 0))
		task.wait(0.3)
		HoldE(VEHICLE_ENTER_HOLD)
		task.wait(1)
	end

	local SeatPart = Humanoid.SeatPart

	if SeatPart then
		SeatPart = Humanoid.SeatPart:FindFirstAncestorOfClass("Model")
	end

	if not SeatPart then
		WindUI:Notify({
			["Title"] = "Auto Pettarani",
			["Content"] = "Failed to enter vehicle!",
			["Duration"] = 4,
		})
		AutoPettaraniEnabled = false

		return
	end

	WindUI:Notify({
		["Title"] = "Auto Pettarani",
		["Content"] = "In vehicle! Moving to start...",
		["Duration"] = 2,
	})

	local v379 = Humanoid
	local v380 = SeatPart
	local v381 = Character

	local function v382()
		return v379.SeatPart and v379.SeatPart:FindFirstAncestorOfClass("Model") or (v380 or v381)
	end

	local Model = Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") or (SeatPart or (Character or false))

	if Model and Model ~= Character then
		v372 = v372(CFrame.new(PETTARANI_START_POS + Vector3.new(0, 2, 0)))
		v376 = select(23, unpack(v372, 1, 23))
		Model:PivotTo(unpack(v372, 1, v372.n))
	else
		HumanoidRootPart.CFrame = CFrame.new(PETTARANI_START_POS + Vector3.new(0, 3, 0))
	end

	task.wait(0.5)

	if not AutoPettaraniEnabled then
		return
	end

	v372 = LP:WaitForChild("PlayerGui")
	Model = nil
	v376 = nil

	local RaceGui, Timers

	while true do
		task.wait(0.3)

		if not AutoPettaraniEnabled then
			break
		end

		RaceGui = v372:FindFirstChild("RaceGui")

		if RaceGui then
			RaceGui = RaceGui:FindFirstChild("RaceInfoFrame")

			if RaceGui then
				Timers = RaceGui:FindFirstChild("Timers")

				if Timers then
					Model = Timers:FindFirstChild("TotalLabel")
				end

				RaceGui = RaceGui:FindFirstChild("Laps")

				if RaceGui then
					v376 = RaceGui:FindFirstChild("LapsLabel")
				end
			end
		end

		if not AutoPettaraniEnabled or Model ~= nil then
			break
		end
	end

	if not AutoPettaraniEnabled then
		return
	end

	if not Model then
		WindUI:Notify({
			["Title"] = "Auto Pettarani",
			["Content"] = "RaceGui not found!",
			["Duration"] = 4,
		})
		AutoPettaraniEnabled = false

		return
	end

	local v386 = SeatPart
	local v387 = HumanoidRootPart
	local v388 = Humanoid

	v372 = function()
		local function v389(...)
			return {
				...,
				["n"] = select("#", ...),
			}
		end

		if not (v386 and v386.Parent) then
			AutoPettaraniEnabled = false

			return false
		end
		local Position

		v389 = v389(CFrame.new(PETTARANI_START_POS + Vector3.new(0, 3, 0)))

		local value = select(7, unpack(v389, 1, 7))

		v386:PivotTo(unpack(v389, 1, v389.n))
		task.wait(0.3)
		v387.CFrame = CFrame.new(PETTARANI_START_POS + Vector3.new(0, 3, -3))
		task.wait(0.3)
		Position = v387.Position

		local u392 = nil
		local n13 = 30

		local v394 = PETTARANI_MOTOR
		local v395 = Position

		pcall(function()
			local v396, v397, v398 = pairs(Workspace:GetDescendants())

			while true do
				local v399

				v398, v399 = v396(v397, v398)

				if v398 == nil then
					return
				end

				if v399:IsA("Model") and v399.Name == v394 then
					local Magnitude = (v399:GetPivot().Position - v395).Magnitude

					if Magnitude < n13 then
						local VehicleSeat = v399:FindFirstChildWhichIsA("VehicleSeat", true)

						VehicleSeat = VehicleSeat and VehicleSeat:FindFirstChildOfClass("ProximityPrompt")

						if VehicleSeat then
							u392 = VehicleSeat
							n13 = Magnitude
						end

						if not u392 then
							local v402

							v399, VehicleSeat, v402 = pairs(v399:GetDescendants())

							while true do
								local v403

								v402, v403 = v399(VehicleSeat, v402)

								if v402 == nil then
									break
								end

								if v403:IsA("ProximityPrompt") then
									u392 = v403
									n13 = Magnitude

									break
								end
							end
						end
					end
				end
			end
		end)
		v389 = nil

		if true then
			task.wait(1)

			if v388.SeatPart and v388.SeatPart:FindFirstAncestorOfClass("Model") then
				return true
			else
				AutoPettaraniEnabled = false

				return false
			end

			return
		end

		local v404 = v389

		pcall(function()
			v404.Enabled = true
		end)

		local v406 = v389

		pcall(function()
			v406.HoldDuration = 0
		end)
		fireproximityprompt(v389)
		task.wait(1)

		if v388.SeatPart and v388.SeatPart:FindFirstAncestorOfClass("Model") then
			return true
		else
			AutoPettaraniEnabled = false

			return false
		end
	end
	HumanoidRootPart = 1

	while AutoPettaraniEnabled do
		local v407

		while true do
			task.wait(0.2)

			if not (AutoPettaraniEnabled and (AutoPettaraniEnabled and Model.Visible)) then
				break
			end

			RaceGui, Timers, v407 = Model.Text:match("(%d+):(%d+)%.(%d+)")

			if (not (RaceGui and (Timers and v407)) and 0 or tonumber(RaceGui) * 60 + tonumber(Timers) + tonumber(v407) / 100) == 0 then
				break
			end
		end

		if not AutoPettaraniEnabled then
			break
		end

		while true do
			task.wait(0.2)

			if not (AutoPettaraniEnabled and AutoPettaraniEnabled) then
				break
			end

			if Model.Visible then
				RaceGui, Timers, v407 = Model.Text:match("(%d+):(%d+)%.(%d+)")

				if (not (RaceGui and (Timers and v407)) and 0 or tonumber(RaceGui) * 60 + tonumber(Timers) + tonumber(v407) / 100) > 0 then
					break
				end
			end
		end

		if not AutoPettaraniEnabled then
			break
		end

		RaceGui = math.random(0, 40) * 0.1

		if RaceGui > 0 then
			task.wait(RaceGui)
		end

		if not AutoPettaraniEnabled then
			break
		end

		if v376 then
			RaceGui = v376.Text:match("^(%d+)/%d+")
			HumanoidRootPart = tonumber(RaceGui) or (HumanoidRootPart or false)
		end

		WindUI:Notify({
			["Title"] = "Auto Pettarani",
			["Content"] = "Race Start!",
			["Duration"] = 2,
		})

		for i = 1, HumanoidRootPart do
			if not AutoPettaraniEnabled then
				break
			end

			local n14 = 2
			local n15 = 0

			while n14 <= #PETTARANI_TRACK do
				if not AutoPettaraniEnabled then
					break
				end

				local v410 = PETTARANI_TRACK[n14]

				v330(v382, v410, PETTARANI_SPEED, function()
					return not AutoPettaraniEnabled
				end)

				if not AutoPettaraniEnabled then
					break
				end

				local Model2 = Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") or (SeatPart or (Character or false))

				if Model2 then
					Model2 = Model2:GetPivot().Position
				end

				if (Model2 and ((Model2 - v410).Magnitude or 0) or 0) <= 18 or n15 >= 2 then
					n14 = n14 + 1
					n15 = 0
				else
					n15 = n15 + 1

					if n14 > 2 then
						v410 = PETTARANI_TRACK[n14 - 1]

						if (v410 - Model2).Magnitude > 10 then
							v330(v382, v410, PETTARANI_SPEED * 0.8, function()
								return not AutoPettaraniEnabled
							end)

							if not AutoPettaraniEnabled then
								break
							end
						end
					end
				end
			end
		end

		if not AutoPettaraniEnabled then
			break
		end

		WindUI:Notify({
			["Title"] = "Auto Pettarani",
			["Content"] = "Finish!",
			["Duration"] = 3,
		})
		v353(v382)

		if not Humanoid.SeatPart then
			if not v372() then
				break
			end

			v353(v382)
		end

		if not AutoPettaraniEnabled then
			break
		end

		task.wait(1)
	end

	AutoPettaraniEnabled = false
	pcall(function()
		local Character2 = LP.Character

		if Character2 then
			Character2 = LP.Character:FindFirstChildOfClass("Humanoid")
		end

		Character2 = Character2 and Character2.SeatPart and Character2.SeatPart:FindFirstAncestorOfClass("Model")

		if not Character2 then
			return
		end
		local anchored = false
		local v415 = Character2

		pcall(function()
			local v416
			local v417, v418

			v416, v417, v418 = pairs(v415:GetDescendants())

			while true do
				local v419

				v418, v419 = v416(v417, v418)

				if v418 == nil then
					break
				end

				if v419:IsA("BasePart") then
					v419.Anchored = anchored
				end
			end
		end)
	end)
	WindUI:Notify({
		["Title"] = "Auto Pettarani",
		["Content"] = "Stopped.",
		["Duration"] = 2,
	})
end
function startAutoDragPettarani()
	local function v420(...)
		return {
			...,
			["n"] = select("#", ...),
		}
	end

	local Character = LP.Character or LP.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

	HumanoidRootPart.CFrame = CFrame.new(DRAG_PETTARANI_SPAWN_POS + Vector3.new(0, 3, 0))
	task.wait(0.5)

	if not AutoDragPettaraniEnabled then
		return
	end

	RS:WaitForChild("SpawnCarEvents"):WaitForChild("SpawnCar"):FireServer(DRAG_PETTARANI_MOTOR)
	task.wait(2.5)

	if not AutoDragPettaraniEnabled then
		return
	end

	HumanoidRootPart.CFrame = CFrame.new(DRAG_PETTARANI_ENTER_POS + Vector3.new(0, 3, 0))
	task.wait(0.5)
	HoldE(VEHICLE_ENTER_HOLD)

	local v424 = false

	for i = 1, 20 do
		task.wait(0.2)

		if Humanoid.SeatPart then
			if Humanoid.SeatPart:FindFirstAncestorOfClass("Model") then
				v424 = true

				return
			end
		end
	end

	if not v424 then
		HumanoidRootPart.CFrame = CFrame.new(DRAG_PETTARANI_ENTER_POS + Vector3.new(0, 3, 0))
		task.wait(0.3)
		HoldE(VEHICLE_ENTER_HOLD)
		task.wait(1)
	end

	local SeatPart = Humanoid.SeatPart

	if SeatPart then
		SeatPart = Humanoid.SeatPart:FindFirstAncestorOfClass("Model")
	end

	if not SeatPart then
		AutoDragPettaraniEnabled = false

		return
	end

	local _ = Humanoid
	local _ = SeatPart
	local _ = Character
	local v430 = Humanoid
	local v431 = SeatPart
	local v432 = Character

	local function v433(p56)
		local function v434(...)
			return {
				...,
				["n"] = select("#", ...),
			}
		end

		local Model = v430.SeatPart and v430.SeatPart:FindFirstAncestorOfClass("Model") or (v431 or v432)

		if not Model then
			return
		end

		local pcall_ = pcall
		local v437 = Model
		local anchored = true

		pcall(function()
			local v439
			local v440, v441

			v439, v440, v441 = pairs(v437:GetDescendants())

			while true do
				local v442

				v441, v442 = v439(v440, v441)

				if v441 == nil then
					break
				end

				if v442:IsA("BasePart") then
					v442.Anchored = anchored
				end
			end
		end)
		pcall_ = p56 - Model:GetPivot().Position
		pcall_ = pcall_.Magnitude > 1 and pcall_.Unit or nil
		Model = Model:GetPivot().Position

		local n16 = 0

		while true do
			local Model2 = AutoDragPettaraniEnabled and (v430.SeatPart and v430.SeatPart:FindFirstAncestorOfClass("Model") or (v431 or v432))

			if not Model2 then
				break
			end

			local Position = Model2:GetPivot().Position
			local v446 = p56 - Position

			if v446.Magnitude < 6 then
				break
			end

			if pcall_ and pcall_:Dot(v446.Unit) < -0.1 then
				v434 = v434(CFrame.new(p56))
				Model = select(8, unpack(v434, 1, 8))
				Model2:PivotTo(unpack(v434, 1, v434.n))

				break
			end

			local result = RunService.Heartbeat:Wait()

			if (Position - Model).Magnitude >= 0.3 then
				Model = Position
				n16 = 0
			else
				n16 = n16 + result

				if not (n16 <= 1.5) then
					v434 = v434(CFrame.new(p56))
					Model = select(6, unpack(v434, 1, 6))
					Model2:PivotTo(unpack(v434, 1, v434.n))

					break
				end
			end

			Position = v434(CFrame.new(Position + v446.Unit * DRAG_PETTARANI_SPEED * result))
			v446 = select(6, unpack(Position, 1, 6))
			Model2:PivotTo(unpack(Position, 1, Position.n))
		end

		v434 = v430.SeatPart and v430.SeatPart:FindFirstAncestorOfClass("Model") or (v431 or v432)

		if not v434 then
			return
		end

		local v448 = v434

		v434 = pcall

		local anchored2 = false

		pcall(function()
			local v450
			local v451, v452

			v450, v451, v452 = pairs(v448:GetDescendants())

			while true do
				local v453

				v452, v453 = v450(v451, v452)

				if v452 == nil then
					break
				end

				if v453:IsA("BasePart") then
					v453.Anchored = anchored2
				end
			end
		end)
	end

	local v454 = DRAG_PETTARANI_TRACK[1]

	v424 = Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") or (SeatPart or (Character or false))

	local pcall_, value

	if v424 and v424 ~= Character then
		pcall_ = v420(CFrame.new(v454 + Vector3.new(0, 2, 0)))
		value = select(7, unpack(pcall_, 1, 7))
		v424:PivotTo(unpack(pcall_, 1, pcall_.n))
	else
		HumanoidRootPart.CFrame = CFrame.new(v454 + Vector3.new(0, 3, 0))
	end

	task.wait(2)

	if not AutoDragPettaraniEnabled then
		return
	end

	WindUI:Notify({
		["Title"] = "Auto Drag Pettarani",
		["Content"] = "Race started!",
		["Duration"] = 2,
	})

	while true do
		if not AutoDragPettaraniEnabled then
			AutoDragPettaraniEnabled = false

			return
		end

		for i = 2, #DRAG_PETTARANI_TRACK do
			if not AutoDragPettaraniEnabled then
				break
			end

			v433(DRAG_PETTARANI_TRACK[i])
		end

		if not AutoDragPettaraniEnabled then
			AutoDragPettaraniEnabled = false

			return
		end

		WindUI:Notify({
			["Title"] = "Auto Drag Pettarani",
			["Content"] = "Finish!",
			["Duration"] = 2,
		})
		v424 = Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") or (SeatPart or (Character or false))

		if v424 and v424 ~= Character then
			pcall_ = pcall

			local v458 = v424
			local anchored = true

			pcall(function()
				local v460
				local v461, v462

				v460, v461, v462 = pairs(v458:GetDescendants())

				while true do
					local v463

					v462, v463 = v460(v461, v462)

					if v462 == nil then
						break
					end

					if v463:IsA("BasePart") then
						v463.Anchored = anchored
					end
				end
			end)
			pcall_ = v420(CFrame.new(v454 + Vector3.new(0, 2, 0)))
			value = select(6, unpack(pcall_, 1, 6))
			v424:PivotTo(unpack(pcall_, 1, pcall_.n))
			pcall_ = pcall

			local v464 = v424
			local anchored2 = false

			pcall(function()
				local v466
				local v467, v468

				v466, v467, v468 = pairs(v464:GetDescendants())

				while true do
					local v469

					v468, v469 = v466(v467, v468)

					if v468 == nil then
						break
					end

					if v469:IsA("BasePart") then
						v469.Anchored = anchored2
					end
				end
			end)
		else
			HumanoidRootPart.CFrame = CFrame.new(v454 + Vector3.new(0, 3, 0))
		end

		task.wait(2)

		if AutoDragPettaraniEnabled then
			WindUI:Notify({
				["Title"] = "Auto Drag Pettarani",
				["Content"] = "Race started!",
				["Duration"] = 2,
			})
		end
	end
end
function dragSetup(_)
	if game.PlaceId == MAIN_PLACE_ID then
		game:GetService("TeleportService"):Teleport(SENTUL_PLACE_ID, LP)
		AutoDragEnabled = false

		return nil, nil
	end

	local Character = LP.Character or LP.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local v473 = DragSlotData[DRAG_MODE]

	if not v473 then
		if v473 then
			HumanoidRootPart.CFrame = CFrame.new(v473.start + Vector3.new(0, 3, 0))
			task.wait(1)
			HumanoidRootPart = 0

			repeat
				task.wait(0.1)
				HumanoidRootPart = HumanoidRootPart + 0.1
			until Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") or HumanoidRootPart > 20

			if not (Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model")) then
				WindUI:Notify({
					["Title"] = "Auto Drag",
					["Content"] = "Failed to seat on vehicle",
					["Duration"] = 4,
				})

				return nil, nil
			end

			return
		else
			return nil, nil
		end

		return
	end

	v473 = DragSlotData[DRAG_MODE][DRAG_SLOT]

	if v473 then
		HumanoidRootPart.CFrame = CFrame.new(v473.start + Vector3.new(0, 3, 0))
		task.wait(1)
		HumanoidRootPart = 0

		repeat
			task.wait(0.1)
			HumanoidRootPart = HumanoidRootPart + 0.1
		until Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model") or HumanoidRootPart > 20

		if not (Humanoid.SeatPart and Humanoid.SeatPart:FindFirstAncestorOfClass("Model")) then
			WindUI:Notify({
				["Title"] = "Auto Drag",
				["Content"] = "Failed to seat on vehicle",
				["Duration"] = 4,
			})

			return nil, nil
		end

		return
	else
		return nil, nil
	end
end
function startAutoDragLoop()
	local v474 = dragSetup(function()
		return not AutoDragEnabled
	end)

	if not v474 then
		AutoDragEnabled = false

		return
	end
end
function startAutoDragOneShot()
	local v476 = dragSetup(function()
		return false
	end)

	if not v476 then
		return
	end
end
function startCourierFarm()
	courierLoopRunning = true

	while true do
		if not (courierLoopRunning and CourierAutoFarm) then
			courierLoopRunning = false

			return
		end

		if not IsCourier() then
			ChangeTeamToCourier()
			task.wait(1)

			if not (courierLoopRunning and CourierAutoFarm) then
				courierLoopRunning = false

				return
			end
		end

		if not HasJob and (not WaitingForNextQuest and TweenTP(START_JOB)) then
			task.wait(2)
			PressF()
			HasJob = true
			WaitingForNextQuest = true
		end

		local Livrason = Workspace:FindFirstChild("Livrason")

		if not Livrason then
			task.wait(5)

			if not (courierLoopRunning and CourierAutoFarm) then
				courierLoopRunning = false

				return
			end
		end

		for i = 1, 8 do
			local v480 = Livrason.Location:FindFirstChild((tostring(i)))

			if not (v480 or courierLoopRunning and CourierAutoFarm) then
				break
			end

			local ProximityPrompt, v482, v483 = ipairs(v480:GetChildren())

			v480 = i

			local v484 = nil

			while true do
				local v485

				v483, v485 = ProximityPrompt(v482, v483)

				if v483 == nil then
					v485 = v484

					return
				end

				if v485:IsA("BasePart") and v485:FindFirstChildWhichIsA("ProximityPrompt") then
					break
				end
			end

			if v556 then
				ProximityPrompt = v556:FindFirstChildWhichIsA("ProximityPrompt")

				if ProximityPrompt then
					if ProximityPrompt.Enabled then
						ProximityPrompt = DESTINATIONS[tostring(i)]

						if ProximityPrompt then
							CurrentDest = i

							if TweenTP(ProximityPrompt.pos) then
								task.wait(2.5)
								pcall(PressF)
								EquipAndGrabNewBox()
							end

							HasJob = false
							task.wait(15)

							break
						end
					end
				end
			end
		end

		task.wait(0.4)
	end
end
function startQuestFarm()
	questLoopRunning = true

	while questLoopRunning and QuestAutoFarm do
		if not CurrentQuest and (GetQuestBoard() and AcceptQuest()) then
			CurrentQuest = "Active"
			task.wait(2)

			if CompleteQuest() then
				QuestCompleted = QuestCompleted + 1
				CurrentQuest = nil
				task.wait(5)
			end
		end

		task.wait(1)
	end

	questLoopRunning = false
end
function startBaristaFarm()
	baristaLoopRunning = true
	StartBaristaMinigame()

	local function v486()
		return not (BaristaAutoFarm and baristaLoopRunning)
	end

	toggleNoclip(true)

	local v487 = GetHum()
	local v488 = GetHRP()

	if v487 and v488 and (BaristaAutoFarm and baristaLoopRunning) then
		WalkThroughWaypoints(v487, v488, { BaristaPos.Brew }, 16, 20, v486)
	end

	toggleNoclip(false)
	v487 = GetHum()
	v488 = GetHRP()

	if v487 then
		v487:MoveTo(v488.Position)
	end

	task.wait(0.3)

	if BaristaAutoFarm and baristaLoopRunning then
		PressE()
		task.wait(5)
	end

	while BaristaAutoFarm and baristaLoopRunning do
		if not (IsBarista() and HasBaristaMission()) then
			BaristaAutoFarm = false

			break
		end

		if IsMachineBroken() then
			toggleNoclip(false)
			FixBrokenMachine()

			if BaristaAutoFarm and baristaLoopRunning then
				v487 = GetHum()
				v488 = GetHRP()

				if v487 and v488 then
					WalkThroughWaypoints(v487, v488, { BaristaPos.Brew }, 16, 15, v486)
				end

				if v487 then
					v487:MoveTo(v488.Position)
				end

				task.wait(0.2)
				PressE()
				task.wait(5)
			end
		else
			if BaristaAutoFarm and baristaLoopRunning then
				v487 = GetHum()
				v488 = GetHRP()

				if v487 and v488 then
					WalkThroughWaypoints(v487, v488, { BaristaPos.Cash }, 16, 15, v486)
				end

				if v487 then
					v487:MoveTo(v488.Position)
				end

				if BaristaAutoFarm and baristaLoopRunning then
					task.wait(0.2)
					HoldE(1.5)
					task.wait(0.8)
				end
			end

			if not (BaristaAutoFarm and baristaLoopRunning) then
				toggleNoclip(false)
				StopBaristaMinigame()
				baristaLoopRunning = false

				return
			end

			v487 = GetHum()
			v488 = GetHRP()

			if v487 and v488 then
				WalkThroughWaypoints(v487, v488, { BaristaPos.Brew }, 16, 15, v486)
			end

			if v487 then
				v487:MoveTo(v488.Position)
			end

			if BaristaAutoFarm and baristaLoopRunning then
				task.wait(0.2)
				PressE()
				task.wait(5)
			end
		end
	end

	toggleNoclip(false)
	StopBaristaMinigame()
	baristaLoopRunning = false
end

getgenv().BARISTA_ROUTE_MOTOR = "Yamahax-MioSporty"
windUI = getgenv()
vector3 = {}
vector32 = Vector3.new(-752, 2, -639)
vector33 = Vector3.new(-889, 2, -634)
vector34 = Vector3.new(-936, 4, -632)
vector35 = Vector3.new(-1015, 10, -631)
vector36 = Vector3.new(-1113, 17, -628)
vector37 = Vector3.new(-1313, 31, -623)
vector38 = Vector3.new(-1405, 37, -620)
vector39 = Vector3.new(-1493, 38, -618)
vector310 = Vector3.new(-1629, 38, -616)
vector311 = Vector3.new(-2222, 38, -601)
vector312 = Vector3.new(-2255, 38, -602)
vector313 = Vector3.new(-2289, 35, -601)
vector314 = Vector3.new(-2392, 28, -598)
vector315 = Vector3.new(-2559, 17, -593)
vector316 = Vector3.new(-2642, 11, -592)

local vector317 = Vector3.new(-2726, 5, -590)

vector3[1] = vector32
vector3[2] = vector33
vector3[3] = vector34
vector3[4] = vector35
vector3[5] = vector36
vector3[6] = vector37
vector3[7] = vector38
vector3[8] = vector39
vector3[9] = vector310
vector3[10] = vector311
vector3[11] = vector312
vector3[12] = vector313
vector3[13] = vector314
vector3[14] = vector315
vector3[15] = vector316
vector3[16] = vector317
vector32 = Vector3.new(-2740, 4, -590)
vector33 = Vector3.new(-2767, 3, -590)
vector34 = Vector3.new(-5021, 3, -583)
v1 = v1(Vector3.new(-5021, 3, -646))
vector3[17] = vector32
vector3[18] = vector33
vector3[19] = vector34
v2(vector3, 20, v1, 1)
windUI.BARISTA_ROUTE_WAYPOINTS = vector3

function startBaristaRouteTravel(_, p57)
	local Character = LP.Character or LP.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")

	Character = Character:WaitForChild("HumanoidRootPart")

	local function v492()
		return not BaristaAutoFarm
	end

	local vector318 = Vector3.new(-4991, 4, -715)

	Character.CFrame = CFrame.new(vector318)
	task.wait(0.3)

	if not (BaristaAutoFarm and true or false) then
		restoreBaristaSeats()

		return
	end

	Humanoid.Sit = true
	task.wait(0.8)

	if not (BaristaAutoFarm and true or false) then
		Humanoid.Sit = false
		restoreBaristaSeats()

		return
	end

	Humanoid.Sit = false
	task.wait(0.2)
	Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	task.wait(0.4)
	Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
	task.wait(0.3)

	if not (BaristaAutoFarm and true or false) then
		restoreBaristaSeats()

		return
	end

	PressE()
	task.wait(0.5)

	if not (BaristaAutoFarm and true or false) then
		restoreBaristaSeats()

		return
	end

	StartBaristaMinigame()
	toggleNoclip(false)
	WalkThroughWaypoints(Humanoid, Character, { BaristaPos.Brew }, 16, 15, v492)

	if not p57 then
		return
	end

	BaristaAutoFarm = true
	BaristaState = "Brew"
	baristaLoopRunning = false
	task.wait(0.2)
	task.spawn(startBaristaFarm)
end

v1 = task.spawn

v1(function()
	if WindUI then
		if type(WindUI) == "table" then
			if not WindUI.CreateWindow then
				return
			end

			return
		else
			return
		end

		return
	else
		return
	end
end)
v1 = LP.CharacterAdded

local v496 = ok

v1:Connect(function(p58)
	p58:WaitForChild("Humanoid")
	task.wait(1.5)

	if isFrozen then
		setFrozen(true)
	end

	if OfficeAutoFarm then
		v496()
		OfficeAnsweredIDs = {}
		task.wait(0.5)
		OfficeSitOnChair(true)
		OfficeStartWatcher()
	end

	if BaristaAutoFarm then
		task.wait(2)
		StartBaristaMinigame()
	end

	if antiAdminEnabled then
		task.wait(1)
		EnableAntiAdmin()
	end

	pcall(function()
		game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]:Destroy()
	end)
end)
print("this script made by komtolmmek2 script")
pcall(function()
	local PlayerListFrame = game:GetService("StarterGui").RaceGui.LeaderboardFrame.PlayerListFrame
	local v498 = PlayerListFrame

	local function v499()
		local pcall_ = v498
		local v501, v502

		pcall_, v501, v502 = ipairs(v498:GetChildren())

		local t6 = {}
		local pcall_2

		while true do
			v502, pcall_2 = pcall_(v501, v502)

			if v502 == nil then
				break
			end

			if pcall_2:IsA("Frame") and pcall_2.Name == "PlayerFrame" then
				table.insert(t6, pcall_2)
			end
		end

		if #t6 > 1 then
			for i = 2, #t6 do
				pcall_2 = pcall

				local v506 = t6
				local v507 = i

				pcall(function()
					v506[v507]:Destroy()
				end)
			end
		end

		if not t6[1] then
			return
		end

		pcall_ = pcall

		local v508 = t6

		pcall(function()
			v508[1].NameLabel.Text = "Cyraa Hub on top"
		end)
	end

	v499()
	PlayerListFrame = PlayerListFrame.ChildAdded

	local v509 = v499

	PlayerListFrame:Connect(function(p59)
		if not (p59:IsA("Frame") and p59.Name == "PlayerFrame") then
			return
		end

		task.wait(0.05)
		v509()
	end)
end)
pcall(function()
	local PlayerListFrame = LP.PlayerGui:WaitForChild("RaceGui", 30):WaitForChild("LeaderboardFrame", 10):WaitForChild("PlayerListFrame", 10)
	local v511 = PlayerListFrame

	local function v512()
		local pcall_ = v511
		local v514, v515

		pcall_, v514, v515 = ipairs(v511:GetChildren())

		local t7 = {}
		local pcall_2

		while true do
			v515, pcall_2 = pcall_(v514, v515)

			if v515 == nil then
				break
			end

			if pcall_2:IsA("Frame") and pcall_2.Name == "PlayerFrame" then
				table.insert(t7, pcall_2)
			end
		end

		if #t7 > 1 then
			for i = 2, #t7 do
				pcall_2 = pcall

				local v519 = t7
				local v520 = i

				pcall(function()
					v519[v520]:Destroy()
				end)
			end
		end

		if not t7[1] then
			return
		end

		pcall_ = pcall

		local v521 = t7

		pcall(function()
			v521[1].NameLabel.Text = "Cyraa Hub on top"
		end)
	end

	v512()
	PlayerListFrame = PlayerListFrame.ChildAdded

	local v522 = v512

	PlayerListFrame:Connect(function(p60)
		if not (p60:IsA("Frame") and p60.Name == "PlayerFrame") then
			return
		end

		task.wait(0.05)
		v522()
	end)
end)
LP.CharacterAdded:Connect(function()
	task.wait(2)
	pcall(function()
		local PlayerListFrame = game:GetService("StarterGui").RaceGui.LeaderboardFrame.PlayerListFrame
		local v524 = PlayerListFrame

		local function v525()
			local pcall_ = v524
			local v527, v528

			pcall_, v527, v528 = ipairs(v524:GetChildren())

			local t8 = {}
			local pcall_2

			while true do
				v528, pcall_2 = pcall_(v527, v528)

				if v528 == nil then
					break
				end

				if pcall_2:IsA("Frame") and pcall_2.Name == "PlayerFrame" then
					table.insert(t8, pcall_2)
				end
			end

			if #t8 > 1 then
				for i = 2, #t8 do
					pcall_2 = pcall

					local v532 = t8
					local v533 = i

					pcall(function()
						v532[v533]:Destroy()
					end)
				end
			end

			if not t8[1] then
				return
			end

			pcall_ = pcall

			local v534 = t8

			pcall(function()
				v534[1].NameLabel.Text = "Cyraa Hub on top"
			end)
		end

		v525()
		PlayerListFrame = PlayerListFrame.ChildAdded

		local v535 = v525

		PlayerListFrame:Connect(function(p61)
			if not (p61:IsA("Frame") and p61.Name == "PlayerFrame") then
				return
			end

			task.wait(0.05)
			v535()
		end)
	end)
	pcall(function()
		local PlayerListFrame = LP.PlayerGui:WaitForChild("RaceGui", 30):WaitForChild("LeaderboardFrame", 10):WaitForChild("PlayerListFrame", 10)
		local v537 = PlayerListFrame

		local function v538()
			local pcall_ = v537
			local v540, v541

			pcall_, v540, v541 = ipairs(v537:GetChildren())

			local t9 = {}
			local pcall_2

			while true do
				v541, pcall_2 = pcall_(v540, v541)

				if v541 == nil then
					break
				end

				if pcall_2:IsA("Frame") and pcall_2.Name == "PlayerFrame" then
					table.insert(t9, pcall_2)
				end
			end

			if #t9 > 1 then
				for i = 2, #t9 do
					pcall_2 = pcall

					local v545 = t9
					local v546 = i

					pcall(function()
						v545[v546]:Destroy()
					end)
				end
			end

			if not t9[1] then
				return
			end

			pcall_ = pcall

			local v547 = t9

			pcall(function()
				v547[1].NameLabel.Text = "Cyraa Hub on top"
			end)
		end

		v538()
		PlayerListFrame = PlayerListFrame.ChildAdded

		local v548 = v538

		PlayerListFrame:Connect(function(p62)
			if not (p62:IsA("Frame") and p62.Name == "PlayerFrame") then
				return
			end

			task.wait(0.05)
			v548()
		end)
	end)
end)
