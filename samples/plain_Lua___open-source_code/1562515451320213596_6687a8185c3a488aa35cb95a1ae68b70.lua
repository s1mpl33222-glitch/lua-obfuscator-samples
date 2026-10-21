-- bib

local Library = (function()
-- ===========================
-- SERVICES
-- ===========================
local UIS  = game:GetService("UserInputService")
local TS   = game:GetService("TweenService")
local Players = game:GetService("Players")

-- ===========================
-- COLORS
-- ===========================
local C_BG       = Color3.fromRGB(16, 18, 24)
local C_SIDEBAR  = Color3.fromRGB(19, 23, 31)
local C_PANEL    = Color3.fromRGB(24, 28, 36)
local C_BORDER   = Color3.fromRGB(38, 44, 55)
local C_ACCENT   = Color3.fromRGB(90, 160, 255)
local C_TEXT     = Color3.fromRGB(220, 225, 230)
local C_MUTED    = Color3.fromRGB(110, 120, 135)

local FONT       = Enum.Font.Gotham
local FONT_B     = Enum.Font.GothamBold
local FSIZE      = 11

-- ===========================
-- SCREEN GUI
-- ===========================
local SG = Instance.new("ScreenGui")
SG.Name = "SIv2Menu"
SG.IgnoreGuiInset = true
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
do
    local ok, pg = pcall(function() return Players.LocalPlayer:WaitForChild("PlayerGui", 3) end)
    SG.Parent = (ok and pg) or game:GetService("CoreGui")
end

-- ===========================
-- MAIN WINDOW
-- ===========================
local MAIN = Instance.new("Frame", SG)
MAIN.Name = "Main"
MAIN.Size = UDim2.new(0, 520, 0, 360)
MAIN.Position = UDim2.new(0.5, 0, 0.5, 0)
MAIN.AnchorPoint = Vector2.new(0.5, 0.5)
MAIN.BackgroundColor3 = C_BG
MAIN.ClipsDescendants = true
MAIN.Active = true
MAIN.BorderSizePixel = 0
Instance.new("UICorner", MAIN).CornerRadius = UDim.new(0, 8)
do
    local s = Instance.new("UIStroke", MAIN)
    s.Color = C_BORDER; s.Thickness = 1
end

-- ===========================
-- SIDEBAR
-- ===========================
local SIDEBAR = Instance.new("Frame", MAIN)
SIDEBAR.Name = "Sidebar"
SIDEBAR.Size = UDim2.new(0, 140, 1, 0)
SIDEBAR.BackgroundColor3 = C_SIDEBAR
SIDEBAR.BorderSizePixel = 0
Instance.new("UICorner", SIDEBAR).CornerRadius = UDim.new(0, 8)
-- patch corner-only left side visible
local sidebarPatch = Instance.new("Frame", SIDEBAR)
sidebarPatch.Size = UDim2.new(0, 12, 1, 0)
sidebarPatch.Position = UDim2.new(1, -12, 0, 0)
sidebarPatch.BackgroundColor3 = C_SIDEBAR
sidebarPatch.BorderSizePixel = 0

-- Logo
local LOGO = Instance.new("TextLabel", SIDEBAR)
LOGO.Size = UDim2.new(1, -12, 0, 46)
LOGO.Position = UDim2.new(0, 12, 0, 10)
LOGO.BackgroundTransparency = 1
LOGO.Font = FONT_B
LOGO.TextColor3 = C_TEXT
LOGO.TextSize = 14
LOGO.RichText = true
LOGO.TextXAlignment = Enum.TextXAlignment.Left
LOGO.Text = [[ZEUS
<font color="#5aa0ff">INTERNAL</font> <font size="10" color="#6b7a8d">v2</font>]]

-- Divider
local DIV = Instance.new("Frame", SIDEBAR)
DIV.Size = UDim2.new(1, -24, 0, 1)
DIV.Position = UDim2.new(0, 12, 0, 60)
DIV.BackgroundColor3 = C_BORDER
DIV.BorderSizePixel = 0

-- Tab list scroll
local TAB_LIST = Instance.new("ScrollingFrame", SIDEBAR)
TAB_LIST.Size = UDim2.new(1, -10, 1, -140)
TAB_LIST.Position = UDim2.new(0, 5, 0, 68)
TAB_LIST.BackgroundTransparency = 1
TAB_LIST.ScrollBarThickness = 0
TAB_LIST.BorderSizePixel = 0
TAB_LIST.CanvasSize = UDim2.new(0, 0, 0, 0)
local TAB_LAYOUT = Instance.new("UIListLayout", TAB_LIST)
TAB_LAYOUT.Padding = UDim.new(0, 3)
TAB_LAYOUT.SortOrder = Enum.SortOrder.LayoutOrder
TAB_LAYOUT:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TAB_LIST.CanvasSize = UDim2.new(0, 0, 0, TAB_LAYOUT.AbsoluteContentSize.Y + 8)
end)

-- User info (bottom of sidebar)
local USER_FRAME = Instance.new("Frame", SIDEBAR)
USER_FRAME.Size = UDim2.new(1, -16, 0, 50)
USER_FRAME.Position = UDim2.new(0, 8, 1, -58)
USER_FRAME.BackgroundTransparency = 1

local USER_DIV = Instance.new("Frame", SIDEBAR)
USER_DIV.Size = UDim2.new(1, -24, 0, 1)
USER_DIV.Position = UDim2.new(0, 12, 1, -64)
USER_DIV.BackgroundColor3 = C_BORDER
USER_DIV.BorderSizePixel = 0

local AVATAR_IMG = Instance.new("ImageLabel", USER_FRAME)
AVATAR_IMG.Size = UDim2.new(0, 28, 0, 28)
AVATAR_IMG.Position = UDim2.new(0, 4, 0.5, -14)
AVATAR_IMG.BackgroundColor3 = C_PANEL
AVATAR_IMG.BorderSizePixel = 0
AVATAR_IMG.Image = ""
Instance.new("UICorner", AVATAR_IMG).CornerRadius = UDim.new(1, 0)
pcall(function()
    AVATAR_IMG.Image = Players:GetUserThumbnailAsync(
        Players.LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)

local USER_NAME = Instance.new("TextLabel", USER_FRAME)
USER_NAME.Size = UDim2.new(1, -38, 0, 16)
USER_NAME.Position = UDim2.new(0, 38, 0, 6)
USER_NAME.BackgroundTransparency = 1
USER_NAME.Font = FONT_B
USER_NAME.Text = Players.LocalPlayer.DisplayName
USER_NAME.TextColor3 = C_TEXT
USER_NAME.TextSize = 12
USER_NAME.TextXAlignment = Enum.TextXAlignment.Left

local USER_SUB = Instance.new("TextLabel", USER_FRAME)
USER_SUB.Size = UDim2.new(1, -38, 0, 14)
USER_SUB.Position = UDim2.new(0, 38, 0, 22)
USER_SUB.BackgroundTransparency = 1
USER_SUB.Font = FONT
USER_SUB.Text = "Expires: Lifetime"
USER_SUB.TextColor3 = C_MUTED
USER_SUB.TextSize = 10
USER_SUB.TextXAlignment = Enum.TextXAlignment.Left

-- ===========================
-- CONTENT AREA
-- ===========================
local CONTENT = Instance.new("Frame", MAIN)
CONTENT.Name = "Content"
CONTENT.Position = UDim2.new(0, 140, 0, 0)
CONTENT.Size = UDim2.new(1, -140, 1, 0)
CONTENT.BackgroundTransparency = 1
CONTENT.ClipsDescendants = true

-- Close / Minimize buttons
local BTN_CLOSE = Instance.new("TextButton", MAIN)
BTN_CLOSE.Size = UDim2.new(0, 16, 0, 16)
BTN_CLOSE.Position = UDim2.new(1, -22, 0, 6)
BTN_CLOSE.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
BTN_CLOSE.Text = ""
BTN_CLOSE.Font = FONT_B
BTN_CLOSE.ZIndex = 10
Instance.new("UICorner", BTN_CLOSE).CornerRadius = UDim.new(1, 0)
BTN_CLOSE.MouseButton1Click:Connect(function() MAIN.Visible = false end)

-- ===========================
-- FLOATING DOT (bolinha arrastável)
-- ===========================
local FLOAT_DOT = Instance.new("TextButton", SG)
FLOAT_DOT.Name = "FloatDot"
FLOAT_DOT.Size = UDim2.new(0, 40, 0, 40)
FLOAT_DOT.Position = UDim2.new(0.5, 240, 0.5, 0)
FLOAT_DOT.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
FLOAT_DOT.Text = "Z"
FLOAT_DOT.Font = FONT_B
FLOAT_DOT.TextSize = 16
FLOAT_DOT.TextColor3 = Color3.fromRGB(255, 255, 255)
FLOAT_DOT.Visible = false
FLOAT_DOT.ZIndex = 100
FLOAT_DOT.Active = true
FLOAT_DOT.AutoButtonColor = false
Instance.new("UICorner", FLOAT_DOT).CornerRadius = UDim.new(1, 0)
do
    local s = Instance.new("UIStroke", FLOAT_DOT)
    s.Color = Color3.fromRGB(255, 130, 130)
    s.Thickness = 1.5
end

do
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    FLOAT_DOT.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = i.Position
            startPos = FLOAT_DOT.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then moved = true end
            FLOAT_DOT.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    FLOAT_DOT.MouseButton1Click:Connect(function()
        if moved then return end
        MAIN.Visible = true
    end)
end

-- Sincroniza visibilidade do dot com o menu
local function SyncFloatDot()
    FLOAT_DOT.Visible = not MAIN.Visible
end
MAIN:GetPropertyChangedSignal("Visible"):Connect(SyncFloatDot)
SyncFloatDot()

-- Resize handle
local RESIZER = Instance.new("TextButton", MAIN)
RESIZER.Size = UDim2.new(0, 22, 0, 22)
RESIZER.Position = UDim2.new(1, -22, 1, -22)
RESIZER.BackgroundTransparency = 1
RESIZER.Text = "//"
RESIZER.TextSize = 13
RESIZER.TextColor3 = C_MUTED
RESIZER.Font = FONT_B
RESIZER.ZIndex = 10

-- ===========================
-- DRAG
-- ===========================
do
    local dragging, dragStart, startPos
    SIDEBAR.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = MAIN.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            MAIN.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
end

-- ===========================
-- RESIZE
-- ===========================
do
    local resizing, rsPos, rsSize
    RESIZER.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; rsPos = i.Position; rsSize = MAIN.AbsoluteSize
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then resizing = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - rsPos
            local w = math.max(380, rsSize.X + d.X)
            local h = math.max(260, rsSize.Y + d.Y)
            MAIN.Size = UDim2.new(0, w, 0, h)
            CONTENT.Size = UDim2.new(1, -140, 1, 0)
        end
    end)
end

-- ===========================
-- VISIBILITY TOGGLE
-- ===========================
local toggleKey = Enum.KeyCode.Delete
local clicks, lastClick = 0, 0
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == toggleKey then
        MAIN.Visible = not MAIN.Visible
    end
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        local t = tick()
        if t - lastClick < 0.4 then clicks = clicks + 1 else clicks = 1 end
        lastClick = t
        if clicks >= 5 then clicks = 0; MAIN.Visible = not MAIN.Visible end
    end
end)

-- ===========================
-- NOTIFICATIONS
-- ===========================
local NOTIF_HOLDER = Instance.new("Frame", SG)
NOTIF_HOLDER.Size = UDim2.new(0, 240, 1, -20)
NOTIF_HOLDER.Position = UDim2.new(1, -250, 0, 10)
NOTIF_HOLDER.BackgroundTransparency = 1
do
    local nl = Instance.new("UIListLayout", NOTIF_HOLDER)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom
    nl.Padding = UDim.new(0, 6)
end

-- ===========================
-- HELPERS
-- ===========================
local function tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function mkCorner(p, r) Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 4) end
local function mkStroke(p, c, t) local s=Instance.new("UIStroke",p); s.Color=c or C_BORDER; s.Thickness=t or 1 end

-- ===========================
-- SECTION CLASS
-- ===========================
local Section = {}
Section.__index = Section

function Section:_row(h)
    local f = Instance.new("Frame", self._list)
    f.Size = UDim2.new(1, 0, 0, h)
    f.BackgroundTransparency = 1
    return f
end

function Section:AddToggle(label, default, flag, cb)
    if type(flag) == "function" then cb = flag; flag = nil end
    local row = self:_row(28)
    
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -54, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = default and C_TEXT or C_MUTED
    lbl.Text = label; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0, 30, 0, 15)
    pill.Position = UDim2.new(1, -38, 0.5, -7)
    pill.BackgroundColor3 = default and C_ACCENT or Color3.fromRGB(40, 46, 58)
    mkCorner(pill, 8); mkStroke(pill, C_BORDER)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, 11, 0, 11)
    knob.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mkCorner(knob, 6)

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1; btn.Text = ""

    local obj = {Value = default}
    function obj:Set(v)
        obj.Value = v
        lbl.TextColor3 = v and C_TEXT or C_MUTED
        tween(pill, {BackgroundColor3 = v and C_ACCENT or Color3.fromRGB(40, 46, 58)})
        tween(knob, {Position = v and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)})
        if cb then task.spawn(pcall, cb, v) end
    end

    btn.MouseButton1Click:Connect(function() obj:Set(not obj.Value) end)
    if flag then if not _G.Toggles then _G.Toggles = {} end; _G.Toggles[flag] = obj end
    if default and cb then task.spawn(pcall, cb, default) end
    return obj
end

function Section:AddSlider(label, min, max, default, flag, cb)
    if type(flag) == "function" then cb = flag; flag = nil end
    local row = self:_row(44)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 0, 18)
    lbl.Position = UDim2.new(0, 8, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = C_MUTED; lbl.Text = label
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local val_lbl = Instance.new("TextLabel", row)
    val_lbl.Size = UDim2.new(0.4, -10, 0, 18)
    val_lbl.Position = UDim2.new(0.6, 0, 0, 3)
    val_lbl.BackgroundTransparency = 1
    val_lbl.Font = FONT_B; val_lbl.TextSize = FSIZE
    val_lbl.TextColor3 = C_TEXT
    val_lbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -16, 0, 3)
    track.Position = UDim2.new(0, 8, 1, -14)
    track.BackgroundColor3 = Color3.fromRGB(35, 42, 54)
    mkCorner(track, 2)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = C_ACCENT
    mkCorner(fill, 2)

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 11, 0, 11)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new(0, 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mkCorner(thumb, 6)

    local hitbox = Instance.new("TextButton", track)
    hitbox.Size = UDim2.new(1, 0, 0, 26)
    hitbox.Position = UDim2.new(0, 0, 0.5, -13)
    hitbox.BackgroundTransparency = 1; hitbox.Text = ""

    local obj = {Value = default}
    function obj:Set(v)
        v = math.clamp(math.floor(v), min, max)
        obj.Value = v
        local r = (v - min) / math.max(1, max - min)
        tween(fill, {Size = UDim2.new(r, 0, 1, 0)}, 0.1)
        tween(thumb, {Position = UDim2.new(r, 0, 0.5, 0)}, 0.1)
        val_lbl.Text = tostring(v)
        if cb then task.spawn(pcall, cb, v) end
    end
    obj:Set(default)

    local sliding = false
    local function fromInput(i)
        local px = i.Position.X - track.AbsolutePosition.X
        local r = math.clamp(px / track.AbsoluteSize.X, 0, 1)
        obj:Set(min + (max - min) * r)
    end
    hitbox.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; fromInput(i) end
    end)
    hitbox.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then fromInput(i) end
    end)

    if flag then if not _G.Toggles then _G.Toggles = {} end; _G.Toggles[flag] = obj end
    if cb then task.spawn(pcall, cb, default) end
    return obj
end

function Section:AddDropdown(label, options, default, flag, cb)
    if type(flag) == "function" then cb = flag; flag = nil end
    local row = self:_row(32)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.45, -4, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = C_MUTED; lbl.Text = label
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    local dbtn = Instance.new("TextButton", row)
    dbtn.Size = UDim2.new(0.55, -12, 0, 22)
    dbtn.Position = UDim2.new(0.45, 4, 0.5, -11)
    dbtn.BackgroundColor3 = C_PANEL; dbtn.Font = FONT
    dbtn.TextColor3 = C_TEXT; dbtn.TextSize = FSIZE - 1
    dbtn.TextXAlignment = Enum.TextXAlignment.Left
    dbtn.TextTruncate = Enum.TextTruncate.AtEnd
    mkCorner(dbtn, 4); mkStroke(dbtn)
    local dp = Instance.new("UIPadding", dbtn); dp.PaddingLeft = UDim.new(0, 7)
    local arrow = Instance.new("TextLabel", dbtn)
    arrow.Size = UDim2.new(0, 18, 1, 0); arrow.Position = UDim2.new(1, -18, 0, 0)
    arrow.BackgroundTransparency = 1; arrow.Font = FONT_B
    arrow.Text = "▾"; arrow.TextColor3 = C_MUTED; arrow.TextSize = 14

    local cur = 1
    for i, v in ipairs(options) do if v == default then cur = i break end end

    local obj = {Value = options[cur] or (options[1] or "")}
    function obj:Set(v)
        obj.Value = v; dbtn.Text = tostring(v)
        if cb then task.spawn(pcall, cb, v) end
    end
    obj:Set(obj.Value)

    local open = false
    dbtn.MouseButton1Click:Connect(function()
        if open then return end; open = true
        local cc = Instance.new("TextButton", SG)
        cc.Size = UDim2.new(1,0,1,0); cc.BackgroundTransparency = 1; cc.Text = ""; cc.ZIndex = 98
        local df = Instance.new("ScrollingFrame", cc)
        df.Size = UDim2.new(0, dbtn.AbsoluteSize.X, 0, math.min(#options * 26 + 6, 130))
        df.Position = UDim2.new(0, dbtn.AbsolutePosition.X, 0, dbtn.AbsolutePosition.Y + 26)
        df.BackgroundColor3 = Color3.fromRGB(26, 31, 41); df.ZIndex = 99
        df.ScrollBarThickness = 2; df.BorderSizePixel = 0; df.CanvasSize = UDim2.new(0,0,0,0)
        mkCorner(df, 5); mkStroke(df, Color3.fromRGB(50,58,72))
        local dll = Instance.new("UIListLayout", df); dll.SortOrder = Enum.SortOrder.LayoutOrder
        for _, v in ipairs(options) do
            local ob = Instance.new("TextButton", df)
            ob.Size = UDim2.new(1, 0, 0, 26); ob.BackgroundTransparency = 1
            ob.Font = FONT; ob.TextColor3 = C_TEXT; ob.TextSize = FSIZE - 1
            ob.Text = "  "..tostring(v); ob.TextXAlignment = Enum.TextXAlignment.Left; ob.ZIndex = 100
            ob.TextTruncate = Enum.TextTruncate.AtEnd
            ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.8; ob.BackgroundColor3 = C_ACCENT end)
            ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 1 end)
            ob.MouseButton1Click:Connect(function() obj:Set(v); open = false; cc:Destroy() end)
        end
        df.CanvasSize = UDim2.new(0,0,0,dll.AbsoluteContentSize.Y)
        cc.MouseButton1Click:Connect(function() open = false; cc:Destroy() end)
    end)

    if flag then if not _G.Toggles then _G.Toggles = {} end; _G.Toggles[flag] = obj end
    if default and cb then task.spawn(pcall, cb, default) end
    return obj
end

function Section:AddKeybind(label, defaultKey, flag, cb)
    if type(flag) == "function" then cb = flag; flag = nil end
    local row = self:_row(28)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 1, 0); lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = C_MUTED; lbl.Text = label; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local kbtn = Instance.new("TextButton", row)
    kbtn.Size = UDim2.new(0, 72, 0, 20); kbtn.Position = UDim2.new(1, -80, 0.5, -10)
    kbtn.BackgroundColor3 = C_PANEL; kbtn.Font = FONT; kbtn.TextSize = FSIZE - 1
    kbtn.TextColor3 = C_TEXT; mkCorner(kbtn, 4); mkStroke(kbtn)

    local obj = {Value = defaultKey}
    function obj:Set(v) obj.Value = v; kbtn.Text = v and v.Name or "None" end
    obj:Set(defaultKey)

    local listening = false
    kbtn.MouseButton1Click:Connect(function() listening = true; kbtn.Text = "..." end)
    UIS.InputBegan:Connect(function(i, gp)
        if listening and i.UserInputType == Enum.UserInputType.Keyboard then
            listening = false; obj:Set(i.KeyCode)
        elseif not listening and not gp and i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == obj.Value then
            if cb then task.spawn(pcall, cb) end
        end
    end)
    if flag then if not _G.Toggles then _G.Toggles = {} end; _G.Toggles[flag] = obj end
    return obj
end

