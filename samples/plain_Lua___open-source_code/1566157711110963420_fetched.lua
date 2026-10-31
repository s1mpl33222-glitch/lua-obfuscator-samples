-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("LocHUDAllButtons") then
    CoreGui.LocHUDAllButtons:Destroy()
end

-- ScreenGui chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LocHUDAllButtons"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 🍵 MÀU SẮC GREEN TEA / MATCHA
local ColorTeaDark = Color3.fromRGB(26, 38, 29)
local ColorTeaTitle = Color3.fromRGB(38, 56, 42)
local ColorTeaAccent = Color3.fromRGB(120, 180, 110)
local ColorTeaBtnOff = Color3.fromRGB(180, 70, 70)
local ColorTeaBtnOn = Color3.fromRGB(85, 150, 90)
local ColorTeaBtnSingle = Color3.fromRGB(50, 80, 60)
local ColorTeaPlus = Color3.fromRGB(40, 65, 48)

-- Biến quản lý khóa nút
local isButtonsLocked = false

-- 1. NÚT TRÒN THU GỌN / DI CHUYỂN MENU CHÍNH
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Name = "ToggleMenuBtn"
ToggleMenuBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleMenuBtn.Position = UDim2.new(0, 20, 0, 150)
ToggleMenuBtn.BackgroundColor3 = ColorTeaTitle
ToggleMenuBtn.Text = "🍵"
ToggleMenuBtn.TextSize = 22
ToggleMenuBtn.Parent = ScreenGui

local UICornerCircle = Instance.new("UICorner")
UICornerCircle.CornerRadius = UDim.new(1, 0)
UICornerCircle.Parent = ToggleMenuBtn

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Thickness = 2.5
CircleStroke.Color = ColorTeaAccent
CircleStroke.Parent = ToggleMenuBtn

local CircleGradient = Instance.new("UIGradient")
CircleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 127, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(139, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
})
CircleGradient.Parent = CircleStroke

-- Kéo thả nút tròn chính
local draggingCircle, dragStartCircle, startPosCircle
ToggleMenuBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingCircle = true
        dragStartCircle = input.Position
        startPosCircle = ToggleMenuBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingCircle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingCircle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartCircle
        ToggleMenuBtn.Position = UDim2.new(startPosCircle.X.Scale, startPosCircle.X.Offset + delta.X, startPosCircle.Y.Scale, startPosCircle.Y.Offset + delta.Y)
    end
end)

-- 2. MENU GIAO DIỆN CHÍNH (Tăng chiều cao để chứa thêm nút)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 335)
MainFrame.Position = UDim2.new(0, 75, 0, 150)
MainFrame.BackgroundColor3 = ColorTeaDark
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICornerFrame = Instance.new("UICorner")
UICornerFrame.CornerRadius = UDim.new(0, 14)
UICornerFrame.Parent = MainFrame

local UIStrokeFrame = Instance.new("UIStroke")
UIStrokeFrame.Thickness = 2.5
UIStrokeFrame.Color = Color3.fromRGB(255, 255, 255)
UIStrokeFrame.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = CircleGradient.Color
MainGradient.Parent = UIStrokeFrame

-- Thanh Tiêu Đề
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = ColorTeaTitle
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 14)
UICornerTitle.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🍵 Lộc HUD - Multi Action"
TitleText.TextColor3 = Color3.fromRGB(220, 245, 215)
TitleText.TextSize = 11
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = MainFrame

-- ----------------------------------------------------
-- HÀM TẠO NÚT CHỨC NĂNG CÓ NÚT [+] ĐỘC LẬP
-- ----------------------------------------------------
local function createFeatureRow(posY, defaultText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 0, 28)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = ColorTeaBtnOff
    btn.Text = defaultText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 35, 0, 28)
    plusBtn.Position = UDim2.new(0, 142, 0, posY)
    plusBtn.BackgroundColor3 = ColorTeaPlus
    plusBtn.Text = "+"
    plusBtn.TextColor3 = ColorTeaAccent
    plusBtn.TextSize = 14
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.Parent = MainFrame

    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 8)
    plusCorner.Parent = plusBtn

    local detachedFloatingBtn = nil

    -- Click nút chính trong menu
    btn.MouseButton1Click:Connect(function()
        callback(btn, detachedFloatingBtn)
    end)

    -- Click dấu [+] để bật/tắt nút độc lập
    plusBtn.MouseButton1Click:Connect(function()
        if detachedFloatingBtn then
            detachedFloatingBtn:Destroy()
            detachedFloatingBtn = nil
            plusBtn.BackgroundColor3 = ColorTeaPlus
            return
        end

        plusBtn.BackgroundColor3 = ColorTeaBtnOn

        detachedFloatingBtn = Instance.new("TextButton")
        detachedFloatingBtn.Size = UDim2.new(0, 50, 0, 50)
        detachedFloatingBtn.Position = UDim2.new(0, 200, 0, 200)
        detachedFloatingBtn.BackgroundColor3 = btn.BackgroundColor3
        detachedFloatingBtn.Text = defaultText:match("([^:%s]+)") or "Btn"
        detachedFloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        detachedFloatingBtn.TextSize = 9
        detachedFloatingBtn.Font = Enum.Font.GothamBold
        detachedFloatingBtn.Parent = ScreenGui

        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(1, 0)
        fCorner.Parent = detachedFloatingBtn

        local fStroke = Instance.new("UIStroke")
        fStroke.Thickness = 2
        fStroke.Color = ColorTeaAccent
        fStroke.Parent = detachedFloatingBtn

        -- Kéo thả nút độc lập (Bị khóa nếu bật Khóa Nút)
        local draggingF, dragStartF, startPosF
        detachedFloatingBtn.InputBegan:Connect(function(input)
            if not isButtonsLocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                draggingF = true
                dragStartF = input.Position
                startPosF = detachedFloatingBtn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingF = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not isButtonsLocked and draggingF and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartF
                detachedFloatingBtn.Position = UDim2.new(startPosF.X.Scale, startPosF.X.Offset + delta.X, startPosF.Y.Scale, startPosF.Y.Offset + delta.Y)
            end
        end)

        detachedFloatingBtn.MouseButton1Click:Connect(function()
            callback(btn, detachedFloatingBtn)
        end)
    end)
