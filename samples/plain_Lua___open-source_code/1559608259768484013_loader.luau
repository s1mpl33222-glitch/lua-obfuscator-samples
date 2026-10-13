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
	Directory = "sportsclub",
	Images = "sportsclub/Images",
}

if type(isfolder) == "function" and type(makefolder) == "function" then
	if not isfolder(Folder_Configs.Directory) then
		makefolder(Folder_Configs.Directory)
	end
	if not isfolder(Folder_Configs.Images) then
		makefolder(Folder_Configs.Images)
	end
end

local ProjectId = "22cad4542e792a9c"
local SdkUrl = "https://api.polsec.net/sdk"
local LoaderBase = "https://api.polsec.net/loader"

local function StealAnEggBypass()
	if getgenv().sportsclub_steal_an_egg_ac_bypassed then
		return
	end
	if type(filtergc) ~= "function" or type(debug) ~= "table" or type(debug.getupvalues) ~= "function" or type(setrawmetatable) ~= "function" then
		return
	end
	local Tamper = filtergc("function", { Constants = { "gmatch", "GetFullName" } }, true)
	if Tamper then
		local Upvalues = debug.getupvalues(Tamper)
		for Index = 1, #Upvalues do
			if type(Upvalues[Index]) == "table" then
				setrawmetatable(Upvalues[Index], { __newindex = function() end })
			end
		end
	end
	getgenv().sportsclub_steal_an_egg_ac_bypassed = true
end

local Config = {
	File = "sportsclub/license_key.json",
	Settings = "sportsclub/loader_settings.json",
	KeyLink = "https://getsportsclub.com/adsystem",
	Shop = "https://sportsclub.fun/#store",
	Discord = "https://discord.gg/gUbZegrB6g",
	AnalyticsProject = "proj_sportsclub",
	AnalyticsVersion = "1.0.2",
	AnalyticsClient = "https://loader.sportsclub.fun/clientv1.lua",
	Sniper = 7264587281,
	Bypasses = {
		[7264587281] = "https://loader.sportsclub.fun/sniperduels_bypass.luau",
		[9908641400] = "https://pastebin.com/raw/UwQPRTXQ",
		[6726637224] = "https://pastebin.com/raw/nDTMkYuc",
		[10563114921] = StealAnEggBypass,
	},
}

local function StartRunAnalytics()
	local ProjectId = Config.AnalyticsProject
	local Recording = rawget(getgenv(), "_scRunsRecording")
	if type(Recording) ~= "table" then
		Recording = {}
		getgenv()._scRunsRecording = Recording
	end
	if Recording[ProjectId] then
		return
	end
	Recording[ProjectId] = true
	task.spawn(function()
		pcall(function()
			getgenv()._scRunsConfig = {
				project = Config.AnalyticsProject,
				version = Config.AnalyticsVersion,
			}
			local Src = game:HttpGet(Config.AnalyticsClient)
			if type(Src) ~= "string" or #Src < 32 then
				return
			end
			local Fn = loadstring(Src)
			if type(Fn) == "function" then
				Fn()
			end
		end)
	end)
end

local GameList = {
	[66654135] = "009ff4a78983f850",
	[73885730] = "c1383e4dbc04c894",
	[111958650] = "241356b729bc3c97",
	[113491250] = "c4d3ef0c29176832",
	[184199275] = "3b7bd9142a45d559",
	[372226183] = "6bf87ae2d1b86339",
	[383310974] = "c3114c8b9a6def3c",
	[1054526971] = "68a89638f9889f79",
	[2459091562] = "75fba2f42d4b54f3",
	[2765784373] = "1b340b6b8731af94",
	[3508322461] = "0beee9623f5ab493",
	[3734304510] = "773f91220f0d056e",
	[4293374620] = "0f10cc5ff028f81e",
	[4730278139] = "fa8f91a1fc10377a",
	[4750561026] = "dc950db6094e699b",
	[4777817887] = "8a66fc1161d29f0e",
	[4931927012] = "1231151b59c9dcf8",
	[4949420752] = "cc50c53a4adb4571",
	[4987856151] = "34f3553489891d5d",
	[5595353122] = "f941ecf9c2893c84",
	[5750914919] = "c7a474f479dc6208",
	[5995470825] = "c9da2143136ce8d5",
	[6035872082] = "c8a45ca0b25139a3",
	[6061766680] = "d52ba1c5c0dc5c11",
	[6216285188] = "e8147fe214540335",
	[6260656796] = "b0d2c57249d2ec06",
	[6331902150] = "ade0e0dfb65b8dab",
	[6505338302] = "f26436215d550df4",
	[6726637224] = "bf1f1aa1d5bec70f",
	[6739698191] = "30bd8f3b21d19783",
	[6765805766] = "ccdc75b37f2e8282",
	[6931042565] = "98c663b5cac918d2",
	[7094518649] = "ea549e345bb6bc5c",
	[7108384194] = "a25ea6b8888984e3",
	[7264587281] = "5f0b619a6d027235",
	[7585140258] = "db37f21dad9c7ac1",
	[7633926880] = "981acf63e98b3571",
	[7849427635] = "9025b3ed041b9d9c",
	[7883776681] = "ecfb28ceae344a4e",
	[7884563721] = "137bb216d0fdab55",
	[7996365376] = "7e52ef54881d0706",
	[8307114974] = "32a3f9f1781977ef",
	[8558141897] = "1051e085a0b50cca",
	[8795154789] = "931dcf7ba70b7dc5",
	[9112256336] = "34a15184cb6a7ee4",
	[9167377564] = "82f7f927a73f1de1",
	[9294074907] = "31655f9162e3aa8f",
	[9534705677] = "e2fabbf7654aed38",
	[9561553764] = "e823cdbf57675025",
	[9641502068] = "d65fbd7db286df7d",
	[9753494457] = "e3e9abb8f447d92d",
	[9893475671] = "8c562c93ddf3135d",
	[9908641400] = "e648818e624401de",
	[9925603818] = "2e79cb4841902c70",
	[9931749389] = "858f757ed4641d2b",
	[10031562156] = "e930337182b904f9",
	[10057403337] = "b92fa39292be5ddc",
	[10124403207] = "5acd8eb266a78674",
	[10144280947] = "31696135af052840",
	[10155360168] = "f135c2d3a0febabf",
	[10230942274] = "dc478626c0c0f9de",
	[10476380360] = "67b2e03a3469e076",
	[10539411000] = "308fe2805126001d",
	[10563114921] = "ebcff09f785a4a30",
	[10648640958] = "24b4a31160224f3c",
	[10737656087] = "335eac11248ccc9f",
	[10759337137] = "e5b0b60cae97900f",
	[10764627709] = "e4ebf4d7aeb01c1c",
	[10766364164] = "e7518b41b5326498",
	[10766921988] = "d8db551c2dfeea72",
	[10767012496] = "2ccff20e9a3d4b4e",
	[10768944292] = "faad167e37181281",
}

local ScriptId = GameList[game.GameId]

if type(ScriptId) ~= "string" or ScriptId == "" then
	StarterGui:SetCore("SendNotification", {
		Title = "sportsclub",
		Text = "This game is not supported.",
	})
	return
end

local AttributionUrl = "https://getsportsclub.com/api/free-key/first-game"

local function ReportFirstGame(Key)
	pcall(function()
		local Body = HttpService:JSONEncode({
			key = Key,
			gameId = tostring(game.GameId),
			placeId = tostring(game.PlaceId),
			scriptId = ScriptId,
		})
		local Req = {
			Url = AttributionUrl,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = Body,
		}
		if typeof(request) == "function" then
			request(Req)
		elseif typeof(http_request) == "function" then
			http_request(Req)
		elseif typeof(syn) == "table" and typeof(syn.request) == "function" then
			syn.request(Req)
		end
	end)
end

local Library = loadstring(game:HttpGet(SdkUrl))()
Library.script_id = ScriptId

local function Copy(Text)
	if setclipboard then
		setclipboard(Text)
	elseif toclipboard then
		toclipboard(Text)
	end
end

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
	local Data = ReadJson(Config.File)
	if not Data or type(Data.key) ~= "string" or Data.key == "" then
		return nil
	end
	local Expires = tonumber(Data.expires_at)
	if Expires and Expires > 0 and Expires < os.time() then
		if delfile then
			pcall(delfile, Config.File)
		end
		return nil
	end
	return Data.key
