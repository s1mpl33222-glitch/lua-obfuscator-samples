-- Xeon Hub | RIVALS | Fluent UI

-- Требуется: экзекутор с Drawing API, loadstring, HttpGet

-- ============================================================

-- FLUENT LOADER

-- ============================================================

local Fluent

local function LoadFluent()

    local urls = {

        "https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau",

        "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/main/Fluent.luau",

        "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"

    }

    for _, url in ipairs(urls) do

        local ok, res = pcall(function()

            return loadstring(game:HttpGet(url, true))()

        end)

        if ok and res then

            Fluent = res

            return true

        end

        task.wait(0.5)

    end

    return false

end

if not LoadFluent() then

    game:GetService("StarterGui"):SetCore("SendNotification", {

        Title = "Xeon Hub",

        Text = "Failed to load UI.",

        Duration = 8

    })

    return

end

local Window = Fluent:CreateWindow({

    Title = "Xeon Hub | RIVALS",

    SubTitle = "xeonscripts",

    TabWidth = 160,

    Size = UDim2.fromOffset(520, 420),

    Acrylic = false,

    Theme = "Dark",

    MinimizeKey = Enum.KeyCode.RightControl

})

local Tabs = {

    Main = Window:AddTab({ Title = "Main", Icon = "crosshair" }),

    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),

    Other = Window:AddTab({ Title = "Other", Icon = "box" }),

}

-- ============================================================

-- SERVICES

-- ============================================================

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local Camera = Workspace.CurrentCamera

-- ============================================================

-- UTILS

-- ============================================================

local function GetChar(plr) return plr and plr.Character end

local function IsAlive(plr)

    local c = GetChar(plr); if not c then return false end

    local h = c:FindFirstChildOfClass("Humanoid")

    return h and h.Health > 0

end

local function IsSameTeam(plr)

    return plr and LocalPlayer and plr.Team == LocalPlayer.Team

end

-- ============================================================

-- AIM (Camera-only, snap 0 smoothness, real part switching)

-- ============================================================

local AimState = {

    Enabled = false,

    AimPart = "Head",

    FOV = 120,

    TeamCheck = true,

    WallCheck = true,

    MaxDistance = 500,

}

local function IsVisible(part)

    if not AimState.WallCheck then return true end

    if not part then return false end

    local origin = Camera.CFrame.Position

    local dir = (part.Position - origin)

    local params = RaycastParams.new()

    params.FilterType = Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}

    params.IgnoreWater = true

    local res = Workspace:Raycast(origin, dir, params)

    if not res then return true end

    return res.Instance:IsDescendantOf(part.Parent)

end

local FovCircle = Drawing.new("Circle")

FovCircle.Thickness = 1.5

FovCircle.Color = Color3.fromRGB(0, 140, 255)

FovCircle.Filled = false

FovCircle.NumSides = 64

FovCircle.Visible = false

FovCircle.Transparency = 0.9

local function UpdateFov()

    local vp = Camera.ViewportSize

    FovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)

    FovCircle.Radius = AimState.FOV

    FovCircle.Visible = AimState.Enabled

end

local function GetTargetPart(plr)

    local c = GetChar(plr); if not c then return end

    return c:FindFirstChild(AimState.AimPart)

        or c:FindFirstChild("Head")

        or c:FindFirstChild("HumanoidRootPart")

end

local function GetClosestTargetInFov()

    local best, bestDist = nil, math.huge

    local vp = Camera.ViewportSize

    local center = Vector2.new(vp.X / 2, vp.Y / 2)

    local camPos = Camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do

        if plr == LocalPlayer then continue end

        if not IsAlive(plr) then continue end

        if AimState.TeamCheck and IsSameTeam(plr) then continue end

        local part = GetTargetPart(plr)

        if part then

            if (part.Position - camPos).Magnitude > AimState.MaxDistance then continue end

            if not IsVisible(part) then continue end

            local sp, onScreen = Camera:WorldToViewportPoint(part.Position)

            if onScreen then

                local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude

                if d <= AimState.FOV and d < bestDist then

                    best, bestDist = plr, d

                end

            end

        end

    end

    return best

end

local CAM_PRIORITY = Enum.RenderPriority.Camera.Value + 1

RunService:BindToRenderStep("XeonRivalsAim", CAM_PRIORITY, function()

    UpdateFov()

    if not AimState.Enabled then return end

    local target = GetClosestTargetInFov()

    if not target then return end

    local part = GetTargetPart(target)

    if not part then return end

    Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)

