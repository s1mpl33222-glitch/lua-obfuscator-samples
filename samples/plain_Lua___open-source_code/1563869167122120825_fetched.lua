-- This script is almost entirely made by AI so you may run into issues, please report issues in the Discord.
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
-- Join the Discord with this link: https://discord.gg/NyYzt9XVd9

local MONOUI_SOURCE = [==[
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local GuiService       = game:GetService("GuiService")

if getgenv and getgenv().MONOUI_CLEANUP then pcall(getgenv().MONOUI_CLEANUP) end
local CONNS = {}
local function keep(c) table.insert(CONNS, c) return c end

local function sig(s)
    return { Connect = function(_, fn) return keep(s:Connect(fn)) end }
end
if getgenv then
    getgenv().MONOUI_CLEANUP = function()
        for _, c in ipairs(CONNS) do pcall(function() c:Disconnect() end) end
        table.clear(CONNS)
    end
end

local Lucide
pcall(function()
    Lucide = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/mstudio45/lucide-roblox-direct/refs/heads/main/source.lua"))()
end)

local T = {
    root       = Color3.fromRGB(24, 24, 24),
    panel      = Color3.fromRGB(30, 30, 30),
    panelHover = Color3.fromRGB(37, 37, 37),
    inset      = Color3.fromRGB(28, 28, 28),
    stroke     = Color3.fromRGB(40, 40, 40),
    strokeSoft = Color3.fromRGB(34, 34, 34),
    text       = Color3.fromRGB(255, 255, 255),
    sub        = Color3.fromRGB(150, 150, 150),
    dim        = Color3.fromRGB(108, 108, 108),
    faint      = Color3.fromRGB(84, 84, 84),
    descText   = Color3.fromRGB(124, 124, 124),
    star       = Color3.fromRGB(205, 205, 205),

    onTrack    = Color3.fromRGB(205, 205, 205),
    onKnob     = Color3.fromRGB(240, 240, 240),
    offTrack   = Color3.fromRGB(52, 52, 52),
    offKnob    = Color3.fromRGB(240, 240, 240),
}

local FAMILIES = {
    ["Builder Sans"] = { Enum.Font.BuilderSans, Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold },
    ["Gotham"]       = { Enum.Font.Gotham,      Enum.Font.GothamMedium,      Enum.Font.GothamBold },
    ["Source Sans"]  = { Enum.Font.SourceSans,  Enum.Font.SourceSansSemibold, Enum.Font.SourceSansBold },
    ["Ubuntu"]       = { Enum.Font.Ubuntu,      Enum.Font.Ubuntu,            Enum.Font.Ubuntu },
}
local FAMILY_ORDER = { "Builder Sans", "Gotham", "Source Sans", "Ubuntu" }
local FONT_REG, FONT, FONT_BOLD = table.unpack(FAMILIES["Builder Sans"])

local TextService = game:GetService("TextService")
local MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
local TEXT_SCALE = MOBILE and 1.42 or 1.15

local ROW_H         = MOBILE and 78 or 62
local ROW_H_COMPACT = MOBILE and 58 or 44
local CAT_H         = MOBILE and 52 or 40
local SEARCH_H      = MOBILE and 54 or 42
local TRACK_W       = MOBILE and 52 or 38
local TRACK_H       = MOBILE and 28 or 22
local KNOB_D        = MOBILE and 20 or 16
local KNOB_PAD      = MOBILE and 4 or 3
local KNOB_ON       = TRACK_W - KNOB_D - KNOB_PAD
local HIT           = MOBILE and 34 or 24
local GLYPH         = MOBILE and 36 or 24
local CHIP_H        = MOBILE and 28 or 22
local CHIP_PAD      = MOBILE and 12 or 10
local CHIP_MIN      = CHIP_H + 10

local function lum(c) return 0.299 * c.R + 0.587 * c.G + 0.114 * c.B end
local function contrastKnob(track)
    return lum(track) > 0.5 and Color3.fromRGB(26, 26, 26) or Color3.fromRGB(240, 240, 240)
end

local EASE  = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local FAST  = TweenInfo.new(0.14, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)

local OPEN  = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local CLOSE = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local WIN_FADE = TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ANIM = { on = true }
local BLOCKED = { on = false }
local function tw(o, ti, p)
    if not ANIM.on then

        for k, v in pairs(p) do pcall(function() o[k] = v end) end
        return nil
    end
    local t = TweenService:Create(o, ti, p) t:Play() return t
end

local KEY_SHORT = {
    LeftShift = "LSHIFT", RightShift = "RSHIFT", LeftControl = "LCTRL", RightControl = "RCTRL",
    LeftAlt = "LALT", RightAlt = "RALT", Space = "SPACE", Backspace = "BSPACE",
    Return = "ENTER", Delete = "DEL", Insert = "INS", PageUp = "PGUP", PageDown = "PGDN",
    CapsLock = "CAPS", Tab = "TAB", Up = "UP", Down = "DOWN", Left = "LEFT", Right = "RIGHT",
    MouseButton1 = "LMB", MouseButton2 = "RMB", MouseButton3 = "MMB",
    MouseWheelUp = "WHEELUP", MouseWheelDown = "WHEELDN",
}

local function spaceName(s)
    s = s:gsub("(%l)(%u)", "%1 %2")
    s = s:gsub("(%u)(%u%l)", "%1 %2")
    return s
end

local function keyLabel(name)
    if not name then return nil end
    return KEY_SHORT[name] or name:upper()
end

local SQUIRCLE = { img = "rbxassetid://89641024074289", rect = Rect.new(460,460,460,460), radius = 310 }
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
local SQ_OUTLINE = { img = "rbxassetid://74029063732681", rect = Rect.new(512,512,512,512), radius = 310 }

local NAME_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local function randName(min, max)
    local n = math.random(min or 12, max or 22)
    local b = table.create(n)
    for i = 1, n do
        local k = math.random(1, #NAME_CHARS)
        b[i] = NAME_CHARS:sub(k, k)
    end
    return table.concat(b)
end

local BASE_PROPS = {
    "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency",
    "ImageTransparency", "ScrollBarImageTransparency", "Transparency",
}

local BASE_BY_CLASS = {}
local function basePropsFor(class)
    local list = BASE_BY_CLASS[class]
    if list then return list end
    list = {}
    local made, probe = pcall(Instance.new, class)
    if made then
        for i = 1, #BASE_PROPS do
            local prop = BASE_PROPS[i]
            local ok, v = pcall(function() return probe[prop] end)
            if ok and type(v) == "number" then
                list[#list + 1] = { prop, "_base_" .. prop }
            end
        end
        probe:Destroy()
        BASE_BY_CLASS[class] = list
    end
    return list
end

local function recordBase(o)
    local list = basePropsFor(o.ClassName)
    for i = 1, #list do
        local e = list[i]
        o:SetAttribute(e[2], o[e[1]])
    end
end

local function new(class, props, kids)
    local o = Instance.new(class)
    o.Name = randName()
    for k, v in pairs(props or {}) do if k ~= "Parent" then o[k] = v end end
    recordBase(o)
    for _, c in ipairs(kids or {}) do c.Parent = o end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end

local function mountPoint()
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and typeof(h) == "Instance" then return h end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end
    if typeof(get_hidden_gui) == "function" then
        local ok, h = pcall(get_hidden_gui)
        if ok and typeof(h) == "Instance" then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then
        local ok2 = pcall(function() return #cg:GetChildren() end)
        if ok2 then return cg end
    end
    local lp = Players.LocalPlayer
    return lp and lp:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
end

local function protect(gui)
    local fns = {}
    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then fns[#fns + 1] = syn.protect_gui end
    if typeof(protectgui) == "function" then fns[#fns + 1] = protectgui end
    if typeof(protect_gui) == "function" then fns[#fns + 1] = protect_gui end
    for _, fn in ipairs(fns) do
        if pcall(fn, gui) then return end
    end
end

local function panel(props, radius)
    radius = radius or 8
    local p = { BackgroundColor3 = T.panel, BorderSizePixel = 0 }
    local class = "Frame"
    for k, v in pairs(props or {}) do
        if k == "Class" then class = v else p[k] = v end
    end
    if class == "ImageButton" or class == "TextButton" then
        p.AutoButtonColor = false
        if class == "TextButton" then p.Text = p.Text or "" end
    end
    local o = new(class, p)
    new("UICorner", { CornerRadius = UDim.new(0, radius), Parent = o })
    return o
end

local function fadeEnds(inst, vertical, head, tail)
    head = head or 0.12
    tail = tail or 0.12
    return new("UIGradient", {
        Rotation = vertical and 90 or 0, Parent = inst,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(head, 0),
            NumberSequenceKeypoint.new(1 - tail, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
    })
end

local SCROLLERS = {}
local SMOOTH = { scroll = true, drag = false }
local WHEEL_IMPULSE = 950
local SCROLL_DECAY = 7
local SCROLL_MAX_VEL = 9000

-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
local function shownOnScreen(o)
    local node = o
    while node and node:IsA("GuiObject") do
        if not node.Visible then return false end
        node = node.Parent
    end
    return node ~= nil
end

local function scrollerAt(x, y)
    local best, bestZ = nil, -math.huge
    for i = 1, #SCROLLERS do
        local e = SCROLLERS[i]
        local sf = e.sf
        if sf.Parent and not e.frozen and shownOnScreen(sf) then
            local p, sz = sf.AbsolutePosition, sf.AbsoluteSize
            if x >= p.X and x <= p.X + sz.X and y >= p.Y and y <= p.Y + sz.Y then
                local z = sf.ZIndex
                if z >= bestZ then best, bestZ = e, z end
            end
        end
    end
    return best
end

local function maxScroll(sf, horiz)
    if horiz then return math.max(0, sf.AbsoluteCanvasSize.X - sf.AbsoluteWindowSize.X) end
    return math.max(0, sf.AbsoluteCanvasSize.Y - sf.AbsoluteWindowSize.Y)
end

local function stepScrollers(dt)
    local d = math.min(dt, 0.05)
    local k = math.exp(-SCROLL_DECAY * d)
    for i = 1, #SCROLLERS do
        local e = SCROLLERS[i]
        local sf = e.sf
        if sf.Parent and e.vel and e.vel ~= 0 then
            local horiz = e.horizontal
            local lim = maxScroll(sf, horiz)
            local cur = horiz and sf.CanvasPosition.X or sf.CanvasPosition.Y
            local nxt = cur + e.vel * d
            e.vel = e.vel * k
            if nxt <= 0 then
                nxt, e.vel = 0, 0
            elseif nxt >= lim then
                nxt, e.vel = lim, 0
            elseif math.abs(e.vel) < 3 then
                e.vel = 0
            end
            sf.CanvasPosition = horiz and Vector2.new(nxt, 0) or Vector2.new(0, nxt)
        end
    end
end

local function scrollerEntry(sf)
    for i = 1, #SCROLLERS do
        if SCROLLERS[i].sf == sf then return SCROLLERS[i] end
    end
end

-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
local function customScrollbar(sf, inset)
    sf.ScrollBarThickness = 0
    local bar = new("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -(inset or 2), 0, 0),
        Size = UDim2.fromOffset(3, 0),
        BackgroundColor3 = T.stroke, BackgroundTransparency = 0.25,
        BorderSizePixel = 0, Visible = false, ZIndex = 30, Parent = sf.Parent,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
    local grad = fadeEnds(bar, true, 0.18, 0.18)
    sf.ScrollingEnabled = true
    SCROLLERS[#SCROLLERS + 1] = { sf = sf, bar = bar, grad = grad, inset = inset or 2 }
    return bar
end

local function updateScrollbars()
    for i = 1, #SCROLLERS do
        local e = SCROLLERS[i]
        local sf, bar = e.sf, e.bar
        if sf.Parent and bar.Parent then
            local horiz = e.horizontal
            if e.wasHoriz ~= horiz then
                e.wasHoriz = horiz
                e.h, e.pos = nil, nil
                bar.AnchorPoint = horiz and Vector2.new(0, 0) or Vector2.new(1, 0)
                if e.grad then e.grad.Rotation = horiz and 0 or 90 end
            end
            local view   = horiz and sf.AbsoluteWindowSize.X or sf.AbsoluteWindowSize.Y
            local canvas = horiz and sf.AbsoluteCanvasSize.X or sf.AbsoluteCanvasSize.Y
            if canvas <= view + 1 or view < 1 then
                if bar.Visible then bar.Visible = false end
            else
                local h = math.max(24, math.floor(view * view / canvas))
                local at = horiz and sf.CanvasPosition.X or sf.CanvasPosition.Y
                local prog = math.clamp(at / (canvas - view), 0, 1)
                local rel = sf.AbsolutePosition - sf.Parent.AbsolutePosition
                local p = math.floor((horiz and rel.X or rel.Y) + (view - h) * prog)
                if not bar.Visible then bar.Visible = true end
                if e.h ~= h then
                    e.h = h
                    bar.Size = horiz and UDim2.fromOffset(h, 3) or UDim2.fromOffset(3, h)
                end
                if e.pos ~= p then
                    e.pos = p
                    if horiz then
                        bar.Position = UDim2.fromOffset(p,
                            math.floor(rel.Y + sf.AbsoluteWindowSize.Y - 3 - e.inset))
                    else
                        bar.Position = UDim2.new(1, -e.inset, 0, p)
                    end
                end
            end
        end
    end
end

local function stroke(parent, color, radius, transparency)
    local st = new("UIStroke", {
        Color = color or T.stroke, Thickness = 1,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Transparency = transparency or 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    })

    st:SetAttribute("BaseTransparency", st.Transparency)
    return st
end

local function text(props)
    local p = {
        BackgroundTransparency = 1, Font = FONT, TextColor3 = T.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do p[k] = v end
    local base = p.TextSize or 14
    p.TextSize = math.floor(base * TEXT_SCALE + 0.5)
    local o = new("TextLabel", p)
    o:SetAttribute("FontRole", p.Font == FONT_BOLD and "bold" or (p.Font == FONT_REG and "reg" or "med"))

    o:SetAttribute("BaseTextSize", base)
    return o
end

local iconCache = {}
local function iconAsset(name)
    local a = iconCache[name]
    if a == nil then
        a = (Lucide and Lucide.GetAsset(name)) or false
        iconCache[name] = a
    end
    return a or nil
end

local function setIcon(im, name)
    local a = iconAsset(name)
    if a then im.Image = a.Url; im.ImageRectOffset = a.ImageRectOffset; im.ImageRectSize = a.ImageRectSize end
    return im
end

local function icon(name, props)

    local p = { BackgroundTransparency = 1, ImageColor3 = T.dim, Size = UDim2.fromOffset(24, 24) }
    for k, v in pairs(props or {}) do p[k] = v end
    return setIcon(new("ImageLabel", p), name)
end

local MonoUI = {}
MonoUI.__index = MonoUI

function MonoUI.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, MonoUI)
    self.cfg = cfg
    self.categories, self.tabs, self.allModules = {}, {}, {}
    self.sections, self._order = {}, 0
    self.activeCategory, self.activeTab = nil, nil
    self.search = ""

    local mount = mountPoint()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    if getgenv and getgenv().__mono_gui then
        pcall(function() getgenv().__mono_gui:Destroy() end)
    end
    self.gui = new("ScreenGui", {
        ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    protect(self.gui)
    self.gui.Parent = mount
    if getgenv then
        getgenv().__mono_gui = self.gui
        getgenv().MONOUI = self
    end
    if STATE and STATE.onCleanup then
        local g = self.gui; STATE.onCleanup(function() pcall(function() g:Destroy() end) end)
    end

    local W, H = cfg.Width or 820, cfg.Height or 520
    if MOBILE then
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 500)
        local inset = GuiService:GetGuiInset()
        W = math.floor(math.min(vp.X - 24, 1100))
        H = math.floor(math.min(vp.Y - inset.Y - 24, 720))
    end
    self.root = panel({
        Class = "CanvasGroup",
        AnchorPoint = Vector2.new(0, 0), Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(W, H), BackgroundColor3 = T.root, ZIndex = 2, Parent = self.gui,
    }, 10)
    self.rootStroke = stroke(self.root, T.strokeSoft, 10, 0.3)

    function self:Recenter()
        local space = self.gui.AbsoluteSize
        if space.X < 1 then
            space = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                or Vector2.new(1280, 720)
        end
        local rw, rh = self.root.AbsoluteSize.X, self.root.AbsoluteSize.Y
        if rw < 1 then rw, rh = W, H end

        local inset = GuiService:GetGuiInset()
        local usableY = space.Y - inset.Y
        self.root.Position = UDim2.fromOffset(
            math.floor((space.X - rw) / 2 + 0.5),
            inset.Y + math.floor((usableY - rh) / 2 + 0.5))
    end
    self:Recenter()

    task.defer(function() self:Recenter() end)

    local TOPBAR_H = 86
    local LOGO_ROW  = 52
    local top = new("Frame", {
        Size = UDim2.new(1, 0, 0, TOPBAR_H), BackgroundTransparency = 1,
        ZIndex = 3, Parent = self.root,
    })

    local brandRow = new("Frame", {
        Position = UDim2.fromOffset(22, 0), Size = UDim2.new(0, 0, 0, LOGO_ROW),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        ZIndex = 4, Parent = top,
    })
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = brandRow,
    })

    local function resolveLogo()
        local L = cfg.Logo
        if L and L:match("^rbxassetid?://") then return L end

        local canFile = typeof(getcustomasset) == "function" and typeof(writefile) == "function"
        if cfg.LogoUrl and canFile then
            local path = cfg.LogoCache or "Mono MM2/logo.png"
            local folder = path:match("^(.*)/[^/]+$")
            if folder and typeof(isfolder) == "function" and not isfolder(folder) then
                pcall(makefolder, folder)
            end

            if not (typeof(isfile) == "function" and isfile(path)) then
                local ok, data = pcall(function() return game:HttpGet(cfg.LogoUrl, true) end)

                if ok and type(data) == "string" and data:sub(2, 4) == "PNG" then
                    pcall(writefile, path, data)
                end
            end
            if typeof(isfile) == "function" and isfile(path) then
                local ok, id = pcall(getcustomasset, path)
                if ok then return id end
            end
        end

        if L and canFile and typeof(isfile) == "function" and isfile(L) then
            local ok, id = pcall(getcustomasset, L)
            if ok then return id end
        end
        return nil
    end
    local logoId = resolveLogo()
    self.logoId = logoId

    local brand
    if logoId then
        local h = cfg.LogoHeight or 24
        brand = new("ImageLabel", {
            Image = logoId, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromOffset(math.floor(h * (cfg.LogoAspect or 3) + 0.5), h),
            LayoutOrder = 1, ZIndex = 4, Parent = brandRow,
        })
    else
        brand = text({
            Text = cfg.Title or "MONO", Font = FONT_BOLD, TextSize = 18, TextColor3 = T.text,
            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
            LayoutOrder = 1, ZIndex = 4, Parent = brandRow,
        })
    end
    if not logoId and cfg.Version then
        local badge = panel({
            Size = UDim2.fromOffset(27, 16), BackgroundColor3 = Color3.fromRGB(48, 48, 48),
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            LayoutOrder = 2, ZIndex = 4, Parent = brandRow,
        }, 4)
        text({
            Text = cfg.Version, Font = FONT_BOLD, TextSize = 10, TextColor3 = T.sub,
            Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 6, Parent = badge,
        })
    end

    local tabHolder = new("Frame", {
        Position = UDim2.fromOffset(22, LOGO_ROW), Size = UDim2.new(1, -44, 0, TOPBAR_H - LOGO_ROW),
        BackgroundTransparency = 1, ZIndex = 3, Parent = top,
    })
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 30), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabHolder,
    })
    self.tabHolder = tabHolder

    local function iconRow(width, gap)
        local f = new("Frame", {
            Size = UDim2.fromOffset(width, LOGO_ROW), BackgroundTransparency = 1,
            ZIndex = 3, Parent = top,
        })
        new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, gap), Parent = f,
        })
        return f
    end
    local TOOL_W, WIN_W = HIT * 2 + 18, HIT * 3 + 12 * 2
    self.midIcons = iconRow(TOOL_W, 18)
    self.winIcons = iconRow(WIN_W, 12)
    self.winIcons.Position = UDim2.new(1, -WIN_W - 18, 0, 0)

    local function topIcon(parent, name, cb, hoverColor)
        local b = new("TextButton", {
            Size = UDim2.fromOffset(HIT, HIT), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, LayoutOrder = #parent:GetChildren(),
            ZIndex = 4, Parent = parent,
        })
        local im = icon(name, {
            Size = UDim2.fromOffset(GLYPH, GLYPH), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.dim, ZIndex = 5, Parent = b,
        })
        b.MouseEnter:Connect(function()
            if BLOCKED.on then return end
            tw(im, FAST, { ImageColor3 = hoverColor or T.text })
        end)
        b.MouseLeave:Connect(function()
            tw(im, FAST, { ImageColor3 = im:GetAttribute("Active") and T.star or T.dim })
        end)
        if cb then b.MouseButton1Click:Connect(cb) end
        return b, im
    end
    self.refreshImg = select(2, topIcon(self.midIcons, "refresh-cw", function() self:Reload() end))
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    self.layoutImg = select(2, topIcon(self.midIcons, "panels-top-left", function()
        self:SetCompact(not self.compact)
    end))
    topIcon(self.winIcons, "minus", function() self:Minimize() end)
    self.fullImg = select(2, topIcon(self.winIcons, "maximize", function() self:ToggleFullscreen() end))

    topIcon(self.winIcons, "x", function()
        if self.onCloseRequest then self.onCloseRequest() else self:Destroy() end
    end, Color3.fromRGB(255, 92, 92))

    local topRule = new("Frame", {
        Position = UDim2.fromOffset(0, TOPBAR_H), Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = T.stroke, BackgroundTransparency = 0.35,
        BorderSizePixel = 0, ZIndex = 5, Parent = self.root,
    })

    new("UIGradient", {
        Parent = topRule,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.04, 0),
            NumberSequenceKeypoint.new(0.96, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
    })

    local SIDE_W = MOBILE and 196 or 205
    local side = new("Frame", {
        Position = UDim2.fromOffset(0, TOPBAR_H + 13), Size = UDim2.new(0, SIDE_W, 1, -TOPBAR_H - 13),
        BackgroundTransparency = 1, ZIndex = 3, Parent = self.root,
    })
    self.catHeader = text({
        Text = "Categories", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(18, 4), Size = UDim2.fromOffset(160, 20),
        ZIndex = 4, Parent = side,
    })
    self.side = side
    self.SIDE_W, self.TOPBAR_H = SIDE_W, TOPBAR_H
    side.ClipsDescendants = true
    self.catList = new("ScrollingFrame", {
        Position = UDim2.fromOffset(8, 42), Size = UDim2.new(0, SIDE_W - 16, 1, -54),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3, Parent = side,
    })
    new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.catList })
    customScrollbar(self.catList)

    local content = new("Frame", {
        Position = UDim2.fromOffset(SIDE_W, TOPBAR_H + 13),
        Size = UDim2.new(1, -SIDE_W - 16, 1, -TOPBAR_H - 27),
        BackgroundTransparency = 1, ZIndex = 3, Parent = self.root,
    })

    local searchBox = panel({
        Size = UDim2.new(1, -8, 0, SEARCH_H), BackgroundColor3 = T.inset, ZIndex = 3, Parent = content,
    }, 8)
    self.searchBox = searchBox
    stroke(searchBox, T.stroke, 8, 0.55)
    icon("search", {
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 11, 0.5, 0), ImageColor3 = T.dim, ZIndex = 4, Parent = searchBox,
    })
    self.searchInput = new("TextBox", {
        BackgroundTransparency = 1, Text = "", PlaceholderText = "Search modules...",
        TextColor3 = T.text, PlaceholderColor3 = T.dim, Font = FONT_REG, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
        Position = UDim2.fromOffset(42, 0), Size = UDim2.new(1, -54, 1, 0),
        ZIndex = 4, Parent = searchBox,
    })
    self.searchInput.Focused:Connect(function()
        if BLOCKED.on then self.searchInput:ReleaseFocus() end
    end)
    self.searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        self.search = self.searchInput.Text:lower()
        self:Refresh()
    end)

    self.content = content

    self.edgeStrip = new("Frame", {
        Position = UDim2.fromOffset(0, TOPBAR_H + 13),
        Size = UDim2.new(0, 16, 1, -TOPBAR_H - 13),
        BackgroundTransparency = 1, Visible = false, ZIndex = 8, Parent = self.root,
    })
    self.modList = new("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 54), Size = UDim2.new(1, 0, 1, -54),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3, Parent = content,
    })
    new("UIPadding", { PaddingRight = UDim.new(0, 8), Parent = self.modList })
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.modList })
    customScrollbar(self.modList)

    local dv = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5, Parent = self.root,
    })
    self.dividerLine = new("Frame", {
        Position = UDim2.fromOffset(SIDE_W, TOPBAR_H + 1),
        Size = UDim2.new(0, 1, 1, -TOPBAR_H - 1),
        BackgroundColor3 = T.stroke, BackgroundTransparency = 0.35,
        BorderSizePixel = 0, ZIndex = 5, Parent = dv,
    })

    new("UIGradient", {
        Rotation = 90, Parent = self.dividerLine,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.14, 0),
            NumberSequenceKeypoint.new(0.94, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
    })

    self.scrim = new("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        BorderSizePixel = 0, ZIndex = 19, Visible = false, Parent = self.root,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    })
    new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.scrim })
    self.scrim.MouseButton1Click:Connect(function() self:CloseDrawer() end)

    self.drawer = panel({
        Class = "TextButton", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 300, 1, 0), BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        AutoButtonColor = false, ZIndex = 20, Visible = false, Parent = self.root,
    }, 10)
    stroke(self.drawer, T.stroke, 10, 0.3)
    self.drawerTitle = text({
        Text = "Settings", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(44, 0), Size = UDim2.fromOffset(180, 46), ZIndex = 21, Parent = self.drawer,
    })
    local backBtn = new("TextButton", {
        Size = UDim2.fromOffset(HIT, HIT), Position = UDim2.fromOffset(14, 11),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 22, Parent = self.drawer,
    })
    local backImg = icon("arrow-left", {
        Size = UDim2.fromOffset(GLYPH, GLYPH), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.sub, ZIndex = 23, Parent = backBtn,
    })
    backBtn.MouseEnter:Connect(function() tw(backImg, FAST, { ImageColor3 = T.text }) end)
    backBtn.MouseLeave:Connect(function() tw(backImg, FAST, { ImageColor3 = T.sub }) end)
    backBtn.MouseButton1Click:Connect(function() self:CloseDrawer() end)

    self.drawerBody = new("ScrollingFrame", {
        Position = UDim2.fromOffset(14, 50), Size = UDim2.new(1, -28, 1, -62),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 21, Parent = self.drawer,
    })
    new("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.drawerBody })
    customScrollbar(self.drawerBody)

    self.root.GroupTransparency = 1
    if self.rootStroke then self.rootStroke.Transparency = 1 end
    task.delay(5, function()
        if not self._presented and not self._destroyed then self:Present() end
    end)

    self.root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if not self.midIcons then return end
        self.midIcons.Position = UDim2.fromOffset(
            math.floor((self.root.AbsoluteSize.X - self.midIcons.AbsoluteSize.X) / 2 + 0.5), 0)
    end)

    keep(RunService.Heartbeat:Connect(function(dt)
        if self._dragGoal then
            local c = self._dragCur
            if not c then
                c = { X = self.root.Position.X.Offset, Y = self.root.Position.Y.Offset }
                self._dragCur = c
            end
            local a = 1 - math.exp(-26 * math.min(dt, 0.05))
            c.X = c.X + (self._dragGoal.X - c.X) * a
            c.Y = c.Y + (self._dragGoal.Y - c.Y) * a
            if math.abs(self._dragGoal.X - c.X) < 0.35 and math.abs(self._dragGoal.Y - c.Y) < 0.35 then
                c.X, c.Y = self._dragGoal.X, self._dragGoal.Y
                if not self._dragging then self._dragGoal = nil; self._dragCur = nil end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            end
            local px, py = math.floor(c.X + 0.5), math.floor(c.Y + 0.5)
            if self.root.Position.X.Offset ~= px or self.root.Position.Y.Offset ~= py then
                self.root.Position = UDim2.fromOffset(px, py)
            end
        end
        if self.minimized or not self.root.Visible or not self.gui.Enabled then return end
        if SMOOTH.scroll then stepScrollers(dt) end
        updateScrollbars()
    end))

    local SINK = "MonoWheelSink"
    local sunk = false
    local function setSink(on)
        if on == sunk then return end
        sunk = on
        if on then
            ContextActionService:BindActionAtPriority(SINK, function()
                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value + 200, Enum.UserInputType.MouseWheel)
        else
            pcall(function() ContextActionService:UnbindAction(SINK) end)
        end
    end
    self._releaseWheel = function() setSink(false) end

    local sinkAt = 0
    keep(RunService.Heartbeat:Connect(function()
        if self._destroyed or self.minimized
            or not self.root.Visible or not self.gui.Enabled then
            setSink(false)
            return
        end
        local now = os.clock()
        if now - sinkAt < 0.05 then return end
        sinkAt = now
        local m = UserInputService:GetMouseLocation()
        local ins = GuiService:GetGuiInset()
        local e = scrollerAt(m.X - ins.X, m.Y - ins.Y)
        setSink(e ~= nil and (SMOOTH.scroll or e.horizontal ~= nil))
    end))

    keep(UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        if self.minimized or not self.root.Visible or not self.gui.Enabled then return end
        local m = UserInputService:GetMouseLocation()
        local ins = GuiService:GetGuiInset()
        local e = scrollerAt(m.X - ins.X, m.Y - ins.Y)
        if not e then return end
        if SMOOTH.scroll then
            e.vel = math.clamp((e.vel or 0) - i.Position.Z * WHEEL_IMPULSE, -SCROLL_MAX_VEL, SCROLL_MAX_VEL)
        elseif e.horizontal then
            local sf = e.sf
            sf.CanvasPosition = Vector2.new(
                math.clamp(sf.CanvasPosition.X - i.Position.Z * 60, 0, maxScroll(sf, true)), 0)
        end
    end))

    self:_drag(top)
    self:_bindInput()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    self._sideShown = true
    self:SetLayout({ side = "Left", search = "Top" }, false)
    self:_buildUISettings()
    self:_buildPages()
    self:_buildNotifications()
    self:_buildTour()
    self:_buildBadge()
    return self
end

function MonoUI:_bindInput()
    sig(UserInputService.InputBegan):Connect(function(input, processed)
        if not self.gui or not self.gui.Parent then return end

        local name
        local t = input.UserInputType
        if t == Enum.UserInputType.Keyboard then
            name = input.KeyCode.Name
        elseif t == Enum.UserInputType.MouseButton1 then
            name = "MouseButton1"
        elseif t == Enum.UserInputType.MouseButton2 then
            name = "MouseButton2"
        elseif t == Enum.UserInputType.MouseButton3 then
            name = "MouseButton3"
        elseif t == Enum.UserInputType.MouseWheel then
            name = (input.Position.Z > 0) and "MouseWheelUp" or "MouseWheelDown"
        elseif input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
            name = input.KeyCode.Name
        else
            return
        end

        if self.listeningCfg then
            local cfg = self.listeningCfg
            self.listeningCfg = nil
            if name ~= "Escape" then
                cfg.Value = name
                if cfg.Callback then task.spawn(cfg.Callback, name) end
            end
            if cfg._repaint then cfg._repaint() end
            return
        end
        if BLOCKED.on and not self.listening then return end
        if self.listening then
            local m = self.listening
            self:_listen(nil)
            if name == "MouseButton2" or name == "MouseButton3" then m._eatClear = true end
            m:SetBind(name ~= "Escape" and name or nil)
            return
        end

        if processed then return end
        for _, m in ipairs(self.allModules) do
            if m.bind == name and m.row.Parent then
                if m.action then
                    if m.callback then task.spawn(m.callback, true) end
                elseif m.hold then
                    m:Toggle(true)
                else
                    m:Toggle()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                end
            end
        end
    end)

    sig(UserInputService.InputEnded):Connect(function(input)
        if not self.gui or not self.gui.Parent then return end
        local name
        local t = input.UserInputType
        if t == Enum.UserInputType.Keyboard then
            name = input.KeyCode.Name
        elseif t == Enum.UserInputType.MouseButton1 then name = "MouseButton1"
        elseif t == Enum.UserInputType.MouseButton2 then name = "MouseButton2"
        elseif t == Enum.UserInputType.MouseButton3 then name = "MouseButton3"
        else return end
        for _, m in ipairs(self.allModules) do
            if m.hold and m.bind == name and m.row.Parent then m:Toggle(false) end
        end
    end)
end

function MonoUI:_drag(handle, target)
    target = target or self.root
    local dragging, sp, so
    handle.InputBegan:Connect(function(i)

        if target == self.root and self.fullscreen then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, sp, so = true, i.Position, target.Position
            if target == self.root then self._dragging = true end
        end
    end)
    sig(UserInputService.InputEnded):Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            self._dragging = false
        end
    end)
    sig(UserInputService.InputChanged):Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - sp
            if SMOOTH.drag and target == self.root then
                if not self._dragCur then
                    self._dragCur = { X = target.Position.X.Offset, Y = target.Position.Y.Offset }
                end
                self._dragGoal = { X = so.X.Offset + d.X, Y = so.Y.Offset + d.Y }
            else
                target.Position = UDim2.new(so.X.Scale, math.floor(so.X.Offset + d.X + 0.5),
                                            so.Y.Scale, math.floor(so.Y.Offset + d.Y + 0.5))
            end
        end
    end)
end

function MonoUI:Tab(name)
    local TAB_BASE = 15
    local btn = new("TextButton", {
        BackgroundTransparency = 1, AutoButtonColor = false,
        Text = name, Font = FONT, TextColor3 = T.dim,
        TextSize = math.floor(TAB_BASE * TEXT_SCALE + 0.5),
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
        LayoutOrder = #self.tabs + 1, ZIndex = 5, Parent = self.tabHolder,
    })
    btn:SetAttribute("BaseTextSize", TAB_BASE)
    btn:SetAttribute("FontRole", "med")
    local tab = { name = name, button = btn }
    table.insert(self.tabs, tab)

    btn.MouseEnter:Connect(function()
        if BLOCKED.on then return end
        if self.activeTab ~= tab then tw(btn, FAST, { TextColor3 = T.sub }) end
    end)
    btn.MouseLeave:Connect(function()
        if self.activeTab ~= tab then tw(btn, FAST, { TextColor3 = T.dim }) end
    end)
    btn.MouseButton1Click:Connect(function()
        if BLOCKED.on then return end
        self:SelectTab(tab)
    end)

    if #self.tabs == 1 then task.defer(function() self:SelectTab(tab) end) end
    return tab
end

function MonoUI:SelectTab(tab)
    local changed = self.activeTab ~= tab
    if self.activeTab and changed then
        tw(self.activeTab.button, FAST, { TextColor3 = T.dim })
    end
    self.activeTab = tab
    tw(tab.button, EASE, { TextColor3 = T.text })
    if not changed then return end

    local function show(on)
        local mods = tab.name == "Modules"
        if self.side then self.side.Visible = mods and (self._sideShown ~= false) end
        if self.content then self.content.Visible = mods end
        self:_setDivider(mods and (self._sideShown ~= false) and self.layout
            and self.layout.side ~= "Bottom", false)
        if self.pagePlayers  then self.pagePlayers.Visible  = tab.name == "Players" end
        if self.pageServer   then self.pageServer.Visible   = tab.name == "Server" end
        if self.pageConfigs then self.pageConfigs.Visible = tab.name == "Configs" end
        if self.pageSettings then self.pageSettings.Visible = tab.name == "Settings" end
        if self.pageCredits then self.pageCredits.Visible = tab.name == "Credits" end
    end

    local leavingModules = self._activePage == self.content
    local current = self._activePage
    if current then self:_fade(current, 1, FAST) end
    if leavingModules and self.side and self.side.Visible then
        self:_fade(self.side, 1, FAST)
        self:_setDivider(false, true)
    end
    task.delay(current and 0.10 or 0, function()
        if self.activeTab ~= tab then return end
        show(true)
        local page = (tab.name == "Players" and self.pagePlayers)
            or (tab.name == "Server" and self.pageServer)
            or (tab.name == "Configs" and self.pageConfigs)
            or (tab.name == "Settings" and self.pageSettings)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            or (tab.name == "Credits" and self.pageCredits)
            or self.content
        self._activePage = page
        if tab.name == "Configs" and self._refreshConfigs then self._refreshConfigs() end
        if tab.name == "Server" and self._refreshServer then self._refreshServer() end
        if tab.name == "Settings" and self._refreshSettings then self._refreshSettings() end
        if page then
            self:_setFade(page, 1)
            self:_fade(page, 0, OPEN)
        end
        if tab.name == "Modules" and self.side then
            self:_setFade(self.side, 1)
            self:_fade(self.side, 0, OPEN)
        end
    end)
