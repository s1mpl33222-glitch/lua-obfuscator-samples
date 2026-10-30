-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 1: CORE INITS ]
-- ==========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
 
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
local Mouse = LocalPlayer:GetMouse()
 
shared.KosikConfig = shared.KosikConfig or { 
    Aim = { Enabled = false, Smoothness = 0.01, Fov = 350, TargetPart = "Head", VisibleCheck = true, IgnoreTeam = true, Prediction = true, PredictionFactor = 0.05, Mode = "RMB", ShowFov = true, Aim360 = false }, 
    Trigger = { Enabled = false, Delay = 0.01, Mode = "RMB" }, 
    Visuals = { Boxes = false, Health = false, NameEsp = false, Skeleton = false, MaxDistance = 800, FontSize = 18, BoxColor = {255, 0, 0, 255}, TextColor = {255, 255, 255, 255}, FovColor = {255, 255, 255, 255} }, 
    Environment = { WorldColorEnabled = true, WorldColor = {255, 0, 0, 255}, WorldIntensity = 1.0, WorldRGB = false, DarkMode = false, DarkModeIntensity = 0.5, WeatherMode = "None", WeatherCount = 100, WeatherSpeed = 10, WeatherThickness = 2, WeatherOpacity = 0.6, WeatherColor = {130, 134, 140, 255} }, 
    Rage = { Fly = false, FlySpeed = 150, NoClip = false, AntiAim = false, AirSpeedEnabled = false, AirSpeedValue = 50, QRageEnabled = false, ScytheSpeedEnabled = false }, 
    Crosshair = { Enabled = false, Size = 15, Gap = 4, Thickness = 2, Spin = false, SpinSpeed = 5, RGB = false, Color = {0, 255, 255, 255} }, 
    UI = { MenuColor = Color3.fromRGB(15, 15, 15), AccentColor = Color3.fromRGB(0, 122, 255) }
}
local Config = shared.KosikConfig
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 2: IO & COLOR PARSER ]
-- ==========================================================
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local OriginalColorShift = Lighting.ColorShift_Top
local OriginalFogColor = Lighting.FogColor
local OriginalBrightness = Lighting.Brightness
local OriginalExposure = Lighting.ExposureCompensation
 
local ConfigFile = "Kosik_Rivals_V320_Final.json"
local function SaveSettings() 
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end)
end
shared.KosikSaveSettings = SaveSettings
 
pcall(function() 
    if isfile and isfile(ConfigFile) then 
        local decoded = HttpService:JSONDecode(readfile(ConfigFile)) 
        for k, v in pairs(decoded) do 
            if type(v) == "table" then for k2, v2 in pairs(v) do Config[k][k2] = v2 end else Config[k] = v end 
        end 
    end
end)
 
shared.GetColorFromArray = function(arr) 
    if not arr or type(arr) ~= "table" then return Color3.fromRGB(255,255,255), 1 end 
    local r = arr[1] or arr["R"] or arr["r"] or 255
    local g = arr[2] or arr["G"] or arr["g"] or 255
    local b = arr[3] or arr["B"] or arr["b"] or 255
    local a = arr[4] or arr["A"] or arr["a"] or 255
    return Color3.fromRGB(r, g, b), (a / 255)
end
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 3: SMART SELECTION ]
-- ==========================================================
local function CheckVisibility(part) 
    if not Config.Aim.VisibleCheck or Config.Aim.Aim360 then return true end 
    local params = RaycastParams.new() 
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}; params.FilterType = Enum.RaycastFilterType.Exclude 
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params) 
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end
 
shared.GetClosest3DTarget = function() 
    local bestTarget, maxDist = nil, Config.Aim.Fov 
    local screenCenter = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5) 
    
    for _, player in pairs(Players:GetPlayers()) do 
        if player ~= LocalPlayer and player.Character and (not Config.Aim.IgnoreTeam or player.Team ~= LocalPlayer.Team) then 
            local char = player.Character 
            local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") 
            local hum = char:FindFirstChildOfClass("Humanoid") 
            if part and hum and hum.Health > 0 then 
                if Config.Aim.Aim360 or (Config.Rage.QRageEnabled and UIS:IsKeyDown(Enum.KeyCode.Q)) then 
                    local dist3d = (Camera.CFrame.Position - part.Position).Magnitude 
                    if dist3d < maxDist then bestTarget = part; maxDist = dist3d end 
                else 
                    local vector, onScreen = Camera:WorldToViewportPoint(part.Position) 
                    if onScreen and vector.Z > 0 then 
                        local mag = (Vector2.new(vector.X, vector.Y) - screenCenter).Magnitude 
                        if mag < maxDist and CheckVisibility(part) then bestTarget = part; maxDist = mag end 
                    end 
                end 
            end 
        end 
    end 
    return bestTarget
