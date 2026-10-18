local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local parent = (gethui and gethui()) or game:GetService("CoreGui")

local old = parent:FindFirstChild("MonochromeHelper")
if old then
    old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonochromeHelper"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(390, 330)
Main.Position = UDim2.new(0.5, -195, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(48, 51, 60)
Stroke.Transparency = 0.25
Stroke.Thickness = 1
Stroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 67)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(18, 11)
Title.Size = UDim2.new(1, -110, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Monochrome Helper"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Credit = Instance.new("TextLabel")
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.fromOffset(18, 35)
Credit.Size = UDim2.new(1, -110, 0, 18)
Credit.Font = Enum.Font.Gotham
Credit.Text = "by HanzoRTX"
Credit.TextColor3 = Color3.fromRGB(125, 128, 140)
Credit.TextSize = 12
Credit.TextXAlignment = Enum.TextXAlignment.Left
Credit.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.BackgroundTransparency = 1
Minimize.Position = UDim2.new(1, -82, 0, 13)
Minimize.Size = UDim2.fromOffset(34, 34)
Minimize.Font = Enum.Font.GothamMedium
Minimize.Text = "—"
Minimize.TextSize = 18
Minimize.TextColor3 = Color3.fromRGB(150, 152, 160)
Minimize.AutoButtonColor = false
Minimize.Parent = Header

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -48, 0, 13)
Close.Size = UDim2.fromOffset(34, 34)
Close.Font = Enum.Font.GothamMedium
Close.Text = "×"
Close.TextSize = 23
Close.TextColor3 = Color3.fromRGB(150, 152, 160)
Close.AutoButtonColor = false
Close.Parent = Header

local Divider = Instance.new("Frame")
Divider.Position = UDim2.fromOffset(0, 66)
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(39, 41, 48)
Divider.Parent = Main

local Section = Instance.new("TextLabel")
Section.BackgroundTransparency = 1
Section.Position = UDim2.fromOffset(18, 78)
Section.Size = UDim2.new(1, -36, 0, 20)
Section.Font = Enum.Font.GothamBold
Section.Text = "MAIN"
Section.TextSize = 11
Section.TextColor3 = Color3.fromRGB(110, 113, 125)
Section.TextXAlignment = Enum.TextXAlignment.Left
Section.Parent = Main

local Container = Instance.new("Frame")
Container.BackgroundTransparency = 1
Container.Position = UDim2.fromOffset(14, 105)
Container.Size = UDim2.new(1, -28, 0, 174)
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

local function createAction(titleText, description, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 52)
    Row.BackgroundColor3 = Color3.fromRGB(23, 24, 29)
    Row.BorderSizePixel = 0
    Row.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Row

    local Name = Instance.new("TextLabel")
    Name.BackgroundTransparency = 1
    Name.Position = UDim2.fromOffset(13, 7)
    Name.Size = UDim2.new(1, -100, 0, 19)
    Name.Font = Enum.Font.GothamMedium
    Name.Text = titleText
    Name.TextColor3 = Color3.fromRGB(232, 233, 238)
    Name.TextSize = 13
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Row

    local Description = Instance.new("TextLabel")
    Description.BackgroundTransparency = 1
    Description.Position = UDim2.fromOffset(13, 27)
    Description.Size = UDim2.new(1, -100, 0, 16)
    Description.Font = Enum.Font.Gotham
    Description.Text = description
    Description.TextColor3 = Color3.fromRGB(115, 118, 130)
    Description.TextSize = 10
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = Row

    local Button = Instance.new("TextButton")
    Button.AnchorPoint = Vector2.new(1, 0.5)
    Button.Position = UDim2.new(1, -10, 0.5, 0)
    Button.Size = UDim2.fromOffset(66, 30)
    Button.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Font = Enum.Font.GothamBold
    Button.Text = "RUN"
    Button.TextColor3 = Color3.fromRGB(220, 222, 230)
    Button.TextSize = 10
    Button.Parent = Row

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 7)
    ButtonCorner.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(55, 58, 68)}
        ):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(41, 43, 51)}
        ):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        Button.Text = "..."

        local success = pcall(callback)

        if success then
            Button.Text = "DONE"
        else
            Button.Text = "ERROR"
        end

        task.wait(1)
        Button.Text = "RUN"
    end)
