repeat wait() until game:IsLoaded()

if LPH_OBFUSCATED == nil then
	LPH_NO_VIRTUALIZE = function(...) return (...) end
	LPH_ENCSTR = function(...) return (...) end
	LRM_SANITIZE = function(...) return ... end
end

local cloneref = cloneref or function(o) return o end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local TextService = cloneref(game:GetService("TextService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Lighting = cloneref(game:GetService("Lighting"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local Workspace = cloneref(game:GetService("Workspace"))

local LocalPlayer = cloneref(Players.LocalPlayer)

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

if identifyexecutor and identifyexecutor() == "Wave" then
	getgenv().gethui = function()
		return game:GetService("CoreGui")
	end
end

local Folder_Configs = {
	Directory = "solixhub",
	Assets = "solixhub/Assets",
	Configs = "solixhub/Configs",
	Datas = "solixhub/Datas",
	Images = "solixhub/Images",
	Themes = "solixhub/Themes"
}

for _, Folder in Folder_Configs do
	if not isfolder(Folder) then
		makefolder(Folder)
	end
end

local GameId = tostring(game.GameId)
local GameConfigFolder = Folder_Configs.Configs .. "/" .. GameId

if not isfolder(GameConfigFolder) then
	makefolder(GameConfigFolder)
end

local GameList = {
	["994732206"] = { id = "ce2e40f0bc2b1720", keyless = false }, -- Blox Fruits 
	["648454481"] = { id = "a873ec9f40a25c5c", keyless = false }, -- Grand Piece Online 
	["66654135"] = { id = "e45bba6c0dc08fad", keyless = false }, -- Murder Mystery 2
    ["7219654364"] = { id = "40ae7ebdcf5a8d40", keyless = false }, -- Sheriff VS Murderer 
	["5595353122"] = { id = "d7305ba1bbb3bd7b", keyless = false }, -- Slayers 2 
	["1511883870"] = { id = "5ac16739ff2ef735", keyless = false }, -- Shindo Life
	["10563114921"] = { id = "d3b0a2eaf4a1522a", keyless = false }, -- Steal An Egg
    ["6035872082"] = { id = "9d318b57c43ebd9d", keyless = false }, -- Rivals
   	["10035204815"] = { id = "85a577643f806078", keyless = false } -- Ride A Pet
}

local SdkUrl = "https://api.polsec.net/sdk"
local LoaderBase = "https://api.polsec.net/loader"

local Config = {
	ProjectId = "7d45ec1510769529",
	File = "solixhub/polsec/license.key.json",
	KeyLink = "https://solixhub.com/free/get-key/",
	Discord = "https://discord.gg/solixhub",
	Shop = "https://solixhub.com/free",
}

local ErrorMessages = {
	key_expired = "Your key is expired!",
	key_blacklisted = "This key is banned. Join Discord for help.",
	key_banned = "This key is banned. Join Discord for help.",
	invalid_fingerprint = "HWID not valid! Reset HWID on the panel.",
	key_hwid_locked = "HWID not valid! Reset HWID on the panel.",
	hwid_mismatch = "HWID not valid! Reset HWID on the panel.",
	invalid_key = "Wrong key. Check it and try again.",
	key_incorrect = "Wrong key. Check it and try again.",
	key_invalid = "That doesnt look like a key.",
	invalid_script_id = "Script not found.",
	script_id_incorrect = "Script not found.",
	script_id_invalid = "Script deleted.",
	invalid_executor = "Your executor isnt supported.",
	security_error = "Something went wrong. Try again.",
	time_error = "Fix your PC clock and try again.",
	key_disabled = "This key is disabled. Join Discord for help.",
	rate_limited = "Too many tries. Wait a bit and try again.",
	error = "Something broke. Join Discord for help.",
	unknown_error = "Something broke. Join Discord for help.",
	enter_a_key = "Enter a key",
	network_error = "Could not reach license server. Try again.",
}

if type(isfolder) == "function" and type(makefolder) == "function" then
	if not isfolder("solixhub/polsec") then
		pcall(makefolder, "solixhub/polsec")
	end
end

local GameConfig = GameList[GameId]

if not GameConfig then
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Hub",
		Text = "This game is not supported.",
		Icon = "rbxassetid://103638617992222",
	})
	return
end

local ScriptId = GameConfig.id
local IsKeyless = GameConfig.keyless

