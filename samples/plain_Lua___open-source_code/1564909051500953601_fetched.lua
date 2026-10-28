local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera       = workspace.CurrentCamera
local LocalPlayer  = Players.LocalPlayer
local Backpack     = LocalPlayer:WaitForChild("Backpack")

local AimEnabled       = false
local HighlightEnabled = false
local NameESPEnabled   = false
local HideNameEnabled  = false
local EnabledSkip      = false
local NoRecoilEnabled  = false
local ItemAuraEnabled  = false
local LookHeadEnabled  = false
local FOV = 50

-- Item Aura
local ItemAuraConnections = {}

-- Inventory ESP
local inventoryESPEnabled = false
local WeaponRegistry = {}
local PlayerBillboards = {}
local PlayerConnections = {}

local Items = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
    or game:GetService("ReplicatedStorage"):FindFirstChild("Tools")
    or game:GetService("ServerStorage"):FindFirstChild("Items")


-- ===== Counter =====
local Counter
pcall(function()
    for _, v in ipairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then
            Counter = v
            break
        end
    end
end)

-- ===== netGet (แก้แค่ตรงนี้) =====
local function netGet(...)
    if not Counter then return end

    Counter.func = (Counter.func or 0) + 1

    local getRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")

    return getRemote:InvokeServer(Counter.func, ...)
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if not ItemAuraEnabled then continue end

        local Character = LocalPlayer.Character
        if not Character then continue end

        local DroppedItems = workspace:FindFirstChild("DroppedItems")
        if not DroppedItems then continue end

        for _, Item in next, DroppedItems:GetChildren() do
            if Item:IsA("Model") then
                local ItemPosition = Item:GetPivot().Position
                local CharacterPosition = Character:GetPivot().Position

                if (ItemPosition - CharacterPosition).Magnitude < 30 then
                    if Item.Name == "Money" then
                        task.spawn(function()
                            pcall(netGet, "pickup_dropped_item", Item)
                        end)
                        continue
                    end

                    task.spawn(function()
                        pcall(netGet, "pickup_dropped_item", Item)
                    end)

                    if not ItemAuraConnections[Item] then
                        local Connection
                        Connection = RunService.Heartbeat:Connect(function()
                            if not Item or not Item.Parent or not Item:FindFirstChild("PickUpZone") then
                                if Connection then Connection:Disconnect() Connection = nil end
                                ItemAuraConnections[Item] = nil
                                return
                            end

                            firetouchinterest(Item.PickUpZone, Character:FindFirstChild("HumanoidRootPart"), 1)
                            firetouchinterest(Item.PickUpZone, Character:FindFirstChild("HumanoidRootPart"), 0)
                        end)

                        ItemAuraConnections[Item] = Connection
                    end
                end
            end
        end
    end
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color     = Color3.new(1, 1, 1)
FOVCircle.Thickness = 1
FOVCircle.Radius    = FOV
FOVCircle.NumSides  = 100
FOVCircle.Filled    = false
FOVCircle.Visible   = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = AimEnabled
    local size = Camera.ViewportSize
    FOVCircle.Position = Vector2.new(size.X / 2, size.Y / 2)
end)

local function Visible(part)
    local origin = Camera.CFrame.Position
    local dir    = part.Position - origin
    local ray    = RaycastParams.new()
    ray.FilterDescendantsInstances = {LocalPlayer.Character}
    ray.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(origin, dir, ray)
    if result then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

local function GetTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    local closest = nil
    local closestDist = FOV
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local pos,visible = Camera:WorldToViewportPoint(root.Position)
                if visible then
                    local screenPos = Vector2.new(pos.X,pos.Y)
                    local dist = (screenPos - center).Magnitude
                    if dist <= FOV then
                        if LookHeadEnabled then
                            local distFromRoot = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distFromRoot <= 500 then
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = root
                                end
                            end
                        elseif AimEnabled then
                            if Visible(root) then
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = root
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

Camera.CameraType = Enum.CameraType.Custom

