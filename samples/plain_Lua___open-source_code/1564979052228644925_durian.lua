if not game:IsLoaded() then
    game.Loaded:Wait()
end

--==================================================
-- Services & Variables
--==================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Backpack = LocalPlayer:WaitForChild("Backpack")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SellDurians = Remotes:WaitForChild("SellDurians")
local WaterRemote = Remotes:WaitForChild("Water")
local SeedShopRemote = Remotes:WaitForChild("SeedShop")

local DurianWarehouse = workspace:WaitForChild("Map"):WaitForChild("DurianWarehouse")
local SellFruitsNpc = DurianWarehouse:WaitForChild("Flex_Guy"):WaitForChild("RootPart")
local SeedShopNpc = DurianWarehouse:WaitForChild("ShanaKung")

-- Global Configuration & Environment
local _env = getgenv()
_env.Config = _env.Config or {}

if _env.Config.SellFruitAmount == nil then
    _env.Config.SellFruitAmount = 10
end

if _env.Config.SeedsToBuy == nil then
    _env.Config.SeedsToBuy = { "Kradumthong", "Chanee", "Puangmanee" }
end

if _env.Config.FertsToBuy == nil then
    _env.Config.FertsToBuy = { "Basic" }
end

if _env.Config.MinFertKeep == nil then
    _env.Config.MinFertKeep = 1
end

-- สวิตช์เปิด/ปิดโหมดการทำงาน
if _env.AutoSell == nil then _env.AutoSell = true end
if _env.AutoBuySeed == nil then _env.AutoBuySeed = false end
if _env.AutoBuyFert == nil then _env.AutoBuyFert = false end
if _env.AutoWater == nil then _env.AutoWater = true end
if _env.AutoFertilize == nil then _env.AutoFertilize = true end
if _env.AutoHarvest == nil then _env.AutoHarvest = true end
if _env.AutoSteal == nil then _env.AutoSteal = true end
if _env.AutoSaveEnabled == nil then _env.AutoSaveEnabled = true end
if _env.ESPRipe == nil then _env.ESPRipe = false end
if _env.ESPPlayers == nil then _env.ESPPlayers = false end

local DefaultFertPrices = {
    ["Basic"]      = 100,
    ["Super"]      = 500,
    ["Mega"]       = 2500,
    ["TonicBasic"] = 150,
    ["TonicSuper"] = 750,
    ["TonicMega"]  = 3000,
}

--==================================================
-- Auto-Save / Load Settings (JSON)
--==================================================
local SAVE_FOLDER = "DurianElectDriver"
local SAVE_FILE = SAVE_FOLDER .. "/config.json"

local function _buildSaveData()
    return {
        AutoSell = _env.AutoSell,
        AutoBuySeed = _env.AutoBuySeed,
        AutoBuyFert = _env.AutoBuyFert,
        AutoWater = _env.AutoWater,
        AutoFertilize = _env.AutoFertilize,
        AutoHarvest = _env.AutoHarvest,
        AutoSteal = _env.AutoSteal,
        AutoSaveEnabled = _env.AutoSaveEnabled,
        ESPRipe = _env.ESPRipe,
        ESPPlayers = _env.ESPPlayers,
        Config = {
            SellFruitAmount = _env.Config.SellFruitAmount,
            SeedsToBuy = _env.Config.SeedsToBuy,
            FertsToBuy = _env.Config.FertsToBuy,
            MinFertKeep = _env.Config.MinFertKeep,
        },
    }
end

local function saveSettings(silent)
    if not writefile then return false end
    pcall(function()
        if makefolder and isfolder and not isfolder(SAVE_FOLDER) then
            pcall(makefolder, SAVE_FOLDER)
        end
        writefile(SAVE_FILE, HttpService:JSONEncode(_buildSaveData()))
    end)
    return true
end

