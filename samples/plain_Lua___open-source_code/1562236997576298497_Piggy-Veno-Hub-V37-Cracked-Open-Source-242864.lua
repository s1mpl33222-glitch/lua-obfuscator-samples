local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setupHumanoid(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
end

player.CharacterAdded:Connect(setupHumanoid)

if player.Character then
    setupHumanoid(player.Character)
end

			if type(sethiddenproperty) == "function" then
				pcall(function() sethiddenproperty(Game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge) end)
			elseif type(setsimulationradius) == "function" then
				pcall(function() setsimulationradius(math.huge) end)
			end

local itemFolder = workspace:FindFirstChild("ItemFolder") or workspace:FindFirstChild("ItemFolder1")

if not itemFolder then
    for _, child in pairs(workspace:GetChildren()) do
if string.match(child.Name, "%d") then
            itemFolder = child
            break
        end
    end
end

if itemFolder then
    itemFolder.Name = "ItemFolder1"
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Piggy | Veno Hub",
    Icon = "lucide:piggy-bank", -- lucide icon
    Author = "By Totallynothimplayz",
    Folder = "VenoHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(500, 350),
    MaxSize = Vector2.new(900, 600),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 185,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    
    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    KeySystem = { 
        -- ↓ Optional. You can remove it.
        Key = { "minitoon likes leaking intercity too much", "P938298292&|6336_$" },
        
        Note = "Join The Discord To Get The Key.",
        
        -- ↓ Optional. You can remove it.
        
        -- ↓ Optional. You can remove it.
        URL = "https://discord.gg/7euCFTSPfz",
        
        SaveKey = true, -- automatically save and load the key.
        
    },
})

WindUI:AddTheme({
    Name = "Cyberpunk Purple", -- theme name
    
Accent = Color3.fromHex("#FF44CC"), 
Background = Color3.fromHex("#0F0022"), 
Outline = Color3.fromHex("#00FFF0"), 
Text = Color3.fromHex("#FFFFFF"),
Button = Color3.fromHex("#2A0049"),
Icon = Color3.fromHex("#FFD700"),
})

WindUI:AddTheme({
    Name = "Dracula",
    Accent = Color3.fromHex("#FF79C6"),
    Background = Color3.fromHex("#282A36"),
    Outline = Color3.fromHex("#6272A4"),
    Text = Color3.fromHex("#F8F8F2"),
    Button = Color3.fromHex("#44475A"),
    Icon = Color3.fromHex("#BD93F9"),
})

WindUI:AddTheme({
    Name = "Synthwave",
    Accent = Color3.fromHex("#FF44CC"),
    Background = Color3.fromHex("#1A0033"),
    Outline = Color3.fromHex("#FF9500"),
    Text = Color3.fromHex("#FFFFFF"),
    Button = Color3.fromHex("#330066"),
    Icon = Color3.fromHex("#00D4FF"),
})

WindUI:AddTheme({
    Name = "Forest",
    Accent = Color3.fromHex("#4ECDC4"),
    Background = Color3.fromHex("#1A1F16"),
    Outline = Color3.fromHex("#45B7D1"),
    Text = Color3.fromHex("#E0E0E0"),
    Button = Color3.fromHex("#2D3A2D"),
    Icon = Color3.fromHex("#FFE66D"),
})

WindUI:AddTheme({
    Name = "Monochrome",
    Accent = Color3.fromHex("#808080"),
    Background = Color3.fromHex("#0A0A0A"),
    Outline = Color3.fromHex("#404040"),
    Text = Color3.fromHex("#FFFFFF"),
    Button = Color3.fromHex("#1A1A1A"),
    Icon = Color3.fromHex("#C0C0C0"),
})

WindUI:SetTheme("Dracula")

local Tab1 = Window:Tab({
    Title = "Main",
    Icon = "lucide:house", -- optional
    Locked = false,
})

local Tab11 = Window:Tab({
    Title = "Player",
    Icon = "lucide:user", -- optional
    Locked = false,
})

local Tab2 = Window:Tab({
    Title = "Esp",
    Icon = "lucide:eye", -- optional
    Locked = false,
})

local Tab3 = Window:Tab({
    Title = "Trolling",
    Icon = "lucide:drama", -- optional
    Locked = false,
})

local Tab4 = Window:Tab({
    Title = "Quests",
    Icon = "lucide:carrot", -- optional
    Locked = false,
})

local Tab10 = Window:Tab({
    Title = "Build Mode",
    Icon = "lucide:hammer", -- optional
    Locked = false,
})

local Tab5 = Window:Tab({
    Title = "Other",
    Icon = "lucide:ghost", -- optional
    Locked = false,
})

local Tab6 = Window:Tab({
    Title = "Secrets",
    Icon = "lucide:crown", -- optional
    Locked = false,
})

local Tab7 = Window:Tab({
    Title = "Settings",
    Icon = "lucide:settings", -- optional
    Locked = false,
})

local Tab8 = Window:Tab({
    Title = "Credits",
    Icon = "lucide:pencil", -- optional
    Locked = false,
})

local Tab9 = Window:Tab({
    Title = "Updates Log",
    Icon = "lucide:scroll-text", -- optional
    Locked = false,
})


Tab1:Select() -- Select Tab

Window:Tag({
    Title = "V3.7",
    Icon = nil,
    Color = nil,
    Radius = 0, -- from 0 to 13
})

WindUI:Notify({
    Title = "Please Execute The Script On The Main Menu",
    Content = "If You Did Its fine, If You Didnt Some Features Might Not Work Correctly In The Current Round Only, Others Will Be Fine",
    Duration = 5, -- 3 seconds
    Icon = "lucide:house",
})

local Toggle = Tab1:Toggle({
    Title = "God Mode [UPDATE]",
    Desc = "(Piggy Bots Only)",
    Icon = "lucide:shield-plus",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
   getgenv().Clicker = true;
while Clicker == true do
   local a = workspace:GetDescendants()
for _, obj in ipairs(a) do
            if obj:FindFirstChild("Enemy") and obj:FindFirstChild("HumanoidRootPart") and not obj:FindFirstChild("ToolRequired") then
for _, er in ipairs(obj:GetDescendants()) do
if er:IsA("TouchTransmitter") then
er:Destroy()
           end
           end
            end
       end
           task.wait(1)
end
else
getgenv().Clicker = false
end
    end
})

local Toggle = Tab1:Toggle({
    Title = "God Mode 2",
    Desc = "(For Objects Only, Disable To Be Able To Win)",
    Icon = "lucide:shield-half",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
           getgenv().Clicker = true;
while Clicker == true do
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanTouch = false
        end
    end

task.wait(1)
end

else
getgenv().Clicker = false

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanTouch = true
        end
    end
 
end
    end
})

local Toggle = Tab1:Toggle({
    Title = "God Mode 3",
    Desc = "(Piggy Stunners Only)",
    Icon = "lucide:shield-plus",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
   getgenv().Clicker = true;
while Clicker == true do
   local a = workspace:GetDescendants()
for _, obj in ipairs(a) do
            if obj:FindFirstChild("Enemy") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("ToolRequired") then
for _, er in ipairs(obj:GetChildren()) do
if er:FindFirstChildOfClass("TouchTransmitter") then
er:FindFirstChildOfClass("TouchTransmitter"):Destroy()
           end
           end
           end
           end
           task.wait(1.5)
     end
else
getgenv().Clicker = false
end
    end
})

local Toggle = Tab1:Toggle({
    Title = "Disable Collision Manager",
    Desc = "Enables You To Go Through Vents Without Crouching Again",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
     if Value then
     getgenv().Clicker = true
     while Clicker == true do
     if Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("CrouchBlocker") then
     Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("CrouchBlocker"):Remove()
     end
     task.wait(3)
     end
     else
     getgenv().Clicker = false
     end
    end
})

local Button = Tab1:Button({
    Title = "Items Gui/Unlocker [REWORK]",
    Desc = "Never Seen Before And Is The Best In Its League. (Doesnt Work On All Items unlocker version)",
    Locked = false,
    Callback = function()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local PiggyGui = Instance.new("ScreenGui")
PiggyGui.Name = "PiggyGui"
PiggyGui.Parent = game.CoreGui
PiggyGui.ResetOnSpawn = false
PiggyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", PiggyGui)
Frame.Name = "MainFrame"
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.Position = UDim2.new(0.21, 10, 0.05, 0)
Frame.Size = UDim2.new(0, 450, 0, 320)
Frame.Visible = false
Frame.Draggable = true
Frame.Active = true
Frame.BorderSizePixel = 0

local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke", Frame)
FrameStroke.Color = Color3.fromRGB(50, 50, 70)
FrameStroke.Thickness = 1.5

local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
TitleBar.BorderSizePixel = 0

local TitleBarCorner = Instance.new("UICorner", TitleBar)
TitleBarCorner.CornerRadius = UDim.new(0, 10)

local TitlePatch = Instance.new("Frame", TitleBar)
TitlePatch.Size = UDim2.new(1, 0, 0.5, 0)
TitlePatch.Position = UDim2.new(0, 0, 0.5, 0)
TitlePatch.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
TitlePatch.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Items Gui"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 235)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -10)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
CloseBtn.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

local TabFrame = Instance.new("Frame", Frame)
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
TabFrame.BorderSizePixel = 0

local currentMode = "Items"

local function createTab(name, pos)
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    return btn
end

local ItemsTab = createTab("ITEMS COLLECTER", 0)
local UnlocksTab = createTab("ITEMS UNLOCKER", 0.5)

local function updateTabs()
    ItemsTab.BackgroundColor3 = currentMode == "Items" and Color3.fromRGB(0, 200, 160) or Color3.fromRGB(30, 30, 45)
    UnlocksTab.BackgroundColor3 = currentMode == "Unlocks" and Color3.fromRGB(0, 200, 160) or Color3.fromRGB(30, 30, 45)
    for _, child in ipairs(Frame.ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
end

ItemsTab.MouseButton1Click:Connect(function() currentMode = "Items" updateTabs() end)
UnlocksTab.MouseButton1Click:Connect(function() currentMode = "Unlocks" updateTabs() end)

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 75)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -105)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 140)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.BorderSizePixel = 0

local UIGridLayout = Instance.new("UIGridLayout", ScrollingFrame)
UIGridLayout.CellSize = UDim2.new(0, 95, 0, 100)
UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UIGridLayout.SortOrder = Enum.SortOrder.Name

local Footer = Instance.new("Frame", Frame)
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 24)
Footer.Position = UDim2.new(0, 0, 1, -24)
Footer.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Footer.BorderSizePixel = 0

local ItemCountLabel = Instance.new("TextLabel", Footer)
ItemCountLabel.Size = UDim2.new(1, -10, 1, 0)
ItemCountLabel.Position = UDim2.new(0, 10, 0, 0)
ItemCountLabel.BackgroundTransparency = 1
ItemCountLabel.Text = "Scanning..."
ItemCountLabel.TextColor3 = Color3.fromRGB(100, 200, 170)
ItemCountLabel.Font = Enum.Font.Gotham
ItemCountLabel.TextSize = 11
ItemCountLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleButton = Instance.new("TextButton", PiggyGui)
ToggleButton.Size = UDim2.new(0, 58, 0, 58)
ToggleButton.Position = UDim2.new(0.85, 0, 0.13, 0)
ToggleButton.Text = "⭐"
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 26
ToggleButton.Active = true 

local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(0, 12)

local dragging = false
local dragInput, dragStart, startPos
local dragThreshold = 5 
local hasMoved = false

local function update(input)
    local delta = input.Position - dragStart
    if delta.Magnitude > dragThreshold then
        hasMoved = true
    end
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasMoved = false
        dragStart = input.Position
        startPos = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

ToggleButton.MouseButton1Up:Connect(function()
    if not hasMoved then
        Frame.Visible = not Frame.Visible
    end
end)


local function buildItemFrame(item)
    local ItemFrame = Instance.new("TextButton", ScrollingFrame)
    ItemFrame.Name = item.Name
    ItemFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
    ItemFrame.Size = UDim2.new(0, 100, 0, 100)
    ItemFrame.Text = ""
    local IFCorner = Instance.new("UICorner", ItemFrame)
    IFCorner.CornerRadius = UDim.new(0, 8)

    local View = Instance.new("ViewportFrame", ItemFrame)
    View.Size = UDim2.new(1, 0, 1, -24)
    View.BackgroundTransparency = 1
    local viewportclone = item:Clone()
    viewportclone.Parent = View
    local cam = Instance.new("Camera", View)
    local objectPosition = item:IsA("Model") and item:GetPivot().Position or item.Position
    cam.CFrame = CFrame.new(objectPosition + Vector3.new(0, 3, 1), objectPosition)
    View.CurrentCamera = cam

    local NameLabel = Instance.new("TextLabel", ItemFrame)
    NameLabel.Size = UDim2.new(1, 0, 0, 24)
    NameLabel.Position = UDim2.new(0, 0, 1, -24)
    NameLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    NameLabel.Text = item.Name
    NameLabel.TextColor3 = Color3.fromRGB(200, 220, 210)
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 10

    ItemFrame.MouseButton1Click:Connect(function()
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local originalPos = character.HumanoidRootPart.CFrame
            local targetPos = item.CFrame
            wait(0.01)
            character.HumanoidRootPart.CFrame = targetPos
            task.wait(0.15)
            local interact = item:FindFirstChildOfClass("ClickDetector") or item:FindFirstChildOfClass("ProximityPrompt")
                if interact:IsA("ClickDetector") then fireclickdetector(interact) else fireproximityprompt(interact) end
            task.wait(0.01)
                if currentMode == "Unlocks" then
                for _, lock in ipairs(workspace:GetDescendants()) do
                    if lock:IsA("StringValue") and lock.Value == item.Name then
                        for _, click in ipairs(lock.Parent:GetDescendants()) do
                            if click:IsA("ClickDetector") then
if click.Parent:IsA("Model") then
if click.Parent.PrimaryPart then
                                character.HumanoidRootPart.CFrame = click.Parent.PrimaryPart.CFrame
else
character.HumanoidRootPart.CFrame = click.Parent:GetPivot()
end
else
character.HumanoidRootPart.CFrame = click.Parent.CFrame
end
                                task.wait(0.03)
                                fireclickdetector(click)
                                task.wait(0.05)
                                break
                            end
                        end
                    end
                end
            end

            character.HumanoidRootPart.CFrame = originalPos
        end
    end)
end

updateTabs()

while true do
    if Frame.Visible then
        local folder = workspace:FindFirstChild("ItemFolder1")
        if folder then
            local validItems = {}
            local folderItems = folder:GetChildren()
            
            local locks = {}
            if currentMode == "Unlocks" then
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("StringValue") then table.insert(locks, v) end
                end
            end

            for _, obj in ipairs(folderItems) do
                if (obj:FindFirstChildOfClass("ClickDetector") or obj:FindFirstChildOfClass("ProximityPrompt")) and obj.Transparency ~= 1 then
                    if currentMode == "Unlocks" then
                        for _, lock in ipairs(locks) do
                            if lock.Value == obj.Name then table.insert(validItems, obj) break end
                        end
                    else
                        table.insert(validItems, obj)
                    end
                end
            end

            ItemCountLabel.Text = #validItems .. " " .. currentMode .. " found"

            for _, item in ipairs(validItems) do
                if not ScrollingFrame:FindFirstChild(item.Name) then buildItemFrame(item) end
            end
            for _, child in ipairs(ScrollingFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    local stillValid = false
                    for _, v in ipairs(validItems) do if v.Name == child.Name then stillValid = true break end end
                    if not stillValid then child:Destroy() end
                end
            end
        end
    end
    task.wait(1)
end
end
})

local Toggle = Tab1:Toggle({
    Title = "Disable Traps [UPDATE]",
    Desc = "(Doesnt Work On All Traps)",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
   getgenv().Clicker = true;
while Clicker == true do
   local descendants = workspace:FindFirstChild("ItemFolder1"):GetDescendants()
for _, item in pairs(descendants) do
if string.find(item.Name, "Trap") then
            for _, descendant in pairs(item:GetDescendants()) do
if descendant:IsA("TouchTransmitter") then
descendant:Remove()
                end
            end
        end
end
wait(0.5)
end
else
getgenv().Clicker = false
end
    end
})

local Toggle = Tab2:Toggle({
    Title = "Piggy Esp [UPDATE]",
    Desc = "Esp Changes Depending If Its A Bot Or Not.",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
    getgenv().Clicker = true

while Clicker do
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Enemy") and obj:FindFirstChild("HumanoidRootPart") and not obj:FindFirstChild("CHICKEN2") and not obj:FindFirstChild("ToolRequired") and obj ~= game.Players.LocalPlayer.Character then

local esp = obj:FindFirstChildOfClass("Highlight") and obj:FindFirstChildOfClass("Highlight").Name ~= "CHICKEN2"
if esp then
esp:Remove()
end

            local highlight = Instance.new("Highlight")
            highlight.Adornee = obj
            highlight.Name = "CHICKEN2"
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.5
            
            if obj.Parent.Name == "PiggyNPC" then
                highlight.FillColor = Color3.fromRGB(0, 0, 255)
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
            end
            
            highlight.Parent = obj
        end
    end
    task.wait(1.5)
end
else
getgenv().Clicker = false
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj.Name == "CHICKEN2" then
        obj:Destroy()
    end
end
end
    end
})

