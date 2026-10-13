-- Robust Rayfield loading with fallback
local Rayfield = nil
local rayfieldSources = {
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    "https://sirius.menu"
}

for _, url in ipairs(rayfieldSources) do
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and result then
        Rayfield = result
        break
    end
end

if not Rayfield then
    warn("Failed to load Rayfield UI library.")
    return
end

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")

local Window = Rayfield:CreateWindow({
    Name = "Script Of J — Delta Premium Pro",
    LoadingTitle = "Script Of J",
    LoadingSubtitle = "Delta Mobile Edition v2.5",
    ConfigurationSaving = {Enabled = true, FolderName = "ScriptOfJ_Config", FileName = "DoorsProfile"},
    Discord = {Enabled = false},
    Keybind = "RightShift",
    ShowText = "Tap to Toggle UI",
    ToggleSide = "Left",
    CustomToggleIcon = "rbxassetid://10723346513"
})

local Flags = {
    Speed = false, SpeedVal = 21, Noclip = false, Fullbright = false,
    ESP = false, InstantInteract = false, MonsterAlert = false,
    LootESP = false, AutoHide = false, AntiScreech = false, AntiA90 = false,
    AutoRooms = false
}
local InCloset = false
local trackedHighlights = {}
local entityTracers = {} -- store tracers for entities

-- Store original lighting values for restoration
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

-- Clean up highlights and tracers
local function ClearESP()
    for obj, hl in pairs(trackedHighlights) do
        if hl and hl.Parent then hl:Destroy() end
    end
    trackedHighlights = {}

    -- Remove all tracers
    for _, tracer in pairs(entityTracers) do
        if tracer then
            tracer:Remove()
        end
    end
    entityTracers = {}
end

-- Function to create a tracer line from player to entity
local function CreateTracer(target)
    if not target or not target:IsA("BasePart") and not target:IsA("Model") then return end
    local targetPart = target:IsA("Model") and target.PrimaryPart or target
    if not targetPart then return end

    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Transparency = 0.8
    tracer.Visible = true
    tracer.From = Vector2.new(0, 0)
    tracer.To = Vector2.new(0, 0)
    return tracer
end

-- Update tracers each frame (called from RenderStepped)
local function UpdateTracers()
    for target, tracer in pairs(entityTracers) do
        if target and target.Parent and target:IsA("Model") and target.PrimaryPart then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(target.PrimaryPart.Position)
                if onScreen then
                    local screenPosPlayer = Workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                    tracer.From = Vector2.new(screenPosPlayer.X, screenPosPlayer.Y)
                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            end
        elseif target and target.Parent and target:IsA("BasePart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(target.Position)
                if onScreen then
                    local screenPosPlayer = Workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                    tracer.From = Vector2.new(screenPosPlayer.X, screenPosPlayer.Y)
                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            end
        else
            tracer:Remove()
            entityTracers[target] = nil
        end
    end
end

-- Efficiently handle render loop adjustments
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- Safe Speed Bypass (Velocity method, more undetectable)
    if Flags.Speed and hum and root then
        if hum.MoveDirection.Magnitude > 0 then
            root.Velocity = hum.MoveDirection * Flags.SpeedVal
        end
    end

    -- Anti-A90 Implementation
    if Flags.AntiA90 and LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI:FindFirstChild("A90") then
        if LocalPlayer.PlayerGui.MainUI.A90.Visible == true and root then
            root.Velocity = Vector3.new(0,0,0)
        end
    end

    -- Optimized Noclip
    if Flags.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    -- Fullbright Engine (save and restore all values)
    if Flags.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.GlobalShadows = originalLighting.GlobalShadows
    end

    -- Update tracers if MonsterAlert ESP is on
    if Flags.MonsterAlert then
        UpdateTracers()
    end
end)