local function loadSettings()
    if not readfile or not isfile then return false end
    local okExist, exists = pcall(isfile, SAVE_FILE)
    if not okExist or not exists then return false end
    local okRead, content = pcall(readfile, SAVE_FILE)
    if not okRead or not content then return false end
    local okDec, decoded = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if not okDec or type(decoded) ~= "table" then return false end

    if type(decoded.AutoSell) == "boolean" then _env.AutoSell = decoded.AutoSell end
    if type(decoded.AutoBuySeed) == "boolean" then _env.AutoBuySeed = decoded.AutoBuySeed end
    if type(decoded.AutoBuyFert) == "boolean" then _env.AutoBuyFert = decoded.AutoBuyFert end
    if type(decoded.AutoWater) == "boolean" then _env.AutoWater = decoded.AutoWater end
    if type(decoded.AutoFertilize) == "boolean" then _env.AutoFertilize = decoded.AutoFertilize end
    if type(decoded.AutoHarvest) == "boolean" then _env.AutoHarvest = decoded.AutoHarvest end
    if type(decoded.AutoSteal) == "boolean" then _env.AutoSteal = decoded.AutoSteal end
    if type(decoded.AutoSaveEnabled) == "boolean" then _env.AutoSaveEnabled = decoded.AutoSaveEnabled end
    if type(decoded.ESPRipe) == "boolean" then _env.ESPRipe = decoded.ESPRipe end
    if type(decoded.ESPPlayers) == "boolean" then _env.ESPPlayers = decoded.ESPPlayers end

    if type(decoded.Config) == "table" then
        local c = decoded.Config
        if type(c.SellFruitAmount) == "number" then _env.Config.SellFruitAmount = c.SellFruitAmount end
        if type(c.SeedsToBuy) == "table" and #c.SeedsToBuy > 0 then _env.Config.SeedsToBuy = c.SeedsToBuy end
        if type(c.FertsToBuy) == "table" and #c.FertsToBuy > 0 then _env.Config.FertsToBuy = c.FertsToBuy end
        if type(c.MinFertKeep) == "number" then _env.Config.MinFertKeep = c.MinFertKeep end
    end
    return true
end

loadSettings()

local _savePending = false
local function scheduleSave()
    if not _env.AutoSaveEnabled or _savePending then return end
    _savePending = true
    task.delay(0.5, function()
        _savePending = false
        saveSettings(true)
    end)
end

--==================================================
-- Glossy Status Popup UI (Top-Center, Thai)
--==================================================
local UpdateStatusUI
do
    local guiParent = (gethui and gethui()) or CoreGui
    local oldGui = guiParent:FindFirstChild("GlossyDriverHUD")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GlossyDriverHUD"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = guiParent

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainPopup"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0, -60)
    MainFrame.Size = UDim2.new(0, 290, 0, 44)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    MainFrame.BackgroundTransparency = 0.12
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Parent = MainFrame

    local StrokeGrad = Instance.new("UIGradient")
    StrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(165, 95, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 180)),
    })
    StrokeGrad.Parent = Stroke

    local StatusDot = Instance.new("Frame")
    StatusDot.AnchorPoint = Vector2.new(0, 0.5)
    StatusDot.Position = UDim2.new(0, 18, 0.5, 0)
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = MainFrame

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 38, 0, 5)
    TitleLabel.Size = UDim2.new(1, -50, 0, 14)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "สถานะระบบออโต้"
    TitleLabel.TextColor3 = Color3.fromRGB(160, 175, 205)
    TitleLabel.TextSize = 10
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 38, 0, 19)
    StatusLabel.Size = UDim2.new(1, -50, 0, 20)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "กำลังเริ่มต้น..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 14
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainFrame

    TweenService:Create(
        MainFrame,
        TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 16)}
    ):Play()

    task.spawn(function()
        local rot = 0
        while ScreenGui.Parent do
            rot = (rot + 2) % 360
            StrokeGrad.Rotation = rot
            task.wait(0.03)
        end
    end)

    local DriverThemes = {
        steal     = {text = "อีเวนต์ PURGE: กำลังขโมยผลไม้", color = Color3.fromRGB(255, 65, 65)},
        sell      = {text = "กำลังขายทุเรียน",             color = Color3.fromRGB(255, 200, 50)},
        buy_seed  = {text = "กำลังซื้อเมล็ดพันธุ์",         color = Color3.fromRGB(190, 110, 255)},
        buy_fert  = {text = "กำลังซื้อปุ๋ย",               color = Color3.fromRGB(255, 110, 195)},
        water     = {text = "กำลังรดน้ำต้นไม้",            color = Color3.fromRGB(50, 195, 255)},
        fertilize = {text = "กำลังใส่ปุ๋ย",               color = Color3.fromRGB(110, 255, 120)},
        harvest   = {text = "กำลังเก็บเกี่ยวผลไม้ที่สุก",   color = Color3.fromRGB(255, 135, 55)},
        idle      = {text = "รอจังหวะ / สแตนด์บาย",       color = Color3.fromRGB(145, 155, 175)},
    }

    UpdateStatusUI = function(driverKey, detailText)
        local theme = DriverThemes[driverKey or "idle"] or DriverThemes.idle
        local finalText = detailText and (theme.text .. " (" .. detailText .. ")") or theme.text
        StatusLabel.Text = finalText
        TweenService:Create(StatusDot, TweenInfo.new(0.25), {BackgroundColor3 = theme.color}):Play()
    end
