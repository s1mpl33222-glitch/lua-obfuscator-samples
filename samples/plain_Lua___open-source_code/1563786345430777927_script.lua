--[[
    🌙 MOONHUB - Universal Edition (Syntax Errors Fixed)
    Optimized for: Place ID 139542527731344 (Map1 / Potato Tycoon & Horror)
    Supports PC & Mobile
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Device Detection System (PC vs Mobile)
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- 2. Cleanup Old Instances
local UI_NAME = "MoonHub_Universal_Edition"
if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end
if PlayerGui:FindFirstChild(UI_NAME) then PlayerGui[UI_NAME]:Destroy() end

-- 3. Supreme Obsidian Theme
local Theme = {
    MainBg       = Color3.fromRGB(13, 14, 18),
    HeaderBg     = Color3.fromRGB(10, 11, 15),
    SidebarBg    = Color3.fromRGB(9, 10, 13),
    CardBg       = Color3.fromRGB(18, 20, 26),
    Accent       = Color3.fromRGB(0, 162, 255),       -- #00A2FF Neon Cyan
    Border       = Color3.fromRGB(28, 32, 43),
    TextWhite    = Color3.fromRGB(245, 247, 250),
    TextMuted    = Color3.fromRGB(110, 118, 133),
    ToggleOff    = Color3.fromRGB(26, 29, 38),
    CloseRed     = Color3.fromRGB(255, 75, 75),
    Warning      = Color3.fromRGB(255, 170, 0),
    Success      = Color3.fromRGB(0, 230, 120),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

local activeConnections = {}
local cleanupCallbacks = {}
local isDestroyed = false

local function FastTween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Sleek Toast Notification System
local function Notify(title, message, duration)
    duration = duration or 2.5
    local Toast = Instance.new("Frame", ScreenGui)
    Toast.Size = UDim2.new(0, 240, 0, 48)
    Toast.Position = IS_MOBILE and UDim2.new(0.5, -120, 0, 15) or UDim2.new(1, -255, 1, -65)
    Toast.BackgroundColor3 = Theme.HeaderBg
    Toast.BorderSizePixel = 0
    Toast.ZIndex = 1000

    Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 6)
    local ToastStroke = Instance.new("UIStroke", Toast)
    ToastStroke.Color = Theme.Accent
    ToastStroke.Thickness = 1.2

    local Bar = Instance.new("Frame", Toast)
    Bar.Size = UDim2.new(0, 3, 1, -12)
    Bar.Position = UDim2.new(0, 5, 0, 6)
    Bar.BackgroundColor3 = Theme.Accent
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local TitleLbl = Instance.new("TextLabel", Toast)
    TitleLbl.Size = UDim2.new(1, -20, 0, 18)
    TitleLbl.Position = UDim2.new(0, 14, 0, 6)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Theme.Accent
    TitleLbl.TextSize = 11
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local MsgLbl = Instance.new("TextLabel", Toast)
    MsgLbl.Size = UDim2.new(1, -20, 0, 18)
    MsgLbl.Position = UDim2.new(0, 14, 0, 24)
    MsgLbl.BackgroundTransparency = 1
    MsgLbl.Font = Enum.Font.GothamMedium
    MsgLbl.Text = message
    MsgLbl.TextColor3 = Theme.TextWhite
    MsgLbl.TextSize = 10
    MsgLbl.TextXAlignment = Enum.TextXAlignment.Left

    task.delay(duration, function()
        if Toast and Toast.Parent then
            FastTween(Toast, 0.25, {BackgroundTransparency = 1})
            FastTween(TitleLbl, 0.25, {TextTransparency = 1})
            FastTween(MsgLbl, 0.25, {TextTransparency = 1})
            FastTween(ToastStroke, 0.25, {Transparency = 1})
            task.wait(0.26)
            Toast:Destroy()
        end
    end)
end

-- ================================================================
-- DISCORD OAUTH2 VERIFICATION GATE (Backend: moonhub.freesrv.com)
-- ================================================================
local AUTH_WEB_LINK = "https://moonhub.freesrv.com/login/" .. LocalPlayer.UserId
local API_CHECK_STATUS = "https://moonhub.freesrv.com/check?userid=" .. LocalPlayer.UserId

local VerifyGui = Instance.new("Frame", ScreenGui)
VerifyGui.Size = UDim2.new(0, 380, 0, 230)
VerifyGui.Position = UDim2.new(0.5, -190, 0.5, -115)
VerifyGui.BackgroundColor3 = Theme.MainBg
VerifyGui.BorderSizePixel = 0
VerifyGui.ZIndex = 500

Instance.new("UICorner", VerifyGui).CornerRadius = UDim.new(0, 8)
local VerifyStroke = Instance.new("UIStroke", VerifyGui)
VerifyStroke.Color = Theme.Accent
VerifyStroke.Thickness = 1.5

local VerifyHeader = Instance.new("TextLabel", VerifyGui)
VerifyHeader.Size = UDim2.new(1, 0, 0, 40)
VerifyHeader.BackgroundColor3 = Theme.HeaderBg
VerifyHeader.Font = Enum.Font.GothamBold
VerifyHeader.Text = "🌙 MOONHUB - Discord Authorization"
VerifyHeader.TextColor3 = Theme.TextWhite
VerifyHeader.TextSize = 13
Instance.new("UICorner", VerifyHeader).CornerRadius = UDim.new(0, 8)

local VerifyDesc = Instance.new("TextLabel", VerifyGui)
VerifyDesc.Size = UDim2.new(1, -30, 0, 55)
VerifyDesc.Position = UDim2.new(0, 15, 0, 50)
VerifyDesc.BackgroundTransparency = 1
VerifyDesc.Font = Enum.Font.GothamMedium
VerifyDesc.Text = "Authorize via Discord to access MoonHub. Click below to copy your secure login link."
VerifyDesc.TextColor3 = Theme.TextMuted
VerifyDesc.TextSize = 11
VerifyDesc.TextWrapped = true
VerifyDesc.TextXAlignment = Enum.TextXAlignment.Center

local OpenLinkBtn = Instance.new("TextButton", VerifyGui)
OpenLinkBtn.Size = UDim2.new(1, -40, 0, 36)
OpenLinkBtn.Position = UDim2.new(0, 20, 0, 115)
OpenLinkBtn.BackgroundColor3 = Theme.CardBg
OpenLinkBtn.Font = Enum.Font.GothamBold
OpenLinkBtn.Text = "🔗 Copy Discord Login Link"
OpenLinkBtn.TextColor3 = Theme.Accent
OpenLinkBtn.TextSize = 12
Instance.new("UICorner", OpenLinkBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", OpenLinkBtn).Color = Theme.Border

OpenLinkBtn.MouseButton1Click:Connect(function()
    local loginUrl = "https://moonhub.freesrv.com/login/" .. LocalPlayer.UserId
    local opened = false
    
    local openUrlFunc = rawget(_G, "openurl")
    local synGlobal = rawget(_G, "syn")
    local guiService = game:GetService("GuiService")
    
    pcall(function()
        if openUrlFunc then
            openUrlFunc(loginUrl)
            opened = true
        elseif synGlobal and synGlobal.open_url then
            synGlobal.open_url(loginUrl)
            opened = true
        elseif guiService then
            guiService:OpenBrowserWindow(loginUrl)
            opened = true
        end
    end)
    
    if opened then
        Notify("🌙 MOONHUB", "Opening Discord authorization...", 3)
    else
        if setclipboard then
            setclipboard(loginUrl)
            Notify("Link Copied", "Browser didn't open automatically, link copied!", 3)
        end
    end
end)

local StatusLbl = Instance.new("TextLabel", VerifyGui)
StatusLbl.Size = UDim2.new(1, 0, 0, 24)
StatusLbl.Position = UDim2.new(0, 0, 0, 170)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.Text = "Status: Waiting for browser authorization..."
StatusLbl.TextColor3 = Theme.Warning
StatusLbl.TextSize = 11
StatusLbl.TextXAlignment = Enum.TextXAlignment.Center

-- Main Window Frame (Initially Hidden until Verified)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Visible = false

if IS_MOBILE then
    Main.Size = UDim2.new(0, math.min(520, ScreenGui.AbsoluteSize.X - 16), 0, math.min(330, ScreenGui.AbsoluteSize.Y - 16))
else
    Main.Size = UDim2.new(0, 720, 0, 490)
end

Main.Position = UDim2.new(0.5, -Main.Size.X.Offset / 2, 0.5, -Main.Size.Y.Offset / 2)
Main.BackgroundColor3 = Theme.MainBg
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1.2

-- Background Polling Task
task.spawn(function()
    local synGlobal = rawget(_G, "syn")
    local httpRequest = (synGlobal and synGlobal.request) or (typeof(http) == "table" and http.request) or http_request or request
    if not httpRequest then
        StatusLbl.Text = "Status: Error (HTTP requests not supported)"
        StatusLbl.TextColor3 = Theme.CloseRed
        return
    end

    while not isDestroyed and VerifyGui and VerifyGui.Parent do
        pcall(function()
            local res = httpRequest({
                Url = API_CHECK_STATUS,
                Method = "GET"
            })
            if res and res.StatusCode == 200 then
                local data = HttpService:JSONDecode(res.Body)
                if data and data.authorized == true then
                    StatusLbl.Text = "Status: Authorized Successfully!"
                    StatusLbl.TextColor3 = Theme.Success
                    task.wait(0.5)

                    FastTween(VerifyGui, 0.2, {BackgroundTransparency = 1})
                    for _, child in ipairs(VerifyGui:GetChildren()) do
                        if child:IsA("GuiObject") then
                            FastTween(child, 0.2, {BackgroundTransparency = 1})
                            if child:IsA("TextButton") or child:IsA("TextLabel") then
                                child.TextTransparency = 1
                            end
                        end
                    end
                    task.wait(0.25)
                    VerifyGui:Destroy()
                    Main.Visible = true
                    Notify("🌙 MOONHUB", "Authorized successfully! Enjoy Map1!", 3)
                end
            end
        end)
        task.wait(3)
    end
end)

table.insert(activeConnections, ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    if IS_MOBILE then
        Main.Size = UDim2.new(0, math.min(520, ScreenGui.AbsoluteSize.X - 16), 0, math.min(330, ScreenGui.AbsoluteSize.Y - 16))
        Main.Position = UDim2.new(0.5, -Main.Size.X.Offset / 2, 0.5, -Main.Size.Y.Offset / 2)
    end
end))

-- 5. FLOATING TOGGLE BUTTON (1-Click & Draggable)
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Name = "FloatingToggle"
FloatBtn.Size = IS_MOBILE and UDim2.new(0, 38, 0, 38) or UDim2.new(0, 44, 0, 44)
FloatBtn.Position = UDim2.new(0, 15, 0.5, -20)
FloatBtn.BackgroundColor3 = Theme.HeaderBg
FloatBtn.BorderSizePixel = 0
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Text = "🌙"
FloatBtn.TextColor3 = Theme.Accent
FloatBtn.TextSize = IS_MOBILE and 16 or 18
FloatBtn.Visible = false
FloatBtn.ZIndex = 999

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Color = Theme.Accent
FloatStroke.Thickness = 1.5

local function ToggleMenuVisibility()
    local newState = not Main.Visible
    Main.Visible = newState
    FloatBtn.Visible = not newState
end

local floatDragging = false
local initialMousePos = Vector2.zero
local dragStartPos = UDim2.new()
local hasMoved = false

table.insert(activeConnections, FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        hasMoved = false
        initialMousePos = Vector2.new(input.Position.X, input.Position.Y)
        dragStartPos = FloatBtn.Position
    end
end))

table.insert(activeConnections, UserInputService.InputChanged:Connect(function(input)
    if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentMouse = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentMouse - initialMousePos
        if delta.Magnitude > 4 then hasMoved = true end
        FloatBtn.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end))

table.insert(activeConnections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if floatDragging then
            floatDragging = false
            if not hasMoved then ToggleMenuVisibility() end
        end
    end
end))

