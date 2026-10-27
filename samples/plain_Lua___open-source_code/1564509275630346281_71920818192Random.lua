-- Lua Land Backdoor Executor (Advanced Multi-Scan Logic) - FIXED VERSION
-- Developed By LLH Lua Land

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local TitleIcon = Instance.new("ImageLabel")
local Subtitle = Instance.new("TextLabel")
local SubtitleIcon = Instance.new("ImageLabel")
local CloseBtn = Instance.new("TextButton")
local Editor = Instance.new("ScrollingFrame")
local TextBox = Instance.new("TextBox")
local ExecuteBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")
local RespawnBtn = Instance.new("TextButton")
local ScriptPanel = Instance.new("ScrollingFrame")
local ScriptListLayout = Instance.new("UIListLayout")
local ScriptPanelTitle = Instance.new("TextLabel")
local ScriptPanelIcon = Instance.new("ImageLabel")
local StatusLabel = Instance.new("TextLabel")

-- GUI Core Setup
ScreenGui.Name = "LuaLandExecutor_v4_Fixed"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Active = true

-- Modern Dragging Script (Replaces deprecated .Draggable)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Header
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 40, 0, 5)
Title.Size = UDim2.new(0, 200, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Lua Land Backdoor Executor"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

TitleIcon.Parent = MainFrame
TitleIcon.BackgroundTransparency = 1
TitleIcon.Position = UDim2.new(0, 10, 0, 8)
TitleIcon.Size = UDim2.new(0, 22, 0, 22)
TitleIcon.Image = "rbxassetid://8997386861"

Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 40, 0, 25)
Subtitle.Size = UDim2.new(0, 200, 0, 20)
Subtitle.Font = Enum.Font.SourceSansItalic
Subtitle.Text = "Developed By LLH Lua Land"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.TextSize = 13
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

SubtitleIcon.Parent = MainFrame
SubtitleIcon.BackgroundTransparency = 1
SubtitleIcon.Position = UDim2.new(0, 18, 0, 28)
SubtitleIcon.Size = UDim2.new(0, 15, 0, 15)
SubtitleIcon.Image = "rbxassetid://7743876054"

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 4)

-- Editor
Editor.Parent = MainFrame
Editor.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Editor.Position = UDim2.new(0, 10, 0, 60)
Editor.Size = UDim2.new(0, 320, 0, 180)
Editor.CanvasSize = UDim2.new(0, 0, 5, 0)
Editor.ScrollBarThickness = 4
Editor.ClipsDescendants = true

TextBox.Parent = Editor
TextBox.Size = UDim2.new(1, 0, 1, 0)
TextBox.BackgroundTransparency = 1
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.Code
TextBox.PlaceholderText = "-- Developed By LLH Lua Land"
TextBox.Text = ""
TextBox.ClearTextOnFocus = false
TextBox.TextWrapped = true
TextBox.MultiLine = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top

local textPadding = Instance.new("UIPadding")
textPadding.Parent = TextBox
textPadding.PaddingLeft = UDim.new(0, 8)
textPadding.PaddingTop = UDim.new(0, 8)

-- Control Buttons
local function createButton(name, pos, text, iconId)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Position = pos
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "      " .. text 
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    
    local icon = Instance.new("ImageLabel")
    icon.Parent = btn
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 8, 0, 7)
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Image = iconId
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

ExecuteBtn = createButton("Execute", UDim2.new(0, 10, 0, 250), "Execute", "rbxassetid://7743871480")
ClearBtn = createButton("Clear", UDim2.new(0, 120, 0, 250), "Clear", "rbxassetid://7743873772")
RespawnBtn = createButton("Re", UDim2.new(0, 230, 0, 250), "Re", "rbxassetid://10709781605")

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 235)
StatusLabel.Size = UDim2.new(0, 320, 0, 15)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Scripts Panel
ScriptPanelTitle.Parent = MainFrame
ScriptPanelTitle.BackgroundTransparency = 1
ScriptPanelTitle.Position = UDim2.new(0, 345, 0, 60)
ScriptPanelTitle.Size = UDim2.new(0, 145, 0, 25)
ScriptPanelTitle.Font = Enum.Font.SourceSansBold
ScriptPanelTitle.Text = "          Scripts"
ScriptPanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptPanelTitle.TextSize = 18
ScriptPanelTitle.TextXAlignment = Enum.TextXAlignment.Left

ScriptPanelIcon.Parent = ScriptPanelTitle
ScriptPanelIcon.BackgroundTransparency = 1
ScriptPanelIcon.Position = UDim2.new(0, 5, 0, 2)
ScriptPanelIcon.Size = UDim2.new(0, 20, 0, 20)
ScriptPanelIcon.Image = "rbxassetid://10734943448"

ScriptPanel.Parent = MainFrame
ScriptPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ScriptPanel.Position = UDim2.new(0, 340, 0, 90)
ScriptPanel.Size = UDim2.new(0, 150, 0, 200)
ScriptPanel.CanvasSize = UDim2.new(0, 0, 0, 0) 
ScriptPanel.ScrollBarThickness = 2

ScriptListLayout.Parent = ScriptPanel
ScriptListLayout.Padding = UDim.new(0, 5)