-- Safe Throttle-controlled Interactor
task.spawn(function()
    while true do
        task.wait(0.2)
        if Flags.InstantInteract and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent:IsA("BasePart") then
                    local dist = (prompt.Parent.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= prompt.MaxActivationDistance then
                        fireproximityprompt(prompt)
                        task.wait(0.05)
                    end
                end
            end
        end
    end
end)

-- Auto Rooms Completion Thread
task.spawn(function()
    while true do
        task.wait(0.5)
        if Flags.AutoRooms and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and not InCloset then
            local latestRoom = Workspace:FindFirstChild("CurrentRoom") or Workspace:FindFirstChild("Rooms")
            if latestRoom then
                for _, target in ipairs(latestRoom:GetDescendants()) do
                    if target.Name == "Door" and target:IsA("BasePart") then
                        local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if not prompt and target.Parent then
                            prompt = target.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
                        end
                        local rootPart = LocalPlayer.Character.HumanoidRootPart

                        local danger = Workspace:FindFirstChild("RushMoving") or Workspace:FindFirstChild("AmbushMoving")
                        if not danger then
                            rootPart.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            task.wait(0.8)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Anti-Screech: search and destroy screech objects globally
task.spawn(function()
    while true do
        task.wait(0.1)
        if Flags.AntiScreech then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name == "Screech" or obj.Name == "ScreechPart" then
                    obj:Destroy()
                    Rayfield:Notify({Title = "🤫 SCREECH DEFLECTED", Content = "Screech was instantly silenced.", Duration = 2, Image = "activity"})
                end
            end
            -- Also check PlayerGui for Screech UI
            if LocalPlayer.PlayerGui then
                for _, guiObj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if guiObj.Name == "Screech" then
                        guiObj:Destroy()
                    end
                end
            end
        end
    end
end)

local function TriggerAutoHide(monsterName)
    if InCloset or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Wardrobe" or obj.Name == "Closet" then
            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                local hideCFrame = nil
                if obj:IsA("Model") and obj.PrimaryPart then
                    hideCFrame = obj.PrimaryPart.CFrame
                elseif obj:IsA("BasePart") then
                    hideCFrame = obj.CFrame
                end

                if hideCFrame then
                    InCloset = true
                    Rayfield:Notify({Title = "🔒 AUTO-HIDING", Content = "Hiding from: " .. monsterName, Duration = 4, Image = "activity"})
                    LocalPlayer.Character.HumanoidRootPart.CFrame = hideCFrame
                    task.wait(0.1)
                    fireproximityprompt(prompt)
                end
                break
            end
        end
    end
end

local function SolveLibrary()
    local lib = Workspace:FindFirstChild("Room_50") or Workspace:FindFirstChild("50")
    if not lib then
        Rayfield:Notify({Title = "Error", Content = "You are not in Room 50!", Duration = 3, Image = "activity"})
        return
    end
    local padLock = lib:FindFirstChild("Padlock", true)
    if padLock and padLock:FindFirstChild("Code") then
        local code = padLock.Code.Value
        local codeStr = tostring(code)
        if codeStr and codeStr ~= "" then
            Rayfield:Notify({Title = "📚 CODE SOLVED", Content = "The Lock Code is: " .. codeStr, Duration = 10, Image = "activity"})
            local prompt = padLock:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then fireproximityprompt(prompt) end
        else
            Rayfield:Notify({Title = "Solver Info", Content = "Books haven't loaded data values yet.", Duration = 4, Image = "activity"})
        end
    end
end

-- Streamlined ESP Engine (performance note: scanning every 1.2s is acceptable for most maps)
local function ProcessESP()
    if not (Flags.ESP or Flags.LootESP or Flags.MonsterAlert) then ClearESP() return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            -- Base ESP: Doors, Keys, Drawers
            if Flags.ESP then
                local isHighlightTarget = false
                if obj.Name == "Door" or obj.Name == "DrawerContainer" then
                    isHighlightTarget = true
                elseif obj.Name == "Key" or obj.Name == "KeyPart" or obj.Name == "KeyHole" then
                    isHighlightTarget = true
                end

                if isHighlightTarget and not trackedHighlights[obj] and not obj:FindFirstChild("ESPHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight"
                    hl.FillColor = (obj.Name == "Key" or obj.Name == "KeyPart" or obj.Name == "KeyHole") 
                        and Color3.new(1, 1, 0) 
                        or Color3.new(0, 0, 1)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.Parent = obj
                    trackedHighlights[obj] = hl
                end
            end

            -- Loot ESP: Gold, Books, etc.
            if Flags.LootESP then
                if obj.Name == "GoldPile" or obj.Name == "LiveHintBook" or string.find(string.lower(obj.Name), "gold") or obj.Name == "Book" then
                    if not trackedHighlights[obj] and not obj:FindFirstChild("ESPHighlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESPHighlight"
                        hl.FillColor = Color3.fromRGB(30, 215, 96)
                        hl.FillTransparency = 0.4
                        hl.Parent = obj
                        trackedHighlights[obj] = hl
                    end
                end
            end

            -- Monster Alert + ESP with tracers
            if Flags.MonsterAlert then
                if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" or obj.Name == "Rush" or obj.Name == "Ambush" or obj.Name == "SeekMoving" then
                    -- Notify and highlight
                    if not trackedHighlights[obj] and not obj:FindFirstChild("ESPHighlight") then
                        Rayfield:Notify({Title = "⚠️ ENTITY BLITZ!", Content = obj.Name .. " is active!", Duration = 5, Image = "activity"})
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESPHighlight"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.FillTransparency = 0.2
                        hl.Parent = obj
                        trackedHighlights[obj] = hl
                    end
                    -- Create tracer if not exists
                    if not entityTracers[obj] then
                        local tracer = CreateTracer(obj)
                        if tracer then
                            entityTracers[obj] = tracer
                        end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        ProcessESP()
        task.wait(1.2)
    end
end)

-- Save/Load configuration functions using executor's file system (if available)
local function SaveConfiguration()
    local data = {}
    for flagName, value in pairs(Flags) do
        data[flagName] = value
    end
    -- Also include slider value (SpeedVal) is already in Flags
    if writefile then
        writefile("ScriptOfJ_Config/DoorsProfile.json", game:GetService("HttpService"):JSONEncode(data))
        Rayfield:Notify({Title = "💾 Configuration Saved", Content = "Settings have been saved.", Duration = 3, Image = "activity"})
    else
        Rayfield:Notify({Title = "Error", Content = "File system not available.", Duration = 3, Image = "activity"})
    end
end

local function LoadConfiguration()
    if readfile and isfile and isfile("ScriptOfJ_Config/DoorsProfile.json") then
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("ScriptOfJ_Config/DoorsProfile.json"))
        end)
        if success and result then
            for flagName, value in pairs(result) do
                if Flags[flagName] ~= nil then
                    Flags[flagName] = value
                end
            end
            Rayfield:Notify({Title = "📂 Configuration Loaded", Content = "Settings have been loaded.", Duration = 3, Image = "activity"})
        else
            Rayfield:Notify({Title = "Error", Content = "Failed to load configuration.", Duration = 3, Image = "activity"})
        end
    else
        Rayfield:Notify({Title = "No Config Found", Content = "No saved configuration exists.", Duration = 3, Image = "activity"})
    end
end

-- UI Setup Creation
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateSection("Script Status")
HomeTab:CreateLabel("Status: Active & Secure")
HomeTab:CreateLabel("Version: Ultimate Automation Build")
HomeTab:CreateButton({
    Name = "Join the Discord Server!",
    Callback = function()
        -- Copy link to clipboard and try to open browser
        if setclipboard then setclipboard("https://discord.gg/wZkYuPMkdb") end
        if GuiService then
            GuiService:OpenBrowserWindow("https://discord.gg/wZkYuPMkdb")
        end
        Rayfield:Notify({Title = "Discord", Content = "Opening Discord invite...", Duration = 3, Image = "activity"})
    end
})

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Movement & Interaction")
MainTab:CreateToggle({
    Name = "Enable Safe Speed Bypass",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value) Flags.Speed = Value end
})
MainTab:CreateSlider({
    Name = "WalkSpeed Amount",
    Range = {16, 45},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 21,
    Flag = "WalkSpeedVal",
    Callback = function(Value) Flags.SpeedVal = Value end
})
MainTab:CreateToggle({
    Name = "Noclip (Walk Through Walls)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value) Flags.Noclip = Value end
})
MainTab:CreateToggle({
    Name = "Instant Interact (Auto-Loot)",
    CurrentValue = false,
    Flag = "InstantInteract",
    Callback = function(V) Flags.InstantInteract = V end
})
MainTab:CreateSection("Automated Complete Engines")
MainTab:CreateToggle({
    Name = "Auto-Walk/Complete Rooms",
    CurrentValue = false,
    Flag = "AutoRoomsToggle",
    Callback = function(V) Flags.AutoRooms = V end
})
MainTab:CreateSection("Automated Protections")
MainTab:CreateToggle({
    Name = "Auto-Hide In Closets",
    CurrentValue = false,
    Flag = "AutoHideToggle",
    Callback = function(V) Flags.AutoHide = V end
})
MainTab:CreateToggle({
    Name = "Anti-Screech Deflect",
    CurrentValue = false,
    Flag = "AntiScreech",
    Callback = function(V) Flags.AntiScreech = V end
})
MainTab:CreateToggle({
    Name = "Anti-A90 Freeze",
    CurrentValue = false,
    Flag = "AntiA90",
    Callback = function(V) Flags.AntiA90 = V end
})
MainTab:CreateButton({
    Name = "Instant Solve Room 50 Lock",
    Callback = function() SolveLibrary() end
})