end

createAction(
    "Auto Pry",
    "Automatically interact with pry points",
    function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        hrp.CFrame = CFrame.new(241.531, 21.665, -313.530)

        local function triggerPrompt(prompt)
            if prompt and prompt:IsA("ProximityPrompt") then
                fireproximityprompt(prompt)
            end
        end

        local monochrome = workspace:WaitForChild("monochrome")

        triggerPrompt(monochrome["Cube.008"].PryPromptPoint.PryPrompt)
        triggerPrompt(monochrome["Cube.009"].PryPromptPoint.PryPrompt)
        triggerPrompt(monochrome["Cube.010"].PryPromptPoint.PryPrompt)
        triggerPrompt(monochrome["Cube.011"].PryPromptPoint.PryPrompt)
        triggerPrompt(monochrome["Cube.012"].PryPromptPoint.PryPrompt)
    end
)

createAction(
    "Get Code",
    "Read the current code note",
    function()
        local digitsObject = workspace:WaitForChild("monochrome")
            :WaitForChild("CodeNote")
            :WaitForChild("Printed")
            :WaitForChild("Digits")

        local codeText = digitsObject.Text

        task.spawn(function()
            local success = false

            while not success do
                success = pcall(function()
                    StarterGui:SetCore("SendNotification", {
                        Title = "Code Note",
                        Text = codeText,
                        Duration = 5
                    })
                end)

                if not success then
                    task.wait(0.5)
                end
            end
        end)
    end
)

createAction(
    "Get Keys",
    "Automatically collect hidden keys",
    function()
        local noclipConnection

        local function getCharacterParts()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")

            return character, rootPart, humanoid
        end

        local function setNoclip(enable)
            if enable then
                if not noclipConnection then
                    noclipConnection = RunService.Stepped:Connect(function()
                        local character = LocalPlayer.Character

                        if character then
                            for _, part in ipairs(character:GetDescendants()) do
                                if part:IsA("BasePart") and part.CanCollide then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end)
                end
            else
                if noclipConnection then
                    noclipConnection:Disconnect()
                    noclipConnection = nil
                end

                local character = LocalPlayer.Character

                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end

        local function setFloating(enable)
            local character, rootPart, humanoid = getCharacterParts()

            local existingPlatform = character:FindFirstChild("FloatPlatform")
            local existingVelocity = rootPart:FindFirstChild("FloatBodyVelocity")

            if enable then
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

                if not existingVelocity then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Name = "FloatBodyVelocity"
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(0, 1e6, 0)
                    bodyVelocity.Parent = rootPart
                end

                if not existingPlatform then
                    local platform = Instance.new("Part")
                    platform.Name = "FloatPlatform"
                    platform.Size = Vector3.new(6, 1, 6)
                    platform.Transparency = 1
                    platform.Anchored = true
                    platform.CanCollide = true
                    platform.CFrame = rootPart.CFrame * CFrame.new(0, -3.5, 0)
                    platform.Parent = character
                else
                    existingPlatform.CFrame = rootPart.CFrame * CFrame.new(0, -3.5, 0)
                end
            else
                if existingPlatform then
                    existingPlatform:Destroy()
                end

                if existingVelocity then
                    existingVelocity:Destroy()
                end
            end
        end

        local function safeTeleport(targetCFrame)
            local _, rootPart = getCharacterParts()

            rootPart.CFrame = targetCFrame
            setFloating(true)
            task.wait(0.25)
        end

        local function safeFirePrompt(prompt)
            if prompt and prompt:IsA("ProximityPrompt") then
                if fireproximityprompt then
                    fireproximityprompt(prompt)
                else
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration)
                    prompt:InputHoldEnd()
                end

                task.wait(0.3)
            end
        end

        setNoclip(true)
        setFloating(true)

        local monochrome = workspace:WaitForChild("monochrome")

        for i = 1, 4 do
            local keyFolderName = "HiddenKey" .. i
            local keyFolder = monochrome:FindFirstChild(keyFolderName)

            if keyFolder then
                local keyModel = keyFolder:FindFirstChild("Key")

                local keyHandle =
                    keyFolder:FindFirstChild("KeyHandle")
                    or (keyModel and keyModel:FindFirstChild("KeyHandle"))

                local keyTargetCFrame =
                    keyHandle and keyHandle.CFrame
                    or (keyModel and keyModel:GetPivot())
                    or keyFolder:GetPivot()

                safeTeleport(keyTargetCFrame)

                local drawerName

                if keyHandle then
                    drawerName = keyHandle:GetAttribute("RidesDrawer")
                end

                if drawerName and monochrome:FindFirstChild(drawerName) then
                    local drawer = monochrome[drawerName]

                    local drawerCFrame =
                        drawer:IsA("Model")
                        and drawer:GetPivot()
                        or drawer.CFrame

                    safeTeleport(drawerCFrame)

                    local drawerPromptPoint = drawer:FindFirstChild("DrawerPromptPoint")

                    local drawerPrompt =
                        drawerPromptPoint
                        and drawerPromptPoint:FindFirstChild("DrawerPrompt")

                    safeFirePrompt(drawerPrompt)
                end

                local keyPromptPoint =
                    keyModel
                    and keyModel:FindFirstChild("KeyPromptPoint")

                local keyPrompt =
                    keyPromptPoint
                    and keyPromptPoint:FindFirstChild("KeyPrompt")

                safeFirePrompt(keyPrompt)
            end
        end

        safeTeleport(CFrame.new(254.540, 21.665, -313.882))

        task.wait(0.5)

        setFloating(false)
        setNoclip(false)
    end
)