end
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 4: FRAMEWORK CORE ]
-- ==========================================================
shared.KosikScreenGui = CoreGui:FindFirstChild("KosikRivalsGui") or Instance.new("ScreenGui", CoreGui)
shared.KosikScreenGui.Name = "KosikRivalsGui"; shared.KosikScreenGui.ResetOnSpawn = false
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 640, 0, 440); MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220); MainFrame.BackgroundColor3 = Config.UI.MenuColor; MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Parent = shared.KosikScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12); Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 55)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 24); Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
local TopLogo = Instance.new("TextLabel", Sidebar)
TopLogo.Size = UDim2.new(1, 0, 0, 35); TopLogo.Position = UDim2.new(0, 0, 0, 10); TopLogo.Text = "KOSIK RIVALS        TG:@DR66T"; TopLogo.TextColor3 = Config.UI.AccentColor; TopLogo.Font = Enum.Font.GothamBold; TopLogo.TextSize = 10; TopLogo.BackgroundTransparency = 1
local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -80); TabContainer.Position = UDim2.new(0, 0, 0, 70); TabContainer.BackgroundTransparency = 1; local TabListLayout = Instance.new("UIListLayout", TabContainer); TabListLayout.Padding = UDim.new(0, 6); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -180, 1, -20); PageContainer.Position = UDim2.new(0, 170, 0, 10); PageContainer.BackgroundTransparency = 1
 
local Pages, TabButtons = {}, {}
shared.KosikCreatePage = function(name) 
    local p = Instance.new("ScrollingFrame", PageContainer); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0, 0, 0, 0); p.ScrollBarThickness = 4; p.ScrollBarImageColor3 = Config.UI.AccentColor; p.Visible = false 
    local layout = Instance.new("UIListLayout", p); layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; Pages[name] = p 
    local btn = Instance.new("TextButton", TabContainer); btn.Size = UDim2.new(0, 140, 0, 36); btn.BackgroundColor3 = Color3.fromRGB(26, 26, 30); btn.Text = "  " .. name; btn.TextColor3 = Color3.fromRGB(160, 160, 160); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6); local bStroke = Instance.new("UIStroke", btn); bStroke.Color = Color3.fromRGB(35, 35, 40); TabButtons[name] = {Btn = btn, Stroke = bStroke} 
    btn.MouseButton1Click:Connect(function() for pageName, pageFrame in pairs(Pages) do pageFrame.Visible = (pageName == name) end; for btnName, data in pairs(TabButtons) do if btnName == name then data.Btn.TextColor3 = Color3.new(1, 1, 1); data.Stroke.Color = Config.UI.AccentColor else data.Btn.TextColor3 = Color3.fromRGB(160, 160, 160); data.Stroke.Color = Color3.fromRGB(35, 35, 40) end end end); return p
end
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.F4 then MainFrame.Visible = not MainFrame.Visible end end)
 
shared.KosikAddInlineColorPicker = function(page, text, configTable, configKey) 
    local baseFrame = Instance.new("Frame", page); baseFrame.Size = UDim2.new(0, 420, 0, 150); baseFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26); Instance.new("UICorner", baseFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", baseFrame).Color = Color3.fromRGB(35, 35, 40)
    local title = Instance.new("TextLabel", baseFrame); title.Size = UDim2.new(1, -20, 0, 25); title.Position = UDim2.new(0, 12, 0, 4); title.Text = text .. " (RGBA)"; title.TextColor3 = Config.UI.AccentColor; title.Font = Enum.Font.GothamBold; title.TextSize = 12; title.TextXAlignment = 0; title.BackgroundTransparency = 1
    local rgbaData = configTable[configKey] or {255, 255, 255, 255}; local channels = { {Name = "Красный", Idx = 1}, {Name = "Зеленый", Idx = 2}, {Name = "Синий", Idx = 3}, {Name = "Прозрачность", Idx = 4} } 
    for i, ch in ipairs(channels) do 
        local row = Instance.new("Frame", baseFrame); row.Size = UDim2.new(1, -20, 0, 24); row.Position = UDim2.new(0, 10, 0, 25 + (i - 1) * 28); row.BackgroundTransparency = 1 
        local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0, 110, 1, 0); lbl.Text = ch.Name .. ": " .. rgbaData[ch.Idx]; lbl.TextColor3 = Color3.fromRGB(200, 200, 200); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1 
        local bar = Instance.new("Frame", row); bar.Size = UDim2.new(1, -130, 0, 6); bar.Position = UDim2.new(0, 120, 0.5, -3); bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
        local fill = Instance.new("Frame", bar); fill.Size = UDim2.new(rgbaData[ch.Idx] / 255, 0, 1, 0); fill.BackgroundColor3 = Config.UI.AccentColor; Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
        local trigger = Instance.new("TextButton", bar); trigger.Size = UDim2.new(1, 0, 3, 0); trigger.Position = UDim2.new(0, 0, -1, 0); trigger.BackgroundTransparency = 1; trigger.Text = ""; local active = false 
        trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then active = true end end); UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then active = false end end) 
        trigger.InputChanged:Connect(function(input) if active and input.UserInputType == Enum.UserInputType.MouseMovement then local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(pct, 0, 1, 0); local val = math.floor(pct * 255); lbl.Text = ch.Name .. ": " .. val; rgbaData[ch.Idx] = val; configTable[configKey] = rgbaData; if shared.KosikSaveSettings then shared.KosikSaveSettings() end end end) 
    end; page.CanvasSize = UDim2.new(0, 0, 0, page.UIListLayout.AbsoluteContentSize.Y + 30)
end
 