RunService.RenderStepped:Connect(function()
    if not AimEnabled then return end
            if target then
        local head = target.Parent:FindFirstChild("Head")
        -- ตรวจสอบว่า LocalPlayer นั่งบนที่นั่งรถ (Seat) หรือไม่
        local isSitting = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").SeatPart ~= nil
        
        if head then
            local offset
            if isSitting then
                -- ถ้าอยู่บนรถ: ล็อกต่ำลง (Y) และเฉียงซ้าย (X)
                -- ปรับค่า -0.5 (ซ้าย) และ 1.5 (ต่ำ) ได้ตามความชอบ
                offset = Vector3.new(-0.5, 1.5, 0)
            else
                -- ถ้าไม่ได้อยู่บนรถ: ล็อกปกติ (ต่ำลงจากหัวเล็กน้อย 0.6)
                offset = Vector3.new(0, 0.6, 0)
            end
            
            local aimPos = LookHeadEnabled and head.Position or (head.Position - offset)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
        end
        end
end)

local ESP = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency    = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = false
    highlight.Parent  = game.CoreGui

    local name = Drawing.new("Text")
    name.Size    = 10
    name.Center  = true
    name.Outline = true
    name.Color   = Color3.new(1, 1, 1)
    name.Visible = false
    name.Font    = 3

    local info = Drawing.new("Text")
    info.Size    = 9
    info.Center  = true
    info.Outline = true
    info.Color   = Color3.new(1, 1, 1)
    info.Visible = false
    info.Font    = 3

    ESP[player]  = {Highlight = highlight, Name = name, Info = info}
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(player)
    local data = ESP[player]
    if data then
        if data.Highlight then data.Highlight:Destroy() end
        if data.Name      then data.Name:Remove()      end
        if data.Info      then data.Info:Remove()      end
        ESP[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for player, data in pairs(ESP) do
        local char = player.Character
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if char then
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and head and root and hum.Health > 0 then
                -- Highlight
                if HighlightEnabled then
                    local hpPercent = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    data.Highlight.Adornee          = char
                    data.Highlight.Enabled          = true
                    data.Highlight.FillColor        = Color3.fromRGB(
                        255 * (1 - hpPercent),
                        255 * hpPercent,
                        0
                    )
                else
                    data.Highlight.Enabled = false
                end

                -- Name + Info ESP
                local posHead, visHead = Camera:WorldToViewportPoint(head.Position)
                local posFoot, visFoot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                if NameESPEnabled then
                    if visHead then
                        data.Name.Visible  = true
                        data.Name.Text     = player.Name
                        data.Name.Position = Vector2.new(posHead.X, posHead.Y - 15)
                    else
                        data.Name.Visible = false
                    end

                    if visFoot and myRoot then
                        local dist = math.floor((myRoot.Position - root.Position).Magnitude)
                        data.Info.Visible  = true
                        data.Info.Text     = string.format("HP: %d | %dM", math.floor(hum.Health), dist)
                        data.Info.Position = Vector2.new(posFoot.X, posFoot.Y)
                    else
                        data.Info.Visible = false
                    end
                else
                    data.Name.Visible = false
                    data.Info.Visible = false
                end
            else
                -- ตายหรือ part หาย
                data.Highlight.Enabled = false
                data.Name.Visible      = false
                data.Info.Visible      = false
            end
        else
            -- ไม่มี character
            data.Highlight.Enabled = false
            data.Highlight.Adornee = nil
            data.Name.Visible      = false
            data.Info.Visible      = false
        end
    end
end)