end

local function SaveKey(Key, Data)
	if not writefile then
		return
	end
	if makefolder and isfolder and not isfolder(Folder_Configs.Directory) then
		pcall(makefolder, Folder_Configs.Directory)
	end
	pcall(writefile, Config.File, HttpService:JSONEncode({
		key = Key,
		note = Data and Data.note or nil,
		discord_id = Data and Data.discord_id or nil,
		expires_at = Data and Data.expires_at or nil,
		saved_at = os.time(),
	}))
end

local function LoadSettings()
	local Data = ReadJson(Config.Settings)
	if not Data then
		return {
			discord_join_disabled = false,
			discord_prompt_answered = false,
		}
	end
	return {
		discord_join_disabled = Data.discord_join_disabled == true,
		discord_prompt_answered = Data.discord_prompt_answered == true,
	}
end

local function InstallDiscordGuard()
	if getgenv().sportsclub_discord_join_guard_installed == true then
		return
	end
	getgenv().sportsclub_discord_join_guard_installed = true
	getgenv().sportsclub_discord_join_disabled = true
	if type(hookfunction) ~= "function" then
		return
	end

	local function Hook(Target)
		if type(Target) ~= "function" then
			return
		end
		local Original
		local Ok, Result = pcall(hookfunction, Target, function(Opts)
			local Url = type(Opts) == "table" and (Opts.Url or Opts.url)
			local Body = type(Opts) == "table" and (Opts.Body or Opts.body)
			local Headers = type(Opts) == "table" and (Opts.Headers or Opts.headers)
			if type(Headers) == "table" and Headers["X-Sportsclub-Join"] == "1" then
				return Original(Opts)
			end
			if type(Url) == "string" and string.find(Url, "127.0.0.1:6463", 1, true) and type(Body) == "string" and string.find(Body, "INVITE_BROWSER", 1, true) then
				return { StatusCode = 200, Body = "{}" }
			end
			return Original(Opts)
		end)
		if Ok and type(Result) == "function" then
			Original = Result
		end
	end

	Hook(request)
	if type(syn) == "table" then
		Hook(syn.request)
	end
	Hook(http_request)
	if type(http) == "table" then
		Hook(http.request)
	end
end

local function TryDiscordAutoJoin()
	local Settings = LoadSettings()
	if Settings.discord_join_disabled then
		InstallDiscordGuard()
		return
	end
	local Invite = Config.Discord
	local Code = string.match(Invite, "discord%.gg/([%w%-]+)") or "gUbZegrB6g"
	task.spawn(function()
		local RequestFn = (typeof(request) == "function" and request)
			or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
			or (typeof(http_request) == "function" and http_request)
			or (type(http) == "table" and type(http.request) == "function" and http.request)
		if RequestFn then
			local Success, Response = pcall(function()
				return RequestFn({
					Url = "http://127.0.0.1:6463/rpc?v=1",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
					Body = HttpService:JSONEncode({
						cmd = "INVITE_BROWSER",
						args = { code = Code },
						nonce = HttpService:GenerateGUID(false),
					}),
				})
			end)
			if Success and Response and Response.StatusCode == 200 then
				return
			end
		end
		if setclipboard then
			pcall(setclipboard, Invite)
		elseif toclipboard then
			pcall(toclipboard, Invite)
		end
	end)
end

TryDiscordAutoJoin()

local function EnsureSniper()
	if game.GameId ~= Config.Sniper then
		return
	end
	local Link = Config.Bypasses[game.GameId]
	if type(Link) ~= "string" then
		return
	end
	local Existing = getgenv().sportsclub_sniper_duels_ac_bypass
	if getgenv().sportsclub_sniper_duels_ac_bypassed and type(Existing) == "table" and Existing.ready == true then
		return
	end
	pcall(function()
		loadstring(game:HttpGet(Link))()
	end)
	local Started = os.clock()
	while os.clock() - Started < 15 do
		local Api = getgenv().sportsclub_sniper_duels_ac_bypass
		if type(Api) == "table" and Api.ready == true then
			return
		end
		local Moderation = game:FindFirstChild("ModerationService")
		if Moderation and (Moderation:GetAttribute("SD_SOFT_READY") == true or Moderation:GetAttribute("SD_FULL_READY") == true) then
			return
		end
		task.wait(0.1)
	end
end

local function ApplyKey(Key, Data)
	script_key = Key
	getgenv().script_key = Key
	getgenv().PolSec_Note = Data and Data.note or nil
	getgenv().PolSec_Key_Note = Data and Data.note or nil
	getgenv().PolSec_Expiry = Data and Data.expires_at or nil
	getgenv().PolSec_UserId = Data and Data.discord_id or nil
	getgenv().PolSec_Discord_Id = Data and Data.discord_id and tostring(Data.discord_id) or nil
	getgenv().polsec_script_id = ScriptId
	local Note = Data and Data.note
	if type(Note) == "string" then
		local Clean = string.lower((Note:gsub("^%s+", ""):gsub("%s+$", "")))
		getgenv().sportsclub_premium = Clean ~= "" and Clean ~= "keysystem" and Clean ~= "trail"
	else
		getgenv().sportsclub_premium = false
	end
	SaveKey(Key, Data)
	StartRunAnalytics()
end

local function LoadGame()
	local Bypass = Config.Bypasses[game.GameId]
	if game.GameId ~= Config.Sniper then
		if type(Bypass) == "string" then
			loadstring(game:HttpGet(Bypass))()
		elseif type(Bypass) == "function" then
			Bypass()
		end
	end
	loadstring(game:HttpGet(LoaderBase .. "/" .. ProjectId .. "/" .. ScriptId))()
end

local function TimeLeft(Expires)
	Expires = tonumber(Expires)
	if not Expires or Expires <= 0 then
		return "Lifetime"
	end
	local Left = Expires - os.time()
	if Left < 0 then
		return "Expired"
	end
	local Days = math.floor(Left / 86400)
	local Hours = math.floor((Left % 86400) / 3600)
	local Minutes = math.floor((Left % 3600) / 60)
	local Seconds = math.floor(Left % 60)
	if Days > 0 then
		return string.format("%dd %dh %dm", Days, Hours, Minutes)
	elseif Hours > 0 then
		return string.format("%dh %dm %ds", Hours, Minutes, Seconds)
	elseif Minutes > 0 then
		return string.format("%dm %ds", Minutes, Seconds)
	end
	return string.format("%ds", Seconds)
end

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

