--[[
    SH Hub - Roblox UI Script
    Tabs: نسخ (Copy) | تحكم (Control)
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- helper: choose best parent for executor GUIs (Delta/Synapse/etc)
local function getGuiParent()
    local ok, hidden = pcall(function() return gethui() end)
    if ok and hidden then return hidden end
    local ok2, cg = pcall(function() return CoreGui end)
    if ok2 and cg then return cg end
    return PlayerGui
end
local guiParent = getGuiParent()

-- cleanup old
pcall(function()
    for _, n in ipairs({"SHHub","SHMini","SHSplash"}) do
        local old = guiParent:FindFirstChild(n)
        if old then old:Destroy() end
        local old2 = PlayerGui:FindFirstChild(n)
        if old2 then old2:Destroy() end
    end
end)

----------------------------------------------------------------
-- إشعار فريق SH Hub – يظهر بعد دقيقتين من تشغيل السكربت
----------------------------------------------------------------
local function getAvatar(username)
    local ok1, uid = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not ok1 then return "" end
    local ok2, url = pcall(function()
        return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
    end)
    return ok2 and url or ""
end

local function showTeamCard()
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "SH_TeamCard"
        sg.DisplayOrder = 9999997
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        pcall(function() sg.Parent = CoreGui end)
        if not sg.Parent then sg.Parent = PlayerGui end

        -- خلفية شفافة
        local overlay = Instance.new("Frame", sg)
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.new(0, 0, 0)
        overlay.BackgroundTransparency = 0.5
        overlay.BorderSizePixel = 0

        -- البطاقة الرئيسية
        local card = Instance.new("Frame", sg)
        card.Size = UDim2.new(0, 340, 0, 0)
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.new(0.5, 0, 0.65, 0)
        card.BackgroundColor3 = Color3.fromRGB(5, 10, 20)
        card.BackgroundTransparency = 0.05
        card.BorderSizePixel = 0
        card.AutomaticSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(0, 200, 255)
        stroke.Thickness = 1.8
        stroke.Transparency = 0.2

        local pad = Instance.new("UIPadding", card)
        pad.PaddingTop    = UDim.new(0, 16)
        pad.PaddingBottom = UDim.new(0, 20)
        pad.PaddingLeft   = UDim.new(0, 16)
        pad.PaddingRight  = UDim.new(0, 16)

        local layout = Instance.new("UIListLayout", card)
        layout.Padding = UDim.new(0, 14)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        -- عنوان البطاقة
        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(1, 0, 0, 26)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = "✦ كلان RAY ✦"
        title.TextSize = 17
        title.TextColor3 = Color3.fromRGB(0, 210, 255)
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.LayoutOrder = 1

        -- فاصل
        local div = Instance.new("Frame", card)
        div.Size = UDim2.new(1, 0, 0, 1)
        div.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        div.BackgroundTransparency = 0.5
        div.BorderSizePixel = 0
        div.LayoutOrder = 2

        -- دالة إنشاء بطاقة شخص
        local function makePersonCard(username, roleText, order)
            local avatarUrl = getAvatar(username)

            local row = Instance.new("Frame", card)
            row.Size = UDim2.new(1, 0, 0, 90)
            row.BackgroundColor3 = Color3.fromRGB(10, 20, 35)
            row.BackgroundTransparency = 0.3
            row.BorderSizePixel = 0
            row.LayoutOrder = order
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)

            -- الصورة
            local img = Instance.new("ImageLabel", row)
            img.Size = UDim2.new(0, 72, 0, 72)
            img.Position = UDim2.new(0, 10, 0.5, -36)
            img.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
            img.BorderSizePixel = 0
            img.Image = avatarUrl
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 36)
            local imgStroke = Instance.new("UIStroke", img)
            imgStroke.Color = Color3.fromRGB(0, 200, 255)
            imgStroke.Thickness = 2
            imgStroke.Transparency = 0.1

            -- اسم الحساب
            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Size = UDim2.new(1, -96, 0, 32)
            nameLbl.Position = UDim2.new(0, 90, 0.5, -30)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.Text = "@" .. username
            nameLbl.TextSize = 14
            nameLbl.TextColor3 = Color3.fromRGB(220, 240, 255)
            nameLbl.TextXAlignment = Enum.TextXAlignment.Right

            -- الدور
            local roleLbl = Instance.new("TextLabel", row)
            roleLbl.Size = UDim2.new(1, -96, 0, 28)
            roleLbl.Position = UDim2.new(0, 90, 0.5, 4)
            roleLbl.BackgroundTransparency = 1
            roleLbl.Font = Enum.Font.GothamSemibold
            roleLbl.Text = roleText
            roleLbl.TextSize = 13
            roleLbl.TextColor3 = Color3.fromRGB(0, 210, 255)
            roleLbl.TextXAlignment = Enum.TextXAlignment.Right
        end

        -- المصممه فقط
        makePersonCard("shhode320", "👑 المصممه", 3)

        -- زر إغلاق
        local closeBtn = Instance.new("TextButton", card)
        closeBtn.Size = UDim2.new(1, 0, 0, 34)
        closeBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
        closeBtn.BackgroundTransparency = 0.1
        closeBtn.BorderSizePixel = 0
        closeBtn.AutoButtonColor = false
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Text = "حسناً 👍"
        closeBtn.TextSize = 14
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.LayoutOrder = 4
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)
        closeBtn.MouseEnter:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}):Play()
        end)
        closeBtn.MouseLeave:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 140, 200)}):Play()
        end)

        -- أنيميشن الظهور
        card.BackgroundTransparency = 1
        overlay.BackgroundTransparency = 1
        TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0.05}):Play()

        local function closeCard()
            TweenService:Create(card,    TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
            TweenService:Create(overlay, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
            task.delay(0.28, function() pcall(function() sg:Destroy() end) end)
        end

        closeBtn.MouseButton1Click:Connect(closeCard)
    end)
end

-- تشغيل الإشعار بعد دقيقتين
task.delay(120, function()
    showTeamCard()
end)

----------------------------------------------------------------
-- Loading splash: SH Zero Protocol (hacker intro)
----------------------------------------------------------------

-- ─── نافذة "ما الجديد" تظهر بعد الإنترو ─────────────────────
local function showWhatsNew()
    local core = game:GetService("CoreGui")
    local wsg = Instance.new("ScreenGui")
    wsg.Name = "SH_WhatsNew"
    wsg.DisplayOrder = 9999998
    wsg.IgnoreGuiInset = true
    wsg.ResetOnSpawn = false
    wsg.Parent = core

    -- خلفية شفافة داكنة
    local overlay = Instance.new("Frame", wsg)
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0

    -- الإطار الرئيسي
    local card = Instance.new("Frame", wsg)
    card.Size = UDim2.new(0, 400, 0, 0)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.BackgroundColor3 = Color3.fromRGB(6, 18, 10)
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    card.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)
    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(0, 230, 110); cs.Thickness = 1.8; cs.Transparency = 0.15

    local cpad = Instance.new("UIPadding", card)
    cpad.PaddingTop = UDim.new(0, 16); cpad.PaddingBottom = UDim.new(0, 18)
    cpad.PaddingLeft = UDim.new(0, 18); cpad.PaddingRight = UDim.new(0, 18)

    local layout = Instance.new("UIListLayout", card)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- عنوان
    local titleRow = Instance.new("Frame", card)
    titleRow.Size = UDim2.new(1, 0, 0, 30)
    titleRow.BackgroundTransparency = 1
    titleRow.LayoutOrder = 1
    local tLayout = Instance.new("UIListLayout", titleRow)
    tLayout.FillDirection = Enum.FillDirection.Horizontal
    tLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local titleLbl = Instance.new("TextLabel", titleRow)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = "✦ ما الجديد؟ ✦"
    titleLbl.TextSize = 20
    titleLbl.TextColor3 = Color3.fromRGB(0, 255, 130)
    titleLbl.AutomaticSize = Enum.AutomaticSize.XY

    -- فاصل
    local divider = Instance.new("Frame", card)
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    divider.BackgroundTransparency = 0.6
    divider.BorderSizePixel = 0
    divider.LayoutOrder = 2

    -- النص الرئيسي
    local bodyLines = {
        "✦ التحديثات الجديدة ✦",
        "",
        "🔹 تم تغيير الإنترو إلى إنترو جديد",
        "🔹 تم تغيير ريموت الشات في خانة النسخ",
        "🔹 تم إضافة زرين في خانة النسخ:",
        "   • اسم كامل — يرسل الأوامر بالاسم الكامل",
        "   • ثلاث حروف — يرسل الأوامر بأول ٣ حروف فقط",
        "🔹 تم حذف التايتال لان انتهت الثغرة",
        "🔹 تم إضافة مراقبة الشات / تقليد الشات",
        "",
        "",
        "",
        "حسابي روب: shhode320~",
    }

    local bodyLbl = Instance.new("TextLabel", card)
    bodyLbl.Size = UDim2.new(1, 0, 0, 0)
    bodyLbl.AutomaticSize = Enum.AutomaticSize.Y
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.Font = Enum.Font.GothamSemibold
    bodyLbl.Text = table.concat(bodyLines, "\n")
    bodyLbl.TextSize = 14
    bodyLbl.TextColor3 = Color3.fromRGB(200, 245, 215)
    bodyLbl.TextXAlignment = Enum.TextXAlignment.Right
    bodyLbl.TextWrapped = true
    bodyLbl.RichText = false
    bodyLbl.LayoutOrder = 3

    -- زر إغلاق
    local closeBtn = Instance.new("TextButton", card)
    closeBtn.Size = UDim2.new(1, 0, 0, 36)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 70)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "فاهمت، يلا نبدأ! 🚀"
    closeBtn.TextSize = 15
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.LayoutOrder = 4
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 210, 90)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 160, 70)}):Play()
    end)

    -- أنيميشن الظهور (AnchorPoint 0.5,0.5 → نبدأ من أسفل قليلاً)
    card.Position = UDim2.new(0.5, 0, 0.65, 0)
    card.BackgroundTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0.08}):Play()

    local closed = false
    local function closeWhatsNew()
        if closed then return end; closed = true
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        task.delay(0.22, function() pcall(function() wsg:Destroy() end) end)
    end

    closeBtn.MouseButton1Click:Connect(closeWhatsNew)
