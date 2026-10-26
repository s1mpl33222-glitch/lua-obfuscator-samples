-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

--[[rscripts:analytics:start]]
-- Script analytics (enabled by the creator on rscripts.net).
-- Runs in its own thread and cannot affect the script below.
task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/v2/client.lua?s=6ada2740da1192654ca4c0fa"))()
	end)
end)
--[[rscripts:analytics:end]]

-- Urban Reload | AimBot + ESP + No Recoil
-- Executor: Synapse X / KRNL / Fluxus
-- Game: https://www.roblox.com/games/84448037861644/Urban-Reload

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Camera            = workspace.CurrentCamera
local LocalPlayer       = Players.LocalPlayer

-- ================================================
--  SETTINGS
-- ================================================
local Settings = {
    AimbotEnabled     = true,
    AimbotKey         = Enum.UserInputType.MouseButton2,
    AimbotBone        = "Head",
    AimbotSmoothing   = 0.15,
    AimbotFOV         = 200,

    ESPEnabled        = true,
    ESPBoxColor       = Color3.fromRGB(255, 60, 60),
    ESPNameColor      = Color3.fromRGB(255, 255, 255),
    ESPHealthColor    = Color3.fromRGB(60, 255, 60),
    ESPTracerColor    = Color3.fromRGB(255, 200, 0),
    ESPTracers        = true,
    ESPDistance       = true,
    ESPMaxDist        = 2000,

    NoRecoilEnabled   = true,
}

-- ================================================
--  NO RECOIL
-- ================================================
local Weapons     = game:GetService("ReplicatedStorage"):WaitForChild("Weapons")
local ClientState = require(Weapons:WaitForChild("ClientState"))
local Config      = require(Weapons:WaitForChild("Config"))

pcall(function() Config.Global.BloomScale = 0 end)

RunService:BindToRenderStep("NoRecoil", Enum.RenderPriority.Camera.Value - 1, function()
    if not Settings.NoRecoilEnabled then return end
    ClientState.RecoilPitch      = 0
    ClientState.RecoilYaw        = 0
    ClientState.Spread           = 0
    ClientState.SpreadRest       = 0
    ClientState.SpreadMultiplier = 0
    pcall(function() Config.Global.BloomScale = 0 end)
end)

-- ================================================
--  UTILITIES
-- ================================================
local function GetCharacter(player)
    return player and player.Character
end

local function GetRootAndHum(player)
    local char = GetCharacter(player)
    if not char then return nil, nil end
    return char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

local function GetBone(player, bone)
    local char = GetCharacter(player)
    if not char then return nil end
    return char:FindFirstChild(bone) or char:FindFirstChild("HumanoidRootPart")
end

local function IsAlive(player)
    local _, hum = GetRootAndHum(player)
    return hum and hum.Health > 0
end

local function WorldToViewport(pos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screenPos.X, screenPos.Y), screenPos.Z, onScreen
end

local function IsEnemy(player)
    if player == LocalPlayer then return false end
    local lt, pt = player.Team, LocalPlayer.Team
    if lt and pt and lt == pt then return false end
    return true
end

-- ================================================
--  FOV CIRCLE
-- ================================================
local FOVCircle         = Drawing.new("Circle")
FOVCircle.Visible       = true
FOVCircle.Radius        = Settings.AimbotFOV
FOVCircle.Color         = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness     = 1
FOVCircle.Filled        = false
FOVCircle.NumSides      = 64

-- ================================================
--  CLOSEST ENEMY IN FOV
-- ================================================
local function GetClosestEnemy()
    local center      = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest     = nil
    local closestDist = Settings.AimbotFOV

    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) and IsAlive(player) then
            local bone = GetBone(player, Settings.AimbotBone)
            if bone then
                local screenPos, depth, onScreen = WorldToViewport(bone.Position)
                if onScreen and depth > 0 then
                    local dist = (screenPos - center).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest     = player
                    end
                end
            end
        end
    end
    return closest
end

-- ================================================
--  AIMBOT
-- ================================================
RunService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius   = Settings.AimbotFOV

    if not Settings.AimbotEnabled then return end
    if not UserInputService:IsMouseButtonPressed(Settings.AimbotKey) then return end

    local target = GetClosestEnemy()
    if not target then return end
    local bone = GetBone(target, Settings.AimbotBone)
    if not bone then return end

    local currentCF = Camera.CFrame
    local targetCF  = CFrame.new(currentCF.Position, bone.Position)
    local alpha     = Settings.AimbotSmoothing == 0 and 1 or Settings.AimbotSmoothing
    Camera.CFrame   = currentCF:Lerp(targetCF, alpha)
end)

-- ================================================
--  ESP POOL
-- ================================================
local ESPObjects = {}

local function MakeESP(player)
    local obj = {
        Box    = Drawing.new("Square"),
        Name   = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        Dist   = Drawing.new("Text"),
    }

    obj.Box.Visible       = false
    obj.Box.Color         = Settings.ESPBoxColor
    obj.Box.Thickness     = 1
    obj.Box.Filled        = false

    obj.Name.Visible      = false
    obj.Name.Color        = Settings.ESPNameColor
    obj.Name.Size         = 13
    obj.Name.Center       = true
    obj.Name.Outline      = true
    obj.Name.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Health.Visible      = false
    obj.Health.Color        = Settings.ESPHealthColor
    obj.Health.Size         = 11
    obj.Health.Center       = true
    obj.Health.Outline      = true
    obj.Health.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Tracer.Visible    = false
    obj.Tracer.Color      = Settings.ESPTracerColor
    obj.Tracer.Thickness  = 1

    obj.Dist.Visible      = false
    obj.Dist.Color        = Settings.ESPNameColor
    obj.Dist.Size         = 11
    obj.Dist.Center       = true
    obj.Dist.Outline      = true
    obj.Dist.OutlineColor = Color3.fromRGB(0, 0, 0)

    ESPObjects[player] = obj
