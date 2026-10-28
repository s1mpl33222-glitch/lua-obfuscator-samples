print("[luffy flash block tp] script loading...")
task.wait(0.05)
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Stats=game:GetService("Stats")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local StarterGui=game:GetService("StarterGui")
local GuiService=game:GetService("GuiService")
local CoreGui=game:GetService("CoreGui")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = Instance.new("VirtualInputManager")
end)
if VirtualInputManager then
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

if _G.Formega_Script_Purge then pcall(function() _G.Formega_Script_Purge() end) task.wait(0.2) end
local ActiveConnections={}
local thisScriptStopped=false

-- ===== QUICK PICKUP (HoldDuration bajo en tu plot) =====
local QuickPickup = (function()
    local enabled = false
    local orig = {}
    local hooked = false
    local function isMyPlotQP(plot)
        if not plot or not plot:IsA("Model") then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then return true end
        return false
    end
    local function inMyPlotQP(inst)
        if not inst or not inst.Parent then return false end
        local node = inst.Parent
        for _ = 1, 12 do
            if not node then return false end
            if node:IsA("Model") and node.Parent and node.Parent.Name == "Plots" then
                return isMyPlotQP(node)
            end
            node = node.Parent
        end
        return false
    end
    local function installHook()
        if hooked then return end
        local ok, mt = pcall(getrawmetatable, game)
        if not ok or not mt then return end
        pcall(setreadonly, mt, false)
        local oldNewIndex = mt.__newindex
        local nc = newcclosure or function(f) return f end
        mt.__newindex = nc(function(self, key, value)
            if not thisScriptStopped and key == "HoldDuration" and enabled
                and typeof(self) == "Instance" and self:IsA("ProximityPrompt") and inMyPlotQP(self) then
                value = 0.05
            end
            return oldNewIndex(self, key, value)
        end)
        pcall(setreadonly, mt, true)
        hooked = true
    end
    local M = {}
    function M.set(v)
        enabled = v and true or false
        _G.QuickPickup = enabled
        if enabled then
            installHook()
            task.spawn(function()
                local root = Workspace:FindFirstChild("Plots") or Workspace
                local stack = { root }
                local visited = 0
                while #stack > 0 and enabled do
                    local cur = table.remove(stack)
                    for _, d in ipairs(cur:GetChildren()) do
                        if d:IsA("ProximityPrompt") and inMyPlotQP(d) then
                            if orig[d] == nil then orig[d] = d.HoldDuration end
                            pcall(function() d.HoldDuration = 0.05 end)
                        end
                        table.insert(stack, d)
                    end
                    visited = visited + 1
                    if visited % 50 == 0 then task.wait() end
                end
            end)
        else
            for p, o in pairs(orig) do
                if p and p.Parent then pcall(function() p.HoldDuration = o end) end
            end
            orig = {}
        end
    end
    return M
end)()
_G._175_QuickPickup = QuickPickup

local AntiRagdollConns={}
local lastRagdollClean=0
local antiRagdollEnabled=false
_G.RagdollBypass=false
_G.AutoResetOnBalloon=true
_G.AutoGiant=false
_G.AutoBlock=false
_G.APESPEnabled=false
_G.BackpackESP=false
_G.ShowGiantPotion=true
_G.ShowFlashTeleport=true
_G.ShowFlyingCarpet=true
_G.BrainrotHighlight=false
_G.FPSBoostEnabled=false
_G.IPESPEnabled=false
_G.AutoSelectBrainrot=false
_G.AutoSelectBrainrotName=""
_G.AutoSelectBrainrotSlot=0
_G.QuickAP=false
_G.DropBrainrotEnabled=false
_G.ESPBaseEnabled=false
_G.ESPBestEnabled=false
_G.LaggerOnFlash=false
_G.LaggerPower=50
_G.LaggerBypass=false
_G.LaggerVersion="v1"
_G.antiGummyEnabled=false
_G.AutoTurretEnabled=false
_G.AutoReturnBase=false
_G.FlashSpeed=180
_G.TransportIndex=1
_G.AntiSteal=false
_G.QuickPickup=false
_G.AntiStealMode="laser" -- "laser" | "ap"
_G.AntiStealDelay=1.8
_G.AntiStealAP = { balloon=true, tiny=false, jail=false, rocket=false, ragdoll=false }
local aimbotEnabled=false