shared.KosikAddSlider = function(page, text, min, max, configTable, configKey) 
    local f = Instance.new("Frame", page); f.Size = UDim2.new(0, 420, 0, 50); f.BackgroundColor3 = Color3.fromRGB(24, 24, 28); Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", f).Color = Color3.fromRGB(35, 35, 40)
    local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(0.6, 0, 0, 24); lbl.Position = UDim2.new(0, 12, 0, 2); lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(220, 220, 220); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1 
    local valLbl = Instance.new("TextLabel", f); valLbl.Size = UDim2.new(0.3, 0, 0, 24); valLbl.Position = UDim2.new(1, -120, 0, 2); valLbl.Text = tostring(configTable[configKey]); valLbl.TextColor3 = Config.UI.AccentColor; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 12; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.BackgroundTransparency = 1
    local bar = Instance.new("Frame", f); bar.Size = UDim2.new(1, -24, 0, 6); bar.Position = UDim2.new(0, 12, 1, -14); bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3) 
    local currentPct = (configTable[configKey] - min) / (max - min); local fill = Instance.new("Frame", bar); fill.Size = UDim2.new(math.clamp(currentPct, 0, 1), 0, 1, 0); fill.BackgroundColor3 = Config.UI.AccentColor; Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3) 
    local trigger = Instance.new("TextButton", bar); trigger.Size = UDim2.new(1, 0, 3, 0); trigger.Position = UDim2.new(0, 0, -1, 0); trigger.BackgroundTransparency = 1; trigger.Text = ""; local active = false 
    trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then active = true end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then active = false end end) 
    trigger.InputChanged:Connect(function(i) if active and i.UserInputType == Enum.UserInputType.MouseMovement then local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(pct, 0, 1, 0); local val = min + (pct * (max - min)); if max > 5 then val = math.floor(val) end; valLbl.Text = string.format("%.2f", val):gsub("%.00", ""); configTable[configKey] = val; if shared.KosikSaveSettings then shared.KosikSaveSettings() end end end); page.CanvasSize = UDim2.new(0, 0, 0, page.UIListLayout.AbsoluteContentSize.Y + 20)
end
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 5: UI COMPONENTS ]
-- ==========================================================
shared.KosikAddToggle = function(page, text, configTable, configKey) 
    local f = Instance.new("Frame", page); f.Size = UDim2.new(0, 420, 0, 40); f.BackgroundColor3 = Color3.fromRGB(24, 24, 28); Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", f).Color = Color3.fromRGB(35, 35, 40)
    local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(0.7, 0, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(220, 220, 220); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1 
    local switch = Instance.new("TextButton", f); switch.Size = UDim2.new(0, 46, 0, 22); switch.Position = UDim2.new(1, -58, 0.5, -11); switch.BackgroundColor3 = configTable[configKey] and Config.UI.AccentColor or Color3.fromRGB(45, 45, 50); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(0, 11) 
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 16, 0, 16); circle.Position = UDim2.new(configTable[configKey] and 0.55 or 0.05, 0, 0.5, -8); circle.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 8) 
    switch.MouseButton1Click:Connect(function() 
        local state = not configTable[configKey]; configTable[configKey] = state; if shared.KosikSaveSettings then shared.KosikSaveSettings() end 
        TweenService:Create(switch, TweenInfo.new(0.18), {BackgroundColor3 = state and Config.UI.AccentColor or Color3.fromRGB(45, 45, 50)}):Play() 
        TweenService:Create(circle, TweenInfo.new(0.18), {Position = UDim2.new(state and 0.55 or 0.05, 0, 0.5, -8)}):Play() 
    end); page.CanvasSize = UDim2.new(0, 0, 0, page.UIListLayout.AbsoluteContentSize.Y + 20)
end
 
shared.KosikAddDropdown = function(page, text, list, configTable, configKey) 
    local f = Instance.new("Frame", page); f.Size = UDim2.new(0, 420, 0, 40); f.BackgroundColor3 = Color3.fromRGB(24, 24, 28); Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", f).Color = Color3.fromRGB(35, 35, 40)
    local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(0.5, 0, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(220, 220, 220); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1 
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 140, 0, 26); btn.Position = UDim2.new(1, -152, 0.5, -13); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); btn.Text = tostring(configTable[configKey]); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4) 
    
    btn.MouseButton1Click:Connect(function() 
        if shared.KosikScreenGui:FindFirstChild("KosikDropdownMenu") then shared.KosikScreenGui.KosikDropdownMenu:Destroy() end
        local dropFrame = Instance.new("Frame", shared.KosikScreenGui); dropFrame.Name = "KosikDropdownMenu"; dropFrame.Size = UDim2.new(0, 140, 0, #list * 28); dropFrame.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + 30); dropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UIStroke", dropFrame).Color = Config.UI.AccentColor; dropFrame.ZIndex = 20
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 4); Instance.new("UIListLayout", dropFrame)
        for _, val in pairs(list) do 
            local item = Instance.new("TextButton", dropFrame); item.Size = UDim2.new(1, 0, 0, 28); item.ZIndex = 21; item.BackgroundColor3 = Color3.fromRGB(30, 30, 35); item.Text = tostring(val); item.TextColor3 = Color3.fromRGB(220, 220, 220); item.Font = Enum.Font.Gotham; item.TextSize = 11; item.BorderSizePixel = 0; item.Visible = true
            item.MouseButton1Click:Connect(function() configTable[configKey] = val; btn.Text = tostring(val); dropFrame:Destroy(); if shared.KosikSaveSettings then shared.KosikSaveSettings() end end)
        end
        local closeDetect; closeDetect = UIS.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then task.wait(0.1) if dropFrame and dropFrame.Parent and (UIS:GetMouseLocation() - Vector2.new(dropFrame.AbsolutePosition.X + 70, dropFrame.AbsolutePosition.Y + (dropFrame.AbsoluteSize.Y/2))).Magnitude > 160 then dropFrame:Destroy(); closeDetect:Disconnect() end end end)
    end); page.CanvasSize = UDim2.new(0, 0, 0, page.UIListLayout.AbsoluteContentSize.Y + 20)