end

-- ─── الإنترو مع تخطي بالضغط مرتين ──────────────────────────
local function runSplash()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Antro_ray/refs/heads/main/README.md"))()
    end)
    task.delay(0.5, function()
        showWhatsNew()
    end)
end
pcall(runSplash)

----------------------------------------------------------------
-- Main GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SHHub"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 9000
pcall(function() gui.Parent = guiParent end)
if not gui.Parent then gui.Parent = PlayerGui end

local main = Instance.new("Frame", gui)
main.Name = "Main"; main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0); main.Size = UDim2.new(0, 520, 0, 360)
main.BackgroundColor3 = Color3.fromRGB(6, 16, 9); main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local mStroke = Instance.new("UIStroke", main)
mStroke.Color = Color3.fromRGB(0, 230, 110); mStroke.Thickness = 1.4; mStroke.Transparency = 0.25
local mGradient = Instance.new("UIGradient", main)
mGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 30, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 12, 7)),
}
mGradient.Rotation = 135

local glow = Instance.new("Frame", main)
glow.BackgroundColor3 = Color3.fromRGB(0, 255, 130); glow.BorderSizePixel = 0
glow.Size = UDim2.new(1, 0, 0, 2); glow.Position = UDim2.new(0, 0, 0, 44)
local glowGrad = Instance.new("UIGradient", glow)
glowGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1),
}
task.spawn(function()
    while glow.Parent do
        glowGrad.Offset = Vector2.new(-1, 0)
        TweenService:Create(glowGrad, TweenInfo.new(2.2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
        task.wait(2.2)
    end
end)

local title = Instance.new("TextLabel", main)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -90, 0, 44); title.Position = UDim2.new(0, 16, 0, 0)
title.Font = Enum.Font.GothamBlack; title.Text = "👑 كلان RAY 👑"
title.TextSize = 22; title.TextColor3 = Color3.fromRGB(0, 255, 130)
title.TextXAlignment = Enum.TextXAlignment.Left

----------------------------------------------------------------
-- Top buttons (close X + minimize circle)
----------------------------------------------------------------
local closeBtn = Instance.new("TextButton", main)
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.Position = UDim2.new(1, -8, 0, 8)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 30)
closeBtn.BackgroundTransparency = 0.3; closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"; closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(180, 255, 200); closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Color = Color3.fromRGB(0, 200, 100); closeStroke.Transparency = 0.4
closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play() end)
closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play() end)

-- circle minimize
local minBtn = Instance.new("TextButton", main)
minBtn.AnchorPoint = Vector2.new(1, 0)
minBtn.Position = UDim2.new(1, -44, 0, 8)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.BackgroundColor3 = Color3.fromRGB(0, 90, 45)
minBtn.BackgroundTransparency = 0.2; minBtn.BorderSizePixel = 0
minBtn.Text = ""; minBtn.AutoButtonColor = false
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0) -- full circle
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = Color3.fromRGB(0, 255, 130); minStroke.Transparency = 0.2; minStroke.Thickness = 1.4
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)

----------------------------------------------------------------
-- Floating mini circle (when hidden)
----------------------------------------------------------------
local miniGui = Instance.new("ScreenGui")
miniGui.Name = "SHMini"; miniGui.ResetOnSpawn = false; miniGui.IgnoreGuiInset = true
miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; miniGui.DisplayOrder = 9001
pcall(function() miniGui.Parent = guiParent end)
if not miniGui.Parent then miniGui.Parent = PlayerGui end

local miniBubble = Instance.new("TextButton", miniGui)
miniBubble.AnchorPoint = Vector2.new(0, 0.5)
miniBubble.Position = UDim2.new(0, 16, 0.5, 0)
miniBubble.Size = UDim2.new(0, 44, 0, 44)
miniBubble.BackgroundColor3 = Color3.fromRGB(0, 110, 55)
miniBubble.BackgroundTransparency = 0.15; miniBubble.BorderSizePixel = 0
miniBubble.AutoButtonColor = false
miniBubble.Text = "RAY"
miniBubble.Font = Enum.Font.GothamBlack
miniBubble.TextSize = 14
miniBubble.TextColor3 = Color3.fromRGB(230, 255, 240)
miniBubble.Visible = false
Instance.new("UICorner", miniBubble).CornerRadius = UDim.new(1, 0)
local miniStroke = Instance.new("UIStroke", miniBubble)
miniStroke.Color = Color3.fromRGB(0, 255, 130); miniStroke.Thickness = 1.6; miniStroke.Transparency = 0.2

-- pulse
task.spawn(function()
    while miniGui.Parent do
        if miniBubble.Visible then
            TweenService:Create(miniStroke, TweenInfo.new(0.7), {Transparency = 0.7}):Play(); task.wait(0.7)
            TweenService:Create(miniStroke, TweenInfo.new(0.7), {Transparency = 0.15}):Play(); task.wait(0.7)
        else
            task.wait(0.2)
        end
    end
end)