function Section:AddColorPicker(label, defaultColor, flag, cb)
    if type(flag) == "function" then cb = flag; flag = nil end
    local row = self:_row(28)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -50, 1, 0); lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = C_MUTED; lbl.Text = label; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    local preview = Instance.new("Frame", row)
    preview.Size = UDim2.new(0, 26, 0, 18); preview.Position = UDim2.new(1, -34, 0.5, -9)
    preview.BackgroundColor3 = defaultColor; mkCorner(preview, 4); mkStroke(preview)
    local pbtn = Instance.new("TextButton", preview)
    pbtn.Size = UDim2.new(1,0,1,0); pbtn.BackgroundTransparency = 1; pbtn.Text = ""

    local obj = {Value = defaultColor}
    function obj:Set(v) obj.Value = v; preview.BackgroundColor3 = v; if cb then task.spawn(pcall, cb, v) end end

    local PALETTE = {
        Color3.fromRGB(255,70,70),  Color3.fromRGB(255,140,60),  Color3.fromRGB(255,220,60), Color3.fromRGB(140,255,70),
        Color3.fromRGB(60,255,120), Color3.fromRGB(60,220,255),  Color3.fromRGB(70,140,255), Color3.fromRGB(120,80,255),
        Color3.fromRGB(220,70,255), Color3.fromRGB(255,70,180),  Color3.fromRGB(255,255,255),Color3.fromRGB(180,180,180),
        Color3.fromRGB(100,100,100),Color3.fromRGB(40,40,40),    Color3.fromRGB(255,200,140),Color3.fromRGB(140,200,255),
    }
    local open = false
    pbtn.MouseButton1Click:Connect(function()
        if open then return end; open = true
        local cc = Instance.new("TextButton", SG); cc.Size = UDim2.new(1,0,1,0)
        cc.BackgroundTransparency = 1; cc.Text = ""; cc.ZIndex = 98
        local px = math.min(pbtn.AbsolutePosition.X - 60, SG.AbsoluteSize.X - 150)
        local py = math.min(pbtn.AbsolutePosition.Y + 22, SG.AbsoluteSize.Y - 155)
        local pf = Instance.new("Frame", cc)
        pf.Size = UDim2.new(0, 138, 0, 138); pf.Position = UDim2.new(0, px, 0, py)
        pf.BackgroundColor3 = Color3.fromRGB(24,29,39); pf.ZIndex = 99
        mkCorner(pf, 6); mkStroke(pf, Color3.fromRGB(50,58,72))
        local gl = Instance.new("UIGridLayout", pf)
        gl.CellSize = UDim2.new(0, 24, 0, 24); gl.CellPadding = UDim2.new(0, 5, 0, 5)
        local gp2 = Instance.new("UIPadding", pf); gp2.PaddingTop = UDim.new(0,9); gp2.PaddingLeft = UDim.new(0,9)
        for _, col in ipairs(PALETTE) do
            local cb2 = Instance.new("TextButton", pf); cb2.BackgroundColor3 = col; cb2.Text = ""; cb2.ZIndex = 100
            mkCorner(cb2, 4)
            cb2.MouseButton1Click:Connect(function() obj:Set(col); open = false; cc:Destroy() end)
        end
        cc.MouseButton1Click:Connect(function() open = false; cc:Destroy() end)
    end)
    if flag then if not _G.Toggles then _G.Toggles = {} end; _G.Toggles[flag] = obj end
    if cb then task.spawn(pcall, cb, defaultColor) end
    return obj
end

function Section:AddTextbox(label, flag, cb)
    if type(flag) == "function" then cb = flag; flag = nil end
    local row = self:_row(32)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.45, -4, 1, 0); lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = C_MUTED; lbl.Text = label; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0.55, -12, 0, 22); box.Position = UDim2.new(0.45, 4, 0.5, -11)
    box.BackgroundColor3 = C_PANEL; box.Font = FONT; box.TextColor3 = C_TEXT; box.TextSize = FSIZE - 1
    box.PlaceholderText = "..."; box.PlaceholderColor3 = C_MUTED; mkCorner(box, 4); mkStroke(box)
    box.ClearTextOnFocus = false
    local bp = Instance.new("UIPadding", box); bp.PaddingLeft = UDim.new(0, 6)
    local obj = {Value = ""}
    function obj:Set(v) obj.Value = v; box.Text = tostring(v); if cb then task.spawn(pcall, cb, v) end end
    box.FocusLost:Connect(function() obj.Value = box.Text; if cb then task.spawn(pcall, cb, box.Text) end end)
    if flag then if not _G.Toggles then _G.Toggles = {} end; _G.Toggles[flag] = obj end
    return obj
end

function Section:AddButton(label, cb)
    local row = self:_row(34)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, -16, 0, 26); btn.Position = UDim2.new(0, 8, 0.5, -13)
    btn.BackgroundColor3 = C_PANEL; btn.Font = FONT_B; btn.TextSize = FSIZE
    btn.TextColor3 = C_TEXT; btn.Text = label; mkCorner(btn, 5); mkStroke(btn)
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.MouseButton1Click:Connect(function()
        tween(btn, {BackgroundColor3 = C_ACCENT}, 0.1)
        task.delay(0.2, function() tween(btn, {BackgroundColor3 = C_PANEL}, 0.15) end)
        if cb then task.spawn(pcall, cb) end
    end)
    return btn
end

function Section:AddLabel(text)
    local row = self:_row(22)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -16, 1, 0); lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Font = FONT; lbl.TextSize = FSIZE - 1
    lbl.TextColor3 = C_MUTED; lbl.Text = text; lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local obj = {Value = text}
    function obj:Set(v) obj.Value = v; lbl.Text = tostring(v) end
    return obj
end

-- ===========================
-- TAB CLASS
-- ===========================
local Tab = {}
Tab.__index = Tab

function Tab:AddSection(name)
    local sec = Instance.new("Frame", self._col)
    sec.BackgroundColor3 = C_PANEL
    sec.Size = UDim2.new(1, 0, 0, 10)
    sec.BorderSizePixel = 0
    sec.LayoutOrder = self._secCount
    self._secCount = self._secCount + 1
    mkCorner(sec, 6); mkStroke(sec, C_BORDER)

    local title = Instance.new("TextLabel", sec)
    title.Size = UDim2.new(1, -12, 0, 26)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = FONT_B; title.TextSize = FSIZE
    title.TextColor3 = C_TEXT; title.Text = name
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd

    local sep = Instance.new("Frame", sec)
    sep.Size = UDim2.new(1, -20, 0, 1); sep.Position = UDim2.new(0, 10, 0, 26)
    sep.BackgroundColor3 = C_BORDER; sep.BorderSizePixel = 0

    local list_frame = Instance.new("Frame", sec)
    list_frame.Position = UDim2.new(0, 0, 0, 28)
    list_frame.Size = UDim2.new(1, 0, 0, 0)
    list_frame.BackgroundTransparency = 1

    local ll = Instance.new("UIListLayout", list_frame)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 1)

    local botPad = Instance.new("UIPadding", list_frame)
    botPad.PaddingBottom = UDim.new(0, 4)

    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local h = ll.AbsoluteContentSize.Y + 34
        sec.Size = UDim2.new(1, 0, 0, h)
        local sp = self._scrollFrame
        if sp then
            local col = self._col
            local cll = col:FindFirstChildWhichIsA("UIListLayout")
            if cll then
                sp.CanvasSize = UDim2.new(0, 0, 0, cll.AbsoluteContentSize.Y + 16)
            end
        end
    end)

    list_frame.Size = UDim2.new(1, 0, 0, 0)

    local sObj = setmetatable({}, Section)
    sObj._list = list_frame
    return sObj
end

-- ===========================
-- WINDOW CLASS
-- ===========================
local allTabs = {}
local activeTabFrame = nil

local Window = {}
Window.__index = Window

function Window:AddTab(name, iconData)
    local container = Instance.new("Frame", TAB_LIST)
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.BackgroundColor3 = Color3.fromRGB(28, 34, 46)
    mkCorner(container, 5)

    local ic = Instance.new("ImageLabel", container)
    ic.Size = UDim2.new(0, 14, 0, 14)
    ic.Position = UDim2.new(0, 8, 0.5, -7)
    ic.BackgroundTransparency = 1
    ic.ImageColor3 = C_MUTED

    if iconData then
        if type(iconData) == "table" then
            if iconData.Image then ic.Image = iconData.Image end
            if iconData.ImageRectOffset then ic.ImageRectOffset = iconData.ImageRectOffset end
            if iconData.ImageRectSize then ic.ImageRectSize = iconData.ImageRectSize end
        elseif type(iconData) == "number" then
            ic.Image = "rbxassetid://"..iconData
        elseif type(iconData) == "string" then
            ic.Image = iconData
        end
    else
        ic.Visible = false
    end

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1, -32, 1, 0)
    lbl.Position = UDim2.new(0, 28, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = FONT; lbl.TextSize = FSIZE
    lbl.TextColor3 = C_MUTED
    lbl.Text = name
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local sf = Instance.new("ScrollingFrame", CONTENT)
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.Visible = false
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C_BORDER
    sf.BorderSizePixel = 0
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)

    local sfPad = Instance.new("UIPadding", sf)
    sfPad.PaddingTop = UDim.new(0, 10); sfPad.PaddingLeft = UDim.new(0, 10)
    sfPad.PaddingRight = UDim.new(0, 10)

    local col = Instance.new("Frame", sf)
    col.Name = "Col1"
    col.BackgroundTransparency = 1
    col.Size = UDim2.new(1, 0, 0, 0)
    col.Position = UDim2.new(0, 0, 0, 0)

    local colLayout = Instance.new("UIListLayout", col)
    colLayout.Padding = UDim.new(0, 8)
    colLayout.SortOrder = Enum.SortOrder.LayoutOrder

    colLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sf.CanvasSize = UDim2.new(0, 0, 0, colLayout.AbsoluteContentSize.Y + 24)
        col.Size = UDim2.new(1, 0, 0, colLayout.AbsoluteContentSize.Y)
    end)

    if not activeTabFrame then
        sf.Visible = true; activeTabFrame = sf
        container.BackgroundTransparency = 0
        lbl.TextColor3 = C_TEXT
        ic.ImageColor3 = C_ACCENT
    end

    table.insert(allTabs, {Container = container, Lbl = lbl, Ic = ic, Frame = sf})

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(allTabs) do
            t.Frame.Visible = false
            t.Container.BackgroundTransparency = 1
            t.Lbl.TextColor3 = C_MUTED
            t.Ic.ImageColor3 = C_MUTED
        end
        sf.Visible = true; activeTabFrame = sf
        container.BackgroundTransparency = 0
        lbl.TextColor3 = C_TEXT
        ic.ImageColor3 = C_ACCENT
    end)

    local tabObj = setmetatable({}, Tab)
    tabObj._col = col
    tabObj._scrollFrame = sf
    tabObj._secCount = 0
    return tabObj
end

-- ===========================
-- LIBRARY API
-- ===========================
local Lib = {}

function Lib:CreateWindow(title, keyOrEnum)
    if typeof(keyOrEnum) == "EnumItem" and keyOrEnum.EnumType == Enum.KeyCode then
        toggleKey = keyOrEnum
    end
    return setmetatable({}, Window)
end

function Lib:Notify(title, text, duration, _type)
    local n = Instance.new("Frame", NOTIF_HOLDER)
    n.Size = UDim2.new(1, 0, 0, 52)
    n.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
    n.BackgroundTransparency = 1
    mkCorner(n, 6)
    local ns = Instance.new("UIStroke", n); ns.Color = C_ACCENT; ns.Thickness = 1; ns.Transparency = 1
    local nt = Instance.new("TextLabel", n)
    nt.Size = UDim2.new(1,-16, 0.44, 0); nt.Position = UDim2.new(0, 10, 0, 4)
    nt.BackgroundTransparency = 1; nt.Font = FONT_B; nt.TextSize = 12
    nt.TextColor3 = C_TEXT; nt.Text = tostring(title); nt.TextXAlignment = Enum.TextXAlignment.Left
    nt.TextTruncate = Enum.TextTruncate.AtEnd
    nt.TextTransparency = 1
    local nb = Instance.new("TextLabel", n)
    nb.Size = UDim2.new(1,-16, 0.5, 0); nb.Position = UDim2.new(0, 10, 0.44, 0)
    nb.BackgroundTransparency = 1; nb.Font = FONT; nb.TextSize = 10
    nb.TextColor3 = C_MUTED; nb.Text = tostring(text); nb.TextXAlignment = Enum.TextXAlignment.Left
    nb.TextTruncate = Enum.TextTruncate.AtEnd
    nb.TextTransparency = 1
    tween(n, {BackgroundTransparency = 0}, 0.25)
    tween(ns, {Transparency = 0}, 0.25)
    tween(nt, {TextTransparency = 0}, 0.25)
    tween(nb, {TextTransparency = 0}, 0.25)
    task.spawn(function()
        task.wait(duration or 3)
        tween(n, {BackgroundTransparency = 1}, 0.25)
        tween(ns, {Transparency = 1}, 0.25)
        tween(nt, {TextTransparency = 1}, 0.25)
        local tw = TS:Create(nb, TweenInfo.new(0.25), {TextTransparency = 1})
        tw:Play(); tw.Completed:Wait(); pcall(function() n:Destroy() end)
    end)
end

return Lib
end)()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Runtime = _G.ClassicArcaneRuntime or {Connections = {}, Drawings = {}}
for _, connection in ipairs(Runtime.Connections) do
    pcall(function() connection:Disconnect() end)
end
for _, drawing in ipairs(Runtime.Drawings) do
    pcall(function() drawing:Remove() end)
end
Runtime.Connections = {}
Runtime.Drawings = {}
_G.ClassicArcaneRuntime = Runtime

local function TrackConnection(connection)
    if connection then
        table.insert(Runtime.Connections, connection)
    end
    return connection
end

local function TrackDrawing(drawing)
    if drawing then
        table.insert(Runtime.Drawings, drawing)
    end
    return drawing
end

_G.Toggles = {}
local Toggles = _G.Toggles

task.spawn(function()
    local function limparBan()
        local carregamento = LocalPlayer:WaitForChild("CarregamentoFold", 10)
        if carregamento then
            local dataBan = carregamento:WaitForChild("DataBanimento", 10)
            if dataBan then
                dataBan.Changed:Connect(function(novoValor)
                    if novoValor == true and Toggles.AntiBanimento then
                        dataBan.Value = false
                    end
                end)
            end
        end
    end
    limparBan()
end)

task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local SistemaReviver = ReplicatedStorage:WaitForChild("SistemaReviver", 10)
    
    if SistemaReviver then
        local Reanimar = SistemaReviver:WaitForChild("Reanimar", 5)
        local Reanimando = SistemaReviver:WaitForChild("Reanimando", 5)

        if Reanimar and Reanimando then
            Reanimar.OnClientEvent:Connect(function(p1, p2)
                if _G.Toggles.AutoReviver then
                    pcall(function()
                        Reanimando:FireServer(p1, p2)
                    end)
                end
            end)
        end
    end
end)

local CurrentCamera = Workspace.CurrentCamera
_G.MaxAimbotDistance = 500
_G.MaxESPDistance = 500

_G.PlayerRespawnCooldowns = {}
_G.PlayerShieldCooldowns = {}
_G.WallCheckCache = {}
_G.SkunkDrawings = {}

local ThemeColors = {
    Background = Color3.fromRGB(10, 10, 10),
    Sidebar = Color3.fromRGB(15, 15, 15),
    Element = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(255, 0, 0),
    DarkAccent = Color3.fromRGB(100, 0, 0),
    Stroke = Color3.fromRGB(180, 0, 0)
}

_G.Settings = {
    Combat = {
        OrgCheck = false,
        Enabled = false,
        Mode = "Legitado(claramente 💸)",
        AimPart = "Head",
        FOV = 120,
        ShowFOV = false,
        DynamicFOV = false,
        Smoothness = 1,
        Deadzone = 0,
        TeamCheck = false,
        WallCheck = true,
        AutoFire = false,
        ShieldCheck = false,
        IgnoreVehicles = false,
        IgnoreDeadOrRespawning = true,
        MaxDistance = _G.MaxAimbotDistance,
        LockTarget = nil,
        AimbotBind = Enum.UserInputType.MouseButton2,
        UseToggleMode = false,
        TriggerbotEnabled = false,
        MobileMode = false,
        AutoAim = false,
        HitboxHSEnabled = false,
        HitboxHSSize = 15,
        HitboxHSTransparency = 0.65,
        PlayerAlerts = false,
        CopySkinPlayerName = "Nobary",
        RemoveAura = false,
        RemoveEffects = false,
        SavePosBind = Enum.KeyCode.F6,
        LoadPosBind = Enum.KeyCode.F7,
        PullBind = Enum.KeyCode.F8,
        PullEnabled = false,
        PullDistance = 15,
        FakeDashEnabled = false,
        FakeDashDistance = 8,
        FakeDashCooldown = 0.25,
        FakeLagBind = Enum.KeyCode.F9,
        FakeLagEnabled = false,
        FakeLagDistance = 15,
        FakeLagCooldown = 1.0,
        FakeLagVariations = "12,15,18",
        WallCheckBypass = false,
        WallCheckBypassBind = Enum.KeyCode.F10,
        RapidFireEnabled = false,
        RapidFireDelay = 0.06,
        HoldToAimEnabled = false,
        AimKey = Enum.KeyCode.E,
        FixedCrosshair = false
    },
    Visuals = {
        Enabled = false,
        TeamCheck = false,
        BoxEnabled = false,
        BoxType = "2D",
        BoxFilled = false,
        Box3D = false,
        ChineseHat = false,
        HealthText = false,
        Preview = false,
        Skeleton = false,
        Tracers = false,
        TracerOrigin = "Bottom",
        Names = false,
        Distance = false,
        HealthBar = true,
        Hat = false,
        HeadDot = false,
        LookTracer = false,
        OffscreenArrows = false,
        Chams = true,
        MaxDistance = _G.MaxESPDistance,
        RainbowGun = false,
        VisibilityCheck = false,
        Streamproof = true,
        Playtime = false,
        Inventory = false,
        ShowLocalPlayer = false,
        Rainbow = false,
        Radar = false,
        HealthGradient = false,
        Colors = {
            FOV = ThemeColors.Accent,
            Enemy = ThemeColors.Accent,
            Friend = Color3.fromRGB(0, 0, 255),
            Name = Color3.fromRGB(255, 255, 255),
            Distance = Color3.fromRGB(200, 200, 200),
            Tracer = ThemeColors.Accent,
            Skeleton = ThemeColors.Accent,
            Health = Color3.fromRGB(0, 255, 0),
            Invisible = Color3.fromRGB(120, 120, 120),
            Box = ThemeColors.Accent
        }
    },
    World = {
        Fullbright = false,
        NightMode = false,
        Time = 12
    },
    Menu = {
        Keybind = Enum.KeyCode.Delete,
        Transparency = 0,
        Watermark = true,
        Scale = 1
    },
    Friends = {},
    IlhaBela = {
        GariFarmBind = Enum.KeyCode.F5
    }
}

do
    local CONFIG_FILE_EARLY = "classic_arcane_config.json"
    if type(isfile) == "function" and isfile(CONFIG_FILE_EARLY)
        and type(readfile) == "function" then
        local ok, raw = pcall(readfile, CONFIG_FILE_EARLY)
        if ok then
            local parseOk, payload = pcall(function()
                return game:GetService("HttpService"):JSONDecode(raw)
            end)
            if parseOk and type(payload) == "table" and payload.autoLoad == true
                and type(payload.settings) == "table" then
                local function decodeEarly(v)
                    if type(v) ~= "table" or not v.__type then return v end
                    if v.__type == "Color3" then return Color3.new(v.r or 0, v.g or 0, v.b or 0) end
                    if v.__type == "Vector3" then return Vector3.new(v.x or 0, v.y or 0, v.z or 0) end
                    if v.__type == "EnumItem" then
                        local et = v.enumType and Enum[v.enumType]
                        return et and v.name and et[v.name] or nil
                    end
                    if v.__type == "nil" then return nil end
                    if v.__type == "table" then
                        local res = {}
                        for _, entry in ipairs(v.entries or {}) do
                            local k = decodeEarly(entry.key)
                            local val = decodeEarly(entry.value)
                            if k ~= nil then res[k] = val end
                        end
                        return res
                    end
                    return v
                end
                local function mergeEarly(target, source)
                    for k, v in pairs(source or {}) do
                        local decoded = decodeEarly(v)
                        if type(decoded) == "table" and type(target[k]) == "table" then
                            mergeEarly(target[k], decoded)
                        elseif decoded ~= nil then
                            target[k] = decoded
                        end
                    end
                end
                pcall(function()
                    local saved = decodeEarly(payload.settings)
                    if type(saved) == "table" then
                        mergeEarly(_G.Settings, saved)
                    end
                end)
            end
        end
    end
end

function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
    end)
end

local function IsFriend(player)
    return player and _G.Settings and _G.Settings.Friends and _G.Settings.Friends[player.UserId] == true
end

local function IsSameOrg(player)
    if not _G.Settings.Combat.OrgCheck then return false end
    
    local localFac = LocalPlayer:FindFirstChild("FacRuaInfos")
    local targetFac = player:FindFirstChild("FacRuaInfos")
    
    if localFac and targetFac then
        local localOrg = localFac:FindFirstChild("OrgName")
        local targetOrg = targetFac:FindFirstChild("OrgName")
        
        if localOrg and targetOrg and localOrg.Value ~= "" and targetOrg.Value ~= "" then
            return localOrg.Value == targetOrg.Value
        end
    end
    return false
end

local function isPlayerInVehicle(player)
    if not player or not player.Character then return false end
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Sit then return true end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local current = root.Parent
    while current and current ~= Workspace do
        local parentName = current.Name
        if parentName == "CarrosSpawnados" or parentName == "BarcosSpawnados" or parentName == "AeroSpawnados" then
            return true
        end
        current = current.Parent
    end
    for _, descendant in pairs(char:GetDescendants()) do
        if descendant:IsA("VehicleSeat") and descendant.Occupant == char then
            return true
        end
    end
    return false
end

local function Modificar_Radio_Vip(estado)
    local vips = LocalPlayer:FindFirstChild("VipsAdquiridos")
    if vips then
        local radio = vips:FindFirstChild("Radio")
        if radio then
            radio.Value = estado and "Sim" or "Não"
        end
    end
end

local function CreateDrawInstance(objectType, properties)
    if not Drawing or type(Drawing.new) ~= "function" then
        warn("Drawing API não disponível!")
        return nil
    end

    local ok, obj = pcall(function()
        return Drawing.new(objectType)
    end)
    if not ok or not obj then
        warn("Não foi possível criar o objeto Drawing: " .. tostring(objectType))
        return nil
    end
    TrackDrawing(obj)

    if _G.Settings.Visuals.Streamproof then
        pcall(function()
            obj.VisibleInCapture = false
        end)
    end

    for prop, val in pairs(properties or {}) do
        pcall(function()
            obj[prop] = val
        end)
    end

    pcall(function()
        if not obj.Color then
            obj.Color = Color3.fromRGB(255, 0, 0)
        end
    end)
    return obj