local function IsGun(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return tool:GetAttribute("reload_time") or tool:GetAttribute("AmmoType")
end

local function ApplyNoRecoil(gun)
    pcall(function()
        gun:SetAttribute("Recoil", 0)
    end)
end

RunService.Heartbeat:Connect(function()
    if not NoRecoilEnabled then return end
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and IsGun(tool) then
            ApplyNoRecoil(tool)
        end
    end
    for _, tool in pairs(Backpack:GetChildren()) do
        if IsGun(tool) then
            ApplyNoRecoil(tool)
        end
    end
end)

local RarityColors = {
    Common    = Color3.fromRGB(255, 255, 255),
    Uncommon  = Color3.fromRGB(99,  255, 52),
    Rare      = Color3.fromRGB(51,  170, 255),
    Epic      = Color3.fromRGB(237, 44,  255),
    Legendary = Color3.fromRGB(255, 150, 0),
    Omega     = Color3.fromRGB(255, 20,  51),
}

local function registerItems(folder)
    for _, tool in ipairs(folder:GetChildren()) do
        if tool:IsA("Tool") then
            local handle    = tool:FindFirstChild("Handle")
            local displayName = tool:GetAttribute("DisplayName") or tool.Name
            local itemId    = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
            local rarity    = tool:GetAttribute("RarityName") or "Common"
            local imageId   = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"
            local key
            if handle then
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                if mesh and mesh.MeshId ~= "" then
                    key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
                elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                    key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
                end
            end
            if not key and itemId and itemId ~= "" and itemId ~= tool.Name then
                key = "ITEMID_" .. itemId .. "_RARITY_" .. rarity
            end
            if not key then
                key = "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
            end
            WeaponRegistry[key] = { Name = displayName, Rarity = rarity, ImageId = imageId, ToolName = tool.Name }
        end
    end
end

local function getItemKey(tool)
    local handle = tool:FindFirstChild("Handle")
    local displayName = tool:GetAttribute("DisplayName") or tool.Name
    local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
    local rarity = tool:GetAttribute("RarityName") or "Common"
    if handle then
        local mesh = handle:FindFirstChildOfClass("SpecialMesh")
        if mesh and mesh.MeshId ~= "" then return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity end
        if handle:IsA("MeshPart") and handle.MeshId ~= "" then return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity end
    end
    if itemId and itemId ~= "" and itemId ~= tool.Name then return "ITEMID_" .. itemId .. "_RARITY_" .. rarity end
    return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
end

local function getWeaponInfo(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    return WeaponRegistry[getItemKey(tool)]
end

-- ── Inventory ESP (Drawing) ───────────────────────────────────
local InventoryDrawings = {}

local function getPlayerTools(player)
    local tools = {}
    local char = player.Character
    for _, bagName in ipairs({"Backpack", "StarterGear", "StarterPack"}) do
        local bag = player:FindFirstChild(bagName)
        if bag then
            for _, t in ipairs(bag:GetChildren()) do
                if t:IsA("Tool") and t.Name ~= "Fists" then table.insert(tools, t) end
            end
        end
    end
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name ~= "Fists" then table.insert(tools, t) end
        end
    end
    return tools
end

local function clearInventoryDrawings(player)
    local data = InventoryDrawings[player]
    if data then
        for _, d in ipairs(data.drawings) do
            pcall(function() d:Remove() end)
        end
        InventoryDrawings[player] = nil
    end
end

local function createBillboardForPlayer(player) end

local function setInventoryESPEnabled(enabled)
    inventoryESPEnabled = enabled
    if not enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            clearInventoryDrawings(player)
        end
        PlayerBillboards = {}
    end
end

RunService.RenderStepped:Connect(function()
    if not inventoryESPEnabled then
        for player in pairs(InventoryDrawings) do
            clearInventoryDrawings(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == Players.LocalPlayer then continue end
        local char = player.Character
        if not char then clearInventoryDrawings(player) continue end
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not head or not root then clearInventoryDrawings(player) continue end

        local tools = getPlayerTools(player)
        local infos = {}
        for _, tool in ipairs(tools) do
            local info = getWeaponInfo(tool)
            if info then table.insert(infos, info) end
        end

        if not InventoryDrawings[player] then
            InventoryDrawings[player] = { drawings = {} }
        end
        local data = InventoryDrawings[player]

        while #data.drawings < #infos do
            local d = Drawing.new("Text")
            d.Size    = 11
            d.Center  = true
            d.Outline = true
            d.Font    = 4
            d.Visible = false
            table.insert(data.drawings, d)
        end

        local posHead, visHead = Camera:WorldToViewportPoint(head.Position)
        local posFoot, visFoot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

        local baseY = posFoot.Y + 28

        for idx, info in ipairs(infos) do
            local d = data.drawings[idx]
            if visFoot then
                d.Text     = "[" .. info.Name .. "]"
                d.Color    = RarityColors[info.Rarity] or Color3.new(1, 1, 1)
                d.Position = Vector2.new(posFoot.X, baseY + ((idx - 1) * 13))
                d.Visible  = true
            else
                d.Visible = false
            end
        end

        for idx = #infos + 1, #data.drawings do
            data.drawings[idx].Visible = false
        end
    end
end)

for _, folderName in ipairs({"gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish"}) do
    local folder = Items:FindFirstChild(folderName)
    if folder then registerItems(folder) end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        clearInventoryDrawings(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    clearInventoryDrawings(player)
    if PlayerBillboards[player] then
        PlayerBillboards[player]:Destroy()
        PlayerBillboards[player] = nil
    end
end)

local UI = Instance.new("ScreenGui")
UI.Parent = game.CoreGui
UI.ResetOnSpawn = false

local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 300, 0, 280)
Main.Position = UDim2.new(0.02, 0, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(15,15,18)
Main.BorderSizePixel = 0
Main.Visible = true
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,14)

local Top = Instance.new("Frame",Main)
Top.Size = UDim2.new(1,0,0,45)
Top.BackgroundColor3 = Color3.fromRGB(25,25,30)
Top.BorderSizePixel = 0
Instance.new("UICorner",Top).CornerRadius = UDim.new(0,14)

local Line = Instance.new("Frame",Top)
Line.Size = UDim2.new(1,0,0,2)
Line.Position = UDim2.new(0,0,1,-2)
Line.BackgroundColor3 = Color3.fromRGB(120,80,255)
Line.BorderSizePixel = 0

local Logo = Instance.new("ImageLabel",Top)
Logo.Size = UDim2.new(0,28,0,28)
Logo.Position = UDim2.new(0,10,0.5,-14)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://72830195117719"

local Title = Instance.new("TextLabel",Top)
Title.Size = UDim2.new(1,-50,1,0)
Title.Position = UDim2.new(0,45,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Neverman X Dev"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.new(1,1,1)

local Container = Instance.new("ScrollingFrame",Main)
Container.Size = UDim2.new(1,-10,1,-55)
Container.Position = UDim2.new(0,5,0,50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(120,80,255)
Container.CanvasSize = UDim2.new(0,0,0,0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout",Container)
Layout.Padding = UDim.new(0,10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local UIPadding = Instance.new("UIPadding", Container)
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 10)

local dragging, dragInput, dragStart, startPos = false,nil,nil,nil

local function UpdateMain(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        UpdateMain(input)
    end
end)

local function CreateToggle(text,callback)
    local Holder = Instance.new("Frame",Container)
    Holder.Size = UDim2.new(0, 275, 0, 42)
    Holder.BackgroundColor3 = Color3.fromRGB(30,30,36)
    Holder.BorderSizePixel = 0
    Instance.new("UICorner",Holder).CornerRadius = UDim.new(0,8)

    local Label = Instance.new("TextLabel",Holder)
    Label.Size = UDim2.new(1,-60,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Toggle = Instance.new("Frame",Holder)
    Toggle.Size = UDim2.new(0,42,0,20)
    Toggle.Position = UDim2.new(1,-50,0.5,-10)
    Toggle.BackgroundColor3 = Color3.fromRGB(70,70,80)
    Toggle.BorderSizePixel = 0
    Instance.new("UICorner",Toggle).CornerRadius = UDim.new(1,0)

    local Dot = Instance.new("Frame",Toggle)
    Dot.Size = UDim2.new(0,16,0,16)
    Dot.Position = UDim2.new(0,2,0.5,-8)
    Dot.BackgroundColor3 = Color3.new(1,1,1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner",Dot).CornerRadius = UDim.new(1,0)

    local Btn = Instance.new("TextButton",Holder)
    Btn.Size = UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Toggle.BackgroundColor3 = Color3.fromRGB(120,80,255)
            Dot.Position = UDim2.new(1,-18,0.5,-8)
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(70,70,80)
            Dot.Position = UDim2.new(0,2,0.5,-8)
        end
        callback(state)
    end)
end


-- ══════════════════════════════════════════════════════════════
--  Silent Aim System
-- ══════════════════════════════════════════════════════════════
local silentAimEnabled = false
local fovRadius        = 120
local aimTarget        = nil
local sendEventCounter = 0
local smoothTarget     = Vector3.new()
local positionHistory  = {}
local HISTORY_SIZE     = 10
local MAX_JUMP_VEL     = 150
local _hookBusy        = false
local _multiShotGuard  = false
local shotMultiplier   = 1

local SendRemote
pcall(function()
    SendRemote = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Send", 5)
end)

local function getPing()
    local gui   = LocalPlayer:FindFirstChild("PlayerGui")
    local stats = gui and gui:FindFirstChild("NetworkStats")
    local label = stats and stats:FindFirstChild("PingLabel")
    if not label then return 0.2 end
    local num = tonumber(tostring(label.Text):match("%d+"))
    if not num then return 0.2 end
    local ping = num / 1000
    return (ping < 0 or ping > 2) and 0.2 or ping
end

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum  = player.Character:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                positionHistory[player] = positionHistory[player] or {}
                table.insert(positionHistory[player], { time = os.clock(), pos = root.Position })
                if #positionHistory[player] > HISTORY_SIZE then
                    table.remove(positionHistory[player], 1)
                end
            else
                positionHistory[player] = nil
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) positionHistory[p] = nil end)

local function calcVelocity(player)
    local h = positionHistory[player]
    if not h or #h < 2 then return Vector3.new() end
    local sum, tw = Vector3.new(), 0
    for i = 2, #h do
        local dt = h[i].time - h[i-1].time
        if dt > 0 then
            local raw = (h[i].pos - h[i-1].pos) / dt
            local c = Vector3.new(math.clamp(raw.X,-120,120), math.clamp(raw.Y,-150,150), math.clamp(raw.Z,-120,120))
            sum = sum + c * i; tw = tw + i
        end
    end
    if tw == 0 then return Vector3.new() end
    local avg = sum / tw
    if avg.Y > MAX_JUMP_VEL then return Vector3.new(avg.X*1.15, math.clamp(avg.Y*0.85,0,400), avg.Z*1.15) end
    return avg
end

local function predictPos(part)
    if not part then return Vector3.zero end
    local player   = Players:GetPlayerFromCharacter(part.Parent)
    local velocity = (player and calcVelocity(player)) or Vector3.zero
    local ping     = math.clamp(getPing(), 0.06, 0.35)
    local hSpeed   = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    local mult = hSpeed>60 and 1.50 or hSpeed>50 and 1.42 or hSpeed>35 and 1.32 or hSpeed>20 and 1.22 or hSpeed>10 and 1.15 or 1.05
    if ping > 0.15 then mult = mult * 0.93 end
    local hor  = Vector3.new(velocity.X,0,velocity.Z) * ping * mult
    local vert = Vector3.new(0, math.clamp(velocity.Y*ping*0.30,-4,4), 0)
    local jb   = Vector3.new(0, velocity.Y>20 and 0.50 or velocity.Y>15 and 0.35 or 0, 0)
    local ho   = part.Name=="Head" and Vector3.new(0, hSpeed>30 and 0.14 or hSpeed>22 and 0.10 or 0.05, 0) or Vector3.zero
    return part.Position + hor + vert + jb + ho
end

local function isBehindWall(origin, target)
    if not origin or not target then return false end
    local dir = target - origin
    if dir.Magnitude < 1 then return false end
    local result = workspace:Raycast(origin, dir, RaycastParams.new())
    if not result then return false end
    local inst = result.Instance
    local mc = LocalPlayer.Character
    local ac = aimTarget and aimTarget.Character
    return inst and not ((mc and inst:IsDescendantOf(mc)) or (ac and inst:IsDescendantOf(ac)))
end

local function getClosestSA()
    local best, bestDist = nil, fovRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local hum  = player.Character:FindFirstChild("Humanoid")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if head and hum and hum.Health > 0 and root then
                local pos, visible = Camera:WorldToViewportPoint(head.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= fovRadius and dist < bestDist then
                        bestDist = dist; best = player
                    end
                end
            end
        end
    end
    return best
end

-- FOV Circle
local saFovLines = {}
for i = 1, 16 do
    local l = Drawing.new("Line")
    l.Visible = false; l.Thickness = 1.5
    l.Color   = Color3.fromHSV(i/16, 1, 1)
    saFovLines[i] = l
end

-- Red Line
local saRedLine       = Drawing.new("Line")
saRedLine.Thickness   = 1
saRedLine.Color       = Color3.fromRGB(255, 50, 50)
saRedLine.Visible     = false

-- Hook
local originalFireServer
task.spawn(function()
    if SendRemote and SendRemote.FireServer then
        pcall(function()
            originalFireServer = hookfunction(SendRemote.FireServer, function(self, ...)
                if self ~= SendRemote or _hookBusy then return originalFireServer(self, ...) end
                _hookBusy = true
                local args = { ... }
                if silentAimEnabled and args[2] == "shoot_gun" and aimTarget then
                    local head = aimTarget.Character and aimTarget.Character:FindFirstChild("Head")
                    local root = aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart")
                    local hum  = aimTarget.Character and aimTarget.Character:FindFirstChild("Humanoid")
                    if head and root and hum then
                        local aimPos    = predictPos(head)
                        local myHead    = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                        local originPos = myHead and myHead.Position or nil
                        local function isShotgun()
                            local char = LocalPlayer.Character
                            if not char then return false end
                            for _, tool in ipairs(char:GetChildren()) do
                                if tool:IsA("Tool") then
                                    local ammo = tool:GetAttribute("AmmoType")
                                    if ammo == "shotgun" or ammo == "shootgun" then return true end
                                end
                            end
                            return false
                        end
                        if isShotgun() then
                            args[4] = CFrame.new(originPos, aimPos)
                            local pellets = {}
                            for i = 1, 6 do
                                local sp = Vector3.new(math.random(-2,2)*0.03, math.random(-2,2)*0.03, math.random(-2,2)*0.03)
                                table.insert(pellets, { [1] = { Instance=head, Normal=Vector3.new(0,1,0), Position=aimPos+sp }})
                            end
                            args[5] = pellets
                        else
                            local wb = isBehindWall(originPos, aimPos)
                            args[4] = wb and CFrame.new(math.huge,math.huge,math.huge) or CFrame.new(originPos, aimPos)
                            args[5] = { [1] = { [1] = { Instance=head, Normal=Vector3.new(0,1,0), Position=aimPos }}}
                        end
                    end
                end
                local res = originalFireServer(self, table.unpack(args))
                _hookBusy = false
                return res
            end)
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        aimTarget = silentAimEnabled and getClosestSA() or nil
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local t = tick()
        for i = 1, 16 do
            local a1 = math.rad((i-1)*(360/16))
            local a2 = math.rad(i*(360/16))
            saFovLines[i].From    = center + Vector2.new(math.cos(a1)*fovRadius, math.sin(a1)*fovRadius)
            saFovLines[i].To      = center + Vector2.new(math.cos(a2)*fovRadius, math.sin(a2)*fovRadius)
            saFovLines[i].Color   = Color3.fromHSV(((i/16)+t*0.5)%1, 1, 1)
            saFovLines[i].Visible = silentAimEnabled
        end
        local closest = silentAimEnabled and getClosestSA() or nil
        if closest and closest.Character then
            local hum  = closest.Character:FindFirstChild("Humanoid")
            local head = closest.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                smoothTarget = smoothTarget:Lerp(head.Position, 1)
                local sp, vis = Camera:WorldToViewportPoint(smoothTarget)
                if vis then
                    saRedLine.Visible = true
                    saRedLine.From    = center
                    saRedLine.To      = Vector2.new(sp.X, sp.Y)
                    saRedLine.Thickness = 1.3
                else
                    saRedLine.Visible = false
                end
            else
                saRedLine.Visible = false
            end
        else
            saRedLine.Visible = false
        end
    end)
end)

CreateToggle("AimLock",       function(v) AimEnabled       = v end)
CreateToggle("Look Head",     function(v) LookHeadEnabled  = v end)
CreateToggle("Highlight ESP", function(v) HighlightEnabled = v end)
CreateToggle("Name ESP",      function(v) NameESPEnabled   = v end)
CreateToggle("Hide Name",     function(v) HideNameEnabled  = v end)
CreateToggle("No Recoil",     function(v) NoRecoilEnabled  = v end)
CreateToggle("Crate Skip",    function(v) EnabledSkip      = v end)
CreateToggle("Item Aura",     function(v)
    ItemAuraEnabled = v
    if not v then
        for _, conn in pairs(ItemAuraConnections) do conn:Disconnect() end
        ItemAuraConnections = {}
    end
end)

CreateToggle("Inventory ESP", function(v)
    inventoryESPEnabled = v

    if not v then
        for _, gui in pairs(PlayerBillboards) do
            if gui then
                gui:Destroy()
            end
        end

        PlayerBillboards = {}
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createBillboardForPlayer(player)
            end
        end
    end
end)


CreateToggle("Silent Aim",  function(v) silentAimEnabled = v end)

local Float = Instance.new("ImageButton", UI)
Float.Size               = UDim2.new(0, 50, 0, 50)
Float.Position           = UDim2.new(0.02, 0, 0.25, 0)
Float.BackgroundTransparency = 1
Float.Image              = "rbxassetid://72830195117719"
Instance.new("UICorner", Float).CornerRadius = UDim.new(1, 0)

local uiOpen = true
local function ToggleUI()
    uiOpen = not uiOpen
    Main.Visible = uiOpen
    local click = TweenService:Create(Float,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 60, 0, 60)}
    )
    click:Play()
    click.Completed:Connect(function()
        TweenService:Create(Float,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 50, 0, 50)}
        ):Play()
    end)
end
Float.MouseButton1Click:Connect(ToggleUI)

local fDragging, fDragInput, fDragStart, fStartPos = false, nil, nil, nil
local function UpdateFloat(input)
    local delta = input.Position - fDragStart
    Float.Position = UDim2.new(
        fStartPos.X.Scale, fStartPos.X.Offset + delta.X,
        fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y
    )
end
Float.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        fDragging  = true
        fDragStart = input.Position
        fStartPos  = Float.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                fDragging = false
            end
        end)
    end