local ProjectId = type(Config.ProjectId) == "string" and Config.ProjectId or ""
if type(getgenv().PolSec_ProjectId) == "string" and getgenv().PolSec_ProjectId ~= "" then
	ProjectId = getgenv().PolSec_ProjectId
end

if ProjectId == "" then
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Hub",
		Text = "Set Config.ProjectId to your PolSec project ID.",
		Icon = "rbxassetid://103638617992222",
	})
	return
end

LowUnc = not (hookfunction and hookmetamethod)

local function DeleteFile(Input)
	if isfile(Input) then
		delfile(Input)
	end
end

local PolSec = loadstring(game:HttpGet(SdkUrl))()
PolSec.script_id = ScriptId

local LoaderUrl = LoaderBase .. "/" .. ProjectId .. "/" .. ScriptId

local function ReadJson(Path)
	if not isfile or not readfile or not isfile(Path) then
		return nil
	end
	local Ok, Raw = pcall(readfile, Path)
	if not Ok or type(Raw) ~= "string" or Raw == "" then
		return nil
	end
	local Decoded, Data = pcall(HttpService.JSONDecode, HttpService, Raw)
	if not Decoded or type(Data) ~= "table" then
		return nil
	end
	return Data
end

local function LoadSavedKey()
	local LegacyPaths = {
		"solixhub/savedkey.txt",
		"solixhub/license_key.json",
		"solixhub.com/polsec/license.key.json",
	}
	for Index = 1, #LegacyPaths do
		local LegacyPath = LegacyPaths[Index]
		if isfile and isfile(LegacyPath) and readfile then
			local Ok, Raw = pcall(readfile, LegacyPath)
			if Ok and type(Raw) == "string" and Raw:gsub("%s", "") ~= "" then
				local Key
				if Index ~= 1 then
					local Decoded, Data = pcall(HttpService.JSONDecode, HttpService, Raw)
					Key = Decoded and type(Data) == "table" and Data.key or nil
				else
					Key = Raw:gsub("^%s+", ""):gsub("%s+$", "")
				end
				if type(Key) == "string" and Key ~= "" then
					pcall(writefile, Config.File, HttpService:JSONEncode({
						key = Key,
						saved_at = os.time(),
					}))
					pcall(delfile, LegacyPath)
					return Key
				end
			end
		end
	end
	local Data = ReadJson(Config.File)
	if not Data or type(Data.key) ~= "string" or Data.key == "" then
		return nil
	end
	local Expires = tonumber(Data.expires_at)
	if Expires and Expires > 0 and Expires < os.time() then
		DeleteFile(Config.File)
		return nil
	end
	return Data.key
end

local function SaveKey(Key, Data)
	if not writefile then
		return
	end
	if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("solixhub/polsec") then
		pcall(makefolder, "solixhub/polsec")
	end
	pcall(writefile, Config.File, HttpService:JSONEncode({
		key = Key,
		note = Data and Data.note or nil,
		discord_id = Data and Data.discord_id or nil,
		expires_at = Data and Data.expires_at or nil,
		saved_at = os.time(),
	}))
end

local function ApplyKey(Key, Data)
	script_key = Key
	getgenv().script_key = Key
	getgenv().key = Key
	getgenv().PolSec_Note = Data and Data.note or nil
	getgenv().PolSec_Key_Note = Data and Data.note or nil
	getgenv().PolSec_Expiry = Data and Data.expires_at or nil
	getgenv().PolSec_UserId = Data and Data.discord_id or nil
	getgenv().PolSec_Discord_Id = Data and Data.discord_id and tostring(Data.discord_id) or nil
	getgenv().polsec_script_id = ScriptId
	getgenv().key_expire = Data and Data.expires_at or 0
	getgenv().key_note = Data and Data.note or ""
	SaveKey(Key, Data)
end

local function LoadGame()
	loadstring(game:HttpGet(LoaderUrl))()
end

local function PolSecErrorMessage(Status, Message, User)
	local Code = type(Status) == "string" and string.lower(Status) or "unknown_error"
	if ErrorMessages[Code] then
		return ErrorMessages[Code]
	end
	if type(Message) == "string" and Message ~= "" then
		local Lower = string.lower(Message)
		if ErrorMessages[Lower] then
			return ErrorMessages[Lower]
		end
	end
	if type(User) == "table" and type(User.blacklist_reason) == "string" and User.blacklist_reason ~= "" then
		return User.blacklist_reason
	end
	return ErrorMessages.unknown_error
end