end

local ValidBodyParts = {
    "Head","UpperTorso","LowerTorso","HumanoidRootPart",
    "LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
    "LeftHand","RightHand","LeftUpperLeg","RightUpperLeg",
    "LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"
}

local aimbotSettings = {
    FOV = 120,
    MaxDistance = 125,
    Smoothness = 0.4,
    Enabled = false,
    ShowFOV = true,
    HeadOffset = Vector3.new(0, 0.05, 0),
    isMobile = UserInputService.TouchEnabled,
}

local function SetDrawingProperty(object, property, value)
    if not object then return end
    pcall(function()
        object[property] = value
    end)
end

local DrawingCircle = nil
local circleOk, circle = pcall(function()
    if not Drawing or type(Drawing.new) ~= "function" then
        return nil
    end
    return Drawing.new("Circle")
end)
if circleOk and circle then
    DrawingCircle = TrackDrawing(circle)
    SetDrawingProperty(DrawingCircle, "Transparency", 1)
    SetDrawingProperty(DrawingCircle, "Thickness", 2)
    SetDrawingProperty(DrawingCircle, "Color", Color3.fromRGB(50, 255, 50))
    SetDrawingProperty(DrawingCircle, "Radius", aimbotSettings.FOV)
    SetDrawingProperty(DrawingCircle, "Visible", aimbotSettings.ShowFOV)
    if CurrentCamera then
        SetDrawingProperty(DrawingCircle, "Position", Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2))
    end
    SetDrawingProperty(DrawingCircle, "Filled", false)
end

local function getClosestHead()
    if not CurrentCamera then return nil end

    local closest, shortestDistance = nil, math.huge
    local cameraPos = CurrentCamera.CFrame.Position
    local cameraLook = CurrentCamera.CFrame.LookVector
    local screenCenter = CurrentCamera.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and head then
                if IsFriend(player) or IsSameOrg(player) then
                    continue
                end
                if _G.Settings.Combat.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                if _G.Settings.Combat.IgnoreVehicles and isPlayerInVehicle(player) then
                    continue
                end

                local offset = head.Position - cameraPos
                local distance = offset.Magnitude
                if distance <= 0 or distance > aimbotSettings.MaxDistance then
                    continue
                end

                local direction = offset / distance
                local dot = math.max(-1, math.min(1, cameraLook:Dot(direction)))
                local angle = math.deg(math.acos(dot))

                if angle <= aimbotSettings.FOV / 2 then
                    local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        if _G.Settings.Combat.WallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local localCharacter = LocalPlayer.Character
                            local filter = localCharacter and {localCharacter} or {}
                            if CurrentCamera then
                                table.insert(filter, CurrentCamera)
                            end
                            rayParams.FilterDescendantsInstances = filter
                            local rayResult = Workspace:Raycast(cameraPos, offset, rayParams)
                            if rayResult and not rayResult.Instance:IsDescendantOf(player.Character) then
                                continue
                            end
                        end

                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist2D < shortestDistance then
                            shortestDistance, closest = dist2D, head
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function aimbotLoop()
    CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then return end

    if DrawingCircle then
        DrawingCircle.Radius = aimbotSettings.FOV
        DrawingCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
        DrawingCircle.Visible = aimbotSettings.ShowFOV
    end

    if not aimbotSettings.Enabled then return end
    
    local target = getClosestHead()
    if target then
        local pos = target.Position + aimbotSettings.HeadOffset
        
        if aimbotSettings.isMobile then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local camPos = CurrentCamera.CFrame.Position
                local direction = pos - camPos
                if direction.Magnitude <= 0 then return end
                local targetDir = direction.Unit
                CurrentCamera.CFrame = CFrame.new(camPos, camPos + targetDir)
                
                if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                    CurrentCamera.CameraSubject = humanoid
                end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local look = (pos - hrp.Position).Unit
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z))
                end
            end
        else
            local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(pos)
            if onScreen and type(mousemoverel) == "function" then
                local dx = screenPos.X - CurrentCamera.ViewportSize.X/2
                local dy = screenPos.Y - CurrentCamera.ViewportSize.Y/2
                mousemoverel(dx * aimbotSettings.Smoothness, dy * aimbotSettings.Smoothness)
            end
        end
    end
end

local renderConnection = TrackConnection(RunService.RenderStepped:Connect(aimbotLoop))

local FixedCrosshairGui = nil
local FixedCrosshairDot = nil

local function EnsureFixedCrosshairDot()
    if FixedCrosshairGui and FixedCrosshairGui.Parent and FixedCrosshairDot then
        return
    end

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end

    local oldGui = playerGui:FindFirstChild("ClassicArcaneCrosshair")
    if oldGui then oldGui:Destroy() end

    FixedCrosshairGui = Instance.new("ScreenGui")
    FixedCrosshairGui.Name = "ClassicArcaneCrosshair"
    FixedCrosshairGui.IgnoreGuiInset = true
    FixedCrosshairGui.ResetOnSpawn = false
    FixedCrosshairGui.DisplayOrder = 999999
    FixedCrosshairGui.Enabled = false
    FixedCrosshairGui.Parent = playerGui

    FixedCrosshairDot = Instance.new("Frame")
    FixedCrosshairDot.Name = "Dot"
    FixedCrosshairDot.AnchorPoint = Vector2.new(0.5, 0.5)
    FixedCrosshairDot.Position = UDim2.fromScale(0.5, 0.5)
    FixedCrosshairDot.Size = UDim2.fromOffset(6, 6)
    FixedCrosshairDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FixedCrosshairDot.BorderSizePixel = 0
    FixedCrosshairDot.Parent = FixedCrosshairGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = FixedCrosshairDot
end

local function SetFixedCrosshair(enabled)
    EnsureFixedCrosshairDot()
    if FixedCrosshairGui then
        FixedCrosshairGui.Enabled = enabled == true
    end
end

local stretchConn = nil
local function ToggleStretchScreen(state)
    if state then
        if stretchConn then return end
        local cam = workspace.CurrentCamera
        stretchConn = RunService.RenderStepped:Connect(function()
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.65, 0, 0, 0, 1)
        end)
    else
        if stretchConn then
            stretchConn:Disconnect()
            stretchConn = nil
        end
    end
end

local HitboxHSOriginals = {}
local HitboxHSConnection = nil

local function FindHitboxPart(character)
    if not character or not character:IsA("Model") then return nil end
    return character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("HumanoidRootPart")
end

local function SetHitboxHS(player, enable)
    if player == LocalPlayer or IsFriend(player) then return end
    local char = player.Character
    if not char then return end
    local part = FindHitboxPart(char)
    if not part or not part:IsA("BasePart") then return end
    if enable then
        if not HitboxHSOriginals[part] then
            HitboxHSOriginals[part] = {
                Size = part.Size,
                Transparency = part.Transparency,
                Material = part.Material,
                Color = part.Color,
                CanCollide = part.CanCollide,
                Massless = part.Massless
            }
        end
        pcall(function()
            local size = tonumber(_G.Settings.Combat.HitboxHSSize) or 15
            part.Size = Vector3.new(size, size, size)
            part.Transparency = tonumber(_G.Settings.Combat.HitboxHSTransparency) or 0.65
            part.Material = Enum.Material.ForceField
            part.Color = ThemeColors.Accent
            part.CanCollide = false
            part.Massless = true
        end)
    elseif HitboxHSOriginals[part] then
        local original = HitboxHSOriginals[part]
        pcall(function()
            part.Size = original.Size
            part.Transparency = original.Transparency
            part.Material = original.Material
            part.Color = original.Color
            part.CanCollide = original.CanCollide
            part.Massless = original.Massless
        end)
        HitboxHSOriginals[part] = nil
    end
end

local function ResetAllHitboxHS()
    for part, original in pairs(HitboxHSOriginals) do
        if part and part.Parent then
            pcall(function()
                part.Size = original.Size
                part.Transparency = original.Transparency
                part.Material = original.Material
                part.Color = original.Color
                part.CanCollide = original.CanCollide
                part.Massless = original.Massless
            end)
        end
        HitboxHSOriginals[part] = nil
    end
end

local function UpdateHitboxHS(player)
    if _G.Settings.Combat.HitboxHSEnabled then
        SetHitboxHS(player, true)
    else
        SetHitboxHS(player, false)
    end
end

local function StartHitboxHSLoop()
    if HitboxHSConnection then return end
    HitboxHSConnection = RunService.Heartbeat:Connect(function()
        if not _G.Settings.Combat.HitboxHSEnabled then return end
        for _, player in ipairs(Players:GetPlayers()) do
            UpdateHitboxHS(player)
        end
    end)
end

local function FindPlayerByName(name)
    name = tostring(name or ""):lower()
    if name == "" then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        local playerName = player.Name:lower()
        local displayName = player.DisplayName:lower()
        if playerName == name or displayName == name or playerName:sub(1, #name) == name or displayName:sub(1, #name) == name then
            return player
        end
    end
    return nil
end

local function CopySkinFromName(name)
    name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then
        Notify("Copy Skin", "Digite o nome de um player.")
        return
    end
    local userId
    local onlinePlayer = FindPlayerByName(name)
    if onlinePlayer then
        userId = onlinePlayer.UserId
    else
        local ok, result = pcall(function()
            return Players:GetUserIdFromNameAsync(name)
        end)
        if ok then userId = result end
    end
    if not userId then
        Notify("Copy Skin", "Player nao encontrado no Roblox.")
        return
    end
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        Notify("Copy Skin", "Seu boneco ainda nao carregou.")
        return
    end
    local ok, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    if not ok or not desc then
        Notify("Copy Skin", "Nao deu para buscar a skin.")
        return
    end
    local applied, applyError = pcall(function()
        if humanoid.ApplyDescriptionReset then
            humanoid:ApplyDescriptionReset(desc)
        else
            humanoid:ApplyDescription(desc)
        end
    end)
    if not applied then
        Notify("Copy Skin", "Não foi possível aplicar: " .. tostring(applyError))
        return
    end
    Notify("Copy Skin", "Skin copiada com sucesso.")
end

local fakeDashEnabled = false
local DashDistance = 8
local DashCooldown = 0.25
local LastDashTime = 0
local dashLoop = nil

local fakeLagEnabled = false
local LagDistance = 15
local LagCooldown = 1.0
local LagDistanceVariacoes = {12, 15, 18}
local forceIndex = 1
local LastLagTime = 0
local lagLoop = nil

local function startDashLoop()
    if dashLoop then return end
    dashLoop = RunService.Heartbeat:Connect(function()
        if fakeDashEnabled and tick() - LastDashTime > DashCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hrp = char.HumanoidRootPart
                local hum = char.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    local dir = hrp.CFrame.LookVector
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {char}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = workspace:Raycast(hrp.Position, dir * DashDistance, rayParams)
                    if not rayResult then
                        hrp.CFrame = hrp.CFrame + dir * DashDistance
                    end
                    LastDashTime = tick()
                end
            end
        end
    end)
end

local function ToggleFakeDash(state)
    fakeDashEnabled = state
    _G.Settings.Combat.FakeDashEnabled = state
    if state then
        startDashLoop()
    elseif dashLoop then
        dashLoop:Disconnect()
        dashLoop = nil
    end
end

local function startLagLoop()
    if lagLoop then return end
    lagLoop = RunService.Heartbeat:Connect(function()
        if fakeLagEnabled and tick() - LastLagTime > LagCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hrp = char.HumanoidRootPart
                local hum = char.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    forceIndex = (forceIndex % #LagDistanceVariacoes) + 1
                    local dist = LagDistanceVariacoes[forceIndex]
                    local direction = hrp.CFrame.LookVector
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {char}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = workspace:Raycast(hrp.Position, direction * dist, rayParams)
                    if not rayResult or (rayResult and not rayResult.Instance.CanCollide) then
                        hrp.CFrame = hrp.CFrame + direction * dist
                    end
                    LastLagTime = tick()
                end
            end
        end
    end)
end

local function ToggleFakeLag(state)
    fakeLagEnabled = state
    _G.Settings.Combat.FakeLagEnabled = state
    if state then
        startLagLoop()
    elseif lagLoop then
        lagLoop:Disconnect()
        lagLoop = nil
    end
end

local _BindStates = {}
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.MouseButton2
    or input.UserInputType == Enum.UserInputType.MouseButton3 then
        _BindStates[input.UserInputType] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.MouseButton2
    or input.UserInputType == Enum.UserInputType.MouseButton3 then
        _BindStates[input.UserInputType] = false
    end
end)

local function loadFluxoBypass()
    pcall(function()
        local repStorage = game:GetService("ReplicatedStorage")
        for _, child in pairs(repStorage:GetChildren()) do
            if child:IsA("RemoteEvent") and child.Name == "iac-respond" then child:Destroy() end
        end
        repStorage.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") and child.Name == "iac-respond" then child:Destroy() end
        end)
        local originalProperties = {}
        local function spoofProperty(instance, property, value)
            if not instance then return end
            if not originalProperties[instance] then originalProperties[instance] = {} end
            if not originalProperties[instance][property] then
                originalProperties[instance][property] = instance[property]
            end
            instance[property] = value
        end
        local function overrideCam()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CameraType = Enum.CameraType.Scriptable
                task.wait(0.1)
                cam.CameraType = Enum.CameraType.Custom
            end
        end
        overrideCam()
        local function applySpoof()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    spoofProperty(humanoid, "WalkSpeed", humanoid.WalkSpeed)
                    spoofProperty(humanoid, "JumpPower", humanoid.JumpPower)
                end
            end
        end
        applySpoof()
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            applySpoof()
        end)
        print("[Bypass] Ativado para Fluxo PvP")
    end)
end

local spinEnabled = false
local spinAngle = 0
local spinConnection = nil
local SPIN_SPEED = 1440

local function toggleSpin(enable)
    spinEnabled = enable
    if spinEnabled then
        if not spinConnection then
            spinConnection = TrackConnection(RunService.RenderStepped:Connect(function(dt)
                if spinEnabled then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        spinAngle = spinAngle + math.rad(SPIN_SPEED * dt)
                        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, spinAngle, 0)
                    end
                end
            end))
        end
    else
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
    end
end

local infiniteAmmoEnabled = false
local infiniteAmmoConnection = nil

local function runInfiniteAmmo()
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, name in ipairs({"Ammo","Magazine","Bullets","CurrentAmmo","Clip","MaxAmmo","Stored","ReserveAmmo","Amount"}) do
                local prop = tool:FindFirstChild(name)
                if prop then prop.Value = 999 end
            end
        end
    end
end

local function toggleInfiniteAmmo(enable)
    infiniteAmmoEnabled = enable
    if enable then
        runInfiniteAmmo()
        if not infiniteAmmoConnection then
            infiniteAmmoConnection = TrackConnection(RunService.Heartbeat:Connect(runInfiniteAmmo))
        end
    else
        if infiniteAmmoConnection then
            infiniteAmmoConnection:Disconnect()
            infiniteAmmoConnection = nil
        end
    end
end

local speedHackEnabled = false
local speedHackBeganConn = nil
local speedHackEndedConn = nil

local function toggleSpeedHack(enable)
    speedHackEnabled = enable
    if enable then
        if not speedHackBeganConn then
            speedHackBeganConn = TrackConnection(UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if speedHackEnabled and input.KeyCode == Enum.KeyCode.LeftControl then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 36 end
                end
            end))
            speedHackEndedConn = TrackConnection(UserInputService.InputEnded:Connect(function(input)
                if speedHackEnabled and input.KeyCode == Enum.KeyCode.LeftControl then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
                end
            end))
        end
    else
        if speedHackBeganConn then speedHackBeganConn:Disconnect(); speedHackBeganConn = nil end
        if speedHackEndedConn then speedHackEndedConn:Disconnect(); speedHackEndedConn = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
    end
end

local purpleAmbientEnabled = false
local purpleAmbientConn = nil
local CUSTOM_AMBIENT_COLOR = Color3.fromRGB(180, 100, 255)

local function togglePurpleAmbient(enable)
    purpleAmbientEnabled = enable
    if enable then
        Lighting.Ambient = CUSTOM_AMBIENT_COLOR
        Lighting.OutdoorAmbient = CUSTOM_AMBIENT_COLOR
        Lighting.Brightness = 1.5
        if not purpleAmbientConn then
            purpleAmbientConn = TrackConnection(Lighting.Changed:Connect(function()
                if purpleAmbientEnabled then
                    Lighting.Ambient = CUSTOM_AMBIENT_COLOR
                    Lighting.OutdoorAmbient = CUSTOM_AMBIENT_COLOR
                end
            end))
        end
    else
        if purpleAmbientConn then purpleAmbientConn:Disconnect(); purpleAmbientConn = nil end
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
        Lighting.Brightness = 1
    end
end

-- FARM LIXEIRO
local FarmLixeiro = { Running = false, CycleToken = 0, SavedPos = nil, noclipAtivo = false, noclipConexao = nil, LastIndex = 0, setStatus = function(txt) end }
local PROMPT_BLOCKLIST_LIXO = {"sentar", "passageiro", "entrar", "sair", "dirigir", "motorista", "assento"}
local Lixos = {
    CFrame.new(3475.437012, 4.222155, 2276.931152) * CFrame.Angles(0, -0.828853, 0),
    CFrame.new(3415.006592, 4.215099, 2334.865234) * CFrame.Angles(0, 0.071366, 0),
    CFrame.new(3413.956543, 4.215099, 2497.440186) * CFrame.Angles(0, -3.134464, 0),
    CFrame.new(3407.579346, 4.215099, 2440.788818) * CFrame.Angles(0, 2.151735, 0),
}
function FarmLixeiro.isBlockedPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    local fields = {prompt.ActionText or "", prompt.ObjectText or "", prompt.Name or ""}
    for _, field in ipairs(fields) do
        local low = string.lower(field)
        for _, keyword in ipairs(PROMPT_BLOCKLIST_LIXO) do
            if string.find(low, keyword, 1, true) then return true end
        end
    end
    return false
end
function FarmLixeiro.setCollisions(collide)
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = collide end
        end
    end
end
function FarmLixeiro.ativarNoclip()
    if FarmLixeiro.noclipConexao then return end
    FarmLixeiro.noclipAtivo = true
    FarmLixeiro.noclipConexao = RunService.Stepped:Connect(function() FarmLixeiro.setCollisions(false) end)
end
function FarmLixeiro.desativarNoclip()
    if FarmLixeiro.noclipConexao then FarmLixeiro.noclipConexao:Disconnect(); FarmLixeiro.noclipConexao = nil end
    FarmLixeiro.noclipAtivo = false; FarmLixeiro.setCollisions(true)
end
function FarmLixeiro.getHRP() return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5) end
function FarmLixeiro.getHumanoid() return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid", 5) end
function FarmLixeiro.getNearbyPrompts()
    local hrp = FarmLixeiro.getHRP(); if not hrp then return {} end
    local list = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled and not FarmLixeiro.isBlockedPrompt(obj) then
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (parent.Position - hrp.Position).Magnitude
                if dist <= 22 then table.insert(list, {prompt = obj, dist = dist, part = parent}) end
            end
        end
    end
    table.sort(list, function(a, b) return a.dist < b.dist end); return list
end
function FarmLixeiro.walkTo(targetCF, myToken)
    local hum = FarmLixeiro.getHumanoid(); local hrp = FarmLixeiro.getHRP()
    if not hum or not hrp then return false end
    local targetPos = targetCF.Position
    hum:MoveTo(targetPos)
    local lastPos, stuckTime, t0 = hrp.Position, 0, time()
    while FarmLixeiro.Running and myToken == FarmLixeiro.CycleToken do
        if not hum.Parent or not hrp.Parent then return false end
        if (hrp.Position - targetPos).Magnitude <= 4 then hum:MoveTo(hrp.Position) return true end
        if (time() - t0) > 40 then hum:MoveTo(hrp.Position) return false end
        local flatDir = Vector3.new(targetPos.X - hrp.Position.X, 0, targetPos.Z - hrp.Position.Z)
        if flatDir.Magnitude > 0.1 then flatDir = flatDir.Unit end
        local moved = (hrp.Position - lastPos).Magnitude
        if moved < 0.4 then stuckTime = stuckTime + 0.1 else stuckTime = 0 end
        lastPos = hrp.Position
        if not FarmLixeiro.noclipAtivo and stuckTime > 1.5 then
            local right = Vector3.new(flatDir.Z, 0, -flatDir.X)
            hum:MoveTo(hrp.Position + right * 6)
            task.wait(0.7)
            if myToken ~= FarmLixeiro.CycleToken then return false end
            hum:MoveTo(targetPos)
            stuckTime = 0; lastPos = hrp.Position
        end
        task.wait(0.1)
    end
    hum:MoveTo(hrp.Position); return false
end
function FarmLixeiro.fireAndWait(description, myToken)
    local t0 = time()
    while FarmLixeiro.Running and myToken == FarmLixeiro.CycleToken do
        local prompts = FarmLixeiro.getNearbyPrompts()
        if #prompts == 0 then
            if (time() - t0) > 30 then FarmLixeiro.setStatus("Timeout: sem prompt"); return false end
            FarmLixeiro.setStatus("Aguardando " .. description .. "...")
            task.wait(0.3)
        else
            local target = prompts[1]
            pcall(function() fireproximityprompt(target.prompt) end)
            task.wait(0.4)
            local registered = false
            if not target.prompt.Parent or not target.prompt.Enabled then registered = true else
                local checkStart = time()
                while (time() - checkStart) < 5 do
                    if not target.prompt.Parent or not target.prompt.Enabled then registered = true break end
                    task.wait(0.2)
                end
            end
            if registered then return true end
            FarmLixeiro.setStatus("Aguardando " .. description .. "...")
            task.wait(0.8)
        end
    end
    return false