local FooterLine = Instance.new("Frame")
FooterLine.Position = UDim2.new(0, 0, 1, -39)
FooterLine.Size = UDim2.new(1, 0, 0, 1)
FooterLine.BackgroundColor3 = Color3.fromRGB(39, 41, 48)
FooterLine.BorderSizePixel = 0
FooterLine.Parent = Main

local Footer = Instance.new("TextLabel")
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 18, 1, -31)
Footer.Size = UDim2.new(1, -36, 0, 20)
Footer.Font = Enum.Font.Gotham
Footer.Text = UserInputService.TouchEnabled
    and "Tap — to minimize"
    or "RightShift  •  Toggle UI"
Footer.TextSize = 10
Footer.TextColor3 = Color3.fromRGB(100, 103, 115)
Footer.TextXAlignment = Enum.TextXAlignment.Left
Footer.Parent = Main

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.fromOffset(52, 52)
MiniButton.Position = UDim2.new(0, 20, 0.5, -26)
MiniButton.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
MiniButton.BorderSizePixel = 0
MiniButton.Text = "M"
MiniButton.TextColor3 = Color3.fromRGB(235, 235, 240)
MiniButton.TextSize = 18
MiniButton.Font = Enum.Font.GothamBold
MiniButton.AutoButtonColor = false
MiniButton.Visible = false
MiniButton.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(55, 58, 68)
MiniStroke.Transparency = 0.2
MiniStroke.Thickness = 1
MiniStroke.Parent = MiniButton

local function minimizeUI()
    Main.Visible = false
    MiniButton.Visible = true
end

local function restoreUI()
    MiniButton.Visible = false
    Main.Visible = true
end

Minimize.MouseButton1Click:Connect(minimizeUI)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local dragging = false
local dragStart
local startPosition
local activeDragInput

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
        activeDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input == activeDragInput then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == activeDragInput
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        activeDragInput = nil
    end
end)

local miniDragging = false
local miniDragStart
local miniStartPosition
local miniDragInput
local miniMoved = false

MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniMoved = false
        miniDragStart = input.Position
        miniStartPosition = MiniButton.Position
        miniDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not miniDragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input == miniDragInput then
        local delta = input.Position - miniDragStart

        if delta.Magnitude > 6 then
            miniMoved = true
        end

        MiniButton.Position = UDim2.new(
            miniStartPosition.X.Scale,
            miniStartPosition.X.Offset + delta.X,
            miniStartPosition.Y.Scale,
            miniStartPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == miniDragInput
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        miniDragging = false
        miniDragInput = nil
    end
end)

MiniButton.MouseButton1Click:Connect(function()
    if miniMoved then
        miniMoved = false
        return
    end

    restoreUI()
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        if MiniButton.Visible then
            restoreUI()
        else
            Main.Visible = not Main.Visible
        end
    end
end)
