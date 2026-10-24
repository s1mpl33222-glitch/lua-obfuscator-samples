--==================================================
-- MELODY MAIN
-- DARK/LIGHT • SETTINGS FIX • CAMLOCK SMOOTH • TRAFFIC DOTS
--==================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = " ────୨ৎ──── ",
    Text = "Melody Dahood make sure to be cute",
    Duration = 5
})

local Player = Players.LocalPlayer
local me = Player
local cam = workspace.CurrentCamera
local mouse = me:GetMouse()
local PlayerGui = Player:WaitForChild("PlayerGui")

-- remove any previous instance (PlayerGui / CoreGui / gethui)
pcall(function()
    local old = PlayerGui:FindFirstChild("MELODY_EXE")
    if old then old:Destroy() end
end)
pcall(function()
    local cg = game:GetService("CoreGui")
    local old = cg:FindFirstChild("MELODY_EXE")
    if old then old:Destroy() end
end)
pcall(function()
    if gethui then
        local old = gethui():FindFirstChild("MELODY_EXE")
        if old then old:Destroy() end
    end
end)

--==================================================
-- COLORS  (black + white)
--==================================================
local DARK = {
    BG = Color3.fromRGB(20, 14, 29),
    SURFACE = Color3.fromRGB(35, 22, 48),
    CARD = Color3.fromRGB(47, 30, 61),
    CARD2 = Color3.fromRGB(65, 39, 78),
    BORDER = Color3.fromRGB(119, 72, 107),
    WHITE = Color3.fromRGB(255, 158, 65),
    MUTE = Color3.fromRGB(255, 190, 112),
    DIM = Color3.fromRGB(205, 111, 49),
}

local LIGHT = {
    BG = Color3.fromRGB(255, 241, 222),
    SURFACE = Color3.fromRGB(255, 222, 184),
    CARD = Color3.fromRGB(255, 248, 235),
    CARD2 = Color3.fromRGB(255, 231, 200),
    BORDER = Color3.fromRGB(235, 190, 214),
    WHITE = Color3.fromRGB(166, 72, 18),
    MUTE = Color3.fromRGB(190, 91, 28),
    DIM = Color3.fromRGB(214, 126, 54),
}

local BG, SURFACE, CARD, CARD2, BORDER, WHITE, MUTE, DIM =
    LIGHT.BG, LIGHT.SURFACE, LIGHT.CARD, LIGHT.CARD2, LIGHT.BORDER, LIGHT.WHITE, LIGHT.MUTE, LIGHT.DIM

local PINK     = Color3.fromRGB(255, 119, 30) -- pumpkin orange accent
local PINKSOFT = Color3.fromRGB(255, 190, 102) -- cute candle-glow orange
local FONT     = Enum.Font.FredokaOne

local Theme = {
    Outline = Color3.fromRGB(255, 119, 30),
    Text    = WHITE,
    Accent  = Color3.fromRGB(255, 119, 30),
    Mode    = "Light",
}

local ESP_COLORS = {
    Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 140, 40), Color3.fromRGB(255, 220, 50),
    Color3.fromRGB(60, 220, 100), Color3.fromRGB(60, 140, 255), Color3.fromRGB(160, 80, 255),
    Color3.fromRGB(255, 100, 180), Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 255, 255),
}
local FOV_COLORS = ESP_COLORS
local PICKER_COLORS = {
    Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 140, 40), Color3.fromRGB(255, 220, 50),
    Color3.fromRGB(60, 220, 100), Color3.fromRGB(60, 180, 255), Color3.fromRGB(80, 120, 255),
    Color3.fromRGB(160, 80, 255), Color3.fromRGB(255, 100, 180), Color3.fromRGB(255, 175, 205),
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190), Color3.fromRGB(40, 40, 50),
}

--==================================================
-- STATE
--==================================================
local env = (getgenv and getgenv()) or _G
local _G = env

_G.SilentAim_Enabled = false
_G.FOV_RADIUS = 0
_G.ShowFOV = false
_G.FOV_Color = Color3.fromRGB(255, 255, 255)
_G.RevolverBypass = false
_G.WallCheck = false
_G.Knock_Check = false
_G.ESP_Boxes = false
_G.ESP_Names = false
_G.ESP_Health = false
_G.ESP_Color = Color3.fromRGB(255, 255, 255)
_G.Speed_Enabled = false
    _G.Speed_Value = 50
    _G.Speed_Key = Enum.KeyCode.X
    _G.Speed_ToggleEnabled = false
    _G.Jump_Enabled = false
    _G.Jump_Value = 50
    _G.Jump_Key = Enum.KeyCode.C

    local TriggerBot = {
        MasterEnabled = false,
        TriggerKey = Enum.KeyCode.T,
        Active = false,
        ClickDelay = 0.02,
        Blacklist = {"Knife","Wallet","Phone","Chicken","Pizza","Flashlight","Medkit"}
    }

    _G.CamLock_Enabled = false
    _G.CamLock_Key = Enum.KeyCode.V
    _G.CamLock_Smoothness = 0.25
    local camLockActive, lastCamLockDir, currentCamLockTarget = false, nil, nil

    local _0x52a0d5 = { BulletSpread = { Enabled = true, Amount = 100 } }

    if not _G.SaturnConfigs then _G.SaturnConfigs = {} end
    if not _G.SaturnWhitelist then _G.SaturnWhitelist = {} end -- [userId] = true

    local ToggleUI = {}
    local SliderUI = {}
    local refreshWeaponButtons -- forward declare (filled in skins section)

    local function isWhitelisted(plr)
        if not plr then return false end
        local id = plr.UserId
        if _G.SaturnWhitelist[id] == true then return true end
        if _G.SaturnWhitelist[tostring(id)] == true then return true end
        -- name fallback
        if _G.SaturnWhitelist[plr.Name] == true then return true end
        if _G.SaturnWhitelist[string.lower(plr.Name)] == true then return true end
        return false
    end

    local function setWhitelisted(plr, state)
        if not plr then return end
        local id = plr.UserId
        if state then
            _G.SaturnWhitelist[id] = true
            _G.SaturnWhitelist[tostring(id)] = true
            _G.SaturnWhitelist[plr.Name] = true
            _G.SaturnWhitelist[string.lower(plr.Name)] = true
        else
            _G.SaturnWhitelist[id] = nil
            _G.SaturnWhitelist[tostring(id)] = nil
            _G.SaturnWhitelist[plr.Name] = nil
            _G.SaturnWhitelist[string.lower(plr.Name)] = nil
        end
    end

    local SHOP_TPS = {
        { name = "$ Military",        pos = Vector3.new(28.3, 25.5, -833.8) },
        { name = "$ Uphill",          pos = Vector3.new(482.6, 47.8, -614.3) },
        { name = "$ Revolver",        pos = Vector3.new(-636.8, 21.7, -123.1) },
        { name = "$ Old Military",    pos = Vector3.new(-1049.2, 21.5, -263.2) },
        { name = "$ Shotgun",         pos = Vector3.new(-578.3, 8.2, -736.8) },
        { name = "$ Uphill Revolver", pos = Vector3.new(538.1, 4.4, -255.3) },
    }

    local function teleportToPos(pos)
        local hrp = me.Character and me.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end
    end

    --==================================================
    -- SKIN BACKEND
    --==================================================
    shared.Glory = shared.Glory or {
        skins = {
            enabled = true,
            weapons = {
                ["[Knife]"] = "", ["[Shotgun]"] = "", ["[Double-Barrel SG]"] = "",
                ["[TacticalShotgun]"] = "", ["[Revolver]"] = "", ["[Flamethrower]"] = "", ["[RPG]"] = ""
            }
    }
}
local cfg = shared.Glory
local knifedata, toolregistry = {}, {}

local DEFAULT_KNIFE_OFFSET = {
    positionoffset = Vector3.new(0, -0.20, -1.2),
    rotationoffset = Vector3.new(90, 263.7, 180),
    soundid = "",
    animationid = "",
}

local knifeskins = {
    ["Golden"] = { soundid = "", animationid = "", positionoffset = Vector3.new(0, -0.20, -1.2), rotationoffset = Vector3.new(90, 263.7, 180) },
    ["Golden Age Tanto"] = { soundid = "rbxassetid://5917819099", animationid = "rbxassetid://13473404819", positionoffset = Vector3.new(0, -0.20, -1.2), rotationoffset = Vector3.new(90, 263.7, 180) },
    ["GPO-Knife"] = { soundid = "rbxassetid://4604390759", animationid = "rbxassetid://14014278925", positionoffset = Vector3.new(0.00, -0.32, -1.07), rotationoffset = Vector3.new(90, -97.4, 90) },
    ["Heaven"] = { soundid = "rbxassetid://14489860007", animationid = "rbxassetid://14500266726", positionoffset = Vector3.new(-0.02, -0.82, 0.20), rotationoffset = Vector3.new(64.42, 3.79, 0.00) },
    ["Purple Dagger"] = { soundid = "rbxassetid://17822743153", animationid = "rbxassetid://17824999722", positionoffset = Vector3.new(-0.13, -0.24, -1.80), rotationoffset = Vector3.new(89.05, 96.63, 180.00) },
    ["Dragon"] = { soundid = "rbxassetid://14217789230", animationid = "rbxassetid://14217804400", positionoffset = Vector3.new(-0.02, -0.32, -0.98), rotationoffset = Vector3.new(89.05, 90.95, 180.00) },
    ["Void"] = { soundid = "rbxassetid://14756591763", animationid = "rbxassetid://14774699952", positionoffset = Vector3.new(-0.02, -0.22, -0.85), rotationoffset = Vector3.new(180.00, 90.95, 180.00) },
    ["Ribbon"] = { soundid = "rbxassetid://130974579277249", animationid = "rbxassetid://124102609796063", positionoffset = Vector3.new(0.02, -0.25, -0.05), rotationoffset = Vector3.new(90.00, 0.00, 180.00) },
    ["Love Kukri"] = { soundid = "", animationid = "", positionoffset = Vector3.new(0, -0.22, -1.15), rotationoffset = Vector3.new(90, 263.7, 180) },
    ["LoveKukri"] = { soundid = "", animationid = "", positionoffset = Vector3.new(0, -0.22, -1.15), rotationoffset = Vector3.new(90, 263.7, 180) },
}

local function isFX(inst)
    return inst:IsA("ParticleEmitter") or inst:IsA("Fire") or inst:IsA("Smoke")
        or inst:IsA("Sparkles") or inst:IsA("Trail") or inst:IsA("Beam")
end

-- wipe ALL visual FX under a tool (old skin particles, trails, etc.)
local function clearAllSkinFX(tool)
    if not tool then return end
    local toDestroy = {}
    for _, v in ipairs(tool:GetDescendants()) do
        if isFX(v) then
            table.insert(toDestroy, v)
        elseif v:IsA("Attachment") and v:GetAttribute("SaturnSkinFX") then
            table.insert(toDestroy, v)
        end
    end
    for _, v in ipairs(toDestroy) do
        pcall(function() v:Destroy() end)
    end
end

local function clearmesh(tool, exclude)
    if not tool then return end
    local kids = tool:GetChildren()
    for _, v in ipairs(kids) do
        if v == exclude then
            -- keep
        elseif v.Name == "CurrentSkin" or v:GetAttribute("SaturnSkin") then
            pcall(function() v:Destroy() end)
        elseif v:IsA("MeshPart") and v.Name ~= "Handle" and v.Name ~= "Default" then
            pcall(function() v:Destroy() end)
        elseif v:IsA("Model") and v.Name ~= "Default" then
            pcall(function() v:Destroy() end)
        end
    end
    clearAllSkinFX(tool)
end

local function clearParticles(root)
    if not root then return end
    local toDestroy = {}
    for _, v in ipairs(root:GetDescendants()) do
        if isFX(v) then table.insert(toDestroy, v) end
        if v:IsA("Attachment") and v:GetAttribute("SaturnSkinFX") then table.insert(toDestroy, v) end
    end
    for _, v in ipairs(toDestroy) do pcall(function() v:Destroy() end) end
end

