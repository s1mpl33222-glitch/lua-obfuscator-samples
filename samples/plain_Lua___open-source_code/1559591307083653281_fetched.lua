local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Window = WindUI:CreateWindow({
    Title = "Ramsey Hub | TH Admin🇹🇭",
})

-- สร้างแถบเมนูต่างๆ
local PVP_Tab = Window:Tab({
    Title = "PVP",
    Icon = "swords",
})

local ESP_Tab = Window:Tab({
    Title = "ESP",
    Icon = "eye",
})

local Text_Tab = Window:Tab({
    Title = "Text",
    Icon = "type",
})

local Server_Tab = Window:Tab({
    Title = "Server",
    Icon = "globe",
})

local Settings_Tab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

-- ตัวแปรระบบ Combat / Aimbot
local aimbotEnabled = false
local wallCheckEnabled = false -- ตัวแปรเช็คกำแพง
local targetPartName = "Chin"
local showFov = false
local fovRadius = 150
local smoothValue = 8
local fovColorMode = "สีม่วง (Purple)"
getgenv().AppleLockedTarget = nil
local ignoredPlayers = {}

-- ตัวแปรระบบ ESP
local nameEspEnabled = false
local healthEspEnabled = false
local highlightEspEnabled = false
local weaponEspEnabled = false 
local weaponEspEnv = nil 
local espObjects = {}

-- ตัวแปรเก็บ UI References สำหรับเซ็ตค่ากลับตอนโหลด Config
local aimbotToggleRef, wallCheckToggleRef, fovToggleRef, fovColorDropdownRef, targetPartDropdownRef, fovSliderRef, smoothSliderRef, ignoreDropdownRef
local nameEspToggleRef, healthEspToggleRef, highlightEspToggleRef, weaponEspToggleRef

-- สร้างวงกลม FOV
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "AppleFOVGui"
FOVGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
FOVGui.Enabled = false
FOVGui.IgnoreGuiInset = true

local FOVCircleFrame = Instance.new("Frame")
FOVCircleFrame.Parent = FOVGui
FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircleFrame.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
FOVCircleFrame.BackgroundTransparency = 1

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVCircleFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = FOVCircleFrame
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(170, 0, 255)
UIStroke.Transparency = 0.4

RunService.RenderStepped:Connect(function()
    if fovColorMode == "สีม่วง (Purple)" then
        UIStroke.Color = Color3.fromRGB(170, 0, 255)
    elseif fovColorMode == "สีขาว (White)" then
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
    elseif fovColorMode == "สีรุ้ง (Rainbow)" then
        local hue = tick() % 5 / 5
        UIStroke.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- ================= [ 1. ESP SYSTEM ] =================
local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].highlight then espObjects[player].highlight:Destroy() end
        if espObjects[player].billboard then espObjects[player].billboard:Destroy() end
        if espObjects[player].textLabel then espObjects[player].textLabel = nil end
        if espObjects[player].healthBg then espObjects[player].healthBg = nil end
        if espObjects[player].healthBar then espObjects[player].healthBar = nil end
        if espObjects[player].healthConn then espObjects[player].healthConn:Disconnect() end
        espObjects[player] = nil
    end
end

