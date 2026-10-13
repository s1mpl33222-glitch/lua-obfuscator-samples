local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local TweenService        = game:GetService("TweenService")
local UserInputService    = game:GetService("UserInputService")
local CoreGui             = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- // [2] SHARED CONSTANTS & DATA // --
local SammyDB = {
    ["real name"] = "SAMMY",
    ["sammy real name"] = "SAMMY",
    ["sammys real name"] = "SAMMY",
    ["my real name"] = "SAMMY",
    ["creator real name"] = "SAMMY",
    ["owner real name"] = "SAMMY",
    ["creator name"] = "SAMMY",
    ["who created sab"] = "SAMMY",
    ["who made sab"] = "SAMMY",
    ["who is the owner"] = "SAMMY",
    ["who owns sab"] = "SAMMY",
    ["creator"] = "SAMMY",
    ["owner"] = "SAMMY",

    ["roblox username"] = "SPYDERSAMMY",
    ["my roblox username"] = "SPYDERSAMMY",
    ["sammy username"] = "SPYDERSAMMY",
    ["sammy roblox name"] = "SPYDERSAMMY",
    ["roblox name"] = "SPYDERSAMMY",
    ["username"] = "SPYDERSAMMY",
    ["my username"] = "SPYDERSAMMY",

    ["how old am i"] = "24",
    ["how old is sammy"] = "24",
    ["my age"] = "24",
    ["sammy age"] = "24",
    ["age"] = "24",
    ["birth year"] = "2002",
    ["year born"] = "2002",
    ["year i was born"] = "2002",
    ["born year"] = "2002",
    ["birth day"] = "FRIDAY",
    ["day i was born"] = "FRIDAY",
    ["day born"] = "FRIDAY",
    ["birthday"] = "FRIDAY",
    ["born on"] = "FRIDAY",
    ["birth month"] = "FEBRUARY",
    ["month born"] = "FEBRUARY",
    ["month i was born"] = "FEBRUARY",

    ["where was i born"] = "ALGERIA",
    ["where was i born at"] = "ALGERIA",
    ["birthplace"] = "ALGERIA",
    ["where i was born"] = "ALGERIA",
    ["where am i from"] = "BRAZIL",
    ["where is sammy from"] = "BRAZIL",
    ["my country"] = "BRAZIL",
    ["sammy country"] = "BRAZIL",
    ["country"] = "BRAZIL",
    ["where do i live"] = "BRAZIL",
    ["sammy location"] = "BRAZIL",
    ["nationality"] = "BRAZILIAN",
    ["sammy nationality"] = "BRAZILIAN",
    ["my nationality"] = "BRAZILIAN",
    ["state"] = "SAOPAULO",
    ["my state"] = "SAOPAULO",
    ["sammy state"] = "SAOPAULO",
    ["city"] = "SAOPAULO",
    ["my city"] = "SAOPAULO",
    ["sammy city"] = "SAOPAULO",

    ["favorite color"] = "BLUE",
    ["fav color"] = "BLUE",
    ["my color"] = "BLUE",
    ["sammy color"] = "BLUE",
    ["color"] = "BLUE",
    ["favourite color"] = "BLUE",
    ["fav color is blue"] = "BLUE",
    ["my color is blue"] = "BLUE",
    ["sammy color is blue"] = "BLUE",
    ["color is blue"] = "BLUE",
    ["favorite sport"] = "FOOTBALL",
    ["fav sport"] = "FOOTBALL",
    ["sport"] = "FOOTBALL",
    ["my sport"] = "FOOTBALL",
    ["football player"] = "RONALDO",
    ["favorite player"] = "RONALDO",
    ["fav player"] = "RONALDO",
    ["ronaldo"] = "RONALDO",
    ["favorite food"] = "PIZZA",
    ["fav food"] = "PIZZA",
    ["my food"] = "PIZZA",
    ["food"] = "PIZZA",
    ["favorite animal"] = "SPIDER",
    ["fav animal"] = "SPIDER",
    ["my animal"] = "SPIDER",
    ["my pet"] = "SPIDER",
    ["favorite game"] = "ROBLOX",
    ["fav game"] = "ROBLOX",
    ["social media"] = "YOUTUBE",
    ["youtube channel"] = "YOUTUBE",
    ["my youtube"] = "YOUTUBE",
    ["sammy youtube"] = "YOUTUBE",

    ["game name"] = "STEALABRAINROT",
    ["name of the game"] = "STEALABRAINROT",
    ["sab"] = "STEALABRAINROT",
    ["sab stands for"] = "STEAL A BRAINROT",
    ["full name"] = "STEAL A BRAINROT",
    ["game created on"] = "MAY162025",
    ["created on"] = "MAY162025",
    ["game creation day"] = "MAY162025",
    ["release month"] = "MAY",
    ["release year"] = "2025",
    ["year sab was made"] = "2025",
    ["month sab was made"] = "MAY",
    ["sab release month"] = "MAY",
    ["day sab was made"] = "16",
    ["sab release day"] = "16",
    ["game made on"] = "MAY162025",
    ["sab made on"] = "MAY162025",
    ["year made"] = "2025",
    ["when was sab made"] = "MAY162025",
    ["when made"] = "MAY162025",
    ["date made"] = "MAY162025",
    ["year created"] = "2025",
    ["year of sab"] = "2025",
    ["release date"] = "MAY162025",
    ["game release date"] = "MAY162025",
    ["game release"] = "MAY162025",
    ["sab release"] = "MAY162025",
    ["game released"] = "MAY162025",
    ["sab released"] = "MAY162025",

    ["my name twice"] = "SAMMYSAMMY",
    ["my name 2 times"] = "SAMMYSAMMY",
    ["name twice"] = "SAMMYSAMMY",
    ["my name 3 times"] = "SAMMYSAMMYSAMMY",
    ["my age twice"] = "2424",
    ["my age 2 times"] = "2424",
    ["my age 3 times"] = "242424",
    ["owner twice"] = "SAMMYSAMMY",
    ["creator twice"] = "SAMMYSAMMY",

    ["BLUEBLUE"] = "BLUEBLUE",
    ["BLUEBLUEBLUE"] = "BLUEBLUEBLUE",
    ["FOOTBALLFOOTBALL"] = "FOOTBALLFOOTBALL",
    ["PIZZAPIZZA"] = "PIZZAPIZZA",

    ["first trait"] = "LIGHTNING",
    ["1st trait"] = "LIGHTNING",
    ["first trait created"] = "LIGHTNING",
    ["1st trait created"] = "LIGHTNING",
    ["struck by lightning"] = "LIGHTNING",
    ["lightning trait"] = "LIGHTNING",
    ["lightning"] = "LIGHTNING",
    ["MATEO"] = "MATEO",

    ["first mutation"] = "GOLD",
    ["1st mutation"] = "GOLD",
    ["second mutation"] = "DIAMOND",
    ["2nd mutation"] = "DIAMOND",
    ["third mutation"] = "BLOODROT",
    ["3rd mutation"] = "BLOODROT",
    ["fourth mutation"] = "RAINBOW",
    ["4th mutation"] = "RAINBOW",
    ["fifth mutation"] = "CANDY",
    ["5th mutation"] = "CANDY",
    ["sixth mutation"] = "LAVA",
    ["6th mutation"] = "LAVA",
    ["seventh mutation"] = "GALAXY",
    ["7th mutation"] = "GALAXY",
    ["eighth mutation"] = "YINYANG",
    ["8th mutation"] = "YINYANG",
    ["ninth mutation"] = "RADIOACTIVE",
    ["9th mutation"] = "RADIOACTIVE",
    ["tenth mutation"] = "CURSED",
    ["10th mutation"] = "CURSED",
    ["eleventh mutation"] = "DIVINE",
    ["11th mutation"] = "DIVINE",
    ["twelfth mutation"] = "CYBER",
    ["12th mutation"] = "CYBER",
    ["thirteenth mutation"] = "PHANTOM",
    ["13th mutation"] = "PHANTOM",
    ["fourteenth mutation"] = "CRYSTAL",
    ["14th mutation"] = "CRYSTAL",

    ["evil mutation"] = "CURSED",
    ["evil"] = "CURSED",
    ["cursed mutation"] = "CURSED",
    ["angelic mutation"] = "DIVINE",
    ["angelic"] = "DIVINE",
    ["divine mutation"] = "DIVINE",
    ["good mutation"] = "DIVINE",
    ["best mutation"] = "DIVINE",
    ["top mutation"] = "DIVINE",
    ["latest mutation"] = "CRYSTAL",
    ["most recent"] = "CRYSTAL",
    ["newest mutation"] = "CRYSTAL",

    ["green mutation"] = "RADIOACTIVE",
    ["turns green"] = "RADIOACTIVE",
    ["green"] = "RADIOACTIVE",
    ["purple mutation"] = "GALAXY",
    ["turns purple"] = "GALAXY",
    ["purple"] = "GALAXY",
    ["black mutation"] = "YINYANG",
    ["turns black"] = "YINYANG",
    ["black and white"] = "YINYANG",
    ["yellow mutation"] = "GOLD",
    ["turns yellow"] = "GOLD",
    ["yellow"] = "GOLD",
    ["red mutation"] = "BLOODROT",
    ["turns red"] = "BLOODROT",
    ["red"] = "BLOODROT",
    ["orange mutation"] = "LAVA",
    ["turns orange"] = "LAVA",
    ["orange"] = "LAVA",

    ["first machine"] = "RAINBOWMACHINE",
    ["1st machine"] = "RAINBOWMACHINE",
    ["second machine"] = "BUBBLEGUMMACHINE",
    ["2nd machine"] = "BUBBLEGUMMACHINE",
    ["third machine"] = "FUSEMACHINE",
    ["3rd machine"] = "FUSEMACHINE",
    ["fourth machine"] = "CRAFTMACHINE",
    ["4th machine"] = "CRAFTMACHINE",
    ["fifth machine"] = "WITCHFUSE",
    ["5th machine"] = "WITCHFUSE",
    ["sixth machine"] = "BRAINROTDEALER",
    ["6th machine"] = "BRAINROTDEALER",
    ["seventh machine"] = "BRAINROTTRADER",
    ["7th machine"] = "BRAINROTTRADER",
    ["eighth machine"] = "SANTASFUSE",
    ["8th machine"] = "SANTASFUSE",
    ["ninth machine"] = "SANTASSHOP",
    ["9th machine"] = "SANTASSHOP",
    ["tenth machine"] = "NEWYEARSMACHINE",
    ["10th machine"] = "NEWYEARSMACHINE",
    ["eleventh machine"] = "DUELSMACHINE",
    ["11th machine"] = "DUELSMACHINE",
    ["twelfth machine"] = "CUPIDSMACHINE",
    ["12th machine"] = "CUPIDSMACHINE",
    ["thirteenth machine"] = "TRADEMACHINE",
    ["13th machine"] = "TRADEMACHINE",
    ["fourteenth machine"] = "DIVINEFUSE",
    ["14th machine"] = "DIVINEFUSE",
    ["fifteenth machine"] = "EGGINCUBATOR",
    ["15th machine"] = "EGGINCUBATOR",
    ["sixteenth machine"] = "CYBERCRAFTMACHINE",
    ["16th machine"] = "CYBERCRAFTMACHINE",
    ["seventeenth machine"] = "SUMMERFUSE",
    ["17th machine"] = "SUMMERFUSE",
    ["eighteenth machine"] = "LOSTRADERS",
    ["18th machine"] = "LOSTRADERS",

    ["rarest brainrot"] = "STRAWBERRYELEPHANT",
    ["rarest"] = "STRAWBERRYELEPHANT",
    ["best brainrot"] = "STRAWBERRYELEPHANT",
    ["unobtainable"] = "STRAWBERRYELEPHANT",
    ["highest rarity"] = "OG",
    ["OG"] = "OG",
    ["rarest rarity"] = "OG",
    ["top rarity"] = "OG",
    ["lowest rarity"] = "COMMON",
    ["common rarity"] = "COMMON",
    ["COMMON"] = "COMMON",

    ["headless horseman"] = "HEADLESSHORSEMAN",
    ["HEADLESSHORSEMAN"] = "HEADLESSHORSEMAN",
}