-- 6. HEADER BAR
local Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, IS_MOBILE and 32 or 36)
Header.BackgroundColor3 = Theme.HeaderBg
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local HeaderCover = Instance.new("Frame", Header)
HeaderCover.Size = UDim2.new(1, 0, 0, 6)
HeaderCover.Position = UDim2.new(0, 0, 1, -6)
HeaderCover.BackgroundColor3 = Theme.HeaderBg
HeaderCover.BorderSizePixel = 0

local TopGlow = Instance.new("Frame", Header)
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.Position = UDim2.new(0, 0, 1, 0)
TopGlow.BackgroundColor3 = Theme.Accent
TopGlow.BorderSizePixel = 0

local HeaderTitle = Instance.new("TextLabel", Header)
HeaderTitle.Size = UDim2.new(0, 280, 1, 0)
HeaderTitle.Position = UDim2.new(0, 10, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.Text = "🌙 <font color='#00A2FF'>ＭＯＯＮ</font>HUB <font color='#6E7685'>[" .. (IS_MOBILE and "Mobile" or "PC") .. "]</font>"
HeaderTitle.RichText = true
HeaderTitle.TextColor3 = Theme.TextWhite
HeaderTitle.TextSize = IS_MOBILE and 11 or 13
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

local Controls = Instance.new("Frame", Header)
Controls.Size = UDim2.new(0, 60, 1, 0)
Controls.Position = UDim2.new(1, -60, 0, 0)
Controls.BackgroundTransparency = 1

local ControlList = Instance.new("UIListLayout", Controls)
ControlList.FillDirection = Enum.FillDirection.Horizontal
ControlList.HorizontalAlignment = Enum.HorizontalAlignment.Right
ControlList.VerticalAlignment = Enum.VerticalAlignment.Center
ControlList.Padding = UDim.new(0, 5)

local ControlPad = Instance.new("UIPadding", Controls)
ControlPad.PaddingRight = UDim.new(0, 8)

local HideBtn = Instance.new("TextButton", Controls)
HideBtn.Size = IS_MOBILE and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 22, 0, 22)
HideBtn.BackgroundColor3 = Theme.CardBg
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Text = "-"
HideBtn.TextColor3 = Theme.TextMuted
HideBtn.TextSize = IS_MOBILE and 12 or 14
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", HideBtn).Color = Theme.Border
HideBtn.MouseButton1Click:Connect(ToggleMenuVisibility)

