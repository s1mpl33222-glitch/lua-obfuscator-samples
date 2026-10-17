-- KASS HUB | MENU
-- Anti Hit, Anti Trap, Insta Grab, ESP Top-1 e menu móvel.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local runtimeEnv = getgenv and getgenv() or _G
local rng = Random.new()
local uiConnections = {}

if type(runtimeEnv.__KassHubMenuCleanup) == "function" then
    pcall(runtimeEnv.__KassHubMenuCleanup)
end
for _, oldName in ipairs({"KASS_COMBAT_MENU", "KASS_PET_BOARD"}) do
    local oldGui = PlayerGui:FindFirstChild(oldName)
    if oldGui then pcall(function() oldGui:Destroy() end) end
end

--==================================================
-- INSTA GRAB
-- Modificado para alterar somente o prompt CarryAreaEgg de SmartPromptPart.
--==================================================

local InstaGrab = {}
local instaEnabled = false
local instaConnections = {}
local originalHold = {}

local function isCarryEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") or prompt.Name ~= "CarryAreaEgg" then
        return false
    end
    local parent = prompt.Parent
    return parent ~= nil and parent.Name == "SmartPromptPart"
end

local function setInstantPrompt(prompt)
    if not instaEnabled or not isCarryEggPrompt(prompt) then return end
    if originalHold[prompt] == nil then
        originalHold[prompt] = prompt.HoldDuration
    end
    if prompt.HoldDuration ~= 0 then
        pcall(function() prompt.HoldDuration = 0 end)
    end
end

local function findCarryPrompt(container)
    if not container or container.Name ~= "SmartPromptPart" then return nil end
    local prompt = container:FindFirstChild("CarryAreaEgg")
    if prompt and prompt:IsA("ProximityPrompt") then return prompt end
    return nil
end

function InstaGrab.start()
    if instaEnabled then return true end
    instaEnabled = true

    instaConnections[#instaConnections + 1] = ProximityPromptService.PromptShown:Connect(function(prompt)
        setInstantPrompt(prompt)
    end)

    for _, object in ipairs(Workspace:GetChildren()) do
        setInstantPrompt(findCarryPrompt(object))
    end

    instaConnections[#instaConnections + 1] = Workspace.ChildAdded:Connect(function(object)
        if object.Name ~= "SmartPromptPart" then return end
        task.defer(function()
            local prompt = object:FindFirstChild("CarryAreaEgg") or object:WaitForChild("CarryAreaEgg", 2)
            setInstantPrompt(prompt)
        end)
    end)
    return true
end

function InstaGrab.stop()
    instaEnabled = false
    for prompt, duration in pairs(originalHold) do
        pcall(function()
            if prompt and prompt.Parent then prompt.HoldDuration = duration end
        end)
    end
    table.clear(originalHold)
    for _, connection in ipairs(instaConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(instaConnections)
end

--==================================================
-- ANTI TRAP (baseado no bloco ANTI TRAP de text.txt)
--==================================================

local AntiTrap = {
    enabled = true,
    originals = setmetatable({}, {__mode = "k"}),
    running = false,
}

local function processTrap(trap)
    if not AntiTrap.enabled or not trap or not trap.Parent then return end
    local hitbox = trap:FindFirstChild("Hitbox")
    if hitbox and hitbox:IsA("BasePart") then
        if AntiTrap.originals[hitbox] == nil then
            AntiTrap.originals[hitbox] = hitbox.CanTouch
        end
        if hitbox.CanTouch then
            pcall(function() hitbox.CanTouch = false end)
        end
    end
end

function AntiTrap.setEnabled(enabled)
    AntiTrap.enabled = enabled == true
    if AntiTrap.enabled then
        for _, trap in ipairs(CollectionService:GetTagged("PlacedTrap")) do
            processTrap(trap)
        end
        if not AntiTrap.running then
            AntiTrap.running = true
            task.spawn(function()
                while AntiTrap.enabled and PlayerGui.Parent do
                    task.wait(0.3)
                    local ok, traps = pcall(CollectionService.GetTagged, CollectionService, "PlacedTrap")
                    if ok and type(traps) == "table" then
                        for _, trap in ipairs(traps) do processTrap(trap) end
                    end
                end
                AntiTrap.running = false
            end)
        end
    else
        for hitbox, original in pairs(AntiTrap.originals) do
            pcall(function()
                if hitbox and hitbox.Parent then hitbox.CanTouch = original end
            end)
            AntiTrap.originals[hitbox] = nil
        end
    end
end

uiConnections[#uiConnections + 1] = CollectionService:GetInstanceAddedSignal("PlacedTrap"):Connect(function(trap)
    task.defer(processTrap, trap)
end)
AntiTrap.setEnabled(true)

--==================================================
-- ESP: somente o ovo/pet disponível de maior valor
--==================================================

local EggState
local AssetsData
pcall(function()
    EggState = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("EggState"))
end)
pcall(function()
    AssetsData = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("Assets"))
end)

local function assetDirectory()
    if type(AssetsData) ~= "table" then return nil end
    return AssetsData.Directory or AssetsData.Assets or AssetsData