end
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 6: BOOTING TABS 1 ]
-- ==========================================================
local AimbotPage = shared.KosikCreatePage("Aimbot")
shared.KosikAddToggle(AimbotPage, "Включить Аимбот", Config.Aim, "Enabled")
shared.KosikAddDropdown(AimbotPage, "Режим Активации", {"RMB", "Always"}, Config.Aim, "Mode")
shared.KosikAddDropdown(AimbotPage, "Цель (Bone)", {"Head", "HumanoidRootPart"}, Config.Aim, "TargetPart")
shared.KosikAddToggle(AimbotPage, "Проверка видимости", Config.Aim, "VisibleCheck")
shared.KosikAddToggle(AimbotPage, "Игнорировать команду", Config.Aim, "IgnoreTeam")
shared.KosikAddToggle(AimbotPage, "Векторное Упреждение", Config.Aim, "Prediction")
shared.KosikAddSlider(AimbotPage, "Фактор предсказания", 0.01, 0.2, Config.Aim, "PredictionFactor")
shared.KosikAddSlider(AimbotPage, "Плавность (Меньше = Резче)", 0, 0.95, Config.Aim, "Smoothness")
shared.KosikAddSlider(AimbotPage, "Радиус захвата FOV", 10, 800, Config.Aim, "Fov")
shared.KosikAddToggle(AimbotPage, "Отображать круг FOV", Config.Aim, "ShowFov")
shared.KosikAddToggle(AimbotPage, "Режим Аим 360", Config.Aim, "Aim360")

local TriggerPage = shared.KosikCreatePage("Triggerbot")
shared.KosikAddToggle(TriggerPage, "Включить Авто-Шот (Trigger)", Config.Trigger, "Enabled")
shared.KosikAddDropdown(TriggerPage, "Режим Активации Триггера", {"RMB", "Always"}, Config.Trigger, "Mode")
shared.KosikAddSlider(TriggerPage, "Задержка выстрела (сек)", 0.01, 1, Config.Trigger, "Delay")
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 7: BOOTING TABS 2 ]
-- ==========================================================
local VisualsPage = shared.KosikCreatePage("Visuals")
shared.KosikAddToggle(VisualsPage, "Квадраты (Boxes)", Config.Visuals, "Boxes")
shared.KosikAddToggle(VisualsPage, "Полоса здоровья", Config.Visuals, "Health")
shared.KosikAddToggle(VisualsPage, "Имена игроков (Names)", Config.Visuals, "NameEsp")
shared.KosikAddSlider(VisualsPage, "Макс. Дистанция ESP", 50, 3000, Config.Visuals, "MaxDistance")
shared.KosikAddInlineColorPicker(VisualsPage, "Цвет Отрисовки ESP боксов", Config.Visuals, "BoxColor")
shared.KosikAddInlineColorPicker(VisualsPage, "Цвет Текста ESP", Config.Visuals, "TextColor")
shared.KosikAddInlineColorPicker(VisualsPage, "Цвет Круга FOV", Config.Visuals, "FovColor")

local EnvPage = shared.KosikCreatePage("Environment")
shared.KosikAddToggle(EnvPage, "Включить World Colour", Config.Environment, "WorldColorEnabled")
shared.KosikAddInlineColorPicker(EnvPage, "Настройка World Colour", Config.Environment, "WorldColor")
shared.KosikAddSlider(EnvPage, "Интенсивность цвета мира", 0, 1, Config.Environment, "WorldIntensity")
shared.KosikAddToggle(EnvPage, "Режим RGB для Мира", Config.Environment, "WorldRGB")
shared.KosikAddToggle(EnvPage, "Dark Mode", Config.Environment, "DarkMode")
shared.KosikAddSlider(EnvPage, "Интенсивность Dark Mode", 0, 1, Config.Environment, "DarkModeIntensity")
shared.KosikAddDropdown(EnvPage, "Эффекты Погоды", {"None", "Rain", "Snow"}, Config.Environment, "WeatherMode")
shared.KosikAddSlider(EnvPage, "Количество частиц", 10, 400, Config.Environment, "WeatherCount")
shared.KosikAddSlider(EnvPage, "Скорость падения", 1, 30, Config.Environment, "WeatherSpeed")
shared.KosikAddSlider(EnvPage, "Толщина частиц", 1, 5, Config.Environment, "WeatherThickness")
shared.KosikAddSlider(EnvPage, "Прозрачность частиц", 0.1, 1, Config.Environment, "WeatherOpacity")
shared.KosikAddInlineColorPicker(EnvPage, "Цвет погоды", Config.Environment, "WeatherColor")
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 8: BOOTING TABS 3 ]
-- ==========================================================
local CrossPage = shared.KosikCreatePage("Crosshair")
shared.KosikAddToggle(CrossPage, "Включить Прицел", Config.Crosshair, "Enabled")
shared.KosikAddSlider(CrossPage, "Размер линий", 2, 50, Config.Crosshair, "Size")
shared.KosikAddSlider(CrossPage, "Зазор прицела (Gap)", 0, 20, Config.Crosshair, "Gap")
shared.KosikAddSlider(CrossPage, "Толщина линий", 1, 10, Config.Crosshair, "Thickness")
shared.KosikAddToggle(CrossPage, "Вращение (Spin)", Config.Crosshair, "Spin")
shared.KosikAddSlider(CrossPage, "Скорость вращения", 1, 20, Config.Crosshair, "SpinSpeed")
shared.KosikAddToggle(CrossPage, "Переливание RGB", Config.Crosshair, "RGB")
shared.KosikAddInlineColorPicker(CrossPage, "Цвет Прицела", Config.Crosshair, "Color")