end
function FarmLixeiro.fireOnce(description, myToken)
    local prompts = FarmLixeiro.getNearbyPrompts()
    if #prompts == 0 then FarmLixeiro.setStatus("Sem prompt de " .. description); return false end
    pcall(function() fireproximityprompt(prompts[1].prompt) end)
    task.wait(1)
    return true
end
function FarmLixeiro.startFarm()
    if FarmLixeiro.Running then return end
    if not FarmLixeiro.SavedPos then FarmLixeiro.setStatus("Salve a posição primeiro!") return end
    FarmLixeiro.Running = true; FarmLixeiro.CycleToken = FarmLixeiro.CycleToken + 1
    local myToken = FarmLixeiro.CycleToken
    pcall(function() _G.SpeedController.SetEnabled(true) end)
    FarmLixeiro.ativarNoclip()
    task.spawn(function()
        while FarmLixeiro.Running and myToken == FarmLixeiro.CycleToken do
            local idx
            repeat idx = math.random(1, #Lixos) until idx ~= FarmLixeiro.LastIndex
            FarmLixeiro.LastIndex = idx
            FarmLixeiro.setStatus("Indo pro lixo " .. idx); FarmLixeiro.walkTo(Lixos[idx], myToken)
            if myToken ~= FarmLixeiro.CycleToken then break end
            FarmLixeiro.setStatus("Coletando lixo " .. idx); FarmLixeiro.fireAndWait("coleta", myToken)
            if myToken ~= FarmLixeiro.CycleToken then break end
            task.wait(0.5)
            FarmLixeiro.setStatus("Voltando pra entrega"); FarmLixeiro.walkTo(FarmLixeiro.SavedPos, myToken)
            if myToken ~= FarmLixeiro.CycleToken then break end
            FarmLixeiro.setStatus("Entregando..."); FarmLixeiro.fireOnce("entrega", myToken)
            if myToken ~= FarmLixeiro.CycleToken then break end
            FarmLixeiro.setStatus("Aguardando 3s..."); task.wait(3)
        end
        pcall(function() _G.SpeedController.SetEnabled(false) end)
        FarmLixeiro.desativarNoclip()
        FarmLixeiro.setStatus("Parado")
    end)
end
function FarmLixeiro.stopFarm()
    FarmLixeiro.Running = false; FarmLixeiro.CycleToken = FarmLixeiro.CycleToken + 1
    local hum = FarmLixeiro.getHumanoid(); local hrp = FarmLixeiro.getHRP()
    if hum and hrp then hum:MoveTo(hrp.Position) end
    pcall(function() _G.SpeedController.SetEnabled(false) end)
    FarmLixeiro.desativarNoclip(); FarmLixeiro.setStatus("Parado")
end

-- FARM PIZZA
local FarmPizza = { Running = false, CycleToken = 0, LastOrder = nil, OrderArrived = false, noclipAtivo = false, noclipConexao = nil, speedConn = nil, antiSitConn = nil, setStatus = function(txt) end }
local EntregadorFold = ReplicatedStorage:FindFirstChild("EntregadorFold")
local Order = EntregadorFold and EntregadorFold:FindFirstChild("Order")
local RewardPizza = EntregadorFold and EntregadorFold:FindFirstChild("RewardPizza")
function FarmPizza.forcarLevantar(hum)
    if not hum or not hum.Parent then return end
    pcall(function()
        if hum.Sit then hum.Sit = false end
        if hum:GetState() == Enum.HumanoidStateType.Sitting then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end)
end
function FarmPizza.iniciarAntiSit()
    if FarmPizza.antiSitConn then return end
    FarmPizza.antiSitConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Sit then FarmPizza.forcarLevantar(hum) end
    end)
end
function FarmPizza.pararAntiSit() if FarmPizza.antiSitConn then FarmPizza.antiSitConn:Disconnect(); FarmPizza.antiSitConn = nil end end
function FarmPizza.setCollisions(collide)
    if LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = collide end
        end
    end
end
function FarmPizza.ativarNoclip()
    if FarmPizza.noclipConexao then return end
    FarmPizza.noclipAtivo = true; FarmPizza.noclipConexao = RunService.Stepped:Connect(function() FarmPizza.setCollisions(false) end)
end
function FarmPizza.desativarNoclip()
    if FarmPizza.noclipConexao then FarmPizza.noclipConexao:Disconnect(); FarmPizza.noclipConexao = nil end
    FarmPizza.noclipAtivo = false; FarmPizza.setCollisions(true)
end
function FarmPizza.ativarSpeed()
    if FarmPizza.speedConn then return end
    FarmPizza.speedConn = RunService.Heartbeat:Connect(function()
        if not FarmPizza.Running then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= 70 then pcall(function() hum.WalkSpeed = 70 end) end
    end)
end
function FarmPizza.desativarSpeed()
    if FarmPizza.speedConn then FarmPizza.speedConn:Disconnect(); FarmPizza.speedConn = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum.WalkSpeed = 16 end) end
end
function FarmPizza.hasPizza()
    local char = LocalPlayer.Character; if char and char:FindFirstChild("PizzaTemplate") then return true end
    local bp = LocalPlayer:FindFirstChild("Backpack"); if bp and bp:FindFirstChild("PizzaTemplate") then return true end
    return false
end
function FarmPizza.getHRP() return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5) end
function FarmPizza.getHum() return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid", 5) end
function FarmPizza.goTo(targetPos, myToken)
    local hum = FarmPizza.getHum(); local hrp = FarmPizza.getHRP()
    if not hum or not hrp then return false end
    for attempt = 1, 5 do
        hum:MoveTo(targetPos); local t0, arrived = time(), false
        while FarmPizza.Running and myToken == FarmPizza.CycleToken do
            if (hrp.Position - targetPos).Magnitude <= 4 then arrived = true break end
            if (time() - t0) > 25 then break end
            hum:MoveTo(targetPos); task.wait(0.1)
        end
        if arrived then hum:MoveTo(hrp.Position) return true end
        task.wait(0.3)
    end
    return false
end
if Order then
    Order.OnClientEvent:Connect(function(p5)
        if type(p5) ~= "table" then return end
        local localPart = p5.Local
        FarmPizza.LastOrder = { Npc = p5.Npc, Local = localPart, Timestamp = time(), WaypointPos = nil }
        FarmPizza.OrderArrived = true
        task.spawn(function()
            local t0 = time()
            while time() - t0 < 4 do
                local arr = _G.sendMarcarPadrao
                if type(arr) == "table" and #arr > 0 then
                    local last = arr[#arr]
                    if type(last) == "table" and last[1] and last[1].Position then
                        FarmPizza.LastOrder.WaypointPos = last[1].Position; return
                    end
                end
                task.wait(0.1)
            end
            if localPart and localPart:IsA("BasePart") then FarmPizza.LastOrder.WaypointPos = localPart.Position + Vector3.new(0, 3, 0) end
        end)
    end)
end
function FarmPizza.startFarm()
    if FarmPizza.Running then return end
    if not Order or not RewardPizza then FarmPizza.setStatus("Erro: Remotes do Pizza não encontrados") return end
    FarmPizza.Running = true; FarmPizza.CycleToken = FarmPizza.CycleToken + 1
    local myToken = FarmPizza.CycleToken
    FarmPizza.ativarNoclip(); FarmPizza.ativarSpeed(); FarmPizza.iniciarAntiSit()
    pcall(function() _G.SpeedController.SetEnabled(true) end)
    task.spawn(function()
        while FarmPizza.Running and myToken == FarmPizza.CycleToken do
            if not FarmPizza.hasPizza() then FarmPizza.setStatus("Procurando pizza..."); task.wait(2) end
            FarmPizza.setStatus("Aguardando pedido...")
            local waitStart = time()
            while FarmPizza.Running and myToken == FarmPizza.CycleToken and not FarmPizza.OrderArrived do
                if (time() - waitStart) > 60 then break end
                task.wait(0.3)
            end
            if myToken ~= FarmPizza.CycleToken then break end
            if FarmPizza.OrderArrived and FarmPizza.LastOrder then
                FarmPizza.OrderArrived = false; FarmPizza.setStatus("Entregando pizza...")
                if FarmPizza.LastOrder.WaypointPos then
                    FarmPizza.goTo(FarmPizza.LastOrder.WaypointPos, myToken)
                    pcall(function() RewardPizza:InvokeServer() end)
                    FarmPizza.setStatus("Entregue!")
                end
            end
            task.wait(1)
        end
        FarmPizza.stopFarm()
    end)
end
function FarmPizza.stopFarm()
    FarmPizza.Running = false; FarmPizza.CycleToken = FarmPizza.CycleToken + 1
    local hum = FarmPizza.getHum(); local hrp = FarmPizza.getHRP()
    if hum and hrp then hum:MoveTo(hrp.Position) end
    pcall(function() _G.SpeedController.SetEnabled(false) end)
    FarmPizza.pararAntiSit(); FarmPizza.desativarSpeed(); FarmPizza.desativarNoclip()
    FarmPizza.setStatus("Parado")
end

-- AUTOFARM PRISÃO
local FarmPrisao = { Running = false, CicloAtual = 0, setStatus = function(txt) end }
local FarmPrisaoCFG = {
    PONTO_A = Vector3.new(3893.7625, 65.4211, 4064.9290),
    PONTO_B = Vector3.new(3802.4011, 65.4211, 4119.1519),
    WALK_SPEED = 60, WALK_SPEED_PARADO = 16, RAMP_TIME = 0.3,
    ARRIVE_DIST = 7, MOVE_REISSUE = 0.1, STUCK_TIME = 1.5,
    STUCK_DIST = 2.0, STUCK_MAX = 2, SEG_TIMEOUT = 25,
    SEG_MARGEM = 1.5, SEG_FOLGA = 5, PARAR_TIMEOUT = 1.5,
    PARAR_VEL_MAX = 2, PROMPT_RAIO = 30, PROMPT_TIMEOUT = 6,
    WAIT_APOS_PROMPT = 1, PAUSA_ENTRE_CICLOS = 0.3, FALL_VEL_THRESHOLD = -25,
}
function FarmPrisao.pegarRefs()
    local char = LocalPlayer.Character
    if not char or not char.Parent then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return nil end
    return hum, hrp, char
end
function FarmPrisao.pararPersonagem(hum, hrp)
    if not hum or not hrp then return end
    pcall(function() hum:MoveTo(hrp.Position) end)
    pcall(function() hum.WalkSpeed = 0 end)
    local deadline = tick() + FarmPrisaoCFG.PARAR_TIMEOUT
    while tick() < deadline do
        local _, h2 = FarmPrisao.pegarRefs()
        if not h2 then break end
        if h2.AssemblyLinearVelocity.Magnitude < FarmPrisaoCFG.PARAR_VEL_MAX then break end
        task.wait(0.05)
    end
    pcall(function() hum.WalkSpeed = FarmPrisaoCFG.WALK_SPEED_PARADO end)
end
function FarmPrisao.navegarAte(hum, char, destino, deadline)
    local ultimaPos, ultimoCheck, ultimoMoveTo, tentativas = nil, tick(), 0, 0
    while tick() < deadline do
        local h2, hrp2, c2 = FarmPrisao.pegarRefs()
        if not h2 or c2 ~= char then return "changed" end
        if hrp2.AssemblyLinearVelocity.Y < FarmPrisaoCFG.FALL_VEL_THRESHOLD then return "falling" end
        local dist = (hrp2.Position - destino).Magnitude
        if dist <= FarmPrisaoCFG.ARRIVE_DIST then
            pcall(function() h2:MoveTo(hrp2.Position) end)
            pcall(function() h2.WalkSpeed = FarmPrisaoCFG.WALK_SPEED_PARADO end)
            task.wait(0.15)
            return "arrived"
        end
        local agora = tick()
        if agora - ultimoCheck >= FarmPrisaoCFG.STUCK_TIME then
            if ultimaPos and (hrp2.Position - ultimaPos).Magnitude < FarmPrisaoCFG.STUCK_DIST then
                tentativas = tentativas + 1
                if tentativas >= FarmPrisaoCFG.STUCK_MAX then return "stuck" end
                pcall(function() h2.Jump = true end)
                task.wait(0.3)
            else
                tentativas = 0
            end
            ultimaPos = hrp2.Position
            ultimoCheck = agora
        end
        if agora - ultimoMoveTo >= FarmPrisaoCFG.MOVE_REISSUE then
            pcall(function() h2:MoveTo(destino) end)
            ultimoMoveTo = agora
        end
        task.wait(0.03)
    end
    return "timeout"
end
local function rampSpeedLocal(hum, de, para, duracao, tokenCheck)
    if not hum or not hum.Parent then return false end
    if not duracao or duracao <= 0 then return pcall(function() hum.WalkSpeed = para end) end
    local t0 = tick()
    while true do
        if tokenCheck and not tokenCheck() then return false end
        if not hum or not hum.Parent then return false end
        local alpha = (tick() - t0) / duracao
        if alpha >= 1 then return pcall(function() hum.WalkSpeed = para end) end
        local a = alpha * alpha * (3 - 2 * alpha)
        pcall(function() hum.WalkSpeed = de + (para - de) * a end)
        task.wait(0.03)
    end
end
function FarmPrisao.irPara(ponto, nome)
    local hum, hrp, char = FarmPrisao.pegarRefs()
    if not hum or not hrp then return false end
    local dist = (hrp.Position - ponto).Magnitude
    FarmPrisao.setStatus("Indo " .. nome .. " (" .. math.floor(dist) .. " studs)")
    if dist <= FarmPrisaoCFG.ARRIVE_DIST then
        FarmPrisao.pararPersonagem(hum, hrp)
        return true
    end
    local originalSpeed = hum.WalkSpeed
    local tokenCheck = function()
        local _, _, c = FarmPrisao.pegarRefs()
        return c == char and FarmPrisao.Running
    end
    if not rampSpeedLocal(hum, originalSpeed, FarmPrisaoCFG.WALK_SPEED, FarmPrisaoCFG.RAMP_TIME, tokenCheck) then
        pcall(function() hum.WalkSpeed = originalSpeed end)
        return false
    end
    local tempoEstimado = (dist / FarmPrisaoCFG.WALK_SPEED) * FarmPrisaoCFG.SEG_MARGEM + FarmPrisaoCFG.SEG_FOLGA
    local deadline = tick() + math.max(FarmPrisaoCFG.SEG_TIMEOUT, tempoEstimado)
    local r = FarmPrisao.navegarAte(hum, char, ponto, deadline)
    local h3, hrp3, c3 = FarmPrisao.pegarRefs()
    if h3 and hrp3 and c3 == char then
        FarmPrisao.pararPersonagem(h3, hrp3)
        task.wait(0.2)
        pcall(function() h3.WalkSpeed = originalSpeed end)
    end
    return r == "arrived"
end
function FarmPrisao.encontrarPromptsPerto(pos, raio)
    local encontrados = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent then
            local posP = nil
            local pai = obj.Parent
            if pai:IsA("BasePart") then posP = pai.Position
            elseif pai:IsA("Attachment") then posP = pai.WorldPosition end
            if posP then
                local d = (pos - posP).Magnitude
                if d <= raio then
                    table.insert(encontrados, {tipo = "prompt", obj = obj, dist = d, nome = obj.Name, enabled = obj.Enabled})
                end
            end
        elseif obj:IsA("ClickDetector") and obj.Parent then
            local pai = obj.Parent
            if pai:IsA("BasePart") then
                local d = (pos - pai.Position).Magnitude
                if d <= raio then
                    table.insert(encontrados, {tipo = "click", obj = obj, dist = d, nome = obj.Name, enabled = true})
                end
            end
        end
    end
    table.sort(encontrados, function(a, b) return a.dist < b.dist end)
    return encontrados
end
function FarmPrisao.ativarPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    if type(fireproximityprompt) == "function" then
        local ok = pcall(fireproximityprompt, prompt)
        if ok then return true end
    end
    local holdOrig = prompt.HoldDuration
    pcall(function() prompt.HoldDuration = 0 end)
    local triggered = false
    local conn = prompt.Triggered:Connect(function() triggered = true end)
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.05)
        prompt:InputHoldEnd()
    end)
    local deadline = tick() + FarmPrisaoCFG.PROMPT_TIMEOUT
    while not triggered and tick() < deadline do task.wait(0.1) end
    if conn and conn.Connected then conn:Disconnect() end
    pcall(function() prompt.HoldDuration = holdOrig end)
    return triggered
end
function FarmPrisao.tentarAutoPrompt()
    local _, hrp = FarmPrisao.pegarRefs()
    if not hrp then return false end
    local lista = FarmPrisao.encontrarPromptsPerto(hrp.Position, FarmPrisaoCFG.PROMPT_RAIO)
    if #lista == 0 then return false end
    for i = 1, math.min(3, #lista) do
        local alvo = lista[i]
        if alvo.tipo == "prompt" then
            if not alvo.obj.Enabled then pcall(function() alvo.obj.Enabled = true end) end
            local ok = FarmPrisao.ativarPrompt(alvo.obj)
            if ok then return true end
        elseif alvo.tipo == "click" then
            if type(fireclickdetector) == "function" then
                pcall(fireclickdetector, alvo.obj)
                return true
            end
        end
        task.wait(0.15)
    end
    return false
end
function FarmPrisao.loopFarm()
    while FarmPrisao.Running do
        FarmPrisao.CicloAtual = FarmPrisao.CicloAtual + 1
        FarmPrisao.setStatus("Ciclo " .. FarmPrisao.CicloAtual .. " - indo A")
        local okA = FarmPrisao.irPara(FarmPrisaoCFG.PONTO_A, "Ponto A")
        if okA then
            FarmPrisao.setStatus("Ciclo " .. FarmPrisao.CicloAtual .. " - prompt A")
            FarmPrisao.tentarAutoPrompt()
        end
        if not FarmPrisao.Running then break end
        task.wait(FarmPrisaoCFG.WAIT_APOS_PROMPT)
        FarmPrisao.setStatus("Ciclo " .. FarmPrisao.CicloAtual .. " - indo B")
        local okB = FarmPrisao.irPara(FarmPrisaoCFG.PONTO_B, "Ponto B")
        if okB then
            FarmPrisao.setStatus("Ciclo " .. FarmPrisao.CicloAtual .. " - prompt B")
            FarmPrisao.tentarAutoPrompt()
        end
        if not FarmPrisao.Running then break end
        task.wait(FarmPrisaoCFG.PAUSA_ENTRE_CICLOS)
    end
    FarmPrisao.setStatus("Parado")
end
function FarmPrisao.startFarm()
    if FarmPrisao.Running then return end
    FarmPrisao.Running = true
    FarmPrisao.CicloAtual = 0
    pcall(function() _G.SpeedController.SetEnabled(true) end)
    FarmPrisao.setStatus("Iniciando...")
    task.spawn(FarmPrisao.loopFarm)
end
function FarmPrisao.stopFarm()
    FarmPrisao.Running = false
    local hum = FarmPrisao.pegarRefs()
    if hum then pcall(function() hum:MoveTo(hum.Parent.HumanoidRootPart.Position) end) end
    pcall(function() _G.SpeedController.SetEnabled(false) end)
    FarmPrisao.setStatus("Parado")
end

-- ANTI FALL DAMAGE
local AntiFall = { Connection = nil, Enabled = false, MAX_FALL_SPEED = -40 }
function AntiFall.Toggle(state)
    AntiFall.Enabled = state
    if state then
        if not AntiFall.Connection then
            AntiFall.Connection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Velocity.Y < AntiFall.MAX_FALL_SPEED then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, AntiFall.MAX_FALL_SPEED, hrp.Velocity.Z)
                    end
                end
            end)
        end
    else
        if AntiFall.Connection then AntiFall.Connection:Disconnect(); AntiFall.Connection = nil end
    end
end

-- NOCLIP GLOBAL
local NoclipGlobal = { Enabled = false, Connection = nil }
local function setCollisionsGlobal(collide)
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = collide end
        end
    end
end
function NoclipGlobal.Toggle(state)
    NoclipGlobal.Enabled = state
    if state then
        if NoclipGlobal.Connection then NoclipGlobal.Connection:Disconnect() end
        NoclipGlobal.Connection = RunService.RenderStepped:Connect(function()
            setCollisionsGlobal(false)
        end)
    else
        if NoclipGlobal.Connection then
            NoclipGlobal.Connection:Disconnect()
            NoclipGlobal.Connection = nil
        end
        setCollisionsGlobal(true)
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    if NoclipGlobal.Enabled then
        task.wait(0.2)
        setCollisionsGlobal(false)
    end
end)

-- JUMP POWER
local JumpPower = {
    Current = 50, Min = 50, Max = 350, Step = 5, HeightConv = 0.25,
    EnforcePower = false, Conn = nil, OriginalPower = nil, OriginalHeight = nil,
}
local function getJumpHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end
local function captureOriginals(hum)
    if not hum then return end
    if hum.UseJumpPower then
        JumpPower.OriginalPower = hum.JumpPower
        JumpPower.OriginalHeight = nil
    else
        JumpPower.OriginalHeight = hum.JumpHeight
        JumpPower.OriginalPower = nil
    end
end
local function restoreOriginal()
    local hum = getJumpHumanoid()
    if not hum then return end
    if hum.UseJumpPower and JumpPower.OriginalPower then
        pcall(function() hum.JumpPower = JumpPower.OriginalPower end)
    elseif JumpPower.OriginalHeight then
        pcall(function() hum.JumpHeight = JumpPower.OriginalHeight end)
    end
end
local function applyJumpPower()
    local hum = getJumpHumanoid()
    if not hum then return end
    if hum.UseJumpPower then
        pcall(function() hum.JumpPower = JumpPower.Current end)
    else
        pcall(function() hum.JumpHeight = JumpPower.Current * JumpPower.HeightConv end)
    end