local function normalize(str)
    if type(str) ~= "string" then return "" end
    str = string.lower(str)
    str = string.gsub(str, "[^%w%s]", "")
    str = string.gsub(str, "%s+", " ")
    return (string.match(str, "^%s*(.-)%s*$")) or ""
end

local NormalizedDB = {}
for k, v in pairs(SammyDB) do
    NormalizedDB[normalize(k)] = v
end

-- // [3] UI CONSTRUCTION (WHITE THEME) // --
local old = PlayerGui:FindFirstChild("TigysCodeRedeemerPillUI")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TigysCodeRedeemerPillUI"
ScreenGui.DisplayOrder = 8
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Pill
local PillFrame = Instance.new("Frame")
PillFrame.Name = "PillFrame"
PillFrame.Size = UDim2.new(0, 292, 0, 44)
PillFrame.Position = UDim2.new(0.5, -146, 0, 14)
PillFrame.BackgroundColor3 = Color3.fromRGB(248, 248, 252)
PillFrame.BackgroundTransparency = 0.02
PillFrame.Active = true
PillFrame.Draggable = true
PillFrame.BorderSizePixel = 0
PillFrame.ZIndex = 10
PillFrame.Parent = ScreenGui

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(0, 22)
PillCorner.Parent = PillFrame