end

local function normalizeKey(value)
    return tostring(value or ""):lower():gsub("[%s_%-%[%]%(%)%.'/\\]", "")
end

local function getAssetInfo(category)
    local directory = assetDirectory()
    if not directory or not category then return nil end
    if directory[category] then return directory[category] end
    local wanted = normalizeKey(category)
    for key, info in pairs(directory) do
        if normalizeKey(key) == wanted then return info end
        if type(info) == "table"
            and (normalizeKey(info.DisplayName) == wanted or normalizeKey(info.Name) == wanted) then
            return info
        end
    end
    return nil
end

local function toImageId(value)
    if value == nil then return "" end
    local text = tostring(value)
    if text == "" then return "" end
    if text:match("^%d+$") then return "rbxassetid://" .. text end
    return text
end

local function categoryOf(record)
    return tostring(record.AssetCategory or record.Category or record.Name or "Egg")
end

local function getEggIcon(record)
    local category = categoryOf(record)
    local icon = record.Icon or record.Image or record.Thumbnail or record.Texture or record.Decal
    local info = getAssetInfo(category)
    if type(info) == "table" then
        icon = icon or info.Icon or info.Image or info.Thumbnail or info.Texture or info.Decal
        if type(info.Pet) == "table" then
            icon = icon or info.Pet.Icon or info.Pet.Image or info.Pet.Texture
        end
        if type(info.Egg) == "table" then
            icon = icon or info.Egg.Icon or info.Egg.Image or info.Egg.Texture
        end
    end
    return toImageId(icon)
end

local function getRarityName(record)
    local rarity = record.Rarity
    if type(rarity) == "table" then
        return tostring(rarity.DisplayName or rarity._id or rarity.Name or "Common")
    elseif rarity ~= nil then
        return tostring(rarity)
    end
    local info = getAssetInfo(categoryOf(record))
    if type(info) == "table" and info.Rarity ~= nil then
        local value = info.Rarity
        if type(value) == "table" then
            return tostring(value.DisplayName or value._id or value.Name or "Common")
        end
        return tostring(value)
    end
    return "Common"
end

local RARITY_SCORE = {
    Secret = 800, Cosmic = 700, Mythic = 600, Rainbow = 600,
    Legendary = 500, Epic = 400, Rare = 300, Uncommon = 200, Common = 100,
}

local function mutationMultiplier(record)
    local multiplier = 1
    local mutations = record.Mutations or record.Mutation
    if type(mutations) == "table" then
        for _, mutation in pairs(mutations) do
            if type(mutation) == "table" then
                multiplier *= tonumber(mutation.Multiplier or mutation.Value or mutation.Scale) or 1.5
            else
                local text = tostring(mutation):lower()
                if text:find("rainbow") then multiplier *= 3
                elseif text:find("gold") then multiplier *= 2
                elseif text:find("silver") then multiplier *= 1.5
                elseif text:find("parasite") or text:find("monstrous") then multiplier *= 5
                else multiplier *= 1.25 end
            end
        end
    elseif mutations then
        multiplier *= 1.5
    end
    if record.HasParasite then multiplier *= 5 end
    return multiplier
end

local function getEggValue(record)
    local info = getAssetInfo(categoryOf(record))
    local value = tonumber(record.Money or record.Cash or record.Income or record.EarningRate
        or record.Value or record.Price)
    if (not value or value <= 0) and type(info) == "table" then
        value = tonumber(info.Money or info.Cash or info.Income or info.EarningRate
            or info.ProfileIncome or info.SalePrice or info.Price)
        if (not value or value <= 0) and type(info.Egg) == "table" then
            value = tonumber(info.Egg.Money or info.Egg.Income or info.Egg.EarningRate
                or info.Egg.SalePrice)
        end
    end
    value = tonumber(value) or 0
    local scale = tonumber(record.AssetScale or record.Scale or record.NestScale) or 1
    value *= scale * mutationMultiplier(record)
    if value <= 0 then
        local rarity = getRarityName(record)
        local areaNumber = tonumber(tostring(record.AreaId or ""):match("%d+")) or 50
        value = (RARITY_SCORE[rarity] or 100) * math.max(areaNumber, 50) * math.max(scale, 1)
    end
    return value
end

local function recordPosition(record)
    for _, key in ipairs({"BoundsCFrame", "CFrame", "BottomCFrame", "Pivot"}) do
        local value = record[key]
        if typeof(value) == "CFrame" then return value.Position end
        if typeof(value) == "Vector3" then return value end
    end
    local model = record.PhysicalModel or record.Model
    if model and model:IsA("Model") then
        local ok, pivot = pcall(function() return model:GetPivot() end)
        if ok and pivot then return pivot.Position end
    elseif model and model:IsA("BasePart") then
        return model.Position
    end
    return nil
end

local function isAvailableRecord(record)
    if type(record) ~= "table" or not (record.Uid or record.UID) then return false end
    local state = tostring(record.State or "Slot")
    if state ~= "Slot" and state ~= "Dropped" then return false end
    if record.CarrierUserId and tonumber(record.CarrierUserId) ~= 0 then return false end
    return recordPosition(record) ~= nil