-- mini bubble stays ALWAYS visible. clicking it toggles the main panel.
miniBubble.Visible = true

local function setHidden(hidden)
    if hidden then
        TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.22)
        main.Visible = false
        main.Size = UDim2.new(0, 520, 0, 360)
        main.BackgroundTransparency = 0.25
    else
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        main.BackgroundTransparency = 1
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 360), BackgroundTransparency = 0.25}):Play()
    end
end

minBtn.MouseButton1Click:Connect(function() setHidden(true) end)
miniBubble.MouseButton1Click:Connect(function()
    setHidden(main.Visible)
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.22); gui:Destroy(); miniGui:Destroy()
end)

----------------------------------------------------------------
-- Drag main + mini
----------------------------------------------------------------
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(title, main)
makeDraggable(miniBubble, miniBubble)

----------------------------------------------------------------
-- Tab bar
----------------------------------------------------------------
local tabBar = Instance.new("Frame", main)
tabBar.BackgroundTransparency = 1
tabBar.Position = UDim2.new(0, 16, 0, 56); tabBar.Size = UDim2.new(1, -32, 0, 36)
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.Padding = UDim.new(0, 8)

local pages, tabButtons = {}, {}

local function makeTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, 130, 1, 0); btn.BackgroundColor3 = Color3.fromRGB(8, 30, 14)
    btn.BackgroundTransparency = 0.4; btn.BorderSizePixel = 0; btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold; btn.Text = name; btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(160, 230, 180)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", btn); s.Color = Color3.fromRGB(0, 200, 100); s.Transparency = 0.6

    local page = Instance.new("Frame", main)
    page.Position = UDim2.new(0, 16, 0, 100); page.Size = UDim2.new(1, -32, 1, -116)
    page.BackgroundColor3 = Color3.fromRGB(4, 12, 7); page.BackgroundTransparency = 0.4
    page.BorderSizePixel = 0; page.Visible = false
    Instance.new("UICorner", page).CornerRadius = UDim.new(0, 10)
    local ps = Instance.new("UIStroke", page); ps.Color = Color3.fromRGB(0, 180, 90); ps.Transparency = 0.7

    pages[name] = page; tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(pages) do p.Visible = (n == name) end
        for n, b in pairs(tabButtons) do
            if n == name then
                TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(0, 255, 130)}):Play()
            else
                TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(160, 230, 180)}):Play()
            end
        end
    end)
    return page, btn
end

local copyPage    = makeTab("نسخ")
local controlPage = makeTab("تحكم")

----------------------------------------------------------------
-- Page: نسخ
----------------------------------------------------------------
local selectedName = nil
local nameMode = "full"  -- "full" = اسم كامل ، "three" = ثلاث حروف

local function getEffectiveName()
    if not selectedName then return nil end
    if nameMode == "three" then
        return selectedName:sub(1, 3)
    end
    return selectedName
end

local playersBar = Instance.new("ScrollingFrame", copyPage)
playersBar.Position = UDim2.new(0, 10, 0, 10); playersBar.Size = UDim2.new(1, -20, 0, 46)
playersBar.BackgroundColor3 = Color3.fromRGB(2, 10, 5); playersBar.BackgroundTransparency = 0.5
playersBar.BorderSizePixel = 0; playersBar.ScrollBarThickness = 3
playersBar.ScrollingDirection = Enum.ScrollingDirection.X
playersBar.AutomaticCanvasSize = Enum.AutomaticSize.X
playersBar.CanvasSize = UDim2.new(0, 0, 0, 0)
playersBar.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 130)
Instance.new("UICorner", playersBar).CornerRadius = UDim.new(0, 8)
local pbLayout = Instance.new("UIListLayout", playersBar)
pbLayout.FillDirection = Enum.FillDirection.Horizontal; pbLayout.Padding = UDim.new(0, 6)
pbLayout.SortOrder = Enum.SortOrder.LayoutOrder; pbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
local pbPad = Instance.new("UIPadding", playersBar)
pbPad.PaddingLeft = UDim.new(0, 8); pbPad.PaddingRight = UDim.new(0, 8)

local selectedLabel = Instance.new("TextLabel", copyPage)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Position = UDim2.new(0, 10, 0, 60); selectedLabel.Size = UDim2.new(1, -20, 0, 20)
selectedLabel.Font = Enum.Font.GothamSemibold; selectedLabel.TextSize = 13
selectedLabel.TextColor3 = Color3.fromRGB(180, 255, 200)
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.Text = "اختر لاعب من القائمة"

local playerChips = {}
local function refreshPlayers()
    for _, c in ipairs(playersBar:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    playerChips = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local chip = Instance.new("TextButton", playersBar)
            chip.Size = UDim2.new(0, 0, 1, -8); chip.AutomaticSize = Enum.AutomaticSize.X
            chip.BackgroundColor3 = Color3.fromRGB(10, 35, 18); chip.BackgroundTransparency = 0.2
            chip.BorderSizePixel = 0; chip.AutoButtonColor = false
            chip.Font = Enum.Font.GothamBold; chip.Text = "  " .. p.Name .. "  "
            chip.TextSize = 13; chip.TextColor3 = Color3.fromRGB(200, 255, 215)
            Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 8)
            local cs = Instance.new("UIStroke", chip); cs.Color = Color3.fromRGB(0, 200, 100); cs.Transparency = 0.5
            chip.MouseButton1Click:Connect(function()
                selectedName = p.Name
                selectedLabel.Text = "تم اختيار: " .. p.Name
                for _, ch in pairs(playerChips) do
                    TweenService:Create(ch, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(10, 35, 18)}):Play()
                end
                TweenService:Create(chip, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 120, 60)}):Play()
            end)
            chip.MouseEnter:Connect(function()
                if selectedName ~= p.Name then
                    TweenService:Create(chip, TweenInfo.new(0.12), {BackgroundTransparency = 0.05}):Play()
                end
            end)
            chip.MouseLeave:Connect(function()
                if selectedName ~= p.Name then
                    TweenService:Create(chip, TweenInfo.new(0.12), {BackgroundTransparency = 0.2}):Play()
                end
            end)
            playerChips[p.Name] = chip
        end
    end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

local function makeBigBtn(parent, text, posY, color1, color2)
    color1 = color1 or Color3.fromRGB(0, 150, 75)
    color2 = color2 or Color3.fromRGB(0, 90, 45)
    local b = Instance.new("TextButton", parent)
    b.Position = UDim2.new(0, 10, 0, posY); b.Size = UDim2.new(1, -20, 0, 46)
    b.BackgroundColor3 = Color3.fromRGB(0, 110, 55); b.BackgroundTransparency = 0.15
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    b.Font = Enum.Font.GothamBlack; b.Text = text; b.TextSize = 16
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(0, 255, 130); s.Transparency = 0.3
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2),
    }
    g.Rotation = 90
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play() end)
    return b
end

-- حقل علامة الأدمن
local prefixRow = Instance.new("Frame", copyPage)
prefixRow.BackgroundTransparency = 1
prefixRow.Position = UDim2.new(0, 10, 0, 84); prefixRow.Size = UDim2.new(1, -20, 0, 36)

