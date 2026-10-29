-- =======================================================
-- [ ✦ ] SmoothScript_v1.0 ⚡
-- Plane Textures, Ultra Smooth Plastic & Performance Script
-- Designed for Delta Executor (All Games)
-- =======================================================

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------
-- 1. LIGHTING, FOG, SHADOWS & ATMOSPHERE REMOVAL
---------------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.Brightness = 1
Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

-- Clear atmospheric fog, bloom, blur, and lighting post-effects
local function ClearLightingEffects()
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") or v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end
end

ClearLightingEffects()
Lighting.ChildAdded:Connect(function()
    task.wait()
    ClearLightingEffects()
end)

---------------------------------------------------------
-- 2. PLANE TEXTURES, TERRAIN & VFX SMOOTHING
---------------------------------------------------------
-- Force Plane Terrain Material
if Workspace:FindFirstChildOfClass("Terrain") then
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    pcall(function()
        Terrain.Decoration = false
    end)
end

-- Function to make parts plane, plastic, and remove all textures/VFX
local function MakePlaneAndSmooth(v)
    -- Plane & Smooth Plastic Parts
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
        v.CastShadow = false
        
    -- Mesh Parts (Remove texture maps to make them completely flat/plane)
    elseif v:IsA("MeshPart") then
        v.Material = Enum.Material.SmoothPlastic
        v.TextureID = ""
        v.Reflectance = 0
        v.CastShadow = false

    elseif v:IsA("SpecialMesh") then
        v.TextureId = ""
        
    -- Destroy All Surface Decals & Textures (Makes world flat/plane)
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
        
    -- Flatten / Disable Particles, Beams, Trails & VFX
    elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("Trail") or v:IsA("Beam") then
        v.Enabled = false
    elseif v:IsA("Explosion") then
        v.Visible = false
    end
end

-- Optimize existing world objects
for _, v in pairs(Workspace:GetDescendants()) do
    MakePlaneAndSmooth(v)
end

-- Dynamically handle new parts/effects spawned by the game
Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    MakePlaneAndSmooth(v)
end)

---------------------------------------------------------
-- 3. FLAT, PLANE & SMOOTH GUI / UI
---------------------------------------------------------
local function SmoothGuiElement(element)
    if element:IsA("GuiObject") then
        element.BorderSizePixel = 0
        
        -- Remove heavy stroke outlines
        for _, child in pairs(element:GetChildren()) do
            if child:IsA("UIStroke") then
                child.Enabled = false
            end
        end
    end
end

if LocalPlayer then
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
    if PlayerGui then
        for _, v in pairs(PlayerGui:GetDescendants()) do
            SmoothGuiElement(v)
        end
        PlayerGui.DescendantAdded:Connect(SmoothGuiElement)
    end
end

---------------------------------------------------------
-- 4. MINI FPS & PING TOP DISPLAY
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SmoothScriptUI"
ScreenGui.ResetOnSpawn = false

-- Delta Executor CoreGui Bypass
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

-- Top Display Container
local DisplayFrame = Instance.new("Frame")
DisplayFrame.Name = "TopDisplay"
DisplayFrame.Size = UDim2.new(0, 190, 0, 28)
DisplayFrame.Position = UDim2.new(0.5, -95, 0, 8) -- Centered top mobile-friendly
DisplayFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
DisplayFrame.BackgroundTransparency = 0.25
DisplayFrame.BorderSizePixel = 0
DisplayFrame.Parent = ScreenGui

-- Rounded Corners for Smooth Aesthetic
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = DisplayFrame

-- Subtle Flat Accent Border
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1
UIStroke.Transparency = 0.5
UIStroke.Parent = DisplayFrame

-- Text Label
local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(1, 0, 1, 0)
StatsText.BackgroundTransparency = 1
StatsText.Font = Enum.Font.GothamBold
StatsText.TextSize = 12
StatsText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsText.Text = "[ ✦ ] FPS: -- | Ping: --ms"
StatsText.Parent = DisplayFrame

---------------------------------------------------------
-- 5. REAL-TIME STATS UPDATER
---------------------------------------------------------
local frameCount = 0
local lastUpdate = os.clock()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = os.clock()
    
    if currentTime - lastUpdate >= 0.5 then
        local fps = math.floor(frameCount / (currentTime - lastUpdate))
        local ping = 0
        
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        
        StatsText.Text = string.format("[ ✦ ] FPS: %d  |  Ping: %dms ⚡", fps, ping)
        
        frameCount = 0
        lastUpdate = currentTime
    end
end)

print("[ ✦ ] SmoothScript_v1.0 ⚡ Loaded Successfully!")
