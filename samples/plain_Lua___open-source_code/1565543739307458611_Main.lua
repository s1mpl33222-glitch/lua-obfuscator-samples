local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace:FindFirstChild("CustomCamera")
if not Camera or not Camera:IsA("Camera") then
    Camera = Workspace.CurrentCamera
end

local Rayfield
local function LoadRayfield()
    Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end
LoadRayfield()

local Settings = {
    AimEnabled  = true,
    AimKey      = Enum.UserInputType.MouseButton2,
    FOV         = 150,
    Smoothness  = 1.0,
    YOffset     = 1.5,
    VisCheck    = false,
    TeamCheck   = false,
    AutoSwitch  = true,
    OverrideCam = false,

    ESPEnabled  = true,
    ESPBoxes    = true,
    ESPTracers  = true,
    ESPInfo     = true,
    ESPDrawFOV  = true,
    ESPMaxDist  = 5000,
    ESPBoxScale = 1.5,

    HitboxEnabled      = false,
    HitboxSize         = 10,
    HitboxTransparency = 0.6,

    Notifications = true,
}

local CurrentTarget  = nil
local HoldingAim     = false
local ESPTable       = {}
local ScriptActive   = true

local FOVDraw = Drawing.new("Circle")
FOVDraw.Thickness    = 1
FOVDraw.NumSides     = 64
FOVDraw.Filled       = false
FOVDraw.ZIndex       = 1
FOVDraw.Transparency = 1
FOVDraw.Color        = Color3.fromRGB(255, 255, 255)

local TargetDraw = Drawing.new("Circle")
TargetDraw.Thickness = 2.5
TargetDraw.NumSides  = 32
TargetDraw.Filled    = false
TargetDraw.ZIndex    = 5
TargetDraw.Color     = Color3.fromRGB(255, 50, 50)

local function Notify(text)
    if not Settings.Notifications then return end
    pcall(function()
        Rayfield:Notify({
            Title    = "VoidScripts",
            Content  = text,
            Duration = 4,
            Image    = 4483362458,
        })
    end)
end

local function IsAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function GetAimPart(char)
    return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end

local function GetAimPosition(part)
    return part.Position + Vector3.new(0, Settings.YOffset, 0)
end