end
function JumpPower.Set(value)
    local stepped = math.floor((value - JumpPower.Min) / JumpPower.Step + 0.5) * JumpPower.Step + JumpPower.Min
    stepped = math.clamp(stepped, JumpPower.Min, JumpPower.Max)
    JumpPower.Current = stepped
    applyJumpPower()
end
local function setupJumpEnforce()
    local hum = getJumpHumanoid()
    if not hum then return end
    if JumpPower.Conn then JumpPower.Conn:Disconnect() end
    JumpPower.Conn = hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if JumpPower.EnforcePower and hum.UseJumpPower and hum.JumpPower ~= JumpPower.Current then
            applyJumpPower()
        end
    end)
end
function JumpPower.SetEnforce(state)
    JumpPower.EnforcePower = state
    if state then
        setupJumpEnforce()
        applyJumpPower()
    else
        if JumpPower.Conn then JumpPower.Conn:Disconnect(); JumpPower.Conn = nil end
        restoreOriginal()
    end
end
task.spawn(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:WaitForChild("Humanoid", 5)
        if hum then captureOriginals(hum) end
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    task.wait(0.5)
    captureOriginals(hum)
    if JumpPower.EnforcePower then
        applyJumpPower()
        setupJumpEnforce()
    end
end)

-- WEAPONS MODS
local WeaponsMod = { NoRecoil = false, ZeroSpread = false, InfAmmo = false, Initialized = false }

task.spawn(function()
    local function acquire(path, timeout)
        local node = ReplicatedStorage
        for _, part in ipairs(path) do
            node = node:WaitForChild(part, timeout or 30)
            if not node then return nil end
        end
        return node
    end
    local function safeRequire(parent, name)
        local mod = parent:FindFirstChild(name) or parent:WaitForChild(name, 10)
        if not mod then return nil end
        local ok, res = pcall(require, mod)
        if not ok then return nil end
        return res
    end
    local WeaponsSystemFolder = acquire({"WeaponsSystem"}, 60)
    if not WeaponsSystemFolder then return end
    local Libraries = acquire({"WeaponsSystem", "Libraries"}, 30)
    local RobloxLib = safeRequire(Libraries, "Roblox")
    local BaseWeapon = safeRequire(Libraries, "BaseWeapon")
    local WSModule = safeRequire(WeaponsSystemFolder, "WeaponsSystem")
    if not (RobloxLib and BaseWeapon) then return end
    local originals, installed = {}, {}
    local function install(name, obj, key, replacement)
        if not obj then return end
        if originals[name] == nil then originals[name] = obj[key] end
        obj[key] = replacement
        installed[name] = { obj = obj, key = key, replacement = replacement }
    end
    local function reinstall(name)
        local entry = installed[name]
        if not entry then return end
        entry.obj[entry.key] = entry.replacement
    end
    if RobloxLib.applySpread then
        local origApplySpread = RobloxLib.applySpread
        install("applySpread", RobloxLib, "applySpread",
            function(dir, rnd, minS, maxS)
                if not WeaponsMod.ZeroSpread then return origApplySpread(dir, rnd, minS, maxS) end
                return dir
            end)
    end
    if BaseWeapon.getConfigValue then
        local origGetConfig = BaseWeapon.getConfigValue
        install("getConfigValue", BaseWeapon, "getConfigValue",
            function(self, name, default)
                if WeaponsMod.ZeroSpread and (name == "MinSpread" or name == "MaxSpread") then return 0 end
                if WeaponsMod.NoRecoil and name:find("Recoil") then return 0 end
                return origGetConfig(self, name, default)
            end)
    end
    local AMMO_FILL = 999
    local function grabAmmo(self)
        if self and self.ammoInWeaponValue and self.ammoInWeaponValue.Parent then
            return self.ammoInWeaponValue
        end
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local ammo = tool:FindFirstChild("CurrentAmmo")
                if ammo and ammo:IsA("NumberValue") then return ammo end
            end
        end
        return nil
    end
    RunService.RenderStepped:Connect(function()
        if not WeaponsMod.InfAmmo then return end
        local ammo = grabAmmo(nil)
        if ammo and ammo.Value ~= AMMO_FILL then
            pcall(function() ammo.Value = AMMO_FILL end)
        end
    end)
    if BaseWeapon.fire then
        local origFire = BaseWeapon.fire
        install("fire", BaseWeapon, "fire", function(self, ...)
            if not WeaponsMod.InfAmmo then return origFire(self, ...) end
            local ammo = grabAmmo(self)
            if ammo then pcall(function() ammo.Value = AMMO_FILL end) end
            local ret = origFire(self, ...)
            ammo = grabAmmo(self)
            if ammo then pcall(function() ammo.Value = AMMO_FILL end) end
            return ret
        end)
    end
    if BaseWeapon.useAmmo then
        local origUseAmmo = BaseWeapon.useAmmo
        install("useAmmo", BaseWeapon, "useAmmo", function(self, count)
            if not WeaponsMod.InfAmmo then return origUseAmmo(self, count) end
            return count
        end)
    end
    if BaseWeapon.getAmmoInWeapon then
        local origGetAmmoInWeapon = BaseWeapon.getAmmoInWeapon
        install("getAmmoInWeapon", BaseWeapon, "getAmmoInWeapon", function(self)
            if not WeaponsMod.InfAmmo then return origGetAmmoInWeapon(self) end
            return AMMO_FILL
        end)
    end
    if BaseWeapon.reload then
        local origReload = BaseWeapon.reload
        install("reload", BaseWeapon, "reload", function(self, ...)
            if not WeaponsMod.InfAmmo then return origReload(self, ...) end
            return false
        end)
    end
    if BaseWeapon.getAmmoInInventory then
        local origGetAmmoInInventory = BaseWeapon.getAmmoInInventory
        install("getAmmoInInventory", BaseWeapon, "getAmmoInInventory", function(self)
            if not WeaponsMod.InfAmmo then return origGetAmmoInInventory(self) end
            return AMMO_FILL
        end)
    end
    if WSModule then
        task.spawn(function()
            while task.wait(3) do
                if WeaponsMod.InfAmmo then
                    local char = LocalPlayer.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            local remote = WSModule.getRemoteEvent and WSModule.getRemoteEvent("WeaponReloadRequest")
                            if remote then pcall(function() remote:FireServer(tool) end) end
                        end
                    end
                end
            end
        end)
    end
    task.spawn(function()
        while task.wait(2) do
            if WeaponsMod.NoRecoil or WeaponsMod.ZeroSpread or WeaponsMod.InfAmmo then
                for name, entry in pairs(installed) do
                    if entry.obj[entry.key] ~= entry.replacement then reinstall(name) end
                end
            end
        end
    end)
    WeaponsMod.Initialized = true
end)

-- SILENT AIM
local SilentAim = {
    Enabled = false, FOVRadius = 150, TeamCheck = false, WallCheck = true,
    TargetPart = nil, oldNamecall = nil, HookInstalled = false,
    FOVGui = nil, FOVFrame = nil, FOVStroke = nil, CameraCFrame = nil,
}

do
    SilentAim.FOVGui = Instance.new("ScreenGui")
    SilentAim.FOVGui.Name = "SilentAimFOV"
    SilentAim.FOVGui.IgnoreGuiInset = true
    SilentAim.FOVGui.ResetOnSpawn = false
    pcall(function() SilentAim.FOVGui.Parent = CoreGui end)
    if not SilentAim.FOVGui.Parent then SilentAim.FOVGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    SilentAim.FOVFrame = Instance.new("Frame", SilentAim.FOVGui)
    SilentAim.FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SilentAim.FOVFrame.BackgroundTransparency = 1
    SilentAim.FOVFrame.Visible = false
    Instance.new("UICorner", SilentAim.FOVFrame).CornerRadius = UDim.new(1, 0)
    SilentAim.FOVStroke = Instance.new("UIStroke", SilentAim.FOVFrame)
    SilentAim.FOVStroke.Color = Color3.fromRGB(255, 50, 50)
    SilentAim.FOVStroke.Thickness = 2
    SilentAim.FOVStroke.Transparency = 0.2
end

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = true

local function hasLineOfSight(targetChar, targetPos)
    if not SilentAim.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    RayParams.FilterDescendantsInstances = {char, targetChar}
    local origin = SilentAim.CameraCFrame and SilentAim.CameraCFrame.Position or Workspace.CurrentCamera.CFrame.Position
    local direction = targetPos - origin
    local raycastResult = Workspace:Raycast(origin, direction, RayParams)
    return raycastResult == nil
end

local function getClosestTarget()
    local Camera = Workspace.CurrentCamera
    if not Camera then return nil end
    local bestTarget = nil
    local shortestDistance = SilentAim.FOVRadius
    local viewportSize = Camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if SilentAim.TeamCheck and player.Team and player.Team == LocalPlayer.Team then
                else
                    local targetPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                            local distance = (screenVector - center).Magnitude
                            if distance <= shortestDistance then
                                if hasLineOfSight(char, targetPart.Position) then
                                    shortestDistance = distance
                                    bestTarget = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.RenderStepped:Connect(function()
    local Camera = Workspace.CurrentCamera
    if not Camera then return end
    SilentAim.CameraCFrame = Camera.CFrame
    if SilentAim.Enabled then
        local viewportSize = Camera.ViewportSize
        local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        SilentAim.FOVFrame.Position = UDim2.new(0, center.X, 0, center.Y)
        SilentAim.FOVFrame.Size = UDim2.new(0, SilentAim.FOVRadius * 2, 0, SilentAim.FOVRadius * 2)
        SilentAim.FOVFrame.Visible = true
        SilentAim.TargetPart = getClosestTarget()
        if SilentAim.TargetPart then
            SilentAim.FOVStroke.Color = Color3.fromRGB(50, 255, 50)
        else
            SilentAim.FOVStroke.Color = Color3.fromRGB(255, 50, 50)
        end
    else
        SilentAim.FOVFrame.Visible = false
        SilentAim.TargetPart = nil
    end
end)

local function instalarSilentAimHook()
    if SilentAim.HookInstalled then return end
    if type(hookmetamethod) ~= "function" then return end

    SilentAim.oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if SilentAim.Enabled and SilentAim.TargetPart and not checkcaller() then
            if self == Workspace and method == "FindPartOnRayWithIgnoreList" then
                local args = {...}
                local ray = args[1]
                if typeof(ray) == "Ray" then
                    if ray.Direction.Magnitude > 100 then
                        local origin = ray.Origin
                        args[1] = Ray.new(origin, (SilentAim.TargetPart.Position - origin).Unit * 5000)
                        return SilentAim.oldNamecall(self, table.unpack(args))
                    end
                end
            end
        end
        return SilentAim.oldNamecall(self, ...)
    end))
    SilentAim.HookInstalled = true
end

instalarSilentAimHook()

loadFluxoBypass()

local NebulaIcons
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
    end)
    if ok and type(result) == "table" then
        NebulaIcons = result
    else
        NebulaIcons = {GetIcon = function(self, name, lib) return nil end}
    end
end
local Window = Library:CreateWindow("Zeus Internal", Enum.KeyCode.Delete)

local CombatTab    = Window:AddTab("Combate",   NebulaIcons:GetIcon("crosshair", "Lucide"))
local HitboxTab    = CombatTab
local VisualTab    = Window:AddTab("ESP",        NebulaIcons:GetIcon("visibility", "Material"))
local WorldTab     = Window:AddTab("Mundo",     NebulaIcons:GetIcon("public", "Material"))
local MovementTab  = Window:AddTab("Movimento", NebulaIcons:GetIcon("circle-gauge", "Lucide"))
local MiscTab      = Window:AddTab("Extra",     NebulaIcons:GetIcon("circle-star", "Lucide"))
local BloqueioTab  = Window:AddTab("Proteção",  NebulaIcons:GetIcon("gavel", "Material"))
local InfoTab      = Window:AddTab("Info",      NebulaIcons:GetIcon("info", "Material"))
local ArmasTab     = Window:AddTab("Armas",     NebulaIcons:GetIcon("sword", "Lucide"))
local FarmTab      = Window:AddTab("Farm",      NebulaIcons:GetIcon("coins", "Lucide"))
local ConfigTab    = Window:AddTab("Config",    NebulaIcons:GetIcon("settings", "Material"))

local GeneralSection = CombatTab:AddSection("Aimbot")
GeneralSection:AddToggle("Enabled", _G.Settings.Combat.Enabled, "AimbotEnabled", function(Value)
    aimbotSettings.Enabled = Value
    _G.Settings.Combat.Enabled = Value
    Library:Notify("Aimbot", Value and "Ativado ✓" or "Desativado ✗", 2, Value and "Success" or "Error")
end)
GeneralSection:AddSlider("FOV", 20, 300, 120, "FOVRadius", function(Value)
    aimbotSettings.FOV = Value
    _G.Settings.Combat.FOV = Value
    if DrawingCircle then DrawingCircle.Radius = Value end
end)
GeneralSection:AddToggle("Show FOV", true, "ShowFOV", function(Value)
    aimbotSettings.ShowFOV = Value
    _G.Settings.Combat.ShowFOV = Value
    if DrawingCircle then DrawingCircle.Visible = Value end
end)
GeneralSection:AddSlider("Smoothness", 1, 100, 40, "Smoothness", function(Value)
    aimbotSettings.Smoothness = Value / 100
    _G.Settings.Combat.Smoothness = Value / 100
end)
GeneralSection:AddSlider("Max Distance", 25, 450, 125, "MaxDistance", function(Value)
    aimbotSettings.MaxDistance = Value
    _G.Settings.Combat.MaxDistance = Value
end)

local ChecksSection = CombatTab:AddSection("Filtros")
ChecksSection:AddToggle("Team Check", _G.Settings.Combat.TeamCheck, "TeamCheck", function(Value)
    _G.Settings.Combat.TeamCheck = Value
end)
ChecksSection:AddToggle("Ignore Aliado de fac", _G.Settings.Combat.OrgCheck, "IgnoreSameOrgToggle", function(Value)
    _G.Settings.Combat.OrgCheck = Value
    Library:Notify("Filtro Org", Value and "Ignorando mesma Org ✓" or "Ataque livre ✗", 2, Value and "Success" or "Info")
end)
ChecksSection:AddToggle("Ignorar Alvos em Veículos", _G.Settings.Combat.IgnoreVehicles, "IgnoreVehiclesToggle", function(Value)
    _G.Settings.Combat.IgnoreVehicles = Value
    Library:Notify("Ignorar Veículos", Value and "Ativado ✓" or "Desativado ✗", 2, Value and "Success" or "Error")
end)

local SilentAimSection = CombatTab:AddSection("Silent Aim")
SilentAimSection:AddToggle("Silent Aim", false, "SilentAimEnabled", function(Value)
    SilentAim.Enabled = Value
    Library:Notify("Silent Aim", Value and "Ativado" or "Desativado", 2, Value and "Success" or "Error")
end)
SilentAimSection:AddSlider("FOV Silent Aim", 50, 500, 150, "SilentAimFOVSlider", function(Value)
    SilentAim.FOVRadius = Value
end)
SilentAimSection:AddToggle("Team Check", false, "SilentAimTeam", function(Value)
    SilentAim.TeamCheck = Value
end)
SilentAimSection:AddToggle("Wall Check", true, "SilentAimWall", function(Value)
    SilentAim.WallCheck = Value
end)
SilentAimSection:AddLabel("Redireciona tiros via hookmetamethod")

local HitboxSection = CombatTab:AddSection("Hitbox Expandida")
HitboxSection:AddToggle("Hitbox 100 HS", _G.Settings.Combat.HitboxHSEnabled == true, "HitboxHSEnabled", function(Value)
    _G.Settings.Combat.HitboxHSEnabled = Value
    if Value then
        StartHitboxHSLoop()
        for _, player in ipairs(Players:GetPlayers()) do
            UpdateHitboxHS(player)
        end
    else
        ResetAllHitboxHS()
        if HitboxHSConnection then
            HitboxHSConnection:Disconnect()
            HitboxHSConnection = nil
        end
    end
end)
HitboxSection:AddSlider("Tamanho da Hitbox", 5, 100, 15, "HitboxHSSize", function(Value)
    _G.Settings.Combat.HitboxHSSize = Value
    if _G.Settings.Combat.HitboxHSEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            UpdateHitboxHS(player)
        end
    end
end)
HitboxSection:AddSlider("Transparência", 0, 100, 65, "HitboxHSTransparency", function(Value)
    _G.Settings.Combat.HitboxHSTransparency = Value / 100
    if _G.Settings.Combat.HitboxHSEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            UpdateHitboxHS(player)
        end
    end
end)
HitboxSection:AddButton("Resetar Hitbox", function()
    _G.Settings.Combat.HitboxHSEnabled = false
    ResetAllHitboxHS()
    Library:Notify("Hitbox", "Hitboxes resetadas.", 3, "Info")
end)

local ESPPreviewGui = nil
local ESPPreviewParts = {}
local MenuHotkey = Enum.KeyCode.Delete

local function FindMainMenuGui()
    local known = _G.ClassicArcaneMainGui
    if known and known.Parent and known:IsA("ScreenGui") then
        return known
    end

    for _, container in ipairs({CoreGui, LocalPlayer:FindFirstChildOfClass("PlayerGui")}) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("ScreenGui")
                    and child.Name
                    and child.Name ~= "ClassicArcaneCrosshair"
                    and child.Name ~= "ClassicArcaneESPPreview"
                    and child.Name:find("Classic") then
                    _G.ClassicArcaneMainGui = child
                    return child
                end
            end
        end
    end
    return nil
end

local function IsMainMenuOpen()
    local mainGui = FindMainMenuGui()
    return mainGui and mainGui.Enabled == true
end

local function EnsureESPPreview()
    if ESPPreviewGui and ESPPreviewGui.Parent then return true end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return false end

    local oldPreview = playerGui:FindFirstChild("ClassicArcaneESPPreview")
    if oldPreview then oldPreview:Destroy() end

    ESPPreviewGui = Instance.new("ScreenGui")
    ESPPreviewGui.Name = "ClassicArcaneESPPreview"
    ESPPreviewGui.IgnoreGuiInset = true
    ESPPreviewGui.ResetOnSpawn = false
    ESPPreviewGui.DisplayOrder = 999998
    ESPPreviewGui.Enabled = false
    ESPPreviewGui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.Position = UDim2.new(1, -10, 0, 70)
    panel.Size = UDim2.new(0.92, 0, 0, 300)
    panel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.ZIndex = 50
    panel.Parent = ESPPreviewGui

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 10)
    panelCorner.Parent = panel

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 28)
    title.Position = UDim2.fromOffset(12, 8)
    title.BackgroundTransparency = 1
    title.Text = "ESP Preview — todos os elementos"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 51
    title.Parent = panel

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -24, 0, 18)
    subtitle.Position = UDim2.fromOffset(12, 35)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Box • Skeleton • Box 3D • Hat • Textos • Vida"
    subtitle.TextColor3 = Color3.fromRGB(170, 170, 180)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 11
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 51
    subtitle.Parent = panel

    local sample = Instance.new("Frame")
    sample.Name = "Sample"
    sample.BackgroundTransparency = 1
    sample.Position = UDim2.fromOffset(124, 62)
    sample.Size = UDim2.fromOffset(140, 210)
    sample.ZIndex = 51
    sample.Parent = panel

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.Position = UDim2.fromOffset(28, 38)
    box.Size = UDim2.fromOffset(84, 146)
    box.ZIndex = 52
    box.Parent = sample

    local box3D = Instance.new("Frame")
    box3D.Name = "Box3D"
    box3D.BackgroundTransparency = 1
    box3D.BorderSizePixel = 2
    box3D.Position = UDim2.fromOffset(39, 27)
    box3D.Size = UDim2.fromOffset(84, 146)
    box3D.ZIndex = 51
    box3D.Parent = sample

    local hat = Instance.new("TextLabel")
    hat.Name = "ChineseHat"
    hat.BackgroundTransparency = 1
    hat.Size = UDim2.fromOffset(84, 38)
    hat.Position = UDim2.fromOffset(28, 0)
    hat.Text = "△"
    hat.TextColor3 = Color3.fromRGB(255, 255, 255)
    hat.Font = Enum.Font.GothamBold
    hat.TextSize = 32
    hat.ZIndex = 54
    hat.Parent = sample

    local skeletonRoot = Instance.new("Frame")
    skeletonRoot.Name = "Skeleton"
    skeletonRoot.BackgroundTransparency = 1
    skeletonRoot.Size = UDim2.fromOffset(140, 210)
    skeletonRoot.ZIndex = 54
    skeletonRoot.Parent = sample

    local function createPreviewLine(name, position, size, rotation)
        local line = Instance.new("Frame")
        line.Name = name
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Position = position
        line.Size = size
        line.Rotation = rotation or 0
        line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        line.BorderSizePixel = 0
        line.ZIndex = 55
        line.Parent = skeletonRoot
        return line
    end

    local skeletonHead = Instance.new("Frame")
    skeletonHead.Name = "Head"
    skeletonHead.AnchorPoint = Vector2.new(0.5, 0.5)
    skeletonHead.Position = UDim2.fromOffset(70, 50)
    skeletonHead.Size = UDim2.fromOffset(18, 18)
    skeletonHead.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    skeletonHead.BorderSizePixel = 0
    skeletonHead.ZIndex = 56
    skeletonHead.Parent = skeletonRoot
    local skeletonCorner = Instance.new("UICorner")
    skeletonCorner.CornerRadius = UDim.new(1, 0)
    skeletonCorner.Parent = skeletonHead

    local skeletonLines = {
        createPreviewLine("Spine", UDim2.fromOffset(70, 88), UDim2.fromOffset(4, 58), 0),
        createPreviewLine("LeftArm", UDim2.fromOffset(49, 91), UDim2.fromOffset(4, 50), 68),
        createPreviewLine("RightArm", UDim2.fromOffset(91, 91), UDim2.fromOffset(4, 50), -68),
        createPreviewLine("LeftLeg", UDim2.fromOffset(59, 139), UDim2.fromOffset(4, 62), 25),
        createPreviewLine("RightLeg", UDim2.fromOffset(81, 139), UDim2.fromOffset(4, 62), -25)
    }

    local name = Instance.new("TextLabel")
    name.Name = "Name"
    name.BackgroundTransparency = 1
    name.Size = UDim2.fromOffset(180, 20)
    name.Position = UDim2.fromOffset(-20, 178)
    name.Text = "Player"
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.Font = Enum.Font.Gotham
    name.TextSize = 13
    name.ZIndex = 56
    name.Parent = sample

    local distance = Instance.new("TextLabel")
    distance.Name = "Distance"
    distance.BackgroundTransparency = 1
    distance.Size = UDim2.fromOffset(180, 18)
    distance.Position = UDim2.fromOffset(-20, 197)
    distance.Text = "[125m]"
    distance.TextColor3 = Color3.fromRGB(200, 200, 200)
    distance.Font = Enum.Font.Gotham
    distance.TextSize = 11
    distance.ZIndex = 56
    distance.Parent = sample

    local inventory = Instance.new("TextLabel")
    inventory.Name = "Inventory"
    inventory.BackgroundTransparency = 1
    inventory.Size = UDim2.new(1, -24, 0, 20)
    inventory.Position = UDim2.fromOffset(12, 265)
    inventory.Text = "Inv: Exemplo"
    inventory.TextColor3 = Color3.fromRGB(170, 220, 255)
    inventory.Font = Enum.Font.Gotham
    inventory.TextSize = 11
    inventory.ZIndex = 56
    inventory.Parent = panel

    local healthBack = Instance.new("Frame")
    healthBack.Name = "HealthBack"
    healthBack.BorderSizePixel = 0
    healthBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBack.Position = UDim2.fromOffset(105, 120)
    healthBack.Size = UDim2.fromOffset(6, 105)
    healthBack.ZIndex = 52
    healthBack.Parent = panel

    local health = Instance.new("Frame")
    health.Name = "Health"
    health.BorderSizePixel = 0
    health.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    health.Position = UDim2.fromOffset(105, 120)
    health.Size = UDim2.fromOffset(6, 82)
    health.ZIndex = 53
    health.Parent = panel

    local tracer = createPreviewLine("Tracer", UDim2.fromOffset(72, 255), UDim2.fromOffset(3, 150), 60)
    tracer.Parent = panel
    tracer.ZIndex = 51

    ESPPreviewParts = {
        Box = box,
        Box3D = box3D,
        Hat = hat,
        SkeletonHead = skeletonHead,
        SkeletonLines = skeletonLines,
        Name = name,
        Distance = distance,
        Inventory = inventory,
        HealthBack = healthBack,
        Health = health,
        Tracer = tracer
    }
    return true