local dropPosition = {X = 0.5, Y = 0.5}
local dropAutoOff = true
local DROP_ACTIVE_TIME = 0.85

-- VARIABLES VAMPIRE RESET
_G.VampireResetRemote = nil
_G.VampireResetGuid = ""
local RESET_COOLDOWN = false
local resetAttempts = 0
local maxResetAttempts = 20

local imageCache = {}
local assetCache = {}
local function getRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

local function toWikiName(displayName)
    local clean = (displayName or ""):match("^(.-)%s*%(") or displayName or ""
    return clean:gsub(" ", "_")
end

local function fetchFandomImageUrl(displayName)
    if not displayName or displayName == "" then return nil end
    if imageCache[displayName] ~= nil then
        return imageCache[displayName] ~= false and imageCache[displayName] or nil
    end

    local requestFn = getRequestFn()
    if not requestFn then
        imageCache[displayName] = false
        return nil
    end

    local url = "https://stealabrainrot.fandom.com/wiki/" .. toWikiName(displayName)
    local ok, response = pcall(function()
        return requestFn({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0",
                ["Accept"] = "text/html",
            },
        })
    end)

    if not ok or not response then
        imageCache[displayName] = false
        return nil
    end

    local code = response.StatusCode or response.status or response.Status or 0
    local body = response.Body or response.body or response.Data or ""
    if code ~= 200 or body == "" then
        imageCache[displayName] = false
        return nil
    end

    local ogImage = body:match('property="og:image"%s+content="([^"]+)"')
        or body:match('content="([^"]+)"%s+property="og:image"')
        or body:match('property=%s*"og:image"%s+content=%s*"([^"]+)"')

    if ogImage and ogImage ~= "" then
        ogImage = ogImage:gsub("&amp;", "&")
        if ogImage:find("^https?://") then
            imageCache[displayName] = ogImage
            return ogImage
        end
    end

    local img = body:match('src="(https://static%.wikia%.nocookie%.net[^"]+%.png[^"]*)"')
        or body:match('src="(https://static%.wikia%.nocookie%.net[^"]+%.jpg[^"]*)"')
        or body:match('data%-src="(https://static%.wikia%.nocookie%.net[^"]+)"')

    if img and img ~= "" then
        img = img:gsub("/revision/latest.*", "")
        imageCache[displayName] = img
        return img
    end

    imageCache[displayName] = false
    return nil
end