local RagePage = shared.KosikCreatePage("Rage")
shared.KosikAddToggle(RagePage, "Включить Умный Взлет (Fly Hack)", Config.Rage, "Fly")
shared.KosikAddSlider(RagePage, "Скорость полета / Взлета", 10, 300, Config.Rage, "FlySpeed")
shared.KosikAddToggle(RagePage, "NoClip сквозь стены", Config.Rage, "NoClip")
shared.KosikAddToggle(RagePage, "Включить Воздушный Контроль (Air Speed)", Config.Rage, "AirSpeedEnabled")
shared.KosikAddSlider(RagePage, "Множитель Air Speed", 15, 120, Config.Rage, "AirSpeedValue")
shared.KosikAddToggle(RagePage, "Включить Коса Спид (Дальний полет)", Config.Rage, "ScytheSpeedEnabled")

-- ИНТЕРАКТИВНЫЙ БИНДЕР АНТИ-АИМА И ВЗЛЕТА (КЛИКАБЕЛЬНЫЙ КОМПОНЕНТ)
Config.Rage.RageKeycode = Config.Rage.RageKeycode or "V"
local bindFrame = Instance.new("Frame", RagePage); bindFrame.Size = UDim2.new(0, 420, 0, 40); bindFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28); Instance.new("UICorner", bindFrame).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", bindFrame).Color = Color3.fromRGB(35, 35, 40)
local bindLbl = Instance.new("TextLabel", bindFrame); bindLbl.Size = UDim2.new(0.5, 0, 1, 0); bindLbl.Position = UDim2.new(0, 12, 0, 0); bindLbl.Text = "Клавиша Sky Anti-Aim/Взлета"; bindLbl.TextColor3 = Color3.fromRGB(220, 220, 220); bindLbl.Font = Enum.Font.Gotham; bindLbl.TextSize = 12; bindLbl.TextXAlignment = 0; bindLbl.BackgroundTransparency = 1
local bindBtn = Instance.new("TextButton", bindFrame); bindBtn.Size = UDim2.new(0, 140, 0, 26); bindBtn.Position = UDim2.new(1, -152, 0.5, -13); bindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); bindBtn.Text = tostring(Config.Rage.RageKeycode); bindBtn.TextColor3 = Config.UI.AccentColor; bindBtn.Font = Enum.Font.GothamBold; bindBtn.TextSize = 11; Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)

local listening = false
bindBtn.MouseButton1Click:Connect(function() listening = true; bindBtn.Text = "Нажмите клавишу..." end)
UIS.InputBegan:Connect(function(input, proc) if listening and not proc and input.UserInputType == Enum.UserInputType.Keyboard then Config.Rage.RageKeycode = input.KeyCode.Name; bindBtn.Text = tostring(input.KeyCode.Name); listening = false; if shared.KosikSaveSettings then shared.KosikSaveSettings() end end end)
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 9: MONOLITH ESP FIXED ]
-- ==========================================================
local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 1.5; FOVCircle.Filled = false
local CrosshairLines = {}
for i = 1, 4 do local line = Drawing.new("Line"); line.Visible = false; table.insert(CrosshairLines, line) end
local OriginalSkies = {}
for _, obj in pairs(Lighting:GetChildren()) do if obj:IsA("Sky") or obj:IsA("Atmosphere") then table.insert(OriginalSkies, obj) end end

local PlayerDrawings = {}
local function GetPlayerESP(player)
    local activeDraw = PlayerDrawings[player]
    if activeDraw then return activeDraw end
    
    local data = { Box = Drawing.new("Square"), BoxOutline = Drawing.new("Square"), HealthOutline = Drawing.new("Square"), HealthBar = Drawing.new("Square"), Name = Drawing.new("Text"), BrutalTag = Drawing.new("Text") }
    data.Box.Thickness = 1.5; data.Box.Filled = false
    data.BoxOutline.Thickness = 3.0; data.BoxOutline.Filled = false; data.BoxOutline.Transparency = 0.4
    data.HealthOutline.Thickness = 1; data.HealthOutline.Filled = true; data.HealthOutline.Color = Color3.fromRGB(10, 10, 10)
    data.HealthBar.Thickness = 1; data.HealthBar.Filled = true; data.HealthBar.Color = Color3.fromRGB(0, 255, 100)
    data.Name.Center = true; data.Name.Outline = true
    data.BrutalTag.Center = true; data.BrutalTag.Outline = true; data.BrutalTag.Color = Color3.fromRGB(255, 0, 50); data.BrutalTag.Size = 13; data.BrutalTag.Text = "[BRUTAL]"
    
    PlayerDrawings[player] = data; return data
