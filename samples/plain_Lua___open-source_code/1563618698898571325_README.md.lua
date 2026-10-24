-- الفذايح برعاية ريان 😂

local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local DataService = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("DataService")

-- ══════════════════════════════════════════
--       السكربت الأصلي (يشتغل دائماً)
-- ══════════════════════════════════════════

local sentMessages = {}
local isScanning   = false

local adminBlacklist = {
    "nv", "re", "logs", "clogs", "cmds", "fly", "unfly", "speed", "jump", "sit",
    "ban", "kick", "kill", "respawn", "loopkill", "freeze", "thaw", "bring", "to"
}

print("--- سكريبت القراءة العكسية الأحدث فالأحدث (سرعة 0.4) جاهز! ---")

local function getCleanMessage(fullText)
    local cleanText = nil
    local bracketIndex = string.find(fullText, "%]%s*:")
    if bracketIndex then
        cleanText = string.sub(fullText, bracketIndex + 2)
    else
        local colonIndex = string.find(fullText, ":")
        if colonIndex then
            cleanText = string.sub(fullText, colonIndex + 1)
        end
    end
    if cleanText then
        return cleanText:gsub("^%s*", ""):gsub("%s*$", "")
    end
    return nil
end

local function isAdminCommand(text)
    local lowerText = string.lower(text)
    local firstWord = string.match(lowerText, "%a+") or ""
    for _, command in ipairs(adminBlacklist) do
        if firstWord == command or string.find(lowerText, "%f[%a]" .. command .. "%f[%A]") then
            return true
        end
    end
    return false
end

local function scanContainerProtected(container)
    if isScanning then return end
    isScanning = true

    task.wait(0.2)

    local allLabels = {}
    for _, textLabel in ipairs(container:GetDescendants()) do
        if textLabel:IsA("TextLabel") and textLabel.Text ~= "" then
            table.insert(allLabels, textLabel)
        end
    end

    local messagesToFire = {}

    for i = #allLabels, 1, -1 do
        local textLabel = allLabels[i]
        local fullText  = textLabel.Text

        if not string.find(fullText, LocalPlayer.Name) and not sentMessages[fullText] then
            local cleanText = getCleanMessage(fullText)
            if cleanText and cleanText ~= "" then
                if not isAdminCommand(cleanText) then
                    sentMessages[fullText] = true
                    table.insert(messagesToFire, cleanText)
                else
                    print("🚫 تم حظر أمر آدمن مكتشف: " .. cleanText)
                end
            end
        end
    end

    task.spawn(function()
        for _, msg in ipairs(messagesToFire) do
            print("🚀 إرسال سريع وعكسي (0.4): " .. msg)
            pcall(function()
                DataService:FireServer(msg)
            end)
            task.wait(0.4)
        end
        isScanning = false
    end)
end

-- مراقبة HDAdmin
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function setupMonitoring(gui)
    gui.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "MessageContainer" or descendant:IsA("ScrollingFrame") then
            descendant.ChildAdded:Connect(function()
                scanContainerProtected(descendant)
            end)
        end
    end)
end

local HDAdminInterface = PlayerGui:FindFirstChild("HDAdminInterface")
if HDAdminInterface then setupMonitoring(HDAdminInterface) end

PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "HDAdminInterface" then setupMonitoring(child) end
end)

-- ══════════════════════════════════════════
--                 الـ GUI
-- ══════════════════════════════════════════

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("AlFathaich"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "AlFathaich"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local _ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- حافة RGB
local RGBBorder = Instance.new("Frame")
RGBBorder.Size             = UDim2.new(0, 324, 0, 224)
RGBBorder.Position         = UDim2.new(0.5, -162, 0.5, -112)
RGBBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
RGBBorder.BorderSizePixel  = 0
RGBBorder.ZIndex           = 1
RGBBorder.Parent           = ScreenGui
Instance.new("UICorner", RGBBorder).CornerRadius = UDim.new(0, 13)

-- الإطار الرئيسي
local Main = Instance.new("Frame")
Main.Name                   = "Main"
Main.Size                   = UDim2.new(0, 318, 0, 218)
Main.Position               = UDim2.new(0.5, -159, 0.5, -109)
Main.BackgroundColor3       = Color3.fromRGB(8, 30, 12)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel        = 0
Main.ZIndex                 = 2
Main.Parent                 = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 11)

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size               = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3   = Color3.fromRGB(4, 52, 16)
TitleBar.BackgroundTransparency = 0.05
TitleBar.BorderSizePixel    = 0
TitleBar.ZIndex             = 3
TitleBar.Parent             = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 11)

