-- ==========================================
-- ADMIN HUB - STEAL AN EGG 🥚 KEY SYSTEM UI
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("AdminHubKeySystem") then
    CoreGui.AdminHubKeySystem:Destroy()
end

local CorrectKey = "WeroHub-77955B09F65G8551"
local Link4mURL = "https://link4m.net/P2fD4r"
local ScriptURL = "https://raw.githubusercontent.com/Wzeus-NTH/Wzeusno1/main/Wzeus/nthzz"

local AdminHubUI = Instance.new("ScreenGui")
AdminHubUI.Name = "AdminHubKeySystem"
AdminHubUI.ResetOnSpawn = false
AdminHubUI.Parent = CoreGui

-- Frame Chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = AdminHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 65)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Admin Hub-steal an egg 🥚 | Key System"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 215)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function()
    AdminHubUI:Destroy()
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 6)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

-- Content Container
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -130, 1, -40)
ContentArea.Position = UDim2.new(0, 125, 0, 35)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Page 1: Verify Key Page
local VerifyPage = Instance.new("Frame")
VerifyPage.Size = UDim2.new(1, 0, 1, 0)
VerifyPage.BackgroundTransparency = 1
VerifyPage.Visible = true
VerifyPage.Parent = ContentArea

local Page1Title = Instance.new("TextLabel")
Page1Title.Size = UDim2.new(1, 0, 0, 25)
Page1Title.BackgroundTransparency = 1
Page1Title.Text = "Verify Key"
Page1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Page1Title.TextSize = 22
Page1Title.Font = Enum.Font.SourceSansBold
Page1Title.TextXAlignment = Enum.TextXAlignment.Left
Page1Title.Parent = VerifyPage

local SectionLabel1 = Instance.new("TextLabel")
SectionLabel1.Size = UDim2.new(1, 0, 0, 20)
SectionLabel1.Position = UDim2.new(0, 0, 0, 28)
SectionLabel1.BackgroundTransparency = 1
SectionLabel1.Text = "Key Input"
SectionLabel1.TextColor3 = Color3.fromRGB(160, 160, 180)
SectionLabel1.TextSize = 13
SectionLabel1.Font = Enum.Font.SourceSansSemibold
SectionLabel1.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel1.Parent = VerifyPage