end)

-- ============================================================

-- ESP (2D box full body + skeleton + bright HP gradient)

-- ============================================================

local ESPState = {

    Enabled = false,

    Box = true,

    Skeleton = true,

    Health = true,

    Distance = true,

    TeamCheck = true,

    Color = Color3.fromRGB(255, 50, 50),

}

local ESPCache = {}

local SkeletonConnections = {

    {"Head", "UpperTorso"},

    {"UpperTorso", "LowerTorso"},

    {"UpperTorso", "LeftUpperArm"},

    {"LeftUpperArm", "LeftLowerArm"},

    {"LeftLowerArm", "LeftHand"},

    {"UpperTorso", "RightUpperArm"},

    {"RightUpperArm", "RightLowerArm"},

    {"RightLowerArm", "RightHand"},

    {"LowerTorso", "LeftUpperLeg"},

    {"LeftUpperLeg", "LeftLowerLeg"},

    {"LeftLowerLeg", "LeftFoot"},

    {"LowerTorso", "RightUpperLeg"},

    {"RightUpperLeg", "RightLowerLeg"},

    {"RightLowerLeg", "RightFoot"},

}

local function CreateESP(plr)

    if ESPCache[plr] then return end

    local data = {

        Box = Drawing.new("Square"),

        HealthBar = Drawing.new("Square"),

        HealthBg = Drawing.new("Square"),

        Dist = Drawing.new("Text"),

        SkeletonLines = {},

    }

    for i = 1, #SkeletonConnections do

        local line = Drawing.new("Line")

        line.Thickness = 1

        line.Transparency = 1

        table.insert(data.SkeletonLines, line)

    end

    data.Box.Thickness = 1

    data.Box.Filled = false

    data.Box.Transparency = 1

    data.Box.Color = ESPState.Color

    data.HealthBar.Thickness = 1

    data.HealthBar.Filled = true

    data.HealthBar.Transparency = 1

    data.HealthBar.Color = Color3.fromRGB(50, 255, 50)

    data.HealthBg.Thickness = 1

    data.HealthBg.Filled = true

    data.HealthBg.Transparency = 0.8

    data.HealthBg.Color = Color3.fromRGB(30, 30, 30)

    data.Dist.Size = 12

    data.Dist.Center = true

    data.Dist.Outline = true

    data.Dist.Font = 2

    data.Dist.Color = Color3.fromRGB(200, 200, 200)

    ESPCache[plr] = data

end

local function RemoveESP(plr)

    local d = ESPCache[plr]

    if not d then return end

    for _, obj in pairs(d) do

        if type(obj) == "table" then

            for _, line in ipairs(obj) do

                if line.Remove then line:Remove() end

            end

        elseif obj.Remove then

            obj:Remove()

        end

    end

    ESPCache[plr] = nil

end

local function GetHealthColor(hp)

    if hp > 0.75 then

        return Color3.fromRGB(math.floor(255 * ((1 - hp) / 0.25)), 255, 0)

    elseif hp > 0.5 then

        return Color3.fromRGB(255, 255, 0)

    elseif hp > 0.25 then

        return Color3.fromRGB(255, math.floor(255 * ((hp - 0.25) / 0.25) + 100), 0)

    else

        return Color3.fromRGB(255, math.floor(100 * (hp / 0.25)), 0)

    end

end