end
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 10: RAGE PHYSICS & HOOKS ]
-- ==========================================================
local WeatherParticles = {} local lastWeatherMode = "None"
local function UpdateWeatherSystem()
    local mode = Config.Environment.WeatherMode or "None"
    if mode == "None" then if #WeatherParticles > 0 then for _, p in pairs(WeatherParticles) do p.Obj:Remove() end; table.clear(WeatherParticles); lastWeatherMode = "None" end; return end
    local count, speed, thick, opacity = Config.Environment.WeatherCount or 100, Config.Environment.WeatherSpeed or 10, Config.Environment.WeatherThickness or 2, Config.Environment.WeatherOpacity or 0.6
    local wColor, _ = shared.GetColorFromArray(Config.Environment.WeatherColor)
    if mode ~= lastWeatherMode then for _, p in pairs(WeatherParticles) do p.Obj:Remove() end; table.clear(WeatherParticles); lastWeatherMode = mode end
    
    if #WeatherParticles ~= count then
        if #WeatherParticles > count then for i = #WeatherParticles, count + 1, -1 do WeatherParticles[i].Obj:Remove(); table.remove(WeatherParticles, i) end
        else for i = #WeatherParticles + 1, count do local drawObj = (mode == "Rain") and Drawing.new("Line") or Drawing.new("Circle"); table.insert(WeatherParticles, { Obj = drawObj, X = math.random(0, Camera.ViewportSize.X), Y = math.random(-200, Camera.ViewportSize.Y) }) end end
    end
    local viewX, viewY = Camera.ViewportSize.X, Camera.ViewportSize.Y
    for idx, p in ipairs(WeatherParticles) do
        p.Y = p.Y + (speed * (mode == "Rain" and 1.4 or 0.5)); p.X = p.X + (mode == "Rain" and (speed * 0.08) or math.sin(tick() + idx) * 0.4)
        if p.Y > viewY or p.X > viewX or p.X < 0 then p.Y = math.random(-50, 0); p.X = math.random(0, viewX) end
        p.Obj.Visible = true; p.Obj.Color = wColor; p.Obj.Transparency = opacity
        if mode == "Rain" then p.Obj.Thickness = thick; p.Obj.From = Vector2.new(p.X, p.Y); p.Obj.To = Vector2.new(p.X + (speed * 0.08), p.Y + 12 + thick) else p.Obj.Thickness = 1; p.Obj.Filled = true; p.Obj.Radius = thick + 0.5; p.Obj.Position = Vector2.new(p.X, p.Y) end
    end
end

workspace.DescendantAdded:Connect(function(descendant)
    if Config.Rage.ScytheSpeedEnabled and descendant.Name:lower():find("scythe") and descendant:IsA("BasePart") then
        task.wait() if descendant and descendant.Parent then descendant.AssemblyLinearVelocity = descendant.AssemblyLinearVelocity * 4.5 end
    end
end)

shared.CustomRageHeld = false
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == (Config.Rage.RageKeycode or "V") then
        shared.CustomRageHeld = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == (Config.Rage.RageKeycode or "V") then
        shared.CustomRageHeld = false
    end
end)

local crosshairRotation, flyBodyVelocity, flyBodyGyro = 0, nil, nil
local function ProcessStandardFly(char, hrp, hum, flySpeed, isCustomHeld)
    if (Config.Rage.Fly or isCustomHeld) and hrp and hum and hum.Health > 0 then
        if not flyBodyVelocity then flyBodyVelocity = Instance.new("BodyVelocity"); flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyBodyVelocity.Parent = hrp end
        if not flyBodyGyro then flyBodyGyro = Instance.new("BodyGyro"); flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyBodyGyro.Parent = hrp end
        flyBodyGyro.CFrame = Camera.CFrame; local moveDir = Vector3.new(0,0,0)
        
        if isCustomHeld then
            local targetEnemy = shared.GetClosest3DTarget()
            local enemyHrp = targetEnemy and targetEnemy.Parent:FindFirstChild("HumanoidRootPart")
            local posX, posZ = hrp.Position.X, hrp.Position.Z
            
            if enemyHrp then 
                -- ЖЕСТКАЯ КОЛБАСА: Хаотичные, ультра-быстрые стрейфы на высокой частоте, но в коротком радиусе (3-4 метра)
                local rTick = tick() * 35
                posX = enemyHrp.Position.X + (math.sin(rTick) * 4) + (math.cos(rTick * 1.5) * 2)
                posZ = enemyHrp.Position.Z + (math.cos(rTick) * 4) + (math.sin(rTick * 1.5) * 2)
                
                -- ВЗЛЕТ В НЕБО: Подбрасывает жестко вверх над противником, но удерживает на грани Skybox (42 метра)
                hrp.CFrame = CFrame.new(posX, enemyHrp.Position.Y + 42, posZ)
            else
                hrp.CFrame = CFrame.new(posX, 60, posZ)
            end
            flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        else
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
            flyBodyVelocity.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0,0,0)
        end
    else
        if flyBodyVelocity and not shared.CustomRageHeld then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
        if flyBodyGyro and not shared.CustomRageHeld then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    end