local function loadImageAsAsset(imageUrl, name)
    if not imageUrl or imageUrl == "" then return "" end
    local safeName = tostring(name or "pet"):gsub("[^%w]", "_"):sub(1, 40)
    local fileName = "br_" .. safeName .. ".png"

    -- cache en memoria
    if assetCache and assetCache[name] and assetCache[name] ~= "" then
        return assetCache[name]
    end

    local okExist, exists = pcall(function()
        return isfile and isfile(fileName)
    end)
    if okExist and exists then
        local ok2, asset = pcall(function() return getcustomasset(fileName) end)
        if ok2 and asset and asset ~= "" then
            if assetCache then assetCache[name] = asset end
            return asset
        end
    end

    local data = nil
    local requestFn = getRequestFn()

    if requestFn then
        local ok, res = pcall(function()
            return requestFn({
                Url = imageUrl,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0",
                    ["Accept"] = "image/png,image/jpeg,image/*,*/*",
                },
            })
        end)
        if ok and res then
            local code = res.StatusCode or res.status or res.Status or 200
            if code == 200 or code == 0 then
                data = res.Body or res.body or res.Data
            end
        end
    end

    if (not data or #tostring(data) < 200) then
        pcall(function()
            data = game:HttpGet(imageUrl)
        end)
    end

    if not data or #tostring(data) < 200 then return "" end

    -- evitar guardar HTML de error
    local head = tostring(data):sub(1, 50):lower()
    if head:find("<!doctype") or head:find("<html") or head:find("<?xml") then
        return ""
    end

    local okWrite = pcall(function()
        writefile(fileName, data)
    end)
    if not okWrite then return "" end

    local okAsset, asset = pcall(function()
        return getcustomasset(fileName)
    end)
    if okAsset and asset and asset ~= "" then
        if assetCache then assetCache[name] = asset end
        return asset
    end
    return ""
end

local function parseGenNumber(text)
    if not text then return 0 end
    text = tostring(text):gsub(",", ""):gsub("%s", ""):upper()
    local num = text:match("([%d%.]+)")
    if not num then return 0 end
    num = tonumber(num) or 0
    if text:find("T") then return num * 1e12 end
    if text:find("B") then return num * 1e9 end
    if text:find("M") then return num * 1e6 end
    if text:find("K") then return num * 1e3 end
    return num
end

local function getRarityScoreBest(name)
    name = (name or ""):lower()
    if name:find("secret") or name:find("og") or name:find("exclusive") then return 100 end
    if name:find("mythic") or name:find("mitico") then return 80 end
    if name:find("legendary") or name:find("legendario") then return 60 end
    if name:find("epic") or name:find("epico") then return 40 end
    if name:find("rare") or name:find("raro") then return 25 end
    if name:find("uncommon") then return 15 end
    return 5
end

local function getPetValueBest(prompt, podium)
    if not prompt then return "?", 0 end
    local val = prompt:GetAttribute("Value") or prompt:GetAttribute("Price") or prompt:GetAttribute("Cash") or prompt:GetAttribute("Generation")
    if val then
        local s = tostring(val)
        return s, parseGenNumber(s)
    end
    local searchIn = podium
    if not searchIn and prompt.Parent then searchIn = prompt.Parent.Parent end
    if searchIn then
        for _, d in ipairs(searchIn:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = tostring(d.Text or "")
                if t:find("%$") or t:find("/s") or t:find("/S") or t:find("M/s") or t:find("K/s") or t:find("B/s") then
                    return t, parseGenNumber(t)
                end
            end
        end
    end
    return "?", 0
end

local function drawClickDot(x, y)
    if not Drawing then return end
    local dot = Drawing.new("Circle")
    dot.Radius = 5
    dot.Position = Vector2.new(x, y)
    dot.Color = Color3.fromRGB(255, 80, 80)
    dot.Filled = true
    dot.Visible = true
    dot.Transparency = 0.6
    task.delay(0.25, function() dot:Remove() end)
end

local function getNearestPlayer()
    local chr = LocalPlayer and LocalPlayer.Character
    local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if h then
                local dist = (h.Position - hrp.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = p
                end
            end
        end
    end
    return nearest
end

-- Block Delay: fast (0) / normal (0.50) / slow (1.00) — del script Wins Hub
_G.BlockDelay = _G.BlockDelay or "fast"

local function getBlockDelay()
    if _G.BlockDelay == "normal" then return 0.50
    elseif _G.BlockDelay == "slow" then return 1.00
    else return 0 end -- fast
end

local function PromptClick()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local centerX = vp.X / 2
    local centerY = (vp.Y / 2) + 30
    local vim = VirtualInputManager
    if not vim then
        pcall(function() vim = Instance.new("VirtualInputManager") end)
    end
    if not vim then return end
    for _ = 1, 4 do
        pcall(function()
            vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
            vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
        end)
        task.wait(0.001)
    end
end

local function blockPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return end
    pcall(function()
        task.wait(getBlockDelay())
        StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
        PromptClick()
    end)
end

local function triggerAutoBlock()
    if not _G.AutoBlock then return end
    task.spawn(function()
        local target = getNearestPlayer()
        if target then
            pcall(blockPlayer, target)
        end
    end)
end

local dropEnabled = false
local dropConns = {}
local dropActiveTimer = nil

local dropBusy = false

local function stopDropEffect()
    dropEnabled = false
    for _, dc in ipairs(dropConns) do
        if typeof(dc) == "RBXScriptConnection" then pcall(function() dc:Disconnect() end) end
    end
    dropConns = {}
    if dropActiveTimer then
        pcall(function() task.cancel(dropActiveTimer) end)
        dropActiveTimer = nil
    end
    -- Restaurar personaje YA para poder agarrar brainrot al instante
    pcall(function()
        local ch = LocalPlayer.Character
        if ch then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local root = ch:FindFirstChild("HumanoidRootPart")
            if hum then
                hum.PlatformStand = false
                hum.Sit = false
                if hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                end
            end
            if root then
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, math.min(root.AssemblyLinearVelocity.Y, 50), root.AssemblyLinearVelocity.Z)
            end
        end
    end)
    if dropBtn then
        dropBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
        dropBtn.Text = "DROP"
    end
    dropBusy = false
end

local function toggleDrop()
    if dropEnabled then
        stopDropEffect()
        return
    end
    if dropBusy then
        stopDropEffect()
        return
    end
    dropBusy = true
    dropEnabled = true

    local colConn = RunService.Stepped:Connect(function()
        if not dropEnabled then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    table.insert(dropConns, colConn)

    task.spawn(function()
        local endAt = tick() + (DROP_ACTIVE_TIME or 3)
        while dropEnabled and tick() < endAt do
            RunService.Heartbeat:Wait()
            local c = LocalPlayer.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, 0.1, 0)
                end
            else
                RunService.Heartbeat:Wait()
            end
        end
        stopDropEffect()
    end)

    if dropBtn then
        dropBtn.BackgroundColor3 = Color3.fromRGB(60,200,120)
        dropBtn.Text = "DROP ✓"
    end
end

local dropGUI = nil
local dropMain = nil
local dropShadow = nil
local dropBtn = nil
local dropGuiVisible = false

local function createDropGui()
    local existing = PlayerGui:FindFirstChild("DropBrainrotGui")
    if existing then existing:Destroy() end
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DropBrainrotGui"
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 16
    GUI.Parent = PlayerGui
    dropGUI = GUI
    local Shadow = Instance.new("Frame", GUI)
    Shadow.Size = UDim2.new(0, 96, 0, 48)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(dropPosition.X or 0.5, 0, dropPosition.Y or 0.5, 0)
    Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Shadow.BackgroundTransparency = 0.5
    Shadow.BorderSizePixel = 0
    local c = Instance.new("UICorner", Shadow); c.CornerRadius = UDim.new(0, 8)
    dropShadow = Shadow
    local Main = Instance.new("Frame", GUI)
    Main.Size = UDim2.new(0, 88, 0, 40)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(dropPosition.X or 0.5, 0, dropPosition.Y or 0.5, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8,15,30)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    local mc = Instance.new("UICorner", Main); mc.CornerRadius = UDim.new(0, 6)
    local ms = Instance.new("UIStroke", Main); ms.Color = Color3.fromRGB(0,150,255); ms.Thickness = 1.5
    dropMain = Main
    local DropBtn = Instance.new("TextButton", Main)
    DropBtn.Size = UDim2.new(1,-4,1,-4)
    DropBtn.Position = UDim2.new(0,2,0,2)
    DropBtn.BackgroundColor3 = Color3.fromRGB(140,35,35)
    DropBtn.Text = "DROP"
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.TextSize = 12
    DropBtn.TextColor3 = Color3.fromRGB(255,255,255)
    DropBtn.BorderSizePixel = 0
    local dbc = Instance.new("UICorner", DropBtn); dbc.CornerRadius = UDim.new(0, 4)
    dropBtn = DropBtn
    local dragging, dragStart, startPos
    local cam = workspace.CurrentCamera
    DropBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=Main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then
                    dragging=false
                    dropPosition.X = Main.Position.X.Scale
                    dropPosition.Y = Main.Position.Y.Scale
                    pcall(saveSettings)
                end
            end)
        end
    end)
    Main.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
        local d = inp.Position - dragSt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local VirtualInput = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