local function deepCloneParticles(source, target)
    if not source or not target then return end
    for _, child in ipairs(source:GetChildren()) do
        if isFX(child) then
            local c = child:Clone()
            c:SetAttribute("SaturnSkinFX", true)
            c.Parent = target
        elseif child:IsA("Attachment") then
            local att = child:Clone()
            att:SetAttribute("SaturnSkinFX", true)
            -- strip non-fx if needed; keep structure
            att.Parent = target
            for _, d in ipairs(att:GetDescendants()) do
                if isFX(d) then d:SetAttribute("SaturnSkinFX", true) end
            end
        end
    end
end

local function findParticleSource(folder, name)
    if not folder then return nil end
    local exact = folder:FindFirstChild(name)
    if exact then return exact end
    local lower = string.lower(name)
    for _, ch in ipairs(folder:GetChildren()) do
        if string.lower(ch.Name) == lower then return ch end
    end
    return nil
end

local function applygun(tool, name)
    if not name or name == "" or not tool then return false end
    local handle = tool:FindFirstChild("Handle")
    local orig = tool:FindFirstChildOfClass("MeshPart") or tool:FindFirstChildWhichIsA("MeshPart")
        or (handle and handle:IsA("MeshPart") and handle) or handle
    if not orig then return false end

    local skinmodules = ReplicatedStorage:FindFirstChild("SkinModules")
    if not skinmodules then return false end
    local ok, skinmodulesreq = pcall(function() return require(skinmodules) end)
    if not ok or not skinmodulesreq then return false end
    local toolData = skinmodulesreq[tool.Name]
    if not toolData then return false end

    local info = toolData[name]
    if not info then
        for skinName, skinInfo in pairs(toolData) do
            if string.lower(tostring(skinName)) == string.lower(name) then
                info = skinInfo
                name = skinName
                break
            end
        end
    end
    if not info then return false end

    -- full cleanup of previous skin + particles first
    clearmesh(tool, orig)
    clearAllSkinFX(tool)
    if handle then clearParticles(handle) end
    if orig and orig ~= handle then clearParticles(orig) end

    -- restore default visibility before applying
    if orig:IsA("BasePart") and typeof(info.TextureID) == "string" then
        orig.Transparency = 0
    end

    local skinpart = info.TextureID
    if typeof(skinpart) == "Instance" then
        local clone = skinpart:Clone()
        clone.Name = "CurrentSkin"
        clone:SetAttribute("SaturnSkin", true)
        if clone:IsA("Model") then
            if not clone.PrimaryPart then
                for _, p in ipairs(clone:GetDescendants()) do
                    if p:IsA("BasePart") then clone.PrimaryPart = p break end
                end
            end
            for _, p in ipairs(clone:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                    p.Massless = true
                    p.Anchored = false
                end
            end
            clone.Parent = tool
            if clone.PrimaryPart and orig then
                local w = Instance.new("Weld")
                w.Part0 = orig
                w.Part1 = clone.PrimaryPart
                if info.CFrame then w.C0 = info.CFrame:Inverse() end
                w.Parent = clone.PrimaryPart
            end
            if orig:IsA("BasePart") then orig.Transparency = 1 end
        else
            clone.CanCollide = false
            clone.Massless = true
            clone.Anchored = false
            clone.Parent = tool
            if orig:IsA("BasePart") then
                local w = Instance.new("Weld")
                w.Part0 = clone
                w.Part1 = orig
                if info.CFrame then w.C0 = info.CFrame:Inverse() end
                w.Parent = clone
                orig.Transparency = 1
            end
        end
    elseif typeof(skinpart) == "string" and orig:IsA("MeshPart") then
        orig.TextureID = skinpart
        orig.Transparency = 0
    end

    -- only the matching particle set for THIS skin
    if handle then
        clearParticles(handle)
        local skinassets = ReplicatedStorage:FindFirstChild("SkinAssets")
        if skinassets then
            local particlefolder = skinassets:FindFirstChild("GunHandleParticle")
            local particlesource = findParticleSource(particlefolder, name)
            if particlesource then
                deepCloneParticles(particlesource, handle)
            end
        end
        handle:SetAttribute("SkinName", name)
    end
    return true
end

local function cleanknife(tool)
    local data = knifedata[tool]
    if data then
        if data.track then pcall(function() data.track:Stop() data.track:Destroy() end) end
        if data.welds then for _, w in ipairs(data.welds) do if w then pcall(function() w:Destroy() end) end end end
    end
    clearAllSkinFX(tool)
    local mesh = tool:FindFirstChild("Default")
    if mesh then
        for _, v in ipairs(mesh:GetChildren()) do
            if v.Name == "Handle.R" or v:IsA("Model") or v:GetAttribute("SaturnSkin")
                or (v:IsA("BasePart") and v.Name ~= "Default") then
                pcall(function() v:Destroy() end)
            end
        end
        clearParticles(mesh)
        mesh.Transparency = 0
    end
    local handle = tool:FindFirstChild("Handle")
    if handle then clearParticles(handle) end
    knifedata[tool] = nil
end

local function findKnifeModel(knivesFolder, skin)
    if not knivesFolder then return nil, skin end
    local exact = knivesFolder:FindFirstChild(skin)
    if exact then return exact, skin end
    local lower = string.lower(skin)
    -- try common variants
    local alts = { skin, lower, skin:gsub("%s+", ""), skin:gsub("%s+", "-"), skin:gsub("%s+", "_") }
    for _, alt in ipairs(alts) do
        local m = knivesFolder:FindFirstChild(alt)
        if m then return m, m.Name end
    end
    for _, ch in ipairs(knivesFolder:GetChildren()) do
        if string.lower(ch.Name) == lower then return ch, ch.Name end
        if string.find(string.lower(ch.Name), lower, 1, true) then return ch, ch.Name end
        if string.find(lower, string.lower(ch.Name), 1, true) then return ch, ch.Name end
    end
    return nil, skin
end

local function applyknife(char, tool, skin)
    if not skin or skin == "" or not tool or not char then return false end

    local skincfg = knifeskins[skin]
    if not skincfg then
        for n, c in pairs(knifeskins) do
            if string.lower(n) == string.lower(skin) then
                skincfg = c
                skin = n
                break
            end
        end
    end
    -- allow any SkinModules knife even if not in table
    if not skincfg then
        skincfg = DEFAULT_KNIFE_OFFSET
    end

    local hum = char:FindFirstChild("Humanoid")
    local rhand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    if not hum or not rhand then return false end

    cleanknife(tool)
    clearAllSkinFX(tool)

    knifedata[tool] = { track = nil, welds = {} }
    local data = knifedata[tool]
    local mesh = tool:FindFirstChild("Default") or tool:FindFirstChild("Handle")
    if not mesh then return false end
    if mesh:IsA("BasePart") then mesh.Transparency = 1 end

    local skinmodules = ReplicatedStorage:FindFirstChild("SkinModules")
    if not skinmodules then
        if mesh:IsA("BasePart") then mesh.Transparency = 0 end
        return false
    end
    local knives = skinmodules:FindFirstChild("Knives")
    if not knives then
        if mesh:IsA("BasePart") then mesh.Transparency = 0 end
        return false
    end

    local skinmodel, resolvedName = findKnifeModel(knives, skin)
    if not skinmodel then
        if mesh:IsA("BasePart") then mesh.Transparency = 0 end
        return false
    end
    skin = resolvedName

    local clone = skinmodel:Clone()
    clone.Name = "CurrentKnifeSkin"
    clone:SetAttribute("SaturnSkin", true)

    local handr = Instance.new("Part")
    handr.Name = "Handle.R"
    handr.Transparency = 1
    handr.CanCollide = false
    handr.Size = Vector3.new(0.001, 0.001, 0.001)
    handr.Massless = true
    handr.Parent = mesh

    local m6d = Instance.new("Motor6D")
    m6d.Part0 = rhand
    m6d.Part1 = handr
    m6d.Parent = handr

    local offset = CFrame.new(skincfg.positionoffset) * CFrame.Angles(
        math.rad(skincfg.rotationoffset.X),
        math.rad(skincfg.rotationoffset.Y),
        math.rad(skincfg.rotationoffset.Z)
    )

    local function weldPart(p, relativeTo)
        p.CanCollide = false
        p.Massless = true
        p.Anchored = false
        local w = Instance.new("Weld")
        w.Part0 = handr
        w.Part1 = p
        w.C0 = offset
        if relativeTo then
            w.C1 = p.CFrame:ToObjectSpace(relativeTo.CFrame)
        end
        w.Parent = p
        table.insert(data.welds, w)
    end

    if clone:IsA("Model") then
        if not clone.PrimaryPart then
            for _, c in ipairs(clone:GetDescendants()) do
                if c:IsA("BasePart") then
                    clone.PrimaryPart = c
                    break
                end
            end
        end
        clone.Parent = mesh
        if clone.PrimaryPart then
            for _, p in ipairs(clone:GetDescendants()) do
                if p:IsA("BasePart") then
                    weldPart(p, clone.PrimaryPart)
                end
            end
        else
            -- no baseparts? still parent so particles exist, but try MeshParts
            for _, p in ipairs(clone:GetDescendants()) do
                if p:IsA("MeshPart") or p:IsA("Part") then
                    weldPart(p, p)
                end
            end
        end
    elseif clone:IsA("BasePart") then
        clone.Parent = mesh
        weldPart(clone, nil)
    else
        -- Folder or other: parent children
        clone.Parent = mesh
        for _, p in ipairs(clone:GetDescendants()) do
            if p:IsA("BasePart") then
                weldPart(p, p)
            end
        end
    end

    -- knife-specific particles from SkinAssets if any
    local skinassets = ReplicatedStorage:FindFirstChild("SkinAssets")
    if skinassets then
        local knifeParticles = skinassets:FindFirstChild("KnifeParticle")
            or skinassets:FindFirstChild("GunHandleParticle")
        local src = findParticleSource(knifeParticles, skin)
        if src and mesh then
            deepCloneParticles(src, mesh)
        end
    end

    tool:SetAttribute("CurrentKnifeSkin", skin)
    return true
end

local function setuptool(tool)
    if not tool:IsA("Tool") or toolregistry[tool] then return end
    toolregistry[tool] = true
    tool.Equipped:Connect(function()
        if not cfg.skins.enabled then return end
        if tool.Parent ~= me.Character then return end
        local skin = cfg.skins.weapons[tool.Name]
        if not skin or skin == "" then return end
        if tool.Name == "[Knife]" then applyknife(me.Character, tool, skin)
        else applygun(tool, skin) end
    end)
    tool.Unequipped:Connect(function()
        if tool.Name == "[Knife]" then cleanknife(tool) end
    end)
    if tool.Parent == me.Character then
        local skin = cfg.skins.weapons[tool.Name]
        if skin and skin ~= "" then
            task.spawn(function()
                if tool.Name == "[Knife]" then applyknife(me.Character, tool, skin)
                else applygun(tool, skin) end
            end)
        end
    end
end

local function watchchar(char)
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do if v:IsA("Tool") then setuptool(v) end end
    char.ChildAdded:Connect(function(v) if v:IsA("Tool") then setuptool(v) end end)
end
if me.Character then watchchar(me.Character) end
me.CharacterAdded:Connect(watchchar)
for _, v in ipairs(me.Backpack:GetChildren()) do if v:IsA("Tool") then setuptool(v) end end
me.Backpack.ChildAdded:Connect(function(v) if v:IsA("Tool") then setuptool(v) end end)

--==================================================
-- HELPERS
--==================================================
local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, math.min(r, 12))
    c.Parent = o
    return c
end

local function stroke(o, col, tr, th)
    local s = Instance.new("UIStroke")
    s.Color = col or BORDER
    s.Transparency = tr or 0.35
    s.Thickness = th or 1
    s.Parent = o
    return s
end

local function tween(o, t, props, style)
    local a = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    a:Play()
    return a
end

local function label(parent, text, size, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size
    l.TextColor3 = color or WHITE
    l.Font = FONT
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function safeClick()
    pcall(function()
        if mouse1click then mouse1click()
        else
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new())
        end
    end)
end

local function openDiscord()
    local url = "https://discord.gg/tfR3hDF6E"
    pcall(function()
        if setclipboard then setclipboard(url) end
    end)
    -- open in system browser (Chrome / default)
    pcall(function()
        GuiService:OpenBrowserWindow(url)
    end)
    pcall(function()
        if typeof(open_url) == "function" then open_url(url) end
    end)
    pcall(function()
        if syn and syn.open_url then syn.open_url(url) end
    end)