local CloseBtn = Instance.new("TextButton", Controls)
CloseBtn.Size = IS_MOBILE and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 22, 0, 22)
CloseBtn.BackgroundColor3 = Theme.CardBg
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextMuted
CloseBtn.TextSize = IS_MOBILE and 14 or 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
local CloseStroke = Instance.new("UIStroke", CloseBtn)
CloseStroke.Color = Theme.Border

CloseBtn.MouseEnter:Connect(function() FastTween(CloseBtn, 0.1, {BackgroundColor3 = Theme.CloseRed, TextColor3 = Theme.TextWhite}) end)
CloseBtn.MouseLeave:Connect(function() FastTween(CloseBtn, 0.1, {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextMuted}) end)

local function DestroyUI()
    isDestroyed = true
    for _, cb in ipairs(cleanupCallbacks) do pcall(cb) end
    for _, conn in ipairs(activeConnections) do pcall(function() conn:Disconnect() end) end
    ScreenGui:Destroy()
end
CloseBtn.MouseButton1Click:Connect(DestroyUI)

-- PC Dragging Support
if not IS_MOBILE then
    local dragging = false
    local dragStart = Vector2.zero
    local startPos = UDim2.new()

    table.insert(activeConnections, Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end))

    table.insert(activeConnections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

-- 7. Sidebar Framework
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, IS_MOBILE and 110 or 150, 1, IS_MOBILE and -34 or -38)
Sidebar.Position = UDim2.new(0, 0, 0, IS_MOBILE and 34 or 38)
Sidebar.BackgroundColor3 = Theme.SidebarBg
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabHolder = Instance.new("ScrollingFrame", Sidebar)
TabHolder.Size = UDim2.new(1, 0, 1, -8)
TabHolder.Position = UDim2.new(0, 0, 0, 4)
TabHolder.BackgroundTransparency = 1
TabHolder.BorderSizePixel = 0
TabHolder.ScrollBarThickness = 0

local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 3)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local TabPad = Instance.new("UIPadding", TabHolder)
TabPad.PaddingLeft = UDim.new(0, IS_MOBILE and 5 or 8)
TabPad.PaddingRight = UDim.new(0, IS_MOBILE and 5 or 8)

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, IS_MOBILE and -118 or -160, 1, IS_MOBILE and -38 or -46)
ContentArea.Position = UDim2.new(0, IS_MOBILE and 114 or 155, 0, IS_MOBILE and 36 or 42)
ContentArea.BackgroundTransparency = 1

local Tabs = {}
local activeTab = nil

local function CreateTab(tabName, iconText)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(1, 0, 0, IS_MOBILE and 26 or 28)
    TabBtn.BackgroundColor3 = Theme.CardBg
    TabBtn.BackgroundTransparency = 1
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = "  " .. (iconText or "•") .. " " .. tabName
    TabBtn.TextColor3 = Theme.TextMuted
    TabBtn.TextSize = IS_MOBILE and 10 or 11
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    local Strip = Instance.new("Frame", TabBtn)
    Strip.Size = UDim2.new(0, 3, 0, IS_MOBILE and 12 or 14)
    Strip.Position = UDim2.new(0, 2, 0.5, IS_MOBILE and -6 or -7)
    Strip.BackgroundColor3 = Theme.Accent
    Strip.BorderSizePixel = 0
    Strip.BackgroundTransparency = 1
    Instance.new("UICorner", Strip).CornerRadius = UDim.new(0, 2)

    local TabPage = Instance.new("ScrollingFrame", ContentArea)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Theme.Accent
    TabPage.Visible = false
    
    local LeftCol = Instance.new("Frame", TabPage)
    LeftCol.Size = UDim2.new(0.49, 0, 0, 0)
    LeftCol.AutomaticSize = Enum.AutomaticSize.Y
    LeftCol.BackgroundTransparency = 1
    
    local RightCol = Instance.new("Frame", TabPage)
    RightCol.Size = UDim2.new(0.49, 0, 0, 0)
    RightCol.Position = UDim2.new(0.51, 0, 0, 0)
    RightCol.AutomaticSize = Enum.AutomaticSize.Y
    RightCol.BackgroundTransparency = 1

    local LList = Instance.new("UIListLayout", LeftCol)
    LList.Padding = UDim.new(0, 6)
    local RList = Instance.new("UIListLayout", RightCol)
    RList.Padding = UDim.new(0, 6)

    local function AutoResizeCanvas()
        local maxH = math.max(LList.AbsoluteContentSize.Y, RList.AbsoluteContentSize.Y)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, maxH + 16)
    end
    LList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AutoResizeCanvas)
    RList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AutoResizeCanvas)

    Tabs[tabName] = {Btn = TabBtn, Page = TabPage, Left = LeftCol, Right = RightCol, Strip = Strip}

    TabBtn.MouseButton1Click:Connect(function()
        for name, data in pairs(Tabs) do
            local isActive = (name == tabName)
            data.Page.Visible = isActive
            FastTween(data.Btn, 0.15, {
                TextColor3 = isActive and Theme.TextWhite or Theme.TextMuted,
                BackgroundTransparency = isActive and 0 or 1
            })
            FastTween(data.Strip, 0.15, {BackgroundTransparency = isActive and 0 or 1})
        end
    end)

    if not activeTab then
        activeTab = tabName
        TabPage.Visible = true
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.TextWhite
        Strip.BackgroundTransparency = 0
    end

    return Tabs[tabName]
end

local function CreateSection(column, titleText)
    local Section = Instance.new("Frame", column)
    Section.Size = UDim2.new(1, 0, 0, 26)
    Section.BackgroundColor3 = Theme.CardBg
    Section.BorderSizePixel = 0
    
    Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 5)
    local Stroke = Instance.new("UIStroke", Section)
    Stroke.Color = Theme.Border
    Stroke.Thickness = 1
    
    local HeaderLabel = Instance.new("TextLabel", Section)
    HeaderLabel.Size = UDim2.new(1, -10, 0, 20)
    HeaderLabel.Position = UDim2.new(0, 8, 0, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.Text = string.upper(titleText)
    HeaderLabel.TextColor3 = Theme.Accent
    HeaderLabel.TextSize = IS_MOBILE and 8 or 10
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame", Section)
    Container.Position = UDim2.new(0, 0, 0, 20)
    Container.Size = UDim2.new(1, 0, 1, -20)
    Container.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 5)
    
    local Pad = Instance.new("UIPadding", Container)
    Pad.PaddingLeft = UDim.new(0, 6)
    Pad.PaddingRight = UDim.new(0, 6)
    Pad.PaddingBottom = UDim.new(0, 6)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 26)
    end)

    return Container