-- Input Frame
local InputBoxFrame = Instance.new("Frame")
InputBoxFrame.Size = UDim2.new(0.95, 0, 0, 42)
InputBoxFrame.Position = UDim2.new(0, 0, 0, 52)
InputBoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
InputBoxFrame.BorderSizePixel = 0
InputBoxFrame.Parent = VerifyPage

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputBoxFrame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(0.35, 0, 1, 0)
InputLabel.Position = UDim2.new(0, 10, 0, 0)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "Enter Key:"
InputLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
InputLabel.TextSize = 13
InputLabel.Font = Enum.Font.SourceSans
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = InputBoxFrame

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(0.6, -10, 0.7, 0)
KeyTextBox.Position = UDim2.new(0.38, 0, 0.15, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
KeyTextBox.Text = ""
KeyTextBox.PlaceholderText = "Paste key here..."
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
KeyTextBox.TextSize = 12
KeyTextBox.Font = Enum.Font.SourceSans
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.Parent = InputBoxFrame

local KeyTextCorner = Instance.new("UICorner")
KeyTextCorner.CornerRadius = UDim.new(0, 4)
KeyTextCorner.Parent = KeyTextBox

-- Check Key Button
local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.new(0.95, 0, 0, 42)
CheckBtn.Position = UDim2.new(0, 0, 0, 102)
CheckBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
CheckBtn.Text = ""
CheckBtn.Parent = VerifyPage

local CheckBtnCorner = Instance.new("UICorner")
CheckBtnCorner.CornerRadius = UDim.new(0, 6)
CheckBtnCorner.Parent = CheckBtn

local CheckBtnLabel = Instance.new("TextLabel")
CheckBtnLabel.Size = UDim2.new(0.8, 0, 1, 0)
CheckBtnLabel.Position = UDim2.new(0, 10, 0, 0)
CheckBtnLabel.BackgroundTransparency = 1
CheckBtnLabel.Text = "Check Key"
CheckBtnLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
CheckBtnLabel.TextSize = 13
CheckBtnLabel.Font = Enum.Font.SourceSans
CheckBtnLabel.TextXAlignment = Enum.TextXAlignment.Left
CheckBtnLabel.Parent = CheckBtn

local Arrow1 = Instance.new("TextLabel")
Arrow1.Size = UDim2.new(0, 20, 1, 0)
Arrow1.Position = UDim2.new(1, -25, 0, 0)
Arrow1.BackgroundTransparency = 1
Arrow1.Text = ">"
Arrow1.TextColor3 = Color3.fromRGB(160, 160, 175)
Arrow1.TextSize = 14
Arrow1.Font = Enum.Font.SourceSansBold
Arrow1.Parent = CheckBtn

-- Page 2: Get Key Page
local GetKeyPage = Instance.new("Frame")
GetKeyPage.Size = UDim2.new(1, 0, 1, 0)
GetKeyPage.BackgroundTransparency = 1
GetKeyPage.Visible = false
GetKeyPage.Parent = ContentArea

local Page2Title = Instance.new("TextLabel")
Page2Title.Size = UDim2.new(1, 0, 0, 25)
Page2Title.BackgroundTransparency = 1
Page2Title.Text = "Get Key"
Page2Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Page2Title.TextSize = 22
Page2Title.Font = Enum.Font.SourceSansBold
Page2Title.TextXAlignment = Enum.TextXAlignment.Left
Page2Title.Parent = GetKeyPage

local SectionLabel2 = Instance.new("TextLabel")
SectionLabel2.Size = UDim2.new(1, 0, 0, 20)
SectionLabel2.Position = UDim2.new(0, 0, 0, 28)
SectionLabel2.BackgroundTransparency = 1
SectionLabel2.Text = "Get Key System"
SectionLabel2.TextColor3 = Color3.fromRGB(160, 160, 180)
SectionLabel2.TextSize = 13
SectionLabel2.Font = Enum.Font.SourceSansSemibold
SectionLabel2.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel2.Parent = GetKeyPage

-- Link Button
local Link4mBtn = Instance.new("TextButton")
Link4mBtn.Size = UDim2.new(0.95, 0, 0, 48)
Link4mBtn.Position = UDim2.new(0, 0, 0, 52)
Link4mBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
Link4mBtn.Text = ""
Link4mBtn.Parent = GetKeyPage

local Link4mCorner = Instance.new("UICorner")
Link4mCorner.CornerRadius = UDim.new(0, 6)
Link4mCorner.Parent = Link4mBtn

local Link4mStroke = Instance.new("UIStroke")
Link4mStroke.Color = Color3.fromRGB(50, 50, 65)
Link4mStroke.Thickness = 1
Link4mStroke.Parent = Link4mBtn

local Link4mTitle = Instance.new("TextLabel")
Link4mTitle.Size = UDim2.new(0.85, 0, 0, 22)
Link4mTitle.Position = UDim2.new(0, 10, 0, 4)
Link4mTitle.BackgroundTransparency = 1
Link4mTitle.Text = "Get Key 1 lần (key vĩnh viễn)"
Link4mTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
Link4mTitle.TextSize = 13
Link4mTitle.Font = Enum.Font.SourceSansBold
Link4mTitle.TextXAlignment = Enum.TextXAlignment.Left
Link4mTitle.Parent = Link4mBtn

local Link4mSub = Instance.new("TextLabel")
Link4mSub.Size = UDim2.new(0.85, 0, 0, 16)
Link4mSub.Position = UDim2.new(0, 10, 0, 26)
Link4mSub.BackgroundTransparency = 1
Link4mSub.Text = "ấn vào đây để sao chép link getkey"
Link4mSub.TextColor3 = Color3.fromRGB(140, 140, 155)
Link4mSub.TextSize = 11
Link4mSub.Font = Enum.Font.SourceSans
Link4mSub.TextXAlignment = Enum.TextXAlignment.Left
Link4mSub.Parent = Link4mBtn

local Arrow2 = Instance.new("TextLabel")
Arrow2.Size = UDim2.new(0, 20, 1, 0)
Arrow2.Position = UDim2.new(1, -25, 0, 0)
Arrow2.BackgroundTransparency = 1
Arrow2.Text = ">"
Arrow2.TextColor3 = Color3.fromRGB(160, 160, 175)
Arrow2.TextSize = 14
Arrow2.Font = Enum.Font.SourceSansBold
Arrow2.Parent = Link4mBtn

-- Tabs
local function CreateTabBtn(text, isDefault)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(28, 28, 36) or Color3.fromRGB(15, 15, 20)
    TabBtn.BackgroundTransparency = isDefault and 0 or 1
    TabBtn.Text = text
    TabBtn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 155)
    TabBtn.TextSize = 13
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabBtn

    return TabBtn
