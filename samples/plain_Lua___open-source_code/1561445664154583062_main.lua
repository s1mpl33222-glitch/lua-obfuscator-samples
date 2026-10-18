-- pwd char remake, this is very buggy, you must equip the same body parts as char if you want it to work properly, it is open-source so you can check if it has keylogger or smth dangerous


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")


local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local targetParent = (gethui and gethui()) or CoreGui or PlayerGui

if targetParent:FindFirstChild("PwdCharInterface") then
    targetParent.PwdCharInterface:Destroy()
end


_G.UIVisible = true
_G.UIToggleKey = Enum.KeyCode.RightShift

local isAvatarEnabled = false
local isHeadlessEnabled = false
local targetUserInput = ""


local Theme = {
    AccentColor = Color3.fromRGB(145, 210, 240),
    DimColor = Color3.fromRGB(100, 150, 180),
    HighlightColor = Color3.fromRGB(255, 255, 255),
    BgColor = Color3.fromRGB(255, 255, 255),
    SectionBg = Color3.fromRGB(245, 250, 252),
    TrayColor = Color3.fromRGB(200, 225, 240),
    TextColor = Color3.fromRGB(100, 160, 200),
    DimTextColor = Color3.fromRGB(150, 185, 205),
    BorderColor = Color3.fromRGB(210, 230, 240),
    DarkBg = Color3.fromRGB(240, 248, 252),
    HeaderBg = Color3.fromRGB(220, 238, 248),
    ButtonBg = Color3.fromRGB(235, 245, 250),
    ApplyDefaultBg = Color3.fromRGB(245, 250, 253),
    ApplyBorder = Color3.fromRGB(215, 230, 240),
    ApplyDefaultText = Color3.fromRGB(165, 200, 220),
    ApplyActiveBg = Color3.fromRGB(160, 165, 175),
    ApplyActiveText = Color3.fromRGB(255, 255, 255)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PwdCharInterface"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetParent


local MobileToggleBtn
if IsMobile then
    MobileToggleBtn = Instance.new("ImageButton")
    MobileToggleBtn.Name = "MobileToggleBtn"
    MobileToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    MobileToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    MobileToggleBtn.BackgroundColor3 = Theme.HeaderBg
    MobileToggleBtn.BorderColor3 = Theme.AccentColor
    MobileToggleBtn.BorderSizePixel = 2
    MobileToggleBtn.Image = "rbxassetid://81412927404972"
    MobileToggleBtn.ScaleType = Enum.ScaleType.Fit
    MobileToggleBtn.ZIndex = 100
    MobileToggleBtn.Parent = ScreenGui

    local MobileBtnCorner = Instance.new("UICorner")
    MobileBtnCorner.CornerRadius = UDim.new(1, 0)
    MobileBtnCorner.Parent = MobileToggleBtn

    local mDragging, mDragStart, mStartPos
    MobileToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            mDragging = true
            mDragStart = input.Position
            mStartPos = MobileToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then mDragging = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if mDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - mDragStart
            MobileToggleBtn.Position = UDim2.new(mStartPos.Width.Scale, mStartPos.Width.Offset + delta.X, mStartPos.Height.Scale, mStartPos.Height.Offset + delta.Y)
        end
    end)
end


local WindowOuterBorder = Instance.new("Frame")
WindowOuterBorder.Name = "WindowOuterBorder"
WindowOuterBorder.Size = UDim2.new(0, 520, 0, 360)
WindowOuterBorder.Position = UDim2.new(0.5, -260, 0.5, -180)
WindowOuterBorder.BackgroundColor3 = Theme.TrayColor
WindowOuterBorder.BorderSizePixel = 0
WindowOuterBorder.Active = true
WindowOuterBorder.ClipsDescendants = true
WindowOuterBorder.Parent = ScreenGui

local OuterCorner = Instance.new("UICorner")
OuterCorner.CornerRadius = UDim.new(0, 10)
OuterCorner.Parent = WindowOuterBorder