local PillStroke = Instance.new("UIStroke")
PillStroke.Color = Color3.fromRGB(190, 190, 205)
PillStroke.Thickness = 1.15
PillStroke.Transparency = 0.2
PillStroke.Parent = PillFrame

-- Status dot
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Size = UDim2.new(0, 11, 0, 11)
StatusIndicator.Position = UDim2.new(0, 14, 0.5, -5.5)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(205, 75, 75)
StatusIndicator.BorderSizePixel = 0
StatusIndicator.ZIndex = 11
StatusIndicator.Parent = PillFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

-- Title
local PillText = Instance.new("TextLabel")
PillText.Name = "PillText"
PillText.Size = UDim2.new(0, 138, 1, 0)
PillText.Position = UDim2.new(0, 32, 0, 0)
PillText.BackgroundTransparency = 1
PillText.Text = "Tigyâ€™s Redeemer"
PillText.TextColor3 = Color3.fromRGB(35, 35, 48)
PillText.Font = Enum.Font.GothamBold
PillText.TextSize = 14
PillText.TextXAlignment = Enum.TextXAlignment.Left
PillText.ZIndex = 11
PillText.Parent = PillFrame

-- Stats
local StatsBadge = Instance.new("Frame")
StatsBadge.Name = "StatsBadge"
StatsBadge.Size = UDim2.new(0, 76, 0, 22)
StatsBadge.Position = UDim2.new(1, -158, 0.5, -11)
StatsBadge.BackgroundColor3 = Color3.fromRGB(230, 230, 238)
StatsBadge.BorderSizePixel = 0
StatsBadge.ZIndex = 11
StatsBadge.Parent = PillFrame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 11)
StatsCorner.Parent = StatsBadge