end

function MonoUI:Category(name, iconName)
    local cat = { name = name, icon = iconName, modules = {}, ui = self }

    local btn = panel({
        Class = "ImageButton", Size = UDim2.new(1, 0, 0, CAT_H), BackgroundColor3 = T.panel,
        BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 4,
        LayoutOrder = #self.categories + 1, Parent = self.catList,
    }, 6)
    local ico = icon(iconName or "box", {
        Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 8, 0.5, 0), ImageColor3 = T.faint, ZIndex = 6, Parent = btn,
    })
    local lbl = text({
        Text = name, TextSize = 15, TextColor3 = T.dim, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 40, 0.5, 0), Size = UDim2.new(1, -104, 0, 18),
        ZIndex = 6, Parent = btn,
    })

    local chev = text({
        Text = "›", TextSize = 16, TextColor3 = T.faint, Font = FONT_REG,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, -1),
        Size = UDim2.fromOffset(8, 18), TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 6, Parent = btn,
    })
    local count = text({
        Text = "", TextSize = 12, TextColor3 = T.faint, Font = FONT_REG,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -30, 0.5, 0),
        Size = UDim2.fromOffset(24, 16), TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 6, Parent = btn,
    })

    cat.button, cat.iconImg, cat.label, cat.countLabel = btn, ico, lbl, count

    btn.MouseEnter:Connect(function()
        if BLOCKED.on then return end
        if self.activeCategory ~= cat then tw(btn, FAST, { BackgroundTransparency = 0.55 }) end
    end)
    btn.MouseLeave:Connect(function()
        if self.activeCategory ~= cat then tw(btn, FAST, { BackgroundTransparency = 1 }) end
    end)
    btn.MouseButton1Click:Connect(function()
        if BLOCKED.on then return end
        self:SelectCategory(cat)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end)

    function cat:Section(name)
        local ui = self.ui
        ui._order = ui._order + 1
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, MOBILE and 34 or 28), BackgroundTransparency = 1,
            LayoutOrder = ui._order, Visible = false, ZIndex = 4, Parent = ui.modList,
        })
        local lbl = text({
            Text = name, Font = FONT_BOLD, TextSize = 12, TextColor3 = T.sub,
            AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 22, 1, -6),
            Size = UDim2.new(1, -44, 0, 16), ZIndex = 5, Parent = row,
        })
        local rule = new("Frame", {
            AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -11),
            Size = UDim2.new(1, -44 - math.ceil(lbl.TextBounds.X), 0, 1),
            BackgroundColor3 = T.stroke, BackgroundTransparency = 0.45,
            BorderSizePixel = 0, ZIndex = 5, Parent = row,
        })
        fadeEnds(rule, false, 0.02, 0.16)
        local sec = { name = name, row = row, label = lbl, rule = rule, cat = cat, modules = {} }
        table.insert(ui.sections, sec)
        cat._section = sec
        ui:_captureBase(row)
        return sec
    end

    function cat:Module(opts) return self.ui:_module(self, opts) end

    function cat:Adopt(m)
        for _, e in ipairs(cat.modules) do if e == m then return m end end
        table.insert(cat.modules, m)
        m.categories = m.categories or {}
        table.insert(m.categories, cat)
        self.ui:_updateCounts()
        return m
    end
    function cat:Drop(m)
        for i = #cat.modules, 1, -1 do
            if cat.modules[i] == m then table.remove(cat.modules, i) end
        end
        for i = #(m.categories or {}), 1, -1 do
            if m.categories[i] == cat then table.remove(m.categories, i) end
        end
        self.ui:_updateCounts()
        return m
    end

    self:_captureBase(btn)
    table.insert(self.categories, cat)

    if name == "Favorites" then
        self.favCategory = cat
        btn.Visible = false
    end
    if not self._bootstrapped then
        self._bootstrapped = true

        task.defer(function()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            if self.activeCategory then return end
            for _, c in ipairs(self.categories) do
                if c.button.Visible then self:SelectCategory(c) return end
            end
        end)
    end
    return cat
end

function MonoUI:_syncFavorites()
    local fav = self.favCategory
    if not fav then return end
    local any = #fav.modules > 0
    fav.button.Visible = any
    if not any and self.activeCategory == fav then
        for _, c in ipairs(self.categories) do
            if c ~= fav then self:SelectCategory(c) break end
        end
    end
    self:Refresh()
end

function MonoUI:SelectCategory(cat)
    if self.activeCategory == cat then return end
    local prev = self.activeCategory
    self.activeCategory = cat
    if prev then
        tw(prev.button, FAST, { BackgroundTransparency = 1 })
        tw(prev.label, FAST, { TextColor3 = T.dim })
        tw(prev.iconImg, FAST, { ImageColor3 = T.faint })
    end
    tw(cat.button, EASE, { BackgroundTransparency = 0 })
    tw(cat.label, EASE, { TextColor3 = T.text })

    tw(cat.iconImg, EASE, { ImageColor3 = (cat.name == "Favorites") and T.star or T.text })
    self:Refresh(true)
end

function MonoUI:_module(cat, opts)
    opts = opts or {}
    local m = {
        name = opts.Name or "Module",
        desc = opts.Desc or "",
        bind = opts.Bind,
        state = opts.Default and true or false,
        callback = opts.Callback,
        settings = {},
        category = cat,
        action = opts.Action and true or false,
        hold = opts.Hold and true or false,
        info = opts.Info,
    }
    m.categories = { cat }

    self._order = self._order + 1
    local row = panel({
        Class = "ImageButton", Size = UDim2.new(1, 0, 0, ROW_H), BackgroundColor3 = T.panel,
        AutoButtonColor = false, LayoutOrder = self._order, ZIndex = 4, Parent = self.modList,
    }, 8)
    m.section = cat._section
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    if m.section then table.insert(m.section.modules, m) end

    m.display = spaceName(m.name)
    local title = text({
        Text = m.display, TextSize = 14, Font = FONT, TextColor3 = T.sub,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 22, 0.5, 0),
        Size = UDim2.fromOffset(150, 16), ZIndex = 6, Parent = row,
    })

    local desc = text({
        Text = m.desc, TextSize = 12, Font = FONT_REG, TextColor3 = T.descText,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 190, 0.5, 0),
        Size = UDim2.new(1, -190 - 200, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6, Parent = row,
    })

    local dots = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -math.floor(HIT / 2), 0.5, 0),
        Size = UDim2.fromOffset(HIT, HIT), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, ZIndex = 7, Parent = row,
    })
    local dotsImg = icon("ellipsis-vertical", {
        Size = UDim2.fromOffset(GLYPH, GLYPH), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.faint, ZIndex = 8, Parent = dots,
    })

    local STAR_X  = HIT + 14
    local TRACK_X = STAR_X + HIT + 6
    local CHIP_X  = TRACK_X + TRACK_W + 10
    local star = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -STAR_X, 0.5, 0),
        Size = UDim2.fromOffset(HIT, HIT), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, ZIndex = 7, Parent = row,
    })
    local starImg = icon("star", {
        Size = UDim2.fromOffset(GLYPH, GLYPH), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.faint, ZIndex = 8, Parent = star,
    })

    local track = panel({
        Class = "ImageButton", AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -TRACK_X, 0.5, 0), Size = UDim2.fromOffset(TRACK_W, TRACK_H),
        BackgroundColor3 = T.offTrack, AutoButtonColor = false, ZIndex = 7, Parent = row,
    }, math.floor(TRACK_H / 2))
    stroke(track, T.stroke, math.floor(TRACK_H / 2), 0.45)
    local knob = panel({
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, KNOB_PAD, 0.5, 0),
        Size = UDim2.fromOffset(KNOB_D, KNOB_D), BackgroundColor3 = T.offKnob, ZIndex = 8, Parent = track,
    }, math.floor(KNOB_D / 2))

    local chip = panel({
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -CHIP_X, 0.5, 0),
        Size = UDim2.fromOffset(CHIP_MIN, CHIP_H),
        BackgroundColor3 = Color3.fromRGB(44, 44, 44), Visible = not MOBILE,
        ZIndex = 7, Parent = row,
    }, 6)
    local chipLbl = text({
        Text = "", TextSize = 12, Font = FONT_REG, TextColor3 = T.sub,
        Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8, Parent = chip,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    })
    local chipIcon = icon("keyboard", {
        Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.faint, ZIndex = 8, Parent = chip,
    })
    local function chipWidth(str)
        if not str or str == "" then return CHIP_MIN end
        local ok, sz = pcall(function()
            return TextService:GetTextSize(str, chipLbl.TextSize, chipLbl.Font, Vector2.new(1000, 100))
        end)
        local w = ok and sz.X or (#str * chipLbl.TextSize * 0.6)
        return math.max(CHIP_MIN, math.ceil(w) + CHIP_PAD * 2)
    end
    local chipBtn = new("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, ZIndex = 9, Parent = chip,
    })

    local function paint(animate)
        local ti = animate and EASE or TweenInfo.new(0)
        tw(title,  ti, { TextColor3 = m.state and T.text or T.sub })
        tw(desc,   ti, { TextColor3 = m.state and T.sub or T.descText })
        tw(track,  ti, { BackgroundColor3 = m.state and T.onTrack or T.offTrack })
        tw(knob,   ti, { BackgroundColor3 = m.state and contrastKnob(T.onTrack) or T.offKnob,
                         Position = UDim2.new(0, m.state and KNOB_ON or KNOB_PAD, 0.5, 0) })
    end
    paint(false)

    local function set(v, fire)
        v = v and true or false
        if m.state == v then return end
        m.state = v
        paint(true)
        cat.ui:_updateCounts()
        if fire and m.callback then task.spawn(m.callback, v) end
        if fire and self.onStateChanged then task.spawn(self.onStateChanged, m, v) end
    end

    if m.action then

        track.Visible = false
        chip.Position = UDim2.new(1, -TRACK_X, 0.5, 0)
        row.MouseButton1Click:Connect(function()
            tw(title, FAST, { TextColor3 = T.text })
            task.delay(0.16, function() tw(title, FAST, { TextColor3 = T.sub }) end)
            if m.callback then task.spawn(m.callback, true) end
        end)
    else
        track.MouseButton1Click:Connect(function() set(not m.state, true) end)

        row.MouseButton1Click:Connect(function()
            if BLOCKED.on then return end
            set(not m.state, true)
        end)
    end
    row.MouseEnter:Connect(function()
        if BLOCKED.on then return end
        tw(row, FAST, { BackgroundColor3 = T.panelHover })
    end)
    row.MouseLeave:Connect(function() tw(row, FAST, { BackgroundColor3 = T.panel }) end)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    dots.MouseEnter:Connect(function()
        if BLOCKED.on then return end
        tw(dotsImg, FAST, { ImageColor3 = T.text })
    end)
    dots.MouseLeave:Connect(function() tw(dotsImg, FAST, { ImageColor3 = T.faint }) end)
    dots.MouseButton1Click:Connect(function() self:OpenDrawer(m) end)

    local function paintStar()
        tw(starImg, FAST, { ImageColor3 = m.favorite and T.star or T.faint })
    end
    star.MouseEnter:Connect(function()
        if BLOCKED.on then return end
        if not m.favorite then tw(starImg, FAST, { ImageColor3 = T.sub }) end
    end)
    star.MouseLeave:Connect(paintStar)
    star.MouseButton1Click:Connect(function() m:SetFavorite(not m.favorite) end)

    local function paintChip()
        local listening = self.listening == m
        local label = listening and "..." or keyLabel(m.bind)
        chipLbl.Text = label or ""
        chipIcon.Visible = label == nil
        chip.Size = UDim2.fromOffset(chipWidth(label), CHIP_H)
        tw(chipLbl, FAST, { TextColor3 = listening and T.star or T.sub })
    end
    chipBtn.MouseEnter:Connect(function()
        if self.listening ~= m and not m.bind then tw(chipIcon, FAST, { ImageColor3 = T.sub }) end
    end)
    chipBtn.MouseLeave:Connect(function()
        tw(chipIcon, FAST, { ImageColor3 = T.faint })
        paintChip()
    end)
    chipBtn.MouseButton1Click:Connect(function()
        if self.listening == m then self:_listen(nil) else self:_listen(m) end
    end)
    chipBtn.MouseButton2Click:Connect(function()
        if m._eatClear then m._eatClear = nil return end
        if self.listening == m then self:_listen(nil) return end
        if not m.bind then return end
        m:SetBind(nil)
    end)

    self:_captureBase(row)
    m.row, m.titleLbl, m.descLbl, m.chip, m.chipLbl = row, title, desc, chip, chipLbl
    m.starImg, m._paintChip, m._paintStar = starImg, paintChip, paintStar
    m._paint = paint
    function m:Get() return m.state end
    function m:Toggle(v)
        if v == nil then v = not m.state end
        set(v and true or false, true)
    end
    function m:SetDesc(t) m.desc = t; desc.Text = t end
    function m:SetBind(k)

        if k then
            for _, o in ipairs(self.ui and self.ui.allModules or {}) do
                if o ~= m and o.bind == k then o:SetBind(nil) end
            end
        end
        m.bind = k
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        paintChip()
    end
    function m:SetFavorite(v)
        v = v and true or false
        if m.favorite == v then return end
        m.favorite = v
        local fav = cat.ui.favCategory
        if fav and fav ~= cat then
            if v then fav:Adopt(m) else fav:Drop(m) end
        end
        paintStar()
        cat.ui:_syncFavorites()
    end
    function m:Setting(cfg) table.insert(m.settings, cfg); return m end
    m.ui = self

    table.insert(cat.modules, m)
    table.insert(self.allModules, m)
    if opts.Favorite then task.defer(function() m:SetFavorite(true) end) end
    paintChip()
    self:_updateCounts()
    self:Refresh()
    return m
end

function MonoUI:_listen(m)
    local prev = self.listening
    self.listening = m
    if prev and prev._paintChip then prev._paintChip() end
    if m then
        if self.searchInput then self.searchInput:ReleaseFocus() end
        if m._paintChip then m._paintChip() end
    end
end

function MonoUI:_updateCounts()
    for _, cat in ipairs(self.categories) do
        local n = 0
        for _, m in ipairs(cat.modules) do if m.state and not m.action then n = n + 1 end end

        cat.countLabel.Text = n > 0 and tostring(n) or ""
    end
end

function MonoUI:Refresh(animate)
    local q = self.search
    local shown = 0

    for _, m in ipairs(self.allModules) do
        local match = (q == "")
            or m.name:lower():find(q, 1, true)
            or (m.display or m.name):lower():find(q, 1, true)
            or m.desc:lower():find(q, 1, true)
        local inActive = false
        for _, c in ipairs(m.categories) do
            if c == self.activeCategory then inActive = true break end
        end
        local show = match and (q ~= "" or inActive)
        m.row.Visible = show and true or false
        if show then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            shown = shown + 1
            if animate then

                local idx = shown
                self:_setFade(m.row, 1)
                task.delay(math.min(idx, 6) * 0.014, function()
                    if m.row.Parent then self:_fade(m.row, 0, EASE) end
                end)
            end
        end
    end

    for _, sec in ipairs(self.sections) do
        local any = false
        for _, m in ipairs(sec.modules) do
            if m.row.Visible then any = true break end
        end
        sec.row.Visible = any
    end
end

local function baseOf(c, prop)
    local v = c:GetAttribute("_base_" .. prop)
    if v ~= nil then return v end
    recordBase(c)
    v = c:GetAttribute("_base_" .. prop)
    if v ~= nil then return v end
    local ok, cur = pcall(function() return c[prop] end)
    return (ok and type(cur) == "number") and cur or 0
end

local P_TEXT   = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" }
local P_IMAGE  = { "ImageTransparency", "BackgroundTransparency" }
local P_BUTTON = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" }
local P_SCROLL = { "BackgroundTransparency", "ScrollBarImageTransparency" }
local P_FRAME  = { "BackgroundTransparency" }
local P_STROKE = { "Transparency" }

local function propsFor(c)
    if c:IsA("ScrollingFrame") then return P_SCROLL end
    if c:IsA("TextButton") then return P_BUTTON end
    if c:IsA("TextLabel") or c:IsA("TextBox") then return P_TEXT end
    if c:IsA("ImageLabel") or c:IsA("ImageButton") then return P_IMAGE end
    if c:IsA("Frame") then return P_FRAME end
    if c:IsA("UIStroke") then return P_STROKE end
    return nil
end

local fadePlans = setmetatable({}, { __mode = "k" })

local function fadePlan(root)
    local plan = fadePlans[root]
    if plan then return plan end

    plan = {}
    local n = 1
    plan[1] = { root, "BackgroundTransparency", baseOf(root, "BackgroundTransparency") }
    if root:IsA("ImageLabel") or root:IsA("ImageButton") then
        n = 2
        plan[2] = { root, "ImageTransparency", baseOf(root, "ImageTransparency") }
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end
    for _, c in ipairs(root:GetDescendants()) do
        local props = propsFor(c)
        if props then
            for i = 1, #props do
                n = n + 1
                plan[n] = { c, props[i], baseOf(c, props[i]) }
            end
        end
    end

    fadePlans[root] = plan

    local conns
    local function invalidate()
        fadePlans[root] = nil
        if conns then
            for i = 1, #conns do pcall(function() conns[i]:Disconnect() end) end
            conns = nil
        end
    end
    conns = {
        root.DescendantAdded:Connect(invalidate),
        root.DescendantRemoving:Connect(invalidate),
    }
    return plan
end

local function eachFadeTarget(root, alpha, apply)
    local plan = fadePlan(root)
    for i = 1, #plan do
        local e = plan[i]
        local base = e[3]
        apply(e[1], e[2], base + (1 - base) * alpha)
    end
end

function MonoUI:_captureBase(root)
    eachFadeTarget(root, 0, function() end)
end

function MonoUI:_setFade(root, alpha)
    eachFadeTarget(root, alpha, function(inst, prop, value) inst[prop] = value end)
end

function MonoUI:_fade(root, alpha, ti)
    ti = ti or EASE
    eachFadeTarget(root, alpha, function(inst, prop, value)
        tw(inst, ti, { [prop] = value })
    end)
end

function MonoUI:OpenDrawer(m)
    self.drawerTitle.Text = m and (m.display or m.name) or "Settings"
    for _, c in ipairs(self.drawerBody:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    if m and (m.info or m.desc) ~= nil and (m.info or m.desc) ~= "" then
        local txt = m.info or m.desc
        local width = self.drawerBody.AbsoluteSize.X
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        if width < 1 then width = 272 end
        local size = math.floor(13 * TEXT_SCALE + 0.5)
        local ok, sz = pcall(function()
            return TextService:GetTextSize(txt, size, FONT_REG, Vector2.new(width - 20, 10000))
        end)
        local h = ok and math.ceil(sz.Y) or 34
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, h + 8), BackgroundTransparency = 1,
            LayoutOrder = -1, ZIndex = 22, Parent = self.drawerBody,
        })
        text({
            Text = txt, TextSize = 13, Font = FONT_REG, TextColor3 = T.descText,
            Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(width - 20, h),
            TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 23, Parent = row,
        })
    end
    if m then
        if #m.settings == 0 and not (m.info or m.desc) then
            text({
                Text = "No settings for this module.", TextSize = 12, Font = FONT_REG,
                TextColor3 = T.faint, Size = UDim2.new(1, 0, 0, 20), ZIndex = 22, Parent = self.drawerBody,
            })
        end
        for _, s in ipairs(m.settings) do self:_setting(s) end
    else
        for _, s in ipairs(self.uiSettings or {}) do self:_setting(s) end
    end
    self.drawerBody.ScrollingEnabled = true
    self.drawer.Position = UDim2.new(1, 0, 0, 0)
    self.drawer.Visible = true
    self.modalOpen = true
    BLOCKED.on = true
    self:_freezeScroll(true)
    self.scrim.Visible = true
    self.scrim.BackgroundTransparency = 1
    tw(self.scrim, OPEN, { BackgroundTransparency = 0.45 })

    self:_setFade(self.drawer, 1)
    self:_fade(self.drawer, 0, OPEN)
end

function MonoUI:CloseDrawer()

    self.modalOpen = false
    BLOCKED.on = false
    self.drawerBody.ScrollingEnabled = true
    self:_freezeScroll(false)
    self:_fade(self.drawer, 1, CLOSE)
    tw(self.scrim, CLOSE, { BackgroundTransparency = 1 })
    task.delay(0.24, function()
        if self.drawer.BackgroundTransparency >= 0.99 then
            self.drawer.Visible = false
            self.scrim.Visible = false
        end
    end)
end

function MonoUI:_freezeScroll(on)
    for i = 1, #SCROLLERS do
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        local e = SCROLLERS[i]
        if e.sf.Parent and e.sf ~= self.drawerBody then
            e.frozen = on or nil
            if on then e.vel = 0 end
            e.sf.ScrollingEnabled = not on
        end
    end
end

function MonoUI:SetSmoothScroll(on)
    SMOOTH.scroll = on and true or false
    for i = 1, #SCROLLERS do
        local e = SCROLLERS[i]
        if e.sf.Parent then
            e.vel = 0
            e.sf.ScrollingEnabled = not e.frozen
        end
    end
end

function MonoUI:SetSmoothDrag(on)
    SMOOTH.drag = on and true or false
    if not SMOOTH.drag then self._dragGoal = nil end
end

function MonoUI:Confirm(cfg)
    cfg = cfg or {}
    if self._confirmOpen then return end
    self._confirmOpen = true

    local W = MOBILE and 380 or 348
    local innerW = W - 36
    local bodyText = cfg.Body or ""
    local bs = math.floor(13 * TEXT_SCALE + 0.5)
    local okB, bz = pcall(function()
        return TextService:GetTextSize(bodyText, bs, FONT_REG, Vector2.new(innerW, 10000))
    end)
    local bh = math.max(okB and math.ceil(bz.Y) or 40, 18)
    local H = 46 + bh + 22 + 34 + 18

    local host = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        ZIndex = 70, Parent = self.gui })
    local shade = new("TextButton", { Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 70, Parent = host })
    local card = panel({ AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H), BackgroundColor3 = T.panel, ZIndex = 71, Parent = host }, 12)
    stroke(card, T.strokeSoft, 12, 0.25)
    text({ Text = cfg.Title or "Are you sure?", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(18, 18), Size = UDim2.fromOffset(innerW, 20), ZIndex = 72, Parent = card })
    text({ Text = bodyText, TextSize = 13, Font = FONT_REG, TextColor3 = T.descText,
        Position = UDim2.fromOffset(18, 46), Size = UDim2.fromOffset(innerW, bh),
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 72, Parent = card })

    local function mk(label, xOff, w, danger)
        local idle = danger and Color3.fromRGB(196, 62, 62) or T.inset
        local hot  = danger and Color3.fromRGB(224, 78, 78) or T.panelHover
        local lit  = danger and Color3.fromRGB(255, 255, 255) or T.sub
        local b = panel({ Class = "TextButton", AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, xOff, 1, -18), Size = UDim2.fromOffset(w, 34),
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            BackgroundColor3 = idle, AutoButtonColor = false, ZIndex = 72, Parent = card }, 8)
        local l = text({ Text = label, TextSize = 13, TextColor3 = lit, Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 73, Parent = b })
        b.MouseEnter:Connect(function()
            tw(b, FAST, { BackgroundColor3 = hot })
            tw(l, FAST, { TextColor3 = danger and Color3.fromRGB(255, 255, 255) or T.text })
        end)
        b.MouseLeave:Connect(function()
            tw(b, FAST, { BackgroundColor3 = idle })
            tw(l, FAST, { TextColor3 = lit })
        end)
        return b
    end
    local yesBtn = mk(cfg.ConfirmText or "Confirm", -18, 138, true)
    local noBtn  = mk(cfg.CancelText or "Cancel", -166, 112, false)

    self:_captureBase(host)
    self:_setFade(host, 1)
    self:_fade(host, 0, OPEN)
    tw(shade, OPEN, { BackgroundTransparency = 0.5 })
    card.Size = UDim2.fromOffset(math.floor(W * 0.93), math.floor(H * 0.93))
    tw(card, OPEN, { Size = UDim2.fromOffset(W, H) })
    local wasBlocked = BLOCKED.on
    BLOCKED.on = true

    local done = false
    local function close(run)
        if done then return end
        done = true
        BLOCKED.on = wasBlocked
        self._confirmOpen = false
        self:_fade(host, 1, CLOSE)
        tw(shade, CLOSE, { BackgroundTransparency = 1 })
        tw(card, CLOSE, { Size = UDim2.fromOffset(math.floor(W * 0.93), math.floor(H * 0.93)) })
        task.delay(0.26, function()
            pcall(function() host:Destroy() end)
            if run then task.spawn(run) end
        end)
    end
    yesBtn.MouseButton1Click:Connect(function() close(cfg.OnConfirm) end)
    noBtn.MouseButton1Click:Connect(function() close(cfg.OnCancel) end)
    shade.MouseButton1Click:Connect(function() close(cfg.OnCancel) end)
end

function MonoUI:Reload()
    if self._reloading then return end
    self._reloading = true

    if self.refreshImg then
        self.refreshImg.Rotation = 0
        tw(self.refreshImg, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Rotation = 360 })
    end
    local name = self.activeTab and self.activeTab.name or "Modules"
    local onModules = name == "Modules"
    local page = self._activePage

    if onModules then
        if self.searchInput then self.searchInput.Text = "" end
        self.search = ""
        self:_fade(self.side, 1, FAST)
        self:_fade(self.content, 1, FAST)
    elseif page then
        self:_fade(page, 1, FAST)
    end

    task.delay(0.10, function()
        if onModules then
            self:_updateCounts()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            self:_syncFavorites()
            self:Refresh(false)
        elseif name == "Players"  and self._rebuildPlayers  then self._rebuildPlayers()
        elseif name == "Server"   and self._refreshServer   then self._refreshServer()
        elseif name == "Configs"  and self._refreshConfigs  then self._refreshConfigs()
        elseif name == "Settings" and self._refreshSettings then self._refreshSettings()
        end

        if onModules then
            self:_fade(self.side, 0, OPEN)
            self:_fade(self.content, 0, OPEN)
        elseif page then
            self:_setFade(page, 1)
            self:_fade(page, 0, OPEN)
        end
        task.delay(0.3, function() self._reloading = false end)
    end)
end

function MonoUI:_buildNotifications()
    self.notifyHost = new("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.fromOffset(MOBILE and 320 or 288, 1),
        BackgroundTransparency = 1, ZIndex = 40, Parent = self.gui,
    })
    new("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8), Parent = self.notifyHost,
    })
    self.notifySeq = 0
end

function MonoUI:Notify(cfg)
    cfg = cfg or {}
    if not self.notifyHost then return end
    self.notifySeq = self.notifySeq + 1

    local PAD_X, PAD_T, PAD_B, TITLE_H, GAP = 14, 11, 12, 18, 3
    local hostW = self.notifyHost.AbsoluteSize.X
    if hostW < 1 then hostW = MOBILE and 320 or 288 end
    local innerW = hostW - PAD_X * 2

    local bodySize  = math.floor(13 * TEXT_SCALE + 0.5)
    local bodyH = 0
    if cfg.Content and cfg.Content ~= "" then
        local ok, sz = pcall(function()
            return TextService:GetTextSize(cfg.Content, bodySize, FONT_REG, Vector2.new(innerW, 10000))
        end)
        bodyH = ok and math.ceil(sz.Y) or bodySize + 2
    end
    local BAR_H, BAR_GAP = 3, 7
    local cardH = PAD_T + TITLE_H + (bodyH > 0 and (GAP + bodyH) or 0) + PAD_B + BAR_H + BAR_GAP

    local card = panel({
        Size = UDim2.fromOffset(hostW, cardH), BackgroundColor3 = T.panel,
        ClipsDescendants = true,
        LayoutOrder = self.notifySeq, ZIndex = 41, Parent = self.notifyHost,
    }, 8)
    stroke(card, T.strokeSoft, 8, 0.35)

    local title = text({
        Text = cfg.Title or "Notice", Font = FONT_BOLD, TextSize = 14, TextColor3 = T.text,
        Position = UDim2.fromOffset(PAD_X, PAD_T), Size = UDim2.fromOffset(innerW, TITLE_H),
        ZIndex = 42, Parent = card,
    })
    local body
    if bodyH > 0 then
        body = text({
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            Text = cfg.Content, TextSize = 13, Font = FONT_REG, TextColor3 = T.descText,
            Position = UDim2.fromOffset(PAD_X, PAD_T + TITLE_H + GAP),
            Size = UDim2.fromOffset(innerW, bodyH), TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 42, Parent = card,
        })
    end

    local barTrack = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -BAR_GAP),
        Size = UDim2.new(1, -PAD_X * 2, 0, BAR_H),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.45,
        BorderSizePixel = 0, ZIndex = 42, Parent = card,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barTrack })
    local barFill = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = cfg.Color or T.onTrack,
        BorderSizePixel = 0, ZIndex = 43, Parent = barTrack,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barFill })

    self:_captureBase(card)
    self:_setFade(card, 1)
    self:_fade(card, 0, OPEN)

    local handle, closed = {}, false
    function handle:Close()
        if closed then return end
        closed = true
        local ui = handle._ui
        ui:_fade(card, 1, CLOSE)
        task.delay(0.26, function() pcall(function() card:Destroy() end) end)
    end
    handle._ui = self
    function handle:SetContent(t) if body then body.Text = tostring(t) end end
    function handle:SetTitle(t) title.Text = tostring(t) end

    local dur = cfg.Duration
    if dur == 0 then
        barTrack.Visible = false
    else
        dur = dur or 3
        tw(barFill, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size = UDim2.fromScale(0, 1) })
        task.delay(dur, function() handle:Close() end)
    end
    return handle
end

function MonoUI:_buildTour()
    local host = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Visible = false, ZIndex = 60, Parent = self.gui,
    })
    local shade = new("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        BorderSizePixel = 0, ZIndex = 60, Parent = host,
    })
    local ring = new("Frame", {
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 61, Parent = host,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    })
    new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = ring })
    local ringEdge = new("UIStroke", {
        Color = T.onTrack, Thickness = 2, Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ring,
    })

    local CARD_W = MOBILE and 340 or 300
    local card = panel({
        Size = UDim2.fromOffset(CARD_W, 150), BackgroundColor3 = T.panel,
        ZIndex = 62, Parent = host,
    }, 10)
    stroke(card, T.strokeSoft, 10, 0.3)
    local step = text({
        Text = "", TextSize = 11, Font = FONT_REG, TextColor3 = T.faint,
        Position = UDim2.fromOffset(16, 13), Size = UDim2.fromOffset(120, 14),
        ZIndex = 63, Parent = card,
    })
    local title = text({
        Text = "", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(16, 30), Size = UDim2.fromOffset(CARD_W - 32, 20),
        ZIndex = 63, Parent = card,
    })
    local body = text({
        Text = "", TextSize = 13, Font = FONT_REG, TextColor3 = T.descText,
        Position = UDim2.fromOffset(16, 54), Size = UDim2.fromOffset(CARD_W - 32, 60),
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 63, Parent = card,
    })
    local function mkBtn(label, x, w, primary)
        local b = panel({
            Class = "TextButton", AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, x, 1, -14), Size = UDim2.fromOffset(w, 30),
            BackgroundColor3 = primary and T.onTrack or T.inset,
            AutoButtonColor = false, ZIndex = 63, Parent = card,
        }, 7)
        local l = text({
            Text = label, TextSize = 13, TextColor3 = primary and contrastKnob(T.onTrack) or T.sub,
            Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 64, Parent = b,
        })
        b.MouseEnter:Connect(function()
            if not primary then tw(b, FAST, { BackgroundColor3 = T.panelHover }) end
            tw(l, FAST, { TextColor3 = primary and contrastKnob(T.onTrack) or T.text })
        end)
        b.MouseLeave:Connect(function()
            if not primary then tw(b, FAST, { BackgroundColor3 = T.inset }) end
            tw(l, FAST, { TextColor3 = primary and contrastKnob(T.onTrack) or T.sub })
        end)
        return b, l
    end
    local nextBtn, nextLbl = mkBtn("Next", -14, 84, true)
    local skipBtn = mkBtn("Skip", -106, 68, false)

    self.tour = {
        host = host, shade = shade, ring = ring, ringEdge = ringEdge, card = card,
        step = step, title = title, body = body, cardW = CARD_W,
        nextBtn = nextBtn, nextLbl = nextLbl, skipBtn = skipBtn,
        steps = {}, index = 0,
    }
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    self:_captureBase(host)

    nextBtn.MouseButton1Click:Connect(function() self:_tourNext() end)
    skipBtn.MouseButton1Click:Connect(function() self:EndTour() end)
    shade.MouseButton1Click:Connect(function() self:_tourNext() end)
end

function MonoUI:AddTourStep(cfg)
    if not self.tour then return end
    table.insert(self.tour.steps, cfg)
end

function MonoUI:_tourPlace(target)
    local t = self.tour
    local pad = 2
    if typeof(target) == "Instance" and target:IsA("GuiObject") then
        local rp = self.root.AbsolutePosition
        local ap, as = target.AbsolutePosition, target.AbsoluteSize
        local px = ap.X - rp.X + self.root.Position.X.Offset - pad
        local py = ap.Y - rp.Y + self.root.Position.Y.Offset - pad
        local sx, sy = as.X + pad * 2, as.Y + pad * 2
        if t.ring.Visible then
            tw(t.ring, EASE, { Position = UDim2.fromOffset(px, py), Size = UDim2.fromOffset(sx, sy) })
        else
            t.ring.Position = UDim2.fromOffset(px, py)
            t.ring.Size = UDim2.fromOffset(sx, sy)
            t.ring.Visible = true
        end

        local space = self.gui.AbsoluteSize
        local cw, ch = t.card.AbsoluteSize.X, t.card.AbsoluteSize.Y
        local x = ap.X - rp.X + self.root.Position.X.Offset + as.X / 2 - cw / 2
        local y = ap.Y - rp.Y + self.root.Position.Y.Offset + as.Y + pad + 12
        if y + ch > space.Y - 16 then
            y = ap.Y - rp.Y + self.root.Position.Y.Offset - ch - pad - 12
        end
        x = math.clamp(math.floor(x), 16, math.max(16, space.X - cw - 16))
        y = math.clamp(math.floor(y), 16, math.max(16, space.Y - ch - 16))
        tw(t.card, EASE, { Position = UDim2.fromOffset(x, y) })
    else
        t.ring.Visible = false
        local space = self.gui.AbsoluteSize
        tw(t.card, EASE, {
            Position = UDim2.fromOffset(
                math.floor((space.X - t.card.AbsoluteSize.X) / 2),
                math.floor((space.Y - t.card.AbsoluteSize.Y) / 2)),
        })
    end
end