end

--==================================================
-- Base & Helper Functions
--==================================================
local function PressKeyE(holdTime)
    holdTime = holdTime or 0.2
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function LoadPlayerBase()
    local map = workspace:FindFirstChild("Map")
    local Bases = map and map:FindFirstChild("Bases")
    if not Bases then return end

    for _, Base in ipairs(Bases:GetChildren()) do
        local ownerAttr = Base:GetAttribute("OwnerName") or Base:GetAttribute("Owner")
        local ownerVal = Base:FindFirstChild("Owner") or Base:FindFirstChild("OwnerName")
        local valStr = ownerVal and (ownerVal.Value or "") or ""

        if ownerAttr == LocalPlayer.DisplayName or ownerAttr == LocalPlayer.Name or ownerAttr == LocalPlayer.UserId or
           valStr == LocalPlayer.DisplayName or valStr == LocalPlayer.Name or valStr == LocalPlayer.UserId or
           Base.Name:lower():find(LocalPlayer.Name:lower()) then
            _env.Config.LocalPlayerBase = Base
            _env.LoadedData = true
            return
        end
    end

    if #Bases:GetChildren() > 0 and not _env.Config.LocalPlayerBase then
        _env.Config.LocalPlayerBase = Bases:GetChildren()[1]
        _env.LoadedData = true
    end
end

LoadPlayerBase()

local function _wait(seconds)
    seconds = seconds or 0.1
    local start = os.clock()
    repeat task.wait() until os.clock() >= start + seconds
    return true
end

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Backpack = LocalPlayer:WaitForChild("Backpack")
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function GetTool(name)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if bp and bp:FindFirstChild(name) then return bp:FindFirstChild(name) end
    if char and char:FindFirstChild(name) then return char:FindFirstChild(name) end
    return nil
end

local function ForceEquipTool(tool, timeout)
    timeout = timeout or 2.5
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not tool or not char or not hum then return false end
    if tool.Parent == char then return true end

    local start = os.clock()
    repeat
        if not tool or not tool.Parent then return false end
        hum:EquipTool(tool)
        task.wait(0.15)
        if tool.Parent ~= char then pcall(function() tool.Parent = char end) end
    until tool.Parent == char or (os.clock() - start >= timeout)
    return tool.Parent == char
end

local function GetAllSlots()
    local slots = {}
    local Base = _env.Config.LocalPlayerBase
    if not Base then return slots end
    local Items = Base:FindFirstChild("Items")
    if not Items then return slots end

    for _, item in ipairs(Items:GetChildren()) do
        if item.Name:match("^FarmPlot") and item:FindFirstChild("Slots") then
            for _, slot in ipairs(item.Slots:GetChildren()) do
                table.insert(slots, slot)
            end
        end
    end
    return slots
end

local function GetPlayerCash()
    if _env.LatestSeedData and type(_env.LatestSeedData.Cash) == "number" then
        return _env.LatestSeedData.Cash
    end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local cashObj = ls:FindFirstChild("Cash") or ls:FindFirstChild("Money") or ls:FindFirstChild("Coins")
        if cashObj and tonumber(cashObj.Value) then return tonumber(cashObj.Value) end
    end
    return math.huge
end

--==================================================
-- Shop & Fertilizer Helpers
--==================================================
local function GetAllFertilizers()
    local ferts = {}
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("FertId") ~= nil then table.insert(ferts, item) end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("FertId") ~= nil then table.insert(ferts, item) end
        end
    end
    return ferts
end

local function GetFertilizerTool() return GetAllFertilizers()[1] end
local function GetFertilizerCount() return #GetAllFertilizers() end

_env.LatestSeedData = _env.LatestSeedData or nil
local lastShopRefresh = 0