end

local function readCanonicalEggs()
    if type(EggState) ~= "table" then return nil end
    for _, methodName in ipairs({"GetAreaEggSnapshot", "ReadFieldEggs"}) do
        local method = EggState[methodName]
        if type(method) == "function" then
            local ok, snapshot = pcall(method)
            if ok and type(snapshot) == "table" then
                local source = snapshot.Records or snapshot
                local records = {}
                if type(source) == "table" then
                    for _, record in pairs(source) do
                        if isAvailableRecord(record) then
                            records[#records + 1] = record
                        end
                    end
                end
                return records
            end
        end
    end
    return nil
end

local function findModelForRecord(record)
    local existing = record.PhysicalModel or record.Model
    if existing and existing.Parent then return existing end
    local folder = Workspace:FindFirstChild("AreaEggSlotsClient")
    if not folder then return nil end
    local wanted = tostring(record.Uid or record.UID or "")
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local uid = tostring(model:GetAttribute("UID") or model:GetAttribute("Uid") or model.Name)
            if uid == wanted then return model end
        end
    end
    return nil
end

local function readVisibleEggs()
    local folder = Workspace:FindFirstChild("AreaEggSlotsClient")
    local records = {}
    if not folder then return records end
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local state = tostring(model:GetAttribute("State") or "Slot")
            local carrier = model:GetAttribute("CarrierUserId")
            local uid = model:GetAttribute("UID") or model:GetAttribute("Uid") or model.Name
            local category = model:GetAttribute("Category") or model:GetAttribute("AssetCategory") or model.Name
            if uid and state ~= "Carried" and state ~= "Claimed"
                and (carrier == nil or tonumber(carrier) == 0) then
                local ok, pivot = pcall(function() return model:GetPivot() end)
                if ok and pivot then
                    records[#records + 1] = {
                        Uid = uid,
                        AssetCategory = category,
                        AreaId = model:GetAttribute("AreaId") or model:GetAttribute("Area"),
                        Rarity = model:GetAttribute("Rarity"),
                        AssetScale = tonumber(model:GetAttribute("Scale") or model:GetAttribute("AssetScale")) or 1,
                        Mutations = model:GetAttribute("Mutations") or model:GetAttribute("Mutation"),
                        BoundsCFrame = pivot,
                        State = state,
                        PhysicalModel = model,
                    }
                end
            end
        end
    end
    return records
end

local function readFieldEggs()
    -- Prefer the authoritative state so an egg already picked up is immediately excluded.
    local canonical = readCanonicalEggs()
    if canonical ~= nil then return canonical end
    return readVisibleEggs()
end

local function formatValue(value)
    value = tonumber(value) or 0
    if value >= 1e12 then return string.format("%.1fT", value / 1e12) end
    if value >= 1e9 then return string.format("%.1fB", value / 1e9) end
    if value >= 1e6 then return string.format("%.2fM", value / 1e6) end
    if value >= 1e3 then return string.format("%.1fK", value / 1e3) end
    return tostring(math.floor(value))
end

local function getAssetName(record)
    local category = categoryOf(record)
    local info = getAssetInfo(category)
    if type(info) == "table" then
        return tostring(info.DisplayName or info.Name or category)
    end
    return category
end

local function getTopCandidate()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best
    for _, record in ipairs(readFieldEggs()) do
        local position = recordPosition(record)
        if position then
            local distance = (root.Position - position).Magnitude
            local value = getEggValue(record)
            if not best or value > best.value or (value == best.value and distance < best.distance) then
                best = {
                    uid = tostring(record.Uid or record.UID),
                    record = record,
                    position = position,
                    distance = distance,
                    value = value,
                    name = getAssetName(record),
                    rarity = getRarityName(record),
                    image = getEggIcon(record),
                    model = findModelForRecord(record),
                }
            end
        end
    end
    return best
end

local espEnabled = false
local espWorker = false
local billboard
local billboardRoot
local billboardTargetUid
local nameLabel
local valueLabel
local distanceLabel
local iconImage

local function removeBillboard()
    if billboard then pcall(function() billboard:Destroy() end) end
    if billboardRoot then pcall(function() billboardRoot:Destroy() end) end
    billboard, billboardRoot, billboardTargetUid = nil, nil, nil
    nameLabel, valueLabel, distanceLabel, iconImage = nil, nil, nil, nil
end

local function findAdornee(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    if not model:IsA("Model") then return nil end
    if model.PrimaryPart then return model.PrimaryPart end
    return model:FindFirstChildWhichIsA("BasePart", true)
end

local function createBillboard(target)
    removeBillboard()
    local model = target.model
    local adornee = findAdornee(model)
    if not adornee then
        local anchor = Instance.new("Part")
        anchor.Name = "KASS_Top1Anchor"
        anchor.Anchored = true
        anchor.Transparency = 1
        anchor.CanCollide = false
        anchor.CanTouch = false
        anchor.CanQuery = false
        anchor.Size = Vector3.new(0.2, 0.2, 0.2)
        anchor.CFrame = CFrame.new(target.position)
        anchor.Parent = Workspace
        billboardRoot = anchor
        adornee = anchor
    end

    local board = Instance.new("BillboardGui")
    board.Name = "KASS_Top1PetESP"
    board.Adornee = adornee
    board.Size = UDim2.fromOffset(124, 42)
    board.AlwaysOnTop = true -- continua visível mesmo com objetos entre câmera e ovo
    board.LightInfluence = 0
    board.MaxDistance = 0
    board.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
    board.Parent = PlayerGui
    billboard = board
    billboardTargetUid = target.uid

    local background = Instance.new("Frame")
    background.Name = "Card"
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = Color3.fromRGB(22, 7, 40)
    background.BackgroundTransparency = 0.5
    background.BorderSizePixel = 0
    background.Parent = board
    Instance.new("UICorner", background).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = background

    iconImage = Instance.new("ImageLabel")
    iconImage.Name = "PetIcon"
    iconImage.Size = UDim2.fromOffset(26, 26)
    iconImage.Position = UDim2.fromOffset(5, 8)
    iconImage.BackgroundColor3 = Color3.fromRGB(35, 16, 58)
    iconImage.BackgroundTransparency = 0.35
    iconImage.BorderSizePixel = 0
    iconImage.ScaleType = Enum.ScaleType.Fit
    iconImage.Parent = background
    Instance.new("UICorner", iconImage).CornerRadius = UDim.new(0, 5)

    nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PetName"
    nameLabel.Position = UDim2.fromOffset(36, 3)
    nameLabel.Size = UDim2.new(1, -41, 0, 13)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 9
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = background

    valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "PetValue"
    valueLabel.Position = UDim2.fromOffset(36, 16)
    valueLabel.Size = UDim2.new(1, -41, 0, 12)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 8
    valueLabel.TextColor3 = Color3.fromRGB(219, 176, 255)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = background

    distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Position = UDim2.fromOffset(36, 29)
    distanceLabel.Size = UDim2.new(1, -41, 0, 10)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 7
    distanceLabel.TextColor3 = Color3.fromRGB(225, 225, 235)
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    distanceLabel.Parent = background
end

local function updateBillboard(target)
    if not billboard or billboardTargetUid ~= target.uid
        or not billboard.Adornee or not billboard.Adornee.Parent then
        createBillboard(target)
    end
    if billboardRoot and not target.model then
        billboardRoot.CFrame = CFrame.new(target.position)
    elseif target.model and billboard and billboard.Adornee ~= findAdornee(target.model) then
        createBillboard(target)
    end
    if not billboard then return end
    nameLabel.Text = target.name
    valueLabel.Text = "Valor: " .. formatValue(target.value) .. "  •  " .. target.rarity
    distanceLabel.Text = "Distância: " .. tostring(math.floor(target.distance + 0.5)) .. " studs"
    iconImage.Image = target.image or ""
end

local function startEsp()
    if espEnabled then return end
    espEnabled = true
    if espWorker then return end
    espWorker = true
    task.spawn(function()
        while espEnabled and PlayerGui.Parent do
            local ok, target = pcall(getTopCandidate)
            if ok and target then
                pcall(updateBillboard, target)
            else
                removeBillboard()
            end
            task.wait(0.45)
        end
        removeBillboard()
        espWorker = false
    end)
end

local function stopEsp()
    espEnabled = false
    if not espWorker then removeBillboard() end
end

--==================================================
-- MENU UI
--==================================================

local oldGui = PlayerGui:FindFirstChild("KASS_COMBAT_MENU")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KASS_COMBAT_MENU"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- ANTI HIT
-- Rota e resposta de loading adaptadas do arquivo Anti Hit reenviado.
--==================================================

local AntiHit = {
    enabled = false,
    teleporting = false,
}

local TeleportPoints = {
    Vector3.new(500.62, 241.28, -366.64),
    Vector3.new(504.45, 155.80, -366.35),
    Vector3.new(508.30, 70.28, -366.03),
    Vector3.new(513.86, 70.28, -366.25),
    Vector3.new(519.43, 70.28, -366.47),
    Vector3.new(524.32, 70.28, -366.59),
    Vector3.new(529.22, 70.28, -366.71),
    Vector3.new(538.01, 70.28, -365.55),
    Vector3.new(546.80, 70.28, -364.40),
}

local teleportOverlay = Instance.new("Frame")
teleportOverlay.Name = "AntiHitOverlay"
teleportOverlay.Size = UDim2.fromScale(1, 1)
teleportOverlay.BackgroundColor3 = Color3.fromRGB(10, 4, 18)
teleportOverlay.BackgroundTransparency = 1
teleportOverlay.BorderSizePixel = 0
teleportOverlay.Visible = false
teleportOverlay.ZIndex = 100
teleportOverlay.Parent = ScreenGui

local loadingText = Instance.new("TextLabel")
loadingText.AnchorPoint = Vector2.new(0.5, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.52, 10)
loadingText.Size = UDim2.fromOffset(300, 30)
loadingText.BackgroundTransparency = 1
loadingText.Text = "anti hit almost loaded"
loadingText.TextColor3 = Color3.fromRGB(220, 180, 255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 15
loadingText.ZIndex = 101
loadingText.Parent = teleportOverlay

local loadingBarBg = Instance.new("Frame")
loadingBarBg.AnchorPoint = Vector2.new(0.5, 0)
loadingBarBg.Position = UDim2.new(0.5, 0, 0.58, 10)
loadingBarBg.Size = UDim2.fromOffset(220, 5)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(35, 24, 48)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.ZIndex = 101
loadingBarBg.Parent = teleportOverlay
local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(1, 0)
loadingBarBgCorner.Parent = loadingBarBg

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(177, 82, 245)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.ZIndex = 102
loadingBarFill.Parent = loadingBarBg
local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(1, 0)
loadingBarFillCorner.Parent = loadingBarFill

local function teleportRoute(character)
    if not AntiHit.enabled or not character or not character.Parent then return end
    teleportOverlay.Visible = true
    teleportOverlay.BackgroundTransparency = 0.08
    loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    loadingText.Text = "anti hit almost loaded"

    local total = #TeleportPoints
    for index, position in ipairs(TeleportPoints) do
        if not AntiHit.enabled or not character.Parent then
            teleportOverlay.Visible = false
            return
        end
        local ok = pcall(function()
            character:PivotTo(CFrame.new(position))
        end)
        if not ok then
            teleportOverlay.Visible = false
            return
        end
        TweenService:Create(loadingBarFill, TweenInfo.new(0.05), {
            Size = UDim2.new(index / total, 0, 1, 0),
        }):Play()
        if index == total then loadingText.Text = "anti hit loaded!" end
        task.wait(0.05)
    end

    local fade = TweenService:Create(teleportOverlay, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1,
    })
    fade:Play()
    fade.Completed:Wait()
    teleportOverlay.Visible = false
end

function AntiHit.setEnabled(enabled)
    AntiHit.enabled = enabled == true
    if not AntiHit.enabled then
        teleportOverlay.Visible = false
        AntiHit.teleporting = false
    end
end

uiConnections[#uiConnections + 1] = ProximityPromptService.PromptTriggered:Connect(function(_, triggeredPlayer)
    if triggeredPlayer ~= LocalPlayer or not AntiHit.enabled or AntiHit.teleporting then return end
    local character = LocalPlayer.Character
    if not character then return end
    AntiHit.teleporting = true
    local ok, err = pcall(teleportRoute, character)
    AntiHit.teleporting = false
    if not ok then warn("[KASS] Anti Hit route error:", err) end
end)

local Sound = Instance.new("Sound")
Sound.Name = "KASSMenuClick"
Sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
Sound.Volume = 0.28
Sound.Parent = ScreenGui

local function playSound()
    pcall(function()
        Sound.TimePosition = 0
        Sound:Play()
    end)
end

local function makeCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function makeStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = parent
    return stroke
end

local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.AnchorPoint = Vector2.new(0.5, 0.5)
Menu.BackgroundColor3 = Color3.fromRGB(24, 5, 44)
Menu.BackgroundTransparency = 0.32
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.ClipsDescendants = true
Menu.Parent = ScreenGui
makeCorner(Menu, 0)
makeStroke(Menu, Color3.fromRGB(0, 0, 0), 4)

local menuScale = Instance.new("UIScale")
menuScale.Scale = 0.88
menuScale.Parent = Menu

local guiScaleValue = 1.0
local guiScaleEffect = Instance.new("UIScale")
guiScaleEffect.Scale = guiScaleValue
guiScaleEffect.Parent = Menu

local function resizeMenu()
    local camera = Workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local width = math.clamp(viewport.X * 0.36, 240, 360)
    local height = math.clamp(viewport.Y * 0.40, 240, 320)
    width = math.min(width, math.max(230, (viewport.X - 24) / guiScaleValue))
    height = math.min(height, math.max(230, (viewport.Y - 40) / guiScaleValue))
    Menu.Size = UDim2.fromOffset(width, height)
    Menu.Position = UDim2.new(0.5, 0, 0.5, 0)
end
resizeMenu()

local Floating = Instance.new("TextButton")
Floating.Name = "FloatingButton"
Floating.Size = UDim2.fromOffset(62, 62)
Floating.Position = UDim2.new(1, -42, 1, -42)
Floating.AnchorPoint = Vector2.new(0.5, 0.5)
Floating.BackgroundColor3 = Color3.fromRGB(47, 9, 82)
Floating.BackgroundTransparency = 0.38
Floating.BorderSizePixel = 0
Floating.AutoButtonColor = false
Floating.Active = true
Floating.Selectable = true
Floating.Interactable = true
Floating.Text = "KAS"
Floating.Font = Enum.Font.GothamBlack
Floating.TextSize = 16
Floating.TextColor3 = Color3.new(1, 1, 1)
Floating.ZIndex = 10
Floating.Parent = ScreenGui
makeCorner(Floating, 31)
makeStroke(Floating, Color3.fromRGB(0, 0, 0), 4)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.ZIndex = 7
Header.Size = UDim2.new(1, -16, 0, 48)
Header.Position = UDim2.fromOffset(8, 8)
Header.BackgroundColor3 = Color3.fromRGB(36, 9, 60)
Header.BackgroundTransparency = 0.34
Header.BorderSizePixel = 0
Header.Parent = Menu
makeCorner(Header, 0)
makeStroke(Header, Color3.fromRGB(0, 0, 0), 2)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.fromOffset(14, 0)
Title.BackgroundTransparency = 1
Title.Text = "KASS HUB"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 21
Title.TextColor3 = Color3.fromRGB(244, 233, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 8
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -80, 0, 15)
Subtitle.Position = UDim2.fromOffset(15, 29)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Ferramentas principais"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 10
Subtitle.TextColor3 = Color3.fromRGB(190, 155, 220)
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 8
Subtitle.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(34, 34)
CloseButton.Position = UDim2.new(1, -42, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(12, 3, 22)
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = false
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBlack
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.ZIndex = 8
CloseButton.Parent = Header
makeCorner(CloseButton, 0)
makeStroke(CloseButton, Color3.fromRGB(0, 0, 0), 2)

local LightningLayer = Instance.new("Frame")
LightningLayer.Name = "LightningFX"
LightningLayer.Size = UDim2.fromScale(1, 1)
LightningLayer.Position = UDim2.fromOffset(0, 0)
LightningLayer.BackgroundTransparency = 1
LightningLayer.ClipsDescendants = true
LightningLayer.ZIndex = 5
LightningLayer.Parent = Menu

local Content = Instance.new("ScrollingFrame")
Content.Name = "Options"
Content.Size = UDim2.new(1, -24, 1, -91)
Content.Position = UDim2.fromOffset(12, 64)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ZIndex = 3
Content.Parent = Menu

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 5)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, -24, 0, 15)
Footer.Position = UDim2.new(0, 12, 1, -19)
Footer.BackgroundTransparency = 1
Footer.Text = "KAS  •  toque para abrir, segure para mover"
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 9
Footer.TextColor3 = Color3.fromRGB(175, 145, 205)
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.ZIndex = 6
Footer.Parent = Menu

local function makeToggleRow(order, title, description, initial, onChanged, locked)
    local Row = Instance.new("Frame")
    Row.Name = title:gsub("%W", "") .. "Row"
    Row.Size = UDim2.new(1, 0, 0, 46)
    Row.BackgroundColor3 = locked and Color3.fromRGB(27, 18, 34) or Color3.fromRGB(31, 11, 50)
    Row.BackgroundTransparency = 0.46
    Row.BorderSizePixel = 0
    Row.LayoutOrder = order
    Row.ZIndex = 3
    Row.Parent = Content
    makeCorner(Row, 0)
    makeStroke(Row, Color3.fromRGB(0, 0, 0), 2)

    local Accent = Instance.new("Frame")
    Accent.Name = "Accent"
    Accent.Size = UDim2.new(0, 3, 0, 24)
    Accent.Position = UDim2.new(0, 0, 0.5, -12)
    Accent.BackgroundColor3 = Color3.fromRGB(166, 75, 245)
    Accent.BorderSizePixel = 0
    Accent.ZIndex = 5
    Accent.Parent = Row
    makeCorner(Accent, 2)

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -76, 0, 19)
    NameLabel.Position = UDim2.fromOffset(9, 4)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = title
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 12
    NameLabel.TextColor3 = locked and Color3.fromRGB(175, 165, 185) or Color3.new(1, 1, 1)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ZIndex = 6
    NameLabel.Parent = Row

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -82, 0, 14)
    Description.Position = UDim2.fromOffset(9, 24)
    Description.BackgroundTransparency = 1
    Description.Text = description
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 9
    Description.TextColor3 = Color3.fromRGB(185, 165, 205)
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextTruncate = Enum.TextTruncate.AtEnd
    Description.ZIndex = 6
    Description.Parent = Row

    local Switch = Instance.new("TextButton")
    Switch.Name = "Toggle"
    Switch.Size = UDim2.fromOffset(46, 24)
    Switch.Position = UDim2.new(1, -54, 0.5, -12)
    Switch.BackgroundColor3 = initial and Color3.fromRGB(141, 48, 219) or Color3.fromRGB(62, 54, 70)
    Switch.BorderSizePixel = 0
    Switch.AutoButtonColor = false
    Switch.Text = ""
    Switch.ZIndex = 7
    Switch.Parent = Row
    makeCorner(Switch, 0)
    makeStroke(Switch, Color3.fromRGB(0, 0, 0), 1)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(18, 18)
    Knob.Position = initial and UDim2.new(1, -21, 0.5, -9) or UDim2.fromOffset(3, 3)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 8
    Knob.Parent = Switch
    makeCorner(Knob, 10)

    local active = initial == true
    local function paint()
        local bg = active and Color3.fromRGB(141, 48, 219) or Color3.fromRGB(62, 54, 70)
        local pos = active and UDim2.new(1, -21, 0.5, -9) or UDim2.fromOffset(3, 3)
        TweenService:Create(Switch, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundColor3 = bg}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Position = pos}):Play()
    end

    Switch.Activated:Connect(function()
        playSound()
        if locked then
            Footer.Text = "Reenvie o arquivo Anti Hit para integrar essa opção"
            task.delay(2.4, function()
                if Footer and Footer.Parent then Footer.Text = "KAS  •  toque para abrir, segure para mover" end
            end)
            return
        end
        active = not active
        paint()
        local ok, err = pcall(onChanged, active)
        if not ok then
            active = false
            paint()
            warn("[KASS] Falha ao alternar " .. title .. ": " .. tostring(err))
        end
    end)
    return Row