function MonoUI:_tourNext()
    local t = self.tour
    if not t or not t.host.Visible then return end
    t.index = t.index + 1
    local s = t.steps[t.index]
    if not s then return self:EndTour() end

    if s.Before then pcall(s.Before, self) end

    t.step.Text = ("Step %d of %d"):format(t.index, #t.steps)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    t.title.Text = s.Title or ""
    t.nextLbl.Text = (t.index >= #t.steps) and "Done" or "Next"

    local bodyText = s.Body or ""
    t.body.Text = bodyText
    local innerW = t.cardW - 32
    local bodySize = math.floor(13 * TEXT_SCALE + 0.5)
    local okB, bz = pcall(function()
        return TextService:GetTextSize(bodyText, bodySize, FONT_REG, Vector2.new(innerW, 10000))
    end)
    local bh = math.max(okB and math.ceil(bz.Y) or 60, 18)
    t.body.Size = UDim2.fromOffset(innerW, bh)
    t.card.Size = UDim2.fromOffset(t.cardW, bh + 114)

    local rawTarget = s.Target
    local myIndex = t.index
    task.spawn(function()
        RunService.Heartbeat:Wait()
        RunService.Heartbeat:Wait()
        if t.index ~= myIndex or not t.host.Visible then return end
        local target = rawTarget
        if typeof(target) == "function" then
            local ok, r = pcall(target, self)
            target = ok and r or nil
        end
        self:_tourPlace(target)
    end)
end

function MonoUI:StartTour()
    local t = self.tour
    if not t or #t.steps == 0 then return end
    t.index = 0
    t.ring.Visible = false
    t.host.Visible = true
    BLOCKED.on = true
    self:_setFade(t.host, 1)
    self:_fade(t.host, 0, OPEN)
    tw(t.shade, OPEN, { BackgroundTransparency = 0.55 })
    self:_tourNext()
end

function MonoUI:EndTour()
    local t = self.tour
    if not t or not t.host.Visible then return end
    BLOCKED.on = false
    self:_fade(t.host, 1, CLOSE)
    tw(t.shade, CLOSE, { BackgroundTransparency = 1 })
    task.delay(0.26, function() t.host.Visible = false end)
    if self.onTourEnd then pcall(self.onTourEnd) end
end

function MonoUI:_buildBadge()
    local cfg = self.cfg or {}
    local hasLogo = self.logoId ~= nil
    local markRect = hasLogo and cfg.LogoMarkRect or nil
    local BW, BH
    if markRect then BW, BH = 52, 52
    elseif hasLogo then BW, BH = 106, 46
    else BW, BH = 46, 46 end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece

    local SS = 0.05
    self.badge = new("ImageButton", {
        Image = SQUIRCLE.img, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = SQUIRCLE.rect, SliceScale = SS,
        ImageColor3 = T.root, BackgroundTransparency = 1, AutoButtonColor = false,
        Size = UDim2.fromOffset(BW, BH), Visible = false, ZIndex = 30, Parent = self.gui,
    })
    new("UIGradient", {
        Rotation = 90, Parent = self.badge,
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(214, 214, 214)),
    })
    new("ImageLabel", {
        Image = SQ_OUTLINE.img, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = SQ_OUTLINE.rect, SliceScale = SS,
        ImageColor3 = T.stroke, ImageTransparency = 0,
        BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
        ZIndex = 32, Parent = self.badge,
    })

    local parts = {}
    local function crop(rect, posY, w, h)
        parts[#parts + 1] = new("ImageLabel", {
            Image = self.logoId, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit,
            ImageRectOffset = Vector2.new(rect[1], rect[2]),
            ImageRectSize = Vector2.new(rect[3], rect[4]),
            ImageColor3 = T.text, AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, posY), Size = UDim2.fromOffset(w, h),
            ZIndex = 31, Parent = self.badge,
        })
    end
    if markRect then
        crop(markRect, 0.5, 32, 24)
    elseif hasLogo then
        parts[1] = new("ImageLabel", {
            Image = self.logoId, BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Fit, ImageColor3 = T.text,
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(BW - 24, 24), ZIndex = 31, Parent = self.badge,
        })
    else
        parts[1] = text({
            Text = "M", Font = FONT_BOLD, TextSize = 20, TextColor3 = T.text,
            Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 31, Parent = self.badge,
        })
    end
    local function paintMark(c)
        for _, p in ipairs(parts) do
            if p:IsA("ImageLabel") then tw(p, FAST, { ImageColor3 = c })
            else tw(p, FAST, { TextColor3 = c }) end
        end
    end
    self.badge.MouseEnter:Connect(function()
        tw(self.badge, FAST, { ImageColor3 = T.panelHover })
        paintMark(T.onTrack)
    end)
    self.badge.MouseLeave:Connect(function()
        tw(self.badge, FAST, { ImageColor3 = T.root })
        paintMark(T.text)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end)

    local downAt, moved = nil, false
    self.badge.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            downAt, moved = i.Position, false
        end
    end)
    self.badge.InputChanged:Connect(function(i)
        if downAt and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            if math.abs(i.Position.X - downAt.X) > 3 or math.abs(i.Position.Y - downAt.Y) > 3 then
                moved, self._badgeMoved = true, true
            end
        end
    end)
    self.badge.MouseButton1Click:Connect(function()
        local wasDrag = moved
        downAt, moved = nil, false
        if not wasDrag then self:Restore() end
    end)
    self:_drag(self.badge, self.badge)
end

function MonoUI:_clampToScreen(x, y, w, h)
    local M = 8
    local space = self.gui.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    return UDim2.fromOffset(
        math.clamp(math.floor(x), M, math.max(M, space.X - w - M)),
        math.clamp(math.floor(y), inset.Y + M, math.max(inset.Y + M, space.Y - h - M)))
end

function MonoUI:Present()
    if self._presented or self._destroyed then return end
    self._presented = true
    self.root.GroupTransparency = 1
    tw(self.root, OPEN, { GroupTransparency = 0 })
    if self.rootStroke then
        tw(self.rootStroke, OPEN, { Transparency = baseOf(self.rootStroke, "Transparency") })
    end
end

function MonoUI:Minimize()
    if self.minimized then return end
    self.minimized = true
    if self.drawer.Visible then self:CloseDrawer() end
    if not self._badgeMoved then
        local rp, rs, bs = self.root.Position, self.root.AbsoluteSize, self.badge.AbsoluteSize
        self.badge.Position = self:_clampToScreen(
            rp.X.Offset + math.floor(rs.X / 2) - math.floor(bs.X / 2),
            rp.Y.Offset + math.floor(rs.Y / 2) - math.floor(bs.Y / 2), bs.X, bs.Y)
    end
    tw(self.root, WIN_FADE, { GroupTransparency = 1 })
    if self.rootStroke then tw(self.rootStroke, WIN_FADE, { Transparency = 1 }) end
    task.delay(0.06, function()
        if not self.minimized then return end
        self.badge.Visible = true
        self:_setFade(self.badge, 1)
        self:_fade(self.badge, 0, WIN_FADE)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end)
    task.delay(0.26, function()
        if not self.minimized then return end
        self.root.Visible = false
    end)
end

function MonoUI:Restore()
    if not self.minimized then return end
    self.minimized = false
    if self.fullscreen then
        local space   = self.gui.AbsoluteSize
        local inset   = GuiService:GetGuiInset()
        local usableY = space.Y - inset.Y
        local M = 18
        self.root.Size = UDim2.fromOffset(space.X - M * 2, usableY - M * 2)
        self.root.Position = UDim2.fromOffset(M, inset.Y + M)
    else
        local bp, bs, rs = self.badge.Position, self.badge.AbsoluteSize, self.root.AbsoluteSize
        self.root.Position = self:_clampToScreen(
            bp.X.Offset + math.floor(bs.X / 2) - math.floor(rs.X / 2),
            bp.Y.Offset + math.floor(bs.Y / 2) - math.floor(rs.Y / 2), rs.X, rs.Y)
    end
    self:_fade(self.badge, 1, WIN_FADE)
    task.delay(0.24, function()
        if self.minimized then return end
        self.badge.Visible = false
    end)
    self.root.Visible = true
    self.root.GroupTransparency = 1
    tw(self.root, WIN_FADE, { GroupTransparency = 0 })
    if self.rootStroke then
        self.rootStroke.Transparency = 1
        tw(self.rootStroke, WIN_FADE, { Transparency = baseOf(self.rootStroke, "Transparency") })
    end
end

function MonoUI:ToggleFullscreen()
    local M = 18
    if self.fullscreen then
        self.fullscreen = false
        local ps = self._preSize
        local w = ps.X.Offset > 0 and ps.X.Offset or self.root.AbsoluteSize.X
        local h = ps.Y.Offset > 0 and ps.Y.Offset or self.root.AbsoluteSize.Y
        tw(self.root, EASE, {
            Size = ps,
            Position = self:_clampToScreen(self._prePos.X.Offset, self._prePos.Y.Offset, w, h),
        })
        setIcon(self.fullImg, "maximize")
        self.fullImg:SetAttribute("Active", false)
        tw(self.fullImg, FAST, { ImageColor3 = T.dim })
    else
        self.fullscreen = true
        self._preSize, self._prePos = self.root.Size, self.root.Position
        local space   = self.gui.AbsoluteSize
        local inset   = GuiService:GetGuiInset()
        local usableY = space.Y - inset.Y

        tw(self.root, EASE, {
            Size = UDim2.fromOffset(space.X - M * 2, usableY - M * 2),
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            Position = UDim2.fromOffset(M, inset.Y + M),
        })
        setIcon(self.fullImg, "minimize")
        self.fullImg:SetAttribute("Active", true)
        tw(self.fullImg, FAST, { ImageColor3 = T.star })
    end
    task.delay(0.27, function() self:SetLayout(nil, false) end)
end

function MonoUI:Destroy()
    if self._destroyed then return end
    self._destroyed = true

    for _, m in ipairs(self.allModules) do
        if not m.action and m.state then pcall(function() m:Toggle(false) end) end
    end

    if self._releaseWheel then pcall(self._releaseWheel) end
    local OUT = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local rs = self.root.AbsoluteSize
    local rx, ry = self.root.Position.X.Offset, self.root.Position.Y.Offset
    local sx, sy = math.floor(rs.X * 0.9), math.floor(rs.Y * 0.9)
    tw(self.root, OUT, {
        GroupTransparency = 1,
        Size = UDim2.fromOffset(sx, sy),
        Position = UDim2.fromOffset(rx + math.floor((rs.X - sx) / 2), ry + math.floor((rs.Y - sy) / 2)),
    })
    if self.rootStroke then tw(self.rootStroke, OUT, { Transparency = 1 }) end
    if self.badge then self:_fade(self.badge, 1, CLOSE) end

    task.delay(0.36, function()
        if self._releaseWheel then pcall(self._releaseWheel) end
        if getgenv and getgenv().MONOUI_CLEANUP then pcall(getgenv().MONOUI_CLEANUP) end
        if getgenv then
            getgenv().MONOUI_CLEANUP = nil
            getgenv().MONOUI = nil
        end
        pcall(function() self.gui:Destroy() end)
        if getgenv then getgenv().__mono_gui = nil end
        if self.onDestroy then pcall(self.onDestroy) end
    end)
end

function MonoUI:SetLayout(opts, animate)
    opts = opts or {}
    self.layout = self.layout or { side = "Left", search = "Top" }
    if opts.side   then self.layout.side   = opts.side end
    if opts.search then self.layout.search = opts.search end

    local function clean(props)
        local t = {}
        for k, v in pairs(props) do if k ~= "__fast" then t[k] = v end end
        return t
    end
    local put = animate
        and function(o, props) tw(o, props.__fast and FAST or EASE, clean(props)) end
        or  function(o, props) for k, v in pairs(clean(props)) do o[k] = v end end

    local L, TB, SW = self.layout, self.TOPBAR_H, self.SIDE_W

-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    local BOTTOM_H, PAD, GUTTER = 62, 13, 12
    local bottom = L.side == "Bottom"
    local right  = L.side == "Right"
    local w      = self._sideShown == false and 0 or SW

    if bottom then
        put(self.side, { Position = UDim2.new(0, 0, 1, -BOTTOM_H), Size = UDim2.new(1, 0, 0, BOTTOM_H) })
    else
        put(self.side, {
            Position = UDim2.fromOffset(right and (self.root.AbsoluteSize.X - w) or 0, TB + PAD),
            Size = UDim2.new(0, w, 1, -TB - PAD), __fast = not self._sideShown })
    end

    local layout = self.catList:FindFirstChildWhichIsA("UIListLayout")
    layout.FillDirection = bottom and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    self.catList.AutomaticCanvasSize = bottom and Enum.AutomaticSize.X or Enum.AutomaticSize.Y
    local ce = scrollerEntry(self.catList)
    if ce and ce.horizontal ~= (bottom or nil) then
        ce.horizontal = bottom or nil
        ce.vel = 0
        self.catList.CanvasPosition = Vector2.new(0, 0)
    end
    self.catHeader.Visible = not bottom
    if bottom then
        self.catList.Position = UDim2.fromOffset(8, 10)
        self.catList.Size     = UDim2.new(1, -16, 0, 42)
    else
        self.catList.Position = UDim2.fromOffset(8, 42)
        self.catList.Size     = UDim2.new(0, SW - 16, 1, -54)
    end
    for _, c in ipairs(self.categories) do
        c.button.Size = bottom and UDim2.fromOffset(MOBILE and 190 or 150, CAT_H) or UDim2.new(1, 0, 0, CAT_H)
    end

    local cx = (bottom or right) and 16 or (w + GUTTER)
    put(self.content, {
        Position = UDim2.fromOffset(cx, TB + PAD),
        Size = UDim2.new(1, bottom and -32 or (-w - GUTTER - 16), 1,
            -TB - PAD - 14 - (bottom and BOTTOM_H or 0)),
        __fast = not self._sideShown })

    if L.search == "Bottom" then
        put(self.searchBox, { Position = UDim2.new(0, 0, 1, -SEARCH_H) })
        put(self.modList,   { Position = UDim2.fromOffset(0, 0) })
    else
        put(self.searchBox, { Position = UDim2.fromOffset(0, 0) })
        put(self.modList,   { Position = UDim2.fromOffset(0, SEARCH_H + 12) })
    end
    put(self.modList, { Size = UDim2.new(1, 0, 1, -SEARCH_H - 12) })

    local grad = self.dividerLine:FindFirstChildWhichIsA("UIGradient")
    if bottom then
        self.dividerLine.Position = UDim2.new(0, 0, 1, -BOTTOM_H)
        self.dividerLine.Size = UDim2.new(1, 0, 0, 1)
        if grad then grad.Rotation = 0 end
    else
        self.dividerLine.Position = UDim2.fromOffset(right and (self.root.AbsoluteSize.X - w) or w, TB + 1)
        self.dividerLine.Size = UDim2.new(0, 1, 1, -TB - 1)
        if grad then grad.Rotation = 90 end
    end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    local onModules = (not self.activeTab) or self.activeTab.name == "Modules"
    self:_setDivider(onModules and (bottom or (self._sideShown ~= false)), animate)
    self.edgeStrip.Position = UDim2.fromOffset(right and (self.root.AbsoluteSize.X - 16) or 0, TB + PAD)

    if self.midIcons then
        self.midIcons.Position = UDim2.fromOffset(
            math.floor((self.root.AbsoluteSize.X - self.midIcons.AbsoluteSize.X) / 2 + 0.5), 0)
    end
end

function MonoUI:_setDivider(shown, animate)
    local line = self.dividerLine
    if not line then return end
    if shown then line.Visible = true end
    if animate then
        tw(line, shown and OPEN or FAST, { BackgroundTransparency = shown and 0.35 or 1 })
        if not shown then
            task.delay(0.16, function()
                if line.BackgroundTransparency >= 0.99 then line.Visible = false end
            end)
        end
    else
        line.BackgroundTransparency = shown and 0.35 or 1
        line.Visible = shown
    end
end

function MonoUI:_setSidebar(shown, animate)
    if self._sideShown == shown then return end
    self._sideShown = shown
    local onModules = (not self.activeTab) or self.activeTab.name == "Modules"
    if shown and onModules then self.side.Visible = true end
    self:_fade(self.side, shown and 0 or 1, animate and (shown and OPEN or FAST) or TweenInfo.new(0))
    self:SetLayout(nil, animate)
end

function MonoUI:SetCompact(v)
    self.compact = v and true or false
    local h = self.compact and ROW_H_COMPACT or ROW_H
    for _, m in ipairs(self.allModules) do
        tw(m.row, EASE, { Size = UDim2.new(1, 0, 0, h) })
        if m.descLbl then m.descLbl.Visible = (not self.compact) and self.showDesc ~= false end
    end
    if self.layoutImg then
        setIcon(self.layoutImg, self.compact and "rows-3" or "panels-top-left")
        self.layoutImg:SetAttribute("Active", self.compact)
        tw(self.layoutImg, FAST, { ImageColor3 = self.compact and T.star or T.dim })
    end

    self.edgeStrip.Visible = self.compact
    self:_setSidebar(not self.compact, true)

    if not self._hoverWired then
        self._hoverWired = true

        sig(UserInputService.InputChanged):Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if not self.compact or not self.root.Parent then return end
            local p  = UserInputService:GetMouseLocation()
            local ins = GuiService:GetGuiInset()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            local o  = self.root.AbsolutePosition
            local x, y = p.X - o.X, p.Y - ins.Y - o.Y

            local w = self._sideShown and self.SIDE_W or 16
            local inside = x >= 0 and x <= w and y >= self.TOPBAR_H and y <= self.root.AbsoluteSize.Y
            if inside and not self._sideShown then
                self:_setSidebar(true, true)
            elseif not inside and self._sideShown then
                self:_setSidebar(false, true)
            end
        end)
    end
end

function MonoUI:SetTextScale(mult)
    TEXT_SCALE = mult
    for _, d in ipairs(self.gui:GetDescendants()) do
        local base = d:GetAttribute("BaseTextSize")
        if base then d.TextSize = math.floor(base * mult + 0.5) end
    end
end

function MonoUI:SetFontFamily(name)
    local fam = FAMILIES[name]
    if not fam then return end
    FONT_REG, FONT, FONT_BOLD = fam[1], fam[2], fam[3]
    local byRole = { reg = FONT_REG, med = FONT, bold = FONT_BOLD }
    for _, d in ipairs(self.gui:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextBox") or d:IsA("TextButton") then
            local role = d:GetAttribute("FontRole")
            if role and byRole[role] then d.Font = byRole[role] end
        end
    end
end

function MonoUI:SetAccent(color)
    T.star, T.onTrack = color, color
    for _, m in ipairs(self.allModules) do
        if m._paint then m._paint(true) end
        if m._paintStar then m._paintStar() end
    end
    for _, c in ipairs(self.categories) do
        if c == self.activeCategory then
            tw(c.iconImg, FAST, { ImageColor3 = (c == self.favCategory) and T.star or T.text })
        end
    end
    if self.layoutImg and self.compact then tw(self.layoutImg, FAST, { ImageColor3 = T.star }) end

    for _, d in ipairs(self.gui:GetDescendants()) do
        local role = d:GetAttribute("AccentRole")
        if role == "fill" then
            tw(d, FAST, { BackgroundColor3 = color })
        elseif role == "track" and d:GetAttribute("AccentOn") then
            tw(d, FAST, { BackgroundColor3 = color })
        elseif role == "knob" and d:GetAttribute("AccentOn") then
            tw(d, FAST, { BackgroundColor3 = contrastKnob(color) })
        end
    end
end

-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
function MonoUI:SetOpacity(pct)
    local a = 1 - math.clamp(pct, 20, 100) / 100
    self.root.BackgroundTransparency = a

    self.root:SetAttribute("_base_BackgroundTransparency", a)
end

function MonoUI:ResetSettings()
    for _, cfg in ipairs(self.uiSettings or {}) do
        if cfg.Title and cfg.Default ~= nil then
            local cur = cfg.Value
            if cur == nil then cur = cfg.Default end
            if cur ~= cfg.Default then
                cfg.Value = cfg.Default
                if cfg.Callback then pcall(cfg.Callback, cfg.Default) end
            end
        end
    end
    if self._refreshSettings then self._refreshSettings() end
end

function MonoUI:_buildUISettings()
    local accents = {
        Gray   = Color3.fromRGB(205, 205, 205),
        Orange = Color3.fromRGB(255, 157, 46), White = Color3.fromRGB(232, 232, 232),
        Blue   = Color3.fromRGB(80, 160, 255), Green = Color3.fromRGB(96, 210, 130),
        Red    = Color3.fromRGB(255, 92, 92),  Purple = Color3.fromRGB(178, 130, 255),
    }
    self.uiSettings = {
        { Type = "Section", Text = "APPEARANCE" },
        { Type = "Dropdown", Title = "Accent",
          Values = { "Gray", "Orange", "White", "Blue", "Green", "Red", "Purple" },
          Default = "Gray", Callback = function(v) self:SetAccent(accents[v] or accents.Gray) end },
        { Type = "Dropdown", Title = "Font", Values = FAMILY_ORDER, Default = FAMILY_ORDER[1],
          Callback = function(v) self:SetFontFamily(v) end },
        { Type = "Dropdown", Title = "Text Size", Values = { "Small", "Normal", "Large", "Huge" },
          Default = "Normal", Callback = function(v)
              self:SetTextScale(({ Small = 1.0, Normal = 1.15, Large = 1.3, Huge = 1.45 })[v] or 1.15)
          end },
        { Type = "Slider", Title = "Opacity", Min = 40, Max = 100, Default = 100,
          Callback = function(v) self:SetOpacity(v) end },

        { Type = "Section", Text = "LAYOUT" },
        { Type = "Dropdown", Title = "Categories", Values = { "Left", "Right", "Bottom" },
          Default = "Left", Callback = function(v) self:SetLayout({ side = v }, true) end },
        { Type = "Dropdown", Title = "Search Bar", Values = { "Top", "Bottom" },
          Default = "Top", Callback = function(v) self:SetLayout({ search = v }, true) end },
        { Type = "Toggle", Title = "Compact Rows", Default = false,
          Callback = function(v) self:SetCompact(v) end },
        { Type = "Slider", Title = "Width", Min = 700, Max = 1100, Default = self.root.AbsoluteSize.X,
          Callback = function(v)
              if self.fullscreen then self:ToggleFullscreen() end
              self.root.Size = UDim2.fromOffset(v, self.root.AbsoluteSize.Y)
              self._preSize = self.root.Size
              self:Recenter(); self:SetLayout(nil, false)
          end },
        { Type = "Slider", Title = "Height", Min = 400, Max = 760, Default = self.root.AbsoluteSize.Y,
          Callback = function(v)
              if self.fullscreen then self:ToggleFullscreen() end
              self.root.Size = UDim2.fromOffset(self.root.AbsoluteSize.X, v)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
              self._preSize = self.root.Size
              self:Recenter(); self:SetLayout(nil, false)
          end },
        { Type = "Button", Title = "Recenter Window", Callback = function() self:Recenter() end },

        { Type = "Section", Text = "BEHAVIOR" },
        { Type = "Toggle", Title = "Show Descriptions", Default = true,
          Callback = function(v)
              self.showDesc = v
              for _, m in ipairs(self.allModules) do
                  if m.descLbl then m.descLbl.Visible = v and not self.compact end
              end
          end },
        { Type = "Toggle", Title = "Show Keybinds", Default = true,
          Callback = function(v)
              for _, m in ipairs(self.allModules) do if m.chip then m.chip.Visible = v end end
          end },
        { Type = "Toggle", Title = "Animations", Default = true,
          Callback = function(v) ANIM.on = v end },
        { Type = "Toggle", Title = "Smooth Scrolling", Default = true,
          Callback = function(v) self:SetSmoothScroll(v) end },
        { Type = "Toggle", Title = "Smooth Dragging", Default = false,
          Callback = function(v) self:SetSmoothDrag(v) end },
    }
end

local activeSlider = nil
sig(UserInputService.InputChanged):Connect(function(i)
    if not activeSlider then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
        activeSlider(i.Position.X)
    end
end)
sig(UserInputService.InputEnded):Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
        activeSlider = nil
    end
end)

local function settingValue(cfg)
    if cfg.Value == nil then cfg.Value = cfg.Default end
    return cfg.Value
end

function MonoUI:_setting(cfg, body)
    local kind = cfg.Type or "Toggle"
    body = body or self.drawerBody

    if kind == "Toggle" then

        local row = panel({ Class = "TextButton", Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.inset, BackgroundTransparency = 1,
            AutoButtonColor = false, ZIndex = 22, Parent = body }, 7)
        local lbl = text({ Text = cfg.Title or "Toggle", TextSize = 14, TextColor3 = T.text,
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(1, -66, 0, 16), ZIndex = 23, Parent = row })
        local state = settingValue(cfg) and true or false
        local track = panel({ AnchorPoint = Vector2.new(1, 0.5),
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(TRACK_W, TRACK_H),
            BackgroundColor3 = state and T.onTrack or T.offTrack,
            ZIndex = 23, Parent = row }, 11)
        stroke(track, T.stroke, 11, 0.45)
        local knob = panel({ AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, state and KNOB_ON or KNOB_PAD, 0.5, 0), Size = UDim2.fromOffset(KNOB_D, KNOB_D),
            BackgroundColor3 = state and contrastKnob(T.onTrack) or T.offKnob,
            ZIndex = 24, Parent = track }, 8)
        track:SetAttribute("AccentRole", "track")
        track:SetAttribute("AccentOn", state)
        knob:SetAttribute("AccentRole", "knob")
        knob:SetAttribute("AccentOn", state)
        row.MouseEnter:Connect(function() tw(row, FAST, { BackgroundTransparency = 0 }) end)
        row.MouseLeave:Connect(function() tw(row, FAST, { BackgroundTransparency = 1 }) end)
        row.MouseButton1Click:Connect(function()
            state = not state
            cfg.Value = state
            track:SetAttribute("AccentOn", state)
            knob:SetAttribute("AccentOn", state)
            tw(track, EASE, { BackgroundColor3 = state and T.onTrack or T.offTrack })
            tw(knob, EASE, { BackgroundColor3 = state and contrastKnob(T.onTrack) or T.offKnob,
                             Position = UDim2.new(0, state and KNOB_ON or KNOB_PAD, 0.5, 0) })
            if cfg.Callback then task.spawn(cfg.Callback, state) end
        end)

    elseif kind == "Slider" then
        local row = new("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, ZIndex = 22, Parent = body })
        text({ Text = cfg.Title or "Slider", TextSize = 14, TextColor3 = T.text,
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -60, 0, 16), ZIndex = 23, Parent = row })
        local min, max = cfg.Min or 0, cfg.Max or 100
        local value = settingValue(cfg) or min
        local function fmtVal(v)
            if cfg.Format then
                local ok, str = pcall(cfg.Format, v)
                if ok and type(str) == "string" then return str end
            end
            return tostring(v)
        end
        local valLbl = text({ Text = fmtVal(value), TextSize = 12, TextColor3 = T.sub,
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0),
            Size = UDim2.fromOffset(46, 16), TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 23, Parent = row })

        local KNOB = 14
        local bar = panel({ Position = UDim2.new(0, 10, 0, 31), Size = UDim2.new(1, -20, 0, 4),
            BackgroundColor3 = T.offTrack, ZIndex = 23, Parent = row }, 2)
        local a = math.clamp((value - min) / math.max(max - min, 1), 0, 1)
        local fill = panel({ Size = UDim2.new(a, 0, 1, 0), BackgroundColor3 = T.onTrack, ZIndex = 24, Parent = bar }, 2)
        fill:SetAttribute("AccentRole", "fill")
        local knob = panel({ AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(a, 0, 0.5, 0),
            Size = UDim2.fromOffset(KNOB, KNOB), BackgroundColor3 = T.offKnob, ZIndex = 25, Parent = bar }, KNOB / 2)
        local hit = new("TextButton", { BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
            Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 20), ZIndex = 26, Parent = row })
        local function apply(px)
            local rel = math.clamp((px - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            local v = math.floor(min + (max - min) * rel + 0.5)
            if cfg.Adjust then
                local ok, adj = pcall(cfg.Adjust, v)
                if ok and type(adj) == "number" then v = math.clamp(adj, min, max) end
            end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            rel = (v - min) / math.max(max - min, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            if v ~= value then
                value = v; cfg.Value = v; valLbl.Text = fmtVal(v)
                if cfg.Callback then task.spawn(cfg.Callback, v) end
            end
        end
        hit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                activeSlider = apply
                apply(i.Position.X)
            end
        end)
        hit.Destroying:Connect(function()
            if activeSlider == apply then activeSlider = nil end
        end)

    elseif kind == "Keybind" then
        local row = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1,
            ZIndex = 22, Parent = body })
        text({ Text = cfg.Title or "Keybind", TextSize = 14, TextColor3 = T.text,
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(1, -110, 0, 16), ZIndex = 23, Parent = row })
        local chip = panel({ Class = "TextButton", AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(76, 24),
            BackgroundColor3 = T.inset, AutoButtonColor = false, ZIndex = 23, Parent = row }, 6)
        local lbl = text({ Text = "", TextSize = 12, TextColor3 = T.sub,
            Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 24, Parent = chip })
        local function repaint()
            local listening = (self.listeningCfg == cfg)
            lbl.Text = listening and "..." or (keyLabel(settingValue(cfg)) or "None")
            tw(lbl, FAST, { TextColor3 = listening and T.star or T.sub })
        end
        cfg._repaint = repaint
        repaint()
        chip.MouseButton1Click:Connect(function()
            local prev = self.listeningCfg
            self.listeningCfg = (prev == cfg) and nil or cfg
            if prev and prev ~= cfg and prev._repaint then prev._repaint() end
            repaint()
        end)
        chip.MouseButton2Click:Connect(function()
            if self.listeningCfg == cfg then self.listeningCfg = nil repaint() return end
            cfg.Value = cfg.Default
            if cfg.Callback then task.spawn(cfg.Callback, cfg.Value) end
            repaint()
        end)
        chip.MouseEnter:Connect(function() tw(chip, FAST, { BackgroundColor3 = T.panelHover }) end)
        chip.MouseLeave:Connect(function() tw(chip, FAST, { BackgroundColor3 = T.inset }) end)

    elseif kind == "Section" then
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, MOBILE and 34 or 28), BackgroundTransparency = 1,
            ZIndex = 22, Parent = body,
        })
        local lbl = text({
            Text = cfg.Text or "", Font = FONT_BOLD, TextSize = 12,
            TextColor3 = cfg.Color or T.sub,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -6),
            Size = UDim2.new(1, -28, 0, 16), ZIndex = 23, Parent = row,
        })
        local rule = new("Frame", {
            AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -11),
            Size = UDim2.new(1, -38 - math.ceil(lbl.TextBounds.X), 0, 1),
            BackgroundColor3 = T.stroke, BackgroundTransparency = 0.45,
            BorderSizePixel = 0, ZIndex = 23, Parent = row,
        })
        fadeEnds(rule, false, 0.02, 0.16)

    elseif kind == "Label" then
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 22, Parent = body,
        })
        local lbl = text({
            Text = cfg.Text or "", TextSize = 13, Font = FONT_REG,
            TextColor3 = cfg.Color or T.sub, Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(1, -20, 0, 18), TextWrapped = cfg.Wrap and true or false,
            AutomaticSize = cfg.Wrap and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 23, Parent = row,
        })
        if cfg.Register then cfg.Register(function(t) lbl.Text = t or "" end) end

    elseif kind == "Input" then
        local row = new("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, ZIndex = 22, Parent = body })
        text({ Text = cfg.Title or "Input", TextSize = 14, TextColor3 = T.text,
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 0, 16), ZIndex = 23, Parent = row })
        local box = panel({ Position = UDim2.fromOffset(10, 24), Size = UDim2.new(1, -20, 0, 30),
            BackgroundColor3 = T.inset, ZIndex = 23, Parent = row }, 7)
        stroke(box, T.stroke, 7, 0.55)
        local input = new("TextBox", {
            BackgroundTransparency = 1, Text = tostring(settingValue(cfg) or ""),
            PlaceholderText = cfg.Placeholder or "", TextColor3 = T.text, PlaceholderColor3 = T.dim,
            Font = FONT_REG, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false, Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -24, 1, 0), ZIndex = 24, Parent = box,
        })
        input:SetAttribute("FontRole", "reg")
        input:SetAttribute("BaseTextSize", 13)
        input.FocusLost:Connect(function(enter)
            cfg.Value = input.Text
            if cfg.Callback then task.spawn(cfg.Callback, input.Text, enter) end
        end)

    elseif kind == "Button" then
        local box = panel({ Class = "TextButton", Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = T.inset, AutoButtonColor = false, ZIndex = 22, Parent = body }, 7)
        local lbl = text({ Text = cfg.Title or "Button", TextSize = 12, TextColor3 = T.sub,
            Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 23, Parent = box })
        box.MouseEnter:Connect(function()
            tw(box, FAST, { BackgroundColor3 = T.panelHover }); tw(lbl, FAST, { TextColor3 = T.text })
        end)
        box.MouseLeave:Connect(function()
            tw(box, FAST, { BackgroundColor3 = T.inset }); tw(lbl, FAST, { TextColor3 = T.sub })
        end)
        box.MouseButton1Click:Connect(function()
            if cfg.Callback then task.spawn(cfg.Callback) end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        end)

    elseif kind == "Dropdown" then

        local values = cfg.Values or (cfg.GetValues and cfg.GetValues()) or {}
        local current = settingValue(cfg)
        local ROW_H, ENTRY_H, OPEN_MAX = 34, 28, 132

        local holder = new("Frame", { Size = UDim2.new(1, 0, 0, ROW_H), BackgroundTransparency = 1,
            ClipsDescendants = true, ZIndex = 22, Parent = body })
        local box = panel({ Class = "TextButton", Size = UDim2.new(1, 0, 0, ROW_H),
            BackgroundColor3 = T.inset, AutoButtonColor = false, ZIndex = 22, Parent = holder }, 7)
        local lbl = text({ Text = (cfg.Title and (cfg.Title .. " - ") or "") .. tostring(current or "none"),
            TextSize = 12, TextColor3 = T.sub, AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.new(1, -40, 0, 16), ZIndex = 23, Parent = box })
        local chev = icon("chevron-down", { Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -11, 0.5, 0), ImageColor3 = T.dim, ZIndex = 23, Parent = box })

        local list = new("ScrollingFrame", {
            Position = UDim2.fromOffset(0, ROW_H + 4), Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
            ScrollBarImageColor3 = T.stroke, CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 22, Parent = holder,
        })
        new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

        local open, entries = false, {}
        local addEntry
        local function paintEntries()
            for v, e in pairs(entries) do
                tw(e.lbl, FAST, { TextColor3 = (v == current) and T.text or T.dim })
                tw(e.box, FAST, { BackgroundTransparency = (v == current) and 0 or 1 })
            end
        end
        addEntry = function(i, v)
            local e = panel({ Class = "TextButton", Size = UDim2.new(1, 0, 0, ENTRY_H),
                BackgroundColor3 = T.panelHover, BackgroundTransparency = 1,
                AutoButtonColor = false, LayoutOrder = i, ZIndex = 23, Parent = list }, 6)
            local el = text({ Text = tostring(v), TextSize = 12, TextColor3 = T.dim,
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.new(1, -20, 0, 16), ZIndex = 24, Parent = e })
            entries[v] = { box = e, lbl = el }
            e.MouseEnter:Connect(function()
                if v ~= current then tw(e, FAST, { BackgroundTransparency = 0.5 }) end
            end)
            e.MouseLeave:Connect(function()
                if v ~= current then tw(e, FAST, { BackgroundTransparency = 1 }) end
            end)
            e.MouseButton1Click:Connect(function()
                current = v
                cfg.Value = v
                lbl.Text = (cfg.Title and (cfg.Title .. " - ") or "") .. tostring(v)
                paintEntries()
                if cfg.Callback then task.spawn(cfg.Callback, v) end
            end)
        end
        for i, v in ipairs(values) do addEntry(i, v) end
        paintEntries()

        local function setOpen(v)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            open = v
            local h = open and math.min(#values * (ENTRY_H + 2), OPEN_MAX) or 0
            tw(holder, EASE, { Size = UDim2.new(1, 0, 0, ROW_H + (open and (h + 4) or 0)) })
            tw(list, EASE, { Size = UDim2.new(1, 0, 0, h) })
            tw(chev, EASE, { Rotation = open and 180 or 0 })
        end
        if cfg.GetValues then
            cfg.Refresh = function()
                for _, c in ipairs(list:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                entries = {}
                values = cfg.GetValues() or {}
                local stillThere = false
                for _, v in ipairs(values) do if v == current then stillThere = true break end end
                if current ~= nil and not stillThere then
                    current, cfg.Value = nil, nil
                    lbl.Text = (cfg.Title and (cfg.Title .. " - ") or "") .. "none"
                    if cfg.Callback then task.spawn(cfg.Callback, nil) end
                end
                for i, v in ipairs(values) do addEntry(i, v) end
                paintEntries()
            end
        end
        box.MouseButton1Click:Connect(function()
            if cfg.Refresh and not open then cfg.Refresh() end
            setOpen(not open)
        end)
        box.MouseEnter:Connect(function() tw(box, FAST, { BackgroundColor3 = T.panelHover }) end)
        box.MouseLeave:Connect(function() tw(box, FAST, { BackgroundColor3 = T.inset }) end)

        local function guard(inst)
            inst.MouseEnter:Connect(function() body.ScrollingEnabled = false end)
            inst.MouseLeave:Connect(function() body.ScrollingEnabled = true end)
        end
        guard(holder); guard(box); guard(list)
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("TextButton") then guard(c) end
        end
    end
end

local HttpService = game:GetService("HttpService")
local BASE_DIR    = "Mono MM2"
local CONFIG_DIR  = BASE_DIR .. "/configs"
local Stats               = game:GetService("Stats")
local Lighting            = game:GetService("Lighting")
local LocalizationService = game:GetService("LocalizationService")

local function canFiles()
    return typeof(writefile) == "function" and typeof(readfile) == "function"
        and typeof(listfiles) == "function"
end

function MonoUI:_page()
    local f = new("Frame", {
        Position = UDim2.fromOffset(16, self.TOPBAR_H + 13),
        Size = UDim2.new(1, -32, 1, -self.TOPBAR_H - 27),
        BackgroundTransparency = 1, Visible = false, ZIndex = 3, Parent = self.root,
    })
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    return f
end

local function listRow(parent, order, height)
    local row = panel({
        Class = "TextButton", Size = UDim2.new(1, 0, 0, height or 52),
        BackgroundColor3 = T.panel, AutoButtonColor = false,
        LayoutOrder = order, ZIndex = 4, Parent = parent,
    }, 8)
    return row
end

local function scroller(parent, y)
    local sc = new("ScrollingFrame", {
        Position = UDim2.fromOffset(0, y or 0), Size = UDim2.new(1, 0, 1, -(y or 0)),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60), CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3, Parent = parent,
    })
    new("UIPadding", { PaddingRight = UDim.new(0, 8), Parent = sc })
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sc })
    customScrollbar(sc)
    return sc