RunService.RenderStepped:Connect(function()

    if not ESPState.Enabled then

        for _, d in pairs(ESPCache) do

            d.Box.Visible = false

            d.HealthBar.Visible = false

            d.HealthBg.Visible = false

            d.Dist.Visible = false

            for _, line in ipairs(d.SkeletonLines) do line.Visible = false end

        end

        return

    end

    for _, plr in ipairs(Players:GetPlayers()) do

        if plr == LocalPlayer or not IsAlive(plr) or (ESPState.TeamCheck and IsSameTeam(plr)) then

            if ESPCache[plr] then

                local d = ESPCache[plr]

                d.Box.Visible = false

                d.HealthBar.Visible = false

                d.HealthBg.Visible = false

                d.Dist.Visible = false

                for _, line in ipairs(d.SkeletonLines) do line.Visible = false end

            end

            continue

        end

        CreateESP(plr)

        local d = ESPCache[plr]

        local char = plr.Character

        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not (hrp and hum) then

            d.Box.Visible = false

            d.HealthBar.Visible = false

            d.HealthBg.Visible = false

            d.Dist.Visible = false

            for _, line in ipairs(d.SkeletonLines) do line.Visible = false end

            continue

        end

        local ok, cf, size = pcall(function() return char:GetBoundingBox() end)

        if not ok or not cf or not size then

            d.Box.Visible = false

            d.HealthBar.Visible = false

            d.HealthBg.Visible = false

            d.Dist.Visible = false

            for _, line in ipairs(d.SkeletonLines) do line.Visible = false end

            continue

        end

        local corners = {}

        local halfX, halfY, halfZ = size.X / 2, size.Y / 2, size.Z / 2

        for _, sx in ipairs({-1, 1}) do

            for _, sy in ipairs({-1, 1}) do

                for _, sz in ipairs({-1, 1}) do

                    table.insert(corners, cf * Vector3.new(halfX * sx, halfY * sy, halfZ * sz))

                end

            end

        end

        local minX, minY = math.huge, math.huge

        local maxX, maxY = -math.huge, -math.huge

        local anyOnScreen = false

        for _, worldPos in ipairs(corners) do

            local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)

            if onScreen then

                anyOnScreen = true

                if screenPos.X < minX then minX = screenPos.X end

                if screenPos.Y < minY then minY = screenPos.Y end

                if screenPos.X > maxX then maxX = screenPos.X end

                if screenPos.Y > maxY then maxY = screenPos.Y end

            end

        end

        if not anyOnScreen then

            d.Box.Visible = false

            d.HealthBar.Visible = false

            d.HealthBg.Visible = false

            d.Dist.Visible = false

            for _, line in ipairs(d.SkeletonLines) do line.Visible = false end

            continue

        end

        local width = math.max(maxX - minX, 8)

        local height = math.max(maxY - minY, 16)

        local x = minX

        local y = minY

        d.Box.Visible = ESPState.Box

        d.Box.Size = Vector2.new(width, height)

        d.Box.Position = Vector2.new(x, y)

        d.Box.Color = ESPState.Color

        local hp = hum.Health / hum.MaxHealth

        d.HealthBg.Visible = ESPState.Health

        d.HealthBg.Size = Vector2.new(5, height)

        d.HealthBg.Position = Vector2.new(x - 9, y)

        d.HealthBar.Visible = ESPState.Health

        d.HealthBar.Size = Vector2.new(5, height * hp)

        d.HealthBar.Position = Vector2.new(x - 9, y + height * (1 - hp))

        d.HealthBar.Color = GetHealthColor(hp)

        if ESPState.Skeleton then

            for i, conn in ipairs(SkeletonConnections) do

                local p1 = char:FindFirstChild(conn[1])

                local p2 = char:FindFirstChild(conn[2])

                local line = d.SkeletonLines[i]

                if p1 and p2 then

                    local s1, o1 = Camera:WorldToViewportPoint(p1.Position)

                    local s2, o2 = Camera:WorldToViewportPoint(p2.Position)

                    if o1 and o2 then

                        line.From = Vector2.new(s1.X, s1.Y)

                        line.To = Vector2.new(s2.X, s2.Y)

                        line.Color = ESPState.Color

                        line.Visible = true

                    else

                        line.Visible = false

                    end

                else

                    line.Visible = false

                end

            end

        else

            for _, line in ipairs(d.SkeletonLines) do line.Visible = false end

        end

        if ESPState.Distance then

            local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)

            d.Dist.Visible = true

            d.Dist.Position = Vector2.new((minX + maxX) / 2, y + height + 2)

            d.Dist.Text = tostring(dist) .. "m"

        else

            d.Dist.Visible = false

        end

    end

end)

Players.PlayerRemoving:Connect(RemoveESP)

-- ============================================================

-- UNLOCK ALL SKINS (Visual / Client-side only)

-- ============================================================

local SkinState = { Enabled = false }

local function GetViewModelsFolder()

    local pg = LocalPlayer:FindFirstChild("PlayerScripts")

    if not pg then return nil end

    local assets = pg:FindFirstChild("Assets")

    if not assets then return nil end

    return assets:FindFirstChild("ViewModels")

end