local function updateESPState(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then removeESP(player) return end

    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChild("Humanoid")
    if not head or not humanoid or humanoid.Health <= 0 then removeESP(player) return end

    local isLocked = (getgenv().AppleLockedTarget == player)

    if highlightEspEnabled then
        if not espObjects[player] then espObjects[player] = {} end
        if not espObjects[player].highlight or espObjects[player].highlight.Parent ~= char then
            if espObjects[player].highlight then espObjects[player].highlight:Destroy() end
            local highlight = Instance.new("Highlight")
            highlight.Name = "CustomESPHighlight"
            highlight.Adornee = char
            highlight.FillColor = Color3.fromRGB(0, 170, 255)
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = Color3.fromRGB(0, 255, 204)
            highlight.OutlineTransparency = 0
            highlight.Parent = char
            espObjects[player].highlight = highlight
        end
    else
        if espObjects[player] and espObjects[player].highlight then
            espObjects[player].highlight:Destroy()
            espObjects[player].highlight = nil
        end
    end

    local shouldShowBillboard = nameEspEnabled or healthEspEnabled
    if shouldShowBillboard then
        if not espObjects[player] then espObjects[player] = {} end
        if not espObjects[player].billboard or espObjects[player].billboard.Parent ~= char then
            if espObjects[player].billboard then espObjects[player].billboard:Destroy() end
            if espObjects[player].healthConn then espObjects[player].healthConn:Disconnect() end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "CustomESPBillboard"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 150, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 2.8, 0)
            billboard.AlwaysOnTop = true
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = billboard
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 0, 20)
            textLabel.Font = Enum.Font.Legacy
            textLabel.TextSize = 9
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.Text = player.Name
            
            local HealthBg = Instance.new("Frame")
            HealthBg.Parent = billboard
            HealthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            HealthBg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            HealthBg.BorderSizePixel = 1
            HealthBg.Position = UDim2.new(0.1, 0, 0, 20)
            HealthBg.Size = UDim2.new(0.8, 0, 0, 3)
            
            local HealthBar = Instance.new("Frame")
            HealthBar.Parent = HealthBg
            HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            HealthBar.BorderSizePixel = 0
            HealthBar.Size = UDim2.new(1, 0, 1, 0)
            
            local function updateHealth()
                if not humanoid or humanoid.Parent == nil then return end
                local hp = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                local maxHp = humanoid.MaxHealth
                if maxHp <= 0 then maxHp = 100 end
                HealthBar.Size = UDim2.new(hp / maxHp, 0, 1, 0)
            end
            updateHealth()
            espObjects[player].healthConn = humanoid.HealthChanged:Connect(updateHealth)
            billboard.Parent = char
            espObjects[player].billboard = billboard
            espObjects[player].textLabel = textLabel
            espObjects[player].healthBg = HealthBg
        end

        if espObjects[player].textLabel then
            espObjects[player].textLabel.Visible = nameEspEnabled
            espObjects[player].textLabel.Text = player.Name
            if isLocked then
                espObjects[player].textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            else
                espObjects[player].textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        if espObjects[player].healthBg then espObjects[player].healthBg.Visible = healthEspEnabled end
    else
        if espObjects[player] then
            if espObjects[player].billboard then espObjects[player].billboard:Destroy() espObjects[player].billboard = nil end
            if espObjects[player].healthConn then espObjects[player].healthConn:Disconnect() espObjects[player].healthConn = nil end
            espObjects[player].textLabel = nil
            espObjects[player].healthBg = nil
        end
    end
end

nameEspToggleRef = ESP_Tab:Toggle({
    Title = "มองทะลุเห็นชื่อ (Name ESP)",
    Default = false,
    Callback = function(Value)
        nameEspEnabled = Value
        for _, p in ipairs(Players:GetPlayers()) do updateESPState(p) end
    end
})

healthEspToggleRef = ESP_Tab:Toggle({
    Title = "มองทะลุเห็นหลอดเลือด (Health ESP)",
    Default = false,
    Callback = function(Value)
        healthEspEnabled = Value
        for _, p in ipairs(Players:GetPlayers()) do updateESPState(p) end
    end
})

highlightEspToggleRef = ESP_Tab:Toggle({
    Title = "ไฮไลท์สีตัวละคร (Highlight ESP)",
    Default = false,
    Callback = function(Value)
        highlightEspEnabled = Value
        for _, p in ipairs(Players:GetPlayers()) do updateESPState(p) end
    end
})