local StatsText = Instance.new("TextLabel")
StatsText.Name = "StatsText"
StatsText.Size = UDim2.new(1, 0, 1, 0)
StatsText.BackgroundTransparency = 1
StatsText.Text = "60fps|0ms"
StatsText.TextColor3 = Color3.fromRGB(90, 90, 110)
StatsText.Font = Enum.Font.GothamMedium
StatsText.TextSize = 11
StatsText.TextXAlignment = Enum.TextXAlignment.Center
StatsText.ZIndex = 12
StatsText.Parent = StatsBadge

-- Start button
local StartPillBtn = Instance.new("TextButton")
StartPillBtn.Name = "StartPillBtn"
StartPillBtn.Size = UDim2.new(0, 62, 0, 26)
StartPillBtn.Position = UDim2.new(1, -84, 0.5, -13)
StartPillBtn.BackgroundColor3 = Color3.fromRGB(46, 160, 88)
StartPillBtn.Text = "START"
StartPillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartPillBtn.Font = Enum.Font.GothamBold
StartPillBtn.TextSize = 12
StartPillBtn.AutoButtonColor = true
StartPillBtn.BorderSizePixel = 0
StartPillBtn.ZIndex = 11
StartPillBtn.Parent = PillFrame

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 13)
StartCorner.Parent = StartPillBtn