if not _env.SeedShopListenerConnected then
    _env.SeedShopListenerConnected = true
    SeedShopRemote.OnClientEvent:Connect(function(...)
        local args = {...}
        local action, data = args[1], args[2]
        if (action == "Open" or action == "Update") and data then
            _env.LatestSeedData = data
        end
    end)
end
SeedShopRemote:FireServer("Refresh")

local function IsWantedSeed(seedName)
    for _, wanted in ipairs(_env.Config.SeedsToBuy or {}) do
        if tostring(wanted):lower() == tostring(seedName):lower() then return true end
    end
    return false
end

local function GetBuyableSeedItem()
    local data = _env.LatestSeedData
    if not data or not data.Items then return nil end
    local currentCash = GetPlayerCash()
    for _, item in ipairs(data.Items) do
        if IsWantedSeed(item.Name) and (item.Stock or 0) > 0 and currentCash >= (item.Price or 0) then
            return item
        end
    end
    return nil
end

local function GetFertPrice(fertName)
    local data = _env.LatestSeedData
    if data and type(data.Fertilizers or data.Ferts or data.Items) == "table" then
        for _, item in ipairs(data.Fertilizers or data.Ferts or data.Items) do
            if type(item) == "table" and (item.Name == fertName or item.Id == fertName) then
                if type(item.Price) == "number" then return item.Price end
            end
        end
    end
    return DefaultFertPrices[fertName] or 100
end

local function GetAffordableWantedFert()
    for _, fertName in ipairs(_env.Config.FertsToBuy or { "Basic" }) do
        local price = GetFertPrice(fertName)
        if GetPlayerCash() >= price then return fertName, price end
    end
    return nil, 0
end

local function BuySeedStatus()
    if not _env.AutoBuySeed then return nil end
    if not _env.LatestSeedData and os.clock() - lastShopRefresh > 5 then
        lastShopRefresh = os.clock()
        SeedShopRemote:FireServer("Refresh")
    end
    if GetBuyableSeedItem() ~= nil then return "ready" end
    return nil
end

local function BuySeedTick()
    if not SeedShopNpc then return end
    Character:PivotTo(SeedShopNpc:GetPivot() * CFrame.new(0, 2, 4))
    task.wait(0.4)
    local targetItem = GetBuyableSeedItem()
    if not targetItem then return end
    UpdateStatusUI("buy_seed", targetItem.Name .. " x" .. tostring(targetItem.Stock))
    for _ = 1, (targetItem.Stock or 1) do
        if not _env.AutoBuySeed or GetPlayerCash() < (targetItem.Price or 0) then break end
        SeedShopRemote:FireServer("Buy", targetItem.Name)
        task.wait(0.25)
    end
    SeedShopRemote:FireServer("Refresh")
end

local function BuyFertStatus()
    if not _env.AutoBuyFert then return nil end
    if GetFertilizerCount() < (_env.Config.MinFertKeep or 1) and GetAffordableWantedFert() ~= nil then
        return "ready"
    end
    return nil
end

local function BuyFertTick()
    if not SeedShopNpc then return end
    Character:PivotTo(SeedShopNpc:GetPivot() * CFrame.new(0, 2, 4))
    task.wait(0.4)
    for _, fertName in ipairs(_env.Config.FertsToBuy or { "Basic" }) do
        if not _env.AutoBuyFert then break end
        local price = GetFertPrice(fertName)
        if GetPlayerCash() >= price then
            UpdateStatusUI("buy_fert", fertName)
            SeedShopRemote:FireServer("BuyFert", fertName)
            task.wait(0.35)
        end
    end
    SeedShopRemote:FireServer("Refresh")
end

--==================================================
-- Sell Fruits
--==================================================
local function GetAllFruits()
    local fruits = {}
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("FruitId") then table.insert(fruits, item) end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("FruitId") then table.insert(fruits, item) end
        end
    end
    return fruits
end

local function SellStatus()
    if _env.AutoSell and #GetAllFruits() >= (_env.Config.SellFruitAmount or 10) then return "ready" end
    return nil
end

local function SellFruitsTick()
    Character:PivotTo(SellFruitsNpc:GetPivot() * CFrame.new(0, 2, 5))
    task.wait(1)
    SellDurians:FireServer("All")
end