local TBFix = Instance.new("Frame")
TBFix.Size                  = UDim2.new(1, 0, 0, 10)
TBFix.Position              = UDim2.new(0, 0, 1, -10)
TBFix.BackgroundColor3      = Color3.fromRGB(4, 52, 16)
TBFix.BackgroundTransparency = 0.05
TBFix.BorderSizePixel       = 0
TBFix.ZIndex                = 3
TBFix.Parent                = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size               = UDim2.new(1, -12, 1, 0)
TitleLbl.Position           = UDim2.new(0, 10, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text               = "الفذايح برعاية ريان 😂"
TitleLbl.TextColor3         = Color3.fromRGB(100, 255, 148)
TitleLbl.TextSize           = 14
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextXAlignment     = Enum.TextXAlignment.Center
TitleLbl.ZIndex             = 4
TitleLbl.Parent             = TitleBar

-- لوحة النص التوضيحي
local InfoFrame = Instance.new("Frame")
InfoFrame.Size               = UDim2.new(1, -16, 0, 120)
InfoFrame.Position           = UDim2.new(0, 8, 0, 44)
InfoFrame.BackgroundColor3   = Color3.fromRGB(5, 45, 14)
InfoFrame.BackgroundTransparency = 0.25
InfoFrame.BorderSizePixel    = 0
InfoFrame.ZIndex             = 3
InfoFrame.Parent             = Main
Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 8)

local InfoPad = Instance.new("UIPadding")
InfoPad.PaddingLeft   = UDim.new(0, 10)
InfoPad.PaddingRight  = UDim.new(0, 10)
InfoPad.PaddingTop    = UDim.new(0, 8)
InfoPad.PaddingBottom = UDim.new(0, 8)
InfoPad.Parent        = InfoFrame

local InfoLbl = Instance.new("TextLabel")
InfoLbl.Size                = UDim2.new(1, 0, 1, 0)
InfoLbl.BackgroundTransparency = 1
InfoLbl.Text                = "اضغط ابدا حتى تحصل على ال clogs وننقل الشات.\n\nكل ما تصير سالفة جديدة بالسيرفر اضغط ابدا مرة ثانية وراح تطلع لك.\n\nحاليا الفكرة تحت التطوير لذالك تجاهل لائحة ال clogs الي قدامك ولا تحذفها واضغط Load more لو في كثير كلام."
InfoLbl.TextColor3          = Color3.fromRGB(190, 255, 210)
InfoLbl.TextSize            = 12
InfoLbl.Font                = Enum.Font.Gotham
InfoLbl.TextXAlignment      = Enum.TextXAlignment.Right
InfoLbl.TextYAlignment      = Enum.TextYAlignment.Top
InfoLbl.TextWrapped         = true
InfoLbl.ZIndex              = 4
InfoLbl.Parent              = InfoFrame

-- زر ابدا
local StartBtn = Instance.new("TextButton")
StartBtn.Size               = UDim2.new(1, -16, 0, 34)
StartBtn.Position           = UDim2.new(0, 8, 0, 172)
StartBtn.BackgroundColor3   = Color3.fromRGB(0, 135, 52)
StartBtn.BackgroundTransparency = 0.05
StartBtn.Text               = "▶  ابدا"
StartBtn.TextColor3         = Color3.fromRGB(210, 255, 220)
StartBtn.TextSize           = 15
StartBtn.Font               = Enum.Font.GothamBold
StartBtn.BorderSizePixel    = 0
StartBtn.ZIndex             = 3
StartBtn.Parent             = Main
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 8)

local SBStroke = Instance.new("UIStroke", StartBtn)
SBStroke.Color     = Color3.fromRGB(0, 255, 100)
SBStroke.Thickness = 1.5