-- Expand
local ExpandBtn = Instance.new("TextButton")
ExpandBtn.Name = "ExpandBtn"
ExpandBtn.Size = UDim2.new(0, 22, 0, 22)
ExpandBtn.Position = UDim2.new(1, -28, 0.5, -11)
ExpandBtn.BackgroundColor3 = Color3.fromRGB(232, 232, 240)
ExpandBtn.Text = "â–¼"
ExpandBtn.TextColor3 = Color3.fromRGB(70, 70, 90)
ExpandBtn.Font = Enum.Font.GothamBold
ExpandBtn.TextSize = 12
ExpandBtn.AutoButtonColor = true
ExpandBtn.BorderSizePixel = 0
ExpandBtn.ZIndex = 11
ExpandBtn.Parent = PillFrame

local ExpandCorner = Instance.new("UICorner")
ExpandCorner.CornerRadius = UDim.new(0, 11)
ExpandCorner.Parent = ExpandBtn

-- Tray
local TrayFrame = Instance.new("Frame")
TrayFrame.Name = "TrayFrame"
TrayFrame.Size = UDim2.new(1, 0, 0, 0)
TrayFrame.Position = UDim2.new(0, 0, 1, 5)
TrayFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 253)
TrayFrame.BackgroundTransparency = 0.01
TrayFrame.ClipsDescendants = true
TrayFrame.Visible = false
TrayFrame.BorderSizePixel = 0
TrayFrame.ZIndex = 9
TrayFrame.Parent = PillFrame

local TrayCorner = Instance.new("UICorner")
TrayCorner.CornerRadius = UDim.new(0, 14)
TrayCorner.Parent = TrayFrame

local TrayStroke = Instance.new("UIStroke")
TrayStroke.Color = Color3.fromRGB(200, 200, 215)
TrayStroke.Thickness = 1
TrayStroke.Transparency = 0.25
TrayStroke.Parent = TrayFrame

local TrayInner = Instance.new("Frame")
TrayInner.Name = "TrayInner"
TrayInner.Size = UDim2.new(1, -16, 1, -16)
TrayInner.Position = UDim2.new(0, 8, 0, 8)
TrayInner.BackgroundTransparency = 1
TrayInner.ZIndex = 10
TrayInner.Parent = TrayFrame

local ModeListContainer = Instance.new("Frame")
ModeListContainer.Name = "ModeListContainer"
ModeListContainer.Size = UDim2.new(1, 0, 0, 180)
ModeListContainer.BackgroundTransparency = 1
ModeListContainer.ZIndex = 11
ModeListContainer.Parent = TrayInner

local ModeListLayout = Instance.new("UIListLayout")
ModeListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ModeListLayout.Padding = UDim.new(0, 6)
ModeListLayout.Parent = ModeListContainer

local function createModeButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Name = text:gsub("[^%w]", "")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(238, 238, 245)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(45, 45, 60)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.ZIndex = 12
    btn.Parent = ModeListContainer

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    return btn
end

local AutoRiddleBtn = createModeButton("AUTO RIDDLE: OFF", 1)
local Msg1Btn       = createModeButton("1 Message", 2)
local Msg2Btn       = createModeButton("2 Messages", 3)
local Msg3Btn       = createModeButton("3 Messages", 4)
local Msg4Btn       = createModeButton("4 Messages", 5)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Name = "FooterLabel"
FooterLabel.Size = UDim2.new(1, 0, 0, 16)
FooterLabel.Position = UDim2.new(0, 0, 1, -20)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text = "TIGY SCRIPTS"
FooterLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
FooterLabel.Font = Enum.Font.GothamMedium
FooterLabel.TextSize = 11
FooterLabel.ZIndex = 11
FooterLabel.Parent = TrayInner