end

local function captureRow(o)
    eachFadeTarget(o, 0, function() end)
    return o
end

local INFO_H  = MOBILE and 44 or 34
local INFO_LW = MOBILE and 168 or 128
local function infoRow(parent, order, label, value, copyText)
    local row = panel({
        Size = UDim2.new(1, 0, 0, INFO_H), BackgroundColor3 = T.panel,
        LayoutOrder = order, ZIndex = 4, Parent = parent,
    }, 7)
    text({
        Text = label, TextSize = 13, Font = FONT_REG, TextColor3 = T.descText,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
        Size = UDim2.fromOffset(INFO_LW, 16), ZIndex = 6, Parent = row,
    })
    local canCopy = copyText ~= nil and typeof(setclipboard) == "function"
    local pad = canCopy and 42 or 14
    local v = text({
        Text = tostring(value), TextSize = 13, TextColor3 = T.text,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -pad, 0.5, 0),
        Size = UDim2.new(1, -INFO_LW - 22 - pad, 0, 16), TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6, Parent = row,
    })
    if canCopy then
        local b = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, ZIndex = 7, Parent = row,
        })
        local im = icon("copy", {
            Size = UDim2.fromOffset(15, 15), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.faint, ZIndex = 8, Parent = b,
        })
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        b.MouseEnter:Connect(function() tw(im, FAST, { ImageColor3 = T.text }) end)
        b.MouseLeave:Connect(function()
            if not im:GetAttribute("Copied") then tw(im, FAST, { ImageColor3 = T.faint }) end
        end)
        b.MouseButton1Click:Connect(function()
            pcall(setclipboard, tostring(copyText))
            im:SetAttribute("Copied", true)
            setIcon(im, "check")
            im.ImageColor3 = T.onTrack
            task.delay(1.2, function()
                if im.Parent then
                    im:SetAttribute("Copied", nil)
                    setIcon(im, "copy")
                    im.ImageColor3 = T.faint
                end
            end)
        end)
    end
    captureRow(row)
    return row, v
end

local function sectionLabel(parent, order, txt)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 0, MOBILE and 34 or 28), BackgroundTransparency = 1,
        LayoutOrder = order, ZIndex = 4, Parent = parent,
    })
    local lbl = text({
        Text = txt, Font = FONT_BOLD, TextSize = 12, TextColor3 = T.sub,
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -6),
        Size = UDim2.new(1, -28, 0, 16), ZIndex = 5, Parent = f,
    })
    local rule = new("Frame", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -11),
        Size = UDim2.new(1, -38 - math.ceil(lbl.TextBounds.X), 0, 1),
        BackgroundColor3 = T.stroke, BackgroundTransparency = 0.45,
        BorderSizePixel = 0, ZIndex = 5, Parent = f,
    })
    fadeEnds(rule, false, 0.02, 0.16)
    return f
end

function MonoUI:_buildServer()
    local page = self:_page()
    self.pageServer = page

    text({
        Text = "Server", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(2, 4), Size = UDim2.fromOffset(200, 20),
        ZIndex = 4, Parent = page,
    })
    local list = scroller(page, 34)

    local live = {}

    local info = game:GetService("MarketplaceService")
    local placeName, creator, desc = "?", "?", ""
    pcall(function()
        local d = info:GetProductInfo(game.PlaceId)
        placeName = d.Name or "?"
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        creator = (d.Creator and d.Creator.Name) or "?"
        desc = d.Description or ""
    end)

    local function serverKind()
        if game.PrivateServerId ~= "" then
            return game.PrivateServerOwnerId ~= 0 and "Private (VIP)" or "Reserved"
        end
        return "Public"
    end

    local o = 0
    local function add(label, value) o = o + 1; local _, v = infoRow(list, o, label, value); return v end
    local function addCopy(label, value)
        o = o + 1
        local _, v = infoRow(list, o, label, value, value)
        return v
    end
    local function sect(t) o = o + 1; sectionLabel(list, o, t) end

    sect("Place")
    addCopy("Name", placeName)
    addCopy("Creator", creator)
    addCopy("Place ID", game.PlaceId)
    addCopy("Place version", game.PlaceVersion)
    addCopy("Creator ID", game.CreatorId)
    add("Creator type", game.CreatorType.Name)
    addCopy("Universe ID", game.GameId)

    sect("Session")
    local jobId = game.JobId ~= "" and game.JobId or nil
    o = o + 1
    infoRow(list, o, "Job ID", jobId or "(studio)", jobId)
    add("Server type", serverKind())
    live.players = add("Players", "-")
    add("Max players", Players.MaxPlayers)
    add("Preferred players", Players.PreferredPlayers)
    live.uptime = add("Uptime", "-")
    add("Region locale", (function()
        local ok, l = pcall(function() return LocalizationService.RobloxLocaleId end)
        return ok and l or "?"
    end)())

    sect("Performance")
    live.fps = add("FPS", "-")
    live.ping = add("Ping", "-")
    live.mem = add("Memory", "-")
    live.instances = add("Instances", "-")

    sect("World")
    live.gravity = add("Gravity", "-")
    live.time = add("Clock time", "-")
    add("Graphics quality", tostring(settings().Rendering.QualityLevel):gsub("Enum.QualityLevel.", ""))
    add("Streaming enabled", tostring(workspace.StreamingEnabled))
    add("Filtering enabled", tostring(workspace.FilteringEnabled))

    local instText, instAt = "-", 0
    local frames, fps, acc = 0, 0, 0
    local tick = function(dt)
        frames = frames + 1
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        acc = acc + dt
        if acc >= 1 then fps = frames / acc; frames, acc = 0, 0 end
    end
    sig(RunService.RenderStepped):Connect(tick)

    local function refresh()
        if not page.Visible then return end
        live.players.Text = ("%d / %d"):format(#Players:GetPlayers(), Players.MaxPlayers)
        local up = math.floor(workspace.DistributedGameTime)
        live.uptime.Text = ("%dh %dm %ds"):format(up // 3600, (up % 3600) // 60, up % 60)
        live.fps.Text = ("%.0f"):format(fps)
        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)
        live.ping.Text = ok and ping or "?"
        local ok2, mem = pcall(function() return Stats:GetTotalMemoryUsageMb() end)
        live.mem.Text = ok2 and ("%.0f MB"):format(mem) or "?"
        local now2 = os.clock()
        if instAt == 0 or now2 - instAt >= 10 then
            instAt = now2
            instText = ("%d"):format(#game:GetDescendants())
        end
        live.instances.Text = instText
        live.gravity.Text = ("%.0f"):format(workspace.Gravity)
        live.time.Text = ("%.1f"):format(Lighting.ClockTime)
    end
    self._refreshServer = refresh
    task.spawn(function()
        while page.Parent do
            refresh()
            task.wait(1)
        end
    end)
end

function MonoUI:_buildPlayers()
    local page = self:_page()
    self.pagePlayers = page
    self.friends, self.targets = {}, {}

    local pageTitle = text({
        Text = "Players", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(2, 4), Size = UDim2.fromOffset(200, 20),
        ZIndex = 4, Parent = page,
    })
    local count = text({
        Text = "", TextSize = 12, TextColor3 = T.faint, AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 6), Size = UDim2.fromOffset(120, 18),
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4, Parent = page,
    })
    local listWrap = new("Frame", {
        Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34),
        BackgroundTransparency = 1, ZIndex = 3, Parent = page,
    })
    local list = scroller(listWrap, 0)

    local detail = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Visible = false, ZIndex = 3, Parent = page,
    })
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    local backBtn = new("TextButton", {
        Position = UDim2.fromOffset(0, 2), Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        ZIndex = 6, Parent = detail,
    })
    local backImg = icon("arrow-left", {
        Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), ImageColor3 = T.sub, ZIndex = 7, Parent = backBtn,
    })
    backBtn.MouseEnter:Connect(function() tw(backImg, FAST, { ImageColor3 = T.text }) end)
    backBtn.MouseLeave:Connect(function() tw(backImg, FAST, { ImageColor3 = T.sub }) end)

    local card = panel({
        Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, -8, 0, 108),
        BackgroundColor3 = T.panel, ZIndex = 4, Parent = detail,
    }, 8)
    local pfp = panel({
        Class = "ImageLabel", AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 16, 0.5, 0), Size = UDim2.fromOffset(76, 76),
        BackgroundColor3 = T.inset, ZIndex = 6, Parent = card,
    }, 38)
    pfp.ScaleType = Enum.ScaleType.Fit
    local dName = text({
        Text = "", Font = FONT_BOLD, TextSize = 17, TextColor3 = T.text,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 108, 0.5, -16),
        Size = UDim2.new(1, -130, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6, Parent = card,
    })
    local uName = text({
        Text = "", TextSize = 13, Font = FONT_REG, TextColor3 = T.descText,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 108, 0.5, 6),
        Size = UDim2.new(1, -130, 0, 16), ZIndex = 6, Parent = card,
    })
    local tagLbl = text({
        Text = "", TextSize = 12, Font = FONT_REG, TextColor3 = T.star,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 108, 0.5, 28),
        Size = UDim2.new(1, -130, 0, 14), ZIndex = 6, Parent = card,
    })
    local dList = scroller(detail, 152)
    dList.Size = UDim2.new(1, 0, 1, -152)

    local detailToken = 0
    local function openDetail(plr)
        detailToken = detailToken + 1
        local myToken = detailToken
        for _, c in ipairs(dList:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        dName.Text = plr.DisplayName
        uName.Text = "@" .. plr.Name
        local tags = {}
        if self.friends[plr.Name] then tags[#tags + 1] = "Friend" end
        if self.targets[plr.Name] then tags[#tags + 1] = "Target" end
        if plr == Players.LocalPlayer then tags[#tags + 1] = "You" end
        tagLbl.Text = table.concat(tags, "  -  ")

        pfp.Image = ""
        task.spawn(function()

            local ok, url = pcall(function()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                return Players:GetUserThumbnailAsync(plr.UserId,
                    Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            end)
            if ok and url and pfp.Parent then pfp.Image = url end
        end)

        local o = 0
        local function add(label, value) o = o + 1; local _, v = infoRow(dList, o, label, value); return v end
        local function addCopy(label, value)
            o = o + 1
            local _, v = infoRow(dList, o, label, value, value)
            return v
        end
        local function sect(t) o = o + 1; sectionLabel(dList, o, t) end

        sect("Account")
        addCopy("User ID", plr.UserId)
        addCopy("Display name", plr.DisplayName)
        addCopy("Username", plr.Name)
        add("Account age", plr.AccountAge .. " days")
        add("Membership", tostring(plr.MembershipType):gsub("Enum.MembershipType.", ""))
        add("Locale", plr.LocaleId ~= "" and plr.LocaleId or "?")
        add("Team", plr.Team and plr.Team.Name or "None")
        add("Follows you", tostring(plr.FollowUserId == Players.LocalPlayer.UserId))

        if self.DetailExtra then
            local ok, extra = pcall(self.DetailExtra, plr)
            if ok and type(extra) == "table" then
                for _, grp in ipairs(extra) do
                    if grp.Section then sect(grp.Section) end
                    for _, pair in ipairs(grp.Rows or {}) do
                        if pair[3] then addCopy(pair[1], pair[2]) else add(pair[1], pair[2]) end
                    end
                end
            end
        end
        self:_fade(listWrap, 1, FAST)
        task.delay(0.10, function()
            if myToken ~= detailToken then return end
            listWrap.Visible = false
            pageTitle.Visible = false
            detail.Visible = true
            self:_setFade(detail, 1)
            self:_fade(detail, 0, OPEN)
        end)
    end

    backBtn.MouseButton1Click:Connect(function()
        detailToken = detailToken + 1
        self:_fade(detail, 1, FAST)
        task.delay(0.10, function()
            detail.Visible = false
            pageTitle.Visible = true
            listWrap.Visible = true
            self:_setFade(listWrap, 1)
            self:_fade(listWrap, 0, OPEN)
        end)
    end)

    local function mark(store, plr, on, img, color)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        store[plr.Name] = on or nil
        tw(img, FAST, { ImageColor3 = on and color or T.faint })
    end

    local targetIcons = {}
    local function rebuild()
        table.clear(targetIcons)
        for _, c in ipairs(list:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        local players = Players:GetPlayers()
        count.Text = ("%d in server"):format(#players)
        for i, plr in ipairs(players) do
            local row = listRow(list, i)
            local me = plr == Players.LocalPlayer
            text({
                Text = plr.DisplayName .. (me and "  (you)" or ""),
                TextSize = 14, TextColor3 = T.text, AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 16, 0.5, -8), Size = UDim2.new(1, -180, 0, 16),
                ZIndex = 6, Parent = row,
            })
            text({
                Text = "@" .. plr.Name, TextSize = 12, Font = FONT_REG, TextColor3 = T.descText,
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 9),
                Size = UDim2.new(1, -180, 0, 14), ZIndex = 6, Parent = row,
            })

            if not me then
                local fBtn = new("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -52, 0.5, 0),
                    Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Text = "",
                    AutoButtonColor = false, ZIndex = 7, Parent = row,
                })
                local fImg = icon("heart", {
                    Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    ImageColor3 = self.friends[plr.Name] and T.star or T.faint,
                    ZIndex = 8, Parent = fBtn,
                })
                fBtn.MouseButton1Click:Connect(function()
                    mark(self.friends, plr, not self.friends[plr.Name], fImg, T.star)
                end)

                local tBtn = new("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0.5, 0),
                    Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Text = "",
                    AutoButtonColor = false, ZIndex = 7, Parent = row,
                })
                local tImg = icon("crosshair", {
                    Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    ImageColor3 = self.targets[plr.Name] and Color3.fromRGB(255, 92, 92) or T.faint,
                    ZIndex = 8, Parent = tBtn,
                })
                targetIcons[plr.Name] = tImg
                tBtn.MouseButton1Click:Connect(function()
                    local on = not self.targets[plr.Name]
                    if on then
                        for other, img in pairs(targetIcons) do
                            if other ~= plr.Name and self.targets[other] then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                                self.targets[other] = nil
                                tw(img, FAST, { ImageColor3 = T.faint })
                            end
                        end
                    end
                    mark(self.targets, plr, on, tImg, Color3.fromRGB(255, 92, 92))
                    if self.TargetChanged then pcall(self.TargetChanged, plr.Name, on) end
                end)
            end

            row.MouseButton1Click:Connect(function()
                if not self.modalOpen then openDetail(plr) end
            end)
            row.MouseEnter:Connect(function()
                if not self.modalOpen then tw(row, FAST, { BackgroundColor3 = T.panelHover }) end
            end)
            row.MouseLeave:Connect(function() tw(row, FAST, { BackgroundColor3 = T.panel }) end)
        end
    end

    self._rebuildPlayers = function()
        detail.Visible = false
        listWrap.Visible = true
        rebuild()
    end
    rebuild()
    sig(Players.PlayerAdded):Connect(function() task.defer(self._rebuildPlayers) end)
    sig(Players.PlayerRemoving):Connect(function() task.defer(self._rebuildPlayers) end)
end


function MonoUI:GetConfig()
    local mods = {}
    for _, m in ipairs(self.allModules) do
        mods[m.name] = { state = m.state, bind = m.bind, favorite = m.favorite or false }
    end
    local sets = {}
    for _, cfg in ipairs(self.uiSettings or {}) do

        if cfg.Title then
            local v = cfg.Value
            if v == nil then v = cfg.Default end
            sets[cfg.Title] = v
        end
    end
    return { modules = mods, settings = sets,
             friends = self.friends or {}, targets = self.targets or {} }
end

function MonoUI:LoadConfig(data)
    if type(data) ~= "table" then return false end

    for _, cfg in ipairs(self.uiSettings or {}) do
        local v = data.settings and data.settings[cfg.Title]
        if v ~= nil then
            cfg.Value = v
            if cfg.Callback then pcall(cfg.Callback, v) end
        end
    end
    for _, m in ipairs(self.allModules) do
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        local d = data.modules and data.modules[m.name]
        if d then
            m:SetBind(d.bind)
            m:SetFavorite(d.favorite)
            if not m.action and m.state ~= d.state then m:Toggle(d.state) end
        end
    end
    self.friends = data.friends or {}
    self.targets = data.targets or {}
    if self._rebuildPlayers then self._rebuildPlayers() end
    return true
end

function MonoUI:_configPath(name) return CONFIG_DIR .. "/" .. name .. ".json" end

function MonoUI:ListConfigs()
    if not canFiles() then return {} end
    if typeof(isfolder) == "function" and not isfolder(CONFIG_DIR) then
        pcall(makefolder, BASE_DIR); pcall(makefolder, CONFIG_DIR)
    end
    local out = {}
    local ok, files = pcall(listfiles, CONFIG_DIR)
    if ok then
        for _, f in ipairs(files) do
            local n = tostring(f):match("([^/\\]+)%.json$")
            if n then out[#out + 1] = n end
        end
    end
    table.sort(out)
    return out
end

function MonoUI:SaveConfig(name)
    if not canFiles() or name == "" then return false, "no file access" end
    if typeof(isfolder) == "function" and not isfolder(CONFIG_DIR) then
        pcall(makefolder, BASE_DIR); pcall(makefolder, CONFIG_DIR)
    end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(self:GetConfig()) end)
    if not ok then return false, "encode failed" end
    local wrote = pcall(writefile, self:_configPath(name), encoded)
    return wrote, wrote and "saved" or "write failed"
end

function MonoUI:DeleteConfig(name)
    if typeof(delfile) ~= "function" then return false end
    return pcall(delfile, self:_configPath(name))
end

function MonoUI:_buildCredits()
    local page = self:_page()
    self.pageCredits = page

    text({
        Text = "Credits", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(2, 4), Size = UDim2.new(1, -4, 0, 20),
        ZIndex = 4, Parent = page,
    })

    local list = new("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32),
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 4, Parent = page,
    })
    new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
    new("UIPadding", { PaddingRight = UDim.new(0, 8), Parent = list })
    customScrollbar(list)

    local order = 0
    local function card(height)
        order = order + 1
        local c = panel({
            Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = T.panel,
            LayoutOrder = order, ZIndex = 5, Parent = list,
        }, 8)
        stroke(c, T.strokeSoft, 8, 0.55)
        return c
    end

    local head = card(72)
    text({
        Text = "Mono MM2", Font = FONT_BOLD, TextSize = 17, TextColor3 = T.text,
        Position = UDim2.fromOffset(16, 14), Size = UDim2.new(1, -32, 0, 20),
        ZIndex = 6, Parent = head,
    })
    text({
        Text = "A Murder Mystery 2 script by fleece",
        TextSize = 12, Font = FONT_REG, TextColor3 = T.descText,
        Position = UDim2.fromOffset(16, 38), Size = UDim2.new(1, -32, 0, 16),
        ZIndex = 6, Parent = head,
    })

    local function linkRow(label, value, ico, copyText)
        local c = card(56)
        icon(ico, {
            Size = UDim2.fromOffset(20, 20), AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 16, 0.5, 0), ImageColor3 = T.sub, ZIndex = 6, Parent = c,
        })
        text({
            Text = label, TextSize = 11, Font = FONT_REG, TextColor3 = T.faint,
            Position = UDim2.fromOffset(48, 12), Size = UDim2.new(1, -140, 0, 14),
            ZIndex = 6, Parent = c,
        })
        text({
            Text = value, TextSize = 13, Font = FONT_BOLD, TextColor3 = T.text,
            Position = UDim2.fromOffset(48, 28), Size = UDim2.new(1, -140, 0, 16),
            ZIndex = 6, Parent = c,
        })
        if copyText and typeof(setclipboard) == "function" then
            local b = panel({
                Class = "TextButton", AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(66, 26),
                BackgroundColor3 = T.inset, AutoButtonColor = false, ZIndex = 6, Parent = c,
            }, 6)
            local bl = text({
                Text = "Copy", TextSize = 12, TextColor3 = T.sub, Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 7, Parent = b,
            })
            b.MouseEnter:Connect(function() tw(b, FAST, { BackgroundColor3 = T.panelHover }) end)
            b.MouseLeave:Connect(function() tw(b, FAST, { BackgroundColor3 = T.inset }) end)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            b.MouseButton1Click:Connect(function()
                pcall(setclipboard, copyText)
                bl.Text = "Copied"
                task.delay(1.2, function() if bl.Parent then bl.Text = "Copy" end end)
            end)
        end
        return c
    end

    linkRow("Made by", "fleece", "user", nil)
    linkRow("Other Scripts", "robloxscripts.com/user/Fleece", "file-code", "https://robloxscripts.com/user/Fleece")
    linkRow("GitHub", "github.com/fleecewtf", "hammer", "https://github.com/fleecewtf")
    linkRow("Discord", "@zquz", "message-circle", "@zquz")
    linkRow("Icons", "Lucide, via lucide-roblox by mstudio45", "shapes", nil)
end

function MonoUI:_buildConfigs()
    local page = self:_page()
    self.pageConfigs = page

    text({
        Text = "Configs", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(2, 4), Size = UDim2.fromOffset(200, 20),
        ZIndex = 4, Parent = page,
    })
    local status = text({
        Text = "", TextSize = 12, TextColor3 = T.faint, AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 6), Size = UDim2.fromOffset(260, 18),
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4, Parent = page,
    })

    local bar = panel({
        Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, -8, 0, 42),
        BackgroundColor3 = T.inset, ZIndex = 3, Parent = page,
    }, 8)
    stroke(bar, T.stroke, 8, 0.55)
    local nameBox = new("TextBox", {
        BackgroundTransparency = 1, Text = "", PlaceholderText = "Config name...",
        TextColor3 = T.text, PlaceholderColor3 = T.dim, Font = FONT_REG, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
        Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -120, 1, 0),
        ZIndex = 4, Parent = bar,
    })
    nameBox:SetAttribute("FontRole", "reg")
    nameBox:SetAttribute("BaseTextSize", 14)
    local saveBtn = panel({
        Class = "TextButton", AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(92, 28),
        BackgroundColor3 = T.panelHover, AutoButtonColor = false, ZIndex = 5, Parent = bar,
    }, 6)
    text({
        Text = "Save", TextSize = 13, TextColor3 = T.text, Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6, Parent = saveBtn,
    })
    saveBtn.MouseEnter:Connect(function() tw(saveBtn, FAST, { BackgroundColor3 = T.onTrack }) end)
    saveBtn.MouseLeave:Connect(function() tw(saveBtn, FAST, { BackgroundColor3 = T.panelHover }) end)

    local list = scroller(page, 88)

    local function flash(msg)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        status.Text = msg
        task.delay(2.5, function() if status.Text == msg then status.Text = "" end end)
    end

    local function refresh()
        for _, c in ipairs(list:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        local names = self:ListConfigs()
        if #names == 0 then
            text({
                Text = canFiles() and "No saved configs yet."
                    or "This executor has no file access, so configs cannot be saved.",
                TextSize = 13, Font = FONT_REG, TextColor3 = T.faint,
                Size = UDim2.new(1, 0, 0, 20), ZIndex = 5, Parent = list,
            })
            return
        end
        for i, n in ipairs(names) do
            local row = listRow(list, i, 46)
            text({
                Text = n, TextSize = 14, TextColor3 = T.text, AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 16, 0.5, 0), Size = UDim2.new(1, -190, 0, 16),
                ZIndex = 6, Parent = row,
            })
            local function chip(label, xOff, width, cb, danger)
                local b = panel({
                    Class = "TextButton", AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, xOff, 0.5, 0), Size = UDim2.fromOffset(width, 26),
                    BackgroundColor3 = T.inset, AutoButtonColor = false, ZIndex = 7, Parent = row,
                }, 6)
                local l = text({
                    Text = label, TextSize = 12, TextColor3 = T.sub, Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8, Parent = b,
                })
                b.MouseEnter:Connect(function()
                    tw(b, FAST, { BackgroundColor3 = danger and Color3.fromRGB(120, 40, 40) or T.panelHover })
                    tw(l, FAST, { TextColor3 = T.text })
                end)
                b.MouseLeave:Connect(function()
                    tw(b, FAST, { BackgroundColor3 = T.inset }); tw(l, FAST, { TextColor3 = T.sub })
                end)
                b.MouseButton1Click:Connect(cb)
                return b
            end
            chip("Load", -16, 62, function()
                local ok, raw = pcall(readfile, self:_configPath(n))
                if not ok then flash("could not read " .. n) return end
                local okd, data = pcall(function() return HttpService:JSONDecode(raw) end)
                if not okd then flash(n .. " is corrupt") return end
                self:LoadConfig(data)
                flash("loaded " .. n)
            end)
            chip("Save", -84, 62, function()
                local ok = self:SaveConfig(n)
                flash(ok and ("overwrote " .. n) or "save failed")
            end, false)
            chip("Delete", -152, 62, function()
                if self:DeleteConfig(n) then flash("deleted " .. n); refresh()
                else flash("delete failed") end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            end, true)
        end
    end

    saveBtn.MouseButton1Click:Connect(function()
        local n = nameBox.Text:gsub("[^%w _%-]", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if n == "" then flash("give the config a name first") return end
        local ok, why = self:SaveConfig(n)
        flash(ok and ("saved " .. n) or why)
        if ok then nameBox.Text = ""; refresh() end
    end)

    self._refreshConfigs = refresh
    refresh()
end

function MonoUI:_buildSettings()
    local page = self:_page()
    self.pageSettings = page

    text({
        Text = "Settings", Font = FONT_BOLD, TextSize = 16, TextColor3 = T.text,
        Position = UDim2.fromOffset(2, 4), Size = UDim2.fromOffset(200, 20),
        ZIndex = 4, Parent = page,
    })

    local list = scroller(page, 34)
    local lay = list:FindFirstChildWhichIsA("UIListLayout")
    if lay then lay.Padding = UDim.new(0, 10) end

    self._refreshSettings = function()
        for _, c in ipairs(list:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        list.ScrollingEnabled = true
        for _, s in ipairs(self.uiSettings or {}) do self:_setting(s, list) end
    end
end

function MonoUI:_buildPages()
    self:_buildSettings()
    self:_buildPlayers()
    self:_buildServer()
    self:_buildConfigs()
    self:_buildCredits()
end


return MonoUI

]==]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local RS               = game:GetService("ReplicatedStorage")
local TweenService     = game:GetService("TweenService")
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
local VirtualUser; pcall(function() VirtualUser=game:GetService("VirtualUser") end)
local GuiService       = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

