local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ContentProvider = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer

local ItemESP_Enabled = true

local BillboardCache = {}

local ItemESP_UpdateConnections = {}

local WeaponDB = {}

local PreloadedImages = {}

local RARITY_COLORS = {

    ["Common"] = Color3.fromRGB(255, 255, 255),

    ["Uncommon"] = Color3.fromRGB(99, 255, 52),

    ["Rare"] = Color3.fromRGB(51, 170, 255),

    ["Epic"] = Color3.fromRGB(237, 44, 255),

    ["Legendary"] = Color3.fromRGB(255, 150, 0),

    ["Omega"] = Color3.fromRGB(255, 20, 51),

}

local function generateUniqueKey(tool)

    if not tool or not tool:IsA("Tool") then return nil end

    local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id")

    if itemId and itemId ~= "" and (typeof(itemId) == "string" or typeof(itemId) == "number") then

        return "ITEMID_" .. tostring(itemId)

    end

    local partsData = {}

    for _, part in ipairs(tool:GetDescendants()) do

        if part:IsA("SpecialMesh") and part.MeshId and part.MeshId ~= "" and part.MeshId ~= "rbxassetid://" then

            table.insert(partsData, "MESH_"..part.MeshId.."|TEX_"..(part.TextureId or "NOTEX"))

        elseif part:IsA("MeshPart") and part.MeshId and part.MeshId ~= "" and part.MeshId ~= "rbxassetid://" then

            table.insert(partsData, "MESH_"..part.MeshId.."|TEX_"..(part.TextureID or "NOTEX"))

        elseif part:IsA("Decal") and part.Texture and part.Texture ~= "" and part.Texture ~= "rbxassetid://" then

            table.insert(partsData, "DECAL_"..part.Texture)

        elseif part:IsA("Part") then

            table.insert(partsData, "PART_"..part.Name.."_"..part.Size.X.."x"..part.Size.Y.."x"..part.Size.Z)

        end

    end

    if #partsData > 0 then

        table.sort(partsData)

        return "MESHKEY_" .. table.concat(partsData, ";")

    end

    local displayName = tool:GetAttribute("DisplayName") or tool.Name

    local toolName = tool.Name

    local rarity = tool:GetAttribute("RarityName") or tool:GetAttribute("Rarity") or "Unknown"

    local imageId = tool:GetAttribute("ImageId") or "NOIMAGE"

    return "NAME_" .. displayName .. "_" .. toolName .. "_" .. rarity .. "_" .. imageId

end

-- เธฅเธเธ—เธฐเน€เธเธตเธขเธเนเธญเน€เธ—เธกเธ—เธฑเนเธเธซเธกเธ”

local function registerItems(folder)

    for _, tool in ipairs(folder:GetDescendants()) do

        if not tool:IsA("Tool") then continue end

        local key = generateUniqueKey(tool)

        if not key then continue end

        local displayName = tool:GetAttribute("DisplayName") or tool.Name

        local imageId = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"

        local rarity = tool:GetAttribute("RarityName") or tool:GetAttribute("Rarity") or "Common"

        WeaponDB[key] = {

            Name = displayName,

            Rarity = rarity,

            ImageId = imageId,

            ToolName = tool.Name,

            Key = key

        }

        -- Preload เธฃเธนเธเธ เธฒเธ

        if imageId and imageId ~= "" and not PreloadedImages[imageId] then

            PreloadedImages[imageId] = true

            task.spawn(function()

                pcall(function()

                    ContentProvider:PreloadAsync({imageId})

                end)

            end)

        end

    end

end

-- เธฅเธเธ—เธฐเน€เธเธตเธขเธเธ•เธญเธเน€เธฃเธดเนเธก

pcall(function()

    local itemsFolder = ReplicatedStorage:WaitForChild("Items", 5)

    if itemsFolder then registerItems(itemsFolder) end

    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do

        if obj:IsA("Folder") and (obj.Name:find("Weapon") or obj.Name:find("Item") or obj.Name:find("Tool")) then

            registerItems(obj)

        end

    end

    registerItems(game:GetService("StarterPack"))

end)

local function getWeaponInfo(tool)

    if not tool or not tool:IsA("Tool") then return nil end

    local key = generateUniqueKey(tool)

    return WeaponDB[key]

end