end

local Tab1Btn = CreateTabBtn("Verify Key", true)
local Tab2Btn = CreateTabBtn("Get Key", false)

local function SwitchTab(activeBtn, activePage)
    VerifyPage.Visible = false
    GetKeyPage.Visible = false

    Tab1Btn.BackgroundTransparency = 1
    Tab1Btn.TextColor3 = Color3.fromRGB(140, 140, 155)

    Tab2Btn.BackgroundTransparency = 1
    Tab2Btn.TextColor3 = Color3.fromRGB(140, 140, 155)

    activeBtn.BackgroundTransparency = 0
    activeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    activePage.Visible = true
end

Tab1Btn.MouseButton1Click:Connect(function()
    SwitchTab(Tab1Btn, VerifyPage)
end)

Tab2Btn.MouseButton1Click:Connect(function()
    SwitchTab(Tab2Btn, GetKeyPage)
end)

-- Notification Popup
local function ShowNotification(text)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 240, 0, 35)
    NotifFrame.Position = UDim2.new(0.5, -120, 0.85, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = AdminHubUI

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 6)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(0, 200, 255)
    NotifStroke.Thickness = 1
    NotifStroke.Parent = NotifFrame

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, 0, 1, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 12
    NotifText.Font = Enum.Font.SourceSansBold
    NotifText.Parent = NotifFrame

    task.delay(2.5, function()
        if NotifFrame then NotifFrame:Destroy() end
    end)
end

-- Button Logic
Link4mBtn.MouseButton1Click:Connect(function()
    setclipboard(Link4mURL)
    
    Link4mStroke.Color = Color3.fromRGB(0, 220, 130)
    Link4mTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
    Link4mSub.Text = "[OK] Da sao chep link thanh cong!"
    Link4mSub.TextColor3 = Color3.fromRGB(0, 220, 130)
    
    ShowNotification("Da sao chep link GetKey!")
    
    task.wait(2)
    Link4mStroke.Color = Color3.fromRGB(50, 50, 65)
    Link4mTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
    Link4mSub.Text = "an vao day de sao chep link getkey"
    Link4mSub.TextColor3 = Color3.fromRGB(140, 140, 155)
end)

CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyTextBox.Text:gsub("%s+", "")
    if input == CorrectKey then
        ShowNotification("Key Dung! Dang tai Script...")
        task.wait(1)
        AdminHubUI:Destroy()
        loadstring(game:HttpGet(ScriptURL))()
    else
        ShowNotification("Key Sai! Vui long thu lai.")
    end
end)

-- Dragging (Kéo thả UI)
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