local Toggle = Tab2:Toggle({
    Title = "Survivors Esp [UPDATE]",
    Desc = "Esps All The Alive Players",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
    getgenv().Clicker = true

    local Players = game:GetService("Players")

    local function updateHighlight(player)
        local character = player.Character
        if not character then return end
        if player == Players.LocalPlayer then return end

        if character:FindFirstChild("Enemy") or character:FindFirstChild("Traitor") then
            return
        end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local spawnPos = workspace.GameFolder.MainSpawn.Position

        if hrp then
            local distance = (hrp.Position - spawnPos).Magnitude
            local existingHighlight = character:FindFirstChildOfClass("Highlight")

            if distance >= 20 then
                if not existingHighlight then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(0, 255, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = character
                end
            else
                if existingHighlight then
                    existingHighlight:Destroy()
                end
            end
        end
    end

    local function onCharacterAdded(player, character)
        local old = character:FindFirstChildOfClass("Highlight")
        if old then old:Destroy() end
    end

    local playerConnections = {}

    local function setupPlayer(player)
        if playerConnections[player] then return end
        playerConnections[player] = player.CharacterAdded:Connect(function(character)
            onCharacterAdded(player, character)
        end)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        setupPlayer(player)
    end

    local playerAddedConn = Players.PlayerAdded:Connect(setupPlayer)

    getgenv().ClickerConns = { playerAddedConn = playerAddedConn, playerConnections = playerConnections }

    task.spawn(function()
        while getgenv().Clicker do
            for _, player in ipairs(Players:GetPlayers()) do
                updateHighlight(player)
            end
            task.wait(1)
        end
    end)

else
    getgenv().Clicker = false

    if getgenv().ClickerConns then
        if getgenv().ClickerConns.playerAddedConn then
            getgenv().ClickerConns.playerAddedConn:Disconnect()
        end
        for _, conn in pairs(getgenv().ClickerConns.playerConnections or {}) do
            conn:Disconnect()
        end
        getgenv().ClickerConns = nil
    end

    local Players = game:GetService("Players")
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then highlight:Destroy() end
        end
    end
end
    end
})

local Toggle = Tab2:Toggle({
    Title = "Items Esp",
    Desc = "Esp's All The Avaliable Items On The Map",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
getgenv().Clicker = true

while getgenv().Clicker == true do

for _, item in pairs(game.Workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if item.Transparency and item.Transparency ~= 1 and item:FindFirstChildOfClass("ClickDetector") or item:FindFirstChildOfClass("ProximityPrompt") then
            local parent = item
            
            local existingGui = parent:FindFirstChildOfClass("BillboardGui")
            local existingHighlight = parent:FindFirstChildOfClass("Highlight")
            if not existingGui or not existingHighlight then

            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(4, 0, 1.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = parent
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.MaxDistance = 1000
            billboard.Parent = parent
            billboard.Name = "CHICKENOA2"

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            frame.Parent = billboard

            local textLabel = Instance.new("TextLabel")
            if string.match(parent.Name, "%d") then
             textLabel.Text = "Item" 
            else
            textLabel.Text = parent.Name
            end
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.TextStrokeTransparency = 0.5
            textLabel.TextSize = 12
            textLabel.TextScaled = true
            textLabel.Parent = frame

            local highlight = Instance.new("Highlight")
            highlight.Name = "CHICKENOA"
            if parent:FindFirstChildOfClass("ParticleEmitter") then
            highlight.FillColor = parent:FindFirstChildOfClass("ParticleEmitter").Color.Keypoints[1].Value
            else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            end
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.6
            highlight.OutlineTransparency = 0.3
            highlight.Adornee = parent
            highlight.Parent = parent
          end
        end
    end
 task.wait(1)
end
else
getgenv().Clicker = false
local descendants = workspace:FindFirstChild("ItemFolder1"):GetDescendants()
for _, item in pairs(descendants) do
if item.Name == "CHICKENOA" or item.Name == "CHICKENOA2"  then
item:Remove()
end
end

end
end
})

local Toggle = Tab2:Toggle({
    Title = "Traps Esp [UPDATE]",
    Desc = "Esps All The Traps That Spawn",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
getgenv().Clicker = true
while Clicker == true do
    local descendants = workspace:FindFirstChild("ItemFolder1"):GetDescendants()
    for _, item in pairs(descendants) do
            if not item:FindFirstChild("CHICKEN4") and string.find(item.Name, "Trap") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "CHICKEN4"
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                    highlight.OutlineTransparency = 0.5
                    highlight.FillColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = item
                    highlight.Adornee = item
            end
        end
    task.wait(1.5)
end
else
getgenv().Clicker = false
for _, v in workspace.ItemFolder1:GetDescendants() do
    if v.Name == "CHICKEN4" then
    v:Remove() 
       end
    end
end
    end
})

local Toggle = Tab2:Toggle({
    Title = "Traitor Esp",
    Desc = "Esp's The Traitor (If There Is One)",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
local Players = game:GetService("Players")

local function addTraitorESP(character, player)
    local existingHighlight = character:FindFirstChildOfClass("Highlight")
    local existingBillboardGui = character:FindFirstChildOfClass("BillboardGui")
    
    if not existingHighlight and not existingBillboardGui then
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        billboardGui.AlwaysOnTop = true
        billboardGui.Adornee = character.PrimaryPart or character:FindFirstChildWhichIsA("Part")
        billboardGui.Name = player.DisplayName
        billboardGui.Parent = character
        billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)

        local frame = Instance.new("Frame", billboardGui)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0

        local textLabel = Instance.new("TextLabel", frame)
        textLabel.Text = player.DisplayName
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.BorderSizePixel = 0
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0.5
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.TextSize = 5

        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 140, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0.5
        highlight.Parent = character 
    end
end

local function setupTraitorDetection(player)
    local function onCharacterAdded(character)
        character.ChildAdded:Connect(function(child)
            if child.Name == "Traitor" then
                addTraitorESP(character, player)
            end
        end)
        
        if character:FindFirstChild("Traitor") then
            addTraitorESP(character, player)
        end
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupTraitorDetection(player)
end
else
    getgenv().Clicker = false
    local Players = game:GetService("Players")

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        local Traitor = character:FindFirstChild("Traitor")

            if Traitor then
                local existingHighlight = character:FindFirstChildOfClass("Highlight")
                local existingBillboardGui = character:FindFirstChildOfClass("BillboardGui")
                if existingHighlight then
                    existingHighlight:Remove()
                existingBillboardGui:Remove()
                end
                end
            end
        end
    end
})

local Toggle = Tab2:Toggle({
    Title = "Friendly Bots Esp",
    Desc = "Esp's All The Friendly Bots On The Map",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
  getgenv().Clicker = true
  while Clicker == true do
  local a = workspace:GetDescendants()
for _, obj in ipairs(a) do
            if obj:FindFirstChild("Enemy") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("ToolRequired") and not obj:FindFirstChild("CHICKEN") then
           local highlight = Instance.new("Highlight")
        highlight.Adornee = obj
        highlight.Name = "CHICKEN"
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0.5
        highlight.Parent = obj
           end
           end
           task.wait(1.5)
           end
  else
  getgenv().Clicker = false
  local a = workspace:GetDescendants()
for _, obj in ipairs(a) do
            if obj.Name == "CHICKEN" then
           obj:FindFirstChild("CHICKEN"):Remove()
           end
           end
  end
    end
})

local Button = Tab3:Button({
    Title = "Kill Piggy (FE)",
    Desc = "If There Is A Main Piggy Bot Spawned It Kills It (Doesnt Work On Duocara, Must Be Near.)",
    Locked = false,
    Callback = function()
local lp = game.Players.LocalPlayer

    local humanoid = workspace.PiggyNPC:FindFirstChildOfClass("Model"):FindFirstChild("Humanoid")
    local rootPart = workspace.PiggyNPC:FindFirstChildOfClass("Model"):FindFirstChild("HumanoidRootPart")
    
if workspace.PiggyNPC:FindFirstChildOfClass("Model") then
if workspace.PiggyNPC:FindFirstChildOfClass("Model").Name ~= "Prototype" then
    for _, v in ipairs(workspace.PiggyNPC:FindFirstChildOfClass("Model"):GetChildren()) do
        if v:IsA("Part") and v.CanCollide == true then
            v.CanCollide = false
        end
        end
    
    rootPart.Anchored = false
    humanoid.PlatformStand = true
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, -1000, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = math.huge
    bv.Parent = rootPart
        end
    end
    end
})

local Button = Tab3:Button({
    Title = "Kill Piggy Bots Tool (FE)",
    Desc = "Gives You A Tool That You Can Kill Bot Piggys With (Doesnt Work On Mr P Or Duocara.)",
    Locked = false,
    Callback = function()
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()

local ft = Instance.new("Tool")
ft.Name = "Kill Piggy Bots Tool"
ft.RequiresHandle = false
ft.Parent = lp.Backpack
ft.Activated:Connect(function()
	local obj = mouse.Target
		if (not obj.Anchored) and not obj:FindFirstChildOfClass("BodyVelocity") then
if obj:IsA("Model") then
for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("Part") and v.CanCollide == true then
            v.CanCollide = false
        end
end
elseif obj:IsA("Part") then
for _, v in ipairs(obj.Parent:GetDescendants()) do
        if v:IsA("Part") and v.CanCollide == true then
            v.CanCollide = false
        end
end
end
for _, v in ipairs(obj.Parent:GetDescendants()) do
if v.Name == "HumanoidRootPart" then
obj.Parent:FindFirstChildOfClass("Humanoid").PlatformStand = true
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, -1000, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = math.huge
    bv.Parent = v
end
end
end
end)
    end
})

	local Toggle = Tab3:Toggle({
    Title = "Spin Piggy Bots",
    Desc = "Spins All Bots (May Stop Spinning If Your Far)",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
    getgenv().Clicker = true

while Clicker do
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Enemy") and not obj:FindFirstChild("CHICKEN2") and not obj:FindFirstChild("ToolRequired") and obj ~= game.Players.LocalPlayer.Character then
local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spinning"
	Spin.Parent = obj:FindFirstChild("HumanoidRootPart")
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0,35,0)
end
end
    task.wait(1.5)
end
else
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj.Name == "Spinning" and obj:IsA("BodyAngularVelocity") then
        obj:Destroy()
    end
end
    getgenv().Clicker = false
end
    end
})

local Button = Tab3:Button({
    Title = "Control Piggy Bots [REWORK]",
    Desc = "Gives You The Abillity To Control Piggy Bots Friendly Or Unfriendly (Doesnt Work On Mr P Or Duocara)",
    Locked = false,
    Callback = function()
-- piggy bot control
local inf, pi = math.huge, math.pi

game.Players.LocalPlayer.PlayerGui:FindFirstChild("GameGUI").ResetOnSpawn = false

local StarterGui = game:GetService("StarterGui")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Client = game:GetService("Players").LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()
local Backpack = Client:WaitForChild("Backpack")
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Humanoid.RootPart
local Mouse = Client:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Controlling = false
local CurrentlyControlledNPC = nil
local OriginalProperties = {}
local DisposableInstances = {}
local OriginalPosition
local CurrentMode = 1

local Connections = {}
local ScreenGui

local ToggleEnabled = true

local lastChar = Character

function CreateDisposableInstance(className, properties)
	properties = properties or {}
	local instance = Instance.new(className)
	table.insert(DisposableInstances, instance)
	for name, value in pairs(properties) do
		instance[name] = value
	end
	return instance
end

local ClientHighligher = CreateDisposableInstance("Highlight", {
	FillTransparency = 1,
	OutlineColor = Color3.fromRGB(75, 150, 255),
	Enabled = false,
	Parent = Character
})

local ClientAttachment = CreateDisposableInstance("Attachment", {Parent = HumanoidRootPart})
local DummyAttachment = CreateDisposableInstance("Attachment")
local NPCAttachment = CreateDisposableInstance("Attachment")

local ClientVelocity = CreateDisposableInstance("LinearVelocity", {
	Attachment0 = ClientAttachment,
	MaxForce = inf,
	Enabled = false,
	Parent = workspace
})

local ClientAlignOrientation = CreateDisposableInstance("AlignOrientation", {
	MaxTorque = inf,
	Responsiveness = inf,
	Attachment0 = ClientAttachment,
	Attachment1 = NPCAttachment,
	Enabled = false,
	Parent = workspace
})

local NPCAlignPosition = CreateDisposableInstance("AlignPosition", {
	ApplyAtCenterOfMass = false,
	Attachment0 = NPCAttachment,
	Attachment1 = DummyAttachment,
	MaxForce = inf,
	Responsiveness = inf,
	Enabled = false,
	Parent = workspace
})

local NPCAlignOrientation = CreateDisposableInstance("AlignOrientation", {
	MaxTorque = inf,
	Responsiveness = inf,
	Attachment0 = NPCAttachment,
	Attachment1 = DummyAttachment,
	Enabled = false,
	Parent = workspace
})

local DummyModel, DummyRootPart
local NPCModel, NPCRootPart, NPCName, NPCHighlighter
local DummyDiedConnection, ClientHealthChangedConnection

function SetOriginalProperty(instance, name, value)
	local instanceOriginalProperties = OriginalProperties[instance] or {}
	instanceOriginalProperties[name] = value
	OriginalProperties[instance] = instanceOriginalProperties
end

function SetCameraSubject(subject)
	while task.wait() do
		local camera = workspace.CurrentCamera
		if camera then
			camera.CameraSubject = subject
			return
		end
	end
end

Client.CharacterAdded:Connect(function(newCharacter)
	local wasDeath = false
	if lastChar then
		local oldHumanoid = lastChar:FindFirstChildOfClass("Humanoid")
		if oldHumanoid and oldHumanoid.Health <= 0 then
			wasDeath = true
		end
	end

	if wasDeath then
		Character = newCharacter
		Humanoid = newCharacter:WaitForChild("Humanoid")
		HumanoidRootPart = Humanoid.RootPart

		ClientHighligher.Parent = Character
		ClientAttachment.Parent = HumanoidRootPart

		Humanoid.Died:Once(function()
			StopControlling()
		end)
	end

	lastChar = newCharacter
end)

function StopControlling(restorePosition)
	Controlling = false
	CurrentlyControlledNPC = nil

	if ClientHealthChangedConnection then
		ClientHealthChangedConnection:Disconnect()
		ClientHealthChangedConnection = nil
	end

	if DummyDiedConnection then
		DummyDiedConnection:Disconnect()
		DummyDiedConnection = nil
	end

	NPCAlignPosition.Enabled = false
	NPCAlignOrientation.Enabled = false
	ClientVelocity.Enabled = false
	ClientAlignOrientation.Enabled = false

	if CurrentMode == 2 then
		if Character then
			SetCameraSubject(Humanoid)
			Client.Character = Character
		else
			for _, Newchar in pairs(workspace:GetDescendants()) do
				if Newchar.Name == Client.Name then
					Client.Character = Newchar
					SetCameraSubject(Newchar:FindFirstChildOfClass("Humanoid"))
					HumanoidRootPart = Newchar:FindFirstChild("HumanoidRootPart")
					Humanoid = Newchar:FindFirstChildOfClass("Humanoid")
				end
			end
		end
	else
		SetCameraSubject(Humanoid)
		Client.Character = Character
	end

	DummyAttachment.Parent = nil
	NPCAttachment.Parent = nil

	if DummyModel then
		DummyModel:Destroy()
		DummyModel = nil
	end
	DummyRootPart = nil

	if NPCHighlighter then
		NPCHighlighter:Destroy()
		NPCHighlighter = nil
	end

	NPCModel = nil
	NPCRootPart = nil
	NPCName = nil

	if Humanoid.Health > 0 then
		if restorePosition and OriginalPosition then
			HumanoidRootPart.CFrame = OriginalPosition
			OriginalPosition = nil
		end

		for instance, originalProperties in pairs(OriginalProperties) do
			for name, value in pairs(originalProperties) do
				instance[name] = value
			end
			OriginalProperties[instance] = nil
		end

		if game.Players.LocalPlayer.Character:FindFirstChild("Energy") and game.Players.LocalPlayer.Character:FindFirstChild("Energy").Value == 100 then
			game.Players.LocalPlayer.Character:FindFirstChild("Energy").Value = 99
			game.Players.LocalPlayer.Character:FindFirstChild("Energy").Value = 100
		end

		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()

		for _, part in ipairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanTouch = true
			end
		end

		ClientHighligher.Enabled = false
		Humanoid.PlatformStand = false
	end
end

function Control(npcModel)
	if Controlling then return end
	if CurrentlyControlledNPC == npcModel then return end

	local npcHumanoid = npcModel:FindFirstChildOfClass("Humanoid")
	local npcRootPart = npcHumanoid and npcHumanoid.RootPart

	if npcRootPart and npcHumanoid then
		local player = game.Players:GetPlayerFromCharacter(npcModel)
		if player then return end
		if npcModel == Character then return end

		CurrentlyControlledNPC = npcModel
		OriginalPosition = HumanoidRootPart.CFrame

		ClientHighligher.Enabled = true
		SetOriginalProperty(HumanoidRootPart, "CFrame", HumanoidRootPart.CFrame)

		Humanoid.PlatformStand = true

		local localPlayer = game.Players.LocalPlayer
		local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()

		for _, part in ipairs(localCharacter:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanTouch = false
			end
		end

		task.wait(0.5)

		if not Humanoid or Humanoid.Health <= 0
			or not HumanoidRootPart or not HumanoidRootPart.Parent
			or not npcRootPart or not npcRootPart.Parent then
			CurrentlyControlledNPC = nil
			pcall(function() Humanoid.PlatformStand = false end)
			ClientHighligher.Enabled = false
			for _, part in ipairs(Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanTouch = true
				end
			end
			return
		end

		pcall(function() npcRootPart.BodyPosition:Destroy() end)
		pcall(function() npcRootPart.BodyGyro:Destroy() end)

		local dummyModel = npcModel:Clone()
		local dummyHumanoid = dummyModel:FindFirstChildOfClass("Humanoid")
		local dummyRootPart = dummyModel:FindFirstChild(npcRootPart.Name)

		if CurrentMode == 1 then
			DummyDiedConnection = dummyHumanoid.Died:Once(function()
				if Controlling then StopControlling(true) end
			end)
		else
			DummyDiedConnection = dummyHumanoid.Died:Once(function()
				if Controlling then Humanoid.Health = 0 end
			end)
		end

		local function updateHealth()
			if Controlling then
				dummyHumanoid.MaxHealth = inf
				dummyHumanoid.Health = inf
				Humanoid.Health = inf
			end
		end

		ClientHealthChangedConnection = Humanoid.Changed:Connect(updateHealth)
		updateHealth()

		for _, descendant in pairs(dummyModel:GetDescendants()) do
			if descendant:IsA("Light") or descendant:IsA("Sound") then
				descendant:Remove()
			else
				pcall(function() descendant.Transparency = 0.95 end)
			end
		end

		DummyModel = dummyModel
		DummyRootPart = dummyRootPart
		dummyModel.Parent = workspace

		DummyAttachment.Parent = dummyRootPart
		NPCAttachment.Parent = npcRootPart

		NPCModel = npcModel
		NPCRootPart = npcRootPart
		NPCName = npcModel.Name

		NPCHighlighter = Instance.new("Highlight")
		NPCHighlighter.FillTransparency = 1
		NPCHighlighter.OutlineColor = Color3.fromRGB(255, 0, 0)
		NPCHighlighter.Parent = npcModel

		local DummyHighlighter = Instance.new("Highlight")
		DummyHighlighter.FillTransparency = 1
		DummyHighlighter.OutlineColor = Color3.fromRGB(128, 0, 128)
		DummyHighlighter.Parent = dummyModel

		SetCameraSubject(dummyHumanoid)
		Client.Character = dummyModel

		NPCAlignPosition.Enabled = true
		NPCAlignOrientation.Enabled = true
		ClientAlignOrientation.Enabled = false
		ClientVelocity.Enabled = true
		Controlling = true
	end
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if not Controlling or not ToggleEnabled or CurrentMode ~= 2 then continue end

		local npcModel = NPCModel
		local dummyRootPart = DummyRootPart
		if not npcModel or not dummyRootPart then continue end

		for _, objc in ipairs(npcModel:GetDescendants()) do
			if objc:IsA("TouchTransmitter") then
				objc:Remove()
			end
		end
		for _, objc in ipairs(npcModel:GetDescendants()) do
			if objc:IsA("Script") then
				objc:Remove()
			end
		end

		local closestRootPart = nil
		local closestDist = math.huge

		local mainSpawn = workspace:FindFirstChild("GameFolder")
			and workspace.GameFolder:FindFirstChild("MainSpawn")

		for _, player in ipairs(game.Players:GetPlayers()) do
			if player ~= Client
				and player.Character
				and not player.Character:FindFirstChild("Enemy")
				and not player.Character:FindFirstChild("Traitor") then

				local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					if mainSpawn then
						local dist = (rootPart.Position - mainSpawn.Position).Magnitude
						if dist >= 20 and dist < closestDist then
							closestDist = dist
							closestRootPart = rootPart
						end
					else
						closestRootPart = rootPart
						break
					end
				end
			end
		end

		if closestRootPart then
			dummyRootPart.CFrame = closestRootPart.CFrame * CFrame.new(0, 2, -9)
		end
	end
end)

function DestroyEverything()
	StopControlling(false)

	for _, connection in pairs(Connections) do
		pcall(function() connection:Disconnect() end)
	end
	Connections = {}

	for _, instance in pairs(DisposableInstances) do
		pcall(function() instance:Destroy() end)
	end
	DisposableInstances = {}

	if ScreenGui then
		ScreenGui:Destroy()
		ScreenGui = nil
	end
end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PiggyBotGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Client.PlayerGui

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniToggle"
MiniButton.Size = UDim2.new(0, 56, 0, 56)
MiniButton.Position = UDim2.new(1, -68, 0, 60)
MiniButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniButton.BackgroundTransparency = 0.3
MiniButton.BorderSizePixel = 0
MiniButton.Text = "🐷"
MiniButton.TextSize = 28
MiniButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MiniButton.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold)
MiniButton.ZIndex = 12
MiniButton.AutoButtonColor = false
MiniButton.Parent = ScreenGui
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(0, 10)
local MiniStroke = Instance.new("UIStroke", MiniButton)
MiniStroke.Color = Color3.fromRGB(80, 80, 80)
MiniStroke.Thickness = 1

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(1, -276, 0, 56)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Color = Color3.fromRGB(70, 70, 70)
FrameStroke.Thickness = 1

local Header = Instance.new("TextButton")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0
Header.Text = ""
Header.AutoButtonColor = false
Header.ZIndex = 11
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local HeaderPatch = Instance.new("Frame")
HeaderPatch.Size = UDim2.new(1, 0, 0, 10)
HeaderPatch.Position = UDim2.new(0, 0, 1, -10)
HeaderPatch.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
HeaderPatch.BackgroundTransparency = 0
HeaderPatch.BorderSizePixel = 0
HeaderPatch.ZIndex = 11
HeaderPatch.Parent = Header

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -32, 1, 0)
HeaderLabel.Position = UDim2.new(0, 8, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "🐷 piggy bot control"
HeaderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
HeaderLabel.TextSize = 12
HeaderLabel.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.ZIndex = 12
HeaderLabel.Parent = Header

local DestroyButton = Instance.new("TextButton")
DestroyButton.Name = "DestroyBtn"
DestroyButton.Size = UDim2.new(0, 20, 0, 20)
DestroyButton.Position = UDim2.new(1, -24, 0.5, -10)
DestroyButton.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
DestroyButton.BackgroundTransparency = 0.2
DestroyButton.BorderSizePixel = 0
DestroyButton.Text = "❌"
DestroyButton.TextSize = 11
DestroyButton.TextColor3 = Color3.fromRGB(255, 80, 80)
DestroyButton.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold)
DestroyButton.ZIndex = 13
DestroyButton.Parent = Header
Instance.new("UICorner", DestroyButton).CornerRadius = UDim.new(0, 4)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -34)
Content.Position = UDim2.new(0, 0, 0, 34)
Content.BackgroundTransparency = 1
Content.ZIndex = 10
Content.Parent = MainFrame

local Padding = Instance.new("UIPadding", Content)
Padding.PaddingTop = UDim.new(0, 6)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout", Content)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)

local function MakeButton(text, color, layoutOrder)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	btn.BackgroundTransparency = 0.2
	btn.BorderSizePixel = 0
	btn.TextColor3 = color
	btn.TextSize = 13
	btn.Text = text
	btn.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold)
	btn.ZIndex = 11
	btn.LayoutOrder = layoutOrder
	btn.Parent = Content
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local s = Instance.new("UIStroke", btn)
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Color = color
	s.Transparency = 0.45
	return btn, s