end

-- ----------------------------------------------------
-- ĐỊNH NGHĨA CÁC CHỨC NĂNG
-- ----------------------------------------------------

-- 1. AUTO F
local isPressingF = false
createFeatureRow(42, "AUTO F: OFF", function(mainBtn, floatBtn)
    isPressingF = not isPressingF
    if isPressingF then
        mainBtn.Text = "AUTO F: ON"
        mainBtn.BackgroundColor3 = ColorTeaBtnOn
        if floatBtn then 
            floatBtn.Text = "ON"
            floatBtn.BackgroundColor3 = ColorTeaBtnOn
        end
        
        task.spawn(function()
            while isPressingF do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                task.wait(0.05)
            end
        end)
    else
        mainBtn.Text = "AUTO F: OFF"
        mainBtn.BackgroundColor3 = ColorTeaBtnOff
        if floatBtn then 
            floatBtn.Text = "OFF"
            floatBtn.BackgroundColor3 = ColorTeaBtnOff
        end
    end
end)

-- 2. ẤN F (1 LẦN)
createFeatureRow(78, "⚡ ẤN F (1 LẦN)", function(_, _)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.001)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end)

-- 3. ẤN Q (1 LẦN)
createFeatureRow(114, "🎯 ẤN Q (1 LẦN)", function(_, _)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    task.wait(0.001)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
end)

-- 4. PHÍM CÁCH (SPACEBAR - 1 LẦN)
createFeatureRow(150, "☁️ PHÍM CÁCH", function(_, _)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.001)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)

-- 5. PHÍM SỐ 1 (KEY 1 - 1 LẦN)
createFeatureRow(186, "🔢 PHÍM SỐ 1", function(_, _)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
    task.wait(0.001)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
end)

-- 6. NÚT CỐ ĐỊNH VỊ TRÍ NÚT (LOCK / PIN BUTTONS)
local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, 167, 0, 28)
LockBtn.Position = UDim2.new(0, 10, 0, 222)
LockBtn.BackgroundColor3 = ColorTeaBtnOff
LockBtn.Text = "🔒 KHÓA NÚT: OFF"
LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBtn.TextSize = 10
LockBtn.Font = Enum.Font.GothamBold
LockBtn.Parent = MainFrame

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockBtn

LockBtn.MouseButton1Click:Connect(function()
    isButtonsLocked = not isButtonsLocked
    if isButtonsLocked then
        LockBtn.Text = "🔒 KHÓA NÚT: ON"
        LockBtn.BackgroundColor3 = ColorTeaBtnOn
    else
        LockBtn.Text = "🔒 KHÓA NÚT: OFF"
        LockBtn.BackgroundColor3 = ColorTeaBtnOff
    end
end)

-- Dòng thông tin hướng dẫn
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 0, 18)
InfoText.Position = UDim2.new(0, 0, 0, 260)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Added Space & Key 1!"
InfoText.TextColor3 = ColorTeaAccent
InfoText.TextSize = 9
InfoText.Font = Enum.Font.Gotham
InfoText.Parent = MainFrame

-- Hiệu ứng viền 7 màu cầu vồng
RunService.RenderStepped:Connect(function()
    local rot = (tick() * 120) % 360
    MainGradient.Rotation = rot
    CircleGradient.Rotation = rot
end)

-- Kéo thả Menu chính
local draggingMenu, dragStartMenu, startPosMenu
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = true
        dragStartMenu = input.Position
        startPosMenu = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMenu = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMenu
        MainFrame.Position = UDim2.new(startPosMenu.X.Scale, startPosMenu.X.Offset + delta.X, startPosMenu.Y.Scale, startPosMenu.Y.Offset + delta.Y)
    end
end)

-- ẨN / HIỆN MENU KHI BẤM NÚT TRÒN 🍵
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