local function CheckKey(Key)
	Key = type(Key) == "string" and Key:gsub("^%s+", ""):gsub("%s+$", "") or ""
	if Key == "" then
		return false, ErrorMessages.enter_a_key
	end
	local Ok, Result = pcall(PolSec.check_key, Key)
	if not Ok or type(Result) ~= "table" then
		return false, ErrorMessages.network_error
	end
	if Result.status ~= "key_valid" then
		local User = type(Result.user) == "table" and Result.user or nil
		return false, PolSecErrorMessage(Result.status, Result.message, User)
	end
	local User = type(Result.user) == "table" and Result.user or {}
	return true, {
		note = User.note,
		expires_at = User.key_expires,
		discord_id = User.discord_id or User.discordId,
		ad_key = User.ad_key == true,
	}, Key
end

local AttributionUrl = "https://solixhub.com/api/free-key/first-game"

local function ReportFirstGame(Key)
	pcall(function()
		local Body = HttpService:JSONEncode({
			key = Key,
			gameId = tostring(game.GameId),
			placeId = tostring(game.PlaceId),
			scriptId = ScriptId,
		})
		if typeof(request) == "function" then
			request({
				Url = AttributionUrl,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = Body,
			})
		elseif typeof(http_request) == "function" then
			http_request({
				Url = AttributionUrl,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = Body,
			})
		elseif typeof(syn) == "table" and typeof(syn.request) == "function" then
			syn.request({
				Url = AttributionUrl,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = Body,
			})
		end
	end)
end

if IsKeyless then
	script_key = "trail"
	getgenv().script_key = "trail"
	getgenv().polsec_script_id = ScriptId
	LoadGame()
	return
end

local function TrySilent(Key)
	ReportFirstGame(Key)
	local Ok, Data, Normalized = CheckKey(Key)
	if not Ok then
		return false
	end
	ApplyKey(Normalized, Data)
	LoadGame()
	return true
end

local SavedInitial = LoadSavedKey()
local Initial = getgenv().script_key
if type(Initial) ~= "string" or Initial == "" then
	Initial = script_key
end
if type(Initial) ~= "string" or Initial == "" then
	Initial = SavedInitial
end

if type(Initial) == "string" and Initial ~= "" then
	if TrySilent(Initial) then
		return
	end
	if SavedInitial and Initial == SavedInitial then
		DeleteFile(Config.File)
	end
end