end

local outlineStrokes = {}
local themedLabels = {}
local themeSurfaces = {} -- frames: BG / SURFACE / CARD / CARD2
local shadowFrames = {}
local toggleTracks = {} -- {tg=, kn=, getOn=} for live refresh
local Buttons = {}      -- filled later in NAV section

local function registerOutline(s)
    table.insert(outlineStrokes, s)
end
local function registerText(l)
    table.insert(themedLabels, l)
end
local function registerSurface(f, kind)
    table.insert(themeSurfaces, {obj = f, kind = kind or "CARD"})
end

local function applyOutlineColor(col)
    Theme.Outline = col
    Theme.Accent = col
    for _, s in ipairs(outlineStrokes) do
        if s and s.Parent then s.Color = col end
    end
end

local function applyTextColor(col)
    Theme.Text = col
    for _, l in ipairs(themedLabels) do
        if l and l.Parent and l:GetAttribute("ThemeText") then
            l.TextColor3 = col
        end
    end
end

local function snapshotConfig()
    return {
        SilentAim_Enabled = _G.SilentAim_Enabled,
        FOV_RADIUS = _G.FOV_RADIUS,
        ShowFOV = _G.ShowFOV,
        RevolverBypass = _G.RevolverBypass,
        WallCheck = _G.WallCheck,
        Knock_Check = _G.Knock_Check,
        ESP_Boxes = _G.ESP_Boxes,
        ESP_Names = _G.ESP_Names,
        ESP_Health = _G.ESP_Health,
        Speed_ToggleEnabled = _G.Speed_ToggleEnabled,
        Speed_Enabled = _G.Speed_Enabled,
        Speed_Value = _G.Speed_Value,
        Jump_Enabled = _G.Jump_Enabled,
        Jump_Value = _G.Jump_Value,
        CamLock_Enabled = _G.CamLock_Enabled,
        CamLock_Smoothness = _G.CamLock_Smoothness,
        TriggerBot = TriggerBot.MasterEnabled,
    }
end

local function loadConfig(data)
    if not data then return end
    _G.SilentAim_Enabled = data.SilentAim_Enabled or false
    _G.FOV_RADIUS = data.FOV_RADIUS or 0
    _G.ShowFOV = data.ShowFOV or false
    _G.RevolverBypass = data.RevolverBypass or false
    _G.WallCheck = data.WallCheck or false
    _G.Knock_Check = data.Knock_Check or false
    _G.ESP_Boxes = data.ESP_Boxes or false
    _G.ESP_Names = data.ESP_Names or false
    _G.ESP_Health = data.ESP_Health or false
    _G.Speed_ToggleEnabled = data.Speed_ToggleEnabled or false
    _G.Speed_Enabled = data.Speed_Enabled or false
    _G.Speed_Value = data.Speed_Value or 50
    _G.Jump_Enabled = data.Jump_Enabled or false
    _G.Jump_Value = data.Jump_Value or 50
    _G.CamLock_Enabled = data.CamLock_Enabled or false
    _G.CamLock_Smoothness = data.CamLock_Smoothness or 0.25
    TriggerBot.MasterEnabled = data.TriggerBot or false

    local map = {
        SilentAim = _G.SilentAim_Enabled,
        ShowFOV = _G.ShowFOV,
        RevolverBypass = _G.RevolverBypass,
        WallCheck = _G.WallCheck,
        Knock_Check = _G.Knock_Check,
        ESP_Boxes = _G.ESP_Boxes,
        ESP_Names = _G.ESP_Names,
        ESP_Health = _G.ESP_Health,
        Speed_Toggle = _G.Speed_ToggleEnabled,
        Jump_Enabled = _G.Jump_Enabled,
        CamLock = _G.CamLock_Enabled,
        TriggerBot = TriggerBot.MasterEnabled,
    }
    for k, v in pairs(map) do
        if ToggleUI[k] then ToggleUI[k](v) end
    end
    if SliderUI.FOV then SliderUI.FOV(_G.FOV_RADIUS) end
    if SliderUI.Speed then SliderUI.Speed(_G.Speed_Value) end
    if SliderUI.Jump then SliderUI.Jump(_G.Jump_Value) end
    if SliderUI.CamSmooth then SliderUI.CamSmooth(_G.CamLock_Smoothness) end
end

--==================================================
-- GUI  (built FIRST so UI always shows even if aim hooks fail)
--==================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "MELODY_EXE"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(Gui) end
end)
pcall(function()
    if gethui then
        Gui.Parent = gethui()
    end
end)
if not Gui.Parent then
    pcall(function() Gui.Parent = game:GetService("CoreGui") end)
end
if not Gui.Parent then
    Gui.Parent = PlayerGui
end

local W, H, sideW = 640, 600, 158

local ShadowHolder = Instance.new("Frame")
ShadowHolder.Size = UDim2.fromOffset(W, H)
ShadowHolder.Position = UDim2.fromScale(0.5, 0.5)
ShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
ShadowHolder.BackgroundTransparency = 1
ShadowHolder.ZIndex = 5
ShadowHolder.Parent = Gui

for i = 1, 3 do
    local sh = Instance.new("Frame")
    sh.Size = UDim2.new(1, 8 + i * 5, 1, 8 + i * 5)
    sh.Position = UDim2.fromOffset(-4 - i * 2, -2 - i * 2)
    sh.BackgroundColor3 = Color3.new(0, 0, 0)
    sh.BackgroundTransparency = 0.55 + i * 0.1
    sh.BorderSizePixel = 0
    sh.ZIndex = 5
    sh.Parent = ShadowHolder
    corner(sh, 20)
    table.insert(shadowFrames, sh)
end

local pinkGlow = Instance.new("Frame")
pinkGlow.Size = UDim2.new(1, 16, 1, 16)
pinkGlow.Position = UDim2.fromOffset(-8, -8)
pinkGlow.BackgroundTransparency = 1
pinkGlow.ZIndex = 6
pinkGlow.Parent = ShadowHolder
corner(pinkGlow, 22)
local pinkStroke = Instance.new("UIStroke")
pinkStroke.Color = Theme.Outline
pinkStroke.Transparency = 0.5
pinkStroke.Thickness = 2
pinkStroke.Parent = pinkGlow
registerOutline(pinkStroke)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W * 0.85, H * 0.85)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = BG
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.ZIndex = 10
Main.Parent = Gui
corner(Main, 16)
local mainStroke = stroke(Main, Theme.Outline, 0.55, 1.2)
registerOutline(mainStroke)
registerSurface(Main, "BG")

local function syncShadow()
    ShadowHolder.Position = Main.Position
    ShadowHolder.Size = Main.Size
end
Main:GetPropertyChangedSignal("Position"):Connect(syncShadow)
Main:GetPropertyChangedSignal("Size"):Connect(syncShadow)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3 = SURFACE
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 20
TopBar.Parent = Main
corner(TopBar, 16)
registerSurface(TopBar, "SURFACE")

local topGradient = Instance.new("UIGradient")
topGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 137, 48)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(112, 64, 156)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 137, 48)),
})
topGradient.Rotation = 0
topGradient.Parent = TopBar
local gradientTween = TweenService:Create(
    topGradient,
    TweenInfo.new(18, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    { Rotation = 360 }
)
gradientTween:Play()

local topFill = Instance.new("Frame")
topFill.Size = UDim2.new(1, 0, 0, 14)
topFill.Position = UDim2.fromOffset(0, 38)
topFill.BackgroundColor3 = SURFACE
topFill.BorderSizePixel = 0
topFill.ZIndex = 20
topFill.Parent = TopBar
registerSurface(topFill, "SURFACE")

-- traffic light dots (top left)
local function makeDot(x, col)
    local d = Instance.new("Frame")
    d.Size = UDim2.fromOffset(10, 10)
    d.Position = UDim2.fromOffset(x, 16)
    d.BackgroundColor3 = col
    d.BorderSizePixel = 0
    d.ZIndex = 25
    d.Parent = TopBar
    corner(d, 10)
    return d
end
makeDot(14, Color3.fromRGB(255, 95, 87))   -- soft red
makeDot(30, Color3.fromRGB(255, 189, 46))  -- soft yellow
makeDot(46, Color3.fromRGB(40, 200, 64))   -- soft green

-- title + discord- boyhunting under it
local title = label(TopBar, "🎃 MELODY ♡", 14, PINKSOFT)
title.Position = UDim2.fromOffset(66, 7)
title.Size = UDim2.fromOffset(210, 20)
title.Font = Enum.Font.GothamBold
title.ZIndex = 25
title:SetAttribute("ThemeText", true)
registerText(title)

local discSub = label(TopBar, "☾  HALLOWEEN EDITION  /  STAY SPOOKY  ☽", 9, MUTE)
discSub.Position = UDim2.fromOffset(66, 27)
discSub.Size = UDim2.fromOffset(250, 14)
discSub.Font = Enum.Font.Code
discSub.ZIndex = 25

-- Dark Mode / Light Mode button (top right)
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.fromOffset(78, 24)
modeBtn.Position = UDim2.new(1, -118, 0, 14)
modeBtn.BackgroundColor3 = CARD
modeBtn.Text = "Dark Mode"
modeBtn.TextColor3 = PINKSOFT
modeBtn.TextSize = 11
modeBtn.Font = Enum.Font.Code
modeBtn.AutoButtonColor = false
modeBtn.ZIndex = 25
modeBtn.Parent = TopBar
corner(modeBtn, 7)
stroke(modeBtn, BORDER, 0.4, 1)
registerSurface(modeBtn, "CARD")

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -36, 0, 13)
closeBtn.BackgroundColor3 = CARD
closeBtn.Text = "⁠₊˚⊹♡"
closeBtn.TextColor3 = MUTE
closeBtn.TextSize = 14
closeBtn.Font = FONT
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 25
closeBtn.Parent = TopBar
corner(closeBtn, 7)
registerSurface(closeBtn, "CARD")
closeBtn.MouseButton1Click:Connect(function()
    tween(Main, 0.22, {Size = UDim2.fromOffset(W * 0.7, H * 0.7), BackgroundTransparency = 1})
    task.wait(0.22)
    if fovCircle then pcall(function() fovCircle:Remove() end) end
    Gui:Destroy()
end)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, sideW, 1, -52)
Sidebar.Position = UDim2.fromOffset(0, 52)
Sidebar.BackgroundColor3 = SURFACE
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 20
Sidebar.Parent = Main
registerSurface(Sidebar, "SURFACE")

local navLabel = label(Sidebar, "────୨ৎ────", 10, Theme.Accent)
navLabel.Position = UDim2.fromOffset(12, 10)
navLabel.Size = UDim2.fromOffset(100, 14)
navLabel.Font = Enum.Font.Code
navLabel.ZIndex = 25
navLabel:SetAttribute("ThemeText", true)
registerText(navLabel)

local Categories = Instance.new("Frame")
Categories.Size = UDim2.new(1, -10, 1, -40)
Categories.Position = UDim2.fromOffset(5, 28)
Categories.BackgroundTransparency = 1
Categories.ZIndex = 25
Categories.Parent = Sidebar

local catLayout = Instance.new("UIListLayout")
catLayout.Padding = UDim.new(0, 4)
catLayout.SortOrder = Enum.SortOrder.LayoutOrder
catLayout.Parent = Categories

-- CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -sideW, 1, -52)
Content.Position = UDim2.fromOffset(sideW, 52)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.ZIndex = 15
Content.Parent = Main

-- bottom left ONLINE
local onlineDot = Instance.new("Frame")
onlineDot.Size = UDim2.fromOffset(7, 7)
onlineDot.Position = UDim2.fromOffset(14, H - 22)
onlineDot.BackgroundColor3 = Theme.Accent
onlineDot.BorderSizePixel = 0
onlineDot.ZIndex = 30
onlineDot.Parent = Main
corner(onlineDot, 10)