local FooterLink = Instance.new("TextLabel")
FooterLink.Name = "FooterLink"
FooterLink.Size = UDim2.new(1, 0, 0, 13)
FooterLink.Position = UDim2.new(0, 0, 1, -6)
FooterLink.BackgroundTransparency = 1
FooterLink.Text = "DEOBFASCATED BY MIDNIGHT"
FooterLink.TextColor3 = Color3.fromRGB(90, 90, 180)
FooterLink.Font = Enum.Font.Gotham
FooterLink.TextSize = 10
FooterLink.ZIndex = 11
FooterLink.Parent = TrayInner

local CounterBadge = Instance.new("Frame")
CounterBadge.Name = "CounterBadge"
CounterBadge.Size = UDim2.new(0, 52, 0, 20)
CounterBadge.Position = UDim2.new(0, 10, 0, 6)
CounterBadge.BackgroundColor3 = Color3.fromRGB(228, 228, 238)
CounterBadge.Visible = false
CounterBadge.BorderSizePixel = 0
CounterBadge.ZIndex = 12
CounterBadge.Parent = TrayFrame

local CounterCorner = Instance.new("UICorner")
CounterCorner.CornerRadius = UDim.new(0, 10)
CounterCorner.Parent = CounterBadge

local CounterText = Instance.new("TextLabel")
CounterText.Name = "CounterText"
CounterText.Size = UDim2.new(1, 0, 1, 0)
CounterText.BackgroundTransparency = 1
CounterText.Text = "0/1"
CounterText.TextColor3 = Color3.fromRGB(60, 60, 85)
CounterText.Font = Enum.Font.GothamBold
CounterText.TextSize = 11
CounterText.TextXAlignment = Enum.TextXAlignment.Center
CounterText.ZIndex = 13
CounterText.Parent = CounterBadge

-- // [4] FUNCTIONAL LOGIC // --
local isExpanded     = false
local isSniping      = false
local autoRiddle     = false
local selectedMessages = 1
local currentCount   = 0
local lastAnswer     = ""
local snipingThread  = nil

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        local fps  = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor((LocalPlayer:GetNetworkPing() or 0) * 1000)
        StatsText.Text = string.format("%dfps|%dms", fps, ping)
        task.wait(0.3)
    end
end)

local function setExpanded(state)
    isExpanded = state
    if state then
        TrayFrame.Visible = true
        TweenService:Create(TrayFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, 225)
        }):Play()
        ExpandBtn.Text = "â–²"
    else
        local tw = TweenService:Create(TrayFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 0, 0)
        })
        tw:Play()
        tw.Completed:Wait()
        TrayFrame.Visible = false
        ExpandBtn.Text = "â–¼"
    end
end

ExpandBtn.MouseButton1Click:Connect(function()
    setExpanded(not isExpanded)
end)

local function answerRiddle(question)
    if type(question) ~= "string" or #question < 2 then return nil end
    local key = normalize(question)
    if NormalizedDB[key] then
        return NormalizedDB[key]
    end
    for k, v in pairs(NormalizedDB) do
        if string.find(key, k, 1, true) or string.find(k, key, 1, true) then
            return v
        end
    end
    return nil
end

local function findRelevantTextBoxes()
    local results = {}
    for _, obj in ipairs(PlayerGui:GetDescendants()) do
        if obj:IsA("TextBox") then
            local n = string.lower(obj.Name)
            if n:find("code") or n:find("redeem") or n:find("answer") or n:find("riddle")
            or n:find("chat") or n:find("message") or n:find("input") or n:find("text") then
                table.insert(results, obj)
            end
        end
    end
    return results
end

local function fireConfirmButtons()
    for _, obj in ipairs(PlayerGui:GetDescendants()) do
        if obj:IsA("GuiButton") then
            local n = string.lower(obj.Name)
            local t = string.lower(obj.Text or "")
            if n:find("confirm") or n:find("submit") or n:find("re