do
	local wait = task.wait
	local spawn = task.spawn
	local delay = task.delay

	local FromRGB = Color3.fromRGB
	local UDim2New = UDim2.new
	local UDimNew = UDim.new
	local Vector2New = Vector2.new
	local MathClamp = math.clamp
	local MathFloor = math.floor
	local MathMax = math.max
	local MathMin = math.min
	local TableInsert = table.insert
	local StringFormat = string.format
	local InstanceNew = Instance.new

	local Theme = {
		Background = FromRGB(14, 13, 18),
		Inline = FromRGB(22, 21, 28),
		Border = FromRGB(42, 40, 52),
		Outline = FromRGB(36, 38, 45),
		Shadow = FromRGB(8, 6, 12),
		Text = FromRGB(242, 240, 248),
		Inactive = FromRGB(148, 144, 162),
		Accent = FromRGB(215, 40, 114),
		Element = FromRGB(32, 30, 40),
		Gradient = FromRGB(255, 140, 185),
	}

	local FontFace do
		local ok, face = pcall(function()
			return Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		end)
		FontFace = (ok and face) or Font.fromEnum(Enum.Font.GothamBold)
	end

	local GetUI = gethui or function()
		local ok, result = pcall(function()
			return game:GetService("CoreGui")
		end)
		return ok and result or nil
	end

	local function SafeGetUI()
		local ok, result = pcall(GetUI)
		if ok and result then
			return result
		end
		return game:GetService("CoreGui")
	end

	local function Create(class, props)
		local inst = InstanceNew(class)
		for k, v in props do
			if k ~= "Parent" then
				pcall(function()
					inst[k] = v
				end)
			end
		end
		if props.Parent then
			inst.Parent = props.Parent
		end
		return inst
	end

	local function Corner(parent, radius)
		return Create("UICorner", {
			Parent = parent,
			CornerRadius = UDimNew(0, radius or 5),
		})
	end

	local function Stroke(parent, color, transparency)
		return Create("UIStroke", {
			Parent = parent,
			Color = color or Theme.Border,
			Thickness = 1,
			Transparency = transparency or 0,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
	end

	local function Tween(inst, info, goal)
		local tw = TweenService:Create(inst, info or TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
		tw:Play()
		return tw
	end

	local function ToTime(a)
		if not a or a <= 0 then
			return "Lifetime"
		end

		local left = a - os.time()
		if left < 0 then
			return "Expired"
		end

		local days = MathFloor(left / 86400)
		local hours = MathFloor((left % 86400) / 3600)
		local minutes = MathFloor((left % 3600) / 60)
		local seconds = left % 60

		if days > 0 then
			return StringFormat("%dd %dh %dm", days, hours, minutes)
		elseif hours > 0 then
			return StringFormat("%dh %dm %ds", hours, minutes, seconds)
		elseif minutes > 0 then
			return StringFormat("%dm %ds", minutes, seconds)
		end
		return StringFormat("%ds", seconds)
	end

	local Holder = Create("ScreenGui", {
		Parent = SafeGetUI(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 2,
		ResetOnSpawn = false,
	})

	local NotifHolder = Create("Frame", {
		Parent = Holder,
		Name = "\0",
		Size = UDim2New(0, 0, 1, 0),
		Position = UDim2New(1, 0, 0, 0),
		AnchorPoint = Vector2New(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
	})

	Create("UIListLayout", {
		Parent = NotifHolder,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDimNew(0, 12),
	})

	Create("UIPadding", {
		Parent = NotifHolder,
		PaddingLeft = UDimNew(0, 12),
		PaddingRight = UDimNew(0, 12),
		PaddingTop = UDimNew(0, 12),
		PaddingBottom = UDimNew(0, 12),
	})

	local NotifLayoutOrder = 0

	local function Notify(data)
		wait()
		NotifLayoutOrder += 1

		local title = data.Title or "Solix Hub"
		local desc = data.Description or ""
		local duration = data.Duration or 5
		local accent = data.Color or Theme.Accent

		local pad_h, pad_v, gap, bar_gap, bar_h = 10, 8, 4, 6, 3
		local accent_w, accent_gap = 3, 8
		local max_w, min_w = 300, 160
		local title_size, desc_size = 14, 12

		local function text_size(text, font_size, width)
			return TextService:GetTextSize(text, font_size, Enum.Font.Gotham, Vector2New(width > 0 and width or 10000, 10000))
		end

		local text_w = max_w - pad_h * 2 - accent_w - accent_gap
		local title_sz = text_size(title, title_size, text_w)
		local desc_sz = desc ~= "" and text_size(desc, desc_size, text_w) or Vector2New(0, 0)
		local title_h = MathMax(MathFloor(title_sz.Y + 0.5), title_size + 2)
		local desc_h = desc ~= "" and MathMax(MathFloor(desc_sz.Y + 0.5), desc_size + 2) or 0
		local has_desc = desc_h > 0

		local content_w = MathMin(
			MathMax(MathFloor(title_sz.X + 0.5), MathFloor(desc_sz.X + 0.5), min_w - pad_h * 2 - accent_w - accent_gap)
				+ pad_h * 2 + accent_w + accent_gap,
			max_w
		)
		local body_h = title_h + (has_desc and (gap + desc_h) or 0)
		local size_y = pad_v * 2 + body_h + bar_gap + bar_h

		local fade_info = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
		local bar_info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

		local notif = Create("Frame", {
			Parent = NotifHolder,
			BackgroundColor3 = Theme.Inline,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = NotifLayoutOrder,
			Size = UDim2New(0, 0, 0, size_y),
			ZIndex = 50,
		})
		Corner(notif, 5)
		local notif_stroke = Stroke(notif, Theme.Border, 0.45)
		notif_stroke.Transparency = 1

		Create("UIPadding", {
			Parent = notif,
			PaddingLeft = UDimNew(0, pad_h),
			PaddingRight = UDimNew(0, pad_h),
			PaddingTop = UDimNew(0, pad_v),
			PaddingBottom = UDimNew(0, pad_v),
		})

		Create("UIListLayout", {
			Parent = notif,
			Padding = UDimNew(0, bar_gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
		})

		local body = Create("Frame", {
			Parent = notif,
			Size = UDim2New(1, 0, 0, body_h),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			ZIndex = 51,
		})

		Create("UIListLayout", {
			Parent = body,
			Padding = UDimNew(0, accent_gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
		})

		local accent_bar = Create("Frame", {
			Parent = body,
			Size = UDim2New(0, accent_w, 1, 0),
			BackgroundColor3 = accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			ZIndex = 51,
		})
		Corner(accent_bar, 2)

		local content = Create("Frame", {
			Parent = body,
			Size = UDim2New(1, -(accent_w + accent_gap), 0, body_h),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			ZIndex = 51,
		})

		Create("UIListLayout", {
			Parent = content,
			Padding = UDimNew(0, gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
		})

		local title_lbl = Create("TextLabel", {
			Parent = content,
			Size = UDim2New(1, 0, 0, title_h),
			BackgroundTransparency = 1,
			Text = title,
			TextColor3 = Theme.Text,
			TextSize = title_size,
			FontFace = FontFace,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			TextTransparency = 1,
			LayoutOrder = 1,
			ZIndex = 51,
		})

		local desc_lbl
		if has_desc then
			desc_lbl = Create("TextLabel", {
				Parent = content,
				Size = UDim2New(1, 0, 0, desc_h),
				BackgroundTransparency = 1,
				Text = desc,
				TextColor3 = Theme.Inactive,
				TextSize = desc_size,
				FontFace = FontFace,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				TextTransparency = 1,
				LayoutOrder = 2,
				ZIndex = 51,
			})
		end

		local duration_bg = Create("Frame", {
			Parent = notif,
			Size = UDim2New(1, 0, 0, bar_h),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = 2,
			ZIndex = 51,
		})
		Corner(duration_bg, 2)

		local progress = Create("Frame", {
			Parent = duration_bg,
			Size = UDim2New(1, 0, 1, 0),
			BackgroundColor3 = accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 52,
		})

		spawn(function()
			Tween(notif, fade_info, { BackgroundTransparency = 0, Size = UDim2New(0, content_w, 0, size_y) })
			Tween(notif_stroke, fade_info, { Transparency = 0.45 })
			Tween(accent_bar, fade_info, { BackgroundTransparency = 0 })
			Tween(title_lbl, fade_info, { TextTransparency = 0 })
			if desc_lbl then
				Tween(desc_lbl, fade_info, { TextTransparency = 0 })
			end
			Tween(duration_bg, fade_info, { BackgroundTransparency = 0 })
			Tween(progress, fade_info, { BackgroundTransparency = 0 })
			Tween(progress, bar_info, { Size = UDim2New(0, 0, 1, 0) })

			delay(duration + 0.1, function()
				Tween(notif, fade_info, { BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, size_y) })
				Tween(notif_stroke, fade_info, { Transparency = 1 })
				Tween(accent_bar, fade_info, { BackgroundTransparency = 1 })
				Tween(title_lbl, fade_info, { TextTransparency = 1 })
				if desc_lbl then
					Tween(desc_lbl, fade_info, { TextTransparency = 1 })
				end
				Tween(duration_bg, fade_info, { BackgroundTransparency = 1 })
				Tween(progress, fade_info, { BackgroundTransparency = 1 })
				wait(0.4)
				notif:Destroy()
			end)
		end)
	end

	local panel_w = IsMobile and 360 or 360
	local pad = IsMobile and 14 or 12
	local logo_s = IsMobile and 38 or 34
	local btn_h = IsMobile and 46 or 36
	local btn_gap = 8
	local field_h = IsMobile and 42 or 36
	local content_w = panel_w - pad * 2
	local half_w = MathFloor((content_w - btn_gap) / 2)

	local LogoUrl = "https://solixhub.com/solix-logo.png"
	local LogoFallback = "rbxassetid://137698471325689"

	local function GetLogoAsset()
		if type(getcustomasset) ~= "function" or type(writefile) ~= "function" then
			return LogoFallback
		end
		local images_dir = Folder_Configs.Images
		if type(isfolder) == "function" and not isfolder(images_dir) and type(makefolder) == "function" then
			pcall(makefolder, images_dir)
		end
		local file_path = images_dir .. "/solix-logo.png"
		if type(isfile) ~= "function" or not isfile(file_path) then
			local ok, content = pcall(function()
				return game:HttpGet(LogoUrl)
			end)
			if not ok or type(content) ~= "string" or content == "" then
				return LogoFallback
			end
			if not pcall(writefile, file_path, content) then
				return LogoFallback
			end
		end
		local ok, asset_id = pcall(getcustomasset, file_path)
		if ok and type(asset_id) == "string" and asset_id ~= "" then
			return asset_id
		end
		return LogoFallback
	end

	local ScreenGui = Create("ScreenGui", {
		Parent = SafeGetUI(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 999,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
	})

	local UIScale = Create("UIScale", {
		Parent = ScreenGui,
		Scale = 1,
	})

	local Main = Create("Frame", {
		Parent = ScreenGui,
		Size = UDim2New(0, 0, 0, 0),
		Position = UDim2New(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2New(0.5, 0.5),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 2,
		ClipsDescendants = true,
	})
	Corner(Main, 5)
	local MainStroke = Stroke(Main, Theme.Border, 1)

	Create("ImageLabel", {
		Parent = Main,
		Size = UDim2New(1, 55, 1, 55),
		Position = UDim2New(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2New(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://112971167999062",
		ImageColor3 = Theme.Shadow,
		ImageTransparency = 0.56,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(Vector2New(112, 112), Vector2New(147, 147)),
		SliceScale = 0.6,
		ZIndex = 1,
	})

	local fade_items = {}

	local function track(inst, kind)
		TableInsert(fade_items, { Inst = inst, Kind = kind or "bg" })
		return inst
	end

	local header_h = logo_s + 18
	local DragArea = Create("Frame", {
		Parent = Main,
		Size = UDim2New(1, -40, 0, header_h + 8),
		BackgroundTransparency = 1,
		ZIndex = 3,
	})

	local CloseBtn = Create("ImageButton", {
		Parent = Main,
		Size = UDim2New(0, IsMobile and 26 or 22, 0, IsMobile and 26 or 22),
		Position = UDim2New(1, -pad, 0, pad),
		AnchorPoint = Vector2New(1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://76001605964586",
		ImageTransparency = 1,
		ImageColor3 = Theme.Inactive,
		ScaleType = Enum.ScaleType.Fit,
		AutoButtonColor = false,
		ZIndex = 6,
	})

	local Logo = Create("ImageLabel", {
		Parent = Main,
		Size = UDim2New(0, logo_s, 0, logo_s),
		Position = UDim2New(0, pad, 0, pad),
		BackgroundTransparency = 1,
		Image = LogoFallback,
		ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 4,
	})
	track(Logo, "image")

	spawn(function()
		local asset = GetLogoAsset()
		Logo.Image = asset
		if asset ~= LogoFallback then
			Logo.ImageColor3 = FromRGB(255, 255, 255)
		end
	end)

	local title_size = IsMobile and 18 or 16
	local BrandRow = Create("Frame", {
		Parent = Main,
		Size = UDim2New(0, 0, 0, logo_s),
		Position = UDim2New(0, pad + logo_s + 8, 0, pad),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ZIndex = 4,
	})

	Create("UIListLayout", {
		Parent = BrandRow,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDimNew(0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local function BrandPart(text, color, order)
		local lbl = Create("TextLabel", {
			Parent = BrandRow,
			Size = UDim2New(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = color,
			TextSize = title_size,
			FontFace = FontFace,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTransparency = 1,
			LayoutOrder = order,
			ZIndex = 4,
		})
		track(lbl, "text")
		return lbl
	end

	BrandPart("solix", Theme.Text, 1)
	BrandPart("hub", Theme.Accent, 2)
	BrandPart(".com", Theme.Text, 3)

	local Description = Create("TextLabel", {
		Parent = Main,
		Size = UDim2New(1, -(pad * 2), 0, 16),
		Position = UDim2New(0, pad, 0, pad + logo_s + 6),
		BackgroundTransparency = 1,
		Text = "Paste your key to continue",
		TextColor3 = Theme.Inactive,
		TextSize = IsMobile and 13 or 12,
		FontFace = FontFace,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 1,
		ZIndex = 4,
	})
	track(Description, "muted")

	local AccentLine = Create("Frame", {
		Parent = Main,
		Size = UDim2New(1, 4, 0, 1),
		Position = UDim2New(0, -2, 0, pad + logo_s + 28),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	track(AccentLine, "accent")

	local field_y = pad + logo_s + 40

	local KeyBox = Create("Frame", {
		Parent = Main,
		Size = UDim2New(0, content_w, 0, field_h),
		Position = UDim2New(0, pad, 0, field_y),
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	Corner(KeyBox, 5)
	local KeyStroke = Stroke(KeyBox, Theme.Border, 1)
	track(KeyBox, "bg")
	track(KeyStroke, "stroke")

	local KeyInput = Create("TextBox", {
		Parent = KeyBox,
		Size = UDim2New(1, -20, 1, 0),
		Position = UDim2New(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.Text,
		TextSize = IsMobile and 15 or 13,
		FontFace = FontFace,
		PlaceholderText = "Enter your key",
		PlaceholderColor3 = Theme.Inactive,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 1,
		ClearTextOnFocus = false,
		ZIndex = 4,
	})
	track(KeyInput, "text")

	local btn_y = field_y + field_h + 10
	local btn_text = IsMobile and 14 or 13
	local row2_y = btn_y + btn_h + btn_gap

	local function MakeSideBtn(text, x, y, w)
		local btn = Create("TextButton", {
			Parent = Main,
			Size = UDim2New(0, w, 0, btn_h),
			Position = UDim2New(0, x, 0, y),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = btn_text,
			FontFace = FontFace,
			AutoButtonColor = false,
			TextTransparency = 1,
			ZIndex = 4,
		})
		Corner(btn, 5)
		local stroke = Stroke(btn, Theme.Border, 1)
		track(btn, "btn")
		track(stroke, "stroke")
		btn.MouseEnter:Connect(function()
			Tween(btn, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Inline })
		end)
		btn.MouseLeave:Connect(function()
			Tween(btn, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Element })
		end)
		return btn
	end

	local ContinueBtn = Create("TextButton", {
		Parent = Main,
		Size = UDim2New(0, half_w, 0, btn_h),
		Position = UDim2New(0, pad, 0, btn_y),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "Continue",
		TextColor3 = FromRGB(255, 255, 255),
		TextSize = btn_text,
		FontFace = FontFace,
		AutoButtonColor = false,
		TextTransparency = 1,
		ZIndex = 4,
	})
	Corner(ContinueBtn, 5)
	Create("UIGradient", {
		Parent = ContinueBtn,
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Theme.Gradient),
		}),
	})
	track(ContinueBtn, "cta")

	local GetKeyBtn = MakeSideBtn("Get Key", pad + half_w + btn_gap, btn_y, half_w)
	local DiscordBtn = MakeSideBtn("Join Discord", pad, row2_y, half_w)
	local SkipBtn = MakeSideBtn("Skip Keysystem", pad + half_w + btn_gap, row2_y, half_w)

	local panel_h = row2_y + btn_h + pad

	do
		local dragging, drag_start, start_pos, changed

		DragArea.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			dragging = true
			drag_start = input.Position
			start_pos = Main.Position
			if changed then
				return
			end
			changed = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if changed then
						changed:Disconnect()
						changed = nil
					end
				end
			end)
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not dragging then
				return
			end
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local scale = UIScale.Scale or 1
			local delta = (input.Position - drag_start) / scale
			Tween(Main, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(
					start_pos.X.Scale,
					start_pos.X.Offset + delta.X,
					start_pos.Y.Scale,
					start_pos.Y.Offset + delta.Y
				),
			})
		end)
	end

	local tween_data = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fade_in = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local validating = false
	local closed = false

	local function set_fade(transparency)
		local info = transparency == 0 and fade_in or tween_data
		for _, item in fade_items do
			local inst = item.Inst
			local kind = item.Kind
			if kind == "text" then
				Tween(inst, info, { TextTransparency = transparency })
			elseif kind == "muted" then
				Tween(inst, info, { TextTransparency = transparency == 0 and 0.1 or 1 })
			elseif kind == "stroke" then
				Tween(inst, info, { Transparency = transparency == 0 and 0.35 or 1 })
			elseif kind == "cta" or kind == "btn" then
				Tween(inst, info, { BackgroundTransparency = transparency, TextTransparency = transparency })
			elseif kind == "accent" then
				Tween(inst, info, { BackgroundTransparency = transparency })
			elseif kind == "image" then
				Tween(inst, info, { ImageTransparency = transparency })
			else
				Tween(inst, info, { BackgroundTransparency = transparency })
			end
		end
	end

	local function CloseUI()
		if closed then
			return
		end
		closed = true
		Tween(MainStroke, tween_data, { Transparency = 1 })
		Tween(CloseBtn, tween_data, { ImageTransparency = 1 })
		set_fade(1)
		Tween(Main, tween_data, { Size = UDim2New(0, 0, 0, 0) })
		wait(0.28)
		ScreenGui:Destroy()
	end

	local function CopyLink(url, copied_msg)
		if setclipboard then
			pcall(setclipboard, url)
			Notify({
				Title = "Solix Hub",
				Description = copied_msg,
				Duration = 4,
			})
			return
		end
		Notify({
			Title = "Solix Hub",
			Description = "Couldnt copy. Open this link: " .. url,
			Duration = 6,
		})
	end

	local function set_continue(text, active)
		if closed then
			return
		end
		pcall(function()
			ContinueBtn.Text = text
			ContinueBtn.Active = active
		end)
	end

	local function ValidateKey(key, opts)
		opts = opts or {}
		if validating or closed then
			return false
		end

		local from_saved = opts.from_saved == true

		validating = true
		set_continue("Checking...", false)
		ReportFirstGame(key)
		local ok, data_or_err, normalized = CheckKey(key)

		if closed then
			validating = false
			return false, "closed"
		end

		if not ok then
			validating = false
			set_continue("Continue", true)
			if from_saved then
				DeleteFile(Config.File)
			end
			Notify({
				Title = "Solix Hub",
				Description = tostring(data_or_err),
				Duration = 5,
			})
			return false, "invalid"
		end

		ApplyKey(normalized, data_or_err)

		set_continue("Loading...", false)
		Notify({
			Title = "Solix Hub",
			Description = "Key works. Time left: " .. ToTime(data_or_err.expires_at),
			Duration = 4,
		})

		CloseUI()
		wait(0.03)
		LoadGame()
		validating = false
		return true
	end

	local function try_submit()
		if KeyInput.Text == "" then
			Notify({
				Title = "Solix Hub",
				Description = "Paste a key first.",
				Duration = 3,
			})
			return
		end
		local ok, reason = ValidateKey(KeyInput.Text)
		if not ok and (reason == "format" or reason == "invalid") then
			KeyInput.Text = ""
		end
	end

	ContinueBtn.MouseEnter:Connect(function()
		if validating then
			return
		end
		Tween(ContinueBtn, TweenInfo.new(0.12), { BackgroundColor3 = FromRGB(235, 70, 140) })
	end)
	ContinueBtn.MouseLeave:Connect(function()
		Tween(ContinueBtn, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Accent })
	end)

	KeyInput.Focused:Connect(function()
		Tween(KeyStroke, TweenInfo.new(0.12), { Color = Theme.Accent, Transparency = 0.1 })
	end)
	KeyInput.FocusLost:Connect(function(enter)
		Tween(KeyStroke, TweenInfo.new(0.12), { Color = Theme.Border, Transparency = 0.25 })
		if enter then
			try_submit()
		end
	end)


	ContinueBtn.MouseButton1Click:Connect(try_submit)

	GetKeyBtn.MouseButton1Click:Connect(function()
		CopyLink(Config.KeyLink, "Key link copied. Paste it in your browser.")
	end)

	DiscordBtn.MouseButton1Click:Connect(function()
		spawn(function()
			local opened = false
			if typeof(request) == "function" then
				local success, response = pcall(function()
					return request({
						Url = "http://127.0.0.1:6463/rpc?v=1",
						Method = "POST",
						Headers = {
							["Content-Type"] = "application/json",
							["Origin"] = "https://discord.com",
						},
						Body = HttpService:JSONEncode({
							cmd = "INVITE_BROWSER",
							args = { code = "solixhub" },
							nonce = HttpService:GenerateGUID(false),
						}),
					})
				end)
				opened = success and response and response.StatusCode == 200
			end
			if not opened and setclipboard then
				pcall(setclipboard, Config.Discord)
			end
			Notify({
				Title = "Solix Hub",
				Description = opened and "Opening Discord invite." or "Discord invite copied.",
				Duration = 4,
			})
		end)
	end)

	SkipBtn.MouseButton1Click:Connect(function()
		CopyLink(Config.Shop, "Buy link copied. Open it to skip ads and get a key.")
	end)

	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, TweenInfo.new(0.12), { ImageColor3 = Theme.Text })
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, TweenInfo.new(0.12), { ImageColor3 = Theme.Inactive })
	end)
	CloseBtn.MouseButton1Click:Connect(CloseUI)

	if IsMobile then
		local cam = Workspace.CurrentCamera
		local viewport = (cam and cam.ViewportSize) or Vector2New(1920, 1080)
		UIScale.Scale = MathClamp(viewport.Y / 720, 0.7, 1.2)
	end

	Tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2New(0, panel_w, 0, panel_h),
	})

	wait(0.18)

	Tween(MainStroke, fade_in, { Transparency = 0.2 })
	Tween(CloseBtn, fade_in, { ImageTransparency = 0 })
	set_fade(0)

	spawn(function()
		wait(0.35)
		if closed or validating then
			return
		end
		if type(Initial) == "string" and Initial ~= "" then
			KeyInput.Text = Initial
		end
	end)
end