local onlineTxt = label(Main, "ִֶָ𓂃 ࣪ ִֶָ🦢་༘࿐", 10, PINKSOFT)
onlineTxt.Position = UDim2.fromOffset(26, H - 28)
onlineTxt.Size = UDim2.fromOffset(60, 16)
onlineTxt.Font = Enum.Font.Code
onlineTxt.ZIndex = 30
onlineTxt:SetAttribute("ThemeText", true)
registerText(onlineTxt)

local watermark = label(Main, ">⩊<", 10, DIM)
watermark.Position = UDim2.new(1, -90, 1, -22)
watermark.Size = UDim2.fromOffset(80, 16)
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Font = Enum.Font.Code
watermark.ZIndex = 30

local toast = label(Main, "", 11, PINKSOFT)
toast.Position = UDim2.new(0.5, -140, 1, -28)
toast.Size = UDim2.fromOffset(280, 18)
toast.TextXAlignment = Enum.TextXAlignment.Center
toast.Font = Enum.Font.Code
toast.ZIndex = 40
toast.TextTransparency = 1

local function showToast(msg)
    toast.Text = msg
    toast.TextTransparency = 0
    task.delay(2.8, function()
        tween(toast, 0.4, {TextTransparency = 1})
    end)
end

-- Dark / Light mode switch
local function applyMode(mode)
    Theme.Mode = mode
    local pal = (mode == "Light") and LIGHT or DARK
    BG, SURFACE, CARD, CARD2, BORDER, WHITE, MUTE, DIM =
        pal.BG, pal.SURFACE, pal.CARD, pal.CARD2, pal.BORDER, pal.WHITE, pal.MUTE, pal.DIM

    -- main + registered surfaces
    Main.BackgroundColor3 = BG
    topGradient.Color = (mode == "Light") and ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 137, 48)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 102)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(112, 64, 156)),
    }) or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 25, 61)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(112, 64, 156)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 25, 61)),
    })
    for _, entry in ipairs(themeSurfaces) do
        local o = entry.obj
        if o and o.Parent then
            if entry.kind == "BG" then
                o.BackgroundColor3 = BG
            elseif entry.kind == "SURFACE" then
                o.BackgroundColor3 = SURFACE
            elseif entry.kind == "CARD2" then
                o.BackgroundColor3 = CARD2
            else
                o.BackgroundColor3 = CARD
            end
        end
    end

    -- soft light shadow vs dark shadow
    for _, sh in ipairs(shadowFrames) do
        if sh and sh.Parent then
            if mode == "Light" then
                sh.BackgroundColor3 = Color3.fromRGB(180, 190, 210)
                sh.BackgroundTransparency = 0.35
            else
                sh.BackgroundColor3 = Color3.new(0, 0, 0)
                sh.BackgroundTransparency = 0.65
            end
        end
    end

    -- nav category buttons
    for _, data in pairs(Buttons) do
        if data.btn and data.btn.Parent then
            local active = data.text and data.text.TextColor3 == Theme.Accent
            -- fallback: check indicator
            local isActive = data.ind and data.ind.BackgroundTransparency < 0.5
            data.btn.BackgroundColor3 = isActive and CARD2 or SURFACE
            if data.text then
                data.text.TextColor3 = isActive and Theme.Accent or MUTE
            end
        end
    end

    -- toggle tracks (off = white/light CARD2, on = accent)
    for _, t in ipairs(toggleTracks) do
        if t.tg and t.tg.Parent then
            local on = t.getOn and t.getOn() or false
            t.tg.BackgroundColor3 = on and Theme.Accent or CARD2
            if t.kn then
                t.kn.BackgroundColor3 = on and BG or MUTE
            end
        end
    end

    -- body / mute text → black (or light) so readable
    if Main then
        for _, d in ipairs(Main:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                if d:GetAttribute("ThemeText") then
                    -- keep accent pink
                elseif d:GetAttribute("KeepColor") then
                    -- fixed colors
                elseif d == modeBtn or d == closeBtn then
                    -- handled below
                else
                    -- default readable body text
                    if d:IsA("TextBox") then
                        d.TextColor3 = WHITE
                        d.PlaceholderColor3 = DIM
                    elseif d.TextColor3 == PINK or d.TextColor3 == PINKSOFT or d.TextColor3 == Theme.Accent then
                        -- leave pink accents
                    elseif string.find(string.lower(d.Text or ""), "status:") or d.Name == "" then
                        d.TextColor3 = MUTE
                    else
                        -- most labels: primary or muted
                        local tc = d.TextColor3
                        -- if it was near-white or near-mute from dark theme, remap
                        d.TextColor3 = (mode == "Light") and Color3.fromRGB(30, 32, 40) or Color3.fromRGB(245, 245, 250)
                    end
                end
            end
        end
    end

    -- skins weapon buttons
    if refreshWeaponButtons then
        pcall(refreshWeaponButtons)
    end

    -- re-apply accent on ThemeText labels
    for _, l in ipairs(themedLabels) do
        if l and l.Parent and l:GetAttribute("ThemeText") then
            l.TextColor3 = Theme.Accent
        end
    end

    modeBtn.Text = (mode == "Dark") and "Dark Mode" or "Light Mode"
    modeBtn.TextColor3 = Theme.Accent
    modeBtn.BackgroundColor3 = CARD
    if closeBtn then closeBtn.BackgroundColor3 = CARD closeBtn.TextColor3 = MUTE end

    -- nav text readable
    for _, data in pairs(Buttons) do
        if data.text and data.text.Parent then
            local isActive = data.ind and data.ind.BackgroundTransparency < 0.5
            data.text.TextColor3 = isActive and Theme.Accent or MUTE
        end
    end

    showToast((mode == "Dark") and "dark mode on" or "light mode on")
end

modeBtn.MouseButton1Click:Connect(function()
    if Theme.Mode == "Dark" then
        applyMode("Light")
    else
        applyMode("Dark")
    end
end)

--==================================================
-- HOME
--==================================================
local Home = Instance.new("ScrollingFrame")
Home.Name = "HOME"
Home.Size = UDim2.fromScale(1, 1)
Home.BackgroundTransparency = 1
Home.BorderSizePixel = 0
Home.ScrollBarThickness = 2
Home.ScrollBarImageColor3 = Theme.Accent
Home.CanvasSize = UDim2.new(0, 0, 0, 0)
Home.AutomaticCanvasSize = Enum.AutomaticSize.Y
Home.ZIndex = 16
Home.Parent = Content

local homePad = Instance.new("UIPadding")
homePad.PaddingTop = UDim.new(0, 14)
homePad.PaddingLeft = UDim.new(0, 14)
homePad.PaddingRight = UDim.new(0, 14)
homePad.PaddingBottom = UDim.new(0, 20)
homePad.Parent = Home

local homeList = Instance.new("UIListLayout")
homeList.Padding = UDim.new(0, 8)
homeList.SortOrder = Enum.SortOrder.LayoutOrder
homeList.Parent = Home

local load1 = label(Home, "Loading melody`♡´..", 13, MUTE)
load1.Size = UDim2.new(1, 0, 0, 18)
load1.Font = Enum.Font.Code
load1.LayoutOrder = 1
load1.ZIndex = 17

local load2 = label(Home, "loading interfaceᲘ𐑼..", 13, MUTE)
load2.Size = UDim2.new(1, 0, 0, 18)
load2.Font = Enum.Font.Code
load2.LayoutOrder = 2
load2.ZIndex = 17
load2.Visible = false

local load3 = label(Home, "ready✓...", 13, Theme.Accent)
load3.Size = UDim2.new(1, 0, 0, 18)
load3.Font = Enum.Font.Code
load3.LayoutOrder = 3
load3.ZIndex = 17
load3.Visible = false
load3:SetAttribute("ThemeText", true)
registerText(load3)

local aboutHolder = Instance.new("Frame")
aboutHolder.Size = UDim2.new(1, 0, 0, 0)
aboutHolder.BackgroundTransparency = 1
aboutHolder.LayoutOrder = 10
aboutHolder.Visible = false
aboutHolder.AutomaticSize = Enum.AutomaticSize.Y
aboutHolder.ZIndex = 17
aboutHolder.Parent = Home

local aboutList = Instance.new("UIListLayout")
aboutList.Padding = UDim.new(0, 8)
aboutList.Parent = aboutHolder

local function makeInfoCard(parent, height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, height)
    card.BackgroundColor3 = CARD
    card.BorderSizePixel = 0
    card.ZIndex = 17
    card.Parent = parent
    corner(card, 12)
    stroke(card, BORDER, 0.4, 1)
    registerSurface(card, "CARD")
    return card
end

local aboutCard = makeInfoCard(aboutHolder, 118)
local aboutCmd = label(aboutCard, "melody main about✗✗", 12, Theme.Accent)
aboutCmd.Position = UDim2.fromOffset(12, 10)
aboutCmd.Size = UDim2.new(1, -24, 0, 16)
aboutCmd.Font = Enum.Font.Code
aboutCmd.ZIndex = 18
aboutCmd:SetAttribute("ThemeText", true)
registerText(aboutCmd)
label(aboutCard, "[name] melody.exe", 11, MUTE).Position = UDim2.fromOffset(12, 32)
label(aboutCard, "[name] melody.exe", 11, MUTE).Size = UDim2.new(1, -24, 0, 14)
-- redo labels properly
for _, c in ipairs(aboutCard:GetChildren()) do if c:IsA("TextLabel") and c ~= aboutCmd then c:Destroy() end end
local function addLine(parent, text, y)
    local l = label(parent, text, 11, MUTE)
    l.Position = UDim2.fromOffset(12, y)
    l.Size = UDim2.new(1, -24, 0, 14)
    l.Font = Enum.Font.Code
    l.ZIndex = 18
    return l
end
addLine(aboutCard, "[name] melody۶ৎ", 32)
addLine(aboutCard, "[developers] Angelsdior≽^• ˕ • ྀི≼", 50)
addLine(aboutCard, "[discord] https://discord.gg/YTdSZX9v6", 68)
addLine(aboutCard, "[status] ready..", 86)

local infoCard = makeInfoCard(aboutHolder, 128)
local infoTitle = label(infoCard, "ִֶָ𓂃 ࣪˖ ִֶָ🐇་༘࿐information", 12, Theme.Accent)
infoTitle.Position = UDim2.fromOffset(12, 10)
infoTitle.Size = UDim2.new(1, -24, 0, 16)
infoTitle.Font = Enum.Font.Code
infoTitle.ZIndex = 18
infoTitle:SetAttribute("ThemeText", true)
registerText(infoTitle)
addLine(infoCard, "[user] :: " .. Player.Name, 34)
addLine(infoCard, "[ui key] :: rightshift", 54)
addLine(infoCard, "[appearance] :: top-right theme switch", 74)
addLine(infoCard, "[modules] :: combat / misc / skins / teleport / and more", 94)

local cmdCard = makeInfoCard(aboutHolder, 128)
local cmdTitle = label(cmdCard, "commands𐔌՞. .՞𐦯", 12, Theme.Accent)
cmdTitle.Position = UDim2.fromOffset(12, 10)
cmdTitle.Size = UDim2.new(1, -24, 0, 16)
cmdTitle.Font = Enum.Font.Code
cmdTitle.ZIndex = 18
cmdTitle:SetAttribute("ThemeText", true)
registerText(cmdTitle)
addLine(cmdCard, "ʚɞ tabs  # open a module from the command bar", 34)
addLine(cmdCard, "ʚɞ rightshift  # hide or reveal this terminal", 54)
addLine(cmdCard, "ʚɞ settings  # customise outline of the UI / texts colour", 74)
addLine(cmdCard, "ʚɞ theme  # switch light/dark from the switch", 94)

task.spawn(function()
    task.wait(0.6)
    load2.Visible = true
    task.wait(1.2)
    load3.Visible = true
    task.wait(1.2)
    task.wait(1)
    load1.Visible = false
    load2.Visible = false
    load3.Visible = false
    aboutHolder.Visible = true
end)

--==================================================
-- PAGE BUILDERS
--==================================================
local Pages = {}

local function createPage(name, titleText, subText)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ZIndex = 16
    page.Parent = Content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 16)
    pad.Parent = page

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = page

    local t = label(page, titleText, 15, Theme.Text)
    t.Size = UDim2.new(1, 0, 0, 20)
    t.Font = Enum.Font.GothamBold
    t.LayoutOrder = 0
    t.ZIndex = 17
    t:SetAttribute("ThemeText", true)
    registerText(t)

    local s = label(page, subText, 11, MUTE)
    s.Size = UDim2.new(1, 0, 0, 14)
    s.Font = Enum.Font.Code
    s.LayoutOrder = 1
    s.ZIndex = 17

    Pages[name] = page
    return page