end)
Float.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        fDragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == fDragInput and fDragging then UpdateFloat(input) end
end)

local function hideMyName()
    if not HideNameEnabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BillboardGui") then v.Enabled = false end
    end
end
RunService.Heartbeat:Connect(hideMyName)

local CrateController = require(ReplicatedStorage.Modules.Game.CrateSystem.Crate)
task.spawn(function()
    while true do
        if EnabledSkip then
            for _, crate in pairs(CrateController.class.objects) do
                crate.states.open.set(true)
                CrateController.skipping.set(true)
            end
        end
        task.wait(0.05)
    end
end)

local function GetCamlookTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest = nil
    local closestDist = FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local pos, visible = Camera:WorldToViewportPoint(root.Position)
                if visible then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local dist = (screenPos - center).Magnitude
                    if dist <= FOV then
                        if Visible(root) then
                            if dist < closestDist then
                                closestDist = dist
                                closest = root
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- 2. สร้างตัวแปรควบคุม Camlook Head แยกอิสระ
local CamlookHeadEnabled = false

-- 3. ระบบทำงานของ Camlook Head (ล็อกเข้ากลางหัวตรงๆ ไม่หักลบความสูง)
RunService.RenderStepped:Connect(function()
    if not CamlookHeadEnabled then return end
    local target = GetCamlookTarget()
    if target then
        local head = target.Parent:FindFirstChild("Head")
        if head then
            -- ล็อกเข้าตำแหน่ง head.Position ตรงๆ 100%
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)