-- الدائرة الصغيرة
local MiniBtn = Instance.new("TextButton")
MiniBtn.Name                = "MiniToggle"
MiniBtn.Size                = UDim2.new(0, 36, 0, 36)
MiniBtn.Position            = UDim2.new(0, 10, 0.5, -18)
MiniBtn.BackgroundColor3    = Color3.fromRGB(8, 28, 11)
MiniBtn.BackgroundTransparency = 0.05
MiniBtn.Text                = "●"
MiniBtn.TextColor3          = Color3.fromRGB(0, 255, 100)
MiniBtn.TextSize            = 17
MiniBtn.Font                = Enum.Font.GothamBold
MiniBtn.BorderSizePixel     = 0
MiniBtn.ZIndex              = 10
MiniBtn.Parent              = ScreenGui
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)

local MiniRGB = Instance.new("Frame")
MiniRGB.Size                = UDim2.new(1, 7, 1, 7)
MiniRGB.Position            = UDim2.new(0, -3.5, 0, -3.5)
MiniRGB.BackgroundColor3    = Color3.fromRGB(0, 255, 100)
MiniRGB.BorderSizePixel     = 0
MiniRGB.ZIndex              = 9
MiniRGB.Parent              = MiniBtn
Instance.new("UICorner", MiniRGB).CornerRadius = UDim.new(1, 0)

-- ══════════════════════════════════════════
--          سحب يدوي (Delta Safe)
-- ══════════════════════════════════════════

local dragging, dragStart, dragStartPos = false, nil, nil

TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragging     = true
        dragStart    = inp.Position
        dragStartPos = Main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement
    and inp.UserInputType ~= Enum.UserInputType.Touch then return end
    local d  = inp.Position - dragStart
    local nx = dragStartPos.X.Offset + d.X
    local ny = dragStartPos.Y.Offset + d.Y
    Main.Position      = UDim2.new(dragStartPos.X.Scale, nx, dragStartPos.Y.Scale, ny)
    RGBBorder.Position = UDim2.new(dragStartPos.X.Scale, nx - 3, dragStartPos.Y.Scale, ny - 3)
end)

-- ══════════════════════════════════════════
--               المنطق
-- ══════════════════════════════════════════

-- زر ابدا: يرسل ;clogs عبر ريموت HD Admin مباشرة (بدون ما يمر بالشات)
local HDSignal = ReplicatedStorage
    :WaitForChild("HDAdminHDClient")
    :WaitForChild("Signals")
    :WaitForChild("RequestCommandModification")

StartBtn.MouseButton1Click:Connect(function()
    TweenService:Create(StartBtn, TweenInfo.new(0.08), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.1)
    TweenService:Create(StartBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.05}):Play()

    pcall(function()
        HDSignal:InvokeServer(";clogs")
    end)

    print("✅ تم إرسال ;clogs عبر HD Admin")
end)

-- إخفاء / إظهار
local guiVisible = true

local function hideGui()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size     = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset + 159,
                             Main.Position.Y.Scale,  Main.Position.Y.Offset + 109)
    }):Play()
    TweenService:Create(RGBBorder, TweenInfo.new(0.23, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.28)
    Main.Visible       = false
    RGBBorder.Visible  = false
    guiVisible         = false
    MiniBtn.TextColor3 = Color3.fromRGB(255, 65, 65)
end

local function showGui()
    Main.Visible      = true
    RGBBorder.Visible = true
    Main.Size         = UDim2.new(0, 0, 0, 0)
    RGBBorder.Size    = UDim2.new(0, 0, 0, 0)
    TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, 318, 0, 218),
        Position = UDim2.new(0.5, -159, 0.5, -109)
    }):Play()
    TweenService:Create(RGBBorder, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, 324, 0, 224),
        Position = UDim2.new(0.5, -162, 0.5, -112)
    }):Play()
    guiVisible         = true
    MiniBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
end

-- سحب الدائرة الصغيرة
local miniDragging    = false
local miniDragStart   = nil
local miniDragStartPos = nil
local miniMoved       = false  -- نفرّق بين الضغط والسحب

MiniBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        miniDragging     = true
        miniMoved        = false
        miniDragStart    = inp.Position
        miniDragStartPos = MiniBtn.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                miniDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if not miniDragging then return end
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement
    and inp.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = inp.Position - miniDragStart
    -- لو تحرك أكثر من 4 بكسل = سحب مش ضغطة
    if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then
        miniMoved = true
    end
    if miniMoved then
        local nx = miniDragStartPos.X.Offset + d.X
        local ny = miniDragStartPos.Y.Offset + d.Y
        MiniBtn.Position = UDim2.new(miniDragStartPos.X.Scale, nx,
                                     miniDragStartPos.Y.Scale, ny)
    end