end

local function createToggle(parent, order, name, desc, get, set, keyText, syncKey)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = CARD
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ZIndex = 17
    card.Parent = parent
    corner(card, 11)
    stroke(card, BORDER, 0.45, 1)
    registerSurface(card, "CARD")

    local titleL = label(card, name, 12, Theme.Text)
    titleL.Position = UDim2.fromOffset(12, 8)
    titleL.Size = UDim2.new(1, -58, 0, 16)
    titleL.ZIndex = 18
    titleL:SetAttribute("ThemeText", true)
    registerText(titleL)

    local subL = label(card, desc, 10, MUTE)
    subL.Position = UDim2.fromOffset(12, 24)
    subL.Size = UDim2.new(1, -58, 0, 12)
    subL.ZIndex = 18

    if keyText then
        local k = label(card, keyText, 9, DIM)
        k.Position = UDim2.fromOffset(12, 36)
        k.Size = UDim2.new(1, -58, 0, 12)
        k.Font = Enum.Font.Code
        k.ZIndex = 18
    end

    local on = get and get() or false
    local tg = Instance.new("Frame")
    tg.Size = UDim2.fromOffset(36, 20)
    tg.Position = UDim2.new(1, -48, 0.5, -10)
    tg.BackgroundColor3 = on and Theme.Accent or CARD2
    tg.BorderSizePixel = 0
    tg.ZIndex = 18
    tg.Parent = card
    corner(tg, 10)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.fromOffset(14, 14)
    kn.Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3)
    kn.BackgroundColor3 = on and BG or MUTE
    kn.BorderSizePixel = 0
    kn.ZIndex = 19
    kn.Parent = tg
    corner(kn, 8)

    local function setVisual(state)
        on = state
        if state then
            tg.BackgroundColor3 = Theme.Accent
            kn.Position = UDim2.new(1, -17, 0.5, -7)
            kn.BackgroundColor3 = BG
        else
            tg.BackgroundColor3 = CARD2
            kn.Position = UDim2.fromOffset(3, 3)
            kn.BackgroundColor3 = MUTE
        end
    end
    if syncKey then ToggleUI[syncKey] = setVisual end
    table.insert(toggleTracks, { tg = tg, kn = kn, getOn = function() return on end })

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.fromScale(1, 1)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 20
    hit.Parent = tg
    hit.MouseButton1Click:Connect(function()
        on = not on
        if set then set(on) end
        setVisual(on)
    end)
end

local function createSlider(parent, order, name, minV, maxV, get, set, syncKey, isFloat)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 62)
    card.BackgroundColor3 = CARD
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ZIndex = 17
    card.Parent = parent
    corner(card, 11)
    stroke(card, BORDER, 0.45, 1)
    registerSurface(card, "CARD")

    local titleL = label(card, name, 11, MUTE)
    titleL.Position = UDim2.fromOffset(12, 6)
    titleL.Size = UDim2.new(1, -24, 0, 14)
    titleL.Font = Enum.Font.Code
    titleL.ZIndex = 18

    local cur = get()
    local valL = label(card, isFloat and string.format("%.2f", cur) or tostring(cur), 12, Theme.Accent)
    valL.Position = UDim2.fromOffset(12, 22)
    valL.Size = UDim2.new(1, -24, 0, 14)
    valL.ZIndex = 18
    valL:SetAttribute("ThemeText", true)
    registerText(valL)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 5)
    track.Position = UDim2.fromOffset(12, 42)
    track.BackgroundColor3 = CARD2
    track.BorderSizePixel = 0
    track.ZIndex = 18
    track.Parent = card
    corner(track, 4)
    registerSurface(track, "CARD2")

    local pct = math.clamp((cur - minV) / (maxV - minV), 0, 1)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 18
    fill.Parent = track
    corner(fill, 4)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.fromOffset(13, 13)
    knob.Position = UDim2.new(pct, 0, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.ZIndex = 19
    knob.Parent = track
    corner(knob, 8)

    local function setVisual(v)
        local p = math.clamp((v - minV) / (maxV - minV), 0, 1)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        valL.Text = isFloat and string.format("%.2f", v) or tostring(v)
        fill.BackgroundColor3 = Theme.Accent
    end
    if syncKey then SliderUI[syncKey] = setVisual end

    local sliding = false
    local function update(input)
        local abs = track.AbsoluteSize.X
        if abs < 1 then return end
        local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / abs, 0, 1)
        local v = minV + p * (maxV - minV)
        if not isFloat then v = math.floor(v + 0.5)
        else v = math.floor(v * 100 + 0.5) / 100 end
        setVisual(v)
        set(v)
    end

    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true end
    end)
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true update(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end
    end)
end

local function createColorRow(parent, order, title, colors, set)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 46)
    card.BackgroundColor3 = CARD
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ZIndex = 17
    card.Parent = parent
    corner(card, 11)
    stroke(card, BORDER, 0.45, 1)
    registerSurface(card, "CARD")

    local t = label(card, title, 10, MUTE)
    t.Position = UDim2.fromOffset(12, 4)
    t.Size = UDim2.new(1, -24, 0, 12)
    t.ZIndex = 18

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 16)
    row.Position = UDim2.fromOffset(12, 22)
    row.BackgroundTransparency = 1
    row.ZIndex = 18
    row.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 4)
    layout.Parent = row

    for _, col in ipairs(colors) do
        local box = Instance.new("TextButton")
        box.Size = UDim2.fromOffset(16, 16)
        box.BackgroundColor3 = col
        box.Text = ""
        box.AutoButtonColor = false
        box.ZIndex = 19
        box.Parent = row
        corner(box, 4)
        stroke(box, Color3.fromRGB(255,255,255), 0.7, 1)
        box.MouseButton1Click:Connect(function() set(col) end)
    end
end

-- pages
local combatPage = createPage("COMBAT", "݁ ˖Ი𐑼⋆ combat", "aim & combat tools")
createToggle(combatPage, 2, "Silent Aim", "improves shot accuracy", function() return _G.SilentAim_Enabled end, function(v) _G.SilentAim_Enabled = v end, nil, "SilentAim")
createSlider(combatPage, 3, "FOV Radius", 0, 1000, function() return _G.FOV_RADIUS end, function(v) _G.FOV_RADIUS = v end, "FOV")
createToggle(combatPage, 4, "Show FOV", "circle on screen", function() return _G.ShowFOV end, function(v) _G.ShowFOV = v end, nil, "ShowFOV")
createColorRow(combatPage, 5, "FOV Color", FOV_COLORS, function(c) _G.FOV_Color = c end)
createToggle(combatPage, 6, "Revolver Bypass", "skip silent on revolver", function() return _G.RevolverBypass end, function(v) _G.RevolverBypass = v end, nil, "RevolverBypass")
createToggle(combatPage, 7, "Wall Check", "only aim in open space", function() return _G.WallCheck end, function(v) _G.WallCheck = v end, nil, "WallCheck")
createToggle(combatPage, 8, "Knock Check", "ignore knocked players", function() return _G.Knock_Check end, function(v) _G.Knock_Check = v end, nil, "Knock_Check")
createToggle(combatPage, 9, "TriggerBot", "auto click on target", function() return TriggerBot.MasterEnabled end, function(v) TriggerBot.MasterEnabled = v if not v then TriggerBot.Active = false end end, "key: T", "TriggerBot")

local visualsPage = createPage("VISUALS", "˖Ი𐑼⋆ visuals", "esp & overlays")
createToggle(visualsPage, 2, "ESP Boxes", "boxes through walls", function() return _G.ESP_Boxes end, function(v) _G.ESP_Boxes = v end, nil, "ESP_Boxes")
createToggle(visualsPage, 3, "ESP Names", "show display names", function() return _G.ESP_Names end, function(v) _G.ESP_Names = v end, nil, "ESP_Names")
createToggle(visualsPage, 4, "ESP Health", "health bar next to player", function() return _G.ESP_Health end, function(v) _G.ESP_Health = v end, nil, "ESP_Health")
createColorRow(visualsPage, 5, "ESP Color", ESP_COLORS, function(c) _G.ESP_Color = c end)

-- CAMLOCK: no flamelock, smoothness slider
local camlockPage = createPage("CAMLOCK", "˖Ი𐑼⋆ camlock", "camera assist")
createToggle(camlockPage, 2, "Camlock", "sticky camera lock", function() return _G.CamLock_Enabled end, function(v) _G.CamLock_Enabled = v if not v then camLockActive = false end end, nil, "CamLock")

local smoothLabel = label(camlockPage, "˖Ი𐑼⋆ smoothness :: " .. string.format("%.2f", _G.CamLock_Smoothness), 12, Theme.Accent)
smoothLabel.Size = UDim2.new(1, 0, 0, 16)
smoothLabel.Font = Enum.Font.Code
smoothLabel.LayoutOrder = 3
smoothLabel.ZIndex = 17
smoothLabel:SetAttribute("ThemeText", true)
registerText(smoothLabel)

createSlider(camlockPage, 4, "Smoothness", 0.01, 10, function() return _G.CamLock_Smoothness end, function(v)
    _G.CamLock_Smoothness = v
    smoothLabel.Text = "$ smoothness :: " .. string.format("%.2f", v)
end, "CamSmooth", true)

-- keybind row
local bindRow = Instance.new("Frame")
bindRow.Size = UDim2.new(1, 0, 0, 36)
bindRow.BackgroundColor3 = CARD
bindRow.BorderSizePixel = 0
bindRow.LayoutOrder = 5
bindRow.ZIndex = 17
bindRow.Parent = camlockPage
corner(bindRow, 10)
stroke(bindRow, BORDER, 0.45, 1)
registerSurface(bindRow, "CARD")

local bindLbl = label(bindRow, "keybind:", 12, MUTE)
bindLbl.Position = UDim2.fromOffset(12, 0)
bindLbl.Size = UDim2.new(0, 70, 1, 0)
bindLbl.Font = Enum.Font.Code
bindLbl.ZIndex = 18

local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.fromOffset(90, 26)
bindBtn.Position = UDim2.new(1, -102, 0.5, -13)
bindBtn.BackgroundColor3 = CARD2
bindBtn.Text = _G.CamLock_Key.Name
bindBtn.TextColor3 = Theme.Accent
bindBtn.TextSize = 12
bindBtn.Font = Enum.Font.Code
bindBtn.AutoButtonColor = false
bindBtn.ZIndex = 18
bindBtn.Parent = bindRow
corner(bindBtn, 7)
stroke(bindBtn, BORDER, 0.4, 1)
registerSurface(bindBtn, "CARD2")

local listeningBind = false
bindBtn.MouseButton1Click:Connect(function()
    if listeningBind then return end
    listeningBind = true
    bindBtn.Text = "..."
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        _G.CamLock_Key = input.KeyCode
        bindBtn.Text = input.KeyCode.Name
        listeningBind = false
        showToast("camlock bind → " .. input.KeyCode.Name)
        if conn then conn:Disconnect() end
    end)
end)

local miscPage = createPage("MISC", "˖Ი𐑼⋆ misc", "movement & tools")
createToggle(miscPage, 2, "Speed Hack", "faster walk speed", function() return _G.Speed_ToggleEnabled end, function(v) _G.Speed_ToggleEnabled = v if not v then _G.Speed_Enabled = false end end, "key: X", "Speed_Toggle")
createSlider(miscPage, 3, "Speed Value", 50, 1000, function() return _G.Speed_Value end, function(v) _G.Speed_Value = v end, "Speed")
createToggle(miscPage, 4, "Jump Power", "higher jumps", function() return _G.Jump_Enabled end, function(v) _G.Jump_Enabled = v end, "key: C", "Jump_Enabled")
createSlider(miscPage, 5, "Jump Value", 50, 1000, function() return _G.Jump_Value end, function(v) _G.Jump_Value = v end, "Jump")