weaponEspToggleRef = ESP_Tab:Toggle({
    Title = "มองทะลุเห็นไอเทม (Item/Weapon ESP)",
    Default = false,
    Callback = function(Value)
        weaponEspEnabled = Value
        if weaponEspEnabled then
            pcall(function() weaponEspEnv = loadstring(game:HttpGet("https://pastefy.app/cIyYKNBD/raw", true))() end)
        else
            pcall(function()
                if type(weaponEspEnv) == "table" and weaponEspEnv.Destroy then weaponEspEnv:Destroy()
                elseif type(weaponEspEnv) == "function" then pcall(weaponEspEnv) end
            end)
            weaponEspEnv = nil
        end
    end
})

local function setupPlayer(player)
    player.CharacterAdded:Connect(function(char)
        task.spawn(function()
            local humanoid = char:WaitForChild("Humanoid", 5)
            local head = char:WaitForChild("Head", 5)
            if humanoid and head then
                task.wait(0.5)
                removeESP(player)
                updateESPState(player)
            end
        end)
    end)
    if player.Character then
        task.spawn(function() task.wait(0.5) updateESPState(player) end)
    end
end

Players.PlayerAdded:Connect(setupPlayer)
for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerRemoving:Connect(function(player) removeESP(player) end)

RunService.RenderStepped:Connect(function()
    if nameEspEnabled or healthEspEnabled or highlightEspEnabled or weaponEspEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                updateESPState(p)
            end
        end
    end
end)

-- ================= [ 2. TEXT TAB (Mobile Optimized Drag System) ] =================
local function createFloatingText(defaultText, defaultSize, defaultPos)
    local gui = Instance.new("ScreenGui")
    gui.Name = "AppleFloatingText"
    gui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    gui.Enabled = false
    gui.IgnoreGuiInset = true

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.BackgroundTransparency = 1
    frame.Position = defaultPos
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Active = true

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = defaultSize
    label.TextColor3 = Color3.fromRGB(0, 170, 255)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = defaultText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top

    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return gui, label
end

local textGui1, textLabel1 = createFloatingText("ข้อความที่ 1", 24, UDim2.new(0.05, 0, 0.1, 0))
local textGui2, textLabel2 = createFloatingText("ข้อความที่ 2", 24, UDim2.new(0.05, 0, 0.2, 0))
local textGui3, textLabel3 = createFloatingText("ข้อความที่ 3", 24, UDim2.new(0.05, 0, 0.3, 0))
local textGui4, textLabel4 = createFloatingText("ข้อความที่ 4", 24, UDim2.new(0.05, 0, 0.4, 0))

Text_Tab:Toggle({ Title = "เปิด/ปิด ข้อความที่ 1", Default = false, Callback = function(v) textGui1.Enabled = v end })
Text_Tab:Input({ Title = "พิมพ์ข้อความที่ 1", Default = "ข้อความที่ 1", Callback = function(text) textLabel1.Text = text end })
Text_Tab:Slider({ Title = "ขนาดตัวอักษร 1", Value = { Min = 10, Max = 100, Default = 24 }, Callback = function(val) local n = type(val) == "table" and (val.Value or val.Current or 24) or tonumber(val) if n then textLabel1.TextSize = n end end })

Text_Tab:Toggle({ Title = "เปิด/ปิด ข้อความที่ 2", Default = false, Callback = function(v) textGui2.Enabled = v end })
Text_Tab:Input({ Title = "พิมพ์ข้อความที่ 2", Default = "ข้อความที่ 2", Callback = function(text) textLabel2.Text = text end })
Text_Tab:Slider({ Title = "ขนาดตัวอักษร 2", Value = { Min = 10, Max = 100, Default = 24 }, Callback = function(val) local n = type(val) == "table" and (val.Value or val.Current or 24) or tonumber(val) if n then textLabel2.TextSize = n end end })

