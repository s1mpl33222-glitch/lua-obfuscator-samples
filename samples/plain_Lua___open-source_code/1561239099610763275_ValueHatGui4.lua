local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UIModule = {}
UIModule.__index = UIModule

-- 定義 UI 的唯一名稱 (重複執行時自動刪除舊版)
local GUI_NAME = "Apex_V90_Sea"

-- --- 自動刪除舊 GUI ---
local CoreGui = game:GetService("CoreGui")
local oldGui = CoreGui:FindFirstChild(GUI_NAME)
if oldGui then
    oldGui:Destroy()
end

-- 通用工具：支援「TextScaled 自動縮放」+「TextWrapped 自動換行」
local function applyTextSettings(textObject, minSize, maxSize)
    textObject.TextScaled = true
    textObject.TextWrapped = true -- 支援自動換行
    
    local oldConstraint = textObject:FindFirstChildOfClass("UITextSizeConstraint")
    if oldConstraint then oldConstraint:Destroy() end

    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MinTextSize = minSize or 8
    constraint.MaxTextSize = maxSize or 16 -- 提高上限，讓字體能放大
    constraint.Parent = textObject
end

-- --- 1. 建立 UI 主視窗 (:CreateWindow) ---
function UIModule.CreateWindow(titleText, footerText)
    local self = setmetatable({}, UIModule)

    local ApexHub = Instance.new("ScreenGui")
    ApexHub.Name = GUI_NAME
    ApexHub.Parent = CoreGui
    self.Gui = ApexHub

    -- 主面板
    local Main = Instance.new("Frame")
    Main.Parent = ApexHub
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -130, 0.5, -200)
    Main.Size = UDim2.new(0, 260, 0, 100)
    Main.Active = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    -- GUI 外框（深藍色）
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(0, 70, 180)
    UIStroke.Parent = Main

    -- 標題文字
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, -45, 0, 40)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = titleText or "MY HUB"
    Title.TextColor3 = Color3.fromRGB(255, 220, 50)
    Title.Font = Enum.Font.LuckiestGuy
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 標題放大範圍：10pt ~ 20pt
    applyTextSettings(Title, 10, 20)

    self.TitleLabel = Title

    local TitleStroke = Instance.new("UIStroke")
    TitleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    TitleStroke.Thickness = 2.5
    TitleStroke.Color = Color3.fromRGB(0, 0, 0)
    TitleStroke.Parent = Title

    -- 內容容器 (ScrollingFrame)
    local Content = Instance.new("ScrollingFrame")
    Content.Parent = Main
    Content.Position = UDim2.new(0, 12, 0, 42)
    Content.Size = UDim2.new(1, -24, 0, 0)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 0
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Content = Content

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Content
    UIList.Padding = UDim.new(0, 6)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.UIList = UIList

    -- 右上角縮小按鈕
    local isMinimized = false
    local MINIMIZED_SIZE = UDim2.new(0, 260, 0, 42)
    
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 22, 0, 22)
    MinBtn.Position = UDim2.new(1, -30, 0, 10)
    MinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.FredokaOne
    MinBtn.TextSize = 16
    MinBtn.Parent = Main

    local MinBtnCorner = Instance.new("UICorner")
    MinBtnCorner.CornerRadius = UDim.new(0, 5)
    MinBtnCorner.Parent = MinBtn

    local MinBtnStroke = Instance.new("UIStroke")
    MinBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    MinBtnStroke.Thickness = 1.5
    MinBtnStroke.Color = Color3.fromRGB(0, 0, 0)
    MinBtnStroke.Parent = MinBtn

    -- 自動調整高度邏輯
    local TITLE_PADDING = 52
    local MAX_HEIGHT = 350

    local function updateMainSize()
        if not isMinimized then
            local contentHeight = UIList.AbsoluteContentSize.Y
            local targetContentHeight = math.min(contentHeight, MAX_HEIGHT)
            
            Content.Size = UDim2.new(1, -24, 0, targetContentHeight)
            Main.Size = UDim2.new(0, 260, 0, targetContentHeight + TITLE_PADDING)
        end
    end
    self.UpdateSize = updateMainSize
    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateMainSize)

    -- 縮小功能
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Content.Visible = false
            Main.Size = MINIMIZED_SIZE
            MinBtn.Text = "+"
        else
            Content.Visible = true
            updateMainSize()
            MinBtn.Text = "-"
        end
    end)

    -- 拖曳邏輯
    local dragToggle, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- 頁尾標籤
    if footerText then
        local Footer = Instance.new("TextLabel")
        Footer.Size = UDim2.new(0.9, 0, 0, 20)
        Footer.BackgroundTransparency = 1
        Footer.Text = footerText
        Footer.TextColor3 = Color3.fromRGB(0, 255, 200)
        Footer.Font = Enum.Font.FredokaOne
        Footer.Parent = Content
        applyTextSettings(Footer, 8, 14)

        local FooterStroke = Instance.new("UIStroke")
        FooterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        FooterStroke.Thickness = 1.5
        FooterStroke.Color = Color3.fromRGB(0, 0, 0)
        FooterStroke.Parent = Footer
    end

    return self
end

-- --- 2. 動態修改標題 (:SetTitle) ---
function UIModule:SetTitle(newTitle)
    if self.TitleLabel then
        self.TitleLabel.Text = tostring(newTitle)
    end
end