end

makeToggleRow(1, "Anti Hit", "Rota de evasão ao acionar prompts", false, function(enabled)
    AntiHit.setEnabled(enabled)
end, false)
makeToggleRow(2, "Anti Trap", "Bloqueia as hitboxes de armadilhas", true, function(enabled)
    AntiTrap.setEnabled(enabled)
end, false)
makeToggleRow(3, "Insta Grab", "Pega ovos sem tempo de espera", false, function(enabled)
    if enabled then InstaGrab.start() else InstaGrab.stop() end
end, false)
makeToggleRow(4, "ESP Top 1", "Mostra o melhor ovo disponível", false, function(enabled)
    if enabled then startEsp() else stopEsp() end
end, false)

-- Drag do menu pela faixa superior (mouse e toque).
do
    local dragging = false
    local dragInput
    local dragStart
    local startPosition
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = Menu.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    uiConnections[#uiConnections + 1] = UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Menu.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
end

local isOpen = false
local animationToken = 0
local function setOpen(open)
    isOpen = open
    animationToken += 1
    local token = animationToken
    playSound()
    if open then
        Menu.Visible = true
        Menu.BackgroundTransparency = 0.5
        menuScale.Scale = 0.86
        TweenService:Create(menuScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(Menu, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.32}):Play()
        TweenService:Create(Floating, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Rotation = 12}):Play()
    else
        TweenService:Create(menuScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.88}):Play()
        TweenService:Create(Menu, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Floating, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Rotation = 0}):Play()
        task.delay(0.18, function()
            if token == animationToken and not isOpen then Menu.Visible = false end
        end)
    end