local rndSeed = Random.new(tick() * 1e6 % 2147483647)
local function rnd(len)
    local pool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local out = {}
    for i = 1, (len or rndSeed:NextInteger(9, 15)) do
        local j = rndSeed:NextInteger(1, #pool)
        out[i] = pool:sub(j, j)
    end
    return table.concat(out)
end
local Fallback={n=0,used={}}
function Fallback.note(system,level,why,mods)
    Fallback.n=Fallback.n+1
    Fallback.used[Fallback.n]={system=system,level=level,why=why,mods=mods or {}}
end
function Fallback.text()
    if Fallback.n==0 then return nil end
    local out={}
    for i=1,Fallback.n do
        local f=Fallback.used[i]
        out[#out+1]=f.system.." is using "..f.level.." because "..f.why.."."
        if #f.mods>0 then out[#out+1]="   Affects: "..table.concat(f.mods,", ") end
    end
    return table.concat(out,"\n")
end

local function protect(inst)
    pcall(function()
        if typeof(syn) == "table" and syn.protect_gui then syn.protect_gui(inst)
        elseif typeof(protectgui) == "function" then protectgui(inst) end
    end)
end

local mountTarget
do
    local mountLevel
    local function try(f) local ok,v=pcall(f); if ok and typeof(v)=="Instance" then return v end end
    mountTarget = typeof(gethui)=="function" and try(gethui) or nil
    if mountTarget then mountLevel="gethui" end
    if not mountTarget then
        mountTarget = try(function()
            local c=game:GetService("CoreGui")
            local probe=Instance.new("Folder"); probe.Parent=c; probe:Destroy()
            return c
        end)
        if mountTarget then mountLevel="CoreGui" end
    end
    if not mountTarget then
        mountTarget = try(function() return LocalPlayer:FindFirstChildOfClass("PlayerGui") end)
            or LocalPlayer:WaitForChild("PlayerGui",10)
        mountLevel="PlayerGui"
    end
    if mountLevel~="gethui" then
        Fallback.note("Menu hiding",mountLevel,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            mountLevel=="CoreGui" and "gethui is missing, so the menu is in CoreGui where the game could find it"
                or "gethui and CoreGui are both blocked, so the menu sits in PlayerGui in plain sight",
            {"the whole menu","ESP drawings"})
    end
end
local GENV = (typeof(getgenv) == "function") and getgenv() or nil

pcall(function() if GENV and GENV.MONO_Unload then GENV.MONO_Unload() end end)
pcall(function()
    if GENV and type(GENV.MONO_GUIS) == "table" then
        for _, g in ipairs(GENV.MONO_GUIS) do pcall(function() g:Destroy() end) end
    end
end)
for _, g in ipairs(mountTarget:GetChildren()) do
    if g.Name == "Obsidian" or g.Name == "MONO_ESP" or g.Name == "MONO_MINI" then pcall(function() g:Destroy() end) end
end
local TRACKED = {}
if GENV then GENV.MONO_GUIS = TRACKED end
pcall(function()
    if STATE and STATE.onCleanup then
        STATE.onCleanup(function()
            pcall(function() if GENV and GENV.MONO_Unload then GENV.MONO_Unload() end end)
            pcall(function() if typeof(cleardrawcache) == "function" then cleardrawcache() end end)
        end)
    end
end)
local function trackGui(inst) table.insert(TRACKED, inst); protect(inst); return inst end

if typeof(loadstring)~="function" then
    return error("[MONO] Your executor has no loadstring, which the UI library needs.",0)
end
local MonoUI=loadstring(MONOUI_SOURCE)()

local UI={}
local Window
local Unloaded=false
local function isDead() return Unloaded or (Window and Window._destroyed) end

local function create(class,props,children)
    local o=Instance.new(class)
    for k,v in pairs(props or {}) do o[k]=v end
    for _,c in ipairs(children or {}) do c.Parent=o end
    return o
end
local flags={autoKill=false,autoFlingMurderer=false,autoFlingSheriff=false,knifeWalls=false,gunWalls=false,instantKnife=false,gunEsp=false,gunEspDist=false,autoGun=false,aimbot=false,silentAim=false,showFov=false,
    fly=false,flySpeed=60,noclip=false,infJump=false,unlockCam=false,
    espBox=false,espChams=false,footsteps=false,footMine=false,espFill=false,espNames=false,espRoleTags=false,espSkeleton=false,killFeed=false,coinEsp=false,espTracers=false,espAvatar=false,espMaxDist=0,espTracerFrom="Bottom",espBox3D=false,
    fullbright=false,fpsBoost=false,autoCoins=false,murdererNotify=false,antiAfk=false,
    flingPower=10000,flingSeconds=1,trapEsp=false,antiTrap=false,antiFling=false}
local COLLECT_SPEED=16
local aimFov=120
local flinging=false
local Mono={
    tpAt=-10, TP_GRACE=2.5,
    plrs={},
    unclip=setmetatable({},{__mode="k"}),
    mobUp=false, mobDown=false, mobAim=false,
    camThru=nil,
    COIN_MAX_DIST=250,
    wantPS=false,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    wantNoclip=false,
    tagOwners={},
    guiN=0, guiT=0, guiIns=0,
}
function Mono.teleporting() return os.clock()-Mono.tpAt<Mono.TP_GRACE end
function Mono.markTeleport() Mono.tpAt=os.clock() end
Mono.selfTpAt=-10
function Mono.markSelfTP() Mono.selfTpAt=os.clock() end
function Mono.selfTeleporting() return os.clock()-Mono.selfTpAt<0.35 end
local instantFiredAt=-10
local unstick
local conns={}
local function bind(sig,fn) local c=sig:Connect(fn);table.insert(conns,c);return c end
local function notify(msg,t)
    if not Window then return end
    return Window:Notify({Title="Mono",Content=tostring(msg),Duration=t or 3})
end
function Mono.aimCenter()
    local m=UserInputService:GetMouseLocation()
    local x,y=m.X,m.Y
    local ml=LocalPlayer:FindFirstChild("PlayerScripts")
    ml=ml and ml:FindFirstChild("MouseLock")
    if ml and ml:GetAttribute("Enabled")==true
        and UserInputService.PreferredInput~=Enum.PreferredInput.Gamepad then
        local vs=Camera.ViewportSize
        x,y=vs.X*0.5,vs.Y*0.5
    end
    return Vector2.new(x,y)
end
function Mono.aimViewport() return Mono.aimCenter() end
function Mono.mouseGui()
    local c=Mono.aimCenter()
    local ins=GuiService:GetGuiInset()
    return Vector2.new(c.X-ins.X, c.Y-ins.Y)
end

local MM2_UNIVERSE=66654135
local hopFallbackPlace
local function fetchServers(placeId,maxPages,order)
    local out,cursor={},nil
    for _=1,(maxPages or 4) do
        local url="https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder="..(order or "Asc").."&limit=100"
        if cursor then url=url.."&cursor="..HttpService:UrlEncode(cursor) end
        local ok,res=pcall(function() return game:HttpGet(url) end)
        if not ok then break end
        local ok2,d=pcall(function() return HttpService:JSONDecode(res) end)
        if not (ok2 and d and d.data) then break end
        for _,sv in ipairs(d.data) do out[#out+1]=sv end
        cursor=d.nextPageCursor
        if not cursor then break end
    end
    return out
end
bind(TeleportService.TeleportInitFailed,function(plr)
    if plr==LocalPlayer then Mono.hopFailed=true end
end)
local function hopServers(placeId,excludeJob,fallbackTeleport)
    task.spawn(function()
        local function gather(all,minFree)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            local t={}
            for _,sv in ipairs(all) do
                if sv.id and sv.id~=excludeJob
                    and ((sv.maxPlayers or 0)-(sv.playing or 0))>=minFree then t[#t+1]=sv end
            end
            return t
        end
        local all=fetchServers(placeId,2,"Desc")
        local cand=gather(all,2)
        if #cand==0 then
            all=fetchServers(placeId,3,"Asc")
            cand=gather(all,2)
        end
        if #cand==0 then cand=gather(all,1) end
        if #cand==0 then
            if fallbackTeleport then
                notify("Letting Roblox pick a server...")
                pcall(function() TeleportService:Teleport(placeId,LocalPlayer) end)
            else
                notify("No joinable servers came back, try again in a moment",5)
            end
            return
        end
        table.sort(cand,function(a,b) return (a.playing or 0)>(b.playing or 0) end)
        local top=math.min(#cand,15)
        for i=top,2,-1 do local j=math.random(1,i); cand[i],cand[j]=cand[j],cand[i] end
        hopFallbackPlace=placeId
        for i=1,math.min(#cand,4) do
            Mono.hopFailed=false
            local sv=cand[i]
            pcall(function() TeleportService:TeleportToPlaceInstance(placeId,sv.id,LocalPlayer) end)
            local t0=os.clock()
            while os.clock()-t0<7 and not Mono.hopFailed do task.wait(0.2) end
            if not Mono.hopFailed then return end
            notify("That server filled up, trying another...",2)
        end
        hopFallbackPlace=nil
        notify("Every server tried was full, try again in a moment",5)
    end)
end
local function rejoin() notify("Rejoining..."); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end) end
local function serverHop() notify("Finding a server..."); hopServers(game.PlaceId,game.JobId,true) end
if game.GameId~=MM2_UNIVERSE then
    local gui=trackGui(create("ScreenGui",{Name=rnd(),ResetOnSpawn=false,IgnoreGuiInset=true,
        DisplayOrder=1000,Parent=mountTarget}))
    local shade=create("Frame",{Name=rnd(),Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=1,
        BorderSizePixel=0,ZIndex=1,Parent=gui})
    local PAD,CARD_W=24,352
    local BODY_W=CARD_W-PAD*2
    local BODY_TEXT="Mono only works in Murder Mystery 2.\nJoin an MM2 server and run the script again."
    local LINE_H=1.15
    local bodyH=36
    do
        local okS,sz=pcall(function()
            return game:GetService("TextService"):GetTextSize(
                BODY_TEXT,14,Enum.Font.BuilderSans,Vector2.new(BODY_W,1000))
        end)
        if okS and sz then bodyH=math.ceil(sz.Y*LINE_H)+2 end
    end
    local TITLE_Y,TITLE_H,GAP,BTN_H=PAD,22,14,34
    local BODY_Y=TITLE_Y+TITLE_H+GAP
    local CARD_H=BODY_Y+bodyH+22+BTN_H+PAD
    local card=create("Frame",{Name=rnd(),AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromOffset(math.floor(CARD_W*0.94),math.floor(CARD_H*0.94)),
        BackgroundColor3=Color3.fromRGB(30,30,30),BackgroundTransparency=1,
        BorderSizePixel=0,ZIndex=2,Parent=gui},
        {create("UICorner",{CornerRadius=UDim.new(0,12)})})
    local edge=create("UIStroke",{Color=Color3.fromRGB(52,52,52),Thickness=1,Transparency=1,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=card})
    local title=create("TextLabel",{Name=rnd(),BackgroundTransparency=1,
        Position=UDim2.fromOffset(PAD,TITLE_Y),Size=UDim2.fromOffset(BODY_W,TITLE_H),
        Font=Enum.Font.BuilderSansBold,TextSize=18,TextColor3=Color3.fromRGB(255,255,255),
        TextTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,
        Text="Wrong game",ZIndex=3,Parent=card})
    local body=create("TextLabel",{Name=rnd(),BackgroundTransparency=1,
        Position=UDim2.fromOffset(PAD,BODY_Y),Size=UDim2.fromOffset(BODY_W,bodyH),
        Font=Enum.Font.BuilderSans,TextSize=14,TextColor3=Color3.fromRGB(150,150,150),
        LineHeight=LINE_H,
        TextTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
        Text=BODY_TEXT,ZIndex=3,Parent=card})
    local okBtn=create("TextButton",{Name=rnd(),AnchorPoint=Vector2.new(1,1),
        Position=UDim2.new(1,-PAD,1,-PAD),Size=UDim2.fromOffset(96,BTN_H),
        BackgroundColor3=Color3.fromRGB(205,205,205),BackgroundTransparency=1,
        AutoButtonColor=false,Text="",ZIndex=3,Parent=card},
        {create("UICorner",{CornerRadius=UDim.new(0,8)})})
    local okLbl=create("TextLabel",{Name=rnd(),BackgroundTransparency=1,Size=UDim2.fromScale(1,1),
        Font=Enum.Font.BuilderSansMedium,TextSize=14,TextColor3=Color3.fromRGB(26,26,26),
        TextTransparency=1,Text="OK",ZIndex=4,Parent=okBtn})

    local IN=TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    local function fade(to)
        TweenService:Create(shade,to and IN or TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {BackgroundTransparency=to and 0.5 or 1}):Play()
        local ti=to and IN or TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        TweenService:Create(card,ti,{BackgroundTransparency=to and 0 or 1}):Play()
        TweenService:Create(edge,ti,{Transparency=to and 0.25 or 1}):Play()
        TweenService:Create(title,ti,{TextTransparency=to and 0 or 1}):Play()
        TweenService:Create(body,ti,{TextTransparency=to and 0 or 1}):Play()
        TweenService:Create(okBtn,ti,{BackgroundTransparency=to and 0 or 1}):Play()
        TweenService:Create(okLbl,ti,{TextTransparency=to and 0 or 1}):Play()
    end
    fade(true)
    TweenService:Create(card,TweenInfo.new(0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Size=UDim2.fromOffset(CARD_W,CARD_H)}):Play()

    okBtn.MouseEnter:Connect(function()
        TweenService:Create(okBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(235,235,235)}):Play()
    end)
    okBtn.MouseLeave:Connect(function()
        TweenService:Create(okBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(205,205,205)}):Play()
    end)

    local closing=false
    local function dismiss()
        if closing then return end
        closing=true
        Unloaded=true
        fade(false)
        task.delay(0.2,function()
            pcall(function() gui:Destroy() end)
            pcall(function() if GENV then GENV.MONO_Unload=nil end end)
        end)
    end
    okBtn.MouseButton1Click:Connect(dismiss)

    pcall(function() if GENV then GENV.MONO_Unload=function()
        Unloaded=true
        pcall(function() gui:Destroy() end)
        GENV.MONO_Unload=nil
    end end end)
    return
end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece

local EspGui=trackGui(create("ScreenGui",{Name=rnd(),ResetOnSpawn=false,IgnoreGuiInset=false,DisplayOrder=998,Parent=mountTarget}))
do
    local lineMT={}
    local function apply(t)
        local f=rawget(t,"_f")
        if not (f and f.Parent) then return end
        local a,b=rawget(t,"_From"),rawget(t,"_To")
        if not (a and b) then return end
        local d=b-a
        f.Position=UDim2.fromOffset((a.X+b.X)*0.5,(a.Y+b.Y)*0.5)
        f.Size=UDim2.fromOffset(math.max(d.Magnitude,1),math.max(rawget(t,"_Thickness") or 1,1))
        f.Rotation=math.deg(math.atan2(d.Y,d.X))
    end
    local function remove(t)
        local f=rawget(t,"_f")
        if f then pcall(function() f:Destroy() end) end
    end
    lineMT.__index=function(t,k)
        if k=="Remove" then return remove end
        return rawget(t,"_"..k)
    end
    lineMT.__newindex=function(t,k,v)
        rawset(t,"_"..k,v)
        local f=rawget(t,"_f")
        if not (f and f.Parent) then return end
        if k=="Visible" then f.Visible=(v==true)
        elseif k=="Color" then f.BackgroundColor3=v
        elseif k=="Transparency" then f.BackgroundTransparency=1-(tonumber(v) or 1)
        elseif k=="From" or k=="To" or k=="Thickness" then apply(t) end
    end
    Mono.hasDrawing=(typeof(Drawing)=="table") and (pcall(function()
        local probe=Drawing.new("Line"); probe:Remove()
    end))
    if not Mono.hasDrawing then
        Fallback.note("ESP lines","GUI frames",
            "your executor has no Drawing library, so lines are built from rotated frames, which costs more on a weak device",
            {"Box ESP","3D Box ESP","Skeleton ESP","Tracers","Show FOV Circle"})
    end
    Mono.drawn={}
    function Mono.trackDraw(o) Mono.drawn[o]=true; return o end
    function Mono.dropDraw(o)
        if o==nil then return end
        Mono.drawn[o]=nil
        pcall(function() o:Remove() end)
    end
    function Mono.clearDrawn()
        for o in pairs(Mono.drawn) do pcall(function() o:Remove() end) end
        table.clear(Mono.drawn)
    end
    function Mono.newLine(thickness)
        if Mono.hasDrawing then
            local l=Drawing.new("Line"); l.Thickness=thickness; l.Transparency=1; l.Visible=false
            return Mono.trackDraw(l)
        end
        local t=setmetatable({},lineMT)
        rawset(t,"_f",create("Frame",{Name=rnd(),AnchorPoint=Vector2.new(0.5,0.5),BorderSizePixel=0,
            BackgroundColor3=Color3.new(1,1,1),Visible=false,ZIndex=3,Parent=EspGui}))
        rawset(t,"_Thickness",thickness)
        rawset(t,"_Visible",false)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        return t
    end
end

local CRC; pcall(function() CRC=require(RS:WaitForChild("Modules"):WaitForChild("CurrentRoundClient")) end)
local function roundData(plr) return CRC and CRC.PlayerData and CRC.PlayerData[plr.Name] end
local function getHRP(ch) return ch and ch:FindFirstChild("HumanoidRootPart") end
local function badVec(v)
    if typeof(v)~="Vector3" then return true end
    if v.X~=v.X or v.Y~=v.Y or v.Z~=v.Z then return true end
    local inf=math.huge
    if v.X==inf or v.X==-inf then return true end
    if v.Y==inf or v.Y==-inf then return true end
    if v.Z==inf or v.Z==-inf then return true end
    return false
end
local function badCF(cf)
    if typeof(cf)~="CFrame" then return true end
    local p=cf.Position
    if badVec(p) then return true end
    if math.abs(p.X)>1e6 or math.abs(p.Y)>1e6 or math.abs(p.Z)>1e6 then return true end
    return false
end
local function charHasWeapon(ch,kind)
    for _,t in ipairs(ch:GetChildren()) do
        if t:IsA("Tool") then
            if kind=="Gun" and (t.Name=="Gun" or t:FindFirstChild("Shoot")) then return true end
            if kind=="Knife" and (t.Name=="Knife" or t:FindFirstChild("Events")) then return true end
        end
    end
    return false
end
local CollectionService=game:GetService("CollectionService")
function Mono.refreshTags()
    for _,tag in ipairs({"Weapon_Gun","Weapon_Knife"}) do
        local m=Mono.tagOwners[tag]
        if m then table.clear(m) else m={}; Mono.tagOwners[tag]=m end
        for _,t in ipairs(CollectionService:GetTagged(tag)) do
            local par=t.Parent
            if par then m[par]=true end
        end
    end
end
Mono.refreshTags()
local function playerHasTagged(plr,tag)
    local m=Mono.tagOwners[tag]; if not m then return false end
    local ch=plr.Character
    if ch and m[ch] then return true end
    local bp=plr:FindFirstChildOfClass("Backpack")
    if bp and m[bp] then return true end
    return false
end
local function computeRole(plr)
    local d=roundData(plr)
    local r=d and d.Role
    if r=="Murderer" then return "Murderer" end
    if r=="Sheriff" or r=="Hero" then return r end
    local ch=plr.Character
    if playerHasTagged(plr,"Weapon_Gun") or (ch and charHasWeapon(ch,"Gun")) then return "Hero" end
    if playerHasTagged(plr,"Weapon_Knife") or (ch and charHasWeapon(ch,"Knife")) then return "Murderer" end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    return r or "Innocent"
end
local function computeAlive(plr)
    local d=roundData(plr); if d and d.Dead==true then return false end
    local ch=plr.Character; local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    return ch and hum and hum.Health>0 and getHRP(ch)
end
local CACHE_TTL=0.05
local roleCache,aliveCache,cacheStamp={},{},0
local function sweepCaches()
    local now=os.clock()
    if now-cacheStamp>CACHE_TTL then
        table.clear(roleCache); table.clear(aliveCache); cacheStamp=now
        Mono.refreshTags()
    end
    if now-(Mono.rosterAt or 0)>2 then
        Mono.rosterAt=now
        Mono.refreshPlrs()
    end
end
local function roleOf(plr)
    sweepCaches()
    local v=roleCache[plr]
    if v==nil then v=computeRole(plr); roleCache[plr]=v end
    return v
end
local function alive(plr)
    sweepCaches()
    local v=aliveCache[plr]
    if v==nil then v=computeAlive(plr) or false; aliveCache[plr]=v end
    return v
end
function Mono.hasBody(plr)
    local ch=plr.Character
    if not ch then return nil end
    local hum=ch:FindFirstChildOfClass("Humanoid")
    if not (hum and hum.Health>0) then return nil end
    local hrp=ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return ch,hum,hrp
end
local function myRole() return roleOf(LocalPlayer) end
local function isGunRole(role) return role=="Sheriff" or role=="Hero" end
local function isEnemyOf(myrole,role)
    if myrole=="Murderer" then return true end
    if isGunRole(myrole) then return role=="Murderer" end
    return false
end
function Mono.refreshPlrs()
    local ok,list=pcall(function() return Players:GetPlayers() end)
    if ok and type(list)=="table" then Mono.plrs=list end
end
Mono.refreshPlrs()
bind(Players.PlayerAdded,Mono.refreshPlrs)
bind(Players.PlayerRemoving,function()
    task.defer(Mono.refreshPlrs)
end)
local function findMurderer() for _,p in ipairs(Mono.plrs) do if roleOf(p)=="Murderer" then return p end end end
local function findWeapon(n) local ch=LocalPlayer.Character; local bp=LocalPlayer:FindFirstChildOfClass("Backpack"); return (ch and ch:FindFirstChild(n)) or (bp and bp:FindFirstChild(n)) end
local function equip(tool) local ch=LocalPlayer.Character; local hum=ch and ch:FindFirstChildOfClass("Humanoid"); if tool and hum and tool.Parent~=ch then pcall(function() hum:EquipTool(tool) end) end end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece

function Mono.aimPointFor(p)
    local ch=p and p.Character; local hrp=ch and getHRP(ch); if not hrp then return end
    local part=ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or hrp
    return part.Position
end
Mono.WALL_BACKOFF=0.6

local KNIFE_PARTS={"HumanoidRootPart","UpperTorso","LowerTorso","Torso","Head"}
local function knifeKill(ev,targetChar)
    if not (ev and targetChar) then return end
    local ht=ev:FindFirstChild("HandleTouched"); local ks=ev:FindFirstChild("KnifeStabbed")
    if not ht then return end
    if ks then ks:FireServer() end
    for _,pn in ipairs(KNIFE_PARTS) do
        local part=targetChar:FindFirstChild(pn)
        if part then ht:FireServer(part) return end
    end
end
Mono.SNAP_HEIGHT=5
Mono.GUN_COOLDOWN=3.25
Mono.SNAP_COOLDOWN=3.25
Mono.snapAt=-10
local snapping=false
function Mono.gunOrigin()
    local ch=LocalPlayer.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local att=hrp:FindFirstChild("GunRaycastAttachment")
    if att then return att.WorldCFrame end
    return hrp.CFrame
end

function Mono.aimPoint(ch)
    local part=ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso")
        or ch:FindFirstChild("Torso") or ch:FindFirstChild("Head")
    return part and part.Position
end

function Mono.gunBusy(lead)
    local gun=findWeapon("Gun")
    if not gun then return false end
    if os.clock()-Mono.snapAt<Mono.GUN_COOLDOWN-(lead or 0) then return true end
    return false
end
do
    local cs=RS:FindFirstChild("ClientServices")
    local ws=cs and cs:FindFirstChild("WeaponService")
    local gf=ws and ws:FindFirstChild("GunFired")
    if gf and gf:IsA("RemoteEvent") then
        bind(gf.OnClientEvent,function(handle)
            local ch=LocalPlayer.Character
            if ch and typeof(handle)=="Instance" and handle:IsDescendantOf(ch) then
                local rt=os.clock()-Mono.snapAt
                if rt>0 and rt<1.5 then Mono.shotLag=(Mono.shotLag or 0.08)*0.7+rt*0.3 end
                Mono.snapAt=os.clock()
            end
        end)
    end
end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece

local function snapShot(target)
    if snapping then return false end
    local lagT=math.clamp(Mono.shotLag or 0.08,0.03,0.25)
    local preLock=math.clamp(lagT*1.5,0.12,0.35)
    if Mono.gunBusy(preLock) then return false end
    local gun=findWeapon("Gun"); if not gun then return false end
    local shoot=gun:FindFirstChild("Shoot"); if not shoot then return false end
    local myHrp=getHRP(LocalPlayer.Character)
    local tChar=target and target.Character
    local tHrp=tChar and getHRP(tChar)
    if not (myHrp and tHrp and Mono.canAct()) then return false end
    snapping=true

    local home=myHrp.CFrame
    local homeVel=myHrp.AssemblyLinearVelocity
    local myHum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local homeState=myHum and myHum:GetState() or nil
    local fired=false

    pcall(function()
        equip(gun)
        local deadline=os.clock()+0.4
        while os.clock()<deadline do
            local h=getHRP(LocalPlayer.Character)
            if h and h:FindFirstChild("GunRaycastAttachment") then break end
            RunService.Heartbeat:Wait()
        end

        Mono.markSelfTP()
        local aim=Mono.aimPoint(tChar)
        if not aim then return end
        local side=home.Position-aim
        side=Vector3.new(side.X,0,side.Z)
        if side.Magnitude<0.5 then
            local lv=tHrp.CFrame.LookVector
            side=Vector3.new(lv.X,0,lv.Z)
        end
        if side.Magnitude<0.5 then side=Vector3.new(0,0,1) end
        side=side.Unit
        local rp=RaycastParams.new()
        rp.FilterType=Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances={tChar,LocalPlayer.Character}
        if workspace:Raycast(aim,side*Mono.SNAP_HEIGHT,rp) then side=-side end
        local relOff=side*Mono.SNAP_HEIGHT

        local chest=aim
        local function lockOn(dur)
            local t0=os.clock()
            repeat
                local h=getHRP(LocalPlayer.Character)
                local tr=target.Character and getHRP(target.Character)
                if not (h and tr) then return false end
                if Mono.teleporting() then return false end
                local nxt=Mono.aimPoint(target.Character)
                if nxt and (nxt-chest).Magnitude>60 then return false end
                chest=nxt or chest
                h.CFrame=CFrame.new(chest+relOff,chest)
                h.AssemblyLinearVelocity=Vector3.zero
                h.AssemblyAngularVelocity=Vector3.zero
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                Mono.markSelfTP()
                RunService.Heartbeat:Wait()
            until os.clock()-t0>=dur
            return true
        end

        if not lockOn(preLock) then return end

        local origin=Mono.gunOrigin()
        if origin then
            local tr2=target.Character and getHRP(target.Character)
            local vel=tr2 and tr2.AssemblyLinearVelocity or Vector3.zero
            shoot:FireServer(origin,CFrame.new(chest+vel*lagT))
            Mono.snapAt=os.clock()
            fired=true
            lockOn(math.clamp(lagT*2,0.16,0.5))
        end
    end)

    RunService.Heartbeat:Wait()
    Mono.markSelfTP()
    local h3=getHRP(LocalPlayer.Character)
    if h3 then
        h3.CFrame=home
        h3.AssemblyLinearVelocity=homeVel
        h3.AssemblyAngularVelocity=Vector3.zero
    end
    local hum3=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum3 then
        if homeState and homeState~=Enum.HumanoidStateType.Dead then
            pcall(function() hum3:ChangeState(homeState) end)
        else
            pcall(function() hum3:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
        pcall(function() hum3:Move(hum3.MoveDirection,false) end)
    end
    snapping=false
    return fired
end
local function enemies()
    local role=myRole(); local list={}
    if isGunRole(role) then local m=findMurderer(); if m and alive(m) then table.insert(list,m) end
    else for _,p in ipairs(Mono.plrs) do if p~=LocalPlayer and alive(p) then table.insert(list,p) end end end
    return list,role
end
local function fovTarget()
    local mr=myRole()
    local center=Mono.aimViewport(); local best,bd
    for _,p in ipairs(Mono.plrs) do
        if p~=LocalPlayer and alive(p) then
            local pr=roleOf(p)
            if isEnemyOf(mr,pr) or pr=="Murderer" then
                local hrp=getHRP(p.Character)
                if hrp then
                    local v,on=Camera:WorldToViewportPoint(hrp.Position)
                    if on and v.Z>0 then
                        local d=(Vector2.new(v.X,v.Y)-center).Magnitude
                        if d<=aimFov and (not bd or d<bd) then bd,best=d,p end
                    end
                end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            end
        end
    end
    return best
end

task.spawn(function() while not isDead() do
  local okLoop,errLoop=pcall(function()
    if flags.autoKill then
        local list,role=enemies()
        if role=="Murderer" then
            local knife=findWeapon("Knife"); local ev=knife and knife:FindFirstChild("Events")
            if ev then equip(knife)
                for _,tgt in ipairs(list) do
                    if not flags.autoKill then break end
                    knifeKill(ev,tgt.Character)
                end
            end
            task.wait(0.05)
        elseif isGunRole(role) then
            local m=list[1]
            if m and alive(m) then snapShot(m) end
            task.wait(0.05)
        else task.wait(0.1) end
    else task.wait(0.08) end
  end)
  if not okLoop then warn("[MONO] auto kill: "..tostring(errLoop)); task.wait(0.25) end
end end)
local FovCircle=create("Frame",{Name=rnd(),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(240,240),BackgroundTransparency=1,BorderSizePixel=0,Visible=false,Parent=EspGui},
    {create("UICorner",{CornerRadius=UDim.new(1,0)}),create("UIStroke",{Color=Color3.fromRGB(255,255,255),Thickness=1.5,Transparency=0.25})})
bind(RunService.RenderStepped,function()
    if flags.showFov and (flags.aimbot or flags.silentAim) then
        FovCircle.Visible=true; FovCircle.Size=UDim2.fromOffset(aimFov*2,aimFov*2); local mp=Mono.mouseGui(); FovCircle.Position=UDim2.fromOffset(mp.X,mp.Y)
    else FovCircle.Visible=false end
    if flags.aimbot or Mono.mobAim then
        local t=fovTarget()
        if t then local th=t.Character:FindFirstChild("Head") or getHRP(t.Character)
            if th then Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,th.Position),0.45) end end
    end
end)
local silentAimPos
local function crosshairAnyPlayerPos(radius)
    local center=Mono.aimViewport()
    local best,bd
    for _,p in ipairs(Mono.plrs) do
        if p~=LocalPlayer and alive(p) then
            local ch=p.Character; local hrp=getHRP(ch)
            if hrp then
                local sp=Camera:WorldToViewportPoint(hrp.Position)
                if sp.Z>0 then
                    local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                    if d<=radius and (not bd or d<bd) then
                        bd=d
                        best=p
                    end
                end
            end
        end
    end
    return best and Mono.aimPointFor(best) or nil
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
end
Mono.SILENT_HOLD=1.8
function Mono.crosshairPlayer(radius)
    local center=Mono.aimViewport()
    local best,bd
    for _,p in ipairs(Mono.plrs) do
        if p~=LocalPlayer and alive(p) then
            local hrp=getHRP(p.Character)
            if hrp then
                local sp=Camera:WorldToViewportPoint(hrp.Position)
                if sp.Z>0 then
                    local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                    if d<=radius and (not bd or d<bd) then bd=d; best=p end
                end
            end
        end
    end
    return best
end
local function computeSilentTarget()
    if myRole()~="Murderer" then Mono.silentPlr=nil return nil end
    local p=Mono.crosshairPlayer(aimFov)
    if p then
        Mono.silentPlr=p
        Mono.silentAt=os.clock()
        return Mono.aimPointFor(p)
    end
    local last=Mono.silentPlr
    if last and os.clock()-(Mono.silentAt or -10)<Mono.SILENT_HOLD and alive(last) then
        local held=Mono.aimPointFor(last)
        if held then return held end
    end
    Mono.silentPlr=nil
    return nil
end
local function aimRay()
    local c=Mono.aimCenter()
    return Camera:ViewportPointToRay(c.X,c.Y)
end
local function wallAimPos()
    local ray=aimRay()
    local origin,dir=ray.Origin,ray.Direction.Unit
    local far=origin+dir*300
    local chars={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and alive(p) and p.Character then chars[#chars+1]=p.Character end
    end
    if #chars==0 then return nil,far end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances=chars
    local hit=workspace:Raycast(origin,dir*300,params)
    if hit then return hit.Position,far end
    return crosshairAnyPlayerPos(aimFov),far
end
local wallSnapPos, wallFarPos, myHrpPos
bind(RunService.Heartbeat,function()
    silentAimPos = flags.silentAim and computeSilentTarget() or nil
    if flags.knifeWalls or flags.gunWalls then
        wallSnapPos, wallFarPos = wallAimPos()
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    else
        wallSnapPos, wallFarPos = nil, nil
    end
    local h=getHRP(LocalPlayer.Character); myHrpPos = h and h.Position or nil
end)
Mono.hookOk=pcall(function()
    if typeof(hookmetamethod)~="function" or typeof(newcclosure)~="function"
        or typeof(checkcaller)~="function" or typeof(getnamecallmethod)~="function" then
        error("executor has no __namecall hooking")
    end
    local oldNamecall
    oldNamecall=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        if not Unloaded and not checkcaller() and getnamecallmethod()=="FireServer" then
            local nm=self.Name
            if nm=="Shoot" or nm=="KnifeThrown" then
                if nm=="Shoot" and flags.silentAim and not snapping and not Mono.gunBusy()
                    and os.clock()-Mono.snapAt>=Mono.SNAP_COOLDOWN and isGunRole(myRole()) then
                    local ft=fovTarget()
                    if ft then
                        task.spawn(function() snapShot(ft) end)
                        return
                    end
                end
                local walls=(nm=="Shoot" and flags.gunWalls) or (nm=="KnifeThrown" and flags.knifeWalls)
                if nm=="KnifeThrown" and flags.instantKnife and os.clock()-instantFiredAt<0.6 then
                    return
                end
                local silent=flags.silentAim and silentAimPos
                local wallTarget
                if walls then
                    if nm=="Shoot" then wallTarget=wallSnapPos
                    else wallTarget=wallSnapPos or wallFarPos end
                end
                local retarget=(silent and silentAimPos) or wallTarget or nil
                if retarget then
                    local n=select("#",...)
                    if n>=2 then
                        local a={...}
                        if typeof(a[2])=="CFrame" then
                            if retarget then a[2]=CFrame.new(retarget) end
                            if walls and retarget and myHrpPos and typeof(a[1])=="CFrame" then
                                local tp=a[2].Position
                                local d=tp-myHrpPos
                                d=(d.Magnitude>0.1) and d.Unit or Vector3.new(0,0,-1)
                                a[1]=CFrame.new(tp-d*Mono.WALL_BACKOFF,tp)
                            end
                            return oldNamecall(self,table.unpack(a,1,n))
                        end
                    end
                end
            end
        end
        return oldNamecall(self,...)
    end))
end)

local WeaponService
pcall(function() WeaponService=require(RS:WaitForChild("ClientServices"):WaitForChild("WeaponService")) end)
local function gameAimCFrame()
    if WeaponService then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        local ok,cf=pcall(function() return WeaponService:GetMouseTargetCFrame() end)
        if ok and typeof(cf)=="CFrame" then return cf end
    end
    local ray=aimRay()
    return CFrame.new(ray.Origin+ray.Direction.Unit*300)
end
if not Mono.hookOk then
    Fallback.note("Weapon retargeting","direct fire",
        "your executor cannot hook __namecall, so Mono fires the weapon remote itself instead of quietly redirecting the shot the game already sends",
        {"Silent Aim","Gun Through Walls","Knife Through Walls","Instant Knife Throw"})
    bind(UserInputService.InputBegan,function(input,processed)
        if processed or isDead() then return end
        local it=input.UserInputType
        if it~=Enum.UserInputType.MouseButton1 and it~=Enum.UserInputType.Touch then return end
        if not (flags.gunWalls or flags.knifeWalls or flags.silentAim) then return end
        task.spawn(function()
            local ch=LocalPlayer.Character
            if not (ch and Mono.canAct()) then return end
            local mine=getHRP(ch); if not mine then return end
            local gun=ch:FindFirstChild("Gun")
            if gun and gun:FindFirstChild("Shoot") then
                if Mono.gunBusy() then return end
                if flags.silentAim and isGunRole(myRole()) then
                    local ft=fovTarget()
                    if ft then snapShot(ft) return end
                end
                if flags.gunWalls then
                    local snap=wallAimPos()
                    if snap then
                        local d=snap-mine.Position
                        d=(d.Magnitude>0.1) and d.Unit or Vector3.new(0,0,-1)
                        pcall(function() gun.Shoot:FireServer(CFrame.new(snap-d*2,snap),CFrame.new(snap)) end)
                    end
                end
                return
            end
            local knife=ch:FindFirstChild("Knife")
            local ev=knife and knife:FindFirstChild("Events")
            local thrown=ev and ev:FindFirstChild("KnifeThrown")
            if thrown and (flags.knifeWalls or flags.silentAim) then
                local snap=(flags.silentAim and crosshairAnyPlayerPos(aimFov)) or wallAimPos()
                if snap then
                    local d=snap-mine.Position
                    d=(d.Magnitude>0.1) and d.Unit or Vector3.new(0,0,-1)
                    local h2=knife:FindFirstChild("Handle")
                    local o2
                    if flags.knifeWalls or not h2 then
                        o2=CFrame.new(snap-d*Mono.WALL_BACKOFF,snap)
                    else
                        o2=h2.CFrame
                    end
                    pcall(function() thrown:FireServer(o2,CFrame.new(snap)) end)
                end
            end
        end)
    end)
end

local function throwKnifeNow(ignoreCooldown)
    local ch=LocalPlayer.Character
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    if not ch then return false end
    local knife=ch:FindFirstChild("Knife")
    if not knife then
        local bp=LocalPlayer:FindFirstChild("Backpack")
        local stowed=bp and bp:FindFirstChild("Knife")
        if stowed then
            local hum=ch:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(stowed) end) end
            knife=ch:FindFirstChild("Knife") or stowed
        end
    end
    if not knife then return false end
    local ev=knife:FindFirstChild("Events")
    local thrown=ev and ev:FindFirstChild("KnifeThrown")
    if not thrown then return false end
    if knife:GetAttribute("Disabled")==true then return false end
    if not ignoreCooldown then
        local cd=2*(tonumber(knife:GetAttribute("ThrowSpeed")) or 1)
        if os.clock()-instantFiredAt<cd then return false end
    end
    local target=silentAimPos
    if not target then
        if flags.knifeWalls then
            local snap,far=wallAimPos()
            target=snap or far
        else
            target=gameAimCFrame().Position
        end
    end
    if not target then return false end
    local hrp=getHRP(ch); if not hrp then return false end
    local d=target-hrp.Position
    d=(d.Magnitude>0.1) and d.Unit or Vector3.new(0,0,-1)
    instantFiredAt=os.clock()
    local handle=knife:FindFirstChild("Handle")
    local origin
    if flags.knifeWalls or not handle then
        origin=CFrame.new(target-d*Mono.WALL_BACKOFF,target)
    else
        origin=handle.CFrame
    end
    thrown:FireServer(origin,CFrame.new(target))
    return true
end
bind(UserInputService.InputBegan,function(input,gpe)
    if gpe then return end
    if input.UserInputType~=Enum.UserInputType.MouseButton2 then return end
    if flags.instantKnife then throwKnifeNow(false) end
end)
task.spawn(function()
    local ok,act=pcall(function()
        local ic=LocalPlayer:WaitForChild("PlayerGui",10):WaitForChild("InputContext",10)
        return ic:WaitForChild("GameplayContext",10):WaitForChild("Throw",10)
    end)
    if ok and act then
        pcall(function()
            bind(act.Pressed,function()
                if flags.instantKnife then throwKnifeNow(false) end
            end)
        end)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end
end)

local controlModule
local function getControls()
    if not controlModule then
        pcall(function()
            controlModule=require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
        end)
    end
    return controlModule
end
local lastJumpAt=-10
local flyBV,flyBG
local function startFly() local ch=LocalPlayer.Character; local hrp=getHRP(ch); local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end; hum.PlatformStand=true; Mono.wantPS=true
    flyBV=create("BodyVelocity",{MaxForce=Vector3.new(1,1,1)*9e9,P=9e4,Velocity=Vector3.zero,Parent=hrp})
    flyBG=create("BodyGyro",{MaxTorque=Vector3.new(1,1,1)*9e9,P=9e4,CFrame=hrp.CFrame,Parent=hrp}) end
local function stopFly() local ch=LocalPlayer.Character; local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false end; Mono.wantPS=false; if flyBV then flyBV:Destroy();flyBV=nil end; if flyBG then flyBG:Destroy();flyBG=nil end end
bind(RunService.RenderStepped,function()
    if not flags.fly or not flyBV then return end
    local hrp=getHRP(LocalPlayer.Character); if not hrp then return end
    local dir=Vector3.zero; local look,right=Camera.CFrame.LookVector,Camera.CFrame.RightVector
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=look end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=look end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=right end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=right end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or Mono.mobUp then dir+=Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or Mono.mobDown then dir-=Vector3.new(0,1,0) end
    if dir.Magnitude==0 then
        local c=getControls()
        local mv=c and c:GetMoveVector()
        if mv and mv.Magnitude>0 then dir=dir+(look*(-mv.Z))+(right*mv.X) end
    end
    if os.clock()-lastJumpAt<0.25 then dir+=Vector3.new(0,1,0) end
    flyBV.Velocity=(dir.Magnitude>0 and dir.Unit or Vector3.zero)*flags.flySpeed; flyBG.CFrame=Camera.CFrame
end)
do
    local TOUCH_ONLY=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local pad,btns=nil,{}
    local function build()
        local gui=trackGui(create("ScreenGui",{Name=rnd(),ResetOnSpawn=false,IgnoreGuiInset=false,
            DisplayOrder=999,Parent=mountTarget}))
        pad=create("Frame",{Name=rnd(),AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-20,1,-150),
            Size=UDim2.fromOffset(70,252),BackgroundTransparency=1,Visible=false,Parent=gui})
        local grip=create("Frame",{Name=rnd(),Size=UDim2.fromOffset(70,18),BackgroundColor3=Color3.fromRGB(19,19,21),
            BackgroundTransparency=0.25,BorderSizePixel=0,Parent=pad},
            {create("UICorner",{CornerRadius=UDim.new(1,0)}),
             create("Frame",{Name=rnd(),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),
                Size=UDim2.fromOffset(26,2),BackgroundColor3=Color3.fromRGB(150,150,155),
                BackgroundTransparency=0.3,BorderSizePixel=0},{create("UICorner",{CornerRadius=UDim.new(1,0)})})})
        local function pill(y,glyph,set)
            local b=create("TextButton",{Name=rnd(),Position=UDim2.fromOffset(0,y),Size=UDim2.fromOffset(70,70),
                BackgroundColor3=Color3.fromRGB(19,19,21),BackgroundTransparency=0.15,AutoButtonColor=false,
                Text=glyph,TextColor3=Color3.fromRGB(238,238,240),TextSize=27,Font=Enum.Font.GothamMedium,
                Visible=false,Parent=pad},
                {create("UICorner",{CornerRadius=UDim.new(1,0)}),
                 create("UIStroke",{Color=Color3.fromRGB(72,72,76),Thickness=1,Transparency=0.35})})
            b.InputBegan:Connect(function(i)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                if i.UserInputType==Enum.UserInputType.Touch then set(true); b.BackgroundTransparency=0 end
            end)
            b.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.Touch then set(false); b.BackgroundTransparency=0.15 end
            end)
            return b
        end
        btns.up=pill(26,"▲",function(v) Mono.mobUp=v end)
        btns.down=pill(117,"▼",function(v) Mono.mobDown=v end)
        btns.aim=pill(208,"◎",function(v) Mono.mobAim=v end)

        local drag,startPos,startIn=false,nil,nil
        grip.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then
                drag=true; startPos=pad.Position; startIn=i.Position
            end
        end)
        grip.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then drag=false end
        end)
        bind(UserInputService.InputChanged,function(i)
            if drag and i.UserInputType==Enum.UserInputType.Touch and startPos then
                local d=i.Position-startIn
                pad.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
                    startPos.Y.Scale,startPos.Y.Offset+d.Y)
            end
        end)
    end

    local last=0
    bind(RunService.Heartbeat,function()
        if not TOUCH_ONLY then return end
        local now=os.clock()
        if now-last<0.25 then return end
        last=now
        local wantFly=flags.fly and true or false
        local wantAim=flags.aimbot and true or false
        if not (wantFly or wantAim) then
            if pad then pad.Visible=false end
            Mono.mobUp,Mono.mobDown,Mono.mobAim=false,false,false
            return
        end
        if not pad then build() end
        btns.up.Visible=wantFly
        btns.down.Visible=wantFly
        btns.aim.Visible=wantAim
        btns.aim.Position=UDim2.fromOffset(0,wantFly and 208 or 26)
        pad.Size=UDim2.fromOffset(70,26+(wantFly and 182 or 0)+(wantAim and 70 or 0))
        pad.Visible=true
    end)