local function NormalizeError(Value)
	if type(Value) ~= "string" then
		return ""
	end
	return string.lower((Value:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[%s%-]+", "_")))
end

local function ResolveError(...)
	local Count = select("#", ...)
	for Index = 1, Count do
		local Key = NormalizeError(select(Index, ...))
		if Key ~= "" and ErrorMessages[Key] then
			return ErrorMessages[Key]
		end
	end
	for Index = 1, Count do
		local Value = select(Index, ...)
		if type(Value) == "string" then
			local Trimmed = Value:gsub("^%s+", ""):gsub("%s+$", "")
			if Trimmed ~= "" and not string.find(Trimmed, "^[%w_]+$") then
				return Trimmed
			end
		end
	end
	return ErrorMessages.unknown_error
end

local function CheckKey(Key)
	Key = type(Key) == "string" and Key:gsub("^%s+", ""):gsub("%s+$", "") or ""
	if Key == "" then
		return false, ErrorMessages.enter_a_key
	end
	local Ok, Result = pcall(Library.check_key, Key)
	if not Ok then
		return false, ErrorMessages.network_error
	end
	if type(Result) ~= "table" then
		return false, ResolveError(Result)
	end
	if Result.status ~= "key_valid" then
		local User = type(Result.user) == "table" and Result.user or nil
		return false, ResolveError(Result.status, Result.message, User and User.blacklist_reason)
	end
	local User = type(Result.user) == "table" and Result.user or {}
	return true, {
		note = User.note,
		expires_at = User.key_expires,
		discord_id = User.discord_id or User.discordId,
		ad_key = User.ad_key == true,
	}, Key
end

EnsureSniper()


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

local Initial = getgenv().script_key
if type(Initial) ~= "string" or Initial == "" then
	Initial = script_key
end
if type(Initial) ~= "string" or Initial == "" then
	Initial = LoadSavedKey()
end

if type(Initial) == "string" and Initial ~= "" and TrySilent(Initial) then
	return
end

do
local Previous = getgenv().Library
if type(Previous) == "table" and type(Previous.AddLoader) == "function" and type(Previous.Unload) == "function" then
	Previous:Unload()
end

gethui = function() return game:GetService("CoreGui") end

local Library; do
    local ServiceCache = {};
    getgenv().Services = setmetatable({}, {
        __index = function(Self, Index)
            if not ServiceCache[Index] then
                ServiceCache[Index] = cloneref(game:GetService(Index));
            end;

            return ServiceCache[Index];
        end
    });

    local Keys = {
        [Enum.KeyCode.LeftShift] = "Left Shift",
        [Enum.KeyCode.RightShift] = "Right Shift",
        [Enum.KeyCode.LeftControl] = "Left Ctrl",
        [Enum.KeyCode.RightControl] = "Right Ctrl",
        [Enum.KeyCode.Insert] = "Insert",
        [Enum.KeyCode.Backspace] = "Backspace",
        [Enum.KeyCode.Return] = "Return",
        [Enum.KeyCode.LeftAlt] = "Left Alt",
        [Enum.KeyCode.RightAlt] = "Right Alt",
        [Enum.KeyCode.CapsLock] = "Capslock",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ";",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "LMB",
        [Enum.UserInputType.MouseButton2] = "RMB",
        [Enum.UserInputType.MouseButton3] = "MMB",
        [Enum.UserInputType.Touch] = "TouchTap",
        [Enum.KeyCode.Escape] = "Escape",
        [Enum.KeyCode.Space] = "Space",
    }

    local Camera = Services.Workspace.CurrentCamera
    local LocalPlayer = Services.Players.LocalPlayer
    local GuiInset = Services.GuiService:GetGuiInset().Y

    local NumSeq = NumberSequence.new
    local ColorSeq = ColorSequence.new

    local NumKey = NumberSequenceKeypoint.new
    local ColorKey = ColorSequenceKeypoint.new

    local Pos = UDim2.new
    local Offset = UDim2.fromOffset
    local Vec = Vector2.new

    Library = {
        Directory = "sportsclub",
        Logo = {"rbxassetid://128716345240510", "rbxassetid://103881456218503"},
        Debug = false,

        ConfigFlags = {},
        PremiumFlags = {},
        FlagCount = 0;
        Connections = {},
        Threads = {},

        Notifications = {},
        NotificationGlowRadius = 10,
        NotificationGlowTransparency = 0.27,
        NotificationOrigin = "Top Left",
        NotificationOrigins = {"Top Left", "Top Center", "Top Right", "Bottom Left", "Bottom Center", "Bottom Right"},

        Keybinds = {},
        Marquees = {},
        MarqueeDelta = 0,
        AnimatedColorpickers = {},
        ColorpickerDelta = 0,

        EasingStyle = Enum.EasingStyle.Exponential,
        TweeningSpeed = 0.4,
        Listeners = {},
        EasingStyleNames = {"Linear", "Cubic", "Quad", "Quart", "Quint", "Sine", "Exponential", "Back", "Bounce", "Elastic", "Circular"},

        Dragging = false;
        Drags = {};
        Bin = {};
    };

    Library.__index = Library;
    getgenv().Library = Library

    local FlagsCache = {}

    Flags = setmetatable({}, {
        __index = function(_,Key)
            return {
                Get = function()
                    return FlagsCache[Key]
                end,

                Set = function(_, Value)
                    local Old = FlagsCache[Key]

                    if Old ~= Value then
                        FlagsCache[Key] = Value

                        if Library.Listeners[Key] then
                            for _,Function in Library.Listeners[Key] do
                                Function(Value)
                            end
                        end
                    end
                end,

                OnChanged = function(_,Function)
                    Library.Listeners[Key] = Library.Listeners[Key] or {}
                    table.insert(Library.Listeners[Key], Function)
                end
            }
        end,

        __newindex = function(self, Key, Value)
            local Old = FlagsCache[Key]

            if Old ~= Value then
                FlagsCache[Key] = Value

                if Library.Listeners[Key] then
                    for _,Function in Library.Listeners[Key] do
                        Function(Value)
                    end
                end
            end
        end
    })

    PremiumFlags = Library.PremiumFlags

    local ConfigFlags = Library.ConfigFlags

    local Themes = {
        Preset = {
            ["Background"] = Color3.fromRGB(10, 10, 10),
            ["Sidebar"] = Color3.fromRGB(14, 14, 14),
            ["Selected"] = Color3.fromRGB(16, 16, 16),
            ["SectionBackground"] = Color3.fromRGB(19, 19, 19),
            ["SectionTop"] = Color3.fromRGB(22, 22, 22),
            ["OtherBackgrounds"] = Color3.fromRGB(24, 24, 24),

            ["Outline"] = Color3.fromRGB(24, 24, 24),
            ["Inline"] = Color3.fromRGB(29, 29, 29),
            ["HighContrast"] = Color3.fromRGB(43, 43, 43),
            ["LowContrast"] = Color3.fromRGB(27, 27, 27),

            ["Unselected"] = Color3.fromRGB(92, 92, 92),
            ["Inactive"] = Color3.fromRGB(78, 78, 78),
            ["Accent"] = Color3.fromRGB(4, 122, 252),
            ["TextColor"] = Color3.fromRGB(240, 240, 240),

            ["Risky"] = Color3.fromRGB(255, 221, 51),
            ["Warning"] = Color3.fromRGB(255, 61, 61),
        },
    }

    local Preset = Themes.Preset

    do
        do



            Library.Lerp = function(self, Start, Finish, Alpha)
                return Start + (Finish - Start) * Alpha
            end


            Library.ColorText = function(self, Text, Colors)
                local Result = ""
                local Position = 1

                while Position <= #Text do
                    local BestStart, BestEnd, BestColor

                    for Word, Color in Colors do
                        if Word == "" then
                            continue
                        end

                        local Start, End = string.find(Text, Word, Position, true)

                        if Start and (not BestStart or Start < BestStart or (Start == BestStart and End > BestEnd)) then
                            BestStart, BestEnd, BestColor = Start, End, Color
                        end
                    end

                    if not BestStart then
                        break
                    end

                    Result ..= string.sub(Text, Position, BestStart - 1) .. string.format('<font color="#%s">%s</font>', BestColor:ToHex(), string.sub(Text, BestStart, BestEnd))
                    Position = BestEnd + 1
                end

                return Result .. string.sub(Text, Position)
            end




        end

        do
            Library.Create = function(self, Class, Options)
                Options = Options or {}

                local Info = setmetatable({Instance = Instance.new(Class)}, Library)
                local Object = Info.Instance

                for Property, Value in Options do
                    if Property ~= "Parent" then
                        Object[Property] = Value
                    end
                end

                if Object:IsA("GuiObject") and not Options.BackgroundColor3 then
                    Object.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end

                if Class == "TextButton" then
                    Object.AutoButtonColor = false

                    if not Options.Text then
                        Object.Text = ""
                    end
                end

                if Class == "ScrollingFrame" and not Options.ScrollBarImageColor3 then
                    Object.ScrollBarImageColor3 = Preset.Accent
                end

                if Class == "TextLabel" or Class == "TextBox" or Class == "TextButton" then
                    if Options.RichText == nil then
                        Object.RichText = true
                    end

                    if not Options.TextColor3 then
                        Object.TextColor3 = Preset.TextColor
                    end
                end

                if Class == "UIStroke" and not Options.LineJoinMode then
                    Object.LineJoinMode = Enum.LineJoinMode.Round
                end

                Object.Name = "\0"

                if Options.Parent then
                    Object.Parent = Options.Parent
                end

                table.insert(self.Bin, Object)

                return Info
            end

            local LayoutToFlag = function(Object)
                return {
                    X = Object.Position.X.Offset,
                    Y = Object.Position.Y.Offset,
                    XScale = Object.Position.X.Scale,
                    YScale = Object.Position.Y.Scale,
                    Width = Object.Size.X.Offset,
                    Height = Object.Size.Y.Offset,
                    WidthScale = Object.Size.X.Scale,
                    HeightScale = Object.Size.Y.Scale,
                }
            end












            Library.Draggify = function(self)
                local Instance = self.Instance
                local Dragging = false
                local StartPosition = nil
                local StartOffset = nil

                local Clamp = function(Position)
                    local Viewport = Camera.ViewportSize
                    local Size = Instance.AbsoluteSize

                    return UDim2.new(
                        Position.X.Scale,
                        math.clamp(Position.X.Offset, 0, math.max(0, Viewport.X - Size.X)),
                        Position.Y.Scale,
                        math.clamp(Position.Y.Offset, 0, math.max(0, Viewport.Y - Size.Y))
                    )
                end

                self:OnDrag(function(Input)
                    if not Dragging then
                        return
                    end

                    self:Tween({Position = Clamp(UDim2.new(
                        Instance.Position.X.Scale,
                        StartOffset.X + (Input.Position.X - StartPosition.X),
                        Instance.Position.Y.Scale,
                        StartOffset.Y + (Input.Position.Y - StartPosition.Y)
                    ))})
                end, function(State, Input)
                    if not State then
                        Dragging = false
                        Library.Dragging = false
                        return
                    end

                    if not Library.Dragging then
                        Dragging = true
                        Library.Dragging = true
                        StartPosition = Input.Position
                        StartOffset = Vec(Instance.Position.X.Offset, Instance.Position.Y.Offset)
                    end
                end)

                return self
            end

            Library.OnClick = function(self, Callback)
                Library:Connect(self.Instance.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Callback()
			end
		end)

                return self
            end


            Library.OnHover = function(self, Callback1, Callback2)
                Library:Connect(self.Instance.MouseEnter, Callback1)
                Library:Connect(self.Instance.MouseLeave, Callback2)

                return self
            end

            Library.OnDrag = function(self, Callback1, Callback2)
                Callback2 = Callback2 or function() end
                Callback1 = Callback1 or function() end

                local dragging = false
                local Moving
                local Ending

                Library:Connect(self.Instance.InputBegan, function(input)
                    if dragging then return end

                    local InputType = input.UserInputType
                    if InputType ~= Enum.UserInputType.MouseButton1 and InputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    dragging = true
                    Callback2(true, input)

                    Moving = Services.UserInputService.InputChanged:Connect(function(InputType)
                        local Type = InputType.UserInputType

                        if Type == Enum.UserInputType.MouseMovement or Type == Enum.UserInputType.Touch then
                            Callback1(InputType)
                        end
                    end)

                    Ending = Services.UserInputService.InputEnded:Connect(function(InputType)
                        local Type = InputType.UserInputType

                        if Type == Enum.UserInputType.MouseButton1 or Type == Enum.UserInputType.Touch then
                            dragging = false

                            Moving:Disconnect()
                            Ending:Disconnect()

                            Library.Drags[Moving] = nil
                            Library.Drags[Ending] = nil

                            Callback2(false, InputType)
                        end
                    end)

                    Library.Drags[Moving] = true
                    Library.Drags[Ending] = true
                end)

                return self
            end


        end

        do
            Library.Tween = function(self, Properties, Info)
                local Tween = Services.TweenService:Create(self.Instance, Info or TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.Out, 0, false, 0), Properties)
                Tween:Play()

                return Tween
            end

            Library.Apply = function(self, Properties, Immediate)
                if self.ApplyTween then
                    self.ApplyTween:Cancel()
                    self.ApplyTween = nil
                end

                if not Immediate then
                    self.ApplyTween = self:Tween(Properties)

					return
				end

                for Property, Value in Properties do
                    self.Instance[Property] = Value
                end
            end



        end

        do
















            Library.NextFlag = function(self)
                self.FlagCount = self.FlagCount + (1)

                return "Flag " .. tostring(self.FlagCount)
            end


        end

        do
            Library.Thread = function(self, Function)
                local Thread = coroutine.create(Function)

                coroutine.wrap(function()
                    coroutine.resume(Thread)
                end)()

                table.insert(self.Threads, Thread)

                return Thread
            end

            Library.Connect = function(self, Signal, Callback)
                local ConnectionInfo = {}

                Library:Thread(function()
                    ConnectionInfo.Connection = Signal:Connect(Callback)
                end)

                table.insert(self.Connections, ConnectionInfo)

                return ConnectionInfo
            end

            Library.Unload = function(self)
                repeat task.wait() until #self.Notifications == 0

                for _, Value in self.Connections do
                    if Value.Connection then
                        Value.Connection:Disconnect()
			end
		end

                for Connection in self.Drags do
                    Connection:Disconnect()
                end

                for _, Value in self.Threads do
                    coroutine.close(Value)
                end

                for _, Instance in self.Bin do
                    Instance:Destroy()
                end

                getgenv().Library = nil
            end
        end
    end

    do
        Library.Items = Library:Create("ScreenGui", {Parent = gethui(); Enabled = true; ZIndexBehavior = Enum.ZIndexBehavior.Sibling; IgnoreGuiInset = true; DisplayOrder = 3})
        Library.HUD = Library:Create("ScreenGui", {Parent = gethui(); Enabled = true; IgnoreGuiInset = true; ZIndexBehavior = Enum.ZIndexBehavior.Sibling; DisplayOrder = 5})
        Library.Other = Library:Create("ScreenGui", {Parent = gethui(); Enabled = false; ZIndexBehavior = Enum.ZIndexBehavior.Sibling; IgnoreGuiInset = true; DisplayOrder = 2})
        Library.Elements = Library:Create("ScreenGui", {Parent = gethui(); Enabled = true; ZIndexBehavior = Enum.ZIndexBehavior.Sibling; IgnoreGuiInset = true; DisplayOrder = 4})








        Library.CreateElements = function(self, Data)
            Data = Data or {}

            local Cfg = {
                Items = {},
            }

            local Items = Cfg.Items; do
                if Data.Scrolling then
                    Items.Elements = Library:Create("ScrollingFrame",{LayoutOrder = Data.LayoutOrder or 0; Active = true; AutomaticCanvasSize = Enum.AutomaticSize.Y; CanvasSize = Pos(0, 0, 0, 0); ScrollBarImageColor3 = Themes.Preset["Accent"]; MidImage = "rbxassetid://128205296381662"; Parent = self.Instance; ScrollBarThickness = 2; Position = Pos(0, 0, 0, 4); Size = Pos(1, -4, 1, -8); TopImage = "rbxassetid://128205296381662"; BorderSizePixel = 0; BottomImage = "rbxassetid://128205296381662"; BackgroundTransparency = 1})
                else
                    Items.Elements = Library:Create("Frame",{LayoutOrder = Data.LayoutOrder or 0; Parent = self.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, Data.Fill and 1 or 0, 0); BorderSizePixel = 0; AutomaticSize = Data.Fill and Enum.AutomaticSize.None or Enum.AutomaticSize.Y})
                end

                Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.Elements.Instance; Padding = Data.Padding or UDim.new(0, 10); SortOrder = Enum.SortOrder.LayoutOrder})
                Items.UIPadding = Library:Create("UIPadding",{PaddingTop = Data.PaddingTop or UDim.new(0, 0); PaddingBottom = Data.PaddingBottom or UDim.new(0, 0); Parent = Items.Elements.Instance; PaddingRight = Data.PaddingRight or UDim.new(0, 0); PaddingLeft = Data.PaddingLeft or UDim.new(0, 0)})
            end

            return setmetatable(Cfg, Library)
        end

        Library.TitleColor = function(self, Cfg)
            if Cfg.Highlighted then
                return Preset.Accent
            end

            if Cfg.Warning then
                return Preset.Warning
            end

            if Cfg.Risky then
                return Preset.Risky
            end

            return Cfg.Dimmed and Preset.Unselected or Preset.TextColor
        end

        Library.PremiumBlocked = function(self, Cfg)
            if tick() - (Cfg.PremiumTick or 0) < 2 then
					return
				end

            Cfg.PremiumTick = tick()

            Library:Notify({Title = tostring(Cfg.Text or "This") .. " is a premium feature", Color = {["premium"] = Preset.Accent}, Duration = 2})
        end

        Library.CreateObject = function(self, Cfg)
            local Items = Cfg.Items

            Items.Object = Library:Create("TextButton",{Parent = self.Items.Elements.Instance; BackgroundTransparency = Library.Debug and 0 or 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; BackgroundColor3 = Color3.fromRGB(255, 0, 0)})
            Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.Object.Instance; Padding = UDim.new(0, 10); SortOrder = Enum.SortOrder.LayoutOrder})
        end

        Library.CreateRow = function(self, Cfg)
            local Items = Cfg.Items

            self:CreateObject(Cfg)

            Items.Row = Library:Create("Frame",{LayoutOrder = 1; Visible = Cfg.Text ~= nil; Parent = Items.Object.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0})
            Items.Left = Library:Create("Frame",{Parent = Items.Row.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y})
            Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.Left.Instance; Padding = UDim.new(0, 3); SortOrder = Enum.SortOrder.LayoutOrder})
            Items.LeftPadding = Library:Create("UIPadding",{Parent = Items.Left.Instance})
            Items.Title = Library:Create("TextLabel",{LayoutOrder = 1; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = Themes.Preset["TextColor"]; Text = Cfg.Text or ""; Parent = Items.Left.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; TextSize = 16; TextWrapped = true; TextXAlignment = Enum.TextXAlignment.Left})
            Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, 1); Parent = Items.Title.Instance})

            if Cfg.Description then
                Items.Description = Library:Create("TextLabel",{LayoutOrder = 2; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal); TextColor3 = Themes.Preset["Unselected"]; Text = Cfg.Description; Parent = Items.Left.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; TextSize = 15; TextWrapped = true; TextXAlignment = Enum.TextXAlignment.Left})
            end

            Items.Right = Library:Create("Frame",{AnchorPoint = Vec(1, 0); Parent = Items.Row.Instance; BackgroundTransparency = 1; Position = Pos(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY})
            Items.UIListLayout = Library:Create("UIListLayout",{FillDirection = Enum.FillDirection.Horizontal; Parent = Items.Right.Instance; Padding = UDim.new(0, 10); SortOrder = Enum.SortOrder.LayoutOrder})

        end



        Library.SetupElement = function(self, Default)
            if self.Flag then
                PremiumFlags[self.Flag] = self.Premium == true
            end

            if self.Set and self.Flag then
                ConfigFlags[self.Flag] = self.Premium and function() end or self.Set
                self.Set(Default)
            end

            if self.DataElements and self.IsHovering then
                table.insert(self.DataElements, self.IsHovering)
            end

            if self.Section and self.Text and self.Type ~= "Label" then
                table.insert(Library.Window.SearchElements, self)
            end

            if not self.SetVisible then
                self.SetVisible = function(Bool)
                    self.Items.Object.Instance.Visible = Bool ~= false
                end
            end
        end











        do



        end

        do
            local NotifSpacing = 9
            local NotifPadding = 32

            local GetOrderedNotifications = function()
                local Ordered = table.clone(Library.Notifications)

                table.sort(Ordered, function(A, B)
                    return A.Index < B.Index
                end)

                return Ordered
            end

            Library.Notify = function(self, Data)
                self = Library
                Data = Data or {}

                self.NotifIdx = (self.NotifIdx or 0) + 1

                local Cfg = {
                    Title = tostring(Data.Title or Data.Text or "Notification"),
                    Description = Data.Description or Data.Desc,
                    Duration = Data.Duration or Data.Time or Data.Lifetime or 3,
                    Color = Data.Color,

                    Items = {},

                    Status = true,
                    Tick = tick(),
                    Index = self.NotifIdx,
                    IsAnim = false,
                }

                local Colors = type(Cfg.Color) == "table" and Cfg.Color
                local TextColor = typeof(Cfg.Color) == "Color3" and Cfg.Color

                local Items = Cfg.Items; do
                    Items.Canvas = Library:Create("CanvasGroup",{GroupTransparency = 1; BackgroundTransparency = 1; Parent = Library.HUD.Instance; BorderSizePixel = 0; ZIndex = 100; AutomaticSize = Enum.AutomaticSize.XY})
                    Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, NotifPadding); PaddingBottom = UDim.new(0, NotifPadding); Parent = Items.Canvas.Instance; PaddingRight = UDim.new(0, NotifPadding); PaddingLeft = UDim.new(0, NotifPadding)})
                    Items.Notification = Library:Create("Frame",{Parent = Items.Canvas.Instance; Size = Pos(0, 0, 0, 37); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Themes.Preset["OtherBackgrounds"]})
                    Items.UICorner = Library:Create("UICorner",{Parent = Items.Notification.Instance; CornerRadius = UDim.new(0, 4)})
                    Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -1); Parent = Items.Notification.Instance})
                    Items.Glow = Library:Create("UIShadow",{Parent = Items.Notification.Instance; Transparency = Library.NotificationGlowTransparency; BlurRadius = UDim.new(0, Library.NotificationGlowRadius); Color = Themes.Preset["Accent"]})
                    Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Inline"]; BorderOffset = UDim.new(0, -2); Parent = Items.Notification.Instance})
                    Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -3); Parent = Items.Notification.Instance})
                    Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.Notification.Instance; Padding = UDim.new(0, 7); SortOrder = Enum.SortOrder.LayoutOrder})
                    Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, 10); PaddingBottom = UDim.new(0, 11); Parent = Items.Notification.Instance; PaddingRight = UDim.new(0, 11); PaddingLeft = UDim.new(0, 11)})
                    Items.Title = Library:Create("TextLabel",{LayoutOrder = 1; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = TextColor or Themes.Preset["TextColor"]; Text = Colors and Library:ColorText(Cfg.Title, Colors) or Cfg.Title; Parent = Items.Notification.Instance; BackgroundTransparency = 1; TextXAlignment = Enum.TextXAlignment.Left; BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; TextSize = 16})

                    if Cfg.Description then
                        Items.Description = Library:Create("TextLabel",{LayoutOrder = 2; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = TextColor or Themes.Preset["Unselected"]; Text = Colors and Library:ColorText(tostring(Cfg.Description), Colors) or tostring(Cfg.Description); Parent = Items.Notification.Instance; BackgroundTransparency = 1; TextXAlignment = Enum.TextXAlignment.Left; BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; TextSize = 16})
                    end

                end

                table.insert(self.Notifications, Cfg)

                task.defer(function()
                    for _, Label in {Items.Title, Items.Description} do
                        if Label.Instance.AbsoluteSize.X > 280 then
                            Label.Instance.AutomaticSize = Enum.AutomaticSize.Y
                            Label.Instance.Size = Pos(0, 280, 0, 0)
                            Label.Instance.TextWrapped = true
                        end
                    end

                    Cfg.Ready = true
                end)

                task.delay(Cfg.Duration + 1.25, function()
                    Cfg.Status = false

                    table.remove(self.Notifications, table.find(self.Notifications, Cfg))
                    Items.Canvas.Instance:Destroy()
                end)

                return setmetatable(Cfg, Library)
            end

            Library.LerpObjects = function(self)
                local Tick = tick()
                local Origin = self.NotificationOrigin
                local Bottom = string.find(Origin, "Bottom") ~= nil
                local Side = (string.find(Origin, "Left") and 0) or (string.find(Origin, "Right") and 1) or 0.5
                local YOffset = 0

                for _, Object in GetOrderedNotifications() do
                    if not Object.Ready then
                        continue
                    end

                    local Canvas = Object.Items.Canvas
                    local Instance = Canvas.Instance

                    if Object.Status and Tick - Object.Tick >= Object.Duration then
                        Object.Status = false
                    end

                    local Visible = Object.Status
                    local SizeX = math.max(Instance.AbsoluteSize.X, 1)

                    local GetPosition = function(Shown)
                        local X = (Side * 2 - 1) * (Shown and NotifPadding - 24 or SizeX)
                        local Y = Bottom and NotifPadding - 24 - YOffset or (Side == 0 and 112 or 64) - NotifPadding + YOffset

                        if Side == 0.5 and not Shown then
                            Y = Y + (Bottom and 24 or -24)
                        end

                        return Pos(Side, X, Bottom and 1 or 0, Y)
                    end

                    if Object.Origin ~= Origin then
                        Object.Origin = Origin
                        Object.IsAnim = nil

                        Instance.AnchorPoint = Vec(Side, Bottom and 1 or 0)
                        Instance.Position = GetPosition(false)
                        Instance.GroupTransparency = 1
                    end

                    if Object.IsAnim ~= Visible or Object.AnimY ~= YOffset or (Visible and Object.AnimSizeX ~= SizeX) then
                        Object.IsAnim = Visible
                        Object.AnimY = YOffset
                        Object.AnimSizeX = SizeX

                        Canvas:Tween({Position = GetPosition(Visible), GroupTransparency = Visible and 0 or 1}, TweenInfo.new(1, Library.EasingStyle, Enum.EasingDirection.Out))
                    end

                    if Visible then
                        YOffset = YOffset + (Object.Items.Notification.Instance.AbsoluteSize.Y + NotifSpacing)
                    end
                end
            end
        end

        do


        end


        Library.AddLoader = function(self, Data)
            Data = Data or {}

            local Cfg = {
                Name = Data.Name or Data.Text or "sportsclub",
                AccentText = Data.AccentText or Data.Accent,
                Logo = Data.Logo or Library.Logo,
                Game = Data.Game or {},
                Key = Data.Key or "",
                KeyLink = Data.KeyLink or "",
                Discord = Data.Discord or "",
                Size = Data.Size or Offset(420, 257),

                Open = true,
                Skipped = false,
                Items = {},
            }; Library.Loader = Cfg

            local Loader = setmetatable(Cfg, Library)
            local Thread = coroutine.running()
            local Viewport = Camera.ViewportSize
            local Supported = Cfg.Game.Supported ~= false

            local Items = Cfg.Items; do
                Items.Loader = Library:Create("TextButton",{Parent = Library.Items.Instance; BackgroundTransparency = 1; Position = Offset((Viewport.X - Cfg.Size.X.Offset) / 2, (Viewport.Y - Cfg.Size.Y.Offset) / 2); Size = Cfg.Size; ZIndex = 2; BorderSizePixel = 0}):Draggify()
                Items.Canvas = Library:Create("CanvasGroup",{GroupTransparency = 1; Parent = Items.Loader.Instance; BackgroundTransparency = 1; Position = Offset(0, -12); Size = Pos(1, 0, 1, 0); BorderSizePixel = 0})
                Items.Panel = Library:Create("Frame",{ClipsDescendants = true; Parent = Items.Canvas.Instance; Size = Pos(1, 0, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["SectionBackground"]})
                Items.UICorner = Library:Create("UICorner",{Parent = Items.Panel.Instance; CornerRadius = UDim.new(0, 5)})
                Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["LowContrast"]; Parent = Items.Panel.Instance})
                Items.UIShadow = Library:Create("UIShadow",{Parent = Items.Panel.Instance; Transparency = 0.86; BlurRadius = UDim.new(0, 20)})
                Items.Inner = Library:Create("Frame",{Parent = Items.Panel.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, Cfg.Size.Y.Offset); BorderSizePixel = 0})
                Items.Holder = Library:Create("Frame",{Parent = Items.Inner.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 1, 0); BorderSizePixel = 0})
                Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.Holder.Instance; SortOrder = Enum.SortOrder.LayoutOrder})

                Items.Top = Library:Create("Frame",{LayoutOrder = 1; Parent = Items.Holder.Instance; Size = Pos(1, 0, 0, 40); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["SectionTop"]})
                Items.UICorner = Library:Create("UICorner",{TopLeftRadius = UDim.new(0, 5); TopRightRadius = UDim.new(0, 5); BottomRightRadius = UDim.new(0, 0); Parent = Items.Top.Instance; BottomLeftRadius = UDim.new(0, 0)})
                Items.UIShadow = Library:Create("UIShadow",{Parent = Items.Top.Instance; Transparency = 0.82; BlurRadius = UDim.new(0, 20)})
                Items.UIListLayout = Library:Create("UIListLayout",{FillDirection = Enum.FillDirection.Horizontal; Parent = Items.Top.Instance; Padding = UDim.new(0, 10); SortOrder = Enum.SortOrder.LayoutOrder; VerticalAlignment = Enum.VerticalAlignment.Center})
                Items.UIPadding = Library:Create("UIPadding",{Parent = Items.Top.Instance; PaddingRight = UDim.new(0, 10); PaddingLeft = UDim.new(0, 13)})
                Items.Logo = Library:Create("Frame",{LayoutOrder = 0; Parent = Items.Top.Instance; BackgroundTransparency = 1; Size = Pos(0, 18, 0, 18); BorderSizePixel = 0})
                Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, -5); Parent = Items.Logo.Instance; PaddingLeft = UDim.new(0, -3)})
                Items.LogoLeft = Library:Create("ImageLabel",{ImageColor3 = Themes.Preset["Accent"]; Parent = Items.Logo.Instance; Image = Cfg.Logo[1]; BackgroundTransparency = 1; Size = Pos(0, 28, 0, 28); BorderSizePixel = 0})
                Items.LogoRight = Library:Create("ImageLabel",{Parent = Items.Logo.Instance; Image = Cfg.Logo[2]; BackgroundTransparency = 1; Size = Pos(0, 28, 0, 28); BorderSizePixel = 0})
                Items.Title = Library:Create("TextLabel",{LayoutOrder = 1; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = Themes.Preset["TextColor"]; Text = "Loader - " .. (Cfg.AccentText and Library:ColorText(Cfg.Name, {[Cfg.AccentText] = Preset.Accent}) or Cfg.Name); Parent = Items.Top.Instance; BackgroundTransparency = 1; Size = Pos(0, 0, 0, 19); BorderSizePixel = 0; TextSize = 18; TextXAlignment = Enum.TextXAlignment.Left; TextTruncate = Enum.TextTruncate.AtEnd})
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 1); Parent = Items.Title.Instance; PaddingLeft = UDim.new(0, 3)})
                Items.UIFlexItem = Library:Create("UIFlexItem",{Parent = Items.Title.Instance; FlexMode = Enum.UIFlexMode.Fill})
                Items.Close = Library:Create("TextButton",{LayoutOrder = 2; Parent = Items.Top.Instance; BackgroundTransparency = 1; Size = Pos(0, 18, 0, 18); BorderSizePixel = 0})
                Items.CloseLines = {}

                for Index, Rotation in {45, -45} do
                    Items.CloseLines[Index] = Library:Create("Frame",{AnchorPoint = Vec(0.5, 0.5); Parent = Items.Close.Instance; Position = Pos(0.5, 0, 0.5, 0); Size = Pos(0, 14, 0, 2); BorderSizePixel = 0; Rotation = Rotation; BackgroundColor3 = Themes.Preset["Unselected"]})
                    Library:Create("UICorner",{Parent = Items.CloseLines[Index].Instance; CornerRadius = UDim.new(1, 0)})
                end

                Items.Content = Library:Create("Frame",{LayoutOrder = 2; Parent = Items.Holder.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0})
                Items.UIFlexItem = Library:Create("UIFlexItem",{Parent = Items.Content.Instance; FlexMode = Enum.UIFlexMode.Fill})
                Items.Elements = Items.Content:CreateElements({Fill = true, PaddingTop = UDim.new(0, 13), PaddingBottom = UDim.new(0, 13), PaddingRight = UDim.new(0, 13), PaddingLeft = UDim.new(0, 13)}).Items.Elements
            end

            Cfg.Copy = function(Link)
                setclipboard(Link)
                Library:Notify({Title = "Copied link to clipboard"})
            end

            Cfg.Close = function(Launched, Skipped)
                if not Cfg.Open then
				return
			end

                Cfg.Open = false
                Cfg.Skipped = Skipped == true

                Items.Canvas:Tween({GroupTransparency = 1, Position = Offset(0, -12)}).Completed:Connect(function()
                    Items.Loader.Instance.Visible = false

                    if Launched then
                        task.spawn(Thread)
                    else
                        Library:Unload()
                    end
                end)
            end

            Cfg.Shop = Data.Shop or ""

            Cfg.Continue = function()
                local Text = Flags[Items.Key.Flag]:Get() or ""

                if type(Data.Validate) == "function" then
                    local Ok, Err = Data.Validate(Text)

                    if not Ok then
                        Library:Notify({Title = tostring(Err or "Invalid key")})

				return
			end

                    Cfg.Close(true)

					return
				end

                if Text ~= Cfg.Key then
                    Library:Notify({Title = "Invalid key"})

					return
				end

                Cfg.Close(true)
            end

            Items.Key = Loader:AddInput({Flag = "Loader Key_ignore", Icon = "rbxassetid://78215653023560", Placeholder = "Enter key...", TextAccent = false})

            if type(Data.Prefill) == "string" and Data.Prefill ~= "" then
                Items.Key.Set(Data.Prefill)
            end

            Library:Connect(Items.Key.Items.Input.Instance.FocusLost, function(Enter)
                if Enter then
                    Cfg.Continue()
                end
            end)

            Items.Information = Library:Create("Frame",{Parent = Items.Elements.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y})
            Items.UIFlexItem = Library:Create("UIFlexItem",{Parent = Items.Information.Instance; FlexMode = Enum.UIFlexMode.Fill})
            Items.UIListLayout = Library:Create("UIListLayout",{FillDirection = Enum.FillDirection.Horizontal; Parent = Items.Information.Instance; Padding = UDim.new(0, 11); SortOrder = Enum.SortOrder.LayoutOrder})
            Items.Icon = Library:Create("ImageLabel",{LayoutOrder = 1; Parent = Items.Information.Instance; Image = Cfg.Game.Icon or ""; Size = Pos(0, 50, 0, 50); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["OtherBackgrounds"]})
            Items.UICorner = Library:Create("UICorner",{Parent = Items.Icon.Instance; CornerRadius = UDim.new(0, 4)})
            Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -1); Parent = Items.Icon.Instance})
            Items.UIShadow = Library:Create("UIShadow",{Parent = Items.Icon.Instance; Transparency = 0.82; BlurRadius = UDim.new(0, 5)})
            Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Inline"]; BorderOffset = UDim.new(0, -2); Parent = Items.Icon.Instance})
            Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -3); Parent = Items.Icon.Instance})
            Items.TextHolder = Library:Create("Frame",{LayoutOrder = 2; Parent = Items.Information.Instance; BackgroundTransparency = 1; BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y})
            Items.UIFlexItem = Library:Create("UIFlexItem",{Parent = Items.TextHolder.Instance; FlexMode = Enum.UIFlexMode.Fill})
            Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.TextHolder.Instance; Padding = UDim.new(0, 5); SortOrder = Enum.SortOrder.LayoutOrder})
            Items.UIPadding = Library:Create("UIPadding",{Parent = Items.TextHolder.Instance; PaddingTop = UDim.new(0, 6)})
            Items.GameTitle = Library:Create("TextLabel",{LayoutOrder = 1; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = Themes.Preset["TextColor"]; Text = "Game: " .. tostring(Cfg.Game.Name or "N/A"); Parent = Items.TextHolder.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 18); BorderSizePixel = 0; TextSize = 18; TextXAlignment = Enum.TextXAlignment.Left; TextTruncate = Enum.TextTruncate.AtEnd; RichText = false})
            Items.Status = Library:Create("TextLabel",{LayoutOrder = 2; FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = Themes.Preset["Unselected"]; Text = string.format('Status: <font color="#%s">%s</font>', (Supported and Color3.fromRGB(61, 255, 122) or Preset.Warning):ToHex(), Supported and "Supported" or "Unsupported"); Parent = Items.TextHolder.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 16); BorderSizePixel = 0; TextSize = 16; TextXAlignment = Enum.TextXAlignment.Left; TextTruncate = Enum.TextTruncate.AtEnd; RichText = true})

            Loader:AddButton({Text = "Continue", Accent = true, Callback = Cfg.Continue}):AddButton({Text = "Get Key", Callback = function()
                Cfg.Copy(Cfg.KeyLink)
            end})

            Loader:AddButton({Text = "Skip Key System", Callback = function()
                local Link = Cfg.Shop
                if type(Link) ~= "string" or Link == "" then
                    Link = Cfg.KeyLink
                end
                if type(Link) == "string" and Link ~= "" then
                    Cfg.Copy(Link)
					return
				end
                Cfg.Close(true, true)
            end}):AddButton({Text = "Join Discord", Callback = function()
                local Invite = Cfg.Discord
                if type(Invite) ~= "string" or Invite == "" then
					return
				end

                Cfg.Copy(Invite)

                local Code = string.match(Invite, "discord%.gg/([%w%-]+)") or string.match(Invite, "discord%.com/invite/([%w%-]+)")
                if not Code then
						return
					end

                task.spawn(function()
                    local RequestFn = (typeof(request) == "function" and request)
                        or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
                        or (typeof(http_request) == "function" and http_request)
                        or (type(http) == "table" and type(http.request) == "function" and http.request)
                    if type(RequestFn) ~= "function" then
						return
					end

                    pcall(RequestFn, {
                        Url = "http://127.0.0.1:6463/rpc?v=1",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com",
                            ["X-Sportsclub-Join"] = "1",
                        },
                        Body = Services.HttpService:JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = { code = Code },
                            nonce = Services.HttpService:GenerateGUID(false),
                        }),
                    })
                end)
            end})

            Items.Close:OnHover(function()
                for _, Line in Items.CloseLines do
                    Line:Apply({BackgroundColor3 = Preset.TextColor})
                end
            end, function()
                for _, Line in Items.CloseLines do
                    Line:Apply({BackgroundColor3 = Preset.Unselected})
                end
            end)

            Items.Close:OnClick(function()
                Cfg.Close()
            end)

            Items.Canvas:Tween({GroupTransparency = 0, Position = Offset(0, 0)})

            coroutine.yield()

            return Loader
        end

        Library.AddButton = function(self, Data)
            Data = Data or {}

            local Cfg = {
                Text = Data.Text or Data.Title or Data.Name or "Button",
                Callback = Data.Callback or function() end,
                Confirmation = Data.Confirmation or false,
                Disabled = Data.Disabled or false,
                Premium = Data.Premium == true,
                Accent = Data.Accent == true,
                Flag = Data.Flag,
                Type = "Button",
                Items = {},

                Tab = self.Tab,
                Section = self.Section,
                Gear = self.Gear,
                DataElements = self.DataElements,
            }

            local Items = Cfg.Items; do
                if self.Type == "Button" then
                    Items.Object = self.Items.Object
                else
                    self:CreateObject(Cfg)

                    Items.Object.Instance.AutomaticSize = Enum.AutomaticSize.None
                    Items.Object.Instance.Size = Pos(1, 0, 0, 37)
                    Items.UIListLayout.Instance.FillDirection = Enum.FillDirection.Horizontal
                    Items.UIListLayout.Instance.Padding = UDim.new(0, 10)
                    Items.UIListLayout.Instance.HorizontalFlex = Enum.UIFlexAlignment.Fill
                end

                Items.Outline = Library:Create("Frame",{Active = true; LayoutOrder = #Items.Object.Instance:GetChildren(); Parent = Items.Object.Instance; Size = Pos(1, 0, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset[Cfg.Accent and "Accent" or "OtherBackgrounds"]})
                Items.UICorner = Library:Create("UICorner",{Parent = Items.Outline.Instance; CornerRadius = UDim.new(0, 4)})
                Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -1); Parent = Items.Outline.Instance})
                Items.UIShadow = Library:Create("UIShadow",{Parent = Items.Outline.Instance; Transparency = 0.82; BlurRadius = UDim.new(0, 5)})

                if Cfg.Accent then
                    Items.Gradient = Library:Create("UIGradient",{Parent = Items.Outline.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(255, 255, 255)), ColorKey(1, Color3.fromRGB(212, 212, 212))}})
                else
                    Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Inline"]; BorderOffset = UDim.new(0, -2); Parent = Items.Outline.Instance})
                    Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -3); Parent = Items.Outline.Instance})
                end

                Items.Title = Library:Create("TextLabel",{FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = Themes.Preset[Cfg.Accent and "TextColor" or "Unselected"]; Text = Cfg.Text; Parent = Items.Outline.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 1, 0); BorderSizePixel = 0; ClipsDescendants = true; TextSize = 16})
            end

            local Confirm = false
            local Hovering = false
            local Pressed = false

            local ApplyVisual = function(Immediate)
                local Color = Preset.Unselected

                if Cfg.Accent then
                    Color = Preset.TextColor

                elseif Pressed or Confirm or Cfg.Highlighted then
                    Color = Preset.Accent
                elseif Hovering then
                    Color = Preset.TextColor
                end

                Items.Title:Apply({TextColor3 = Color}, Immediate)
                Items.Outline:Apply({BackgroundColor3 = Cfg.Accent and Preset.Accent or (Pressed and Preset.LowContrast or Preset.OtherBackgrounds)}, Immediate)
            end

            Cfg.UpdateTitle = ApplyVisual

            Cfg.Fire = function()
                Confirm = false
                Items.Title.Instance.Text = Cfg.Text
                ApplyVisual()

                Cfg.Callback(Cfg.Premium)
            end

            Cfg.SetDisabled = function(Bool)
                Cfg.Disabled = Bool == true
            end

            Cfg.Click = function()
                if Cfg.Disabled then
					return
				end

                if Cfg.Premium then
                    Library:PremiumBlocked(Cfg)

				return
			end

                if Confirm or not Cfg.Confirmation then
                    Cfg.Fire()
					return
				end

                Confirm = true
                ApplyVisual()

                for i = 30, 0, -1 do
                    if not Confirm then
                        return
                    end

                    Items.Title.Instance.Text = string.format("Confirm? (%.1fs)", i / 10)
                    task.wait(0.1)
                end

                Confirm = false
                Items.Title.Instance.Text = Cfg.Text
                ApplyVisual()
            end

            Items.Outline:OnClick(Cfg.Click)

            Items.Outline:OnHover(function()
                Hovering = true
                ApplyVisual()
            end, function()
                Hovering = false
                Pressed = false
                ApplyVisual()
            end)

            Library:Connect(Items.Outline.Instance.InputBegan, function(Input)
                if Cfg.Disabled or Cfg.Premium then
				return
			end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Pressed = true
                    ApplyVisual()
                end
            end)

            Library:Connect(Items.Outline.Instance.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Pressed = false
                    ApplyVisual()
                end
            end)

            local Button = setmetatable(Cfg, Library)
            Button:SetupElement()

            return Button
        end

        Library.AddInput = function(self, Data)
            Data = Data or {}

            local Cfg = {
                Text = Data.Text or Data.Title or Data.Name,
                Description = Data.Description,
                Placeholder = Data.Placeholder or Data.PlaceHolder or "Type here...",
                Icon = Data.Icon,
                Default = Data.Default or "",
                Flag = Data.Flag or Library:NextFlag(),
                Callback = Data.Callback or function() end,
                FocusLost = Data.FocusLost or false,
                ClearTextOnFocus = Data.ClearTextOnFocus == true,
                TextAccent = Data.TextAccent ~= false,
                MaxLength = Data.MaxLength,
                Risky = Data.Risky,
                Warning = Data.Warning,
                Premium = Data.Premium == true,

                Items = {},
                Focused = false,

                Tab = self.Tab,
                Section = self.Section,
                Gear = self.Gear,
                DataElements = self.DataElements,
            }

            Cfg.Dimmed = Cfg.Premium

            local Items = Cfg.Items; do
                self:CreateRow(Cfg)

                Items.BottomRow = Library:Create("Frame",{LayoutOrder = 2; Parent = Items.Object.Instance; BackgroundTransparency = 1; Size = Pos(1, 0, 0, 37); BorderSizePixel = 0})
                Items.Outline = Library:Create("Frame",{Active = true; Parent = Items.BottomRow.Instance; Size = Pos(1, 0, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["OtherBackgrounds"]})
                Items.UICorner = Library:Create("UICorner",{Parent = Items.Outline.Instance; CornerRadius = UDim.new(0, 4)})
                Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -1); Parent = Items.Outline.Instance})
                Items.UIShadow = Library:Create("UIShadow",{Parent = Items.Outline.Instance; Transparency = 0.82; BlurRadius = UDim.new(0, 5)})
                Items.Inline = Library:Create("UIStroke",{Color = Themes.Preset["Inline"]; BorderOffset = UDim.new(0, -2); Parent = Items.Outline.Instance})
                Items.UIStroke = Library:Create("UIStroke",{Color = Themes.Preset["Outline"]; BorderOffset = UDim.new(0, -3); Parent = Items.Outline.Instance})
                Items.Input = Library:Create("TextBox",{FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal); TextColor3 = Themes.Preset["TextColor"]; PlaceholderColor3 = Themes.Preset["Unselected"]; Text = ""; PlaceholderText = Cfg.Placeholder; Parent = Items.Outline.Instance; BackgroundTransparency = 1; Position = Pos(0, Cfg.Icon and 36 or 11, 0, 0); Size = Pos(1, Cfg.Icon and -47 or -22, 1, 0); BorderSizePixel = 0; TextSize = 16; TextXAlignment = Enum.TextXAlignment.Left; ClipsDescendants = true; ClearTextOnFocus = Cfg.ClearTextOnFocus; TextEditable = not Cfg.Premium; RichText = false})
                Items.InputPadding = Library:Create("UIPadding",{Parent = Items.Input.Instance})
                Items.InputGradient = Library:Create("UIGradient",{Parent = Items.Input.Instance})

                if Cfg.Icon then
                    Items.Icon = Library:Create("ImageLabel",{ImageColor3 = Themes.Preset["Unselected"]; Parent = Items.Outline.Instance; Image = Cfg.Icon; BackgroundTransparency = 1; Position = Pos(0, 11, 0, 10); Size = Pos(0, 18, 0, 18); BorderSizePixel = 0})
                end
            end

            Cfg.UpdateInput = function(Immediate)
                Items.Input:Apply({TextColor3 = Cfg.Focused and Cfg.TextAccent and Preset.Accent or Preset.TextColor}, Immediate)
                Items.Inline:Apply({Color = Cfg.Focused and Preset.Accent or Preset.Inline}, Immediate)

                if Items.Icon then
                    Items.Icon:Apply({ImageColor3 = Cfg.Focused and Preset.Accent or Preset.Unselected}, Immediate)
                end
            end

            Cfg.Set = function(Text)
                if type(Text) ~= "string" and type(Text) ~= "number" then
			return
		end

                Text = tostring(Text)

                if Cfg.MaxLength then
                    Text = string.sub(Text, 1, Cfg.MaxLength)
                end

                Flags[Cfg.Flag]:Set(Text)

                Cfg.InputIgnore = true
                Items.Input.Instance.Text = Text
                Cfg.InputIgnore = false

                if not Cfg.CallbackIgnore then
                    Cfg.Callback(Text, Cfg.Premium)
                end
            end

            Items.Outline:OnClick(function()
                if Cfg.Premium then
                    Library:PremiumBlocked(Cfg)

			return
		end

                Items.Input.Instance:CaptureFocus()
            end)

            Library:Connect(Items.Input.Instance.Focused, function()
                if Cfg.Premium then
                    Items.Input.Instance:ReleaseFocus()

			return
		end

                Cfg.Focused = true
                Cfg.UpdateInput()
            end)

            Library:Connect(Items.Input.Instance.FocusLost, function()
                if not Cfg.Focused then
                    return
                end

                Cfg.Focused = false
                Cfg.UpdateInput()

                if Cfg.FocusLost then
                    Cfg.Set(Items.Input.Instance.Text)
                end
            end)

            Library:Connect(Items.Input.Instance:GetPropertyChangedSignal("Text"), function()
                if not Cfg.InputIgnore and not Cfg.FocusLost and not Cfg.Premium then
                    Cfg.Set(Items.Input.Instance.Text)
				end
			end)

            local Input = setmetatable(Cfg, Library)

            Cfg.CallbackIgnore = true
            Input:SetupElement(Cfg.Default)
            Cfg.CallbackIgnore = false

            return Input
        end
    end

    Library:Connect(Services.RunService.Heartbeat, function()
        Library:LerpObjects()
    end)