end

local floatDrag = {
    active = false,
    moved = false,
    pointerType = nil,
    input = nil,
    startPointer = nil,
    startCenter = nil,
}

Floating.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    floatDrag.active = true
    floatDrag.moved = false
    floatDrag.pointerType = Enum.UserInputType.MouseButton1
    floatDrag.input = input
    floatDrag.startPointer = Vector2.new(input.Position.X, input.Position.Y)
    floatDrag.startCenter = Floating.AbsolutePosition + Floating.AbsoluteSize / 2
end)

local function isTouchOnFloatingButton(position)
    local ok, objects = pcall(function()
        return PlayerGui:GetGuiObjectsAtPosition(position.X, position.Y)
    end)
    if not ok or type(objects) ~= "table" then return false end
    for _, object in ipairs(objects) do
        if object == Floating or object:IsDescendantOf(Floating) then
            return true
        end
    end
    return false
end

uiConnections[#uiConnections + 1] = UserInputService.TouchStarted:Connect(function(input)
    if floatDrag.active or not isTouchOnFloatingButton(input.Position) then return end
    floatDrag.active = true
    floatDrag.moved = false
    floatDrag.pointerType = Enum.UserInputType.Touch
    floatDrag.input = input
    floatDrag.startPointer = Vector2.new(input.Position.X, input.Position.Y)
    floatDrag.startCenter = Floating.AbsolutePosition + Floating.AbsoluteSize / 2
end)