end

local function UpdateESPPreview()
    if not _G.Settings.Visuals.Preview or not IsMainMenuOpen() then
        if ESPPreviewGui then ESPPreviewGui.Enabled = false end
        return
    end
    if not EnsureESPPreview() then return end
    ESPPreviewGui.Enabled = true

    local rainbowColor = nil
    if _G.Settings.Visuals.Rainbow then
        rainbowColor = Color3.fromHSV((tick() * 0.2) % 1, 1, 1)
    end
    local mainColor = rainbowColor or _G.Settings.Visuals.Colors.Enemy

    ESPPreviewParts.Box.Visible = true
    ESPPreviewParts.Box.BorderColor3 = mainColor
    ESPPreviewParts.Box3D.Visible = true
    ESPPreviewParts.Box3D.BorderColor3 = mainColor
    ESPPreviewParts.Hat.Visible = true
    ESPPreviewParts.Hat.TextColor3 = mainColor
    ESPPreviewParts.SkeletonHead.Visible = true
    ESPPreviewParts.SkeletonHead.BackgroundColor3 = mainColor
    for _, line in ipairs(ESPPreviewParts.SkeletonLines) do
        line.Visible = true
        line.BackgroundColor3 = mainColor
    end
    ESPPreviewParts.Tracer.Visible = true
    ESPPreviewParts.Tracer.BackgroundColor3 = mainColor
    ESPPreviewParts.Name.Visible = true
    ESPPreviewParts.Name.TextColor3 = mainColor
    ESPPreviewParts.Distance.Visible = true
    ESPPreviewParts.Distance.TextColor3 = mainColor
    ESPPreviewParts.Inventory.Visible = true
    ESPPreviewParts.Inventory.TextColor3 = Color3.fromRGB(170, 220, 255)
    ESPPreviewParts.HealthBack.Visible = true
    ESPPreviewParts.Health.Visible = true
    ESPPreviewParts.Health.BackgroundColor3 = _G.Settings.Visuals.Colors.Health
end

TrackConnection(RunService.RenderStepped:Connect(UpdateESPPreview))

TrackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == MenuHotkey then
        local mainGui = FindMainMenuGui()
        if mainGui then
            mainGui.Enabled = not mainGui.Enabled
            UpdateESPPreview()
        end
    end
end))

local ESPGeneralSection = VisualTab:AddSection("ESP General")
ESPGeneralSection:AddToggle("Radar", _G.Settings.Visuals.Radar, "ESPRadar", function(Value)
    _G.Settings.Visuals.Radar = Value
end)
ESPGeneralSection:AddToggle("Enabled", _G.Settings.Visuals.Enabled, "VisualsEnabled", function(Value)
    _G.Settings.Visuals.Enabled = Value
    Library:Notify("ESP", Value and "Ativado ✓" or "Desativado ✗", 2, Value and "Success" or "Error")
end)
ESPGeneralSection:AddSlider("Max Distance", 50, 1000, 500, "MaxESPDistance", function(Value)
    _G.Settings.Visuals.MaxDistance = Value
end)
ESPGeneralSection:AddToggle("Ignorar Fac/Org (ESP)", _G.Settings.Combat.OrgCheck, "VisualIgnoreOrg", function(Value)
    _G.Settings.Combat.OrgCheck = Value
    Library:Notify("Filtro Org", Value and "Ignorando mesma facção no ESP ✓" or "Mostrando todos ✗", 2, Value and "Success" or "Info")
end)
ESPGeneralSection:AddToggle("Team Check", _G.Settings.Visuals.TeamCheck, "VisualsTeamCheck", function(Value)
    _G.Settings.Visuals.TeamCheck = Value
end)
ESPGeneralSection:AddToggle("Visibility Check", _G.Settings.Visuals.VisibilityCheck, "VisibilityCheck", function(Value)
    _G.Settings.Visuals.VisibilityCheck = Value
end)
ESPGeneralSection:AddToggle("Streamproof", _G.Settings.Visuals.Streamproof, "Streamproof", function(Value)
    _G.Settings.Visuals.Streamproof = Value
end)

local ESPVisualsSection = VisualTab:AddSection("Visuals")
ESPVisualsSection:AddToggle("Box", _G.Settings.Visuals.BoxEnabled, "ESPBoxes", function(Value)
    _G.Settings.Visuals.BoxEnabled = Value
    UpdateESPPreview()
end)
ESPVisualsSection:AddDropdown("Tipo de Box", {"2D", "Corner", "3D"}, _G.Settings.Visuals.BoxType, "ESPBoxType", function(Value)
    _G.Settings.Visuals.BoxType = Value
    _G.Settings.Visuals.Box3D = Value == "3D"
    UpdateESPPreview()
end)
ESPVisualsSection:AddToggle("Chapéu chinês", _G.Settings.Visuals.ChineseHat, "ESPChineseHat", function(Value)
    _G.Settings.Visuals.ChineseHat = Value
    UpdateESPPreview()
end)
ESPVisualsSection:AddToggle("Head Dot", _G.Settings.Visuals.HeadDot, "ESPHeadDot", function(Value)
    _G.Settings.Visuals.HeadDot = Value
end)
ESPVisualsSection:AddToggle("Look Tracer", _G.Settings.Visuals.LookTracer, "ESPLookTracer", function(Value)
    _G.Settings.Visuals.LookTracer = Value
end)
ESPVisualsSection:AddToggle("Health Text", _G.Settings.Visuals.HealthText, "ESPHealthText", function(Value)
    _G.Settings.Visuals.HealthText = Value
end)
ESPVisualsSection:AddToggle("Names", _G.Settings.Visuals.Names, "ESPNames", function(Value)
    _G.Settings.Visuals.Names = Value
    UpdateESPPreview()
end)
ESPVisualsSection:AddToggle("Distance", _G.Settings.Visuals.Distance, "ESPDistance", function(Value)
    _G.Settings.Visuals.Distance = Value
    UpdateESPPreview()
end)
ESPVisualsSection:AddToggle("Health", _G.Settings.Visuals.HealthBar, "ESPHealth", function(Value)
    _G.Settings.Visuals.HealthBar = Value
    UpdateESPPreview()
end)
ESPVisualsSection:AddToggle("Gradiente de Vida", _G.Settings.Visuals.HealthGradient, "ESPHealthGradient", function(Value)
    _G.Settings.Visuals.HealthGradient = Value
end)
ESPVisualsSection:AddToggle("Skeletons", _G.Settings.Visuals.Skeleton, "ESPSkeletons", function(Value)
    _G.Settings.Visuals.Skeleton = Value
end)
ESPVisualsSection:AddToggle("Tracers", _G.Settings.Visuals.Tracers, "ESPTracers", function(Value)
    _G.Settings.Visuals.Tracers = Value
end)
ESPVisualsSection:AddDropdown("Origem do Tracer", {"Baixo", "Cima"}, _G.Settings.Visuals.TracerOrigin or "Baixo", "ESPTracerOrigin", function(Value)
    _G.Settings.Visuals.TracerOrigin = Value
end)
ESPVisualsSection:AddToggle("Tempo de Jogo", _G.Settings.Visuals.Playtime, "ESPPlaytime", function(Value)
    _G.Settings.Visuals.Playtime = Value
end)
ESPVisualsSection:AddToggle("Ver inventário público", _G.Settings.Visuals.Inventory, "ESPInventory", function(Value)
    _G.Settings.Visuals.Inventory = Value
    UpdateESPPreview()
end)
ESPVisualsSection:AddToggle("Show local player", _G.Settings.Visuals.ShowLocalPlayer, "ESPShowLocalPlayer", function(Value)
    _G.Settings.Visuals.ShowLocalPlayer = Value
end)
ESPVisualsSection:AddToggle("Rainbow ESP", _G.Settings.Visuals.Rainbow, "ESPRainbow", function(Value)
    _G.Settings.Visuals.Rainbow = Value
    UpdateESPPreview()
end)

local ESPColorsSection = VisualTab:AddSection("Cores do ESP")
ESPColorsSection:AddColorPicker("Cor da Box (Inimigo)", _G.Settings.Visuals.Colors.Enemy, "ESPColorEnemy", function(cor)
    _G.Settings.Visuals.Colors.Enemy = cor
end)
ESPColorsSection:AddColorPicker("Cor da Box (Amigo)", _G.Settings.Visuals.Colors.Friend, "ESPColorFriend", function(cor)
    _G.Settings.Visuals.Colors.Friend = cor
end)
ESPColorsSection:AddColorPicker("Cor do Nome", _G.Settings.Visuals.Colors.Name, "ESPColorName", function(cor)
    _G.Settings.Visuals.Colors.Name = cor
end)
ESPColorsSection:AddColorPicker("Cor da Distância", _G.Settings.Visuals.Colors.Distance, "ESPColorDistance", function(cor)
    _G.Settings.Visuals.Colors.Distance = cor
end)
ESPColorsSection:AddColorPicker("Cor do Traçador", _G.Settings.Visuals.Colors.Tracer, "ESPColorTracer", function(cor)
    _G.Settings.Visuals.Colors.Tracer = cor
end)
ESPColorsSection:AddColorPicker("Cor do Esqueleto", _G.Settings.Visuals.Colors.Skeleton, "ESPColorSkeleton", function(cor)
    _G.Settings.Visuals.Colors.Skeleton = cor
end)
ESPColorsSection:AddColorPicker("Cor da Vida", _G.Settings.Visuals.Colors.Health, "ESPColorHealth", function(cor)
    _G.Settings.Visuals.Colors.Health = cor
end)
ESPColorsSection:AddColorPicker("Cor do Invisível", _G.Settings.Visuals.Colors.Invisible, "ESPColorInvisible", function(cor)
    _G.Settings.Visuals.Colors.Invisible = cor
end)

local ESPPreviewSection = VisualTab:AddSection("Preview dos ESP")
ESPPreviewSection:AddToggle("Mostrar preview", _G.Settings.Visuals.Preview, "ESPPreview", function(Value)
    _G.Settings.Visuals.Preview = Value
    UpdateESPPreview()
end)

local LightingSection = WorldTab:AddSection("Iluminação")
LightingSection:AddToggle("Fullbright", false, "Fullbright", function(Value)
    _G.Settings.World.Fullbright = Value
    if Value then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
    end
end)
LightingSection:AddToggle("Night Mode", false, "NightMode", function(Value)
    _G.Settings.World.NightMode = Value
    if Value then
        Lighting.Ambient = Color3.fromRGB(50, 50, 50)
        Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)
    else
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
    end
end)
LightingSection:AddSlider("Time", 0, 24, 12, "GameTime", function(Value)
    _G.Settings.World.Time = Value
    pcall(function() Lighting.ClockTime = Value end)
end)

local WorldInterfaceSection = WorldTab:AddSection("Interface Visual")
WorldInterfaceSection:AddToggle("Mira fixa", false, "FixedCrosshair", function(Value)
    _G.Settings.Combat.FixedCrosshair = Value
    SetFixedCrosshair(Value)
end)
WorldInterfaceSection:AddToggle("Tela esticada", false, "StretchScreen", function(Value)
    ToggleStretchScreen(Value)
    Library:Notify("Tela esticada", Value and "Ativada ✓" or "Desativada ✗", 2, Value and "Success" or "Info")
end)
WorldInterfaceSection:AddToggle("Ambient Color", false, "PurpleAmbient", function(Value)
    togglePurpleAmbient(Value)
    Library:Notify("Ambient Color", Value and "Ativado ✓" or "Desativado ✗", 2, Value and "Success" or "Info")
end)
WorldInterfaceSection:AddColorPicker("Selecionar Cor", Color3.fromRGB(180, 100, 255), "AmbientColorPicker", function(color)
    CUSTOM_AMBIENT_COLOR = color
    if purpleAmbientEnabled then
        Lighting.Ambient = CUSTOM_AMBIENT_COLOR
        Lighting.OutdoorAmbient = CUSTOM_AMBIENT_COLOR
    end
end)

local MovementBasicSection = MovementTab:AddSection("Movimentação")
MovementBasicSection:AddToggle("Infinite Jump", false, "InfJump", function(Value)
    _G.Settings.Combat = _G.Settings.Combat or {}
    _G.Settings.Combat.InfJump = Value
end)
MovementBasicSection:AddToggle("NoClip", false, "NoClipEnabled", function(Value)
    _G.Settings.Combat = _G.Settings.Combat or {}
    _G.Settings.Combat.NoClip = Value
end)
MovementBasicSection:AddSlider("WalkSpeed", 16, 200, 16, "WalkSpeedSlider", function(Value)
    _G.Settings.Combat = _G.Settings.Combat or {}
    _G.Settings.Combat.WalkSpeed = Value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)
MovementBasicSection:AddSlider("JumpPower", 50, 300, 50, "JumpPowerSlider", function(Value)
    _G.Settings.Combat = _G.Settings.Combat or {}
    _G.Settings.Combat.JumpPower = Value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Settings.Combat and _G.Settings.Combat.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if _G.Settings.Combat and _G.Settings.Combat.NoClip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if _G.Settings.Combat and _G.Settings.Combat.WalkSpeed then
            hum.WalkSpeed = _G.Settings.Combat.WalkSpeed
        end
        if _G.Settings.Combat and _G.Settings.Combat.JumpPower then
            hum.UseJumpPower = true
            hum.JumpPower = _G.Settings.Combat.JumpPower
        end
    end
end)

local MovementDashSection = MovementTab:AddSection("Fake Dash")
MovementDashSection:AddToggle("Fake Dash", false, "FakeDashEnabled", function(Value)
    ToggleFakeDash(Value)
end)
MovementDashSection:AddSlider("Distance", 1, 30, 8, "FakeDashDistance", function(Value)
    DashDistance = Value
    _G.Settings.Combat.FakeDashDistance = DashDistance
end)
MovementDashSection:AddSlider("Cooldown (ms)", 50, 1000, 250, "FakeDashCooldown", function(Value)
    DashCooldown = Value / 1000
    _G.Settings.Combat.FakeDashCooldown = DashCooldown
end)

local MovementLagSection = MovementTab:AddSection("Fake Lag")
MovementLagSection:AddToggle("Fake Lag", false, "FakeLagEnabled", function(Value)
    ToggleFakeLag(Value)
end)
MovementLagSection:AddSlider("Distance", 5, 50, 15, "FakeLagDistance", function(Value)
    LagDistance = Value
    _G.Settings.Combat.FakeLagDistance = LagDistance
end)
MovementLagSection:AddTextbox("Variations", "FakeLagVariations", function(Value)
    local arr = {}
    for num in tostring(Value):gmatch("(%d+)") do table.insert(arr, tonumber(num)) end
    if #arr > 0 then LagDistanceVariacoes = arr end
end, "12,15,18")
MovementLagSection:AddSlider("Cooldown (ms)", 100, 2000, 1000, "FakeLagCooldown", function(Value)
    LagCooldown = Value / 1000
    _G.Settings.Combat.FakeLagCooldown = LagCooldown
end)

local MovementSpeedHackSection = MovementTab:AddSection("Speed Hack (Left Ctrl)")
MovementSpeedHackSection:AddToggle("Speed Hack (Ctrl)", false, "SpeedHackEnabled", function(Value)
    toggleSpeedHack(Value)
    Library:Notify("Speed Hack", Value and "Ativado (Ctrl = 36) ✓" or "Desativado ✗", 2, Value and "Success" or "Error")
end)
MovementSpeedHackSection:AddLabel("Segure Ctrl para correr (36) | Solte para voltar (16)")

local MovementSpinbotSection = MovementTab:AddSection("Spinbot")
MovementSpinbotSection:AddToggle("Spinbot", false, "SpinbotEnabled", function(Value)
    toggleSpin(Value)
    Library:Notify("Spinbot", Value and "Ativado ✓" or "Desativado ✗", 2, Value and "Success" or "Error")
end)

local MiscCopySkin = MiscTab:AddSection("Copiar Skin")
local CopySkinName = ""
    MiscCopySkin:AddTextbox("Nome ou DisplayName", "CopySkinPlayerName", function(Value)
    CopySkinName = tostring(Value or "")
    _G.Settings.Combat.CopySkinPlayerName = CopySkinName
end)
MiscCopySkin:AddButton("Aplicar skin", function()
    CopySkinFromName(CopySkinName)
end)

local MiscInfAmmoSection = MiscTab:AddSection("Munição Infinita")
MiscInfAmmoSection:AddToggle("Infinite Ammo", false, "InfiniteAmmoEnabled", function(Value)
    toggleInfiniteAmmo(Value)
    Library:Notify("Infinite Ammo", Value and "Ativado ✓" or "Desativado ✗", 2, Value and "Success" or "Error")
end)

local MiscUtilSection = MiscTab:AddSection("Utilidades")
MiscUtilSection:AddToggle("Aviso de Jogadores", _G.Settings.Combat.PlayerAlerts, "PlayerAlertsToggle", function(Value)
    _G.Settings.Combat.PlayerAlerts = Value
end)
MiscUtilSection:AddKeybind("Tecla de Pânico", Enum.KeyCode.P, "PanicKey", function()
    _G.Settings.Combat.Enabled          = false
    _G.Settings.Combat.SilentAimEnabled = false
    _G.Settings.Combat.HitboxHSEnabled  = false
    _G.Settings.Combat.FakeLagEnabled   = false
    _G.Settings.Combat.FakeDashEnabled  = false
    _G.Settings.Visuals.Enabled         = false
    _G.Settings.Visuals.Radar           = false
    ResetAllHitboxHS()
    if HitboxHSConnection then
        HitboxHSConnection:Disconnect()
        HitboxHSConnection = nil
    end
    Library:Notify("⚠️ PÂNICO", "Tudo desativado!", 3, "Warning")
end, false)

local fallFixConnection = nil
local BloqueioSection = BloqueioTab:AddSection("Proteções")

BloqueioSection:AddToggle("Bypass Anti-Cheat (Fluxo)", false, "FluxoBypassToggle", function(Value)
    if Value then
        loadFluxoBypass()
        Library:Notify("Bypass", "Bypass ativado e rodando ✓", 2, "Success")
    else
        Library:Notify("Bypass", "Reinicie o script para desativar", 2, "Warning")
    end
end)

BloqueioSection:AddToggle("Bypass ban Manual", false, "anti_ban_flag", function(estado)
    Toggles.AntiBanimento = estado
    if estado then
        pcall(function()
            if LocalPlayer.CarregamentoFold.DataBanimento.Value == true then
                LocalPlayer.CarregamentoFold.DataBanimento.Value = false
            end
        end)
    end
end)

BloqueioSection:AddToggle("Anti Queda Sem Lag", false, "AntiFallNoLag", function(estado)
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local function DesativarQueda()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        for _, conn in ipairs(getconnections(hum.StateChanged)) do
            local func = conn.Function
            if func then
                local info = debug.getinfo(func)
                if info and info.source and string.find(info.source, "Chat e Backpack") then
                    conn:Disable()
                    break
                end
            end
        end
    end
    local function Aplicar()
        DesativarQueda()
        local Remote = game.ReplicatedStorage:FindFirstChild("ReceberDano")
        if Remote then
            if not Remote._fallBackup then
                Remote._fallBackup = Remote.FireServer
            end
            Remote.FireServer = function() end
        end
    end
    if estado then
        Aplicar()
        if fallFixConnection then fallFixConnection:Disconnect() end
        fallFixConnection = LP.CharacterAdded:Connect(function()
            task.wait(1)
            Aplicar()
        end)
        Library:Notify("Anti Queda", "✅ 100% sem lag ativado!", 2, "Success")
    else
        if fallFixConnection then
            fallFixConnection:Disconnect()
            fallFixConnection = nil
        end
        local Remote = game.ReplicatedStorage:FindFirstChild("ReceberDano")
        if Remote and Remote._fallBackup then
            Remote.FireServer = Remote._fallBackup
            Remote._fallBackup = nil
        end
        Library:Notify("Anti Queda", "❌ Desativado.", 2, "Info")
    end
end)