local C = {
    accent    = Color3.fromRGB(0, 150, 255),
    accentHi  = Color3.fromRGB(0, 200, 255),
    deepRed   = Color3.fromRGB(10, 25, 50),
    body      = Color3.fromRGB(8, 15, 30),
    panel     = Color3.fromRGB(15, 25, 45),
    tabBar    = Color3.fromRGB(10, 20, 35),
    card      = Color3.fromRGB(20, 35, 60),
    iconBg    = Color3.fromRGB(25, 45, 80),
    stroke    = Color3.fromRGB(30, 80, 140),
    strokeDim = Color3.fromRGB(20, 50, 90),
    textBright = Color3.fromRGB(220, 240, 255),
    textMute   = Color3.fromRGB(120, 160, 200),
    textDim    = Color3.fromRGB(80, 120, 160),
    knobOn     = Color3.fromRGB(200, 240, 255),
}

local borderGradientSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.accentHi),
    ColorSequenceKeypoint.new(0.25, C.deepRed),
    ColorSequenceKeypoint.new(0.5, C.accent),
    ColorSequenceKeypoint.new(0.75, C.deepRed),
    ColorSequenceKeypoint.new(1, C.accentHi),
})

local function getGuiParent()
    local parent = nil
    pcall(function()
        if typeof(gethui) == "function" then parent = gethui() end
    end)
    if not parent then
        pcall(function()
            local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
            parent = _cr(CoreGui)
        end)
    end
    if not parent then
        parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    end
    return parent
