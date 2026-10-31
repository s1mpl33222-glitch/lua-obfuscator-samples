--==================================================
-- ELLA AVATAR - INSTANT OUTFIT & ANIMATION COPY
--==================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local targetParent = (gethui and gethui()) or CoreGui or PlayerGui

if targetParent:FindFirstChild("EllarougHoodCustomUI") then
    targetParent.EllarougHoodCustomUI:Destroy()
end

_G.UIVisible = true
_G.UIToggleKey = Enum.KeyCode.RightControl

local isAvatarEnabled = true
local isAnimationEnabled = true
local isHeadlessEnabled = false
local targetUserInput = ""

-- Cozy Latte & Cream Theme Palette
local currentTheme = {
    ACCENT = Color3.fromRGB(185, 164, 147),
    BG = Color3.fromRGB(245, 242, 235),
    CARD_BG = Color3.fromRGB(250, 248, 243),
    CARD = Color3.fromRGB(238, 234, 226),
    SOFT_TEXT = Color3.fromRGB(75, 65, 55),
    SUB_TEXT = Color3.fromRGB(135, 118, 104),
    LIGHT_BTN = Color3.fromRGB(230, 224, 215),
    TOGGLE_OFF = Color3.fromRGB(215, 208, 198),
    STROKE = Color3.fromRGB(205, 194, 182),
    SLIDER_BG = Color3.fromRGB(230, 224, 215)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EllarougHoodCustomUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10000
ScreenGui.Parent = targetParent

-- Mobile Toggle Button
local MobileToggleBtn
if IsMobile then
    MobileToggleBtn = Instance.new("ImageButton")
    MobileToggleBtn.Name = "MobileToggleBtn"
    MobileToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    MobileToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    MobileToggleBtn.BackgroundColor3 = currentTheme.CARD
    MobileToggleBtn.BorderColor3 = currentTheme.ACCENT
    MobileToggleBtn.BorderSizePixel = 2
    MobileToggleBtn.Image = "rbxassetid://6023426915"
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
            MobileToggleBtn.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y)
        end
    end)
end

-- Main Window Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.ClipsDescendants = true
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = currentTheme.BG
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = currentTheme.ACCENT
MainStroke.Thickness = 2

-- Profile Avatar Thumbnail Frame on Left
local AvatarHolder = Instance.new("Frame", Main)
AvatarHolder.Size = UDim2.new(0, 38, 0, 38)
AvatarHolder.Position = UDim2.new(0, 8, 0, 4)
AvatarHolder.BackgroundColor3 = currentTheme.CARD
AvatarHolder.BorderSizePixel = 0
Instance.new("UICorner", AvatarHolder).CornerRadius = UDim.new(0, 8)
local AvatarStroke = Instance.new("UIStroke", AvatarHolder)
AvatarStroke.Color = currentTheme.STROKE
AvatarStroke.Thickness = 1

local AvatarImg = Instance.new("ImageLabel", AvatarHolder)
AvatarImg.Size = UDim2.new(1, 0, 1, 0)
AvatarImg.BackgroundTransparency = 1
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(0, 8)

task.spawn(function()
    pcall(function()
        local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
        AvatarImg.Image = content
    end)
end)

-- Header Bar
local Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, -60, 0, 45)
Header.Position = UDim2.new(0, 52, 0, 0)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 0, 18)
Title.Position = UDim2.new(0, 5, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "♡ ella avatar ♡"
Title.TextColor3 = currentTheme.SOFT_TEXT
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local UserSubTitle = Instance.new("TextLabel", Header)
UserSubTitle.Size = UDim2.new(1, 0, 0, 15)
UserSubTitle.Position = UDim2.new(0, 5, 0, 22)
UserSubTitle.BackgroundTransparency = 1
UserSubTitle.Text = LocalPlayer.DisplayName .. " - id: " .. LocalPlayer.UserId
UserSubTitle.TextColor3 = currentTheme.SUB_TEXT
UserSubTitle.TextSize = 10
UserSubTitle.Font = Enum.Font.GothamBold
UserSubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Window Dragging Logic
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Main Content Box
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -16, 1, -60)
Content.Position = UDim2.new(0, 8, 0, 50)
Content.BackgroundColor3 = currentTheme.CARD_BG
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local pageScroll = Instance.new("ScrollingFrame", Content)
pageScroll.Size = UDim2.new(1, -12, 1, -12)
pageScroll.Position = UDim2.new(0, 6, 0, 6)
pageScroll.BackgroundTransparency = 1
pageScroll.BorderSizePixel = 0
pageScroll.ScrollBarThickness = 3
pageScroll.ScrollBarImageColor3 = currentTheme.ACCENT