--==================================================
-- Watering & Fertilizing
--==================================================
local function IsSlotThirsty(slot)
    local plantSpot = slot:FindFirstChild("PlantSpot")
    if plantSpot and plantSpot:FindFirstChild("ThirstSign") then
        local sign = plantSpot.ThirstSign
        if sign:IsA("BillboardGui") or sign:IsA("SurfaceGui") then return sign.Enabled end
        return true
    end
    return false
end

local function GetThirstySlots()
    local list = {}
    for _, slot in ipairs(GetAllSlots()) do
        if IsSlotThirsty(slot) then table.insert(list, slot) end
    end
    return list
end

local function EnsureWateringCanFilled(itemsFolder)
    local Well = itemsFolder:FindFirstChild("Well")
    if not Well or not Well:FindFirstChild("PromptPart") then return false end
    local Prompt = Well.PromptPart:FindFirstChild("FillPrompt")
    local WateringCan = GetTool("Watering Can")
    if not WateringCan then return false end
    ForceEquipTool(WateringCan, 2)
    if (WateringCan:GetAttribute("Uses") or 0) <= 0 then
        Character:PivotTo(Well:GetPivot() * CFrame.new(0, 5, 5))
        task.wait(0.25)
        if Prompt then fireproximityprompt(Prompt) end
        task.wait(0.5)
    end
    return true
end

local function WaterStatus()
    if not _env.AutoWater or not GetTool("Watering Can") then return nil end
    if #GetThirstySlots() > 0 then return "ready" end
    return nil
end

local function WateringTick()
    local Base = _env.Config.LocalPlayerBase
    local Items = Base and Base:FindFirstChild("Items")
    if not Items then return end
    for _, slot in ipairs(GetThirstySlots()) do
        if EnsureWateringCanFilled(Items) then
            local plantSpot = slot:FindFirstChild("PlantSpot")
            if plantSpot then
                Character:PivotTo(CFrame.new(plantSpot:GetPivot().Position) + Vector3.new(0, 3, 3))
                task.wait(0.3)
                pcall(function() WaterRemote:FireServer("Water", plantSpot:GetPivot().Position) end)
                task.wait(0.5)
            end
        end
    end
end

local function DoesSlotNeedFertilizer(slot)
    local plantSpot = slot:FindFirstChild("PlantSpot")
    local tonicSign = plantSpot and plantSpot:FindFirstChild("TonicSign")
    if not tonicSign then return false end
    local textLabel = tonicSign:FindFirstChild("TextLabel") or tonicSign:FindFirstChildWhichIsA("TextLabel", true)
    if textLabel and textLabel.Text:upper():find("NEEDS FERTILIZER") then return true end
    return false
end

local function GetFertilizerSlots()
    local list = {}
    for _, slot in ipairs(GetAllSlots()) do
        if DoesSlotNeedFertilizer(slot) then table.insert(list, slot) end
    end
    return list
end

local function FertilizeStatus()
    if not _env.AutoFertilize then return nil end
    if #GetFertilizerSlots() > 0 then
        if GetFertilizerTool() ~= nil then return "ready"
        elseif _env.AutoBuyFert then return "need_buy" end
    end
    return nil
end

local function FertilizeTick()
    local fertTool = GetFertilizerTool()
    if not fertTool then return end
    for _, slot in ipairs(GetFertilizerSlots()) do
        ForceEquipTool(fertTool, 2)
        local plantSpot = slot:FindFirstChild("PlantSpot")
        if plantSpot then
            Character:PivotTo(CFrame.new(plantSpot:GetPivot().Position) + Vector3.new(0, 2, 3))
            task.wait(0.35)
            PressKeyE(0.3)
        end
    end
end

--==================================================
-- Harvest & Purge Steal
--==================================================
local function IsFruitRipe(prompt)
    local parent = prompt.Parent
    local grow = parent and parent:FindFirstChild("Grow")
    local pct = grow and grow:FindFirstChild("Pct")
    if not pct then return false end
    local text = pct.Text or ""
    if text == "" or text:find("%%") or text:lower():find("growing") then return false end
    return true
end