end

pcall(function()
    local parents = {}
    pcall(function()
        if typeof(gethui) == "function" then
            local h = gethui()
            if h then table.insert(parents, h) end
        end
    end)
    table.insert(parents, CoreGui)
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if pg then table.insert(parents, pg) end
    for _, p in ipairs(parents) do
        local old = p:FindFirstChild("BlockPanelUI")
        if old then old:Destroy() end
    end
end)

local parent = getGuiParent()
if not parent then return end

local isBlocking = false

local function instantBlock(player)
    if not player or player == LP then return false end
    if isBlocking then return false end
    isBlocking = true

    local Camera = workspace.CurrentCamera
    if not Camera then isBlocking = false; return false end
    local vp = Camera.ViewportSize

    local ok = pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", player)
        task.wait(0.03)
        local offsets = {30, 25, 35}
        for _, offset in ipairs(offsets) do
            local cx = vp.X / 2
            local cy = (vp.Y / 2) + offset
            for _ = 1, 3 do
                VirtualInput:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                VirtualInput:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                task.wait(0.001)
            end
        end
    end)

    task.wait(0.02)
    isBlocking = false
    return ok
end

local gui = Instance.new("ScreenGui")
gui.Name = "BlockPanelUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(gui) end
end)
gui.Parent = parent

local WIN_W = 230
local WIN_H = 420

local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderFrame"
BorderFrame.Size = UDim2.new(0, WIN_W + 4, 0, WIN_H + 4)
BorderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BorderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BorderFrame.BackgroundColor3 = C.accent
BorderFrame.BorderSizePixel = 0
BorderFrame.ClipsDescendants = true
BorderFrame.ZIndex = 1
BorderFrame.Parent = gui
Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 10)

local BorderGrad = Instance.new("UIGradient")
BorderGrad.Color = borderGradientSeq
BorderGrad.Rotation = 308
BorderGrad.Parent = BorderFrame

local Win = Instance.new("Frame")
Win.Name = "Win"
Win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
Win.Position = UDim2.new(0.5, 0, 0.5, 0)
Win.AnchorPoint = Vector2.new(0.5, 0.5)
Win.BackgroundColor3 = C.body
Win.BackgroundTransparency = 0.1
Win.BorderSizePixel = 0
Win.ClipsDescendants = true
Win.ZIndex = 2
Win.Parent = gui
Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 10)

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
overlay.BackgroundTransparency = 0.45
overlay.BorderSizePixel = 0
overlay.ZIndex = 0
overlay.Parent = Win
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 10)

local redTint = Instance.new("Frame")
redTint.Size = UDim2.fromScale(1, 1)
redTint.BackgroundColor3 = Color3.fromRGB(10, 30, 80)
redTint.BackgroundTransparency = 0.75
redTint.BorderSizePixel = 0
redTint.ZIndex = 0
redTint.Parent = Win
Instance.new("UICorner", redTint).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = C.panel
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.Active = true
Header.ZIndex = 3
Header.Parent = Win
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = C.stroke
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 4
HeaderLine.Parent = Header

