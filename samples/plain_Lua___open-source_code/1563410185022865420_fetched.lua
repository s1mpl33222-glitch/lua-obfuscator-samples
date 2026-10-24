--[[
@author depso (depthso)
@description Scriptblox analytics

If you jits are wondering why I wrote this the way I did, 
this is designed to compile with lua rather than luau.
This is a compatibility measure we have agreed to use, hence the odd structure.

Yes I could have used a shared table to have this library run only once but
we would prefer to not increase the GC pressure and blatantly expose anything
for future updates; possible obfuscation.

@Codes:
    resume
        - teleported
    error
        - teleportfail
        - heartbeattimeout
    disconnect
        - kick
        - leave
        - crash
        - teleport
    heartbeat
        - null

@loadstring:
    loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))(
        "proj_e1d815a5fad9", 
        "1.0.0",
        false
    )

]]

--// Config
local EndPoint = "https://scriptblox.com/ingest/v1"
local CacheFolder = "Scriptblox"
local HeartbeatInterval = 300
local Attempts = 3
local BodyBytes = 8000
local RequestTimeout = 10
local ResumeLifetime = 120

--// Variables
local _ProjectId, _ProjectVersion, _DEBUG = ...
local HttpService, UserInputService, Players

--------// Execution debounce
do
    --// Fetch global table
    local RecordingProjectIds = getgenv()._SblxRecordingProjectIds
    if not RecordingProjectIds then
        RecordingProjectIds = {}
        getgenv()._SblxRecordingProjectIds = RecordingProjectIds
    end

    --// Debounce check
    if RecordingProjectIds[_ProjectId] then
        return
    end
    RecordingProjectIds[_ProjectId] = true
end

--------// Core functions
local DebugWarn, GetService, CacheFetch, CacheWrite, 
    HttpGet, HttpGetWithCache, ImportLib, FormatGUID, InitCache, 
    SendPacket, GetDevicePlatform, ConnectAsyncInterval

do
    function DebugWarn(...)
        if _DEBUG then
            warn("[Scriptblox-Analytics]:", ...)
        end
    end

    function GetService(ServiceName)
        return cloneref(game:GetService(ServiceName))
    end

    function CacheFetch(FileName)
        local Path = CacheFolder .. "/" .. FileName
        if isfile(Path) then
            return readfile(Path)
        end
    end
    function CacheWrite(FileName, Content)
        writefile(CacheFolder .. "/" .. FileName, Content)
    end

    function HttpGet(Url)
        while true do
            local Success, Response = pcall(game.HttpGet, game, Url)

            --// Success
            if Success then
                return Response
            end

            DebugWarn("Request failed for", Url, "Reason:", Response)
            task.wait(1)
        end
    end

    function HttpGetWithCache(FileName, Url)
        --// Use cached content
        local Cached = CacheFetch(FileName)
        if Cached then
            return Cached
        end

        --// Fetch remote content
        local Content = HttpGet(Url)
        CacheWrite(FileName, Content)

        return Content
    end

    function ImportLib(Name, Url)
        --// Compile
        local Function, Reason = loadstring(
            HttpGetWithCache(Name, Url), 
            Name
        )

        --// Compile failure
        if not Function then
            DebugWarn("Failed to compile bytecode of:", Name, "Reason:", Reason)
            return
        end

        return Function()
    end

    function FormatGUID(GUIDString)
        return GUIDString:gsub("%-", ""):lower()
    end

    function InitCache()
        if not isfolder(CacheFolder) then
            makefolder(CacheFolder)
        end
    end

    function AttemptSendPacket(Body)
        --// Encode JSON
        local EncodeSuccess, EncodedBody = pcall(HttpService.JSONEncode, HttpService, Body)
        if not EncodeSuccess then
            DebugWarn("POST encode failed, Reason:", EncodedBody)
            return false
        end

        --// Validate body size
        if #EncodedBody > BodyBytes then 
            DebugWarn("POST encode failed, invalid payload size:", #EncodedBody)
            return
        end

        --// Send POST request to backend API
        local Success, Response = pcall(request, {
            Url = EndPoint,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Content-Length"] = tostring(#EncodedBody),
                ["X-Reporter-Id"] = _ProjectId
            },
            Body = EncodedBody,
            Timeout = RequestTimeout,
            Redirects = false
        })

        --// Payload failed
        if not Success then
            DebugWarn("POST fail, Reason:", Response)
            return false
        end

        --// Server rejection
        if Response.StatusCode ~= 200 then
            DebugWarn("POST fail, Server rejected with StatusCode:", Response.StatusCode)
            return false
        end

        return true
    end

    function SendPacket(Body)
        for i = 1, Attempts do
            --// Send packet
            local Success = AttemptSendPacket(Body)
            if Success then
                break
            end

            --// Retry timeout
            task.wait(RequestTimeout)
        end
    end

    function GetDevicePlatform()
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            return "Mobile"
        else
            return "Computer"
        end
    end

    function ConnectAsyncInterval(Interval, Callback)
        task.spawn(function()
            while task.wait(Interval) do
                pcall(Callback)
            end
        end)
    end

    --// Init core
    InitCache()