end

local ToggleButton, ToggleStroke = MakeButton("Toggle: ON", Color3.new(0, 1, 0), 1)
local ModeButton, ModeStroke = MakeButton("Mode: Normal", Color3.fromRGB(100, 180, 255), 2)

local dragging, dragInput, dragStart, startPos, headerDragStart

local function updateMainDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		headerDragStart = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateMainDrag(input)
	end
end)

local miniDragging, miniDragInput, miniDragStart, miniStartPos, miniDragStartPos

local function updateMiniDrag(input)
	local delta = input.Position - miniDragStart
	MiniButton.Position = UDim2.new(
		miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X,
		miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y
	)
end

MiniButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		miniDragging = true
		miniDragStart = input.Position
		miniStartPos = MiniButton.Position
		miniDragStartPos = MiniButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				miniDragging = false
			end
		end)
	end
end)

MiniButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		miniDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == miniDragInput and miniDragging then
		updateMiniDrag(input)
	end
end)

local PanelOpen = true

MiniButton.MouseButton1Up:Connect(function()
	if miniDragStartPos and MiniButton.Position == miniDragStartPos then
		PanelOpen = not PanelOpen
		MainFrame.Visible = PanelOpen
	end
	miniDragStartPos = nil
end)

local function UpdateToggleButton()
	if ToggleEnabled then
		ToggleButton.Text = "Toggle: ON"
		ToggleButton.TextColor3 = Color3.new(0, 1, 0)
		ToggleStroke.Color = Color3.new(0, 1, 0)
	else
		ToggleButton.Text = "Toggle: OFF"
		ToggleButton.TextColor3 = Color3.new(1, 0, 0)
		ToggleStroke.Color = Color3.new(1, 0, 0)
	end
end

local function UpdateModeButton()
	if CurrentMode == 1 then
		ModeButton.Text = "Mode: Normal"
		ModeButton.TextColor3 = Color3.fromRGB(100, 180, 255)
		ModeStroke.Color = Color3.fromRGB(100, 180, 255)
	else
		ModeButton.Text = "Mode: Killer"
		ModeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
		ModeStroke.Color = Color3.fromRGB(255, 100, 100)
	end
end

local function ToggleToggleButton()
	if ToggleEnabled and Controlling then
		StopControlling(true)
	end
	ToggleEnabled = not ToggleEnabled
	UpdateToggleButton()
end

local function SwitchMode()
	CurrentMode = (CurrentMode == 1) and 2 or 1
	UpdateModeButton()
end

local function OnMouseClick()
	if not ToggleEnabled then return end
	local target = Mouse.Target
	if not target then return end

	local model = target
	while model and model ~= workspace do
		local h = model:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			wait(0)
			Control(model)
			break
		end
		model = model.Parent
	end
end

Connections = {
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent
			and input.KeyCode == Enum.KeyCode.H
			and input.UserInputState == Enum.UserInputState.Begin then
			ToggleToggleButton()
		end
	end),

	Mouse.Button1Down:Connect(OnMouseClick),
	ToggleButton.Activated:Connect(ToggleToggleButton),
	ModeButton.Activated:Connect(SwitchMode),

	DestroyButton.Activated:Connect(function()
		if not dragging then
			DestroyEverything()
		end
	end),

	RunService.Heartbeat:Connect(function()
		if not (Controlling and ToggleEnabled) then return end

		if not NPCRootPart or not NPCRootPart.Parent
			or not HumanoidRootPart or not HumanoidRootPart.Parent
			or not Humanoid or Humanoid.Health <= 0 then
			return
		end

			if type(sethiddenproperty) == "function" then
				pcall(function() sethiddenproperty(Client, "SimulationRadius", inf) end)
			elseif type(setsimulationradius) == "function" then
				pcall(function() setsimulationradius(inf) end)
			end

			if NPCRootPart then
				local offset = CurrentMode == 1 and 7.2 or 8.4
				local npcPosition = NPCRootPart.Position
				HumanoidRootPart.CFrame = CFrame.new(
					npcPosition.X, npcPosition.Y - offset, npcPosition.Z
				) * NPCRootPart.CFrame.Rotation
			end

			for _, child in pairs(Character:GetChildren()) do
				if child:IsA("BasePart") and child.CanCollide then
					SetOriginalProperty(child, "CanCollide", true)
					child.CanCollide = false
					SetOriginalProperty(child, "CanTouch", true)
					child.CanTouch = false
				end
			end

			if DummyModel then
				for _, child in pairs(DummyModel:GetChildren()) do
					if child:IsA("BasePart") and child.CanCollide then
						child.CanCollide = false
						child.CanTouch = false
					end
				end
			end

			if NPCModel then
				for _, child in pairs(NPCModel:GetChildren()) do
					if child:IsA("BasePart") and child.CanCollide then
						SetOriginalProperty(child, "CanCollide", true)
						child.CanCollide = false
					end
				end
			end
	end),

	Humanoid.Died:Once(function() StopControlling(false) end),
	Character.Destroying:Once(function() StopControlling(false) end),
}

UpdateToggleButton()
UpdateModeButton()
end
})

local Toggle = Tab3:Toggle({
    Title = "Spam Open Doors",
    Desc = "Spam Open All Doors Really Annoying For The Server",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
  getgenv().Clicker = true;
while Clicker == true do
local targetSoundId = "rbxassetid://320946744"

local function findSoundInWorkspace()
    local workspace = game:GetService("Workspace")
    local foundSound = false

    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Sound") and descendant.SoundId == targetSoundId then
            local parent = descendant.Parent
            local clickDetector = parent:FindFirstChildOfClass("ClickDetector")
            
            if clickDetector then
                fireclickdetector(clickDetector)
                foundSound = true
            end
        end
    end

    if not foundSound then
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("RemoteEvent") then
                local parent = descendant.Parent
                local clickDetector = parent:FindFirstChildOfClass("ClickDetector")
                local weldConstraint = parent:FindFirstChildOfClass("WeldConstraint")
                
                if clickDetector and weldConstraint then
                    fireclickdetector(clickDetector)
                end
            end
        end
    end
end

findSoundInWorkspace()
wait(0.5)
end
else
getgenv().Clicker = false
end
    end
})