Text_Tab:Toggle({ Title = "เปิด/ปิด ข้อความที่ 3", Default = false, Callback = function(v) textGui3.Enabled = v end })
Text_Tab:Input({ Title = "พิมพ์ข้อความที่ 3", Default = "ข้อความที่ 3", Callback = function(text) textLabel3.Text = text end })
Text_Tab:Slider({ Title = "ขนาดตัวอักษร 3", Value = { Min = 10, Max = 100, Default = 24 }, Callback = function(val) local n = type(val) == "table" and (val.Value or val.Current or 24) or tonumber(val) if n then textLabel3.TextSize = n end end })

Text_Tab:Toggle({ Title = "เปิด/ปิด ข้อความที่ 4", Default = false, Callback = function(v) textGui4.Enabled = v end })
Text_Tab:Input({ Title = "พิมพ์ข้อความที่ 4", Default = "ข้อความที่ 4", Callback = function(text) textLabel4.Text = text end })
Text_Tab:Slider({ Title = "ขนาดตัวอักษร 4", Value = { Min = 10, Max = 100, Default = 24 }, Callback = function(val) local n = type(val) == "table" and (val.Value or val.Current or 24) or tonumber(val) if n then textLabel4.TextSize = n end end })

-- ================= [ 3. PVP / AIMBOT & WALL CHECK SYSTEM ] =================
aimbotToggleRef = PVP_Tab:Toggle({
    Title = "เปิด/ปิด ระบบล็อกเป้า (Aimbot)",
    Default = false,
    Callback = function(Value)
        aimbotEnabled = Value
    end
})

wallCheckToggleRef = PVP_Tab:Toggle({
    Title = "ไม่ล็อกผู้เล่นที่อยู่หลังกำแพง (Wall Check)",
    Default = false,
    Callback = function(Value)
        wallCheckEnabled = Value
    end
})

local function getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

ignoreDropdownRef = PVP_Tab:Dropdown({
    Title = "รายชื่อผู้เล่นที่ไม่ต้องการล็อก (Whitelist/Ignore)",
    Values = getPlayerNames(),
    Multi = true,
    Default = {},
    Callback = function(Value)
        ignoredPlayers = Value
    end
})

Players.PlayerAdded:Connect(function() ignoreDropdownRef:SetValues(getPlayerNames()) end)
Players.PlayerRemoving:Connect(function() ignoreDropdownRef:SetValues(getPlayerNames()) end)

fovColorDropdownRef = PVP_Tab:Dropdown({
    Title = "เลือกสีวงกลม FOV",
    Values = { "สีม่วง (Purple)", "สีรุ้ง (Rainbow)", "สีขาว (White)" },
    Default = 1,
    Callback = function(Value) fovColorMode = Value end
})

targetPartDropdownRef = PVP_Tab:Dropdown({
    Title = "เลือกส่วนที่จะล็อกเป้า",
    Values = { "คาง (Chin / ขอบล่างหัว)", "หัว (Head)", "ลำตัว (HumanoidRootPart)" },
    Default = 1,
    Callback = function(Value)
        if Value == "คาง (Chin / ขอบล่างหัว)" then targetPartName = "Chin"
        elseif Value == "หัว (Head)" then targetPartName = "Head"
        elseif Value == "ลำตัว (HumanoidRootPart)" then targetPartName = "HumanoidRootPart" end
    end
})

fovToggleRef = PVP_Tab:Toggle({
    Title = "แสดงวงกลม FOV ตรงกลางจอ",
    Default = false,
    Callback = function(Value)
        showFov = Value
        FOVGui.Enabled = showFov
    end
})

fovSliderRef = PVP_Tab:Slider({
    Title = "ขนาดวงกลม FOV",
    Value = { Min = 1, Max = 700, Default = 150 },
    Rounding = 0,
    Callback = function(Value) 
        local actualValue = type(Value) == "table" and (Value.Value or Value.Current or 150) or tonumber(Value)
        if actualValue then
            fovRadius = actualValue 
            FOVCircleFrame.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
        end
    end
})