local teleportPage = createPage("TELEPORT", "˖Ი𐑼⋆ teleport", "shop / map locations")
for i, loc in ipairs(SHOP_TPS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = CARD
    btn.Text = loc.name
    btn.TextColor3 = PINKSOFT
    btn.TextSize = 12
    btn.Font = Enum.Font.Code
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = i + 1
    btn.ZIndex = 17
    btn.Parent = teleportPage
    corner(btn, 9)
    stroke(btn, BORDER, 0.4, 1)
    registerSurface(btn, "CARD")
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn
    btn.MouseButton1Click:Connect(function() teleportToPos(loc.pos) end)
end

-- SKINS
local skinsPage = createPage("SKINS", "˖Ი𐑼⋆ skin changer", "select one gun, enter skin name")
local WEAPON_LIST = {
    { label = "Double-Barrel-SG", tool = "[Double-Barrel SG]" },
    { label = "Tactical-Shotgun", tool = "[TacticalShotgun]" },
    { label = "Knife", tool = "[Knife]" },
    { label = "Shotgun", tool = "[Shotgun]" },
    { label = "Double-Barrel", tool = "[Double-Barrel SG]" },
    { label = "Revolver", tool = "[Revolver]" },
}
local selectedWeapon, weaponButtons = nil, {}
local warnLabel = label(skinsPage, "", 10, Color3.fromRGB(255, 120, 140))
warnLabel.Size = UDim2.new(1, 0, 0, 14)
warnLabel.LayoutOrder = 50
warnLabel.ZIndex = 17

refreshWeaponButtons = function()
    for key, btn in pairs(weaponButtons) do
        if selectedWeapon == key then
            btn.BackgroundColor3 = Theme.Accent
            btn.TextColor3 = Color3.fromRGB(20, 20, 25)
        else
            btn.BackgroundColor3 = CARD2
            btn.TextColor3 = WHITE
        end
    end
end

for i, info in ipairs(WEAPON_LIST) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = CARD2
    btn.Text = "$ " .. info.label
    btn.TextColor3 = WHITE
    btn.TextSize = 12
    btn.Font = Enum.Font.Code
    btn.AutoButtonColor = false
    btn.LayoutOrder = i + 1
    btn.ZIndex = 17
    btn.Parent = skinsPage
    corner(btn, 8)
    stroke(btn, BORDER, 0.5, 1)
    registerSurface(btn, "CARD2")
    weaponButtons[info.label] = btn
    btn.MouseButton1Click:Connect(function()
        if selectedWeapon == info.label then
            selectedWeapon = nil
            warnLabel.Text = ""
            refreshWeaponButtons()
            return
        end
        if selectedWeapon and selectedWeapon ~= info.label then
            warnLabel.Text = "please choose 1 at a time (unselect the chosen gun)"
            return
        end
        selectedWeapon = info.label
        warnLabel.Text = ""
        refreshWeaponButtons()
    end)
end

local function getSelectedToolName()
    if not selectedWeapon then return nil end
    for _, info in ipairs(WEAPON_LIST) do
        if info.label == selectedWeapon then return info.tool end
    end
end

local skinInput = Instance.new("TextBox")
skinInput.Size = UDim2.new(1, 0, 0, 32)
skinInput.BackgroundColor3 = CARD2
skinInput.PlaceholderText = "Enter skin name..."
skinInput.Text = ""
skinInput.TextColor3 = WHITE
skinInput.PlaceholderColor3 = DIM
skinInput.Font = FONT
skinInput.TextSize = 12
skinInput.ClearTextOnFocus = false
skinInput.LayoutOrder = 20
skinInput.ZIndex = 17
skinInput.Parent = skinsPage
corner(skinInput, 8)
stroke(skinInput, BORDER, 0.5, 1)
registerSurface(skinInput, "CARD2")

local applySkinBtn = Instance.new("TextButton")
applySkinBtn.Size = UDim2.new(1, 0, 0, 32)
applySkinBtn.BackgroundColor3 = Theme.Accent
applySkinBtn.Text = "Apply"
applySkinBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
applySkinBtn.TextSize = 12
applySkinBtn.Font = Enum.Font.GothamBold
applySkinBtn.AutoButtonColor = false
applySkinBtn.LayoutOrder = 21
applySkinBtn.ZIndex = 17
applySkinBtn.Parent = skinsPage
corner(applySkinBtn, 8)

local skinStatus = label(skinsPage, "Status: select a gun first", 10, MUTE)
skinStatus.Size = UDim2.new(1, 0, 0, 14)
skinStatus.LayoutOrder = 22
skinStatus.ZIndex = 17

applySkinBtn.MouseButton1Click:Connect(function()
    local toolName = getSelectedToolName()
    if not toolName then skinStatus.Text = "Status: select a gun first" return end
    local skinName = skinInput.Text:match("^%s*(.-)%s*$")
    if not skinName or skinName == "" then skinStatus.Text = "Status: enter a skin name" return end
    cfg.skins.weapons[toolName] = skinName
    local tool = me.Character and me.Character:FindFirstChild(toolName)
    if tool and tool:IsA("Tool") then
        local ok = (toolName == "[Knife]") and applyknife(me.Character, tool, skinName) or applygun(tool, skinName)
        skinStatus.Text = ok and ("Status: applied " .. skinName) or "Status: skin not found / failed"
    else
        skinStatus.Text = "Status: equip the gun, then Apply"
    end
end)

-- CONFIGS
local configsPage = createPage("CONFIGS", "$ configs", "save & load your setups (max 5)")

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, 0, 0, 34)
nameBox.BackgroundColor3 = CARD2
nameBox.PlaceholderText = "Save config name..."
nameBox.Text = ""
nameBox.TextColor3 = WHITE
nameBox.PlaceholderColor3 = DIM
nameBox.Font = Enum.Font.Code
nameBox.TextSize = 12
nameBox.ClearTextOnFocus = false
nameBox.LayoutOrder = 2
nameBox.ZIndex = 17
nameBox.Parent = configsPage
corner(nameBox, 9)
stroke(nameBox, BORDER, 0.45, 1)
registerSurface(nameBox, "CARD2")

local cfgRow = Instance.new("Frame")
cfgRow.Size = UDim2.new(1, 0, 0, 34)
cfgRow.BackgroundTransparency = 1
cfgRow.LayoutOrder = 3
cfgRow.ZIndex = 17
cfgRow.Parent = configsPage

local saveCfgBtn = Instance.new("TextButton")
saveCfgBtn.Size = UDim2.new(0.48, 0, 1, 0)
saveCfgBtn.BackgroundColor3 = Theme.Accent
saveCfgBtn.Text = "Save CFG"
saveCfgBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
saveCfgBtn.TextSize = 12
saveCfgBtn.Font = Enum.Font.GothamBold
saveCfgBtn.AutoButtonColor = false
saveCfgBtn.ZIndex = 18
saveCfgBtn.Parent = cfgRow
corner(saveCfgBtn, 9)

local openCfgBtn = Instance.new("TextButton")
openCfgBtn.Size = UDim2.new(0.48, 0, 1, 0)
openCfgBtn.Position = UDim2.new(0.52, 0, 0, 0)
openCfgBtn.BackgroundColor3 = CARD2
openCfgBtn.Text = "Open CFGS"
openCfgBtn.TextColor3 = PINKSOFT
openCfgBtn.TextSize = 12
openCfgBtn.Font = Enum.Font.GothamBold
openCfgBtn.AutoButtonColor = false
openCfgBtn.ZIndex = 18
openCfgBtn.Parent = cfgRow
corner(openCfgBtn, 9)
stroke(openCfgBtn, BORDER, 0.4, 1)
registerSurface(openCfgBtn, "CARD2")

local cfgList = Instance.new("ScrollingFrame")
cfgList.Size = UDim2.new(1, 0, 0, 0)
cfgList.BackgroundTransparency = 1
cfgList.BorderSizePixel = 0
cfgList.ScrollBarThickness = 2
cfgList.Visible = false
cfgList.LayoutOrder = 4
cfgList.ZIndex = 17
cfgList.Parent = configsPage
cfgList.CanvasSize = UDim2.new(0, 0, 0, 0)
cfgList.AutomaticCanvasSize = Enum.AutomaticSize.Y

local cfgListLayout = Instance.new("UIListLayout")
cfgListLayout.Padding = UDim.new(0, 5)
cfgListLayout.Parent = cfgList