local ConfigSection = ConfigTab:AddSection("Configurações do Script")
local CONFIG_FILE = "classic_arcane_config.json"
local ConfigAutoLoad = false

local function EncodeConfigValue(value, visited)
    local valueType = typeof(value)
    if value == nil then
        return {__type = "nil"}
    elseif valueType == "boolean" or valueType == "number" or valueType == "string" then
        return value
    elseif valueType == "Color3" then
        return {__type = "Color3", r = value.R, g = value.G, b = value.B}
    elseif valueType == "Vector2" then
        return {__type = "Vector2", x = value.X, y = value.Y}
    elseif valueType == "Vector3" then
        return {__type = "Vector3", x = value.X, y = value.Y, z = value.Z}
    elseif valueType == "EnumItem" then
        local enumText = tostring(value)
        local enumType, enumName = string.match(enumText, "^Enum%.([^%.]+)%.(.+)$")
        if enumType and enumName then
            return {__type = "EnumItem", enumType = enumType, name = enumName}
        end
        return {__type = "nil"}
    elseif type(value) == "table" then
        visited = visited or {}
        if visited[value] then return {__type = "nil"} end
        visited[value] = true
        local entries = {}
        for key, item in pairs(value) do
            table.insert(entries, {
                key = EncodeConfigValue(key, visited),
                value = EncodeConfigValue(item, visited)
            })
        end
        visited[value] = nil
        return {__type = "table", entries = entries}
    end
    return {__type = "nil"}
end

local function DecodeConfigValue(value)
    if type(value) ~= "table" or not value.__type then return value end
    if value.__type == "nil" then
        return nil
    elseif value.__type == "Color3" then
        return Color3.new(value.r or 0, value.g or 0, value.b or 0)
    elseif value.__type == "Vector2" then
        return Vector2.new(value.x or 0, value.y or 0)
    elseif value.__type == "Vector3" then
        return Vector3.new(value.x or 0, value.y or 0, value.z or 0)
    elseif value.__type == "EnumItem" then
        local enumType = value.enumType and Enum[value.enumType]
        return enumType and value.name and enumType[value.name] or nil
    elseif value.__type == "table" then
        local result = {}
        for _, entry in ipairs(value.entries or {}) do
            local key = DecodeConfigValue(entry.key)
            local item = DecodeConfigValue(entry.value)
            if key ~= nil and item ~= nil then result[key] = item end
        end
        return result
    end
    return nil
end

local function MergeConfigTables(target, source)
    for key, value in pairs(source or {}) do
        if type(value) == "table" and type(target[key]) == "table" then
            MergeConfigTables(target[key], value)
        else
            target[key] = value
        end
    end
end

local function ApplyLoadedRuntimeSettings()
    local combat = _G.Settings.Combat or {}
    local visuals = _G.Settings.Visuals or {}

    aimbotSettings.Enabled = combat.Enabled == true
    aimbotSettings.FOV = tonumber(combat.FOV) or aimbotSettings.FOV
    aimbotSettings.ShowFOV = combat.ShowFOV ~= false
    aimbotSettings.Smoothness = tonumber(combat.Smoothness) or aimbotSettings.Smoothness
    aimbotSettings.MaxDistance = tonumber(combat.MaxDistance) or aimbotSettings.MaxDistance
    if DrawingCircle then
        DrawingCircle.Radius = aimbotSettings.FOV
        DrawingCircle.Visible = aimbotSettings.ShowFOV
    end

    DashDistance = tonumber(combat.FakeDashDistance) or DashDistance
    LagDistance = tonumber(combat.FakeLagDistance) or LagDistance
    DashCooldown = tonumber(combat.FakeDashCooldown) or DashCooldown
    LagCooldown = tonumber(combat.FakeLagCooldown) or LagCooldown
    if type(combat.FakeLagVariations) == "string" then
        local variations = {}
        for number in combat.FakeLagVariations:gmatch("(%d+)") do
            table.insert(variations, tonumber(number))
        end
        if #variations > 0 then LagDistanceVariacoes = variations end
    end

    SilentAim.Enabled = combat.SilentAimEnabled == true
    SilentAim.FOVRadius = tonumber(combat.SilentAimFOV) or SilentAim.FOVRadius

    local controls = {
        AimbotEnabled = combat.Enabled,
        FOVRadius = combat.FOV,
        ShowFOV = combat.ShowFOV,
        Smoothness = (tonumber(combat.Smoothness) or 0.4) * 100,
        MaxDistance = combat.MaxDistance,
        TeamCheck = combat.TeamCheck,
        IgnoreSameOrgToggle = combat.OrgCheck,
        IgnoreVehiclesToggle = combat.IgnoreVehicles,
        SilentAimEnabled = SilentAim.Enabled,
        HitboxHSEnabled = combat.HitboxHSEnabled,
        HitboxHSSize = combat.HitboxHSSize,
        HitboxHSTransparency = (tonumber(combat.HitboxHSTransparency) or 0.65) * 100,
        InfJump = combat.InfJump,
        NoClipEnabled = combat.NoClip,
        FakeDashEnabled = combat.FakeDashEnabled,
        FakeDashDistance = combat.FakeDashDistance,
        FakeLagEnabled = combat.FakeLagEnabled,
        FakeLagDistance = combat.FakeLagDistance,
        FakeLagCooldown = (tonumber(combat.FakeLagCooldown) or 1) * 1000,
        FixedCrosshair = combat.FixedCrosshair,
        StretchScreen = combat.StretchScreen,
        PurpleAmbient = combat.PurpleAmbient,
        InfiniteAmmoEnabled = combat.InfiniteAmmoEnabled,
        SpeedHackEnabled = combat.SpeedHackEnabled,
        SpinbotEnabled = combat.SpinbotEnabled,
        FluxoBypassToggle = combat.FluxoBypassEnabled,
        anti_ban_flag = combat.AntiBanimento,
        AntiFallNoLag = combat.AntiFallNoLag,
        AutoLoadConfig = ConfigAutoLoad
    }
    for name, value in pairs(controls) do
        if value ~= nil and Toggles and Toggles[name] and type(Toggles[name].Set) == "function" then
            pcall(function() Toggles[name]:Set(value) end)
        end
    end
end

local function CaptureRuntimeSettings()
    local combat = _G.Settings.Combat or {}
    combat.Enabled = aimbotSettings.Enabled
    combat.FOV = aimbotSettings.FOV
    combat.ShowFOV = aimbotSettings.ShowFOV
    combat.Smoothness = aimbotSettings.Smoothness
    combat.MaxDistance = aimbotSettings.MaxDistance
    combat.FakeDashEnabled = fakeDashEnabled
    combat.FakeDashDistance = DashDistance
    combat.FakeDashCooldown = DashCooldown
    combat.FakeLagEnabled = fakeLagEnabled
    combat.FakeLagDistance = LagDistance
    combat.FakeLagCooldown = LagCooldown
    combat.FakeLagVariations = table.concat(LagDistanceVariacoes, ",")
    combat.SilentAimEnabled = SilentAim.Enabled
    combat.SilentAimFOV = SilentAim.FOVRadius
    combat.InfiniteAmmoEnabled = infiniteAmmoEnabled
    combat.SpeedHackEnabled = speedHackEnabled
    combat.PurpleAmbient = purpleAmbientEnabled
    combat.SpinbotEnabled = spinEnabled
    _G.Settings.Combat = combat
end

local function SaveConfig(silent)
    if type(writefile) ~= "function" then
        if not silent then Library:Notify("Config", "Este executor não suporta writefile.", 3, "Error") end
        return false
    end
    local ok, err = pcall(function()
        CaptureRuntimeSettings()
        local payload = {
            version = 1,
            autoLoad = ConfigAutoLoad,
            settings = EncodeConfigValue(_G.Settings)
        }
        writefile(CONFIG_FILE, HttpService:JSONEncode(payload))
    end)
    if not ok then
        if not silent then Library:Notify("Config", "Falha ao salvar: " .. tostring(err), 3, "Error") end
        return false
    end
    if not silent then Library:Notify("Config", "Configuração salva com sucesso.", 2, "Success") end
    return true
end

local function LoadConfig(silent)
    if type(isfile) ~= "function" or not isfile(CONFIG_FILE) then
        if not silent then Library:Notify("Config", "Nenhuma configuração salva encontrada.", 3, "Error") end
        return false
    end
    local ok, err = pcall(function()
        local payload = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(payload) ~= "table" then error("formato inválido") end
        ConfigAutoLoad = payload.autoLoad == true
        local savedSettings = DecodeConfigValue(payload.settings)
        if type(savedSettings) ~= "table" then error("configurações inválidas") end
        MergeConfigTables(_G.Settings, savedSettings)
        _G.Toggles.AutoLoadConfig = ConfigAutoLoad
        ApplyLoadedRuntimeSettings()
    end)
    if not ok then
        if not silent then Library:Notify("Config", "Falha ao carregar: " .. tostring(err), 3, "Error") end
        return false
    end
    if not silent then Library:Notify("Config", "Configuração carregada com sucesso.", 2, "Success") end
    return true
end

ConfigSection:AddToggle("Carregar config automático", ConfigAutoLoad, "AutoLoadConfig", function(Value)
    ConfigAutoLoad = Value == true
    _G.Toggles.AutoLoadConfig = ConfigAutoLoad
    SaveConfig(true)
    Library:Notify("Config", ConfigAutoLoad and "Carregamento automático ativado." or "Carregamento automático desativado.", 2, "Info")
end)

ConfigSection:AddButton("Salvar Config", function()
    SaveConfig(false)
end)

ConfigSection:AddButton("Carregar Config", function()
    LoadConfig(false)
end)

ConfigSection:AddButton("Excluir Config", function()
    if type(isfile) == "function" and isfile(CONFIG_FILE) and type(delfile) == "function" then
        delfile(CONFIG_FILE)
        ConfigAutoLoad = false
        Library:Notify("Config", "Configuração excluída.", 2, "Info")
    else
        Library:Notify("Config", "Nenhuma configuração para excluir.", 2, "Error")
    end
end)

local SystemSection = InfoTab:AddSection("Sistema")
local jogador = game.Players.LocalPlayer
local nomeJogo = (function()
    local ok, result = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    return (ok and result) or game.Name
end)()
local executorNome = "Desconhecido"
if syn then executorNome = "Synapse X"
elseif krnl then executorNome = "Krnl"
elseif getexecutorname then
    local ok, nome = pcall(getexecutorname)
    if ok then executorNome = nome end
end
SystemSection:AddLabel("Usuário: " .. jogador.Name)
SystemSection:AddLabel("Executor: " .. executorNome)
SystemSection:AddLabel("Jogo: " .. nomeJogo)

Library:Notify("Zeus Internal", "Script carregado com sucesso! ✓", 5, "Success")

if not _G.Settings.Visuals.Playtime then
    _G.Settings.Visuals.Playtime = false
end

TrackConnection(Players.PlayerAdded:Connect(function(player)
    if not _G.Settings.Combat.PlayerAlerts then return end
    task.wait(0.5)
    local level = pcall(function() return player:GetAttribute("Nivel") end) and player:GetAttribute("Nivel") or "?"
    Library:Notify("🟢 Entrou", player.Name .. " entrou no servidor", 4, "Success")
end))

TrackConnection(Players.PlayerRemoving:Connect(function(player)
    if not _G.Settings.Combat.PlayerAlerts then return end
    Library:Notify("🔴 Saiu", player.Name .. " saiu do servidor", 4, "Warning")
end))

local _RADAR_GUI  = nil
local _RADAR_DOTS = {}
local RADAR_PX    = 160
local RADAR_RANGE = 150

local function SetupRadar()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local old = playerGui:FindFirstChild("ClassicArcaneRadar")
    if old then old:Destroy() end
    local oldCg = CoreGui:FindFirstChild("ClassicArcaneRadar")
    if oldCg then oldCg:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ClassicArcaneRadar"
    gui.DisplayOrder = 99998
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then gui.Parent = playerGui end

    local half = RADAR_PX / 2

    local bg = Instance.new("Frame")
    bg.Name = "BG"
    bg.Size = UDim2.new(0, RADAR_PX, 0, RADAR_PX)
    bg.Position = UDim2.new(1, -RADAR_PX - 12, 1, -RADAR_PX - 12)
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    bg.BackgroundTransparency = 0.25
    bg.BorderSizePixel = 0
    bg.Parent = gui
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.fromRGB(70, 70, 70)
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    for _, axis in ipairs({{UDim2.new(0, half - 10, 0.5, 0), UDim2.new(0, 20, 0, 1)},
                           {UDim2.new(0.5, 0, 0, half - 10), UDim2.new(0, 1, 0, 20)}}) do
        local line = Instance.new("Frame")
        line.Position = axis[1]
        line.Size = axis[2]
        line.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.ZIndex = 3
        line.Parent = bg
    end

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Position = UDim2.new(0, 0, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = "RADAR"
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.ZIndex = 4
    label.Parent = bg

    local selfDot = Instance.new("Frame")
    selfDot.Name = "SelfDot"
    selfDot.Size = UDim2.new(0, 6, 0, 6)
    selfDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    selfDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    selfDot.BorderSizePixel = 0
    selfDot.ZIndex = 5
    selfDot.Parent = bg
    local selfCorner = Instance.new("UICorner")
    selfCorner.CornerRadius = UDim.new(1, 0)
    selfCorner.Parent = selfDot

    _RADAR_GUI = {Gui = gui, BG = bg}
    _RADAR_DOTS = {}
end

local function GetOrMakeDot(player)
    if _RADAR_DOTS[player] then return _RADAR_DOTS[player] end
    if not _RADAR_GUI or not _RADAR_GUI.BG then return nil end
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    dot.BorderSizePixel = 0
    dot.ZIndex = 4
    dot.Parent = _RADAR_GUI.BG
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = dot
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 70, 0, 11)
    lbl.Position = UDim2.new(0, 7, 0, -3)
    lbl.BackgroundTransparency = 1
    lbl.Text = player.Name
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 8
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    lbl.Parent = dot
    _RADAR_DOTS[player] = dot
    return dot
end

local function UpdateRadar()
    if not _G.Settings.Visuals.Radar then
        if _RADAR_GUI then _RADAR_GUI.Gui.Enabled = false end
        return
    end
    if not _RADAR_GUI then SetupRadar() end
    if not _RADAR_GUI then return end
    _RADAR_GUI.Gui.Enabled = true

    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    local localPos = localRoot.Position
    local camLook  = CurrentCamera.CFrame.LookVector
    local camYaw   = math.atan2(camLook.X, camLook.Z)
    local half     = RADAR_PX / 2
    local scale    = half / RADAR_RANGE

    for player, dot in pairs(_RADAR_DOTS) do
        if not player or not player.Parent then
            pcall(function() dot:Destroy() end)
            _RADAR_DOTS[player] = nil
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local dot  = GetOrMakeDot(player)
        if not dot then continue end

        if not root or not hum or hum.Health <= 0 then
            dot.Visible = false
            continue
        end

        local rel = root.Position - localPos
        local cos, sin = math.cos(-camYaw), math.sin(-camYaw)
        local rx = rel.X * cos - rel.Z * sin
        local rz = rel.X * sin + rel.Z * cos

        local px = half + rx * scale
        local py = half - rz * scale

        local dx, dy = px - half, py - half
        local dist = math.sqrt(dx*dx + dy*dy)
        if dist > half - 5 then
            local n = (half - 5) / dist
            px = half + dx * n
            py = half + dy * n
        end

        dot.Position = UDim2.new(0, px - 2.5, 0, py - 2.5)
        dot.Visible  = true

        if _G.Settings.Visuals.TeamCheck
            and player.Team
            and player.Team == LocalPlayer.Team then
            dot.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        else
            dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

TrackConnection(RunService.RenderStepped:Connect(UpdateRadar))

TrackConnection(Players.PlayerRemoving:Connect(function(player)
    if _RADAR_DOTS[player] then
        pcall(function() _RADAR_DOTS[player]:Destroy() end)
        _RADAR_DOTS[player] = nil
    end
end))

local function formatPlaytime(minutes)
    if not minutes or minutes == 0 then return "0m" end
    local hours = math.floor(minutes / 60)
    local mins = minutes % 60
    if hours > 0 then
        return string.format("%dh %dm", hours, mins)
    else
        return string.format("%dm", mins)
    end
end

local _INVENTORY_CACHE = {}
local _INVENTORY_CACHE_TIME = {}
local INVENTORY_CACHE_DURATION = 1

local function GetPublicInventoryText(player)
    local now = tick()
    if _INVENTORY_CACHE[player] and (now - (_INVENTORY_CACHE_TIME[player] or 0)) < INVENTORY_CACHE_DURATION then
        return _INVENTORY_CACHE[player]
    end

    local backpack = player and player:FindFirstChildOfClass("Backpack")
    local itemNames = {}

    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local itemName = tostring(item.Name or "")
                if itemName ~= "" and itemName:lower() ~= "celular" then
                    table.insert(itemNames, itemName)
                end
            end
        end
    end

    table.sort(itemNames, function(a, b)
        return a:lower() < b:lower()
    end)

    local result
    if #itemNames == 0 then
        result = "Inv: vazia"
    else
        result = "Inv: " .. table.concat(itemNames, ", ")
    end
    _INVENTORY_CACHE[player] = result
    _INVENTORY_CACHE_TIME[player] = now
    return result
end

local _ESP_CACHE = {}
local _CONNECTIONS = {}