smoothSliderRef = PVP_Tab:Slider({
    Title = "ความเนียนในการล็อก",
    Value = { Min = 1, Max = 20, Default = 8 },
    Rounding = 1,
    Callback = function(Value) 
        local actualValue = type(Value) == "table" and (Value.Value or Value.Current or 8) or tonumber(Value)
        if actualValue then smoothValue = actualValue end
    end
})

local function getTargetPosition(character)
    if targetPartName == "Chin" then
        local head = character:FindFirstChild("Head")
        if head then return head.Position - Vector3.new(0, head.Size.Y / 2, 0) - (head.CFrame.LookVector * 0.1) end
    end
    local part = character:FindFirstChild(targetPartName) or character:FindFirstChild("Head")
    return part and part.Position or nil
end

-- ฟังก์ชันเช็คว่ามีกำแพงบังเป้าหมายอยู่หรือไม่
local function isVisible(targetPart, character)
    if not wallCheckEnabled then return true end
    if not targetPart or not character then return false end

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local excludeList = { LocalPlayer.Character }
    if LocalPlayer.Character then
        table.insert(excludeList, LocalPlayer.Character)
    end
    table.insert(excludeList, character)
    raycastParams.FilterDescendantsInstances = excludeList
    raycastParams.IgnoreWater = true

    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result then
        -- ถ้า Raycast ชนกับสิ่งกีดขวาง แปลว่ามีกำแพงบัง
        return false
    end
    return true
end

RunService.RenderStepped:Connect(function()
    local viewportSize = Camera.ViewportSize
    local foundTarget = nil

    if aimbotEnabled then
        local closestPlayer, shortestDistance = nil, fovRadius
        local centerScreen = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        
        for _, player in ipairs(Players:GetPlayers()) do
            local isIgnored = false
            if type(ignoredPlayers) == "table" then
                if ignoredPlayers[player.Name] == true or table.find(ignoredPlayers, player.Name) then
                    isIgnored = true
                end
            end

            if not isIgnored and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local hum = player.Character.Humanoid
                if hum.Health > 0 then
                    local targetPart = player.Character:FindFirstChild(targetPartName) or player.Character:FindFirstChild("Head")
                    if targetPart then
                        local pos = getTargetPosition(player.Character)
                        if pos then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
                            if onScreen then
                                local dist = (centerScreen - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                if dist < shortestDistance then
                                    -- ตรวจสอบเงื่อนไข Wall Check
                                    if not wallCheckEnabled or isVisible(targetPart, player.Character) then
                                        shortestDistance = dist
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character then
            foundTarget = closestPlayer
            local targetPos = getTargetPosition(closestPlayer.Character)
            if targetPos then
                local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / math.max(smoothValue, 1))
            end
        end
    end
    getgenv().AppleLockedTarget = foundTarget
end)

-- ================= [ 4. SERVER TAB ] =================
local function hopSpecificPing()
    pcall(function()
        local servers = {}
        local cursor = ""
        local targetServerId = nil

        repeat
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor ~= "" then url = url .. "&cursor=" .. cursor end
            local req = HttpService:JSONDecode(game:HttpGet(url))
            
            if req and req.data then
                for _, s in ipairs(req.data) do
                    if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                        local serverPing = s.ping or 0
                        if serverPing >= 40 and serverPing <= 50 then
                            targetServerId = s.id
                            break
                        elseif #servers < 50 then
                            table.insert(servers, s.id)
                        end
                    end
                end
                cursor = req.nextPageCursor
            else
                break
            end
        until targetServerId or not cursor or #servers >= 50

        if targetServerId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, LocalPlayer)
        elseif #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end)
end

Server_Tab:Button({ Title = "วาปไปเซิร์ฟปิง 40-50ms ทันที", Callback = function() hopSpecificPing() end })
Server_Tab:Button({ Title = "รีจอยเข้าเซิร์ฟเดิม (Rejoin)", Callback = function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end })