end

local charParts,charPartsFor={},nil
local function refreshCharParts(ch)
    charParts={}
    if Mono.cpConn then Mono.cpConn:Disconnect(); Mono.cpConn=nil end
    if not ch then charPartsFor=nil return end
    for _,p in ipairs(ch:GetDescendants()) do
        if p:IsA("BasePart") then charParts[#charParts+1]=p end
    end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    charPartsFor=ch
    Mono.cpConn=ch.DescendantAdded:Connect(function(d)
        if ch==charPartsFor and d:IsA("BasePart") then charParts[#charParts+1]=d end
    end)
    table.insert(conns,Mono.cpConn)
end
local function getCharParts(ch)
    if ch~=charPartsFor then refreshCharParts(ch) end
    return charParts
end
bind(LocalPlayer.CharacterAdded,function(ch)
    task.defer(function() refreshCharParts(ch) end)
end)
if LocalPlayer.Character then refreshCharParts(LocalPlayer.Character) end
local function uncollide(ch)
    for _,p in ipairs(getCharParts(ch)) do
        if p.Parent and p.CanCollide then p.CanCollide=false; Mono.unclip[p]=true end
    end
end
function Mono.recollide(hum,force)
    if (not force) and (flags.noclip or flinging or Mono.wantNoclip) then return end
    for p in pairs(Mono.unclip) do
        if p.Parent then p.CanCollide=true end
    end
    table.clear(Mono.unclip)
    if hum then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
end

bind(RunService.Stepped,function()
    if flinging and os.clock()-(Mono.flingAt or 0)>(flags.flingSeconds or 3)+8 then flinging=false end
    if not (flags.noclip or flinging or Mono.wantNoclip) then
        if next(Mono.unclip) then
            Mono.recollide(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
        end
        return
    end
    local ch=LocalPlayer.Character; if not ch then return end
    uncollide(ch)
end)
bind(UserInputService.JumpRequest,function() lastJumpAt=os.clock() if flags.infJump then local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

local origMaxZoom=LocalPlayer.CameraMaxZoomDistance
local function setUnlockCam(on) pcall(function() LocalPlayer.CameraMaxZoomDistance=on and 10000 or origMaxZoom end) end
local camCams,origOccUpdate
local function getCams()
    if camCams then return camCams end
    if os.clock()-(Mono.camTryAt or -10)<2 then return nil end
    Mono.camTryAt=os.clock()
    pcall(function() camCams=require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetCameras() end)
    return camCams
end
local function setCamThruWalls(on)
    if Mono.camThru==on then return end
    Mono.camThru=on
    local cams=getCams(); if not cams then Mono.camThru=nil return end
    local occ=cams.activeOcclusionModule; if not (occ and occ.Update) then return end
    if on and not occ.__monoHook then
        origOccUpdate=occ.Update; occ.__monoHook=true
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        occ.Update=function(_,_,desiredCF,desiredFocus) return desiredCF,desiredFocus end
    elseif (not on) and occ.__monoHook then
        occ.Update=origOccUpdate; occ.__monoHook=false
    end
end
bind(RunService.Heartbeat,function()
    if flags.unlockCam and LocalPlayer.CameraMaxZoomDistance<9999 then setUnlockCam(true) end
    setCamThruWalls(flags.unlockCam and flags.noclip)
end)

local espStore={}
Mono.TextService=game:GetService("TextService")
Mono.nameHidden=setmetatable({},{__mode="k"})
function Mono.setRobloxNames(hide)
    for _,p in ipairs(Mono.plrs) do
        if p~=LocalPlayer then
            local hum=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hide then
                    if Mono.nameHidden[hum]==nil then
                        Mono.nameHidden[hum]={hum.DisplayDistanceType,hum.HealthDisplayDistance,hum.NameDisplayDistance}
                    end
                    if hum.DisplayDistanceType~=Enum.HumanoidDisplayDistanceType.None then
                        hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
                    end
                else
                    local o=Mono.nameHidden[hum]
                    if o then
                        pcall(function()
                            hum.DisplayDistanceType=o[1]
                            hum.HealthDisplayDistance=o[2]
                            hum.NameDisplayDistance=o[3]
                        end)
                        Mono.nameHidden[hum]=nil
                    end
                end
            end
        end
    end
end

local function clearEsp(plr) local e=espStore[plr]; if not e then return end
    if e.hl then e.hl:Destroy() end; if e.bb then e.bb:Destroy() end; espStore[plr]=nil end
function Mono.espRole(plr)
    local d=roundData(plr)
    if d and d.Dead==true then return "Innocent" end
    return roleOf(plr)
end
local function espColor(role) if not flags.espRoleTags then return Color3.fromRGB(214,214,220) end
    if role=="Murderer" then return Color3.fromRGB(255,80,80) elseif isGunRole(role) then return Color3.fromRGB(90,150,255) else return Color3.fromRGB(95,225,125) end end
local function tagOf(role) return role=="Murderer" and "[M]" or isGunRole(role) and "[S]" or "[I]" end
local guiRects={}
function Mono.addRect(o)
    if not (o and o.Visible and o.AbsoluteSize.X>1 and o.AbsoluteSize.Y>1) then return end
    if o:IsA("Frame") and o.BackgroundTransparency>=1 then
        for _,c in ipairs(o:GetChildren()) do
            if c:IsA("GuiObject") then Mono.addRect(c) end
        end
        return
    end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    local p,s=o.AbsolutePosition,o.AbsoluteSize
    local oy=p.Y+Mono.guiIns
    Mono.guiN=Mono.guiN+1
    local r=guiRects[Mono.guiN]
    if r then r[1],r[2],r[3],r[4]=p.X,oy,p.X+s.X,oy+s.Y
    else guiRects[Mono.guiN]={p.X,oy,p.X+s.X,oy+s.Y} end
end
local function refreshGuiRects(force)
    local now=os.clock()
    if not force and now-Mono.guiT<0.1 then return end
    Mono.guiT=now
    Mono.guiIns=GuiService:GetGuiInset().Y
    Mono.guiN=0
    local sg=Window and Window.gui
    if sg then
        for _,c in ipairs(sg:GetChildren()) do
            if c:IsA("GuiObject") then Mono.addRect(c) end
        end
    end
end
local function pointBlocked(x,y)
    for i=1,Mono.guiN do
        local r=guiRects[i]
        if x>=r[1] and x<=r[3] and y>=r[2] and y<=r[4] then return true end
    end
    return false
end
local function rectBlocked(x1,y1,x2,y2)
    for i=1,Mono.guiN do
        local r=guiRects[i]
        if x1<=r[3] and x2>=r[1] and y1<=r[4] and y2>=r[2] then return true end
    end
    return false
end
local function ensureEsp(plr) if espStore[plr] then return espStore[plr] end
    local e={}
    e.hl=create("Highlight",{Name=rnd(),FillTransparency=1,OutlineTransparency=0,Enabled=false,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Parent=EspGui})
    e.bb=create("BillboardGui",{Name=rnd(),Size=UDim2.fromOffset(198,40),AlwaysOnTop=true,Enabled=false,
        StudsOffsetWorldSpace=Vector3.new(0,3.2,0),Parent=EspGui})

    e.scale=create("UIScale",{Scale=1,Parent=e.bb})
    e.card=create("Frame",{Name=rnd(),AnchorPoint=Vector2.new(0.5,1),Position=UDim2.fromScale(0.5,1),
        Size=UDim2.fromOffset(198,32),BackgroundColor3=Color3.fromRGB(16,16,18),BackgroundTransparency=0.2,
        BorderSizePixel=0,Parent=e.bb},
        {create("UICorner",{CornerRadius=UDim.new(0,10)}),
         create("UIGradient",{Rotation=90,
             Transparency=NumberSequence.new({
                 NumberSequenceKeypoint.new(0,0.04),
                 NumberSequenceKeypoint.new(1,0.28)})})})
    e.edge=create("UIStroke",{Color=Color3.fromRGB(255,255,255),Thickness=1,Transparency=0.75,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=e.card})

    e.avatar=create("ImageLabel",{Name=rnd(),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0),
        Size=UDim2.fromOffset(22,22),BackgroundColor3=Color3.fromRGB(38,38,44),BackgroundTransparency=0.25,
        ScaleType=Enum.ScaleType.Fit,Image="",Parent=e.card},
        {create("UICorner",{CornerRadius=UDim.new(0,6)})})

    e.name=create("TextLabel",{Name=rnd(),BackgroundTransparency=1,AnchorPoint=Vector2.new(0,0.5),
        Position=UDim2.new(0,36,0.5,0),Size=UDim2.new(1,-116,0,15),Font=Enum.Font.GothamBold,TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Text="",TextColor3=Color3.fromRGB(255,255,255),Parent=e.card})

    e.sub=create("TextLabel",{Name=rnd(),BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(74,14),Font=Enum.Font.Gotham,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Right,Text="",TextColor3=Color3.fromRGB(176,176,188),Parent=e.card})

    espStore[plr]=e; return e end
task.spawn(function() while not isDead() do
    local anyEsp=flags.espChams or flags.espNames or flags.espRoleTags
    if not anyEsp then
        if next(espStore) then for p in pairs(espStore) do clearEsp(p) end end
        task.wait(0.5)
        continue
    end
    if Mono._rnFlag~=flags.espNames or os.clock()-(Mono._rnAt or 0)>0.5 then
        Mono._rnFlag=flags.espNames
        Mono._rnAt=os.clock()
        Mono.setRobloxNames(flags.espNames)
    end
    local camP=Camera.CFrame.Position
    for _,plr in ipairs(Mono.plrs) do if plr~=LocalPlayer then
        local ch,_,tHRP=Mono.hasBody(plr)
        if anyEsp and ch then
            local e=ensureEsp(plr); local role=Mono.espRole(plr); local col=espColor(role)
            local wantCh=flags.espChams and true or false
            if e._ch~=wantCh then e._ch=wantCh; e.hl.Enabled=wantCh end
            if wantCh then
                if e.hl.Adornee~=ch then e.hl.Adornee=ch end
                local ft=flags.espFill and 0.6 or 1
                if e._hlCol~=col then e._hlCol=col; e.hl.OutlineColor=col; e.hl.FillColor=col end
                if e._hlFill~=ft then e._hlFill=ft; e.hl.FillTransparency=ft end
            end
            local dist=math.floor((tHRP.Position-camP).Magnitude)
            local inRange=(flags.espMaxDist<=0 or dist<=flags.espMaxDist)
            e.dist=dist
            e.inRange=inRange
            e.col=col
            if flags.espNames and inRange then
                e.bb.Enabled=true; e.bb.Adornee=ch:FindFirstChild("Head") or tHRP
                local nm=plr.Name
                if flags.espRoleTags then nm=tagOf(role).."  "..nm end
                if e._nm~=nm then
                    e._nm=nm
                    e.name.Text=nm
                    e._nw=nil
                end
                local rd=roundData(plr); local coins=rd and rd.Coins
                local sub=dist.."m"
                if coins then sub=coins.."c  ·  "..sub end
                if e._sub~=sub then e._sub=sub; e.sub.Text=sub end
                if e._col~=col then e._col=col; e.name.TextColor3=col; e.edge.Color=col end

                local near,far=18,220
                local t=math.clamp((dist-near)/(far-near),0,1)
                local dim=t*0.55
                if e._dim~=dim then
                    e._dim=dim
                    e.scale.Scale=1-(t*0.45)
                    e.card.BackgroundTransparency=0.2+dim*0.5
                    e.edge.Transparency=0.75+dim*0.2
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                    e.name.TextTransparency=dim
                    e.sub.TextTransparency=math.min(1,dim*1.25)
                    e.avatar.ImageTransparency=dim
                end
                local wantAv=flags.espAvatar and true or false
                if e._av~=wantAv then
                    e._av=wantAv
                    e.avatar.Visible=wantAv
                    e.name.Position=UDim2.new(0,wantAv and 36 or 12,0.5,0)
                    e._nw=nil
                end
                if e._nw~=(nm..sub..tostring(wantAv)) then
                    e._nw=nm..sub..tostring(wantAv)
                    local okN,nz=pcall(function()
                        return Mono.TextService:GetTextSize(nm,e.name.TextSize,e.name.Font,Vector2.new(4000,40))
                    end)
                    local okS,sz2=pcall(function()
                        return Mono.TextService:GetTextSize(sub,e.sub.TextSize,e.sub.Font,Vector2.new(4000,40))
                    end)
                    local nw=okN and nz.X or (#nm*8)
                    local sw=okS and sz2.X or (#sub*6)
                    local left=wantAv and 36 or 12
                    local w=math.clamp(math.ceil(left+nw+14+sw+10),150,520)
                    e.name.Size=UDim2.fromOffset(math.ceil(nw)+2,15)
                    e.sub.Size=UDim2.fromOffset(math.ceil(sw)+2,14)
                    e.card.Size=UDim2.fromOffset(w,32)
                    e.bb.Size=UDim2.fromOffset(w,40)
                end
                if flags.espAvatar and e.avatar.Image=="" and os.clock()-(e._avAt or -99)>4 then
                    local uid=plr.UserId
                    e._avAt=os.clock()
                    task.spawn(function()
                        local ok,url=pcall(function()
                            return Players:GetUserThumbnailAsync(uid,
                                Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
                        end)
                        if ok and url and e.avatar and e.avatar.Parent then e.avatar.Image=url end
                    end)
                end
            else e.bb.Enabled=false end
        else clearEsp(plr) end
    end end
    task.wait(0.05)
end end)

local boxStore={}
local function clearBox(plr)
    local b=boxStore[plr]
    if b then for _,l in ipairs(b) do Mono.dropDraw(l) end; boxStore[plr]=nil end
end
local function ensureBox(plr)
    local b=boxStore[plr]
    if b then return b end
    b={}
    for i=1,4 do
        b[i]=Mono.newLine(1)
    end
    boxStore[plr]=b; return b
end
local tracerStore={}
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
local function clearTracer(plr)
    local t=tracerStore[plr]
    if t then Mono.dropDraw(t); tracerStore[plr]=nil end
end
local function ensureTracer(plr)
    local t=tracerStore[plr]
    if t then return t end
    t=Mono.newLine(2)
    tracerStore[plr]=t; return t
end
local function tracerOrigin()
    local vp=Camera.ViewportSize
    local from=flags.espTracerFrom
    if from=="Top" then return Vector2.new(vp.X*0.5,0)
    elseif from=="Center" then return Vector2.new(vp.X*0.5,vp.Y*0.5)
    elseif from=="Bottom Left" then return Vector2.new(0,vp.Y)
    elseif from=="Bottom Right" then return Vector2.new(vp.X,vp.Y)
    elseif from=="Mouse" then
        local m=UserInputService:GetMouseLocation()
        return Vector2.new(m.X,m.Y)
    end
    return Vector2.new(vp.X*0.5,vp.Y)
end

local CORNERS={
    Vector3.new(-1,-1,-1),Vector3.new(-1,-1,1),Vector3.new(-1,1,-1),Vector3.new(-1,1,1),
    Vector3.new(1,-1,-1),Vector3.new(1,-1,1),Vector3.new(1,1,-1),Vector3.new(1,1,1),
}
Mono.boundsCache=setmetatable({},{__mode="k"})
Mono.bodyCache=setmetatable({},{__mode="k"})
function Mono.bodyParts(ch)
    local e=Mono.bodyCache[ch]
    if e then
        if not e.dirty then return e.list end
    else
        e={dirty=true,list={}}
        Mono.bodyCache[ch]=e
        local function soil() e.dirty=true end
        ch.ChildAdded:Connect(soil)
        ch.ChildRemoved:Connect(soil)
    end
    local l=e.list
    table.clear(l)
    for _,d in ipairs(ch:GetChildren()) do
        if d:IsA("BasePart") then l[#l+1]=d end
    end
    e.dirty=false
    return l
end
local function charBounds(ch)
    local hrp=getHRP(ch); if not hrp then return nil end
    local base=hrp.CFrame
    local minX,minY,minZ=math.huge,math.huge,math.huge
    local maxX,maxY,maxZ=-math.huge,-math.huge,-math.huge
    local found=false
    local body=Mono.bodyParts(ch)
    for i=1,#body do
        local d=body[i]
        if d.Parent then
            local rel=base:PointToObjectSpace(d.Position)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            local h=d.Size*0.5
            local r=math.max(h.X,h.Y,h.Z)
            if rel.X-h.X<minX then minX=rel.X-h.X end
            if rel.X+h.X>maxX then maxX=rel.X+h.X end
            if rel.Y-h.Y<minY then minY=rel.Y-h.Y end
            if rel.Y+h.Y>maxY then maxY=rel.Y+h.Y end
            if rel.Z-r<minZ then minZ=rel.Z-r end
            if rel.Z+r>maxZ then maxZ=rel.Z+r end
            found=true
        end
    end
    if not found then return base,Vector3.new(4,6,2) end
    local size=Vector3.new(maxX-minX,maxY-minY,maxZ-minZ)
    local off=Vector3.new((minX+maxX)*0.5,(minY+maxY)*0.5,(minZ+maxZ)*0.5)
    local prev=Mono.boundsCache[ch]
    if prev then
        local a=0.25
        size=prev.size:Lerp(size,a)
        off=prev.off:Lerp(off,a)
        prev.size,prev.off=size,off
    else
        Mono.boundsCache[ch]={size=size,off=off}
    end
    return base*CFrame.new(off),size
end
local box3Store={}
local function clearBox3(plr)
    local b=box3Store[plr]
    if b then for _,l in ipairs(b) do Mono.dropDraw(l) end; box3Store[plr]=nil end
end
local function ensureBox3(plr)
    local b=box3Store[plr]
    if b then return b end
    b={}
    for i=1,12 do b[i]=Mono.newLine(1) end
    box3Store[plr]=b; return b
end
local BOX3_EDGES={
    {1,2},{1,3},{1,5},{2,4},{2,6},{3,4},{3,7},{4,8},{5,6},{5,7},{6,8},{7,8},
}

local R15Bones={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
local R6Bones={{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
local skelStore={}
local function clearSkel(plr)
    local s=skelStore[plr]
    if not s then return end
    for _,l in ipairs(s.lines) do Mono.dropDraw(l) end
    skelStore[plr]=nil
end
local function ensureSkel(plr,ch)
    local bones=ch:FindFirstChild("UpperTorso") and R15Bones or R6Bones
    local s=skelStore[plr]
    if s and s.bones==bones and s.char==ch then return s end
    if s then clearSkel(plr) end
    s={bones=bones,lines={},char=ch,uniq={},pair={},vx={},vy={},vok={}}
    local idx={}
    for i=1,#bones do
        s.lines[i]=Mono.newLine(2)
        local ja,jb
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        for k=1,2 do
            local p=ch:FindFirstChild(bones[i][k])
            local j
            if p then
                j=idx[p]
                if not j then s.uniq[#s.uniq+1]=p; j=#s.uniq; idx[p]=j end
            end
            if k==1 then ja=j else jb=j end
        end
        s.pair[i]={ja,jb}
    end
    skelStore[plr]=s; return s
end
bind(RunService.RenderStepped,function()
    local doBox,doSkel,doTracer,doBox3=flags.espBox,flags.espSkeleton,flags.espTracers,flags.espBox3D
    if not doBox and next(boxStore) then for p in pairs(boxStore) do clearBox(p) end end
    if not doSkel and next(skelStore) then for p in pairs(skelStore) do clearSkel(p) end end
    if not doTracer and next(tracerStore) then for p in pairs(tracerStore) do clearTracer(p) end end
    if not doBox3 and next(box3Store) then for p in pairs(box3Store) do clearBox3(p) end end
    if not (doBox or doSkel or doTracer or doBox3) then return end
    refreshGuiRects()
    local needCorners=doBox or doBox3
    local camCF=Camera.CFrame
    local camPos,camLook=camCF.Position,camCF.LookVector
    local tOrigin=doTracer and tracerOrigin() or nil
    for _,plr in ipairs(Mono.plrs) do if plr~=LocalPlayer then
        local ch,_,cullRoot=Mono.hasBody(plr)
        if ch then
            if cullRoot and (cullRoot.Position-camPos):Dot(camLook)<=0 then
                local hb=boxStore[plr]
                if hb then for i=1,#hb do hb[i].Visible=false end end
                local h3=box3Store[plr]
                if h3 then for i=1,#h3 do h3[i].Visible=false end end
                local ht=tracerStore[plr]
                if ht then ht.Visible=false end
                local hs=skelStore[plr]
                if hs then
                    for i=1,#hs.lines do local l=hs.lines[i]; if l then l.Visible=false end end
                end
                continue
            end
            local col=espColor(Mono.espRole(plr))

            local pts,okPts
            local bx1,by1,bx2,by2
            local allAhead=false
            if needCorners then
                local cf,size=charBounds(ch)
                if cf then
                    pts,okPts={},true
                    bx1,by1,bx2,by2=math.huge,math.huge,-math.huge,-math.huge
                    local half=size*0.5
                    local hx,hy,hz=half.X,half.Y,half.Z
                    local ahead=0
                    for i=1,8 do
                        local c=CORNERS[i]
                        local v=Camera:WorldToViewportPoint(
                            cf:PointToWorldSpace(Vector3.new(c.X*hx,c.Y*hy,c.Z*hz)))
                        pts[i]=Vector2.new(v.X,v.Y)
                        if v.Z>0 then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                            ahead=ahead+1
                            if v.X<bx1 then bx1=v.X end
                            if v.X>bx2 then bx2=v.X end
                            if v.Y<by1 then by1=v.Y end
                            if v.Y>by2 then by2=v.Y end
                        end
                    end
                    allAhead=(ahead==8)
                    if ahead<4 then okPts=false end
                    if okPts and ((bx2-bx1)<1 or (by2-by1)<1) then okPts=false end
                else okPts=false end
            end
            local blocked=okPts and rectBlocked(bx1,by1,bx2,by2) or false

            if doBox then
                local b=ensureBox(plr)
                if okPts and not blocked then
                    local tl,tr=Vector2.new(bx1,by1),Vector2.new(bx2,by1)
                    local bl,br=Vector2.new(bx1,by2),Vector2.new(bx2,by2)
                    local segs={{tl,tr},{tr,br},{br,bl},{bl,tl}}
                    for i=1,4 do
                        local seg,l=segs[i],b[i]
                        l.From,l.To,l.Color,l.Visible=seg[1],seg[2],col,true
                    end
                else
                    for _,l in ipairs(b) do l.Visible=false end
                end
            end
            if doBox3 then
                local b=ensureBox3(plr)
                if okPts and allAhead and not blocked then
                    for i=1,12 do
                        local e2=BOX3_EDGES[i]
                        local l=b[i]
                        l.From,l.To,l.Color,l.Visible=pts[e2[1]],pts[e2[2]],col,true
                    end
                else
                    for _,l in ipairs(b) do l.Visible=false end
                end
            end
            if doTracer then
                local t=ensureTracer(plr)
                local tx,ty
                local thrp=cullRoot
                local far=false
                if thrp and flags.espMaxDist>0 then
                    far=(thrp.Position-camPos).Magnitude>flags.espMaxDist
                end
                if not far then
                    if okPts then
                        tx,ty=(bx1+bx2)*0.5,by2
                    elseif thrp then
                        local v=Camera:WorldToViewportPoint(thrp.Position-Vector3.new(0,3,0))
                        if v.Z>0 then tx,ty=v.X,v.Y end
                    end
                end
                if tx and not pointBlocked(tx,ty) then
                    t.From=tOrigin; t.To=Vector2.new(tx,ty); t.Color=col; t.Visible=true
                else t.Visible=false end
            end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            if doSkel then
                local s=ensureSkel(plr,ch)
                local rootHrp=cullRoot
                local vis=false
                if rootHrp then
                    local rv=Camera:WorldToViewportPoint(rootHrp.Position)
                    local vp=Camera.ViewportSize
                    vis=rv.Z>0 and rv.X>-250 and rv.X<vp.X+250 and rv.Y>-250 and rv.Y<vp.Y+250
                end
                if not vis then
                    for i=1,#s.lines do local l=s.lines[i]; if l then l.Visible=false end end
                else
                    local uq,vx,vy,vok=s.uniq,s.vx,s.vy,s.vok
                    for j=1,#uq do
                        local p=uq[j]
                        if p.Parent then
                            local v=Camera:WorldToViewportPoint(p.Position)
                            vx[j],vy[j],vok[j]=v.X,v.Y,v.Z>0
                        else vok[j]=false end
                    end
                    for i=1,#s.bones do
                        local line=s.lines[i]
                        if line then
                            local pr=s.pair[i]
                            local ja,jb=pr[1],pr[2]
                            if ja and jb and vok[ja] and vok[jb]
                                and not pointBlocked(vx[ja],vy[ja]) and not pointBlocked(vx[jb],vy[jb]) then
                                line.From=Vector2.new(vx[ja],vy[ja]); line.To=Vector2.new(vx[jb],vy[jb])
                                line.Color=col; line.Visible=true
                            else line.Visible=false end
                        end
                    end
                end
            end
        else
            if doBox then clearBox(plr) end
            if doSkel then clearSkel(plr) end
            if doTracer then clearTracer(plr) end
            if doBox3 then clearBox3(plr) end
        end
    end end
end)
bind(Players.PlayerRemoving,function(plr) clearEsp(plr); clearSkel(plr); clearBox(plr); clearTracer(plr); clearBox3(plr) end)

local coinContainerRef
local function getCoinContainer()
    if coinContainerRef and coinContainerRef.Parent then return coinContainerRef end
    local map=CollectionService:GetTagged("CurrentMap")[1]
    coinContainerRef=(map and map:FindFirstChild("CoinContainer")) or workspace:FindFirstChild("CoinContainer",true)
    return coinContainerRef
end
local function coinTaken(d) local c=d:GetAttribute("Collected"); return c==true or c=="true" end
local function freshCoins()
    local out={}
    local tagged=CollectionService:GetTagged("ServerCoinPart")
    if #tagged>0 then
        for _,d in ipairs(tagged) do
            if d:IsA("BasePart") and d.Parent and not coinTaken(d) then out[#out+1]=d end
        end
        return out
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end
    local c=getCoinContainer()
    if c then for _,d in ipairs(c:GetChildren()) do if d:IsA("BasePart") and (d:GetAttribute("CoinID")~=nil or d.Name=="Coin_Server") and not coinTaken(d) then out[#out+1]=d end end end
    return out
end
local coinCache={}
task.spawn(function() while not isDead() do
    if flags.coinEsp or flags.autoCoins then
        coinCache=freshCoins(); task.wait(0.2)
    else
        if #coinCache>0 then coinCache={} end
        task.wait(1)
    end
end end)
local coinEspStore={}
task.spawn(function() while not isDead() do
    if flags.coinEsp then local seen={}
        for _,coin in ipairs(coinCache) do seen[coin]=true
            if not coinEspStore[coin] then
                local vis=coin:FindFirstChild("CoinVisual"); local ad=(vis and vis:FindFirstChild("MainCoin")) or vis or coin
                coinEspStore[coin]=create("Highlight",{Name=rnd(),Adornee=ad,FillColor=Color3.fromRGB(255,205,55),FillTransparency=0.25,OutlineColor=Color3.fromRGB(255,235,150),OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Parent=EspGui}) end end
        for coin,hl in pairs(coinEspStore) do if not seen[coin] or not coin.Parent then hl:Destroy();coinEspStore[coin]=nil end end
    elseif next(coinEspStore) then for coin,hl in pairs(coinEspStore) do hl:Destroy();coinEspStore[coin]=nil end end
    task.wait(0.15)
end end)

local GameplayR=RS:WaitForChild("Remotes"):WaitForChild("Gameplay")

for _,rn in ipairs({"TeleportToPart","RoundStart","RoundEndFade","LoadingMap","GameOver","VictoryScreen"}) do
    local r=GameplayR:FindFirstChild(rn)
    if r and r:IsA("RemoteEvent") then bind(r.OnClientEvent,Mono.markTeleport) end
end
bind(LocalPlayer.CharacterAdded,Mono.markTeleport)

local coinBagFull=false
local CoinCollectedR=GameplayR:FindFirstChild("CoinCollected")
local CoinsStartedR=GameplayR:FindFirstChild("CoinsStarted")
if CoinCollectedR then bind(CoinCollectedR.OnClientEvent,function(_,collected,capacity)
    if type(collected)=="number" and type(capacity)=="number" and capacity>0 and collected>=capacity then
        if not coinBagFull then
            coinBagFull=true
            if flags.autoCoins then notify("Coin bag full, auto collect stopped",4) end
        end
    end
end) end
if CoinsStartedR then bind(CoinsStartedR.OnClientEvent,function() coinBagFull=false end) end

local farmBlack={}
task.spawn(function()
    local target,since,farming,prevWS
    local function standDown()
        if not farming then return end
        farming=false
        local ch2=LocalPlayer.Character
        local hum2=ch2 and ch2:FindFirstChildOfClass("Humanoid")
        if hum2 then pcall(function() hum2.PlatformStand=false; if prevWS then hum2.WalkSpeed=prevWS end end) end
        Mono.wantPS=false
        Mono.wantNoclip=false
        Mono.recollide(hum2)
        unstick(ch2)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        prevWS=nil
    end
    while not isDead() do
        if flags.autoCoins and not coinBagFull and alive(LocalPlayer) and not Mono.teleporting() then
            local ch=LocalPlayer.Character; local hrp=getHRP(ch); local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                local coin,bd
                for _,c in ipairs(coinCache) do
                    if c.Parent and not coinTaken(c) and not (farmBlack[c] and os.clock()<farmBlack[c]) then
                        local d=(c.Position-hrp.Position).Magnitude
                        if d<=Mono.COIN_MAX_DIST and (not bd or d<bd) then bd,coin=d,c end
                    end
                end
                if coin then
                    if not farming then farming=true; prevWS=hum.WalkSpeed; pcall(function() hum.PlatformStand=true end); Mono.wantPS=true; Mono.wantNoclip=true end
                    local spd=COLLECT_SPEED
                    pcall(function() hum.WalkSpeed=spd end)
                    if coin~=target then target=coin; since=os.clock() end
                    if os.clock()-since>5 then farmBlack[coin]=os.clock()+8; target=nil; task.wait()
                    else
                        local dt=RunService.RenderStepped:Wait()
                        uncollide(ch)
                        local dir=coin.Position-hrp.Position
                        if dir.Magnitude>2 then hrp.CFrame=CFrame.new(hrp.Position+dir.Unit*math.min(dir.Magnitude,spd*dt)); hrp.AssemblyLinearVelocity=Vector3.zero end
                        if typeof(firetouchinterest)=="function" then pcall(function() firetouchinterest(hrp,coin,0);firetouchinterest(hrp,coin,1) end) end
                    end
                else
                    standDown()
                    target=nil; task.wait(0.25)
                end
            else task.wait(0.1) end
        else
            standDown()
            target=nil; task.wait(0.2)
        end
    end
end)

local function findDroppedGun()
    for _,p in ipairs(CollectionService:GetTagged("GunDrop")) do
        if p:IsA("BasePart") and p:IsDescendantOf(workspace) then return p end
    end
    local map=CollectionService:GetTagged("CurrentMap")[1]
    if map then
        local g=map:FindFirstChild("GunDrop")
        if g and g:IsA("BasePart") then return g end
    end
    for _,d in ipairs(workspace:GetChildren()) do
        if d:IsA("BasePart") and d.Name=="GunDrop" then return d end
        if d:IsA("Model") then
            local g=d:FindFirstChild("GunDrop")
            if g and g:IsA("BasePart") then return g end
        end
    end
end
local droppedGun
local gunEspHL,gunEspBB
task.spawn(function() while not isDead() do
    if not flags.gunEsp then
        if gunEspHL then gunEspHL.Enabled=false end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        if gunEspBB then gunEspBB.Enabled=false end
        task.wait(0.5)
        continue
    end
    local h=droppedGun
    if h and h.Parent then
        if not gunEspHL then gunEspHL=create("Highlight",{Name=rnd(),FillColor=Color3.fromRGB(90,150,255),FillTransparency=0.35,OutlineColor=Color3.fromRGB(170,210,255),OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Parent=EspGui}) end
        if not gunEspBB then
            gunEspBB=create("BillboardGui",{Name=rnd(),Size=UDim2.fromOffset(160,18),AlwaysOnTop=true,StudsOffsetWorldSpace=Vector3.new(0,2,0),Parent=EspGui},
                {create("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(140,190,255),TextStrokeTransparency=.4,Text="GUN"})})
        end
        gunEspHL.Adornee=h; gunEspHL.Enabled=true
        gunEspBB.Adornee=h; gunEspBB.Enabled=flags.gunEspDist
        if flags.gunEspDist then
            local hrp=getHRP(LocalPlayer.Character)
            local dist=hrp and math.floor((h.Position-hrp.Position).Magnitude) or 0
            local lbl=gunEspBB:FindFirstChildOfClass("TextLabel"); if lbl then lbl.Text="DROPPED GUN  ·  "..dist.."m" end
        end
    else
        if gunEspHL then gunEspHL.Enabled=false end
        if gunEspBB then gunEspBB.Enabled=false end
    end
    task.wait(0.1)
end end)
local grabbing=false
local function touchGun(h)
    local hrp=getHRP(LocalPlayer.Character)
    if not (hrp and h and h.Parent) then return false end
    if typeof(firetouchinterest)=="function" then
        pcall(function()
            for _=1,4 do
                firetouchinterest(hrp,h,0)
                firetouchinterest(hrp,h,1)
            end
        end)
    end
    return findWeapon("Gun")~=nil
end
function Mono.canAct()
    if Mono.teleporting() then return false end
    local ch=LocalPlayer.Character
    if not ch or not ch.Parent then return false end
    local hum=ch:FindFirstChildOfClass("Humanoid")
    if not (hum and hum.Health>0) then return false end
    if not getHRP(ch) then return false end
    if LocalPlayer:GetAttribute("Alive")==false then return false end
    local d=roundData(LocalPlayer)
    if d and d.Dead==true then return false end
    return true
end
local function grabGunOnce(target)
    if grabbing then return false end
    local h=target or droppedGun or findDroppedGun()
    local hrp=getHRP(LocalPlayer.Character)
    if not (h and h.Parent and hrp and Mono.canAct()) then return false end
    grabbing=true
    if touchGun(h) then
        notify("Grabbed the Sheriff gun")
        grabbing=false
        return true
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end
    local back=hrp.CFrame
    for _=1,10 do
        local myhrp=getHRP(LocalPlayer.Character)
        if not (myhrp and h.Parent) then break end
        if not Mono.canAct() then break end
        Mono.markSelfTP()
        myhrp.CFrame=CFrame.new(h.Position); myhrp.AssemblyLinearVelocity=Vector3.zero
        if touchGun(h) then break end
        RunService.Heartbeat:Wait()
    end
    local myhrp=getHRP(LocalPlayer.Character)
    if myhrp then myhrp.CFrame=back; myhrp.AssemblyLinearVelocity=Vector3.zero end
    local got=findWeapon("Gun")~=nil
    if got then notify("Grabbed the Sheriff gun") end
    grabbing=false
    return got
end
local function onGunAppeared(inst)
    if not (inst and inst:IsA("BasePart") and inst:IsDescendantOf(workspace)) then return end
    droppedGun=inst
    if flags.autoGun and not grabbing and myRole()~="Murderer" and not findWeapon("Gun") and Mono.canAct() then
        task.spawn(grabGunOnce,inst)
    end
end
pcall(function()
    bind(CollectionService:GetInstanceAddedSignal("GunDrop"),onGunAppeared)
    bind(CollectionService:GetInstanceRemovedSignal("GunDrop"),function(i)
        if droppedGun==i then droppedGun=nil end
    end)
end)
bind(workspace.DescendantAdded,function(d)
    if d.Name=="GunDrop" then task.defer(onGunAppeared,d) end
end)
task.spawn(function() while not isDead() do
    if flags.gunEsp or flags.autoGun then
        local g=findDroppedGun()
        droppedGun=g
        if g and flags.autoGun and not grabbing and myRole()~="Murderer" and not findWeapon("Gun") and Mono.canAct() then
            grabGunOnce(g)
        end
    elseif droppedGun then droppedGun=nil end
    task.wait((flags.gunEsp or flags.autoGun) and 0.1 or 0.6)
end end)

Mono.lightStore=nil
Mono.shadowOrig=nil
function Mono.shadowsOff()
    if Mono.shadowOrig==nil then Mono.shadowOrig=Lighting.GlobalShadows end
    pcall(function() Lighting.GlobalShadows=false end)
end
function Mono.shadowsRestore()
    if flags.fullbright or flags.fpsBoost then return end
    if Mono.shadowOrig~=nil then
        pcall(function() Lighting.GlobalShadows=Mono.shadowOrig end)
        Mono.shadowOrig=nil
    end
end
function Mono.brightApply()
    if not Mono.lightStore then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Mono.lightStore={Lighting.Brightness,Lighting.ClockTime,Lighting.Ambient,
            Lighting.OutdoorAmbient,Lighting.FogEnd,Lighting.FogStart,Lighting.ExposureCompensation}
    end
    pcall(function()
        Lighting.Brightness=math.max(Lighting.Brightness,3)
        Lighting.ClockTime=14
        Lighting.Ambient=Color3.new(1,1,1)
        Lighting.OutdoorAmbient=Color3.new(1,1,1)
        Lighting.FogStart=1e6
        Lighting.FogEnd=1e6
        Lighting.ExposureCompensation=0
    end)
    Mono.shadowsOff()
end
function Mono.brightRestore()
    local s=Mono.lightStore
    if s then
        pcall(function()
            Lighting.Brightness,Lighting.ClockTime,Lighting.Ambient=s[1],s[2],s[3]
            Lighting.OutdoorAmbient,Lighting.FogEnd,Lighting.FogStart,Lighting.ExposureCompensation=s[4],s[5],s[6],s[7]
        end)
        Mono.lightStore=nil
    end
    Mono.shadowsRestore()
end
function Mono.gfxApply()
    local atm=Lighting:FindFirstChildOfClass("Atmosphere")
    if atm and not Mono.atmStore then
        Mono.atmStore={atm,atm.Density,atm.Haze,atm.Glare}
        pcall(function() atm.Density=0; atm.Haze=0; atm.Glare=0 end)
    end
    Mono.shadowsOff()
end
function Mono.gfxRestore()
    local a=Mono.atmStore
    if a then
        pcall(function() if a[1].Parent then a[1].Density=a[2]; a[1].Haze=a[3]; a[1].Glare=a[4] end end)
        Mono.atmStore=nil
    end
    Mono.shadowsRestore()
end
local function setFullbright(on)
    if on then Mono.brightApply() else Mono.brightRestore() end
end
local fpsStore,fpsConn
local function fxKill(e,store)
    if store[e]~=nil then return end
    if e:IsA("PostEffect") then if e.Enabled then e.Enabled=false; store[e]={"en"} end
    elseif e:IsA("ParticleEmitter") or e:IsA("Trail") or e:IsA("Smoke") or e:IsA("Fire") or e:IsA("Sparkles") or e:IsA("Beam") then if e.Enabled then e.Enabled=false; store[e]={"en"} end
    elseif e:IsA("Decal") or e:IsA("Texture") then store[e]={"tr",e.Transparency}; e.Transparency=1
    elseif e:IsA("SurfaceAppearance") then store[e]={"par",e.Parent}; e.Parent=nil
    elseif e:IsA("BasePart") then
        local mat,refl=e.Material,e.Reflectance
        local tex=e:IsA("MeshPart") and e.TextureID or nil
        if mat~=Enum.Material.SmoothPlastic or refl~=0 or (tex and tex~="") then
            store[e]={"part",mat,refl,tex}
            pcall(function()
                e.Material=Enum.Material.SmoothPlastic
                e.Reflectance=0
                if tex and tex~="" then e.TextureID="" end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            end)
        end
    end
end
local function setFPSBoost(on)
    if on then
        fpsStore={changed=Mono.fxPending or {}}
        Mono.fxPending=nil
        Mono.gfxApply()
        local terrain=workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            local okD,d=pcall(function() return terrain.Decoration end)
            if okD then fpsStore.decor=d; pcall(function() terrain.Decoration=false end) end
            fpsStore.water={terrain.WaterWaveSize,terrain.WaterWaveSpeed,terrain.WaterReflectance}
            terrain.WaterWaveSize=0;terrain.WaterWaveSpeed=0;terrain.WaterReflectance=0
        end
        fpsConn=workspace.DescendantAdded:Connect(function(e) if flags.fpsBoost and fpsStore then task.defer(fxKill,e,fpsStore.changed) end end)
        task.spawn(function() local s=fpsStore.changed; local n=0
            for _,e in ipairs(Lighting:GetDescendants()) do fxKill(e,s) end
            for _,e in ipairs(workspace:GetDescendants()) do
                if not (flags.fpsBoost and fpsStore and fpsStore.changed==s) then return end
                fxKill(e,s); n+=1; if n%900==0 then RunService.Heartbeat:Wait() end
            end
        end)
    elseif fpsStore then
        local s=fpsStore.changed
        Mono.fxPending=s
        Mono.gfxRestore()
        local terrain=workspace:FindFirstChildOfClass("Terrain")
        if terrain and fpsStore.water then terrain.WaterWaveSize,terrain.WaterWaveSpeed,terrain.WaterReflectance=fpsStore.water[1],fpsStore.water[2],fpsStore.water[3] end
        if terrain and fpsStore.decor~=nil then pcall(function() terrain.Decoration=fpsStore.decor end) end
        if fpsConn then fpsConn:Disconnect();fpsConn=nil end; fpsStore=nil
        task.spawn(function() local n=0 for e,info in pairs(s) do
            if Mono.fxPending~=s then return end
            pcall(function()
            if info[1]=="en" then e.Enabled=true
            elseif info[1]=="tr" then e.Transparency=info[2]
            elseif info[1]=="par" then e.Parent=info[2]
            elseif info[1]=="part" then
                e.Material=info[2]; e.Reflectance=info[3]
                if info[4] and info[4]~="" then e.TextureID=info[4] end
            end end)
            s[e]=nil
            n+=1; if n%900==0 then RunService.Heartbeat:Wait() end end
            if Mono.fxPending==s then Mono.fxPending=nil end end)
    end
end
unstick=function(ch)
    if not ch then return end
    local hrp=getHRP(ch); if not hrp then return end
    task.spawn(function()
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances={ch}
        local from=hrp.Position+Vector3.new(0,6,0)
        local hit=workspace:Raycast(from,Vector3.new(0,-200,0),params)
        Mono.markSelfTP()
        if hit then
            hrp.CFrame=CFrame.new(hit.Position+Vector3.new(0,3.5,0))
        else
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            hrp.CFrame=hrp.CFrame+Vector3.new(0,4,0)
        end
        hrp.AssemblyLinearVelocity=Vector3.zero
        RunService.Heartbeat:Wait()
        for p in pairs(Mono.unclip) do
            if p.Parent and p.Name~="HumanoidRootPart" then p.CanCollide=true end
        end
        table.clear(Mono.unclip)
    end)
end
local function tpTo(pos)
    local hrp=getHRP(LocalPlayer.Character); if not hrp then return false end
    Mono.markSelfTP()
    hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0))
    return true
end

local function resolvePlayer(v)
    if typeof(v)=="Instance" and v:IsA("Player") then return v end
    if type(v)=="table" then
        for k,on in pairs(v) do
            local cand=(on==true) and k or on
            if typeof(cand)=="Instance" and cand:IsA("Player") then return cand end
            if type(cand)=="string" then local p=resolvePlayer(cand); if p then return p end end
        end
        return nil
    end
    if type(v)=="string" and #v>0 then
        local p=Players:FindFirstChild(v); if p and p:IsA("Player") then return p end
        local lv=v:lower()
        for _,q in ipairs(Mono.plrs) do
            if q.Name:lower()==lv or (q.DisplayName or ""):lower()==lv then return q end
        end
    end
    return nil
end

Mono.canClaim=(typeof(sethiddenproperty)=="function")
if not Mono.canClaim then
    Fallback.note("Fling","velocity only",
        "your executor has no sethiddenproperty, so Mono cannot claim the target's physics and has to rely on raw velocity, which lands far less often",
        {"Fling Player","Fling All Players","Auto Fling Murderer","Auto Fling Sheriff"})
end
Mono.flungAt=setmetatable({},{__mode="k"})
Mono.FLING_MAX_DY=140
Mono.FLING_MAX_RISE=320
function Mono.voidY()
    local ok,v=pcall(function() return workspace.FallenPartsDestroyHeight end)
    return (ok and type(v)=="number") and v or -500
end
function Mono.alreadyFlung(p)
    local hrp=p and p.Character and getHRP(p.Character)
    if not hrp then return true end
    if os.clock()-(Mono.flungAt[p] or -60)<4 then return true end
    if hrp.AssemblyLinearVelocity.Magnitude>100 then return true end
    if hrp.Position.Y<Mono.voidY()+150 then return true end
    local mine=getHRP(LocalPlayer.Character)
    if mine then
        local dy=hrp.Position.Y-mine.Position.Y
        if dy<-60 or dy>120 then return true end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end
    return false
end

local function flingPlayer(p,keepPos)
    if flinging then return false,"already flinging someone" end
    local myCh=LocalPlayer.Character; local myHrp=getHRP(myCh)
    local hum=myCh and myCh:FindFirstChildOfClass("Humanoid")
    local tHrp=p and p.Character and getHRP(p.Character)
    if not (myHrp and hum and tHrp) then return false,"they have no character right now" end
    local back=keepPos or myHrp.CFrame
    if Mono.teleporting() then return false,"the round just moved you, try again in a second" end
    if math.abs(tHrp.Position.Y-back.Position.Y)>Mono.FLING_MAX_DY then return false,"they are too far above or below you" end
    if tHrp.AssemblyLinearVelocity.Magnitude>340 then return false,"they are already flying, wait for them to land" end

    Mono.flingAt=os.clock()
    flinging=true
    local moved=false
    local movel=0.1
    local t0=os.clock()
    local claimed
    while os.clock()-t0<flags.flingSeconds do
        if Mono.teleporting() then break end
        RunService.Heartbeat:Wait()
        local h=getHRP(LocalPlayer.Character)
        local t=p.Character and getHRP(p.Character)
        if not (h and t and h.Parent and t.Parent) then break end
        local tp=t.Position
        if tp.Y<Mono.voidY()+400 then break end
        if t.AssemblyLinearVelocity.Magnitude>340 then break end
        if tp.Y>back.Position.Y+Mono.FLING_MAX_RISE then break end
        if tp.Y<back.Position.Y-Mono.FLING_MAX_DY then break end
        h.CFrame=t.CFrame
        moved=true
        Mono.flungAt[p]=os.clock()
        if Mono.canClaim then
            pcall(function() sethiddenproperty(h,"PhysicsRepRootPart",t) end)
            claimed=h
        end
        local vel=h.AssemblyLinearVelocity
        h.AssemblyLinearVelocity=vel*flags.flingPower+Vector3.new(0,flags.flingPower,0)
        RunService.RenderStepped:Wait()
        if not h.Parent then break end
        h.AssemblyLinearVelocity=vel
        RunService.Stepped:Wait()
        if not h.Parent then break end
        h.AssemblyLinearVelocity=vel+Vector3.new(0,movel,0)
        movel=-movel
    end

    local function release(part)
        if part and Mono.canClaim then pcall(function() sethiddenproperty(part,"PhysicsRepRootPart",nil) end) end
    end
    release(claimed)
    local nowHrp=getHRP(LocalPlayer.Character)
    if nowHrp and nowHrp~=claimed then release(nowHrp) end

    if not moved then
        flinging=false
        Mono.recollide(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"),true)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        return false,"could not get a grip on them, try again"
    end

    local home=CFrame.new(back.Position+Vector3.new(0,4,0))
    for _=1,6 do
        local ch2=LocalPlayer.Character
        if not ch2 then break end
        for _,pp in ipairs(getCharParts(ch2)) do
            if pp.Parent then
                pp.AssemblyLinearVelocity=Vector3.zero
                pp.AssemblyAngularVelocity=Vector3.zero
            end
        end
        RunService.Heartbeat:Wait()
    end
    local h2=getHRP(LocalPlayer.Character)
    if h2 then
        h2.CFrame=home
        h2.AssemblyLinearVelocity=Vector3.zero
        h2.AssemblyAngularVelocity=Vector3.zero
    end
    flinging=false
    local hum2=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    Mono.recollide(hum2,true)
    local watch=os.clock()
    while os.clock()-watch<1.5 do
        RunService.Heartbeat:Wait()
        if Mono.teleporting() then break end
        local h3=getHRP(LocalPlayer.Character)
        if not h3 then break end
        local lv=h3.AssemblyLinearVelocity
        local av=h3.AssemblyAngularVelocity
        if badVec(lv) or badVec(av) or lv.Magnitude>200 or av.Magnitude>25 then
            h3.AssemblyLinearVelocity=Vector3.zero
            h3.AssemblyAngularVelocity=Vector3.zero
            h3.CFrame=home
        end
    end
    Mono.recollide(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"),true)
    return true
end
local function flingAll()
    local myHrp=getHRP(LocalPlayer.Character)
    if not myHrp then notify("You have no character"); return end
    local home=myHrp.CFrame
    task.spawn(function()
        local n=0
        for _,p in ipairs(Mono.plrs) do
            if p~=LocalPlayer and Mono.hasBody(p) then
                if flingPlayer(p,home) then n=n+1 end
                task.wait(0.1)
            end
        end
        local h=getHRP(LocalPlayer.Character)
        if h then h.CFrame=home; h.AssemblyLinearVelocity=Vector3.zero end
        notify("Flung "..n.." player"..(n==1 and "" or "s"))
    end)
end
task.spawn(function() while not isDead() do
    if (flags.autoFlingMurderer or flags.autoFlingSheriff)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        and Mono.hasBody(LocalPlayer) and not flinging and not Mono.teleporting() then
        local want
        for _,p in ipairs(Mono.plrs) do
            if p~=LocalPlayer and alive(p) and p.Character and getHRP(p.Character) then
                local r=roleOf(p)
                if ((flags.autoFlingMurderer and r=="Murderer")
                    or (flags.autoFlingSheriff and isGunRole(r)))
                    and not Mono.alreadyFlung(p) then
                    want=p; break
                end
            end
        end
        if want then flingPlayer(want) end
    end
    task.wait(0.5)
end end)

local MURD_ALERT_RANGE=50
local murdNotif=nil
local murdInRange=false
local function closeMurdNotif()
    murdInRange=false
    if murdNotif then
        pcall(function() murdNotif:Close() end)
        murdNotif=nil
    end
end
bind(RunService.Heartbeat,function()
    if not flags.murdererNotify then closeMurdNotif() return end
    local hrp=getHRP(LocalPlayer.Character)
    local m=findMurderer()
    local mh=(m and m~=LocalPlayer and alive(m)) and getHRP(m.Character) or nil
    if not (hrp and mh) then closeMurdNotif() return end
    local d=math.floor((mh.Position-hrp.Position).Magnitude)
    if d>MURD_ALERT_RANGE then
        if murdInRange then closeMurdNotif() end
        return
    end
    if not murdInRange then
        murdInRange=true
        murdNotif=Window:Notify({
            Title="Murderer Nearby",
            Content=(m.DisplayName or m.Name).."  ·  "..d.."m",
            Icon="triangle-alert",
            Duration=4,
        })
    end
end)

local GiveWeaponR=GameplayR:FindFirstChild("GiveWeapon")
if GiveWeaponR then bind(GiveWeaponR.OnClientEvent,function(w) if w=="Knife" or w=="Gun" then notify("You are the "..(w=="Knife" and "MURDERER" or "SHERIFF").."!",3) end end) end

do
    local function feedNotify(name,killType,role,color)
        local tag = role and (" ["..(role=="Murderer" and "M" or isGunRole(role) and "S" or "I").."]") or ""
        Window:Notify({Title="Kill Feed",Content=tostring(name)..tag.."  ·  "..tostring(killType or "Eliminated"),Duration=4,Color=color})
    end
    local recentKillEvent={}
    local KillEventR=GameplayR:FindFirstChild("KillEvent")
    if KillEventR then bind(KillEventR.OnClientEvent,function(victim,roleColor,_,killType)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        if not victim then return end
        local nm=tostring(victim)
        recentKillEvent[nm]=os.clock()
        if flags.killFeed then
            local p=Players:FindFirstChild(nm)
            feedNotify(nm,killType,p and roleOf(p) or nil,
                typeof(roleColor)=="Color3" and roleColor or nil)
        end
    end) end
    local lastDead={}
    local function scanDeaths()
        if not (CRC and CRC.PlayerData) then return end
        for name,d in pairs(CRC.PlayerData) do
            local dead = (d.Dead==true)
            local was = lastDead[name]
            if was==false and dead then
                local seen=recentKillEvent[name]
                if flags.killFeed and not (seen and os.clock()-seen<2) then
                    feedNotify(name,nil,d.Role)
                end
            end
            lastDead[name]=dead
        end
    end
    local function watchDeaths(plr)
        if plr==LocalPlayer then return end
        local function hookChar(ch)
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local c
            c=hum.Died:Connect(function()
                local nm=plr.Name
                local seen=recentKillEvent[nm]
                if flags.killFeed and not (seen and os.clock()-seen<2) then
                    recentKillEvent[nm]=os.clock()
                    feedNotify(plr.DisplayName or nm,nil,roleOf(plr))
                end
            end)
            table.insert(conns,c)
        end
        if plr.Character then hookChar(plr.Character) end
        table.insert(conns,plr.CharacterAdded:Connect(function(ch)
            task.defer(function() hookChar(ch) end)
        end))
    end
    for _,p in ipairs(Mono.plrs) do watchDeaths(p) end
    bind(Players.PlayerAdded,watchDeaths)
    local PlayerDataChangedR=GameplayR:FindFirstChild("PlayerDataChanged")
    if PlayerDataChangedR then bind(PlayerDataChangedR.OnClientEvent,function() task.defer(scanDeaths) end) end
    local RoundStartR=GameplayR:FindFirstChild("RoundStart")
    if RoundStartR then bind(RoundStartR.OnClientEvent,function()
        lastDead={}; recentKillEvent={}; coinBagFull=false
        task.defer(scanDeaths)
    end) end
    task.spawn(function() while not isDead() do
        if flags.killFeed then scanDeaths(); task.wait(0.2) else task.wait(0.75) end
    end end)
end

bind(TeleportService.TeleportInitFailed,function(_,_,_,_)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    local p=hopFallbackPlace
    if not p then return end
    hopFallbackPlace=nil
    notify("That server was full, letting Roblox pick one")
    pcall(function() TeleportService:Teleport(p,LocalPlayer) end)
end)
Mono.afkFires=0
bind(LocalPlayer.Idled,function()
    if not flags.antiAfk then return end
    if not VirtualUser then pcall(function() VirtualUser=game:GetService("VirtualUser") end) end
    if not VirtualUser then return end
    local ch=LocalPlayer.Character
    local armed=false
    if ch then
        for _,t in ipairs(ch:GetChildren()) do
            if t:IsA("Tool") then armed=true break end
        end
    end
    local ok=pcall(function()
        VirtualUser:CaptureController()
        if armed then
            VirtualUser:MoveMouse(Vector2.new(0,0))
            VirtualUser:MoveMouse(Vector2.new(2,2))
        else
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
    if not ok then return end
    Mono.afkFires=Mono.afkFires+1
    if Mono.afkFires==1 then notify("Anti AFK is working, you will not be kicked",4) end
end)

do
    local TrapSystem=RS:FindFirstChild("TrapSystem")
    local trapHls={}
    local function dropTrap(part)
        local h=trapHls[part]
        if h then pcall(function() h.hl:Destroy() end); pcall(function() h.bb:Destroy() end); trapHls[part]=nil end
    end
    local function addTrap(part)
        if trapHls[part] or not part:IsA("BasePart") then return end
        local hl=create("Highlight",{Name=rnd(),Adornee=part,FillColor=Color3.fromRGB(255,90,255),
            FillTransparency=0.4,OutlineColor=Color3.fromRGB(255,170,255),OutlineTransparency=0,
            DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Enabled=false,Parent=EspGui})
        local bb=create("BillboardGui",{Name=rnd(),Size=UDim2.fromOffset(90,16),AlwaysOnTop=true,
            StudsOffsetWorldSpace=Vector3.new(0,2,0),Adornee=part,Enabled=false,Parent=EspGui},
            {create("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Font=Enum.Font.GothamBold,
                TextSize=12,TextColor3=Color3.fromRGB(255,150,255),TextStrokeTransparency=.4,Text="TRAP"})})
        trapHls[part]={hl=hl,bb=bb}
    end
    for _,d in ipairs(workspace:GetDescendants()) do
        if d.Name=="TrapVisual" then addTrap(d) end
    end
    bind(workspace.DescendantAdded,function(d)
        if d.Name=="TrapVisual" then task.defer(addTrap,d) end
    end)
    bind(workspace.DescendantRemoving,function(d)
        if trapHls[d] then dropTrap(d) end
    end)
    task.spawn(function() while not isDead() do
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        for part,h in pairs(trapHls) do
            if not part.Parent then dropTrap(part)
            else
                h.hl.Enabled=flags.trapEsp
                h.bb.Enabled=flags.trapEsp
            end
        end
        task.wait(0.1)
    end end)

    if TrapSystem then
        local thl=TrapSystem:FindFirstChild("TrapHitLocal")
        if thl then
            bind(thl.OnClientEvent,function()
                if not flags.antiTrap then return end
                task.spawn(function()
                    local ch=LocalPlayer.Character
                    local hum=ch and ch:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    local want=16
                    pcall(function() want=tonumber(UI.walkSpeed) or 16 end)
                    local t0=os.clock()
                    while os.clock()-t0<4.6 do
                        if hum.Parent then
                            if hum.WalkSpeed<want then hum.WalkSpeed=want end
                            if hum.JumpPower<40 then hum.UseJumpPower=true; hum.JumpPower=50 end
                        end
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        end
    end
end
do
    local MAX_LINEAR=200
    local MAX_ANGULAR=20
    local ANCHOR_MIN=35
    local lastGood=nil
    local lastGoodAt=0
    local otherParts={}
    local flipped=setmetatable({},{__mode="k"})
    local nParts=0
    local function addPart(d)
        if d:IsA("BasePart") then
            nParts=nParts+1
            otherParts[nParts]=d
            if flags.antiFling and d.CanCollide then d.CanCollide=false; flipped[d]=true end
        end
    end
    local function restoreOthers()
        for d in pairs(flipped) do
            if d and d.Parent and d:IsA("BasePart") then d.CanCollide=true end
        end
        table.clear(flipped)
    end
    Mono.antiFlingRestore=restoreOthers
    local function hookChar(ch)
        if not ch then return end
        for _,d in ipairs(ch:GetDescendants()) do addPart(d) end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        bind(ch.DescendantAdded,function(d)
            if flags.antiFling then task.defer(addPart,d) end
        end)
    end
    local function rebuildOthers()
        table.clear(otherParts)
        nParts=0
        for _,p in ipairs(Mono.plrs) do
            if p~=LocalPlayer and p.Character then
                for _,d in ipairs(p.Character:GetDescendants()) do addPart(d) end
            end
        end
    end
    local function watch(p)
        if p==LocalPlayer then return end
        hookChar(p.Character)
        bind(p.CharacterAdded,function(ch) task.defer(function() hookChar(ch); rebuildOthers() end) end)
    end
    for _,p in ipairs(Mono.plrs) do watch(p) end
    bind(Players.PlayerAdded,function(p) watch(p); task.defer(rebuildOthers) end)
    bind(Players.PlayerRemoving,function() task.defer(rebuildOthers) end)
    task.spawn(function() while not isDead() do
        if flags.antiFling then rebuildOthers() end
        task.wait(3)
    end end)

    local function selfBusy()
        return flinging or flags.fly
    end
    local function guard()
        if not flags.antiFling or selfBusy() then return end
        local ch=LocalPlayer.Character
        local hrp=getHRP(ch)
        if not hrp then lastGood=nil return end

        if badCF(hrp.CFrame) then
            if lastGood then pcall(function() hrp.CFrame=lastGood end) end
            hrp.AssemblyLinearVelocity=Vector3.zero
            hrp.AssemblyAngularVelocity=Vector3.zero
            return
        end

        local lv=hrp.AssemblyLinearVelocity
        if badVec(lv) then hrp.AssemblyLinearVelocity=Vector3.zero
        elseif lv.Magnitude>MAX_LINEAR then hrp.AssemblyLinearVelocity=lv.Unit*MAX_LINEAR end
        local av=hrp.AssemblyAngularVelocity
        if badVec(av) or av.Magnitude>MAX_ANGULAR then hrp.AssemblyAngularVelocity=Vector3.zero end

        local hum0=ch:FindFirstChildOfClass("Humanoid")
        local maxRise=60
        if hum0 and hum0.UseJumpPower then maxRise=math.max(60,hum0.JumpPower*1.4) end
        local lv2=hrp.AssemblyLinearVelocity
        if (not flags.infJump) and lv2.Y>maxRise then
            hrp.AssemblyLinearVelocity=Vector3.new(lv2.X,maxRise,lv2.Z)
        end

        local cp=getCharParts(ch)
        for i=1,#cp do
            local p=cp[i]
            if p.Parent then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
                if badVec(p.AssemblyLinearVelocity) then p.AssemblyLinearVelocity=Vector3.zero end
                local pav=p.AssemblyAngularVelocity
                if badVec(pav) or pav.Magnitude>MAX_ANGULAR then p.AssemblyAngularVelocity=Vector3.zero end
                if badCF(p.CFrame) and lastGood then pcall(function() p.CFrame=lastGood end) end
            end
        end

        if not Mono.wantPS then
            if hum0 and hum0.PlatformStand then hum0.PlatformStand=false end
        end

        local now=os.clock()
        local exempt = Mono.teleporting() or Mono.selfTeleporting() or flags.autoCoins
        if lastGood and not exempt then
            local dt=math.clamp(now-lastGoodAt,1/240,0.5)
            local allow=math.max(ANCHOR_MIN,(MAX_LINEAR+100)*dt)
            if (hrp.Position-lastGood.Position).Magnitude>allow then
                pcall(function() hrp.CFrame=lastGood end)
                hrp.AssemblyLinearVelocity=Vector3.zero
                hrp.AssemblyAngularVelocity=Vector3.zero
                return
            end
        end
        lastGood=hrp.CFrame
        lastGoodAt=now
    end
    local function sweepCollide()
        if not flags.antiFling or flinging then return end
        for i=1,nParts do
            local d=otherParts[i]
            if d and d.Parent and d.CanCollide then d.CanCollide=false; flipped[d]=true end
        end
    end
    bind(RunService.Heartbeat,sweepCollide)
    bind(RunService.Stepped,guard)
    bind(RunService.Heartbeat,guard)
    bind(RunService.RenderStepped,guard)

    local MOVERS={"BodyVelocity","BodyAngularVelocity","BodyThrust","BodyForce","BodyPosition","BodyGyro",
        "LinearVelocity","AngularVelocity","VectorForce","Torque","AlignPosition","AlignOrientation",
        "RocketPropulsion"}
    local function isMover(d)
        for _,c in ipairs(MOVERS) do if d:IsA(c) then return true end end
        return false
    end
    local function killMover(d)
        if d==flyBV or d==flyBG or flags.fly or flinging then return end
        if d.Parent then pcall(function() d:Destroy() end) end
    end
    local function watchSelf(ch)
        if not ch then return end
        bind(ch.DescendantAdded,function(d)
            if not flags.antiFling or flags.fly then return end
            if not isMover(d) then return end
            task.defer(killMover,d)
        end)
    end
    task.spawn(function() while not isDead() do
        if flags.antiFling and not flags.fly and not flinging then
            local ch=LocalPlayer.Character
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            if ch then
                for _,d in ipairs(ch:GetDescendants()) do
                    if isMover(d) then killMover(d) end
                end
            end
        end
        task.wait(0.5)
    end end)
    watchSelf(LocalPlayer.Character)
    bind(LocalPlayer.CharacterAdded,watchSelf)
end

local Menu = MonoUI.new({
    Title = "Mono", Version = "v1", Width = 860, Height = 560,
    LogoUrl = "https://raw.githubusercontent.com/fleecewtf/MonoMM2/main/Mono%20MM2%20Logo.png",
    LogoCache = "Mono MM2/logo-mm2.png",
    LogoHeight = 46, LogoAspect = 3,
    LogoMarkRect = { 19, 88, 200, 141 },
})
Window = Menu

Menu:Tab("Modules"); Menu:Tab("Players"); Menu:Tab("Server"); Menu:Tab("Configs"); Menu:Tab("Settings"); Menu:Tab("Credits")

Menu:Category("Favorites", "star")
local Combat    = Menu:Category("Combat",    "crosshair")
local PlayerCat = Menu:Category("Player",    "user")
local Visuals   = Menu:Category("Visuals",   "eye")
local Teleport  = Menu:Category("Teleport",  "map-pin")
local Safety    = Menu:Category("Safety",    "shield")
local Utility   = Menu:Category("Utility",   "wrench")


Combat:Section("Murderer + Sheriff")
do
    local m = Combat:Module({ Name = "Auto Kill", Desc = "As murderer, knifes everyone still alive in the round. As sheriff, snap-shots the murderer", Callback = function(v) flags.autoKill=v end, Info = "As murderer, it knifes everyone still alive in the round at once, with no distance limit, so it ends the round instantly. Anyone already dead and sitting in the lobby is skipped. As sheriff or hero it snap-shots the murderer instead: it locks onto them at a fixed offset, rides along with them for a few frames so the server sees the two of you in the correct relative position, fires point blank and returns you. Riding along is what makes it land on someone running or jumping, because your position and theirs go stale together instead of separately. The server only accepts one gun shot every 3.2 seconds and silently discards anything sent sooner, so this waits that long between attempts." })
    m:Setting{ Type = "Slider", Title = "Snap Height", Min = 5, Max = 9, Default = 5, Callback = function(v) Mono.SNAP_HEIGHT=v end }
    m:Setting{ Type = "Label", Wrap = true, Text = "5 is the measured sweet spot and you should not need to change it. Over a logged sample every shot that landed came from between 2.3 and 2.75 studs of the target, and every shot outside that band missed on both sides. Closer than about 2.2 puts the muzzle inside their hitbox, where a ray that starts inside a part passes straight out without registering. The muzzle sits 3.45 studs ahead of you, so height 5 places it 2.44 studs away, in the middle of the band." }
    m:Setting{ Type = "Label", Wrap = true, Text = "Gun cooldown is fixed at 3.25s. The server only accepts one shot every 3.2s and silently throws away anything fired sooner, so there is no useful setting below that." }
end
do
    local m = Combat:Module({ Name = "Aimbot", Desc = "Snaps your camera to the closest enemy in your FOV", Hold = true, Callback = function(v) flags.aimbot=v end, Info = "Snaps your camera to the closest enemy inside the FOV circle. As murderer it tracks anyone, otherwise it tracks the murderer. Bind a key and it only aims while that key is held; leave it toggled on and it aims continuously. Adjust the radius with the FOV slider, and turn on Show FOV to see it." })
    m:Setting{ Type = "Slider", Title = "FOV", Min = 40, Max = 400, Default = 120, Callback = function(v) aimFov=v end }
end
do
    local m = Combat:Module({ Name = "Silent Aim", Desc = "Your shots and throws go to the closest player in your FOV", Callback = function(v) flags.silentAim=v end, Info = "Your shots and throws go to the closest player in your FOV. As murderer it redirects the knife where you threw it, and it keeps hold of whoever you picked for a moment so drifting off them during the throw's wind up does not lose the lock. As sheriff or hero, pulling the trigger locks onto whoever is in the circle and snap-shots them, since the gun is checked against your position. Set the radius with the Aimbot FOV slider." })
end
do
    local m = Combat:Module({ Name = "Show FOV Circle", Desc = "Draws the aim radius", Callback = function(v) flags.showFov=v end, Info = "Draws the aim radius. Only visible while an aim feature is on." })
end

Combat:Section("Sheriff")
do
    local m = Combat:Module({ Name = "Gun Through Walls", Desc = "Your shots ignore geometry", Callback = function(v) flags.gunWalls=v end, Info = "Your shots ignore geometry. Aim near a player rather than exactly at them - through a wall it falls back to whoever is closest inside the Aimbot FOV circle, since you cannot aim precisely at someone you cannot see. Does not shoot for you." })
end
do
    local m = Combat:Module({ Name = "Dropped Gun ESP", Desc = "Highlights the sheriff gun once it is on the ground", Callback = function(v) flags.gunEsp=v end, Info = "Highlights the sheriff gun once it is lying on the ground." })
end
do
    local m = Combat:Module({ Name = "Gun ESP Distance", Desc = "Adds a distance label to the dropped gun highlight", Callback = function(v) flags.gunEspDist=v end, Info = "Adds a distance label to the dropped gun highlight." })
end
do
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    local m = Combat:Module({ Name = "Auto Grab Gun", Desc = "Grabs the dropped gun the moment it appears, then returns you", Callback = function(v) flags.autoGun=v end, Info = "Grabs the dropped gun the moment it appears, then returns you." })
end
do
    local m = Combat:Module({ Name = "Grab Gun Now", Desc = "One-off grab of the dropped gun", Action = true, Callback = function()
        if findWeapon("Gun") then notify("You already have a gun"); return end
        if not (droppedGun or findDroppedGun()) then notify("No dropped gun on the map"); return end
        grabGunOnce()
    end, Info = "One-off grab of the dropped gun" })
end

Combat:Section("Murderer")
do
    local m = Combat:Module({ Name = "Knife Through Walls", Desc = "Your thrown knives ignore geometry", Callback = function(v) flags.knifeWalls=v end, Info = "Your thrown knives ignore geometry. Aim at a player or anywhere on the map. Does not throw for you." })
end
do
    local m = Combat:Module({ Name = "Instant Knife Throw", Desc = "Skips the wind up and the flight time so the knife lands at once", Callback = function(v) flags.instantKnife=v end, Info = "Skips the wind up and the flight time, so the knife lands the instant you press throw. Walls still block it unless Knife Through Walls is on." })
end

PlayerCat:Section("Movement")
do
    local m = PlayerCat:Module({ Name = "Fly", Desc = "Free movement in any direction", Callback = function(v) flags.fly=v; if v then startFly() else stopFly() end end, Info = "Free movement relative to your camera. On a keyboard use WASD with Space to rise and Ctrl to drop. On a touch screen use your normal movement stick, and the up and down buttons Mono adds to the side of the screen." })
    m:Setting{ Type = "Slider", Title = "Speed", Min = 20, Max = 250, Default = 60, Callback = function(v) flags.flySpeed=v end }
end
do
    local m = PlayerCat:Module({ Name = "Noclip", Desc = "Walk through walls", Callback = function(v) flags.noclip=v
        if not v then
            local ch=LocalPlayer.Character
            Mono.recollide(ch and ch:FindFirstChildOfClass("Humanoid"))
        end
    end, Info = "Walk through walls. Forced on during a fling, which needs it." })
end
do
    local m = PlayerCat:Module({ Name = "Infinite Jump", Desc = "Jump again any time, including mid-air", Callback = function(v) flags.infJump=v end, Info = "Jump again any time, including mid-air." })
end
do
    local m = PlayerCat:Module({ Name = "Unlock Camera", Desc = "Removes the zoom limit", Callback = function(v) flags.unlockCam=v; setUnlockCam(v) end, Info = "Removes the zoom limit. Combined with Noclip the camera also passes through walls." })
end

PlayerCat:Section("Stats")
do
    local m = PlayerCat:Module({ Name = "Reset Character", Desc = "Kills you so you respawn", Action = true, Callback = function()
        local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health=0 else notify("You have no character right now") end end, Info = "Kills you so you respawn" })
end

Visuals:Section("Player ESP")
do
    local m = Visuals:Module({ Name = "Nametag ESP", Desc = "Name, distance and round coins above each player", Callback = function(v) flags.espNames=v; if not v then pcall(Mono.setRobloxNames,false) end end, Info = "Name, distance and round coins above each player." })
end
do
    local m = Visuals:Module({ Name = "Box ESP", Desc = "2D rectangle around each player that tracks their pose", Callback = function(v) flags.espBox=v end, Info = "2D rectangle around each player that tracks their pose." })
end
do
    local m = Visuals:Module({ Name = "3D Box ESP", Desc = "Draws a box around each player in world space",
        Info = "A twelve-edge box fitted to the player's actual bounding box, so it turns with them and keeps true perspective at any distance.",
        Callback = function(v) flags.espBox3D=v end })
end
do
    local m = Visuals:Module({ Name = "Chams", Desc = "Colored through-wall outline on each player", Callback = function(v) flags.espChams=v end, Info = "Colored through-wall outline on each player, visible through geometry." })
    m:Setting{ Type = "Toggle", Title = "Fill Body", Default = false,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Callback = function(v) flags.espFill=v end }
end
do
    local m = Visuals:Module({ Name = "Role Tags", Desc = "Colors every ESP by role and shows [M] [S] [I] tags", Callback = function(v) flags.espRoleTags=v end, Info = "Colors every ESP by role and shows [M] [S] [I] tags." })
end
do
    local m = Visuals:Module({ Name = "Avatar Icons", Desc = "Shows each player's headshot on their nametag",
        Callback = function(v) flags.espAvatar=v end, Info = "Fetches the player's headshot thumbnail once and caches it on the nametag card." })
end
do
    local m = Visuals:Module({ Name = "Tracers", Desc = "Draws a line from your chosen origin to each player",
        Callback = function(v) flags.espTracers=v end, Info = "A thin line from your chosen origin to each player, colored by their role." })
    m:Setting{ Type = "Dropdown", Title = "Origin",
        Values = { "Bottom", "Bottom Left", "Bottom Right", "Center", "Top", "Mouse" },
        Default = "Bottom", Callback = function(v) flags.espTracerFrom=v end }
end
do
    local m = Visuals:Module({ Name = "ESP Distance Limit", Desc = "Hides nametags and tracers past a set range",
        Callback = function(v) flags.espMaxDist = v and (Mono.espLimit or 250) or 0 end, Info = "With this off every player is shown regardless of range." })
    m:Setting{ Type = "Slider", Title = "Max Distance", Min = 25, Max = 1000, Default = 250,
        Callback = function(v) Mono.espLimit = v; if m:Get() then flags.espMaxDist = v end end }
end
do
    local m = Visuals:Module({ Name = "Skeleton ESP", Desc = "Draws bone lines over each player", Callback = function(v) flags.espSkeleton=v end, Info = "Draws bone lines over each player." })
end

do
    local FS = { prints = {}, last = setmetatable({}, { __mode = "k" }),
                 side = setmetatable({}, { __mode = "k" }),
                 folder = nil, life = 8, at = 0,
                 ray = RaycastParams.new() }
    FS.ray.FilterType = Enum.RaycastFilterType.Exclude

    function FS.tint(role)
        if role == "Murderer" then return Color3.fromRGB(255, 80, 80) end
        if isGunRole(role) then return Color3.fromRGB(90, 150, 255) end
        return Color3.fromRGB(95, 225, 125)
    end
    function FS.clear()
        for i = #FS.prints, 1, -1 do
            local e = FS.prints[i]
            pcall(function() e.part:Destroy() end)
            if e.toe then pcall(function() e.toe:Destroy() end) end
            FS.prints[i] = nil
        end
        table.clear(FS.last); table.clear(FS.side)
        if FS.folder then pcall(function() FS.folder:Destroy() end); FS.folder = nil end
    end
    function FS.drop(cf, col)
        if #FS.prints >= 220 then
            local old = table.remove(FS.prints, 1)
            if old then
                pcall(function() old.part:Destroy() end)
                if old.toe then pcall(function() old.toe:Destroy() end) end
            end
        end
        if not (FS.folder and FS.folder.Parent) then
            FS.folder = create("Folder", { Name = rnd(), Parent = workspace })
        end
        local part = create("Part", { Name = rnd(), Anchored = true, CanCollide = false,
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            CanQuery = false, CanTouch = false, CastShadow = false,
            Size = Vector3.new(0.4, 0.07, 0.66), Material = Enum.Material.Neon,
            Color = col, Transparency = 0.15, CFrame = cf, Parent = FS.folder },
            { create("SpecialMesh", { MeshType = Enum.MeshType.Sphere }) })
        local toe = create("Part", { Name = rnd(), Anchored = true, CanCollide = false,
            CanQuery = false, CanTouch = false, CastShadow = false,
            Size = Vector3.new(0.26, 0.06, 0.2), Material = Enum.Material.Neon,
            Color = col, Transparency = 0.15,
            CFrame = cf * CFrame.new(0, 0, -0.46), Parent = FS.folder },
            { create("SpecialMesh", { MeshType = Enum.MeshType.Sphere }) })
        FS.prints[#FS.prints + 1] = { part = part, toe = toe, born = os.clock() }
    end

    bind(RunService.Heartbeat, function()
        if not flags.footsteps then
            if #FS.prints > 0 or FS.folder then FS.clear() end
            return
        end
        local now = os.clock()
        for i = #FS.prints, 1, -1 do
            local e = FS.prints[i]
            local age = now - e.born
            if age >= FS.life or not e.part.Parent then
                pcall(function() e.part:Destroy() end)
                if e.toe then pcall(function() e.toe:Destroy() end) end
                table.remove(FS.prints, i)
            else
                local t = 0.15 + 0.85 * (age / FS.life)
                e.part.Transparency = t
                if e.toe then e.toe.Transparency = t end
            end
        end
        if now - FS.at < 0.08 then return end
        FS.at = now
        local me = LocalPlayer.Character
        for _, plr in ipairs(Mono.plrs) do
            local ch, _, hrp = Mono.hasBody(plr)
            if (plr ~= LocalPlayer or flags.footMine) and ch then
                if hrp then
                    local pos = hrp.Position
                    local prev = FS.last[plr]
                    if not prev then
                        FS.last[plr] = pos
                    elseif (pos - prev).Magnitude >= 3.5 then
                        FS.last[plr] = pos
                        FS.ray.FilterDescendantsInstances = { ch, me, FS.folder }
                        local hit = workspace:Raycast(pos, Vector3.new(0, -8, 0), FS.ray)
                        if hit then
                            local n = hit.Normal
                            local travel = pos - prev
                            local look = (travel.Magnitude > 0.5) and travel.Unit or hrp.CFrame.LookVector
                            local fwd = look - n * look:Dot(n)
                            fwd = (fwd.Magnitude > 1e-3) and fwd.Unit or Vector3.new(0, 0, -1)
                            local side = fwd:Cross(n)
                            FS.side[plr] = not FS.side[plr]
                            local base = hit.Position + side * (FS.side[plr] and 0.3 or -0.3) + n * 0.045
                            FS.drop(CFrame.lookAt(base, base + fwd, n), FS.tint(Mono.espRole(plr)))
                        end
                    end
                end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            end
        end
    end)

    local m = Visuals:Module({ Name = "Footstep Trails",
        Desc = "Leaves a colored trail of footprints behind every player",
        Callback = function(v) flags.footsteps = v; if not v then FS.clear() end end,
        Info = "Leaves a trail of footprints behind every player, colored by role: red for the murderer, blue for the sheriff or hero, green for innocents. The game's own Footsteps perk is murderer only and shows innocents in one color, so this replaces it rather than revealing it. The prints are drawn on your machine only, so nobody else sees them." })
    m:Setting{ Type = "Slider", Title = "Trail Length", Min = 3, Max = 30, Default = 8,
        Format = function(v) return v .. "s" end,
        Callback = function(v) FS.life = v end }
    m:Setting{ Type = "Toggle", Title = "Include My Own", Default = false,
        Callback = function(v) flags.footMine = v end }
end

Visuals:Section("World & Render")
do
    local m = Visuals:Module({ Name = "Coin ESP", Desc = "Highlights every uncollected coin on the map", Callback = function(v) flags.coinEsp=v end, Info = "Highlights every uncollected coin on the map." })
end
do
    local m = Visuals:Module({ Name = "Trap ESP", Desc = "Untested. Shows the murderer's invisible traps through walls", Callback = function(v) flags.trapEsp=v end, Info = "Untested. Murderer traps turn up rarely enough that this has never been confirmed working, so it may not behave as intended. What it is meant to do: traps are invisible by design, and this draws them through walls so you can walk around them." })
end
do
    local m = Visuals:Module({ Name = "Kill Feed", Desc = "Notifies you of every elimination, in any role including innocent", Callback = function(v) flags.killFeed=v end, Info = "Notifies you of every elimination, in any role including innocent." })
end
do
    local m = Visuals:Module({ Name = "Fullbright", Desc = "Removes darkness so nowhere on the map is unlit", Callback = function(v) flags.fullbright=v; setFullbright(v) end, Info = "Removes darkness so nowhere on the map is unlit." })
end
do
    local m = Visuals:Module({ Name = "FPS Boost", Desc = "Strips textures, shadows, particles and post effects", Callback = function(v) flags.fpsBoost=v; setFPSBoost(v) end, Info = "Flattens every part to plain untextured plastic and removes shadows, particles, decals, sun rays, bloom and atmospheric haze, which is where most of the frame cost in a heavy map goes. It leaves your brightness alone, so if the map is dark it stays dark. Turn on Fullbright as well if you want it lit flat. Everything is reversed when you turn it off or unload." })
end

local function targetList()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then t[#t + 1] = p.Name end
    end
    if #t == 0 then t[1] = "(nobody else here)" end
    return t
end
local function targetSetting(m)
    m.tpTarget = nil
    m:Setting{ Type = "Dropdown", Title = "Target", GetValues = targetList,
        Callback = function(v) m.tpTarget = v end }
end
local function targetOf(m)
    return resolvePlayer(m and m.tpTarget) or resolvePlayer(UI.tpPlayer)
end


Teleport:Section("Player Actions")
do
    local m
    m = Teleport:Module({ Name = "Teleport To Player", Desc = "Drops you just above the selected player", Action = true, Callback = function()
        local p=targetOf(m)
        if not p then notify("Pick a player first"); return end
        local ch=p.Character; local h=ch and ch:FindFirstChildOfClass("Humanoid"); local root=(h and h.RootPart) or getHRP(ch)
        if not root then notify((p.DisplayName or p.Name).." is dead, no character to teleport to"); return end
        if tpTo(root.Position) then notify("Teleported to "..(p.DisplayName or p.Name))
        else notify("You have no character right now") end end, Info = "Drops you just above the selected player" })
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    targetSetting(m)
end
do
    local m
    m = Teleport:Module({ Name = "Fling Player", Desc = "Launches the selected player using physics", Action = true, Callback = function()
        local p=targetOf(m)
        if not p then notify("Pick a player first"); return end
        if not (p.Character and getHRP(p.Character)) then notify((p.DisplayName or p.Name).." is dead, nothing to fling"); return end
        notify("Flinging "..(p.DisplayName or p.Name))
        task.spawn(function()
            local ok,why=flingPlayer(p)
            if not ok and why then notify(why,4) end
        end) end, Info = "Launches the selected player using physics. You return to where you were." })
    targetSetting(m)
end
do
    local m
    m = Teleport:Module({ Name = "Loop Fling", Desc = "Keeps flinging the selected player over and over",
        Callback = function(v)
            if not v then return end
            task.spawn(function()
                local lastWhy
                while m:Get() and not isDead() do
                    local p = targetOf(m)
                    if not p then
                        notify("Pick a player first")
                        m:Toggle(false)
                        break
                    end
                    if Mono.hasBody(LocalPlayer) and p.Character and getHRP(p.Character)
                        and not Mono.alreadyFlung(p) and not flinging and not Mono.teleporting() then
                        local ok, why = flingPlayer(p)
                        if ok then
                            lastWhy = nil
                        elseif why and why ~= lastWhy then
                            lastWhy = why
                            notify(why, 3)
                        end
                    end
                    task.wait(0.4)
                end
            end)
        end,
        Info = "Keeps flinging one player for as long as this is on, waiting for them to land before going again. It skips them while they are already sailing through the air or heading for the void, so it will not follow them down." })
    targetSetting(m)
end
do
    local m = Teleport:Module({ Name = "Fling All Players", Desc = "Flings everyone in the server one after another, then puts you back", Action = true, Callback = flingAll, Info = "Flings everyone in the server one after another, then puts you back" })
end
do
    local m = Teleport:Module({ Name = "Auto Fling Murderer", Desc = "Flings the murderer on sight, over and over, for as long as this is on", Callback = function(v) flags.autoFlingMurderer=v end, Info = "Flings the murderer on sight, over and over, for as long as this is on." })
end
do
    local m = Teleport:Module({ Name = "Auto Fling Sheriff", Desc = "Flings the sheriff on sight, over and over, for as long as this is on", Callback = function(v) flags.autoFlingSheriff=v end, Info = "Flings whoever is holding the gun, sheriff or hero, on sight, over and over, for as long as this is on." })
end

Teleport:Section("Coins")
do
    local m = Teleport:Module({ Name = "Auto Collect Coins", Desc = "Walks you coin to coin at normal speed", Callback = function(v) flags.autoCoins=v; if v then if coinBagFull then notify("Coin bag is already full") else notify("Auto collect on") end end end, Info = "Walks you coin to coin at normal speed. Idles while you are dead, in the lobby, or when no coins are out, and stops on its own when your bag is full." })
end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
do
    local m = Teleport:Module({ Name = "Teleport To Nearest Coin", Desc = "One hop to the closest uncollected coin", Action = true, Callback = function()
        local hrp=getHRP(LocalPlayer.Character)
        if not hrp then notify("You have no character right now"); return end
        local pool=coinCache
        if #pool==0 then pool=freshCoins() end
        local best,bd
        for _,c in ipairs(pool) do
            if c.Parent and not coinTaken(c) then
                local d=(c.Position-hrp.Position).Magnitude
                if not bd or d<bd then bd,best=d,c end
            end
        end
        if not best then notify("No coins on map"); return end
        if tpTo(best.Position) then notify("Teleported to coin") else notify("You have no character right now") end end, Info = "One hop to the closest uncollected coin" })
end

Safety:Section("Protection")
do
    local m = Safety:Module({ Name = "Anti Fling", Desc = "Blocks other exploiters from flinging you", Callback = function(v) flags.antiFling=v
        if not v and Mono.antiFlingRestore then Mono.antiFlingRestore() end
    end, Info = "Blocks other exploiters from flinging you. It works two ways: it turns off collision on everyone else so they cannot shove you, and it anchors you back if something throws you further than you could physically travel. The collision half keeps running even while you fly. The anchor half stands down while the game teleports you between rounds, while Auto Collect Coins is moving you, and briefly after Mono teleports you itself, since it cannot tell those apart from an attack." })
end
do
    local m = Safety:Module({ Name = "Anti Trap", Desc = "Untested. Keeps your speed when you walk into a murderer trap", Callback = function(v) flags.antiTrap=v end, Info = "Untested. Murderer traps turn up rarely enough that this has never been confirmed working, so it may not behave as intended. What it is meant to do: cancel the slow when you walk into a trap, so you keep full speed." })
end

Safety:Section("Awareness")
do
    local m = Safety:Module({ Name = "Murderer Notify", Desc = "Warns you when the murderer comes within 50 studs", Callback = function(v) flags.murdererNotify=v end, Info = "Pops a warning the moment the murderer gets within 50 studs of you, with their name and how far away they were. It fires once per approach and only re-arms after they leave that range again, so it will not spam you while they are nearby." })
end
do
    local m = Safety:Module({ Name = "Anti AFK", Desc = "Stops the 20 minute idle kick", Callback = function(v) flags.antiAfk=v end, Info = "Stops the 20 minute idle kick. Roblox tells the game you have gone idle about every two minutes, and Mono answers with a fake input that resets the timer, so you are never kicked. It notifies you the first time it fires so you know it is alive, then stays quiet. While you are holding a weapon it nudges the mouse instead of right clicking, so it can never throw your knife while you are away." })
end

Utility:Section("Actions")
do
    Mono.origFps = (function()
        local ok, v = pcall(function()
            return UserSettings():GetService("UserGameSettings").FramerateCap
        end)
        if ok and type(v) == "number" and v >= 0 then return math.floor(v + 0.5) end
        if typeof(getfpscap) == "function" then
            local ok2, v2 = pcall(getfpscap)
            if ok2 and type(v2) == "number" and v2 >= 0 then return math.floor(v2 + 0.5) end
        end
        return nil
    end)()
    if Mono.origFps == nil then
        Mono.origFps = 0
        Fallback.note("FPS Cap", "release to unlimited",
            "neither your executor nor Roblox would report your current frame cap, so turning the cap back off releases it entirely instead of restoring your own limit",
            {"FPS Cap"})
    end
    local value = 60
    local function apply(v)
        if typeof(setfpscap) ~= "function" then return end
        pcall(setfpscap, v)
    end
    local m = Utility:Module({ Name = "FPS Cap", Desc = "Limits your frame rate to save battery and heat",
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        Callback = function(on) apply(on and value or (Mono.origFps or 0)) end,
        Info = "Limits your frame rate. Worth having on a phone or a weak laptop, where an uncapped frame rate is what makes the device run hot and drain the battery. Set the slider to 0 for unlimited. The lowest real cap is 5, because anything under that leaves the game unplayable. Turning it off puts you back on whatever cap you had before Mono loaded, not on unlimited." })
    m:Setting{ Type = "Slider", Title = "FPS Limit", Min = 0, Max = 360, Default = 60,
        Adjust = function(v) if v > 0 and v < 5 then return 5 end return v end,
        Format = function(v) return v == 0 and "Unlimited" or tostring(v) end,
        Callback = function(v) value = v; if m:Get() then apply(v) end end }
    m:Setting{ Type = "Label", Text = "0 = unlimited. The lowest cap you can set is 5, so you cannot make the game unplayable by accident.", Wrap = true }
    if typeof(setfpscap) ~= "function" then
        Fallback.note("FPS Cap","no cap control",
            "your executor has no setfpscap, so the frame rate cannot be limited at all",
            {"FPS Cap"})
    end
end
do
    local m = Utility:Module({ Name = "Rejoin", Desc = "Rejoins this same server", Action = true, Callback = rejoin, Info = "Rejoins this same server" })
end
do
    local m = Utility:Module({ Name = "Server Hop", Desc = "Joins the busiest server that still has room", Action = true, Callback = serverHop, Info = "Joins the busiest server that still has room for you, never the one you are already in. If that server fills up before you arrive it moves on to the next one." })
end

do
    local value = 16
    local apply = function(v) UI.walkSpeed=v; local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=v end end
    local m = PlayerCat:Module({ Name = "Walk Speed", Desc = "Sets how fast you run", Callback = function(on)
        apply(on and value or 16)
    end, Info = "Sets how fast you run. The default is 16. Going well above that is an easy way to get kicked, so raise it gently." })
    m:Setting{ Type = "Slider", Title = "Walk Speed", Min = 16, Max = 120, Default = 16,
        Callback = function(v) value = v; if m:Get() then apply(v) end end }
end
do
    local value = 50
    local apply = function(v) local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if h then h.UseJumpPower=true;h.JumpPower=v end end
    local m = PlayerCat:Module({ Name = "Jump Power", Desc = "Raises how high you jump", Callback = function(on)
        apply(on and value or 50)
    end, Info = "Raises how high you jump. The default is 50. Large values are very obvious to other players, so raise it gently." })
    m:Setting{ Type = "Slider", Title = "Jump Power", Min = 50, Max = 250, Default = 50,
        Callback = function(v) value = v; if m:Get() then apply(v) end end }
end
do
    local value = 70
    local apply = function(v) pcall(function() Camera.FieldOfView=v end) end
    local m = Visuals:Module({ Name = "Field of View", Desc = "Widens the camera so you see more around you", Callback = function(on)
        apply(on and value or 70)
    end, Info = "Widens the camera so you see more around you. The default is 70. This only changes what you see, never what the server knows." })
    m:Setting{ Type = "Slider", Title = "Field of View", Min = 70, Max = 120, Default = 70,
        Callback = function(v) value = v; if m:Get() then apply(v) end end }
end


Menu.TargetChanged = function(name, on)
    UI.tpPlayer = on and name or nil
end

Menu.DetailExtra = function(p)
    local rd = roundData(p)
    return {
        { Section = "MM2", Rows = {
            { "Role",     roleOf(p) .. ((rd and rd.Dead) and "  (dead)" or "") },
            { "Level",    tostring(p:GetAttribute("Level") or "?") },
            { "Prestige", tostring(p:GetAttribute("Prestige") or "?") },
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            { "XP",       tostring(p:GetAttribute("XP") or "?") },
            { "Perk",     tostring((rd and rd.Perk) or p:GetAttribute("EquippedPerk") or "?") },
            { "Knife",    tostring(p:GetAttribute("EquippedKnife") or "?"), true },
            { "Gun",      tostring(p:GetAttribute("EquippedGun") or "?"), true },
        } },
    }
end

Menu.onDestroy = function()
    Unloaded = true
    if GENV and GENV.MONO_Unload then pcall(GENV.MONO_Unload) return end
    pcall(function() for _, c in ipairs(conns) do c:Disconnect() end end)
    table.clear(conns)
    pcall(function() Mono.clearDrawn() end)
end

Mono.requestUnload = function()
    Menu:Confirm({
        Title = "Unload Mono?",
        Body = "This turns every feature off, puts your walk speed, jump power, camera and lighting back the way they were, and removes every trace of Mono from the game. You can run the script again any time.",
        ConfirmText = "Unload Mono",
        CancelText = "Cancel",
        OnConfirm = function() Menu:Destroy() end,
    })
end
Menu.onCloseRequest = Mono.requestUnload

pcall(function()
    if not GENV then return end
    GENV.MONO_Unload = function()
        if Mono.unloading then return end
        Mono.unloading = true
        pcall(function()
            for _, m in ipairs(Menu.allModules) do
                if not m.action and m.state then pcall(function() m:Toggle(false) end) end
            end
        end)
        task.wait()
        task.wait()
        Unloaded = true
        pcall(function() Mono.setRobloxNames(false) end)
        pcall(function() setCamThruWalls(false) end)
        pcall(function() setUnlockCam(false) end)
        pcall(function() stopFly() end)
        pcall(function() setFullbright(false) end)
        pcall(function() setFPSBoost(false) end)
        pcall(function() if Mono.antiFlingRestore then Mono.antiFlingRestore() end end)
        pcall(function()
            local ch = LocalPlayer.Character
            Mono.recollide(ch and ch:FindFirstChildOfClass("Humanoid"), true)
        end)
        pcall(function() for _, c in ipairs(conns) do c:Disconnect() end end)
        table.clear(conns)
        pcall(function() Mono.clearDrawn() end)
        pcall(function() if typeof(cleardrawcache) == "function" then cleardrawcache() end end)
        pcall(function() if Menu._releaseWheel then Menu._releaseWheel() end end)
        pcall(function() game:GetService("ContextActionService"):UnbindAction("MonoWheelSink") end)
        pcall(function() if GENV.MONOUI_CLEANUP then GENV.MONOUI_CLEANUP() end end)
        pcall(function() if GENV.__mono_gui then GENV.__mono_gui:Destroy() end end)
        pcall(function() for _, g in ipairs(TRACKED) do pcall(function() g:Destroy() end) end end)
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        table.clear(TRACKED)
        GENV.MONO_Unload = nil
        GENV.MONOUI = nil
        GENV.__mono_gui = nil
        GENV.MONOUI_CLEANUP = nil
        GENV.MONO_GUIS = nil
    end
end)

Mono.menuKey = "RightShift"
Mono.keyPretty = {
    RightShift = "Right Shift", LeftShift = "Left Shift",
    RightControl = "Right Ctrl", LeftControl = "Left Ctrl",
    RightAlt = "Right Alt", LeftAlt = "Left Alt",
    MouseButton1 = "Left Click", MouseButton2 = "Right Click", MouseButton3 = "Middle Click",
}
function Mono.keyName()
    local n = Mono.menuKey
    if not n then return "no key" end
    return Mono.keyPretty[n] or n
end
do
    bind(UserInputService.InputBegan, function(i, gp)
        if gp or isDead() then return end
        if Mono.menuKey and i.KeyCode.Name == Mono.menuKey then
            if Menu.minimized then Menu:Restore() else Menu:Minimize() end
        end
    end)
    table.insert(Menu.uiSettings, { Type = "Section", Text = "MENU" })
    table.insert(Menu.uiSettings, { Type = "Keybind", Title = "Menu Toggle Key",
        Default = "RightShift",
        Callback = function(v)
            Mono.menuKey = v
            if Mono.onMenuKey then pcall(Mono.onMenuKey) end
        end })
end

do
    Mono.DIR = "Mono MM2"
    Mono.STATE = Mono.DIR .. "/settings.txt"

    function Mono.ensureFolder()
        if typeof(makefolder) ~= "function" or typeof(isfolder) ~= "function" then return false end
        local ok = pcall(function()
            if not isfolder(Mono.DIR) then makefolder(Mono.DIR) end
            if not isfolder(Mono.DIR .. "/configs") then makefolder(Mono.DIR .. "/configs") end
        end)
        if not ok then return false end
        local ok2, there = pcall(isfolder, Mono.DIR)
        return ok2 and there == true
    end

    function Mono.readState()
        if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then return nil end
        local okf, there = pcall(isfile, Mono.STATE)
        if not (okf and there) then return nil end
        local ok, raw = pcall(readfile, Mono.STATE)
        if not (ok and type(raw) == "string") then return nil end
        return raw:lower():match("tutorial_completed%s*=%s*(%a+)") == "true"
    end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece

    function Mono.writeState(done)
        if typeof(writefile) ~= "function" then return false end
        return (pcall(writefile, Mono.STATE,
            "tutorial_completed = " .. (done and "true" or "false") .. "\n"))
    end

    do
        local folderOk = Mono.ensureFolder()
        local state = folderOk and Mono.readState() or nil
        if folderOk and state == nil then
            if Mono.writeState(false) then state = false end
        end
        Mono.fileOk = folderOk and state ~= nil
        Mono.tutorialDone = (state == true)
        if not Mono.fileOk then
            Fallback.note("First run tutorial", "always on",
                "Mono could not create its " .. Mono.DIR .. " folder or the settings file inside it, "
                .. "which usually means the executor is missing makefolder or writefile, so nothing can "
                .. "remember that you already finished the tutorial and it will run on every execution",
                { "the tutorial", "Configs", "Auto Save Toggles" })
        end
    end

    local function firstRun()
        return not Mono.tutorialDone
    end

    local function catButton(name)
        for _, c in ipairs(Menu.categories) do
            if c.name == name then return c.button end
        end
    end
    local function moduleRow(name)
        for _, m in ipairs(Menu.allModules) do
            if m.name == name then return m.row end
        end
    end
    local function moduleBit(name, kind)
        for _, m in ipairs(Menu.allModules) do
            if m.name == name then
                if kind == "chip" then return m.chip end
                if kind == "star" then return m.starImg and m.starImg.Parent end
                return m.row
            end
        end
    end
    local function iconAt(row, i)
        if not row then return nil end
        local b = {}
        for _, c in ipairs(row:GetChildren()) do if c:IsA("TextButton") then b[#b + 1] = c end end
        table.sort(b, function(x, y) return x.LayoutOrder < y.LayoutOrder end)
        return b[i]
    end
    local function topIconAt(i) return iconAt(Menu.midIcons, i) end
    local function winIconAt(i) return iconAt(Menu.winIcons, i) end
    local function tabButton(name)
        for _, t in ipairs(Menu.tabs) do
            if t.name == name then return t.button end
        end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
    end

    Menu:AddTourStep({ Title = "Welcome to Mono",
        Body = "A quick tour of the menu. You can skip at any point, and reopen this from Utility.",
        Target = nil })
    Menu:AddTourStep({ Title = "Categories",
        Body = "Features are grouped here. Combat, Player, Visuals, Teleport, Safety and Utility.",
        Target = function() return catButton("Combat") end })
    Menu:AddTourStep({ Title = "Turn a feature on",
        Body = "Click anywhere on a row to toggle it, not just the switch on the right.",
        Before = function() local c = catButton("Combat") if c then Menu:SelectCategory(Menu.categories[2]) end end,
        Target = function() return moduleRow("Auto Kill") end })
    Menu:AddTourStep({ Title = "Keybinds",
        Body = "Click the key chip, then press any key to bind it. Right click the chip to clear it.",
        Target = function() return moduleBit("Auto Kill", "chip") end })
    Menu:AddTourStep({ Title = "Per-feature settings",
        Body = "The three dots open that feature's own options, plus its full description.",
        Target = function()
            local m = moduleRow("Auto Kill")
            if not m then return end
            for _, c in ipairs(m:GetChildren()) do
                if c:IsA("TextButton") and c.AbsoluteSize.X <= 40
                    and c.AbsolutePosition.X > m.AbsolutePosition.X + m.AbsoluteSize.X - 44 then return c end
            end
            return m
        end })
    Menu:AddTourStep({ Title = "Favorites",
        Body = "Star a feature and it appears in a Favorites category at the top.",
        Target = function() return moduleBit("Auto Kill", "star") end })
    Menu:AddTourStep({ Title = "Refresh",
        Body = "Reloads whichever tab you are on. On Modules it also clears the search box.",
        Target = function() return topIconAt(1) end })
    Menu:AddTourStep({ Title = "Compact mode",
        Body = "Shrinks the rows and hides the sidebar. Sweep your mouse to the left edge to bring it back.",
        Target = function() return topIconAt(2) end })
    Menu:AddTourStep({ Title = "Settings",
        Body = "Accent color, font, text size, layout, opacity and window size all live in this tab.",
        Target = function() return tabButton("Settings") end })
    Menu:AddTourStep({ Title = "Minimize",
        Body = "Collapses the menu to a small M badge. Drag it anywhere, click it to reopen.",
        Target = function() return winIconAt(1) end })
    Menu:AddTourStep({ Title = "Fullscreen",
        Body = "Fills the screen. Press again to go back to the windowed size.",
        Target = function() return winIconAt(2) end })
    Menu:AddTourStep({ Title = "Close",
        Body = "Unloads Mono completely, turning every feature off and undoing its changes.",
        Target = function() return winIconAt(3) end })
    Menu:AddTourStep({ Title = "That's it",
        Body = Mono.keyName() .. " hides and shows the menu, and you can change that key in Settings. Have fun.",
        Target = nil })

    if typeof(writefile)~="function" or typeof(readfile)~="function" or typeof(listfiles)~="function" then
        Fallback.note("Saved settings","memory only",
            "your executor cannot write files, so anything you set lives only until you leave",
            {"Configs","Auto Save Toggles","the first-run tour will replay every time"})
    end

    local AS = { path = Mono.DIR .. "/autosave.json", on = false, pending = false }
    function AS.write(now)
        if not AS.on then return end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
        if now then
            AS.pending = false
            pcall(function() writefile(AS.path, HttpService:JSONEncode(Menu:GetConfig())) end)
            return
        end
        if AS.pending then return end
        AS.pending = true
        task.delay(0.4, function()
            AS.pending = false
            if not AS.on then return end
            pcall(function() writefile(AS.path, HttpService:JSONEncode(Menu:GetConfig())) end)
        end)
    end
    function AS.load()
        local ok, raw = pcall(readfile, AS.path)
        if not ok or not raw then return false end
        local okd, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not okd then return false end
        Menu:LoadConfig(data)
        return true
    end

    function AS.clear()
        if typeof(delfile) ~= "function" then return false end
        if typeof(isfile) == "function" then
            local ok, there = pcall(isfile, AS.path)
            if not (ok and there) then return false end
        end
        return (pcall(delfile, AS.path))
    end

    Menu.onStateChanged = function() AS.write() end

    table.insert(Menu.uiSettings, { Type = "Toggle", Title = "Auto Save Toggles", Default = false,
        Info = "saving",
        Callback = function(v)
            AS.on = v
            if v then
                AS.write(true)
                notify("Auto save on. Your toggles are saved as you change them", 3)
            else
                AS.clear()
                notify("Auto save off. The saved toggles have been deleted", 3)
            end
        end })
    local function execName()
        local name
        if typeof(identifyexecutor)=="function" then
            local ok,a,b=pcall(identifyexecutor)
            if ok and type(a)=="string" and a~="" then
                name=a
                if type(b)=="string" and b~="" then name=name.." "..b end
            end
        end
        if not name and typeof(getexecutorname)=="function" then
            local ok,a=pcall(getexecutorname)
            if ok and type(a)=="string" and a~="" then name=a end
        end
        return name or "unknown"
    end
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece

    local function showCompat()
        local body=Fallback.text()
        local tag="\n\nDetected executor: "..execName()
        if not body then
            Menu:Notify({ Title = "Compatibility", Duration = 6,
                Content = "Everything Mono needs is available on your executor. No features are running in a reduced mode."..tag })
            return
        end
        Menu:Notify({ Title = "Some features are running reduced", Duration = 18,
            Content = "Your executor is missing something Mono normally uses, so it fell back to a weaker method. "
                .. "This is usually a limited or outdated executor rather than anything you did.\n\n"
                .. body .. "\n\nEverything still works, it is just louder or less reliable. "
                .. "You can re-read this any time from Settings."..tag })
    end
    Mono.showCompat = showCompat

    table.insert(Menu.uiSettings, { Type = "Section", Text = "RESET" })
    table.insert(Menu.uiSettings, { Type = "Button", Title = "Clear All Keybinds",
        Callback = function()
            for _, mm in ipairs(Menu.allModules) do mm:SetBind(nil) end
            notify("Every keybind cleared", 3)
        end })
    table.insert(Menu.uiSettings, { Type = "Button", Title = "Unfavorite All",
        Callback = function()
            for _, mm in ipairs(Menu.allModules) do mm:SetFavorite(false) end
        end })
    table.insert(Menu.uiSettings, { Type = "Button", Title = "Reset All Settings",
        Callback = function()
            Menu:Confirm({
                Title = "Reset all settings?",
                Body = "Every appearance, layout and behavior setting goes back to how it was when Mono first loaded. Your keybinds, favorites, saved configs and which features are turned on are all left alone.",
                ConfirmText = "Reset",
                CancelText = "Cancel",
                OnConfirm = function()
                    Menu:ResetSettings()
                    notify("Settings reset to default", 3)
                end,
            })
        end })

    table.insert(Menu.uiSettings, { Type = "Section", Text = "ACTIONS" })
    table.insert(Menu.uiSettings, { Type = "Button", Title = "Compatibility Report",
        Callback = function() Menu:CloseDrawer(); task.delay(0.25, showCompat) end })
    table.insert(Menu.uiSettings, { Type = "Button", Title = "Replay Tour",
        Callback = function()
            Menu:CloseDrawer()
            for _, t in ipairs(Menu.tabs) do
                if t.name == "Modules" then Menu:SelectTab(t) break end
            end
            task.delay(0.4, function() Menu:StartTour() end)
        end })
    table.insert(Menu.uiSettings, { Type = "Button", Title = "Unload Mono",
        Callback = function() Menu:CloseDrawer(); task.delay(0.28, Mono.requestUnload) end })

    task.delay(1.2, function()
        local okf, there = pcall(function()
            return typeof(isfile) == "function" and isfile(AS.path) == true
        end)
        if okf and there then
-- Script and UI originally created by and uploaded by https://robloxscripts.com/user/Fleece
            for _, cfg in ipairs(Menu.uiSettings) do
                if cfg.Title == "Auto Save Toggles" then cfg.Value = true end
            end
            AS.on = true
            if AS.load() then notify("Restored your saved toggles", 3) end
        end
    end)

    Menu.onTourEnd = function()
        Mono.tutorialDone = true
        Mono.writeState(true)
    end

    if firstRun() then
        task.delay(0.9, function() Menu:StartTour() end)
    else
        Mono.greet = notify("Mono loaded  " .. Mono.keyName() .. " to hide", 4)
        Mono.onMenuKey = function()
            local g = Mono.greet
            if g and g.SetContent then
                pcall(function() g:SetContent("Mono loaded  " .. Mono.keyName() .. " to hide") end)
            end
        end
    end
    if Fallback.n > 0 then
        task.delay(2.4, function() if Mono.showCompat then Mono.showCompat() end end)
    end
end

task.delay(0.25, function()
    if Unloaded then return end
    pcall(function() Menu:Refresh(false) end)
    pcall(function() Menu:Present() end)
end)