local SKELETON_BONES = {
    R15 = {
        {"UpperTorso", "LowerTorso"}, {"UpperTorso", "Head"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    },
    R6 = {
        {"Torso", "Head"},
        {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
        {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
    }
}

local BOX3D_EDGES = {
    {1, 2}, {2, 3}, {3, 4}, {4, 1},
    {5, 6}, {6, 7}, {7, 8}, {8, 5},
    {1, 5}, {2, 6}, {3, 7}, {4, 8}
}

local function HideDrawingLines(lines)
    for _, line in ipairs(lines or {}) do
        if line then line.Visible = false end
    end
end

local function UpdateFull3DBox(lines, character, color)
    HideDrawingLines(lines)
    if not _G.Settings.Visuals.BoxEnabled or not _G.Settings.Visuals.Box3D or _G.Settings.Visuals.BoxType ~= "3D" or not CurrentCamera or not character then return end

    local ok, boxCFrame, boxSize = pcall(function()
        return character:GetBoundingBox()
    end)
    if not ok or not boxCFrame or not boxSize then return end

    local half = boxSize / 2
    local corners = {
        Vector3.new(-half.X, -half.Y, -half.Z),
        Vector3.new( half.X, -half.Y, -half.Z),
        Vector3.new( half.X,  half.Y, -half.Z),
        Vector3.new(-half.X,  half.Y, -half.Z),
        Vector3.new(-half.X, -half.Y,  half.Z),
        Vector3.new( half.X, -half.Y,  half.Z),
        Vector3.new( half.X,  half.Y,  half.Z),
        Vector3.new(-half.X,  half.Y,  half.Z)
    }

    local projected = {}
    for i, corner in ipairs(corners) do
        local screen, onScreen = CurrentCamera:WorldToViewportPoint(boxCFrame:PointToWorldSpace(corner))
        if not onScreen or screen.Z <= 0 then return end
        projected[i] = Vector2.new(screen.X, screen.Y)
    end

    for i, edge in ipairs(BOX3D_EDGES) do
        local line = lines and lines[i]
        if line then
            line.From = projected[edge[1]]
            line.To = projected[edge[2]]
            line.Color = color or Color3.fromRGB(255, 255, 255)
            line.Visible = true
        end
    end
end

local CHINESE_HAT_EDGES = {
    {1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8},{8,1},
    {9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8}
}

local function UpdateChineseHat(lines, character, color)
    HideDrawingLines(lines)
    if not _G.Settings.Visuals.ChineseHat or not CurrentCamera or not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local camRight = CurrentCamera.CFrame.RightVector
    local camLook  = CurrentCamera.CFrame.LookVector
    local worldRight = Vector3.new(camRight.X, 0, camRight.Z)
    local worldFwd   = Vector3.new(camLook.X,  0, camLook.Z)
    worldRight = worldRight.Magnitude > 0.01 and worldRight.Unit or Vector3.new(1, 0, 0)
    worldFwd   = worldFwd.Magnitude   > 0.01 and worldFwd.Unit   or Vector3.new(0, 0, 1)

    local center     = head.Position + Vector3.new(0, 0.6, 0)
    local N          = 8
    local brimRadius = 1.35
    local brimY      = -0.15
    local apexY      = 0.55

    local points = {}
    for i = 1, N do
        local angle = (i - 1) * (2 * math.pi / N)
        points[i] = center
            + Vector3.new(0, brimY, 0)
            + worldRight * (math.cos(angle) * brimRadius)
            + worldFwd   * (math.sin(angle) * brimRadius)
    end
    points[9] = center + Vector3.new(0, apexY, 0)

    local projected = {}
    for i, point in ipairs(points) do
        local screen, onScreen = CurrentCamera:WorldToViewportPoint(point)
        if not onScreen or screen.Z <= 0 then return end
        projected[i] = Vector2.new(screen.X, screen.Y)
    end

    for i, edge in ipairs(CHINESE_HAT_EDGES) do
        local line = lines and lines[i]
        if line then
            line.From  = projected[edge[1]]
            line.To    = projected[edge[2]]
            line.Color = color or Color3.fromRGB(255, 255, 255)
            line.Visible = true
        end
    end
end

local function UpdateCornerBox(lines, frameData, color)
    HideDrawingLines(lines)
    if not _G.Settings.Visuals.BoxEnabled or _G.Settings.Visuals.BoxType ~= "Corner" or not frameData then return end

    local x, y, w, h = frameData.X, frameData.Y, frameData.W, frameData.H
    local cornerW = math.clamp(w * 0.24, 6, 22)
    local cornerH = math.clamp(h * 0.18, 6, 28)
    local points = {
        {Vector2.new(x, y), Vector2.new(x + cornerW, y)},
        {Vector2.new(x, y), Vector2.new(x, y + cornerH)},
        {Vector2.new(x + w, y), Vector2.new(x + w - cornerW, y)},
        {Vector2.new(x + w, y), Vector2.new(x + w, y + cornerH)},
        {Vector2.new(x, y + h), Vector2.new(x + cornerW, y + h)},
        {Vector2.new(x, y + h), Vector2.new(x, y + h - cornerH)},
        {Vector2.new(x + w, y + h), Vector2.new(x + w - cornerW, y + h)},
        {Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - cornerH)}
    }

    for i, segment in ipairs(points) do
        local line = lines and lines[i]
        if line then
            line.From = segment[1]
            line.To = segment[2]
            line.Color = color or Color3.fromRGB(255, 255, 255)
            line.Visible = true
        end
    end
end

local function ClearAllVisibility(objects)
    if not objects then return end
    if objects.Box then objects.Box.Visible = false end
    if objects.BoxOutline then objects.BoxOutline.Visible = false end
    if objects.Name then objects.Name.Visible = false end
    if objects.Dist then objects.Dist.Visible = false end
    if objects.HealthBar then objects.HealthBar.Visible = false end
    if objects.HealthBack then objects.HealthBack.Visible = false end
    if objects.Tracer then objects.Tracer.Visible = false end
    if objects.Playtime then objects.Playtime.Visible = false end
    if objects.Inventory then objects.Inventory.Visible = false end
    if objects.HealthText then objects.HealthText.Visible = false end
    if objects.HeadDot then objects.HeadDot.Visible = false end
    if objects.LookTracer then objects.LookTracer.Visible = false end
    HideDrawingLines(objects.SkeletonLines)
    HideDrawingLines(objects.Box3DLines)
    HideDrawingLines(objects.CornerBoxLines)
    HideDrawingLines(objects.ChineseHatLines)
end

local function RegisterPlayerVisuals(player)
    if _ESP_CACHE[player] then return end
    local objects = {
        BoxOutline = CreateDrawInstance("Square", {Thickness = 3, Color = Color3.fromRGB(0,0,0), Filled = false, Visible = false, ZIndex = 1}),
        Box = CreateDrawInstance("Square", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Enemy, Filled = false, Visible = false, ZIndex = 2}),
        Tracer = CreateDrawInstance("Line", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Tracer, Visible = false}),
        Name = CreateDrawInstance("Text", {Size = 12, Center = true, Outline = true, Color = _G.Settings.Visuals.Colors.Name, Font = 3, Visible = false}),
        Dist = CreateDrawInstance("Text", {Size = 10, Center = true, Outline = true, Color = _G.Settings.Visuals.Colors.Distance, Font = 3, Visible = false}),
        HealthBack = CreateDrawInstance("Square", {Thickness = 1, Color = Color3.fromRGB(0,0,0), Filled = true, Visible = false, ZIndex = 1}),
        HealthBar = CreateDrawInstance("Square", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Health, Filled = true, Visible = false, ZIndex = 2}),
        Playtime = CreateDrawInstance("Text", {
            Size = 10,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 0),
            Font = 3,
            Visible = false
        }),
        Inventory = CreateDrawInstance("Text", {
            Size = 10,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(170, 220, 255),
            Font = 3,
            Visible = false
        }),
        HealthText = CreateDrawInstance("Text", {
            Size = 10,
            Center = true,
            Outline = true,
            Color = _G.Settings.Visuals.Colors.Health,
            Font = 3,
            Visible = false
        }),
        SkeletonLines = {},
        Box3DLines = {},
        CornerBoxLines = {},
        ChineseHatLines = {}
    }
    for i = 1, 15 do
        objects.SkeletonLines[i] = CreateDrawInstance("Line", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Skeleton, Visible = false})
    end
    for i = 1, 12 do
        objects.Box3DLines[i] = CreateDrawInstance("Line", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Box, Visible = false})
    end
    for i = 1, 8 do
        objects.CornerBoxLines[i] = CreateDrawInstance("Line", {Thickness = 2, Color = _G.Settings.Visuals.Colors.Box, Visible = false})
    end
    for i = 1, 16 do
        objects.ChineseHatLines[i] = CreateDrawInstance("Line", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Name, Visible = false})
    end
    objects.HeadDot = CreateDrawInstance("Circle", {Thickness = 1, Radius = 4, Filled = true, Visible = false})
    objects.LookTracer = CreateDrawInstance("Line", {Thickness = 1, Color = _G.Settings.Visuals.Colors.Tracer, Visible = false})
    _CONNECTIONS[player.Name .. "_CharAdded"] = TrackConnection(player.CharacterAdded:Connect(function(char)
        if _ESP_CACHE[player] then
            ClearAllVisibility(_ESP_CACHE[player])
        end
        task.wait(0.1)
    end))
    _ESP_CACHE[player] = objects
end

local function UnregisterPlayerVisuals(player)
    local connKey = player.Name .. "_CharAdded"
    if _CONNECTIONS[connKey] then
        _CONNECTIONS[connKey]:Disconnect()
        _CONNECTIONS[connKey] = nil
    end
    local objects = _ESP_CACHE[player]
    if objects then
        for key, value in pairs(objects) do
            if key == "SkeletonLines" or key == "Box3DLines" or key == "CornerBoxLines" or key == "ChineseHatLines" then
                for _, line in ipairs(value) do pcall(function() line:Remove() end) end
            else
                pcall(function() value:Remove() end)
            end
        end
        _ESP_CACHE[player] = nil
    end
    _INVENTORY_CACHE[player] = nil
    _INVENTORY_CACHE_TIME[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do
    RegisterPlayerVisuals(p)
end
_CONNECTIONS.PlayerAdded = TrackConnection(Players.PlayerAdded:Connect(RegisterPlayerVisuals))
_CONNECTIONS.PlayerRemoving = TrackConnection(Players.PlayerRemoving:Connect(UnregisterPlayerVisuals))

local function AtualizarESP(Player, Objects, RootPos, FrameData, boxColor, elementColor)
    local Char = Player.Character
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    if not Char or not Hum or not Objects or not FrameData then return end
    if not Objects.HealthBar or not Objects.HealthBack or not Objects.Tracer then return end

    local X, Y, W, H = FrameData.X, FrameData.Y, FrameData.W, FrameData.H
    local FeetS = FrameData.FeetS
    local Distance = FrameData.Distance
    local rainbowColor = nil
    if _G.Settings.Visuals.Rainbow then
        local hue = (tick() * 0.2 + (Player.UserId or 0) * 0.001) % 1
        rainbowColor = Color3.fromHSV(hue, 1, 1)
    end
    local boxEspColor = rainbowColor or elementColor or boxColor

    UpdateFull3DBox(Objects.Box3DLines, Char, boxEspColor)
    UpdateCornerBox(Objects.CornerBoxLines, FrameData, boxEspColor)
    UpdateChineseHat(Objects.ChineseHatLines, Char, rainbowColor or _G.Settings.Visuals.Colors.Name)

    local selectedBoxType = _G.Settings.Visuals.BoxType or "2D"
    local boxVisible = _G.Settings.Visuals.BoxEnabled and (selectedBoxType == "2D" or selectedBoxType == "None")
    Objects.Box.Visible = boxVisible
    Objects.BoxOutline.Visible = boxVisible
    if boxVisible then
        local boxSize = Vector2.new(W, H)
        local boxPos = Vector2.new(X, Y)
        Objects.Box.Size = boxSize
        Objects.Box.Position = boxPos
        Objects.Box.Color = boxEspColor
        pcall(function()
            Objects.Box.Thickness = 1
            Objects.BoxOutline.Thickness = 2
            Objects.BoxOutline.Color = Color3.fromRGB(8, 8, 12)
        end)
        Objects.BoxOutline.Size = boxSize
        Objects.BoxOutline.Position = boxPos
    end

    local nameVisible = _G.Settings.Visuals.Names
    if Objects.Name then
        Objects.Name.Visible = nameVisible
        if nameVisible and Player and Player.Name then
            Objects.Name.Text = Player.Name:lower()
            Objects.Name.Position = Vector2.new(RootPos.X, math.max(Y - 14, 0))
            Objects.Name.Color = rainbowColor or _G.Settings.Visuals.Colors.Name
        end
    end

    local playtimeVisible = _G.Settings.Visuals.Playtime
    if Objects.Playtime then
        Objects.Playtime.Visible = playtimeVisible
        if playtimeVisible then
            local minutos = Player:GetAttribute("TempoJogadoMin")
            if minutos and type(minutos) == "number" then
                Objects.Playtime.Text = formatPlaytime(minutos)
            else
                Objects.Playtime.Text = "N/A"
            end
            local nameY = _G.Settings.Visuals.Names and (math.max(Y - 14, 0)) or (math.max(Y - 14, 0))
            Objects.Playtime.Position = Vector2.new(RootPos.X, nameY - 14)
            Objects.Playtime.Color = Color3.fromRGB(255, 255, 0)
        end
    end

    local healthTextVisible = _G.Settings.Visuals.HealthText == true
    if Objects.HealthText then
        Objects.HealthText.Visible = healthTextVisible
        if healthTextVisible then
            Objects.HealthText.Text = string.format("HP: %d/%d", math.floor(Hum.Health), math.floor(Hum.MaxHealth))
            Objects.HealthText.Position = Vector2.new(RootPos.X, FeetS.Y + 16)
            Objects.HealthText.Color = _G.Settings.Visuals.Colors.Health
        end
    end

    local inventoryVisible = _G.Settings.Visuals.Inventory == true
    if Objects.Inventory then
        Objects.Inventory.Visible = inventoryVisible
        if inventoryVisible then
            Objects.Inventory.Text = GetPublicInventoryText(Player)
            Objects.Inventory.Position = Vector2.new(RootPos.X, Y - 42)
            Objects.Inventory.Color = Color3.fromRGB(170, 220, 255)
        end
    end

    local distVisible = _G.Settings.Visuals.Distance
    if Objects.Dist then
        Objects.Dist.Visible = distVisible
        if distVisible and Distance then
            Objects.Dist.Text = "[" .. math.floor(Distance) .. "m]"
            Objects.Dist.Position = Vector2.new(RootPos.X, FeetS.Y + 2)
            Objects.Dist.Color = rainbowColor or _G.Settings.Visuals.Colors.Distance
        end
    end

    local healthVisible = _G.Settings.Visuals.HealthBar
    Objects.HealthBar.Visible = healthVisible
    Objects.HealthBack.Visible = healthVisible
    if healthVisible then
        local HP = math.clamp(Hum.Health / Hum.MaxHealth, 0, 1)
        Objects.HealthBack.Size = Vector2.new(2, H)
        Objects.HealthBack.Position = Vector2.new(X - 5, Y)
        Objects.HealthBar.Size = Vector2.new(2, H * HP)
        Objects.HealthBar.Position = Vector2.new(X - 5, FeetS.Y - (H * HP))
        if _G.Settings.Visuals.HealthGradient then
            local r = math.clamp(2 * (1 - HP), 0, 1)
            local g = math.clamp(2 * HP, 0, 1)
            Objects.HealthBar.Color = Color3.new(r, g, 0)
        else
            Objects.HealthBar.Color = _G.Settings.Visuals.Colors.Health
        end
    end

    local tracerVisible = _G.Settings.Visuals.Tracers
    Objects.Tracer.Visible = tracerVisible
    if tracerVisible then
        local tracerOrigin = _G.Settings.Visuals.TracerOrigin or "Baixo"
        local fromY = tracerOrigin == "Cima" and 0 or CurrentCamera.ViewportSize.Y
        Objects.Tracer.From = Vector2.new(CurrentCamera.ViewportSize.X / 2, fromY)
        Objects.Tracer.To = Vector2.new(RootPos.X, FeetS.Y)
        Objects.Tracer.Color = rainbowColor or _G.Settings.Visuals.Colors.Tracer
    end

    if Objects.HeadDot then
        local showDot = _G.Settings.Visuals.HeadDot == true
        Objects.HeadDot.Visible = showDot
        if showDot then
            local head = Char:FindFirstChild("Head")
            if head then
                local headScreen, onScreen = CurrentCamera:WorldToViewportPoint(head.Position)
                if onScreen then
                    Objects.HeadDot.Position = Vector2.new(headScreen.X, headScreen.Y)
                    Objects.HeadDot.Color = rainbowColor or boxEspColor
                else
                    Objects.HeadDot.Visible = false
                end
            else
                Objects.HeadDot.Visible = false
            end
        end
    end

    if Objects.LookTracer then
        local showLook = _G.Settings.Visuals.LookTracer == true
        Objects.LookTracer.Visible = showLook
        if showLook then
            local head = Char:FindFirstChild("Head")
            if head then
                local headPos = head.Position
                local lookPos = headPos + head.CFrame.LookVector * 5
                local h1, on1 = CurrentCamera:WorldToViewportPoint(headPos)
                local h2, on2 = CurrentCamera:WorldToViewportPoint(lookPos)
                if on1 or on2 then
                    Objects.LookTracer.From = Vector2.new(h1.X, h1.Y)
                    Objects.LookTracer.To = Vector2.new(h2.X, h2.Y)
                    Objects.LookTracer.Color = rainbowColor or _G.Settings.Visuals.Colors.Tracer
                else
                    Objects.LookTracer.Visible = false
                end
            else
                Objects.LookTracer.Visible = false
            end
        end
    end

    if _G.Settings.Visuals.Skeleton then
        local Rig = (Hum.RigType == Enum.HumanoidRigType.R15) and "R15" or "R6"
        local ConnectionList = SKELETON_BONES[Rig]
        for i, Bone in ipairs(ConnectionList) do
            local p1, p2 = Char:FindFirstChild(Bone[1]), Char:FindFirstChild(Bone[2])
            local targetLine = Objects.SkeletonLines[i]
            if p1 and p2 and targetLine then
                local a, aOn = CurrentCamera:WorldToViewportPoint(p1.Position)
                local b, bOn = CurrentCamera:WorldToViewportPoint(p2.Position)
                if aOn and bOn then
                    targetLine.Visible = true
                    targetLine.From = Vector2.new(a.X, a.Y)
                    targetLine.To = Vector2.new(b.X, b.Y)
                    targetLine.Color = rainbowColor or _G.Settings.Visuals.Colors.Skeleton
                else
                    targetLine.Visible = false
                end
            elseif targetLine then
                targetLine.Visible = false
            end
        end
    else
        for _, line in ipairs(Objects.SkeletonLines) do
            line.Visible = false
        end
    end
end

_CONNECTIONS.MasterRenderLoop = TrackConnection(RunService.RenderStepped:Connect(function()
    if not _G.Settings.Visuals.Enabled then
        for _, objects in pairs(_ESP_CACHE) do
            ClearAllVisibility(objects)
        end
        return
    end

    CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then return end
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localChar or not localHRP then return end
    local camCFrame = CurrentCamera.CFrame

    for player, objects in pairs(_ESP_CACHE) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hrp and hum and hum.Health > 0 then
            if player == LocalPlayer and not _G.Settings.Visuals.ShowLocalPlayer then
                ClearAllVisibility(objects)
                continue
            end
            if player ~= LocalPlayer and _G.Settings.Combat.OrgCheck and IsSameOrg(player) then
                ClearAllVisibility(objects)
                continue
            end
            local distance = (camCFrame.Position - hrp.Position).Magnitude
            if distance <= _G.Settings.Visuals.MaxDistance then
                local rootPos, onScreen = CurrentCamera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local boxColor
                    if player == LocalPlayer then
                        boxColor = Color3.fromRGB(0, 255, 255)
                    elseif _G.Settings.Friends[player.UserId] then
                        boxColor = _G.Settings.Visuals.Colors.Friend
                    else
                        boxColor = _G.Settings.Visuals.Colors.Enemy
                    end

                    local elementColor = boxColor
                    if _G.Settings.Visuals.VisibilityCheck and player ~= LocalPlayer then
                        local isVisible = true
                        if localHRP then
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                            raycastParams.FilterDescendantsInstances = {localChar, char}
                            local ray = Workspace:Raycast(camCFrame.Position, hrp.Position - camCFrame.Position, raycastParams)
                            if ray then
                                isVisible = false
                            end
                        end
                        if isVisible then
                            elementColor = Color3.fromRGB(0, 255, 0)
                        else
                            elementColor = _G.Settings.Visuals.Colors.Invisible
                        end
                    end

                    local head = char:FindFirstChild("Head")
                    local headPos = head and CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0)) or Vector3.new(rootPos.X, rootPos.Y - 2, 0)
                    local feetPos = CurrentCamera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 4, 0))
                    local height = math.abs(headPos.Y - feetPos.Y)
                    local width = height / 2
                    local frameData = {
                        X = rootPos.X - (width / 2),
                        Y = headPos.Y,
                        W = width,
                        H = height,
                        FeetS = feetPos,
                        Distance = distance
                    }
                    AtualizarESP(player, objects, rootPos, frameData, boxColor, elementColor)
                else
                    ClearAllVisibility(objects)
                end
            else
                ClearAllVisibility(objects)
            end
        else
            ClearAllVisibility(objects)
        end
    end
end))

local function GetMainGui()
    return FindMainMenuGui()
end

local function CreateMinimizeButton()
    local button = Instance.new("TextButton")
    button.Name = "MinimizeButton"
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(1, -60, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.4
    button.Text = "─"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 26
    button.Font = Enum.Font.SourceSansBold
    button.ZIndex = 999
    button.Parent = LocalPlayer.PlayerGui
    button.MouseButton1Down:Connect(function()
        button.BackgroundTransparency = 0.1
    end)
    button.MouseButton1Up:Connect(function()
        button.BackgroundTransparency = 0.4
    end)
    button.MouseButton1Click:Connect(function()
        local mainGui = GetMainGui()
        if mainGui then
            mainGui.Enabled = not mainGui.Enabled
            if mainGui.Enabled then
                button.Text = "─"
            else
                button.Text = "⬜"
            end
        else
            warn("GUI principal não encontrada!")
        end
    end)
    return button
end

if UserInputService.TouchEnabled then
    task.wait(0.5)
    CreateMinimizeButton()
    print("Botão de minimizar ativado para mobile!")
end

local ArmasSection1 = ArmasTab:AddSection("Modificadores de Arma")
ArmasSection1:AddToggle("No Recoil", false, "NoRecoilToggle", function(Value)
    WeaponsMod.NoRecoil = Value
end)
ArmasSection1:AddToggle("Zero Spread", false, "ZeroSpreadToggle", function(Value)
    WeaponsMod.ZeroSpread = Value
end)
ArmasSection1:AddToggle("Municao Infinita", false, "InfAmmoToggle", function(Value)
    WeaponsMod.InfAmmo = Value
end)

local ArmasSection2 = ArmasTab:AddSection("Dano 999")
ArmasSection2:AddToggle("Dano 999 (one-shot)", false, "Damage999Toggle", function(Value)
    Damage999.Enabled = Value
end)
ArmasSection2:AddLabel("Amplifica hits via WeaponFired para matar em 1 tiro")

local ArmasSection3 = ArmasTab:AddSection("Wallbang")
ArmasSection3:AddToggle("Balas Atravessam Paredes", false, "WallbangToggle", function(Value)
    Wallbang.Enabled = Value
end)
ArmasSection3:AddLabel("Penetrate cast - balas ignoram geometria")

local FarmSection1 = FarmTab:AddSection("Auto Farm Prisao")
local farmPrisaoStatus = FarmSection1:AddLabel("Status: Parado")
FarmPrisao.setStatus = function(txt) farmPrisaoStatus:Set("Status Prisao: " .. tostring(txt)) end
FarmSection1:AddToggle("Farm Prisao", false, "FarmPrisaoToggle", function(Value)
    if Value then FarmPrisao.startFarm() else FarmPrisao.stopFarm() end
end)
FarmSection1:AddLabel("Faz ciclo entre Ponto A e Ponto B automaticamente")

local FarmSection2 = FarmTab:AddSection("Auto Farm Pizzaria")
local farmPizzaStatus = FarmSection2:AddLabel("Status: Parado")
FarmPizza.setStatus = function(txt) farmPizzaStatus:Set("Status Pizza: " .. tostring(txt)) end
FarmSection2:AddToggle("Farm Pizza", false, "FarmPizzaToggle", function(Value)
    if Value then FarmPizza.startFarm() else FarmPizza.stopFarm() end
end)
FarmSection2:AddLabel("Entrega pedidos de pizza automaticamente")

local FarmSection3 = FarmTab:AddSection("Auto Farm Lixeiro")
local farmLixStatus = FarmSection3:AddLabel("Status: Parado")
FarmLixeiro.setStatus = function(txt) farmLixStatus:Set("Status Lixeiro: " .. tostring(txt)) end
FarmSection3:AddButton("Salvar Posicao Entrega", function()
    local hrp = FarmLixeiro.getHRP()
    if hrp then FarmLixeiro.SavedPos = hrp.CFrame; Library:Notify("Farm", "Posicao salva!", 2, "Success") end
end)
FarmSection3:AddToggle("Farm Lixeiro", false, "FarmLixToggle", function(Value)
    if Value then FarmLixeiro.startFarm() else FarmLixeiro.stopFarm() end
end)