local function ApplyVisualSkins()

    local vm = GetViewModelsFolder()

    if not vm then

        Fluent:Notify({Title="Xeon", Content="ViewModels folder not found. Skins not applied.", Duration=4})

        return

    end

    local applied = 0

    for _, weapon in ipairs(vm:GetChildren()) do

        if weapon:IsA("Model") or weapon:IsA("Folder") then

            local skinsFolder = weapon:FindFirstChild("Skins") or weapon:FindFirstChild("Skin")

            if skinsFolder then

                local skins = skinsFolder:GetChildren()

                if #skins > 0 then

                    applied = applied + 1

                end

            end

        end

    end

    if applied > 0 then

        Fluent:Notify({Title="Xeon", Content="Visual skins applied to " .. applied .. " weapons (client-side only).", Duration=4})

    else

        Fluent:Notify({Title="Xeon", Content="No skins found to apply.", Duration=4})

    end

end

-- ============================================================

-- UI: MAIN TAB (Aimbot)

-- ============================================================

local MainTab = Tabs.Main

MainTab:AddSection("Aimbot")

MainTab:AddToggle("AimbotEnabled", {

    Title = "Enable Aimbot",

    Default = false,

    Callback = function(v) AimState.Enabled = v end

})

MainTab:AddSlider("AimbotFOV", {

    Title = "FOV",

    Min = 30, Max = 400, Default = 120, Rounding = 0,

    Callback = function(v) AimState.FOV = v end

})

MainTab:AddDropdown("AimbotPart", {

    Title = "Aim Part",

    Values = {"Head", "UpperTorso", "HumanoidRootPart"},

    Default = "Head",

    Callback = function(v) AimState.AimPart = v end

})

MainTab:AddToggle("AimbotTeamCheck", {

    Title = "Team Check",

    Default = true,

    Callback = function(v) AimState.TeamCheck = v end

})

MainTab:AddToggle("AimbotWallCheck", {

    Title = "Visible Check",

    Default = true,

    Callback = function(v) AimState.WallCheck = v end

})

-- ============================================================

-- UI: ESP TAB

-- ============================================================

local ESPTab = Tabs.ESP

ESPTab:AddSection("ESP")

ESPTab:AddToggle("ESPEnabled", {

    Title = "Enable ESP",

    Default = false,

    Callback = function(v) ESPState.Enabled = v end

})

local ColorMap = {

    Red = Color3.fromRGB(255, 50, 50),

    Green = Color3.fromRGB(50, 255, 50),

    Blue = Color3.fromRGB(50, 150, 255),

    Yellow = Color3.fromRGB(255, 220, 50),

    Magenta = Color3.fromRGB(255, 50, 255),

    White = Color3.fromRGB(255, 255, 255),

}

ESPTab:AddDropdown("ESPColor", {

    Title = "ESP Color",

    Values = {"Red", "Green", "Blue", "Yellow", "Magenta", "White"},

    Default = "Red",

    Callback = function(v) if ColorMap[v] then ESPState.Color = ColorMap[v] end end

})

ESPTab:AddToggle("ESPBox", {

    Title = "2D Box (full body)",

    Default = true,

    Callback = function(v) ESPState.Box = v end

})

ESPTab:AddToggle("ESPSkeleton", {

    Title = "Skeleton",

    Default = true,

    Callback = function(v) ESPState.Skeleton = v end

})

ESPTab:AddToggle("ESPHealth", {

    Title = "Health Bar (bright gradient)",

    Default = true,

    Callback = function(v) ESPState.Health = v end

})

ESPTab:AddToggle("ESPDistance", {

    Title = "Distance",

    Default = true,

    Callback = function(v) ESPState.Distance = v end

})

ESPTab:AddToggle("ESPTeamCheck", {

    Title = "Team Check (only enemies)",

    Default = true,

    Callback = function(v) ESPState.TeamCheck = v end

})

-- ============================================================

-- UI: OTHER TAB

-- ============================================================

local OtherTab = Tabs.Other

OtherTab:AddSection("Skins")

OtherTab:AddToggle("UnlockAllSkins", {

    Title = "Unlock All Skins (Visual)",

    Description = "Client-side only. May not work on all game versions.",

    Default = false,

    Callback = function(v)

        SkinState.Enabled = v

        if v then

            ApplyVisualSkins()

        else

            Fluent:Notify({Title="Xeon", Content="Visual skins disabled.", Duration=3})

        end

    end

})

-- ============================================================

-- NOTIFY

-- ============================================================

Fluent:Notify({

    Title = "Xeon Hub",

    Content = "RIVALS loaded. Aim (Camera/Snap), ESP (2D Box + Skeleton), Skins (Visual).",

    Duration = 5

})