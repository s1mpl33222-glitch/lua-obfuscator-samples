--!nolint

local AutoUpdate = (...) or true

repeat
	task.wait()
until game:IsLoaded() -- Ensure the game is loaded so no possible errors. - lua_u

-- Disable AC
for i, v in pairs(getgc(true)) do
	if typeof(v) ~= "table" then continue end
	if rawget(v, "Detected") and typeof(rawget(v, "Detected")) == "function" then
		local old
		old = hookfunction(rawget(v, "Detected"), function(a, ...)
			if a == "crash" or a == "kick" then
				return
			else
				return old(a, ...)
			end
		end)
	end
end

-- Services (Global cuz yes)
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
Stats = game:GetService("Stats")
HttpService = game:GetService("HttpService")
HTTP = HttpService

-- Preloads to maintain support
Vector2_new = Vector2.new
Vector3_new = Vector3.new -- In my opinion you should use vector.create instead but you do you vro. - lua_u
CFrame_new = CFrame.new
CFrame_Angles = CFrame.Angles
Color3_fromRGB = Color3.fromRGB
math_clamp = math.clamp
math_floor = math.floor
math_rad = math.rad
math_abs = math.abs
math_max = math.max
LocalPlayer = Players.LocalPlayer
sharedRaycastParams = RaycastParams.new()
sharedRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
Camera = workspace.CurrentCamera

-- Local Vars
if not BaseUrl then
	BaseURL = "https://raw.githubusercontent.com/noristt/town/refs/heads/main/"
end
const IsLocal = isfile("SkidWare/Settings.json") and HttpService:JSONDecode(readfile("SkidWare/Settings.json")).DevelopmentBuild or false
const Environment = getfenv()
const TitleText = "SkidWare - made by noritery, modularized by lua_u"
const DataPing = Stats.Network.ServerStatsItem["Data Ping"]
local UpdateFlag = false
local FrameCounter = 0
local FPS = 60
local LastTick = tick()

-- Global Vars
AutoHealSelf = false
AutoHealNearby = false
AutoFixArmorSelf = false
AutoFixArmorNearby = false

-- Functions
const function HGet(url: string)
	local ret = request({
		Url = url,
		Method = "GET",
		Headers = {
			["Cache-Control"] = "no-cache"
		}
	})

	return ret.Body
end

const function Get(name: string, update: boolean?)
	if (not isfile("SkidWare/" .. name)) or update then
		print("Downloading", name)
		const code = HGet(BaseURL .. name)
		print("Got", name)
		writefile("SkidWare/" .. name, code)
	end

	return readfile("SkidWare/" .. name)
end

const function LoadTab(tab)
	local a, b = pcall(function()
		local module = Load("Tabs/" .. tab.Name:gsub(" ", "") .. ".lua")
	end)

	if not a then
		print(b)
	end
end

function Load(name: string)
	print("Loading", name)
	if IsLocal then
		local Func = loadstring(readfile("SkidWare/" .. name), name)
		setfenv(Func, Environment) -- Make sure whatever globals it adds goes to here. - lua_u
		return Func()
	else
		local Code = Get( name, UpdateFlag)
		if Code == "" then
			Code = Get(name, true)
		end
		local Func = loadstring(Code, name)
		if typeof(Func) ~= "function" then
			print("err", Func)
		end
		setfenv(Func, Environment) -- Make sure whatever globals it adds goes to here. - lua_u
		return Func()
	end
end

function RegisterDrawing(drawingObj)
	table.insert(DrawingRegistry, drawingObj)
	return drawingObj
end

-- Main Script Body
local CurrentVersion = Get("version")
const OtherVersion = HGet(BaseURL .. "version")
if (CurrentVersion ~= OtherVersion and not IsLocal) and AutoUpdate then -- Dont try to update if DevelopmentBuild is enabled, probably should switch it to auto-updating based on sha256 hash's but whatever. - lua_u
	UpdateFlag = true
	CurrentVersion = OtherVersion
	writefile("SkidWare/version", OtherVersion) -- This could fail if someone closes it down before it all loads, I or someone else should fix it in the near future cause I can NOT be damned to do it right now. - lua_u
end

-- Load ze UI Modules
Library = Load("Systems/UILibrary.lua")
ThemeManager = Load("Utilities/ThemeManager.lua")
SaveManager = Load("Utilities/SaveManager.lua")

-- BEHOLD THE LOADING OF THE UI (funny ultrakill reference ha)
Window = Library:CreateWindow({
	Title = TitleText,
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})
Library:SetWatermarkVisibility(true)

MainTab = Window:AddTab('Main')
CombatTab = Window:AddTab('Combat')
ModsTab = Window:AddTab('Mods')
VisualsTab = Window:AddTab('Visuals')
BuilderTab = Window:AddTab('Builder')
UISettingsTab = Window:AddTab('UI Settings')
InfoTab = Window:AddTab('Info')

DrawingRegistry = {}
ESPCache = {}
OriginalPartState = {}

const WatermarkConnection = RunService.RenderStepped:Connect(function()
	FrameCounter = FrameCounter + 1
	const CurrentTime = tick()
	if CurrentTime - LastTick >= 1 then
		FPS = FrameCounter
		FrameCounter = 0
		LastTick = CurrentTime
	end
end)

task.spawn(function()
	while task.wait(1/15) do
		local ping = 0
		pcall(function()
			ping = math_floor(DataPing:GetValue())
		end)--string.format("%s | %d FPS | %d ms", TitleText, FPS, ping)
		Library:SetWatermark(`{TitleText} | {FPS} FPS | {ping} ms`)
	end
end)

-- Load Ze Tabz
LoadTab(MainTab)
LoadTab(CombatTab)
LoadTab(ModsTab)
LoadTab(VisualsTab)
LoadTab(BuilderTab)
LoadTab(UISettingsTab)
LoadTab(InfoTab)

-- Last Shit

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind', 'AimbotKeybind', 'TriggerKeybind' })

ThemeManager:SetFolder('SkidWare Town')
SaveManager:SetFolder('SkidWare/configs')

SaveManager:BuildConfigSection(UISettingsTab)
ThemeManager:ApplyToTab(UISettingsTab)

SaveManager:LoadAutoloadConfig()

Load("Systems/ToolUser.lua") -- i forgot to load this LOL - lua_u