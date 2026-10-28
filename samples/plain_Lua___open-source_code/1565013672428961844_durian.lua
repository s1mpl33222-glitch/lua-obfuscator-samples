if not game:IsLoaded() then
    game.Loaded:Wait()
end

--==================================================
-- Services & Variables
--==================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local cam = workspace.CurrentCamera

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

if _env.Config.SellFruitAmount == nil then _env.Config.SellFruitAmount = 10 end
if _env.Config.SeedsToBuy == nil then _env.Config.SeedsToBuy = { "Kradumthong", "Chanee", "Puangmanee" } end
if _env.Config.FertsToBuy == nil then _env.Config.FertsToBuy = { "Basic" } end
if _env.Config.MinFertKeep == nil then _env.Config.MinFertKeep = 1 end

-- Extended State from Message 3
_env.AutoSell = _env.AutoSell or true
_env.AutoBuySeed = _env.AutoBuySeed or false
_env.AutoBuyFert = _env.AutoBuyFert or false
_env.AutoWater = _env.AutoWater or true
_env.AutoFertilize = _env.AutoFertilize or true
_env.AutoHarvest = _env.AutoHarvest or true
_env.AutoSteal = _env.AutoSteal or true
_env.AutoSaveEnabled = _env.AutoSaveEnabled or true
_env.ESPRipe = _env.ESPRipe or false
_env.ESPPlayers = _env.ESPPlayers or false

_env.Mahira = {
    ESP = { Enabled = false, Name = true, Dist = true, Health = true, Highlight = true, Max = 1500 },
    Player = { Speed = 0, InfJump = false, Noclip = false },
    Farm = {
        Harvest = false, Water = false, Plant = false, Sell = false, Interact = false,
        Speed = 10, SellAt = 100, Seed = "ทุกชนิด", Filter = "", HFruit = "ทุกชนิด", HMut = "ทั้งหมด", HBest = false,
    },
    Shop = { Buy = false, Pick = "ทุกชนิด", Fert = "Basic", FertQty = 1, FertAuto = false },
    Rubber = { Plant = false, Tap = false, Acid = false, Sell = false, Buy = false, AutoGame = true, Delay = 0.4, SellEvery = 45, SaplingQty = 4, Plot = "FarmPlot" },
    Garage = { Auto = false, Pick = "" },
    Gardener = { Log = false },
    AntiAFK = true,
}

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
        steal     = {text = "กำลังขโมยผลไม้ตอนกลางคืน", color = Color3.fromRGB(255, 65, 65)},
        sell      = {text = "กำลังขายทุเรียน",             color = Color3.fromRGB(255, 200, 50)},
        buy_seed  = {text = "กำลังซื้อเมล็ดพันธุ์",         color = Color3.fromRGB(190, 110, 255)},
        buy_fert  = {text = "กำลังซื้อปุ๋ย",               color = Color3.fromRGB(255, 110, 195)},
        water     = {text = "กำลังรดน้ำต้นไม้",            color = Color3.fromRGB(50, 195, 255)},
        fertilize = {text = "กำลังใส่ปุ๋ย",               color = Color3.fromRGB(110, 255, 120)},
        harvest   = {text = "กำลังเก็บเกี่ยวผลไม้ที่สุก",   color = Color3.fromRGB(255, 135, 55)},
        drive     = {text = "กำลังขับรถไปจุดหมาย",        color = Color3.fromRGB(0, 235, 255)},
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
-- Robust Prompt Interactor & Helpers
--==================================================
local function PressKeyE(holdTime)
    holdTime = holdTime or 0.2
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function ForceTriggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.MaxActivationDistance = 50
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        prompt.Enabled = true
    end)

    if fireproximityprompt then
        pcall(fireproximityprompt, prompt)
    end
    
    pcall(function()
        if prompt.InputHoldBegan then prompt:InputHoldBegan() end
        task.wait(0.05)
        if prompt.InputHoldEnded then prompt:InputHoldEnded() end
    end)

    PressKeyE(0.15)
end

--==================================================
-- [ใหม่] วิ่งไปยังตำแหน่ง (แทนการวาร์ป)
--==================================================
local function WalkTo(pos, stopDist, timeout)
    stopDist = stopDist or 5
    timeout = timeout or 12

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and root) or hum.Health <= 0 then return false end

    -- ลงจากรถก่อนถ้านั่งอยู่
    if hum.SeatPart then
        hum.Sit = false
        task.wait(0.15)
    end

    local startTime = os.clock()
    local lastPos = root.Position
    local lastCheck = os.clock()

    while os.clock() - startTime < timeout do
        if not _env.AutoHarvest then return false end

        char = LocalPlayer.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        root = char and char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) or hum.Health <= 0 then return false end

        local dist = (root.Position - pos).Magnitude
        local flat = Vector3.new(pos.X - root.Position.X, 0, pos.Z - root.Position.Z).Magnitude
        if dist <= stopDist or flat <= 3 then
            hum:MoveTo(root.Position) -- หยุดเดิน
            return true
        end

        hum:MoveTo(pos)

        -- ตรวจว่าติดสิ่งกีดขวางไหม ถ้าไม่ขยับให้กระโดด
        if os.clock() - lastCheck >= 0.6 then
            if (root.Position - lastPos).Magnitude < 1 then
                hum.Jump = true
            end
            lastPos = root.Position
            lastCheck = os.clock()
        end

        task.wait(0.1)
    end

    return false