local function rebuildCfgList()
    for _, c in ipairs(cfgList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local n = 0
    for i, entry in ipairs(_G.SaturnConfigs) do
        n = n + 1
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = CARD
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.ZIndex = 18
        row.Parent = cfgList
        corner(row, 9)
        stroke(row, BORDER, 0.45, 1)

        local nm = label(row, entry.name, 12, WHITE)
        nm.Position = UDim2.fromOffset(12, 0)
        nm.Size = UDim2.new(1, -110, 1, 0)
        nm.Font = Enum.Font.Code
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 19

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.fromOffset(90, 26)
        loadBtn.Position = UDim2.new(1, -100, 0.5, -13)
        loadBtn.BackgroundColor3 = Theme.Accent
        loadBtn.Text = "Load Config"
        loadBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        loadBtn.TextSize = 11
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.AutoButtonColor = false
        loadBtn.ZIndex = 19
        loadBtn.Parent = row
        corner(loadBtn, 7)

        loadBtn.MouseButton1Click:Connect(function()
            loadConfig(entry.data)
            showToast("config '" .. entry.name .. "' loaded !")
        end)
    end
    cfgList.Size = UDim2.new(1, 0, 0, math.min(n * 41, 180))
end

saveCfgBtn.MouseButton1Click:Connect(function()
    local name = nameBox.Text:match("^%s*(.-)%s*$")
    if not name or name == "" then
        showToast("enter a config name first")
        return
    end
    if #_G.SaturnConfigs >= 5 then
        showToast("config limit reached (max 5)")
        return
    end
    for i, e in ipairs(_G.SaturnConfigs) do
        if e.name == name then table.remove(_G.SaturnConfigs, i) break end
    end
    table.insert(_G.SaturnConfigs, { name = name, data = snapshotConfig() })
    showToast("config '" .. name .. "' has been saved to ur configs !")
    nameBox.Text = ""
    if cfgList.Visible then rebuildCfgList() end
end)

local cfgsOpen = false
openCfgBtn.MouseButton1Click:Connect(function()
    cfgsOpen = not cfgsOpen
    if cfgsOpen then
        rebuildCfgList()
        cfgList.Visible = true
        openCfgBtn.Text = "Close CFGS"
    else
        cfgList.Visible = false
        cfgList.Size = UDim2.new(1, 0, 0, 0)
        openCfgBtn.Text = "Open CFGS"
    end
end)

--==================================================
-- SETTINGS (color boxes LEFT-aligned under text)
--==================================================
local settingsPage = createPage("SETTINGS", "$ settings", "customise outline & text colours")

local setCard1 = Instance.new("Frame")
setCard1.Size = UDim2.new(1, 0, 0, 168)
setCard1.BackgroundColor3 = CARD
setCard1.BorderSizePixel = 0
setCard1.LayoutOrder = 2
setCard1.ZIndex = 17
setCard1.Parent = settingsPage
corner(setCard1, 12)
stroke(setCard1, BORDER, 0.4, 1)
registerSurface(setCard1, "CARD")

local setTitle1 = label(setCard1, "Change UI Outline / Colour Texts", 12, Theme.Accent)
setTitle1.Position = UDim2.fromOffset(12, 10)
setTitle1.Size = UDim2.new(1, -24, 0, 16)
setTitle1.Font = Enum.Font.Code
setTitle1.ZIndex = 18
setTitle1:SetAttribute("ThemeText", true)
registerText(setTitle1)

-- outline: text then boxes BELOW on the LEFT
local outlineTxt = label(setCard1, "$ Change UI Outline  # Changes UI Outline", 10, MUTE)
outlineTxt.Position = UDim2.fromOffset(12, 34)
outlineTxt.Size = UDim2.new(1, -24, 0, 14)
outlineTxt.Font = Enum.Font.Code
outlineTxt.ZIndex = 18

local outlineWheel = Instance.new("Frame")
outlineWheel.Size = UDim2.new(1, -24, 0, 22)
outlineWheel.Position = UDim2.fromOffset(12, 52)
outlineWheel.BackgroundColor3 = CARD2
outlineWheel.BorderSizePixel = 0
outlineWheel.ZIndex = 18
outlineWheel.Parent = setCard1
corner(outlineWheel, 6)
registerSurface(outlineWheel, "CARD2")

local owLayout = Instance.new("UIListLayout")
owLayout.FillDirection = Enum.FillDirection.Horizontal
owLayout.Padding = UDim.new(0, 4)
owLayout.VerticalAlignment = Enum.VerticalAlignment.Center
owLayout.Parent = outlineWheel

local owPad = Instance.new("UIPadding")
owPad.PaddingLeft = UDim.new(0, 6)
owPad.Parent = outlineWheel

for _, col in ipairs(PICKER_COLORS) do
    local box = Instance.new("TextButton")
    box.Size = UDim2.fromOffset(14, 14)
    box.BackgroundColor3 = col
    box.Text = ""
    box.AutoButtonColor = false
    box.ZIndex = 19
    box.Parent = outlineWheel
    corner(box, 3)
    box.MouseButton1Click:Connect(function()
        applyOutlineColor(col)
        onlineDot.BackgroundColor3 = col
        showToast("ui outline colour updated")
    end)
end

-- text colour: text then boxes BELOW on the LEFT
local textTxt = label(setCard1, "$ Change Texts Colour  # Changes The Colour Of The Texts", 10, MUTE)
textTxt.Position = UDim2.fromOffset(12, 84)
textTxt.Size = UDim2.new(1, -24, 0, 14)
textTxt.Font = Enum.Font.Code
textTxt.ZIndex = 18

local textWheel = Instance.new("Frame")
textWheel.Size = UDim2.new(1, -24, 0, 22)
textWheel.Position = UDim2.fromOffset(12, 102)
textWheel.BackgroundColor3 = CARD2
textWheel.BorderSizePixel = 0
textWheel.ZIndex = 18
textWheel.Parent = setCard1
corner(textWheel, 6)
registerSurface(textWheel, "CARD2")

local twLayout = Instance.new("UIListLayout")
twLayout.FillDirection = Enum.FillDirection.Horizontal
twLayout.Padding = UDim.new(0, 4)
twLayout.VerticalAlignment = Enum.VerticalAlignment.Center
twLayout.Parent = textWheel

local twPad = Instance.new("UIPadding")
twPad.PaddingLeft = UDim.new(0, 6)
twPad.Parent = textWheel

for _, col in ipairs(PICKER_COLORS) do
    local box = Instance.new("TextButton")
    box.Size = UDim2.fromOffset(14, 14)
    box.BackgroundColor3 = col
    box.Text = ""
    box.AutoButtonColor = false
    box.ZIndex = 19
    box.Parent = textWheel
    corner(box, 3)
    box.MouseButton1Click:Connect(function()
        applyTextColor(col)
        showToast("text colour updated")
    end)
end

-- Help & Support
local setCard2 = Instance.new("Frame")
setCard2.Size = UDim2.new(1, 0, 0, 70)
setCard2.BackgroundColor3 = CARD
setCard2.BorderSizePixel = 0
setCard2.LayoutOrder = 3
setCard2.ZIndex = 17
setCard2.Parent = settingsPage
corner(setCard2, 12)
stroke(setCard2, BORDER, 0.4, 1)
registerSurface(setCard2, "CARD")

local setTitle2 = label(setCard2, "// Help & Support V", 12, Theme.Accent)
setTitle2.Position = UDim2.fromOffset(12, 10)
setTitle2.Size = UDim2.new(1, -24, 0, 16)
setTitle2.Font = Enum.Font.Code
setTitle2.ZIndex = 18
setTitle2:SetAttribute("ThemeText", true)
registerText(setTitle2)

local discBtn = Instance.new("TextButton")
discBtn.Size = UDim2.new(1, -24, 0, 28)
discBtn.Position = UDim2.fromOffset(12, 32)
discBtn.BackgroundTransparency = 1
discBtn.Text = "$ Join Discord Server For More →"
discBtn.TextColor3 = MUTE
discBtn.TextSize = 11
discBtn.Font = Enum.Font.Code
discBtn.TextXAlignment = Enum.TextXAlignment.Left
discBtn.AutoButtonColor = false
discBtn.ZIndex = 18
discBtn.Parent = setCard2

discBtn.MouseEnter:Connect(function() discBtn.TextColor3 = Theme.Accent end)
discBtn.MouseLeave:Connect(function() discBtn.TextColor3 = MUTE end)
discBtn.MouseButton1Click:Connect(function()
    openDiscord()
    showToast("opening discord in browser...")
end)

--==================================================
-- WHITELIST
--==================================================
local whitelistPage = createPage("WHITELIST", "$ whitelist", "")

local wlHeader = label(whitelistPage, "// whitelist", 12, Theme.Accent)
wlHeader.Size = UDim2.new(1, 0, 0, 18)
wlHeader.Font = Enum.Font.Code
wlHeader.LayoutOrder = 2
wlHeader.ZIndex = 17
wlHeader:SetAttribute("ThemeText", true)
registerText(wlHeader)

local wlList = Instance.new("Frame")
wlList.Size = UDim2.new(1, 0, 0, 0)
wlList.BackgroundTransparency = 1
wlList.AutomaticSize = Enum.AutomaticSize.Y
wlList.LayoutOrder = 3
wlList.ZIndex = 17
wlList.Parent = whitelistPage

local wlLayout = Instance.new("UIListLayout")
wlLayout.Padding = UDim.new(0, 6)
wlLayout.SortOrder = Enum.SortOrder.LayoutOrder
wlLayout.Parent = wlList

local function makeWhitelistRow(plr, order)
    if plr == me then return end
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = CARD
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 18
    row.Parent = wlList
    corner(row, 10)
    stroke(row, BORDER, 0.45, 1)
    registerSurface(row, "CARD")
    row:SetAttribute("UserId", plr.UserId)

    local disp = label(row, plr.DisplayName, 12, MUTE)
    disp.Position = UDim2.fromOffset(12, 6)
    disp.Size = UDim2.new(1, -60, 0, 16)
    disp.Font = Enum.Font.Gotham
    disp.TextTruncate = Enum.TextTruncate.AtEnd
    disp.ZIndex = 19

    local uname = label(row, "@" .. plr.Name, 10, DIM)
    uname.Position = UDim2.fromOffset(12, 24)
    uname.Size = UDim2.new(1, -60, 0, 14)
    uname.Font = Enum.Font.Code
    uname.TextTruncate = Enum.TextTruncate.AtEnd
    uname.ZIndex = 19

    local on = isWhitelisted(plr)
    local tg = Instance.new("Frame")
    tg.Size = UDim2.fromOffset(36, 20)
    tg.Position = UDim2.new(1, -48, 0.5, -10)
    tg.BackgroundColor3 = on and Theme.Accent or CARD2
    tg.BorderSizePixel = 0
    tg.ZIndex = 19
    tg.Parent = row
    corner(tg, 10)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.fromOffset(14, 14)
    kn.Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.fromOffset(3, 3)
    kn.BackgroundColor3 = on and BG or MUTE
    kn.BorderSizePixel = 0
    kn.ZIndex = 20
    kn.Parent = tg
    corner(kn, 8)

    local function setVisual(state)
        on = state
        if state then
            tg.BackgroundColor3 = Theme.Accent
            kn.Position = UDim2.new(1, -17, 0.5, -7)
            kn.BackgroundColor3 = BG
        else
            tg.BackgroundColor3 = CARD2
            kn.Position = UDim2.fromOffset(3, 3)
            kn.BackgroundColor3 = MUTE
        end
    end

    table.insert(toggleTracks, { tg = tg, kn = kn, getOn = function() return on end })

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.fromScale(1, 1)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 21
    hit.Parent = tg
    hit.MouseButton1Click:Connect(function()
        on = not on
        setWhitelisted(plr, on)
        setVisual(on)
        showToast(on and ("whitelisted " .. plr.DisplayName) or ("removed " .. plr.DisplayName))
    end)
end

local function rebuildWhitelist()
    for _, c in ipairs(wlList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local order = 1
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= me then
            makeWhitelistRow(plr, order)
            order = order + 1
        end
    end
end

rebuildWhitelist()
Players.PlayerAdded:Connect(function()
    task.wait(0.3)
    rebuildWhitelist()
end)
Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    rebuildWhitelist()
end)

--==================================================
-- NAV
--==================================================
local CategoryNames = {
    { id = "HOME",      label = "♡ home" },
    { id = "COMBAT",    label = "♡ combat" },
    { id = "VISUALS",   label = "♡ visuals" },
    { id = "CAMLOCK",   label = "♡ camera" },
    { id = "MISC",      label = "♡ movement" },
    { id = "TELEPORT",  label = "♡ locations" },
    { id = "SKINS",     label = "♡ skins" },
    { id = "WHITELIST", label = "♡ whitelist" },
    { id = "CONFIGS",   label = "♡ profiles" },
    { id = "SETTINGS",  label = "♡ settings" },
}
-- Buttons table already declared above

local function selectPage(name)
    Home.Visible = name == "HOME"
    for pn, p in pairs(Pages) do p.Visible = pn == name end
    for bn, data in pairs(Buttons) do
        local active = bn == name
        tween(data.btn, 0.12, {BackgroundColor3 = active and CARD2 or SURFACE})
        tween(data.text, 0.12, {TextColor3 = active and Theme.Accent or MUTE})
        if data.ind then tween(data.ind, 0.12, {BackgroundTransparency = active and 0 or 1}) end
    end
end

for i, cat in ipairs(CategoryNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = SURFACE
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 26
    btn.Parent = Categories
    corner(btn, 8)
    registerSurface(btn, "SURFACE")

    local ind = Instance.new("Frame")
    ind.Size = UDim2.fromOffset(2, 14)
    ind.Position = UDim2.fromOffset(5, 10)
    ind.BackgroundColor3 = Theme.Accent
    ind.BackgroundTransparency = 1
    ind.BorderSizePixel = 0
    ind.ZIndex = 27
    ind.Parent = btn
    corner(ind, 2)

    local txt = label(btn, cat.label, 12, MUTE)
    txt.Position = UDim2.fromOffset(14, 0)
    txt.Size = UDim2.new(1, -18, 1, 0)
    txt.Font = Enum.Font.Code
    txt.ZIndex = 27

    Buttons[cat.id] = {btn = btn, text = txt, ind = ind}
    btn.MouseButton1Click:Connect(function() selectPage(cat.id) end)
end

-- DRAG
local dragging, dragStart, startPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        syncShadow()
    end
end)

-- ESP — single throttled loop (no per-player RenderStepped = huge lag fix)
local hasDrawing = pcall(function() return Drawing and Drawing.new end)
local espObjects = {} -- [player] = {box, name, hBg, hFg}

local function destroyESP(plr)
    local e = espObjects[plr]
    if not e then return end
    pcall(function() if e.box then e.box:Remove() end end)
    pcall(function() if e.name then e.name:Remove() end end)
    pcall(function() if e.hBg then e.hBg:Remove() end end)
    pcall(function() if e.hFg then e.hFg:Remove() end end)
    espObjects[plr] = nil
end

local function createESP(plr)
    if not hasDrawing or plr == me or espObjects[plr] then return end
    local ok, box = pcall(function()
        local b = Drawing.new("Square")
        b.Visible = false
        b.Thickness = 1.2
        b.Filled = false
        return b
    end)
    if not ok or not box then return end
    local _, name = pcall(function()
        local t = Drawing.new("Text")
        t.Visible = false
        t.Size = 13
        t.Center = true
        t.Outline = true
        return t
    end)
    local _, hBg = pcall(function()
        local b = Drawing.new("Square")
        b.Visible = false
        b.Filled = true
        return b
    end)
    local _, hFg = pcall(function()
        local b = Drawing.new("Square")
        b.Visible = false
        b.Filled = true
        return b
    end)
    espObjects[plr] = { box = box, name = name, hBg = hBg, hFg = hFg }
end

local function hideESP(e)
    if e.box then e.box.Visible = false end
    if e.name then e.name.Visible = false end
    if e.hBg then e.hBg.Visible = false end
    if e.hFg then e.hFg.Visible = false end
end

local espFrame = 0
RunService.Heartbeat:Connect(function()
    if not hasDrawing then return end
    espFrame = espFrame + 1
    if espFrame % 2 ~= 0 then return end -- every 2nd frame — lighter on weak executors

    for plr, e in pairs(espObjects) do
        if not plr.Parent then
            destroyESP(plr)
        else
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local head = char:FindFirstChild("Head") or root
                local rp, on = cam:WorldToViewportPoint(root.Position)
                if on then
                    local hp = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local lp = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                    local h = math.abs(hp.Y - lp.Y)
                    local w = h / 2
                    local wl = isWhitelisted(plr)
                    if e.box then
                        if _G.ESP_Boxes and not wl then
                            e.box.Size = Vector2.new(w, h)
                            e.box.Position = Vector2.new(rp.X - w / 2, rp.Y - h / 2)
                            e.box.Color = _G.ESP_Color
                            e.box.Visible = true
                        else
                            e.box.Visible = false
                        end
                    end
                    if e.name then
                        if _G.ESP_Names and not wl then
                            e.name.Text = plr.DisplayName
                            e.name.Position = Vector2.new(rp.X, hp.Y - 14)
                            e.name.Color = _G.ESP_Color
                            e.name.Visible = true
                        else
                            e.name.Visible = false
                        end
                    end
                    if e.hBg and e.hFg then
                        if _G.ESP_Health and not wl then
                            local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                            local barX = rp.X - w / 2 - 6
                            local barY = rp.Y - h / 2
                            e.hBg.Size = Vector2.new(3, h)
                            e.hBg.Position = Vector2.new(barX, barY)
                            e.hBg.Color = Color3.fromRGB(30, 30, 30)
                            e.hBg.Visible = true
                            local fgH = h * pct
                            e.hFg.Size = Vector2.new(3, fgH)
                            e.hFg.Position = Vector2.new(barX, barY + (h - fgH))
                            e.hFg.Color = pct > 0.5 and Color3.fromRGB(60, 220, 100)
                                or (pct > 0.25 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(255, 60, 60))
                            e.hFg.Visible = true
                        else
                            e.hBg.Visible = false
                            e.hFg.Visible = false
                        end
                    end
                else
                    hideESP(e)
                end
            else
                hideESP(e)
            end
        end
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= me then createESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= me then
        createESP(p)
        p.CharacterAdded:Connect(function()
            -- drawings already exist; no new connection
        end)
    end
end)
Players.PlayerRemoving:Connect(function(p)
    destroyESP(p)
end)

local function isBlacklisted()
    local tool = me.Character and me.Character:FindFirstChildOfClass("Tool")
    if tool then
        local n = tool.Name:lower()
        for _, w in pairs(TriggerBot.Blacklist) do
            if string.find(n, w:lower()) then return true end
        end
    end
    return false
end

-- Triggerbot: no task.wait inside RenderStepped (that freezes frames)
local lastTrig = 0
RunService.Heartbeat:Connect(function()
    if not (TriggerBot.MasterEnabled and TriggerBot.Active) then return end
    if isBlacklisted() then return end
    local now = tick()
    if now - lastTrig < (TriggerBot.ClickDelay or 0.02) then return end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { me.Character }
    local ray = cam:ScreenPointToRay(mouse.X, mouse.Y)
    local res = workspace:Raycast(ray.Origin, ray.Direction * 500, params)
    if res and res.Instance then
        local char = res.Instance:FindFirstAncestorOfClass("Model")
        if char and char:FindFirstChildOfClass("Humanoid") and char ~= me.Character then
            local hitPlr = Players:GetPlayerFromCharacter(char)
            if hitPlr and isWhitelisted(hitPlr) then return end
            lastTrig = now
            pcall(safeClick)
        end
    end
end)

-- Camlock on Heartbeat (slightly lighter than RenderStepped)
RunService.Heartbeat:Connect(function()
    if not (_G.CamLock_Enabled and camLockActive) then return end
    if not currentCamLockTarget or not currentCamLockTarget.Parent then
        local best, bestD = nil, math.huge
        local hrp = me.Character and me.Character:FindFirstChild("HumanoidRootPart")
        local origin = (hrp and hrp.Position) or cam.CFrame.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= me and not isWhitelisted(p) then
                local c = p.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
                    if part then
                        local d = (part.Position - origin).Magnitude
                        if d < bestD then bestD = d best = part end
                    end
                end
            end
        end
        currentCamLockTarget = best
    end
    if currentCamLockTarget and currentCamLockTarget.Parent then
        local dir = (currentCamLockTarget.Position - cam.CFrame.Position)
        if dir.Magnitude > 0 then
            dir = dir.Unit
            local s = math.clamp(_G.CamLock_Smoothness or 0.25, 0.01, 10)
            local a = 0.08 + (s - 0.01) / (10 - 0.01) * 0.92
            if s >= 9.5 then a = 1 end
            if not lastCamLockDir then lastCamLockDir = cam.CFrame.LookVector end
            local blend = lastCamLockDir * (1 - a) + dir * a
            if blend.Magnitude > 0 then
                lastCamLockDir = blend.Unit
                cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + lastCamLockDir)
            end
        end
    end
end)

