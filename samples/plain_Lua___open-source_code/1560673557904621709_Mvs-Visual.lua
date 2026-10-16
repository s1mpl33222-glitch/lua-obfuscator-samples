local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
if not game:IsLoaded() then game.Loaded:Wait() end
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end
local GUI_NAME = "NexvyrToolsVisual"
local LOGO_ID = 14653905878
local BG_ID = 126614954679548
local env = (getgenv and getgenv()) or _G
env.NexvyrCatOverride = env.NexvyrCatOverride or {}
if env.NexvyrToolsVisualCleanup then
    pcall(env.NexvyrToolsVisualCleanup)
end
local conns = {}
local function track(c)
    conns[#conns + 1] = c
    return c
end
local function withTimeout(secs, fn)
    local res, done = nil, false
    task.spawn(function()
        local ok, r = pcall(fn)
        if ok then res = r end
        done = true
    end)
    local t0 = os.clock()
    while not done and os.clock() - t0 < secs do task.wait(0.05) end
    return res
end
local probeCache = {}
local function probeImage(id)
    if probeCache[id] ~= nil then return probeCache[id] end
    local p = Instance.new("ImageLabel")
    p.Image = id
    withTimeout(3, function() ContentProvider:PreloadAsync({ p }) end)
    local ok, loaded = pcall(function() return p.IsLoaded end)
    pcall(function() p:Destroy() end)
    local r = (ok and loaded) and true or false
    probeCache[id] = r
    return r
end
local function textureFromAsset(direct)
    local ok, obj = pcall(function() return game:GetObjects(direct)[1] end)
    if not (ok and obj) then return nil end
    local tex
    if obj:IsA("Decal") or obj:IsA("Texture") then
        tex = obj.Texture
    else
        local d = obj:FindFirstChildWhichIsA("Decal", true)
        if d then tex = d.Texture end
    end
    pcall(function() obj:Destroy() end)
    if tex and tex ~= "" then return tex end
    return nil
end
local Logo = { image = nil, ready = false, subs = {} }
local LOGO_THUMB = "rbxthumb://type=Asset&id=" .. LOGO_ID .. "&w=150&h=150"
local LOGO_DIRECT = "rbxassetid://" .. LOGO_ID
local function logoApply(image)
    if Logo.ready then return end
    Logo.ready, Logo.image = true, image
    for _, fn in ipairs(Logo.subs) do task.spawn(fn, image) end
end
function Logo.onReady(fn)
    Logo.subs[#Logo.subs + 1] = fn
    if Logo.ready then task.spawn(fn, Logo.image) end
end
task.spawn(function()
    task.spawn(function()
        if probeImage(LOGO_THUMB) then logoApply(LOGO_THUMB) end
    end)
    task.spawn(function()
        if probeImage(LOGO_DIRECT) then logoApply(LOGO_DIRECT) end
    end)
    task.spawn(function()
        local tex = textureFromAsset(LOGO_DIRECT)
        if tex and probeImage(tex) then logoApply(tex) end
    end)
    task.delay(3, function()
        if not Logo.ready then logoApply(LOGO_THUMB) end
    end)
end)
local Bg = { image = nil, ready = false, subs = {} }
local BG_THUMB = "rbxthumb://type=Asset&id=" .. BG_ID .. "&w=768&h=432"
local BG_DIRECT = "rbxassetid://" .. BG_ID
local function bgApply(image)
    if Bg.ready then return end
    Bg.ready, Bg.image = true, image
    for _, fn in ipairs(Bg.subs) do task.spawn(fn, image) end
end
function Bg.onReady(fn)
    Bg.subs[#Bg.subs + 1] = fn
    if Bg.ready then task.spawn(fn, Bg.image) end
end
task.spawn(function()
    task.spawn(function()
        if probeImage(BG_THUMB) then bgApply(BG_THUMB) end
    end)
    task.spawn(function()
        if probeImage(BG_DIRECT) then bgApply(BG_DIRECT) end
    end)
    task.spawn(function()
        local tex = textureFromAsset(BG_DIRECT)
        if tex and probeImage(tex) then bgApply(tex) end
    end)
    task.delay(4, function()
        if not Bg.ready then bgApply(BG_THUMB) end
    end)
end)
task.wait(0.2)
local function getParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    ok, ui = pcall(function() return game:GetService("CoreGui") end)
    if ok and ui then
        local t = Instance.new("Folder")
        local good = pcall(function() t.Parent = ui end)
        t:Destroy()
        if good then return ui end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local parent = getParent()
local old = parent:FindFirstChild(GUI_NAME)
if old then old:Destroy() end
local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)
local IC = {
    title = Color3.fromRGB(228, 230, 238),
    titleLow = Color3.fromRGB(168, 172, 190),
    gold = Color3.fromRGB(210, 178, 120),
    goldLight = Color3.fromRGB(240, 214, 160),
    soft = Color3.fromRGB(176, 168, 152),
    btnText = Color3.fromRGB(206, 206, 214),
    btnBg = Color3.fromRGB(10, 10, 14),
    btnBgMain = Color3.fromRGB(64, 56, 44),
    btnLine = Color3.fromRGB(110, 108, 118),
}
local T = {
    text = IC.title,
    sub = IC.soft,
    line = IC.btnLine,
    gold = IC.gold,
    red = Color3.fromRGB(232, 72, 92),
    green = Color3.fromRGB(62, 212, 142),
    warn = Color3.fromRGB(255, 196, 84),
}
local STYLES = {
    main = { bg = IC.btnBgMain, bgT = 0.3, stroke = IC.gold, strokeT = 0.35, text = WHITE },
    dark = { bg = IC.btnBg, bgT = 0.5, stroke = IC.btnLine, strokeT = 0.7, text = IC.btnText },
    danger = { bg = Color3.fromRGB(58, 24, 32), bgT = 0.35, stroke = T.red, strokeT = 0.5, text = Color3.fromRGB(255, 214, 220) },
    green = { bg = Color3.fromRGB(22, 58, 42), bgT = 0.3, stroke = T.green, strokeT = 0.5, text = WHITE },
}
local UI = {}
local touchOnly = UIS.TouchEnabled and not UIS.MouseEnabled
function UI.new(class, props)
    local o = Instance.new(class)
    local p
    for k, v in pairs(props) do
        if k == "Parent" then p = v else o[k] = v end
    end
    if p then o.Parent = p end
    return o
end
local new = UI.new
function UI.corner(o, r)
    return new("UICorner", { Parent = o, CornerRadius = UDim.new(0, r) })
end
local corner = UI.corner
function UI.stroke(o, color, thick, trans)
    return new("UIStroke", {
        Parent = o, Color = color, Thickness = thick or 1,
        Transparency = trans or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end
local stroke = UI.stroke
function UI.grad(o, c1, c2, rot)
    return new("UIGradient", { Parent = o, Color = ColorSequence.new(c1, c2), Rotation = rot or 90 })
end
local grad = UI.grad
function UI.tween(o, info, props)
    local t = TweenService:Create(o, info, props)
    t:Play()
    return t
end
local tween = UI.tween
local gui = new("ScreenGui", {
    Name = GUI_NAME, ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})
function UI.viewport()
    local s = gui.AbsoluteSize
    if s.X < 10 or s.Y < 10 then s = workspace.CurrentCamera.ViewportSize end
    return s
end
function UI.clampPos(target, x, y)
    local vp = UI.viewport()
    local sz = target.AbsoluteSize
    return math.clamp(x, 0, math.max(0, vp.X - sz.X)), math.clamp(y, 0, math.max(0, vp.Y - sz.Y))
end
local clampPos = UI.clampPos
function UI.draggable(handle, target, onTap, onDown, onUp)
    local dragging, moved, active, startIn, startX, startY = false, false, nil, nil, 0, 0
    track(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging, moved, active = true, false, input
            startIn = input.Position
            startX, startY = target.Position.X.Offset, target.Position.Y.Offset
            if onDown then onDown() end
            local c
            c = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    c:Disconnect()
                    local wasDrag = moved
                    dragging = false
                    if onUp then onUp(wasDrag) end
                    if not wasDrag and onTap then onTap() end
                end
            end)
        end
    end))
    track(UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input == active then
            local d = input.Position - startIn
            if not moved and d.Magnitude < 6 then return end
            moved = true
            local x, y = clampPos(target, startX + d.X, startY + d.Y)
            target.Position = UDim2.fromOffset(x, y)
        end
    end))
end
function UI.logo(img, fallback)
    img.ImageTransparency = 1
    if fallback then fallback.Visible = true end
    Logo.onReady(function(image)
        if not image or not img.Parent then return end
        img.Image = image
        tween(img, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 })
        if fallback then
            task.delay(0.25, function() fallback.Visible = false end)
        end
    end)
end
function UI.background(host, overlayT)
    local holder = new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true,
    })
    local img = new("ImageLabel", {
        Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Crop, Image = "", ImageTransparency = 1,
    })
    local sc = new("UIScale", { Parent = img, Scale = 1.12 })
    new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = overlayT, BorderSizePixel = 0,
    })
    local shade = new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = 0, BorderSizePixel = 0,
    })
    new("UIGradient", {
        Parent = shade, Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(0.5, 0.85),
            NumberSequenceKeypoint.new(1, 0.3),
        }),
    })
    Bg.onReady(function(image)
        if not image or not img.Parent then return end
        img.Image = image
        tween(img, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 })
    end)
    return sc
end
function UI.icon(kind, parent_, color, size)
    size = size or 16
    local root = new("Frame", {
        Parent = parent_, Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1,
    })
    local inner = new("Frame", {
        Parent = root, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
    })
    new("UIScale", { Parent = inner, Scale = size / 16 })
    local fills, strokes = {}, {}
    local function bar(cx, cy, w, h, rot)
        local f = new("Frame", {
            Parent = inner, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
            Size = UDim2.fromOffset(w, h), Rotation = rot or 0, BackgroundColor3 = color, BorderSizePixel = 0,
        })
        corner(f, math.min(w, h) / 2)
        fills[#fills + 1] = f
    end
    local function line(x1, y1, x2, y2, th)
        local dx, dy = x2 - x1, y2 - y1
        local len = math.sqrt(dx * dx + dy * dy)
        bar((x1 + x2) / 2, (y1 + y2) / 2, len, th or 1.8, math.deg(math.atan2(dy, dx)))
    end
    local function box(cx, cy, w, h, r, th)
        local f = new("Frame", {
            Parent = inner, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
            Size = UDim2.fromOffset(w, h), BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(f, r)
        strokes[#strokes + 1] = new("UIStroke", {
            Parent = f, Color = color, Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        })
    end
    if kind == "close" then
        line(3.8, 3.8, 12.2, 12.2, 2)
        line(12.2, 3.8, 3.8, 12.2, 2)
    elseif kind == "min" then
        bar(8, 11, 10, 2)
    elseif kind == "plus" then
        bar(8, 8, 11, 2)
        bar(8, 8, 2, 11)
    elseif kind == "search" then
        box(7, 7, 10, 10, 5, 1.6)
        line(10.8, 10.8, 14.2, 14.2, 2)
    elseif kind == "trash" then
        box(8, 2.9, 4.6, 3.2, 1.4, 1.4)
        bar(8, 4.9, 12.5, 1.8)
        box(8, 10.6, 9, 8.6, 2, 1.5)
        bar(6.2, 10.8, 1.3, 4.6)
        bar(9.8, 10.8, 1.3, 4.6)
    end
    local icon = { root = root }
    function icon.set(c)
        for _, f in ipairs(fills) do f.BackgroundColor3 = c end
        for _, s in ipairs(strokes) do s.Color = c end
    end
    return icon
end
function UI.button(o)
    local S = STYLES[o.style or "dark"]
    local b = new("TextButton", {
        Parent = o.parent, Size = o.size, BackgroundColor3 = S.bg, BackgroundTransparency = S.bgT,
        AutoButtonColor = false, Text = "", BorderSizePixel = 0, LayoutOrder = o.order or 0,
    })
    if o.pos then b.Position = o.pos end
    if o.anchor then b.AnchorPoint = o.anchor end
    corner(b, o.radius or 4)
    local st = stroke(b, S.stroke, 1, S.strokeT)
    local sc = new("UIScale", { Parent = b, Scale = 1 })
    local row = new("Frame", { Parent = b, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = row, FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
    })
    local tc = o.textColor or S.text
    local icColor = o.iconColor or tc
    local ic, lbl
    if o.icon then
        ic = UI.icon(o.icon, row, icColor, o.iconSize or 14)
        ic.root.LayoutOrder = 1
    end
    if o.text then
        lbl = new("TextLabel", {
            Parent = row, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 16), Text = o.text, Font = Enum.Font.GothamMedium,
            TextSize = o.textSize or 12, TextColor3 = tc, LayoutOrder = 2,
        })
    end
    local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
    local pinfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local rinfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local function paint(mode)
        local bgT, stT, bgC
        if mode == "hover" then
            bgT, stT = math.max(0, S.bgT - 0.18), math.max(0, S.strokeT - 0.3)
            bgC = S.bg:Lerp(S.stroke, 0.18)
        elseif mode == "press" then
            bgT, stT = math.max(0, S.bgT - 0.3), math.max(0, S.strokeT - 0.4)
            bgC = S.bg:Lerp(S.stroke, 0.3)
        else
            bgT, stT, bgC = S.bgT, S.strokeT, S.bg
        end
        tween(b, info, { BackgroundTransparency = bgT, BackgroundColor3 = bgC })
        tween(st, info, { Transparency = stT })
    end
    b.MouseEnter:Connect(function()
        if touchOnly then return end
        paint("hover")
        if ic and o.iconHover then ic.set(o.iconHover) end
    end)
    b.MouseLeave:Connect(function()
        paint("idle")
        tween(sc, rinfo, { Scale = 1 })
        if ic and o.iconHover then ic.set(icColor) end
    end)
    b.MouseButton1Down:Connect(function()
        paint("press")
        tween(sc, pinfo, { Scale = 0.95 })
        if ic and o.iconHover then ic.set(o.iconHover) end
    end)
    b.MouseButton1Up:Connect(function()
        tween(sc, rinfo, { Scale = 1 })
        if touchOnly then
            paint("idle")
            if ic and o.iconHover then ic.set(icColor) end
        else
            paint("hover")
        end
    end)
    local h = { btn = b, label = lbl, icon = ic, stroke = st }
    function h.setStyle(name)
        S = STYLES[name] or S
        local c = o.textColor or S.text
        if lbl then lbl.TextColor3 = c end
        if ic and not o.iconColor then ic.set(c) end
        tween(st, info, { Color = S.stroke })
        paint("idle")
    end
    return h
end
local makeButton = UI.button
function UI.winButton(parent_, kind, xOff, accent)
    local b = new("TextButton", {
        Parent = parent_, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOff, 0.5, 0),
        Size = UDim2.fromOffset(28, 28), BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.45,
        AutoButtonColor = false, Text = "", BorderSizePixel = 0,
    })
    corner(b, 4)
    local st = stroke(b, IC.btnLine, 1, 0.65)
    local sc = new("UIScale", { Parent = b, Scale = 1 })
    local ic = UI.icon(kind, b, IC.soft, 14)
    ic.root.AnchorPoint = Vector2.new(0.5, 0.5)
    ic.root.Position = UDim2.fromScale(0.5, 0.5)
    local info = TweenInfo.new(0.14, Enum.EasingStyle.Quad)
    local pinfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local rinfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local function state(bgColor, bgT, strokeColor, strokeT, iconColor)
        tween(b, info, { BackgroundColor3 = bgColor, BackgroundTransparency = bgT })
        tween(st, info, { Color = strokeColor, Transparency = strokeT })
        ic.set(iconColor)
    end
    local function idle() state(IC.btnBg, 0.45, IC.btnLine, 0.65, IC.soft) end
    local function over() state(accent:Lerp(BLACK, 0.7), 0.15, accent, 0.2, WHITE) end
    b.MouseEnter:Connect(function()
        if touchOnly then return end
        over()
        if kind == "close" then
            tween(ic.root, rinfo, { Rotation = 90 })
        end
    end)
    b.MouseLeave:Connect(function()
        idle()
        tween(sc, rinfo, { Scale = 1 })
        tween(ic.root, rinfo, { Rotation = 0 })
    end)
    b.MouseButton1Down:Connect(function()
        over()
        tween(sc, pinfo, { Scale = 0.88 })
    end)
    b.MouseButton1Up:Connect(function()
        tween(sc, rinfo, { Scale = 1 })
        if touchOnly then
            idle()
        else
            over()
        end
    end)
    return b