end

local function AddToggle(parent, text, default, callback)
    local ToggleBtn = Instance.new("TextButton", parent)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 20)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""

    local Label = Instance.new("TextLabel", ToggleBtn)
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Theme.TextWhite
    Label.TextSize = IS_MOBILE and 9 or 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new("Frame", ToggleBtn)
    Box.Size = UDim2.new(0, 24, 0, 12)
    Box.Position = UDim2.new(1, -24, 0.5, -6)
    Box.BackgroundColor3 = default and Theme.Accent or Theme.ToggleOff
    Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

    local Indicator = Instance.new("Frame", Box)
    Indicator.Size = UDim2.new(0, 8, 0, 8)
    Indicator.Position = default and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
    Indicator.BackgroundColor3 = Theme.TextWhite
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        FastTween(Box, 0.12, {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff})
        FastTween(Indicator, 0.12, {Position = state and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)})
        pcall(callback, state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 28)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -30, 0, 12)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Theme.TextWhite
    Label.TextSize = IS_MOBILE and 9 or 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLbl = Instance.new("TextLabel", Frame)
    ValueLbl.Size = UDim2.new(0, 30, 0, 12)
    ValueLbl.Position = UDim2.new(1, -30, 0, 0)
    ValueLbl.BackgroundTransparency = 1
    ValueLbl.Font = Enum.Font.GothamBold
    ValueLbl.Text = tostring(default)
    ValueLbl.TextColor3 = Theme.Accent
    ValueLbl.TextSize = IS_MOBILE and 8 or 10
    ValueLbl.TextXAlignment = Enum.TextXAlignment.Right

    local HitBox = Instance.new("TextButton", Frame)
    HitBox.Size = UDim2.new(1, 0, 0, 14)
    HitBox.Position = UDim2.new(0, 0, 0, 13)
    HitBox.BackgroundTransparency = 1
    HitBox.Text = ""

    local Bar = Instance.new("Frame", HitBox)
    Bar.Size = UDim2.new(1, 0, 0, 4)
    Bar.Position = UDim2.new(0, 0, 0.5, -2)
    Bar.BackgroundColor3 = Theme.ToggleOff
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(math.clamp((default - min)/(max - min), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local isDragging = false
    local currentVal = default

    local function UpdateSlider(inputPos)
        local barPos = Bar.AbsolutePosition.X
        local barSize = Bar.AbsoluteSize.X
        local pct = math.clamp((inputPos.X - barPos) / barSize, 0, 1)
        local val = math.floor(min + (max - min) * pct)
        
        if val ~= currentVal then
            currentVal = val
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            ValueLbl.Text = tostring(val)
            pcall(callback, val)
        end
    end

    HitBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            UpdateSlider(input.Position)
        end
    end)

    table.insert(activeConnections, UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input.Position)
        end
    end))

    table.insert(activeConnections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end))
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 22)
    Btn.BackgroundColor3 = Theme.SidebarBg
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = text
    Btn.TextColor3 = Theme.TextWhite
    Btn.TextSize = IS_MOBILE and 9 or 11
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", Btn).Color = Theme.Border

    Btn.MouseButton1Click:Connect(function()
        FastTween(Btn, 0.08, {BackgroundColor3 = Theme.Accent})
        task.wait(0.08)
        FastTween(Btn, 0.12, {BackgroundColor3 = Theme.SidebarBg})
        pcall(callback)
    end)
end

local function AddLabel(parent, text, color)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.Size = UDim2.new(1, 0, 0, 16)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.Text = text
    Lbl.TextColor3 = color or Theme.TextMuted
    Lbl.TextSize = IS_MOBILE and 8 or 10
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextWrapped = true
    return Lbl
end

-- ================================================================
-- PLACE ID: 139542527731344 FEATURE LOGIC (Safe Require)
-- ================================================================

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local SharedStats = nil
local originalStats = {}

pcall(function()
    local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
    local statsMod = sharedFolder and sharedFolder:FindFirstChild("Stats")
    if statsMod and statsMod:IsA("ModuleScript") then
        SharedStats = require(statsMod)
        if SharedStats then
            originalStats.instantPeel = SharedStats.instantPeel
        end
    end
end)

table.insert(cleanupCallbacks, function()
    if SharedStats and originalStats.instantPeel then
        SharedStats.instantPeel = originalStats.instantPeel
    end
end)

-- ================================================================
-- KEY WORLD LOCATIONS
-- ================================================================
local POTATO_PILE_POS = Vector3.new(104.7, 4.0, 17.0)
local CRATE_POS       = Vector3.new(52.9, 4.0, 19.5)
local POWER_BOX_POS   = Vector3.new(14.1, 4.6, 36.3)
local KITCHEN_POS     = Vector3.new(46.4, 4.0, 24.3)

-- ================================================================
-- CORE FARM & INTERACTION FUNCTIONS (ANY-RANGE)
-- ================================================================

local function getTopPotato()
    local pScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    if pScripts then
        local ctrl = pScripts:FindFirstChild("Controllers")
        local pileCtrl = ctrl and ctrl:FindFirstChild("PileController")
        if pileCtrl then
            local ok, PileController = pcall(require, pileCtrl)
            if ok and PileController and PileController.clickAtScreen then
                local ok2, clickAt = pcall(debug.getupvalue, PileController.clickAtScreen, 1)
                if ok2 and clickAt then
                    local ok3, state = pcall(debug.getupvalue, clickAt, 1)
                    if ok3 and state and state.partCell then
                        for part, cell in pairs(state.partCell) do
                            if part and part.Parent then
                                local key = state.packKey(cell[1], cell[3])
                                local h = state.heights and state.heights[key]
                                if h and cell[2] == h - 1 then
                                    local tex = state.partTexture and state.partTexture[part] or 1
                                    return part, cell, tex
                                end
                            end
                        end
                        for part, cell in pairs(state.partCell) do
                            if part and part.Parent then
                                local tex = state.partTexture and state.partTexture[part] or 1
                                return part, cell, tex
                            end
                        end
                    end
                end
            end
        end
    end

    local pile = workspace:FindFirstChild("PotatoPile")
    if pile then
        local p = pile:FindFirstChildWhichIsA("MeshPart")
        if p then return p, {0, 0, 0}, 1 end
    end
    return nil, nil, nil
end