-- Script Adder Function
local function addScript(name, code, isSpecial)
    local sBtn = Instance.new("TextButton")
    sBtn.Parent = ScriptPanel
    sBtn.Size = UDim2.new(1, -5, 0, 32)
    sBtn.BackgroundColor3 = isSpecial and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(45, 45, 45)
    sBtn.BackgroundTransparency = isSpecial and 0.4 or 0
    sBtn.Font = Enum.Font.SourceSans
    sBtn.Text = "            " .. name 
    sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sBtn.TextSize = 14
    sBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local sIcon = Instance.new("ImageLabel")
    sIcon.Parent = sBtn
    sIcon.BackgroundTransparency = 1
    sIcon.Position = UDim2.new(0, 8, 0, 6)
    sIcon.Size = UDim2.new(0, 20, 0, 20)
    sIcon.Image = "rbxassetid://7734010488"
    
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 4)

    sBtn.MouseButton1Click:Connect(function()
        local myName = game:GetService("Players").LocalPlayer.Name
        local finalCode = code:gsub("UserName", myName):gsub("username", myName)
        TextBox.Text = finalCode
    end)
    ScriptPanel.CanvasSize = UDim2.new(0, 0, 0, ScriptListLayout.AbsoluteContentSize.Y + 10)
end

-- Load Scripts
addScript("R6", 'require(3436957371):r6("UserName")', true)
addScript("Sans (R6)", 'require(4952709475).load("UserName")')
addScript("Gojo V1 (R6)", 'require(14499140823)("UserName","sorcerer")')
addScript("Gojo V2 (R6)", 'require(103408394508146).unlimited("UserName")')
addScript("Sukuna (R6)", 'require(89529616632600)("UserName","Sukuna")')
addScript("Ban Hammer (R6)", 'require(2953959989).load("UserName")')
addScript("Hokuto Shinken (R6)", 'require(2966795270):Fire("UserName")')
addScript("Parasite (R6)", 'require(17234454946).load("UserName")')
addScript("Excavator", 'require(17181083619)("UserName")')
addScript("Mustard Gas (R6)", 'require(2989312214).load("UserName")')
addScript("Building Tools", 'require(7518778955).ConstraintTools("UserName")')
addScript("Furry (R6)", 'require(6806052169).Furry("UserName")')
addScript("Flying Spaceship", 'require(4922372692).load("UserName")')
addScript("Super Bro (R6)", 'require(86206606847204).SoRetro("UserName")')
addScript("Veltex (R6)", 'require(6099316092).load("UserName")')
addScript("Asylum (R6)", 'require(4992512410):Asylumgotskidded("UserName")')
addScript("HD Admin Ranker", 'require(11560761226).HD("UserName")')
addScript("Caducus (R6)", 'require(5686002742):Fire("UserName","caducus")')
addScript("Kill Machine (R6)", 'require(6375409514).load("UserName")')
addScript("Gentleman killbot (R6)", 'require(5430831931).Dark("UserName")')
addScript("Goner (R6)", 'require(4513235536).G("UserName")')
addScript("Server Admin (R6)", 'require(4665394711).load("UserName")')
addScript("All Seeing Hand (R6)", 'require(5375399205).Player("UserName")')
addScript("Goku (R6)", 'require(7433042949)("UserName")')
addScript("Sensation Hub", 'require(100263845596551)("UserName", ColorSequence.new(Color3.fromRGB(71, 148, 253), Color3.fromRGB(71, 253, 160)), "Standard")')
addScript("Dark Dex", 'require(3010581956):Fireplace("UserName")')
addScript("Aureus V1", 'require(6036737823).CrackedByIncreaseron("UserName")')
addScript("Vascepa Hub", 'require(6009547419).Fire("UserName")')
addScript("UTG Edit", 'require(3497222070).load("UserName")')
addScript("Fire Hub", 'require(5098133040):FirePire("UserName")')
addScript("Anonymous UTG", 'require(5126648745).load("UserName")')
addScript("Glitch Hub Premium", 'require(5487274946).GLITCHED("UserName")')
addScript("Kurapika GUI V1", 'require(103091801389406).kurapikav1("UserName")')
addScript("Eggman GUI V2", 'require(93542145255151):LUX("UserName")')

-- SCANNING LOGIC
local function executeThroughBackdoors()
    local code = TextBox.Text
    local services = {game:GetService("ReplicatedStorage"), game:GetService("Lighting"), game:GetService("Workspace")}
    local foundAny = false
    
    StatusLabel.Text = "Status: Scanning for remotes..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    for _, service in ipairs(services) do
        for _, v in pairs(service:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                pcall(function()
                    v:FireServer(code)
                    foundAny = true
                end)
            end
        end
    end
    
    if foundAny then
        StatusLabel.Text = "Status: Backdoor Found! Executed."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "Status: Game not backdoor!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Connections
ExecuteBtn.MouseButton1Click:Connect(executeThroughBackdoors)
ClearBtn.MouseButton1Click:Connect(function() 
    TextBox.Text = "" 
    StatusLabel.Text = "Status: Static" 
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
RespawnBtn.MouseButton1Click:Connect(function() 
    local char = game:GetService("Players").LocalPlayer.Character
    if char then char:BreakJoints() end
end)