-- ================= [ 5. SETTINGS TAB (FPS Boost, Save & Full Load Config) ] =================
Settings_Tab:Button({
    Title = "บูท FPS (ภาพกากทันที / ลดแลค)",
    Callback = function()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualityLevel.Level1
            local Terrain = Workspace:FindFirstChildOfClass("Terrain")
            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveTransparency = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
                Terrain.Decoration = false
            end
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Beam") then
                    v.Enabled = false
                elseif v:IsA("MeshPart") then
                    v.TextureID = ""
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                end
            end
        end)
    end
})

Settings_Tab:Button({
    Title = "เซฟการตั้งค่า (Save Config)",
    Callback = function()
        pcall(function()
            local config = {
                aimbot = aimbotEnabled,
                wallCheck = wallCheckEnabled,
                fov = fovRadius,
                smooth = smoothValue,
                colorMode = fovColorMode,
                part = targetPartName,
                showFov = showFov,
                ignored = ignoredPlayers,
                nameEsp = nameEspEnabled,
                healthEsp = healthEspEnabled,
                highlightEsp = highlightEspEnabled,
                weaponEsp = weaponEspEnabled
            }
            if writefile then
                writefile("AppleHub_Config.json", HttpService:JSONEncode(config))
            end
        end)
    end
})

Settings_Tab:Button({
    Title = "โหลด / รันการตั้งค่า (Load & Run Config)",
    Callback = function()
        pcall(function()
            if readfile and isfile and isfile("AppleHub_Config.json") then
                local data = HttpService:JSONDecode(readfile("AppleHub_Config.json"))
                if data then
                    aimbotEnabled = data.aimbot or false
                    wallCheckEnabled = data.wallCheck or false
                    fovRadius = data.fov or 150
                    smoothValue = data.smooth or 8
                    fovColorMode = data.colorMode or "สีม่วง (Purple)"
                    targetPartName = data.part or "Chin"
                    showFov = data.showFov or false
                    ignoredPlayers = data.ignored or {}

                    nameEspEnabled = data.nameEsp or false
                    healthEspEnabled = data.healthEsp or false
                    highlightEspEnabled = data.highlightEsp or false
                    weaponEspEnabled = data.weaponEsp or false

                    if aimbotToggleRef and aimbotToggleRef.Set then aimbotToggleRef:Set(aimbotEnabled) end
                    if wallCheckToggleRef and wallCheckToggleRef.Set then wallCheckToggleRef:Set(wallCheckEnabled) end
                    if fovToggleRef and fovToggleRef.Set then fovToggleRef:Set(showFov) end
                    if fovColorDropdownRef and fovColorDropdownRef.Set then fovColorDropdownRef:Set(fovColorMode) end
                    if targetPartDropdownRef and targetPartDropdownRef.Set then targetPartDropdownRef:Set(targetPartName) end
                    if fovSliderRef and fovSliderRef.Set then fovSliderRef:Set(fovRadius) end
                    if smoothSliderRef and smoothSliderRef.Set then smoothSliderRef:Set(smoothValue) end
                    if ignoreDropdownRef and ignoreDropdownRef.Set then ignoreDropdownRef:Set(ignoredPlayers) end

                    if nameEspToggleRef and nameEspToggleRef.Set then nameEspToggleRef:Set(nameEspEnabled) end
                    if healthEspToggleRef and healthEspToggleRef.Set then healthEspToggleRef:Set(healthEspEnabled) end
                    if highlightEspToggleRef and highlightEspToggleRef.Set then highlightEspToggleRef:Set(highlightEspEnabled) end
                    if weaponEspToggleRef and weaponEspToggleRef.Set then weaponEspToggleRef:Set(weaponEspEnabled) end

                    FOVGui.Enabled = showFov
                    FOVCircleFrame.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
                    for _, p in ipairs(Players:GetPlayers()) do updateESPState(p) end
                end
            end
        end)
    end
})