end

local function RemoveESP(player)
    local obj = ESPObjects[player]
    if not obj then return end
    for _, d in pairs(obj) do pcall(function() d:Remove() end) end
    ESPObjects[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then MakeESP(p) end
end
Players.PlayerAdded:Connect(MakeESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ================================================
--  ESP UPDATE
-- ================================================
RunService:BindToRenderStep("ESP", Enum.RenderPriority.Camera.Value - 2, function()
    for player, obj in pairs(ESPObjects) do
        local visible = Settings.ESPEnabled and IsEnemy(player) and IsAlive(player)

        if not visible then
            for _, d in pairs(obj) do d.Visible = false end
        else
            local char = GetCharacter(player)
            if not char then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum  = char:FindFirstChildOfClass("Humanoid")

            if not root or not head or not hum then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local dist = (Camera.CFrame.Position - root.Position).Magnitude
            if dist > Settings.ESPMaxDist then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local topScreen,    _, topOn    = WorldToViewport(head.Position + Vector3.new(0, 2.5, 0))
            local bottomScreen, _, bottomOn = WorldToViewport(root.Position - Vector3.new(0, 3.5, 0))

            if not topOn or not bottomOn then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local boxH = math.abs(topScreen.Y - bottomScreen.Y)
            local boxW = boxH * 0.55
            local boxX = topScreen.X - boxW / 2

            obj.Box.Visible  = true
            obj.Box.Position = Vector2.new(boxX, topScreen.Y)
            obj.Box.Size     = Vector2.new(boxW, boxH)

            obj.Name.Visible  = true
            obj.Name.Position = Vector2.new(topScreen.X, topScreen.Y - 15)
            obj.Name.Text     = player.DisplayName

            local hp = math.floor((hum.Health / hum.MaxHealth) * 100)
            obj.Health.Visible  = true
            obj.Health.Position = Vector2.new(topScreen.X, topScreen.Y + boxH + 2)
            obj.Health.Text     = hp .. "hp"
            obj.Health.Color    = Color3.fromRGB(255 - hp * 2.55, hp * 2.55, 0)

            obj.Dist.Visible  = Settings.ESPDistance
            obj.Dist.Position = Vector2.new(topScreen.X, topScreen.Y + boxH + 14)
            obj.Dist.Text     = math.floor(dist) .. "m"

            obj.Tracer.Visible = Settings.ESPTracers
            obj.Tracer.From    = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            obj.Tracer.To      = bottomScreen
        end
    end
end)

-- ================================================
--  RAYFIELD UI
-- ================================================
local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

local Window = Rayfield:CreateWindow({
    Name                = "Urban Reload",
    LoadingTitle        = "Urban Reload",
    LoadingSubtitle     = "by null",
    ConfigurationSaving = { Enabled = false },
    KeySystem           = false,
})

-- ── AIMBOT TAB ──────────────────────────────────
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name         = "Aimbot",
    CurrentValue = Settings.AimbotEnabled,
    Flag         = "AimbotEnabled",
    Callback     = function(v) Settings.AimbotEnabled = v end,
})

AimbotTab:CreateSlider({
    Name         = "Smoothing",
    Range        = {0, 1},
    Increment    = 0.01,
    CurrentValue = Settings.AimbotSmoothing,
    Flag         = "AimbotSmoothing",
    Callback     = function(v) Settings.AimbotSmoothing = v end,
})

AimbotTab:CreateSlider({
    Name         = "FOV Radius",
    Range        = {50, 800},
    Increment    = 10,
    CurrentValue = Settings.AimbotFOV,
    Flag         = "AimbotFOV",
    Callback     = function(v)
        Settings.AimbotFOV = v
        FOVCircle.Radius   = v
    end,
})

AimbotTab:CreateDropdown({
    Name          = "Bone Target",
    Options       = {"Head", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    Flag          = "AimbotBone",
    Callback      = function(v) Settings.AimbotBone = v[1] end,
})

-- ── ESP TAB ─────────────────────────────────────
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
    Name         = "ESP",
    CurrentValue = Settings.ESPEnabled,
    Flag         = "ESPEnabled",
    Callback     = function(v) Settings.ESPEnabled = v end,
})

ESPTab:CreateToggle({
    Name         = "Tracers",
    CurrentValue = Settings.ESPTracers,
    Flag         = "ESPTracers",
    Callback     = function(v) Settings.ESPTracers = v end,
})

ESPTab:CreateToggle({
    Name         = "Distance",
    CurrentValue = Settings.ESPDistance,
    Flag         = "ESPDistance",
    Callback     = function(v) Settings.ESPDistance = v end,
})

ESPTab:CreateSlider({
    Name         = "Max Distance",
    Range        = {100, 5000},
    Increment    = 100,
    CurrentValue = Settings.ESPMaxDist,
    Flag         = "ESPMaxDist",
    Callback     = function(v) Settings.ESPMaxDist = v end,
})

-- ── MISC TAB ────────────────────────────────────
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateToggle({
    Name         = "No Recoil",
    CurrentValue = Settings.NoRecoilEnabled,
    Flag         = "NoRecoilEnabled",
    Callback     = function(v) Settings.NoRecoilEnabled = v end,
})

Rayfield:Notify({
    Title    = "Urban Reload loaded",
    Content  = "Insert key: Right Shift",
    Duration = 4,
})