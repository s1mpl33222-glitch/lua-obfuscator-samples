--[[
    Cobalt
    A runtime developer tool to monitor and intercept network traffic
    coming from the roblox game engine.
    
    This script is NOT intended to be modified.
    To view the source code, see the 'Src' folder on the official GitLab repository!

    Authors: deivid, upio
    GitLab: https://gitlab.com/upio/cobalt/
--]]


-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()local wax,script,require,CreateLookupTable=ImportGlobals(1)local ImportGlobals return (function(...)wax.shared.CobaltStartTime = tick()
wax.shared.IS_ACTOR = false

local FileLogger = require(script.Utils.FileLog)

-- Environment
for _, Service in pairs({
	"ContentProvider",
	"CoreGui",
	"TweenService",
	"Players",
	"RunService",
	"HttpService",
	"UserInputService",
	"TextService",
	"StarterGui",
	"RobloxReplicatedStorage",
}) do
	wax.shared[Service] = cloneref(game:GetService(Service))
end

wax.shared.GetTextBounds = function(Text: string, Font: Font, Size: number, Width: number?): (number, number)
	local Params = Instance.new("GetTextBoundsParams")
	Params.Text = Text
	Params.RichText = true
	Params.Font = Font
	Params.Size = Size
	Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

	local Bounds = wax.shared.TextService:GetTextBoundsAsync(Params)
	Params:Destroy()

	return Bounds.X, Bounds.Y
end

wax.shared.CobaltVerificationToken = wax.shared.HttpService:GenerateGUID()
wax.shared.Hooks = {}

-- Executor Support
wax.shared.ExecutorName = identifyexecutor()
wax.shared.ExecutorSupport = require(script.ExecutorSupport)

local AssetManager = require(script.Utils.UI.Assets.Manager)
AssetManager.PreloadAsync()
wax.shared.ExecutorSupport.ValidateCustomAssets(AssetManager)

wax.shared.Sonner = require(script.Window.Components.Sonner)
wax.shared.SaveManager = require(script.Utils.SaveManager)
wax.shared.Settings = {}

wax.shared.CallFilters = require(script.Utils.CallFilter.Manager)
local CallFiltersSubscription = wax.shared.CallFilters:Subscribe(function(Filters)
	if not wax.shared.ActorCommunicator then
		return
	end

	pcall(wax.shared.ActorCommunicator.Fire, wax.shared.ActorCommunicator, "MainCallFiltersSync", Filters)
end)

local Ratelimiter = require("@src/Utils/Ratelimiter")

-- Session Data
local DoesSupportOthHooks = (
	wax.shared.ExecutorSupport["oth"].IsWorking
	and wax.shared.ExecutorSupport["iscclosure"].IsWorking
	and wax.shared.ExecutorSupport["getnamecallmethod"].IsWorking
	and wax.shared.ExecutorSupport["getrawmetatable"].IsWorking
)
local DoesSupportStandardHooks = (
	wax.shared.ExecutorSupport["hookfunction"].IsWorking
	and wax.shared.ExecutorSupport["hookmetamethod"].IsWorking
	and wax.shared.ExecutorSupport["newcclosure"].IsWorking
	and wax.shared.ExecutorSupport["islclosure"].IsWorking
	and wax.shared.ExecutorSupport["getnamecallmethod"].IsWorking
	and wax.shared.ExecutorSupport["getrawmetatable"].IsWorking
)

wax.shared.IsUsingRakNetHooks = (
	wax.shared.SaveManager:GetState("RakNetHooks") and wax.shared.ExecutorSupport["raknet"].IsWorking
)

wax.shared.IsUsingOthHooks = (
	wax.shared.SaveManager:GetState("OthHooks") and DoesSupportOthHooks
)

wax.shared.IsOutgoingLoggable = wax.shared.IsUsingRakNetHooks or wax.shared.IsUsingOthHooks or DoesSupportStandardHooks

-- Utils
require(script.Utils.Connect)
wax.shared.Hooking = require(script.Utils.Hook.Luau)

-- Code Generation
local LuaEncode = require(script.Utils.CodeGen.Serializer.LuaEncode)
wax.shared.LuaEncode = LuaEncode

local CodeGen = require(script.Utils.CodeGen.Generator)
local InstanceSerializer = require(script.Utils.CodeGen.Serializer.Instance)

-- Variables
if not wax.shared.Players.LocalPlayer then
	wax.shared.Players.PlayerAdded:Wait()
end
--#region @export "PlayerScripts"
wax.shared.LocalPlayer = wax.shared.Players.LocalPlayer
local ContendingPlayerScripts =
	cloneref(wax.shared.LocalPlayer:QueryDescendants("PlayerScripts")[1] or wax.shared.LocalPlayer)
if ContendingPlayerScripts:IsA("PlayerScripts") then
	wax.shared.PlayerScripts = ContendingPlayerScripts
else
	wax.shared.PlayerScripts = nil

	local ChildAddedConnection
	ChildAddedConnection = wax.shared.Connect(wax.shared.LocalPlayer.ChildAdded:Connect(function(Child)
		if Child:IsA("PlayerScripts") then
			wax.shared.PlayerScripts = cloneref(Child)
			wax.shared.Disconnect(ChildAddedConnection)
		end
	end))
end
--#endregion

-- Functions
wax.shared.trampoline_call = trampoline_call or (syn and syn.trampoline_call)
wax.shared.gethui = gethui or function()
	return wax.shared.CoreGui
end
wax.shared.checkcaller = checkcaller or function()
	return nil
end
--#region @export "ExecutorHelpers"
wax.shared.restorefunction = function(Function: (...any) -> ...any, Silent: boolean?)
	local Original = wax.shared.Hooks[Function]

	if Silent and not Original then
		return
	end

	assert(Original, "Function not hooked")

	if restorefunction and isfunctionhooked(Function) then
		restorefunction(Function)
	else
		wax.shared.Hooking.HookFunction(Function, Original)
	end

	wax.shared.Hooks[Function] = nil
end
wax.shared.getrawmetatable = wax.shared.ExecutorSupport["getrawmetatable"].IsWorking
		and (getrawmetatable or debug.getmetatable)
	or function()
		return setmetatable({}, {
			__index = function()
				return function() end
			end,
		})
	end

local RawGetDebugId = clonefunction and clonefunction(game.GetDebugId) or game.GetDebugId
wax.shared.GetDebugId = function(Instance)
	local identity = getthreadidentity()
	setthreadidentity(8)
	local id = RawGetDebugId(Instance)
	setthreadidentity(identity)
	return id
end

wax.shared.newcclosure = wax.shared.ExecutorName == "AWP"
		and function(f, name)
			local env = getfenv(f)
			local x = setmetatable({
				__F = f,
			}, {
				__index = env,
				__newindex = env,
			})

			local nf = function(...)
				return __F(...)
			end

			setfenv(nf, x) -- set func env (env of nf gets deoptimized)
			return newcclosure(nf, name)
		end
	or newcclosure
--#endregion

wax.shared.queue_on_teleport = queue_on_teleport or queueonteleport or function(...) end
wax.shared.SafePack = require(script.Utils.SafePack)

--#region @export "IsPlayerModule"
wax.shared.IsPlayerModule = function(Origin: LocalScript | ModuleScript, Instance: Instance): boolean
	if Instance and Instance.ClassName ~= "BindableEvent" then
		return false
	end

	if not Origin or typeof(Origin) ~= "Instance" or not Origin.IsA(Origin, "LuaSourceContainer") then
		return false
	end

	local PlayerModule = Origin and Origin.FindFirstAncestor(Origin, "PlayerModule") or nil
	if not PlayerModule then
		return false
	end

	if PlayerModule.Parent == nil then
		return true
	end

	if wax.shared.PlayerScripts then
		return compareinstances(PlayerModule.Parent, wax.shared.PlayerScripts)
	end

	return false
end
wax.shared.ShouldIgnore = function(Instance, Origin)
	if not wax.shared.Settings.LogRobloxInternalEvents.Value then
		if Instance.IsDescendantOf(Instance, wax.shared.RobloxReplicatedStorage) then
			return true
		end
	end

	return wax.shared.Settings.IgnoredRemotesDropdown.Value[Instance.ClassName] == true
		or (wax.shared.Settings.IgnorePlayerModule.Value and wax.shared.IsPlayerModule(Origin, Instance))
end
--#endregion

wax.shared.GetTableLength = function(Table)
	if Table["n"] then
		return Table.n
	end

	local Length = 0
	for _, _ in pairs(Table) do
		Length += 1
	end
	return Length
end

wax.shared.Unloaded = false
local CleanupSpy: (() -> ())?

wax.shared.Unload = function()
	if wax.shared.Unloaded then
		return
	end

	local identity = getthreadidentity and getthreadidentity()
	if setthreadidentity then setthreadidentity(8) end

	local PluginManager = wax.shared.CobaltPluginManager
	if PluginManager then
		for _, Plugin in PluginManager.Registry.Plugins do
			if not Plugin.UnloadCallbacks then
				continue
			end

			for _, Callback in Plugin.UnloadCallbacks or {} do
				task.spawn(pcall, Callback)
			end
		end
	end

	if CleanupSpy then
		local Cleanup = CleanupSpy
		CleanupSpy = nil
		pcall(Cleanup)
	end

	if CallFiltersSubscription then
		pcall(CallFiltersSubscription.Disconnect, CallFiltersSubscription)
		CallFiltersSubscription = nil
	end

	if wax.shared.LogThread then
		pcall(task.cancel, wax.shared.LogThread)
		wax.shared.LogThread = nil
	end

	if Ratelimiter then
		pcall(Ratelimiter.StopAll)
	end

	for _, Connection in pairs(wax.shared.Connections) do
		Connection:Disconnect()
	end
	table.clear(wax.shared.Connections)

	for _, Category in wax.shared.Logs do
		for _, Log in Category do
			Log:ClearCalls()
		end
		table.clear(Category)
	end
	table.clear(wax.shared.Logs)
	table.clear(wax.shared.IncomingLogConnectionFunctions)

	getgenv().CobaltInitialized = false
	getgenv().Cobalt = nil

	wax.shared.Communicator:Destroy()
	wax.shared.ScreenGui:Destroy()

	wax.shared.Unloaded = true

	if identity then setthreadidentity(identity) end
end

local AnticheatData = require(script.Utils.Anticheats.Main)

-- Load Script
wax.shared.Communicator = Instance.new("BindableEvent")

wax.shared.SetupLoggingConnection = function()
	if wax.shared.LogConnection then
		wax.shared.LogConnection:Disconnect()
	end

	if wax.shared.LogThread then
		pcall(task.cancel, wax.shared.LogThread)
		wax.shared.LogThread = nil
	end

	wax.shared.LogFileName = `Cobalt/Logs/{DateTime.now():ToIsoDate():gsub(":", "_")}.log`
	local FileLog = FileLogger.new(wax.shared.LogFileName, FileLogger.LOG_LEVELS.INFO, true)

	local LogQueue = {}
	local LogQueueHead = 1
	local LogQueueTail = 0
	wax.shared.LogThread = task.defer(function()
		while not wax.shared.Unloaded do
			while LogQueueHead <= LogQueueTail do
				local Entry = LogQueue[LogQueueHead]
				LogQueue[LogQueueHead] = nil
				LogQueueHead += 1

				if not Entry then
					continue
				end

				local RemoteInstance = Entry.Instance
				local Type = Entry.Type
				local CallOrderInLog = Entry.CallIndex
				local CallDataFromHook = Entry.CallData

				local success, err = pcall(function()
					local generatedCode = CodeGen:BuildCallCode(setmetatable({
						Instance = RemoteInstance,
						Type = Type,
					}, {
						__index = CallDataFromHook,
					}) :: any)

					local comprehensiveDataToSerialize = {
						RemoteInstanceInfo = {
							Name = RemoteInstance and RemoteInstance.Name,
							ClassName = RemoteInstance and RemoteInstance.ClassName,
							Path = RemoteInstance and InstanceSerializer.Serialize(RemoteInstance, {
								DisableNilParentHandler = true,
							}),
						},
						EventType = Type,
						CallOrderInLog = CallOrderInLog,
						DataFromHook = CallDataFromHook,
					}

					local serializedEventData = LuaEncode(
						comprehensiveDataToSerialize,
						{ Prettify = true, InsertCycles = true, UseInstancePaths = true }
					)

					local instanceName = RemoteInstance and RemoteInstance.Name or "UnknownInstance"
					local instanceClassName = RemoteInstance and RemoteInstance.ClassName or "UnknownClass"
					local instancePath = RemoteInstance
							and InstanceSerializer.Serialize(RemoteInstance, {
								DisableNilParentHandler = true,
							})
						or "UnknownPath"

					local logParts = {
						("Instance: %s (%s)"):format(instanceName, instanceClassName),
						("Path: %s"):format(instancePath),
						("Status: %s"):format(CallDataFromHook and CallDataFromHook.Blocked and "Blocked" or "Allowed"),
						("Call Order In Log: %s"):format(CallOrderInLog or "N/A"),
						"-------------------- Event Data --------------------",
						serializedEventData,
						"-------------------- Generated Code --------------------",
						generatedCode,
					}
					local logMessage = table.concat(logParts, "\n\t")
					local threadId = ("%s:%s"):format(Type or "S", instanceName)

					FileLog:Info(threadId, logMessage)
				end)

				if not success then
					local instanceNameForError = RemoteInstance and RemoteInstance.Name or "Unknown"
					FileLog:Error(
						"Logger",
						("Failed to log remote communication for %s:%s - %s"):format(
							Type or "UnknownType",
							instanceNameForError,
							tostring(err)
						)
					)

					warn(
						("Cobalt: Failed to log remote communication for %s:%s - %s"):format(
							Type or "UnknownType",
							instanceNameForError,
							tostring(err)
						)
					)
				end

				task.wait()
			end

			if LogQueueHead > LogQueueTail then
				table.clear(LogQueue)
				LogQueueHead = 1
				LogQueueTail = 0
			end

			task.wait()
		end

		-- Clear the queue and cancel the thread
		table.clear(LogQueue)
		LogQueueHead = 1
		LogQueueTail = 0

		if wax.shared.LogThread then
			pcall(task.cancel, wax.shared.LogThread)
			wax.shared.LogThread = nil
		end
	end)

	return function(Batch)
		if typeof(Batch) ~= "table" then
			return
		end

		for _, Notification in Batch do
			local RemoteInstance = Notification.Instance
			local Type = Notification.Type
			local CallOrderInLog = Notification.CallIndex

			local LogEntry = wax.shared.Logs[Type][wax.shared.GetDebugId(RemoteInstance)]
			if not LogEntry then
				continue
			end

			local CallDataFromHook = LogEntry.Calls[CallOrderInLog]
			if not CallDataFromHook then
				continue
			end

			LogQueueTail += 1
			LogQueue[LogQueueTail] = {
				Instance = RemoteInstance,
				Type = Type,
				CallIndex = CallOrderInLog,
				CallData = CallDataFromHook,
			}
		end
	end
end

if wax.shared.SaveManager:GetState("EnableLogging") then
	local LogConnection = wax.shared.SetupLoggingConnection()
	wax.shared.LogConnection = wax.shared.Connect(wax.shared.Communicator.Event:Connect(LogConnection))
end

wax.shared.Log = require(script.Utils.Log)
wax.shared.Logs = {
	Outgoing = {},
	Incoming = {},
}

wax.shared.NewLog = function(Instance, Type, CallingScript, DebugId)
	local Log = wax.shared.Log.new(Instance, Type, wax.shared.GetTableLength(wax.shared.Logs[Type]) + 1, CallingScript)
	wax.shared.Logs[Type][DebugId] = Log
	return Log
end

local Window = require(script.Window)
if not wax.shared.IsOutgoingLoggable and not wax.shared.SaveManager:GetState("LimitedLoggingAcknowledged") then
	Window.Dialogs.LoggingDisabled.Open(Window)
end

CleanupSpy = require(script.Spy)()

local PluginManager = require(script.Utils.Plugins.Manager)
PluginManager.SetupPlugins()

wax.shared.CobaltPluginManager = PluginManager

wax.shared.Connect(wax.shared.LocalPlayer.OnTeleport:Connect(function()
	if not wax.shared.SaveManager:GetState("ExecuteOnTeleport") then
		return
	end

	-- getgenv().COBALT_LATEST_URL for dev environments
	local CobaltURL = getgenv().COBALT_LATEST_URL
		or "https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"
	wax.shared.queue_on_teleport(string.format(
		[[
		if getgenv().CobaltAutoExecuted then
			return
		end

		getgenv().CobaltAutoExecuted = true
		loadstring(game:HttpGet("%s"))()
	]],
		CobaltURL
	))
end))

getgenv().Cobalt = wax

task.wait(1)
if AnticheatData.Disabled then
	wax.shared.Sonner.success(`Cobalt has bypassed {AnticheatData.Name} (anticheat detected)`)
end

end)() end,
    function()local wax,script,require,CreateLookupTable=ImportGlobals(2)local ImportGlobals return (function(...)--[[

	Very lightweight checks for various executor functions and reports whether they are working or not.
	Some checks also verify that the function works as intended, not just that it exists.

]]

local ExecutorSupport = {
	FailedChecks = {
		Essential = {},
		NonEssential = {},
		DetectionRisk = {},
	},
}

local BrokenFeatures = {
	["Volcano"] = { "oth", "run_on_actor" },
	["Potassium"] = { "oth" }, -- submit a pr to luau
}

type TestOptions = {
	ExistenceOnly: boolean?,
	Essential: boolean?,
	DetectionRisk: boolean?,
}

local DEFAULT_OPTIONS: TestOptions = {
	ExistenceOnly = false,
	Essential = true,
	DetectionRisk = false,
}

local function CheckFFlagValue(Name: string, Value: any)
	local Success, Result = pcall(getfflag, Name)
	if not Success then
		return false
	end

	if typeof(Result) == "boolean" then
		return Result
	end

	if typeof(Result) == "string" then
		return Result == tostring(Value)
	end

	return false
end

local function test(name: string, Callback: any, options: TestOptions?)
	options = options or DEFAULT_OPTIONS

	local ExistenceOnly = if options.ExistenceOnly == nil then DEFAULT_OPTIONS.ExistenceOnly else options.ExistenceOnly
	local Essential = if options.Essential == nil then DEFAULT_OPTIONS.Essential else options.Essential
	local DetectionRisk = if options.DetectionRisk == nil then DEFAULT_OPTIONS.DetectionRisk else options.DetectionRisk

	local TestFunction = if not ExistenceOnly
		then Callback
		else function()
			assert(typeof(Callback) == "function", string.format("%s is not a function.", name))
			return "Passed nil check."
		end

	local Success, Result
	if BrokenFeatures[wax.shared.ExecutorName] and table.find(BrokenFeatures[wax.shared.ExecutorName], name) then
		Success = false
		Result = "This function/library is broken or can crash your game on this executor."
	else
		Success, Result = pcall(TestFunction)
	end

	ExecutorSupport[name] = {
		IsWorking = Success,
		Details = Result,
		Essential = Essential,
		DetectionRisk = DetectionRisk,
	}

	if not Success then
		if Essential then
			table.insert(ExecutorSupport.FailedChecks.Essential, name)
		else
			table.insert(ExecutorSupport.FailedChecks.NonEssential, name)
		end

		if DetectionRisk then
			table.insert(ExecutorSupport.FailedChecks.DetectionRisk, name)
		end
	end
end

local TEST_EXISTENCE_ONLY = { ExistenceOnly = true }

-- Filesystem Library
test("FileSystem", function()
	for Name, Function in {
		isfile = isfile,
		isfolder = isfolder,
		makefolder = makefolder,
		writefile = writefile,
		appendfile = appendfile,
		readfile = readfile,
		delfile = delfile,
		delfolder = delfolder,
		listfiles = listfiles,
	} do
		assert(typeof(Function) == "function", `{Name} is not a function`)
	end

	local TestDirectory = `Cobalt-Filesystem-Test-{wax.shared.HttpService:GenerateGUID(false)}`
	local TestFile = `{TestDirectory}/test.txt`
	local Success, Error = pcall(function()
		makefolder(TestDirectory)
		assert(isfolder(TestDirectory), "makefolder did not create a directory")

		writefile(TestFile, "Cobalt")
		assert(isfile(TestFile), "writefile did not create a file")
		assert(readfile(TestFile) == "Cobalt", "readfile did not return the written contents")

		appendfile(TestFile, " filesystem test")
		assert(readfile(TestFile) == "Cobalt filesystem test", "appendfile did not append contents")
		assert(#listfiles(TestDirectory) > 0, "listfiles did not return the test file")
	end)

	pcall(delfile, TestFile)
	pcall(delfolder, TestDirectory)
	assert(Success, Error)
end, { Essential = false })

local function SkipOptionalChecks(): boolean
	if not ExecutorSupport.FileSystem.IsWorking or not isfile("Cobalt/Settings.json") then
		return false
	end

	local Success, Settings = pcall(function()
		return wax.shared.HttpService:JSONDecode(readfile("Cobalt/Settings.json"))
	end)
	return Success and Settings.DisableNonEssentialChecks == true
end

-- FFlag Library
test("getfflag", getfflag, TEST_EXISTENCE_ONLY)
test("setfflag", setfflag, TEST_EXISTENCE_ONLY)

-- Actor Library
test("getactors", getactors, TEST_EXISTENCE_ONLY)
test("run_on_actor", run_on_actor, TEST_EXISTENCE_ONLY)
test("create_comm_channel", create_comm_channel, TEST_EXISTENCE_ONLY)

-- Closure Library
test("newcclosure", function()
	assert(typeof(newcclosure) == "function", "newcclosure is not a function")
	local CClosure = newcclosure(function()
		return true
	end)

	assert(typeof(CClosure) == "function", "newcclosure did not return a function")
	assert(CClosure() == true, "Failed to create a new closure")

	assert(debug.info(CClosure, "s") == "[C]", "newcclosure did not create a C closure")
end)

test("iscclosure", function()
	assert(typeof(iscclosure) == "function", "iscclosure is not a function")
	assert(iscclosure(math.abs), "iscclosure did not identify a C closure")
	assert(not iscclosure(function() end), "iscclosure identified a Luau closure as a C closure")
end)

test("islclosure", function()
	assert(typeof(islclosure) == "function", "islclosure is not a function")
	assert(islclosure(function() end), "islclosure did not identify a Luau closure")
	assert(not islclosure(math.abs), "islclosure identified a C closure as a Luau closure")
end)

test("checkcaller", checkcaller, TEST_EXISTENCE_ONLY)
test("getcallingscript", getcallingscript, TEST_EXISTENCE_ONLY)

test("hookfunction", function()
	assert(typeof(hookfunction) == "function", "hookfunction is not a function")

	local function Original(a, b)
		return a + b
	end

	local ref = hookfunction(Original, function(a, b)
		return a * b
	end)

	assert(Original(2, 3) == 6, "Failed to hook a function and change the return value")
	assert(ref(2, 3) == 5, "Did not return the original function")
end)
test("isfunctionhooked", function()
	assert(typeof(isfunctionhooked) == "function", "isfunctionhooked is not a function")
	assert(typeof(hookfunction) == "function", "hookfunction is required for this test")

	local function Original(a, b)
		return a + b
	end

	assert(isfunctionhooked(Original) == false, "isfunctionhooked returned true for an unhooked function")

	hookfunction(Original, function(a, b)
		return a * b
	end)

	assert(isfunctionhooked(Original) == true, "isfunctionhooked returned false for a hooked function")
end)
test("restorefunction", function()
	assert(typeof(restorefunction) == "function", "restorefunction is not a function")
	assert(typeof(hookfunction) == "function", "hookfunction is required for this test")

	local function Original(a, b)
		return a + b
	end

	hookfunction(Original, function(a, b)
		return a * b
	end)

	assert(Original(2, 3) == 6, "Failed to hook a function and change the return value")

	restorefunction(Original)

	assert(Original(2, 3) == 5, "restorefunction did not restore the original function")
end)

test("setstackhidden", function()
	assert(typeof(setstackhidden) == "function", "setstackhidden is not a function")

	local StackCheck = {}

	local CallerFunctionSource = [[
		local StackCheck = ...
		local function CallerFunction()
			return StackCheck[1]()
		end
		return CallerFunction
	]]

	local CallerFunction = (loadstring(CallerFunctionSource, "=CallerFunction") :: (...any) -> ...any)(StackCheck)

	setstackhidden(CallerFunction, true)

	StackCheck[1] = function()
		return debug.info(2, "f") ~= CallerFunction
	end

	local IsHidden = CallerFunction()
	assert(IsHidden == true, "setstackhidden did not hide the function from the stack (debug.info)")

	StackCheck[1] = function()
		return not debug.traceback():find("CallerFunction")
	end

	IsHidden = CallerFunction()
	assert(IsHidden == true, "setstackhidden did not hide the function from the stack (debug.traceback)")

	local TestTable = { math.huge, 0 / 0, 123, 58913 } :: { any }
	setfenv(CallerFunction, TestTable)

	StackCheck[1] = function()
		return getfenv(2) ~= TestTable
	end

	IsHidden = CallerFunction()
	assert(IsHidden == true, "setstackhidden did not hide the function from the stack (getfenv)")

	StackCheck[1] = function()
		return not select(2, pcall(error, "", 3)):find("CallerFunction")
	end

	IsHidden = CallerFunction()
	assert(IsHidden == true, "setstackhidden did not hide the function from the stack (error with level traceback)")
end, { Essential = false, DetectionRisk = true })

test("FilterBase", function()
	assert(AllFilter ~= nil, "AllFilter not found")
	assert(AnyFilter ~= nil, "AnyFilter not found")
	assert(NotFilter ~= nil, "NotFilter not found")
	assert(ArgumentFilter ~= nil, "ArgumentFilter not found")
	assert(InstanceTypeFilter ~= nil, "InstanceTypeFilter not found")
	assert(NamecallFilter ~= nil, "NamecallFilter not found")
end, { Essential = false, DetectionRisk = false })

-- Oth Library
test("oth", function()
	assert(oth ~= nil, "oth library not found")

	assert(typeof(oth.hook) == "function", "oth.hook is not a function")
	assert(hookfunction ~= oth.hook, "oth.hook is an alias of hookfunction")

	assert(typeof(oth.unhook) == "function", "oth.unhook is not a function")
	assert(restorefunction ~= oth.unhook, "oth.unhook is an alias of restorefunction")

	assert(typeof(oth.is_hook_thread) == "function", "oth.is_hook_thread is not a function")
	assert(typeof(oth.get_original_thread) == "function", "oth.get_original_thread is not a function")

	local VIM = Instance.new("VirtualInputManager")
	local Origin = coroutine.running()

	local Working, AttributeChangedCalled = nil, false
	local AttributeChangedConnect = VIM.AttributeChanged.Connect

	local Old
	Old = oth.hook(AttributeChangedConnect, function(...)
		if Working == nil then
			Working = (Origin ~= coroutine.running() and oth.is_hook_thread() and oth.get_original_thread() == Origin)
			return
		end

		return Old(...)
	end)

	AttributeChangedConnect(VIM.AttributeChanged, function(name)
		if name ~= "cobalt" then
			return
		end

		AttributeChangedCalled = true
		coroutine.resume(Origin)
	end)

	VIM:SetAttribute("cobalt", true)
	repeat
		task.wait()
	until Working ~= nil or AttributeChangedCalled
	assert(Working, "oth.hook is not running on a seperate thread")

	local Success, Error = pcall(oth.unhook, AttributeChangedConnect, Old)
	assert(Success, "oth.unhook failed: " .. tostring(Error))
	VIM:Destroy()

	if not SkipOptionalChecks() then
		assert(typeof(getrawmetatable) == "function", "getrawmetatable is required to validate oth __namecall returns")
		assert(
			typeof(getnamecallmethod) == "function",
			"getnamecallmethod is required to validate oth __namecall returns"
		)

		local function CheckInvokeResult(Result, Context)
			if Result.n ~= 4 then
				return false, `{Context}: returned {Result.n} values instead of 4`
			end
			if Result[1] ~= "expected" then
				return false, `{Context}: did not preserve the first return value`
			end
			if Result[2] ~= 123 then
				return false, `{Context}: did not preserve the second return value`
			end
			if Result[3] ~= nil then
				return false, `{Context}: did not preserve the nil return value`
			end
			if Result[4] ~= "tail" then
				return false, `{Context}: did not preserve the tail return value`
			end

			return true
		end

		local Bindable = Instance.new("BindableFunction")
		Bindable.OnInvoke = function()
			return "expected", 123, nil, "tail"
		end

		local SuccededInsideHook, InsideError = false, nil

		local OldNamecall
		OldNamecall = oth.hook(getrawmetatable(game).__namecall, function(...)
			local self = ...
			local Method = getnamecallmethod()

			if self == Bindable and Method == "Invoke" then
				pcall(function() end)

				local Result = table.pack(OldNamecall(...))

				SuccededInsideHook, InsideError = CheckInvokeResult(Result, "Result corruption in __namecall oth hook")

				return table.unpack(Result, 1, Result.n)
			end

			return OldNamecall(...)
		end)

		local Result = table.pack(Bindable:Invoke())
		pcall(oth.unhook, getrawmetatable(game).__namecall)
		Bindable:Destroy()

		assert(SuccededInsideHook, InsideError)
		assert(CheckInvokeResult(Result, "Result corruption post oth hook and pcall"))
	end
end, { Essential = false, DetectionRisk = true })

-- RakNet Library
test("raknet", function()
	assert(raknet ~= nil, "raknet library not found")

	assert(typeof(raknet.add_send_hook) == "function", "raknet.add_send_hook is not a function")
	assert(typeof(raknet.remove_send_hook) == "function", "raknet.remove_send_hook is not a function")

	assert(typeof(raknet.add_receive_hook) == "function", "raknet.add_receive_hook is not a function")
	assert(typeof(raknet.remove_receive_hook) == "function", "raknet.remove_receive_hook is not a function")

	if typeof(raknet.is_enabled) == "function" then
		assert(raknet.is_enabled() == true, "raknet is not enabled")
	else
		local Success, Error = pcall(function()
			local hook = raknet.add_send_hook(function() end)
			raknet.remove_send_hook(hook)
		end)
	
		assert(Success, "raknet failed to hook (not enabled?): " .. tostring(Error))
	end
end, { Essential = false })

-- Metamethod
test("hookmetamethod", function()
	assert(typeof(hookmetamethod) == "function", "hookmetamethod is not a function")

	local object = setmetatable({}, {
		__index = newcclosure(function()
			return false
		end),
		__metatable = "Locked!",
	})

	local ref = hookmetamethod(object, "__index", function()
		return true
	end)

	assert(object.test == true, "Failed to hook a metamethod and change the return value")
	assert(ref() == false, "Did not return the original function")
end)
test("getnamecallmethod", function()
	assert(typeof(getnamecallmethod) == "function", "getnamecallmethod is not a function")

	pcall(function()
		game:TEST_NAMECALL_METHOD()
	end)

	assert(getnamecallmethod() == "TEST_NAMECALL_METHOD", "getnamecallmethod did not return the real namecall method")
end)
test("getrawmetatable", function()
	assert(typeof(getrawmetatable) == "function", "getrawmetatable is not a function")

	local BaseLockedMetatable = {
		__index = function()
			return false
		end,
		__metatable = "Locked!",
	}

	local TestMetatable = setmetatable({}, BaseLockedMetatable)

	local FetchedMetatable = getrawmetatable(TestMetatable)
	assert(typeof(FetchedMetatable) == "table", "getrawmetatable did not return a table")

	assert(FetchedMetatable.__index() == false, "getrawmetatable did not return the correct metatable [__index()]")
	assert(
		FetchedMetatable.__metatable == "Locked!",
		"getrawmetatable did not return the correct metatable [locked mt check]"
	)

	assert(
		FetchedMetatable == BaseLockedMetatable,
		"getrawmetatable did not return the correct metatable [mt eq check]"
	)
end)

-- Instance Library
test("getcallbackvalue", function()
	assert(typeof(getcallbackvalue) == "function", "getcallbackvalue is not a function")

	local bindable = Instance.new("BindableFunction")
	local InvokeRan = false
	local InvokeFunction = function(value)
		InvokeRan = true
		return value * 2
	end
	bindable.OnInvoke = InvokeFunction

	local FetchedInvoke = getcallbackvalue(bindable, "OnInvoke")
	bindable:Destroy()

	assert(typeof(FetchedInvoke) == "function", "getcallbackvalue did not return a function")

	assert(FetchedInvoke(5) == 10, "getcallbackvalue's function return did not match expected value")
	assert(InvokeRan, "getcallbackvalue's function did not run")
end)
test("getnilinstances", function()
	assert(typeof(getnilinstances) == "function", "getnilinstances is not a function")

	local NilInstances = getnilinstances()
	assert(typeof(NilInstances) == "table", "getnilinstances did not return a table")
end)
test("getconnections", function()
	assert(typeof(getconnections) == "function", "getconnections is not a function")

	local Event = Instance.new("BindableEvent")
	local ConnectionFunction = function() end
	local OnceFunction = function() end

	Event.Event:Connect(ConnectionFunction)
	Event.Event:Once(OnceFunction)
	task.spawn(function()
		Event.Event:Wait()
	end)

	local Connections = getconnections(Event.Event)

	assert(typeof(Connections) == "table", "getconnections did not return a table")
	assert(#Connections == 3, "getconnections did not return the correct number of connections")

	local FoundFunctions = {}
	for _, Connection in Connections do
		local _, ConnFunc = pcall(function()
			return Connection.Function
		end)

		if typeof(ConnFunc) == "function" then
			table.insert(FoundFunctions, ConnFunc)
		end
	end

	assert(
		table.find(FoundFunctions, ConnectionFunction) ~= nil,
		"getconnections did not return the correct connection [:Connect()]"
	)
	assert(
		table.find(FoundFunctions, OnceFunction) ~= nil,
		"getconnections did not return the correct connection [:Once()]"
	)

	Event:Destroy()
end)
test("firesignal", function()
	assert(typeof(firesignal) == "function", "firesignal is not a function")

	local event = Instance.new("BindableEvent")
	local fired = false

	event.Event:Once(function(value)
		fired = value
	end)

	firesignal(event.Event, true)
	task.wait(0.1)
	event:Destroy()

	assert(fired, "Failed to fire a BindableEvent")
end)
test("cloneref", function()
	assert(typeof(cloneref) == "function", "cloneref is not a function")

	local ref = cloneref(game)
	assert(ref ~= game, "cloneref did not create a ref to instance")
	assert(typeof(ref) == "Instance", "cloneref did not return an instance")
end)
test("compareinstances", function()
	assert(typeof(compareinstances) == "function", "compareinstances is not a function")
	assert(typeof(cloneref) == "function", "cloneref is required for this test")

	assert(compareinstances(game, cloneref(game)) == true, "compareinstances did not return true for the same instance")
	assert(compareinstances(game, workspace) == false, "compareinstances did not return false for different instances")
end)

if CheckFFlagValue("DebugRunParallelLuaOnMainThread", false) and not ExecutorSupport["run_on_actor"].IsWorking then
	task.spawn(function()
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end

		local GameUsesActors = false

		local CategoryToSearch = { game:QueryDescendants("Actor") }
		if ExecutorSupport["getnilinstances"].IsWorking then
			table.insert(CategoryToSearch, getnilinstances())
		end

		for _, Category in CategoryToSearch do
			if GameUsesActors then
				break
			end

			for _, Instance in Category do
				if not Instance:IsA("Actor") then
					continue
				end

				GameUsesActors = true
				break
			end
		end

		if not GameUsesActors then
			return
		end

		local bindable = Instance.new("BindableFunction")

		function bindable.OnInvoke(response)
			if response == "Enable Fix" then
				setfflag("DebugRunParallelLuaOnMainThread", "true")
				wax.shared.StarterGui:SetCore("SendNotification", {
					Title = "Cobalt",
					Text = "Please rejoin for the fix to take effect!",
					Duration = math.huge,
				})
			end

			bindable:Destroy()
		end

		wax.shared.StarterGui:SetCore("SendNotification", {
			Title = "Cobalt",
			Text = "This game may use remotes in a way that your executor can't intercept. You can enable the fix and rejoin to detect them.",
			Duration = math.huge,
			Callback = bindable,
			Button1 = "Enable Fix",
			Button2 = "Dismiss",
		})
	end)
end

function ExecutorSupport.ValidateCustomAssets(AssetManager)
	test("getcustomasset", function()
		assert(typeof(getcustomasset) == "function", "getcustomasset is not a function")

		local Success, Error = AssetManager.ValidateCustomFonts()
		assert(Success, Error)
	end, { Essential = false })
end

return ExecutorSupport

end)() end,
    function()local wax,script,require,CreateLookupTable=ImportGlobals(3)local ImportGlobals return (function(...)return function()
	local Hooks = script.Hooks
	local IncomingOnlyOptions = {
		IncomingConnections = true,
		IncomingCallbacks = false,
		HookIncomingConnections = false,
		Outgoing = false,
		Actors = true,
	}

	if wax.shared.IsUsingRakNetHooks then
		local CleanupLuau = require(Hooks.Luau)(IncomingOnlyOptions)
		local CleanupRakNet = require(Hooks.RakNet)()

		return function()
			pcall(CleanupRakNet)
			pcall(CleanupLuau)
		end
	end

	if not wax.shared.IsOutgoingLoggable then
		return require(Hooks.Luau)(IncomingOnlyOptions)
	end

	return require(Hooks.Luau)()
end

end)() end,
    [5] = function()local wax,script,require,CreateLookupTable=ImportGlobals(5)local ImportGlobals return (function(...)--// Imports \\--
local Validation = require("@src/Utils/Validation")
local LuaEncode = require("@src/Utils/CodeGen/Serializer/LuaEncode")
local IsEqualToInstance = require("@src/Utils/CodeGen/Serializer/Instance").IsEqualToInstance

local Interceptors = script.Interceptors

--// Types \\--
export type Options = {
	IncomingConnections: boolean?,
	IncomingCallbacks: boolean?,
	HookIncomingConnections: boolean?,
	Outgoing: boolean?,
	Actors: boolean?,
}

local OptionsTemplate: Options = {
	IncomingConnections = true,
	IncomingCallbacks = true,
	HookIncomingConnections = true,
	Outgoing = true,
	Actors = true,
}

return function(Options: Options?)
	--// Validation \\--
	Options = Validation.FillTemplate(Options or {}, OptionsTemplate)

	--// Options \\--
	local IsUsingRakNetHooks = wax.shared.IsUsingRakNetHooks
	local IncomingConnections = Options.IncomingConnections ~= false
	local IncomingCallbacks = Options.IncomingCallbacks ~= false and not IsUsingRakNetHooks
	local HookIncomingConnections = Options.HookIncomingConnections ~= false and not IsUsingRakNetHooks
	local Outgoing = Options.Outgoing ~= false and not IsUsingRakNetHooks
	local Actors = Options.Actors ~= false

	-- Main Thread Hooks
	task.spawn(require(Interceptors.Incoming), {
		Connections = IncomingConnections,
		Callbacks = IncomingCallbacks,
		HookConnections = HookIncomingConnections,
	})

	if Outgoing then
		task.spawn(require, Interceptors.Outgoing)
	end

	getgenv().CobaltInitialized = true

	-- Actors use a different lua vm
	-- This means that our main thread metatable hooks dont apply in the actor's vm
	-- So we need to set up the hooks again in the actor lua vm in order to log everything
	local ActorsUtils = script.Actors

	wax.shared.ActorsEnabled = Actors
		and (
			wax.shared.ExecutorSupport["run_on_actor"].IsWorking
			and wax.shared.ExecutorSupport["getactors"].IsWorking
			and wax.shared.ExecutorSupport["create_comm_channel"].IsWorking
		)

	if wax.shared.ActorsEnabled then
		local ActorEnvironmentCode = ActorsUtils.Environment.Value

		local CommunicationChannelID, Channel = create_comm_channel()
		
		--// Has .Internal \\--
		if pcall(function()
			assert(typeof(Channel.Internal) == "Instance", "im NOT volting it ⚡")
		end) then
			wax.shared.ActorCommunicator = Channel.Internal
		else
			wax.shared.ActorCommunicator = Channel
		end


		local IgnorePlayerModule = wax.shared.SaveManager:GetState("IgnorePlayerModule")
		local LogBlockedRemotes = wax.shared.SaveManager:GetState("LogBlockedRemotes")
		local IngoredRemotesDropdown = wax.shared.SaveManager:GetState("IgnoredRemotesDropdown")
		local LogRobloxInternalEvents = wax.shared.SaveManager:GetState("LogRobloxInternalEvents")

		local ActorData = LuaEncode({
			Token = wax.shared.CobaltVerificationToken,

			--// Luau Hook Options \\--
			IncomingConnections = IncomingConnections,
			IncomingCallbacks = IncomingCallbacks,
			HookIncomingConnections = HookIncomingConnections,
			Outgoing = Outgoing,

			--// Settings \\--
			LogRobloxInternalEvents = LogRobloxInternalEvents,
			IgnorePlayerModule = IgnorePlayerModule,
			LogBlockedRemotes = LogBlockedRemotes,
			IgnoredRemotesDropdown = IngoredRemotesDropdown,

			--// Executor Support \\--
			ExecutorSupport = wax.shared.ExecutorSupport,
		})

		ActorEnvironmentCode = ActorEnvironmentCode:gsub("COBALT_ACTOR_DATA", ActorData)

		--#region Actor Logs Sync Layer
		local function ReconstructTable(Info, CyclicRefs)
			local Reconstructed = {}

			for Key, Value in Info do
				if type(Value) == "table" then
					if Value["__Function"] and Value["Validation"] == wax.shared.CobaltVerificationToken then
						local FunctionData = table.clone(Value)
						FunctionData["__Function"] = nil
						FunctionData["Validation"] = nil

						Reconstructed[Key] = FunctionData
						continue
					end

					-- Check for Cobalt Created Object
					if not Value["__CyclicRef"] then
						Reconstructed[Key] = ReconstructTable(Value, CyclicRefs)
						continue
					end

					local CyclicId = Value["__Id"]

					if not CyclicRefs[CyclicId] then
						warn("CyclicRef not found: " .. CyclicId)
						continue
					end

					Reconstructed[Key] = CyclicRefs[CyclicId]
					continue
				end

				Reconstructed[Key] = Value
			end

			return Reconstructed
		end

		local function ReconstructPacked(Packed)
			if not Packed or not Packed.Data then
				return Packed
			end

			local PackedN, PackedData = Packed.n, Packed.Data
			PackedData.n = PackedN
			return PackedData
		end

		wax.shared.Connect(Channel.Event:Connect(function(EventType, ...)
			local ShouldLogActors = wax.shared.SaveManager:GetState("LogActors")

			if not ShouldLogActors then
				return
			end

			if EventType == "IncomingConnectionMetadata" then
				local Instance, LogIndex, CallIndex, RawInfo, CyclicRefs = ...
				Instance = cloneref(Instance)

				local DebugId = wax.shared.GetDebugId(Instance)

				local Log = wax.shared.Logs.Incoming[DebugId]
				if not Log and LogIndex ~= nil then
					for _, Candidate in wax.shared.Logs.Incoming do
						if Candidate.Index == LogIndex then
							Log = Candidate
							break
						end
					end
				end

				local OriginalCall = Log and Log.Calls[CallIndex]
				if not OriginalCall then
					return
				end

				local Metadata = ReconstructTable(RawInfo, CyclicRefs)
				local NewCallIndex = Log:Call({
					Arguments = OriginalCall.Arguments,
					Origin = Metadata.Origin,
					Function = Metadata.Function,
					Line = Metadata.Line,
					Source = OriginalCall.Source,
					IsExecutor = Metadata.IsExecutor,
					IsActor = true,
					Actor = Metadata.Actor,
					Blocked = OriginalCall.Blocked,
					Highlighted = OriginalCall.Highlighted,
					CallFilterId = OriginalCall.CallFilterId,
				})

				--// Make Memory Usage More Efficient \\--
				if NewCallIndex and Log.Calls[NewCallIndex] then
					Log.Calls[NewCallIndex].Arguments = OriginalCall.Arguments
				end

				return
			end

			if EventType ~= "ActorCall" then
				return
			end

			local Instance, Type, RawInfo, CyclicRefs = ...
			Instance = cloneref(Instance)

			if IsEqualToInstance(Instance, Channel) or IsEqualToInstance(Instance, wax.shared.Communicator) then
				return
			end

			local DebugId = wax.shared.GetDebugId(Instance)

			local Log = wax.shared.Logs[Type][DebugId]

			if not Log then
				Log = wax.shared.NewLog(Instance, Type, RawInfo.Origin, DebugId)
			end

			local ReconstructedInfo = ReconstructTable(RawInfo, CyclicRefs)
			ReconstructedInfo.IsActor = true -- Incase the Actor Instance is nil for some reason

			--// Reconstruct Packed Arguments (BindableEvents omit ["n"] for unknown reason) \\--
			ReconstructedInfo.Arguments = ReconstructPacked(ReconstructedInfo.Arguments)
			ReconstructedInfo.InvokeResult = ReconstructPacked(ReconstructedInfo.InvokeResult)

			Log:Call(ReconstructedInfo)
		end))
		--#endregion

		--#region Actor Hooking Logic
		-- The hooking code wont run again if cobalt is already initialized in that Actor (to address deleted actors aka LuaStateProxy stuff)

		-- God this code is so ass 🥹
		local function HookActor(TargetActor: Actor)
			local Hooked = false
			local Attempts = 0

			repeat
				Hooked, _ = pcall(run_on_actor, TargetActor, ActorEnvironmentCode, CommunicationChannelID, TargetActor)

				Attempts += 1
				task.wait(0.25)
			until Hooked or Attempts > 10

			if Hooked then
				pcall(function() Channel:Fire("MainCallFiltersSync", wax.shared.CallFilters:GetAll()) end)
			end
		end

		local ActorLibraryQuirks = {
			getactorstates = {
				FuncExists = typeof(getactorstates) == "function",
				ReturnsThreads = false,
				ReturnsLuaStateProxy = false,
			}
		}
		do
			if ActorLibraryQuirks.getactorstates.FuncExists then
				local Success, States = pcall(getactorstates)
				local ReturnedInvalidStates = (
					not Success or
					typeof(States) ~= "table"
				)

				if ReturnedInvalidStates then
					ActorLibraryQuirks.getactorstates.FuncExists = false
				else
					local LuaStateProxy = next(States)

					if LuaStateProxy then
						local ProxyType = type(LuaStateProxy)

						ActorLibraryQuirks.getactorstates.ReturnsThreads = (ProxyType == "thread")
						ActorLibraryQuirks.getactorstates.ReturnsLuaStateProxy = (ProxyType == "userdata" or ProxyType == "table")
					end
				end
			end
		end

		local Hooked = false

		local GetActorStateQuirks = ActorLibraryQuirks.getactorstates
		if GetActorStateQuirks.FuncExists then
			local UseRunOnThread = GetActorStateQuirks.ReturnsThreads and run_on_thread
			local UseLuaStateProxyExecute = GetActorStateQuirks.ReturnsLuaStateProxy

			for _, LuaStateProxy in getactorstates() do
				if UseRunOnThread then
					local Success = pcall(run_on_thread, LuaStateProxy, ActorEnvironmentCode, CommunicationChannelID)
					Hooked = Hooked or Success
				elseif UseLuaStateProxyExecute then
					if not LuaStateProxy.IsActorState then continue end

					local Success = pcall(function()
						return LuaStateProxy:Execute(
							ActorEnvironmentCode,
							CommunicationChannelID,
							LuaStateProxy:GetActors()[1]
						)
					end)
					Hooked = Hooked or Success
				end
			end
		end

		if not Hooked then
			for _, Category in { getactors(), getdeletedactors and getdeletedactors() or {} } do
				for _, TargetActor in Category do
					task.spawn(HookActor, TargetActor)
				end
			end
		end

		local ActorHookConnection
		local function HandleInstance(Instance)
			if typeof(Instance) == "Instance" and not Instance:IsA("Actor") then
				return
			end

			HookActor(Instance)
		end

		if on_actor_state_created then
			ActorHookConnection = on_actor_state_created:Connect(HandleInstance)
		else
			ActorHookConnection = game.DescendantAdded:Connect(HandleInstance)
		end

		wax.shared.Connect(ActorHookConnection)
		--#endregion
	end

	--// Cleanup \\--
	return function()
		local gameMetatable = wax.shared.getrawmetatable(game)

		if wax.shared.IsUsingOthHooks then
			if Outgoing then
				pcall(oth.unhook, gameMetatable.__namecall)
			end
			if IncomingCallbacks then
				pcall(oth.unhook, gameMetatable.__newindex)
			end
		else
			if
				wax.shared.ExecutorSupport["restorefunction"].IsWorking
				and wax.shared.ExecutorSupport["hookmetamethod"].IsWorking
			then
				if Outgoing then
					pcall(restorefunction, gameMetatable.__namecall)
				end
				if IncomingCallbacks then
					pcall(restorefunction, gameMetatable.__newindex)
				end
			else
				if Outgoing then
					wax.shared.Hooking.HookMetaMethod(game, "__namecall", wax.shared.NamecallHook)
				end
				if IncomingCallbacks then
					wax.shared.Hooking.HookMetaMethod(game, "__newindex", wax.shared.NewIndexHook)
				end
			end
		end

		if IncomingCallbacks and wax.shared.RestoreCallbackDetours then
			wax.shared.RestoreCallbackDetours()
		end

		for Function, Original in wax.shared.Hooks do
			if wax.shared.IsUsingOthHooks then
				task.spawn(pcall, oth.unhook, Function)
			elseif wax.shared.ExecutorSupport["restorefunction"].IsWorking then
				task.spawn(pcall, wax.shared.restorefunction, Function)
			else
				pcall(wax.shared.Hooking.HookFunction, Function, Original)
			end
		end

		if wax.shared.ActorCommunicator then
			pcall(wax.shared.ActorCommunicator.Fire, wax.shared.ActorCommunicator, "Unload")
		end
	end
end

end)() end,
    [9] = function()local wax,script,require,CreateLookupTable=ImportGlobals(9)local ImportGlobals return (function(...)--// Variables \\--
local setfenv = setfenv
local getconnections = wax.shared.ExecutorSupport["getconnections"].IsWorking and getconnections or function() return {} end

local ClassesToHook = {
	RemoteEvent = "OnClientEvent",
	RemoteFunction = "OnClientInvoke",
	UnreliableRemoteEvent = "OnClientEvent",
	BindableEvent = "Event",
	BindableFunction = "OnInvoke",
}

local ConnectionKeys = CreateLookupTable({
	"Connect",
	"ConnectParallel",
	"connect",
	"connectParallel",
	"Once",
})

--// State \\--
local ConnectionsEnabled = false
local CallbacksEnabled = false
local ConnectionHookEnabled = false

--// Signals & Detours \\--
local LogConnectionFunctions = {}
local CallbackOwners = setmetatable({}, { __mode = "k" })
local SignalMapping = setmetatable({}, { __mode = "kv" })
local ObservedConnectionInstances = setmetatable({}, { __mode = "k" })
wax.shared.IncomingLogConnectionFunctions = LogConnectionFunctions

local CobaltObserverEnvironmentKey = "__CobaltIncomingObserver"

--// Types \\--
type InstancesToHook = RemoteEvent | UnreliableRemoteEvent | RemoteFunction | BindableEvent | BindableFunction
type MethodsToHook = "OnClientEvent" | "OnClientInvoke" | "Event" | "OnInvoke"
export type Options = {
	Connections: boolean?,
	Callbacks: boolean?,
	HookConnections: boolean?,
}

--// Functions \\--
local function GetLog(Instance: InstancesToHook, Function: (...any) -> ...any)
	local DebugId = wax.shared.GetDebugId(Instance)

	if wax.shared.ShouldIgnore(Instance, getcallingscript()) or LogConnectionFunctions[Function] then
		return nil
	end

	local IncomingLogs = wax.shared.Logs.Incoming
	if not IncomingLogs then
		return nil
	end

	local Log = IncomingLogs[DebugId]
	if not Log then
		Log = wax.shared.NewLog(Instance, "Incoming", getcallingscript(), DebugId)
	end

	return Log
end

local function ResolveCallableFunction(Value: any): ((...any) -> ...any)?
	if typeof(Value) == "function" then
		return Value
	end

	local Success, Metatable = pcall(wax.shared.getrawmetatable, Value)
	if not Success or not Metatable then
		return nil
	end

	local HasCall, Call = pcall(rawget, Metatable, "__call")
	return if HasCall and typeof(Call) == "function" then Call else nil
end

--[[
	Individually logs an incoming remote call.

	@param Instance The instance that was called.
	@param Function The function that was called, if applicable.
	@param Info The information about the call, including arguments and origin. Can be nil.
	@param ... The arguments passed from the server to the client.
	@return boolean, Log? Returns true if the call was blocked, plus the log when one was used.
]]
local function LogRemote(
	Instance: InstancesToHook,
	Function: (...any) -> ...any,
	Info: {
		Arguments: { [number]: any, n: number },
		Origin: Instance,
		Function: (...any) -> ...any,
		Line: number,
		IsExecutor: boolean,
		Blocked: boolean?,
	}
)
	local Log = GetLog(Instance, Function)
	if not Log then
		return false, nil
	end

	local ShouldBlock = Log:ShouldBlock(Info)
	local CallIndex = Log:Call(Info)
	return ShouldBlock, Log, CallIndex
end

--#region Hook Filters
local SupportsFilters = wax.shared.ExecutorSupport["FilterBase"].IsWorking

--[[
	Creates a base filter for the incoming hooks.

	@return `table` The base filter.
]]
local function CreateBaseFilter()
	local Filters = {}
	if not SupportsFilters then
		return Filters
	end

	--// allowed classnames \\--
	for ClassName in ClassesToHook do
		table.insert(Filters, InstanceTypeFilter.new(1, ClassName))
	end

	return Filters
end
--#endregion

--#region Incoming Connection Stuff
local function IsCobaltConnectionFunction(Function): boolean
	if not Function then
		return false
	end

	if LogConnectionFunctions[Function] then
		return true
	end

	local Success, Environment = pcall(getfenv, Function)
	local VerificationToken = wax.shared.CobaltVerificationToken
	return (
		Success
		and VerificationToken ~= nil
		and typeof(Environment) == "table"
		and rawequal(rawget(Environment, CobaltObserverEnvironmentKey), VerificationToken)
	)
end

--[[
	Creates a function that can be used to pass to `Connect` which will log all the incoming calls. It will additonally add the function to a ignore list (`LogConnectionFunctions`) to prevent unneccessary logging.
	
	@param Instance The instance to log.
	@param Method The method to log (e.g., "OnClientEvent").
	@return function Returns a function that logs all calls to the given instance and method.
]]
local function CreateConnectionFunction(Instance: InstancesToHook, Method: MethodsToHook)
	local CachedConnectionInfo = nil
	local CachedConnectionCount = -1

	local DebugId = wax.shared.GetDebugId(Instance)

	local ConnectionFunction = function(...)
		--// Skip if this remote is already ignored \\--
		local ExistingLog = wax.shared.Logs.Incoming[DebugId]
		if ExistingLog and ExistingLog.Ignored then
			return
		end

		local Signal = (Instance :: any)[Method]
		local Connections = getconnections(Signal)
		local ConnectionCount = #Connections

		-- Only re-analyze connections when the count changes (connect/disconnect)
		if ConnectionCount ~= CachedConnectionCount then
			CachedConnectionCount = ConnectionCount

			local Information = {
				HasValidConnections = false,
				HasForeignLuaConnections = false,
				Entries = {},
			}

			for _, Connection in Connections do
				--// Foreign State Connections \\--
				if Connection.ForeignState then
					--// It is a Lua Connection - Other Actor's Connections \\--
					if Connection.LuaConnection then
						Information.HasForeignLuaConnections = true
					end

					continue
				end

				--// Get Function \\--
				local Function = typeof(Connection.Function) == "function" and (Connection.Function) or (nil)
				if IsCobaltConnectionFunction(Function) then
					continue
				end

				Information.HasValidConnections = true

				--// Get Origin \\--
				local Thread = Connection.Thread
				local Origin = nil

				if Thread and getscriptfromthread then
					Origin = getscriptfromthread(Thread)
				end

				if not Origin and Function then
					-- ts is unreliable because people could js set the script global to nil
					-- if only debug.getinfo(Function).source or debug.info(Function, "s") returned an Instance...

					local Script = rawget(getfenv(Function), "script")
					if typeof(Script) == "Instance" then
						Origin = Script
					end
				end

				table.insert(Information.Entries, {
					Function = Function,
					Origin = Origin,
					IsExecutor = Function and isexecutorclosure(Function) or false,
				})
			end

			CachedConnectionInfo = Information
		end

		local Arguments = wax.shared.SafePack.Pack(...)
		local TargetLog, TargetCallIndex

		--// Log Remote \\--
		if CachedConnectionInfo.HasValidConnections then
			for _, Entry in CachedConnectionInfo.Entries do
				TargetLog, TargetCallIndex = select(2, LogRemote(Instance, Entry.Function, {
					Arguments = Arguments,
					Origin = Entry.Origin,
					Function = Entry.Function,
					Line = nil,
					IsExecutor = Entry.IsExecutor,
				}))
			end

		elseif not wax.shared.IS_ACTOR then
			TargetLog, TargetCallIndex = select(2, LogRemote(Instance, nil, {
				Arguments = Arguments,
				Origin = nil,
				Function = nil,
				Line = nil,
				IsExecutor = false,
			}))
		end

		local Communicator = wax.shared.ActorCommunicator
		if Communicator then
			if
				not wax.shared.IS_ACTOR
				and CachedConnectionInfo.HasForeignLuaConnections
				and TargetLog
				and TargetCallIndex
			then
				Communicator:Fire(
					"InspectIncomingConnections",
					Instance,
					Method,
					TargetLog.Index,
					TargetCallIndex
				)
			end
		end
	end

	local OriginalEnvironment = getfenv(ConnectionFunction)
	setfenv(ConnectionFunction, setmetatable({
		[CobaltObserverEnvironmentKey] = wax.shared.CobaltVerificationToken,
	}, {
		__index = OriginalEnvironment,
		__newindex = OriginalEnvironment,
	}))

	LogConnectionFunctions[ConnectionFunction] = true
	return ConnectionFunction
end
--#endregion

--#region Incoming Callback Stuff
--[[
	Handles logging for a callback.

	@param Log The log to use.
	@param Info The pending callback call information.
	@param InitialEnv The initial environment to use.
	@param InitialIdentity The initial identity to use.
	@param ... The result of the callback.

	@return The result of the callback.
]]
local function HandleCallbackLogging(Log, Info, InitialEnv, InitialIdentity, ...)
	setfenv(0, InitialEnv)
	setthreadidentity(InitialIdentity)

	if Log then
		Info.InvokeResult = wax.shared.SafePack.Pack(...)
		Log:Call(Info)
	end

	return ...
end

--[[
	Creates a function that can be used to pass to callbacks (.OnInvoke & .OnClientInvoke) which will log all the incoming calls.
	
	@param Instance The instance to log.
	@param Function The original callback of the RemoteFunction
	@return function Returns a function that logs all function calls to the given instance.
]]
local function CreateCallbackDetour(Instance: InstancesToHook, Callback: any)
	local CallbackFunction = assert(ResolveCallableFunction(Callback), "Callback is not callable")
	local Detour = function(...)
		local Origin = nil

		-- May not exist in all executors
		if getscriptfromthread then
			Origin = getscriptfromthread(coroutine.running())
		end

		-- Unreliable method to get script.
		if not Origin then
			local Script = rawget(getfenv(CallbackFunction), "script")
			if typeof(Script) == "Instance" then
				Origin = Script
			end
		end

		local FunctionCaller = debug.info(2, "f")
		local IsExecutor = if typeof(FunctionCaller) == "function"
			then isexecutorclosure(FunctionCaller)
			else isexecutorclosure(CallbackFunction)

		local Arguments = wax.shared.SafePack.Pack(...)
		local Log = GetLog(Instance, CallbackFunction)
		local Info = {
			Arguments = Arguments,
			Origin = Origin,
			Function = CallbackFunction,
			Line = nil,
			IsExecutor = IsExecutor,
			InvokeKind = "Callback",
		}
		if Log and Log:ShouldBlock(Info) then
			Log:Call(Info)
			return
		end

		local InitialEnv, InitialIdentity = getfenv(CreateCallbackDetour), getthreadidentity()
		local IsDirectFunction = rawequal(Callback, CallbackFunction)

		setthreadidentity(2)
		setfenv(0, getfenv(CallbackFunction))
		if IsDirectFunction then
			return HandleCallbackLogging(
				Log,
				Info,
				InitialEnv,
				InitialIdentity,
				CallbackFunction(...)
			)
		end

		return HandleCallbackLogging(
			Log,
			Info,
			InitialEnv,
			InitialIdentity,
			CallbackFunction(Callback, ...)
		)
	end

	if wax.shared.ExecutorSupport["setstackhidden"].IsWorking then
		setstackhidden(Detour, true)
	end

	CallbackOwners[Detour] = {
		Original = Callback,
		Method = ClassesToHook[Instance.ClassName],
		Instance = Instance
	}
	return Detour
end

local function GetOriginalScript(OriginalEnv: { [string]: any}): Instance?
	local OriginalScript = rawget(OriginalEnv, "script")
	if typeof(OriginalScript) ~= "Instance" then
		return nil
	end

	return OriginalScript
end

--[[
	Restores the callback detours for the given instances. Used for cobalt unloading.
	NOTE: Keep this in here so Actors can rely on wax.shared.RestoreCallbackDetours
]]
wax.shared.RestoreCallbackDetours = function()
	for Detour, Owner in CallbackOwners do
		local Success, CurrentCallback = pcall(getcallbackvalue, Owner.Instance, Owner.Method)
		if not (Success and rawequal(CurrentCallback, Detour)) then
			continue
		end

		pcall(function()
			if wax.shared.trampoline_call then
				local OriginalEnv = getfenv(Owner.Original)
				local OriginalScript = GetOriginalScript(OriginalEnv)

				wax.shared.trampoline_call(function()
					Owner.Instance[Owner.Method] = Owner.Original
				end, {}, {
					env = OriginalEnv,
					script = OriginalScript,
					identity = 2
				})
			else
				task.spawn(function()
					local OriginalEnv = getfenv(Owner.Original)

					setthreadidentity(2)
					setfenv(0, OriginalEnv)
					Owner.Instance[Owner.Method] = Owner.Original
				end)
			end
		end)
	end

	table.clear(CallbackOwners)
end

--#endregion

--[[
	Handles setting up logging for the appropriate instances.

	@param Instance The instance to handle.
]]
local function HandleInstance(Instance: any)
	if
		not ClassesToHook[Instance.ClassName]
		or Instance == wax.shared.Communicator
		or Instance == wax.shared.ActorCommunicator
	then
		return
	end

	local Method = ClassesToHook[Instance.ClassName]

	if ConnectionsEnabled and not ObservedConnectionInstances[Instance] then
		if Instance.ClassName == "RemoteEvent" or Instance.ClassName == "UnreliableRemoteEvent" then
			wax.shared.Connect(Instance.OnClientEvent:Connect(CreateConnectionFunction(Instance, Method)))

			SignalMapping[Instance.OnClientEvent] = Instance
			ObservedConnectionInstances[Instance] = true
		elseif Instance.ClassName == "BindableEvent" then
			wax.shared.Connect(Instance.Event:Connect(CreateConnectionFunction(Instance, Method)))

			SignalMapping[Instance.Event] = Instance
			ObservedConnectionInstances[Instance] = true
		end
	end

	if CallbacksEnabled then
		if Instance.ClassName == "RemoteFunction" or Instance.ClassName == "BindableFunction" then
			local IsCoreRemote = Instance:IsDescendantOf(wax.shared.RobloxReplicatedStorage)
			if IsCoreRemote then return end

			local Success, Callback = pcall(getcallbackvalue, Instance, Method)
			local IsCallable = ResolveCallableFunction(Callback) ~= nil

			if not Success or not IsCallable or CallbackOwners[Callback] then
				return
			end

			--// Use trampoline_call so error redirection dosent occur \\--
			if wax.shared.trampoline_call then
				local OriginalEnv = getfenv(Callback)
				local OriginalScript = GetOriginalScript(OriginalEnv)

				wax.shared.trampoline_call(function()
					Instance[Method] = CreateCallbackDetour(Instance, Callback)
				end, {}, {
					env = OriginalEnv,
					script = OriginalScript,
					identity = 2
				})
			else
				Instance[Method] = CreateCallbackDetour(Instance, Callback)
			end
		end
	end
end

--[[
	Creates a hook that intercepts .OnInvoke & .OnClientInvoke assignments and detours them to log the calls.
]]
local function SetupCallbackAssignmentHook()
	local NewIndexHookFilter = SupportsFilters and AnyFilter.new(CreateBaseFilter())
	
	wax.shared.NewIndexHook = wax.shared.Hooking.HookMetaMethod(game, "__newindex", function(...)
		local self, key, value = ...

		if typeof(self) ~= "Instance" or not ClassesToHook[self.ClassName] then
			return wax.shared.NewIndexHook(...)
		end

		if self.ClassName == "RemoteFunction" or self.ClassName == "BindableFunction" then
			local Method = ClassesToHook[self.ClassName]

			local IsCallable = ResolveCallableFunction(value) ~= nil

			if key == Method and IsCallable then
				if CallbackOwners[value] then
					return wax.shared.NewIndexHook(...)
				end

				return wax.shared.NewIndexHook(self, key, CreateCallbackDetour(self :: InstancesToHook, value))
			end
		end

		return wax.shared.NewIndexHook(...)
	end, NewIndexHookFilter)
end

--[[
	Handles logging for a connection.

	@param Method The method to log.
	@param callback The callback to log.
	@param ... The arguments to log.

	@return The result of the connection.
]]
local function HandleConnectionLogging(Instance, Method, callback, ...)
	local Log = wax.shared.Logs.Incoming[wax.shared.GetDebugId(Instance)]

	if Log and Log.Blocked then
		for _, Connection in getconnections(Instance[Method]) do
			if not Connection.ForeignState and Connection.Function ~= callback then
				continue
			end

			Connection:Disable()
		end
	end

	return ...
end

--[[
	Creates a hook that disables connections for blocked instances on creation.
]]
local function SetupConnectionAssignmentHook()
	local SignalMetatable = wax.shared.getrawmetatable(Instance.new("Part").Touched)
	wax.shared.Hooks[SignalMetatable.__index] = wax.shared.Hooking.HookFunction(SignalMetatable.__index, function(...)
		local self, key = ...

		if not wax.shared.Unloaded and ConnectionKeys[key] then
			local Instance = SignalMapping[self]
			local Connect = wax.shared.Hooks[SignalMetatable.__index](...)

			if not Instance then
				return Connect
			end

			local Method = ClassesToHook[Instance.ClassName]
			return wax.shared.newcclosure(function(...)
				local _self, callback = ...
				return HandleConnectionLogging(Instance, Method, callback, Connect(...))
			end, debug.info(Connect, "n"))
		end

		return wax.shared.Hooks[SignalMetatable.__index](...)
	end)
end

local Started = false
return function(Options: Options?)
	if Started then
		return
	end

	--// Validation \\--
	Options = Options or {}
	do
		ConnectionsEnabled = Options.Connections ~= false
		CallbacksEnabled = Options.Callbacks ~= false
		ConnectionHookEnabled = Options.HookConnections ~= false
	end

	if not ConnectionsEnabled and not CallbacksEnabled then
		return
	end

	Started = true

	--// Listeners \\--
	if CallbacksEnabled then
		if wax.shared.ExecutorSupport["setstackhidden"].IsWorking then
			setstackhidden(HandleCallbackLogging, true)
		end

		SetupCallbackAssignmentHook()
	end

	if ConnectionsEnabled and ConnectionHookEnabled then
		SetupConnectionAssignmentHook()
	end

	wax.shared.Connect(game.DescendantAdded:Connect(function(instance)
		HandleInstance(cloneref(instance))
	end))

	--// Initialization \\--
	local ClassesToSearch = {}
	do
		if ConnectionsEnabled then
			table.insert(ClassesToSearch, "RemoteEvent")
			table.insert(ClassesToSearch, "UnreliableRemoteEvent")
			table.insert(ClassesToSearch, "BindableEvent")
		end
		if CallbacksEnabled then
			table.insert(ClassesToSearch, "RemoteFunction")
			table.insert(ClassesToSearch, "BindableFunction")
		end
	end

	local Categories = {
		game:QueryDescendants(table.concat(ClassesToSearch, ", ")),
	}
	if wax.shared.ExecutorSupport["getnilinstances"].IsWorking then
		table.insert(Categories, getnilinstances())
	end

	for _, Category in Categories do
		for _, TargetInstance in next, Category do
			HandleInstance(cloneref(TargetInstance))
		end
	end
end

end)() end,
    [10] = function()local wax,script,require,CreateLookupTable=ImportGlobals(10)local ImportGlobals return (function(...)local NamecallMethods = {
	["FireServer"] = CreateLookupTable({"RemoteEvent", "UnreliableRemoteEvent"}),
	["fireServer"] = CreateLookupTable({"RemoteEvent", "UnreliableRemoteEvent"}),
	
	["InvokeServer"] = CreateLookupTable({"RemoteFunction"}),
	["invokeServer"] = CreateLookupTable({"RemoteFunction"}),

	["Fire"] = CreateLookupTable({"BindableEvent"}),
	["fire"] = CreateLookupTable({"BindableEvent"}),
	
	["Invoke"] = CreateLookupTable({"BindableFunction"}),
	["invoke"] = CreateLookupTable({"BindableFunction"}),
}
local AllowedClassNames =
	CreateLookupTable({ "RemoteEvent", "RemoteFunction", "UnreliableRemoteEvent", "BindableEvent", "BindableFunction" })

--[[
	Returns the calling function via `debug.info`

	@return `function | nil` The calling function or nil if not found.
]]
local function getcallingfunction()
	local BaseLevel = if wax.shared.IsUsingOthHooks then 3 else 5

	for i = BaseLevel, 10 do
		local Function, Source = debug.info(i, "fs")
		if not Function or not Source then
			break
		end

		if Source == "[C]" then
			continue
		end

		return Function
	end

	return debug.info(BaseLevel, "f")
end

--[[
	Returns the calling line of the script that called the function via `debug.info`

	@return number Returns the line number of the calling script.
]]
local function getcallingline()
	local BaseLevel = if wax.shared.IsUsingOthHooks then 3 else 5

	for i = BaseLevel, 10 do
		local Source, Line = debug.info(i, "sl")
		if not Source then
			break
		end

		if Source == "[C]" then
			continue
		end

		return Line
	end

	return debug.info(BaseLevel, "l")
end

--[[
	Returns the calling source of the script that called the function via `debug.info`

	@return string Returns the source of the calling script.
]]
local function getcallingsource()
	local BaseLevel = if wax.shared.IsUsingOthHooks then 3 else 5

	for i = BaseLevel, 10 do
		local Source = debug.info(i, "s")
		if not Source then
			break
		end

		if Source == "[C]" then
			continue
		end

		return Source
	end

	return debug.info(BaseLevel, "s")
end

--[[
	Gets the log for a specific instance and direction.

	@param Instance: The instance that was called.
	@param Direction: The direction of the log (Outgoing, Incoming).
	@return Log: The log for the instance and direction.
]]
local function GetLog(Instance: Instance, Direction: "Outgoing" | "Incoming")
	local DebugId = wax.shared.GetDebugId(Instance)

	local LogsInDirection = wax.shared.Logs[Direction]
	if not LogsInDirection then
		return nil
	end

	local Log = LogsInDirection[DebugId]
	if not Log then
		Log = wax.shared.NewLog(Instance, Direction, getcallingscript(), DebugId)
	end

	return Log
end

--[[
	Handles logging for a result of a remote function.
	@param Log The log to use.
	@param Arguments The arguments to use.
	@param ... The result to log.
	@return The result.
]]
local function HandleLoggingResult(Log, Info, ResultKey, ...)
	local Result = wax.shared.SafePack.Pack(...)
	Info[ResultKey] = Result
	Log:Call(Info)

	return ...
end

--[[
	Handles the logging for a specific instance and method.

	@param Instance: The instance that was called.
	@param Method: The method that was called (e.g., "OnClientEvent").
	@param ... The arguments passed from the server to the client.
]]
local function HandleLogging(TargetInstance: Instance, Method: string, OldFunction: (...any) -> ...any, ...)
	local Log = GetLog(TargetInstance, "Outgoing")
	if not Log then
		return OldFunction(...)
	end
	local Arguments = wax.shared.SafePack.Pack(select(2, ...))

	local Info = {
		Arguments = Arguments,
		Origin = getcallingscript(),
		Function = getcallingfunction(),
		Line = getcallingline(),
		Source = getcallingsource(),
		IsExecutor = checkcaller(),
	}
	local ShouldBlock = Log:ShouldBlock(Info)
	Log:Call(Info)
	if ShouldBlock then
		return
	end

	local IsRemoteFunctionInvoke = (
		TargetInstance.ClassName == "RemoteFunction" and (Method == "InvokeServer" or Method == "invokeServer")
	)

	local IsBindableFunctionInvoke = (
		TargetInstance.ClassName == "BindableFunction" and (Method == "Invoke" or Method == "invoke")
	)

	if IsRemoteFunctionInvoke or IsBindableFunctionInvoke then
		--// Handle Incoming Log \\--
		Log = GetLog(TargetInstance, "Incoming")
		local RFResultInfo = {
			Arguments = Arguments,
			InvokeResult = nil,
			Origin = getcallingscript(),
			Function = getcallingfunction(),
			Line = getcallingline(),
			Source = getcallingsource(),
			IsExecutor = checkcaller(),
			InvokeKind = "Request",
		}

		if Log:ShouldBlock(RFResultInfo) then
			Log:Call(RFResultInfo)
			return
		end

		return HandleLoggingResult(Log, RFResultInfo, "InvokeResult", OldFunction(...))
	end

	return OldFunction(...)
end

--#region Hook Filters
local SupportsFilters = wax.shared.ExecutorSupport["FilterBase"].IsWorking

--[[
	Creates a base filter for the outgoing hooks.

	@return `table` The base filter.
]]
local function CreateBaseFilter()
	local Filters = {}
	if not SupportsFilters then
		return Filters
	end

	--// ignore communicator \\--
	table.insert(Filters, NotFilter.new(ArgumentFilter.new(1, wax.shared.Communicator)))
	table.insert(Filters, NotFilter.new(ArgumentFilter.new(1, wax.shared.ActorCommunicator)))

	return Filters
end

local NamecallHookFilter = SupportsFilters and AllFilter.new((function()
	local Filters = CreateBaseFilter()

	--[[
		AllFilter:
			not communicator
			not actor communicator
			AnyFilter:
				RemoteEvent
				...
			AnyFilter:
				FireServer
				invokeServer
				...
	--]]

	--// classnames \\--
	local AnyClassNameFilters = {}
	for ClassName in AllowedClassNames do
		table.insert(AnyClassNameFilters, InstanceTypeFilter.new(1, ClassName))
	end
	
	--// methods \\--
	local AnyNamecallMethoFilters = {}
    for Method in NamecallMethods do
        table.insert(AnyNamecallMethoFilters, NamecallFilter.new(Method))
    end

	table.insert(Filters, AnyFilter.new(AnyClassNameFilters))
	table.insert(Filters, AnyFilter.new(AnyNamecallMethoFilters))
    return Filters
end)())
--#endregion

-- namecall hook
wax.shared.NamecallHook = wax.shared.Hooking.HookMetaMethod(game, "__namecall", function(...)
	local self = ...
	local Method = getnamecallmethod()

	if
		typeof(self) == "Instance"
		and AllowedClassNames[self.ClassName]
		and not rawequal(self, wax.shared.Communicator)
		and not rawequal(self, wax.shared.ActorCommunicator)
		and (NamecallMethods[Method] and NamecallMethods[Method][self.ClassName])
		and not wax.shared.ShouldIgnore(self, getcallingscript())
	then
		return HandleLogging(cloneref(self), Method, wax.shared.NamecallHook, ...)
	end

	return wax.shared.NamecallHook(...)
end, NamecallHookFilter)

-- function hooks
local FunctionsToHook
do
	local BindableFunction = Instance.new("BindableFunction")
	local BindableEvent = Instance.new("BindableEvent")

	local RemoteFunction = Instance.new("RemoteFunction")
	local RemoteEvent = Instance.new("RemoteEvent")
	local UnreliableRemoteEvent = Instance.new("UnreliableRemoteEvent")

	FunctionsToHook = {
		BindableFunction.Invoke,
		BindableEvent.Fire,

		RemoteFunction.InvokeServer,
		RemoteEvent.FireServer,
		UnreliableRemoteEvent.FireServer,
	}

	BindableFunction:Destroy()
	BindableEvent:Destroy()

	RemoteFunction:Destroy()
	RemoteEvent:Destroy()
	UnreliableRemoteEvent:Destroy()
end

local FunctionHookFilter = SupportsFilters and AllFilter.new((function()
	local Filters = CreateBaseFilter()

	--[[
		AllFilter:
			not communicator
			not actor communicator
			AnyFilter:
				RemoteEvent
				RemoteFunction
				UnreliableRemoteEvent
				BindableEvent
				BindableFunction
	--]]

	local ClassFilters = {}
	for ClassName in AllowedClassNames do
		table.insert(ClassFilters, InstanceTypeFilter.new(1, ClassName))
	end

	table.insert(Filters, AnyFilter.new(ClassFilters))
	return Filters
end)())

for _, Function in next, FunctionsToHook do
	local Method = debug.info(Function, "n")

	wax.shared.Hooks[Function] = wax.shared.Hooking.HookFunction(Function, function(...)
		local self = ...

		if
			typeof(self) == "Instance"
			and AllowedClassNames[self.ClassName]
			and not rawequal(self, wax.shared.Communicator)
			and not wax.shared.ShouldIgnore(self, getcallingscript())
		then
			return HandleLogging(cloneref(self), Method, wax.shared.Hooks[Function], ...)
		end

		return wax.shared.Hooks[Function](...)
	end, FunctionHookFilter)
end

end)() end,
    [11] = function()local wax,script,require,CreateLookupTable=ImportGlobals(11)local ImportGlobals return (function(...)--// Imports \\--
local LookupModule = require("@src/Utils/Hook/RakNet/Lookup")
local raknet = require("@src/Utils/Hook/RakNet/Wrapper")
local InvocationTracker = require(script.InvocationTracker)

return function()
	--// Initialization \\--
	LookupModule.Instance.Build()

	local Requests = {
		Incoming = InvocationTracker.new(),
		Outgoing = InvocationTracker.new(),
	}

	--// Hooks \\--
	for _, Interceptor in script.Interceptors:GetChildren() do
		require(Interceptor)(Requests)
	end

	--// Cleanup \\--
	return function()
		Requests.Incoming:Clear()
		Requests.Outgoing:Clear()

		LookupModule.Instance.Destroy()
		raknet.remove_all_hooks()
	end
end

end)() end,
    [12] = function()local wax,script,require,CreateLookupTable=ImportGlobals(12)local ImportGlobals return (function(...)local Parser = require("@src/Utils/Hook/RakNet/Variant/Parser")

local SafePack = wax.shared.SafePack

local InterceptorUtils = {}

function InterceptorUtils.GetLog(instance: Instance, direction: "Outgoing" | "Incoming")
	local debugId = wax.shared.GetDebugId(instance)
	local log = wax.shared.Logs[direction][debugId]
	if not log then
		log = wax.shared.NewLog(instance, direction, getcallingscript(), debugId)
	end

	return log
end

function InterceptorUtils.PackArguments(arguments: Parser.Arguments)
	return SafePack.Pack(SafePack.Unpack(arguments.Values, 1, arguments.Count))
end

return InterceptorUtils

end)() end,
    [14] = function()local wax,script,require,CreateLookupTable=ImportGlobals(14)local ImportGlobals return (function(...)--// Imports \\--
local raknet = require("@src/Utils/Hook/RakNet/Wrapper")
local Constants = require("@src/Utils/Hook/RakNet/Constants")
local ProcessPacket = require("@src/Spy/Hooks/RakNet/PacketProcessor")

--// Helpers \\--
local InvocationTracker = require("@src/Spy/Hooks/RakNet/InvocationTracker")
local InterceptorUtils = require("@src/Spy/Hooks/RakNet/InterceptorUtils")

--// Types \\--
type Requests = {
	Incoming: InvocationTracker.Tracker,
	Outgoing: InvocationTracker.Tracker,
}

--// Handler \\--
local function CreateHandler(Requests: Requests)
	return function(Instance: Instance, Payload: ProcessPacket.Payload): boolean
		local ShouldCapture = not wax.shared.ShouldIgnore(Instance, nil)

		if Payload.Type == "RemoteFunction" then
			local Response = Payload.Response

			--// :InvokeServer() response (Server -> Client) \\--
			local OutgoingRequest = Requests.Outgoing:Consume(Instance, Response.InvokeId)
			if OutgoingRequest then
				if OutgoingRequest.ShouldLog == false then
					return false
				end

				local Log = InterceptorUtils.GetLog(Instance, "Incoming")
				local Info = {
					Arguments = OutgoingRequest.Arguments,
					InvokeResult = InterceptorUtils.PackArguments(Response.Arguments),
					Error = Response.Error,
					Origin = nil,
					Function = nil,
					Line = nil,
					Source = nil,
					IsExecutor = nil,
					IsRakNet = true,
					InvokeKind = "Request",
				}
				local ShouldBlock = Log:ShouldBlock(Info)
				Log:Call(Info)
				if ShouldBlock then
					return true
				end

				return false
			end

			--// .OnClientInvoke request (Server -> Client) \\--
			local Log = InterceptorUtils.GetLog(Instance, "Incoming")
			local Info = {
				Arguments = InterceptorUtils.PackArguments(Response.Arguments),
				InvokeResult = nil,
				Error = Response.Error,
				Origin = nil,
				Function = nil,
				Line = nil,
				Source = nil,
				IsExecutor = nil,
				IsRakNet = true,
				InvokeKind = "Callback",
			}
			if Log:ShouldBlock(Info) then
				Log:Call(Info)
				return true
			end

			Requests.Incoming:Add(Instance, Response.InvokeId, {
				Info = Info,
				Instance = Instance,
				ShouldLog = ShouldCapture,
			})
			return false
		end

		--// Blocked RemoteEvents (Server -> Client) \\--
		--// Actual Logging is done with regular luau & getconnections because it has richer information. \\--
		if not ShouldCapture then
			return false
		end

		local Log = InterceptorUtils.GetLog(Instance, "Incoming")
		local Info = {
			Arguments = InterceptorUtils.PackArguments(Payload.Arguments),
			Origin = nil,
			Function = nil,
			Line = nil,
			Source = nil,
			IsExecutor = nil,
			IsRakNet = true,
			Omit = true
		}
		local ShouldBlock = Log:ShouldBlock(Info)
		Log:Call(Info)
		if ShouldBlock then
			return true
		end

		return false
	end
end

--// Hooks \\--
return function(Requests: Requests)
	local HandlePayload = CreateHandler(Requests)
	return raknet.add_receive_hook(Constants.PacketIds.ID_DATA, function(Message: raknet.RakNetMessage)
		ProcessPacket(Message, HandlePayload, function(Instance, InvokeId)
			return Requests.Outgoing:Has(Instance, InvokeId)
		end)
	end)
end

end)() end,
    [15] = function()local wax,script,require,CreateLookupTable=ImportGlobals(15)local ImportGlobals return (function(...)--// Imports \\--
local raknet = require("@src/Utils/Hook/RakNet/Wrapper")
local Constants = require("@src/Utils/Hook/RakNet/Constants")
local ProcessPacket = require("@src/Spy/Hooks/RakNet/PacketProcessor")

--// Helpers \\--
local InvocationTracker = require("@src/Spy/Hooks/RakNet/InvocationTracker")
local InterceptorUtils = require("@src/Spy/Hooks/RakNet/InterceptorUtils")

--// Types \\--
type Requests = {
	Incoming: InvocationTracker.Tracker,
	Outgoing: InvocationTracker.Tracker,
}

--// Handler \\--
local function CreateHandler(Requests: Requests)
	return function(Instance: Instance, Payload: ProcessPacket.Payload): boolean
		local ShouldCapture = not wax.shared.ShouldIgnore(Instance, nil)

		if Payload.Type == "RemoteFunction" then
			local Response = Payload.Response

			--// .OnClientInvoke return value (Client -> Server) \\--
			local IncomingRequest = Requests.Incoming:Consume(Instance, Response.InvokeId)
			if IncomingRequest then
				local Info = IncomingRequest.Info
				Info.InvokeResult = InterceptorUtils.PackArguments(Response.Arguments)
				Info.Error = Response.Error

				if IncomingRequest.ShouldLog then
					local Log = InterceptorUtils.GetLog(IncomingRequest.Instance, "Incoming")
					Log:Call(Info)
				end

				return false
			end

			--// :InvokeServer() request (Client -> Server) \\--
			if Requests.Outgoing:Has(Instance, Response.InvokeId) then
				return false
			end

			local Log = InterceptorUtils.GetLog(Instance, "Outgoing")
			local Info = {
				Arguments = InterceptorUtils.PackArguments(Response.Arguments),
				Error = Response.Error,
				Origin = nil,
				Function = nil,
				Line = nil,
				Source = nil,
				IsExecutor = nil,
				IsRakNet = true,
			}

			if not ShouldCapture then
				Requests.Outgoing:Add(Instance, Response.InvokeId, {
					Arguments = Info.Arguments,
					ShouldLog = false,
				})
				return false
			end

			local ShouldBlock = Log:ShouldBlock(Info)
			Log:Call(Info)
			if ShouldBlock then
				return true
			end

			Requests.Outgoing:Add(Instance, Response.InvokeId, {
				Arguments = Info.Arguments,
				ShouldLog = true,
			})
			return false
		end

		--// :FireServer() - RemoteEvent/UnreliableRemoteEvent (Client -> Server) \\--
		if not ShouldCapture then
			return false
		end

		local Log = InterceptorUtils.GetLog(Instance, "Outgoing")
		local Info = {
			Arguments = InterceptorUtils.PackArguments(Payload.Arguments),
			Origin = nil,
			Function = nil,
			Line = nil,
			Source = nil,
			IsExecutor = nil,
			IsRakNet = true,
		}
		local ShouldBlock = Log:ShouldBlock(Info)
		Log:Call(Info)
		if ShouldBlock then
			return true
		end

		return false
	end
end

--// Hooks \\--
return function(Requests: Requests)
	local HandlePayload = CreateHandler(Requests)
	return raknet.add_send_hook(Constants.PacketIds.ID_DATA, function(Message: raknet.RakNetMessage)
		ProcessPacket(Message, HandlePayload, function(Instance, InvokeId)
			return Requests.Incoming:Has(Instance, InvokeId)
		end)
	end)
end

end)() end,
    [16] = function()local wax,script,require,CreateLookupTable=ImportGlobals(16)local ImportGlobals return (function(...)local DEFAULT_TIMEOUT_SECONDS = 1500

local InvocationTracker = {}
InvocationTracker.__index = InvocationTracker

export type Tracker = typeof(setmetatable(
	{} :: {
		Entries: { [string]: { [number]: { Value: any, CreatedAt: number } } },
		TimeoutSeconds: number,
		LastPrune: number,
	},
	InvocationTracker
))

function InvocationTracker.new(timeoutSeconds: number?): Tracker
	return setmetatable({
		Entries = {},
		TimeoutSeconds = timeoutSeconds or DEFAULT_TIMEOUT_SECONDS,
		LastPrune = os.clock(),
	}, InvocationTracker)
end

function InvocationTracker.Prune(self: Tracker, now: number?)
	now = now or os.clock()
	if now - self.LastPrune < 1 then
		return
	end

	self.LastPrune = now
	for instance, entries in self.Entries do
		for invokeId, entry in entries do
			if now - entry.CreatedAt >= self.TimeoutSeconds then
				entries[invokeId] = nil
			end
		end

		if next(entries) == nil then
			self.Entries[instance] = nil
		end
	end
end

function InvocationTracker.Add(self: Tracker, instance: Instance, invokeId: number, value: any)
	self:Prune()

	local key = wax.shared.GetDebugId(instance)
	local entries = self.Entries[key]
	if not entries then
		entries = {}
		self.Entries[key] = entries
	end

	entries[invokeId] = {
		Value = value,
		CreatedAt = os.clock(),
	}
end

function InvocationTracker.Has(self: Tracker, instance: Instance, invokeId: number): boolean
	self:Prune()

	local entries = self.Entries[wax.shared.GetDebugId(instance)]
	if not entries then
		return false
	end

	local entry = entries[invokeId]
	return entry ~= nil and os.clock() - entry.CreatedAt < self.TimeoutSeconds
end

function InvocationTracker.Consume(self: Tracker, instance: Instance, invokeId: number): any?
	self:Prune()

	local key = wax.shared.GetDebugId(instance)
	local entries = self.Entries[key]
	if not entries then
		return nil
	end

	local entry = entries[invokeId]
	entries[invokeId] = nil
	if next(entries) == nil then
		self.Entries[key] = nil
	end

	if not entry or os.clock() - entry.CreatedAt >= self.TimeoutSeconds then
		return nil
	end

	return entry.Value
end

function InvocationTracker.Clear(self: Tracker)
	table.clear(self.Entries)
end

return InvocationTracker

end)() end,
    [17] = function()local wax,script,require,CreateLookupTable=ImportGlobals(17)local ImportGlobals return (function(...)--// Imports \\--
local raknet = require("@src/Utils/Hook/RakNet/Wrapper")
local Constants = require("@src/Utils/Hook/RakNet/Constants")

--// Utils \\--
local Lookup = require("@src/Utils/Hook/RakNet/Lookup")
local Codec = require("@src/Utils/Hook/RakNet/Codec")
local Parser = require("@src/Utils/Hook/RakNet/Variant/Parser")

--// Constants \\--
local ItemTypes = Constants.ItemTypes

type ByteRange = {
	Start: number,
	Finish: number,
}

export type RemoteFunctionPayload = {
	Type: "RemoteFunction",
	Response: Parser.RemoteFunctionPayload,
	Offset: number,
}

export type ArgumentsPayload = {
	Type: "Arguments",
	Arguments: Parser.Arguments,
	Offset: number,
}

export type Payload = RemoteFunctionPayload | ArgumentsPayload

type IsRemoteFunctionResponse = (Instance: Instance, InvokeId: number) -> boolean

local SupportedInstanceTypes = {
	RemoteEvent = true,
	RemoteFunction = true,
	UnreliableRemoteEvent = true,
}

local function IsInvocationItem(ItemType: number): boolean
	return ItemType == ItemTypes.ReliableEventInvocationItem
	or ItemType == ItemTypes.UnreliableEventInvocationItem
end

local function ParseItem(
	Data: buffer,
	Length: number,
	ItemStart: number,
	IsResponse: IsRemoteFunctionResponse?
)
	local Offset = ItemStart
	local ItemType = buffer.readu8(Data, Offset)
	Offset += 1

	if not IsInvocationItem(ItemType) then
		return {
			Stop = true,
			Reason = "unsupported item type",
			ItemType = ItemType,
			CurrentOffset = Offset,
		}
	end

	local InstanceRef, NextOffset = Codec.ReadInstanceRef(Data, Offset)
	Offset = NextOffset

	if InstanceRef.is_null or Offset + 2 > Length then
		return {
			Stop = true,
			Reason = if InstanceRef.is_null then "null instance reference" else "scope id exceeds packet",
			ItemType = ItemType,
			InstanceRef = InstanceRef,
			CurrentOffset = Offset,
		}
	end

	local ScopeId = buffer.readu16(Data, Offset)
	Offset += 2

	local Instance = Lookup.Instance.ByRef(InstanceRef)
	if not Instance or not SupportedInstanceTypes[Instance.ClassName] then
		return {
			Stop = true,
			Reason = "instance lookup failed",
			ItemType = ItemType,
			InstanceRef = InstanceRef,
			ScopeId = ScopeId,
			CurrentOffset = Offset,
		}
	end

	local PayloadParser = Parser.new(Data)
	local Payload: Payload
	if Instance:IsA("RemoteFunction") then
		local InvokeId = Codec.LEB128(Data, Offset)
		local Response = PayloadParser:ParseRemoteFunction(
			Offset,
			IsResponse ~= nil and IsResponse(Instance, InvokeId)
		)
		Payload = {
			Type = "RemoteFunction",
			Response = Response,
			Offset = Response.Offset,
		}
	else
		local Arguments = PayloadParser:ParseArgs(Offset)
		Payload = {
			Type = "Arguments",
			Arguments = {
				Values = Arguments.Values,
				Count = Arguments.Count,
			},
			Offset = Arguments.Offset,
		}
	end

	if Payload.Offset <= Offset or Payload.Offset > Length then
		return {
			Stop = true,
			Reason = "payload offset is invalid",
			ItemType = ItemType,
			InstanceRef = InstanceRef,
			ScopeId = ScopeId,
			Instance = Instance,
			Payload = Payload,
			PayloadStart = Offset,
			PacketLength = Length,
			CurrentOffset = Offset,
		}
	end

	return {
		ItemType = ItemType,
		InstanceRef = InstanceRef,
		ScopeId = ScopeId,
		Instance = Instance,
		Payload = Payload,
		PayloadStart = Offset,
	}
end

local function TryParseItem(
	Data: buffer,
	Length: number,
	ItemStart: number,
	IsResponse: IsRemoteFunctionResponse?
)
	local Success, Result = pcall(ParseItem, Data, Length, ItemStart, IsResponse)
	if not Success then
		return nil, {
			Stop = true,
			Reason = "item parser errored",
			Error = Result,
			CurrentOffset = ItemStart,
		}
	elseif Result.Stop then
		return nil, Result
	end

	return Result, nil
end

local function IsPlausibleBoundary(Data: buffer, Length: number, Offset: number): boolean
	if Offset >= Length then
		return true
	end

	local NextItemType = buffer.readu8(Data, Offset)
	return NextItemType == 0 or IsInvocationItem(NextItemType)
end

local function FindNextInvocation(
	Data: buffer,
	Length: number,
	StartOffset: number,
	IsResponse: IsRemoteFunctionResponse?
)
	for Candidate = StartOffset, Length - 1 do
		if not IsInvocationItem(buffer.readu8(Data, Candidate)) then
			continue
		end

		local Parsed = TryParseItem(Data, Length, Candidate, IsResponse)
		if Parsed and IsPlausibleBoundary(Data, Length, Parsed.Payload.Offset) then
			return Candidate, Parsed
		end
	end

	return nil, nil
end

local function RewriteWithoutRanges(Message: raknet.RakNetMessage, Data: buffer, Length: number, Ranges: { ByteRange })
	local RemovedLength = 0
	for _, Range in Ranges do
		RemovedLength += Range.Finish - Range.Start
	end

	local NewLength = Length - RemovedLength
	if NewLength <= 1 then
		Message:Block()
		return
	end

	local Rewritten = buffer.create(NewLength)
	local SourceOffset = 0
	local DestinationOffset = 0

	for _, Range in Ranges do
		local CopyLength = Range.Start - SourceOffset
		if CopyLength > 0 then
			buffer.copy(Rewritten, DestinationOffset, Data, SourceOffset, CopyLength)
			DestinationOffset += CopyLength
		end

		SourceOffset = Range.Finish
	end

	local RemainingLength = Length - SourceOffset
	if RemainingLength > 0 then
		buffer.copy(Rewritten, DestinationOffset, Data, SourceOffset, RemainingLength)
	end

	Message:SetData(Rewritten)
end

--// Processor \\--
return function(
	Message: raknet.RakNetMessage,
	Postprocess: (Instance: Instance, Payload: Payload, Message: raknet.RakNetMessage) -> boolean?,
	IsResponse: IsRemoteFunctionResponse?
)
	local Data = Message.AsBuffer
	local Length = buffer.len(Data)
	if Length < 2 then
		return
	end

	local BlockedRanges: { ByteRange } = {}
	local Offset = 1
	while Offset < Length do
		local ItemStart = Offset
		local Parsed, Failure = TryParseItem(Data, Length, ItemStart, IsResponse)
		if not Parsed then
			local RecoveredStart, Recovered = FindNextInvocation(Data, Length, ItemStart + 1, IsResponse)
			if RecoveredStart and Recovered then
				ItemStart = RecoveredStart
				Parsed = Recovered
			else
				break
			end
		end

		local ItemEnd = Parsed.Payload.Offset

		local ShouldBlock = Postprocess(Parsed.Instance, Parsed.Payload, Message)
		if ShouldBlock then
			table.insert(BlockedRanges, {
				Start = ItemStart,
				Finish = ItemEnd,
			})
		end

		Offset = ItemEnd
	end

	if #BlockedRanges > 0 then
		RewriteWithoutRanges(Message, Data, Length, BlockedRanges)
	end
end

end)() end,
    [20] = function()local wax,script,require,CreateLookupTable=ImportGlobals(20)local ImportGlobals return (function(...)--[[
    Bypasses for popular roblox anticheats
]]

local AnticheatData = {
	Disabled = false,
	Name = "N/A",
}

local BypassEnabled = wax.shared.SaveManager:GetState("AnticheatBypass")
if not BypassEnabled then
	return AnticheatData
end

type Bypass = {
	Name: string,
	Game: string | number | { number } | { string },
	Detect: () -> boolean,
	Bypass: () -> boolean,
}

local GeneralPurposeBypasses: { Bypass } = {}
local DedicatedPlaceACBypass: Bypass = nil

local AnticheatBypasses = script.Parent.impl
for _, Anticheat in AnticheatBypasses:GetChildren() do
	local Data = require(Anticheat) :: Bypass

	local IsDedicatedACBypass = (
		if typeof(Data.Game) == "table"
			then (table.find(Data.Game, game.PlaceId) or table.find(Data.Game, tostring(game.PlaceId)))
			else (tostring(Data.Game) == tostring(game.PlaceId))
	)

	if IsDedicatedACBypass then
		DedicatedPlaceACBypass = Data
		break
	end

	if Data.Game ~= "*" then
		continue
	end

	table.insert(GeneralPurposeBypasses, Data)
end

if DedicatedPlaceACBypass and DedicatedPlaceACBypass.Detect() then
	DedicatedPlaceACBypass.Bypass()

	AnticheatData.Name = DedicatedPlaceACBypass.Name
	AnticheatData.Disabled = true
	return AnticheatData
end

for _, Data in GeneralPurposeBypasses do
	if not Data.Detect() then
		continue
	end

	if Data.Bypass() then
		AnticheatData.Name = Data.Name
		AnticheatData.Disabled = true
		break
	end
end

return AnticheatData

end)() end,
    [22] = function()local wax,script,require,CreateLookupTable=ImportGlobals(22)local ImportGlobals return (function(...)local Adonis = {
	Name = "Adonis",
	Game = "*",
}

local AdonisAnticheatThreads = {}
function Adonis.Detect()
	if not getreg or not getgc or not isfunctionhooked then
		return false
	end

	local AdonisDetected = false

	for _, thread in getreg() do
		if typeof(thread) ~= "thread" then
			continue
		end

		local Source = debug.info(thread, 1, "s")
		if Source and (Source:match(".Core.Anti") or Source:match(".Plugins.Anti_Cheat")) then
			AdonisDetected = true
			table.insert(AdonisAnticheatThreads, thread)
		end
	end

	return AdonisDetected
end

function Adonis.Bypass()
	for _, thread in AdonisAnticheatThreads do
		pcall(coroutine.close, thread)
	end

	local AdonisTables = {}
	if filtergc then
		local ContendorAdonisTables = filtergc("table", {
			Keys = { "Detected", "RLocked" }
		}, false)

		for _, AdonisTable in ContendorAdonisTables do
			if typeof(rawget(AdonisTable, "Detected")) ~= "function" then continue end
			table.insert(AdonisTables, AdonisTable)
		end
	else
		for _, Table in getgc(true) do
			if typeof(Table) ~= "table" then
				continue
			end
	
			local IsAdonisOrigin = typeof(rawget(Table, "Detected")) == "function" and rawget(Table, "RLocked")
			if not IsAdonisOrigin then continue end

			table.insert(AdonisTables, Table)
		end
	end

	for _, Adonis in AdonisTables do
		for _, DetectionFunc in Adonis do
			-- Just in case they already loaded a custom anticheat bypass for adonis
			if typeof(DetectionFunc) ~= "function" or isfunctionhooked(DetectionFunc) then
				continue
			end

			wax.shared.Hooks[DetectionFunc] = wax.shared.Hooking.HookFunction(
				DetectionFunc,
				function(action, info, nocrash)
					coroutine.yield()
					return task.wait(9e9)
				end
			)
		end
	end

	return true
end

return Adonis

end)() end,
    [24] = function()local wax,script,require,CreateLookupTable=ImportGlobals(24)local ImportGlobals return (function(...)local Operators = wax.shared.CallFilterOperators or require("@src/Utils/CallFilter/Operators")
local InstanceSerializer = wax.shared.InstanceSerializer or require("@src/Utils/CodeGen/Serializer/Instance")
local Validation = wax.shared.Validation or require("@src/Utils/Validation")
local CallFilterSchema = wax.shared.CallFilterSchema or require("@src/Utils/CallFilter/Schema")
local RemoteFields = wax.shared.CallFilterRemoteFields or require("@src/Utils/CallFilter/RemoteFields")

local CallFilters = {
	Items = {},
	ById = {},
	Listeners = {},
}

local ActionPriorities = {
	Highlight = 1,
	Ignore = 2,
	Block = 3,
}

local function Validate(Data, DataSchema, Context: string)
	local IsValid, Result, Errors = Validation.ValidateSchema(Data, DataSchema)
	assert(IsValid, `{Context}: {Errors[1] or "validation failed"}`)
	return Result
end

local function CopyFilter(Filter)
	local Copy = table.clone(Filter)
	Copy.Conditions = {}

	for _, Condition in Filter.Conditions or {} do
		local ConditionCopy = table.clone(Condition)
		ConditionCopy.Subject = table.clone(Condition.Subject)
		table.insert(Copy.Conditions, ConditionCopy)
	end

	Copy.Target = table.clone(Filter.Target)
	if Filter.Target.Type == "Query" then
		Copy.Target.Conditions = {}
		for _, Condition in Filter.Target.Conditions do
			table.insert(Copy.Target.Conditions, table.clone(Condition))
		end
	end

	Copy.Enabled = Filter.Enabled ~= false
	return Copy
end

local function EmitChanged()
	local Snapshot = CallFilters:GetAll()
	for Listener in CallFilters.Listeners do
		if task then
			task.spawn(Listener, Snapshot)
		else
			Listener(Snapshot)
		end
	end
end

function CallFilters:GetAll()
	local Filters = {}
	for _, Filter in self.Items do
		table.insert(Filters, CopyFilter(Filter))
	end
	return Filters
end

function CallFilters:Get(Id: string)
	local Filter = self.ById[Id]
	return Filter and CopyFilter(Filter) or nil
end

function CallFilters:Add(Filter)
	local Copy = Validate(Filter, CallFilterSchema.Filter, "Invalid call filter")
	Copy.Id = Copy.Id or wax.shared.HttpService:GenerateGUID(false)
	assert(not self.ById[Copy.Id], `A call filter with id {Copy.Id} already exists`)

	table.insert(self.Items, Copy)
	self.ById[Copy.Id] = Copy
	EmitChanged()
	return CopyFilter(Copy)
end

function CallFilters:Update(Id: string, Changes)
	local Filter = self.ById[Id]
	if not Filter then
		return nil
	end

	local ValidChanges = Validate(Changes, CallFilterSchema.Update, "Invalid call filter update")
	local Updated = CopyFilter(Filter)
	for Key, Value in ValidChanges do
		Updated[Key] = Value
	end
	Updated = Validate(Updated, CallFilterSchema.Filter, "Invalid updated call filter")

	local Index = table.find(self.Items, Filter)
	if Index then
		self.Items[Index] = Updated
	end
	self.ById[Id] = Updated

	EmitChanged()
	return CopyFilter(Updated)
end

function CallFilters:SetEnabled(Id: string, Enabled: boolean)
	return self:Update(Id, { Enabled = Enabled })
end

function CallFilters:Remove(Id: string): boolean
	local Filter = self.ById[Id]
	if not Filter then
		return false
	end

	self.ById[Id] = nil
	local Index = table.find(self.Items, Filter)
	if Index then
		table.remove(self.Items, Index)
	end
	EmitChanged()
	return true
end

function CallFilters:ReplaceAll(Filters, Silent: boolean?)
	local Validated = Validate(Filters or {}, Validation.Schema.array(CallFilterSchema.Filter), "Invalid call filters")
	local SeenIds = {}
	for _, Filter in Validated do
		Filter.Id = Filter.Id or wax.shared.HttpService:GenerateGUID(false)
		assert(not SeenIds[Filter.Id], `A call filter with id {Filter.Id} already exists`)
		SeenIds[Filter.Id] = true
	end

	table.clear(self.Items)
	table.clear(self.ById)
	for _, Filter in Validated do
		table.insert(self.Items, Filter)
		self.ById[Filter.Id] = Filter
	end

	if not Silent then
		EmitChanged()
	end
end

function CallFilters:Subscribe(Listener)
	self.Listeners[Listener] = true
	Listener(self:GetAll())

	local Subscription = {}
	function Subscription:Disconnect()
		CallFilters.Listeners[Listener] = nil
	end
	return Subscription
end

function CallFilters:Match(Remote: Instance, Direction: string, Arguments)
	local WinningAction
	local WinningFilter
	local WinningPriority = 0

	for _, Filter in self.Items do
		local TargetMatches = if Filter.Target.Type == "Instance"
			then InstanceSerializer.IsEqualToInstance(Filter.Target.Remote, Remote)
			else RemoteFields.Matches(Filter.Target.Conditions, Remote)
		if
			Filter.Enabled
			and (Filter.Direction == "Any" or Filter.Direction == Direction)
			and TargetMatches
			and Operators.MatchesConditions(Filter.Conditions, Arguments)
		then
			local Priority = ActionPriorities[Filter.Action] or 0
			if Priority > WinningPriority then
				WinningAction = Filter.Action
				WinningFilter = Filter
				WinningPriority = Priority
			end
		end
	end

	return WinningAction, WinningFilter and CopyFilter(WinningFilter) or nil
end

function CallFilters:Resolve(Remote: Instance, Direction: string, Info)
	local Action, Filter = self:Match(Remote, Direction, Info.Arguments or {})
	if Action == "Highlight" then
		Info.Highlighted = true
		Info.CallFilterId = Filter.Id
	elseif Action then
		Info.CallFilterId = Filter.Id
	end
	return Action, Filter
end

return CallFilters

end)() end,
    [25] = function()local wax,script,require,CreateLookupTable=ImportGlobals(25)local ImportGlobals return (function(...)local Operators = {}

local Registry = {
	Equals = {
		Text = "==",
		AllowedTypes = { boolean = true, number = true, string = true },
		Evaluate = function(Value, Expected)
			return Value == Expected
		end,
	},
	NotEquals = {
		Text = "~=",
		AllowedTypes = { boolean = true, number = true, string = true },
		Evaluate = function(Value, Expected)
			return Value ~= Expected
		end,
	},
	LessThan = {
		Text = "<",
		NumericComparison = true,
		AllowedTypes = { number = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "number" and typeof(Expected) == "number" and Value < Expected
		end,
	},
	LessThanOrEqual = {
		Text = "<=",
		NumericComparison = true,
		AllowedTypes = { number = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "number" and typeof(Expected) == "number" and Value <= Expected
		end,
	},
	GreaterThan = {
		Text = ">",
		NumericComparison = true,
		AllowedTypes = { number = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "number" and typeof(Expected) == "number" and Value > Expected
		end,
	},
	GreaterThanOrEqual = {
		Text = ">=",
		NumericComparison = true,
		AllowedTypes = { number = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "number" and typeof(Expected) == "number" and Value >= Expected
		end,
	},
	Contains = {
		Text = "Contains",
		SummaryText = "contains",
		AllowedTypes = { string = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "string"
				and typeof(Expected) == "string"
				and string.find(Value, Expected, 1, true) ~= nil
		end,
	},
	StartsWith = {
		Text = "Starts with",
		SummaryText = "starts with",
		AllowedTypes = { string = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "string"
				and typeof(Expected) == "string"
				and string.sub(Value, 1, #Expected) == Expected
		end,
	},
	EndsWith = {
		Text = "Ends with",
		SummaryText = "ends with",
		AllowedTypes = { string = true },
		Evaluate = function(Value, Expected)
			return typeof(Value) == "string"
				and typeof(Expected) == "string"
				and (Expected == "" or string.sub(Value, -#Expected) == Expected)
		end,
	},
	TypeIs = {
		Text = "Type",
		SummaryText = "type",
		Evaluate = function(Value, Expected)
			return typeof(Value) == tostring(Expected)
		end,
	},
}

local Order = {
	"Equals",
	"NotEquals",
	"LessThan",
	"LessThanOrEqual",
	"GreaterThan",
	"GreaterThanOrEqual",
	"Contains",
	"StartsWith",
	"EndsWith",
	"TypeIs",
}

local TypeNames = {
	"nil",
	"boolean",
	"number",
	"string",
	"table",
	"function",
	"thread",
	"userdata",
	"Instance",
	"EnumItem",
	"RBXScriptSignal",
	"RBXScriptConnection",
	"Vector2",
	"Vector3",
	"CFrame",
	"Color3",
	"BrickColor",
	"UDim",
	"UDim2",
	"Rect",
	"Ray",
	"buffer",
}

local TypeNameLookup = {}
for _, TypeName in TypeNames do
	TypeNameLookup[TypeName] = true
end

local function GetSubjectKey(Subject): string
	return if Subject.Type == "ArgumentCount" then "ArgumentCount" else `Argument:{Subject.Index}`
end

local function FormatSubject(Subject): string
	return if Subject.Type == "ArgumentCount" then "#Arg" else `Arg[{Subject.Index}]`
end

local function GetAndGroupRange(Conditions, Condition)
	local ConditionIndex = table.find(Conditions, Condition)
	if not ConditionIndex then
		return 1, #Conditions
	end

	local FirstIndex = 1
	for Index = ConditionIndex, 2, -1 do
		if Conditions[Index].Join == "Or" then
			FirstIndex = Index
			break
		end
	end

	local LastIndex = #Conditions
	for Index = ConditionIndex + 1, #Conditions do
		if Conditions[Index].Join == "Or" then
			LastIndex = Index - 1
			break
		end
	end

	return FirstIndex, LastIndex
end

local function FormatValue(Value): string
	return if typeof(Value) == "string" then `"{Value}"` else tostring(Value)
end

function Operators.Get(Operator)
	return Registry[Operator]
end

function Operators.GetOptions()
	local Options = {}
	for _, Operator in Order do
		local Definition = Registry[Operator]
		table.insert(Options, {
			Value = Operator,
			Text = Definition.Text,
		})
	end
	return Options
end

function Operators.GetTypeNames()
	return table.clone(TypeNames)
end

function Operators.IsTypeName(Value): boolean
	return type(Value) == "string" and TypeNameLookup[Value] == true
end

function Operators.GetText(Operator, Summary: boolean?): string
	local Definition = Registry[Operator]
	if not Definition then
		return tostring(Operator)
	end
	return Summary and Definition.SummaryText or Definition.Text
end

function Operators.FormatValue(Value): string
	return FormatValue(Value)
end

function Operators.IsNumericComparison(Operator): boolean
	local Definition = Registry[Operator]
	return Definition ~= nil and Definition.NumericComparison == true
end

function Operators.Evaluate(Operator, Value, Expected): boolean
	local Definition = Registry[Operator]
	return Definition ~= nil and Definition.Evaluate(Value, Expected) or false
end

function Operators.ResolveSubject(Subject, Arguments)
	if Subject.Type == "ArgumentCount" then
		return Arguments.n or #Arguments
	end

	return Arguments[Subject.Index]
end

function Operators.MatchesCondition(Condition, Arguments): boolean
	return Operators.Evaluate(Condition.Operator, Operators.ResolveSubject(Condition.Subject, Arguments), Condition.Value)
end

function Operators.Matches(Conditions, ResolveValue): boolean
	if #Conditions == 0 then
		return true
	end

	local AnyGroupMatches = false
	local CurrentGroupMatches = Operators.Evaluate(
		Conditions[1].Operator,
		ResolveValue(Conditions[1]),
		Conditions[1].Value
	)
	for Index = 2, #Conditions do
		local Condition = Conditions[Index]
		local Matches = Operators.Evaluate(Condition.Operator, ResolveValue(Condition), Condition.Value)
		if Condition.Join == "Or" then
			AnyGroupMatches = AnyGroupMatches or CurrentGroupMatches
			CurrentGroupMatches = Matches
		else
			CurrentGroupMatches = CurrentGroupMatches and Matches
		end
	end

	return AnyGroupMatches or CurrentGroupMatches
end

function Operators.MatchesConditions(Conditions, Arguments): boolean
	return Operators.Matches(Conditions, function(Condition)
		return Operators.ResolveSubject(Condition.Subject, Arguments)
	end)
end

function Operators.GetConditionType(Conditions, Condition): string?
	if Condition.Subject.Type == "ArgumentCount" then
		return "number"
	end

	local SubjectKey = GetSubjectKey(Condition.Subject)
	local FirstIndex, LastIndex = GetAndGroupRange(Conditions, Condition)
	for Index = FirstIndex, LastIndex do
		local OtherCondition = Conditions[Index]
		if
			OtherCondition ~= Condition
			and GetSubjectKey(OtherCondition.Subject) == SubjectKey
			and OtherCondition.Operator == "TypeIs"
		then
			return tostring(OtherCondition.Value)
		end
	end

	if Condition.Operator == "TypeIs" then
		return tostring(Condition.Value)
	end

	local ValueType = typeof(Condition.Value)
	if ValueType == "boolean" or ValueType == "number" then
		return ValueType
	end

	for Index = FirstIndex, LastIndex do
		local OtherCondition = Conditions[Index]
		local OtherValueType = typeof(OtherCondition.Value)
		if
			OtherCondition ~= Condition
			and GetSubjectKey(OtherCondition.Subject) == SubjectKey
			and (OtherValueType == "boolean" or OtherValueType == "number")
		then
			return OtherValueType
		end
	end

	return if ValueType == "string" then "string" else nil
end

function Operators.IsAllowed(Conditions, Condition, Operator): boolean
	if Operator == "TypeIs" then
		return Condition.Subject.Type == "Argument"
	end

	local Definition = Registry[Operator]
	if not Definition then
		return false
	end

	local ConditionType = Operators.GetConditionType(Conditions, Condition)
	return ConditionType == nil or Definition.AllowedTypes[ConditionType] == true
end

function Operators.IsConditionValid(Conditions, Condition): boolean
	local Definition = Registry[Condition.Operator]
	if not Definition then
		return false
	end

	if Condition.Operator == "TypeIs" then
		return Condition.Subject.Type == "Argument" and Operators.IsTypeName(Condition.Value)
	end

	local ConditionType = Operators.GetConditionType(Conditions, Condition)
	return ConditionType ~= nil
		and Definition.AllowedTypes ~= nil
		and Definition.AllowedTypes[ConditionType] == true
		and typeof(Condition.Value) == ConditionType
end

local function NumericConditionsConflict(First, Second): boolean
	if typeof(First.Value) ~= "number" or typeof(Second.Value) ~= "number" then
		return false
	end

	if First.Operator == "Equals" and Operators.IsNumericComparison(Second.Operator) then
		return not Operators.Evaluate(Second.Operator, First.Value, Second.Value)
	elseif Second.Operator == "Equals" and Operators.IsNumericComparison(First.Operator) then
		return not Operators.Evaluate(First.Operator, Second.Value, First.Value)
	elseif not Operators.IsNumericComparison(First.Operator) or not Operators.IsNumericComparison(Second.Operator) then
		return false
	end

	local FirstIsLower = First.Operator == "GreaterThan" or First.Operator == "GreaterThanOrEqual"
	local SecondIsLower = Second.Operator == "GreaterThan" or Second.Operator == "GreaterThanOrEqual"
	if FirstIsLower == SecondIsLower then
		return false
	end

	local Lower = if FirstIsLower then First else Second
	local Upper = if FirstIsLower then Second else First
	return Lower.Value > Upper.Value
		or Lower.Value == Upper.Value and (Lower.Operator == "GreaterThan" or Upper.Operator == "LessThan")
end

local function AreInSameAndBranch(Conditions, FirstIndex: number, SecondIndex: number): boolean
	for Index = FirstIndex + 1, SecondIndex do
		if Conditions[Index].Join == "Or" then
			return false
		end
	end
	return true
end

function Operators.Validate(Conditions, Adapter)
	local Errors = {}
	local Conflicts = {}
	local GetKey = Adapter and Adapter.GetKey or function(Condition)
		return GetSubjectKey(Condition.Subject)
	end
	local GetLabel = Adapter and Adapter.GetLabel or function(Condition)
		return FormatSubject(Condition.Subject)
	end
	local IsConditionValid = Adapter and Adapter.IsConditionValid or function(Condition)
		return Operators.IsConditionValid(Conditions, Condition)
	end

	local function AddConflict(FirstIndex: number, SecondIndex: number, Message: string)
		Conflicts[FirstIndex] = true
		Conflicts[SecondIndex] = true
		table.insert(Errors, Message)
	end

	for Index, Condition in Conditions do
		if not IsConditionValid(Condition) then
			Conflicts[Index] = true
			table.insert(
				Errors,
				`{GetLabel(Condition)} has a value that is incompatible with {Operators.GetText(Condition.Operator, true)}.`
			)
		end
	end

	for FirstIndex = 1, #Conditions do
		local First = Conditions[FirstIndex]
		for SecondIndex = FirstIndex + 1, #Conditions do
			local Second = Conditions[SecondIndex]
			if Conflicts[FirstIndex] or Conflicts[SecondIndex] then
				continue
			end
			if GetKey(First) ~= GetKey(Second) or not AreInSameAndBranch(Conditions, FirstIndex, SecondIndex) then
				continue
			end
			local SubjectText = GetLabel(First)

			if First.Operator == "Equals" and Second.Operator == "Equals" and First.Value ~= Second.Value then
				AddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot equal both {FormatValue(First.Value)} and {FormatValue(Second.Value)}.`)
			elseif
				First.Operator == "Equals" and Second.Operator == "NotEquals" and First.Value == Second.Value
				or First.Operator == "NotEquals" and Second.Operator == "Equals" and First.Value == Second.Value
			then
				AddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot both equal and not equal {FormatValue(First.Value)}.`)
			elseif First.Operator == "TypeIs" and Second.Operator == "TypeIs" and First.Value ~= Second.Value then
				AddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot have both type {First.Value} and {Second.Value}.`)
			elseif NumericConditionsConflict(First, Second) then
				AddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot satisfy both numeric comparisons.`)
			else
				local TypeCondition
				local OtherCondition
				if First.Operator == "TypeIs" then
					TypeCondition, OtherCondition = First, Second
				elseif Second.Operator == "TypeIs" then
					TypeCondition, OtherCondition = Second, First
				end

				if TypeCondition and OtherCondition and OtherCondition.Operator ~= "TypeIs" then
					local Definition = Registry[OtherCondition.Operator]
					local TypeName = tostring(TypeCondition.Value)
					if Definition and Definition.AllowedTypes and not Definition.AllowedTypes[TypeName] then
						AddConflict(FirstIndex, SecondIndex, `{SubjectText} has type {TypeName}, so it cannot use {Definition.SummaryText or Definition.Text}.`)
					end
				end
			end
		end
	end

	return #Errors == 0, Errors, Conflicts
end

return Operators

end)() end,
    [26] = function()local wax,script,require,CreateLookupTable=ImportGlobals(26)local ImportGlobals return (function(...)local Operators = wax.shared.CallFilterOperators or require("@src/Utils/CallFilter/Operators")

local RemoteFields = {}

local RemoteClassOptions = {
	{ Value = "RemoteEvent", Text = "RemoteEvent" },
	{ Value = "RemoteFunction", Text = "RemoteFunction" },
	{ Value = "UnreliableRemoteEvent", Text = "UnreliableRemoteEvent" },
	{ Value = "BindableEvent", Text = "BindableEvent" },
	{ Value = "BindableFunction", Text = "BindableFunction" },
}

local Registry = {
	Name = {
		Text = "Name",
		GetValue = function(Remote)
			return Remote.Name
		end,
	},
	ClassName = {
		Text = "Class",
		ValueOptions = RemoteClassOptions,
		GetValue = function(Remote)
			return Remote.ClassName
		end,
	},
	FullName = {
		Text = "Full path",
		GetValue = function(Remote)
			local Success, Result = pcall(Remote.GetFullName, Remote)
			return Success and Result or Remote.Name
		end,
	},
}

local Order = { "Name", "ClassName", "FullName" }
local StringOperators = {
	Equals = true,
	NotEquals = true,
	Contains = true,
	StartsWith = true,
	EndsWith = true,
}

function RemoteFields.Get(Field)
	return Registry[Field]
end

function RemoteFields.GetOptions()
	local Options = {}
	for _, Field in Order do
		table.insert(Options, {
			Value = Field,
			Text = Registry[Field].Text,
		})
	end
	return Options
end

function RemoteFields.GetNames()
	return table.clone(Order)
end

function RemoteFields.GetText(Field): string
	local Definition = Registry[Field]
	return Definition and Definition.Text or tostring(Field)
end

function RemoteFields.GetValueOptions(Field)
	local Definition = Registry[Field]
	return Definition and Definition.ValueOptions and table.clone(Definition.ValueOptions) or nil
end

function RemoteFields.IsValueAllowed(Field, Value): boolean
	local Options = RemoteFields.GetValueOptions(Field)
	if not Options then
		return typeof(Value) == "string"
	end

	for _, Option in Options do
		if Option.Value == Value then
			return true
		end
	end
	return false
end

function RemoteFields.IsOperatorAllowed(Operator, Field): boolean
	if Field == "ClassName" then
		return Operator == "Equals" or Operator == "NotEquals"
	end
	return StringOperators[Operator] == true
end

function RemoteFields.IsConditionValid(Condition): boolean
	return Registry[Condition.Field] ~= nil
		and RemoteFields.IsOperatorAllowed(Condition.Operator, Condition.Field)
		and RemoteFields.IsValueAllowed(Condition.Field, Condition.Value)
end

function RemoteFields.Validate(Conditions)
	return Operators.Validate(Conditions, {
		GetKey = function(Condition)
			return Condition.Field
		end,
		GetLabel = function(Condition)
			return RemoteFields.GetText(Condition.Field)
		end,
		IsConditionValid = RemoteFields.IsConditionValid,
	})
end

function RemoteFields.Matches(Conditions, Remote): boolean
	return Operators.Matches(Conditions, function(Condition)
		local Definition = Registry[Condition.Field]
		return Definition and Definition.GetValue(Remote) or nil
	end)
end

return RemoteFields

end)() end,
    [27] = function()local wax,script,require,CreateLookupTable=ImportGlobals(27)local ImportGlobals return (function(...)--// Imports \\--
local Validation = wax.shared.Validation or require("@src/Utils/Validation")
local Operators = wax.shared.CallFilterOperators or require("@src/Utils/CallFilter/Operators")
local RemoteFields = wax.shared.CallFilterRemoteFields or require("@src/Utils/CallFilter/RemoteFields")

local Schema = Validation.Schema

--// Helpers \\--
local function GetOperatorNames()
	local Names = {}
	for _, Option in Operators.GetOptions() do
		table.insert(Names, Option.Value)
	end
	return Names
end

local function IsConditionValueValid(Condition): boolean
	return Operators.IsConditionValid({ Condition }, Condition)
end

local function HasNoConditionConflicts(Conditions): boolean
	return Operators.Validate(Conditions)
end

--// Schemas \\--
local Remote = Schema.instance():refine(function(Value)
	return RemoteFields.IsValueAllowed("ClassName", Value.ClassName)
end, "must be a supported remote")

local Subject = Schema.object({
	Type = Schema.enum({ "Argument", "ArgumentCount" }),
	Index = Schema.number():integer():min(1):optional(),
}):refine(function(Value)
	return Value.Type == "ArgumentCount" and Value.Index == nil or Value.Type == "Argument" and Value.Index ~= nil
end, "must provide an index only for argument subjects")

local Condition = Schema.object({
	Subject = Subject,
	Operator = Schema.enum(GetOperatorNames()),
	Value = Schema.any():optional(),
	Join = Schema.enum({ "And", "Or" }):optional(),
}):refine(IsConditionValueValid, "has a value that is incompatible with its operator")

local ConditionArray = Schema.array(Condition):refine(HasNoConditionConflicts, "contains conflicting conditions")
local Conditions = ConditionArray:default({})

local RemoteCondition = Schema.object({
	Field = Schema.enum(RemoteFields.GetNames()),
	Operator = Schema.enum(GetOperatorNames()),
	Value = Schema.string(),
	Join = Schema.enum({ "And", "Or" }):optional(),
}):refine(RemoteFields.IsConditionValid, "has an operator or value that is incompatible with its field")

local RemoteConditions = Schema.array(RemoteCondition):refine(function(Value)
	return #Value > 0 and RemoteFields.Validate(Value)
end, "must contain at least one non-conflicting remote condition")

local Target = Schema.union({
	Schema.object({
		Type = Schema.literal("Instance"),
		Remote = Remote,
	}),
	Schema.object({
		Type = Schema.literal("Query"),
		Conditions = RemoteConditions,
	}),
})

local Filter = Schema.object({
	Id = Schema.string():optional(),
	Enabled = Schema.boolean():default(true),
	Target = Target,
	Direction = Schema.enum({ "Outgoing", "Incoming", "Any" }),
	Conditions = Conditions,
	Action = Schema.enum({ "Ignore", "Block", "Highlight" }):default("Ignore"),
})

local Update = Schema.object({
	Enabled = Schema.boolean():optional(),
	Target = Target:optional(),
	Direction = Schema.enum({ "Outgoing", "Incoming", "Any" }):optional(),
	Conditions = ConditionArray:optional(),
	Action = Schema.enum({ "Ignore", "Block", "Highlight" }):optional(),
})

return {
	Remote = Remote,
	Subject = Subject,
	Condition = Condition,
	Conditions = Conditions,
	RemoteCondition = RemoteCondition,
	RemoteConditions = RemoteConditions,
	Target = Target,
	Filter = Filter,
	Update = Update,
}

end)() end,
    [29] = function()local wax,script,require,CreateLookupTable=ImportGlobals(29)local ImportGlobals return (function(...)--// Tables \\--
local MethodLookupTable = {
	Incoming = {
		RemoteEvent = "OnClientEvent",
		RemoteFunction = "OnClientInvoke",
		UnreliableRemoteEvent = "OnClientEvent",
		BindableEvent = "Event",
		BindableFunction = "OnInvoke",
	},
	Outgoing = {
		RemoteEvent = "FireServer",
		RemoteFunction = "InvokeServer",
		UnreliableRemoteEvent = "FireServer",
		BindableEvent = "Fire",
		BindableFunction = "Invoke",
	},

	--// Bidirectional \\--
	Bidirectional = {
		RemoteFunction = {
			Request = "InvokeServer",
			SSE = "OnClientInvoke",
		},
		BindableFunction = {
			Request = "Invoke",
			SSE = "OnInvoke",
		},
	},
}

--// Types \\--
local Types = require(script.Parent.Types)

--// Functions \\--
local function CanEventContainCallbackValue(Instance: Instance)
	return (Instance.ClassName == "RemoteFunction" or Instance.ClassName == "BindableFunction")
end

local function BuildTemplateScenario(CallInfo: Types.CallInfo, Data)
	local Method = MethodLookupTable[CallInfo.Type][CallInfo.Instance.ClassName]

	--// Handle Bidirectional Methods \\--
	local BidirectionalLookup = MethodLookupTable.Bidirectional[CallInfo.Instance.ClassName]

	if BidirectionalLookup and Data.Shape then
		Method = BidirectionalLookup[Data.Shape]
	end

	--// Build Scenario \\--
	local Scenario = {
		Type = CallInfo.Type,
		Direction = CallInfo.Type,
		Class = CallInfo.Instance.ClassName,
		Method = Method,
		InvokeKind = CallInfo.InvokeKind,
		Error = CallInfo.Error,
		IsActor = CallInfo.IsActor,
		Actor = CallInfo.Actor,
	}

	--// Merge Data \\--
	for Key, Value in Data do
		Scenario[Key] = Value
	end

	return Scenario
end

--// Classifier \\--
local Classifier = {}
Classifier.MethodLookupTable = MethodLookupTable

--[[
    Determines the scenario of a call.

	Shape:
    - Request (Client -> Server)
    - SSE (Server Sent Event)
    - Signal (Client -> Server)

    @param CallInfo: Types.CallInfo
    @return Types.Scenario
]]
function Classifier.DetermineScenario(CallInfo: Types.CallInfo): Types.Scenario
	local Type = CallInfo.Type

	--// Server -> Client \\--
	if Type == "Incoming" then
		--// RemoteFunction or BindableFunction Handling \\--
		if CanEventContainCallbackValue(CallInfo.Instance) then
			--// Does originate from :InvokeClient()/:Invoke() from Server (Server Sent Event) \\--
			if CallInfo.InvokeKind ~= "Request" then
				return BuildTemplateScenario(CallInfo, {
					Arguments = CallInfo.Arguments,
					Result = CallInfo.InvokeResult,

					Shape = "SSE",
				})
			end

			--// Does originate from :InvokeServer()/:Invoke() \\--
			return BuildTemplateScenario(CallInfo, {
				Arguments = CallInfo.Arguments,
				Result = CallInfo.InvokeResult,

				Shape = "Request",
			})
		end

		--// RemoteEvent or BindableEvent Handling \\--
		return BuildTemplateScenario(CallInfo, {
			Arguments = CallInfo.Arguments,

			Shape = "Signal",
		})
	end

	--// Client -> Server \\--
	return BuildTemplateScenario(CallInfo, {
		Arguments = CallInfo.Arguments,

		Shape = "Request",
	})
end

return Classifier

end)() end,
    [30] = function()local wax,script,require,CreateLookupTable=ImportGlobals(30)local ImportGlobals return (function(...)local Formatter = {}

--#region @export "FormatLuaLiteral"
--// Populate CleanTable \\--
Formatter.CleanTable = { ['"'] = '\\"', ["\\"] = "\\\\" }
do
	for i = 0, 31 do
		Formatter.CleanTable[string.char(i)] = "\\" .. string.format("%03d", i)
	end
	for i = 127, 255 do
		Formatter.CleanTable[string.char(i)] = "\\" .. string.format("%03d", i)
	end
end

--// Indent Template \\--
local IndentTemplate = string.rep(" ", 4)

--[[
    Formats a Lua string to be used in a Lua code block.

    @param str: The string to format.
    @return The formatted string.
]]
function Formatter.FormatLuaString(str)
	return string.gsub(str, '["\\\0-\31\127-\255]', Formatter.CleanTable)
end

--[[
    Formats a Lua literal to be used in a Lua code block.

    @param Value: The value to format.
    @return The formatted string.
]]
function Formatter.FormatLuaLiteral(Value): string?
	local ValueType = type(Value)
	if ValueType == "string" then
		return `"{Formatter.FormatLuaString(Value)}"`
	elseif ValueType == "number" or ValueType == "boolean" then
		return tostring(Value)
	end

	return nil
end
--#endregion

--[[
    Formats a Lua array to be used in a Lua code block.

    @param Values: The values to format.
    @return The formatted string.
]]
function Formatter.FormatLuaArray(Values: { any }): string
	local Serialized = {}
	for _, Value in Values do
		local Literal = Formatter.FormatLuaLiteral(Value)
		if not Literal then
			return "{}"
		end

		table.insert(Serialized, Literal)
	end

	return "{ " .. table.concat(Serialized, ", ") .. " }"
end

--[[
    Indents code

    @param Code: The code to indent.
    @param IndentLevel: The amount of indentation to add.
    @return The indented code.
]]
function Formatter.IndentCode(Code: string, IndentLevel: number)
	local Indent = IndentTemplate:rep(IndentLevel)
	local IndentedCode = Code:gsub("\n", "\n" .. Indent)
	return Indent .. IndentedCode
end

--[[
    Creates a string of arguments for a given serialized arguments.

    @param SerializedArgs: The serialized arguments.
    @param Args: The arguments.
    @param Prefix: The prefix to add to the string.
    @return The string of arguments.
]]
function Formatter.CreateArgsString(SerializedArgs: string, Args: { [number]: any, n: number }, Prefix: string?)
	if Args.n == 0 then
		return ""
	end

	--// Cyclic Table Handler \\--
	if string.sub(SerializedArgs, 1, 9) == "(function" then
		return `{Prefix == nil and "" or Prefix}table.unpack({SerializedArgs}, 1, {Args.n})`
	end

	--// Normal Table Handler \\--
	return `{Prefix == nil and "" or Prefix}{string.sub(SerializedArgs, 2, #SerializedArgs - 1)}`
end

return Formatter

end)() end,
    [31] = function()local wax,script,require,CreateLookupTable=ImportGlobals(31)local ImportGlobals return (function(...)local CodeGen = {}

local Types = require(script.Parent.Types)

wax.shared.FunctionForClasses = {
	Incoming = {
		RemoteEvent = "OnClientEvent",
		RemoteFunction = "OnClientInvoke",
		UnreliableRemoteEvent = "OnClientEvent",
		BindableEvent = "Event",
		BindableFunction = "OnInvoke",
	},

	Outgoing = {
		RemoteEvent = "FireServer",
		RemoteFunction = "InvokeServer",
		UnreliableRemoteEvent = "FireServer",
		BindableEvent = "Fire",
		BindableFunction = "Invoke",
	},
}

local Formatter = require(script.Parent.Formatter)

local InstanceSerializer = require(script.Parent.Serializer.Instance)
local Renderer = require(script.Parent.Renderer)
local Classifier = require(script.Parent.Classifier)

--[[

    Invokes plugin handlers for a given type.

    @param Type: The type of plugin handler to invoke.
    @param ShouldUseResult: Returns whether a plugin result should replace the default codegen output.
    @param ...: The arguments to pass to the plugin handler.
    @return:
		- ShouldContinue: Whether to continue the default behavior.
		- Results: The results of the plugin handlers.
]]
local function InvokePluginHandlers(Type: "Hook" | "Call", ShouldUseResult: (...any) -> boolean, ...)
	local PluginManager = wax.shared.CobaltPluginManager
	if not PluginManager or not PluginManager.HasCodeGenInterceptors then
		return true, nil
	end
	
	local InterceptorRegistry = PluginManager.Registry.UIHooks.CodeGen[Type] or {}

	for _, Interceptor in InterceptorRegistry do
		local Results = wax.shared.SafePack.Pack(
			xpcall(Interceptor, function(Error)
				warn(`Error in Cobalt Plugin (CodeGen Interceptor ({Type})):`, Error)
				return Error
			end, ...)
		)

		local Success = Results[1]
		if not Success then continue end

		if ShouldUseResult(wax.shared.SafePack.Unpack(Results, 2, Results.n)) then
			return false, wax.shared.SafePack.Unpack(Results, 2, Results.n)
		end
	end

	return true, nil
end

CodeGen.GetFullPath = InstanceSerializer.Serialize

local CodeGenHeaderTemplate = [[-- This code was generated by Cobalt
-- https://gitlab.com/upio/cobalt

]]

local CodeGenHeaderRakNetTemplate = [[-- This code was generated by Cobalt
-- https://gitlab.com/upio/cobalt

-- Code derived from RakNet packets. Some outputs may be incorrect.

]]

local function CountValues(Values)
	if type(Values) ~= "table" then
		return "N/A"
	end

	return tostring(#Values)
end

local function CountDebugValues(DebugFunction, TargetFunction)
	if not DebugFunction then
		return "N/A"
	end

	local Success, Values = pcall(DebugFunction, TargetFunction)
	if not Success then
		return "N/A"
	end

	return CountValues(Values)
end

--[[
    Builds the code gen header.

    @return The code gen header.
]]
local function BuildCodeGenHeader(): string
	if not wax.shared.SaveManager:GetState("ShowWatermark") then
		return ""
	end

	if wax.shared.IsUsingRakNetHooks then
		return CodeGenHeaderRakNetTemplate
	end

	return CodeGenHeaderTemplate
end

--[[
    Builds hook code for a call info.

    @param CallInfo: The call info.
    @return The hook code.
]]
function CodeGen:BuildHookCode(CallInfo: Types.CallInfo)
	local InterceptedByPlugin, InterceptedCode = InvokePluginHandlers("Hook", function(InterceptedCode)
		return type(InterceptedCode) == "string"
	end, CallInfo)

	if not InterceptedByPlugin then
		return InterceptedCode
	end

	--// Determine Scenario \\--
	local Scenario = Classifier.DetermineScenario(CallInfo)

	--// Resolve Template \\--
	local Template = Renderer.ResolveTemplate("Hook", Scenario)
	local Variables = Renderer.DeriveVariables("Hook", {
		Scenario = Scenario,
		CallInfo = CallInfo,
	})

	--// Build Code \\--
	local Code = Renderer.Render({
		Code = Template,
		Args = Variables,
		
		CallInfo = CallInfo,
	})
	return BuildCodeGenHeader() .. Code
end

function CodeGen:BuildCallCode(CallInfo: Types.CallInfo)
	local InterceptedByPlugin, InterceptedCode = InvokePluginHandlers("Call", function(InterceptedCode)
		return type(InterceptedCode) == "string"
	end, CallInfo)

	if not InterceptedByPlugin then
		return InterceptedCode
	end

	--// Determine Scenario \\--
	local Scenario = Classifier.DetermineScenario(CallInfo)

	--// Resolve Template \\--
	local Template = Renderer.ResolveTemplate("Call", Scenario)
	local Variables = Renderer.DeriveVariables("Call", {
		Scenario = Scenario,
		CallInfo = CallInfo,
	})

	--// Build Code \\--
	local Code = Renderer.Render({
		Code = Template,
		Args = Variables,
	})
	return BuildCodeGenHeader() .. Code
end

function CodeGen:BuildFunctionInfo(CallInfo: Types.CallInfo)
	local Info = {}

	if not CallInfo.Function then
		Info["Function Address"] = "N/A"
		Info["Name"] = "N/A"
		Info["Script Path"] = (
			CallInfo.Origin and
				InstanceSerializer.Serialize(CallInfo.Origin, { DisableNilParentHandler = true })
			or wax.shared.ExecutorName
		)
		
		Info["Source"] = CallInfo.Source or "N/A"
		Info["Calling Line"] = CallInfo.Line or "N/A"
		
		if CallInfo.IsActor then
			Info["Origin Actor"] = CallInfo.Actor and InstanceSerializer.Serialize(CallInfo.Actor, { DisableNilParentHandler = true }) or "N/A"
		end
		
		Info["Closure Type"] = "N/A"
		Info["Constants"] = "N/A"
		Info["Upvalues"] = "N/A"
		Info["Protos"] = "N/A"
	elseif typeof(CallInfo.Function) == "table" then
		local Function = CallInfo.Function

		Info["Function Address"] = Function.Address and Function.Address:match("0x%x+") or tostring(Function)
		Info["Name"] = Function.Name ~= "" and Function.Name or "Anonymous"
		Info["Script Path"] = (
			CallInfo.Origin and
				InstanceSerializer.Serialize(CallInfo.Origin, { DisableNilParentHandler = true })
			or wax.shared.ExecutorName
		)

		Info["Source"] = Function.Source or "N/A"
		Info["Calling Line"] = CallInfo.Line or "N/A"
		if CallInfo.IsActor then
			Info["Origin Actor"] = CallInfo.Actor and InstanceSerializer.Serialize(CallInfo.Actor, { DisableNilParentHandler = true }) or "N/A"
		end

		if Function.IsC then
			Info["Closure Type"] = "C closure"
		else
			Info["Closure Type"] = "Luau closure"
			Info["Constants"] = debug.getconstants and Function.Constants or "N/A"
			Info["Upvalues"] = debug.getupvalues and Function.Upvalues or "N/A"
			Info["Protos"] = debug.getprotos and Function.Protos or "N/A"
		end
	else
		local FunctionName = debug.info(CallInfo.Function, "n")

		Info["Function Address"] = tostring(CallInfo.Function):match("0x%x+") or tostring(CallInfo.Function)
		Info["Name"] = FunctionName ~= "" and FunctionName or "Anonymous"
		Info["Script Path"] = CallInfo.Origin
				and InstanceSerializer.Serialize(CallInfo.Origin, { DisableNilParentHandler = true })
			or wax.shared.ExecutorName
		Info["Source"] = CallInfo.Source or debug.info(CallInfo.Function, "s") or "N/A"
		Info["Calling Line"] = tostring(CallInfo.Line)
		if CallInfo.IsActor then
			Info["Origin Actor"] = CallInfo.Actor and InstanceSerializer.Serialize(CallInfo.Actor, { DisableNilParentHandler = true }) or "N/A"
		end

		if iscclosure(CallInfo.Function) then
			Info["Closure Type"] = "C closure"
		else
			Info["Closure Type"] = "Luau closure"
			Info["Constants"] = CountDebugValues(debug.getconstants, CallInfo.Function)
			Info["Upvalues"] = CountDebugValues(debug.getupvalues, CallInfo.Function)
			Info["Protos"] = CountDebugValues(debug.getprotos, CallInfo.Function)
		end
	end

	local InfoLines = {}
	for _, Key in
		{
			"Function Address",
			"Name",
			"Script Path",
			"Source",
			"Calling Line",
			"Origin Actor",
			"Closure Type",
			"Constants",
			"Upvalues",
			"Protos",
		}
	do
		local Value = Info[Key]
		if Value ~= nil then
			table.insert(InfoLines, string.format("<b>%s:</b> %s", Key, tostring(Value)))
		end
	end

	return table.concat(InfoLines, "\n")
end

function CodeGen:ReplayCallInfo(CallInfo: Types.CallInfo)
	local Scenario = Classifier.DetermineScenario(CallInfo)
	local Method = Scenario.Method
	local Arguments = Scenario.Arguments
	local TargetInstance = CallInfo.Instance :: Instance
	local SafeUnpack = wax.shared.SafePack.Unpack

	if Scenario.Type == "Incoming" then
		--// RemoteEvent/BindableEvent Signal \\--
		if Scenario.Shape == "Signal" then
			assert(firesignal or getconnections, "No firesignal or getconnections found")

			if firesignal then
				firesignal(TargetInstance[Method], SafeUnpack(Arguments, 1, Arguments.n))
			elseif getconnections then
				for _, conn in getconnections(TargetInstance[Method]) do
					conn:Fire(SafeUnpack(Arguments, 1, Arguments.n))
				end
			end

			return
		end

		--// RemoteFunction/BindableFunction SSE \\--
		if Scenario.Shape == "SSE" then
			local Callback = getcallbackvalue(TargetInstance, Method)

			if not Callback then
				return
			end

			task.spawn(function()
				local task_spawn = task.spawn
				
				setthreadidentity(2)
				setfenv(0, getfenv(Callback))
				task_spawn(Callback, SafeUnpack(Arguments, 1, Arguments.n))
			end)
			return
		end
	end

	task.spawn(function()
		TargetInstance[Method](TargetInstance, SafeUnpack(Arguments, 1, Arguments.n))
	end)
end

return CodeGen

end)() end,
    [32] = function()local wax,script,require,CreateLookupTable=ImportGlobals(32)local ImportGlobals return (function(...)local Renderer = {}

local Types = require(script.Parent.Types)

local Formatter = require(script.Parent.Formatter)

local Templates = {}
do
	Templates.Call = require(script.Parent.Templates.Call)
	Templates.Hook = require(script.Parent.Templates.Hook)
	Templates.Actor = require(script.Parent.Templates.Actor)
end

local ReferencingTemplate = require(script.Parent.Templates.Referencing)
local GetNilCode = ReferencingTemplate.GetNilCode

local InstanceSerializer = require(script.Parent.Serializer.Instance)
local ResolveEventPath
do
	--#region @export "FindEventReferenceInTable"
	--[[
		Finds an event reference in a table, used to search upvalues which are tables.

		@param Table: The table to search.
		@param Instance: The instance to search for.
		@param Visited: The visited table.
		@return The event reference.
	]]
	local function FindEventReferenceInTable(
		Table: { [any]: any },
		Instance: Instance,
		Visited: { [any]: boolean }?
	): { any }?
		local Seen = Visited or {}
		if Seen[Table] then
			return nil
		end

		Seen[Table] = true

		for Key, Value in next, Table do
			if
				typeof(Value) == "Instance"
				and InstanceSerializer.IsEqualToInstance(Value, Instance)
				and Formatter.FormatLuaLiteral(Key)
			then
				return { Key }
			end

			if type(Value) == "table" and Formatter.FormatLuaLiteral(Key) then
				local ChildPath = FindEventReferenceInTable(Value, Instance, Seen)
				if ChildPath then
					table.insert(ChildPath, 1, Key)
					return ChildPath
				end
			end
		end

		return nil
	end
	--#endregion

	--#region @export "ResolveEventReference"
	--[[
		Resolves an event reference from a call info.

		@param CallInfo: The call info.
		@return The event reference.
	]]
	local function ResolveEventReference(
		CallInfo: Types.CallInfo
	): { Hash: string, Index: number, ExcludeExecutor: boolean?, Path: { any }? }?
		if wax.shared.SaveManager:GetState("EventReferenceStrategy") ~= "Upvalue Lookup" then
			return nil
		end

		if (CallInfo.IsActor == true or CallInfo.Actor ~= nil) and typeof(CallInfo.Function) == "table" then
			-- local FunctionHash = CallInfo.Function.FunctionHash
			-- local Upvalues = CallInfo.Function.Upvalues

			-- if FunctionHash and type(Upvalues) == "table" then
			-- 	local UpvaluePath = FindEventReferenceInTable(Upvalues, CallInfo.Instance)
			-- 	if not UpvaluePath then
			-- 		return nil
			-- 	end

			-- 	local UpvalueIndex = table.remove(UpvaluePath, 1)
			-- 	return {
			-- 		Hash = FunctionHash,
			-- 		Index = UpvalueIndex,
			-- 		Path = UpvaluePath,
			-- 		ExcludeExecutor = true,
			-- 	}
			-- end

			local RequestId = tick()
			local Thread = coroutine.running()
			local Response = nil
			wax.shared.Communicator:Fire("ResolveEventReference", getfunctionhash(CallInfo.Function), CallInfo.Instance, CallInfo.IsExecutor ~= true, RequestId)

			local ResponseConnection
			ResponseConnection = wax.shared.Communicator.Event:Connect(function(Type, ...)
				if Type ~= "ResolveEventReferenceResponse" then
					return
				end

				local ResolvedRequestId, ResolvedResponse = ...
				if ResolvedRequestId == RequestId then
					ResponseConnection:Disconnect()
					Response = ResolvedResponse
					coroutine.resume(Thread)
				end
			end)

			coroutine.yield()
			if not Response then
				return nil
			end

			return {
				Hash = Response.Hash,
				Index = Response.Index,
				Path = Response.Path,
				ExcludeExecutor = CallInfo.IsExecutor ~= true,
			}
		end

		if
			typeof(CallInfo.Function) ~= "function"
			or not islclosure
			or not islclosure(CallInfo.Function)
			or not getfunctionhash
		then
			return nil
		end

		local UpvaluePath = FindEventReferenceInTable(debug.getupvalues(CallInfo.Function), CallInfo.Instance)
		if not UpvaluePath then
			return nil
		end

		local UpvalueIndex = table.remove(UpvaluePath, 1)
		return {
			Hash = getfunctionhash(CallInfo.Function),
			Index = UpvalueIndex,
			Path = UpvaluePath,
			ExcludeExecutor = CallInfo.IsExecutor ~= true,
		}
	end
	--#endregion

	ResolveEventPath = function(CallInfo: Types.CallInfo): (string, string?)
		return InstanceSerializer.Serialize(CallInfo.Instance, {
			VariableName = "Event",
			DisableNilParentHandler = false,
			OmitNilFunctionGetterCodeGeneration = true,
			EventReference = ResolveEventReference(CallInfo),
		})
	end
end

--[[
    Renders a code string with the given arguments.

    @param Code: The code string to render.
    @param Args: The arguments to render the code with.
    @return The rendered code string.
]]
local function RenderCode(Code: string, Args: { [string]: any })
	local RenderedCode = Code:gsub("{{%s*([%w_]+)%s*}}", function(Key)
		local Value = Args[Key]
		assert(Value ~= nil, `Missing CodeGen template variable: {Key}`)
		return tostring(Value)
	end)
	return RenderedCode
end

--[[
    Renders a code string with the given arguments.

    @param Code: The code string to render.
    @param Args: The arguments to render the code with.
    @return The rendered code string.
]]
function Renderer.Render(Data: {
	Code: string,
	Args: { [string]: any },

	CallInfo: Types.CallInfo?,
})
	local RenderedCode = RenderCode(Data.Code, Data.Args)

	if Data.CallInfo and Data.CallInfo.IsActor then
		local TemplateToUse = Templates.Actor.TargetedWrapper
		if not Data.CallInfo.Actor then
			TemplateToUse = Templates.Actor.GenericWrapper
		end

		local Args = {
			Prelude = "-- Event originated from an Actor Environment",
			Actor = "",

			IndentedCode = Formatter.IndentCode(RenderedCode, TemplateToUse.IndentLevel),
		}

		if Data.CallInfo.Actor then
			local Actor, ActorPrelude = InstanceSerializer.Serialize(Data.CallInfo.Actor, {
				OmitNilFunctionGetterCodeGeneration = true,
				DisableNilParentHandler = false,
			})

			Args.Prelude = ActorPrelude and `{Args.Prelude}\n{ActorPrelude}\n\n` or Args.Prelude
			Args.Actor = Actor or ""
		end

		RenderedCode = RenderCode(TemplateToUse.Text, Args)
	end

	return RenderedCode
end

--[[
	Resolves the template string based on the scenario.

	@param Context: The context to resolve the template for.
	@param Scenario: The scenario to resolve the template for.
	@return The resolved template string.
]]
function Renderer.ResolveTemplate(Context: "Call" | "Hook", Scenario: Types.Scenario)
	local TemplateContext = Templates[Context]

	if Scenario.Type == "Outgoing" then
		return TemplateContext.Outgoing
	end

	local Template = TemplateContext.Incoming[Scenario.Shape]
	if type(Template) == "table" then
		return Template[Scenario.InvokeKind] or Template.Default
	end

	return Template
end

--[[
	Derives the variables for a given scenario and call info.

	@param Scenario: The scenario to derive the variables for.
	@param CallInfo: The call info to derive the variables for.
	@return The derived variables.
]]
function Renderer.DeriveVariables(
	Context: "Call" | "Hook",
	Data: {
		Scenario: Types.Scenario,
		CallInfo: Types.CallInfo,
	}
): { [string]: any }
	local Preludes = {}
	local PreludeLookup = {}

	local function AddPrelude(Code: string?)
		if not Code or PreludeLookup[Code] then
			return
		end

		table.insert(Preludes, Code)
		PreludeLookup[Code] = true
	end

	local EventPath, EventPrelude = ResolveEventPath(Data.CallInfo)
	AddPrelude(EventPrelude)

	local Variables = {
		Prelude = "",
		Path = EventPath,
		Method = Data.Scenario.Method,
	}

	if Context == "Call" then
		local SerializedArgs, ArgsRequiresNilHandler = wax.shared.LuaEncode(Data.Scenario.Arguments, {
			Prettify = true,
			InsertCycles = true,
			IsArray = true,
		})

		local ExpectedResult, ExpectedResultRequiresNilHandler = nil, false
		local HasError = Data.Scenario.Error ~= nil and Data.CallInfo.Blocked ~= true
		if HasError then
			Variables.CapturePrefix = "local Success, ResultOrError = pcall(function()\n\treturn table.pack("
			Variables.CaptureSuffix = ")\nend)"
		else
			Variables.CapturePrefix = "local Result = table.pack("
			Variables.CaptureSuffix = ")"
		end

		--// Handle Invoke Result \\--
		local HasInvokeResult = (Data.Scenario.Result ~= nil and Data.CallInfo.Blocked ~= true and not HasError)
		if HasInvokeResult then
			ExpectedResult, ExpectedResultRequiresNilHandler = wax.shared.LuaEncode(Data.Scenario.Result, {
				Prettify = true,
				InsertCycles = true,
				IsArray = true,
			})

			Variables.ExpectedResultCode = "\n\nlocal ExpectedResult = table.unpack(" .. ExpectedResult .. ")\n"
		else
			Variables.ExpectedResultCode = if HasError
				then `\n\nlocal ExpectedSuccess = false\nlocal ExpectedError = {Formatter.FormatLuaLiteral(
					tostring(Data.Scenario.Error)
				)}\n`
				else "\n"
		end

		if ArgsRequiresNilHandler or ExpectedResultRequiresNilHandler then
			AddPrelude(GetNilCode)
		end

		--// Add Variables \\--
		Variables.Args = Formatter.CreateArgsString(SerializedArgs, Data.Scenario.Arguments)
		if HasError then
			Variables.Args = Variables.Args:gsub("\n", "\n\t")
		end
		Variables.ArgsWithLeadingComma = Formatter.CreateArgsString(SerializedArgs, Data.Scenario.Arguments, ", ")
	end

	if #Preludes > 0 then
		Variables.Prelude = table.concat(Preludes, "\n\n") .. "\n\n"
	end

	return Variables
end

return Renderer

end)() end,
    [34] = function()local wax,script,require,CreateLookupTable=ImportGlobals(34)local ImportGlobals return (function(...)local InstanceSerializer = {}

local Formatter = require(script.Parent.Parent.Formatter)
local ReferencingTemplate = require(script.Parent.Parent.Templates.Referencing)

local GetNilCode = ReferencingTemplate.GetNilCode
local GetEventReferenceCode = ReferencingTemplate.GetEventReferenceCode

--#region @export "IsEqualToInstance"
--[[
    Checks if two instances are equal.

    @param Object: The first instance.
    @param ToCompareTo: The second instance.
    @return Whether the instances are equal.
]]
local function IsEqualToInstance(Object, ToCompareTo)
	if typeof(Object) ~= "Instance" or typeof(ToCompareTo) ~= "Instance" then return false end

	if rawequal(Object, ToCompareTo) then
		return true
	end

	if wax.shared.ExecutorSupport["compareinstances"].IsWorking then
		return compareinstances(Object, ToCompareTo)
	end

	local ObjectDebugId, ToCompareToDebugId, ShouldCompareDebugIds = nil, nil, false
	do
		local Success, ObjectDebugIdResult = pcall(wax.shared.GetDebugId, Object)
		local Success2, ToCompareToDebugIdResult = pcall(wax.shared.GetDebugId, ToCompareTo)

		if Success and Success2 then
			ObjectDebugId = ObjectDebugIdResult
			ToCompareToDebugId = ToCompareToDebugIdResult
			ShouldCompareDebugIds = true
		end
	end

	if ShouldCompareDebugIds then
		return ObjectDebugId == ToCompareToDebugId
	end

	return false
end
--#endregion

--[[

    Invokes plugin handlers for a given type.

    @param Type: The type of plugin handler to invoke.
    @param ShouldUseResult: Returns whether a plugin result should replace the default codegen output.
    @param ...: The arguments to pass to the plugin handler.
    @return:
		- ShouldContinue: Whether to continue the default behavior.
		- Results: The results of the plugin handlers.
]]
local function InvokePluginHandlers(ShouldUseResult: (...any) -> boolean, ...)
	local PluginManager = wax.shared.CobaltPluginManager
	if PluginManager and PluginManager.HasCodeGenInterceptors then
		local Interceptors = PluginManager.Registry.UIHooks.CodeGen.InstancePath

		for _, Interceptor in Interceptors or {} do
			local Results = table.pack(pcall(Interceptor, ...))
			local Success = Results[1]

			if Success then
				local ReturnValues = table.pack(table.unpack(Results, 2, Results.n))
				if ShouldUseResult(table.unpack(ReturnValues, 1, ReturnValues.n)) then
					return false, ReturnValues
				end
			else
				warn(
					`Error in Cobalt Plugin (CodeGen Interceptor (InstancePath)):`,
					table.unpack(Results, 2, Results.n)
				)
			end
		end
	end

	return true, nil
end

--[[
    Serializes an instance path to a string.

    @param Object: The instance to serialize.
    @param options: The options to use for serialization.
    @return The serialized path.
]]
function InstanceSerializer.Serialize(
	Object,
	options: {
		DisableNilParentHandler: boolean?,
		VariableName: string?,
		OmitNilFunctionGetterCodeGeneration: boolean?,
		IgnorePlugins: boolean?,
		EventReference: {
			Hash: string,
			Index: number,
			ExcludeExecutor: boolean?,
			Path: { any }?,
		}?,
	}?
)
	local DisableNilParentHandler = options and options.DisableNilParentHandler
	local OmitNilFunctionGetterCodeGeneration = options and options.OmitNilFunctionGetterCodeGeneration
	local VariableName = options and options.VariableName
	local IgnorePlugins = options and options.IgnorePlugins
	local EventReference = options and options.EventReference
	do
		if DisableNilParentHandler == nil then
			DisableNilParentHandler = true
		end

		if OmitNilFunctionGetterCodeGeneration == nil then
			OmitNilFunctionGetterCodeGeneration = false
		end
	end

	if not IgnorePlugins then
		local ShouldContinue, Results = InvokePluginHandlers(function(InterceptedCode)
			return type(InterceptedCode) == "string"
		end, Object, options)

		if not ShouldContinue then
			return Results[1]
		end
	end

	local ChildLookupMode = wax.shared.SaveManager:GetState("InstancePathLookupChain")
	local NilEventReferenceStrategy = wax.shared.SaveManager:GetState("EventReferenceStrategy")

	local function BuildDynamicAccessor(Expression: string): string
		if ChildLookupMode == "WaitForChild" then
			return ":WaitForChild(" .. Expression .. ")"
		elseif ChildLookupMode == "FindFirstChild" then
			return ":FindFirstChild(" .. Expression .. ")"
		end

		return "[" .. Expression .. "]"
	end

	local function BuildStaticAccessor(Name: string): string
		local SanitizedName = Formatter.FormatLuaString(Name)

		if ChildLookupMode == "WaitForChild" then
			return ':WaitForChild("' .. SanitizedName .. '")'
		elseif ChildLookupMode == "FindFirstChild" then
			return ':FindFirstChild("' .. SanitizedName .. '")'
		elseif string.match(Name, "^[%a_][%w_]*$") then
			return "." .. Name
		end

		return '["' .. SanitizedName .. '"]'
	end

	local CurrentObject = Object
	local IsNil = false
	local Path = ""
	local RequiredPrelude = nil

	repeat
		if typeof(CurrentObject) ~= "Instance" then
			break
		end

		if IsEqualToInstance(CurrentObject, game) then
			Path = "game" .. Path
			break
		end

		local IndexName = ""

		if IsEqualToInstance(CurrentObject, wax.shared.LocalPlayer) then
			IndexName = ".LocalPlayer"
		elseif
			wax.shared.LocalPlayer.Character and IsEqualToInstance(CurrentObject, wax.shared.LocalPlayer.Character)
		then
			Path = 'game:GetService("Players").LocalPlayer.Character' .. Path
			break
		elseif CurrentObject.Name and CurrentObject.Name == wax.shared.LocalPlayer.Name then
			IndexName = BuildDynamicAccessor('game:GetService("Players").LocalPlayer.Name')
		elseif CurrentObject.Name and CurrentObject.Name == tostring(wax.shared.LocalPlayer.UserId) then
			IndexName = BuildDynamicAccessor('game:GetService("Players").LocalPlayer.UserId')
		elseif IsEqualToInstance(CurrentObject, workspace) then
			Path = "workspace" .. Path
			break
		elseif CurrentObject.ClassName and CurrentObject.Name then
			IndexName = BuildStaticAccessor(CurrentObject.Name)

			local Parent = CurrentObject.Parent
			if Parent then
				local DirectChildPtr = Parent:FindFirstChild(CurrentObject.Name)
				local IsService = false

				if IsEqualToInstance(Parent, game) then
					local Success, Service = pcall(game.FindService, game, CurrentObject.ClassName)
					IsService = Success and IsEqualToInstance(Service, CurrentObject)
				end

				if IsService then
					IndexName = ':GetService("' .. CurrentObject.ClassName .. '")'
				elseif DirectChildPtr then
					local Children = Parent:GetChildren()
					local FoundIndex = nil

					if
						wax.shared.ExecutorSupport["compareinstances"].IsWorking
						and not compareinstances(DirectChildPtr, CurrentObject)
					then
						for Index, Child in Children do
							if not compareinstances(Child, CurrentObject) then
								continue
							end

							FoundIndex = Index
							break
						end
					elseif DirectChildPtr ~= CurrentObject then
						FoundIndex = table.find(Children, CurrentObject)
					end

					if FoundIndex then
						IndexName = ":GetChildren()[" .. tostring(FoundIndex) .. "]"
					end
				end
			elseif Parent == nil then
				IsNil = true

				if DisableNilParentHandler then
					Path = Path .. " --[[Nil Parent]]"
				else
					local Base = `GetNil("{Formatter.FormatLuaString(CurrentObject.Name)}", "{Formatter.FormatLuaString(
						CurrentObject:GetDebugId()
					)}")`
					local GetterCode = GetNilCode
					RequiredPrelude = GetterCode

					if NilEventReferenceStrategy == "Upvalue Lookup" and EventReference then
						local EventReferenceCall = {
							"GetEventReference({",
							Formatter.IndentCode(`Hash = "{Formatter.FormatLuaString(EventReference.Hash)}",`, 1),
							Formatter.IndentCode(
								`ExcludeExecutor = {EventReference.ExcludeExecutor == true and "true" or "false"},`,
								1
							),
							Formatter.IndentCode(`Index = {tostring(EventReference.Index)},`, 1),
						}

						if EventReference.Path and #EventReference.Path > 0 then
							table.insert(
								EventReferenceCall,
								Formatter.IndentCode(`Path = {Formatter.FormatLuaArray(EventReference.Path)},`, 1)
							)
						end

						table.insert(EventReferenceCall, "})\n")
						Base = table.concat(EventReferenceCall, "\n")
						GetterCode = GetEventReferenceCode
						RequiredPrelude = GetterCode
					end

					if OmitNilFunctionGetterCodeGeneration then
						Path = `{VariableName and `local {VariableName} = ` or ""}` .. Base
						break
					end

					Path = GetterCode .. `\n\n{VariableName and `local {VariableName} = ` or ""}` .. Base
					break
				end
			end
		end

		Path = IndexName .. Path

		CurrentObject = CurrentObject.Parent
	until CurrentObject == nil

	if IsNil then
		if OmitNilFunctionGetterCodeGeneration then
			return Path, RequiredPrelude
		end

		return Path
	end

	return `{VariableName and `local {VariableName} = ` or ""}{Path}`
end

InstanceSerializer.IsEqualToInstance = IsEqualToInstance
return InstanceSerializer

end)() end,
    [35] = function()local wax,script,require,CreateLookupTable=ImportGlobals(35)local ImportGlobals return (function(...)-- LuaEncode - Fast table serialization library for pure Luau/Lua 5.1+
-- MIT License | Copyright (c) 2022-2025 Chad Hyatt <chad@hyatt.page>
-- https://github.com/chadhyatt/LuaEncode

--!optimize 2
--!native

local table, string, next, pcall, game, workspace, tostring, tonumber, getmetatable =
    table, string, next, pcall, game, workspace, tostring, tonumber, getmetatable

local SerializeInstance = require(script.Parent.Instance).Serialize

local string_pack = string.pack
local string_byte = string.byte
local string_format = string.format
local string_char = string.char
local string_gsub = string.gsub
local string_match = string.match
local string_rep = string.rep
local string_sub = string.sub
local string_gmatch = string.gmatch

local table_concat = table.concat

local Type = typeof or type

local function LookupTable(array, lookupType)
    local Out = {}

    if lookupType == "key" then
        for Key, _ in next, array do
            Out[Key] = true
        end
    else
        for _, Value in next, array do
            Out[Value] = true
        end
    end

    return Out
end

-- Used for checking direct getfield syntax; Lua keywords can't be used as keys without being a str
-- FYI; `continue` is Luau only (in Lua it's actually a global function)
local LuaKeywords = LookupTable({
    "and",
    "break",
    "do",
    "else",
    "elseif",
    "end",
    "false",
    "for",
    "function",
    "if",
    "in",
    "local",
    "nil",
    "not",
    "or",
    "repeat",
    "return",
    "then",
    "true",
    "until",
    "while",
    "continue",
})

-- Used to properly serialize NaN values
local NumberCorrection = {
    [string_pack(">n", 0 / 0)] = "0/0",
    [string_pack(">n", -(0 / 0))] = "-(0/0)",
    [string_pack(">n", tonumber("nan"))] = 'tonumber("nan")',
    [string_pack(">n", tonumber("-nan"))] = 'tonumber("-nan")',
}

-- Type names that can be used as manual key indexes (i.e. non-reference types)
local KeyIndexTypes = LookupTable({
    "number",
    "string",
    "boolean",
    "Enum",
    "EnumItem",
    "Enums",
})

local DirectIndexPat = "^[A-Za-z_][A-Za-z0-9_]*$"

local function CheckType(inputData, dataName, ...)
    local ValidTypes = { ... }
    local ValidTypesLookup = LookupTable(ValidTypes)
    local InputType = Type(inputData)

    if not ValidTypesLookup[InputType] then
        error(
            string_format(
                "LuaEncode: Incorrect type for `%s`: `%s` expected, got `%s`",
                dataName,
                table_concat(ValidTypes, ", "), -- For if multiple types are accepted
                InputType
            ),
            0
        )
    end

    return inputData
end

-- This re-serializes a string back into Lua, for the interpreter AND humans to read. This fixes
-- `string_format("%q")` only outputting in system encoding, instead of explicit Lua byte escapes
local SerializeString
do
    -- These are control characters to be encoded in a certain way in Lua rather than just a byte escape
    local SpecialCharacters = {
        ['"'] = '\\"',
        ["\\"] = "\\\\",
        ["\a"] = "\\a",
        ["\b"] = "\\b",
        ["\t"] = "\\t",
        ["\n"] = "\\n",
        ["\v"] = "\\v",
        ["\f"] = "\\f",
        ["\r"] = "\\r",
    }

    for Index = 0, 255 do
        local Character = string_char(Index)

        if not SpecialCharacters[Character] and (Index < 32 or Index > 126) then
            SpecialCharacters[Character] = string_format("\\x%02X", Index)
        end
    end

    function SerializeString(inputString)
        -- FYI; We can't do "\0-\31" in Lua 5.1 (Only Luau/Lua 5.2+) due to an embedded zeros in pattern
        -- issue. See: https://stackoverflow.com/a/22962409
        return table_concat({ '"', string_gsub(inputString, '[%z\\"\1-\31\127-\255]', SpecialCharacters), '"' })
    end
end

-- Escape warning messages and such for comment block inserts
local function CommentBlock(inputString)
    local Longest = -1
    for Match in string_gmatch(inputString, "%](=*)%]") do
        if #Match > Longest then
            Longest = #Match
        end
    end

    local Padding = string_rep("=", Longest + 1)
    return "--[" .. Padding .. "[" .. inputString .. "]" .. Padding .. "]"
end

--[[
LuaEncode(inputTable: {[any]: any}, options: {[string]: any}): string

    ---------- OPTIONS: ----------

    Prettify <boolean:false> | Whether or not the output should be pretty printed

    IndentCount <number:0> | The amount of characters that should be used for indents
    (**Note**: If `Prettify` is set to true and this is unspecified, it will default to `4`)

    InsertCycles <boolean:false> | If there are cyclic references in your table, the output
    will be wrapped in an anonymous function that manually sets paths to those references.
    (**NOTE:** If a key in the index path to the cycle is a reference type (e.g. `table`,
    `function`), the codegen can't externally set that path, and the value will have to be ignored)

    OutputWarnings <boolean:true> | If "warnings" should be placed into the output as
    comment blocks

    UseInstancePaths <boolean:true> | If Roblox `Instance` values should return their
    Lua-accessable path for serialization. If the instance is parented under `nil` or
    isn't under `game`/`workspace`, it'll always fall back to `Instance.new(ClassName)`

    UseFindFirstChild  <boolean:true> | When `options.UseInstancePaths` is true, whether or
    not instance paths should use `FindFirstChild` instead of direct indexes

    SerializeMathHuge <boolean:true> | If "infinite" (or negative-infinite) numbers should
    be serialized as `math.huge`. (uses the `math` global, as opposed to just a direct data
    type) If false, "`1/0`" or "`-1/0`" will be serialized, which is supported on all
    target Lua environments

]]

local function LuaEncode(inputTable, options)
    options = options or {}

    CheckType(inputTable, "inputTable", "table")
    CheckType(options, "options", "table")

    CheckType(options.Prettify, "options.Prettify", "boolean", "nil")
    CheckType(options.PrettyPrinting, "options.PrettyPrinting", "boolean", "nil") -- Alias for `Options.Prettify`
    CheckType(options.IndentCount, "options.IndentCount", "number", "nil")
    CheckType(options.InsertCycles, "options.InsertCycles", "boolean", "nil")
    CheckType(options.OutputWarnings, "options.OutputWarnings", "boolean", "nil")
    CheckType(options.FunctionsReturnRaw, "options.FunctionsReturnRaw", "boolean", "nil")
    CheckType(options.UseInstancePaths, "options.UseInstancePaths", "boolean", "nil")
    CheckType(options.UseFindFirstChild, "options.UseFindFirstChild", "boolean", "nil")
    CheckType(options.SerializeMathHuge, "options.SerializeMathHuge", "boolean", "nil")
    CheckType(options.DisableNilParentHandler, "options.DisableNilParentHandler", "boolean", "nil")
    CheckType(options.IsArray, "options.IsArray", "boolean", "nil")

    CheckType(options._StackLevel, "options._StackLevel", "number", "nil")
    CheckType(options._VisitedTables, "options._VisitedTables", "table", "nil")
    CheckType(options._SharedTableLarpAsRegTable, "options._SharedTableLarpAsRegTable", "boolean", "nil")

    local Prettify = (options.Prettify == nil and options.PrettyPrinting == nil and false)
        or (options.Prettify ~= nil and options.Prettify)
        or (options.PrettyPrinting and options.PrettyPrinting)
    local IndentCount = options.IndentCount or (Prettify and 4) or 0
    local InsertCycles = (options.InsertCycles == nil and false) or options.InsertCycles
    local OutputWarnings = (options.OutputWarnings == nil and true) or options.OutputWarnings
    local UseInstancePaths = (options.UseInstancePaths == nil and true) or options.UseInstancePaths
    local DisableNilParentHandler = options.DisableNilParentHandler or false
    local SerializeMathHuge = (options.SerializeMathHuge == nil and true) or options.SerializeMathHuge
    local IsArray = (options.IsArray == nil and false) or options.IsArray

    local StackLevelOpt = options._StackLevel or 1
    local VisitedTables = options._VisitedTables or {} -- [Ref: table] = true
    local SharedTableLarpAsRegTable = options._SharedTableLarpAsRegTable or false
    local DidInsertNilFunction = options._DidInsertNilFunction or false

    -- Lazy serialization reference values
    local PositiveInf = (SerializeMathHuge and "math.huge") or "1/0"
    local NegativeInf = (SerializeMathHuge and "-math.huge") or "-1/0"
    local NewEntryString = (Prettify and "\n") or ""
    local CodegenNewline = (Prettify and "\n") or " "
    local ValueSeperator = (Prettify and ", ") or ","
    local BlankSeperator = (Prettify and " ") or ""
    local EqualsSeperator = (Prettify and " = ") or "="

    local StackLevel = StackLevelOpt

    -- For pretty printing we need to keep track of the current stack level, then repeat IndentString by that count
    local IndentStringBase = string_rep(" ", IndentCount)

    -- Calculated in the walk loop, based on the current StackLevel
    local IndentString = nil
    local EndingIndentString = nil

    --IndentString = (Prettify and string_rep(IndentString, StackLevel)) or IndentString
    --local EndingIndentString = (#IndentString > 0 and string_sub(IndentString, 1, -IndentCount - 1)) or ""

    -- For number key values, we want to explicitly serialize the index num ONLY when it needs to be
    local KeyNumIndex = 1

    -- Cases for encoding values, then end setup. Functions are all expected to return a (EncodedKey: string, EncloseInBrackets: boolean)
    local TypeCases = {}
    do
        local function TypeCase(typeName, value, ...)
            local EncodedValue = TypeCases[typeName](value, false, ...) -- False to label as NOT `isKey`
            return EncodedValue
        end

        local function Args(...)
            local EncodedValues = {}

            for _, Arg in next, { ... } do
                EncodedValues[#EncodedValues + 1] = TypeCase(Type(Arg), Arg)
            end

            return table_concat(EncodedValues, ValueSeperator)
        end

        -- For Roblox's different `Params` data types
        local function Params(newData, params)
            return "(function(p, t) for n, v in next, t do p[n] = v end return p end)("
                .. table_concat({ newData, TypeCase("table", params) }, ValueSeperator)
                .. ")"
        end

        TypeCases["number"] = function(value, isKey)
            -- If the number isn't the current real index of the table, we DO want to
            -- explicitly define it in the serialization no matter what for accuracy
            if isKey and value == KeyNumIndex then
                -- ^^ What's EXPECTED unless otherwise explicitly defined, if so, return no encoded num
                KeyNumIndex = KeyNumIndex + 1
                return nil, true
            end

            -- Lua's internal `tostring` handling will denote positive/negativie-infinite number TValues as "inf", which
            -- makes certain numbers not encode properly. We also just want to make the output precise
            if value == 1 / 0 then
                return PositiveInf
            elseif value == -1 / 0 then
                return NegativeInf
            elseif value == math.pi then
                return "math.pi"
            end

            -- Provided by felixdm
            local NumberPacked = string_pack(">n", value) -- gameguy is a boss
            local CorrectedNumber = NumberCorrection[NumberPacked]
            if CorrectedNumber then
                return CorrectedNumber
            end

            if value ~= value then
                return string_format(
                    '(string.unpack(">n", "\\%*\\%*\\%*\\%*\\%*\\%*\\%*\\%*"))',
                    string_byte(NumberPacked, 1, 8)
                )
            end

            return string_format("%.17g", value)
        end

        TypeCases["string"] = function(value, isKey)
            if isKey and not LuaKeywords[value] and string_match(value, DirectIndexPat) then
                -- Doesn't need full string def
                return value, true
            end

            return SerializeString(value)
        end

        -- This is NOT used for recursive table serialization, only table-as-key values and Roblox data types that use tables as
        -- arguments for constructor functions
        TypeCases["table"] = function(value, isKey, stLarpAsRegTable)
            -- Primarily for tables-as-keys
            if VisitedTables[value] and OutputWarnings then
                return "{--[[LuaEncode: Duplicate reference]]}"
            end

            local NewOptions = setmetatable({}, { __index = options })
            do
                NewOptions.Prettify = (isKey and false) or Prettify
                NewOptions.IndentCount = (isKey and ((not Prettify and IndentCount) or 1)) or IndentCount
                NewOptions._StackLevel = (isKey and 1) or StackLevel + 1
                NewOptions._VisitedTables = VisitedTables
                NewOptions._SharedTableLarpAsRegTable = (not isKey and stLarpAsRegTable)
                NewOptions.IsArray = false
                NewOptions._DidInsertNilFunction = DidInsertNilFunction
            end

            local Result, DidInsertNilFunction = LuaEncode(value, NewOptions)
            if DidInsertNilFunction then
                DidInsertNilFunction = true
            end

            return Result
        end

        TypeCases["boolean"] = function(value)
            return value and "true" or "false"
        end

        TypeCases["nil"] = function(value)
            return "nil"
        end

        TypeCases["thread"] = function(value)
            return "task.spawn(function() end)"
        end

        TypeCases["function"] = function(value)
            -- We can't serialize functions, so emit a stub with a comment block of metadata
            local FunctionName, ArgumentCount, VarArg, Line = debug.info(value, "nal")

            local Arguments = {}
            for Index = 1, ArgumentCount do
                Arguments[Index] = string_format("arg%d", Index)
            end

            local BodyIndent = IndentString .. IndentStringBase
            local Details = {
                `Name: {FunctionName == "" and "Anonymous Function" or FunctionName} | Line: {Line}`,
                if islclosure(value)
                    then `Upvalues: {#debug.getupvalues(value)}`
                    else "Upvalues: N/A (C Closure)",
                if getfunctionhash
                    then if islclosure(value)
                        then `Function Hash: {getfunctionhash(value)}`
                        else "Function Hash: N/A (C Closure)"
                    else "Function Hash: N/A (getfunctionhash == nil)",
            }
            if OutputWarnings then
                Details[#Details + 1] = "LuaEncode: Unable to serialize function"
            end

            return string_format(
                [[function(%s)%sreturn%send]],
                `{table_concat(Arguments, ", ")}{VarArg and `{Arguments[1] and ", " or ""}...` or ""}`,
                `{CodegenNewline}{BodyIndent}{CommentBlock(table_concat(Details, CodegenNewline .. BodyIndent))}{CodegenNewline}{BodyIndent}`,
                `{CodegenNewline}{IndentString}`
            )
        end

        ---------- ROBLOX CUSTOM DATA TYPES BELOW ----------

        TypeCases["Axes"] = function(value)
            local EncodedArgs = {}
            local EnumValues = {
                ["Enum.Axis.X"] = value.X,
                ["Enum.Axis.Y"] = value.Y,
                ["Enum.Axis.Z"] = value.Z,
            }

            for EnumValue, IsEnabled in next, EnumValues do
                if IsEnabled then
                    EncodedArgs[#EncodedArgs + 1] = EnumValue
                end
            end

            return "Axes.new(" .. table_concat(EncodedArgs, ValueSeperator) .. ")"
        end

        TypeCases["BrickColor"] = function(value)
            -- BrickColor.Number (Its enum ID) will be slightly more efficient in all cases in deser,
            -- so we'll use it if Options.Prettify is false
            return "BrickColor.new(" .. ((Prettify and TypeCase("string", value.Name)) or value.Number) .. ")"
        end

        TypeCases["CFrame"] = function(value)
            return "CFrame.new(" .. Args(value:components()) .. ")"
        end

        TypeCases["CatalogSearchParams"] = function(value)
            return Params("CatalogSearchParams.new()", {
                SearchKeyword = value.SearchKeyword,
                MinPrice = value.MinPrice,
                MaxPrice = value.MaxPrice,
                SortType = value.SortType, -- EnumItem
                CategoryFilter = value.CategoryFilter, -- EnumItem
                BundleTypes = value.BundleTypes, -- table
                AssetTypes = value.AssetTypes, -- table
            })
        end

        TypeCases["Color3"] = function(value)
            return "Color3.new(" .. Args(value.R, value.G, value.B) .. ")"
        end

        TypeCases["ColorSequence"] = function(value)
            return "ColorSequence.new(" .. TypeCase("table", value.Keypoints) .. ")"
        end

        TypeCases["ColorSequenceKeypoint"] = function(value)
            return "ColorSequenceKeypoint.new(" .. Args(value.Time, value.Value) .. ")"
        end

        TypeCases["DateTime"] = function(value)
            return "DateTime.fromUnixTimestamp(" .. value.UnixTimestamp .. ")"
        end

        -- Properties seem to throw an error on index if the scope isn't a Studio plugin, so we're
        -- directly getting values! (so fun!!!!)
        TypeCases["DockWidgetPluginGuiInfo"] = function(value)
            -- e.g.: "InitialDockState:Right InitialEnabled:0 InitialEnabledShouldOverrideRestore:0 FloatingXSize:0 FloatingYSize:0 MinWidth:0 MinHeight:0"
            local ValueString = tostring(value)

            return "DockWidgetPluginGuiInfo.new("
                .. Args(
                    -- InitialDockState (Enum.InitialDockState)
                    Enum.InitialDockState[string_match(ValueString, "InitialDockState:(%w+)")], -- Enum.InitialDockState.Right
                    -- InitialEnabled and InitialEnabledShouldOverrideRestore (boolean as number; `0` or `1`)
                    string_match(ValueString, "InitialEnabled:(%w+)") == "1", -- false
                    string_match(ValueString, "InitialEnabledShouldOverrideRestore:(%w+)") == "1", -- false
                    -- FloatingXSize/FloatingYSize (numbers)
                    tonumber(string_match(ValueString, "FloatingXSize:(%w+)")), -- 0
                    tonumber(string_match(ValueString, "FloatingYSize:(%w+)")), -- 0
                    -- MinWidth/MinHeight (numbers)
                    tonumber(string_match(ValueString, "MinWidth:(%w+)")), -- 0
                    tonumber(string_match(ValueString, "MinHeight:(%w+)")) -- 0
                )
                .. ")"
        end

        -- e.g. `Enum.UserInputType`
        TypeCases["Enum"] = function(value)
            local ValueString = tostring(value)

            if string_match(ValueString, DirectIndexPat) then
                return "Enum." .. ValueString
            end
            return "Enum[" .. SerializeString(ValueString) .. "]"
        end

        -- e.g. `Enum.UserInputType.Gyro`
        TypeCases["EnumItem"] = function(value)
            local EnumTypeStr = TypeCase("Enum", value.EnumType)
            local EnumName = value.Name

            if string_match(EnumName, DirectIndexPat) then
                return EnumTypeStr .. "." .. value.Name
            end
            return EnumTypeStr .. "[" .. SerializeString(EnumName) .. "]"
        end

        -- i.e. the `Enum` global return
        TypeCases["Enums"] = function(value)
            return "Enum"
        end

        TypeCases["Faces"] = function(value)
            local EncodedArgs = {}
            local EnumValues = {
                ["Enum.NormalId.Top"] = value.Top, -- These return bools
                ["Enum.NormalId.Bottom"] = value.Bottom,
                ["Enum.NormalId.Left"] = value.Left,
                ["Enum.NormalId.Right"] = value.Right,
                ["Enum.NormalId.Back"] = value.Back,
                ["Enum.NormalId.Front"] = value.Front,
            }

            for EnumValue, IsEnabled in next, EnumValues do
                if IsEnabled then
                    EncodedArgs[#EncodedArgs + 1] = EnumValue
                end
            end

            return "Faces.new(" .. table_concat(EncodedArgs, ValueSeperator) .. ")"
        end

        TypeCases["FloatCurveKey"] = function(value)
            return "FloatCurveKey.new(" .. Args(value.Time, value.Value, value.Interpolation) .. ")"
        end

        TypeCases["Font"] = function(value)
            return "Font.new(" .. Args(value.Family, value.Weight, value.Style) .. ")"
        end

        TypeCases["Content"] = function(value)
            local source = value.SourceType

            if source == Enum.ContentSourceType.None then
                return "Content.none"
            elseif source == Enum.ContentSourceType.Uri then
                local uri = value.Uri or ""
                local assetId = string.match(uri, "^rbxassetid://(%d+)$")
                if assetId then
                    return "Content.fromAssetId(" .. assetId .. ")"
                end
                return "Content.fromUri(" .. TypeCase("string", uri) .. ")"
            elseif source == Enum.ContentSourceType.Object and value.Object then
                return "Content.fromObject(" .. TypeCase("Instance", value.Object) .. ")"
            end

            return "Content.none" .. BlankSeperator .. CommentBlock("Content source=" .. tostring(source))
        end

        -- Instance refs can be evaluated to their paths (optional), but if parented to
        -- nil or some DataModel not under `game`, it'll just return nil
        TypeCases["Instance"] = function(value)
            if UseInstancePaths then
                local InstancePath, NilFunctionInserted = SerializeInstance(value, {
                    DisableNilParentHandler = DisableNilParentHandler,
                    OmitNilFunctionGetterCodeGeneration = true,
                })

                if NilFunctionInserted then
                    DidInsertNilFunction = true
                end

                if InstancePath then
                    return InstancePath
                end

                -- ^^ Now, if the path isn't accessable, falls back to the return below anyway
            end

            return "nil"
                .. BlankSeperator
                .. CommentBlock("Instance.new(" .. TypeCase("string", value.ClassName) .. ")")
        end

        TypeCases["NumberRange"] = function(value)
            return "NumberRange.new(" .. Args(value.Min, value.Max) .. ")"
        end

        TypeCases["NumberSequence"] = function(value)
            return "NumberSequence.new(" .. TypeCase("table", value.Keypoints) .. ")"
        end

        TypeCases["NumberSequenceKeypoint"] = function(value)
            return "NumberSequenceKeypoint.new(" .. Args(value.Time, value.Value, value.Envelope) .. ")"
        end

        TypeCases["OverlapParams"] = function(value)
            return Params("OverlapParams.new()", {
                FilterDescendantsInstances = value.FilterDescendantsInstances,
                FilterType = value.FilterType,
                MaxParts = value.MaxParts,
                CollisionGroup = value.CollisionGroup,
                RespectCanCollide = value.RespectCanCollide,
            })
        end

        TypeCases["Path2DControlPoint"] = function(value)
            return "Path2DControlPoint.new(" .. Args(value.Position, value.LeftTangent, value.RightTangent) .. ")"
        end

        TypeCases["PathWaypoint"] = function(value)
            return "PathWaypoint.new(" .. Args(value.Position, value.Action, value.Label) .. ")"
        end

        TypeCases["PhysicalProperties"] = function(value)
            return "PhysicalProperties.new("
                .. Args(
                    value.Density,
                    value.Friction,
                    value.Elasticity,
                    value.FrictionWeight,
                    value.ElasticityWeight,
                    value.AcousticAbsorption
                )
                .. ")"
        end

        TypeCases["Random"] = function()
            return "Random.new()"
        end

        TypeCases["Ray"] = function(value)
            return "Ray.new(" .. Args(value.Origin, value.Direction) .. ")"
        end

        TypeCases["SecurityCapabilities"] = function(value)
            local caps = {}
            for _, item in Enum.SecurityCapability:GetEnumItems() do
                local IsAlias = table.find({ "AssetRequire", "Avatar" }, item.Name) ~= nil
                if IsAlias then
                    continue
                end

                if value:Contains(item) then
                    table.insert(caps, item)
                end
            end

            if #caps == 0 then
                return "SecurityCapabilities.new()"
            end

            return "SecurityCapabilities.new(" .. Args(table.unpack(caps)) .. ")"
        end

        TypeCases["RaycastParams"] = function(value)
            return Params("RaycastParams.new()", {
                FilterDescendantsInstances = value.FilterDescendantsInstances,
                FilterType = value.FilterType,
                IgnoreWater = value.IgnoreWater,
                CollisionGroup = value.CollisionGroup,
                RespectCanCollide = value.RespectCanCollide,
            })
        end

        TypeCases["Rect"] = function(value)
            return "Rect.new(" .. Args(value.Min, value.Max) .. ")"
        end

        -- Roblox doesn't provide direct read properties for min/max on `Region3`, but they do on Region3int16..
        TypeCases["Region3"] = function(value)
            local ValuePos = value.CFrame.Position
            local ValueSize = 0.5 * value.Size

            return "Region3.new("
                .. Args(
                    ValuePos - ValueSize, -- Minimum
                    ValuePos + ValueSize -- Maximum
                )
                .. ")"
        end

        TypeCases["Region3int16"] = function(value)
            return "Region3int16.new(" .. Args(value.Min, value.Max) .. ")"
        end

        TypeCases["TweenInfo"] = function(value)
            return "TweenInfo.new("
                .. Args(
                    value.Time,
                    value.EasingStyle,
                    value.EasingDirection,
                    value.RepeatCount,
                    value.Reverses,
                    value.DelayTime
                )
                .. ")"
        end

        TypeCases["RotationCurveKey"] = function(value)
            return "RotationCurveKey.new(" .. Args(value.Time, value.Value, value.Interpolation) .. ")"
        end

        TypeCases["UDim"] = function(value)
            return "UDim.new(" .. Args(value.Scale, value.Offset) .. ")"
        end

        TypeCases["UDim2"] = function(value)
            return "UDim2.new(" .. Args(value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset) .. ")"
        end

        TypeCases["Vector2"] = function(value)
            return "Vector2.new(" .. Args(value.X, value.Y) .. ")"
        end

        TypeCases["Vector2int16"] = function(value)
            return "Vector2int16.new(" .. Args(value.X, value.Y) .. ")"
        end

        TypeCases["Vector3"] = function(value)
            return "Vector3.new(" .. Args(value.X, value.Y, value.Z) .. ")"
        end

        TypeCases["Vector3int16"] = function(value)
            return "Vector3int16.new(" .. Args(value.X, value.Y, value.Z) .. ")"
        end

        TypeCases["buffer"] = function(value)
            if wax.shared.SaveManager:GetState("PreferBufferFromString") then
                return "buffer.fromstring(" .. SerializeString(buffer.tostring(value)) .. ")"
            end

            local Bytes = {}
            for i = 1, buffer.len(value) do
                table.insert(Bytes, buffer.readu8(value, i - 1))
            end

            return table_concat({
                "(function(bytes) ",
                CommentBlock("Type: buffer"),
                NewEntryString,
                IndentString,
                IndentStringBase,
                "local b = buffer.create(#bytes)",
                NewEntryString,
                IndentString,
                IndentStringBase,
                "for i = 1, #bytes do",
                NewEntryString,
                IndentString,
                IndentStringBase,
                IndentStringBase,
                "buffer.writeu8(b, i - 1, bytes[i])",
                NewEntryString,
                IndentString,
                IndentStringBase,
                "end",
                NewEntryString,
                IndentStringBase,
                IndentString,
                "return b",
                NewEntryString,
                IndentString,
                "end)({ ",
                table_concat(Bytes, ", "),
                " })",
            })
        end

        TypeCases["SharedTable"] = function(value, isKey)
            local StClone = {}
            -- Will still compile in vanilla Lua if we do it this way. We should probably create a deep clone
            -- of the current state of the table regardless
            for Key, Value in SharedTable.clone(value, not SharedTableLarpAsRegTable) do
                StClone[Key] = Value
            end

            local StCloneStr = TypeCases["table"](StClone, isKey, true) -- 3rd arg is stLarpAsRegTable
            if SharedTableLarpAsRegTable then
                return StCloneStr
            end
            return table_concat({ "SharedTable.new(", StCloneStr, ")" })
        end

        TypeCases["userdata"] = function(value)
            if getmetatable(value) ~= nil then -- Has mt
                return "newproxy(true)"
            else
                return "newproxy()" -- newproxy() defaults to false (no mt)
            end
        end
    end

    -- Setup for final output, which will be concat together
    local Output = {}

    local TablePointer = inputTable
    local NextKey = nil -- Used with TableStack so the TablePointer loop knows where to continue from upon stack pop
    local IsNewTable = true -- Used with table stack push/pop to identify when an opening curly brace should be added

    -- Stack array for table depth
    local TableStack = {} -- [Depth: number] = {TablePointer: table, NextKey: any, KeyNumIndex: number}
    local RefMaps = { [TablePointer] = "" } -- [Ref: table] = ".example["ref path"]'
    local CycleMaps = {} -- ['.example["ref path"]'] = '.another["ref path"]'

    local function IsArrayKey(Index, Length)
        return type(Index) == "number" and Index >= 1 and Index <= Length and Index % 1 == 0
    end

    local function NextEntry(Table, Key)
        local Length = IsArray and Table.n or #Table

        -- Keep holes inside the array as nil; explicit numeric keys can change
        -- how Roblox classifies the reconstructed table during replication.
        if Key == nil or IsArrayKey(Key, Length) then
            local Index = (Key or 0) + 1
            if Index <= Length then
                return Index, rawget(Table, Index)
            end
            Key = nil
        end

        if not IsArray then
            local Value
            repeat
                Key, Value = next(Table, Key)
            until not IsArrayKey(Key, Length)
            return Key, Value
        end
    end

    while TablePointer do
        -- Update StackLevel for formatting
        StackLevel = StackLevelOpt + #TableStack
        IndentString = (Prettify and string_rep(IndentStringBase, StackLevel)) or IndentStringBase
        EndingIndentString = (#IndentString > 0 and string_sub(IndentString, 1, -IndentCount - 1)) or ""

        local HasNextValue = NextEntry(TablePointer, NextKey) ~= nil

        -- Only append an opening brace to the table if this isn't just a continution up the stack
        if IsNewTable then
            Output[#Output + 1] = "{"
        elseif not HasNextValue then -- Formatting for the next entry still needs to be added like any other value
            Output[#Output + 1] = NewEntryString .. EndingIndentString
        else
            Output[#Output + 1] = ","
        end

        VisitedTables[TablePointer] = true

        -- Just because of control flow restrictions with Lua compatibility
        local SkipStackPop = false

        local function WalkTable(Key, Value)
            local KeyType, ValueType = Type(Key), Type(Value)
            local ValueIsTable = ValueType == "table"
            local KeyTypeCase, ValueTypeCase = TypeCases[KeyType], TypeCases[ValueType]

            Output[#Output + 1] = NewEntryString .. IndentString

            if KeyTypeCase and ValueTypeCase then
                local ValueWasEncoded = false -- Keeping track of this for adding a "," to the output if needed

                -- Evaluate output for key
                local KeyEncodedSuccess, EncodedKeyOrError, DontEncloseKeyInBrackets = pcall(KeyTypeCase, Key, true) -- The `true` represents if it's a key or not, here it is

                -- Evaluate output for value, ignoring 2nd arg (`DontEncloseInBrackets`) because this isn't the key
                local ValueEncodedSuccess, EncodedValueOrError
                if not ValueIsTable then
                    ValueEncodedSuccess, EncodedValueOrError = pcall(ValueTypeCase, Value, false)
                end

                -- Ignoring `if EncodedKeyOrError` because the key doesn't actually need to ALWAYS
                -- be explicitly encoded, like if it's a number of the current key index!
                if KeyEncodedSuccess and (ValueIsTable or (ValueEncodedSuccess and EncodedValueOrError)) then
                    -- Append explicit key if necessary
                    if EncodedKeyOrError then
                        if DontEncloseKeyInBrackets then
                            Output[#Output + 1] = EncodedKeyOrError
                        else
                            Output[#Output + 1] = table_concat({ "[", EncodedKeyOrError, "]" })
                        end

                        Output[#Output + 1] = EqualsSeperator
                    end

                    -- Of course, recursive tables are handled differently and use the stack system
                    if ValueIsTable then
                        local IndexPath
                        if InsertCycles and KeyIndexTypes[KeyType] and RefMaps[TablePointer] then
                            if KeyType == "string" and not LuaKeywords[Key] and string_match(Key, DirectIndexPat) then
                                IndexPath = "." .. Key
                            else
                                local EncodedKeyAsValue = TypeCases[KeyType](Key)
                                IndexPath = table_concat({ "[", EncodedKeyAsValue, "]" })
                            end
                        end

                        if not VisitedTables[Value] then
                            if IndexPath then
                                RefMaps[Value] = RefMaps[TablePointer] .. IndexPath
                            end

                            TableStack[#TableStack + 1] = { TablePointer, Key, KeyNumIndex, IsArray }

                            TablePointer = Value
                            NextKey = nil
                            KeyNumIndex = 1
                            IsArray = false -- Nested tables are not treated as arrays with 'n' field

                            IsNewTable = true
                            SkipStackPop = true

                            return false -- break
                        else
                            EncodedValueOrError =
                                string_format("{%s}", (OutputWarnings and "--[[LuaEncode: Duplicate reference]]") or "")

                            if IndexPath then
                                CycleMaps[IndexPath] = RefMaps[Value]
                            end
                        end
                    end

                    -- Append value like normal
                    Output[#Output + 1] = EncodedValueOrError

                    ValueWasEncoded = true
                elseif OutputWarnings then -- Then `Encoded(Key/Value)OrError` is the error msg
                    -- ^^ Then either the key or value wasn't properly checked or encoded, and there
                    -- was an error we need to log!
                    local ErrorMessage = string_format(
                        "LuaEncode: Failed to serialize %s of data type %s: %s",
                        (not KeyEncodedSuccess and "key") or (not ValueEncodedSuccess and "value") or "key/value",
                        ValueType,
                        (not KeyEncodedSuccess and SerializeString(EncodedKeyOrError))
                            or (not ValueEncodedSuccess and SerializeString(EncodedValueOrError))
                            or "(Failed to get error message)"
                    )

                    Output[#Output + 1] = CommentBlock(ErrorMessage)
                end

                local HasNextValue = NextEntry(TablePointer, Key) ~= nil
                if not HasNextValue then
                    -- If there isn't another value after the current index, add ending formatting
                    Output[#Output + 1] = NewEntryString .. EndingIndentString
                elseif ValueWasEncoded then
                    Output[#Output + 1] = ","
                end
            else
                -- Data type is unimplemented

                -- Dtc
                local KeyTostring = (KeyType == "userdata" and "userdata") or tostring(Key)
                local ValueTostring = (ValueType == "userdata" and "userdata") or tostring(Value)

                Output[#Output + 1] = CommentBlock(
                    BlankSeperator
                        .. KeyType
                        .. "("
                        .. SerializeString(KeyTostring)
                        .. ")"
                        .. ":"
                        .. BlankSeperator
                        .. ValueType
                        .. "("
                        .. SerializeString(ValueTostring)
                        .. ")"
                        .. BlankSeperator
                )

                local HasNextValue = NextEntry(TablePointer, Key) ~= nil
                if not HasNextValue then
                    Output[#Output + 1] = NewEntryString .. EndingIndentString
                end
            end

            return true
        end

        for Key, Value in NextEntry, TablePointer, NextKey do
            local Success = WalkTable(Key, Value)
            if not Success then
                break
            end
        end

        -- Vanilla Lua control flow is fun
        if not SkipStackPop then
            if not Prettify and IndentCount > 0 then
                Output[#Output + 1] = IndentString
            end
            Output[#Output + 1] = "}"

            if #TableStack > 0 then
                local TableUp = TableStack[#TableStack]
                TableStack[#TableStack] = nil -- Pop off the table stack

                TablePointer, NextKey, KeyNumIndex, IsArray = TableUp[1], TableUp[2], TableUp[3], TableUp[4]
                IsNewTable = false
            else
                break
            end
        end
    end

    if InsertCycles then
        local CycleMapsOut = {}
        for CycleIndex, CycleMap in next, CycleMaps do
            CycleMapsOut[#CycleMapsOut + 1] = IndentString
                .. "t"
                .. CycleIndex
                .. EqualsSeperator
                .. "t"
                .. CycleMap
                .. CodegenNewline
        end

        if #CycleMapsOut > 0 then
            return table_concat({
                "(function(t)",
                NewEntryString,
                table_concat(CycleMapsOut),
                NewEntryString,
                IndentString,
                "return t",
                CodegenNewline,
                "end)(",
                table_concat(Output),
                ")",
            }),
                DidInsertNilFunction
        end
    end

    return table_concat(Output), DidInsertNilFunction
end

return LuaEncode

end)() end,
    [36] = function()local wax,script,require,CreateLookupTable=ImportGlobals(36)local ImportGlobals return (function(...)local Utils = script.Parent.Parent.Parent

local LuaEncode = require(script.Parent.LuaEncode)
local InstanceSerializer = require(script.Parent.Instance)

local Session = {}
do
	local StringMapper = {}
	StringMapper.__index = StringMapper

	function StringMapper.New()
		return setmetatable({
			StringMap = {},
			StringList = {},
			NextStringId = 1,
		}, StringMapper)
	end

	function StringMapper:GetId(Str)
		if Str == nil then
			Str = "nil"
		end
		Str = tostring(Str)
		if not self.StringMap[Str] then
			self.StringMap[Str] = self.NextStringId
			self.StringList[tostring(self.NextStringId)] = Str
			self.NextStringId = self.NextStringId + 1
		end
		return self.StringMap[Str]
	end

	function StringMapper:GetString(Id)
		return self.StringList[Id]
	end

	Session.StringMapper = StringMapper
end

function Session:FetchAllLogs()
	local AllCalls = {}

	for _, LogCategory in next, wax.shared.Logs do
		for _, Log in next, LogCategory do
			for Idx, Call in next, Log.Calls do
				table.insert(
					AllCalls,
					setmetatable(Call, {
						__index = Log,
					})
				)
			end
		end
	end

	return AllCalls
end

function Session:SortCalls(AllCalls)
	table.sort(AllCalls, function(a, b)
		local TimeA = a.CreationTime or 0
		local TimeB = b.CreationTime or 0
		return TimeA < TimeB
	end)
end

function Session:GetSessionData(AllCalls)
	local StartTime = wax.shared.CobaltStartTime or tick()
	local EndTime = AllCalls[#AllCalls] and AllCalls[#AllCalls].CreationTime or tick()
	local Duration = math.max(0.1, EndTime - StartTime)
	local SessionId = wax.shared.HttpService:GenerateGUID(false)

	return {
		StartTime = StartTime,
		EndTime = EndTime,
		Duration = Duration,
		SessionId = SessionId,
	}
end

function Session:EscapeHTML(Str)
	return Str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

function Session:SerializeLuauTableForHTML(Table)
	if type(Table) ~= "table" then
		-- Actor function metadata stores upvalue/constant/proto *counts* as numbers.
		return self:EscapeHTML(tostring(Table))
	end

	local SerializedString = LuaEncode(Table, {
		Prettify = true,
		InsertCycles = true,
		DisableNilParentHandler = true,
	})

	return self:EscapeHTML(SerializedString)
end

function Session:ProcessCalls(AllCalls, SessionData, UpdateProgress)
	local StringMapper = self.StringMapper.New()

	local Events = {}
	local AllCallsNum = #AllCalls
	for Idx, Call in next, AllCalls do
		if Idx % 500 == 0 then
			if UpdateProgress then
				UpdateProgress(`Processing... ({Idx}/{AllCallsNum})`)
			end
			task.wait()
		end

		local Args = Call.Arguments
		local ArgsString = if type(Args) == "table"
			then self:SerializeLuauTableForHTML({ wax.shared.SafePack.Unpack(Args, 1, Args.n) })
			else self:EscapeHTML(tostring(Args))

		local Method = "Unknown"
		if wax.shared.FunctionForClasses[Call.Type] then
			Method = wax.shared.FunctionForClasses[Call.Type][Call.Instance.ClassName] or Method
		end

		local FunctionName, FunctionLine, FunctionSource, FunctionHash =
			"Unknown", Call.Line or -1, Call.Source or "Unknown", "N/A"
		local FunctionUpvalues, FunctionProtos, FunctionConstants = "{}", "{}", "{}"
		do
			if type(Call.Function) == "table" and (Call.IsActor == true or Call.Actor ~= nil) then
				FunctionName = Call.Function.Name ~= "" and Call.Function.Name or "Anonymous"
				FunctionSource = Call.Function.Source or "N/A"
				FunctionLine = Call.Function.Line or -1

				if not Call.Function.IsC then
					FunctionHash = Call.Function.FunctionHash or "N/A"
					-- Actor bridge only sends counts for these, not the full tables.
					FunctionUpvalues = self:SerializeLuauTableForHTML(Call.Function.Upvalues)
					FunctionProtos = self:SerializeLuauTableForHTML(Call.Function.Protos)
					FunctionConstants = self:SerializeLuauTableForHTML(Call.Function.Constants)
				else
					FunctionHash = "N/A (C Closure)"
					FunctionUpvalues = "N/A (C Closure)"
					FunctionProtos = "N/A (C Closure)"
					FunctionConstants = "N/A (C Closure)"
				end
			elseif type(Call.Function) == "function" then
				FunctionName = debug.info(Call.Function, "n")

				if islclosure(Call.Function) then
					FunctionHash = getfunctionhash and getfunctionhash(Call.Function) or "N/A"
					FunctionUpvalues = self:SerializeLuauTableForHTML(debug.getupvalues(Call.Function))
					FunctionProtos = self:SerializeLuauTableForHTML(debug.getprotos(Call.Function))
					FunctionConstants = self:SerializeLuauTableForHTML(debug.getconstants(Call.Function))
				else
					FunctionHash = "N/A (C Closure)"
					FunctionUpvalues = "N/A (C Closure)"
					FunctionProtos = "N/A (C Closure)"
					FunctionConstants = "N/A (C Closure)"
				end
			else
				FunctionName = tostring(Call.Function or "Unknown")
			end

			if FunctionName == "" then
				FunctionName = "Anonymous"
			end
		end

		local OriginPath = Call.Origin
				and InstanceSerializer.Serialize(Call.Origin, {
					DisableNilParentHandler = true,
				})
			or "Unknown"

		table.insert(Events, {
			StringMapper:GetId(Call.Instance.Name),
			StringMapper:GetId(Call.Instance.ClassName),
			StringMapper:GetId(InstanceSerializer.Serialize(Call.Instance, {
				DisableNilParentHandler = true,
			})),

			StringMapper:GetId(Method),
			(Call.CreationTime or SessionData.StartTime),
			StringMapper:GetId(OriginPath),

			StringMapper:GetId(ArgsString),
			StringMapper:GetId(Method),

			StringMapper:GetId(FunctionName),
			FunctionLine,
			StringMapper:GetId(FunctionSource),
			Call.IsExecutor and 1 or 0,
			(Call.IsActor == true or Call.Actor ~= nil) and 1 or 0,

			StringMapper:GetId(FunctionHash),
			StringMapper:GetId(FunctionUpvalues),
			StringMapper:GetId(FunctionProtos),
			StringMapper:GetId(FunctionConstants),
			Call.Blocked and 1 or 0,
		})
	end

	return Events, StringMapper
end

function Session:ExportSessionToHTML(Events, StringMapper, SessionData)
	local Template = Utils.CodeGen.Templates.SessionHTMLView.Value
	local StartDateStr = os.date("%d %b %Y, %H:%M:%S", math.floor(SessionData.StartTime))
	local EndDateStr = os.date("%d %b %Y, %H:%M:%S", math.floor(SessionData.EndTime))

	local HTML = Template:gsub("{{EVENTS_JSON}}", function()
		return wax.shared.HttpService:JSONEncode(Events)
	end)
		:gsub("{{DICTIONARY_JSON}}", function()
			return wax.shared.HttpService:JSONEncode(StringMapper.StringList)
		end)
		:gsub("{{SESSION_ID}}", SessionData.SessionId)
		:gsub("{{START_TIME}}", tostring(SessionData.StartTime))
		:gsub("{{DURATION}}", tostring(SessionData.Duration))
		:gsub("{{EVENT_COUNT}}", tostring(#Events))
		:gsub("{{TOTAL_DURATION}}", string.format("%.2f", SessionData.Duration))
		:gsub("{{PLACE_ID}}", tostring(game.PlaceId))
		:gsub("{{JOB_ID}}", game.JobId)
		:gsub("{{DATE}}", StartDateStr)
		:gsub("{{END_DATE}}", EndDateStr)

	return HTML
end

return Session

end)() end,
    [38] = function()local wax,script,require,CreateLookupTable=ImportGlobals(38)local ImportGlobals return (function(...)return {
    TargetedWrapper = {
        Text = table.concat({
            "{{Prelude}}",
            "run_on_actor({{Actor}}, [[\n{{IndentedCode}}\n]])",
        }, "\n"),
        IndentLevel = 1,
    },
    GenericWrapper = {
        Text = table.concat({
            "{{Prelude}}",
            "for _, category in {getactors(), getdeletedactors and getdeletedactors() or {}} do",
            "    for _, actor in category do",
            "        run_on_actor(actor, [[\n{{IndentedCode}}\n]])",
            "    end",
            "end",
        }, "\n"),
        IndentLevel = 2,
    }
}
end)() end,
    [39] = function()local wax,script,require,CreateLookupTable=ImportGlobals(39)local ImportGlobals return (function(...)local CallTemplates = {}

CallTemplates.IncomingCallbackInvoke = [[{{Prelude}}{{Path}}
local Callback = getcallbackvalue(Event, "{{Method}}")
{{CapturePrefix}}Callback({{Args}}){{CaptureSuffix}}{{ExpectedResultCode}}]]

CallTemplates.IncomingRequestInvoke = [[{{Prelude}}{{Path}}
{{CapturePrefix}}Event:{{Method}}({{Args}}){{CaptureSuffix}}{{ExpectedResultCode}}]]

CallTemplates.IncomingSignal = [[{{Prelude}}{{Path}}
firesignal(Event.{{Method}}{{ArgsWithLeadingComma}})]]

CallTemplates.OutgoingCall = [[{{Prelude}}{{Path}}
Event:{{Method}}({{Args}})]]

CallTemplates.Incoming = {
	SSE = CallTemplates.IncomingCallbackInvoke,
	Request = CallTemplates.IncomingRequestInvoke,
	Signal = CallTemplates.IncomingSignal,
}

CallTemplates.Outgoing = CallTemplates.OutgoingCall

return CallTemplates

end)() end,
    [40] = function()local wax,script,require,CreateLookupTable=ImportGlobals(40)local ImportGlobals return (function(...)local HookTemplates = {}

HookTemplates.IncomingCallbackReturn = [[{{Prelude}}{{Path}}
local Callback = getcallbackvalue(Event, "{{Method}}")
Event.{{Method}} = function(...)
	local Args = table.pack(...)

	local Result = table.pack(
		Callback(table.unpack(Args, 1, Args.n))
	)

	return table.unpack(Result, 1, Result.n)
end

local mtHook; mtHook = hookmetamethod(game, "__newindex", function(...)
	local self, key, value = ...
	
	if (
		rawequal(self, Event) and
		rawequal(key, "{{Method}}") and
		typeof(value) == "function" and
		not checkcaller()
	) then
		Callback = value
	end

	return mtHook(...)
end)]]

HookTemplates.IncomingRequestReturn = [[{{Prelude}}{{Path}}
local mtHook; mtHook = hookmetamethod(game, "__namecall", function(...)
	local self = ...

	if rawequal(self, Event) and getnamecallmethod() == "{{Method}}" then
		local Args = table.pack(...)

		local Result = table.pack(
			mtHook(table.unpack(Args, 1, Args.n))
		)

		return table.unpack(Result, 1, Result.n)
	end

	return mtHook(self, ...)
end)

local Old{{Method}}; Old{{Method}} = hookfunction(Event.{{Method}}, function(...)
	local self = ...

	if rawequal(self, Event) then
		local Args = table.pack(...)

		local Result = table.pack(
			Old{{Method}}(table.unpack(Args, 1, Args.n))
		)

		return table.unpack(Result, 1, Result.n)
	end

	return Old{{Method}}(self, ...)
end)]]

HookTemplates.IncomingCallbackValue = [[{{Prelude}}{{Path}}
local Callback = getcallbackvalue(Event, "{{Method}}")
Event.{{Method}} = function(...)
	print(`Intercepted (Callback) {Event.Name}.{{Method}}`, ...)
	return Callback(...)
end

local mtHook; mtHook = hookmetamethod(game, "__newindex", function(...)
	local self, key, value = ...
	
	if (
		rawequal(self, Event) and
		rawequal(key, "{{Method}}") and
		typeof(value) == "function" and
		not checkcaller()
	) then
		Callback = value
	end

	return mtHook(...)
end)]]

HookTemplates.IncomingSignalConnections = [[{{Prelude}}{{Path}}
for _, Connection in getconnections(Event.{{Method}}) do
	local old; old = hookfunction(Connection.Function, function(...)
		print(`Intercepted (Connection) {Event.Name}.{{Method}}`, ...)
		return old(...)
	end)
end]]

HookTemplates.OutgoingRemoteCall = [[{{Prelude}}{{Path}}
local mtHook; mtHook = hookmetamethod(game, "__namecall", function(...)
	local self = ...

	if rawequal(self, Event) and getnamecallmethod() == "{{Method}}" then
		local Args = table.pack(...)
		
		local Result = table.pack(
			mtHook(self, table.unpack(Args, 1, Args.n))
		)

		print(`Intercepted (__namecall) {Event.Name}:{{Method}}()`, ...)

		return table.unpack(Result, 1, Result.n)
	end

	return mtHook(...)
end)

local Old{{Method}}; Old{{Method}} = hookfunction(Event.{{Method}}, function(...)
	local self = ...

	if rawequal(self, Event) then
		local Args = table.pack(...)

		local Result = table.pack(
			Old{{Method}}(table.unpack(Args, 1, Args.n))
		)

		print(`Intercepted (__index) {Event.Name}:{{Method}}()`, self, table.unpack(Result, 1, Result.n))

		return table.unpack(Result, 1, Result.n)
	end

	return Old{{Method}}(self, ...)
end)]]

HookTemplates.Incoming = {
	SSE = {
		Callback = HookTemplates.IncomingCallbackReturn,
		Default = HookTemplates.IncomingCallbackValue,
	},
	Request = HookTemplates.IncomingRequestReturn,
	Signal = HookTemplates.IncomingSignalConnections,
}

HookTemplates.Outgoing = HookTemplates.OutgoingRemoteCall

return HookTemplates

end)() end,
    [41] = function()local wax,script,require,CreateLookupTable=ImportGlobals(41)local ImportGlobals return (function(...)local GetNilCode = [[local function GetNil(Name, DebugId)
	for _, Object in getnilinstances() do
		if Object.Name == Name and Object:GetDebugId() == DebugId then
			return Object
		end
	end
end]]

local GetEventReferenceCode = [[local function GetEventReference(options)
	local Hash, Index, ExcludeExecutor, Path = options.Hash, options.Index, options.ExcludeExecutor, options.Path
	local Retrieved = nil

	if filtergc then
		Retrieved = filtergc("function", {
			Hash = Hash,
			IgnoreExecutor = ExcludeExecutor
		}, true)
	else
		for _, Func in getgc() do
			if typeof(Func) ~= "function" then
				continue
			end

			if ExcludeExecutor and isexecutorclosure(Func) then
				continue
			end
			
			if getfunctionhash(Func) == Hash then
				Retrieved = Func
				break
			end
		end
	end

	assert(Retrieved, "Could not find function with hash " .. tostring(Hash))
	local Value = debug.getupvalue(Retrieved, Index)

	if Path then
		for _, Key in next, Path do
			Value = Value[Key]
		end
	end

	return Value
end]]

return {
    GetNilCode = GetNilCode,
    GetEventReferenceCode = GetEventReferenceCode,
}
end)() end,
    [43] = function()local wax,script,require,CreateLookupTable=ImportGlobals(43)local ImportGlobals return (function(...)export type SupportedRemoteTypes = RemoteEvent | RemoteFunction | BindableEvent | BindableFunction | UnreliableRemoteEvent
export type Direction = "Incoming" | "Outgoing"

export type CallInfo = {
	Arguments: { [number]: any, n: number },
	CreationTime: number,
	Origin: BaseScript?,
	Function: (
		...any
	) -> any | {
		Address: string,
		Name: string,
		Source: string?,
		IsC: boolean,
		Constants: { any }?,
		Upvalues: { any }?,
		Protos: { any }?,
		FunctionHash: string?,
	},
	Line: number?,
	Source: string?,
	Instance: SupportedRemoteTypes,
	Order: number,
	Type: Direction,
	InvokeResult: { [number]: any, n: number }?,
	Error: string?,
	InvokeKind: "Callback" | "Request"?,
	IsExecutor: boolean?,
	IsRakNet: boolean?,
	IsActor: true?,
	Path: string?,
	Actor: Actor?,
	Blocked: boolean?,
}

export type Scenario = {
	Type: Direction,
	Direction: Direction,
	Class: string,
	Method: string,
	Arguments: { [number]: any, n: number },
	Result: { [number]: any, n: number }?,
	Error: string?,
	InvokeKind: ("Callback" | "Request")?,
	Shape: "Request" | "SSE" | "Signal",
}

return {}

end)() end,
    [44] = function()local wax,script,require,CreateLookupTable=ImportGlobals(44)local ImportGlobals return (function(...)local Connections = {}

local function Connect(Connection)
	table.insert(Connections, Connection)
	return Connection
end

local function Disconnect(Connection)
	Connection:Disconnect()

	local Index = table.find(Connections, Connection)
	if Index then
		table.remove(Connections, Index)
	end

	return true
end

wax.shared.Connections = Connections
wax.shared.Connect = Connect
wax.shared.Disconnect = Disconnect

return Connect

end)() end,
    [45] = function()local wax,script,require,CreateLookupTable=ImportGlobals(45)local ImportGlobals return (function(...)local FileHelper = {}
FileHelper.__index = FileHelper

local function IsFilesystemAvailable(): boolean
    local ExecutorSupport = wax.shared.ExecutorSupport
    return ExecutorSupport ~= nil
        and ExecutorSupport.FileSystem ~= nil
        and ExecutorSupport.FileSystem.IsWorking
end

--[[
    Creates a new FileHelper instance.

    @param basePath: The base path to use for the FileHelper.
    @return FileHelper: The new FileHelper instance.
]]
function FileHelper.new(basePath: string)
    local self = setmetatable({
        BasePath = FileHelper.NormalizePath(basePath),
    }, FileHelper)

    self:EnsureDirectory()
    return self
end

--[[
    Ensures that the directory exists.

    @return: None.
]]
function FileHelper:EnsureDirectory()
    if not IsFilesystemAvailable() then return end

    local paths = {}
    local parts = self.BasePath:split("/")

    for idx = 1, #parts do
        if parts[idx] == "" then continue end
        paths[#paths + 1] = table.concat(parts, "/", 1, idx)
    end

    for i = 1, #paths do
        local str = paths[i]
        if isfolder(str) then continue end
        makefolder(str)
    end
end

--[[
    Gets the path to the file.
    @param relativePath: The relative path to the file.
    @return: The path to the file.
]]
function FileHelper:GetPath(relativePath: string)
    local normalizedPath = self.NormalizePath(relativePath or "")
    
    if self.BasePath == "" then
        return normalizedPath
    end
    
    if self.BasePath:sub(-1) == "/" then
        return self.BasePath .. normalizedPath
    end
    
    if normalizedPath == "" then
        return self.BasePath
    end
    
    return self.BasePath .. "/" .. normalizedPath
end

--[[
    Normalizes a path.
    @param path: The path to normalize.
    @return: The normalized path.
]]
function FileHelper.NormalizePath(path: string)
    if type(path) ~= "string" then return "" end
    return path:gsub("\\", "/")
end

--[[
    Gets the relative path to the file.
    @param path: The path to get the relative path of.
    @return: The relative path.
]]
function FileHelper:GetRelativePath(path: string)
    path = self.NormalizePath(path)
    local basePath = self.NormalizePath(self.BasePath)
    if basePath:sub(-1) ~= "/" then
        basePath = basePath .. "/"
    end
    
    local Start, End = string.find(path, basePath, 1, true)
    if Start then
        return string.sub(path, End + 1)
    end
    
    return path
end

--[[
    Ensures that the file exists.
    @param relativePath: The relative path to the file.
    @param default: The default content to write to the file.
    @return: None.
]]
function FileHelper:EnsureFile(relativePath: string, default: string)
    if not IsFilesystemAvailable() then return end

    relativePath = self.NormalizePath(relativePath or "")
    
    if not isfile(self:GetPath(relativePath)) then
        writefile(self:GetPath(relativePath), default)
    end
end

--[[
    Checks if a file or directory exists.
    @param relativePath: The relative path to the file or directory.
    @return: True if the file or directory exists, false otherwise.
]]
function FileHelper:DoesExist(relativePath: string)
    if not IsFilesystemAvailable() then return false end

    relativePath = self.NormalizePath(relativePath or "")
    local path = self:GetPath(relativePath)

    local fileSuccess = pcall(assert, isfile(path), "File does not exist.")
    local folderSuccess = pcall(assert, isfolder(path), "Directory does not exist.")

    return fileSuccess or folderSuccess
end

--[[
    Reads the contents of a file.
    @param relativePath: The relative path to the file.
    @return: The contents of the file.
]]
function FileHelper:ReadFile(relativePath: string)
    if not IsFilesystemAvailable() then return nil end

    relativePath = self.NormalizePath(relativePath or "")
    return readfile(self:GetPath(relativePath))
end

--[[
    Reads the contents of a file.
    @param path: The path to the file.
    @return: The contents of the file.
]]
function FileHelper:ReadRawFile(path: string)
    if not IsFilesystemAvailable() then return nil end

    return readfile(path)
end

--[[
    Writes the contents of a file.
    @param relativePath: The relative path to the file.
    @param data: The contents to write to the file.
    @return: None.
]]
function FileHelper:WriteFile(relativePath: string, data: string)
    if not IsFilesystemAvailable() then return end

    relativePath = self.NormalizePath(relativePath or "")
    
    writefile(self:GetPath(relativePath), data)
end

--[[
    Appends contents to a file.
    @param relativePath: The relative path to the file.
    @param data: The contents to append to the file.
    @return: None.
]]
function FileHelper:AppendFile(relativePath: string, data: string)
    if not IsFilesystemAvailable() then return end

    relativePath = self.NormalizePath(relativePath or "")
    
    appendfile(self:GetPath(relativePath), data)
end

--[[
    Deletes a file.
    @param relativePath: The relative path to the file.
    @return: None.
]]
function FileHelper:DeleteFile(relativePath: string)
    if not IsFilesystemAvailable() then return end

    relativePath = self.NormalizePath(relativePath or "")
    
    if isfile(self:GetPath(relativePath)) then
        delfile(self:GetPath(relativePath))
    end
end

--[[
    Deletes a directory.
    @param relativePath: The relative path to the directory.
    @return: None.
]]
function FileHelper:DeleteDirectory(relativePath: string)
    if not IsFilesystemAvailable() then return end

    relativePath = self.NormalizePath(relativePath or "")
    
    if isfolder(self:GetPath(relativePath)) then
        delfolder(self:GetPath(relativePath))
    end
end

--[[
    Lists the files in a directory.
    @param relativePath: The relative path to the directory.
    @return: The files in the directory.
]]
function FileHelper:ListFiles(relativePath: string?)
    if not IsFilesystemAvailable() then return {} end

    relativePath = self.NormalizePath(relativePath or "")
    
    local files = {}
    for _, file in listfiles(self:GetPath(relativePath)) do
        table.insert(files, self:GetRelativePath(file))
    end

    return files
end

--[[
    Gets the file name from a path.
    @param relativePath: The relative path to the file.
    @return: The file name.
]]
function FileHelper:GetFileName(relativePath: string)
    relativePath = self.NormalizePath(relativePath or "")
    
    return relativePath:match("[^/]+$")
end

--[[
    Lists the file names in a directory.
    @param relativePath: The relative path to the directory.
    @return: The file names in the directory.
]]
function FileHelper:ListFileNames(relativePath: string?)
    relativePath = self.NormalizePath(relativePath or "")
    
    local names = {}
    for _, file in self:ListFiles(relativePath) do
        table.insert(names, self:GetFileName(file))
    end

    return names
end

return FileHelper

end)() end,
    [46] = function()local wax,script,require,CreateLookupTable=ImportGlobals(46)local ImportGlobals return (function(...)-- Logger
-- ActualMasterOogway
-- December 8, 2024

--[=[
    A simple logging utility that writes messages to a file. Supports different log levels
    and can be configured to overwrite or append to the log file.

    Log Format:  2024-12-04T15:28:31.131Z,0.131060,MyThread,Warning [FLog::RobloxStarter] Roblox stage ReadyForFlagFetch completed
                 <timestamp>,<elapsed_time>,<thread_id>,<level> <message>
]=]

local Logger = {}
Logger.__index = Logger

local FileHelper = require(script.Parent.FileHelper)

Logger.LOG_LEVELS = {
	ERROR = 1,
	WARNING = 2,
	INFO = 3,
	DEBUG = 4,
}

local LOG_LEVEL_STRINGS = {
	[Logger.LOG_LEVELS.ERROR] = "ERROR",
	[Logger.LOG_LEVELS.WARNING] = "WARNING",
	[Logger.LOG_LEVELS.INFO] = "INFO",
	[Logger.LOG_LEVELS.DEBUG] = "DEBUG",
}

local startTime = tick()

local function SplitFilePath(path: string): (string, string)
	local normalizedPath = FileHelper.NormalizePath(path)
	local directory, fileName = normalizedPath:match("^(.*)/([^/]*)$")

	return directory or "", fileName or normalizedPath
end

--[=[
    Generates a unique file name for the log file. The file name is based on the current
    job ID, ensuring it is unique per server instance but consistent across multiple
    executions within the same server.

    @return string A unique file name for the log file.
]=]
function Logger:GenerateFileName()
	local JobIdNumber = game.JobId:gsub("%D", "")
	local timestamp = os.date("!%Y%m%d%H%M%S")
	local fileName = `{JobIdNumber * 1.7 // 1.8}_{timestamp}.log`

	if self.logFileDirectory == "" then
		return fileName
	end

	return `{self.logFileDirectory}/{fileName}`
end

--[=[
    Creates a new Logger instance.

    @param logFilePath string The path to the log file.
    @param logLevel number The minimum log level to write to the file. Defaults to INFO.
    @param overwrite boolean Whether to overwrite the log file or append to it. Defaults to false (append).
    @return Logger A new Logger instance.
]=]
function Logger.new(logFilePath: string, logLevel: number?, overwrite: boolean?)
	local self = setmetatable({}, Logger)
	local logFileDirectory, logFileName = SplitFilePath(logFilePath)

	self.fileHelper = FileHelper.new(logFileDirectory)
	self.logFileName = logFileName
	self.logFileDirectory = logFileDirectory
	self.logFilePath = self.fileHelper:GetPath(logFileName)
	self.logLevel = logLevel or Logger.LOG_LEVELS.INFO
	self.overwrite = overwrite or false

	local success, err = pcall(function()
		if self.overwrite then
			self.fileHelper:WriteFile(self.logFileName, "")
		else
			self.fileHelper:EnsureFile(self.logFileName, "")
		end
	end)
	if not success then
		warn(debug.traceback(`Failed to initialize log file: {self.logFilePath} - {err}`, 2))
	end

	self:Info("Logger", "Logger initialized")

	return self
end

--[=[
    Logs a message to the file.

    @param level number The log level of the message.
    @param threadId string The ID of the thread or source of the log message.
    @param message string The message to log.
]=]
function Logger:Log(level: number, threadId: string, message: string)
	if level <= self.logLevel then
		local levelStr = LOG_LEVEL_STRINGS[level]

		local timestamp = `{os.date("!%Y-%m-%dT%H:%M:%S")}{("%.3f"):format(tick() % 1)}Z`
		local elapsedTime = ("%.6f"):format(tick() - startTime)

		local logMessage = `{timestamp},{elapsedTime},{threadId},{levelStr} {message}\n`

		local success, err = pcall(self.fileHelper.AppendFile, self.fileHelper, self.logFileName, logMessage)
		if not success then
			warn(debug.traceback(`Failed to write to log file: {self.logFilePath} - {err}`, 2))
		end
	end
end

--[=[
    Logs a debug message.

    @param threadId string The ID of the thread or source of the log message.
    @param message string The message to log.
]=]
function Logger:Debug(threadId: string, message: string)
	self:Log(Logger.LOG_LEVELS.DEBUG, threadId, message)
end

--[=[
    Logs an info message.

    @param threadId string The ID of the thread or source of the log message.
    @param message string The message to log.
]=]
function Logger:Info(threadId: string, message: string)
	self:Log(Logger.LOG_LEVELS.INFO, threadId, message)
end

--[=[
    Logs a warning message.

    @param threadId string The ID of the thread or source of the log message.
    @param message string The message to log.
]=]
function Logger:Warning(threadId: string, message: string)
	self:Log(Logger.LOG_LEVELS.WARNING, threadId, message)
end

--[=[
    Logs an error message.

    @param threadId string The ID of the thread or source of the log message.
    @param message string The message to log.
]=]
function Logger:Error(threadId: string, message: string)
	self:Log(Logger.LOG_LEVELS.ERROR, threadId, message)
end

return Logger

end)() end,
    [48] = function()local wax,script,require,CreateLookupTable=ImportGlobals(48)local ImportGlobals return (function(...)local Hooking = {}

Hooking.HookFunction = function(Original, Replacement, Filter)
	if
		wax.shared.IsUsingOthHooks
		and iscclosure(Original)
	then
		return oth.hook(Original, Replacement, Filter)
	end

	if islclosure(Replacement) then
		Replacement = wax.shared.newcclosure(Replacement)
	end

	if not wax.shared.ExecutorSupport["hookfunction"].IsWorking then
		return Original
	end

	return hookfunction(Original, Replacement, Filter)
end

Hooking.HookMetaMethod = function(object, method, hook, filter)
	local Metatable = wax.shared.getrawmetatable(object)
	local originalMethod = rawget(Metatable, method)

	assert(typeof(originalMethod) == "function", `{method} is not a function in the metatable of {object}`)

	if wax.shared.IsUsingOthHooks then
		return oth.hook(originalMethod, hook, filter)
	end

	if islclosure(hook) then
		hook = wax.shared.newcclosure(hook)
	end

	if
		not wax.shared.ExecutorSupport["hookmetamethod"].IsWorking
		and wax.shared.ExecutorSupport["getrawmetatable"].IsWorking
	then
		setreadonly(Metatable, false)
		rawset(Metatable, method, hook)
		setreadonly(Metatable, true)

		return originalMethod
	end

	if not wax.shared.ExecutorSupport["hookmetamethod"].IsWorking then
		if method == "__index" then
			local _, Metamethod = xpcall(function()
				return object[tostring(math.random())]
			end, function(err)
				return debug.info(2, "f")
			end)

			return Metamethod
		elseif method == "__newindex" then
			local _, Metamethod = xpcall(function()
				object[tostring(math.random())] = true
			end, function(err)
				return debug.info(2, "f")
			end)

			return Metamethod
		elseif method == "__namecall" then
			local _, Metamethod = xpcall(function()
				object:Mustard()
			end, function(err)
				return debug.info(2, "f")
			end)

			return Metamethod
		end

		return nil
	end

	if filter then
		return hookmetamethod(object, method, hook, true, filter)
	end
	
	return hookmetamethod(object, method, hook)
end

return Hooking

end)() end,
    [50] = function()local wax,script,require,CreateLookupTable=ImportGlobals(50)local ImportGlobals return (function(...)local Codec = {}

-- Network CFrame specials use the same sparse rot_id bytes as rbx-dom/attributes
local CFRAME_SPECIALS: { [number]: { number } } = {
	[0x02] = { 1, 0, 0, 0, 1, 0, 0, 0, 1 },
	[0x03] = { 1, 0, 0, 0, 0, -1, 0, 1, 0 },
	[0x05] = { 1, 0, 0, 0, -1, 0, 0, 0, -1 },
	[0x06] = { 1, 0, 0, 0, 0, 1, 0, -1, 0 },
	[0x07] = { 0, 1, 0, 1, 0, 0, 0, 0, -1 },
	[0x09] = { 0, 0, 1, 1, 0, 0, 0, 1, 0 },
	[0x0A] = { 0, -1, 0, 1, 0, 0, 0, 0, 1 },
	[0x0C] = { 0, 0, -1, 1, 0, 0, 0, -1, 0 },
	[0x0D] = { 0, 1, 0, 0, 0, 1, 1, 0, 0 },
	[0x0E] = { 0, 0, -1, 0, 1, 0, 1, 0, 0 },
	[0x10] = { 0, -1, 0, 0, 0, -1, 1, 0, 0 },
	[0x11] = { 0, 0, 1, 0, -1, 0, 1, 0, 0 },
	[0x14] = { -1, 0, 0, 0, 1, 0, 0, 0, -1 },
	[0x15] = { -1, 0, 0, 0, 0, 1, 0, 1, 0 },
	[0x17] = { -1, 0, 0, 0, -1, 0, 0, 0, 1 },
	[0x18] = { -1, 0, 0, 0, 0, -1, 0, -1, 0 },
	[0x19] = { 0, 1, 0, -1, 0, 0, 0, 0, 1 },
	[0x1B] = { 0, 0, -1, -1, 0, 0, 0, 1, 0 },
	[0x1C] = { 0, -1, 0, -1, 0, 0, 0, 0, -1 },
	[0x1E] = { 0, 0, 1, -1, 0, 0, 0, -1, 0 },
	[0x1F] = { 0, 1, 0, 0, 0, -1, -1, 0, 0 },
	[0x20] = { 0, 0, 1, 0, 1, 0, -1, 0, 0 },
	[0x22] = { 0, -1, 0, 0, 0, 1, -1, 0, 0 },
	[0x23] = { 0, 0, -1, 0, -1, 0, -1, 0, 0 },
}

function Codec.LEB128(data: buffer, offset: number): (number, number)
	local result = 0
	local shift = 0
	for i = offset, offset + 8 do
		local byte = buffer.readu8(data, i)
		result = bit32.bor(result, bit32.lshift(bit32.band(byte, 0x7F), shift))
		shift += 7
		if bit32.band(byte, 0x80) == 0 then
			return result, i + 1
		end
	end
	return result, offset + 9
end

-- Unsigned LEB128 via number arithmetic (safe past 32-bit).
function Codec.LEB128U(data: buffer, offset: number): (number, number)
	local result = 0
	local mult = 1
	for i = offset, offset + 9 do
		local byte = buffer.readu8(data, i)
		result += (byte % 128) * mult
		if byte < 128 then
			return result, i + 1
		end
		mult *= 128
	end
	return result, offset + 10
end

-- Zigzag signed-int decode
function Codec.ZzDec(n: number): number
	if n % 2 == 1 then
		return -(n // 2) - 1
	else
		return n // 2
	end
end

type NullRef = { is_null: true }
type ValidRef = { is_null: false, peer_id: number, instance_id: number }
export type InstanceRef = NullRef | ValidRef

function Codec.ReadInstanceRef(data: buffer, offset: number): (InstanceRef, number)
	local peer_id, next_offset = Codec.LEB128(data, offset)
	if peer_id == 0 then
		return { is_null = true }, next_offset
	end
	local instance_id = buffer.readu32(data, next_offset)
	return {
		is_null = false,
		peer_id = peer_id,
		instance_id = instance_id,
	}, next_offset + 4
end

local function makeCFrame(x: number, y: number, z: number, rot: { number }): CFrame
	return CFrame.new(x, y, z, rot[1], rot[2], rot[3], rot[4], rot[5], rot[6], rot[7], rot[8], rot[9])
end

-- Custom network rotation: 48-bit smallest-three quaternion.
-- Layout: c0:15 | pad:1 | c1:15 | c2:15 | maxIndex:2
-- Components are scaled by 0x3FFF*√2 and packed in XZY order relative to the
-- ascending list of non-omitted axes. maxIndex is which of X,Y,Z,W was dropped.
local ROT_SCALE = 0x3FFF * math.sqrt(2)

local function readBits48(
	b0: number,
	b1: number,
	b2: number,
	b3: number,
	b4: number,
	b5: number,
	start: number,
	len: number
): number
	local bytes = { b0, b1, b2, b3, b4, b5 }
	local v = 0
	for i = 0, len - 1 do
		local bitIndex = start + i
		local byteIndex = bitIndex // 8 + 1
		local bitInByte = bitIndex % 8
		if bit32.band(bytes[byteIndex], bit32.lshift(1, bitInByte)) ~= 0 then
			v += 2 ^ i
		end
	end
	return v
end

local function signExtend15(v: number): number
	if v >= 0x4000 then
		return v - 0x8000
	end
	return v
end

function Codec.ReadCompressedRotation(data: buffer, offset: number): (number, number, number, number, number)
	local b0 = buffer.readu8(data, offset)
	local b1 = buffer.readu8(data, offset + 1)
	local b2 = buffer.readu8(data, offset + 2)
	local b3 = buffer.readu8(data, offset + 3)
	local b4 = buffer.readu8(data, offset + 4)
	local b5 = buffer.readu8(data, offset + 5)

	local c0 = signExtend15(readBits48(b0, b1, b2, b3, b4, b5, 0, 15))
	local c1 = signExtend15(readBits48(b0, b1, b2, b3, b4, b5, 16, 15))
	local c2 = signExtend15(readBits48(b0, b1, b2, b3, b4, b5, 31, 15))
	local maxIndex = readBits48(b0, b1, b2, b3, b4, b5, 46, 2)

	-- Wire order is XZY relative to ascending non-omitted axes → undo to XYZ-order fill
	local ordered = { c0 / ROT_SCALE, c2 / ROT_SCALE, c1 / ROT_SCALE }
	local q = table.create(4)
	local vi = 1
	for i = 0, 3 do
		if i == maxIndex then
			q[i + 1] = 0
		else
			q[i + 1] = ordered[vi]
			vi += 1
		end
	end

	local sumsq = 0
	for i = 1, 4 do
		if i ~= maxIndex + 1 then
			sumsq += q[i] * q[i]
		end
	end
	q[maxIndex + 1] = math.sqrt(math.max(0, 1 - sumsq))

	return q[1], q[2], q[3], q[4], offset + 6
end

-- 0x1A / 0x1B: pos(3×f32) + rot_id(1b) [+ optional 6-byte quat]
function Codec.ReadCFrameV1(data: buffer, offset: number): (CFrame, number)
	local x = buffer.readf32(data, offset)
	local y = buffer.readf32(data, offset + 4)
	local z = buffer.readf32(data, offset + 8)
	offset += 12

	local rid = buffer.readu8(data, offset)
	offset += 1

	if rid == 0 then
		local qx, qy, qz, qw
		qx, qy, qz, qw, offset = Codec.ReadCompressedRotation(data, offset)
		return CFrame.new(x, y, z, qx, qy, qz, qw), offset
	end

	local special = CFRAME_SPECIALS[rid]
	if special then
		return makeCFrame(x, y, z, special), offset
	end
	return CFrame.new(x, y, z), offset
end

-- 0x32 / 0x33: flags(1b); 0=nil; else rot (+ optional 6-byte quat) then pos(3×f32)
function Codec.ReadOptCFrame(data: buffer, offset: number): (CFrame?, number)
	local fb = buffer.readu8(data, offset)
	offset += 1
	if fb == 0 then
		return nil, offset
	end

	local rid = bit32.band(fb, 0x7F)
	local x: number, y: number, z: number
	if rid == 0 then
		local qx, qy, qz, qw
		qx, qy, qz, qw, offset = Codec.ReadCompressedRotation(data, offset)
		x = buffer.readf32(data, offset)
		y = buffer.readf32(data, offset + 4)
		z = buffer.readf32(data, offset + 8)
		return CFrame.new(x, y, z, qx, qy, qz, qw), offset + 12
	end

	local rot = CFRAME_SPECIALS[rid] or { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
	x = buffer.readf32(data, offset)
	y = buffer.readf32(data, offset + 4)
	z = buffer.readf32(data, offset + 8)
	return makeCFrame(x, y, z, rot), offset + 12
end

function Codec.ReadUInt64(data: buffer, offset: number): (number, number)
	local lo = buffer.readu32(data, offset)
	local hi = buffer.readu32(data, offset + 4)
	return lo + hi * 0x100000000, offset + 8
end

return Codec

end)() end,
    [51] = function()local wax,script,require,CreateLookupTable=ImportGlobals(51)local ImportGlobals return (function(...)local NetworkSchema = {}
local EnumLookupTable = {}
do
	if raknet and raknet.get_network_schema then
		NetworkSchema = raknet.get_network_schema()
	end
	
	for _, enumType in Enum:GetEnums() do 
		local cleanName = string.gsub(tostring(enumType), "Enum%.", "")
		EnumLookupTable[cleanName] = enumType
	end 
end


local NetworkTypeIds = NetworkSchema.type_ids
local function ResolveType(Name: string, Fallback: number): number
	if NetworkTypeIds then
		local TypeId = NetworkTypeIds[Name]
		return TypeId or Fallback
	end
	
	return Fallback
end

-- Wire: u16(enumTypeId) + LEB128(value).
-- typeId is an engine reflection id (NOT Enum:GetEnums() order).
local TYPE_ID_TO_ENUM: { [number]: Enum? } = {
	[0] = EnumLookupTable.AccessModifierType,
	[1] = EnumLookupTable.AccessoryType,
	[2] = EnumLookupTable.ActionType,
	[3] = EnumLookupTable.ActivePayerStatus,
	[4] = EnumLookupTable.ActuatorRelativeTo,
	[5] = EnumLookupTable.ActuatorType,
	[6] = EnumLookupTable.AdAvailabilityResult,
	[7] = EnumLookupTable.AdEventType,
	[8] = EnumLookupTable.AdFormat,
	[9] = EnumLookupTable.AdShape,
	[10] = EnumLookupTable.AdTeleportMethod,
	[11] = EnumLookupTable.AdUIEventType,
	[12] = EnumLookupTable.AdUIType,
	[13] = EnumLookupTable.AdUnitStatus,
	[14] = EnumLookupTable.AdornCullingMode,
	[15] = EnumLookupTable.AdornShading,
	[16] = EnumLookupTable.AgeCheckStatus,
	[17] = EnumLookupTable.AlignType,
	[18] = EnumLookupTable.AlphaMode,
	[19] = EnumLookupTable.AnalyticsCustomFieldKeys,
	[20] = EnumLookupTable.AnalyticsEconomyAction,
	[21] = EnumLookupTable.AnalyticsEconomyFlowType,
	[22] = EnumLookupTable.AnalyticsEconomyTransactionType,
	[23] = EnumLookupTable.AnalyticsLogLevel,
	[24] = EnumLookupTable.AnalyticsProgressionStatus,
	[25] = EnumLookupTable.AnalyticsProgressionType,
	[26] = EnumLookupTable.AnimationClipFromVideoStatus,
	[27] = EnumLookupTable.AnimationNodeBlend2DInputMode,
	[28] = EnumLookupTable.AnimationNodeInterruptible,
	[29] = EnumLookupTable.AnimationNodePhaseSync,
	[30] = EnumLookupTable.AnimationNodePlayMode,
	[31] = EnumLookupTable.AnimationNodeTransitionType,
	[32] = EnumLookupTable.AnimationNodeType,
	[33] = EnumLookupTable.AnimationNodeWaitFor,
	[34] = EnumLookupTable.AnimationPriority,
	[35] = EnumLookupTable.AnimatorRetargetingMode,
	[41] = EnumLookupTable.AntiAliasing,
	[42] = EnumLookupTable.AppLifecycleManagerState,
	[43] = EnumLookupTable.AppShellActionType,
	[44] = EnumLookupTable.AppShellFeature,
	[45] = EnumLookupTable.AppUpdateStatus,
	[46] = EnumLookupTable.ApplyStrokeMode,
	[47] = EnumLookupTable.AspectType,
	[48] = EnumLookupTable.AssetCreatorType,
	[49] = EnumLookupTable.AssetFetchStatus,
	[50] = EnumLookupTable.AssetRepresentation,
	[51] = EnumLookupTable.AssetType,
	[52] = EnumLookupTable.AssetTypeVerification,
	[53] = EnumLookupTable.AudioApiRollout,
	[55] = EnumLookupTable.AudioChannelLayout,
	[56] = EnumLookupTable.AudioFilterType,
	[57] = EnumLookupTable.AudioSimulationFidelity,
	[58] = EnumLookupTable.AudioSubType,
	[59] = EnumLookupTable.AudioWindowSize,
	[60] = EnumLookupTable.AuthorityMode,
	[61] = EnumLookupTable.AutomaticSize,
	[62] = EnumLookupTable.AvatarAssetType,
	[63] = EnumLookupTable.AvatarChatServiceFeature,
	[64] = EnumLookupTable.AvatarContextMenuOption,
	[65] = EnumLookupTable.AvatarGenerationError,
	[66] = EnumLookupTable.AvatarItemType,
	[67] = EnumLookupTable.AvatarPromptResult,
	[68] = EnumLookupTable.AvatarSettingsAccessoryLimitMethod,
	[69] = EnumLookupTable.AvatarSettingsAccessoryMode,
	[70] = EnumLookupTable.AvatarSettingsAnimationClipsMode,
	[71] = EnumLookupTable.AvatarSettingsAnimationPacksMode,
	[72] = EnumLookupTable.AvatarSettingsAppearanceMode,
	[73] = EnumLookupTable.AvatarSettingsBuildMode,
	[74] = EnumLookupTable.AvatarSettingsCharacterControllerMode,
	[75] = EnumLookupTable.AvatarSettingsClothingMode,
	[76] = EnumLookupTable.AvatarSettingsCollisionMode,
	[77] = EnumLookupTable.AvatarSettingsCustomAccessoryMode,
	[78] = EnumLookupTable.AvatarSettingsCustomBodyType,
	[79] = EnumLookupTable.AvatarSettingsCustomClothingMode,
	[80] = EnumLookupTable.AvatarSettingsHitAndTouchDetectionMode,
	[81] = EnumLookupTable.AvatarSettingsJumpMode,
	[82] = EnumLookupTable.AvatarSettingsLegacyCollisionMode,
	[83] = EnumLookupTable.AvatarSettingsScaleMode,
	[84] = EnumLookupTable.AvatarThumbnailCustomizationType,
	[85] = EnumLookupTable.AvatarUnificationMode,
	[86] = EnumLookupTable.Axis,
	[87] = EnumLookupTable.BenefitType,
	[88] = EnumLookupTable.BinType,
	[89] = EnumLookupTable.BodyPart,
	[90] = EnumLookupTable.BodyPartR15,
	[91] = EnumLookupTable.BorderMode,
	[92] = EnumLookupTable.BorderStrokePosition,
	[93] = EnumLookupTable.BreakReason,
	[94] = EnumLookupTable.BulkMoveMode,
	[95] = EnumLookupTable.BundleType,
	[96] = EnumLookupTable.Button,
	[97] = EnumLookupTable.ButtonStyle,
	[98] = EnumLookupTable.CageType,
	[99] = EnumLookupTable.CameraMode,
	[100] = EnumLookupTable.CameraPanMode,
	[101] = EnumLookupTable.CameraType,
	[103] = EnumLookupTable.CaptureGalleryPermission,
	[104] = EnumLookupTable.CaptureType,
	[105] = EnumLookupTable.CatalogCategoryFilter,
	[106] = EnumLookupTable.CatalogSortAggregation,
	[107] = EnumLookupTable.CatalogSortType,
	[108] = EnumLookupTable.CellBlock,
	[109] = EnumLookupTable.CellMaterial,
	[110] = EnumLookupTable.CellOrientation,
	[111] = EnumLookupTable.CenterDialogType,
	[112] = EnumLookupTable.CharacterControlMode,
	[113] = EnumLookupTable.ChatCallbackType,
	[114] = EnumLookupTable.ChatColor,
	[115] = EnumLookupTable.ChatMode,
	[116] = EnumLookupTable.ChatPrivacyMode,
	[117] = EnumLookupTable.ChatRestrictionStatus,
	[118] = EnumLookupTable.ChatStyle,
	[119] = EnumLookupTable.ChatVersion,
	[120] = EnumLookupTable.ClientAnimatorThrottlingMode,
	[121] = EnumLookupTable.CloseReason,
	[123] = EnumLookupTable.CollisionFidelity,
	[124] = EnumLookupTable.CommandPermission,
	[125] = EnumLookupTable.CompositeValueCurveType,
	[126] = EnumLookupTable.CompressionAlgorithm,
	[127] = EnumLookupTable.ComputerCameraMovementMode,
	[128] = EnumLookupTable.ComputerMovementMode,
	[129] = EnumLookupTable.ConfigSnapshotErrorState,
	[130] = EnumLookupTable.ConnectionError,
	[131] = EnumLookupTable.ConnectionState,
	[132] = EnumLookupTable.ContentSourceType,
	[133] = EnumLookupTable.ContextActionPriority,
	[134] = EnumLookupTable.ContextActionResult,
	[135] = EnumLookupTable.ControlMode,
	[136] = EnumLookupTable.CoreGuiType,
	[137] = EnumLookupTable.CreateAssetResult,
	[138] = EnumLookupTable.CreateContentResult,
	[139] = EnumLookupTable.CreateOutfitFailure,
	[140] = EnumLookupTable.CreatorType,
	[141] = EnumLookupTable.CreatorTypeFilter,
	[142] = EnumLookupTable.CurrencyType,
	[143] = EnumLookupTable.CustomCameraMode,
	[144] = EnumLookupTable.DataModelExtractorFileType,
	[145] = EnumLookupTable.DataStoreRequestType,
	[146] = EnumLookupTable.DebugBreakModeType,
	[147] = EnumLookupTable.DebuggerResumeType,
	[148] = EnumLookupTable.DevCameraOcclusionMode,
	[149] = EnumLookupTable.DevComputerCameraMovementMode,
	[150] = EnumLookupTable.DevComputerMovementMode,
	[151] = EnumLookupTable.DevTouchCameraMovementMode,
	[152] = EnumLookupTable.DevTouchMovementMode,
	[153] = EnumLookupTable.DeveloperMemoryTag,
	[154] = EnumLookupTable.DeviceFeatureType,
	[155] = EnumLookupTable.DeviceForm,
	[156] = EnumLookupTable.DeviceLevel,
	[157] = EnumLookupTable.DeviceType,
	[158] = EnumLookupTable.DialogBehaviorType,
	[159] = EnumLookupTable.DialogPurpose,
	[160] = EnumLookupTable.DialogTone,
	[161] = EnumLookupTable.DigitsRigDescriptionSide,
	[162] = EnumLookupTable.DiscountType,
	[163] = EnumLookupTable.DisplayScalingMode,
	[164] = EnumLookupTable.DisplaySize,
	[165] = EnumLookupTable.DomainType,
	[166] = EnumLookupTable.DominantAxis,
	[167] = EnumLookupTable.DragDetectorDragStyle,
	[168] = EnumLookupTable.DragDetectorPermissionPolicy,
	[169] = EnumLookupTable.DragDetectorResponseStyle,
	[170] = EnumLookupTable.DraggingScrollBar,
	[171] = EnumLookupTable.EasingDirection,
	[172] = EnumLookupTable.EasingStyle,
	[173] = EnumLookupTable.EditableStatus,
	[174] = EnumLookupTable.ElasticBehavior,
	[175] = EnumLookupTable.EmitterPositionType,
	[176] = EnumLookupTable.EngagementLevel,
	[177] = EnumLookupTable.EngineFolder,
	[178] = EnumLookupTable.EnviromentalPhysicsThrottle,
	[179] = EnumLookupTable.ExperienceActivationStatus,
	[180] = EnumLookupTable.ExperienceAuthScope,
	[181] = EnumLookupTable.ExperienceEventStatus,
	[182] = EnumLookupTable.ExperienceStateCaptureSelectionMode,
	[183] = EnumLookupTable.ExperienceStateRecordingLoadMode,
	[184] = EnumLookupTable.ExperienceStateRecordingLoadSourceType,
	[185] = EnumLookupTable.ExperienceStateRecordingPlaybackMode,
	[186] = EnumLookupTable.ExplosionType,
	[187] = EnumLookupTable.FACSDataLod,
	[188] = EnumLookupTable.FacialAgeEstimationResultType,
	[189] = EnumLookupTable.FacialAnimationStreamingState,
	[190] = EnumLookupTable.FacsActionUnit,
	[191] = EnumLookupTable.FeatureRestrictionAbuseVector,
	[192] = EnumLookupTable.FeedbackType,
	[193] = EnumLookupTable.FieldOfViewMode,
	[194] = EnumLookupTable.FillDirection,
	[195] = EnumLookupTable.FilterResult,
	[196] = EnumLookupTable.FilterType,
	[197] = EnumLookupTable.FinishRecordingOperation,
	[198] = EnumLookupTable.FluidFidelity,
	[199] = EnumLookupTable.FluidForces,
	[200] = EnumLookupTable.Font,
	[201] = EnumLookupTable.FontSize,
	[202] = EnumLookupTable.FontStyle,
	[203] = EnumLookupTable.FontWeight,
	[204] = EnumLookupTable.ForceLimitMode,
	[205] = EnumLookupTable.FormFactor,
	[206] = EnumLookupTable.FrameStyle,
	[207] = EnumLookupTable.FriendRequestEvent,
	[208] = EnumLookupTable.FriendStatus,
	[209] = EnumLookupTable.FunctionalTestResult,
	[210] = EnumLookupTable.GameAvatarType,
	[211] = EnumLookupTable.GamepadType,
	[212] = EnumLookupTable.GearGenreSetting,
	[213] = EnumLookupTable.GearType,
	[214] = EnumLookupTable.Genre,
	[215] = EnumLookupTable.GradientTileMode,
	[216] = EnumLookupTable.GradientType,
	[217] = EnumLookupTable.GraphicsOptimizationMode,
	[218] = EnumLookupTable.GroupMembershipStatus,
	[219] = EnumLookupTable.GuiState,
	[220] = EnumLookupTable.GuiType,
	[221] = EnumLookupTable.HandlesStyle,
	[222] = EnumLookupTable.HapticEffectType,
	[223] = EnumLookupTable.HashAlgorithm,
	[224] = EnumLookupTable.HighlightDepthMode,
	[225] = EnumLookupTable.HorizontalAlignment,
	[226] = EnumLookupTable.HttpCachePolicy,
	[227] = EnumLookupTable.HttpCompression,
	[228] = EnumLookupTable.HttpContentType,
	[229] = EnumLookupTable.HttpError,
	[230] = EnumLookupTable.HttpRequestType,
	[231] = EnumLookupTable.HumanoidCollisionType,
	[232] = EnumLookupTable.HumanoidDisplayDistanceType,
	[233] = EnumLookupTable.HumanoidHealthDisplayType,
	[234] = EnumLookupTable.HumanoidRigType,
	[235] = EnumLookupTable.HumanoidStateType,
	[236] = EnumLookupTable.IKCollisionsMode,
	[237] = EnumLookupTable.IKControlConstraintSupport,
	[238] = EnumLookupTable.IKControlType,
	[239] = EnumLookupTable.IXPLoadingStatus,
	[240] = EnumLookupTable.ImageAlphaType,
	[241] = EnumLookupTable.ImageCombineType,
	[242] = EnumLookupTable.InOut,
	[243] = EnumLookupTable.InfoType,
	[244] = EnumLookupTable.InitialDockState,
	[245] = EnumLookupTable.InputActionType,
	[246] = EnumLookupTable.InputBindingType,
	[247] = EnumLookupTable.InputSink,
	[248] = EnumLookupTable.InputType,
	[249] = EnumLookupTable.InstanceFileSyncStatus,
	[250] = EnumLookupTable.IntermediateMeshGenerationResult,
	[251] = EnumLookupTable.InternalVideoUsage,
	[252] = EnumLookupTable.InterpolationThrottlingMode,
	[253] = EnumLookupTable.InviteState,
	[254] = EnumLookupTable.ItemLineAlignment,
	[255] = EnumLookupTable.JoinSource,
	[256] = EnumLookupTable.JointCreationMode,
	[257] = EnumLookupTable.KeyCode,
	[258] = EnumLookupTable.KeyCodeStringFormat,
	[259] = EnumLookupTable.KeyInterpolationMode,
	[260] = EnumLookupTable.KeywordFilterType,
	-- [261] = EnumLookupTable.Language,
	[262] = EnumLookupTable.LeftRight,
	[263] = EnumLookupTable.LightingStyle,
	[264] = EnumLookupTable.Limb,
	[265] = EnumLookupTable.LineJoinMode,
	[266] = EnumLookupTable.ListenerLocation,
	[267] = EnumLookupTable.ListenerPositionType,
	[268] = EnumLookupTable.ListenerType,
	[271] = EnumLookupTable.LoadCharacterLayeredClothing,
	[272] = EnumLookupTable.LoadDynamicHeads,
	[273] = EnumLookupTable.LocationType,
	[274] = EnumLookupTable.LuauTypeCheckMode,
	[275] = EnumLookupTable.MakeupType,
	[276] = EnumLookupTable.MarketplaceBulkPurchasePromptStatus,
	[277] = EnumLookupTable.MarketplaceItemPurchaseStatus,
	[278] = EnumLookupTable.MarketplaceProductType,
	[279] = EnumLookupTable.MatchmakingType,
	[280] = EnumLookupTable.Material,
	[281] = EnumLookupTable.MaterialPattern,
	[282] = EnumLookupTable.MembershipType,
	[283] = EnumLookupTable.MeshPartHeadsAndAccessories,
	[285] = EnumLookupTable.MeshType,
	[286] = EnumLookupTable.MessageType,
	[287] = EnumLookupTable.ModelLevelOfDetail,
	[288] = EnumLookupTable.ModelStreamingBehavior,
	[289] = EnumLookupTable.ModelStreamingMode,
	[290] = EnumLookupTable.ModerationResultCategory,
	[291] = EnumLookupTable.ModerationResultLabel,
	[292] = EnumLookupTable.ModerationStatus,
	[293] = EnumLookupTable.ModifierKey,
	[294] = EnumLookupTable.MouseBehavior,
	[295] = EnumLookupTable.MoveState,
	[296] = EnumLookupTable.MuteState,
	[297] = EnumLookupTable.NameOcclusion,
	[298] = EnumLookupTable.NegateOperationHiddenHistory,
	[299] = EnumLookupTable.NetworkOwnership,
	[300] = EnumLookupTable.NetworkStatus,
	[301] = EnumLookupTable.NoiseType,
	[302] = EnumLookupTable.NormalId,
	[303] = EnumLookupTable.NotificationButtonType,
	[304] = EnumLookupTable.OperationType,
	[305] = EnumLookupTable.OrientationAlignmentMode,
	[306] = EnumLookupTable.OutfitSource,
	[307] = EnumLookupTable.OutfitType,
	[308] = EnumLookupTable.OverrideMouseIconBehavior,
	[309] = EnumLookupTable.PackagePermission,
	[310] = EnumLookupTable.PartType,
	[311] = EnumLookupTable.ParticleEmitterShape,
	[312] = EnumLookupTable.ParticleEmitterShapeInOut,
	[313] = EnumLookupTable.ParticleEmitterShapeStyle,
	[314] = EnumLookupTable.ParticleFlipbookLayout,
	[315] = EnumLookupTable.ParticleFlipbookMode,
	[316] = EnumLookupTable.ParticleFlipbookTextureCompatible,
	[317] = EnumLookupTable.ParticleOrientation,
	[318] = EnumLookupTable.PathStatus,
	[319] = EnumLookupTable.PathWaypointAction,
	[320] = EnumLookupTable.PathfindingUseImprovedSearch,
	[321] = EnumLookupTable.PeoplePageLayout,
	[323] = EnumLookupTable.PhysicsSimulationRate,
	[324] = EnumLookupTable.PhysicsSteppingMethod,
	[327] = EnumLookupTable.Platform,
	[328] = EnumLookupTable.PlaybackState,
	[329] = EnumLookupTable.PlayerActions,
	[330] = EnumLookupTable.PlayerCharacterDestroyBehavior,
	[331] = EnumLookupTable.PlayerChatType,
	[332] = EnumLookupTable.PlayerDataErrorState,
	[333] = EnumLookupTable.PlayerDataLoadFailureBehavior,
	[334] = EnumLookupTable.PlayerExitReason,
	[335] = EnumLookupTable.PlayerPlatformActivationStatus,
	[336] = EnumLookupTable.PlayerPlatformSpenderStatus,
	[337] = EnumLookupTable.PoseEasingDirection,
	[338] = EnumLookupTable.PoseEasingStyle,
	[339] = EnumLookupTable.PositionAlignmentMode,
	[340] = EnumLookupTable.PredictionMode,
	[341] = EnumLookupTable.PredictionStatus,
	[342] = EnumLookupTable.PreferredInput,
	[343] = EnumLookupTable.PreferredTextSize,
	[344] = EnumLookupTable.PrimalPhysicsSolver,
	[345] = EnumLookupTable.PrimitiveType,
	[346] = EnumLookupTable.PrivilegeType,
	[347] = EnumLookupTable.ProductLocationRestriction,
	[348] = EnumLookupTable.ProductPurchaseChannel,
	[349] = EnumLookupTable.ProductPurchaseDecision,
	[350] = EnumLookupTable.PromptCreateAssetResult,
	[351] = EnumLookupTable.PromptCreateAvatarResult,
	[352] = EnumLookupTable.PromptExperienceDetailsResult,
	[353] = EnumLookupTable.PromptLinkSharingResult,
	[354] = EnumLookupTable.PromptPublishAssetResult,
	[355] = EnumLookupTable.PropertyStatus,
	[356] = EnumLookupTable.ProximityPromptExclusivity,
	[357] = EnumLookupTable.ProximityPromptInputType,
	[358] = EnumLookupTable.ProximityPromptStyle,
	[359] = EnumLookupTable.PurchaseOption,
	[360] = EnumLookupTable.R15CollisionType,
	[361] = EnumLookupTable.RaycastFilterType,
	[362] = EnumLookupTable.ReadCapturesFromGalleryResult,
	[363] = EnumLookupTable.ReceiptDecision,
	[364] = EnumLookupTable.ReceiptType,
	[365] = EnumLookupTable.RecommendationActionType,
	[366] = EnumLookupTable.RecommendationDepartureIntent,
	[367] = EnumLookupTable.RecommendationImpressionType,
	[368] = EnumLookupTable.RecommendationItemContentType,
	[369] = EnumLookupTable.RecommendationItemVisibility,
	[370] = EnumLookupTable.RecommendationPreferenceTargetType,
	[371] = EnumLookupTable.RecommendationPreferenceType,
	[372] = EnumLookupTable.RejectCharacterDeletions,
	[373] = EnumLookupTable.RenderFidelity,
	[374] = EnumLookupTable.RenderPriority,
	[375] = EnumLookupTable.RenderingCacheOptimizationMode,
	[376] = EnumLookupTable.RenderingTestComparisonMethod,
	[377] = EnumLookupTable.ReplicateInstanceDestroySetting,
	[378] = EnumLookupTable.ResamplerMode,
	[379] = EnumLookupTable.ReservedHighlightId,
	[381] = EnumLookupTable.ReturnKeyType,
	[382] = EnumLookupTable.ReverbType,
	[383] = EnumLookupTable.ReviewableContentState,
	[384] = EnumLookupTable.RibbonTool,
	[385] = EnumLookupTable.RigLabel,
	[388] = EnumLookupTable.RollOffMode,
	[389] = EnumLookupTable.RolloutState,
	[390] = EnumLookupTable.RotationOrder,
	[391] = EnumLookupTable.RotationType,
	[392] = EnumLookupTable.RsvpStatus,
	[393] = EnumLookupTable.RtlTextSupport,
	[394] = EnumLookupTable.RunContext,
	[395] = EnumLookupTable.RunState,
	[396] = EnumLookupTable.RuntimeUndoBehavior,
	[397] = EnumLookupTable.SafeAreaCompatibility,
	[398] = EnumLookupTable.SalesTypeFilter,
	[399] = EnumLookupTable.SandboxedInstanceMode,
	[400] = EnumLookupTable.SaveAvatarThumbnailCustomizationFailure,
	[401] = EnumLookupTable.SaveFilter,
	[402] = EnumLookupTable.SavedQualitySetting,
	[403] = EnumLookupTable.ScaleType,
	[404] = EnumLookupTable.ScopeCheckResult,
	[405] = EnumLookupTable.ScreenInsets,
	[406] = EnumLookupTable.ScreenOrientation,
	[407] = EnumLookupTable.ScreenshotCaptureResult,
	[408] = EnumLookupTable.ScriptStoppedReason,
	[409] = EnumLookupTable.ScriptVariableScope,
	[410] = EnumLookupTable.ScrollBarInset,
	[411] = EnumLookupTable.ScrollingDirection,
	[412] = EnumLookupTable.SecurityCapability,
	[413] = EnumLookupTable.SelectionBehavior,
	[414] = EnumLookupTable.SelectionRenderMode,
	[415] = EnumLookupTable.SelfViewPosition,
	[416] = EnumLookupTable.SensorMode,
	[417] = EnumLookupTable.SensorUpdateType,
	[419] = EnumLookupTable.ShowAdResult,
	[420] = EnumLookupTable.SignalBehavior,
	[421] = EnumLookupTable.SimulationMode,
	[422] = EnumLookupTable.SizeConstraint,
	[423] = EnumLookupTable.SlimTintMode,
	[424] = EnumLookupTable.SolidPrimitiveType,
	[425] = EnumLookupTable.SolverConvergenceMetricType,
	[426] = EnumLookupTable.SolverConvergenceVisualizationMode,
	[427] = EnumLookupTable.SortDirection,
	[428] = EnumLookupTable.SortOrder,
	[429] = EnumLookupTable.SpecialKey,
	[430] = EnumLookupTable.StartCorner,
	[431] = EnumLookupTable.StateObjectFieldType,
	[432] = EnumLookupTable.Status,
	[433] = EnumLookupTable.StepFrequency,
	[434] = EnumLookupTable.StreamOutBehavior,
	[435] = EnumLookupTable.StreamingIntegrityMode,
	[436] = EnumLookupTable.StreamingPauseMode,
	[437] = EnumLookupTable.StrokeSizingMode,
	[438] = EnumLookupTable.StudioAction,
	[439] = EnumLookupTable.StudioCaptureScreenshotFormat,
	[440] = EnumLookupTable.StudioCloseMode,
	[441] = EnumLookupTable.StudioDataModelType,
	[442] = EnumLookupTable.StudioPlaceUpdateFailureReason,
	[443] = EnumLookupTable.Style,
	[444] = EnumLookupTable.SubscriptionExpirationReason,
	[445] = EnumLookupTable.SubscriptionPaymentStatus,
	[446] = EnumLookupTable.SubscriptionPeriod,
	[447] = EnumLookupTable.SubscriptionState,
	[448] = EnumLookupTable.SurfaceConstraint,
	[449] = EnumLookupTable.SurfaceGuiShape,
	[450] = EnumLookupTable.SurfaceGuiSizingMode,
	[451] = EnumLookupTable.SurfaceType,
	[452] = EnumLookupTable.SwipeDirection,
	[453] = EnumLookupTable.SystemThemeValue,
	[454] = EnumLookupTable.TableMajorAxis,
	[457] = EnumLookupTable.Technology,
	[458] = EnumLookupTable.TelemetryBackend,
	[459] = EnumLookupTable.TelemetryStandardizedField,
	[460] = EnumLookupTable.TeleportMethod,
	[461] = EnumLookupTable.TeleportResult,
	[462] = EnumLookupTable.TeleportState,
	[463] = EnumLookupTable.TeleportType,
	[464] = EnumLookupTable.TerrainAcquisitionMethod,
	[465] = EnumLookupTable.TerrainFace,
	[466] = EnumLookupTable.TerrainLiquidMergeOperation,
	[467] = EnumLookupTable.TerrainSolidMergeOperation,
	[468] = EnumLookupTable.TextChatMessageStatus,
	[469] = EnumLookupTable.TextDirection,
	[470] = EnumLookupTable.TextFilterContext,
	[471] = EnumLookupTable.TextInputType,
	[472] = EnumLookupTable.TextTruncate,
	[473] = EnumLookupTable.TextXAlignment,
	[474] = EnumLookupTable.TextYAlignment,
	[475] = EnumLookupTable.TextureMode,
	[476] = EnumLookupTable.TextureQueryType,
	[477] = EnumLookupTable.ThreadPoolConfig,
	[478] = EnumLookupTable.ThrottlingPriority,
	[479] = EnumLookupTable.ThumbnailSize,
	[480] = EnumLookupTable.ThumbnailType,
	[481] = EnumLookupTable.TickCountSampleMethod,
	[482] = EnumLookupTable.TonemapperPreset,
	[483] = EnumLookupTable.TopBottom,
	[484] = EnumLookupTable.TouchCameraMovementMode,
	[485] = EnumLookupTable.TouchMovementMode,
	[486] = EnumLookupTable.TrackerError,
	[487] = EnumLookupTable.TrackerExtrapolationFlagMode,
	[488] = EnumLookupTable.TrackerFaceTrackingStatus,
	[489] = EnumLookupTable.TrackerLodFlagMode,
	[490] = EnumLookupTable.TrackerLodValueMode,
	[491] = EnumLookupTable.TrackerMode,
	[492] = EnumLookupTable.TrackerPromptEvent,
	[493] = EnumLookupTable.TrackerType,
	[494] = EnumLookupTable.TriStateBoolean,
	[495] = EnumLookupTable.TweenStatus,
	[496] = EnumLookupTable.UICaptureMode,
	[497] = EnumLookupTable.UIDragDetectorBoundingBehavior,
	[498] = EnumLookupTable.UIDragDetectorDragRelativity,
	[499] = EnumLookupTable.UIDragDetectorDragSpace,
	[500] = EnumLookupTable.UIDragDetectorDragStyle,
	[501] = EnumLookupTable.UIDragDetectorResponseStyle,
	[502] = EnumLookupTable.UIDragSpeedAxisMapping,
	[503] = EnumLookupTable.UIFlexAlignment,
	[504] = EnumLookupTable.UIFlexMode,
	[505] = EnumLookupTable.UiMessageType,
	[506] = EnumLookupTable.UpdateState,
	[507] = EnumLookupTable.UploadCaptureResult,
	[508] = EnumLookupTable.UsageContext,
	[509] = EnumLookupTable.UserCFrame,
	[510] = EnumLookupTable.UserInputState,
	[511] = EnumLookupTable.UserInputType,
	[512] = EnumLookupTable.VRComfortSetting,
	[513] = EnumLookupTable.VRControllerModelMode,
	[514] = EnumLookupTable.VRDeviceType,
	[515] = EnumLookupTable.VRLaserPointerMode,
	[516] = EnumLookupTable.VRSafetyBubbleMode,
	[517] = EnumLookupTable.VRScaling,
	[518] = EnumLookupTable.VRSessionState,
	[519] = EnumLookupTable.VRTouchpad,
	[520] = EnumLookupTable.VRTouchpadMode,
	[521] = EnumLookupTable.VelocityConstraintMode,
	[522] = EnumLookupTable.VerticalAlignment,
	[523] = EnumLookupTable.VerticalScrollBarPosition,
	[524] = EnumLookupTable.VibrationMotor,
	[525] = EnumLookupTable.VideoCaptureResult,
	[526] = EnumLookupTable.VideoCaptureStartedResult,
	[527] = EnumLookupTable.VideoDeviceCaptureQuality,
	[528] = EnumLookupTable.VideoError,
	[529] = EnumLookupTable.VideoSampleSize,
	[530] = EnumLookupTable.VirtualCursorMode,
	[531] = EnumLookupTable.VoiceChatDistanceAttenuationType,
	[532] = EnumLookupTable.VoiceChatState,
	[533] = EnumLookupTable.VoiceClientLeaveReasons,
	[534] = EnumLookupTable.VoiceControlPath,
	[535] = EnumLookupTable.VoiceRccReconnectReason,
	[536] = EnumLookupTable.VolumetricAudio,
	[537] = EnumLookupTable.WaterDirection,
	[538] = EnumLookupTable.WaterForce,
	[539] = EnumLookupTable.WebSocketState,
	[540] = EnumLookupTable.WebStreamClientState,
	[541] = EnumLookupTable.WebStreamClientType,
	[542] = EnumLookupTable.WeldConstraintPreserve,
	[543] = EnumLookupTable.WhenUserFirstPlayed,
	[544] = EnumLookupTable.WhisperChatPrivacyMode,
	[545] = EnumLookupTable.WrapLayerAutoSkin,
	[546] = EnumLookupTable.WrapLayerDebugMode,
	[547] = EnumLookupTable.WrapTargetDebugMode,
	[548] = EnumLookupTable.ZIndexBehavior,
}

local VariantTypes = {
	Nil = 0x00,
	String = ResolveType("string", 0x02),
	NilAlt = 0x03,
	InstanceLegacy = 0x06,
	Enum = ResolveType("Enum", 0x07),
	BinaryString = ResolveType("BinaryString", 0x08),
	Bool = ResolveType("bool", 0x09),
	Int = ResolveType("int", 0x0A),
	Float = ResolveType("float", 0x0B),
	Double = ResolveType("double", 0x0C),
	UDim = ResolveType("UDim", 0x0D),
	UDim2 = ResolveType("UDim2", 0x0E),
	Ray = ResolveType("Ray", 0x0F),
	Faces = ResolveType("Faces", 0x10),
	Axes = ResolveType("Axes", 0x11),
	BrickColor = ResolveType("BrickColor", 0x12),
	Color3 = ResolveType("Color3", 0x13),
	Color3uint8 = ResolveType("Color3uint8", 0x14),
	Vector2 = ResolveType("Vector2", 0x15),
	Vector3 = ResolveType("Vector3", 0x16),
	Vector2int16 = ResolveType("Vector2int16", 0x18),
	Vector3int16 = ResolveType("Vector3int16", 0x19),
	CoordinateFrameLegacy = 0x1A,
	CoordinateFrame = ResolveType("CoordinateFrame", 0x1B),
	Instance = ResolveType("Instance", 0x1C),
	Tuple = ResolveType("Tuple", 0x1D),
	Array = ResolveType("Array", 0x1E),
	Dictionary = ResolveType("Dictionary", 0x1F),
	Map = ResolveType("Map", 0x20),
	ContentId = ResolveType("ContentId", 0x21),
	SystemAddress = ResolveType("SystemAddress", 0x22),
	NumberSequence = ResolveType("NumberSequence", 0x23),
	NumberSequenceKeypoint = ResolveType("NumberSequenceKeypoint", 0x24),
	NumberRange = ResolveType("NumberRange", 0x25),
	ColorSequence = ResolveType("ColorSequence", 0x26),
	ColorSequenceKeypoint = ResolveType("ColorSequenceKeypoint", 0x27),
	Rect2D = ResolveType("Rect2D", 0x28),
	PhysicalProperties = ResolveType("PhysicalProperties", 0x29),
	Region3 = ResolveType("Region3", 0x2A),
	Region3int16 = ResolveType("Region3int16", 0x2B),
	Int64 = ResolveType("int64", 0x2C),
	SharedString = ResolveType("SharedString", 0x2E),
	InstanceAlt = 0x2F,
	DateTime = ResolveType("DateTime", 0x30),
	FontLegacy = 0x31,
	OptionalCoordinateFrameLegacy = 0x32,
	OptionalCoordinateFrame = ResolveType("OptionalCoordinateFrame", 0x33),
	UniqueId = ResolveType("UniqueId", 0x34),
	PathWaypoint = ResolveType("PathWaypoint", 0x35),
	Font = ResolveType("Font", 0x36),
	SecurityCapabilities = ResolveType("SecurityCapabilities", 0x37),
	Buffer = ResolveType("buffer", 0x38),
	ReplicationPV = ResolveType("ReplicationPV", 0x39),
	FacsReplicationData = ResolveType("FacsReplicationData", 0x3A),
	NetAssetHandle = ResolveType("NetAssetHandle", 0x3B),
	NetAssetRef = ResolveType("NetAssetRef", 0x3C),
	Content = ResolveType("Content", 0x3D),
	SlimReplicationData = ResolveType("SlimReplicationData", 0x3F),
	AnimTrackVariant = 0x40,
	AnimTrackPlayState = ResolveType("AnimTrackPlayState", 0x41),
	AnimTrackMetadata = ResolveType("AnimTrackMetadata", 0x42),
	AnimTrackWeight = ResolveType("AnimTrackWeight", 0x43),
}

local Constants = {
	NetworkSchema = NetworkSchema,
	PacketIds = {
		ID_DATA = 0x83,
	},
	ItemTypes = {
		ReliableEventInvocationItem = 0x07,
		UnreliableEventInvocationItem = 0x03,
	},
	VariantTypes = VariantTypes,
}

Constants.EnumTypes = TYPE_ID_TO_ENUM

local EnumNames = NetworkSchema.enum_names
function Constants.GetEnum(EnumTypeId: number): Enum?
	local EnumName = EnumNames and EnumNames[EnumTypeId]
	if EnumName then
		local EnumType = EnumLookupTable[EnumName]
		if EnumType then
			return EnumType
		end
	end

	return TYPE_ID_TO_ENUM[EnumTypeId]
end

return Constants

end)() end,
    [52] = function()local wax,script,require,CreateLookupTable=ImportGlobals(52)local ImportGlobals return (function(...)local Codec = require(script.Parent.Codec)

local LookupModule = {
	Instance = {
		Lookup = {},
	},
}

local GetInstanceIdBrokenExecutors = {
    ["Synapse Z"] = true,
}

local GetInstanceByID = (
	not GetInstanceIdBrokenExecutors[wax.shared.ExecutorName] and
	(raknet and raknet.get_instance_by_id)
)

local function IndexInstance(instance: Instance)
	local Success, DebugId = pcall(instance.GetDebugId, instance)
	if not Success then
		return
	end

	LookupModule.Instance.Lookup[DebugId] = cloneref(instance)
end

local function UnindexInstance(instance: Instance)
	local Success, DebugId = pcall(instance.GetDebugId, instance)
	if not Success then
		return
	end

	LookupModule.Instance.Lookup[DebugId] = nil
end

function LookupModule.Instance.ByRef(ref: Codec.InstanceRef): Instance?
	if ref.is_null then
		return nil
	end

	if GetInstanceByID then
		return GetInstanceByID(ref.peer_id, ref.instance_id)
	end

	local DebugIdKey = string.format("%d_%d", ref.peer_id, ref.instance_id)
	return LookupModule.Instance.Lookup[DebugIdKey]
end

function LookupModule.Instance.Build()
	if GetInstanceByID then
		return
	end

	LookupModule.DescendantAdded = wax.shared.Connect(game.DescendantAdded:Connect(IndexInstance))
	LookupModule.DescendantRemoving = wax.shared.Connect(game.DescendantRemoving:Connect(UnindexInstance))

	for _, category in { game:GetDescendants(), getnilinstances and getnilinstances() } do
		for _, instance in category do
			IndexInstance(instance)
		end
	end
end

function LookupModule.Instance.Destroy()
	if GetInstanceByID then
		return
	end

	--// Connections \\--
	if LookupModule.DescendantAdded then
		wax.shared.Disconnect(LookupModule.DescendantAdded)
		LookupModule.DescendantAdded = nil
	end

	if LookupModule.DescendantRemoving then
		wax.shared.Disconnect(LookupModule.DescendantRemoving)
		LookupModule.DescendantRemoving = nil
	end

	--// Lookup \\--
	table.clear(LookupModule.Instance.Lookup)
end

return LookupModule

end)() end,
    [55] = function()local wax,script,require,CreateLookupTable=ImportGlobals(55)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local ANIM_TRACK_VARIANT_TYPE = VariantTypes.AnimTrackVariant
local ANIM_TRACK_PLAY_STATE_TYPE = VariantTypes.AnimTrackPlayState
local ANIM_TRACK_METADATA_TYPE = VariantTypes.AnimTrackMetadata
local ANIM_TRACK_WEIGHT_TYPE = VariantTypes.AnimTrackWeight

local DecoderModule = {
	Type = {
		ANIM_TRACK_VARIANT_TYPE,
		ANIM_TRACK_PLAY_STATE_TYPE,
		ANIM_TRACK_METADATA_TYPE,
		ANIM_TRACK_WEIGHT_TYPE,
	},
}

local Router = {
	-- Speculative: zigzag LEB128 (play-state enum-ish)
	[ANIM_TRACK_VARIANT_TYPE] = function(data: buffer, offset: number)
		local n, newOffset = Codec.LEB128(data, offset)
		return {
			Result = { animTrackVariant = Codec.ZzDec(n) },
			Offset = newOffset,
		}
	end,

	-- Speculative: flags(u8) + f32 + f64 = 13 bytes
	[ANIM_TRACK_PLAY_STATE_TYPE] = function(data: buffer, offset: number)
		return {
			Result = {
				flags = buffer.readu8(data, offset),
				f32 = buffer.readf32(data, offset + 1),
				f64 = buffer.readf64(data, offset + 5),
			},
			Offset = offset + 13,
		}
	end,

	-- Speculative: u8 + i16 = 3 bytes
	[ANIM_TRACK_METADATA_TYPE] = function(data: buffer, offset: number)
		return {
			Result = {
				byte = buffer.readu8(data, offset),
				i16 = buffer.readi16(data, offset + 1),
			},
			Offset = offset + 3,
		}
	end,

	-- Speculative: f32 + f32 + f64 = 16 bytes
	[ANIM_TRACK_WEIGHT_TYPE] = function(data: buffer, offset: number)
		return {
			Result = {
				f0 = buffer.readf32(data, offset),
				f1 = buffer.readf32(data, offset + 4),
				d = buffer.readf64(data, offset + 8),
			},
			Offset = offset + 16,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [56] = function()local wax,script,require,CreateLookupTable=ImportGlobals(56)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local AXIS_VALUES = {
	Enum.Axis.X,
	Enum.Axis.Y,
	Enum.Axis.Z,
}

local DecoderModule = {
	Type = VariantTypes.Axes,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local mask = buffer.readu32(data, offset)
	local axes = {}
	for i, axis in AXIS_VALUES do
		if bit32.band(mask, bit32.lshift(1, i - 1)) ~= 0 then
			table.insert(axes, axis)
		end
	end
	return {
		Result = Axes.new(table.unpack(axes)),
		Offset = offset + 4,
	}
end

return DecoderModule

end)() end,
    [57] = function()local wax,script,require,CreateLookupTable=ImportGlobals(57)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.Bool,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	return {
		Result = buffer.readu8(data, offset) ~= 0,
		Offset = offset + 1,
	}
end

return DecoderModule

end)() end,
    [58] = function()local wax,script,require,CreateLookupTable=ImportGlobals(58)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.BrickColor,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local number = buffer.readu16(data, offset)
	return {
		Result = BrickColor.new(number),
		Offset = offset + 2,
	}
end

return DecoderModule

end)() end,
    [59] = function()local wax,script,require,CreateLookupTable=ImportGlobals(59)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.Buffer,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	-- u8(flags/reserved) + LEB128(len) + bytes
	offset += 1

	local length, newOffset = Codec.LEB128(data, offset)
	local result = buffer.create(length)

	buffer.copy(result, 0, data, newOffset, length)

	return {
		Result = result,
		Offset = newOffset + length,
	}
end

return DecoderModule

end)() end,
    [60] = function()local wax,script,require,CreateLookupTable=ImportGlobals(60)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local CFRAME_V1_TYPE = VariantTypes.CoordinateFrameLegacy
local CFRAME_TYPE = VariantTypes.CoordinateFrame

local DecoderModule = {
	Type = { CFRAME_V1_TYPE, CFRAME_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local cf, newOffset = Codec.ReadCFrameV1(data, offset)
	return {
		Result = cf,
		Offset = newOffset,
	}
end

return DecoderModule

end)() end,
    [61] = function()local wax,script,require,CreateLookupTable=ImportGlobals(61)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local COLOR3_TYPE = VariantTypes.Color3
local COLOR3UINT8_TYPE = VariantTypes.Color3uint8

local DecoderModule = {
	Type = { COLOR3_TYPE, COLOR3UINT8_TYPE },
}

local Router = {
	[COLOR3_TYPE] = function(data: buffer, offset: number)
		local r = buffer.readf32(data, offset)
		local g = buffer.readf32(data, offset + 4)
		local b = buffer.readf32(data, offset + 8)
		return {
			Result = Color3.new(r, g, b),
			Offset = offset + 12,
		}
	end,

	[COLOR3UINT8_TYPE] = function(data: buffer, offset: number)
		local r = buffer.readu8(data, offset)
		local g = buffer.readu8(data, offset + 1)
		local b = buffer.readu8(data, offset + 2)
		return {
			Result = Color3.fromRGB(r, g, b),
			Offset = offset + 3,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [62] = function()local wax,script,require,CreateLookupTable=ImportGlobals(62)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local COLOR_SEQUENCE_TYPE = VariantTypes.ColorSequence
local COLOR_SEQUENCE_KEYPOINT_TYPE = VariantTypes.ColorSequenceKeypoint

local DecoderModule = {
	Type = { COLOR_SEQUENCE_TYPE, COLOR_SEQUENCE_KEYPOINT_TYPE },
}

local function readKeypoint(data: buffer, offset: number): (ColorSequenceKeypoint, number)
	local time = buffer.readf32(data, offset)
	local r = buffer.readf32(data, offset + 4)
	local g = buffer.readf32(data, offset + 8)
	local b = buffer.readf32(data, offset + 12)
	-- envelope at +16 is present on wire but unused by ColorSequenceKeypoint.new
	return ColorSequenceKeypoint.new(time, Color3.new(r, g, b)), offset + 20
end

local Router = {
	[COLOR_SEQUENCE_TYPE] = function(data: buffer, offset: number)
		local count = buffer.readu32(data, offset)
		offset += 4
		if count > 100 then
			return { Result = ColorSequence.new(Color3.new()), Offset = -1 }
		end

		local keypoints = table.create(count)
		for i = 1, count do
			local kp
			kp, offset = readKeypoint(data, offset)
			keypoints[i] = kp
		end

		if count == 0 then
			return { Result = ColorSequence.new(Color3.new()), Offset = offset }
		end

		return {
			Result = ColorSequence.new(keypoints),
			Offset = offset,
		}
	end,

	[COLOR_SEQUENCE_KEYPOINT_TYPE] = function(data: buffer, offset: number)
		local kp, newOffset = readKeypoint(data, offset)
		return {
			Result = kp,
			Offset = newOffset,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [63] = function()local wax,script,require,CreateLookupTable=ImportGlobals(63)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local Lookup = require(script.Parent.Parent.Parent.Lookup)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.Content,
}

local KIND_ID_URI: { [number]: (number) -> string } = {
	[3] = function(id)
		return "rbxassetid://" .. tostring(id)
	end,
	[11] = function(id)
		return "http://www.roblox.com/asset/?id=" .. tostring(id)
	end,
	[13] = function(id)
		return "https://www.roblox.com/asset/?id=" .. tostring(id)
	end,
	[21] = function(id)
		return "https://assetdelivery.roblox.com/v1/asset/?id=" .. tostring(id)
	end,
}

local KIND_PREFIX: { [number]: string } = {
	[4] = "rbxgameasset://",
}

local function readNulString(data: buffer, offset: number): (string, number)
	local len, nextOffset = Codec.LEB128U(data, offset)
	local s = buffer.readstring(data, nextOffset, len)
	nextOffset += len
	-- trailing NUL terminator
	nextOffset += 1
	return s, nextOffset
end

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local source = buffer.readu8(data, offset)
	offset += 1

	if source == 0 then
		return { Result = Content.none, Offset = offset }
	end

	if source == 1 then
		local kind = buffer.readu8(data, offset)
		offset += 1

		if kind == 0 then
			local uri
			uri, offset = readNulString(data, offset)
			return { Result = Content.fromUri(uri), Offset = offset }
		end

		local prefix = KIND_PREFIX[kind]
		if prefix then
			local suffix
			suffix, offset = readNulString(data, offset)
			return { Result = Content.fromUri(prefix .. suffix), Offset = offset }
		end

		local toUri = KIND_ID_URI[kind]
		if toUri then
			local zz, nextOffset = Codec.LEB128U(data, offset)
			local id = Codec.ZzDec(zz)
			return { Result = Content.fromUri(toUri(id)), Offset = nextOffset }
		end

		return {
			Result = { contentKind = kind },
			Offset = offset,
		}
	end

	if source == 2 then
		local ref, refOffset = Codec.ReadInstanceRef(data, offset)
		if ref.is_null then
			return { Result = Content.none, Offset = refOffset }
		end
		local inst = Lookup.Instance.ByRef(ref)
		if inst then
			local ok, content = pcall(Content.fromObject, inst)
			if ok then
				return { Result = content, Offset = refOffset }
			end
		end
		return {
			Result = { contentObjectId = ref.instance_id, peerId = ref.peer_id },
			Offset = refOffset,
		}
	end

	-- Opaque (3) or unknown — no extra payload observed
	return {
		Result = if source == 3 then Content.none else { contentSource = source },
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [64] = function()local wax,script,require,CreateLookupTable=ImportGlobals(64)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.DateTime,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local ms, newOffset = Codec.ReadUInt64(data, offset)
	return {
		Result = DateTime.fromUnixTimestampMillis(ms),
		Offset = newOffset,
	}
end

return DecoderModule

end)() end,
    [65] = function()local wax,script,require,CreateLookupTable=ImportGlobals(65)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local DICTIONARY_TYPE = VariantTypes.Dictionary
local MAP_TYPE = VariantTypes.Map

local DecoderModule = {
	Type = { DICTIONARY_TYPE, MAP_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, parser: any, depth: number)
	local length = buffer.len(data)
	local count, nextOffset = Codec.LEB128(data, offset)
	local remainingBytes = length - nextOffset
	local maxPossibleCount = remainingBytes // 2
	if count > maxPossibleCount then
		return { Result = {}, Offset = -1 }
	end

	local dict = {}
	offset = nextOffset
	for _ = 1, count do
		local keyLen, keyOffset = Codec.LEB128(data, offset)
		if keyOffset + keyLen > length then
			return { Result = dict, Offset = -1 }
		end

		local key = buffer.readstring(data, keyOffset, keyLen)
		local parsed = parser:Parse(keyOffset + keyLen, depth + 1)
		if parsed.Offset < 0 then
			return { Result = dict, Offset = -1 }
		end

		dict[key] = parsed.Result
		offset = parsed.Offset
	end

	return {
		Result = dict,
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [66] = function()local wax,script,require,CreateLookupTable=ImportGlobals(66)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local Constants = require(script.Parent.Parent.Parent.Constants)

local DecoderModule = {
	Type = Constants.VariantTypes.Enum,
}

local function findByValue(enum: Enum, value: number): EnumItem?
	for _, item in enum:GetEnumItems() do
		if item.Value == value then
			return item
		end
	end
	return nil
end

local function findUniqueByValue(value: number): EnumItem?
	local match: EnumItem? = nil
	for _, enum in Enum:GetEnums() do
		for _, item in enum:GetEnumItems() do
			if item.Value ~= value then
				continue
			end

			if match then
				return nil -- ambiguous across enum families
			end

			match = item
		end
	end

	return match
end

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local typeId = buffer.readu16(data, offset)
	local value, newOffset = Codec.LEB128(data, offset + 2)

	local enum = Constants.GetEnum(typeId)
	local item = if enum then findByValue(enum, value) else nil
	if not item then
		item = findUniqueByValue(value)
		if item and not Constants.EnumTypes[typeId] then
			Constants.EnumTypes[typeId] = item.EnumType
		end
	end

	return {
		Result = item or value,
		Offset = newOffset,
	}
end

return DecoderModule

end)() end,
    [67] = function()local wax,script,require,CreateLookupTable=ImportGlobals(67)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local FACE_NORMALS = {
	Enum.NormalId.Right,
	Enum.NormalId.Top,
	Enum.NormalId.Back,
	Enum.NormalId.Left,
	Enum.NormalId.Bottom,
	Enum.NormalId.Front,
}

local DecoderModule = {
	Type = VariantTypes.Faces,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local mask = buffer.readu32(data, offset)
	local faces = {}
	for i, normal in FACE_NORMALS do
		if bit32.band(mask, bit32.lshift(1, i - 1)) ~= 0 then
			table.insert(faces, normal)
		end
	end
	return {
		Result = Faces.new(table.unpack(faces)),
		Offset = offset + 4,
	}
end

return DecoderModule

end)() end,
    [68] = function()local wax,script,require,CreateLookupTable=ImportGlobals(68)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local FONT31_TYPE = VariantTypes.FontLegacy
local FONT36_TYPE = VariantTypes.Font

local DecoderModule = {
	Type = { FONT31_TYPE, FONT36_TYPE },
}

local function parseFont36(data: buffer, offset: number)
	local weight = buffer.readu16(data, offset)
	local style = buffer.readu8(data, offset + 2)
	offset += 3

	local nameLen = buffer.readu32(data, offset)
	offset += 4
	local name = buffer.readstring(data, offset, nameLen)
	offset += nameLen

	local fbLen = buffer.readu32(data, offset)
	offset += 4
	-- CachedFaceId is on the wire (often empty); Font.new only takes family.
	offset += fbLen

	local fontStyle = if style == 1 then Enum.FontStyle.Italic else Enum.FontStyle.Normal
	local fontWeight = Enum.FontWeight.Regular
	for _, item in Enum.FontWeight:GetEnumItems() do
		if item.Value == weight then
			fontWeight = item
			break
		end
	end

	return {
		Result = Font.new(name, fontWeight, fontStyle),
		Offset = offset,
	}
end

-- Speculative: IDA schema lists a string/id font encoding at 0x31.
-- Unobserved on remotes for Font values.
local function parseFont31(data: buffer, offset: number)
	local hdr = buffer.readu8(data, offset)
	offset += 1

	if hdr == 0xFF then
		local id, newOffset = Codec.LEB128(data, offset)
		return {
			Result = { fontId = id + 127 },
			Offset = newOffset,
		}
	elseif bit32.band(hdr, 0x80) ~= 0 then
		return {
			Result = { fontId = bit32.band(hdr, 0x7F) + 127 },
			Offset = offset,
		}
	elseif hdr == 0x7F then
		local nameLen, nameOffset = Codec.LEB128(data, offset)
		local name = buffer.readstring(data, nameOffset, nameLen)
		return {
			Result = Font.new(name),
			Offset = nameOffset + nameLen,
		}
	else
		local name = buffer.readstring(data, offset, hdr)
		return {
			Result = Font.new(name),
			Offset = offset + hdr,
		}
	end
end

local Router = {
	[FONT31_TYPE] = parseFont31,
	[FONT36_TYPE] = parseFont36,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [69] = function()local wax,script,require,CreateLookupTable=ImportGlobals(69)local ImportGlobals return (function(...)--// Imports \\--
local RakNet = script:FindFirstAncestor("RakNet")

local Codec = require(RakNet.Codec)
local Lookup = require(RakNet.Lookup)
local VariantTypes = require(RakNet.Constants).VariantTypes

--// Constants \\--
local INSTANCE_TYPE = VariantTypes.InstanceLegacy
local INSTANCE_REF_TYPE = VariantTypes.Instance
local INSTANCE_ALT_TYPE = VariantTypes.InstanceAlt

local DecoderModule = {
	Type = { INSTANCE_TYPE, INSTANCE_REF_TYPE, INSTANCE_ALT_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local ref, newOffset = Codec.ReadInstanceRef(data, offset)
	if ref.is_null then
		return {
			Result = nil,
			Offset = newOffset,
		}
	end

	return {
		Result = Lookup.Instance.ByRef(ref),
		Offset = newOffset,
	}
end

return DecoderModule

end)() end,
    [70] = function()local wax,script,require,CreateLookupTable=ImportGlobals(70)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local NIL_TYPE = VariantTypes.Nil
local NIL_ALT_TYPE = VariantTypes.NilAlt

local DecoderModule = {
	Type = { NIL_TYPE, NIL_ALT_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	return {
		Result = nil,
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [71] = function()local wax,script,require,CreateLookupTable=ImportGlobals(71)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local INT_TYPE = VariantTypes.Int
local FLOAT_TYPE = VariantTypes.Float
local DOUBLE_TYPE = VariantTypes.Double
local INT64_TYPE = VariantTypes.Int64
local UINT_TYPE = VariantTypes.SystemAddress

local DecoderModule = {
	Type = { INT_TYPE, FLOAT_TYPE, DOUBLE_TYPE, INT64_TYPE, UINT_TYPE },
}

local Router = {
	[INT_TYPE] = function(data: buffer, offset: number)
		local n, newOffset = Codec.LEB128(data, offset)
		return {
			Result = Codec.ZzDec(n),
			Offset = newOffset,
		}
	end,

	[FLOAT_TYPE] = function(data: buffer, offset: number)
		return {
			Result = buffer.readf32(data, offset),
			Offset = offset + 4,
		}
	end,

	[DOUBLE_TYPE] = function(data: buffer, offset: number)
		return {
			Result = buffer.readf64(data, offset),
			Offset = offset + 8,
		}
	end,

	[INT64_TYPE] = function(data: buffer, offset: number)
		local n, newOffset = Codec.LEB128(data, offset)
		return {
			Result = Codec.ZzDec(n),
			Offset = newOffset,
		}
	end,

	[UINT_TYPE] = function(data: buffer, offset: number)
		local n, newOffset = Codec.LEB128(data, offset)
		return {
			Result = n,
			Offset = newOffset,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [72] = function()local wax,script,require,CreateLookupTable=ImportGlobals(72)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.NumberRange,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local min = buffer.readf32(data, offset)
	local max = buffer.readf32(data, offset + 4)
	return {
		Result = NumberRange.new(min, max),
		Offset = offset + 8,
	}
end

return DecoderModule

end)() end,
    [73] = function()local wax,script,require,CreateLookupTable=ImportGlobals(73)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local NUMBER_SEQUENCE_TYPE = VariantTypes.NumberSequence
local NUMBER_SEQUENCE_KEYPOINT_TYPE = VariantTypes.NumberSequenceKeypoint

local DecoderModule = {
	Type = { NUMBER_SEQUENCE_TYPE, NUMBER_SEQUENCE_KEYPOINT_TYPE },
}

local function readKeypoint(data: buffer, offset: number): (NumberSequenceKeypoint, number)
	local time = buffer.readf32(data, offset)
	local value = buffer.readf32(data, offset + 4)
	local envelope = buffer.readf32(data, offset + 8)
	return NumberSequenceKeypoint.new(time, value, envelope), offset + 12
end

local Router = {
	[NUMBER_SEQUENCE_TYPE] = function(data: buffer, offset: number)
		local count = buffer.readu32(data, offset)
		offset += 4
		if count > 100 then
			return { Result = NumberSequence.new(0), Offset = -1 }
		end

		local keypoints = table.create(count)
		for i = 1, count do
			local kp
			kp, offset = readKeypoint(data, offset)
			keypoints[i] = kp
		end

		if count == 0 then
			return { Result = NumberSequence.new(0), Offset = offset }
		end

		return {
			Result = NumberSequence.new(keypoints),
			Offset = offset,
		}
	end,

	[NUMBER_SEQUENCE_KEYPOINT_TYPE] = function(data: buffer, offset: number)
		local kp, newOffset = readKeypoint(data, offset)
		return {
			Result = kp,
			Offset = newOffset,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [74] = function()local wax,script,require,CreateLookupTable=ImportGlobals(74)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local FACS_DATA_TYPE = VariantTypes.FacsReplicationData
local NET_ASSET_HANDLE_TYPE = VariantTypes.NetAssetHandle
local NET_ASSET_REF_TYPE = VariantTypes.NetAssetRef
local SLIM_REPLICATION_DATA_TYPE = VariantTypes.SlimReplicationData

local DecoderModule = {
	Type = {
		FACS_DATA_TYPE,
		NET_ASSET_HANDLE_TYPE,
		NET_ASSET_REF_TYPE,
		SLIM_REPLICATION_DATA_TYPE,
	},
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	local remaining = buffer.len(data) - offset
	local sliceLen = math.min(remaining, 8)
	local slice = buffer.create(sliceLen)
	if sliceLen > 0 then
		buffer.copy(slice, 0, data, offset, sliceLen)
	end

	return {
		Result = {
			typeId = t,
			bytes = slice,
		},
		Offset = -1,
	}
end

return DecoderModule

end)() end,
    [75] = function()local wax,script,require,CreateLookupTable=ImportGlobals(75)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local OPTIONAL_CFRAME_ALT_TYPE = VariantTypes.OptionalCoordinateFrameLegacy
local OPTIONAL_CFRAME_TYPE = VariantTypes.OptionalCoordinateFrame

local DecoderModule = {
	Type = { OPTIONAL_CFRAME_ALT_TYPE, OPTIONAL_CFRAME_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local cf, newOffset = Codec.ReadOptCFrame(data, offset)
	return {
		Result = cf,
		Offset = newOffset,
	}
end

return DecoderModule

end)() end,
    [76] = function()local wax,script,require,CreateLookupTable=ImportGlobals(76)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.PathWaypoint,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local x = buffer.readf32(data, offset)
	local y = buffer.readf32(data, offset + 4)
	local z = buffer.readf32(data, offset + 8)
	local action = buffer.readu8(data, offset + 12)
	offset += 13

	local labelLen = buffer.readu32(data, offset)
	offset += 4
	local label = buffer.readstring(data, offset, labelLen)
	offset += labelLen

	local actionEnum = Enum.PathWaypointAction.Walk
	for _, item in Enum.PathWaypointAction:GetEnumItems() do
		if item.Value == action then
			actionEnum = item
			break
		end
	end

	return {
		Result = PathWaypoint.new(Vector3.new(x, y, z), actionEnum, label),
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [77] = function()local wax,script,require,CreateLookupTable=ImportGlobals(77)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.PhysicalProperties,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local hdr = buffer.readu8(data, offset)
	offset += 1

	local isCustom = bit32.band(hdr, 0x01) ~= 0
	local hasAA = bit32.band(hdr, 0x02) ~= 0

	if not isCustom then
		-- Stand-in: no material id on wire for default.
		return {
			Result = PhysicalProperties.new(Enum.Material.Plastic),
			Offset = offset,
		}
	end

	local density = buffer.readf32(data, offset)
	local friction = buffer.readf32(data, offset + 4)
	local elasticity = buffer.readf32(data, offset + 8)
	local frictionWeight = buffer.readf32(data, offset + 12)
	local elasticityWeight = buffer.readf32(data, offset + 16)
	offset += 20

	local acousticAbsorption = 1
	if hasAA then
		acousticAbsorption = buffer.readf32(data, offset)
		offset += 4
	end

	return {
		Result = PhysicalProperties.new(
			density,
			friction,
			elasticity,
			frictionWeight,
			elasticityWeight,
			acousticAbsorption
		),
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [78] = function()local wax,script,require,CreateLookupTable=ImportGlobals(78)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.Ray,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local ox = buffer.readf32(data, offset)
	local oy = buffer.readf32(data, offset + 4)
	local oz = buffer.readf32(data, offset + 8)
	local dx = buffer.readf32(data, offset + 12)
	local dy = buffer.readf32(data, offset + 16)
	local dz = buffer.readf32(data, offset + 20)
	return {
		Result = Ray.new(Vector3.new(ox, oy, oz), Vector3.new(dx, dy, dz)),
		Offset = offset + 24,
	}
end

return DecoderModule

end)() end,
    [79] = function()local wax,script,require,CreateLookupTable=ImportGlobals(79)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.Rect2D,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local x0 = buffer.readf32(data, offset)
	local y0 = buffer.readf32(data, offset + 4)
	local x1 = buffer.readf32(data, offset + 8)
	local y1 = buffer.readf32(data, offset + 12)
	return {
		Result = Rect.new(x0, y0, x1, y1),
		Offset = offset + 16,
	}
end

return DecoderModule

end)() end,
    [80] = function()local wax,script,require,CreateLookupTable=ImportGlobals(80)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local REGION3_TYPE = VariantTypes.Region3
local REGION3INT16_TYPE = VariantTypes.Region3int16

local DecoderModule = {
	Type = { REGION3_TYPE, REGION3INT16_TYPE },
}

local Router = {
	[REGION3_TYPE] = function(data: buffer, offset: number)
		local x0 = buffer.readf32(data, offset)
		local y0 = buffer.readf32(data, offset + 4)
		local z0 = buffer.readf32(data, offset + 8)
		local x1 = buffer.readf32(data, offset + 12)
		local y1 = buffer.readf32(data, offset + 16)
		local z1 = buffer.readf32(data, offset + 20)
		return {
			Result = Region3.new(Vector3.new(x0, y0, z0), Vector3.new(x1, y1, z1)),
			Offset = offset + 24,
		}
	end,

	[REGION3INT16_TYPE] = function(data: buffer, offset: number)
		local x0 = buffer.readi16(data, offset)
		local y0 = buffer.readi16(data, offset + 2)
		local z0 = buffer.readi16(data, offset + 4)
		local x1 = buffer.readi16(data, offset + 6)
		local y1 = buffer.readi16(data, offset + 8)
		local z1 = buffer.readi16(data, offset + 10)
		return {
			Result = Region3int16.new(Vector3int16.new(x0, y0, z0), Vector3int16.new(x1, y1, z1)),
			Offset = offset + 12,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [81] = function()local wax,script,require,CreateLookupTable=ImportGlobals(81)local ImportGlobals return (function(...)local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.ReplicationPV,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local flags = buffer.readu8(data, offset)
	offset += 1

	local result = {
		flags = flags,
		position = nil :: Vector3?,
		rotationId = bit32.band(flags, 0x1F),
		rotation = nil :: CFrame?,
		velocity = nil :: Vector3?,
		angularVelocity = nil :: Vector3?,
	}

	if flags >= 0x80 then
		local px = buffer.readf32(data, offset)
		local py = buffer.readf32(data, offset + 4)
		local pz = buffer.readf32(data, offset + 8)
		result.position = Vector3.new(px, py, pz)
		offset += 12
	end

	if result.rotationId == 0 then
		local qx, qy, qz, qw
		qx, qy, qz, qw, offset = Codec.ReadCompressedRotation(data, offset)
		result.rotation = CFrame.new(0, 0, 0, qx, qy, qz, qw)
	end

	if bit32.band(flags, 0x40) == 0 then
		local vx = buffer.readf32(data, offset)
		local vy = buffer.readf32(data, offset + 4)
		local vz = buffer.readf32(data, offset + 8)
		result.velocity = Vector3.new(vx, vy, vz)
		offset += 12
	end

	if bit32.band(flags, 0x20) == 0 then
		local ax = buffer.readf32(data, offset)
		local ay = buffer.readf32(data, offset + 4)
		local az = buffer.readf32(data, offset + 8)
		result.angularVelocity = Vector3.new(ax, ay, az)
		offset += 12
	end

	return {
		Result = result,
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [82] = function()local wax,script,require,CreateLookupTable=ImportGlobals(82)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

-- Enum.SecurityCapability.Value is NOT the bit index — engine uses a sparse map.
local BIT_TO_CAPABILITY: { [number]: string } = {
	[0] = "Plugin",
	[1] = "LocalUser",
	[2] = "WritePlayer",
	[3] = "RobloxScript",
	[4] = "RobloxEngine",
	[8] = "RunClientScript",
	[9] = "RunServerScript",
	[11] = "AccessOutsideWrite",
	[15] = "Unassigned",
	[16] = "LoadUnownedAsset", -- AssetRequire alias
	[17] = "LoadString",
	[18] = "ScriptGlobals",
	[19] = "CreateInstances",
	[20] = "Basic",
	[21] = "Audio",
	[22] = "DataStore",
	[23] = "Network",
	[24] = "Physics",
	[25] = "UI",
	[26] = "CSG",
	[27] = "Chat",
	[28] = "Animation",
	[29] = "AvatarAppearance", -- Avatar alias
	[30] = "Input",
	[31] = "Environment",
	[32] = "RemoteEvent",
	[33] = "LegacySound",
	[34] = "Players",
	[35] = "CapabilityControl",
	[36] = "AssetRead",
	[37] = "AssetManagement",
	[38] = "DynamicGeneration",
	[39] = "PlatformAvatarEditing",
	[40] = "AssetCreateUpdate",
	[41] = "Capture",
	[42] = "SensitiveInput",
	[43] = "Monetization",
	[44] = "LoadOwnedAsset",
	[45] = "Social",
	[46] = "ServerCommunication",
	[47] = "Logging",
	[48] = "PromptExternalPurchase",
	[49] = "Groups",
	[50] = "Teleport",
	[51] = "Consequences",
	[52] = "Material",
	[53] = "AvatarBehavior",
	[59] = "RemoteCommand",
	[60] = "InternalTest",
	[61] = "PluginOrOpenCloud",
	[62] = "Assistant",
}

local DecoderModule = {
	Type = VariantTypes.SecurityCapabilities,
}

local function fromBitmask(lo: number, hi: number): SecurityCapabilities
	local caps: { Enum.SecurityCapability } = {}
	for bit = 0, 63 do
		local word = if bit < 32 then lo else hi
		local bitInWord = bit % 32
		if bit32.band(word, bit32.lshift(1, bitInWord)) ~= 0 then
			local name = BIT_TO_CAPABILITY[bit]
			if name then
				local ok, item = pcall(function()
					return (Enum.SecurityCapability :: any)[name]
				end)
				if ok and item then
					table.insert(caps, item)
				end
			end
		end
	end

	if #caps == 0 then
		return SecurityCapabilities.new()
	end
	return SecurityCapabilities.new(table.unpack(caps))
end

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local lo = buffer.readu32(data, offset)
	local hi = buffer.readu32(data, offset + 4)
	return {
		Result = fromBitmask(lo, hi),
		Offset = offset + 8,
	}
end

return DecoderModule

end)() end,
    [83] = function()local wax,script,require,CreateLookupTable=ImportGlobals(83)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.SharedString,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	return {
		Result = buffer.readstring(data, offset, 16),
		Offset = offset + 16,
	}
end

return DecoderModule

end)() end,
    [84] = function()local wax,script,require,CreateLookupTable=ImportGlobals(84)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local STRING_TYPE = VariantTypes.String
local BINARY_STRING_TYPE = VariantTypes.BinaryString

local DecoderModule = {
	Type = { STRING_TYPE, BINARY_STRING_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local length, newOffset = Codec.LEB128(data, offset)
	return {
		Result = buffer.readstring(data, newOffset, length),
		Offset = newOffset + length,
	}
end

return DecoderModule

end)() end,
    [85] = function()local wax,script,require,CreateLookupTable=ImportGlobals(85)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Parent.Codec)
local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local TUPLE_TYPE = VariantTypes.Tuple
local ARRAY_TYPE = VariantTypes.Array

local DecoderModule = {
	Type = { TUPLE_TYPE, ARRAY_TYPE },
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, parser: any, depth: number)
	local length = buffer.len(data)
	local count, nextOffset = Codec.LEB128(data, offset)
	local remainingBytes = length - nextOffset
	if count > remainingBytes then
		return { Result = {}, Offset = -1 }
	end

	local values = table.create(count)
	offset = nextOffset
	for i = 1, count do
		local parsed = parser:Parse(offset, depth + 1)
		if parsed.Offset < 0 then
			return { Result = values, Offset = -1 }
		end
		values[i] = parsed.Result
		offset = parsed.Offset
	end

	return {
		Result = values,
		Offset = offset,
	}
end

return DecoderModule

end)() end,
    [86] = function()local wax,script,require,CreateLookupTable=ImportGlobals(86)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.UDim,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local scale = buffer.readf32(data, offset)
	local udimOffset = buffer.readi32(data, offset + 4)
	return {
		Result = UDim.new(scale, udimOffset),
		Offset = offset + 8,
	}
end

return DecoderModule

end)() end,
    [87] = function()local wax,script,require,CreateLookupTable=ImportGlobals(87)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.UDim2,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	local xs = buffer.readf32(data, offset)
	local xo = buffer.readi32(data, offset + 4)
	local ys = buffer.readf32(data, offset + 8)
	local yo = buffer.readi32(data, offset + 12)
	return {
		Result = UDim2.new(xs, xo, ys, yo),
		Offset = offset + 16,
	}
end

return DecoderModule

end)() end,
    [88] = function()local wax,script,require,CreateLookupTable=ImportGlobals(88)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local DecoderModule = {
	Type = VariantTypes.UniqueId,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, _parser: any, _depth: number)
	return {
		Result = buffer.readstring(data, offset, 16),
		Offset = offset + 16,
	}
end

return DecoderModule

end)() end,
    [89] = function()local wax,script,require,CreateLookupTable=ImportGlobals(89)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

local MAX_DEPTH = 3

local DecoderModule = {
	Type = VariantTypes.ContentId,
}

function DecoderModule.Parse(data: buffer, offset: number, _t: number, parser: any, depth: number)
	if depth >= MAX_DEPTH then
		return { Result = nil, Offset = offset }
	end

	return parser:Parse(offset, depth + 1)
end

return DecoderModule

end)() end,
    [90] = function()local wax,script,require,CreateLookupTable=ImportGlobals(90)local ImportGlobals return (function(...)local VariantTypes = require(script.Parent.Parent.Parent.Constants).VariantTypes

--// Constants \\--
local VECTOR2_TYPE = VariantTypes.Vector2
local VECTOR3_TYPE = VariantTypes.Vector3
local VECTOR2INT16_TYPE = VariantTypes.Vector2int16
local VECTOR3INT16_TYPE = VariantTypes.Vector3int16

local DecoderModule = {
	Type = { VECTOR2_TYPE, VECTOR3_TYPE, VECTOR2INT16_TYPE, VECTOR3INT16_TYPE },
}

local Router = {
	[VECTOR2_TYPE] = function(data: buffer, offset: number)
		local x = buffer.readf32(data, offset)
		local y = buffer.readf32(data, offset + 4)
		return {
			Result = Vector2.new(x, y),
			Offset = offset + 8,
		}
	end,

	[VECTOR3_TYPE] = function(data: buffer, offset: number)
		local x = buffer.readf32(data, offset)
		local y = buffer.readf32(data, offset + 4)
		local z = buffer.readf32(data, offset + 8)
		return {
			Result = Vector3.new(x, y, z),
			Offset = offset + 12,
		}
	end,

	[VECTOR2INT16_TYPE] = function(data: buffer, offset: number)
		local x = buffer.readi16(data, offset)
		local y = buffer.readi16(data, offset + 2)
		return {
			Result = Vector2int16.new(x, y),
			Offset = offset + 4,
		}
	end,

	[VECTOR3INT16_TYPE] = function(data: buffer, offset: number)
		local x = buffer.readi16(data, offset)
		local y = buffer.readi16(data, offset + 2)
		local z = buffer.readi16(data, offset + 4)
		return {
			Result = Vector3int16.new(x, y, z),
			Offset = offset + 6,
		}
	end,
}

function DecoderModule.Parse(data: buffer, offset: number, t: number, _parser: any, _depth: number)
	return Router[t](data, offset)
end

return DecoderModule

end)() end,
    [91] = function()local wax,script,require,CreateLookupTable=ImportGlobals(91)local ImportGlobals return (function(...)--// Imports \\--
local Codec = require(script.Parent.Parent.Codec)

--// Decoders \\--
local LazilyLoadDecoders, Decoders
do
	LazilyLoadDecoders = function()
		if Decoders then
			return
		end
		Decoders = {}

		for _, decoder in script.Parent.Decoders:GetChildren() do
			local Module = require(decoder)
			assert(Module.Type, "Decoder must have a Type field")

			local SanitizedType = {}
			if typeof(Module.Type) == "number" then
				table.insert(SanitizedType, Module.Type)
			elseif typeof(Module.Type) == "table" then
				SanitizedType = Module.Type
			end

			for _, t in SanitizedType do
				Decoders[t] = Module
			end
		end
	end
end

--// Parser \\--
local Parser = {}
Parser.__index = Parser

local MAX_NESTING_DEPTH = 64

function Parser.new(data: buffer)
	LazilyLoadDecoders()
	assert(Decoders, "Could not load variant decoders.")

	local self = setmetatable({
		Data = data,
	}, Parser)
	return self
end

function Parser:Parse(offset: number, depth: number?): { Result: any, Offset: number }
	depth = depth or 0

	local length = buffer.len(self.Data)
	if offset >= length then
		return { Result = nil, Offset = -1 }
	end

	if depth > MAX_NESTING_DEPTH then
		return { Result = nil, Offset = -1 }
	end

	local typeId = buffer.readu8(self.Data, offset)
	offset += 1

	local decoder = Decoders[typeId]
	if not decoder then
		return { Result = nil, Offset = -1 }
	end

	return decoder.Parse(self.Data, offset, typeId, self, depth)
end

export type Arguments = {
	Values: { any },
	Count: number,
}

export type ParsedArguments = Arguments & {
	Offset: number,
}

function Parser:ParseArgs(offset: number, depth: number?): ParsedArguments
	depth = depth or 0

	local length = buffer.len(self.Data)
	if offset >= length then
		return { Values = {}, Offset = offset, Count = 0 }
	end

	local count, nextOffset = Codec.LEB128(self.Data, offset)
	local remainingBytes = length - nextOffset
	if count > remainingBytes then
		return { Values = {}, Offset = -1, Count = 0 }
	end

	offset = nextOffset
	local args = table.create(count)
	for i = 1, count do
		local parsed = self:Parse(offset, depth)
		if parsed.Offset < 0 then
			return { Values = args, Offset = -1, Count = i - 1 }
		end
		args[i] = parsed.Result
		offset = parsed.Offset
	end

	return { Values = args, Offset = offset, Count = count }
end

export type RemoteFunctionPayload = {
	InvokeId: number,
	IsResponse: boolean,
	RequestRef: Codec.InstanceRef?,
	IsError: boolean,
	Error: string?,
	Arguments: Arguments,
	Offset: number,
}

function Parser:ParseRemoteFunction(offset: number, isResponse: boolean, depth: number?): RemoteFunctionPayload
	depth = depth or 0
	local length = buffer.len(self.Data)
	local invokeId, nextOffset = Codec.LEB128(self.Data, offset)
	local requestRef = nil

	-- RemoteFunction requests carry an InstanceRef used by Roblox to correlate
	-- the invocation. Responses omit it and begin their return arguments here.
	if not isResponse then
		requestRef, nextOffset = Codec.ReadInstanceRef(self.Data, nextOffset)
	end

	if isResponse and nextOffset < length and buffer.readu8(self.Data, nextOffset) == 0x3D then
		local start = nextOffset + 1
		local finish = start
		while finish < length and buffer.readu8(self.Data, finish) ~= 0 do
			finish += 1
		end
		if finish >= length then
			return {
				InvokeId = invokeId,
				IsResponse = true,
				RequestRef = nil,
				IsError = true,
				Error = nil,
				Arguments = {
					Values = {},
					Count = 0,
				},
				Offset = -1,
			}
		end
		local message = if finish > start then buffer.readstring(self.Data, start, finish - start) else ""
		return {
			InvokeId = invokeId,
			IsResponse = isResponse,
			RequestRef = requestRef,
			IsError = true,
			Error = message,
			Arguments = {
				Values = {},
				Count = 0,
			},
			Offset = finish + 1,
		}
	end

	local parsed = self:ParseArgs(nextOffset, depth)
	return {
		InvokeId = invokeId,
		IsResponse = isResponse,
		RequestRef = requestRef,
		IsError = false,
		Error = nil,
		Arguments = {
			Values = parsed.Values,
			Count = parsed.Count,
		},
		Offset = parsed.Offset,
	}
end

return Parser

end)() end,
    [92] = function()local wax,script,require,CreateLookupTable=ImportGlobals(92)local ImportGlobals return (function(...)local RakNetWrapper = {
	Hooks = {
		Receive = {},
		Send = {},
	},
}

local function MatchesPacketId(packetIds: number | { number }, packetId: number): boolean
	if typeof(packetIds) == "number" then
		return packetIds == packetId
	end

	return table.find(packetIds, packetId) ~= nil
end

export type RakNetMessage = {
	AsBuffer: buffer,
	AsString: string,
	AsArray: { number },
	Size: number,
	PacketId: number,
	Priority: number,
	Reliability: number,
	OrderingChannel: number,
	Block: (self: RakNetMessage) -> (),
	SetData: (self: RakNetMessage, data: buffer | string | { number }) -> (),
}

function RakNetWrapper.add_receive_hook(packetId: number | { number }, callback: (msg: RakNetMessage) -> ())
	local registeredHook = raknet.add_receive_hook(function(msg: RakNetMessage)
		if MatchesPacketId(packetId, msg.PacketId) then
			callback(msg)
		end
	end)

	table.insert(RakNetWrapper.Hooks.Receive, registeredHook)
	return registeredHook
end

function RakNetWrapper.add_send_hook(packetId: number | { number }, callback: (msg: RakNetMessage) -> ())
	local registeredHook = raknet.add_send_hook(function(msg: RakNetMessage)
		if MatchesPacketId(packetId, msg.PacketId) then
			callback(msg)
		end
	end)

	table.insert(RakNetWrapper.Hooks.Send, registeredHook)
	return registeredHook
end

function RakNetWrapper.remove_all_hooks()
	for _, hook in RakNetWrapper.Hooks.Receive do
		pcall(raknet.remove_receive_hook, hook)
	end

	for _, hook in RakNetWrapper.Hooks.Send do
		pcall(raknet.remove_send_hook, hook)
	end

	RakNetWrapper.Hooks = {
		Receive = {},
		Send = {},
	}
end

return RakNetWrapper

end)() end,
    [93] = function()local wax,script,require,CreateLookupTable=ImportGlobals(93)local ImportGlobals return (function(...)local Log = {}
Log.__index = Log

local PendingCallDecisions = setmetatable({}, { __mode = "k" })

--// Log Call Queue \\--
wax.shared.LogNotificationQueue = {
	Items = {},
	Head = 1,
	Tail = 0,
}

local function QueueNotification(LogObject, CallIndex: number)
	local Queue = wax.shared.LogNotificationQueue
	Queue.Tail += 1
	Queue.Items[Queue.Tail] = {
		Instance = LogObject.Instance,
		Type = LogObject.Type,
		LogIndex = LogObject.Index,
		CallIndex = CallIndex,
	}
end

--// Auto Ignore Constants \\--
local SpamCallCountThreshold = 15
local SpamTimeWindowSeconds = 1
local AutoIgnoreSpammyEvents = false

if not wax.shared.IS_ACTOR then
	wax.shared.Connect(wax.shared.RunService.Heartbeat:Connect(function()
		local Queue = wax.shared.LogNotificationQueue
		local Tail = Queue.Tail

		if Queue.Head > Tail then
			return
		end

		local Batch = {}
		local BatchSize = 0
		while Queue.Head <= Tail do
			local Notification = Queue.Items[Queue.Head]
			Queue.Items[Queue.Head] = nil
			Queue.Head += 1

			if Notification then
				BatchSize += 1
				Batch[BatchSize] = Notification
			end
		end

		table.clear(Queue.Items)
		Queue.Head = 1
		Queue.Tail = 0

		if BatchSize > 0 then
			local Communicator = wax.shared.Communicator
			if Communicator then
				AutoIgnoreSpammyEvents = wax.shared.SaveManager:GetState("AutoIgnoreSpammyEvents", false)
				Communicator:Fire(Batch)
			end

			table.clear(Batch)
		end
	end))
end

--// Actor Table Fixing \\--
local FunctionToMetatadata, FixTable
do
	if wax.shared.IS_ACTOR then
		local FunctionMetadataCache = setmetatable({}, { __mode = "k" })

		local function CreateTraversalState(Refs)
			return {
				CyclicRefs = Refs or {},
				TableIds = setmetatable({}, { __mode = "k" }),
				Functions = setmetatable({}, { __mode = "k" }),
				NextId = 0,
			}
		end

		local function GenerateId(State)
			State.NextId += 1
			return State.NextId
		end

		FixTable = function(Table, State)
			if not Table then
				return nil
			end

			if not State or not State.CyclicRefs then
				State = CreateTraversalState(State)
			end

			local CyclicRefs = State.CyclicRefs
			local TableId = State.TableIds[Table]
			if not TableId then
				TableId = GenerateId(State)
				State.TableIds[Table] = TableId
			end

			local OutputTable = {}
			CyclicRefs[TableId] = OutputTable

			local ContainsCyclicRef = false

			for Key, Value in next, Table do
				if type(Value) == "table" then
					local ExistingId = State.TableIds[Value]
					if ExistingId then
						ContainsCyclicRef = true

						OutputTable[Key] = {
							__CyclicRef = true,
							__Id = ExistingId,
						}
						continue
					end

					if getmetatable(Value) then
						OutputTable[Key] =
							"Cobalt: Impossible to bridge table with metatable from actor Environment to main Environment"
						continue
					end

					local Result, _, ContainsCyclic = FixTable(Value, State)
					if not Result then
						continue
					end

					OutputTable[Key] = Result
					ContainsCyclicRef = ContainsCyclicRef or ContainsCyclic
				elseif type(Value) == "function" then
					OutputTable[Key] = FunctionToMetatadata(Value, State)
				else
					OutputTable[Key] = Value
				end
			end

			return OutputTable, CyclicRefs, ContainsCyclicRef
		end

		FunctionToMetatadata = function(Function, State)
			if not Function then
				return nil
			end

			if not State or not State.CyclicRefs then
				State = CreateTraversalState()
			end

			local CachedMetadata = FunctionMetadataCache[Function]
			if CachedMetadata then
				return CachedMetadata
			end

			local Metadata = {
				Address = tostring(Function),
				Name = debug.info(Function, "n"),
				Source = debug.info(Function, "s"),
				IsC = iscclosure(Function),
			}

			if State.Functions[Function] then
				Metadata["Recursive"] = true
				Metadata["Validation"] = Data.Token
				Metadata["__Function"] = true

				return Metadata
			end

			State.Functions[Function] = true

			if not iscclosure(Function) then
				Metadata["Upvalues"] = debug.getupvalues and #debug.getupvalues(Function) or 0
				Metadata["Constants"] = debug.getconstants and #debug.getconstants(Function) or 0
				Metadata["Protos"] = debug.getprotos and #debug.getprotos(Function) or 0

				if getfunctionhash then
					Metadata["FunctionHash"] = getfunctionhash(Function)
				end
			end

			-- to validate that this function was generated by FunctionToMetatadata
			Metadata["Validation"] = Data.Token
			Metadata["__Function"] = true

			FunctionMetadataCache[Function] = Metadata

			return Metadata
		end
	end
end

--// Cloning \\--
function DeepClone(OriginalValue, ValueCopies)
	if wax.shared.IS_ACTOR then
		return OriginalValue
	end

	local ValueType = type(OriginalValue)
	if ValueType == "userdata" then
		local ValueRobloxType = typeof(OriginalValue)

		if ValueRobloxType == "Instance" then
			return cloneref(OriginalValue)

		elseif ValueRobloxType == "userdata" then
			if getmetatable(OriginalValue) then
				return newproxy(true)
			else
				return newproxy()
			end

		else
			return OriginalValue
		end

	elseif ValueType == "function" then
		if clonefunction then
			return clonefunction(OriginalValue)
		else
			return OriginalValue
		end

	elseif ValueType ~= "table" then
		return OriginalValue
	end

	-- Cycle detection
	if ValueCopies then
		local CachedValue = ValueCopies[OriginalValue]
		if CachedValue then
			return CachedValue
		end
	else
		ValueCopies = {}
	end

	-- Shallow copy first, then selectively recurse
	local ShallowCopy = table.create(rawlen(OriginalValue))
	ValueCopies[OriginalValue] = ShallowCopy

	for Key, Value in next, OriginalValue do
		local ClonedKey = DeepClone(Key, ValueCopies)
		ShallowCopy[ClonedKey] = DeepClone(Value, ValueCopies)
	end

	return ShallowCopy
end

if wax.shared.IS_ACTOR then
	wax.shared.SerializeActorInfo = function(Info)
		return FixTable(DeepClone(Info))
	end
end

function Log.new(Instance, Type, Index, CallingScript)
	local NewLog = setmetatable({
		Instance = Instance,
		Type = Type,
		Index = Index,
		Calls = {},
		GameCalls = {},
		SpamWindowStart = 0,
		SpamCallCount = 0,
		Ignored = false,
		Blocked = false,
		Button = nil,
	}, Log)

	return NewLog
end

function Log:IsOverSpamThreshold()
	if not AutoIgnoreSpammyEvents then
		return false
	end

	local Now = tick()
	if Now - self.SpamWindowStart > SpamTimeWindowSeconds then
		self.SpamWindowStart = Now
		self.SpamCallCount = 0
	end

	self.SpamCallCount = self.SpamCallCount + 1

	if self.SpamCallCount > SpamCallCountThreshold then
		if not self.Ignored then
			self.Ignore(self)
			wax.shared.Sonner.info(`Ignored {self.Instance.Name} ({self.Type}) due to event spam.`)
		end

		return true
	end

	return false
end

local function RunInterceptors(Interceptors: { (...any) -> ...any }, Info: any, Log): boolean
	for _, Callback in Interceptors do
		local Ok, Result = pcall(Callback, Info, Log.Instance, Log.Type)
		if not Ok then
			warn(`[Cobalt Plugin Interceptor] Error: {Result}`)
		elseif Result == false then
			return true
		end
	end

	return false
end

function Log:ShouldBlock(RawInfo, PendingCallDecisionsKey): boolean
	PendingCallDecisionsKey = PendingCallDecisionsKey or tostring(RawInfo)

	local Decision = PendingCallDecisions[PendingCallDecisionsKey]
	if Decision then
		return Decision.ShouldBlock
	end

	local FilterAction
	local CallFilters = wax.shared.CallFilters
	do
		if CallFilters then
			FilterAction = CallFilters:Resolve(self.Instance, self.Type, RawInfo)
		end
	end

	local ShouldBlock = RawInfo.Blocked == true or self.Blocked or FilterAction == "Block"
	if ShouldBlock then
		RawInfo.Blocked = true
	end

	PendingCallDecisions[PendingCallDecisionsKey] = {
		FilterAction = FilterAction,
		ShouldBlock = ShouldBlock,
	}
	return ShouldBlock
end

function Log:Call(RawInfo): number?
	local PendingCallDecisionsKey = tostring(RawInfo)

	local ShouldBlock = self:ShouldBlock(RawInfo, PendingCallDecisionsKey)
	local Decision = PendingCallDecisions[PendingCallDecisionsKey]
	PendingCallDecisions[PendingCallDecisionsKey] = nil

	local ShouldCapture = not self.Ignored and Decision.FilterAction ~= "Ignore"
	do
		if ShouldBlock then
			ShouldCapture = ShouldCapture and wax.shared.SaveManager:GetState("LogBlockedRemotes", false)
		end

		if RawInfo.Omit then
			ShouldCapture = false
		end
	end

	if not ShouldCapture then
		return nil
	end

	--// Ratelimiting \\--
	if not wax.shared.IS_ACTOR then
		local Success, SpamData = pcall(function() return self.IsOverSpamThreshold(self) end)
		if Success and SpamData then
			return nil
		end
	end

	--// Info stuff \\--
	local Info = DeepClone(RawInfo)
	Info.CreationTime = tick()

	--// Actor Relaying \\--
	if wax.shared.IS_ACTOR then
		if self.Instance == wax.shared.Communicator then
			return nil
		end

		Info["Actor"] = CurrentActor

		--// Fix Arguments \\--
		local OldArguments = Info.Arguments
		Info.Arguments = {
			Data = OldArguments,
			n = OldArguments.n,
		}

		if Info.InvokeResult then
			local OldInvokeResult = Info.InvokeResult
			Info.InvokeResult = {
				Data = OldInvokeResult,
				n = OldInvokeResult.n,
			}
		end

		local FixedInfo, CyclicRefs, ContainsCyclicRef = FixTable(Info)

		-- Seliware puts their actor BindableEvents in CoreGui
		local identity = getthreadidentity()
		setthreadidentity(8)
		wax.shared.Communicator.Fire(
			wax.shared.Communicator,
			"ActorCall",
			self.Instance,
			self.Type,
			FixedInfo,
			CyclicRefs,
			ContainsCyclicRef
		)
		setthreadidentity(identity)
		return nil
	end

	--// Plugin Interceptors \\--
	local PluginManager = wax.shared.CobaltPluginManager
	if PluginManager and PluginManager.HasInterceptors then
		-- Run Instance-specific interceptors (both exact type and "All")
		local InstanceIntercept = PluginManager.Registry.Interceptors.Instance[self.Instance]
		if InstanceIntercept then
			if InstanceIntercept[self.Type] and RunInterceptors(InstanceIntercept[self.Type], Info, self) then
				return nil
			end
			if InstanceIntercept["All"] and RunInterceptors(InstanceIntercept["All"], Info, self) then
				return nil
			end
		end

		-- Run Global interceptors (both exact type and "All")
		local GlobalByType = PluginManager.Registry.Interceptors.Global[self.Type]
		if GlobalByType and RunInterceptors(GlobalByType, Info, self) then
			return nil
		end

		local GlobalAll = PluginManager.Registry.Interceptors.Global["All"]
		if GlobalAll and RunInterceptors(GlobalAll, Info, self) then
			return nil
		end
	end

	--// Update Log \\--
	local Index = #self.Calls + 1
	self.Calls[Index] = Info
	if not Info.IsExecutor then
		table.insert(self.GameCalls, Index)
	end

	QueueNotification(self, Index)
	return Index
end

function Log:ClearCalls()
	table.clear(self.Calls)
	table.clear(self.GameCalls)
end

function Log:Ignore()
	self.Ignored = not self.Ignored

	if not wax.shared.IS_ACTOR then
		if wax.shared.ActorCommunicator then
			pcall(wax.shared.ActorCommunicator.Fire, wax.shared.ActorCommunicator, "MainIgnore", self.Instance, self.Type)
		end

		local IgnoredRemoteList = wax.shared.Settings["IgnoredRemotes"]
		if IgnoredRemoteList then
			if self.Ignored then
				IgnoredRemoteList:AddToList(self)
			else
				IgnoredRemoteList:RemoveFromList(self)
			end
		end
	end
end

local ClassesConnectionsToggle = {
	RemoteEvent = "OnClientEvent",
	UnreliableRemoteEvent = "OnClientEvent",
	BindableEvent = "Event",
}

function Log:SetConnectionsEnabled(enabled: boolean)
	if not self.Instance or not ClassesConnectionsToggle[self.Instance.ClassName] then
		return
	end

	local ConnectionName = ClassesConnectionsToggle[self.Instance.ClassName]
	if self.Type ~= "Incoming" or not ConnectionName then
		return
	end

	local LoggingFunctions = wax.shared.IncomingLogConnectionFunctions
	for _, Connection in pairs(getconnections(self.Instance[ConnectionName])) do
		if LoggingFunctions and LoggingFunctions[Connection.Function] then
			continue
		end

		if enabled then
			Connection:Enable()
		else
			Connection:Disable()
		end
	end
end

function Log:Block()
	if not wax.shared.IS_ACTOR and wax.shared.ActorCommunicator then
		pcall(wax.shared.ActorCommunicator.Fire, wax.shared.ActorCommunicator, "MainBlock", self.Instance, self.Type)
	end

	self.Blocked = not self.Blocked
	self:SetConnectionsEnabled(not self.Blocked)
end

function Log:SetButton(Instance, Name, Calls)
	self.Button = {
		Instance = Instance,
		Name = Name,
		Calls = Calls,
	}
end

return Log

end)() end,
    [94] = function()local wax,script,require,CreateLookupTable=ImportGlobals(94)local ImportGlobals return (function(...)local LogStore = {}

local IsEqualToInstance = require("@src/Utils/CodeGen/Serializer/Instance").IsEqualToInstance

function LogStore.GetMatching(FilterInstance: Instance?, FilterType: string?): { any }
	local Logs = {}

	for Type, LogCategory in pairs(wax.shared.Logs) do
		if FilterType and Type ~= FilterType then
			continue
		end

		for _, Log in pairs(LogCategory) do
			if FilterInstance and not IsEqualToInstance(Log.Instance, FilterInstance) then
				continue
			end

			table.insert(Logs, Log)
		end
	end

	return Logs
end

function LogStore.Clear(FilterInstance: Instance?, FilterType: string?): { any }
	local ClearedLogs = LogStore.GetMatching(FilterInstance, FilterType)

	for _, Log in ClearedLogs do
		Log:ClearCalls()
	end

	return ClearedLogs
end

return LogStore

end)() end,
    [95] = function()local wax,script,require,CreateLookupTable=ImportGlobals(95)local ImportGlobals return (function(...)--[[

Pagination Module
made by deivid and turned into module by upio

]]

local Pagination = {}
Pagination.__index = Pagination

type PaginationOptions = {
	TotalItems: number,
	ItemsPerPage: number,
	CurrentPage: number?,
	SiblingCount: number?,
}

type PaginationOptionKeys = keyof<PaginationOptions>
export type Pagination = typeof(Pagination)

function Pagination.new(Options: PaginationOptions)
	return setmetatable({
		TotalItems = Options.TotalItems,
		ItemsPerPage = Options.ItemsPerPage,
		CurrentPage = Options.CurrentPage or 1,
		SiblingCount = Options.SiblingCount or 2,
	}, Pagination)
end

function Pagination:GetInfo()
	local TotalPages = math.ceil(self.TotalItems / self.ItemsPerPage)

	return {
		TotalItems = self.TotalItems,
		ItemsPerPage = self.ItemsPerPage,
		CurrentPage = self.CurrentPage,
		TotalPages = TotalPages,
	}
end

function Pagination:SetOption(Key: PaginationOptionKeys, Value: any)
	local Mapping = {
		["ItemsPerPage"] = function(Value: number)
			self:SetItemsPerPage(Value)
		end,
		["TotalItems"] = function(Value: number)
			self:Update(Value)
		end,
		["CurrentPage"] = function(Value: number)
			self:SetPage(Value)
		end,
	}

	Mapping[Key](Value)
end

function Pagination:SetItemsPerPage(max: number)
	self.ItemsPerPage = max
end

function Pagination:GetIndexRanges(Page: number?)
	Page = Page or self.CurrentPage

	local TotalPages = math.ceil(self.TotalItems / self.ItemsPerPage)
	if TotalPages == 0 then
		return 1, 0
	end
	assert(
		Page <= TotalPages,
		"Attempted to get invalid page out of range, got " .. Page .. " but max is " .. TotalPages
	)

	local Start = (((Page or self.CurrentPage) - 1) * self.ItemsPerPage) + 1
	local End = Start + (self.ItemsPerPage - 1)

	return Start, End
end

function Pagination:SetPage(Page: number)
	local TotalPages = math.ceil(self.TotalItems / self.ItemsPerPage)
	if TotalPages == 0 then
		self.CurrentPage = 1
		return
	end
	assert(Page <= TotalPages, "Attempted to set page out of range, got " .. Page .. " but max is " .. TotalPages)

	self.CurrentPage = Page
end

function Pagination:Update(TotalItems: number?, ItemsPerPage: number?)
	self.TotalItems = TotalItems or self.TotalItems
	self.ItemsPerPage = ItemsPerPage or self.ItemsPerPage
end

function Pagination:GetVisualInfo(Page: number?)
	Page = Page or self.CurrentPage

	local TotalPages = math.ceil(self.TotalItems / self.ItemsPerPage)
	if TotalPages == 0 then
		return {}
	end

	assert(
		Page <= TotalPages,
		"Attempted to get invalid page out of range, got " .. Page .. " but max is " .. TotalPages
	)

	local MaxButtons = 5 + self.SiblingCount * 2
	local Result = table.create(MaxButtons, "none")
	if TotalPages <= MaxButtons then
		for i = 1, TotalPages do
			Result[i] = i
		end
		return Result
	end

	local LeftSibling = math.max(Page - self.SiblingCount, 1)
	local RightSibling = math.min(Page + self.SiblingCount, TotalPages)

	local FakeLeft = LeftSibling > 2
	local FakeRight = RightSibling < TotalPages - 1

	local TotalPageNumbers = math.min(2 * self.SiblingCount + 5, TotalPages)
	local ItemCount = TotalPageNumbers - 2

	if not FakeLeft and FakeRight then
		for i = 1, ItemCount do
			Result[i] = i
		end
		Result[ItemCount + 1] = "ellipsis"
		Result[ItemCount + 2] = TotalPages
		--return MergeTables(LeftRange, "ellipsis", TotalPages)
		return Result
	elseif FakeLeft and not FakeRight then
		--local RightRange = CreateArray(TotalPages - ItemCount + 1, TotalPages)
		Result[1] = 1
		Result[2] = "ellipsis"

		local Index = 3
		for i = TotalPages - ItemCount + 1, TotalPages do
			Result[Index] = i
			Index += 1
		end

		return Result
	elseif FakeLeft and FakeRight then
		--local MiddleRange = CreateArray(LeftSibling, RightSibling)
		Result[1] = 1
		Result[2] = "ellipsis"
		local Index = 3

		for i = LeftSibling, RightSibling do
			Result[Index] = i
			Index += 1
		end

		Result[Index] = "ellipsis"
		Result[Index + 1] = TotalPages

		return Result
		--return MergeTables(1, "ellipsis", MiddleRange, "ellipsis", TotalPages)
	end

	--return CreateArray(1, TotalPages)
	for i = 1, TotalPages do
		Result[i] = i
	end
	return Result
end

return Pagination

end)() end,
    [98] = function()local wax,script,require,CreateLookupTable=ImportGlobals(98)local ImportGlobals return (function(...)--// Imports \\--
local Formatter = require("@src/Utils/CodeGen/Formatter")
local InstanceSerializer = require("@src/Utils/CodeGen/Serializer/Instance")
local LazySerializer = require("@src/Window/Utils/Text/LazySerializer")

local CodeGen = {}

function CodeGen.Apply(Cobalt, Manager)
	function Cobalt.CodeGen:InterceptGeneration(
		Type: "Call" | "Hook" | "InstancePath",
		Callback: (Info: any, ...any) -> ...any
	)
		Manager.HasCodeGenInterceptors = true

		local Interceptors = Manager.Registry.UIHooks.CodeGen[Type]
		assert(Interceptors, "Invalid Code Generation Type")

		table.insert(Interceptors, Callback)

		return function()
			local Index = table.find(Interceptors, Callback)
			if Index then
				table.remove(Interceptors, Index)
			end
		end
	end

	function Cobalt.CodeGen.Serialize(data, options)
		if typeof(data) == "table" then
			return wax.shared.LuaEncode(data, options)
		elseif typeof(data) == "Instance" then
			return InstanceSerializer.Serialize(data, options)
		end

		return LazySerializer.QuickSerializeArgument(data)
	end

	function Cobalt.CodeGen.Indent(str: string, indent: number)
		return Formatter.IndentCode(str, indent)
	end
end

return CodeGen

end)() end,
    [99] = function()local wax,script,require,CreateLookupTable=ImportGlobals(99)local ImportGlobals return (function(...)--// Imports \\--
local Types = require("@src/Utils/CodeGen/Types")

local Bridge = require(script.Parent.Parent.Bridge)

local Spy = {}

function Spy.Apply(Cobalt, Manager)
	type InterceptorFunction = (Info: Types.CallInfo, Instance: Instance, Type: "Incoming" | "Outgoing") -> ...any

	function Cobalt.Spy:InterceptExecutedCalls(
		Type: "Incoming" | "Outgoing" | "All",
		Data: {
			Callback: InterceptorFunction,
			Instance: Instance | nil,
		} | InterceptorFunction
	)
		Manager.HasInterceptors = true

		local Options = typeof(Data) == "table" and setmetatable(Data, { __mode = "v" })
			or setmetatable({
				Callback = Data,
				Instance = nil,
			}, { __mode = "v" })

		local IsInstanceSpecific = Options.Instance ~= nil

		if IsInstanceSpecific then
			local InstanceInterceptors = Manager.Registry.Interceptors.Instance[Options.Instance]
			if not InstanceInterceptors then
				Manager.Registry.Interceptors.Instance[Options.Instance] = {}
				InstanceInterceptors = Manager.Registry.Interceptors.Instance[Options.Instance]
			end

			if not InstanceInterceptors[Type] then
				InstanceInterceptors[Type] = {}
			end

			table.insert(InstanceInterceptors[Type], Options.Callback)
		else
			local GlobalInterceptors = Manager.Registry.Interceptors.Global[Type]
			if not GlobalInterceptors then
				Manager.Registry.Interceptors.Global[Type] = {}
				GlobalInterceptors = Manager.Registry.Interceptors.Global[Type]
			end

			table.insert(GlobalInterceptors, Options.Callback)
		end

		return function()
			if IsInstanceSpecific then
				if not Options.Instance then
					return
				end

				local InstanceInterceptors = Manager.Registry.Interceptors.Instance[Options.Instance]
				if not InstanceInterceptors then
					return
				end

				local Interceptors = InstanceInterceptors[Type]
				if not Interceptors then
					return
				end

				local Index = table.find(Interceptors, Options.Callback)
				if Index then
					table.remove(Interceptors, Index)
				end
			else
				local GlobalInterceptors = Manager.Registry.Interceptors.Global[Type]
				if not GlobalInterceptors then
					return
				end

				local Index = table.find(GlobalInterceptors, Options.Callback)
				if Index then
					table.remove(GlobalInterceptors, Index)
				end
			end
		end
	end

	function Cobalt.Spy:ClearLogs(Instance: Instance?, Type: string?)
		Bridge.Get().ClearLogs(Instance, if Type == "All" then nil else Type)
	end

	function Cobalt.Spy:AppendLog(Instance: Instance, Type: "Incoming" | "Outgoing", Data: {})
		local DebugId = wax.shared.GetDebugId(Instance)
		local Log = wax.shared.Logs[Type][DebugId] or wax.shared.NewLog(Instance, Type, nil, DebugId)
		Log:Call(Data)
	end

	function Cobalt:GetLog(instance: Instance, type: "Incoming" | "Outgoing")
		local DebugId = wax.shared.GetDebugId(instance)
		return wax.shared.Logs[type][DebugId]
	end
end

return Spy

end)() end,
    [100] = function()local wax,script,require,CreateLookupTable=ImportGlobals(100)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Resize = require("@src/Window/Utils/Input/Resize")
local Highlighter = require("@src/Window/Utils/Text/Highlighter")

local Signals = require("@src/Utils/Signal")
local Types = require("@src/Utils/CodeGen/Types")

local Bridge = require(script.Parent.Parent.Bridge)

local UI = {}

function UI.Apply(Cobalt, Manager, State)
	function Cobalt.UI:GetSelectedRemote()
		local Log = Bridge.Get().GetCurrentLog()
		return Log and Log.Instance or nil, Log and Log.Type or nil
	end

	function Cobalt.UI:CreateModal(Title: string, Icon: string)
		local WindowBridge = Bridge.Get()
		local ModalController = WindowBridge.ModalController

		local ModalFrame: TextButton = Interface.New("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(10, 10, 10),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0.65, 0, 0, 285),
			Text = "",
			Visible = false,
			Parent = ModalController.Background,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 8),
			},

			["UIStroke"] = {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
			},
		})

		Resize.new({
			MainFrame = ModalFrame,

			MaximumSize = UDim2.new(1, -2, 1, -2),
			MinimumSize = UDim2.fromScale(0.65, 0.712),
			Mirrored = true,
			LockedPosition = true,

			CornerHandleSize = 20,
			HandleSize = 6,
			GetDPIScale = WindowBridge.GetDPIScale,
		})

		ModalController:CreateTop(Title, Icon, ModalFrame)

		local ContentFrame = Interface.New("ScrollingFrame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 1, -37),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollBarThickness = 0,
			HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Parent = ModalFrame,
		})

		local OnCloseEvent = Signals:New()
		local ClosedByInternal = false

		ModalFrame:GetPropertyChangedSignal("Visible"):Connect(function()
			if not ModalFrame.Visible and not ClosedByInternal then
				OnCloseEvent:Fire()
			end
			ClosedByInternal = false
		end)

		local TabsState = {
			Container = nil,
			Scroller = nil,
			FooterContainer = nil,
			CurrentTab = nil,
			Buttons = {},
			Contents = {},
		}

		local ModalInterface = {
			Container = ContentFrame,
			Open = function()
				ModalController:Open(ModalFrame)
			end,
			Close = function()
				ClosedByInternal = true
				ModalController:Close()
				OnCloseEvent:Fire()
			end,
			OnClose = OnCloseEvent,
		}

		function ModalInterface:SelectTab(TabName: string)
			if not TabsState.Buttons[TabName] then
				return
			end

			for _, Button in pairs(TabsState.Buttons) do
				Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				Button.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			end
			for _, Content in pairs(TabsState.Contents) do
				Content.Visible = false
			end

			TabsState.Buttons[TabName].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			TabsState.Buttons[TabName].Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			TabsState.Contents[TabName].Visible = true
			TabsState.CurrentTab = TabName
		end

		function ModalInterface:AddTab(TabName: string, Icon: string)
			if not TabsState.Container then
				ContentFrame.Visible = false

				TabsState.Scroller = Interface.New("ScrollingFrame", {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 4, 0, 44),
					Size = UDim2.new(1, -10, 0, 36),
					CanvasSize = UDim2.fromScale(0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.X,
					ClipsDescendants = false,
					Parent = ModalFrame,
				})

				TabsState.Container = Interface.New("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromScale(0, 1),
					Parent = TabsState.Scroller,

					["UIListLayout"] = {
						Padding = UDim.new(0, 6),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					},

					["UIPadding"] = {
						PaddingRight = UDim.new(0, 20),
						PaddingTop = UDim.new(0, 2),
						PaddingLeft = UDim.new(0, 2),
					},
				})
			end

			local TabUI, TabContent = WindowBridge.InfoModal.Tabs:CreateTabContent()

			if TabsState.FooterContainer then
				TabUI.Size = UDim2.new(1, -12, 1, -118)
			else
				TabUI.Size = UDim2.new(1, -12, 1, -79)
			end

			TabUI.Parent = ModalFrame
			TabUI.Visible = false

			local TextWrapper = Interface.New("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.fromOffset(0, 24),
				ZIndex = 2,

				["UIListLayout"] = {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 5),
				},

				["UIPadding"] = {
					PaddingRight = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
				},

				["TextLabel"] = {
					Text = TabName,
					TextSize = 15,
					Size = UDim2.fromScale(0, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					LayoutOrder = 2,
					ZIndex = 2,
				},
			})

			Interface.NewIcon(Icon, {
				Position = UDim2.fromOffset(8, 5),
				Size = UDim2.fromOffset(16, 16),
				LayoutOrder = 1,
				ZIndex = 2,
				Parent = TextWrapper,
			})

			local ButtonColor = TabsState.CurrentTab == TabName and Color3.fromRGB(25, 25, 25)
				or Color3.fromRGB(0, 0, 0)
			local TabButton = Interface.New("TextButton", {
				BackgroundColor3 = ButtonColor,
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = "",
				Parent = TabsState.Container,

				["UICorner"] = {
					CornerRadius = UDim.new(0, 8),
				},

				["UIStroke"] = {
					Color = Color3.fromRGB(25, 25, 25),
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				},

				["Frame"] = {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.fromScale(1, 0.6),
					BackgroundColor3 = ButtonColor,
					BorderSizePixel = 0,
				},

				TextWrapper,
			})

			TabsState.Buttons[TabName] = TabButton
			TabsState.Contents[TabName] = TabUI

			TabButton.MouseButton1Click:Connect(function()
				ModalInterface:SelectTab(TabName)
			end)

			if not TabsState.CurrentTab then
				ModalInterface:SelectTab(TabName)
			end

			return TabContent
		end

		function ModalInterface:AddFooterButton(Icon: string, Title: string, Options: {})
			if not TabsState.FooterContainer then
				TabsState.FooterContainer = Interface.New("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 6, 1, -7),
					Size = UDim2.new(1, -12, 0, 32),
					Parent = ModalFrame,

					["UIListLayout"] = {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 6),
					},
				})

				ContentFrame.Size = UDim2.new(1, 0, 1, -69)
				for _, Content in pairs(TabsState.Contents) do
					Content.Size = UDim2.new(1, -12, 1, -118)
				end
			end

			local Button = WindowBridge.InfoModal.Footer:CreateDropdownButton(Icon, Title, Options)
			Button.Parent = TabsState.FooterContainer

			return Button
		end

		return ModalInterface
	end

	function Cobalt.UI:CreatePluginSettings()
		if not State.CurrentPluginSettings then
			State.CurrentPluginSettings = Bridge.Get().PluginsModal.Settings:CreateSection(
				State.CurrentPluginData.Name,
				`PluginSettings-{State.CurrentPluginData.Name}-`
			)
		end

		return State.CurrentPluginSettings
	end

	function Cobalt.UI.RemoteInfo:CreateTab(TabName: string, Icon: string)
		local InfoModal = Bridge.Get().InfoModal
		local TabUI, TabContent = InfoModal.Tabs:CreateTabContent()
		InfoModal.Tabs:CreateTab(Icon, TabName, TabUI)

		return TabContent, TabUI
	end

	function Cobalt.UI.RemoteInfo:DisableDefaultButtons(TabName: string)
		local TabRegistry = Manager.Registry.UIHooks.RemoteInfo.Tabs[TabName]
		if not TabRegistry then
			Manager.Registry.UIHooks.RemoteInfo.Tabs[TabName] = { DisableDefaults = true, Buttons = {} }
		else
			TabRegistry.DisableDefaults = true
		end

		Cobalt.UI.RemoteInfo.UpdateFooterButtons()
	end

	function Cobalt.UI.RemoteInfo.UpdateFooterButtons()
		local WindowBridge = Bridge.GetOptional()
		if WindowBridge and WindowBridge.InfoModal and WindowBridge.InfoModal.Footer then
			WindowBridge.InfoModal.Footer:UpdateDropdownButtons()
		end
	end

	function Cobalt.UI.RemoteInfo:AddFooterButton(TabName: string, Icon: string, Title: string, Options: {})
		local TabRegistry = Manager.Registry.UIHooks.RemoteInfo.Tabs[TabName]
		if not TabRegistry then
			TabRegistry = { DisableDefaults = false, Buttons = {} }
			Manager.Registry.UIHooks.RemoteInfo.Tabs[TabName] = TabRegistry
		end

		local ButtonDefinition: { [any]: any } = {
			Icon = Icon,
			Title = Title,
			Options = Options,
		}

		table.insert(TabRegistry.Buttons, ButtonDefinition)
		Cobalt.UI.RemoteInfo.UpdateFooterButtons()

		return function()
			local Index = table.find(TabRegistry.Buttons, ButtonDefinition)
			if Index then
				table.remove(TabRegistry.Buttons, Index)

				if ButtonDefinition.Instance then
					ButtonDefinition.Instance.Parent = nil
				end

				Cobalt.UI.RemoteInfo.UpdateFooterButtons()
			end
		end
	end

	function Cobalt.UI.RemoteInfo:BindToModalOpen(Callback: (CallInfo: Types.CallInfo) -> ...any)
		table.insert(Manager.Registry.UIHooks.RemoteInfo.Open, Callback)

		return function()
			local Index = table.find(Manager.Registry.UIHooks.RemoteInfo.Open, Callback)
			if Index then
				table.remove(Manager.Registry.UIHooks.RemoteInfo.Open, Index)
			end
		end
	end

	function Cobalt.UI.RemoteInfo:InterceptModalOpen(Callback: (CallInfo: Types.CallInfo) -> boolean?)
		table.insert(Manager.Registry.UIHooks.RemoteInfo.Intercept, Callback)

		return function()
			local Index = table.find(Manager.Registry.UIHooks.RemoteInfo.Intercept, Callback)
			if Index then
				table.remove(Manager.Registry.UIHooks.RemoteInfo.Intercept, Index)
			end
		end
	end

	function Cobalt.UI.ContextMenu:AddOption(
		MenuType: "RemoteList" | "CallList",
		Icon: string,
		Title: string,
		Callback: (InteractionData: any) -> ()
	)
		if not Manager.Registry.UIHooks.ContextMenus[MenuType] then
			warn(
				`[Cobalt] Invalid MenuType provided to ContextMenu:AddOption. Expected RemoteList | CallList, got {tostring(
					MenuType
				)}`
			)
			return function() end
		end

		local OptionDefinition = {
			Icon = Icon,
			Text = Title,
			Callback = Callback,
		}

		table.insert(Manager.Registry.UIHooks.ContextMenus[MenuType], OptionDefinition)

		return function()
			local Index = table.find(Manager.Registry.UIHooks.ContextMenus[MenuType], OptionDefinition)
			if Index then
				table.remove(Manager.Registry.UIHooks.ContextMenus[MenuType], Index)
			end
		end
	end

	function Cobalt.UI.ColorizeLuauCode(code: string)
		return Highlighter.Run(code)
	end

	for Idx, Value in Interface do
		Cobalt.UI[Idx] = Value
	end
end

return UI

end)() end,
    [101] = function()local wax,script,require,CreateLookupTable=ImportGlobals(101)local ImportGlobals return (function(...)local Bridge = {
	Current = nil,
}

function Bridge.Attach(WindowBridge)
	Bridge.Current = WindowBridge

	if WindowBridge.InfoModal and WindowBridge.InfoModal.Footer then
		WindowBridge.InfoModal.Footer:UpdateDropdownButtons()
	end
end

function Bridge.Get()
	assert(Bridge.Current, "Cobalt plugin window bridge has not been attached.")
	return Bridge.Current
end

function Bridge.GetOptional()
	return Bridge.Current
end

return Bridge

end)() end,
    [102] = function()local wax,script,require,CreateLookupTable=ImportGlobals(102)local ImportGlobals return (function(...)--// Imports \\--
local Metadata = require(script.Parent.Metadata)

local CodeGenAPI = require(script.Parent.API.CodeGen)
local SpyAPI = require(script.Parent.API.Spy)
local UIAPI = require(script.Parent.API.UI)

local Environment = {}

function Environment.Create(
	Manager,
	FilePath: string,
	PluginCallback: (...any) -> ...any,
	PluginThread: thread,
	PluginErrored: (string, any) -> ()
)
	local State = {
		CurrentPluginData = nil,
		CurrentPluginSettings = nil,
	}

	local Cobalt = {
		Sonner = wax.shared.Sonner,
		UI = { RemoteInfo = {}, ContextMenu = {} },
		Spy = {},
		CodeGen = {},
		ExecutorSupport = wax.shared.ExecutorSupport,
	}

	Cobalt.Settings = setmetatable({}, {
		__index = function(_, key)
			return wax.shared.SaveManager:GetState(key, false)
		end,
		__newindex = function(_, key, value)
			wax.shared.SaveManager:SetState(key, value)
		end,
	})

	function Cobalt:BindToUnload(Callback: () -> ())
		for _, Plugin in Manager.Registry.Plugins do
			if Plugin.PluginData == State.CurrentPluginData then
				table.insert(Plugin.UnloadCallbacks, Callback)
				return
			end
		end
	end

	UIAPI.Apply(Cobalt, Manager, State)
	SpyAPI.Apply(Cobalt, Manager)
	CodeGenAPI.Apply(Cobalt, Manager)

	setmetatable(Cobalt, {
		__newindex = function(_, Key, Value)
			if Key:lower() == "plugindata" then
				local PluginData = Metadata.Validate(Value)

				if not Metadata.IsSupportedInCurrentGame(PluginData) then
					PluginErrored(FilePath, "Plugin is not supported in this game.")

					if coroutine.status(PluginThread) ~= "dead" then
						pcall(task.cancel, PluginThread)
					end

					return
				end

				table.insert(Manager.Registry.Plugins, {
					FilePath = FilePath,
					PluginData = PluginData,
					PluginThread = PluginThread,
					UnloadCallbacks = {},
				})

				State.CurrentPluginData = PluginData
				return
			end

			return rawset(Cobalt, Key, Value)
		end,
	})

	return setmetatable({ Cobalt = Cobalt }, {
		__index = getfenv(PluginCallback),
	})
end

return Environment

end)() end,
    [103] = function()local wax,script,require,CreateLookupTable=ImportGlobals(103)local ImportGlobals return (function(...)local Errors = {}

function Errors.PluginErrored(Manager, FilePath, Error)
	if #Manager.Registry.Errored == 0 then
		wax.shared.Sonner.error(`Failed to load plugin: {FilePath}.`)
	end

	local PluginIndex
	do
		for Idx, Plugin in Manager.Registry.Plugins do
			if Plugin.FilePath ~= FilePath then
				continue
			end

			PluginIndex = Idx
			break
		end
	end

	if PluginIndex then
		local PluginInfo = table.remove(Manager.Registry.Plugins, PluginIndex)
		for _, Callback in PluginInfo.UnloadCallbacks or {} do
			task.spawn(pcall, Callback)
		end

		local PluginData = PluginInfo.PluginData or {}
		table.insert(Manager.Registry.Errored, {
			FilePath = PluginInfo.FilePath,
			Name = PluginData.Name,
			Author = PluginData.Author,
			Version = PluginData.Version,
			Error = Error,
		})
	else
		table.insert(Manager.Registry.Errored, {
			FilePath = FilePath,
			Error = Error,
		})
	end
end

return Errors

end)() end,
    [104] = function()local wax,script,require,CreateLookupTable=ImportGlobals(104)local ImportGlobals return (function(...)--// Imports \\--
local Environment = require(script.Parent.Environment)
local Errors = require(script.Parent.Errors)

local FileHelperUtil = require("@src/Utils/FileHelper")

local PluginFiles = FileHelperUtil.new("Cobalt/Plugins")

local Loader = {}

function Loader.SetupPlugins(Manager)
	for _, FilePath in PluginFiles:ListFiles() do
		local Plugin, CompileError =
			loadstring(PluginFiles:ReadFile(FilePath), `CobaltPlugin-{PluginFiles:GetFileName(FilePath)}`)
		if CompileError then
			Errors.PluginErrored(Manager, FilePath, CompileError)
			continue
		end

		local PluginThread = task.spawn(function()
			coroutine.yield()

			local Success, Error = pcall(Plugin)
			if not Success then
				Errors.PluginErrored(Manager, FilePath, Error)
			end
		end)

		setfenv(
			Plugin,
			Environment.Create(Manager, FilePath, Plugin, PluginThread, function(ErrorFilePath, Error)
				Errors.PluginErrored(Manager, ErrorFilePath, Error)
			end)
		)

		coroutine.resume(PluginThread)
	end
end

return Loader

end)() end,
    [105] = function()local wax,script,require,CreateLookupTable=ImportGlobals(105)local ImportGlobals return (function(...)--// Imports \\--
local Bridge = require(script.Parent.Bridge)
local Loader = require(script.Parent.Loader)
local Registry = require(script.Parent.Registry)

--// Manager \\--
local Manager = {
	Registry = Registry,
	HasInterceptors = false,
	HasCodeGenInterceptors = false,
	Initialized = false,
}

function Manager.AttachWindow(WindowBridge)
	Bridge.Attach(WindowBridge)
end

function Manager.SetupPlugins()
	Loader.SetupPlugins(Manager)
	Manager.Initialized = true
end

return Manager

end)() end,
    [106] = function()local wax,script,require,CreateLookupTable=ImportGlobals(106)local ImportGlobals return (function(...)local Metadata = {}
local Validation = require("@src/Utils/Validation")

local Schema = Validation.Schema

local GameIdSchema = Schema.union({ Schema.string(), Schema.number() })
local PluginDataSchema = Schema.object({
	Name = Schema.string():default("Untitled Plugin"),
	Description = Schema.string():default("No description provided."),
	Author = Schema.string():default("N/A"),
	Version = Schema.string():default("0.0.0"),
	Game = Schema.union({ GameIdSchema, Schema.array(GameIdSchema) }):default("*"),
})

function Metadata.Validate(PluginData)
	local IsValid, Result, Errors = Validation.ValidateSchema(PluginData, PluginDataSchema)
	assert(IsValid, Errors[1] or "Invalid plugin metadata")
	return Result
end

function Metadata.IsSupportedInCurrentGame(PluginData): boolean
	if type(PluginData.Game) == "string" then
		return PluginData.Game == "*"
			or tostring(game.PlaceId) == PluginData.Game
			or tostring(game.GameId) == PluginData.Game
	end

	if type(PluginData.Game) == "number" then
		return game.PlaceId == PluginData.Game or game.GameId == PluginData.Game
	end

	if type(PluginData.Game) == "table" then
		for _, Id in pairs(PluginData.Game) do
			if tostring(game.PlaceId) == tostring(Id) or tostring(game.GameId) == tostring(Id) then
				return true
			end
		end

		return false
	end

	return true
end

return Metadata

end)() end,
    [107] = function()local wax,script,require,CreateLookupTable=ImportGlobals(107)local ImportGlobals return (function(...)return {
	Plugins = {},
	Errored = {},
	Interceptors = {
		Global = {},
		Instance = {},
	},
	UIHooks = {
		RemoteInfo = {
			Tabs = {},
			Open = {},
			Intercept = {},
		},
		ContextMenus = {
			RemoteList = {},
			CallList = {},
		},
		Spy = {
			RemoteList = {},
			CallList = {},
		},
		CodeGen = {
			Call = {},
			Hook = {},
			InstancePath = {},
		},
	},
}

end)() end,
    [108] = function()local wax,script,require,CreateLookupTable=ImportGlobals(108)local ImportGlobals return (function(...)type RatelimiterOptions = {
	Burst: {
		Time: number,
		Max: number,
	},

	PeriodicInterval: number?,
	MainCallback: (...any) -> ...any,
	ShouldProcess: ((...any) -> boolean)?,
	OnUnload: (() -> ())?,
}

local Ratelimits = {}
local Ratelimiter = {}
Ratelimiter.__index = Ratelimiter

function Ratelimiter.new(Options: RatelimiterOptions)
	local self = setmetatable(Options, Ratelimiter)
	self.Bucket = {}
	self.Queue = {}
	self.QueueHead = 1
	self.QueueTail = 0

	self.IsDestroyed = false
	self.ManagerThread = nil
	self.PeriodicThread = nil

	self:SetupManagerThread()

	table.insert(Ratelimits, self)
	return self
end

function Ratelimiter.StopAll()
	for _, Ratelimit in Ratelimits do
		Ratelimit:Destroy()
	end

	table.clear(Ratelimits)
end

function Ratelimiter:QueueOperation(...: any)
	if self.IsDestroyed then
		return
	end

	self.QueueTail += 1
	self.Queue[self.QueueTail] = table.pack(...)
end

function Ratelimiter:SetupManagerThread()
	if self.IsDestroyed then
		return
	end

	self.Bucket = {}
	self.Queue = {}
	self.QueueHead = 1
	self.QueueTail = 0

	if self.ManagerThread then
		task.cancel(self.ManagerThread)
		self.ManagerThread = nil
	end

	if self.PeriodicThread then
		task.cancel(self.PeriodicThread)
		self.PeriodicThread = nil
	end

	self.ManagerThread = task.spawn(function()
		while not wax.shared.Unloaded and not self.IsDestroyed do
			local CurrentTime = tick()

			if #self.Bucket > 0 then
				local NewBucket = {}
				for _, Time in self.Bucket do
					if CurrentTime - Time < self.Burst.Time then
						table.insert(NewBucket, Time)
					end
				end

				self.Bucket = NewBucket
			end

			while #self.Bucket < self.Burst.Max and self.QueueHead <= self.QueueTail do
				local TaskData = self.Queue[self.QueueHead]
				self.Queue[self.QueueHead] = nil
				self.QueueHead += 1

				if self.QueueHead > self.QueueTail then
					self.Queue = {}
					self.QueueHead = 1
					self.QueueTail = 0
				end

				if TaskData and self.ShouldProcess and not self.ShouldProcess(table.unpack(TaskData, 1, TaskData.n)) then
					continue
				end

				if TaskData then
					table.insert(self.Bucket, tick())

					task.defer(function()
						if self.IsDestroyed then
							return
						end

						self.MainCallback(table.unpack(TaskData, 1, TaskData.n))
					end)
				end
			end

			task.wait()
		end

		if wax.shared.Unloaded and not self.IsDestroyed and self.OnUnload then
			self.OnUnload()
		end
	end)

	if not self.PeriodicInterval then
		return
	end

	self.PeriodicThread = task.spawn(function()
		while not wax.shared.Unloaded and not self.IsDestroyed do
			self:QueueOperation()
			task.wait(self.PeriodicInterval)
		end
	end)
end

function Ratelimiter:Destroy()
	if self.IsDestroyed then
		return
	end

	self.IsDestroyed = true

	if self.ManagerThread then
		pcall(task.cancel, self.ManagerThread)
		self.ManagerThread = nil
	end

	if self.PeriodicThread then
		pcall(task.cancel, self.PeriodicThread)
		self.PeriodicThread = nil
	end

	table.clear(self.Bucket)
	table.clear(self.Queue)
	self.QueueHead = 1
	self.QueueTail = 0
end

Ratelimiter.Stop = Ratelimiter.Destroy

return Ratelimiter

end)() end,
    [109] = function()local wax,script,require,CreateLookupTable=ImportGlobals(109)local ImportGlobals return (function(...)--[[
    SafePack
    Author: centerepic
]]

local TableProxy = {}

local UNPACK_CHUNK = 7997
local SAFE_LIMIT = 12000

function TableProxy.Pack(...)
    return { n = select("#", ...), ... }
end

function TableProxy.Unpack(Tbl, I, J)
    I = I or 1
    J = J or Tbl.n or #Tbl

    if J - I + 1 > SAFE_LIMIT then
        J = I + SAFE_LIMIT - 1
    end

    if J < I then
        return
    end

    if J - I + 1 <= UNPACK_CHUNK then
        return table.unpack(Tbl, I, J)
    end

    return Tbl[I], TableProxy.Unpack(Tbl, I + 1, J)
end

return TableProxy

end)() end,
    [110] = function()local wax,script,require,CreateLookupTable=ImportGlobals(110)local ImportGlobals return (function(...)local FileHelperUtil = require(script.Parent.FileHelper)
local Validation = require(script.Parent.Validation)
local Settings = require(script.Parent.Settings)

local Schema = Validation.Schema

local SettingsSchemas = {}
for _, Setting in Settings do
	SettingsSchemas[Setting.Key] = Setting.Schema
end

local SettingsRootSchema = Schema.table():refine(function(Value)
	for Key in Value do
		if type(Key) ~= "string" then
			return false
		end
	end
	return true
end, "must be a settings object")

local SaveManager = {
	State = {},
	Settings = Settings,
	Schemas = SettingsSchemas,
	WarnedInvalidSettings = {},
}

local function ApplyMigrations(State): boolean
	local Changed = false

	for _, Setting in Settings do
		if State[Setting.Key] == nil then
			for _, Alias in Setting.Aliases do
				if State[Alias] ~= nil then
					State[Setting.Key] = State[Alias]
					Changed = true
					break
				end
			end
		end

		for _, Alias in Setting.Aliases do
			if State[Alias] ~= nil then
				State[Alias] = nil
				Changed = true
			end
		end
	end

	return Changed
end

local FileHelper = FileHelperUtil.new("Cobalt")
FileHelper:EnsureFile("Settings.json", "{}")

local Success, Error = pcall(function()
	local Decoded = wax.shared.HttpService:JSONDecode(FileHelper:ReadFile("Settings.json"))
	local IsValid, State, Errors = Validation.ValidateSchema(Decoded, SettingsRootSchema)
	assert(IsValid, Errors[1] or "Invalid settings data")
	SaveManager.State = State

	if ApplyMigrations(State) then
		FileHelper:WriteFile("Settings.json", wax.shared.HttpService:JSONEncode(State))
	end
end)

if not Success then
	wax.shared.Sonner.warning("Failed to load settings: " .. Error)
end

function SaveManager:SetState(Idx, Value)
	local DataSchema = SaveManager.Schemas[Idx]
	if DataSchema then
		local IsValid, Validated, Errors = Validation.ValidateSchema(Value, DataSchema)
		if not IsValid then
			local Error = `Invalid value for setting {Idx}: {Errors[1] or "validation failed"}`
			wax.shared.Sonner.warning(Error)
			return false, Error
		end
		Value = Validated
	end

	SaveManager.State[Idx] = Value
	pcall(FileHelper.WriteFile, FileHelper, "Settings.json", wax.shared.HttpService:JSONEncode(SaveManager.State))
	return true
end

function SaveManager:GetState(Idx, Default)
	if Default == nil and SaveManager.Settings[Idx] then
		Default = SaveManager.Settings[Idx]:GetDefault()
	end

	local Value = SaveManager.State[Idx]
	if Value == nil then
		return Default
	end

	local DataSchema = SaveManager.Schemas[Idx]
	if not DataSchema then
		return Value
	end

	local IsValid, Validated, Errors = Validation.ValidateSchema(Value, DataSchema)
	if IsValid then
		return Validated
	end

	if not SaveManager.WarnedInvalidSettings[Idx] then
		SaveManager.WarnedInvalidSettings[Idx] = true
		wax.shared.Sonner.warning(`Ignoring invalid saved setting {Idx}: {Errors[1] or "validation failed"}`)
	end

	return Default
end

function SaveManager:RegisterSchema(Idx: string, DataSchema)
	SaveManager.Schemas[Idx] = DataSchema
end

return SaveManager

end)() end,
    [111] = function()local wax,script,require,CreateLookupTable=ImportGlobals(111)local ImportGlobals return (function(...)local Registry = require(script.Registry)

for Name, Setting in Registry do
	assert(Name == Setting.Key, `Setting registry key {Name} does not match setting key {Setting.Key}`)
end

return Registry

end)() end,
    [112] = function()local wax,script,require,CreateLookupTable=ImportGlobals(112)local ImportGlobals return (function(...)local Constants = require("@src/Window/Constants")
local Validation = require(script.Parent.Parent.Validation)

local Setting = require(script.Parent.Setting)

local Schema = Validation.Schema

local PositiveInteger = Schema.union({ Schema.number(), Schema.string() }):refine(function(Value)
	local Number = tonumber(Value)
	return Number ~= nil and Number >= 1 and Number % 1 == 0
end, "must be a positive integer")

local RemoteClassSelection = Schema.table():refine(function(Value)
	for ClassName, Enabled in Value do
		if type(ClassName) ~= "string" or type(Enabled) ~= "boolean" then
			return false
		end
	end
	return true
end, "must map remote class names to booleans")

return {
	--// Internal Stuff \\--
	LimitedLoggingAcknowledged = Setting.new({
		Key = "LimitedLoggingAcknowledged",
		Default = false,
		Schema = Schema.boolean(),
	}),

	--// General Section \\--
	WindowDPIScale = Setting.new({
		Key = "WindowDPIScale",
		Default = "100%",
		Schema = Schema.enum({ "50%", "75%", "100%", "125%", "150%" }),
		UI = {
			Type = "Dropdown",
			Text = "Interface Scale",
			Values = { "50%", "75%", "100%", "125%", "150%" },
		},
	}),
	CallsPerPage = Setting.new({
		Key = "CallsPerPage",
		Aliases = { "MaxItemPerPages" },
		Default = 20,
		Schema = PositiveInteger,
		UI = {
			Type = "TextBox",
			Text = "Calls Per Page",
			NumericOnly = true,
		},
	}),
	ExecuteOnTeleport = Setting.new({
		Key = "ExecuteOnTeleport",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Relaunch After Teleport",
		},
	}),


	--// Capture Section \\--
	RakNetHooks = Setting.new({
		Key = "RakNetHooks",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Use RakNet Hooks on Relaunch (Experimental)",
			Risky = true,
		},
	}),
	OthHooks = Setting.new({
		Key = "OthHooks",
		Default = true,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Use Oth Hooks on Relaunch",
			Risky = false,
		},
	}),
	LogRobloxInternalEvents = Setting.new({
		Key = "LogRobloxInternalEvents",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Capture Roblox Internal Events",
		},
	}),
	LogActors = Setting.new({
		Key = "LogActors",
		Default = true,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Capture Actor Calls",
		},
	}),
	LogBlockedRemotes = Setting.new({
		Key = "LogBlockedRemotes",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Record Blocked Calls",
		},
	}),


	--// Filter Section \\--
	IgnoredRemotesDropdown = Setting.new({
		Key = "IgnoredRemotesDropdown",
		Default = {
			BindableEvent = true,
			BindableFunction = true,
		},
		Schema = RemoteClassSelection,
		UI = {
			Type = "Dropdown",
			Text = "Ignored Remote Classes",
			Values = Constants.InstanceClassImages,
			AllowNull = true,
			Multi = true,
		},
	}),
	AutoIgnoreSpammyEvents = Setting.new({
		Key = "AutoIgnoreSpammyEvents",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Auto-ignore High-frequency Calls",
		},
	}),
	IgnorePlayerModule = Setting.new({
		Key = "IgnorePlayerModule",
		Default = true,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Ignore PlayerModule Calls",
		},
	}),
	ShowExecutorLogs = Setting.new({
		Key = "ShowExecutorLogs",
		Default = true,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Show Executor Calls",
		},
	}),


	--// Code Generation Section \\--
	InstancePathLookupChain = Setting.new({
		Key = "InstancePathLookupChain",
		Default = "Index",
		Schema = Schema.enum({ "Index", "WaitForChild", "FindFirstChild" }),
		UI = {
			Type = "Dropdown",
			Text = "Instance Path Style",
			Values = {
				Index = "file",
				WaitForChild = "file-clock",
				FindFirstChild = "file-search",
			},
		},
	}),
	EventReferenceStrategy = Setting.new({
		Key = "EventReferenceStrategy",
		Default = "GetNil",
		Schema = Schema.enum({ "GetNil", "Upvalue Lookup" }),
		UI = {
			Type = "Dropdown",
			Text = "Nil Instance Strategy",
			Values = {
				GetNil = "bug",
				["Upvalue Lookup"] = "circle-fading-arrow-up",
			},
		},
	}),
	PreferBufferFromString = Setting.new({
		Key = "PreferBufferFromString",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Use buffer.fromstring()",
		},
	}),
	ShowWatermark = Setting.new({
		Key = "ShowWatermark",
		Default = true,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Include Cobalt Header",
		},
	}),


	--// File Logging Section \\--
	EnableLogging = Setting.new({
		Key = "EnableLogging",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Save Calls to File",
		},
	}),
	

	--// Compatibility & Safety Section \\--
	DisableNonEssentialChecks = Setting.new({
		Key = "DisableNonEssentialChecks",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Skip Optional Executor Checks",
		},
	}),
	AnticheatBypass = Setting.new({
		Key = "AnticheatBypass",
		Default = false,
		Schema = Schema.boolean(),
		UI = {
			Type = "Checkbox",
			Text = "Enable Anti-Cheat Bypass",
		},
	}),
}

end)() end,
    [113] = function()local wax,script,require,CreateLookupTable=ImportGlobals(113)local ImportGlobals return (function(...)local Validation = require(script.Parent.Parent.Validation)

local ControlMethods = {
	Checkbox = "CreateCheckbox",
	Dropdown = "CreateDropdown",
	TextBox = "CreateTextBox",
}

local function CloneValue(Value)
	if type(Value) ~= "table" then
		return Value
	end

	local Copy = {}
	for Key, Child in Value do
		Copy[CloneValue(Key)] = CloneValue(Child)
	end
	return Copy
end

local Setting = {}
Setting.__index = Setting

function Setting.new(Options)
	assert(type(Options) == "table", "Setting options must be a table")
	assert(type(Options.Key) == "string", "Setting key must be a string")
	assert(Options.Schema ~= nil, `Setting {Options.Key} requires a schema`)
	if Options.UI ~= nil then
		assert(type(Options.UI) == "table", `Setting {Options.Key} UI options must be a table`)
		assert(ControlMethods[Options.UI.Type] ~= nil, `Setting {Options.Key} has an unsupported control type`)
	end

	local IsValid, Default, Errors = Validation.ValidateSchema(Options.Default, Options.Schema)
	assert(IsValid, `Setting {Options.Key} has an invalid default: {Errors[1] or "validation failed"}`)

	return setmetatable({
		Key = Options.Key,
		Schema = Options.Schema,
		Default = Default,
		Aliases = table.clone(Options.Aliases or {}),
		UI = if Options.UI then CloneValue(Options.UI) else nil,
	}, Setting)
end

function Setting:GetDefault()
	return CloneValue(self.Default)
end

function Setting:SetupOption(Section, Overrides)
	assert(self.UI, `Setting {self.Key} does not define a UI control`)
	local MethodName = ControlMethods[self.UI.Type]
	local CreateControl = Section[MethodName]
	assert(type(CreateControl) == "function", `Section does not support {self.UI.Type} settings`)

	local Options = CloneValue(self.UI)
	Options.Type = nil
	Options.Default = self:GetDefault()

	for Key, Value in Overrides or {} do
		Options[Key] = Value
	end

	return CreateControl(Section, self.Key, Options)
end

return Setting

end)() end,
    [114] = function()local wax,script,require,CreateLookupTable=ImportGlobals(114)local ImportGlobals return (function(...)local SignalHandler = {
	Signals = {},
}

function SignalHandler.New(self)
	local Signal = {
		Connections = {},
		Disconnect = nil,
	}

	function Signal:Connect(callback)
		local connection = {
			Connected = true,
			Enabled = true,
			Callback = callback,
		}

		function connection:Disconnect()
			connection.Connected = false
		end

		function connection:Reconnect()
			if not connection.Enabled then
				return
			end

			connection.Connected = true
		end

		function connection:Enable()
			connection.Enabled = true
		end

		function connection:Disable()
			connection.Enabled = false
		end

		table.insert(Signal.Connections, connection)

		return connection
	end

	function Signal:Once(callback)
		local connection
		connection = Signal:Connect(function(...)
			connection:Disconnect()
			callback(...)
		end)

		return connection
	end

	function Signal:Fire(...)
		for _, connection in Signal.Connections do
			if connection.Connected and connection.Enabled then
				task.spawn(connection.Callback, ...)
			end
		end
	end

	function Signal:Wait(...)
		local return_data = { n = 0 }
		local finishedWaiting = false

		Signal:Once(function(...)
			return_data = wax.shared.SafePack.Pack(...)
			finishedWaiting = true
		end)

		repeat
			task.wait()
		until finishedWaiting
		return wax.shared.SafePack.Unpack(return_data)
	end

	table.insert(SignalHandler.Signals, Signal)
	return Signal
end

function SignalHandler.StopAll(self: any)
	for Index, Signal in SignalHandler.Signals do
		for _, Connection in Signal.Connections do
			Connection:Disable()
			Connection:Disconnect()
		end
	end
end

return SignalHandler

end)() end,
    [117] = function()local wax,script,require,CreateLookupTable=ImportGlobals(117)local ImportGlobals return (function(...)local Icons = {}
local AssetManager = require("@src/Utils/UI/Assets/Manager")

type SpriteIcon = {
	Url: string,
	IconName: string,
	ImageRectOffset: Vector2,
	ImageRectSize: Vector2,
}

type FontIcon = {
	FontFace: Font,
	Text: string,
}

type LucideModule = {
	Icons: { string },
	GetAsset: (Name: string) -> SpriteIcon?,
	GetFontAsset: ((Name: string) -> FontIcon?)?,
}

export type IconObject = TextLabel | TextButton | ImageLabel | ImageButton

local Success, Lucide: LucideModule = pcall(function()
	local IconFetchSuccess, IconModuleSource = pcall(request, {
		Url = "https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua",
		Method = "GET",
	})

	assert(
		IconFetchSuccess and IconModuleSource.Success
			or IconModuleSource.StatusCode >= 200 and IconModuleSource.StatusCode < 300,
		"Failed to fetch lucide icons direct module source"
	)
	return (loadstring(IconModuleSource.Body) :: () -> LucideModule)()
end)

--// Icon Font \\--
local FontFace: Font? = nil

if Success and typeof(Lucide.GetFontAsset) == "function" then
	pcall(function()
		local FontIcon = (Lucide.GetFontAsset :: (Name: string) -> FontIcon?)("circle-alert")
		assert(FontIcon, "Failed to load lucide icon font")

		local TextSize = 16
		local Width = wax.shared.GetTextBounds(FontIcon.Text, FontIcon.FontFace, TextSize)
		assert(math.abs(Width - TextSize) < 1, "Lucide icon font failed to render")

		FontFace = FontIcon.FontFace
	end)
end

--// Helpers \\--
local IconMappings = {
	Glyph = {
		ClassNames = {
			Label = "TextLabel",
			Button = "TextButton",
		},
		Properties = {
			IconColor3 = "TextColor3",
			IconTransparency = "TextTransparency",
		},
	},
	
	Image = {
		ClassNames = {
			Label = "ImageLabel",
			Button = "ImageButton",
		},
		Properties = {
			IconColor3 = "ImageColor3",
			IconTransparency = "ImageTransparency",
		},
	}
}
do
	local ClassKinds = {}
	for Kind, Mapping in IconMappings do
		for _, ClassName in Mapping.ClassNames do
			ClassKinds[ClassName] = Kind
		end
	end
	
	IconMappings.ClassKinds = ClassKinds
	Icons.IconMappings = IconMappings
end

function Icons.GetIconData(Icon: string)
	local MappingKey = (
		(FontFace and table.find(Lucide.Icons, Icon))
			and "Glyph"
			or "Image"
	)
	local Mapping = IconMappings[MappingKey]

	return MappingKey, Mapping
end

function Icons.GetClassName(Icon: string, Button: boolean?): string
	local _, Mapping = Icons.GetIconData(Icon)
	return Mapping.ClassNames[if Button then "Button" else "Label"]
end

function Icons.CanDisplay(Object: IconObject, Icon: string): boolean
	return IconMappings.ClassKinds[Object.ClassName] == Icons.GetIconData(Icon)
end

function Icons.GetProperty(Object: Instance, Property: string): any
	local ObjectKind = IconMappings.ClassKinds[Object.ClassName]
	local PropertyToGet = IconMappings[ObjectKind].Properties[Property] or Property
	return Object[PropertyToGet]
end

function Icons.ResolveProperties(ClassName: string, Properties: { [string]: any }): { [string]: any }
	local Mapping = IconMappings[IconMappings.ClassKinds[ClassName]].Properties
	local Resolved = {}

	for Property, Value in Properties do
		Resolved[Mapping[Property] or Property] = Value
	end

	return Resolved
end

function Icons.SetProperties(Object: Instance, Properties: { [string]: any })
	for Key, Value in Icons.ResolveProperties(Object.ClassName, Properties) do
		Object[Key] = Value
	end
end

function Icons.GetSpriteIcon(IconName: string): SpriteIcon?
	if not Success then
		return
	end

	local Fetched, Icon = pcall(Lucide.GetAsset, IconName)
	if not Fetched then
		return
	end

	return Icon
end

function Icons.SetIcon(Object: IconObject, Icon: string)
	local IconKind = Icons.IconMappings.ClassKinds[Object.ClassName]
	assert(IconKind, `{Object.ClassName} cannot display icon "{Icon}"`)

	if IconKind == "Glyph" then
		local Glyph = Object
		Glyph.FontFace = FontFace :: Font
		Glyph.RichText = false
		Glyph.TextScaled = true
		Glyph.Text = Icon
		return
	end

	local Image = Object :: ImageLabel
	if AssetManager.IsAsset(Icon) then
		Image.Image = Icon
		Image.ImageRectOffset = Vector2.zero
		Image.ImageRectSize = Vector2.zero
		return
	end

	local Sprite = Icons.GetSpriteIcon(Icon)
	if not Sprite then
		return
	end

	Image.Image = Sprite.Url
	Image.ImageRectOffset = Sprite.ImageRectOffset
	Image.ImageRectSize = Sprite.ImageRectSize
end

return Icons

end)() end,
    [118] = function()local wax,script,require,CreateLookupTable=ImportGlobals(118)local ImportGlobals return (function(...)--// Imports \\--
local Registry = require(script.Parent.Registry)
local FileHelper = require("@src/Utils/FileHelper")

--// Manager \\--
local AssetManager = {
	Overrides = {},
	Resolved = {},
	Sources = {},
	Errors = {},
	Preloaded = false,
}

local Assets = FileHelper.new("Cobalt/Assets")

local UsedRandomStrings = {}
local AssetRandom = Random.new(tick())

local IsCustomAssetSafe: boolean?
local UseRawCustomAssetPaths = false

type Resolution = {
	Value: any,
	Source: "Custom" | "Fallback",
	Error: string?,
}

local function GetFallback(Definition)
	if Definition.Type == "Font" then
		return Font.fromId(Definition.FallbackId)
	end

	return Definition.FallbackId
end

local GenerateSafeUniqueRandomFileName
do
	local Charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	GenerateSafeUniqueRandomFileName = function(): string
		while true do
			local RandomString = ""
			for _ = 1, AssetRandom:NextInteger(4, 7) do
				local RandomIndex = AssetRandom:NextInteger(1, #Charset)
				RandomString ..= Charset:sub(RandomIndex, RandomIndex)
			end

			local FileName = RandomString
			local Success, Exists = pcall(function()
				return isfile(FileName) or isfolder(FileName)
			end)

			if Success and Exists then
				continue
			end
			if UsedRandomStrings[FileName] then
				continue
			end

			UsedRandomStrings[FileName] = true
			return FileName
		end
	end
end

local function FetchRandomizedCustomContentId(Path: string): string?
	local RandomFileName = GenerateSafeUniqueRandomFileName()

	local Success, Result = pcall(function()
		writefile(RandomFileName, readfile(Path))
		return getcustomasset(RandomFileName)
	end)

	pcall(delfile, RandomFileName)

	if Success and typeof(Result) == "string" then
		return Result
	end
	return nil
end

local function SafeFetchCustomContentId(Path: string, FileName: string): string?
	if typeof(getcustomasset) ~= "function" then
		return nil
	end

	--// raw getcustomasset path \\--
	if UseRawCustomAssetPaths then
		local Success, Result = pcall(getcustomasset, Path)
		return if Success and typeof(Result) == "string" then Result else nil
	end

	--// Safety check \\--
	local HasEstablishedSafety = typeof(IsCustomAssetSafe) == "boolean"
	
	if
		IsCustomAssetSafe or
		not HasEstablishedSafety
	then
		local Success, Result = pcall(getcustomasset, Path)
		local IsValidResult = Success and typeof(Result) == "string"

		--// Determine safety \\--
		if not HasEstablishedSafety then
			if IsValidResult then
				IsCustomAssetSafe = Result:lower():find(FileName:lower(), 1, true) == nil
			else
				IsCustomAssetSafe = false
			end
		end

		--// Return result if safe \\--
		if IsValidResult and IsCustomAssetSafe then
			return Result
		end
	end

	--// Fallback to randomized custom content id \\--
	return FetchRandomizedCustomContentId(Path)
end

local function FetchAssetData(Url: string): string?
	if typeof(request) ~= "function" then
		return nil
	end

	local Success, Response = pcall(request, {
		Url = Url,
		Method = "GET",
	})

	if not Success then
		return nil
	end

	local StatusCode = tonumber(Response.StatusCode)
	if Response.Success ~= true and not (StatusCode and StatusCode >= 200 and StatusCode < 300) then
		return nil
	end

	return if typeof(Response.Body) == "string" then Response.Body else nil
end

local function EnsureAssetFile(Definition): (boolean, string?)
	if Assets:DoesExist(Definition.FileName) then
		return true
	end

	local Data = FetchAssetData(Definition.Url)
	if not Data then
		return false, `Failed to download {Definition.FileName}`
	end

	local Success, Error = pcall(Assets.WriteFile, Assets, Definition.FileName, Data)
	if not Success then
		return false, tostring(Error)
	end

	return true
end

local function ResolveImage(Name: string, Definition): Resolution
	--// Ensure asset file exists \\--
	local Exists, Error = EnsureAssetFile(Definition)
	if not Exists then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = Error,
		}
	end

	--// Fetch custom content id \\--
	local ContentId = SafeFetchCustomContentId(Assets:GetPath(Definition.FileName), Definition.FileName)
	if not ContentId then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = `Failed to load {Definition.FileName} with getcustomasset`,
		}
	end

	return {
		Value = ContentId,
		Source = "Custom",
	}
end

local function ResolveFont(Name: string, Definition): Resolution
	--// Ensure asset file exists \\--
	local Exists, Error = EnsureAssetFile(Definition)
	if not Exists then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = Error,
		}
	end

	--// Fetch custom content id \\--
	local TTFPath = Assets:GetPath(Definition.FileName)
	local TTFAssetId = SafeFetchCustomContentId(TTFPath, Definition.FileName)
	if not TTFAssetId then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = `Failed to load {Definition.FileName} with getcustomasset`,
		}
	end

	local FontFileName = `{Name}.font`
	local FontPath = Assets:GetPath(FontFileName)
	local Success, WriteError = pcall(
		Assets.WriteFile,
		Assets,
		FontFileName,
		wax.shared.HttpService:JSONEncode({
			name = Definition.FamilyName,
			faces = {
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = TTFAssetId,
				},
			},
		})
	)

	if not Success then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = tostring(WriteError),
		}
	end

	local FontAssetId = SafeFetchCustomContentId(FontPath, FontFileName)
	if not FontAssetId then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = `Failed to load {FontFileName} with getcustomasset`,
		}
	end

	local Created, FontFace = pcall(Font.new, FontAssetId)
	if not Created then
		return {
			Value = GetFallback(Definition),
			Source = "Fallback",
			Error = tostring(FontFace),
		}
	end

	return {
		Value = FontFace,
		Source = "Custom",
	}
end

local function ResolveAllAssets()
	for Name, Definition in Registry do
		local Success, ResolutionOrError = pcall(function()
			if Definition.Type == "Font" then
				return ResolveFont(Name, Definition)
			end

			return ResolveImage(Name, Definition)
		end)

		if Success then
			AssetManager.Resolved[Name] = ResolutionOrError.Value
			AssetManager.Sources[Name] = ResolutionOrError.Source
			AssetManager.Errors[Name] = ResolutionOrError.Error
		else
			AssetManager.Resolved[Name] = GetFallback(Definition)
			AssetManager.Sources[Name] = "Fallback"
			AssetManager.Errors[Name] = tostring(ResolutionOrError)
		end
	end
end

function AssetManager.SetOverride(Name: string, Value: any)
	assert(Registry[Name], `Unknown asset {Name}`)
	AssetManager.Overrides[Name] = Value
end

function AssetManager.ClearOverride(Name: string)
	AssetManager.Overrides[Name] = nil
end

function AssetManager.UseFallback(Name: string)
	local Definition = assert(Registry[Name], `Unknown asset {Name}`)
	AssetManager.SetOverride(Name, GetFallback(Definition))
end

function AssetManager.PreloadAsync()
	if AssetManager.Preloaded then
		return
	end

	local FileSystemSupport = wax.shared.ExecutorSupport.FileSystem
	if not FileSystemSupport or not FileSystemSupport.IsWorking or typeof(getcustomasset) ~= "function" then
		for Name, Definition in Registry do
			AssetManager.Resolved[Name] = GetFallback(Definition)
			AssetManager.Sources[Name] = "Fallback"
			AssetManager.Errors[Name] = "Custom assets require filesystem and getcustomasset support"
		end

		AssetManager.Preloaded = true
		return
	end

	Assets:EnsureDirectory()
	ResolveAllAssets()

	AssetManager.Preloaded = true
end

local function GetCustomFontErrors(): { [string]: string }
	local Errors = {}
	for Name, Definition in Registry do
		if Definition.Type ~= "Font" then
			continue
		end

		if AssetManager.Sources[Name] ~= "Custom" then
			Errors[Name] = AssetManager.Errors[Name] or "custom font was unavailable"
			continue
		end

		local Params = Instance.new("GetTextBoundsParams")
		Params.Text = "Cobalt"
		Params.RichText = true
		Params.Font = AssetManager.GetCustomFont(Name)
		Params.Size = 16
		Params.Width = 250

		local Success, Result = pcall(wax.shared.TextService.GetTextBoundsAsync, wax.shared.TextService, Params)
		Params:Destroy()
		if not Success or Result.X <= 0 or Result.Y <= 0 then
			Errors[Name] = if Success then "custom font returned invalid bounds" else tostring(Result)
		end
	end

	return Errors
end

function AssetManager.ValidateCustomFonts(): (boolean, string?)
	local Errors = GetCustomFontErrors()

	--// Fallback to raw custom asset paths \\--
	if next(Errors) and IsCustomAssetSafe == false and not UseRawCustomAssetPaths then
		UseRawCustomAssetPaths = true
		ResolveAllAssets() -- Reload assets with raw custom asset paths
		Errors = GetCustomFontErrors() -- Get new errors
	end

	--// Collect error messages \\--
	local ErrorMessages = {}
	for Name, Error in Errors do
		AssetManager.UseFallback(Name)
		table.insert(ErrorMessages, `{Name}: {Error}`)
	end

	if #ErrorMessages > 0 then
		return false, table.concat(ErrorMessages, "\n")
	end

	return true
end

function AssetManager.GetCustomFont(Name: string): Font
	local Definition = assert(Registry[Name], `Unknown asset {Name}`)
	assert(Definition.Type == "Font", `{Name} is not a font asset`)
	return AssetManager.Overrides[Name] or AssetManager.Resolved[Name] or GetFallback(Definition)
end

function AssetManager.GetImage(Name: string): string
	local Definition = assert(Registry[Name], `Unknown asset {Name}`)
	assert(Definition.Type == "Image", `{Name} is not an image asset`)
	return AssetManager.Overrides[Name] or AssetManager.Resolved[Name] or GetFallback(Definition)
end

function AssetManager.GetInstanceClassImages(): { [string]: string }
	local Images = {}
	for Name, Definition in Registry do
		if Definition.Type == "Image" and Definition.Group == "InstanceClass" then
			Images[Name] = AssetManager.GetImage(Name)
		end
	end

	return Images
end

local EditableClassNames = {
	["EditableImage"] = true,
	["EditableMesh"] = true,
}

function AssetManager.IsAsset(asset: string | EditableImage | EditableMesh)
	if typeof(asset) == "string" then
		return (
			asset:match("^rbxasset") ~= nil or
			asset:match("^rbxthumb") ~= nil or
			asset:match("^https?://") ~= nil
		)
	elseif typeof(asset) == "Object" then
		return EditableClassNames[asset.ClassName]
	end

	return false
end

return AssetManager

end)() end,
    [119] = function()local wax,script,require,CreateLookupTable=ImportGlobals(119)local ImportGlobals return (function(...)export type FontAsset = {
	Type: "Font",
	FileName: string,
	FamilyName: string,
	Url: string,
	FallbackId: number,
}

export type ImageAsset = {
	Type: "Image",
	FileName: string,
	Url: string,
	FallbackId: string,
	Group: string?,
}

export type Asset = FontAsset | ImageAsset

local RepositoryAssetUrl = "https://gitlab.com/upio/cobalt/-/raw/main/Assets"
local RobloxClassIconUrl = "https://robloxapi.github.io/ref/icons/dark"

local Registry: { [string]: Asset } = {
	Inter = {
		Type = "Font",
		
		FileName = "Inter.ttf",
		FamilyName = "Inter",
		
		Url = `{RepositoryAssetUrl}/Inter.ttf`,
		FallbackId = 12187365364,
	},
	IBMPlexMono = {
		Type = "Font",
		
		FileName = "IBMPlexMono.ttf",
		FamilyName = "IBM Plex Mono",

		Url = `{RepositoryAssetUrl}/IBMPlexMono.ttf`,
		FallbackId = 16658246179,
	},
	Logo = {
		Type = "Image",
		FileName = "Logo.png",

		Url = `{RepositoryAssetUrl}/Logo.png`,
		FallbackId = "rbxassetid://91685317120520",
	},
	RemoteEvent = {
		Group = "InstanceClass",
		
		Type = "Image",
		FileName = "RemoteEvent.png",

		Url = `{RobloxClassIconUrl}/RemoteEvent.png`,
		FallbackId = "rbxassetid://110803789420086",
	},
	UnreliableRemoteEvent = {
		Group = "InstanceClass",

		Type = "Image",
		FileName = "UnreliableRemoteEvent.png",

		Url = `{RobloxClassIconUrl}/UnreliableRemoteEvent.png`,
		FallbackId = "rbxassetid://126244162339059",
	},
	RemoteFunction = {
		Group = "InstanceClass",

		Type = "Image",
		FileName = "RemoteFunction.png",
		
		Url = `{RobloxClassIconUrl}/RemoteFunction.png`,
		FallbackId = "rbxassetid://108537517159060",
	},
	BindableEvent = {
		Group = "InstanceClass",

		Type = "Image",
		FileName = "BindableEvent.png",
		
		Url = `{RobloxClassIconUrl}/BindableEvent.png`,
		FallbackId = "rbxassetid://116839398727495",
	},
	BindableFunction = {
		Group = "InstanceClass",

		Type = "Image",
		FileName = "BindableFunction.png",
		
		Url = `{RobloxClassIconUrl}/BindableFunction.png`,
		FallbackId = "rbxassetid://112264959079193",
	},
}

return Registry

end)() end,
    [120] = function()local wax,script,require,CreateLookupTable=ImportGlobals(120)local ImportGlobals return (function(...)local Interface = {}
local Icons = require(script.Parent.Assets.Icons)
local AssetManager = require(script.Parent.Assets.Manager)

local DefaultFont = AssetManager.GetCustomFont("Inter")

local DefaultProperties = {
	["Frame"] = {
		BorderSizePixel = 0,
	},
	["ScrollingFrame"] = {
		BorderSizePixel = 0,
	},
	["ImageLabel"] = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	},
	["ImageButton"] = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	},

	["TextLabel"] = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = DefaultFont,
		RichText = true,
		TextColor3 = Color3.new(1, 1, 1),
	},
	["TextButton"] = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		FontFace = DefaultFont,
		RichText = true,
		TextColor3 = Color3.new(1, 1, 1),
	},
	["TextBox"] = {
		BorderSizePixel = 0,
		FontFace = DefaultFont,
		ClipsDescendants = true,
		RichText = false,
		TextColor3 = Color3.new(1, 1, 1),
	},

	["UIListLayout"] = {
		SortOrder = Enum.SortOrder.LayoutOrder,
	},
}

function Interface.New(ClassName: string, Properties: { [string | number]: any })
	local Object = Instance.new(ClassName)

	for Key, Value in pairs(DefaultProperties[ClassName] or {}) do
		if Properties and Properties[Key] ~= nil then
			continue
		end

		Object[Key] = Value
	end

	for Key, Value in pairs(Properties or {}) do
		if typeof(Value) == "table" then
			local SubObject = Interface.New(Key, Value)
			SubObject.Parent = Object

			continue
		elseif typeof(Key) ~= "string" and typeof(Value) == "Instance" then
			local SubObject = Value:Clone()
			SubObject.Parent = Object

			continue
		end

		Object[Key] = Value
	end

	return Object
end

local function CreateIcon(Icon: string, Button: boolean, Properties: { [string]: any }?): Icons.IconObject
	local ClassName = Icons.GetClassName(Icon, Button)
	local Resolved = {
		Name = "Icon",
		BackgroundTransparency = 1,
	}

	for Key, Value in Icons.ResolveProperties(ClassName, Properties or {}) do
		Resolved[Key] = Value
	end

	local Object = Interface.New(ClassName, Resolved)
	Icons.SetIcon(Object, Icon)

	return Object
end

function Interface.NewIcon(Icon: string, Properties: { [string]: any }?): Icons.IconObject
	return CreateIcon(Icon, false, Properties)
end

function Interface.NewIconButton(Icon: string, Properties: { [string]: any }?): Icons.IconObject
	return CreateIcon(Icon, true, Properties)
end

local CarriedIconProperties = {
	"Name",
	"AnchorPoint",
	"Position",
	"Size",
	"SizeConstraint",
	"AutomaticSize",
	"LayoutOrder",
	"ZIndex",
	"Rotation",
	"Visible",
	"Active",
	"BackgroundColor3",
	"BackgroundTransparency",
}

function Interface.SetIcon(Object: Icons.IconObject, Icon: string): Icons.IconObject
	if Icons.CanDisplay(Object, Icon) then
		Icons.SetIcon(Object, Icon)
		return Object
	end

	assert(not Object:IsA("GuiButton"), "Icon buttons cannot be replaced, use an icon inside of a button instead")

	local Properties = {
		IconColor3 = Icons.GetProperty(Object, "IconColor3"),
		IconTransparency = Icons.GetProperty(Object, "IconTransparency"),
	}
	for _, Property in CarriedIconProperties do
		Properties[Property] = (Object :: any)[Property]
	end

	local Replacement = Interface.NewIcon(Icon, Properties)
	for _, Child in Object:GetChildren() do
		Child.Parent = Replacement
	end

	Replacement.Parent = Object.Parent
	Object:Destroy()

	return Replacement
end

function Interface.GetScreenParent(): Instance
	local ScreenGui = Interface.New("ScreenGui", {})
	local HiddenUI = wax.shared.gethui()

	for _, Container in { HiddenUI, wax.shared.CoreGui } do
		if pcall(function()
			ScreenGui.Parent = Container
		end) then
			ScreenGui:Destroy()
			return Container
		end
	end

	return wax.shared.LocalPlayer:WaitForChild("PlayerGui")
end

return Interface

end)() end,
    [121] = function()local wax,script,require,CreateLookupTable=ImportGlobals(121)local ImportGlobals return (function(...)--// Imports \\--
local Schema = wax.shared.ValidationSchema or require(script.Schema)

--// Module \\--
local Validation = {
	Schema = Schema,
}

--// Functions \\--
function Validation.FillTemplate(Data, Template)
	local NewData = {}
	for Key, Value in Template do
		if Data[Key] == nil or typeof(Data[Key]) ~= typeof(Value) then
			NewData[Key] = Value
		else
			NewData[Key] = Data[Key]
		end
	end

	return NewData
end

function Validation.ValidateSchema(Data, DataSchema)
	return Schema.Validate(DataSchema, Data)
end

return Validation

end)() end,
    [122] = function()local wax,script,require,CreateLookupTable=ImportGlobals(122)local ImportGlobals return (function(...)--// Types \\--
type SchemaKind = "Any" | "Type" | "Literal" | "Enum" | "Array" | "Object" | "Union"
type Refinement = {
	Predicate: (any) -> boolean,
	Message: string,
}
type SchemaNode = {
	Kind: SchemaKind,
	ExpectedType: string?,
	Literal: any?,
	Values: { any }?,
	Item: SchemaNode?,
	Shape: { [any]: SchemaNode }?,
	Schemas: { SchemaNode }?,
	IsOptional: boolean?,
	HasDefault: boolean?,
	DefaultValue: any?,
	Refinements: { Refinement }?,
	Minimum: number?,
	Maximum: number?,
	Integer: boolean?,
}

--// Setup \\--
local Node = {}
Node.__index = Node

local Schema = {}

--// Helpers \\--
local function CloneValue(Value)
	if type(Value) ~= "table" then
		return Value
	end

	local Copy = {}
	for Key, Child in Value do
		Copy[CloneValue(Key)] = CloneValue(Child)
	end
	return Copy
end

local function CloneNode(self: SchemaNode): SchemaNode
	local Copy = table.clone(self)
	Copy.Refinements = self.Refinements and table.clone(self.Refinements) or nil
	return setmetatable(Copy, Node) :: any
end

local function NewNode(Kind: SchemaKind, Data: { [any]: any }?): SchemaNode
	local NewSchema = Data and table.clone(Data) or {}
	NewSchema.Kind = Kind
	return setmetatable(NewSchema, Node) :: any
end

local function AddError(Errors: { string }, Path: string, Message: string)
	table.insert(Errors, `{Path}: {Message}`)
end

local function ChildPath(Path: string, Key: any): string
	if type(Key) == "number" then
		return `{Path}[{Key}]`
	end
	return Path == "" and tostring(Key) or `{Path}.{Key}`
end

local function IsSchema(Value): boolean
	return type(Value) == "table" and getmetatable(Value) == Node
end

local function ValidateNode(CurrentSchema: SchemaNode, Value: any, Path: string, Errors: { string }): (boolean, any)
	if Value == nil then
		if CurrentSchema.HasDefault then
			return true, CloneValue(CurrentSchema.DefaultValue)
		end
		if CurrentSchema.IsOptional then
			return true, nil
		end

		AddError(Errors, Path, "is required")
		return false, nil
	end

	local IsValid = true
	local Output = Value
	local Kind = CurrentSchema.Kind

	if Kind == "Type" then
		IsValid = typeof(Value) == CurrentSchema.ExpectedType
		if not IsValid then
			AddError(Errors, Path, `expected {CurrentSchema.ExpectedType}, got {typeof(Value)}`)
		end
	elseif Kind == "Literal" then
		IsValid = Value == CurrentSchema.Literal
		if not IsValid then
			AddError(Errors, Path, `expected {tostring(CurrentSchema.Literal)}`)
		end
	elseif Kind == "Enum" then
		IsValid = false
		for _, Option in CurrentSchema.Values or {} do
			if Value == Option then
				IsValid = true
				break
			end
		end
		if not IsValid then
			local Options = {}
			for _, Option in CurrentSchema.Values or {} do
				table.insert(Options, tostring(Option))
			end
			AddError(Errors, Path, `expected one of {table.concat(Options, ", ")}`)
		end
	elseif Kind == "Array" then
		if type(Value) ~= "table" then
			AddError(Errors, Path, `expected table, got {typeof(Value)}`)
			IsValid = false
		else
			Output = {}
			for Index, Child in Value do
				if type(Index) ~= "number" or Index % 1 ~= 0 or Index < 1 then
					AddError(Errors, Path, "expected an array with positive integer keys")
					IsValid = false
					continue
				end

				local ChildValid, ChildOutput = ValidateNode(CurrentSchema.Item :: SchemaNode, Child, ChildPath(Path, Index), Errors)
				IsValid = ChildValid and IsValid
				if ChildValid then
					Output[Index] = ChildOutput
				end
			end
		end
	elseif Kind == "Object" then
		if type(Value) ~= "table" then
			AddError(Errors, Path, `expected table, got {typeof(Value)}`)
			IsValid = false
		else
			Output = {}
			for Key, ChildSchema in CurrentSchema.Shape or {} do
				local ChildValid, ChildOutput = ValidateNode(ChildSchema, Value[Key], ChildPath(Path, Key), Errors)
				IsValid = ChildValid and IsValid
				if ChildOutput ~= nil then
					Output[Key] = ChildOutput
				end
			end
		end
	elseif Kind == "Union" then
		IsValid = false
		for _, ChildSchema in CurrentSchema.Schemas or {} do
			local ChildErrors = {}
			local ChildValid, ChildOutput = ValidateNode(ChildSchema, Value, Path, ChildErrors)
			if ChildValid then
				IsValid = true
				Output = ChildOutput
				break
			end
		end
		if not IsValid then
			AddError(Errors, Path, "did not match any allowed schema")
		end
	end

	if not IsValid then
		return false, nil
	end

	if type(Output) == "number" then
		if CurrentSchema.Integer and Output % 1 ~= 0 then
			AddError(Errors, Path, "expected an integer")
			IsValid = false
		end
		if CurrentSchema.Minimum ~= nil and Output < CurrentSchema.Minimum then
			AddError(Errors, Path, `must be at least {CurrentSchema.Minimum}`)
			IsValid = false
		end
		if CurrentSchema.Maximum ~= nil and Output > CurrentSchema.Maximum then
			AddError(Errors, Path, `must be at most {CurrentSchema.Maximum}`)
			IsValid = false
		end
	end

	for _, Refinement in CurrentSchema.Refinements or {} do
		local Success, Result = pcall(Refinement.Predicate, Output)
		if not Success or not Result then
			AddError(Errors, Path, Refinement.Message)
			IsValid = false
		end
	end

	if not IsValid then
		return false, nil
	end
	return true, Output
end

--// Modifiers \\--
function Node:optional(): SchemaNode
	local Copy = CloneNode(self)
	Copy.IsOptional = true
	return Copy
end

function Node:default(Value: any): SchemaNode
	local Copy = CloneNode(self)
	Copy.HasDefault = true
	Copy.DefaultValue = Value
	return Copy
end

function Node:refine(Predicate: (any) -> boolean, Message: string?): SchemaNode
	assert(type(Predicate) == "function", "Schema refinement must be a function")
	local Copy = CloneNode(self)
	Copy.Refinements = Copy.Refinements or {}
	table.insert(Copy.Refinements, {
		Predicate = Predicate,
		Message = Message or "failed refinement",
	})
	return Copy
end

function Node:integer(): SchemaNode
	assert(self.Kind == "Type" and self.ExpectedType == "number", "integer() can only be used on number schemas")
	local Copy = CloneNode(self)
	Copy.Integer = true
	return Copy
end

function Node:min(Value: number): SchemaNode
	assert(self.Kind == "Type" and self.ExpectedType == "number", "min() can only be used on number schemas")
	local Copy = CloneNode(self)
	Copy.Minimum = Value
	return Copy
end

function Node:max(Value: number): SchemaNode
	assert(self.Kind == "Type" and self.ExpectedType == "number", "max() can only be used on number schemas")
	local Copy = CloneNode(self)
	Copy.Maximum = Value
	return Copy
end

--// Constructors \\--
function Schema.any(): SchemaNode
	return NewNode("Any")
end

function Schema.type(ExpectedType: string): SchemaNode
	assert(type(ExpectedType) == "string", "Schema type must be a string")
	return NewNode("Type", { ExpectedType = ExpectedType })
end

function Schema.string(): SchemaNode
	return Schema.type("string")
end

function Schema.number(): SchemaNode
	return Schema.type("number")
end

function Schema.boolean(): SchemaNode
	return Schema.type("boolean")
end

function Schema.table(): SchemaNode
	return Schema.type("table")
end

function Schema.callback(): SchemaNode
	return Schema.type("function")
end

function Schema.instance(ClassName: string?): SchemaNode
	local InstanceSchema = Schema.type("Instance")
	if ClassName then
		return InstanceSchema:refine(function(Value)
			return Value:IsA(ClassName)
		end, `expected an Instance that is a {ClassName}`)
	end
	return InstanceSchema
end

function Schema.literal(Value: any): SchemaNode
	assert(Value ~= nil, "Schema literal cannot be nil; use optional() instead")
	return NewNode("Literal", { Literal = Value })
end

function Schema.enum(Values: { any }): SchemaNode
	assert(type(Values) == "table" and #Values > 0, "Schema enum requires at least one value")
	return NewNode("Enum", { Values = table.clone(Values) })
end

function Schema.array(ItemSchema: SchemaNode): SchemaNode
	assert(IsSchema(ItemSchema), "Schema array requires an item schema")
	return NewNode("Array", { Item = ItemSchema })
end

function Schema.object(Shape: { [any]: SchemaNode }): SchemaNode
	assert(type(Shape) == "table", "Schema object requires a shape")
	for Key, ChildSchema in Shape do
		assert(IsSchema(ChildSchema), `Schema object field {tostring(Key)} must be a schema`)
	end
	return NewNode("Object", { Shape = table.clone(Shape) })
end

function Schema.union(Schemas: { SchemaNode }): SchemaNode
	assert(type(Schemas) == "table" and #Schemas > 0, "Schema union requires at least one schema")
	for _, ChildSchema in Schemas do
		assert(IsSchema(ChildSchema), "Schema union entries must be schemas")
	end
	return NewNode("Union", { Schemas = table.clone(Schemas) })
end

--// Validation \\--
function Schema.Validate(DataSchema: SchemaNode, Value: any): (boolean, any, { string })
	assert(IsSchema(DataSchema), "ValidateSchema requires a schema created by Validation.Schema")
	local Errors = {}
	local IsValid, Output = ValidateNode(DataSchema, Value, "Value", Errors)
	return IsValid, Output, Errors
end

return Schema

end)() end,
    [123] = function()local wax,script,require,CreateLookupTable=ImportGlobals(123)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")

local DPI = require("@src/Window/Utils/DPI")
local Resize = require("@src/Window/Utils/Input/Resize")

local AssetManager = require("@src/Utils/UI/Assets/Manager")
local PluginManager = require("@src/Utils/Plugins/Manager")

--// Components \\--
local ModalController = require("@src/Window/Components/Modal")
local ContextMenuController = require("@src/Window/Components/ContextMenu")

--// Variables \\--
local Window = {
	Dialogs = {},
	Modals = {},
}

--// Assets \\--
local CobaltLogo = AssetManager.GetImage("Logo")

local DPIHandler
local function GetDPIScale()
	return DPIHandler and DPIHandler:GetDPIScale() or 1
end

--// UI \\--
local ScreenGui = Interface.New("ScreenGui", {
	Name = "Cobalt",
	ResetOnSpawn = false,
	Parent = Interface.GetScreenParent(),
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
wax.shared.ScreenGui = ScreenGui

local MainFrame = Interface.New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(15, 15, 15),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(640, 420),
	ZIndex = 0,

	Constants.MainUICorner,
	Parent = ScreenGui,
})
do
	Resize.new({
		MainFrame = MainFrame,

		MinimumSize = Vector2.new(585, 220),

		CornerHandleSize = 20,
		HandleSize = 6,
		GetDPIScale = GetDPIScale,
	})
end

--// Minimized \\--
local ShowButton = Interface.New("TextButton", {
	AnchorPoint = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(15, 15, 15),
	Position = UDim2.new(0.5, 0, 0, 36),
	Size = UDim2.fromOffset(36, 36),
	Text = "",
	Visible = false,

	["ImageLabel"] = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = CobaltLogo,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -10, 1, -10),
	},

	["UIStroke"] = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.new(1, 1, 1),
	},

	Constants.MainUICorner,
	Parent = ScreenGui,
})

--// Sonner (Notifications) \\--
local NotificationWrapper = Interface.New("Frame", {
	Name = "Sonner",
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 285, 1, 0),
	Position = UDim2.fromScale(1, 1),
	AnchorPoint = Vector2.new(1, 1),
	ZIndex = 5000,
	ClipsDescendants = true,
	Parent = MainFrame,
})
do
	wax.shared.Sonner.init(NotificationWrapper)
end

--// Pagination \\--
local PaginationFactory = require(script.Utils.Pagination)

local PaginationManager = PaginationFactory.new({
	TotalItems = 0,
})

--// DPI \\--
DPIHandler = DPI.new({
	Scale = Interface.New("UIScale", {
		Parent = ScreenGui,
	}),
	SaveKey = "WindowDPIScale",
})

--// ContextMenus \\--
local ContextMenus = ContextMenuController.new(ScreenGui, {
	GetDPIScale = GetDPIScale,

	TweenInfo = Constants.DefaultTweenInfo,
})

--// Dialogs \\--
Window.Dialog = require(script.Components.Dialog)({
	MainFrame = MainFrame,
})

local QueryBuilder = require(script.Components.QueryBuilder)
do
	QueryBuilder.ContextMenu = ContextMenus
	Window.QueryBuilder = QueryBuilder
end

Window.Dialogs = require(script.Components.Dialogs)

--// Modal Controller \\--
Window.Modals.Controller = ModalController.new(MainFrame, {
	TweenInfo = Constants.DefaultTweenInfo,
})

--// Views \\--
local LogsPage = require(script.Views.Logs)({
	MainFrame = MainFrame,
	Window = Window,
	ContextMenu = ContextMenus,
	PaginationManager = PaginationManager,
	GetDPIScale = GetDPIScale,
})
Window.Logs = LogsPage

wax.shared.ClearLogs = LogsPage.ClearLogs
wax.shared.GetCurrentLog = LogsPage.GetCurrentLog

--// Modal Builders \\--
local SettingsBuilder = require(script.Components.Modal.Builder.Settings)({
	ContextMenu = ContextMenus,
})

--// Modals \\--
Window.Modals.Settings = require(script.Modals.Settings)({
	ModalController = Window.Modals.Controller,
	SettingsBuilder = SettingsBuilder,
	DPIHandler = DPIHandler,
	PaginationManager = PaginationManager,
	LogsPage = LogsPage,
	Window = Window,
})

Window.Modals.Plugins = require(script.Modals.Plugins)({
	ModalController = Window.Modals.Controller,
	SettingsBuilder = SettingsBuilder,
	GetDPIScale = GetDPIScale,
})

Window.Modals.Info = require(script.Modals.Info)({
	ModalController = Window.Modals.Controller,
	ContextMenu = ContextMenus,
	GetDPIScale = GetDPIScale,
	LogsPage = LogsPage,
})

Window.Modals.Search = require(script.Modals.Search)({
	ModalController = Window.Modals.Controller,
	LogsPage = LogsPage,
})

PluginManager.AttachWindow({
	ModalController = Window.Modals.Controller,
	InfoModal = Window.Modals.Info,
	PluginsModal = Window.Modals.Plugins,
	GetCurrentLog = LogsPage.GetCurrentLog,
	ClearLogs = LogsPage.ClearLogs,
	GetDPIScale = GetDPIScale,
})

--// Topbar \\--
require(script.Components.Topbar)({
	MainFrame = MainFrame,
	ShowButton = ShowButton,
	CobaltLogo = CobaltLogo,
	Modals = Window.Modals,
	GetDPIScale = GetDPIScale,
})

return Window

end)() end,
    [125] = function()local wax,script,require,CreateLookupTable=ImportGlobals(125)local ImportGlobals return (function(...)local Interface = require("@src/Utils/UI/Interface")
local Input = require("@src/Window/Utils/Input/Input")

local ContextMenu = {}
export type ContextMenu = {
	CurrentContext: {
		Parent: GuiObject,
		Anchor: GuiObject?,
		Options: { GuiObject },
		Owner: ContextMenu,
		MouseOnCursorPosition: boolean?,
	}?,
} & typeof(setmetatable({}, ContextMenu))
ContextMenu.__index = ContextMenu

local DefaultTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Exponential)

function ContextMenu.new(
	Parent: GuiObject,
	Options: {
		GetDPIScale: (() -> number)?,
		TweenInfo: TweenInfo?,
	}?
)
	local self = setmetatable({
		CurrentContext = nil,
		GetDPIScale = Options and Options.GetDPIScale or function()
			return 1
		end,
		TweenInfo = Options and Options.TweenInfo or DefaultTweenInfo,
	}, ContextMenu)

	self.Frame = Interface.New("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 2,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = false,
		Size = UDim2.fromScale(0, 0),
		ZIndex = 10000,
		Visible = false,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 6),
		},

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 0),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},

		["UISizeConstraint"] = {
			MaxSize = Vector2.new(100000, 100000),
		},

		Parent = Parent,
	})
	self.SizeConstraint = self.Frame.UISizeConstraint

	wax.shared.Connect(wax.shared.UserInputService.InputBegan:Connect(function(InputObject: InputObject)
		if not Input.IsClickInput(InputObject) then
			return
		end

		local CurrentContext = self.CurrentContext
		if not CurrentContext then
			return
		end

		local Anchor = CurrentContext.Anchor or CurrentContext.Parent
		local IsOverAnchor = Anchor.Parent ~= nil and Input.IsMouseOverFrame(Anchor, InputObject.Position)
		if not (Input.IsMouseOverFrame(self.Frame, InputObject.Position) or IsOverAnchor) then
			CurrentContext:Close()
		end
	end))

	return self
end

function ContextMenu:Create(
	Parent: GuiObject,
	Options: {},
	MouseOnCursorPosition: boolean?,
	DisplayOptions: {
		MaxHeight: number?,
	}?
)
	local ContextData = {
		Parent = Parent,
		Anchor = Parent,
		Options = {},
		Owner = self,
		MouseOnCursorPosition = MouseOnCursorPosition,
		DisplayOptions = DisplayOptions or {},
		SuppressedClicks = setmetatable({}, { __mode = "k" }),
	}

	local function BuildContextMenu(MenuOptions: {})
		for Order, Data in pairs(MenuOptions) do
			local TextButton = Interface.New("TextButton", {
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				BackgroundTransparency = 1,
				LayoutOrder = Order,
				Size = UDim2.new(1, 0, 0, 30),
				Text = "",

				["UICorner"] = {
					CornerRadius = UDim.new(0, 6),
				},

				["UIPadding"] = {
					PaddingBottom = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					PaddingTop = UDim.new(0, 6),
				},
			})

			local IconToSet = Data.Icon
			if typeof(IconToSet) == "function" then
				IconToSet = IconToSet()
			end

			local ItemIcon = Interface.NewIcon(IconToSet or "", {
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,

				Parent = TextButton,
			})

			local TextToSet = Data.Text
			if typeof(TextToSet) == "function" then
				TextToSet = TextToSet()
			end

			local ItemText = Interface.New("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.fromOffset(Data.Icon == nil and 0 or 26, 0),
				Size = UDim2.fromScale(0, 1),
				Text = TextToSet,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,

				Parent = TextButton,
			})

			if Data.TextProperties then
				local Properties = typeof(Data.TextProperties) == "function" and Data.TextProperties()
					or Data.TextProperties
				for Property, Value in pairs(Properties) do
					ItemText[Property] = Value
				end
			end

			TextButton.MouseEnter:Connect(function()
				wax.shared.TweenService
					:Create(TextButton, self.TweenInfo, {
						BackgroundTransparency = 0,
					})
					:Play()
			end)

			TextButton.MouseLeave:Connect(function()
				wax.shared.TweenService
					:Create(TextButton, self.TweenInfo, {
						BackgroundTransparency = 1,
					})
					:Play()
			end)

			TextButton.MouseButton1Click:Connect(function()
				TextButton.BackgroundTransparency = 1

				if Data.Callback then
					Data.Callback()
				end

				if Data.CloseOnClick ~= false then
					ContextData.Close()
				else
					for _, Option in pairs(ContextData.Options) do
						Option:Display()
					end
				end
			end)

			function Data:Display()
				if typeof(Data.Text) == "function" then
					ItemText.Text = Data.Text()
				end

				if typeof(Data.Icon) == "function" then
					IconToSet = Data.Icon()
					ItemIcon = Interface.SetIcon(ItemIcon, IconToSet)
				end

				if Data.TextProperties then
					local Properties = typeof(Data.TextProperties) == "function" and Data.TextProperties()
						or Data.TextProperties
					for Property, Value in pairs(Properties) do
						ItemText[Property] = Value
					end
				end
			end

			ContextData.Options[TextButton] = Data
		end
	end

	function ContextData.Open(InputPosition: Vector2?, Anchor: GuiObject?)
		local Owner = ContextData.Owner
		if Owner.CurrentContext then
			Owner.CurrentContext.Close()
		end

		Owner.CurrentContext = ContextData
		ContextData.Anchor = Anchor or Parent
		Owner.Frame.CanvasPosition = Vector2.zero
		local MaxHeight = ContextData.DisplayOptions.MaxHeight
		Owner.Frame.AutomaticSize = if MaxHeight then Enum.AutomaticSize.X else Enum.AutomaticSize.XY
		Owner.Frame.Size = UDim2.fromScale(0, 0)
		Owner.SizeConstraint.MaxSize = Vector2.new(100000, 100000)
		local ContentHeight = Owner.Frame.UIPadding.PaddingTop.Offset + Owner.Frame.UIPadding.PaddingBottom.Offset
		for Object, Data in pairs(ContextData.Options) do
			if Data.Condition and not Data.Condition() then
				continue
			end
			Object.Parent = Owner.Frame
			ContentHeight += Object.Size.Y.Offset
			Data:Display()
		end
		if MaxHeight then
			Owner.Frame.ScrollingEnabled = ContentHeight > MaxHeight
			Owner.Frame.Size = UDim2.new(0, 0, 0, math.min(ContentHeight, MaxHeight))
		else
			Owner.Frame.ScrollingEnabled = false
		end

		local DPIScale = Owner.GetDPIScale()
		if ContextData.MouseOnCursorPosition then
			local CursorPosition = InputPosition or wax.shared.UserInputService:GetMouseLocation()
			Owner.Frame.Position = UDim2.fromOffset(
				CursorPosition.X,
				CursorPosition.Y - (45 / DPIScale)
			)
		else
			Owner.Frame.Position = UDim2.fromOffset(
				ContextData.Anchor.AbsolutePosition.X / DPIScale,
				(ContextData.Anchor.AbsolutePosition.Y + ContextData.Anchor.AbsoluteSize.Y) / DPIScale
			)
		end

		Owner.Frame.Visible = true
	end

	function ContextData.Toggle()
		if ContextData.Owner.CurrentContext == ContextData then
			ContextData.Close()
			return
		end

		ContextData.Open()
	end

	function ContextData:BindLongPress(Target: GuiObject?, BeforeOpen: (() -> boolean?)?)
		local LongPressTarget = Target or Parent
		return LongPressTarget.TouchLongPress:Connect(function(TouchPositions: { Vector2 }, State: Enum.UserInputState)
			if State == Enum.UserInputState.Begin then
				if BeforeOpen and BeforeOpen() == false then
					return
				end

				local SuppressionToken = {}
				ContextData.SuppressedClicks[LongPressTarget] = SuppressionToken
				ContextData.Open(TouchPositions[1], LongPressTarget)
			elseif State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
				local SuppressionToken = ContextData.SuppressedClicks[LongPressTarget]
				if SuppressionToken then
					task.delay(0.1, function()
						if ContextData.SuppressedClicks[LongPressTarget] == SuppressionToken then
							ContextData.SuppressedClicks[LongPressTarget] = nil
						end
					end)
				end
			end
		end)
	end

	function ContextData:ConsumeLongPress(Target: GuiObject): boolean
		if not self.SuppressedClicks[Target] then
			return false
		end

		self.SuppressedClicks[Target] = nil
		return true
	end

	function ContextData.Close()
		if ContextData.Owner.CurrentContext ~= ContextData then
			return
		end

		ContextData.Owner.Frame.Visible = false
		for Object, _ in pairs(ContextData.Options) do
			Object.Parent = nil
		end
		ContextData.Anchor = Parent
		ContextData.Owner.CurrentContext = nil
	end

	function ContextData:SetContextMenu(MenuOptions: { any })
		for Object, _Data in pairs(self.Options) do
			Object:Destroy()
		end
		self.Options = {}
		BuildContextMenu(MenuOptions)
	end

	BuildContextMenu(Options)
	return ContextData
end

return ContextMenu

end)() end,
    [126] = function()local wax,script,require,CreateLookupTable=ImportGlobals(126)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Icons = require("@src/Utils/UI/Assets/Icons")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

--// Types \\--
type Dialog = Types.Dialog
type DialogDismissBehavior = Types.DialogDismissBehavior
type DialogButton = Types.DialogButton
type FooterButton = Types.DialogFooterButton
type DialogProps = Types.DialogProps

--// Animation \\--
local BackdropTransparency = 0.25
local ClosedDialogScale = 0.95
local BackdropTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local DialogTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

--// Setup \\--
local function SetupDialog(
	props: {
		MainFrame: Frame,
	},
	ZIndexOffset: number
)
	--// Props \\--
	local MainFrame = props.MainFrame

	--// UI \\--
	local Root = Interface.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 3 + ZIndexOffset,
		Parent = MainFrame,
	})

	local OverlayWrapper = Interface.New("TextButton", {
		Text = "",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1,
		Parent = Root,

		Constants.MainUICorner,
	})

	local DialogFrame = Interface.New("CanvasGroup", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(11, 11, 11),
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.Y,
		GroupTransparency = 1,
		Size = UDim2.new(0.65, 0, 0, 120),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ZIndex = 2,
		Parent = Root,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 8),
		},

		["UIStroke"] = {
			Color = Color3.fromRGB(26, 26, 26),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1,
		},

		["UIScale"] = {
			Scale = ClosedDialogScale,
		},
	})

	local InputSink = Interface.New("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = DialogFrame,
	})

	local DialogBody = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = InputSink,

		["UIPadding"] = {
			PaddingTop = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 47),
		},

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 5),
		},
	})

	--// Header \\--
	local Header = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = DialogBody,
	})

	--// Close Button \\--
	local CloseButton = Interface.NewIconButton("x", {
		IconTransparency = 0.5,
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0, 15, 0, 15),
		Position = UDim2.new(1, 0, 0, 0),
		Parent = Header,
	})

	--// Title Description \\--
	local TitleDescriptionContainer = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = Header,
	})

	local TitleWrapper = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Parent = TitleDescriptionContainer,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 5),
		},
	})

	local TitleLabel = Interface.New("TextLabel", {
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 20),
		Text = "<b>Title</b>",
		LayoutOrder = 1,

		Parent = TitleWrapper,
	})

	local HeaderIcon = Interface.New("ImageLabel", {
		Name = "Icon",
		Size = UDim2.new(0, 23, 0, 23),
		Visible = false,

		Parent = TitleWrapper,
	})

	local DescriptionLabel = Interface.New("TextLabel", {
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "Description",
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 28),
		TextWrapped = true,
		AutomaticSize = Enum.AutomaticSize.Y,

		Parent = TitleDescriptionContainer,
	})

	--// Main Content \\--
	local MainContent = Interface.New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 1,
		Parent = DialogBody,
	})

	--// Footer \\--
	local Footer = Interface.New("Frame", {
		Parent = InputSink,
		BackgroundColor3 = Color3.fromRGB(36, 36, 36),
		AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
		},

		["UIPadding"] = {
			PaddingRight = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		},
	})

	--// Footer Button \\--
	local function CreateFooterButton(options: FooterButton)
		local ButtonType = options.Type or "Secondary"
		local ButtonText = options.Text or ""
		local ButtonIcon = options.Icon

		local ButtonBackground = ButtonType == "Primary" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(21, 21, 21)
		local ButtonTextColor = ButtonType == "Primary" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)

		local Button = Interface.New("ImageButton", {
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundColor3 = ButtonBackground,
			BackgroundTransparency = 0,
			ImageRectSize = Vector2.new(24, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			ImageRectOffset = Vector2.new(424, 325),
			["UICorner"] = {
				CornerRadius = UDim.new(0, 6),
			},

			["UIStroke"] = {
				Color = Color3.fromRGB(31, 31, 31),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},

			["UIPadding"] = {
				PaddingTop = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 6),
			},

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 6),
			},

			Parent = Footer,
		})

		local Text = Interface.New("TextLabel", {
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = ButtonTextColor,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			Text = ButtonText,
			LayoutOrder = 1,

			Parent = Button,
		})

		local Icon = Interface.NewIcon(ButtonIcon or "", {
			Visible = ButtonIcon ~= nil,
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Size = UDim2.fromScale(1, 1),

			Parent = Button,
		})

		return Button, Text, Icon
	end

	return {
		Root = Root,
		Overlay = OverlayWrapper,
		Container = DialogFrame,
		Scale = DialogFrame.UIScale,
		CloseButton = CloseButton,
		Header = {
			TitleLabel = TitleLabel,
			DescriptionLabel = DescriptionLabel,
			HeaderIcon = HeaderIcon,
		},
		MainContent = MainContent,
		Footer = {
			CreateButton = CreateFooterButton,
			UI = Footer,
		},
	}
end

--// Component \\--
return function(ComponentProps: {
	MainFrame: Frame,
})
	--// Registry \\--
	local Registry = {}
	local NextDialogId = 0

	--// Dialog \\--
	local Dialog = {}
	Dialog.__index = Dialog

	--[[
        Create a new dialog.

        @param props - The props for the dialog.
    ]]
	function Dialog.new(props: DialogProps)
		local AutoShow = props.AutoShow == true or props.AutoShow == nil

		--// Constructor \\--
		local self = setmetatable({}, Dialog)

		NextDialogId += 1
		local DialogId = NextDialogId
		Registry[DialogId] = self

		--// State \\--
		self.DialogId = DialogId
		self.DismissBehavior = props.DismissBehavior or "Destroy"
		self.ActiveTweens = {}
		self.AnimationId = 0
		self.IsOpen = false
		self.DismissTween = nil
		self.Destroyed = false
		self.Buttons = {}

		--// Setup \\--
		self:Setup(props, DialogId)

		if AutoShow then
			self:Show()
		end

		return self
	end

	--[[
        Setup the dialog with the given props and offset. Designed for internal use only.

        @param props - The props for the dialog.
        @param Offset - The offset for the dialog.
    ]]
	function Dialog:Setup(props: DialogProps, Offset: number)
		local RawDialog = SetupDialog(ComponentProps, Offset)
		self.RawDialog = RawDialog
		for Key, Value in RawDialog do
			self[Key] = Value
		end

		--// Header \\--
		self.Header.TitleLabel.Text = `<b>{props.Title}</b>`
		self.Header.DescriptionLabel.Text = props.Description
		if props.Icon then
			self.Header.HeaderIcon = Interface.SetIcon(self.Header.HeaderIcon, props.Icon)
			self.Header.TitleLabel.Size = UDim2.new(1, -28, 0, 20)
			self.Header.HeaderIcon.Visible = true
		end

		if props.TitleColor then
			self.Header.TitleLabel.TextColor3 = props.TitleColor
			Icons.SetProperties(self.Header.HeaderIcon, { IconColor3 = props.TitleColor })
		end

		--// Footer \\--
		for _, Button in self.Footer.UI:QueryDescendants("ImageButton") do
			Button:Destroy()
		end

		local ButtonIndex = 0
		for ButtonKey, ButtonData in props.Footer do
			ButtonIndex += 1
			local Button, Text, Icon = self.Footer.CreateButton(ButtonData)
			Button.LayoutOrder = ButtonData.LayoutOrder or ButtonIndex

			Button.Parent = self.Footer.UI
			Text.Parent = Button
			Icon.Parent = Button

			local ButtonController = {
				Instance = Button,
				Label = Text,
				Icon = Icon,
				Disabled = false,
			} :: DialogButton

			local ButtonBaseColor = ButtonData.Type == "Primary" and Color3.fromRGB(255, 255, 255)
				or Color3.fromRGB(21, 21, 21)
			local HoldDuration = ButtonData.HoldDuration
			local HoldGradient: UIGradient?
			if HoldDuration and HoldDuration > 0 then
				Button.AutoButtonColor = false
				local HoldColor = ButtonData.Type == "Primary" and Color3.fromRGB(180, 180, 180)
					or Color3.fromRGB(60, 60, 60)
				Button.BackgroundColor3 = Color3.new(1, 1, 1)
				HoldGradient = Interface.New("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, HoldColor),
						ColorSequenceKeypoint.new(0.5, HoldColor),
						ColorSequenceKeypoint.new(0.501, ButtonBaseColor),
						ColorSequenceKeypoint.new(1, ButtonBaseColor),
					}),
					Offset = Vector2.new(-0.5, 0),
					Parent = Button,
				})
			end

			local HoldTween: Tween?
			local Holding = false
			local function CancelHold()
				Holding = false
				if HoldTween then
					HoldTween:Cancel()
					HoldTween = nil
				end
				if HoldGradient then
					HoldGradient.Offset = Vector2.new(-0.5, 0)
				end
			end

			function ButtonController:SetDisabled(Disabled: boolean)
				self.Disabled = Disabled
				Button.Interactable = not Disabled
				Button.BackgroundTransparency = if Disabled then 0.45 else 0
				Text.TextTransparency = if Disabled then 0.5 else 0
				Icons.SetProperties(Icon, { IconTransparency = if Disabled then 0.5 else 0 })

				if Disabled then
					CancelHold()
				end
			end

			if type(ButtonKey) == "string" then
				self.Buttons[ButtonKey] = ButtonController
			end

			ButtonController:SetDisabled(ButtonData.Disabled == true)

			--// Action \\--
			if not ButtonData.Action then
				continue
			end

			local function RunAction()
				if ButtonController.Disabled or self.Destroyed then
					return
				end

				if ButtonData.Action == "Dismiss" then
					self:Dismiss(self.DismissBehavior)
				else
					ButtonData.Action(self)
				end
			end

			if HoldDuration and HoldDuration > 0 then
				Button.MouseButton1Down:Connect(function()
					if ButtonController.Disabled or Holding then
						return
					end

					Holding = true
					HoldTween = wax.shared.TweenService:Create(HoldGradient, TweenInfo.new(HoldDuration), {
						Offset = Vector2.new(0.5, 0),
					})
					local CurrentTween = HoldTween
					CurrentTween.Completed:Once(function(PlaybackState)
						if PlaybackState ~= Enum.PlaybackState.Completed or not Holding or HoldTween ~= CurrentTween then
							return
						end

						Holding = false
						HoldTween = nil
						HoldGradient.Offset = Vector2.new(-0.5, 0)
						RunAction()
					end)
					CurrentTween:Play()
				end)
				Button.MouseButton1Up:Connect(CancelHold)
				Button.MouseLeave:Connect(CancelHold)
			else
				Button.MouseButton1Click:Connect(RunAction)
			end
		end

		self.Overlay.MouseButton1Click:Connect(function()
			self:Dismiss(self.DismissBehavior)
		end)
		self.CloseButton.MouseButton1Click:Connect(function()
			self:Dismiss(self.DismissBehavior)
		end)
	end

	function Dialog:_CancelAnimation()
		self.AnimationId += 1

		for _, Tween in self.ActiveTweens do
			Tween:Cancel()
		end
		table.clear(self.ActiveTweens)

		return self.AnimationId
	end

	--[[
        Dismiss the dialog.
    ]]
	function Dialog:Dismiss(DismissBehavior: DialogDismissBehavior?)
		if self.Destroyed then
			return nil
		elseif not self.IsOpen then
			return self.DismissTween
		end

		local AnimationId = self:_CancelAnimation()
		local Behavior = DismissBehavior or self.DismissBehavior
		self.IsOpen = false
		self.Container.Interactable = false

		local BackdropTween = wax.shared.TweenService:Create(self.Overlay, BackdropTweenInfo, {
			BackgroundTransparency = 1,
		})
		local DialogFadeTween = wax.shared.TweenService:Create(self.Container, DialogTweenInfo, {
			GroupTransparency = 1,
		})
		local DialogScaleTween = wax.shared.TweenService:Create(self.Scale, DialogTweenInfo, {
			Scale = ClosedDialogScale,
		})
		self.DismissTween = DialogScaleTween

		self.ActiveTweens = { BackdropTween, DialogFadeTween, DialogScaleTween }
		DialogScaleTween.Completed:Once(function(PlaybackState)
			if PlaybackState ~= Enum.PlaybackState.Completed or self.AnimationId ~= AnimationId or self.IsOpen then
				return
			end

			self.DismissTween = nil
			table.clear(self.ActiveTweens)

			if Behavior == "Destroy" then
				self:Destroy()
				return
			end

			self.Root.Visible = false
			self.Overlay.Active = false
		end)

		BackdropTween:Play()
		DialogFadeTween:Play()
		DialogScaleTween:Play()

		return DialogScaleTween
	end

	--[[
        Show the dialog.
    ]]
	function Dialog:Show()
		if self.Destroyed or self.IsOpen then
			return
		end

		local WasHidden = not self.Root.Visible
		local AnimationId = self:_CancelAnimation()
		self.IsOpen = true
		self.DismissTween = nil

		if WasHidden then
			self.Overlay.BackgroundTransparency = 1
			self.Container.GroupTransparency = 1
			self.Scale.Scale = ClosedDialogScale
		end

		self.Root.Visible = true
		self.Overlay.Active = true
		self.Container.Interactable = true

		local BackdropTween = wax.shared.TweenService:Create(self.Overlay, BackdropTweenInfo, {
			BackgroundTransparency = BackdropTransparency,
		})
		local DialogFadeTween = wax.shared.TweenService:Create(self.Container, DialogTweenInfo, {
			GroupTransparency = 0,
		})
		local DialogScaleTween = wax.shared.TweenService:Create(self.Scale, DialogTweenInfo, {
			Scale = 1,
		})

		self.ActiveTweens = { BackdropTween, DialogFadeTween, DialogScaleTween }
		DialogScaleTween.Completed:Once(function(PlaybackState)
			if PlaybackState ~= Enum.PlaybackState.Completed or self.AnimationId ~= AnimationId or not self.IsOpen then
				return
			end

			table.clear(self.ActiveTweens)
		end)

		BackdropTween:Play()
		DialogFadeTween:Play()
		DialogScaleTween:Play()
	end

	--[[
        Destroy the dialog.
    ]]
	function Dialog:Destroy()
		if self.Destroyed then
			return
		end

		self.Destroyed = true
		self:_CancelAnimation()
		self.DismissTween = nil
		Registry[self.DialogId] = nil
		self.Root:Destroy()
	end

	return Dialog
end

end)() end,
    [127] = function()local wax,script,require,CreateLookupTable=ImportGlobals(127)local ImportGlobals return (function(...)local Registry = {}

for _, Dialog in script:GetChildren() do
	Registry[Dialog.Name] = require(Dialog)
end

return Registry
end)() end,
    [128] = function()local wax,script,require,CreateLookupTable=ImportGlobals(128)local ImportGlobals return (function(...)--// Imports \\--
local Types = require("@src/Window/Types")
local Validation = require("@src/Utils/Validation")
local CallFilterSchema = require("@src/Utils/CallFilter/Schema")

--// Types \\--
type CallFilter = Types.CallFilter
type QueryBuilder = Types.QueryBuilder
type QueryBuilderCondition = Types.QueryBuilderCondition
type QueryBuilderValue = Types.QueryBuilderValue
type QueryFilterAction = Types.QueryFilterAction
type QueryFilterDirection = Types.QueryFilterDirection
type QueryRemoteTarget = Types.QueryRemoteTarget
type SupportedRemoteTypes = Types.SupportedRemoteTypes
type Window = Types.Window
type CallFilterDialogOptions = {
	Filter: CallFilter?,
	Target: QueryRemoteTarget?,
	Remote: SupportedRemoteTypes?,
	Direction: QueryFilterDirection?,
	ArgumentCount: number?,
	Conditions: { QueryBuilderCondition }?,
	Action: QueryFilterAction?,
	OnSave: (QueryBuilderValue) -> (),
}

--// Module \\--
local CallFilter = {}

--// Functions \\--
local function ResolveFilterData(Options: CallFilterDialogOptions): (CallFilter?, QueryBuilderValue, number)
	local Existing = Options.Filter
	assert(type(Options.OnSave) == "function", "OnSave is required to create or edit a call filter")

	local Target = Options.Target
	if not Target and Options.Remote then
		Target = {
			Type = "Instance",
			Remote = Options.Remote,
		}
	end

	local Source = Existing or {
		Target = Target,
		Direction = Options.Direction,
		Conditions = Options.Conditions or {},
		Action = Options.Action,
	}

	local IsValid, FilterData, Errors = Validation.ValidateSchema(Source, CallFilterSchema.Filter)
	assert(IsValid, Errors[1] or "Invalid call filter data")

	local ArgumentCount = Options.ArgumentCount or 1
	for _, Condition in FilterData.Conditions do
		if Condition.Subject.Type == "Argument" then
			ArgumentCount = math.max(ArgumentCount, Condition.Subject.Index)
		end
	end

	return Existing, FilterData, math.max(1, ArgumentCount)
end

function CallFilter.Open(Window: Window, Options: CallFilterDialogOptions)
	--// Validation \\--
	local Existing, FilterData, ArgumentCount = ResolveFilterData(Options)

	local ArgumentLabels = {}
	do
		for Index = 1, ArgumentCount do
			ArgumentLabels[Index] = `Argument {Index}`
		end
	end

	local Query: QueryBuilder
	local Dialog = Window.Dialog.new({
		Title = Existing and "Edit Call Filter" or "Create Call Filter",
		Description = "Choose which remote calls Cobalt should match.",
		Icon = "list-filter",
		AutoShow = false,
		Footer = {
			Cancel = {
				Text = "Cancel",
				Action = "Dismiss",
				LayoutOrder = 1,
			},
			SaveChanges = {
				Text = Existing and "Save Changes" or "Create Filter",
				Type = "Primary",
				LayoutOrder = 2,
				Action = function(CurrentDialog: Types.Dialog)
					local IsValid, Errors = Query:Validate()
					if not IsValid then
						wax.shared.Sonner.error(Errors[1] or "This filter contains conflicting conditions.")
						return
					end

					Options.OnSave(Query:GetValue())
					CurrentDialog:Dismiss()
				end,
			},
		},
	})

	Query = Window.QueryBuilder.new(Dialog, {
		Target = FilterData.Target,
		Direction = FilterData.Direction,
		SampleRemote = Options.Remote,
		ArgumentLabels = ArgumentLabels,
		Conditions = FilterData.Conditions,
		Action = FilterData.Action,
		OnValidationChanged = function(IsValid)
			Dialog.Buttons.SaveChanges:SetDisabled(not IsValid)
		end,
	})

	Dialog:Show()
	return Dialog, Query
end

return CallFilter

end)() end,
    [129] = function()local wax,script,require,CreateLookupTable=ImportGlobals(129)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local ClearCapturedCalls = {}

function ClearCapturedCalls.Open(Window: Types.Window, ClearLogs: () -> ())
	return Window.Dialog.new({
		Title = "Clear Captured Calls?",
		TitleColor = Color3.fromRGB(245, 60, 54),
		Description = "This will permanently remove all captured incoming and outgoing calls. This action cannot be undone.",
		Icon = "trash",
		Footer = {
			{
				Text = "Cancel",
				Action = "Dismiss",
			},
			{
				Text = "Clear Calls",
				Type = "Primary",
				Action = function(Dialog: Types.Dialog)
					ClearLogs()
					Dialog:Dismiss()
				end,
			},
		},
	})
end

return ClearCapturedCalls

end)() end,
    [130] = function()local wax,script,require,CreateLookupTable=ImportGlobals(130)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local Credits = {}

function Credits.Open(Window: Types.Window)
	return Window.Dialog.new({
		Title = "Credits",
		Description = table.concat({
			"<b>upio</b> · Cobalt Developer",
			"<b>deivid</b> · Cobalt Developer",
			'<b>shadcn</b> · UI design inspiration · <font color="#3798ff">ui.shadcn.com</font>',
			'<b>The Lucide Team</b> · Icon library · <font color="#3798ff">lucide.dev</font>',
			'<b>Emil Kowalski</b> · Sonner · <font color="#3798ff">sonner.emilkowal.ski</font>',
		}, "\n\n"),
		Footer = {
			{
				Text = "Close",
				Action = "Dismiss",
			},
		},
	})
end

return Credits

end)() end,
    [131] = function()local wax,script,require,CreateLookupTable=ImportGlobals(131)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local DeleteCallFilter = {}

function DeleteCallFilter.Open(Window: Types.Window, Filter: Types.CallFilter)
	return Window.Dialog.new({
		Title = "Delete Call Filter?",
		Description = "This permanently removes the selected call filter.",
		Icon = "trash",
		Footer = {
			{ Text = "Cancel", Action = "Dismiss" },
			{
				Text = "Delete",
				Action = function(Dialog: Types.Dialog)
					wax.shared.CallFilters:Remove(Filter.Id)
					wax.shared.Sonner.success("Call filter deleted")
					Dialog:Dismiss()
				end,
			},
		},
	})
end

return DeleteCallFilter

end)() end,
    [132] = function()local wax,script,require,CreateLookupTable=ImportGlobals(132)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local DetectionRisk = {}

function DetectionRisk.Open(Window: Types.Window, Failures: { string })
	local Details = {}
	for _, Name in Failures do
		local Check = wax.shared.ExecutorSupport[Name]
		local CheckDetails = if Check then Check.Details else "No details available."
		table.insert(
			Details,
			`<b><font color="#ff9900">{Name}</font></b>\n<font transparency="0.35">{CheckDetails}</font>`
		)
	end

	return Window.Dialog.new({
		Title = "Detection Risk",
		TitleColor = Color3.fromRGB(245, 60, 54),
		Description = "Cobalt may be detectable because your executor does not support the following functions or libraries:\n\n"
			.. table.concat(Details, "\n\n"),
		Icon = "triangle-alert",
		Footer = {
			{
				Text = "Close",
				Action = "Dismiss",
			},
		},
	})
end

return DetectionRisk

end)() end,
    [133] = function()local wax,script,require,CreateLookupTable=ImportGlobals(133)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local LoggingDisabled = {}

function LoggingDisabled.Open(Window: Types.Window)
	return Window.Dialog.new({
		Title = "Limited Logging Support",
		TitleColor = Color3.fromRGB(245, 166, 35),
		Description = "Your executor can't fully support Cobalt's remote logging. Incoming RemoteEvents will still be captured with limited info; outgoing calls and incoming RemoteFunctions won't be logged on this executor.",
		Icon = "triangle-alert",
		Footer = {
			{
				Text = "I understand",
				Type = "Primary",
				HoldDuration = 3,
				Action = function(Dialog: Types.Dialog)
					if wax.shared.SaveManager:SetState("LimitedLoggingAcknowledged", true) then
						Dialog:Dismiss()
					end
				end,
			},
		},
	})
end

return LoggingDisabled

end)() end,
    [134] = function()local wax,script,require,CreateLookupTable=ImportGlobals(134)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local Oth = {}

function Oth.Confirm(Window: Types.Window, NewValue: boolean): boolean
	local Support = wax.shared.ExecutorSupport["oth"]
    if not Support.IsWorking then
        wax.shared.Sonner.error("Oth hooks are not supported by your executor:\n\n" .. Support.Details)
        return false
    end

    if NewValue == false then
        local Thread = coroutine.running()
        task.spawn(Window.Dialog.new, {
            Title = "Warning",
            Description = "Are you sure you want to disable Oth hooks? This is risky and could theoretically lead to getting banned in certain games. Cobalt is not responsible for any bans you may receive. This change takes effect the next time Cobalt launches.",
            Icon = "triangle-alert",
            AutoShow = true,
            Footer = {
                {
                    Text = "Nevermind",
                    Action = function(Dialog: Types.Dialog)
                        Dialog:Dismiss()
                        coroutine.resume(Thread, false)
                    end,
                },
                {
                    Text = "Continue (Hold to Confirm)",
                    Type = "Primary",
                    HoldDuration = 5,
                    Action = function(Dialog: Types.Dialog)
                        Dialog:Dismiss()
                        coroutine.resume(Thread, true)
                    end,
                },
            },
        })

        return coroutine.yield()
    end

    return true
end

return Oth
end)() end,
    [135] = function()local wax,script,require,CreateLookupTable=ImportGlobals(135)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")

local RakNet = {}

function RakNet.ConfirmEnable(Window: Types.Window): boolean
	local Support = wax.shared.ExecutorSupport["raknet"]
	if not Support.IsWorking then
		wax.shared.Sonner.error("RakNet hooks are not supported by your executor:\n\n" .. Support.Details)
		return false
	end

	local Thread = coroutine.running()
	task.spawn(Window.Dialog.new, {
		Title = "Warning",
		Description = "Are you sure you want to use RakNet hooks? This is risky and could theoretically lead to account bans. Cobalt is not responsible for any bans you may receive. This change takes effect the next time Cobalt launches.",
		Icon = "triangle-alert",
		AutoShow = true,
		Footer = {
			{
				Text = "Nevermind",
				Action = function(Dialog: Types.Dialog)
					Dialog:Dismiss()
					coroutine.resume(Thread, false)
				end,
			},
			{
				Text = "Continue (Hold to Confirm)",
				Type = "Primary",
				HoldDuration = 5,
				Action = function(Dialog: Types.Dialog)
					Dialog:Dismiss()
					coroutine.resume(Thread, true)
				end,
			},
		},
	})

	return coroutine.yield()
end

return RakNet

end)() end,
    [136] = function()local wax,script,require,CreateLookupTable=ImportGlobals(136)local ImportGlobals return (function(...)local Icons = require("@src/Utils/UI/Assets/Icons")
local Interface = require("@src/Utils/UI/Interface")

local Modal = {}
Modal.__index = Modal

export type Modal = {
	OpenedModal: GuiObject?,
	Background: GuiObject,
	TweenInfo: TweenInfo,
} & typeof(setmetatable({}, Modal))

local DefaultTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Exponential)

function Modal.new(
	Parent: GuiObject,
	Options: {
		TweenInfo: TweenInfo?,
	}?
)
	local self = setmetatable({
		OpenedModal = nil,
		Background = nil,
		TweenInfo = Options and Options.TweenInfo or DefaultTweenInfo,
	}, Modal)

	self.Background = Interface.New("TextButton", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		Visible = false,
		ZIndex = 2,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 6),
		},

		Parent = Parent,
	})

	self.Background.MouseButton1Click:Connect(function()
		self:Close()
	end)

	return self
end

function Modal:Open(Parent)
	self.OpenedModal = Parent

	self.OpenedModal.Visible = true
	self.Background.Visible = true
end

function Modal:Close()
	if self.OpenedModal then
		self.OpenedModal.Visible = false
		self.OpenedModal = nil
	end

	self.Background.Visible = false
end

function Modal:ConnectCloseButton(Button, Image)
	Button.MouseEnter:Connect(function()
		wax.shared.TweenService
			:Create(
				Image,
				self.TweenInfo,
				Icons.ResolveProperties(Image.ClassName, {
					IconTransparency = 0.25,
				})
			)
			:Play()
	end)

	Button.MouseLeave:Connect(function()
		wax.shared.TweenService
			:Create(
				Image,
				self.TweenInfo,
				Icons.ResolveProperties(Image.ClassName, {
					IconTransparency = 0.5,
				})
			)
			:Play()
	end)

	Button.MouseButton1Click:Connect(function()
		self:Close()
	end)
end

function Modal:CreateTop(Title: string, Icon: string, Parent: GuiObject)
	local ModalTop = Interface.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 36),
		Parent = Parent,

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		},
	})

	local ModalTitle = Interface.New("TextLabel", {
		Text = Title,
		TextSize = 17,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = ModalTop,
	})

	local ModalIcon = Interface.NewIcon(Icon, {
		IconTransparency = if Icons.GetIconData(Icon) == "Image" then 0 else 0.5,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(4, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,

		Parent = ModalTop,
	})

	local CloseButton = Interface.New("ImageButton", {
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Parent = ModalTop,
	})

	local CloseImage = Interface.NewIcon("x", {
		IconTransparency = 0.5,
		Size = UDim2.fromOffset(22, 22),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,

		Parent = CloseButton,
	})

	self:ConnectCloseButton(CloseButton, CloseImage)

	Interface.New("Frame", {
		Parent = Parent,
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.fromOffset(0, 36),
	})

	return ModalTitle, ModalIcon
end

return Modal

end)() end,
    [139] = function()local wax,script,require,CreateLookupTable=ImportGlobals(139)local ImportGlobals return (function(...)local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")
local Operators = require("@src/Utils/CallFilter/Operators")
local RemoteFields = require("@src/Utils/CallFilter/RemoteFields")

type CallFilter = Types.CallFilter
type CallFilterManager = Types.CallFilterManager

local ActionColors = {
	Ignore = Color3.fromRGB(105, 105, 105),
	Block = Color3.fromRGB(205, 75, 75),
	Highlight = Color3.fromRGB(230, 170, 65),
}

local function FormatDirection(Direction): string
	return if Direction == "Any" then "Any direction" else Direction
end

local function FormatTargetCondition(Condition): string
	return `{RemoteFields.GetText(Condition.Field)} {Operators.GetText(Condition.Operator, true)} {Operators.FormatValue(Condition.Value)}`
end

local function FormatTarget(Filter: CallFilter): (string, string?)
	if Filter.Target.Type == "Instance" then
		return Filter.Target.Remote.Name, Constants.InstanceClassImages[Filter.Target.Remote.ClassName]
	end

	return "Matching remotes", nil
end

local function FormatSummary(Filter: CallFilter): string
	local Parts = { FormatDirection(Filter.Direction) }
	if Filter.Target.Type == "Query" then
		local FirstTarget = Filter.Target.Conditions[1]
		if FirstTarget then
			local TargetSummary = FormatTargetCondition(FirstTarget)
			if #Filter.Target.Conditions > 1 then
				TargetSummary ..= ` · {#Filter.Target.Conditions} remote conditions`
			end
			table.insert(Parts, TargetSummary)
		end
	end

	local First = Filter.Conditions[1]
	if not First then
		table.insert(Parts, "All arguments")
		return table.concat(Parts, " · ")
	end

	local Subject = if First.Subject.Type == "ArgumentCount" then "#Arg" else `Arg[{First.Subject.Index}]`
	local Summary = `{Subject} {Operators.GetText(First.Operator, true)} {Operators.FormatValue(First.Value)}`
	if #Filter.Conditions > 1 then
		Summary ..= ` · {#Filter.Conditions} conditions`
	end
	table.insert(Parts, Summary)
	return table.concat(Parts, " · ")
end

return function(Props: {
	Parent: GuiObject,
	ContextMenu: any,
	Manager: CallFilterManager,
	OnEdit: (CallFilter) -> (),
	OnDuplicate: (CallFilter) -> (),
	OnDelete: (CallFilter) -> (),
})
	local Root = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Parent = Props.Parent,
		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
		},
	})

	local EmptyLabel = Interface.New("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		Size = UDim2.new(1, 0, 0, 70),
		Text = "No call filters have been created yet.\nRight-click a captured call to create one.",
		TextSize = 14,
		TextTransparency = 0.5,
		TextWrapped = true,
		Parent = Root,
		["UICorner"] = { CornerRadius = UDim.new(0, 6) },
		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},
	})

	local Rows = {}
	local Refresh
	local ActiveToggleAnimations = 0
	local DeferredFilters
	local function ClearRows()
		for _, Row in Rows do
			Row:Destroy()
		end
		table.clear(Rows)
	end

	local function CreateToggle(Parent: GuiObject, Filter: CallFilter)
		local Toggle = Interface.New("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = if Filter.Enabled then Color3.fromRGB(52, 199, 89) else Color3.fromRGB(50, 50, 50),
			Position = UDim2.new(1, -38, 0.5, 0),
			Size = UDim2.fromOffset(32, 18),
			Text = "",
			Parent = Parent,
			["UICorner"] = { CornerRadius = UDim.new(1, 0) },
		})
		local Knob = Interface.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Position = if Filter.Enabled then UDim2.new(1, -9, 0.5, 0) else UDim2.new(0, 9, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			Parent = Toggle,
			["UICorner"] = { CornerRadius = UDim.new(1, 0) },
		})

		Toggle.MouseButton1Click:Connect(function()
			Toggle.Interactable = false
			local Enabled = not Filter.Enabled
			ActiveToggleAnimations += 1
			Props.Manager:SetEnabled(Filter.Id, Enabled)
			wax.shared.TweenService
				:Create(Toggle, Constants.DefaultTweenInfo, {
					BackgroundColor3 = if Enabled then Color3.fromRGB(52, 199, 89) else Color3.fromRGB(50, 50, 50),
				})
				:Play()
			local KnobTween = wax.shared.TweenService:Create(Knob, Constants.DefaultTweenInfo, {
				Position = if Enabled then UDim2.new(1, -9, 0.5, 0) else UDim2.new(0, 9, 0.5, 0),
			})
			KnobTween:Play()
			KnobTween.Completed:Once(function()
				ActiveToggleAnimations -= 1
				if ActiveToggleAnimations == 0 and DeferredFilters then
					local Filters = DeferredFilters
					DeferredFilters = nil
					Refresh(Filters)
				end
			end)
		end)
	end

	local function CreateRow(Filter: CallFilter)
		local TargetName, TargetImage = FormatTarget(Filter)
		local Row = Interface.New("Frame", {
			BackgroundColor3 = Color3.fromRGB(10, 10, 10),
			BackgroundTransparency = if Filter.Enabled then 0 else 0.35,
			Size = UDim2.new(1, 0, 0, 52),
			Parent = Root,
			["UICorner"] = { CornerRadius = UDim.new(0, 6) },
			["UIStroke"] = {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
			},
		})
		table.insert(Rows, Row)

		Interface.NewIcon(if Filter.Target.Type == "Query" then "globe" else TargetImage or "", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.fromOffset(26, 26),
			Parent = Row,
		})
		local Header = Interface.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(42, 5),
			Size = UDim2.new(1, -200, 0, 21),
			Parent = Row,
			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 6),
			},
		})
		Interface.New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			Text = TargetName,
			TextSize = 16,
			TextTransparency = if Filter.Enabled then 0 else 0.4,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Header,
			["UISizeConstraint"] = { MaxSize = Vector2.new(180, 21) },
		})
		Interface.New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = ActionColors[Filter.Action] or Color3.fromRGB(75, 75, 75),
			BackgroundTransparency = 0.75,
			Size = UDim2.new(0, 0, 0, 20),
			Text = Filter.Action,
			TextSize = 12,
			Parent = Header,
			["UICorner"] = { CornerRadius = UDim.new(0, 4) },
			["UIPadding"] = { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) },
		})
		Interface.New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(42, 25),
			RichText = false,
			Size = UDim2.new(1, -200, 0, 18),
			Text = FormatSummary(Filter),
			TextSize = 13,
			TextTransparency = 0.55,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Row,
		})

		CreateToggle(Row, Filter)

		local MoreButton = Interface.NewIconButton("ellipsis", {
			AnchorPoint = Vector2.new(1, 0.5),
			IconTransparency = 0.5,
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.fromOffset(22, 22),
			Parent = Row,
		})
		local Menu = Props.ContextMenu:Create(MoreButton, {
			{
				Text = "Edit",
				Icon = "pencil",
				Callback = function()
					Props.OnEdit(Filter)
				end,
			},
			{
				Text = "Duplicate",
				Icon = "copy",
				Callback = function()
					Props.OnDuplicate(Filter)
				end,
			},
			{
				Text = "Delete",
				Icon = "trash",
				Callback = function()
					Props.OnDelete(Filter)
				end,
			},
		})
		MoreButton.MouseButton1Click:Connect(Menu.Toggle)
	end

	Refresh = function(Filters: { CallFilter })
		ClearRows()
		EmptyLabel.Visible = #Filters == 0
		for _, Filter in Filters do
			CreateRow(Filter)
		end
	end

	local Subscription = Props.Manager:Subscribe(function(Filters)
		if ActiveToggleAnimations > 0 then
			DeferredFilters = Filters
			return
		end
		Refresh(Filters)
	end)
	return {
		Root = Root,
		Refresh = Refresh,
		Destroy = function()
			Subscription:Disconnect()
			Root:Destroy()
		end,
	}
end

end)() end,
    [140] = function()local wax,script,require,CreateLookupTable=ImportGlobals(140)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")

local SettingSync = require(script.Parent.SettingSync)

return function(props: {
	Parent: GuiObject,
	Idx: string,
	Options: {
		Text: string,
		Callback: ((boolean) -> ())?,
		PreSetCallback: ((boolean) -> ())?,
		Default: boolean?,
	},
})
	--// Props \\--
	local Idx = props.Idx
	local Options = props.Options

	--// Setup \\--
	local Checkbox = {
		Idx = Idx,
		Default = Options.Default or false,
		Value = wax.shared.SaveManager:GetState(Idx, Options.Default or false),
		Risky = Options.Risky or false,
	}

	local ToggleTextRiskyColor = Color3.fromRGB(255, 125, 0)

	local CheckboxUI = Interface.New("TextButton", {
		Text = Options.Text,
		TextSize = 16,
		TextColor3 = if Checkbox.Risky then ToggleTextRiskyColor else Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = props.Parent,
	})

	local ToggleOnColor = Color3.fromRGB(52, 199, 89)
	local ToggleOffColor = Color3.fromRGB(50, 50, 50)

	local ToggleKnobOffSize = UDim2.fromOffset(16, 16)
	local ToggleKnobOnSize = UDim2.fromOffset(18, 18)
	local ToggleKnobInset = 10

	local ToggleTrack = Interface.New("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(36, 20),
		BackgroundColor3 = ToggleOffColor,
		Parent = CheckboxUI,

		["UICorner"] = {
			CornerRadius = UDim.new(1, 0),
		},
	})

	local ToggleKnob = Interface.New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = ToggleKnobOffSize,
		Parent = ToggleTrack,

		["UICorner"] = {
			CornerRadius = UDim.new(1, 0),
		},
	})

	local function UpdateToggleVisual(instant: boolean?)
		local TargetTrackColor = if Checkbox.Value then ToggleOnColor else ToggleOffColor
		local TargetKnobPosition = if Checkbox.Value
			then UDim2.new(1, -ToggleKnobInset, 0.5, 0)
			else UDim2.new(0, ToggleKnobInset, 0.5, 0)
		local TargetKnobSize = if Checkbox.Value then ToggleKnobOnSize else ToggleKnobOffSize

		if instant then
			ToggleTrack.BackgroundColor3 = TargetTrackColor
			ToggleKnob.Position = TargetKnobPosition
			ToggleKnob.Size = TargetKnobSize
			return
		end

		wax.shared.TweenService
			:Create(ToggleTrack, Constants.DefaultTweenInfo, {
				BackgroundColor3 = TargetTrackColor,
			})
			:Play()

		wax.shared.TweenService
			:Create(ToggleKnob, Constants.DefaultTweenInfo, {
				Position = TargetKnobPosition,
				Size = TargetKnobSize,
			})
			:Play()
	end

	function Checkbox:Reset()
		Checkbox:SetValue(Checkbox.Default)
	end

	function Checkbox:SetValue(NewValue)
		if Options.PreSetCallback then
			local Result = Options.PreSetCallback(NewValue)
			if Result == false then return end
		end

		SettingSync.Save(Idx, NewValue)

		Checkbox.Value = NewValue
		UpdateToggleVisual()

		if Options.Callback then
			Options.Callback(Checkbox.Value)
		end
	end

	CheckboxUI.MouseButton1Click:Connect(function()
		Checkbox:SetValue(not Checkbox.Value)
	end)

	UpdateToggleVisual(true)
	SettingSync.Register(Idx, Checkbox)

	return Checkbox
end

end)() end,
    [141] = function()local wax,script,require,CreateLookupTable=ImportGlobals(141)local ImportGlobals return (function(...)--// Imports \\--
local Icons = require("@src/Utils/UI/Assets/Icons")
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")

local SettingSync = require(script.Parent.SettingSync)

local function CloneDictionary(Source: { [any]: any })
	local Copy = {}
	for Key, Value in pairs(Source) do
		Copy[Key] = Value
	end

	return Copy
end

return function(props: {
	Parent: GuiObject,
	Idx: string,
	ContextMenu: any,
	Options: {
		Multi: boolean?,
		AllowNull: boolean?,
		Values: { [any]: any },
		Default: any | { [any]: any },
		Callback: ((any) -> ())?,
		Text: string,
	},
})
	--// Props \\--
	local Idx = props.Idx
	local Options = props.Options
	local AllowNull = Options.AllowNull or false

	assert(AllowNull or Options.Default ~= nil, "Default value must be provided when AllowNull is false")

	local Default = Options.Default and CreateLookupTable(Options.Default)
		or Options.AllowNull and (Options.Multi and {} or Options.Values[1])
		or {}

	--// Setup \\--
	local Dropdown = {
		Idx = Idx,
		Values = Options.Values or {},
		Default = Default,
		Value = wax.shared.SaveManager:GetState(Idx, Default),
		Multi = Options.Multi or false,
		Callback = Options.Callback,
	}

	local DropdownUI = Interface.New("TextButton", {
		Text = Options.Text,
		TextSize = 16,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 24),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = props.Parent,
	})

	DropdownUI.AutoButtonColor = false

	local DropdownDisplay = Interface.New("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(180, 24),
		Parent = DropdownUI,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
		},
	})

	local ValueLabel = Interface.New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -16, 1, 0),
		Text = "Select...",
		TextSize = 16,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextTransparency = 0.45,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = DropdownDisplay,
	})

	local DropdownIcon = Interface.NewIcon("chevron-down", {
		AnchorPoint = Vector2.new(1, 0.5),
		IconTransparency = 0.2,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		Parent = DropdownDisplay,
	})

	local DisplayDefaultColor = DropdownDisplay.BackgroundColor3
	local DisplayHoverColor = Color3.fromRGB(12, 12, 12)

	local function TweenDisplayColor(TargetColor: Color3, TargetTransparency: number?)
		wax.shared.TweenService
			:Create(DropdownDisplay, Constants.DefaultTweenInfo, {
				BackgroundColor3 = TargetColor,
			})
			:Play()

		if TargetTransparency then
			wax.shared.TweenService
				:Create(
					DropdownIcon,
					Constants.DefaultTweenInfo,
					Icons.ResolveProperties(DropdownIcon.ClassName, {
						IconTransparency = TargetTransparency,
					})
				)
				:Play()
		end
	end

	local function IterateValues(Callback: (any, string) -> ())
		for Index, Object in Dropdown.Values do
			local ActualValue = typeof(Index) == "number" and Object or Index
			local DisplayText = typeof(Index) == "number" and tostring(Object) or tostring(Index)
			Callback(ActualValue, DisplayText)
		end
	end

	local function ResolveValueText(Value)
		local Resolved
		IterateValues(function(ActualValue, DisplayText)
			if ActualValue == Value then
				Resolved = DisplayText
			end
		end)

		return Resolved or (Value ~= nil and tostring(Value) or "")
	end

	local function UpdateValueLabel()
		local DisplayText = "Select..."
		local Transparency = 0.45

		if Dropdown.Multi then
			local SelectedTexts = {}
			IterateValues(function(Value, Text)
				if Dropdown.Value[Value] then
					table.insert(SelectedTexts, Text)
				end
			end)

			if #SelectedTexts == 0 then
				DisplayText = "None"
			else
				table.sort(SelectedTexts)
				DisplayText = if #SelectedTexts <= 2
					then table.concat(SelectedTexts, ", ")
					else string.format("%s, +%d", SelectedTexts[1], #SelectedTexts - 1)
				Transparency = 0
			end
		elseif Dropdown.Value == nil or Dropdown.Value == "" then
			DisplayText = "None"
		else
			local Resolved = ResolveValueText(Dropdown.Value)
			DisplayText = if Resolved == "" then tostring(Dropdown.Value) else Resolved
			Transparency = 0
		end

		ValueLabel.Text = DisplayText
		ValueLabel.TextTransparency = Transparency
	end

	local DropdownContext

	local function SetValue(NewValue, CloseMenu: boolean?)
		SettingSync.Save(Idx, NewValue)

		if CloseMenu ~= false and DropdownContext then
			DropdownContext:Close()
		end

		if Dropdown.Multi then
			for Image, Object in pairs(Dropdown.Values) do
				local Value = if typeof(Image) == "number" then Object else Image
				Dropdown.Value[Value] = NewValue[Value]
			end
		else
			Dropdown.Value = NewValue
		end

		UpdateValueLabel()

		if Dropdown.Callback then
			Dropdown.Callback(Dropdown.Value)
		end
	end

	local function BuildDropdownContext()
		local MenuOptions = {}
		for Index, Object in Dropdown.Values do
			local IsArray = typeof(Index) == "number"

			local ContextOption = {
				Text = tostring(Object),
				CloseOnClick = not Dropdown.Multi,
				Callback = function()
					local Value = if IsArray then Object else Index

					if Dropdown.Multi then
						local NewValue = CloneDictionary(Dropdown.Value)
						NewValue[Value] = not (NewValue[Value] or false)
						SetValue(NewValue, false)
					else
						SetValue(Value)
					end
				end,
				TextProperties = function()
					local Value = if IsArray then Object else Index
					local IsSelected = if Dropdown.Multi then Dropdown.Value[Value] else Dropdown.Value == Value

					return {
						TextTransparency = if IsSelected then 0 else 0.5,
					}
				end,
			}

			if not IsArray then
				ContextOption.Text = Index
				ContextOption.Icon = Object
			end

			table.insert(MenuOptions, ContextOption)
		end

		return MenuOptions
	end

	function Dropdown:Reset()
		Dropdown:SetValue(if Dropdown.Multi then CloneDictionary(Dropdown.Default) else Dropdown.Default)
	end

	function Dropdown:SetValue(NewValue)
		SetValue(NewValue)
	end

	DropdownUI.MouseEnter:Connect(function()
		TweenDisplayColor(DisplayHoverColor, 0.05)
	end)

	DropdownUI.MouseLeave:Connect(function()
		TweenDisplayColor(DisplayDefaultColor, 0.2)
	end)

	DropdownContext = props.ContextMenu:Create(DropdownDisplay, BuildDropdownContext())
	DropdownUI.MouseButton1Click:Connect(DropdownContext.Toggle)

	UpdateValueLabel()
	SettingSync.Register(Idx, Dropdown)

	return Dropdown
end

end)() end,
    [142] = function()local wax,script,require,CreateLookupTable=ImportGlobals(142)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Icons = require("@src/Utils/UI/Assets/Icons")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

return function(props: {
	Parent: GuiObject,
	Idx: string,
	CreateButton: (string, () -> ()) -> TextButton,
	Options: {
		Text: string?,
		Callback: ((any) -> ())?,
		NullMessage: string,
	},
})
	--// Props \\--
	local Options = props.Options

	--// Setup \\--
	local RemoteList = {
		Idx = props.Idx,
		Value = {},
		InfoMapping = {},
	}

	local RemoveIgnored

	local RemoteListContainer = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Parent = props.Parent,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 8),
		},

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},
	})

	local NoRemotesText = Interface.New("TextLabel", {
		Size = UDim2.new(1, 0, 0, 100),
		TextTransparency = 0.5,
		Text = Options.NullMessage,
		TextSize = 14,
		Visible = true,
		Parent = RemoteListContainer,
	})

	if Options.Text then
		Interface.New("TextLabel", {
			Text = `<b>{Options.Text}</b>`,
			TextSize = 14,
			TextTransparency = 0.15,
			Size = UDim2.new(1, 0, 0, 18),
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = -1,
			Parent = RemoteListContainer,
		})
	end

	local function CreateListElement(RemoteData)
		local Remote = RemoteData.Instance
		if not Remote then
			return
		end

		local ListElement = Interface.New("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, 0, 0, 32),
			Parent = RemoteListContainer,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 4),
			},

			["UIStroke"] = {
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},

			["Frame"] = {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,

				["UIListLayout"] = {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 4),
				},

				["UIPadding"] = {
					PaddingLeft = UDim.new(0, 5),
				},

				["ImageLabel"] = {
					Size = UDim2.new(1, -8, 1, -8),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Image = Constants.InstanceClassImages[Remote.ClassName],
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
				},

				["TextLabel"] = {
					Text = `{Remote.Name} ({RemoteData.Type})`,
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 16,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
				},
			},
		})

		local RemoveButton = Interface.NewIconButton("trash", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.new(1, -12, 1, -12),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			IconTransparency = 0.5,
			Parent = ListElement,
		})

		RemoveButton.MouseEnter:Connect(function()
			wax.shared.TweenService
				:Create(
					RemoveButton,
					Constants.DefaultTweenInfo,
					Icons.ResolveProperties(RemoveButton.ClassName, {
						IconTransparency = 0,
					})
				)
				:Play()
		end)

		RemoveButton.MouseLeave:Connect(function()
			wax.shared.TweenService
				:Create(
					RemoveButton,
					Constants.DefaultTweenInfo,
					Icons.ResolveProperties(RemoveButton.ClassName, {
						IconTransparency = 0.5,
					})
				)
				:Play()
		end)

		RemoveButton.MouseButton1Click:Connect(function()
			RemoteList:RemoveFromList(RemoteData)

			if Options.Callback then
				Options.Callback(RemoteData)
			end
		end)
	end

	function RemoteList:Display()
		for _, Object in pairs(RemoteListContainer:GetChildren()) do
			if Object:IsA("Frame") then
				Object:Destroy()
			end
		end

		NoRemotesText.Visible = #self.Value == 0
		RemoveIgnored.Visible = #self.Value > 0

		for _, RemoteData in self.Value do
			CreateListElement(RemoteData)
		end
	end

	function RemoteList:AddToList(Remote)
		table.insert(self.Value, Remote)
		self:Display()
	end

	function RemoteList:RemoveFromList(Remote)
		local Index = table.find(self.Value, Remote)
		if not Index then
			return
		end

		table.remove(self.Value, Index)
		self:Display()
	end

	function RemoteList:SetList(Remotes: { Types.SupportedRemoteTypes })
		self.Value = Remotes
		self:Display()
	end

	RemoveIgnored = props.CreateButton("Remove All", function()
		if not Options.Callback then
			return
		end

		local ToRemove = {}
		for _, Remote in RemoteList.Value do
			Options.Callback(Remote)
			table.insert(ToRemove, Remote)
		end

		for _, Remote in ToRemove do
			RemoteList:RemoveFromList(Remote)
		end

		wax.shared.Sonner.success("Removed all remotes")
	end)
	RemoveIgnored.Visible = false

	RemoteList:Display()
	wax.shared.Settings[props.Idx] = RemoteList

	return RemoteList
end

end)() end,
    [143] = function()local wax,script,require,CreateLookupTable=ImportGlobals(143)local ImportGlobals return (function(...)local SettingSync = {}

function SettingSync.Broadcast(Idx: string, Value: any)
	if not wax.shared.ActorCommunicator then
		return
	end

	pcall(function()
		wax.shared.ActorCommunicator:Fire("MainSettingsSync", Idx, Value)
	end)
end

function SettingSync.Save(Idx: string, Value: any)
	local Success, Error = wax.shared.SaveManager:SetState(Idx, Value)
	if not Success then
		return false, Error
	end

	SettingSync.Broadcast(Idx, Value)
	return true
end

function SettingSync.Register(Idx: string, Setting: any, Value: any?)
	SettingSync.Broadcast(Idx, if Value == nil then Setting.Value else Value)
	wax.shared.Settings[Idx] = Setting
end

return SettingSync

end)() end,
    [144] = function()local wax,script,require,CreateLookupTable=ImportGlobals(144)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")

local SettingSync = require(script.Parent.SettingSync)

local function NormalizeNumberText(Value: string): string
	if Value == "" then
		return ""
	end

	local Characters = table.create(#Value)
	local HasDigits = false
	local HasDecimal = false
	local SignApplied = false

	for Index = 1, #Value do
		local Char = string.sub(Value, Index, Index)
		local Byte = string.byte(Char)

		if Char == "-" and not SignApplied and not HasDigits and not HasDecimal then
			table.insert(Characters, Char)
			SignApplied = true
		elseif Char == "." and not HasDecimal then
			table.insert(Characters, Char)
			HasDecimal = true
			SignApplied = true
		elseif Byte and Byte >= 48 and Byte <= 57 then
			table.insert(Characters, Char)
			HasDigits = true
			SignApplied = true
		end
	end

	local Sanitized = table.concat(Characters)

	if Sanitized == "-" or Sanitized == "." or Sanitized == "-." then
		return ""
	end

	return Sanitized
end

return function(props: {
	Parent: GuiObject,
	Idx: string,
	Options: {
		Text: string,
		Callback: ((any) -> ())?,
		Default: any?,
		Placeholder: string?,
		ClearTextOnFocus: boolean?,
		Width: number?,
		NumericOnly: boolean?,
	},
})
	--// Props \\--
	local Idx = props.Idx
	local Options = props.Options
	local NumericOnly = Options.NumericOnly == true
	local TextBoxWidth = Options.Width or 160

	local function NormalizeValue(NewValue: any): string
		local Value = tostring(NewValue or "")
		return if NumericOnly then NormalizeNumberText(Value) else Value
	end

	local DefaultValue = NormalizeValue(Options.Default)
	local SavedValue = wax.shared.SaveManager:GetState(Idx)
	local InitialValue = NormalizeValue(if SavedValue ~= nil then SavedValue else DefaultValue)

	--// Setup \\--
	local TextSetting = {
		Idx = Idx,
		Default = DefaultValue,
		Value = InitialValue,
		Callback = Options.Callback,
	}

	local Container = Interface.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 26),
		Parent = props.Parent,

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2),
		},
	})

	Interface.New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, -TextBoxWidth - 6, 1, 0),
		Text = Options.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = true,
		Parent = Container,
	})

	local Input = Interface.New("TextBox", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(5, 5, 5),
		ClearTextOnFocus = Options.ClearTextOnFocus or false,
		PlaceholderColor3 = Color3.fromRGB(128, 128, 128),
		PlaceholderText = Options.Placeholder or "",
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, TextBoxWidth, 1, -2),
		Text = InitialValue,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Container,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIStroke"] = {
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
		},
	})

	local function SyncValue(NewValue: string, FireCallback: boolean?)
		TextSetting.Value = NewValue
		Input.Text = NewValue

		if FireCallback ~= false and TextSetting.Callback then
			TextSetting.Callback(if NumericOnly then tonumber(NewValue) else NewValue)
		end
	end

	function TextSetting:Reset()
		TextSetting:SetValue(TextSetting.Default)
	end

	function TextSetting:SetValue(NewValue)
		local PreparedValue = NormalizeValue(NewValue)

		if PreparedValue == TextSetting.Value then
			SyncValue(PreparedValue, false)
			return
		end

		if not SettingSync.Save(Idx, PreparedValue) then
			SyncValue(TextSetting.Value, false)
			return
		end
		SyncValue(PreparedValue)
	end

	Input.FocusLost:Connect(function()
		TextSetting:SetValue(Input.Text)
	end)

	SyncValue(TextSetting.Value, false)
	SettingSync.Register(Idx, TextSetting)

	return TextSetting
end

end)() end,
    [145] = function()local wax,script,require,CreateLookupTable=ImportGlobals(145)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")

local ContextMenuController = require("@src/Window/Components/ContextMenu")

local CreateCheckbox = require(script.Parent.Controls.Checkbox)
local CreateCallFilterList = require(script.Parent.Controls.CallFilterList)
local CreateDropdown = require(script.Parent.Controls.Dropdown)
local CreateRemoteList = require(script.Parent.Controls.RemoteList)
local CreateTextBox = require(script.Parent.Controls.TextBox)

--// Builder \\--
return function(props: {
	ContextMenu: ContextMenuController.ContextMenu,
})
	local ContextMenu = props.ContextMenu

	local SectionBuilder = {}
	SectionBuilder.__index = SectionBuilder

	function SectionBuilder.new(Parent: Frame, DataSavePrefix: string?)
		return setmetatable({
			Parent = Parent,
			DataSavePrefix = DataSavePrefix or "",
		}, SectionBuilder)
	end

	function SectionBuilder:CreateRow(Padding: UDim?)
		local Row = Interface.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = self.Parent,

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = Padding or UDim.new(0, 8),
			},
		})

		return SectionBuilder.new(Row, self.DataSavePrefix)
	end

	function SectionBuilder:AddLabel(Text: string, TextSize: number?)
		return Interface.New("TextLabel", {
			Text = Text,
			TextSize = TextSize or 16,
			Size = UDim2.new(1, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Parent = self.Parent,
			TextWrapped = true,
		})
	end

	function SectionBuilder:AddSpacer(Height: number?)
		return Interface.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Height or 0),
			Parent = self.Parent,
		})
	end

	function SectionBuilder:CreateButton(Text: string, Callback: (() -> ())?, TextSize: number?)
		local Button = Interface.New("TextButton", {
			BackgroundColor3 = Color3.fromRGB(15, 15, 15),
			Size = UDim2.new(1, 0, 0, 24),
			TextSize = 15,
			Text = "",
			Parent = self.Parent,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 4),
			},

			["UIStroke"] = {
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},

			["TextLabel"] = {
				Text = Text,
				TextSize = TextSize or 16,
				TextTransparency = 0.5,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(0, -1),
			},
		})

		Button.MouseButton1Click:Connect(function()
			if Callback then
				Callback()
			end
		end)

		return Button
	end

	function SectionBuilder:CreateCheckbox(Idx: string, Options)
		return CreateCheckbox({
			Parent = self.Parent,
			Idx = self.DataSavePrefix .. Idx,
			Options = Options,
		})
	end

	function SectionBuilder:CreateTextBox(Idx: string, Options)
		return CreateTextBox({
			Parent = self.Parent,
			Idx = self.DataSavePrefix .. Idx,
			Options = Options,
		})
	end

	function SectionBuilder:CreateDropdown(Idx: string, Options)
		return CreateDropdown({
			Parent = self.Parent,
			Idx = self.DataSavePrefix .. Idx,
			Options = Options,
			ContextMenu = ContextMenu,
		})
	end

	function SectionBuilder:CreateRemoteList(Idx: string, Options)
		return CreateRemoteList({
			Parent = self.Parent,
			Idx = self.DataSavePrefix .. Idx,
			Options = Options,
			CreateButton = function(Text, Callback)
				return self:CreateButton(Text, Callback)
			end,
		})
	end

	function SectionBuilder:CreateCallFilterList(Options)
		return CreateCallFilterList({
			Parent = self.Parent,
			ContextMenu = ContextMenu,
			Manager = Options.Manager,
			OnEdit = Options.OnEdit,
			OnDuplicate = Options.OnDuplicate,
			OnDelete = Options.OnDelete,
		})
	end

	return SectionBuilder
end

end)() end,
    [146] = function()local wax,script,require,CreateLookupTable=ImportGlobals(146)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local SectionBuilder = require(script.Parent.Section)

local ContextMenu = require("@src/Window/Components/ContextMenu")

--// Builder \\--
local SettingsBuilder = {}
export type Builder = typeof(SettingsBuilder)
SettingsBuilder.__index = SettingsBuilder

return function(props: {
	ContextMenu: ContextMenu.ContextMenu,
})
	local ContextMenu = props.ContextMenu

	--// Section Builder \\--
	local SectionBuilder = SectionBuilder({
		ContextMenu = ContextMenu,
	})

	--// Settings Builder \\--
	function SettingsBuilder.new(Parent: Frame)
		return setmetatable({
			Parent = Parent,
		}, SettingsBuilder)
	end

	-- Sections Constructor
	function SettingsBuilder:CreateSection(SectionName: string, DataSavePrefix: string?)
		local Section = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			Parent = self.Parent,

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 4),
			},

			["TextLabel"] = {
				Text = `<b>{SectionName}</b>`,
				RichText = true,
				TextSize = 18,
				Size = UDim2.new(1, 0, 0, 18),
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = -1,
			},
		})

		return SectionBuilder.new(Section, DataSavePrefix)
	end

	return SettingsBuilder
end

end)() end,
    [147] = function()local wax,script,require,CreateLookupTable=ImportGlobals(147)local ImportGlobals return (function(...)local Types = require("@src/Window/Types")
local UI = require("@src/Window/Components/QueryBuilder/UI")
local Operators = require("@src/Utils/CallFilter/Operators")

type Dialog = Types.Dialog
type QueryBuilder = Types.QueryBuilder
type QueryBuilderProps = Types.QueryBuilderProps

local QueryBuilderClass = {
	ContextMenu = nil,
}

function QueryBuilderClass.new(Dialog: Dialog, Props: QueryBuilderProps): QueryBuilder
	local ContextMenu = assert(QueryBuilderClass.ContextMenu, "QueryBuilder.ContextMenu has not been configured")
	return UI.new(Dialog, Props, ContextMenu, Operators)
end

return QueryBuilderClass

end)() end,
    [148] = function()local wax,script,require,CreateLookupTable=ImportGlobals(148)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")
local RemoteFields = require("@src/Utils/CallFilter/RemoteFields")

--// Types \\--
type Dialog = Types.Dialog
type QueryBuilder = Types.QueryBuilder
type QueryBuilderCondition = Types.QueryBuilderCondition
type QueryBuilderProps = Types.QueryBuilderProps
type QueryFilterAction = Types.QueryFilterAction
type QueryFilterJoin = Types.QueryFilterJoin
type QueryFilterOperator = Types.QueryFilterOperator
type QueryRemoteCondition = Types.QueryRemoteCondition
type QueryRemoteTarget = Types.QueryRemoteTarget

type Select = {
	Container: Frame,
	Value: any,
	SetValue: (Select, any, boolean?) -> (),
}

type Validator = {
	Validate: ({ QueryBuilderCondition }) -> (boolean, { string }, { [number]: boolean }),
	GetConditionType: ({ QueryBuilderCondition }, QueryBuilderCondition) -> string?,
	IsAllowed: ({ QueryBuilderCondition }, QueryBuilderCondition, QueryFilterOperator) -> boolean,
	GetOptions: () -> { { Value: QueryFilterOperator, Text: string } },
	GetTypeNames: () -> { string },
}

--// Constants \\--
local BackgroundColor = Color3.fromRGB(15, 15, 15)
local BorderColor = Color3.fromRGB(35, 35, 35)
local LineColor = Color3.fromRGB(60, 60, 60)
local ErrorColor = Color3.fromRGB(245, 60, 54)

local Actions = {
	{ Value = "Ignore", Text = "Ignore matching calls" },
	{ Value = "Block", Text = "Block matching calls" },
	{ Value = "Highlight", Text = "Highlight matching calls" },
}

local Joins = {
	{ Value = "And", Text = "AND" },
	{ Value = "Or", Text = "OR" },
}

local Scopes = {
	{ Value = "Instance", Text = "This remote" },
	{ Value = "Query", Text = "Matching remotes" },
}

local Directions = {
	{ Value = "Outgoing", Text = "Outgoing" },
	{ Value = "Incoming", Text = "Incoming" },
	{ Value = "Any", Text = "Any direction" },
}

local function EscapeRichText(Text: string): string
	return Text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&apos;")
end

local UI = {}

local function CopyCondition(Condition: QueryBuilderCondition): QueryBuilderCondition
	return {
		Subject = table.clone(Condition.Subject),
		Operator = Condition.Operator,
		Value = Condition.Value,
		Join = Condition.Join,
	}
end

local function CopyRemoteCondition(Condition: QueryRemoteCondition): QueryRemoteCondition
	return table.clone(Condition)
end

local function CopyTarget(Target: QueryRemoteTarget): QueryRemoteTarget
	local Copy = table.clone(Target)
	if Target.Type == "Query" then
		Copy.Conditions = {}
		for _, Condition in Target.Conditions do
			table.insert(Copy.Conditions, CopyRemoteCondition(Condition))
		end
	end
	return Copy :: any
end

local function GetSubjectValue(Subject): string
	return if Subject.Type == "ArgumentCount" then "ArgumentCount" else `Argument:{Subject.Index}`
end

local function CreateSubject(Value: string)
	if Value == "ArgumentCount" then
		return { Type = "ArgumentCount" }
	end

	return {
		Type = "Argument",
		Index = tonumber(string.match(Value, "^Argument:(%d+)$")) or 1,
	}
end

local function GetRemoteValueOptions(Field)
	local Options = RemoteFields.GetValueOptions(Field)
	if Options and Field == "ClassName" then
		for _, Option in Options do
			Option.Icon = Constants.InstanceClassImages[Option.Value]
		end
	end
	return Options
end

local function CreateMain(Parent: GuiObject)
	return Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = Parent,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
		},
	})
end

local function CreateStage(Main: Frame, LayoutOrder: number, AutomaticSize: Enum.AutomaticSize, Height: number)
	local Stage = Interface.New("Frame", {
		AutomaticSize = AutomaticSize,
		BackgroundTransparency = 1,
		LayoutOrder = LayoutOrder,
		Size = UDim2.new(1, 0, 0, Height),
		Parent = Main,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		},
	})

	return Stage
end

local function CreateRemoteLeft(Stage: Frame)
	local Left = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = Stage,
	})

	Interface.New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 17),
		Rotation = 45,
		Size = UDim2.fromOffset(11, 11),
		Parent = Left,

		["UIStroke"] = {
			Color = LineColor,
			Thickness = 1,
		},
	})

	Interface.New("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = LineColor,
		Position = UDim2.new(0, 5, 1, 0),
		Size = UDim2.new(0, 1, 1, -24),
		Parent = Left,
	})

	Interface.New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(23, 17),
		Size = UDim2.new(0, 60, 0, 25),
		Text = "Remote",
		TextSize = 14,
		TextTransparency = 0.25,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Left,
	})

	return Left
end

local function CreateBranchLeft(Stage: Frame, Label: string, Height: number, IsLast: boolean)
	local Left = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, Height),
		Parent = Stage,
	})

	Interface.New("Frame", {
		BackgroundColor3 = LineColor,
		Position = if IsLast then UDim2.fromOffset(5, -2) else UDim2.fromOffset(5, 0) ,
		Size = if IsLast then UDim2.new(0, 1, 0.5, 2) else UDim2.new(0, 1, 1, 0),
		Parent = Left,
	})

	Interface.New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = LineColor,
		Position = if IsLast then UDim2.new(0, 6, 0.5, 0) else UDim2.fromOffset(6, 17),
		Size = UDim2.fromOffset(10, 1),
		Parent = Left,
	})

	Interface.New("TextLabel", {
		AutomaticSize = if IsLast then Enum.AutomaticSize.X else Enum.AutomaticSize.XY,
		AnchorPoint = if IsLast then Vector2.new(0, 0.5) else Vector2.zero,
		Position = if IsLast then UDim2.new(0, 23, 0.5, 0) else UDim2.fromOffset(23, 10),
		Size = if IsLast then UDim2.new(0, 60, 1, 0) else UDim2.new(0, 60, 0, 0),
		Text = Label,
		TextSize = 14,
		TextTransparency = 0.25,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Left,
	})

	return Left
end

local function CreateRight(Stage: Frame, AutomaticSize: Enum.AutomaticSize)
	return Interface.New("Frame", {
		AutomaticSize = AutomaticSize,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = if AutomaticSize == Enum.AutomaticSize.Y then UDim2.new(1, -83, 0, 0) else UDim2.new(1, -83, 1, 0),
		Parent = Stage,

		["UIPadding"] = {
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
		},
	})
end

local function CreateSelect(props: {
	Parent: GuiObject,
	ContextMenu: any,
	Options: { { Value: any, Text: string, Icon: string? } },
	Default: any,
	LayoutOrder: number,
	Text: ((any, string) -> string)?,
	IsOptionAllowed: ((any) -> boolean)?,
	MaxMenuHeight: number?,
	OnChanged: ((any) -> ())?,
}): Select
	local Container = Interface.New("TextButton", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(0, 0, 1, 0),
		Text = "",
		Parent = props.Parent,

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
		},

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 3),
		},
	})

	local Label = Interface.New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Text = "",
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Container,
	})
	local SelectedIcon = Interface.New("ImageLabel", {
		Name = "Icon",
		LayoutOrder = -1,
		Size = UDim2.fromOffset(15, 15),
		Visible = false,
		Parent = Container,
	})

	Interface.NewIcon("chevron-down", {
		IconTransparency = 0.5,
		LayoutOrder = 1,
		Size = UDim2.fromOffset(15, 15),
		Parent = Container,
	})

	local Select = {
		Container = Container,
		Value = props.Default,
	} :: Select

	local function FindOption(Value: any)
		for _, Option in props.Options do
			if Option.Value == Value then
				return Option
			end
		end
		return nil
	end

	local Context
	function Select:SetValue(Value: any, SkipCallback: boolean?)
		self.Value = Value
		local Option = FindOption(Value)
		local Text = Option and Option.Text or tostring(Value)
		Label.Text = if props.Text then props.Text(Value, Text) else Text
		if Option ~= nil and Option.Icon ~= nil then
			SelectedIcon = Interface.SetIcon(SelectedIcon, Option.Icon)
			SelectedIcon.Visible = true
		else
			SelectedIcon.Visible = false
		end
		if Context then
			Context:Close()
		end
		if not SkipCallback and props.OnChanged then
			props.OnChanged(Value)
		end
	end

	local MenuOptions = {}
	for _, Option in props.Options do
		table.insert(MenuOptions, {
			Text = EscapeRichText(Option.Text),
			Icon = Option.Icon,
			Condition = function()
				return not props.IsOptionAllowed or props.IsOptionAllowed(Option.Value)
			end,
			Callback = function()
				Select:SetValue(Option.Value)
			end,
			TextProperties = function()
				return { TextTransparency = if Select.Value == Option.Value then 0 else 0.5 }
			end,
		})
	end

	Context = props.ContextMenu:Create(
		Container,
		MenuOptions,
		nil,
		if props.MaxMenuHeight then { MaxHeight = props.MaxMenuHeight } else nil
	)
	Container.MouseButton1Click:Connect(Context.Toggle)
	Select:SetValue(props.Default, true)
	return Select
end

local function CreateSeparator(Parent: GuiObject, LayoutOrder: number)
	return Interface.New("Frame", {
		BackgroundColor3 = BorderColor,
		LayoutOrder = LayoutOrder,
		Size = UDim2.new(0, 1, 1, 0),
		Parent = Parent,
	})
end

local function CreateScrollableRow(Parent: GuiObject, LayoutOrder: number)
	local Row = Interface.New("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		LayoutOrder = LayoutOrder,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		Size = UDim2.new(0, 1, 0, 25),
		Parent = Parent,
	})

	local Content = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = BackgroundColor,
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(0, 0, 0, 23),
		Parent = Row,
		["UICorner"] = { CornerRadius = UDim.new(0, 4) },
		["UIStroke"] = { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = BorderColor, Thickness = 1 },
		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 2),
		},
		["UIPadding"] = { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 2) },
	})

	local function UpdateCanvasSize()
		local Layout = Content.UIListLayout
		local Padding = Content.UIPadding
		local CanvasWidth = Content.Position.X.Offset
			+ Layout.AbsoluteContentSize.X
			+ Padding.PaddingLeft.Offset
			+ Padding.PaddingRight.Offset
			+ 1
		local AvailableWidth = math.max(1, Parent.AbsoluteSize.X - 2)
		local ViewportWidth = math.min(CanvasWidth, AvailableWidth)
		Row.Size = UDim2.fromOffset(ViewportWidth, 25)
		Row.CanvasSize = UDim2.fromOffset(CanvasWidth, 0)

		local MaximumX = math.max(0, CanvasWidth - ViewportWidth)
		Row.ScrollingEnabled = MaximumX > 1
		if not Row.ScrollingEnabled then
			Row.CanvasPosition = Vector2.zero
		elseif Row.CanvasPosition.X > MaximumX then
			Row.CanvasPosition = Vector2.new(MaximumX, 0)
		end
	end

	Content.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
	Row:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(UpdateCanvasSize)
	Row.InputChanged:Connect(function(Input: InputObject)
		if Input.UserInputType ~= Enum.UserInputType.MouseWheel or not Row.ScrollingEnabled then
			return
		end

		local MaximumX = math.max(0, Row.AbsoluteCanvasSize.X - Row.AbsoluteWindowSize.X)
		Row.CanvasPosition = Vector2.new(math.clamp(Row.CanvasPosition.X - Input.Position.Z * 28, 0, MaximumX), 0)
	end)

	UpdateCanvasSize()
	return Row, Content, Content.UIStroke, UpdateCanvasSize
end

function UI.new(Dialog: Dialog, props: QueryBuilderProps, ContextMenu: any, Operators: Validator): QueryBuilder
	assert(not Dialog.Destroyed, "Cannot create a query builder on a destroyed dialog")
	local TypeofValues = Operators.GetTypeNames()

	local Builder = {
		Target = CopyTarget(props.Target),
		Conditions = {},
		ConditionRows = {},
		Direction = props.Direction,
		Action = props.Action or "Ignore",
		Destroyed = false,
		IsValid = true,
		ValidationErrors = {},
	}

	local Main = CreateMain(Dialog.MainContent)
	Builder.Root = Main
	local EmitChanged

	--// Remote \\--
	local RemoteStage = CreateStage(Main, 0, Enum.AutomaticSize.Y, 0)
	CreateRemoteLeft(RemoteStage)
	local RemoteRight = CreateRight(RemoteStage, Enum.AutomaticSize.Y)
	Interface.New("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDim.new(0, 6),
		Parent = RemoteRight,
	})
	local _, RemoteDisplay, _, UpdateRemoteDisplay = CreateScrollableRow(RemoteRight, 0)

	local ExactRemote = if props.Target.Type == "Instance" then props.Target.Remote else props.SampleRemote
	local ScopeOptions = table.clone(Scopes)
	ScopeOptions[1] = table.clone(ScopeOptions[1])
	ScopeOptions[1].Icon = ExactRemote and Constants.InstanceClassImages[ExactRemote.ClassName] or nil

	local RefreshTargetUI
	CreateSelect({
		Parent = RemoteDisplay,
		ContextMenu = ContextMenu,
		Options = ScopeOptions,
		Default = Builder.Target.Type,
		LayoutOrder = -4,
		Text = function(Value, Text)
			return if Value == "Instance" then ExactRemote and ExactRemote.Name or "No remote selected" else Text
		end,
		IsOptionAllowed = function(Value)
			return Value == "Query" or ExactRemote ~= nil
		end,
		OnChanged = function(Value)
			if Value == "Instance" then
				Builder.Target = { Type = "Instance", Remote = ExactRemote }
			else
				local Conditions = if Builder.Target.Type == "Query" then Builder.Target.Conditions else {}
				if #Conditions == 0 then
					table.insert(Conditions, {
						Field = "Name",
						Operator = "Equals",
						Value = ExactRemote and ExactRemote.Name or "",
						Join = "And",
					})
				end
				Builder.Target = { Type = "Query", Conditions = Conditions }
			end
			if RefreshTargetUI then RefreshTargetUI() end
			if EmitChanged then EmitChanged() end
		end,
	})
	local ScopeSeparator = CreateSeparator(RemoteDisplay, -3)
	CreateSelect({
		Parent = RemoteDisplay,
		ContextMenu = ContextMenu,
		Options = Directions,
		Default = Builder.Direction,
		LayoutOrder = 3,
		OnChanged = function(Value)
			Builder.Direction = Value
			if EmitChanged then EmitChanged() end
		end,
	})

	local TargetRows = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = RemoteRight,
		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
		},
	})

	--// Where \\--
	local WhereStage = CreateStage(Main, 1, Enum.AutomaticSize.Y, 0)
	local WhereLeft = CreateBranchLeft(WhereStage, "Where", 70, false)
	local WhereRight = CreateRight(WhereStage, Enum.AutomaticSize.Y)
	local Rows = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = WhereRight,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 10),
		},
		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, 1),
			PaddingTop = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1),
		},
	})
	local ValidationLabel = Interface.New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = 999,
		Size = UDim2.fromScale(0, 0),
		Text = "",
		TextColor3 = ErrorColor,
		TextSize = 13,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Visible = false,
		Parent = Rows,
	})

	local ConflictingRows = {}
	local TargetConflictingRows = {}
	local TargetConditionRows = {}
	function Builder:Validate(): (boolean, { string })
		local IsValid, Errors, Conflicts = Operators.Validate(self.Conditions)
		ConflictingRows = Conflicts

		if self.Target.Type == "Query" then
			if #self.Target.Conditions == 0 then
				IsValid = false
				table.insert(Errors, "Matching remotes require at least one remote condition.")
				TargetConflictingRows = {}
			else
				local TargetValid, TargetErrors, TargetConflicts = RemoteFields.Validate(self.Target.Conditions)
				IsValid = IsValid and TargetValid
				TargetConflictingRows = TargetConflicts
				for _, Error in TargetErrors do
					table.insert(Errors, Error)
				end
			end
		else
			TargetConflictingRows = {}
		end

		self.IsValid = IsValid
		self.ValidationErrors = Errors
		return self.IsValid, table.clone(Errors)
	end

	local function ApplyValidation()
		ValidationLabel.Visible = not Builder.IsValid
		ValidationLabel.Text = Builder.ValidationErrors[1] or ""
		WhereLeft.Size = UDim2.new(0, 0, 0, 35 * (#Builder.Conditions + 1) + (Builder.IsValid and 0 or 28))

		for Index, RowData in Builder.ConditionRows do
			RowData.Stroke.Color = if ConflictingRows[Index] then ErrorColor else BorderColor
		end
		for Index, RowData in TargetConditionRows do
			RowData.Stroke.Color = if TargetConflictingRows[Index] then ErrorColor else BorderColor
		end

		if props.OnValidationChanged then
			props.OnValidationChanged(Builder.IsValid, table.clone(Builder.ValidationErrors))
		end
	end

	EmitChanged = function()
		Builder:Validate()
		ApplyValidation()
		if props.OnChanged then
			props.OnChanged(Builder:GetValue())
		end
	end

	local function RefreshRows()
		Builder:Validate()
		local Count = #Builder.Conditions
		for Index, RowData in Builder.ConditionRows do
			RowData.JoinContainer.Visible = Index > 1
			RowData.JoinSeparator.Visible = Index > 1
			RowData.RemoveContainer.Visible = Count > 0
			RowData.RemoveSeparator.Visible = Count > 0
			RowData.Row.LayoutOrder = Index - 1
			RowData.Content.UIPadding.PaddingRight = UDim.new(0, if Count > 0 then 2 else 0)
			RowData.UpdateCanvasSize()
			if RowData.UpdateValueMode then
				RowData.UpdateValueMode()
			end
		end
		Builder:Validate()
		ApplyValidation()
	end

	local TargetAddCondition = Interface.New("TextButton", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		LayoutOrder = 1000,
		Size = UDim2.new(0, 0, 0, 25),
		Text = "Add remote condition",
		TextSize = 14,
		TextTransparency = 0.5,
		Parent = TargetRows,
		["UIPadding"] = { PaddingLeft = UDim.new(0, 22), PaddingRight = UDim.new(0, 5) },
	})
	Interface.NewIcon("plus", {
		AnchorPoint = Vector2.new(0, 0.5),
		IconTransparency = 0.5,
		Position = UDim2.new(0, -17, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		Parent = TargetAddCondition,
	})

	local function CreateTargetConditionRow(Data: QueryRemoteCondition, Index: number)
		local Row, Content, Stroke, UpdateCanvasSize = CreateScrollableRow(TargetRows, Index)

		local JoinSeparator = CreateSeparator(Content, -1)
		local Join = CreateSelect({
			Parent = Content,
			ContextMenu = ContextMenu,
			Options = Joins,
			Default = Data.Join or "And",
			LayoutOrder = -2,
			OnChanged = function(Value)
				Data.Join = Value
				EmitChanged()
			end,
		})
		Join.Container.Visible = Index > 1
		JoinSeparator.Visible = Index > 1

		CreateSelect({
			Parent = Content,
			ContextMenu = ContextMenu,
			Options = RemoteFields.GetOptions(),
			Default = Data.Field,
			LayoutOrder = 0,
			OnChanged = function(Value)
				Data.Field = Value
				if not RemoteFields.IsOperatorAllowed(Data.Operator, Value) then
					Data.Operator = "Equals"
				end
				local ValueOptions = RemoteFields.GetValueOptions(Value)
				if ValueOptions and not RemoteFields.IsValueAllowed(Value, Data.Value) then
					Data.Value = ValueOptions[1].Value
				end
				RefreshTargetUI()
				EmitChanged()
			end,
		})

		CreateSeparator(Content, 1)
		CreateSelect({
			Parent = Content,
			ContextMenu = ContextMenu,
			Options = Operators.GetOptions(),
			Default = Data.Operator,
			LayoutOrder = 2,
			IsOptionAllowed = function(Value)
				return RemoteFields.IsOperatorAllowed(Value, Data.Field)
			end,
			MaxMenuHeight = 150,
			Text = function(_, Text)
				return `<font transparency="0.5">{EscapeRichText(Text)}</font>`
			end,
			OnChanged = function(Value)
				Data.Operator = Value
				EmitChanged()
			end,
		})

		CreateSeparator(Content, 3)
		local TargetValueContainer = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			Size = UDim2.new(0, 0, 1, 0),
			Parent = Content,
			["UIPadding"] = { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 2) },
			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
		})
		local ValueOptions = GetRemoteValueOptions(Data.Field)
		if ValueOptions then
			if not RemoteFields.IsValueAllowed(Data.Field, Data.Value) then
				Data.Value = ValueOptions[1].Value
			end
			CreateSelect({
				Parent = TargetValueContainer,
				ContextMenu = ContextMenu,
				Options = ValueOptions,
				Default = Data.Value,
				LayoutOrder = 0,
				MaxMenuHeight = 150,
				OnChanged = function(Value)
					Data.Value = Value
					EmitChanged()
				end,
			})
		else
			local TargetValueBox = Interface.New("TextBox", {
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				LayoutOrder = 0,
				Size = UDim2.new(0, 0, 1, 0),
				Text = Data.Value,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = TargetValueContainer,
				["UISizeConstraint"] = { MinSize = Vector2.new(35, 0) },
			})
			TargetValueBox:GetPropertyChangedSignal("Text"):Connect(function()
				Data.Value = TargetValueBox.Text
				EmitChanged()
			end)
		end

		local RemoveSeparator = CreateSeparator(Content, 5)
		local RemoveContainer = Interface.New("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 6,
			Size = UDim2.new(0, 20, 1, 0),
			Parent = Content,
			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
		})
		local Remove = Interface.NewIconButton("x", {
			IconTransparency = 0.5,
			Size = UDim2.fromOffset(14, 14),
			Parent = RemoveContainer,
		})
		local CanRemove = Builder.Target.Type == "Query" and #Builder.Target.Conditions > 1
		RemoveContainer.Visible = CanRemove
		RemoveSeparator.Visible = CanRemove
		Remove.MouseButton1Click:Connect(function()
			if Builder.Target.Type == "Query" and #Builder.Target.Conditions > 1 then
				table.remove(Builder.Target.Conditions, Index)
				RefreshTargetUI()
				EmitChanged()
			end
		end)

		table.insert(TargetConditionRows, {
			Row = Row,
			Stroke = Stroke,
			UpdateCanvasSize = UpdateCanvasSize,
		})
		UpdateCanvasSize()
	end

	RefreshTargetUI = function()
		for _, RowData in TargetConditionRows do
			RowData.Row:Destroy()
		end
		table.clear(TargetConditionRows)

		local IsQuery = Builder.Target.Type == "Query"
		ScopeSeparator.Visible = true
		TargetRows.Visible = IsQuery
		TargetAddCondition.Visible = IsQuery
		UpdateRemoteDisplay()

		if IsQuery then
			for Index, Condition in Builder.Target.Conditions do
				CreateTargetConditionRow(Condition, Index)
			end
		end
		Builder:Validate()
		ApplyValidation()
	end
	RemoteRight:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateRemoteDisplay)

	TargetAddCondition.MouseButton1Click:Connect(function()
		if Builder.Target.Type ~= "Query" then
			return
		end
		table.insert(Builder.Target.Conditions, {
			Field = "Name",
			Operator = "Equals",
			Value = "",
			Join = "And",
		})
		RefreshTargetUI()
		EmitChanged()
	end)

	RefreshTargetUI()
	Rows:GetPropertyChangedSignal("AbsoluteSize"):Connect(RefreshRows)

	function Builder:AddCondition(Condition: QueryBuilderCondition?)
		local Data = CopyCondition(Condition or {
			Subject = { Type = "Argument", Index = 1 },
			Operator = "Equals",
			Value = "",
			Join = "And",
		})
		table.insert(self.Conditions, Data)

		local Row, Content, ContentStroke, UpdateCanvasSize = CreateScrollableRow(Rows, #self.Conditions - 1)

		local JoinSeparator = CreateSeparator(Content, -1)
		local Join = CreateSelect({
			Parent = Content,
			ContextMenu = ContextMenu,
			Options = Joins,
			Default = Data.Join or "And",
			LayoutOrder = -2,
			OnChanged = function(Value: QueryFilterJoin)
				Data.Join = Value
				EmitChanged()
			end,
		})
		local JoinContainer = Join.Container

		local SubjectOptions = {
			{ Value = "ArgumentCount", Text = "#Arg" },
		}
		for Index, Label in props.ArgumentLabels or { "Argument 1", "Argument 2", "Argument 3" } do
			table.insert(SubjectOptions, { Value = `Argument:{Index}`, Text = Label })
		end
		local Operator
		local Subject = CreateSelect({
			Parent = Content,
			ContextMenu = ContextMenu,
			Options = SubjectOptions,
			Default = GetSubjectValue(Data.Subject),
			LayoutOrder = 0,
			Text = function(Value)
				if Value == "ArgumentCount" then
					return `<font transparency="0.5">#Arg</font>`
				end
				local Index = string.match(Value, "^Argument:(%d+)$") or "1"
				return `<font transparency="0.5">Arg</font>[<font color="rgb(255,255,255)">{Index}</font>]`
			end,
			OnChanged = function(Value: string)
				Data.Subject = CreateSubject(Value)
				if not Operators.IsAllowed(Builder.Conditions, Data, Data.Operator) then
					Data.Operator = "Equals"
					if Operator then
						Operator:SetValue("Equals", true)
					end
				end
				RefreshRows()
				EmitChanged()
			end,
		})

		CreateSeparator(Content, 1)
		local UpdateValueMode
		local CurrentArgumentType
		local function IsOperatorAllowed(Value: QueryFilterOperator): boolean
			return Operators.IsAllowed(Builder.Conditions, Data, Value)
		end
		Operator = CreateSelect({
			Parent = Content,
			ContextMenu = ContextMenu,
			Options = Operators.GetOptions(),
			Default = Data.Operator,
			LayoutOrder = 2,
			IsOptionAllowed = IsOperatorAllowed,
			MaxMenuHeight = 150,
			Text = function(_, Text)
				return `<font transparency="0.5">{EscapeRichText(Text)}</font>`
			end,
			OnChanged = function(Value: QueryFilterOperator)
				Data.Operator = Value
				if UpdateValueMode then
					UpdateValueMode()
				end
				RefreshRows()
				EmitChanged()
			end,
		})

		CreateSeparator(Content, 3)
		local ValueContainer = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			Size = UDim2.new(0, 0, 1, 0),
			Parent = Content,
			["UIPadding"] = { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 2) },
			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 1),
			},
		})
		local ValueBox = Interface.New("TextBox", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			Size = UDim2.new(0, 0, 1, 0),
			Text = tostring(Data.Value),
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = ValueContainer,
			["UISizeConstraint"] = {
				MinSize = Vector2.new(35, 0),
			},
		})
		local TypeLabel = Interface.New("TextLabel", {
			Active = true,
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 0,
			Size = UDim2.new(0, 0, 1, 0),
			Text = tostring(Data.Value),
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = false,
			Parent = ValueContainer,
		})
		local ValueChevron = Interface.NewIcon("chevron-down", {
			Active = true,
			IconTransparency = 0.5,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(12, 12),
			Parent = ValueContainer,
		})

		local TypeOptions = {}
		local TypeContext
		for _, TypeName in TypeofValues do
			table.insert(TypeOptions, {
				Text = TypeName,
				Callback = function()
					Data.Value = TypeName
					TypeLabel.Text = TypeName
					TypeContext:Close()
					RefreshRows()
					EmitChanged()
				end,
				TextProperties = function()
					return { TextTransparency = if Data.Value == TypeName then 0 else 0.5 }
				end,
			})
		end
		TypeContext = ContextMenu:Create(ValueContainer, TypeOptions, nil, {
			MaxHeight = 180,
		})

		local BooleanContext = ContextMenu:Create(ValueContainer, {
			{
				Text = "true",
				Callback = function()
					Data.Value = true
					TypeLabel.Text = "true"
					EmitChanged()
				end,
			},
			{
				Text = "false",
				Callback = function()
					Data.Value = false
					TypeLabel.Text = "false"
					EmitChanged()
				end,
			},
		})

		local ValueMode = "Text"
		local function ToggleValueContext(Input: InputObject)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				if ValueMode == "Type" then
					TypeContext:Toggle()
				elseif ValueMode == "Boolean" then
					BooleanContext:Toggle()
				end
			end
		end
		TypeLabel.InputBegan:Connect(ToggleValueContext)
		ValueChevron.InputBegan:Connect(ToggleValueContext)

		UpdateValueMode = function()
			CurrentArgumentType = Operators.GetConditionType(Builder.Conditions, Data)
			local IsType = Data.Operator == "TypeIs"
			local IsBoolean = not IsType and CurrentArgumentType == "boolean"
			ValueMode = if IsType then "Type" elseif IsBoolean then "Boolean" else "Text"

			if not IsType then
				TypeContext:Close()
			end
			if not IsBoolean then
				BooleanContext:Close()
			end
			if IsType then
				if not table.find(TypeofValues, tostring(Data.Value)) then
					local InferredType = CurrentArgumentType or typeof(Data.Value)
					Data.Value = if table.find(TypeofValues, InferredType) then InferredType else "Instance"
				end
				TypeLabel.Text = tostring(Data.Value)
			elseif IsBoolean then
				if typeof(Data.Value) ~= "boolean" then
					Data.Value = true
				end
				TypeLabel.Text = tostring(Data.Value)
			end
			if ValueMode == "Text" and ValueBox.Text ~= tostring(Data.Value) then
				ValueBox.Text = tostring(Data.Value)
			end
			ValueBox.Visible = ValueMode == "Text"
			TypeLabel.Visible = ValueMode ~= "Text"
			ValueChevron.Visible = ValueMode ~= "Text"
			ValueChevron.Active = ValueMode ~= "Text"
		end
		UpdateValueMode()
		ValueBox:GetPropertyChangedSignal("Text"):Connect(function()
			Data.Value = if CurrentArgumentType == "number"
				then tonumber(ValueBox.Text) or ValueBox.Text
				else ValueBox.Text
			EmitChanged()
		end)

		local RemoveSeparator = CreateSeparator(Content, 5)
		local RemoveContainer = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.None,
			BackgroundTransparency = 1,
			LayoutOrder = 6,
			Size = UDim2.new(0, 20, 1, 0),
			Parent = Content,
			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
		})
		local Remove = Interface.NewIconButton("x", {
			IconTransparency = 0.5,
			Size = UDim2.fromOffset(14, 14),
			Parent = RemoveContainer,
		})

		local RowData = {
			Row = Row,
			Content = Content,
			Stroke = ContentStroke,
			Join = Join,
			JoinContainer = JoinContainer,
			JoinSeparator = JoinSeparator,
			Subject = Subject,
			Operator = Operator,
			ValueBox = ValueBox,
			RemoveContainer = RemoveContainer,
			RemoveSeparator = RemoveSeparator,
			UpdateCanvasSize = UpdateCanvasSize,
			UpdateValueMode = UpdateValueMode,
		}
		table.insert(self.ConditionRows, RowData)

		Remove.MouseButton1Click:Connect(function()
			local Index = table.find(self.ConditionRows, RowData)
			if Index then
				self:RemoveCondition(Index)
			end
		end)

		RefreshRows()
		EmitChanged()
		return Data
	end

	function Builder:RemoveCondition(Index: number)
		local RowData = table.remove(self.ConditionRows, Index)
		table.remove(self.Conditions, Index)
		if RowData then
			RowData.Row:Destroy()
		end
		RefreshRows()
		EmitChanged()
	end

	local AddCondition = Interface.New("TextButton", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		LayoutOrder = 1000,
		Size = UDim2.new(0, 0, 0, 25),
		Text = "Add Condition",
		TextSize = 14,
		TextTransparency = 0.5,
		Parent = Rows,
		["UICorner"] = { CornerRadius = UDim.new(0, 4) },
		["UIPadding"] = { PaddingLeft = UDim.new(0, 22), PaddingRight = UDim.new(0, 5) },
	})
	Interface.NewIcon("plus", {
		AnchorPoint = Vector2.new(0, 0.5),
		IconTransparency = 0.5,
		Position = UDim2.new(0, -17, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		Parent = AddCondition,
	})
	AddCondition.MouseButton1Click:Connect(function()
		Builder:AddCondition()
	end)

	--// Action \\--
	local ActionStage = CreateStage(Main, 3, Enum.AutomaticSize.None, 35)
	CreateBranchLeft(ActionStage, "Action", 35, true)
	local ActionRight = CreateRight(ActionStage, Enum.AutomaticSize.None)
	local ActionFrame = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = BackgroundColor,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = ActionRight,
		["UICorner"] = { CornerRadius = UDim.new(0, 4) },
		["UIStroke"] = { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = BorderColor, Thickness = 1 },
		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 2),
		},
		["UIPadding"] = { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) },
	})
	local Action = CreateSelect({
		Parent = ActionFrame,
		ContextMenu = ContextMenu,
		Options = Actions,
		Default = Builder.Action,
		LayoutOrder = 0,
		OnChanged = function(Value: QueryFilterAction)
			Builder.Action = Value
			EmitChanged()
		end,
	})

	function Builder:GetValue()
		local Conditions = {}
		for _, Condition in self.Conditions do
			table.insert(Conditions, CopyCondition(Condition))
		end
		return {
			Target = CopyTarget(self.Target),
			Direction = self.Direction,
			Conditions = Conditions,
			Action = self.Action,
		}
	end

	function Builder:SetAction(Value: QueryFilterAction)
		Action:SetValue(Value)
	end

	function Builder:Destroy()
		if self.Destroyed then
			return
		end
		self.Destroyed = true
		Main:Destroy()
	end

	for _, Condition in props.Conditions or {} do
		Builder:AddCondition(Condition)
	end

	return Builder :: any
end

return UI

end)() end,
    [149] = function()local wax,script,require,CreateLookupTable=ImportGlobals(149)local ImportGlobals return (function(...)--[[[

Sonner Luau Port by upio
Original Sonner by Emil Kowalski (https://sonner.emilkowal.ski/)

TODO (which will almost probably never be done):
 - Add a way to view the previous notifications (hovering over the notifs but im lazy)
 - Handle too many notifications breaking the UI
 - Fix inconsistant notification positioning
]]

local Sonner = {
	Queue = {},
	TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential),
	Wrapper = nil,
	PendingQueue = {},
	Processing = false,
}

local Icons = require("@src/Utils/UI/Assets/Icons")
local Interface = require("@src/Utils/UI/Interface")
local Animations = require("@src/Window/Utils/Animations")

local NOTIFICATION_WIDTH = 250
local NOTIFICATION_MIN_HEIGHT = 50
local NOTIFICATION_VERTICAL_PADDING = 20

local function GetHiddenPosition(Notification: GuiObject): UDim2
	return UDim2.new(0.5, 0, 1, math.max(NOTIFICATION_MIN_HEIGHT, Notification.AbsoluteSize.Y + 2))
end

local function InternalCreateNotificationObject(zindex, image, text)
	local NotificationTemplate = Interface.New("CanvasGroup", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(NOTIFICATION_WIDTH, NOTIFICATION_MIN_HEIGHT),
		Position = UDim2.new(0.5, 0, 1, 500),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = zindex,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIStroke"] = {
			Color = Color3.fromRGB(39, 42, 42),
		},

		["UIScale"] = {},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		},
	})

	local Icon = Interface.NewIcon(image or "", {
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Size = UDim2.new(0, 20, 0, 20),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 20, 0.5, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = image ~= nil,
		ZIndex = zindex + 1,
		Parent = NotificationTemplate,
	})
	if Icon:IsA("ImageLabel") then
		Icon.ScaleType = Enum.ScaleType.Fit
	end

	Animations.SetFadeExpectation(
		"In",
		Icon,
		Icons.ResolveProperties(Icon.ClassName, {
			BackgroundTransparency = 1,
			IconTransparency = 0,
		})
	)

	local Frame = Interface.New("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(1, -50, 1, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		ZIndex = zindex + 1,
		Parent = NotificationTemplate,

		["UIListLayout"] = {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
		},
	})

	local TextLabel = Interface.New("TextLabel", {
		BorderSizePixel = 0,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = text,
		ZIndex = zindex + 1,
		Parent = Frame,
		TextWrapped = true,
	})

	local function UpdateHeight()
		NotificationTemplate.Size = UDim2.fromOffset(
			NOTIFICATION_WIDTH,
			math.max(NOTIFICATION_MIN_HEIGHT, math.ceil(TextLabel.TextBounds.Y) + NOTIFICATION_VERTICAL_PADDING)
		)
	end

	TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateHeight)
	UpdateHeight()

	return NotificationTemplate
end

local function InternalToast(image, text, internalTime, removeCallback)
	assert(Sonner.Wrapper, "Sonner has not been initialized")
	assert(typeof(image) == "string" or image == nil, "Image must be a string or nil")
	assert(typeof(text) == "string", "Text is required!")
	assert(typeof(internalTime) == "number" or internalTime == nil, "Time must be a number or nil")

	local time = internalTime or 4.5

	local Notif = InternalCreateNotificationObject(500, image, text)

	Notif.Parent = Sonner.Wrapper
	wax.shared.RunService.Heartbeat:Wait()
	Notif.Position = GetHiddenPosition(Notif)

	table.insert(Sonner.Queue, Notif)

	local ScaleMultiplier = 0.9
	local RemovalQueue = {}

	for index, object in Sonner.Queue do
		if object == Notif then
			continue
		end

		object.ZIndex = 500 - (#Sonner.Queue - index)

		-- shift them down
		wax.shared.TweenService
			:Create(object.UIScale, Sonner.TweenInfo, {
				Scale = object.UIScale.Scale * ScaleMultiplier,
			})
			:Play()

		wax.shared.TweenService
			:Create(object, Sonner.TweenInfo, {
				Position = object.Position - UDim2.fromOffset(0, object.AbsoluteSize.Y * 0.35),
			})
			:Play()

		if ((#Sonner.Queue - index) + 1) >= 4 then
			Animations.FadeOut(object)
			task.delay(0.5, function()
				object:Destroy()
			end)
			table.insert(RemovalQueue, object)
		end
	end

	for _, obj in RemovalQueue do
		table.remove(Sonner.Queue, table.find(Sonner.Queue, obj))
	end

	wax.shared.TweenService
		:Create(Notif, Sonner.TweenInfo, {
			Position = UDim2.new(0.5, 0, 1, -20),
		})
		:Play()
	Animations.FadeIn(Notif)

	if removeCallback then
		task.spawn(removeCallback, Notif, time)
	else
		task.delay(time, function()
			if not table.find(Sonner.Queue, Notif) then
				return
			end
			table.remove(Sonner.Queue, table.find(Sonner.Queue, Notif))

			Animations.FadeOut(Notif, 0.35)
			wax.shared.TweenService
				:Create(Notif, Sonner.TweenInfo, {
					Position = GetHiddenPosition(Notif),
				})
				:Play()
			task.wait(0.5)
			Notif:Destroy()
		end)
	end
end

local function ProcessQueue()
	if Sonner.Processing then
		return
	end
	if not Sonner.Wrapper then
		return
	end
	Sonner.Processing = true

	while #Sonner.PendingQueue > 0 do
		local Request = table.remove(Sonner.PendingQueue, 1)
		InternalToast(Request.image, Request.text, Request.internalTime, Request.removeCallback)
		task.wait(0.5)
	end

	Sonner.Processing = false
end

local function toast(image, text, internalTime, removeCallback)
	table.insert(Sonner.PendingQueue, {
		image = image,
		text = text,
		internalTime = internalTime,
		removeCallback = removeCallback,
	})

	task.spawn(ProcessQueue)
end

function Sonner.info(text, internalTime)
	toast("info", text, internalTime)
end

function Sonner.success(text, internalTime)
	toast("circle-check", text, internalTime)
end

function Sonner.warning(text, internalTime)
	toast("triangle-alert", text, internalTime)
end

function Sonner.error(text, internalTime)
	toast("circle-alert", text, internalTime)
end

function Sonner.toast(text, internalTime)
	toast(nil, text, internalTime)
end

function Sonner.promise(func, options)
	local loadingText = options.loadingText or "Loading..."
	local successText = options.successText or "Success!"
	local errorText = options.errorText or "Error!"
	local internalTime = options.time or 4.5

	toast("loader-circle", loadingText, internalTime, function(notif, time)
		local success, resultOrError = nil, nil

		local spinnerThread = task.spawn(function()
			repeat
				wax.shared.RunService.RenderStepped:Wait()

				local icon = notif:FindFirstChild("Icon")
				if not icon then
					continue
				end
				icon.Rotation = (icon.Rotation + 1) % 360
			until success == false or resultOrError ~= nil
		end)

		success, resultOrError = pcall(func, function(text)
			notif.Frame.TextLabel.Text = text
		end)

		task.spawn(function()
			setthreadidentity(8)

			-- The thread identity is 8 when setting it on the parent thread (Sonner.promise), but it still lacks capabilities when running another child thread
			-- Capabilities here should pass from a thread to another... Could be an upstream (executor) issue ?

			Animations.FadeOut(notif.Icon, 0.15)
			wax.shared.TweenService
				:Create(notif.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
					Size = UDim2.new(0, 0, 0, 0),
				})
				:Play()
			task.wait(0.15)

			if coroutine.status(spinnerThread) ~= "dead" then
				coroutine.close(spinnerThread)
			end
			notif.Icon.Rotation = 0

			if success then
				Icons.SetIcon(notif.Icon, "check")
				local message = (
					typeof(successText) == "string" and successText
					or typeof(successText) == "function" and successText(resultOrError)
					or "Success!"
				)

				if message:match("%s") then
					notif.Frame.TextLabel.Text = string.format(message, tostring(resultOrError))
				else
					notif.Frame.TextLabel.Text = message
				end
			else
				Icons.SetIcon(notif.Icon, "circle-alert")
				notif.Frame.TextLabel.Text = (
					typeof(errorText) == "string" and errorText
					or typeof(errorText) == "function" and errorText(resultOrError)
					or "Error!"
				)
			end

			Animations.FadeIn(notif.Icon)
			wax.shared.TweenService
				:Create(notif.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
					Size = UDim2.new(0, 20, 0, 20),
				})
				:Play()

			task.delay(time, function()
				if not table.find(Sonner.Queue, notif) then
					return
				end
				table.remove(Sonner.Queue, table.find(Sonner.Queue, notif))

				Animations.FadeOut(notif, 0.35)
				wax.shared.TweenService
					:Create(notif, Sonner.TweenInfo, {
						Position = GetHiddenPosition(notif),
					})
					:Play()

				task.wait(0.5)
				notif:Destroy()
			end)
		end)
	end)
end

function Sonner.rawtoast(options)
	local image = options.image
	local text = options.text or "No Text Provided"
	local internalTime = options.time or 4.5

	toast(image, text, internalTime)
end

function Sonner.init(wrapper)
	Sonner.Wrapper = wrapper
	task.spawn(ProcessQueue)
end

return Sonner

end)() end,
    [150] = function()local wax,script,require,CreateLookupTable=ImportGlobals(150)local ImportGlobals return (function(...)--// Imports \\--
local Icons = require("@src/Utils/UI/Assets/Icons")
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Drag = require("@src/Window/Utils/Input/Drag")
local ModalController = require("@src/Window/Components/Modal")

--// Component \\--
return function(props: {
	MainFrame: Frame,
	ShowButton: TextButton,
	CobaltLogo: string,
	Modals: {
		Controller: ModalController.Modal,
		[string]: any,
	},
	GetDPIScale: (() -> number)?,
})
	--// Props \\--
	local MainFrame = props.MainFrame
	local ShowButton = props.ShowButton
	local Modals = props.Modals

	--// UI \\--
	local TopBar = Interface.New("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(1, 0, 0, 36),
		ZIndex = 0,
		Parent = MainFrame,

		["TextLabel"] = {
			Text = "Cobalt",
			TextSize = 18,
			Position = UDim2.fromOffset(0, 1),
			Size = UDim2.new(1, 0, 1, -1),
		},

		["ImageLabel"] = {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 6, 0.5, 0),
			Size = UDim2.new(1, -12, 1, -12),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Image = props.CobaltLogo,
		},

		["UICorner"] = {
			TopLeftRadius = UDim.new(0, 6),
			TopRightRadius = UDim.new(0, 6),
			BottomLeftRadius = UDim.new(0, 0),
			BottomRightRadius = UDim.new(0, 0),
		},
	})

	local TopButtons = Interface.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
		},

		["UIPadding"] = {
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
		},

		Parent = TopBar,
	})

	--// Functions \\--
	local function CreateTopButton(IconName: string, Order: number, Callback: (() -> ())?)
		local Button = Interface.New("ImageButton", {
			LayoutOrder = Order,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,

			["UIPadding"] = {
				PaddingBottom = UDim.new(0, 3),
				PaddingLeft = UDim.new(0, 3),
				PaddingRight = UDim.new(0, 3),
				PaddingTop = UDim.new(0, 3),
			},

			Parent = TopButtons,
		})

		local Image = Interface.NewIcon(IconName, {
			IconTransparency = 0.5,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,

			Parent = Button,
		})

		Button.MouseEnter:Connect(function()
			wax.shared.TweenService
				:Create(
					Image,
					Constants.DefaultTweenInfo,
					Icons.ResolveProperties(Image.ClassName, {
						IconTransparency = 0.25,
					})
				)
				:Play()
		end)

		Button.MouseLeave:Connect(function()
			wax.shared.TweenService
				:Create(
					Image,
					Constants.DefaultTweenInfo,
					Icons.ResolveProperties(Image.ClassName, {
						IconTransparency = 0.5,
					})
				)
				:Play()
		end)

		if Callback then
			Button.MouseButton1Click:Connect(Callback)
		end

		return Button, Image
	end

	local function CreateTopSeparator(Order: number)
		Interface.New("ImageLabel", {
			LayoutOrder = Order,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			Parent = TopButtons,

			["Frame"] = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Size = UDim2.fromOffset(4, 4),
				Position = UDim2.fromScale(0.5, 0.5),

				["UICorner"] = {
					CornerRadius = UDim.new(1, 0),
				},
			},
		})
	end

	--// Right Side Layout \\--
	local TopButtonData = {}

	for _, ModalData in Modals do
		if typeof(ModalData) ~= "table" then
			continue
		end

		local TopButton = ModalData.TopButton
		if not TopButton or not ModalData.Frame then
			continue
		end

		table.insert(TopButtonData, {
			Type = "Button",
			Icon = TopButton.Icon,
			Order = TopButton.Order,
			Callback = function()
				if ModalData.Open then
					ModalData:Open()
				else
					Modals.Controller:Open(ModalData.Frame)
				end
			end,
		})
	end

	table.sort(TopButtonData, function(Left, Right)
		return (Left.Order or 0) < (Right.Order or 0)
	end)

	table.insert(TopButtonData, {
		Type = "Separator",
	})
	table.insert(TopButtonData, {
		Type = "Button",
		Icon = "minus",
		Callback = function()
			MainFrame.Visible = false
			ShowButton.Visible = true
		end,
	})
	table.insert(TopButtonData, {
		Type = "Button",
		Icon = "x",
		Callback = wax.shared.Unload,
	})

	for Order, Data in TopButtonData do
		if Data.Type == "Separator" then
			CreateTopSeparator(Order)
		else
			CreateTopButton(Data.Icon, Order, Data.Callback)
		end
	end

	Drag.Setup(MainFrame, TopBar, nil, {
		GetDPIScale = props.GetDPIScale,
	})
	local ShowButtonDrag = Drag.Setup(ShowButton, ShowButton, nil, {
		GetDPIScale = props.GetDPIScale,
	})
	ShowButton.MouseButton1Click:Connect(function()
		if ShowButtonDrag.Moved then
			return
		end
		ShowButton.Visible = false
		MainFrame.Visible = true
	end)

	return {
		TopBar = TopBar,
		TopButtons = TopButtons,
		CreateTopButton = CreateTopButton,
		CreateTopSeparator = CreateTopSeparator,
	}
end

end)() end,
    [151] = function()local wax,script,require,CreateLookupTable=ImportGlobals(151)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local AssetManager = require("@src/Utils/UI/Assets/Manager")

--// Constants \\--
local Constants = {}

Constants.MainUICorner = Interface.New("UICorner", {
	CornerRadius = UDim.new(0, 6),
})

Constants.DefaultTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Exponential)

Constants.InstanceClassImages = AssetManager.GetInstanceClassImages()

return Constants

end)() end,
    [153] = function()local wax,script,require,CreateLookupTable=ImportGlobals(153)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

local ModalController = require("@src/Window/Components/Modal")
local ContextMenu = require("@src/Window/Components/ContextMenu")

local CodeGen = require("@src/Utils/CodeGen/Generator")

--// Data \\--
local ArgumentList = require(script.Components.ArgumentList)
local CodeView = require(script.Components.CodeView)
local CreateDefaultFooterButtons = require(script.Components.FooterButtons)
local FunctionInfoView = require(script.Components.FunctionInfoView)

--// Setup \\--
local SetupModal = require(script.Shell)

--// UI \\--
return function(props: {
	ModalController: ModalController.Modal,
	ContextMenu: ContextMenu.ContextMenu,
	GetDPIScale: (() -> number)?,
	LogsPage: Types.LogsPage,
})
	--// Props \\--
	local ModalController = props.ModalController
	local ContextMenu = props.ContextMenu
	local LogsPage = props.LogsPage

	--// Setup \\--
	local Modal = SetupModal({
		ModalController = ModalController,
		ContextMenu = ContextMenu,
		GetDPIScale = props.GetDPIScale,
	})

	Modal.Footer.BuiltInButtons = CreateDefaultFooterButtons({
		Modal = Modal,
		ModalController = ModalController,
		LogsPage = LogsPage,
	})

	--// Tabs \\--

	--// Arguments \\--
	local ArgumentsInfoUI, ArgumentsScrollingFrame = Modal.Tabs:CreateTabContent()
	local ArgumentsInfoFrame
	do
		Modal.Tabs:CreateTab("ellipsis", "Arguments", ArgumentsInfoUI)
		ArgumentsScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

		ArgumentsInfoFrame = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),

			["UIListLayout"] = {
				Padding = UDim.new(0, 6),
			},

			Constants.MainUICorner,

			Parent = ArgumentsScrollingFrame,
		})
	end

	--// Original Args (Incoming RemoteFunction) \\--
	local OriginalArgsInfoUI, OriginalArgsScrollingFrame = Modal.Tabs:CreateTabContent()
	local OriginalArgsInfoFrame
	do
		Modal.Tabs:CreateTab("list", "Args", OriginalArgsInfoUI)
		OriginalArgsScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Modal.Tabs:SetMounted("Args", false)

		OriginalArgsInfoFrame = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),

			["UIListLayout"] = {
				Padding = UDim.new(0, 6),
			},

			Constants.MainUICorner,

			Parent = OriginalArgsScrollingFrame,
		})
	end

	--// Code \\--
	local CodeInfoUI, CodeScrollingFrame = Modal.Tabs:CreateTabContent()
	local CodeDisplay
	do
		Modal.Tabs:CreateTab("code", "Code", CodeInfoUI)
		CodeScrollingFrame.ScrollBarThickness = 3
		CodeScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None

		CodeDisplay = CodeView.new(CodeScrollingFrame)
	end

	--// Function Info \\--
	local FunctionInfoUI, FunctionScrollingFrame = Modal.Tabs:CreateTabContent()
	local FunctionInfoDisplay
	do
		Modal.Tabs:CreateTab("parentheses", "Function Info", FunctionInfoUI)

		FunctionInfoDisplay = FunctionInfoView.new(FunctionScrollingFrame)
	end

	--// Functions \\--
	function Modal:Open(CallInfo)
		--// Plugin Hooks \\--
		if wax.shared.CobaltPluginManager and wax.shared.CobaltPluginManager.Initialized then
			for _, Interceptor in wax.shared.CobaltPluginManager.Registry.UIHooks.RemoteInfo.Intercept do
				local Success, Result = pcall(Interceptor, CallInfo)

				if Success and Result == false then
					return
				end
			end
		end

		local Event = CallInfo.Instance

		--// Set Title \\--
		Modal.Title.Text = if CallInfo.Blocked then `{Event.Name} (Blocked)` else Event.Name
		Modal.Icon = Interface.SetIcon(Modal.Icon, Constants.InstanceClassImages[Event.ClassName])

		--// Set Current Info \\--
		Modal.CurrentInfo = CallInfo

		--// Set Code Text \\--
		CodeDisplay:SetText(CodeGen:BuildCallCode(CallInfo))

		--// Set Function Info Text \\--
		FunctionInfoDisplay:SetCallInfo(CallInfo)

		--// Populate Arguments & Return Data \\--
		local InitialDataView = (
			if CallInfo.Type == "Incoming" and CallInfo.InvokeResult then "InvokeResult" else "Arguments"
		)

		local FirstTab = Modal.Tabs[Modal.Tabs[1]]

		if FirstTab and FirstTab.TextLabel then
			FirstTab.TextLabel.Text = if InitialDataView == "InvokeResult" then "Return Data" else "Arguments"
		end

		--// Cleanup \\--
		ArgumentList.Clear(ArgumentsInfoFrame)
		ArgumentList.Clear(OriginalArgsInfoFrame)

		--// Populate Arguments \\--
		ArgumentList.Populate(ArgumentsInfoFrame, CallInfo[InitialDataView])

		local ShouldShowOriginalArgs = (
			InitialDataView == "InvokeResult" and wax.shared.GetTableLength(CallInfo.Arguments) > 0
		)

		Modal.Tabs:SetMounted("Args", ShouldShowOriginalArgs)
		if ShouldShowOriginalArgs then
			ArgumentList.Populate(OriginalArgsInfoFrame, CallInfo.Arguments)
		end

		--// Plugin Hooks \\--
		if wax.shared.CobaltPluginManager and wax.shared.CobaltPluginManager.Initialized then
			for _, Plugin in wax.shared.CobaltPluginManager.Registry.UIHooks.RemoteInfo.Open do
				task.spawn(Plugin, CallInfo)
			end
		end

		--// Select Arguments Tab \\--
		Modal.Tabs:Select("Arguments")

		if ContextMenu.CurrentContext then
			ContextMenu.CurrentContext.Close()
		end

		ModalController:Open(Modal.Frame)
	end

	return Modal
end

end)() end,
    [155] = function()local wax,script,require,CreateLookupTable=ImportGlobals(155)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")

local LazySerializer = require("@src/Window/Utils/Text/LazySerializer")
local SyntaxHighlighter = require("@src/Window/Utils/Text/Highlighter")
local TextBounds = require("@src/Window/Utils/Text/TextBounds")

local ArgumentList = {}

local DefaultPreviewMaxLength = 500

type HolderOptions = {
	IsBlockedCall: boolean?,
	IsError: boolean?,
	IsPreview: boolean?,
	Label: string?,
	MaxPreviewLength: number?,
	PreviewCache: { [number]: string }?,
}

local function TruncatePreviewText(Text: string, MaxLength: number): string
	local NormalizedText = Text:gsub("[\r\n\t]", " ")
	if #Text <= MaxLength then
		return NormalizedText
	end

	return NormalizedText:sub(1, MaxLength) .. "..."
end

function ArgumentList.CreatePreviewText(Value: any, MaxLength: number?): string
	MaxLength = MaxLength or DefaultPreviewMaxLength

	if typeof(Value) == "string" then
		return `"{TruncatePreviewText(Value, MaxLength)}"`
	end

	return TruncatePreviewText(tostring(LazySerializer.QuickSerializeArgument(Value)), MaxLength)
end

function ArgumentList.Clear(Frame: GuiObject)
	for _, Object in Frame:QueryDescendants("Frame") do
		Object:Destroy()
	end
end

function ArgumentList.CreateHolder(Index: number, Value: any, Parent: GuiObject, Options: HolderOptions | boolean?)
	if typeof(Options) ~= "table" then
		Options = {
			IsBlockedCall = Options,
		}
	end

	--// Variables \\--
	local IsBlockedCall = Options.IsBlockedCall
	local IsError = Options.IsError == true
	local PreviewCache = Options.PreviewCache
	local IsPreview = Options.IsPreview == true

	--// UI \\--
	local Holder = Interface.New("Frame", {
		BackgroundColor3 = if IsBlockedCall
			then Color3.fromRGB(58, 24, 24)
			else Color3.fromRGB(25, 25, 25),
		LayoutOrder = Index,
		Size = UDim2.new(1, 0, 0, 27),

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		},

		Parent = Parent,
	})

	local IndexLabel = Interface.New("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		Text = Options.Label or Index,
		TextColor3 = if IsBlockedCall or IsError then Color3.fromRGB(255, 190, 190) else Color3.new(1, 1, 1),
		TextSize = 15,
		TextTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,

		Parent = Holder,
	})
	local IndexX = TextBounds.GetCachedWidth(IndexLabel.Text, IndexLabel.FontFace, IndexLabel.TextSize)

	local TypeLabel = Interface.New("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		Text = typeof(Value),
		TextColor3 = if IsBlockedCall or IsError then Color3.fromRGB(255, 190, 190) else Color3.new(1, 1, 1),
		TextSize = 15,
		TextTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Top,

		Parent = Holder,
	})
	local TypeX = TextBounds.GetCachedWidth(TypeLabel.Text, TypeLabel.FontFace, TypeLabel.TextSize)

	local Text
	if IsPreview then
		if PreviewCache then
			if not PreviewCache[Index] then
				PreviewCache[Index] = ArgumentList.CreatePreviewText(Value, Options.MaxPreviewLength)
			end

			Text = PreviewCache[Index]
		else
			Text = ArgumentList.CreatePreviewText(Value, Options.MaxPreviewLength)
		end
	else
		Text = tostring(LazySerializer.QuickSerializeArgument(Value)):gsub("<", "&lt;"):gsub(">", "&gt;")
	end

	local TextLabel = Interface.New("TextLabel", {
		Position = UDim2.fromOffset(IndexX + 6, 0),
		Size = UDim2.new(1, -(IndexX + TypeX + 10), 1, 0),
		TextColor3 = if IsBlockedCall or IsError
			then Color3.fromRGB(255, 190, 190)
			else Color3.fromHex(SyntaxHighlighter.GetArgumentColor(Value)),
		Text = Text,
		RichText = not IsPreview,
		TextSize = 15,
		TextTruncate = if IsPreview then Enum.TextTruncate.AtEnd else Enum.TextTruncate.None,
		TextWrapped = not IsPreview,
		TextXAlignment = Enum.TextXAlignment.Left,

		Parent = Holder,
	})

	if not IsPreview then
		local _, TextY = TextBounds.Get(TextLabel.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
		Holder.Size = UDim2.new(1, 0, 0, TextY + 12)
	end

	return Holder
end

function ArgumentList.Populate(Frame: GuiObject, Values: { [any]: any }?)
	if not Values then
		return
	end

	for Index = 1, wax.shared.GetTableLength(Values) do
		if Index % 25 == 0 then
			task.wait()
		end

		ArgumentList.CreateHolder(Index, Values[Index], Frame)
	end
end

return ArgumentList

end)() end,
    [156] = function()local wax,script,require,CreateLookupTable=ImportGlobals(156)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local AssetManager = require("@src/Utils/UI/Assets/Manager")

local SyntaxHighlighter = require("@src/Window/Utils/Text/Highlighter")

--// Assets \\--
local IBMPlexMono = AssetManager.GetCustomFont("IBMPlexMono")
local LoadingText = SyntaxHighlighter.Run("-- Loading...")

local CodeView = {}
CodeView.__index = CodeView

function CodeView.new(Parent: ScrollingFrame)
	local self = setmetatable({
		Labels = {},
		Parent = Parent,
	}, CodeView)

	for Index = 1, 5 do
		self.Labels[Index] = Interface.New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 16,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = IBMPlexMono,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Text = "",
			Parent = Parent,
		})
	end

	return self
end

function CodeView:SetText(Code: string)
	for _, Label in self.Labels do
		Label.Text = ""
	end

	local Lines = SyntaxHighlighter.Run(Code):split("\n")
	local CurrentCharacterCount = 0
	local TextContents = {}
	local CurrentLabel = 1

	for _, Line in Lines do
		if CurrentCharacterCount + #Line > 200000 then
			CurrentLabel += 1
			CurrentCharacterCount = 0
			continue
		end

		CurrentCharacterCount += #Line
		if not TextContents[CurrentLabel] then
			TextContents[CurrentLabel] = {}
		end

		table.insert(TextContents[CurrentLabel], Line)
	end

	for Index, Content in TextContents do
		if not self.Labels[Index] then
			self.Labels[Index] = Interface.New("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 16,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				FontFace = IBMPlexMono,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Text = LoadingText,
				Parent = self.Parent,
			})
		end

		self.Labels[Index].Text = table.concat(Content, "\n")
	end
end

return CodeView

end)() end,
    [157] = function()local wax,script,require,CreateLookupTable=ImportGlobals(157)local ImportGlobals return (function(...)local CodeGen = require("@src/Utils/CodeGen/Generator")
local Types = require("@src/Window/Types")
local ModalController = require("@src/Window/Components/Modal")
local InstanceSerializer = require("@src/Utils/CodeGen/Serializer/Instance")
local LuaEncode = require("@src/Utils/CodeGen/Serializer/LuaEncode")

local function CopyToClipboard(Text: string, SuccessMessage: string, ErrorMessage: string)
	local Success, Error = pcall(setclipboard, Text)
	if Success then
		wax.shared.Sonner.success(SuccessMessage)
	else
		wax.shared.Sonner.error(ErrorMessage)
		warn(ErrorMessage, Error)
	end
end

return function(props: {
	Modal: {
		CurrentInfo: any?,
		[any]: any,
	},
	ModalController: ModalController.Modal,
	LogsPage: Types.LogsPage,
})
	local FooterButtons = {}

	local function GetCurrentInfo()
		return props.Modal.CurrentInfo
	end

	local function GetCurrentLog()
		return props.LogsPage.GetCurrentLog()
	end

	table.insert(FooterButtons, {
		Icon = "code",
		Title = "Code",
		Options = {
			{
				Text = "Calling Code",
				Icon = "forward",
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if not CurrentInfo then
						return
					end

					CopyToClipboard(
						CodeGen:BuildCallCode(CurrentInfo),
						"Copied code to clipboard",
						"Failed to copy code to clipboard"
					)
				end,
			},
			{
				Text = "Intercept Code",
				Icon = "shield-alert",
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if not CurrentInfo then
						return
					end

					CopyToClipboard(
						CodeGen:BuildHookCode(CurrentInfo),
						"Copied code to clipboard",
						"Failed to copy code to clipboard"
					)
				end,
			},
			{
				Text = "Function Info",
				Icon = "parentheses",
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if not CurrentInfo then
						return
					end

					local Info = {
						Function = typeof(CurrentInfo.Function) == "function"
								and {
									Name = CurrentInfo.Function and debug.info(CurrentInfo.Function, "n") or "Unknown",
									Source = CurrentInfo.Source
										or (CurrentInfo.Function and debug.info(CurrentInfo.Function, "s"))
										or "Unknown",
									Type = CurrentInfo.Function
											and (iscclosure(CurrentInfo.Function) and "C Closure" or "Luau function")
										or "N/A",
									Address = tostring(CurrentInfo.Function),
									Arguments = {
										wax.shared.SafePack.Unpack(
											CurrentInfo.Arguments,
											1,
											wax.shared.GetTableLength(CurrentInfo.Arguments)
										),
									},
								}
							or CurrentInfo.Function,
						Script = CurrentInfo.Origin,
						Line = CurrentInfo.Line,
					}

					if typeof(CurrentInfo.Function) == "function" and islclosure(CurrentInfo.Function) then
						local FunctionInfo = {
							Constants = debug.getconstants,
							Upvalues = debug.getupvalues,
							Protos = debug.getprotos,
						}

						for Type, Func in pairs(FunctionInfo) do
							if Func then
								Info.Function[Type] = Func(CurrentInfo.Function)
							end
						end
					end

					CopyToClipboard(
						`local Info = {LuaEncode(Info, { Prettify = true, DisableNilParentHandler = true })}`,
						"Copied function info to clipboard",
						"Failed to copy function info to clipboard"
					)
				end,
			},
		},
	})

	table.insert(FooterButtons, {
		Icon = "scroll-text",
		Title = "Origin",
		Options = {
			{
				Text = "Remote Path",
				Icon = "package-search",
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if not CurrentInfo then
						return
					end

					CopyToClipboard(
						InstanceSerializer.Serialize(CurrentInfo.Instance, {
							VariableName = "Event",
							DisableNilParentHandler = false,
						}),
						"Copied remote path to clipboard",
						"Failed to copy remote path to clipboard"
					)
				end,
			},
			{
				Text = "Script Path",
				Icon = "file-search",
				Condition = function()
					local CurrentInfo = GetCurrentInfo()
					return CurrentInfo and typeof(CurrentInfo.Origin) == "Instance"
				end,
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if not (CurrentInfo and typeof(CurrentInfo.Origin) == "Instance") then
						return
					end

					CopyToClipboard(
						InstanceSerializer.Serialize(CurrentInfo.Origin),
						"Copied script path to clipboard",
						"Failed to copy script path to clipboard"
					)
				end,
			},
			{
				Text = "Decompiled Script",
				Icon = "file-text",
				Condition = function()
					local CurrentInfo = GetCurrentInfo()
					return CurrentInfo and typeof(CurrentInfo.Origin) == "Instance" and typeof(decompile) == "function"
				end,
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if
						not (
							CurrentInfo
							and typeof(CurrentInfo.Origin) == "Instance"
							and typeof(decompile) == "function"
						)
					then
						return
					end

					local Decompiled, Result = pcall(decompile, CurrentInfo.Origin)
					if Decompiled then
						CopyToClipboard(
							Result,
							"Copied decompiled script to clipboard",
							"Failed to copy decompiled script to clipboard"
						)
					else
						wax.shared.Sonner.error("Failed to decompile script")
						warn("Failed to decompile script", Result)
					end
				end,
			},
		},
	})

	table.insert(FooterButtons, {
		Icon = "network",
		Title = "Event",
		Options = {
			{
				Text = "Replay",
				Icon = "play",
				Callback = function()
					local CurrentInfo = GetCurrentInfo()
					if not CurrentInfo then
						return
					end

					wax.shared.Sonner.promise(function()
						CodeGen:ReplayCallInfo(CurrentInfo)
					end, {
						loadingText = "Replaying event...",
						successText = "Replayed event successfully!",
						errorText = "Failed to replay event",
						time = 4.5,
					})
				end,
			},
			{
				Text = function()
					local CurrentLog = GetCurrentLog()
					return CurrentLog and (CurrentLog.Ignored and "Unignore" or "Ignore") or "Ignore"
				end,
				Icon = function()
					local CurrentLog = GetCurrentLog()
					return CurrentLog and (CurrentLog.Ignored and "eye" or "eye-off") or "eye"
				end,
				Callback = function()
					local CurrentLog = GetCurrentLog()
					if not CurrentLog then
						return
					end

					CurrentLog:Ignore()
					wax.shared.Sonner.success(`{CurrentLog.Ignored and "Started" or "Stopped"} ignoring event`)
				end,
			},
			{
				Text = function()
					local CurrentLog = GetCurrentLog()
					return CurrentLog and (CurrentLog.Blocked and "Unblock" or "Block") or "Block"
				end,
				Icon = function()
					local CurrentLog = GetCurrentLog()
					return CurrentLog and (CurrentLog.Blocked and "lock" or "lock-open") or "lock"
				end,
				Callback = function()
					local CurrentLog = GetCurrentLog()
					if not CurrentLog then
						return
					end

					CurrentLog:Block()

					local BlockedRemoteList = wax.shared.Settings["BlockedRemotes"]
					if BlockedRemoteList then
						if CurrentLog.Blocked then
							BlockedRemoteList:AddToList(CurrentLog)
						else
							BlockedRemoteList:RemoveFromList(CurrentLog)
						end
					end

					wax.shared.Sonner.success(`{CurrentLog.Blocked and "Started" or "Stopped"} blocking event`)
				end,
			},
			{
				Text = "Clear Logs",
				Icon = "trash",
				Callback = function()
					local CurrentLog = GetCurrentLog()
					if not CurrentLog then
						return
					end

					props.LogsPage.ClearLogs(CurrentLog.Instance, CurrentLog.Type)
					props.ModalController:Close()
				end,
			},
		},
	})

	return FooterButtons
end

end)() end,
    [158] = function()local wax,script,require,CreateLookupTable=ImportGlobals(158)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local AssetManager = require("@src/Utils/UI/Assets/Manager")

local CodeGen = require("@src/Utils/CodeGen/Generator")

--// Assets \\--
local IBMPlexMono = AssetManager.GetCustomFont("IBMPlexMono")

local FunctionInfoView = {}
FunctionInfoView.__index = FunctionInfoView

function FunctionInfoView.new(Parent: ScrollingFrame)
	return setmetatable({
		Text = Interface.New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 16,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			FontFace = IBMPlexMono,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Text = "",
			Parent = Parent,
		}),
	}, FunctionInfoView)
end

function FunctionInfoView:SetCallInfo(CallInfo)
	xpcall(function()
		self.Text.Text = CodeGen:BuildFunctionInfo(CallInfo)
	end, function(Error)
		self.Text.Text = table.concat({
			"Error while fetching function data.",
			`Calling Function: {CallInfo.Function} (type: {typeof(CallInfo.Function)})`,
			`\n\nError: {Error}`,
		}, "\n")
	end)
end

return FunctionInfoView

end)() end,
    [159] = function()local wax,script,require,CreateLookupTable=ImportGlobals(159)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")

local ModalController = require("@src/Window/Components/Modal")
local ContextMenu = require("@src/Window/Components/ContextMenu")

local Resize = require("@src/Window/Utils/Input/Resize")

return function(props: {
	ModalController: ModalController.Modal,
	ContextMenu: ContextMenu.ContextMenu,
	GetDPIScale: (() -> number)?,
})
	local ModalController = props.ModalController
	local ContextMenu = props.ContextMenu

	local Modal = {
		CurrentInfo = nil,
		Footer = {
			BuiltInButtons = {},
		},
		Tabs = {
			CurrentTab = nil,
		},
	}

	--// UI \\--
	local LeftGradient

	local InfoFrame = Interface.New("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.65, 0.712),
		Text = "",
		Visible = false,
		Parent = ModalController.Background,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 8),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},
	})
	do
		--// Right Gradient \\--
		Interface.New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -6, 0, 44),
			Size = UDim2.new(0, 30, 0, 36),
			BackgroundColor3 = Color3.fromRGB(10, 10, 10),
			BorderSizePixel = 0,
			ZIndex = 10,
			Parent = InfoFrame,

			["UIGradient"] = {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
			},
		})

		--// Left Gradient \\--
		LeftGradient = Interface.New("Frame", {
			Position = UDim2.new(0, 4, 0, 44),
			Size = UDim2.new(0, 30, 0, 36),
			BackgroundColor3 = Color3.fromRGB(10, 10, 10),
			BorderSizePixel = 0,
			ZIndex = 10,
			Visible = false,
			Parent = InfoFrame,

			["UIGradient"] = {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			},
		})

		Resize.new({
			MainFrame = InfoFrame,

			MaximumSize = UDim2.new(1, -2, 1, -2),
			MinimumSize = UDim2.fromScale(0.65, 0.712),
			Mirrored = true,
			LockedPosition = true,

			CornerHandleSize = 20,
			HandleSize = 6,
			GetDPIScale = props.GetDPIScale,
		})
	end

	--// Modal Top \\--
	local InfoTitle, InfoIcon = ModalController:CreateTop("...", Constants.InstanceClassImages["RemoteEvent"], InfoFrame)
	do
		Modal.Frame = InfoFrame
		Modal.Title = InfoTitle
		Modal.Icon = InfoIcon
		Modal.Controller = ModalController
		Modal.Background = ModalController.Background
	end

	--// Tabs Scrolling Frame \\--
	local TabsScroller: ScrollingFrame = Interface.New("ScrollingFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 4, 0, 44),
		Size = UDim2.new(1, -10, 0, 36),
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ClipsDescendants = true,
		Parent = InfoFrame,
	})
	do
		--// Left Gradient \\--
		TabsScroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			LeftGradient.Visible = TabsScroller.CanvasPosition.X > 2
		end)
	end

	--// Tabs Container \\--
	local InfoTabs = Interface.New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromScale(0, 1),
		Parent = TabsScroller,

		["UIListLayout"] = {
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		},

		["UIPadding"] = {
			PaddingRight = UDim.new(0, 20),
			PaddingTop = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
		},
	})
	Modal.TabsContainer = InfoTabs

	--// Footer \\--
	local InfoButtons = Interface.New("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 6, 1, -7),
		Size = UDim2.new(1, -12, 0, 32),
		Parent = InfoFrame,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 6),
		},
	})
	Modal.Footer.Frame = InfoButtons

	--// Functions \\--
	--[[
        Creates a dropdown button for the footer.

        @param Icon: The icon of the button.
        @param Title: The title of the button.
        @param Options: The options for the button.
        @return: The button.
    ]]
	function Modal.Footer:CreateDropdownButton(Icon: string, Title: string, Options: {})
		local Button = Interface.New("TextButton", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0, 1),
			Text = "",

			["UICorner"] = {
				CornerRadius = UDim.new(0, 6),
			},

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
			},

			["UIStroke"] = {
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},

			["TextLabel"] = {
				Text = Title,
				TextSize = 15,
				Size = UDim2.fromScale(0, 1),
				Position = UDim2.fromOffset(28, 0),
				AutomaticSize = Enum.AutomaticSize.X,
			},

			Parent = InfoButtons,
		})

		Interface.NewIcon(Icon, {
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,

			Parent = Button,
		})

		local Menu = ContextMenu:Create(Button, Options)

		Button.MouseEnter:Connect(function()
			wax.shared.TweenService
				:Create(Button, Constants.DefaultTweenInfo, {
					BackgroundTransparency = 0,
				})
				:Play()
		end)
		Button.MouseLeave:Connect(function()
			wax.shared.TweenService
				:Create(Button, Constants.DefaultTweenInfo, {
					BackgroundTransparency = 1,
				})
				:Play()
		end)
		Button.MouseButton1Click:Connect(Menu.Toggle)
		return Button
	end

	--[[
        Updates the dropdown buttons in the footer.
    ]]
	function Modal.Footer:UpdateDropdownButtons()
		for _, Element in InfoButtons:GetChildren() do
			if Element:IsA("TextButton") then
				Element.Parent = nil
			end
		end

		local PluginManager = wax.shared.CobaltPluginManager
		local PluginTabRegistry = PluginManager
				and PluginManager.Registry.UIHooks.RemoteInfo.Tabs[Modal.Tabs.CurrentTab]
			or nil

		local DidPluginDisableDefaults = (PluginTabRegistry and PluginTabRegistry.DisableDefaults)

		local PluginButtons = (PluginTabRegistry and PluginTabRegistry.Buttons)

		if not DidPluginDisableDefaults then
			for _, ButtonDef in self.BuiltInButtons do
				if not ButtonDef.Instance then
					ButtonDef.Instance = self:CreateDropdownButton(ButtonDef.Icon, ButtonDef.Title, ButtonDef.Options)
				end
				ButtonDef.Instance.Parent = InfoButtons
			end
		end

		if PluginButtons then
			for _, ButtonDef in PluginButtons do
				if not ButtonDef.Instance then
					ButtonDef.Instance = self:CreateDropdownButton(ButtonDef.Icon, ButtonDef.Title, ButtonDef.Options)
				end
				ButtonDef.Instance.Parent = InfoButtons
			end
		end
	end

	--[[
        Selects a tab.

        @param Title: The title of the tab to select.
    ]]
	function Modal.Tabs:Select(Title: string)
		if not self[Title] then
			return
		end

		for _, TabName in ipairs(self) do
			local Tab = self[TabName]
			local IsSelected = TabName == Title and Tab.TabButton.Parent ~= nil
			local ButtonColor = if IsSelected then Color3.fromRGB(25, 25, 25) else Color3.fromRGB(0, 0, 0)

			Tab.TabButton.BackgroundColor3 = ButtonColor
			Tab.TabButton.Frame.BackgroundColor3 = ButtonColor

			if Tab.TabContents then
				Tab.TabContents.Visible = IsSelected
			end
		end

		self.CurrentTab = Title
		Modal.Footer:UpdateDropdownButtons()
	end

	--[[
        Creates a tab for the modal.

        @param Icon: The icon of the tab.
        @param Title: The title of the tab.
        @param TabContents: The contents of the tab.
        @return: The tab.
    ]]
	function Modal.Tabs:CreateTab(Icon: string, Title: string, TabContents: Frame?)
		if not self.CurrentTab then
			self.CurrentTab = Title
		end

		local IsTabSelected = self.CurrentTab == Title

		if TabContents then
			TabContents.Parent = InfoFrame
			TabContents.Visible = IsTabSelected
		end

		local ButtonColor = IsTabSelected and Color3.fromRGB(25, 25, 25) or Color3.fromRGB(0, 0, 0)
		local TabButton = Interface.New("TextButton", {
			BackgroundColor3 = ButtonColor,
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = #self,
			Text = "",
			Parent = InfoTabs,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 8),
			},

			["UIStroke"] = {
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},

			["Frame"] = {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromScale(1, 0.5),
				BackgroundColor3 = ButtonColor,
			},
		})

		local TextWrapper = Interface.New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 24),
			Parent = TabButton,

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 5),
			},

			["UIPadding"] = {
				PaddingRight = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
			},
		})

		local TabLabel = Interface.New("TextLabel", {
			Text = Title,
			TextSize = 15,
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 2,
			ZIndex = 2,

			Parent = TextWrapper,
		})

		Interface.NewIcon(Icon, {
			Position = UDim2.fromOffset(8, 5),
			Size = UDim2.fromOffset(16, 16),
			LayoutOrder = 1,
			ZIndex = 2,

			Parent = TextWrapper,
		})

		self[Title] = {
			TabButton = TabButton,
			TabContents = TabContents,
			TextLabel = TabLabel,
		}
		table.insert(self, Title)

		wax.shared.Connect(TabButton.MouseButton1Click:Connect(function()
			self:Select(Title)
		end))
	end

	--[[
        Creates the content container for a tab.

        @return: The container and scrolling frame.
    ]]
	function Modal.Tabs:CreateTabContent()
		local Container = Interface.New("Frame", {
			Position = UDim2.fromOffset(6, 71),
			Size = UDim2.new(1, -12, 1, -118),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),

			["UICorner"] = {
				CornerRadius = UDim.new(0, 6),
			},

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
			},

			["UIStroke"] = {
				Color = Color3.fromRGB(25, 25, 25),
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},
		})

		return Container,
			Interface.New("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarThickness = 0,
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				ScrollingDirection = Enum.ScrollingDirection.XY,
				Parent = Container,
			})
	end

	--[[
        Sets the mounted state of a tab.

        @param Title: The title of the tab.
        @param Mounted: Whether the tab should be mounted.
    ]]
	function Modal.Tabs:SetMounted(Title: string, Visible: boolean)
		local Tab = self[Title]
		if not Tab then
			return
		end

		Tab.TabButton.Parent = if Visible then InfoTabs else nil
		if not Visible and Tab.TabContents then
			Tab.TabContents.Visible = false
		end

		if Visible or self.CurrentTab ~= Title then
			return
		end
		
		for _, TabName in self do
			if TabName == Title or self[TabName].TabButton.Parent == nil then
				continue
			end
			
			self:Select(TabName)
			break
		end
	end

	return Modal
end

end)() end,
    [160] = function()local wax,script,require,CreateLookupTable=ImportGlobals(160)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")

local ModalController = require("@src/Window/Components/Modal")
local SettingsBuilder = require("@src/Window/Components/Modal/Builder/Settings")
local Resize = require("@src/Window/Utils/Input/Resize")

--// Setup \\--
local function SetupModal(ModalController: ModalController.Modal, GetDPIScale: () -> number)
	local PluginsFrame = Interface.New("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0.65, 0, 0, 285),
		Text = "",
		Visible = false,
		Parent = ModalController.Background,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 8),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},
	})

	Resize.new({
		MainFrame = PluginsFrame,

		MaximumSize = UDim2.new(1, -2, 1, -2),
		MinimumSize = UDim2.fromScale(0.65, 0.712),
		Mirrored = true,
		LockedPosition = true,

		CornerHandleSize = 20,
		HandleSize = 6,
		GetDPIScale = GetDPIScale,
	})

	ModalController:CreateTop("Plugins", "blocks", PluginsFrame)

	local PluginsScrollingFrame = Interface.New("ScrollingFrame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 1, -37),
		ClipsDescendants = true,
		ScrollBarThickness = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		Parent = PluginsFrame,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 15),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
		},
	})

	return PluginsFrame, PluginsScrollingFrame
end

--// UI \\--
return function(props: {
	ModalController: ModalController.Modal,
	SettingsBuilder: SettingsBuilder.Builder,
	GetDPIScale: () -> number,
})
	--// Props \\--
	local ModalController = props.ModalController
	local SettingsBuilder = props.SettingsBuilder
	local GetDPIScale = props.GetDPIScale

	--// Setup \\--
	local _PluginsFrame, PluginsScrollingFrame = SetupModal(ModalController, GetDPIScale)

	local PluginSettings = SettingsBuilder.new(PluginsScrollingFrame)
	local PluginsSection = PluginSettings:CreateSection("Plugins")

	--// Actual UI \\--
	local HeaderLabel = PluginsSection.Parent:FindFirstChildWhichIsA("TextLabel")
	local SummaryLabel = Interface.New("TextLabel", {
		Text = `<font transparency="0.5">Waiting for plugins...</font>`,
		RichText = true,
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		Parent = HeaderLabel,
	})

	-- Container that holds all per-plugin cards
	local PluginCardsContainer = Interface.New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Parent = PluginsSection.Parent,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 5),
		},
	})

	local function CreatePluginCard(IsError: boolean, Title: string, Meta: string, Body: string)
		local AccentColor = IsError and Color3.fromRGB(220, 55, 55) or Color3.fromRGB(55, 185, 100)

		local Card = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(18, 18, 18),
			Size = UDim2.fromScale(1, 0),
			Parent = PluginCardsContainer,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 6),
			},

			["UIStroke"] = {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(35, 35, 35),
				Thickness = 1,
			},
		})

		-- Left accent bar
		Interface.New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = AccentColor,
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 3, 1, -8),
			BorderSizePixel = 0,
			Parent = Card,
		})

		local Content = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			Parent = Card,

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 7),
				PaddingBottom = UDim.new(0, 7),
			},

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 2),
			},
		})

		-- Title row: name + badge
		local TitleRow = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			Parent = Content,

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 6),
			},
		})

		Interface.New("TextLabel", {
			Text = Title,
			RichText = false,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Parent = TitleRow,
		})

		-- Status badge (only shown for errors)
		if IsError then
			local Badge = Interface.New("Frame", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = AccentColor,
				BackgroundTransparency = 0.75,
				LayoutOrder = 2,
				Parent = TitleRow,

				["UICorner"] = {
					CornerRadius = UDim.new(1, 0),
				},

				["UIPadding"] = {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					PaddingTop = UDim.new(0, 2),
					PaddingBottom = UDim.new(0, 2),
				},
			})

			Interface.New("TextLabel", {
				Text = "ERROR",
				Font = Enum.Font.GothamBold,
				TextColor3 = AccentColor,
				TextSize = 10,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Parent = Badge,
			})
		end

		-- Meta line (version · author  OR  file path)
		if Meta ~= "" then
			Interface.New("TextLabel", {
				Text = Meta,
				RichText = false,
				Font = Enum.Font.Gotham,
				TextColor3 = Color3.fromRGB(160, 160, 160),
				TextSize = 12,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Parent = Content,
			})
		end

		-- Body (description or error message)
		if Body ~= "" then
			Interface.New("TextLabel", {
				Text = Body,
				RichText = false,
				Font = Enum.Font.Gotham,
				TextColor3 = IsError and Color3.fromRGB(210, 120, 120) or Color3.fromRGB(140, 140, 140),
				TextSize = 12,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Parent = Content,
			})
		end
	end

	task.spawn(function()
		while not wax.shared.CobaltPluginManager or not wax.shared.CobaltPluginManager.Initialized do
			task.wait()
		end

		local Registry = wax.shared.CobaltPluginManager.Registry
		local LoadedCount = #Registry.Plugins
		local ErrorCount = #Registry.Errored

		-- Update summary label
		local SummaryParts = {}
		if LoadedCount > 0 then
			table.insert(SummaryParts, `<font color="#37b964"><b>{LoadedCount}</b></font> loaded`)
		end
		if ErrorCount > 0 then
			table.insert(SummaryParts, `<font color="#dc3737"><b>{ErrorCount}</b></font> errored`)
		end
		if #SummaryParts == 0 then
			table.insert(SummaryParts, `<font transparency="0.5">No plugins installed.</font>`)
		end
		SummaryLabel.RichText = true
		SummaryLabel.Text = table.concat(SummaryParts, `<font transparency="0.6"> · </font>`)

		-- Errored plugins first (most actionable)
		for _, ErrorInfo in Registry.Errored do
			local FileName = string.match(ErrorInfo.FilePath, "([^/]+)$") or ErrorInfo.FilePath
			local Title = ErrorInfo.Name or FileName
			local Meta = if ErrorInfo.Name
				then `v{ErrorInfo.Version or "1.0.0"}  ·  by {ErrorInfo.Author or "Unknown"}  ·  {FileName}`
				else ErrorInfo.FilePath
			CreatePluginCard(true, Title, Meta, ErrorInfo.Error)
		end

		-- Loaded plugins
		for _, PluginInfo in Registry.Plugins do
			local Data = PluginInfo.PluginData
			local Name = Data.Name or "Unknown"
			local Version = Data.Version or "1.0.0"
			local Author = Data.Author or "Unknown"
			local Desc = Data.Description or "No description."
			CreatePluginCard(false, Name, `v{Version}  ·  by {Author}`, Desc)
		end
	end)

	return {
		Frame = _PluginsFrame,
		ScrollingFrame = PluginsScrollingFrame,
		Settings = PluginSettings,
		TopButton = {
			Icon = "blocks",
			Order = 1,
		},
	}
end

end)() end,
    [161] = function()local wax,script,require,CreateLookupTable=ImportGlobals(161)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

local ModalController = require("@src/Window/Components/Modal")

--// Constants \\--
local SearchableClasses = {
	"RemoteEvent",
	"UnreliableRemoteEvent",
	"RemoteFunction",
	"BindableEvent",
	"BindableFunction",
}

--// Setup \\--
local function SetupModal(ModalController: ModalController.Modal)
	local SearchFrame = Interface.New("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0.5, 0, 0.8, 0),
		Text = "",
		Visible = false,
		Parent = ModalController.Background,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 6),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},
	})

	local SearchTop = Interface.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 36),
		Parent = SearchFrame,

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		},
	})

	local SearchBox: TextBox = Interface.New("TextBox", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -30, 1, 0),
		PlaceholderText = "Search for logs...",
		TextXAlignment = Enum.TextXAlignment.Left,
		PlaceholderColor3 = Color3.fromRGB(127, 127, 127),
		Text = "",
		TextSize = 17,
		Parent = SearchTop,
	})

	local SearchCloseButton = Interface.New("ImageButton", {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(1, 0),
		AnchorPoint = Vector2.new(1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Parent = SearchTop,
	})

	local SearchCloseImage = Interface.NewIcon("x", {
		IconTransparency = 0.5,
		Size = UDim2.fromOffset(22, 22),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,

		Parent = SearchCloseButton,
	})

	ModalController:ConnectCloseButton(SearchCloseButton, SearchCloseImage)

	Interface.New("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.fromOffset(0, 36),
		Parent = SearchFrame,
	})

	local SearchFilterList = Interface.New("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarThickness = 2,
		Position = UDim2.fromOffset(0, 37),
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Parent = SearchFrame,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		},
	})

	local FilterAllButton = Interface.New("TextButton", {
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		TextSize = 15,
		Text = "All",
		Parent = SearchFilterList,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
		},
	})

	Interface.New("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.fromOffset(0, 72),
		Parent = SearchFrame,
	})

	local SearchResults = Interface.New("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Position = UDim2.fromOffset(0, 73),
		ScrollBarThickness = 3,
		Size = UDim2.new(1, 0, 1, -73),

		Parent = SearchFrame,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.Name,
		},

		["UIPadding"] = {
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
		},
	})

	return SearchFrame, SearchBox, SearchFilterList, FilterAllButton, SearchResults
end

--// UI \\--
return function(props: {
	ModalController: ModalController.Modal,
	LogsPage: Types.LogsPage,
})
	--// Props \\--
	local ModalController = props.ModalController
	local LogsPage = props.LogsPage

	--// State \\--
	local Search = {
		ResultInfo = {},
		CurrentResults = {},
		SelectedResult = -1,
		ExcludedClasses = {},
		ResultByLog = setmetatable({}, { __mode = "k" }),
	}

	--// Setup \\--
	local SearchFrame, SearchBox, SearchFilterList, FilterAllButton, SearchResults = SetupModal(ModalController)
	local SearchFilterButtons = {}

	--// Functions \\--
	local function SelectResult(NewResult: number, UpdateCanvasPosition: boolean?)
		if Search.SelectedResult > 0 and Search.CurrentResults[Search.SelectedResult] then
			Search.CurrentResults[Search.SelectedResult].BackgroundTransparency = 1
		end

		if NewResult == -1 or #Search.CurrentResults == 0 then
			Search.SelectedResult = -1
			return
		end

		Search.SelectedResult = math.clamp(NewResult, 1, #Search.CurrentResults)
		Search.CurrentResults[Search.SelectedResult].BackgroundTransparency = 0

		if not UpdateCanvasPosition then
			return
		end

		local ScrollSize = SearchResults.AbsoluteSize.Y
		local SelectedMin = Search.CurrentResults[Search.SelectedResult].AbsolutePosition.Y
			- SearchResults.AbsolutePosition.Y
		local SelectedMax = SelectedMin + Search.CurrentResults[Search.SelectedResult].AbsoluteSize.Y

		if SelectedMin < 0 then
			SearchResults.CanvasPosition += Vector2.new(0, SelectedMin - 6)
		elseif SelectedMax > ScrollSize then
			SearchResults.CanvasPosition += Vector2.new(0, SelectedMax - ScrollSize + 6)
		end
	end

	local function EnterResult(ResultIndex: number)
		local Result = Search.CurrentResults[ResultIndex]
		local Info = Result and Search.ResultInfo[Result]
		if not Info then
			ModalController:Close()
			return
		end

		LogsPage.ShowLog(Info.Log)
		ModalController:Close()
	end

	local function CreateSearchResult(RemoteInstance: Instance, Type: string)
		local SearchResult = Interface.New("TextButton", {
			BackgroundColor3 = Color3.fromRGB(25, 25, 25),
			BackgroundTransparency = 1,
			Name = RemoteInstance.Name,
			Size = UDim2.new(1, 0, 0, 36),
			Text = "",

			["UICorner"] = {
				CornerRadius = UDim.new(0, 6),
			},

			["UIPadding"] = {
				PaddingBottom = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 6),
			},

			["TextLabel"] = {
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Text = RemoteInstance.Name,
				TextSize = 17,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
		})

		SearchResult.MouseEnter:Connect(function()
			local Index = table.find(Search.CurrentResults, SearchResult)
			if Index then
				SelectResult(Index)
			end
		end)

		SearchResult.MouseButton1Click:Connect(function()
			local Index = table.find(Search.CurrentResults, SearchResult)
			if Index then
				EnterResult(Index)
			end
		end)

		Interface.New("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Constants.InstanceClassImages[RemoteInstance.ClassName],
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Parent = SearchResult,
		})

		Interface.New("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			Text = Type,
			TextSize = 15,
			TextTransparency = 0.5,
			TextXAlignment = Enum.TextXAlignment.Right,

			Parent = SearchResult,
		})

		return SearchResult
	end

	local function HandleSearch(Text: string, Type: string)
		for _, Log in pairs(wax.shared.Logs[Type]) do
			local RemoteInstance = Log.Instance
			local SearchResult = Search.ResultByLog[Log]
			if not SearchResult then
				SearchResult = CreateSearchResult(RemoteInstance, Type)
				Search.ResultByLog[Log] = SearchResult
				Search.ResultInfo[SearchResult] = {
					Type = Type,
					Log = Log,
				}
			end

			local LoweredName = string.lower(RemoteInstance.Name)
			if
				Text ~= "" and not LoweredName:find(Text, 1, true)
				or table.find(Search.ExcludedClasses, RemoteInstance.ClassName)
			then
				SearchResult.Parent = nil
				continue
			end

			SearchResult.BackgroundTransparency = 1
			SearchResult.Parent = SearchResults
			table.insert(Search.CurrentResults, SearchResult)
		end
	end

	function Search:Update()
		table.clear(self.CurrentResults)
		SelectResult(-1)

		local Text = string.lower(SearchBox.Text)
		HandleSearch(Text, "Outgoing")
		HandleSearch(Text, "Incoming")

		if #self.CurrentResults == 0 then
			return
		end

		table.sort(self.CurrentResults, function(Left, Right)
			return Left.AbsolutePosition.Y < Right.AbsolutePosition.Y
		end)

		SelectResult(1, true)
	end

	function Search:Open()
		ModalController:Open(SearchFrame)
		self:Update()
		SearchBox:CaptureFocus()
	end

	--// Events \\--
	FilterAllButton.MouseButton1Click:Connect(function()
		table.clear(Search.ExcludedClasses)
		FilterAllButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

		for _, Button in SearchFilterButtons do
			Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		end

		Search:Update()
	end)

	for Order, ClassName in SearchableClasses do
		local ClassNameFilterButton = Interface.New("TextButton", {
			BackgroundColor3 = Color3.fromRGB(25, 25, 25),
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 15,
			Text = "",
			LayoutOrder = Order,
			Parent = SearchFilterList,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 4),
			},

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 0),
				PaddingBottom = UDim.new(0, 0),
			},

			["UIListLayout"] = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 6),
			},

			["TextLabel"] = {
				LayoutOrder = 1,
				Text = ClassName,
				TextSize = 15,
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
			},
		})

		Interface.New("ImageLabel", {
			Image = Constants.InstanceClassImages[ClassName],
			Size = UDim2.new(1, -8, 1, -8),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromOffset(0.5, 0),
			Parent = ClassNameFilterButton,
		})

		ClassNameFilterButton.MouseButton1Click:Connect(function()
			local FoundIndex = table.find(Search.ExcludedClasses, ClassName)
			if FoundIndex then
				table.remove(Search.ExcludedClasses, FoundIndex)
				ClassNameFilterButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				if #Search.ExcludedClasses == 0 then
					FilterAllButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				end

				Search:Update()
				return
			end

			table.insert(Search.ExcludedClasses, ClassName)
			ClassNameFilterButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			FilterAllButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			Search:Update()
		end)

		table.insert(SearchFilterButtons, ClassNameFilterButton)
	end

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		Search:Update()
	end)

	wax.shared.Connect(wax.shared.UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Input.KeyCode == Enum.KeyCode.K and wax.shared.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			Search:Open()
			return
		end

		if ModalController.OpenedModal ~= SearchFrame then
			return
		end

		if Input.KeyCode == Enum.KeyCode.Escape then
			ModalController:Close()
		elseif Input.KeyCode == Enum.KeyCode.Return then
			EnterResult(Search.SelectedResult)
		elseif Input.KeyCode == Enum.KeyCode.Up then
			SelectResult(Search.SelectedResult - 1, true)
		elseif Input.KeyCode == Enum.KeyCode.Down then
			SelectResult(Search.SelectedResult + 1, true)
		end
	end))

	Search.Frame = SearchFrame
	Search.TopButton = {
		Icon = "search",
		Order = 0,
	}

	return Search
end

end)() end,
    [162] = function()local wax,script,require,CreateLookupTable=ImportGlobals(162)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Types = require("@src/Window/Types")

local ModalController = require("@src/Window/Components/Modal")
local SettingsBuilder = require("@src/Window/Components/Modal/Builder/Settings")

local Resize = require("@src/Window/Utils/Input/Resize")
local DPI = require("@src/Window/Utils/DPI")

--// Data \\--
local AnticheatData = require("@src/Utils/Anticheats/Main")
local Session = require("@src/Utils/CodeGen/Serializer/Session")
local Settings = require("@src/Utils/Settings")

local FilterResetSettings = {
	Settings.IgnoredRemotesDropdown,
	Settings.AutoIgnoreSpammyEvents,
	Settings.IgnorePlayerModule,
	Settings.ShowExecutorLogs,
}

--// Setup \\--
local function SetupModal(ModalController: ModalController.Modal, GetDPIScale: () -> number)
	local SettingsFrame = Interface.New("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0.65, 0, 0, 285),
		Text = "",
		Visible = false,
		Parent = ModalController.Background,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 8),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(25, 25, 25),
			Thickness = 1,
		},
	})

	Resize.new({
		MainFrame = SettingsFrame,

		MaximumSize = UDim2.new(1, -2, 1, -2),
		MinimumSize = UDim2.fromScale(0.65, 0.712),
		Mirrored = true,
		LockedPosition = true,

		CornerHandleSize = 20,
		HandleSize = 6,
		GetDPIScale = GetDPIScale,
	})

	ModalController:CreateTop("Settings", "settings", SettingsFrame)

	local SettingsScrollingFrame = Interface.New("ScrollingFrame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 1, -37),
		ClipsDescendants = true,
		ScrollBarThickness = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		Parent = SettingsFrame,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 15),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
		},
	})

	return SettingsFrame, SettingsScrollingFrame
end

local function CreateDetectionNotice(Parent: GuiObject, Window: Types.Window)
	local FailedChecks = wax.shared.ExecutorSupport.FailedChecks
	local DetectionRiskFailures = FailedChecks and FailedChecks.DetectionRisk
	if not DetectionRiskFailures or #DetectionRiskFailures == 0 then
		return
	end

	local WarningDisplay = Interface.New("TextButton", {
		Text = "",
		BackgroundColor3 = Color3.fromRGB(245, 60, 54),
		BackgroundTransparency = 0.82,
		Size = UDim2.new(1, 0, 0, 32),
		Parent = Parent,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIStroke"] = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(245, 60, 54),
			Thickness = 1,
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
		},
	})

	Interface.New("TextLabel", {
		Text = `⚠  <b>Detection risk</b> · {#DetectionRiskFailures} unsupported {if #DetectionRiskFailures == 1
			then "check"
			else "checks"}`,
		TextSize = 14,
		Size = UDim2.new(1, -82, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = WarningDisplay,
	})

	Interface.New("TextLabel", {
		Text = "View details",
		TextSize = 13,
		TextTransparency = 0.25,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, 76, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = WarningDisplay,
	})

	WarningDisplay.MouseButton1Click:Connect(function()
		Window.Dialogs.DetectionRisk.Open(Window, DetectionRiskFailures)
	end)
end

--// UI \\--
return function(props: {
	ModalController: ModalController.Modal,
	SettingsBuilder: SettingsBuilder.Builder,
	DPIHandler: DPI.DPI,
	PaginationManager: Types.PaginationManager,
	LogsPage: Types.LogsPage,
	Window: Types.Window,
})
	--// Props \\--
	local ModalController = props.ModalController
	local SettingsBuilder = props.SettingsBuilder
	local DPIHandler = props.DPIHandler
	local PaginationManager = props.PaginationManager
	local LogsPage = props.LogsPage
	local Window = props.Window

	local function GetDPIScale()
		return DPIHandler:GetDPIScale()
	end

	--// Setup \\--
	local SettingsFrame, SettingsScrollingFrame = SetupModal(ModalController, GetDPIScale)

	local MainSettings = SettingsBuilder.new(SettingsScrollingFrame)
	if not wax.shared.IsUsingRakNetHooks then
		CreateDetectionNotice(SettingsScrollingFrame, Window)
	end

	--// General Section \\--
	local GeneralSection = MainSettings:CreateSection("General")
	do
		Settings.WindowDPIScale:SetupOption(GeneralSection, {
			Callback = DPIHandler:CreateDPIScaleChangedCallback(),
		})

		PaginationManager:BindPagination({
			Component = Settings.CallsPerPage:SetupOption(GeneralSection),

			PaginationKey = "ItemsPerPage",
			Refresh = LogsPage.RefreshCurrentLog,
		})

		Settings.ExecuteOnTeleport:SetupOption(GeneralSection)

		GeneralSection:AddSpacer()
		GeneralSection:CreateButton("Clear Captured Calls", function()
			Window.Dialogs.ClearCapturedCalls.Open(Window, LogsPage.ClearLogs)
		end)
	end

	--// Capture Section \\--
	local CaptureSection = MainSettings:CreateSection("Capture")
	do
		Settings.RakNetHooks:SetupOption(CaptureSection, {
			PreSetCallback = function(value)
				return not value or Window.Dialogs.RakNet.ConfirmEnable(Window)
			end,
		})

		Settings.OthHooks:SetupOption(CaptureSection, {
			PreSetCallback = function(value)
				return Window.Dialogs.Oth.Confirm(Window, value)
			end,
		})

		Settings.LogRobloxInternalEvents:SetupOption(CaptureSection)
		Settings.LogActors:SetupOption(CaptureSection)
		Settings.LogBlockedRemotes:SetupOption(CaptureSection)
	end

	--// Filter Section \\--
	local FilterSection = MainSettings:CreateSection("Filtering")
	do
		Settings.IgnoredRemotesDropdown:SetupOption(FilterSection)
		Settings.AutoIgnoreSpammyEvents:SetupOption(FilterSection)
		Settings.IgnorePlayerModule:SetupOption(FilterSection)

		Settings.ShowExecutorLogs:SetupOption(FilterSection, {
			Text = `Show {wax.shared.ExecutorName} Calls`,
			Callback = LogsPage.RefreshCurrentLog,
		})

		FilterSection:CreateButton("Reset Filtering Preferences", function()
			for _, Setting in FilterResetSettings do
				wax.shared.Settings[Setting.Key]:Reset()
			end

			wax.shared.Sonner.success("Successfully reset remote filtering to default")
		end)
	end

	--// Call Filters Section \\--
	local CallFiltersSection = MainSettings:CreateSection("Call Filters")
	do
		CallFiltersSection:CreateCallFilterList({
			Manager = wax.shared.CallFilters,
			OnEdit = function(Filter: Types.CallFilter)
				Window.Dialogs.CallFilter.Open(Window, {
					Filter = Filter,
					OnSave = function(Value)
						wax.shared.CallFilters:Update(Filter.Id, Value)
						wax.shared.Sonner.success("Call filter updated")
					end,
				})
			end,
			OnDuplicate = function(Filter: Types.CallFilter)
				wax.shared.CallFilters:Add({
					Enabled = Filter.Enabled,
					Target = Filter.Target,
					Direction = Filter.Direction,
					Conditions = Filter.Conditions,
					Action = Filter.Action,
				})
				wax.shared.Sonner.success("Call filter duplicated")
			end,
			OnDelete = function(Filter: Types.CallFilter)
				Window.Dialogs.DeleteCallFilter.Open(Window, Filter)
			end,
		})
	end

	--// Remotes Filtering Section \\--
	local IgnoredRemotesSection = MainSettings:CreateSection("Ignored Remotes")
	do
		IgnoredRemotesSection:CreateRemoteList("IgnoredRemotes", {
			NullMessage = "No remotes have been ignored yet.",
			Callback = function(Log)
				Log.Ignored = false
			end,
		})
	end

	local BlockedRemotesSection = MainSettings:CreateSection("Blocked Remotes")
	do
		BlockedRemotesSection:CreateRemoteList("BlockedRemotes", {
			NullMessage = "No remotes have been blocked yet.",
			Callback = function(Log)
				Log.Blocked = false
				Log:SetConnectionsEnabled(true)
			end,
		})
	end

	--// Code Generation Section \\--
	local CodeGenSection = MainSettings:CreateSection("Code Generation")
	do
		Settings.InstancePathLookupChain:SetupOption(CodeGenSection)
		Settings.EventReferenceStrategy:SetupOption(CodeGenSection)
		Settings.PreferBufferFromString:SetupOption(CodeGenSection)
		Settings.ShowWatermark:SetupOption(CodeGenSection)
	end

	--// File Logging Section \\--
	local LoggingSection = MainSettings:CreateSection("File Logging")
	do
		local SessionLogLabel

		Settings.EnableLogging:SetupOption(LoggingSection, {
			Callback = function(value)
				if not value then
					wax.shared.LogConnection:Disconnect()
					wax.shared.LogConnection = nil
					wax.shared.LogFileName = nil

					SessionLogLabel.Text = `Current Log File: <b>Not Logging</b>`
					wax.shared.Sonner.success("Successfully disabled file logging")
					return
				end

				local LogConnection = wax.shared.SetupLoggingConnection()
				SessionLogLabel.Text = `Current Log File: <b>{wax.shared.LogFileName:gsub("Cobalt/Logs/", "")}</b>`
				wax.shared.LogConnection = wax.shared.Connect(wax.shared.Communicator.Event:Connect(LogConnection))

				wax.shared.Sonner.success("Successfully enabled file logging")
			end,
		})

		SessionLogLabel = LoggingSection:AddLabel(
			`Current Log File: <b>{wax.shared.Settings.EnableLogging.Value and wax.shared.LogFileName:gsub(
				"Cobalt/Logs/",
				""
			) or "Not Logging"}</b>`
		)

		LoggingSection:AddLabel(`Log Folder: <b>Cobalt/Logs</b>`)

		--// Session Buttons Row \\--
		LoggingSection:AddSpacer()
		local SessionButtons = LoggingSection:CreateRow()
		do
			local CopySessionName = SessionButtons:CreateButton("Copy File Name", function()
				if not wax.shared.Settings.EnableLogging.Value then
					wax.shared.Sonner.error("File logging is not enabled")
					return
				end

				local ActualLogFileName = wax.shared.LogFileName:gsub("Cobalt/Logs/", "")
				local Success, Error = pcall(setclipboard, ActualLogFileName)

				if not Success then
					warn(Error)
					wax.shared.Sonner.error("Failed to copy session name")
					return
				end

				wax.shared.Sonner.success("Successfully copied session name to clipboard")
			end, 14)
			CopySessionName.Size = UDim2.new(0.5, -4, 0, 24)

			local CopyFullSessionPath = SessionButtons:CreateButton("Copy File Path", function()
				if not wax.shared.Settings.EnableLogging.Value then
					wax.shared.Sonner.error("File logging is not enabled")
					return
				end

				local Success, Error = pcall(setclipboard, wax.shared.LogFileName)

				if not Success then
					warn(Error)
					wax.shared.Sonner.error("Failed to copy log path")
					return
				end

				wax.shared.Sonner.success("Successfully copied log path to clipboard")
			end, 14)
			CopyFullSessionPath.Size = UDim2.new(0.5, -4, 0, 24)
		end

		LoggingSection:CreateButton("Export Session as HTML", function()
			wax.shared.Sonner.promise(function(UpdateProgress)
				assert(typeof(writefile) == "function", "Exploit does not support writefile")

				--// Collect all logs \\--
				local AllCalls = Session:FetchAllLogs()
				local SessionData = Session:GetSessionData(AllCalls)

				--// Data Processing \\--
				UpdateProgress("Sorting calls...")
				Session:SortCalls(AllCalls)
				local Events, StringMap = Session:ProcessCalls(AllCalls, SessionData, UpdateProgress)

				--// Export \\--
				local FileName = `Cobalt_Session_{os.time()}.html`
				writefile(FileName, Session:ExportSessionToHTML(Events, StringMap, SessionData))
				return FileName
			end, {
				loadingText = "Starting Export...",
				successText = function(fileName)
					return `Successfully exported trace to {fileName}`
				end,
				errorText = function(err)
					return `Export Failed: {err}`
				end,
			})
		end, 14)
	end

	--// Compatibility & Safety Section \\--
	local CompatibilitySection = MainSettings:CreateSection("Compatibility & Safety")
	do
		CompatibilitySection:AddLabel(`Executor: <b>{wax.shared.ExecutorName}</b>`)
		CompatibilitySection:AddLabel(
			`Support: {#wax.shared.ExecutorSupport.FailedChecks.Essential == 0 and "<b>Full</b>" or "<b>Partial</b> (" .. #wax.shared.ExecutorSupport.FailedChecks.Essential .. " check(s) failed)"}`
		)

		if #wax.shared.ExecutorSupport.FailedChecks.Essential > 0 then
			local PartialSupportDetails = {}
			for _, Name in wax.shared.ExecutorSupport.FailedChecks.Essential do
				table.insert(
					PartialSupportDetails,
					`❌ <b><font color="#ff0000">{Name}</font></b> · <font size="14" transparency="0.5">{wax.shared.ExecutorSupport[Name].Details}</font>`
				)
			end

			CompatibilitySection:AddLabel(table.concat(PartialSupportDetails, "\n"), 14)
		end

		Settings.DisableNonEssentialChecks:SetupOption(CompatibilitySection)
		Settings.AnticheatBypass:SetupOption(CompatibilitySection)
		CompatibilitySection:AddLabel("These options take effect the next time Cobalt launches.", 13).TextTransparency =
			0.5

		if AnticheatData.Disabled then
			CompatibilitySection:AddLabel(`Detected Anti-Cheat: <b>{AnticheatData.Name}</b>`, 14)
		end
	end

	--// About & Credits Section \\--
	local CreditsSection = MainSettings:CreateSection("About & Credits")
	CreditsSection:AddLabel("Cobalt and the open-source projects that make it possible.", 14).TextTransparency = 0.35
	CreditsSection:AddSpacer()
	CreditsSection:CreateButton("View Credits", function()
		Window.Dialogs.Credits.Open(Window)
	end)

	return {
		Frame = SettingsFrame,
		ScrollingFrame = SettingsScrollingFrame,
		Settings = MainSettings,
		TopButton = {
			Icon = "settings",
			Order = 2,
		},
	}
end

end)() end,
    [163] = function()local wax,script,require,CreateLookupTable=ImportGlobals(163)local ImportGlobals return (function(...)export type SupportedRemoteTypes = RemoteEvent | RemoteFunction | BindableEvent | BindableFunction | UnreliableRemoteEvent

export type LogDirection = "Outgoing" | "Incoming"

export type LogButton = {
	Instance: TextButton,
	Name: TextLabel,
	Calls: TextLabel,
}

export type Log = {
	Instance: SupportedRemoteTypes,
	Type: LogDirection,
	Index: number,
	
	Calls: { any },
	GameCalls: { number },

	SpamWindowStart: number,
	SpamCallCount: number,

	Ignored: boolean,
	Blocked: boolean,
	Button: LogButton?,

	Ignore: (any) -> (),
	Block: (any) -> (),
	ClearCalls: (any) -> (),
	ShouldBlock: (any, any) -> boolean,
	Call: (any, any) -> number?,
	SetButton: (any, TextButton, TextLabel, TextLabel) -> (),
	SetConnectionsEnabled: (any, boolean) -> (),
}

export type LogsState = {
	SelectedPageByLog: { [Log]: number },
	CurrentLog: Log?,
}

export type LogsPage = {
	State: LogsState,
	LogList: any?,
	LogCalls: any?,
	CleanLogsList: () -> (),
	ShowLog: (Log?) -> (),
	ClearLogs: (Instance?, LogDirection?) -> (),
	GetCurrentLog: () -> Log?,
	RefreshCurrentLog: () -> (),
}

export type DialogDismissBehavior = "Dismiss" | "Destroy"

export type QueryFilterOperator =
	"Equals"
	| "NotEquals"
	| "LessThan"
	| "LessThanOrEqual"
	| "GreaterThan"
	| "GreaterThanOrEqual"
	| "Contains"
	| "StartsWith"
	| "EndsWith"
	| "TypeIs"
export type QueryFilterJoin = "And" | "Or"
export type QueryFilterAction = "Ignore" | "Block" | "Highlight"
export type QueryFilterDirection = LogDirection | "Any"

export type QueryFilterSubject =
	{ Type: "Argument", Index: number }
	| { Type: "ArgumentCount" }

export type QueryBuilderCondition = {
	Subject: QueryFilterSubject,
	Operator: QueryFilterOperator,
	Value: any,
	Join: QueryFilterJoin?,
}

export type QueryRemoteField = "Name" | "ClassName" | "FullName"
export type QueryRemoteCondition = {
	Field: QueryRemoteField,
	Operator: QueryFilterOperator,
	Value: string,
	Join: QueryFilterJoin?,
}

export type QueryRemoteTarget =
	{ Type: "Instance", Remote: SupportedRemoteTypes }
	| { Type: "Query", Conditions: { QueryRemoteCondition } }

export type QueryBuilderValue = {
	Target: QueryRemoteTarget,
	Direction: QueryFilterDirection,
	Conditions: { QueryBuilderCondition },
	Action: QueryFilterAction,
}

export type CallFilter = QueryBuilderValue & {
	Id: string,
	Enabled: boolean,
}

export type CallFilterManager = {
	GetAll: (CallFilterManager) -> { CallFilter },
	Get: (CallFilterManager, string) -> CallFilter?,
	Add: (CallFilterManager, QueryBuilderValue | CallFilter) -> CallFilter,
	Update: (CallFilterManager, string, { [string]: any }) -> CallFilter?,
	SetEnabled: (CallFilterManager, string, boolean) -> CallFilter?,
	Remove: (CallFilterManager, string) -> boolean,
	ReplaceAll: (CallFilterManager, { CallFilter }, boolean?) -> (),
	Subscribe: (CallFilterManager, ({ CallFilter }) -> ()) -> { Disconnect: (any) -> () },
	Match: (
		CallFilterManager,
		SupportedRemoteTypes,
		LogDirection,
		{ [number]: any }
	) -> (QueryFilterAction?, CallFilter?),
	Resolve: (CallFilterManager, SupportedRemoteTypes, LogDirection, any) -> (QueryFilterAction?, CallFilter?),
}

export type QueryBuilderProps = {
	Target: QueryRemoteTarget,
	Direction: QueryFilterDirection,
	SampleRemote: SupportedRemoteTypes?,
	ArgumentLabels: { [number]: string }?,
	Conditions: { QueryBuilderCondition }?,
	Action: QueryFilterAction?,
	OnChanged: ((QueryBuilderValue) -> ())?,
	OnValidationChanged: ((boolean, { string }) -> ())?,
}

export type QueryBuilder = {
	Root: Frame,
	Target: QueryRemoteTarget,
	Conditions: { QueryBuilderCondition },
	Direction: QueryFilterDirection,
	Action: QueryFilterAction,
	Destroyed: boolean,
	IsValid: boolean,
	ValidationErrors: { string },

	GetValue: (QueryBuilder) -> QueryBuilderValue,
	Validate: (QueryBuilder) -> (boolean, { string }),
	AddCondition: (QueryBuilder, QueryBuilderCondition?) -> QueryBuilderCondition,
	RemoveCondition: (QueryBuilder, number) -> (),
	SetAction: (QueryBuilder, QueryFilterAction) -> (),
	Destroy: (QueryBuilder) -> (),
}

export type QueryBuilderClass = {
	new: (Dialog, QueryBuilderProps) -> QueryBuilder,
}

export type Dialog = {
	DialogId: number,
	DismissBehavior: DialogDismissBehavior,
	IsOpen: boolean,
	Destroyed: boolean,
	Root: Frame,
	Overlay: TextButton,
	Container: CanvasGroup,
	Scale: UIScale,
	CloseButton: GuiButton,
	Header: {
		TitleLabel: TextLabel,
		DescriptionLabel: TextLabel,
		HeaderIcon: GuiObject,
	},
	MainContent: Frame,
	Buttons: { [string]: DialogButton },
	Footer: {
		CreateButton: any,
		UI: Frame,
	},
	Show: (Dialog) -> (),
	Dismiss: (Dialog, DialogDismissBehavior?) -> Tween?,
	Destroy: (Dialog) -> (),
}

export type DialogFooterAction = "Dismiss" | ((Dialog) -> ())

export type DialogButton = {
	Instance: ImageButton,
	Label: TextLabel,
	Icon: GuiObject,
	Disabled: boolean,

	SetDisabled: (DialogButton, boolean) -> (),
}

export type DialogFooterButton = {
	Type: ("Primary" | "Secondary")?,
	Text: string?,
	Icon: string?,
	Action: DialogFooterAction?,
	Disabled: boolean?,
	HoldDuration: number?,
	LayoutOrder: number?,
}

export type DialogProps = {
	Title: string,
	TitleColor: Color3?,
	Description: string,
	Icon: string?,
	Footer: { [number | string]: DialogFooterButton },

	AutoShow: boolean?,
	DismissBehavior: DialogDismissBehavior?,
}

export type DialogClass = {
	new: (DialogProps) -> Dialog,
}

export type Window = {
	Dialog: DialogClass,
	QueryBuilder: QueryBuilderClass,
	Dialogs: { [string]: any },
	Logs: LogsPage?,
	Modals: { [string]: any },
}

export type PaginationData = {
	TotalItems: number,
	ItemsPerPage: number?,
	CurrentPage: number?,
	SiblingCount: number?,
}

export type PaginationDataKey = keyof<PaginationData>

export type PaginationBinding = {
	Component: any,
	PaginationKey: PaginationDataKey,
	Refresh: (() -> ())?,
}

export type PaginationManager = {
	Helper: any,

	GetInfo: (any) -> any,
	SetOption: (any, PaginationDataKey, any) -> (),
	SetItemsPerPage: (any, number) -> (),
	GetIndexRanges: (any, number?) -> (number, number),
	SetPage: (any, number) -> (),
	Update: (any, number?, number?) -> (),
	GetVisualInfo: (any, number?) -> { any },
	BindPagination: (any, PaginationBinding) -> (),
}

export type LogDirectionTab = {
	Name: LogDirection,
	Logs: { [Instance]: Log },
	Instance: TextButton,
}

return {}

end)() end,
    [165] = function()local wax,script,require,CreateLookupTable=ImportGlobals(165)local ImportGlobals return (function(...)local Animations = {
	TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Exponential),
	Exclusions = {},
	Expectations = { In = {}, Out = {} },
}

local function GetTransparencyProperty(object)
	if table.find(Animations.Exclusions, object) then
		return nil
	end

	if object:IsA("TextButton") or object:IsA("TextLabel") or object:IsA("TextBox") then
		return { "TextTransparency" }
	elseif object:IsA("CanvasGroup") then
		return { "GroupTransparency" }
	elseif object:IsA("Frame") then
		return { "BackgroundTransparency" }
	elseif object:IsA("ScrollingFrame") then
		return { "ScrollBarImageTransparency" }
	elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
		return { "ImageTransparency", "BackgroundTransparency" }
	elseif object:IsA("UIStroke") then
		return { "Transparency" }
	end

	return nil
end

local function BuildPropertyTable(properties, type, object)
	if Animations.Expectations[type][object] then
		return Animations.Expectations[type][object]
	end

	local propTable = {}
	for _, prop in properties do
		propTable[prop] = type == "In" and 0 or 1
	end
	return propTable
end

function Animations.FadeOut(object, time)
	local tweenInfo = time and TweenInfo.new(time, Enum.EasingStyle.Exponential) or Animations.TweenInfo
	local properties = GetTransparencyProperty(object)

	if not properties then
		return
	end

	wax.shared.TweenService:Create(object, tweenInfo, BuildPropertyTable(properties, "Out", object)):Play()

	if object:IsA("CanvasGroup") then
		return
	end

	for _, child in object:GetDescendants() do
		local prop = GetTransparencyProperty(child)
		if not prop then
			continue
		end

		wax.shared.TweenService:Create(child, tweenInfo, BuildPropertyTable(prop, "Out", child)):Play()
	end
end

function Animations.FadeIn(object, time)
	local tweenInfo = time and TweenInfo.new(time, Enum.EasingStyle.Exponential) or Animations.TweenInfo
	local property = GetTransparencyProperty(object)

	if property then
		wax.shared.TweenService:Create(object, tweenInfo, BuildPropertyTable(property, "In", object)):Play()
	end

	if object:IsA("CanvasGroup") then
		return
	end

	for _, child in object:GetDescendants() do
		local prop = GetTransparencyProperty(child)
		if not prop then
			continue
		end

		wax.shared.TweenService:Create(child, tweenInfo, BuildPropertyTable(prop, "In", child)):Play()
	end
end

function Animations.AddFadeExclusion(object)
	local prop = GetTransparencyProperty(object)
	if not prop then
		return
	end

	table.insert(Animations.Exclusions, object)
end

function Animations.AddFadeExclusions(objects)
	for _, object in objects do
		local prop = GetTransparencyProperty(object)
		if not prop then
			continue
		end

		table.insert(Animations.Exclusions, object)
	end
end

function Animations.SetFadeExpectation(type: "In" | "Out", object: GuiBase2d, properties: { [string]: any })
	if not Animations.Expectations[type] then
		return
	end

	Animations.Expectations[type][object] = properties
end

return Animations

end)() end,
    [166] = function()local wax,script,require,CreateLookupTable=ImportGlobals(166)local ImportGlobals return (function(...)local DPI = {}
export type DPI = typeof(DPI)
DPI.__index = DPI

function DPI.new(data: {
    Scale: UIScale,
    SaveKey: string,
})
    local self = setmetatable({
        Scale = data.Scale,
        SaveKey = data.SaveKey,
    }, DPI)

    self.Scale.Scale = self:GetDPIScale()

    return self
end

function DPI:GetDPIScale()
	local Scale = wax.shared.SaveManager:GetState(self.SaveKey)
	return (tonumber(Scale:sub(1, #Scale - 1)) or 100) / 100
end

function DPI:CreateDPIScaleChangedCallback()
    return function()
        self.Scale.Scale = self:GetDPIScale()
    end
end

return DPI

end)() end,
    [168] = function()local wax,script,require,CreateLookupTable=ImportGlobals(168)local ImportGlobals return (function(...)local Drag = {
	Dragging = false,
	Frame = nil,
	FramePosition = nil,
	FrameSize = nil, -- Added to store initial frame size
	StartPosition = nil,
	ChangedConnection = nil,
	Callback = nil,
	GetDPIScale = nil,
	Gesture = nil,
}

local InputUtils = require(script.Parent.Input)

local function GetDPIScale()
	if Drag.GetDPIScale then
		return Drag.GetDPIScale()
	end

	return 1
end

local function DefaultCallback(_, Input: InputObject)
	local Delta = Input.Position - Drag.StartPosition
	local FramePosition: UDim2 = Drag.FramePosition

	Delta = Delta / GetDPIScale()

	Drag.Frame.Position = UDim2.new(
		FramePosition.X.Scale,
		FramePosition.X.Offset + Delta.X,
		FramePosition.Y.Scale,
		FramePosition.Y.Offset + Delta.Y
	)
end

function Drag.Setup(
	Frame: GuiObject,
	DragFrame: GuiObject,
	Callback: ((Info: {}, Input: InputObject) -> ())?,
	Options: {
		GetDPIScale: (() -> number)?,
	}?
)
	Callback = Callback or DefaultCallback
	Options = Options or {}
	local Gesture = { Moved = false }

	DragFrame.InputBegan:Connect(function(Input: InputObject)
		if not InputUtils.IsClickInput(Input) then
			return
		end

		Drag.Dragging = true
		Gesture.Moved = false
		Drag.Gesture = Gesture
		Drag.Frame = Frame
		Drag.FramePosition = Frame.Position
		Drag.StartPosition = Input.Position
		Drag.FrameSize = Frame.Size
		Drag.Callback = Callback
		Drag.GetDPIScale = Options.GetDPIScale

		Drag.ChangedConnection = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			Drag.Dragging = false
			Drag.Frame = nil
			Drag.Callback = nil
			Drag.GetDPIScale = nil

			if Drag.ChangedConnection and Drag.ChangedConnection.Connected then
				Drag.ChangedConnection:Disconnect()
				Drag.ChangedConnection = nil
			end
		end)
	end)

	return Gesture
end

wax.shared.Connect(wax.shared.UserInputService.InputChanged:Connect(function(Input: InputObject)
	if Drag.Dragging and Drag.Callback and InputUtils.IsMoveInput(Input) then
		if (Input.Position - Drag.StartPosition).Magnitude > 6 then
			Drag.Gesture.Moved = true
		end
		Drag.Callback(Drag, Input)
	end
end))

return Drag

end)() end,
    [169] = function()local wax,script,require,CreateLookupTable=ImportGlobals(169)local ImportGlobals return (function(...)local Input = {}

function Input.IsMouseOverFrame(Frame: GuiObject, Position: Vector3): boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Position.X >= AbsPos.X
		and Position.X <= AbsPos.X + AbsSize.X
		and Position.Y >= AbsPos.Y
		and Position.Y <= AbsPos.Y + AbsSize.Y
end

function Input.IsClickInput(InputObject: InputObject): boolean
	return InputObject.UserInputState == Enum.UserInputState.Begin
		and (
			InputObject.UserInputType == Enum.UserInputType.MouseButton1
			or InputObject.UserInputType == Enum.UserInputType.Touch
		)
end

function Input.IsMoveInput(InputObject: InputObject): boolean
	return InputObject.UserInputState == Enum.UserInputState.Change
		and (
			InputObject.UserInputType == Enum.UserInputType.MouseMovement
			or InputObject.UserInputType == Enum.UserInputType.Touch
		)
end

return Input

end)() end,
    [170] = function()local wax,script,require,CreateLookupTable=ImportGlobals(170)local ImportGlobals return (function(...)local Resize = {}
Resize.__index = Resize

local Interface = require("@src/Utils/UI/Interface")
local Drag = require(script.Parent.Drag)

local HANDLE_SIZE = 6
local CORNER_HANDLE_SIZE = 20

function Resize.new(Options: {
	MainFrame: Frame,
	MinimumSize: Vector2? | UDim2?,
	MaximumSize: UDim2?,
	HandleSize: number?,
	CornerHandleSize: number?,
	Mirrored: boolean?,
	LockedPosition: boolean? | UDim2?,
	GetDPIScale: (() -> number)?,
})
	local MainFrame = Options.MainFrame
	local HandleSize = Options.HandleSize or HANDLE_SIZE
	local CornerHandleSize = Options.CornerHandleSize or CORNER_HANDLE_SIZE
	local Mirrored = Options.Mirrored or false
	local LockedPosition = Options.LockedPosition
	local GetDPIScale = Options.GetDPIScale or function()
		return 1
	end

	local MinimumSize
	if typeof(Options.MinimumSize) == "Vector2" then
		MinimumSize = UDim2.fromOffset(Options.MinimumSize.X, Options.MinimumSize.Y)
	elseif typeof(Options.MinimumSize) == "UDim2" then
		MinimumSize = Options.MinimumSize
	else
		MinimumSize = UDim2.fromOffset(100, 100)
	end

	local MaximumSize = Options.MaximumSize

	local self = setmetatable({
		MainFrame = MainFrame,
		ScreenGui = MainFrame:FindFirstAncestorOfClass("ScreenGui"),
		Parent = MainFrame.Parent,
	}, Resize)

	local function CalculateResizeProperties(
		initialFramePosition: UDim2,
		initialFrameSize: UDim2,
		mouseDelta: Vector2,
		resizeTypeX: string?,
		resizeTypeY: string?
	)
		if Mirrored then
			local parentAbsSize = self.Parent.AbsoluteSize

			local newSizeOffsetX = initialFrameSize.X.Offset
			local newSizeOffsetY = initialFrameSize.Y.Offset

			if resizeTypeX then
				local deltaX = 0
				if resizeTypeX == "Right" then
					deltaX = 2 * mouseDelta.X
				elseif resizeTypeX == "Left" then
					deltaX = -2 * mouseDelta.X
				end
				newSizeOffsetX = initialFrameSize.X.Offset + deltaX

				local minWidthAbs = MinimumSize.X.Scale * parentAbsSize.X + MinimumSize.X.Offset
				local maxWidthAbs = (MaximumSize and (MaximumSize.X.Scale * parentAbsSize.X + MaximumSize.X.Offset))
					or math.huge
				local scaleContributionX = initialFrameSize.X.Scale * parentAbsSize.X
				local minAllowedTotalOffsetX = minWidthAbs - scaleContributionX
				local maxAllowedTotalOffsetX = maxWidthAbs - scaleContributionX
				newSizeOffsetX = math.clamp(newSizeOffsetX, minAllowedTotalOffsetX, maxAllowedTotalOffsetX)
			end

			if resizeTypeY then
				local deltaY = 0
				if resizeTypeY == "Bottom" then
					deltaY = 2 * mouseDelta.Y
				elseif resizeTypeY == "Top" then
					deltaY = -2 * mouseDelta.Y
				end
				newSizeOffsetY = initialFrameSize.Y.Offset + deltaY

				local minHeightAbs = MinimumSize.Y.Scale * parentAbsSize.Y + MinimumSize.Y.Offset
				local maxHeightAbs = (MaximumSize and (MaximumSize.Y.Scale * parentAbsSize.Y + MaximumSize.Y.Offset))
					or math.huge
				local scaleContributionY = initialFrameSize.Y.Scale * parentAbsSize.Y
				local minAllowedTotalOffsetY = minHeightAbs - scaleContributionY
				local maxAllowedTotalOffsetY = maxHeightAbs - scaleContributionY
				newSizeOffsetY = math.clamp(newSizeOffsetY, minAllowedTotalOffsetY, maxAllowedTotalOffsetY)
			end

			local finalNewSize =
				UDim2.new(initialFrameSize.X.Scale, newSizeOffsetX, initialFrameSize.Y.Scale, newSizeOffsetY)
			local finalNewPosition = initialFramePosition
			if typeof(LockedPosition) == "UDim2" then
				finalNewPosition = LockedPosition
			end
			return finalNewSize, finalNewPosition
		else
			-- Non-mirrored logic
			local currentScreenGuiAbsSize = self.ScreenGui.AbsoluteSize
			local parentAbsSizeForMinMax = currentScreenGuiAbsSize -- As per original non-mirrored logic for min/max context

			-- These will store the final UDim offset values for position and the absolute pixel values for size calculation
			local finalPosOffsetX = initialFramePosition.X.Offset
			local finalPosOffsetY = initialFramePosition.Y.Offset

			-- Initial absolute pixel size of the frame
			local initialAbsWidthPx = initialFrameSize.X.Scale * self.Parent.AbsoluteSize.X + initialFrameSize.X.Offset
			local initialAbsHeightPx = initialFrameSize.Y.Scale * self.Parent.AbsoluteSize.Y + initialFrameSize.Y.Offset

			local newAbsWidthPx = initialAbsWidthPx
			local newAbsHeightPx = initialAbsHeightPx

			-- Min/max pixel dimensions
			local minWidthPx = MinimumSize.X.Scale * parentAbsSizeForMinMax.X + MinimumSize.X.Offset
			local minHeightPx = MinimumSize.Y.Scale * parentAbsSizeForMinMax.Y + MinimumSize.Y.Offset
			local maxWidthPx = MaximumSize and (MaximumSize.X.Scale * parentAbsSizeForMinMax.X + MaximumSize.X.Offset)
				or math.huge
			local maxHeightPx = MaximumSize and (MaximumSize.Y.Scale * parentAbsSizeForMinMax.Y + MaximumSize.Y.Offset)
				or math.huge

			-- Original edge calculation logic (assuming MainFrame.Position is center if AnchorPoint is 0.5,0.5 for these calcs)
			local initialAbsCenterX = currentScreenGuiAbsSize.X * initialFramePosition.X.Scale
				+ initialFramePosition.X.Offset
			local initialAbsSizeX_forEdgeCalc = initialFrameSize.X.Offset -- Original code used offset for this part of edge calculation
			local initialRightEdgeX = initialAbsCenterX + initialAbsSizeX_forEdgeCalc / 2
			local initialLeftEdgeX = initialAbsCenterX - initialAbsSizeX_forEdgeCalc / 2

			local initialAbsCenterY = currentScreenGuiAbsSize.Y * initialFramePosition.Y.Scale
				+ initialFramePosition.Y.Offset
			local initialAbsSizeY_forEdgeCalc = initialFrameSize.Y.Offset -- Original code used offset for this part of edge calculation
			local initialBottomEdgeY = initialAbsCenterY + initialAbsSizeY_forEdgeCalc / 2
			local initialTopEdgeY = initialAbsCenterY - initialAbsSizeY_forEdgeCalc / 2

			if resizeTypeX then
				if resizeTypeX == "Left" then
					local newLeftEdge = initialLeftEdgeX + mouseDelta.X
					newAbsWidthPx = math.clamp(initialRightEdgeX - newLeftEdge, minWidthPx, maxWidthPx)
					if newAbsWidthPx ~= (initialRightEdgeX - newLeftEdge) then -- Readjust edge if clamped
						newLeftEdge = initialRightEdgeX - newAbsWidthPx
					end
					if not LockedPosition then
						local newAbsCenterX = newLeftEdge + newAbsWidthPx / 2 -- Assuming center is halfway for position update
						finalPosOffsetX = newAbsCenterX - currentScreenGuiAbsSize.X * initialFramePosition.X.Scale
					end
				elseif resizeTypeX == "Right" then
					local newRightEdge = initialRightEdgeX + mouseDelta.X
					newAbsWidthPx = math.clamp(newRightEdge - initialLeftEdgeX, minWidthPx, maxWidthPx)
					if not LockedPosition then
						local newAbsCenterX = initialLeftEdgeX + newAbsWidthPx / 2 -- Assuming center is halfway
						finalPosOffsetX = newAbsCenterX - currentScreenGuiAbsSize.X * initialFramePosition.X.Scale
					end
				end
			end

			if resizeTypeY then
				if resizeTypeY == "Top" then
					local newTopEdge = initialTopEdgeY + mouseDelta.Y
					newAbsHeightPx = math.clamp(initialBottomEdgeY - newTopEdge, minHeightPx, maxHeightPx)
					if newAbsHeightPx ~= (initialBottomEdgeY - newTopEdge) then -- Readjust edge if clamped
						newTopEdge = initialBottomEdgeY - newAbsHeightPx
					end
					if not LockedPosition then
						local newAbsCenterY = newTopEdge + newAbsHeightPx / 2 -- Assuming center is halfway
						finalPosOffsetY = newAbsCenterY - currentScreenGuiAbsSize.Y * initialFramePosition.Y.Scale
					end
				elseif resizeTypeY == "Bottom" then
					local newBottomEdge = initialBottomEdgeY + mouseDelta.Y
					newAbsHeightPx = math.clamp(newBottomEdge - initialTopEdgeY, minHeightPx, maxHeightPx)
					if not LockedPosition then
						local newAbsCenterY = initialTopEdgeY + newAbsHeightPx / 2 -- Assuming center is halfway
						finalPosOffsetY = newAbsCenterY - currentScreenGuiAbsSize.Y * initialFramePosition.Y.Scale
					end
				end
			end

			-- Convert final absolute pixel dimensions back to UDim offsets for size
			local finalSizeOffsetX = newAbsWidthPx - (initialFrameSize.X.Scale * self.Parent.AbsoluteSize.X)
			local finalSizeOffsetY = newAbsHeightPx - (initialFrameSize.Y.Scale * self.Parent.AbsoluteSize.Y)

			local finalNewSize =
				UDim2.new(initialFrameSize.X.Scale, finalSizeOffsetX, initialFrameSize.Y.Scale, finalSizeOffsetY)
			local finalNewPosition = initialFramePosition -- Default if LockedPosition is true
			if typeof(LockedPosition) == "UDim2" then
				finalNewPosition = LockedPosition
			elseif not LockedPosition then -- Only update if not locked (boolean false)
				finalNewPosition = UDim2.new(
					initialFramePosition.X.Scale,
					finalPosOffsetX,
					initialFramePosition.Y.Scale,
					finalPosOffsetY
				)
			end
			return finalNewSize, finalNewPosition
		end
	end

	local function createDragHandler(resizeTypeX, resizeTypeY)
		return function(Info, Input: InputObject)
			local mouseDelta = Input.Position - Info.StartPosition
			mouseDelta = mouseDelta / GetDPIScale()

			local newSize, newPosition =
				CalculateResizeProperties(Info.FramePosition, Info.FrameSize, mouseDelta, resizeTypeX, resizeTypeY)

			MainFrame.Size = newSize
			MainFrame.Position = newPosition
		end
	end

	local LeftSide = Interface.New("Frame", {
		Size = UDim2.new(0, HandleSize, 1, -CornerHandleSize * 2),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6,
	})
	Drag.Setup(MainFrame, LeftSide, createDragHandler("Left", nil), {
		GetDPIScale = GetDPIScale,
	})

	local RightSide = Interface.New("Frame", {
		Size = UDim2.new(0, HandleSize, 1, -CornerHandleSize * 2),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6,
	})
	Drag.Setup(MainFrame, RightSide, createDragHandler("Right", nil), {
		GetDPIScale = GetDPIScale,
	})

	local TopSide = Interface.New("Frame", {
		Size = UDim2.new(1, -CornerHandleSize * 2, 0, HandleSize),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6,
	})
	Drag.Setup(MainFrame, TopSide, createDragHandler(nil, "Top"), {
		GetDPIScale = GetDPIScale,
	})

	local BottomSide = Interface.New("Frame", {
		Size = UDim2.new(1, -CornerHandleSize * 2, 0, HandleSize),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6,
	})
	Drag.Setup(MainFrame, BottomSide, createDragHandler(nil, "Bottom"), {
		GetDPIScale = GetDPIScale,
	})

	local TopLeftCorner = Interface.New("Frame", {
		Size = UDim2.fromOffset(CornerHandleSize, CornerHandleSize),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6 + 1,
	})
	Drag.Setup(MainFrame, TopLeftCorner, createDragHandler("Left", "Top"), {
		GetDPIScale = GetDPIScale,
	})

	local TopRightCorner = Interface.New("Frame", {
		Size = UDim2.fromOffset(CornerHandleSize, CornerHandleSize),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6 + 1,
	})
	Drag.Setup(MainFrame, TopRightCorner, createDragHandler("Right", "Top"), {
		GetDPIScale = GetDPIScale,
	})

	local BottomLeftCorner = Interface.New("Frame", {
		Size = UDim2.fromOffset(CornerHandleSize, CornerHandleSize),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6 + 1,
	})
	Drag.Setup(MainFrame, BottomLeftCorner, createDragHandler("Left", "Bottom"), {
		GetDPIScale = GetDPIScale,
	})

	local BottomRightCorner = Interface.New("Frame", {
		Size = UDim2.fromOffset(CornerHandleSize, CornerHandleSize),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = MainFrame,
		ZIndex = 9e6 + 1,
	})
	Drag.Setup(MainFrame, BottomRightCorner, createDragHandler("Right", "Bottom"), {
		GetDPIScale = GetDPIScale,
	})

	return self
end

return Resize

end)() end,
    [171] = function()local wax,script,require,CreateLookupTable=ImportGlobals(171)local ImportGlobals return (function(...)--[[

	Pagination Wrapper Util for the window

]]

local RawPagination = require("@src/Utils/Pagination")
local Types = require("@src/Window/Types")

local PaginationWrapper = {}
PaginationWrapper.__index = PaginationWrapper

type PaginationWrapperData = Types.PaginationData
type PaginationWrapperDataKeys = Types.PaginationDataKey

export type PaginationManager = Types.PaginationManager

function PaginationWrapper.new(data: PaginationWrapperData)
	local SanitizedData = {
		TotalItems = data.TotalItems,
		ItemsPerPage = data.ItemsPerPage or 20,
		SiblingCount = data.SiblingCount,
		CurrentPage = data.CurrentPage,
	}

	return setmetatable({
		Helper = RawPagination.new(SanitizedData),
	}, PaginationWrapper)
end

function PaginationWrapper:GetInfo()
	return self.Helper:GetInfo()
end

function PaginationWrapper:SetOption(Key: PaginationWrapperDataKeys, Value: any)
	self.Helper:SetOption(Key, Value)
end

function PaginationWrapper:SetItemsPerPage(Max: number)
	self.Helper:SetItemsPerPage(Max)
end

function PaginationWrapper:GetIndexRanges(Page: number?)
	return self.Helper:GetIndexRanges(Page)
end

function PaginationWrapper:SetPage(Page: number)
	self.Helper:SetPage(Page)
end

function PaginationWrapper:Update(TotalItems: number?, ItemsPerPage: number?)
	self.Helper:Update(TotalItems, ItemsPerPage)
end

function PaginationWrapper:GetVisualInfo(Page: number?)
	return self.Helper:GetVisualInfo(Page)
end

function PaginationWrapper:BindPagination(data: Types.PaginationBinding)
	local Component = data.Component
	local PaginationKey = data.PaginationKey

	local function RefreshValue()
		self.Helper:SetOption(PaginationKey, Component.Value)

		if data.Refresh then
			data.Refresh()
		end
	end

	Component.Callback = RefreshValue
	self.Helper:SetOption(PaginationKey, Component.Value)
end

return {
	new = function(data: PaginationWrapperData)
		return PaginationWrapper.new(data)
	end,
}

end)() end,
    [173] = function()local wax,script,require,CreateLookupTable=ImportGlobals(173)local ImportGlobals return (function(...)--[[

Luau syntax highlighter with studio colors
Based on: https://devforum.roblox.com/t/realtime-richtext-lua-syntax-highlighting/2500399

]]

local Highlighter = {
	Colors = {
		Keyword = "#f86d7c",
		String = "#adf195",
		Number = "#ffc600",
		Nil = "#ffc600",
		Boolean = "#ffc600",
		Function = "#f86d7c",
		Self = "#f86d7c",
		Local = "#f86d7c",
		Text = "#ffffff",
		LocalMethod = "#fdfbac",
		LocalProperty = "#61a1f1",
		BuiltIn = "#84d6f7",
		Comment = "#666666",
	},

	Keywords = {
		Lua = {
			"and",
			"break",
			"or",
			"else",
			"elseif",
			"if",
			"then",
			"until",
			"repeat",
			"while",
			"do",
			"for",
			"in",
			"end",
			"local",
			"return",
			"function",
			"export",
		},
		Roblox = {
			"game",
			"workspace",
			"script",
			"math",
			"string",
			"table",
			"task",
			"wait",
			"select",
			"next",
			"Enum",
			"error",
			"warn",
			"tick",
			"assert",
			"shared",
			"loadstring",
			"tonumber",
			"tostring",
			"type",
			"typeof",
			"unpack",
			"print",
			"Instance",
			"CFrame",
			"Vector3",
			"Vector2",
			"Color3",
			"UDim",
			"UDim2",
			"Ray",
			"BrickColor",
			"OverlapParams",
			"RaycastParams",
			"Axes",
			"Random",
			"Region3",
			"Rect",
			"TweenInfo",
			"collectgarbage",
			"not",
			"utf8",
			"pcall",
			"xpcall",
			"_G",
			"setmetatable",
			"getmetatable",
			"os",
			"pairs",
			"ipairs",
		},
	},
}

local function CreateKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in ipairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local LuaSet = CreateKeywordSet(Highlighter.Keywords.Lua)
local RobloxSet = CreateKeywordSet(Highlighter.Keywords.Roblox)

local function GetHighlightColor(tokens, index)
	local token = tokens[index]

	if tonumber(token) then
		return Highlighter.Colors.Number
	elseif token == "nil" then
		return Highlighter.Colors.Nil
	elseif token:sub(1, 2) == "--" then
		return Highlighter.Colors.Comment
	elseif LuaSet[token] then
		return Highlighter.Colors.Keyword
	elseif RobloxSet[token] or getgenv()[token] ~= nil then
		return Highlighter.Colors.BuiltIn
	elseif token:sub(1, 1) == '"' or token:sub(1, 1) == "'" then
		return Highlighter.Colors.String
	elseif token == "true" or token == "false" then
		return Highlighter.Colors.Boolean
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return Highlighter.Colors.LocalMethod
		end
		return Highlighter.Colors.LocalMethod
	end

	if tokens[index - 1] == "." then
		if tokens[index - 2] == "Enum" then
			return Highlighter.Colors.BuiltIn
		end
		return Highlighter.Colors.LocalProperty
	end

	return nil
end

local ArgumentColors = {
	["boolean"] = Highlighter.Colors.Boolean,
	["number"] = Highlighter.Colors.Number,
	["Vector2"] = Highlighter.Colors.Number,
	["Vector3"] = Highlighter.Colors.Number,
	["CFrame"] = Highlighter.Colors.Number,
	["string"] = Highlighter.Colors.String,
	["EnumItem"] = Highlighter.Colors.BuiltIn,
	["nil"] = Highlighter.Colors.Nil,
}
function Highlighter.GetArgumentColor(Argument)
	return ArgumentColors[typeof(Argument)] or Highlighter.Colors.Text
end

function Highlighter.Run(source)
	local tokens = {}
	local currentToken = ""

	local inString = false
	local inComment = false
	local commentPersist = false

	for i = 1, #source do
		local character = source:sub(i, i)

		if inComment then
			if character == "\n" and not commentPersist then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""

				inComment = false
			elseif source:sub(i - 1, i) == "]]" and commentPersist then
				currentToken = currentToken .. "]"

				table.insert(tokens, currentToken)
				currentToken = ""

				inComment = false
				commentPersist = false
			else
				currentToken = currentToken .. character
			end
		elseif inString then
			if character == inString and source:sub(i - 1, i - 1) ~= "\\" or character == "\n" then
				currentToken = currentToken .. character
				table.insert(tokens, currentToken)
				currentToken = ""
				inString = false
			else
				currentToken = currentToken .. character
			end
		else
			if source:sub(i, i + 1) == "--" then
				table.insert(tokens, currentToken)
				currentToken = "--"
				inComment = true
				commentPersist = source:sub(i + 2, i + 3) == "[["
				i = i + 1
			elseif character == '"' or character == "'" then
				table.insert(tokens, currentToken)
				currentToken = character
				inString = character
			elseif character:match("[%p]") and character ~= "_" then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			elseif character:match("[%w_]") then
				currentToken = currentToken .. character
			else
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			end
		end
	end

	if currentToken ~= "" then
		table.insert(tokens, currentToken)
	end

	for i = #tokens, 1, -1 do
		if tokens[i] == "" then
			table.remove(tokens, i)
		end
	end

	local highlighted = {}

	for i, token in ipairs(tokens) do
		local highlightColor = GetHighlightColor(tokens, i)

		if highlightColor then
			local syntax =
				string.format('<font color="%s">%s</font>', highlightColor, token:gsub("<", "&lt;"):gsub(">", "&gt;"))

			table.insert(highlighted, syntax)
		else
			table.insert(highlighted, token)
		end
	end

	return table.concat(highlighted)
end

return Highlighter

end)() end,
    [174] = function()local wax,script,require,CreateLookupTable=ImportGlobals(174)local ImportGlobals return (function(...)local LazySerializer = {}

local InstanceSerializer = require("@src/Utils/CodeGen/Serializer/Instance")

function LazySerializer.QuickSerializeNumber(Number: number)
	if Number % 1 ~= 0 then
		return string.format("%.3f", Number)
	elseif Number == 1 / 0 then
		return "math.huge"
	elseif Number == -1 / 0 then
		return "-math.huge"
	end

	return Number
end

function LazySerializer.QuickSerializeArgument(Argument)
	if typeof(Argument) == "string" then
		return string.format('"%s"', (Argument :: string))
	elseif typeof(Argument) == "number" then
		return LazySerializer.QuickSerializeNumber(Argument)
	elseif typeof(Argument) == "Vector2" then
		return string.format(
			"%s, %s",
			LazySerializer.QuickSerializeNumber(Argument.X),
			LazySerializer.QuickSerializeNumber(Argument.Y)
		)
	elseif typeof(Argument) == "Vector3" then
		return string.format(
			"%s, %s, %s",
			LazySerializer.QuickSerializeNumber(Argument.X),
			LazySerializer.QuickSerializeNumber(Argument.Y),
			LazySerializer.QuickSerializeNumber(Argument.Z)
		)
	elseif typeof(Argument) == "CFrame" then
		local Components = { Argument:GetComponents() }
		for Index, Value in pairs(Components) do
			Components[Index] = LazySerializer.QuickSerializeNumber(Value)
		end
		return table.concat(Components, ", ")
	elseif typeof(Argument) == "table" then
		return "{...}"
	elseif typeof(Argument) == "Instance" then
		return InstanceSerializer.Serialize(Argument, { DisableNilParentHandler = true })
	elseif typeof(Argument) == "userdata" then
		return "newproxy(" .. (getmetatable(Argument) and "true" or "false") .. ")"
	end

	return tostring(Argument)
end

return LazySerializer

end)() end,
    [175] = function()local wax,script,require,CreateLookupTable=ImportGlobals(175)local ImportGlobals return (function(...)local TextBounds = {}

local BoundsCache = {}
local BoundsCacheOrder = {}
local MaxCachedTextLength = 128
local MaxCacheEntries = 256

local function CreateCacheKey(Text: string, FontFace: Font, TextSize: number, Width: number?): string
	return `{TextSize}:{tostring(FontFace)}:{Width or ""}:{Text}`
end

function TextBounds.Get(Text: string, FontFace: Font, TextSize: number, Width: number?): (number, number)
	return wax.shared.GetTextBounds(Text, FontFace, TextSize, Width)
end

function TextBounds.GetCached(Text: string, FontFace: Font, TextSize: number, Width: number?): (number, number)
	if #Text > MaxCachedTextLength then
		return TextBounds.Get(Text, FontFace, TextSize, Width)
	end

	local CacheKey = CreateCacheKey(Text, FontFace, TextSize, Width)
	local Bounds = BoundsCache[CacheKey]
	if Bounds then
		return Bounds.X, Bounds.Y
	end

	local X, Y = TextBounds.Get(Text, FontFace, TextSize, Width)
	BoundsCache[CacheKey] = Vector2.new(X, Y)
	table.insert(BoundsCacheOrder, CacheKey)

	if #BoundsCacheOrder > MaxCacheEntries then
		local OldestKey = table.remove(BoundsCacheOrder, 1)
		BoundsCache[OldestKey] = nil
	end

	return X, Y
end

function TextBounds.GetCachedWidth(Text: string, FontFace: Font, TextSize: number, Width: number?): number
	local X = TextBounds.GetCached(Text, FontFace, TextSize, Width)
	return X
end

function TextBounds.ClearCache()
	table.clear(BoundsCache)
	table.clear(BoundsCacheOrder)
end

return TextBounds

end)() end,
    [177] = function()local wax,script,require,CreateLookupTable=ImportGlobals(177)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")
local LogStore = require("@src/Utils/LogStore")

local Drag = require("@src/Window/Utils/Input/Drag")

--// UI \\--
return function(props: {
	MainFrame: GuiObject,
	Window: Types.Window,
	ContextMenu: any,
	PaginationManager: Types.PaginationManager,
	GetDPIScale: () -> number,
})
	--// Props \\--
	local MainFrame = props.MainFrame
	local Window = props.Window
	local ContextMenu = props.ContextMenu
	local LogsPage = {
		State = {
			SelectedPageByLog = {},
			CurrentLog = nil,
		},
	}

	local LogList
	local LogCalls

	function LogsPage.CleanLogsList()
		LogCalls:CleanLogsList()
	end

	function LogsPage.ShowLog(Log)
		return LogCalls:ShowLog(Log)
	end

	function LogsPage.GetCurrentLog()
		return LogsPage.State.CurrentLog
	end

	function LogsPage.RefreshCurrentLog()
		local CurrentLog = LogsPage.GetCurrentLog()
		if not CurrentLog then
			return
		end

		props.PaginationManager:SetPage(1)
		LogsPage.State.SelectedPageByLog[CurrentLog] = 1
		LogsPage.ShowLog(CurrentLog)
	end

	function LogsPage.ClearLogs(FilterInstance: Instance?, FilterType: Types.LogDirection?)
		local ClearedLogs = LogStore.Clear(FilterInstance, FilterType)
		for _, Log in ClearedLogs do
			LogList:RemoveLogButton(Log)
			LogsPage.State.SelectedPageByLog[Log] = nil
		end

		LogCalls:CleanLogsList()

		local CurrentLog = LogsPage.GetCurrentLog()
		if not FilterInstance or (CurrentLog and CurrentLog.Instance == FilterInstance) then
			LogsPage.State.CurrentLog = nil
		end

		if #ClearedLogs > 0 then
			wax.shared.Sonner.success(
				`Successfully Cleared {FilterInstance and FilterInstance.Name .. " " or ""}{FilterType or "All"} Logs`
			)
		end
	end

	--// Components \\--
	LogList = require(script.Components.List)({
		MainFrame = MainFrame,
		LogsPage = LogsPage,
		ContextMenu = ContextMenu,
	})

	LogCalls = require(script.Components.Calls)({
		MainFrame = MainFrame,
		Window = Window,
		LogsPage = LogsPage,
		ContextMenu = ContextMenu,
		PaginationManager = props.PaginationManager,
		GetCurrentTab = function()
			return LogList.CurrentTab
		end,
	})

	--// Resizer \\--
	local RemoteListLine = Interface.New("Frame", {
		AnchorPoint = Vector2.yAxis,
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Position = UDim2.new(0, 240, 1, 0),
		Size = UDim2.new(0, 2, 1, -36),
		Parent = MainFrame,
	})

	local RemoteListResize = Interface.New("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.new(1, 4, 1, 0),
		Text = "",

		Parent = RemoteListLine,
	})
	do
		RemoteListResize.MouseEnter:Connect(function()
			wax.shared.TweenService
				:Create(RemoteListLine, Constants.DefaultTweenInfo, {
					BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				})
				:Play()
		end)
		RemoteListResize.MouseLeave:Connect(function()
			wax.shared.TweenService
				:Create(RemoteListLine, Constants.DefaultTweenInfo, {
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				})
				:Play()
		end)

		Drag.Setup(RemoteListLine, RemoteListResize, function(Info, InputObject: InputObject)
			local Delta = (InputObject.Position - Info.StartPosition) / props.GetDPIScale()
			local FramePosition: UDim2 = Info.FramePosition
			local Offset = math.clamp(FramePosition.X.Offset + Delta.X, 120, (MainFrame.AbsoluteSize.X - 2) / 2)

			Info.Frame.Position =
				UDim2.new(FramePosition.X.Scale, Offset, FramePosition.Y.Scale, FramePosition.Y.Offset)

			LogList.Frame.Size = UDim2.new(0, Offset, 1, -36)
			LogCalls.Wrapper.Size = UDim2.new(1, -(Offset + 2), 1, -36)
		end, {
			GetDPIScale = props.GetDPIScale,
		})
	end

	LogsPage.LogList = LogList
	LogsPage.LogCalls = LogCalls

	wax.shared.Connect(wax.shared.Communicator.Event:Connect(function(Batch)
		if typeof(Batch) ~= "table" then
			return
		end

		local CurrentTab = LogList.CurrentTab
		if not CurrentTab then
			return
		end

		for _, Notification in Batch do
			local Type = Notification.Type
			if CurrentTab.Name ~= Type then
				continue
			end

			local Instance = Notification.Instance
			local CallIndex = Notification.CallIndex
			local LogIndex = Notification.LogIndex

			local InstanceDebugId = wax.shared.GetDebugId(Instance)

			-- RakNet callbacks can expose an equivalent Instance through a different
			-- userdata identity. BindableEvents also strip table metatables, so pass a
			-- scalar index and resolve the original Log in this context instead.
			local Log = wax.shared.Logs[Type][InstanceDebugId]
			if not Log and LogIndex ~= nil then
				for _, Candidate in wax.shared.Logs[Type] do
					if Candidate.Index == LogIndex then
						Log = Candidate
						break
					end
				end
			end

			if not Log or #Log.Calls == 0 then
				continue
			end

			LogList:EnsureLogButton(Log)
			LogList:QueueLogButtonUpdate(Log)
			LogCalls:HandleCallAdded(Log, CallIndex)
		end
	end))

	return LogsPage
end

end)() end,
    [179] = function()local wax,script,require,CreateLookupTable=ImportGlobals(179)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

local ArgumentList = require("@src/Window/Modals/Info/Components/ArgumentList")
local CodeGen = require("@src/Utils/CodeGen/Generator")
local InstanceSerializer = require("@src/Utils/CodeGen/Serializer/Instance")
local Ratelimiter = require("@src/Utils/Ratelimiter")

local MaxArgumentPreviewLength = 500
local PreviewCacheByCallInfo = setmetatable({}, { __mode = "k" })

--// UI \\--
return function(props: {
	MainFrame: GuiObject,
	Window: Types.Window,
	LogsPage: Types.LogsPage,
	ContextMenu: any,
	PaginationManager: Types.PaginationManager,
	GetCurrentTab: () -> Types.LogDirectionTab?,
})
	local Window = props.Window
	local LogsPage = props.LogsPage
	local ContextMenu = props.ContextMenu
	local PaginationManager = props.PaginationManager

	local Calls = {
		ActiveCallInfo = nil,
		SharedCallContextMenu = nil,
		CallFramePool = {},
		CallFrameData = setmetatable({}, { __mode = "k" }),
		CurrentCallFrameRenderGeneration = 0,
	}

	--// UI \\--
	local LogsWrapper = Interface.New("Frame", {
		AnchorPoint = Vector2.one,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(1, 1),
		Size = UDim2.new(1, -242, 1, -36),
		Parent = props.MainFrame,

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 6),
		},
	})

	local LogsList = Interface.New("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -38),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 2,
		Parent = LogsWrapper,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
		},
	})

	local LogsPagination = Interface.New("Frame", {
		AnchorPoint = Vector2.yAxis,
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = LogsWrapper,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 6),
		},
	})

	Calls.Wrapper = LogsWrapper
	Calls.List = LogsList
	Calls.Pagination = LogsPagination

	--// Helpers \\--
	local function IsShowingExecutorLogs(): boolean
		local Setting = wax.shared.Settings.ShowExecutorLogs
		return not Setting or Setting.Value == true
	end

	local function GetVisibleCallCount(Log): number
		return if IsShowingExecutorLogs() then #Log.Calls else #Log.GameCalls
	end

	local function GetCallByVisibleIndex(Log, VisibleIndex: number)
		local CallIndex = if IsShowingExecutorLogs() then VisibleIndex else Log.GameCalls[VisibleIndex]
		if not CallIndex then
			return nil, nil
		end

		return Log.Calls[CallIndex], CallIndex
	end

	local function GetVisibleIndexForCall(Log, CallIndex: number): number?
		if IsShowingExecutorLogs() then
			return CallIndex
		end

		return table.find(Log.GameCalls, CallIndex)
	end

	local function GetPreviewCache(CallInfo)
		local Cache = PreviewCacheByCallInfo[CallInfo]
		if not Cache then
			Cache = {}
			PreviewCacheByCallInfo[CallInfo] = Cache
		end

		return Cache
	end

	local function CopyToClipboard(Text: string, SuccessMessage: string, ErrorMessage: string)
		local Success, Error = pcall(setclipboard, Text)
		if Success then
			wax.shared.Sonner.success(SuccessMessage)
		else
			wax.shared.Sonner.error(ErrorMessage)
			warn(ErrorMessage, Error)
		end
	end

	local function GetInitialFilterCondition(CallInfo): Types.QueryBuilderCondition
		local Value = CallInfo.Arguments and CallInfo.Arguments[1]
		local ValueType = typeof(Value)
		if ValueType == "boolean" or ValueType == "number" or ValueType == "string" then
			return {
				Subject = { Type = "Argument", Index = 1 },
				Operator = "Equals",
				Value = Value,
				Join = "And",
			}
		end

		return {
			Subject = { Type = "Argument", Index = 1 },
			Operator = "TypeIs",
			Value = ValueType,
			Join = "And",
		}
	end

	local function BuildCallContextMenuOptions()
		local ContextMenuOptions = {
			{
				Text = "Copy Calling Code",
				Icon = "forward",
				Callback = function()
					local CallInfo = Calls.ActiveCallInfo
					if not CallInfo then
						return
					end

					CopyToClipboard(
						CodeGen:BuildCallCode(CallInfo),
						"Copied code to clipboard",
						"Failed to copy code to clipboard"
					)
				end,
			},
			{
				Text = "Copy Intercept Code",
				Icon = "shield-alert",
				Callback = function()
					local CallInfo = Calls.ActiveCallInfo
					local CurrentTab = props.GetCurrentTab()
					if not (CallInfo and CurrentTab) then
						return
					end

					CopyToClipboard(
						CodeGen:BuildHookCode(CallInfo, CurrentTab.Name),
						"Copied code to clipboard",
						"Failed to copy code to clipboard"
					)
				end,
			},
			{
				Text = "Copy Remote Path",
				Icon = "package-search",
				Callback = function()
					local CallInfo = Calls.ActiveCallInfo
					if not CallInfo then
						return
					end

					CopyToClipboard(
						InstanceSerializer.Serialize(CallInfo.Instance, {
							VariableName = "Event",
							DisableNilParentHandler = false,
						}),
						"Copied remote path to clipboard",
						"Failed to copy remote path to clipboard"
					)
				end,
			},
			{
				Text = "Copy Script Path",
				Icon = "file-search",
				Condition = function()
					local CallInfo = Calls.ActiveCallInfo
					return CallInfo and typeof(CallInfo.Origin) == "Instance"
				end,
				Callback = function()
					local CallInfo = Calls.ActiveCallInfo
					if not (CallInfo and typeof(CallInfo.Origin) == "Instance") then
						return
					end

					CopyToClipboard(
						InstanceSerializer.Serialize(CallInfo.Origin),
						"Copied script path to clipboard",
						"Failed to copy script path to clipboard"
					)
				end,
			},
			{
				Text = "Create Call Filter",
				Icon = "list-filter",
				Callback = function()
					local CallInfo = Calls.ActiveCallInfo
					if not CallInfo then
						return
					end

					Window.Dialogs.CallFilter.Open(Window, {
						Remote = CallInfo.Instance,
						Direction = CallInfo.Type,
						ArgumentCount = CallInfo.Arguments.n or #CallInfo.Arguments,
						Conditions = { GetInitialFilterCondition(CallInfo) },
						Action = "Ignore",
						OnSave = function(Value)
							wax.shared.CallFilters:Add(Value)
							wax.shared.Sonner.success("Call filter created")
						end,
					})
				end,
			},
			{
				Text = "Replay",
				Icon = "play",
				Callback = function()
					local CallInfo = Calls.ActiveCallInfo
					if not CallInfo then
						return
					end

					wax.shared.Sonner.promise(function()
						CodeGen:ReplayCallInfo(CallInfo)
					end, {
						loadingText = "Replaying event...",
						successText = "Replayed event successfully!",
						errorText = "Failed to replay event",
						time = 4.5,
					})
				end,
			},
		}

		local PluginManager = wax.shared.CobaltPluginManager
		if PluginManager and PluginManager.Registry.UIHooks.ContextMenus.CallList then
			for _, Option in PluginManager.Registry.UIHooks.ContextMenus.CallList do
				table.insert(ContextMenuOptions, {
					Text = Option.Text,
					Icon = Option.Icon,
					Callback = function()
						local CallInfo = Calls.ActiveCallInfo
						if CallInfo then
							task.spawn(Option.Callback, CallInfo)
						end
					end,
				})
			end
		end

		return ContextMenuOptions
	end

	local function GetSharedCallContextMenu()
		if not Calls.SharedCallContextMenu then
			Calls.SharedCallContextMenu = ContextMenu:Create(LogsList, BuildCallContextMenuOptions(), true)
		end

		return Calls.SharedCallContextMenu
	end

	local function ClearCallFrameContent(CallFrame)
		for _, Child in CallFrame:GetChildren() do
			if
				Child:IsA("UIListLayout")
				or Child:IsA("UIPadding")
				or Child:IsA("UICorner")
				or Child:IsA("UIStroke")
			then
				continue
			end

			Child:Destroy()
		end
	end

	function Calls:ReleaseCallFrame(CallFrame)
		CallFrame.Parent = nil
		table.insert(self.CallFramePool, CallFrame)
	end

	function Calls:AcquireCallFrame()
		local CallFrame = table.remove(self.CallFramePool)
		if CallFrame then
			ClearCallFrameContent(CallFrame)
			return CallFrame
		end

		CallFrame = Interface.New("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			Text = "",

			["UIListLayout"] = {
				Padding = UDim.new(0, 6),
			},

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
			},

			Constants.MainUICorner,
		})

		local HighlightStroke = Interface.New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1,
			Transparency = 1,

			Parent = CallFrame,
		})

		self.CallFrameData[CallFrame] = {
			HighlightStroke = HighlightStroke,
		}

		CallFrame.MouseEnter:Connect(function()
			local Data = self.CallFrameData[CallFrame]
			if not Data then
				return
			end

			wax.shared.TweenService
				:Create(Data.HighlightStroke, Constants.DefaultTweenInfo, {
					Transparency = 0,
				})
				:Play()
		end)

		CallFrame.MouseLeave:Connect(function()
			local Data = self.CallFrameData[CallFrame]
			if not Data then
				return
			end

			wax.shared.TweenService
				:Create(Data.HighlightStroke, Constants.DefaultTweenInfo, {
					Transparency = if Data.IsBlockedCall then 0.5 elseif Data.IsHighlightedCall then 0.35 else 1,
				})
				:Play()
		end)

		local CallContextMenu = GetSharedCallContextMenu()
		CallFrame.MouseButton1Click:Connect(function()
			if CallContextMenu:ConsumeLongPress(CallFrame) then
				return
			end

			local Data = self.CallFrameData[CallFrame]
			if Data and Data.CallInfo and Window.Modals.Info then
				Window.Modals.Info:Open(Data.CallInfo)
			end
		end)

		local function PrepareCallContext(): boolean
			local Data = self.CallFrameData[CallFrame]
			if not (Data and Data.CallInfo) then
				return false
			end

			self.ActiveCallInfo = Data.CallInfo
			return true
		end

		CallFrame.MouseButton2Click:Connect(function()
			if not PrepareCallContext() then
				return
			end

			CallContextMenu.Open(nil, CallFrame)
		end)
		CallContextMenu:BindLongPress(CallFrame, PrepareCallContext)

		return CallFrame
	end

	function Calls:CreateCallFrame(CallInfo)
		local RenderGeneration = CallInfo.RenderGeneration
		if RenderGeneration and RenderGeneration ~= self.CurrentCallFrameRenderGeneration then
			return
		end

		if not IsShowingExecutorLogs() and not CallInfo.Origin then
			return
		end

		local IsBlockedCall = CallInfo.Blocked == true
		local IsHighlightedCall = not IsBlockedCall and CallInfo.Highlighted == true
		local CallFrame = self:AcquireCallFrame()
		local Data = self.CallFrameData[CallFrame]

		Data.CallInfo = CallInfo
		Data.IsBlockedCall = IsBlockedCall
		Data.IsHighlightedCall = IsHighlightedCall

		CallFrame.BackgroundColor3 = if IsBlockedCall then Color3.fromRGB(34, 18, 18) else Color3.fromRGB(25, 25, 25)
		CallFrame.LayoutOrder = CallInfo.Order
		Data.HighlightStroke.Color = if IsBlockedCall
			then Color3.fromRGB(222, 82, 82)
			elseif IsHighlightedCall then Color3.fromRGB(230, 170, 65)
			else Color3.fromRGB(75, 75, 75)
		Data.HighlightStroke.Transparency = if IsBlockedCall then 0.5 elseif IsHighlightedCall then 0.35 else 1

		local InitialDataView = if CallInfo.Type == "Incoming" and CallInfo.InvokeResult
			then "InvokeResult"
			else "Arguments"
		local CallInfoValues = CallInfo[InitialDataView] or {}
		local CallInfoValueCount = wax.shared.GetTableLength(CallInfoValues)
		local HasError = CallInfo.Error ~= nil

		local function ReleaseIfStale()
			if RenderGeneration and RenderGeneration ~= self.CurrentCallFrameRenderGeneration then
				self:ReleaseCallFrame(CallFrame)
				return true
			end

			return false
		end

		local ArgumentsFrame = Interface.New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = if IsBlockedCall then Color3.fromRGB(24, 13, 13) else Color3.fromRGB(15, 15, 15),
			Size = UDim2.fromScale(1, 0),
			Visible = CallInfoValueCount > 0 or HasError,

			["UIListLayout"] = {
				Padding = UDim.new(0, 6),
			},

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
			},

			Constants.MainUICorner,

			Parent = CallFrame,
		})
		do
			if HasError then
				ArgumentList.CreateHolder(0, CallInfo.Error, ArgumentsFrame, {
					IsError = true,
					IsPreview = true,
					Label = "Error",
					MaxPreviewLength = MaxArgumentPreviewLength,
				})
			end

			for Index = 1, CallInfoValueCount do
				if ReleaseIfStale() then
					return
				end

				if Index % 5 == 0 then
					task.wait()
					if ReleaseIfStale() then
						return
					end
				end

				ArgumentList.CreateHolder(Index, CallInfoValues[Index], ArgumentsFrame, {
					IsBlockedCall = IsBlockedCall,
					IsPreview = true,
					MaxPreviewLength = MaxArgumentPreviewLength,
					PreviewCache = CallInfo.PreviewCache,
				})
			end
		end

		local OriginText = CallInfo.IsExecutor and wax.shared.ExecutorName
			or CallInfo.IsRakNet and "RakNet"
			or CallInfo.Origin and CallInfo.Origin.Name
			or "Unknown"
		local OriginIcon
		if IsBlockedCall then
			OriginIcon = Interface.NewIcon("ban", {
				AnchorPoint = Vector2.yAxis,
				IconColor3 = Color3.fromRGB(255, 151, 151),
				IconTransparency = 0.5,
				Position = UDim2.new(0, 2, 1, 0),
				Size = UDim2.fromOffset(22, 22),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
			})
		elseif CallInfo.IsRakNet then
			OriginIcon = Interface.NewIcon("network", {
				AnchorPoint = Vector2.yAxis,
				IconColor3 = Color3.new(1, 1, 1),
				IconTransparency = 0.5,
				Position = UDim2.new(0, 2, 1, 0),
				Size = UDim2.fromOffset(22, 22),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
			})
		else
			OriginIcon = Interface.NewIcon(CallInfo.IsExecutor and "terminal" or "gamepad-2", {
				AnchorPoint = Vector2.yAxis,
				IconColor3 = Color3.new(1, 1, 1),
				IconTransparency = 0.5,
				Position = UDim2.new(0, 2, 1, 0),
				Size = UDim2.fromOffset(22, 22),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
			})
		end

		Interface.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 22),

			OriginIcon,

			Interface.New("TextLabel", {
				AnchorPoint = Vector2.yAxis,
				Position = UDim2.new(0, 30, 1, 0),
				Size = UDim2.new(0.5, -24, 0, 22),
				BackgroundTransparency = 1,
				Text = if IsBlockedCall then `{OriginText} (Blocked)` else OriginText,
				TextColor3 = if IsBlockedCall then Color3.fromRGB(255, 190, 190) else Color3.new(1, 1, 1),
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTransparency = 0.5,
			}),

			Interface.New("TextLabel", {
				AnchorPoint = Vector2.one,
				Position = UDim2.new(1, -2, 1, 0),
				Size = UDim2.new(0.5, -2, 0, 22),
				BackgroundTransparency = 1,
				Text = "Time: " .. os.date("%X", CallInfo.CreationTime),
				TextColor3 = if IsBlockedCall then Color3.fromRGB(255, 190, 190) else Color3.new(1, 1, 1),
				TextSize = 16,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Right,
			}),

			Parent = CallFrame,
		})

		if ReleaseIfStale() then
			return
		end

		CallFrame.Parent = LogsList
		return CallFrame
	end

	local function IsCallFrameJobCurrent(Data): boolean
		return not Data.RenderGeneration or Data.RenderGeneration == Calls.CurrentCallFrameRenderGeneration
	end

	local CreateCallFrameLimiter = Ratelimiter.new({
		Burst = {
			Time = 0.1,
			Max = 2,
		},
		ShouldProcess = IsCallFrameJobCurrent,
		MainCallback = function(Data)
			if not IsCallFrameJobCurrent(Data) then
				return
			end

			Calls:CreateCallFrame(Data)
		end,
	})

	function Calls:CleanLogsList()
		self.CurrentCallFrameRenderGeneration += 1
		for _, Object in pairs(LogsList:GetChildren()) do
			if Object.ClassName == "TextButton" then
				self:ReleaseCallFrame(Object)
			end
		end
	end

	function Calls:ShowCalls(Log, Page)
		self.CurrentCallFrameRenderGeneration += 1
		local RenderGeneration = self.CurrentCallFrameRenderGeneration
		local Start, End = PaginationManager:GetIndexRanges(Page)

		for VisibleIndex = Start, End do
			local Call = GetCallByVisibleIndex(Log, VisibleIndex)
			if not Call then
				break
			end

			local Data = setmetatable({
				Instance = Log.Instance,
				Type = Log.Type,
				Order = VisibleIndex,
				RenderGeneration = RenderGeneration,
				PreviewCache = GetPreviewCache(Call),
			}, {
				__index = Call,
			})

			CreateCallFrameLimiter:QueueOperation(Data)
		end
	end

	function Calls:CreatePaginationEllipsis(Order: number, Visible: boolean)
		local Ellipsis = {
			Ellipsis = Interface.New("TextBox", {
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				LayoutOrder = Order,
				PlaceholderText = "-",
				Text = "",
				TextSize = 15,
				RichText = false,
				Parent = Visible and LogsPagination or nil,

				["UICorner"] = {
					CornerRadius = UDim.new(0, 4),
				},
			}),
		}

		function Ellipsis:SetVisible(Visible: boolean)
			if not Visible then
				self.Ellipsis.Text = ""
			end

			self.Ellipsis.Parent = Visible and LogsPagination or nil
		end

		Ellipsis.Ellipsis.FocusLost:Connect(function(EnterPressed)
			if not EnterPressed then
				return
			end

			local Page = tonumber(Ellipsis.Ellipsis.Text)
			local CurrentLog = LogsPage.State.CurrentLog
			if not (Page and CurrentLog and math.floor(Page) == Page and math.abs(Page) == Page and Page ~= 0) then
				wax.shared.Sonner.error("Invalid page number provided!")
				Ellipsis.Ellipsis.Text = ""
				return
			end

			local Success = pcall(function()
				PaginationManager:SetPage(Page)
				LogsPage.State.SelectedPageByLog[CurrentLog] = Page
				self:ShowLog(CurrentLog)
			end)

			if not Success then
				wax.shared.Sonner.error("Invalid page number provided!")
			end

			Ellipsis.Ellipsis.Text = ""
		end)

		return Ellipsis
	end

	function Calls:CreatePaginationButton(Order: number, Active: boolean, Visible: boolean)
		local ButtonData = {
			Button = Interface.New("TextButton", {
				BackgroundColor3 = Active and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(25, 25, 25),
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Text = tostring(1),
				LayoutOrder = Order,
				TextSize = 15,
				Parent = Visible and LogsPagination or nil,

				["UICorner"] = {
					CornerRadius = UDim.new(0, 4),
				},
			}),
		}

		function ButtonData:SetActive(Active: boolean)
			self.Button.BackgroundColor3 = Active and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(25, 25, 25)
		end

		function ButtonData:SetText(Text: string)
			self.Button.Text = Text
		end

		function ButtonData:SetVisible(Visible: boolean)
			self.Button.Parent = Visible and LogsPagination or nil
		end

		ButtonData.Button.MouseButton1Click:Connect(function()
			local CurrentLog = LogsPage.State.CurrentLog
			local Page = tonumber(ButtonData.Button.Text)
			if not (CurrentLog and Page) then
				return
			end

			PaginationManager:SetPage(Page)
			LogsPage.State.SelectedPageByLog[CurrentLog] = Page
			self:ShowLog(CurrentLog)
		end)

		return ButtonData
	end

	local MaxButtons = 5 + ((PaginationManager.Helper and PaginationManager.Helper.SiblingCount) or 2) * 2
	local PaginationElements = {
		Buttons = {},
		Ellipsis = {
			[2] = Calls:CreatePaginationEllipsis(1, false),
			[MaxButtons - 1] = Calls:CreatePaginationEllipsis(MaxButtons - 1, false),
		},
	}
	for Index = 1, MaxButtons do
		table.insert(PaginationElements.Buttons, Calls:CreatePaginationButton(Index, false, false))
	end

	function Calls:ShowPagination(Log)
		local Pages = PaginationManager:GetVisualInfo()
		for Order, Info in pairs(Pages) do
			if Info == "none" then
				local Ellipsis = PaginationElements.Ellipsis[Order]
				if Ellipsis then
					Ellipsis:SetVisible(false)
				end

				local Button = PaginationElements.Buttons[Order]
				if Button then
					Button:SetVisible(false)
				end

				continue
			elseif Info == "ellipsis" then
				local Ellipsis = PaginationElements.Ellipsis[Order]
				if Ellipsis then
					Ellipsis:SetVisible(true)
				end

				local Button = PaginationElements.Buttons[Order]
				if Button then
					Button:SetVisible(false)
				end

				continue
			end

			local Ellipsis = PaginationElements.Ellipsis[Order]
			if Ellipsis then
				Ellipsis:SetVisible(false)
			end

			local Button = PaginationElements.Buttons[Order]
			if Button then
				Button:SetVisible(true)
				Button:SetText(tostring(Info))
				Button:SetActive(LogsPage.State.SelectedPageByLog[Log] == Info)
			end
		end
	end

	function Calls:ShowLog(Log)
		self:CleanLogsList()
		if not Log then
			return
		end

		local CurrentLog = LogsPage.State.CurrentLog
		if CurrentLog ~= Log then
			if CurrentLog and CurrentLog.Button then
				wax.shared.TweenService
					:Create(CurrentLog.Button.Instance, Constants.DefaultTweenInfo, {
						BackgroundTransparency = 1,
					})
					:Play()
			end

			LogsPage.State.CurrentLog = Log
			if Log.Button then
				wax.shared.TweenService
					:Create(Log.Button.Instance, Constants.DefaultTweenInfo, {
						BackgroundTransparency = 0,
					})
					:Play()
			end
		end

		local VisibleCount = GetVisibleCallCount(Log)
		local Page = LogsPage.State.SelectedPageByLog[Log] or 1
		LogsPage.State.SelectedPageByLog[Log] = Page

		PaginationManager:Update(VisibleCount)
		local PageSet = pcall(function()
			PaginationManager:SetPage(Page)
		end)
		if not PageSet then
			Page = 1
			LogsPage.State.SelectedPageByLog[Log] = Page
			PaginationManager:SetPage(Page)
		end

		LogsList.CanvasPosition = Vector2.zero
		self:ShowPagination(Log)
		self:ShowCalls(Log, Page)
	end

	function Calls:HandleCallAdded(Log, CallIndex: number)
		if LogsPage.State.CurrentLog ~= Log then
			return
		end

		local VisibleIndex = GetVisibleIndexForCall(Log, CallIndex)
		if not VisibleIndex then
			return
		end

		local Page = LogsPage.State.SelectedPageByLog[Log] or 1
		LogsPage.State.SelectedPageByLog[Log] = Page
		PaginationManager:Update(GetVisibleCallCount(Log))

		local Start, End = PaginationManager:GetIndexRanges(Page)
		if VisibleIndex < Start or VisibleIndex > End then
			self:ShowPagination(Log)
			return
		end

		local Call = Log.Calls[CallIndex]
		if not Call then
			return
		end

		local Data = setmetatable({
			Instance = Log.Instance,
			Type = Log.Type,
			Order = VisibleIndex,
			RenderGeneration = self.CurrentCallFrameRenderGeneration,
			PreviewCache = GetPreviewCache(Call),
		}, {
			__index = Call,
		})

		CreateCallFrameLimiter:QueueOperation(Data)
	end

	return Calls
end

end)() end,
    [180] = function()local wax,script,require,CreateLookupTable=ImportGlobals(180)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

--// UI \\--
return function(props: {
	Parent: GuiObject,
	OnSelected: (Tab: Types.LogDirectionTab) -> (),
})
	local DirectionTabs = {
		Tabs = {},
		CurrentTab = nil,
	}

	function DirectionTabs:Select(Tab, Force: boolean?)
		if self.CurrentTab == Tab and not Force then
			return
		end

		if self.CurrentTab then
			wax.shared.TweenService
				:Create(self.CurrentTab.Instance, Constants.DefaultTweenInfo, {
					BackgroundTransparency = 1,
				})
				:Play()
		end

		self.CurrentTab = Tab
		wax.shared.TweenService
			:Create(Tab.Instance, Constants.DefaultTweenInfo, {
				BackgroundTransparency = 0,
			})
			:Play()

		props.OnSelected(Tab)
	end

	function DirectionTabs:Create(TabName: Types.LogDirection, Active: boolean, Logs)
		local Button = Interface.New("TextButton", {
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BackgroundTransparency = Active and 0 or 1,
			Size = UDim2.fromScale(0, 1),
			TextSize = 15,
			Text = TabName,
			Parent = props.Parent,

			["UICorner"] = {
				CornerRadius = UDim.new(0, 4),
			},
		})

		local Tab = {
			Name = TabName,
			Logs = Logs,
			Instance = Button,
		}
		self.Tabs[TabName] = Tab

		Button.MouseButton1Click:Connect(function()
			self:Select(Tab)
		end)

		if Active then
			self.CurrentTab = Tab
		end

		return Tab
	end

	return DirectionTabs
end

end)() end,
    [181] = function()local wax,script,require,CreateLookupTable=ImportGlobals(181)local ImportGlobals return (function(...)--// Imports \\--
local Interface = require("@src/Utils/UI/Interface")
local Constants = require("@src/Window/Constants")
local Types = require("@src/Window/Types")

local DirectionTabs = require(script.Parent.DirectionTabs)
local Ratelimiter = require("@src/Utils/Ratelimiter")

--// UI \\--
return function(props: {
	MainFrame: GuiObject,
	LogsPage: Types.LogsPage,
	ContextMenu: any,
})
	local LogsPage = props.LogsPage
	local ContextMenu = props.ContextMenu

	local List = {
		CurrentTab = nil,
		PendingLogButtonUpdates = {},
		IsLogButtonUpdateQueued = false,
	}

	--// UI \\--
	local LeftList = Interface.New("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.yAxis,
		Size = UDim2.new(0, 240, 1, -36),
		Position = UDim2.fromScale(0, 1),
		Parent = props.MainFrame,

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		},
	})

	local RemoteTabContainer = Interface.New("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Size = UDim2.new(1, 0, 0, 30),
		Parent = LeftList,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
		},
	})

	local RemoteListWrapper = Interface.New("Frame", {
		AnchorPoint = Vector2.yAxis,
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 1, -36),
		Parent = LeftList,

		["UICorner"] = {
			CornerRadius = UDim.new(0, 4),
		},

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
		},
	})

	local RemoteList = Interface.New("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 2,
		Parent = RemoteListWrapper,

		["UIListLayout"] = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
		},

		["UIPadding"] = {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		},
	})

	List.Frame = LeftList
	List.RemoteList = RemoteList

	--// Functions \\--
	local function EstimateCounterWidth(Text: string, TextSize: number): number
		return math.ceil(#Text * TextSize * 0.42)
	end

	local function UpdateLogNameSize(Log)
		local TextSizeX = EstimateCounterWidth(Log.Button.Calls.Text, Log.Button.Calls.TextSize)
		Log.Button.Name.Size = UDim2.new(1, -(TextSizeX + 24), 1, 0)
	end

	function List:CreateLogButton(Log): (TextButton, TextLabel, TextLabel)
		local Button = Interface.New("TextButton", {
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BackgroundTransparency = 1,
			LayoutOrder = Log.Index or 1,
			Size = UDim2.new(1, 0, 0, 30),
			Text = "",

			["ImageLabel"] = {
				Image = Constants.InstanceClassImages[Log.Instance.ClassName],
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
			},

			["UICorner"] = {
				CornerRadius = UDim.new(0, 4),
			},

			["UIPadding"] = {
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
			},
		})

		local Name = Interface.New("TextLabel", {
			Position = UDim2.fromOffset(24, 0),
			Size = UDim2.new(1, -24, 1, 0),
			Text = "",
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,

			Parent = Button,
		})

		local Calls = Interface.New("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			Text = "",
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Right,

			Parent = Button,
		})

		local LogContextMenu
		Button.MouseButton1Click:Connect(function()
			if LogContextMenu and LogContextMenu:ConsumeLongPress(Button) then
				return
			end

			if LogsPage.GetCurrentLog() == Log then
				return
			end

			LogsPage.ShowLog(Log)
		end)

		local ContextMenuOptions = {
			{
				Text = function()
					return Log.Ignored and "Unignore" or "Ignore"
				end,
				Icon = function()
					return Log.Ignored and "eye" or "eye-off"
				end,
				Callback = function()
					Log:Ignore()
					wax.shared.Sonner.success(`{Log.Ignored and "Started" or "Stopped"} ignoring event`)
				end,
			},
			{
				Text = function()
					return Log.Blocked and "Unblock" or "Block"
				end,
				Icon = function()
					return Log.Blocked and "lock" or "lock-open"
				end,
				Callback = function()
					Log:Block()

					local BlockedRemoteList = wax.shared.Settings["BlockedRemotes"]
					if BlockedRemoteList then
						if Log.Blocked then
							BlockedRemoteList:AddToList(Log)
						else
							BlockedRemoteList:RemoveFromList(Log)
						end
					end

					wax.shared.Sonner.success(`{Log.Blocked and "Started" or "Stopped"} blocking event`)
				end,
			},
			{
				Text = "Clear Logs",
				Icon = "trash",
				Callback = function()
					LogsPage.ClearLogs(Log.Instance, Log.Type)
				end,
			},
		}

		local PluginManager = wax.shared.CobaltPluginManager
		if PluginManager and PluginManager.Registry.UIHooks.ContextMenus.RemoteList then
			for _, Option in PluginManager.Registry.UIHooks.ContextMenus.RemoteList do
				table.insert(ContextMenuOptions, {
					Text = Option.Text,
					Icon = Option.Icon,
					Callback = function()
						task.spawn(Option.Callback, Log)
					end,
				})
			end
		end

		LogContextMenu = ContextMenu:Create(Button, ContextMenuOptions, true)
		Button.MouseButton2Click:Connect(LogContextMenu.Toggle)
		LogContextMenu:BindLongPress(Button)

		return Button, Name, Calls
	end

	function List:EnsureLogButton(Log)
		if Log.Button then
			return Log.Button
		end

		local Button, Name, Calls = self:CreateLogButton(Log)
		Log:SetButton(Button, Name, Calls)
		return Log.Button
	end

	function List:RemoveLogButton(Log)
		self.PendingLogButtonUpdates[Log] = nil

		if not Log.Button then
			return
		end

		Log.Button.Instance:Destroy()
		Log.Button = nil
	end

	function List:RefreshLogButton(Log)
		if not (Log.Button and self.CurrentTab and self.CurrentTab.Name == Log.Type) then
			return
		end

		Log.Button.Name.Text = Log.Instance.Name
		Log.Button.Calls.Text = "x" .. #Log.Calls
		UpdateLogNameSize(Log)

		Log.Button.Instance.Parent = if #Log.Calls == 0 then nil else RemoteList
	end

	local function FlushLogButtonUpdates()
		List.IsLogButtonUpdateQueued = false

		for Log in List.PendingLogButtonUpdates do
			List.PendingLogButtonUpdates[Log] = nil
			List:RefreshLogButton(Log)
		end
	end

	local LogButtonUpdateLimiter = Ratelimiter.new({
		Burst = {
			Time = 0.1,
			Max = 1,
		},
		MainCallback = FlushLogButtonUpdates,
	})

	function List:QueueLogButtonUpdate(Log)
		self.PendingLogButtonUpdates[Log] = true

		if self.IsLogButtonUpdateQueued then
			return
		end

		self.IsLogButtonUpdateQueued = true
		LogButtonUpdateLimiter:QueueOperation()
	end

	function List:ShowTab(Tab)
		for _, Object in pairs(RemoteList:GetChildren()) do
			if Object.ClassName == "TextButton" then
				Object.Parent = nil
			end
		end

		self.CurrentTab = Tab

		for _, Log in pairs(Tab.Logs) do
			if #Log.Calls == 0 then
				continue
			end

			self:EnsureLogButton(Log)
			self:RefreshLogButton(Log)
		end
	end

	local Tabs = DirectionTabs({
		Parent = RemoteTabContainer,
		OnSelected = function(Tab)
			List:ShowTab(Tab)
		end,
	})

	Tabs:Create("Outgoing", true, wax.shared.Logs.Outgoing)
	Tabs:Create("Incoming", false, wax.shared.Logs.Incoming)
	Tabs:Select(Tabs.Tabs.Outgoing, true)

	List.Tabs = Tabs

	return List
end

end)() end
} -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        4,
        {
            "cobalt"
        },
        {
            {
                3,
                2,
                {
                    "Spy"
                },
                {
                    {
                        4,
                        1,
                        {
                            "Hooks"
                        },
                        {
                            {
                                5,
                                2,
                                {
                                    "Luau"
                                },
                                {
                                    {
                                        8,
                                        1,
                                        {
                                            "Interceptors"
                                        },
                                        {
                                            {
                                                10,
                                                2,
                                                {
                                                    "Outgoing"
                                                }
                                            },
                                            {
                                                9,
                                                2,
                                                {
                                                    "Incoming"
                                                }
                                            }
                                        }
                                    },
                                    {
                                        6,
                                        1,
                                        {
                                            "Actors"
                                        },
                                        {
                                            {
                                                7,
                                                5,
                                                {
                                                    "Environment",
                                                    Value = "--[[\n\n    Wax Environment replicated for actor env\n\n\tNOTE: the @include regions are autogenerated by the build system, do not modify them in this file.\n\tTo modify the code, modify the source files where the export regions are defined.\n]]\n\nif getgenv().CobaltInitialized == true then\n\treturn\nend\n\ngetgenv().CobaltInitialized = true\n\ntype ActorData = {\n\tToken: string,\n\tIncomingConnections: boolean,\n\tIncomingCallbacks: boolean,\n\tHookIncomingConnections: boolean,\n\tOutgoing: boolean,\n\n\tIgnorePlayerModule: boolean,\n\tLogBlockedRemotes: boolean,\n\tIgnoredRemotesDropdown: { [string]: boolean },\n\n\tExecutorSupport: { [string]: { IsWorking: boolean } },\n}\n\nlocal Data: ActorData = COBALT_ACTOR_DATA\n\nlocal function CreateLookupTable(Values)\n\tif type(Values) ~= \"table\" then\n\t\treturn Values\n\tend\n\n\tlocal LookupTable = {}\n\tfor Key, Value in next, Values do\n\t\tif type(Key) == \"number\" then\n\t\t\tLookupTable[Value] = true\n\t\telse\n\t\t\tLookupTable[Key] = Value\n\t\tend\n\tend\n\n\treturn LookupTable\nend\n\nlocal ChannelId, CurrentActor = ...\nif typeof(CurrentActor) == \"Instance\" then\n\tCurrentActor = cloneref(CurrentActor)\nend\n\nlocal function ResolveCurrentActor(Origin)\n\tif Origin and getluastate then\n\t\tlocal Success, LuaStateProxy = pcall(getluastate, Origin)\n\n\t\t-- Best effort to find origin actor\n\t\tif Success then\n\t\t\tlocal Actors = LuaStateProxy:GetActors()\n\t\t\tfor _, Actor in Actors do\n\t\t\t\tif Origin:IsDescendantOf(Actor) then\n\t\t\t\t\treturn cloneref(Actor)\n\t\t\t\tend\n\t\t\tend\n\n\t\t\tif #Actors == 1 then\n\t\t\t\treturn cloneref(Actors[1])\n\t\t\tend\n\t\tend\n\tend\n\n\t-- A LuaState can have several actors assigned to it if the worker limit gets reached\n\t-- Therefore to resolve the actual origin we use get_current_actor\n\tlocal ResolvedActor = get_current_actor and get_current_actor()\n\tif typeof(ResolvedActor) == \"Instance\" then\n\t\treturn cloneref(ResolvedActor)\n\tend\n\n\t-- Probably accurate, but maybe not\n\treturn CurrentActor\nend\n\nlocal RelayChannel = get_comm_channel(ChannelId)\n\nlocal wax = {shared = {}}\nwax.shared.IS_ACTOR = true\nwax.shared.CobaltVerificationToken = Data.Token\nlocal OnUnload\ndo\n\twax.shared.Hooks = {}\n\n\twax.shared.Settings = {\n\t\tIgnorePlayerModule = { Value = Data.IgnorePlayerModule },\n\t\tLogBlockedRemotes = { Value = Data.LogBlockedRemotes },\n\t\tIgnoredRemotesDropdown = { Value = Data.IgnoredRemotesDropdown },\n\t\tLogRobloxInternalEvents = { Value = Data.LogRobloxInternalEvents },\n\t}\n\n\twax.shared.SaveManager = {\n\t\tGetState = function(Idx, Default)\n\t\t\treturn (wax.shared.Settings[Idx] and wax.shared.Settings[Idx].Value) or Data[Idx] or Default\n\t\tend,\n\t}\n\n\twax.shared.Log = {}\n\tdo\n\t\twax.shared.Logs = {\n\t\t\tOutgoing = {},\n\t\t\tIncoming = {},\n\t\t}\n\n\t\twax.shared.NewLog = function(Instance, Type, CallingScript, DebugId)\n\t\t\tlocal NewLog = wax.shared.Log.new(Instance, Type, 0, CallingScript)\n\t\t\twax.shared.Logs[Type][DebugId] = NewLog\n\t\t\treturn NewLog\n\t\tend\n\tend\n\n\twax.shared.ExecutorSupport = Data.ExecutorSupport\n\twax.shared.Communicator = RelayChannel\n\twax.shared.ExecutorName = string.split(identifyexecutor(), \" \")[1]\n\n\t--// Services \\\\--\n\tfor _, Service in pairs({\n\t\t\"Players\",\n\t\t\"HttpService\",\n\t\t\"RobloxReplicatedStorage\",\n\t}) do\n\t\twax.shared[Service] = cloneref(game:GetService(Service))\n\tend\n\n\twax.shared.trampoline_call = trampoline_call or (syn and syn.trampoline_call)\n\n\t--// Event Reference \\\\--\n\n\tlocal InstanceSerializer = {}\n\tdo\n\t\t--#region @include region IsEqualToInstance\n\t\t--[[\n\t\t    Checks if two instances are equal.\n\n\t\t    @param Object: The first instance.\n\t\t    @param ToCompareTo: The second instance.\n\t\t    @return Whether the instances are equal.\n\t\t]]\n\t\tlocal function IsEqualToInstance(Object, ToCompareTo)\n\t\t\tif typeof(Object) ~= \"Instance\" or typeof(ToCompareTo) ~= \"Instance\" then return false end\n\n\t\t\tif rawequal(Object, ToCompareTo) then\n\t\t\t\treturn true\n\t\t\tend\n\n\t\t\tif wax.shared.ExecutorSupport[\"compareinstances\"].IsWorking then\n\t\t\t\treturn compareinstances(Object, ToCompareTo)\n\t\t\tend\n\n\t\t\tlocal ObjectDebugId, ToCompareToDebugId, ShouldCompareDebugIds = nil, nil, false\n\t\t\tdo\n\t\t\t\tlocal Success, ObjectDebugIdResult = pcall(wax.shared.GetDebugId, Object)\n\t\t\t\tlocal Success2, ToCompareToDebugIdResult = pcall(wax.shared.GetDebugId, ToCompareTo)\n\n\t\t\t\tif Success and Success2 then\n\t\t\t\t\tObjectDebugId = ObjectDebugIdResult\n\t\t\t\t\tToCompareToDebugId = ToCompareToDebugIdResult\n\t\t\t\t\tShouldCompareDebugIds = true\n\t\t\t\tend\n\t\t\tend\n\n\t\t\tif ShouldCompareDebugIds then\n\t\t\t\treturn ObjectDebugId == ToCompareToDebugId\n\t\t\tend\n\n\t\t\treturn false\n\t\tend\n\t\t--#endregion\n\n\t\tInstanceSerializer.IsEqualToInstance = IsEqualToInstance\n\tend\n\twax.shared.InstanceSerializer = InstanceSerializer\n\n\tlocal Formatter = {}\n\tdo\n\t\t--#region @include region FormatLuaLiteral\n\t\t--// Populate CleanTable \\\\--\n\t\tFormatter.CleanTable = { ['\"'] = '\\\\\"', [\"\\\\\"] = \"\\\\\\\\\" }\n\t\tdo\n\t\t\tfor i = 0, 31 do\n\t\t\t\tFormatter.CleanTable[string.char(i)] = \"\\\\\" .. string.format(\"%03d\", i)\n\t\t\tend\n\t\t\tfor i = 127, 255 do\n\t\t\t\tFormatter.CleanTable[string.char(i)] = \"\\\\\" .. string.format(\"%03d\", i)\n\t\t\tend\n\t\tend\n\n\t\t--// Indent Template \\\\--\n\t\tlocal IndentTemplate = string.rep(\" \", 4)\n\n\t\t--[[\n\t\t    Formats a Lua string to be used in a Lua code block.\n\n\t\t    @param str: The string to format.\n\t\t    @return The formatted string.\n\t\t]]\n\t\tfunction Formatter.FormatLuaString(str)\n\t\t\treturn string.gsub(str, '[\"\\\\\\0-\\31\\127-\\255]', Formatter.CleanTable)\n\t\tend\n\n\t\t--[[\n\t\t    Formats a Lua literal to be used in a Lua code block.\n\n\t\t    @param Value: The value to format.\n\t\t    @return The formatted string.\n\t\t]]\n\t\tfunction Formatter.FormatLuaLiteral(Value): string?\n\t\t\tlocal ValueType = type(Value)\n\t\t\tif ValueType == \"string\" then\n\t\t\t\treturn `\"{Formatter.FormatLuaString(Value)}\"`\n\t\t\telseif ValueType == \"number\" or ValueType == \"boolean\" then\n\t\t\t\treturn tostring(Value)\n\t\t\tend\n\n\t\t\treturn nil\n\t\tend\n\t\t--#endregion\n\tend\n\n\t--#region @include region FindEventReferenceInTable\n\t\t--[[\n\t\t\tFinds an event reference in a table, used to search upvalues which are tables.\n\n\t\t\t@param Table: The table to search.\n\t\t\t@param Instance: The instance to search for.\n\t\t\t@param Visited: The visited table.\n\t\t\t@return The event reference.\n\t\t]]\n\t\tlocal function FindEventReferenceInTable(\n\t\t\tTable: { [any]: any },\n\t\t\tInstance: Instance,\n\t\t\tVisited: { [any]: boolean }?\n\t\t): { any }?\n\t\t\tlocal Seen = Visited or {}\n\t\t\tif Seen[Table] then\n\t\t\t\treturn nil\n\t\t\tend\n\n\t\t\tSeen[Table] = true\n\n\t\t\tfor Key, Value in next, Table do\n\t\t\t\tif\n\t\t\t\t\ttypeof(Value) == \"Instance\"\n\t\t\t\t\tand InstanceSerializer.IsEqualToInstance(Value, Instance)\n\t\t\t\t\tand Formatter.FormatLuaLiteral(Key)\n\t\t\t\tthen\n\t\t\t\t\treturn { Key }\n\t\t\t\tend\n\n\t\t\t\tif type(Value) == \"table\" and Formatter.FormatLuaLiteral(Key) then\n\t\t\t\t\tlocal ChildPath = FindEventReferenceInTable(Value, Instance, Seen)\n\t\t\t\t\tif ChildPath then\n\t\t\t\t\t\ttable.insert(ChildPath, 1, Key)\n\t\t\t\t\t\treturn ChildPath\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\n\t\t\treturn nil\n\t\tend\n\t--#endregion\n\n\t--// Unload \\\\--\n\tlocal RelayConnection\n\tRelayConnection = RelayChannel.Event:Connect(function(Type, ...)\n\t\tif Type == \"Unload\" then\n\t\t\tRelayConnection:Disconnect()\n\t\t\twax.shared.Unloaded = true\n\t\t\tfor _, Connection in wax.shared.Connections do\n\t\t\t\tConnection:Disconnect()\n\t\t\tend\n\t\t\ttable.clear(wax.shared.Connections)\n\n\t\t\tif OnUnload then\n\t\t\t\tOnUnload()\n\t\t\tend\n\t\telseif Type == \"MainBlock\" then\n\t\t\tlocal Instance, EventType = ...\n\t\t\tlocal Log = wax.shared.Logs[EventType][wax.shared.GetDebugId(Instance)]\n\t\t\tif Log then\n\t\t\t\tLog:Block()\n\t\t\tend\n\t\telseif Type == \"MainIgnore\" then\n\t\t\tlocal Instance, EventType = ...\n\t\t\tlocal Log = wax.shared.Logs[EventType][wax.shared.GetDebugId(Instance)]\n\t\t\tif Log then\n\t\t\t\tLog:Ignore()\n\t\t\tend\n\t\telseif Type == \"MainSettingsSync\" then\n\t\t\tlocal Setting, Value = ...\n\t\t\tif wax.shared.Settings[Setting] then\n\t\t\t\twax.shared.Settings[Setting].Value = Value\n\t\t\tend\n\t\telseif Type == \"MainCallFiltersSync\" then\n\t\t\twax.shared.CallFilters:ReplaceAll(..., true)\n\t\telseif Type == \"InspectIncomingConnections\" then\n\t\t\tlocal Instance, Method, LogIndex, CallIndex = ...\n\t\t\tlocal Success, Signal = pcall(function()\n\t\t\t\treturn Instance[Method]\n\t\t\tend)\n\t\t\tif not Success or typeof(Signal) ~= \"RBXScriptSignal\" then\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tfor _, Connection in getconnections(Signal) do\n\t\t\t\tif Connection.ForeignState then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\n\t\t\t\tlocal Function = typeof(Connection.Function) == \"function\" and Connection.Function or nil\n\n\t\t\t\tlocal Origin\n\t\t\t\tlocal Thread = Connection.Thread\n\t\t\t\tif Thread and getscriptfromthread then\n\t\t\t\t\tOrigin = getscriptfromthread(Thread)\n\t\t\t\tend\n\t\t\t\tif not Origin and Function then\n\t\t\t\t\tlocal Script = rawget(getfenv(Function), \"script\")\n\t\t\t\t\tif typeof(Script) == \"Instance\" then\n\t\t\t\t\t\tOrigin = Script\n\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tlocal FixedInfo, CyclicRefs, ContainsCyclicRef = wax.shared.SerializeActorInfo({\n\t\t\t\t\tOrigin = Origin,\n\t\t\t\t\tFunction = Function,\n\t\t\t\t\tLine = nil,\n\t\t\t\t\tIsExecutor = Function and isexecutorclosure(Function) or false,\n\t\t\t\t\tIsActor = true,\n\t\t\t\t\tActor = ResolveCurrentActor(Origin),\n\t\t\t\t})\n\n\t\t\t\tRelayChannel:Fire(\n\t\t\t\t\t\"IncomingConnectionMetadata\",\n\t\t\t\t\tInstance,\n\t\t\t\t\tLogIndex,\n\t\t\t\t\tCallIndex,\n\t\t\t\t\tFixedInfo,\n\t\t\t\t\tCyclicRefs,\n\t\t\t\t\tContainsCyclicRef\n\t\t\t\t)\n\t\t\tend\n\t\telseif Type == \"ResolveEventReference\" then\n\t\t\tlocal Hash, Instance, IsExecutor, RequestId = ...\n\t\t\tlocal Retrieved = nil\n\n\t\t\tif filtergc then\n\t\t\t\tRetrieved = filtergc(\"function\", {\n\t\t\t\t\tHash = Hash,\n\t\t\t\t\tIgnoreExecutor = not IsExecutor,\n\t\t\t\t}, true)\n\t\t\telse\n\t\t\t\tfor _, Func in getgc() do\n\t\t\t\t\tif typeof(Func) ~= \"function\" then\n\t\t\t\t\t\tcontinue\n\t\t\t\t\tend\n\n\t\t\t\t\tif IsExecutor and not isexecutorclosure(Func) then\n\t\t\t\t\t\tcontinue\n\t\t\t\t\tend\n\n\t\t\t\t\tif getfunctionhash(Func) == Hash then\n\t\t\t\t\t\tRetrieved = Func\n\t\t\t\t\t\tbreak\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\n\t\t\tif not Retrieved then\n\t\t\t\tRelayChannel:Fire(\"ResolveEventReferenceResponse\", RequestId, nil)\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tlocal UpvaluePath = FindEventReferenceInTable(debug.getupvalues(Retrieved), Instance)\n\n\t\t\tif not UpvaluePath then\n\t\t\t\tRelayChannel:Fire(\"ResolveEventReferenceResponse\", RequestId, nil)\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tlocal UpvalueIndex = table.remove(UpvaluePath, 1)\n\t\t\tRelayChannel:Fire(\"ResolveEventReferenceResponse\", RequestId, {\n\t\t\t\tHash = Hash,\n\t\t\t\tIndex = UpvalueIndex,\n\t\t\t\tPath = UpvaluePath,\n\t\t\t})\n\t\tend\n\tend)\n\n\twax.shared.Unloaded = false\nend\n\n--#region @include \"Src/Utils/Connect.luau\" as \"wax.shared.Connect\"\ndo\n\tlocal Connections = {}\n\n\tlocal function Connect(Connection)\n\t\ttable.insert(Connections, Connection)\n\t\treturn Connection\n\tend\n\n\tlocal function Disconnect(Connection)\n\t\tConnection:Disconnect()\n\n\t\tlocal Index = table.find(Connections, Connection)\n\t\tif Index then\n\t\t\ttable.remove(Connections, Index)\n\t\tend\n\n\t\treturn true\n\tend\n\n\twax.shared.Connections = Connections\n\twax.shared.Connect = Connect\n\twax.shared.Disconnect = Disconnect\n\n\twax.shared.Connect = Connect\nend\n--#endregion\n\n--#region @include region PlayerScripts\nwax.shared.LocalPlayer = wax.shared.Players.LocalPlayer\nlocal ContendingPlayerScripts =\n\tcloneref(wax.shared.LocalPlayer:QueryDescendants(\"PlayerScripts\")[1] or wax.shared.LocalPlayer)\nif ContendingPlayerScripts:IsA(\"PlayerScripts\") then\n\twax.shared.PlayerScripts = ContendingPlayerScripts\nelse\n\twax.shared.PlayerScripts = nil\n\n\tlocal ChildAddedConnection\n\tChildAddedConnection = wax.shared.Connect(wax.shared.LocalPlayer.ChildAdded:Connect(function(Child)\n\t\tif Child:IsA(\"PlayerScripts\") then\n\t\t\twax.shared.PlayerScripts = cloneref(Child)\n\t\t\twax.shared.Disconnect(ChildAddedConnection)\n\t\tend\n\tend))\nend\n--#endregion\n\n--#region @include region ExecutorHelpers\nwax.shared.restorefunction = function(Function: (...any) -> ...any, Silent: boolean?)\n\tlocal Original = wax.shared.Hooks[Function]\n\n\tif Silent and not Original then\n\t\treturn\n\tend\n\n\tassert(Original, \"Function not hooked\")\n\n\tif restorefunction and isfunctionhooked(Function) then\n\t\trestorefunction(Function)\n\telse\n\t\twax.shared.Hooking.HookFunction(Function, Original)\n\tend\n\n\twax.shared.Hooks[Function] = nil\nend\nwax.shared.getrawmetatable = wax.shared.ExecutorSupport[\"getrawmetatable\"].IsWorking\n\t\tand (getrawmetatable or debug.getmetatable)\n\tor function()\n\t\treturn setmetatable({}, {\n\t\t\t__index = function()\n\t\t\t\treturn function() end\n\t\t\tend,\n\t\t})\n\tend\n\nlocal RawGetDebugId = clonefunction and clonefunction(game.GetDebugId) or game.GetDebugId\nwax.shared.GetDebugId = function(Instance)\n\tlocal identity = getthreadidentity()\n\tsetthreadidentity(8)\n\tlocal id = RawGetDebugId(Instance)\n\tsetthreadidentity(identity)\n\treturn id\nend\n\nwax.shared.newcclosure = wax.shared.ExecutorName == \"AWP\"\n\t\tand function(f, name)\n\t\t\tlocal env = getfenv(f)\n\t\t\tlocal x = setmetatable({\n\t\t\t\t__F = f,\n\t\t\t}, {\n\t\t\t\t__index = env,\n\t\t\t\t__newindex = env,\n\t\t\t})\n\n\t\t\tlocal nf = function(...)\n\t\t\t\treturn __F(...)\n\t\t\tend\n\n\t\t\tsetfenv(nf, x) -- set func env (env of nf gets deoptimized)\n\t\t\treturn newcclosure(nf, name)\n\t\tend\n\tor newcclosure\n--#endregion\n\n--#region @include \"Src/Utils/Hook/Luau.luau\" as \"wax.shared.Hooking\"\ndo\n\tlocal Hooking = {}\n\n\tHooking.HookFunction = function(Original, Replacement, Filter)\n\t\tif\n\t\t\twax.shared.IsUsingOthHooks\n\t\t\tand iscclosure(Original)\n\t\tthen\n\t\t\treturn oth.hook(Original, Replacement, Filter)\n\t\tend\n\n\t\tif islclosure(Replacement) then\n\t\t\tReplacement = wax.shared.newcclosure(Replacement)\n\t\tend\n\n\t\tif not wax.shared.ExecutorSupport[\"hookfunction\"].IsWorking then\n\t\t\treturn Original\n\t\tend\n\n\t\treturn hookfunction(Original, Replacement, Filter)\n\tend\n\n\tHooking.HookMetaMethod = function(object, method, hook, filter)\n\t\tlocal Metatable = wax.shared.getrawmetatable(object)\n\t\tlocal originalMethod = rawget(Metatable, method)\n\n\t\tassert(typeof(originalMethod) == \"function\", `{method} is not a function in the metatable of {object}`)\n\n\t\tif wax.shared.IsUsingOthHooks then\n\t\t\treturn oth.hook(originalMethod, hook, filter)\n\t\tend\n\n\t\tif islclosure(hook) then\n\t\t\thook = wax.shared.newcclosure(hook)\n\t\tend\n\n\t\tif\n\t\t\tnot wax.shared.ExecutorSupport[\"hookmetamethod\"].IsWorking\n\t\t\tand wax.shared.ExecutorSupport[\"getrawmetatable\"].IsWorking\n\t\tthen\n\t\t\tsetreadonly(Metatable, false)\n\t\t\trawset(Metatable, method, hook)\n\t\t\tsetreadonly(Metatable, true)\n\n\t\t\treturn originalMethod\n\t\tend\n\n\t\tif not wax.shared.ExecutorSupport[\"hookmetamethod\"].IsWorking then\n\t\t\tif method == \"__index\" then\n\t\t\t\tlocal _, Metamethod = xpcall(function()\n\t\t\t\t\treturn object[tostring(math.random())]\n\t\t\t\tend, function(err)\n\t\t\t\t\treturn debug.info(2, \"f\")\n\t\t\t\tend)\n\n\t\t\t\treturn Metamethod\n\t\t\telseif method == \"__newindex\" then\n\t\t\t\tlocal _, Metamethod = xpcall(function()\n\t\t\t\t\tobject[tostring(math.random())] = true\n\t\t\t\tend, function(err)\n\t\t\t\t\treturn debug.info(2, \"f\")\n\t\t\t\tend)\n\n\t\t\t\treturn Metamethod\n\t\t\telseif method == \"__namecall\" then\n\t\t\t\tlocal _, Metamethod = xpcall(function()\n\t\t\t\t\tobject:Mustard()\n\t\t\t\tend, function(err)\n\t\t\t\t\treturn debug.info(2, \"f\")\n\t\t\t\tend)\n\n\t\t\t\treturn Metamethod\n\t\t\tend\n\n\t\t\treturn nil\n\t\tend\n\n\t\tif filter then\n\t\t\treturn hookmetamethod(object, method, hook, true, filter)\n\t\tend\n\t\t\n\t\treturn hookmetamethod(object, method, hook)\n\tend\n\n\twax.shared.Hooking = Hooking\nend\n--#endregion\n\n--#region @include \"Src/Utils/SafePack.luau\" as \"wax.shared.SafePack\"\ndo\n\t--[[\n\t    SafePack\n\t    Author: centerepic\n\t]]\n\n\tlocal TableProxy = {}\n\n\tlocal UNPACK_CHUNK = 7997\n\tlocal SAFE_LIMIT = 12000\n\n\tfunction TableProxy.Pack(...)\n\t    return { n = select(\"#\", ...), ... }\n\tend\n\n\tfunction TableProxy.Unpack(Tbl, I, J)\n\t    I = I or 1\n\t    J = J or Tbl.n or #Tbl\n\n\t    if J - I + 1 > SAFE_LIMIT then\n\t        J = I + SAFE_LIMIT - 1\n\t    end\n\n\t    if J < I then\n\t        return\n\t    end\n\n\t    if J - I + 1 <= UNPACK_CHUNK then\n\t        return table.unpack(Tbl, I, J)\n\t    end\n\n\t    return Tbl[I], TableProxy.Unpack(Tbl, I + 1, J)\n\tend\n\n\twax.shared.SafePack = TableProxy\nend\n--#endregion\n\n--#region @include \"Src/Utils/Validation/Schema.luau\" as \"wax.shared.ValidationSchema\"\ndo\n\t--// Types \\\\--\n\ttype SchemaKind = \"Any\" | \"Type\" | \"Literal\" | \"Enum\" | \"Array\" | \"Object\" | \"Union\"\n\ttype Refinement = {\n\t\tPredicate: (any) -> boolean,\n\t\tMessage: string,\n\t}\n\ttype SchemaNode = {\n\t\tKind: SchemaKind,\n\t\tExpectedType: string?,\n\t\tLiteral: any?,\n\t\tValues: { any }?,\n\t\tItem: SchemaNode?,\n\t\tShape: { [any]: SchemaNode }?,\n\t\tSchemas: { SchemaNode }?,\n\t\tIsOptional: boolean?,\n\t\tHasDefault: boolean?,\n\t\tDefaultValue: any?,\n\t\tRefinements: { Refinement }?,\n\t\tMinimum: number?,\n\t\tMaximum: number?,\n\t\tInteger: boolean?,\n\t}\n\n\t--// Setup \\\\--\n\tlocal Node = {}\n\tNode.__index = Node\n\n\tlocal Schema = {}\n\n\t--// Helpers \\\\--\n\tlocal function CloneValue(Value)\n\t\tif type(Value) ~= \"table\" then\n\t\t\treturn Value\n\t\tend\n\n\t\tlocal Copy = {}\n\t\tfor Key, Child in Value do\n\t\t\tCopy[CloneValue(Key)] = CloneValue(Child)\n\t\tend\n\t\treturn Copy\n\tend\n\n\tlocal function CloneNode(self: SchemaNode): SchemaNode\n\t\tlocal Copy = table.clone(self)\n\t\tCopy.Refinements = self.Refinements and table.clone(self.Refinements) or nil\n\t\treturn setmetatable(Copy, Node) :: any\n\tend\n\n\tlocal function NewNode(Kind: SchemaKind, Data: { [any]: any }?): SchemaNode\n\t\tlocal NewSchema = Data and table.clone(Data) or {}\n\t\tNewSchema.Kind = Kind\n\t\treturn setmetatable(NewSchema, Node) :: any\n\tend\n\n\tlocal function AddError(Errors: { string }, Path: string, Message: string)\n\t\ttable.insert(Errors, `{Path}: {Message}`)\n\tend\n\n\tlocal function ChildPath(Path: string, Key: any): string\n\t\tif type(Key) == \"number\" then\n\t\t\treturn `{Path}[{Key}]`\n\t\tend\n\t\treturn Path == \"\" and tostring(Key) or `{Path}.{Key}`\n\tend\n\n\tlocal function IsSchema(Value): boolean\n\t\treturn type(Value) == \"table\" and getmetatable(Value) == Node\n\tend\n\n\tlocal function ValidateNode(CurrentSchema: SchemaNode, Value: any, Path: string, Errors: { string }): (boolean, any)\n\t\tif Value == nil then\n\t\t\tif CurrentSchema.HasDefault then\n\t\t\t\treturn true, CloneValue(CurrentSchema.DefaultValue)\n\t\t\tend\n\t\t\tif CurrentSchema.IsOptional then\n\t\t\t\treturn true, nil\n\t\t\tend\n\n\t\t\tAddError(Errors, Path, \"is required\")\n\t\t\treturn false, nil\n\t\tend\n\n\t\tlocal IsValid = true\n\t\tlocal Output = Value\n\t\tlocal Kind = CurrentSchema.Kind\n\n\t\tif Kind == \"Type\" then\n\t\t\tIsValid = typeof(Value) == CurrentSchema.ExpectedType\n\t\t\tif not IsValid then\n\t\t\t\tAddError(Errors, Path, `expected {CurrentSchema.ExpectedType}, got {typeof(Value)}`)\n\t\t\tend\n\t\telseif Kind == \"Literal\" then\n\t\t\tIsValid = Value == CurrentSchema.Literal\n\t\t\tif not IsValid then\n\t\t\t\tAddError(Errors, Path, `expected {tostring(CurrentSchema.Literal)}`)\n\t\t\tend\n\t\telseif Kind == \"Enum\" then\n\t\t\tIsValid = false\n\t\t\tfor _, Option in CurrentSchema.Values or {} do\n\t\t\t\tif Value == Option then\n\t\t\t\t\tIsValid = true\n\t\t\t\t\tbreak\n\t\t\t\tend\n\t\t\tend\n\t\t\tif not IsValid then\n\t\t\t\tlocal Options = {}\n\t\t\t\tfor _, Option in CurrentSchema.Values or {} do\n\t\t\t\t\ttable.insert(Options, tostring(Option))\n\t\t\t\tend\n\t\t\t\tAddError(Errors, Path, `expected one of {table.concat(Options, \", \")}`)\n\t\t\tend\n\t\telseif Kind == \"Array\" then\n\t\t\tif type(Value) ~= \"table\" then\n\t\t\t\tAddError(Errors, Path, `expected table, got {typeof(Value)}`)\n\t\t\t\tIsValid = false\n\t\t\telse\n\t\t\t\tOutput = {}\n\t\t\t\tfor Index, Child in Value do\n\t\t\t\t\tif type(Index) ~= \"number\" or Index % 1 ~= 0 or Index < 1 then\n\t\t\t\t\t\tAddError(Errors, Path, \"expected an array with positive integer keys\")\n\t\t\t\t\t\tIsValid = false\n\t\t\t\t\t\tcontinue\n\t\t\t\t\tend\n\n\t\t\t\t\tlocal ChildValid, ChildOutput = ValidateNode(CurrentSchema.Item :: SchemaNode, Child, ChildPath(Path, Index), Errors)\n\t\t\t\t\tIsValid = ChildValid and IsValid\n\t\t\t\t\tif ChildValid then\n\t\t\t\t\t\tOutput[Index] = ChildOutput\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\telseif Kind == \"Object\" then\n\t\t\tif type(Value) ~= \"table\" then\n\t\t\t\tAddError(Errors, Path, `expected table, got {typeof(Value)}`)\n\t\t\t\tIsValid = false\n\t\t\telse\n\t\t\t\tOutput = {}\n\t\t\t\tfor Key, ChildSchema in CurrentSchema.Shape or {} do\n\t\t\t\t\tlocal ChildValid, ChildOutput = ValidateNode(ChildSchema, Value[Key], ChildPath(Path, Key), Errors)\n\t\t\t\t\tIsValid = ChildValid and IsValid\n\t\t\t\t\tif ChildOutput ~= nil then\n\t\t\t\t\t\tOutput[Key] = ChildOutput\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\telseif Kind == \"Union\" then\n\t\t\tIsValid = false\n\t\t\tfor _, ChildSchema in CurrentSchema.Schemas or {} do\n\t\t\t\tlocal ChildErrors = {}\n\t\t\t\tlocal ChildValid, ChildOutput = ValidateNode(ChildSchema, Value, Path, ChildErrors)\n\t\t\t\tif ChildValid then\n\t\t\t\t\tIsValid = true\n\t\t\t\t\tOutput = ChildOutput\n\t\t\t\t\tbreak\n\t\t\t\tend\n\t\t\tend\n\t\t\tif not IsValid then\n\t\t\t\tAddError(Errors, Path, \"did not match any allowed schema\")\n\t\t\tend\n\t\tend\n\n\t\tif not IsValid then\n\t\t\treturn false, nil\n\t\tend\n\n\t\tif type(Output) == \"number\" then\n\t\t\tif CurrentSchema.Integer and Output % 1 ~= 0 then\n\t\t\t\tAddError(Errors, Path, \"expected an integer\")\n\t\t\t\tIsValid = false\n\t\t\tend\n\t\t\tif CurrentSchema.Minimum ~= nil and Output < CurrentSchema.Minimum then\n\t\t\t\tAddError(Errors, Path, `must be at least {CurrentSchema.Minimum}`)\n\t\t\t\tIsValid = false\n\t\t\tend\n\t\t\tif CurrentSchema.Maximum ~= nil and Output > CurrentSchema.Maximum then\n\t\t\t\tAddError(Errors, Path, `must be at most {CurrentSchema.Maximum}`)\n\t\t\t\tIsValid = false\n\t\t\tend\n\t\tend\n\n\t\tfor _, Refinement in CurrentSchema.Refinements or {} do\n\t\t\tlocal Success, Result = pcall(Refinement.Predicate, Output)\n\t\t\tif not Success or not Result then\n\t\t\t\tAddError(Errors, Path, Refinement.Message)\n\t\t\t\tIsValid = false\n\t\t\tend\n\t\tend\n\n\t\tif not IsValid then\n\t\t\treturn false, nil\n\t\tend\n\t\treturn true, Output\n\tend\n\n\t--// Modifiers \\\\--\n\tfunction Node:optional(): SchemaNode\n\t\tlocal Copy = CloneNode(self)\n\t\tCopy.IsOptional = true\n\t\treturn Copy\n\tend\n\n\tfunction Node:default(Value: any): SchemaNode\n\t\tlocal Copy = CloneNode(self)\n\t\tCopy.HasDefault = true\n\t\tCopy.DefaultValue = Value\n\t\treturn Copy\n\tend\n\n\tfunction Node:refine(Predicate: (any) -> boolean, Message: string?): SchemaNode\n\t\tassert(type(Predicate) == \"function\", \"Schema refinement must be a function\")\n\t\tlocal Copy = CloneNode(self)\n\t\tCopy.Refinements = Copy.Refinements or {}\n\t\ttable.insert(Copy.Refinements, {\n\t\t\tPredicate = Predicate,\n\t\t\tMessage = Message or \"failed refinement\",\n\t\t})\n\t\treturn Copy\n\tend\n\n\tfunction Node:integer(): SchemaNode\n\t\tassert(self.Kind == \"Type\" and self.ExpectedType == \"number\", \"integer() can only be used on number schemas\")\n\t\tlocal Copy = CloneNode(self)\n\t\tCopy.Integer = true\n\t\treturn Copy\n\tend\n\n\tfunction Node:min(Value: number): SchemaNode\n\t\tassert(self.Kind == \"Type\" and self.ExpectedType == \"number\", \"min() can only be used on number schemas\")\n\t\tlocal Copy = CloneNode(self)\n\t\tCopy.Minimum = Value\n\t\treturn Copy\n\tend\n\n\tfunction Node:max(Value: number): SchemaNode\n\t\tassert(self.Kind == \"Type\" and self.ExpectedType == \"number\", \"max() can only be used on number schemas\")\n\t\tlocal Copy = CloneNode(self)\n\t\tCopy.Maximum = Value\n\t\treturn Copy\n\tend\n\n\t--// Constructors \\\\--\n\tfunction Schema.any(): SchemaNode\n\t\treturn NewNode(\"Any\")\n\tend\n\n\tfunction Schema.type(ExpectedType: string): SchemaNode\n\t\tassert(type(ExpectedType) == \"string\", \"Schema type must be a string\")\n\t\treturn NewNode(\"Type\", { ExpectedType = ExpectedType })\n\tend\n\n\tfunction Schema.string(): SchemaNode\n\t\treturn Schema.type(\"string\")\n\tend\n\n\tfunction Schema.number(): SchemaNode\n\t\treturn Schema.type(\"number\")\n\tend\n\n\tfunction Schema.boolean(): SchemaNode\n\t\treturn Schema.type(\"boolean\")\n\tend\n\n\tfunction Schema.table(): SchemaNode\n\t\treturn Schema.type(\"table\")\n\tend\n\n\tfunction Schema.callback(): SchemaNode\n\t\treturn Schema.type(\"function\")\n\tend\n\n\tfunction Schema.instance(ClassName: string?): SchemaNode\n\t\tlocal InstanceSchema = Schema.type(\"Instance\")\n\t\tif ClassName then\n\t\t\treturn InstanceSchema:refine(function(Value)\n\t\t\t\treturn Value:IsA(ClassName)\n\t\t\tend, `expected an Instance that is a {ClassName}`)\n\t\tend\n\t\treturn InstanceSchema\n\tend\n\n\tfunction Schema.literal(Value: any): SchemaNode\n\t\tassert(Value ~= nil, \"Schema literal cannot be nil; use optional() instead\")\n\t\treturn NewNode(\"Literal\", { Literal = Value })\n\tend\n\n\tfunction Schema.enum(Values: { any }): SchemaNode\n\t\tassert(type(Values) == \"table\" and #Values > 0, \"Schema enum requires at least one value\")\n\t\treturn NewNode(\"Enum\", { Values = table.clone(Values) })\n\tend\n\n\tfunction Schema.array(ItemSchema: SchemaNode): SchemaNode\n\t\tassert(IsSchema(ItemSchema), \"Schema array requires an item schema\")\n\t\treturn NewNode(\"Array\", { Item = ItemSchema })\n\tend\n\n\tfunction Schema.object(Shape: { [any]: SchemaNode }): SchemaNode\n\t\tassert(type(Shape) == \"table\", \"Schema object requires a shape\")\n\t\tfor Key, ChildSchema in Shape do\n\t\t\tassert(IsSchema(ChildSchema), `Schema object field {tostring(Key)} must be a schema`)\n\t\tend\n\t\treturn NewNode(\"Object\", { Shape = table.clone(Shape) })\n\tend\n\n\tfunction Schema.union(Schemas: { SchemaNode }): SchemaNode\n\t\tassert(type(Schemas) == \"table\" and #Schemas > 0, \"Schema union requires at least one schema\")\n\t\tfor _, ChildSchema in Schemas do\n\t\t\tassert(IsSchema(ChildSchema), \"Schema union entries must be schemas\")\n\t\tend\n\t\treturn NewNode(\"Union\", { Schemas = table.clone(Schemas) })\n\tend\n\n\t--// Validation \\\\--\n\tfunction Schema.Validate(DataSchema: SchemaNode, Value: any): (boolean, any, { string })\n\t\tassert(IsSchema(DataSchema), \"ValidateSchema requires a schema created by Validation.Schema\")\n\t\tlocal Errors = {}\n\t\tlocal IsValid, Output = ValidateNode(DataSchema, Value, \"Value\", Errors)\n\t\treturn IsValid, Output, Errors\n\tend\n\n\twax.shared.ValidationSchema = Schema\nend\n--#endregion\n\n--#region @include \"Src/Utils/Validation/init.luau\" as \"wax.shared.Validation\"\ndo\n\t--// Imports \\\\--\n\tlocal Schema = wax.shared.ValidationSchema or require(script.Schema)\n\n\t--// Module \\\\--\n\tlocal Validation = {\n\t\tSchema = Schema,\n\t}\n\n\t--// Functions \\\\--\n\tfunction Validation.FillTemplate(Data, Template)\n\t\tlocal NewData = {}\n\t\tfor Key, Value in Template do\n\t\t\tif Data[Key] == nil or typeof(Data[Key]) ~= typeof(Value) then\n\t\t\t\tNewData[Key] = Value\n\t\t\telse\n\t\t\t\tNewData[Key] = Data[Key]\n\t\t\tend\n\t\tend\n\n\t\treturn NewData\n\tend\n\n\tfunction Validation.ValidateSchema(Data, DataSchema)\n\t\treturn Schema.Validate(DataSchema, Data)\n\tend\n\n\twax.shared.Validation = Validation\nend\n--#endregion\n\n--#region @include \"Src/Utils/CallFilter/Operators.luau\" as \"wax.shared.CallFilterOperators\"\ndo\n\tlocal Operators = {}\n\n\tlocal Registry = {\n\t\tEquals = {\n\t\t\tText = \"==\",\n\t\t\tAllowedTypes = { boolean = true, number = true, string = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn Value == Expected\n\t\t\tend,\n\t\t},\n\t\tNotEquals = {\n\t\t\tText = \"~=\",\n\t\t\tAllowedTypes = { boolean = true, number = true, string = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn Value ~= Expected\n\t\t\tend,\n\t\t},\n\t\tLessThan = {\n\t\t\tText = \"<\",\n\t\t\tNumericComparison = true,\n\t\t\tAllowedTypes = { number = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"number\" and typeof(Expected) == \"number\" and Value < Expected\n\t\t\tend,\n\t\t},\n\t\tLessThanOrEqual = {\n\t\t\tText = \"<=\",\n\t\t\tNumericComparison = true,\n\t\t\tAllowedTypes = { number = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"number\" and typeof(Expected) == \"number\" and Value <= Expected\n\t\t\tend,\n\t\t},\n\t\tGreaterThan = {\n\t\t\tText = \">\",\n\t\t\tNumericComparison = true,\n\t\t\tAllowedTypes = { number = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"number\" and typeof(Expected) == \"number\" and Value > Expected\n\t\t\tend,\n\t\t},\n\t\tGreaterThanOrEqual = {\n\t\t\tText = \">=\",\n\t\t\tNumericComparison = true,\n\t\t\tAllowedTypes = { number = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"number\" and typeof(Expected) == \"number\" and Value >= Expected\n\t\t\tend,\n\t\t},\n\t\tContains = {\n\t\t\tText = \"Contains\",\n\t\t\tSummaryText = \"contains\",\n\t\t\tAllowedTypes = { string = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"string\"\n\t\t\t\t\tand typeof(Expected) == \"string\"\n\t\t\t\t\tand string.find(Value, Expected, 1, true) ~= nil\n\t\t\tend,\n\t\t},\n\t\tStartsWith = {\n\t\t\tText = \"Starts with\",\n\t\t\tSummaryText = \"starts with\",\n\t\t\tAllowedTypes = { string = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"string\"\n\t\t\t\t\tand typeof(Expected) == \"string\"\n\t\t\t\t\tand string.sub(Value, 1, #Expected) == Expected\n\t\t\tend,\n\t\t},\n\t\tEndsWith = {\n\t\t\tText = \"Ends with\",\n\t\t\tSummaryText = \"ends with\",\n\t\t\tAllowedTypes = { string = true },\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == \"string\"\n\t\t\t\t\tand typeof(Expected) == \"string\"\n\t\t\t\t\tand (Expected == \"\" or string.sub(Value, -#Expected) == Expected)\n\t\t\tend,\n\t\t},\n\t\tTypeIs = {\n\t\t\tText = \"Type\",\n\t\t\tSummaryText = \"type\",\n\t\t\tEvaluate = function(Value, Expected)\n\t\t\t\treturn typeof(Value) == tostring(Expected)\n\t\t\tend,\n\t\t},\n\t}\n\n\tlocal Order = {\n\t\t\"Equals\",\n\t\t\"NotEquals\",\n\t\t\"LessThan\",\n\t\t\"LessThanOrEqual\",\n\t\t\"GreaterThan\",\n\t\t\"GreaterThanOrEqual\",\n\t\t\"Contains\",\n\t\t\"StartsWith\",\n\t\t\"EndsWith\",\n\t\t\"TypeIs\",\n\t}\n\n\tlocal TypeNames = {\n\t\t\"nil\",\n\t\t\"boolean\",\n\t\t\"number\",\n\t\t\"string\",\n\t\t\"table\",\n\t\t\"function\",\n\t\t\"thread\",\n\t\t\"userdata\",\n\t\t\"Instance\",\n\t\t\"EnumItem\",\n\t\t\"RBXScriptSignal\",\n\t\t\"RBXScriptConnection\",\n\t\t\"Vector2\",\n\t\t\"Vector3\",\n\t\t\"CFrame\",\n\t\t\"Color3\",\n\t\t\"BrickColor\",\n\t\t\"UDim\",\n\t\t\"UDim2\",\n\t\t\"Rect\",\n\t\t\"Ray\",\n\t\t\"buffer\",\n\t}\n\n\tlocal TypeNameLookup = {}\n\tfor _, TypeName in TypeNames do\n\t\tTypeNameLookup[TypeName] = true\n\tend\n\n\tlocal function GetSubjectKey(Subject): string\n\t\treturn if Subject.Type == \"ArgumentCount\" then \"ArgumentCount\" else `Argument:{Subject.Index}`\n\tend\n\n\tlocal function FormatSubject(Subject): string\n\t\treturn if Subject.Type == \"ArgumentCount\" then \"#Arg\" else `Arg[{Subject.Index}]`\n\tend\n\n\tlocal function GetAndGroupRange(Conditions, Condition)\n\t\tlocal ConditionIndex = table.find(Conditions, Condition)\n\t\tif not ConditionIndex then\n\t\t\treturn 1, #Conditions\n\t\tend\n\n\t\tlocal FirstIndex = 1\n\t\tfor Index = ConditionIndex, 2, -1 do\n\t\t\tif Conditions[Index].Join == \"Or\" then\n\t\t\t\tFirstIndex = Index\n\t\t\t\tbreak\n\t\t\tend\n\t\tend\n\n\t\tlocal LastIndex = #Conditions\n\t\tfor Index = ConditionIndex + 1, #Conditions do\n\t\t\tif Conditions[Index].Join == \"Or\" then\n\t\t\t\tLastIndex = Index - 1\n\t\t\t\tbreak\n\t\t\tend\n\t\tend\n\n\t\treturn FirstIndex, LastIndex\n\tend\n\n\tlocal function FormatValue(Value): string\n\t\treturn if typeof(Value) == \"string\" then `\"{Value}\"` else tostring(Value)\n\tend\n\n\tfunction Operators.Get(Operator)\n\t\treturn Registry[Operator]\n\tend\n\n\tfunction Operators.GetOptions()\n\t\tlocal Options = {}\n\t\tfor _, Operator in Order do\n\t\t\tlocal Definition = Registry[Operator]\n\t\t\ttable.insert(Options, {\n\t\t\t\tValue = Operator,\n\t\t\t\tText = Definition.Text,\n\t\t\t})\n\t\tend\n\t\treturn Options\n\tend\n\n\tfunction Operators.GetTypeNames()\n\t\treturn table.clone(TypeNames)\n\tend\n\n\tfunction Operators.IsTypeName(Value): boolean\n\t\treturn type(Value) == \"string\" and TypeNameLookup[Value] == true\n\tend\n\n\tfunction Operators.GetText(Operator, Summary: boolean?): string\n\t\tlocal Definition = Registry[Operator]\n\t\tif not Definition then\n\t\t\treturn tostring(Operator)\n\t\tend\n\t\treturn Summary and Definition.SummaryText or Definition.Text\n\tend\n\n\tfunction Operators.FormatValue(Value): string\n\t\treturn FormatValue(Value)\n\tend\n\n\tfunction Operators.IsNumericComparison(Operator): boolean\n\t\tlocal Definition = Registry[Operator]\n\t\treturn Definition ~= nil and Definition.NumericComparison == true\n\tend\n\n\tfunction Operators.Evaluate(Operator, Value, Expected): boolean\n\t\tlocal Definition = Registry[Operator]\n\t\treturn Definition ~= nil and Definition.Evaluate(Value, Expected) or false\n\tend\n\n\tfunction Operators.ResolveSubject(Subject, Arguments)\n\t\tif Subject.Type == \"ArgumentCount\" then\n\t\t\treturn Arguments.n or #Arguments\n\t\tend\n\n\t\treturn Arguments[Subject.Index]\n\tend\n\n\tfunction Operators.MatchesCondition(Condition, Arguments): boolean\n\t\treturn Operators.Evaluate(Condition.Operator, Operators.ResolveSubject(Condition.Subject, Arguments), Condition.Value)\n\tend\n\n\tfunction Operators.Matches(Conditions, ResolveValue): boolean\n\t\tif #Conditions == 0 then\n\t\t\treturn true\n\t\tend\n\n\t\tlocal AnyGroupMatches = false\n\t\tlocal CurrentGroupMatches = Operators.Evaluate(\n\t\t\tConditions[1].Operator,\n\t\t\tResolveValue(Conditions[1]),\n\t\t\tConditions[1].Value\n\t\t)\n\t\tfor Index = 2, #Conditions do\n\t\t\tlocal Condition = Conditions[Index]\n\t\t\tlocal Matches = Operators.Evaluate(Condition.Operator, ResolveValue(Condition), Condition.Value)\n\t\t\tif Condition.Join == \"Or\" then\n\t\t\t\tAnyGroupMatches = AnyGroupMatches or CurrentGroupMatches\n\t\t\t\tCurrentGroupMatches = Matches\n\t\t\telse\n\t\t\t\tCurrentGroupMatches = CurrentGroupMatches and Matches\n\t\t\tend\n\t\tend\n\n\t\treturn AnyGroupMatches or CurrentGroupMatches\n\tend\n\n\tfunction Operators.MatchesConditions(Conditions, Arguments): boolean\n\t\treturn Operators.Matches(Conditions, function(Condition)\n\t\t\treturn Operators.ResolveSubject(Condition.Subject, Arguments)\n\t\tend)\n\tend\n\n\tfunction Operators.GetConditionType(Conditions, Condition): string?\n\t\tif Condition.Subject.Type == \"ArgumentCount\" then\n\t\t\treturn \"number\"\n\t\tend\n\n\t\tlocal SubjectKey = GetSubjectKey(Condition.Subject)\n\t\tlocal FirstIndex, LastIndex = GetAndGroupRange(Conditions, Condition)\n\t\tfor Index = FirstIndex, LastIndex do\n\t\t\tlocal OtherCondition = Conditions[Index]\n\t\t\tif\n\t\t\t\tOtherCondition ~= Condition\n\t\t\t\tand GetSubjectKey(OtherCondition.Subject) == SubjectKey\n\t\t\t\tand OtherCondition.Operator == \"TypeIs\"\n\t\t\tthen\n\t\t\t\treturn tostring(OtherCondition.Value)\n\t\t\tend\n\t\tend\n\n\t\tif Condition.Operator == \"TypeIs\" then\n\t\t\treturn tostring(Condition.Value)\n\t\tend\n\n\t\tlocal ValueType = typeof(Condition.Value)\n\t\tif ValueType == \"boolean\" or ValueType == \"number\" then\n\t\t\treturn ValueType\n\t\tend\n\n\t\tfor Index = FirstIndex, LastIndex do\n\t\t\tlocal OtherCondition = Conditions[Index]\n\t\t\tlocal OtherValueType = typeof(OtherCondition.Value)\n\t\t\tif\n\t\t\t\tOtherCondition ~= Condition\n\t\t\t\tand GetSubjectKey(OtherCondition.Subject) == SubjectKey\n\t\t\t\tand (OtherValueType == \"boolean\" or OtherValueType == \"number\")\n\t\t\tthen\n\t\t\t\treturn OtherValueType\n\t\t\tend\n\t\tend\n\n\t\treturn if ValueType == \"string\" then \"string\" else nil\n\tend\n\n\tfunction Operators.IsAllowed(Conditions, Condition, Operator): boolean\n\t\tif Operator == \"TypeIs\" then\n\t\t\treturn Condition.Subject.Type == \"Argument\"\n\t\tend\n\n\t\tlocal Definition = Registry[Operator]\n\t\tif not Definition then\n\t\t\treturn false\n\t\tend\n\n\t\tlocal ConditionType = Operators.GetConditionType(Conditions, Condition)\n\t\treturn ConditionType == nil or Definition.AllowedTypes[ConditionType] == true\n\tend\n\n\tfunction Operators.IsConditionValid(Conditions, Condition): boolean\n\t\tlocal Definition = Registry[Condition.Operator]\n\t\tif not Definition then\n\t\t\treturn false\n\t\tend\n\n\t\tif Condition.Operator == \"TypeIs\" then\n\t\t\treturn Condition.Subject.Type == \"Argument\" and Operators.IsTypeName(Condition.Value)\n\t\tend\n\n\t\tlocal ConditionType = Operators.GetConditionType(Conditions, Condition)\n\t\treturn ConditionType ~= nil\n\t\t\tand Definition.AllowedTypes ~= nil\n\t\t\tand Definition.AllowedTypes[ConditionType] == true\n\t\t\tand typeof(Condition.Value) == ConditionType\n\tend\n\n\tlocal function NumericConditionsConflict(First, Second): boolean\n\t\tif typeof(First.Value) ~= \"number\" or typeof(Second.Value) ~= \"number\" then\n\t\t\treturn false\n\t\tend\n\n\t\tif First.Operator == \"Equals\" and Operators.IsNumericComparison(Second.Operator) then\n\t\t\treturn not Operators.Evaluate(Second.Operator, First.Value, Second.Value)\n\t\telseif Second.Operator == \"Equals\" and Operators.IsNumericComparison(First.Operator) then\n\t\t\treturn not Operators.Evaluate(First.Operator, Second.Value, First.Value)\n\t\telseif not Operators.IsNumericComparison(First.Operator) or not Operators.IsNumericComparison(Second.Operator) then\n\t\t\treturn false\n\t\tend\n\n\t\tlocal FirstIsLower = First.Operator == \"GreaterThan\" or First.Operator == \"GreaterThanOrEqual\"\n\t\tlocal SecondIsLower = Second.Operator == \"GreaterThan\" or Second.Operator == \"GreaterThanOrEqual\"\n\t\tif FirstIsLower == SecondIsLower then\n\t\t\treturn false\n\t\tend\n\n\t\tlocal Lower = if FirstIsLower then First else Second\n\t\tlocal Upper = if FirstIsLower then Second else First\n\t\treturn Lower.Value > Upper.Value\n\t\t\tor Lower.Value == Upper.Value and (Lower.Operator == \"GreaterThan\" or Upper.Operator == \"LessThan\")\n\tend\n\n\tlocal function AreInSameAndBranch(Conditions, FirstIndex: number, SecondIndex: number): boolean\n\t\tfor Index = FirstIndex + 1, SecondIndex do\n\t\t\tif Conditions[Index].Join == \"Or\" then\n\t\t\t\treturn false\n\t\t\tend\n\t\tend\n\t\treturn true\n\tend\n\n\tfunction Operators.Validate(Conditions, Adapter)\n\t\tlocal Errors = {}\n\t\tlocal Conflicts = {}\n\t\tlocal GetKey = Adapter and Adapter.GetKey or function(Condition)\n\t\t\treturn GetSubjectKey(Condition.Subject)\n\t\tend\n\t\tlocal GetLabel = Adapter and Adapter.GetLabel or function(Condition)\n\t\t\treturn FormatSubject(Condition.Subject)\n\t\tend\n\t\tlocal IsConditionValid = Adapter and Adapter.IsConditionValid or function(Condition)\n\t\t\treturn Operators.IsConditionValid(Conditions, Condition)\n\t\tend\n\n\t\tlocal function AddConflict(FirstIndex: number, SecondIndex: number, Message: string)\n\t\t\tConflicts[FirstIndex] = true\n\t\t\tConflicts[SecondIndex] = true\n\t\t\ttable.insert(Errors, Message)\n\t\tend\n\n\t\tfor Index, Condition in Conditions do\n\t\t\tif not IsConditionValid(Condition) then\n\t\t\t\tConflicts[Index] = true\n\t\t\t\ttable.insert(\n\t\t\t\t\tErrors,\n\t\t\t\t\t`{GetLabel(Condition)} has a value that is incompatible with {Operators.GetText(Condition.Operator, true)}.`\n\t\t\t\t)\n\t\t\tend\n\t\tend\n\n\t\tfor FirstIndex = 1, #Conditions do\n\t\t\tlocal First = Conditions[FirstIndex]\n\t\t\tfor SecondIndex = FirstIndex + 1, #Conditions do\n\t\t\t\tlocal Second = Conditions[SecondIndex]\n\t\t\t\tif Conflicts[FirstIndex] or Conflicts[SecondIndex] then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\t\t\t\tif GetKey(First) ~= GetKey(Second) or not AreInSameAndBranch(Conditions, FirstIndex, SecondIndex) then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\t\t\t\tlocal SubjectText = GetLabel(First)\n\n\t\t\t\tif First.Operator == \"Equals\" and Second.Operator == \"Equals\" and First.Value ~= Second.Value then\n\t\t\t\t\tAddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot equal both {FormatValue(First.Value)} and {FormatValue(Second.Value)}.`)\n\t\t\t\telseif\n\t\t\t\t\tFirst.Operator == \"Equals\" and Second.Operator == \"NotEquals\" and First.Value == Second.Value\n\t\t\t\t\tor First.Operator == \"NotEquals\" and Second.Operator == \"Equals\" and First.Value == Second.Value\n\t\t\t\tthen\n\t\t\t\t\tAddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot both equal and not equal {FormatValue(First.Value)}.`)\n\t\t\t\telseif First.Operator == \"TypeIs\" and Second.Operator == \"TypeIs\" and First.Value ~= Second.Value then\n\t\t\t\t\tAddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot have both type {First.Value} and {Second.Value}.`)\n\t\t\t\telseif NumericConditionsConflict(First, Second) then\n\t\t\t\t\tAddConflict(FirstIndex, SecondIndex, `{SubjectText} cannot satisfy both numeric comparisons.`)\n\t\t\t\telse\n\t\t\t\t\tlocal TypeCondition\n\t\t\t\t\tlocal OtherCondition\n\t\t\t\t\tif First.Operator == \"TypeIs\" then\n\t\t\t\t\t\tTypeCondition, OtherCondition = First, Second\n\t\t\t\t\telseif Second.Operator == \"TypeIs\" then\n\t\t\t\t\t\tTypeCondition, OtherCondition = Second, First\n\t\t\t\t\tend\n\n\t\t\t\t\tif TypeCondition and OtherCondition and OtherCondition.Operator ~= \"TypeIs\" then\n\t\t\t\t\t\tlocal Definition = Registry[OtherCondition.Operator]\n\t\t\t\t\t\tlocal TypeName = tostring(TypeCondition.Value)\n\t\t\t\t\t\tif Definition and Definition.AllowedTypes and not Definition.AllowedTypes[TypeName] then\n\t\t\t\t\t\t\tAddConflict(FirstIndex, SecondIndex, `{SubjectText} has type {TypeName}, so it cannot use {Definition.SummaryText or Definition.Text}.`)\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\n\t\treturn #Errors == 0, Errors, Conflicts\n\tend\n\n\twax.shared.CallFilterOperators = Operators\nend\n--#endregion\n\n--#region @include \"Src/Utils/CallFilter/RemoteFields.luau\" as \"wax.shared.CallFilterRemoteFields\"\ndo\n\tlocal Operators = wax.shared.CallFilterOperators or require(\"@src/Utils/CallFilter/Operators\")\n\n\tlocal RemoteFields = {}\n\n\tlocal RemoteClassOptions = {\n\t\t{ Value = \"RemoteEvent\", Text = \"RemoteEvent\" },\n\t\t{ Value = \"RemoteFunction\", Text = \"RemoteFunction\" },\n\t\t{ Value = \"UnreliableRemoteEvent\", Text = \"UnreliableRemoteEvent\" },\n\t\t{ Value = \"BindableEvent\", Text = \"BindableEvent\" },\n\t\t{ Value = \"BindableFunction\", Text = \"BindableFunction\" },\n\t}\n\n\tlocal Registry = {\n\t\tName = {\n\t\t\tText = \"Name\",\n\t\t\tGetValue = function(Remote)\n\t\t\t\treturn Remote.Name\n\t\t\tend,\n\t\t},\n\t\tClassName = {\n\t\t\tText = \"Class\",\n\t\t\tValueOptions = RemoteClassOptions,\n\t\t\tGetValue = function(Remote)\n\t\t\t\treturn Remote.ClassName\n\t\t\tend,\n\t\t},\n\t\tFullName = {\n\t\t\tText = \"Full path\",\n\t\t\tGetValue = function(Remote)\n\t\t\t\tlocal Success, Result = pcall(Remote.GetFullName, Remote)\n\t\t\t\treturn Success and Result or Remote.Name\n\t\t\tend,\n\t\t},\n\t}\n\n\tlocal Order = { \"Name\", \"ClassName\", \"FullName\" }\n\tlocal StringOperators = {\n\t\tEquals = true,\n\t\tNotEquals = true,\n\t\tContains = true,\n\t\tStartsWith = true,\n\t\tEndsWith = true,\n\t}\n\n\tfunction RemoteFields.Get(Field)\n\t\treturn Registry[Field]\n\tend\n\n\tfunction RemoteFields.GetOptions()\n\t\tlocal Options = {}\n\t\tfor _, Field in Order do\n\t\t\ttable.insert(Options, {\n\t\t\t\tValue = Field,\n\t\t\t\tText = Registry[Field].Text,\n\t\t\t})\n\t\tend\n\t\treturn Options\n\tend\n\n\tfunction RemoteFields.GetNames()\n\t\treturn table.clone(Order)\n\tend\n\n\tfunction RemoteFields.GetText(Field): string\n\t\tlocal Definition = Registry[Field]\n\t\treturn Definition and Definition.Text or tostring(Field)\n\tend\n\n\tfunction RemoteFields.GetValueOptions(Field)\n\t\tlocal Definition = Registry[Field]\n\t\treturn Definition and Definition.ValueOptions and table.clone(Definition.ValueOptions) or nil\n\tend\n\n\tfunction RemoteFields.IsValueAllowed(Field, Value): boolean\n\t\tlocal Options = RemoteFields.GetValueOptions(Field)\n\t\tif not Options then\n\t\t\treturn typeof(Value) == \"string\"\n\t\tend\n\n\t\tfor _, Option in Options do\n\t\t\tif Option.Value == Value then\n\t\t\t\treturn true\n\t\t\tend\n\t\tend\n\t\treturn false\n\tend\n\n\tfunction RemoteFields.IsOperatorAllowed(Operator, Field): boolean\n\t\tif Field == \"ClassName\" then\n\t\t\treturn Operator == \"Equals\" or Operator == \"NotEquals\"\n\t\tend\n\t\treturn StringOperators[Operator] == true\n\tend\n\n\tfunction RemoteFields.IsConditionValid(Condition): boolean\n\t\treturn Registry[Condition.Field] ~= nil\n\t\t\tand RemoteFields.IsOperatorAllowed(Condition.Operator, Condition.Field)\n\t\t\tand RemoteFields.IsValueAllowed(Condition.Field, Condition.Value)\n\tend\n\n\tfunction RemoteFields.Validate(Conditions)\n\t\treturn Operators.Validate(Conditions, {\n\t\t\tGetKey = function(Condition)\n\t\t\t\treturn Condition.Field\n\t\t\tend,\n\t\t\tGetLabel = function(Condition)\n\t\t\t\treturn RemoteFields.GetText(Condition.Field)\n\t\t\tend,\n\t\t\tIsConditionValid = RemoteFields.IsConditionValid,\n\t\t})\n\tend\n\n\tfunction RemoteFields.Matches(Conditions, Remote): boolean\n\t\treturn Operators.Matches(Conditions, function(Condition)\n\t\t\tlocal Definition = Registry[Condition.Field]\n\t\t\treturn Definition and Definition.GetValue(Remote) or nil\n\t\tend)\n\tend\n\n\twax.shared.CallFilterRemoteFields = RemoteFields\nend\n--#endregion\n\n--#region @include \"Src/Utils/CallFilter/Schema.luau\" as \"wax.shared.CallFilterSchema\"\ndo\n\t--// Imports \\\\--\n\tlocal Validation = wax.shared.Validation or require(\"@src/Utils/Validation\")\n\tlocal Operators = wax.shared.CallFilterOperators or require(\"@src/Utils/CallFilter/Operators\")\n\tlocal RemoteFields = wax.shared.CallFilterRemoteFields or require(\"@src/Utils/CallFilter/RemoteFields\")\n\n\tlocal Schema = Validation.Schema\n\n\t--// Helpers \\\\--\n\tlocal function GetOperatorNames()\n\t\tlocal Names = {}\n\t\tfor _, Option in Operators.GetOptions() do\n\t\t\ttable.insert(Names, Option.Value)\n\t\tend\n\t\treturn Names\n\tend\n\n\tlocal function IsConditionValueValid(Condition): boolean\n\t\treturn Operators.IsConditionValid({ Condition }, Condition)\n\tend\n\n\tlocal function HasNoConditionConflicts(Conditions): boolean\n\t\treturn Operators.Validate(Conditions)\n\tend\n\n\t--// Schemas \\\\--\n\tlocal Remote = Schema.instance():refine(function(Value)\n\t\treturn RemoteFields.IsValueAllowed(\"ClassName\", Value.ClassName)\n\tend, \"must be a supported remote\")\n\n\tlocal Subject = Schema.object({\n\t\tType = Schema.enum({ \"Argument\", \"ArgumentCount\" }),\n\t\tIndex = Schema.number():integer():min(1):optional(),\n\t}):refine(function(Value)\n\t\treturn Value.Type == \"ArgumentCount\" and Value.Index == nil or Value.Type == \"Argument\" and Value.Index ~= nil\n\tend, \"must provide an index only for argument subjects\")\n\n\tlocal Condition = Schema.object({\n\t\tSubject = Subject,\n\t\tOperator = Schema.enum(GetOperatorNames()),\n\t\tValue = Schema.any():optional(),\n\t\tJoin = Schema.enum({ \"And\", \"Or\" }):optional(),\n\t}):refine(IsConditionValueValid, \"has a value that is incompatible with its operator\")\n\n\tlocal ConditionArray = Schema.array(Condition):refine(HasNoConditionConflicts, \"contains conflicting conditions\")\n\tlocal Conditions = ConditionArray:default({})\n\n\tlocal RemoteCondition = Schema.object({\n\t\tField = Schema.enum(RemoteFields.GetNames()),\n\t\tOperator = Schema.enum(GetOperatorNames()),\n\t\tValue = Schema.string(),\n\t\tJoin = Schema.enum({ \"And\", \"Or\" }):optional(),\n\t}):refine(RemoteFields.IsConditionValid, \"has an operator or value that is incompatible with its field\")\n\n\tlocal RemoteConditions = Schema.array(RemoteCondition):refine(function(Value)\n\t\treturn #Value > 0 and RemoteFields.Validate(Value)\n\tend, \"must contain at least one non-conflicting remote condition\")\n\n\tlocal Target = Schema.union({\n\t\tSchema.object({\n\t\t\tType = Schema.literal(\"Instance\"),\n\t\t\tRemote = Remote,\n\t\t}),\n\t\tSchema.object({\n\t\t\tType = Schema.literal(\"Query\"),\n\t\t\tConditions = RemoteConditions,\n\t\t}),\n\t})\n\n\tlocal Filter = Schema.object({\n\t\tId = Schema.string():optional(),\n\t\tEnabled = Schema.boolean():default(true),\n\t\tTarget = Target,\n\t\tDirection = Schema.enum({ \"Outgoing\", \"Incoming\", \"Any\" }),\n\t\tConditions = Conditions,\n\t\tAction = Schema.enum({ \"Ignore\", \"Block\", \"Highlight\" }):default(\"Ignore\"),\n\t})\n\n\tlocal Update = Schema.object({\n\t\tEnabled = Schema.boolean():optional(),\n\t\tTarget = Target:optional(),\n\t\tDirection = Schema.enum({ \"Outgoing\", \"Incoming\", \"Any\" }):optional(),\n\t\tConditions = ConditionArray:optional(),\n\t\tAction = Schema.enum({ \"Ignore\", \"Block\", \"Highlight\" }):optional(),\n\t})\n\n\twax.shared.CallFilterSchema = {\n\t\tRemote = Remote,\n\t\tSubject = Subject,\n\t\tCondition = Condition,\n\t\tConditions = Conditions,\n\t\tRemoteCondition = RemoteCondition,\n\t\tRemoteConditions = RemoteConditions,\n\t\tTarget = Target,\n\t\tFilter = Filter,\n\t\tUpdate = Update,\n\t}\nend\n--#endregion\n\n--#region @include \"Src/Utils/CallFilter/Manager.luau\" as \"wax.shared.CallFilters\"\ndo\n\tlocal Operators = wax.shared.CallFilterOperators or require(\"@src/Utils/CallFilter/Operators\")\n\tlocal InstanceSerializer = wax.shared.InstanceSerializer or require(\"@src/Utils/CodeGen/Serializer/Instance\")\n\tlocal Validation = wax.shared.Validation or require(\"@src/Utils/Validation\")\n\tlocal CallFilterSchema = wax.shared.CallFilterSchema or require(\"@src/Utils/CallFilter/Schema\")\n\tlocal RemoteFields = wax.shared.CallFilterRemoteFields or require(\"@src/Utils/CallFilter/RemoteFields\")\n\n\tlocal CallFilters = {\n\t\tItems = {},\n\t\tById = {},\n\t\tListeners = {},\n\t}\n\n\tlocal ActionPriorities = {\n\t\tHighlight = 1,\n\t\tIgnore = 2,\n\t\tBlock = 3,\n\t}\n\n\tlocal function Validate(Data, DataSchema, Context: string)\n\t\tlocal IsValid, Result, Errors = Validation.ValidateSchema(Data, DataSchema)\n\t\tassert(IsValid, `{Context}: {Errors[1] or \"validation failed\"}`)\n\t\treturn Result\n\tend\n\n\tlocal function CopyFilter(Filter)\n\t\tlocal Copy = table.clone(Filter)\n\t\tCopy.Conditions = {}\n\n\t\tfor _, Condition in Filter.Conditions or {} do\n\t\t\tlocal ConditionCopy = table.clone(Condition)\n\t\t\tConditionCopy.Subject = table.clone(Condition.Subject)\n\t\t\ttable.insert(Copy.Conditions, ConditionCopy)\n\t\tend\n\n\t\tCopy.Target = table.clone(Filter.Target)\n\t\tif Filter.Target.Type == \"Query\" then\n\t\t\tCopy.Target.Conditions = {}\n\t\t\tfor _, Condition in Filter.Target.Conditions do\n\t\t\t\ttable.insert(Copy.Target.Conditions, table.clone(Condition))\n\t\t\tend\n\t\tend\n\n\t\tCopy.Enabled = Filter.Enabled ~= false\n\t\treturn Copy\n\tend\n\n\tlocal function EmitChanged()\n\t\tlocal Snapshot = CallFilters:GetAll()\n\t\tfor Listener in CallFilters.Listeners do\n\t\t\tif task then\n\t\t\t\ttask.spawn(Listener, Snapshot)\n\t\t\telse\n\t\t\t\tListener(Snapshot)\n\t\t\tend\n\t\tend\n\tend\n\n\tfunction CallFilters:GetAll()\n\t\tlocal Filters = {}\n\t\tfor _, Filter in self.Items do\n\t\t\ttable.insert(Filters, CopyFilter(Filter))\n\t\tend\n\t\treturn Filters\n\tend\n\n\tfunction CallFilters:Get(Id: string)\n\t\tlocal Filter = self.ById[Id]\n\t\treturn Filter and CopyFilter(Filter) or nil\n\tend\n\n\tfunction CallFilters:Add(Filter)\n\t\tlocal Copy = Validate(Filter, CallFilterSchema.Filter, \"Invalid call filter\")\n\t\tCopy.Id = Copy.Id or wax.shared.HttpService:GenerateGUID(false)\n\t\tassert(not self.ById[Copy.Id], `A call filter with id {Copy.Id} already exists`)\n\n\t\ttable.insert(self.Items, Copy)\n\t\tself.ById[Copy.Id] = Copy\n\t\tEmitChanged()\n\t\treturn CopyFilter(Copy)\n\tend\n\n\tfunction CallFilters:Update(Id: string, Changes)\n\t\tlocal Filter = self.ById[Id]\n\t\tif not Filter then\n\t\t\treturn nil\n\t\tend\n\n\t\tlocal ValidChanges = Validate(Changes, CallFilterSchema.Update, \"Invalid call filter update\")\n\t\tlocal Updated = CopyFilter(Filter)\n\t\tfor Key, Value in ValidChanges do\n\t\t\tUpdated[Key] = Value\n\t\tend\n\t\tUpdated = Validate(Updated, CallFilterSchema.Filter, \"Invalid updated call filter\")\n\n\t\tlocal Index = table.find(self.Items, Filter)\n\t\tif Index then\n\t\t\tself.Items[Index] = Updated\n\t\tend\n\t\tself.ById[Id] = Updated\n\n\t\tEmitChanged()\n\t\treturn CopyFilter(Updated)\n\tend\n\n\tfunction CallFilters:SetEnabled(Id: string, Enabled: boolean)\n\t\treturn self:Update(Id, { Enabled = Enabled })\n\tend\n\n\tfunction CallFilters:Remove(Id: string): boolean\n\t\tlocal Filter = self.ById[Id]\n\t\tif not Filter then\n\t\t\treturn false\n\t\tend\n\n\t\tself.ById[Id] = nil\n\t\tlocal Index = table.find(self.Items, Filter)\n\t\tif Index then\n\t\t\ttable.remove(self.Items, Index)\n\t\tend\n\t\tEmitChanged()\n\t\treturn true\n\tend\n\n\tfunction CallFilters:ReplaceAll(Filters, Silent: boolean?)\n\t\tlocal Validated = Validate(Filters or {}, Validation.Schema.array(CallFilterSchema.Filter), \"Invalid call filters\")\n\t\tlocal SeenIds = {}\n\t\tfor _, Filter in Validated do\n\t\t\tFilter.Id = Filter.Id or wax.shared.HttpService:GenerateGUID(false)\n\t\t\tassert(not SeenIds[Filter.Id], `A call filter with id {Filter.Id} already exists`)\n\t\t\tSeenIds[Filter.Id] = true\n\t\tend\n\n\t\ttable.clear(self.Items)\n\t\ttable.clear(self.ById)\n\t\tfor _, Filter in Validated do\n\t\t\ttable.insert(self.Items, Filter)\n\t\t\tself.ById[Filter.Id] = Filter\n\t\tend\n\n\t\tif not Silent then\n\t\t\tEmitChanged()\n\t\tend\n\tend\n\n\tfunction CallFilters:Subscribe(Listener)\n\t\tself.Listeners[Listener] = true\n\t\tListener(self:GetAll())\n\n\t\tlocal Subscription = {}\n\t\tfunction Subscription:Disconnect()\n\t\t\tCallFilters.Listeners[Listener] = nil\n\t\tend\n\t\treturn Subscription\n\tend\n\n\tfunction CallFilters:Match(Remote: Instance, Direction: string, Arguments)\n\t\tlocal WinningAction\n\t\tlocal WinningFilter\n\t\tlocal WinningPriority = 0\n\n\t\tfor _, Filter in self.Items do\n\t\t\tlocal TargetMatches = if Filter.Target.Type == \"Instance\"\n\t\t\t\tthen InstanceSerializer.IsEqualToInstance(Filter.Target.Remote, Remote)\n\t\t\t\telse RemoteFields.Matches(Filter.Target.Conditions, Remote)\n\t\t\tif\n\t\t\t\tFilter.Enabled\n\t\t\t\tand (Filter.Direction == \"Any\" or Filter.Direction == Direction)\n\t\t\t\tand TargetMatches\n\t\t\t\tand Operators.MatchesConditions(Filter.Conditions, Arguments)\n\t\t\tthen\n\t\t\t\tlocal Priority = ActionPriorities[Filter.Action] or 0\n\t\t\t\tif Priority > WinningPriority then\n\t\t\t\t\tWinningAction = Filter.Action\n\t\t\t\t\tWinningFilter = Filter\n\t\t\t\t\tWinningPriority = Priority\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\n\t\treturn WinningAction, WinningFilter and CopyFilter(WinningFilter) or nil\n\tend\n\n\tfunction CallFilters:Resolve(Remote: Instance, Direction: string, Info)\n\t\tlocal Action, Filter = self:Match(Remote, Direction, Info.Arguments or {})\n\t\tif Action == \"Highlight\" then\n\t\t\tInfo.Highlighted = true\n\t\t\tInfo.CallFilterId = Filter.Id\n\t\telseif Action then\n\t\t\tInfo.CallFilterId = Filter.Id\n\t\tend\n\t\treturn Action, Filter\n\tend\n\n\twax.shared.CallFilters = CallFilters\nend\n--#endregion\n\n--#region @include region IsPlayerModule\nwax.shared.IsPlayerModule = function(Origin: LocalScript | ModuleScript, Instance: Instance): boolean\n\tif Instance and Instance.ClassName ~= \"BindableEvent\" then\n\t\treturn false\n\tend\n\n\tif not Origin or typeof(Origin) ~= \"Instance\" or not Origin.IsA(Origin, \"LuaSourceContainer\") then\n\t\treturn false\n\tend\n\n\tlocal PlayerModule = Origin and Origin.FindFirstAncestor(Origin, \"PlayerModule\") or nil\n\tif not PlayerModule then\n\t\treturn false\n\tend\n\n\tif PlayerModule.Parent == nil then\n\t\treturn true\n\tend\n\n\tif wax.shared.PlayerScripts then\n\t\treturn compareinstances(PlayerModule.Parent, wax.shared.PlayerScripts)\n\tend\n\n\treturn false\nend\nwax.shared.ShouldIgnore = function(Instance, Origin)\n\tif not wax.shared.Settings.LogRobloxInternalEvents.Value then\n\t\tif Instance.IsDescendantOf(Instance, wax.shared.RobloxReplicatedStorage) then\n\t\t\treturn true\n\t\tend\n\tend\n\n\treturn wax.shared.Settings.IgnoredRemotesDropdown.Value[Instance.ClassName] == true\n\t\tor (wax.shared.Settings.IgnorePlayerModule.Value and wax.shared.IsPlayerModule(Origin, Instance))\nend\n--#endregion\n\n--#region @include \"Src/Utils/Log.luau\" as \"wax.shared.Log\"\ndo\n\tlocal Log = {}\n\tLog.__index = Log\n\n\tlocal PendingCallDecisions = setmetatable({}, { __mode = \"k\" })\n\n\t--// Log Call Queue \\\\--\n\twax.shared.LogNotificationQueue = {\n\t\tItems = {},\n\t\tHead = 1,\n\t\tTail = 0,\n\t}\n\n\tlocal function QueueNotification(LogObject, CallIndex: number)\n\t\tlocal Queue = wax.shared.LogNotificationQueue\n\t\tQueue.Tail += 1\n\t\tQueue.Items[Queue.Tail] = {\n\t\t\tInstance = LogObject.Instance,\n\t\t\tType = LogObject.Type,\n\t\t\tLogIndex = LogObject.Index,\n\t\t\tCallIndex = CallIndex,\n\t\t}\n\tend\n\n\t--// Auto Ignore Constants \\\\--\n\tlocal SpamCallCountThreshold = 15\n\tlocal SpamTimeWindowSeconds = 1\n\tlocal AutoIgnoreSpammyEvents = false\n\n\tif not wax.shared.IS_ACTOR then\n\t\twax.shared.Connect(wax.shared.RunService.Heartbeat:Connect(function()\n\t\t\tlocal Queue = wax.shared.LogNotificationQueue\n\t\t\tlocal Tail = Queue.Tail\n\n\t\t\tif Queue.Head > Tail then\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tlocal Batch = {}\n\t\t\tlocal BatchSize = 0\n\t\t\twhile Queue.Head <= Tail do\n\t\t\t\tlocal Notification = Queue.Items[Queue.Head]\n\t\t\t\tQueue.Items[Queue.Head] = nil\n\t\t\t\tQueue.Head += 1\n\n\t\t\t\tif Notification then\n\t\t\t\t\tBatchSize += 1\n\t\t\t\t\tBatch[BatchSize] = Notification\n\t\t\t\tend\n\t\t\tend\n\n\t\t\ttable.clear(Queue.Items)\n\t\t\tQueue.Head = 1\n\t\t\tQueue.Tail = 0\n\n\t\t\tif BatchSize > 0 then\n\t\t\t\tlocal Communicator = wax.shared.Communicator\n\t\t\t\tif Communicator then\n\t\t\t\t\tAutoIgnoreSpammyEvents = wax.shared.SaveManager:GetState(\"AutoIgnoreSpammyEvents\", false)\n\t\t\t\t\tCommunicator:Fire(Batch)\n\t\t\t\tend\n\n\t\t\t\ttable.clear(Batch)\n\t\t\tend\n\t\tend))\n\tend\n\n\t--// Actor Table Fixing \\\\--\n\tlocal FunctionToMetatadata, FixTable\n\tdo\n\t\tif wax.shared.IS_ACTOR then\n\t\t\tlocal FunctionMetadataCache = setmetatable({}, { __mode = \"k\" })\n\n\t\t\tlocal function CreateTraversalState(Refs)\n\t\t\t\treturn {\n\t\t\t\t\tCyclicRefs = Refs or {},\n\t\t\t\t\tTableIds = setmetatable({}, { __mode = \"k\" }),\n\t\t\t\t\tFunctions = setmetatable({}, { __mode = \"k\" }),\n\t\t\t\t\tNextId = 0,\n\t\t\t\t}\n\t\t\tend\n\n\t\t\tlocal function GenerateId(State)\n\t\t\t\tState.NextId += 1\n\t\t\t\treturn State.NextId\n\t\t\tend\n\n\t\t\tFixTable = function(Table, State)\n\t\t\t\tif not Table then\n\t\t\t\t\treturn nil\n\t\t\t\tend\n\n\t\t\t\tif not State or not State.CyclicRefs then\n\t\t\t\t\tState = CreateTraversalState(State)\n\t\t\t\tend\n\n\t\t\t\tlocal CyclicRefs = State.CyclicRefs\n\t\t\t\tlocal TableId = State.TableIds[Table]\n\t\t\t\tif not TableId then\n\t\t\t\t\tTableId = GenerateId(State)\n\t\t\t\t\tState.TableIds[Table] = TableId\n\t\t\t\tend\n\n\t\t\t\tlocal OutputTable = {}\n\t\t\t\tCyclicRefs[TableId] = OutputTable\n\n\t\t\t\tlocal ContainsCyclicRef = false\n\n\t\t\t\tfor Key, Value in next, Table do\n\t\t\t\t\tif type(Value) == \"table\" then\n\t\t\t\t\t\tlocal ExistingId = State.TableIds[Value]\n\t\t\t\t\t\tif ExistingId then\n\t\t\t\t\t\t\tContainsCyclicRef = true\n\n\t\t\t\t\t\t\tOutputTable[Key] = {\n\t\t\t\t\t\t\t\t__CyclicRef = true,\n\t\t\t\t\t\t\t\t__Id = ExistingId,\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tcontinue\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tif getmetatable(Value) then\n\t\t\t\t\t\t\tOutputTable[Key] =\n\t\t\t\t\t\t\t\t\"Cobalt: Impossible to bridge table with metatable from actor Environment to main Environment\"\n\t\t\t\t\t\t\tcontinue\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tlocal Result, _, ContainsCyclic = FixTable(Value, State)\n\t\t\t\t\t\tif not Result then\n\t\t\t\t\t\t\tcontinue\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tOutputTable[Key] = Result\n\t\t\t\t\t\tContainsCyclicRef = ContainsCyclicRef or ContainsCyclic\n\t\t\t\t\telseif type(Value) == \"function\" then\n\t\t\t\t\t\tOutputTable[Key] = FunctionToMetatadata(Value, State)\n\t\t\t\t\telse\n\t\t\t\t\t\tOutputTable[Key] = Value\n\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\treturn OutputTable, CyclicRefs, ContainsCyclicRef\n\t\t\tend\n\n\t\t\tFunctionToMetatadata = function(Function, State)\n\t\t\t\tif not Function then\n\t\t\t\t\treturn nil\n\t\t\t\tend\n\n\t\t\t\tif not State or not State.CyclicRefs then\n\t\t\t\t\tState = CreateTraversalState()\n\t\t\t\tend\n\n\t\t\t\tlocal CachedMetadata = FunctionMetadataCache[Function]\n\t\t\t\tif CachedMetadata then\n\t\t\t\t\treturn CachedMetadata\n\t\t\t\tend\n\n\t\t\t\tlocal Metadata = {\n\t\t\t\t\tAddress = tostring(Function),\n\t\t\t\t\tName = debug.info(Function, \"n\"),\n\t\t\t\t\tSource = debug.info(Function, \"s\"),\n\t\t\t\t\tIsC = iscclosure(Function),\n\t\t\t\t}\n\n\t\t\t\tif State.Functions[Function] then\n\t\t\t\t\tMetadata[\"Recursive\"] = true\n\t\t\t\t\tMetadata[\"Validation\"] = Data.Token\n\t\t\t\t\tMetadata[\"__Function\"] = true\n\n\t\t\t\t\treturn Metadata\n\t\t\t\tend\n\n\t\t\t\tState.Functions[Function] = true\n\n\t\t\t\tif not iscclosure(Function) then\n\t\t\t\t\tMetadata[\"Upvalues\"] = debug.getupvalues and #debug.getupvalues(Function) or 0\n\t\t\t\t\tMetadata[\"Constants\"] = debug.getconstants and #debug.getconstants(Function) or 0\n\t\t\t\t\tMetadata[\"Protos\"] = debug.getprotos and #debug.getprotos(Function) or 0\n\n\t\t\t\t\tif getfunctionhash then\n\t\t\t\t\t\tMetadata[\"FunctionHash\"] = getfunctionhash(Function)\n\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\t-- to validate that this function was generated by FunctionToMetatadata\n\t\t\t\tMetadata[\"Validation\"] = Data.Token\n\t\t\t\tMetadata[\"__Function\"] = true\n\n\t\t\t\tFunctionMetadataCache[Function] = Metadata\n\n\t\t\t\treturn Metadata\n\t\t\tend\n\t\tend\n\tend\n\n\t--// Cloning \\\\--\n\tfunction DeepClone(OriginalValue, ValueCopies)\n\t\tif wax.shared.IS_ACTOR then\n\t\t\treturn OriginalValue\n\t\tend\n\n\t\tlocal ValueType = type(OriginalValue)\n\t\tif ValueType == \"userdata\" then\n\t\t\tlocal ValueRobloxType = typeof(OriginalValue)\n\n\t\t\tif ValueRobloxType == \"Instance\" then\n\t\t\t\treturn cloneref(OriginalValue)\n\n\t\t\telseif ValueRobloxType == \"userdata\" then\n\t\t\t\tif getmetatable(OriginalValue) then\n\t\t\t\t\treturn newproxy(true)\n\t\t\t\telse\n\t\t\t\t\treturn newproxy()\n\t\t\t\tend\n\n\t\t\telse\n\t\t\t\treturn OriginalValue\n\t\t\tend\n\n\t\telseif ValueType == \"function\" then\n\t\t\tif clonefunction then\n\t\t\t\treturn clonefunction(OriginalValue)\n\t\t\telse\n\t\t\t\treturn OriginalValue\n\t\t\tend\n\n\t\telseif ValueType ~= \"table\" then\n\t\t\treturn OriginalValue\n\t\tend\n\n\t\t-- Cycle detection\n\t\tif ValueCopies then\n\t\t\tlocal CachedValue = ValueCopies[OriginalValue]\n\t\t\tif CachedValue then\n\t\t\t\treturn CachedValue\n\t\t\tend\n\t\telse\n\t\t\tValueCopies = {}\n\t\tend\n\n\t\t-- Shallow copy first, then selectively recurse\n\t\tlocal ShallowCopy = table.create(rawlen(OriginalValue))\n\t\tValueCopies[OriginalValue] = ShallowCopy\n\n\t\tfor Key, Value in next, OriginalValue do\n\t\t\tlocal ClonedKey = DeepClone(Key, ValueCopies)\n\t\t\tShallowCopy[ClonedKey] = DeepClone(Value, ValueCopies)\n\t\tend\n\n\t\treturn ShallowCopy\n\tend\n\n\tif wax.shared.IS_ACTOR then\n\t\twax.shared.SerializeActorInfo = function(Info)\n\t\t\treturn FixTable(DeepClone(Info))\n\t\tend\n\tend\n\n\tfunction Log.new(Instance, Type, Index, CallingScript)\n\t\tlocal NewLog = setmetatable({\n\t\t\tInstance = Instance,\n\t\t\tType = Type,\n\t\t\tIndex = Index,\n\t\t\tCalls = {},\n\t\t\tGameCalls = {},\n\t\t\tSpamWindowStart = 0,\n\t\t\tSpamCallCount = 0,\n\t\t\tIgnored = false,\n\t\t\tBlocked = false,\n\t\t\tButton = nil,\n\t\t}, Log)\n\n\t\treturn NewLog\n\tend\n\n\tfunction Log:IsOverSpamThreshold()\n\t\tif not AutoIgnoreSpammyEvents then\n\t\t\treturn false\n\t\tend\n\n\t\tlocal Now = tick()\n\t\tif Now - self.SpamWindowStart > SpamTimeWindowSeconds then\n\t\t\tself.SpamWindowStart = Now\n\t\t\tself.SpamCallCount = 0\n\t\tend\n\n\t\tself.SpamCallCount = self.SpamCallCount + 1\n\n\t\tif self.SpamCallCount > SpamCallCountThreshold then\n\t\t\tif not self.Ignored then\n\t\t\t\tself.Ignore(self)\n\t\t\t\twax.shared.Sonner.info(`Ignored {self.Instance.Name} ({self.Type}) due to event spam.`)\n\t\t\tend\n\n\t\t\treturn true\n\t\tend\n\n\t\treturn false\n\tend\n\n\tlocal function RunInterceptors(Interceptors: { (...any) -> ...any }, Info: any, Log): boolean\n\t\tfor _, Callback in Interceptors do\n\t\t\tlocal Ok, Result = pcall(Callback, Info, Log.Instance, Log.Type)\n\t\t\tif not Ok then\n\t\t\t\twarn(`[Cobalt Plugin Interceptor] Error: {Result}`)\n\t\t\telseif Result == false then\n\t\t\t\treturn true\n\t\t\tend\n\t\tend\n\n\t\treturn false\n\tend\n\n\tfunction Log:ShouldBlock(RawInfo, PendingCallDecisionsKey): boolean\n\t\tPendingCallDecisionsKey = PendingCallDecisionsKey or tostring(RawInfo)\n\n\t\tlocal Decision = PendingCallDecisions[PendingCallDecisionsKey]\n\t\tif Decision then\n\t\t\treturn Decision.ShouldBlock\n\t\tend\n\n\t\tlocal FilterAction\n\t\tlocal CallFilters = wax.shared.CallFilters\n\t\tdo\n\t\t\tif CallFilters then\n\t\t\t\tFilterAction = CallFilters:Resolve(self.Instance, self.Type, RawInfo)\n\t\t\tend\n\t\tend\n\n\t\tlocal ShouldBlock = RawInfo.Blocked == true or self.Blocked or FilterAction == \"Block\"\n\t\tif ShouldBlock then\n\t\t\tRawInfo.Blocked = true\n\t\tend\n\n\t\tPendingCallDecisions[PendingCallDecisionsKey] = {\n\t\t\tFilterAction = FilterAction,\n\t\t\tShouldBlock = ShouldBlock,\n\t\t}\n\t\treturn ShouldBlock\n\tend\n\n\tfunction Log:Call(RawInfo): number?\n\t\tlocal PendingCallDecisionsKey = tostring(RawInfo)\n\n\t\tlocal ShouldBlock = self:ShouldBlock(RawInfo, PendingCallDecisionsKey)\n\t\tlocal Decision = PendingCallDecisions[PendingCallDecisionsKey]\n\t\tPendingCallDecisions[PendingCallDecisionsKey] = nil\n\n\t\tlocal ShouldCapture = not self.Ignored and Decision.FilterAction ~= \"Ignore\"\n\t\tdo\n\t\t\tif ShouldBlock then\n\t\t\t\tShouldCapture = ShouldCapture and wax.shared.SaveManager:GetState(\"LogBlockedRemotes\", false)\n\t\t\tend\n\n\t\t\tif RawInfo.Omit then\n\t\t\t\tShouldCapture = false\n\t\t\tend\n\t\tend\n\n\t\tif not ShouldCapture then\n\t\t\treturn nil\n\t\tend\n\n\t\t--// Ratelimiting \\\\--\n\t\tif not wax.shared.IS_ACTOR then\n\t\t\tlocal Success, SpamData = pcall(function() return self.IsOverSpamThreshold(self) end)\n\t\t\tif Success and SpamData then\n\t\t\t\treturn nil\n\t\t\tend\n\t\tend\n\n\t\t--// Info stuff \\\\--\n\t\tlocal Info = DeepClone(RawInfo)\n\t\tInfo.CreationTime = tick()\n\n\t\t--// Actor Relaying \\\\--\n\t\tif wax.shared.IS_ACTOR then\n\t\t\tif self.Instance == wax.shared.Communicator then\n\t\t\t\treturn nil\n\t\t\tend\n\n\t\t\tInfo[\"Actor\"] = CurrentActor\n\n\t\t\t--// Fix Arguments \\\\--\n\t\t\tlocal OldArguments = Info.Arguments\n\t\t\tInfo.Arguments = {\n\t\t\t\tData = OldArguments,\n\t\t\t\tn = OldArguments.n,\n\t\t\t}\n\n\t\t\tif Info.InvokeResult then\n\t\t\t\tlocal OldInvokeResult = Info.InvokeResult\n\t\t\t\tInfo.InvokeResult = {\n\t\t\t\t\tData = OldInvokeResult,\n\t\t\t\t\tn = OldInvokeResult.n,\n\t\t\t\t}\n\t\t\tend\n\n\t\t\tlocal FixedInfo, CyclicRefs, ContainsCyclicRef = FixTable(Info)\n\n\t\t\t-- Seliware puts their actor BindableEvents in CoreGui\n\t\t\tlocal identity = getthreadidentity()\n\t\t\tsetthreadidentity(8)\n\t\t\twax.shared.Communicator.Fire(\n\t\t\t\twax.shared.Communicator,\n\t\t\t\t\"ActorCall\",\n\t\t\t\tself.Instance,\n\t\t\t\tself.Type,\n\t\t\t\tFixedInfo,\n\t\t\t\tCyclicRefs,\n\t\t\t\tContainsCyclicRef\n\t\t\t)\n\t\t\tsetthreadidentity(identity)\n\t\t\treturn nil\n\t\tend\n\n\t\t--// Plugin Interceptors \\\\--\n\t\tlocal PluginManager = wax.shared.CobaltPluginManager\n\t\tif PluginManager and PluginManager.HasInterceptors then\n\t\t\t-- Run Instance-specific interceptors (both exact type and \"All\")\n\t\t\tlocal InstanceIntercept = PluginManager.Registry.Interceptors.Instance[self.Instance]\n\t\t\tif InstanceIntercept then\n\t\t\t\tif InstanceIntercept[self.Type] and RunInterceptors(InstanceIntercept[self.Type], Info, self) then\n\t\t\t\t\treturn nil\n\t\t\t\tend\n\t\t\t\tif InstanceIntercept[\"All\"] and RunInterceptors(InstanceIntercept[\"All\"], Info, self) then\n\t\t\t\t\treturn nil\n\t\t\t\tend\n\t\t\tend\n\n\t\t\t-- Run Global interceptors (both exact type and \"All\")\n\t\t\tlocal GlobalByType = PluginManager.Registry.Interceptors.Global[self.Type]\n\t\t\tif GlobalByType and RunInterceptors(GlobalByType, Info, self) then\n\t\t\t\treturn nil\n\t\t\tend\n\n\t\t\tlocal GlobalAll = PluginManager.Registry.Interceptors.Global[\"All\"]\n\t\t\tif GlobalAll and RunInterceptors(GlobalAll, Info, self) then\n\t\t\t\treturn nil\n\t\t\tend\n\t\tend\n\n\t\t--// Update Log \\\\--\n\t\tlocal Index = #self.Calls + 1\n\t\tself.Calls[Index] = Info\n\t\tif not Info.IsExecutor then\n\t\t\ttable.insert(self.GameCalls, Index)\n\t\tend\n\n\t\tQueueNotification(self, Index)\n\t\treturn Index\n\tend\n\n\tfunction Log:ClearCalls()\n\t\ttable.clear(self.Calls)\n\t\ttable.clear(self.GameCalls)\n\tend\n\n\tfunction Log:Ignore()\n\t\tself.Ignored = not self.Ignored\n\n\t\tif not wax.shared.IS_ACTOR then\n\t\t\tif wax.shared.ActorCommunicator then\n\t\t\t\tpcall(wax.shared.ActorCommunicator.Fire, wax.shared.ActorCommunicator, \"MainIgnore\", self.Instance, self.Type)\n\t\t\tend\n\n\t\t\tlocal IgnoredRemoteList = wax.shared.Settings[\"IgnoredRemotes\"]\n\t\t\tif IgnoredRemoteList then\n\t\t\t\tif self.Ignored then\n\t\t\t\t\tIgnoredRemoteList:AddToList(self)\n\t\t\t\telse\n\t\t\t\t\tIgnoredRemoteList:RemoveFromList(self)\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\n\n\tlocal ClassesConnectionsToggle = {\n\t\tRemoteEvent = \"OnClientEvent\",\n\t\tUnreliableRemoteEvent = \"OnClientEvent\",\n\t\tBindableEvent = \"Event\",\n\t}\n\n\tfunction Log:SetConnectionsEnabled(enabled: boolean)\n\t\tif not self.Instance or not ClassesConnectionsToggle[self.Instance.ClassName] then\n\t\t\treturn\n\t\tend\n\n\t\tlocal ConnectionName = ClassesConnectionsToggle[self.Instance.ClassName]\n\t\tif self.Type ~= \"Incoming\" or not ConnectionName then\n\t\t\treturn\n\t\tend\n\n\t\tlocal LoggingFunctions = wax.shared.IncomingLogConnectionFunctions\n\t\tfor _, Connection in pairs(getconnections(self.Instance[ConnectionName])) do\n\t\t\tif LoggingFunctions and LoggingFunctions[Connection.Function] then\n\t\t\t\tcontinue\n\t\t\tend\n\n\t\t\tif enabled then\n\t\t\t\tConnection:Enable()\n\t\t\telse\n\t\t\t\tConnection:Disable()\n\t\t\tend\n\t\tend\n\tend\n\n\tfunction Log:Block()\n\t\tif not wax.shared.IS_ACTOR and wax.shared.ActorCommunicator then\n\t\t\tpcall(wax.shared.ActorCommunicator.Fire, wax.shared.ActorCommunicator, \"MainBlock\", self.Instance, self.Type)\n\t\tend\n\n\t\tself.Blocked = not self.Blocked\n\t\tself:SetConnectionsEnabled(not self.Blocked)\n\tend\n\n\tfunction Log:SetButton(Instance, Name, Calls)\n\t\tself.Button = {\n\t\t\tInstance = Instance,\n\t\t\tName = Name,\n\t\t\tCalls = Calls,\n\t\t}\n\tend\n\n\twax.shared.Log = Log\nend\n--#endregion\n\n--#region @include \"Src/Spy/Hooks/Luau/Interceptors/Incoming.luau\" as \"wax.shared.IncomingInterceptor\"\ndo\n\t--// Variables \\\\--\n\tlocal setfenv = setfenv\n\tlocal getconnections = wax.shared.ExecutorSupport[\"getconnections\"].IsWorking and getconnections or function() return {} end\n\n\tlocal ClassesToHook = {\n\t\tRemoteEvent = \"OnClientEvent\",\n\t\tRemoteFunction = \"OnClientInvoke\",\n\t\tUnreliableRemoteEvent = \"OnClientEvent\",\n\t\tBindableEvent = \"Event\",\n\t\tBindableFunction = \"OnInvoke\",\n\t}\n\n\tlocal ConnectionKeys = CreateLookupTable({\n\t\t\"Connect\",\n\t\t\"ConnectParallel\",\n\t\t\"connect\",\n\t\t\"connectParallel\",\n\t\t\"Once\",\n\t})\n\n\t--// State \\\\--\n\tlocal ConnectionsEnabled = false\n\tlocal CallbacksEnabled = false\n\tlocal ConnectionHookEnabled = false\n\n\t--// Signals & Detours \\\\--\n\tlocal LogConnectionFunctions = {}\n\tlocal CallbackOwners = setmetatable({}, { __mode = \"k\" })\n\tlocal SignalMapping = setmetatable({}, { __mode = \"kv\" })\n\tlocal ObservedConnectionInstances = setmetatable({}, { __mode = \"k\" })\n\twax.shared.IncomingLogConnectionFunctions = LogConnectionFunctions\n\n\tlocal CobaltObserverEnvironmentKey = \"__CobaltIncomingObserver\"\n\n\t--// Types \\\\--\n\ttype InstancesToHook = RemoteEvent | UnreliableRemoteEvent | RemoteFunction | BindableEvent | BindableFunction\n\ttype MethodsToHook = \"OnClientEvent\" | \"OnClientInvoke\" | \"Event\" | \"OnInvoke\"\n\texport type Options = {\n\t\tConnections: boolean?,\n\t\tCallbacks: boolean?,\n\t\tHookConnections: boolean?,\n\t}\n\n\t--// Functions \\\\--\n\tlocal function GetLog(Instance: InstancesToHook, Function: (...any) -> ...any)\n\t\tlocal DebugId = wax.shared.GetDebugId(Instance)\n\n\t\tif wax.shared.ShouldIgnore(Instance, getcallingscript()) or LogConnectionFunctions[Function] then\n\t\t\treturn nil\n\t\tend\n\n\t\tlocal IncomingLogs = wax.shared.Logs.Incoming\n\t\tif not IncomingLogs then\n\t\t\treturn nil\n\t\tend\n\n\t\tlocal Log = IncomingLogs[DebugId]\n\t\tif not Log then\n\t\t\tLog = wax.shared.NewLog(Instance, \"Incoming\", getcallingscript(), DebugId)\n\t\tend\n\n\t\treturn Log\n\tend\n\n\tlocal function ResolveCallableFunction(Value: any): ((...any) -> ...any)?\n\t\tif typeof(Value) == \"function\" then\n\t\t\treturn Value\n\t\tend\n\n\t\tlocal Success, Metatable = pcall(wax.shared.getrawmetatable, Value)\n\t\tif not Success or not Metatable then\n\t\t\treturn nil\n\t\tend\n\n\t\tlocal HasCall, Call = pcall(rawget, Metatable, \"__call\")\n\t\treturn if HasCall and typeof(Call) == \"function\" then Call else nil\n\tend\n\n\t--[[\n\t\tIndividually logs an incoming remote call.\n\n\t\t@param Instance The instance that was called.\n\t\t@param Function The function that was called, if applicable.\n\t\t@param Info The information about the call, including arguments and origin. Can be nil.\n\t\t@param ... The arguments passed from the server to the client.\n\t\t@return boolean, Log? Returns true if the call was blocked, plus the log when one was used.\n\t]]\n\tlocal function LogRemote(\n\t\tInstance: InstancesToHook,\n\t\tFunction: (...any) -> ...any,\n\t\tInfo: {\n\t\t\tArguments: { [number]: any, n: number },\n\t\t\tOrigin: Instance,\n\t\t\tFunction: (...any) -> ...any,\n\t\t\tLine: number,\n\t\t\tIsExecutor: boolean,\n\t\t\tBlocked: boolean?,\n\t\t}\n\t)\n\t\tlocal Log = GetLog(Instance, Function)\n\t\tif not Log then\n\t\t\treturn false, nil\n\t\tend\n\n\t\tlocal ShouldBlock = Log:ShouldBlock(Info)\n\t\tlocal CallIndex = Log:Call(Info)\n\t\treturn ShouldBlock, Log, CallIndex\n\tend\n\n\t--#region Hook Filters\n\tlocal SupportsFilters = wax.shared.ExecutorSupport[\"FilterBase\"].IsWorking\n\n\t--[[\n\t\tCreates a base filter for the incoming hooks.\n\n\t\t@return `table` The base filter.\n\t]]\n\tlocal function CreateBaseFilter()\n\t\tlocal Filters = {}\n\t\tif not SupportsFilters then\n\t\t\treturn Filters\n\t\tend\n\n\t\t--// allowed classnames \\\\--\n\t\tfor ClassName in ClassesToHook do\n\t\t\ttable.insert(Filters, InstanceTypeFilter.new(1, ClassName))\n\t\tend\n\n\t\treturn Filters\n\tend\n\t--#endregion\n\n\t--#region Incoming Connection Stuff\n\tlocal function IsCobaltConnectionFunction(Function): boolean\n\t\tif not Function then\n\t\t\treturn false\n\t\tend\n\n\t\tif LogConnectionFunctions[Function] then\n\t\t\treturn true\n\t\tend\n\n\t\tlocal Success, Environment = pcall(getfenv, Function)\n\t\tlocal VerificationToken = wax.shared.CobaltVerificationToken\n\t\treturn (\n\t\t\tSuccess\n\t\t\tand VerificationToken ~= nil\n\t\t\tand typeof(Environment) == \"table\"\n\t\t\tand rawequal(rawget(Environment, CobaltObserverEnvironmentKey), VerificationToken)\n\t\t)\n\tend\n\n\t--[[\n\t\tCreates a function that can be used to pass to `Connect` which will log all the incoming calls. It will additonally add the function to a ignore list (`LogConnectionFunctions`) to prevent unneccessary logging.\n\t\t\n\t\t@param Instance The instance to log.\n\t\t@param Method The method to log (e.g., \"OnClientEvent\").\n\t\t@return function Returns a function that logs all calls to the given instance and method.\n\t]]\n\tlocal function CreateConnectionFunction(Instance: InstancesToHook, Method: MethodsToHook)\n\t\tlocal CachedConnectionInfo = nil\n\t\tlocal CachedConnectionCount = -1\n\n\t\tlocal DebugId = wax.shared.GetDebugId(Instance)\n\n\t\tlocal ConnectionFunction = function(...)\n\t\t\t--// Skip if this remote is already ignored \\\\--\n\t\t\tlocal ExistingLog = wax.shared.Logs.Incoming[DebugId]\n\t\t\tif ExistingLog and ExistingLog.Ignored then\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tlocal Signal = (Instance :: any)[Method]\n\t\t\tlocal Connections = getconnections(Signal)\n\t\t\tlocal ConnectionCount = #Connections\n\n\t\t\t-- Only re-analyze connections when the count changes (connect/disconnect)\n\t\t\tif ConnectionCount ~= CachedConnectionCount then\n\t\t\t\tCachedConnectionCount = ConnectionCount\n\n\t\t\t\tlocal Information = {\n\t\t\t\t\tHasValidConnections = false,\n\t\t\t\t\tHasForeignLuaConnections = false,\n\t\t\t\t\tEntries = {},\n\t\t\t\t}\n\n\t\t\t\tfor _, Connection in Connections do\n\t\t\t\t\t--// Foreign State Connections \\\\--\n\t\t\t\t\tif Connection.ForeignState then\n\t\t\t\t\t\t--// It is a Lua Connection - Other Actor's Connections \\\\--\n\t\t\t\t\t\tif Connection.LuaConnection then\n\t\t\t\t\t\t\tInformation.HasForeignLuaConnections = true\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tcontinue\n\t\t\t\t\tend\n\n\t\t\t\t\t--// Get Function \\\\--\n\t\t\t\t\tlocal Function = typeof(Connection.Function) == \"function\" and (Connection.Function) or (nil)\n\t\t\t\t\tif IsCobaltConnectionFunction(Function) then\n\t\t\t\t\t\tcontinue\n\t\t\t\t\tend\n\n\t\t\t\t\tInformation.HasValidConnections = true\n\n\t\t\t\t\t--// Get Origin \\\\--\n\t\t\t\t\tlocal Thread = Connection.Thread\n\t\t\t\t\tlocal Origin = nil\n\n\t\t\t\t\tif Thread and getscriptfromthread then\n\t\t\t\t\t\tOrigin = getscriptfromthread(Thread)\n\t\t\t\t\tend\n\n\t\t\t\t\tif not Origin and Function then\n\t\t\t\t\t\t-- ts is unreliable because people could js set the script global to nil\n\t\t\t\t\t\t-- if only debug.getinfo(Function).source or debug.info(Function, \"s\") returned an Instance...\n\n\t\t\t\t\t\tlocal Script = rawget(getfenv(Function), \"script\")\n\t\t\t\t\t\tif typeof(Script) == \"Instance\" then\n\t\t\t\t\t\t\tOrigin = Script\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\n\t\t\t\t\ttable.insert(Information.Entries, {\n\t\t\t\t\t\tFunction = Function,\n\t\t\t\t\t\tOrigin = Origin,\n\t\t\t\t\t\tIsExecutor = Function and isexecutorclosure(Function) or false,\n\t\t\t\t\t})\n\t\t\t\tend\n\n\t\t\t\tCachedConnectionInfo = Information\n\t\t\tend\n\n\t\t\tlocal Arguments = wax.shared.SafePack.Pack(...)\n\t\t\tlocal TargetLog, TargetCallIndex\n\n\t\t\t--// Log Remote \\\\--\n\t\t\tif CachedConnectionInfo.HasValidConnections then\n\t\t\t\tfor _, Entry in CachedConnectionInfo.Entries do\n\t\t\t\t\tTargetLog, TargetCallIndex = select(2, LogRemote(Instance, Entry.Function, {\n\t\t\t\t\t\tArguments = Arguments,\n\t\t\t\t\t\tOrigin = Entry.Origin,\n\t\t\t\t\t\tFunction = Entry.Function,\n\t\t\t\t\t\tLine = nil,\n\t\t\t\t\t\tIsExecutor = Entry.IsExecutor,\n\t\t\t\t\t}))\n\t\t\t\tend\n\n\t\t\telseif not wax.shared.IS_ACTOR then\n\t\t\t\tTargetLog, TargetCallIndex = select(2, LogRemote(Instance, nil, {\n\t\t\t\t\tArguments = Arguments,\n\t\t\t\t\tOrigin = nil,\n\t\t\t\t\tFunction = nil,\n\t\t\t\t\tLine = nil,\n\t\t\t\t\tIsExecutor = false,\n\t\t\t\t}))\n\t\t\tend\n\n\t\t\tlocal Communicator = wax.shared.ActorCommunicator\n\t\t\tif Communicator then\n\t\t\t\tif\n\t\t\t\t\tnot wax.shared.IS_ACTOR\n\t\t\t\t\tand CachedConnectionInfo.HasForeignLuaConnections\n\t\t\t\t\tand TargetLog\n\t\t\t\t\tand TargetCallIndex\n\t\t\t\tthen\n\t\t\t\t\tCommunicator:Fire(\n\t\t\t\t\t\t\"InspectIncomingConnections\",\n\t\t\t\t\t\tInstance,\n\t\t\t\t\t\tMethod,\n\t\t\t\t\t\tTargetLog.Index,\n\t\t\t\t\t\tTargetCallIndex\n\t\t\t\t\t)\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\n\t\tlocal OriginalEnvironment = getfenv(ConnectionFunction)\n\t\tsetfenv(ConnectionFunction, setmetatable({\n\t\t\t[CobaltObserverEnvironmentKey] = wax.shared.CobaltVerificationToken,\n\t\t}, {\n\t\t\t__index = OriginalEnvironment,\n\t\t\t__newindex = OriginalEnvironment,\n\t\t}))\n\n\t\tLogConnectionFunctions[ConnectionFunction] = true\n\t\treturn ConnectionFunction\n\tend\n\t--#endregion\n\n\t--#region Incoming Callback Stuff\n\t--[[\n\t\tHandles logging for a callback.\n\n\t\t@param Log The log to use.\n\t\t@param Info The pending callback call information.\n\t\t@param InitialEnv The initial environment to use.\n\t\t@param InitialIdentity The initial identity to use.\n\t\t@param ... The result of the callback.\n\n\t\t@return The result of the callback.\n\t]]\n\tlocal function HandleCallbackLogging(Log, Info, InitialEnv, InitialIdentity, ...)\n\t\tsetfenv(0, InitialEnv)\n\t\tsetthreadidentity(InitialIdentity)\n\n\t\tif Log then\n\t\t\tInfo.InvokeResult = wax.shared.SafePack.Pack(...)\n\t\t\tLog:Call(Info)\n\t\tend\n\n\t\treturn ...\n\tend\n\n\t--[[\n\t\tCreates a function that can be used to pass to callbacks (.OnInvoke & .OnClientInvoke) which will log all the incoming calls.\n\t\t\n\t\t@param Instance The instance to log.\n\t\t@param Function The original callback of the RemoteFunction\n\t\t@return function Returns a function that logs all function calls to the given instance.\n\t]]\n\tlocal function CreateCallbackDetour(Instance: InstancesToHook, Callback: any)\n\t\tlocal CallbackFunction = assert(ResolveCallableFunction(Callback), \"Callback is not callable\")\n\t\tlocal Detour = function(...)\n\t\t\tlocal Origin = nil\n\n\t\t\t-- May not exist in all executors\n\t\t\tif getscriptfromthread then\n\t\t\t\tOrigin = getscriptfromthread(coroutine.running())\n\t\t\tend\n\n\t\t\t-- Unreliable method to get script.\n\t\t\tif not Origin then\n\t\t\t\tlocal Script = rawget(getfenv(CallbackFunction), \"script\")\n\t\t\t\tif typeof(Script) == \"Instance\" then\n\t\t\t\t\tOrigin = Script\n\t\t\t\tend\n\t\t\tend\n\n\t\t\tlocal FunctionCaller = debug.info(2, \"f\")\n\t\t\tlocal IsExecutor = if typeof(FunctionCaller) == \"function\"\n\t\t\t\tthen isexecutorclosure(FunctionCaller)\n\t\t\t\telse isexecutorclosure(CallbackFunction)\n\n\t\t\tlocal Arguments = wax.shared.SafePack.Pack(...)\n\t\t\tlocal Log = GetLog(Instance, CallbackFunction)\n\t\t\tlocal Info = {\n\t\t\t\tArguments = Arguments,\n\t\t\t\tOrigin = Origin,\n\t\t\t\tFunction = CallbackFunction,\n\t\t\t\tLine = nil,\n\t\t\t\tIsExecutor = IsExecutor,\n\t\t\t\tInvokeKind = \"Callback\",\n\t\t\t}\n\t\t\tif Log and Log:ShouldBlock(Info) then\n\t\t\t\tLog:Call(Info)\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tlocal InitialEnv, InitialIdentity = getfenv(CreateCallbackDetour), getthreadidentity()\n\t\t\tlocal IsDirectFunction = rawequal(Callback, CallbackFunction)\n\n\t\t\tsetthreadidentity(2)\n\t\t\tsetfenv(0, getfenv(CallbackFunction))\n\t\t\tif IsDirectFunction then\n\t\t\t\treturn HandleCallbackLogging(\n\t\t\t\t\tLog,\n\t\t\t\t\tInfo,\n\t\t\t\t\tInitialEnv,\n\t\t\t\t\tInitialIdentity,\n\t\t\t\t\tCallbackFunction(...)\n\t\t\t\t)\n\t\t\tend\n\n\t\t\treturn HandleCallbackLogging(\n\t\t\t\tLog,\n\t\t\t\tInfo,\n\t\t\t\tInitialEnv,\n\t\t\t\tInitialIdentity,\n\t\t\t\tCallbackFunction(Callback, ...)\n\t\t\t)\n\t\tend\n\n\t\tif wax.shared.ExecutorSupport[\"setstackhidden\"].IsWorking then\n\t\t\tsetstackhidden(Detour, true)\n\t\tend\n\n\t\tCallbackOwners[Detour] = {\n\t\t\tOriginal = Callback,\n\t\t\tMethod = ClassesToHook[Instance.ClassName],\n\t\t\tInstance = Instance\n\t\t}\n\t\treturn Detour\n\tend\n\n\tlocal function GetOriginalScript(OriginalEnv: { [string]: any}): Instance?\n\t\tlocal OriginalScript = rawget(OriginalEnv, \"script\")\n\t\tif typeof(OriginalScript) ~= \"Instance\" then\n\t\t\treturn nil\n\t\tend\n\n\t\treturn OriginalScript\n\tend\n\n\t--[[\n\t\tRestores the callback detours for the given instances. Used for cobalt unloading.\n\t\tNOTE: Keep this in here so Actors can rely on wax.shared.RestoreCallbackDetours\n\t]]\n\twax.shared.RestoreCallbackDetours = function()\n\t\tfor Detour, Owner in CallbackOwners do\n\t\t\tlocal Success, CurrentCallback = pcall(getcallbackvalue, Owner.Instance, Owner.Method)\n\t\t\tif not (Success and rawequal(CurrentCallback, Detour)) then\n\t\t\t\tcontinue\n\t\t\tend\n\n\t\t\tpcall(function()\n\t\t\t\tif wax.shared.trampoline_call then\n\t\t\t\t\tlocal OriginalEnv = getfenv(Owner.Original)\n\t\t\t\t\tlocal OriginalScript = GetOriginalScript(OriginalEnv)\n\n\t\t\t\t\twax.shared.trampoline_call(function()\n\t\t\t\t\t\tOwner.Instance[Owner.Method] = Owner.Original\n\t\t\t\t\tend, {}, {\n\t\t\t\t\t\tenv = OriginalEnv,\n\t\t\t\t\t\tscript = OriginalScript,\n\t\t\t\t\t\tidentity = 2\n\t\t\t\t\t})\n\t\t\t\telse\n\t\t\t\t\ttask.spawn(function()\n\t\t\t\t\t\tlocal OriginalEnv = getfenv(Owner.Original)\n\n\t\t\t\t\t\tsetthreadidentity(2)\n\t\t\t\t\t\tsetfenv(0, OriginalEnv)\n\t\t\t\t\t\tOwner.Instance[Owner.Method] = Owner.Original\n\t\t\t\t\tend)\n\t\t\t\tend\n\t\t\tend)\n\t\tend\n\n\t\ttable.clear(CallbackOwners)\n\tend\n\n\t--#endregion\n\n\t--[[\n\t\tHandles setting up logging for the appropriate instances.\n\n\t\t@param Instance The instance to handle.\n\t]]\n\tlocal function HandleInstance(Instance: any)\n\t\tif\n\t\t\tnot ClassesToHook[Instance.ClassName]\n\t\t\tor Instance == wax.shared.Communicator\n\t\t\tor Instance == wax.shared.ActorCommunicator\n\t\tthen\n\t\t\treturn\n\t\tend\n\n\t\tlocal Method = ClassesToHook[Instance.ClassName]\n\n\t\tif ConnectionsEnabled and not ObservedConnectionInstances[Instance] then\n\t\t\tif Instance.ClassName == \"RemoteEvent\" or Instance.ClassName == \"UnreliableRemoteEvent\" then\n\t\t\t\twax.shared.Connect(Instance.OnClientEvent:Connect(CreateConnectionFunction(Instance, Method)))\n\n\t\t\t\tSignalMapping[Instance.OnClientEvent] = Instance\n\t\t\t\tObservedConnectionInstances[Instance] = true\n\t\t\telseif Instance.ClassName == \"BindableEvent\" then\n\t\t\t\twax.shared.Connect(Instance.Event:Connect(CreateConnectionFunction(Instance, Method)))\n\n\t\t\t\tSignalMapping[Instance.Event] = Instance\n\t\t\t\tObservedConnectionInstances[Instance] = true\n\t\t\tend\n\t\tend\n\n\t\tif CallbacksEnabled then\n\t\t\tif Instance.ClassName == \"RemoteFunction\" or Instance.ClassName == \"BindableFunction\" then\n\t\t\t\tlocal IsCoreRemote = Instance:IsDescendantOf(wax.shared.RobloxReplicatedStorage)\n\t\t\t\tif IsCoreRemote then return end\n\n\t\t\t\tlocal Success, Callback = pcall(getcallbackvalue, Instance, Method)\n\t\t\t\tlocal IsCallable = ResolveCallableFunction(Callback) ~= nil\n\n\t\t\t\tif not Success or not IsCallable or CallbackOwners[Callback] then\n\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\t\t--// Use trampoline_call so error redirection dosent occur \\\\--\n\t\t\t\tif wax.shared.trampoline_call then\n\t\t\t\t\tlocal OriginalEnv = getfenv(Callback)\n\t\t\t\t\tlocal OriginalScript = GetOriginalScript(OriginalEnv)\n\n\t\t\t\t\twax.shared.trampoline_call(function()\n\t\t\t\t\t\tInstance[Method] = CreateCallbackDetour(Instance, Callback)\n\t\t\t\t\tend, {}, {\n\t\t\t\t\t\tenv = OriginalEnv,\n\t\t\t\t\t\tscript = OriginalScript,\n\t\t\t\t\t\tidentity = 2\n\t\t\t\t\t})\n\t\t\t\telse\n\t\t\t\t\tInstance[Method] = CreateCallbackDetour(Instance, Callback)\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\n\n\t--[[\n\t\tCreates a hook that intercepts .OnInvoke & .OnClientInvoke assignments and detours them to log the calls.\n\t]]\n\tlocal function SetupCallbackAssignmentHook()\n\t\tlocal NewIndexHookFilter = SupportsFilters and AnyFilter.new(CreateBaseFilter())\n\t\t\n\t\twax.shared.NewIndexHook = wax.shared.Hooking.HookMetaMethod(game, \"__newindex\", function(...)\n\t\t\tlocal self, key, value = ...\n\n\t\t\tif typeof(self) ~= \"Instance\" or not ClassesToHook[self.ClassName] then\n\t\t\t\treturn wax.shared.NewIndexHook(...)\n\t\t\tend\n\n\t\t\tif self.ClassName == \"RemoteFunction\" or self.ClassName == \"BindableFunction\" then\n\t\t\t\tlocal Method = ClassesToHook[self.ClassName]\n\n\t\t\t\tlocal IsCallable = ResolveCallableFunction(value) ~= nil\n\n\t\t\t\tif key == Method and IsCallable then\n\t\t\t\t\tif CallbackOwners[value] then\n\t\t\t\t\t\treturn wax.shared.NewIndexHook(...)\n\t\t\t\t\tend\n\n\t\t\t\t\treturn wax.shared.NewIndexHook(self, key, CreateCallbackDetour(self :: InstancesToHook, value))\n\t\t\t\tend\n\t\t\tend\n\n\t\t\treturn wax.shared.NewIndexHook(...)\n\t\tend, NewIndexHookFilter)\n\tend\n\n\t--[[\n\t\tHandles logging for a connection.\n\n\t\t@param Method The method to log.\n\t\t@param callback The callback to log.\n\t\t@param ... The arguments to log.\n\n\t\t@return The result of the connection.\n\t]]\n\tlocal function HandleConnectionLogging(Instance, Method, callback, ...)\n\t\tlocal Log = wax.shared.Logs.Incoming[wax.shared.GetDebugId(Instance)]\n\n\t\tif Log and Log.Blocked then\n\t\t\tfor _, Connection in getconnections(Instance[Method]) do\n\t\t\t\tif not Connection.ForeignState and Connection.Function ~= callback then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\n\t\t\t\tConnection:Disable()\n\t\t\tend\n\t\tend\n\n\t\treturn ...\n\tend\n\n\t--[[\n\t\tCreates a hook that disables connections for blocked instances on creation.\n\t]]\n\tlocal function SetupConnectionAssignmentHook()\n\t\tlocal SignalMetatable = wax.shared.getrawmetatable(Instance.new(\"Part\").Touched)\n\t\twax.shared.Hooks[SignalMetatable.__index] = wax.shared.Hooking.HookFunction(SignalMetatable.__index, function(...)\n\t\t\tlocal self, key = ...\n\n\t\t\tif not wax.shared.Unloaded and ConnectionKeys[key] then\n\t\t\t\tlocal Instance = SignalMapping[self]\n\t\t\t\tlocal Connect = wax.shared.Hooks[SignalMetatable.__index](...)\n\n\t\t\t\tif not Instance then\n\t\t\t\t\treturn Connect\n\t\t\t\tend\n\n\t\t\t\tlocal Method = ClassesToHook[Instance.ClassName]\n\t\t\t\treturn wax.shared.newcclosure(function(...)\n\t\t\t\t\tlocal _self, callback = ...\n\t\t\t\t\treturn HandleConnectionLogging(Instance, Method, callback, Connect(...))\n\t\t\t\tend, debug.info(Connect, \"n\"))\n\t\t\tend\n\n\t\t\treturn wax.shared.Hooks[SignalMetatable.__index](...)\n\t\tend)\n\tend\n\n\tlocal Started = false\n\twax.shared.IncomingInterceptor = function(Options: Options?)\n\t\tif Started then\n\t\t\treturn\n\t\tend\n\n\t\t--// Validation \\\\--\n\t\tOptions = Options or {}\n\t\tdo\n\t\t\tConnectionsEnabled = Options.Connections ~= false\n\t\t\tCallbacksEnabled = Options.Callbacks ~= false\n\t\t\tConnectionHookEnabled = Options.HookConnections ~= false\n\t\tend\n\n\t\tif not ConnectionsEnabled and not CallbacksEnabled then\n\t\t\treturn\n\t\tend\n\n\t\tStarted = true\n\n\t\t--// Listeners \\\\--\n\t\tif CallbacksEnabled then\n\t\t\tif wax.shared.ExecutorSupport[\"setstackhidden\"].IsWorking then\n\t\t\t\tsetstackhidden(HandleCallbackLogging, true)\n\t\t\tend\n\n\t\t\tSetupCallbackAssignmentHook()\n\t\tend\n\n\t\tif ConnectionsEnabled and ConnectionHookEnabled then\n\t\t\tSetupConnectionAssignmentHook()\n\t\tend\n\n\t\twax.shared.Connect(game.DescendantAdded:Connect(function(instance)\n\t\t\tHandleInstance(cloneref(instance))\n\t\tend))\n\n\t\t--// Initialization \\\\--\n\t\tlocal ClassesToSearch = {}\n\t\tdo\n\t\t\tif ConnectionsEnabled then\n\t\t\t\ttable.insert(ClassesToSearch, \"RemoteEvent\")\n\t\t\t\ttable.insert(ClassesToSearch, \"UnreliableRemoteEvent\")\n\t\t\t\ttable.insert(ClassesToSearch, \"BindableEvent\")\n\t\t\tend\n\t\t\tif CallbacksEnabled then\n\t\t\t\ttable.insert(ClassesToSearch, \"RemoteFunction\")\n\t\t\t\ttable.insert(ClassesToSearch, \"BindableFunction\")\n\t\t\tend\n\t\tend\n\n\t\tlocal Categories = {\n\t\t\tgame:QueryDescendants(table.concat(ClassesToSearch, \", \")),\n\t\t}\n\t\tif wax.shared.ExecutorSupport[\"getnilinstances\"].IsWorking then\n\t\t\ttable.insert(Categories, getnilinstances())\n\t\tend\n\n\t\tfor _, Category in Categories do\n\t\t\tfor _, TargetInstance in next, Category do\n\t\t\t\tHandleInstance(cloneref(TargetInstance))\n\t\t\tend\n\t\tend\n\tend\nend\n--#endregion\n\ntask.spawn(wax.shared.IncomingInterceptor, {\n\tConnections = false,\n\tCallbacks = Data.IncomingCallbacks,\n\tHookConnections = false,\n})\n\nif Data.Outgoing then\n\ttask.spawn(function()\n\t\tlocal NamecallMethods = {\n\t\t\t[\"FireServer\"] = CreateLookupTable({\"RemoteEvent\", \"UnreliableRemoteEvent\"}),\n\t\t\t[\"fireServer\"] = CreateLookupTable({\"RemoteEvent\", \"UnreliableRemoteEvent\"}),\n\t\t\t\n\t\t\t[\"InvokeServer\"] = CreateLookupTable({\"RemoteFunction\"}),\n\t\t\t[\"invokeServer\"] = CreateLookupTable({\"RemoteFunction\"}),\n\n\t\t\t[\"Fire\"] = CreateLookupTable({\"BindableEvent\"}),\n\t\t\t[\"fire\"] = CreateLookupTable({\"BindableEvent\"}),\n\t\t\t\n\t\t\t[\"Invoke\"] = CreateLookupTable({\"BindableFunction\"}),\n\t\t\t[\"invoke\"] = CreateLookupTable({\"BindableFunction\"}),\n\t\t}\n\t\tlocal AllowedClassNames =\n\t\t\tCreateLookupTable({ \"RemoteEvent\", \"RemoteFunction\", \"UnreliableRemoteEvent\", \"BindableEvent\", \"BindableFunction\" })\n\n\t\t--[[\n\t\t\tReturns the calling function via `debug.info`\n\n\t\t\t@return `function | nil` The calling function or nil if not found.\n\t\t]]\n\t\tlocal function getcallingfunction()\n\t\t\tlocal BaseLevel = if wax.shared.IsUsingOthHooks then 3 else 5\n\n\t\t\tfor i = BaseLevel, 10 do\n\t\t\t\tlocal Function, Source = debug.info(i, \"fs\")\n\t\t\t\tif not Function or not Source then\n\t\t\t\t\tbreak\n\t\t\t\tend\n\n\t\t\t\tif Source == \"[C]\" then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\n\t\t\t\treturn Function\n\t\t\tend\n\n\t\t\treturn debug.info(BaseLevel, \"f\")\n\t\tend\n\n\t\t--[[\n\t\t\tReturns the calling line of the script that called the function via `debug.info`\n\n\t\t\t@return number Returns the line number of the calling script.\n\t\t]]\n\t\tlocal function getcallingline()\n\t\t\tlocal BaseLevel = if wax.shared.IsUsingOthHooks then 3 else 5\n\n\t\t\tfor i = BaseLevel, 10 do\n\t\t\t\tlocal Source, Line = debug.info(i, \"sl\")\n\t\t\t\tif not Source then\n\t\t\t\t\tbreak\n\t\t\t\tend\n\n\t\t\t\tif Source == \"[C]\" then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\n\t\t\t\treturn Line\n\t\t\tend\n\n\t\t\treturn debug.info(BaseLevel, \"l\")\n\t\tend\n\n\t\t--[[\n\t\t\tReturns the calling source of the script that called the function via `debug.info`\n\n\t\t\t@return string Returns the source of the calling script.\n\t\t]]\n\t\tlocal function getcallingsource()\n\t\t\tlocal BaseLevel = if wax.shared.IsUsingOthHooks then 3 else 5\n\n\t\t\tfor i = BaseLevel, 10 do\n\t\t\t\tlocal Source = debug.info(i, \"s\")\n\t\t\t\tif not Source then\n\t\t\t\t\tbreak\n\t\t\t\tend\n\n\t\t\t\tif Source == \"[C]\" then\n\t\t\t\t\tcontinue\n\t\t\t\tend\n\n\t\t\t\treturn Source\n\t\t\tend\n\n\t\t\treturn debug.info(BaseLevel, \"s\")\n\t\tend\n\n\t\t--[[\n\t\t\tGets the log for a specific instance and direction.\n\n\t\t\t@param Instance: The instance that was called.\n\t\t\t@param Direction: The direction of the log (Outgoing, Incoming).\n\t\t\t@return Log: The log for the instance and direction.\n\t\t]]\n\t\tlocal function GetLog(Instance: Instance, Direction: \"Outgoing\" | \"Incoming\")\n\t\t\tlocal DebugId = wax.shared.GetDebugId(Instance)\n\n\t\t\tlocal LogsInDirection = wax.shared.Logs[Direction]\n\t\t\tif not LogsInDirection then\n\t\t\t\treturn nil\n\t\t\tend\n\n\t\t\tlocal Log = LogsInDirection[DebugId]\n\t\t\tif not Log then\n\t\t\t\tLog = wax.shared.NewLog(Instance, Direction, getcallingscript(), DebugId)\n\t\t\tend\n\n\t\t\treturn Log\n\t\tend\n\n\t\t--[[\n\t\t\tHandles logging for a result of a remote function.\n\t\t\t@param Log The log to use.\n\t\t\t@param Arguments The arguments to use.\n\t\t\t@param ... The result to log.\n\t\t\t@return The result.\n\t\t]]\n\t\tlocal function HandleLoggingResult(Log, Info, ResultKey, ...)\n\t\t\tlocal Result = wax.shared.SafePack.Pack(...)\n\t\t\tInfo[ResultKey] = Result\n\t\t\tLog:Call(Info)\n\n\t\t\treturn ...\n\t\tend\n\n\t\t--[[\n\t\t\tHandles the logging for a specific instance and method.\n\n\t\t\t@param Instance: The instance that was called.\n\t\t\t@param Method: The method that was called (e.g., \"OnClientEvent\").\n\t\t\t@param ... The arguments passed from the server to the client.\n\t\t]]\n\t\tlocal function HandleLogging(TargetInstance: Instance, Method: string, OldFunction: (...any) -> ...any, ...)\n\t\t\tlocal Log = GetLog(TargetInstance, \"Outgoing\")\n\t\t\tif not Log then\n\t\t\t\treturn OldFunction(...)\n\t\t\tend\n\t\t\tlocal Arguments = wax.shared.SafePack.Pack(select(2, ...))\n\n\t\t\tlocal Info = {\n\t\t\t\tArguments = Arguments,\n\t\t\t\tOrigin = getcallingscript(),\n\t\t\t\tFunction = getcallingfunction(),\n\t\t\t\tLine = getcallingline(),\n\t\t\t\tSource = getcallingsource(),\n\t\t\t\tIsExecutor = checkcaller(),\n\t\t\t}\n\t\t\tlocal ShouldBlock = Log:ShouldBlock(Info)\n\t\t\tLog:Call(Info)\n\t\t\tif ShouldBlock then\n\t\t\t\treturn\n\t\t\tend\n\n\t\t\tlocal IsRemoteFunctionInvoke = (\n\t\t\t\tTargetInstance.ClassName == \"RemoteFunction\" and (Method == \"InvokeServer\" or Method == \"invokeServer\")\n\t\t\t)\n\n\t\t\tlocal IsBindableFunctionInvoke = (\n\t\t\t\tTargetInstance.ClassName == \"BindableFunction\" and (Method == \"Invoke\" or Method == \"invoke\")\n\t\t\t)\n\n\t\t\tif IsRemoteFunctionInvoke or IsBindableFunctionInvoke then\n\t\t\t\t--// Handle Incoming Log \\\\--\n\t\t\t\tLog = GetLog(TargetInstance, \"Incoming\")\n\t\t\t\tlocal RFResultInfo = {\n\t\t\t\t\tArguments = Arguments,\n\t\t\t\t\tInvokeResult = nil,\n\t\t\t\t\tOrigin = getcallingscript(),\n\t\t\t\t\tFunction = getcallingfunction(),\n\t\t\t\t\tLine = getcallingline(),\n\t\t\t\t\tSource = getcallingsource(),\n\t\t\t\t\tIsExecutor = checkcaller(),\n\t\t\t\t\tInvokeKind = \"Request\",\n\t\t\t\t}\n\n\t\t\t\tif Log:ShouldBlock(RFResultInfo) then\n\t\t\t\t\tLog:Call(RFResultInfo)\n\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\t\treturn HandleLoggingResult(Log, RFResultInfo, \"InvokeResult\", OldFunction(...))\n\t\t\tend\n\n\t\t\treturn OldFunction(...)\n\t\tend\n\n\t\t--#region Hook Filters\n\t\tlocal SupportsFilters = wax.shared.ExecutorSupport[\"FilterBase\"].IsWorking\n\n\t\t--[[\n\t\t\tCreates a base filter for the outgoing hooks.\n\n\t\t\t@return `table` The base filter.\n\t\t]]\n\t\tlocal function CreateBaseFilter()\n\t\t\tlocal Filters = {}\n\t\t\tif not SupportsFilters then\n\t\t\t\treturn Filters\n\t\t\tend\n\n\t\t\t--// ignore communicator \\\\--\n\t\t\ttable.insert(Filters, NotFilter.new(ArgumentFilter.new(1, wax.shared.Communicator)))\n\t\t\ttable.insert(Filters, NotFilter.new(ArgumentFilter.new(1, wax.shared.ActorCommunicator)))\n\n\t\t\treturn Filters\n\t\tend\n\n\t\tlocal NamecallHookFilter = SupportsFilters and AllFilter.new((function()\n\t\t\tlocal Filters = CreateBaseFilter()\n\n\t\t\t--[[\n\t\t\t\tAllFilter:\n\t\t\t\t\tnot communicator\n\t\t\t\t\tnot actor communicator\n\t\t\t\t\tAnyFilter:\n\t\t\t\t\t\tRemoteEvent\n\t\t\t\t\t\t...\n\t\t\t\t\tAnyFilter:\n\t\t\t\t\t\tFireServer\n\t\t\t\t\t\tinvokeServer\n\t\t\t\t\t\t...\n\t\t\t--]]\n\n\t\t\t--// classnames \\\\--\n\t\t\tlocal AnyClassNameFilters = {}\n\t\t\tfor ClassName in AllowedClassNames do\n\t\t\t\ttable.insert(AnyClassNameFilters, InstanceTypeFilter.new(1, ClassName))\n\t\t\tend\n\t\t\t\n\t\t\t--// methods \\\\--\n\t\t\tlocal AnyNamecallMethoFilters = {}\n\t\t    for Method in NamecallMethods do\n\t\t        table.insert(AnyNamecallMethoFilters, NamecallFilter.new(Method))\n\t\t    end\n\n\t\t\ttable.insert(Filters, AnyFilter.new(AnyClassNameFilters))\n\t\t\ttable.insert(Filters, AnyFilter.new(AnyNamecallMethoFilters))\n\t\t    return Filters\n\t\tend)())\n\t\t--#endregion\n\n\t\t-- namecall hook\n\t\twax.shared.NamecallHook = wax.shared.Hooking.HookMetaMethod(game, \"__namecall\", function(...)\n\t\t\tlocal self = ...\n\t\t\tlocal Method = getnamecallmethod()\n\n\t\t\tif\n\t\t\t\ttypeof(self) == \"Instance\"\n\t\t\t\tand AllowedClassNames[self.ClassName]\n\t\t\t\tand not rawequal(self, wax.shared.Communicator)\n\t\t\t\tand not rawequal(self, wax.shared.ActorCommunicator)\n\t\t\t\tand (NamecallMethods[Method] and NamecallMethods[Method][self.ClassName])\n\t\t\t\tand not wax.shared.ShouldIgnore(self, getcallingscript())\n\t\t\tthen\n\t\t\t\treturn HandleLogging(cloneref(self), Method, wax.shared.NamecallHook, ...)\n\t\t\tend\n\n\t\t\treturn wax.shared.NamecallHook(...)\n\t\tend, NamecallHookFilter)\n\n\t\t-- function hooks\n\t\tlocal FunctionsToHook\n\t\tdo\n\t\t\tlocal BindableFunction = Instance.new(\"BindableFunction\")\n\t\t\tlocal BindableEvent = Instance.new(\"BindableEvent\")\n\n\t\t\tlocal RemoteFunction = Instance.new(\"RemoteFunction\")\n\t\t\tlocal RemoteEvent = Instance.new(\"RemoteEvent\")\n\t\t\tlocal UnreliableRemoteEvent = Instance.new(\"UnreliableRemoteEvent\")\n\n\t\t\tFunctionsToHook = {\n\t\t\t\tBindableFunction.Invoke,\n\t\t\t\tBindableEvent.Fire,\n\n\t\t\t\tRemoteFunction.InvokeServer,\n\t\t\t\tRemoteEvent.FireServer,\n\t\t\t\tUnreliableRemoteEvent.FireServer,\n\t\t\t}\n\n\t\t\tBindableFunction:Destroy()\n\t\t\tBindableEvent:Destroy()\n\n\t\t\tRemoteFunction:Destroy()\n\t\t\tRemoteEvent:Destroy()\n\t\t\tUnreliableRemoteEvent:Destroy()\n\t\tend\n\n\t\tlocal FunctionHookFilter = SupportsFilters and AllFilter.new((function()\n\t\t\tlocal Filters = CreateBaseFilter()\n\n\t\t\t--[[\n\t\t\t\tAllFilter:\n\t\t\t\t\tnot communicator\n\t\t\t\t\tnot actor communicator\n\t\t\t\t\tAnyFilter:\n\t\t\t\t\t\tRemoteEvent\n\t\t\t\t\t\tRemoteFunction\n\t\t\t\t\t\tUnreliableRemoteEvent\n\t\t\t\t\t\tBindableEvent\n\t\t\t\t\t\tBindableFunction\n\t\t\t--]]\n\n\t\t\tlocal ClassFilters = {}\n\t\t\tfor ClassName in AllowedClassNames do\n\t\t\t\ttable.insert(ClassFilters, InstanceTypeFilter.new(1, ClassName))\n\t\t\tend\n\n\t\t\ttable.insert(Filters, AnyFilter.new(ClassFilters))\n\t\t\treturn Filters\n\t\tend)())\n\n\t\tfor _, Function in next, FunctionsToHook do\n\t\t\tlocal Method = debug.info(Function, \"n\")\n\n\t\t\twax.shared.Hooks[Function] = wax.shared.Hooking.HookFunction(Function, function(...)\n\t\t\t\tlocal self = ...\n\n\t\t\t\tif\n\t\t\t\t\ttypeof(self) == \"Instance\"\n\t\t\t\t\tand AllowedClassNames[self.ClassName]\n\t\t\t\t\tand not rawequal(self, wax.shared.Communicator)\n\t\t\t\t\tand not wax.shared.ShouldIgnore(self, getcallingscript())\n\t\t\t\tthen\n\t\t\t\t\treturn HandleLogging(cloneref(self), Method, wax.shared.Hooks[Function], ...)\n\t\t\t\tend\n\n\t\t\t\treturn wax.shared.Hooks[Function](...)\n\t\t\tend, FunctionHookFilter)\n\t\tend\n\tend)\nend\n\ntask.spawn(function()\n\tlocal getrawmetatable = getrawmetatable or debug.getmetatable\n\n\twax.shared.Communicator.Event:Connect(function(Type, ...)\n\t\tif Type ~= \"Unload\" then\n\t\t\treturn\n\t\tend\n\n\t\tlocal gameMetatable = getrawmetatable(game)\n\n\t\tif wax.shared.ExecutorSupport[\"oth\"].IsWorking then\n\t\t\tif Data.Outgoing then\n\t\t\t\tpcall(oth.unhook, gameMetatable.__namecall)\n\t\t\tend\n\t\t\tif Data.IncomingCallbacks then\n\t\t\t\tpcall(oth.unhook, gameMetatable.__newindex)\n\t\t\tend\n\t\telse\n\t\t\tif wax.shared.ExecutorSupport[\"restorefunction\"].IsWorking and wax.shared.ExecutorSupport[\"hookmetamethod\"].IsWorking then\n\t\t\t\tif Data.Outgoing then\n\t\t\t\t\tpcall(restorefunction, gameMetatable.__namecall)\n\t\t\t\tend\n\t\t\t\tif Data.IncomingCallbacks then\n\t\t\t\t\tpcall(restorefunction, gameMetatable.__newindex)\n\t\t\t\tend\n\t\t\telse\n\t\t\t\tif Data.Outgoing then\n\t\t\t\t\twax.shared.Hooking.HookMetaMethod(game, \"__namecall\", wax.shared.NamecallHook)\n\t\t\t\tend\n\t\t\t\tif Data.IncomingCallbacks then\n\t\t\t\t\twax.shared.Hooking.HookMetaMethod(game, \"__newindex\", wax.shared.NewIndexHook)\n\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\n\t\t\tif Data.IncomingCallbacks and wax.shared.RestoreCallbackDetours then\n\t\t\t\twax.shared.RestoreCallbackDetours()\n\t\t\tend\n\n\t\t\tfor Function, Original in pairs(wax.shared.Hooks) do\n\t\t\tif wax.shared.ExecutorSupport[\"oth\"].IsWorking then\n\t\t\t\ttask.spawn(pcall, oth.unhook, Function)\n\t\t\telseif wax.shared.ExecutorSupport[\"restorefunction\"].IsWorking then\n\t\t\t\ttask.spawn(pcall, wax.shared.restorefunction, Function)\n\t\t\telse\n\t\t\t\tpcall(wax.shared.Hooking.HookFunction, Function, Original)\n\t\t\tend\n\t\tend\n\n\t\ttask.defer(function()\n\t\t\tgetgenv().CobaltInitialized = false\n\t\tend)\n\tend)\nend)\n"
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                11,
                                2,
                                {
                                    "RakNet"
                                },
                                {
                                    {
                                        17,
                                        2,
                                        {
                                            "PacketProcessor"
                                        }
                                    },
                                    {
                                        12,
                                        2,
                                        {
                                            "InterceptorUtils"
                                        }
                                    },
                                    {
                                        16,
                                        2,
                                        {
                                            "InvocationTracker"
                                        }
                                    },
                                    {
                                        13,
                                        1,
                                        {
                                            "Interceptors"
                                        },
                                        {
                                            {
                                                14,
                                                2,
                                                {
                                                    "Incoming"
                                                }
                                            },
                                            {
                                                15,
                                                2,
                                                {
                                                    "Outgoing"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            {
                123,
                2,
                {
                    "Window"
                },
                {
                    {
                        164,
                        1,
                        {
                            "Utils"
                        },
                        {
                            {
                                171,
                                2,
                                {
                                    "Pagination"
                                }
                            },
                            {
                                165,
                                2,
                                {
                                    "Animations"
                                }
                            },
                            {
                                172,
                                1,
                                {
                                    "Text"
                                },
                                {
                                    {
                                        174,
                                        2,
                                        {
                                            "LazySerializer"
                                        }
                                    },
                                    {
                                        173,
                                        2,
                                        {
                                            "Highlighter"
                                        }
                                    },
                                    {
                                        175,
                                        2,
                                        {
                                            "TextBounds"
                                        }
                                    }
                                }
                            },
                            {
                                167,
                                1,
                                {
                                    "Input"
                                },
                                {
                                    {
                                        170,
                                        2,
                                        {
                                            "Resize"
                                        }
                                    },
                                    {
                                        169,
                                        2,
                                        {
                                            "Input"
                                        }
                                    },
                                    {
                                        168,
                                        2,
                                        {
                                            "Drag"
                                        }
                                    }
                                }
                            },
                            {
                                166,
                                2,
                                {
                                    "DPI"
                                }
                            }
                        }
                    },
                    {
                        124,
                        1,
                        {
                            "Components"
                        },
                        {
                            {
                                126,
                                2,
                                {
                                    "Dialog"
                                }
                            },
                            {
                                125,
                                2,
                                {
                                    "ContextMenu"
                                }
                            },
                            {
                                147,
                                2,
                                {
                                    "QueryBuilder"
                                },
                                {
                                    {
                                        148,
                                        2,
                                        {
                                            "UI"
                                        }
                                    }
                                }
                            },
                            {
                                150,
                                2,
                                {
                                    "Topbar"
                                }
                            },
                            {
                                149,
                                2,
                                {
                                    "Sonner"
                                }
                            },
                            {
                                127,
                                2,
                                {
                                    "Dialogs"
                                },
                                {
                                    {
                                        131,
                                        2,
                                        {
                                            "DeleteCallFilter"
                                        }
                                    },
                                    {
                                        133,
                                        2,
                                        {
                                            "LoggingDisabled"
                                        }
                                    },
                                    {
                                        128,
                                        2,
                                        {
                                            "CallFilter"
                                        }
                                    },
                                    {
                                        129,
                                        2,
                                        {
                                            "ClearCapturedCalls"
                                        }
                                    },
                                    {
                                        135,
                                        2,
                                        {
                                            "RakNet"
                                        }
                                    },
                                    {
                                        134,
                                        2,
                                        {
                                            "Oth"
                                        }
                                    },
                                    {
                                        132,
                                        2,
                                        {
                                            "DetectionRisk"
                                        }
                                    },
                                    {
                                        130,
                                        2,
                                        {
                                            "Credits"
                                        }
                                    }
                                }
                            },
                            {
                                136,
                                2,
                                {
                                    "Modal"
                                },
                                {
                                    {
                                        137,
                                        1,
                                        {
                                            "Builder"
                                        },
                                        {
                                            {
                                                138,
                                                1,
                                                {
                                                    "Controls"
                                                },
                                                {
                                                    {
                                                        142,
                                                        2,
                                                        {
                                                            "RemoteList"
                                                        }
                                                    },
                                                    {
                                                        144,
                                                        2,
                                                        {
                                                            "TextBox"
                                                        }
                                                    },
                                                    {
                                                        139,
                                                        2,
                                                        {
                                                            "CallFilterList"
                                                        }
                                                    },
                                                    {
                                                        141,
                                                        2,
                                                        {
                                                            "Dropdown"
                                                        }
                                                    },
                                                    {
                                                        140,
                                                        2,
                                                        {
                                                            "Checkbox"
                                                        }
                                                    },
                                                    {
                                                        143,
                                                        2,
                                                        {
                                                            "SettingSync"
                                                        }
                                                    }
                                                }
                                            },
                                            {
                                                145,
                                                2,
                                                {
                                                    "Section"
                                                }
                                            },
                                            {
                                                146,
                                                2,
                                                {
                                                    "Settings"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        151,
                        2,
                        {
                            "Constants"
                        }
                    },
                    {
                        176,
                        1,
                        {
                            "Views"
                        },
                        {
                            {
                                177,
                                2,
                                {
                                    "Logs"
                                },
                                {
                                    {
                                        178,
                                        1,
                                        {
                                            "Components"
                                        },
                                        {
                                            {
                                                179,
                                                2,
                                                {
                                                    "Calls"
                                                }
                                            },
                                            {
                                                180,
                                                2,
                                                {
                                                    "DirectionTabs"
                                                }
                                            },
                                            {
                                                181,
                                                2,
                                                {
                                                    "List"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        152,
                        1,
                        {
                            "Modals"
                        },
                        {
                            {
                                161,
                                2,
                                {
                                    "Search"
                                }
                            },
                            {
                                160,
                                2,
                                {
                                    "Plugins"
                                }
                            },
                            {
                                162,
                                2,
                                {
                                    "Settings"
                                }
                            },
                            {
                                153,
                                2,
                                {
                                    "Info"
                                },
                                {
                                    {
                                        159,
                                        2,
                                        {
                                            "Shell"
                                        }
                                    },
                                    {
                                        154,
                                        1,
                                        {
                                            "Components"
                                        },
                                        {
                                            {
                                                158,
                                                2,
                                                {
                                                    "FunctionInfoView"
                                                }
                                            },
                                            {
                                                157,
                                                2,
                                                {
                                                    "FooterButtons"
                                                }
                                            },
                                            {
                                                156,
                                                2,
                                                {
                                                    "CodeView"
                                                }
                                            },
                                            {
                                                155,
                                                2,
                                                {
                                                    "ArgumentList"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        163,
                        2,
                        {
                            "Types"
                        }
                    }
                }
            },
            {
                18,
                1,
                {
                    "Utils"
                },
                {
                    {
                        114,
                        2,
                        {
                            "Signal"
                        }
                    },
                    {
                        19,
                        1,
                        {
                            "Anticheats"
                        },
                        {
                            {
                                20,
                                2,
                                {
                                    "Main"
                                }
                            },
                            {
                                21,
                                1,
                                {
                                    "impl"
                                },
                                {
                                    {
                                        22,
                                        2,
                                        {
                                            "Adonis"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        44,
                        2,
                        {
                            "Connect"
                        }
                    },
                    {
                        45,
                        2,
                        {
                            "FileHelper"
                        }
                    },
                    {
                        115,
                        1,
                        {
                            "UI"
                        },
                        {
                            {
                                116,
                                1,
                                {
                                    "Assets"
                                },
                                {
                                    {
                                        119,
                                        2,
                                        {
                                            "Registry"
                                        }
                                    },
                                    {
                                        118,
                                        2,
                                        {
                                            "Manager"
                                        }
                                    },
                                    {
                                        117,
                                        2,
                                        {
                                            "Icons"
                                        }
                                    }
                                }
                            },
                            {
                                120,
                                2,
                                {
                                    "Interface"
                                }
                            }
                        }
                    },
                    {
                        108,
                        2,
                        {
                            "Ratelimiter"
                        }
                    },
                    {
                        96,
                        1,
                        {
                            "Plugins"
                        },
                        {
                            {
                                101,
                                2,
                                {
                                    "Bridge"
                                }
                            },
                            {
                                107,
                                2,
                                {
                                    "Registry"
                                }
                            },
                            {
                                106,
                                2,
                                {
                                    "Metadata"
                                }
                            },
                            {
                                103,
                                2,
                                {
                                    "Errors"
                                }
                            },
                            {
                                102,
                                2,
                                {
                                    "Environment"
                                }
                            },
                            {
                                105,
                                2,
                                {
                                    "Manager"
                                }
                            },
                            {
                                104,
                                2,
                                {
                                    "Loader"
                                }
                            },
                            {
                                97,
                                1,
                                {
                                    "API"
                                },
                                {
                                    {
                                        100,
                                        2,
                                        {
                                            "UI"
                                        }
                                    },
                                    {
                                        98,
                                        2,
                                        {
                                            "CodeGen"
                                        }
                                    },
                                    {
                                        99,
                                        2,
                                        {
                                            "Spy"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        110,
                        2,
                        {
                            "SaveManager"
                        }
                    },
                    {
                        95,
                        2,
                        {
                            "Pagination"
                        }
                    },
                    {
                        28,
                        1,
                        {
                            "CodeGen"
                        },
                        {
                            {
                                43,
                                2,
                                {
                                    "Types"
                                }
                            },
                            {
                                30,
                                2,
                                {
                                    "Formatter"
                                }
                            },
                            {
                                37,
                                1,
                                {
                                    "Templates"
                                },
                                {
                                    {
                                        38,
                                        2,
                                        {
                                            "Actor"
                                        }
                                    },
                                    {
                                        39,
                                        2,
                                        {
                                            "Call"
                                        }
                                    },
                                    {
                                        41,
                                        2,
                                        {
                                            "Referencing"
                                        }
                                    },
                                    {
                                        40,
                                        2,
                                        {
                                            "Hook"
                                        }
                                    },
                                    {
                                        42,
                                        5,
                                        {
                                            "SessionHTMLView",
                                            Value = "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\" />\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\n    <title>Cobalt - Session Viewer</title>\n    <link\n      rel=\"icon\"\n      type=\"image/png\"\n      href=\"https://cobalt-xil.pages.dev/Assets/Logo.png\"\n    />\n    <style>\n      :root {\n        --bg-color: #0b0b0b;\n        --surface-color: #161b22;\n        --border-color: #30363d;\n        --text-primary: #c9d1d9;\n        --text-secondary: #8b949e;\n        --accent-blue: #58a6ff;\n        --accent-green: #3fb950;\n        --accent-orange: #d29922;\n        --accent-red: #ff7b72;\n        --font-family: \"Inter\", -apple-system, BlinkMacSystemFont, \"Segoe UI\",\n          Helvetica, Arial, sans-serif;\n      }\n\n      body {\n        background-color: var(--bg-color);\n        color: var(--text-primary);\n        font-family: var(--font-family);\n        margin: 0;\n        padding: 0;\n        font-size: 13px;\n        height: 100vh;\n        display: flex;\n        flex-direction: column;\n        overflow: hidden;\n      }\n\n      /* Top Header */\n      .app-header {\n        height: 50px;\n        border-bottom: 1px solid var(--border-color);\n        display: flex;\n        align-items: center;\n        justify-content: space-between;\n        padding: 0 20px;\n        background-color: var(--bg-color);\n        flex-shrink: 0;\n        z-index: 10;\n      }\n\n      .brand {\n        display: flex;\n        align-items: center;\n        gap: 10px;\n        font-size: 16px;\n        font-weight: 600;\n        color: #fff;\n      }\n\n      .brand-icon {\n        width: 20px;\n        height: 20px;\n        background-image: url(\"https://cobalt-xil.pages.dev/Assets/Logo.png\");\n        background-size: contain;\n        background-repeat: no-repeat;\n        background-position: center;\n      }\n\n      .session-container {\n        position: relative;\n        display: flex;\n        flex-direction: column;\n        align-items: flex-end;\n      }\n\n      .session-info {\n        color: var(--text-secondary);\n        font-family: monospace;\n        font-size: 12px;\n        cursor: pointer;\n        padding: 2px 5px;\n        border-radius: 4px;\n        transition: background-color 0.2s ease;\n        user-select: none;\n      }\n\n      .session-info:hover {\n        background-color: #1c2128;\n      }\n\n      .session-id {\n        color: #fff;\n      }\n\n      .session-tooltip {\n        position: absolute;\n        top: 100%;\n        right: 0;\n        background-color: #1c2128;\n        border: 1px solid var(--border-color);\n        border-radius: 6px;\n        padding: 10px;\n        z-index: 100;\n        width: 250px;\n        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);\n        margin-top: 5px;\n        opacity: 0;\n        transform: translateY(-10px);\n        pointer-events: none;\n        visibility: hidden;\n        transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s;\n      }\n\n      .session-tooltip::before {\n        content: \"\";\n        position: absolute;\n        top: -10px;\n        left: 0;\n        width: 100%;\n        height: 10px;\n        background: transparent;\n      }\n\n      .session-container:hover .session-tooltip,\n      .session-tooltip.visible {\n        opacity: 1;\n        transform: translateY(0);\n        pointer-events: auto;\n        visibility: visible;\n      }\n\n      .tooltip-row {\n        display: flex;\n        justify-content: space-between;\n        margin-bottom: 5px;\n        font-size: 11px;\n      }\n\n      .tooltip-label {\n        color: var(--text-secondary);\n      }\n\n      .tooltip-value {\n        color: var(--text-primary);\n        font-family: monospace;\n        user-select: text;\n      }\n\n      /* Mobile Responsiveness */\n      @media (max-width: 768px) {\n        .app-header {\n          height: auto;\n          flex-wrap: wrap;\n          padding: 10px;\n          gap: 10px;\n        }\n\n        .brand {\n          font-size: 14px;\n        }\n\n        .session-container {\n          align-items: flex-start;\n          display: none;\n          /* Hide session info on mobile to save space */\n        }\n\n        .trace-toolbar {\n          height: auto;\n          flex-wrap: wrap;\n          padding: 10px;\n          gap: 10px;\n          justify-content: space-between;\n        }\n\n        /* Hide non-essential info on mobile */\n        .trace-toolbar > div:first-child,\n        #statsLabel {\n          display: none;\n        }\n\n        .search-widget {\n          width: 100%;\n          order: 3;\n          margin-top: 5px;\n        }\n\n        .view-toggle {\n          width: 100%;\n          display: flex;\n        }\n\n        .view-btn {\n          flex: 1;\n          text-align: center;\n        }\n\n        .row-list {\n          width: 60vw;\n          /* Use viewport width to prevent runaway expansion */\n        }\n\n        .col-list {\n          width: 60vw;\n          flex: none;\n        }\n\n        .details-panel.visible {\n          position: fixed;\n          top: 0;\n          left: 0;\n          width: 100%;\n          height: 100%;\n          z-index: 1000;\n          border-left: none;\n        }\n\n        .details-header-top {\n          margin-top: 10px;\n        }\n\n        /* Fix Details Header Overflow */\n        .details-title-group {\n          min-width: 0;\n          flex: 1;\n          margin-right: 10px;\n        }\n\n        .details-name-large {\n          white-space: nowrap;\n          overflow: hidden;\n          text-overflow: ellipsis;\n        }\n\n        .details-actions {\n          flex-shrink: 0;\n        }\n\n        /* Allow wrapping for paths on mobile */\n        .details-path-row,\n        .origin-row,\n        .remote-path-copy {\n          white-space: normal !important;\n          word-break: break-all;\n        }\n      }\n\n      /* Scrollbars */\n      ::-webkit-scrollbar {\n        width: 10px;\n        height: 10px;\n      }\n\n      ::-webkit-scrollbar-track {\n        background: #0d1117;\n      }\n\n      ::-webkit-scrollbar-thumb {\n        background: #30363d;\n        border-radius: 5px;\n        border: 2px solid #0d1117;\n      }\n\n      ::-webkit-scrollbar-thumb:hover {\n        background: #8b949e;\n      }\n\n      ::-webkit-scrollbar-corner {\n        background: var(--bg-color);\n      }\n\n      /* Heatmap Styles */\n      .heatmap-container {\n        flex: 1;\n        display: none;\n        flex-direction: column;\n        overflow: hidden;\n        background-color: var(--bg-color);\n        position: relative;\n      }\n\n      .heatmap-container.visible {\n        display: flex;\n      }\n\n      .heatmap-canvas {\n        flex: 1;\n        width: 100%;\n        height: 100%;\n      }\n\n      .view-toggle {\n        display: flex;\n        background: #1c2128;\n        border: 1px solid var(--border-color);\n        border-radius: 4px;\n        overflow: hidden;\n      }\n\n      .view-btn {\n        padding: 4px 12px;\n        font-size: 12px;\n        cursor: pointer;\n        color: var(--text-secondary);\n        background: transparent;\n        border: none;\n        transition: all 0.2s;\n      }\n\n      .view-btn.active {\n        background: var(--accent-blue);\n        color: white;\n      }\n\n      .view-btn:hover:not(.active) {\n        background: #30363d;\n      }\n\n      /* Main Layout */\n      .main-container {\n        display: flex;\n        flex: 1;\n        overflow: hidden;\n      }\n\n      /* Left Panel: Trace View */\n      .trace-panel {\n        flex: 1;\n        display: flex;\n        flex-direction: column;\n        border-right: 1px solid var(--border-color);\n        min-width: 0;\n        overflow: hidden;\n      }\n\n      .trace-toolbar {\n        height: 40px;\n        border-bottom: 1px solid var(--border-color);\n        display: flex;\n        align-items: center;\n        padding: 0 10px;\n        gap: 10px;\n        background-color: var(--bg-color);\n        flex-shrink: 0;\n      }\n\n      .search-widget {\n        display: flex;\n        flex-direction: column;\n        background-color: var(--bg-color);\n        border: 1px solid var(--border-color);\n        border-radius: 6px;\n        width: 320px;\n        position: relative;\n        transition: border-color 0.2s ease, border-radius 0.2s ease;\n        box-sizing: border-box;\n      }\n\n      .search-widget:focus-within {\n        border-color: var(--accent-blue);\n      }\n\n      .search-widget:focus-within > .search-options {\n        border-color: var(--accent-blue);\n      }\n\n      .search-widget.expanded {\n        border-bottom-left-radius: 0;\n        border-bottom-right-radius: 0;\n        border-bottom-color: transparent;\n      }\n\n      .search-row {\n        display: flex;\n        align-items: center;\n        padding: 4px;\n      }\n\n      .search-chevron {\n        cursor: pointer;\n        padding: 2px;\n        color: var(--text-secondary);\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        transition: transform 0.2s ease, color 0.2s ease;\n        width: 20px;\n        height: 20px;\n        border-radius: 4px;\n      }\n\n      .search-chevron:hover {\n        background-color: rgba(255, 255, 255, 0.1);\n        color: var(--text-primary);\n      }\n\n      .search-chevron.expanded {\n        transform: rotate(90deg);\n      }\n\n      .search-input-container {\n        flex: 1;\n        display: flex;\n        align-items: center;\n        margin-left: 4px;\n      }\n\n      .search-input {\n        background: transparent;\n        border: none;\n        color: var(--text-primary);\n        font-size: 12px;\n        width: 100%;\n        outline: none;\n        height: 20px;\n      }\n\n      .search-options {\n        transition: border-color 0.2s ease, border-radius 0.2s ease;\n        display: none;\n        padding: 10px;\n        border: 1px solid var(--border-color);\n        border-top: none;\n        background-color: var(--bg-color);\n        flex-direction: column;\n        gap: 12px;\n        position: absolute;\n        top: 100%;\n        left: -1px;\n        right: -1px;\n        z-index: 100;\n        border-bottom-left-radius: 6px;\n        border-bottom-right-radius: 6px;\n        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);\n        box-sizing: border-box;\n      }\n\n      .search-options.visible {\n        display: flex;\n      }\n\n      .time-range-row {\n        display: flex;\n        align-items: center;\n        gap: 8px;\n        font-size: 11px;\n        color: var(--text-secondary);\n      }\n\n      .filter-options-row {\n        display: flex;\n        flex-wrap: wrap;\n        gap: 8px;\n        padding-top: 8px;\n        border-top: 1px solid var(--border-color);\n      }\n\n      .filter-checkbox-label {\n        display: flex;\n        align-items: center;\n        gap: 4px;\n        font-size: 11px;\n        color: var(--text-secondary);\n        cursor: pointer;\n        user-select: none;\n      }\n\n      .filter-checkbox-label:hover {\n        color: var(--text-primary);\n      }\n\n      .filter-checkbox {\n        accent-color: var(--accent-blue);\n      }\n\n      .time-input-styled {\n        background-color: #161b22;\n        border: 1px solid var(--border-color);\n        color: var(--text-primary);\n        border-radius: 4px;\n        padding: 4px 8px;\n        width: 60px;\n        outline: none;\n        font-size: 11px;\n        transition: border-color 0.2s ease;\n        margin: 0 2px;\n      }\n\n      .time-input-styled:focus {\n        border-color: var(--accent-blue);\n      }\n\n      .unit-select {\n        background-color: #161b22;\n        border: 1px solid var(--border-color);\n        color: var(--text-primary);\n        border-radius: 4px;\n        outline: none;\n        font-size: 11px;\n        padding: 3px 6px;\n        cursor: pointer;\n        transition: border-color 0.2s ease;\n      }\n\n      .unit-select:focus {\n        border-color: var(--accent-blue);\n      }\n\n      .trace-header-row {\n        display: flex;\n        height: 30px;\n        border-bottom: 1px solid var(--border-color);\n        background-color: var(--surface-color);\n        font-size: 11px;\n        color: var(--text-secondary);\n        line-height: 30px;\n        flex-shrink: 0;\n      }\n\n      .col-list {\n        width: 300px;\n        padding-left: 15px;\n        border-right: 1px solid var(--border-color);\n        flex-shrink: 0;\n        z-index: 5;\n        background-color: var(--surface-color);\n        box-sizing: border-box;\n        /* Match row-list */\n      }\n\n      .col-timeline {\n        flex: 1;\n        position: relative;\n        overflow: hidden;\n        min-width: calc(100vw - 300px);\n      }\n\n      .timeline-ruler {\n        position: relative;\n        top: 0;\n        left: 0;\n        height: 100%;\n        pointer-events: none;\n      }\n\n      .tick {\n        position: absolute;\n        top: 0;\n        bottom: 0;\n        border-left: 1px solid #30363d;\n        font-size: 10px;\n        color: #484f58;\n        padding-left: 4px;\n      }\n\n      .trace-rows {\n        flex: 1;\n        overflow: auto;\n        /* Ensure both scrollbars appear */\n        position: relative;\n        contain: strict;\n      }\n\n      .virtual-spacer {\n        position: absolute;\n        top: 0;\n        left: 0;\n        width: 1px;\n      }\n\n      .virtual-content {\n        position: absolute;\n        top: 0;\n        left: 0;\n        width: 100%;\n      }\n\n      .trace-row {\n        display: flex;\n        height: 28px;\n        /* align-items: center;  Removed to allow children to stretch */\n        cursor: pointer;\n        /* border-bottom: 1px solid #1c2128; Moved to children */\n        width: fit-content;\n        min-width: 100%;\n        transition: background-color 0.1s ease;\n        box-sizing: border-box;\n      }\n\n      .trace-row:hover {\n        background-color: #1c2128;\n      }\n\n      .trace-row.selected {\n        background-color: rgba(88, 166, 255, 0.1);\n      }\n\n      .trace-row.hidden {\n        display: none;\n      }\n\n      .trace-row:hover * {\n        background-color: #1c2128;\n      }\n\n      .trace-row.selected * {\n        background-color: #1c2333;\n      }\n\n      .row-list {\n        width: 300px;\n        padding-left: 15px;\n        /* Use box-shadow for sticky border to prevent it from disappearing */\n        box-shadow: 1px 0 0 0 var(--border-color);\n        border-right: none;\n        border-bottom: 1px solid #1c2128;\n        /* Added border here */\n        display: flex;\n        align-items: center;\n        overflow: hidden;\n        flex-shrink: 0;\n        box-sizing: border-box;\n        position: sticky;\n        left: 0;\n        background-color: var(--bg-color);\n        z-index: 2;\n        transition: background-color 0.1s ease;\n        height: 100%;\n      }\n\n      .row-timeline {\n        flex: 1;\n        position: relative;\n        height: 100%;\n        overflow: hidden;\n        border-bottom: 1px solid #1c2128;\n        /* Added border here */\n        box-sizing: border-box;\n        /* Ensure border is inside height */\n      }\n\n      .type-icon {\n        width: 16px;\n        height: 16px;\n        margin-right: 8px;\n        flex-shrink: 0;\n        background-size: contain;\n        background-repeat: no-repeat;\n        background-position: center;\n      }\n\n      .remote-name {\n        white-space: nowrap;\n        overflow: hidden;\n        text-overflow: ellipsis;\n        color: var(--text-primary);\n        font-size: 12px;\n      }\n\n      .timeline-marker {\n        position: absolute;\n        top: 10px;\n        height: 8px;\n        min-width: 4px;\n        border-radius: 4px;\n        opacity: 0.9;\n      }\n\n      .timeline-marker.incoming {\n        background: linear-gradient(90deg, var(--accent-green), #2ea043);\n      }\n\n      .timeline-marker.outgoing {\n        background: linear-gradient(90deg, var(--accent-orange), #b08800);\n      }\n\n      /* Right Panel: Details */\n      .details-panel {\n        width: 0;\n        opacity: 0;\n        background-color: var(--bg-color);\n        border-left: 0 solid var(--border-color);\n        display: flex;\n        flex-direction: column;\n        padding: 0;\n        box-sizing: border-box;\n        overflow-y: auto;\n        overflow-x: hidden;\n        position: relative;\n        flex-shrink: 0;\n        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.2s ease,\n          padding 0.3s ease;\n      }\n\n      .details-panel.visible {\n        width: 450px;\n        opacity: 1;\n        padding: 20px;\n        border-left: 1px solid var(--border-color);\n      }\n\n      /* Header */\n      .details-header-top {\n        display: flex;\n        align-items: center;\n        justify-content: space-between;\n        margin-bottom: 10px;\n      }\n\n      .details-title-group {\n        display: flex;\n        align-items: center;\n        gap: 10px;\n      }\n\n      .details-icon-large {\n        width: 32px;\n        height: 32px;\n        background-size: contain;\n        background-repeat: no-repeat;\n        background-position: center;\n      }\n\n      .details-name-large {\n        font-size: 20px;\n        font-weight: 600;\n        color: #fff;\n      }\n\n      .details-actions {\n        display: flex;\n        align-items: center;\n        gap: 10px;\n      }\n\n      .close-btn {\n        cursor: pointer;\n        color: var(--text-secondary);\n        font-size: 20px;\n        transition: color 0.2s ease;\n        line-height: 1;\n      }\n\n      .close-btn:hover {\n        color: #fff;\n      }\n\n      /* Unified Badge Style */\n      .badge-pill {\n        padding: 4px 12px;\n        border-radius: 20px;\n        font-size: 11px;\n        font-weight: 600;\n        text-transform: uppercase;\n        border: 1px solid;\n        letter-spacing: 0.5px;\n        white-space: nowrap;\n      }\n\n      .badge-pill.incoming {\n        color: var(--accent-green);\n        border-color: var(--accent-green);\n      }\n\n      .badge-pill.outgoing {\n        color: var(--accent-orange);\n        border-color: var(--accent-orange);\n      }\n\n      .badge-pill.executor {\n        color: var(--accent-green);\n        border-color: var(--accent-green);\n      }\n\n      .badge-pill.actor {\n        color: var(--accent-red);\n        border-color: var(--accent-red);\n        background: repeating-linear-gradient(\n          45deg,\n          transparent,\n          transparent 2px,\n          rgba(255, 123, 114, 0.1) 2px,\n          rgba(255, 123, 114, 0.1) 4px\n        );\n      }\n\n      .badge-pill.blocked {\n        color: var(--accent-red);\n        border-color: var(--accent-red);\n      }\n\n      .details-path-row {\n        color: var(--text-secondary);\n        font-size: 12px;\n        margin-bottom: 20px;\n        font-family: monospace;\n        white-space: nowrap;\n        text-overflow: ellipsis;\n        overflow: hidden;\n        height: 1.2em;\n      }\n\n      .remote-path-copy {\n        cursor: pointer;\n        color: var(--text-secondary);\n        font-size: 12px;\n        font-weight: normal;\n        transition: color 0.2s ease;\n        white-space: nowrap;\n        overflow: hidden;\n        text-overflow: ellipsis;\n        display: block;\n        width: 25%;\n      }\n\n      .remote-path-copy:hover {\n        color: var(--accent-blue);\n      }\n\n      /* Info Grid 2 */\n      .info-grid-2 {\n        display: flex;\n        gap: 20px;\n        margin-bottom: 25px;\n      }\n\n      .info-item-2 h4 {\n        margin: 0 0 6px 0;\n        color: var(--text-secondary);\n        font-size: 12px;\n        font-weight: normal;\n      }\n\n      .info-item-2 div {\n        font-size: 11px;\n        color: var(--text-primary);\n        font-family: monospace;\n      }\n\n      /* Info Grid */\n      .info-grid {\n        display: grid;\n        grid-template-columns: 1fr 1fr;\n        gap: 20px;\n        margin-bottom: 25px;\n      }\n\n      .info-item h4 {\n        margin: 0 0 6px 0;\n        color: var(--text-secondary);\n        font-size: 12px;\n        font-weight: normal;\n      }\n\n      .info-item div {\n        font-size: 14px;\n        color: var(--text-primary);\n        font-family: monospace;\n      }\n\n      .clickable-path {\n        border-bottom: 1px dashed var(--text-secondary);\n        cursor: pointer;\n        transition: color 0.2s, border-color 0.2s;\n      }\n\n      .clickable-path:hover {\n        color: var(--accent-blue);\n        border-color: var(--accent-blue);\n      }\n\n      /* Content Boxes */\n      .content-box {\n        border: 1px solid var(--border-color);\n        border-radius: 8px;\n        padding: 15px;\n        margin-bottom: 20px;\n        position: relative;\n        background-color: rgba(22, 27, 34, 0.5);\n      }\n\n      .box-title {\n        position: absolute;\n        top: -10px;\n        left: 10px;\n        background-color: var(--bg-color);\n        padding: 0 5px;\n        font-size: 11px;\n        color: var(--text-secondary);\n      }\n\n      .caller-header {\n        display: flex;\n        align-items: center;\n        gap: 10px;\n        margin-bottom: 15px;\n      }\n\n      .caller-icon {\n        color: var(--text-secondary);\n        display: flex;\n        align-items: center;\n        justify-content: center;\n      }\n\n      .caller-icon svg {\n        width: 24px;\n        height: 24px;\n      }\n\n      .caller-info {\n        flex: 1;\n        min-width: 0;\n        /* Critical for flex child truncation */\n      }\n\n      .caller-name {\n        color: var(--accent-blue);\n        font-family: monospace;\n        font-size: 14px;\n        margin-bottom: 2px;\n      }\n\n      .caller-source {\n        color: var(--text-secondary);\n        font-size: 11px;\n        font-family: monospace;\n        height: 1.2em;\n        white-space: nowrap;\n        overflow: hidden;\n        text-overflow: ellipsis;\n        display: block;\n      }\n\n      .flags-row {\n        display: flex;\n        gap: 10px;\n        margin-bottom: 10px;\n        align-items: center;\n      }\n\n      .origin-row {\n        font-size: 12px;\n        color: var(--text-primary);\n        font-family: monospace;\n        display: block;\n        white-space: nowrap;\n        height: 1.2em;\n        overflow: hidden;\n        text-overflow: ellipsis;\n        width: 35%;\n      }\n\n      /* Arguments */\n      .args-content {\n        font-family: \"Consolas\", \"Monaco\", monospace;\n        font-size: 12px;\n        white-space: pre-wrap;\n        overflow-x: auto;\n        color: #e0e0e0;\n        max-height: 300px;\n        overflow-y: auto;\n        line-height: 1.5;\n      }\n\n      /* Copy Button with Animation */\n      .copy-icon-btn {\n        position: absolute;\n        top: 10px;\n        right: 10px;\n        background: transparent;\n        border: 1px solid var(--border-color);\n        border-radius: 4px;\n        color: var(--text-secondary);\n        cursor: pointer;\n        width: 28px;\n        height: 28px;\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        transition: all 0.2s;\n        overflow: hidden;\n        /* Ensure check icon doesn't spill out */\n      }\n\n      .copy-icon-btn:hover {\n        border-color: var(--text-primary);\n        color: var(--text-primary);\n        background-color: var(--surface-color);\n      }\n\n      .copy-icon-btn svg {\n        width: 14px;\n        height: 14px;\n        position: absolute;\n        top: 50%;\n        left: 50%;\n        transform: translate(-50%, -50%) scale(1);\n        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);\n      }\n\n      .copy-icon-btn .icon-check {\n        transform: translate(-50%, -50%) scale(0);\n        color: var(--accent-green);\n      }\n\n      .copy-icon-btn.copied .icon-copy {\n        transform: translate(-50%, -50%) scale(0);\n      }\n\n      .copy-icon-btn.copied .icon-check {\n        transform: translate(-50%, -50%) scale(1);\n      }\n\n      /* Dropdown */\n      .dropdown-menu {\n        position: absolute;\n        top: 42px;\n        /* Button height + spacing */\n        right: 10px;\n        background-color: #1c2128;\n        border: 1px solid var(--border-color);\n        border-radius: 6px;\n        width: 160px;\n        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);\n        z-index: 50;\n        display: none;\n        overflow: hidden;\n      }\n\n      .dropdown-menu.visible {\n        display: block;\n      }\n\n      .dropdown-item {\n        padding: 8px 12px;\n        font-size: 12px;\n        color: var(--text-primary);\n        cursor: pointer;\n        transition: background-color 0.2s;\n        display: flex;\n        align-items: center;\n        gap: 8px;\n      }\n\n      .dropdown-item:hover {\n        background-color: var(--accent-blue);\n        color: #fff;\n      }\n\n      .dropdown-item svg {\n        width: 14px;\n        height: 14px;\n        opacity: 0.7;\n      }\n\n      /* Toast Notification */\n      .toast-container {\n        position: fixed;\n        bottom: 30px;\n        left: 50%;\n        transform: translateX(-50%) translateY(20px);\n        background-color: #1c2128;\n        border: 1px solid var(--border-color);\n        border-radius: 6px;\n        padding: 8px 16px;\n        color: #fff;\n        font-size: 12px;\n        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);\n        opacity: 0;\n        transition: opacity 0.3s, transform 0.3s;\n        pointer-events: none;\n        z-index: 1000;\n        display: flex;\n        align-items: center;\n        gap: 8px;\n      }\n\n      .toast-container.visible {\n        opacity: 1;\n        transform: translateX(-50%) translateY(0);\n      }\n\n      .toast-container svg {\n        width: 16px;\n        height: 16px;\n        color: var(--accent-green);\n      }\n\n      /* Syntax Highlighting */\n      .hl-str {\n        color: #a5d6ff;\n      }\n\n      .hl-num {\n        color: #79c0ff;\n      }\n\n      .hl-bool {\n        color: #ff7b72;\n      }\n\n      .hl-key {\n        color: #7ee787;\n      }\n\n      .hl-nil {\n        color: #ff7b72;\n      }\n\n      .footer {\n        height: 25px;\n        border-top: 1px solid var(--border-color);\n        display: flex;\n        align-items: center;\n        justify-content: space-between;\n        padding: 0 20px;\n        background-color: var(--bg-color);\n        color: var(--text-secondary);\n        font-size: 11px;\n        flex-shrink: 0;\n      }\n    </style>\n  </head>\n\n  <body>\n    <div class=\"app-header\">\n      <a\n        href=\"https://gitlab.com/upio/cobalt/-/tree/main\"\n        target=\"_blank\"\n        style=\"text-decoration: none\"\n      >\n        <div class=\"brand\">\n          <div class=\"brand-icon\"></div>\n          Cobalt - Session Viewer\n        </div>\n      </a>\n      <div class=\"session-container\">\n        <div class=\"session-info\">\n          Session / <span class=\"session-id\">{{SESSION_ID}}</span>\n        </div>\n        <div class=\"session-tooltip\">\n          <div class=\"tooltip-row\">\n            <span class=\"tooltip-label\">Start Time (tick)</span>\n            <span class=\"tooltip-value\">{{START_TIME}}</span>\n          </div>\n          <div class=\"tooltip-row\">\n            <span class=\"tooltip-label\">Place ID</span>\n            <span class=\"tooltip-value\">{{PLACE_ID}}</span>\n          </div>\n          <div class=\"tooltip-row\">\n            <span class=\"tooltip-label\">Job ID</span>\n            <span class=\"tooltip-value\">{{JOB_ID}}</span>\n          </div>\n        </div>\n      </div>\n    </div>\n\n    <div class=\"main-container\">\n      <!-- LEFT PANEL WRAPPER -->\n      <div\n        class=\"left-panel-wrapper\"\n        style=\"\n          flex: 1;\n          display: flex;\n          flex-direction: column;\n          border-right: 1px solid var(--border-color);\n          min-width: 0;\n          overflow: hidden;\n        \"\n      >\n        <!-- SHARED TOOLBAR -->\n        <div class=\"trace-toolbar\">\n          <div\n            style=\"\n              font-size: 11px;\n              color: var(--text-secondary);\n              margin-right: 20px;\n            \"\n          >\n            Started: {{DATE}}\n          </div>\n          <div style=\"flex: 1\"></div>\n          <div class=\"view-toggle\">\n            <button class=\"view-btn active\" onclick=\"switchView('timeline')\">\n              Timeline\n            </button>\n            <button class=\"view-btn\" onclick=\"switchView('heatmap')\">\n              Heatmap\n            </button>\n          </div>\n          <div class=\"divider\"></div>\n          <div class=\"search-widget\">\n            <div class=\"search-row\">\n              <div\n                class=\"search-chevron\"\n                onclick=\"toggleSearchOptions()\"\n                id=\"searchChevron\"\n              >\n                <svg\n                  width=\"16\"\n                  height=\"16\"\n                  viewBox=\"0 0 16 16\"\n                  fill=\"currentColor\"\n                >\n                  <path\n                    d=\"M6 4l4 4-4 4\"\n                    stroke=\"currentColor\"\n                    stroke-width=\"1.5\"\n                    fill=\"none\"\n                  />\n                </svg>\n              </div>\n              <div class=\"search-input-container\">\n                <input\n                  type=\"text\"\n                  class=\"search-input\"\n                  id=\"filterInput\"\n                  placeholder=\"Filter events...\"\n                  oninput=\"handleFilterInput()\"\n                />\n              </div>\n            </div>\n            <div class=\"search-options\" id=\"searchOptions\">\n              <div class=\"time-range-row\">\n                <span>Time Range:</span>\n                <input\n                  type=\"number\"\n                  class=\"time-input-styled\"\n                  id=\"minTimeInput\"\n                  placeholder=\"Start\"\n                  oninput=\"handleTimeInput()\"\n                />\n                <span>-</span>\n                <input\n                  type=\"number\"\n                  class=\"time-input-styled\"\n                  id=\"maxTimeInput\"\n                  placeholder=\"End\"\n                  oninput=\"handleTimeInput()\"\n                />\n                <select\n                  class=\"unit-select\"\n                  id=\"timeUnitSelect\"\n                  onchange=\"handleTimeInput()\"\n                >\n                  <option value=\"1\">s</option>\n                  <option value=\"0.001\">ms</option>\n                </select>\n              </div>\n              <div class=\"filter-options-row\">\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterIncoming\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Incoming</label\n                >\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterOutgoing\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Outgoing</label\n                >\n                <div\n                  style=\"\n                    width: 1px;\n                    height: 14px;\n                    background: var(--border-color);\n                    margin: 0 4px;\n                  \"\n                ></div>\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterActor\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Actor</label\n                >\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterNonActor\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Non-Actor</label\n                >\n                <div\n                  style=\"\n                    width: 1px;\n                    height: 14px;\n                    background: var(--border-color);\n                    margin: 0 4px;\n                  \"\n                ></div>\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterArgs\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Args</label\n                >\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterProto\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Proto</label\n                >\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterConst\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Const</label\n                >\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterHash\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Hash</label\n                >\n                <label class=\"filter-checkbox-label\"\n                  ><input\n                    type=\"checkbox\"\n                    class=\"filter-checkbox\"\n                    id=\"filterSource\"\n                    onchange=\"handleFilterInput()\"\n                  />\n                  Source</label\n                >\n              </div>\n            </div>\n          </div>\n        </div>\n\n        <!-- TIMELINE VIEW -->\n        <div class=\"trace-panel\" id=\"timelinePanel\" style=\"border-right: none\">\n          <div class=\"trace-header-row\">\n            <div class=\"col-list\">Remote</div>\n            <div class=\"col-timeline\" id=\"timelineHeader\">\n              <div class=\"timeline-ruler\" id=\"ruler\"></div>\n            </div>\n          </div>\n\n          <div class=\"trace-rows\" id=\"rowsContainer\">\n            <div id=\"virtualSpacer\" class=\"virtual-spacer\"></div>\n            <div id=\"virtualContent\" class=\"virtual-content\"></div>\n          </div>\n        </div>\n\n        <!-- HEATMAP VIEW -->\n        <div class=\"heatmap-container\" id=\"heatmapPanel\">\n          <div\n            id=\"heatmapScroll\"\n            style=\"\n              width: 100%;\n              height: 100%;\n              overflow-x: auto;\n              overflow-y: hidden;\n              position: relative;\n            \"\n          >\n            <div\n              id=\"heatmapSpacer\"\n              style=\"\n                height: 1px;\n                width: 100%;\n                position: absolute;\n                top: 0;\n                left: 0;\n                pointer-events: none;\n              \"\n            ></div>\n            <canvas\n              id=\"heatmapCanvas\"\n              class=\"heatmap-canvas\"\n              style=\"\n                position: sticky;\n                left: 0;\n                top: 0;\n                width: 100%;\n                height: 100%;\n              \"\n            ></canvas>\n          </div>\n          <div\n            id=\"heatmapTooltip\"\n            class=\"heatmap-tooltip\"\n            style=\"\n              display: none;\n              position: absolute;\n              background: #1c2128;\n              border: 1px solid #30363d;\n              padding: 4px 8px;\n              border-radius: 4px;\n              font-size: 11px;\n              color: #c9d1d9;\n              pointer-events: none;\n              z-index: 100;\n            \"\n          ></div>\n        </div>\n      </div>\n\n      <!-- RIGHT PANEL -->\n      <div class=\"details-panel\" id=\"detailsPanel\">\n        <div id=\"detailsContent\"></div>\n      </div>\n    </div>\n\n    <div class=\"footer\">\n      <div>Ended: {{END_DATE}}</div>\n      <span\n        id=\"statsLabel\"\n        style=\"\n          color: var(--text-secondary);\n          font-size: 11px;\n          margin-right: 10px;\n        \"\n      >\n        {{EVENT_COUNT}} Events \226\128\162 {{TOTAL_DURATION}}s\n      </span>\n    </div>\n\n    <!-- Toast Notification -->\n    <div id=\"toast\" class=\"toast-container\">\n      <svg\n        xmlns=\"http://www.w3.org/2000/svg\"\n        width=\"24\"\n        height=\"24\"\n        viewBox=\"0 0 24 24\"\n        fill=\"none\"\n        stroke=\"currentColor\"\n        stroke-width=\"2\"\n        stroke-linecap=\"round\"\n        stroke-linejoin=\"round\"\n        class=\"lucide lucide-check\"\n      >\n        <path d=\"M20 6 9 17l-5-5\" />\n      </svg>\n      <span id=\"toastMessage\">Copied to clipboard</span>\n    </div>\n\n    <!-- Data Script -->\n    <script type=\"application/json\" id=\"dictionary-data\">\n      {{DICTIONARY_JSON}}\n    </script>\n    <script type=\"application/json\" id=\"event-data\">\n      {{EVENTS_JSON}}\n    </script>\n\n    <script>\n      // Data Parsing\n      let startTime = {{START_TIME}}; // Seconds\n      const totalDuration = {{DURATION}};\n      const dictionary = JSON.parse(document.getElementById('dictionary-data').textContent);\n      const rawEvents = JSON.parse(document.getElementById('event-data').textContent);\n\n      // Reconstruct Events\n      const allEvents = rawEvents.map(e => ({\n        name: dictionary[e[0]],\n        className: dictionary[e[1]],\n        path: dictionary[e[2]],\n        type: dictionary[e[3]],\n        timestamp: e[4],\n        origin: dictionary[e[5]],\n\n        args: dictionary[e[6]],\n        method: dictionary[e[7]],\n\n        funcName: dictionary[e[8]],\n        funcLine: e[9],\n        funcSource: dictionary[e[10]],\n        isExecutor: e[11] === 1,\n        isActor: e[12] === 1,\n\n        funcHash: dictionary[e[13]],\n        upvalues: dictionary[e[14]],\n        protos: dictionary[e[15]],\n        constants: dictionary[e[16]],\n        isBlocked: e[17] === 1\n      }));\n\n      if (allEvents.length > 0) {\n        const minTimestamp = Math.min(...allEvents.map(e => e.timestamp));\n        if (minTimestamp < startTime) {\n          startTime = minTimestamp;\n        }\n      }\n\n      // Preprocess events\n      allEvents.forEach(evt => {\n        evt.relTime = Math.max(0, evt.timestamp - startTime);\n\n        const typeLower = evt.type.toLowerCase();\n        const methodLower = evt.method ? evt.method.toLowerCase() : '';\n\n        if (methodLower.includes('client') || typeLower.includes('client')) {\n          evt.typeClass = 'incoming';\n        } else {\n          evt.typeClass = 'outgoing';\n        }\n      });\n\n      // State\n      let filteredEvents = allEvents;\n      let zoomLevel = 1;\n      let selectedEvent = null;\n      let filterTimeout = null;\n      let filterMinTime = 0;\n      let filterMaxTime = totalDuration;\n\n      // Initialize Time Inputs\n      document.getElementById('minTimeInput').value = \"0\";\n      document.getElementById('maxTimeInput').value = totalDuration.toFixed(2);\n\n      // Virtual Scroll State\n      let lastStartIndex = -1;\n      let lastEndIndex = -1;\n      let isScrolling = false;\n\n      // DOM Elements\n      const rowsContainer = document.getElementById('rowsContainer');\n      const virtualSpacer = document.getElementById('virtualSpacer');\n      const virtualContent = document.getElementById('virtualContent');\n      const rulerContainer = document.getElementById('ruler');\n      const detailsPanel = document.getElementById('detailsPanel');\n      const detailsContent = document.getElementById('detailsContent');\n      const timelineHeader = document.getElementById('timelineHeader');\n      const statsLabel = document.getElementById('statsLabel');\n\n\n      // Heatmap State\n      let currentView = 'timeline';\n      let heatmapZoom = 1;\n      let detailsWasVisible = false;\n      const heatmapCanvas = document.getElementById('heatmapCanvas');\n      const heatmapTooltip = document.getElementById('heatmapTooltip');\n\n      const timelinePanel = document.getElementById('timelinePanel');\n      const heatmapPanel = document.getElementById('heatmapPanel');\n\n      // Heatmap Interaction\n      heatmapCanvas.addEventListener('wheel', (e) => {\n        if (currentView !== 'heatmap') return;\n        e.preventDefault();\n\n        const delta = e.deltaY > 0 ? 1.1 : 0.9;\n        heatmapZoom = Math.max(1, Math.min(50, heatmapZoom * delta));\n        renderHeatmap();\n      }, { passive: false });\n\n      heatmapCanvas.addEventListener('mousemove', (e) => {\n        if (currentView !== 'heatmap') return;\n        const rect = heatmapCanvas.getBoundingClientRect();\n        const x = e.clientX - rect.left;\n        const y = e.clientY - rect.top;\n\n        if (!window.lastHeatmapData) return;\n\n        const { sortedRemotes, rowHeight, binWidth, remotes, maxBinCount, timeBins, binDuration, margin, scrollLeft } = window.lastHeatmapData;\n        const width = heatmapPanel.clientWidth;\n        const height = heatmapPanel.clientHeight;\n\n        if (x < margin.left || x > width - margin.right || y < margin.top || y > height - margin.bottom) {\n          heatmapTooltip.style.display = 'none';\n          return;\n        }\n\n        const rowIndex = Math.floor((y - margin.top) / rowHeight);\n\n        // Calculate colIndex based on virtual position (x + scrollLeft)\n        const colIndex = Math.floor((x - margin.left + scrollLeft) / binWidth);\n\n        if (rowIndex >= 0 && rowIndex < sortedRemotes.length && colIndex >= 0 && colIndex < timeBins) {\n          const remote = sortedRemotes[rowIndex];\n          // Calculate count for this bin\n          let count = 0;\n          remotes[remote].forEach(evt => {\n            const binIndex = Math.min(Math.floor(evt.relTime / binDuration), timeBins - 1);\n            if (binIndex === colIndex) count++;\n          });\n\n          heatmapTooltip.style.display = 'block';\n          heatmapTooltip.innerHTML = `<b>${remote}</b><br>Time: ${(colIndex * binDuration).toFixed(1)}s<br>Count: ${count}`;\n\n          const tooltipWidth = heatmapTooltip.offsetWidth;\n          const panelWidth = heatmapPanel.clientWidth;\n\n          let leftPos = x + 10;\n          if (leftPos + tooltipWidth > panelWidth - 10) {\n            leftPos = x - tooltipWidth - 10;\n          }\n\n          heatmapTooltip.style.left = leftPos + 'px';\n          heatmapTooltip.style.top = (y + 10) + 'px';\n        } else {\n          heatmapTooltip.style.display = 'none';\n        }\n      });\n\n      heatmapCanvas.addEventListener('mouseleave', () => {\n        heatmapTooltip.style.display = 'none';\n      });\n\n      document.getElementById('heatmapScroll').addEventListener('scroll', () => {\n        if (currentView === 'heatmap') {\n          renderHeatmap();\n        }\n      });\n\n      function switchView(view) {\n        currentView = view;\n        document.querySelectorAll('.view-btn').forEach(btn => {\n          btn.classList.toggle('active', btn.innerText.toLowerCase() === view);\n        });\n\n        if (view === 'timeline') {\n          timelinePanel.style.display = 'flex';\n          heatmapPanel.classList.remove('visible');\n\n          if (detailsWasVisible) {\n            detailsPanel.classList.add('visible');\n          }\n\n          renderVirtualRows(true);\n        } else {\n          if (detailsPanel.classList.contains('visible')) {\n            detailsWasVisible = true;\n            detailsPanel.classList.remove('visible');\n          } else {\n            detailsWasVisible = false;\n          }\n\n          timelinePanel.style.display = 'none';\n          heatmapPanel.classList.add('visible');\n          renderHeatmap();\n        }\n      }\n\n      function renderHeatmap() {\n        const ctx = heatmapCanvas.getContext('2d');\n        const containerWidth = heatmapPanel.clientWidth;\n        const height = heatmapPanel.clientHeight;\n        const scrollLeft = document.getElementById('heatmapScroll').scrollLeft;\n\n        // Calculate total virtual width\n        const totalWidth = containerWidth * heatmapZoom;\n\n        // Update Spacer\n        document.getElementById('heatmapSpacer').style.width = totalWidth + 'px';\n\n        const dpr = window.devicePixelRatio || 1;\n\n        // Canvas is always viewport size\n        heatmapCanvas.width = containerWidth * dpr;\n        heatmapCanvas.height = height * dpr;\n        ctx.scale(dpr, dpr);\n\n        ctx.fillStyle = '#0d1117';\n        ctx.fillRect(0, 0, containerWidth, height);\n\n        if (filteredEvents.length === 0) return;\n\n        const remotes = {};\n        filteredEvents.forEach(evt => {\n          if (!remotes[evt.name]) remotes[evt.name] = [];\n          remotes[evt.name].push(evt);\n        });\n\n        const sortedRemotes = Object.keys(remotes).sort((a, b) => remotes[b].length - remotes[a].length);\n\n        const margin = { top: 30, right: 20, bottom: 20, left: 150 };\n\n        // Virtual chart width\n        const chartWidth = totalWidth - margin.left - margin.right;\n        const chartHeight = height - margin.top - margin.bottom;\n\n        // Apply Zoom to time bins\n        const timeBins = Math.floor(100 * heatmapZoom);\n        const binWidth = chartWidth / timeBins;\n        const binDuration = totalDuration / timeBins;\n\n        // Adjust row height to fit\n        const rowHeight = Math.min(30, chartHeight / sortedRemotes.length);\n\n        // Store data for tooltip (adjusted for virtual scroll)\n        window.lastHeatmapData = { sortedRemotes, rowHeight, binWidth, remotes, timeBins, binDuration, margin, scrollLeft };\n\n        ctx.strokeStyle = '#30363d';\n        ctx.lineWidth = 1;\n\n        ctx.font = '11px -apple-system, BlinkMacSystemFont, \"Segoe UI\", Helvetica, Arial, sans-serif';\n        ctx.textAlign = 'right';\n        ctx.textBaseline = 'middle';\n\n        let maxBinCount = 0;\n        sortedRemotes.forEach(remote => {\n          const bins = new Array(timeBins).fill(0);\n          remotes[remote].forEach(evt => {\n            const binIndex = Math.min(Math.floor(evt.relTime / binDuration), timeBins - 1);\n            bins[binIndex]++;\n          });\n          maxBinCount = Math.max(maxBinCount, ...bins);\n        });\n\n        // Update Legend Labels\n        window.lastHeatmapData.maxBinCount = maxBinCount;\n        window.lastHeatmapData.maxBinCount = maxBinCount;\n\n        sortedRemotes.forEach((remote, i) => {\n          const y = margin.top + (i * rowHeight);\n\n          // Draw Label (Fixed position)\n          ctx.fillStyle = '#8b949e';\n          ctx.fillText(remote.length > 20 ? remote.slice(0, 18) + '...' : remote, margin.left - 10, y + rowHeight / 2);\n\n          // Draw Line\n          ctx.beginPath();\n          ctx.moveTo(margin.left, y);\n          ctx.lineTo(containerWidth - margin.right, y);\n          ctx.stroke();\n\n          const bins = new Array(timeBins).fill(0);\n          remotes[remote].forEach(evt => {\n            const binIndex = Math.min(Math.floor(evt.relTime / binDuration), timeBins - 1);\n            bins[binIndex]++;\n          });\n\n          bins.forEach((count, binIndex) => {\n            if (count === 0) return;\n\n            // Calculate virtual X\n            const virtualX = margin.left + (binIndex * binWidth);\n\n            // Apply scroll offset\n            const screenX = virtualX - scrollLeft;\n\n            // Only draw if visible\n            if (screenX + binWidth < margin.left || screenX > containerWidth - margin.right) return;\n\n            // Clamp to chart area\n            const drawX = Math.max(margin.left, screenX);\n            const drawWidth = Math.min(binWidth, (containerWidth - margin.right) - drawX);\n\n            const intensity = count / maxBinCount;\n            const hue = (1 - intensity) * 240;\n            ctx.fillStyle = `hsla(${hue}, 70%, 50%, 0.8)`;\n\n            ctx.fillRect(drawX, y + 2, drawWidth - 1, rowHeight - 4);\n          });\n        });\n\n        ctx.fillStyle = '#8b949e';\n        ctx.textAlign = 'center';\n        ctx.textBaseline = 'top';\n\n        const numTicks = 5 * Math.ceil(heatmapZoom);\n\n        for (let i = 0; i <= numTicks; i++) {\n          const virtualX = margin.left + (chartWidth * (i / numTicks));\n          const screenX = virtualX - scrollLeft;\n\n          if (screenX < margin.left || screenX > containerWidth - margin.right) continue;\n\n          const time = (totalDuration * (i / numTicks)).toFixed(1) + 's';\n          ctx.fillText(time, screenX, margin.top - 20);\n\n          ctx.beginPath();\n          ctx.moveTo(screenX, margin.top);\n          ctx.lineTo(screenX, height - margin.bottom);\n          ctx.stroke();\n        }\n      }\n\n      // Resize observer for heatmap\n      new ResizeObserver(() => {\n        if (currentView === 'heatmap' && heatmapPanel.classList.contains('visible')) {\n          renderHeatmap();\n        }\n      }).observe(heatmapPanel);\n\n      // Window resize handler for timeline\n      window.addEventListener('resize', () => {\n        if (currentView === 'timeline') {\n          renderVirtualRows(true);\n          renderRuler();\n        }\n      });\n\n      // Virtual Scroll Config\n      const ROW_HEIGHT = 29; // 28px + 1px border\n      const BUFFER_SIZE = 5;\n\n      function formatTime(seconds) {\n        if (seconds < 1) return (seconds * 1000).toFixed(1) + 'ms';\n        return seconds.toFixed(2) + 's';\n      }\n\n      function formatAbsTime(timestamp) {\n        const date = new Date(timestamp * 1000);\n        return date.toLocaleTimeString();\n      }\n\n      function getIconUrl(className) {\n        return `https://robloxapi.github.io/ref/icons/dark/${className}.png`;\n      }\n\n      function escapeHtml(text) {\n        if (!text) return '';\n        return text\n          .replace(/&/g, \"&amp;\")\n          .replace(/</g, \"&lt;\")\n          .replace(/>/g, \"&gt;\")\n          .replace(/\"/g, \"&quot;\")\n          .replace(/'/g, \"&#039;\");\n      }\n\n      function syntaxHighlight(text) {\n        if (!text) return '';\n\n        text = escapeHtml(text);\n        return text\n          .replace(/&quot;((?:[^&]|&(?!(quot;)))*)&quot;/g, '<span class=\"hl-str\">\"$1\"</span>')\n          .replace(/\\b(\\d+(\\.\\d+)?)\\b/g, '<span class=\"hl-num\">$1</span>')\n          .replace(/\\b(true|false)\\b/g, '<span class=\"hl-bool\">$1</span>')\n          .replace(/\\b(nil)\\b/g, '<span class=\"hl-nil\">$1</span>');\n      }\n\n      // Toast Logic\n      function showToast(message) {\n        const toast = document.getElementById('toast');\n        const msgSpan = document.getElementById('toastMessage');\n        msgSpan.innerText = message;\n        toast.classList.add('visible');\n        setTimeout(() => {\n          toast.classList.remove('visible');\n        }, 2000);\n      }\n\n      function copyText(text, message = \"Copied to clipboard\") {\n        navigator.clipboard.writeText(text).then(() => {\n          showToast(message);\n        });\n      }\n\n      function copyArgs(btn) {\n        if (selectedEvent) {\n          navigator.clipboard.writeText(selectedEvent.args).then(() => {\n            btn.classList.add('copied');\n            setTimeout(() => btn.classList.remove('copied'), 2000);\n          });\n        }\n      }\n\n      function toggleCallerDropdown(e) {\n        e.stopPropagation();\n        const menu = document.getElementById('callerDropdown');\n        if (menu) {\n          menu.classList.toggle('visible');\n        }\n      }\n\n      function copyCallerData(type) {\n        if (!selectedEvent) return;\n        let text = \"\";\n        let msg = \"Copied to clipboard\";\n        switch (type) {\n          case 'hash':\n            text = selectedEvent.funcHash || \"N/A\";\n            msg = \"Function Hash copied\";\n            break;\n          case 'upvalues':\n            text = selectedEvent.upvalues || \"{}\";\n            msg = \"Upvalues copied\";\n            break;\n          case 'protos':\n            text = selectedEvent.protos || \"[]\";\n            msg = \"Protos copied\";\n            break;\n          case 'path':\n            text = selectedEvent.origin || \"N/A\";\n            msg = \"Script Path copied\";\n            break;\n          case 'source':\n            text = selectedEvent.funcSource || \"N/A\";\n            msg = \"Source copied\";\n            break;\n        }\n        copyText(text, msg);\n        document.getElementById('callerDropdown').classList.remove('visible');\n      }\n\n      // Render Ruler\n      function renderRuler() {\n        rulerContainer.innerHTML = '';\n        const tickCount = Math.max(5, Math.floor(5 * zoomLevel));\n        for (let i = 0; i <= tickCount; i++) {\n          const pct = (i / tickCount) * 100;\n          const time = (totalDuration * (i / tickCount));\n          const tick = document.createElement('div');\n          tick.className = 'tick';\n          tick.style.left = pct + '%';\n          tick.innerText = formatTime(time);\n          rulerContainer.appendChild(tick);\n        }\n      }\n\n      // Scroll Sync\n      rowsContainer.addEventListener('scroll', () => {\n        timelineHeader.scrollLeft = rowsContainer.scrollLeft;\n      });\n\n      // Virtual Rendering\n      function renderVirtualRows(force = false) {\n        const scrollTop = rowsContainer.scrollTop;\n        const containerHeight = rowsContainer.clientHeight;\n\n        const totalHeight = filteredEvents.length * ROW_HEIGHT;\n        virtualSpacer.style.height = totalHeight + 'px';\n\n        const startIndex = Math.floor(scrollTop / ROW_HEIGHT);\n        const endIndex = Math.min(filteredEvents.length, Math.ceil((scrollTop + containerHeight) / ROW_HEIGHT) + BUFFER_SIZE);\n\n        if (!force && startIndex === lastStartIndex && endIndex === lastEndIndex) {\n          return;\n        }\n\n        lastStartIndex = startIndex;\n        lastEndIndex = endIndex;\n\n        const visibleEvents = filteredEvents.slice(Math.max(0, startIndex - BUFFER_SIZE), endIndex);\n        const startOffset = Math.max(0, startIndex - BUFFER_SIZE) * ROW_HEIGHT;\n\n        virtualContent.style.transform = `translateY(${startOffset}px)`;\n\n        const fragment = document.createDocumentFragment();\n        const zoomWidth = (100 * zoomLevel) + '%';\n\n        // Sync Ruler Width\n        document.getElementById('ruler').style.width = zoomWidth;\n\n        visibleEvents.forEach((evt) => {\n          const row = document.createElement('div');\n          row.className = 'trace-row';\n          if (selectedEvent === evt) row.classList.add('selected');\n\n          row.evtData = evt;\n          row.onclick = function () { selectRow(this, evt); };\n\n          const listCol = document.createElement('div');\n          listCol.className = 'row-list';\n          listCol.innerHTML = `\n                    <div class=\"type-icon\" style=\"background-image: url('${getIconUrl(evt.className)}')\"></div>\n                    <div class=\"remote-name\" title=\"${evt.name}\">${evt.name}</div>\n                `;\n\n          const timelineCol = document.createElement('div');\n          timelineCol.className = 'row-timeline';\n          timelineCol.style.width = zoomWidth;\n          timelineCol.style.flex = 'none';\n\n          const marker = document.createElement('div');\n          marker.className = `timeline-marker ${evt.typeClass}`;\n\n          let leftPct = ((evt.relTime) / totalDuration) * 100;\n          if (leftPct > 99) leftPct = 99;\n\n          let widthPct = (0.05 / totalDuration) * 100;\n          if (widthPct < 1) widthPct = 1;\n\n          marker.style.left = leftPct + '%';\n          marker.style.width = widthPct + '%';\n\n          timelineCol.appendChild(marker);\n          row.appendChild(listCol);\n          row.appendChild(timelineCol);\n          fragment.appendChild(row);\n        });\n\n        virtualContent.innerHTML = '';\n        virtualContent.appendChild(fragment);\n      }\n\n      // Ctrl+F Handler\n      document.addEventListener('keydown', function (e) {\n        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {\n          e.preventDefault();\n          const filterInput = document.getElementById('filterInput');\n          filterInput.focus();\n          filterInput.select();\n        }\n      });\n\n      // Initial Render\n      renderVirtualRows();\n      renderRuler();\n\n      function selectRow(el, evt) {\n        const prev = virtualContent.querySelector('.trace-row.selected');\n        if (prev) prev.classList.remove('selected');\n\n        el.classList.add('selected');\n        selectedEvent = evt;\n\n        detailsPanel.classList.add('visible');\n\n        const isIncoming = evt.typeClass === 'incoming';\n        const badgeClass = isIncoming ? 'incoming' : 'outgoing';\n\n        // Flags with Unified Style\n        let flagsHtml = '';\n        if (evt.isExecutor) {\n          flagsHtml += `<div class=\"badge-pill executor\">Executor</div>`;\n        }\n        if (evt.isActor) {\n          flagsHtml += `<div class=\"badge-pill actor\">Actor</div>`;\n        }\n        if (evt.isBlocked) {\n          flagsHtml += `<div class=\"badge-pill blocked\">Blocked</div>`;\n        }\n        if (!flagsHtml) flagsHtml = '<span style=\"color:var(--text-secondary); font-size:11px;\">None</span>';\n\n        const highlightedArgs = syntaxHighlight(evt.args);\n\n        // Icons\n        const copyIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-copy icon-copy\"><rect width=\"14\" height=\"14\" x=\"8\" y=\"8\" rx=\"2\" ry=\"2\"/><path d=\"M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2\"/></svg>`;\n        const checkIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-check icon-check\"><path d=\"M20 6 9 17l-5-5\"/></svg>`;\n        const parenthesesIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-parentheses\"><path d=\"M8 21s-4-3-4-9 4-9 4-9\"/><path d=\"M16 3s4 3 4 9-4 9-4 9\"/></svg>`;\n\n        // Dropdown Icons\n        const hashIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-hash\"><line x1=\"4\" x2=\"20\" y1=\"9\" y2=\"9\"/><line x1=\"4\" x2=\"20\" y1=\"15\" y2=\"15\"/><line x1=\"10\" x2=\"8\" y1=\"3\" y2=\"21\"/><line x1=\"16\" x2=\"14\" y1=\"3\" y2=\"21\"/></svg>`;\n        const upvaluesIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-a-arrow-up\"><path d=\"m14 11 4-4 4 4\"/><path d=\"M18 16V7\"/><path d=\"m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16\"/><path d=\"M3.304 13h6.392\"/></svg>`;\n        const protosIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-square-function\"><rect width=\"18\" height=\"18\" x=\"3\" y=\"3\" rx=\"2\" ry=\"2\"/><path d=\"M9 17c2 0 2.8-1 2.8-2.8V10c0-2 1-3.3 3.2-3\"/><path d=\"M9 11.2h5.7\"/></svg>`;\n        const pathIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-route\"><circle cx=\"6\" cy=\"19\" r=\"3\"/><path d=\"M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15\"/><circle cx=\"18\" cy=\"5\" r=\"3\"/></svg>`;\n        const sourceIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-code\"><path d=\"m16 18 6-6-6-6\"/><path d=\"m8 6-6 6 6 6\"/></svg>`;\n        const boxIcon = `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-box\"><path d=\"M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z\"/><path d=\"m3.3 7 8.7 5 8.7-5\"/><path d=\"M12 22v-9\"/></svg>`;\n\n        detailsContent.innerHTML = `\n                <div class=\"details-header-top\">\n                    <div class=\"details-title-group\">\n                        <div class=\"details-icon-large\" style=\"background-image: url('${getIconUrl(evt.className)}')\"></div>\n                        <div class=\"details-name-large\">${escapeHtml(evt.name)}</div>\n                    </div>\n                    <div class=\"details-actions\">\n                        <div class=\"badge-pill ${badgeClass}\">${evt.typeClass.toUpperCase()}</div>\n                        <div class=\"close-btn\" onclick=\"closeDetails()\">\195\151</div>\n                    </div>\n                </div>\n\n                <div class=\"details-path-row\" onclick=\"copyText('${escapeHtml(evt.path).replace(/'/g, \"\\\\'\").replace(/\"/g, \"&quot;\")}', 'Remote Path copied')\" title=\"Click to copy path\"><span class=\"clickable-path\">${escapeHtml(evt.path)}</span></div>\n\n                <div class=\"info-grid\">\n                    <div class=\"info-item\">\n                        <h4>Method</h4>\n                        <div>${escapeHtml(evt.method)}</div>\n                    </div>\n                    <div class=\"info-item\">\n                        <h4>Timestamp</h4>\n                        <div>${formatAbsTime(evt.timestamp)} <span style=\"color:var(--text-secondary)\">(+${formatTime(evt.relTime)})</span></div>\n                    </div>\n                    <div class=\"info-item\">\n                        <h4>ClassName</h4>\n                        <div>${escapeHtml(evt.className)}</div>\n                    </div>\n                    <div class=\"info-item\">\n                        <h4>Remote Path</h4>\n                        <div class=\"remote-path-copy clickable-path\" onclick=\"copyText('${escapeHtml(evt.path).replace(/'/g, \"\\\\'\").replace(/\"/g, \"&quot;\")}', 'Remote Path copied')\" title=\"Click to copy path\">${escapeHtml(evt.path)}</div>\n                    </div>\n                </div>\n\n                <div class=\"content-box\">\n                    <div class=\"box-title\">Caller Data</div>\n                    <button class=\"copy-icon-btn\" onclick=\"toggleCallerDropdown(event)\" title=\"Copy Caller Info\">${copyIcon}</button>\n\n                    <div id=\"callerDropdown\" class=\"dropdown-menu\">\n                        <div class=\"dropdown-item\" onclick=\"copyCallerData('hash')\">${hashIcon} Function Hash</div>\n                        <div class=\"dropdown-item\" onclick=\"copyCallerData('upvalues')\">${upvaluesIcon} Upvalues</div>\n                        <div class=\"dropdown-item\" onclick=\"copyCallerData('protos')\">${protosIcon} Protos</div>\n                        <div class=\"dropdown-item\" onclick=\"copyCallerData('constants')\">${boxIcon} Constants</div>\n                        <div class=\"dropdown-item\" onclick=\"copyCallerData('path')\">${pathIcon} Script Path</div>\n                        <div class=\"dropdown-item\" onclick=\"copyCallerData('source')\">${sourceIcon} Func Source</div>\n                    </div>\n\n                    <div class=\"caller-header\">\n                        <div class=\"caller-icon\">${parenthesesIcon}</div>\n                        <div class=\"caller-info\">\n                            <div class=\"caller-name\">${escapeHtml(evt.funcName)} <span class=\"caller-source\">:${evt.funcLine}</span></div>\n                            <div class=\"caller-source\">${escapeHtml(evt.funcSource)}</div>\n                        </div>\n                    </div>\n\n                    <div class=\"info-grid-2\" style=\"margin-bottom:0; gap:10px;\">\n                         <div class=\"info-item-2\" style=\"margin-right: 100px;\">\n                            <h4>Flags</h4>\n                            <div class=\"flags-row\">${flagsHtml}</div>\n                         </div>\n                         <div class=\"info-item-2\">\n                            <h4>Origin</h4>\n                            <div class=\"origin-row clickable-path\" onclick=\"copyText('${escapeHtml(evt.origin).replace(/'/g, \"\\\\'\").replace(/\"/g, \"&quot;\")}', 'Origin copied')\" title=\"Click to copy origin\">${escapeHtml(evt.origin)}</div>\n                         </div>\n                    </div>\n                </div>\n\n                <div class=\"content-box\">\n                    <div class=\"box-title\">Arguments</div>\n                    <button class=\"copy-icon-btn\" onclick=\"copyArgs(this)\" title=\"Copy Arguments\">\n                        ${copyIcon}\n                        ${checkIcon}\n                    </button>\n                    <div class=\"args-content\">${highlightedArgs}</div>\n                </div>\n            `;\n      }\n\n      function closeDetails() {\n        detailsPanel.classList.remove('visible');\n        const prev = virtualContent.querySelector('.trace-row.selected');\n        if (prev) prev.classList.remove('selected');\n        selectedEvent = null;\n      }\n\n      function handleFilterInput() {\n        if (filterTimeout) clearTimeout(filterTimeout);\n        filterTimeout = setTimeout(applyFilters, 300);\n      }\n\n      function toggleSearchOptions() {\n        const widget = document.getElementById('searchChevron').closest('.search-widget');\n        const options = document.getElementById('searchOptions');\n        const chevron = document.getElementById('searchChevron');\n\n        options.classList.toggle('visible');\n        chevron.classList.toggle('expanded');\n        widget.classList.toggle('expanded');\n      }\n\n      function handleTimeInput() {\n        const minVal = parseFloat(document.getElementById('minTimeInput').value);\n        const maxVal = parseFloat(document.getElementById('maxTimeInput').value);\n        const unit = parseFloat(document.getElementById('timeUnitSelect').value);\n\n        filterMinTime = isNaN(minVal) ? 0 : minVal * unit;\n        filterMaxTime = isNaN(maxVal) ? totalDuration : maxVal * unit;\n\n        if (filterTimeout) clearTimeout(filterTimeout);\n        filterTimeout = setTimeout(applyFilters, 300);\n      }\n\n      function applyFilters() {\n        const query = document.getElementById('filterInput').value.toLowerCase();\n        const checkIncoming = document.getElementById('filterIncoming').checked;\n        const checkOutgoing = document.getElementById('filterOutgoing').checked;\n        const checkActor = document.getElementById('filterActor').checked;\n        const checkNonActor = document.getElementById('filterNonActor').checked;\n        const checkArgs = document.getElementById('filterArgs').checked;\n        const checkProto = document.getElementById('filterProto').checked;\n        const checkConst = document.getElementById('filterConst').checked;\n        const checkHash = document.getElementById('filterHash').checked;\n        const checkSource = document.getElementById('filterSource').checked;\n\n        filteredEvents = allEvents.filter(evt => {\n          // Filter by Type (Incoming/Outgoing)\n          if (checkIncoming || checkOutgoing) {\n            const isIncoming = evt.typeClass === 'incoming';\n            const isOutgoing = evt.typeClass === 'outgoing';\n            if (!((checkIncoming && isIncoming) || (checkOutgoing && isOutgoing))) {\n              return false;\n            }\n          }\n\n          // Filter by Actor Status\n          if (checkActor || checkNonActor) {\n            const isActor = evt.isActor;\n            const isNonActor = !evt.isActor;\n            if (!((checkActor && isActor) || (checkNonActor && isNonActor))) {\n              return false;\n            }\n          }\n\n          let matchesText = !query;\n\n          if (!matchesText) {\n            // Default search: Name and Type\n            if (evt.name.toLowerCase().includes(query) || evt.type.toLowerCase().includes(query)) {\n              matchesText = true;\n            }\n            // Advanced search options\n            else {\n              if (checkArgs && evt.args && evt.args.toLowerCase().includes(query)) matchesText = true;\n              else if (checkProto && evt.protos && evt.protos.toLowerCase().includes(query)) matchesText = true;\n              else if (checkConst && evt.constants && evt.constants.toLowerCase().includes(query)) matchesText = true;\n              else if (checkHash && evt.funcHash && evt.funcHash.toLowerCase().includes(query)) matchesText = true;\n              else if (checkSource && evt.funcSource && evt.funcSource.toLowerCase().includes(query)) matchesText = true;\n            }\n          }\n\n          const matchesTime = evt.relTime >= filterMinTime && evt.relTime <= filterMaxTime;\n\n          return matchesText && matchesTime;\n        });\n\n        // Update Stats\n        statsLabel.innerText = `${filteredEvents.length} Events \226\128\162 ${totalDuration.toFixed(2)}s`;\n\n        // Reset Scroll\n        rowsContainer.scrollTop = 0;\n        lastStartIndex = -1;\n        lastEndIndex = -1;\n\n        if (currentView === 'timeline') {\n          renderVirtualRows(true);\n        } else {\n          renderHeatmap();\n        }\n      } function updateZoom() {\n        const width = (100 * zoomLevel) + '%';\n        rulerContainer.style.width = width;\n        renderRuler();\n        lastStartIndex = -1;\n        renderVirtualRows(true);\n      }\n\n      rowsContainer.addEventListener('wheel', (e) => {\n        if (e.ctrlKey) {\n          e.preventDefault();\n          if (e.deltaY < 0) {\n            zoomLevel = Math.min(zoomLevel * 1.1, 20);\n          } else {\n            zoomLevel = Math.max(zoomLevel / 1.1, 1);\n          }\n          updateZoom();\n        }\n      });\n\n      rowsContainer.addEventListener('scroll', () => {\n        timelineHeader.scrollLeft = rowsContainer.scrollLeft;\n\n        if (!isScrolling) {\n          window.requestAnimationFrame(() => {\n            renderVirtualRows();\n            isScrolling = false;\n          });\n          isScrolling = true;\n        }\n      });\n\n      const sessionInfo = document.querySelector('.session-info');\n      const tooltip = document.querySelector('.session-tooltip');\n\n      sessionInfo.addEventListener('click', (e) => {\n        e.stopPropagation();\n        tooltip.classList.toggle('visible');\n      });\n\n      tooltip.addEventListener('click', (e) => {\n        e.stopPropagation();\n      });\n\n      document.addEventListener('click', () => {\n        tooltip.classList.remove('visible');\n        const dropdown = document.getElementById('callerDropdown');\n        if (dropdown) dropdown.classList.remove('visible');\n      });\n    </script>\n  </body>\n</html>\n"
                                        }
                                    }
                                }
                            },
                            {
                                29,
                                2,
                                {
                                    "Classifier"
                                }
                            },
                            {
                                33,
                                1,
                                {
                                    "Serializer"
                                },
                                {
                                    {
                                        35,
                                        2,
                                        {
                                            "LuaEncode"
                                        }
                                    },
                                    {
                                        36,
                                        2,
                                        {
                                            "Session"
                                        }
                                    },
                                    {
                                        34,
                                        2,
                                        {
                                            "Instance"
                                        }
                                    }
                                }
                            },
                            {
                                32,
                                2,
                                {
                                    "Renderer"
                                }
                            },
                            {
                                31,
                                2,
                                {
                                    "Generator"
                                }
                            }
                        }
                    },
                    {
                        111,
                        2,
                        {
                            "Settings"
                        },
                        {
                            {
                                113,
                                2,
                                {
                                    "Setting"
                                }
                            },
                            {
                                112,
                                2,
                                {
                                    "Registry"
                                }
                            }
                        }
                    },
                    {
                        23,
                        1,
                        {
                            "CallFilter"
                        },
                        {
                            {
                                27,
                                2,
                                {
                                    "Schema"
                                }
                            },
                            {
                                25,
                                2,
                                {
                                    "Operators"
                                }
                            },
                            {
                                26,
                                2,
                                {
                                    "RemoteFields"
                                }
                            },
                            {
                                24,
                                2,
                                {
                                    "Manager"
                                }
                            }
                        }
                    },
                    {
                        109,
                        2,
                        {
                            "SafePack"
                        }
                    },
                    {
                        94,
                        2,
                        {
                            "LogStore"
                        }
                    },
                    {
                        93,
                        2,
                        {
                            "Log"
                        }
                    },
                    {
                        47,
                        1,
                        {
                            "Hook"
                        },
                        {
                            {
                                49,
                                1,
                                {
                                    "RakNet"
                                },
                                {
                                    {
                                        51,
                                        2,
                                        {
                                            "Constants"
                                        }
                                    },
                                    {
                                        50,
                                        2,
                                        {
                                            "Codec"
                                        }
                                    },
                                    {
                                        52,
                                        2,
                                        {
                                            "Lookup"
                                        }
                                    },
                                    {
                                        53,
                                        1,
                                        {
                                            "Variant"
                                        },
                                        {
                                            {
                                                54,
                                                1,
                                                {
                                                    "Decoders"
                                                },
                                                {
                                                    {
                                                        82,
                                                        2,
                                                        {
                                                            "securityCapabilities"
                                                        }
                                                    },
                                                    {
                                                        70,
                                                        2,
                                                        {
                                                            "nil"
                                                        }
                                                    },
                                                    {
                                                        66,
                                                        2,
                                                        {
                                                            "enum"
                                                        }
                                                    },
                                                    {
                                                        65,
                                                        2,
                                                        {
                                                            "dictionary"
                                                        }
                                                    },
                                                    {
                                                        73,
                                                        2,
                                                        {
                                                            "numberSequence"
                                                        }
                                                    },
                                                    {
                                                        56,
                                                        2,
                                                        {
                                                            "axes"
                                                        }
                                                    },
                                                    {
                                                        71,
                                                        2,
                                                        {
                                                            "number"
                                                        }
                                                    },
                                                    {
                                                        77,
                                                        2,
                                                        {
                                                            "physicalProperties"
                                                        }
                                                    },
                                                    {
                                                        83,
                                                        2,
                                                        {
                                                            "sharedString"
                                                        }
                                                    },
                                                    {
                                                        84,
                                                        2,
                                                        {
                                                            "string"
                                                        }
                                                    },
                                                    {
                                                        80,
                                                        2,
                                                        {
                                                            "region3"
                                                        }
                                                    },
                                                    {
                                                        69,
                                                        2,
                                                        {
                                                            "instance"
                                                        }
                                                    },
                                                    {
                                                        85,
                                                        2,
                                                        {
                                                            "tuple"
                                                        }
                                                    },
                                                    {
                                                        81,
                                                        2,
                                                        {
                                                            "replicationPV"
                                                        }
                                                    },
                                                    {
                                                        68,
                                                        2,
                                                        {
                                                            "font"
                                                        }
                                                    },
                                                    {
                                                        59,
                                                        2,
                                                        {
                                                            "buffer"
                                                        }
                                                    },
                                                    {
                                                        63,
                                                        2,
                                                        {
                                                            "content"
                                                        }
                                                    },
                                                    {
                                                        57,
                                                        2,
                                                        {
                                                            "bool"
                                                        }
                                                    },
                                                    {
                                                        86,
                                                        2,
                                                        {
                                                            "udim"
                                                        }
                                                    },
                                                    {
                                                        78,
                                                        2,
                                                        {
                                                            "ray"
                                                        }
                                                    },
                                                    {
                                                        89,
                                                        2,
                                                        {
                                                            "variant"
                                                        }
                                                    },
                                                    {
                                                        88,
                                                        2,
                                                        {
                                                            "uniqueId"
                                                        }
                                                    },
                                                    {
                                                        87,
                                                        2,
                                                        {
                                                            "udim2"
                                                        }
                                                    },
                                                    {
                                                        90,
                                                        2,
                                                        {
                                                            "vector"
                                                        }
                                                    },
                                                    {
                                                        76,
                                                        2,
                                                        {
                                                            "pathWaypoint"
                                                        }
                                                    },
                                                    {
                                                        62,
                                                        2,
                                                        {
                                                            "colorSequence"
                                                        }
                                                    },
                                                    {
                                                        67,
                                                        2,
                                                        {
                                                            "faces"
                                                        }
                                                    },
                                                    {
                                                        61,
                                                        2,
                                                        {
                                                            "color3"
                                                        }
                                                    },
                                                    {
                                                        55,
                                                        2,
                                                        {
                                                            "animTrack"
                                                        }
                                                    },
                                                    {
                                                        75,
                                                        2,
                                                        {
                                                            "optionalCFrame"
                                                        }
                                                    },
                                                    {
                                                        74,
                                                        2,
                                                        {
                                                            "opaque"
                                                        }
                                                    },
                                                    {
                                                        64,
                                                        2,
                                                        {
                                                            "dateTime"
                                                        }
                                                    },
                                                    {
                                                        79,
                                                        2,
                                                        {
                                                            "rect"
                                                        }
                                                    },
                                                    {
                                                        58,
                                                        2,
                                                        {
                                                            "brickColor"
                                                        }
                                                    },
                                                    {
                                                        60,
                                                        2,
                                                        {
                                                            "cframe"
                                                        }
                                                    },
                                                    {
                                                        72,
                                                        2,
                                                        {
                                                            "numberRange"
                                                        }
                                                    }
                                                }
                                            },
                                            {
                                                91,
                                                2,
                                                {
                                                    "Parser"
                                                }
                                            }
                                        }
                                    },
                                    {
                                        92,
                                        2,
                                        {
                                            "Wrapper"
                                        }
                                    }
                                }
                            },
                            {
                                48,
                                2,
                                {
                                    "Luau"
                                }
                            }
                        }
                    },
                    {
                        121,
                        2,
                        {
                            "Validation"
                        },
                        {
                            {
                                122,
                                2,
                                {
                                    "Schema"
                                }
                            }
                        }
                    },
                    {
                        46,
                        2,
                        {
                            "FileLog"
                        }
                    }
                }
            },
            {
                2,
                2,
                {
                    "ExecutorSupport"
                }
            }
        }
    }
}

-- Line offsets for debugging (only included when minifyTables is false)
local LineOffsets = {
    8,
    534,
    1170,
    [5] = 1198,
    [9] = 1585,
    [10] = 2239,
    [11] = 2571,
    [12] = 2601,
    [14] = 2624,
    [15] = 2741,
    [16] = 2853,
    [17] = 2952,
    [20] = 3223,
    [22] = 3292,
    [24] = 3371,
    [25] = 3567,
    [26] = 4009,
    [27] = 4131,
    [29] = 4229,
    [30] = 4357,
    [31] = 4460,
    [32] = 4786,
    [34] = 5121,
    [35] = 5416,
    [36] = 6442,
    [38] = 6671,
    [39] = 6692,
    [40] = 6718,
    [41] = 6861,
    [43] = 6912,
    [44] = 6962,
    [45] = 6987,
    [46] = 7250,
    [48] = 7410,
    [50] = 7496,
    [51] = 7716,
    [52] = 8369,
    [55] = 8455,
    [56] = 8527,
    [57] = 8556,
    [58] = 8572,
    [59] = 8589,
    [60] = 8615,
    [61] = 8638,
    [62] = 8677,
    [63] = 8737,
    [64] = 8840,
    [65] = 8859,
    [66] = 8907,
    [67] = 8965,
    [68] = 8997,
    [69] = 9084,
    [70] = 9118,
    [71] = 9137,
    [72] = 9199,
    [73] = 9217,
    [74] = 9275,
    [75] = 9312,
    [76] = 9335,
    [77] = 9370,
    [78] = 9420,
    [79] = 9442,
    [80] = 9462,
    [81] = 9507,
    [82] = 9566,
    [83] = 9663,
    [84] = 9679,
    [85] = 9702,
    [86] = 9742,
    [87] = 9760,
    [88] = 9780,
    [89] = 9796,
    [90] = 9815,
    [91] = 9874,
    [92] = 10055,
    [93] = 10123,
    [94] = 10650,
    [95] = 10687,
    [98] = 10860,
    [99] = 10905,
    [100] = 11007,
    [101] = 11418,
    [102] = 11442,
    [103] = 11531,
    [104] = 11575,
    [105] = 11617,
    [106] = 11642,
    [107] = 11689,
    [108] = 11719,
    [109] = 11880,
    [110] = 11916,
    [111] = 12038,
    [112] = 12047,
    [113] = 12286,
    [114] = 12354,
    [117] = 12445,
    [118] = 12624,
    [119] = 13041,
    [120] = 13138,
    [121] = 13304,
    [122] = 13333,
    [123] = 13655,
    [125] = 13862,
    [126] = 14203,
    [127] = 14822,
    [128] = 14830,
    [129] = 14952,
    [130] = 14982,
    [131] = 15008,
    [132] = 15034,
    [133] = 15067,
    [134] = 15095,
    [135] = 15141,
    [136] = 15184,
    [139] = 15344,
    [140] = 15625,
    [141] = 15754,
    [142] = 16025,
    [143] = 16264,
    [144] = 16294,
    [145] = 16463,
    [146] = 16615,
    [147] = 16674,
    [148] = 16694,
    [149] = 17913,
    [150] = 18281,
    [151] = 18510,
    [153] = 18528,
    [155] = 18715,
    [156] = 18877,
    [157] = 18958,
    [158] = 19254,
    [159] = 19296,
    [160] = 19775,
    [161] = 20092,
    [162] = 20556,
    [163] = 21009,
    [165] = 21269,
    [166] = 21386,
    [168] = 21418,
    [169] = 21513,
    [170] = 21542,
    [171] = 21858,
    [173] = 21939,
    [174] = 22194,
    [175] = 22248,
    [177] = 22299,
    [179] = 22492,
    [180] = 23378,
    [181] = 23452
}

-- Luau aliases from .luaurc
local Aliases = {
    src = "/cobalt"
}

-- Misc AOT variable imports
local WaxVersion = "0.4.1"
local EnvName = "Cobalt"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION =
      string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION

local table_insert = table.insert
local table_remove = table.remove
local table_freeze = table.freeze or function(t) return t end -- lol

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- wax.shared __index/__newindex
local SharedEnvironment = {}

-- Global helper injected into every script closure
-- Array entries become [value] = true, dictionary entries are kept as-is, non-tables pass through
local function CreateLookupTable(Values)
    if type(Values) ~= "table" then
        return Values
    end

    local LookupTable = {}
    for Key, Value in next, Values do
        if type(Key) == "number" then
            LookupTable[Value] = true
        else
            LookupTable[Key] = Value
        end
    end

    return LookupTable
end

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in next, Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in next, Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in next, Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in next, InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in next, Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in next, EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in next, Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in next, Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in next, Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in next, ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in next, ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(originalErrorMessage)
        originalErrorMessage = tostring(originalErrorMessage)

        local VirtualFullName = scriptRef:GetFullName()

        -- Check for vanilla/Roblox format
        local OriginalErrorLine, BaseErrorMessage = string_match(originalErrorMessage, "[^:]+:(%d+): (.+)")

        if not OriginalErrorLine or not LineOffsets then
            return VirtualFullName .. ":*: " .. (BaseErrorMessage or originalErrorMessage)
        end

        OriginalErrorLine = tonumber(OriginalErrorLine)

        local RefId = ScriptClosureRefIds[scriptRef]
        local LineOffset = LineOffsets[RefId]

        local RealErrorLine = OriginalErrorLine - LineOffset + 1
        if RealErrorLine < 0 then
            RealErrorLine = "?"
        end

        return VirtualFullName .. ":" .. RealErrorLine .. ": " .. BaseErrorMessage
    end

    -- If it's a BaseScript, we'll just run it directly!
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = xpcall(Closure, function(msg)
            return msg
        end)
        if not RunSuccess then
            error(FormatError(ErrorMessage), 0)
        end
    else
        local PCallReturn = {xpcall(Closure, function(msg)
            return msg
        end)}

        local RunSuccess = table_remove(PCallReturn, 1)
        if not RunSuccess then
            local ErrorMessage = table_remove(PCallReturn, 1)
            error(FormatError(ErrorMessage), 0)
        end

        StoredModuleValues[scriptRef] = PCallReturn
        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {xpcall(f, function(msg)
            return debug.traceback(msg, 2)
        end, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return next, SharedEnvironment
        end,
    }))

    local Global_wax = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" then
            -- The control flow on this SUCKS
            if string_sub(module, 1, 1) == "@" then
                local AliasName, RemainingPath = string_match(module, "^@([^/]+)(.*)")
                local MappedPath = AliasName and Aliases[AliasName]

                if MappedPath then
                    if string_sub(MappedPath, -1) == "/" and string_sub(RemainingPath, 1, 1) == "/" then
                        module = MappedPath .. string_sub(RemainingPath, 2)
                    elseif string_sub(MappedPath, -1) ~= "/" and string_sub(RemainingPath, 1, 1) ~= "/" and #RemainingPath > 0 then
                        module = MappedPath .. "/" .. RemainingPath
                    else
                        module = MappedPath .. RemainingPath
                    end

                    if string_sub(module, 1, 1) ~= "/" then
                        module = "/" .. module
                    end
                else
                    -- Fallback to real require for @lune/ etc
                    return RealCall(require, module, ...)
                end
            end

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch
                if PathMatch == ".." then
                    RealIndex = "Parent"
                end

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                    if not ResultRef then
                        local CurrentRefParent = CurrentRefPointer.Parent
                        if CurrentRefParent then
                            ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                        end
                    end

                    if ResultRef then
                        CurrentRefPointer = ResultRef
                    elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                        error("Virtual script path \"" .. module .. "\" not found", 2)
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require, CreateLookupTable
end

for _, ScriptRef in next, ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end