local prefixBox = Instance.new("TextBox", prefixRow)
prefixBox.Size = UDim2.new(0, 48, 1, 0); prefixBox.Position = UDim2.new(0, 0, 0, 0)
prefixBox.BackgroundColor3 = Color3.fromRGB(20, 80, 180); prefixBox.BackgroundTransparency = 0.15
prefixBox.BorderSizePixel = 0; prefixBox.Text = ";"
prefixBox.PlaceholderText = ";"
prefixBox.TextColor3 = Color3.fromRGB(255, 255, 255)
prefixBox.Font = Enum.Font.GothamBold; prefixBox.TextSize = 18
prefixBox.ClearTextOnFocus = false
Instance.new("UICorner", prefixBox).CornerRadius = UDim.new(0, 8)
local pbStroke = Instance.new("UIStroke", prefixBox)
pbStroke.Color = Color3.fromRGB(80, 160, 255); pbStroke.Thickness = 1.5; pbStroke.Transparency = 0.2

local prefixLabel = Instance.new("TextLabel", prefixRow)
prefixLabel.BackgroundTransparency = 1
prefixLabel.Position = UDim2.new(0, 56, 0, 0); prefixLabel.Size = UDim2.new(1, -56, 1, 0)
prefixLabel.Font = Enum.Font.GothamSemibold; prefixLabel.TextSize = 13
prefixLabel.TextColor3 = Color3.fromRGB(160, 210, 255)
prefixLabel.TextXAlignment = Enum.TextXAlignment.Left
prefixLabel.Text = "اكتب علامة الادمن الخاصة بك"

-- ┌─────────────────────────────────────────────────────────┐
-- │  زرا وضع الاسم: اسم كامل / ثلاث حروف                   │
-- └─────────────────────────────────────────────────────────┘
local nameModeRow = Instance.new("Frame", copyPage)
nameModeRow.BackgroundTransparency = 1
nameModeRow.Position = UDim2.new(0, 10, 0, 124)
nameModeRow.Size = UDim2.new(1, -20, 0, 34)

local fullNameBtn = Instance.new("TextButton", nameModeRow)
fullNameBtn.Size = UDim2.new(0.5, -4, 1, 0)
fullNameBtn.Position = UDim2.new(0, 0, 0, 0)
fullNameBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
fullNameBtn.BackgroundTransparency = 0.1
fullNameBtn.BorderSizePixel = 0
fullNameBtn.AutoButtonColor = false
fullNameBtn.Font = Enum.Font.GothamBold
fullNameBtn.Text = "اسم كامل"
fullNameBtn.TextSize = 14
fullNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", fullNameBtn).CornerRadius = UDim.new(0, 9)
local fnStroke = Instance.new("UIStroke", fullNameBtn)
fnStroke.Color = Color3.fromRGB(0, 255, 130); fnStroke.Thickness = 2; fnStroke.Transparency = 0.1

local threeLettersBtn = Instance.new("TextButton", nameModeRow)
threeLettersBtn.Size = UDim2.new(0.5, -4, 1, 0)
threeLettersBtn.Position = UDim2.new(0.5, 4, 0, 0)
threeLettersBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
threeLettersBtn.BackgroundTransparency = 0.15
threeLettersBtn.BorderSizePixel = 0
threeLettersBtn.AutoButtonColor = false
threeLettersBtn.Font = Enum.Font.GothamBold
threeLettersBtn.Text = "ثلاث حروف"
threeLettersBtn.TextSize = 14
threeLettersBtn.TextColor3 = Color3.fromRGB(200, 255, 215)
Instance.new("UICorner", threeLettersBtn).CornerRadius = UDim.new(0, 9)
local tlStroke = Instance.new("UIStroke", threeLettersBtn)
tlStroke.Color = Color3.fromRGB(0, 200, 100); tlStroke.Thickness = 1.5; tlStroke.Transparency = 0.4

local function updateNameModeUI()
    if nameMode == "full" then
        TweenService:Create(fullNameBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 160, 80), BackgroundTransparency = 0.05}):Play()
        fnStroke.Transparency = 0.05
        TweenService:Create(threeLettersBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 50, 30), BackgroundTransparency = 0.2}):Play()
        tlStroke.Transparency = 0.5
    else
        TweenService:Create(fullNameBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 50, 30), BackgroundTransparency = 0.2}):Play()
        fnStroke.Transparency = 0.5
        TweenService:Create(threeLettersBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 160, 80), BackgroundTransparency = 0.05}):Play()
        tlStroke.Transparency = 0.05
    end
end

fullNameBtn.MouseButton1Click:Connect(function()
    nameMode = "full"
    updateNameModeUI()
end)
threeLettersBtn.MouseButton1Click:Connect(function()
    nameMode = "three"
    updateNameModeUI()
end)

-- ┌─────────────────────────────────────────────────────────┐
-- │  ScrollingFrame لخانة النسخ - يمنع خروج الأزرار        │
-- └─────────────────────────────────────────────────────────┘
local spamScroll = Instance.new("ScrollingFrame", copyPage)
spamScroll.Position = UDim2.new(0, 0, 0, 162)
spamScroll.Size = UDim2.new(1, 0, 1, -190)
spamScroll.BackgroundTransparency = 1
spamScroll.BorderSizePixel = 0
spamScroll.ScrollBarThickness = 4
spamScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 130)
spamScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
spamScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local spamList = Instance.new("UIListLayout", spamScroll)
spamList.Padding = UDim.new(0, 6)
spamList.SortOrder = Enum.SortOrder.LayoutOrder
local spamPad = Instance.new("UIPadding", spamScroll)
spamPad.PaddingTop = UDim.new(0, 4)
spamPad.PaddingBottom = UDim.new(0, 4)
spamPad.PaddingLeft = UDim.new(0, 6)
spamPad.PaddingRight = UDim.new(0, 6)

local function makeSpamRow(order)
    local row = Instance.new("Frame", spamScroll)
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    return row
end

-- تسمية (label) على اليسار - مجرد نص، ما تضغط
local function makeRowLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(0.34, -4, 1, 0)
    lbl.BackgroundColor3 = Color3.fromRGB(8, 25, 14)
    lbl.BackgroundTransparency = 0.3
    lbl.BorderSizePixel = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(200, 255, 215)
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 10)
    return lbl
end

-- زر تشغيل: احمر لما طافي، اخضر لما شغال
local function makeStartBtn(parent)
    local b = Instance.new("TextButton", parent)
    b.Position = UDim2.new(0.35, 2, 0, 0)
    b.Size = UDim2.new(0.33, -2, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(180, 25, 25)   -- احمر = طافي
    b.BackgroundTransparency = 0.05
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    b.Font = Enum.Font.GothamBold
    b.Text = "تشغيل"
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(255, 80, 80)
    s.Transparency = 0.2; s.Thickness = 1.8
    return b
end

-- زر ايقاف: رمادي داكن ثابت
local function makeStopBtn(parent)
    local b = Instance.new("TextButton", parent)
    b.Position = UDim2.new(0.69, 3, 0, 0)
    b.Size = UDim2.new(0.31, -3, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    b.BackgroundTransparency = 0.05
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    b.Font = Enum.Font.GothamBold
    b.Text = "ايقاف"
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(210, 210, 225)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(80, 80, 95)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play() end)
    return b
end

-- تغيير لون زر التشغيل
local function setStartOn(btn)
    TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(0, 190, 75)}):Play()
    local s = btn:FindFirstChildOfClass("UIStroke")
    if s then s.Color = Color3.fromRGB(0, 255, 130) end
    btn.Text = "شغال ✓"
end
local function setStartOff(btn)
    TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(180, 25, 25)}):Play()
    local s = btn:FindFirstChildOfClass("UIStroke")
    if s then s.Color = Color3.fromRGB(255, 80, 80) end
    btn.Text = "تشغيل"
end

-- الصف الأول: سبام
local rowA = makeSpamRow(1)
makeRowLabel(rowA, "سبام")
local copySpamBtn = makeStartBtn(rowA)
local stopBtnA    = makeStopBtn(rowA)

