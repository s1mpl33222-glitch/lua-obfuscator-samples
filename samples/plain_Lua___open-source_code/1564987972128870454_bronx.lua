local Popup = {
    Title = "tha bronx",
    Tag = "BETA",
    Heading = "Before you run this script",
    Message = "If you're on mobile or a low UNC executor, the script can take up to 2 minutes to load because of the heavy obfuscation.\n\nIf you don't like this UI, there will be an option to go back to the old UI in about a week, so please don't complain to me about the UI.\n\nPlease report any bugs or issues to me ASAP and I'll fix them as soon as I'm told.",
    Agree = "I've read this",
    Button = "Understood / Load script",
}

local Theme = {
    Background = Color3.fromRGB(27, 29, 30),
    Section = Color3.fromRGB(35, 37, 38),
    Outline = Color3.fromRGB(15, 16, 17),
    Inline = Color3.fromRGB(43, 45, 48),
    Text = Color3.fromRGB(221, 227, 244),
    Dim = Color3.fromRGB(150, 155, 168),
    Accent = Color3.fromRGB(98, 174, 255),
    SecondAccent = Color3.fromRGB(61, 100, 141),
}

local FontId = "rbxassetid://12187365364"
local function F(Weight) return Font.new(FontId, Weight, Enum.FontStyle.Normal) end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function New(Class, Props, Children)
    local Obj = Instance.new(Class)
    for K, V in pairs(Props or {}) do Obj[K] = V end
    for _, C in ipairs(Children or {}) do C.Parent = Obj end
    return Obj
end

local function Corner(R) return New("UICorner", {CornerRadius = UDim.new(0, R)}) end
local function Stroke(C, T) return New("UIStroke", {Color = C, Thickness = T or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end

local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")
local Old = GuiParent:FindFirstChild("BetaPopup")
if Old then Old:Destroy() end

local Gui = New("ScreenGui", {Name = "BetaPopup", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 10000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
if syn and syn.protect_gui then pcall(syn.protect_gui, Gui) end

local Dim = New("Frame", {Parent = Gui, BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), BorderSizePixel = 0})

local Camera = workspace.CurrentCamera
local Width = math.min(380, Camera.ViewportSize.X - 32)
local Card = New("CanvasGroup", {
    Parent = Gui, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 12),
    Size = UDim2.fromOffset(Width, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = Theme.Background, BorderSizePixel = 0, GroupTransparency = 1,
}, {Corner(8), Stroke(Theme.Outline, 1)})

local Fit = New("UIScale", {Parent = Card, Scale = 1})
local function FitToScreen()
    local VP = Camera.ViewportSize
    local W = Card.AbsoluteSize.X / math.max(Fit.Scale, 0.01)
    local H = Card.AbsoluteSize.Y / math.max(Fit.Scale, 0.01)
    if W <= 0 or H <= 0 then return end
    Fit.Scale = math.clamp(math.min((VP.X - 24) / W, (VP.Y - 24) / H, 1), 0.45, 1)
end
Card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() task.defer(FitToScreen) end)
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(FitToScreen)

New("Frame", {Parent = Card, BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 2), ZIndex = 3}, {
    New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.SecondAccent)}),
})

local Body = New("Frame", {Parent = Card, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}, {
    New("UIPadding", {PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)}),
    New("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder}),
})

local Header = New("Frame", {Parent = Body, LayoutOrder = 1, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22)})
local TitleRow = New("Frame", {Parent = Header, BackgroundTransparency = 1, Size = UDim2.new(1, -28, 1, 0)}, {
    New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8)}),
})
New("TextLabel", {Parent = TitleRow, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0),
    FontFace = F(Enum.FontWeight.SemiBold), Text = Popup.Title, TextColor3 = Theme.Accent, TextSize = 20})