-- 4. สร้างฟังก์ชันสร้างปุ่มขึ้นมาใหม่โดยชี้ตำแหน่งไปที่ MainScroll ของลิงก์นี้
local function CreateCamlookToggle(text, callback)
    -- ใช้ MainScroll ตามโครงสร้าง UI ของสคริปต์ในลิงก์
    local Holder = Instance.new("Frame", MainScroll) 
    Holder.Size = UDim2.new(0, 275, 0, 42)
    Holder.BackgroundColor3 = Color3.fromRGB(30,30,36)
    Holder.BorderSizePixel = 0
    Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,8)

    local Label = Instance.new("TextLabel", Holder)
    Label.Size = UDim2.new(1,-60,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Toggle = Instance.new("Frame", Holder)
    Toggle.Size = UDim2.new(0,42,0,20)
    Toggle.Position = UDim2.new(1,-50,0.5,-10)
    Toggle.BackgroundColor3 = Color3.fromRGB(70,70,80)
    Toggle.BorderSizePixel = 0
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

    local Dot = Instance.new("Frame", Toggle)
    Dot.Size = UDim2.new(0,16,0,16)
    Dot.Position = UDim2.new(0,2,0.5,-8)
    Dot.BackgroundColor3 = Color3.new(1,1,1)
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)

    local Btn = Instance.new("TextButton", Holder)
    Btn.Size = UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Toggle.BackgroundColor3 = Color3.fromRGB(120,80,255)
            Dot.Position = UDim2.new(1,-18,0.5,-8)
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(70,70,80)
            Dot.Position = UDim2.new(0,2,0.5,-8)
        end
        callback(state)
    end)
end

-- 5. เรียกใช้งานปุ่ม Toggle อันใหม่ให้ไปปรากฏในเมนู
CreateCamlookToggle("Camlook Head", function(v) CamlookHeadEnabled = v end)