-- الصف الثاني: Logs
local rowB = makeSpamRow(2)
makeRowLabel(rowB, "Logs")
local copyLogsBtn = makeStartBtn(rowB)
local stopBtnB    = makeStopBtn(rowB)

-- الصف الثالث: Re
local rowC = makeSpamRow(3)
makeRowLabel(rowC, "Re")
local copyReBtn = makeStartBtn(rowC)
local stopBtnC  = makeStopBtn(rowC)

-- الصف الرابع: ⚡ سبام قوي
local rowD = makeSpamRow(4)
makeRowLabel(rowD, "⚡ سبام قوي")
local copyPowerBtn = makeStartBtn(rowD)
local stopBtnD     = makeStopBtn(rowD)


local statusLbl = Instance.new("TextLabel", copyPage)
statusLbl.BackgroundTransparency = 1
statusLbl.Position = UDim2.new(0, 10, 1, -28); statusLbl.Size = UDim2.new(1, -20, 0, 22)
statusLbl.Font = Enum.Font.GothamSemibold; statusLbl.TextSize = 13
statusLbl.TextColor3 = Color3.fromRGB(150, 220, 170); statusLbl.Text = ""

local function setStatus(txt, persistent)
    statusLbl.Text = txt; statusLbl.TextTransparency = 0
    if not persistent then
        task.delay(2.5, function()
            if statusLbl.Text == txt then
                TweenService:Create(statusLbl, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            end
        end)
    end
end

-- Build spam commands
local function buildLogsCmd(name, prefix)
    prefix = prefix or ";"
    local parts = {}
    for i = 1, 26 do parts[i] = prefix.."logs "..name end
    return table.concat(parts, " ")
end

local function buildReCmd(name, prefix)
    prefix = prefix or ";"
    local parts = {}
    for i = 1, 26 do parts[i] = prefix.."re "..name end
    return table.concat(parts, " ")
end

local function buildSpamA(name, prefix)
    prefix = prefix or ";"
    local parts = {}
    for i = 1, 10 do
        parts[i] = prefix.."logs "..name.." "..prefix.."nv "..name.." "..prefix.."re "..name
    end
    return table.concat(parts, " ")
end

local function buildPowerSpam(name, prefix)
    prefix = prefix or ";"
    local cmds = {
        "apparate "..name.." inf",
        "fling "..name,
        "jp "..name.." inf",
        "jc "..name,
        "ice "..name,
        "emotes "..name,
        "phase "..name,
        "cmdbar "..name,
        "nv "..name,
        "jump "..name,
        "re "..name,
        "res "..name,
        "kill "..name,
        "ping "..name,
    }
    local out = {}
    for i, c in ipairs(cmds) do out[i] = prefix..c end
    return table.concat(out, " ")
end


----------------------------------------------------------------
-- Remotes
----------------------------------------------------------------
local chatRemote, hdRemote, changeSettingRemote
pcall(function()
    local re = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if re then chatRemote = re:FindFirstChild("ChatEvent") end
end)
pcall(function()
    local hd = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
    if hd then
        local sig = hd:FindFirstChild("Signals")
        if sig then
            hdRemote            = sig:FindFirstChild("RequestCommandModification")
            changeSettingRemote = sig:FindFirstChild("ChangeSetting")
        end
    end
end)

-- تغيير علامة الأدمن في HDAdmin تلقائياً لما تتغير في الصندوق
local function applyPrefix(newPrefix)
    if newPrefix == "" then newPrefix = ";" end
    pcall(function()
        if changeSettingRemote then
            local args = {[1] = {[1] = "Prefix", [2] = newPrefix}}
            changeSettingRemote:InvokeServer(unpack(args))
        else
            -- fallback: ابحث عن الريموت مباشرة
            local sig = game:GetService("ReplicatedStorage")
                :FindFirstChild("HDAdminHDClient")
                :FindFirstChild("Signals")
            if sig then
                local r = sig:FindFirstChild("ChangeSetting")
                if r then
                    local args = {[1] = {[1] = "Prefix", [2] = newPrefix}}
                    r:InvokeServer(unpack(args))
                end
            end
        end
    end)
    setStatus("✓ علامة الأدمن: " .. newPrefix)
end

prefixBox.FocusLost:Connect(function()
    local val = prefixBox.Text
    if val == "" then val = ";" prefixBox.Text = ";" end
    applyPrefix(val)
end)

local function sendOnce(message)
    pcall(function()
        game:GetService("ReplicatedStorage").RemoteEvents.DataService:FireServer(message)
    end)
    if hdRemote then pcall(function() hdRemote:InvokeServer(message) end) end
end

local function copyText(t)
    local ok = false
    if setclipboard then ok = pcall(setclipboard, t)
    elseif toclipboard then ok = pcall(toclipboard, t)
    elseif type(syn) == "table" and syn.write_clipboard then ok = pcall(syn.write_clipboard, t) end
    return ok
end

----------------------------------------------------------------
-- Spam loop control
----------------------------------------------------------------
local spamRunning = false
local spamThread

local function stopSpam()
    spamRunning = false
    spamThread = nil
    setStatus("تم إيقاف السبام")
end

local function startSpam(message)
    if spamRunning then stopSpam(); task.wait(0.05) end
    spamRunning = true
    setStatus("السبام شغال... اضغط إيقاف للايقاف", true)
    spamThread = task.spawn(function()
        while spamRunning do
            sendOnce(message)
            task.wait(0.05)
        end
    end)
end

-- ── helpers لتوحيد منطق التشغيل والإيقاف ─────────────────────
local spamARunning     = false
local logsSpamRunning  = false
local reSpamRunning    = false
local powerSpamRunning = false

local function doStop(runFlag, startBtn)
    stopSpam()
    if startBtn then setStartOff(startBtn) end
    return false
end

-- ── سبام ────────────────────────────────────────────────────
copySpamBtn.MouseButton1Click:Connect(function()
    if spamARunning then return end
    if not selectedName then setStatus("اختر لاعب اولا") return end
    local prefix = (prefixBox.Text ~= "" and prefixBox.Text) or ";"
    startSpam(buildSpamA(getEffectiveName(), prefix))
    spamARunning = true; setStartOn(copySpamBtn)
end)
stopBtnA.MouseButton1Click:Connect(function()
    if spamARunning then spamARunning = doStop(spamARunning, copySpamBtn) end
end)

-- ── Logs ─────────────────────────────────────────────────────
copyLogsBtn.MouseButton1Click:Connect(function()
    if logsSpamRunning then return end
    if not selectedName then setStatus("اختر لاعب اولا") return end
    local prefix = (prefixBox.Text ~= "" and prefixBox.Text) or ";"
    startSpam(buildLogsCmd(getEffectiveName(), prefix))
    logsSpamRunning = true; setStartOn(copyLogsBtn)
end)
stopBtnB.MouseButton1Click:Connect(function()
    if logsSpamRunning then logsSpamRunning = doStop(logsSpamRunning, copyLogsBtn) end
end)

-- ── Re ───────────────────────────────────────────────────────
copyReBtn.MouseButton1Click:Connect(function()
    if reSpamRunning then return end
    if not selectedName then setStatus("اختر لاعب اولا") return end
    local prefix = (prefixBox.Text ~= "" and prefixBox.Text) or ";"
    startSpam(buildReCmd(getEffectiveName(), prefix))
    reSpamRunning = true; setStartOn(copyReBtn)
end)
stopBtnC.MouseButton1Click:Connect(function()
    if reSpamRunning then reSpamRunning = doStop(reSpamRunning, copyReBtn) end
end)

-- ── سبام قوي ─────────────────────────────────────────────────
copyPowerBtn.MouseButton1Click:Connect(function()
    if powerSpamRunning then return end
    if not selectedName then setStatus("اختر لاعب اولا") return end
    local prefix = (prefixBox.Text ~= "" and prefixBox.Text) or ";"
    startSpam(buildPowerSpam(getEffectiveName(), prefix))
    powerSpamRunning = true; setStartOn(copyPowerBtn)
end)
stopBtnD.MouseButton1Click:Connect(function()
    if powerSpamRunning then powerSpamRunning = doStop(powerSpamRunning, copyPowerBtn) end
end)



----------------------------------------------------------------
-- Page: تحكم
----------------------------------------------------------------
local ctrlInfo = Instance.new("TextLabel", controlPage)
ctrlInfo.BackgroundTransparency = 1
ctrlInfo.Position = UDim2.new(0, 10, 0, 10); ctrlInfo.Size = UDim2.new(1, -20, 0, 24)
ctrlInfo.Font = Enum.Font.GothamBold; ctrlInfo.Text = "لوحة التحكم"
ctrlInfo.TextSize = 16; ctrlInfo.TextColor3 = Color3.fromRGB(0, 255, 130)
ctrlInfo.TextXAlignment = Enum.TextXAlignment.Left

-- scrollable area for control buttons (since we now have many)
local ctrlScroll = Instance.new("ScrollingFrame", controlPage)
ctrlScroll.Position = UDim2.new(0, 0, 0, 40)
ctrlScroll.Size = UDim2.new(1, 0, 1, -70)
ctrlScroll.BackgroundTransparency = 1
ctrlScroll.BorderSizePixel = 0
ctrlScroll.ScrollBarThickness = 4
ctrlScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 100)
ctrlScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ctrlScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local spamBtn      = makeBigBtn(ctrlScroll, "سبام", 4,
    Color3.fromRGB(255, 80, 80), Color3.fromRGB(170, 30, 30))