local function moveFloatingButton(pointerPosition)
    if not floatDrag.active then return end
    local point = typeof(pointerPosition) == "Vector3"
        and Vector2.new(pointerPosition.X, pointerPosition.Y)
        or pointerPosition
    if typeof(point) ~= "Vector2" then return end
    local delta = point - floatDrag.startPointer
    if delta.Magnitude > 4 then floatDrag.moved = true end
    if not floatDrag.moved then return end

    local camera = Workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local half = Floating.AbsoluteSize / 2
    local center = floatDrag.startCenter + delta
    center = Vector2.new(
        math.clamp(center.X, half.X + 4, viewport.X - half.X - 4),
        math.clamp(center.Y, half.Y + 4, viewport.Y - half.Y - 4)
    )
    Floating.Position = UDim2.fromOffset(center.X, center.Y)
end

uiConnections[#uiConnections + 1] = UserInputService.InputChanged:Connect(function(input)
    if floatDrag.active and floatDrag.pointerType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement then
        moveFloatingButton(input.Position)
    end
end)

uiConnections[#uiConnections + 1] = UserInputService.TouchMoved:Connect(function(input)
    if floatDrag.active and floatDrag.pointerType == Enum.UserInputType.Touch then
        moveFloatingButton(input.Position)
    end
end)