local function grabFromPile(returnBack)
    local grabbed = false
    pcall(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local busy = LocalPlayer:GetAttribute("PotatoBusy")
        if busy then return end

        local topPart, topCell, topTex = getTopPotato()
        if not topPart or not topCell then return end

        local originalCF = hrp.CFrame
        local targetCF = topPart.CFrame + Vector3.new(0, 2.5, 0)
        local dist = (hrp.Position - topPart.Position).Magnitude
        local needsTp = dist > 12

        if needsTp then
            hrp.CFrame = targetCF
            task.wait(0.08)
        end

        if Remotes and Remotes:FindFirstChild("RemovePotato") then
            Remotes.RemovePotato:FireServer(topCell[1], topCell[2], topCell[3], topTex)
            grabbed = true
        end

        if needsTp and returnBack then
            task.wait(0.08)
            hrp.CFrame = originalCF
        end
    end)
    return grabbed
end

local function putPotatoesInCrate(returnBack)
    local put = false
    pcall(function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local dist = (hrp.Position - CRATE_POS).Magnitude
        local needsTp = dist > 10
        local originalCF = hrp.CFrame

        if needsTp then
            hrp.CFrame = CFrame.new(CRATE_POS)
            task.wait(0.08)
        end

        if Remotes and Remotes:FindFirstChild("CratePut") then
            Remotes.CratePut:FireServer()
            put = true
        end

        if needsTp and returnBack then
            task.wait(0.08)
            hrp.CFrame = originalCF
        end
    end)
    return put
end

local isRepairing = false

-- Тохиргоо (Хүссэн секундээ энд өөрчилж болно)
local CLOSE_DELAY = 0.5         -- Цэстэй байх хугацаа
local COOLDOWN_DURATION = 3     -- Засаж дууссаны дараа дахин шалгахгүй байх хүлээх хугацаа (сек)

local isRepairing = false
local lastRepairTime = 0

local function repairPowerBox(returnBack)
    if isRepairing then return end
    isRepairing = true

    pcall(function()
        local pbs = workspace:FindFirstChild("PowerBoxes")
        local pb = pbs and pbs:FindFirstChild("PowerBox1")
        if not pb then
            if typeof(Notify) == "function" then
                Notify("Power Box", "Power Box 1 not found in workspace!", 2.5)
            end
            isRepairing = false
            return
        end

        local char = LocalPlayer and LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local isFar = hrp and (hrp.Position - POWER_BOX_POS).Magnitude > 12
        local originalCF = nil

        -- 1. Хол байгаа бол байршил руу нь телепорт хийх
        if isFar and hrp then
            originalCF = hrp.CFrame
            hrp.CFrame = CFrame.new(POWER_BOX_POS)
            task.wait(0.15)
        end

        -- 2. ProximityPrompt-ийг албаар дарж мини-тоглоом/менюг идэвхжүүлэх
        local prompt = pb:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and fireproximityprompt then
            fireproximityprompt(prompt)
            task.wait(0.1)
        end

        -- 3. ReplicatedStorage-оос Remotes-ийг найдвартай олж авах
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = replicatedStorage:FindFirstChild("Remotes")
        local powerCableRemote = remotes and remotes:FindFirstChild("PowerCable")

        if powerCableRemote then
            -- 1-ээс 6 хүртэл кабелийг залгах
            for i = 1, 6 do
                powerCableRemote:FireServer(pb, "Plug", i)
                task.wait(0.04)
            end

            -- Хайрцгийг хаах хүсэлт явуулах
            powerCableRemote:FireServer(pb, "Close")

            -- UI / Мини-тоглоомын цонхыг хаах хэсэг
            task.wait(CLOSE_DELAY)
            pcall(function()
                local pScripts = LocalPlayer:FindFirstChild("PlayerScripts")
                local ctrl = pScripts and pScripts:FindFirstChild("Controllers")
                local pwr = ctrl and ctrl:FindFirstChild("Power")
                local cableGameMod = pwr and pwr:FindFirstChild("CableGame")
                if cableGameMod then
                    local CableGame = require(cableGameMod)
                    if CableGame and CableGame.close then
                        CableGame.close()
                    end
                end
            end)
        end

        if typeof(Notify) == "function" then
            Notify("Power Box", "Power Box 1 successfully repaired!", 2.5)
        end
    end)

    lastRepairTime = tick()
    isRepairing = false
end

local function checkAnomalyDetected()
    local driveThru = workspace:FindFirstChild("DriveThru")
    if driveThru then
        if driveThru:GetAttribute("PatienceKind") == "Possessed" then
            return true, "DriveThru Possessed"
        end
        local car = driveThru:FindFirstChild("Car")
        if car and car:IsA("Model") then
            local anom = car:GetAttribute("Anomaly")
            if anom and anom ~= "None" and anom ~= "" then
                return true, tostring(anom)
            end
            local traits = car:GetAttribute("AnomalyTraits")
            if traits and traits ~= "None" and traits ~= "" then
                return true, tostring(traits)
            end
            if car:GetAttribute("AnomalyForced") == true then
                return true, "Anomaly Forced"
            end
        end
    end

    local traffic = workspace:FindFirstChild("Traffic")
    if traffic then
        for _, car in ipairs(traffic:GetChildren()) do
            if car:IsA("Model") then
                local anom = car:GetAttribute("Anomaly")
                if anom and anom ~= "None" and anom ~= "" then
                    return true, tostring(anom)
                end
                local traits = car:GetAttribute("AnomalyTraits")
                if traits and traits ~= "None" and traits ~= "" then
                    return true, tostring(traits)
                end
            end
        end
    end

    local anomalies = workspace:FindFirstChild("Anomalies")
    if anomalies and #anomalies:GetChildren() > 0 then
        return true, "Anomaly Entity"
    end

    return false, nil
end

-- -------------------------------------------------------------
-- TAB 1: 🍟 GAME (Potato Tycoon & Anomaly Defense)
-- -------------------------------------------------------------
local GameTab = CreateTab("Game", "🍟")
local FarmCol    = CreateSection(GameTab.Left,  "Auto Farm")
local AnomalyCol = CreateSection(GameTab.Right, "Anomaly Car Radar & Survival")
local TycoonCol  = CreateSection(GameTab.Right, "Tycoon Automation")

AddToggle(FarmCol, "Instant Peel (0s)", true, function(v)
    if SharedStats then
        if v then
            SharedStats.instantPeel = function() return true end
            Notify("Instant Peel", "Enabled: Potatoes peel in 0 seconds!", 2)
        else
            SharedStats.instantPeel = originalStats.instantPeel
            Notify("Instant Peel", "Disabled: Normal peeling restored", 2)
        end
    end
end)

local shutterCooldown = false
local autoFarmActive = false
AddToggle(FarmCol, "Auto Farm (Full Loop)", false, function(v)
    autoFarmActive = v
    Notify("Auto Farm", v and "Running: Continuous Pile -> Crate auto-farming (Big Scoop Enabled)!" or "Stopped", 2.5)
end)