local skinsBtn     = makeBigBtn(ctrlScroll, "سكنات", 58,
    Color3.fromRGB(255, 90, 200), Color3.fromRGB(170, 30, 130))
local dancesBtn    = makeBigBtn(ctrlScroll, "رقصات", 112,
    Color3.fromRGB(230, 140, 30), Color3.fromRGB(160, 90, 10))
local loadBtn      = makeBigBtn(ctrlScroll, "تحكم الراديو", 166,
    Color3.fromRGB(0, 200, 110), Color3.fromRGB(0, 130, 70))
local hideBtn      = makeBigBtn(ctrlScroll, "إخفاء رسائل السبام", 220,
    Color3.fromRGB(30, 200, 200), Color3.fromRGB(15, 130, 130))
local spinStartBtn = makeBigBtn(ctrlScroll, "تشغيل الدوران", 274,
    Color3.fromRGB(140, 220, 40), Color3.fromRGB(80, 150, 20))
local spinStopBtn  = makeBigBtn(ctrlScroll, "إيقاف الدوران", 328,
    Color3.fromRGB(170, 30, 30), Color3.fromRGB(110, 15, 15))
local logsBtn      = makeBigBtn(ctrlScroll, "حماية من logs / clogs", 382,
    Color3.fromRGB(0, 130, 220), Color3.fromRGB(0, 70, 140))
local titleBtn     = makeBigBtn(ctrlScroll, "تقليد الشات", 436,
    Color3.fromRGB(170, 70, 220), Color3.fromRGB(100, 30, 150))
local allBtn       = makeBigBtn(ctrlScroll, "نسخ all", 490,
    Color3.fromRGB(30, 180, 255), Color3.fromRGB(10, 100, 180))
local blueBtn      = makeBigBtn(ctrlScroll, "نسخه معدلة من سكربت بلو", 544,
    Color3.fromRGB(0, 120, 255), Color3.fromRGB(0, 60, 160))
local afkBtn       = makeBigBtn(ctrlScroll, "تحكم في شات ال afk أو أحد مايعرف يسولف", 598,
    Color3.fromRGB(255, 160, 0), Color3.fromRGB(180, 90, 0))

local ctrlStatus = Instance.new("TextLabel", controlPage)
ctrlStatus.BackgroundTransparency = 1
ctrlStatus.Position = UDim2.new(0, 10, 1, -28); ctrlStatus.Size = UDim2.new(1, -20, 0, 22)
ctrlStatus.Font = Enum.Font.GothamSemibold; ctrlStatus.TextSize = 13
ctrlStatus.TextColor3 = Color3.fromRGB(150, 220, 170); ctrlStatus.Text = ""
ctrlStatus.TextXAlignment = Enum.TextXAlignment.Left

local function showBigNotice(text)
    local nGui = Instance.new("ScreenGui")
    nGui.Name = "SHNotice"; nGui.ResetOnSpawn = false; nGui.IgnoreGuiInset = true
    nGui.DisplayOrder = 9998
    pcall(function() nGui.Parent = guiParent end)
    if not nGui.Parent then nGui.Parent = PlayerGui end

    local nFrame = Instance.new("Frame", nGui)
    nFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    nFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    nFrame.Size = UDim2.new(0, 520, 0, 220)
    nFrame.BackgroundColor3 = Color3.fromRGB(8, 18, 10)
    nFrame.BackgroundTransparency = 0.1
    nFrame.BorderSizePixel = 0
    Instance.new("UICorner", nFrame).CornerRadius = UDim.new(0, 16)
    local nStroke = Instance.new("UIStroke", nFrame)
    nStroke.Color = Color3.fromRGB(0, 255, 130); nStroke.Thickness = 2; nStroke.Transparency = 0.1

    local title = Instance.new("TextLabel", nFrame)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 12, 0, 14); title.Size = UDim2.new(1, -24, 0, 32)
    title.Font = Enum.Font.GothamBlack; title.Text = "ملاحظة مهمة"
    title.TextSize = 22; title.TextColor3 = Color3.fromRGB(0, 255, 130)

    local body = Instance.new("TextLabel", nFrame)
    body.BackgroundTransparency = 1
    body.Position = UDim2.new(0, 16, 0, 56); body.Size = UDim2.new(1, -32, 1, -116)
    body.Font = Enum.Font.GothamSemibold; body.Text = text
    body.TextSize = 20; body.TextColor3 = Color3.fromRGB(230, 255, 235)
    body.TextWrapped = true; body.TextYAlignment = Enum.TextYAlignment.Top

    local okBtn = Instance.new("TextButton", nFrame)
    okBtn.AnchorPoint = Vector2.new(0.5, 1)
    okBtn.Position = UDim2.new(0.5, 0, 1, -14); okBtn.Size = UDim2.new(0, 160, 0, 38)
    okBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); okBtn.BorderSizePixel = 0
    okBtn.Font = Enum.Font.GothamBold; okBtn.Text = "تمام"
    okBtn.TextSize = 18; okBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 10)

    okBtn.MouseButton1Click:Connect(function() pcall(function() nGui:Destroy() end) end)
    task.delay(12, function() pcall(function() nGui:Destroy() end) end)
end

local dancesLoaded = false
dancesBtn.MouseButton1Click:Connect(function()
    if dancesLoaded then ctrlStatus.Text = "الرقصات مفعلة بالفعل" return end
    ctrlStatus.Text = "جاري تشغيل الرقصات..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
        end)
        if ok then dancesLoaded = true; ctrlStatus.Text = "تم تشغيل الرقصات"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