end)

-- النقر يشغّل الإخفاء/الإظهار فقط لو ما صار سحب
local toggling = false
MiniBtn.MouseButton1Up:Connect(function()
    if miniMoved then return end  -- كان سحب، ما نشغّل toggle
    if toggling then return end
    toggling = true
    TweenService:Create(MiniBtn, TweenInfo.new(0.09), {
        Size = UDim2.new(0, 42, 0, 42),
        Position = UDim2.new(MiniBtn.Position.X.Scale, MiniBtn.Position.X.Offset - 3,
                             MiniBtn.Position.Y.Scale, MiniBtn.Position.Y.Offset - 3)
    }):Play()
    task.wait(0.1)
    TweenService:Create(MiniBtn, TweenInfo.new(0.1), {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(MiniBtn.Position.X.Scale, MiniBtn.Position.X.Offset + 3,
                             MiniBtn.Position.Y.Scale, MiniBtn.Position.Y.Offset + 3)
    }):Play()
    if guiVisible then hideGui() else showGui() end
    task.wait(0.36)
    toggling = false
end)

-- RGB للحواف + حركة الدائرة
local hue      = 0
local miniAngle = 0

-- إطار دوران للدائرة
local MiniSpinner = Instance.new("Frame")
MiniSpinner.Size            = UDim2.new(1, 14, 1, 14)
MiniSpinner.Position        = UDim2.new(0, -7, 0, -7)
MiniSpinner.BackgroundTransparency = 1
MiniSpinner.BorderSizePixel = 0
MiniSpinner.ZIndex          = 8
MiniSpinner.Parent          = MiniBtn

-- قوس دوار (نقطة على حافة الدائرة تدور)
local Dot1 = Instance.new("Frame")
Dot1.Size               = UDim2.new(0, 8, 0, 8)
Dot1.AnchorPoint        = Vector2.new(0.5, 0.5)
Dot1.BackgroundColor3   = Color3.fromRGB(0, 255, 100)
Dot1.BorderSizePixel    = 0
Dot1.ZIndex             = 11
Dot1.Parent             = ScreenGui
Instance.new("UICorner", Dot1).CornerRadius = UDim.new(1, 0)

local Dot2 = Instance.new("Frame")
Dot2.Size               = UDim2.new(0, 5, 0, 5)
Dot2.AnchorPoint        = Vector2.new(0.5, 0.5)
Dot2.BackgroundColor3   = Color3.fromRGB(0, 200, 80)
Dot2.BorderSizePixel    = 0
Dot2.ZIndex             = 11
Dot2.Parent             = ScreenGui
Instance.new("UICorner", Dot2).CornerRadius = UDim.new(1, 0)

RunService.Heartbeat:Connect(function(dt)
    hue        = (hue + dt * 0.45) % 1
    miniAngle  = (miniAngle + dt * 130) % 360

    local col = Color3.fromHSV(hue, 1, 1)
    RGBBorder.BackgroundColor3 = col
    MiniRGB.BackgroundColor3   = col
    Dot1.BackgroundColor3      = col
    Dot2.BackgroundColor3      = Color3.fromHSV((hue + 0.5) % 1, 1, 1)

    -- نبض شفافية الدائرة
    MiniBtn.BackgroundTransparency = 0.05 + math.abs(math.sin(tick() * 2.5)) * 0.1

    -- حساب موضع النقطتين حول الدائرة
    local miniPos = MiniBtn.AbsolutePosition
    local miniSize = MiniBtn.AbsoluteSize
    local cx = miniPos.X + miniSize.X / 2
    local cy = miniPos.Y + miniSize.Y / 2
    local r1 = 26  -- نصف قطر الدوران للنقطة الكبيرة
    local r2 = 26  -- نصف قطر الدوران للنقطة الصغيرة (معاكس)

    local rad1 = math.rad(miniAngle)
    local rad2 = math.rad(miniAngle + 180)

    Dot1.Position = UDim2.new(0, cx + math.cos(rad1) * r1 - 4,
                               0, cy + math.sin(rad1) * r1 - 4)
    Dot2.Position = UDim2.new(0, cx + math.cos(rad2) * r2 - 2.5,
                               0, cy + math.sin(rad2) * r2 - 2.5)
end)

print("✅ الفذايح برعاية ريان جاهز!")