-- --- 3. 清空內容 (:Clear) ---
function UIModule:Clear()
    for _, child in ipairs(self.Content:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    self.UpdateSize()
end

-- --- 4. 普通按鈕 (:CreateButton) ---
-- 可選擇性傳入 maxFontSize 參數 (預設 16pt，最小 8pt)
function UIModule:CreateButton(txt, cb, maxFontSize)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.AutomaticSize = Enum.AutomaticSize.Y -- 超過兩行自動拉高按鈕
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.FredokaOne
    btn.Parent = self.Content

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 4)
    UIPadding.Parent = btn

    -- 動態放大文字：8pt ~ 16pt (或傳入值)
    applyTextSettings(btn, 8, maxFontSize or 16)
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    BtnStroke.Thickness = 1.5
    BtnStroke.Color = Color3.fromRGB(0, 0, 0)
    BtnStroke.Parent = btn
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if cb then cb(btn) end
    end)
    
    self.UpdateSize()
    return btn
end

-- --- 5. 開關按鈕 (:CreateToggle) ---
function UIModule:CreateToggle(txt, defaultState, cb, maxFontSize)
    local state = defaultState or false
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.AutomaticSize = Enum.AutomaticSize.Y
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = ""
    btn.Parent = self.Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    BtnStroke.Thickness = 1.5
    BtnStroke.Color = Color3.fromRGB(0, 0, 0)
    BtnStroke.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -38, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = txt
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    applyTextSettings(label, 8, maxFontSize or 15)

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 18, 0, 18)
    box.Position = UDim2.new(1, -26, 0.5, -9)
    box.Parent = btn
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box
    
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Color = Color3.fromRGB(0, 0, 0)
    boxStroke.Parent = box

    local function updateState()
        if state then
            box.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        else
            box.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
    end
    
    updateState()

    btn.MouseButton1Click:Connect(function()
        state = not state
        updateState()
        if cb then cb(state) end
    end)
    
    self.UpdateSize()
    return btn
end

-- --- 6. 滑桿 (:CreateSlider) ---
function UIModule:CreateSlider(txt, min, max, default, cb)
    min = min or 0
    max = max or 100
    default = math.clamp(default or min, min, max)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = self.Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = frame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 1.5
    frameStroke.Color = Color3.fromRGB(0, 0, 0)
    frameStroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    applyTextSettings(label, 8, 14)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 6)
    track.Position = UDim2.new(0, 8, 0, 23)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    track.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    local dragging = false

    local function updateVal(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = txt .. ": " .. tostring(val)
        if cb then cb(val) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateVal(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateVal(input)
        end
    end)

    self.UpdateSize()
    return frame
end

-- --- 7. 下拉選單 (:CreateDropdown) ---
function UIModule:CreateDropdown(txt, options, default, cb)
    options = options or {}
    local selected = default or (options[1] or "None")
    local isOpen = false

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(0.92, 0, 0, 32)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Parent = self.Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = dropdownFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 1.5
    mainStroke.Color = Color3.fromRGB(0, 0, 0)
    mainStroke.Parent = dropdownFrame

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, -28, 0, 32)
    mainBtn.Position = UDim2.new(0, 6, 0, 0)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = txt .. ": " .. tostring(selected)
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.Font = Enum.Font.FredokaOne
    mainBtn.TextXAlignment = Enum.TextXAlignment.Left
    mainBtn.Parent = dropdownFrame
    applyTextSettings(mainBtn, 8, 15)

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 0, 32)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.Font = Enum.Font.FredokaOne
    arrow.TextSize = 10
    arrow.Parent = dropdownFrame

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -12, 0, 0)
    container.Position = UDim2.new(0, 6, 0, 32)
    container.BackgroundTransparency = 1
    container.Parent = dropdownFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = container

    local function toggleDropdown()
        isOpen = not isOpen
        arrow.Text = isOpen and "▲" or "▼"
        
        if isOpen then
            local totalHeight = listLayout.AbsoluteContentSize.Y + 38
            dropdownFrame.Size = UDim2.new(0.92, 0, 0, totalHeight)
        else
            dropdownFrame.Size = UDim2.new(0.92, 0, 0, 32)
        end
        self.UpdateSize()
    end

    mainBtn.MouseButton1Click:Connect(toggleDropdown)

    for _, optionText in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 24)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        optBtn.Text = optionText
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        optBtn.Font = Enum.Font.FredokaOne
        optBtn.Parent = container
        applyTextSettings(optBtn, 8, 14)

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 4)
        optCorner.Parent = optBtn

        optBtn.MouseButton1Click:Connect(function()
            selected = optionText
            mainBtn.Text = txt .. ": " .. tostring(selected)
            toggleDropdown()
            if cb then cb(selected) end
        end)
    end

    self.UpdateSize()
    return dropdownFrame
end

-- --- 8. 輸入框 (:CreateInput) ---
function UIModule:CreateInput(txt, placeholder, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = self.Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = frame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 1.5
    frameStroke.Color = Color3.fromRGB(0, 0, 0)
    frameStroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = txt
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    applyTextSettings(label, 8, 14)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.5, -8, 0, 22)
    textBox.Position = UDim2.new(0.5, 0, 0.5, -11)
    textBox.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or "輸入..."
    textBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 150)
    textBox.TextColor3 = Color3.fromRGB(0, 255, 120)
    textBox.Font = Enum.Font.FredokaOne
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    applyTextSettings(textBox, 8, 14)

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = textBox

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1
    boxStroke.Color = Color3.fromRGB(0, 0, 0)
    boxStroke.Parent = textBox

    textBox.FocusLost:Connect(function(enterPressed)
        if cb then
            cb(textBox.Text, enterPressed)
        end
    end)

    self.UpdateSize()
    return frame
end

-- --- 9. 銷毀 UI (:Destroy) ---
function UIModule:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

return UIModule