local function GetHealth(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        return math.floor(hum.Health), math.floor(hum.MaxHealth)
    end
    return 0, 100
end

local function IsVisible(character, worldPos)
    if not Settings.VisCheck then return true end
    local origin    = Camera.CFrame.Position
    local direction = worldPos - origin
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(origin, direction, rayParams)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(character)
    end
    return true
end

local function IsTargetValid(player)
    if player == LocalPlayer then return false end
    if Settings.TeamCheck and player.Team == LocalPlayer.Team then return false end
    return true
end

local function GetESP(player)
    if not ESPTable[player] then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled    = false
        box.Visible   = false

        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Visible   = false

        local info = Drawing.new("Text")
        info.Size    = 13
        info.Center  = true
        info.Outline = true
        info.Font    = 2
        info.Visible = false

        ESPTable[player] = { Box = box, Tracer = tracer, Info = info }
    end
    return ESPTable[player]
end

local function RemoveESP(player)
    local data = ESPTable[player]
    if data then
        data.Box:Remove()
        data.Tracer:Remove()
        data.Info:Remove()
        ESPTable[player] = nil
    end
end

local function GetClosestPlayer()
    local screenCenter = Camera.ViewportSize / 2
    local closest      = nil
    local closestDist  = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if IsTargetValid(player) then
            local char = player.Character
            local part = char and GetAimPart(char)
            if part and IsAlive(char) then
                local aimPos = GetAimPosition(part)
                local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
                if onScreen then
                    local screenDist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if screenDist <= Settings.FOV and IsVisible(char, aimPos) then
                        local dist3D = (part.Position - Camera.CFrame.Position).Magnitude
                        if dist3D < closestDist then
                            closestDist = dist3D
                            closest = {
                                Player   = player,
                                Part     = part,
                                Position = pos,
                                Distance = dist3D,
                                Notified = false,
                            }
                        end
                    end
                end
            end
        end
    end

    return closest
end

local function RecursiveFindTools(folder, path, results)
    results = results or {}
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Tool") then
            table.insert(results, { Path = path .. obj.Name, Tool = obj })
        elseif obj:IsA("Folder") or obj:IsA("Model") then
            RecursiveFindTools(obj, path .. obj.Name .. ".", results)
        end
    end
    return results
end

local function GiveTool(tool, path)
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not bp then
        Notify("No backpack found!")
        return
    end
    local clone = tool:Clone()
    clone.Parent = bp
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum and char and not char:FindFirstChildOfClass("Tool") then
        pcall(function() hum:EquipTool(clone) end)
    end
    Notify("Gave: " .. tostring(path))
end

local AimKeyMap = {
    ["Right Mouse"]  = Enum.UserInputType.MouseButton2,
    ["Left Mouse"]   = Enum.UserInputType.MouseButton1,
    ["Middle Mouse"] = Enum.UserInputType.MouseButton3,
    ["Left Shift"]   = Enum.KeyCode.LeftShift,
    ["Left Alt"]     = Enum.KeyCode.LeftAlt,
    ["Left Control"] = Enum.KeyCode.LeftControl,
    ["E"]            = Enum.KeyCode.E,
    ["Q"]            = Enum.KeyCode.Q,
    ["F"]            = Enum.KeyCode.F,
    ["C"]            = Enum.KeyCode.C,
    ["V"]            = Enum.KeyCode.V,
    ["X"]            = Enum.KeyCode.X,
    ["Z"]            = Enum.KeyCode.Z,
    ["T"]            = Enum.KeyCode.T,
}
local AimKeyOptions = {
    "Right Mouse", "Left Mouse", "Middle Mouse", "Left Shift", "Left Alt",
    "Left Control", "E", "Q", "F", "C", "V", "X", "Z", "T",
}

local BuildUI

local function ReloadUI()
    if Rayfield then
        pcall(function() Rayfield:Destroy() end)
    end
    LoadRayfield()
    BuildUI()
end

function BuildUI()
    local Window = Rayfield:CreateWindow({
        Name             = "Void Scripts | FluxoPVP",
        LoadingTitle     = "Void Scripts",
        LoadingSubtitle  = "FluxoPVP Edition",
        ConfigurationSaving = {
            Enabled    = true,
            FolderName = "VoidScripts",
            FileName   = "VoidScriptsConfig",
        },
        KeySystem = false,
    })

    local AimTab    = Window:CreateTab("Aim", 4483362458)
    local ESPTab    = Window:CreateTab("ESP", 4483362458)
    local HitboxTab = Window:CreateTab("Hitbox", 4483362458)
    local GunTab    = Window:CreateTab("Guns", 4483362458)
    local MiscTab   = Window:CreateTab("Misc", 4483362458)

    AimTab:CreateSection("Aimbot")

    AimTab:CreateToggle({
        Name         = "Enable Aim Lock",
        CurrentValue = Settings.AimEnabled,
        Flag         = "AimEnabled",
        Callback     = function(v)
            Settings.AimEnabled = v
            Notify("Aim: " .. tostring(v))
        end,
    })

    AimTab:CreateSlider({
        Name         = "FOV Radius",
        Range        = { 10, 800 },
        Increment    = 1,
        Suffix       = "px",
        CurrentValue = Settings.FOV,
        Flag         = "AimFOV",
        Callback     = function(v) Settings.FOV = v end,
    })

    AimTab:CreateSlider({
        Name         = "Smoothness (1 = Hard Lock)",
        Range        = { 0.01, 1 },
        Increment    = 0.01,
        Suffix       = "",
        CurrentValue = Settings.Smoothness,
        Flag         = "AimSmoothness",
        Callback     = function(v) Settings.Smoothness = v end,
    })

    AimTab:CreateSlider({
        Name         = "Y-Offset",
        Range        = { 0, 5 },
        Increment    = 0.1,
        Suffix       = "studs",
        CurrentValue = Settings.YOffset,
        Flag         = "AimYOffset",
        Callback     = function(v) Settings.YOffset = v end,
    })

    AimTab:CreateSection("Filters")

    AimTab:CreateToggle({
        Name         = "Visibility Check",
        CurrentValue = Settings.VisCheck,
        Flag         = "AimVisCheck",
        Callback     = function(v) Settings.VisCheck = v end,
    })

    AimTab:CreateToggle({
        Name         = "Team Check",
        CurrentValue = Settings.TeamCheck,
        Flag         = "AimTeamCheck",
        Callback     = function(v) Settings.TeamCheck = v end,
    })

    AimTab:CreateToggle({
        Name         = "Auto Switch Target",
        CurrentValue = Settings.AutoSwitch,
        Flag         = "AimAutoSwitch",
        Callback     = function(v) Settings.AutoSwitch = v end,
    })

    AimTab:CreateToggle({
        Name         = "Override Camera",
        CurrentValue = Settings.OverrideCam,
        Flag         = "AimOverrideCam",
        Callback     = function(v) Settings.OverrideCam = v end,
    })

    AimTab:CreateSection("Input")

    AimTab:CreateDropdown({
        Name           = "Aim Key",
        Options        = AimKeyOptions,
        CurrentOption  = { "Right Mouse" },
        MultipleOptions = false,
        Flag           = "AimKeyDropdown",
        Callback       = function(Option)
            local name = type(Option) == "table" and Option[1] or Option
            local mapped = AimKeyMap[name]
            if mapped then
                Settings.AimKey = mapped
                Notify("Aim key set to " .. name)
            end
        end,
    })

    ESPTab:CreateSection("Visuals")

    ESPTab:CreateToggle({
        Name         = "Master ESP",
        CurrentValue = Settings.ESPEnabled,
        Flag         = "ESPEnabled",
        Callback     = function(v) Settings.ESPEnabled = v end,
    })

    ESPTab:CreateToggle({
        Name         = "Boxes",
        CurrentValue = Settings.ESPBoxes,
        Flag         = "ESPBoxes",
        Callback     = function(v) Settings.ESPBoxes = v end,
    })

    ESPTab:CreateToggle({
        Name         = "Tracers",
        CurrentValue = Settings.ESPTracers,
        Flag         = "ESPTracers",
        Callback     = function(v) Settings.ESPTracers = v end,
    })

    ESPTab:CreateToggle({
        Name         = "Player Info",
        CurrentValue = Settings.ESPInfo,
        Flag         = "ESPInfo",
        Callback     = function(v) Settings.ESPInfo = v end,
    })

    ESPTab:CreateToggle({
        Name         = "Draw FOV Circle",
        CurrentValue = Settings.ESPDrawFOV,
        Flag         = "ESPDrawFOV",
        Callback     = function(v) Settings.ESPDrawFOV = v end,
    })

    ESPTab:CreateSlider({
        Name         = "Max Distance",
        Range        = { 50, 5000 },
        Increment    = 10,
        Suffix       = "studs",
        CurrentValue = Settings.ESPMaxDist,
        Flag         = "ESPMaxDist",
        Callback     = function(v) Settings.ESPMaxDist = v end,
    })

    ESPTab:CreateSlider({
        Name         = "Box Scale",
        Range        = { 0.5, 3.0 },
        Increment    = 0.1,
        Suffix       = "x",
        CurrentValue = Settings.ESPBoxScale,
        Flag         = "ESPBoxScale",
        Callback     = function(v) Settings.ESPBoxScale = v end,
    })

    HitboxTab:CreateSection("Hitbox Expander")

    HitboxTab:CreateToggle({
        Name         = "Enable Hitbox Expander",
        CurrentValue = Settings.HitboxEnabled,
        Flag         = "HitboxEnabled",
        Callback     = function(v)
            Settings.HitboxEnabled = v
            Notify("Hitbox: " .. tostring(v))
        end,
    })

    HitboxTab:CreateSlider({
        Name         = "Hitbox Size",
        Range        = { 1, 30 },
        Increment    = 0.5,
        Suffix       = "studs",
        CurrentValue = Settings.HitboxSize,
        Flag         = "HitboxSize",
        Callback     = function(v) Settings.HitboxSize = v end,
    })

    HitboxTab:CreateSlider({
        Name         = "Hitbox Visibility",
        Range        = { 0, 1 },
        Increment    = 0.1,
        Suffix       = "",
        CurrentValue = Settings.HitboxTransparency,
        Flag         = "HitboxTransparency",
        Callback     = function(v) Settings.HitboxTransparency = v end,
    })

    GunTab:CreateSection("Recursive Gun Giver")
    GunTab:CreateLabel("Scans ReplicatedStorage.GunModels recursively for Tools.")

    local gunList, gunMap = {}, {}
    do
        local folder = ReplicatedStorage:FindFirstChild("GunModels")
        if folder then
            for _, entry in ipairs(RecursiveFindTools(folder, "GunModels.")) do
                table.insert(gunList, entry.Path)
                gunMap[entry.Path] = entry.Tool
            end
        end
    end

    local gunOptions = (#gunList > 0) and gunList or { "<No guns found>" }
    local selectedGun = gunList[1]

    GunTab:CreateDropdown({
        Name            = "Select Gun",
        Options         = gunOptions,
        CurrentOption   = { gunOptions[1] },
        MultipleOptions = false,
        Flag            = "GunSelect",
        Callback        = function(Option)
            selectedGun = type(Option) == "table" and Option[1] or Option
        end,
    })

    GunTab:CreateButton({
        Name     = "Give Selected Gun",
        Callback = function()
            if not selectedGun or not gunMap[selectedGun] then
                Notify("No gun selected!")
                return
            end
            GiveTool(gunMap[selectedGun], selectedGun)
        end,
    })

    GunTab:CreateButton({
        Name     = "Give ALL Guns",
        Callback = function()
            if #gunList == 0 then
                Notify("No guns found in GunModels.")
                return
            end
            for path, tool in pairs(gunMap) do
                GiveTool(tool, path)
            end
        end,
    })

    GunTab:CreateButton({
        Name     = "Refresh Gun List",
        Callback = function()
            Notify("Rescanning GunModels...")
            ReloadUI()
        end,
    })

    MiscTab:CreateSection("General")

    MiscTab:CreateToggle({
        Name         = "Notifications",
        CurrentValue = Settings.Notifications,
        Flag         = "Notifications",
        Callback     = function(v) Settings.Notifications = v end,
    })

    MiscTab:CreateButton({
        Name     = "Join Discord",
        Callback = function()
            local link = "https://discord.gg/fuECzR3dM3"
            local success, err = pcall(function()
                setclipboard(link)
            end)
            if success then
                Notify("Copied to Clipboard")
            else
                Notify("Failed to copy: " .. tostring(err))
            end
        end,
    })

    MiscTab:CreateButton({
        Name     = "Unload Script",
        Callback = function()
            ScriptActive = false

            for _, p in ipairs(Players:GetPlayers()) do
                RemoveESP(p)
                local char = p.Character
                if char then
                    local old = char:FindFirstChild("DevHitbox")
                    if old then old:Destroy() end
                end
            end

            pcall(function() FOVDraw:Remove() end)
            pcall(function() TargetDraw:Remove() end)

            Notify("Unloaded.")
            task.wait(0.2)
            pcall(function() Rayfield:Destroy() end)
        end,
    })

    pcall(function() Rayfield:LoadConfiguration() end)
end

BuildUI()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not ScriptActive then return end

    if input.KeyCode == Settings.AimKey or input.UserInputType == Settings.AimKey then
        HoldingAim = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Settings.AimKey or input.UserInputType == Settings.AimKey then
        HoldingAim   = false
        CurrentTarget = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if not ScriptActive then return end

    if not Camera or not Camera.Parent then
        Camera = Workspace:FindFirstChild("CustomCamera")
        if not Camera or not Camera:IsA("Camera") then
            Camera = Workspace.CurrentCamera
        end
    end
    if not Camera then return end

    if Settings.ESPDrawFOV then
        FOVDraw.Position = Camera.ViewportSize / 2
        FOVDraw.Radius   = Settings.FOV
        FOVDraw.Visible  = true
    else
        FOVDraw.Visible = false
    end

    if Settings.AimEnabled and HoldingAim then
        local valid = false

        if CurrentTarget then
            local char = CurrentTarget.Player.Character
            local part = char and GetAimPart(char)
            if part and IsAlive(char) and IsTargetValid(CurrentTarget.Player) then
                local aimPos = GetAimPosition(part)
                local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
                if onScreen then
                    local sd = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize / 2).Magnitude
                    if sd <= Settings.FOV and IsVisible(char, aimPos) then
                        valid = true
                        CurrentTarget.Part     = part
                        CurrentTarget.Position = pos
                        CurrentTarget.Distance = (part.Position - Camera.CFrame.Position).Magnitude
                    end
                end
            end
        end

        if not valid then
            CurrentTarget = Settings.AutoSwitch and GetClosestPlayer() or nil
        end

        if CurrentTarget then
            local part   = CurrentTarget.Part
            local aimPos = GetAimPosition(part)

            if Settings.OverrideCam then
                Camera.CameraType = Enum.CameraType.Scriptable
            end

            local targetCF = CFrame.new(Camera.CFrame.Position, aimPos)
            if Settings.Smoothness >= 0.99 then
                Camera.CFrame = targetCF
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Smoothness)
            end

            local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
            if onScreen then
                TargetDraw.Position = Vector2.new(pos.X, pos.Y)
                TargetDraw.Radius   = math.clamp(500 / pos.Z, 5, 30)
                TargetDraw.Visible  = true
            else
                TargetDraw.Visible = false
            end

            if not CurrentTarget.Notified then
                CurrentTarget.Notified = true
                Notify("Locked: " .. CurrentTarget.Player.Name ..
                       " | " .. math.floor(CurrentTarget.Distance) .. " studs")
            end
        else
            TargetDraw.Visible = false
        end
    else
        CurrentTarget      = nil
        TargetDraw.Visible = false
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local data = GetESP(player)
            data.Box.Visible    = false
            data.Tracer.Visible = false
            data.Info.Visible   = false

            if Settings.ESPEnabled then
                local char = player.Character
                local part = char and GetAimPart(char)
                if part and IsAlive(char) and IsTargetValid(player) then
                    local dist = (part.Position - Camera.CFrame.Position).Magnitude
                    if dist <= Settings.ESPMaxDist then
                        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local screenPos = Vector2.new(pos.X, pos.Y)
                            local hp, maxHp = GetHealth(char)
                            local locked    = CurrentTarget and CurrentTarget.Player == player

                            if Settings.ESPTracers then
                                data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                data.Tracer.To   = screenPos
                                data.Tracer.Color = locked and Color3.fromRGB(255, 0, 0)
                                                             or Color3.fromRGB(255, 255, 255)
                                data.Tracer.Transparency = locked and 1 or 0.6
                                data.Tracer.Visible = true
                            end

                            if Settings.ESPBoxes then
                                local scale = math.clamp(1500 / pos.Z, 40, 200) * Settings.ESPBoxScale
                                data.Box.Size     = Vector2.new(scale * 0.65, scale)
                                data.Box.Position = screenPos - data.Box.Size / 2
                                data.Box.Color    = locked and Color3.fromRGB(255, 0, 0)
                                                             or Color3.fromRGB(0, 255, 100)
                                data.Box.Visible  = true
                            end

                            if Settings.ESPInfo then
                                data.Info.Position = screenPos - Vector2.new(0, 40)
                                data.Info.Text     = player.Name .. "\nHP:" .. hp .. "/" .. maxHp ..
                                                     " | " .. math.floor(dist) .. " studs"
                                data.Info.Color    = locked and Color3.fromRGB(255, 200, 50)
                                                             or Color3.fromRGB(255, 255, 255)
                                data.Info.Visible  = true
                            end
                        end
                    end
                end
            end
        end
    end

    if Settings.HitboxEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local expander = char:FindFirstChild("DevHitbox")
                        if not expander then
                            expander = Instance.new("Part")
                            expander.Name       = "DevHitbox"
                            expander.Shape      = Enum.PartType.Ball
                            expander.Material   = Enum.Material.ForceField
                            expander.Color      = Color3.fromRGB(255, 0, 0)
                            expander.CanCollide = false
                            expander.Anchored   = false
                            expander.Parent     = char

                            local weld = Instance.new("Weld", expander)
                            weld.Part0 = hrp
                            weld.Part1 = expander
                        end
                        expander.Size = Vector3.new(
                            Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize
                        )
                        expander.Transparency = 1 - Settings.HitboxTransparency
                    end
                end
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local old = char:FindFirstChild("DevHitbox")
                    if old then old:Destroy() end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    if CurrentTarget and CurrentTarget.Player == player then
        CurrentTarget = nil
    end
end)

Notify("Void Scripts Loaded | FluxoPVP Edition")
