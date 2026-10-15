-- MYNXX LOADER
local ReplicatedFirst = game:GetService("ReplicatedFirst")
ReplicatedFirst:RemoveDefaultLoadingScreen()

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

local startTime = os.clock()

local function log(msg)
    print("[MYNXX] " .. string.format("%.3fs", os.clock() - startTime) .. " | " .. msg)
end

-- ==========================================
-- GIGA-PIXEL FFLAGS INJEKTION
-- ==========================================
if pcall(function() return setfflag end) and setfflag then
    pcall(function()
        setfflag("DebugForceAllTextures1x1", "True")
        setfflag("RomRenderTextureScale", "10")
    end)
end

local localPlayer = Players.LocalPlayer
while not localPlayer do
    task.wait()
    localPlayer = Players.LocalPlayer
end

-- ==========================================
-- 2D UI NUKE (Inventar Fix: Sichtbarer Pixel-Brei)
-- ==========================================
local function nukeTexture(obj)
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        obj.ImageTransparency = 0 
        obj.ResampleMode = Enum.ResamplerMode.Pixelated
        -- Starker orangener Deep-Fried-Filter, um die fehlenden Pixel wettzumachen
        obj.ImageColor3 = Color3.fromRGB(255, 110, 40) 
    end
    
    if obj.Name == "Avatar" or obj.Name == "ProfilePicture" or obj.Name == "SettingsButton" then
        obj.Visible = false
    end
end

-- ==========================================
-- 3D WORLD NUKE (Traits, Accessoires, Pets in Brei verwandeln)
-- ==========================================
local function nuke3D(obj)
    pcall(function()
        if obj:IsA("MeshPart") then
            obj.TextureID = "" 
            obj.Material = Enum.Material.SmoothPlastic 
        elseif obj:IsA("SpecialMesh") then
            obj.TextureId = ""
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Texture = ""
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
        end
    end)
end

-- UI-Schleife starten
task.spawn(function()
    local pGui = localPlayer:WaitForChild("PlayerGui", 10)
    if pGui then
        for _, obj in pairs(pGui:GetDescendants()) do
            nukeTexture(obj)
        end
        pGui.DescendantAdded:Connect(nukeTexture)
    end
end)

-- 3D-Welt-Schleife starten (Zerstört Traits & Accessoires)
task.spawn(function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        nuke3D(obj)
    end
    Workspace.DescendantAdded:Connect(nuke3D)
end)

-- ==========================================
-- RESTLICHE OPTIMIERUNGEN & LOADER UI
-- ==========================================
local origShadows
pcall(function() origShadows = Lighting.GlobalShadows; Lighting.GlobalShadows = false end)
task.delay(8, function() pcall(function() if origShadows ~= nil then Lighting.GlobalShadows = origShadows end end) end)

for _, d in ipairs({0.3, 1.5}) do
    task.delay(d, function()
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam.CameraType ~= Enum.CameraType.Custom then
                cam.CameraType = Enum.CameraType.Custom
                local ch = localPlayer.Character
                if ch then cam.CameraSubject = ch:FindFirstChildOfClass("Humanoid") end
            end
        end)
    end)
end