local function FindHarvestPrompt()
    for _, slot in ipairs(GetAllSlots()) do
        local fruitsFolder = slot:FindFirstChild("Fruits")
        if fruitsFolder then
            for _, desc in ipairs(fruitsFolder:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and desc.Name == "Harvest" and desc.Enabled and IsFruitRipe(desc) then
                    return desc
                end
            end
        end
    end
    return nil
end

local function HarvestStatus()
    if not _env.AutoHarvest then return nil end
    if FindHarvestPrompt() ~= nil then return "ready" end
    return nil
end

local function HarvestTick()
    local prompt = FindHarvestPrompt()
    if not prompt then return end
    local parentPart = prompt.Parent
    if parentPart and parentPart:IsA("BasePart") then
        Character:PivotTo(parentPart.CFrame + Vector3.new(0, 3, 3))
        task.wait(0.4)
        PressKeyE(0.3)
    end
end

local function IsPurgeEventActive()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local dayNight = playerGui and playerGui:FindFirstChild("DayNightGui")
    local caption = dayNight and dayNight:FindFirstChild("Clock") and dayNight.Clock:FindFirstChild("Caption")
    if caption and caption.Text:upper():find("PURGE ENDS IN") then return true end
    return false
end

local function FindBiggestStealableFruitPrompt()
    local Bases = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Bases")
    if not Bases then return nil end
    local myBase = _env.Config.LocalPlayerBase
    local bestPrompt = nil
    local maxVolume = -1

    for _, base in ipairs(Bases:GetChildren()) do
        if base ~= myBase then
            local items = base:FindFirstChild("Items")
            if items then
                for _, item in ipairs(items:GetChildren()) do
                    if item.Name:match("^FarmPlot") and item:FindFirstChild("Slots") then
                        for _, slot in ipairs(item.Slots:GetChildren()) do
                            local fruitsFolder = slot:FindFirstChild("Fruits")
                            if fruitsFolder then
                                for _, desc in ipairs(fruitsFolder:GetDescendants()) do
                                    if desc:IsA("ProximityPrompt") and desc.Enabled and IsFruitRipe(desc) then
                                        local vol = desc.Parent:IsA("BasePart") and desc.Parent.Size.Magnitude or 1
                                        if vol > maxVolume then
                                            maxVolume = vol
                                            bestPrompt = desc
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPrompt
end

local function StealStatus()
    if not _env.AutoSteal or not IsPurgeEventActive() then return nil end
    if FindBiggestStealableFruitPrompt() ~= nil then return "ready" end
    return nil
end

local function StealTick()
    local prompt = FindBiggestStealableFruitPrompt()
    if not prompt or not prompt.Parent then return end
    Character:PivotTo(prompt.Parent.CFrame + Vector3.new(0, 3, 3))
    task.wait(0.4)
    PressKeyE(0.3)
end

--==================================================
-- ElectDriver Loop
--==================================================
local function ElectDriver()
    if SellStatus() == "ready" then return "sell" end
    if StealStatus() == "ready" then return "steal" end
    if BuySeedStatus() == "ready" then return "buy_seed" end
    local fertState = FertilizeStatus()
    if fertState == "need_buy" or BuyFertStatus() == "ready" then return "buy_fert" end
    if WaterStatus() == "ready" then return "water" end
    if fertState == "ready" then return "fertilize" end
    if HarvestStatus() == "ready" then return "harvest" end
    return nil
end

local DriverTick = {
    steal     = StealTick,
    sell      = SellFruitsTick,
    buy_seed  = BuySeedTick,
    buy_fert  = BuyFertTick,
    water     = WateringTick,
    fertilize = FertilizeTick,
    harvest   = HarvestTick,
}

--==================================================
-- ESP Systems Loop
--==================================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local Bases = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Bases")
            if Bases then
                for _, base in ipairs(Bases:GetChildren()) do
                    local items = base:FindFirstChild("Items")
                    if items then
                        for _, item in ipairs(items:GetChildren()) do
                            if item.Name:match("^FarmPlot") and item:FindFirstChild("Slots") then
                                for _, slot in ipairs(item.Slots:GetChildren()) do
                                    local fruitsFolder = slot:FindFirstChild("Fruits")
                                    if fruitsFolder then
                                        for _, desc in ipairs(fruitsFolder:GetDescendants()) do
                                            if desc:IsA("ProximityPrompt") and desc.Name == "Harvest" and IsFruitRipe(desc) then
                                                local targetObj = desc.Parent
                                                if targetObj and _env.ESPRipe and not targetObj:FindFirstChild("RipeHighlight") then
                                                    local hl = Instance.new("Highlight")
                                                    hl.Name = "RipeHighlight"
                                                    hl.Adornee = targetObj
                                                    hl.FillColor = Color3.fromRGB(0, 255, 100)
                                                    hl.Parent = targetObj
                                                elseif targetObj and not _env.ESPRipe and targetObj:FindFirstChild("RipeHighlight") then
                                                    targetObj.RipeHighlight:Destroy()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if _env.ESPPlayers and not plr.Character:FindFirstChild("PlayerHighlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "PlayerHighlight"
                        hl.Adornee = plr.Character
                        hl.FillColor = Color3.fromRGB(255, 50, 50)
                        hl.Parent = plr.Character
                    elseif not _env.ESPPlayers and plr.Character:FindFirstChild("PlayerHighlight") then
                        plr.Character.PlayerHighlight:Destroy()
                    end
                end
            end
        end)
    end
end)