-- Speed / Jump — only when enabled; never fight reset with forced 16 spam
local weSetSpeed = false
local weSetJump = false
RunService.Heartbeat:Connect(function()
    local char = me.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then
        weSetSpeed = false
        weSetJump = false
        return
    end
    if _G.Speed_Enabled then
        pcall(function()
            hum.WalkSpeed = _G.Speed_Value
            weSetSpeed = true
        end)
    elseif weSetSpeed then
        pcall(function()
            if hum.WalkSpeed == _G.Speed_Value then
                hum.WalkSpeed = 16
            end
        end)
        weSetSpeed = false
    end
    if _G.Jump_Enabled then
        pcall(function()
            hum.JumpPower = _G.Jump_Value
            if hum.UseJumpPower == false then
                -- some games use JumpHeight
                pcall(function() hum.JumpHeight = _G.Jump_Value / 7.2 end)
            end
            weSetJump = true
        end)
    elseif weSetJump then
        pcall(function()
            if hum.JumpPower == _G.Jump_Value then
                hum.JumpPower = 50
            end
        end)
        weSetJump = false
    end
end)

-- on respawn, clear speed/jump ownership so Animate / default speed recover
me.CharacterAdded:Connect(function()
    weSetSpeed = false
    weSetJump = false
    camLockActive = false
    currentCamLockTarget = nil
    lastCamLockDir = nil
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == TriggerBot.TriggerKey then TriggerBot.Active = not TriggerBot.Active end
    if input.KeyCode == _G.CamLock_Key and _G.CamLock_Enabled then
        camLockActive = not camLockActive
        if not camLockActive then currentCamLockTarget = nil lastCamLockDir = nil end
    end
    if input.KeyCode == _G.Speed_Key and _G.Speed_ToggleEnabled then
        _G.Speed_Enabled = not _G.Speed_Enabled
    end
    if input.KeyCode == _G.Jump_Key then
        _G.Jump_Enabled = not _G.Jump_Enabled
    end
end)

local visible, debounce = true, false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if debounce then return end
        debounce = true
        visible = not visible
        Main.Visible = visible
        ShadowHolder.Visible = visible
        task.wait(0.08)
        debounce = false
    end
end)

selectPage("HOME")
Main.Visible = true
ShadowHolder.Visible = true
Main.Size = UDim2.fromOffset(W * 0.75, H * 0.75)
Main.BackgroundTransparency = 1
for _, element in ipairs(Main:GetDescendants()) do
    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
        element.Font = Enum.Font.FredokaOne
    end
end
task.delay(0.04, function()
    tween(Main, 0.42, {Size = UDim2.fromOffset(W, H), BackgroundTransparency = 0}, Enum.EasingStyle.Quint)
    syncShadow()
end)

--==================================================
-- SILENT AIM (after UI so a failed require never blocks the menu)
--==================================================
task.spawn(function()
    local handler = nil
    local okH, hRes = pcall(function()
        local mods = ReplicatedStorage:FindFirstChild("Modules")
        if not mods then return nil end
        local gh = mods:FindFirstChild("GunHandler")
        if not gh then return nil end
        return require(gh)
    end)
    if okH and hRes then
        handler = hRes
    else
        handler = { getAim = function(_, m) return Vector3.new(0, 0, -1), m or 200 end }
    end

    local oldFunc
    if handler.__saturnsHooked and type(handler.__saturnsOldGetAim) == "function" then
        oldFunc = handler.__saturnsOldGetAim
    else
        oldFunc = handler.getAim
        if type(oldFunc) ~= "function" then
            oldFunc = function(_, m) return Vector3.new(0, 0, -1), m or 200 end
        end
        handler.__saturnsOldGetAim = oldFunc
        handler.__saturnsHooked = true
    end

    local aimBusy = false

    local function getClosest()
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local best, bestDist = nil, math.max(_G.FOV_RADIUS or 0, 1)
        local myChar = me.Character
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= me and not isWhitelisted(v) then
                local char = v.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if part then
                        local sp, onScreen = cam:WorldToScreenPoint(part.Position)
                        if onScreen then
                            local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                            if d < bestDist then
                                if _G.WallCheck then
                                    local origin = cam.CFrame.Position
                                    local dir = (part.Position - origin)
                                    local dist = dir.Magnitude
                                    if dist > 0 then
                                        local params = RaycastParams.new()
                                        params.FilterType = Enum.RaycastFilterType.Exclude
                                        params.FilterDescendantsInstances = { myChar, cam }
                                        local hit = workspace:Raycast(origin, dir.Unit * dist, params)
                                        if hit and hit.Instance and hit.Instance:IsDescendantOf(char) then
                                            bestDist = d
                                            best = part
                                        end
                                    end
                                else
                                    bestDist = d
                                    best = part
                                end
                            end
                        end
                    end
                end
            end
        end
        return best
    end

    handler.getAim = function(origin, maxDist)
        if aimBusy then
            local ok, a, b = pcall(oldFunc, origin, maxDist)
            if ok then return a, b end
            return Vector3.new(0, 0, -1), maxDist or 200
        end
        aimBusy = true
        local okRun, result1, result2 = pcall(function()
            if not _G.SilentAim_Enabled or not _G.FOV_RADIUS or _G.FOV_RADIUS <= 0 then
                return oldFunc(origin, maxDist)
            end
            if _G.RevolverBypass then
                local tool = me.Character and me.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name == "[Revolver]" or tool.Name == "Revolver") then
                    return oldFunc(origin, maxDist)
                end
            end
            local target = getClosest()
            if target and target.Parent then
                if _G.Knock_Check then
                    local hum = target.Parent:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        return oldFunc(origin, maxDist)
                    end
                end
                local dir = (target.Position - origin)
                if dir.Magnitude > 0 then
                    return dir.Unit, math.min(dir.Magnitude, maxDist or 200)
                end
            end
            return oldFunc(origin, maxDist)
        end)
        aimBusy = false
        if okRun then return result1, result2 end
        local ok2, a, b = pcall(oldFunc, origin, maxDist)
        if ok2 then return a, b end
        return Vector3.new(0, 0, -1), maxDist or 200
    end

    local fovCircle = nil
    pcall(function()
        if Drawing and Drawing.new then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 1.5
            fovCircle.NumSides = 48
            fovCircle.Filled = false
            fovCircle.Visible = false
        end
    end)

    local fovTick = 0
    RunService.Heartbeat:Connect(function()
        fovTick = fovTick + 1
        if fovTick % 2 ~= 0 then return end
        if not fovCircle then return end
        if _G.ShowFOV and _G.FOV_RADIUS and _G.FOV_RADIUS > 0 then
            local vs = cam.ViewportSize
            fovCircle.Position = Vector2.new(vs.X / 2, vs.Y / 2)
            fovCircle.Radius = _G.FOV_RADIUS
            fovCircle.Color = _G.FOV_Color
            fovCircle.Visible = true
        else
            fovCircle.Visible = false
        end
    end)
end)

print("melody@main: ~$ main console loaded")