New("TextLabel", {Parent = TitleRow, BackgroundColor3 = Theme.SecondAccent, BackgroundTransparency = 0.35, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 18),
    FontFace = F(Enum.FontWeight.Bold), Text = Popup.Tag, TextColor3 = Theme.Text, TextSize = 11}, {
    Corner(4), New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}),
})
local Close = New("TextButton", {Parent = Header, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(22, 22),
    BackgroundTransparency = 1, FontFace = F(Enum.FontWeight.Medium), Text = "×", TextColor3 = Theme.Dim, TextSize = 22, AutoButtonColor = false})

local MsgBox = New("Frame", {Parent = Body, LayoutOrder = 2, BackgroundColor3 = Theme.Section, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}, {
    Corner(6), Stroke(Theme.Inline, 1),
    New("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}),
})
New("UIListLayout", {Parent = MsgBox, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
New("TextLabel", {Parent = MsgBox, LayoutOrder = 1, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    FontFace = F(Enum.FontWeight.Heavy), Text = Popup.Heading, TextColor3 = Theme.Text, TextSize = 17,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left})
New("TextLabel", {Parent = MsgBox, LayoutOrder = 2, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    FontFace = F(Enum.FontWeight.Regular), Text = Popup.Message, TextColor3 = Theme.Text, TextSize = 14,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LineHeight = 1.1})

local Agreed = false
local AgreeRow = New("TextButton", {Parent = Body, LayoutOrder = 3, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Text = "", AutoButtonColor = false}, {
    New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8)}),
})
local Box = New("Frame", {Parent = AgreeRow, LayoutOrder = 1, BackgroundColor3 = Theme.Section, BorderSizePixel = 0, Size = UDim2.fromOffset(18, 18)}, {Corner(4)})
local BoxStroke = Stroke(Theme.Inline, 1)
BoxStroke.Parent = Box
local Tick = New("TextLabel", {Parent = Box, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), FontFace = F(Enum.FontWeight.Bold),
    Text = "✓", TextColor3 = Theme.Background, TextSize = 14, TextTransparency = 1})
New("TextLabel", {Parent = AgreeRow, LayoutOrder = 2, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0),
    FontFace = F(Enum.FontWeight.Medium), Text = Popup.Agree, TextColor3 = Theme.Text, TextSize = 14})

local ButtonRow = New("Frame", {Parent = Body, LayoutOrder = 4, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32)})

local CheckBtn = New("TextButton", {Parent = ButtonRow, BackgroundColor3 = Theme.Section, BorderSizePixel = 0, Size = UDim2.new(0.5, -4, 1, 0),
    FontFace = F(Enum.FontWeight.SemiBold), Text = "check executor", TextColor3 = Theme.Text, TextSize = 14, AutoButtonColor = false}, {Corner(6), Stroke(Theme.Inline, 1)})

local Btn = New("TextButton", {Parent = ButtonRow, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Theme.Section, BorderSizePixel = 0, Size = UDim2.new(0.5, -4, 1, 0),
    FontFace = F(Enum.FontWeight.SemiBold), Text = Popup.Button, TextColor3 = Theme.Dim, TextSize = 14, AutoButtonColor = false}, {Corner(6)})

local function Tween(Obj, Time, Props)
    local T = TweenService:Create(Obj, TweenInfo.new(Time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), Props)
    T:Play()
    return T
end

local function SetAgreed(Value)
    Agreed = Value
    Tween(Box, 0.15, {BackgroundColor3 = Value and Theme.Accent or Theme.Section})
    Tween(BoxStroke, 0.15, {Color = Value and Theme.Accent or Theme.Inline})
    Tween(Tick, 0.15, {TextTransparency = Value and 0 or 1})
    Tween(Btn, 0.2, {BackgroundColor3 = Value and Theme.Accent or Theme.Section, TextColor3 = Value and Theme.Background or Theme.Dim})
end
AgreeRow.MouseButton1Click:Connect(function() SetAgreed(not Agreed) end)