local InnerSpacer = Instance.new("Frame")
InnerSpacer.Name = "InnerSpacer"
InnerSpacer.Size = UDim2.new(1, -2, 1, -2)
InnerSpacer.Position = UDim2.new(0, 1, 0, 1)
InnerSpacer.BackgroundColor3 = Theme.DarkBg
InnerSpacer.BorderSizePixel = 0
InnerSpacer.ClipsDescendants = true
InnerSpacer.Parent = WindowOuterBorder

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 9)
InnerCorner.Parent = InnerSpacer

local MainBody = Instance.new("Frame")
MainBody.Name = "MainBody"
MainBody.Size = UDim2.new(1, -2, 1, -2)
MainBody.Position = UDim2.new(0, 1, 0, 1)
MainBody.BackgroundColor3 = Theme.BgColor
MainBody.BorderColor3 = Theme.BorderColor
MainBody.BorderSizePixel = 1
MainBody.ClipsDescendants = true
MainBody.Parent = InnerSpacer

local BodyCorner = Instance.new("UICorner")
BodyCorner.CornerRadius = UDim.new(0, 8)
BodyCorner.Parent = MainBody

local HeaderBar = Instance.new("Frame")
HeaderBar.Name = "HeaderBar"
HeaderBar.Size = UDim2.new(1, 0, 0, 32)
HeaderBar.BackgroundColor3 = Theme.HeaderBg
HeaderBar.BorderSizePixel = 0
HeaderBar.ZIndex = 5
HeaderBar.Parent = MainBody

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = HeaderBar

local CinnamorollIcon = Instance.new("ImageLabel")
CinnamorollIcon.Size = UDim2.new(0, 22, 0, 22)
CinnamorollIcon.Position = UDim2.new(0, 10, 0.5, -11)
CinnamorollIcon.BackgroundTransparency = 1
CinnamorollIcon.Image = "rbxassetid://81412927404972"
CinnamorollIcon.ScaleType = Enum.ScaleType.Fit
CinnamorollIcon.ZIndex = 10
CinnamorollIcon.Parent = HeaderBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.5, 0, 1, 0)
TitleText.Position = UDim2.new(0, 38, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "pwd . CHAR"
TitleText.TextColor3 = Theme.TextColor
TitleText.TextSize = 13
TitleText.Font = Enum.Font.RobotoMono
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 6
TitleText.Parent = HeaderBar

local DateText = Instance.new("TextLabel")
DateText.Name = "DateText"
DateText.Size = UDim2.new(0.5, 0, 1, 0)
DateText.Position = UDim2.new(0.5, -15, 0, 0)
DateText.BackgroundTransparency = 1
DateText.Text = ""
DateText.TextColor3 = Theme.DimTextColor
DateText.TextSize = 11
DateText.Font = Enum.Font.RobotoMono
DateText.TextXAlignment = Enum.TextXAlignment.Right
DateText.ZIndex = 6
DateText.Parent = HeaderBar

local PinkLineAccent = Instance.new("Frame")
PinkLineAccent.Name = "PinkLineAccent"
PinkLineAccent.Size = UDim2.new(1, 0, 0, 2)
PinkLineAccent.Position = UDim2.new(0, 0, 1, 0)
PinkLineAccent.BackgroundColor3 = Theme.AccentColor
PinkLineAccent.BorderSizePixel = 0
PinkLineAccent.ZIndex = 10
PinkLineAccent.Parent = HeaderBar

local PinkHeaderGlow = Instance.new("Frame")
PinkHeaderGlow.Name = "PinkHeaderGlow"
PinkHeaderGlow.Size = UDim2.new(1, 0, 0, 20)
PinkHeaderGlow.Position = UDim2.new(0, 0, 1, 2)
PinkHeaderGlow.BackgroundColor3 = Theme.AccentColor
PinkHeaderGlow.BorderSizePixel = 0
PinkHeaderGlow.ZIndex = 4
PinkHeaderGlow.Parent = HeaderBar

local GlowGradient = Instance.new("UIGradient")
GlowGradient.Rotation = 90
GlowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.60),
    NumberSequenceKeypoint.new(0.5, 0.85),
    NumberSequenceKeypoint.new(1, 1)
})
GlowGradient.Parent = PinkHeaderGlow

local function updateClock()
    DateText.Text = os.date("%A, %d %B, %y")
end
updateClock()
task.spawn(function()
    while task.wait(60) do updateClock() end
end)