end
function UI.modal(host)
    local overlay = new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, Visible = false, ZIndex = 100,
    })
    local box = new("Frame", {
        Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(300, 142), BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.08,
        BorderSizePixel = 0, ZIndex = 101,
    })
    corner(box, 6)
    local boxStroke = stroke(box, WHITE, 1.2, 0.2)
    grad(boxStroke, IC.gold, IC.btnLine, 60)
    local scale = new("UIScale", { Parent = box, Scale = 0.9 })
    local title = new("TextLabel", {
        Parent = box, Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -28, 0, 26),
        BackgroundTransparency = 1, Text = "", Font = Enum.Font.Garamond,
        TextSize = 22, TextColor3 = IC.title, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102,
    })
    local text = new("TextLabel", {
        Parent = box, Position = UDim2.fromOffset(14, 42), Size = UDim2.new(1, -28, 0, 34),
        BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = IC.soft, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 102,
    })
    local left = makeButton({
        parent = box, text = "Volver", size = UDim2.fromOffset(129, 34),
        pos = UDim2.fromOffset(14, 94), style = "dark", textSize = 13,
    })
    local right = makeButton({
        parent = box, text = "Aceptar", size = UDim2.fromOffset(129, 34),
        pos = UDim2.fromOffset(157, 94), style = "danger", textSize = 13,
    })
    for _, d in ipairs(box:GetDescendants()) do
        if d:IsA("GuiObject") and d.ZIndex < 102 then d.ZIndex = 102 end
    end
    local m = {}
    local cbLeft, cbRight
    local showToken = 0
    function m.show(o)
        showToken = showToken + 1
        title.Text = o.title or ""
        text.Text = o.text or ""
        left.label.Text = o.leftText or "Volver"
        right.label.Text = o.rightText or "Aceptar"
        left.setStyle(o.leftStyle or "dark")
        right.setStyle(o.rightStyle or "danger")
        cbLeft, cbRight = o.onLeft, o.onRight
        overlay.Visible = true
        tween(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 0.45 })
        scale.Scale = 0.9
        tween(scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
    end
    function m.hide()
        showToken = showToken + 1
        local my = showToken
        tween(scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.9 })
        local t = tween(overlay, TweenInfo.new(0.18), { BackgroundTransparency = 1 })
        t.Completed:Connect(function()
            if showToken == my then overlay.Visible = false end
        end)
    end
    left.btn.MouseButton1Click:Connect(function()
        m.hide()
        if cbLeft then cbLeft() end
    end)
    right.btn.MouseButton1Click:Connect(function()
        m.hide()
        if cbRight then cbRight() end
    end)
    return m
end
local W, H = 540, 330
local vp0 = UI.viewport()
local BASE = math.min(1, (vp0.Y - 24) / H, (vp0.X - 24) / W)
local Root = new("Frame", {
    Parent = gui, BackgroundTransparency = 1, Active = true,
    Size = UDim2.fromOffset(W * BASE, H * BASE),
    Position = UDim2.fromOffset(math.floor((vp0.X - W * BASE) / 2), math.floor((vp0.Y - H * BASE) / 2)),
    Visible = false,
})
local Window = new("CanvasGroup", {
    Parent = Root, AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H),
    BackgroundColor3 = BLACK, BackgroundTransparency = 0, BorderSizePixel = 0,
    Active = true, GroupTransparency = 1,
})
corner(Window, 8)
local winStroke = stroke(Window, WHITE, 1.2, 0.2)
grad(winStroke, IC.gold, IC.btnLine, 60)
local winScale = new("UIScale", { Parent = Window, Scale = BASE * 0.6 })
local bgScale = UI.background(Window, 0.5)
local TopBar = new("Frame", {
    Parent = Window, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1,
})
local headLine = new("Frame", {
    Parent = Window, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 42),
    Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = IC.gold, BorderSizePixel = 0,
})
new("UIGradient", {
    Parent = headLine,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    }),
})
local dragArea = new("Frame", {
    Parent = TopBar, Size = UDim2.new(1, -86, 1, 0), BackgroundTransparency = 1, Active = true,
})
local logo = new("Frame", {
    Parent = TopBar, Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(26, 26),
    BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true,
})
corner(logo, 8)
local logoImg = new("ImageLabel", {
    Parent = logo, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop, Image = "", BorderSizePixel = 0, ImageTransparency = 1,
})
corner(logoImg, 8)
UI.logo(logoImg)
local titleMain = new("TextLabel", {
    Parent = TopBar, Position = UDim2.fromOffset(48, 3), Size = UDim2.fromOffset(330, 24),
    BackgroundTransparency = 1, Text = "NEXVYRHUB | TOOLS VISUAL", Font = Enum.Font.Garamond,
    TextSize = 22, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left,
    TextStrokeTransparency = 0.88, TextStrokeColor3 = BLACK,
})
grad(titleMain, IC.title, IC.titleLow, 90)
new("TextLabel", {
    Parent = TopBar, Position = UDim2.fromOffset(48, 25), Size = UDim2.fromOffset(330, 14),
    BackgroundTransparency = 1, Text = "https://discord.gg/j3jfkkDG3Q", Font = Enum.Font.Garamond,
    TextSize = 15, TextColor3 = IC.soft, TextXAlignment = Enum.TextXAlignment.Left,
})
local btnMin = UI.winButton(TopBar, "min", -44, IC.gold)
local btnClose = UI.winButton(TopBar, "close", -10, T.red)
UI.draggable(dragArea, Root)
local Left = new("Frame", {
    Parent = Window, Position = UDim2.fromOffset(10, 52), Size = UDim2.fromOffset(190, 268),
    BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.4, BorderSizePixel = 0,
})
corner(Left, 6)
stroke(Left, IC.btnLine, 1, 0.65)
local previewHolder = new("Frame", {
    Parent = Left, Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(170, 170),
    BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.35, BorderSizePixel = 0, ClipsDescendants = true,
})
corner(previewHolder, 6)
local prevStroke = stroke(previewHolder, WHITE, 1, 0.3)
grad(prevStroke, IC.gold, IC.btnLine, 45)
local previewContent = new("Frame", {
    Parent = previewHolder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
})
local previewHint = new("TextLabel", {
    Parent = previewHolder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "Sin seleccion", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = IC.soft,
})
local nameLabel = new("TextLabel", {
    Parent = Left, Position = UDim2.fromOffset(10, 188), Size = UDim2.fromOffset(170, 20),
    BackgroundTransparency = 1, Text = "-", Font = Enum.Font.GothamBold, TextSize = 14,
    TextColor3 = IC.title, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
})
local idChip = new("Frame", {
    Parent = Left, Position = UDim2.fromOffset(10, 210), Size = UDim2.fromOffset(0, 16),
    AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = IC.btnBgMain, BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
})
corner(idChip, 4)
new("UIPadding", { Parent = idChip, PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7) })
local idLabel = new("TextLabel", {
    Parent = idChip, Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X,
    BackgroundTransparency = 1, Text = "-", Font = Enum.Font.GothamMedium, TextSize = 10,
    TextColor3 = IC.gold,
})
local btnMove = makeButton({
    parent = Left, text = "> Pistolas", size = UDim2.fromOffset(78, 18),
    pos = UDim2.fromOffset(102, 209), style = "dark", textSize = 10,
})
btnMove.btn.Visible = false
local statusDot = new("Frame", {
    Parent = Left, Position = UDim2.fromOffset(12, 238), Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = IC.soft, BorderSizePixel = 0,
})
corner(statusDot, 3)
local statusLabel = new("TextLabel", {
    Parent = Left, Position = UDim2.fromOffset(24, 232), Size = UDim2.fromOffset(156, 24),
    BackgroundTransparency = 1, Text = "Iniciando...", Font = Enum.Font.Gotham,
    TextSize = 11, TextColor3 = IC.soft, TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
})
local progressTrack = new("Frame", {
    Parent = Left, Position = UDim2.fromOffset(10, 260), Size = UDim2.fromOffset(170, 3),
    BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.3, BorderSizePixel = 0, ClipsDescendants = true,
})
corner(progressTrack, 2)
local progressFill = new("Frame", {
    Parent = progressTrack, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0,
})
corner(progressFill, 2)
grad(progressFill, IC.gold, IC.goldLight, 0)
local function setStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or IC.soft
    statusDot.BackgroundColor3 = color or IC.soft
end
local function setProgress(p)
    tween(progressFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0),
    })
end
local Right = new("Frame", {
    Parent = Window, Position = UDim2.fromOffset(210, 52), Size = UDim2.fromOffset(320, 268),
    BackgroundTransparency = 1,
})
local inputBox = new("Frame", {
    Parent = Right, Size = UDim2.fromOffset(240, 36), BackgroundColor3 = IC.btnBg,
    BackgroundTransparency = 0.4, BorderSizePixel = 0,
})
corner(inputBox, 4)
local inputStroke = stroke(inputBox, IC.btnLine, 1, 0.55)
local searchIcon = UI.icon("search", inputBox, IC.soft, 15)
searchIcon.root.Position = UDim2.fromOffset(10, 10)
local input = new("TextBox", {
    Parent = inputBox, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -42, 1, 0),
    BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", PlaceholderText = "Buscar cuchillo",
    PlaceholderColor3 = IC.soft, TextColor3 = IC.title, Font = Enum.Font.GothamMedium,
    TextSize = 13, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
    ClipsDescendants = true,
})
input.Focused:Connect(function()
    tween(inputStroke, TweenInfo.new(0.15), { Color = IC.gold, Transparency = 0.2 })
    searchIcon.set(IC.gold)
end)
input.FocusLost:Connect(function()
    tween(inputStroke, TweenInfo.new(0.15), { Color = IC.btnLine, Transparency = 0.55 })
    searchIcon.set(IC.soft)
end)
local btnSearch = makeButton({
    parent = Right, text = "Buscar", size = UDim2.fromOffset(74, 36),
    pos = UDim2.fromOffset(246, 0), style = "main", textSize = 12,
})
local btnApply = makeButton({
    parent = Right, text = "Aplicar cuchillo", icon = "plus", size = UDim2.fromOffset(156, 34),
    pos = UDim2.fromOffset(0, 44), style = "main",
})
local btnRemove = makeButton({
    parent = Right, text = "Borrar cuchillo", icon = "trash", size = UDim2.fromOffset(156, 34),
    pos = UDim2.fromOffset(164, 44), style = "danger",
})
local tabBar = new("Frame", {
    Parent = Right, Position = UDim2.fromOffset(0, 86), Size = UDim2.fromOffset(220, 30),
    BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.4, BorderSizePixel = 0,
})
corner(tabBar, 4)
stroke(tabBar, IC.btnLine, 1, 0.65)
local tabStrokes = {}
local function makeTab(text, x, key)
    local t = new("TextButton", {
        Parent = tabBar, Position = UDim2.fromOffset(x, 3), Size = UDim2.fromOffset(70, 24),
        BackgroundColor3 = IC.btnBgMain, BackgroundTransparency = 1, AutoButtonColor = false,
        Text = text, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = IC.soft, BorderSizePixel = 0,
    })
    corner(t, 3)
    tabStrokes[key] = stroke(t, IC.gold, 1, 1)
    return t
end
local tabButtons = {
    knives = makeTab("Cuchillos", 3, "knives"),
    guns = makeTab("Pistolas", 75, "guns"),
    effects = makeTab("Efectos", 147, "effects"),
}
local countLabel = new("TextLabel", {
    Parent = Right, Position = UDim2.fromOffset(226, 86), Size = UDim2.fromOffset(94, 30),
    BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamMedium, TextSize = 11,
    TextColor3 = IC.soft, TextXAlignment = Enum.TextXAlignment.Right,
})
local listFrame = new("ScrollingFrame", {
    Parent = Right, Position = UDim2.fromOffset(0, 124), Size = UDim2.fromOffset(320, 144),
    BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.4, BorderSizePixel = 0, ScrollBarThickness = 3,
    ScrollBarImageColor3 = IC.gold, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y, ClipsDescendants = true,
})
corner(listFrame, 6)
stroke(listFrame, IC.btnLine, 1, 0.65)
new("UIPadding", {
    Parent = listFrame, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
})
new("UIGridLayout", {
    Parent = listFrame, CellSize = UDim2.fromOffset(94, 98), CellPadding = UDim2.fromOffset(6, 6),
    SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center,
})
local emptyLabel = new("TextLabel", {
    Parent = Right, Position = UDim2.fromOffset(0, 124), Size = UDim2.fromOffset(320, 144),
    BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = IC.soft, Visible = false, ZIndex = 5,
})
local Modal = UI.modal(Window)
local PAGE = 18
local Data = { knives = {}, guns = {}, effects = {} }
local Scan = { running = false, done = false }
local Selected = { knives = nil, guns = nil, effects = nil }
local activeTab = "knives"
local busy = false
local Spin = { cam = nil, center = Vector3.zero, dist = 10, ang = 0 }
local paintCards
local TAB_INFO = {
    knives = {
        apply = "Aplicar cuchillo", remove = "Borrar cuchillo", ph = "Buscar cuchillo",
        plural = " cuchillos", empty = "No se encontraron cuchillos.", cat = "melee",
    },
    guns = {
        apply = "Aplicar pistola", remove = "Borrar pistola", ph = "Buscar pistola",
        plural = " pistolas", empty = "No se encontraron pistolas.", cat = "gun",
    },
    effects = {
        apply = "Aplicar efecto", remove = "Borrar efecto", ph = "Buscar kill effect",
        plural = " kill effects", empty = "No se encontraron kill effects.",
    },
}