task.spawn(function()
    while not isDestroyed do
        if autoFarmActive and not isRepairing and not shutterCooldown then
            pcall(function()
                local carry = LocalPlayer:GetAttribute("CarryCount") or 0
                local raw   = LocalPlayer:GetAttribute("CarryRaw")   or 0
                local busy  = LocalPlayer:GetAttribute("PotatoBusy")
                local char  = LocalPlayer.Character
                local hrp   = char and char:FindFirstChild("HumanoidRootPart")
                local cap   = (SharedStats and SharedStats.carryCapacity and SharedStats.carryCapacity(LocalPlayer)) or (LocalPlayer:GetAttribute("CarryCapacity")) or 3

                if not hrp or busy then task.wait(0.2) return end

                -- Сагс дүүрсэн эсвэл raw хэтэрсэн бол Карт руу зөөх
                if carry >= cap or (carry > 0 and raw > 99) then
                    hrp.CFrame = CFrame.new(CRATE_POS)
                    task.wait(0.1)
                    if Remotes and Remotes:FindFirstChild("CratePut") then
                        Remotes.CratePut:FireServer()
                    end
                    task.wait(0.25)
                else
                    -- Big Scoop ашиглан сагс дүүртэл цувралаар түүх хэсэг
                    while carry < cap and autoFarmActive do
                        local topPart, topCell, topTex = getTopPotato()
                        if topPart and topCell then
                            hrp.CFrame = topPart.CFrame + Vector3.new(0, 2.5, 0)
                            task.wait(0.02)
                            if Remotes and Remotes:FindFirstChild("RemovePotato") then
                                Remotes.RemovePotato:FireServer(topCell[1], topCell[2], topCell[3], topTex)
                            end
                            carry = carry + 1
                            task.wait(0.05)
                        else
                            hrp.CFrame = CFrame.new(POTATO_PILE_POS + Vector3.new(0, 2.5, 0))
                            task.wait(0.2)
                            break
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

local autoRepairPowerActive = false
AddToggle(FarmCol, "Auto Repair Power Box 1", false, function(v)
    autoRepairPowerActive = v
    Notify("Auto Power Repair", v and "Active: Will auto-fix Power Box 1 when broken" or "Disabled", 2)
end)

-- ----------------------------------------------------
-- ҮНДСЭН ШАЛГАХ ДАВТАЛТ (MAIN LOOP)
-- ----------------------------------------------------
task.spawn(function()
    while not isDestroyed do
        if autoRepairPowerActive and not isRepairing and (tick() - lastRepairTime >= COOLDOWN_DURATION) then
            pcall(function()
                local pbs = workspace:FindFirstChild("PowerBoxes")
                local pb = pbs and pbs:FindFirstChild("PowerBox1")
                local isBroken = false

                if pb then
                    -- ЗӨВХӨН PowerBroken == true үед л эвдэрсэн гэж үзнэ
                    if pb:GetAttribute("PowerBroken") == true then
                        isBroken = true
                    end
                end

                -- Зөвхөн үнэхээр эвдэрсэн үед засна
                if isBroken then
                    repairPowerBox(true)
                end
            end)
        end
        task.wait(2)
    end
end)

AddButton(FarmCol, "Repair Power Box 1 (Now)", function()
    repairPowerBox(true)
end)

-- -------------------------------------------------------------
-- ANOMALY CAR RADAR & SURVIVAL
-- -------------------------------------------------------------
local anomalyCarEspActive   = false
local autoShutterOnAnomaly  = false
local autoShutterClosedIt   = false
local shutterDebounce       = false
local anomalyCarHighlights  = {}
local anomalyCarBillboards  = {}

local function removeCarEsp(car)
    if anomalyCarHighlights[car] then
        anomalyCarHighlights[car]:Destroy()
        anomalyCarHighlights[car] = nil
    end
    if anomalyCarBillboards[car] then
        anomalyCarBillboards[car]:Destroy()
        anomalyCarBillboards[car] = nil
    end
end

local function updateCarEsp(car)
    if not anomalyCarEspActive or not car or not car:IsA("Model") then
        removeCarEsp(car)
        return
    end

    local anomaly = car:GetAttribute("Anomaly")
    local traits  = car:GetAttribute("AnomalyTraits") or "None"
    local driver  = car:GetAttribute("DriverName") or "Unknown"
    local isAnomaly = anomaly and anomaly ~= "None" and anomaly ~= ""

    if isAnomaly then
        if not anomalyCarHighlights[car] then
            local hl = Instance.new("Highlight")
            hl.Name = "MoonHub_AnomalyCarHL"
            hl.Adornee = car
            hl.FillColor = Color3.fromRGB(255, 30, 30)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.35
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = ScreenGui
            anomalyCarHighlights[car] = hl

            local root = car:FindFirstChildWhichIsA("BasePart") or car.PrimaryPart
            if root then
                local bb = Instance.new("BillboardGui")
                bb.Name = "MoonHub_AnomalyCarBB"
                bb.Adornee = root
                bb.Size = UDim2.new(0, 180, 0, 42)
                bb.StudsOffset = Vector3.new(0, 4.5, 0)
                bb.AlwaysOnTop = true
                bb.Parent = ScreenGui

                anomalyCarBillboards[car] = bb
            end
        end
    else
        removeCarEsp(car)
        if not anomalyCarHighlights[car] then
            local hl = Instance.new("Highlight")
            hl.Name = "MoonHub_HumanCarHL"
            hl.Adornee = car
            hl.FillColor = Color3.fromRGB(0, 230, 120)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.7
            hl.OutlineTransparency = 0.5
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = ScreenGui
            anomalyCarHighlights[car] = hl

            local root = car:FindFirstChildWhichIsA("BasePart") or car.PrimaryPart
            if root then
                local bb = Instance.new("BillboardGui")
                bb.Name = "MoonHub_HumanCarBB"
                bb.Adornee = root
                bb.Size = UDim2.new(0, 140, 0, 24)
                bb.StudsOffset = Vector3.new(0, 4, 0)
                bb.AlwaysOnTop = true
                bb.Parent = ScreenGui

                anomalyCarBillboards[car] = bb
            end
        end
    end
end

local function scanTraffic()
    local traffic = workspace:FindFirstChild("Traffic")
    if traffic then
        for _, car in ipairs(traffic:GetChildren()) do
            updateCarEsp(car)
        end
    end
    local driveThru = workspace:FindFirstChild("DriveThru")
    local dtCar = driveThru and driveThru:FindFirstChild("Car")
    if dtCar then
        updateCarEsp(dtCar)
    end
end

AddToggle(AnomalyCol, "Anomaly Car ESP", false, function(v)
    anomalyCarEspActive = v
    if v then
        scanTraffic()
        Notify("Anomaly Radar", "Active: Anomaly cars in RED, Humans in GREEN", 2.5)
    else
        local traffic = workspace:FindFirstChild("Traffic")
        if traffic then
            for _, car in ipairs(traffic:GetChildren()) do
                removeCarEsp(car)
            end
        end
        local driveThru = workspace:FindFirstChild("DriveThru")
        local dtCar = driveThru and driveThru:FindFirstChild("Car")
        if dtCar then
            removeCarEsp(dtCar)
        end
    end
end)

local trafficFolder = workspace:FindFirstChild("Traffic")
if trafficFolder then
    table.insert(activeConnections, trafficFolder.ChildAdded:Connect(function(car)
        task.wait(0.2)
        if anomalyCarEspActive then
            updateCarEsp(car)
            car:GetAttributeChangedSignal("Anomaly"):Connect(function()
                updateCarEsp(car)
            end)
        end
    end))
    table.insert(activeConnections, trafficFolder.ChildRemoved:Connect(function(car)
        removeCarEsp(car)
    end))
end

local driveThruFolder = workspace:FindFirstChild("DriveThru")
if driveThruFolder then
    table.insert(activeConnections, driveThruFolder.ChildAdded:Connect(function(child)
        if child.Name == "Car" then
            task.wait(0.2)
            if anomalyCarEspActive then
                updateCarEsp(child)
                child:GetAttributeChangedSignal("Anomaly"):Connect(function()
                    updateCarEsp(child)
                end)
            end
        end
    end))
    table.insert(activeConnections, driveThruFolder.ChildRemoved:Connect(function(child)
        if child.Name == "Car" then
            removeCarEsp(child)
        end
    end))
end

local antiJumpscareActive = false
AddToggle(AnomalyCol, "Anti-Jumpscare", false, function(v)
    antiJumpscareActive = v
    Notify("Anti-Jumpscare", v and "Enabled: Screen jumpscares blocked" or "Disabled", 2)
end)

pcall(function()
    local pScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local ctrl = pScripts and pScripts:FindFirstChild("Controllers")
    local anomFolder = ctrl and ctrl:FindFirstChild("Anomaly")
    local anomScreenMod = anomFolder and anomFolder:FindFirstChild("AnomalyScreen")
    if anomScreenMod then
        local AnomalyScreen = require(anomScreenMod)
        local oldScare = AnomalyScreen.scare
        AnomalyScreen.scare = function(...)
            if antiJumpscareActive then return end
            return oldScare(...)
        end
        table.insert(cleanupCallbacks, function()
            AnomalyScreen.scare = oldScare
        end)
    end
end)

-- Close shutter
local function closeShutter()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShutterPress"):FireServer()
    end)
end

-- ── SHUTTER ───────────────────────────────────────────────────────
-- Only triggers when CarWaiting==true AND the car at the drive-thru window has Anomaly set
local autoShutterOnAnomaly = false
local shutterCooldown      = false
local autoShutterClosedIt  = false

-- Телепорт хийх координат
local SHUTTER_POS = Vector3.new(18.1, 4.0, 28.7)

AddToggle(AnomalyCol, "Auto Close on Anomaly at Window", false, function(v)
    autoShutterOnAnomaly = v
    Notify("Auto Shutter", v and "Active: closes when anomaly pulls up to window" or "OFF", 2)
end)

task.spawn(function()
    while not isDestroyed do
        if autoShutterOnAnomaly and not shutterCooldown then
            pcall(function()
                local dt = workspace:FindFirstChild("DriveThru")
                if not dt then return end
                local carWaiting = dt:GetAttribute("CarWaiting") == true
                local car        = dt:FindFirstChild("Car")
                local isAnomalyCar = car and carWaiting and (car:GetAttribute("Anomaly") ~= nil)

                local shutter = dt:FindFirstChild("Shutter")
                local isClosed = shutter and (shutter:GetAttribute("ShutterClosed") == true
                                           or shutter:GetAttribute("ShutterTo") == 1)

                if isAnomalyCar then
                    if not isClosed then
                        shutterCooldown = true

                        -- 1. Тухайн цэг рүү очиж телепорт хийх (Буцаж ирэх хэсгийг хассан)
                        local char = LocalPlayer and LocalPlayer.Character
                        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                        local isFar = hrp and (hrp.Position - SHUTTER_POS).Magnitude > 6

                        if isFar and hrp then
                            hrp.CFrame = CFrame.new(SHUTTER_POS)
                            task.wait(0.15) -- Байрлалдаа очтол бага зэрэг хүлээх
                        end

                        -- 2. Shutter-ийг хаах үйлдэл
                        closeShutter()
                        autoShutterClosedIt = true
                        Notify("🚨 AUTO SHUTTER", "Anomaly at window! Teleported & Shutter closed!", 3)

                        task.delay(5, function() shutterCooldown = false end)
                    end
                else
                    -- Reopen if we closed it and no anomaly now
                    if autoShutterClosedIt and isClosed and not shutterCooldown then
                        shutterCooldown = true

                        closeShutter()
                        autoShutterClosedIt = false
                        Notify("✅ AUTO SHUTTER", "Anomaly gone! Shutter reopened!", 2.5)
                        
                        task.delay(5, function() shutterCooldown = false end)
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

AddButton(AnomalyCol, "Toggle Shutter (Manual)", function()
    closeShutter()
    Notify("Shutter", "Toggled drive-thru shutter", 2)
end)

local autoTycoonActive = false
AddToggle(TycoonCol, "Auto Step On Tycoon Pads", false, function(v)
    autoTycoonActive = v
    Notify("Auto Tycoon", v and "Active: Auto-buying available pads" or "Disabled", 2)
end)

task.spawn(function()
    while not isDestroyed do
        if autoTycoonActive then
            pcall(function()
                local tycoon = workspace:FindFirstChild("Tycoon")
                local pads   = tycoon and tycoon:FindFirstChild("Pads")
                local char   = LocalPlayer.Character
                local hrp    = char and char:FindFirstChild("HumanoidRootPart")
                if pads and hrp then
                    for _, pad in ipairs(pads:GetChildren()) do
                        if not autoTycoonActive then break end
                        local trig = pad:FindFirstChild("Trigger")
                        if trig and trig:IsA("BasePart") then
                            if firetouchinterest then
                                firetouchinterest(hrp, trig, 0)
                                task.wait()
                                firetouchinterest(hrp, trig, 1)
                            else
                                local oldPos = hrp.CFrame
                                hrp.CFrame = trig.CFrame
                                task.wait(0.08)
                                hrp.CFrame = oldPos
                            end
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
        task.wait(1.5)
    end
end)

-- -------------------------------------------------------------
-- TAB 2: 📍 TELEPORTS (Place 139542527731344 Key Locations)
-- -------------------------------------------------------------
local TeleportTab = CreateTab("Teleports", "📍")
local WorkSpots = CreateSection(TeleportTab.Left,  "Station & Kitchen")
local MapSpots  = CreateSection(TeleportTab.Right, "Shops & Secrets")

local function TeleportTo(pos, name)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2.5, 0))
        Notify("Teleport", "Arrived at: " .. name, 2)
    end
end

AddButton(WorkSpots, "Kitchen Station / Peeler", function()
    TeleportTo(Vector3.new(46.4, 4.0, 24.3), "Kitchen Peeler")
end)

AddButton(WorkSpots, "Potato Pile", function()
    TeleportTo(Vector3.new(104.7, 4.0, 17.0), "Potato Pile")
end)

AddButton(WorkSpots, "Drive-Thru Window", function()
    TeleportTo(Vector3.new(13.5, 4.8, 23.3), "Drive-Thru Window")
end)

AddButton(WorkSpots, "Power Box 1", function()
    TeleportTo(Vector3.new(14.1, 4.6, 36.3), "Power Box 1")
end)

AddButton(MapSpots, "Item Shop", function()
    TeleportTo(Vector3.new(28.3, 4.0, 29.3), "Item Shop")
end)

AddButton(MapSpots, "Merchant Shop", function()
    TeleportTo(Vector3.new(30.0, 4.0, 157.9), "Merchant Shop")
end)

AddButton(MapSpots, "Basement Padlock", function()
    TeleportTo(Vector3.new(103.8, 3.0, 40.9), "Basement Padlock")
end)

AddButton(MapSpots, "Safe Rooftop (High Spot)", function()
    TeleportTo(Vector3.new(24.4, 32.0, 20.4), "Safe Rooftop")
end)

-- -------------------------------------------------------------
-- TAB 3: 🏃 PLAYER (Movement & Mobility)
-- -------------------------------------------------------------
local PlayerTab = CreateTab("Player", "🏃")
local MoveCol = CreateSection(PlayerTab.Left,  "Movement Stats")
local FlyCol  = CreateSection(PlayerTab.Right, "Flight & Tools")

local speedEnabled = false
local customSpeed  = 16
local jumpEnabled  = false
local customJump   = 50

AddSlider(MoveCol, "WalkSpeed", 16, 200, 16, function(val)
    customSpeed = val
    if speedEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end)

AddToggle(MoveCol, "Enable Speed Loop", false, function(v)
    speedEnabled = v
    if not v and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

AddSlider(MoveCol, "JumpPower", 50, 300, 50, function(val)
    customJump = val
    if jumpEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            if hum.UseJumpPower then hum.JumpPower = val else hum.JumpHeight = val * 0.144 end
        end
    end
end)

AddToggle(MoveCol, "Enable Jump Loop", false, function(v)
    jumpEnabled = v
    if not v and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            if hum.UseJumpPower then hum.JumpPower = 50 else hum.JumpHeight = 7.2 end
        end
    end
end)

table.insert(activeConnections, RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            if speedEnabled then hum.WalkSpeed = customSpeed end
            if jumpEnabled then
                if hum.UseJumpPower then hum.JumpPower = customJump else hum.JumpHeight = customJump * 0.144 end
            end
        end
    end
end))

local infJumpActive = false
AddToggle(MoveCol, "Infinite Jump", false, function(v)
    infJumpActive = v
end)

table.insert(activeConnections, UserInputService.JumpRequest:Connect(function()
    if infJumpActive and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

local noclipActive = false
AddToggle(MoveCol, "Noclip (Through Walls)", false, function(v)
    noclipActive = v
end)

table.insert(activeConnections, RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end))

local flyActive = false
local flySpeed  = 50
local flyBV     = nil
local flyBG     = nil
local flyConn   = nil

local function setFly(state)
    flyActive = state
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")

    if state and hrp and hum then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "MoonHub_FlyBV"
        flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp

        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "MoonHub_FlyBG"
        flyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        flyBG.CFrame = hrp.CFrame
        flyBG.Parent = hrp

        hum.PlatformStand = true

        flyConn = RunService.RenderStepped:Connect(function()
            if not flyActive or not hrp or not hum or not flyBV or not flyBG then return end
            local cam = workspace.CurrentCamera
            flyBG.CFrame = cam.CFrame

            local dir = Vector3.zero
            if not IS_MOBILE then
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    dir = (cam.CFrame:VectorToWorldSpace(Vector3.new(md.X, 0, md.Z))).Unit
                end
            end

            if dir.Magnitude > 0 then
                flyBV.Velocity = dir.Unit * flySpeed
            else
                flyBV.Velocity = Vector3.zero
            end
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        if hum then hum.PlatformStand = false end
    end
end

table.insert(cleanupCallbacks, function() setFly(false) end)

AddToggle(FlyCol, "Fly (PC & Mobile)", false, function(v)
    setFly(v)
end)

AddSlider(FlyCol, "Fly Speed", 10, 200, 50, function(val)
    flySpeed = val
end)

AddButton(FlyCol, "Reset Character", function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.Health = 0 end
    end
end)

-- -------------------------------------------------------------
-- TAB 4: ⚙️ SETTINGS (Info & Utils)
-- -------------------------------------------------------------
local SettingsTab = CreateTab("Settings", "⚙️")
local InfoCol = CreateSection(SettingsTab.Left,  "Status & Info")
local UtilCol = CreateSection(SettingsTab.Right, "Game Utilities")

AddLabel(InfoCol, "Place: Map1 (139542527731344)", Theme.Accent)
AddLabel(InfoCol, "Player: " .. LocalPlayer.Name, Theme.TextWhite)
AddLabel(InfoCol, "Platform: " .. (IS_MOBILE and "Mobile Touch" or "PC Keyboard"), Theme.TextMuted)

AddButton(InfoCol, "Copy Current Coordinates", function()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local text = string.format("Vector3.new(%.1f, %.1f, %.1f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        if setclipboard then
            setclipboard(text)
            Notify("Copied", text, 2.5)
        else
            print("MoonHub Pos:", text)
            Notify("Position", text, 2.5)
        end
    end
end)

local antiAfkActive = true
AddToggle(UtilCol, "Anti-AFK (No 20m Kick)", true, function(v)
    antiAfkActive = v
end)

table.insert(activeConnections, LocalPlayer.Idled:Connect(function()
    if antiAfkActive then
        local VirtualUser = game:GetService("VirtualUser")
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.zero)
        end)
    end
end))

AddButton(UtilCol, "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

AddButton(UtilCol, "Server Hop", function()
    pcall(function()
        local sf = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
        for _, s in ipairs(sf.data) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)

AddButton(UtilCol, "Unload Script (Close & Clean)", DestroyUI)

if not IS_MOBILE then
    table.insert(activeConnections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            ToggleMenuVisibility()
        end
    end))
end

Notify("🌙 MOONHUB", "Discord Auth Gate loaded! Please verify.", 3.5)