end
-- ==========================================================
-- [ KOSIK RIVALS SUPREME V32.0 - PART 11: MONOLITH EXECUTION COMPLETE ]
-- ==========================================================
RunService.RenderStepped:Connect(function()
    local mouseLocation = UIS:GetMouseLocation()
    local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    local actualRageActive = shared.CustomRageHeld
    local currentTarget = shared.GetClosest3DTarget()
    
    if (Config.Rage.AntiAim or actualRageActive) and hrp and hum and hum.Health > 0 then 
        local spinAngle = tick() * 95
        hrp.AssemblyLinearVelocity = Vector3.new(math.sin(spinAngle) * 950, math.random(-60, 60), math.cos(spinAngle) * 950) 
    end
    
    pcall(function() ProcessStandardFly(char, hrp, hum, Config.Rage.FlySpeed or 150, actualRageActive) end)
    
    if Config.Rage.AirSpeedEnabled and hrp and hum and hum.Health > 0 and not Config.Rage.Fly and not actualRageActive and hum.FloorMaterial == Enum.Material.Air then
        local look, right, customSpeed, airDir = Camera.CFrame.LookVector, Camera.CFrame.RightVector, Config.Rage.AirSpeedValue or 50, Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then airDir = airDir + Vector3.new(look.X, 0, look.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then airDir = airDir - Vector3.new(look.X, 0, look.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then airDir = airDir + Vector3.new(right.X, 0, right.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then airDir = airDir - Vector3.new(right.X, 0, right.Z) end
        if airDir.Magnitude > 0 then hrp.AssemblyLinearVelocity = Vector3.new(airDir.Unit.X * customSpeed, hrp.AssemblyLinearVelocity.Y, airDir.Unit.Z * customSpeed) end
    end
    if (Config.Rage.NoClip or Config.Rage.Fly or actualRageActive) and char then for _, part in pairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end
    
    local isRightMousePressed = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local isAimActive = Config.Aim.Enabled and ((Config.Aim.Mode == "Always") or (Config.Aim.Mode == "RMB" and isRightMousePressed))
    
    if actualRageActive and currentTarget then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, currentTarget.Position)
    elseif isAimActive and currentTarget then
        local targetPos = currentTarget.Position
        if Config.Aim.Prediction and currentTarget.Parent and currentTarget.Parent:FindFirstChild("HumanoidRootPart") then targetPos = targetPos + (currentTarget.Parent.HumanoidRootPart.AssemblyLinearVelocity * Config.Aim.PredictionFactor) end
        if Config.Aim.Aim360 then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
        else 
            local vector, onScreen = Camera:WorldToViewportPoint(targetPos) 
            if onScreen and vector.Z > 0 then 
                local moveVector = (Vector2.new(vector.X, vector.Y) - mouseLocation)
                mousemoverel(moveVector.X, moveVector.Y)
            end 
        end
    end

    local fovColor, fovAlpha = shared.GetColorFromArray(Config.Visuals.FovColor)
    FOVCircle.Visible = Config.Aim.ShowFov and Config.Aim.Enabled and not Config.Aim.Aim360 and not actualRageActive; FOVCircle.Radius = Config.Aim.Fov; FOVCircle.Position = mouseLocation; FOVCircle.Color = fovColor; FOVCircle.Transparency = fovAlpha
    
    local crossColor = Config.Crosshair.RGB and Color3.fromHSV(tick() % 5 / 5, 1, 1) or shared.GetColorFromArray(Config.Crosshair.Color)
    crosshairRotation = crosshairRotation + (Config.Crosshair.Spin and (Config.Crosshair.SpinSpeed or 5) or 0)
    local size, gap, thick = Config.Crosshair.Size or 15, Config.Crosshair.Gap or 4, Config.Crosshair.Thickness or 2; local rads = {0, math.pi/2, math.pi, math.pi*1.5}
    for idx, line in ipairs(CrosshairLines) do line.Visible = Config.Crosshair.Enabled; if line.Visible then line.Color = crossColor; line.Thickness = thick; local angle = rads[idx] + math.rad(crosshairRotation); line.From = mouseLocation + Vector2.new(math.cos(angle) * gap, math.sin(angle) * gap); line.To = mouseLocation + Vector2.new(math.cos(angle) * (gap + size), math.sin(angle) * (gap + size)) end end
    
    local isTriggerActive = Config.Trigger.Enabled and ((Config.Trigger.Mode == "Always") or (Config.Trigger.Mode == "RMB" and isRightMousePressed)) or actualRageActive
    if isTriggerActive then 
        if actualRageActive then mouse1click()
        else
            local ray = Camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
            local hitPart = workspace:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin, ray.Direction * 1000), {LocalPlayer.Character, Camera})
            if hitPart and hitPart.Parent then
                local model = hitPart:FindFirstAncestorOfClass("Model"); local victim = model and Players:GetPlayerFromCharacter(model)
                if victim and victim ~= LocalPlayer and (not Config.Aim.IgnoreTeam or victim.Team ~= LocalPlayer.Team) then
                    local hum2 = model:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then if Config.Trigger.Delay > 0 then task.wait(Config.Trigger.Delay) end; mouse1click() end
                end
            end
        end 
    end

    local boxColor, boxAlpha = shared.GetColorFromArray(Config.Visuals.BoxColor)
    local txtColor, txtAlpha = shared.GetColorFromArray(Config.Visuals.TextColor)
    local clrShift = Color3.fromRGB(math.clamp(boxColor.R*255-40,0,255), math.clamp(boxColor.G*255-40,0,255), math.clamp(boxColor.B*255-40,0,255))
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent then
            local esp = GetPlayerESP(player)
            if esp then
                local pChar = player.Character
                local isVisible = false
                
                if pChar and pChar:FindFirstChild("HumanoidRootPart") and pChar:FindFirstChild("Head") then
                    local pHrp = pChar.HumanoidRootPart
                    local pHum = pChar:FindFirstChildOfClass("Humanoid")
                    
                    if pHum and pHum.Health > 0 and (not Config.Aim.IgnoreTeam or player.Team ~= LocalPlayer.Team) then
                        local distance = (Camera.CFrame.Position - pHrp.Position).Magnitude
                        if distance <= (Config.Visuals.MaxDistance or 800) then
                            local topPos, topOnScreen = Camera:WorldToViewportPoint(pHrp.Position + Vector3.new(0, 3, 0))
                            local bottomPos, bottomOnScreen = Camera:WorldToViewportPoint(pHrp.Position - Vector3.new(0, 3.5, 0))
                            
                            if topOnScreen and bottomOnScreen and topPos.Z > 0 and bottomPos.Z > 0 then
                                local sizeY = math.abs(topPos.Y - bottomPos.Y); local sizeX = sizeY / 2; local posX, posY = topPos.X - (sizeX / 2), topPos.Y
                                
                                if Config.Visuals.Boxes then 
                                    esp.BoxOutline.Position = Vector2.new(posX, posY); esp.BoxOutline.Size = Vector2.new(sizeX, sizeY); esp.BoxOutline.Color = clrShift; esp.BoxOutline.Visible = true
                                    esp.Box.Position = Vector2.new(posX, posY); esp.Box.Size = Vector2.new(sizeX, sizeY); esp.Box.Color = boxColor; esp.Box.Transparency = boxAlpha; esp.Box.Visible = true
                                else esp.Box.Visible = false; esp.BoxOutline.Visible = false end
                                
                                if Config.Visuals.Health then 
                                    local barHeight = (pHum.Health / pHum.MaxHealth) * sizeY
                                    esp.HealthOutline.Position = Vector2.new(posX - 6, posY); esp.HealthOutline.Size = Vector2.new(3, sizeY); esp.HealthOutline.Visible = true
                                    esp.HealthBar.Position = Vector2.new(posX - 6, posY + (sizeY - barHeight)); esp.HealthBar.Size = Vector2.new(3, barHeight); esp.HealthBar.Visible = true
                                else esp.HealthBar.Visible = false; esp.HealthOutline.Visible = false end
                                
                                if Config.Visuals.NameEsp then 
                                    esp.Name.Text = player.Name .. " [" .. math.floor(distance) .. "m]"; esp.Name.Position = Vector2.new(topPos.X, posY - 18); esp.Name.Size = Config.Visuals.FontSize or 14; esp.Name.Color = txtColor; esp.Name.Transparency = txtAlpha; esp.Name.Visible = true
                                else esp.Name.Visible = false end
                                
                                esp.BrutalTag.Visible = actualRageActive
                                if actualRageActive then esp.BrutalTag.Position = Vector2.new(topPos.X, posY - 32) end
                                isVisible = true
                            end
                        end
                    end
                end
                if not isVisible then esp.Box.Visible = false; esp.BoxOutline.Visible = false; esp.HealthBar.Visible = false; esp.HealthOutline.Visible = false; esp.Name.Visible = false; esp.BrutalTag.Visible = false end
            end
        end
    end
    
    pcall(UpdateWeatherSystem)
    if Config.Environment.WorldColorEnabled then
        for _, skyObj in pairs(OriginalSkies) do skyObj.Parent = nil end
        local targetWorldColor = Config.Environment.WorldRGB and Color3.fromHSV(tick() % 6 / 6, 1, 1) or shared.GetColorFromArray(Config.Environment.WorldColor)
        Lighting.ClockTime = 14; Lighting.Brightness = 0; Lighting.GlobalShadows = false; Lighting.ExposureCompensation = 0
if Config.Environment.DarkMode then local darkFactor = 1 - (Config.Environment.DarkModeIntensity or 0.5); targetWorldColor = Color3.new(targetWorldColor.R * darkFactor, targetWorldColor.G * darkFactor, targetWorldColor.B * darkFactor) end
Lighting.Ambient = targetWorldColor; Lighting.OutdoorAmbient = targetWorldColor; Lighting.ColorShift_Top = targetWorldColor; Lighting.FogColor = targetWorldColor
else
for _, skyObj in pairs(OriginalSkies) do skyObj.Parent = Lighting end
Lighting.Ambient = OriginalAmbient; Lighting.OutdoorAmbient = OriginalOutdoorAmbient; Lighting.ColorShift_Top = OriginalColorShift; Lighting.FogColor = OriginalFogColor; Lighting.Brightness = OriginalBrightness; Lighting.ExposureCompensation = OriginalExposure; Lighting.GlobalShadows = true
end
end)