task.spawn(function()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then plots = Workspace:WaitForChild("Plots", 3) end
    if not plots then return end

    local ids, seen, count = {}, {}, 0
    local propMap = {
        MeshPart = {"MeshId", "TextureID"},
        SpecialMesh = {"MeshId", "TextureId"},
        Decal = {"Texture"},
        Texture = {"Texture"},
    }

    pcall(function()
        for _, obj in ipairs(plots:GetDescendants()) do
            if count >= 200 then break end
            local props = propMap[obj.ClassName]
            if props then
                for _, prop in ipairs(props) do
                    pcall(function()
                        local id = obj[prop]
                        if id and id ~= "" and not seen[id] then
                            local c = id:byte(1)
                            if c == 114 or c == 104 then
                                seen[id] = true; count = count + 1; ids[count] = id
                            end
                        end
                    end)
                end
            end
        end
    end)

    if count > 0 then
        local total = count
        local nextIdx = 1
        local done = 0
        for _ = 1, 8 do
            task.spawn(function()
                while true do
                    local s = nextIdx; if s > total then return end
                    nextIdx = math.min(s + 15, total + 1)
                    local batch = {}
                    for i = s, nextIdx - 1 do batch[#batch + 1] = ids[i] end
                    pcall(ContentProvider.PreloadAsync, ContentProvider, batch)
                    done = done + #batch
                end
            end)
        end
        local dl = os.clock() + 1.5
        while done < total and os.clock() < dl do RunService.Heartbeat:Wait() end
    end
    log("Plots preloaded: " .. count .. " assets")
end)

task.spawn(function()
    task.wait(3)
    local ids, seen, count = {}, {}, 0
    local propMap = {
        MeshPart = {"MeshId","TextureID"}, SpecialMesh = {"MeshId","TextureId"},
        Decal = {"Texture"}, Texture = {"Texture"},
        ImageLabel = {"Image"}, ImageButton = {"Image"},
    }
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if count >= 300 then break end
            local props = propMap[obj.ClassName]
            if props then
                for _, prop in ipairs(props) do
                    pcall(function()
                        local id = obj[prop]
                        if id and id ~= "" and not seen[id] then
                            local c = id:byte(1)
                            if c == 114 or c == 104 then
                                seen[id] = true; count = count + 1; ids[count] = id
                            end
                        end
                    end)
                end
            end
        end
    end)
    if count > 0 then
        local idx = 1
        while idx <= count do
            local batch = {}
            for j = idx, math.min(idx + 29, count) do batch[#batch+1] = ids[j] end
            pcall(ContentProvider.PreloadAsync, ContentProvider, batch)
            idx = idx + 30
        end
    end
end)

if CoreGui:FindFirstChild("MynxxLoaderUI") then
    CoreGui.MynxxLoaderUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MynxxLoaderUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local loadStart = os.clock()

local card = Instance.new("Frame")
card.Name = "NotificationCard"
card.AnchorPoint = Vector2.new(0.5, 0)
card.Position = UDim2.new(0.5, 0, 0, 18)
card.Size = UDim2.new(0, 300, 0, 96)
card.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
card.BackgroundTransparency = 0.08
card.BorderSizePixel = 0
card.Parent = gui

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 14)
cardCorner.Parent = card

local cardStroke = Instance.new("UIStroke")
cardStroke.Color = Color3.fromRGB(220, 220, 220)
cardStroke.Thickness = 1.2
cardStroke.Transparency = 0.45
cardStroke.Parent = card

local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 3, 1, -20)
accent.Position = UDim2.new(0, 10, 0.5, 0)
accent.AnchorPoint = Vector2.new(0, 0.5)
accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
accent.BorderSizePixel = 0
accent.Parent = card

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(1, 0)
accentCorner.Parent = accent

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 26, 0, 16)
title.Size = UDim2.new(1, -36, 0, 22)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "MYNXX LOADER"
title.Parent = card

local timeText = Instance.new("TextLabel")
timeText.Name = "TimeText"
timeText.BackgroundTransparency = 1
timeText.Position = UDim2.new(0, 26, 0, 40)
timeText.Size = UDim2.new(1, -36, 0, 20)
timeText.Font = Enum.Font.GothamMedium
timeText.TextSize = 14
timeText.TextColor3 = Color3.fromRGB(180, 180, 180)
timeText.TextXAlignment = Enum.TextXAlignment.Left
timeText.Text = "Loading..."
timeText.Parent = card

local discordText = Instance.new("TextLabel")
discordText.Name = "DiscordText"
discordText.BackgroundTransparency = 1
discordText.Position = UDim2.new(0, 26, 0, 62)
discordText.Size = UDim2.new(1, -36, 0, 18)
discordText.Font = Enum.Font.GothamBold
discordText.TextSize = 13
discordText.TextColor3 = Color3.fromRGB(150, 150, 150)
discordText.TextXAlignment = Enum.TextXAlignment.Left
discordText.Text = "discord.gg/sabtweaks"
discordText.Parent = card

local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -22, 0, 18)
statusDot.AnchorPoint = Vector2.new(0.5, 0.5)
statusDot.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
statusDot.BorderSizePixel = 0
statusDot.Parent = card

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

task.spawn(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local elapsed = os.clock() - loadStart
    timeText.Text = string.format("Loaded in %.2fs", elapsed)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

task.spawn(function()
    task.wait(5)
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeTargets = {card, title, timeText, discordText, accent, statusDot}
    for _, obj in ipairs(fadeTargets) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, tweenInfo, {TextTransparency = 1}):Play()
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, tweenInfo, {BackgroundTransparency = 1}):Play()
        end
    end
    TweenService:Create(cardStroke, tweenInfo, {Transparency = 1}):Play()
    task.wait(0.6)
    gui:Destroy()
end)