local HeaderDot = Instance.new("Frame")
HeaderDot.Size = UDim2.new(0, 5, 0, 5)
HeaderDot.Position = UDim2.new(0, 8, 0.5, -2.5)
HeaderDot.BackgroundColor3 = C.accent
HeaderDot.BorderSizePixel = 0
HeaderDot.ZIndex = 5
HeaderDot.Parent = Header
Instance.new("UICorner", HeaderDot).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -68, 1, 0)
Title.Position = UDim2.new(0, 17, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Block Panel"
Title.TextColor3 = C.textBright
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 5
Title.Parent = Header

local function headerButton(name, txt, xOff)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(0, 18, 0, 18)
    b.Position = UDim2.new(1, xOff, 0.5, -9)
    b.BackgroundColor3 = C.card
    b.BorderSizePixel = 0
    b.ZIndex = 6
    b.Text = txt
    b.TextColor3 = C.textMute
    b.TextSize = 8
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = Header
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke"); s.Color = C.stroke; s.Thickness = 1; s.Parent = b
    return b
end

local RefreshBtn = headerButton("RefreshR", "⟳", -42)
local CloseBtn = headerButton("Close", "X", -22)

local list = Instance.new("ScrollingFrame")
list.Name = "PlayerList"
list.Size = UDim2.new(1, -10, 1, -38)
list.Position = UDim2.new(0, 5, 0, 34)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = C.accent
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ScrollingDirection = Enum.ScrollingDirection.Y
list.ZIndex = 2
list.Parent = Win

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = list

local listPad = Instance.new("UIPadding")
listPad.PaddingTop = UDim.new(0, 4)
listPad.PaddingBottom = UDim.new(0, 4)
listPad.Parent = list

local function createPlayerEntry(player, order)
    local entry = Instance.new("Frame")
    entry.Name = "Entry_" .. player.Name
    entry.Size = UDim2.new(1, -6, 0, 50)
    entry.BackgroundColor3 = C.card
    entry.BorderSizePixel = 0
    entry.LayoutOrder = order
    entry.ZIndex = 3
    entry.Parent = list
    Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 7)

    local eStroke = Instance.new("UIStroke")
    eStroke.Color = C.stroke
    eStroke.Thickness = 1
    eStroke.Parent = entry

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 1, -6)
    accentBar.Position = UDim2.new(0, 0, 0, 3)
    accentBar.BackgroundColor3 = C.accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 4
    accentBar.Parent = entry
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 34, 0, 34)
    avatar.Position = UDim2.new(0, 6, 0.5, -17)
    avatar.BackgroundColor3 = C.iconBg
    avatar.BorderSizePixel = 0
    avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(player.UserId)
    avatar.ZIndex = 4
    avatar.Parent = entry
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 7)

    local avStroke = Instance.new("UIStroke")
    avStroke.Color = C.accent
    avStroke.Thickness = 1.3
    avStroke.Transparency = 0.3
    avStroke.Parent = avatar

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -115, 0, 15)
    nameLabel.Position = UDim2.new(0, 46, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = C.textBright
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 4
    nameLabel.Parent = entry

    local dispLabel = Instance.new("TextLabel")
    dispLabel.Size = UDim2.new(1, -115, 0, 12)
    dispLabel.Position = UDim2.new(0, 46, 0, 24)
    dispLabel.BackgroundTransparency = 1
    dispLabel.Text = "@" .. player.DisplayName
    dispLabel.TextColor3 = C.textMute
    dispLabel.TextSize = 8
    dispLabel.Font = Enum.Font.GothamMedium
    dispLabel.TextXAlignment = Enum.TextXAlignment.Left
    dispLabel.TextTruncate = Enum.TextTruncate.AtEnd
    dispLabel.ZIndex = 4
    dispLabel.Parent = entry

    local blockBtn = Instance.new("TextButton")
    blockBtn.Size = UDim2.new(0, 54, 0, 24)
    blockBtn.Position = UDim2.new(1, -60, 0.5, -12)
    blockBtn.BackgroundColor3 = C.accent
    blockBtn.BorderSizePixel = 0
    blockBtn.Text = "Block"
    blockBtn.TextColor3 = C.textBright
    blockBtn.TextSize = 9
    blockBtn.Font = Enum.Font.GothamBold
    blockBtn.AutoButtonColor = false
    blockBtn.ZIndex = 4
    blockBtn.Parent = entry
    Instance.new("UICorner", blockBtn).CornerRadius = UDim.new(0, 5)

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = C.accentHi
    bStroke.Thickness = 1
    bStroke.Parent = blockBtn

    blockBtn.MouseEnter:Connect(function()
        TweenService:Create(blockBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.accentHi }):Play()
    end)
    blockBtn.MouseLeave:Connect(function()
        TweenService:Create(blockBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.accent }):Play()
    end)

    blockBtn.MouseButton1Click:Connect(function()
        if blockBtn.Text == "✓ Blocked" then return end
        blockBtn.Text = "..."
        blockBtn.BackgroundColor3 = C.card
        blockBtn.TextColor3 = C.textMute

        task.spawn(function()
            local success = instantBlock(player)
            blockBtn.Text = success and "✓ Blocked" or "✗ Failed"
            blockBtn.BackgroundColor3 = success and C.strokeDim or Color3.fromRGB(60, 10, 15)
            blockBtn.TextColor3 = success and C.textMute or C.accentHi
            task.wait(2)
            if blockBtn and blockBtn.Parent then
                blockBtn.Text = "Block"
                blockBtn.BackgroundColor3 = C.accent
                blockBtn.TextColor3 = C.textBright
            end
        end)
    end)

    entry.MouseEnter:Connect(function()
        TweenService:Create(entry, TweenInfo.new(0.15), { BackgroundColor3 = C.iconBg }):Play()
        TweenService:Create(eStroke, TweenInfo.new(0.15), { Color = C.accent }):Play()
    end)
    entry.MouseLeave:Connect(function()
        TweenService:Create(entry, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play()
        TweenService:Create(eStroke, TweenInfo.new(0.15), { Color = C.stroke }):Play()
    end)

    return entry
end

local function refreshList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            count = count + 1
            createPlayerEntry(player, count)
        end
    end
    if count == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 50)
        empty.BackgroundTransparency = 1
        empty.Text = "لا يوجد لاعبون آخرون"
        empty.TextColor3 = C.textMute
        empty.TextSize = 10
        empty.Font = Enum.Font.GothamMedium
        empty.ZIndex = 3
        empty.Parent = list
    end