end

	local function GameCard()
		local Name = "Unknown"
		local PlaceId = game.PlaceId
		local Ok, Info = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(PlaceId)
		end)
		local Icon = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150"
		if Ok and type(Info) == "table" then
			if type(Info.Name) == "string" and Info.Name ~= "" then
				Name = Info.Name
			end
			local AssetId = tonumber(Info.IconImageAssetId)
			if AssetId and AssetId > 0 then
				Icon = "rbxassetid://" .. tostring(AssetId)
			end
		end
		return {
			Name = Name,
			Icon = Icon,
			Supported = type(ScriptId) == "string" and ScriptId ~= "",
		}
	end

	local Result = Library:AddLoader({
			Name = "sportsclub",
			AccentText = "sports",
			KeyLink = Config.KeyLink,
			Discord = Config.Discord,
			Shop = Config.Shop,
		Prefill = type(Initial) == "string" and Initial or "",
		Game = GameCard(),
			Validate = function(Text)
			if type(ScriptId) ~= "string" or ScriptId == "" then
				return false, "This game is not supported."
			end
				local Ok, Data, Key = CheckKey(Text)
				if not Ok then
					return false, tostring(Data)
				end
				ApplyKey(Key, Data)
				ReportFirstGame(Key)
				return true
			end,
		})
	if not Result or Result.Skipped then
		return
	end
		LoadGame()
end