local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    WindowOuterBorder.Position = UDim2.new(startPos.Width.Scale, startPos.Width.Offset + delta.X, startPos.Height.Scale, startPos.Height.Offset + delta.Y)
end

HeaderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = WindowOuterBorder.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
HeaderBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)


local LayoutContent = Instance.new("Frame")
LayoutContent.Name = "LayoutContent"
LayoutContent.Size = UDim2.new(1, 0, 1, -32)
LayoutContent.Position = UDim2.new(0, 0, 0, 32)
LayoutContent.BackgroundTransparency = 1
LayoutContent.ClipsDescendants = true
LayoutContent.ZIndex = 2
LayoutContent.Parent = MainBody

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Theme.BgColor
Sidebar.BorderColor3 = Theme.BorderColor
Sidebar.BorderSizePixel = 1
Sidebar.ZIndex = 3
Sidebar.Parent = LayoutContent

local SidebarTab = Instance.new("TextButton")
SidebarTab.Size = UDim2.new(1, -16, 0, 24)
SidebarTab.Position = UDim2.new(0, 12, 0, 15)
SidebarTab.BackgroundTransparency = 1
SidebarTab.Text = "Avatar"
SidebarTab.TextColor3 = Theme.TextColor
SidebarTab.Font = Enum.Font.RobotoMono
SidebarTab.TextSize = 12
SidebarTab.TextXAlignment = Enum.TextXAlignment.Left
SidebarTab.Parent = Sidebar

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
SidebarDivider.BackgroundColor3 = Theme.BorderColor
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

local WorkspaceFrame = Instance.new("Frame")
WorkspaceFrame.Name = "WorkspaceFrame"
WorkspaceFrame.Size = UDim2.new(1, -120, 1, 0)
WorkspaceFrame.Position = UDim2.new(0, 120, 0, 0)
WorkspaceFrame.BackgroundTransparency = 1
WorkspaceFrame.ZIndex = 3
WorkspaceFrame.Parent = LayoutContent

local ContainerPadding = Instance.new("UIPadding")
ContainerPadding.PaddingTop = UDim.new(0, 20)
ContainerPadding.PaddingLeft = UDim.new(0, 20)
ContainerPadding.PaddingRight = UDim.new(0, 20)
ContainerPadding.PaddingBottom = UDim.new(0, 20)
ContainerPadding.Parent = WorkspaceFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 14)
UIList.Parent = WorkspaceFrame