Btn.MouseEnter:Connect(function() if Agreed then Tween(Btn, 0.15, {BackgroundColor3 = Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.15)}) end end)
Btn.MouseLeave:Connect(function() if Agreed then Tween(Btn, 0.15, {BackgroundColor3 = Theme.Accent}) end end)
Close.MouseEnter:Connect(function() Tween(Close, 0.15, {TextColor3 = Theme.Text}) end)
Close.MouseLeave:Connect(function() Tween(Close, 0.15, {TextColor3 = Theme.Dim}) end)

do
    local Dragging, Start, StartPos
    Header.InputBegan:Connect(function(I)
        if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
            Dragging, Start, StartPos = true, I.Position, Card.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(I)
        if Dragging and (I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch) then
            local D = I.Position - Start
            Card.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + D.X, StartPos.Y.Scale, StartPos.Y.Offset + D.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(I)
        if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

local Results = New("Frame", {Parent = Body, LayoutOrder = 5, Visible = false, BackgroundColor3 = Theme.Section, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}, {
    Corner(6), Stroke(Theme.Inline, 1),
    New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}),
    New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
})

local Good, Warn, Bad = Color3.fromRGB(64, 214, 120), Color3.fromRGB(240, 180, 50), Color3.fromRGB(236, 72, 84)

local function Has(Path)
    local Ok, Value = pcall(function()
        local Cur = getfenv(0)
        for Part in string.gmatch(Path, "[^%.]+") do Cur = Cur[Part] end
        return Cur
    end)
    return Ok and type(Value) == "function"
end

local function AnyOf(...)
    for _, Name in ipairs({...}) do
        if Has(Name) then return true end
    end
    return false
end

local function CanRequire()
    local Module
    for _, D in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if D:IsA("ModuleScript") then Module = D break end
    end
    if not Module then return false end
    return (pcall(require, Module))
end

local Checks = {
    {Name = "Load the script", Required = true, Test = function() return Has("loadstring") end},
    {Name = "Script globals", Required = true, Test = function() return Has("getgenv") end},
    {Name = "Auto farms, buying, cash, dupes", Weight = 3, Test = function() return Has("fireproximityprompt") end},
    {Name = "Gun mods", Weight = 3, Test = CanRequire},
    {Name = "Infinite ammo (fast mode)", Weight = 2, Soft = "uses the backup mode", Test = function() return Has("getsenv") and Has("debug.getupvalue") and Has("debug.setupvalue") end},
    {Name = "Chat, script users, Discord", Weight = 2, Test = function() return AnyOf("request", "http_request", "syn.request", "http.request") end},
    {Name = "Saving configs", Weight = 2, Test = function() return Has("writefile") and Has("readfile") and Has("isfile") and Has("makefolder") end},
    {Name = "ESP", Weight = 1, Soft = "uses the backup drawing", Test = function() return Has("Drawing.new") end},
    {Name = "Game & banner images", Weight = 1, Test = function() return AnyOf("getcustomasset", "getsynasset") end},
    {Name = "Copy buttons", Weight = 1, Test = function() return AnyOf("setclipboard", "toclipboard") end},
}

local function Row(Order, Color, Left, Right)
    local R = New("Frame", {Parent = Results, LayoutOrder = Order, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16)})
    New("Frame", {Parent = R, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = Color, BorderSizePixel = 0}, {Corner(3)})
    New("TextLabel", {Parent = R, BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(0.6, -12, 1, 0), FontFace = F(Enum.FontWeight.Medium),
        Text = Left, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd})
    New("TextLabel", {Parent = R, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), FontFace = F(Enum.FontWeight.Regular),
        Text = Right, TextColor3 = Color, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd})
end