--==================================================
-- WindUI Menu Integration (Thai Language)
--==================================================
do
    local success, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)

    if success and WindUI then
        local Window = WindUI:CreateWindow({
            Title = "ฟาร์มทุเรียน 🍈",
            Icon = "sprout",
            Author = "Bytlena",
            Folder = "DurianFarm",
            Size = UDim2.fromOffset(560, 420),
            Transparent = true,
            Theme = "Dark",
            SideBarWidth = 175,
        })

        pcall(function()
            Window:EditOpenButton({
                Title = "เปิดเมนูฟาร์ม",
                Icon = "sprout",
                CornerRadius = UDim.new(1, 0),
                StrokeThickness = 2,
                Color = ColorSequence.new(Color3.fromRGB(0, 235, 255), Color3.fromRGB(165, 95, 255)),
                Draggable = true,
            })
        end)

        -- TAB 1: ออโต้ฟาร์ม
        local FarmTab = Window:Tab({ Title = "ออโต้ฟาร์ม", Icon = "tractor" })
        FarmTab:Select()

        FarmTab:Toggle({
            Title = "เก็บเกี่ยวผลไม้สุกออโต้",
            Desc = "วาร์ปและเก็บทุเรียนที่สุกแล้วโดยอัตโนมัติ",
            Value = _env.AutoHarvest,
            Callback = function(state)
                _env.AutoHarvest = state
                scheduleSave()
            end
        })

        FarmTab:Toggle({
            Title = "ขโมยออโต้ (ช่วงอีเวนต์ PURGE)",
            Desc = "ขโมยผลไม้จากฐานคนอื่นในช่วงอีเวนต์",
            Value = _env.AutoSteal,
            Callback = function(state)
                _env.AutoSteal = state
                scheduleSave()
            end
        })

        FarmTab:Toggle({
            Title = "รดน้ำต้นไม้ออโต้",
            Desc = "รดน้ำต้นไม้อัตโนมัติเมื่อกระหายน้ำ",
            Value = _env.AutoWater,
            Callback = function(state)
                _env.AutoWater = state
                scheduleSave()
            end
        })

        FarmTab:Toggle({
            Title = "ใส่ปุ๋ยออโต้",
            Desc = "ใส่ปุ๋ยอัตโนมัติเมื่อต้นไม้ต้องการ",
            Value = _env.AutoFertilize,
            Callback = function(state)
                _env.AutoFertilize = state
                scheduleSave()
            end
        })

        FarmTab:Toggle({
            Title = "ขายผลไม้ออโต้",
            Desc = "ขายทุเรียนทั้งหมดอัตโนมัติเมื่อถึงเป้าหมาย",
            Value = _env.AutoSell,
            Callback = function(state)
                _env.AutoSell = state
                scheduleSave()
            end
        })

        FarmTab:Slider({
            Title = "จำนวนผลไม้ก่อนขาย",
            Desc = "จำนวนขั้นต่ำในกระเป๋าก่อนนำไปขาย",
            Step = 1,
            Value = { Min = 1, Max = 50, Default = _env.Config.SellFruitAmount or 10 },
            Callback = function(val)
                _env.Config.SellFruitAmount = tonumber(val) or 10
                scheduleSave()
            end
        })

        -- TAB 2: ร้านค้าเมล็ดและปุ๋ย
        local ShopTab = Window:Tab({ Title = "ร้านค้าเมล็ดและปุ๋ย", Icon = "shopping-cart" })

        ShopTab:Toggle({
            Title = "ซื้อเมล็ดพันธุ์ออโต้",
            Desc = "ซื้อเมล็ดพันธุ์ที่เลือกไว้เมื่อมีในสต็อก",
            Value = _env.AutoBuySeed,
            Callback = function(state)
                _env.AutoBuySeed = state
                scheduleSave()
            end
        })

        ShopTab:Dropdown({
            Title = "เลือกเมล็ดพันธุ์",
            Values = { "Kradumthong", "Chanee", "Puangmanee", "Kanyao", "Nokyip", "Monthong" },
            Value = _env.Config.SeedsToBuy,
            Multi = true,
            Callback = function(selected)
                _env.Config.SeedsToBuy = selected
                scheduleSave()
            end
        })

        ShopTab:Toggle({
            Title = "ซื้อปุ๋ยออโต้",
            Desc = "ซื้อปุ๋ยอัตโนมัติเมื่อปุ๋ยในตัวหมด",
            Value = _env.AutoBuyFert,
            Callback = function(state)
                _env.AutoBuyFert = state
                scheduleSave()
            end
        })

        -- TAB 3: วาร์ปและ ESP
        local TeleportTab = Window:Tab({ Title = "วาร์ปและ ESP", Icon = "map-pin" })

        TeleportTab:Button({
            Title = "วาร์ปไปร้านขายเมล็ดพันธุ์",
            Desc = "วาร์ปไปหา NPC ShanaKung",
            Callback = function()
                if SeedShopNpc and Character and Character:FindFirstChild("HumanoidRootPart") then
                    Character:PivotTo(SeedShopNpc:GetPivot() * CFrame.new(0, 3, 5))
                end
            end
        })

        TeleportTab:Button({
            Title = "วาร์ปไปจุดขายผลไม้",
            Desc = "วาร์ปไปที่โกดังของ Flex_Guy",
            Callback = function()
                if SellFruitsNpc and Character and Character:FindFirstChild("HumanoidRootPart") then
                    Character:PivotTo(SellFruitsNpc.CFrame + Vector3.new(0, 3, 5))
                end
            end
        })

        TeleportTab:Toggle({
            Title = "ESP ทุเรียนที่สุกแล้ว",
            Desc = "ไฮไลท์ผลไม้ที่พร้อมเก็บด้วยแสงสีเขียว",
            Value = _env.ESPRipe,
            Callback = function(state)
                _env.ESPRipe = state
                scheduleSave()
            end
        })

        TeleportTab:Toggle({
            Title = "ESP ผู้เล่นอื่น",
            Desc = "ไฮไลท์ผู้เล่นอื่นด้วยแสงสีแดง",
            Value = _env.ESPPlayers,
            Callback = function(state)
                _env.ESPPlayers = state
                scheduleSave()
            end
        })

        -- TAB 4: ช่องทางข่าวสาร
        local NewsTab = Window:Tab({ Title = "ช่องทางข่าวสาร", Icon = "message-square" })

        NewsTab:Paragraph({
            Title = "Discord Community",
            Desc = "เข้าร่วมดิสคอร์ดของเราเพื่อติดตามข่าวสาร อัปเดตสคริปต์ใหม่ๆ หรือพูดคุยสอบถามปัญหา",
        })

        NewsTab:Button({
            Title = "คัดลอกลิงก์ Discord",
            Desc = "กดเพื่อคัดลอกลิงก์เชิญเข้าดิสคอร์ด",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/yzgsk26AZ")
                    print("คัดลอกลิงก์ Discord เรียบร้อยแล้ว!")
                else
                    warn("ตัวรันของคุณไม่รองรับคำสั่ง setclipboard ลิงก์: https://discord.gg/yzgsk26AZ")
                end
            end
        })
    end
end

--==================================================
-- Main Loop
--==================================================
if not _env.LoadedFarmFunc then
    _env.LoadedFarmFunc = true
    task.spawn(function()
        while _wait(0.2) do
            if not _env.LoadedData then
                UpdateStatusUI("idle", "กำลังโหลดข้อมูลฐาน...")
                LoadPlayerBase()
            else
                local driver = ElectDriver()
                if driver ~= _env._lastDriver then
                    _env._lastDriver = driver
                    UpdateStatusUI(driver)
                end
                if driver and DriverTick[driver] then
                    pcall(DriverTick[driver])
                end
            end
        end
    end)
end