end

refreshList()
RefreshBtn.MouseButton1Click:Connect(refreshList)
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshList() end)

local function hookButton(btn, normal, hover)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = hover }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = normal }):Play()
    end)
end
hookButton(RefreshBtn, C.card, C.iconBg)
hookButton(CloseBtn, C.card, C.iconBg)

CloseBtn.MouseButton1Click:Connect(function()
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local t1 = TweenService:Create(Win, info, { Size = UDim2.new(0, 0, 0, 0) })
    local t2 = TweenService:Create(BorderFrame, info, { Size = UDim2.new(0, 0, 0, 0) })
    t1:Play(); t2:Play()
    t1.Completed:Connect(function() gui:Destroy() end)
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Win.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        Win.Position = newPos
        BorderFrame.Position = newPos
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

task.spawn(function()
    local baseRot = BorderGrad.Rotation
    while BorderGrad.Parent do
        local t = os.clock()
        BorderGrad.Rotation = (baseRot + t * 18) % 360
        RunService.RenderStepped:Wait()
    end
end)

task.spawn(function()
    local targetPos = UDim2.new(0.5, 0, 0.5, 0)
    Win.Position = UDim2.new(0.5, 0, 0.5, -40)
    BorderFrame.Position = Win.Position
    TweenService:Create(Win, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = targetPos }):Play()
    TweenService:Create(BorderFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = targetPos }):Play()
end)