local controlLoaded = false
loadBtn.MouseButton1Click:Connect(function()
    showBigNotice("البس الراديو يلا يشتغل السكربت 🙌😌")
    if controlLoaded then ctrlStatus.Text = "تحكم الراديو مفعل بالفعل" return end
    ctrlStatus.Text = "جاري تشغيل الراديو..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Raduo_ray/refs/heads/main/README.md"))()
        end)
        if ok then controlLoaded = true; ctrlStatus.Text = "تم تشغيل تحكم الراديو"
        else ctrlStatus.Text = "فشل التشغيل: " .. tostring(err):sub(1, 60) end
    end)
end)

----------------------------------------------------------------
-- Anti notification (activated by hide button)
----------------------------------------------------------------
local antiActive = false
local antiConnection
local function hideSystemNotifications(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextBox") then
        local ok, txt = pcall(function() return obj.Text end)
        if ok and txt and (txt:find("Sending commands") or txt:find("CommandLimit")) then
            local frame = obj.Parent
            if frame then
                pcall(function() frame.Visible = false; frame:Destroy() end)
            end
        end
    end
end

hideBtn.MouseButton1Click:Connect(function()
    if antiActive then
        ctrlStatus.Text = "حماية الواجهة مفعلة بالفعل"
        return
    end
    antiActive = true
    antiConnection = PlayerGui.DescendantAdded:Connect(function(d)
        task.wait(0.01)
        hideSystemNotifications(d)
    end)
    task.spawn(function()
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            hideSystemNotifications(v)
        end
    end)
    ctrlStatus.Text = "تم تفعيل اخفاء رسائل السبام"
    print("تم تفعيل حماية الواجهة.. لن تظهر رسائل System بعد الآن.")
end)

----------------------------------------------------------------
-- Spin (دوران)
----------------------------------------------------------------
local spinning = false
local spinSpeed = 50
local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
    if spinning then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

spinStartBtn.MouseButton1Click:Connect(function()
    spinning = true
    ctrlStatus.Text = "تم تشغيل الدوران"
end)
spinStopBtn.MouseButton1Click:Connect(function()
    spinning = false
    ctrlStatus.Text = "تم إيقاف الدوران"
end)

----------------------------------------------------------------
-- Logs / clogs protection
----------------------------------------------------------------
local logsActive = false
local function scanAndDestroy(obj)
    if obj:IsA("ScreenGui") or obj:IsA("Frame") then
        local nm = obj.Name:lower()
        if nm:find("log") or nm:find("admin") or nm:find("command") then
            pcall(function() obj:Destroy() end)
        end
    end
end

logsBtn.MouseButton1Click:Connect(function()
    if logsActive then
        ctrlStatus.Text = "حماية logs مفعلة بالفعل"
        return
    end
    logsActive = true
    for _, g in ipairs(PlayerGui:GetDescendants()) do
        scanAndDestroy(g)
    end
    PlayerGui.DescendantAdded:Connect(function(d)
        scanAndDestroy(d)
    end)
    task.spawn(function()
        while logsActive and task.wait(0.1) do
            for _, g in ipairs(PlayerGui:GetChildren()) do
                if g:IsA("ScreenGui") and (g.Name:find("Log") or g.Name:find("Admin")) then
                    pcall(function() g.Enabled = false; g:Destroy() end)
                end
            end
        end
    end)
    ctrlStatus.Text = "تم تفعيل حماية logs / clogs"
    print("تم تفعيل الحظر النهائي لقائمة اللوقز")
end)

----------------------------------------------------------------
-- Default tab
----------------------------------------------------------------
pages["نسخ"].Visible = true
TweenService:Create(tabButtons["نسخ"], TweenInfo.new(0.15), {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(0, 255, 130)}):Play()




----------------------------------------------------------------
-- Title control (SH RGB embedded)
----------------------------------------------------------------
local titleLoaded = false
local SH_RGB_SOURCE = [==[
--[[
    SH RGB - Roblox UI Script (Green Theme)
    Sends title text + cycling RGB Color3 to ApplyTitle RemoteEvent
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function getGuiParent()
    local ok, hidden = pcall(function() return gethui() end)
    if ok and hidden then return hidden end
    local ok2, cg = pcall(function() return CoreGui end)
    if ok2 and cg then return cg end
    return PlayerGui
end
local guiParent = getGuiParent()

pcall(function()
    for _, n in ipairs({"SHRGBHub","SHRGBMini","SHRGBSplash"}) do
        local old = guiParent:FindFirstChild(n)
        if old then old:Destroy() end
        local old2 = PlayerGui:FindFirstChild(n)
        if old2 then old2:Destroy() end
    end
end)

----------------------------------------------------------------
-- Loading splash
----------------------------------------------------------------
local function runSplash()
    local splash = Instance.new("ScreenGui")
    splash.Name = "SHRGBSplash"; splash.ResetOnSpawn = false; splash.IgnoreGuiInset = true
    splash.DisplayOrder = 9999
    pcall(function() splash.Parent = guiParent end)
    if not splash.Parent then splash.Parent = PlayerGui end

    local f = Instance.new("Frame", splash)
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.new(0.5, 0, 0.5, 0)
    f.Size = UDim2.new(0, 360, 0, 140)
    f.BackgroundColor3 = Color3.fromRGB(8, 18, 10)
    f.BackgroundTransparency = 0.15; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 14)
    local s = Instance.new("UIStroke", f)
    s.Color = Color3.fromRGB(0, 255, 120); s.Thickness = 1.4; s.Transparency = 0.2

    local n = Instance.new("TextLabel", f)
    n.BackgroundTransparency = 1
    n.Position = UDim2.new(0, 0, 0, 22); n.Size = UDim2.new(1, 0, 0, 44)
    n.Font = Enum.Font.GothamBlack; n.Text = "RAY"
    n.TextSize = 32; n.TextColor3 = Color3.fromRGB(0, 255, 130)

    local st = Instance.new("TextLabel", f)
    st.BackgroundTransparency = 1
    st.Position = UDim2.new(0, 0, 0, 78); st.Size = UDim2.new(1, 0, 0, 28)
    st.Font = Enum.Font.GothamSemibold; st.Text = "جاري التشغيل..."
    st.TextSize = 18; st.TextColor3 = Color3.fromRGB(180, 255, 200)

    for i = 1, 3 do
        if not splash.Parent then break end
        pcall(function() TweenService:Create(s, TweenInfo.new(0.35), {Transparency = 0.7}):Play() end)
        task.wait(0.35)
        pcall(function() TweenService:Create(s, TweenInfo.new(0.35), {Transparency = 0.1}):Play() end)
        task.wait(0.35)
    end
    pcall(function() TweenService:Create(f, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play() end)
    pcall(function() TweenService:Create(n, TweenInfo.new(0.4), {TextTransparency = 1}):Play() end)
    pcall(function() TweenService:Create(st, TweenInfo.new(0.4), {TextTransparency = 1}):Play() end)
    pcall(function() TweenService:Create(s, TweenInfo.new(0.4), {Transparency = 1}):Play() end)
    task.wait(0.45)
    pcall(function() splash:Destroy() end)
end
pcall(runSplash)

----------------------------------------------------------------
-- Main GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SHRGBHub"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 9000
pcall(function() gui.Parent = guiParent end)
if not gui.Parent then gui.Parent = PlayerGui end

local main = Instance.new("Frame", gui)
main.Name = "Main"; main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0); main.Size = UDim2.new(0, 420, 0, 320)
main.BackgroundColor3 = Color3.fromRGB(6, 16, 9); main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local mStroke = Instance.new("UIStroke", main)
mStroke.Color = Color3.fromRGB(0, 230, 110); mStroke.Thickness = 1.4; mStroke.Transparency = 0.25

local mGradient = Instance.new("UIGradient", main)
mGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 30, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 12, 7)),
}
mGradient.Rotation = 135

local glow = Instance.new("Frame", main)
glow.BackgroundColor3 = Color3.fromRGB(0, 255, 130); glow.BorderSizePixel = 0
glow.Size = UDim2.new(1, 0, 0, 2); glow.Position = UDim2.new(0, 0, 0, 44)

-- Header
local header = Instance.new("Frame", main)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 44)