end

local function LoadPlayerBase()
    local map = workspace:FindFirstChild("Map")
    local Bases = map and map:FindFirstChild("Bases")
    if not Bases then return end

    for _, Base in ipairs(Bases:GetChildren()) do
        if Base:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            _env.Config.LocalPlayerBase = Base
            _env.LoadedData = true
            return
        end
    end

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
_env.LoadedData = true

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
    if not Base then 
        LoadPlayerBase()
        Base = _env.Config.LocalPlayerBase
    end
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

local function GetFruitPercent(prompt)
    local parent = prompt.Parent
    local grow = parent and parent:FindFirstChild("Grow")
    local pct = grow and grow:FindFirstChild("Pct")
    if not pct then return 100 end
    local text = pct.Text or ""
    if text == "" or text:lower():find("ripe") or text:lower():find("ready") then return 100 end
    local num = tonumber(text:match("(%d+)%%"))
    if num then return num end
    return 0
end

local function IsFruitRipe(prompt)
    local pctVal = GetFruitPercent(prompt)
    return pctVal >= 100
end

local function IsNightTime()
    local clockTime = Lighting.ClockTime
    return clockTime >= 18 or clockTime < 6
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

--==================================================
-- Independent Background Auto Tasks (Concurrent)
--==================================================

-- 1. Auto Harvest Task (วิ่งไปเก็บ แทนวาร์ป)
task.spawn(function()
    while task.wait(0.3) do
        if _env.AutoHarvest then
            pcall(function()
                for _, slot in ipairs(GetAllSlots()) do
                    if not _env.AutoHarvest then break end
                    local fruitsFolder = slot:FindFirstChild("Fruits")
                    if fruitsFolder then
                        for _, desc in ipairs(fruitsFolder:GetDescendants()) do
                            if not _env.AutoHarvest then break end
                            if desc:IsA("ProximityPrompt") and desc.Name == "Harvest" and desc.Enabled and IsFruitRipe(desc) then
                                local parentPart = desc.Parent
                                if parentPart and parentPart:IsA("BasePart") then
                                    UpdateStatusUI("harvest", "กำลังวิ่งไปเก็บทุเรียนสุก")

                                    -- วิ่งไปใกล้ผลไม้ (ระยะ 6 studs) แทนการ PivotTo
                                    local arrived = WalkTo(parentPart.Position, 6, 12)

                                    if arrived and desc.Parent and desc.Enabled then
                                        UpdateStatusUI("harvest", "กำลังเก็บทุเรียนสุก")
                                        local harvestStart = os.clock()
                                        repeat
                                            ForceTriggerPrompt(desc)
                                            task.wait(0.2)
                                        until not desc or not desc.Enabled or not desc.Parent or (os.clock() - harvestStart > 2.5)
                                        task.wait(0.15)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 2. Auto Water Task
local function IsSlotThirsty(slot)
    local plantSpot = slot:FindFirstChild("PlantSpot")
    if plantSpot and plantSpot:FindFirstChild("ThirstSign") then
        local sign = plantSpot.ThirstSign
        if sign:IsA("BillboardGui") or sign:IsA("SurfaceGui") then return sign.Enabled end
        return true
    end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if _env.AutoWater then
            pcall(function()
                local thirstySlots = {}
                for _, slot in ipairs(GetAllSlots()) do
                    if IsSlotThirsty(slot) then table.insert(thirstySlots, slot) end
                end

                if #thirstySlots > 0 then
                    local Base = _env.Config.LocalPlayerBase
                    local Items = Base and Base:FindFirstChild("Items")
                    if Items then
                        local Well = Items:FindFirstChild("Well")
                        local WateringCan = GetTool("Watering Can")
                        if Well and Well:FindFirstChild("PromptPart") and WateringCan then
                            ForceEquipTool(WateringCan, 2)
                            if (WateringCan:GetAttribute("Uses") or 0) <= 0 then
                                Character:PivotTo(Well:GetPivot() * CFrame.new(0, 4, 3))
                                task.wait(0.3)
                                local prompt = Well.PromptPart:FindFirstChild("FillPrompt")
                                if prompt then ForceTriggerPrompt(prompt) end
                                task.wait(0.6)
                            end

                            for _, slot in ipairs(thirstySlots) do
                                if not _env.AutoWater then break end
                                local plantSpot = slot:FindFirstChild("PlantSpot")
                                if plantSpot then
                                    UpdateStatusUI("water", "กำลังรดน้ำต้นไม้")
                                    Character:PivotTo(CFrame.new(plantSpot:GetPivot().Position) + Vector3.new(0, 2, 2))
                                    task.wait(0.3)
                                    WaterRemote:FireServer("Water", plantSpot:GetPivot().Position)
                                    task.wait(0.4)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. Auto Fertilize Task
local function DoesSlotNeedFertilizer(slot)
    local plantSpot = slot:FindFirstChild("PlantSpot")
    local tonicSign = plantSpot and plantSpot:FindFirstChild("TonicSign")
    if not tonicSign then return false end
    local textLabel = tonicSign:FindFirstChild("TextLabel") or tonicSign:FindFirstChildWhichIsA("TextLabel", true)
    if textLabel and textLabel.Text:upper():find("NEEDS FERTILIZER") then return true end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if _env.AutoFertilize then
            pcall(function()
                local fertSlots = {}
                for _, slot in ipairs(GetAllSlots()) do
                    if DoesSlotNeedFertilizer(slot) then table.insert(fertSlots, slot) end
                end

                if #fertSlots > 0 then
                    local fertTool = GetFertilizerTool()
                    if fertTool then
                        for _, slot in ipairs(fertSlots) do
                            if not _env.AutoFertilize then break end
                            ForceEquipTool(fertTool, 2)
                            local plantSpot = slot:FindFirstChild("PlantSpot")
                            if plantSpot then
                                UpdateStatusUI("fertilize", "กำลังใส่ปุ๋ย")
                                Character:PivotTo(CFrame.new(plantSpot:GetPivot().Position) + Vector3.new(0, 2, 2))
                                task.wait(0.3)
                                PressKeyE(0.3)
                                task.wait(0.4)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 4. Auto Sell Task
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

task.spawn(function()
    while task.wait(1) do
        if _env.AutoSell then
            pcall(function()
                if #GetAllFruits() >= (_env.Config.SellFruitAmount or 10) then
                    if SellFruitsNpc and Character and Character:FindFirstChild("HumanoidRootPart") then
                        UpdateStatusUI("sell", "กำลังขายทุเรียน")
                        Character:PivotTo(SellFruitsNpc:GetPivot() * CFrame.new(0, 2, 4))
                        task.wait(0.8)
                        SellDurians:FireServer("All")
                        task.wait(1)
                    end
                end
            end)
        end
    end
end)

-- 5. Auto Steal Task
task.spawn(function()
    while task.wait(1) do
        if _env.AutoSteal and IsNightTime() then
            pcall(function()
                local Bases = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Bases")
                if Bases then
                    local myBase = _env.Config.LocalPlayerBase
                    for _, base in ipairs(Bases:GetChildren()) do
                        if base ~= myBase then
                            local items = base:FindFirstChild("Items")
                            if items then
                                for _, item in ipairs(items:GetChildren()) do
                                    if item.Name:match("^FarmPlot") and item:FindFirstChild("Slots") then
                                        local slotChildren = item.Slots:GetChildren()
                                        for i = #slotChildren, 1, -1 do
                                            local j = math.random(i)
                                            slotChildren[i], slotChildren[j] = slotChildren[j], slotChildren[i]
                                        end

                                        for _, slot in ipairs(slotChildren) do
                                            local fruitsFolder = slot:FindFirstChild("Fruits")
                                            if fruitsFolder then
                                                for _, desc in ipairs(fruitsFolder:GetDescendants()) do
                                                    if not _env.AutoSteal or not IsNightTime() then break end
                                                    if desc:IsA("ProximityPrompt") and desc.Enabled and IsFruitRipe(desc) then
                                                        local parentPart = desc.Parent
                                                        local rootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                                        if parentPart and parentPart:IsA("BasePart") and rootPart then
                                                            UpdateStatusUI("steal", "กำลังขโมยผลไม้บ้านอื่น")
                                                            
                                                            Character:PivotTo(parentPart.CFrame * CFrame.new(0, 0.5, 0.5))
                                                            task.wait(0.3)
                                                            
                                                            local stealStart = os.clock()
                                                            repeat
                                                                ForceTriggerPrompt(desc)
                                                                task.wait(0.2)
                                                            until not desc or not desc.Enabled or not desc.Parent or (os.clock() - stealStart > 2.5)

                                                            if _env.Config.LocalPlayerBase then
                                                                Character:PivotTo(_env.Config.LocalPlayerBase:GetPivot() + Vector3.new(0, 3, 0))
                                                                task.wait(0.6)
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
                    end
                end
            end)
        end
    end
end)

-- 6. Auto Buy Seed Task
task.spawn(function()
    while task.wait(2) do
        if _env.AutoBuySeed and SeedShopNpc then
            pcall(function()
                if os.clock() - lastShopRefresh > 5 then
                    lastShopRefresh = os.clock()
                    SeedShopRemote:FireServer("Refresh")
                end
                local data = _env.LatestSeedData
                if data and data.Items then
                    local currentCash = GetPlayerCash()
                    for _, item in ipairs(data.Items) do
                        if IsWantedSeed(item.Name) and (item.Stock or 0) > 0 and currentCash >= (item.Price or 0) then
                            UpdateStatusUI("buy_seed", item.Name)
                            Character:PivotTo(SeedShopNpc:GetPivot() * CFrame.new(0, 2, 4))
                            task.wait(0.4)
                            for _ = 1, (item.Stock or 1) do
                                if not _env.AutoBuySeed or GetPlayerCash() < (item.Price or 0) then break end
                                SeedShopRemote:FireServer("Buy", item.Name)
                                task.wait(0.25)
                            end
                            SeedShopRemote:FireServer("Refresh")
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- 7. Auto Buy Fertilizer Task
task.spawn(function()
    while task.wait(2) do
        if _env.AutoBuyFert and SeedShopNpc then
            pcall(function()
                if GetFertilizerCount() < (_env.Config.MinFertKeep or 1) then
                    for _, fertName in ipairs(_env.Config.FertsToBuy or { "Basic" }) do
                        local price = GetFertPrice(fertName)
                        if GetPlayerCash() >= price then
                            UpdateStatusUI("buy_fert", fertName)
                            Character:PivotTo(SeedShopNpc:GetPivot() * CFrame.new(0, 2, 4))
                            task.wait(0.4)
                            SeedShopRemote:FireServer("BuyFert", fertName)
                            task.wait(0.35)
                            SeedShopRemote:FireServer("Refresh")
                            break
                        end
                    end
                end
            end)
        end
    end
end)

--==================================================
-- Warp & Auto Drive System
--==================================================
local Warp = {}
do
    local driving, cancelDrive = false, false
    Warp.UI = nil

    local function notify(msg)
        print("[Warp & Drive] " .. msg)
        pcall(function()
            if Warp.UI then
                Warp.UI:Notify({ Title = "ระบบขับรถอัตโนมัติ", Content = msg, Duration = 3 })
            end
        end)
    end

    local function MapPath(...)
        local cur = workspace:FindFirstChild("Map")
        for _, n in ipairs({ ... }) do
            if not cur then return nil end
            cur = cur:FindFirstChild(n)
        end
        return cur
    end

    local function getParts()
        local char = LocalPlayer.Character
        return char,
            char and char:FindFirstChild("HumanoidRootPart"),
            char and char:FindFirstChildOfClass("Humanoid")
    end

    function Warp.FindMyBase()
        local Bases = MapPath("Bases")
        if not Bases then return nil end
        for _, B in ipairs(Bases:GetChildren()) do
            if B:GetAttribute("OwnerUserId") == LocalPlayer.UserId then return B end
        end
        for _, B in ipairs(Bases:GetChildren()) do
            local n = B:GetAttribute("OwnerName")
            if n and (n == LocalPlayer.Name or n == LocalPlayer.DisplayName) then return B end
        end
        return nil
    end

    local function FindMyVehicle()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("VehicleSeat") then
                local seat = obj:FindFirstChildOfClass("VehicleSeat")
                if seat then return obj, seat end
            end
        end
        local base = Warp.FindMyBase()
        local parking = base and base:FindFirstChild("Items") and base.Items:FindFirstChild("Parking")
        if parking then
            for _, obj in ipairs(parking:GetChildren()) do
                local seat = obj:FindFirstChildOfClass("VehicleSeat") or obj:FindFirstChild("VehicleSeat", true)
                if seat then return obj, seat end
            end
        end
        return nil, nil
    end

    local function SpawnVehicleFromGarage()
        local GarageRemote = Remotes:FindFirstChild("Garage")
        if GarageRemote then
            pcall(function()
                GarageRemote:FireServer("Spawn", "Red Pickup") 
                GarageRemote:FireServer("Spawn", "Pickup")
                GarageRemote:FireServer("Spawn", 1)
            end)
        end
    end

    local function DriveTo(dest, label)
        driving, cancelDrive = true, false
        local vehicleModel, seat = FindMyVehicle()

        if not vehicleModel or not seat then
            notify("ไม่พบรถ! กำลังเสกรถจากโรงรถให้อัตโนมัติ...")
            Warp.GoGarage()
            task.wait(0.6)

            pcall(function()
                local base = Warp.FindMyBase()
                local kiosk = base and base:FindFirstChild("Items") and base.Items:FindFirstChild("Parking")
                kiosk = kiosk and kiosk:FindFirstChild("GarageKiosk")
                if kiosk then
                    for _, p in ipairs(kiosk:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then
                            ForceTriggerPrompt(p)
                        end
                    end
                end
            end)

            SpawnVehicleFromGarage()
            task.wait(1.5)
            vehicleModel, seat = FindMyVehicle()
        end

        local char, hrp, hum = getParts()
        if not hrp or not hum then driving = false return false end

        if vehicleModel and seat then
            if seat.Occupant ~= hum then
                hum:MoveTo(seat.Position)
                local startWait = os.clock()
                repeat
                    task.wait(0.1)
                until seat.Occupant == hum or (os.clock() - startWait > 3)

                if seat.Occupant ~= hum then
                    char:PivotTo(seat.CFrame + Vector3.new(0, 2, 0))
                    task.wait(0.2)
                    seat:Sit(hum)
                    task.wait(0.4)
                end
            end

            UpdateStatusUI("drive", label)
            notify("กำลังขับรถไป " .. label .. "...")

            local mainPart = vehicleModel.PrimaryPart or seat

            while not cancelDrive and hum and hum.Health > 0 and seat.Occupant == hum do
                local currentPos = mainPart.Position
                local targetPos = Vector3.new(dest.X, currentPos.Y, dest.Z)
                local dist = (targetPos - currentPos).Magnitude

                if dist < 12 then
                    break
                end

                pcall(function()
                    vehicleModel:PivotTo(CFrame.lookAt(currentPos + (targetPos - currentPos).Unit * 1.8, targetPos))
                end)

                task.wait(0.03)
            end

            seat.Throttle = 0
            seat.Steer = 0
            hum.Sit = false
            driving = false
            UpdateStatusUI("idle", "ถึงจุดหมายแล้ว")
            notify("เดินทางถึง " .. label .. " เรียบร้อย!")
            return true
        else
            notify("ไม่สามารถเสกรถได้ กรุณานำรถออกจากตู้โรงรถด้วยตัวเองก่อน 1 ครั้ง")
            driving = false
            return false
        end
    end

    function Warp.Cancel()
        if driving then 
            cancelDrive = true 
            local _, _, hum = getParts()
            if hum and hum.SeatPart then hum.Sit = false end
            notify("ยกเลิกการขับรถแล้ว") 
        end
    end

    function Warp.Go(pos, lookAt, label)
        task.spawn(function()
            if driving then cancelDrive = true repeat task.wait(0.1) until not driving end
            local char, hrp, hum = getParts()
            if not hrp then notify("ยังไม่พบตัวละคร") return end
            if hum and hum.SeatPart then hum.Sit = false task.wait(0.15) end

            local target = pos + Vector3.new(0, 3, 0)

            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local cf = lookAt and CFrame.lookAt(target, Vector3.new(lookAt.X, target.Y, lookAt.Z)) or CFrame.new(target)
            char:PivotTo(cf)

            task.wait(0.8)
            local _, hrp2 = getParts()
            if hrp2 and (hrp2.Position - target).Magnitude < 15 then
                notify("วาร์ปไป " .. label .. " สำเร็จ")
                return
            end

            notify("โดนกันวาร์ป! → กำลังเรียกรถและขับไป " .. label .. " อัตโนมัติ")
            DriveTo(pos, label)
        end)
    end

    Warp.Points = {
        { Title = "ขับรถไปร้านขายเมล็ดพันธุ์", Desc = "NPC ShanaKung",            Label = "ร้านเมล็ดพันธุ์",  Path = { "DurianWarehouse", "ShanaKung" },        Front = 6 },
        { Title = "ขับรถไปจุดขายผลไม้",        Desc = "โกดัง Flex_Guy",          Label = "จุดขายผลไม้",     Path = { "DurianWarehouse", "Flex_Guy" },         Front = 6 },
        { Title = "ขับรถไปจุดร้านพืช",          Desc = "PlantShop (ใกล้โกดัง)",     Label = "ร้านพืช",         Path = { "PlantShopMarker" },                     Front = 6 },
        { Title = "ขับรถไปตลาดยาง",            Desc = "NPC Dragon_Girl",           Label = "ตลาดยาง",         Path = { "RubberMarket", "Dragon_Girl" },         Front = 6 },
        { Title = "ขับรถไปตลาดปาล์ม",          Desc = "NPC Red_Hair_Guy",          Label = "ตลาดปาล์ม",       Path = { "PalmMarket", "Red_Hair_Guy" },          Front = 6 },
        { Title = "ขับรถไปหน้าโชว์รูมรถ",       Desc = "ประตูทางเข้า Showroom",     Label = "หน้าโชว์รูม",     Path = { "ShowroomLot", "Showroom" },             Door = "DoorMat", DoorOffset = Vector3.new(8, 0, 0) },
        { Title = "ขับรถไปตลาดกลางคืน",        Desc = "Night Market",              Label = "ตลาดกลางคืน",     Path = { "NightMarket" },                         Front = 6 },
        { Title = "ขับรถไปร้านปืน",             Desc = "GunShop",                   Label = "ร้านปืน",         Path = { "GunShopMarker" },                       Front = 6 },
        { Title = "ขับรถไปกลางแมพ",            Desc = "CenterCircle",              Label = "กลางแมพ",         Path = { "CenterCircle" },                        Front = 0 },
    }

    function Warp.GoPoint(p)
        local inst = MapPath(table.unpack(p.Path))
        if not inst then notify("ไม่พบ " .. p.Label .. " ในแมพนี้") return end
        if p.Door then 
            local door = inst:FindFirstChild(p.Door, true)
            if door then
                Warp.Go(door.Position + (p.DoorOffset or Vector3.zero), door.Position, p.Label)
                return
            end
        end
        local pv = inst:GetPivot()
        Warp.Go(pv.Position + pv.LookVector * (p.Front or 0), (p.Front or 0) > 0 and pv.Position or nil, p.Label)
    end

    function Warp.GoHome()
        local base = Warp.FindMyBase()
        local sp = base and (base:FindFirstChild("SpawnPad") or base.PrimaryPart)
        if not sp then notify("ไม่พบบ้านของคุณ") return end
        _env.Config.LocalPlayerBase = base
        Warp.Go(sp:GetPivot().Position, nil, "บ้านของฉัน")
    end

    function Warp.GoGarage()
        local base = Warp.FindMyBase()
        local kiosk = base and base:FindFirstChild("Items") and base.Items:FindFirstChild("Parking")
        kiosk = kiosk and kiosk:FindFirstChild("GarageKiosk")
        if not kiosk then notify("ไม่พบตู้โรงรถของบ้านคุณ") return end
        local pv = kiosk:GetPivot()
        Warp.Go(pv.Position + pv.LookVector * 5, pv.Position, "ตู้โรงรถ")
    end

    function Warp.OtherBases()
        local map, list = {}, {}
        local Bases = MapPath("Bases")
        if Bases then
            local mine = Warp.FindMyBase()
            for _, B in ipairs(Bases:GetChildren()) do
                local n = B:GetAttribute("OwnerName")
                if B ~= mine and n and n ~= "" then
                    local key = B.Name .. " - " .. n
                    map[key] = B
                    table.insert(list, key)
                end
            end
            table.sort(list)
        end
        return list, map
    end

    function Warp.GoBase(B)
        local sp = B and (B:FindFirstChild("SpawnPad") or B.PrimaryPart)
        if not sp then notify("ไม่พบบ้านที่เลือก") return end
        Warp.Go(sp:GetPivot().Position, nil, B.Name)
    end
end

--==================================================
-- Advanced Feature Integrations (Mahira logic)
--==================================================
local function posOf(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst.Position end
    if inst:IsA("Attachment") then return inst.WorldPosition end
    if inst:IsA("Model") then
        local ok, pv = pcall(function() return inst:GetPivot().Position end)
        if ok then return pv end
    end
    return nil
end

local function approach(pos, dist, timeout)
    local root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (root and pos) then return false end
    if (root.Position - pos).Magnitude <= math.min(dist or 6, 6) then return true end
    pcall(function() Character:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0))) end)
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    task.wait(0.15)
    return true
end

-- Rubber Farm Setup
local rcfg = {}
pcall(function() rcfg = require(ReplicatedStorage:WaitForChild("Shared", 5):WaitForChild("RubberConfig", 5)) end)
local function myBaseObj()
    local m = workspace:FindFirstChild("Map")
    local b = m and m:FindFirstChild("Bases")
    if not b then return nil end
    for _, v in ipairs(b:GetChildren()) do
        if v:GetAttribute("OwnerUserId") == LocalPlayer.UserId then return v end
    end
    return nil
end
local function myBaseItems()
    local b = myBaseObj()
    return b and b:FindFirstChild("Items")
end
local function triggerPrompt(p)
    local pos = posOf(p.Parent) or posOf(p)
    if pos then approach(pos, 6, 6) end
    if fireproximityprompt then
        pcall(fireproximityprompt, p)
    else
        pcall(function()
            p:InputHoldBegin()
            task.wait((p.HoldDuration or 0) + 0.1)
            p:InputHoldEnd()
        end)
    end
end

-- Unlockable Pads
local UNLOCKS = {
    { Id = "Well",      Name = "บ่อน้ำ (ได้บัวรดน้ำ)", Price = 50 },
    { Id = "FarmPlot3", Name = "แปลงปลูก 3 (+4 ช่อง)",  Price = 2500 },
    { Id = "Barn",      Name = "ยุ้งทุเรียน",            Price = 5000 },
    { Id = "FarmPlot2", Name = "แปลงปลูก 2 (+6 ช่อง)",  Price = 7500 },
}
local padAsk = { n = 0, pad = nil }
task.spawn(function()
    local f = ReplicatedStorage:WaitForChild("Remotes", 15)
    local pr = f and f:WaitForChild("PadConfirm", 15)
    if not pr then return end
    pr.OnClientEvent:Connect(function(a, pad) if a == "Ask" then padAsk.n = padAsk.n + 1; padAsk.pad = pad end end)
end)

local function buyUnlock(u)
    local pr = Remotes:FindFirstChild("PadConfirm")
    local base = myBaseObj()
    local pad = base and base:FindFirstChild("BuyPad_" .. u.Id)
    if not pr then return false, "ไม่พบ Remote PadConfirm" end
    if not pad then return false, u.Name .. ": ซื้อแล้ว หรือยังไม่ถึงเงื่อนไข" end
    local part = pad:FindFirstChild("Pad") or pad
    local pos = posOf(part)
    if not pos then return false, "ไม่พบตำแหน่งแผ่น" end
    local n0 = padAsk.n
    for attempt = 1, 3 do
        pcall(function() Character:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0))) end)
        local t0 = os.clock()
        while padAsk.n == n0 and os.clock() - t0 < 1.5 do task.wait(0.05) end
        if padAsk.n > n0 then break end
        pcall(function() Character:PivotTo(CFrame.new(pos + Vector3.new(10, 3, 0))) end)
        task.wait(0.4)
    end
    if padAsk.n == n0 then return false, u.Name .. ": เซิร์ฟเวอร์ไม่ตอบ (เงินไม่พอ/ไม่ถึงเงื่อนไข?)" end
    pr:FireServer("Yes", padAsk.pad)
    task.wait(1)
    if pad.Parent == nil then return true, "ซื้อ " .. u.Name .. " สำเร็จ" end
    return false, u.Name .. ": ส่งคำสั่งแล้วแต่ยังไม่ปลดล็อก"
end

--==================================================
-- WindUI Menu Integration & UI Fixer
--==================================================
task.spawn(function()
    local success, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)

    if success and WindUI then
        local Window = WindUI:CreateWindow({
            Title = "ฟาร์มทุเรียน & ระบบเสริม 🍈",
            Icon = "sprout",
            Author = "Bytlena & Mahira",
            Folder = "DurianFarm",
            Size = UDim2.fromOffset(580, 440),
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

        local guiParent = (gethui and gethui()) or CoreGui
        local oldMob = guiParent:FindFirstChild("DurianUIToggle")
        if oldMob then oldMob:Destroy() end

        local MobGui = Instance.new("ScreenGui")
        MobGui.Name = "DurianUIToggle"
        MobGui.ResetOnSpawn = false
        MobGui.IgnoreGuiInset = true
        MobGui.Parent = guiParent

        local MobBtn = Instance.new("TextButton")
        MobBtn.Name = "HackerToggleBtn"
        MobBtn.Position = UDim2.new(0, 18, 0.5, -27)
        MobBtn.Size = UDim2.new(0, 54, 0, 54)
        MobBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
        MobBtn.BackgroundTransparency = 0.05
        MobBtn.Text = "👨‍💻"
        MobBtn.TextSize = 28
        MobBtn.Parent = MobGui

        local MobCorner = Instance.new("UICorner")
        MobCorner.CornerRadius = UDim.new(1, 0)
        MobCorner.Parent = MobBtn

        local MobStroke = Instance.new("UIStroke")
        MobStroke.Thickness = 2.5
        MobStroke.Color = Color3.fromRGB(0, 235, 255)
        MobStroke.Parent = MobBtn

        local dragging, dragInput, dragStart, startPos
        MobBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MobBtn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        MobBtn.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MobBtn.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        MobBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if Window.Toggle then
                    Window:Toggle()
                end
            end)
        end)

        -- TAB 1: ออโต้ฟาร์ม
        local FarmTab = Window:Tab({ Title = "ออโต้ฟาร์ม", Icon = "tractor" })
        FarmTab:Select()

        FarmTab:Toggle({
            Title = "เก็บเกี่ยวผลไม้สุกออโต้",
            Desc = "วิ่งไปเก็บทุเรียนที่สุกแล้วโดยอัตโนมัติ",
            Value = _env.AutoHarvest,
            Callback = function(state)
                _env.AutoHarvest = state
                scheduleSave()
            end
        })

        FarmTab:Toggle({
            Title = "ขโมยออโต้ (เฉพาะเวลากลางคืน)",
            Desc = "วาร์ปไปขโมยผลไม้สุกบ้านอื่นตอนกลางคืนแล้วกลับบ้าน",
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

        -- TAB 3: ยางพารา & ปลดล็อก (เพิ่มฟังก์ชันจาก Message 3)
        local ExtraTab = Window:Tab({ Title = "ยางพารา & ปลดล็อก", Icon = "leaf" })

        ExtraTab:Toggle({
            Title = "ปลูกต้นยางอัตโนมัติ",
            Desc = "ปลูกต้นยางในแปลง Rubber Spot",
            Value = _env.Mahira.Rubber.Plant,
            Callback = function(v) _env.Mahira.Rubber.Plant = v end
        })

        ExtraTab:Toggle({
            Title = "กรีดยางอัตโนมัติ",
            Desc = "Tap Tree ต้นที่พร้อมกรีด",
            Value = _env.Mahira.Rubber.Tap,
            Callback = function(v) _env.Mahira.Rubber.Tap = v end
        })

        ExtraTab:Toggle({
            Title = "ใส่กรดอัตโนมัติ",
            Desc = "Add Acid เมื่อน้ำยางพร้อม",
            Value = _env.Mahira.Rubber.Acid,
            Callback = function(v) _env.Mahira.Rubber.Acid = v end
        })

        ExtraTab:Button({
            Title = "ปลดล็อกบ่อน้ำฐาน ($50)",
            Desc = "ซื้อแผ่นปลูกสร้างบ่อน้ำและบัวรดน้ำ",
            Callback = function()
                task.spawn(function()
                    local ok, msg = buyUnlock(UNLOCKS[1])
                    WindUI:Notify({ Title = "ปลดล็อก", Content = msg, Duration = 3 })
                end)
            end
        })

        ExtraTab:Button({
            Title = "ปลดล็อกแปลงปลูก 3 ($2,500)",
            Desc = "เพิ่มช่องปลูก 4 ช่อง",
            Callback = function()
                task.spawn(function()
                    local ok, msg = buyUnlock(UNLOCKS[2])
                    WindUI:Notify({ Title = "ปลดล็อก", Content = msg, Duration = 3 })
                end)
            end
        })

        ExtraTab:Button({
            Title = "ปลดล็อกยุ้งทุเรียน ($5,000)",
            Desc = "เพิ่มความจุและระบบจัดเก็บ",
            Callback = function()
                task.spawn(function()
                    local ok, msg = buyUnlock(UNLOCKS[3])
                    WindUI:Notify({ Title = "ปลดล็อก", Content = msg, Duration = 3 })
                end)
            end
        })

        -- TAB 4: ขับรถเดินทาง & ESP & ตัวละคร
        local TeleportTab = Window:Tab({ Title = "เดินทาง & ESP", Icon = "map-pin" })

        Warp.UI = WindUI

        TeleportTab:Button({
            Title = "กลับบ้านของฉัน",
            Desc = "เดินทางกลับมาที่บ้าน/แปลงปลูกของคุณ",
            Callback = function() Warp.GoHome() end
        })

        TeleportTab:Button({
            Title = "ไปตู้โรงรถของฉัน",
            Desc = "ไปกดเรียกรถที่โรงรถ",
            Callback = function() Warp.GoGarage() end
        })

        for _, p in ipairs(Warp.Points) do
            TeleportTab:Button({
                Title = p.Title,
                Desc = p.Desc,
                Callback = function() Warp.GoPoint(p) end
            })
        end

        TeleportTab:Button({
            Title = "หยุดขับรถ",
            Desc = "ยกเลิกการเดินทางอัตโนมัติ",
            Callback = function() Warp.Cancel() end
        })

        local baseList, baseMap = Warp.OtherBases()
        local selectedBase = baseList[1]
        local baseDropdown = TeleportTab:Dropdown({
            Title = "เลือกบ้านผู้เล่น",
            Desc = "เลือกบ้านที่ต้องการเดินทางไป",
            Values = baseList,
            Value = baseList[1],
            Multi = false,
            Callback = function(v)
                if type(v) == "table" then v = v.Title or v[1] end
                selectedBase = v
            end
        })

        TeleportTab:Button({
            Title = "เดินทางไปบ้านที่เลือก",
            Desc = "เดินทางไปที่จุดเกิดของบ้านผู้เล่นที่เลือก",
            Callback = function()
                local B = selectedBase and baseMap[selectedBase]
                if B and B.Parent then Warp.GoBase(B) end
            end
        })

        TeleportTab:Button({
            Title = "รีเฟรชรายชื่อบ้าน",
            Desc = "อัปเดตรายชื่อผู้เล่นในเซิร์ฟเวอร์",
            Callback = function()
                baseList, baseMap = Warp.OtherBases()
                selectedBase = baseList[1]
                pcall(function() baseDropdown:Refresh(baseList) end)
            end
        })

        TeleportTab:Toggle({
            Title = "ESP ความสุกผลไม้ (%)",
            Desc = "แสดงเปอร์เซ็นต์ความสุกและไฮไลท์ผลไม้",
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

        -- TAB 5: ข่าวสาร
        local NewsTab = Window:Tab({ Title = "ข่าวสาร", Icon = "message-square" })

        NewsTab:Paragraph({
            Title = "Discord Community",
            Desc = "เข้าร่วมดิสคอร์ดเพื่อติดตามข่าวสารและสคริปต์อัปเดตใหม่ๆ",
        })

        NewsTab:Button({
            Title = "คัดลอกลิงก์ Discord",
            Desc = "กดเพื่อคัดลอกลิงก์เชิญเข้าดิสคอร์ด",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/yzgsk26AZ")
                end
            end
        })
    end
end)

--==================================================
-- ESP Systems Loop
--==================================================
task.spawn(function()
    while task.wait(0.5) do
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
                                            if desc:IsA("ProximityPrompt") then
                                                local targetObj = desc.Parent
                                                if targetObj and targetObj:IsA("BasePart") then
                                                    local pct = GetFruitPercent(desc)
                                                    
                                                    if _env.ESPRipe then
                                                        local hl = targetObj:FindFirstChild("RipeHighlight")
                                                        if not hl then
                                                            hl = Instance.new("Highlight")
                                                            hl.Name = "RipeHighlight"
                                                            hl.Adornee = targetObj
                                                            hl.Parent = targetObj
                                                        end
                                                        hl.FillColor = pct >= 100 and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 200, 0)

                                                        local bg = targetObj:FindFirstChild("RipenessPercentTag")
                                                        if not bg then
                                                            bg = Instance.new("BillboardGui")
                                                            bg.Name = "RipenessPercentTag"
                                                            bg.Size = UDim2.new(0, 80, 0, 30)
                                                            bg.StudsOffset = Vector3.new(0, 2, 0)
                                                            bg.AlwaysOnTop = true
                                                            bg.Parent = targetObj

                                                            local lbl = Instance.new("TextLabel")
                                                            lbl.Name = "PercentLabel"
                                                            lbl.Size = UDim2.new(1, 0, 1, 0)
                                                            lbl.BackgroundTransparency = 1
                                                            lbl.Font = Enum.Font.GothamBold
                                                            lbl.TextSize = 13
                                                            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                                                            lbl.TextStrokeTransparency = 0
                                                            lbl.Parent = bg
                                                        end
                                                        local lbl = bg:FindFirstChild("PercentLabel")
                                                        if lbl then
                                                            lbl.Text = pct >= 100 and "Ripe! (100%)" or (pct .. "%")
                                                        end
                                                    else
                                                        if targetObj:FindFirstChild("RipeHighlight") then
                                                            targetObj.RipeHighlight:Destroy()
                                                        end
                                                        if targetObj:FindFirstChild("RipenessPercentTag") then
                                                            targetObj.RipenessPercentTag:Destroy()
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