local pList = Instance.new("UIListLayout", pageScroll)
pList.SortOrder = Enum.SortOrder.LayoutOrder
pList.Padding = UDim.new(0, 8)

pList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    pageScroll.CanvasSize = UDim2.new(0, 0, 0, pList.AbsoluteContentSize.Y + 12)
end)

local headerFrame = Instance.new("Frame", pageScroll)
headerFrame.Size = UDim2.new(1, 0, 0, 32)
headerFrame.BackgroundTransparency = 1

local pTitle = Instance.new("TextLabel", headerFrame)
pTitle.Size = UDim2.new(1, 0, 0, 18)
pTitle.BackgroundTransparency = 1
pTitle.Text = "♡ instant character & anim studio ♡"
pTitle.TextColor3 = currentTheme.SOFT_TEXT
pTitle.Font = Enum.Font.SourceSansBold
pTitle.TextSize = 14
pTitle.TextXAlignment = Enum.TextXAlignment.Left

local pDesc = Instance.new("TextLabel", headerFrame)
pDesc.Size = UDim2.new(1, 0, 0, 14)
pDesc.Position = UDim2.new(0, 0, 0, 18)
pDesc.BackgroundTransparency = 1
pDesc.Text = "copy outfits and animation packs instantly"
pDesc.TextColor3 = currentTheme.SUB_TEXT
pDesc.Font = Enum.Font.GothamBold
pDesc.TextSize = 10
pDesc.TextXAlignment = Enum.TextXAlignment.Left

local function createCard(height)
    local card = Instance.new("Frame", pageScroll)
    card.Size = UDim2.new(1, -4, 0, height or 36)
    card.BackgroundColor3 = currentTheme.CARD
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", card)
    s.Color = currentTheme.STROKE
    s.Thickness = 1
    return card
end

local function addToggle(text, subtext, default, callback)
    local card = createCard(36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.65, 0, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", card)
    sub.Size = UDim2.new(0.65, 0, 0, 14)
    sub.Position = UDim2.new(0, 10, 0, 18)
    sub.BackgroundTransparency = 1
    sub.Text = subtext or ""
    sub.TextColor3 = currentTheme.SUB_TEXT
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 36, 0, 18)
    btn.Position = UDim2.new(1, -44, 0, 9)
    btn.BackgroundColor3 = default and currentTheme.ACCENT or currentTheme.TOGGLE_OFF
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    local function setToggleState(newState)
        state = newState
        btn.BackgroundColor3 = state and currentTheme.ACCENT or currentTheme.TOGGLE_OFF
        circle:TweenPosition(
            state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true
        )
        callback(state)
    end

    btn.MouseButton1Click:Connect(function() setToggleState(not state) end)
    return setToggleState
end

local applyFullOutfitLive

local function addInputGroup(labelText, defaultVal, callback)
    local card = createCard(44)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -20, 0, 15)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local TxtBox = Instance.new("TextBox", card)
    TxtBox.Size = UDim2.new(1, -20, 0, 20)
    TxtBox.Position = UDim2.new(0, 10, 0, 20)
    TxtBox.BackgroundColor3 = currentTheme.BG
    TxtBox.BorderSizePixel = 0
    TxtBox.Text = defaultVal or ""
    TxtBox.PlaceholderText = "Enter User ID or Username"
    TxtBox.TextColor3 = currentTheme.SOFT_TEXT
    TxtBox.PlaceholderColor3 = currentTheme.SUB_TEXT
    TxtBox.Font = Enum.Font.GothamBold
    TxtBox.TextSize = 11
    TxtBox.TextXAlignment = Enum.TextXAlignment.Left
    
    Instance.new("UICorner", TxtBox).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", TxtBox)
    stroke.Color = currentTheme.STROKE

    TxtBox.FocusLost:Connect(function()
        callback(TxtBox.Text)
        if applyFullOutfitLive and LocalPlayer.Character then
            applyFullOutfitLive(LocalPlayer.Character)
        end
    end)