local title = Instance.new("TextLabel", header)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 0); title.Size = UDim2.new(1, -60, 1, 0)
title.Font = Enum.Font.GothamBlack; title.Text = "👑 كلان RAY 👑"
title.TextSize = 20; title.TextColor3 = Color3.fromRGB(0, 255, 130)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -10, 0.5, 0); closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30); closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold; closeBtn.Text = "X"
closeBtn.TextSize = 16; closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Drag main
do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

----------------------------------------------------------------
-- Body with slots
----------------------------------------------------------------
local body = Instance.new("Frame", main)
body.Position = UDim2.new(0, 12, 0, 56); body.Size = UDim2.new(1, -24, 1, -68)
body.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", body)
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder

local Remote = ReplicatedStorage:FindFirstChild("ApplyTitle")
local activeLoops = {}

local function makeSlot(index, defaultText)
    local row = Instance.new("Frame", body)
    row.LayoutOrder = index
    row.Size = UDim2.new(1, 0, 0, 42); row.BackgroundTransparency = 1

    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(1, -100, 1, 0); box.Position = UDim2.new(0, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(10, 22, 14); box.BackgroundTransparency = 0.15
    box.BorderSizePixel = 0
    box.Text = defaultText; box.PlaceholderText = "اكتب النص..."
    box.TextColor3 = Color3.fromRGB(220, 255, 230); box.PlaceholderColor3 = Color3.fromRGB(120, 160, 130)
    box.Font = Enum.Font.GothamSemibold; box.TextSize = 14
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", box)
    bs.Color = Color3.fromRGB(0, 200, 100); bs.Thickness = 1; bs.Transparency = 0.5

    local btn = Instance.new("TextButton", row)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, 0, 0, 0); btn.Size = UDim2.new(0, 92, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 80); btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold; btn.Text = "تشغيل"
    btn.TextSize = 14; btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bts = Instance.new("UIStroke", btn)
    bts.Color = Color3.fromRGB(0, 255, 130); bts.Thickness = 1; bts.Transparency = 0.3

    btn.MouseButton1Click:Connect(function()
        if activeLoops[index] then
            activeLoops[index] = false
            btn.Text = "تشغيل"
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
            bts.Color = Color3.fromRGB(0, 255, 130)
        else
            if not Remote then
                Remote = ReplicatedStorage:FindFirstChild("ApplyTitle")
            end
            activeLoops[index] = true
            btn.Text = "إيقاف"
            btn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            bts.Color = Color3.fromRGB(255, 80, 80)

            task.spawn(function()
                while activeLoops[index] do
                    local dynamicColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    pcall(function()
                        if Remote then Remote:FireServer(box.Text, dynamicColor) end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end)
end

makeSlot(1, "SH ON TOP")
makeSlot(2, "NA WAS HERE")
makeSlot(3, "SHAHAD WAS HERE")

----------------------------------------------------------------
-- Mini draggable bubble
----------------------------------------------------------------
local miniGui = Instance.new("ScreenGui")
miniGui.Name = "SHRGBMini"; miniGui.ResetOnSpawn = false; miniGui.IgnoreGuiInset = true
miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; miniGui.DisplayOrder = 9001
pcall(function() miniGui.Parent = guiParent end)
if not miniGui.Parent then miniGui.Parent = PlayerGui end

local miniBubble = Instance.new("TextButton", miniGui)
miniBubble.AnchorPoint = Vector2.new(0, 0.5)
miniBubble.Position = UDim2.new(0, 14, 0.35, 0)
miniBubble.Size = UDim2.new(0, 48, 0, 48)
miniBubble.BackgroundColor3 = Color3.fromRGB(150, 60, 200)
miniBubble.BackgroundTransparency = 0.1; miniBubble.BorderSizePixel = 0
miniBubble.AutoButtonColor = false
miniBubble.Text = "🌈"
miniBubble.Font = Enum.Font.GothamBlack
miniBubble.TextSize = 22
miniBubble.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", miniBubble).CornerRadius = UDim.new(0, 10)
local mbStroke = Instance.new("UIStroke", miniBubble)
mbStroke.Color = Color3.fromRGB(220, 120, 255); mbStroke.Thickness = 2; mbStroke.Transparency = 0.1

local mbGrad = Instance.new("UIGradient", miniBubble)
mbGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 30, 150)),
}
mbGrad.Rotation = 135

-- color cycling animation (RGB style to differentiate from green SH)
task.spawn(function()
    local t = 0
    while miniBubble.Parent do
        t = t + 0.05
        pcall(function()
            mbStroke.Color = Color3.fromHSV(t % 1, 1, 1)
        end)
        task.wait(0.05)
    end
end)

-- draggable + click-to-toggle
do
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    miniBubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false
            dragStart = input.Position; startPos = miniBubble.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 4 then moved = true end
            miniBubble.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    miniBubble.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not moved then
                main.Visible = not main.Visible
            end
        end
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    pcall(function() gui:Destroy() end)
    pcall(function() miniGui:Destroy() end)
end)

print("[SH RGB] Loaded")

]==]

titleBtn.MouseButton1Click:Connect(function()
    ctrlStatus.Text = "جاري تشغيل مراقبة الشات..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Nah_chat_ray/refs/heads/main/README.md"))()
        end)
        if ok then ctrlStatus.Text = "تم تشغيل مراقبة الشات"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

spamBtn.MouseButton1Click:Connect(function()
    ctrlStatus.Text = "جاري تشغيل السبام..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/SPAM_RAY/refs/heads/main/README.md"))()
        end)
        if ok then ctrlStatus.Text = "تم تشغيل السبام"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

skinsBtn.MouseButton1Click:Connect(function()
    ctrlStatus.Text = "جاري تشغيل السكنات..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Skin_ray/refs/heads/main/README.md"))()
        end)
        if ok then ctrlStatus.Text = "تم تشغيل السكنات"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

allBtn.MouseButton1Click:Connect(function()
    ctrlStatus.Text = "جاري تشغيل نسخ all..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/ALL_RAY/refs/heads/main/README.md"))()
        end)
        if ok then ctrlStatus.Text = "تم تشغيل نسخ all"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

local blueLoaded = false
blueBtn.MouseButton1Click:Connect(function()
    if blueLoaded then ctrlStatus.Text = "نسخه معدلة من سكربت بلو مفعلة بالفعل" return end
    ctrlStatus.Text = "جاري تشغيل نسخه معدلة من سكربت بلو..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Blsh/refs/heads/main/README.md"))()
        end)
        if ok then blueLoaded = true; ctrlStatus.Text = "تم تشغيل نسخه معدلة من سكربت بلو"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

local afkLoaded = false
afkBtn.MouseButton1Click:Connect(function()
    if afkLoaded then ctrlStatus.Text = "AFK مفعل بالفعل" return end
    ctrlStatus.Text = "جاري تشغيل AFK..."
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Afk/refs/heads/main/README.md"))()
        end)
        if ok then afkLoaded = true; ctrlStatus.Text = "تم تشغيل AFK ✅"
        else ctrlStatus.Text = "فشل: " .. tostring(err):sub(1, 60) end
    end)
end)

print("[SH] Loaded")
 