local VisualsTab = Window:CreateTab("Visuals", 4483362458)
VisualsTab:CreateSection("ESP Options")
VisualsTab:CreateToggle({
    Name = "Base ESP (Doors & Keys)",
    CurrentValue = false,
    Flag = "EspMain",
    Callback = function(V) Flags.ESP = V if not V then ClearESP() end end
})
VisualsTab:CreateToggle({
    Name = "Loot ESP (Gold & Books)",
    CurrentValue = false,
    Flag = "EspLoot",
    Callback = function(V) Flags.LootESP = V if not V then ClearESP() end end
})
VisualsTab:CreateToggle({
    Name = "Monster Alerts & ESP (with Tracers)",
    CurrentValue = false,
    Flag = "MonsterAlertsToggle",
    Callback = function(V)
        Flags.MonsterAlert = V
        if not V then
            -- Remove tracers when disabled
            for _, tracer in pairs(entityTracers) do
                tracer:Remove()
            end
            entityTracers = {}
        end
    end
})
VisualsTab:CreateToggle({
    Name = "Fullbright Engine",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(V)
        Flags.Fullbright = V
    end
})

local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("Interface Theme")
SettingsTab:CreateColorPicker({
    Name = "Accent Color",
    Color = Color3.fromRGB(44, 120, 224),
    Flag = "ThemeAccent",
    Callback = function(Value)
        -- Use Rayfield's UpdateTheme (not Window)
        if Rayfield.UpdateTheme then
            Rayfield:UpdateTheme({Accent = Value})
        end
    end
})
SettingsTab:CreateSection("Configuration")
SettingsTab:CreateButton({
    Name = "Save Configuration",
    Callback = SaveConfiguration
})
SettingsTab:CreateButton({
    Name = "Load Configuration",
    Callback = LoadConfiguration
})

Rayfield:Notify({
    Title = "Script Of J — Delta Premium Pro",
    Content = "Loaded v2.5 successfully!",
    Duration = 6,
    Image = "activity"
})