local function CreateToggle(parent, text, defaultState, callback)
    local Row = Instance.new("Frame", parent)
    Row.Size = UDim2.new(1, 0, 0, 18)
    Row.BackgroundTransparency = 1

    local Box = Instance.new("TextButton", Row)
    Box.Size = UDim2.new(0, 12, 0, 12)
    Box.Position = UDim2.new(0, 0, 0.5, -6)
    Box.BackgroundColor3 = defaultState and Theme.AccentColor or Theme.ButtonBg
    Box.BorderColor3 = defaultState and Theme.AccentColor or Theme.BorderColor
    Box.BorderSizePixel = 1
    Box.Text = ""

    local Lbl = Instance.new("TextLabel", Row)
    Lbl.Size = UDim2.new(1, -22, 1, 0)
    Lbl.Position = UDim2.new(0, 22, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = defaultState and Theme.TextColor or Theme.DimTextColor
    Lbl.TextSize = 11
    Lbl.Font = Enum.Font.RobotoMono
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local state = defaultState
    local function updateState(newState)
        state = newState
        Box.BackgroundColor3 = state and Theme.AccentColor or Theme.ButtonBg
        Box.BorderColor3 = state and Theme.AccentColor or Theme.BorderColor
        Lbl.TextColor3 = state and Theme.TextColor or Theme.DimTextColor
    end

    Box.MouseButton1Click:Connect(function()
        updateState(not state)
        callback(state)
    end)

    return updateState
end

local function CreateInputGroup(parent, labelText, defaultVal, callback)
    local Group = Instance.new("Frame", parent)
    Group.Size = UDim2.new(1, 0, 0, 36)
    Group.BackgroundTransparency = 1

    local Lbl = Instance.new("TextLabel", Group)
    Lbl.Size = UDim2.new(1, 0, 0, 14)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = labelText
    Lbl.TextColor3 = Theme.DimTextColor
    Lbl.TextSize = 11
    Lbl.Font = Enum.Font.RobotoMono
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local TxtBox = Instance.new("TextBox", Group)
    TxtBox.Size = UDim2.new(1, 0, 0, 20)
    TxtBox.Position = UDim2.new(0, 0, 0, 16)
    TxtBox.BackgroundColor3 = Theme.DarkBg
    TxtBox.BorderColor3 = Theme.BorderColor
    TxtBox.BorderSizePixel = 1
    TxtBox.Text = defaultVal or ""
    TxtBox.PlaceholderText = "Enter User ID or Username"
    TxtBox.TextColor3 = Theme.TextColor
    TxtBox.PlaceholderColor3 = Theme.DimTextColor
    TxtBox.Font = Enum.Font.RobotoMono
    TxtBox.TextSize = 11
    TxtBox.TextXAlignment = Enum.TextXAlignment.Left
    
    local BoxPadding = Instance.new("UIPadding", TxtBox)
    BoxPadding.PaddingLeft = UDim.new(0, 6)

    TxtBox:GetPropertyChangedSignal("Text"):Connect(function()
        callback(TxtBox.Text)
    end)
    return Group
end

local bindingKey = false
local function CreateKeybindGroup(parent, labelText, defaultKey, callback)
    local Row = Instance.new("Frame", parent)
    Row.Size = UDim2.new(1, 0, 0, 22)
    Row.BackgroundTransparency = 1

    local Lbl = Instance.new("TextLabel", Row)
    Lbl.Size = UDim2.new(0, 120, 1, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = labelText
    Lbl.TextColor3 = Theme.DimTextColor
    Lbl.TextSize = 11
    Lbl.Font = Enum.Font.RobotoMono
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local BBtn = Instance.new("TextButton", Row)
    BBtn.Size = UDim2.new(0, 100, 1, 0)
    BBtn.Position = UDim2.new(1, -100, 0, 0)
    BBtn.BackgroundColor3 = Theme.DarkBg
    BBtn.BorderColor3 = Theme.BorderColor
    BBtn.BorderSizePixel = 1
    BBtn.Text = "[" .. defaultKey.Name .. "]"
    BBtn.TextColor3 = Theme.DimTextColor
    BBtn.Font = Enum.Font.RobotoMono
    BBtn.TextSize = 11

    BBtn.MouseButton1Click:Connect(function()
        bindingKey = true
        BBtn.Text = "..."
        BBtn.TextColor3 = Theme.AccentColor
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if bindingKey and input.UserInputType == Enum.UserInputType.Keyboard then
            bindingKey = false
            _G.UIToggleKey = input.KeyCode
            BBtn.Text = "[" .. input.KeyCode.Name .. "]"
            BBtn.TextColor3 = Theme.DimTextColor
            callback(input.KeyCode)
        end
    end)
end

CreateToggle(WorkspaceFrame, "Enable Avatar", isAvatarEnabled, function(v) isAvatarEnabled = v end)

CreateInputGroup(WorkspaceFrame, "Enter User ID or Username to Char", targetUserInput, function(v) targetUserInput = v end)

CreateToggle(WorkspaceFrame, "Visual Headless", isHeadlessEnabled, function(v) isHeadlessEnabled = v end)


if not IsMobile then
    CreateKeybindGroup(WorkspaceFrame, "UI Toggle Key", _G.UIToggleKey, function(k) end)
end

local updateShowUIToggle = CreateToggle(WorkspaceFrame, "Show UI", _G.UIVisible, function(v)
    _G.UIVisible = v
    WindowOuterBorder.Visible = _G.UIVisible
end)


local function toggleUIState()
    _G.UIVisible = not _G.UIVisible
    WindowOuterBorder.Visible = _G.UIVisible
    updateShowUIToggle(_G.UIVisible)
end


if IsMobile then
    MobileToggleBtn.MouseButton1Click:Connect(function()
        toggleUIState()
    end)
else
    UIS.InputBegan:Connect(function(input, gpe)
        if bindingKey or gpe then return end
        if input.KeyCode == _G.UIToggleKey then
            toggleUIState()
        end
    end)
end

local ApplyBtn = Instance.new("TextButton", WorkspaceFrame)
ApplyBtn.Size = UDim2.new(1, 0, 0, 28)
ApplyBtn.BackgroundColor3 = Theme.ApplyDefaultBg
ApplyBtn.BorderColor3 = Theme.ApplyBorder
ApplyBtn.BorderSizePixel = 1
ApplyBtn.Text = "Apply & Reset Character"
ApplyBtn.TextColor3 = Theme.ApplyDefaultText
ApplyBtn.Font = Enum.Font.RobotoMono
ApplyBtn.TextSize = 12

ApplyBtn.MouseButton1Down:Connect(function()
    ApplyBtn.BackgroundColor3 = Theme.ApplyActiveBg
    ApplyBtn.TextColor3 = Theme.ApplyActiveText
    ApplyBtn.BorderSizePixel = 0
end)

ApplyBtn.MouseButton1Up:Connect(function()
    ApplyBtn.BackgroundColor3 = Theme.ApplyDefaultBg
    ApplyBtn.TextColor3 = Theme.ApplyDefaultText
    ApplyBtn.BorderColor3 = Theme.ApplyBorder
    ApplyBtn.BorderSizePixel = 1
end)

ApplyBtn.MouseLeave:Connect(function()
    ApplyBtn.BackgroundColor3 = Theme.ApplyDefaultBg
    ApplyBtn.TextColor3 = Theme.ApplyDefaultText
    ApplyBtn.BorderColor3 = Theme.ApplyBorder
    ApplyBtn.BorderSizePixel = 1
end)

local function getUserIdFromInput(input)
    input = tostring(input):gsub("%s+", ""):gsub("^@", "")
    if input == "" then return nil end
    
    local id = tonumber(input)
    if id then return id end
    
    local success, result = pcall(function()
        return Players:GetUserIdFromNameAsync(input)
    end)
    
    if success and result then
        return result
    end
    return nil
end

local function applyAnimationsFromDummy(char, dummyModel)
    local myAnimate = char:FindFirstChild("Animate")
    local dummyAnimate = dummyModel:FindFirstChild("Animate")
    local myHumanoid = char:FindFirstChildOfClass("Humanoid")

    if not myAnimate or not dummyAnimate or not myHumanoid then return end

    local animator = myHumanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end

    for _, dummyChild in ipairs(dummyAnimate:GetChildren()) do
        local myChild = myAnimate:FindFirstChild(dummyChild.Name)
        if myChild then
            for _, animObj in ipairs(dummyChild:GetChildren()) do
                if animObj:IsA("Animation") then
                    local targetAnim = myChild:FindFirstChild(animObj.Name)
                    if targetAnim and targetAnim:IsA("Animation") then
                        targetAnim.AnimationId = animObj.AnimationId
                    else
                        local cloneAnim = animObj:Clone()
                        cloneAnim.Parent = myChild
                    end
                end
            end
        end
    end

    myAnimate.Disabled = true
    task.wait(0.05)
    myAnimate.Disabled = false
end

local function applyFullOutfit(char)
    if not isAvatarEnabled or targetUserInput == "" then return end
    
    local id = getUserIdFromInput(targetUserInput)
    if not id then return end

    task.spawn(function()
        local myHumanoid = char:WaitForChild("Humanoid", 5)
        if not myHumanoid then return end

        local success, dummyModel = pcall(function()
            return Players:CreateHumanoidModelFromUserId(id)
        end)
        if not success or not dummyModel then return end

        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") then
                obj:Destroy()
            end
        end

        pcall(function()
            local dummyHum = dummyModel:FindFirstChildOfClass("Humanoid")
            if dummyHum then
                local humDesc = dummyHum:GetAppliedDescription()
                if humDesc then
                    myHumanoid:ApplyDescription(humDesc)
                end
            end
        end)

        local targetColors = dummyModel:FindFirstChildOfClass("BodyColors")
        if targetColors then 
            local oldColors = char:FindFirstChildOfClass("BodyColors")
            if oldColors then oldColors:Destroy() end
            targetColors:Clone().Parent = char 
        end

        for _, item in ipairs(dummyModel:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") then
                item:Clone().Parent = char
            end
        end

        for _, dPart in ipairs(dummyModel:GetChildren()) do
            if dPart:IsA("MeshPart") and dPart.Name ~= "Head" then
                local myPart = char:FindFirstChild(dPart.Name)
                if myPart and myPart:IsA("MeshPart") then
                    pcall(function()
                        myPart.MeshId = dPart.MeshId
                        myPart.TextureID = dPart.TextureID
                    end)
                end
            end
        end

        local targetHead = dummyModel:FindFirstChild("Head")
        local myHead = char:FindFirstChild("Head")
        
        if targetHead and myHead then
            local oldFake = char:FindFirstChild("FakeHead")
            if oldFake then oldFake:Destroy() end

            for _, child in ipairs(myHead:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") or child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") or child:IsA("WrapTarget") then
                    child:Destroy()
                end
            end

            myHead.Color = targetHead.Color

            local successMesh = false
            if targetHead:IsA("MeshPart") and myHead:IsA("MeshPart") then
                successMesh = pcall(function()
                    myHead.MeshId = targetHead.MeshId
                    myHead.TextureID = targetHead.TextureID
                end)
            end

            for _, child in ipairs(targetHead:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("Decal") or child:IsA("SurfaceAppearance") then
                    child:Clone().Parent = myHead
                end
            end

            if targetHead:IsA("MeshPart") and not successMesh then
                myHead.Transparency = 1
                
                local fakeHead = targetHead:Clone()
                fakeHead.Name = "FakeHead"
                fakeHead.CanCollide = false
                fakeHead.Parent = char

                local weld = Instance.new("Weld")
                weld.Name = "FakeHeadWeld"
                weld.Part0 = myHead
                weld.Part1 = fakeHead
                weld.C0 = CFrame.new()
                weld.C1 = CFrame.new()
                weld.Parent = fakeHead
            else
                myHead.Transparency = targetHead.Transparency
            end
        end

        for _, item in ipairs(dummyModel:GetChildren()) do
            if item:IsA("Accessory") then
                local accClone = item:Clone()
                local handle = accClone:FindFirstChild("Handle")
                
                if handle then
                    handle.CanCollide = false
                    accClone.Parent = char
                    
                    local handleAttachment = handle:FindFirstChildOfClass("Attachment")
                    if handleAttachment then
                        local targetAttachment = nil
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then
                                local att = p:FindFirstChild(handleAttachment.Name)
                                if att and att:IsA("Attachment") then
                                    targetAttachment = att
                                    break
                                end
                            end
                        end

                        if targetAttachment then
                            local weld = Instance.new("Weld")
                            weld.Name = "AccessoryWeld"
                            weld.Part0 = handle
                            weld.Part1 = targetAttachment.Parent
                            weld.C0 = handleAttachment.CFrame
                            weld.C1 = targetAttachment.CFrame
                            weld.Parent = handle
                        end
                    else
                        local head = char:FindFirstChild("Head")
                        if head then
                            local weld = Instance.new("Weld")
                            weld.Name = "AccessoryWeld"
                            weld.Part0 = handle
                            weld.Part1 = head
                            weld.C0 = CFrame.new()
                            weld.C1 = CFrame.new()
                            weld.Parent = handle
                        end
                    end
                end
            end
        end

        applyAnimationsFromDummy(char, dummyModel)

        if isHeadlessEnabled then
            task.wait(0.1)
            if myHead then
                myHead.Transparency = 1
                local face = myHead:FindFirstChildOfClass("Decal")
                if face then face.Transparency = 1 end
                
                local fakeHead = char:FindFirstChild("FakeHead")
                if fakeHead then fakeHead.Transparency = 1 end
            end
        end

        dummyModel:Destroy()
    end)
end

local function resetCharacter()
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    else
        char:BreakJoints()
    end
end
LocalPlayer.CharacterAdded:Connect(function(newChar)
    if isAvatarEnabled and targetUserInput ~= "" then
        task.wait(0.5)
        applyFullOutfit(newChar)
    end
end)

ApplyBtn.MouseButton1Click:Connect(function()
    resetCharacter()
end)