local function finishFloatingPress()
    if not floatDrag.active then return end
    local wasClick = not floatDrag.moved
    floatDrag.active = false
    floatDrag.input = nil
    if wasClick then setOpen(not isOpen) end
end

uiConnections[#uiConnections + 1] = UserInputService.InputEnded:Connect(function(input)
    if floatDrag.pointerType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseButton1 then
        finishFloatingPress()
    end
end)

uiConnections[#uiConnections + 1] = UserInputService.TouchEnded:Connect(function()
    if floatDrag.pointerType == Enum.UserInputType.Touch then
        finishFloatingPress()
    end
end)

CloseButton.Activated:Connect(function() if isOpen then setOpen(false) end end)

-- Sete raios maiores, ramificados e brilhantes; o ciclo visual é de 0,3 s.
local function drawLightningBurst()
    local width, height = LightningLayer.AbsoluteSize.X, LightningLayer.AbsoluteSize.Y
    if width < 80 or height < 80 then return end
    local spawned = {}

    local function addSegment(a, b, color, thickness, transparency, zIndex)
        local delta = b - a
        local segment = Instance.new("Frame")
        segment.AnchorPoint = Vector2.new(0.5, 0.5)
        segment.Size = UDim2.fromOffset(delta.Magnitude, thickness)
        segment.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
        segment.Rotation = math.deg(math.atan2(delta.Y, delta.X))
        segment.BackgroundColor3 = color
        segment.BackgroundTransparency = transparency
        segment.BorderSizePixel = 0
        segment.Active = false
        segment.ZIndex = zIndex
        segment.Parent = LightningLayer
        spawned[#spawned + 1] = segment
    end

    local function addBoltSegment(a, b)
        -- Violet halo plus a narrow lilac core for a brighter, more natural flash.
        addSegment(a, b, Color3.fromRGB(145, 42, 255), 12, 0.68, 4)
        addSegment(a, b, Color3.fromRGB(225, 190, 255), 2.4, 0.48, 5)
    end

    for boltIndex = 1, 7 do
        local x = width * (boltIndex / 8) + rng:NextNumber(-8, 8)
        local y = rng:NextNumber(-height * 0.08, height * 0.08)
        local points = {Vector2.new(x, y)}
        -- Longer jagged trunk (roughly three times the previous height).
        for step = 1, 7 do
            x = math.clamp(x + rng:NextNumber(-48, 48), 4, width - 4)
            y = math.clamp(y + rng:NextNumber(height * 0.105, height * 0.16), 4, height - 4)
            points[#points + 1] = Vector2.new(x, y)
        end
        for i = 1, #points - 1 do
            addBoltSegment(points[i], points[i + 1])
        end

        -- One fork per strike makes the silhouette less repetitive.
        local forkOrigin = points[2]
        local forkKnee = Vector2.new(
            math.clamp(forkOrigin.X + rng:NextNumber(-38, 38), 4, width - 4),
            math.clamp(forkOrigin.Y + rng:NextNumber(height * 0.08, height * 0.12), 4, height - 4)
        )
        local forkTip = Vector2.new(
            math.clamp(forkKnee.X + rng:NextNumber(-62, 62), 4, width - 4),
            math.clamp(forkKnee.Y + rng:NextNumber(height * 0.06, height * 0.10), 4, height - 4)
        )
        addBoltSegment(forkOrigin, forkKnee)
        addBoltSegment(forkKnee, forkTip)
    end

    -- 0,3 s visible, then a quick fade; new bursts begin every 0,3 s.
    task.delay(0.18, function()
        for _, segment in ipairs(spawned) do
            if segment.Parent then
                local fade = TweenService:Create(segment, TweenInfo.new(0.08), {BackgroundTransparency = 1})
                fade:Play()
                fade.Completed:Connect(function()
                    if segment.Parent then segment:Destroy() end
                end)
            end
        end
    end)
end

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.3)
        if Menu.Visible then pcall(drawLightningBurst) end
    end
end)

local camera = Workspace.CurrentCamera
if camera then
    uiConnections[#uiConnections + 1] = camera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeMenu)
end

-- Estado inicial: menu fechado, botão flutuante visível.
Menu.Visible = false

local function disconnectUiConnections()
    for _, connection in ipairs(uiConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(uiConnections)
end

local function cleanupMenu()
    AntiHit.setEnabled(false)
    AntiTrap.setEnabled(false)
    InstaGrab.stop()
    stopEsp()
    removeBillboard()
    disconnectUiConnections()
    if ScreenGui and ScreenGui.Parent then
        pcall(function() ScreenGui:Destroy() end)
    end
end
runtimeEnv.__KassHubMenuCleanup = cleanupMenu
ScreenGui.Destroying:Connect(function()
    AntiHit.setEnabled(false)
    AntiTrap.setEnabled(false)
    InstaGrab.stop()
    stopEsp()
    removeBillboard()
    disconnectUiConnections()
    if runtimeEnv.__KassHubMenuCleanup == cleanupMenu then
        runtimeEnv.__KassHubMenuCleanup = nil
    end
end)