end

--// Libraries
local Sha256 = ImportLib("SHA256", "https://github.com/Dekkonot/luau-hashing/raw/refs/heads/main/modules/sha256/init.luau")
if not Sha256 then 
    DebugWarn("Failed to import libraries")
    return 
end

--// Fetch services
HttpService = GetService("HttpService")
UserInputService = GetService("UserInputService")
Players = GetService("Players")

--// Variables
local LocalPlayer = cloneref(Players.LocalPlayer) 
local SessionID = FormatGUID(HttpService:GenerateGUID(false))
local ExecutorName, ExecutorVersion = identifyexecutor()
local UserIdHash = Sha256(tostring(LocalPlayer.UserId))
local Platform = GetDevicePlatform()
local StartTick = os.clock()
local StopTick = nil
local UniverseID = game.GameId
local PlaceID = game.PlaceId
local LocaleId = LocalPlayer.LocaleId
local HeartbeatClosed = false
local LastState = CacheFetch("LastState")
local LastTeleport = CacheFetch("LastTeleport")

--------// Communication functions
local SendHeartbeat, ConnectEvent, SendAndClose, 
    AttemptSessionResume, ResumeHeartbeat
    
do
    function SendHeartbeat(Category, DisconnectReason)
        local State = DisconnectReason or Category
        DebugWarn("Heartbeat:", Category, DisconnectReason, "State:", State)
        CacheWrite("LastState", State)

        SendPacket({
            type = Category,
            reporter_id = _ProjectId,
            version = _ProjectVersion,
            session_id = SessionID,
            executor = ExecutorName,
            executor_version = ExecutorVersion,
            user_id = UserIdHash,
            platform = Platform,
            locale = LocaleId,
            place_id = PlaceID,
            universe_id = UniverseID,
            sent_at = math.floor(os.clock()),
            uptime = math.round(os.clock() - StartTick)
        })
    end

    function ResumeHeartbeat(Category, DisconnectReason)
        HeartbeatClosed = false
        SendHeartbeat(Category, DisconnectReason)
    end

    function ConnectEvent(Name, EventSignal)
        EventSignal:Connect(function()
            SendHeartbeat(Name)
        end)
    end

    function SendAndClose(DisconnectReason)
        HeartbeatClosed = true
        StopTick = os.clock()

        local TeleportData = table.concat({
            tostring(game.GameId),
            SessionID,
            tostring(StartTick)
        }, " ")

        CacheWrite("LastTeleport", TeleportData)
        SendHeartbeat("disconnect", DisconnectReason)
    end

    function AttemptSessionResume(Category, DisconnectReason)
        local TeleportData = LastTeleport:split(" ")
        local LastUniverse, LastSessionID, RealStartTick = unpack(TeleportData)

        --// Restore
        if tonumber(LastUniverse) == game.GameId then
            SessionID = LastSessionID
            StartTick = tonumber(RealStartTick)
            SendHeartbeat(Category, DisconnectReason)
        end
    end
end

--// Validation
assert(
    typeof(UniverseID) == "number" and
    typeof(PlaceID) == "number" and
    typeof(LocaleId) == "string",
    
    "Saar pls no tamper"
)

--// Crash detection (Last state was not shutdown safely)
if LastState == "heartbeat" then
    SendHeartbeat("disconnect", "crash") -- TODO: Inherit previous SessionID?
    task.wait(1)

--// Resume heartbeat after teleporting
elseif LastState == "teleport" then
    AttemptSessionResume("resume", "teleported")
end

--// Connections
do
    ConnectAsyncInterval(HeartbeatInterval, function()
        if not HeartbeatClosed then
            SendHeartbeat("heartbeat")
            return
        
        --// Resume heartbeat after long period of a timeout
        elseif os.clock() - StopTick > ResumeLifetime then
            ResumeHeartbeat("error", "heartbeattimeout")
            return
        end
    end)

    --// Player events
    LocalPlayer.OnTeleport:Connect(function(State)
        if State == Enum.TeleportState.InProgress then
            SendAndClose("teleport")
        elseif State == Enum.TeleportState.Failed then
            ResumeHeartbeat("error", "teleportfail")
        end
    end)
    Players.PlayerRemoving:Connect(function(LeavingPlayer, KickReason)
        if LeavingPlayer == LocalPlayer then 
            local IsKick = KickReason ~= Enum.PlayerExitReason.Unknown
            local ReasonString = IsKick and "kick" or "leave"

            SendAndClose("disconnect", ReasonString)
        end
    end)
end

--// Init heartbeat
SendHeartbeat("execution")