end

-- Controls
addToggle("Enable Avatar Copy", "live outfit synchronization", isAvatarEnabled, function(v) 
    isAvatarEnabled = v 
    if isAvatarEnabled and LocalPlayer.Character then
        applyFullOutfitLive(LocalPlayer.Character)
    end
end)

addToggle("Copy Character Animations", "use target's walk/idle pack", isAnimationEnabled, function(v) 
    isAnimationEnabled = v 
    if isAnimationEnabled and LocalPlayer.Character then
        applyFullOutfitLive(LocalPlayer.Character)
    end
end)

addInputGroup("Target Username or User ID", targetUserInput, function(v) 
    targetUserInput = v 
end)

addToggle("Visual Headless", "hide head mesh instantly", isHeadlessEnabled, function(v) 
    isHeadlessEnabled = v 
    if LocalPlayer.Character then
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then
            head.Transparency = isHeadlessEnabled and 1 or 0
            local face = head:FindFirstChildOfClass("Decal")
            if face then face.Transparency = isHeadlessEnabled and 1 or 0 end
        end
    end
end)

-- Keybind Row
local cardKey = createCard(36)
local keyLbl = Instance.new("TextLabel", cardKey)
keyLbl.Size = UDim2.new(0.65, 0, 1, 0)
keyLbl.Position = UDim2.new(0, 10, 0, 0)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = "UI Toggle Key"
keyLbl.TextColor3 = currentTheme.SOFT_TEXT
keyLbl.Font = Enum.Font.SourceSansBold
keyLbl.TextSize = 12
keyLbl.TextXAlignment = Enum.TextXAlignment.Left

local bindingKey = false
local keyBtn = Instance.new("TextButton", cardKey)
keyBtn.Size = UDim2.new(0, 52, 0, 22)
keyBtn.Position = UDim2.new(1, -58, 0.5, -11)
keyBtn.BackgroundColor3 = currentTheme.LIGHT_BTN
keyBtn.Text = _G.UIToggleKey.Name
keyBtn.TextColor3 = currentTheme.SOFT_TEXT
keyBtn.Font = Enum.Font.SourceSansBold
keyBtn.TextSize = 11
keyBtn.AutoButtonColor = false
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

keyBtn.MouseButton1Click:Connect(function()
    if bindingKey then return end
    bindingKey = true
    keyBtn.Text = "..."
    keyBtn.BackgroundColor3 = currentTheme.ACCENT
    keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local connection
    connection = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local newKey = input.KeyCode
            _G.UIToggleKey = newKey
            keyBtn.Text = newKey.Name
            keyBtn.BackgroundColor3 = currentTheme.LIGHT_BTN
            keyBtn.TextColor3 = currentTheme.SOFT_TEXT
            bindingKey = false
            connection:Disconnect()
        end
    end)
end)

local updateShowUIToggle = addToggle("Show UI", "toggle window visibility", _G.UIVisible, function(v)
    _G.UIVisible = v
    Main.Visible = _G.UIVisible
end)

local function toggleUIState()
    _G.UIVisible = not _G.UIVisible
    Main.Visible = _G.UIVisible
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

-- Animation Sync Function
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

-- Realtime Outfit & Animation Copy Logic
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

applyFullOutfitLive = function(char)
    if not isAvatarEnabled or targetUserInput == "" or not char then return end
    
    local id = getUserIdFromInput(targetUserInput)
    if not id then return end

    task.spawn(function()
        local myHumanoid = char:WaitForChild("Humanoid", 5)
        if not myHumanoid then return end

        local success, dummyModel = pcall(function()
            return Players:CreateHumanoidModelFromUserId(id)
        end)
        if not success or not dummyModel then return end

        -- Remove existing character accessories/outfit
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

        -- Copy target character animations
        if isAnimationEnabled then
            applyAnimationsFromDummy(char, dummyModel)
        end

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

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if isAvatarEnabled and targetUserInput ~= "" then
        task.wait(0.5)
        applyFullOutfitLive(newChar)
    end
end)