local function RunCheck()
    for _, C in ipairs(Results:GetChildren()) do
        if C:IsA("Frame") or C:IsA("TextLabel") then C:Destroy() end
    end

    local Executor = "Unknown executor"
    pcall(function()
        local Name, Version = (identifyexecutor or getexecutorname)()
        Executor = tostring(Name) .. (Version and (" " .. tostring(Version)) or "")
    end)
    local UIS = game:GetService("UserInputService")
    local Mobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

    local Total, Got, Broken = 0, 0, false
    local Lines = {}
    for I, Check in ipairs(Checks) do
        local Ok = false
        pcall(function() Ok = Check.Test() and true or false end)
        if Check.Required then
            if not Ok then Broken = true end
        else
            Total += Check.Weight
            if Ok or Check.Soft then Got += Ok and Check.Weight or Check.Weight * 0.75 end
        end
        local Color = Ok and Good or (Check.Soft and Warn) or Bad
        local Text = Ok and "works" or (Check.Soft or (Check.Required and "missing, can't run" or "won't work"))
        table.insert(Lines, {Color, Check.Name, Text})
    end

    local Percent = Broken and 0 or math.floor(Got / Total * 100 + 0.5)
    local Verdict, VColor
    if Broken then Verdict, VColor = "Not supported", Bad
    elseif Percent >= 90 then Verdict, VColor = "Fully supported", Good
    elseif Percent >= 60 then Verdict, VColor = "Mostly supported", Warn
    else Verdict, VColor = "Limited support", Bad end

    New("TextLabel", {Parent = Results, LayoutOrder = 0, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), FontFace = F(Enum.FontWeight.Bold),
        Text = Executor .. (Mobile and " (mobile)" or ""), TextColor3 = Theme.Text, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd})
    New("TextLabel", {Parent = Results, LayoutOrder = 1, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), FontFace = F(Enum.FontWeight.SemiBold),
        Text = Verdict .. "  •  " .. Percent .. "% compatible", TextColor3 = VColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
    if Mobile then
        New("TextLabel", {Parent = Results, LayoutOrder = 2, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, FontFace = F(Enum.FontWeight.Regular),
            Text = "On mobile, loading can take up to 2 minutes.", TextColor3 = Theme.Dim, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left})
    end
    New("Frame", {Parent = Results, LayoutOrder = 3, BackgroundColor3 = Theme.Inline, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1)})
    for I, L in ipairs(Lines) do
        Row(10 + I, L[1], L[2], L[3])
    end

    Results.Visible = true
    CheckBtn.Text = "check again"
end

CheckBtn.MouseEnter:Connect(function() Tween(CheckBtn, 0.15, {BackgroundColor3 = Theme.Inline}) end)
CheckBtn.MouseLeave:Connect(function() Tween(CheckBtn, 0.15, {BackgroundColor3 = Theme.Section}) end)
CheckBtn.MouseButton1Click:Connect(function()
    CheckBtn.Text = "checking..."
    task.defer(RunCheck)
end)

local Closing = false
local function Dismiss()
    Tween(Dim, 0.2, {BackgroundTransparency = 1})
    Tween(Card, 0.2, {GroupTransparency = 1, Position = Card.Position + UDim2.fromOffset(0, 12)}).Completed:Wait()
    Gui:Destroy()
end

Btn.MouseButton1Click:Connect(function()
    if Closing then return end
    if not Agreed then
        Tween(BoxStroke, 0.1, {Color = Color3.fromRGB(236, 72, 84)})
        task.delay(0.6, function() if not Agreed then Tween(BoxStroke, 0.2, {Color = Theme.Inline}) end end)
        return
    end
    Closing = true
    Btn.Text = "loading..."
    task.spawn(Dismiss)
    task.spawn(function()
        local Ok, Err = pcall(function()
            loadstring(game:HttpGet("https://nazuro.lol/beta"))()
        end)
        if not Ok then warn("[tha bronx] failed to load:", Err) end
    end)
end)

Close.MouseButton1Click:Connect(function()
    if Closing then return end
    Closing = true
    Dismiss()
end)

Gui.Parent = GuiParent
task.defer(FitToScreen)
Tween(Dim, 0.3, {BackgroundTransparency = 0.45})
Tween(Card, 0.35, {GroupTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)})