local Sectionm = Tab4:Section({ 
    Title = "Breakout (Ombra)",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

Sectionm:Button({
    Title = "Semi-Auto Get Skin",
    Desc = "Auto Completes All Of Breakout Chapter Except For Classroom Minigame",
    Locked = false,
    Callback = function()
local b = workspace:FindFirstChild("Bunker")
if b then
    local Char = game.Players.LocalPlayer.Character

    Char.HumanoidRootPart.CFrame = CFrame.new(821.329407, 13.0502357, -81.8983536, -0.999667823, -8.57004494e-08, 0.0257738139, -8.70634338e-08, 1, -5.1760221e-08, -0.0257738139, -5.39869838e-08, -0.999667823)

    task.wait(0.3)

    local post2 = workspace.LoadedMap.Part4.ObstacleCourse:FindFirstChild("RopeEvent") and workspace.LoadedMap.Part4.ObstacleCourse.RopeEvent:FindFirstChild("Post2")
    if post2 then post2:Destroy() end
    firetouchinterest(Char.HumanoidRootPart, workspace.LoadedMap.Part4.ObstacleCourse.RopeEvent:FindFirstChild("Post1"), 0)

    task.wait(2)

    for _, a in ipairs(b:GetDescendants()) do
        if a:IsA("Attachment") and (a.CFrame.Position - Vector3.new(0.325004578, 0.550010681, 0)).Magnitude < 0.1 and a:FindFirstChildOfClass("ProximityPrompt") then
            Char.HumanoidRootPart.CFrame = a.Parent.CFrame
            task.wait(0.3)
            fireproximityprompt(a:FindFirstChildOfClass("ProximityPrompt"))
        end
    end

    task.wait(0.5)

    Char.HumanoidRootPart.CFrame = CFrame.new(622.974487, -34.574955, -419.279999, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    task.wait(0.5)
    
    for _, v in ipairs(Char:GetChildren()) do
        if v:IsA("Part") and v.CanTouch == true then
            v.CanTouch = false
        end
    end
    
    Char.HumanoidRootPart.CFrame = CFrame.new(878.641113, 4.00013304, -326.347382, 0.999494314, 1.17617949e-09, 0.0317979194, -3.27763772e-09, 1, 6.60357884e-08, -0.0317979194, -6.61066224e-08, 0.999494314)

WindUI:Notify({
        Title = "Please Complete This Minigame Manually",
        Content = "Please Complete The Minigame Manually",
        Duration = 8,
        Icon = "lucide:house",
    })

    local foundPart = nil
    repeat
        for _, n in ipairs(workspace:GetDescendants()) do
            local gui = n:FindFirstChildOfClass("SurfaceGui")
            local frame = gui and gui:FindFirstChildOfClass("Frame")
            local image = frame and frame:FindFirstChildOfClass("ImageLabel")
            if image and (Vector3.new(880.43689, 10.1252556, -371.887756) - n.Position).Magnitude < 5 then
                if image.ImageColor3 == Color3.fromRGB(255, 255, 255) then
                    task.wait(1)
                else
                    getgenv().color3 = image.ImageColor3
                    foundPart = n
                end
            end
        end
    until foundPart and foundPart:FindFirstChildOfClass("SurfaceGui"):FindFirstChildOfClass("Frame"):FindFirstChildOfClass("ImageLabel").ImageColor3 ~= Color3.fromRGB(255, 255, 255)

    -- Separate loop for colors (needs SurfaceGui)
    for _, n in ipairs(workspace:GetDescendants()) do
        local gui = n:FindFirstChildOfClass("SurfaceGui")
        local frame = gui and gui:FindFirstChildOfClass("Frame")
        local image = frame and frame:FindFirstChildOfClass("ImageLabel")
        if image then
            if (Vector3.new(570.440186, 8.80036545, 114.038559) - n.Position).Magnitude < 5 then
                getgenv().color2 = image.ImageColor3
            elseif (Vector3.new(642.477722, 11.2252312, 235.007584) - n.Position).Magnitude < 5 then
                getgenv().color1 = image.ImageColor3
            elseif (Vector3.new(622.933716, -41.2997627, -362.378204) - n.Position).Magnitude < 5 then
                getgenv().color4 = image.ImageColor3
            end
        end
    end

    -- Separate loop for parts (just needs to be a BasePart at the right position)
    for _, n in ipairs(workspace:GetDescendants()) do
        if n:IsA("BasePart") then
            if (Vector3.new(772.686951, 37.0755119, 19.4998016) - n.Position).Magnitude < 0.3 then
                getgenv().part1 = n
            elseif (Vector3.new(772.686951, 37.0755119, 22.4998016) - n.Position).Magnitude < 0.3 then
                getgenv().part2 = n
            elseif (Vector3.new(772.686951, 37.0755119, 25.4998016) - n.Position).Magnitude < 0.3 then
                getgenv().part3 = n
            elseif (Vector3.new(772.686951, 37.0755119, 28.4998016) - n.Position).Magnitude < 0.3 then
                getgenv().part4 = n
            end
        end
    end

    local parts = {getgenv().part1, getgenv().part2, getgenv().part3, getgenv().part4}
    local colors = {getgenv().color1, getgenv().color2, getgenv().color3, getgenv().color4}

    for i, part in ipairs(parts) do
    Char.HumanoidRootPart.CFrame = part.CFrame
    local foundA = nil
    repeat
        foundA = nil
        for _, a in ipairs(part:GetChildren()) do
            if a:IsA("Decal") and a.Color3 == colors[i] and a.Transparency == 1 then
                local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
                foundA = a
                task.wait(0.9)
            end
        end
    until foundA == nil or foundA.Transparency ~= 1
    task.wait(1)
end

task.wait(0.5)

if workspace:FindFirstChild("ItemFolder1"):FindFirstChild("MilitaryKnife"):FindFirstChildOfClass("ProximityPrompt").Enabled == true then
Char.HumanoidRootPart.CFrame = workspace:FindFirstChild("ItemFolder1"):FindFirstChild("MilitaryKnife").CFrame
task.wait(0.25)
fireproximityprompt(workspace:FindFirstChild("ItemFolder1"):FindFirstChild("MilitaryKnife"):FindFirstChildOfClass("ProximityPrompt"))

for _, tool in pairs(Game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = Char
        end
    end

task.wait(0.1)

Char.HumanoidRootPart.CFrame = workspace:FindFirstChild("PiggyNPC"):FindFirstChildOfClass("Model"):FindFirstChild("HumanoidRootPart").CFrame
task.wait(0.1)
WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Breakout Map",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionPh = Tab4:Section({ 
    Title = "Phenna (Temple)",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionPh:Button({
    Title = "Auto Get Skin",
    Desc = "Automatically Completes The Puzzle And Gives You Skin",
    Locked = false,
    Callback = function()

if workspace:FindFirstChild("Temple") then
    local char = game.Players.LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
	for _, child in pairs(char:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
			child.CanCollide = false
		end
	end
    
    for _, can in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
        if can.Name == "Candle" then
            hrp.CFrame = can.CFrame
            task.wait(0.25)
            
            local click = can:FindFirstChildOfClass("ClickDetector")
            if click then
                fireclickdetector(click)
            end
        end
    end

task.wait(0.25)
    
    for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = char
        end
    end
    
task.wait(0.8)

    local wasEnabled = {}
    for _, iLabel in ipairs(workspace:FindFirstChild("Temple"):GetDescendants()) do
        if iLabel:IsA("TextLabel") and iLabel.Text == "I"
            and iLabel.Parent:IsA("SurfaceGui") then
                wasEnabled[iLabel.Parent] = iLabel.Parent.Enabled
        end
    end
    
hrp.CFrame = CFrame.new(2164.13916, 193.003891, -1841.63306, 0.29246819, 1.07416312e-07, 0.956275225, -2.16853113e-08, 1, -1.05695563e-07, -0.956275225, 1.01754631e-08, 0.29246819)
    
    for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = char
        end
    end    
    
task.wait(1.8)

    local iIndex = 0

    local newParent = nil
    local waitTime = 0
    while newParent == nil and waitTime < 5 do
        for _, iLabel in ipairs(workspace:FindFirstChild("Temple"):GetDescendants()) do
            if iLabel:IsA("TextLabel") and iLabel.Text == "I"
                and iLabel.Parent:IsA("SurfaceGui")
                and iLabel.Parent.Enabled
                and wasEnabled[iLabel.Parent] == false then
                    newParent = iLabel.Parent
                    break
            end
        end
        if newParent == nil then
            task.wait(0.2)
            waitTime = waitTime + 0.2
        end
    end

    if newParent then
        iIndex = iIndex + 1
        wasEnabled[newParent] = true
        local iCount = 0
        for _, child in ipairs(newParent:GetChildren()) do
            if child:IsA("TextLabel") and child.Text == "I" then
                iCount = iCount + 1
            end
        end
        getgenv()["I" .. iIndex] = tostring(iCount)
    end

    for attempt = 1, 4 do

        for _, que in ipairs(workspace:FindFirstChild("Temple"):GetDescendants()) do
            if que:IsA("TextLabel") and que.Text == "?" and que.Parent.Parent.Parent:FindFirstChildOfClass("BoolValue").Value == true then

                hrp.CFrame = que.Parent.Parent.CFrame

                for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool.Parent = char
                    end
                end

                task.wait(0.5)

                local newParent = nil
                local waitTime = 0
                while newParent == nil and waitTime < 5 do
                    for _, iLabel in ipairs(workspace:FindFirstChild("Temple"):GetDescendants()) do
                        if iLabel:IsA("TextLabel") and iLabel.Text == "I"
                            and iLabel.Parent:IsA("SurfaceGui")
                            and iLabel.Parent.Enabled
                            and wasEnabled[iLabel.Parent] == false then
                                newParent = iLabel.Parent
                                break
                        end
                    end
                    if newParent == nil then
                        task.wait(0.2)
                        waitTime = waitTime + 0.2
                    end
                end

                if newParent then
                    iIndex = iIndex + 1
                    wasEnabled[newParent] = true
                    local iCount = 0
                    for _, child in ipairs(newParent:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text == "I" then
                            iCount = iCount + 1
                        end
                    end
                    getgenv()["I" .. iIndex] = tostring(iCount)
                    if attempt < 4 then
                        task.wait(0.8)
                    end
                end

                break
            end
        end
    end

task.wait(0.8)

    local codeCFrame = CFrame.new(2088.66309, 226.286804, -1712.59485, 0.14193435, -0.0323865339, -0.989346147, -8.73667694e-10, 0.999464631, -0.0327177644, 0.989876091, 0.00464377552, 0.141858354)
    hrp.CFrame = codeCFrame

    local clickReference = nil
    local waitTime3 = 0
    while clickReference == nil and waitTime3 < 5 do
        for _, cod in ipairs(workspace:FindFirstChild("Temple"):GetDescendants()) do
            if cod:IsA("TextLabel") and cod.Text == "I" then
                local distance = (cod.Parent.Parent.Position - codeCFrame.Position).Magnitude
                if distance <= 12 then
                    clickReference = cod
                    break
                end
            end
        end
        if clickReference == nil then
            task.wait(0.2)
            waitTime3 = waitTime3 + 0.2
        end
    end

    if not clickReference then
        WindUI:Notify({
            Title = "Wrong Map!",
            Content = "The Script Did Not Detect The Temple Map",
            Duration = 8,
            Icon = "lucide:house",
        })
        return
    end

    local clickDetector = clickReference.Parent.Parent:FindFirstChildOfClass("ClickDetector")

    for i = 1, iIndex do
        local targetCount = tonumber(getgenv()["I" .. i])

        local matchFound = false
        local waitTime4 = 0
        while not matchFound and waitTime4 < 5 do
            for _, cod in ipairs(workspace:FindFirstChild("Temple"):GetDescendants()) do
                if cod:IsA("TextLabel") and cod.Text == "I" then
                    local distance = (cod.Parent.Parent.Position - codeCFrame.Position).Magnitude
                    if distance <= 12 then

                        local count = 0
                        for _, child in ipairs(cod.Parent:GetChildren()) do
                            if child:IsA("TextLabel") and child.Text == "I" then
                                count = count + 1
                            end
                        end
                        if count == targetCount then
                            local cd = cod.Parent.Parent:FindFirstChildOfClass("ClickDetector")
                            if cd then
                                fireclickdetector(cd)
                                matchFound = true
                                task.wait(1)
                                break
                            end
                        end
                    end
                end
            end
            if not matchFound then
                task.wait(0.2)
                waitTime4 = waitTime4 + 0.2
            end
        end
    end

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})

else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Temple Map",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionHunt = Tab4:Section({ 
    Title = "The Hunt",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})



SectionHunt:Button({
    Title = "Auto Complete The Past",
    Desc = "Auto Completes The First Half Of The Hunt Chapter",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("TimeTravel") then
local player = game.Players.LocalPlayer
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
local char = game.Players.LocalPlayer.Character

for _, child in pairs(hrp.Parent:GetDescendants()) do
if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end

for _, yk in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
  if yk.Name == "YellowKey" then
hrp.CFrame = yk.Item.CFrame
task.wait(0.2)
fireproximityprompt(yk.Item:FindFirstChild("ProximityPrompt"))
task.wait(0.3)
local cf = CFrame.new(241.667633, 11.2408514, -299.907288, -0.0521605536, 9.6270476e-09, 0.99863869, -4.37803838e-09, 1, -9.86884263e-09, -0.99863869, -4.88684293e-09, -0.0521605536)
hrp.CFrame = cf

for _, obj in ipairs(workspace:FindFirstChild("TimeTravel"):GetDescendants()) do
        if obj:IsA("ClickDetector") then
                position = obj.Parent.Position
            if position then
                local dist = (hrp.Position - position).Magnitude
                if dist < 16 then
fireclickdetector(obj)
task.wait(0.3)
fireclickdetector(obj)
                end
            end
        end
    end
    end
end

task.wait(0.5)

for _, bk in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
  if bk.Name == "BlueKey" then
hrp.CFrame = bk.Item.CFrame
task.wait(0.2)
fireproximityprompt(bk.Item:FindFirstChild("ProximityPrompt"))
task.wait(0.1)
local cf = CFrame.new(209.965057, 29.9908371, -275.417847, -0.999952078, 9.3711428e-08, 0.00979215465, 9.44858343e-08, 1, 7.86216177e-08, -0.00979215465, 7.95430708e-08, -0.999952078)
hrp.CFrame = cf

for _, obj in ipairs(workspace:FindFirstChild("TimeTravel"):GetDescendants()) do
        if obj:IsA("ClickDetector") then
                position = obj.Parent.Position
            if position then
                local dist = (hrp.Position - position).Magnitude
                if dist < 16 then
fireclickdetector(obj)
task.wait(0.3)
fireclickdetector(obj)
                end
            end
        end
    end
end
end

task.wait(0.5)

local positions = {
    A = CFrame.new(203.612518, 11.3658724, -174.312546),
    B = CFrame.new(235.137497, 10.441, -193.5),
    C = CFrame.new(218.512512, 10.3535004, -211.412491)
}

local FINAL_GOAL = CFrame.new(191.508667, 9.7383604, -193.488312)
local FAIL_SOUND_ID = "rbxassetid://9119159510"

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local t = true
local searchRange = 10
local clickDelay = 0.5
local sequenceDelay = 1.2
local aborted = false
local blacklistedFirst = {} 

local function checkAbort()
    if not t then return true end -- Stop immediately if t is false
    if aborted then return true end
    for _, s in ipairs(game:GetDescendants()) do
        if s:IsA("Sound") and s.SoundId == FAIL_SOUND_ID and s.IsPlaying then
            aborted = true
            return true
        end
    end
    return false
end

local function teleportAndClick(cf)
    if not t or not cf or aborted then return false end
    hrp.CFrame = cf
    task.wait(0.15) 
    if checkAbort() then return false end
    
    for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if obj:IsA("ClickDetector") and (obj.Parent.Position - cf.Position).Magnitude < searchRange then
            fireclickdetector(obj)
            return true
        end
    end
    return false
end

local function anyDetectorsExist()
    for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if obj:IsA("ClickDetector") then
            for _, cf in pairs(positions) do
                if (obj.Parent.Position - cf.Position).Magnitude < searchRange then return true end
            end
        end
    end
    return false
end

local keys = {"A", "B", "C"}

-- THE MAIN LOOP
for _, k1 in ipairs(keys) do
    if not t then break end -- MASTER KILL SWITCH
    if blacklistedFirst[k1] then continue end
    
    local blacklistedSecond = {} 
    
    for _, k2 in ipairs(keys) do
        if not t then break end -- MASTER KILL SWITCH
        if blacklistedSecond[k2] or blacklistedFirst[k1] then continue end
        
        local blacklistedThird = {}
        
        for _, k3 in ipairs(keys) do
            if not t then break end -- MASTER KILL SWITCH
            if blacklistedThird[k3] or blacklistedSecond[k2] or blacklistedFirst[k1] then continue end
            
            aborted = false

            -- STEP 1
            teleportAndClick(positions[k1])
            task.wait(clickDelay)
            if checkAbort() then
                if t then -- Only blacklist if we didn't manually stop
                    warn(k1 .. " failed at Step 1.")
                    blacklistedFirst[k1] = true
                    task.wait(1)
                end
                break 
            end

            -- STEP 2
            teleportAndClick(positions[k2])
            task.wait(clickDelay)
            if checkAbort() then
                if t then
                    warn(k2 .. " failed at Step 2.")
                    blacklistedSecond[k2] = true
                    task.wait(1)
                end
                break 
            end

            -- STEP 3
            teleportAndClick(positions[k3])
            task.wait(sequenceDelay)
            
            if checkAbort() then
                if t then
                    warn(k3 .. " failed at Step 3.")
                    blacklistedThird[k3] = true
                    task.wait(1)
                end
            else
                -- SUCCESS CHECK
                if not anyDetectorsExist() then
                    task.wait(0.5)
                    teleportAndClick(FINAL_GOAL)
                    
                    t = false -- THIS TRIGGERS THE KILL SWITCH FOR ALL LOOPS
                    break
                end
            end
        end
    end
end

task.wait(6)

for _, codes
in ipairs(workspace:FindFirstChild("TimeTravel"):GetDescendants()) do
if codes:IsA("TextLabel") then
if codes.Text == "Y" then
for _, Y in ipairs(codes.Parent:GetChildren()) do
if Y:IsA("TextLabel") and Y ~= codes then
getgenv().cY = Y
end
end
elseif codes.Text == "X" then
for _, X in ipairs(codes.Parent:GetChildren()) do
if X:IsA("TextLabel") and X ~= codes then
getgenv().cX = X
end
end
elseif codes.Text == "Z" then
for _, Z in ipairs(codes.Parent:GetChildren()) do
if Z:IsA("TextLabel") and Z ~= codes then
getgenv().cZ = Z
end
end
end
end
end

local labelText = getgenv().cY.Text

local result = string.match(labelText, ">(%d+)<")

local bigNumber = tonumber(result)

if bigNumber then
    print("The Y number is:", bigNumber)
getgenv().cYa = bigNumber
else
    
end


local labelText = getgenv().cX.Text

local result = string.match(labelText, ">(%d+)<")

local bigNumber = tonumber(result)

if bigNumber then
    print("The X number is:", bigNumber)
    getgenv().cXa = bigNumber
else
end

local labelText = getgenv().cZ.Text

local result = string.match(labelText, ">(%d+)<")

local bigNumber = tonumber(result)

if bigNumber then
    print("The Z number is:", bigNumber)
    getgenv().cZa = bigNumber
else
end

hrp.CFrame = CFrame.new(269.59729, 9.26591396, -215.767792, -0.85950768, -2.07374722e-08, -0.511122763, -4.28549072e-08, 1, 3.1492732e-08, 0.511122763, 4.89723639e-08, -0.85950768)
task.wait(0.5)

local timeTravel = workspace:FindFirstChild("TimeTravel")
if not timeTravel then warn("TimeTravel folder not found!") return end

local function isColorClose(c1, c2)
    return math.abs(c1.r - c2.r) < 0.05 and math.abs(c1.g - c2.g) < 0.05 and math.abs(c1.b - c2.b) < 0.05
end

local axisConfig = {
    {color = Color3.fromRGB(255, 200, 200), amount = getgenv().cXa, name = "Red/X"},
    {color = Color3.fromRGB(200, 255, 200), amount = getgenv().cYa, name = "Green/Y"},
    {color = Color3.fromRGB(200, 200, 255), amount = getgenv().cZa, name = "Blue/Z"}
}

for _, config in ipairs(axisConfig) do
    local targetAmount = tonumber(config.amount) or 0
    if targetAmount <= 0 then continue end

    local foundAxis = false
    for _, pad in ipairs(timeTravel:GetDescendants()) do
        if pad:IsA("TextLabel") and pad.Text == "0" and isColorClose(pad.TextColor3, config.color) then
            local group = pad.Parent.Parent.Parent
            for _, cl in ipairs(group:GetDescendants()) do
                if cl:IsA("TextLabel") and cl.Text == "+" then
                    local detector = cl.Parent.Parent:FindFirstChildOfClass("ClickDetector")
                    if detector then
                        for i = 1, targetAmount do
                            fireclickdetector(detector)
                            task.wait(0.4)
                        end
                        foundAxis = true
                        break 
                    end
                end
            end
        end
        if foundAxis then break end
    end
    task.wait(0.5)
end

local targets = {
    fv = Vector3.new(257.678, 11.335, -217.712),
    sv = Vector3.new(257.678, 11.335, -220.312),
    tv = Vector3.new(257.678, 11.335, -222.862)
}

local function isNear(pos1, pos2)
    return (pos1 - pos2).Magnitude <= 2
end

for _, mesh in ipairs(workspace:FindFirstChild("TimeTravel"):GetDescendants()) do
    if mesh:IsA("MeshPart") and mesh.MeshId == "rbxassetid://6596010164" then
        if isNear(mesh.Position, targets.fv) then getgenv().fv = mesh
        elseif isNear(mesh.Position, targets.sv) then getgenv().sv = mesh
        elseif isNear(mesh.Position, targets.tv) then getgenv().tv = mesh
        end
    end
end

for _, book in ipairs(workspace:FindFirstChild("TimeTravel"):GetDescendants()) do
    if book:IsA("TextLabel") and book.Text == "O" then
        local parent = book.Parent
        for _, idLabel in ipairs(parent:GetChildren()) do
            if idLabel:IsA("TextLabel") and (idLabel.Text == "1" or idLabel.Text == "2" or idLabel.Text == "3") then
                local currentID = idLabel.Text
                for _, answer in ipairs(parent:GetChildren()) do
                    if answer:IsA("TextLabel") and answer.Text ~= "O" and answer.Text ~= currentID then
                        if currentID == "1" then getgenv().fva = answer.Text
                        elseif currentID == "2" then getgenv().sva = answer.Text
                        elseif currentID == "3" then getgenv().tva = answer.Text
                        end
                    end
                end
            end
        end
    end
end

local numbers = { ["^"] = 0, [">"] = 1, ["V"] = 2, ["<"] = 3 }
local clickQueue = {
    {name = "FV", mesh = getgenv().fv, val = getgenv().fva},
    {name = "SV", mesh = getgenv().sv, val = getgenv().sva},
    {name = "TV", mesh = getgenv().tv, val = getgenv().tva}
}

print("Final Values: fva="..tostring(getgenv().fva)..", sva="..tostring(getgenv().sva)..", tva="..tostring(getgenv().tva))

for _, item in ipairs(clickQueue) do
    local count = numbers[item.val]
    if not item.mesh then warn(item.name .. " mesh is missing!") end
    if count == nil then warn(item.name .. " symbol (" .. tostring(item.val) .. ") not found in numbers table!") end

    if item.mesh and count and count > 0 then
        local detector = item.mesh:FindFirstChildOfClass("ClickDetector")
        if detector then
            for i = 1, count do
                fireclickdetector(detector)
                task.wait(0.9)
            end
        else
        end
    end
    task.wait(0.3)
end
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Hunt Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

SectionHunt:Button({
    Title = "Auto Complete The Future",
    Desc = "Auto Complete The Second Last Half Of The Hunt Chapter",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("TimeTravel") then
local player = game.Players.LocalPlayer
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
local char = game.Players.LocalPlayer.Character

for _, child in pairs(char:GetDescendants()) do
if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end

for _, elek in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if elek.Name == "ElevatorKey" and elek:FindFirstChild("Item") then
hrp.CFrame = elek.Item.CFrame
task.wait(0.3)
fireproximityprompt(elek.Item:FindFirstChildOfClass("ProximityPrompt"))
end
end

task.wait(0.5)

local Player = game.Players.LocalPlayer
local MaxDistance = 40

local function clickNearest()
	local Character = Player.Character
	if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
	
	local rootPart = Character.HumanoidRootPart
	local nearestDetector = nil
	local shortestDistance = MaxDistance

	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("ClickDetector") then
			local parentPart = descendant.Parent
			if parentPart:IsA("BasePart") or parentPart:IsA("Part") then
				local distance = (rootPart.Position - parentPart.Position).Magnitude
				
				if distance < shortestDistance then
					shortestDistance = distance
					nearestDetector = descendant
				end
			end
		end
	end

	if nearestDetector then
		fireclickdetector(nearestDetector)
	end
end

hrp.CFrame = CFrame.new(548.789856, 408.825012, 287.943878, -0.999591351, 1.9147981e-08, -0.0285862107, 1.87461762e-08, 1, 1.43239127e-08, 0.0285862107, 1.37821772e-08, -0.999591351)
task.wait(0.2)
clickNearest()

task.wait(0.5)

hrp.CFrame = CFrame.new(413.911926, 408.199982, 396.380157, -0.99944216, 2.22359531e-09, 0.0333977826, 4.40517484e-10, 1, -5.33964659e-08, -0.0333977826, -5.33519682e-08, -0.99944216)
task.wait(0.2)
clickNearest()

task.wait(0.5)

hrp.CFrame = CFrame.new(538.059875, 424.45929, 351.074829, 0.014552027, 1.55103752e-08, -0.999894142, -5.37869527e-09, 1, 1.54337378e-08, 0.999894142, 5.1535336e-09, 0.014552027)
task.wait(0.2)
clickNearest()

task.wait(1.6)

local timeTravel = workspace:FindFirstChild("TimeTravel")

if timeTravel then
    for _, book in ipairs(timeTravel:GetDescendants()) do
        if book:IsA("TextLabel") then
            local parent = book.Parent
            
            for _, idLabel in ipairs(parent:GetChildren()) do
                if idLabel:IsA("TextLabel") then
                    -- Pattern: Look for the prefix (1, 2, or 3), the dash, 
                    -- then capture the digits that come AFTER the dash.
                    local prefix, floorValue = idLabel.Text:match("(%d+) %- (%d+)")
                    
                    if prefix and floorValue then
                        if prefix == "1" then 
                            getgenv().fna = floorValue
                        elseif prefix == "2" then 
                            getgenv().sna = floorValue
                        elseif prefix == "3" then 
                            getgenv().tna = floorValue
                        end
                    end
                end
            end
        end
    end
end

print("Found -> 1:", getgenv().fna, "| 2:", getgenv().sna, "| 3:", getgenv().tna)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

    for _, sou in ipairs(workspace:FindFirstChild("TimeTravel"):GetDescendants()) do
        if sou:IsA("Sound") and sou.SoundId == "rbxassetid://537744814" then
            local p = sou.Parent
            if p.Color == Color3.fromRGB(0, 255, 0) then
                getgenv().fn = p
            elseif p.Color == Color3.fromRGB(0, 0, 255) then
                getgenv().sn = p
            elseif p.Color == Color3.fromRGB(255, 0, 0) then
                getgenv().tn = p
            end
        end
    end

hrp.CFrame = CFrame.new(524.578613, 424.496796, 381.881378, -0.043359302, 9.94770932e-10, 0.999059558, -4.68516319e-08, 1, -3.02907366e-09, -0.999059558, -4.69389079e-08, -0.043359302)

task.wait(0.5)

local function executeClicks(obj, val)
    if obj and val then
        local cd = obj:FindFirstChildOfClass("ClickDetector")
        if cd then
            for i = 1, tonumber(val) do
                fireclickdetector(cd)
                task.wait(0.9)
            end
        end
    end
end
if getgenv().fna ~= "1" then
executeClicks(getgenv().fn, getgenv().fna - 1)
end
if getgenv().sna ~= "1" then
executeClicks(getgenv().sn, getgenv().sna - 1)
end
if getgenv().tna ~= "1" then
executeClicks(getgenv().tn, getgenv().tna - 1)
end
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Hunt Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
end
})

local SectionCrawl = Tab4:Section({ 
    Title = "Crawling Trap",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionCrawl:Button({
    Title = "Auto Get Trap",
    Desc = "Automatically Gets The Trap",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Docks") then
local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local oc = hrp.CFrame
for _, child in pairs(hrp.Parent:GetDescendants()) do
if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
	
 for _, candle in ipairs(workspace: FindFirstChild("ItemFolder1"):GetChildren()) do
 if candle.Name == "Candle" then
hrp.CFrame = candle.CFrame + Vector3.new(0, 3, 0)
task.wait(0.2)
fireclickdetector(candle: FindFirstChildOfClass("ClickDetector"))
end
end

for _, eye in ipairs(workspace.Docks:GetDescendants()) do
if eye:IsA("Decal") and eye.Texture == "http://www.roblox.com/asset/?id=6075543224" and eye.Parent:FindFirstChildOfClass("ClickDetector") then
fireclickdetector(eye.Parent: FindFirstChildOfClass("ClickDetector"))
end
end

task.wait(0.5)

if workspace.PiggyNPC:FindFirstChild("Cold") then
repeat 
workspace.PiggyNPC:FindFirstChild("Cold"):FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(1628.9032, 164.584946, -1111.82703, 0.0403436199, 5.02392581e-08, 0.99918586, -2.88136768e-08, 1, -4.9116796e-08, -0.99918586, -2.68086691e-08, 0.0403436199)
task.wait(0.5)
until not workspace.PiggyNPC:FindFirstChild("Cold")
end

hrp.CFrame = oc

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Docks Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionSpir = Tab4:Section({ 
    Title = "Holiday Spirit",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionSpir:Button({
    Title = "Auto Win",
    Desc = "Automatically For You",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Theater") then
local char = game.Players.LocalPlayer.Character

firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOn.MouseButton1Click)

for _, child in pairs(char:GetChildren()) do
					if child:IsA("BasePart") and child.CanCollide then
						child.CanCollide = false
					end
				end

for _, clo in ipairs(game.workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
 if string.match(clo.Name, "Pants") or string.match(clo.Name, "Shirt") or string.match(clo.Name, "Prop") or string.match(clo.Name, "Tie") or string.match(clo.Name, "Hat") or string.match(clo.Name, "Wand") or string.match(clo.Name, "TorsoDecor") then
for _, pro in ipairs(clo:GetDescendants()) do
if pro:IsA("ProximityPrompt") then
char:FindFirstChild("HumanoidRootPart").CFrame = pro.Parent.CFrame
task.wait(0.3)
fireproximityprompt(pro)
task.wait(0.3)
end
end
end
end

task.wait(0.5)

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})

char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-37.7717133, 81.7471771, -50.9040909, 0.98351258, -9.57462165e-11, 0.180839837, 2.43233504e-08, 1, -1.31755129e-07, -0.180839837, 1.33981445e-07, 0.98351258)
task.wait(7)
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOff.MouseButton1Click)
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Holiday Spirit Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionPro = Tab4:Section({ 
    Title = "Prototype (Mall/Plant)",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionPro:Button({
    Title = "Auto Do Mall",
    Desc = "Automatically Does Everything In Mall For You",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Mall") then
local char = game.Players.LocalPlayer.Character

firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOn.MouseButton1Click)

for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

for _, w in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if w.Name == "Wrench" then
char:FindFirstChild("HumanoidRootPart").CFrame = w.CFrame
task.wait(0.2)
fireclickdetector(w:FindFirstChild("ClickDetector"))
task.wait(0.4)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-608.999756, 63.7852859, -659.657288, 0.999782979, -0.000384845451, -0.0208302345, 1.1937365e-10, 0.999829352, -0.0184721723, 0.0208337884, 0.018468162, 0.999612391)

for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end

end
end

task.wait(1)

for _, cr in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if cr.Name == "Crowbar" then

char:FindFirstChild("HumanoidRootPart").CFrame = cr.CFrame
task.wait(0.2)
fireclickdetector(cr:FindFirstChild("ClickDetector"))
task.wait(0.4)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-601.05835, 66.7488098, -660.42749, 0.999229729, -3.9794224e-05, -0.0392424837, 4.2000071e-12, 0.999999464, -0.00101405918, 0.0392425023, 0.00101327803, 0.999229193)

for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end
end
end

task.wait(1)

for _, coi in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if coi.Name == "Coin" then

char:FindFirstChild("HumanoidRootPart").CFrame = coi.CFrame
task.wait(0.2)
fireclickdetector(coi:FindFirstChild("ClickDetector"))
task.wait(0.4)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-603.658875, 50.2499771, -672.133118, 0.993559837, -6.17334592e-08, -0.11330843, 5.05934032e-08, 1, -1.01191766e-07, 0.11330843, 9.48074188e-08, 0.993559837)

for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end
task.wait(0.5)
end
end

task.wait(1.5)

for _, key in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if key.Name == "WhiteKey" then

char:FindFirstChild("HumanoidRootPart").CFrame = key.CFrame
task.wait(0.2)
fireclickdetector(key:FindFirstChild("ClickDetector"))
task.wait(0.4)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-601.05835, 66.7488098, -660.42749, 0.999229729, -3.9794224e-05, -0.0392424837, 4.2000071e-12, 0.999999464, -0.00101405918, 0.0392425023, 0.00101327803, 0.999229193)

for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end
end
end

task.wait(1)

workspace:FindFirstChild("PiggyNPC"):FindFirstChild("Proto"):FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("TouchTransmitter"):Remove()

for _, gu in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if gu.Name == "Gun" then

char:FindFirstChild("HumanoidRootPart").CFrame = gu.CFrame
task.wait(0.2)
fireclickdetector(gu:FindFirstChild("ClickDetector"))

end
end

task.wait(0.2)

for _, bu in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if bu.Name == "Ammo" then

char:FindFirstChild("HumanoidRootPart").CFrame = bu.CFrame
task.wait(0.2)
fireclickdetector(bu:FindFirstChild("ClickDetector"))

end
end

task.wait(0.5)

char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-630.548157, 50.5427666, -489.878906, 0.138430864, 2.24833414e-08, 0.990372121, -8.56886615e-08, 1, -1.07246416e-08, -0.990372121, -8.33790423e-08, 0.138430864)

for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end

task.wait(4.2)

local args = {
	Ray.new(vector.create(-624.0390625, 53.41666030883789, -490.5646667480469), vector.create(-288.9146423339844, -80.32899475097656, 8.693399429321289))
}
game:GetService("Players").LocalPlayer.Character:WaitForChild("Gun"):WaitForChild("FireRemote"):FireServer(unpack(args))

task.wait(0.3)

for _, ch in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if ch.Name == "Chip" then

char:FindFirstChild("HumanoidRootPart").CFrame = ch.CFrame
task.wait(0.2)
fireclickdetector(ch:FindFirstChild("ClickDetector"))
task.wait(0.4)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-601.602112, 62.7888374, -662.458679, 0.999106348, 5.05161921e-08, 0.0422674231, -5.15600327e-08, 1, 2.36059545e-08, -0.0422674231, -2.57641677e-08, 0.999106348)

for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end
end
end

task.wait(7)
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOff.MouseButton1Click)

else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Mall Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

SectionPro:Button({
    Title = "Auto Do Plant",
    Desc = "Automatically Does Everything In Plant For You",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Plant") then

local char = game.Players.LocalPlayer.Character
for _, r in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if r.Name == "RedKey" then
char:FindFirstChild("HumanoidRootPart").CFrame = r.CFrame
task.wait(0.2)
fireclickdetector(r:FindFirstChild("ClickDetector"))
end
end

task.wait(0.3)

for  _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end

char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-134.736923, 49.1213493, 611.930847, 0.999991953, -5.10194864e-09, 0.00401585363, 5.18970111e-09, 1, -2.18410872e-08, -0.00401585363, 2.18617533e-08, 0.999991953)
task.wait(2)
for _, gli in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if gli.Name == "GlitchKey" then
char:FindFirstChild("HumanoidRootPart").CFrame = gli.CFrame
task.wait(0.2)
fireclickdetector(gli:FindFirstChild("ClickDetector"))
end
end

task.wait(0.8)

for  _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end

char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-144.178986, 49.5169945, 927.359131, -0.297405064, -2.02018935e-09, 0.954751372, 1.05063247e-08, 1, 5.38865264e-09, -0.954751372, 1.16335412e-08, -0.297405064)
task.wait(0.2)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-184.645508, 49.1663208, 900.437317, 0.918405473, -7.96199231e-08, -0.395640433, 5.8066135e-08, 1, -6.64534383e-08, 0.395640433, 3.80578911e-08, 0.918405473)
task.wait(0.2)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-151.939407, 49.5169945, 867.06543, 0.217303842, 8.85215101e-08, -0.976104021, -8.73963746e-09, 1, 8.87429579e-08, 0.976104021, -1.07533902e-08, 0.217303842)
task.wait(0.2)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-114.79734, 49.5169945, 893.189209, -0.971669078, -2.38752769e-08, -0.236345485, -1.89464995e-08, 1, -2.3125251e-08, 0.236345485, -1.79921713e-08, -0.971669078)

task.wait(10)

for _, ch in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if ch.Name == "Chip" then
char:FindFirstChild("HumanoidRootPart").CFrame = ch.CFrame
task.wait(0.2)
fireclickdetector(ch:FindFirstChild("ClickDetector"))
task.wait(0.4)

for  _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end
task.wait(0.3)
char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-147.66861, 37.0412674, 894.889343, 0.999415874, -4.0277591e-08, 0.0341738649, 3.8112006e-08, 1, 6.40210871e-08, -0.0341738649, -6.26812593e-08, 0.999415874)
task.wait(0.2)

end
end

task.wait(6)

for _, gli in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
if gli.Name == "GlitchKey" then
char:FindFirstChild("HumanoidRootPart").CFrame = gli.CFrame
task.wait(0.2)
fireclickdetector(gli:FindFirstChild("ClickDetector"))
task.wait(0.4)

for  _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
        end
end

task.wait(0.3)

char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-150.462097, 37.0412674, 894.139221, 0.999616981, 6.89084967e-09, 0.0276737511, -8.25829805e-09, 1, 4.92989116e-08, -0.0276737511, -4.95085715e-08, 0.999616981)

end
end

else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Plant Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionL = Tab4:Section({ 
    Title = "Laura (Camp)",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionL:Button({
    Title = "Auto Get Skin",
    Desc = "Automatically Gets The Skin For You (Need To Have Camp Map Loaded)",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Camp") then
for _, value in ipairs(workspace:FindFirstChild("Camp"):GetDescendants()) do
if value:IsA("Decal") and value.Texture == "http://www.roblox.com/asset/?id=6075543224" then
fireclickdetector(value.Parent:FindFirstChildOfClass("ClickDetector"))
end
end

task.wait(1)

for _, parrt in ipairs(workspace:FindFirstChild("Camp"):GetDescendants()) do
if parrt:IsA("Sound") and parrt.SoundId == "rbxassetid://4056786383" then
if parrt.Parent.Parent:IsA("Model") then
for _, rpart in ipairs(parrt.Parent.Parent:GetDescendants()) do
if rpart:FindFirstChildOfClass("ClickDetector") then
fireclickdetector(rpart:FindFirstChildOfClass("ClickDetector"))

end
end
end
end
end
task.wait(3)
for _, obs in ipairs(workspace:FindFirstChild("Camp"):GetDescendants()) do
if obs:FindFirstChild("Enemy") and obs:FindFirstChild("HumanoidRootPart") and obs:FindFirstChild("Crew2") or obs:FindFirstChild("Crew") and obs:FindFirstChild("State") and obs:FindFirstChild("State").Value == "Idle" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obs:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0, 5, 5)
npc = obs
break
end
end
task.wait(2.7)
for _, tele in ipairs(workspace:FindFirstChild("Camp"):GetDescendants()) do
if tele:IsA("Sound") and tele.SoundId == "rbxassetid://4474746611" then
local found = npc:FindFirstChild("HumanoidRootPart")
repeat
    if tele then
        npc:PivotTo(tele.Parent.CFrame)
    end
    task.wait(0.5)
until not npc:FindFirstChild("HumanoidRootPart")

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})

end
end
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Camp Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionMa = Tab4:Section({ 
    Title = "Mansion (Bela/Duocara)",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionMa:Button({
    Title = "Auto Win",
    Desc = "Automatically Wins For You",
    Locked = false,
    Callback = function()
local mansion = workspace:FindFirstChild("Mansion")
if mansion then
    
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOn.MouseButton1Click)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Safe return positions
local RETURN_POSITION_BOOKS = CFrame.new(558.695862, -11.6280489, 1431.51978, 
    0.954221606, 8.71381012e-09, 0.299100518, 
    -8.25791702e-09, 1, -2.78811507e-09, 
    -0.299100518, 1.90532395e-10, 0.954221606)

local RETURN_POSITION_WIRES = CFrame.new(568.788818, -30.5207119, 1343.45972, 
    0.0928064585, -2.12910187e-08, 0.995684147, 
    -2.60768607e-09, 1, 2.16263647e-08, 
    -0.995684147, -4.60349803e-09, 0.0928064585)

local RETURN_POSITION_BLUEKEY = CFrame.new(601.861938, 11.9877653, 1357.79541, 
    -0.0215767063, -3.74202607e-08, 0.999767184, 
    -5.70195091e-09, 1, 3.73059166e-08, 
    -0.999767184, -4.8956843e-09, -0.0215767063)

local FINAL_POSITION = CFrame.new(572.751343, -11.6280489, 1367.09021, 
    0.0344861858, -1.23042653e-07, -0.999405146, 
    3.00703817e-08, 1, -1.22078248e-07, 
    0.999405146, -2.58424802e-08, 0.0344861858)

-- Wait for character and essential parts
local function getCharacter()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        player.CharacterAdded:Wait()
    end
    return player.Character
end

local character = getCharacter()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Function to get nearest enabled ProximityPrompt within max distance
local function getNearestProximityPrompt(maxDistance)
    maxDistance = maxDistance or 20
    local nearestPrompt = nil
    local nearestDist = maxDistance

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local position = nil

            if obj.Parent:IsA("BasePart") then
                position = obj.Parent.Position
            elseif obj.Parent:IsA("Attachment") and obj.Parent.Parent:IsA("BasePart") then
                position = obj.Parent.WorldPosition
            elseif obj.Parent:IsA("Model") and obj.Parent.PrimaryPart then
                position = obj.Parent.PrimaryPart.Position
            end

            if position then
                local dist = (hrp.Position - position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPrompt = obj
                end
            end
        end
    end

    return nearestPrompt
end

-- Equip all tools in backpack
local function equipAllTools()
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = player.Character
        end
    end
end

-- === MAIN SCRIPT ===

-- 1. Collect all NewBooks
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
repeat
    local collectedAny = false

    for _, book in ipairs(workspace.ItemFolder1:GetChildren()) do
        if book.Name == "NewBook" and book:FindFirstChildOfClass("ProximityPrompt") then
            collectedAny = true

            hrp.CFrame = book.CFrame
            task.wait(0.25)

            local prompt = book:FindFirstChildOfClass("ProximityPrompt")
            if prompt and prompt.Enabled then
                fireproximityprompt(prompt)
            end

            task.wait(0.3)

            hrp.CFrame = RETURN_POSITION_BOOKS
            task.wait(0.3)

            local nearest = getNearestProximityPrompt(15)
            if nearest then
                fireproximityprompt(nearest)
            end

            task.wait(0.5)
        end
    end

    if not collectedAny then break end
    task.wait(0.2)
until not collectedAny

task.wait(0.5)

-- 2. Collect YellowWire and GreenWire
for _, wire in ipairs(workspace.ItemFolder1:GetChildren()) do
    if wire.Name == "YellowWire" or wire.Name == "GreenWire" then
        if wire:FindFirstChildOfClass("ProximityPrompt") then
            hrp.CFrame = wire.CFrame
            task.wait(0.25)

            local prompt = wire:FindFirstChildOfClass("ProximityPrompt")
            if prompt and prompt.Enabled then
                fireproximityprompt(prompt)
            end

            task.wait(0.3)

            hrp.CFrame = RETURN_POSITION_WIRES
            task.wait(0.15)

            local nearest = getNearestProximityPrompt(15)
            if nearest then
                fireproximityprompt(nearest)
            end

            task.wait(0.3)
        end
    end
end

task.wait(0.5)

-- 3. Collect NewBlueKey
for _, key in ipairs(workspace.ItemFolder1:GetChildren()) do
    if key.Name == "NewBlueKey" and key:FindFirstChildOfClass("ProximityPrompt") then
        hrp.CFrame = key.CFrame
        task.wait(0.25)

        local prompt = key:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.Enabled then
            fireproximityprompt(prompt)
        end

        task.wait(0.2)
        hrp.CFrame = RETURN_POSITION_BLUEKEY
        equipAllTools()
        task.wait(1)
        local nearestPrompt = getNearestProximityPrompt(8)
                    if nearestPrompt then
                        fireproximityprompt(nearestPrompt)
                    end
        
    end
end

task.wait(0.5)

-- 4. Collect NewRemote and use it on train for Purple Key

for _, remote in ipairs(workspace.ItemFolder1:GetChildren()) do
    if remote.Name == "NewRemote" and remote:FindFirstChildOfClass("ProximityPrompt") then
        hrp.CFrame = remote.CFrame
        task.wait(0.25)

        local prompt = remote:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.Enabled then
            fireproximityprompt(prompt)
        end

        task.wait(0.5)
end
end


for _, train in ipairs(workspace:GetDescendants()) do
    local trainPrompt = train:FindFirstChildOfClass("ProximityPrompt")
    
    if trainPrompt and trainPrompt.ObjectText == "Purple Key" then
        repeat
            hrp.CFrame = train.CFrame
            equipAllTools()
            task.wait(0.1)
            fireproximityprompt(trainPrompt)
            -- Update trainPrompt to check if it still exists
            trainPrompt = train:FindFirstChildOfClass("ProximityPrompt")
            
        until not trainPrompt
        
        break  -- Stop searching after processing one train
    end
end

task.wait(0.5)
hrp.CFrame = FINAL_POSITION
equipAllTools()
task.wait(0.5)
local nearestPrompt = getNearestProximityPrompt(8)
                    if nearestPrompt then
                        fireproximityprompt(nearestPrompt)
                    end

task.wait(0.8)

-- === FIXED BUCKET COLLECTION - SEARCHES ENTIRE MANSION FOR HINT DECALS ===
local itemFolder = workspace:FindFirstChild("ItemFolder1")
if not itemFolder then 
WindUI:Notify({
    Title = "Critical Error!",
    Content = "Did Not Find ItemFolder In Workspace.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
    return 
end

local bucketMap = {
    ["http://www.roblox.com/asset/?id=11322784427"]   = "SunsetBucket",
    ["http://www.roblox.com/asset/?id=11322783630"] = "DayBucket",
    ["http://www.roblox.com/asset/?id=11322784984"]   = "NightBucket",
}

local bucketReturnPos = CFrame.new(616.467712, -30.5207119, 1379.02979, 
    0.999459565, 3.12556381e-08, 0.0328713916, 
    -2.80830363e-08, 1, -9.69772174e-08, 
    -0.0328713916, 9.60016848e-08, 0.999459565)

local collectedBuckets = {}

local maxAttempts = 10
local attempt = 1
repeat
    local collectedAnyThisLoop = false

    -- Search ENTIRE mansion for visible hint decals
    for _, decal in ipairs(mansion:GetDescendants()) do
        if decal:IsA("Decal") and decal.Transparency == 0 then
            local bucketName = bucketMap[decal.Texture]
for _, father in ipairs(decal.Parent:GetDescendants()) do
if father:IsA("Decal") and father.Texture == "http://www.roblox.com/asset/?id=11322796499" then
            if bucketName and not collectedBuckets[bucketName] and father then
                local bucket = itemFolder:FindFirstChild(bucketName)
                if bucket and bucket:FindFirstChildOfClass("ProximityPrompt") then
                    collectedAnyThisLoop = true
                    collectedBuckets[bucketName] = true

                    -- Collect bucket
                    hrp.CFrame = bucket.CFrame * CFrame.new(0, 4, 0)
                    task.wait(0.3)
                    local prompt = bucket:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        fireproximityprompt(prompt)
                    end
                    task.wait(0.3)

                    -- Go to placement area & place
                    hrp.CFrame = bucketReturnPos
                    task.wait(0.3)
                    local nearestPrompt = getNearestProximityPrompt(8)
                    if nearestPrompt then
                        fireproximityprompt(nearestPrompt)
                    end
                    task.wait(0.3)
                end
            end
        end
        end
end
end

    if collectedAnyThisLoop then
        task.wait(0.5)  -- Wait for next hint/update
        attempt = attempt + 1
    end

until not collectedAnyThisLoop or attempt >= maxAttempts or next(collectedBuckets) and #collectedBuckets == 3

task.wait(0.5)

local bucketMap = {
    ["http://www.roblox.com/asset/?id=11322784427"]   = "SunsetBucket",
    ["http://www.roblox.com/asset/?id=11322783630"] = "DayBucket",
    ["http://www.roblox.com/asset/?id=11322784984"]   = "NightBucket",
}

local bucketReturnPos = CFrame.new(610.872681, -30.5207119, 1378.66833, 0.388001114, 8.01267106e-08, 0.921658874, -4.37941274e-08, 1, -6.85009809e-08, -0.921658874, -1.37847893e-08, 0.388001114)

local collectedBuckets = {}

local maxAttempts = 10
local attempt = 1
repeat
    local collectedAnyThisLoop = false

    -- Search ENTIRE mansion for visible hint decals
    for _, decal in ipairs(mansion:GetDescendants()) do
        if decal:IsA("Decal") and decal.Transparency == 0 then
            local bucketName = bucketMap[decal.Texture]
for _, son in ipairs(decal.Parent:GetDescendants()) do
if son:IsA("Decal") and son.Texture == "http://www.roblox.com/asset/?id=11322797772" then
            if bucketName and not collectedBuckets[bucketName] and son then
                local bucket = itemFolder:FindFirstChild(bucketName)
                if bucket and bucket:FindFirstChildOfClass("ProximityPrompt") then
                    collectedAnyThisLoop = true
                    collectedBuckets[bucketName] = true

                    -- Collect bucket
                    hrp.CFrame = bucket.CFrame * CFrame.new(0, 4, 0)
                    task.wait(0.3)
                    local prompt = bucket:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        fireproximityprompt(prompt)
                    end
                    task.wait(0.3)

                    -- Go to placement area & place
                    hrp.CFrame = bucketReturnPos
                    task.wait(0.3)
                    local nearestPrompt = getNearestProximityPrompt(8)
                    if nearestPrompt then
                        fireproximityprompt(nearestPrompt)
                    end
                    task.wait(0.3)
                end
            end
        end
        end
end
end

    if collectedAnyThisLoop then
        task.wait(0.5)  -- Wait for next hint/update
        attempt = attempt + 1
    end

until not collectedAnyThisLoop or attempt >= maxAttempts or next(collectedBuckets) and #collectedBuckets == 3

task.wait(0.5)

local bucketMap = {
    ["http://www.roblox.com/asset/?id=11322784427"]   = "SunsetBucket",
    ["http://www.roblox.com/asset/?id=11322783630"] = "DayBucket",
    ["http://www.roblox.com/asset/?id=11322784984"]   = "NightBucket",
}

local bucketReturnPos = CFrame.new(620.385254, -30.5207119, 1379.41003, 0.310287714, 4.92113628e-10, -0.950642705, 1.38541711e-08, 1, 5.03963538e-09, 0.950642705, -1.47341037e-08, 0.310287714)

local collectedBuckets = {}

local maxAttempts = 10
local attempt = 1
repeat
    local collectedAnyThisLoop = false

    -- Search ENTIRE mansion for visible hint decals
    for _, decal in ipairs(mansion:GetDescendants()) do
        if decal:IsA("Decal") and decal.Transparency == 0 then
            local bucketName = bucketMap[decal.Texture]
for _, mother in ipairs(decal.Parent:GetDescendants()) do
if mother:IsA("Decal") and mother.Texture == "http://www.roblox.com/asset/?id=11322797344" then
            if bucketName and not collectedBuckets[bucketName] and mother then
                local bucket = itemFolder:FindFirstChild(bucketName)
                if bucket and bucket:FindFirstChildOfClass("ProximityPrompt") then
                    collectedAnyThisLoop = true
                    collectedBuckets[bucketName] = true

                    -- Collect bucket
                    hrp.CFrame = bucket.CFrame * CFrame.new(0, 4, 0)
                    task.wait(0.3)
                    local prompt = bucket:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        fireproximityprompt(prompt)
                    end
                    task.wait(0.3)

                    -- Go to placement area & place
                    hrp.CFrame = bucketReturnPos
                    task.wait(0.3)
                    local nearestPrompt = getNearestProximityPrompt(8)
                    if nearestPrompt then
                        fireproximityprompt(nearestPrompt)
                    end
                    task.wait(0.3)
                end
            end
        end
        end
end
end

    if collectedAnyThisLoop then
        task.wait(0.5)  -- Wait for next hint/update
        attempt = attempt + 1
    end

until not collectedAnyThisLoop or attempt >= maxAttempts or next(collectedBuckets) and #collectedBuckets == 3

wait(0.8)

for _, white in ipairs(workspace.ItemFolder1:GetChildren()) do
    if white.Name:find("%d") then
        local keyPrompt = white:FindFirstChildOfClass("ProximityPrompt")
        if keyPrompt then
            hrp.CFrame = white.CFrame
            task.wait(0.3)
            fireproximityprompt(keyPrompt)
        end
    end
end

wait(0.5)
hrp.CFrame = CFrame.new(495.255341, -8.43988228, 1399.3689, 0.0466635972, -0.0850504413, 0.995283365, 2.16236806e-10, 0.996368706, 0.0851431936, -0.998910666, -0.0039730873, 0.0464941487)

equipAllTools()
task.wait(0.5)
local nearestPrompt = getNearestProximityPrompt(18)
                    if nearestPrompt then
                        fireproximityprompt(nearestPrompt)
                    end
                    
WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})

task.wait(7)
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOff.MouseButton1Click)

else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Mansion Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
end
})

SectionMa:Button({
    Title = "Get Bela Skin",
    Desc = "Automatically Gets The Skin For You (Auto Picks Up Books, Pick Up An Item If There Isn't Any Books)",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Mansion") then
local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local ocf = hrp.CFrame
local character = player.Character or player.CharacterAdded:Wait()

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

local function equipAllTools()
    for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = Game.Players.LocalPlayer.Character
        end
    end
end

local function FireNearest(maxDistance)
    maxDistance = maxDistance or 20
    if not hrp then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local position = nil

            if obj.Parent:IsA("BasePart") then
                position = obj.Parent.Position
            elseif obj.Parent:IsA("Attachment") and obj.Parent.Parent:IsA("BasePart") then
                position = obj.Parent.WorldPosition
            elseif obj.Parent:IsA("Model") and obj.Parent.PrimaryPart then
                position = obj.Parent.PrimaryPart.Position
            end

            if position then
                local dist = (hrp.Position - position).Magnitude
                if dist < maxDistance then
                    fireproximityprompt(obj)
                end
            end
        end
        
        if obj:IsA("ClickDetector") then
            local part = obj.Parent
            if part:IsA("BasePart") then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < maxDistance then
                    fireclickdetector(obj)
                end
            end
        end
        
        if obj:IsA("TouchTransmitter") then
            local part = obj.Parent
            if part:IsA("BasePart") then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < maxDistance then
                    firetouchinterest(hrp, part, 0)
                end
            end
        end
    end
end

if workspace:FindFirstChild("ItemFolder1"):FindFirstChild("NewBook") then
local b = workspace:FindFirstChild("ItemFolder1"):FindFirstChild("NewBook")
hrp.CFrame = b.CFrame
task.wait(0.5)
fireproximityprompt(b:FindFirstChildOfClass("ProximityPrompt"))
task.wait(0.2)
	equipAllTools()
elseif game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
else
WindUI:Notify({
    Title = "There Isn't Any Books And You Dont Have A Item In Your Inventory",
    Content = "Please Pick Up An Item.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
return
end

local cfs = {
	{512.697937, -11.6247759, 1344.34155, 0.702151835, 7.43408179e-09, 0.712027192, 6.03828312e-08, 1, -6.99860934e-08, -0.712027192, 9.21350818e-08, 0.702151835},
	{551.30957, -12.3799887, 1413.76233, -1, 0, 0, 0, 1, 0, 0, 0, -1},
	{566.163452, -12.3799887, 1387.49158, 0, 0, -1, 0, 1, 0, 1, 0, 0},
	{550.43866, -12.4799891, 1455.90833, 0, 0, 1, 0, 1, -0, -1, 0, 0},
	{664.509583, -12.4799891, 1461.26233, -1, 0, 0, 0, 1, 0, 0, 0, -1},
	{544.738708, 11.2200127, 1363.50842, 0, 0, 1, 0, 1, -0, -1, 0, 0}
}

for _, cf in ipairs(cfs) do
	hrp.CFrame = CFrame.new(unpack(cf)) - CFrame.new(unpack(cf)).LookVector * 1 + Vector3.new(0, 4, 0)
	task.wait(1.3)
FireNearest(10)
end

repeat
if not workspace:FindFirstChild("PiggyNPC"):FindFirstChild("DuocaraBot") then
task.wait(0.5)
end
until workspace:FindFirstChild("PiggyNPC"):FindFirstChild("DuocaraBot")

hrp.CFrame = CFrame.new(625.309021, -28.3566647, 1370.85303, -0.897381186, 2.48783394e-09, -0.441256136, -1.50523871e-09, 1, 8.69927153e-09, 0.441256136, 8.47075832e-09, -0.897381186)
task.wait(0.3)
for i = 1, 7 do
FireNearest(10)
end

task.wait(4.3)

for  _, black in ipairs(workspace:GetDescendants()) do
    if black:IsA("ProximityPrompt") and black.ObjectText == "Black Key" and black.Enabled == true then
local keyPart = black.Parent
hrp.CFrame = keyPart.CFrame - keyPart.CFrame.LookVector * 6
task.wait(0.2)
fireproximityprompt(black)
end
end

task.wait(0.5)

equipAllTools()
hrp.CFrame = CFrame.new(531.681335, -30.5207119, 1397.29187, -0.999721646, 4.86272391e-08, -0.0235936847, 5.06432691e-08, 1, -8.48503916e-08, 0.0235936847, -8.60216289e-08, -0.999721646)
task.wait(0.3)
FireNearest(8)
task.wait(1)
hrp.CFrame = CFrame.new(542.584412, -30.5207119, 1422.54419, -0.773738503, -1.13889573e-08, -0.633505106, -5.06726856e-08, 1, 4.39119603e-08, 0.633505106, 6.60777815e-08, -0.773738503)
task.wait(0.3)
FireNearest(10)

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})

task.wait(0.2)
hrp.CFrame = ocf
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect The Mansion Map.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionP = Tab4:Section({ 
    Title = "PIGGY.EXE",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionP:Button({
    Title = "Teleport To PIGGY.EXE HouseHold",
    Desc = "Teleports You To The Game You Need To Be In For The Skin",
    Locked = false,
    Callback = function()
game:GetService("TeleportService"):Teleport(17687435907, game.Players.LocalPlayer)
    end
})

SectionP:Button({
    Title = "Auto Win",
    Desc = "Automatically Wins The Game For You",
    Locked = false,
    Callback = function()
for _, key in ipairs(workspace:FindFirstChild("ItemFolder1"):GetChildren()) do
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = key.CFrame
task.wait(0.15)
fireclickdetector(key:FindFirstChildOfClass("ClickDetector"))
task.wait(0.25)
end

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(184.999969, 17.5, -98, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    end
})

local Sectiond = Tab4:Section({ 
    Title = "Decay",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

Sectiond:Button({
    Title = "Auto Win",
    Desc = "Automatically Wins The Decay Chapter For You",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("Bunny") then

if workspace.ItemFolder1:FindFirstChild("Crossbow") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.ItemFolder1:FindFirstChild("Crossbow").CFrame
task.wait(0.3)
game.Workspace.Camera.CFrame = CFrame.new(-17.5978546, 20.7734413, -11.4083443, -0.0565070398, 0.983234167, -0.173371151, -6.55190693e-11, 0.173648611, 0.98480773, 0.998402178, 0.055648569, -0.00981236901)
task.wait(0.5)
fireproximityprompt(workspace.ItemFolder1.Crossbow.ProximityPrompt)
end

task.wait(0.5)

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.ItemFolder1.TunnelKey.CFrame
task.wait(0.3)
game.workspace.Camera.CFrame = CFrame.new(370.59024, 41.4733772, 322.722961, 0.0808440596, 0.981584132, -0.173080161, -6.80299287e-24, 0.173648551, 0.98480773, 0.996726692, -0.0796158537, 0.0140384557)
wait(0.2)
fireproximityprompt(workspace.ItemFolder1.TunnelKey.ProximityPrompt)
task.wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(592.935913, 38.9809723, 112.740211, -0.99998796, -4.76643125e-09, 0.00490529137, -4.89171414e-09, 1, -2.5528438e-08, -0.00490529137, -2.55521257e-08, -0.99998796)
task.wait(0.1)
game.workspace.Camera.CFrame = CFrame.new(593.119568, 41.0125885, 112.37867, -0.999999821, 4.47275634e-05, -0.000705932674, -6.73980442e-22, 0.997998893, 0.0632327348, 0.000707348227, 0.0632327199, -0.997998595)
task.wait(0.2)
fireproximityprompt(workspace.Bunny.Events.Chase1Event.Doors_Tunnel.KeyDoor.DoorMain.PromptAttachment.DoorPrompt)
task.wait(0.3)
firetouchinterest(workspace.Bunny.Events.Chase1Event.SafeTrigger, Game.Players.LocalPlayer.Character.HumanoidRootPart, 0)

task.wait(0.5)

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1140.14856, 53.663517, 414.272217, 0.999653816, 0.0122360205, -0.0232919808, 4.1359488e-15, 0.885276914, 0.465064198, 0.0263103899, -0.464903206, 0.884970486)
task.wait(0.1)
game.workspace.Camera.CFrame = CFrame.new(1140.16016, 51.4309845, 413.829742, 0.999261856, 5.54945672e-08, 0.0384151936, -5.5715919e-08, 1, 4.69146011e-09, -0.0384151936, -6.82833523e-09, 0.999261856)
task.wait(0.2)
local args = {
	CFrame.new(1139.7205810546875, 52.92449188232422, 415.3273010253906, 0.9938197135925293, 0.012246896512806416, -0.11032890528440475, 0.04052341729402542, 0.8852769136428833, 0.4632953405380249, 0.10334556549787521, -0.4649029076099396, 0.879309356212616),
	vector.create(1140.276611328125, 51.09606170654297, 409.3949890136719),
	Instance.new("Part", nil),
	CFrame.new(1139.9083251953125, 50.60262680053711, 409.29498291015625, 0.965938925743103, -0.0000016689300537109375, 0.2587701976299286, 0.2587701976299286, 0.000012755393981933594, -0.9659388661384583, -0.0000016689300537109375, 0.9999999403953552, 0.000012755393981933594)
}
game:GetService("Players").LocalPlayer.Character:WaitForChild("Crossbow"):WaitForChild("FireRemote"):FireServer(unpack(args))
task.wait(0.4)
fireproximityprompt(workspace.Bunny.Events.Boarded_EscapeVent_Doors.Vent_Door.VentCover.PromptAttachment.DoorPrompt)
task.wait(0.2)
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.GameGUI.CrouchButton.MouseButton1Click)
task.wait(0.1)
game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1139.97217, 51.5109863, 384.531708))
task.wait(1.5)
firetouchinterest(workspace.Bunny.Events.EscapeTrigger, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect You In Decay",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local SectionD = Tab4:Section({ 
    Title = "Delirium",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionD:Button({
    Title = "Auto Win (Buggy)",
    Desc = "Automatically Wins The Delirium Chapter For You (Expect Bugs)",
    Locked = false,
    Callback = function()
if workspace:FindFirstChild("LoadedMap"):FindFirstChild("ForestPart1") then
local part = Instance.new("Part")
part.Parent = workspace
part.Size = Vector3.new(10, 1.5, 10)
part.Anchored = true
part.CFrame = CFrame.new(-300.542755, 249.32283, -594.703308, 0.0289156679, 0.00423026737, -0.999572933, -8.49587559e-06, 0.999991059, 0.00423179148, 0.999581873, -0.000113872826, 0.0289154463)
local root = game.Players.LocalPlayer.Character.HumanoidRootPart
root.CFrame = part.CFrame + Vector3.new(0, part.Size.Y/2 + root.Size.Y/2, 0)
task.wait(0.5)
firetouchinterest(workspace.Bunny.Events.ApparitionChase.OpenTrigger, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
task.wait(0.5)
firetouchinterest(workspace.Bunny.Events.ApparitionChase.EscapeTrigger, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)

task.wait(4)

local part2 = Instance.new("Part")
part2.Parent = game.workspace
part2.CFrame = CFrame.new(-775.366333, 483.500732, -915.616333, 1, 0, 0, 0, 1, 0, 0, 0, 1)
part2.Size = Vector3.new(10, 1.5, 10)
part2.Anchored = true
task.wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part2.CFrame
task.wait(5)
firetouchinterest(workspace.Bunny.Events.HandChase1Event.SafeTrigger, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
task.wait(0.1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-447.220734, 474.880585, -1669.40247, 0.999161124, 0.00455833133, -0.0406977534, -3.51645781e-07, 0.993786871, 0.111299962, 0.0409522355, -0.111206576, 0.992953181)
task.wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Bunny.Events.FinalEvent.StartTrigger.CFrame

task.wait(1.8)

workspace.Bunny.Events.CageFolder.BotFolder:Remove()
getgenv().Clicker = true

coroutine.wrap(function()
    while getgenv().Clicker do
        for _, app in ipairs(workspace.ApparitionNPC:GetDescendants()) do
            if app.Name == "Apparition" then
                root.CFrame = app.HumanoidRootPart.CFrame
                workspace.Camera.CFrame = app.UpperTorso.CFrame
            end
        end
        wait(1)
    end
end)()

getgenv().Clicker2 = true
while Clicker2 == true do
    local character = game.Players.LocalPlayer and game.Players.LocalPlayer.Character
    if not character or not game.Players.LocalPlayer:FindFirstChild("Sound") or game:GetService("Players").LocalPlayer.PlayerGui.GameGUI.MobileShootButton.Visible == false or workspace:FindFirstChild("CutsceneFolder") then
        getgenv().Clicker2 = false
        break
    end

                local button = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("GameGUI"):FindFirstChild("MobileShootButton")
                if button then
                    firesignal(button.MouseButton1Down)
                end
    wait(0.7)
end

WindUI:Notify({
    Title = "Check Your Inventory",
    Content = "The Script Has Successfully Finished And Gave You The Skin.",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
else
WindUI:Notify({
    Title = "Wrong Map!",
    Content = "The Script Did Not Detect You In Delirium",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
    end
})

local Button = Tab5:Button({
    Title = "Farm Tool",
    Desc = "The Best Farming Feature You Can Have. (Check Tutorial In Totallynothimplayz Channel If You Dont Know How To Use)",
    Locked = false,
    Callback = function()
WindUI:Notify({
    Title = "Important Note.",
    Content = "You Need A Alt In-Game For It Not To End The Round And Choose Swarm And Heist For Best Results It Auto Turns On Hard mode",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
        
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        -- Declare variables at the top
        local target = nil
        local isActivated = false
        local highlightTool = nil
        local confirmButton = nil
        
        -- Create highlight tool
        highlightTool = Instance.new("Tool")
        highlightTool.Name = "Farm Tool"
        highlightTool.ToolTip = "Click the door (must be unlocked) then press Confirm"
        highlightTool.RequiresHandle = false
        
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        local currentHighlightedPart = nil
        
        local function cleanupHighlight()
            if currentHighlightedPart and currentHighlightedPart:FindFirstChildOfClass("Highlight") then
                currentHighlightedPart:FindFirstChildOfClass("Highlight"):Destroy()
            end
            currentHighlightedPart = nil
        end
        
        local function highlightPart(part)
            cleanupHighlight()
            
            if part and not isActivated then
                local newHighlight = highlight:Clone()
                newHighlight.Parent = part
                currentHighlightedPart = part
            end
        end
        
        highlightTool.Activated:Connect(function()
            if isActivated then return end
            
            local mouse = player:GetMouse()
            target = mouse.Target
            
            if target and confirmButton then
                highlightPart(target)
                confirmButton.Visible = true
            end
        end)
        
        highlightTool.Unequipped:Connect(function()
            cleanupHighlight()
        end)
        
        -- Create UI
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FarmControls"
        screenGui.Parent = player:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        
        confirmButton = Instance.new("TextButton")
        confirmButton.Name = "Confirm"
        confirmButton.Text = "Confirm Door"
        confirmButton.Size = UDim2.new(0, 120, 0, 40)
        confirmButton.BackgroundColor3 = Color3.new(0, 1, 0)
        confirmButton.Position = UDim2.new(1, -130, 1, -50)
        confirmButton.AnchorPoint = Vector2.new(1, 1)
        confirmButton.Visible = false
        confirmButton.Parent = screenGui
        
        confirmButton.MouseButton1Click:Connect(function()
            if target and not isActivated then
                -- Start farming
                isActivated = true
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOn.MouseButton1Click)
                confirmButton.Text = "Stop"
                confirmButton.BackgroundColor3 = Color3.new(1, 0, 0)
                
                getgenv().Clicker = true
                
                -- Farming loop
                spawn(function()
                    while getgenv().Clicker do
                        player.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame
                        task.wait(0.5)
                        
                        -- Skip button
                        if game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Skip then
                            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Skip.MouseButton1Click)
                        end
                        
                        -- Join game
                        local args = {true}
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("JoinGame"):InvokeServer(unpack(args))
                        
                        task.wait(1)
                    end
                end)
                
            elseif confirmButton.Text == "Stop" then
                -- Stop farming
                confirmButton.Visible = false
                _getgenv()Clicker = false
                firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainMenu.Title.SettingsMenu.HardModeOff.MouseButton1Click)
                isActivated = false
                confirmButton.Text = "Confirm Door"
                confirmButton.BackgroundColor3 = Color3.new(0, 1, 0)
                cleanupHighlight()
                highlightTool.Parent = nil
            end
        end)
        
        -- Add tool to backpack if character exists
        if player.Character then
            highlightTool.Parent = player:FindFirstChildOfClass("Backpack")
        end
    end
})

local Toggle = Tab5:Toggle({
    Title = "Auto Find Blueprints",
    Desc = "Auto Finds All Blueprints In The Map",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
        getgenv().Clicker = true

local meshIdsToCheck = {
    "http://www.roblox.com/asset/?id=60791940",
    "rbxassetid://60791940",
    "60791940" -- Sometimes just the number works
}

while Clicker do
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    local humanoidRootPart = character.HumanoidRootPart
    local found = false

    for _, child in ipairs(workspace:GetDescendants()) do
        
        if child:IsA("Part") then
            local clickDetector = child:FindFirstChildOfClass("ClickDetector")
            
            if clickDetector then
                for _, mesh in ipairs(child:GetChildren()) do
                    if mesh:IsA("SpecialMesh") then
                        for _, idFormat in ipairs(meshIdsToCheck) do
                            if tostring(mesh.MeshId):find(idFormat, 1, true) then
                                
                                local originalPos = humanoidRootPart.CFrame
                                humanoidRootPart.CFrame = child.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.2)
                                fireclickdetector(clickDetector)
                                task.wait(0.3)
                                humanoidRootPart.CFrame = originalPos
                                found = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    if found then
WindUI:Notify({
    Title = "Found!",
    Content = "Successfully Found All Blueprints",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
    end
    
    task.wait(2)
end
        else
getgenv().Clicker = false
        end
    end
})

local Toggle = Tab5:Toggle({
    Title = "Auto Find Pages",
    Desc = "Auto Finds All Pages On The Map",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
        getgenv().Clicker = true
while Clicker == true do
local targetMeshId = "rbxassetid://6714051581"
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local maxSize = Vector3.new(255, 255, 255)

local function searchForSpecialMesh()
    local descendants = workspace:GetDescendants()
    local foundAny = false
    
    for _, child in ipairs(descendants) do
        if child:IsA("Part") then
            local clickDetector = child:FindFirstChildOfClass("ClickDetector")
            local touchTransmitter = child:FindFirstChildOfClass("TouchTransmitter")
            
                for _, mesh in ipairs(child:GetChildren()) do
                    if mesh:IsA("SpecialMesh") and mesh.MeshId == targetMeshId then
                        foundAny = true
                        local originalCFrame = humanoidRootPart.CFrame
                        humanoidRootPart.CFrame = child.CFrame + Vector3.new(0, 3, 0)
                        wait(0.2)
                        fireclickdetector(clickDetector)
                        wait(0.3)
                        humanoidRootPart.CFrame = originalCFrame
                    end
                end
            end
        end

    return foundAny
end

if searchForSpecialMesh() then
WindUI:Notify({
    Title = "Found!",
    Content = "Successfully Found All Pages",
    Duration = 8, -- 3 seconds
    Icon = "lucide:house",
})
end
task.wait(2)
end
        else
            getgenv().Clicker = false
            end
    end
})

local SectionT = Tab5:Section({ 
    Title = "Teleports (Book 1)",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
    Opened = false,
})

SectionT:Button({
    Title = "Teleport To Piggy Lobby",
    Desc = "Teleports You To The Piggy Waiting Room",
    Locked = false,
    Callback = function()
Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-368.912445, -3.70697975, -88.2102509, -0.177849829, -6.23116847e-08, -0.984057665, 8.68930528e-08, 1, -7.90254475e-08, 0.984057665, -9.95624347e-08, -0.177849829)
    end
})

SectionT:Button({
    Title = "Teleport To Player Lobby",
    Desc = "Teleports You To The Dead Players Lobby",
    Locked = false,
    Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-462.430878, -26.8999672, -92.9122467, 0.958247006, -1.92621847e-08, 0.28594166, 4.32109672e-08, 1, -7.74444473e-08, -0.28594166, 8.65667289e-08, 0.958247006)
    end
})

SectionT:Button({
    Title = "Teleport To Main Menu",
    Desc = "Teleports You To The Main Menu Place",
    Locked = false,
    Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-458.074951, -9.62249565, 8.91219902, 0.998103261, 2.76764887e-08, -0.0615624413, -3.36117942e-08, 1, -9.53755759e-08, 0.0615624413, 9.72638929e-08, 0.998103261)
wait(0.1)
local rayOrigin = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local rayDirection = Vector3.new(0, -15, 0) -- 15 studs downward
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character} -- Ignore player's own parts
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart:IsA("Part") then
            if not hitPart.CanCollide then
                hitPart.CanCollide = true
            end
end
end
    end
})

local Button = Tab6:Button({
    Title = "Vote Heist",
    Desc = "Votes The Map Heist",
    Locked = false,
    Callback = function()
local args = {
[1] = "Map",
[2] = "Heist"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("NewVote"):FireServer(unpack(args))
    end
})

local Button = Tab6:Button({
    Title = "Vote Distraction",
    Desc = "Votes The Map Distraction",
    Locked = false,
    Callback = function()
local args = {
[1] = "Map",
[2] = "Distraction"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("NewVote"):FireServer(unpack(args))
    end
})

local Button = Tab10:Button({
    Title = "Build Mode Map Stealer",
    Desc = "Steal Everyone's Maps (You Can Find Your Json Files In Your Executor Workspace)",
    Locked = false,
    Callback = function()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService") -- Added for keybind toggle
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "BuildDataGUI_Pro"
screenGui.ResetOnSpawn = false

-- Helper for modern styling
local function styleElement(inst, radius, color)
    local corner = Instance.new("UICorner", inst)
    corner.CornerRadius = UDim.new(0, radius)
    
    if color then
        local stroke = Instance.new("UIStroke", inst)
        stroke.Thickness = 1.8
        stroke.Color = color
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0.5
    end
end

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
styleElement(mainFrame, 12, Color3.fromRGB(0, 170, 255))

-- 🟦 Classic Draggable Enabled
mainFrame.Active = true
mainFrame.Draggable = true

-- Toggle Button (Visual)
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 35)
toggleBtn.Position = UDim2.new(1, -110, 1, -45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
toggleBtn.Text = "Toggle Menu"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Draggable = true
styleElement(toggleBtn, 8, Color3.fromRGB(0, 170, 255))

-- Toggle Logic
local function toggleMenu()
    mainFrame.Visible = not mainFrame.Visible
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BUILD SYSTEM"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16

-- Tabs Container
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, -30, 0, 40)
tabFrame.Position = UDim2.new(0, 15, 0, 50)
tabFrame.BackgroundTransparency = 1

local saveTab = Instance.new("TextButton", tabFrame)
saveTab.Text = "💾 SAVE"
saveTab.Size = UDim2.new(0.48, 0, 1, 0)
saveTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
saveTab.TextColor3 = Color3.new(1, 1, 1)
saveTab.Font = Enum.Font.GothamBold
saveTab.TextSize = 14
styleElement(saveTab, 8)

local loadTab = saveTab:Clone()
loadTab.Parent = tabFrame
loadTab.Position = UDim2.new(0.52, 0, 0, 0)
loadTab.Text = "📦 LOAD"

-- Filename input
local fileNameBox = Instance.new("TextBox", mainFrame)
fileNameBox.PlaceholderText = "Filename (e.g. build.json)"
fileNameBox.Text = "BuildData.json"
fileNameBox.Size = UDim2.new(1, -30, 0, 35)
fileNameBox.Position = UDim2.new(0, 15, 0, 105)
fileNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
fileNameBox.TextColor3 = Color3.new(1, 1, 1)
fileNameBox.Font = Enum.Font.Gotham
fileNameBox.TextSize = 14
styleElement(fileNameBox, 6, Color3.new(1, 1, 1))

-- Action Button
local actionButton = Instance.new("TextButton", mainFrame)
actionButton.Size = UDim2.new(1, -30, 0, 60)
actionButton.Position = UDim2.new(0, 15, 0, 160)
actionButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
actionButton.TextColor3 = Color3.new(1, 1, 1)
actionButton.Text = "SAVE TO JSON"
actionButton.Font = Enum.Font.GothamBold
actionButton.TextSize = 18
styleElement(actionButton, 10)

-- Status Label
local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.new(0, 15, 0, 230)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "System Ready"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextTransparency = 0.3

--- FUNCTIONALITY ---

local isSaveMode = true

local function findBlockModel(name)
    local blocksMainFolder = ReplicatedStorage:WaitForChild("Blocks")
    for _, category in ipairs(blocksMainFolder:GetChildren()) do
        if category:IsA("Folder") then
            local model = category:FindFirstChild(name, true)
            if model and model:IsA("Model") then return model end
            for _, subfolder in ipairs(category:GetChildren()) do
                if subfolder.Name == name and subfolder:IsA("Folder") then
                    local nestedModel = subfolder:FindFirstChild(name)
                    if nestedModel and nestedModel:IsA("Model") then return nestedModel end
                end
            end
        end
    end
    return nil
end

local function setStatus(msg, color)
    statusLabel.Text = msg
    statusLabel.TextColor3 = color or Color3.new(1,1,1)
end

-- Tab Logic
saveTab.MouseButton1Click:Connect(function()
    isSaveMode = true
    saveTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    loadTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    actionButton.Text = "SAVE TO JSON"
    actionButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

loadTab.MouseButton1Click:Connect(function()
    isSaveMode = false
    loadTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    saveTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    actionButton.Text = "LOAD FROM JSON"
    actionButton.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
end)

-- Main Execution
actionButton.MouseButton1Click:Connect(function()
    local fileName = fileNameBox.Text or "BuildData.json"
    if not fileName:match("%.json$") then fileName = fileName .. ".json" end

    if isSaveMode then
        setStatus("Saving...", Color3.new(1, 1, 0))
        local build = workspace:WaitForChild("BuildModel")
        local data = {}

        for _, object in pairs(build:GetChildren()) do
            local part = object:FindFirstChild("Base") or object:FindFirstChild("ColorPart")
            if part and part:IsA("BasePart") then
                table.insert(data, {
                    Name = object.Name,
                    CFrame = { X = part.CFrame.X, Y = part.CFrame.Y, Z = part.CFrame.Z },
                    Material = part.Material.Name,
                    Color = part.BrickColor.Number,
                    Size = { X = part.Size.X, Y = part.Size.Y, Z = part.Size.Z },
                    Rotation = { X = part.Rotation.X, Y = part.Rotation.Y, Z = part.Rotation.Z }
                })
            end
        end

        local json = HttpService:JSONEncode(data)
        if writefile then
            writefile(fileName, json)
            setStatus("✅ Saved to " .. fileName, Color3.new(0, 1, 0))
        else
            setStatus("❌ writefile not supported", Color3.new(1, 0, 0))
        end
    else
        -- LOAD LOGIC
        setStatus("Loading...", Color3.new(1, 1, 0))
        local placeBlock = ReplicatedStorage:WaitForChild("Functions"):WaitForChild("PlaceBlock")
        local commitResize = ReplicatedStorage:WaitForChild("Functions"):WaitForChild("CommitResize")
        local buildModel = workspace:WaitForChild("BuildModel")
        local placedBlocks = {}

        if not readfile then setStatus("❌ readfile missing", Color3.new(1,0,0)) return end
        
        local success, jsonData = pcall(function() return readfile(fileName) end)
        if not success then setStatus("❌ File not found", Color3.new(1,0,0)) return end

        local blockData = HttpService:JSONDecode(jsonData)

        for _, entry in ipairs(blockData) do
            local cf = CFrame.new(entry.CFrame.X, entry.CFrame.Y, entry.CFrame.Z) *
                       CFrame.Angles(math.rad(entry.Rotation.X), math.rad(entry.Rotation.Y), math.rad(entry.Rotation.Z))

            local blockModel = findBlockModel(entry.Name)
            if not blockModel then continue end
            local material = Enum.Material[entry.Material] or Enum.Material.Plastic
            local brickColor = BrickColor.new(tonumber(entry.Color))

            local before = buildModel:GetChildren()
            local args = { blockModel, cf, brickColor, material }
            
            pcall(function() placeBlock:InvokeServer(unpack(args)) end)

            -- Tracking for Resize
            local currentChildren = buildModel:GetChildren()
            local newBlock = currentChildren[#currentChildren]
            if newBlock then
                table.insert(placedBlocks, {
                    instance = newBlock,
                    cf = cf,
                    size = Vector3.new(entry.Size.X, entry.Size.Y, entry.Size.Z)
                })
            end
        end

        task.wait(0.5)
        for _, info in ipairs(placedBlocks) do
            local part = info.instance:FindFirstChild("Base") or info.instance:FindFirstChild("ColorPart")
            if part then
                pcall(function() commitResize:InvokeServer(info.instance, { part, info.cf, info.size }) end)
            end
        end
        setStatus("✅ Load Complete!", Color3.new(0, 1, 0))
    end
end)
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Teleported = false
local LastSelected = ""

local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local Dropdown = Tab11:Dropdown({
    Title = "Teleport to Player",
    Desc = "Select a player to teleport to",
    Values = GetPlayerNames(),
    Value = "",
    Multi = false,
    AllowNone = true,
    Callback = function(selectedName)
        if not selectedName or selectedName == "" then return end
        if Teleported and selectedName == LastSelected then return end

        local targetPlayer = Players:FindFirstChild(selectedName)
        if not targetPlayer then return end

        local targetChar = targetPlayer.Character
        local localChar = LocalPlayer.Character

        if not targetChar or not localChar then return end

        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")

        if targetRoot and localRoot then
            Teleported = true
            LastSelected = selectedName
            localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            task.delay(1, function()
                Teleported = false
            end)
        end
    end
})

Players.PlayerAdded:Connect(function()
    Dropdown:Refresh(GetPlayerNames())
end)

Players.PlayerRemoving:Connect(function()
    Dropdown:Refresh(GetPlayerNames())
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer and LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local IsOnMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local V3_ZERO = Vector3.new(0, 0, 0)
local V3_INF = Vector3.new(9e9, 9e9, 9e9)
local V3_NONE = Vector3.new()
local CAM_TRACK = Enum.CameraType.Track
local CAM_CUSTOM = Enum.CameraType.Custom

local velocityHandlerName = "VelocityHandler"
local gyroHandlerName = "GyroHandler"

iyflyspeed = 1
getgenv().FLYING = false

local flyKeyDown, flyKeyUp, mfly1, mfly2

local function getRoot(char)
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getHumanoid(char)
	return char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildWhichIsA("Humanoid")
end

local function setPlatformStand(state)
	local hum = getHumanoid(LocalPlayer.Character)
	if hum then
		hum.PlatformStand = state
	end
end

local function disconnectKeys()
	if flyKeyDown then
		flyKeyDown:Disconnect()
	end
	if flyKeyUp then
		flyKeyUp:Disconnect()
	end
end

local function disconnectMobile()
	if mfly1 then
		mfly1:Disconnect()
	end
	if mfly2 then
		mfly2:Disconnect()
	end
end

local function safeDestroy(inst)
	if inst and inst.Destroy then
		inst:Destroy()
	end
end

local function safeDisconnect(conn)
	if conn and conn.Disconnect then
		conn:Disconnect()
	end
end

local function waitForCharacter(plr)
	if not plr then
		return nil
	end
	local char = plr.Character
	if not char then
		char = plr.CharacterAdded:Wait()
	end
	return char
end

local function waitForRoot(char)
	if not char then
		return nil
	end
	local root = getRoot(char)
	if root then
		return root
	end
	return char:WaitForChild("HumanoidRootPart", 5)
		or char:WaitForChild("Torso", 5)
		or char:WaitForChild("UpperTorso", 5)
end

local function newBodyVelocity(parent)
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = parent
	bv.MaxForce = V3_ZERO
	bv.Velocity = V3_ZERO
	return bv
end

local function newBodyGyro(parent)
	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = parent
	bg.MaxTorque = V3_INF
	bg.P = 1000
	bg.D = 50
	return bg
end

local function sFLY(vfly)
	local char = waitForCharacter(LocalPlayer)
	repeat
		task.wait()
	until char and getRoot(char) and getHumanoid(char)

	disconnectKeys()

	local T = getRoot(char)
	local CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
	local lCON = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
	local SPEED = 0

	local function FLY()
		getgenv().FLYING = true
		local BG = Instance.new("BodyGyro")
		local BV = Instance.new("BodyVelocity")
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.MaxTorque = V3_INF
		BG.CFrame = T.CFrame
		BV.Velocity = V3_ZERO
		BV.MaxForce = V3_INF

		task.spawn(function()
			repeat
				task.wait()
				if not T or not T.Parent or not LocalPlayer or not LocalPlayer.Character then
					getgenv().FLYING = false
					break
				end
				if not vfly then
					setPlatformStand(true)
				end

				local moving = CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0

				SPEED = moving and 50 or 0

				if moving then
					BV.Velocity = (
						(Camera.CFrame.LookVector * (CONTROL.F + CONTROL.B))
						+ (
							(Camera.CFrame * CFrame.new(
								CONTROL.L + CONTROL.R,
								(CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2,
								0
							)).Position - Camera.CFrame.Position
						)
					) * SPEED
					lCON = { F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R }
				elseif SPEED ~= 0 then
					BV.Velocity = (
						(Camera.CFrame.LookVector * (lCON.F + lCON.B))
						+ (
							(Camera.CFrame * CFrame.new(
								lCON.L + lCON.R,
								(lCON.F + lCON.B + CONTROL.Q + CONTROL.E) * 0.2,
								0
							)).Position - Camera.CFrame.Position
						)
					) * SPEED
				else
					BV.Velocity = V3_ZERO
				end
				Camera = workspace.CurrentCamera
				if Camera then
					BG.CFrame = Camera.CFrame
				end
			until not getgenv().FLYING

			CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
			lCON = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
			SPEED = 0
			safeDestroy(BG)
			safeDestroy(BV)
			setPlatformStand(false)
		end)
	end

	if not mouse then
		return
	end

	flyKeyDown = mouse.KeyDown:Connect(function(KEY)
		local k = KEY:lower()
		if k == "w" then
			CONTROL.F = iyflyspeed
		elseif k == "s" then
			CONTROL.B = -iyflyspeed
		elseif k == "a" then
			CONTROL.L = -iyflyspeed
		elseif k == "d" then
			CONTROL.R = iyflyspeed
		elseif k == "e" then
			CONTROL.Q = iyflyspeed * 2
		elseif k == "q" then
			CONTROL.E = -iyflyspeed * 2
		end
		pcall(function()
			Camera.CameraType = CAM_TRACK
		end)
	end)

	flyKeyUp = mouse.KeyUp:Connect(function(KEY)
		local k = KEY:lower()
		if k == "w" then
			CONTROL.F = 0
		elseif k == "s" then
			CONTROL.B = 0
		elseif k == "a" then
			CONTROL.L = 0
		elseif k == "d" then
			CONTROL.R = 0
		elseif k == "e" then
			CONTROL.Q = 0
		elseif k == "q" then
			CONTROL.E = 0
		end
	end)

	FLY()
end

local function NOFLY()
	getgenv().FLYING = false
	disconnectKeys()
	disconnectMobile()
	setPlatformStand(false)
	pcall(function()
		Camera.CameraType = CAM_CUSTOM
	end)
end

local function unmobilefly(speaker)
	pcall(function()
		getgenv().FLYING = false
		local root = speaker and speaker.Character and getRoot(speaker.Character)
		if root then
			safeDestroy(root:FindFirstChild(velocityHandlerName))
			safeDestroy(root:FindFirstChild(gyroHandlerName))
		end
		local hum = speaker and speaker.Character and getHumanoid(speaker.Character)
		if hum then
			hum.PlatformStand = false
		end
		disconnectMobile()
	end)
end

local function mobilefly(speaker, vfly)
	unmobilefly(speaker)
	getgenv().FLYING = true

	if not speaker then
		return
	end
	local char = waitForCharacter(speaker)
	local root = waitForRoot(char)
	if not root then
		return
	end

	local controlModule
	pcall(function()
		controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	end)
	if not controlModule then
		getgenv().FLYING = false
		return
	end

	newBodyVelocity(root)
	newBodyGyro(root)

	mfly1 = speaker.CharacterAdded:Connect(function()
		local newChar = waitForCharacter(speaker)
		root = waitForRoot(newChar)
		if root then
			newBodyVelocity(root)
			newBodyGyro(root)
		end
	end)

	mfly2 = RunService.RenderStepped:Connect(function()
		if not getgenv().FLYING then
			return
		end
		if not speaker.Character then
			return
		end

		root = getRoot(speaker.Character)
		Camera = workspace.CurrentCamera
		local hum = getHumanoid(speaker.Character)
		local bv = root and root:FindFirstChild(velocityHandlerName)
		local bg = root and root:FindFirstChild(gyroHandlerName)

		if hum and root and bv and bg and Camera then
			bv.MaxForce = V3_INF
			bg.MaxTorque = V3_INF
			if not vfly then
				hum.PlatformStand = true
			end
			bg.CFrame = Camera.CFrame
			bv.Velocity = V3_NONE

			local dir = controlModule.GetMoveVector and controlModule:GetMoveVector() or Vector3.new()
			local spd = iyflyspeed * 50
			if dir.X ~= 0 then
				bv.Velocity += Camera.CFrame.RightVector * (dir.X * spd)
			end
			if dir.Z ~= 0 then
				bv.Velocity -= Camera.CFrame.LookVector * (dir.Z * spd)
			end
		end
	end)
end

local Toggle = Tab11:Toggle({
    Title = "Fly",
    Desc = "Toggles Fly",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
		if Value then
			if not IsOnMobile then
				NOFLY()
				task.wait()
				sFLY()
			else
				mobilefly(LocalPlayer)
			end
		else
			if not IsOnMobile then
				NOFLY()
			else
				unmobilefly(LocalPlayer)
			end
		end
    end
})

local Toggle = Tab11:Toggle({
    Title = "Noclip",
    Desc = "Toggle's Noclip",
    Icon = nil,
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(Value) 
if Value then
getgenv().Clicker = true
    while getgenv().Clicker == true do
        for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = false
            end
        end
        task.wait(0.5)
    end
else
    getgenv().Clicker = false
    for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if (child.Name == "Torso" or child.name == "HumanoidRootPart" or child.Name == "CrouchBlocker") and child.CanCollide == false  then
            child.CanCollide = true
        end
    end
end
    end
})

local Input = Tab11:Input({
    Title = "Speed",
    Desc = "Input The Amount Of WalkSpeed You Want",
    Value = nil,
    InputIcon = "lucide:user",
    Type = "Input",
    Placeholder = "Input The Amount You Want",
    Callback = function(input)
        local amount = tonumber(input)
        if amount then
            getgenv().speedAmount = amount
        end
    end
})

local Toggle = Tab11:Toggle({
    Title = "Toggle Speed",
    Desc = "Toggle's The Player WalkSpeed",
    Icon = nil,
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        getgenv().w = Value
        if Value then
            task.spawn(function()
                while w do
                    local char = game.Players.LocalPlayer.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid and getgenv().speedAmount then
                        humanoid.WalkSpeed = getgenv().speedAmount
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})


local Input = Tab11:Input({
    Title = "Jump",
    Desc = "Input The Amount Of JumpPower You Want",
    Value = nil,
    InputIcon = "lucide:user",
    Type = "Input",
    Placeholder = "Input The Amount You Want",
    Callback = function(input)
        local amount = tonumber(input)
        if amount then
            getgenv().jumpAmount = amount
        end
    end
})

local Toggle = Tab11:Toggle({
    Title = "Toggle Jump",
    Desc = "Toggle's The Player JumpPower",
    Icon = nil,
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        getgenv().j = Value
        if Value then
            task.spawn(function()
                while j do
                    local char = game.Players.LocalPlayer.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid and getgenv().jumpAmount then
                        humanoid.JumpPower = getgenv().jumpAmount
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local Keybind = Tab7:Keybind({
    Title = "Keybind",
    Desc = "Keybind To Open Ui",
    Value = "V",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local Dropdown1 = Tab7:Dropdown({
    Title = "Ui Theme",
    Desc = "Choose Any Ui Theme You Like!",
    Values = { "Dracula", "Cyberpunk Purple", "Synthwave", "Forest", "Monochrome" },
    Value = "Dracula",
    Callback = function(option) 
WindUI:SetTheme(option)
    end
})

local Paragraph = Tab8:Paragraph({
    Title = "Made By Totallynothimplayz",
    Desc = "Script Owner, Script Maker",
    Color = "Green",
    Image = "rbxassetid://116404734406949",
    ImageSize = 50,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

local Button = Tab8:Button({
    Title = "My Discord",
    Desc = "Copies The Link To My Discord Server (Recommend Joining)",
    Locked = false,
    Callback = function()
toclipboard("https://discord.gg/7euCFTSPfz")
    end
})

local Button = Tab8:Button({
    Title = "My YT Channel",
    Desc = "Copies The Link To My Youtube Channel (Please Consider Subscribing)",
    Locked = false,
    Callback = function()
toclipboard("https://m.youtube.com/@Totallynothimplayz")
    end
})

local Button = Tab8:Button({
    Title = "My Scriptblox Account",
    Desc = "Copies The Link To My Scriptblox Account",
    Locked = false,
    Callback = function()
toclipboard("https://scriptblox.com/u/Totallynothimplayz")
    end
})

local Paragraph1 = Tab9:Paragraph({
    Title = "Updates Log",
    Desc = "Reworked Tools Gui And Unlocker And Reworked Control Piggy Bots And Did A Huge Fix For Lag Issues And Made Alot Of Functions Better",
    Color = nil,
    Image = "rbxassetid://126985084896106",
    ImageSize = 50,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})