local function createBillboardForPlayer(player)

    if player == LocalPlayer or BillboardCache[player] then return end

    local billboard, container, layout

    local connections = {}

    local function updateESP()

        if not ItemESP_Enabled or not billboard.Parent then return end

        local currentTools = {}

        local function scan(folder)

            if not folder then return end

            for _, tool in ipairs(folder:GetChildren()) do

                if tool:IsA("Tool") and tool.Name ~= "Fists" then

                    local info = getWeaponInfo(tool)

                    if info then

                        table.insert(currentTools, info)

                    end

                end

            end

        end

        local char = player.Character

        if char then

            scan(char)

            local backpack = player:FindFirstChild("Backpack")

            if backpack then scan(backpack) end

        end

        container:ClearAllChildren()

        layout = Instance.new("UIGridLayout")

        layout.CellSize = UDim2.new(0, 35, 0, 35)

        layout.CellPadding = UDim2.new(0, 6, 0, 0)

        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        layout.VerticalAlignment = Enum.VerticalAlignment.Center

        layout.SortOrder = Enum.SortOrder.LayoutOrder

        layout.Parent = container

        for i, info in ipairs(currentTools) do

            local img = Instance.new("ImageLabel")

            img.Parent = container

            img.Size = UDim2.new(0, 35, 0, 35)

            img.BackgroundTransparency = 1

            img.Image = info.ImageId or "rbxassetid://7072725737"

            img.ScaleType = Enum.ScaleType.Fit

            img.LayoutOrder = i

            local color = RARITY_COLORS[info.Rarity] or Color3.fromRGB(255, 255, 255)

            img.ImageColor3 = color:Lerp(Color3.new(1,1,1), 0.35)

        end

    end

    local function setupBillboard()

        local char = player.Character

        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")

        if not hrp then return end

        if BillboardCache[player] then

            BillboardCache[player]:Destroy()

        end

        for _, conn in pairs(connections) do

            if conn.Connected then conn:Disconnect() end

        end

        connections = {}

        billboard = Instance.new("BillboardGui")

        billboard.Name = "ItemESP"

        billboard.Adornee = hrp

        billboard.Size = UDim2.new(0, 280, 0, 40)

        billboard.StudsOffset = Vector3.new(0, -6.5, 0)

        billboard.AlwaysOnTop = true

        billboard.LightInfluence = 0

        billboard.Parent = hrp

        container = Instance.new("Frame", billboard)

        container.Size = UDim2.new(1, 0, 1, 0)

        container.BackgroundTransparency = 1

        BillboardCache[player] = billboard

        updateESP()

        local backpack = player:FindFirstChild("Backpack")

        if backpack then

            table.insert(connections, backpack.ChildAdded:Connect(updateESP))

            table.insert(connections, backpack.ChildRemoved:Connect(updateESP))

        end

        table.insert(connections, char.ChildAdded:Connect(function(child)

            if child:IsA("Tool") then

                task.defer(updateESP)

            end

        end))

        table.insert(connections, char.ChildRemoved:Connect(function(child)

            if child:IsA("Tool") then

                task.defer(updateESP)

            end

        end))

        table.insert(connections, player.ChildAdded:Connect(function(child)

            if child.Name == "Backpack" then

                task.wait()

                table.insert(connections, child.ChildAdded:Connect(updateESP))

                table.insert(connections, child.ChildRemoved:Connect(updateESP))

                updateESP()

            end

        end))

    end

    if player.Character then

        task.spawn(setupBillboard)

    end

    -- เน€เธกเธทเนเธญเธ•เธฑเธงเธฅเธฐเธเธฃเน€เธเธดเธ”เนเธซเธกเน

    table.insert(connections, player.CharacterAdded:Connect(function()

        task.wait(1)

        setupBillboard()

    end))

    ItemESP_UpdateConnections[player] = connections

end

-- เธ•เธฑเนเธเธเนเธฒเธชเธณเธซเธฃเธฑเธเธเธนเนเน€เธฅเนเธเธ—เธตเนเธกเธตเธญเธขเธนเน

for _, p in ipairs(Players:GetPlayers()) do

    if p ~= LocalPlayer then

        createBillboardForPlayer(p)

    end

end

-- เธเธนเนเน€เธฅเนเธเนเธซเธกเน

Players.PlayerAdded:Connect(function(p)

    if p ~= LocalPlayer then

        createBillboardForPlayer(p)

    end

end)

-- เธฅเธเน€เธกเธทเนเธญเธญเธญเธ

Players.PlayerRemoving:Connect(function(p)

    if BillboardCache[p] then

        BillboardCache[p]:Destroy()

        BillboardCache[p] = nil

    end

    if ItemESP_UpdateConnections[p] then

        for _, conn in pairs(ItemESP_UpdateConnections[p]) do

            if conn.Connected then conn:Disconnect() end

        end

        ItemESP_UpdateConnections[p] = nil

    end

end)