local M = (function()
    local M = {}
    local wIndex = {}
    local guiMap, guiCat, iconMap = {}, {}, {}
    local assetIndex
    local function norm(s)
        s = tostring(s):gsub("(%l)(%u)", "%1 %2")
        s = s:gsub("[_%-%.]+", " ")
        return s:lower()
    end
    local function squash(s)
        local r = tostring(s):lower():gsub("[^%w]", "")
        return r
    end
    local function hasAny(n, list)
        for _, k in ipairs(list) do
            if n:find(k, 1, true) then return true end
        end
        return false
    end
    local function hasWordKW(n, list)
        local p = " " .. n .. " "
        for _, k in ipairs(list) do
            if p:find("[^%w]" .. k .. "s?[^%w]") then return true end
        end
        return false
    end
    local function hasWord(n, list)
        for _, b in ipairs(list) do
            if n:find("%f[%a]" .. b .. "%f[%A]") then return true end
        end
        return false
    end
    local function hasNameWord(n, list)
        for _, k in ipairs(list) do
            if n:find("%f[%a]" .. k .. "%f[%A]") then return true end
        end
        return false
    end
    local PRIORITY = { "hipotermia", "hypothermia", "hipothermia", "hypotermia" }
    local ALIAS = { hipotermia = "hypothermia", hypothermia = "hipotermia" }
    local function isPriority(name)
        local n = squash(name)
        for _, k in ipairs(PRIORITY) do
            if n:find(k, 1, true) then return true end
        end
        return false
    end
    local function nameKeys(name)
        local k = squash(name)
        local list = { k }
        for a, b in pairs(ALIAS) do
            if k:find(a, 1, true) then
                list[#list + 1] = (k:gsub(a, b))
            end
        end
        return list
    end
    local BLADE_SUB = {
        "blade", "knife", "knives", "cuchillo", "dagger", "daga", "sword", "espada", "katana",
        "sabre", "saber", "machete", "scythe", "kunai", "karambit",
        "cleaver", "stiletto", "rapier", "scimitar", "cutlass", "kukri", "wakizashi",
        "nodachi", "bayonet", "bayoneta", "navaja",
    }
    local BLADE_WORD = { "axe", "tanto", "shank", "pico", "katar", "machette", "hatchet", "hacha" }
    local GUN_SUB = {
        "pistol", "pistola", "handgun", "revolver", "rifle", "shotgun", "escopeta", "sniper",
        "francotirador", "blaster", "launcher", "lanzador", "bazooka", "minigun", "firearm",
        "carbine", "carabina", "musket", "mosquete", "flintlock", "derringer", "uzi", "glock",
        "deagle", "desert eagle", "thompson", "winchester", "remington", "barrett", "machinegun",
        "arma de fuego",
    }
    local GUN_WORD = {
        "gun", "smg", "ak47", "ak 47", "m4", "m16", "ar15", "ar 15", "rpg", "mg42",
        "mac10", "mac 10", "mp5", "p90", "aug", "famas", "galil", "tommy", "bren", "sten",
        "welrod", "luger", "colt", "awp", "scar", "vector",
    }
    local GUN_HINT = { "muzzle", "ammo", "reload", "bullet", "shoot", "recoil", "magazine", "fire rate", "firerate", "barrel" }
    local MELEE_HINT = { "slash", "stab", "swing", "lunge", "backstab", "throw" }
    local function catOfName(name)
        local n = norm(name)
        if hasNameWord(n, BLADE_SUB) or hasWordKW(n, BLADE_WORD) then return "melee" end
        if hasNameWord(n, GUN_SUB) or hasWordKW(n, GUN_WORD) then return "gun" end
        return nil
    end
    local function catOfContent(inst)
        local gun, mel, count = 0, 0, 0
        for _, d in ipairs(inst:GetDescendants()) do
            count = count + 1
            if count > 200 then break end
            local n = norm(d.Name)
            if hasAny(n, GUN_HINT) then gun = gun + 1 end
            if hasAny(n, MELEE_HINT) then mel = mel + 1 end
        end
        for k in pairs(inst:GetAttributes()) do
            local n = norm(k)
            if hasAny(n, GUN_HINT) then gun = gun + 1 end
            if hasAny(n, MELEE_HINT) then mel = mel + 1 end
        end
        if gun > mel and gun > 0 then return "gun" end
        if mel > gun and mel > 0 then return "melee" end
        return nil
    end
    local function stopWalk(p)
        if p == game or p == workspace then return true end
        if p:IsA("Backpack") or p:IsA("Player") then return true end
        if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
        return false
    end
    local function classifyWeapon(inst)
        local c = catOfName(inst.Name)
        if c then return c end
        local p, depth = inst.Parent, 0
        while p and depth < 6 and not stopWalk(p) do
            c = catOfName(p.Name)
            if c then return c end
            p = p.Parent
            depth = depth + 1
        end
        return nil
    end
    local function partsOf(inst)
        local list = {}
        if inst:IsA("BasePart") then list[1] = inst end
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("BasePart") then list[#list + 1] = d end
        end
        return list
    end
    local function boundsIn(parts, ref)
        local inv = ref:Inverse()
        local mn, mx
        local cx, cy, cz, tw = 0, 0, 0, 0
        for _, p in ipairs(parts) do
            local cf = inv * p.CFrame
            local s = p.Size / 2
            for ix = -1, 1, 2 do
                for iy = -1, 1, 2 do
                    for iz = -1, 1, 2 do
                        local v = cf:PointToWorldSpace(Vector3.new(s.X * ix, s.Y * iy, s.Z * iz))
                        if not mn then
                            mn, mx = v, v
                        else
                            mn = Vector3.new(math.min(mn.X, v.X), math.min(mn.Y, v.Y), math.min(mn.Z, v.Z))
                            mx = Vector3.new(math.max(mx.X, v.X), math.max(mx.Y, v.Y), math.max(mx.Z, v.Z))
                        end
                    end
                end
            end
            local vol = p.Size.X * p.Size.Y * p.Size.Z
            local pos = cf.Position
            cx = cx + pos.X * vol
            cy = cy + pos.Y * vol
            cz = cz + pos.Z * vol
            tw = tw + vol
        end
        if not mn then return Vector3.zero, Vector3.new(1, 1, 1), Vector3.zero end
        local center = (mn + mx) / 2
        local cen = center
        if tw > 0 then cen = Vector3.new(cx / tw, cy / tw, cz / tw) end
        return center, mx - mn, cen
    end
    local function refPartOf(parts)
        local ref = parts[1]
        for _, p in ipairs(parts) do
            if p.Name == "Handle" then
                ref = p
                break
            end
        end
        return ref
    end
    local NON_WEAPON_KIDS = {
        "Humanoid", "ClickDetector", "ProximityPrompt", "Seat", "VehicleSeat",
    }
    local function looksLikeProp(inst)
        for _, c in ipairs(NON_WEAPON_KIDS) do
            if inst:FindFirstChild(c, true) then return true end
        end
        return false
    end
    local function hasWeaponShape(inst)
        if inst:IsA("Tool") then return true end
        if inst:FindFirstChild("Handle") then return true end
        local hasMesh = inst:IsA("MeshPart")
        if not hasMesh then
            for _, d in ipairs(inst:GetDescendants()) do
                if d:IsA("MeshPart") or d:IsA("SpecialMesh") then
                    hasMesh = true
                    break
                end
            end
        end
        if not hasMesh then return false end
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("Attachment") then return true end
        end
        return false
    end
    local function shapeCat(inst)
        if not hasWeaponShape(inst) then return nil end
        local parts = partsOf(inst)
        if #parts == 0 then return nil end
        local _, s = boundsIn(parts, refPartOf(parts).CFrame)
        local a = { s.X, s.Y, s.Z }
        table.sort(a, function(x, y) return x > y end)
        if a[1] <= 0 then return nil end
        if a[2] / a[1] >= 0.45 then return "gun" end
        return "melee"
    end
    local function sizeOk(inst)
        local parts = partsOf(inst)
        if #parts == 0 then return false end
        local _, s = boundsIn(parts, refPartOf(parts).CFrame)
        local a = { s.X, s.Y, s.Z }
        table.sort(a, function(x, y) return x > y end)
        local long, mid = a[1], a[2]
        if long < 0.8 or long > 10 then return false end
        if long <= 0 then return false end
        return (mid / long) <= 0.7
    end
    local function meshSig(inst)
        local ids = {}
        local function add(d)
            if d:IsA("MeshPart") then
                if d.MeshId ~= "" then ids[#ids + 1] = d.MeshId .. d.TextureID end
            elseif d:IsA("SpecialMesh") then
                if d.MeshId ~= "" then ids[#ids + 1] = d.MeshId .. d.TextureId end
            end
        end
        add(inst)
        local n = 0
        for _, d in ipairs(inst:GetDescendants()) do
            add(d)
            n = n + 1
            if n > 80 then break end
        end
        if #ids == 0 then return "" end
        table.sort(ids)
        return table.concat(ids, "|", 1, math.min(#ids, 5))
    end
    local function catOfTool(t)
        local ov = env.NexvyrCatOverride
        local o = ov and ov[t.Name:lower()]
        if o then return o end
        local c = classifyWeapon(t)
        if c then return c end
        c = catOfContent(t)
        if c then return c end
        return shapeCat(t)
    end
    local FX_CLASSES = {
        "ParticleEmitter", "Beam", "Trail", "Fire", "Smoke", "Sparkles", "Explosion",
        "PointLight", "SpotLight", "SurfaceLight", "Highlight",
    }
    local KILL_BAD = {
        "feed", "streak", "count", "counter", "brick", "zone", "trap", "gui", "hud", "board",
        "announcer", "notification", "message", "script", "remote",
        "sound", "sounds", "sfx", "music", "audio", "ambient", "voice", "song", "track",
    }
    local KILL_NAMES = {
        "kill", "elimination", "eliminat", "finisher", "finish", "execution", "execut",
        "slay", "fatal", "death", "dead", "dying", "takedown", "takedowns",
        "assassin", "wraith", "killer", "killers",
    }
    local KILL_FX_TERMS = { "effect", "efecto", "fx", "vfx", "animation", "anim", "sound", "particle" }
    local EFFECT_TERMS = {
        "effect", "efecto", "fx", "vfx", "slash", "impact", "hit", "trail", "beam",
        "particle", "aura", "glow", "spark", "explosion", "burst", "impacto", "golpe",
        "kill", "death", "finisher", "execution", "slay", "fatal", "takedown",
    }
    local SOUND_BAD = {
        "sound", "sounds", "sfx", "music", "audio", "ambient", "loop", "voice",
        "song", "track", "noise", "snd",
    }
    local function isFx(i)
        for _, c in ipairs(FX_CLASSES) do
            if i:IsA(c) then return true end
        end
        return false
    end
    local function hasFxDeep(inst)
        if isFx(inst) then return true end
        for _, d in inst:GetDescendants() do
            if isFx(d) then return true end
        end
        return false
    end
    local function skipCommon(inst)
        if inst:GetAttribute("NxTV") then return true end
        if inst:IsA("LuaSourceContainer") or inst:IsA("GuiBase") or inst:IsA("LayerCollector") then return true end
        if inst:IsA("Terrain") or inst:IsA("Camera") or inst:IsA("Humanoid") then return true end
        if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") or inst:IsA("BindableEvent") or inst:IsA("BindableFunction") then
            return true
        end
        if inst:IsA("Model") and Players:GetPlayerFromCharacter(inst) then return true end
        return false
    end
    local function skipFx(inst)
        if skipCommon(inst) then return true end
        if inst:IsA("Tool") or inst:IsA("Accessory") or inst:IsA("Accoutrement") then return true end
        if inst:IsA("Model") and inst:FindFirstChildOfClass("Humanoid") then return true end
        return false
    end
    local SKIP_CLASS = {
        CoreGui = true, CorePackages = true, RobloxPluginGuiService = true, PluginGuiService = true,
        NetworkClient = true, Players = true, Stats = true, TestService = true, LogService = true,
    }
    local function scanRoots()
        local list = {}
        for _, s in ipairs(game:GetChildren()) do
            if not SKIP_CLASS[s.ClassName] then list[#list + 1] = s end
        end
        for _, c in ipairs(LocalPlayer:GetChildren()) do
            if c.Name ~= "PlayerGui" and c.Name ~= "PlayerScripts" and c.Name ~= "Backpack" then
                list[#list + 1] = c
            end
        end
        return list
    end
    local function allInstances()
        local list = {}
        for _, root in ipairs(scanRoots()) do
            list[#list + 1] = root
            local ok, d = pcall(function() return root:GetDescendants() end)
            if ok then
                for _, x in ipairs(d) do list[#list + 1] = x end
            end
            task.wait()
        end
        return list
    end
    local function stripJunk(root)
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("LuaSourceContainer") then
                pcall(function() d:Destroy() end)
            end
        end
    end
    local function collectAnims(inst)
        local specs = {}
        local function add(a)
            if a.AnimationId ~= "" then
                specs[#specs + 1] = { id = a.AnimationId, name = a.Name }
            end
        end
        if inst:IsA("Animation") then add(inst) end
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("Animation") then add(d) end
        end
        return specs
    end
    local function existsInGame(inst)
        if not inst then return false end
        local ok, r = pcall(function() return inst:IsDescendantOf(game) end)
        return ok and r
    end
    local function killContent(i)
        if isFx(i) or i:IsA("Sound") or i:IsA("Animation") or i:IsA("Attachment") or i:IsA("BasePart") then
            return true
        end
        for _, d in ipairs(i:GetDescendants()) do
            if isFx(d) or d:IsA("Sound") or d:IsA("Animation") or d:IsA("Attachment") or d:IsA("BasePart") then
                return true
            end
        end
        return false
    end
    local function fxInfo(inst)
        local list = {}
        if isFx(inst) then list[#list + 1] = inst end
        for _, d in ipairs(inst:GetDescendants()) do
            if isFx(d) then list[#list + 1] = d end
        end
        local tex, col, col2
        for _, d in ipairs(list) do
            if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
                if not tex then
                    local ok, t = pcall(function() return d.Texture end)
                    if ok and t and t ~= "" then tex = t end
                end
                if not col then
                    local okc, ks = pcall(function() return d.Color.Keypoints end)
                    if okc and ks and #ks > 0 then
                        col, col2 = ks[1].Value, ks[#ks].Value
                    end
                end
            elseif not col and (d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight")) then
                col = d.Color
            end
        end
        return tex, col, col2 or col, #list
    end
    local function addEffect(inst, out, seen, nameOverride, lib)
        if not inst or not inst.Parent then return end
        if inst:IsA("Tool") or inst:IsA("Sound") or inst:IsA("Animation") then return end
        if not hasFxDeep(inst) then return end
        local name = nameOverride or inst.Name
        local key = name:lower()
        if key == "" or seen[key] then return end
        local n2 = norm(name)
        if (hasNameWord(n2, BLADE_SUB) or hasNameWord(n2, GUN_SUB)) and not hasAny(n2, EFFECT_TERMS) then
            return
        end
        if hasWord(n2, SOUND_BAD) then return end
        seen[key] = true
        local tex, col, col2, n = fxInfo(inst)
        out[#out + 1] = {
            tab = "effects", name = name, lname = key, inst = inst, tex = tex, col = col, col2 = col2,
            fxCount = n, priority = isPriority(name), lib = lib or false, imgs = {},
        }
    end
    local function findAssetByName(name)
        if not assetIndex then
            assetIndex = {}
            local counter = 0
            for _, root in ipairs(scanRoots()) do
                if root ~= workspace then
                    for _, d in ipairs(root:GetDescendants()) do
                        counter = counter + 1
                        if counter % 800 == 0 then task.wait() end
                        if (d:IsA("Folder") or d:IsA("Model") or d:IsA("BasePart") or d:IsA("Attachment")
                            or d:IsA("Configuration")) and not skipFx(d) and d.Name ~= "" then
                            local k = squash(d.Name)
                            if k ~= "" and not assetIndex[k] and killContent(d) then assetIndex[k] = d end
                        end
                    end
                end
            end
        end
        for _, k in ipairs(nameKeys(name)) do
            if assetIndex[k] then return assetIndex[k] end
        end
        return nil
    end
    local KILL_CFG = {
        match = function(n)
            if hasWord(n, KILL_BAD) then return false end
            if not hasAny(n, KILL_NAMES) then return false end
            if hasAny(n, KILL_FX_TERMS) then return true end
            return n:find("s$") ~= nil
        end,
        content = killContent,
        plural = function(n)
            return n:find("s$") ~= nil
        end,
        direct = function(c) return isFx(c) end,
        add = addEffect,
        values = true,
        fromValues = function(inst, out, seen)
            for _, c in ipairs(inst:GetChildren()) do
                if c:IsA("ValueBase") then
                    local asset = findAssetByName(c.Name)
                    if asset then addEffect(asset, out, seen, c.Name) end
                end
            end
        end,
    }
    local function scanGeneric(inst, ctx, cfg, out, seen, counter)
        counter.n = counter.n + 1
        if counter.n % 400 == 0 then task.wait() end
        if skipFx(inst) then return end
        local n = norm(inst.Name)
        local here = ctx or cfg.match(n)
        if here and cfg.values then
            local hasValues = false
            for _, c in ipairs(inst:GetChildren()) do
                if c:IsA("ValueBase") then
                    hasValues = true
                    break
                end
            end
            if hasValues then cfg.fromValues(inst, out, seen) end
        end
        if here and cfg.content(inst) then
            local plural = cfg.plural(n)
            local container = false
            if inst:IsA("Folder") or inst:IsA("Configuration") or inst:IsA("Model") or inst:IsA("BasePart") then
                local holders, direct = 0, 0
                for _, c in ipairs(inst:GetChildren()) do
                    if cfg.direct(c) then
                        direct = direct + 1
                    elseif not skipFx(c) and cfg.content(c) then
                        holders = holders + 1
                    end
                end
                if plural and (holders > 0 or direct > 0) then
                    container = true
                elseif not ctx and direct == 0 and holders >= 2
                    and (inst:IsA("Folder") or inst:IsA("Configuration")) then
                    container = true
                end
            end
            if container then
                for _, c in ipairs(inst:GetChildren()) do
                    if cfg.direct(c) then
                        cfg.add(c, out, seen)
                    else
                        scanGeneric(c, true, cfg, out, seen, counter)
                    end
                end
            else
                cfg.add(inst, out, seen)
            end
            return
        end
        for _, c in ipairs(inst:GetChildren()) do
            scanGeneric(c, ctx, cfg, out, seen, counter)
        end
    end
    local function priorityScan(all, out, seen)
        local p1, p2 = {}, {}
        for i, inst in ipairs(all) do
            if i % 1200 == 0 then task.wait() end
            local n = inst.Name:lower()
            if (n:find("hip", 1, true) or n:find("hyp", 1, true)) and isPriority(n) and not seen[n] and not skipFx(inst) then
                if inst:IsA("ValueBase") then
                    local asset = findAssetByName(inst.Name)
                    if not asset then
                        local okv, v = pcall(function() return inst.Value end)
                        if okv and type(v) == "string" and v ~= "" then asset = findAssetByName(v) end
                    end
                    if asset then addEffect(asset, out, seen, inst.Name) end
                elseif inst:IsA("Folder") or inst:IsA("Model") or inst:IsA("Configuration")
                    or inst:IsA("BasePart") or inst:IsA("Attachment") then
                    if killContent(inst) then p1[#p1 + 1] = inst end
                elseif killContent(inst) then
                    p2[#p2 + 1] = inst
                end
            end
        end
        for _, inst in ipairs(p1) do addEffect(inst, out, seen) end
        for _, inst in ipairs(p2) do addEffect(inst, out, seen) end
    end
    local LIB_NAMES = {
        "effect", "efecto", "fx", "vfx", "particle", "particles",
        "kill", "kills", "killeffect", "killeffects",
        "finisher", "finishers", "execution", "executions",
        "death", "deaths", "dying", "slay", "slays", "fatal",
        "cosmetic", "cosmetics", "animation", "animations",
        "skill", "skills",
    }
    local function isHolder(c)
        if isFx(c) then return false end
        if c:IsA("Folder") or c:IsA("Model") or c:IsA("Attachment") or c:IsA("BasePart") or c:IsA("Configuration") then
            for _, d in ipairs(c:GetDescendants()) do
                if isFx(d) then return true end
            end
        end
        return false
    end
    local function libraryScan(all, out, seen)
        for i, inst in ipairs(all) do
            if i % 800 == 0 then task.wait() end
            if (inst:IsA("Folder") or inst:IsA("Configuration") or inst:IsA("Model")) and not skipFx(inst) then
                local n = norm(inst.Name)
                local nameMatch = hasAny(n, LIB_NAMES) and not hasWord(n, KILL_BAD)
                local inStorage = not inst:IsDescendantOf(workspace)
                if nameMatch or inStorage then
                    local kids = inst:GetChildren()
                    if #kids >= 2 then
                        local hold = {}
                        for _, c in ipairs(kids) do
                            if isHolder(c) then hold[#hold + 1] = c end
                        end
                        local minCount = nameMatch and 2 or 3
                        local minRatio = nameMatch and 0.5 or 0.7
                        if #hold >= minCount and (#hold / #kids) >= minRatio then
                            for _, c in ipairs(hold) do addEffect(c, out, seen, nil, true) end
                        end
                    end
                end
            end
        end
    end
    local function storageFxScan(all, out, seen)
        local STORAGE_ROOTS = {}
        for _, n in ipairs({ "ReplicatedStorage", "ReplicatedFirst", "ServerStorage", "StarterGui", "StarterPack" }) do
            local ok, s = pcall(function() return game:GetService(n) end)
            if ok and s then STORAGE_ROOTS[s] = true end
        end
        for i, inst in ipairs(all) do
            if i % 800 == 0 then task.wait() end
            if (inst:IsA("Folder") or inst:IsA("Configuration") or inst:IsA("Model")) and not skipFx(inst) then
                local inStorage = false
                local p = inst.Parent
                while p do
                    if STORAGE_ROOTS[p] then
                        inStorage = true
                        break
                    end
                    p = p.Parent
                end
                if inStorage then
                    local kids = inst:GetChildren()
                    if #kids >= 3 then
                        local hold = 0
                        for _, c in ipairs(kids) do
                            if isHolder(c) or hasFxDeep(c) then hold = hold + 1 end
                        end
                        if hold >= 3 and (hold / #kids) >= 0.6 then
                            for _, c in ipairs(kids) do
                                if hasFxDeep(c) then addEffect(c, out, seen, nil, true) end
                            end
                        end
                    end
                end
            end
        end
    end
    local ICON_KEYS = { "icon", "image", "thumb", "texture", "picture", "img" }
    local function nameIsIcon(n)
        local s = squash(n)
        for _, k in ipairs(ICON_KEYS) do
            if s:find(k, 1, true) then return true end
        end
        return false
    end
    local function assetStr(v)
        if type(v) == "number" then
            if v >= 1000 and v == math.floor(v) then return "rbxassetid://" .. string.format("%d", v) end
            return nil
        end
        if type(v) == "string" then
            if v:find("rbxassetid://", 1, true) or v:find("roblox.com/asset", 1, true) or v:find("rbxthumb", 1, true) then
                return v
            end
            if v:match("^%d%d%d%d%d+$") then return "rbxassetid://" .. v end
        end
        return nil
    end
    local function explicitIcon(inst)
        for k, v in pairs(inst:GetAttributes()) do
            if nameIsIcon(k) then
                local a = assetStr(v)
                if a then return a end
            end
        end
        for _, c in ipairs(inst:GetChildren()) do
            if c:IsA("ValueBase") and nameIsIcon(c.Name) then
                local okv, v = pcall(function() return c.Value end)
                if okv then
                    local a = assetStr(v)
                    if a then return a end
                end
            end
        end
        return nil
    end
    local function embeddedImage(inst)
        local list = { inst }
        for _, d in ipairs(inst:GetDescendants()) do list[#list + 1] = d end
        for _, d in ipairs(list) do
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                if d.Image ~= "" then return d.Image end
            elseif d:IsA("Decal") or d:IsA("Texture") then
                if d.Texture ~= "" then return d.Texture end
            end
        end
        return nil
    end
    local WCONT = { "weapon", "skin", "loadout", "arsenal", "armas", "equipment" }
    local function inWeaponContainer(inst)
        local p, depth = inst.Parent, 0
        while p and depth < 6 and p ~= game do
            if hasAny(norm(p.Name), WCONT) then return true end
            p = p.Parent
            depth = depth + 1
        end
        return false
    end
    local function toolValid(t)
        for _, d in ipairs(t:GetDescendants()) do
            if d:IsA("BasePart") then return true end
        end
        return false
    end
    local function modelValid(m)
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("BasePart") then return true end
        end
        return false
    end
    local function indexW(inst)
        local k = squash(inst.Name)
        if k == "" then return end
        if not (inst:IsA("Tool") or hasWeaponShape(inst)) then return end
        local cur = wIndex[k]
        if not cur or (inst:IsA("Tool") and not cur:IsA("Tool")) then wIndex[k] = inst end
    end
    local function pushWeapon(inst, cat, out, seen, sig, tex)
        local key = squash(inst.Name)
        if key == "" or seen[key] then return false end
        if looksLikeProp(inst) then return false end
        local sg = meshSig(inst)
        if sg ~= "" and sig[sg] then return false end
        seen[key] = true
        if sg ~= "" then sig[sg] = true end
        local t = tex
        if not t and inst:IsA("Tool") and inst.TextureId ~= "" then t = inst.TextureId end
        out[#out + 1] = {
            tab = cat == "melee" and "knives" or "guns", name = inst.Name, lname = inst.Name:lower(),
            inst = inst, tex = t, isTool = inst:IsA("Tool"), cat = cat,
        }
        return true
    end
    local function consider(inst, out, seen, sig, ov)
        if looksLikeProp(inst) then return end
        indexW(inst)
        local cat = ov[inst.Name:lower()] or classifyWeapon(inst)
        if not cat then
            if inst:IsDescendantOf(workspace) then return end
            if not inWeaponContainer(inst) then return end
            cat = catOfContent(inst)
            if not cat and hasWeaponShape(inst) then cat = shapeCat(inst) end
        end
        if not cat then return end
        if not sizeOk(inst) then return end
        pushWeapon(inst, cat, out, seen, sig, nil)
    end
    local function scanWeapons(list, out, seen, sig)
        local ov = env.NexvyrCatOverride or {}
        local char = LocalPlayer.Character
        for i, inst in ipairs(list) do
            if i % 700 == 0 then task.wait() end
            if inst:IsA("Tool") and not inst:GetAttribute("NxTV") and toolValid(inst) then
                indexW(inst)
                local cat = ov[inst.Name:lower()] or classifyWeapon(inst) or catOfContent(inst)
                if not cat then
                    local mine = inst.Parent == char or inst:FindFirstAncestorOfClass("Backpack") ~= nil
                        or inst:FindFirstAncestorOfClass("StarterPack") ~= nil
                    if mine or inWeaponContainer(inst) then cat = shapeCat(inst) end
                end
                if cat then pushWeapon(inst, cat, out, seen, sig, nil) end
            end
        end
        for i, inst in ipairs(list) do
            if i % 700 == 0 then task.wait() end
            if inst:IsA("Model") then
                if not skipCommon(inst) and not inst:FindFirstAncestorWhichIsA("Model")
                    and not inst:FindFirstAncestorWhichIsA("Tool") and not inst:FindFirstAncestorWhichIsA("Accessory")
                    and not inst:FindFirstChildOfClass("Humanoid") and modelValid(inst) then
                    consider(inst, out, seen, sig, ov)
                end
            elseif inst:IsA("BasePart") then
                local par = inst.Parent
                if par and (par:IsA("Folder") or par:IsA("Configuration")) and not skipCommon(inst)
                    and (inst:IsA("MeshPart") or inst:FindFirstChildOfClass("SpecialMesh")) then
                    consider(inst, out, seen, sig, ov)
                end
            end
        end
    end
    local MOD_KEYS = {
        "effect", "kill", "weapon", "knife", "knives", "gun", "item", "skin", "shop", "inventory", "data",
        "config", "cosmetic", "crate", "catalog", "store", "melee", "blade", "finisher", "loot", "pistol", "sword",
    }
    local NAME_FIELDS = { "Name", "name", "DisplayName", "displayName", "Title", "title" }
    local function harvestData(all, wOut, wSeen, wSig, eOut, eSeen)
        local mods = {}
        for _, d in ipairs(all) do
            if d:IsA("ModuleScript") and not d:GetAttribute("NxTV") then
                if hasAny(norm(d.Name), MOD_KEYS) then mods[#mods + 1] = d end
            end
        end
        local function registerWeapon(nm, cat)
            local k = squash(nm)
            local inst = wIndex[k]
            if not inst or wSeen[k] or not existsInGame(inst) then return end
            if not sizeOk(inst) or looksLikeProp(inst) then return end
            if not (inst:IsA("Tool") or catOfName(inst.Name) or hasWeaponShape(inst)) then return end
            pushWeapon(inst, cat, wOut, wSeen, wSig, nil)
        end
        local function registerEffect(nm)
            local asset = findAssetByName(nm)
            if asset and existsInGame(asset) then addEffect(asset, eOut, eSeen, nm) end
        end
        local t0 = os.clock()
        for i, m in ipairs(mods) do
            if i > 140 or os.clock() - t0 > 25 then break end
            local data = withTimeout(1.2, function() return require(m) end)
            if type(data) == "table" then
                local visited, nodes = {}, 0
                local function iconIn(t)
                    for k, v in pairs(t) do
                        if type(k) == "string" and nameIsIcon(k) then
                            local a = assetStr(v)
                            if a then return a end
                        end
                    end
                    return nil
                end
                local function nameOf(t, key)
                    for _, f in ipairs(NAME_FIELDS) do
                        local v = rawget(t, f)
                        if type(v) == "string" and v ~= "" and #v < 40 then return v end
                    end
                    return key
                end
                local function walk(t, key, cat, fx, depth)
                    if depth > 6 or visited[t] or nodes > 9000 then return end
                    visited[t] = true
                    nodes = nodes + 1
                    local nm = nameOf(t, type(key) == "string" and key or nil)
                    if nm then
                        local ic = iconIn(t)
                        local sk = squash(nm)
                        if ic and sk ~= "" and not iconMap[sk] then iconMap[sk] = ic end
                        if cat then registerWeapon(nm, cat) end
                        if fx then registerEffect(nm) end
                    end
                    for k, v in pairs(t) do
                        local ks = type(k) == "string" and k or nil
                        if type(v) == "table" then
                            local nc = (ks and catOfName(ks)) or cat
                            local nf = fx or (ks ~= nil and hasAny(norm(ks), KILL_NAMES))
                            walk(v, k, nc, nf, depth + 1)
                        elseif type(v) == "string" and type(k) == "number" and #v > 1 and #v < 40 then
                            if cat then registerWeapon(v, cat) end
                            if fx then registerEffect(v) end
                        end
                    end
                end
                pcall(walk, data, nil, nil, false, 0)
            end
        end
    end
    local GENERIC_UI = {}
    for _, n in ipairs({
        "icon", "image", "frame", "button", "template", "item", "slot", "label", "text", "background", "bg",
        "holder", "container", "content", "close", "title", "shop", "inventory", "main", "list", "scroll",
        "scrollingframe", "textlabel", "imagelabel", "imagebutton", "textbutton", "buy", "equip", "equipped",
        "locked", "price", "name", "desc", "description", "rarity", "count", "amount", "info", "preview",
        "display", "viewport", "top", "bottom", "left", "right", "new", "tab", "tabs", "page", "pages", "menu",
        "topbar", "hud", "gui", "effect", "effects", "knife", "knives", "gun", "guns", "weapon", "weapons",
        "skin", "skins",
    }) do GENERIC_UI[n] = true end
    local function ctxCatOf(p)
        local depth = 0
        while p and depth < 7 do
            local c = catOfName(p.Name)
            if c then return c end
            p = p.Parent
            depth = depth + 1
        end
        return nil
    end
    local function buildGuiMap()
        local roots = {}
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then roots[#roots + 1] = pg end
        for _, n in ipairs({ "StarterGui", "ReplicatedStorage" }) do
            local ok, s = pcall(function() return game:GetService(n) end)
            if ok and s then roots[#roots + 1] = s end
        end
        local counter = 0
        for _, root in ipairs(roots) do
            for _, d in ipairs(root:GetDescendants()) do
                counter = counter + 1
                if counter % 700 == 0 then task.wait() end
                if not d:FindFirstAncestor(GUI_NAME) then
                    local img
                    if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        img = d.Image
                    elseif d:IsA("Decal") or d:IsA("Texture") then
                        img = d.Texture
                    end
                    if img and img ~= "" then
                        local p, depth = d, 0
                        while p and p ~= root and depth < 4 do
                            local k = squash(p.Name)
                            if k ~= "" and not GENERIC_UI[k] and not guiMap[k] then
                                guiMap[k] = img
                                guiCat[k] = ctxCatOf(p)
                            end
                            p = p.Parent
                            depth = depth + 1
                        end
                    elseif d:IsA("TextLabel") or d:IsA("TextButton") then
                        local t = d.Text
                        if #t >= 3 and #t <= 32 and not t:find("^[%d%p%s]+$") then
                            local k = squash(t)
                            if k ~= "" and not GENERIC_UI[k] and not guiMap[k] then
                                local p, depth, found = d.Parent, 0, nil
                                while p and p ~= root and depth < 3 and not found do
                                    for _, c in ipairs(p:GetChildren()) do
                                        if (c:IsA("ImageLabel") or c:IsA("ImageButton")) and c.Image ~= "" then
                                            found = c
                                            break
                                        end
                                    end
                                    p = p.Parent
                                    depth = depth + 1
                                end
                                if found then
                                    guiMap[k] = found.Image
                                    guiCat[k] = ctxCatOf(d)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local function iconFor(name)
        for _, k in ipairs(nameKeys(name)) do
            if iconMap[k] then return iconMap[k] end
            if guiMap[k] then return guiMap[k] end
        end
        if isPriority(name) then
            for _, term in ipairs(PRIORITY) do
                for k, img in pairs(guiMap) do
                    if k:find(term, 1, true) then return img end
                end
            end
        end
        return nil
    end
    local function attachIcons(effects, weapons)
        for _, e in ipairs(effects) do
            local explicit = explicitIcon(e.inst)
            local g = iconFor(e.name)
            local embedded = embeddedImage(e.inst)
            if not g and e.inst and e.inst.Parent then
                g = iconFor(e.inst.Parent.Name)
            end
            local imgs, seenI = {}, {}
            for _, v in ipairs({ explicit or "", g or "", embedded or "", e.tex or "" }) do
                if v ~= "" and not seenI[v] then
                    seenI[v] = true
                    imgs[#imgs + 1] = v
                end
            end
            e.imgs = imgs
        end
        for _, w in ipairs(weapons) do
            if not w.tex or w.tex == "" then
                w.tex = explicitIcon(w.inst) or iconFor(w.name)
            end
        end
    end
    local function guiDiscover(wOut, wSeen, wSig)
        local added = 0
        for k, img in pairs(guiMap) do
            local inst = wIndex[k]
            if inst and not wSeen[k] and existsInGame(inst) then
                local cat = guiCat[k] or classifyWeapon(inst)
                if not cat then cat = catOfName(inst.Name) end
                if not cat and inst:IsA("Tool") then cat = catOfContent(inst) end
                if cat and sizeOk(inst) and not looksLikeProp(inst) then
                    if pushWeapon(inst, cat, wOut, wSeen, wSig, img) then added = added + 1 end
                end
            end
        end
        return added
    end
    M.norm, M.squash, M.hasAny, M.catOfName, M.catOfTool = norm, squash, hasAny, catOfName, catOfTool
    M.hasNameWord, M.looksLikeProp, M.hasWeaponShape = hasNameWord, looksLikeProp, hasWeaponShape
    M.scanRoots, M.allInstances, M.scanWeapons, M.scanGeneric, M.KILL_CFG = scanRoots, allInstances, scanWeapons, scanGeneric, KILL_CFG
    M.priorityScan, M.libraryScan, M.storageFxScan, M.harvestData = priorityScan, libraryScan, storageFxScan, harvestData
    M.hasFxDeep = hasFxDeep
    M.buildGuiMap, M.guiDiscover, M.attachIcons = buildGuiMap, guiDiscover, attachIcons
    M.collectAnims, M.stripJunk, M.existsInGame = collectAnims, stripJunk, existsInGame
    M.partsOf, M.boundsIn = partsOf, boundsIn
    return M
end)()
local function App()
    local norm, squash, hasAny, catOfName, catOfTool = M.norm, M.squash, M.hasAny, M.catOfName, M.catOfTool
    local hasNameWord, looksLikeProp, hasWeaponShape = M.hasNameWord, M.looksLikeProp, M.hasWeaponShape
    local scanRoots, allInstances, scanWeapons, scanGeneric, KILL_CFG = M.scanRoots, M.allInstances, M.scanWeapons, M.scanGeneric, M.KILL_CFG
    local priorityScan, libraryScan, storageFxScan, harvestData = M.priorityScan, M.libraryScan, M.storageFxScan, M.harvestData
    local buildGuiMap, guiDiscover, attachIcons = M.buildGuiMap, M.guiDiscover, M.attachIcons
    local collectAnims, stripJunk, existsInGame = M.collectAnims, M.stripJunk, M.existsInGame
    local partsOf, boundsIn = M.partsOf, M.boundsIn
    local Kill = {
        entry = nil, deaths = {}, pending = {}, lastAct = 0, lastHit = {}, lastFire = 0,
        hasStat = false, hasRemote = false, statVals = {}, attrVals = {}, folder = nil,
    }
    local function updateMove()
        local weaponTab = activeTab == "knives" or activeTab == "guns"
        btnMove.btn.Visible = weaponTab and Selected[activeTab] ~= nil
        btnMove.label.Text = activeTab == "knives" and "> Pistolas" or "> Cuchillos"
    end
    local function glyph(host, text)
        new("TextLabel", {
            Parent = host, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = text,
            Font = Enum.Font.Garamond, TextSize = 22, TextColor3 = IC.gold,
        })
    end
    local function fxSwatch(host, entry)
        local f = new("Frame", {
            Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0,
        })
        corner(f, 6)
        local c1 = entry.col and entry.col:Lerp(WHITE, 0.3) or IC.gold
        local c2 = entry.col2 and entry.col2:Lerp(WHITE, 0.3) or IC.btnLine
        new("UIGradient", {
            Parent = f, Color = ColorSequence.new(c1, c2), Rotation = 45,
            Transparency = NumberSequence.new(0.35),
        })
        new("TextLabel", {
            Parent = f, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "FX",
            Font = Enum.Font.Garamond, TextSize = 22, TextColor3 = WHITE,
            TextStrokeTransparency = 0.6, TextStrokeColor3 = BLACK,
        })
    end
    local function buildViewport(host, src, spinOn)
        if not src then return nil end
        local clone
        local ok = pcall(function() clone = src:Clone() end)
        if not ok or not clone then return nil end
        local parts = {}
        if clone:IsA("BasePart") then parts[#parts + 1] = clone end
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("LuaSourceContainer") or d:IsA("Sound") or d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                pcall(function() d:Destroy() end)
            elseif d:IsA("BasePart") then
                parts[#parts + 1] = d
            end
        end
        if #parts == 0 then
            pcall(function() clone:Destroy() end)
            return nil
        end
        local visible = {}
        for _, p in ipairs(parts) do
            p.Anchored = true
            if p.Transparency < 0.99 then visible[#visible + 1] = p end
        end
        local use = #visible > 0 and visible or parts
        local mn, mx
        for _, p in ipairs(use) do
            local cf, s = p.CFrame, p.Size
            local ex = Vector3.new(
                (math.abs(cf.RightVector.X) * s.X + math.abs(cf.UpVector.X) * s.Y + math.abs(cf.LookVector.X) * s.Z) / 2,
                (math.abs(cf.RightVector.Y) * s.X + math.abs(cf.UpVector.Y) * s.Y + math.abs(cf.LookVector.Y) * s.Z) / 2,
                (math.abs(cf.RightVector.Z) * s.X + math.abs(cf.UpVector.Z) * s.Y + math.abs(cf.LookVector.Z) * s.Z) / 2
            )
            local lo, hi = cf.Position - ex, cf.Position + ex
            if not mn then
                mn, mx = lo, hi
            else
                mn = Vector3.new(math.min(mn.X, lo.X), math.min(mn.Y, lo.Y), math.min(mn.Z, lo.Z))
                mx = Vector3.new(math.max(mx.X, hi.X), math.max(mx.Y, hi.Y), math.max(mx.Z, hi.Z))
            end
        end
        local vf = new("ViewportFrame", {
            Parent = host, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            Ambient = Color3.fromRGB(190, 190, 190), LightColor = Color3.fromRGB(255, 255, 255),
            LightDirection = Vector3.new(-1, -1, -1),
        })
        clone.Parent = vf
        local cam = Instance.new("Camera")
        cam.FieldOfView = 40
        cam.Parent = vf
        vf.CurrentCamera = cam
        local center = (mn + mx) / 2
        local radius = math.max((mx - mn).Magnitude / 2, 0.5)
        local dist = radius / math.sin(math.rad(20)) * 1.05
        local dir = Vector3.new(1, 0.5, 1).Unit
        cam.CFrame = CFrame.lookAt(center + dir * dist, center)
        if spinOn then
            Spin.cam, Spin.center, Spin.dist, Spin.ang = cam, center, dist, math.atan2(1, 1)
        end
        return vf
    end
    local function texCandidates(tex)
        local out = {}
        if not tex or tex == "" then return out end
        local id = tostring(tex):match("(%d%d%d%d%d+)")
        if id then
            out[#out + 1] = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
            out[#out + 1] = "rbxassetid://" .. id
        end
        if tostring(tex) ~= out[2] then out[#out + 1] = tostring(tex) end
        return out
    end
    local function loadImageChain(host, texList, onFail)
        local img = new("ImageLabel", {
            Parent = host, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Fit, Image = "", ImageTransparency = 1, BorderSizePixel = 0,
        })
        task.spawn(function()
            local tried = {}
            local function attempt(c)
                if tried[c] then return false end
                tried[c] = true
                img.Image = c
                local t0 = os.clock()
                while img.Parent and os.clock() - t0 < 2.5 do
                    local okl, loaded = pcall(function() return img.IsLoaded end)
                    if okl and loaded then return true end
                    task.wait(0.1)
                end
                return false
            end
            local function show()
                tween(img, TweenInfo.new(0.2), { ImageTransparency = 0 })
            end
            for _, tex in ipairs(texList) do
                for _, c in ipairs(texCandidates(tex)) do
                    if not img.Parent then return end
                    if attempt(c) then
                        show()
                        return
                    end
                end
            end
            for _, tex in ipairs(texList) do
                local id = tostring(tex):match("(%d%d%d%d%d+)")
                if id then
                    local t2 = textureFromAsset("rbxassetid://" .. id)
                    if t2 and img.Parent then
                        for _, c in ipairs(texCandidates(t2)) do
                            if attempt(c) then
                                show()
                                return
                            end
                        end
                    end
                end
                break
            end
            if img.Parent then
                img:Destroy()
                if host.Parent then onFail() end
            end
        end)
    end
    local function renderVisual(host, entry, big)
        local isFxTab = entry.tab == "effects"
        local label = isFxTab and "FX" or (entry.cat == "melee" and "CUCH" or "PIST")
        local function fallback()
            if not host.Parent then return end
            if isFxTab then
                if not (entry.inst and buildViewport(host, entry.inst, big)) then fxSwatch(host, entry) end
            else
                if not buildViewport(host, entry.inst, big) then glyph(host, label) end
            end
        end
        local list
        if isFxTab then
            list = entry.imgs
        elseif entry.tex then
            list = { entry.tex }
        end
        if list and #list > 0 then
            loadImageChain(host, list, fallback)
        else
            fallback()
        end
    end
    track(RunService.Heartbeat:Connect(function(dt)
        local cam = Spin.cam
        if not cam or not cam.Parent or not Root.Visible then return end
        Spin.ang = Spin.ang + dt * 0.9
        local dir = Vector3.new(math.cos(Spin.ang), 0.45, math.sin(Spin.ang)).Unit
        cam.CFrame = CFrame.lookAt(Spin.center + dir * Spin.dist, Spin.center)
    end))
    local function showSelected(entry)
        Spin.cam = nil
        for _, c in ipairs(previewContent:GetChildren()) do c:Destroy() end
        if not entry then
            previewHint.Visible = true
            previewHint.Text = "Sin seleccion"
            nameLabel.Text = "-"
            idLabel.Text = "-"
            updateMove()
            return
        end
        previewHint.Visible = false
        nameLabel.Text = entry.name
        if entry.tab == "effects" then
            local lead = entry.lib and "EFECTO" or "KILL EFFECT"
            idLabel.Text = lead .. " | " .. tostring(entry.fxCount or 0) .. " fx"
        else
            idLabel.Text = entry.cat == "melee" and "CUCHILLO" or "PISTOLA"
        end
        renderVisual(previewContent, entry, true)
        updateMove()
    end
    local function mountContent(root, holder, anchor, pivotCF, adornee)
        local expl = {}
        local baseCF
        local function prepPart(p)
            p.Anchored = false
            p.CanCollide = false
            p.CanTouch = false
            p.CanQuery = false
            p.Massless = true
        end
        local function weldTo(p)
            local w = Instance.new("WeldConstraint")
            w.Part0 = p
            w.Part1 = anchor
            w.Parent = p
        end
        local function attach(inst)
            if inst:IsA("ParticleEmitter") or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles")
                or inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") or inst:IsA("Sound") then
                inst.Parent = anchor
            elseif inst:IsA("Highlight") then
                pcall(function() inst.Adornee = adornee end)
                inst.Parent = holder
            elseif inst:IsA("Beam") or inst:IsA("Trail") then
                local a0 = Instance.new("Attachment")
                a0.Position = Vector3.new(0, 1, 0)
                a0.Parent = anchor
                local a1 = Instance.new("Attachment")
                a1.Position = Vector3.new(0, -1, 0)
                a1.Parent = anchor
                inst.Attachment0 = a0
                inst.Attachment1 = a1
                inst.Parent = anchor
            elseif inst:IsA("Explosion") then
                pcall(function()
                    inst.BlastPressure = 0
                    inst.DestroyJointRadiusPercent = 0
                end)
                expl[#expl + 1] = inst
            elseif inst:IsA("Attachment") then
                inst.Parent = anchor
            elseif inst:IsA("BasePart") then
                local rel = CFrame.new()
                if baseCF then
                    rel = baseCF:Inverse() * inst.CFrame
                else
                    baseCF = inst.CFrame
                end
                prepPart(inst)
                for _, d in ipairs(inst:GetDescendants()) do
                    if d:IsA("BasePart") then prepPart(d) end
                end
                inst.CFrame = pivotCF * rel
                inst.Parent = holder
                weldTo(inst)
            elseif inst:IsA("Model") then
                inst:PivotTo(pivotCF)
                inst.Parent = holder
                for _, d in ipairs(inst:GetDescendants()) do
                    if d:IsA("BasePart") then
                        prepPart(d)
                        weldTo(d)
                    end
                end
            elseif inst:IsA("Folder") or inst:IsA("Configuration") then
                for _, ch in ipairs(inst:GetChildren()) do attach(ch) end
                pcall(function() inst:Destroy() end)
            else
                pcall(function() inst:Destroy() end)
            end
        end
        attach(root)
        return expl
    end
    local function triggerOnce(holder, anchor, expl)
        local total = 2.5
        for _, d in ipairs(holder:GetDescendants()) do
            if d:IsA("ParticleEmitter") then
                local delay = tonumber(d:GetAttribute("EmitDelay")) or 0
                local dur = tonumber(d:GetAttribute("EmitDuration")) or 0
                local count = tonumber(d:GetAttribute("EmitCount")) or 20
                local life = 1
                pcall(function() life = d.Lifetime.Max end)
                if d.Rate > 0 and dur <= 0 then dur = 1.2 end
                total = math.max(total, delay + dur + life)
                task.spawn(function()
                    if delay > 0 then task.wait(delay) end
                    if not d.Parent then return end
                    if d.Rate > 0 or dur > 0 then
                        d.Enabled = true
                        task.wait(math.max(dur, 0.05))
                        if d.Parent then d.Enabled = false end
                    else
                        pcall(function() d:Emit(count) end)
                    end
                end)
            elseif d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") or d:IsA("PointLight")
                or d:IsA("SpotLight") or d:IsA("SurfaceLight") or d:IsA("Highlight")
                or d:IsA("Beam") or d:IsA("Trail") then
                pcall(function() d.Enabled = true end)
                total = math.max(total, 3)
            elseif d:IsA("Sound") then
                local delay = tonumber(d:GetAttribute("Delay")) or 0
                pcall(function()
                    d.Looped = false
                    d.RollOffMaxDistance = math.max(d.RollOffMaxDistance, 300)
                    d.RollOffMinDistance = math.max(d.RollOffMinDistance, 40)
                    if d.Volume < 0.5 then d.Volume = 0.8 end
                end)
                local len = 4
                pcall(function()
                    if d.TimeLength > 0 then len = d.TimeLength end
                end)
                total = math.max(total, math.min(len, 12) + delay)
                task.delay(delay, function()
                    if d.Parent then
                        pcall(function()
                            d.TimePosition = 0
                            d:Play()
                        end)
                    end
                end)
            end
        end
        for _, tpl in ipairs(expl) do
            pcall(function()
                local e = tpl:Clone()
                e.Parent = anchor
                task.delay(3, function() pcall(function() e:Destroy() end) end)
            end)
        end
        return math.min(total + 0.5, 15)
    end
    local function makeAnchorPart(parentFolder, cf, anchored)
        local anchor = Instance.new("Part")
        anchor.Name = "NxTVAnchor"
        anchor.Size = Vector3.new(0.4, 0.4, 0.4)
        anchor.Transparency = 1
        anchor.CanCollide = false
        anchor.CanTouch = false
        anchor.CanQuery = false
        anchor.Massless = true
        anchor.Anchored = anchored
        anchor.CFrame = cf
        anchor.Parent = parentFolder
        return anchor
    end
    local function loadAnimator(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return nil, nil end
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = hum
        end
        return hum, animator
    end
    local function isOurs(d, char)
        local p = d
        while p and p ~= char do
            if p:GetAttribute("NxTV") then return true end
            p = p.Parent
        end
        return false
    end
    local function rootPartOf(v)
        if v:IsA("BasePart") then return v end
        if v:IsA("Accessory") then
            local h = v:FindFirstChild("Handle")
            if h and h:IsA("BasePart") then return h end
            return v:FindFirstChildWhichIsA("BasePart", true)
        end
        if v:IsA("Model") then
            local h = v:FindFirstChild("Handle")
            if h and h:IsA("BasePart") then return h end
            return v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true)
        end
        return nil
    end
    local function holsterFolder(char)
        local f = char:FindFirstChild("NxTVHolster")
        if f then return f end
        f = Instance.new("Folder")
        f.Name = "NxTVHolster"
        f:SetAttribute("NxTV", true)
        f.Parent = char
        return f
    end
    local function compOf(v, i)
        if i == 1 then return v.X end
        if i == 2 then return v.Y end
        return v.Z
    end
    local function axisVec(i)
        return Vector3.new(i == 1 and 1 or 0, i == 2 and 1 or 0, i == 3 and 1 or 0)
    end
    local function frameOf(size, off)
        local idx = { 1, 2, 3 }
        local v = { size.X, size.Y, size.Z }
        table.sort(idx, function(a, b)
            if v[a] ~= v[b] then return v[a] > v[b] end
            return a < b
        end)
        local long = v[idx[1]]
        local function sgn1(i)
            local c = compOf(off, i)
            if math.abs(c) < math.max(0.03 * long, 0.01) then return 1 end
            if c > 0 then return 1 end
            return -1
        end
        local x = axisVec(idx[1]) * sgn1(idx[1])
        local y = axisVec(idx[2]) * sgn1(idx[2])
        return CFrame.fromMatrix(Vector3.zero, x, y, x:Cross(y))
    end
    local function buildSkin(entry, origRoot, origParts, origGrip, gripMode)
        local src = entry.inst
        if not existsInGame(src) then return nil end
        local c
        if not pcall(function() c = src:Clone() end) or not c then return nil end
        local junk = {}
        for _, d in ipairs(c:GetDescendants()) do
            if d:IsA("LuaSourceContainer") or d:IsA("Sound") or d:IsA("ScreenGui") or d:IsA("BillboardGui")
                or d:IsA("SurfaceGui") or d:IsA("Humanoid") or d:IsA("Animation") or d:IsA("JointInstance")
                or d:IsA("WeldConstraint") or d:IsA("Constraint") then
                junk[#junk + 1] = d
            end
        end
        for _, d in ipairs(junk) do pcall(function() d:Destroy() end) end
        local gripS = c:IsA("Tool") and c.Grip or nil
        local pp = c:IsA("Model") and c.PrimaryPart or nil
        local srcPart = c:IsA("BasePart") and c or nil
        local model = Instance.new("Model")
        model.Name = "NxTVSkin"
        model:SetAttribute("NxTV", true)
        if srcPart then
            srcPart.Parent = model
        else
            for _, ch in ipairs(c:GetChildren()) do ch.Parent = model end
            pcall(function() c:Destroy() end)
        end
        local parts = partsOf(model)
        if #parts == 0 then
            pcall(function() model:Destroy() end)
            return nil
        end
        local root = model:FindFirstChild("Handle")
        if not (root and root:IsA("BasePart")) then root = nil end
        if not root and pp and pp:IsA("BasePart") and pp:IsDescendantOf(model) then root = pp end
        if not root and srcPart then root = srcPart end
        if not root then
            local best, bv = nil, -1
            for _, p in ipairs(parts) do
                local v = p.Size.X * p.Size.Y * p.Size.Z
                if v > bv then best, bv = p, v end
            end
            root = best
        end
        for _, p in ipairs(parts) do
            p.Anchored = false
            p.CanCollide = false
            p.CanTouch = false
            p.CanQuery = false
            p.Massless = true
        end
        local oRef = origRoot.CFrame
        local sRefCF = root.CFrame
        local vis = {}
        for _, p in ipairs(origParts) do
            if p.Transparency < 0.95 then vis[#vis + 1] = p end
        end
        if #vis == 0 then vis = origParts end
        local cO, sO, gO = boundsIn(vis, oRef)
        local cS, sS, gS = boundsIn(parts, sRefCF)
        local useGrip = gripMode and gripS ~= nil and root.Name == "Handle"
        local O0, S0
        if useGrip then
            O0, S0 = origGrip, gripS
        else
            O0 = CFrame.new(cO) * frameOf(sO, gO - cO)
            S0 = CFrame.new(cS) * frameOf(sS, gS - cS)
        end
        local S0inv = S0:Inverse()
        local sInv = sRefCF:Inverse()
        local plan = {}
        for _, p in ipairs(parts) do
            local rr = S0inv * (sInv * p.CFrame)
            plan[p] = O0 * rr
        end
        for _, p in ipairs(parts) do
            local w = Instance.new("Weld")
            w.Name = "NxTVWeld"
            w.Part0 = origRoot
            w.Part1 = p
            w.C0 = plan[p]
            w.Parent = p
        end
        return model
    end
    local Applied = {}
    local SkinLoop = { conn = nil, last = 0 }
    local projFolderObj
    local function projFolder()
        if projFolderObj and projFolderObj.Parent then return projFolderObj end
        local f = Instance.new("Folder")
        f.Name = "NxTVProj"
        f:SetAttribute("NxTV", true)
        f.Parent = workspace
        projFolderObj = f
        return f
    end
    local function unskin(info)
        if info.model then pcall(function() info.model:Destroy() end) end
        for _, p in ipairs(info.parts) do
            if p.Parent then pcall(function() p.LocalTransparencyModifier = 0 end) end
        end
    end
    local function skinTool(rec, tool)
        local origParts = {}
        for _, p in ipairs(partsOf(tool)) do
            if not p:FindFirstAncestor("NxTVSkin") then origParts[#origParts + 1] = p end
        end
        local handle = tool:FindFirstChild("Handle")
        local isHandle = handle ~= nil and handle:IsA("BasePart")
        if not isHandle then handle = origParts[1] end
        if not handle then return end
        local model = buildSkin(rec.entry, handle, origParts, tool.Grip, isHandle)
        if not model then return end
        model.Parent = tool
        rec.targets[tool] = { kind = "tool", model = model, parts = origParts, root = handle, skinParts = partsOf(model) }
    end
    local function skinHolster(rec, target, char)
        local root = rootPartOf(target)
        if not root then return end
        local origParts = partsOf(target)
        if #origParts == 0 then return end
        local model = buildSkin(rec.entry, root, origParts, CFrame.new(), false)
        if not model then return end
        model.Parent = holsterFolder(char)
        rec.targets[target] = { kind = "holster", model = model, parts = origParts, root = root, skinParts = partsOf(model) }
    end
    local function refreshRec(rec)
        local char = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        local dead = {}
        for inst, info in pairs(rec.targets) do
            local alive = inst.Parent ~= nil and existsInGame(inst)
            if alive and info.kind == "holster" then
                alive = char ~= nil and inst:IsDescendantOf(char)
            end
            if alive and info.kind == "tool" then
                alive = (inst.Parent == bp) or (inst.Parent == char)
            end
            if alive and not info.model.Parent then alive = false end
            if not alive then dead[#dead + 1] = inst end
        end
        for _, inst in ipairs(dead) do
            unskin(rec.targets[inst])
            rec.targets[inst] = nil
        end
        local function claimed(inst)
            for _, r in pairs(Applied) do
                if r ~= rec and r.targets[inst] then return true end
            end
            return false
        end
        for _, container in ipairs({ bp, char }) do
            if container then
                for _, t in ipairs(container:GetChildren()) do
                    if t:IsA("Tool") and not t:GetAttribute("NxTV") and not rec.targets[t] and not claimed(t) then
                        local cc = rec.cc[t]
                        if cc == nil then
                            cc = catOfTool(t) or false
                            rec.cc[t] = cc
                        end
                        if cc == rec.cat then
                            rec.toolNames[squash(t.Name)] = true
                            pcall(skinTool, rec, t)
                        end
                    end
                end
            end
        end
        if char then
            for _, d in ipairs(char:GetDescendants()) do
                if (d:IsA("Model") or d:IsA("BasePart") or d:IsA("Accessory")) and not rec.targets[d]
                    and not isOurs(d, char) and not d:FindFirstAncestorWhichIsA("Tool") then
                    if catOfName(d.Name) == rec.cat or rec.toolNames[squash(d.Name)] then
                        if not claimed(d) then
                            local nested = false
                            for t in pairs(rec.targets) do
                                if t ~= d and d:IsDescendantOf(t) then
                                    nested = true
                                    break
                                end
                            end
                            if not nested then pcall(skinHolster, rec, d, char) end
                        end
                    end
                end
            end
        end
    end
    local function stepRec(rec)
        local char = LocalPlayer.Character
        local equipped = false
        if char then
            for t, info in pairs(rec.targets) do
                if info.kind == "tool" and t.Parent == char then
                    equipped = true
                    break
                end
            end
        end
        for _, info in pairs(rec.targets) do
            for _, p in ipairs(info.parts) do
                if p.Parent then p.LocalTransparencyModifier = 1 end
            end
            if info.kind == "holster" then
                local root = info.root
                local show = (not equipped) and root.Parent ~= nil and char ~= nil
                    and root:IsDescendantOf(char) and root.Transparency < 0.99
                local v = show and 0 or 1
                for _, p in ipairs(info.skinParts) do
                    if p.Parent then p.LocalTransparencyModifier = v end
                end
            end
        end
        local gone
        for inst, info in pairs(rec.proj) do
            if not info.root.Parent or not inst.Parent then
                gone = gone or {}
                gone[#gone + 1] = inst
            else
                for _, p in ipairs(info.parts) do
                    if p.Parent then p.LocalTransparencyModifier = 1 end
                end
                if info.skinParts then
                    for _, p in ipairs(info.skinParts) do
                        if p.Parent then p.LocalTransparencyModifier = 0 end
                    end
                end
            end
        end
        if gone then
            for _, inst in ipairs(gone) do
                local info = rec.proj[inst]
                rec.proj[inst] = nil
                if info and info.model then pcall(function() info.model:Destroy() end) end
            end
        end
    end
    local function startLoop()
        if SkinLoop.conn then return end
        SkinLoop.last = 0
        SkinLoop.conn = RunService.RenderStepped:Connect(function()
            local now = os.clock()
            local doRefresh = now - SkinLoop.last > 0.7
            if doRefresh then SkinLoop.last = now end
            for _, rec in pairs(Applied) do
                if doRefresh then pcall(refreshRec, rec) end
                pcall(stepRec, rec)
            end
        end)
    end
    local function oursDeep(d)
        local p, depth = d, 0
        while p and p ~= workspace and depth < 8 do
            if p:GetAttribute("NxTV") or p:GetAttribute("NxTVP") then return true end
            p = p.Parent
            depth = depth + 1
        end
        return false
    end
    local function charLike(m)
        local p = m
        while p and p ~= workspace do
            if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
            p = p.Parent
        end
        return false
    end
    local function meleeNamed(d)
        if catOfName(d.Name) == "melee" then return true end
        local p = d.Parent
        if p and p ~= workspace and catOfName(p.Name) == "melee" then return true end
        return false
    end
    local function hideParts(parts)
        for _, p in ipairs(parts) do
            if p.Parent then pcall(function() p.LocalTransparencyModifier = 1 end) end
        end
    end
    local function tryProjectile(d)
        local rec = Applied.melee
        if not rec or not d.Parent then return end
        if os.clock() - Kill.lastAct > 3.2 then return end
        if oursDeep(d) then return end
        if d:FindFirstAncestorWhichIsA("Tool") or d:FindFirstAncestorOfClass("Backpack") then return end
        local target = d
        if d:IsA("BasePart") and d.Parent and d.Parent:IsA("Model") and d.Parent ~= workspace
            and not d.Parent:FindFirstChildOfClass("Humanoid") then
            target = d.Parent
        end
        if charLike(target) then return end
        if not (meleeNamed(target) or meleeNamed(d)) then return end
        if not target.Parent or target:GetAttribute("NxTVP") or rec ~= Applied.melee then return end
        local root = rootPartOf(target)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not hrp then return end
        if (root.Position - hrp.Position).Magnitude > 16 then return end
        target:SetAttribute("NxTVP", true)
        local origParts = partsOf(target)
        hideParts(origParts)
        local model = buildSkin(rec.entry, root, origParts, CFrame.new(), false)
        if not model then
            for _, p in ipairs(origParts) do
                if p.Parent then pcall(function() p.LocalTransparencyModifier = 0 end) end
            end
            return
        end
        model.Parent = projFolder()
        rec.proj[target] = { model = model, parts = origParts, root = root, skinParts = partsOf(model) }
    end
    local function dropWeapon(cat)
        local rec = Applied[cat]
        if not rec then return end
        Applied[cat] = nil
        if rec.projConn then pcall(function() rec.projConn:Disconnect() end) end
        for _, info in pairs(rec.targets) do pcall(unskin, info) end
        for _, info in pairs(rec.proj) do pcall(unskin, info) end
        rec.targets, rec.proj = {}, {}
        if next(Applied) == nil and SkinLoop.conn then
            SkinLoop.conn:Disconnect()
            SkinLoop.conn = nil
        end
    end
    local function applyWeapon(entry)
        local cat = entry.cat
        if cat ~= "melee" and cat ~= "gun" then return false, "Categoria invalida." end
        if not existsInGame(entry.inst) then return false, "El arma ya no existe en el juego." end
        if Applied[cat] then dropWeapon(cat) end
        local rec = { cat = cat, entry = entry, targets = {}, proj = {}, toolNames = {}, cc = {} }
        Applied[cat] = rec
        if cat == "melee" then
            rec.projConn = workspace.DescendantAdded:Connect(function(d)
                if os.clock() - Kill.lastAct < 3.2 and (d:IsA("BasePart") or d:IsA("Model")) then
                    task.defer(tryProjectile, d)
                end
            end)
        end
        startLoop()
        pcall(refreshRec, rec)
        local n = 0
        for _ in pairs(rec.targets) do n = n + 1 end
        if n == 0 then
            local what = cat == "melee" and "cuchillo" or "pistola"
            return true, "Aplicado: " .. entry.name .. ". No veo tu " .. what .. " aun."
        end
        return true, "Skin aplicada: " .. entry.name
    end
    local function killFolder()
        if Kill.folder and Kill.folder.Parent then return Kill.folder end
        local f = Instance.new("Folder")
        f.Name = "NxTVKillFx"
        f:SetAttribute("NxTV", true)
        f.Parent = workspace
        Kill.folder = f
        return f
    end
    local function playOnVictim(specs, char)
        if #specs == 0 then return end
        local _, animator = loadAnimator(char)
        if not animator then return end
        for _, spec in ipairs(specs) do
            local a = Instance.new("Animation")
            a.AnimationId = spec.id
            local ok, tr = pcall(function() return animator:LoadAnimation(a) end)
            if ok and tr then
                pcall(function()
                    tr.Priority = Enum.AnimationPriority.Action4
                    tr:Play(0.05)
                end)
                task.delay(8, function() pcall(function() tr:Stop(0.2) end) end)
            end
        end
    end
    local function playKillEffect(entry, d)
        local src = entry.inst
        if not src or not existsInGame(src) then return end
        local c
        local ok = pcall(function() c = src:Clone() end)
        if not ok or not c then return end
        local specs = collectAnims(c)
        stripJunk(c)
        local holder = Instance.new("Folder")
        holder.Name = "NxTVKill_" .. entry.name
        holder:SetAttribute("NxTV", true)
        holder.Parent = killFolder()
        local anchor = makeAnchorPart(holder, d.cf, true)
        local expl = mountContent(c, holder, anchor, d.cf, d.char)
        playOnVictim(specs, d.char)
        local total = triggerOnce(holder, anchor, expl)
        task.delay(total, function() pcall(function() holder:Destroy() end) end)
    end
    local function nameIsMe(v)
        if typeof(v) == "Instance" then
            return v == LocalPlayer or (LocalPlayer.Character ~= nil and v == LocalPlayer.Character)
        end
        if type(v) == "number" then return v == LocalPlayer.UserId end
        if type(v) == "string" then
            return v == LocalPlayer.Name or v == LocalPlayer.DisplayName or v == tostring(LocalPlayer.UserId)
        end
        return false
    end
    local function argIsMe(v, depth)
        if nameIsMe(v) then return true end
        if type(v) == "table" and depth < 2 then
            for _, x in pairs(v) do
                if argIsMe(x, depth + 1) then return true end
            end
        end
        return false
    end
    local TAG_NAMES = { "creator", "Creator", "killer", "Killer", "LastAttacker", "LastDamager", "KilledBy" }
    local function taggedMine(hum, char)
        for _, holder in ipairs({ hum, char }) do
            for _, tn in ipairs(TAG_NAMES) do
                local tag = holder:FindFirstChild(tn)
                if tag and tag:IsA("ValueBase") then
                    local okv, val = pcall(function() return tag.Value end)
                    if okv and nameIsMe(val) then return true end
                end
                local attr = holder:GetAttribute(tn)
                if attr ~= nil and nameIsMe(attr) then return true end
            end
        end
        return false
    end
    local function fireKill(d)
        if d.fired then return end
        d.fired = true
        local entry = Kill.entry
        if not entry then return end
        if not existsInGame(entry.inst) then
            setStatus("El efecto ya no existe en el juego.", T.warn)
            return
        end
        Kill.lastFire = os.clock()
        setStatus("Kill: " .. d.name, T.green)
        task.spawn(function() pcall(playKillEffect, entry, d) end)
    end
    local function tryMatch()
        local now = os.clock()
        for i = #Kill.pending, 1, -1 do
            if now - Kill.pending[i] > 3.5 then table.remove(Kill.pending, i) end
        end
        while #Kill.pending > 0 do
            local credit = Kill.pending[1]
            local best, bd
            for _, d in ipairs(Kill.deaths) do
                if not d.fired and not d.consumed then
                    local dt = math.abs(d.t - credit)
                    if dt <= 3.5 and (not bd or dt < bd) then best, bd = d, dt end
                end
            end
            if not best then return end
            table.remove(Kill.pending, 1)
            best.consumed = true
            fireKill(best)
        end
    end
    local function addCredit()
        local now = os.clock()
        if now - Kill.lastFire < 2 then return end
        local last = Kill.pending[#Kill.pending]
        if last and now - last < 1.2 then return end
        Kill.pending[#Kill.pending + 1] = now
        tryMatch()
    end
    local function hookCharacter(p, char)
        task.spawn(function()
            local hum = char:WaitForChild("Humanoid", 10)
            if not hum then return end
            local last = hum.Health
            local dead = false
            local function onDead()
                if dead then return end
                dead = true
                local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                    or char:FindFirstChild("Head")
                local cf = hrp and hrp.CFrame or CFrame.new(0, 0, 0)
                local now = os.clock()
                local d = {
                    player = p, char = char, cf = cf, t = now, name = p.DisplayName,
                    fired = false, consumed = false,
                }
                Kill.deaths[#Kill.deaths + 1] = d
                for i = #Kill.deaths, 1, -1 do
                    if now - Kill.deaths[i].t > 8 then table.remove(Kill.deaths, i) end
                end
                if taggedMine(hum, char) then
                    d.consumed = true
                    fireKill(d)
                elseif Kill.hasStat or Kill.hasRemote then
                    tryMatch()
                else
                    local lh = Kill.lastHit[p]
                    if lh and now - lh < 3 then
                        d.consumed = true
                        fireKill(d)
                    end
                end
            end
            hum.HealthChanged:Connect(function(h)
                if h < last and os.clock() - Kill.lastAct < 1.5 then
                    local mine = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local theirs = char:FindFirstChild("HumanoidRootPart")
                    if mine and theirs and (mine.Position - theirs.Position).Magnitude < 400 then
                        Kill.lastHit[p] = os.clock()
                    end
                end
                last = h
                if h <= 0 then onDead() end
            end)
            hum.Died:Connect(onDead)
        end)
    end
    local function hookPlayer(p)
        if p == LocalPlayer then return end
        if p.Character then hookCharacter(p, p.Character) end
        track(p.CharacterAdded:Connect(function(char) hookCharacter(p, char) end))
    end
    local KILL_STAT = { "kill", "elim", "frag", "takedown", "kos" }
    local function statLike(name)
        return hasAny(norm(name), KILL_STAT)
    end
    local function hookStat(v)
        if Kill.statVals[v] ~= nil then return end
        Kill.statVals[v] = v.Value
        Kill.hasStat = true
        track(v.Changed:Connect(function(nv)
            local oldv = Kill.statVals[v]
            Kill.statVals[v] = nv
            if type(nv) == "number" and type(oldv) == "number" and nv > oldv then
                addCredit()
            end
        end))
    end
    local REMOTE_TERMS = { "kill", "elim", "knock", "defeat", "slain" }
    local function onRemote(...)
        local args = table.pack(...)
        for i = 1, args.n do
            if argIsMe(args[i], 0) then
                Kill.hasRemote = true
                addCredit()
                return
            end
        end
    end
    local function hookRemotes()
        local n, count = 0, 0
        for _, d in ipairs(game:GetDescendants()) do
            count = count + 1
            if count % 3000 == 0 then task.wait() end
            if d:IsA("RemoteEvent") and hasAny(norm(d.Name), REMOTE_TERMS) then
                n = n + 1
                if n > 40 then break end
                track(d.OnClientEvent:Connect(onRemote))
            end
        end
    end
    local function initKills()
        for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
        track(Players.PlayerAdded:Connect(hookPlayer))
        track(UIS.InputBegan:Connect(function(input)
            local t = input.UserInputType
            if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch
                or t == Enum.UserInputType.Keyboard or t == Enum.UserInputType.Gamepad1 then
                Kill.lastAct = os.clock()
            end
        end))
        for _, d in ipairs(LocalPlayer:GetDescendants()) do
            if (d:IsA("IntValue") or d:IsA("NumberValue")) and statLike(d.Name)
                and not d:FindFirstAncestorOfClass("Backpack") then
                hookStat(d)
            end
        end
        track(LocalPlayer.DescendantAdded:Connect(function(d)
            if (d:IsA("IntValue") or d:IsA("NumberValue")) and statLike(d.Name) then hookStat(d) end
        end))
        for name, val in pairs(LocalPlayer:GetAttributes()) do
            if statLike(name) and type(val) == "number" then
                Kill.attrVals[name] = val
                Kill.hasStat = true
            end
        end
        track(LocalPlayer.AttributeChanged:Connect(function(name)
            if not statLike(name) then return end
            local v = LocalPlayer:GetAttribute(name)
            if type(v) ~= "number" then return end
            local oldv = Kill.attrVals[name]
            Kill.attrVals[name] = v
            Kill.hasStat = true
            if oldv ~= nil and v > oldv then addCredit() end
        end))
        task.spawn(hookRemotes)
    end
    local View = { token = 0, built = 0, limit = PAGE, list = {}, more = nil }
    local cards = {}
    local function isApplied(entry)
        if entry.tab == "effects" then
            return Kill.entry == entry
        end
        local rec = Applied[entry.cat]
        return rec ~= nil and rec.entry == entry
    end
    paintCards = function()
        for entry, c in pairs(cards) do
            if c.card.Parent then
                local sel = Selected[entry.tab] == entry
                c.st.Color = sel and IC.gold or IC.btnLine
                c.st.Transparency = sel and 0.05 or 0.7
                c.dot.Visible = isApplied(entry)
            end
        end
    end
    local function selectEntry(entry)
        Selected[entry.tab] = entry
        showSelected(entry)
        paintCards()
    end
    local function makeCard(entry, order)
        local card = new("TextButton", {
            Parent = listFrame, BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.35,
            AutoButtonColor = false, Text = "", BorderSizePixel = 0, LayoutOrder = order,
        })
        corner(card, 5)
        local st = stroke(card, IC.btnLine, 1, 0.7)
        local imgHost = new("Frame", {
            Parent = card, Position = UDim2.fromOffset(4, 4), Size = UDim2.new(1, -8, 0, 70),
            BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true,
        })
        renderVisual(imgHost, entry, false)
        new("TextLabel", {
            Parent = card, Position = UDim2.fromOffset(4, 76), Size = UDim2.new(1, -8, 0, 18),
            BackgroundTransparency = 1, Text = entry.name, Font = Enum.Font.GothamMedium, TextSize = 10,
            TextColor3 = IC.title, TextTruncate = Enum.TextTruncate.AtEnd,
        })
        local dot = new("Frame", {
            Parent = card, Position = UDim2.fromOffset(7, 7), Size = UDim2.fromOffset(7, 7),
            BackgroundColor3 = T.green, BorderSizePixel = 0, Visible = isApplied(entry), ZIndex = 3,
        })
        corner(dot, 4)
        cards[entry] = { card = card, st = st, dot = dot }
        card.MouseButton1Click:Connect(function() selectEntry(entry) end)
        card.MouseEnter:Connect(function()
            if touchOnly then return end
            if Selected[entry.tab] ~= entry then tween(st, TweenInfo.new(0.12), { Transparency = 0.4 }) end
        end)
        card.MouseLeave:Connect(function()
            if Selected[entry.tab] ~= entry then tween(st, TweenInfo.new(0.12), { Transparency = 0.7 }) end
        end)
    end
    local function filterList()
        local q = string.lower(string.match(input.Text, "^%s*(.-)%s*$") or "")
        local res = {}
        for _, e in ipairs(Data[activeTab]) do
            if q == "" or string.find(e.lname, q, 1, true) then res[#res + 1] = e end
        end
        return res
    end
    local function clearCards()
        for _, c in ipairs(listFrame:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        cards = {}
        View.more = nil
    end
    local function buildCards(reset)
        View.token = View.token + 1
        local my = View.token
        if reset then
            clearCards()
            View.built = 0
            View.limit = PAGE
            View.list = filterList()
            listFrame.CanvasPosition = Vector2.new(0, 0)
        else
            if View.more then
                View.more:Destroy()
                View.more = nil
            end
        end
        local list = View.list
        countLabel.Text = #list .. TAB_INFO[activeTab].plural
        if #list == 0 then
            emptyLabel.Visible = true
            if not Scan.done then
                emptyLabel.Text = "Escaneando juego..."
            else
                emptyLabel.Text = TAB_INFO[activeTab].empty
            end
            return
        end
        emptyLabel.Visible = false
        local target = math.min(View.limit, #list)
        for i = View.built + 1, target do
            if View.token ~= my then return end
            makeCard(list[i], i)
            View.built = i
            if i % 2 == 0 then task.wait() end
        end
        if View.token ~= my then return end
        paintCards()
        if #list > View.built then
            local more = new("TextButton", {
                Parent = listFrame, BackgroundColor3 = IC.btnBgMain, BackgroundTransparency = 0.35,
                AutoButtonColor = false, Text = "Ver mas (" .. (#list - View.built) .. ")",
                Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = WHITE, BorderSizePixel = 0,
                LayoutOrder = 1000000,
            })
            corner(more, 5)
            stroke(more, IC.gold, 1, 0.5)
            View.more = more
            more.MouseButton1Click:Connect(function()
                View.limit = View.limit + PAGE
                task.spawn(buildCards, false)
            end)
        end
    end
    local function updateLabels()
        local info = TAB_INFO[activeTab]
        btnApply.label.Text = info.apply
        btnRemove.label.Text = info.remove
        input.PlaceholderText = info.ph
    end
    local function setTab(name)
        activeTab = name
        local info = TweenInfo.new(0.15)
        for key, btn in pairs(tabButtons) do
            local on = key == name
            tween(btn, info, {
                BackgroundTransparency = on and 0.25 or 1,
                TextColor3 = on and WHITE or IC.soft,
            })
            tween(tabStrokes[key], info, { Transparency = on and 0.4 or 1 })
        end
        updateLabels()
        showSelected(Selected[name])
        task.spawn(buildCards, true)
    end
    local function moveEntry(entry)
        if entry.tab ~= "knives" and entry.tab ~= "guns" then return end
        local from = entry.tab
        local to = from == "knives" and "guns" or "knives"
        local rec = Applied[entry.cat]
        if rec and rec.entry == entry then dropWeapon(entry.cat) end
        for i, e in ipairs(Data[from]) do
            if e == entry then
                table.remove(Data[from], i)
                break
            end
        end
        entry.cat = entry.cat == "melee" and "gun" or "melee"
        entry.tab = to
        Data[to][#Data[to] + 1] = entry
        table.sort(Data[to], function(a, b) return a.lname < b.lname end)
        env.NexvyrCatOverride[entry.lname] = entry.cat
        Selected[from] = nil
        Selected[to] = entry
        setTab(to)
        setStatus("Movido a " .. (to == "guns" and "Pistolas" or "Cuchillos") .. ".", T.green)
    end
    local function runScan()
        if Scan.running then return end
        Scan.running = true
        Scan.done = false
        setStatus("Escaneando todo el juego...", IC.soft)
        setProgress(0.05)
        local weapons, effects = {}, {}
        local seenW, sigW, seenE = {}, {}, {}
        local cE = { n = 0 }
        local all = {}
        pcall(function() all = allInstances() end)
        setProgress(0.2)
        pcall(function() scanWeapons(all, weapons, seenW, sigW) end)
        setProgress(0.35)
        for _, root in ipairs(scanRoots()) do
            pcall(function() scanGeneric(root, false, KILL_CFG, effects, seenE, cE) end)
        end
        setProgress(0.5)
        pcall(function() priorityScan(all, effects, seenE) end)
        pcall(function() libraryScan(all, effects, seenE) end)
        pcall(function() storageFxScan(all, effects, seenE) end)
        setProgress(0.62)
        setStatus("Leyendo datos del juego...", IC.soft)
        pcall(function() harvestData(all, weapons, seenW, sigW, effects, seenE) end)
        setProgress(0.78)
        setStatus("Leyendo la GUI del juego...", IC.soft)
        pcall(function() buildGuiMap() end)
        pcall(function() guiDiscover(weapons, seenW, sigW) end)
        setProgress(0.88)
        pcall(function() attachIcons(effects, weapons) end)
        setProgress(0.95)
        local knives, guns = {}, {}
        local ov = env.NexvyrCatOverride
        for _, e in ipairs(weapons) do
            if ov[e.lname] then e.cat = ov[e.lname] end
            if e.cat == "melee" then
                e.tab = "knives"
                knives[#knives + 1] = e
            else
                e.tab = "guns"
                guns[#guns + 1] = e
            end
        end
        table.sort(knives, function(a, b) return a.lname < b.lname end)
        table.sort(guns, function(a, b) return a.lname < b.lname end)
        table.sort(effects, function(a, b)
            if a.priority ~= b.priority then return a.priority end
            if a.lib ~= b.lib then return not a.lib end
            return a.lname < b.lname
        end)
        Data.knives, Data.guns, Data.effects = knives, guns, effects
        Scan.done = true
        Scan.running = false
        setStatus(#knives .. " cuchillos | " .. #guns .. " pistolas | " .. #effects .. " efectos.", T.green)
        setProgress(1)
        task.delay(0.6, function() setProgress(0) end)
        buildCards(true)
    end
    local function doSearch()
        buildCards(true)
        setStatus(#View.list .. TAB_INFO[activeTab].plural .. ".", IC.soft)
    end
    btnSearch.btn.MouseButton1Click:Connect(function() task.spawn(doSearch) end)
    input.FocusLost:Connect(function(enter)
        if enter then task.spawn(doSearch) end
    end)
    local typeToken = 0
    track(input:GetPropertyChangedSignal("Text"):Connect(function()
        typeToken = typeToken + 1
        local my = typeToken
        task.delay(0.25, function()
            if typeToken == my then buildCards(true) end
        end)
    end))
    btnMove.btn.MouseButton1Click:Connect(function()
        local e = Selected[activeTab]
        if e then moveEntry(e) end
    end)
    btnApply.btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            if busy then return end
            local entry = Selected[activeTab]
            if not entry then
                setStatus("Selecciona uno primero.", T.warn)
                return
            end
            busy = true
            setStatus("Aplicando...", IC.soft)
            setProgress(0.5)
            local ok, success, msg
            if activeTab == "effects" then
                if existsInGame(entry.inst) then
                    Kill.entry = entry
                    ok, success, msg = true, true, "Efecto activo: " .. entry.name
                else
                    ok, success, msg = true, false, "Ese efecto ya no existe en el juego."
                end
            else
                ok, success, msg = pcall(applyWeapon, entry)
            end
            if not ok then
                setStatus("Error: " .. tostring(success), T.red)
                setProgress(0)
            elseif success then
                setStatus(msg, T.green)
                setProgress(1)
                task.delay(0.6, function() setProgress(0) end)
            else
                setStatus(tostring(msg), T.red)
                setProgress(0)
            end
            paintCards()
            busy = false
        end)
    end)
    btnRemove.btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            if busy then return end
            if activeTab == "effects" then
                if not Kill.entry then
                    setStatus("No hay kill effect activo.", T.warn)
                    return
                end
                Kill.entry = nil
                setStatus("Kill effect borrado.", IC.soft)
            else
                local cat = TAB_INFO[activeTab].cat
                if not Applied[cat] then
                    setStatus("No hay skin aplicada.", T.warn)
                    return
                end
                pcall(dropWeapon, cat)
                setStatus("Skin borrada, original restaurado.", IC.soft)
            end
            paintCards()
        end)
    end)
    for key, btn in pairs(tabButtons) do
        btn.MouseButton1Click:Connect(function() setTab(key) end)
    end
    local FS = 52
    local floatRoot = new("Frame", {
        Parent = gui, Size = UDim2.fromOffset(FS, FS), Position = UDim2.fromOffset(20, 100),
        BackgroundTransparency = 1, Visible = false, Active = true,
    })
    local floatBtn = new("TextButton", {
        Parent = floatRoot, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, AutoButtonColor = false,
        Text = "", BorderSizePixel = 0, ClipsDescendants = true,
    })
    corner(floatBtn, 12)
    local floatStroke = stroke(floatBtn, WHITE, 2, 0.2)
    local floatGrad = grad(floatStroke, IC.gold, IC.btnLine, 45)
    tween(floatGrad, TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 405 })
    local floatImg = new("ImageLabel", {
        Parent = floatBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Crop, Image = "", BorderSizePixel = 0, Active = false,
        ImageTransparency = 1,
    })
    corner(floatImg, 12)
    UI.logo(floatImg)
    local floatScale = new("UIScale", { Parent = floatBtn, Scale = 0 })
    local token = 0
    local floatPlaced = false
    local TI_CLOSE = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local TI_FLOAT_OUT = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local function floatDelta()
        local fx = floatRoot.Position.X.Offset + FS / 2
        local fy = floatRoot.Position.Y.Offset + FS / 2
        local rx = Root.Position.X.Offset + (W * BASE) / 2
        local ry = Root.Position.Y.Offset + (H * BASE) / 2
        return fx - rx, fy - ry
    end
    local function openWindow()
        token = token + 1
        local my = token
        local fromFloat = floatPlaced and floatRoot.Visible
        Root.Visible = true
        Window.GroupTransparency = 1
        if fromFloat then
            local dx, dy = floatDelta()
            Window.Position = UDim2.new(0.5, dx, 0.5, dy)
            winScale.Scale = BASE * 0.2
        else
            Window.Position = UDim2.new(0.5, 0, 0.5, 26)
            winScale.Scale = BASE * 0.8
        end
        bgScale.Scale = 1.14
        Left.Position = UDim2.fromOffset(-30, 52)
        Right.Position = UDim2.fromOffset(260, 52)
        headLine.Size = UDim2.new(0, 0, 0, 1)
        tween(Window, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 })
        tween(winScale, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = BASE })
        tween(Window, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.5),
        })
        tween(headLine, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.1), {
            Size = UDim2.new(1, 0, 0, 1),
        })
        tween(Left, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.08), {
            Position = UDim2.fromOffset(10, 52),
        })
        tween(Right, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.16), {
            Position = UDim2.fromOffset(210, 52),
        })
        tween(bgScale, TweenInfo.new(7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 })
        tween(floatScale, TI_FLOAT_OUT, { Scale = 0 }).Completed:Connect(function()
            if token == my then floatRoot.Visible = false end
        end)
    end
    local function minimizeWindow()
        token = token + 1
        local my = token
        if not floatPlaced then
            local vp = UI.viewport()
            local cx = Root.Position.X.Offset + (W * BASE) / 2 - FS / 2
            local cy = Root.Position.Y.Offset + (H * BASE) / 2 - FS / 2
            floatRoot.Position = UDim2.fromOffset(
                math.clamp(cx, 0, math.max(0, vp.X - FS)),
                math.clamp(cy, 0, math.max(0, vp.Y - FS))
            )
            floatPlaced = true
        end
        floatRoot.Visible = true
        floatScale.Scale = 0
        local dx, dy = floatDelta()
        tween(Window, TI_CLOSE, { GroupTransparency = 1, Position = UDim2.new(0.5, dx, 0.5, dy) })
        tween(winScale, TI_CLOSE, { Scale = BASE * 0.2 }).Completed:Connect(function()
            if token == my then
                Root.Visible = false
                Window.Position = UDim2.fromScale(0.5, 0.5)
            end
        end)
        tween(floatScale, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.12), { Scale = 1 })
    end
    UI.draggable(floatBtn, floatRoot, openWindow,
        function()
            tween(floatScale, TweenInfo.new(0.1), { Scale = 0.92 })
        end,
        function()
            tween(floatScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
        end)
    btnMin.MouseButton1Click:Connect(minimizeWindow)
    local function destroyAll()
        local cats = {}
        for cat in pairs(Applied) do cats[#cats + 1] = cat end
        for _, cat in ipairs(cats) do pcall(dropWeapon, cat) end
        if SkinLoop.conn then
            SkinLoop.conn:Disconnect()
            SkinLoop.conn = nil
        end
        Kill.entry = nil
        if Kill.folder then pcall(function() Kill.folder:Destroy() end) end
        if projFolderObj then pcall(function() projFolderObj:Destroy() end) end
        Spin.cam = nil
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if gui then gui:Destroy() end
        env.NexvyrToolsVisualCleanup = nil
    end
    env.NexvyrToolsVisualCleanup = destroyAll
    btnClose.MouseButton1Click:Connect(function()
        Modal.show({
            title = "Realmente quieres cerrar?",
            text = "Si cierras la GUI por completo tendras que ejecutar el script otra vez.",
            leftText = "Abrir denuevo", leftStyle = "main",
            rightText = "Cerrar Gui", rightStyle = "danger",
            onRight = function()
                tween(winScale, TI_CLOSE, { Scale = BASE * 0.85 })
                tween(Window, TI_CLOSE, { GroupTransparency = 1 }).Completed:Connect(destroyAll)
            end,
        })
    end)
    updateLabels()
    setTab("knives")
    openWindow()
    initKills()
    task.spawn(runScan)
end
local appOk, appErr = pcall(App)
if not appOk then warn("[NexvyrTV] " .. tostring(appErr)) end
