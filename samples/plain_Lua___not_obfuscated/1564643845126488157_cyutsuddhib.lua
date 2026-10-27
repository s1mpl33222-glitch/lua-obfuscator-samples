
--[[ Cyutsud hub ]]

local function _try(fn, ...)
    local ok, err = pcall(fn, ...)
    return ok, err
end

_try(function() if setthreadidentity then setthreadidentity(8) end end)
_try(function() if setidentity then setidentity(8) end end)
_try(function() if set_thread_identity then set_thread_identity(8) end end)
_try(function() if syn and syn.set_thread_identity then syn.set_thread_identity(8) end end)
_try(function() if setthreadcontext then setthreadcontext(8) end end)
_try(function() if setcontext then setcontext(8) end end)
_try(function() if set_thread_capability then set_thread_capability("Plugin") end end)
_try(function() if setthreadcapability then setthreadcapability("Plugin") end end)

if type(cloneref) ~= "function" then
    local _cr = rawget(getfenv(), "cloneref")
        or rawget(getfenv(), "clonereference")
        or (syn and syn.cloneref)
        or (getrenv and getrenv().cloneref)
    if type(_cr) == "function" then
        cloneref = _cr
    else
        cloneref = function(o) return o end
    end
end

do
    local _origGetService = game.GetService
    local _safeGetService = function(self, name)
        local ok, svc = pcall(_origGetService, self, name)
        if ok then return svc end
        task.wait()
        return _origGetService(self, name)
    end
    _G.__SafeGetService = _safeGetService
end

pcall(function()
    if type(setfpscap) == "function" then
        setfpscap(9999)
    end
end)

----------------------------------------------------------------
-- Patch PlotClient / NumberUtils nil errors
-- NumberUtils.ToString → math.abs(nil)  |  UpdateClaim mul on nil
----------------------------------------------------------------
pcall(function()
    local _abs = math.abs
    math.abs = function(x)
        if type(x) ~= "number" then
            x = tonumber(x)
        end
        if type(x) ~= "number" then
            return 0
        end
        return _abs(x)
    end
end)

pcall(function()
    local function patchNumberUtils(mod)
        if type(mod) ~= "table" then return end
        for _, key in ipairs({ "ToString", "toString", "Format", "format", "Abbreviate", "abbreviate" }) do
            local fn = mod[key]
            if type(fn) == "function" then
                mod[key] = function(n, ...)
                    if n == nil then n = 0 end
                    if type(n) ~= "number" then
                        n = tonumber(n) or 0
                    end
                    return fn(n, ...)
                end
            end
        end
    end

    local rs = game:GetService("ReplicatedStorage")
    local utils = rs:FindFirstChild("Utils")
    local nu = utils and utils:FindFirstChild("NumberUtils")
    if nu then
        local ok, mod = pcall(require, nu)
        if ok then patchNumberUtils(mod) end
    end
    -- also try Packages path variants
    pcall(function()
        local ok, mod = pcall(function()
            return require(rs:WaitForChild("Utils"):WaitForChild("NumberUtils"))
        end)
        if ok then patchNumberUtils(mod) end
    end)
end)

-- Soft-sanitize Claim values so PlotClient UpdateClaim does not mul nil
pcall(function()
    local function sanitizeClaim(inst)
        if not inst then return end
        pcall(function()
            for _, attr in ipairs({
                "Generation", "generation", "Income", "Gen",
                "BaseGeneration", "BaseIncome", "Claim", "Money",
                "Rate", "Multiplier", "Offline", "Time",
            }) do
                local ok, v = pcall(function() return inst:GetAttribute(attr) end)
                if ok and v == nil then
                    -- leave unset
                elseif ok and type(v) ~= "number" and v ~= nil then
                    local n = tonumber(v)
                    if n then
                        pcall(function() inst:SetAttribute(attr, n) end)
                    end
                end
            end
            for _, ch in ipairs(inst:GetChildren()) do
                if ch:IsA("NumberValue") or ch:IsA("IntValue") or ch:IsA("NumberConstraint") then
                    if ch.Value == nil then
                        pcall(function() ch.Value = 0 end)
                    end
                end
            end
        end)
    end

    local function scanPlots()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local claim = pod:FindFirstChild("Claim")
                    if claim then sanitizeClaim(claim) end
                    sanitizeClaim(pod)
                end
            end
        end
    end

    task.spawn(function()
        for _ = 1, 8 do
            task.wait(0.5)
            pcall(scanPlots)
        end
        -- light periodic pass (cheap)
        while not rawget(_G, "_FH_SHUTDOWN") do
            task.wait(5)
            pcall(scanPlots)
        end
    end)
end)

local _cloneref_safe = (type(cloneref) == "function") and cloneref or function(o) return o end
Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return _cloneref_safe(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

task.spawn(function()
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService       = game:GetService("RunService")
    local Players          = game:GetService("Players")
    local HttpService      = game:GetService("HttpService")
    local GuiService       = game:GetService("GuiService")

    local LPH_NO_VIRTUALIZE = function(f) return f end

    if not Players.LocalPlayer then
        local _t1 = tick()
        repeat task.wait(0.05) until Players.LocalPlayer or (tick() - _t1 > 5)
    end
    do
        local lp = Players.LocalPlayer
        if lp and not lp:FindFirstChildOfClass("PlayerGui") then
            lp:WaitForChild("PlayerGui", 5)
        end
    end

    _G._FH_CYUTSUD_GEN = (_G._FH_CYUTSUD_GEN or 0) + 1
    local _GEN = _G._FH_CYUTSUD_GEN
    _G._FH_SHUTDOWN = false
    _G._FH_SHUTDOWN_DONE = false

    local function _isShuttingDown()
        if _G._FH_SHUTDOWN then return true end
        if _GEN ~= _G._FH_CYUTSUD_GEN then return true end
        local lp = Players.LocalPlayer
        if not lp or lp.Parent == nil then return true end
        return false
    end
    _G._FH_IS_SHUTDOWN = _isShuttingDown
    _G._FH_TEARDOWN = {}

    local function _doTeardown()
        if _G._FH_SHUTDOWN_DONE then return end
        _G._FH_SHUTDOWN_DONE = true
        _G._FH_SHUTDOWN = true
        for _, fn in ipairs(_G._FH_TEARDOWN) do
            pcall(fn)
        end
    end

    pcall(function()
        local lp = Players.LocalPlayer
        if lp then
            lp.AncestryChanged:Connect(function(_, parent)
                if parent == nil then _doTeardown() end
            end)
        end
    end)
    pcall(function()
        Players.PlayerRemoving:Connect(function(p)
            if p == Players.LocalPlayer then _doTeardown() end
        end)
    end)
    pcall(function()
        game:BindToClose(function() _doTeardown() end)
    end)

    pcall(function()
        local seen = {}
        local function purge(parent)
            if not parent or seen[parent] then return end
            seen[parent] = true
            for _, ch in ipairs(parent:GetChildren()) do
                if ch:IsA("ScreenGui") and ch.Name == "CyutsudHub" then
                    pcall(function() ch:Destroy() end)
                end
            end
        end
        if typeof(gethui) == "function" then pcall(function() purge(gethui()) end) end
        pcall(function() purge(game:GetService("CoreGui")) end)
        local lp = Players.LocalPlayer
        if lp then pcall(function() purge(lp:FindFirstChildOfClass("PlayerGui")) end) end
        if _G._FH_CYUTSUD_GUI then pcall(function() _G._FH_CYUTSUD_GUI:Destroy() end) end
    end)
    _G._FH_CYUTSUD_GUI = nil

    local T = {
        Bg          = Color3.fromRGB(14,  10,  22),
        BgDeep      = Color3.fromRGB(8,    6,  14),
        Side        = Color3.fromRGB(20,  14,  32),
        SideHover   = Color3.fromRGB(36,  24,  56),
        SideActive  = Color3.fromRGB(44,  28,  68),
        Card        = Color3.fromRGB(24,  16,  38),
        CardHover   = Color3.fromRGB(34,  22,  52),
        Line        = Color3.fromRGB(0,    0,   0),
        Soft        = Color3.fromRGB(28,  18,  42),
        Text        = Color3.fromRGB(245, 240, 255),
        TextDim     = Color3.fromRGB(170, 150, 200),
        TextMute    = Color3.fromRGB(110,  95, 140),
        Primary     = Color3.fromRGB(168,  85, 247),
        White       = Color3.fromRGB(255, 255, 255),
        Green       = Color3.fromRGB(168,  85, 247),
    }

    local F  = TweenInfo.new(0.12, Enum.EasingStyle.Quad)
    local M  = TweenInfo.new(0.2,  Enum.EasingStyle.Quad)
    local PG = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local Theme = {
        c1 = Color3.fromRGB(168, 85, 247),
        c2 = Color3.fromRGB(76, 29, 149),
    }

    -- Contrast knob color: primary==secondary → white; both white → black
    local function _CyutsudKnobOnColor()
        local p = Color3.fromRGB(168, 85, 247)
        local s = Color3.fromRGB(255, 255, 255)
        pcall(function()
            if Theme and typeof(Theme.c1) == "Color3" then p = Theme.c1 end
            if T and typeof(T.White) == "Color3" then s = T.White end
            if typeof(_G.coreTheme) == "table" then
                if typeof(_G.coreTheme.primary) == "Color3" then p = _G.coreTheme.primary end
                if typeof(_G.coreTheme.secondary) == "Color3" then s = _G.coreTheme.secondary end
            end
        end)
        local function nearWhite(c)
            return c.R > 0.92 and c.G > 0.92 and c.B > 0.92
        end
        local function near(a, b)
            return math.abs(a.R - b.R) < 0.04 and math.abs(a.G - b.G) < 0.04 and math.abs(a.B - b.B) < 0.04
        end
        if nearWhite(p) and nearWhite(s) then
            return Color3.fromRGB(12, 12, 16)
        end
        if near(p, s) then
            return Color3.fromRGB(255, 255, 255)
        end
        return Color3.fromRGB(255, 255, 255)
    end
    _G._CyutsudKnobOnColor = _CyutsudKnobOnColor


    local ThemeGrads  = {}
    local ThemeSolids = {}
    local ThemeBgFrames = {}

    local function trackBgFrame(frame, role)
        table.insert(ThemeBgFrames, {frame = frame, role = role})
    end

    local function RepaintBgs()
        for _, e in ipairs(ThemeBgFrames) do
            if e.frame and e.frame.Parent then
                pcall(function() e.frame.BackgroundColor3 = T[e.role] end)
            end
        end
    end

    local Repaint

    local function SetGuiColor(col)
        local _h, _s, _v = Color3.toHSV(col)
        T.Bg         = Color3.fromHSV(_h, _s,           _v)
        T.BgDeep     = Color3.fromHSV(_h, _s,           math.max(_v * 0.65, 0))
        T.Side       = Color3.fromHSV(_h, _s * 0.9,     math.min(_v * 1.35, 1))
        T.SideHover  = Color3.fromHSV(_h, _s * 0.75,    math.min(_v * 1.90, 1))
        T.SideActive = Color3.fromHSV(_h, _s * 0.75,    math.min(_v * 1.90, 1))
        T.Card       = Color3.fromHSV(_h, _s * 0.85,    math.min(_v * 1.60, 1))
        T.CardHover  = Color3.fromHSV(_h, _s * 0.75,    math.min(_v * 2.00, 1))
        T.Line       = Color3.fromHSV(_h, _s * 0.55,    math.min(_v * 2.80, 0.45))
        T.Soft       = Color3.fromHSV(_h, _s * 0.80,    math.min(_v * 1.70, 1))
        RepaintBgs()
        pcall(function()
            if Dot2 then Dot2.BackgroundColor3 = T.Bg end
        end)
        pcall(function()
            if type(_G._CyutsudBroadcastTheme) == "function" then
                _G._CyutsudBroadcastTheme()
            end
        end)
    end

    local function SetAccentColor(col)
        Theme.c1 = col
        T.Primary = col
        T.Green = col
        local _h, _s, _v = Color3.toHSV(col)
        Theme.c2 = Color3.fromHSV(_h, math.clamp(_s * 0.75, 0, 1), math.max(_v * 0.32, 0.08))
        pcall(function()
            if Dot1 then Dot1.BackgroundColor3 = col end
        end)
        pcall(function()
            if typeof(PageTitle) == "Instance" then PageTitle.TextColor3 = col end
        end)
        pcall(function()
            if _G._FH_ReopenBtn then
                _G._FH_ReopenBtn.BackgroundColor3 = col
                local lum = 0.299 * col.R + 0.587 * col.G + 0.114 * col.B
                _G._FH_ReopenBtn.TextColor3 = (lum > 0.55) and Color3.fromRGB(12, 6, 22) or Color3.fromRGB(255, 255, 255)
            end
        end)
        if type(Repaint) == "function" then
            pcall(Repaint)
        end
        pcall(function()
            if Root then
                for _, d in ipairs(Root:GetDescendants()) do
                    if d.Name == "LogoBadge" or d.Name == "LogoBox" then
                        d.BackgroundColor3 = col
                    end
                end
            end
        end)
        pcall(function()
            if type(_G._CyutsudBroadcastTheme) == "function" then
                _G._CyutsudBroadcastTheme()
            end
        end)
    end

    local function themeSeq()
        local _h, _s, _v = Color3.toHSV(Theme.c1)
        local _dark = Color3.fromHSV(_h, _s * 0.55, math.max(_v * 0.30, 0))
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Theme.c1),
            ColorSequenceKeypoint.new(0.5,  _dark),
            ColorSequenceKeypoint.new(1,    Theme.c1),
        })
    end

    local function trackSolid(frame, slot)
        table.insert(ThemeSolids, {frame = frame, slot = slot})
        frame.BackgroundColor3 = (slot == 1) and Theme.c1 or Theme.c2
    end

    local function Tween(o, i, p)
        TweenService:Create(o, i, p):Play()
    end

    local function Corner(p, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 12)
        c.Parent = p
        return c
    end

    local function Stroke(p, col, th, trans)
        local s = Instance.new("UIStroke")
        s.Color           = col or T.Line
        s.Thickness       = th or 1
        s.Transparency    = trans or 0
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent          = p
        return s
    end

    local function Pad(p, t, b, l, r)
        local u = Instance.new("UIPadding")
        u.PaddingTop    = UDim.new(0, t or 0)
        u.PaddingBottom = UDim.new(0, b or 0)
        u.PaddingLeft   = UDim.new(0, l or 0)
        u.PaddingRight  = UDim.new(0, r or 0)
        u.Parent = p
    end

    local function Grad(p, _c1, _c2, rot)
        local g = Instance.new("UIGradient")
        g.Color    = themeSeq()
        g.Rotation = rot or 0
        g.Parent   = p
        table.insert(ThemeGrads, {grad = g, baseRot = rot or 0, speed = 1})
        return g
    end

    local function GradStroke(p, th, trans, rot)
        local s = Stroke(p, Color3.fromRGB(0, 0, 0), th or 1.8, trans or 0.05)
        local g = Instance.new("UIGradient")
        g.Color = themeSeq()
        g.Rotation = rot or 90
        g.Parent = s
        table.insert(ThemeGrads, {grad = g, baseRot = rot or 90, speed = 1})
        return s
    end

    Repaint = function()
        local seq = themeSeq()
        for _, e in ipairs(ThemeGrads) do
            if e.grad and e.grad.Parent then
                pcall(function() e.grad.Color = seq end)
            end
        end
        for _, e in ipairs(ThemeSolids) do
            if e.frame and e.frame.Parent then
                pcall(function()
                    e.frame.BackgroundColor3 = (e.slot == 1) and Theme.c1 or Theme.c2
                end)
            end
        end
        pcall(function()
            if typeof(PageTitle) == "Instance" then
                PageTitle.TextColor3 = Theme.c1
            end
        end)
        T.Primary = Theme.c1
        T.Green = Theme.c1
    end

    -- Cyutsud hub logo (embedded) — replaces purple side squares
    local CYUTSUD_SIDE_IMAGE_FALLBACK = "rbxassetid://122136004623357"
    local CYUTSUD_SIDE_IMAGE = CYUTSUD_SIDE_IMAGE_FALLBACK
    local _CyutsudLogoB64 = "removed cuz ts un needed"
    local function _CyutsudEnsureLogoAsset()
        local path = "CyutsudHub/cyutsud_logo.png"
        pcall(function()
            if makefolder and not (isfolder and isfolder("CyutsudHub")) then
                makefolder("CyutsudHub")
            end
        end)
        pcall(function()
            if writefile and (not isfile or not isfile(path)) then
                local ok, data = pcall(function()
                    return game:GetService("HttpService"):Base64Decode(_CyutsudLogoB64)
                end)
                if not ok or type(data) ~= "string" then
                    -- manual base64 decode fallback
                    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
                    local function dec(data)
                        data = string.gsub(data, '[^'..b..'=]', '')
                        return (data:gsub('.', function(x)
                            if x == '=' then return '' end
                            local r, f = '', (b:find(x)-1)
                            for i = 6, 1, -1 do
                                r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
                            end
                            return r
                        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
                            if #x ~= 8 then return '' end
                            local c = 0
                            for i = 1, 8 do
                                c = c + (x:sub(i, i) == '1' and 2^(8-i) or 0)
                            end
                            return string.char(c)
                        end))
                    end
                    data = dec(_CyutsudLogoB64)
                end
                if type(data) == "string" and #data > 100 then
                    writefile(path, data)
                end
            end
        end)
        local asset = nil
        pcall(function()
            if type(getcustomasset) == "function" and isfile and isfile(path) then
                asset = getcustomasset(path)
            end
        end)
        if type(asset) == "string" and asset ~= "" then
            CYUTSUD_SIDE_IMAGE = asset
            return asset
        end
        CYUTSUD_SIDE_IMAGE = CYUTSUD_SIDE_IMAGE_FALLBACK
        return CYUTSUD_SIDE_IMAGE
    end
    pcall(_CyutsudEnsureLogoAsset)
    local _CyutsudSideImageBoxes = {}

    local function _CyutsudAttachSideImage(panel, titleBar)
        if not panel or not panel.Parent then return end
        pcall(function()
            local imgAsset = _CyutsudEnsureLogoAsset()
            -- Skip side image on these panels
            local SKIP_SIDE = {
                ["PanelGui_CyutsudQuickPanel"] = true,
                ["PanelGui_FluxQuickPanel"] = true,
                ["PanelGui_Booster"] = true,
                ["PanelGui_Instant Steal"] = true,
                ["PanelGui_Instant Steal V2"] = true,
                ["PanelGui_Admin Panel"] = true, -- legacy quick admin
                ["CyutsudHubBanner"] = true, -- no logo on floating banner
            }
            local function isSkipped(inst)
                local cur = inst
                while cur do
                    if SKIP_SIDE[cur.Name] then return true end
                    cur = cur.Parent
                end
                return false
            end
            if isSkipped(panel) or (titleBar and isSkipped(titleBar)) then
                for _, root in ipairs({panel, titleBar}) do
                    if root then
                        local ex = root:FindFirstChild("CyutsudSideImage", true)
                        if ex then pcall(function() ex:Destroy() end) end
                    end
                end
                return
            end

            local host = titleBar
            if not host or not host.Parent then
                host = panel:FindFirstChild("TitleBar")
                    or panel:FindFirstChild("Header")
                    or panel:FindFirstChild("CDHdr")
                    or panel
            end
            if not host then return end

            local old = host:FindFirstChild("CyutsudSideImage") or panel:FindFirstChild("CyutsudSideImage")
            if old then
                if old:IsA("ImageLabel") then
                    old.Image = imgAsset
                    old.BackgroundTransparency = 1
                elseif old:IsA("Frame") then
                    old.BackgroundTransparency = 1
                    local ic = old:FindFirstChild("Icon")
                    if ic and ic:IsA("ImageLabel") then
                        ic.Image = imgAsset
                        ic.BackgroundTransparency = 1
                    end
                end
                return
            end

            local size = 26
            if host == panel then
                size = 32
            end

            -- Transparent host frame (no purple square)
            local box = Instance.new("Frame")
            box.Name = "CyutsudSideImage"
            box.Size = UDim2.new(0, size, 0, size)
            box.AnchorPoint = Vector2.new(0, 0.5)
            if host == panel then
                box.Position = UDim2.new(0, 8, 0, 8)
                box.AnchorPoint = Vector2.new(0, 0)
            else
                box.Position = UDim2.new(0, 8, 0.5, 0)
            end
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            local baseZ = math.max(host.ZIndex or 1, panel.ZIndex or 1)
            box.ZIndex = baseZ + 50
            box.Parent = host

            local img = Instance.new("ImageLabel")
            img.Name = "Icon"
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Position = UDim2.new(0, 0, 0, 0)
            img.BackgroundTransparency = 1
            img.Image = imgAsset
            img.ScaleType = Enum.ScaleType.Fit
            img.ZIndex = box.ZIndex + 1
            img.Parent = box
            local ic = Instance.new("UICorner")
            ic.CornerRadius = UDim.new(0, 6)
            ic.Parent = img

            table.insert(_CyutsudSideImageBoxes, box)

            -- Shift title labels to the right so they don't overlap the square
            pcall(function()
                for _, d in ipairs(host:GetChildren()) do
                    if d:IsA("TextLabel") and d.Name ~= "Icon" then
                        local pos = d.Position
                        local left = pos.X.Offset
                        if left < size + 14 then
                            d.Position = UDim2.new(pos.X.Scale, size + 14, pos.Y.Scale, pos.Y.Offset)
                            if d.Size.X.Offset > 0 then
                                d.Size = UDim2.new(d.Size.X.Scale, math.max(40, d.Size.X.Offset - (size + 4)), d.Size.Y.Scale, d.Size.Y.Offset)
                            end
                        end
                    end
                end
            end)
        end)
    end
    _G._CyutsudAttachSideImage = _CyutsudAttachSideImage

    local function _CyutsudStyleLikeHub(panel, titleBar)
        if not panel or not panel.Parent then return end
        pcall(function()
            panel.BackgroundColor3 = T.Bg
            panel.BackgroundTransparency = 0.02
            panel.BorderSizePixel = 0
        end)
        pcall(function() trackBgFrame(panel, "Bg") end)

        pcall(function()
            local c = panel:FindFirstChildOfClass("UICorner")
            if not c then
                c = Instance.new("UICorner")
                c.Parent = panel
            end
            c.CornerRadius = UDim.new(0, 14)
        end)

        pcall(function()
            for _, ch in ipairs(panel:GetChildren()) do
                if ch:IsA("UIStroke") and not ch:FindFirstChildOfClass("UIGradient") then
                    ch:Destroy()
                elseif ch:IsA("UIStroke") then
                    local g = ch:FindFirstChildOfClass("UIGradient")
                    if g then
                        g.Color = themeSeq()
                        g.Rotation = 90
                        table.insert(ThemeGrads, {grad = g, baseRot = 90, speed = 1})
                    end
                    ch.Color = Color3.fromRGB(0, 0, 0)
                    ch.Thickness = 1.8
                    ch.Transparency = 0.05
                end
            end
            if not panel:FindFirstChildOfClass("UIStroke") then
                GradStroke(panel, 1.6, 0.25, 90)
            end
        end)

        pcall(function()
            if not panel:FindFirstChild("Shadow") then
                local shadow = Instance.new("ImageLabel")
                shadow.Name = "Shadow"
                shadow.Size = UDim2.new(1, 40, 1, 40)
                shadow.Position = UDim2.new(0, -20, 0, -20)
                shadow.BackgroundTransparency = 1
                shadow.Image = "rbxassetid://5028857084"
                shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                shadow.ImageTransparency = 0.5
                shadow.ScaleType = Enum.ScaleType.Slice
                shadow.SliceCenter = Rect.new(24, 24, 276, 276)
                shadow.ZIndex = math.max((panel.ZIndex or 1) - 1, 0)
                shadow.Parent = panel
            end
        end)

        if titleBar and titleBar.Parent then
            pcall(function()
                titleBar.BackgroundColor3 = T.BgDeep
                titleBar.BackgroundTransparency = 0.05
                titleBar.BorderSizePixel = 0
            end)
            pcall(function() trackBgFrame(titleBar, "BgDeep") end)
            pcall(function()
                local c = titleBar:FindFirstChildOfClass("UICorner")
                if not c then
                    c = Instance.new("UICorner")
                    c.Parent = titleBar
                end
                c.CornerRadius = UDim.new(0, 12)
            end)
            pcall(function()
                local accent = titleBar:FindFirstChild("HubAccent")
                if not accent then
                    accent = Instance.new("Frame")
                    accent.Name = "HubAccent"
                    accent.Size = UDim2.new(1, 0, 0, 2)
                    accent.Position = UDim2.new(0, 0, 1, -2)
                    accent.BorderSizePixel = 0
                    accent.ZIndex = (titleBar.ZIndex or 1) + 2
                    accent.Parent = titleBar
                end
                accent.BackgroundColor3 = Theme.c1
                trackSolid(accent, 1)
            end)
            pcall(function()
                for _, d in ipairs(titleBar:GetChildren()) do
                    if d:IsA("TextLabel") then
                        d.TextColor3 = T.Text
                        d.Font = Enum.Font.GothamBold
                    end
                end
            end)
        end

        pcall(function()
            _CyutsudAttachSideImage(panel, titleBar)
        end)
    end
    _G._CyutsudStyleLikeHub = _CyutsudStyleLikeHub

    local _gradPhase = 0
    local _gradAccum = 0
    local _GRAD_TICK = 1/15
    local _sharedFps = 0
    local _sharedFc  = 0
    local _sharedFt  = 0
    local _bannerStatsRef = nil
    local _bannerLast = ""
    local _sharedFlowPhase = 0

    local function Lbl(p, txt, sz, col, font, align)
        local l = Instance.new("TextLabel")
        l.Text                   = txt or ""
        l.TextSize               = sz or 12
        l.TextColor3             = col or T.Text
        l.Font                   = font or Enum.Font.Gotham
        l.BackgroundTransparency = 1
        l.TextXAlignment         = align or Enum.TextXAlignment.Left
        l.Parent                 = p
        return l
    end

    local GUI = Instance.new("ScreenGui")
    GUI.Name           = "CyutsudHub"
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.ResetOnSpawn   = false
    GUI.IgnoreGuiInset = true
    GUI.Enabled        = true
    GUI.DisplayOrder   = 999999

    do
        local parented = false
        local function tryParent(p)
            if parented or not p then return end
            local ok = pcall(function() GUI.Parent = p end)
            if ok and GUI.Parent == p then parented = true end
        end

        local _exec = ""
        pcall(function()
            if type(identifyexecutor) == "function" then
                _exec = (identifyexecutor() or ""):lower()
            end
        end)
        local _isMaddium = _exec:find("maddium") ~= nil

        if _isMaddium then
            pcall(function()
                local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
                local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
                tryParent(pg)
            end)
        end
        if not parented then
            pcall(function()
                if type(gethui) == "function" then tryParent(gethui()) end
            end)
        end
        pcall(function()
            if type(protect_gui) == "function" then
                protect_gui(GUI)
            elseif syn and syn.protect_gui then
                syn.protect_gui(GUI)
            end
        end)
        if not parented then
            pcall(function()
                local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                tryParent(_cr(game:GetService("CoreGui")))
            end)
        end
        if not parented then
            local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
            local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
            tryParent(pg)
        end

        GUI.AncestryChanged:Connect(function()
            if GUI.Parent ~= nil then return end
            parented = false
            task.defer(function()
                pcall(function()
                    if typeof(gethui) == "function" then tryParent(gethui()) end
                end)
                if not parented then
                    pcall(function()
                        local _cr = typeof(cloneref) == "function" and cloneref or function(x) return x end
                        tryParent(_cr(game:GetService("CoreGui")))
                    end)
                end
                if not parented then
                    local lp2 = Players.LocalPlayer
                    if lp2 then
                        local pg2 = lp2:FindFirstChildOfClass("PlayerGui")
                        if pg2 then tryParent(pg2) end
                    end
                end
            end)
        end)
    end
    _G._FH_CYUTSUD_GUI = GUI

    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local isPhone = false
    if isMobile then
        local _vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        local _short = math.min(_vp.X, _vp.Y)
        isPhone = _short < 600
    end
    local isTablet = isMobile and not isPhone

    local _UI = { userPct = 100, desiredScale = 1 }
    local _gScaleList = {}

    local function _newScale(frame, factor)
        local f = factor or 1
        local sc = Instance.new("UIScale")
        sc.Scale = (_UI.desiredScale or 1) * f
        sc.Parent = frame
        table.insert(_gScaleList, {sc = sc, f = f})
        return sc
    end

    -- Banner FPS + PING (haut du hub) — thème CyutsudHub (recadré + textes bien alignés)
    do
        local StatsService = game:GetService("Stats")

        pcall(function()
            local old = GUI:FindFirstChild("CyutsudHubBanner")
            if old then old:Destroy() end
        end)
        pcall(function()
            local lp = Players.LocalPlayer
            local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
            if pg then
                local o = pg:FindFirstChild("UI_Watermark_Gamma")
                if o then o:Destroy() end
            end
        end)

        local function colToRgb(c)
            if typeof(c) ~= "Color3" then return "235,235,245" end
            return string.format("%d,%d,%d",
                math.floor(c.R * 255 + 0.5),
                math.floor(c.G * 255 + 0.5),
                math.floor(c.B * 255 + 0.5))
        end

        -- Cadre capsule, textes parfaitement centrés
        local banner = Instance.new("Frame")
        banner.Name                   = "CyutsudHubBanner"
        banner.Size                   = UDim2.new(0, 340, 0, 96)
        banner.Position               = UDim2.new(0.5, 0, 0, -100)
        banner.AnchorPoint            = Vector2.new(0.5, 0)
        banner.BackgroundColor3       = T.Bg
        banner.BackgroundTransparency = 0.02
        banner.BorderSizePixel        = 0
        banner.ZIndex                 = 100000
        banner.Active                 = false
        banner.ClipsDescendants       = true
        banner.Parent                 = GUI
        pcall(function() trackBgFrame(banner, "Bg") end)
        pcall(function() _newScale(banner) end)
        Corner(banner, 24)

        -- Bordure gradient
        local borderStroke = GradStroke(banner, 2.2, 0.08, 90)
        pcall(function()
            if borderStroke then
                borderStroke.Thickness = 2.2
                borderStroke.Transparency = 0.08
            end
        end)

        -- Ombre douce
        local bannerShadow = Instance.new("ImageLabel")
        bannerShadow.Name                   = "BannerShadow"
        bannerShadow.Size                   = UDim2.new(1, 40, 1, 40)
        bannerShadow.Position               = UDim2.new(0, -20, 0, -20)
        bannerShadow.BackgroundTransparency = 1
        bannerShadow.Image                  = "rbxassetid://5028857084"
        bannerShadow.ImageColor3            = Color3.fromRGB(0, 0, 0)
        bannerShadow.ImageTransparency      = 0.52
        bannerShadow.ScaleType              = Enum.ScaleType.Slice
        bannerShadow.SliceCenter            = Rect.new(24, 24, 276, 276)
        bannerShadow.ZIndex                 = 99999
        bannerShadow.Parent                 = banner

        -- Conteneur interne pour centrer parfaitement les 4 lignes
        local content = Instance.new("Frame")
        content.Name                   = "BannerContent"
        content.Size                   = UDim2.new(1, -20, 1, -16)
        content.Position               = UDim2.new(0, 10, 0, 8)
        content.BackgroundTransparency = 1
        content.BorderSizePixel        = 0
        content.ZIndex                 = 100001
        content.Parent                 = banner

        local list = Instance.new("UIListLayout")
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.VerticalAlignment   = Enum.VerticalAlignment.Center
        list.Padding             = UDim.new(0, 2)
        list.SortOrder           = Enum.SortOrder.LayoutOrder
        list.Parent              = content

        -- 1. Titre CYUTSUD HUB
        local Title = Instance.new("TextLabel")
        Title.Name                   = "Title"
        Title.Size                   = UDim2.new(1, 0, 0, 22)
        Title.BackgroundTransparency = 1
        Title.Text                   = "CYUTSUD HUB"
        Title.TextColor3             = T.Text
        Title.TextSize               = 20
        Title.Font                   = Enum.Font.GothamBlack
        Title.TextXAlignment         = Enum.TextXAlignment.Center
        Title.TextYAlignment         = Enum.TextYAlignment.Center
        Title.LayoutOrder            = 1
        Title.ZIndex                 = 100002
        Title.Parent                 = content
        _G._CyutsudBannerTitle = Title
        local function _CyutsudUpdateBannerTitle(allGearOn)
            pcall(function()
                local t = _G._CyutsudBannerTitle
                if not t or not t.Parent then return end
                if allGearOn then
                    t.Text = "CYUTSUD HUB ALL GEAR"
                    t.TextSize = 16
                else
                    t.Text = "CYUTSUD HUB"
                    t.TextSize = 20
                end
            end)
        end
        _G._CyutsudUpdateBannerTitle = _CyutsudUpdateBannerTitle

        -- Ensure no logo on the floating banner
        pcall(function()
            for _, d in ipairs(banner:GetDescendants()) do
                if d.Name == "CyutsudSideImage" or d.Name == "LogoBadge" or d.Name == "LogoBox" then
                    d:Destroy()
                end
            end
        end)

        local titleGrad = Instance.new("UIGradient")
        titleGrad.Color = themeSeq()
        titleGrad.Parent = Title
        table.insert(ThemeGrads, {grad = titleGrad, baseRot = 0, speed = 1})

        -- 2. Crédits
        local credit = Instance.new("TextLabel")
        credit.Name                   = "Credit"
        credit.Size                   = UDim2.new(1, 0, 0, 14)
        credit.BackgroundTransparency = 1
        credit.Text                   = "@cyutsud"
        credit.TextColor3             = T.TextDim
        credit.TextSize               = 11
        credit.Font                   = Enum.Font.GothamBold
        credit.TextXAlignment         = Enum.TextXAlignment.Center
        credit.TextYAlignment         = Enum.TextYAlignment.Center
        credit.LayoutOrder            = 2
        credit.ZIndex                 = 100002
        credit.Parent                 = content

        -- 3. Discord
        local disc = Instance.new("TextLabel")
        disc.Name                   = "Discord"
        disc.Size                   = UDim2.new(1, 0, 0, 13)
        disc.BackgroundTransparency = 1
        disc.Text                   = ""
        disc.TextColor3             = Theme.c1
        disc.TextSize               = 11
        disc.Font                   = Enum.Font.GothamBold
        disc.TextXAlignment         = Enum.TextXAlignment.Center
        disc.TextYAlignment         = Enum.TextYAlignment.Center
        disc.LayoutOrder            = 3
        disc.ZIndex                 = 100002
        disc.Parent                 = content

        -- 4. FPS / PING
        local FpsLabel = Instance.new("TextLabel")
        FpsLabel.Name                   = "FpsLabel"
        FpsLabel.Size                   = UDim2.new(1, 0, 0, 15)
        FpsLabel.BackgroundTransparency = 1
        FpsLabel.Text                   = "FPS: --  PING: --ms"
        FpsLabel.TextColor3             = T.Text
        FpsLabel.TextSize               = 13
        FpsLabel.Font                   = Enum.Font.GothamBold
        FpsLabel.RichText               = true
        FpsLabel.TextXAlignment         = Enum.TextXAlignment.Center
        FpsLabel.TextYAlignment         = Enum.TextYAlignment.Center
        FpsLabel.LayoutOrder            = 4
        FpsLabel.ZIndex                 = 100002
        FpsLabel.Parent                 = content

        local function paintBannerTheme()
            pcall(function()
                banner.BackgroundColor3 = T.Bg
                Title.TextColor3 = T.Text
                credit.TextColor3 = T.TextDim
                disc.TextColor3 = Theme.c1 or T.Primary
                if titleGrad then
                    titleGrad.Color = themeSeq()
                end
                -- border gradient + stroke follow accent
                if borderStroke and borderStroke.Parent then
                    local g = borderStroke:FindFirstChildOfClass("UIGradient")
                    if g then
                        g.Color = themeSeq()
                    else
                        local ng = Instance.new("UIGradient")
                        ng.Color = themeSeq()
                        ng.Rotation = 90
                        ng.Parent = borderStroke
                        table.insert(ThemeGrads, {grad = ng, baseRot = 90, speed = 1})
                    end
                end
            end)
            -- force FPS/PING labels to recolor with new theme
            _lastBannerFps, _lastBannerPing = -1, -1
        end

        -- Entrée animée
        task.spawn(function()
            task.wait(0.12)
            TweenService:Create(banner, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 78)
            }):Play()
            task.wait(0.5)
            TweenService:Create(banner, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 82)
            }):Play()
        end)

        local _lastBannerFps, _lastBannerPing = -1, -1

        _bannerStatsRef = function(fps, ping)
            if not FpsLabel or not FpsLabel.Parent then return end
            fps = tonumber(fps) or 0
            ping = tonumber(ping) or 0
            if fps == _lastBannerFps and ping == _lastBannerPing then return end
            _lastBannerFps, _lastBannerPing = fps, ping

            local primary = Theme.c1 or T.Primary or Color3.fromRGB(168, 85, 247)
            local textCol = T.Text or Color3.fromRGB(245, 240, 255)
            local amber = Color3.fromRGB(255, 200, 80)
            local red = Color3.fromRGB(255, 90, 90)
            -- soft green tinted toward accent for ping OK
            local _h, _s, _v = Color3.toHSV(primary)
            local green = Color3.fromHSV(math.clamp(_h * 0.15 + 0.33, 0.28, 0.42), math.clamp(_s * 0.55, 0.35, 0.85), math.max(_v, 0.75))

            local fpsC = (fps >= 55 and primary) or (fps >= 30 and amber) or red
            local pingC = (ping <= 80 and green) or (ping <= 150 and amber) or red

            FpsLabel.Text = string.format(
                '<font color="rgb(%s)">FPS: </font><font color="rgb(%s)">%d</font><font color="rgb(%s)">  PING: </font><font color="rgb(%s)">%dms</font>',
                colToRgb(textCol), colToRgb(fpsC), fps, colToRgb(textCol), colToRgb(pingC), ping
            )
        end

        -- Repaint quand le thème change
        local _oldBroadcast = _G._CyutsudBroadcastTheme
        _G._CyutsudBroadcastTheme = function(...)
            if type(_oldBroadcast) == "function" then
                pcall(_oldBroadcast, ...)
            end
            paintBannerTheme()
            _lastBannerFps, _lastBannerPing = -1, -1
            if _sharedFps then
                local ping = 0
                pcall(function()
                    local lp = Players.LocalPlayer
                    if lp then ping = math.floor((lp:GetNetworkPing() or 0) * 1000) end
                end)
                if _bannerStatsRef then _bannerStatsRef(_sharedFps, ping) end
            end
        end

        -- Fallback autonome
        task.spawn(function()
            local frameCount, lastTick, currentFps = 0, tick(), 60
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not banner or not banner.Parent then
                    if conn then conn:Disconnect() end
                    return
                end
                frameCount = frameCount + 1
                local now = tick()
                if now - lastTick >= 0.5 then
                    currentFps = math.floor(frameCount / (now - lastTick) + 0.5)
                    frameCount = 0
                    lastTick = now
                end
            end)
            while banner and banner.Parent do
                if _isShuttingDown and _isShuttingDown() then break end
                local ping = 0
                pcall(function()
                    local item = StatsService.Network.ServerStatsItem["Data Ping"]
                    if item then
                        ping = math.floor(item:GetValue() + 0.5)
                    end
                end)
                if ping == 0 then
                    pcall(function()
                        local lp = Players.LocalPlayer
                        if lp then
                            ping = math.floor((lp:GetNetworkPing() or 0) * 1000)
                        end
                    end)
                end
                local fps = (_sharedFps and _sharedFps > 0) and _sharedFps or currentFps
                if _bannerStatsRef then
                    _bannerStatsRef(fps, ping)
                end
                task.wait(0.4)
            end
            if conn then pcall(function() conn:Disconnect() end) end
        end)

        _G._CyutsudPaintBannerTheme = paintBannerTheme
        paintBannerTheme()
    end

    local UIRoot = Instance.new("Frame")
    UIRoot.Name                   = "UIRoot"
    UIRoot.Size                   = UDim2.new(1, 0, 1, 0)
    UIRoot.Position               = UDim2.new(0, 0, 0, 0)
    UIRoot.BackgroundTransparency = 1
    UIRoot.BorderSizePixel        = 0
    UIRoot.Active                 = false
    UIRoot.ZIndex                 = 1
    UIRoot.Parent                 = GUI

    local WIN_W, WIN_H
    if isPhone then
        WIN_W, WIN_H = 340, 420
    elseif isMobile then
        WIN_W, WIN_H = 440, 460
    else
        WIN_W, WIN_H = 520, 480
    end

    local rootScale

    local function _applyUiScale()
        local cam = workspace.CurrentCamera
        if not cam then
            local _t = 0
            repeat task.wait(0.05); _t = _t + 0.05; cam = workspace.CurrentCamera until cam or _t > 3
        end
        local vp  = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        local gsz = GUI.AbsoluteSize
        if gsz and gsz.X > 1 and gsz.Y > 1 then vp = gsz end
        if vp.X < 1 or vp.Y < 1 then vp = Vector2.new(1280, 720) end
        local pct = (_UI.userPct or 100) / 100
        local scale
        if isMobile then
            local _short = math.min(vp.X, vp.Y)
            local _long  = math.max(vp.X, vp.Y)
            local _curPhone = _short < 600
            local base = math.clamp(math.min(_long / 1366, _short / 768), 0.50, 1.20)
            scale = base * (_curPhone and 0.78 or 0.95) * pct
        else
            local base = math.clamp(math.min(vp.X / 1920, vp.Y / 1080), 0.63, 1.62)
            scale = base * pct * 0.91
        end
        local fitW = (vp.X * 0.96) / WIN_W
        local fitH = (vp.Y * 0.94) / WIN_H
        local cap  = math.max(0.40, math.min(fitW, fitH))
        _UI.desiredScale = math.clamp(math.min(scale, cap), 0.40, 2.25)
        if rootScale then rootScale.Scale = _UI.desiredScale end
        for _, e in ipairs(_gScaleList) do
            e.sc.Scale = _UI.desiredScale * e.f
        end
    end

    local _uiScalePending = false
    local function _scheduleUiScale()
        if _uiScalePending then return end
        _uiScalePending = true
        task.delay(0.06, function()
            _uiScalePending = false
            _applyUiScale()
        end)
    end

    task.spawn(function()
        _applyUiScale()
        local cam = workspace.CurrentCamera
        if not cam then
            repeat task.wait(0.05); cam = workspace.CurrentCamera until cam
        end
        local function _connectCam(c)
            if c then pcall(function() c:GetPropertyChangedSignal("ViewportSize"):Connect(_scheduleUiScale) end) end
        end
        _connectCam(cam)
        pcall(function()
            workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                _connectCam(workspace.CurrentCamera)
                _scheduleUiScale()
            end)
        end)
        pcall(function() GUI:GetPropertyChangedSignal("AbsoluteSize"):Connect(_scheduleUiScale) end)
        for _ = 1, 10 do task.wait(0.25); _scheduleUiScale() end
    end)

    local SIDE_W = 0  -- top-tab layout (no left sidebar)
    local TAB_BAR_H = isMobile and 34 or 36
    local HDR_H = isMobile and 40 or 44

    local Root = Instance.new("Frame")
    Root.Name             = "Root"
    Root.Size             = UDim2.new(0, WIN_W, 0, WIN_H)
    Root.AnchorPoint      = Vector2.new(0.5, 0.5)
    Root.Position         = UDim2.new(0.5, 0, 0.5, 0)
    Root.BackgroundColor3 = T.Bg
    Root.BackgroundTransparency = 0.02
    trackBgFrame(Root, "Bg")
    Root.BorderSizePixel  = 0
    Root.ZIndex           = 2
    Root.Parent           = GUI
    Corner(Root, 26)
    local rootStroke = GradStroke(Root, 1.8, 0.25, 90)

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size                   = UDim2.new(1, 48, 1, 48)
    Shadow.Position               = UDim2.new(0, -24, 0, -24)
    Shadow.BackgroundTransparency = 1
    Shadow.Image                  = "rbxassetid://5028857084"
    Shadow.ImageColor3            = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency      = 0.45
    Shadow.ScaleType              = Enum.ScaleType.Slice
    Shadow.SliceCenter            = Rect.new(24, 24, 276, 276)
    Shadow.ZIndex                 = 1
    Shadow.Parent                 = Root

    local Side = Instance.new("Frame")
    Side.Name             = "Header"
    Side.Size             = UDim2.new(1, 0, 0, HDR_H)
    Side.Position         = UDim2.new(0, 0, 0, 0)
    Side.BackgroundColor3 = T.BgDeep
    Side.BackgroundTransparency = 0.05
    trackBgFrame(Side, "BgDeep")
    Side.BorderSizePixel  = 0
    Side.ZIndex           = 5
    Side.Parent           = Root
    Corner(Side, 16)

    local SideCover = Instance.new("Frame")
    SideCover.Size             = UDim2.new(1, 0, 0, 12)
    SideCover.Position         = UDim2.new(0, 0, 1, -12)
    SideCover.BackgroundColor3 = T.BgDeep
    SideCover.BackgroundTransparency = 0.05
    trackBgFrame(SideCover, "BgDeep")
    SideCover.BorderSizePixel  = 0
    SideCover.ZIndex           = 5
    SideCover.Parent           = Side

    local accentBar = Instance.new("Frame")
    accentBar.Size             = UDim2.new(1, 0, 0, 2)
    accentBar.Position         = UDim2.new(0, 0, 1, -2)
    accentBar.BackgroundColor3 = T.Primary
    accentBar.BorderSizePixel  = 0
    accentBar.ZIndex           = 6
    accentBar.Parent           = Side
    trackSolid(accentBar, 1)

    local Logo = Instance.new("Frame")
    Logo.Size                   = UDim2.new(0, 140, 1, 0)
    Logo.Position               = UDim2.new(0, 12, 0, 0)
    Logo.BackgroundTransparency = 1
    Logo.ZIndex                 = 6
    Logo.Parent                 = Side

    local LogoTitle = Lbl(Logo, "CYUTSUD", isMobile and 12 or 14, T.Text, Enum.Font.GothamBlack)
    LogoTitle.Size     = UDim2.new(1, -8, 0, 16)
    LogoTitle.Position = UDim2.new(0, 0, 0.5, -8)
    LogoTitle.ZIndex   = 7

    local LogoSub = Lbl(Logo, "", 1, T.TextDim, Enum.Font.GothamMedium)
    LogoSub.Visible = false


    -- No side logo on main hub header / banner
    pcall(function()
        for _, root in ipairs({Root, Side}) do
            if root then
                local ex = root:FindFirstChild("CyutsudSideImage", true)
                if ex then pcall(function() ex:Destroy() end) end
            end
        end
        if Logo then
            Logo.Position = UDim2.new(0, 12, 0, 0)
        end
    end)

    local NavList = Instance.new("Frame")
    NavList.Name                   = "TabBar"
    NavList.Size                   = UDim2.new(1, -16, 0, TAB_BAR_H)
    NavList.Position               = UDim2.new(0, 8, 0, HDR_H + 4)
    NavList.BackgroundColor3       = T.BgDeep
    NavList.BackgroundTransparency = 0.15
    trackBgFrame(NavList, "BgDeep")
    NavList.BorderSizePixel        = 0
    NavList.ZIndex                 = 4
    NavList.Parent                 = Root
    Corner(NavList, 12)
    Stroke(NavList, T.Line, 1, 0.45)

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.FillDirection       = Enum.FillDirection.Horizontal
    NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    NavLayout.Padding             = UDim.new(0, 4)
    NavLayout.Parent              = NavList
    local NavPad = Instance.new("UIPadding")
    NavPad.PaddingLeft = UDim.new(0, 4)
    NavPad.PaddingRight = UDim.new(0, 4)
    NavPad.Parent = NavList

    local Content = Instance.new("Frame")
    Content.Size                   = UDim2.new(1, 0, 1, -(HDR_H + TAB_BAR_H + 8))
    Content.Position               = UDim2.new(0, 0, 0, HDR_H + TAB_BAR_H + 8)
    Content.BackgroundTransparency = 1
    Content.ZIndex                 = 3
    Content.Parent                 = Root

    local guiLocked = false
    _G._FH_GuiLocked = false
    _G._FH_DragClearers = _G._FH_DragClearers or {}
    _G._FH_ClearAllDrags = function()
        for _, fn in ipairs(_G._FH_DragClearers) do pcall(fn) end
    end

    if not _G._FH_LockWatchdog then
        _G._FH_LockWatchdog = true
        task.spawn(function()
            RunService.Heartbeat:Connect(function()
                if _G._FH_GuiLocked and _G._FH_ClearAllDrags then
                    _G._FH_ClearAllDrags()
                end
            end)
        end)
    end

    local TopBar = Instance.new("Frame")
    TopBar.Size                   = UDim2.new(1, 0, 0, isMobile and 28 or 30)
    TopBar.BackgroundColor3       = T.Bg
    TopBar.BackgroundTransparency = 1
    TopBar.BorderSizePixel        = 0
    TopBar.Active                 = true
    TopBar.ZIndex                 = 4
    TopBar.Parent                 = Content
    trackBgFrame(TopBar, "Bg")

    local TopBarLine = Instance.new("Frame")
    TopBarLine.Size                   = UDim2.new(1, -16, 0, 1)
    TopBarLine.Position               = UDim2.new(0, 8, 1, -1)
    TopBarLine.BackgroundColor3       = T.Primary
    TopBarLine.BackgroundTransparency = 0.85
    TopBarLine.BorderSizePixel        = 0
    TopBarLine.ZIndex                 = 5
    TopBarLine.Parent                 = TopBar

    local PageTitle = Lbl(TopBar, "Main", isMobile and 11 or 13, T.Primary, Enum.Font.GothamBlack)
    PageTitle.Size           = UDim2.new(0, 120, 1, 0)
    PageTitle.Position       = UDim2.new(0, 12, 0, 0)
    PageTitle.TextYAlignment = Enum.TextYAlignment.Center
    PageTitle.ZIndex         = 5

    local function makeColorDot(parent, xOffset, slot)
        local c = Instance.new("Frame")
        c.Name             = (slot == 1) and "ColorDotAccent" or "ColorDotBg"
        c.Size             = UDim2.new(0, 18, 0, 18)
        c.Position         = UDim2.new(1, xOffset, 0.5, -9)
        c.BackgroundColor3 = (slot == 1) and Theme.c1 or T.Bg
        c.BorderSizePixel  = 0
        c.ZIndex           = 60
        c.Active           = true
        c.Parent           = parent
        local _dc = Instance.new("UICorner")
        _dc.CornerRadius = UDim.new(1, 0)
        _dc.Parent = c
        local ring = Instance.new("UIStroke")
        ring.Color        = T.White
        ring.Thickness    = 1.2
        ring.Transparency = 0.35
        ring.Parent       = c
        local btn = Instance.new("TextButton")
        btn.Name                   = "Hit"
        btn.Size                   = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text                   = ""
        btn.AutoButtonColor        = false
        btn.Active                 = true
        btn.Selectable             = true
        btn.ZIndex                 = 61
        btn.Parent                 = c
        btn.MouseEnter:Connect(function() Tween(ring, F, {Transparency = 0.1}) end)
        btn.MouseLeave:Connect(function() Tween(ring, F, {Transparency = 0.35}) end)
        return c, btn
    end

    local Dot1, Dot1Btn = makeColorDot(Side, isMobile and -88 or -72, 1)
    local Dot2, Dot2Btn = makeColorDot(Side, isMobile and -68 or -52, 2)

    do
        local LockBtn = Instance.new("TextButton")
        local btnSize = isMobile and 26 or 24
        local btnOff  = isMobile and -32 or -28
        LockBtn.Size                   = UDim2.new(0, btnSize, 0, btnSize)
        LockBtn.Position               = UDim2.new(1, btnOff, 0.5, -btnSize/2)
        LockBtn.BackgroundColor3       = T.Soft
        LockBtn.BorderSizePixel        = 0
        LockBtn.Text                   = "�"
        LockBtn.Font                   = Enum.Font.GothamBold
        LockBtn.TextSize               = isMobile and 14 or 12
        LockBtn.TextColor3             = T.Text
        LockBtn.AutoButtonColor        = false
        LockBtn.Active                 = true
        LockBtn.Selectable             = true
        LockBtn.ZIndex                 = 60
        LockBtn.Parent                 = Side
        Corner(LockBtn, 12)
        _G._FH_LockBtn = LockBtn

        LockBtn.Activated:Connect(function()
            guiLocked = not guiLocked
            _G._FH_GuiLocked = guiLocked
            LockBtn.Text = guiLocked and "�" or "�"
            LockBtn.TextColor3 = guiLocked and Color3.fromRGB(196, 181, 253) or T.Text
            if guiLocked and _G._FH_ClearAllDrags then _G._FH_ClearAllDrags() end
            if _G._FH_SaveLock then _G._FH_SaveLock(guiLocked) end
        end)
        LockBtn.MouseEnter:Connect(function() Tween(LockBtn, F, {BackgroundColor3 = T.CardHover}) end)
        LockBtn.MouseLeave:Connect(function() Tween(LockBtn, F, {BackgroundColor3 = T.BgDeep}) end)
    end

    local Config = {}
    do
        local FOLDER      = "CyutsudHub"
        local FILE        = FOLDER .. "/config.json"
        local FILE_BAK    = FOLDER .. "/config.bak.json"
        local LEGACY_FILE = "violet_hub_config.json"
        Config.data = {}

        local function _ensureFolder()
            if not makefolder then return end
            if isfolder and isfolder(FOLDER) then return end
            pcall(function() makefolder(FOLDER) end)
        end
        pcall(_ensureFolder)

        pcall(function()
            local function tryDecode(path)
                if isfile and readfile and isfile(path) then
                    local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
                    if ok and type(decoded) == "table" then return decoded end
                end
            end
            local d = tryDecode(FILE) or tryDecode(FILE_BAK) or tryDecode(LEGACY_FILE)
            if d then Config.data = d end
        end)

        local function _writeNow()
            if not writefile then return end
            if Config._dirty == false then return end
            pcall(_ensureFolder)
            local ok, encoded = pcall(function() return HttpService:JSONEncode(Config.data) end)
            if not ok or type(encoded) ~= "string" or #encoded < 2 then return end
            pcall(function()
                if isfile and isfile(FILE) then
                    writefile(FILE_BAK, readfile(FILE))
                end
            end)
            pcall(function() writefile(FILE, encoded) end)
            Config._dirty = false
        end

        local _saveHandle = nil
        function Config.save()
            Config._dirty = true
            if not writefile then return end
            if _saveHandle then return end
            _saveHandle = task.delay(0.2, function()
                _writeNow()
                _saveHandle = nil
            end)
        end

        function Config.flush() _writeNow() end

        function Config.get(key, default)
            local v = Config.data[key]
            if v == nil then return default end
            return v
        end

        local function _deepEq(a, b)
            if type(a) == "number" and type(b) == "number" then
                return math.abs(a - b) < 1e-9
            end
            if a == b then return true end
            if type(a) ~= "table" or type(b) ~= "table" then return false end
            for k, v in pairs(a) do if not _deepEq(v, b[k]) then return false end end
            for k, _ in pairs(b) do if a[k] == nil then return false end end
            return true
        end

        function Config.set(key, value)
            if _deepEq(Config.data[key], value) then return end
            Config.data[key] = value
            Config._dirty = true
            if type(value) == "number" then
                Config.save()
            else
                _writeNow()
                if _saveHandle then task.cancel(_saveHandle); _saveHandle = nil end
            end
        end

        task.spawn(function()
            while true do
                task.wait(2)
                if writefile then _writeNow() end
            end
        end)

        pcall(function() game:BindToClose(function() _writeNow() end) end)
        pcall(function()
            local lp = Players.LocalPlayer
            if lp then
                lp.AncestryChanged:Connect(function(_, parent)
                    if not parent then _writeNow() end
                end)
            end
        end)
    end

    local function _getTogglesTable()
        local t = Config.get("toggles", nil)
        if type(t) ~= "table" then t = {} end
        return t
    end

    local function setToggleSaved(name, on)
        if not name or name == "" then return end
        on = on and true or false
        -- Normalize aliases (Anti Paintball = PaintBall Bypass)
        if name == "Anti Paintball" then
            name = "PaintBall Bypass"
        end
        -- Boolean key (same path for Auto Steal, GummyBypass, etc.)
        pcall(function()
            Config.data = Config.data or {}
            -- force overwrite so deepEq cannot skip
            Config.data["toggle:" .. name] = on
            Config._dirty = true
        end)
        -- Copy toggles map so reference deepEq cannot skip
        local t = _getTogglesTable()
        local copy = {}
        if type(t) == "table" then
            for k, v in pairs(t) do copy[k] = v end
        end
        copy[name] = on
        if name == "PaintBall Bypass" then
            copy["Anti Paintball"] = on
        end
        pcall(function()
            Config.data = Config.data or {}
            Config.data["toggles"] = copy
            Config._dirty = true
        end)
        if name == "Auto Giant Potion" then
            pcall(function()
                Config.data["isv2_autoPotion"] = on
                Config.data["auto_giant_potion"] = on
                Config._dirty = true
            end)
        end
        if name == "Giant Potion Speed" then
            pcall(function()
                Config.data["giant_potion_speed"] = on
                Config.data["gps_enabled"] = on
                Config.data["toggle:Giant Potion Speed"] = on
                Config._dirty = true
            end)
        end
        if name == "PaintBall Bypass" then
            pcall(function()
                Config.data["paintball_bypass"] = on
                Config.data["anti_paintball"] = on
                Config.data["toggle:PaintBall Bypass"] = on
                Config.data["toggle:Anti Paintball"] = on
                Config._dirty = true
            end)
        end
        if name == "GummyBypass" then
            pcall(function()
                Config.data["gummy_bypass"] = on
                Config._dirty = true
            end)
        end
        -- Flush immediately (same reliability as Auto Steal)
        pcall(function()
            if Config.flush then Config.flush() end
            if Config.save then Config.save() end
        end)
    end

    local function getToggleSaved(name, default)
        if default == nil then default = false end
        if name == "Anti Paintball" then
            name = "PaintBall Bypass"
        end
        local t = _getTogglesTable()
        if t[name] ~= nil then
            return t[name] and true or false
        end
        if name == "PaintBall Bypass" and t["Anti Paintball"] ~= nil then
            return t["Anti Paintball"] and true or false
        end
        local legacy = Config.get("toggle:" .. name, nil)
        if legacy ~= nil then
            return legacy and true or false
        end
        if name == "Auto Giant Potion" then
            local isv2 = Config.get("isv2_autoPotion", nil)
            if isv2 ~= nil then return isv2 and true or false end
            local ag = Config.get("auto_giant_potion", nil)
            if ag ~= nil then return ag and true or false end
        end
        if name == "GummyBypass" then
            local gb = Config.get("gummy_bypass", nil)
            if gb ~= nil then return gb and true or false end
        end
        if name == "Giant Potion Speed" then
            local g1 = Config.get("giant_potion_speed", nil)
            if g1 ~= nil then return g1 and true or false end
            local g2 = Config.get("gps_enabled", nil)
            if g2 ~= nil then return g2 and true or false end
            local g3 = Config.get("toggle:Giant Potion Speed", nil)
            if g3 ~= nil then return g3 and true or false end
        end
        if name == "PaintBall Bypass" then
            local p1 = Config.get("paintball_bypass", nil)
            if p1 ~= nil then return p1 and true or false end
            local p2 = Config.get("anti_paintball", nil)
            if p2 ~= nil then return p2 and true or false end
            local p3 = Config.get("toggle:PaintBall Bypass", nil)
            if p3 ~= nil then return p3 and true or false end
            local p4 = Config.get("toggle:Anti Paintball", nil)
            if p4 ~= nil then return p4 and true or false end
        end
        return default and true or false
    end

    local function _getPositionsTable()
        local pos = Config.get("positions", nil)
        if type(pos) ~= "table" then pos = {} end
        return pos
    end

    local function _getSizesTable()
        local s = Config.get("panelSizes", nil)
        if type(s) ~= "table" then s = {} end
        return s
    end

    local function saveGuiPosition(key, guiObject)
        if not key or not guiObject then return end
        pcall(function()
            local positions = _getPositionsTable()
            positions[key] = {
                guiObject.Position.X.Scale, guiObject.Position.X.Offset,
                guiObject.Position.Y.Scale, guiObject.Position.Y.Offset,
            }
            Config.set("positions", positions)
            if Config.flush then Config.flush() end
        end)
    end

    local function loadGuiPosition(key, guiObject)
        if not key or not guiObject then return false end
        local ok, loaded = pcall(function()
            local positions = _getPositionsTable()
            local p = positions[key]
            if type(p) == "table" and #p >= 4 then
                guiObject.Position = UDim2.new(p[1], p[2], p[3], p[4])
                return true
            end
            return false
        end)
        return ok and loaded or false
    end

    local function saveGuiSize(key, guiObject)
        if not key or not guiObject then return end
        pcall(function()
            local sizes = _getSizesTable()
            sizes[key] = { guiObject.Size.X.Offset, guiObject.Size.Y.Offset }
            Config.set("panelSizes", sizes)
            if Config.flush then Config.flush() end
        end)
    end

    local function loadGuiSize(key, guiObject, minW, minH)
        if not key or not guiObject then return false end
        local ok, loaded = pcall(function()
            local sizes = _getSizesTable()
            local s = sizes[key]
            if type(s) == "table" and s[1] and s[2] then
                local w = math.max(minW or 80, tonumber(s[1]) or 0)
                local h = math.max(minH or 60, tonumber(s[2]) or 0)
                if w > 50 and h > 40 then
                    guiObject.Size = UDim2.new(0, w, 0, h)
                    return true
                end
            end
            return false
        end)
        return ok and loaded or false
    end

    local function makePanelDraggable(handle, target, saveKey)
        if not handle or not target then return end

        handle.Active = true
        target.Active = true
        pcall(function() handle.Selectable = true end)
        pcall(function() target.Selectable = true end)

        local dragBtn = handle:FindFirstChild("DragHandleBtn")
        if dragBtn then pcall(function() dragBtn:Destroy() end) end
        dragBtn = Instance.new("TextButton")
        dragBtn.Name = "DragHandleBtn"
        dragBtn.Size = UDim2.new(1, 0, 1, 0)
        dragBtn.Position = UDim2.new(0, 0, 0, 0)
        dragBtn.BackgroundTransparency = 1
        dragBtn.Text = ""
        dragBtn.AutoButtonColor = false
        dragBtn.Active = true
        dragBtn.Selectable = true
        dragBtn.Modal = false
        dragBtn.ZIndex = math.max((handle.ZIndex or 1) + 8, 50)
        dragBtn.Parent = handle

        local function raiseControls()
            local topZ = dragBtn.ZIndex + 10
            for _, ch in ipairs(handle:GetChildren()) do
                if ch == dragBtn then
                    -- skip
                elseif ch:IsA("GuiButton") then
                    ch.ZIndex = topZ
                    ch.Active = true
                    ch.Selectable = true
                elseif ch:IsA("Frame") or ch:IsA("ImageLabel") or ch:IsA("TextLabel") then
                    -- Raise frames that host interactive controls (color dots, etc.)
                    local hasBtn = false
                    for _, d in ipairs(ch:GetDescendants()) do
                        if d:IsA("GuiButton") then
                            hasBtn = true
                            d.ZIndex = topZ + 2
                            d.Active = true
                            d.Selectable = true
                        end
                    end
                    if hasBtn then
                        ch.ZIndex = topZ + 1
                        ch.Active = true
                    elseif ch:IsA("TextLabel") or ch:IsA("ImageLabel") then
                        ch.Active = false
                        if (ch.ZIndex or 0) >= dragBtn.ZIndex then
                            ch.ZIndex = math.max(1, dragBtn.ZIndex - 1)
                        end
                    end
                end
            end
        end
        raiseControls()
        task.defer(raiseControls)
        pcall(function()
            handle.ChildAdded:Connect(function() task.defer(raiseControls) end)
        end)

        local dragging = false
        local dragInput = nil
        local dragStart = nil -- Vector2 screen
        local startPos = nil  -- UDim2
        local startAbs = nil  -- Vector2

        local function getSelfScale()
            local sc = target:FindFirstChildOfClass("UIScale")
            local s = (sc and tonumber(sc.Scale)) or 1
            if s < 0.05 then s = 1 end
            return s
        end

        local function savePos()
            if not saveKey then return end
            pcall(function()
                if saveGuiPosition then
                    saveGuiPosition(saveKey, target)
                elseif Config then
                    local positions = Config.get("positions", {}) or {}
                    if type(positions) ~= "table" then positions = {} end
                    positions[saveKey] = {
                        target.Position.X.Scale, target.Position.X.Offset,
                        target.Position.Y.Scale, target.Position.Y.Offset,
                    }
                    Config.set("positions", positions)
                end
            end)
        end

        local function pointInHandle(screenPos)
            if not handle or not handle.Parent then return false end
            local ap = handle.AbsolutePosition
            local as = handle.AbsoluteSize
            if as.X < 2 or as.Y < 2 then return false end
            local pad = (UserInputService.TouchEnabled and 12) or 2
            return screenPos.X >= (ap.X - pad)
                and screenPos.X <= (ap.X + as.X + pad)
                and screenPos.Y >= (ap.Y - pad)
                and screenPos.Y <= (ap.Y + as.Y + pad)
        end

        local function isInteractiveChild(screenPos)
            local function hit(obj)
                if not obj or not obj.Visible then return false end
                local ap = obj.AbsolutePosition
                local as = obj.AbsoluteSize
                if as.X <= 0 or as.Y <= 0 then return false end
                return screenPos.X >= ap.X and screenPos.X <= ap.X + as.X
                    and screenPos.Y >= ap.Y and screenPos.Y <= ap.Y + as.Y
            end
            for _, ch in ipairs(handle:GetChildren()) do
                if ch == dragBtn then
                    -- skip
                elseif ch:IsA("GuiButton") and ch.Visible then
                    if hit(ch) then return true end
                elseif ch:IsA("GuiObject") and ch.Visible then
                    -- Nested buttons (color dots live in Frames)
                    if hit(ch) then
                        for _, d in ipairs(ch:GetDescendants()) do
                            if d:IsA("GuiButton") and d.Visible then
                                return true
                            end
                        end
                        -- Also treat the frame itself as interactive if it hosts buttons
                        for _, d in ipairs(ch:GetChildren()) do
                            if d:IsA("GuiButton") then return true end
                        end
                    end
                end
            end
            return false
        end

        local function toV2(p)
            if p == nil then return Vector2.zero end
            local ty = typeof(p)
            if ty == "Vector2" then return p end
            if ty == "Vector3" then return Vector2.new(p.X, p.Y) end
            if type(p) == "table" and p.X ~= nil and p.Y ~= nil then
                return Vector2.new(tonumber(p.X) or 0, tonumber(p.Y) or 0)
            end
            return Vector2.zero
        end

        local function beginAt(screenPos, inp)
            if _G._FH_GuiLocked then return false end
            if not target or not target.Parent then return false end
            local pos2 = toV2(screenPos)
            if isInteractiveChild(pos2) then return false end
            dragging = true
            dragInput = inp
            dragStart = pos2
            startPos = target.Position
            startAbs = target.AbsolutePosition -- Vector2
            return true
        end

        local function updateAt(screenPos)
            if not dragging or not dragStart or not startPos then return end
            if _G._FH_GuiLocked then
                dragging = false
                dragInput = nil
                return
            end
            local pos2 = toV2(screenPos)
            local d = pos2 - dragStart -- both Vector2
            local scale = getSelfScale()
            local cam = workspace.CurrentCamera
            local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
            local sz = target.AbsoluteSize

            local baseX = (startAbs and startAbs.X) or 0
            local baseY = (startAbs and startAbs.Y) or 0
            local newAbsX = math.clamp(baseX + d.X, -math.max(40, sz.X - 40), math.max(0, vp.X - 40))
            local newAbsY = math.clamp(baseY + d.Y, 0, math.max(0, vp.Y - 24))
            local adjX = newAbsX - baseX
            local adjY = newAbsY - baseY

            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + adjX / scale,
                startPos.Y.Scale, startPos.Y.Offset + adjY / scale
            )
        end

        local function finish()
            if not dragging then return end
            dragging = false
            dragInput = nil
            savePos()
        end

        local function isPress(inp)
            if not inp then return false end
            local t = inp.UserInputType
            return t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch
        end

        local function isMove(inp)
            if not inp then return false end
            local t = inp.UserInputType
            return t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch
        end

        dragBtn.InputBegan:Connect(function(inp)
            if isPress(inp) then
                beginAt(inp.Position, inp)
            end
        end)
        handle.InputBegan:Connect(function(inp)
            if isPress(inp) then
                beginAt(inp.Position, inp)
            end
        end)
        dragBtn.InputEnded:Connect(function(inp)
            if isPress(inp) then finish() end
        end)
        handle.InputEnded:Connect(function(inp)
            if isPress(inp) then finish() end
        end)

        UserInputService.InputBegan:Connect(function(inp, gp)
            if dragging then return end
            if not isPress(inp) then return end
            if gp and inp.UserInputType ~= Enum.UserInputType.Touch then
            end
            local pos = inp.Position
            if pointInHandle(pos) then
                beginAt(pos, inp)
            end
        end)

        UserInputService.InputChanged:Connect(function(inp)
            if not dragging then return end
            if not isMove(inp) then return end
            if dragInput and inp.UserInputType == Enum.UserInputType.Touch and inp ~= dragInput then
            end
            updateAt(inp.Position)
        end)

        UserInputService.InputEnded:Connect(function(inp)
            if not dragging then return end
            if isPress(inp) then
                finish()
            end
        end)

        pcall(function()
            dragBtn.MouseButton1Down:Connect(function()
                if _G._FH_GuiLocked then return end
                local pos = UserInputService:GetMouseLocation()
                beginAt(pos, nil)
            end)
            dragBtn.MouseButton1Up:Connect(function()
                finish()
            end)
        end)

        pcall(function()
            if UserInputService.TouchMoved then
                UserInputService.TouchMoved:Connect(function(touch, gp)
                    if not dragging then return end
                    updateAt(touch.Position)
                end)
            end
            if UserInputService.TouchEnded then
                UserInputService.TouchEnded:Connect(function(touch, gp)
                    if dragging then finish() end
                end)
            end
        end)

        pcall(function()
            table.insert(_G._FH_DragClearers, function()
                dragging = false
                dragInput = nil
            end)
        end)
    end

    _G.makePanelDraggable = makePanelDraggable

    local function makeDraggable(handle, target, saveKey)
        if not handle or not target then return end
        local UIS = UserInputService
        local dragging, dragStart, startPos = false, nil, nil
        handle.Active = true
        pcall(function()
            if saveKey then loadGuiPosition(saveKey, target) end
        end)
        handle.InputBegan:Connect(function(input)
            if _G._FH_GuiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = target.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragging then
                            dragging = false
                            if saveKey then
                                saveGuiPosition(saveKey, target)
                            end
                        end
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if _G._FH_GuiLocked then dragging = false; return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local p = input.Position
                local ds = dragStart
                local dx = (typeof(p) == "Vector3" and p.X or p.X) - (typeof(ds) == "Vector3" and ds.X or (ds and ds.X) or 0)
                local dy = (typeof(p) == "Vector3" and p.Y or p.Y) - (typeof(ds) == "Vector3" and ds.Y or (ds and ds.Y) or 0)
                local sc = target:FindFirstChildOfClass("UIScale")
                local scale = (sc and tonumber(sc.Scale)) or 1
                if scale < 0.05 then scale = 1 end
                target.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + dx / scale,
                    startPos.Y.Scale, startPos.Y.Offset + dy / scale)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    if saveKey then
                        saveGuiPosition(saveKey, target)
                    end
                end
            end
        end)
    end

    _G._CyutsudSave = {
        setToggle = setToggleSaved,
        getToggle = getToggleSaved,
        savePos = saveGuiPosition,
        loadPos = loadGuiPosition,
        saveSize = saveGuiSize,
        loadSize = loadGuiSize,
        makeDraggable = makeDraggable,
    }

    local function reapplyAllSavedToggles()
        local applied = 0
        local toggles = _getTogglesTable()
        pcall(function()
            if type(Config.data) == "table" then
                for k, v in pairs(Config.data) do
                    if type(k) == "string" and k:sub(1, 7) == "toggle:" then
                        local name = k:sub(8)
                        if name ~= "" and toggles[name] == nil then
                            toggles[name] = v and true or false
                        end
                    end
                end
            end
        end)
        pcall(function()
            if toggles["Auto Giant Potion"] == nil then
                local isv2 = Config.get("isv2_autoPotion", nil)
                if isv2 ~= nil then toggles["Auto Giant Potion"] = isv2 and true or false end
            end
            if toggles["Auto Giant Potion"] == nil then
                local ag = Config.get("auto_giant_potion", nil)
                if ag ~= nil then toggles["Auto Giant Potion"] = ag and true or false end
            end
            if toggles["Giant Potion Speed"] == nil then
                local g1 = Config.get("giant_potion_speed", nil)
                if g1 ~= nil then toggles["Giant Potion Speed"] = g1 and true or false end
            end
            if toggles["Giant Potion Speed"] == nil then
                local g2 = Config.get("gps_enabled", nil)
                if g2 ~= nil then toggles["Giant Potion Speed"] = g2 and true or false end
            end
            if toggles["PaintBall Bypass"] == nil then
                local p1 = Config.get("paintball_bypass", nil)
                if p1 ~= nil then toggles["PaintBall Bypass"] = p1 and true or false end
            end
            if toggles["PaintBall Bypass"] == nil then
                local p2 = Config.get("anti_paintball", nil)
                if p2 ~= nil then toggles["PaintBall Bypass"] = p2 and true or false end
            end
            if toggles["PaintBall Bypass"] == nil and toggles["Anti Paintball"] ~= nil then
                toggles["PaintBall Bypass"] = toggles["Anti Paintball"] and true or false
            end
        end)

        local reg = _G._CyutsudToggleReg or {}
        local cbs = _G._CyutsudToggleCallbacks or {}
        for name, state in pairs(toggles) do
            if state == true then
                local ctrl = reg[name]
                if ctrl and ctrl.set then
                    pcall(function() ctrl.set(true, false) end) -- not silent → fire callback
                    applied = applied + 1
                else
                    local cb = cbs[name]
                    if type(cb) == "function" then
                        pcall(cb, true)
                        applied = applied + 1
                    else
                        pcall(function() Config.set("toggle:" .. name, true) end)
                    end
                end
            end
        end
        return applied
    end
    _G._CyutsudReapplyToggles = reapplyAllSavedToggles

    _G._CyutsudToggleCallbacks = _G._CyutsudToggleCallbacks or {}
    local function registerToggleCallback(label, callback)
        if type(label) ~= "string" or label == "" then return end
        if type(callback) ~= "function" then return end
        _G._CyutsudToggleCallbacks[label] = callback
        task.defer(function()
            local want = false
            pcall(function()
                if getToggleSaved then want = getToggleSaved(label, false) end
            end)
            if want then
                pcall(callback, true)
            end
        end)
    end
    _G._CyutsudRegisterToggleCallback = registerToggleCallback

    local Vis = { open = true, set = nil, rootScale = nil }
    _G._FH_Vis = Vis
    local visible = true
    local setVisible

    local function _toggleHubVisible()
        local fn = Vis.set or setVisible or _G._FH_SetVisible
        local cur
        if Vis and Vis.open ~= nil then
            cur = Vis.open and true or false
        else
            cur = visible and true or false
        end
        if Root and Root.Parent then
            if Root.Visible and (not Vis.rootScale or Vis.rootScale.Scale > 0.05) then
                cur = true
            elseif not Root.Visible then
                cur = false
            end
        end
        if type(fn) == "function" then
            pcall(fn, not cur)
            return
        end
        if Root then
            local show = not (Root.Visible and true or false)
            Root.Visible = show
            Vis.open = show
            visible = show
            local sc = Vis.rootScale or rootScale
            if sc then
                sc.Scale = show and (_UI.desiredScale or 1) or 0
            end
        end
    end
    _G._FH_ToggleHub = _toggleHubVisible

    local ReopenGui = Instance.new("ScreenGui")
    ReopenGui.Name = "CyutsudHubReopen"
    ReopenGui.ResetOnSpawn = false
    ReopenGui.IgnoreGuiInset = true
    ReopenGui.DisplayOrder = 1000000
    ReopenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ReopenGui.Enabled = true
    pcall(function()
        if typeof(gethui) == "function" then
            ReopenGui.Parent = gethui()
        end
    end)
    if not ReopenGui.Parent then
        pcall(function()
            local cg = game:GetService("CoreGui")
            ReopenGui.Parent = cg
        end)
    end
    if not ReopenGui.Parent then
        local lp = Players.LocalPlayer
        local pg = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
        ReopenGui.Parent = pg or GUI
    end
    ReopenGui.AncestryChanged:Connect(function()
        if ReopenGui.Parent ~= nil then return end
        task.defer(function()
            pcall(function()
                if typeof(gethui) == "function" then ReopenGui.Parent = gethui() end
            end)
            if not ReopenGui.Parent then
                pcall(function() ReopenGui.Parent = game:GetService("CoreGui") end)
            end
            if not ReopenGui.Parent then
                local lp = Players.LocalPlayer
                local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
                if pg then ReopenGui.Parent = pg end
            end
        end)
    end)

    local _pillW = isMobile and (isPhone and 96 or 100) or 88
    local _pillH = isMobile and (isPhone and 40 or 38) or 34

    local ReopenBtn = Instance.new("TextButton")
    ReopenBtn.Name                   = "NoxReopenBtn"
    ReopenBtn.Size                   = UDim2.new(0, _pillW, 0, _pillH)
    ReopenBtn.Position               = UDim2.new(0, 8, 0.5, -math.floor(_pillH / 2))
    ReopenBtn.BackgroundColor3       = Color3.fromRGB(168, 85, 247)
    ReopenBtn.BorderSizePixel        = 0
    ReopenBtn.Text                   = "CYUTSUD"
    ReopenBtn.Font                   = Enum.Font.GothamBlack
    ReopenBtn.TextSize               = isMobile and 13 or 12
    ReopenBtn.TextColor3             = Color3.fromRGB(12, 6, 22)
    ReopenBtn.AutoButtonColor        = false
    ReopenBtn.Active                 = true
    ReopenBtn.Selectable             = true
    ReopenBtn.Visible                = true
    ReopenBtn.ZIndex                 = 10
    ReopenBtn.ClipsDescendants       = false
    ReopenBtn.Parent                 = ReopenGui
    local hitPad = Instance.new("TextButton")
    hitPad.Name = "HitPad"
    hitPad.Size = UDim2.new(1, isMobile and 24 or 8, 1, isMobile and 20 or 8)
    hitPad.Position = UDim2.new(0.5, 0, 0.5, 0)
    hitPad.AnchorPoint = Vector2.new(0.5, 0.5)
    hitPad.BackgroundTransparency = 1
    hitPad.Text = ""
    hitPad.AutoButtonColor = false
    hitPad.Active = true
    hitPad.ZIndex = 11
    hitPad.Parent = ReopenBtn
    _newScale(ReopenBtn)
    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0) -- full pill
        c.Parent = ReopenBtn
    end
    Stroke(ReopenBtn, Color3.fromRGB(0, 0, 0), 1.5, 0.2)
    ReopenBtn.MouseEnter:Connect(function() Tween(ReopenBtn, F, {BackgroundColor3 = Color3.fromRGB(192, 132, 252)}) end)
    ReopenBtn.MouseLeave:Connect(function() Tween(ReopenBtn, F, {BackgroundColor3 = Color3.fromRGB(168, 85, 247)}) end)

    do
        local lastToggleAt = 0
        local function onClick()
            local now = tick()
            if now - lastToggleAt < 0.3 then return end
            lastToggleAt = now

            -- Use the actual GUI state so CYUTSUD reliably opens the main menu.
            local isOpen = Root and Root.Visible == true
            if isOpen and rootScale and rootScale.Scale <= 0.05 then
                isOpen = false
            end
            local fn = (Vis and Vis.set) or setVisible or _G._FH_SetVisible
            if type(fn) == "function" then
                pcall(fn, not isOpen)
            elseif Root then
                local show = not isOpen
                Root.Visible = show
                if Vis then Vis.open = show end
                visible = show
                local sc = (Vis and Vis.rootScale) or rootScale
                if sc then sc.Scale = show and (_UI.desiredScale or 1) or 0 end
            end
        end

        local function wireBtn(btn)
            btn.Activated:Connect(onClick)
        end
        wireBtn(ReopenBtn)
        wireBtn(hitPad)

        pcall(function()
            if UserInputService.TouchTap then
                UserInputService.TouchTap:Connect(function(positions, gp)
                    if gp then return end
                    if not positions or #positions < 1 then return end
                    local pos = positions[1]
                    local abs = ReopenBtn.AbsolutePosition
                    local siz = ReopenBtn.AbsoluteSize
                    local pad = isMobile and 16 or 4
                    if pos.X >= abs.X - pad and pos.X <= abs.X + siz.X + pad
                        and pos.Y >= abs.Y - pad and pos.Y <= abs.Y + siz.Y + pad then
                        onClick()
                    end
                end)
            end
        end)
    end

    _G._FH_ReopenBtn = ReopenBtn
    _G._FH_ReopenGui = ReopenGui

    do
        TopBar.Active = true
        Root.Active = true
        pcall(function() TopBar.Selectable = true end)
        pcall(function() Root.Selectable = true end)
        task.defer(function()
            pcall(function()
                local drag = _G.makePanelDraggable or makePanelDraggable
                if drag then
                    drag(Side, Root, "CyutsudHub_Root")
                    drag(TopBar, Root, "CyutsudHub_Root")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                if loadGuiPosition and loadGuiPosition("CyutsudHub_Root", Root) then
                    Root.AnchorPoint = Vector2.new(0, 0)
                    return
                end
                local rp = Config.get("root_pos", nil)
                if type(rp) == "table" and #rp >= 4 then
                    Root.AnchorPoint = Vector2.new(0, 0)
                    Root.Position = UDim2.new(rp[1], rp[2], rp[3], rp[4])
                end
            end)
        end)
    end

    local Pages = Instance.new("Frame")
    Pages.Size                   = UDim2.new(1, 0, 1, -(30 + 22))
    Pages.Position               = UDim2.new(0, 0, 0, 30)
    Pages.BackgroundTransparency = 1
    Pages.ClipsDescendants       = true
    Pages.ZIndex                 = 3
    Pages.Parent                 = Content

    local StatusBar = Instance.new("Frame")
    StatusBar.Name                   = "StatusBar"
    StatusBar.Size                   = UDim2.new(1, 0, 0, 22)
    StatusBar.Position               = UDim2.new(0, 0, 1, -22)
    StatusBar.BackgroundColor3       = Color3.fromRGB(10, 6, 16)
    StatusBar.BorderSizePixel        = 0
    StatusBar.ZIndex                 = 5
    StatusBar.Parent                 = Content

    local _sbTop = Instance.new("Frame")
    _sbTop.Size             = UDim2.new(1, 0, 0, 1)
    _sbTop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _sbTop.BorderSizePixel  = 0
    _sbTop.ZIndex           = 6
    _sbTop.Parent           = StatusBar

    local _sbStats = Instance.new("TextLabel")
    _sbStats.Size                   = UDim2.new(0, 180, 1, 0)
    _sbStats.Position               = UDim2.new(0, 10, 0, 0)
    _sbStats.BackgroundTransparency = 1
    _sbStats.Text                   = "FPS: --   PING: --ms"
    _sbStats.TextSize               = 9
    _sbStats.Font                   = Enum.Font.GothamMedium
    _sbStats.TextColor3             = Color3.fromRGB(170, 150, 200)
    _sbStats.TextXAlignment         = Enum.TextXAlignment.Left
    _sbStats.TextYAlignment         = Enum.TextYAlignment.Center
    _sbStats.ZIndex                 = 6
    _sbStats.Parent                 = StatusBar

    local _sbDot = Instance.new("Frame")
    _sbDot.Size             = UDim2.new(0, 7, 0, 7)
    _sbDot.Position         = UDim2.new(1, -50, 0.5, -3)
    _sbDot.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    _sbDot.BorderSizePixel  = 0
    _sbDot.ZIndex           = 6
    _sbDot.Parent           = StatusBar
    local _sbDotCorner = Instance.new("UICorner")
    _sbDotCorner.CornerRadius = UDim.new(1, 0)
    _sbDotCorner.Parent = _sbDot

    local _sbOnLbl = Instance.new("TextLabel")
    _sbOnLbl.Size                   = UDim2.new(0, 30, 1, 0)
    _sbOnLbl.Position               = UDim2.new(1, -40, 0, 0)
    _sbOnLbl.BackgroundTransparency = 1
    _sbOnLbl.Text                   = "ON"
    _sbOnLbl.TextSize               = 9
    _sbOnLbl.Font                   = Enum.Font.GothamBold
    _sbOnLbl.TextColor3             = Color3.fromRGB(168, 85, 247)
    _sbOnLbl.TextXAlignment         = Enum.TextXAlignment.Left
    _sbOnLbl.TextYAlignment         = Enum.TextYAlignment.Center
    _sbOnLbl.ZIndex                 = 6
    _sbOnLbl.Parent                 = StatusBar

    local _statsConn
    _statsConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        if _GEN ~= _G._FH_CYUTSUD_GEN then _statsConn:Disconnect(); return end

        _sharedFc = _sharedFc + 1
        _sharedFt = _sharedFt + dt
        if _sharedFt >= 1 then
            _sharedFps = math.floor(_sharedFc / _sharedFt)
            _sharedFc, _sharedFt = 0, 0
            local ping = math.floor(((Players.LocalPlayer and Players.LocalPlayer:GetNetworkPing()) or 0) * 1000)
            local txt = "FPS: " .. _sharedFps .. "   PING: " .. ping .. "ms"
            if txt ~= _bannerLast then
                _bannerLast = txt
                if _bannerStatsRef then pcall(_bannerStatsRef, _sharedFps, ping) end
                _sbStats.Text = txt
            end
        end

        if not isMobile then
            _sharedFlowPhase = (_sharedFlowPhase + dt * 0.4) % 1
            _gradAccum = _gradAccum + dt
            if _gradAccum < _GRAD_TICK then return end
            _gradAccum = 0
            _gradPhase = (_gradPhase + _GRAD_TICK * 90) % 360
            local n = #ThemeGrads
            if n == 0 then return end
            for i = 1, n do
                local e = ThemeGrads[i]
                local g = e.grad
                if g and g.Parent and g.Parent.Parent then
                    local r = e.baseRot + _gradPhase * e.speed
                    if g.Rotation ~= r then g.Rotation = r end
                end
            end
        end
    end))

    local function Scroll(parent)
        local s = Instance.new("ScrollingFrame")
        s.Size                  = UDim2.new(1, 0, 1, 0)
        s.BackgroundTransparency = 1
        s.BorderSizePixel       = 0
        s.ScrollBarThickness    = 2
        s.ScrollBarImageColor3  = T.White
        s.ScrollBarImageTransparency = 0
        s.CanvasSize            = UDim2.new(0, 0, 0, 0)
        s.AutomaticCanvasSize   = Enum.AutomaticSize.Y
        s.ScrollingDirection    = Enum.ScrollingDirection.Y
        s.ZIndex                = 3
        s.Parent                = parent
        local l = Instance.new("UIListLayout")
        l.FillDirection       = Enum.FillDirection.Vertical
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
        l.SortOrder           = Enum.SortOrder.LayoutOrder
        l.Padding             = UDim.new(0, 5)
        l.Parent              = s
        Pad(s, 10, 12, 8, 8)
        return s, l
    end

    local Tabs = {}
    local Active = nil
    local Swapping = false
    local _swapGen = 0

    local function setPage(t)
        if Active == t or Swapping then return end
        Swapping = true
        _swapGen = _swapGen + 1
        local myGen = _swapGen
        local function doneSwap()
            if _swapGen == myGen then Swapping = false end
        end
        task.delay(0.7, doneSwap)

        local old = Active
        Active = t
        if old then
            Tween(old.btn, F, {BackgroundColor3 = T.Soft, BackgroundTransparency = 0.5})
            Tween(old.lbl, F, {TextColor3       = T.TextDim})
            Tween(old.dot, F, {BackgroundTransparency = 1})
        end
        Tween(t.btn, F, {BackgroundColor3 = T.Primary, BackgroundTransparency = 0})
        Tween(t.lbl, F, {TextColor3       = Color3.fromRGB(12, 6, 22)})
        Tween(t.dot, F, {BackgroundTransparency = 1})
        PageTitle.Text = t.title
        if old then
            local isCG = pcall(function() return old.canvas:IsA("CanvasGroup") end) and old.canvas:IsA("CanvasGroup")
            if isCG then
                local fadeOut = TweenService:Create(old.canvas, PG, {GroupTransparency = 1})
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    pcall(function() old.page.Visible = false end)
                    local tCG = pcall(function() return t.canvas:IsA("CanvasGroup") end) and t.canvas:IsA("CanvasGroup")
                    pcall(function()
                        if tCG then t.canvas.GroupTransparency = 1 end
                        t.page.Visible = true
                    end)
                    if tCG then
                        local fadeIn = TweenService:Create(t.canvas, PG, {GroupTransparency = 0})
                        fadeIn:Play()
                        fadeIn.Completed:Connect(doneSwap)
                    else
                        doneSwap()
                    end
                end)
            else
                pcall(function() old.page.Visible = false end)
                pcall(function() t.page.Visible   = true  end)
                doneSwap()
            end
        else
            pcall(function()
                t.page.Visible = true
                local tCG = pcall(function() return t.canvas:IsA("CanvasGroup") end) and t.canvas:IsA("CanvasGroup")
                if tCG then t.canvas.GroupTransparency = 0 end
            end)
            doneSwap()
        end
    end

    local function Nav(name, title)
        local btn = Instance.new("TextButton")
        btn.Size                   = UDim2.new(0, isMobile and 56 or 72, 0, isMobile and 26 or 28)
        btn.BackgroundColor3       = T.Soft
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel        = 0
        btn.Text                   = ""
        btn.AutoButtonColor        = false
        btn.ZIndex                 = 5
        btn.Parent                 = NavList
        Corner(btn, 12)

        local dot = Instance.new("Frame")
        dot.Size                   = UDim2.new(0, 0, 0, 0)
        dot.BackgroundTransparency = 1
        dot.BorderSizePixel        = 0
        dot.ZIndex                 = 6
        dot.Parent                 = btn
        Corner(dot, 12)

        local lbl = Lbl(btn, name, isMobile and 10 or 11, T.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        lbl.Size           = UDim2.new(1, 0, 1, 0)
        lbl.Position       = UDim2.new(0, 0, 0, 0)
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.ZIndex         = 6

        local page = Instance.new("Frame")
        page.Size                   = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible                = false
        page.ZIndex                 = 3
        page.Parent                 = Pages

        local canvas
        local _cgOk = pcall(function()
            canvas = Instance.new("CanvasGroup")
            canvas.GroupTransparency = 0
        end)
        if not _cgOk then
            canvas = Instance.new("Frame")
        end
        canvas.Size                   = UDim2.new(1, 0, 1, 0)
        canvas.BackgroundTransparency = 1
        canvas.ZIndex                 = 3
        canvas.Parent                 = page

        local scroll = Scroll(canvas)
        local t = {btn = btn, lbl = lbl, dot = dot, page = page, canvas = canvas, scroll = scroll, title = title}

        btn.MouseEnter:Connect(function()
            if Active ~= t then Tween(btn, F, {BackgroundTransparency = 0.15, BackgroundColor3 = T.SideHover}) end
        end)
        btn.MouseLeave:Connect(function()
            if Active ~= t then Tween(btn, F, {BackgroundTransparency = 0.5, BackgroundColor3 = T.Soft}) end
        end)
        btn.Activated:Connect(function() setPage(t) end)

        table.insert(Tabs, t)
        return t
    end

    local function Section(parent, title)
        local f = Instance.new("Frame")
        f.Name                   = "Section_" .. tostring(title):gsub("%W", "_")
        f.Size                   = UDim2.new(1, -10, 0, isMobile and 22 or 26)
        f.BackgroundTransparency = 1
        f.Parent                 = parent
        f:SetAttribute("NoxSectionTitle", tostring(title))
        local lbl = Lbl(f, title:upper(), 9, T.Primary, Enum.Font.GothamBlack)
        lbl.Name           = "SectionLabel"
        lbl.Size           = UDim2.new(0, 0, 1, 0)
        lbl.Position       = UDim2.new(0, 6, 0, 0)
        lbl.AutomaticSize  = Enum.AutomaticSize.X
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0, 0.5)
        line.Position = UDim2.new(0, 0, 0.5, 0)
        line.Size = UDim2.new(1, -12, 0, 1)
        line.BackgroundColor3 = T.Primary
        line.BackgroundTransparency = 0.75
        line.BorderSizePixel = 0
        line.ZIndex = 3
        line.Parent = f
        lbl.ZIndex = 4
        local bg = Instance.new("Frame")
        bg.BackgroundColor3 = T.Bg
        bg.BackgroundTransparency = 0.15
        bg.BorderSizePixel = 0
        bg.Size = UDim2.new(1, 10, 1, 0)
        bg.Position = UDim2.new(0, -4, 0, 0)
        bg.ZIndex = 3
        bg.Parent = lbl
        trackBgFrame(bg, "Bg")
        -- Registry for All Gear empty-category hiding
        _G._CyutsudSectionReg = _G._CyutsudSectionReg or {}
        _G._CyutsudSectionReg[tostring(title)] = f
        _G._CyutsudSectionReg[string.upper(tostring(title))] = f
    end

    local function Card(parent, h)
        local card = Instance.new("Frame")
        card.Size             = UDim2.new(1, -10, 0, h)
        card.BackgroundColor3 = T.Card
        trackBgFrame(card, "Card")
        card.BorderSizePixel  = 0
        card.ZIndex           = 4
        card.Parent           = parent
        Corner(card, 12)
        local s = Stroke(card, T.Line, 1, 0.5)
        local hi = Instance.new("Frame")
        hi.Size = UDim2.new(1, -16, 0, 1)
        hi.Position = UDim2.new(0, 8, 0, 1)
        hi.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hi.BackgroundTransparency = 0.92
        hi.BorderSizePixel = 0
        hi.ZIndex = 5
        hi.Parent = card
        card.MouseEnter:Connect(function()
            Tween(card, F, {BackgroundColor3 = T.CardHover})
            Tween(s,    F, {Transparency = 0.2, Color = T.Primary})
            Tween(hi,   F, {BackgroundTransparency = 0.82})
        end)
        card.MouseLeave:Connect(function()
            Tween(card, F, {BackgroundColor3 = T.Card})
            Tween(s,    F, {Transparency = 0.5, Color = T.Line})
            Tween(hi,   F, {BackgroundTransparency = 0.92})
        end)
        return card, s
    end

    do
        _G._FH_SaveLock = function(state)
            pcall(function() Config.set("gui_locked", state and true or false) end)
        end
        if Config.get("gui_locked", false) == true then
            guiLocked = true
            _G._FH_GuiLocked = true
            local lb = _G._FH_LockBtn
            if lb then
                lb.Text       = "�"
                lb.TextColor3 = Color3.fromRGB(196, 181, 253)
            end
        end
    end

    do
        local function loadCol(key, default)
            local t = Config.get(key, nil)
            if type(t) == "table" and #t == 3 then
                return Color3.fromRGB(t[1], t[2], t[3])
            end
            return default
        end
        Theme.c1 = loadCol("theme_c1", Theme.c1)
        Theme.c2 = loadCol("theme_c2", Theme.c2)
        T.Primary = Theme.c1
        T.Green = Theme.c1
        if Dot1 then Dot1.BackgroundColor3 = Theme.c1 end
        pcall(function()
            if SetAccentColor then SetAccentColor(Theme.c1) end
        end)
        local _savedBg = loadCol("theme_bg", nil)
        if _savedBg then
            SetGuiColor(_savedBg)
            if Dot2 then Dot2.BackgroundColor3 = T.Bg end
        end
        pcall(Repaint)
    end

    _G._FH_BindingKey = false
    _G._FH_JustBoundKey = nil
    _G._FH_JustBoundUntil = 0

    function _G._FH_BeginBind()
        _G._FH_BindingKey = true
    end

    function _G._FH_EndBind(keyName)
        if keyName and keyName ~= "Backspace" and keyName ~= "Space" and keyName ~= "Delete" then
            _G._FH_JustBoundKey = keyName
            _G._FH_JustBoundUntil = tick() + 0.6
        end
        task.delay(0.05, function()
            _G._FH_BindingKey = false
        end)
    end

    function _G._FH_ShouldIgnoreKey(keyName)
        if _G._FH_BindingKey then return true end
        if keyName and _G._FH_JustBoundKey == keyName and tick() < (_G._FH_JustBoundUntil or 0) then
            return true
        end
        return false
    end

    pcall(function()
        UserInputService.JumpRequest:Connect(function()
            if not _G._FH_BindingKey then return end
            local char = Players.LocalPlayer and Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Jump = false
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false) end)
                task.defer(function()
                    if not _G._FH_BindingKey and hum then
                        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end)
                    end
                end)
            end
        end)
    end)

    local function _CyutsudIsGamepadInput(input)
        if not input then return false end
        local t = input.UserInputType
        return t == Enum.UserInputType.Gamepad1
            or t == Enum.UserInputType.Gamepad2
            or t == Enum.UserInputType.Gamepad3
            or t == Enum.UserInputType.Gamepad4
            or t == Enum.UserInputType.Gamepad5
            or t == Enum.UserInputType.Gamepad6
            or t == Enum.UserInputType.Gamepad7
            or t == Enum.UserInputType.Gamepad8
    end

    local function _CyutsudIsBindInput(input)
        if not input then return false end
        if input.UserInputType == Enum.UserInputType.Keyboard then return true end
        return _CyutsudIsGamepadInput(input)
    end

    local function _CyutsudIsClearBindKey(input)
        local k = input and input.KeyCode
        if not k then return false end
        return k == Enum.KeyCode.Backspace or k == Enum.KeyCode.Space
            or k == Enum.KeyCode.Delete or k == Enum.KeyCode.ButtonSelect
    end

    local function _CyutsudIsIgnoredBindKey(input)
        local k = input and input.KeyCode
        if not k then return true end
        if k == Enum.KeyCode.Thumbstick1 or k == Enum.KeyCode.Thumbstick2 then return true end
        if k == Enum.KeyCode.Unknown then return true end
        return false
    end

    local function _CyutsudBindKeyName(input)
        if not input or not input.KeyCode then return nil end
        local name = input.KeyCode.Name
        if not name or name == "Unknown" then return nil end
        return name
    end

    local function _CyutsudShouldBlockBindFire(input, processed)
        if not input then return true end
        if _CyutsudIsGamepadInput(input) then
            return false
        end
        if processed then return true end
        local ok, box = pcall(function()
            return UserInputService:GetFocusedTextBox()
        end)
        if ok and box then return true end
        return false
    end

    local function _CyutsudInputMatchesBind(input, boundName)
        if not boundName or not input then return false end
        if not _CyutsudIsBindInput(input) then return false end
        if _CyutsudIsIgnoredBindKey(input) then return false end
        local name = input.KeyCode and input.KeyCode.Name
        if not name then return false end
        if name == boundName then return true end
        if string.lower(name) == string.lower(tostring(boundName)) then return true end
        return false
    end

    _G._CyutsudIsGamepadInput = _CyutsudIsGamepadInput
    _G._CyutsudIsBindInput = _CyutsudIsBindInput
    _G._CyutsudIsClearBindKey = _CyutsudIsClearBindKey
    _G._CyutsudIsIgnoredBindKey = _CyutsudIsIgnoredBindKey
    _G._CyutsudBindKeyName = _CyutsudBindKeyName
    _G._CyutsudShouldBlockBindFire = _CyutsudShouldBlockBindFire
    _G._CyutsudInputMatchesBind = _CyutsudInputMatchesBind

    local function _kbGetTable()
        local kb = Config.get("keybinds", nil)
        if type(kb) ~= "table" then kb = {} end
        return kb
    end

    local function _kbSet(name, keyName)
        local kb = _kbGetTable()
        if keyName then
            kb[name] = keyName
        else
            kb[name] = nil
        end
        Config.set("keybinds", kb)
        pcall(function() Config.set("keybind:" .. name, keyName) end)
        if Config.flush then pcall(function() Config.flush() end) end
    end

    local function _kbGet(name)
        local kb = _kbGetTable()
        local v = kb[name]
        if type(v) == "string" and v ~= "" then return v end
        local legacy = Config.get("keybind:" .. name, nil)
        if type(legacy) == "string" and legacy ~= "" then
            kb[name] = legacy
            Config.set("keybinds", kb)
            return legacy
        end
        return nil
    end

    local KB_binds = {}

    local function attachKeybind(host, nameLbl, baseName, fireFn)
        local entry = {
            keyName = nil,
            fire = fireFn,
            baseName = baseName,
            nameLbl = nameLbl,
            _capturing = false,
        }

        local function refresh()
            if not nameLbl or not nameLbl.Parent then return end
            pcall(function() nameLbl.RichText = true end)
            if entry._capturing then
                nameLbl.Text = baseName .. ' <font color="rgb(140,140,160)">(key/pad...)</font>'
                return
            end
            if entry.keyName then
                nameLbl.Text = baseName .. ' <font color="rgb(140,140,160)">(' .. entry.keyName .. ')</font>'
            else
                nameLbl.Text = baseName
            end
        end
        entry.refresh = refresh

        entry.keyName = _kbGet(baseName)
        local replaced = false
        for i = #KB_binds, 1, -1 do
            local e = KB_binds[i]
            if e and e.baseName == baseName then
                KB_binds[i] = entry
                replaced = true
                break
            end
        end
        if not replaced then
            table.insert(KB_binds, entry)
        end
        refresh()

        host.MouseButton2Click:Connect(function()
            for _, e in ipairs(KB_binds) do
                if e._capturing then
                    e._capturing = false
                    if e.refresh then e.refresh() end
                end
            end
            entry._capturing = true
            refresh()
            if _G._FH_BeginBind then _G._FH_BeginBind() else _G._FH_BindingKey = true end

            local conn
            conn = UserInputService.InputBegan:Connect(function(input, processed)
                if not _CyutsudIsBindInput(input) then return end
                if _CyutsudIsIgnoredBindKey(input) then return end
                if input.KeyCode == Enum.KeyCode.Escape then
                    conn:Disconnect()
                    entry._capturing = false
                    if _G._FH_EndBind then _G._FH_EndBind(nil) end
                    refresh()
                    return
                end
                conn:Disconnect()
                entry._capturing = false
                if _CyutsudIsClearBindKey(input) then
                    entry.keyName = nil
                    _kbSet(baseName, nil)
                    if _G._FH_EndBind then _G._FH_EndBind(nil) end
                    pcall(function()
                        if showToast then showToast(baseName .. " unbound", false) end
                    end)
                else
                    local name = _CyutsudBindKeyName(input)
                    if not name then
                        if _G._FH_EndBind then _G._FH_EndBind(nil) end
                        refresh()
                        return
                    end
                    entry.keyName = name
                    _kbSet(baseName, name)
                    if _G._FH_EndBind then _G._FH_EndBind(name) end
                    pcall(function()
                        if showToast then showToast(baseName .. " → " .. name, true) end
                    end)
                end
                refresh()
            end)
        end)

        return entry
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if _CyutsudShouldBlockBindFire(input, processed) then return end
        local kcName = input.KeyCode and input.KeyCode.Name
        if _G._FH_ShouldIgnoreKey and kcName and _G._FH_ShouldIgnoreKey(kcName) then return end
        for _, e in ipairs(KB_binds) do
            if e.keyName and _CyutsudInputMatchesBind(input, e.keyName) then
                task.spawn(e.fire)
            end
        end
    end)

    local function showToast(label, state)
    end
    _G.coreNotify = {
        show = function(...) end,
    }

    local _ToggleReg = _G._CyutsudToggleReg or {}
    _G._CyutsudToggleReg = _ToggleReg

    local function Toggle(parent, name, desc, cb)
        local h = 36
        local card = Card(parent, h)
        local nameLbl = Lbl(card, name, 12, T.Text, Enum.Font.GothamBold)
        nameLbl.Size     = UDim2.new(1, -64, 0, 16)
        nameLbl.Position = UDim2.new(0, 12, 0.5, -8)
        nameLbl.ZIndex   = 5

        local function themeAccent()
            return T.Primary or (Theme and Theme.c1) or Color3.fromRGB(168, 85, 247)
        end
        local function themeTrackOff()
            local base = T.Soft or T.BgDeep or Color3.fromRGB(28, 18, 42)
            local h, s, v = Color3.toHSV(base)
            return Color3.fromHSV(h, math.clamp(s * 0.85, 0, 1), math.clamp(v * 0.75, 0.08, 0.45))
        end
        local function themeKnobOff()
            local dim = T.TextDim or Color3.fromRGB(170, 150, 200)
            return dim
        end

        local track = Instance.new("Frame")
        track.Size             = UDim2.new(0, 42, 0, 22)
        track.Position         = UDim2.new(1, -52, 0.5, -11)
        track.BackgroundColor3 = themeTrackOff()
        track.BorderSizePixel  = 0
        track.ZIndex           = 5
        track.Parent           = card
        Corner(track, 12)
        local trackStroke = Stroke(track, Color3.fromRGB(0, 0, 0), 1.2, 0.2)

        local activeFill = Instance.new("Frame")
        activeFill.Size                   = UDim2.new(1, 0, 1, 0)
        activeFill.BackgroundColor3       = themeAccent()
        activeFill.BackgroundTransparency = 1
        activeFill.BorderSizePixel        = 0
        activeFill.ZIndex                 = 6
        activeFill.Parent                 = track
        Corner(activeFill, 12)

        local knob = Instance.new("Frame")
        knob.Size             = UDim2.new(0, 16, 0, 16)
        knob.Position         = UDim2.new(0, 3, 0.5, -8)
        knob.BackgroundColor3 = themeKnobOff()
        knob.BorderSizePixel  = 0
        knob.ZIndex           = 7
        knob.Parent           = track
        local _kc = Instance.new("UICorner")
        _kc.CornerRadius = UDim.new(1, 0)
        _kc.Parent = knob
        local knobStroke = Stroke(knob, Color3.fromRGB(0, 0, 0), 1, 0.7)

        local btn = Instance.new("TextButton")
        btn.Size                   = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text                   = ""
        btn.AutoButtonColor        = false
        btn.ZIndex                 = 8
        btn.Parent                 = card

        local on = false
        local cfgKey = "toggle:" .. name

        local function applyVisual(state, animate)
            on = state and true or false
            local knobOn = UDim2.new(0, 23, 0.5, -8)
            local knobOff = UDim2.new(0, 3, 0.5, -8)
            local acc = themeAccent()
            local trackOff = themeTrackOff()
            local knobOffCol = themeKnobOff()
            if on then
                activeFill.BackgroundColor3 = acc
                if animate then
                    knob.Position = knobOn
                    knob.BackgroundColor3 = (type(_G._CyutsudKnobOnColor) == "function" and _G._CyutsudKnobOnColor() or Color3.fromRGB(255, 255, 255))
                    activeFill.BackgroundTransparency = 0
                    activeFill.BackgroundColor3 = acc
                    local th, ts, tv = Color3.toHSV(acc)
                    track.BackgroundColor3 = Color3.fromHSV(th, math.clamp(ts * 0.7, 0, 1), math.clamp(tv * 0.35, 0.1, 0.55))
                    trackStroke.Color = acc
                    trackStroke.Transparency = 0
                    trackStroke.Thickness = 2.4
                    pcall(function()
                        local TS = game:GetService("TweenService")
                        local tiFast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tiPulse = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TS:Create(knob, tiFast, {
                            Size = UDim2.new(0, 18, 0, 18),
                            Position = UDim2.new(0, 22, 0.5, -9),
                        }):Play()
                        TS:Create(activeFill, tiFast, {
                            BackgroundTransparency = 0,
                            BackgroundColor3 = acc,
                        }):Play()
                        task.delay(0.12, function()
                            if not on then return end
                            TS:Create(knob, tiPulse, {
                                Size = UDim2.new(0, 16, 0, 16),
                                Position = knobOn,
                            }):Play()
                            TS:Create(trackStroke, tiPulse, {
                                Thickness = 1.4,
                                Transparency = 0.05,
                            }):Play()
                        end)
                        local prev = card.BackgroundColor3
                        TS:Create(card, TweenInfo.new(0.12), {
                            BackgroundColor3 = Color3.new(
                                math.min(1, prev.R * 0.55 + acc.R * 0.45),
                                math.min(1, prev.G * 0.55 + acc.G * 0.45),
                                math.min(1, prev.B * 0.55 + acc.B * 0.45)
                            ),
                        }):Play()
                        task.delay(0.16, function()
                            TS:Create(card, TweenInfo.new(0.2), { BackgroundColor3 = prev }):Play()
                        end)
                    end)
                else
                    knob.Position = knobOn
                    knob.Size = UDim2.new(0, 16, 0, 16)
                    knob.BackgroundColor3 = (type(_G._CyutsudKnobOnColor) == "function" and _G._CyutsudKnobOnColor() or Color3.fromRGB(255, 255, 255))
                    activeFill.BackgroundTransparency = 0
                    trackStroke.Color = acc
                    trackStroke.Transparency = 0.05
                    trackStroke.Thickness = 1.4
                    local th, ts, tv = Color3.toHSV(acc)
                    track.BackgroundColor3 = Color3.fromHSV(th, math.clamp(ts * 0.7, 0, 1), math.clamp(tv * 0.35, 0.1, 0.55))
                end
            else
                if animate then
                    pcall(function()
                        local TS = game:GetService("TweenService")
                        local ti = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TS:Create(knob, ti, {
                            Position = knobOff,
                            Size = UDim2.new(0, 16, 0, 16),
                            BackgroundColor3 = knobOffCol,
                        }):Play()
                        TS:Create(activeFill, ti, { BackgroundTransparency = 1 }):Play()
                        TS:Create(trackStroke, ti, {
                            Color = Color3.fromRGB(0, 0, 0),
                            Transparency = 0.2,
                            Thickness = 1.2,
                        }):Play()
                        TS:Create(track, ti, { BackgroundColor3 = trackOff }):Play()
                    end)
                else
                    knob.Position = knobOff
                    knob.Size = UDim2.new(0, 16, 0, 16)
                    knob.BackgroundColor3 = knobOffCol
                    activeFill.BackgroundTransparency = 1
                    trackStroke.Color = Color3.fromRGB(0, 0, 0)
                    trackStroke.Transparency = 0.2
                    trackStroke.Thickness = 1.2
                    track.BackgroundColor3 = trackOff
                end
            end
        end

        local function setState(state)
            applyVisual(state, true)
            if setToggleSaved then
                setToggleSaved(name, on)
            else
                Config.set(cfgKey, on)
            end
            pcall(showToast, name, on)
            if cb then task.spawn(cb, on) end
            pcall(function()
                local cbs = _G._CyutsudToggleCallbacks
                if cbs and type(cbs[name]) == "function" then
                elseif cbs and cb then
                    cbs[name] = cb
                end
            end)
        end

        if type(cb) == "function" then
            pcall(function()
                _G._CyutsudToggleCallbacks = _G._CyutsudToggleCallbacks or {}
                _G._CyutsudToggleCallbacks[name] = cb
            end)
        end

        local function doToggle() setState(not on) end
        btn.Activated:Connect(doToggle)
        attachKeybind(btn, nameLbl, name, doToggle)

        local _wantOn = false
        pcall(function()
            if getToggleSaved then
                _wantOn = getToggleSaved(name, false)
            else
                _wantOn = Config.get(cfgKey, false) == true
            end
        end)
        if _wantOn then
            task.defer(function() pcall(setState, true) end)
        end

        local controller = {
            set = function(s, silent)
                local want = s and true or false
                if want == on then return end
                if silent then
                    on = want
                    applyVisual(want, false)
                    if setToggleSaved then
                        setToggleSaved(name, want)
                    else
                        Config.set(cfgKey, want)
                    end
                else
                    setState(want)
                end
            end,
            get = function() return on end,
            refreshTheme = function()
                pcall(applyVisual, on, false)
                pcall(function()
                    if nameLbl and nameLbl.Parent then
                        nameLbl.TextColor3 = T.Text or Color3.fromRGB(245, 240, 255)
                    end
                end)
            end,
            card = card,
            btn = btn,
            name = name,
        }
        _ToggleReg[name] = controller
        return controller
    end

    local function setToggleUI(name, state, silent)
        local reg = _G._CyutsudToggleReg or _ToggleReg
        local c = reg and reg[name]
        if c and c.set then
            pcall(function() c.set(state, silent ~= false) end)
        else
            pcall(function()
                if setToggleSaved then
                    setToggleSaved(name, state and true or false)
                else
                    Config.set("toggle:" .. name, state and true or false)
                end
            end)
        end
    end
    _G._CyutsudSetToggleUI = setToggleUI

    local function Button(parent, name, desc, cb, _h)
        local hasDesc = desc and desc ~= ""
        local h = _h or (hasDesc and 46 or 36)
        local card = Card(parent, h)
        local nameY = hasDesc and 8 or (h/2 - 8)
        local nameLbl = Lbl(card, name, 12, T.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        nameLbl.Size     = UDim2.new(1, -8, 0, 16)
        nameLbl.Position = UDim2.new(0, 4, 0, nameY)
        nameLbl.ZIndex   = 5

        if hasDesc then
            local d = Lbl(card, desc, 9, T.TextDim, Enum.Font.Gotham, Enum.TextXAlignment.Center)
            d.Size     = UDim2.new(1, 0, 0, 11)
            d.Position = UDim2.new(0, 0, 0, nameY + 14)
            d.ZIndex   = 5
        end

        local btn = Instance.new("TextButton")
        btn.Size                   = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text                   = ""
        btn.AutoButtonColor        = false
        btn.ZIndex                 = 7
        btn.Parent                 = card

        local function press()
            Tween(card, F, {BackgroundColor3 = T.Primary})
            task.delay(0.12, function()
                Tween(card, M, {BackgroundColor3 = T.Card})
            end)
            if cb then task.spawn(cb) end
        end
        btn.Activated:Connect(press)
        attachKeybind(btn, nameLbl, name, press)
    end

    local _SliderReg = {}
    local _activeSliderDrag = nil

    UserInputService.InputChanged:Connect(function(inp)
        local s = _activeSliderDrag
        if not s then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        s.setFromX(inp.Position.X)
    end)

    local function Slider(parent, name, mn, mx, def, cb, step, onCommit)
        local card = Card(parent, 42)
        local v = def or mn
        local _step     = step or 1
        local _decimals = math.max(0, math.ceil(-math.log(math.max(_step, 1e-9)) / math.log(10)))
        local _fmt      = "%." .. _decimals .. "f"

        local nameLbl = Lbl(card, name, 11, T.Text, Enum.Font.GothamBold)
        nameLbl.Size     = UDim2.new(1, -52, 0, 12)
        nameLbl.Position = UDim2.new(0, 10, 0, 6)
        nameLbl.ZIndex   = 5

        local vBox = Instance.new("TextBox")
        vBox.Size                  = UDim2.new(0, 40, 0, 16)
        vBox.Position              = UDim2.new(1, -48, 0, 4)
        vBox.BackgroundColor3      = T.Soft
        trackBgFrame(vBox, "Soft")
        vBox.BorderSizePixel       = 0
        vBox.Text                  = string.format(_fmt, v)
        vBox.Font                  = Enum.Font.GothamBold
        vBox.TextSize              = 10
        vBox.TextColor3            = T.Text
        vBox.TextXAlignment        = Enum.TextXAlignment.Center
        vBox.ClearTextOnFocus      = false
        vBox.ZIndex                = 6
        vBox.Parent                = card
        Corner(vBox, 10)
        local vBoxStroke = GradStroke(vBox, 1, 0.3, 0)

        local trk = Instance.new("Frame")
        trk.Size             = UDim2.new(1, -20, 0, 4)
        trk.Position         = UDim2.new(0, 10, 0, 28)
        trk.BackgroundColor3 = T.Soft
        trk.BorderSizePixel  = 0
        trk.ZIndex           = 5
        trk.Parent           = card
        trackBgFrame(trk, "Soft")
        Corner(trk, 12)

        local frac = (v - mn) / math.max(1, mx - mn)
        local fill = Instance.new("Frame")
        fill.Size            = UDim2.new(frac, 0, 1, 0)
        fill.BorderSizePixel = 0
        fill.ZIndex          = 6
        fill.Parent          = trk
        Corner(fill, 12)
        trackSolid(fill, 1)

        local knob = Instance.new("Frame")
        knob.Size             = UDim2.new(0, 12, 0, 12)
        knob.AnchorPoint      = Vector2.new(0.5, 0.5)
        knob.Position         = UDim2.new(frac, 0, 0.5, 0)
        knob.BackgroundColor3 = T.White
        knob.BorderSizePixel  = 0
        knob.ZIndex           = 7
        knob.Parent           = trk
        Corner(knob, 12)
        Stroke(knob, T.White, 1.4, 0)

        local hit = Instance.new("TextButton")
        hit.Size                   = UDim2.new(1, 16, 0, 22)
        hit.Position               = UDim2.new(0, -8, 0.5, -11)
        hit.BackgroundTransparency = 1
        hit.Text                   = ""
        hit.AutoButtonColor        = false
        hit.ZIndex                 = 8
        hit.Parent                 = trk

        local cfgKey = "slider:" .. name
        local _entry

        local function setValue(n, fromBox, fromPeer)
            n = tonumber(string.format(_fmt, math.clamp(math.floor(n / _step + 0.5) * _step, mn, mx)))
            v = n
            local f = (v - mn) / math.max(1e-9, mx - mn)
            fill.Size     = UDim2.new(f, 0, 1, 0)
            knob.Position = UDim2.new(f, 0, 0.5, 0)
            if not fromBox then vBox.Text = string.format(_fmt, v) end
            if not fromPeer then
                Config.set(cfgKey, v)
                if cb then cb(v) end
                local reg = _SliderReg[cfgKey]
                if reg then
                    for _, peer in ipairs(reg) do
                        if peer ~= _entry then peer.setVisualOnly(v) end
                    end
                end
            end
        end

        _entry = { setVisualOnly = function(val) setValue(val, false, true) end }
        _SliderReg[cfgKey] = _SliderReg[cfgKey] or {}
        table.insert(_SliderReg[cfgKey], _entry)

        vBox.Focused:Connect(function() Tween(vBoxStroke, F, {Transparency = 0}) end)
        vBox.FocusLost:Connect(function()
            Tween(vBoxStroke, F, {Transparency = 0.3})
            local n = tonumber(vBox.Text)
            if n then setValue(n, true) end
            vBox.Text = string.format(_fmt, v)
            if onCommit then onCommit(v) end
            pcall(Config.flush)
        end)

        local function setFromX(px)
            local f = math.clamp((px - trk.AbsolutePosition.X) / math.max(1, trk.AbsoluteSize.X), 0, 1)
            setValue(mn + (mx - mn) * f)
        end

        local _dragHandle = { setFromX = setFromX }
        hit.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                _activeSliderDrag = _dragHandle
                setFromX(inp.Position.X)
                Tween(knob, F, {Size = UDim2.new(0, 14, 0, 14)})
            end
        end)
        hit.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if _activeSliderDrag == _dragHandle then _activeSliderDrag = nil end
                Tween(knob, F, {Size = UDim2.new(0, 12, 0, 12)})
                if onCommit then onCommit(v) end
                pcall(Config.flush)
            end
        end)

        task.defer(function() pcall(setValue, Config.get(cfgKey, def or mn)) end)
        if onCommit then task.defer(function() if v ~= nil then pcall(onCommit, v) end end) end

        return { card = card, set = function(nv) pcall(setValue, nv) end }
    end

    _G.__CyutsudBridge = {
        Nav = Nav, Section = Section, Toggle = Toggle, Slider = Slider,
        Button = Button, Card = Card, Config = Config,
        T = T, Theme = Theme, F = F, M = M, PG = PG,
        Tween = Tween, Lbl = Lbl, Corner = Corner, Stroke = Stroke,
        GradStroke = GradStroke, Grad = Grad, Pad = Pad,
        trackBgFrame = trackBgFrame, trackSolid = trackSolid,
        SetGuiColor = SetGuiColor, SetAccentColor = SetAccentColor, Repaint = Repaint, themeSeq = themeSeq,
        GUI = GUI, Root = Root, UIRoot = UIRoot,
        isMobile = isMobile, isPhone = isPhone,
        UserInputService = UserInputService, TweenService = TweenService,
        RunService = RunService, Players = Players, HttpService = HttpService,
        _UI = _UI, _applyUiScale = _applyUiScale, _newScale = _newScale,
        Dot1 = Dot1, Dot2 = Dot2, Dot1Btn = Dot1Btn, Dot2Btn = Dot2Btn,
        PageTitle = PageTitle, setPage = setPage,
        Active = Active, Tabs = Tabs,
        showToast = showToast,
        getToggleSaved = getToggleSaved, setToggleSaved = setToggleSaved,
        reapplyAllSavedToggles = reapplyAllSavedToggles,
        saveGuiPosition = saveGuiPosition, loadGuiPosition = loadGuiPosition,
        makeDraggable = makeDraggable,
        rootScale = rootScale, visible = visible, setVisible = setVisible, Vis = Vis,
        guiLocked = guiLocked, _GEN = _GEN,
        ThemeGrads = ThemeGrads, ThemeSolids = ThemeSolids, ThemeBgFrames = ThemeBgFrames,
        attachKeybind = attachKeybind,
        setToggleUI = setToggleUI,
    }

    task.spawn(function()
        local B = _G.__CyutsudBridge
        if not B then warn("[Nox] bridge missing"); return end
        local Nav, Section, Toggle, Slider = B.Nav, B.Section, B.Toggle, B.Slider
        local Button, Card, Config = B.Button, B.Card, B.Config
        local T, Theme, F, M, Tween = B.T, B.Theme, B.F, B.M, B.Tween
        local Lbl, Corner, Stroke, GradStroke = B.Lbl, B.Corner, B.Stroke, B.GradStroke
        local trackBgFrame, trackSolid = B.trackBgFrame, B.trackSolid
        local SetGuiColor, Repaint = B.SetGuiColor, B.Repaint
        local GUI, Root, isMobile = B.GUI, B.Root, B.isMobile
        local UserInputService, TweenService = B.UserInputService, B.TweenService
        local RunService, Players = B.RunService, B.Players
        local HttpService = B.HttpService
        local _UI, _applyUiScale, _newScale = B._UI, B._applyUiScale, B._newScale
        local Dot1, Dot2, Dot1Btn, Dot2Btn = B.Dot1, B.Dot2, B.Dot1Btn, B.Dot2Btn
        local PageTitle, setPage = B.PageTitle, B.setPage
        local showToast = B.showToast or function() end
        local reapplyAllSavedToggles = B.reapplyAllSavedToggles
        local getToggleSaved, setToggleSaved = B.getToggleSaved, B.setToggleSaved
        local rootScale, visible, setVisible = B.rootScale, B.visible, B.setVisible
        local Vis = B.Vis or _G._FH_Vis or { open = true }
        local ThemeGrads, ThemeSolids = B.ThemeGrads, B.ThemeSolids
        local attachKeybind = B.attachKeybind
        local setToggleUI = B.setToggleUI
        local Grad, Pad, themeSeq = B.Grad, B.Pad, B.themeSeq
        local _GEN = B._GEN
        local noop = function(state) end

        local Steal, startAutoSteal, stopAutoSteal

    local __gIIFE_2 = (function()
        local LP = Players.LocalPlayer
        local Steal = {
            AutoStealEnabled = false,
            StealRadius = 100,
            Mode = "half",
            HalfFireRange = 10,
            HalfHoldMin = 1.3,
            HalfHoldMax = 2.6,
            HalfEntryDelay = 0.3,
            StealDelay = 1.30,
            Data = {},
            TargetEnabled = false,
            TargetName = nil,
            TargetKey = nil,
            TargetPlot = nil,
            TargetSlot = nil,
        }
        local isStealing = false
        local stealStartTime = nil
        local autoConn = nil
        local giantPotionEnabled = false
        local spFrame, spScreenGui, spFill, spPct, spTitle, midLine

        local function isMyPlot(plot)
            if not plot then return false end
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local yourBase = sign:FindFirstChild("YourBase")
                if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
                    return true
                end
            end
            return false
        end

        local function isMyPlotByName(plotName)
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return false end
            local plot = plots:FindFirstChild(plotName)
            return isMyPlot(plot)
        end

        local function isValidStealPrompt(prompt)
            if not prompt or not prompt.Parent or not prompt.Enabled then return false end
            local state = prompt:GetAttribute("State")
            local actionText = prompt.ActionText
            return state == "Steal" or state == "Grab"
                or actionText == "Steal" or actionText == "Grab"
        end

        local function getPromptForPodium(plot, slot)
            if not plot or not slot then return nil end
            local pods = plot:FindFirstChild("AnimalPodiums")
            if not pods then return nil end
            local podium = pods:FindFirstChild(tostring(slot))
            if not podium then return nil end
            local base = podium:FindFirstChild("Base")
            if base then
                local spawn = base:FindFirstChild("Spawn")
                if spawn then
                    local att = spawn:FindFirstChild("PromptAttachment")
                    if att then
                        for _, pr in ipairs(att:GetChildren()) do
                            if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                                return pr
                            end
                        end
                    end
                    for _, pr in ipairs(spawn:GetDescendants()) do
                        if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                            return pr
                        end
                    end
                end
                for _, pr in ipairs(base:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                        return pr
                    end
                end
            end
            for _, pr in ipairs(podium:GetDescendants()) do
                if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                    return pr
                end
            end
            return nil
        end

        local function _promptDist(prompt)
            local char = LP.Character
            if not char then return math.huge end
            local root = char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChild("UpperTorso")
                or char:FindFirstChild("Torso")
            if not root then return math.huge end
            local part = prompt.Parent
            if part and part:IsA("Attachment") then part = part.Parent end
            if part and part:IsA("BasePart") then
                return (part.Position - root.Position).Magnitude
            end
            local ok, pos = pcall(function()
                return prompt.Parent and prompt.Parent.WorldPosition
            end)
            if ok and pos then
                return (pos - root.Position).Magnitude
            end
            return math.huge
        end

        local function findNearestPrompt()
            local char = LP.Character
            if not char then return nil, nil end
            local root = char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChild("UpperTorso")
                or char:FindFirstChild("Torso")
            if not root then return nil, nil end
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return nil, nil end
            local nearest, bestDist, nearestName = nil, math.huge, "Brainrot"
            local rootPos = root.Position

            if Steal.TargetEnabled and Steal.TargetPlot and Steal.TargetSlot ~= nil then
                local plot = plots:FindFirstChild(tostring(Steal.TargetPlot))
                if plot and not isMyPlot(plot) then
                    local prompt = getPromptForPodium(plot, Steal.TargetSlot)
                    if prompt and isValidStealPrompt(prompt) then
                        local d = _promptDist(prompt)
                        if d <= Steal.StealRadius then
                            local nm = (prompt.ObjectText ~= "" and prompt.ObjectText) or Steal.TargetName or "Brainrot"
                            return prompt, nm
                        end
                    end
                end
                return nil, nil
            end

            for _, plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") and not isMyPlot(plot) then
                    local pods = plot:FindFirstChild("AnimalPodiums")
                    if pods then
                        for _, pod in ipairs(pods:GetChildren()) do
                            local base = pod:FindFirstChild("Base")
                            local sp = base and base:FindFirstChild("Spawn")
                            if sp then
                                local d = (sp.Position - rootPos).Magnitude
                                if d <= Steal.StealRadius and d < bestDist then
                                    local prompt = getPromptForPodium(plot, tonumber(pod.Name) or pod.Name)
                                    if prompt and isValidStealPrompt(prompt) then
                                        nearest = prompt
                                        bestDist = d
                                        nearestName = (prompt.ObjectText ~= "" and prompt.ObjectText) or "Brainrot"
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return nearest, nearestName
        end

        local function drinkGiantPotion(prompt)
            if not giantPotionEnabled then return end
            if _G.AutoBigPotion and _G.AutoBigPotion.forceActivate then
                pcall(function() _G.AutoBigPotion.forceActivate(prompt) end)
                return
            end
            if _G.AutoPotionSystem and _G.AutoPotionSystem.forceActivate then
                pcall(function() _G.AutoPotionSystem:forceActivate(prompt) end)
                return
            end
        end

        local function executeSteal(prompt)
            if isStealing or not prompt or not prompt.Parent then return end
            if not Steal.Data[prompt] then
                Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
                if getconnections then
                    pcall(function()
                        for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                            if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                        end
                        for _, c in ipairs(getconnections(prompt.Triggered)) do
                            if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                        end
                    end)
                end
            end
            local data = Steal.Data[prompt]
            if not data or not data.ready then return end
            data.ready = false
            isStealing = true
            stealStartTime = tick()
            task.spawn(function()
                for _, fn in ipairs(data.hold) do task.spawn(fn) end
                pcall(function()
                    local on = giantPotionEnabled
                    if _G.AutoBigPotion and _G.AutoBigPotion.isEnabled and _G.AutoBigPotion.isEnabled() then on = true end
                    if on then drinkGiantPotion(prompt) end
                end)
                task.wait(Steal.HalfHoldMin)
                local inRange = _promptDist(prompt) <= Steal.HalfFireRange
                while true do
                    local el = tick() - (stealStartTime or tick())
                    if el > Steal.HalfHoldMax or not prompt.Parent then break end
                    if _promptDist(prompt) <= Steal.HalfFireRange then
                        if not inRange then task.wait(Steal.HalfEntryDelay) end
                        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                        break
                    end
                    task.wait()
                end
                task.wait(0.05)
                data.ready = true
                isStealing = false
            end)
        end

        local function startAutoSteal()
            if autoConn then return end
            Steal.AutoStealEnabled = true
            autoConn = RunService.Heartbeat:Connect(function()
                if not Steal.AutoStealEnabled or isStealing then return end
                if _G._CyutsudSemiTPActive then return end
                if _isShuttingDown and _isShuttingDown() then return end
                for prompt, _ in pairs(Steal.Data) do
                    if not prompt or not prompt.Parent then
                        Steal.Data[prompt] = nil
                    end
                end
                local prompt = findNearestPrompt()
                if prompt then
                    executeSteal(prompt)
                end
            end)
            if spFrame then spFrame.Visible = true end
            if _G._CyutsudProgressBar and _G._CyutsudProgressBar.setVisible then
                pcall(_G._CyutsudProgressBar.setVisible, true)
            end
            table.insert(_G._FH_TEARDOWN, function()
                if autoConn then pcall(function() autoConn:Disconnect() end) autoConn = nil end
                Steal.AutoStealEnabled = false
                isStealing = false
            end)
        end

        local function stopAutoSteal()
            if autoConn then pcall(function() autoConn:Disconnect() end) autoConn = nil end
            isStealing = false
            stealStartTime = nil
        end

        _G.AutoSteal = Steal

        do
            pcall(function()
                local old = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
                if old then old:Destroy() end
            end)

            spScreenGui = Instance.new("ScreenGui")
            spScreenGui.Name = "StealProgressScreenGui"
            spScreenGui.ResetOnSpawn = false
            spScreenGui.DisplayOrder = 200
            spScreenGui.IgnoreGuiInset = true
            spScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            pcall(function()
                if typeof(gethui) == "function" then
                    spScreenGui.Parent = gethui()
                end
            end)
            if not spScreenGui.Parent then
                pcall(function() spScreenGui.Parent = LP:WaitForChild("PlayerGui", 5) end)
            end

            local primary = (Theme and Theme.c1) or Color3.fromRGB(168, 85, 247)
            local secondary = (Theme and Theme.c2) or Color3.fromRGB(76, 29, 149)

            spFrame = Instance.new("Frame")
            spFrame.Name = "StealProgressGui"
            spFrame.Size = UDim2.new(0, 210, 0, 44)
            spFrame.Position = UDim2.new(0.5, -105, 0.5, -22)
            spFrame.AnchorPoint = Vector2.new(0.5, 1)
            spFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            spFrame.BackgroundTransparency = 0.05
            spFrame.BorderSizePixel = 0
            spFrame.Active = true
            spFrame.Visible = false
            spFrame.ZIndex = 60
            spFrame.ClipsDescendants = true
            spFrame.Parent = spScreenGui
            Instance.new("UICorner", spFrame).CornerRadius = UDim.new(0, 10)

            local border = Instance.new("UIStroke", spFrame)
            border.Color = primary
            border.Thickness = 1.5
            border.Transparency = 0.2
            border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local borderGrad = Instance.new("UIGradient", border)
            borderGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, secondary),
                ColorSequenceKeypoint.new(0.5, primary),
                ColorSequenceKeypoint.new(1, secondary),
            })

            local Shadow = Instance.new("ImageLabel", spFrame)
            Shadow.Size = UDim2.new(1, 30, 1, 30)
            Shadow.Position = UDim2.new(0, -15, 0, -15)
            Shadow.BackgroundTransparency = 1
            Shadow.Image = "rbxassetid://5028857084"
            Shadow.ImageColor3 = Color3.fromRGB(80, 20, 120)
            Shadow.ImageTransparency = 0.7
            Shadow.ScaleType = Enum.ScaleType.Slice
            Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
            Shadow.ZIndex = 59

            local dot = Instance.new("Frame", spFrame)
            dot.Size = UDim2.new(0, 6, 0, 6)
            dot.Position = UDim2.new(0, 12, 0, 11)
            dot.BackgroundColor3 = primary
            dot.BorderSizePixel = 0
            dot.ZIndex = 61
            Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 3)

            spTitle = Instance.new("TextLabel", spFrame)
            spTitle.Text = "AUTO GRAB"
            spTitle.TextSize = 11
            spTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            spTitle.Font = Enum.Font.GothamBold
            spTitle.Size = UDim2.new(1, -100, 0, 14)
            spTitle.Position = UDim2.new(0, 24, 0, 7)
            spTitle.BackgroundTransparency = 1
            spTitle.ZIndex = 61

            spPct = Instance.new("TextLabel", spFrame)
            spPct.Text = "0%"
            spPct.TextSize = 11
            spPct.TextColor3 = Color3.fromRGB(210, 225, 255)
            spPct.Font = Enum.Font.GothamBold
            spPct.Size = UDim2.new(0, 80, 0, 14)
            spPct.Position = UDim2.new(1, -92, 0, 7)
            spPct.BackgroundTransparency = 1
            spPct.TextXAlignment = Enum.TextXAlignment.Right
            spPct.ZIndex = 61

            local track = Instance.new("Frame", spFrame)
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 1, -16)
            track.BackgroundColor3 = Color3.fromRGB(23, 26, 36)
            track.BorderSizePixel = 0
            track.ClipsDescendants = true
            track.ZIndex = 61
            Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)
            local trackBorder = Instance.new("UIStroke", track)
            trackBorder.Color = primary
            trackBorder.Thickness = 0.8
            trackBorder.Transparency = 0.5

            midLine = Instance.new("Frame")
            midLine.Name = "MidLine"
            midLine.Size = UDim2.new(0, 2, 1, 0)
            midLine.Position = UDim2.new(0.5, -1, 0, 0)
            midLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            midLine.BackgroundTransparency = 0.15
            midLine.BorderSizePixel = 0
            midLine.ZIndex = 63
            midLine.Parent = track
            Instance.new("UICorner", midLine).CornerRadius = UDim.new(0, 1)

            spFill = Instance.new("Frame", track)
            spFill.Size = UDim2.new(0, 0, 1, 0)
            spFill.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
            spFill.BorderSizePixel = 0
            spFill.ZIndex = 62
            Instance.new("UICorner", spFill).CornerRadius = UDim.new(0, 4)
            local fillGrad = Instance.new("UIGradient", spFill)
            fillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 20, 180)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 100, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 32, 240)),
            })

            pcall(function()
                local loaded = false
                if loadGuiPosition then
                    loaded = loadGuiPosition("StealProgressGui", spFrame)
                end
                if not loaded and Config then
                    local p = Config.get("steal_progress_pos", nil)
                    if type(p) == "table" and #p >= 4 then
                        spFrame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                        if saveGuiPosition then
                            saveGuiPosition("StealProgressGui", spFrame)
                        end
                    end
                end
            end)

            local function saveProgressPos()
                if not spFrame then return end
                pcall(function()
                    local pos = spFrame.Position
                    local t = {
                        pos.X.Scale, pos.X.Offset,
                        pos.Y.Scale, pos.Y.Offset,
                    }
                    if Config then
                        Config.set("steal_progress_pos", t)
                        if Config.flush then Config.flush() end
                    end
                    if saveGuiPosition then
                        saveGuiPosition("StealProgressGui", spFrame)
                    end
                end)
            end

            pcall(function()
                local drag = _G.makePanelDraggable or makePanelDraggable
                if drag then
                    drag(spFrame, spFrame, "StealProgressGui")
                end
            end)

            local dragFrame = Instance.new("TextButton")
            dragFrame.Name = "ProgressDrag"
            dragFrame.Size = UDim2.new(1, 0, 1, 0)
            dragFrame.BackgroundTransparency = 1
            dragFrame.Text = ""
            dragFrame.AutoButtonColor = false
            dragFrame.ZIndex = 100
            dragFrame.Active = true
            dragFrame.Parent = spFrame

            local dragging, dragStart, frameStart, dragMoved = false, nil, nil, false
            local function toV2(p)
                if p == nil then return Vector2.zero end
                local ty = typeof(p)
                if ty == "Vector2" then return p end
                if ty == "Vector3" then return Vector2.new(p.X, p.Y) end
                if type(p) == "table" and p.X ~= nil then
                    return Vector2.new(tonumber(p.X) or 0, tonumber(p.Y) or 0)
                end
                return Vector2.zero
            end

            local function beginDrag(inp)
                if _G._FH_GuiLocked then return end
                dragging = true
                dragStart = toV2(inp and inp.Position)
                frameStart = spFrame.Position
                dragMoved = false
            end

            local function endDrag()
                if not dragging then return end
                dragging = false
                if dragMoved then
                    saveProgressPos()
                end
            end

            local function moveDrag(inp)
                if not dragging or not dragStart or not frameStart then return end
                local pos2 = toV2(inp and inp.Position)
                local delta = pos2 - dragStart
                if not dragMoved then
                    if delta.Magnitude < 3 then return end
                    dragMoved = true
                end
                spFrame.Position = UDim2.new(
                    frameStart.X.Scale, frameStart.X.Offset + delta.X,
                    frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
                )
            end

            dragFrame.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    beginDrag(inp)
                end
            end)
            dragFrame.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    endDrag()
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseMovement
                    and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                moveDrag(inp)
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    endDrag()
                end
            end)
            pcall(function()
                if UserInputService.TouchEnded then
                    UserInputService.TouchEnded:Connect(function()
                        if dragging then endDrag() end
                    end)
                end
            end)

            local shown, barAcc = 0, 0
            local _pbConn = RunService.Heartbeat:Connect(function(dt)
                if _GEN and _G._FH_CYUTSUD_GEN and _GEN ~= _G._FH_CYUTSUD_GEN then return end
                local on = Steal.AutoStealEnabled
                if spFrame then spFrame.Visible = on end
                if not on then return end
                local prompt, name = findNearestPrompt()
                local hasTarget = prompt ~= nil
                local p = 0
                if isStealing and stealStartTime then
                    p = math.clamp((tick() - stealStartTime) / Steal.HalfHoldMax, 0, 1)
                elseif hasTarget then
                    p = 1
                end
                shown = shown + (p - shown) * math.clamp(dt * 14, 0, 1)
                barAcc = barAcc + dt
                if barAcc < 1/30 then return end
                barAcc = 0
                local fillPercent = math.clamp(shown, 0, 1)
                if spFill then spFill.Size = UDim2.new(fillPercent, 0, 1, 0) end
                if hasTarget then
                    if spTitle then spTitle.Text = name or "Stealing..." end
                    if spPct then
                        spPct.Text = string.format("%d%%", math.floor(fillPercent * 100))
                        spPct.TextColor3 = primary
                    end
                else
                    if spTitle then spTitle.Text = "AUTO GRAB" end
                    if spPct then
                        spPct.Text = "searching..."
                        spPct.TextColor3 = Color3.fromRGB(150, 160, 190)
                    end
                end
            end)

            local function setProgressVisible(v)
                v = v and true or false
                if spFrame then spFrame.Visible = v end
                if not v then
                    shown = 0
                    if spFill then spFill.Size = UDim2.new(0, 0, 1, 0) end
                    if spPct then spPct.Text = "0%" end
                end
            end

            _G._CursedSetProgressBarVisible = setProgressVisible
            _G._CyutsudProgressBar = {
                frame = spFrame,
                shadow = Shadow,
                fill = spFill,
                pct = spPct,
                setVisible = setProgressVisible,
            }

            table.insert(_G._FH_TEARDOWN, function()
                pcall(function() if _pbConn then _pbConn:Disconnect() end end)
                pcall(function() if spScreenGui then spScreenGui:Destroy() end end)
            end)
        end

        _G._CyutsudStartAutoSteal = startAutoSteal
        _G._CyutsudStopAutoSteal = stopAutoSteal
        _G._CyutsudSetGiantPotion = function(s) giantPotionEnabled = s and true or false end
        _G._CyutsudIsMyPlotByName = isMyPlotByName
        _G._CyutsudIsValidStealPrompt = isValidStealPrompt
        _G._CyutsudFindNearestPrompt = function()
            local p = findNearestPrompt()
            return p
        end
    end)()
    local Steal = _G.AutoSteal
    local function startAutoSteal(...) return _G._CyutsudStartAutoSteal(...) end
    local function stopAutoSteal(...) return _G._CyutsudStopAutoSteal(...) end
    local function isMyPlotByName(...) return _G._CyutsudIsMyPlotByName(...) end
    local function isValidStealPrompt(...) return _G._CyutsudIsValidStealPrompt(...) end
    local function findNearestPrompt(...) return _G._CyutsudFindNearestPrompt(...) end

    _G.AutoBigPotion = (function()
    local Players = game:GetService("Players")
    local ProximityPromptService = game:GetService("ProximityPromptService")
    local player = Players.LocalPlayer

    local POTION_RADIUS = 5

    local Core = {
        enabled = false,
        _sessionTokens = {},
        _potionNames = {"Giant Potion", "Giant", "Grow Potion", "Super Grow", "Potion"},
        _giantThreshold = 2.5,
        _stealAttrs = {"Stealing", "steal", "stolen", "isStealing", "IsSteal", "issteal"},
        _connections = {},
        _lastActivate = 0,
        _radius = POTION_RADIUS,
    }

    function Core:isGiant()
        local char = player.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        local scale = hum:FindFirstChild("BodyHeightScale")
            or hum:FindFirstChild("BodyDepthScale")
            or hum:FindFirstChild("BodyWidthScale")
        return scale and scale:IsA("NumberValue") and scale.Value >= self._giantThreshold
    end

    function Core:isStealActive()
        for _, attr in ipairs(self._stealAttrs) do
            local success, value = pcall(function()
                return player:GetAttribute(attr)
            end)
            if success and value ~= nil and value ~= false and value ~= 0 then
                return true
            end
        end
        return false
    end

    function Core:getPromptWorldPos(prompt)
        if not prompt or not prompt.Parent then return nil end
        local pp = prompt.Parent
        if pp:IsA("Attachment") then return pp.WorldPosition end
        if pp:IsA("BasePart") then return pp.Position end
        local part = pp:FindFirstAncestorWhichIsA("BasePart")
        if part then return part.Position end
        return nil
    end

    function Core:distanceToPrompt(prompt)
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return math.huge end
        local pos = self:getPromptWorldPos(prompt)
        if not pos then return math.huge end
        return (hrp.Position - pos).Magnitude
    end

    function Core:isNearPrompt(prompt, radius)
        radius = radius or self._radius or POTION_RADIUS
        return self:distanceToPrompt(prompt) <= radius
    end

    function Core:isInEnemyPlot()
        local char = player.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return false end
        local myName = player.Name:lower()
        local myDisplay = player.DisplayName:lower()
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local label = sign:FindFirstChildWhichIsA("TextLabel", true)
                if label then
                    local t = label.Text:lower()
                    if not (t:find(myName, 1, true) or t:find(myDisplay, 1, true)) then
                        local hitbox = plot:FindFirstChild("StealHitbox", true)
                        if hitbox then
                            local cf, size = hitbox.CFrame, hitbox.Size
                            local hx, hz = size.X * 0.5, size.Z * 0.5
                            local rel = cf:PointToObjectSpace(hrp.Position)
                            if math.abs(rel.X) <= hx and math.abs(rel.Z) <= hz then
                                return true
                            end
                        end
                    end
                end
            end
        end
        return false
    end

    function Core:findPotion()
        local char = player.Character
        local bp = player:FindFirstChild("Backpack")
        if not char or not bp then return nil end
        for _, name in ipairs(self._potionNames) do
            local potion = bp:FindFirstChild(name) or char:FindFirstChild(name)
            if potion and potion:IsA("Tool") then
                return potion
            end
        end
        return nil
    end

    function Core:isStealPrompt(prompt)
        if not prompt then return false end
        local at = tostring(prompt.ActionText or "")
        local st = nil
        pcall(function() st = prompt:GetAttribute("State") end)
        if at == "Steal" or at == "Grab" then return true end
        if st == "Steal" or st == "Grab" then return true end
        return false
    end

    function Core:activate(force, prompt)
        if self:isGiant() then return false end
        local now = tick()
        if now - (self._lastActivate or 0) < 0.75 then return false end

        if prompt then
            if not self:isNearPrompt(prompt, self._radius) then
                return false
            end
        else
            if not force and not self:isInEnemyPlot() then
                return false
            end
        end

        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local bp = player:FindFirstChild("Backpack")
        if not char or not hum or not bp then return false end
        local potion = self:findPotion()
        if not potion then return false end

        local success = pcall(function()
            if potion.Parent ~= char then
                hum:EquipTool(potion)
            end
            potion:Activate()
            task.delay(0.25, function()
                if potion and potion.Parent == char and bp and bp.Parent then
                    pcall(function() potion.Parent = bp end)
                end
            end)
        end)
        if success then
            self._lastActivate = now
        end
        return success and true or false
    end

    function Core:forceActivate(prompt)
        return self:activate(true, prompt)
    end

    function Core:clearSession()
        for k in next, self._sessionTokens do
            self._sessionTokens[k] = nil
        end
    end

    function Core:cleanup()
        for _, conn in ipairs(self._connections) do
            pcall(function() conn:Disconnect() end)
        end
        self._connections = {}
        self:clearSession()
    end

    function Core:start()
        if #self._connections > 0 then return end

        local holdConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, plr)
            if plr ~= player or not self.enabled then return end
            if not self:isStealPrompt(prompt) then return end
            if self:isGiant() then return end
            local myToken = {}
            self._sessionTokens[prompt] = myToken
            local dur = (prompt.HoldDuration and prompt.HoldDuration > 0) and prompt.HoldDuration or 1
            task.delay(dur * 0.99, function()
                if self._sessionTokens[prompt] ~= myToken or not self.enabled then return end
                if not (prompt and prompt.Parent) then return end
                if self:isNearPrompt(prompt, self._radius) then
                    self:activate(false, prompt)
                end
            end)
        end)
        table.insert(self._connections, holdConn)

        local holdEndConn = ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, plr)
            if plr == player then self._sessionTokens[prompt] = nil end
        end)
        table.insert(self._connections, holdEndConn)

        local triggeredConn = ProximityPromptService.PromptTriggered:Connect(function(prompt, plr)
            if plr ~= player then return end
            self._sessionTokens[prompt] = nil
            if not self.enabled then return end
            if not self:isStealPrompt(prompt) then return end
            if self:isGiant() then return end
            task.defer(function()
                if not self.enabled then return end
                if self:isNearPrompt(prompt, self._radius) then
                    self:activate(true, prompt)
                end
            end)
        end)
        table.insert(self._connections, triggeredConn)
    end

    function Core:stop()
        self:cleanup()
    end

    function Core:set(state)
        self.enabled = state and true or false
        pcall(function()
            _G.giantPotionEnabled = self.enabled
            pcall(function() if _G._CyutsudSetGiantPotion then _G._CyutsudSetGiantPotion(self.enabled) end end)
        end)
        if self.enabled then
            self:start()
        else
            self:stop()
        end
    end

    local M = {}
    function M.set(state)
        state = state and true or false
        Core:set(state)
        pcall(function()
            if Config and Config.set then
                Config.set("auto_giant_potion", state and true or false)
                if Config.flush then Config.flush() end
            end
        end)
    end
    function M.isEnabled()
        return Core.enabled
    end
    function M.activate(force, prompt)
        return Core:activate(force, prompt)
    end
    function M.forceActivate(prompt)
        return Core:forceActivate(prompt)
    end
    function M.clearSession()
        return Core:clearSession()
    end
    function M.setRadius(r)
        Core._radius = tonumber(r) or POTION_RADIUS
    end
    M._core = Core
    _G.AutoPotionSystem = Core
    _G.AutoBigPotion = M
    return M
end)()

    _G.giantSpeedRequested = false
    _G.GiantPotionSpeed = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        local GPS = { enabled = false, speed = 34, active = false }
        pcall(function()
            if Config then
                local s = tonumber(Config.get("giantPotionSpeed", nil))
                    or tonumber(Config.get("slider:GPS Speed", nil))
                    or 34
                if s then GPS.speed = math.clamp(s, 1, 100) end
            end
        end)

        local _velocity, _attachment, _jumpConn, _loopConn, _charConn
        local _suspendedBooster = false
        local _graceUntil = 0
        local _paused = false
        local KEYWORDS = { "giant", "big", "grow", "size", "large", "mega", "huge", "potion" }

        local function getBooster()
            return rawget(_G, "Booster") or (type(Booster) == "table" and Booster) or nil
        end

        local function isGiantKeyword(str)
            if not str then return false end
            local low = string.lower(tostring(str))
            for _, k in ipairs(KEYWORDS) do
                if low:find(k, 1, true) then return true end
            end
            return false
        end

        local function getAvgScale(char)
            if not char then return 1 end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return 1 end
            local sum, n = 0, 0
            for _, name in ipairs({ "BodyHeightScale", "BodyDepthScale", "BodyWidthScale", "BodyProportionScale" }) do
                local v = hum:FindFirstChild(name)
                if v and v:IsA("NumberValue") then
                    sum = sum + v.Value
                    n = n + 1
                end
            end
            return n > 0 and (sum / n) or 1
        end

        local function hasGiantAttribute(inst)
            if not inst then return false end
            local ok, attrs = pcall(function() return inst:GetAttributes() end)
            if not ok or type(attrs) ~= "table" then return false end
            for k, v in pairs(attrs) do
                if isGiantKeyword(k) then
                    if v == true then return true end
                    if type(v) == "number" and v > 0 then return true end
                    if type(v) == "string" and v ~= "" and v ~= "0" and string.lower(v) ~= "false" and string.lower(v) ~= "none" then
                        return true
                    end
                end
            end
            return false
        end

        local function isGiantNow()
            local char = LocalPlayer.Character
            if not char then return false end
            if os.clock() < _graceUntil then return true end
            if getAvgScale(char) >= 2.0 then return true end
            if hasGiantAttribute(char) then return true end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hasGiantAttribute(hum) then return true end
            if hasGiantAttribute(LocalPlayer) then return true end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and isGiantKeyword(t.Name) then return true end
            end
            return false
        end

        local function Cleanup()
            if _velocity then pcall(function() _velocity:Destroy() end) _velocity = nil end
            if _attachment then pcall(function() _attachment:Destroy() end) _attachment = nil end
            if _jumpConn then pcall(function() _jumpConn:Disconnect() end) _jumpConn = nil end
            if _suspendedBooster then
                _suspendedBooster = false
                local B = getBooster()
                if B and B.unsuspend then
                    pcall(function() B.unsuspend("gps") end)
                end
            end
            GPS.active = false
            _G.NoxGPSEnabled = false
            _G.GammaGPSEnabled = false
        end

        local function CreateVelocity(hrp)
            if _velocity then pcall(function() _velocity:Destroy() end) end
            if _attachment then pcall(function() _attachment:Destroy() end) end
            _attachment = Instance.new("Attachment")
            _attachment.Name = "NoxGPSAtt"
            _attachment.Parent = hrp
            _velocity = Instance.new("LinearVelocity")
            _velocity.Name = "NoxGPSLV"
            _velocity.Parent = _attachment
            _velocity.Attachment0 = _attachment
            _velocity.RelativeTo = Enum.ActuatorRelativeTo.World
            _velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
            _velocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
            _velocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
            _velocity.PlaneVelocity = Vector2.new(0, 0)
            _velocity.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
            _velocity.Enabled = true
        end

        local function SetupJump(hrp, humanoid)
            if _jumpConn then _jumpConn:Disconnect() _jumpConn = nil end
            _jumpConn = humanoid.StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Jumping and GPS.enabled and GPS.active then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        GPS.speed,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end)
        end

        local function StartActiveLoop()
            if _loopConn or _paused then return end
            _G.NoxGPSEnabled = true
            _G.GammaGPSEnabled = true
            _loopConn = RunService.Heartbeat:Connect(function()
                if not GPS.enabled or _paused or _G._CyutsudSemiTPActive then
                    if _velocity then
                        _velocity.PlaneVelocity = Vector2.new(0, 0)
                        _velocity.Enabled = false
                    end
                    if not GPS.enabled or _paused then
                        Cleanup()
                        if _loopConn then _loopConn:Disconnect() _loopConn = nil end
                    end
                    return
                end
                if not isGiantNow() then
                    Cleanup()
                    return
                end
                local char = LocalPlayer.Character
                if not char then return end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not (humanoid and hrp) or humanoid.Health <= 0 then return end
                if not (_velocity and _attachment and _attachment.Parent == hrp) then
                    CreateVelocity(hrp)
                end
                if not _jumpConn then SetupJump(hrp, humanoid) end
                local B = getBooster()
                if B and B.enabled and not _suspendedBooster then
                    _suspendedBooster = true
                    pcall(function() B.suspend("gps") end)
                end
                GPS.active = true
                local md = humanoid.MoveDirection
                if md.Magnitude > 0.05 then
                    local unit = Vector3.new(md.X, 0, md.Z)
                    if unit.Magnitude > 0.01 then
                        unit = unit.Unit
                        _velocity.Enabled = true
                        _velocity.PlaneVelocity = Vector2.new(unit.X * GPS.speed, unit.Z * GPS.speed)
                    end
                else
                    if _velocity then _velocity.PlaneVelocity = Vector2.new(0, 0) end
                end
            end)
        end

        local function StopActiveLoop()
            if _loopConn then _loopConn:Disconnect() _loopConn = nil end
            Cleanup()
        end

        local function onBecameGiant()
            _graceUntil = os.clock() + 1.25
            if GPS.enabled and not _paused then StartActiveLoop() end
        end

        local function watchCharacter(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, name in ipairs({ "BodyHeightScale", "BodyDepthScale", "BodyWidthScale" }) do
                    local v = hum:FindFirstChild(name)
                    if v and v:IsA("NumberValue") then
                        v:GetPropertyChangedSignal("Value"):Connect(function()
                            if v.Value >= 2.0 then onBecameGiant() end
                        end)
                    end
                end
                hum.ChildAdded:Connect(function(c)
                    if c:IsA("NumberValue") and (c.Name == "BodyHeightScale" or c.Name == "BodyDepthScale" or c.Name == "BodyWidthScale") then
                        c:GetPropertyChangedSignal("Value"):Connect(function()
                            if c.Value >= 2.0 then onBecameGiant() end
                        end)
                    end
                end)
            end
            char.ChildAdded:Connect(function(c)
                if c:IsA("Tool") and isGiantKeyword(c.Name) then onBecameGiant() end
            end)
            if isGiantNow() then onBecameGiant() end
        end

        function GPS.set(on, skipSave)
            on = on and true or false
            GPS.enabled = on
            _G.giantSpeedRequested = on
            if on then
                if not _charConn then
                    _charConn = LocalPlayer.CharacterAdded:Connect(function(c)
                        StopActiveLoop()
                        task.wait(0.5)
                        if GPS.enabled and not _paused then watchCharacter(c) end
                    end)
                end
                if LocalPlayer.Character and not _paused then
                    watchCharacter(LocalPlayer.Character)
                end
                if isGiantNow() and not _paused then StartActiveLoop() end
            else
                StopActiveLoop()
            end
            -- Persist only when user toggles (same as Auto Steal). Teardown uses skipSave=true.
            if not skipSave then
                pcall(function()
                    if setToggleSaved then
                        setToggleSaved("Giant Potion Speed", on)
                    elseif Config then
                        Config.set("toggle:Giant Potion Speed", on)
                        local t = Config.get("toggles", {})
                        if type(t) ~= "table" then t = {} end
                        t["Giant Potion Speed"] = on
                        Config.set("toggles", t)
                        if Config.flush then Config.flush() end
                        if Config.save then Config.save() end
                    end
                end)
            end
        end

        function GPS.pause()
            if _paused then return end
            _paused = true
            StopActiveLoop()
        end

        function GPS.resume()
            if not _paused then return end
            _paused = false
            if GPS.enabled then
                if LocalPlayer.Character then watchCharacter(LocalPlayer.Character) end
                if isGiantNow() then StartActiveLoop() end
            end
        end

        function GPS.setSpeed(val)
            val = tonumber(val) or GPS.speed
            GPS.speed = math.clamp(val, 1, 100)
            -- Apply live while boost is active
            pcall(function()
                if _velocity and _velocity.Parent and GPS.active and GPS.enabled then
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local md = hum.MoveDirection
                        if md.Magnitude > 0.05 then
                            local unit = Vector3.new(md.X, 0, md.Z)
                            if unit.Magnitude > 0.01 then
                                unit = unit.Unit
                                _velocity.Enabled = true
                                _velocity.PlaneVelocity = Vector2.new(unit.X * GPS.speed, unit.Z * GPS.speed)
                            end
                        end
                    end
                end
            end)
            pcall(function()
                if Config then
                    Config.set("giantPotionSpeed", GPS.speed)
                    Config.set("slider:GPS Speed", GPS.speed)
                end
            end)
        end

        function GPS.isActive() return GPS.active end
        function GPS.getSpeed() return GPS.speed end

        return GPS
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.GiantPotionSpeed and _G.GiantPotionSpeed.set then
                -- skipSave: do not overwrite saved toggle (same as Auto Steal)
                _G.GiantPotionSpeed.set(false, true)
            end
        end)
    end)

    _G.StealTarget = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local TweenService = game:GetService("TweenService")
        local LP = Players.LocalPlayer
        local gui = nil
        local scroll = nil
        local selectedName = nil
        local rotConns = {}
        local refreshConn = nil
        local knownCases = {}
        local lastFingerprint = ""
        local searchQuery = ""
        local searchBox = nil
        local targetHighlight = nil
        local targetHighlightModel = nil
        local targetTracer = nil          -- Drawing line or Beam
        local targetTracerAtt0 = nil
        local targetTracerAtt1 = nil
        local targetTracerConn = nil
        local targetTracerMode = nil      -- "drawing" | "beam"
        local updateTargetHighlight
        local hlRefreshConn = nil

        local function themePrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            if T and typeof(T.Primary) == "Color3" then return T.Primary end
            return Color3.fromRGB(168, 85, 247)
        end

        local function destroyGui()
            if refreshConn then
                pcall(function() task.cancel(refreshConn) end)
                refreshConn = nil
            end
            for _, c in pairs(rotConns) do pcall(function() c:Disconnect() end) end
            rotConns = {}
            knownCases = {}
            lastFingerprint = ""
            searchBox = nil

            if gui then pcall(function() gui:Destroy() end) gui = nil scroll = nil end
        end

        local function themeSecondary()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(250, 245, 235)
        end

        local function themeColors()
            local p = themePrimary()
            local s = themeSecondary()
            local p40 = Color3.new(p.R * 0.40, p.G * 0.40, p.B * 0.40)
            local p12 = Color3.new(math.max(0.03, p.R * 0.12), math.max(0.03, p.G * 0.12), math.max(0.03, p.B * 0.12))
            local p25 = Color3.new(math.max(0.06, p.R * 0.22), math.max(0.06, p.G * 0.22), math.max(0.06, p.B * 0.22))
            return {
                primary = p,
                secondary = s,
                card = p25,
                cardSel = p40,
                titleBar = p12,
                closeBg = Color3.new(math.max(0.04, p.R * 0.15), math.max(0.04, p.G * 0.15), math.max(0.04, p.B * 0.15)),
                body = Color3.fromRGB(18, 16, 14),
                text = Color3.fromRGB(230, 235, 255),
                stroke = Color3.fromRGB(255, 255, 255),
            }
        end

        local function formatMoney(n)
            if type(n) ~= "number" then return tostring(n) end
            local abs = math.abs(n)
            if abs >= 1e12 then return string.format("%.1fT", n / 1e12):gsub("%.0T", "T")
            elseif abs >= 1e9 then return string.format("%.1fB", n / 1e9):gsub("%.0B", "B")
            elseif abs >= 1e6 then return string.format("%.1fM", n / 1e6):gsub("%.0M", "M")
            elseif abs >= 1e3 then return string.format("%.1fK", n / 1e3):gsub("%.0K", "K")
            else return tostring(math.floor(n + 0.5)) end
        end

        local MUTATION_MULT = {
            ["gold"] = 1.25, ["golden"] = 1.25,
            ["diamond"] = 1.5,
            ["bloodrot"] = 2, ["blood"] = 2, ["bloodmoon"] = 2,
            ["candy"] = 4, ["celestial"] = 4,
            ["lava"] = 6, ["molten"] = 6,
            ["galaxy"] = 7, ["galactic"] = 7,
            ["yin yang"] = 7.5, ["yinyang"] = 7.5, ["yin"] = 7.5,
            ["radioactive"] = 8.5,
            ["cursed"] = 9,
            ["rainbow"] = 10, ["divine"] = 10,
            ["cyber"] = 11,
            ["phantom"] = 12,
            ["crystal"] = 13,
            ["neon"] = 4,
        }
        local TRAIT_MULT = {
            ["strawberry"] = 9, ["meowl"] = 8, ["john pork"] = 7.5, ["skibidi"] = 7,
            ["pink egg"] = 6.5, ["rainbow balloon"] = 6.5, ["nyan"] = 5, ["nyan cat"] = 6,
            ["fireworks"] = 5, ["firework"] = 5, ["fire"] = 5, ["lightning"] = 5,
            ["rose"] = 5, ["disco"] = 4, ["glitched"] = 4, ["glitch"] = 5,
            ["crab"] = 4, ["crab rave"] = 5, ["zombie"] = 4, ["ufo"] = 2,
            ["taco"] = 2, ["taco rain"] = 3, ["snowy"] = 2, ["snow"] = 3,
            ["wet"] = 1.5, ["sleepy"] = 0.5, ["comet"] = 2.5, ["comet-struck"] = 2.5,
            ["asteroid"] = 4, ["la vacca"] = 4, ["bombardiro"] = 3, ["bombardino"] = 3,
            ["halo"] = 5, ["lucky"] = 5, ["sombrero"] = 5, ["brazil"] = 5,
            ["paint"] = 5, ["spider"] = 4.5, ["bubblegum"] = 3, ["shark"] = 3,
            ["galactic"] = 3, ["explosive"] = 3, ["skeleton"] = 3, ["witch"] = 3,
            ["santa"] = 4, ["reindeer"] = 6, ["granny"] = 5.5, ["pink balloon"] = 5.5,
            ["red balloon"] = 5, ["blue balloon"] = 4, ["green balloon"] = 3.5,
            ["orange balloon"] = 3, ["1 year"] = 5.5, ["strawberry elephant"] = 9,
        }

        local function lookupMult(map, text)
            if not text or text == "" then return nil, nil end
            local low = string.lower(tostring(text)):gsub("^%s+", ""):gsub("%s+$", "")
            if map[low] then return map[low], low end

            local bestK, bestV, bestLen = nil, nil, 0
            for k, v in pairs(map) do
                if #k > bestLen and low:find(k, 1, true) then
                    bestK, bestV, bestLen = k, v, #k
                end
            end
            return bestV, bestK
        end

        local function getMutationInfo(prompt, spawn, plot, pod)
            local mut = nil
            local function tryAttr(inst)
                if not inst then return end
                for _, a in ipairs({"Mutation", "mutation", "Variant", "variant", "Rarity", "rarity", "Skin", "skin"}) do
                    local ok, v = pcall(function() return inst:GetAttribute(a) end)
                    if ok and v ~= nil and tostring(v) ~= "" and tostring(v) ~= "None" and tostring(v) ~= "nil" and tostring(v) ~= "Default" then
                        return tostring(v)
                    end
                end
            end
            mut = tryAttr(prompt) or tryAttr(spawn)
            if pod then mut = mut or tryAttr(pod) end
            local playerNames = {}
            for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end
            local nearModel = nil
            if spawn and plot then
                local best, bestD = nil, 12
                for _, v in ipairs(plot:GetDescendants()) do
                    if v:IsA("Model") and not playerNames[v.Name] then
                        local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
                        if rp then
                            local d = (rp.Position - spawn.Position).Magnitude
                            if d < bestD then bestD = d; best = v end
                        end
                    end
                end
                nearModel = best
                if best then
                    mut = mut or tryAttr(best)
                    for _, d in ipairs(best:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Text and #d.Text > 0 and #d.Text < 40 then
                            local t = d.Text
                            local mv = lookupMult(MUTATION_MULT, t)
                            if mv then mut = mut or t end
                        end
                        if not mut then mut = tryAttr(d) end
                        if mut then break end
                    end
                end
            end

            if not mut and prompt and prompt.ObjectText then
                local mv, mk = lookupMult(MUTATION_MULT, prompt.ObjectText)
                if mk then mut = mk end
            end
            return mut, nearModel
        end

        local function detectTraits(prompt, spawn, model)
            local traits = {}
            local function addTrait(text)
                local mult, key = lookupMult(TRAIT_MULT, text)
                if mult and key and not traits[key] then
                    traits[key] = mult
                end
            end
            local function scanInst(inst)
                if not inst then return end
                for _, a in ipairs({"Trait", "trait", "Traits", "traits", "Trait1", "Trait2", "Trait3"}) do
                    local ok, v = pcall(function() return inst:GetAttribute(a) end)
                    if ok and v ~= nil and tostring(v) ~= "" then

                        if type(v) == "table" then
                            for _, x in pairs(v) do addTrait(tostring(x)) end
                        else
                            for part in string.gmatch(tostring(v), "[^,;/|]+") do
                                addTrait(part)
                            end
                        end
                    end
                end
            end
            scanInst(prompt)
            scanInst(spawn)
            scanInst(model)
            if model then
                for _, d in ipairs(model:GetDescendants()) do
                    scanInst(d)
                    if d:IsA("TextLabel") and d.Text then addTrait(d.Text) end
                    if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                        for _, l in ipairs(d:GetDescendants()) do
                            if l:IsA("TextLabel") and l.Text then addTrait(l.Text) end
                        end
                    end
                end
            end
            if spawn then
                for _, attName in ipairs({"PromptAttachment", "Attachment"}) do
                    local att = spawn:FindFirstChild(attName)
                    if att then
                        for _, d in ipairs(att:GetDescendants()) do
                            if d:IsA("TextLabel") and d.Text then addTrait(d.Text) end
                        end
                    end
                end
            end
            return traits
        end

        local function parseMoneyNumber(t)
            if type(t) ~= "string" then return nil end
            local s = t:gsub("%s+", ""):gsub("%$", ""):gsub("/s", ""):gsub("/S", "")
            local num, suf = s:match("^([%d%.]+)([KkMmBbTt]?)$")
            if not num then return nil end
            local n = tonumber(num)
            if not n then return nil end
            local f = string.lower(suf or "")
            if f == "k" then n = n * 1e3
            elseif f == "m" then n = n * 1e6
            elseif f == "b" then n = n * 1e9
            elseif f == "t" then n = n * 1e12 end
            return n
        end

        local function isMoneyText(t)
            if type(t) ~= "string" or t == "" then return false end
            return t:find("%$") ~= nil or t:find("/s") ~= nil
                or t:find("M/s") ~= nil or t:find("K/s") ~= nil
                or t:find("B/s") ~= nil or t:find("T/s") ~= nil
        end

        local function collectMoneyFromGui(gui)
            local best = ""
            for _, label in ipairs(gui:GetDescendants()) do
                if label:IsA("TextLabel") then
                    local t = label.Text
                    if isMoneyText(t) then
                        best = t:gsub("%s+", "")
                        break
                    end
                end
            end
            return best
        end

        local function getBaseGeneration(prompt, name)
            local gen = 0
            pcall(function()
                local Animals = require(game.ReplicatedStorage.Datas.Animals)
                if not Animals then return end
                local entry = Animals[name]
                if not entry and name then
                    local base = name:match("^([^%[%(%|]+)")
                    if base then
                        base = base:gsub("%s+$", "")
                        entry = Animals[base]
                    end
                end
                if entry then
                    gen = entry.Generation or entry.generation or entry.Income or entry.Gen or 0
                end
            end)
            if (not gen or gen == 0) and prompt then
                for _, a in ipairs({"Generation", "generation", "Income", "Gen", "BaseGeneration", "BaseIncome"}) do
                    local ok, v = pcall(function() return prompt:GetAttribute(a) end)
                    if ok and type(v) == "number" and v > 0 then gen = v break end
                end
            end
            return type(gen) == "number" and gen or 0
        end

        local function computeFinalIncome(baseGen, mutName, traits)
            if not baseGen or baseGen <= 0 then return 0 end
            local mutMult = 1
            if mutName then
                local m = lookupMult(MUTATION_MULT, mutName)
                if m then mutMult = m end
            end
            local traitSum = 0
            if traits then
                for _, m in pairs(traits) do
                    if type(m) == "number" then traitSum = traitSum + m end
                end
            end
            local totalMult = mutMult + traitSum
            if totalMult < 0.01 then totalMult = 1 end
            return baseGen * totalMult
        end

        local function getBrainrotMoney(prompt, spawn, mutName, traits, petName)

            local money = ""
            if spawn then
                for _, attName in ipairs({"PromptAttachment", "Attachment"}) do
                    local att = spawn:FindFirstChild(attName)
                    if att then
                        for _, child in ipairs(att:GetDescendants()) do
                            if child:IsA("BillboardGui") or child.Name == "AnimalOverhead" then
                                local m = collectMoneyFromGui(child:IsA("BillboardGui") and child or child)
                                if m ~= "" then money = m break end
                            end
                        end
                        local overhead = att:FindFirstChild("AnimalOverhead")
                        if money == "" and overhead then
                            money = collectMoneyFromGui(overhead)
                        end
                    end
                    if money ~= "" then break end
                end
                if money == "" then
                    for _, child in ipairs(spawn:GetChildren()) do
                        if child:IsA("BillboardGui") then
                            local m = collectMoneyFromGui(child)
                            if m ~= "" then money = m break end
                        end
                    end
                end
            end

            if money ~= "" then
                if not money:find("%$") then money = "$" .. money end
                if not money:find("/s") then money = money .. "/s" end
                return money
            end

            local name = petName or (prompt and prompt.ObjectText) or ""
            local base = getBaseGeneration(prompt, name)
            if base <= 0 then return "" end
            local final = computeFinalIncome(base, mutName, traits)
            if final <= 0 then return "" end
            money = "$" .. formatMoney(final) .. "/s"
            return money
        end

        local function collectAllBrainrots()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return {} end
            local playerNames = {}
            for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end
            local list = {}
            for _, plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
                    local pods = plot:FindFirstChild("AnimalPodiums")
                    if pods then
                        for _, pod in ipairs(pods:GetChildren()) do
                            local slot = tonumber(pod.Name:match("%d+")) or 0
                            local base = pod:FindFirstChild("Base") or pod
                            local sp = base and base:FindFirstChild("Spawn")
                            if not sp then continue end
                            local prompt = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if pr:IsA("ProximityPrompt") and isValidStealPrompt(pr) then prompt = pr break end
                                end
                            end
                            if not prompt then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if pr:IsA("ProximityPrompt") and isValidStealPrompt(pr) then prompt = pr break end
                                end
                            end
                            if not prompt then continue end
                            local petName = tostring(prompt.ObjectText or ""):gsub("^%s+", ""):gsub("%s+$", "")
                            if petName == "" or petName == "Pet" then
                                local best, bestD = nil, 12
                                for _, v in ipairs(plot:GetDescendants()) do
                                    if v:IsA("Model") and not playerNames[v.Name] and not v:IsDescendantOf(pod) then
                                        local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
                                        if rp then
                                            local d = (rp.Position - sp.Position).Magnitude
                                            if d < bestD then bestD = d; best = v end
                                        end
                                    end
                                end
                                if best then petName = best.Name end
                            end
                            if not petName or petName == "" or petName == "Pet" then continue end
                            local mut, nearModel = getMutationInfo(prompt, sp, plot, pod)
                            local traits = detectTraits(prompt, sp, nearModel)
                            local display = petName
                            if mut and mut ~= "" and not petName:lower():find(tostring(mut):lower(), 1, true) then
                                display = petName .. " [" .. tostring(mut) .. "]"
                            end
                            local traitNames = {}
                            for k, _ in pairs(traits) do table.insert(traitNames, k) end
                            if #traitNames > 0 then
                                table.sort(traitNames)
                                display = display .. " {" .. table.concat(traitNames, ",") .. "}"
                            end
                            local money = getBrainrotMoney(prompt, sp, mut, traits, petName)
                            local key = plot.Name .. "|" .. tostring(slot) .. "|" .. petName .. "|" .. tostring(mut or "") .. "|" .. table.concat(traitNames, ",")
                            local disp = display
                            if money ~= "" then
                                disp = display .. "\n" .. money
                            end
                            table.insert(list, {
                                key = key,
                                name = petName,
                                display = display,
                                label = disp,
                                money = money,
                                mutation = mut,
                                traits = traits,
                                prompt = prompt,
                                spawn = sp,
                                plot = plot,
                                plotName = plot.Name,
                                slot = slot,
                            })
                        end
                    end
                end
            end
            table.sort(list, function(a, b)
                if a.name:lower() == b.name:lower() then
                    return (a.mutation or "") < (b.mutation or "")
                end
                return a.name:lower() < b.name:lower()
            end)
            return list
        end

        local function isStructuralModel(v)
            if not v or not v:IsA("Model") then return true end
            local n = string.lower(v.Name or "")
            local banned = {
                "plot", "plots", "podium", "animalpodium", "animalpodiums", "base", "spawn",
                "purchases", "plotblock", "plotsign", "yourbase", "channel", "decoration",
                "floor", "wall", "fence", "door", "part", "model", "folder", "workspace",
            }
            for i = 1, #banned do
                if n == banned[i] or n:find(banned[i], 1, true) then

                    if n == banned[i] then return true end
                end
            end

            local p = v.Parent
            if p and (p.Name == "AnimalPodiums" or p.Name == "Plots" or p.Name == "Purchases") then
                return true
            end
            if v:FindFirstChild("AnimalPodiums") or v:FindFirstChild("PlotSign") or v:FindFirstChild("Purchases") then
                return true
            end
            return false
        end

        local function modelScore(v, name, spawnPos)
            if isStructuralModel(v) then return nil end
            local playerNames = {}
            for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end
            if playerNames[v.Name] then return nil end

            local hasMesh = false
            local partCount = 0
            for _, d in ipairs(v:GetDescendants()) do
                if d:IsA("BasePart") then
                    partCount = partCount + 1
                    if d:IsA("MeshPart") or d:FindFirstChildOfClass("SpecialMesh") then hasMesh = true end
                end
            end
            if partCount < 1 then return nil end
            local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if not rp then return nil end
            local dist = spawnPos and (rp.Position - spawnPos).Magnitude or 0
            if spawnPos and dist > 18 then return nil end
            local score = 100 - dist
            if v.Name == name then score = score + 50 end
            if name and v.Name:lower():find(tostring(name):lower(), 1, true) then score = score + 25 end
            if hasMesh then score = score + 10 end

            local ok, cf, size = pcall(function() return v:GetBoundingBox() end)
            if ok and size then
                local mag = size.Magnitude
                if mag > 40 then score = score - 40 end
                if mag < 15 then score = score + 15 end
            end
            return score, rp
        end

        local function findModelForName(name, preferSpawn)
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return nil end
            local spawnPos = preferSpawn and preferSpawn.Position or nil
            local best, bestScore = nil, -1e9

            for _, v in ipairs(plots:GetDescendants()) do
                if v:IsA("Model") and v.Name == name then
                    local sc = modelScore(v, name, spawnPos)
                    if sc and sc > bestScore then bestScore = sc; best = v end
                end
            end
            if best then return best end

            if spawnPos then
                for _, v in ipairs(plots:GetDescendants()) do
                    if v:IsA("Model") then
                        local sc = modelScore(v, name, spawnPos)
                        if sc and sc > bestScore then bestScore = sc; best = v end
                    end
                end
            end
            return best
        end

        local function attachViewport(vp, data)
            task.spawn(function()
                if not vp or not vp.Parent then return end
                for _, c in ipairs(vp:GetChildren()) do
                    if c:IsA("Model") then return end
                end
                local model = findModelForName(data.name, data.spawn)
                if not model or not vp.Parent then return end
                local clone = model:Clone()
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Highlight")
                        or d:IsA("ProximityPrompt") or d:IsA("BillboardGui") or d:IsA("SurfaceGui")
                        or d:IsA("ClickDetector") or d:IsA("TouchTransmitter") then
                        pcall(function() d:Destroy() end)
                    end
                end

                for _, ch in ipairs(clone:GetChildren()) do
                    local ln = string.lower(ch.Name or "")
                    if ch:IsA("Model") and (ln:find("podium") or ln:find("base") or ln == "spawn") then
                        pcall(function() ch:Destroy() end)
                    end
                end
                clone.Parent = vp
                local cam = vp.CurrentCamera
                if not cam then
                    cam = Instance.new("Camera")
                    cam.Parent = vp
                    vp.CurrentCamera = cam
                end
                local ok, cf, size = pcall(function() return clone:GetBoundingBox() end)
                if not ok or not size then return end

                if size.Magnitude > 50 then
                    pcall(function() clone:Destroy() end)
                    return
                end
                local dist = math.max(size.Magnitude * 1.25, 2.5)
                local center = cf.Position
                cam.CFrame = CFrame.new(center + Vector3.new(dist * 0.85, size.Y * 0.25, dist * 0.85), center)
            end)
        end

        local function getSelHighlightColor()
            return Color3.fromRGB(255, 255, 255)
        end

        local function clearTargetTracer()
            if targetTracerConn then
                pcall(function() targetTracerConn:Disconnect() end)
                targetTracerConn = nil
            end
            if targetTracer then
                pcall(function()
                    if typeof(targetTracer) == "Instance" then
                        targetTracer:Destroy()
                    elseif type(targetTracer) == "table" and targetTracer.Remove then
                        targetTracer:Remove()
                    elseif type(targetTracer) == "table" and targetTracer.Destroy then
                        targetTracer:Destroy()
                    end
                end)
                targetTracer = nil
            end
            if targetTracerAtt0 then
                pcall(function() targetTracerAtt0:Destroy() end)
                targetTracerAtt0 = nil
            end
            if targetTracerAtt1 then
                pcall(function() targetTracerAtt1:Destroy() end)
                targetTracerAtt1 = nil
            end
            targetTracerMode = nil
        end

        local function clearTargetHighlight()
            clearTargetTracer()
            if targetHighlight then
                pcall(function() targetHighlight:Destroy() end)
                targetHighlight = nil
            end
            targetHighlightModel = nil
        end

        local function stopHighlightRefresh()
            if hlRefreshConn then
                pcall(function() task.cancel(hlRefreshConn) end)
                hlRefreshConn = nil
            end
            if targetTracerConn then
                pcall(function() targetTracerConn:Disconnect() end)
                targetTracerConn = nil
            end
        end

        local function getTargetWorldPart()
            if not Steal.TargetKey then return nil end
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return nil end
            local plot = Steal.TargetPlot and plots:FindFirstChild(Steal.TargetPlot)
            if not plot then return nil end
            local pods = plot:FindFirstChild("AnimalPodiums")
            if not pods then return nil end
            local pod = nil
            for _, p in ipairs(pods:GetChildren()) do
                local n = tonumber(p.Name:match("%d+")) or 0
                if n == Steal.TargetSlot then pod = p break end
            end
            if not pod then return nil end
            local base = pod:FindFirstChild("Base") or pod
            local sp = base and base:FindFirstChild("Spawn")
            if not sp then return nil end
            local model = findModelForName(Steal.TargetName or "", sp)
            if model then
                local part = model:FindFirstChild("HumanoidRootPart")
                    or model.PrimaryPart
                    or model:FindFirstChildWhichIsA("BasePart", true)
                return model, part
            end
            -- fallback: any BasePart under spawn
            local part = sp:FindFirstChildWhichIsA("BasePart", true) or (sp:IsA("BasePart") and sp)
            return sp, part
        end

        local function ensureWhiteHighlight(model)
            if not model then return end
            if targetHighlight and targetHighlight.Parent and targetHighlightModel == model then
                targetHighlight.FillColor = Color3.fromRGB(255, 255, 255)
                targetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                targetHighlight.OutlineTransparency = 0
                targetHighlight.FillTransparency = 0.45
                targetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                return
            end
            if targetHighlight then
                pcall(function() targetHighlight:Destroy() end)
                targetHighlight = nil
            end
            local hl = Instance.new("Highlight")
            hl.Name = "NoxStealTargetHL"
            hl.Adornee = model
            hl.FillColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.45
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = model
            targetHighlight = hl
            targetHighlightModel = model
        end

        local function startTargetTracer(model, part)
            clearTargetTracer()
            if not part then return end
            local white = Color3.fromRGB(255, 255, 255)

            -- Prefer Drawing API (executors)
            local okDraw, line = pcall(function()
                if type(Drawing) == "table" and type(Drawing.new) == "function" then
                    return Drawing.new("Line")
                end
            end)
            if okDraw and line then
                targetTracerMode = "drawing"
                targetTracer = line
                pcall(function()
                    line.Visible = true
                    line.Color = white
                    line.Thickness = 2
                    line.Transparency = 0
                    if line.ZIndex ~= nil then line.ZIndex = 20 end
                end)
                targetTracerConn = RunService.RenderStepped:Connect(function()
                    if not Steal.TargetKey or not Steal.TargetEnabled then
                        clearTargetTracer()
                        return
                    end
                    local cam = workspace.CurrentCamera
                    local lp = Players.LocalPlayer
                    local char = lp and lp.Character
                    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    local tgt = part
                    if not (tgt and tgt.Parent) then
                        local m2, p2 = getTargetWorldPart()
                        if p2 then
                            part = p2
                            tgt = p2
                            if m2 then ensureWhiteHighlight(m2:IsA("Model") and m2 or model) end
                        else
                            if targetTracer then pcall(function() targetTracer.Visible = false end) end
                            return
                        end
                    end
                    if not (cam and hrp and tgt) then
                        if targetTracer then pcall(function() targetTracer.Visible = false end) end
                        return
                    end
                    local from = cam:WorldToViewportPoint(hrp.Position)
                    local to = cam:WorldToViewportPoint(tgt.Position)
                    local onScreen = from.Z > 0 and to.Z > 0
                    pcall(function()
                        targetTracer.From = Vector2.new(from.X, from.Y)
                        targetTracer.To = Vector2.new(to.X, to.Y)
                        targetTracer.Visible = onScreen
                        targetTracer.Color = white
                    end)
                end)
                return
            end

            -- Fallback: Beam between player and target
            local lp = Players.LocalPlayer
            local char = lp and lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            targetTracerMode = "beam"
            targetTracerAtt0 = Instance.new("Attachment")
            targetTracerAtt0.Name = "NoxST_Att0"
            targetTracerAtt0.Parent = hrp
            targetTracerAtt1 = Instance.new("Attachment")
            targetTracerAtt1.Name = "NoxST_Att1"
            targetTracerAtt1.Parent = part
            local beam = Instance.new("Beam")
            beam.Name = "NoxStealTargetTracer"
            beam.Attachment0 = targetTracerAtt0
            beam.Attachment1 = targetTracerAtt1
            beam.Color = ColorSequence.new(white)
            beam.Width0 = 0.12
            beam.Width1 = 0.12
            beam.FaceCamera = true
            beam.LightEmission = 1
            beam.LightInfluence = 0
            beam.Transparency = NumberSequence.new(0.15)
            beam.Segments = 10
            beam.Parent = hrp
            targetTracer = beam

            targetTracerConn = RunService.RenderStepped:Connect(function()
                if not Steal.TargetKey or not Steal.TargetEnabled then
                    clearTargetTracer()
                    return
                end
                local c = Players.LocalPlayer and Players.LocalPlayer.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if h and targetTracerAtt0 and targetTracerAtt0.Parent ~= h then
                    targetTracerAtt0.Parent = h
                    if targetTracer and targetTracer.Parent then
                        targetTracer.Parent = h
                    end
                end
                if not (part and part.Parent) then
                    local m2, p2 = getTargetWorldPart()
                    if p2 and targetTracerAtt1 then
                        part = p2
                        targetTracerAtt1.Parent = p2
                        if m2 and m2:IsA("Model") then ensureWhiteHighlight(m2) end
                    end
                end
            end)
        end

        local function startHighlightRefresh()
            stopHighlightRefresh()
            hlRefreshConn = task.spawn(function()
                while Steal.TargetEnabled and Steal.TargetKey do
                    pcall(updateTargetHighlight)
                    task.wait(1.0)
                end
                hlRefreshConn = nil
            end)
        end

        updateTargetHighlight = function()
            if not Steal.TargetEnabled or not Steal.TargetKey then
                clearTargetHighlight()
                return
            end
            local model, part = getTargetWorldPart()
            if not model and not part then
                -- keep trying; don't spam destroy if briefly missing
                return
            end
            if model and model:IsA("Model") then
                ensureWhiteHighlight(model)
            elseif part then
                -- highlight parent model if any
                local m = part:FindFirstAncestorOfClass("Model") or part
                ensureWhiteHighlight(m)
            end
            -- Tracer always on while selected
            if not targetTracer or targetTracerMode == nil then
                startTargetTracer(model, part)
            elseif targetTracerMode == "beam" and targetTracerAtt1 and part and targetTracerAtt1.Parent ~= part then
                pcall(function() targetTracerAtt1.Parent = part end)
            end
        end

        local function makeCase(parent, data, colors)
            local isSel = (Steal.TargetKey ~= nil and Steal.TargetKey == data.key)
            local cell = Instance.new("Frame")
            cell.Name = "BR_" .. data.key:gsub("%W", "_")
            cell.Size = UDim2.new(0, 96, 0, 118)
            cell.BackgroundColor3 = isSel and colors.cardSel or colors.card
            cell.BackgroundTransparency = 0.1
            cell.BorderSizePixel = 0
            cell.Parent = parent
            Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 12)
            local st = Instance.new("UIStroke")
            st.Name = "CaseStroke"
            st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local selCol = Color3.fromRGB(255, 255, 255)
            st.Color = isSel and selCol or Color3.fromRGB(0, 0, 0)
            st.Thickness = isSel and 3.5 or 1
            st.Transparency = isSel and 0 or 0.55
            st.Parent = cell

            local VP = 68
            local vp = Instance.new("ViewportFrame")
            vp.Name = "VP"
            vp.Size = UDim2.new(0, VP, 0, VP)
            vp.Position = UDim2.new(0.5, -VP/2, 0, 6)
            vp.BackgroundTransparency = 1
            vp.BorderSizePixel = 0
            vp.ZIndex = 5
            vp.Parent = cell
            local cam = Instance.new("Camera")
            cam.Parent = vp
            vp.CurrentCamera = cam
            attachViewport(vp, data)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "NameLbl"
            nameLbl.Size = UDim2.new(1, -6, 0, 36)
            nameLbl.Position = UDim2.new(0, 3, 1, -40)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = data.label or data.display
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Center
            nameLbl.TextYAlignment = Enum.TextYAlignment.Top
            nameLbl.TextWrapped = true
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.ZIndex = 6
            nameLbl.Parent = cell

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 10
            btn.Parent = cell
            btn.MouseButton1Click:Connect(function()
                if Steal.TargetKey == data.key then
                    selectedName = nil
                    Steal.TargetName = nil
                    Steal.TargetKey = nil
                    Steal.TargetPlot = nil
                    Steal.TargetSlot = nil
                    Steal.TargetEnabled = false
                else
                    selectedName = data.display
                    local ot = data.prompt and tostring(data.prompt.ObjectText or "") or data.name
                    Steal.TargetName = ot
                    Steal.TargetKey = data.key
                    Steal.TargetEnabled = true
                    Steal.TargetPlot = data.plotName
                    Steal.TargetSlot = data.slot
                end
                pcall(function()
                    Config.set("stealTargetName", Steal.TargetName)
                    Config.set("stealTargetKey", Steal.TargetKey)
                    Config.set("stealTargetPlot", Steal.TargetPlot)
                    Config.set("stealTargetSlot", Steal.TargetSlot)
                end)
                pcall(function()
                    local msg = Steal.TargetKey and (tostring(data.display) .. (data.money ~= "" and (" " .. data.money) or "")) or "Aucun"
                    if showToast then showToast("Steal Target: " .. msg, Steal.TargetKey ~= nil) end
                end)
                refreshList(false)
                task.defer(function()
                    updateTargetHighlight()
                    if Steal.TargetKey then
                        startHighlightRefresh()
                    else
                        stopHighlightRefresh()
                    end
                end)
            end)

            knownCases[data.key] = { cell = cell, vp = vp, nameLbl = nameLbl, stroke = st, data = data }
            return cell
        end

        local function selStrokeColor(colors)
            return Color3.fromRGB(168, 85, 247)
        end

        local function paintCase(entry, colors)
            if not entry or not entry.cell then return end
            local data = entry.data
            local isSel = (Steal.TargetKey ~= nil and Steal.TargetKey == data.key)
            entry.cell.BackgroundColor3 = isSel and colors.cardSel or colors.card
            if entry.stroke then
                entry.stroke.Color = isSel and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(0, 0, 0)
                entry.stroke.Thickness = isSel and 3.5 or 1
                entry.stroke.Transparency = isSel and 0 or 0.55
            end
            if entry.nameLbl then
                entry.nameLbl.Text = data.label or data.display
                entry.nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end

        local function matchesSearch(data)
            local q = tostring(searchQuery or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
            if q == "" then return true end
            if not data then return false end
            local hay = table.concat({
                tostring(data.name or ""),
                tostring(data.display or ""),
                tostring(data.label or ""),
                tostring(data.mutation or ""),
                tostring(data.money or ""),
                tostring(data.plotName or ""),
            }, " "):lower()
            for token in string.gmatch(q, "%S+") do
                if not hay:find(token, 1, true) then
                    return false
                end
            end
            return true
        end

        function refreshList(forceRebuild)
            if not scroll then return end
            local colors = themeColors()
            local list = collectAllBrainrots()
            local keys = {}
            local set = {}
            for _, d in ipairs(list) do
                table.insert(keys, d.key)
                set[d.key] = d
            end
            table.sort(keys)
            local fp = table.concat(keys, "||")
            local structureChanged = (fp ~= lastFingerprint)

            if forceRebuild or structureChanged then
                lastFingerprint = fp

                for key, entry in pairs(knownCases) do
                    if not set[key] then
                        pcall(function() if entry.cell then entry.cell:Destroy() end end)
                        knownCases[key] = nil
                    end
                end

                for _, data in ipairs(list) do
                    if not knownCases[data.key] then
                        makeCase(scroll, data, colors)
                    else
                        knownCases[data.key].data = data
                        paintCase(knownCases[data.key], colors)
                    end
                end
            else
                for key, entry in pairs(knownCases) do
                    if set[key] then
                        entry.data = set[key]
                    end
                    paintCase(entry, colors)
                end
            end

            local visibleCount = 0
            for key, entry in pairs(knownCases) do
                if entry and entry.cell then
                    local data = entry.data or set[key]
                    local ok = matchesSearch(data)
                    entry.cell.Visible = ok and true or false
                    if ok then visibleCount = visibleCount + 1 end
                end
            end

            local emptyMsg
            if #list == 0 then
                emptyMsg = "Aucun Brainrot trouvable…"
            elseif visibleCount == 0 and tostring(searchQuery or ""):gsub("%s+", "") ~= "" then
                emptyMsg = "Aucun résultat pour « " .. tostring(searchQuery) .. " »"
            end

            local hasEmpty = false
            local emptyLbl = nil
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("TextLabel") and c.Name == "EmptyLbl" then
                    hasEmpty = true
                    emptyLbl = c
                    break
                end
            end
            if emptyMsg then
                if not emptyLbl then
                    emptyLbl = Instance.new("TextLabel")
                    emptyLbl.Name = "EmptyLbl"
                    emptyLbl.Size = UDim2.new(1, -12, 0, 40)
                    emptyLbl.BackgroundTransparency = 1
                    emptyLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
                    emptyLbl.Font = Enum.Font.Gotham
                    emptyLbl.TextSize = 12
                    emptyLbl.TextWrapped = true
                    emptyLbl.Parent = scroll
                end
                emptyLbl.Text = emptyMsg
                emptyLbl.Visible = true
            else
                if emptyLbl then emptyLbl:Destroy() end
            end
        end

        local function applyThemeToGui()
            if not gui or not gui.Parent then return end
            local colors = themeColors()
            local frame = gui:FindFirstChild("Frame")
            if not frame then return end
            frame.BackgroundColor3 = colors.body
            local titleBar = frame:FindFirstChild("TitleBar")
            if titleBar then titleBar.BackgroundColor3 = colors.titleBar end
            local stroke = frame:FindFirstChildOfClass("UIStroke")
            if stroke then
                local grad = stroke:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, colors.primary),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                    })
                end
            end
            local minBtnTheme = titleBar and titleBar:FindFirstChild("MinBtn")
            if minBtnTheme then minBtnTheme.BackgroundColor3 = colors.closeBg end

            for _, entry in pairs(knownCases) do
                paintCase(entry, colors)
            end
        end

        local function buildGui()
            destroyGui()
            local pg = LP:WaitForChild("PlayerGui")
            gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_StealTarget"
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 210
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = pg

            local colors = themeColors()
            local frame = Instance.new("Frame")
            frame.Name = "Frame"
            frame.Size = UDim2.new(0, 220, 0, 310)
            frame.Position = UDim2.new(0.5, -110, 0.5, -155)
            frame.BackgroundColor3 = colors.body
            frame.BackgroundTransparency = 0.12
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Visible = false

            pcall(function()
                local loadedSize = false
                if loadGuiSize then
                    loadedSize = loadGuiSize("PanelGui_StealTarget", frame, 160, 200)
                end
                if not loadedSize then
                    local s = Config.get("steal_target_size", nil)
                    if type(s) == "table" and s[1] and s[2] then
                        local w = math.max(160, tonumber(s[1]) or 220)
                        local h = math.max(200, tonumber(s[2]) or 310)
                        frame.Size = UDim2.new(0, w, 0, h)
                    end
                end
                local loadedPos = false
                if loadGuiPosition then
                    loadedPos = loadGuiPosition("PanelGui_StealTarget", frame)
                end
                if not loadedPos then
                    local p = Config.get("steal_target_pos", nil)
                    if type(p) == "table" and #p >= 4 then
                        frame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                        if saveGuiPosition then
                            saveGuiPosition("PanelGui_StealTarget", frame)
                        end
                    end
                end
            end)
            frame.Parent = gui
            frame.Visible = true
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
            task.defer(function()
            end)
            local stroke = Instance.new("UIStroke")
            stroke.Color = colors.stroke
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = frame
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, colors.primary),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            })
            grad.Rotation = 205
            grad.Parent = stroke

            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 30)
            titleBar.BackgroundColor3 = colors.titleBar
            titleBar.BorderSizePixel = 0
            titleBar.Parent = frame
            Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 0, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "Steal Target"
            title.TextColor3 = colors.text
            title.Font = Enum.Font.GothamBold
            title.TextSize = 15
            title.TextXAlignment = Enum.TextXAlignment.Center
            title.TextYAlignment = Enum.TextYAlignment.Center
            title.Parent = titleBar

            local minBtn = Instance.new("TextButton")
            minBtn.Name = "MinBtn"
            minBtn.Size = UDim2.new(0, 24, 0, 24)
            minBtn.Position = UDim2.new(1, -30, 0.5, -12)
            minBtn.BackgroundColor3 = colors.closeBg
            minBtn.Text = "–"
            minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            minBtn.Font = Enum.Font.GothamBold
            minBtn.TextSize = 16
            minBtn.AutoButtonColor = false
            minBtn.ZIndex = 25
            minBtn.Active = true
            minBtn.Parent = titleBar
            Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

            local _stMinimized = false
            local _stExpandedSize = UDim2.new(0, 220, 0, 310)
            local function toggleStealMinimize()
                if not frame then return end
                _stMinimized = not _stMinimized
                local searchWrap = frame:FindFirstChild("SearchWrap")
                if searchWrap then searchWrap.Visible = not _stMinimized end
                if scroll then scroll.Visible = not _stMinimized end
                if _stMinimized then
                    _stExpandedSize = frame.Size
                    frame.Size = UDim2.new(
                        frame.Size.X.Scale, frame.Size.X.Offset,
                        0, 30
                    )
                    minBtn.Text = "+"
                else
                    frame.Size = _stExpandedSize or UDim2.new(0, 220, 0, 310)
                    minBtn.Text = "–"
                    pcall(function()
                        if scaleStealTargetCases then scaleStealTargetCases() end
                    end)
                end
            end
            minBtn.Activated:Connect(toggleStealMinimize)
            minBtn.MouseButton1Click:Connect(toggleStealMinimize)

            pcall(function()
                local drag = _G.makePanelDraggable or makePanelDraggable
                if drag then drag(titleBar, frame, "PanelGui_StealTarget") end
            end)
            pcall(function()
                local lastSave = 0
                local function mirrorPos()
                    if not frame or not frame.Parent then return end
                    local now = tick()
                    if now - lastSave < 0.15 then return end
                    lastSave = now
                    local pos = {
                        frame.Position.X.Scale, frame.Position.X.Offset,
                        frame.Position.Y.Scale, frame.Position.Y.Offset,
                    }
                    if Config then
                        Config.set("steal_target_pos", pos)
                        if saveGuiPosition then
                            saveGuiPosition("PanelGui_StealTarget", frame)
                        end
                        if Config.flush then Config.flush() end
                    end
                end
                if titleBar then
                    titleBar.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1
                            or inp.UserInputType == Enum.UserInputType.Touch then
                            task.defer(mirrorPos)
                        end
                    end)
                end
                local UIS = game:GetService("UserInputService")
                UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                        task.defer(mirrorPos)
                    end
                end)
            end)

            local searchWrap = Instance.new("Frame")
            searchWrap.Name = "SearchWrap"
            searchWrap.Size = UDim2.new(1, -12, 0, 28)
            searchWrap.Position = UDim2.new(0, 6, 0, 34)
            searchWrap.BackgroundColor3 = colors.titleBar
            searchWrap.BackgroundTransparency = 0.08
            searchWrap.BorderSizePixel = 0
            searchWrap.ZIndex = 5
            searchWrap.Parent = frame
            Instance.new("UICorner", searchWrap).CornerRadius = UDim.new(0, 12)
            local searchStroke = Instance.new("UIStroke")
            searchStroke.Color = colors.primary
            searchStroke.Thickness = 1.2
            searchStroke.Transparency = 0.4
            searchStroke.Parent = searchWrap

            local searchIcon = Instance.new("TextLabel")
            searchIcon.Size = UDim2.new(0, 22, 1, 0)
            searchIcon.Position = UDim2.new(0, 4, 0, 0)
            searchIcon.BackgroundTransparency = 1
            searchIcon.Text = "⌕"
            searchIcon.TextColor3 = colors.text
            searchIcon.TextTransparency = 0.2
            searchIcon.Font = Enum.Font.GothamBold
            searchIcon.TextSize = 14
            searchIcon.ZIndex = 6
            searchIcon.Parent = searchWrap

            searchBox = Instance.new("TextBox")
            searchBox.Name = "SearchBox"
            searchBox.Size = UDim2.new(1, -52, 1, -4)
            searchBox.Position = UDim2.new(0, 26, 0, 2)
            searchBox.BackgroundTransparency = 1
            searchBox.ClearTextOnFocus = false
            searchBox.Text = searchQuery or ""
            searchBox.PlaceholderText = "Nom du brainrot..."
            searchBox.PlaceholderColor3 = Color3.fromRGB(140, 145, 165)
            searchBox.TextColor3 = colors.text
            searchBox.Font = Enum.Font.Gotham
            searchBox.TextSize = 12
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.TextTruncate = Enum.TextTruncate.AtEnd
            searchBox.ZIndex = 6
            searchBox.Parent = searchWrap

            local clearBtn = Instance.new("TextButton")
            clearBtn.Name = "ClearSearch"
            clearBtn.Size = UDim2.new(0, 22, 0, 22)
            clearBtn.Position = UDim2.new(1, -24, 0.5, -11)
            clearBtn.BackgroundTransparency = 1
            clearBtn.Text = "×"
            clearBtn.TextColor3 = colors.text
            clearBtn.TextTransparency = 0.35
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 14
            clearBtn.ZIndex = 7
            clearBtn.Visible = (searchQuery or "") ~= ""
            clearBtn.Parent = searchWrap

            local function applySearch(textVal)
                searchQuery = tostring(textVal or "")
                clearBtn.Visible = searchQuery:gsub("%s+", "") ~= ""
                refreshList(true)
            end

            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                applySearch(searchBox.Text)
            end)
            searchBox.FocusLost:Connect(function()
                applySearch(searchBox.Text)
            end)
            clearBtn.Activated:Connect(function()
                searchBox.Text = ""
                applySearch("")
            end)
            clearBtn.MouseButton1Click:Connect(function()
                searchBox.Text = ""
                applySearch("")
            end)

            scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, -12, 1, -70)
            scroll.Position = UDim2.new(0, 6, 0, 66)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.ScrollBarThickness = 5
            scroll.ScrollBarImageTransparency = 0.2
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.Parent = frame

            local grid = Instance.new("UIGridLayout")
            grid.Name = "StealTargetGrid"
            grid.CellSize = UDim2.new(0, 96, 0, 118)
            grid.CellPadding = UDim2.new(0, 6, 0, 6)
            grid.FillDirection = Enum.FillDirection.Horizontal
            grid.FillDirectionMaxCells = 2
            grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
            grid.VerticalAlignment = Enum.VerticalAlignment.Top
            grid.StartCorner = Enum.StartCorner.TopLeft
            grid.SortOrder = Enum.SortOrder.LayoutOrder
            grid.Parent = scroll

            local COLS = 2
            local function scaleStealTargetCases()
                if not frame or not frame.Parent or not grid or not grid.Parent then return end
                if not scroll or not scroll.Parent then return end
                local aw = scroll.AbsoluteSize.X
                if aw < 40 then
                    aw = frame.AbsoluteSize.X - 12
                end
                if aw < 40 then return end

                local pad = 6
                local sb = (scroll.ScrollBarThickness or 5) + 2
                local avail = math.max(80, aw - sb - pad * (COLS + 1))
                local cw = math.floor(avail / COLS)
                cw = math.clamp(cw, 72, 140)
                local ch = math.floor(cw * 1.22 + 0.5)
                ch = math.clamp(ch, 90, 170)
                local scale = cw / 96
                local vp = math.clamp(math.floor(68 * scale + 0.5), 48, 100)
                local nh = math.clamp(math.floor(28 * scale + 0.5), 20, 40)

                grid.FillDirectionMaxCells = COLS
                grid.CellSize = UDim2.new(0, cw, 0, ch)
                grid.CellPadding = UDim2.new(0, pad, 0, pad)

                for _, entry in pairs(knownCases) do
                    if entry.cell then
                        entry.cell.Size = UDim2.new(0, cw, 0, ch)
                    end
                    if entry.vp then
                        entry.vp.Size = UDim2.new(0, vp, 0, vp)
                        entry.vp.Position = UDim2.new(0.5, -math.floor(vp / 2), 0, math.max(4, math.floor(5 * scale)))
                    end
                    if entry.nameLbl then
                        entry.nameLbl.Size = UDim2.new(1, -4, 0, nh)
                        entry.nameLbl.Position = UDim2.new(0, 2, 1, -(nh + 3))
                        entry.nameLbl.TextSize = math.clamp(math.floor(10 * scale), 8, 13)
                    end
                end
            end

            frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                scaleStealTargetCases()
            end)
            scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                scaleStealTargetCases()
            end)
            task.defer(scaleStealTargetCases)

            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 6)
            pad.PaddingBottom = UDim.new(0, 8)
            pad.PaddingLeft = UDim.new(0, 4)
            pad.PaddingRight = UDim.new(0, 4)
            pad.Parent = scroll

            if type(_G.coreThemeListeners) ~= "table" then
                _G.coreThemeListeners = {}
            end
            table.insert(_G.coreThemeListeners, function()
                pcall(applyThemeToGui)

                if targetHighlight and targetHighlight.Parent then
                    local col = getSelHighlightColor()
                    targetHighlight.FillColor = col
                    targetHighlight.OutlineColor = col
                else
                    pcall(updateTargetHighlight)
                end
            end)

            selectedName = Steal.TargetName
            refreshList(true)
            task.defer(updateTargetHighlight)
            refreshConn = task.spawn(function()
                while gui and gui.Parent do
                    task.wait(6.0)
                    if not (gui and gui.Parent) then break end
                    refreshList(false)
                    if Steal.TargetKey and (not targetHighlight or not targetHighlight.Parent) then
                        pcall(updateTargetHighlight)
                    end
                end
            end)
        end

        local M = {}
        -- Panel visibility independent of feature:
        -- selected target keeps working until user deselects it.
        function M.set(on)
            on = on and true or false
            pcall(function()
                if Config then
                    Config.set("toggle:Steal Target", on)
                    Config.set("steal_target_panel_visible", on)
                end
            end)
            if on then
                pcall(function()
                    if not Steal.TargetKey and Config then
                        local k = Config.get("stealTargetKey", nil)
                        local n = Config.get("stealTargetName", nil)
                        if k then
                            Steal.TargetKey = k
                            Steal.TargetName = n
                            Steal.TargetPlot = Config.get("stealTargetPlot", nil)
                            Steal.TargetSlot = Config.get("stealTargetSlot", nil)
                            selectedName = n
                            Steal.TargetEnabled = true
                        end
                    elseif Steal.TargetKey then
                        Steal.TargetEnabled = true
                    end
                end)
                buildGui()
                task.defer(function()
                    updateTargetHighlight()
                    startHighlightRefresh()
                end)
            else
                -- Hide panel only — keep target active
                destroyGui()
                if Steal.TargetKey then
                    Steal.TargetEnabled = true
                    task.defer(function()
                        updateTargetHighlight()
                        startHighlightRefresh()
                    end)
                end
            end
        end
        function M.isOpen()
            return gui ~= nil and gui.Parent ~= nil
        end
        function M.refresh()
            if gui and gui.Parent then refreshList() end
        end
        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.StealTarget and _G.StealTarget.set then _G.StealTarget.set(false) end
        end)
    end)

    do
        local _cfg = _G.coreConfig
        if not _cfg then
            _cfg = {}
            function _cfg:get(k, default)
                if Config then
                    local v = Config.get("isv2:" .. tostring(k), nil)
                    if v == nil then v = Config.get(k, default) end
                    if v == nil then return default end
                    return v
                end
                return default
            end
            function _cfg:set(k, v)
                if Config then
                    Config.set("isv2:" .. tostring(k), v)
                    Config.set(k, v)
                end
            end
            function _cfg:flush() end
            _G.coreConfig = _cfg
        end
        if not _G.coreNotify then
            _G.coreNotify = {
                show = function(a, b)
                    pcall(function()
                        if showToast then showToast(tostring(a) .. ": " .. tostring(b), true) end
                    end)
                end
            }
        end
    end

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local HALF = {}

    HALF.potion = false
    HALF.debounce = false
    HALF.activated = false
    HALF.selectedSlot = 1
    HALF.autoAPSpam = false
    HALF.autoSemiAPSpam = false
    HALF.autoTpOnAllow = false
    HALF._autoTpOnAllowConn = nil
    HALF._lastAllowFire = 0
    HALF.autoTpOnUnlock = false
    HALF._autoTpOnUnlockConn = nil
    HALF._lastUnlockFire = 0
    HALF.autoWalk = false
    HALF.autoWalkTarget = Vector3.new(-345.75, -5.89, 26.54)
    HALF._autoWalkRunning = false
    HALF._autoWalkCancel = false
    HALF.autoActivate = false
    HALF.grappleBoost = false
    HALF._grappleBoostConn = nil

    pcall(function()
        local function get(k, d)
            if _G.coreConfig and _G.coreConfig.get then
                local ok, v = pcall(function() return _G.coreConfig:get(k, d) end)
                if ok and v ~= nil then return v end
            end
            if Config and Config.get then
                local ok, v = pcall(function() return Config.get(k, d) end)
                if ok and v ~= nil then return v end
            end
            return d
        end
        local s = tonumber(get("isv2_slot", 1))
        if s then HALF.selectedSlot = math.clamp(s, 1, 11) end
        HALF.autoTpOnAllow = get("isv2_autoTpOnAllow", false) and true or false
        HALF.autoTpOnUnlock = get("isv2_autoTpOnUnlock", false) and true or false
        HALF.potion = get("isv2_autoPotion", false) and true or false
        HALF.autoWalk = get("isv2_autoWalk", false) and true or false
        HALF.autoActivate = get("isv2_autoActivate", false) and true or false
        HALF.grappleBoost = get("isv2_grappleBoost", false) and true or false
    end)

    local BASES = {
        b1 = { ref = Vector3.new(-337, -5, 100), final = Vector3.new(-337, -5, 103), walkPos = Vector3.new(-348, -7, 4) },
        b2 = { ref = Vector3.new(-335, -5, 20), final = Vector3.new(-334.80, -5.04, 18.90, 0, 0), walkPos = Vector3.new(-348, -7, 4) },
    }

    local function instaReset()
        local flags = {
            {"GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000"},
            {"LargeReplicatorWrite5", "true"},
            {"LargeReplicatorEnabled9", "true"},
            {"AngularVelociryLimit", "360"},
            {"TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646"},
            {"S2PhysicsSenderRate", "15000"},
            {"DisableDPIScale", "true"},
            {"MaxDataPacketPerSend", "2147483647"},
            {"ServerMaxBandwith", "52"},
            {"PhysicsSenderMaxBandwidthBps", "20000"},
            {"MaxTimestepMultiplierBuoyancy", "2147483647"},
            {"SimOwnedNOUCountThresholdMillionth", "2147483647"},
            {"MaxMissedWorldStepsRemembered", "-2147483648"},
            {"CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1"},
            {"StreamJobNOUVolumeLengthCap", "2147483647"},
            {"DebugSendDistInSteps", "-2147483648"},
            {"MaxTimestepMultiplierAcceleration", "2147483647"},
            {"LargeReplicatorRead5", "true"},
            {"SimExplicitlyCappedTimestepMultiplier", "2147483646"},
            {"GameNetDontSendRedundantNumTimes", "1"},
            {"CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1"},
            {"CheckPVCachedRotVelThresholdPercent", "10"},
            {"LargeReplicatorSerializeRead3", "true"},
            {"ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647"},
            {"NextGenReplicatorEnabledWrite4", "true"},
            {"CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1"},
            {"GameNetDontSendRedundantDeltaPositionMillionth", "1"},
            {"InterpolationFrameVelocityThresholdMillionth", "5"},
            {"StreamJobNOUVolumeCap", "2147483647"},
            {"InterpolationFrameRotVelocityThresholdMillionth", "5"},
            {"WorldStepMax", "30"},
            {"TimestepArbiterHumanoidLinearVelThreshold", "1"},
            {"InterpolationFramePositionThresholdMillionth", "5"},
            {"TimestepArbiterHumanoidTurningVelThreshold", "1"},
            {"MaxTimestepMultiplierContstraint", "2147483647"},
            {"GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000"},
            {"CheckPVCachedVelThresholdPercent", "10"},
            {"TimestepArbiterOmegaThou", "1073741823"},
            {"MaxAcceptableUpdateDelay", "1"},
            {"LargeReplicatorSerializeWrite4", "true"},
        }
        for _, data in ipairs(flags) do
            pcall(function()
                if setfflag then setfflag(data[1], data[2]) end
            end)
        end

        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
            end
            pcall(function() char:ClearAllChildren() end)
            local f = Instance.new("Model", workspace)
            player.Character = f
            task.wait()
            player.Character = char
            f:Destroy()
        end

        HALF.debounce = false
        HALF.activated = false
        HALF._semiStealCtx = nil
        pcall(function() if equipCarpet then equipCarpet() end end)
    end

    local function getMyPlot()
        local out = {}
        local myName = player.DisplayName
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return out end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local label = sign and sign:FindFirstChild("SurfaceGui")
                and sign.SurfaceGui:FindFirstChild("Frame")
                and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
            if label then
                local owner = label.Text:gsub("'s Base$",""):gsub("'s base$",""):gsub("%s+$","")
                if owner == myName then table.insert(out, plot) end
            end
        end
        return out
    end

    local function getCurrentBase()
        local myPlots = getMyPlot()
        if #myPlots == 0 then return BASES.b1 end
        local myPlot = myPlots[1]
        local plotPos = nil
        for _, part in ipairs(myPlot:GetDescendants()) do
            if part:IsA("BasePart") then plotPos = part.Position; break end
        end
        if not plotPos then return BASES.b1 end
        local d1 = (plotPos - BASES.b1.ref).Magnitude
        local d2 = (plotPos - BASES.b2.ref).Magnitude
        return d1 < d2 and BASES.b1 or BASES.b2
    end

    local function setFFlags()
        if type(setfflag) ~= "function" then return end
        pcall(function() setfflag("DisableDPIScale", "true") end)
    end

    local CARPET_NAMES = {
        "Flying Carpet",
        "Cupid's Wings",
        "Witch's Broom",
        "Waverider",
        "Santa's Sleigh",
    }

    _G.coreSelectedCarpet = _G.coreSelectedCarpet or nil
    pcall(function()
        if _G.coreConfig then
            _G.coreSelectedCarpet = _G.coreConfig:get("selectedCarpet", "Flying Carpet")
        end
    end)
    pcall(function()
        if Config then
            local sel = Config.get("selectedCarpet", nil)
            if type(sel) == "string" and sel ~= "" then
                _G.coreSelectedCarpet = sel
            elseif not _G.coreSelectedCarpet then
                _G.coreSelectedCarpet = "Flying Carpet"
            end
        elseif not _G.coreSelectedCarpet then
            _G.coreSelectedCarpet = "Flying Carpet"
        end
    end)
    _G.CyutsudHubSelectedCarpet = _G.coreSelectedCarpet
    _G.CyutsudHubSelectedCarpet = _G.coreSelectedCarpet

    local function findCarpetTool(container, preferred)
        if not container then return nil end
        if preferred and preferred ~= "" then
            local t = container:FindFirstChild(preferred)
            if t and t:IsA("Tool") then return t end
        end
        for _, name in ipairs(CARPET_NAMES) do
            local t = container:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end

        for _, t in ipairs(container:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("carpet") or n:find("broom") or n:find("wing") or n:find("sleigh")
                   or n:find("waverider") or n:find("hover") or n:find("jetpack") or n:find("cloud") then
                    return t
                end
            end
        end
        return nil
    end

    local function equipCarpet()
        local char = player.Character
        local bp = player:FindFirstChild("Backpack")
        if not char or not bp then return end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                pcall(function() t.Parent = bp end)
            end
        end
        local preferred = _G.coreSelectedCarpet or _G.CyutsudHubSelectedCarpet
        local carpet = findCarpetTool(bp, preferred) or findCarpetTool(char, preferred)
        if carpet then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum:EquipTool(carpet) end)
            end
        end
    end
    _G.equipCarpet = equipCarpet
    _G._CyutsudEquipCarpet = equipCarpet

    local function canDirectTp(hrp, pos)
        if not hrp or not pos then return false end
        local origin = hrp.Position
        local ignored = { player.Character }
        for _ = 1, 12 do
            local dir = pos - origin
            if dir.Magnitude <= 0.05 then return true end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Blacklist
            params.FilterDescendantsInstances = ignored
            params.IgnoreWater = true
            local result = Workspace:Raycast(origin, dir, params)
            if not result then return true end
            local hit = result.Instance
            if not hit then return true end
            if hit:IsA("BasePart") and not hit.CanCollide then
                table.insert(ignored, hit)
                origin = result.Position + dir.Unit * 0.1
            else
                return (result.Position - pos).Magnitude <= 3
            end
        end
        return false
    end

    local function walkTo(hrp, pos, speed, arriveDist, timeout)
        if not hrp or not hrp.Parent or not pos then return end
        speed = speed or 180
        arriveDist = arriveDist or 6
        timeout = timeout or 6
        equipCarpet()
        local ctrls
        pcall(function()
            ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
        end)
        if ctrls then pcall(function() ctrls:Disable() end) end

        local start = tick()
        while hrp and hrp.Parent do
            local d = pos - hrp.Position
            local flat = Vector3.new(d.X, 0, d.Z)
            local mag = flat.Magnitude
            local vert = d.Y
            if mag < arriveDist then
                if math.abs(vert) > 2.5 then
                    hrp.Velocity = Vector3.new()
                    hrp.CFrame = CFrame.new(pos)
                end
                break
            end
            if mag < arriveDist * 2.5 and math.abs(vert) > 8 then
                hrp.Velocity = Vector3.new()
                hrp.CFrame = CFrame.new(pos)
                break
            end
            if tick() - start > timeout then break end
            local effSpeed = mag < 25 and math.max(60, speed * (mag / 25)) or speed
            local vy = hrp.Velocity.Y
            if math.abs(vert) > 6 then
                vy = math.clamp(vert * 2.5, -120, 120)
            end
            if flat.Magnitude > 0.05 then
                hrp.Velocity = Vector3.new(flat.Unit.X * effSpeed, vy, flat.Unit.Z * effSpeed)
            else
                hrp.Velocity = Vector3.new(0, vy, 0)
            end
            task.wait()
        end
        if hrp and hrp.Parent then
            hrp.Velocity = Vector3.new()
            hrp.CFrame = CFrame.new(pos)
        end
        if ctrls then pcall(function() ctrls:Enable() end) end
    end

    local function getClosestPodium()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end

        local myName = player.DisplayName
        local enemyPlots = {}
        for _, p in ipairs(plots:GetChildren()) do
            local sign = p:FindFirstChild("PlotSign")
            local lbl = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame") and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
            if lbl and lbl.Text ~= "Empty Base" then
                local owner = lbl.Text:gsub("'s Base$", ""):gsub("'s base$", ""):gsub("%s+$", "")
                if owner ~= myName then
                    table.insert(enemyPlots, p)
                end
            end
        end
        if #enemyPlots == 0 then return nil end

        local best, bestDist = nil, math.huge
        for _, p in ipairs(enemyPlots) do
            local podiums = p:FindFirstChild("AnimalPodiums")
            if podiums then
                local pPos
                pcall(function()
                    pPos = p.PrimaryPart and p.PrimaryPart.Position or p:GetPivot().Position
                end)
                if not pPos then
                    local part = p:FindFirstChildWhichIsA("BasePart", true)
                    if part then pPos = part.Position end
                end
                local isB1 = pPos and (pPos - BASES.b1.ref).Magnitude < (pPos - BASES.b2.ref).Magnitude

                local targetNames = {}
                if HALF.selectedSlot == 2 then targetNames = {"2"}
                elseif HALF.selectedSlot == 3 then targetNames = {"3"}
                elseif HALF.selectedSlot == 4 then targetNames = {"4"}
                elseif HALF.selectedSlot == 5 then targetNames = {"5"}
                elseif HALF.selectedSlot == 6 then targetNames = {"6"}
                elseif HALF.selectedSlot == 7 then targetNames = {"7"}
                elseif HALF.selectedSlot == 8 then targetNames = {"8"}
                elseif HALF.selectedSlot == 9 then targetNames = {"9"}
                elseif HALF.selectedSlot == 10 then targetNames = {"10"}
                elseif HALF.selectedSlot == 11 then targetNames = {"11"}
                else targetNames = {"1"} end

                for _, name in ipairs(targetNames) do
                    local pod = podiums:FindFirstChild(name)
                    if pod then
                        local cm = pod:FindFirstChild("Claim") and pod.Claim:FindFirstChild("Main")
                        local pos = cm and cm.Position
                        if not pos then
                            local part = pod:FindFirstChildWhichIsA("BasePart", true)
                            if part then pos = part.Position end
                        end
                        if pos then
                            local d = (hrp.Position - pos).Magnitude
                            if d < bestDist then
                                local prompt = nil
                                for _, desc in ipairs(pod:GetDescendants()) do
                                    if desc:IsA("ProximityPrompt") then
                                        local at = (desc.ActionText or ""):lower()
                                        if at:find("steal") or at:find("grab") or at:find("take") or at == "" then
                                            prompt = desc
                                            break
                                        end
                                    end
                                end
                                if not prompt then
                                    for _, desc in ipairs(pod:GetDescendants()) do
                                        if desc:IsA("ProximityPrompt") then
                                            prompt = desc
                                            break
                                        end
                                    end
                                end
                                if prompt then
                                    best = {
                                        plot = p,
                                        podiumName = name,
                                        position = pos,
                                        prompt = prompt,
                                        isEnemyBase1 = isB1,
                                        distance = d,
                                    }
                                    bestDist = d
                                end
                            end
                        end
                    end
                end
            end
        end
        return best
    end

    -- Semi TP slot tracer + white highlight (follows selected slot brainrot)
    local _semiSlotHL = nil
    local _semiSlotHLModel = nil
    local _semiSlotTracer = nil
    local _semiSlotAtt0, _semiSlotAtt1 = nil, nil
    local _semiSlotTracerConn = nil
    local _semiSlotTracerMode = nil
    local _semiSlotRefresh = nil

    local function clearSemiSlotVisuals()
        if _semiSlotTracerConn then
            pcall(function() _semiSlotTracerConn:Disconnect() end)
            _semiSlotTracerConn = nil
        end
        if _semiSlotTracer then
            pcall(function()
                if typeof(_semiSlotTracer) == "Instance" then
                    _semiSlotTracer:Destroy()
                elseif type(_semiSlotTracer) == "table" then
                    if _semiSlotTracer.Remove then _semiSlotTracer:Remove()
                    elseif _semiSlotTracer.Destroy then _semiSlotTracer:Destroy() end
                end
            end)
            _semiSlotTracer = nil
        end
        if _semiSlotAtt0 then pcall(function() _semiSlotAtt0:Destroy() end) _semiSlotAtt0 = nil end
        if _semiSlotAtt1 then pcall(function() _semiSlotAtt1:Destroy() end) _semiSlotAtt1 = nil end
        _semiSlotTracerMode = nil
        if _semiSlotHL then
            pcall(function() _semiSlotHL:Destroy() end)
            _semiSlotHL = nil
        end
        _semiSlotHLModel = nil
    end

    local function getSemiSlotTargetPart()
        local info = getClosestPodium()
        if not info then return nil, nil, nil end
        local plot = info.plot
        local name = tostring(info.podiumName or HALF.selectedSlot or 1)
        local pods = plot and plot:FindFirstChild("AnimalPodiums")
        local pod = pods and pods:FindFirstChild(name)
        if not pod then return info, nil, nil end

        local model, part = nil, nil
        local base = pod:FindFirstChild("Base") or pod
        local sp = base and base:FindFirstChild("Spawn")
        if sp then
            for _, ch in ipairs(sp:GetChildren()) do
                if ch:IsA("Model") then
                    model = ch
                    break
                end
            end
            if not model then
                for _, d in ipairs(sp:GetDescendants()) do
                    if d:IsA("Model") and d:FindFirstChildWhichIsA("BasePart", true) then
                        model = d
                        break
                    end
                end
            end
        end
        if not model then
            for _, ch in ipairs(pod:GetChildren()) do
                if ch:IsA("Model") and ch.Name ~= "Claim" and ch.Name ~= "Base" then
                    model = ch
                    break
                end
            end
        end
        if model then
            part = model:FindFirstChild("HumanoidRootPart")
                or model.PrimaryPart
                or model:FindFirstChildWhichIsA("BasePart", true)
        end
        if not part then
            local cm = pod:FindFirstChild("Claim") and pod.Claim:FindFirstChild("Main")
            part = cm or pod:FindFirstChildWhichIsA("BasePart", true)
        end
        return info, model, part
    end

    local function ensureSemiSlotHighlight(modelOrPart)
        if not modelOrPart then return end
        local adornee = modelOrPart
        if _semiSlotHL and _semiSlotHL.Parent and _semiSlotHLModel == adornee then
            _semiSlotHL.FillColor = Color3.fromRGB(255, 255, 255)
            _semiSlotHL.OutlineColor = Color3.fromRGB(255, 255, 255)
            _semiSlotHL.FillTransparency = 0.45
            _semiSlotHL.OutlineTransparency = 0
            _semiSlotHL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            return
        end
        if _semiSlotHL then pcall(function() _semiSlotHL:Destroy() end) _semiSlotHL = nil end
        local hl = Instance.new("Highlight")
        hl.Name = "NoxSemiSlotHL"
        hl.Adornee = adornee
        hl.FillColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.45
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = adornee
        _semiSlotHL = hl
        _semiSlotHLModel = adornee
    end

    local function clearSemiSlotTracerOnly()
        if _semiSlotTracerConn then
            pcall(function() _semiSlotTracerConn:Disconnect() end)
            _semiSlotTracerConn = nil
        end
        if _semiSlotTracer then
            pcall(function()
                if typeof(_semiSlotTracer) == "Instance" then
                    _semiSlotTracer:Destroy()
                elseif type(_semiSlotTracer) == "table" then
                    if _semiSlotTracer.Remove then _semiSlotTracer:Remove()
                    elseif _semiSlotTracer.Destroy then _semiSlotTracer:Destroy() end
                end
            end)
            _semiSlotTracer = nil
        end
        if _semiSlotAtt0 then pcall(function() _semiSlotAtt0:Destroy() end) _semiSlotAtt0 = nil end
        if _semiSlotAtt1 then pcall(function() _semiSlotAtt1:Destroy() end) _semiSlotAtt1 = nil end
        _semiSlotTracerMode = nil
    end

    local function startSemiSlotTracer(part)
        if not part then return end
        -- keep existing drawing/beam if still valid for same part
        if _semiSlotTracer and _semiSlotTracerMode == "drawing" then
            return
        end
        if _semiSlotTracer and _semiSlotTracerMode == "beam" and _semiSlotAtt1 and _semiSlotAtt1.Parent == part then
            return
        end
        clearSemiSlotTracerOnly()
        local white = Color3.fromRGB(255, 255, 255)

        local okDraw, line = pcall(function()
            if type(Drawing) == "table" and type(Drawing.new) == "function" then
                return Drawing.new("Line")
            end
        end)
        if okDraw and line then
            _semiSlotTracerMode = "drawing"
            _semiSlotTracer = line
            pcall(function()
                line.Visible = true
                line.Color = white
                line.Thickness = 2
                line.Transparency = 0
                if line.ZIndex ~= nil then line.ZIndex = 20 end
            end)
            _semiSlotTracerConn = RunService.RenderStepped:Connect(function()
                if not HALF or not HALF.selectedSlot then
                    clearSemiSlotVisuals()
                    return
                end
                local cam = workspace.CurrentCamera
                local char = player.Character
                local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                local tgt = part
                if not (tgt and tgt.Parent) then
                    local _, model, p2 = getSemiSlotTargetPart()
                    if p2 then
                        part = p2
                        tgt = p2
                        if model then ensureSemiSlotHighlight(model) else ensureSemiSlotHighlight(p2) end
                    else
                        if _semiSlotTracer then pcall(function() _semiSlotTracer.Visible = false end) end
                        return
                    end
                end
                if not (cam and hrp and tgt) then
                    if _semiSlotTracer then pcall(function() _semiSlotTracer.Visible = false end) end
                    return
                end
                local from = cam:WorldToViewportPoint(hrp.Position)
                local to = cam:WorldToViewportPoint(tgt.Position)
                local onScreen = from.Z > 0 and to.Z > 0
                pcall(function()
                    _semiSlotTracer.From = Vector2.new(from.X, from.Y)
                    _semiSlotTracer.To = Vector2.new(to.X, to.Y)
                    _semiSlotTracer.Visible = onScreen
                    _semiSlotTracer.Color = white
                end)
            end)
            return
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        _semiSlotTracerMode = "beam"
        _semiSlotAtt0 = Instance.new("Attachment")
        _semiSlotAtt0.Name = "NoxSemiSlot_Att0"
        _semiSlotAtt0.Parent = hrp
        _semiSlotAtt1 = Instance.new("Attachment")
        _semiSlotAtt1.Name = "NoxSemiSlot_Att1"
        _semiSlotAtt1.Parent = part
        local beam = Instance.new("Beam")
        beam.Name = "NoxSemiSlotTracer"
        beam.Attachment0 = _semiSlotAtt0
        beam.Attachment1 = _semiSlotAtt1
        beam.Color = ColorSequence.new(white)
        beam.Width0 = 0.12
        beam.Width1 = 0.12
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Transparency = NumberSequence.new(0.15)
        beam.Segments = 10
        beam.Parent = hrp
        _semiSlotTracer = beam

        _semiSlotTracerConn = RunService.RenderStepped:Connect(function()
            local c = player.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if h and _semiSlotAtt0 and _semiSlotAtt0.Parent ~= h then
                _semiSlotAtt0.Parent = h
                if _semiSlotTracer and typeof(_semiSlotTracer) == "Instance" then
                    _semiSlotTracer.Parent = h
                end
            end
            if not (part and part.Parent) then
                local _, model, p2 = getSemiSlotTargetPart()
                if p2 and _semiSlotAtt1 then
                    part = p2
                    _semiSlotAtt1.Parent = p2
                    if model then ensureSemiSlotHighlight(model) else ensureSemiSlotHighlight(p2) end
                end
            end
        end)
    end

    local function updateSemiSlotVisuals()
        local info, model, part = getSemiSlotTargetPart()
        if not part then
            clearSemiSlotVisuals()
            return
        end
        -- Always rebuild tracer on slot change so line follows the new brainrot
        clearSemiSlotTracerOnly()
        if model then
            ensureSemiSlotHighlight(model)
        else
            ensureSemiSlotHighlight(part)
        end
        startSemiSlotTracer(part)
    end

    function HALF.setSelectedSlot(num)
        num = math.clamp(tonumber(num) or 1, 1, 11)
        HALF.selectedSlot = num
        pcall(function()
            if Config then Config.set("isv2_slot", num) end
        end)
        task.defer(updateSemiSlotVisuals)
    end

    HALF.updateSlotVisuals = updateSemiSlotVisuals
    HALF.clearSlotVisuals = clearSemiSlotVisuals

    -- Keep tracer alive / retarget closest podium for slot
    task.spawn(function()
        while true do
            task.wait(1.25)
            if _isShuttingDown and _isShuttingDown() then break end
            if HALF and HALF.selectedSlot and (HALF.activated or _G.InstantStealV2) then
                local open = false
                pcall(function()
                    if _G.InstantStealV2 and _G.InstantStealV2.isOpen then
                        open = _G.InstantStealV2.isOpen()
                    end
                end)
                -- always show while Instant Steal panel exists or activated
                local guiOpen = false
                pcall(function()
                    local pg = player:FindFirstChildOfClass("PlayerGui")
                    if pg and pg:FindFirstChild("PanelGui_Instant Steal V2") then guiOpen = true end
                    if typeof(gethui) == "function" then
                        local h = gethui()
                        if h and h:FindFirstChild("PanelGui_Instant Steal V2") then guiOpen = true end
                    end
                    local cg = game:GetService("CoreGui")
                    if cg:FindFirstChild("PanelGui_Instant Steal V2") then guiOpen = true end
                end)
                if guiOpen or HALF.activated then
                    pcall(updateSemiSlotVisuals)
                end
            end
        end
    end)


    local MIN_HOLD, TRIGGER_DELAY = 1.4, 0.02
    local cbCache = setmetatable({}, { __mode = "k" })

    local function getCallbacks(prompt)
        if cbCache[prompt] then return cbCache[prompt] end
        if type(getconnections) ~= "function" then return nil end
        local data = { hold = {}, trigger = {} }
        local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if ok1 then
            for _, c in ipairs(c1) do
                if type(c.Function) == "function" then
                    table.insert(data.hold, c.Function)
                end
            end
        end
        local ok2, c2 = pcall(getconnections, prompt.Triggered)
        if ok2 then
            for _, c in ipairs(c2) do
                if type(c.Function) == "function" then
                    table.insert(data.trigger, c.Function)
                end
            end
        end
        if #data.hold == 0 and #data.trigger == 0 then return nil end
        cbCache[prompt] = data
        return data
    end

    local function startHold(prompt)
        if not prompt or not prompt.Parent then return nil end
        local cb = getCallbacks(prompt)
        if cb then
            for _, fn in ipairs(cb.hold) do
                task.spawn(fn)
            end
        end
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt, MIN_HOLD)
            end
        end)
        local now = tick()
        return {
            prompt = prompt,
            cb = cb,
            ragdollFireTime = now,
            startedAt = now,
            holdBeganAt = now,
            holdDone = true,
        }
    end

    local function waitStealTime(ctx, sec)
        if not ctx then return end
        local elapsed = tick() - (ctx.ragdollFireTime or tick())
        if elapsed < sec then
            task.wait(sec - elapsed)
        end
    end

    local function finishHold(ctx)
        if not ctx then return false end
        local held = tick() - (ctx.holdBeganAt or tick())
        if held < MIN_HOLD then
            task.wait(MIN_HOLD - held)
        end
        task.wait(TRIGGER_DELAY)
        if ctx.cb then
            for _, fn in ipairs(ctx.cb.trigger) do
                task.spawn(fn)
            end
        end
        pcall(function()
            if ctx.prompt and ctx.prompt.Parent and fireproximityprompt then
                fireproximityprompt(ctx.prompt)
            end
        end)
        return true
    end

    local function quickGrab(prompt)
        if not prompt or not prompt.Parent then return end
        pcall(function()
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = math.huge
            prompt.HoldDuration = 0
        end)
        local cb = getCallbacks(prompt)
        if cb then
            for _, fn in ipairs(cb.hold) do task.spawn(fn) end
            task.wait(0.1)
            for _, fn in ipairs(cb.trigger) do task.spawn(fn) end
        end
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end

    local function isGiant()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        local scale = hum:FindFirstChild("BodyHeightScale") or hum:FindFirstChild("BodyDepthScale") or hum:FindFirstChild("BodyWidthScale")
        return scale and scale:IsA("NumberValue") and scale.Value >= 2.5
    end

    local function drinkPotion(prompt)
        if not HALF.potion or isGiant() then return end
        if _G.AutoBigPotion and _G.AutoBigPotion.forceActivate then
            pcall(function() _G.AutoBigPotion.forceActivate(prompt) end)
            return
        end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local bp = player:FindFirstChild("Backpack")
        if not char or not hum or not bp then return end
        if prompt then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local pp = prompt.Parent
            local pos = nil
            if pp then
                if pp:IsA("Attachment") then pos = pp.WorldPosition
                elseif pp:IsA("BasePart") then pos = pp.Position end
            end
            if hrp and pos and (hrp.Position - pos).Magnitude > 5 then return end
        end
        local potions = { "Giant Potion", "Giant", "Grow Potion", "Super Grow", "Potion" }
        local potion
        for _, n in ipairs(potions) do
            local t = bp:FindFirstChild(n) or char:FindFirstChild(n)
            if t and t:IsA("Tool") then potion = t break end
        end
        if not potion then return end
        pcall(function()
            if potion.Parent ~= char then hum:EquipTool(potion) end
            potion:Activate()
            task.delay(0.25, function()
                if potion and potion.Parent == char and bp and bp.Parent then
                    pcall(function() potion.Parent = bp end)
                end
            end)
        end)
    end

    -- Accessories: do NOT strip continuously (breaks Flying Carpet / Wings / Broom flight).
    -- Optional one-shot strip only when explicitly requested via _G._CyutsudStripAccessories.
    local function RemoveAccessories(character)
        if not character then return end
        if not _G._CyutsudStripAccessories then return end
        for _, accessory in ipairs(character:GetDescendants()) do
            if accessory:IsA("Accessory") then
                local n = string.lower(accessory.Name or "")
                -- never destroy flight-related accessories
                local isFlight = n:find("carpet") or n:find("wing") or n:find("broom") or n:find("sleigh")
                    or n:find("hover") or n:find("jetpack") or n:find("cloud") or n:find("waverider")
                if not isFlight then
                    pcall(function() accessory:Destroy() end)
                end
            end
        end
    end
    -- Disabled by default: continuous accessory deletion broke flying tools.

    local function startTrip(target)
        return {
            t0 = Workspace:GetServerTimeNow(),
            startedAt = tick(),
            target = target
        }
    end

    function HALF:SSDoTeleport()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        setFFlags()
        equipCarpet()

        local podium = getClosestPodium()
        if not podium then return end

        if self._fullExecute then
            local prePos
            if podium.isEnemyBase1 then
                prePos = Vector3.new(-352.39, -6.93, 6.49)
            else
                prePos = Vector3.new(-352.98, -6.93, 112.57)
            end
            pcall(function()
                walkTo(hrp, prePos, 180, 5, 8)
            end)
            self._fullExecute = false
        end

        local preferred = _G.coreSelectedCarpet
        local carpet = findCarpetTool(char, preferred)
            or findCarpetTool(player.Backpack, preferred)
        if carpet then
            pcall(function() hum:EquipTool(carpet) end)
        end

        local netCtx = startTrip({
            plotName = podium.plot.Name,
            pod = tonumber(podium.podiumName) or podium.podiumName,
        })
        HALF._semiStealCtx = netCtx

        local function doTp(HRP, pod)
            local isB1 = pod.isEnemyBase1
            local slot = HALF.selectedSlot
            local targetYaw = isB1 and math.rad(0) or math.rad(180)

            do
                local camera = Workspace.CurrentCamera
                if camera then
                    local currentPitch, _, currentRoll = camera.CFrame:ToOrientation()
                    camera.CameraType = Enum.CameraType.Scriptable
                    camera.CFrame = CFrame.new(camera.CFrame.Position) * CFrame.fromOrientation(currentPitch, targetYaw, currentRoll)
                    camera.CameraType = Enum.CameraType.Custom
                end
            end

            if pod and pod.prompt and pod.prompt.Parent then
                pcall(function()
                    pod.prompt.RequiresLineOfSight = false
                    pod.prompt.MaxActivationDistance = math.huge
                    pod.prompt.HoldDuration = 0
                end)
            end

            local ctx
            if pod and pod.prompt and pod.prompt.Parent then
                ctx = startHold(pod.prompt)
            end
            if ctx then waitStealTime(ctx, 0.6) end

            local greenPos, waypoints

            local function mirrorZ(z)
                return 120 - z
            end
            local function mirrorV3(v)
                return Vector3.new(v.X, v.Y, mirrorZ(v.Z))
            end
            local function mirrorList(list)
                local out = {}
                for i = 1, #list do
                    out[i] = mirrorV3(list[i])
                end
                return out
            end

            if slot == 2 then
                if isB1 then
                    greenPos = Vector3.new(-349, -7, 94)
                    waypoints = { Vector3.new(-349, -7, 94), Vector3.new(-324, -5, 100) }
                    targetYaw = math.rad(0)
                else
                    greenPos = Vector3.new(-349.43, -6.78, 37.47)
                    waypoints = { Vector3.new(-349, -7, 30), Vector3.new(-324, -5, 24) }
                    targetYaw = math.rad(180)
                end
            elseif slot == 3 then
                local wpB1 = { Vector3.new(-353, -7, 7), Vector3.new(-352, -7, 96), Vector3.new(-316, -5, 100) }
                local gpB1 = Vector3.new(-343, -6, 94)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 4 then
                local wpB1 = { Vector3.new(-353, -7, 7), Vector3.new(-353, -7, 96), Vector3.new(-312, -5, 97) }
                local gpB1 = Vector3.new(-332, -4, 96)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 5 then
                local wpB1 = { Vector3.new(-353, -7, 6), Vector3.new(-354, -7, 92), Vector3.new(-305, -5, 96) }
                local gpB1 = Vector3.new(-328, -5, 95)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 6 then
                local wpB1 = { Vector3.new(-353, -7, 6), Vector3.new(-346, -6, 115), Vector3.new(-305, -5, 128) }
                local gpB1 = Vector3.new(-316, -5, 114)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 7 then
                local wpB1 = { Vector3.new(-354, -7, 7), Vector3.new(-344, -6, 116), Vector3.new(-312, -5, 127) }
                local gpB1 = Vector3.new(-319, -5, 114)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 8 then
                local wpB1 = { Vector3.new(-353, -7, 7), Vector3.new(-353, -7, 96), Vector3.new(-318, -5, 126) }
                local gpB1 = Vector3.new(-339, -5, 116)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 9 then
                local wpB1 = { Vector3.new(-353, -7, 7), Vector3.new(-344, -6, 116), Vector3.new(-326, -5, 127) }
                local gpB1 = Vector3.new(-341, -5, 117)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 10 then
                local wpB1 = { Vector3.new(-353, -7, 6), Vector3.new(-345, -6, 116), Vector3.new(-335, -5, 128) }
                local gpB1 = Vector3.new(-346, -6, 116)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            elseif slot == 11 then
                local wpB1 = { Vector3.new(-353, -7, 6), Vector3.new(-346, -6, 115), Vector3.new(-332, -5, 100) }
                local gpB1 = Vector3.new(-332, -5, 100)
                if isB1 then
                    waypoints, greenPos, targetYaw = wpB1, gpB1, math.rad(0)
                else
                    waypoints, greenPos, targetYaw = mirrorList(wpB1), mirrorV3(gpB1), math.rad(180)
                end
            else
                if isB1 then
                    greenPos = Vector3.new(-347.12, -6.67, 81.64)
                    waypoints = { Vector3.new(-347, -6.9, 20), Vector3.new(-347, -6.9, 101), Vector3.new(-336.2, -5, 101) }
                    targetYaw = math.rad(0)
                else
                    greenPos = Vector3.new(-349.43, -6.78, 37.47)
                    waypoints = { Vector3.new(-347, -6.9, 101), Vector3.new(-347, -6.9, 20), Vector3.new(-336.2, -5.04, 20) }
                    targetYaw = math.rad(180)
                end
            end

            if waypoints then
                local realPos = pod and pod.position or nil
                if realPos and greenPos then
                    greenPos = Vector3.new(greenPos.X, realPos.Y + 2.5, greenPos.Z)
                    if #waypoints > 0 then
                        local last = waypoints[#waypoints]
                        waypoints[#waypoints] = Vector3.new(last.X, realPos.Y + 2, last.Z)
                    end
                elseif realPos and not greenPos then
                    greenPos = realPos + Vector3.new(0, 2.5, 0)
                end

                if realPos and HRP and HRP.Parent then
                    local dy = HRP.Position.Y - realPos.Y
                    if dy > 8 then
                        local dropPos = Vector3.new(realPos.X, realPos.Y + 3, realPos.Z)
                        pcall(function()
                            HRP.Velocity = Vector3.new()
                            HRP.CFrame = CFrame.new(dropPos)
                        end)
                        task.wait(0.05)
                    end
                end

                local startIdx = 1
                for i = #waypoints, 1, -1 do
                    if canDirectTp(HRP, waypoints[i]) then
                        startIdx = i
                        break
                    end
                end
                for i = startIdx, #waypoints do
                    walkTo(HRP, waypoints[i], 180)
                end

                task.wait(0.2)
                drinkPotion()
                equipCarpet()

                if ctx and greenPos then
                    waitStealTime(ctx, 1.4)
                    if HRP and HRP.Parent then
                        local finalPos = greenPos
                        if realPos and (HRP.Position.Y - realPos.Y) > 6 then
                            finalPos = realPos + Vector3.new(0, 2.5, 0)
                        end
                        HRP.CFrame = CFrame.new(finalPos)
                    end
                    finishHold(ctx)
                elseif greenPos and HRP and HRP.Parent then
                    local finalPos = greenPos
                    if realPos and (HRP.Position.Y - realPos.Y) > 6 then
                        finalPos = realPos + Vector3.new(0, 2.5, 0)
                    end
                    HRP.CFrame = CFrame.new(finalPos)
                end

                local timeout = (slot == 3 or slot == 4 or slot == 5 or slot == 6 or slot == 7 or slot == 8 or slot == 9 or slot == 10) and 1.5 or 1
                local startT = tick()
                while player:GetAttribute("Stealing") == nil do
                    if tick() - startT >= timeout then break end
                    task.wait(0.1)
                end
            end
        end

        task.spawn(function()
            pcall(function()
                doTp(hrp, podium)
                HALF._semiStealCtx = nil
                _G._CyutsudSemiTPActive = false
            end)
            HALF._semiStealCtx = nil
            _G._CyutsudSemiTPActive = false
        end)
    end

    function HALF:activate()
        task.spawn(function()
            instaReset()
        end)
    end

    function HALF:execute(fullMode)
        if self.debounce then return end
        self.debounce = true
        self._fullExecute = fullMode and true or false
        task.spawn(function()
            if self.autoActivate then
                pcall(function() self:activate() end)
                task.wait(0.12)
            end

            local resumeAuto = Steal and Steal.AutoStealEnabled
            if resumeAuto then
                Steal.AutoStealEnabled = false
                isStealing = false
            end
            _G._CyutsudSemiTPActive = true

            pcall(function()
                if Booster and Booster.suspend then Booster.suspend("semitp") end
            end)
            pcall(function()
                if _G.GiantPotionSpeed and _G.GiantPotionSpeed.pause then _G.GiantPotionSpeed.pause() end
            end)

            local doFull = self.autoAPSpam or (_G.coreConfig and _G.coreConfig:get("isv2_autoAPSpam", false))
            local doSemi = self.autoSemiAPSpam or (_G.coreConfig and _G.coreConfig:get("isv2_autoSemiAPSpam", false))
            if doFull or doSemi then
                local mode = doFull and "full" or "semi"
                task.delay(1, function()
                    pcall(function()
                        local target = nil
                        local best = 1e9
                        local myChar = player.Character
                        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                            if plr ~= player and plr.Character then
                                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                if hrp and myHRP then
                                    local d = (hrp.Position - myHRP.Position).Magnitude
                                    if d < best then best = d; target = plr end
                                elseif not myHRP then
                                    target = plr
                                    break
                                end
                            end
                        end
                        if target and executeSpamOnTarget then
                            executeSpamOnTarget(target, mode)
                        end
                    end)
                end)
            end
            pcall(function()
                setFFlags()
                if self.grappleBoost then
                    -- Grapple Boost: one grapple hit, then TP
                    self:grappleThenTP()
                else
                    self:SSDoTeleport()
                end
            end)

            local t0 = tick()
            while (self._semiStealCtx or _G._CyutsudSemiTPActive) and (tick() - t0) < 18 do
                if not self._semiStealCtx and (tick() - t0) > 1.5 then
                    break
                end
                task.wait(0.1)
            end
            self._semiStealCtx = nil
            _G._CyutsudSemiTPActive = false

            if resumeAuto and Steal then
                Steal.AutoStealEnabled = true
                isStealing = false
                pcall(function()
                    if not autoConn then
                        startAutoSteal()
                    end
                end)
            end

            local wantAutoWalk = self.autoWalk
            pcall(function()
                if not wantAutoWalk and Config and Config.get then
                    wantAutoWalk = Config.get("isv2_autoWalk", false) and true or false
                end
                if not wantAutoWalk and _G.coreConfig and _G.coreConfig.get then
                    wantAutoWalk = _G.coreConfig:get("isv2_autoWalk", false) and true or false
                end
            end)
            if wantAutoWalk then
                task.spawn(function()
                    task.wait(0.35)
                    pcall(function()
                        HALF:doAutoWalk()
                    end)
                end)
            end

            pcall(function()
                if Booster and Booster.unsuspend then Booster.unsuspend("semitp") end
            end)
            pcall(function()
                if _G.GiantPotionSpeed and _G.GiantPotionSpeed.resume then _G.GiantPotionSpeed.resume() end
            end)
            task.wait(0.15)
            self.debounce = false
        end)
    end

    function HALF:setPotion(on)
        self.potion = on and true or false
        pcall(function()
            if _G.coreConfig then
                _G.coreConfig:set("isv2_autoPotion", self.potion)
                if _G.coreConfig.flush then pcall(function() _G.coreConfig:flush() end) end
            end
            if Config then
                Config.set("isv2_autoPotion", self.potion)
            end
        end)
    end

    function HALF:setAutoWalk(on)
        self.autoWalk = on and true or false
        pcall(function()
            if _G.coreConfig then
                _G.coreConfig:set("isv2_autoWalk", self.autoWalk)
                if _G.coreConfig.flush then pcall(function() _G.coreConfig:flush() end) end
            end
            if Config then
                Config.set("isv2_autoWalk", self.autoWalk)
            end
        end)
    end

    function HALF:setAutoActivate(on)
        self.autoActivate = on and true or false
        pcall(function()
            if _G.coreConfig then
                _G.coreConfig:set("isv2_autoActivate", self.autoActivate)
                if _G.coreConfig.flush then pcall(function() _G.coreConfig:flush() end) end
            end
            if Config then
                Config.set("isv2_autoActivate", self.autoActivate)
            end
        end)
        if self.autoActivate then
            pcall(function() self:activate() end)
        end
    end

    function HALF:_stopGrappleBoost()
        if self._grappleBoostConn then
            pcall(function()
                if typeof(self._grappleBoostConn) == "RBXScriptConnection" then
                    self._grappleBoostConn:Disconnect()
                elseif type(self._grappleBoostConn) == "thread" then
                    task.cancel(self._grappleBoostConn)
                end
            end)
            self._grappleBoostConn = nil
        end
        self._grappleRemote = nil
        self._grappleJobId = nil
    end

    function HALF:_resolveGrappleRemote()
        local RS = game:GetService("ReplicatedStorage")
        if self._grappleRemote and self._grappleJobId == game.JobId and self._grappleRemote.Parent then
            return self._grappleRemote
        end
        self._grappleRemote, self._grappleJobId = nil, game.JobId

        local pkgs = RS:FindFirstChild("Packages")
        local Net = pkgs and pkgs:FindFirstChild("Net")
        if not Net then return nil end

        local slots, byLeaf = {}, {}
        for i, c in ipairs(Net:GetChildren()) do
            local p, rest = string.match(c.Name, "^(%a+)/(.+)$")
            if p and #rest == 64 and string.match(rest, "^%x+$") then
                slots[i] = c
                byLeaf[rest] = byLeaf[rest] or {}
                table.insert(byLeaf[rest], { slot = i, class = c.ClassName })
            end
        end

        local anchor, dual = nil, 0
        for _, list in pairs(byLeaf) do
            if #list > 1 then
                dual = dual + 1
                for _, e in ipairs(list) do
                    if e.class == "RemoteEvent" then anchor = e.slot end
                end
            end
        end
        if dual ~= 1 or not anchor then return nil end

        local t = slots[anchor - 1]
        if t and t.ClassName == "RemoteEvent" and t.Parent == Net then
            self._grappleRemote = t
            return t
        end
        return nil
    end

    function HALF:_getGrappleTool()
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        local TOOL = "Grapple Hook"
        local ch = LP.Character
        local t = ch and ch:FindFirstChild(TOOL)
        if t then return t, true end
        local bp = LP:FindFirstChild("Backpack")
        t = bp and bp:FindFirstChild(TOOL)
        return t, false
    end

    function HALF:_fireGrapple(pos)
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        local r = self:_resolveGrappleRemote()
        if not r then return false, "unresolved" end

        local t, equipped = self:_getGrappleTool()
        if not t then return false, "no Grapple Hook" end
        if not equipped then
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if not hum then return false, "no humanoid" end
            pcall(function() hum:EquipTool(t) end)
            task.wait(0.15)
        end

        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return false, "no hrp" end

        local cam = workspace.CurrentCamera
        pos = pos or (hrp.Position + (cam and cam.CFrame.LookVector or hrp.CFrame.LookVector) * 100)
        local a = math.clamp((pos - hrp.Position).Magnitude / 120, 0, 2)
        local ok, err = pcall(function() r:FireServer(a, pos) end)
        if not ok then return false, tostring(err) end
        return true, "fired"
    end

    function HALF:_startGrappleBoost()
        self:_stopGrappleBoost()
        -- Just resolve remote; no spam. Fire happens once before TP.
        self:_resolveGrappleRemote()
        _G._CyutsudFireGrapple = function(pos)
            return HALF:_fireGrapple(pos)
        end
        pcall(function()
            if showToast then showToast("Grapple Boost ON", true) end
        end)
    end

    -- One grapple hit, then Instant Steal TP
    function HALF:grappleThenTP()
        local ok, msg = self:_fireGrapple(nil)
        -- short wait so grapple registers before teleport
        task.wait(0.12)
        pcall(function()
            setFFlags()
            self:SSDoTeleport()
        end)
        return ok, msg
    end

    function HALF:setGrappleBoost(on)
        self.grappleBoost = on and true or false
        pcall(function()
            if _G.coreConfig then
                _G.coreConfig:set("isv2_grappleBoost", self.grappleBoost)
                if _G.coreConfig.flush then pcall(function() _G.coreConfig:flush() end) end
            end
            if Config then
                Config.set("isv2_grappleBoost", self.grappleBoost)
            end
        end)
        if self.grappleBoost then
            self:_startGrappleBoost()
        else
            self:_stopGrappleBoost()
            pcall(function()
                if showToast then showToast("Grapple Boost OFF", false) end
            end)
        end
    end

    -- Restore grapple boost if it was saved ON
    task.defer(function()
        pcall(function()
            if HALF.grappleBoost then
                HALF:setGrappleBoost(true)
            end
        end)
    end)

    function HALF:doAutoWalk()
        if self._autoWalkRunning then return end
        self._autoWalkRunning = true
        self._autoWalkCancel = false

        local waitT0 = tick()
        while tick() - waitT0 < 4 do
            if self._autoWalkCancel then
                self._autoWalkRunning = false
                return
            end
            local stealing = false
            pcall(function()
                stealing = player:GetAttribute("Stealing") ~= nil
            end)
            if not stealing and not self._semiStealCtx and not _G._CyutsudSemiTPActive then
                break
            end
            task.wait(0.12)
        end
        task.wait(0.25)

        local char = player.Character
        if not char then
            self._autoWalkRunning = false
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then
            self._autoWalkRunning = false
            return
        end

        pcall(function()
            if equipCarpet then equipCarpet() end
        end)

        local finalTarget = self.autoWalkTarget or Vector3.new(-345.75, -5.89, 26.54)
        local midTarget = Vector3.new(-344.87, -6.97, 94.78)
        pcall(function()
            if type(getCurrentBase) == "function" then
                local base = getCurrentBase()
                if base then
                    if base.walkPos then finalTarget = base.walkPos end
                    if base.final then midTarget = base.final end
                end
            end
        end)

        local startZones = {
            Vector3.new(-340.49, -4.58, 91.91),
            Vector3.new(-341.36, -4.64, 134.97),
            Vector3.new(-294.05, -3.99, 135.24),
        }
        local nearStart = false
        for _, z in ipairs(startZones) do
            if (hrp.Position - z).Magnitude < 14 then
                nearStart = true
                break
            end
        end
        if nearStart then
            local dMid = (hrp.Position - midTarget).Magnitude
            local dFin = (hrp.Position - finalTarget).Magnitude
            if dFin <= dMid then nearStart = false end
        end

        local UIS = game:GetService("UserInputService")
        local connDied, connChar, connInput
        local function cancel()
            if self._autoWalkCancel then return end
            self._autoWalkCancel = true
            pcall(function()
                local c = player.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h then
                    h:Move(Vector3.zero)
                end
            end)
        end
        connDied = hum.Died:Connect(cancel)
        connChar = player.CharacterAdded:Connect(cancel)
        local MOVE_KEYS = {
            [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
            [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
            [Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true,
            [Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true,
        }
        connInput = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and MOVE_KEYS[input.KeyCode] then
                cancel()
            end
        end)

        pcall(function()
            char = player.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if nearStart then
                if type(walkTo) == "function" then
                    walkTo(hrp, midTarget, 160, 5, 10)
                    if self._autoWalkCancel then return end
                    char = player.Character
                    hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then walkTo(hrp, finalTarget, 160, 5, 12) end
                end
            else
                if type(walkTo) == "function" then
                    walkTo(hrp, finalTarget, 160, 5, 14)
                end
            end
        end)

        pcall(function() if connDied then connDied:Disconnect() end end)
        pcall(function() if connChar then connChar:Disconnect() end end)
        pcall(function() if connInput then connInput:Disconnect() end end)
        self._autoWalkRunning = false
        self._autoWalkCancel = false
    end

    do
        local DISALLOW_IMG = "rbxassetid://110783679426495"
        local COOLDOWN = 4.5

        local function plotIsDisallowed(plot)
            if not plot then return true end
            local friendPanel = plot:FindFirstChild("FriendPanel") or plot:FindFirstChild("FriendPanel", true)
            if not friendPanel then return true end
            local main = friendPanel:FindFirstChild("Main")
            if not main then return true end
            local sg = main:FindFirstChild("SurfaceGui")
            if not sg then return true end
            local img = sg:FindFirstChild("ImageLabel")
            if not img then
                for _, d in ipairs(sg:GetDescendants()) do
                    if d:IsA("ImageLabel") then img = d break end
                end
            end
            if not img then return true end
            return img.Image == DISALLOW_IMG
        end

        local function isOtherPlot(plot)
            if not plot or not plot:IsA("Model") then return false end
            if type(isMyPlotByName) == "function" then
                return not isMyPlotByName(plot.Name)
            end

            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then
                    return false
                end
            end
            return true
        end

        local function anyEnemyBaseAllowed()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return false, nil end
            for _, plot in ipairs(plots:GetChildren()) do
                if isOtherPlot(plot) then
                    if not plotIsDisallowed(plot) then
                        return true, plot
                    end
                end
            end
            return false, nil
        end

        function HALF:setAutoTpOnAllow(on)
            self.autoTpOnAllow = on and true or false
            if self._autoTpOnAllowConn then
                pcall(function() task.cancel(self._autoTpOnAllowConn) end)
                self._autoTpOnAllowConn = nil
            end
            if not self.autoTpOnAllow then return end
            self._autoTpOnAllowConn = task.spawn(function()
                local wasAllowed = {}
                while self.autoTpOnAllow do
                    task.wait(0.35)
                    if not self.autoTpOnAllow then break end
                    if self.debounce or _G._CyutsudSemiTPActive then

                    else
                        local ok, plot = anyEnemyBaseAllowed()
                        if ok and plot then
                            local key = plot.Name
                            local now = tick()

                            local rising = not wasAllowed[key]
                            if rising or (now - (self._lastAllowFire or 0) > COOLDOWN * 3) then
                                if now - (self._lastAllowFire or 0) >= COOLDOWN then
                                    self._lastAllowFire = now
                                    wasAllowed[key] = true
                                    if _G.coreNotify then
                                        _G.coreNotify.show("Auto TP on Allow", "Allow détecté → Full Execute")
                                    end
                                    pcall(function()
                                        HALF:execute(true)
                                    end)
                                end
                            end
                            wasAllowed[key] = true
                        else

                            wasAllowed = {}
                        end
                    end
                end
            end)
        end

        local function textHasBrokeInto(msg)
            if not msg or msg == "" then return false end
            local low = string.lower(tostring(msg))
            if low:find("successfully broke into", 1, true) then return true end
            if low:find("you successfully broke", 1, true) then return true end
            if low:find("broke into", 1, true) and low:find("success", 1, true) then return true end
            return false
        end

        local function fireSemiTpOnBrokeInto()
            if not HALF.autoTpOnUnlock then return end
            if HALF.debounce or _G._CyutsudSemiTPActive then return end
            local now = tick()
            if now - (HALF._lastUnlockFire or 0) < (COOLDOWN or 4.5) then return end
            HALF._lastUnlockFire = now
            if _G.coreNotify then
                _G.coreNotify.show(
                    "Auto Tp on Unlock",
                    "Broke into → Semi TP slot " .. tostring(HALF.selectedSlot or 1)
                )
            end
            pcall(function()
                HALF:execute(false)
            end)
        end

        function HALF:setAutoTpOnUnlock(on)
            self.autoTpOnUnlock = on and true or false

            if self._autoTpOnUnlockConn then
                pcall(function()
                    if typeof(self._autoTpOnUnlockConn) == "RBXScriptConnection" then
                        self._autoTpOnUnlockConn:Disconnect()
                    else
                        task.cancel(self._autoTpOnUnlockConn)
                    end
                end)
                self._autoTpOnUnlockConn = nil
            end
            if type(self._autoTpOnUnlockConns) == "table" then
                for _, c in ipairs(self._autoTpOnUnlockConns) do
                    pcall(function()
                        if typeof(c) == "RBXScriptConnection" then
                            c:Disconnect()
                        elseif type(c) == "thread" then
                            task.cancel(c)
                        end
                    end)
                end
            end
            self._autoTpOnUnlockConns = {}

            if not self.autoTpOnUnlock then return end

            local conns = self._autoTpOnUnlockConns

            pcall(function()
                local TCS = game:GetService("TextChatService")
                if TCS then
                    local c = TCS.MessageReceived:Connect(function(textMsg)
                        if not HALF.autoTpOnUnlock then return end
                        local body = ""
                        pcall(function()
                            body = textMsg.Text or textMsg.PrefixText or ""
                        end)
                        if textHasBrokeInto(body) then
                            fireSemiTpOnBrokeInto()
                        end
                    end)
                    table.insert(conns, c)
                end
            end)

            pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                local chatEvents = RS:FindFirstChild("DefaultChatSystemChatEvents")
                if chatEvents then
                    local onFilter = chatEvents:FindFirstChild("OnMessageDoneFiltering")
                    if onFilter and onFilter:IsA("RemoteEvent") then
                        local c = onFilter.OnClientEvent:Connect(function(data)
                            if not HALF.autoTpOnUnlock then return end
                            local msg = ""
                            if type(data) == "table" then
                                msg = tostring(data.Message or data.message or data.Text or "")
                            else
                                msg = tostring(data or "")
                            end
                            if textHasBrokeInto(msg) then
                                fireSemiTpOnBrokeInto()
                            end
                        end)
                        table.insert(conns, c)
                    end
                    local onNew = chatEvents:FindFirstChild("OnNewMessage")
                    if onNew and onNew:IsA("RemoteEvent") then
                        local c2 = onNew.OnClientEvent:Connect(function(data)
                            if not HALF.autoTpOnUnlock then return end
                            local msg = ""
                            if type(data) == "table" then
                                msg = tostring(data.Message or data.message or data.Text or "")
                            else
                                msg = tostring(data or "")
                            end
                            if textHasBrokeInto(msg) then
                                fireSemiTpOnBrokeInto()
                            end
                        end)
                        table.insert(conns, c2)
                    end
                end
            end)

            local seen = {}
            local loop = task.spawn(function()
                while HALF.autoTpOnUnlock do
                    task.wait(0.25)
                    if not HALF.autoTpOnUnlock then break end
                    if HALF.debounce or _G._CyutsudSemiTPActive then
                    else
                        pcall(function()
                            local pg = player:FindFirstChild("PlayerGui")
                            if not pg then return end
                            for _, d in ipairs(pg:GetDescendants()) do
                                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                                    local t = d.Text
                                    if t and #t > 10 and textHasBrokeInto(t) then
                                        local key = t .. "|" .. tostring(d:GetFullName())
                                        if not seen[key] then
                                            seen[key] = true
                                            fireSemiTpOnBrokeInto()
                                        end
                                    end
                                end
                            end
                            local cg = game:GetService("CoreGui")
                            for _, d in ipairs(cg:GetDescendants()) do
                                if d:IsA("TextLabel") then
                                    local t = d.Text
                                    if t and #t > 10 and textHasBrokeInto(t) then
                                        local key = "cg|" .. t
                                        if not seen[key] then
                                            seen[key] = true
                                            fireSemiTpOnBrokeInto()
                                        end
                                    end
                                end
                            end
                        end)
                        if tick() % 30 < 0.3 then
                            seen = {}
                        end
                    end
                end
            end)
            table.insert(conns, loop)
            self._autoTpOnUnlockConn = loop
        end

        task.defer(function()
            task.wait(1.0)
            if HALF.autoTpOnAllow then
                HALF:setAutoTpOnAllow(true)
            end
            if HALF.autoTpOnUnlock then
                HALF:setAutoTpOnUnlock(true)
            end
        end)
    end

    _G.HALF = HALF

    -- ============================================================
    -- Instant Steal V2 Panel — follows main CyutsudHub theme (T / Theme)
    -- Uses existing HALF logic from this hub
    -- ============================================================
    _G.InstantStealV2 = (function()
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local LP = Players.LocalPlayer
        local state = { open = false }
        local gui, mainFrame

        local function destroy()
            if gui then pcall(function() gui:Destroy() end) end
            gui, mainFrame = nil, nil
            local function purge(parent)
                if not parent then return end
                local old = parent:FindFirstChild("PanelGui_Instant Steal V2")
                if old then pcall(function() old:Destroy() end) end
            end
            pcall(function() purge(LP:FindFirstChild("PlayerGui")) end)
            pcall(function()
                if type(gethui) == "function" then purge(gethui()) end
            end)
            pcall(function() purge(game:GetService("CoreGui")) end)
        end

        local function makeToggleRow(parent, order, title, getOn, setOn)
            local cardBg = (T and T.Card) or Color3.fromRGB(24, 16, 38)
            local textCol = (T and T.Text) or Color3.fromRGB(245, 240, 255)
            local softCol = (T and T.Soft) or Color3.fromRGB(28, 18, 42)
            local muteCol = (T and T.TextMute) or Color3.fromRGB(110, 95, 140)
            local acc = (Theme and Theme.c1) or (T and T.Primary) or Color3.fromRGB(168, 85, 247)
            local white = (T and T.White) or Color3.fromRGB(255, 255, 255)

            local card = Instance.new("Frame")
            card.Name = "ToggleRow_" .. tostring(title):gsub("%W", "_")
            card.Size = UDim2.new(1, 0, 0, 34)
            card.BackgroundColor3 = cardBg
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.Parent = parent
            pcall(function() trackBgFrame(card, "Card") end)
            Corner(card, 12)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Size = UDim2.new(1, -58, 1, 0)
            nameLbl.Position = UDim2.new(0, 12, 0, 0)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 12
            nameLbl.TextColor3 = textCol
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextYAlignment = Enum.TextYAlignment.Center
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Text = tostring(title)
            nameLbl.Parent = card

            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 38, 0, 20)
            track.Position = UDim2.new(1, -48, 0.5, -10)
            track.BackgroundColor3 = softCol
            track.BorderSizePixel = 0
            track.Parent = card
            pcall(function() trackBgFrame(track, "Soft") end)
            Corner(track, 10)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(0, 2, 0.5, -8)
            knob.BackgroundColor3 = muteCol
            knob.BorderSizePixel = 0
            knob.Parent = track
            Corner(knob, 8)

            local on = false
            pcall(function() on = getOn() and true or false end)

            local function paint(anim)
                local col = on and acc or softCol
                local pos = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local kcol = on and white or muteCol
                if anim then
                    Tween(track, F, { BackgroundColor3 = col })
                    Tween(knob, F, { Position = pos, BackgroundColor3 = kcol })
                else
                    track.BackgroundColor3 = col
                    knob.Position = pos
                    knob.BackgroundColor3 = kcol
                end
            end
            paint(false)

            local function doToggle()
                on = not on
                paint(true)
                pcall(function() setOn(on) end)
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = card
            btn.MouseButton1Click:Connect(doToggle)

            -- Clic droit = keybind (comme le hub principal)
            pcall(function()
                local bindFn = attachKeybind or _G.__CyutsudBridge and _G.__CyutsudBridge.attachKeybind
                if type(bindFn) == "function" then
                    bindFn(btn, nameLbl, tostring(title), doToggle)
                end
            end)

            return card
        end

        local function makeActionBtn(parent, order, text, cb)
            local cardBg = (T and T.Card) or Color3.fromRGB(24, 16, 38)
            local hoverBg = (T and T.CardHover) or Color3.fromRGB(34, 22, 52)
            local textCol = (T and T.Text) or Color3.fromRGB(245, 240, 255)

            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 36)
            card.BackgroundColor3 = cardBg
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.Parent = parent
            pcall(function() trackBgFrame(card, "Card") end)
            Corner(card, 12)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -16, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = textCol
            lbl.TextSize = 13
            lbl.Font = Enum.Font.GothamBold
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.Parent = card

            local function press()
                if cb then pcall(cb) end
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = card
            btn.MouseButton1Click:Connect(press)
            btn.MouseEnter:Connect(function()
                Tween(card, F, { BackgroundColor3 = hoverBg })
            end)
            btn.MouseLeave:Connect(function()
                Tween(card, F, { BackgroundColor3 = (T and T.Card) or cardBg })
            end)

            -- Clic droit = keybind (comme le hub principal)
            pcall(function()
                local bindFn = attachKeybind or _G.__CyutsudBridge and _G.__CyutsudBridge.attachKeybind
                if type(bindFn) == "function" then
                    bindFn(btn, lbl, tostring(text), press)
                end
            end)

            return card
        end

        local function build()
            destroy()
            local parent = nil
            pcall(function() if type(gethui) == "function" then parent = gethui() end end)
            if not parent then
                pcall(function()
                    local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                    parent = _cr(game:GetService("CoreGui"))
                end)
            end
            if not parent then
                parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
            end

            gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_Instant Steal V2"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999996
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            pcall(function()
                if type(protect_gui) == "function" then protect_gui(gui)
                elseif syn and syn.protect_gui then syn.protect_gui(gui) end
            end)
            gui.Parent = parent

            mainFrame = Instance.new("Frame")
            mainFrame.Name = "Frame"
            mainFrame.Size = UDim2.new(0, 240, 0, 280)
            mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            mainFrame.Position = UDim2.new(0.5, 0, 0.42, 0)
            mainFrame.BackgroundColor3 = (T and T.Bg) or Color3.fromRGB(14, 10, 22)
            mainFrame.BackgroundTransparency = 0.02
            mainFrame.BorderSizePixel = 0
            mainFrame.Active = true
            mainFrame.Parent = gui
            pcall(function() trackBgFrame(mainFrame, "Bg") end)
            Corner(mainFrame, 14)
            pcall(function() GradStroke(mainFrame, 1.6, 0.25, 90) end)
            pcall(function()
                if type(_G._CyutsudStyleLikeHub) == "function" then
                    _G._CyutsudStyleLikeHub(mainFrame, nil)
                end
            end)

            pcall(function()
                local p = Config and Config.get("isv2_panel_pos", nil)
                if type(p) == "table" and #p >= 4 then
                    mainFrame.AnchorPoint = Vector2.new(0, 0)
                    mainFrame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                end
            end)

            -- Title bar (same style as hub panels)
            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 36)
            titleBar.BackgroundColor3 = (T and T.BgDeep) or Color3.fromRGB(8, 6, 14)
            titleBar.BackgroundTransparency = 0.05
            titleBar.BorderSizePixel = 0
            titleBar.Active = true
            titleBar.Parent = mainFrame
            pcall(function() trackBgFrame(titleBar, "BgDeep") end)
            Corner(titleBar, 12)
            local titleFix = Instance.new("Frame")
            titleFix.Size = UDim2.new(1, 0, 0, 10)
            titleFix.Position = UDim2.new(0, 0, 1, -10)
            titleFix.BackgroundColor3 = (T and T.BgDeep) or Color3.fromRGB(8, 6, 14)
            titleFix.BorderSizePixel = 0
            titleFix.Parent = titleBar
            pcall(function() trackBgFrame(titleFix, "BgDeep") end)

            -- accent line under title (hub style)
            local accent = Instance.new("Frame")
            accent.Name = "HubAccent"
            accent.Size = UDim2.new(1, 0, 0, 2)
            accent.Position = UDim2.new(0, 0, 1, -2)
            accent.BorderSizePixel = 0
            accent.BackgroundColor3 = (Theme and Theme.c1) or Color3.fromRGB(168, 85, 247)
            accent.ZIndex = 5
            accent.Parent = titleBar
            pcall(function() trackSolid(accent, 1) end)

            local title = Lbl(titleBar, "Instant Steal V2", 12, (T and T.Text) or Color3.fromRGB(245, 240, 255), Enum.Font.GothamBold)
            title.Size = UDim2.new(1, -70, 1, 0)
            title.Position = UDim2.new(0, 12, 0, 0)
            title.TextYAlignment = Enum.TextYAlignment.Center

            local minBtn = Instance.new("TextButton")
            minBtn.Name = "MinBtn"
            minBtn.Size = UDim2.new(0, 22, 0, 22)
            minBtn.Position = UDim2.new(1, -28, 0.5, -11)
            minBtn.BackgroundColor3 = (T and T.BgDeep) or Color3.fromRGB(8, 6, 14)
            minBtn.Text = "–"
            minBtn.Font = Enum.Font.GothamBold
            minBtn.TextSize = 14
            minBtn.TextColor3 = (T and T.TextDim) or Color3.fromRGB(170, 150, 200)
            minBtn.AutoButtonColor = false
            minBtn.Active = true
            minBtn.ZIndex = 30
            minBtn.Parent = titleBar
            Corner(minBtn, 12)

            local settingsBtn = Instance.new("TextButton")
            settingsBtn.Name = "SettingsBtn"
            settingsBtn.Size = UDim2.new(0, 22, 0, 22)
            settingsBtn.Position = UDim2.new(1, -54, 0.5, -11)
            settingsBtn.BackgroundColor3 = (T and T.BgDeep) or Color3.fromRGB(8, 6, 14)
            settingsBtn.Text = "⚙"
            settingsBtn.Font = Enum.Font.GothamBold
            settingsBtn.TextSize = 12
            settingsBtn.TextColor3 = (T and T.Text) or Color3.fromRGB(245, 240, 255)
            settingsBtn.AutoButtonColor = false
            settingsBtn.Parent = titleBar
            Corner(settingsBtn, 12)
            settingsBtn.MouseEnter:Connect(function()
                Tween(settingsBtn, F, { BackgroundColor3 = (T and T.CardHover) or Color3.fromRGB(34, 22, 52) })
            end)
            settingsBtn.MouseLeave:Connect(function()
                Tween(settingsBtn, F, { BackgroundColor3 = (T and T.BgDeep) or Color3.fromRGB(8, 6, 14) })
            end)

            -- Content
            local content = Instance.new("Frame")
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 1, -42)
            content.Position = UDim2.new(0, 0, 0, 40)
            content.BackgroundTransparency = 1
            content.Parent = mainFrame
            local cPad = Instance.new("UIPadding")
            cPad.PaddingTop = UDim.new(0, 6)
            cPad.PaddingLeft = UDim.new(0, 10)
            cPad.PaddingRight = UDim.new(0, 10)
            cPad.PaddingBottom = UDim.new(0, 8)
            cPad.Parent = content
            local cList = Instance.new("UIListLayout")
            cList.Padding = UDim.new(0, 6)
            cList.SortOrder = Enum.SortOrder.LayoutOrder
            cList.Parent = content

            -- Settings view
            local settingsView = Instance.new("Frame")
            settingsView.Name = "SettingsView"
            settingsView.Size = UDim2.new(1, 0, 1, -42)
            settingsView.Position = UDim2.new(0, 0, 0, 40)
            settingsView.BackgroundTransparency = 1
            settingsView.Visible = false
            settingsView.Parent = mainFrame
            local sPad = Instance.new("UIPadding")
            sPad.PaddingTop = UDim.new(0, 6)
            sPad.PaddingLeft = UDim.new(0, 10)
            sPad.PaddingRight = UDim.new(0, 10)
            sPad.Parent = settingsView
            local sList = Instance.new("UIListLayout")
            sList.Padding = UDim.new(0, 6)
            sList.SortOrder = Enum.SortOrder.LayoutOrder
            sList.Parent = settingsView

            local setHeader = Instance.new("Frame")
            setHeader.Size = UDim2.new(1, 0, 0, 28)
            setHeader.BackgroundTransparency = 1
            setHeader.LayoutOrder = 1
            setHeader.Parent = settingsView
            local backBtn = Instance.new("TextButton")
            backBtn.Size = UDim2.new(0, 28, 0, 24)
            backBtn.Position = UDim2.new(0, 0, 0.5, -12)
            backBtn.BackgroundColor3 = (T and T.Card) or Color3.fromRGB(24, 16, 38)
            backBtn.Text = "←"
            backBtn.TextColor3 = (T and T.Text) or Color3.fromRGB(245, 240, 255)
            backBtn.TextSize = 16
            backBtn.Font = Enum.Font.GothamBold
            backBtn.AutoButtonColor = false
            backBtn.Parent = setHeader
            Corner(backBtn, 10)
            local setTitle = Instance.new("TextLabel")
            setTitle.Size = UDim2.new(1, -36, 1, 0)
            setTitle.Position = UDim2.new(0, 34, 0, 0)
            setTitle.BackgroundTransparency = 1
            setTitle.Text = "Settings"
            setTitle.TextColor3 = (T and T.Text) or Color3.fromRGB(245, 240, 255)
            setTitle.TextSize = 13
            setTitle.Font = Enum.Font.GothamBold
            setTitle.TextXAlignment = Enum.TextXAlignment.Left
            setTitle.Parent = setHeader

            local H = _G.HALF

            makeToggleRow(settingsView, 10, "Auto Potion", function()
                return H and H.potion
            end, function(on)
                if H and H.setPotion then H:setPotion(on) end
                if Config then Config.set("isv2_autoPotion", on) end
            end)

            makeToggleRow(settingsView, 20, "Auto Full AP Spam", function()
                return H and H.autoAPSpam
            end, function(on)
                if H then
                    H.autoAPSpam = on
                    if on then H.autoSemiAPSpam = false end
                end
                if Config then
                    Config.set("isv2_autoAPSpam", on)
                    if on then Config.set("isv2_autoSemiAPSpam", false) end
                end
            end)

            makeToggleRow(settingsView, 21, "Auto Semi AP Spam", function()
                return H and H.autoSemiAPSpam
            end, function(on)
                if H then
                    H.autoSemiAPSpam = on
                    if on then H.autoAPSpam = false end
                end
                if Config then
                    Config.set("isv2_autoSemiAPSpam", on)
                    if on then Config.set("isv2_autoAPSpam", false) end
                end
            end)

            makeToggleRow(settingsView, 23, "Auto TP on Allow", function()
                return H and H.autoTpOnAllow
            end, function(on)
                if H and H.setAutoTpOnAllow then H:setAutoTpOnAllow(on)
                elseif H then H.autoTpOnAllow = on end
                if Config then Config.set("isv2_autoTpOnAllow", on) end
            end)

            makeToggleRow(settingsView, 24, "Auto TP on Unlock", function()
                return H and H.autoTpOnUnlock
            end, function(on)
                if H and H.setAutoTpOnUnlock then H:setAutoTpOnUnlock(on)
                elseif H then H.autoTpOnUnlock = on end
                if Config then Config.set("isv2_autoTpOnUnlock", on) end
            end)

            if H and H.setAutoWalk then
                makeToggleRow(settingsView, 30, "Auto Walk", function()
                    return H and H.autoWalk
                end, function(on)
                    if H and H.setAutoWalk then H:setAutoWalk(on)
                    elseif H then H.autoWalk = on end
                    if Config then Config.set("isv2_autoWalk", on) end
                end)
            end

            makeToggleRow(settingsView, 40, "Auto Activate", function()
                return H and H.autoActivate
            end, function(on)
                if H then
                    H.autoActivate = on
                    if H.setAutoActivate then H:setAutoActivate(on) end
                    if on and H.activate then H:activate() end
                end
                if Config then Config.set("isv2_autoActivate", on) end
            end)

            makeToggleRow(settingsView, 41, "Grapple Boost", function()
                return H and H.grappleBoost
            end, function(on)
                if H and H.setGrappleBoost then
                    H:setGrappleBoost(on)
                elseif H then
                    H.grappleBoost = on and true or false
                end
                if Config then Config.set("isv2_grappleBoost", on and true or false) end
            end)

            -- Slot selector
            local slotRow = Instance.new("Frame")
            slotRow.Size = UDim2.new(1, 0, 0, 48)
            slotRow.BackgroundColor3 = (T and T.Card) or Color3.fromRGB(24, 16, 38)
            slotRow.BorderSizePixel = 0
            slotRow.LayoutOrder = 1
            slotRow.Parent = content
            pcall(function() trackBgFrame(slotRow, "Card") end)
            Corner(slotRow, 12)

            local slotTitle = Instance.new("TextLabel")
            slotTitle.Size = UDim2.new(1, 0, 0, 14)
            slotTitle.Position = UDim2.new(0, 0, 0, 4)
            slotTitle.BackgroundTransparency = 1
            slotTitle.Text = "Slot"
            slotTitle.TextColor3 = (T and T.TextDim) or Color3.fromRGB(170, 150, 200)
            slotTitle.TextSize = 11
            slotTitle.Font = Enum.Font.GothamBold
            slotTitle.TextXAlignment = Enum.TextXAlignment.Center
            slotTitle.Parent = slotRow

            local softCol = (T and T.Soft) or Color3.fromRGB(28, 18, 42)
            local textCol = (T and T.Text) or Color3.fromRGB(245, 240, 255)

            local leftArrow = Instance.new("TextButton")
            leftArrow.Size = UDim2.new(0, 32, 0, 24)
            leftArrow.Position = UDim2.new(0, 10, 1, -28)
            leftArrow.BackgroundColor3 = softCol
            leftArrow.Text = "◄"
            leftArrow.TextColor3 = textCol
            leftArrow.TextSize = 13
            leftArrow.Font = Enum.Font.GothamBold
            leftArrow.AutoButtonColor = false
            leftArrow.Parent = slotRow
            Corner(leftArrow, 8)

            local slotLbl = Instance.new("TextLabel")
            slotLbl.Size = UDim2.new(1, -84, 0, 24)
            slotLbl.Position = UDim2.new(0, 42, 1, -28)
            slotLbl.BackgroundTransparency = 1
            slotLbl.Text = "SLOT " .. tostring((H and H.selectedSlot) or 1)
            slotLbl.TextColor3 = textCol
            slotLbl.TextSize = 14
            slotLbl.Font = Enum.Font.GothamBold
            slotLbl.TextXAlignment = Enum.TextXAlignment.Center
            slotLbl.Parent = slotRow

            local rightArrow = Instance.new("TextButton")
            rightArrow.Size = UDim2.new(0, 32, 0, 24)
            rightArrow.Position = UDim2.new(1, -42, 1, -28)
            rightArrow.BackgroundColor3 = softCol
            rightArrow.Text = "►"
            rightArrow.TextColor3 = textCol
            rightArrow.TextSize = 13
            rightArrow.Font = Enum.Font.GothamBold
            rightArrow.AutoButtonColor = false
            rightArrow.Parent = slotRow
            Corner(rightArrow, 8)

            local function applySlot(num)
                num = math.clamp(tonumber(num) or 1, 1, 11)
                if H then
                    if H.setSelectedSlot then
                        H.setSelectedSlot(num)
                    else
                        H.selectedSlot = num
                        if H.updateSlotVisuals then pcall(H.updateSlotVisuals) end
                    end
                end
                slotLbl.Text = "SLOT " .. tostring(num)
                if Config then Config.set("isv2_slot", num) end
            end
            applySlot((H and H.selectedSlot) or 1)

            leftArrow.MouseButton1Click:Connect(function()
                local s = ((H and H.selectedSlot) or 1) - 1
                if s < 1 then s = 11 end
                applySlot(s)
            end)
            rightArrow.MouseButton1Click:Connect(function()
                local s = ((H and H.selectedSlot) or 1) + 1
                if s > 11 then s = 1 end
                applySlot(s)
            end)

            makeActionBtn(content, 2, "Activate (Reset)", function()
                if H and H.activate then H:activate() end
            end)
            makeActionBtn(content, 3, "Execute", function()
                if H and H.execute then H:execute(false) end
            end)
            makeActionBtn(content, 4, "Execute (Full)", function()
                if H and H.execute then H:execute(true) end
            end)

            local ISV2_NORMAL_H = 280
            local ISV2_SETTINGS_H = 360
            local ISV2_TITLE_H = 36
            local isv2Minimized = false
            local isv2ExpandedSize = UDim2.new(0, 240, 0, ISV2_NORMAL_H)

            local function showSettings(on)
                if isv2Minimized then return end
                settingsView.Visible = on
                content.Visible = not on
                settingsBtn.Visible = not on
                if mainFrame then
                    local w = mainFrame.Size.X.Offset
                    if w <= 0 then w = 240 end
                    local oldH = mainFrame.Size.Y.Offset
                    if oldH <= 0 then oldH = ISV2_NORMAL_H end
                    local newH = on and ISV2_SETTINGS_H or ISV2_NORMAL_H
                    local ap = mainFrame.AnchorPoint
                    local topY = mainFrame.Position.Y.Offset - oldH * ap.Y
                    local newPosY = topY + newH * ap.Y
                    mainFrame.Size = UDim2.new(0, w, 0, newH)
                    mainFrame.Position = UDim2.new(
                        mainFrame.Position.X.Scale, mainFrame.Position.X.Offset,
                        mainFrame.Position.Y.Scale, newPosY
                    )
                    isv2ExpandedSize = mainFrame.Size
                end
            end

            local function toggleMinimize()
                if not mainFrame or not mainFrame.Parent then return end
                isv2Minimized = not isv2Minimized
                if isv2Minimized then
                    isv2ExpandedSize = mainFrame.Size
                    if content then content.Visible = false end
                    if settingsView then settingsView.Visible = false end
                    if settingsBtn then settingsBtn.Visible = false end
                    mainFrame.ClipsDescendants = true
                    mainFrame.Size = UDim2.new(
                        mainFrame.Size.X.Scale, mainFrame.Size.X.Offset,
                        0, ISV2_TITLE_H
                    )
                    minBtn.Text = "+"
                else
                    mainFrame.Size = isv2ExpandedSize or UDim2.new(0, 240, 0, ISV2_NORMAL_H)
                    mainFrame.ClipsDescendants = false
                    if content then content.Visible = true end
                    if settingsView then settingsView.Visible = false end
                    if settingsBtn then settingsBtn.Visible = true end
                    minBtn.Text = "–"
                end
            end

            -- Un seul connect pour éviter double-toggle (Activated + Click)
            minBtn.Activated:Connect(toggleMinimize)

            settingsBtn.MouseButton1Click:Connect(function()
                showSettings(not settingsView.Visible)
            end)
            backBtn.MouseButton1Click:Connect(function()
                showSettings(false)
            end)

            -- Drag (hub style)
            local dragging, dragStart, startPos = false, nil, nil
            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    if _G._FH_GuiLocked then return end
                    dragging = true
                    dragStart = input.Position
                    startPos = mainFrame.Position
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        pcall(function()
                            if Config and mainFrame then
                                Config.set("isv2_panel_pos", {
                                    mainFrame.Position.X.Scale, mainFrame.Position.X.Offset,
                                    mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset,
                                })
                            end
                        end)
                    end
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                    and input.UserInputType ~= Enum.UserInputType.Touch then return end
                if _G._FH_GuiLocked then dragging = false return end
                local d = input.Position - dragStart
                mainFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end)
        end

        local M = {}
        function M.set(on)
            -- Panel visibility only — HALF toggles (potion, AP spam, walk, slot…) stay active
            state.open = on and true or false
            if state.open then
                build()
                task.defer(function()
                    if HALF and HALF.updateSlotVisuals then pcall(HALF.updateSlotVisuals) end
                end)
            else
                destroy()
                -- Keep slot selection + tracers + auto features running
                task.defer(function()
                    if HALF and HALF.selectedSlot and HALF.updateSlotVisuals then
                        pcall(HALF.updateSlotVisuals)
                    end
                end)
            end
            pcall(function()
                if Config then
                    Config.set("toggle:Instant Steal Panel V2", state.open)
                    Config.set("isv2_panel_visible", state.open)
                end
            end)
        end
        function M.isOpen()
            return state.open and gui and gui.Parent ~= nil
        end
        function M.repaint()
            -- Panel is rebuilt with current T/Theme when opened; force restyle if open
            if state.open and mainFrame then
                pcall(function()
                    if type(_G._CyutsudStyleLikeHub) == "function" then
                        local tb = mainFrame:FindFirstChild("TitleBar")
                        _G._CyutsudStyleLikeHub(mainFrame, tb)
                    end
                end)
            end
        end
        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.InstantStealV2 and _G.InstantStealV2.set then _G.InstantStealV2.set(false) end
        end)
    end)

    local TeleportService = game:GetService("TeleportService")
    local LP = Players.LocalPlayer

    -- ==========================================
    -- RESET SYSTEM (Actions Panel Instant Reset)
    -- Source: SimpleResetGUI ResetPlayer (hipheight + camera lock)
    -- Used by: Panel Actions + Panel Actions Mobile "Instant Reset"
    -- ==========================================
    local LP = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")

    local RS = {
        cooldown = false,
        lockId = 0,
        cameraLocked = false,
        lockedCFrame = nil,
    }

    local function FixFloating(character)
        if not character or not character.Parent then return end
        pcall(function()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if humanoid.HipHeight > 10 or humanoid.HipHeight < 0.5 then
                    humanoid.HipHeight = 2
                end
                humanoid.PlatformStand = false
                humanoid.Sit = false
                humanoid.AutoRotate = true
            end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart and not rootPart.CanCollide then
                rootPart.CanCollide = true
            end
            for _, joint in ipairs(character:GetDescendants()) do
                if (joint:IsA("Motor6D") or joint:IsA("Motor")) and not joint.Enabled then
                    joint.Enabled = true
                end
            end
        end)
    end

    local function ResetPlayer()
        if RS.cooldown then return end
        RS.cooldown = true

        local character = LP.Character
        if not character then RS.cooldown = false return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then RS.cooldown = false return end

        RS.lockId = RS.lockId + 1
        local myLockId = RS.lockId

        local camera = Workspace.CurrentCamera
        if camera and not RS.cameraLocked then
            RS.lockedCFrame = camera.CFrame
            RS.cameraLocked = true
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = RS.lockedCFrame
        end

        local originalHipHeight = humanoid.HipHeight
        if type(originalHipHeight) ~= "number" or originalHipHeight > 10 or originalHipHeight < 0 then
            originalHipHeight = 2
        end

        task.spawn(function()
            local attempts = 0
            while character and character.Parent and humanoid and humanoid.Health > 0 and myLockId == RS.lockId do
                pcall(function()
                    humanoid.HipHeight = 1e30
                    humanoid.AutoRotate = true
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then root.CanCollide = false end
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)

                attempts = attempts + 1
                if attempts >= 25 then break end
                task.wait(0.05)
            end

            if character and character.Parent and humanoid then
                pcall(function() humanoid.HipHeight = originalHipHeight end)
            end

            if character and character.Parent and myLockId == RS.lockId then
                pcall(function()
                    humanoid.HipHeight = originalHipHeight
                    humanoid.PlatformStand = false
                    humanoid.AutoRotate = true
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then root.CanCollide = true end
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end)
            end

            if myLockId == RS.lockId then
                RS.cameraLocked = false
                RS.lockedCFrame = nil
                pcall(function()
                    local cam = Workspace.CurrentCamera
                    if cam then
                        cam.CameraType = Enum.CameraType.Custom
                        local newChar = LP.Character
                        local newHum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                        if newHum then cam.CameraSubject = newHum end
                    end
                end)
            end
            RS.cooldown = false
        end)
    end

    local function StopResetSequence()
        RS.lockId = RS.lockId + 1
        RS.cooldown = false
        RS.cameraLocked = false
        RS.lockedCFrame = nil
        local char = LP.Character
        if char then
            FixFloating(char)
        end
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam then
                cam.CameraType = Enum.CameraType.Custom
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then cam.CameraSubject = hum end
            end
        end)
    end

    -- Fix floating auto (safety)
    task.spawn(function()
        while true do
            task.wait(1)
            if _isShuttingDown and _isShuttingDown() then break end
            local char = LP.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    if humanoid.HipHeight > 100 or humanoid.HipHeight < 0.1 then
                        FixFloating(char)
                    end
                end
            end
        end
    end)

    LP.CharacterAdded:Connect(function(newChar)
        StopResetSequence()
        task.wait(0.5)
        if newChar and newChar.Parent then
            FixFloating(newChar)
        end
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam then
                cam.CameraType = Enum.CameraType.Custom
                local hum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                if hum then cam.CameraSubject = hum end
            end
        end)
    end)

    _G.ResetPlayer = ResetPlayer
    _G.coreResetPlayer = ResetPlayer
    _G.instaReset = ResetPlayer
    _G.coreInstaReset = ResetPlayer
    _G.StopResetSequence = StopResetSequence
    _G.NoxForceUnlock = StopResetSequence

    local ACTIONS = {
        Rejoin = function()
            task.spawn(function()
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LP)
                end)
            end)
            pcall(function()
                LP:Kick("rejoining")
            end)
        end,

        ["Kick Self"] = function()
            pcall(function()
                LP:Kick("Kick Self")
            end)
        end,

        ["Ragdoll Self"] = function()
            task.spawn(function()
                local Players = game:GetService("Players")
                local LP = Players.LocalPlayer
                if not LP then return end
                local ok = false

                -- 1) Admin Panel / QAP: commande ragdoll sur SOI-MEME
                pcall(function()
                    local fn = _G.qapRunCommand or qapRunCommand
                    if type(fn) == "function" then
                        local r = fn("ragdoll", LP)
                        if r ~= false then ok = true end
                    end
                end)

                -- 2) UI AdminPanel direct (getconnections)
                if not ok then
                    pcall(function()
                        local pg = LP:FindFirstChild("PlayerGui")
                        local ap = pg and pg:FindFirstChild("AdminPanel")
                        if not ap then return end
                        local content = ap:FindFirstChild("AdminPanel")
                        content = content and content:FindFirstChild("Content")
                        local sf = content and content:FindFirstChild("ScrollingFrame")
                        if not sf then
                            for _, d in ipairs(ap:GetDescendants()) do
                                if d:IsA("ScrollingFrame") then sf = d; break end
                            end
                        end
                        if not sf then return end
                        local cmdBtn = sf:FindFirstChild("ragdoll")
                        if not cmdBtn then
                            for _, ch in ipairs(sf:GetDescendants()) do
                                if ch:IsA("GuiButton") and string.lower(ch.Name) == "ragdoll" then
                                    cmdBtn = ch; break
                                end
                            end
                        end
                        -- selectionner son propre profil si possible
                        local profileFrame = nil
                        for _, d in ipairs(ap:GetDescendants()) do
                            if d.Name == "Profiles" or d.Name == "Players" or d.Name == "PlayerList" then
                                profileFrame = d; break
                            end
                        end
                        if profileFrame then
                            local me = profileFrame:FindFirstChild(LP.Name)
                            if me and getconnections then
                                for _, c in ipairs(getconnections(me.Activated or me.MouseButton1Click)) do
                                    if c.Function then pcall(c.Function) end
                                end
                            elseif me and me:IsA("GuiButton") then
                                pcall(function() me:Activate() end)
                            end
                            task.wait(0.05)
                        end
                        if cmdBtn and getconnections then
                            local signal = cmdBtn.Activated or cmdBtn.MouseButton1Click
                            if signal then
                                for _, c in ipairs(getconnections(signal)) do
                                    if c.Function then pcall(c.Function); ok = true end
                                end
                            end
                        elseif cmdBtn and cmdBtn:IsA("GuiButton") then
                            pcall(function() cmdBtn:Activate() end)
                            ok = true
                        end
                    end)
                end

                -- 3) Remote admin
                if not ok then
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local net = ReplicatedStorage:FindFirstChild("Packages")
                        net = net and net:FindFirstChild("Net")
                        if not net then return end
                        local children = net:GetChildren()
                        local remote = nil
                        local guid = "RF/a0e78691-cb9b-4efc-ac08-9c06fea70059"
                        for i, o in ipairs(children) do
                            if o.Name == guid and children[i + 1] then
                                remote = children[i + 1]
                                break
                            end
                        end
                        if not remote then
                            for i = 1, #children - 1 do
                                if string.find(children[i].Name, "Tools/Admin", 1, true)
                                    or string.find(children[i].Name, "Tools/Cooldown", 1, true) then
                                    remote = children[i + 1]
                                    break
                                end
                            end
                        end
                        if remote then
                            local uuid = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
                            if remote:IsA("RemoteFunction") then
                                remote:InvokeServer(uuid, LP, "ragdoll")
                            elseif remote:IsA("RemoteEvent") then
                                remote:FireServer(uuid, LP, "ragdoll")
                            end
                            ok = true
                        end
                    end)
                end

                pcall(function()
                    if _G._CyutsudNotifyAdminCommand then
                        _G._CyutsudNotifyAdminCommand("ragdoll", LP)
                    end
                end)
                pcall(function()
                    if showToast then showToast("Ragdoll Self (Admin)", ok) end
                end)
            end)
        end,
        ["Instant Reset"] = function()
            pcall(function()
                if type(ResetPlayer) == "function" then
                    ResetPlayer()
                end
            end)
            return "Instant Reset"
        end,

        ["UP+TP"] = function()
            task.spawn(function()
                if _G._CyutsudUpTpBusy then
                    pcall(function() if showToast then showToast("UP+TP déjà en cours…", false) end end)
                    return
                end
                _G._CyutsudUpTpBusy = true
                pcall(function()
                    if Booster and Booster.suspend then Booster.suspend("uptp") end
                end)
                pcall(function()
                    if _G.GiantPotionSpeed and _G.GiantPotionSpeed.pause then _G.GiantPotionSpeed.pause() end
                end)
                local ok, err = pcall(function()
                    local RunService = game:GetService("RunService")
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local pos2 = Vector3.new(-353.4053, -6.9626, 114.8761)
                    local char = LP.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum then return end

                    pcall(function() if showToast then showToast("UP+TP: UP…", true) end end)

                    local oldM = char:FindFirstChild("NoxUpTpMover")
                    if oldM then pcall(function() oldM:Destroy() end) end
                    hrp.AssemblyLinearVelocity = Vector3.zero

                    local upDuration, upwardSpeed = 0.4, 80
                    local t0 = tick()
                    local upConn
                    upConn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then
                            if upConn then upConn:Disconnect() end
                            return
                        end
                        if tick() - t0 >= upDuration then
                            upConn:Disconnect()
                            return
                        end
                        hrp.AssemblyLinearVelocity = Vector3.new(0, upwardSpeed, 0)
                    end)
                    task.wait(upDuration)
                    if upConn then pcall(function() upConn:Disconnect() end) end
                    if not hrp or not hrp.Parent then return end

                    pcall(function() if showToast then showToast("UP+TP: FLYING…", true) end end)

                    local function getCarpet()
                        local names = {}
                        if _G.coreSelectedCarpet then table.insert(names, _G.coreSelectedCarpet) end
                        for _, n in ipairs({"Flying Carpet", "Carpet", "Tapis", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh"}) do
                            table.insert(names, n)
                        end
                        local function scan(parent)
                            if not parent then return nil end
                            for _, name in ipairs(names) do
                                local t = parent:FindFirstChild(name)
                                if t and t:IsA("Tool") then return t end
                            end
                            for _, t in ipairs(parent:GetChildren()) do
                                if t:IsA("Tool") then
                                    local ln = string.lower(t.Name)
                                    if ln:find("carpet", 1, true) or ln:find("tapis", 1, true)
                                        or ln:find("broom", 1, true) or ln:find("sleigh", 1, true)
                                        or ln:find("waverider", 1, true) or ln:find("wing", 1, true) then
                                        return t
                                    end
                                end
                            end
                            return nil
                        end
                        return scan(char) or scan(LP:FindFirstChild("Backpack"))
                    end

                    local function equipCarpet()
                        local tool = getCarpet()
                        if tool and tool.Parent ~= char and hum then
                            pcall(function() hum:EquipTool(tool) end)
                        end
                        return tool
                    end

                    local mover = Instance.new("Part")
                    mover.Size = Vector3.new(3, 0.5, 3)
                    mover.Transparency = 1
                    mover.CanCollide = false
                    mover.Massless = true
                    mover.Name = "NoxUpTpMover"
                    mover.Parent = char
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = hrp
                    weld.Part1 = mover
                    weld.Parent = mover

                    local prevSpeed = hum.WalkSpeed
                    hum.WalkSpeed = 130
                    pcall(equipCarpet)

                    local flyStart = tick()
                    while tick() - flyStart < 8 do
                        if not hrp or not hrp.Parent then break end
                        pcall(equipCarpet)
                        local currentPos = hrp.Position
                        local targetPosition = Vector3.new(pos2.X, currentPos.Y, pos2.Z)
                        local diff = targetPosition - currentPos
                        if diff.Magnitude < 4 then break end
                        hrp.AssemblyLinearVelocity = diff.Unit * 140
                        pcall(function() hum:MoveTo(targetPosition) end)
                        RunService.Heartbeat:Wait()
                    end

                    if mover and mover.Parent then pcall(function() mover:Destroy() end) end
                    pcall(function() hum.WalkSpeed = prevSpeed or 16 end)
                    if hrp and hrp.Parent then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        hrp.CFrame = CFrame.new(pos2)
                    end
                    task.wait(0.1)

                    pcall(function() if showToast then showToast("UP+TP: POTION…", true) end end)
                    local backpack = LP:FindFirstChild("Backpack")
                    local giantTool = nil
                    for _, name in ipairs({"Giant Potion", "Giant", "Grow Potion", "Super Grow"}) do
                        if backpack then
                            local t = backpack:FindFirstChild(name)
                            if t and t:IsA("Tool") then giantTool = t break end
                        end
                        local t2 = char:FindFirstChild(name)
                        if t2 and t2:IsA("Tool") then giantTool = t2 break end
                    end
                    if giantTool and hum then
                        pcall(function()
                            if giantTool.Parent ~= char then hum:EquipTool(giantTool) end
                            task.wait(0.2)
                            giantTool:Activate()
                            task.wait(0.4)
                            if backpack then giantTool.Parent = backpack end
                        end)
                    end

                    pcall(function()
                        local net = ReplicatedStorage:FindFirstChild("Packages")
                        net = net and net:FindFirstChild("Net")
                        if not net then return end
                        local children = net:GetChildren()
                        local remote = nil
                        local guid = "RF/a0e78691-cb9b-4efc-ac08-9c06fea70059"
                        for i, o in ipairs(children) do
                            if o.Name == guid and children[i + 1] then
                                remote = children[i + 1]
                                break
                            end
                        end
                        if not remote then
                            for i = 1, #children - 1 do
                                if string.find(children[i].Name, "Tools/Cooldown", 1, true) then
                                    remote = children[i + 1]
                                    break
                                end
                            end
                        end
                        if remote then
                            local uuid = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
                            if remote:IsA("RemoteFunction") then
                                remote:InvokeServer(uuid, LP, "ragdoll")
                            elseif remote:IsA("RemoteEvent") then
                                remote:FireServer(uuid, LP, "ragdoll")
                            end
                        end
                    end)

                    pcall(function() if showToast then showToast("UP+TP: Terminé", true) end end)
                end)
                if not ok then
                    pcall(function() if showToast then showToast("UP+TP: Erreur", false) end end)
                end
                pcall(function()
                    if Booster and Booster.unsuspend then Booster.unsuspend("uptp") end
                end)
                pcall(function()
                    if _G.GiantPotionSpeed and _G.GiantPotionSpeed.resume then _G.GiantPotionSpeed.resume() end
                end)
                _G._CyutsudUpTpBusy = false
            end)
        end,

        ["Ragdoll tech"] = function()
            -- RAGDOLL TECH v3: Giant Potion → ragdoll SELF (AdminPanel / remote / local)
            task.spawn(function()
                if _G._CyutsudRagdollTechBusy then
                    pcall(function()
                        if showToast then showToast("Ragdoll tech déjà en cours…", false) end
                    end)
                    return
                end
                _G._CyutsudRagdollTechBusy = true

                local okAll, errAll = pcall(function()
                    local LP = Players.LocalPlayer
                    local char = LP and LP.Character
                    if not char then
                        pcall(function()
                            if showToast then showToast("Ragdoll tech: Pas de personnage", false) end
                        end)
                        return
                    end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    local backpack = LP:FindFirstChild("Backpack")
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")

                    ----------------------------------------------------------------
                    -- 1) GIANT POTION
                    ----------------------------------------------------------------
                    local function drinkGiantPotion()
                        local names = { "Giant Potion", "Giant", "Grow Potion", "Super Grow" }
                        local potion = nil
                        for _, name in ipairs(names) do
                            if backpack then
                                local t = backpack:FindFirstChild(name)
                                if t and t:IsA("Tool") then potion = t break end
                            end
                            local t2 = char:FindFirstChild(name)
                            if t2 and t2:IsA("Tool") then potion = t2 break end
                        end
                        if not potion and backpack then
                            for _, t in ipairs(backpack:GetChildren()) do
                                if t:IsA("Tool") then
                                    local n = string.lower(t.Name)
                                    if n:find("giant", 1, true) or n:find("grow", 1, true) then
                                        potion = t
                                        break
                                    end
                                end
                            end
                        end
                        if potion then
                            pcall(function()
                                if potion.Parent ~= char then
                                    hum:EquipTool(potion)
                                end
                            end)
                            task.wait(0.15)
                            pcall(function() potion:Activate() end)
                            task.wait(0.08)
                            pcall(function() potion:Activate() end)
                            task.wait(0.4)
                            return true
                        end
                        pcall(function()
                            if _G.AutoBigPotion and _G.AutoBigPotion.forceActivate then
                                _G.AutoBigPotion.forceActivate()
                            elseif _G.AutoPotionSystem and _G.AutoPotionSystem.forceActivate then
                                _G.AutoPotionSystem:forceActivate()
                            end
                        end)
                        task.wait(0.4)
                        return false
                    end

                    ----------------------------------------------------------------
                    -- 2) RAGDOLL SELF via AdminPanel (QAP / getconnections)
                    ----------------------------------------------------------------
                    local function waitForAdminFrames(maxAttempts, delay)
                        maxAttempts = maxAttempts or 8
                        delay = delay or 0.2
                        for _ = 1, maxAttempts do
                            local pg = LP:FindFirstChild("PlayerGui") or LP:FindFirstChildOfClass("PlayerGui")
                            local ap = pg and pg:FindFirstChild("AdminPanel")
                            if ap then
                                local inner = ap:FindFirstChild("AdminPanel")
                                if inner then
                                    local content  = inner:FindFirstChild("Content")
                                    local profiles = inner:FindFirstChild("Profiles")
                                    if content and profiles then
                                        local commandFrame = content:FindFirstChild("ScrollingFrame")
                                        local profileFrame = profiles:FindFirstChild("ScrollingFrame")
                                        if commandFrame and profileFrame then
                                            return commandFrame, profileFrame
                                        end
                                    end
                                end
                            end
                            task.wait(delay)
                        end
                        return nil, nil
                    end

                    local function cacheActivated(guiObject)
                        local cached = {}
                        if type(getconnections) ~= "function" then return cached end
                        local okc, conns = pcall(getconnections, guiObject.Activated)
                        if okc and type(conns) == "table" then
                            for _, conn in ipairs(conns) do
                                if type(conn.Function) == "function" then
                                    table.insert(cached, conn.Function)
                                end
                            end
                        end
                        if #cached == 0 then
                            local ok2, conns2 = pcall(getconnections, guiObject.MouseButton1Click)
                            if ok2 and type(conns2) == "table" then
                                for _, conn in ipairs(conns2) do
                                    if type(conn.Function) == "function" then
                                        table.insert(cached, conn.Function)
                                    end
                                end
                            end
                        end
                        return cached
                    end

                    local function fireActivated(cached)
                        for _, fn in ipairs(cached) do
                            task.spawn(fn)
                        end
                    end

                    local function runQapRagdoll()
                        -- Prefer shared hub QAP if available
                        if type(_G.qapRunCommand) == "function" then
                            local ok = false
                            pcall(function()
                                ok = _G.qapRunCommand("ragdoll", LP) and true or false
                            end)
                            if ok then return true end
                        end

                        local commandFrame, profileFrame = waitForAdminFrames(8, 0.2)
                        if not commandFrame or not profileFrame then
                            return false
                        end
                        local profileButton = profileFrame:FindFirstChild(LP.Name)
                        local commandButton = commandFrame:FindFirstChild("ragdoll")
                        if not profileButton or not commandButton then
                            return false
                        end
                        local pCache = cacheActivated(profileButton)
                        local cCache = cacheActivated(commandButton)
                        if #pCache == 0 and #cCache == 0 then
                            return false
                        end
                        fireActivated(pCache)
                        task.wait(0.05)
                        fireActivated(cCache)
                        return true
                    end

                    ----------------------------------------------------------------
                    -- 3) Fallback remote
                    ----------------------------------------------------------------
                    local function tryRemoteRagdoll()
                        local ok = false
                        pcall(function()
                            local net = ReplicatedStorage:FindFirstChild("Packages")
                            net = net and net:FindFirstChild("Net")
                            if not net then return end
                            local children = net:GetChildren()
                            local remote = nil
                            local guid = "RF/a0e78691-cb9b-4efc-ac08-9c06fea70059"
                            for i, o in ipairs(children) do
                                if o.Name == guid and children[i + 1] then
                                    remote = children[i + 1]
                                    break
                                end
                            end
                            if not remote then
                                for i = 1, #children - 1 do
                                    if string.find(children[i].Name, "Tools/Cooldown", 1, true) then
                                        remote = children[i + 1]
                                        break
                                    end
                                end
                            end
                            if remote then
                                local uuid = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
                                if remote:IsA("RemoteFunction") then
                                    remote:InvokeServer(uuid, LP, "ragdoll")
                                elseif remote:IsA("RemoteEvent") then
                                    remote:FireServer(uuid, LP, "ragdoll")
                                end
                                ok = true
                            end
                        end)
                        return ok
                    end

                    ----------------------------------------------------------------
                    -- SEQUENCE
                    ----------------------------------------------------------------
                    drinkGiantPotion()

                    local ok = runQapRagdoll()
                    if not ok then
                        ok = tryRemoteRagdoll()
                    end
                    if not ok then
                        pcall(function()
                            hum:ChangeState(Enum.HumanoidStateType.Physics)
                            hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
                            hum.PlatformStand = true
                        end)
                    end

                    pcall(function()
                        if showToast then showToast("Ragdoll tech: Giant + Ragdoll", true) end
                        if _G.coreNotify then
                            _G.coreNotify.show("Ragdoll tech", "Giant Potion + Ragdoll Self")
                        end
                    end)
                end)

                if not okAll then
                    pcall(function()
                        if showToast then showToast("Ragdoll tech error", false) end
                        warn("[Ragdoll Tech]", errAll)
                    end)
                end
                task.wait(0.35)
                _G._CyutsudRagdollTechBusy = false
            end)
            return "Ragdoll tech"
        end,

        ["Ragdoll Tech Duel"] = function()
            -- Giant Potion → equip Heatseeker → fire (Duel)
            task.spawn(function()
                if _G._CyutsudRagdollTechDuelBusy then
                    pcall(function()
                        if showToast then showToast("Ragdoll Tech Duel déjà en cours…", false) end
                    end)
                    return
                end
                _G._CyutsudRagdollTechDuelBusy = true

                local okAll, errAll = pcall(function()
                    local LP = Players.LocalPlayer
                    local char = LP and LP.Character
                    if not char then
                        pcall(function()
                            if showToast then showToast("Ragdoll Tech Duel: Pas de personnage", false) end
                        end)
                        return
                    end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    local backpack = LP:FindFirstChild("Backpack")

                    ----------------------------------------------------------------
                    -- 1) GIANT POTION (same as Ragdoll tech)
                    ----------------------------------------------------------------
                    local function drinkGiantPotion()
                        local names = { "Giant Potion", "Giant", "Grow Potion", "Super Grow" }
                        local potion = nil
                        for _, name in ipairs(names) do
                            if backpack then
                                local t = backpack:FindFirstChild(name)
                                if t and t:IsA("Tool") then potion = t break end
                            end
                            local t2 = char:FindFirstChild(name)
                            if t2 and t2:IsA("Tool") then potion = t2 break end
                        end
                        if not potion and backpack then
                            for _, t in ipairs(backpack:GetChildren()) do
                                if t:IsA("Tool") then
                                    local n = string.lower(t.Name)
                                    if n:find("giant", 1, true) or n:find("grow", 1, true) then
                                        potion = t
                                        break
                                    end
                                end
                            end
                        end
                        if not potion then
                            for _, t in ipairs(char:GetChildren()) do
                                if t:IsA("Tool") then
                                    local n = string.lower(t.Name)
                                    if n:find("giant", 1, true) or n:find("grow", 1, true) then
                                        potion = t
                                        break
                                    end
                                end
                            end
                        end
                        if potion then
                            pcall(function()
                                if potion.Parent ~= char then
                                    hum:EquipTool(potion)
                                end
                            end)
                            task.wait(0.15)
                            pcall(function() potion:Activate() end)
                            task.wait(0.08)
                            pcall(function() potion:Activate() end)
                            task.wait(0.4)
                            return true
                        end
                        pcall(function()
                            if _G.AutoBigPotion and _G.AutoBigPotion.forceActivate then
                                _G.AutoBigPotion.forceActivate()
                            elseif _G.AutoPotionSystem and _G.AutoPotionSystem.forceActivate then
                                _G.AutoPotionSystem:forceActivate()
                            end
                        end)
                        task.wait(0.35)
                        return false
                    end

                    ----------------------------------------------------------------
                    -- 2) EQUIP HEATSEEKER + FIRE
                    ----------------------------------------------------------------
                    local function findHeatseeker()
                        local exact = {
                            "Heatseeker", "Heat Seeker", "Heat-Seeker", "HeatSeeker",
                            "heatseeker", "Heat Seeker Gun", "Heatseeker Gun",
                        }
                        local function scan(parent)
                            if not parent then return nil end
                            for _, name in ipairs(exact) do
                                local t = parent:FindFirstChild(name)
                                if t and t:IsA("Tool") then return t end
                            end
                            for _, t in ipairs(parent:GetChildren()) do
                                if t:IsA("Tool") then
                                    local n = string.lower(t.Name or "")
                                    if n:find("heatseek", 1, true)
                                        or n:find("heat seek", 1, true)
                                        or n:find("heat-seek", 1, true)
                                        or (n:find("heat", 1, true) and n:find("seek", 1, true))
                                    then
                                        return t
                                    end
                                end
                            end
                            return nil
                        end
                        return scan(backpack) or scan(char)
                    end

                    local function fireTool(tool)
                        if not tool then return false end
                        -- Standard Activate
                        pcall(function() tool:Activate() end)
                        -- VirtualUser click (some tools need it)
                        pcall(function()
                            local vu = game:GetService("VirtualUser")
                            if vu and vu.ClickButton1 then
                                vu:ClickButton1(Vector2.new(0, 0))
                            end
                        end)
                        -- VirtualInputManager left click
                        pcall(function()
                            local vim = game:GetService("VirtualInputManager")
                            if vim and vim.SendMouseButtonEvent then
                                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                task.wait(0.05)
                                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            end
                        end)
                        -- Fire any BindableEvent / Remote under tool
                        pcall(function()
                            for _, d in ipairs(tool:GetDescendants()) do
                                if d:IsA("RemoteEvent") then
                                    pcall(function() d:FireServer() end)
                                elseif d:IsA("BindableEvent") then
                                    pcall(function() d:Fire() end)
                                end
                            end
                        end)
                        return true
                    end

                    local function equipAndFireHeatseeker()
                        local tool = findHeatseeker()
                        if not tool then
                            pcall(function()
                                if showToast then showToast("Ragdoll Tech Duel: Heatseeker introuvable", false) end
                            end)
                            return false
                        end
                        pcall(function()
                            if tool.Parent ~= char then
                                hum:EquipTool(tool)
                            end
                        end)
                        task.wait(0.18)
                        -- Re-resolve after equip (tool may move)
                        tool = char:FindFirstChild(tool.Name) or tool
                        pcall(function()
                            if showToast then showToast("Ragdoll Tech Duel: Heatseeker…", true) end
                        end)
                        -- Fire several times for reliability
                        for _ = 1, 4 do
                            fireTool(tool)
                            task.wait(0.12)
                        end
                        return true
                    end

                    ----------------------------------------------------------------
                    -- SEQUENCE
                    ----------------------------------------------------------------
                    pcall(function()
                        if showToast then showToast("Ragdoll Tech Duel: Giant…", true) end
                    end)
                    drinkGiantPotion()
                    task.wait(0.15)
                    equipAndFireHeatseeker()

                    pcall(function()
                        if showToast then showToast("Ragdoll Tech Duel: OK", true) end
                        if _G.coreNotify then
                            _G.coreNotify.show("Ragdoll Tech Duel", "Giant Potion + Heatseeker")
                        end
                    end)
                end)

                if not okAll then
                    pcall(function()
                        if showToast then showToast("Ragdoll Tech Duel error", false) end
                        warn("[Ragdoll Tech Duel]", errAll)
                    end)
                end
                task.wait(0.25)
                _G._CyutsudRagdollTechDuelBusy = false
            end)
            return "Ragdoll Tech Duel"
        end,
    }
    _G.coreACTIONS = ACTIONS
    _G.fireRagdollTech = function()
        local fn = ACTIONS and ACTIONS["Ragdoll tech"]
        if fn then return fn() end
    end
    _G.fireRagdollTechDuel = function()
        local fn = ACTIONS and ACTIONS["Ragdoll Tech Duel"]
        if fn then return fn() end
    end
    _G.coreInstantReset = function()
        local fn = ACTIONS and ACTIONS["Instant Reset"]
        if fn then return fn() end
        pcall(ResetPlayer)
    end
    _G.coreRejoin = ACTIONS.Rejoin

    _G.ActionsPanel = (function()
        local gui = nil
        local mainFrame = nil

        local function _resolveGuiParent()
            local candidates = {}
            pcall(function()
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then table.insert(candidates, h) end
                end
            end)
            pcall(function()
                local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                table.insert(candidates, _cr(game:GetService("CoreGui")))
            end)
            pcall(function()
                if GUI and GUI.Parent then table.insert(candidates, GUI.Parent) end
            end)
            pcall(function()
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")
                if pg then table.insert(candidates, pg) end
            end)
            for _, p in ipairs(candidates) do
                if p then
                    local ok = pcall(function()
                        local test = Instance.new("Folder")
                        test.Name = "_CyutsudParentTest"
                        test.Parent = p
                        test:Destroy()
                    end)
                    if ok then return p end
                end
            end
            return LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        end

        local function destroy()
            if gui then
                pcall(function() gui:Destroy() end)
                gui = nil
                mainFrame = nil
            end
            pcall(function()
                local parents = {}
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then table.insert(parents, h) end
                end
                pcall(function()
                    local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                    table.insert(parents, _cr(game:GetService("CoreGui")))
                end)
                local pg = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui"))
                if pg then table.insert(parents, pg) end
                for _, parent in ipairs(parents) do
                    local old = parent:FindFirstChild("PanelGui_Actions")
                    if old then pcall(function() old:Destroy() end) end
                end
            end)
        end

        local function build()
            destroy()

            local parent = _resolveGuiParent()
            if not parent then
                return nil
            end

            gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_Actions"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999998
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = true

            pcall(function()
                if type(protect_gui) == "function" then
                    protect_gui(gui)
                elseif syn and syn.protect_gui then
                    syn.protect_gui(gui)
                end
            end)

            local okParent, errParent = pcall(function()
                gui.Parent = parent
            end)
            if not okParent or not gui.Parent then
                pcall(function()
                    local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                    if pg then gui.Parent = pg end
                end)
            end
            if not gui.Parent then
                pcall(function() gui:Destroy() end)
                gui = nil
                return nil
            end

            mainFrame = Instance.new("Frame")
            mainFrame.Name = "Frame"
            mainFrame.Size = UDim2.new(0, 220, 0, 320)
            mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- center (visible on PC)
            mainFrame.BackgroundColor3 = T.Bg
            mainFrame.BackgroundTransparency = 0.02
            mainFrame.BorderSizePixel = 0
            mainFrame.Active = true
            mainFrame.ClipsDescendants = false
            mainFrame.ZIndex = 10
            mainFrame.Visible = true
            mainFrame.Parent = gui
            pcall(function() trackBgFrame(mainFrame, "Bg") end)
            Corner(mainFrame, 14)
            pcall(function() GradStroke(mainFrame, 1.6, 0.25, 90) end)

            local shadow = Instance.new("ImageLabel")
            shadow.Name = "Shadow"
            shadow.Size = UDim2.new(1, 40, 1, 40)
            shadow.Position = UDim2.new(0, -20, 0, -20)
            shadow.BackgroundTransparency = 1
            shadow.Image = "rbxassetid://5028857084"
            shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            shadow.ImageTransparency = 0.5
            shadow.ScaleType = Enum.ScaleType.Slice
            shadow.SliceCenter = Rect.new(24, 24, 276, 276)
            shadow.ZIndex = 9
            shadow.Parent = mainFrame

            pcall(function()
                local loadedSize = false
                if loadGuiSize then
                    loadedSize = loadGuiSize("PanelGui_Actions", mainFrame, 180, 240)
                end
                if not loadedSize then
                    local s = Config.get("actions_panel_size", nil)
                    if type(s) == "table" and s[1] and s[2] and s[1] > 80 and s[2] > 80 then
                        local w = math.clamp(tonumber(s[1]) or 220, 180, 360)
                        local h = math.clamp(tonumber(s[2]) or 320, 240, 520)
                        mainFrame.Size = UDim2.new(0, w, 0, h)
                    end
                end
                local loadedPos = false
                if loadGuiPosition then
                    loadedPos = loadGuiPosition("PanelGui_Actions", mainFrame)
                    if loadedPos then
                        mainFrame.AnchorPoint = Vector2.new(0, 0)
                    end
                end
                if not loadedPos then
                    local p = Config.get("actions_panel_pos", nil)
                    if type(p) == "table" and #p >= 4 then
                        mainFrame.AnchorPoint = Vector2.new(0, 0)
                        mainFrame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                        if saveGuiPosition then
                            saveGuiPosition("PanelGui_Actions", mainFrame)
                        end
                    end
                end
            end)

            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 26)
            titleBar.BackgroundColor3 = T.BgDeep
            titleBar.BackgroundTransparency = 0.05
            titleBar.BorderSizePixel = 0
            titleBar.ZIndex = 12
            titleBar.Active = true
            titleBar.Parent = mainFrame
            pcall(function() trackBgFrame(titleBar, "BgDeep") end)
            Corner(titleBar, 12)
            local titleFill = Instance.new("Frame")
            titleFill.Size = UDim2.new(1, 0, 0, 10)
            titleFill.Position = UDim2.new(0, 0, 1, -10)
            titleFill.BackgroundColor3 = T.BgDeep
            titleFill.BackgroundTransparency = 0.05
            titleFill.BorderSizePixel = 0
            titleFill.ZIndex = 12
            titleFill.Parent = titleBar
            pcall(function() trackBgFrame(titleFill, "BgDeep") end)
            local accent = Instance.new("Frame")
            accent.Name = "HubAccent"
            accent.Size = UDim2.new(1, 0, 0, 2)
            accent.Position = UDim2.new(0, 0, 1, -2)
            accent.BackgroundColor3 = Theme.c1
            accent.BorderSizePixel = 0
            accent.ZIndex = 14
            accent.Parent = titleBar
            pcall(function() trackSolid(accent, 1) end)

            local title = Lbl(titleBar, "Actions", 13, T.Text, Enum.Font.GothamBold)
            title.Size = UDim2.new(1, -90, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.TextYAlignment = Enum.TextYAlignment.Center
            title.ZIndex = 13

            local function makeIconBtn(txt, xOff)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0, 16, 0, 16)
                b.Position = UDim2.new(1, xOff, 0.5, -9)
                b.BackgroundColor3 = T.BgDeep
                b.BorderSizePixel = 0
                b.Text = txt
                b.Font = Enum.Font.GothamBold
                b.TextSize = 12
                b.TextColor3 = T.TextDim
                b.AutoButtonColor = false
                b.ZIndex = 14
                b.Parent = titleBar
                Corner(b, 12)
                pcall(function() trackBgFrame(b, "BgDeep") end)
                b.MouseEnter:Connect(function()
                    Tween(b, F, {BackgroundColor3 = T.CardHover, TextColor3 = T.Text})
                end)
                b.MouseLeave:Connect(function()
                    Tween(b, F, {BackgroundColor3 = T.BgDeep, TextColor3 = T.TextDim})
                end)
                return b
            end

            local minBtn = makeIconBtn("–", -42)
            local closeBtn = makeIconBtn("×", -22)

            local content = Instance.new("ScrollingFrame")
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 1, -26)
            content.Position = UDim2.new(0, 0, 0, 24)
            content.BackgroundTransparency = 1
            content.BorderSizePixel = 0
            content.ScrollBarThickness = 3
            content.ScrollBarImageColor3 = T.White
            content.ScrollBarImageTransparency = 0.25
            content.CanvasSize = UDim2.new(0, 0, 0, 0)
            content.AutomaticCanvasSize = Enum.AutomaticSize.Y
            content.ScrollingDirection = Enum.ScrollingDirection.Y
            content.ZIndex = 11
            content.Visible = true
            content.Parent = mainFrame
            local list = Instance.new("UIListLayout")
            list.FillDirection = Enum.FillDirection.Vertical
            list.HorizontalAlignment = Enum.HorizontalAlignment.Center
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Padding = UDim.new(0, 3)
            list.Parent = content
            Pad(content, 4, 6, 6, 6)

            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, -4, 0, 16)
            sec.BackgroundTransparency = 1
            sec.LayoutOrder = 0
            sec.Parent = content
            local secLbl = Lbl(sec, "QUICK ACTIONS", 10, T.TextDim, Enum.Font.GothamBold)
            secLbl.Size = UDim2.new(1, -4, 1, 0)
            secLbl.Position = UDim2.new(0, 2, 0, 0)
            secLbl.TextYAlignment = Enum.TextYAlignment.Center

            local buttonLabels = {
                { "Rejoin",             "Rejoin server" },
                { "Kick Self",          "Leave game" },
                { "Ragdoll Self",       "Self ragdoll" },
                { "Instant Reset",      "Force reset" },
                { "UP+TP",              "Up fly + TP" },
                { "Ragdoll tech",       "Giant + ragdoll" },
                { "Ragdoll Tech Duel",  "Giant + Heatseeker" },
            }

            for i, entry in ipairs(buttonLabels) do
                local label, sub = entry[1], entry[2]
                local card = Instance.new("Frame")
                card.Name = "Act_" .. label:gsub("%W", "_")
                if (label == "Ragdoll Self" or label == "Ragdoll tech") and _G._CyutsudAllGearHideRagdoll then
                    card.Visible = false
                end
                card.Size = UDim2.new(1, -4, 0, 42)
                card.BackgroundColor3 = T.Card
                card.BorderSizePixel = 0
                card.LayoutOrder = i
                card.ZIndex = 12
                card.Parent = content
                pcall(function() trackBgFrame(card, "Card") end)
                Corner(card, 10)
                local cStroke = Stroke(card, T.Line, 1, 0.25)

                local nameLbl = Lbl(card, label, 12, T.Text, Enum.Font.GothamBold)
                nameLbl.Size = UDim2.new(1, -14, 0, 16)
                nameLbl.Position = UDim2.new(0, 10, 0, 4)
                nameLbl.ZIndex = 13

                local subLbl = Lbl(card, sub, 9, T.TextDim, Enum.Font.Gotham)
                subLbl.Size = UDim2.new(1, -14, 0, 12)
                subLbl.Position = UDim2.new(0, 10, 0, 22)
                subLbl.ZIndex = 13

                local accent = Instance.new("Frame")
                accent.Size = UDim2.new(0, 3, 0, 22)
                accent.Position = UDim2.new(0, 3, 0.5, -11)
                accent.BackgroundColor3 = Theme.c1
                accent.BackgroundTransparency = 0.35
                accent.BorderSizePixel = 0
                accent.ZIndex = 13
                accent.Parent = card
                Corner(accent, 12)
                pcall(function() trackSolid(accent, 1) end)

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.ZIndex = 15
                btn.Parent = card

                local function onEnter()
                    Tween(card, F, {BackgroundColor3 = T.CardHover})
                    Tween(cStroke, F, {Transparency = 0.05})
                    Tween(accent, F, {BackgroundTransparency = 0})
                end
                local function onLeave()
                    Tween(card, F, {BackgroundColor3 = T.Card})
                    Tween(cStroke, F, {Transparency = 0.25})
                    Tween(accent, F, {BackgroundTransparency = 0.35})
                end
                card.MouseEnter:Connect(onEnter)
                card.MouseLeave:Connect(onLeave)
                btn.MouseEnter:Connect(onEnter)
                btn.MouseLeave:Connect(onLeave)

                local function fire()
                    if _G._CyutsudAllGearBlockActions and _G._CyutsudAllGearBlockActions[label] then
                        return
                    end
                    local action = ACTIONS[label]
                    if action then
                        Tween(card, F, {BackgroundColor3 = Theme.c1})
                        task.delay(0.12, function()
                            if card and card.Parent then
                                Tween(card, M, {BackgroundColor3 = T.CardHover})
                            end
                        end)
                        pcall(action)
                        pcall(function() if showToast then showToast(label, true) end end)
                    end
                end
                btn.Activated:Connect(fire)
                btn.MouseButton1Click:Connect(fire)
                pcall(function()
                    if attachKeybind then
                        attachKeybind(btn, nameLbl, label, fire)
                    end
                end)
            end

            pcall(function()
                local drag = _G.makePanelDraggable or makePanelDraggable
                if drag then drag(titleBar, mainFrame, "PanelGui_Actions") end
            end)
            pcall(function()
                local lastSave = 0
                local function mirrorPos()
                    if not mainFrame or not mainFrame.Parent then return end
                    local now = tick()
                    if now - lastSave < 0.15 then return end
                    lastSave = now
                    local pos = {
                        mainFrame.Position.X.Scale, mainFrame.Position.X.Offset,
                        mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset,
                    }
                    if Config then
                        Config.set("actions_panel_pos", pos)
                        if saveGuiPosition then
                            saveGuiPosition("PanelGui_Actions", mainFrame)
                        end
                        if saveGuiSize then
                            saveGuiSize("PanelGui_Actions", mainFrame)
                        end
                        if Config.flush then Config.flush() end
                    end
                end
                if titleBar then
                    titleBar.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1
                            or inp.UserInputType == Enum.UserInputType.Touch then
                            task.defer(mirrorPos)
                        end
                    end)
                end
                local UIS = game:GetService("UserInputService")
                UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                        task.defer(mirrorPos)
                    end
                end)
            end)

            local minimized = false
            local originalSize = mainFrame.Size
            local collapsedY = 28
            minBtn.Activated:Connect(function()
                minimized = not minimized
                content.Visible = not minimized
                if minimized then
                    mainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, collapsedY)
                    minBtn.Text = "+"
                else
                    mainFrame.Size = originalSize
                    minBtn.Text = "–"
                end
            end)
            minBtn.MouseButton1Click:Connect(function() end) -- ensure clickable

            closeBtn.Activated:Connect(function()
                _G.ActionsPanel.set(false)
                pcall(function()
                    if _G._CyutsudSetToggleUI then
                        _G._CyutsudSetToggleUI("Actions Panel", false, true)
                    end
                end)
            end)
            closeBtn.MouseButton1Click:Connect(function()
                _G.ActionsPanel.set(false)
                pcall(function()
                    if _G._CyutsudSetToggleUI then
                        _G._CyutsudSetToggleUI("Actions Panel", false, true)
                    end
                end)
            end)

            return gui
        end

        local M = {}
        function M.repaint()
            pcall(function()
                if not mainFrame or not mainFrame.Parent then return end
                mainFrame.BackgroundColor3 = T.Bg
                for _, d in ipairs(mainFrame:GetDescendants()) do
                    if d:IsA("UIGradient") then
                        d.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Theme.c1),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                        })
                    end
                    if d:IsA("Frame") and (d.Name == "Badge" or d.Name:find("Accent")) then
                        d.BackgroundColor3 = Theme.c1
                    end
                    if d:IsA("Frame") and d.Name:find("Act_") then
                        d.BackgroundColor3 = T.Card
                    end
                end
            end)
        end
        function M.set(on)
            on = on and true or false
            if on then
                local ok, err = pcall(build)
                if not ok then
                end
            else
                destroy()
            end
            pcall(function()
                if Config then
                    Config.set("actions_panel_visible", on)
                    Config.set("toggle:Actions Panel", on)
                end
            end)
        end
        function M.isOpen()
            return gui ~= nil and gui.Parent ~= nil and gui.Enabled
        end
        function M.toggle()
            M.set(not M.isOpen())
        end
        return M
    end)()

    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.ActionsPanel and _G.ActionsPanel.set then _G.ActionsPanel.set(false) end
        end)
    end)

    _G.ActionsPanelMobile = (function()
        local gui = nil
        local mainFrame = nil

        local function _resolveGuiParent()
            local candidates = {}
            pcall(function()
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then table.insert(candidates, h) end
                end
            end)
            pcall(function()
                local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                table.insert(candidates, _cr(game:GetService("CoreGui")))
            end)
            pcall(function()
                if GUI and GUI.Parent then table.insert(candidates, GUI.Parent) end
            end)
            pcall(function()
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")
                if pg then table.insert(candidates, pg) end
            end)
            for _, p in ipairs(candidates) do
                if p then
                    local ok = pcall(function()
                        local test = Instance.new("Folder")
                        test.Name = "_CyutsudParentTest"
                        test.Parent = p
                        test:Destroy()
                    end)
                    if ok then return p end
                end
            end
            return LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        end

        local function destroy()
            if gui then
                pcall(function() gui:Destroy() end)
                gui = nil
                mainFrame = nil
            end
            pcall(function()
                local parents = {}
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then table.insert(parents, h) end
                end
                pcall(function()
                    local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                    table.insert(parents, _cr(game:GetService("CoreGui")))
                end)
                local pg = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui"))
                if pg then table.insert(parents, pg) end
                for _, parent in ipairs(parents) do
                    local old = parent:FindFirstChild("PanelGui_ActionsMobile")
                    if old then pcall(function() old:Destroy() end) end
                end
            end)
        end

        local function build()
            destroy()

            local parent = _resolveGuiParent()
            if not parent then
                return nil
            end

            gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_ActionsMobile"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999998
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = true

            pcall(function()
                if type(protect_gui) == "function" then
                    protect_gui(gui)
                elseif syn and syn.protect_gui then
                    syn.protect_gui(gui)
                end
            end)

            local okParent, errParent = pcall(function()
                gui.Parent = parent
            end)
            if not okParent or not gui.Parent then
                pcall(function()
                    local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                    if pg then gui.Parent = pg end
                end)
            end
            if not gui.Parent then
                pcall(function() gui:Destroy() end)
                gui = nil
                return nil
            end

            mainFrame = Instance.new("Frame")
            mainFrame.Name = "Frame"
            mainFrame.Size = UDim2.new(0, 140, 0, 260)
            mainFrame.AnchorPoint = Vector2.new(0, 0.5)
            mainFrame.Position = UDim2.new(0, 8, 0.5, 0) -- left side mobile
            mainFrame.BackgroundColor3 = T.Bg
            mainFrame.BackgroundTransparency = 0.02
            mainFrame.BorderSizePixel = 0
            mainFrame.Active = true
            mainFrame.ClipsDescendants = false
            mainFrame.ZIndex = 10
            mainFrame.Visible = true
            mainFrame.Parent = gui
            pcall(function() trackBgFrame(mainFrame, "Bg") end)
            Corner(mainFrame, 14)
            pcall(function() GradStroke(mainFrame, 1.6, 0.25, 90) end)

            local shadow = Instance.new("ImageLabel")
            shadow.Name = "Shadow"
            shadow.Size = UDim2.new(1, 40, 1, 40)
            shadow.Position = UDim2.new(0, -20, 0, -20)
            shadow.BackgroundTransparency = 1
            shadow.Image = "rbxassetid://5028857084"
            shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            shadow.ImageTransparency = 0.5
            shadow.ScaleType = Enum.ScaleType.Slice
            shadow.SliceCenter = Rect.new(24, 24, 276, 276)
            shadow.ZIndex = 9
            shadow.Parent = mainFrame

            pcall(function()
                local loadedSize = false
                if loadGuiSize then
                    loadedSize = loadGuiSize("PanelGui_ActionsMobile", mainFrame, 120, 180)
                end
                if not loadedSize then
                    local s = Config.get("actions_panel_mobile_size", nil)
                    if type(s) == "table" and s[1] and s[2] and s[1] > 80 and s[2] > 80 then
                        local w = math.clamp(tonumber(s[1]) or 140, 120, 240)
                        local h = math.clamp(tonumber(s[2]) or 260, 180, 420)
                        mainFrame.Size = UDim2.new(0, w, 0, h)
                    end
                end
                local loadedPos = false
                if loadGuiPosition then
                    loadedPos = loadGuiPosition("PanelGui_ActionsMobile", mainFrame)
                    if loadedPos then
                        mainFrame.AnchorPoint = Vector2.new(0, 0)
                    end
                end
                if not loadedPos then
                    local p = Config.get("actions_panel_mobile_pos", nil)
                    if type(p) == "table" and #p >= 4 then
                        mainFrame.AnchorPoint = Vector2.new(0, 0)
                        mainFrame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                        if saveGuiPosition then
                            saveGuiPosition("PanelGui_ActionsMobile", mainFrame)
                        end
                    end
                end
            end)

            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 22)
            titleBar.BackgroundColor3 = T.BgDeep
            titleBar.BackgroundTransparency = 0.05
            titleBar.BorderSizePixel = 0
            titleBar.ZIndex = 12
            titleBar.Active = true
            titleBar.Parent = mainFrame
            pcall(function() trackBgFrame(titleBar, "BgDeep") end)
            Corner(titleBar, 12)
            local titleFill = Instance.new("Frame")
            titleFill.Size = UDim2.new(1, 0, 0, 10)
            titleFill.Position = UDim2.new(0, 0, 1, -10)
            titleFill.BackgroundColor3 = T.BgDeep
            titleFill.BackgroundTransparency = 0.05
            titleFill.BorderSizePixel = 0
            titleFill.ZIndex = 12
            titleFill.Parent = titleBar
            pcall(function() trackBgFrame(titleFill, "BgDeep") end)
            local accent = Instance.new("Frame")
            accent.Name = "HubAccent"
            accent.Size = UDim2.new(1, 0, 0, 2)
            accent.Position = UDim2.new(0, 0, 1, -2)
            accent.BackgroundColor3 = Theme.c1
            accent.BorderSizePixel = 0
            accent.ZIndex = 14
            accent.Parent = titleBar
            pcall(function() trackSolid(accent, 1) end)

            local title = Lbl(titleBar, "Actions Mobile", 11, T.Text, Enum.Font.GothamBold)
            title.Size = UDim2.new(1, -90, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.TextYAlignment = Enum.TextYAlignment.Center
            title.ZIndex = 13

            local function makeIconBtn(txt, xOff)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0, 16, 0, 16)
                b.Position = UDim2.new(1, xOff, 0.5, -9)
                b.BackgroundColor3 = T.BgDeep
                b.BorderSizePixel = 0
                b.Text = txt
                b.Font = Enum.Font.GothamBold
                b.TextSize = 12
                b.TextColor3 = T.TextDim
                b.AutoButtonColor = false
                b.ZIndex = 14
                b.Parent = titleBar
                Corner(b, 12)
                pcall(function() trackBgFrame(b, "BgDeep") end)
                b.MouseEnter:Connect(function()
                    Tween(b, F, {BackgroundColor3 = T.CardHover, TextColor3 = T.Text})
                end)
                b.MouseLeave:Connect(function()
                    Tween(b, F, {BackgroundColor3 = T.BgDeep, TextColor3 = T.TextDim})
                end)
                return b
            end

            local minBtn = makeIconBtn("–", -42)
            local closeBtn = makeIconBtn("×", -22)

            local content = Instance.new("ScrollingFrame")
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 1, -22)
            content.Position = UDim2.new(0, 0, 0, 22)
            content.BackgroundTransparency = 1
            content.BorderSizePixel = 0
            content.ScrollBarThickness = 3
            content.ScrollBarImageColor3 = T.White
            content.ScrollBarImageTransparency = 0.25
            content.CanvasSize = UDim2.new(0, 0, 0, 0)
            content.AutomaticCanvasSize = Enum.AutomaticSize.Y
            content.ScrollingDirection = Enum.ScrollingDirection.Y
            content.ZIndex = 11
            content.Visible = true
            content.Parent = mainFrame
            local list = Instance.new("UIListLayout")
            list.FillDirection = Enum.FillDirection.Vertical
            list.HorizontalAlignment = Enum.HorizontalAlignment.Center
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Padding = UDim.new(0, 3)
            list.Parent = content
            Pad(content, 4, 6, 6, 6)

            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, -4, 0, 16)
            sec.BackgroundTransparency = 1
            sec.LayoutOrder = 0
            sec.Parent = content
            local secLbl = Lbl(sec, "QUICK ACTIONS", 10, T.TextDim, Enum.Font.GothamBold)
            secLbl.Size = UDim2.new(1, -4, 1, 0)
            secLbl.Position = UDim2.new(0, 2, 0, 0)
            secLbl.TextYAlignment = Enum.TextYAlignment.Center

            local buttonLabels = {
                { "Rejoin",             "Rejoin server" },
                { "Kick Self",          "Leave game" },
                { "Ragdoll Self",       "Self ragdoll" },
                { "Instant Reset",      "Force reset" },
                { "UP+TP",              "Up fly + TP" },
                { "Ragdoll tech",       "Giant + ragdoll" },
                { "Ragdoll Tech Duel",  "Giant + Heatseeker" },
            }

            for i, entry in ipairs(buttonLabels) do
                local label, sub = entry[1], entry[2]
                local card = Instance.new("Frame")
                card.Name = "Act_" .. label:gsub("%W", "_")
                if (label == "Ragdoll Self" or label == "Ragdoll tech") and _G._CyutsudAllGearHideRagdoll then
                    card.Visible = false
                end
                card.Size = UDim2.new(1, -4, 0, 34)
                card.BackgroundColor3 = T.Card
                card.BorderSizePixel = 0
                card.LayoutOrder = i
                card.ZIndex = 12
                card.Parent = content
                pcall(function() trackBgFrame(card, "Card") end)
                Corner(card, 10)
                local cStroke = Stroke(card, T.Line, 1, 0.25)

                local nameLbl = Lbl(card, label, 11, T.Text, Enum.Font.GothamBold)
                nameLbl.Size = UDim2.new(1, -14, 0, 16)
                nameLbl.Position = UDim2.new(0, 10, 0, 4)
                nameLbl.ZIndex = 13

                local subLbl = Lbl(card, sub, 9, T.TextDim, Enum.Font.Gotham)
                subLbl.Size = UDim2.new(1, -14, 0, 12)
                subLbl.Position = UDim2.new(0, 10, 0, 22)
                subLbl.ZIndex = 13

                local accent = Instance.new("Frame")
                accent.Size = UDim2.new(0, 3, 0, 22)
                accent.Position = UDim2.new(0, 3, 0.5, -11)
                accent.BackgroundColor3 = Theme.c1
                accent.BackgroundTransparency = 0.35
                accent.BorderSizePixel = 0
                accent.ZIndex = 13
                accent.Parent = card
                Corner(accent, 12)
                pcall(function() trackSolid(accent, 1) end)

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.ZIndex = 15
                btn.Parent = card

                local function onEnter()
                    Tween(card, F, {BackgroundColor3 = T.CardHover})
                    Tween(cStroke, F, {Transparency = 0.05})
                    Tween(accent, F, {BackgroundTransparency = 0})
                end
                local function onLeave()
                    Tween(card, F, {BackgroundColor3 = T.Card})
                    Tween(cStroke, F, {Transparency = 0.25})
                    Tween(accent, F, {BackgroundTransparency = 0.35})
                end
                card.MouseEnter:Connect(onEnter)
                card.MouseLeave:Connect(onLeave)
                btn.MouseEnter:Connect(onEnter)
                btn.MouseLeave:Connect(onLeave)

                local function fire()
                    if _G._CyutsudAllGearBlockActions and _G._CyutsudAllGearBlockActions[label] then
                        return
                    end
                    local action = ACTIONS[label]
                    if action then
                        Tween(card, F, {BackgroundColor3 = Theme.c1})
                        task.delay(0.12, function()
                            if card and card.Parent then
                                Tween(card, M, {BackgroundColor3 = T.CardHover})
                            end
                        end)
                        pcall(action)
                        pcall(function() if showToast then showToast(label, true) end end)
                    end
                end
                btn.Activated:Connect(fire)
                btn.MouseButton1Click:Connect(fire)
                pcall(function()
                    if attachKeybind then
                        attachKeybind(btn, nameLbl, label, fire)
                    end
                end)
            end

            pcall(function()
                local drag = _G.makePanelDraggable or makePanelDraggable
                if drag then drag(titleBar, mainFrame, "PanelGui_ActionsMobile") end
            end)
            pcall(function()
                local lastSave = 0
                local function mirrorPos()
                    if not mainFrame or not mainFrame.Parent then return end
                    local now = tick()
                    if now - lastSave < 0.15 then return end
                    lastSave = now
                    local pos = {
                        mainFrame.Position.X.Scale, mainFrame.Position.X.Offset,
                        mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset,
                    }
                    if Config then
                        Config.set("actions_panel_mobile_pos", pos)
                        if saveGuiPosition then
                            saveGuiPosition("PanelGui_ActionsMobile", mainFrame)
                        end
                        if saveGuiSize then
                            saveGuiSize("PanelGui_ActionsMobile", mainFrame)
                        end
                        if Config.flush then Config.flush() end
                    end
                end
                if titleBar then
                    titleBar.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1
                            or inp.UserInputType == Enum.UserInputType.Touch then
                            task.defer(mirrorPos)
                        end
                    end)
                end
                local UIS = game:GetService("UserInputService")
                UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                        task.defer(mirrorPos)
                    end
                end)
            end)

            local minimized = false
            local originalSize = mainFrame.Size
            local collapsedY = 28
            minBtn.Activated:Connect(function()
                minimized = not minimized
                content.Visible = not minimized
                if minimized then
                    mainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, collapsedY)
                    minBtn.Text = "+"
                else
                    mainFrame.Size = originalSize
                    minBtn.Text = "–"
                end
            end)
            minBtn.MouseButton1Click:Connect(function() end) -- ensure clickable

            closeBtn.Activated:Connect(function()
                _G.ActionsPanel.set(false)
                pcall(function()
                    if _G._CyutsudSetToggleUI then
                        _G._CyutsudSetToggleUI("Actions Panel", false, true)
                    end
                end)
            end)
            closeBtn.MouseButton1Click:Connect(function()
                _G.ActionsPanel.set(false)
                pcall(function()
                    if _G._CyutsudSetToggleUI then
                        _G._CyutsudSetToggleUI("Actions Panel", false, true)
                    end
                end)
            end)

            return gui
        end

        local M = {}
        function M.repaint()
            pcall(function()
                if not mainFrame or not mainFrame.Parent then return end
                mainFrame.BackgroundColor3 = T.Bg
                for _, d in ipairs(mainFrame:GetDescendants()) do
                    if d:IsA("UIGradient") then
                        d.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Theme.c1),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                        })
                    end
                    if d:IsA("Frame") and (d.Name == "Badge" or d.Name:find("Accent")) then
                        d.BackgroundColor3 = Theme.c1
                    end
                    if d:IsA("Frame") and d.Name:find("Act_") then
                        d.BackgroundColor3 = T.Card
                    end
                end
            end)
        end
        function M.set(on)
            on = on and true or false
            if on then
                local ok, err = pcall(build)
                if not ok then
                end
            else
                destroy()
            end
            pcall(function()
                if Config then
                    Config.set("actions_panel_mobile_visible", on)
                    Config.set("toggle:Actions Panel Mobile", on)
                end
            end)
        end
        function M.isOpen()
            return gui ~= nil and gui.Parent ~= nil and gui.Enabled
        end
        function M.toggle()
            M.set(not M.isOpen())
        end
        function M.setVisible(v)
            M.set(v and true or false)
        end
        return M
    end)()


    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.ActionsPanelMobile and _G.ActionsPanelMobile.set then _G.ActionsPanelMobile.set(false) end
        end)
    end)

    _G.LeaveOnSteal = (function()
        local STEAL_KEYWORD = "you stole"
        local STEAL_KICK_MSG = "Auto Kick on steal"
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local enabled = false
        local conns = {}
        local kicked = false

        local function hasStealText(text)
            if typeof(text) ~= "string" then return false end
            local low = string.lower(text)
            if string.find(low, STEAL_KEYWORD, 1, true) then return true end
            if string.find(low, "you stole", 1, true) then return true end
            if string.find(low, "stole a", 1, true) then return true end
            return false
        end

        local function kickOnSteal()
            if not enabled or kicked then return end
            kicked = true
            pcall(function()
                if showToast then showToast("Leave on Steal: kicking…", true) end
            end)
            pcall(function()
                player:Kick(STEAL_KICK_MSG)
            end)
        end

        local function watchObject(obj)
            if not obj then return end
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if hasStealText(obj.Text) then
                    kickOnSteal()
                    return
                end
                local c = obj:GetPropertyChangedSignal("Text"):Connect(function()
                    if hasStealText(obj.Text) then
                        kickOnSteal()
                    end
                end)
                table.insert(conns, c)
            end
        end

        local function setupGuiWatcher(gui)
            if not gui then return end
            local c = gui.DescendantAdded:Connect(function(desc)
                watchObject(desc)
            end)
            table.insert(conns, c)
        end

        local function scanAll(parent)
            if not parent then return end
            for _, obj in ipairs(parent:GetDescendants()) do
                watchObject(obj)
            end
        end

        local function start()
            for i = 1, #conns do
                pcall(function() conns[i]:Disconnect() end)
            end
            conns = {}
            enabled = true
            kicked = false
            for _, gui in ipairs(playerGui:GetChildren()) do
                setupGuiWatcher(gui)
                scanAll(gui)
            end
            local c = playerGui.ChildAdded:Connect(function(gui)
                setupGuiWatcher(gui)
                scanAll(gui)
            end)
            table.insert(conns, c)
            scanAll(playerGui)
        end

        local function stop()
            enabled = false
            for i = 1, #conns do
                pcall(function() conns[i]:Disconnect() end)
            end
            conns = {}
        end

        local M = {}
        function M.set(on)
            if on then
                start()
            else
                stop()
            end
        end
        function M.isEnabled()
            return enabled
        end
        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.LeaveOnSteal and _G.LeaveOnSteal.set then _G.LeaveOnSteal.set(false) end
        end)
    end)

    _G.FPSBooster = (function()
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer

        local M = {
            enabled = false,
            conn = nil,
            backup = {},
        }

        local function isPlayerHairOrFace(obj)
            if obj:IsA("Accessory") then
                local char = LP.Character
                if char and obj:IsDescendantOf(char) then
                    local accessoryType = obj.AccessoryType
                    if accessoryType == Enum.AccessoryType.Hair
                        or accessoryType == Enum.AccessoryType.Face then
                        return true
                    end
                end
            end
            return false
        end

        local function applyOptimization(obj)
            pcall(function()
                if obj:IsA("Accessory") or obj:IsA("Hat") then
                    if isPlayerHairOrFace(obj) then return end
                    obj:Destroy()
                elseif obj:IsA("BasePart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
                    or obj:IsA("Beam") or obj:IsA("Fire")
                    or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
                    for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
                        pcall(function() t:Stop(0) end)
                    end
                end
            end)
        end

        local function saveLighting()
            M.backup.brightness = Lighting.Brightness
            M.backup.clockTime = Lighting.ClockTime
            M.backup.outdoorAmbient = Lighting.OutdoorAmbient
            M.backup.globalShadows = Lighting.GlobalShadows
            M.backup.fogEnd = Lighting.FogEnd
            M.backup.envDiffuse = Lighting.EnvironmentDiffuseScale
            M.backup.envSpecular = Lighting.EnvironmentSpecularScale
        end

        local function restoreLighting()
            pcall(function()
                Lighting.Brightness = M.backup.brightness or 1
                Lighting.ClockTime = M.backup.clockTime or 14
                Lighting.OutdoorAmbient = M.backup.outdoorAmbient or Color3.fromRGB(128, 128, 128)
                Lighting.GlobalShadows = (M.backup.globalShadows ~= false)
                Lighting.FogEnd = M.backup.fogEnd or 100000
                Lighting.EnvironmentDiffuseScale = M.backup.envDiffuse or 1
                Lighting.EnvironmentSpecularScale = M.backup.envSpecular or 1
            end)
        end

        local function enable()
            if M.enabled then return end
            M.enabled = true
            saveLighting()

            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0

            for _, e in pairs(Lighting:GetChildren()) do
                pcall(function()
                    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
                        or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect")
                        or e:IsA("DepthOfFieldEffect") then
                        e.Enabled = false
                    end
                end)
            end

            task.spawn(function()
                local n = 0
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not M.enabled then break end
                    applyOptimization(obj)
                    n = n + 1
                    if n % 200 == 0 then task.wait() end
                end
            end)

            if M.conn then pcall(function() M.conn:Disconnect() end) end
            M.conn = Workspace.DescendantAdded:Connect(function(obj)
                if M.enabled then applyOptimization(obj) end
            end)
        end

        local function disable()
            if not M.enabled then return end
            M.enabled = false
            if M.conn then
                pcall(function() M.conn:Disconnect() end)
                M.conn = nil
            end
            restoreLighting()
        end

        function M.set(on)
            if on then
                enable()
            else
                disable()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.FPSBooster and _G.FPSBooster.set then _G.FPSBooster.set(false) end
        end)
    end)

    _G.GameStretcher = (function()
        local RunService = game:GetService("RunService")
        local M = {
            enabled = false,
            originalFOV = nil,
            stretchConn = nil,
            stretchFactor = 0.75,
            targetFOV = 70,
            stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.75, 0, 0, 0, 1),
        }

        local function applyStretch()
            if not M.enabled then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            pcall(function()
                cam.CFrame = cam.CFrame * M.stretchCFrame
                local targetFov = M.targetFOV or 70
                if math.abs(cam.FieldOfView - targetFov) > 0.05 then
                    cam.FieldOfView = targetFov
                end
            end)
        end

        local function enable()
            if M.enabled then return end
            M.enabled = true
            local cam = workspace.CurrentCamera
            if cam then
                M.originalFOV = cam.FieldOfView
            end
            pcall(function()
                RunService:BindToRenderStep("FH_GameStretch", Enum.RenderPriority.Camera.Value + 1, applyStretch)
            end)
            if not M.stretchConn then
                M.stretchConn = RunService.RenderStepped:Connect(function()
                    if M.enabled then applyStretch() end
                end)
            end
            pcall(function()
                if Config then
                    Config.set("toggle:Game Stretcher", true)
                    Config.set("gameStretcherFactor", M.stretchFactor)
                end
            end)
        end

        local function disable()
            if not M.enabled then return end
            M.enabled = false
            pcall(function()
                RunService:UnbindFromRenderStep("FH_GameStretch")
            end)
            if M.stretchConn then
                pcall(function() M.stretchConn:Disconnect() end)
                M.stretchConn = nil
            end
            local cam = workspace.CurrentCamera
            if cam and M.originalFOV then
                pcall(function() cam.FieldOfView = M.originalFOV end)
            end
            pcall(function()
                if Config then Config.set("toggle:Game Stretcher", false) end
            end)
        end

        function M.set(on)
            if on then enable() else disable() end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.setFactor(factor)
            factor = tonumber(factor) or 0.75
            factor = math.clamp(factor, 0.1, 1.5)
            M.stretchFactor = factor
            M.stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, factor, 0, 0, 0, 1)
            pcall(function()
                if Config then
                    Config.set("gameStretcherFactor", factor)
                    if Config.flush then Config.flush() end
                end
            end)
        end

        function M.setFOV(fov)
            fov = tonumber(fov) or 70
            fov = math.clamp(fov, 60, 120)
            M.targetFOV = fov
            pcall(function()
                if Config then
                    Config.set("cameraFOV", fov)
                    if Config.flush then Config.flush() end
                end
            end)
            if not M.enabled then
                local cam = workspace.CurrentCamera
                if cam then
                    pcall(function() cam.FieldOfView = fov end)
                end
            end
        end

        function M.getFactor()
            return M.stretchFactor
        end

        function M.getFOV()
            return M.targetFOV
        end

        task.defer(function()
            pcall(function()
                if not Config then return end
                local saved = tonumber(Config.get("gameStretcherFactor", nil) or Config.get("slider:Stretch Factor", 0.75)) or 0.75
                M.setFactor(saved)
                local savedFov = tonumber(Config.get("cameraFOV", nil) or Config.get("slider:Camera FOV", 70)) or 70
                M.setFOV(savedFov)
            end)
        end)

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.GameStretcher and _G.GameStretcher.set then _G.GameStretcher.set(false) end
        end)
    end)

    _G.APESP = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        local M = { enabled = false }
        local backpackEsp = {}
        local apEsp = {}
        local loopConn = nil
        local _acc = 0

        local function clearBP()
            for uid, bb in pairs(backpackEsp) do
                pcall(function() bb:Destroy() end)
                backpackEsp[uid] = nil
            end
        end

        local function clearAP()
            for uid, bb in pairs(apEsp) do
                pcall(function() bb:Destroy() end)
                apEsp[uid] = nil
            end
        end

        local function buildBPBillboard(char, hrp, found)
            local count = #found
            local ICON, GAP = 48, 4
            local bb = Instance.new("BillboardGui")
            bb.Name = "_BackpackESP"
            bb.Size = UDim2.new(0, ICON, 0, ICON * count + GAP * math.max(count - 1, 0))
            bb.StudsOffset = Vector3.new(3.5, 0, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = hrp
            bb.MaxDistance = 200
            bb.Parent = char
            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Vertical
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.Padding = UDim.new(0, GAP)
            layout.Parent = bb
            for i = 1, #found do
                local data = found[i]
                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(0, ICON, 0, ICON)
                img.BackgroundTransparency = 1
                img.Image = (data.texture and data.texture ~= "") and data.texture or "rbxassetid://0"
                img.ScaleType = Enum.ScaleType.Fit
                img.Parent = bb
            end
            return bb
        end

        local function updateBP()
            if not M.enabled then
                if next(backpackEsp) then clearBP() end
                return
            end
            local active = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local char = p.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        active[p.UserId] = true
                        local found = {}
                        local bp = p:FindFirstChild("Backpack")
                        if bp then
                            for _, tool in ipairs(bp:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name == "Flash Teleport" then
                                    found[#found + 1] = {
                                        name = tool.Name,
                                        texture = tool.TextureId or "",
                                    }
                                end
                            end
                        end
                        if char then
                            local eq = char:FindFirstChild("Flash Teleport")
                            if eq and eq:IsA("Tool") then
                                found[#found + 1] = {
                                    name = eq.Name,
                                    texture = eq.TextureId or "",
                                }
                            end
                        end
                        if #found == 0 then
                            if backpackEsp[p.UserId] then
                                pcall(function() backpackEsp[p.UserId]:Destroy() end)
                                backpackEsp[p.UserId] = nil
                            end
                        else
                            local existing = backpackEsp[p.UserId]
                            local need = not existing or existing.Parent == nil or existing.Adornee ~= hrp
                            if need then
                                if existing then pcall(function() existing:Destroy() end) end
                                backpackEsp[p.UserId] = buildBPBillboard(char, hrp, found)
                            end
                        end
                    end
                end
            end
            for uid, bb in pairs(backpackEsp) do
                if not active[uid] then
                    pcall(function() bb:Destroy() end)
                    backpackEsp[uid] = nil
                end
            end
        end

        local function updateAP()
            if not M.enabled then
                if next(apEsp) then clearAP() end
                return
            end
            local active = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local char = p.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        active[p.UserId] = true
                        local hasAP = false
                        pcall(function()
                            hasAP = p:GetAttribute("AdminCommands") ~= nil
                        end)
                        if not hasAP then
                            if apEsp[p.UserId] then
                                pcall(function() apEsp[p.UserId]:Destroy() end)
                                apEsp[p.UserId] = nil
                            end
                        elseif not apEsp[p.UserId] or not apEsp[p.UserId].Parent then
                            if apEsp[p.UserId] then pcall(function() apEsp[p.UserId]:Destroy() end) end
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "_APESP"
                            bb.Size = UDim2.new(0, 52, 0, 52)
                            bb.StudsOffset = Vector3.new(3.5, 7, 0)
                            bb.AlwaysOnTop = true
                            bb.Adornee = hrp
                            bb.MaxDistance = 200
                            bb.Parent = char
                            local img = Instance.new("ImageLabel")
                            img.Size = UDim2.new(1, 0, 1, 0)
                            img.BackgroundTransparency = 1
                            img.Image = "rbxassetid://95529031547606"
                            img.ScaleType = Enum.ScaleType.Fit
                            img.Parent = bb
                            apEsp[p.UserId] = bb
                        else
                            apEsp[p.UserId].Adornee = hrp
                        end
                    end
                end
            end
            for uid, bb in pairs(apEsp) do
                if not active[uid] then
                    pcall(function() bb:Destroy() end)
                    apEsp[uid] = nil
                end
            end
        end

        local function start()
            if loopConn then return end
            _G.BackpackESP = true
            _G.ShowAPESP = true
            _G.ShowFlashTeleport = true
            pcall(updateBP)
            pcall(updateAP)
            _acc = 0
            loopConn = RunService.Heartbeat:Connect(function(dt)
                if not M.enabled then return end
                _acc = _acc + (dt or 0.016)
                if _acc < 0.25 then return end
                _acc = 0
                pcall(updateBP)
                pcall(updateAP)
            end)
        end

        local function stop()
            if loopConn then
                pcall(function() loopConn:Disconnect() end)
                loopConn = nil
            end
            clearBP()
            clearAP()
            _G.BackpackESP = false
            _G.ShowAPESP = false
            _G.ShowFlashTeleport = false
        end

        function M.set(state)
            M.enabled = state and true or false
            if M.enabled then
                start()
            else
                stop()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.applyTheme() end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.APESP and _G.APESP.set then _G.APESP.set(false) end
        end)
    end)

    Aimbot = (function()
        local services = {
            players = game:GetService("Players"),
            replicated = game:GetService("ReplicatedStorage"),
            uis = game:GetService("UserInputService"),
        }
        local lp = services.players.LocalPlayer

        local M = {
            active = false,
            TOOLS = { "Web Slinger", "Laser Cape", "Paintball Gun" },
            DIST = 800,
            conns = {},
            curChar = nil,
            remIndex = {},
            remObjs = {},
            targetChar = nil,
            targetPart = nil,
            cachedUseItem = nil,
        }

        function M.findUseItemOnce()
            if M.cachedUseItem and M.cachedUseItem.Parent then
                return M.cachedUseItem
            end
            M.cachedUseItem = nil
            local net = services.replicated:FindFirstChild("Packages")
            if net then net = net:FindFirstChild("Net") end
            if not net then return nil end

            for _, child in ipairs(net:GetChildren()) do
                if child:IsA("RemoteEvent") then
                    local ok, cs = pcall(function()
                        if type(getconnections) == "function" then
                            return getconnections(child.OnClientEvent)
                        end
                        return nil
                    end)
                    if ok and cs then
                        for _, c in ipairs(cs) do
                            if type(c.Function) == "function" then
                                local ok2, consts = pcall(function()
                                    if debug and debug.getconstants then
                                        return debug.getconstants(c.Function)
                                    end
                                    return nil
                                end)
                                if ok2 and consts then
                                    for _, k in ipairs(consts) do
                                        if k == "PaintballHitted" then
                                            M.cachedUseItem = child
                                            return child
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            for _, child in ipairs(net:GetChildren()) do
                if child:IsA("RemoteEvent") and child.Name:find("UseItem", 1, true) then
                    M.cachedUseItem = child
                    return child
                end
            end
            return nil
        end

        function M.initRems()
            local ok, children = pcall(function()
                return services.replicated:WaitForChild("Packages", 3):WaitForChild("Net", 3):GetChildren()
            end)
            if not ok or not children then return end

            M.remIndex = {}
            M.remObjs = {}
            for i, obj in ipairs(children) do
                if obj:IsA("RemoteEvent") then
                    local nextObj = children[i + 1]
                    if nextObj then
                        M.remIndex[obj.Name] = i + 1
                        M.remObjs[i + 1] = nextObj
                    end
                end
            end
            M.findUseItemOnce()
        end

        function M.fireRem(name, ...)
            local args = table.pack(...)
            if name == "RE/UseItem" or name == "UseItem" then
                local r = M.findUseItemOnce()
                if r then
                    pcall(function()
                        r:FireServer(table.unpack(args, 1, args.n))
                    end)
                    return true
                end
            end

            local idx = M.remIndex[name]
            if idx and M.remObjs[idx] then
                pcall(function()
                    M.remObjs[idx]:FireServer(table.unpack(args, 1, args.n))
                end)
                return true
            end
            return false
        end

        function M.getChar()
            local c = lp and lp.Character
            if c then M.curChar = c end
            return c
        end

        function M.getTool()
            local c = M.getChar()
            if not c then return nil end
            return c:FindFirstChildOfClass("Tool")
        end

        function M.hasTool()
            local tool = M.getTool()
            if not tool then return false end
            for _, name in pairs(M.TOOLS) do
                if tool.Name == name then return true end
            end
            return false
        end

        function M.isAlive(char)
            if not char then return false end
            local hum = char:FindFirstChildOfClass("Humanoid")
            return hum and hum.Health > 0
        end

        function M.updateTarget()
            while M.active do
                local c = M.getChar()
                local hrp = c and c:FindFirstChild("HumanoidRootPart")

                if hrp then
                    local closest = nil
                    local shortest = M.DIST

                    for _, player in ipairs(services.players:GetPlayers()) do
                        if player ~= lp then
                            local char = player.Character
                            if char and M.isAlive(char) then
                                local tHRP = char:FindFirstChild("HumanoidRootPart")
                                if tHRP then
                                    local d = (tHRP.Position - hrp.Position).Magnitude
                                    if d < shortest then
                                        shortest = d
                                        closest = char
                                    end
                                end
                            end
                        end
                    end

                    if closest then
                        M.targetChar = closest
                        M.targetPart = closest:FindFirstChild("Head")
                            or closest:FindFirstChild("HumanoidRootPart")
                            or closest:FindFirstChild("Torso")
                    else
                        M.targetChar = nil
                        M.targetPart = nil
                    end
                else
                    M.targetChar = nil
                    M.targetPart = nil
                end
                task.wait(0.1)
            end
        end

        function M.shoot()
            if not M.hasTool() or not M.targetChar or not M.targetPart then return false end
            if not M.isAlive(M.targetChar) then return false end

            local pos = M.targetPart.Position + Vector3.new(0, 0.5, 0)

            if not M.cachedUseItem then
                M.initRems()
            end

            local ok = M.fireRem("RE/UseItem", pos, M.targetPart)
            if not ok then
                M.initRems()
                ok = M.fireRem("RE/UseItem", pos, M.targetPart)
            end

            return ok
        end

        function M.tryShoot()
            if not M.active or not M.hasTool() then return end
            M.shoot()
        end

        function M.hookTool(tool)
            if not tool then return end
            local c = tool.Activated:Connect(M.tryShoot)
            table.insert(M.conns, c)
        end

        function M.setupChar(char)
            M.curChar = char
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then M.hookTool(tool) end

            local c = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then M.hookTool(child) end
            end)
            table.insert(M.conns, c)
        end

        function M.stop()
            M.active = false
            for _, c in ipairs(M.conns) do
                pcall(function() c:Disconnect() end)
            end
            M.conns = {}
            M.curChar = nil
            M.targetChar = nil
            M.targetPart = nil
        end

        function M.start()
            if M.active then return end
            M.active = true
            M.initRems()

            local input = services.uis.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    M.tryShoot()
                end
            end)
            table.insert(M.conns, input)

            if lp.Character then
                M.setupChar(lp.Character)
            end

            local charAdded = lp.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                if M.active then M.setupChar(char) end
            end)
            table.insert(M.conns, charAdded)

            task.spawn(M.updateTarget)
        end

        function M.set(on)
            if on then
                M.start()
            else
                M.stop()
            end
        end

        function M.isEnabled()
            return M.active
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if Aimbot and Aimbot.stop then Aimbot.stop() end
        end)
    end)

    _G.DefensePanel = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local player = Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")

        local state = {
            panelOpen = false,
            autoDefense = false,
            safetyKick = false,
            autoDrop = false,
        }

        local gui, mainFrame
        local autoDefenseEnabled = false
        local autoKickOnStealEnabled = false
        local useBalloon = true
        local BALLOON_COOLDOWN = 0.15
        local SAFETY_KICK_MSG = "Safety Kick"
        local _safetyKickBusy = false
        local _myPlot = nil
        local cooldowns, wasSteal = {}, {}
        local _defConn = nil
        local _screenBalloonConn = nil
        local _screenBalloonSeen = {}
        local function themePrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end

        local function findMyPlot()
            if _myPlot and _myPlot.Parent then return _myPlot end
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return nil end
            local pn = string.lower(player.Name or "")
            local dn = string.lower(player.DisplayName or "")
            for _, plot in ipairs(plots:GetChildren()) do
                local sign = plot:FindFirstChild("PlotSign")
                if sign then
                    local yb = sign:FindFirstChild("YourBase")
                    if yb and yb:IsA("BillboardGui") and yb.Enabled then
                        _myPlot = plot
                        return plot
                    end
                    local label = sign:FindFirstChildWhichIsA("TextLabel", true)
                    if label and label.Text then
                        local t = string.lower(label.Text)
                        if (pn ~= "" and t:find(pn, 1, true)) or (dn ~= "" and t:find(dn, 1, true)) then
                            _myPlot = plot
                            return plot
                        end
                    end
                end
            end
            return nil
        end

        local _hitboxCache, _hitboxCacheAt = nil, 0
        local _bbCache, _bbCacheAt = nil, 0

        local function getPlotHitbox(plot)
            local now = tick()
            if _hitboxCache and _hitboxCache.Parent and (now - _hitboxCacheAt) < 3 then
                return _hitboxCache
            end
            local hitbox = plot:FindFirstChild("StealHitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                _hitboxCache, _hitboxCacheAt = hitbox, now
                return hitbox
            end
            _hitboxCache, _hitboxCacheAt = nil, now
            return nil
        end

        local function getPlotBounds(plot)
            local now = tick()
            if _bbCache and _bbCache.plot == plot and (now - _bbCacheAt) < 2 then
                return _bbCache.cf, _bbCache.size
            end
            local ok, cf, size = pcall(function() return plot:GetBoundingBox() end)
            if not ok or not cf then return nil, nil end
            _bbCache = { plot = plot, cf = cf, size = size }
            _bbCacheAt = now
            return cf, size
        end

        local function isInMyBase(p)
            local plot = findMyPlot()
            if not plot then return false end
            local char = p.Character
            if not char then return false end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return false end
            local hitbox = getPlotHitbox(plot)
            if hitbox then
                local lp = hitbox.CFrame:PointToObjectSpace(root.Position)
                return math.abs(lp.X) <= hitbox.Size.X * 0.5
                    and math.abs(lp.Z) <= hitbox.Size.Z * 0.5
            end
            local cf, size = getPlotBounds(plot)
            if not cf then return false end
            local lp = cf:PointToObjectSpace(root.Position)
            return math.abs(lp.X) <= size.X * 0.5
                and math.abs(lp.Y) <= size.Y * 0.5 + 8
                and math.abs(lp.Z) <= size.Z * 0.5
        end

        local _cachedRemote, _cachedAuth = nil, nil
        local AUTH_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
        local AUTH_GUID_ALT = "f888ee6e-c86d-46e1-93d7-0639d6635d042"
        local RF_GUID_NAME = "RF/a0e78691-cb9b-4efc-ac08-9c06fea70059"

        local function _isUUID(s)
            return type(s) == "string" and #s == 36
                and s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
        end

        local function _findAdminRemote()
            if typeof(_cachedRemote) == "Instance" and _cachedRemote.Parent then
                return _cachedRemote, _cachedAuth
            end
            if typeof(_G._FH_AdminRemote) == "Instance" and _G._FH_AdminRemote.Parent then
                _cachedRemote = _G._FH_AdminRemote
                _cachedAuth = _G._FH_AuthKey
                return _cachedRemote, _cachedAuth
            end

            local cloneRef = (type(cloneref) == "function") and cloneref or function(o) return o end
            local rs = cloneRef(game:GetService("ReplicatedStorage"))
            local netPkg = rs:FindFirstChild("Packages")
            if netPkg then netPkg = netPkg:FindFirstChild("Net") end
            if not netPkg then return nil, nil end

            local children = netPkg:GetChildren()
            for i, o in ipairs(children) do
                if o.Name == RF_GUID_NAME and children[i + 1] then
                    local rem = children[i + 1]
                    if rem:IsA("RemoteFunction") or rem:IsA("RemoteEvent") then
                        _cachedRemote = rem
                        _cachedAuth = AUTH_GUID
                        _G._FH_AdminRemote = rem
                        _G._FH_AuthKey = AUTH_GUID
                        return rem, AUTH_GUID
                    end
                end
            end
            for i = 1, #children - 1 do
                if string.find(children[i].Name, "Tools/Cooldown", 1, true) then
                    local rem = children[i + 1]
                    if rem:IsA("RemoteFunction") or rem:IsA("RemoteEvent") then
                        _cachedRemote = rem
                        _cachedAuth = AUTH_GUID
                        _G._FH_AdminRemote = rem
                        _G._FH_AuthKey = AUTH_GUID
                        return rem, AUTH_GUID
                    end
                end
            end

            local dbgUp = (debug and debug.getupvalues) or getupvalues
            local dbgCon = (debug and debug.getconstants) or getconstants
            if dbgUp and dbgCon then
                local function scanFn(fn)
                    local rem, uid
                    local ok1, ups = pcall(dbgUp, fn)
                    if ok1 and ups then
                        for _, v in pairs(ups) do
                            if typeof(v) == "Instance" and v:IsA("RemoteFunction") and v:IsDescendantOf(netPkg) then
                                rem = v
                            end
                        end
                    end
                    local ok2, cons = pcall(dbgCon, fn)
                    if ok2 and cons then
                        for _, c in pairs(cons) do
                            if _isUUID(c) then uid = c; break end
                        end
                    end
                    if rem and uid then return rem, uid end
                    return nil, nil
                end

                local ctrl = rs:FindFirstChild("Controllers")
                if ctrl then ctrl = ctrl:FindFirstChild("AdminPanelController") end
                if ctrl then
                    local ok, mod = pcall(require, ctrl)
                    if ok and type(mod) == "table" and type(mod.Start) == "function" then
                        local ok2, ups = pcall(dbgUp, mod.Start)
                        if ok2 and ups then
                            for _, v in pairs(ups) do
                                if type(v) == "function" then
                                    local r, u = scanFn(v)
                                    if r and u then
                                        _cachedRemote, _cachedAuth = r, u
                                        _G._FH_AdminRemote, _G._FH_AuthKey = r, u
                                        return r, u
                                    end
                                end
                            end
                        end
                        local r, u = scanFn(mod.Start)
                        if r and u then
                            _cachedRemote, _cachedAuth = r, u
                            _G._FH_AdminRemote, _G._FH_AuthKey = r, u
                            return r, u
                        end
                    end
                end
            end

            return nil, nil
        end

        local function fireAdminCommand(targetPlayer, commandName)
            if not targetPlayer or not commandName then return false end
            local remote, auth = _findAdminRemote()
            auth = auth or AUTH_GUID
            if not remote or not remote.Parent then
                _cachedRemote, _cachedAuth = nil, nil
                remote, auth = _findAdminRemote()
                auth = auth or AUTH_GUID
            end
            if not remote or not remote.Parent then
                return false
            end
            local ok = false
            local function tryInvoke(a)
                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer(a, targetPlayer, commandName)
                    return true
                elseif remote:IsA("RemoteEvent") then
                    remote:FireServer(a, targetPlayer, commandName)
                    return true
                end
                return false
            end
            pcall(function()
                ok = tryInvoke(auth) or false
            end)
            if not ok and AUTH_GUID_ALT then
                pcall(function()
                    ok = tryInvoke(AUTH_GUID_ALT) or false
                end)
            end
            return ok
        end

        local qapCommandCache = {}
        local qapProfileCache = {}

        local function waitForAdminFrames(maxAttempts, delay)
            maxAttempts = maxAttempts or 6
            delay = delay or 0.03
            local LP = game:GetService("Players").LocalPlayer
            for _ = 1, maxAttempts do
                local pg = LP and LP:FindFirstChild("PlayerGui")
                local ap = pg and pg:FindFirstChild("AdminPanel")
                if ap then
                    local inner = ap:FindFirstChild("AdminPanel")
                    local content = inner and inner:FindFirstChild("Content")
                    local profiles = inner and inner:FindFirstChild("Profiles")
                    if content and profiles then
                        local commandFrame = content:FindFirstChild("ScrollingFrame")
                        local profileFrame = profiles:FindFirstChild("ScrollingFrame")
                        if commandFrame and profileFrame then
                            return commandFrame, profileFrame
                        end
                    end
                end
                task.wait(delay)
            end
            return nil, nil
        end

        local function qapCacheActivated(guiObject)
            local cached = {}
            if type(getconnections) ~= "function" then return cached end
            local ok, conns = pcall(getconnections, guiObject.Activated)
            if ok and type(conns) == "table" then
                for _, conn in ipairs(conns) do
                    if type(conn.Function) == "function" then
                        table.insert(cached, conn.Function)
                    end
                end
            end
            pcall(function()
                local ok2, conns2 = pcall(getconnections, guiObject.MouseButton1Click)
                if ok2 and type(conns2) == "table" then
                    for _, conn in ipairs(conns2) do
                        if type(conn.Function) == "function" then
                            table.insert(cached, conn.Function)
                        end
                    end
                end
            end)
            return cached
        end

        local function qapFireActivated(cached)
            if type(cached) ~= "table" then return end
            for _, fn in ipairs(cached) do
                pcall(function() task.spawn(fn) end)
            end
        end

        local function qapIsYellow(c)
            if not c then return false end
            return c.R >= 0.7 and c.G >= 0.55 and c.B <= 0.45
        end

        local function qapLooksSelected(btn)
            if not btn then return false end
            local ok, res = pcall(function()
                if btn:GetAttribute("Selected") == true then return true end
                if btn:GetAttribute("IsSelected") == true then return true end
                local st = btn:FindFirstChildOfClass("UIStroke")
                if st and st.Transparency < 0.6 and qapIsYellow(st.Color) then
                    return true
                end
                if btn:IsA("GuiObject") and (btn.BorderSizePixel or 0) > 0 and qapIsYellow(btn.BorderColor3) then
                    return true
                end
                for _, ch in ipairs(btn:GetDescendants()) do
                    if ch:IsA("UIStroke") and ch.Transparency < 0.6 and qapIsYellow(ch.Color) then
                        return true
                    end
                end
                return false
            end)
            return ok and res or false
        end

        local function qapAnySelected(frame)
            if not frame then return false end
            for _, ch in ipairs(frame:GetChildren()) do
                if ch:IsA("GuiButton") or ch:IsA("TextButton") or ch:IsA("ImageButton") then
                    if qapLooksSelected(ch) then return true end
                end
            end
            return false
        end

        local function qapRunCommand(commandName, target)
            if not target or not commandName then return false end
            commandName = tostring(commandName):lower()

            pcall(function()
                if _G._CyutsudNotifyAdminCommand then
                    _G._CyutsudNotifyAdminCommand(commandName, target)
                end
            end)

            local okUI = false
            pcall(function()
                local commandFrame, profileFrame = waitForAdminFrames(4, 0.2)
                if not commandFrame or not profileFrame then return end

                local profileButton = profileFrame:FindFirstChild(target.Name)
                local commandButton = commandFrame:FindFirstChild(commandName)
                if not profileButton then
                    for _, ch in ipairs(profileFrame:GetChildren()) do
                        if ch.Name == target.Name or ch.Name == target.DisplayName then
                            profileButton = ch
                            break
                        end
                    end
                end
                if not commandButton then
                    for _, ch in ipairs(commandFrame:GetChildren()) do
                        if string.lower(ch.Name) == commandName then
                            commandButton = ch
                            break
                        end
                    end
                end
                if not profileButton or not commandButton then return end

                if not qapProfileCache[target.Name] then
                    qapProfileCache[target.Name] = qapCacheActivated(profileButton)
                end
                if not qapCommandCache[commandName] then
                    qapCommandCache[commandName] = qapCacheActivated(commandButton)
                end

                local playerAlreadySelected = qapAnySelected(profileFrame)
                local commandAlreadySelected = qapAnySelected(commandFrame)

                if commandAlreadySelected and not playerAlreadySelected then
                    qapFireActivated(qapCommandCache[commandName])
                    task.wait(0.01)
                    qapFireActivated(qapProfileCache[target.Name])
                else
                    qapFireActivated(qapProfileCache[target.Name])
                    task.wait(0.01)
                    qapFireActivated(qapCommandCache[commandName])
                end
                okUI = true
            end)
            if okUI then return true end

            return fireAdminCommand(target, commandName)
        end
        _G.qapRunCommand = qapRunCommand
        _G.fireAdminCommand = fireAdminCommand

        -- Auto Defense prioritaires + cooldowns Admin / Command Cooldowns
        local function readAdminCmdTimer(cmdName)
            local sec = nil
            pcall(function()
                local g = playerGui:FindFirstChild("AdminPanel")
                if not g then return end
                local content = g.AdminPanel and g.AdminPanel.Content and g.AdminPanel.Content.ScrollingFrame
                if not content then return end
                local cmdBtn = content:FindFirstChild(cmdName)
                if not cmdBtn then return end
                local timer = cmdBtn:FindFirstChild("Timer")
                if not timer then sec = 0; return end
                if timer:IsA("GuiObject") and not timer.Visible then sec = 0; return end
                local n = tonumber(tostring(timer.Text):match("%d+"))
                sec = n or 0
            end)
            return sec
        end

        local function isCmdOnCooldown(cmdName)
            cmdName = string.lower(tostring(cmdName or ""))
            if cmdName == "" then return false end
            local onCd = false
            pcall(function()
                if _G.DataManager and type(_G.DataManager.isOnCooldown) == "function" then
                    if _G.DataManager.isOnCooldown(cmdName) then onCd = true end
                end
            end)
            if onCd then return true end
            pcall(function()
                if _G._FH_CD_ONCD and _G._FH_CD_ONCD[cmdName] then onCd = true end
            end)
            if onCd then return true end
            local t = readAdminCmdTimer(cmdName)
            if type(t) == "number" and t > 0 then return true end
            return false
        end

        local function markCmdCooldownUsed(cmdName)
            cmdName = string.lower(tostring(cmdName or ""))
            pcall(function()
                _G._FH_CD_ONCD = _G._FH_CD_ONCD or {}
                _G._FH_CD_ONCD[cmdName] = true
            end)
            pcall(function()
                if _G.DataManager and type(_G.DataManager.updateCommand) == "function" then
                    _G.DataManager.updateCommand(cmdName, false, "COOLDOWN")
                end
            end)
        end

        local function fireAdminCmdOn(targetPlayer, commandName)
            if not targetPlayer or not commandName then return false end
            commandName = string.lower(tostring(commandName))
            if isCmdOnCooldown(commandName) then return false end
            local ok = false
            pcall(function()
                if _G.qapRunCommand then
                    ok = _G.qapRunCommand(commandName, targetPlayer) and true or false
                end
            end)
            if not ok then
                ok = fireAdminCommand(targetPlayer, commandName)
            end
            if ok then markCmdCooldownUsed(commandName) end
            return ok
        end

        local function hasBrainrotInHands()
            local char = player.Character
            if not char then return false end
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool then return false end
            local n = string.lower(tool.Name or "")
            if tool:GetAttribute("IsBrainrot") then return true end
            if n:find("brainrot", 1, true) or n:find("steal", 1, true) then return true end
            local ok, stealing = pcall(function()
                return char:GetAttribute("Stealing") == true or player:GetAttribute("StealingPlayer") == true
            end)
            if ok and stealing then return true end
            return false
        end

        local function useCapLaserThenRestore()
            task.spawn(function()
                local char = player.Character
                local bp = player:FindFirstChild("Backpack")
                if not char or not bp then return end
                local previousTool = nil
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") then previousTool = item; break end
                end
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") then item.Parent = bp end
                end
                task.wait(0.05)
                local keywords = { "cap laser", "caplaser", "laser cap", "lasercap", "cap_laser" }
                local function findTool(container)
                    if not container then return nil end
                    for _, item in ipairs(container:GetChildren()) do
                        if item:IsA("Tool") then
                            local n = item.Name:lower()
                            for _, kw in ipairs(keywords) do
                                if n:find(kw, 1, true) then return item end
                            end
                        end
                    end
                    return nil
                end
                local cap = findTool(bp) or findTool(char)
                if not cap then
                    if previousTool and previousTool.Parent then previousTool.Parent = char end
                    return
                end
                cap.Parent = char
                task.wait(0.08)
                pcall(function() cap:Activate() end)
                task.wait(0.12)
                pcall(function() cap:Activate() end)
                task.wait(0.1)
                if cap and cap.Parent == char then cap.Parent = bp end
                task.wait(0.05)
                if previousTool and previousTool.Parent then previousTool.Parent = char end
            end)
            return true
        end

        local function runDropBrainrotThenCap()
            task.spawn(function()
                -- 1) DROP (module Drop Brainrot ou fallback inline)
                local used = false
                pcall(function()
                    if _G.DropBrainrot and type(_G.DropBrainrot.run) == "function" then
                        _G.DropBrainrot.run(true)
                        used = true
                    end
                end)
                if not used then
                    pcall(function()
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local DROP_ASCEND_DURATION, DROP_ASCEND_SPEED = 0.2, 150
                        local startTime = tick()
                        local done = false
                        local conn
                        conn = RunService.Heartbeat:Connect(function()
                            local currentChar = player.Character
                            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                            if not currentChar or not currentRoot then
                                if conn then conn:Disconnect() end
                                done = true
                                return
                            end
                            if tick() - startTime >= DROP_ASCEND_DURATION then
                                if conn then conn:Disconnect() end
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = { currentChar }
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
                                if rayResult then
                                    local hum = currentChar:FindFirstChildOfClass("Humanoid")
                                    local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                                    currentRoot.CFrame = CFrame.new(
                                        currentRoot.Position.X,
                                        rayResult.Position.Y + offset,
                                        currentRoot.Position.Z
                                    )
                                    currentRoot.AssemblyLinearVelocity = Vector3.zero
                                    currentRoot.AssemblyAngularVelocity = Vector3.zero
                                end
                                done = true
                                return
                            end
                            currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, DROP_ASCEND_SPEED, currentRoot.Velocity.Z)
                        end)
                        local t0 = tick()
                        while not done and tick() - t0 < 1 do
                            task.wait(0.03)
                        end
                    end)
                else
                    task.wait(0.35)
                end
                -- 2) Equip Cap Laser + activate
                useCapLaserThenRestore()
            end)
            return true
        end

        local function triggerBalloon(targetPlayer)
            if not targetPlayer then return false end
            local ok = fireAdminCmdOn(targetPlayer, "balloon")
            if ok then
                pcall(function()
                    if showToast then showToast("Balloon → " .. (targetPlayer.Name or "?"), true) end
                end)
            end
            return ok
        end

        local function triggerRagdoll(targetPlayer)
            if not targetPlayer then return false end
            local ok = fireAdminCmdOn(targetPlayer, "ragdoll")
            if ok then
                pcall(function()
                    if showToast then showToast("Ragdoll → " .. (targetPlayer.Name or "?"), true) end
                end)
            end
            return ok
        end

        -- Priorite STRICTE:
        -- 1) Si balloon dispo → TOUJOURS balloon (priorite max)
        -- 2) Sinon si ragdoll dispo → ragdoll
        -- 3) Seulement si les DEUX sont en CD:
        --      - brainrot en main → Drop Brainrot puis Cap Laser
        --      - sinon → Cap Laser seul
        -- Cap Laser / Drop ne partent JAMAIS si une commande admin est dispo.
        local function respondToSteal(targetPlayer)
            if not targetPlayer then return false end

            -- 1) Balloon d'abord si pret
            if not isCmdOnCooldown("balloon") then
                local ok = triggerBalloon(targetPlayer)
                if ok then return true end
            end

            -- 2) Ragdoll si balloon indispo et ragdoll pret
            if isCmdOnCooldown("balloon") and not isCmdOnCooldown("ragdoll") then
                local ok = triggerRagdoll(targetPlayer)
                if ok then return true end
            end

            -- 3) Fallback outils UNIQUEMENT si balloon + ragdoll tous les deux en CD
            --    Auto Drop ON  → Drop Brainrot (meme systeme) + Cap Laser
            --    Auto Drop OFF → Cap Laser seul
            if isCmdOnCooldown("balloon") and isCmdOnCooldown("ragdoll") then
                if state.autoDrop then
                    pcall(function()
                        if showToast then showToast("Defense: Drop + Cap Laser", true) end
                    end)
                    return runDropBrainrotThenCap()
                else
                    pcall(function()
                        if showToast then showToast("Defense: Cap Laser", true) end
                    end)
                    return useCapLaserThenRestore()
                end
            end

            return false
        end

        local function playerLooksStealing(p)
            local ok, attr = pcall(function()
                return p:GetAttribute("StealingPlayer") == true
            end)
            if ok and attr then return true end
            local char = p.Character
            if not char then return false end
            local ok2, stealAttr = pcall(function()
                return char:GetAttribute("Stealing") == true
            end)
            if ok2 and stealAttr then return true end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local n = string.lower(tool.Name or "")
                if n:find("brainrot", 1, true) or n:find("steal", 1, true)
                    or n == "animal" or tool:GetAttribute("IsBrainrot") then
                    return true
                end
            end
            return false
        end

        local function startAutoDefenseLoop()
            if _defConn then return end
            local acc = 0
            _defConn = RunService.Heartbeat:Connect(function(dt)
                if not autoDefenseEnabled then return end
                acc = acc + (dt or 0.016)
                if acc < 0.02 then return end
                acc = 0
                local now = tick()
                local plot = findMyPlot()
                if not plot then return end

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        if not isInMyBase(p) then
                            local uid = p.UserId
                            if wasSteal[uid] then wasSteal[uid] = false end
                            continue
                        end

                        local uid = p.UserId
                        local stealing = playerLooksStealing(p)

                        if stealing and not wasSteal[uid] then
                            wasSteal[uid] = true
                            if useBalloon then
                                if now - (cooldowns[uid] or 0) >= BALLOON_COOLDOWN then
                                    cooldowns[uid] = now
                                    task.spawn(function()
                                        local ok = respondToSteal(p)
                                        if not ok then
                                            wasSteal[uid] = false
                                        end
                                    end)
                                end
                            end
                        elseif not stealing then
                            wasSteal[uid] = false
                        end
                    end
                end
            end)
        end

        local function stopAutoDefenseLoop()
            if _defConn then
                pcall(function() _defConn:Disconnect() end)
                _defConn = nil
            end
        end

        local function doSafetyLeave(reason)
            if not autoKickOnStealEnabled then return end
            if _safetyKickBusy then return end
            _safetyKickBusy = true
            pcall(function()
                if showToast then showToast("Safety Kick: " .. tostring(reason or "balloon"), true) end
            end)
            pcall(function() player:Kick(SAFETY_KICK_MSG) end)
            task.delay(2, function() _safetyKickBusy = false end)
        end

        local function textLooksLikeExecutedBalloon(t)
            if type(t) ~= "string" then return false end
            local s = string.lower(t)
            return s:find("executed", 1, true) ~= nil and s:find("balloon", 1, true) ~= nil
        end

        local function checkGuiText(inst)
            if not autoKickOnStealEnabled then return end
            if not inst or not inst:IsA("GuiObject") then return end
            local txt
            pcall(function()
                if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                    txt = inst.Text
                end
            end)
            if not txt or txt == "" then return end
            if not textLooksLikeExecutedBalloon(txt) then return end
            local id = tostring(inst)
            if _screenBalloonSeen[id] then return end
            _screenBalloonSeen[id] = true
            task.delay(3, function() _screenBalloonSeen[id] = nil end)
            doSafetyLeave('executed "balloon"')
        end

        local function startScreenBalloonWatch()
            if _screenBalloonConn then return end
            local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
            if not pg then return end
            pcall(function()
                for _, d in ipairs(pg:GetDescendants()) do checkGuiText(d) end
            end)
            _screenBalloonConn = pg.DescendantAdded:Connect(function(inst)
                task.defer(function()
                    checkGuiText(inst)
                    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                        local c
                        c = inst:GetPropertyChangedSignal("Text"):Connect(function()
                            checkGuiText(inst)
                        end)
                        task.delay(5, function() pcall(function() if c then c:Disconnect() end end) end)
                    end
                end)
            end)
        end

        local function stopScreenBalloonWatch()
            if _screenBalloonConn then
                pcall(function() _screenBalloonConn:Disconnect() end)
                _screenBalloonConn = nil
            end
            _screenBalloonSeen = {}
        end


        local DEFENSE_TOGGLE_NAMES = {
            auto = "Auto Defense",
            safety_kick = "Safety Kick",
            auto_drop = "Auto Drop",
        }

        local function saveKey(key, val)
            val = val and true or false
            pcall(function()
                if Config then
                    Config.set("defense_" .. key, val)
                    local t = Config.get("toggles", nil)
                    if type(t) ~= "table" then t = {} end
                    local label = DEFENSE_TOGGLE_NAMES[key]
                    if label then
                        t[label] = val
                        Config.set("toggles", t)
                        Config.set("toggle:" .. label, val)
                    end
                    if Config.flush then Config.flush() end
                    if Config.save then Config.save() end
                end
                if _G.coreConfig and _G.coreConfig.set then
                    _G.coreConfig:set("defense_" .. key, val)
                    if _G.coreConfig.flush then pcall(function() _G.coreConfig:flush() end) end
                end
            end)
        end

        local function loadKey(key, default)
            local v = nil
            pcall(function()
                if Config then
                    local direct = Config.get("defense_" .. key, nil)
                    if direct ~= nil then
                        v = direct
                        return
                    end
                    local label = DEFENSE_TOGGLE_NAMES[key]
                    if label then
                        local t = Config.get("toggles", nil)
                        if type(t) == "table" and t[label] ~= nil then
                            v = t[label]
                            return
                        end
                        local legacy = Config.get("toggle:" .. label, nil)
                        if legacy ~= nil then
                            v = legacy
                            return
                        end
                    end
                end
            end)
            if v == nil then v = default end
            return v and true or false
        end

        local function setAutoDefense(on, persist)
            if persist == nil then persist = true end
            autoDefenseEnabled = on and true or false
            state.autoDefense = autoDefenseEnabled
            useBalloon = true
            if autoDefenseEnabled then
                startAutoDefenseLoop()
            else
                stopAutoDefenseLoop()
            end
            if persist then saveKey("auto", autoDefenseEnabled) end
        end

        local function setSafetyKick(on, persist)
            if persist == nil then persist = true end
            autoKickOnStealEnabled = on and true or false
            state.safetyKick = autoKickOnStealEnabled
            _G._CyutsudSafetyKickEnabled = autoKickOnStealEnabled
            if autoKickOnStealEnabled then
                startScreenBalloonWatch()
            else
                stopScreenBalloonWatch()
            end
            if persist then saveKey("safety_kick", autoKickOnStealEnabled) end
        end

        local function setAutoDrop(on, persist)
            if persist == nil then persist = true end
            state.autoDrop = on and true or false
            _G._CyutsudDefenseAutoDrop = state.autoDrop
            if persist then saveKey("auto_drop", state.autoDrop) end
        end


        local function destroyGui()
            if gui then pcall(function() gui:Destroy() end) end
            gui = nil
            mainFrame = nil
            local pg = player:FindFirstChild("PlayerGui")
            local old = pg and pg:FindFirstChild("PanelGui_Cyutsud Defense")
            if old then pcall(function() old:Destroy() end) end
        end

        local function makeToggleRow(parent, order, title, sub, getState, setState)
            local card = Instance.new("Frame")
            card.Name = "Row_" .. title:gsub("%W", "_")
            card.Size = UDim2.new(1, -6, 0, 40)
            card.BackgroundColor3 = T.Card
            card.BorderSizePixel = 0
            card.ClipsDescendants = true
            card.LayoutOrder = order
            card.Parent = parent
            pcall(function() trackBgFrame(card, "Card") end)
            Corner(card, 10)
            local st = Stroke(card, (BLACK or T.Line), 1, 0.82)

            local accent = Instance.new("Frame")
            accent.Size = UDim2.new(0, 2, 0, 22)
            accent.Position = UDim2.new(0, 4, 0.5, -11)
            accent.BackgroundColor3 = themePrimary()
            accent.BackgroundTransparency = 0.35
            accent.BorderSizePixel = 0
            accent.Parent = card
            Corner(accent, 99)
            pcall(function() trackSolid(accent, 1) end)

            local nameLbl = Lbl(card, title, 11, T.Text, Enum.Font.GothamBold)
            nameLbl.Size = UDim2.new(1, -54, 0, 14)
            nameLbl.Position = UDim2.new(0, 12, 0, 4)
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left

            local subLbl = Lbl(card, sub, 8, T.TextDim, Enum.Font.Gotham)
            subLbl.Size = UDim2.new(1, -54, 0, 12)
            subLbl.Position = UDim2.new(0, 12, 0, 20)
            subLbl.TextTruncate = Enum.TextTruncate.AtEnd
            subLbl.TextXAlignment = Enum.TextXAlignment.Left

            local TW, TH, KW = 36, 18, 14
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, TW, 0, TH)
            track.Position = UDim2.new(1, -(TW + 10), 0.5, -math.floor(TH / 2))
            track.BackgroundColor3 = Color3.fromRGB(34, 28, 22)
            track.BorderSizePixel = 0
            track.Parent = card
            Corner(track, 99)
            local trackStroke = Stroke(track, (BLACK or Color3.fromRGB(0, 0, 0)), 1.2, 0.15)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(1, 0, 1, 0)
            fill.BackgroundColor3 = T.Primary or T.Green or Color3.fromRGB(147, 51, 234)
            fill.BackgroundTransparency = 1
            fill.BorderSizePixel = 0
            fill.Parent = track
            Corner(fill, 99)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, KW, 0, KW)
            knob.Position = UDim2.new(0, 3, 0.5, -math.floor(KW / 2))
            knob.BackgroundColor3 = Color3.fromRGB(230, 225, 240)
            knob.BorderSizePixel = 0
            knob.Parent = track
            Corner(knob, 99)
            Stroke(knob, (BLACK or Color3.fromRGB(0, 0, 0)), 1, 0.4)

            local function paint(on)
                local pad = 3
                local acc = themePrimary()
                if on then
                    knob.Position = UDim2.new(0, TW - KW - pad, 0.5, -math.floor(KW / 2))
                    knob.BackgroundColor3 = (type(_G._CyutsudKnobOnColor) == "function" and _G._CyutsudKnobOnColor() or Color3.fromRGB(255, 255, 255))
                    fill.BackgroundTransparency = 0
                    fill.BackgroundColor3 = acc
                    track.BackgroundColor3 = acc
                    trackStroke.Color = BLACK or Color3.fromRGB(0, 0, 0)
                    trackStroke.Transparency = 0
                    accent.BackgroundTransparency = 0
                    accent.BackgroundColor3 = acc
                else
                    knob.Position = UDim2.new(0, pad, 0.5, -math.floor(KW / 2))
                    knob.BackgroundColor3 = Color3.fromRGB(230, 225, 240)
                    fill.BackgroundTransparency = 1
                    track.BackgroundColor3 = Color3.fromRGB(34, 28, 22)
                    trackStroke.Color = BLACK or Color3.fromRGB(0, 0, 0)
                    trackStroke.Transparency = 0.15
                    accent.BackgroundTransparency = 0.35
                end
            end
            paint(getState())

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = card
            btn.Activated:Connect(function()
                local on = not getState()
                setState(on)
                paint(on)
                pcall(function() if showToast then showToast(title, on) end end)
            end)
            card.MouseEnter:Connect(function()
                Tween(card, F, {BackgroundColor3 = T.CardHover})
                Tween(st, F, {Transparency = 0.05})
            end)
            card.MouseLeave:Connect(function()
                Tween(card, F, {BackgroundColor3 = T.Card})
                Tween(st, F, {Transparency = 0.25})
            end)
            return paint
        end

        local function buildGui()
            destroyGui()

            local parent = nil
            pcall(function()
                if type(gethui) == "function" then parent = gethui() end
            end)
            if not parent then
                pcall(function()
                    local _cr = (type(cloneref) == "function") and cloneref or function(x) return x end
                    parent = _cr(game:GetService("CoreGui"))
                end)
            end
            if not parent then parent = playerGui end

            gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_Cyutsud Defense"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999997
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            pcall(function()
                if type(protect_gui) == "function" then protect_gui(gui)
                elseif syn and syn.protect_gui then syn.protect_gui(gui) end
            end)
            gui.Parent = parent

            mainFrame = Instance.new("Frame")
            mainFrame.Name = "Frame"
            mainFrame.Size = UDim2.new(0, 210, 0, 178)
            mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            mainFrame.BackgroundColor3 = T.Bg
            mainFrame.BackgroundTransparency = 0.04
            mainFrame.BorderSizePixel = 0
            mainFrame.Active = true
            mainFrame.ClipsDescendants = true
            mainFrame.Parent = gui
            pcall(function() trackBgFrame(mainFrame, "Bg") end)
            Corner(mainFrame, 14)
            pcall(function() GradStroke(mainFrame, 1.6, 0.25, 90) end)

            pcall(function()
                local p = Config and Config.get("defense_panel_pos", nil)
                if type(p) == "table" and #p >= 4 then
                    mainFrame.AnchorPoint = Vector2.new(0, 0)
                    mainFrame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                end
            end)

            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 28)
            titleBar.BackgroundColor3 = T.BgDeep
            titleBar.BackgroundTransparency = 0.05
            titleBar.Active = true
            titleBar.BorderSizePixel = 0
            titleBar.Parent = mainFrame
            pcall(function() trackBgFrame(titleBar, "BgDeep") end)
            Corner(titleBar, 12)
            local titleFill = Instance.new("Frame")
            titleFill.Size = UDim2.new(1, 0, 0, 10)
            titleFill.Position = UDim2.new(0, 0, 1, -10)
            titleFill.BackgroundColor3 = T.BgDeep
            titleFill.BackgroundTransparency = 0.05
            titleFill.BorderSizePixel = 0
            titleFill.Parent = titleBar
            pcall(function() trackBgFrame(titleFill, "BgDeep") end)
            local accent = Instance.new("Frame")
            accent.Name = "HubAccent"
            accent.Size = UDim2.new(1, 0, 0, 2)
            accent.Position = UDim2.new(0, 0, 1, -2)
            accent.BackgroundColor3 = Theme.c1
            accent.BorderSizePixel = 0
            accent.Parent = titleBar
            pcall(function() trackSolid(accent, 1) end)

            local title = Lbl(titleBar, "Defense", 11, T.Text, Enum.Font.GothamBold)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 0, 0, 0)
            title.TextXAlignment = Enum.TextXAlignment.Center
            title.TextYAlignment = Enum.TextYAlignment.Center

            local minBtn = Instance.new("TextButton")
            minBtn.Name = "MinBtn"
            minBtn.Size = UDim2.new(0, 18, 0, 18)
            minBtn.Position = UDim2.new(1, -24, 0.5, -9)
            minBtn.BackgroundColor3 = T.BgDeep
            minBtn.Text = "–"
            minBtn.Font = Enum.Font.GothamBold
            minBtn.TextSize = 12
            minBtn.TextColor3 = T.TextDim
            minBtn.AutoButtonColor = false
            minBtn.ZIndex = 25
            minBtn.Active = true
            minBtn.Parent = titleBar
            Corner(minBtn, 8)
            pcall(function() trackBgFrame(minBtn, "BgDeep") end)

            local _defMinimized = false
            local _defExpandedSize = UDim2.new(0, 210, 0, 178)
            local function toggleDefMinimize()
                if not mainFrame then return end
                _defMinimized = not _defMinimized
                if content then content.Visible = not _defMinimized end
                if _defMinimized then
                    _defExpandedSize = mainFrame.Size
                    mainFrame.Size = UDim2.new(
                        mainFrame.Size.X.Scale, mainFrame.Size.X.Offset,
                        0, 30
                    )
                    minBtn.Text = "+"
                else
                    mainFrame.Size = _defExpandedSize or UDim2.new(0, 210, 0, 178)
                    minBtn.Text = "–"
                end
            end
            minBtn.Activated:Connect(toggleDefMinimize)
            minBtn.MouseButton1Click:Connect(toggleDefMinimize)

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 1, -28)
            content.Position = UDim2.new(0, 0, 0, 28)
            content.BackgroundTransparency = 1
            content.Parent = mainFrame
            local list = Instance.new("UIListLayout")
            list.Padding = UDim.new(0, 4)
            list.HorizontalAlignment = Enum.HorizontalAlignment.Center
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Parent = content
            Pad(content, 4, 8, 6, 6)

            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, -4, 0, 12)
            sec.BackgroundTransparency = 1
            sec.LayoutOrder = 0
            sec.Parent = content
            local secLbl = Lbl(sec, "PROTECTION", 8, T.TextDim, Enum.Font.GothamBold)
            secLbl.Size = UDim2.new(1, 0, 1, 0)

            makeToggleRow(content, 1, "Auto Defense", "Balloon if steal in base",
                function() return state.autoDefense end, setAutoDefense)
            makeToggleRow(content, 2, "Safety Kick", "Leave if balloon executed",
                function() return state.safetyKick end, setSafetyKick)
            makeToggleRow(content, 3, "Auto Drop", "Drop + Cap when cmds on CD",
                function() return state.autoDrop end, setAutoDrop)

            do
                local _drag = _G.makePanelDraggable or makePanelDraggable
                if _drag then _drag(titleBar, mainFrame, "PanelGui_Defense") end
            end
            do
                local lastSave = 0
                mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
                    if tick() - lastSave < 0.4 then return end
                    lastSave = tick()
                    pcall(function()
                        if Config and mainFrame then
                            Config.set("defense_panel_pos", {
                                mainFrame.Position.X.Scale, mainFrame.Position.X.Offset,
                                mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset,
                            })
                        end
                    end)
                end)
            end
        end

        local M = {}
        function M.setVisible(on)
            state.panelOpen = on and true or false
            if state.panelOpen then
                pcall(function()
                    state.autoDefense = loadKey("auto", state.autoDefense)
                    state.safetyKick = loadKey("safety_kick", state.safetyKick)
                    state.autoDrop = loadKey("auto_drop", state.autoDrop)
                    autoDefenseEnabled = state.autoDefense
                    autoKickOnStealEnabled = state.safetyKick
                    _G._CyutsudDefenseAutoDrop = state.autoDrop
                end)
                buildGui()
            else
                destroyGui()
            end
            pcall(function()
                if Config then
                    Config.set("defense_panel_visible", state.panelOpen)
                    Config.set("toggle:Defense Panel", state.panelOpen)
                    local t = Config.get("toggles", nil)
                    if type(t) ~= "table" then t = {} end
                    t["Defense Panel"] = state.panelOpen and true or false
                    Config.set("toggles", t)
                    if Config.flush then Config.flush() end
                end
            end)
        end
        function M.set(on) -- alias for toggle compatibility
            M.setVisible(on)
        end
        function M.isOpen()
            return state.panelOpen and gui and gui.Parent ~= nil
        end

        local function restoreDefenseToggles()
            pcall(function()
                local a = loadKey("auto", false)
                local b = loadKey("safety_kick", false)
                if a then setAutoDefense(true, false) else setAutoDefense(false, false) end
                if b then setSafetyKick(true, false) else setSafetyKick(false, false) end
            end)
        end
        task.defer(restoreDefenseToggles)
        task.delay(1.2, restoreDefenseToggles) -- second pass after Config fully ready

        Players.PlayerRemoving:Connect(function(p)
            cooldowns[p.UserId] = nil
            wasSteal[p.UserId] = nil
        end)

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                setAutoDefense(false, false)
                setSafetyKick(false, false)
                destroyGui()
            end)
        end)

        return M
    end)()
    _G.MineESP = (function()
        local M = {}
        local SUBSPACE_FOLDER = "ToolsAdds"
        local subspaceData = {}
        local subspaceEnabled = false
        local subspaceConns = {}

        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")

        local THEME = {
            primary = Color3.fromRGB(168, 85, 247),
            accent  = Color3.fromRGB(34, 197, 94),
            danger  = Color3.fromRGB(255, 80, 80),
            bg      = Color3.fromRGB(18, 16, 14),
            text    = Color3.fromRGB(245, 245, 255),
            dim     = Color3.fromRGB(160, 160, 180),
        }

        local function refreshTheme()
            if Theme and typeof(Theme.c1) == "Color3" then
                THEME.primary = Theme.c1
            elseif _G.coreTheme and typeof(_G.coreTheme.primary) == "Color3" then
                THEME.primary = _G.coreTheme.primary
            end
        end

        local function _smOwnerInfo(mineName)
            local userName = mineName:match("SubspaceTripmine(.+)")
            if not userName or userName == "" then
                return "Inconnu", false
            end
            local foundPlayer = Players:FindFirstChild(userName)
            local displayName = foundPlayer and foundPlayer.DisplayName or userName
            local isOwn = false
            local lp = Players.LocalPlayer
            if lp then
                isOwn = (lp.Name == userName) or (foundPlayer == lp)
            end
            return displayName, isOwn
        end

        local function _smCreateESP(mine)
            refreshTheme()
            local ownerLabel, isOwn = _smOwnerInfo(mine.Name)

            local baseColor = isOwn and THEME.accent or THEME.danger
            local boxColor = isOwn and THEME.accent or THEME.primary

            local selectionBox = Instance.new("SelectionBox")
            selectionBox.Name = "ESP_Hitbox"
            selectionBox.Adornee = mine
            selectionBox.Color3 = boxColor
            selectionBox.LineThickness = 0.08
            selectionBox.SurfaceColor3 = THEME.bg
            selectionBox.SurfaceTransparency = 0.85
            selectionBox.Parent = mine

            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ESP_Label"
            billboardGui.Adornee = mine
            billboardGui.Size = UDim2.new(0, 220, 0, 48)
            billboardGui.StudsOffset = Vector3.new(0, 2.8, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.LightInfluence = 0
            billboardGui.MaxDistance = 300
            billboardGui.Parent = mine

            local background = Instance.new("Frame")
            background.Size = UDim2.new(1, 0, 1, 0)
            background.BackgroundColor3 = THEME.bg
            background.BackgroundTransparency = 0.25
            background.BorderSizePixel = 0
            background.Parent = billboardGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = background

            local stroke = Instance.new("UIStroke")
            stroke.Color = boxColor
            stroke.Thickness = 1.5
            stroke.Transparency = 0.3
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = background

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 4, 1, -8)
            accentBar.Position = UDim2.new(0, 4, 0.5, -4)
            accentBar.BackgroundColor3 = baseColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = background

            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = accentBar

            local icon = Instance.new("TextLabel")
            icon.Size = UDim2.new(0, 18, 0, 18)
            icon.Position = UDim2.new(0, 12, 0.5, -9)
            icon.BackgroundTransparency = 1
            icon.Text = "⚠"
            icon.TextColor3 = baseColor
            icon.Font = Enum.Font.GothamBold
            icon.TextSize = 14
            icon.TextYAlignment = Enum.TextYAlignment.Center
            icon.TextXAlignment = Enum.TextXAlignment.Center
            icon.Parent = background

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -80, 0, 18)
            nameLabel.Position = UDim2.new(0, 36, 0, 6)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = ownerLabel .. "'s Mine"
            nameLabel.TextColor3 = THEME.text
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 13
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextYAlignment = Enum.TextYAlignment.Top
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = background

            local statusLabel = Instance.new("TextLabel")
            statusLabel.Size = UDim2.new(1, -80, 0, 14)
            statusLabel.Position = UDim2.new(0, 36, 0, 26)
            statusLabel.BackgroundTransparency = 1
            statusLabel.Text = isOwn and "◆ yours" or "◈ threat"
            statusLabel.TextColor3 = isOwn and THEME.accent or THEME.danger
            statusLabel.Font = Enum.Font.GothamMedium
            statusLabel.TextSize = 10
            statusLabel.TextXAlignment = Enum.TextXAlignment.Left
            statusLabel.TextYAlignment = Enum.TextYAlignment.Top
            statusLabel.TextTransparency = 0.4
            statusLabel.Parent = background

            local shadow = Instance.new("ImageLabel")
            shadow.Size = UDim2.new(1, 20, 1, 20)
            shadow.Position = UDim2.new(0, -10, 0, -10)
            shadow.BackgroundTransparency = 1
            shadow.Image = "rbxassetid://5028857084"
            shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            shadow.ImageTransparency = 0.6
            shadow.ScaleType = Enum.ScaleType.Slice
            shadow.SliceCenter = Rect.new(24, 24, 276, 276)
            shadow.ZIndex = -1
            shadow.Parent = background

            return {
                selectionBox = selectionBox,
                billboardGui = billboardGui,
                background = background,
                stroke = stroke,
                accentBar = accentBar,
                statusLabel = statusLabel,
                mine = mine,
            }
        end

        local function _smClearAll()
            for _, data in pairs(subspaceData) do
                pcall(function()
                    if data.selectionBox then data.selectionBox:Destroy() end
                    if data.billboardGui then data.billboardGui:Destroy() end
                end)
            end
            subspaceData = {}
        end

        local function _smIsMine(obj)
            return obj:IsA("BasePart") and obj.Name:match("^SubspaceTripmine") ~= nil
        end

        local function _smTryAdd(obj)
            if not subspaceEnabled or not _smIsMine(obj) or subspaceData[obj] then return end
            local ok, data = pcall(_smCreateESP, obj)
            if ok and data then
                subspaceData[obj] = data
            end
        end

        local function _smRemove(obj)
            local data = subspaceData[obj]
            if data then
                pcall(function()
                    if data.selectionBox then data.selectionBox:Destroy() end
                    if data.billboardGui then data.billboardGui:Destroy() end
                end)
                subspaceData[obj] = nil
            end
        end

        local function _smDisconnect()
            for _, c in ipairs(subspaceConns) do
                pcall(function() c:Disconnect() end)
            end
            subspaceConns = {}
        end

        local function _smBindFolder(folder)
            table.insert(subspaceConns, folder.ChildAdded:Connect(_smTryAdd))
            table.insert(subspaceConns, folder.ChildRemoved:Connect(_smRemove))
            for _, obj in ipairs(folder:GetChildren()) do
                _smTryAdd(obj)
            end
        end

        local function _smEnable()
            if subspaceEnabled then return end
            subspaceEnabled = true
            local folder = Workspace:FindFirstChild(SUBSPACE_FOLDER)
            if folder then _smBindFolder(folder) end
            table.insert(subspaceConns, Workspace.ChildAdded:Connect(function(child)
                if child.Name == SUBSPACE_FOLDER then
                    _smBindFolder(child)
                end
            end))
            task.spawn(function()
                task.wait(0.5)
                if not subspaceEnabled then return end
                local f = Workspace:FindFirstChild(SUBSPACE_FOLDER)
                if f then
                    for _, obj in ipairs(f:GetDescendants()) do
                        _smTryAdd(obj)
                    end
                end
            end)
        end

        local function _smDisable()
            if not subspaceEnabled then return end
            subspaceEnabled = false
            _smDisconnect()
            _smClearAll()
        end

        function M.set(on)
            if on then
                _smEnable()
            else
                _smDisable()
            end
        end

        function M.isEnabled()
            return subspaceEnabled
        end

        function M.applyTheme(p, s)
            if p then THEME.primary = p end
            for mine, data in pairs(subspaceData) do
                if data then
                    pcall(function()
                        if data.selectionBox then
                            data.selectionBox.Color3 = THEME.primary
                        end
                        if data.stroke then
                            data.stroke.Color = THEME.primary
                        end
                        if data.accentBar then
                            data.accentBar.BackgroundColor3 = THEME.primary
                        end
                    end)
                end
            end
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.MineESP and _G.MineESP.set then _G.MineESP.set(false) end
        end)
    end)

    _G.IntruderAlarm = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local player = Players.LocalPlayer

        local M = { enabled = false }
        local alarmLabel = nil
        local alarmConnection = nil
        local alarmGui = nil
        local checkTimer = 0

        local function ensureAlertLabel()
            if alarmLabel and alarmLabel.Parent then return alarmLabel end

            local parent = nil
            pcall(function()
                if GUI and GUI.Parent then parent = GUI.Parent end
            end)
            if not parent then
                parent = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 5)
            end
            if not parent then return nil end

            if alarmGui and alarmGui.Parent then
                pcall(function() alarmGui:Destroy() end)
            end

            alarmGui = Instance.new("ScreenGui")
            alarmGui.Name = "NoxIntruderAlarm"
            alarmGui.ResetOnSpawn = false
            alarmGui.IgnoreGuiInset = true
            alarmGui.DisplayOrder = 999990
            alarmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            pcall(function()
                if type(protect_gui) == "function" then protect_gui(alarmGui)
                elseif syn and syn.protect_gui then syn.protect_gui(alarmGui) end
            end)
            alarmGui.Parent = parent

            alarmLabel = Instance.new("TextLabel")
            alarmLabel.Name = "AlertLabel"
            alarmLabel.AnchorPoint = Vector2.new(0.5, 1)
            alarmLabel.Position = UDim2.new(0.5, 0, 0.88, 0)
            alarmLabel.Size = UDim2.new(0, 600, 0, 70)
            alarmLabel.BackgroundTransparency = 1
            alarmLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            alarmLabel.TextSize = 24
            alarmLabel.Font = Enum.Font.GothamBold
            alarmLabel.TextWrapped = true
            alarmLabel.TextStrokeTransparency = 0.3
            alarmLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            alarmLabel.Visible = false
            alarmLabel.ZIndex = 50
            alarmLabel.Parent = alarmGui

            return alarmLabel
        end

        local function isPlayerInBase()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return {} end

            local intruders = {}

            local myPlot = nil
            local pn = string.lower(player.Name or "")
            local dn = string.lower(player.DisplayName or "")
            for _, plot in ipairs(plots:GetChildren()) do
                local sign = plot:FindFirstChild("PlotSign")
                if sign then
                    local label = sign:FindFirstChildWhichIsA("TextLabel", true)
                    if label and label.Text then
                        local text = string.lower(label.Text)
                        if (pn ~= "" and text:find(pn, 1, true))
                            or (dn ~= "" and text:find(dn, 1, true)) then
                            myPlot = plot
                            break
                        end
                    end
                    local yb = sign:FindFirstChild("YourBase")
                    if yb and yb:IsA("BillboardGui") and yb.Enabled then
                        myPlot = plot
                        break
                    end
                end
            end

            if not myPlot then return {} end

            local hitbox = myPlot:FindFirstChild("StealHitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                local cframe, size = hitbox.CFrame, hitbox.Size
                local halfX, halfZ = size.X / 2, size.Z / 2
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local localPos = cframe:PointToObjectSpace(root.Position)
                            if math.abs(localPos.X) <= halfX and math.abs(localPos.Z) <= halfZ then
                                table.insert(intruders, plr.Name)
                            end
                        end
                    end
                end
                return intruders
            end

            local ok, cf, size = pcall(function() return myPlot:GetBoundingBox() end)
            if not ok or not cf or not size then return {} end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local lp = cf:PointToObjectSpace(root.Position)
                        if math.abs(lp.X) <= size.X / 2
                            and math.abs(lp.Y) <= size.Y / 2 + 8
                            and math.abs(lp.Z) <= size.Z / 2 then
                            table.insert(intruders, plr.Name)
                        end
                    end
                end
            end
            return intruders
        end

        local function stopWatch()
            if alarmConnection then
                pcall(function() alarmConnection:Disconnect() end)
                alarmConnection = nil
            end
            if alarmLabel then
                alarmLabel.Visible = false
            end
        end

        local function startWatch()
            stopWatch()
            ensureAlertLabel()
            checkTimer = 0
            alarmConnection = RunService.Heartbeat:Connect(function(dt)
                if not M.enabled then return end
                checkTimer = checkTimer + (dt or 0.016)
                if checkTimer < 0.3 then return end
                checkTimer = 0

                local intruders = isPlayerInBase()
                local lbl = ensureAlertLabel()
                if not lbl then return end

                if #intruders > 0 then
                    local plural = #intruders > 1 and "s" or ""
                    lbl.Text = "� " .. #intruders .. " Player" .. plural
                        .. " in your Base! �\n" .. table.concat(intruders, ", ")
                    lbl.Visible = true
                else
                    lbl.Visible = false
                end
            end)
        end

        function M.set(on)
            M.enabled = on and true or false
            if M.enabled then
                startWatch()
            else
                stopWatch()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.toggle()
            M.set(not M.enabled)
        end

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard
                and input.KeyCode == Enum.KeyCode.A
                and (UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt)
                    or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) then
                M.set(not M.enabled)
                pcall(function()
                    if showToast then
                        showToast("Intruder Alarm", M.enabled)
                    end
                end)
                pcall(function()
                    if Config then
                        Config.set("toggle:Intruder Alarm", M.enabled)
                    end
                end)
            end
        end)

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                M.set(false)
                if alarmGui then alarmGui:Destroy() end
                alarmGui = nil
                alarmLabel = nil
            end)
        end)

        return M
    end)()
    _G.CloneESP = (function()
        local _cr = (type(cloneref) == "function") and cloneref or function(o) return o end
        local Players    = _cr(game:GetService("Players"))
        local Workspace  = _cr(game:GetService("Workspace"))
        local RunService = _cr(game:GetService("RunService"))

        local enabled = false
        local conns = {}
        local switched = false
        local labels = {}

        local function themePrimary()
            if Theme and typeof(Theme.c1) == "Color3" then
                return Theme.c1
            end
            if _G.coreTheme and typeof(_G.coreTheme.primary) == "Color3" then
                return _G.coreTheme.primary
            end
            return Color3.fromRGB(168, 85, 247)
        end

        local function getPlayerFromClone(clone)
            if not clone:IsA("Model") then return nil end
            local hum = clone:FindFirstChildOfClass("Humanoid")
            if not hum then return nil end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local ch = plr.Character:FindFirstChildOfClass("Humanoid")
                    if ch and ch.DisplayName == hum.DisplayName then
                        return plr
                    end
                end
            end
            local n = clone.Name
            local base = n:match("^(.-)_Clone$")
            if base then
                local plr = Players:FindFirstChild(base)
                if plr and plr:IsA("Player") then return plr end
            end
            return nil
        end

        local function highlightClone(clone)
            if not clone or not clone.Parent then return end
            local existing = clone:FindFirstChild("CloneHighlight")
            if existing then pcall(function() existing:Destroy() end) end
            if labels[clone] then
                pcall(function() labels[clone]:Destroy() end)
                labels[clone] = nil
            end

            local head = clone:FindFirstChild("Head")
            local plr = getPlayerFromClone(clone)
            local themeP = themePrimary()

            local hl = Instance.new("Highlight")
            hl.Name = "CloneHighlight"
            hl.FillColor = themeP
            hl.OutlineColor = Color3.new(
                math.min(1, themeP.R * 1.2 + 0.15),
                math.min(1, themeP.G * 1.2 + 0.15),
                math.min(1, themeP.B * 1.2 + 0.15)
            )
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillTransparency = 0.3
            hl.OutlineTransparency = 0.1
            hl.Adornee = clone
            hl.Parent = clone

            if head then
                local hum = clone:FindFirstChildOfClass("Humanoid")
                local dn = hum and hum.DisplayName or ""
                local pn = ""
                if plr then
                    pn = plr.Name
                    if dn == "" then dn = plr.DisplayName end
                end
                local who = pn ~= "" and pn or (dn ~= "" and dn or "?")
                local tag = string.format("%s's clone", who)

                local bb = Instance.new("BillboardGui")
                bb.Name = "CloneLabel"
                bb.Size = UDim2.new(0, 160, 0, 28)
                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                bb.AlwaysOnTop = true
                bb.LightInfluence = 0
                bb.MaxDistance = 0
                bb.ClipsDescendants = false
                bb.Adornee = head

                local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
                bb.Parent = pg or head

                local background = Instance.new("Frame")
                background.Size = UDim2.new(1, 0, 1, 0)
                background.BackgroundColor3 = Color3.fromRGB(18, 16, 14)
                background.BackgroundTransparency = 0.3
                background.BorderSizePixel = 0
                background.Parent = bb

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 12)
                corner.Parent = background

                local stroke = Instance.new("UIStroke")
                stroke.Color = themeP
                stroke.Thickness = 1
                stroke.Transparency = 0.3
                stroke.Parent = background

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = tag
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.TextSize = 11
                lbl.Font = Enum.Font.GothamBold
                lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                lbl.TextStrokeTransparency = 0.2
                lbl.TextXAlignment = Enum.TextXAlignment.Center
                lbl.TextYAlignment = Enum.TextYAlignment.Center
                lbl.Parent = background

                labels[clone] = bb
            end
        end

        local function clearAll()
            for clone, bb in pairs(labels) do
                pcall(function() bb:Destroy() end)
                labels[clone] = nil
            end
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name:find("_Clone") then
                    local hl = obj:FindFirstChild("CloneHighlight")
                    if hl then pcall(function() hl:Destroy() end) end
                end
            end
        end

        local function rescan()
            if not enabled then return end
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name:find("_Clone")
                    and not obj:FindFirstChild("CloneHighlight") then
                    pcall(highlightClone, obj)
                end
            end
        end

        task.spawn(function()
            local had = false
            while task.wait(0.5) do
                if not enabled then
                    had = false
                else
                    local lp = Players.LocalPlayer
                    if lp then
                        local needle = lp.Name .. "_Clone"
                        local has = false
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == needle then
                                has = true
                                break
                            end
                        end
                        if had and not has then
                            switched = true
                            task.delay(30, function() switched = false end)
                            rescan()
                        end
                        had = has
                    end
                end
            end
        end)

        local function start()
            clearAll()
            conns.added = Workspace.ChildAdded:Connect(function(child)
                if enabled and child:IsA("Model") and child.Name:find("_Clone") then
                    task.wait(0.1)
                    pcall(highlightClone, child)
                end
            end)
            local acc = 0
            conns.hb = RunService.Heartbeat:Connect(function(dt)
                if not enabled then return end
                acc = acc + (dt or 0.016)
                if acc < 0.5 then return end
                acc = 0
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:find("_Clone")
                        and not obj:FindFirstChild("CloneHighlight") then
                        pcall(highlightClone, obj)
                    end
                end
            end)
            rescan()
        end

        local function stop()
            for _, c in pairs(conns) do
                if c then pcall(function() c:Disconnect() end) end
            end
            conns = {}
            clearAll()
        end

        local M = {}
        function M.set(on)
            enabled = on and true or false
            if enabled then
                start()
            else
                stop()
            end
        end
        function M.isEnabled()
            return enabled
        end
        function M.applyTheme(p, s)
            p = p or themePrimary()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name:find("_Clone") then
                    local hl = obj:FindFirstChild("CloneHighlight")
                    if hl and hl:IsA("Highlight") then
                        pcall(function()
                            hl.FillColor = p
                            hl.OutlineColor = Color3.new(
                                math.min(1, p.R * 1.2 + 0.15),
                                math.min(1, p.G * 1.2 + 0.15),
                                math.min(1, p.B * 1.2 + 0.15)
                            )
                        end)
                    end
                    local head = obj:FindFirstChild("Head")
                    if head then
                        local bb = head:FindFirstChild("CloneLabel")
                        if bb then
                            for _, d in ipairs(bb:GetDescendants()) do
                                if d:IsA("UIStroke") then
                                    pcall(function() d.Color = p end)
                                end
                            end
                        end
                    end
                end
            end
        end
        return M
    end)()
    _G._FH_REG_CloneESP = _G.CloneESP

    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.CloneESP and _G.CloneESP.set then _G.CloneESP.set(false) end
        end)
    end)

    _G.TimerESP = (function()
        local RunService = game:GetService("RunService")
        local M = { enabled = false }
        local baseEspInstances = {}
        local espBaseThread = nil

        local function themePrimary()
            if Theme and typeof(Theme.c1) == "Color3" then
                return Theme.c1
            end
            if _G.coreTheme and typeof(_G.coreTheme.primary) == "Color3" then
                return _G.coreTheme.primary
            end
            return Color3.fromRGB(168, 85, 247)
        end

        local function createBaseESP(plot, mainPart)
            if baseEspInstances[plot.Name] then
                pcall(function() baseEspInstances[plot.Name]:Destroy() end)
            end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_CYUTSUD_TIMER_" .. tostring(plot.Name)
            billboard.Size = UDim2.new(0, 56, 0, 28)
            billboard.StudsOffset = Vector3.new(0, 5, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = mainPart
            billboard.MaxDistance = 1000
            billboard.Parent = plot

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.Font = Enum.Font.GothamBlack
            label.TextColor3 = themePrimary()
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Parent = billboard

            baseEspInstances[plot.Name] = billboard
            return billboard
        end

        local function updateBaseESP()
            if not M.enabled then return end
            local plotsFolder = workspace:FindFirstChild("Plots")
            if not plotsFolder then return end

            local seen = {}
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                seen[plot.Name] = true
                local purchases = plot:FindFirstChild("Purchases")
                local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
                local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
                local billboard = baseEspInstances[plot.Name]

                local timeLabel = nil
                if mainPart then
                    local bg = mainPart:FindFirstChild("BillboardGui")
                    if bg then
                        timeLabel = bg:FindFirstChild("RemainingTime")
                    end
                    if not timeLabel then
                        for _, d in ipairs(mainPart:GetDescendants()) do
                            if d:IsA("TextLabel") and d.Name == "RemainingTime" then
                                timeLabel = d
                                break
                            end
                        end
                    end
                end

                if timeLabel and mainPart then
                    if not billboard or not billboard.Parent then
                        billboard = createBaseESP(plot, mainPart)
                    end
                    local label = billboard and billboard:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        label.Text = timeLabel.Text
                        label.TextColor3 = themePrimary()
                    end
                elseif billboard then
                    pcall(function() billboard:Destroy() end)
                    baseEspInstances[plot.Name] = nil
                end
            end

            for name, bb in pairs(baseEspInstances) do
                if not seen[name] then
                    pcall(function() bb:Destroy() end)
                    baseEspInstances[name] = nil
                end
            end
        end

        local function start()
            if espBaseThread then return end
            local acc = 0
            espBaseThread = RunService.Heartbeat:Connect(function(dt)
                if not M.enabled then return end
                acc = acc + (dt or 0.016)
                if acc < 0.15 then return end
                acc = 0
                pcall(updateBaseESP)
            end)
            pcall(updateBaseESP)
        end

        local function stop()
            if espBaseThread then
                pcall(function() espBaseThread:Disconnect() end)
                espBaseThread = nil
            end
            for _, billboard in pairs(baseEspInstances) do
                pcall(function() billboard:Destroy() end)
            end
            baseEspInstances = {}
        end

        function M.set(on)
            on = on and true or false
            if on == M.enabled then return end
            M.enabled = on
            if on then
                start()
            else
                stop()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.applyTheme(p, s)
            p = p or themePrimary()
            for _, bb in pairs(baseEspInstances) do
                if bb and bb.Parent then
                    local label = bb:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        pcall(function() label.TextColor3 = p end)
                    end
                end
            end
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.TimerESP and _G.TimerESP.set then _G.TimerESP.set(false) end
        end)
    end)

    _G.BrainrotESP = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LP = Players.LocalPlayer

        local M = { enabled = false }
        local espFolder = nil
        local entries = {} -- key -> { bb, hl, label, moneyLbl }
        local conn = nil
        local acc = 0

        local function themePrimary()
            if Theme and typeof(Theme.c1) == "Color3" then
                return Theme.c1
            end
            if _G.coreTheme and typeof(_G.coreTheme.primary) == "Color3" then
                return _G.coreTheme.primary
            end
            return Color3.fromRGB(168, 85, 247)
        end

        local function isValidStealPrompt(prompt)
            if not prompt or not prompt.Parent or not prompt.Enabled then return false end
            local state = prompt:GetAttribute("State")
            local actionText = prompt.ActionText
            if state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab" then
                return true
            end
            return false
        end

        local function isOwnPlot(plot)
            if not plot then return false end
            if type(_G._CyutsudIsMyPlotByName) == "function" then
                local ok, res = pcall(_G._CyutsudIsMyPlotByName, plot.Name)
                if ok then return res end
            end
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then
                    return true
                end
            end
            return false
        end

        local function ensureFolder()
            if espFolder and espFolder.Parent then return espFolder end
            local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
            if not pg then return nil end
            local f = pg:FindFirstChild("NoxBrainrotESP")
            if not f then
                f = Instance.new("Folder")
                f.Name = "NoxBrainrotESP"
                f.Parent = pg
            end
            espFolder = f
            return f
        end

        local function clearAll()
            for key, e in pairs(entries) do
                pcall(function() if e.bb then e.bb:Destroy() end end)
                pcall(function() if e.hl then e.hl:Destroy() end end)
            end
            entries = {}
            if espFolder then
                for _, ch in ipairs(espFolder:GetChildren()) do
                    pcall(function() ch:Destroy() end)
                end
            end
        end

        local function collectMoneyText(spawn)
            if not spawn then return "" end
            local function isMoney(t)
                if type(t) ~= "string" or t == "" then return false end
                return t:find("%$") ~= nil or t:find("/s") ~= nil
                    or t:find("M/s") ~= nil or t:find("K/s") ~= nil
                    or t:find("B/s") ~= nil or t:find("T/s") ~= nil
            end
            local function fromGui(gui)
                for _, label in ipairs(gui:GetDescendants()) do
                    if label:IsA("TextLabel") and isMoney(label.Text) then
                        return (label.Text or ""):gsub("%s+", "")
                    end
                end
                return ""
            end
            for _, attName in ipairs({"PromptAttachment", "Attachment"}) do
                local att = spawn:FindFirstChild(attName)
                if att then
                    for _, child in ipairs(att:GetDescendants()) do
                        if child:IsA("BillboardGui") or child.Name == "AnimalOverhead" then
                            local m = fromGui(child)
                            if m ~= "" then
                                if not m:find("%$") then m = "$" .. m end
                                if not m:find("/s") then m = m .. "/s" end
                                return m
                            end
                        end
                    end
                end
            end
            for _, child in ipairs(spawn:GetChildren()) do
                if child:IsA("BillboardGui") then
                    local m = fromGui(child)
                    if m ~= "" then
                        if not m:find("%$") then m = "$" .. m end
                        if not m:find("/s") then m = m .. "/s" end
                        return m
                    end
                end
            end
            return ""
        end

        local function findNearModel(plot, spawn, pod)
            if not plot or not spawn then return nil end
            local playerNames = {}
            for _, p in ipairs(Players:GetPlayers()) do playerNames[p.Name] = true end
            local best, bestD = nil, 14
            for _, v in ipairs(plot:GetDescendants()) do
                if v:IsA("Model") and not playerNames[v.Name] then
                    if pod and v:IsDescendantOf(pod) then continue end
                    local n = string.lower(v.Name or "")
                    if n == "base" or n == "spawn" or n:find("podium") or n:find("plot") then continue end
                    local rp = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart")
                        or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
                    if rp then
                        local d = (rp.Position - spawn.Position).Magnitude
                        if d < bestD then bestD = d; best = v end
                    end
                end
            end
            return best
        end

        local function getMutationHint(prompt, spawn, model)
            local function tryAttr(inst)
                if not inst then return nil end
                for _, a in ipairs({"Mutation", "mutation", "Variant", "variant", "Rarity", "rarity", "Skin", "skin"}) do
                    local ok, v = pcall(function() return inst:GetAttribute(a) end)
                    if ok and v ~= nil then
                        local s = tostring(v)
                        if s ~= "" and s ~= "None" and s ~= "nil" and s ~= "Default" then
                            return s
                        end
                    end
                end
                return nil
            end
            local mut = tryAttr(prompt) or tryAttr(spawn) or tryAttr(model)
            if not mut and model then
                for _, d in ipairs(model:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text and #d.Text > 0 and #d.Text < 36 then
                        local t = d.Text
                        local low = string.lower(t)
                        for _, k in ipairs({"gold","diamond","blood","candy","lava","galaxy","rainbow","cursed","neon","crystal","phantom","cyber","divine","radioactive","yin"}) do
                            if low:find(k, 1, true) then
                                return t
                            end
                        end
                    end
                    mut = mut or tryAttr(d)
                    if mut then break end
                end
            end
            return mut
        end

        local function makeEntry(key, spawn, petName, money, mut, model)
            local folder = ensureFolder()
            if not folder then return end
            local col = themePrimary()

            local bb = Instance.new("BillboardGui")
            bb.Name = "BR_ESP_" .. key:gsub("%W", "_")
            bb.Size = UDim2.new(0, 160, 0, 48)
            bb.StudsOffset = Vector3.new(0, 3.2, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 450
            bb.Adornee = spawn
            bb.Parent = folder

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "Name"
            nameLbl.Size = UDim2.new(1, 0, 0, 26)
            nameLbl.Position = UDim2.new(0, 0, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextColor3 = col
            nameLbl.TextStrokeTransparency = 0.25
            nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLbl.TextScaled = false
            nameLbl.TextWrapped = true
            nameLbl.TextYAlignment = Enum.TextYAlignment.Bottom
            local display = petName
            if mut and mut ~= "" and not string.lower(petName):find(string.lower(mut), 1, true) then
                display = petName .. " [" .. mut .. "]"
            end
            nameLbl.Text = display
            nameLbl.Parent = bb

            local moneyLbl = Instance.new("TextLabel")
            moneyLbl.Name = "Money"
            moneyLbl.Size = UDim2.new(1, 0, 0, 18)
            moneyLbl.Position = UDim2.new(0, 0, 0, 26)
            moneyLbl.BackgroundTransparency = 1
            moneyLbl.Font = Enum.Font.GothamBold
            moneyLbl.TextSize = 12
            moneyLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
            moneyLbl.TextStrokeTransparency = 0.3
            moneyLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            moneyLbl.Text = money ~= "" and money or ""
            moneyLbl.Parent = bb

            local hl = nil
            if model then
                hl = Instance.new("Highlight")
                hl.Name = "ESP_CYUTSUD_BRAINROT"
                hl.Adornee = model
                hl.FillColor = col
                hl.OutlineColor = Color3.new(col.R * 0.5, col.G * 0.5, col.B * 0.5)
                hl.FillTransparency = 0.65
                hl.OutlineTransparency = 0.15
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = model
            end

            entries[key] = {
                bb = bb,
                hl = hl,
                nameLbl = nameLbl,
                moneyLbl = moneyLbl,
                spawn = spawn,
                model = model,
            }
        end

        local function updateESP()
            if not M.enabled then return end
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return end
            local seen = {}
            local playerNames = {}
            for _, p in ipairs(Players:GetPlayers()) do playerNames[p.Name] = true end

            for _, plot in ipairs(plots:GetChildren()) do
                if not plot:IsA("Model") then continue end
                if isOwnPlot(plot) then continue end
                local pods = plot:FindFirstChild("AnimalPodiums")
                if not pods then continue end
                for _, pod in ipairs(pods:GetChildren()) do
                    local slot = tonumber(tostring(pod.Name):match("%d+")) or 0
                    local base = pod:FindFirstChild("Base") or pod
                    local sp = base and base:FindFirstChild("Spawn")
                    if not sp then continue end

                    local prompt = nil
                    local att = sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _, pr in ipairs(att:GetChildren()) do
                            if pr:IsA("ProximityPrompt") and isValidStealPrompt(pr) then
                                prompt = pr
                                break
                            end
                        end
                    end
                    if not prompt then
                        for _, pr in ipairs(sp:GetDescendants()) do
                            if pr:IsA("ProximityPrompt") and isValidStealPrompt(pr) then
                                prompt = pr
                                break
                            end
                        end
                    end
                    if not prompt then continue end

                    local petName = tostring(prompt.ObjectText or ""):gsub("^%s+", ""):gsub("%s+$", "")
                    local model = findNearModel(plot, sp, pod)
                    if (petName == "" or petName == "Pet") and model then
                        petName = model.Name
                    end
                    if not petName or petName == "" or petName == "Pet" then continue end

                    local mut = getMutationHint(prompt, sp, model)
                    local money = collectMoneyText(sp)
                    local key = plot.Name .. "|" .. tostring(slot) .. "|" .. petName
                    seen[key] = true

                    local existing = entries[key]
                    if existing and existing.bb and existing.bb.Parent then
                        local display = petName
                        if mut and mut ~= "" and not string.lower(petName):find(string.lower(mut), 1, true) then
                            display = petName .. " [" .. mut .. "]"
                        end
                        if existing.nameLbl then existing.nameLbl.Text = display end
                        if existing.moneyLbl then existing.moneyLbl.Text = money end
                        if existing.bb.Adornee ~= sp then existing.bb.Adornee = sp end
                    else
                        if existing then
                            pcall(function() if existing.bb then existing.bb:Destroy() end end)
                            pcall(function() if existing.hl then existing.hl:Destroy() end end)
                            entries[key] = nil
                        end
                        makeEntry(key, sp, petName, money, mut, model)
                    end
                end
            end

            for key, e in pairs(entries) do
                if not seen[key] then
                    pcall(function() if e.bb then e.bb:Destroy() end end)
                    pcall(function() if e.hl then e.hl:Destroy() end end)
                    entries[key] = nil
                end
            end
        end

        local function start()
            if conn then return end
            ensureFolder()
            acc = 0
            conn = RunService.Heartbeat:Connect(function(dt)
                if not M.enabled then return end
                acc = acc + (dt or 0.016)
                if acc < 0.35 then return end -- ~3 Hz (FPS friendly)
                acc = 0
                pcall(updateESP)
            end)
            pcall(updateESP)
        end

        local function stop()
            if conn then
                pcall(function() conn:Disconnect() end)
                conn = nil
            end
            clearAll()
        end

        function M.set(on)
            on = on and true or false
            if on == M.enabled then return end
            M.enabled = on
            if on then
                start()
            else
                stop()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.applyTheme(p, s)
            p = p or themePrimary()
            for _, e in pairs(entries) do
                if e.nameLbl and e.nameLbl.Parent then
                    pcall(function() e.nameLbl.TextColor3 = p end)
                end
                if e.hl and e.hl.Parent then
                    pcall(function()
                        e.hl.FillColor = p
                        e.hl.OutlineColor = Color3.new(p.R * 0.5, p.G * 0.5, p.B * 0.5)
                    end)
                end
            end
        end

        function M.repaint()
            M.applyTheme(themePrimary())
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.BrainrotESP and _G.BrainrotESP.set then _G.BrainrotESP.set(false) end
        end)
    end)

    _G.AutoResetOnBalloon = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local TextChatService = game:GetService("TextChatService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LP = Players.LocalPlayer
        local M = { enabled = false }
        local conns = {}
        local loopThread = nil
        local lastReset = 0
        local seenGui = {}

        local function textHasJumpHigher(s)
            if type(s) ~= "string" or s == "" then return false end
            local low = string.lower(s)
            -- "Jump Higher" (balloon notification)
            if low:find("jump higher", 1, true) then return true end
            if low:find("jumphigher", 1, true) then return true end
            return false
        end

        local function isBallooned(char)
            if not char then return false end
            for _, d in ipairs(char:GetDescendants()) do
                local n = string.lower(d.Name or "")
                if n:find("balloon") then return true end
            end
            for _, ch in ipairs(char:GetChildren()) do
                if ch:IsA("Tool") and string.lower(ch.Name):find("balloon") then return true end
            end
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("RopeConstraint") then
                    local p0 = d.Part0 or d.Attachment0
                    local p1 = d.Part1 or d.Attachment1
                    local s = (tostring(p0) .. tostring(p1)):lower()
                    if s:find("balloon") then return true end
                end
            end
            return false
        end

        local function doReset(reason)
            if not M.enabled then return end
            local now = tick()
            if now - lastReset < 1.25 then return end
            lastReset = now
            pcall(function()
                if showToast then
                    showToast("Reset On Balloon" .. (reason and (": " .. tostring(reason)) or ""), true)
                end
            end)
            -- Prefer hub Instant Reset if available
            local ok = false
            pcall(function()
                if type(_G.ResetPlayer) == "function" then
                    _G.ResetPlayer()
                    ok = true
                elseif type(ResetPlayer) == "function" then
                    ResetPlayer()
                    ok = true
                end
            end)
            if not ok then
                pcall(function()
                    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Health = 0
                        task.wait(0.05)
                        if hum.Health > 0 then
                            pcall(function() hum:BreakJoints() end)
                        end
                    end
                end)
            end
        end

        local function onMaybeJumpHigher(text)
            if not M.enabled then return end
            if textHasJumpHigher(text) then
                doReset("Jump Higher")
            end
        end

        local function clearConns()
            for _, c in ipairs(conns) do
                pcall(function()
                    if typeof(c) == "RBXScriptConnection" then
                        c:Disconnect()
                    elseif type(c) == "thread" then
                        task.cancel(c)
                    end
                end)
            end
            conns = {}
            if loopThread then
                pcall(function() task.cancel(loopThread) end)
                loopThread = nil
            end
            seenGui = {}
        end

        local function startWatchers()
            clearConns()

            -- TextChatService (new chat)
            pcall(function()
                local c = TextChatService.MessageReceived:Connect(function(textMsg)
                    if not M.enabled then return end
                    local body = ""
                    pcall(function()
                        body = tostring(textMsg.Text or textMsg.PrefixText or "")
                    end)
                    onMaybeJumpHigher(body)
                end)
                table.insert(conns, c)
            end)

            -- Legacy DefaultChatSystemChatEvents
            pcall(function()
                local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if not chatEvents then return end
                local onFilter = chatEvents:FindFirstChild("OnMessageDoneFiltering")
                if onFilter and onFilter:IsA("RemoteEvent") then
                    local c = onFilter.OnClientEvent:Connect(function(data)
                        if not M.enabled then return end
                        local msg = ""
                        if type(data) == "table" then
                            msg = tostring(data.Message or data.message or data.Text or "")
                        else
                            msg = tostring(data or "")
                        end
                        onMaybeJumpHigher(msg)
                    end)
                    table.insert(conns, c)
                end
                local onNew = chatEvents:FindFirstChild("OnNewMessage")
                if onNew and onNew:IsA("RemoteEvent") then
                    local c2 = onNew.OnClientEvent:Connect(function(data)
                        if not M.enabled then return end
                        local msg = ""
                        if type(data) == "table" then
                            msg = tostring(data.Message or data.message or data.Text or "")
                        else
                            msg = tostring(data or "")
                        end
                        onMaybeJumpHigher(msg)
                    end)
                    table.insert(conns, c2)
                end
            end)

            -- Scan PlayerGui notifications / labels for "Jump Higher"
            loopThread = task.spawn(function()
                while M.enabled do
                    task.wait(0.2)
                    if not M.enabled then break end
                    pcall(function()
                        local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")
                        if not pg then return end
                        for _, d in ipairs(pg:GetDescendants()) do
                            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                                local t = d.Text
                                if type(t) == "string" and #t >= 4 and textHasJumpHigher(t) then
                                    local key = t .. "|" .. tostring(d:GetFullName())
                                    if not seenGui[key] then
                                        seenGui[key] = true
                                        doReset("Jump Higher")
                                    end
                                end
                            end
                        end
                    end)
                    -- also still reset if balloon constraints detected
                    pcall(function()
                        local char = LP.Character
                        if char and isBallooned(char) then
                            doReset("balloon")
                        end
                    end)
                end
            end)
            table.insert(conns, loopThread)
        end

        function M.set(on, skipSave)
            on = on and true or false
            if on == M.enabled then
                if on then startWatchers() end
                return
            end
            M.enabled = on
            if on then
                startWatchers()
            else
                clearConns()
            end
            if not skipSave then
                pcall(function()
                    if setToggleSaved then
                        setToggleSaved("Auto Reset On Balloon", on)
                    elseif Config then
                        Config.set("toggle:Auto Reset On Balloon", on)
                        Config.set("toggles", (function()
                            local t = Config.get("toggles", {}) or {}
                            if type(t) ~= "table" then t = {} end
                            local copy = {}
                            for k, v in pairs(t) do copy[k] = v end
                            copy["Auto Reset On Balloon"] = on
                            return copy
                        end)())
                        if Config.flush then Config.flush() end
                    end
                end)
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            -- skipSave: ne pas ecraser le toggle sauvegarde (comme Auto Steal / PaintBall)
            if _G.AutoResetOnBalloon and _G.AutoResetOnBalloon.set then
                _G.AutoResetOnBalloon.set(false, true)
            end
        end)
    end)

    _G.Unwalk = (function()
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        local unwalkSavedAnimate = nil
        local M = { enabled = false, charConn = nil }

        local function startUnwalk()
            local c = LP.Character
            if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                    pcall(function() t:Stop() end)
                end
            end
            local anim = c:FindFirstChild("Animate")
            if anim then
                unwalkSavedAnimate = anim:Clone()
                anim:Destroy()
            end
        end

        local function stopUnwalk()
            local c = LP.Character
            if c then
                local existing = c:FindFirstChild("Animate")
                if not existing then
                    local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
                    local starterAnim = src and src:FindFirstChild("Animate")
                    if starterAnim then
                        starterAnim:Clone().Parent = c
                    elseif unwalkSavedAnimate then
                        unwalkSavedAnimate:Clone().Parent = c
                    end
                end
            end
            unwalkSavedAnimate = nil
        end

        function M.set(on)
            M.enabled = on and true or false
            if M.enabled then
                startUnwalk()
            else
                stopUnwalk()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        if M.charConn then pcall(function() M.charConn:Disconnect() end) end
        M.charConn = LP.CharacterAdded:Connect(function()
            task.wait(0.35)
            if M.enabled then
                startUnwalk()
            end
        end)

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function() if _G.Unwalk and _G.Unwalk.set then _G.Unwalk.set(false) end end)
    end)

    _G.PlayerESP = (function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        local M = { enabled = false }
        local connections = {}
        local espBillboards = {}
        local espHighlights = {}
        local refreshThread = nil

        local function themePrimary()
            if Theme and typeof(Theme.c1) == "Color3" then
                return Theme.c1
            end
            if _G.coreTheme and typeof(_G.coreTheme.primary) == "Color3" then
                return _G.coreTheme.primary
            end
            return Color3.fromRGB(168, 85, 247)
        end

        local function cleanupCharacter(character)
            if not character then return end
            for _, v in ipairs(character:GetChildren()) do
                if v:IsA("Highlight") and (v.Name == "ESP_VIOLET" or v.Name == "ESP_CYUTSUD") then
                    pcall(function() v:Destroy() end)
                end
            end
            for key, bb in pairs(espBillboards) do
                if bb and bb.Parent then
                    local adornee = bb.Adornee
                    if adornee and adornee:IsDescendantOf(character) then
                        pcall(function() bb:Destroy() end)
                        espBillboards[key] = nil
                    end
                end
            end
        end

        local function getHeldTool(player)
            local char = player.Character
            if not char then return nil end
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("Tool") then
                    return obj.Name
                end
            end
            return nil
        end

        local function applyESP(player, character)
            if not character then return end
            if player == LocalPlayer then return end
            if not M.enabled then return end

            cleanupCharacter(character)

            local themeP = themePrimary()
            local hl = Instance.new("Highlight")
            hl.Name = "ESP_CYUTSUD"
            hl.FillColor = themeP
            hl.OutlineColor = Color3.new(themeP.R * 0.45, themeP.G * 0.45, themeP.B * 0.45)
            hl.FillTransparency = 0.65
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = character
            hl.Parent = character
            table.insert(espHighlights, hl)

            local hrp = character:FindFirstChild("HumanoidRootPart")
                or character:FindFirstChild("UpperTorso")
                or character:FindFirstChild("Torso")
            if not hrp then return end

            local bb = Instance.new("BillboardGui")
            bb.Name = "ESP_NAME"
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.StudsOffset = Vector3.new(0, 3.5, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = hrp
            bb.Parent = PlayerGui
            espBillboards[bb] = bb

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            frame.Parent = bb

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, 0, 0, 28)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = player.DisplayName ~= player.Name
                and (player.DisplayName .. " (@" .. player.Name .. ")")
                or player.Name
            nameLbl.Font = Enum.Font.GothamBlack
            nameLbl.TextScaled = true
            nameLbl.TextColor3 = themeP
            nameLbl.TextStrokeTransparency = 0
            nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLbl.Parent = frame

            local toolLbl = Instance.new("TextLabel")
            toolLbl.Size = UDim2.new(1, 0, 0, 20)
            toolLbl.Position = UDim2.new(0, 0, 0, 28)
            toolLbl.BackgroundTransparency = 1
            toolLbl.Font = Enum.Font.GothamBlack
            toolLbl.TextScaled = true
            toolLbl.TextColor3 = Color3.new(
                math.min(1, themeP.R * 1.15 + 0.1),
                math.min(1, themeP.G * 1.15 + 0.1),
                math.min(1, themeP.B * 1.15 + 0.1)
            )
            toolLbl.TextStrokeTransparency = 0
            toolLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            toolLbl.Text = getHeldTool(player) or ""
            toolLbl.Parent = frame

            task.spawn(function()
                while character.Parent and M.enabled and bb.Parent do
                    toolLbl.Text = getHeldTool(player) or ""
                    task.wait(0.15)
                end
            end)
        end

        local function disableESP()
            if refreshThread then
                pcall(function() task.cancel(refreshThread) end)
                refreshThread = nil
            end
            for _, c in ipairs(connections) do
                pcall(function()
                    if type(c) == "table" and c.Disconnect then
                        c.Disconnect()
                    elseif typeof(c) == "RBXScriptConnection" then
                        c:Disconnect()
                    end
                end)
            end
            connections = {}

            for _, hl in ipairs(espHighlights) do
                pcall(function() hl:Destroy() end)
            end
            espHighlights = {}

            for _, bb in pairs(espBillboards) do
                pcall(function() bb:Destroy() end)
            end
            espBillboards = {}
        end

        local function enableESP()
            if not M.enabled then return end
            disableESP()

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local connChar = plr.CharacterAdded:Connect(function(char)
                        task.wait(0.4)
                        if M.enabled then applyESP(plr, char) end
                    end)
                    table.insert(connections, connChar)
                    if plr.Character then
                        applyESP(plr, plr.Character)
                    end
                end
            end

            local connAdd = Players.PlayerAdded:Connect(function(plr)
                if plr == LocalPlayer then return end
                local connChar = plr.CharacterAdded:Connect(function(char)
                    task.wait(0.4)
                    if M.enabled then applyESP(plr, char) end
                end)
                table.insert(connections, connChar)
                if plr.Character then
                    applyESP(plr, plr.Character)
                end
            end)
            table.insert(connections, connAdd)

            local connRemove = Players.PlayerRemoving:Connect(function(plr)
                if plr.Character then
                    cleanupCharacter(plr.Character)
                end
            end)
            table.insert(connections, connRemove)

            refreshThread = task.spawn(function()
                while M.enabled do
                    task.wait(1.0)
                    if not M.enabled then break end
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            local hasHL = false
                            for _, c in ipairs(plr.Character:GetChildren()) do
                                if c:IsA("Highlight") and (c.Name == "ESP_CYUTSUD" or c.Name == "ESP_VIOLET") then
                                    hasHL = true
                                    break
                                end
                            end
                            if not hasHL then
                                pcall(applyESP, plr, plr.Character)
                            end
                        end
                    end
                end
            end)
        end

        function M.set(on)
            M.enabled = on and true or false
            if on then
                enableESP()
            else
                disableESP()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.applyTheme(p, s)
            p = p or themePrimary()
            for _, hl in ipairs(espHighlights) do
                if hl and hl.Parent then
                    pcall(function()
                        hl.FillColor = p
                        hl.OutlineColor = Color3.new(p.R * 0.45, p.G * 0.45, p.B * 0.45)
                    end)
                end
            end
            for bb, _ in pairs(espBillboards) do
                if bb and bb.Parent then
                    pcall(function()
                        for _, d in ipairs(bb:GetDescendants()) do
                            if d:IsA("TextLabel") then
                                d.TextColor3 = p
                            end
                        end
                    end)
                end
            end
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.PlayerESP and _G.PlayerESP.set then _G.PlayerESP.set(false) end
        end)
    end)

    _G.InfiniteJump = (function()
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local LP = Players.LocalPlayer

        local M = {
            enabled = false,
            conn = nil,
            holdConn = nil,
            endConn = nil,
            isJumpingHold = false,
            lastJumpTime = 0,
            COOLDOWN = 0.12,
        }

        local function applyBoost(boost)
            if not M.enabled then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.new(
                        root.AssemblyLinearVelocity.X,
                        boost,
                        root.AssemblyLinearVelocity.Z
                    )
                    root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z)
                end)
            end
        end

        local function startListening()
            if M.conn then return end

            M.conn = UserInputService.JumpRequest:Connect(function()
                if not M.enabled then return end
                local now = tick()
                if now - M.lastJumpTime >= M.COOLDOWN then
                    M.lastJumpTime = now
                    applyBoost(65)
                end
                M.isJumpingHold = true
            end)

            M.holdConn = task.spawn(function()
                while true do
                    task.wait(0.01)
                    if M.isJumpingHold and M.enabled then
                        local now = tick()
                        if now - M.lastJumpTime >= M.COOLDOWN then
                            M.lastJumpTime = now
                            applyBoost(65)
                        end
                    end
                end
            end)

            M.endConn = UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Space
                    or input.KeyCode == Enum.KeyCode.ButtonA
                    or input.UserInputType == Enum.UserInputType.Touch then
                    M.isJumpingHold = false
                end
            end)
        end

        local function stopListening()
            if M.conn then pcall(function() M.conn:Disconnect() end); M.conn = nil end
            if M.holdConn then pcall(function() task.cancel(M.holdConn) end); M.holdConn = nil end
            if M.endConn then pcall(function() M.endConn:Disconnect() end); M.endConn = nil end
            M.isJumpingHold = false
        end

        function M.set(on)
            M.enabled = on and true or false
            stopListening()
            if M.enabled then
                startListening()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        LP.CharacterAdded:Connect(function()
            M.isJumpingHold = false
            M.lastJumpTime = 0
            if M.enabled then
                task.defer(function()
                    stopListening()
                    startListening()
                end)
            end
        end)

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.InfiniteJump and _G.InfiniteJump.set then _G.InfiniteJump.set(false) end
        end)
    end)

    _G.AntiAdmin = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInput = game:GetService("UserInputService")
        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera

        local M = { enabled = false }
        local antiGummyRespawnGraceUntil = 0
        local originalScales = {}
        local originalHipHeight = nil
        local cameraLocked = false
        local lastValidCameraPosition = nil
        local lastValidCharacterPosition = nil
        local _ctrlCache = nil
        local _charController = nil
        local _jumpscareMod = nil
        local loopConn = nil
        local camLoopConn = nil
        local inputConn = nil
        local charAddedConn = nil
        local charAddedCtrlConn = nil

        local scaleNames = {
            "HeadScale", "BodyDepthScale", "BodyHeightScale",
            "BodyProportionScale", "BodyTypeScale", "BodyWidthScale",
        }

        local function captureOriginals()
            local char = Player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            originalHipHeight = hum.HipHeight
            originalScales = {}
            for _, name in ipairs(scaleNames) do
                local sv = hum:FindFirstChild(name)
                if sv then originalScales[name] = sv.Value end
            end
        end

        local function getControls()
            if _ctrlCache then return _ctrlCache end
            local ps = Player:FindFirstChild("PlayerScripts")
            local pm = ps and ps:FindFirstChild("PlayerModule")
            if not pm then return nil end
            local ok, mod = pcall(require, pm)
            if not ok or not mod then return nil end
            local ok2, c = pcall(function() return mod:GetControls() end)
            if ok2 and c then _ctrlCache = c end
            return _ctrlCache
        end

        local function tryRequireCharController()
            if _charController ~= nil then return _charController end
            local ok, mod = pcall(function()
                return require(game:GetService("ReplicatedStorage")
                    :WaitForChild("Controllers", 2)
                    :WaitForChild("CharacterController", 2))
            end)
            _charController = ok and mod or false
            return _charController
        end

        local function tryRequireJumpscare()
            if _jumpscareMod ~= nil then return _jumpscareMod end
            local ok, mod = pcall(function()
                return require(game:GetService("ReplicatedStorage")
                    :WaitForChild("Datas", 2)
                    :WaitForChild("AdminCommands", 2)
                    :WaitForChild("jumpscare", 2))
            end)
            _jumpscareMod = ok and mod or false
            return _jumpscareMod
        end

        local function isFlightToolRelated(obj)
            if not obj then return false end
            local function nameLooksFlight(s)
                s = string.lower(tostring(s or ""))
                return s:find("carpet") or s:find("broom") or s:find("wing") or s:find("sleigh")
                    or s:find("waverider") or s:find("hover") or s:find("jetpack") or s:find("cloud")
                    or s:find("magic carpet") or s:find("fly")
            end
            if nameLooksFlight(obj.Name) then return true end
            local p = obj.Parent
            for _ = 1, 6 do
                if not p then break end
                if p:IsA("Tool") and nameLooksFlight(p.Name) then return true end
                if nameLooksFlight(p.Name) then return true end
                p = p.Parent
            end
            -- if local player has a flight tool equipped, protect all non-hub forces on character
            local char = Player and Player.Character
            if char then
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") and nameLooksFlight(t.Name) then
                        return true
                    end
                end
            end
            return false
        end

        local function isHubForce(obj)
            if not obj then return false end
            -- Never strip forces belonging to flying tools (carpet, broom, wings…)
            if isFlightToolRelated(obj) then return true end
            pcall(function()
                if Booster then
                    if Booster._velocity and obj == Booster._velocity then return true end
                    if Booster._attachment and (obj == Booster._attachment or obj.Parent == Booster._attachment) then
                        return true
                    end
                end
            end)
            if Booster and Booster._velocity and obj == Booster._velocity then return true end
            if Booster and Booster._attachment and (obj == Booster._attachment or obj.Parent == Booster._attachment) then
                return true
            end
            local n = string.lower(tostring(obj.Name or ""))
            if n:find("booster") or n:find("nox") or n:find("gps") or n:find("giant") or n:find("carpet")
                or n:find("broom") or n:find("wing") or n:find("sleigh") or n:find("hover") then
                return true
            end
            local p = obj.Parent
            if p then
                local pn = string.lower(tostring(p.Name or ""))
                if pn:find("booster") or pn:find("nox") or pn:find("gps") or pn:find("carpet")
                    or pn:find("broom") or pn:find("wing") then
                    return true
                end
            end
            return false
        end

        local function stripRocketForces(char)
            for _, obj in ipairs(char:GetDescendants()) do
                if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyThrust")
                    or obj:IsA("LinearVelocity") or obj:IsA("VectorForce")
                    or obj:IsA("AlignPosition") or obj:IsA("Torque") or obj:IsA("AngularVelocity"))
                    and not isHubForce(obj) then
                    pcall(function() obj:Destroy() end)
                end
            end
        end

        local ROCKET_DURATION = 2.8
        local ROCKET_REARM_CD = 0.35
        local _rocketUntil = 0
        local _rocketRearmAfter = 0
        local _rocketNotified = false
        local _rocketWasActive = false

        local function isRocketWindowActive()
            return tick() < _rocketUntil
        end

        local function armRocketProtection(reason)
            local now = tick()
            if now < _rocketUntil then
                return
            end
            if now < _rocketRearmAfter then
                return
            end
            _rocketUntil = now + ROCKET_DURATION
            _rocketRearmAfter = _rocketUntil + ROCKET_REARM_CD
            if not _rocketNotified then
                _rocketNotified = true
                pcall(function()
                    if showToast then
                        showToast("Anti Rocket 2.8s", true)
                    elseif _G.coreNotify then
                        _G.coreNotify.show("Anti Rocket", "2.8s puis air OK")
                    end
                end)
                task.delay(ROCKET_DURATION + 0.05, function()
                    _rocketNotified = false
                end)
            end
        end

        local function isInfiniteJumpOn()
            local ij = _G.InfiniteJump
            if not ij then return false end
            if type(ij.isEnabled) == "function" then
                local ok, on = pcall(ij.isEnabled)
                if ok and on then return true end
            end
            return ij.enabled and true or false
        end

        local function hasFlightToolEquipped(char)
            if not char then return false end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    local n = string.lower(t.Name or "")
                    if n:find("carpet") or n:find("broom") or n:find("wing") or n:find("sleigh")
                        or n:find("waverider") or n:find("hover") or n:find("jetpack") or n:find("cloud") then
                        return true
                    end
                end
            end
            return false
        end

        local function neutralizeRocket(char, hum, hrp)
            -- Do not fight flying tools (carpet etc.)
            if hasFlightToolEquipped(char) then return end
            local now = tick()
            local v = hrp.AssemblyLinearVelocity
            local ijOn = isInfiniteJumpOn()

            if _rocketWasActive and now >= _rocketUntil then
                _rocketWasActive = false
            end

            if now >= _rocketUntil and now >= _rocketRearmAfter then
                local detected = false
                -- Infinite Jump boost ~50-70: do not treat as rocket
                local yDetect = ijOn and 90 or 55
                if v.Y > yDetect then
                    detected = true
                end
                if not detected then
                    for _, obj in ipairs(char:GetDescendants()) do
                        if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyThrust")
                            or obj:IsA("LinearVelocity") or obj:IsA("VectorForce")
                            or obj:IsA("AlignPosition")) and not isHubForce(obj) then
                            detected = true
                            break
                        end
                    end
                end
                if detected then
                    armRocketProtection("detect")
                end
            end

            if not isRocketWindowActive() then
                return
            end
            _rocketWasActive = true

            stripRocketForces(char)

            v = hrp.AssemblyLinearVelocity
            -- Allow Infinite Jump upward boost; still kill real rocket launches
            if ijOn then
                if v.Y > 90 then
                    hrp.AssemblyLinearVelocity = Vector3.new(v.X, 55, v.Z)
                end
            elseif v.Y > 5 then
                hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
            end
            local av = hrp.AssemblyAngularVelocity
            if av.Magnitude > 20 then
                hrp.AssemblyAngularVelocity = Vector3.zero
            end

            pcall(function()
                hum.PlatformStand = false
                hum.Sit = false
                hum.AutoRotate = true
                local want = 16
                if _G.GiantPotionSpeed and _G.GiantPotionSpeed.enabled then
                    local gs = (type(_G.GiantPotionSpeed.getSpeed) == "function" and _G.GiantPotionSpeed.getSpeed()) or _G.GiantPotionSpeed.speed
                    if type(gs) == "number" and gs > want then want = gs end
                end
                if _G.giantSpeedRequested and want < 28 then want = math.max(want, 28) end
                if Booster and Booster.userEnabled then
                    if type(Booster.speed) == "number" and Booster.speed > want then
                        want = Booster.speed
                    end
                    if not Booster._velocity or not Booster._velocity.Parent then
                        pcall(function()
                            if Booster.unsuspend then
                                for _, r in ipairs({"semitp", "uptp", "gps", "carpet", "auto_carpet", "default"}) do
                                    pcall(function() Booster.unsuspend(r) end)
                                end
                            end
                            if Booster.set then Booster.set(true) end
                        end)
                    elseif Booster._velocity and Booster.enabled then
                        pcall(function()
                            Booster._velocity.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
                            Booster._velocity.Enabled = true
                        end)
                    end
                end
                if hum.WalkSpeed < 8 then
                    hum.WalkSpeed = math.max(want, 16)
                end
                if hum.JumpPower < 1 and hum.UseJumpPower then
                    hum.JumpPower = (Booster and Booster.jump) or 50
                end
            end)
            local ctrl = getControls()
            if ctrl then pcall(function() ctrl:Enable() end) end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.PlatformStanding then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end

        local _rocketHooked = {}
        local function hookRocketOnChar(char)
            if not char or _rocketHooked[char] then return end
            _rocketHooked[char] = true
            char.DescendantAdded:Connect(function(obj)
                if not M.enabled then return end
                if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyThrust")
                    or obj:IsA("LinearVelocity") or obj:IsA("VectorForce")
                    or obj:IsA("AlignPosition")) and not isHubForce(obj) then
                    armRocketProtection("force")
                    task.defer(function()
                        if M.enabled and isRocketWindowActive() then
                            pcall(function() obj:Destroy() end)
                        end
                    end)
                end
            end)
            char.Destroying:Connect(function()
                _rocketHooked[char] = nil
            end)
        end

        local function protectTick()
            if not M.enabled then return end
            local char = Player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end

            Camera = workspace.CurrentCamera

            hookRocketOnChar(char)
            neutralizeRocket(char, hum, hrp)

            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
                    pcall(function() v:Destroy() end)
                elseif v:IsA("Motor6D") then
                    v.Enabled = true
                end
            end

            local ctrl = getControls()
            if ctrl then pcall(function() ctrl:Enable() end) end

            local state = hum:GetState()
            if state ~= Enum.HumanoidStateType.Running
                and state ~= Enum.HumanoidStateType.Jumping
                and state ~= Enum.HumanoidStateType.Freefall
                and state ~= Enum.HumanoidStateType.Flying then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end

            if Camera and Camera.CameraSubject ~= hum then
                Camera.CameraSubject = hum
                cameraLocked = false
            end

            local ragdollEnd = Player:GetAttribute("RagdollEndTime") or 0
            if ragdollEnd > 0 and ragdollEnd > workspace:GetServerTimeNow() then
                hrp.AssemblyLinearVelocity = Vector3.zero
                Player:SetAttribute("RagdollEndTime", 0)
            end

            local cc = tryRequireCharController()
            if cc and ctrl then
                pcall(function()
                    ctrl.moveFunction = function(p, x, z)
                        cc:RequestMove(p, x, z)
                    end
                end)
            end

            local jm = tryRequireJumpscare()
            if jm and type(jm) == "table" and jm.effects and jm.effects.Victim then
                jm.effects.Victim = function() end
            end

            if originalHipHeight and hum.HipHeight ~= originalHipHeight then
                hum.HipHeight = originalHipHeight
            end
            for _, name in ipairs(scaleNames) do
                local sv = hum:FindFirstChild(name)
                if sv and originalScales[name] and sv.Value ~= originalScales[name] then
                    sv.Value = originalScales[name]
                end
            end

            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("Model") and not v:IsA("BackpackItem")
                    and not v.Name:find("Head") and not v.Name:find("Torso")
                    and not v.Name:find("Arm") and not v.Name:find("Leg") then
                    pcall(function() v:Destroy() end)
                end
            end

            if Camera and Camera.Parent == workspace then
                lastValidCameraPosition = Camera.CFrame
            end
        end

        local function camTick()
            if not M.enabled then return end
            local char = Player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            Camera = workspace.CurrentCamera
            if Camera and Camera.CameraSubject and Camera.CameraSubject ~= hum then
                Camera.CameraSubject = hum
            end
            if UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                cameraLocked = false
            end
        end

        local function stopLoops()
            if loopConn then pcall(function() task.cancel(loopConn) end); loopConn = nil end
            if camLoopConn then pcall(function() task.cancel(camLoopConn) end); camLoopConn = nil end
            if inputConn then pcall(function() inputConn:Disconnect() end); inputConn = nil end
            if charAddedConn then pcall(function() charAddedConn:Disconnect() end); charAddedConn = nil end
            if charAddedCtrlConn then pcall(function() charAddedCtrlConn:Disconnect() end); charAddedCtrlConn = nil end
        end

        local function startLoops()
            stopLoops()
            captureOriginals()
            charAddedConn = Player.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid", 5)
                if not hum then return end
                antiGummyRespawnGraceUntil = tick() + 1.5
                cameraLocked = false
                lastValidCameraPosition = nil
                lastValidCharacterPosition = nil
                task.wait(0.1)
                captureOriginals()
            end)
            charAddedCtrlConn = Player.CharacterAdded:Connect(function()
                _ctrlCache = nil
            end)
            loopConn = task.spawn(function()
                while M.enabled do
                    pcall(protectTick)
                    task.wait(0.05)
                end
            end)
            camLoopConn = task.spawn(function()
                while M.enabled do
                    pcall(camTick)
                    task.wait(0.05)
                end
            end)
            inputConn = UserInput.InputBegan:Connect(function(input, gameProcessed)
                if not M.enabled then return end
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    cameraLocked = false
                end
            end)
        end

        function M.set(on)
            on = on and true or false
            if M.enabled == on then return end
            M.enabled = on
            if on then
                startLoops()
            else
                stopLoops()
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.AntiAdmin and _G.AntiAdmin.set then _G.AntiAdmin.set(false) end
        end)
    end)

    
    _G.AllowDisallowESP = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LP = Players.LocalPlayer

        local DISALLOW_IMAGE = "rbxassetid://110783679426495"
        local COL_ALLOW = Color3.fromRGB(60, 230, 110)
        local COL_DISALLOW = Color3.fromRGB(240, 60, 60)

        local M = {
            enabled = false,
            pool = {},
            conn = nil,
            childConns = {},
            plotsList = {},
        }

        local function getEspParent()
            local pg = LP:FindFirstChild("PlayerGui")
            if not pg then return nil end
            local gui = pg:FindFirstChild("NoxAllowDisallowESP")
            if not gui then
                gui = Instance.new("ScreenGui")
                gui.Name = "NoxAllowDisallowESP"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = true
                gui.DisplayOrder = 50
                gui.Parent = pg
            end
            return gui
        end

        local function getOrCreate(key, adornee)
            local entry = M.pool[key]
            if not entry or not entry.bb or not entry.bb.Parent then
                local parent = getEspParent()
                if not parent then return nil end
                local bb = Instance.new("BillboardGui")
                bb.Name = "AD_ESP_" .. tostring(key):gsub("%W", "_")
                bb.Size = UDim2.new(0, 36, 0, 36)
                bb.StudsOffset = Vector3.new(0, 2.4, 0)
                bb.AlwaysOnTop = true
                bb.LightInfluence = 0
                bb.MaxDistance = math.huge
                bb.Enabled = false
                bb.Parent = parent

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.BorderSizePixel = 0
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 28
                lbl.Text = ""
                lbl.TextColor3 = COL_ALLOW
                lbl.TextStrokeTransparency = 0.35
                lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                lbl.Parent = bb

                entry = { bb = bb, lbl = lbl, used = false }
                M.pool[key] = entry
            end
            if adornee then
                entry.bb.Adornee = adornee
            end
            return entry
        end

        local function isDisallowed(friendPanel)
            local main = friendPanel:FindFirstChild("Main")
            if not main then return false end
            local sg = main:FindFirstChild("SurfaceGui")
            if not sg then return false end
            local img = sg:FindFirstChild("ImageLabel")
            if not img then
                for _, d in ipairs(sg:GetDescendants()) do
                    if d:IsA("ImageLabel") then img = d break end
                end
            end
            if not img then return false end
            return img.Image == DISALLOW_IMAGE
        end

        local function getAdornee(friendPanel)
            if friendPanel:IsA("BasePart") then return friendPanel end
            if friendPanel.PrimaryPart then return friendPanel.PrimaryPart end
            return friendPanel:FindFirstChildWhichIsA("BasePart", true)
        end

        local function refreshPlotsList()
            M.plotsList = {}
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return end
            for _, p in ipairs(plots:GetChildren()) do
                if p:IsA("Model") then
                    table.insert(M.plotsList, p)
                end
            end
        end

        local function clearAll()
            for _, entry in pairs(M.pool) do
                if entry.bb then pcall(function() entry.bb:Destroy() end) end
            end
            M.pool = {}
            local pg = LP:FindFirstChild("PlayerGui")
            local gui = pg and pg:FindFirstChild("NoxAllowDisallowESP")
            if gui then pcall(function() gui:Destroy() end) end
        end

        local acc = 0
        local function onHeartbeat(dt)
            if not M.enabled then return end
            acc = acc + (dt or 0.016)
            if acc < 0.12 then return end
            acc = 0

            for _, e in pairs(M.pool) do e.used = false end

            if #M.plotsList == 0 then refreshPlotsList() end

            for _, plot in ipairs(M.plotsList) do
                if plot and plot.Parent then
                    local friendPanel = plot:FindFirstChild("FriendPanel")
                    if not friendPanel then
                        friendPanel = plot:FindFirstChild("FriendPanel", true)
                    end
                    if friendPanel then
                        local adornee = getAdornee(friendPanel)
                        if adornee then
                            local entry = getOrCreate(plot.Name, adornee)
                            if entry then
                                local dis = isDisallowed(friendPanel)
                                local txt = dis and "X" or "✓"
                                local col = dis and COL_DISALLOW or COL_ALLOW
                                if entry.lbl.Text ~= txt then entry.lbl.Text = txt end
                                entry.lbl.TextColor3 = col
                                entry.bb.Enabled = true
                                entry.used = true
                            end
                        end
                    end
                end
            end

            for _, e in pairs(M.pool) do
                if not e.used and e.bb and e.bb.Enabled then
                    e.bb.Enabled = false
                end
            end
        end

        local function stopConns()
            if M.conn then pcall(function() M.conn:Disconnect() end) M.conn = nil end
            for _, c in ipairs(M.childConns) do pcall(function() c:Disconnect() end) end
            M.childConns = {}
        end

        function M.set(on)
            M.enabled = on and true or false
            stopConns()
            if not on then
                clearAll()
                return
            end
            refreshPlotsList()
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                table.insert(M.childConns, plots.ChildAdded:Connect(function()
                    task.defer(refreshPlotsList)
                end))
                table.insert(M.childConns, plots.ChildRemoved:Connect(function()
                    task.defer(refreshPlotsList)
                end))
            end
            M.conn = RunService.Heartbeat:Connect(onHeartbeat)
        end

        function M.isEnabled()
            return M.enabled
        end

        return M
    end)()
    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.AllowDisallowESP and _G.AllowDisallowESP.set then
                _G.AllowDisallowESP.set(false)
            end
        end)
    end)

    local Booster = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then
            LocalPlayer = Players.PlayerAdded:Wait()
        end

        local savedSpd, savedJmp = 28, 50
        pcall(function()
            if Config then
                savedSpd = tonumber(Config.get("booster_spd", 28)) or 28
                savedJmp = tonumber(Config.get("booster_jmp", 50)) or 50
            end
        end)

        local B = {
            enabled = false,
            userEnabled = false,
            speed = math.clamp(savedSpd, 16, 200),
            jump = math.clamp(savedJmp, 50, 100),
            _velocity = nil,
            _attachment = nil,
            _jumpConn = nil,
            _loopConn = nil,
            _suspended = false,
            _suspendReasons = {},
        }

        local function Cleanup()
            if B._velocity then
                pcall(function() B._velocity:Destroy() end)
                B._velocity = nil
            end
            if B._attachment then
                pcall(function() B._attachment:Destroy() end)
                B._attachment = nil
            end
            if B._jumpConn then
                pcall(function() B._jumpConn:Disconnect() end)
                B._jumpConn = nil
            end
        end

        local function CreateVelocity(part)
            Cleanup()
            B._attachment = Instance.new("Attachment")
            B._attachment.Name = "NoxBoosterAtt"
            B._attachment.Parent = part
            B._velocity = Instance.new("LinearVelocity")
            B._velocity.Name = "NoxBoosterLV"
            B._velocity.Parent = B._attachment
            B._velocity.Attachment0 = B._attachment
            B._velocity.RelativeTo = Enum.ActuatorRelativeTo.World
            B._velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
            B._velocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
            B._velocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
            B._velocity.PlaneVelocity = Vector2.new(0, 0)
            B._velocity.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
            B._velocity.Enabled = true
        end

        local function SetupJump(hrp, humanoid)
            if B._jumpConn then
                pcall(function() B._jumpConn:Disconnect() end)
                B._jumpConn = nil
            end
            B._jumpConn = humanoid.StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Jumping and B.enabled then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        B.jump,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end)
        end

        local function StartLoop()
            if B._loopConn then return end
            B._loopConn = RunService.Heartbeat:Connect(function()
                if not B.enabled then return end
                if _G._CyutsudSemiTPActive then
                    if B._velocity then
                        B._velocity.PlaneVelocity = Vector2.new(0, 0)
                        B._velocity.Enabled = false
                    end
                    return
                end
                local char = LocalPlayer.Character
                if not char then return end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not (humanoid and hrp) or humanoid.Health <= 0 then return end
                if not (B._velocity and B._attachment and B._attachment.Parent == hrp) then
                    CreateVelocity(hrp)
                end
                if not B._jumpConn then
                    SetupJump(hrp, humanoid)
                end
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0.05 then
                    local unit = Vector3.new(moveDir.X, 0, moveDir.Z)
                    if unit.Magnitude > 0.01 then
                        unit = unit.Unit
                        B._velocity.Enabled = true
                        B._velocity.PlaneVelocity = Vector2.new(unit.X * B.speed, unit.Z * B.speed)
                    end
                else
                    if B._velocity then
                        B._velocity.PlaneVelocity = Vector2.new(0, 0)
                        B._velocity.Enabled = false
                    end
                end
            end)
        end

        local function StopLoop()
            if B._loopConn then
                pcall(function() B._loopConn:Disconnect() end)
                B._loopConn = nil
            end
            Cleanup()
        end

        function B.set(state)
            state = state and true or false
            B.userEnabled = state
            if next(B._suspendReasons) then
                B.enabled = false
                StopLoop()
                return
            end
            B.enabled = state
            if state then
                StartLoop()
            else
                StopLoop()
            end
            pcall(function()
                if Config then
                    Config.set("booster_on", B.userEnabled)
                end
            end)
        end

        function B.suspend(reason)
            reason = reason or "default"
            B._suspendReasons[reason] = true
            B._suspended = true
            B.enabled = false
            StopLoop()
        end

        function B.unsuspend(reason)
            reason = reason or "default"
            B._suspendReasons[reason] = nil
            if not next(B._suspendReasons) then
                B._suspended = false
                if B.userEnabled then
                    B.enabled = true
                    StartLoop()
                end
            end
        end

        function B.setSpeed(value)
            value = tonumber(value) or B.speed
            B.speed = math.clamp(value, 16, 200)
            pcall(function()
                if Config then Config.set("booster_spd", B.speed) end
            end)
        end

        function B.setJump(value)
            value = tonumber(value) or B.jump
            B.jump = math.clamp(value, 50, 100)
            pcall(function()
                if Config then Config.set("booster_jmp", B.jump) end
            end)
        end

        function B.isActive()
            return B.enabled
        end

        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if B.userEnabled and not next(B._suspendReasons) then
                B.enabled = true
                StartLoop()
            end
        end)

        return B
    end)()
    _G.Booster = Booster
    pcall(function()
        getfenv()["Booster"] = Booster
    end)
    rawset(_G, "Booster", Booster)

    _G.coreSelectedCarpet = _G.coreSelectedCarpet or "Flying Carpet"
    _G.carpetSpeedEnabled = false
    _G.autoCarpetSpeedEnabled = false

    _G.CarpetSpeed = (function()
        local RS = game:GetService("RunService")
        local LP = game:GetService("Players").LocalPlayer

        local S = {
            on = false,
            active = false,
            speed = 175,
            conn = nil,
            toolConn = nil,
            wasMoving = false,
            keys = {
                ["Flying Carpet"] = {"flying carpet", "magic carpet", "rainbow carpet", "carpet"},
                ["Cupid's Wings"] = {"cupid", "wings"},
                ["Witch's Broom"] = {"broom", "witch"},
                ["Waverider"] = {"waverider", "wave rider", "wave"},
                ["Santa's Sleigh"] = {"sleigh", "santa"},
            },
            fallback = {"carpet", "broom", "sleigh", "wings", "waverider", "cupid", "witch", "santa"},
        }

        pcall(function()
            if Config then
                local sv = tonumber(Config.get("carpetSpeed", 175))
                if sv then S.speed = math.clamp(sv, 50, 250) end
                local sel = Config.get("selectedCarpet", nil)
                if type(sel) == "string" and sel ~= "" then
                    _G.coreSelectedCarpet = sel
                end
            end
        end)

        local function pref()
            return _G.coreSelectedCarpet or "Flying Carpet"
        end

        local function isMountTool(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = string.lower(tool.Name)
            local p = pref()
            local list = S.keys[p] or S.fallback
            for i = 1, #list do
                if n:find(list[i], 1, true) then return true end
            end
            for i = 1, #S.fallback do
                if n:find(S.fallback[i], 1, true) then return true end
            end
            return false
        end

        local function findMount(container)
            if not container then return nil end
            local p = pref()
            local list = S.keys[p] or { string.lower(tostring(p)) }
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") then
                    local n = string.lower(t.Name)
                    for j = 1, #list do
                        if n:find(list[j], 1, true) then return t end
                    end
                end
            end
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") and isMountTool(t) then return t end
            end
            return nil
        end

        local function equippedMount(char)
            if not char then return nil end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and isMountTool(t) then return t end
            end
            return nil
        end

        local function stopLoop()
            if S.conn then pcall(function() S.conn:Disconnect() end) S.conn = nil end
            if S.toolConn then pcall(function() S.toolConn:Disconnect() end) S.toolConn = nil end
            S.wasMoving = false
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end)
            end
            local bp = LP:FindFirstChild("Backpack")
            local mount = equippedMount(char)
            if mount and bp then
                pcall(function() mount.Parent = bp end)
            end
        end

        local function startLoop()
            stopLoop()
            local acc = 0
            local char = LP.Character
            if char then
                S.toolConn = char.ChildAdded:Connect(function(child)
                    if not S.on then return end
                    if child:IsA("Tool") and not isMountTool(child) then
                        local n = string.lower(child.Name)
                        if not (n:find("potion") or n:find("giant") or n:find("grow")) then
                            S.active = false
                            stopLoop()
                            if Booster and Booster.unsuspend then
                                pcall(function() Booster.unsuspend("carpet") end)
                            end
                        end
                    end
                end)
            end

            S.conn = RS.Heartbeat:Connect(function(dt)
                if not S.on then return end
                acc = acc + (dt or 0.016)
                if acc < 0.016 then return end
                acc = 0

                local okSteal, stealing = pcall(function()
                    return LP:GetAttribute("Stealing") == true
                end)
                if okSteal and stealing then return end

                local ch = LP.Character
                if not ch then return end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end

                if not equippedMount(ch) then
                    local bp = LP:FindFirstChild("Backpack")
                    local tool = findMount(bp)
                    if tool then
                        pcall(function() hum:EquipTool(tool) end)
                    end
                end

                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    local unit = Vector3.new(md.X, 0, md.Z)
                    if unit.Magnitude > 0.01 then
                        unit = unit.Unit
                        hrp.Velocity = Vector3.new(
                            unit.X * S.speed,
                            hrp.Velocity.Y,
                            unit.Z * S.speed
                        )
                        S.wasMoving = true
                    end
                elseif S.wasMoving then
                    S.wasMoving = false
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end
            end)
        end

        local function startCS()
            S.on = true
            S.active = true
            _G.carpetSpeedEnabled = true
            if Booster and Booster.suspend then
                pcall(function() Booster.suspend("carpet") end)
            end
            pcall(function()
                if Config then
                    local sv = tonumber(Config.get("carpetSpeed", 175))
                    if sv then S.speed = math.clamp(sv, 50, 250) end
                end
            end)
            startLoop()
        end

        local function stopCS()
            S.on = false
            S.active = false
            _G.carpetSpeedEnabled = false
            stopLoop()
            if Booster and Booster.unsuspend then
                pcall(function() Booster.unsuspend("carpet") end)
            end
        end

        LP.CharacterAdded:Connect(function()
            if not S.on then return end
            task.wait(0.5)
            if S.on then startLoop() end
        end)

        return {
            set = function(on)
                if on then startCS() else stopCS() end
            end,
            setSpeed = function(val)
                val = tonumber(val) or S.speed
                S.speed = math.clamp(val, 50, 250)
                pcall(function()
                    if Config then Config.set("carpetSpeed", S.speed) end
                end)
            end,
            getSpeed = function()
                return S.speed
            end,
            isOn = function()
                return S.on
            end,
        }
    end)()

    _G.AutoCarpetSpeed = (function()
        local RS = game:GetService("RunService")
        local LP = game:GetService("Players").LocalPlayer
        local ACS = {
            on = false,
            conn = nil,
            wasMoving = false,
            boostActive = false,
        }

        local KEYS = {
            ["Flying Carpet"] = {"flying carpet", "magic carpet", "rainbow carpet", "carpet"},
            ["Cupid's Wings"] = {"cupid", "wings"},
            ["Witch's Broom"] = {"broom", "witch"},
            ["Waverider"] = {"waverider", "wave rider", "wave"},
            ["Santa's Sleigh"] = {"sleigh", "santa"},
        }

        local function prefName()
            return _G.coreSelectedCarpet or "Flying Carpet"
        end

        local function getSpeed()
            local v = 175
            if _G.CarpetSpeed and _G.CarpetSpeed.getSpeed then
                local ok, s = pcall(_G.CarpetSpeed.getSpeed)
                if ok and type(s) == "number" then v = s end
            elseif Config then
                local ok, s = pcall(function() return tonumber(Config.get("carpetSpeed", 175)) end)
                if ok and s then v = s end
            end
            return math.clamp(tonumber(v) or 175, 50, 250)
        end

        local function matchesSelected(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = string.lower(tool.Name or "")
            local p = prefName()
            local list = KEYS[p]
            if list then
                for i = 1, #list do
                    if n:find(list[i], 1, true) then return true end
                end
            end
            local lowP = string.lower(tostring(p))
            if lowP ~= "" and n:find(lowP, 1, true) then return true end
            return false
        end

        local function equippedSelected(char)
            if not char then return nil end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and matchesSelected(t) then return t end
            end
            return nil
        end

        local function clearVelocity()
            local ch = LP.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end)
            end
            ACS.wasMoving = false
            ACS.boostActive = false
            if Booster and Booster.unsuspend then
                pcall(function() Booster.unsuspend("auto_carpet") end)
            end
        end

        local function stopACS()
            ACS.on = false
            _G.autoCarpetSpeedEnabled = false
            if ACS.conn then
                pcall(function() ACS.conn:Disconnect() end)
                ACS.conn = nil
            end
            clearVelocity()
        end

        local function startACS()
            if ACS.on then return end
            ACS.on = true
            _G.autoCarpetSpeedEnabled = true
            ACS.wasMoving = false
            ACS.boostActive = false
            if ACS.conn then pcall(function() ACS.conn:Disconnect() end) ACS.conn = nil end

            local acc = 0
            ACS.conn = RS.Heartbeat:Connect(function(dt)
                if not ACS.on then return end
                if _G.carpetSpeedEnabled then
                    ACS.boostActive = false
                    return
                end

                acc = acc + (dt or 0.016)
                if acc < 0.016 then return end
                acc = 0

                local ch = LP.Character
                if not ch then
                    if ACS.boostActive then clearVelocity() end
                    return
                end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end

                local held = equippedSelected(ch)
                if not held then
                    if ACS.boostActive then clearVelocity() end
                    return
                end

                if not ACS.boostActive then
                    ACS.boostActive = true
                    if Booster and Booster.suspend then
                        pcall(function() Booster.suspend("auto_carpet") end)
                    end
                end

                local okSteal, stealing = pcall(function()
                    return LP:GetAttribute("Stealing") == true
                end)
                if okSteal and stealing then return end

                local speed = getSpeed()
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    local unit = Vector3.new(md.X, 0, md.Z)
                    if unit.Magnitude > 0.01 then
                        unit = unit.Unit
                        hrp.Velocity = Vector3.new(
                            unit.X * speed,
                            hrp.Velocity.Y,
                            unit.Z * speed
                        )
                        ACS.wasMoving = true
                    end
                elseif ACS.wasMoving then
                    ACS.wasMoving = false
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end
            end)
        end

        return {
            set = function(on)
                if on then startACS() else stopACS() end
            end,
            isOn = function()
                return ACS.on
            end,
        }
    end)()

    _G.QuickAdminPanel = (function()
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local LP = Players.LocalPlayer
        if not LP then
            return { set = function() end, isEnabled = function() return false end, markCommand = function() end }
        end

        local function n(class, props, parent)
            local o = Instance.new(class)
            if props then for k, v in pairs(props) do o[k] = v end end
            if parent then o.Parent = parent end
            return o
        end

        local BASE_W, BASE_H, TITLE_H, ROW_H, BTN = 380, 78, 28, 32, 28
        local CD = {
            balloon = 29, tiny = 59, jail = 59, rocket = 119, ragdoll = 29,
        }
        local EMOJIS = { "�", "�", "�", "�‍♂️", "�" }
        local EMOJI_CMD = {
            ["�"] = "tiny", ["�"] = "jail", ["�"] = "rocket",
            ["�‍♂️"] = "ragdoll", ["�"] = "balloon",
        }

        local M = {
            enabled = false, gui = nil, panel = nil, scroll = nil,
            content = nil, minBtn = nil, minimized = false,
            conns = {}, cdUntil = {},
            themeNodes = {},
        }

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end
        local function colBg()
            if T and typeof(T.Bg) == "Color3" then return T.Bg end
            return Color3.fromRGB(18, 16, 14)
        end
        local function colDeep()
            if T and typeof(T.BgDeep) == "Color3" then return T.BgDeep end
            return Color3.fromRGB(12, 10, 9)
        end
        local function colText()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(250, 245, 235)
        end
        local function colDim()
            if T and typeof(T.TextDim) == "Color3" then return T.TextDim end
            return Color3.fromRGB(160, 140, 120)
        end
        local function colSoft()
            if T and typeof(T.Soft) == "Color3" then return T.Soft end
            return Color3.fromRGB(34, 28, 22)
        end

        local function clearConns()
            for i = 1, #M.conns do
                pcall(function() M.conns[i]:Disconnect() end)
            end
            M.conns = {}
        end

        local function drag(handle, target)
            local on, a0, p0 = false, nil, nil
            handle.Active = true
            handle.InputBegan:Connect(function(inp)
                if _G._FH_GuiLocked then return end
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    on, a0, p0 = true, inp.Position, target.Position
                    p0 = target.Position
                    inp.Changed:Connect(function()
                        if inp.UserInputState == Enum.UserInputState.End then
                            on = false
                            pcall(function()
                                if saveGuiPosition then
                                    saveGuiPosition("PanelGui_CyutsudQuickPanel", target)
                                elseif Config then
                                    local positions = Config.get("positions", {}) or {}
                                    positions["PanelGui_CyutsudQuickPanel"] = {
                                        target.Position.X.Scale, target.Position.X.Offset,
                                        target.Position.Y.Scale, target.Position.Y.Offset,
                                    }
                                    Config.set("positions", positions)
                                end
                            end)
                        end
                    end)
                end
            end)
            UIS.InputChanged:Connect(function(inp)
                if not on then return end
                if _G._FH_GuiLocked then on = false; return end
                if inp.UserInputType ~= Enum.UserInputType.MouseMovement
                    and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                local __p = inp.Position; local __s = a0; local d = Vector2.new((typeof(__p)=="Vector3" and __p.X or __p.X) - (typeof(__s)=="Vector3" and __s.X or (__s and __s.X) or 0), (typeof(__p)=="Vector3" and __p.Y or __p.Y) - (typeof(__s)=="Vector3" and __s.Y or (__s and __s.Y) or 0))
                local sc = target:FindFirstChildOfClass("UIScale")
                local scale = (sc and tonumber(sc.Scale)) or 1
                if scale < 0.05 then scale = 1 end
                target.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X / scale, p0.Y.Scale, p0.Y.Offset + d.Y / scale)
            end)
        end

        local function fireCmd(cmd, target)
            if not target or not cmd then return end
            local fn = _G.qapRunCommand
            if type(fn) == "function" then
                pcall(fn, cmd, target)
            end
            pcall(function()
                if showToast then
                    showToast(cmd .. " → " .. target.Name, true)
                end
            end)
        end

        local function fitHeight(count)
            if not M.panel or M.minimized then return end
            local h = (count <= 1) and BASE_H or (BASE_H + (count - 1) * (ROW_H + 4))
            h = math.clamp(h, BASE_H, 400)
            M.panel.Size = UDim2.fromOffset(BASE_W, h)
        end

        local function otherCount()
            local c = 0
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then c = c + 1 end
            end
            return c
        end

        local function isOnCD(uid, cmd)
            cmd = string.lower(tostring(cmd or ""))
            -- Sync with Command Cooldowns GUI / AdminPanel global CD
            local globalCd = false
            pcall(function()
                if _G._FH_CD_ONCD and _G._FH_CD_ONCD[cmd] then globalCd = true end
            end)
            if globalCd then return true end
            pcall(function()
                if _G.DataManager and type(_G.DataManager.isOnCooldown) == "function" then
                    if _G.DataManager.isOnCooldown(cmd) then globalCd = true end
                end
            end)
            if globalCd then return true end
            local t = M.cdUntil[uid]
            if not t then return false end
            local untilT = t[cmd]
            return untilT and tick() < untilT
        end

        local function paintBtn(btn, uid, cmd)
            if isOnCD(uid, cmd) then
                btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
                btn.TextColor3 = Color3.fromRGB(255, 220, 220)
                return true
            end
            local p = M.themeNodes.primary or colPrimary()
            btn.BackgroundColor3 = Color3.new(
                math.clamp(p.R * 0.45, 0, 1),
                math.clamp(p.G * 0.45, 0, 1),
                math.clamp(p.B * 0.55, 0, 1)
            )
            btn.TextColor3 = colText()
            return false
        end

        local function startCD(uid, cmd)
            local sec = CD[cmd]
            if not sec then return end
            if not M.cdUntil[uid] then M.cdUntil[uid] = {} end
            M.cdUntil[uid][cmd] = tick() + sec
        end

        M.startCD = startCD
        M.cdTable = CD
        M.getCdUntil = function() return M.cdUntil end
        M.markCommand = function(cmd, targetPlayer)
            if not cmd then return end
            local sec = CD[cmd] or 30
            local uid = targetPlayer and targetPlayer.UserId
            if uid then
                if not M.cdUntil[uid] then M.cdUntil[uid] = {} end
                M.cdUntil[uid][cmd] = tick() + sec
            end
            if _G._FH_CD_ONCD then
                _G._FH_CD_ONCD[cmd] = true
                task.delay(sec, function()
                    if _G._FH_CD_ONCD then _G._FH_CD_ONCD[cmd] = nil end
                end)
            end
        end

        local function applyTheme(primary)
            primary = primary or colPrimary()
            M.themeNodes.primary = primary
            local tn = M.themeNodes
            if tn.panel then
                pcall(function() tn.panel.BackgroundColor3 = colBg() end)
            end
            if tn.title then
                pcall(function() tn.title.BackgroundColor3 = colDeep() end)
            end
            if tn.minBtn then
                pcall(function() tn.minBtn.BackgroundColor3 = colSoft() end)
            end
            if tn.strokeGrad then
                pcall(function()
                    tn.strokeGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, primary),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                    })
                end)
            end
            if M.scroll then
                for _, row in ipairs(M.scroll:GetChildren()) do
                    if row:IsA("Frame") then
                        for _, d in ipairs(row:GetDescendants()) do
                            if d:IsA("TextButton") and d.Text ~= "" then
                                local cmd = EMOJI_CMD[d.Text]
                                if cmd then
                                    local uid = tonumber(row.Name:match("P_(%d+)"))
                                    if uid then paintBtn(d, uid, cmd) end
                                end
                            end
                        end
                    end
                end
            end
        end

        local function buildRow(plr, parent)
            local uid = plr.UserId
            local row = n("Frame", {
                Name = "P_" .. uid,
                Size = UDim2.new(1, 0, 0, ROW_H),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
            }, parent)

            local av = n("ImageLabel", {
                Size = UDim2.fromOffset(24, 24),
                Position = UDim2.new(0, 0, 0.5, -12),
                BackgroundTransparency = 1,
            }, row)
            n("UICorner", { CornerRadius = UDim.new(1, 0) }, av)
            task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                end)
                if ok and img and av.Parent then av.Image = img end
            end)

            n("TextLabel", {
                Size = UDim2.new(0.42, -28, 1, 0),
                Position = UDim2.new(0, 30, 0, 0),
                BackgroundTransparency = 1,
                Text = ("%s (@%s)"):format(plr.DisplayName, plr.Name),
                TextColor3 = colText(),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, row)

            local btnRow = n("Frame", {
                Size = UDim2.new(0.58, -4, 1, 0),
                Position = UDim2.new(0.42, 0, 0, 0),
                BackgroundTransparency = 1,
            }, row)
            n("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 4),
            }, btnRow)

            for _, emoji in ipairs(EMOJIS) do
                local cmd = EMOJI_CMD[emoji]
                local b = n("TextButton", {
                    Size = UDim2.fromOffset(BTN, BTN),
                    BackgroundColor3 = colSoft(),
                    Text = emoji,
                    TextColor3 = colText(),
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    AutoButtonColor = false,
                }, btnRow)
                n("UICorner", { CornerRadius = UDim.new(0, 12) }, b)
                local st = n("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.45 }, b)
                pcall(function()
                    local g = Instance.new("UIGradient")
                    g.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, colPrimary()),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                    })
                    g.Rotation = 120
                    g.Parent = st
                end)

                paintBtn(b, uid, cmd)
                task.spawn(function()
                    while b.Parent do
                        local busy = paintBtn(b, uid, cmd)
                        task.wait(busy and 0.2 or 0.7)
                    end
                end)

                b.Activated:Connect(function()
                    if not cmd then return end
                    if isOnCD(uid, cmd) then return end
                    startCD(uid, cmd)
                    paintBtn(b, uid, cmd)
                    fireCmd(cmd, plr)
                end)
                b.MouseButton1Click:Connect(function()
                    if not cmd then return end
                    if isOnCD(uid, cmd) then return end
                    startCD(uid, cmd)
                    paintBtn(b, uid, cmd)
                    fireCmd(cmd, plr)
                end)
            end
        end

        local function populate()
            if not M.scroll then return end
            for _, ch in ipairs(M.scroll:GetChildren()) do
                if ch:IsA("Frame") or (ch:IsA("TextLabel") and ch.Name == "Empty") then
                    ch:Destroy()
                end
            end
            local list = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then list[#list + 1] = p end
            end
            table.sort(list, function(a, b)
                return (a.DisplayName or a.Name):lower() < (b.DisplayName or b.Name):lower()
            end)
            if #list == 0 then
                n("TextLabel", {
                    Name = "Empty",
                    Size = UDim2.new(1, 0, 0, ROW_H),
                    BackgroundTransparency = 1,
                    Text = "Aucun autre joueur",
                    TextColor3 = colDim(),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                }, M.scroll)
            else
                for i = 1, #list do
                    buildRow(list[i], M.scroll)
                end
            end
            fitHeight(#list)
        end

        local function buildPanel()
            if M.gui and M.gui.Parent then return end
            for _, name in ipairs({ "PanelGui_CyutsudQuickPanel", "PanelGui_Admin Panel" }) do
                pcall(function()
                    local pg = LP:FindFirstChild("PlayerGui")
                    local old = pg and pg:FindFirstChild(name)
                    if old then old:Destroy() end
                end)
            end

            local gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_CyutsudQuickPanel"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 230
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = false
            M.gui = gui

            local parented = false
            pcall(function()
                if typeof(gethui) == "function" then
                    gui.Parent = gethui()
                    parented = gui.Parent ~= nil
                end
            end)
            if not parented then
                pcall(function()
                    gui.Parent = game:GetService("CoreGui")
                    parented = gui.Parent ~= nil
                end)
            end
            if not parented then
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                if pg then gui.Parent = pg end
            end

            local panel = n("Frame", {
                Name = "Frame",
                Size = UDim2.fromOffset(BASE_W, BASE_H),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = colBg(),
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Active = true,
            }, gui)
            M.panel = panel
            n("UICorner", { CornerRadius = UDim.new(0, 12) }, panel)

            pcall(function()
                if loadGuiPosition then loadGuiPosition("PanelGui_CyutsudQuickPanel", panel) end
            end)

            local stroke = n("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                Thickness = 1.3,
            }, panel)
            local strokeGrad = n("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colPrimary()),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                }),
                Rotation = 200,
            }, stroke)

            local title = n("Frame", {
                Size = UDim2.new(1, 0, 0, TITLE_H),
                BackgroundColor3 = colDeep(),
                BorderSizePixel = 0,
                Active = true,
            }, panel)
            n("UICorner", { CornerRadius = UDim.new(0, 12) }, title)
            n("TextLabel", {
                Size = UDim2.new(1, -36, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = "Quick Admin",
                TextColor3 = colText(),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, title)

            local minBtn = n("TextButton", {
                Name = "Min",
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -24, 0.5, -10),
                BackgroundColor3 = colSoft(),
                Text = "–",
                TextColor3 = colText(),
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
            }, title)
            n("UICorner", { CornerRadius = UDim.new(1, 0) }, minBtn)
            M.minBtn = minBtn

            pcall(function()
                local style = _G._CyutsudStyleLikeHub
                if style then style(panel, title) end
            end)

            local content = n("Frame", {
                Name = "Content",
                Size = UDim2.new(1, 0, 1, -TITLE_H),
                Position = UDim2.new(0, 0, 0, TITLE_H),
                BackgroundTransparency = 1,
            }, panel)
            M.content = content
            n("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 4),
            }, content)

            local scroll = n("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                ScrollBarImageTransparency = 0.3,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y,
            }, content)
            M.scroll = scroll
            n("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, scroll)

            M.themeNodes = {
                panel = panel, title = title, minBtn = minBtn,
                strokeGrad = strokeGrad, primary = colPrimary(),
            }

            pcall(function()
                local d = _G.makePanelDraggable or makePanelDraggable
                if d then d(title, panel, "PanelGui_CyutsudQuickPanel") end
            end)

            minBtn.Activated:Connect(function()
                M.minimized = not M.minimized
                content.Visible = not M.minimized
                if M.minimized then
                    panel.Size = UDim2.fromOffset(BASE_W, TITLE_H)
                    minBtn.Text = "+"
                else
                    minBtn.Text = "–"
                    fitHeight(otherCount())
                end
            end)

            applyTheme(colPrimary())
            populate()
        end

        function M.set(on)
            M.enabled = on and true or false
            if M.enabled then
                if not M.gui or not M.gui.Parent then buildPanel() end
                if M.gui then M.gui.Enabled = true end
                clearConns()
                table.insert(M.conns, Players.PlayerAdded:Connect(function()
                    task.wait(0.12)
                    if M.enabled then populate() end
                end))
                table.insert(M.conns, Players.PlayerRemoving:Connect(function(p)
                    if p then M.cdUntil[p.UserId] = nil end
                    task.wait(0.12)
                    if M.enabled then populate() end
                end))
                populate()
                applyTheme(colPrimary())
            else
                clearConns()
                if M.gui then M.gui.Enabled = false end
            end
            pcall(function()
                if Config then Config.set("quick_admin_panel_visible", M.enabled) end
            end)
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.repaint()
            applyTheme(colPrimary())
        end

        task.defer(function()
            pcall(buildPanel)
            if M.gui then M.gui.Enabled = false end
        end)

        return M
    end)()

    _G.coreSpamWave = _G.coreSpamWave or 1
    _G.coreSpammerConfig = _G.coreSpammerConfig or {}

    pcall(function()
        if Config then
            local saved = Config.get("spammer", nil)
            if type(saved) == "table" and next(saved) then
                _G.coreSpammerConfig = saved
            end
        end
    end)

    _G.executeSpamOnTarget = function(target, mode)
        if not target then
            pcall(function()
                if showToast then showToast("Spam: aucune cible", false) end
            end)
            return
        end

        local cfg = _G.coreSpammerConfig or {}
        local defaults = { "rocket", "ragdoll", "balloon", "inverse", "nightvision", "jail", "tiny", "jumpscare", "morph" }

        local function fireWave(wave)
            local commandsToFire = {}
            if type(cfg) == "table" and next(cfg) then
                for cmd, slot in pairs(cfg) do
                    if slot == wave then
                        table.insert(commandsToFire, tostring(cmd))
                    end
                end
            end
            if #commandsToFire == 0 and wave == 1 then
                for _, c in ipairs(defaults) do table.insert(commandsToFire, c) end
            end
            table.sort(commandsToFire)
            for _, cmdName in ipairs(commandsToFire) do
                pcall(function()
                    if _G.qapRunCommand then
                        _G.qapRunCommand(cmdName, target)
                    end
                end)
                task.wait(0.3)
            end
        end

        if mode == "full" then
            fireWave(1)
            task.wait(0.06)
            fireWave(2)
            _G.coreSpamWave = 1
        elseif mode == "semi" then
            fireWave(1)
            _G.coreSpamWave = 1
        else
            local wave = _G.coreSpamWave or 1
            if wave ~= 1 and wave ~= 2 then wave = 1 end
            fireWave(wave)
            _G.coreSpamWave = (wave == 1) and 2 or 1
        end

        pcall(function()
            if showToast then
                showToast("Spam W" .. tostring(_G.coreSpamWave or 1) .. " → " .. target.Name, true)
            end
        end)
        pcall(function()
            if _G.AdminSpammer and _G.AdminSpammer._refreshSpamLabel then
                _G.AdminSpammer._refreshSpamLabel()
                return
            end
            local gui = _G._FH_AdminSpammerGui
            local lbl = gui and gui:FindFirstChild("SpamLabel", true)
            if lbl then lbl.Text = "Spam (W" .. tostring(_G.coreSpamWave or 1) .. ")" end
        end)
    end

    _G.AdminSpammer = (function()
        --[[
            Admin Spammer (EKUSO fire + CYUTSUD config slots)
            - Exécution = vrai AdminPanel, fireClick, Timer réel
            - Config slots = 0 / 1 / 2, save JSON
            - Vague 1 = Semi, Vague 2 = Full
            - RightShift toggle + hub toggle via .set()
        ]]
        local Players           = game:GetService("Players")
        local UIS               = game:GetService("UserInputService")
        local HttpService       = game:GetService("HttpService")

        local player = Players.LocalPlayer
        if not player then
            return { set = function() end, isEnabled = function() return false end }
        end
        local playerGui = player:WaitForChild("PlayerGui", 10) or player:FindFirstChildOfClass("PlayerGui")

        local SPAM_CMDS = {
            "rocket", "ragdoll", "balloon", "inverse", "nightvision",
            "jail", "tiny", "jumpscare", "morph",
        }
        local COOLDOWNS = {
            ragdoll = 30, jail = 60, rocket = 120, balloon = 30, inverse = 30,
            jumpscare = 30, tiny = 30, morph = 30, nightvision = 30, control = 30,
        }
        local DEFAULT_WAVE1 = { rocket = 1, ragdoll = 1, balloon = 1, inverse = 1 }
        local CONFIG_FILE   = "AdminSpammer_config.json"

        local spamCfg  = {}
        local spamWave = 1
        local apDelay  = 0
        local lastUse  = {}

        -- Deep copy table (évite le bug _deepEq qui skip si même référence mutée)
        local function _copySpamMap(src)
            local out = {}
            if type(src) == "table" then
                for k, v in pairs(src) do
                    out[k] = v
                end
            end
            return out
        end

        local function _cfgGet(key, default)
            local v = nil
            pcall(function()
                if type(Config) == "table" and Config.get then
                    v = Config.get(key, nil)
                end
            end)
            if v == nil then
                pcall(function()
                    if _G.CyutsudHubConfig and _G.CyutsudHubConfig.get then
                        v = _G.CyutsudHubConfig.get(key, nil)
                    end
                end)
            end
            if v == nil then return default end
            return v
        end

        -- Même style que setToggleSaved : écriture directe + flush immédiat
        local function _cfgForceSet(key, value)
            pcall(function()
                if type(Config) ~= "table" then return end
                Config.data = Config.data or {}
                Config.data[key] = value
                Config._dirty = true
                if Config.flush then
                    Config.flush()
                elseif Config.save then
                    Config.save()
                elseif Config.set then
                    -- fallback si pas de flush
                    Config.set(key, value)
                end
            end)
        end

        local function _slotVal(v)
            -- normalize saved slot: 0 / 1 / 2 only
            local n = tonumber(v)
            if n == 1 or n == 2 then return n end
            if n == 0 then return 0 end
            if v == true then return 1 end
            return nil
        end

        local function loadConfig()
            local data = {}
            local hasSavedSlots = false

            -- 1) Priorité : config hub CyutsudHub
            pcall(function()
                local hubSp = _cfgGet("spammer", nil)
                if type(hubSp) == "table" then
                    data.spammer = hubSp
                end
                local w = tonumber(_cfgGet("spamWave", nil))
                if w == 1 or w == 2 then data.spamWave = w end
                local d = _cfgGet("apDelay", nil)
                if type(d) == "number" then data.apDelay = d end
                if data.spammer == nil then
                    local alt = _cfgGet("admin_spammer_cfg", nil)
                    if type(alt) == "table" then
                        data.spammer = alt.spammer or alt
                        local aw = tonumber(alt.spamWave)
                        if aw == 1 or aw == 2 then data.spamWave = aw end
                        if type(alt.apDelay) == "number" then data.apDelay = alt.apDelay end
                    end
                end
            end)

            -- 2) Fallback / merge fichier local AdminSpammer_config.json
            pcall(function()
                if not (isfile and isfile(CONFIG_FILE) and readfile) then return end
                local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE)) or {}
                if type(decoded) ~= "table" then return end
                if type(decoded.spammer) == "table" then
                    if type(data.spammer) ~= "table" then
                        data.spammer = decoded.spammer
                    else
                        for k, v in pairs(decoded.spammer) do
                            if data.spammer[k] == nil then
                                data.spammer[k] = v
                            end
                        end
                    end
                end
                if data.spamWave ~= 1 and data.spamWave ~= 2 then
                    local dw = tonumber(decoded.spamWave)
                    if dw == 1 or dw == 2 then data.spamWave = dw end
                end
                if data.apDelay == nil and type(decoded.apDelay) == "number" then
                    data.apDelay = decoded.apDelay
                end
            end)

            -- 3) Legacy flat keys
            pcall(function()
                if type(data.spammer) ~= "table" then data.spammer = {} end
                for _, cmd in ipairs(SPAM_CMDS) do
                    if data.spammer[cmd] == nil then
                        local flat = _cfgGet("admin_spam_cmd_" .. cmd, nil)
                        local n = _slotVal(flat)
                        if n ~= nil then data.spammer[cmd] = n end
                    end
                end
            end)

            spamCfg = {}
            local saved = type(data.spammer) == "table" and data.spammer or {}
            for _, cmd in ipairs(SPAM_CMDS) do
                local n = _slotVal(saved[cmd])
                if n ~= nil then
                    spamCfg[cmd] = n
                    hasSavedSlots = true
                elseif DEFAULT_WAVE1[cmd] then
                    spamCfg[cmd] = 1
                else
                    spamCfg[cmd] = 0
                end
            end
            if type(saved) == "table" then
                for _, cmd in ipairs(SPAM_CMDS) do
                    if _slotVal(saved[cmd]) ~= nil then
                        hasSavedSlots = true
                        break
                    end
                end
            end
            spamWave = (tonumber(data.spamWave) == 2) and 2 or 1
            if type(data.apDelay) == "number" and data.apDelay >= 0 then
                apDelay = data.apDelay
            else
                apDelay = 0
            end
            _G._CyutsudSpamCfgLoaded = hasSavedSlots
        end

        local function persistSpamCfg()
            local cfgCopy = {}
            for _, cmd in ipairs(SPAM_CMDS) do
                local n = _slotVal(spamCfg[cmd])
                cfgCopy[cmd] = (n ~= nil) and n or 0
            end
            local waveCopy = (tonumber(spamWave) == 2) and 2 or 1
            local delayCopy = tonumber(apDelay) or 0

            _cfgForceSet("spammer", cfgCopy)
            _cfgForceSet("spamWave", waveCopy)
            _cfgForceSet("apDelay", delayCopy)
            _cfgForceSet("admin_spammer_cfg", {
                spammer = cfgCopy,
                spamWave = waveCopy,
                apDelay = delayCopy,
            })
            for _, cmd in ipairs(SPAM_CMDS) do
                _cfgForceSet("admin_spam_cmd_" .. cmd, cfgCopy[cmd])
            end

            pcall(function()
                if writefile then
                    local payload = HttpService:JSONEncode({
                        spammer  = cfgCopy,
                        spamWave = waveCopy,
                        apDelay  = delayCopy,
                    })
                    writefile(CONFIG_FILE, payload)
                    pcall(function()
                        if makefolder and not (isfolder and isfolder("CyutsudHub")) then
                            makefolder("CyutsudHub")
                        end
                        writefile("CyutsudHub/AdminSpammer_config.json", payload)
                    end)
                end
            end)

            pcall(function()
                if type(Config) == "table" then
                    Config.data = Config.data or {}
                    Config.data["spammer"] = cfgCopy
                    Config.data["spamWave"] = waveCopy
                    Config.data["apDelay"] = delayCopy
                    Config._dirty = true
                    if Config.flush then Config.flush()
                    elseif Config.save then Config.save() end
                end
            end)

            _G.CyutsudHubSpammerConfig = cfgCopy
            _G.CyutsudHubSpamWave = waveCopy
            _G.coreSpammerConfig = cfgCopy
            _G.coreSpamWave = waveCopy
            spamCfg = cfgCopy
        end

        loadConfig()
        pcall(function()
            if not _G._CyutsudSpamCfgLoaded then
                persistSpamCfg()
            end
        end)
        _G.CyutsudHubSpammerConfig = spamCfg
        _G.CyutsudHubSpamWave = spamWave
        _G.coreSpammerConfig = spamCfg
        _G.coreSpamWave = spamWave

        local function cmdsForWave(wave)
            local list = {}
            for _, cmd in ipairs(SPAM_CMDS) do
                if spamCfg[cmd] == wave then
                    table.insert(list, cmd)
                end
            end
            if #list == 0 and wave == 1 then
                for _, cmd in ipairs(SPAM_CMDS) do
                    if DEFAULT_WAVE1[cmd] then table.insert(list, cmd) end
                end
            end
            return list
        end

        local function readRealTimer(cmd)
            if not playerGui then return nil end
            local g = playerGui:FindFirstChild("AdminPanel")
            if not g then return nil end
            local ok, content = pcall(function()
                return g.AdminPanel.Content.ScrollingFrame
            end)
            if not ok or not content then return nil end
            local cmdBtn = content:FindFirstChild(cmd)
            if not cmdBtn then return nil end
            local timer = cmdBtn:FindFirstChild("Timer")
            if not timer then return 0 end
            if timer:IsA("GuiObject") and not timer.Visible then return 0 end
            return tonumber(tostring(timer.Text):match("%d+")) or 0
        end

        local function remaining(cmd)
            local rt = readRealTimer(cmd)
            if rt ~= nil then return rt end
            local l = lastUse[cmd]
            if not l then return 0 end
            return math.max(0, (COOLDOWNS[cmd] or 0) - (tick() - l))
        end

        local function onCooldown(cmd) return remaining(cmd) > 0 end
        local function markUsed(cmd) lastUse[cmd] = tick() end

        local function fireClick(btn)
            if not btn then return end
            pcall(function()
                for _, conn in ipairs(getconnections and getconnections(btn.MouseButton1Click) or {}) do
                    pcall(function() conn:Fire() end)
                end
            end)
            pcall(function()
                for _, conn in ipairs(getconnections and getconnections(btn.Activated) or {}) do
                    pcall(function() conn:Fire() end)
                end
            end)
            pcall(function() btn.MouseButton1Click:Fire() end)
        end

        local function runAdminCommand(targetPlayer, commandName)
            if not targetPlayer or not commandName then return false end
            if onCooldown(commandName) then return false end
            if not playerGui then return false end

            local g = playerGui:FindFirstChild("AdminPanel")
                or playerGui:WaitForChild("AdminPanel", 3)
            if not g then
                warn("[AdminSpammer] AdminPanel not found")
                return false
            end

            local wasEnabled = g.Enabled
            g.Enabled = true

            local okC, content = pcall(function()
                return g.AdminPanel.Content.ScrollingFrame
            end)
            if not okC or not content then
                g.Enabled = wasEnabled
                return false
            end

            local cmdBtn = content:FindFirstChild(commandName)
            if not cmdBtn then
                g.Enabled = wasEnabled
                return false
            end
            fireClick(cmdBtn)
            if apDelay > 0 then task.wait(apDelay) end

            local okP, profiles = pcall(function()
                return g.AdminPanel.Profiles.ScrollingFrame
            end)
            if not okP or not profiles then
                g.Enabled = wasEnabled
                return false
            end

            local pBtn = profiles:FindFirstChild(targetPlayer.Name)
            if not pBtn then
                for _, ch in ipairs(profiles:GetChildren()) do
                    if ch:IsA("GuiButton") then
                        local nl = ch:FindFirstChildWhichIsA("TextLabel")
                        if nl and (nl.Text == targetPlayer.Name or nl.Text == targetPlayer.DisplayName) then
                            pBtn = ch
                            break
                        end
                    end
                end
            end
            if not pBtn then
                g.Enabled = wasEnabled
                return false
            end

            fireClick(pBtn)
            markUsed(commandName)
            task.delay(0.05, function()
                if g and g.Parent then g.Enabled = wasEnabled end
            end)
            return true
        end

        _G.qapRunCommand = function(commandName, target)
            return runAdminCommand(target, commandName)
        end

        local setStatus
        local function executeSpamOnTarget(target, wave)
            if not target then return end
            wave = wave or spamWave
            local cmds = cmdsForWave(wave)
            task.spawn(function()
                local fired = 0
                for _, cmd in ipairs(cmds) do
                    if not onCooldown(cmd) then
                        if runAdminCommand(target, cmd) then
                            fired = fired + 1
                        end
                    end
                end
                if setStatus then
                    setStatus(fired > 0
                        and (fired .. " → " .. target.DisplayName)
                        or "all on cooldown")
                end
            end)
        end

        local C = {
            bg     = Color3.fromRGB(26, 27, 33),
            bar    = Color3.fromRGB(32, 33, 40),
            row    = Color3.fromRGB(37, 38, 46),
            btn    = Color3.fromRGB(46, 47, 56),
            green  = Color3.fromRGB(58, 190, 120),
            red    = Color3.fromRGB(200, 70, 70),
            text   = Color3.fromRGB(232, 235, 240),
            dim    = Color3.fromRGB(150, 155, 165),
            purple = Color3.fromRGB(109, 40, 217),
        }

        local function corner(inst, r)
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, r or 8)
            c.Parent = inst
        end

        local function pad(inst, l, r, t, b)
            local p = Instance.new("UIPadding")
            p.PaddingLeft = UDim.new(0, l or 0)
            p.PaddingRight = UDim.new(0, r or 0)
            p.PaddingTop = UDim.new(0, t or 0)
            p.PaddingBottom = UDim.new(0, b or 0)
            p.Parent = inst
        end

        local settingsOpen = false
        local enabled = false

        -- destroy old panel names used by Nox
        pcall(function()
            if playerGui then
                for _, nm in ipairs({"AdminSpammerStandalone", "PanelGui_Cyutsud Admin Spammer", "PanelGui_Flux Admin Spammer"}) do
                    local o = playerGui:FindFirstChild(nm)
                    if o then o:Destroy() end
                end
            end
            if type(gethui) == "function" then
                local h = gethui()
                if h then
                    for _, nm in ipairs({"AdminSpammerStandalone", "PanelGui_Cyutsud Admin Spammer"}) do
                        local o = h:FindFirstChild(nm)
                        if o then o:Destroy() end
                    end
                end
            end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "PanelGui_Cyutsud Admin Spammer"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 9999999
        gui.Enabled = false
        pcall(function()
            if type(gethui) == "function" then
                gui.Parent = gethui()
            else
                gui.Parent = playerGui
            end
        end)
        if not gui.Parent and playerGui then gui.Parent = playerGui end
        _G._FH_AdminSpammerGui = gui

        local root = Instance.new("Frame")
        root.Name = "Frame"
        root.Size = UDim2.new(0, 340, 0, 380)
        root.Position = UDim2.new(0.5, -170, 0.5, -190)
        root.BackgroundColor3 = C.bg
        root.BorderSizePixel = 0
        root.Parent = gui
        corner(root, 12)

        local header = Instance.new("Frame")
        header.Name = "TitleBar"
        header.Size = UDim2.new(1, 0, 0, 40)
        header.BackgroundColor3 = C.bar
        header.BorderSizePixel = 0
        header.Parent = root
        corner(header, 12)

        local hTitle = Instance.new("TextLabel")
        hTitle.Size = UDim2.new(1, -100, 1, 0)
        hTitle.Position = UDim2.new(0, 14, 0, 0)
        hTitle.BackgroundTransparency = 1
        hTitle.Font = Enum.Font.GothamBold
        hTitle.TextSize = 16
        hTitle.TextColor3 = C.text
        hTitle.TextXAlignment = Enum.TextXAlignment.Left
        hTitle.Text = "Admin Spammer"
        hTitle.Parent = header

        setStatus = function(msg)
            hTitle.Text = "Admin Spammer  [" .. tostring(msg) .. "]"
            task.delay(1.5, function()
                if hTitle and hTitle.Parent then
                    hTitle.Text = settingsOpen and "Spam Settings" or "Admin Spammer"
                end
            end)
        end

        local gearBtn = Instance.new("TextButton")
        gearBtn.Size = UDim2.new(0, 28, 0, 28)
        gearBtn.Position = UDim2.new(1, -70, 0.5, -14)
        gearBtn.BackgroundColor3 = C.btn
        gearBtn.Text = "⚙"
        gearBtn.TextSize = 14
        gearBtn.Font = Enum.Font.GothamBold
        gearBtn.TextColor3 = C.dim
        gearBtn.AutoButtonColor = false
        gearBtn.Parent = header
        corner(gearBtn, 6)

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
        closeBtn.BackgroundColor3 = C.btn
        closeBtn.Text = "×"
        closeBtn.TextSize = 18
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextColor3 = C.dim
        closeBtn.AutoButtonColor = false
        closeBtn.Parent = header
        corner(closeBtn, 6)
        closeBtn.MouseButton1Click:Connect(function()
            enabled = false
            gui.Enabled = false
            pcall(function()
                if type(Config) == "table" and Config.set then
                    Config.set("admin_spammer_visible", false)
                    Config.set("toggle:Admin Spammer", false)
                end
            end)
        end)

        local playersFrame = Instance.new("ScrollingFrame")
        playersFrame.Size = UDim2.new(1, -16, 1, -140)
        playersFrame.Position = UDim2.new(0, 8, 0, 48)
        playersFrame.BackgroundTransparency = 1
        playersFrame.BorderSizePixel = 0
        playersFrame.ScrollBarThickness = 4
        playersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        playersFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        playersFrame.Parent = root
        Instance.new("UIListLayout", playersFrame).Padding = UDim.new(0, 8)

        local closestBtn = Instance.new("TextButton")
        closestBtn.Name = "SpamLabel"
        closestBtn.Size = UDim2.new(1, -16, 0, 36)
        closestBtn.Position = UDim2.new(0, 8, 1, -48)
        closestBtn.BackgroundColor3 = C.purple
        closestBtn.BorderSizePixel = 0
        closestBtn.Font = Enum.Font.GothamBold
        closestBtn.TextSize = 13
        closestBtn.TextColor3 = C.text
        closestBtn.AutoButtonColor = false
        closestBtn.Parent = root
        corner(closestBtn, 8)

        local spamClosestBind = nil -- keybind entry (right-click)

        local function refreshClosestLabel()
            local mode = (spamWave == 1) and "SEMI" or "FULL"
            local base = "Spam Closest · " .. mode
            if spamClosestBind and spamClosestBind._capturing then
                closestBtn.Text = base .. " (key/pad...)"
            elseif spamClosestBind and type(spamClosestBind.keyName) == "string" and spamClosestBind.keyName ~= "" then
                closestBtn.Text = base .. " (" .. spamClosestBind.keyName .. ")"
            else
                closestBtn.Text = base
            end
        end
        refreshClosestLabel()

        local function getClosest()
            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not myHRP then return nil end
            local best, bestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - myHRP.Position).Magnitude
                        if d < bestDist then best, bestDist = p, d end
                    end
                end
            end
            return best
        end

        local function doSpamClosest()
            local plr = getClosest()
            if not plr then
                setStatus("no target")
                return
            end
            -- 1er clic = SEMI (wave 1), 2e clic = FULL (wave 2), etc.
            local wave = spamWave
            spamWave = (wave == 1) and 2 or 1
            persistSpamCfg()
            refreshClosestLabel()
            executeSpamOnTarget(plr, wave)
        end

        closestBtn.MouseButton1Click:Connect(doSpamClosest)

        -- Clic droit = définir / changer / supprimer la keybind (comme les toggles du hub)
        pcall(function()
            local bindFn = attachKeybind
            if type(bindFn) ~= "function" and _G.__CyutsudBridge and type(_G.__CyutsudBridge.attachKeybind) == "function" then
                bindFn = _G.__CyutsudBridge.attachKeybind
            end
            if type(bindFn) ~= "function" then return end
            spamClosestBind = bindFn(closestBtn, closestBtn, "Spam Closest", doSpamClosest)
            if type(spamClosestBind) == "table" then
                spamClosestBind.refresh = refreshClosestLabel
                refreshClosestLabel()
            end
            -- expose pour synchro label externe
            pcall(function()
                if type(M) == "table" then
                    M._refreshSpamLabel = refreshClosestLabel
                end
            end)
        end)

        local function avatarUrl(p)
            local ok, url = pcall(function()
                return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            return ok and url or ""
        end

        local function buildPlayerRow(p)
            local row = Instance.new("Frame")
            row.Name = "row_" .. p.Name
            row.Size = UDim2.new(1, -4, 0, 46)
            row.BackgroundColor3 = C.row
            row.BorderSizePixel = 0
            row.Parent = playersFrame
            corner(row, 8)

            local av = Instance.new("ImageLabel")
            av.Size = UDim2.new(0, 32, 0, 32)
            av.Position = UDim2.new(0, 8, 0.5, -16)
            av.BackgroundColor3 = C.btn
            av.BorderSizePixel = 0
            av.Image = avatarUrl(p)
            av.Parent = row
            corner(av, 16)

            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(1, -160, 1, 0)
            name.Position = UDim2.new(0, 48, 0, 0)
            name.BackgroundTransparency = 1
            name.Font = Enum.Font.GothamMedium
            name.TextSize = 12
            name.TextColor3 = C.text
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.TextYAlignment = Enum.TextYAlignment.Center
            name.TextTruncate = Enum.TextTruncate.AtEnd
            name.Text = p.DisplayName
            name.Parent = row

            local function makeWave(label, wave, x, bg, fg)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0, 44, 0, 28)
                b.Position = UDim2.new(1, x, 0.5, -14)
                b.BackgroundColor3 = bg
                b.BorderSizePixel = 0
                b.Text = label
                b.TextSize = 13
                b.Font = Enum.Font.GothamBold
                b.TextColor3 = fg
                b.AutoButtonColor = false
                b.Parent = row
                corner(b, 6)
                b.MouseButton1Click:Connect(function()
                    executeSpamOnTarget(p, wave)
                end)
            end
            makeWave("1", 1, -108, Color3.fromRGB(20, 55, 35), C.green)
            makeWave("2", 2, -56, Color3.fromRGB(55, 20, 20), C.red)
        end

        local function refreshPlayers()
            for _, ch in ipairs(playersFrame:GetChildren()) do
                if ch:IsA("Frame") then ch:Destroy() end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then buildPlayerRow(p) end
            end
        end

        Players.PlayerAdded:Connect(function() task.wait(0.2); refreshPlayers() end)
        Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshPlayers() end)

        local settingsFrame = Instance.new("ScrollingFrame")
        settingsFrame.Name = "SettingsScroll"
        -- Full usable area under header (more height so last cmds are reachable)
        settingsFrame.Size = UDim2.new(1, -12, 1, -52)
        settingsFrame.Position = UDim2.new(0, 6, 0, 46)
        settingsFrame.BackgroundTransparency = 1
        settingsFrame.BorderSizePixel = 0
        settingsFrame.Visible = false
        settingsFrame.Active = true
        settingsFrame.Selectable = true
        settingsFrame.ScrollingEnabled = true
        settingsFrame.ClipsDescendants = true
        settingsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        settingsFrame.ScrollBarThickness = 6
        settingsFrame.ScrollBarImageColor3 = Color3.fromRGB(168, 85, 247)
        settingsFrame.ScrollBarImageTransparency = 0.2
        settingsFrame.ElasticBehavior = Enum.ElasticBehavior.Always
        settingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        settingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        settingsFrame.ZIndex = 45
        settingsFrame.Parent = root
        local _sfLayout = Instance.new("UIListLayout")
        _sfLayout.Name = "SettingsList"
        _sfLayout.Padding = UDim.new(0, 6)
        _sfLayout.SortOrder = Enum.SortOrder.LayoutOrder
        _sfLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        _sfLayout.Parent = settingsFrame
        local _sfPad = Instance.new("UIPadding")
        _sfPad.Name = "SettingsPad"
        _sfPad.PaddingTop = UDim.new(0, 4)
        _sfPad.PaddingBottom = UDim.new(0, 24)
        _sfPad.PaddingLeft = UDim.new(0, 4)
        _sfPad.PaddingRight = UDim.new(0, 8)
        _sfPad.Parent = settingsFrame
        -- Keep canvas tall enough even if AutomaticCanvasSize fails
        local function _sfRecalcCanvas()
            pcall(function()
                local y = _sfLayout.AbsoluteContentSize.Y + 28
                if y < 10 then y = 10 end
                settingsFrame.CanvasSize = UDim2.new(0, 0, 0, y)
            end)
        end
        _sfLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(_sfRecalcCanvas)

        local function paintSlot(btn, active, which)
            if not btn then return end
            btn.BackgroundTransparency = 0
            if active then
                if which == 1 then
                    -- SEMI = vert
                    btn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    pcall(function()
                        local s = btn:FindFirstChildOfClass("UIStroke")
                        if s then
                            s.Color = Color3.fromRGB(74, 222, 128)
                            s.Transparency = 0.1
                            s.Thickness = 1.4
                        end
                    end)
                else
                    -- FULL = rouge
                    btn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    pcall(function()
                        local s = btn:FindFirstChildOfClass("UIStroke")
                        if s then
                            s.Color = Color3.fromRGB(252, 165, 165)
                            s.Transparency = 0.1
                            s.Thickness = 1.4
                        end
                    end)
                end
            else
                -- off = gris
                btn.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
                btn.TextColor3 = Color3.fromRGB(160, 165, 180)
                pcall(function()
                    local s = btn:FindFirstChildOfClass("UIStroke")
                    if s then
                        s.Color = Color3.fromRGB(90, 94, 110)
                        s.Transparency = 0.45
                        s.Thickness = 1
                    end
                end)
            end
        end

        local function buildSettings()
            for _, ch in ipairs(settingsFrame:GetChildren()) do
                if ch:IsA("Frame") or ch:IsA("TextLabel") or ch:IsA("TextButton") then
                    ch:Destroy()
                end
            end

            local accent = C.purple
            pcall(function()
                if Theme and typeof(Theme.c1) == "Color3" then accent = Theme.c1 end
            end)

            -- ===== Header card =====
            local topCard = Instance.new("Frame")
            topCard.Size = UDim2.new(1, -4, 0, 58)
            topCard.BackgroundColor3 = Color3.fromRGB(32, 33, 42)
            topCard.BorderSizePixel = 0
            topCard.LayoutOrder = 1
            topCard.ZIndex = 21
            topCard.Parent = settingsFrame
            corner(topCard, 10)
            local topStroke = Instance.new("UIStroke")
            topStroke.Color = accent
            topStroke.Thickness = 1.2
            topStroke.Transparency = 0.55
            topStroke.Parent = topCard

            local topAccent = Instance.new("Frame")
            topAccent.Size = UDim2.new(0, 3, 1, -12)
            topAccent.Position = UDim2.new(0, 6, 0, 6)
            topAccent.BackgroundColor3 = accent
            topAccent.BorderSizePixel = 0
            topAccent.Parent = topCard
            corner(topAccent, 2)

            local topTitle = Instance.new("TextLabel")
            topTitle.Size = UDim2.new(1, -20, 0, 20)
            topTitle.Position = UDim2.new(0, 16, 0, 8)
            topTitle.BackgroundTransparency = 1
            topTitle.Font = Enum.Font.GothamBlack
            topTitle.TextSize = 13
            topTitle.TextColor3 = C.text
            topTitle.TextXAlignment = Enum.TextXAlignment.Left
            topTitle.Text = "SPAM SETTINGS"
            topTitle.Parent = topCard

            local topSub = Instance.new("TextLabel")
            topSub.Size = UDim2.new(1, -20, 0, 16)
            topSub.Position = UDim2.new(0, 16, 0, 30)
            topSub.BackgroundTransparency = 1
            topSub.Font = Enum.Font.Gotham
            topSub.TextSize = 11
            topSub.TextColor3 = C.dim
            topSub.TextXAlignment = Enum.TextXAlignment.Left
            topSub.Text = "SEMI = vague 1  ·  FULL = vague 2  ·  off = désactivé"
            topSub.Parent = topCard

            -- ===== Delay card =====
            local delayCard = Instance.new("Frame")
            delayCard.Size = UDim2.new(1, -4, 0, 52)
            delayCard.BackgroundColor3 = Color3.fromRGB(32, 33, 42)
            delayCard.BorderSizePixel = 0
            delayCard.LayoutOrder = 2
            delayCard.ZIndex = 21
            delayCard.Parent = settingsFrame
            corner(delayCard, 10)

            local delayTitle = Instance.new("TextLabel")
            delayTitle.Size = UDim2.new(0.55, 0, 0, 16)
            delayTitle.Position = UDim2.new(0, 12, 0, 8)
            delayTitle.BackgroundTransparency = 1
            delayTitle.Font = Enum.Font.GothamBold
            delayTitle.TextSize = 11
            delayTitle.TextColor3 = accent
            delayTitle.TextXAlignment = Enum.TextXAlignment.Left
            delayTitle.Text = "DELAY"
            delayTitle.Parent = delayCard

            local delayHint = Instance.new("TextLabel")
            delayHint.Size = UDim2.new(0.55, 0, 0, 14)
            delayHint.Position = UDim2.new(0, 12, 0, 26)
            delayHint.BackgroundTransparency = 1
            delayHint.Font = Enum.Font.Gotham
            delayHint.TextSize = 10
            delayHint.TextColor3 = C.dim
            delayHint.TextXAlignment = Enum.TextXAlignment.Left
            delayHint.Text = "Pause entre chaque commande"
            delayHint.Parent = delayCard

            local delayCtrl = Instance.new("Frame")
            delayCtrl.Size = UDim2.new(0, 118, 0, 28)
            delayCtrl.Position = UDim2.new(1, -128, 0.5, -14)
            delayCtrl.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
            delayCtrl.BorderSizePixel = 0
            delayCtrl.Parent = delayCard
            corner(delayCtrl, 8)

            local minusBtn = Instance.new("TextButton")
            minusBtn.Size = UDim2.new(0, 28, 1, 0)
            minusBtn.Position = UDim2.new(0, 0, 0, 0)
            minusBtn.BackgroundTransparency = 1
            minusBtn.Text = "−"
            minusBtn.Font = Enum.Font.GothamBold
            minusBtn.TextSize = 16
            minusBtn.TextColor3 = C.text
            minusBtn.AutoButtonColor = false
            minusBtn.Parent = delayCtrl

            local dBox = Instance.new("TextBox")
            dBox.Size = UDim2.new(1, -56, 1, 0)
            dBox.Position = UDim2.new(0, 28, 0, 0)
            dBox.BackgroundTransparency = 1
            dBox.Font = Enum.Font.GothamBold
            dBox.TextSize = 13
            dBox.TextColor3 = C.text
            dBox.Text = string.format("%.1f s", tonumber(apDelay) or 0)
            dBox.ClearTextOnFocus = false
            dBox.TextXAlignment = Enum.TextXAlignment.Center
            dBox.Parent = delayCtrl

            local plusBtn = Instance.new("TextButton")
            plusBtn.Size = UDim2.new(0, 28, 1, 0)
            plusBtn.Position = UDim2.new(1, -28, 0, 0)
            plusBtn.BackgroundTransparency = 1
            plusBtn.Text = "+"
            plusBtn.Font = Enum.Font.GothamBold
            plusBtn.TextSize = 16
            plusBtn.TextColor3 = C.text
            plusBtn.AutoButtonColor = false
            plusBtn.Parent = delayCtrl

            local function applyDelay(n)
                apDelay = math.clamp(tonumber(n) or 0, 0, 30)
                dBox.Text = string.format("%.1f s", apDelay)
                persistSpamCfg()
                if setStatus then setStatus("delay: " .. apDelay .. "s") end
            end

            minusBtn.MouseButton1Click:Connect(function()
                applyDelay((tonumber(apDelay) or 0) - 0.1)
            end)
            plusBtn.MouseButton1Click:Connect(function()
                applyDelay((tonumber(apDelay) or 0) + 0.1)
            end)
            dBox.FocusLost:Connect(function()
                local raw = tostring(dBox.Text or ""):gsub("[^%d%.]", "")
                applyDelay(tonumber(raw) or apDelay)
            end)

            -- ===== Commands section title =====
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, -4, 0, 28)
            sec.BackgroundTransparency = 1
            sec.LayoutOrder = 3
            sec.ZIndex = 21
            sec.Parent = settingsFrame

            local secLbl = Instance.new("TextLabel")
            secLbl.Size = UDim2.new(1, -100, 1, 0)
            secLbl.Position = UDim2.new(0, 4, 0, 0)
            secLbl.BackgroundTransparency = 1
            secLbl.Font = Enum.Font.GothamBlack
            secLbl.TextSize = 11
            secLbl.TextColor3 = accent
            secLbl.TextXAlignment = Enum.TextXAlignment.Left
            secLbl.TextYAlignment = Enum.TextYAlignment.Center
            secLbl.Text = "COMMANDES"
            secLbl.Parent = sec

            local legend = Instance.new("TextLabel")
            legend.Size = UDim2.new(0, 110, 1, 0)
            legend.Position = UDim2.new(1, -114, 0, 0)
            legend.BackgroundTransparency = 1
            legend.Font = Enum.Font.GothamBold
            legend.TextSize = 10
            legend.TextColor3 = C.dim
            legend.TextXAlignment = Enum.TextXAlignment.Right
            legend.TextYAlignment = Enum.TextYAlignment.Center
            legend.Text = "SEMI     FULL"
            legend.Parent = sec

            -- ===== Command rows =====
            local layoutOrder = 10
            for _, cmd in ipairs(SPAM_CMDS) do
                layoutOrder = layoutOrder + 1
                local thisCmd = cmd -- capture for closures

                local row = Instance.new("Frame")
                row.Name = "CmdRow_" .. tostring(thisCmd)
                row.Size = UDim2.new(1, -4, 0, 44)
                row.BackgroundColor3 = Color3.fromRGB(32, 33, 42)
                row.BorderSizePixel = 0
                row.Active = false -- let children receive clicks
                row.ZIndex = 40
                row.LayoutOrder = layoutOrder
                row.Parent = settingsFrame
                corner(row, 10)

                local dot = Instance.new("Frame")
                dot.Name = "StatusDot"
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.Position = UDim2.new(0, 12, 0.5, -3)
                dot.BackgroundColor3 = C.dim
                dot.BorderSizePixel = 0
                dot.ZIndex = 41
                dot.Active = false
                dot.Parent = row
                corner(dot, 3)

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -150, 1, 0)
                lbl.Position = UDim2.new(0, 26, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 13
                lbl.TextColor3 = C.text
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextYAlignment = Enum.TextYAlignment.Center
                lbl.Text = thisCmd:sub(1, 1):upper() .. thisCmd:sub(2)
                lbl.ZIndex = 41
                lbl.Active = false
                lbl.Parent = row

                local function makeSlotBtn(label, xOff)
                    local b = Instance.new("TextButton")
                    b.Name = "Slot_" .. label
                    b.Size = UDim2.new(0, 54, 0, 32)
                    b.Position = UDim2.new(1, xOff, 0.5, -16)
                    b.Text = label
                    b.TextSize = 11
                    b.Font = Enum.Font.GothamBlack
                    b.AutoButtonColor = false
                    b.BorderSizePixel = 0
                    b.BackgroundTransparency = 0
                    b.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
                    b.TextColor3 = Color3.fromRGB(160, 165, 180)
                    b.Active = true
                    b.Selectable = true
                    b.Modal = false
                    b.ZIndex = 60
                    b.Parent = row
                    corner(b, 8)
                    local s = Instance.new("UIStroke")
                    s.Color = Color3.fromRGB(90, 94, 110)
                    s.Thickness = 1
                    s.Transparency = 0.45
                    s.Parent = b
                    return b
                end
                local b1 = makeSlotBtn("SEMI", -120)
                local b2 = makeSlotBtn("FULL", -60)

                local function refresh()
                    local v = tonumber(spamCfg[thisCmd]) or 0
                    if v ~= 0 and v ~= 1 and v ~= 2 then v = 0 end
                    paintSlot(b1, v == 1, 1)
                    paintSlot(b2, v == 2, 2)
                    if v == 1 then
                        dot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
                    elseif v == 2 then
                        dot.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
                    else
                        dot.BackgroundColor3 = Color3.fromRGB(70, 72, 84)
                    end
                end
                refresh()

                local lastClick = 0
                local function toggleSemi()
                    local now = tick()
                    if now - lastClick < 0.08 then return end
                    lastClick = now
                    local cur = tonumber(spamCfg[thisCmd]) or 0
                    spamCfg[thisCmd] = (cur == 1) and 0 or 1
                    refresh()
                    task.spawn(function()
                        pcall(persistSpamCfg)
                    end)
                end
                local function toggleFull()
                    local now = tick()
                    if now - lastClick < 0.08 then return end
                    lastClick = now
                    local cur = tonumber(spamCfg[thisCmd]) or 0
                    spamCfg[thisCmd] = (cur == 2) and 0 or 2
                    refresh()
                    task.spawn(function()
                        pcall(persistSpamCfg)
                    end)
                end

                -- Multiple bindings so at least one fires (PC / mobile / executor quirks)
                b1.MouseButton1Click:Connect(toggleSemi)
                b1.MouseButton1Down:Connect(toggleSemi)
                b2.MouseButton1Click:Connect(toggleFull)
                b2.MouseButton1Down:Connect(toggleFull)
                pcall(function() b1.Activated:Connect(toggleSemi) end)
                pcall(function() b2.Activated:Connect(toggleFull) end)
                b1.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                        toggleSemi()
                    end
                end)
                b2.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                        toggleFull()
                    end
                end)
            end
            -- Force scroll range after building
            task.defer(function()
                pcall(_sfRecalcCanvas)
                task.wait()
                pcall(_sfRecalcCanvas)
            end)

            -- ===== Footer tip =====
            local tip = Instance.new("TextLabel")
            tip.Size = UDim2.new(1, -4, 0, 28)
            tip.BackgroundTransparency = 1
            tip.Font = Enum.Font.Gotham
            tip.TextSize = 10
            tip.TextColor3 = Color3.fromRGB(100, 105, 120)
            tip.TextXAlignment = Enum.TextXAlignment.Center
            tip.TextYAlignment = Enum.TextYAlignment.Center
            tip.Text = "Clique SEMI / FULL pour activer · reclique pour off · auto-save"
            tip.Parent = settingsFrame
        end

        gearBtn.MouseButton1Click:Connect(function()
            settingsOpen = not settingsOpen
            settingsFrame.Visible = settingsOpen
            playersFrame.Visible = not settingsOpen
            playersFrame.Active = not settingsOpen
            closestBtn.Visible = not settingsOpen
            closestBtn.Active = not settingsOpen
            -- hide anything under the scroll that can steal clicks
            pcall(function()
                for _, ch in ipairs(root:GetChildren()) do
                    if ch:IsA("GuiObject") and ch ~= header and ch ~= settingsFrame and ch ~= playersFrame then
                        if settingsOpen then
                            if ch.Name ~= "Shadow" and ch.Name ~= "CyutsudSideImage" then
                                ch:SetAttribute("_CyutsudWasVisible", ch.Visible)
                                -- keep only header-related chrome
                                if ch ~= closestBtn then
                                    -- leave close/gear (in header)
                                end
                            end
                        end
                    end
                end
                for _, nm in ipairs({"WaveToggle", "SpamAll", "BottomBar", "Footer", "WaveBtn", "AllBtn", "SpamLabel"}) do
                    local f = root:FindFirstChild(nm, true)
                    if f and f:IsA("GuiObject") then
                        if settingsOpen then
                            f:SetAttribute("_CyutsudWasVisible", f.Visible)
                            f.Visible = false
                            f.Active = false
                        else
                            local was = f:GetAttribute("_CyutsudWasVisible")
                            if was ~= nil then f.Visible = was and true or false
                            else f.Visible = true end
                            f.Active = true
                        end
                    end
                end
            end)
            settingsFrame.ZIndex = settingsOpen and 50 or 20
            settingsFrame.Active = true
            gearBtn.Text = settingsOpen and "←" or "⚙"
            hTitle.Text = settingsOpen and "Spam Settings" or "Admin Spammer"
            if settingsOpen then
                buildSettings()
                task.defer(function()
                    pcall(_sfRecalcCanvas)
                    settingsFrame.CanvasPosition = Vector2.new(0, 0)
                end)
            end
        end)

        do
            local dragging, dragStart, startPos
            header.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    if _G._FH_GuiLocked then return end
                    dragging = true
                    dragStart = i.Position
                    startPos = root.Position
                    i.Changed:Connect(function()
                        if i.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then
                    if _G._FH_GuiLocked then dragging = false; return end
                    local d = i.Position - dragStart
                    root.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y
                    )
                end
            end)
        end

        local function persistAdminVisible(on)
            on = on and true or false
            -- même pipeline que les toggles hub
            pcall(function()
                if type(setToggleSaved) == "function" then
                    setToggleSaved("Admin Spammer", on)
                end
            end)
            pcall(function()
                if type(Config) ~= "table" then return end
                Config.data = Config.data or {}
                Config.data["admin_spammer_visible"] = on
                Config.data["toggle:Admin Spammer"] = on
                local t = Config.data["toggles"]
                if type(t) ~= "table" then t = {} end
                local copy = {}
                for k, v in pairs(t) do copy[k] = v end
                copy["Admin Spammer"] = on
                Config.data["toggles"] = copy
                Config._dirty = true
                if Config.flush then Config.flush()
                elseif Config.save then Config.save() end
            end)
        end

        UIS.InputBegan:Connect(function(i, gp)
            if not gp and i.KeyCode == Enum.KeyCode.RightShift then
                enabled = not enabled
                gui.Enabled = enabled
                persistAdminVisible(enabled)
            end
        end)

        refreshPlayers()

        local M = {}
        function M.set(on)
            on = on and true or false
            enabled = on
            gui.Enabled = on
            persistAdminVisible(on)
            if on then refreshPlayers() end
        end
        function M.isEnabled()
            return enabled and gui and gui.Enabled
        end
        function M._refreshSpamLabel()
            refreshClosestLabel()
        end
        function M.repaint()
            -- keep standalone colors; optional theme hooks
            pcall(function()
                if Theme and typeof(Theme.c1) == "Color3" then
                    closestBtn.BackgroundColor3 = Theme.c1
                end
            end)
        end
        M.gui = gui
        M.panel = root

        pcall(function()
            if type(_G._CyutsudStyleLikeHub) == "function" then
                _G._CyutsudStyleLikeHub(root, header)
            end
        end)

        return M
    end)()


    _G.DiscordLabel = (function()
        -- FunHub-style bottom watermark: 
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        local gui, label, grad
        local animThread = nil

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            if T and typeof(T.Primary) == "Color3" then return T.Primary end
            return Color3.fromRGB(57, 64, 89)
        end

        local function parentGui(sg)
            local parented = false
            pcall(function()
                if typeof(gethui) == "function" then
                    sg.Parent = gethui()
                    parented = sg.Parent ~= nil
                end
            end)
            if not parented then
                pcall(function()
                    sg.Parent = game:GetService("CoreGui")
                    parented = sg.Parent ~= nil
                end)
            end
            if not parented and LP then
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                if pg then sg.Parent = pg end
            end
        end

        local function destroyOld()
            pcall(function()
                if gui then gui:Destroy() end
            end)
            gui, label, grad = nil, nil, nil
            local names = { "DiscordLabelGui", "NoxLabelGui", "FunHubDiscordLabel" }
            for _, name in ipairs(names) do
                pcall(function()
                    if LP then
                        local pg = LP:FindFirstChild("PlayerGui")
                        local old = pg and pg:FindFirstChild(name)
                        if old then old:Destroy() end
                    end
                end)
                pcall(function()
                    if typeof(gethui) == "function" then
                        local h = gethui()
                        local old = h and h:FindFirstChild(name)
                        if old then old:Destroy() end
                    end
                end)
                pcall(function()
                    local cg = game:GetService("CoreGui")
                    local old = cg:FindFirstChild(name)
                    if old then old:Destroy() end
                end)
            end
        end

        local function build()
            destroyOld()

            gui = Instance.new("ScreenGui")
            gui.Name = "DiscordLabelGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 1000
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = true
            parentGui(gui)

            -- Same layout as FunHub DiscordLabelGui
            label = Instance.new("TextLabel")
            label.Name = "TextLabel"
            label.Size = UDim2.new(0, 250, 0, 30)
            label.Position = UDim2.new(0.5, 0, 1, -65)
            label.AnchorPoint = Vector2.new(0.5, 1)
            label.BackgroundTransparency = 1
            label.Text = ""
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 21
            label.TextStrokeTransparency = 0.7
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Font = Enum.Font.GothamBold
            label.TextScaled = false
            label.TextWrapped = false
            label.ZIndex = 10
            label.Parent = gui

            grad = Instance.new("UIGradient")
            grad.Name = "UIGradient"
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, colPrimary()),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            })
            grad.Offset = Vector2.new(0.5, 0)
            grad.Parent = label

            if animThread then
                pcall(function() task.cancel(animThread) end)
                animThread = nil
            end
            animThread = task.spawn(function()
                local phase = 0
                while gui and gui.Parent do
                    if not gui.Enabled then
                        task.wait(0.5)
                    else
                        phase = (phase + 0.008) % 1
                        if grad and grad.Parent then
                            grad.Offset = Vector2.new(phase - 0.5, 0)
                        end
                        task.wait(0.03)
                    end
                end
            end)
        end

        local function repaint()
            if grad and grad.Parent then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.5, colPrimary()),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                })
            end
            if label and label.Parent then
                label.Text = ""
            end
        end

        task.defer(function()
            pcall(build)
            if gui then gui.Enabled = true end
        end)

        return {
            set = function(on)
                if on then
                    if not gui or not gui.Parent then build() end
                    if gui then gui.Enabled = true end
                else
                    if gui then gui.Enabled = false end
                end
            end,
            isEnabled = function()
                return gui and gui.Enabled or false
            end,
            repaint = repaint,
            rebuild = build,
        }
    end)()

    _G.AntiBee = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Lighting = game:GetService("Lighting")
        local UserInputService = game:GetService("UserInputService")
        local player = Players.LocalPlayer

        local FOV_LOCK = 100

        local blacklist = {
            "BlurEffect", "ColorCorrectionEffect", "BloomEffect", "SunRaysEffect",
            "DepthOfFieldEffect", "Atmosphere", "Sky", "Smoke", "ParticleEmitter",
            "Beam", "Trail", "Highlight", "PostEffect", "SurfaceAppearance",
            "Fire", "Sparkles", "Explosion", "PointLight", "SpotLight",
            "SurfaceLight", "Blur", "ColorGradingEffect",
            "ToneMappingEffect", "VignetteEffect",
            "ChromaticAberrationEffect", "DistortionEffect",
            "AmbientOcclusionEffect", "RefractionEffect",
            "ScreenSpaceReflection", "MotionBlur",
            "PixelateEffect", "FilmGrainEffect",
            "Clouds", "FogVolume",
        }

        local function isBlacklisted(obj)
            if not obj then return false end
            for i = 1, #blacklist do
                local ok, match = pcall(function() return obj:IsA(blacklist[i]) end)
                if ok and match then return true end
            end
            return false
        end

        local function clearEffects()
            pcall(function()
                for _, v in ipairs(Lighting:GetDescendants()) do
                    if isBlacklisted(v) then
                        pcall(function() v:Destroy() end)
                    end
                end
            end)
            pcall(function()
                local cam = workspace.CurrentCamera
                if not cam then return end
                for _, v in ipairs(cam:GetDescendants()) do
                    if isBlacklisted(v) then
                        pcall(function() v:Destroy() end)
                    end
                end
            end)
        end

        local M = {
            enabled = false,
            conns = {},
        }

        local function disconnectAll()
            for i = 1, #M.conns do
                pcall(function() M.conns[i]:Disconnect() end)
            end
            M.conns = {}
        end

        local function start()
            if M.enabled then return end
            M.enabled = true
            disconnectAll()
            clearEffects()

            local camera = workspace.CurrentCamera

            table.insert(M.conns, Lighting.DescendantAdded:Connect(function(obj)
                if M.enabled and isBlacklisted(obj) then
                    pcall(function() obj:Destroy() end)
                end
            end))

            table.insert(M.conns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                camera = workspace.CurrentCamera
            end))

            table.insert(M.conns, RunService.RenderStepped:Connect(function()
                if not M.enabled then return end
                camera = camera or workspace.CurrentCamera
                if camera and camera.FieldOfView ~= FOV_LOCK then
                    pcall(function() camera.FieldOfView = FOV_LOCK end)
                end
            end))

            local keys = { W = false, A = false, S = false, D = false }
            local gamepadMove = Vector3.zero

            local function applyMovement()
                if not M.enabled then return end
                local char = player and player.Character
                if not char then return end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end
                pcall(function()
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                    if humanoid.GetStateEnabled and not humanoid:GetStateEnabled(Enum.HumanoidStateType.Running) then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                    end
                    if humanoid.GetStateEnabled and not humanoid:GetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics) then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
                    end
                end)

                local native = humanoid.MoveDirection
                if native and native.Magnitude > 0.05 then
                    pcall(function() humanoid:Move(native, false) end)
                    return
                end

                local forward = Vector3.zero
                if keys.W then forward = forward + Vector3.new(0, 0, -1) end
                if keys.S then forward = forward + Vector3.new(0, 0, 1) end
                if keys.A then forward = forward + Vector3.new(-1, 0, 0) end
                if keys.D then forward = forward + Vector3.new(1, 0, 0) end
                local keyboardMove = (forward.Magnitude > 0) and forward.Unit or Vector3.zero
                local moveVector = (gamepadMove.Magnitude > 0.05) and gamepadMove or keyboardMove
                if moveVector.Magnitude > 0.05 then
                    pcall(function() humanoid:Move(moveVector, true) end)
                end
            end

            table.insert(M.conns, UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local k = input.KeyCode.Name
                    if keys[k] ~= nil then keys[k] = true end
                end
            end))

            table.insert(M.conns, UserInputService.InputEnded:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local k = input.KeyCode.Name
                    if keys[k] ~= nil then keys[k] = false end
                end
            end))

            table.insert(M.conns, UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Gamepad1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
                        gamepadMove = Vector3.new(input.Position.X, 0, -input.Position.Y)
                    end
                end
            end))

            table.insert(M.conns, RunService.RenderStepped:Connect(applyMovement))

            if player then
                table.insert(M.conns, player.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if M.enabled then applyMovement() end
                end))
            end
        end

        local function stop()
            M.enabled = false
            disconnectAll()
        end

        return {
            set = function(on)
                if on then start() else stop() end
                pcall(function()
                    if Config then Config.set("anti_bee", on and true or false) end
                end)
            end,
            isOn = function()
                return M.enabled
            end,
            start = start,
            stop = stop,
        }
    end)()

    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.AntiBee and _G.AntiBee.set then
                _G.AntiBee.set(false)
            end
        end)
    end)

    _G._FH_CD_ONCD = _G._FH_CD_ONCD or {}

    _G.CommandCooldowns = (function()
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local LP = Players.LocalPlayer
        if not LP then
            return {
                set = function() end,
                isEnabled = function() return false end,
                setVisible = function() end,
            }
        end

        local function n(class, props, parent)
            local o = Instance.new(class)
            if props then for k, v in pairs(props) do o[k] = v end end
            if parent then o.Parent = parent end
            return o
        end

        local CMDS = {
            "rocket", "ragdoll", "balloon", "inverse", "nightvision",
            "jail", "control", "tiny", "jumpscare", "morph",
        }

        local M = {
            enabled = false,
            visible = false,
            gui = nil,
            panel = nil,
            content = nil,
            minBtn = nil,
            minimized = false,
            labels = {},
            conns = {},
            watchConn = nil,
            themeNodes = {},
        }

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end
        local function colBg()
            if T and typeof(T.Bg) == "Color3" then return T.Bg end
            return Color3.fromRGB(18, 16, 14)
        end
        local function colDeep()
            if T and typeof(T.BgDeep) == "Color3" then return T.BgDeep end
            return Color3.fromRGB(12, 10, 9)
        end
        local function colText()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(250, 245, 235)
        end
        local function colDim()
            if T and typeof(T.TextDim) == "Color3" then return T.TextDim end
            return Color3.fromRGB(160, 140, 120)
        end
        local function colSoft()
            if T and typeof(T.Soft) == "Color3" then return T.Soft end
            return Color3.fromRGB(34, 28, 22)
        end
        local function colCard()
            if T and typeof(T.Card) == "Color3" then return T.Card end
            return Color3.fromRGB(28, 24, 20)
        end
        local function colGreen()
            if T and typeof(T.Green) == "Color3" then return T.Green end
            return Color3.fromRGB(34, 197, 94)
        end

        local function clearConns()
            for i = 1, #M.conns do
                pcall(function() M.conns[i]:Disconnect() end)
            end
            M.conns = {}
            if M.watchConn then
                pcall(function() task.cancel(M.watchConn) end)
                M.watchConn = nil
            end
        end

        local function updateCommand(command, isReady, timerText)
            local label = M.labels[command]
            if not label or not label.Parent then return end
            if isReady then
                label.Text = "READY"
                label.TextColor3 = colGreen()
            else
                label.Text = tostring(timerText or "COOLDOWN")
                label.TextColor3 = Color3.fromRGB(239, 68, 68)
            end
        end

        local function applyTheme()
            local primary = colPrimary()
            if M.panel then
                pcall(function() M.panel.BackgroundColor3 = colBg() end)
            end
            if M.themeNodes.title then
                pcall(function() M.themeNodes.title.BackgroundColor3 = colDeep() end)
            end
            if M.themeNodes.minBtn then
                pcall(function() M.themeNodes.minBtn.BackgroundColor3 = colSoft() end)
            end
            if M.themeNodes.strokeGrad then
                pcall(function()
                    M.themeNodes.strokeGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, primary),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                    })
                end)
            end
            for cmd, lbl in pairs(M.labels) do
                if lbl and lbl.Parent and lbl.Text == "READY" then
                    lbl.TextColor3 = colGreen()
                end
            end
        end

        local function startWatcher()
            if M.watchConn then return end
            M.watchConn = task.spawn(function()
                local prev = {}
                while M.enabled do
                    task.wait(0.45)
                    local lp = Players.LocalPlayer
                    if not lp then continue end
                    local pg = lp:FindFirstChild("PlayerGui")
                    if not pg then continue end
                    local ap = pg:FindFirstChild("AdminPanel")
                    if not ap then continue end
                    pcall(function()
                        local sf = ap:FindFirstChild("AdminPanel")
                        sf = sf and sf:FindFirstChild("Content")
                        sf = sf and sf:FindFirstChild("ScrollingFrame")
                        if not sf then return end
                        for _, cmd in ipairs(CMDS) do
                            local cmdFrame = sf:FindFirstChild(cmd)
                            local onCD = false
                            local timerText = "COOLDOWN"
                            if cmdFrame then
                                local timer = cmdFrame:FindFirstChild("Timer")
                                if timer and timer.Visible then
                                    onCD = true
                                    timerText = timer.Text or "COOLDOWN"
                                end
                            end
                            local was = prev[cmd]
                            prev[cmd] = onCD
                            if _G._FH_CD_ONCD then
                                _G._FH_CD_ONCD[cmd] = onCD or nil
                            end
                            updateCommand(cmd, not onCD, onCD and timerText or nil)
                            -- mirror onto Quick AP global command CD
                            pcall(function()
                                if onCD and _G.QuickAdminPanel and _G.QuickAdminPanel.markCommand then
                                    -- mark without target = global via _FH_CD_ONCD already
                                end
                            end)
                            if onCD and not was then
                            end
                        end
                    end)
                end
                M.watchConn = nil
            end)
        end

        local function build()
            if M.gui and M.gui.Parent then return end
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui")
                local old = pg and pg:FindFirstChild("PanelGui_Command Cooldowns")
                if old then old:Destroy() end
            end)
            pcall(function()
                if typeof(gethui) == "function" then
                    local h = gethui()
                    local old = h and h:FindFirstChild("PanelGui_Command Cooldowns")
                    if old then old:Destroy() end
                end
            end)

            local gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_Command Cooldowns"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 232
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = false
            M.gui = gui

            local parented = false
            pcall(function()
                if typeof(gethui) == "function" then
                    gui.Parent = gethui()
                    parented = gui.Parent ~= nil
                end
            end)
            if not parented then
                pcall(function()
                    gui.Parent = game:GetService("CoreGui")
                    parented = gui.Parent ~= nil
                end)
            end
            if not parented then
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                if pg then gui.Parent = pg end
            end

            local BASE_W, BASE_H, TITLE_H = 220, 278, 28
            local panel = n("Frame", {
                Name = "Frame",
                Size = UDim2.fromOffset(BASE_W, BASE_H),
                Position = UDim2.new(0.5, -110, 0.35, 0),
                BackgroundColor3 = colBg(),
                BackgroundTransparency = 0.08,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Active = true,
            }, gui)
            M.panel = panel
            n("UICorner", { CornerRadius = UDim.new(0, 12) }, panel)

            pcall(function()
                if loadGuiPosition then loadGuiPosition("PanelGui_Command Cooldowns", panel) end
            end)

            local stroke = n("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                Thickness = 1.3,
            }, panel)
            local strokeGrad = n("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colPrimary()),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                }),
                Rotation = 200,
            }, stroke)

            local title = n("Frame", {
                Name = "TitleBar",
                Size = UDim2.new(1, 0, 0, TITLE_H),
                BackgroundColor3 = colDeep(),
                BorderSizePixel = 0,
                Active = true,
            }, panel)
            n("UICorner", { CornerRadius = UDim.new(0, 12) }, title)
            n("Frame", {
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 1, -10),
                BackgroundColor3 = colDeep(),
                BorderSizePixel = 0,
            }, title)

            n("TextLabel", {
                Size = UDim2.new(1, -36, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = "Command Cooldowns",
                TextColor3 = colText(),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, title)

            local minBtn = n("TextButton", {
                Name = "Min",
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -24, 0.5, -10),
                BackgroundColor3 = colSoft(),
                Text = "–",
                TextColor3 = colText(),
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
            }, title)
            n("UICorner", { CornerRadius = UDim.new(1, 0) }, minBtn)
            M.minBtn = minBtn

            local content = n("Frame", {
                Name = "Content",
                Size = UDim2.new(1, 0, 1, -TITLE_H),
                Position = UDim2.new(0, 0, 0, TITLE_H),
                BackgroundTransparency = 1,
            }, panel)
            M.content = content
            n("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 6),
            }, content)
            n("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, content)

            M.labels = {}
            for i, cmd in ipairs(CMDS) do
                local row = n("Frame", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = colCard(),
                    BackgroundTransparency = 0.35,
                    BorderSizePixel = 0,
                    LayoutOrder = i,
                }, content)
                n("UICorner", { CornerRadius = UDim.new(0, 12) }, row)

                n("TextLabel", {
                    Size = UDim2.new(1, -78, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = cmd,
                    TextColor3 = colText(),
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                }, row)

                local status = n("TextLabel", {
                    Name = "StatusLabel",
                    Size = UDim2.new(0, 68, 1, 0),
                    Position = UDim2.new(1, -72, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "READY",
                    TextColor3 = colGreen(),
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextYAlignment = Enum.TextYAlignment.Center,
                }, row)
                M.labels[cmd] = status
            end

            M.themeNodes = {
                panel = panel,
                title = title,
                minBtn = minBtn,
                strokeGrad = strokeGrad,
            }

            pcall(function()
                local style = _G._CyutsudStyleLikeHub
                if style then style(panel, title) end
            end)

            pcall(function()
                local d = _G.makePanelDraggable or makePanelDraggable
                if d then d(title, panel, "PanelGui_Command Cooldowns") end
            end)

            local expandedSize = UDim2.fromOffset(BASE_W, BASE_H)
            minBtn.Activated:Connect(function()
                M.minimized = not M.minimized
                content.Visible = not M.minimized
                if M.minimized then
                    panel.Size = UDim2.fromOffset(BASE_W, TITLE_H)
                    minBtn.Text = "+"
                else
                    panel.Size = expandedSize
                    minBtn.Text = "–"
                end
            end)
            minBtn.MouseButton1Click:Connect(function() end) -- keep path for some executors

            applyTheme()
        end

        function M.setVisible(vis)
            vis = vis and true or false
            M.visible = vis
            M.enabled = vis
            if vis then
                if not M.gui or not M.gui.Parent then build() end
                if M.gui then M.gui.Enabled = true end
                applyTheme()
                startWatcher()
            else
                clearConns()
                if M.gui then M.gui.Enabled = false end
            end
            pcall(function()
                if Config then
                    Config.set("command_cooldowns_visible", vis)
                    Config.set("toggle:Command Cooldowns", vis)
                end
            end)
        end

        function M.set(on)
            M.setVisible(on and true or false)
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.repaint()
            applyTheme()
        end

        _G.DataManager = _G.DataManager or {}
        _G.DataManager.updateCommand = function(command, isReady, timerText)
            if type(command) ~= "string" then return end
            command = string.lower(command)
            updateCommand(command, isReady, timerText)
            if _G._FH_CD_ONCD then
                if isReady then
                    _G._FH_CD_ONCD[command] = nil
                else
                    _G._FH_CD_ONCD[command] = true
                end
            end
        end
        _G.DataManager.isOnCooldown = function(command)
            if not command then return false end
            command = string.lower(tostring(command))
            if _G._FH_CD_ONCD and _G._FH_CD_ONCD[command] then return true end
            local lbl = M.labels[command]
            if lbl and lbl.Text and lbl.Text ~= "READY" then return true end
            return false
        end
        _G.DataManager.updateAll = function(statusTable)
            if type(statusTable) ~= "table" then return end
            for cmd, isReady in pairs(statusTable) do
                _G.DataManager.updateCommand(cmd, isReady)
            end
        end

        _G._FH_CD_UI = {
            updateCommandStatus = function(_, command, isReady, timerText)
                updateCommand(command, isReady, timerText)
            end,
            commandStatusLabels = M.labels,
        }
        _G._FH_CD_Panel = M

        task.defer(function()
            pcall(build)
            if M.gui then M.gui.Enabled = false end
        end)

        return M
    end)()

    _G.AutoTurret = (function()
        local cloneref = cloneref or function(o) return o end
        local Players = cloneref(game:GetService("Players"))
        local Workspace = cloneref(game:GetService("Workspace"))
        local lp = Players.LocalPlayer
        local autoTurretEnabled = false
        local turretConns = {}
        local turretLoopRunning = false
        local turretAttackBusy = setmetatable({}, { __mode = "k" })
        local turretAttackQueued = setmetatable({}, { __mode = "k" })
        local turretAttackCD = setmetatable({}, { __mode = "k" })
        local turretAttackActive = false
        local RETRY_DELAY = 0.3

        local function isEnemyTurret(obj)
            if not obj or not obj:IsA("BasePart") then return false end
            local ownerId = obj.Name:match("^Sentry_(%d+)$")
            return ownerId ~= nil and ownerId ~= tostring(lp.UserId)
        end

        local function setTurretNoClip(turret)
            if not isEnemyTurret(turret) then return end
            pcall(function() turret.CanCollide = false end)
        end

        local function getTurretTimeLabel(turret)
            if not turret or not turret.Parent then return nil end
            local sf = turret:FindFirstChild("SetupFrame")
            local mf = sf and sf:FindFirstChild("MainFrame")
            local lbl = mf and mf:FindFirstChild("Time")
            if lbl and lbl:IsA("TextLabel") then return lbl end
            return nil
        end

        local function shouldAttackTurret(turret)
            if not lp then return false end
            local okSteal, stealing = pcall(function()
                return lp:GetAttribute("Stealing") ~= nil
            end)
            if okSteal and stealing then return false end
            if not isEnemyTurret(turret) then return false end
            setTurretNoClip(turret)
            local lbl = getTurretTimeLabel(turret)
            if not lbl then return false end
            local ok, text = pcall(function() return lbl.Text end)
            if not ok then return false end
            text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
            return text ~= "" and string.find(text, "^%d+s!$") ~= nil
        end

        local function bringTurretInFront(turret, hrp)
            if not turret or not hrp then return end
            local fwd = hrp.CFrame.LookVector
            local pos = hrp.Position + fwd * 4 + Vector3.new(0, 1.2, 0)
            local cf = CFrame.lookAt(pos, pos + fwd)
            pcall(function()
                hrp.Velocity = Vector3.zero
                turret.RotVelocity = Vector3.zero
            end)
            pcall(function() turret.CFrame = cf end)
        end

        local function attackTurret(turret)
            local now = os.clock()
            if turretAttackBusy[turret] or turretAttackQueued[turret] or turretAttackActive or not shouldAttackTurret(turret) then return end
            if (turretAttackCD[turret] or 0) > now then return end
            turretAttackQueued[turret] = true
            turretAttackCD[turret] = now + RETRY_DELAY
            task.spawn(function()
                turretAttackQueued[turret] = nil
                if turretAttackActive or turretAttackBusy[turret] or not shouldAttackTurret(turret) then return end
                turretAttackActive = true
                turretAttackBusy[turret] = true
                pcall(function()
                    local attempts = 0
                    while attempts < 12 and autoTurretEnabled do
                        if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum or hum.Health <= 0 then break end
                        local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
                        if okD and dist > 220 then break end
                        setTurretNoClip(turret)
                        bringTurretInFront(turret, hrp)
                        if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                        local bp = lp:FindFirstChild("Backpack")
                        local bat = char:FindFirstChild("Bat") or (bp and bp:FindFirstChild("Bat"))
                        if bat and bat.Parent ~= char then
                            pcall(function() hum:EquipTool(bat) end)
                        end
                        bat = char:FindFirstChild("Bat") or bat
                        if bat then pcall(function() bat:Activate() end) end
                        task.wait(0.03)
                        if turret and turret.Parent and shouldAttackTurret(turret) then
                            setTurretNoClip(turret)
                            bringTurretInFront(turret, hrp)
                        end
                        attempts = attempts + 1
                        task.wait(0.09)
                    end
                end)
                turretAttackBusy[turret] = nil
                turretAttackActive = false
            end)
        end

        local function disconnectAll()
            for _, c in ipairs(turretConns) do
                pcall(function() c:Disconnect() end)
            end
            turretConns = {}
        end

        local function startAutoTurret()
            disconnectAll()
            table.insert(turretConns, Workspace.DescendantAdded:Connect(function(obj)
                if isEnemyTurret(obj) then setTurretNoClip(obj) end
                if autoTurretEnabled and shouldAttackTurret(obj) then
                    task.defer(attackTurret, obj)
                end
            end))
            if not turretLoopRunning then
                turretLoopRunning = true
                task.spawn(function()
                    while autoTurretEnabled do
                        task.wait(0.4)
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if isEnemyTurret(obj) then setTurretNoClip(obj) end
                            if autoTurretEnabled and shouldAttackTurret(obj) then
                                attackTurret(obj)
                            end
                        end
                    end
                    turretLoopRunning = false
                end)
            end
        end

        local M = {}
        function M.set(state)
            autoTurretEnabled = state and true or false
            if autoTurretEnabled then
                startAutoTurret()
            else
                disconnectAll()
            end
            pcall(function()
                if Config then Config.set("anti_turret", autoTurretEnabled) end
            end)
        end
        function M.isOn()
            return autoTurretEnabled
        end
        return M
    end)()

    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.AutoTurret and _G.AutoTurret.set then
                _G.AutoTurret.set(false)
            end
        end)
    end)

    _G.BoosterGUI = (function()
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        local LP = Players.LocalPlayer

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PanelGui_Booster"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 220
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Enabled = false

        local function parentGui()
            local ok = false
            pcall(function()
                if typeof(gethui) == "function" then
                    screenGui.Parent = gethui()
                    ok = screenGui.Parent ~= nil
                end
            end)
            if not ok then
                pcall(function()
                    screenGui.Parent = game:GetService("CoreGui")
                    ok = screenGui.Parent ~= nil
                end)
            end
            if not ok then
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                if pg then screenGui.Parent = pg end
            end
        end
        parentGui()

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end
        local function colBg()
            if T and typeof(T.Bg) == "Color3" then return T.Bg end
            return Color3.fromRGB(18, 16, 14)
        end
        local function colDeep()
            if T and typeof(T.BgDeep) == "Color3" then return T.BgDeep end
            return Color3.fromRGB(12, 10, 9)
        end
        local function colCard()
            if T and typeof(T.Card) == "Color3" then return T.Card end
            return Color3.fromRGB(28, 24, 20)
        end
        local function colText()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(250, 245, 235)
        end
        local function colDim()
            if T and typeof(T.TextDim) == "Color3" then return T.TextDim end
            return Color3.fromRGB(160, 140, 120)
        end
        local function colSoft()
            if T and typeof(T.Soft) == "Color3" then return T.Soft end
            return Color3.fromRGB(34, 28, 22)
        end

        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "Frame"
        mainFrame.Size = UDim2.new(0, 200, 0, 132)
        -- Position par défaut à gauche pour être visible dès l'activation
        mainFrame.Position = UDim2.new(0, 12, 0.35, 0)
        mainFrame.BackgroundColor3 = colBg()
        mainFrame.BackgroundTransparency = 0.08
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.ClipsDescendants = false
        mainFrame.Parent = screenGui
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = mainFrame
        end
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Parent = mainFrame
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colPrimary()),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
        grad.Rotation = 200
        grad.Parent = stroke

        pcall(function()
            if loadGuiPosition then loadGuiPosition("PanelGui_Booster", mainFrame) end
            if loadGuiSize then loadGuiSize("PanelGui_Booster", mainFrame, 180, 110) end
        end)

        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 24)
        titleBar.BackgroundColor3 = colDeep()
        titleBar.BorderSizePixel = 0
        titleBar.Active = true
        titleBar.Parent = mainFrame
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = titleBar
        end
        local titleFill = Instance.new("Frame")
        titleFill.Size = UDim2.new(1, 0, 0, 8)
        titleFill.Position = UDim2.new(0, 0, 1, -8)
        titleFill.BackgroundColor3 = colDeep()
        titleFill.BorderSizePixel = 0
        titleFill.Parent = titleBar

        pcall(function()
            local style = _G._CyutsudStyleLikeHub
            if style then style(mainFrame, titleBar) end
        end)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -32, 1, 0)
        titleLbl.Position = UDim2.new(0, 8, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "Booster"
        titleLbl.TextColor3 = colText()
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 12
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = titleBar

        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 18, 0, 18)
        minBtn.Position = UDim2.new(1, -22, 0.5, -9)
        minBtn.BackgroundColor3 = colSoft()
        minBtn.Text = "–"
        minBtn.TextColor3 = colText()
        minBtn.Font = Enum.Font.GothamBold
        minBtn.TextSize = 13
        minBtn.AutoButtonColor = false
        minBtn.ZIndex = 25
        minBtn.Active = true
        minBtn.Parent = titleBar
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = minBtn
        end

        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, 0, 1, -24)
        content.Position = UDim2.new(0, 0, 0, 24)
        content.BackgroundTransparency = 1
        content.Parent = mainFrame
        do
            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 4)
            pad.PaddingLeft = UDim.new(0, 6)
            pad.PaddingRight = UDim.new(0, 6)
            pad.PaddingBottom = UDim.new(0, 4)
            pad.Parent = content
            local list = Instance.new("UIListLayout")
            list.Padding = UDim.new(0, 3)
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Parent = content
        end

        local toggleRow = Instance.new("Frame")
        toggleRow.Size = UDim2.new(1, 0, 0, 32)
        toggleRow.BackgroundColor3 = colCard()
        toggleRow.BorderSizePixel = 0
        toggleRow.LayoutOrder = 1
        toggleRow.Parent = content
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 10)
            c.Parent = toggleRow
        end
        do
            local s = Instance.new("UIStroke")
            s.Thickness = 1
            s.Color = Color3.fromRGB(255, 255, 255)
            s.Transparency = 0.85
            s.Parent = toggleRow
        end

        local toggleLbl = Instance.new("TextLabel")
        toggleLbl.Size = UDim2.new(1, -56, 1, 0)
        toggleLbl.Position = UDim2.new(0, 10, 0, 0)
        toggleLbl.BackgroundTransparency = 1
        toggleLbl.Text = "Booster"
        toggleLbl.TextColor3 = colText()
        toggleLbl.Font = Enum.Font.GothamBold
        toggleLbl.TextSize = 12
        toggleLbl.TextXAlignment = Enum.TextXAlignment.Left
        toggleLbl.TextYAlignment = Enum.TextYAlignment.Center
        toggleLbl.ZIndex = 2
        toggleLbl.Parent = toggleRow

        local pill = Instance.new("Frame")
        pill.Name = "Toggle"
        pill.Size = UDim2.new(0, 42, 0, 22)
        pill.Position = UDim2.new(1, -50, 0.5, -11)
        pill.BackgroundColor3 = Color3.fromRGB(30, 20, 48)
        pill.BorderSizePixel = 0
        pill.ZIndex = 3
        pill.Parent = toggleRow
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = pill
        end
        do
            local s = Instance.new("UIStroke")
            s.Thickness = 1.2
            s.Color = Color3.fromRGB(0, 0, 0)
            s.Transparency = 0.25
            s.Parent = pill
        end

        local activeFill = Instance.new("Frame")
        activeFill.Size = UDim2.new(1, 0, 1, 0)
        activeFill.BackgroundColor3 = colPrimary()
        activeFill.BackgroundTransparency = 1
        activeFill.BorderSizePixel = 0
        activeFill.ZIndex = 4
        activeFill.Parent = pill
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = activeFill
        end

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new(0, 3, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(180, 160, 210)
        knob.BorderSizePixel = 0
        knob.ZIndex = 5
        knob.Parent = pill
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = knob
        end
        do
            local s = Instance.new("UIStroke")
            s.Thickness = 1
            s.Color = Color3.fromRGB(0, 0, 0)
            s.Transparency = 0.65
            s.Parent = knob
        end

        local toggleClick = Instance.new("TextButton")
        toggleClick.Size = UDim2.new(1, 0, 1, 0)
        toggleClick.BackgroundTransparency = 1
        toggleClick.Text = ""
        toggleClick.AutoButtonColor = false
        toggleClick.ZIndex = 6
        toggleClick.Parent = toggleRow

        local isOn = false
        local function updateToggle(animate)
            local knobOn = UDim2.new(0, 23, 0.5, -8)
            local knobOff = UDim2.new(0, 3, 0.5, -8)
            local targetPos = isOn and knobOn or knobOff
            local fillT = isOn and 0 or 1
            local knobCol = isOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 160, 210)
            activeFill.BackgroundColor3 = colPrimary()
            if animate then
                TweenService:Create(activeFill, TweenInfo.new(0.18), { BackgroundTransparency = fillT }):Play()
                TweenService:Create(knob, TweenInfo.new(0.18), { Position = targetPos, BackgroundColor3 = knobCol }):Play()
            else
                activeFill.BackgroundTransparency = fillT
                knob.Position = targetPos
                knob.BackgroundColor3 = knobCol
            end
        end

        toggleClick.Activated:Connect(function()
            isOn = not isOn
            updateToggle(true)
            if Booster and Booster.set then Booster.set(isOn) end
            pcall(function()
                if Config then Config.set("booster_on", isOn) end
            end)
        end)

        local function makeField(order, label, defaultText, onCommit)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 22)
            row.BackgroundTransparency = 1
            row.LayoutOrder = order
            row.Parent = content

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.52, -2, 1, 0)
            lbl.Position = UDim2.new(0, 2, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = colText()
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.42, 0, 0, 18)
            box.Position = UDim2.new(0.58, 0, 0.5, -9)
            box.BackgroundColor3 = colDeep()
            box.Text = defaultText
            box.TextColor3 = colText()
            box.PlaceholderColor3 = colDim()
            box.Font = Enum.Font.GothamBold
            box.TextSize = 11
            box.ClearTextOnFocus = false
            box.Parent = row
            do
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0, 12)
                c.Parent = box
                local s = Instance.new("UIStroke")
                s.Color = colPrimary()
                s.Thickness = 1
                s.Transparency = 0.55
                s.Parent = box
            end
            box.FocusLost:Connect(function()
                onCommit(box)
            end)
            return box
        end

        local wsBox = makeField(2, "Walk Speed", tostring(Booster.speed), function(box)
            local val = tonumber(box.Text)
            if val and Booster.setSpeed then
                Booster.setSpeed(val)
                box.Text = tostring(Booster.speed)
            else
                box.Text = tostring(Booster.speed)
            end
        end)
        local jpBox = makeField(3, "Jump Power", tostring(Booster.jump), function(box)
            local val = tonumber(box.Text)
            if val and Booster.setJump then
                Booster.setJump(val)
                box.Text = tostring(Booster.jump)
            else
                box.Text = tostring(Booster.jump)
            end
        end)

        do
            local _drag = _G.makePanelDraggable or makePanelDraggable
            if _drag then _drag(titleBar, mainFrame, "PanelGui_Booster") end
        end

        local minimized = false
        local TITLE_H = 24
        local expandedSize = mainFrame.Size
        minBtn.Activated:Connect(function()
            minimized = not minimized
            if minimized then
                expandedSize = mainFrame.Size
                content.Visible = false
                mainFrame.ClipsDescendants = true
                mainFrame.Size = UDim2.new(expandedSize.X.Scale, expandedSize.X.Offset, 0, TITLE_H)
                minBtn.Text = "+"
            else
                mainFrame.Size = expandedSize
                content.Visible = true
                mainFrame.ClipsDescendants = false
                minBtn.Text = "–"
            end
        end)

        local function repaintPanel()
            mainFrame.BackgroundColor3 = colBg()
            titleBar.BackgroundColor3 = colDeep()
            titleFill.BackgroundColor3 = colDeep()
            titleLbl.TextColor3 = colText()
            minBtn.BackgroundColor3 = colSoft()
            minBtn.TextColor3 = colText()
            toggleLbl.TextColor3 = colText()
            if isOn then
                activeFill.BackgroundColor3 = colPrimary()
                activeFill.BackgroundTransparency = 0
            end
            if toggleRow then toggleRow.BackgroundColor3 = colCard() end
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, colPrimary()),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            })
        end

        task.defer(function()
            local saved = false
            pcall(function()
                if Config then saved = Config.get("booster_on", false) and true or false end
            end)
            if saved then
                isOn = true
                if Booster and Booster.set then Booster.set(true) end
            end
            updateToggle(false)
        end)

        local API = {
            screenGui = screenGui,
            frame = mainFrame,
            setVisible = function(v)
                v = v and true or false
                if v then
                    -- Toujours placer le panel à gauche à l'activation pour qu'il soit visible
                    mainFrame.Position = UDim2.new(0, 12, 0.35, 0)
                    mainFrame.AnchorPoint = Vector2.new(0, 0)
                end
                screenGui.Enabled = v
                pcall(function()
                    if Config then
                        Config.set("booster_gui_visible", v)
                    end
                end)
            end,
            isVisible = function()
                return screenGui.Enabled
            end,
            set = function(v)
                API.setVisible(v)
            end,
            repaint = repaintPanel,
            syncToggle = function(state)
                isOn = state and true or false
                updateToggle(false)
            end,
        }
        return API
    end)()

    local noop = function(state) end


    ----------------------------------------------------------------
    -- Cyutsud hub All Gear: when ON, disables listed features + hides ragdoll actions
    ----------------------------------------------------------------

    ----------------------------------------------------------------
    -- TP Brainrot (Duel) — themed + pos save + gamepad keybind
    ----------------------------------------------------------------
    _G.TPBrainrot = (function()
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        local LocalPlayer = Players.LocalPlayer

        local M = { enabled = false, gui = nil, main = nil }
        local basePos, petPos = nil, nil
        local baseMarker, petMarker = nil, nil
        local autoPot = false
        local isSettingKeybind = false
        local currentBind = { type = "KeyCode", value = Enum.KeyCode.T }
        local minimized = false
        local refs = {}

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end
        local function colBg()
            if T and typeof(T.Bg) == "Color3" then return T.Bg end
            return Color3.fromRGB(14, 10, 22)
        end
        local function colDeep()
            if T and typeof(T.BgDeep) == "Color3" then return T.BgDeep end
            return Color3.fromRGB(8, 6, 14)
        end
        local function colCard()
            if T and typeof(T.Card) == "Color3" then return T.Card end
            return Color3.fromRGB(24, 16, 38)
        end
        local function colText()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(245, 240, 255)
        end
        local function colDim()
            if T and typeof(T.TextDim) == "Color3" then return T.TextDim end
            return Color3.fromRGB(170, 150, 200)
        end

        local function bindToText(bind)
            if not bind or not bind.value then return "?" end
            local name = bind.value.Name
            if bind.type == "UserInputType" then
                if name == "MouseButton4" then return "M4" end
                if name == "MouseButton5" then return "M5" end
                return name
            end
            local map = {
                ButtonA = "A/X", ButtonB = "B/O", ButtonX = "X/□", ButtonY = "Y/△",
                ButtonL1 = "LB/L1", ButtonR1 = "RB/R1", ButtonL2 = "LT/L2", ButtonR2 = "RT/R2",
                ButtonL3 = "L3", ButtonR3 = "R3", ButtonStart = "Start", ButtonSelect = "Select",
                DPadUp = "D-Up", DPadDown = "D-Down", DPadLeft = "D-Left", DPadRight = "D-Right",
            }
            return map[name] or name
        end

        local function loadKeybind()
            pcall(function()
                if Config then
                    local t = Config.get("tp_brainrot_bind_type", nil)
                    local v = Config.get("tp_brainrot_bind_value", nil)
                    if type(t) == "string" and type(v) == "string" then
                        if t == "KeyCode" and Enum.KeyCode[v] then
                            currentBind = { type = "KeyCode", value = Enum.KeyCode[v] }
                            return
                        elseif t == "UserInputType" and Enum.UserInputType[v] then
                            currentBind = { type = "UserInputType", value = Enum.UserInputType[v] }
                            return
                        end
                    end
                    local legacy = Config.get("tp_brainrot_keybind", nil)
                    if type(legacy) == "string" and Enum.KeyCode[legacy] then
                        currentBind = { type = "KeyCode", value = Enum.KeyCode[legacy] }
                        return
                    end
                end
                if isfile and isfile("CYUTSUD_TP_BRAINROT_Keybind.txt") and readfile then
                    local result = readfile("CYUTSUD_TP_BRAINROT_Keybind.txt")
                    if result then
                        local bt, bv = result:match("([^|]+)|([^|]+)")
                        if bt and bv then
                            if bt == "KeyCode" and Enum.KeyCode[bv] then
                                currentBind = { type = "KeyCode", value = Enum.KeyCode[bv] }
                            elseif bt == "UserInputType" and Enum.UserInputType[bv] then
                                currentBind = { type = "UserInputType", value = Enum.UserInputType[bv] }
                            end
                        elseif Enum.KeyCode[result] then
                            currentBind = { type = "KeyCode", value = Enum.KeyCode[result] }
                        end
                    end
                end
            end)
        end

        local function saveKeybind()
            pcall(function()
                if Config then
                    Config.set("tp_brainrot_bind_type", currentBind.type)
                    Config.set("tp_brainrot_bind_value", currentBind.value.Name)
                    Config.set("tp_brainrot_keybind", currentBind.value.Name)
                    if Config.flush then Config.flush() end
                end
                if writefile then
                    writefile("CYUTSUD_TP_BRAINROT_Keybind.txt", currentBind.type .. "|" .. currentBind.value.Name)
                end
            end)
        end

        local function createMarker(pos, color)
            local part = Instance.new("Part")
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(2.5, 2.5, 2.5)
            part.Material = Enum.Material.Neon
            part.Anchored = true
            part.CanCollide = false
            part.Position = pos + Vector3.new(0, 2, 0)
            part.Color = color
            part.Name = "NoxTPBrainrotMarker"
            part.Parent = workspace
            return part
        end

        local function equipCarpet()
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if not char or not bp then return false end
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then tool.Parent = bp end
            end
            local preferred = nil
            pcall(function()
                preferred = _G.coreSelectedCarpet or _G.CyutsudHubSelectedCarpet
            end)
            for _, tool in pairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if preferred and n:find(tostring(preferred):lower(), 1, true) then
                        tool.Parent = char
                        return true
                    end
                end
            end
            for _, tool in pairs(bp:GetChildren()) do
                if tool:IsA("Tool") and string.find(tool.Name:lower(), "carpet") then
                    tool.Parent = char
                    return true
                end
            end
            return false
        end

        local function updateTpBtnText()
            if refs.btn4 then
                refs.btn4.Text = "TP [" .. bindToText(currentBind) .. "]"
            end
        end

        local function doTeleport()
            if not M.enabled then return end
            if not basePos or not petPos then
                if refs.btn4 then
                    refs.btn4.Text = "Points manquants"
                    task.delay(1, updateTpBtnText)
                end
                return
            end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if refs.btn4 then refs.btn4.Text = "Teleportation..." end
            equipCarpet()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(basePos + Vector3.new(0, 3, 0))
            task.wait(0.1)
            hrp.CFrame = CFrame.new(petPos + Vector3.new(0, 3, 0))
            if refs.btn4 then refs.btn4.Text = "TP effectue" end
            if autoPot then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                task.wait(0.15)
                if bp then
                    for _, tool in pairs(bp:GetChildren()) do
                        if tool:IsA("Tool") then
                            local n = tool.Name:lower()
                            if n:find("giant") or n:find("huge") or n:find("gigant") then
                                tool.Parent = LocalPlayer.Character
                                task.wait(0.1)
                                pcall(function() tool:Activate() end)
                                break
                            end
                        end
                    end
                end
            end
            task.delay(0.8, updateTpBtnText)
        end

        local function matchesBind(input)
            if not currentBind or not currentBind.value then return false end
            if currentBind.type == "KeyCode" then
                return input.KeyCode == currentBind.value
            elseif currentBind.type == "UserInputType" then
                return input.UserInputType == currentBind.value
            end
            return false
        end

        local function isGamepad(input)
            local t = input.UserInputType
            return t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
                or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4
                or t == Enum.UserInputType.Gamepad5 or t == Enum.UserInputType.Gamepad6
                or t == Enum.UserInputType.Gamepad7 or t == Enum.UserInputType.Gamepad8
        end

        local function isSideMouse(input)
            local n = input.UserInputType.Name
            return n == "MouseButton4" or n == "MouseButton5"
        end

        local inputConn = nil
        local function wireInput()
            if inputConn then pcall(function() inputConn:Disconnect() end) end
            inputConn = UserInputService.InputBegan:Connect(function(input, gp)
                if gp and not isGamepad(input) then return end
                if isSettingKeybind then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            isSettingKeybind = false
                            updateTpBtnText()
                            if refs.btn4 then refs.btn4.BackgroundColor3 = colCard() end
                            return
                        end
                        currentBind = { type = "KeyCode", value = input.KeyCode }
                        isSettingKeybind = false
                        saveKeybind()
                        updateTpBtnText()
                        if refs.btn4 then refs.btn4.BackgroundColor3 = colPrimary() end
                        return
                    end
                    if isSideMouse(input) then
                        currentBind = { type = "UserInputType", value = input.UserInputType }
                        isSettingKeybind = false
                        saveKeybind()
                        updateTpBtnText()
                        if refs.btn4 then refs.btn4.BackgroundColor3 = colPrimary() end
                        return
                    end
                    if isGamepad(input) and input.KeyCode ~= Enum.KeyCode.Unknown
                        and input.KeyCode ~= Enum.KeyCode.Thumbstick1
                        and input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
                        currentBind = { type = "KeyCode", value = input.KeyCode }
                        isSettingKeybind = false
                        saveKeybind()
                        updateTpBtnText()
                        if refs.btn4 then refs.btn4.BackgroundColor3 = colPrimary() end
                        return
                    end
                    return
                end
                if not M.enabled then return end
                if matchesBind(input) then
                    task.spawn(doTeleport)
                end
            end)
        end

        local function savePos()
            pcall(function()
                if not M.main then return end
                if saveGuiPosition then
                    saveGuiPosition("PanelGui_TP Brainrot", M.main)
                elseif Config then
                    local positions = Config.get("positions", {}) or {}
                    if type(positions) ~= "table" then positions = {} end
                    local pos = M.main.Position
                    positions["PanelGui_TP Brainrot"] = {
                        pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset,
                    }
                    Config.set("positions", positions)
                    if Config.flush then Config.flush() end
                end
            end)
        end

        local function loadPos()
            pcall(function()
                if not M.main then return end
                if loadGuiPosition and loadGuiPosition("PanelGui_TP Brainrot", M.main) then return end
                if Config then
                    local positions = Config.get("positions", {}) or {}
                    local p = positions["PanelGui_TP Brainrot"]
                    if type(p) == "table" and #p >= 4 then
                        M.main.Position = UDim2.new(p[1], p[2], p[3], p[4])
                    end
                end
            end)
        end

        local function makeBtn(parent, text, y, bg)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -24, 0, 34)
            btn.Position = UDim2.new(0, 12, 0, y)
            btn.BackgroundColor3 = bg or colCard()
            btn.BackgroundTransparency = 0.05
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = colText()
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 13
            btn.AutoButtonColor = false
            btn.Parent = parent
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 10)
            c.Parent = btn
            local s = Instance.new("UIStroke")
            s.Color = Color3.fromRGB(0, 0, 0)
            s.Thickness = 1.2
            s.Transparency = 0.35
            s.Parent = btn
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.05}):Play()
            end)
            return btn
        end

        local function build()
            if M.gui and M.gui.Parent then return end
            loadKeybind()
            pcall(function()
                for _, parent in ipairs({
                    (typeof(gethui) == "function" and gethui()) or nil,
                    game:GetService("CoreGui"),
                    LocalPlayer:FindFirstChildOfClass("PlayerGui"),
                }) do
                    if parent then
                        local old = parent:FindFirstChild("PanelGui_TP Brainrot")
                        if old then old:Destroy() end
                        local old2 = parent:FindFirstChild("CYUTSUD_TP_BRAINROT")
                        if old2 then old2:Destroy() end
                    end
                end
            end)

            local gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_TP Brainrot"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 260
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = false
            M.gui = gui

            local parented = false
            pcall(function()
                if typeof(gethui) == "function" then
                    gui.Parent = gethui()
                    parented = gui.Parent ~= nil
                end
            end)
            if not parented then
                pcall(function()
                    gui.Parent = game:GetService("CoreGui")
                    parented = gui.Parent ~= nil
                end)
            end
            if not parented then
                local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pg then gui.Parent = pg end
            end

            local main = Instance.new("Frame")
            main.Name = "Frame"
            main.Size = UDim2.new(0, 220, 0, 250)
            main.Position = UDim2.new(0.5, -110, 0.4, 0)
            main.BackgroundColor3 = colBg()
            main.BackgroundTransparency = 0.02
            main.BorderSizePixel = 0
            main.Active = true
            main.Parent = gui
            M.main = main
            local mc = Instance.new("UICorner")
            mc.CornerRadius = UDim.new(0, 14)
            mc.Parent = main

            local stroke = Instance.new("UIStroke")
            stroke.Color = colPrimary()
            stroke.Thickness = 1.8
            stroke.Transparency = 0.1
            stroke.Parent = main
            refs.stroke = stroke

            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 34)
            titleBar.BackgroundColor3 = colDeep()
            titleBar.BorderSizePixel = 0
            titleBar.Parent = main
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(0, 14)
            tc.Parent = titleBar
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(1, 0, 0, 10)
            fill.Position = UDim2.new(0, 0, 1, -10)
            fill.BackgroundColor3 = colDeep()
            fill.BorderSizePixel = 0
            fill.Parent = titleBar

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -40, 1, 0)
            title.Position = UDim2.new(0, 36, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "TP BRAINROT"
            title.TextColor3 = colText()
            title.Font = Enum.Font.GothamBlack
            title.TextSize = 13
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = titleBar
            refs.title = title

            local accent = Instance.new("Frame")
            accent.Name = "HubAccent"
            accent.Size = UDim2.new(1, 0, 0, 2)
            accent.Position = UDim2.new(0, 0, 1, -2)
            accent.BackgroundColor3 = colPrimary()
            accent.BorderSizePixel = 0
            accent.Parent = titleBar
            refs.accent = accent

            pcall(function()
                if type(_G._CyutsudAttachSideImage) == "function" then
                    _G._CyutsudAttachSideImage(main, titleBar)
                end
            end)
            pcall(function()
                if type(_G._CyutsudStyleLikeHub) == "function" then
                    _G._CyutsudStyleLikeHub(main, titleBar)
                end
            end)

            local minBtn = Instance.new("TextButton")
            minBtn.Size = UDim2.new(0, 22, 0, 22)
            minBtn.Position = UDim2.new(1, -28, 0, 6)
            minBtn.BackgroundColor3 = colCard()
            minBtn.Text = "–"
            minBtn.TextColor3 = colText()
            minBtn.Font = Enum.Font.GothamBold
            minBtn.TextSize = 14
            minBtn.AutoButtonColor = false
            minBtn.Parent = titleBar
            Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

            local btn1 = makeBtn(main, "Base joueur", 44, colCard())
            local btn2 = makeBtn(main, "Pet joueur", 86, colCard())
            local btn3 = makeBtn(main, "Auto Potion : OFF", 128, Color3.fromRGB(90, 40, 70))
            local btn4 = makeBtn(main, "TP [" .. bindToText(currentBind) .. "]", 170, colPrimary())
            refs.btn1, refs.btn2, refs.btn3, refs.btn4 = btn1, btn2, btn3, btn4

            -- restore auto pot
            pcall(function()
                if Config and Config.get("tp_brainrot_auto_pot", false) then
                    autoPot = true
                    btn3.Text = "Auto Potion : ON"
                    btn3.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
                end
            end)

            btn3.MouseButton1Click:Connect(function()
                autoPot = not autoPot
                if autoPot then
                    btn3.Text = "Auto Potion : ON"
                    btn3.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
                else
                    btn3.Text = "Auto Potion : OFF"
                    btn3.BackgroundColor3 = Color3.fromRGB(90, 40, 70)
                end
                pcall(function()
                    if Config then
                        Config.set("tp_brainrot_auto_pot", autoPot)
                        if Config.flush then Config.flush() end
                    end
                end)
            end)

            minBtn.MouseButton1Click:Connect(function()
                minimized = not minimized
                if minimized then
                    btn1.Visible = false
                    btn2.Visible = false
                    btn3.Visible = false
                    main.Size = UDim2.new(0, 220, 0, 90)
                    btn4.Position = UDim2.new(0, 12, 0, 44)
                    minBtn.Text = "+"
                else
                    btn1.Visible = true
                    btn2.Visible = true
                    btn3.Visible = true
                    main.Size = UDim2.new(0, 220, 0, 250)
                    btn4.Position = UDim2.new(0, 12, 0, 170)
                    minBtn.Text = "–"
                end
                savePos()
            end)

            btn1.MouseButton1Click:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    basePos = hrp.Position
                    if baseMarker then pcall(function() baseMarker:Destroy() end) end
                    baseMarker = createMarker(basePos, colPrimary())
                    btn1.Text = "Base sauvegardee"
                    task.delay(0.8, function() if btn1 and btn1.Parent then btn1.Text = "Base joueur" end end)
                end
            end)

            btn2.MouseButton1Click:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    petPos = hrp.Position
                    if petMarker then pcall(function() petMarker:Destroy() end) end
                    petMarker = createMarker(petPos, Color3.fromRGB(200, 120, 255))
                    btn2.Text = "Pet sauvegarde"
                    task.delay(0.8, function() if btn2 and btn2.Parent then btn2.Text = "Pet joueur" end end)
                end
            end)

            btn4.MouseButton1Click:Connect(function()
                if not isSettingKeybind then task.spawn(doTeleport) end
            end)
            btn4.MouseButton2Click:Connect(function()
                if isSettingKeybind then return end
                isSettingKeybind = true
                btn4.Text = "Touche / pad..."
                btn4.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            end)

            -- drag
            local dragging, dragStart, startPos = false, nil, nil
            titleBar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    if _G._FH_GuiLocked then return end
                    dragging = true
                    dragStart = inp.Position
                    startPos = main.Position
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseMovement
                    and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                if _G._FH_GuiLocked then dragging = false; return end
                local d = inp.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        savePos()
                    end
                end
            end)

            loadPos()
            wireInput()
        end

        function M.repaint()
            pcall(function()
                if not M.main then return end
                M.main.BackgroundColor3 = colBg()
                local tb = M.main:FindFirstChild("TitleBar")
                if tb then tb.BackgroundColor3 = colDeep() end
                if refs.accent then refs.accent.BackgroundColor3 = colPrimary() end
                if refs.stroke then refs.stroke.Color = colPrimary() end
                if refs.title then refs.title.TextColor3 = colText() end
                if refs.btn4 and not isSettingKeybind then
                    refs.btn4.BackgroundColor3 = colPrimary()
                end
            end)
        end

        function M.set(on, skipSave)
            on = on and true or false
            M.enabled = on
            if on then
                if not M.gui or not M.gui.Parent then build() end
                if M.gui then M.gui.Enabled = true end
                M.repaint()
            else
                if M.gui then M.gui.Enabled = false end
                isSettingKeybind = false
            end
            if not skipSave then
                pcall(function()
                    if setToggleSaved then setToggleSaved("TP Brainrot", on) end
                end)
                pcall(function()
                    if Config then
                        Config.set("tp_brainrot_visible", on)
                        if Config.flush then Config.flush() end
                    end
                end)
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                if M.gui then M.gui:Destroy() end
                if baseMarker then baseMarker:Destroy() end
                if petMarker then petMarker:Destroy() end
                if inputConn then inputConn:Disconnect() end
            end)
        end)

        return M
    end)()

    ----------------------------------------------------------------
    -- Drop Brainrot (Duel) — themed + pos save
    ----------------------------------------------------------------
    _G.DropBrainrot = (function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local LP = Players.LocalPlayer

        local M = { enabled = false, gui = nil, btn = nil }
        local KeyLabel = nil
        local dropBrainrotActive = false
        local DROP_ASCEND_DURATION = 0.2
        local DROP_ASCEND_SPEED = 150
        local currentBind = { type = "KeyCode", value = Enum.KeyCode.X }
        local isSettingKeybind = false
        local inputConn = nil
        local refs = {}

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end
        local function colBg()
            if T and typeof(T.Bg) == "Color3" then return T.Bg end
            return Color3.fromRGB(14, 10, 22)
        end
        local function colText()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(245, 240, 255)
        end
        local function colDim()
            if T and typeof(T.TextDim) == "Color3" then return T.TextDim end
            return Color3.fromRGB(170, 150, 200)
        end

        local function findTool(container, keywords)
            if not container then return nil end
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local n = item.Name:lower()
                    for _, kw in ipairs(keywords) do
                        if n:find(kw, 1, true) then return item end
                    end
                end
            end
            return nil
        end

        local function useCapLaserThenRestore()
            task.spawn(function()
                local char = LP.Character
                local bp = LP:FindFirstChild("Backpack")
                if not char or not bp then return end
                local previousTool = nil
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") then previousTool = item; break end
                end
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") then item.Parent = bp end
                end
                task.wait(0.05)
                local keywords = { "cap laser", "caplaser", "laser cap", "lasercap", "cap_laser" }
                local cap = findTool(bp, keywords) or findTool(char, keywords)
                if not cap then
                    if previousTool and previousTool.Parent then previousTool.Parent = char end
                    return
                end
                cap.Parent = char
                task.wait(0.08)
                pcall(function() cap:Activate() end)
                task.wait(0.12)
                pcall(function() cap:Activate() end)
                task.wait(0.1)
                if cap and cap.Parent == char then cap.Parent = bp end
                task.wait(0.05)
                if previousTool and previousTool.Parent then previousTool.Parent = char end
            end)
        end

        local function runDropBrainrot(force)
            if not force and not M.enabled then return end
            if dropBrainrotActive then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            dropBrainrotActive = true
            local startTime = tick()
            local dropConn
            dropConn = RunService.Heartbeat:Connect(function()
                local currentChar = LP.Character
                local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                if not currentChar or not currentRoot then
                    if dropConn then dropConn:Disconnect() end
                    dropBrainrotActive = false
                    return
                end
                if tick() - startTime >= DROP_ASCEND_DURATION then
                    if dropConn then dropConn:Disconnect() end
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = { currentChar }
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
                    if rayResult then
                        local hum = currentChar:FindFirstChildOfClass("Humanoid")
                        local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                        currentRoot.CFrame = CFrame.new(
                            currentRoot.Position.X,
                            rayResult.Position.Y + offset,
                            currentRoot.Position.Z
                        )
                        currentRoot.AssemblyLinearVelocity = Vector3.zero
                        currentRoot.AssemblyAngularVelocity = Vector3.zero
                    end
                    dropBrainrotActive = false
                    useCapLaserThenRestore()
                    return
                end
                currentRoot.Velocity = Vector3.new(
                    currentRoot.Velocity.X,
                    DROP_ASCEND_SPEED,
                    currentRoot.Velocity.Z
                )
            end)
        end

        local function bindToText(bind)
            if not bind or not bind.value then return "?" end
            local name = bind.value.Name
            if bind.type == "UserInputType" then
                if name == "MouseButton4" then return "M4" end
                if name == "MouseButton5" then return "M5" end
                return name
            end
            local map = {
                ButtonA = "A/X", ButtonB = "B/O", ButtonX = "X/□", ButtonY = "Y/△",
                ButtonL1 = "LB/L1", ButtonR1 = "RB/R1", ButtonL2 = "LT/L2", ButtonR2 = "RT/R2",
                ButtonL3 = "L3", ButtonR3 = "R3", ButtonStart = "Start", ButtonSelect = "Select",
                DPadUp = "D-Up", DPadDown = "D-Down", DPadLeft = "D-Left", DPadRight = "D-Right",
            }
            return map[name] or name
        end

        local function loadKeybind()
            pcall(function()
                if Config then
                    local t = Config.get("drop_brainrot_bind_type", nil)
                    local v = Config.get("drop_brainrot_bind_value", nil)
                    if type(t) == "string" and type(v) == "string" then
                        if t == "KeyCode" and Enum.KeyCode[v] then
                            currentBind = { type = "KeyCode", value = Enum.KeyCode[v] }
                            return
                        elseif t == "UserInputType" and Enum.UserInputType[v] then
                            currentBind = { type = "UserInputType", value = Enum.UserInputType[v] }
                            return
                        end
                    end
                end
                if isfile and isfile("DropBrainrot_Keybind.txt") and readfile then
                    local result = readfile("DropBrainrot_Keybind.txt")
                    if result then
                        local t, v = result:match("([^|]+)|([^|]+)")
                        if t and v then
                            if t == "KeyCode" and Enum.KeyCode[v] then
                                currentBind = { type = "KeyCode", value = Enum.KeyCode[v] }
                            elseif t == "UserInputType" and Enum.UserInputType[v] then
                                currentBind = { type = "UserInputType", value = Enum.UserInputType[v] }
                            end
                        elseif Enum.KeyCode[result] then
                            currentBind = { type = "KeyCode", value = Enum.KeyCode[result] }
                        end
                    end
                end
            end)
        end

        local function saveKeybind()
            pcall(function()
                if Config then
                    Config.set("drop_brainrot_bind_type", currentBind.type)
                    Config.set("drop_brainrot_bind_value", currentBind.value.Name)
                    if Config.flush then Config.flush() end
                end
                if writefile then
                    writefile("DropBrainrot_Keybind.txt", currentBind.type .. "|" .. currentBind.value.Name)
                end
            end)
        end

        local function updateKeyLabel()
            if KeyLabel then KeyLabel.Text = bindToText(currentBind) end
        end

        local function matchesBind(input)
            if currentBind.type == "KeyCode" then
                return input.KeyCode == currentBind.value
            elseif currentBind.type == "UserInputType" then
                return input.UserInputType == currentBind.value
            end
            return false
        end

        local function isGamepad(input)
            local t = input.UserInputType
            return t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
                or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4
        end

        local function isSideMouse(input)
            local n = input.UserInputType.Name
            return n == "MouseButton4" or n == "MouseButton5"
        end

        local function finishKeybind()
            isSettingKeybind = false
            saveKeybind()
            updateKeyLabel()
            if M.btn then M.btn.BackgroundColor3 = colBg() end
        end

        local function wireInput()
            if inputConn then pcall(function() inputConn:Disconnect() end) end
            inputConn = UserInputService.InputBegan:Connect(function(input, gp)
                if gp and not isGamepad(input) then return end
                if isSettingKeybind then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            finishKeybind()
                            return
                        end
                        currentBind = { type = "KeyCode", value = input.KeyCode }
                        finishKeybind()
                        return
                    end
                    if isSideMouse(input) then
                        currentBind = { type = "UserInputType", value = input.UserInputType }
                        finishKeybind()
                        return
                    end
                    if isGamepad(input) and input.KeyCode ~= Enum.KeyCode.Unknown
                        and input.KeyCode ~= Enum.KeyCode.Thumbstick1
                        and input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
                        currentBind = { type = "KeyCode", value = input.KeyCode }
                        finishKeybind()
                        return
                    end
                    return
                end
                if not M.enabled then return end
                if matchesBind(input) then
                    runDropBrainrot()
                end
            end)
        end

        local function savePos()
            pcall(function()
                if not M.btn then return end
                if saveGuiPosition then
                    saveGuiPosition("PanelGui_Drop Brainrot", M.btn)
                elseif Config then
                    local positions = Config.get("positions", {}) or {}
                    if type(positions) ~= "table" then positions = {} end
                    local pos = M.btn.Position
                    positions["PanelGui_Drop Brainrot"] = {
                        pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset,
                    }
                    Config.set("positions", positions)
                    if Config.flush then Config.flush() end
                end
            end)
        end

        local function loadPos()
            pcall(function()
                if not M.btn then return end
                if loadGuiPosition and loadGuiPosition("PanelGui_Drop Brainrot", M.btn) then return end
                if Config then
                    local positions = Config.get("positions", {}) or {}
                    local p = positions["PanelGui_Drop Brainrot"]
                    if type(p) == "table" and #p >= 4 then
                        M.btn.Position = UDim2.new(p[1], p[2], p[3], p[4])
                    end
                end
            end)
        end

        local function build()
            if M.gui and M.gui.Parent then return end
            loadKeybind()
            pcall(function()
                for _, parent in ipairs({
                    (typeof(gethui) == "function" and gethui()) or nil,
                    game:GetService("CoreGui"),
                    LP:FindFirstChildOfClass("PlayerGui"),
                }) do
                    if parent then
                        local old = parent:FindFirstChild("PanelGui_Drop Brainrot") or parent:FindFirstChild("DropBrainrot")
                        if old then old:Destroy() end
                    end
                end
            end)

            local gui = Instance.new("ScreenGui")
            gui.Name = "PanelGui_Drop Brainrot"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.DisplayOrder = 999
            gui.Enabled = false
            M.gui = gui

            local parented = false
            pcall(function()
                if typeof(gethui) == "function" then
                    gui.Parent = gethui()
                    parented = gui.Parent ~= nil
                end
            end)
            if not parented then
                pcall(function()
                    gui.Parent = game:GetService("CoreGui")
                    parented = gui.Parent ~= nil
                end)
            end
            if not parented then
                local pg = LP:FindFirstChildOfClass("PlayerGui")
                if pg then gui.Parent = pg end
            end

            local DropBtn = Instance.new("TextButton")
            DropBtn.Name = "LacherBtn"
            DropBtn.Size = UDim2.new(0, 80, 0, 80)
            DropBtn.Position = UDim2.new(0.5, -40, 0.75, 0)
            DropBtn.BackgroundColor3 = colBg()
            DropBtn.BackgroundTransparency = 0.05
            DropBtn.Text = ""
            DropBtn.AutoButtonColor = false
            DropBtn.Active = true
            DropBtn.Parent = gui
            M.btn = DropBtn

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = DropBtn

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = colPrimary()
            Stroke.Thickness = 2.5
            Stroke.Parent = DropBtn
            refs.stroke = Stroke

            local MainLabel = Instance.new("TextLabel")
            MainLabel.Size = UDim2.new(1, -8, 0, 28)
            MainLabel.Position = UDim2.new(0, 4, 0, 18)
            MainLabel.BackgroundTransparency = 1
            MainLabel.Text = "LACHER"
            MainLabel.TextColor3 = colText()
            MainLabel.Font = Enum.Font.GothamBold
            MainLabel.TextSize = 12
            MainLabel.Parent = DropBtn
            refs.mainLbl = MainLabel

            KeyLabel = Instance.new("TextLabel")
            KeyLabel.Size = UDim2.new(1, -8, 0, 16)
            KeyLabel.Position = UDim2.new(0, 4, 0, 46)
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.Text = bindToText(currentBind)
            KeyLabel.TextColor3 = colDim()
            KeyLabel.Font = Enum.Font.Gotham
            KeyLabel.TextSize = 10
            KeyLabel.TextTransparency = 0.15
            KeyLabel.Parent = DropBtn

            task.spawn(function()
                while Stroke and Stroke.Parent do
                    local c1 = colPrimary()
                    local h, s, v = Color3.toHSV(c1)
                    local c2 = Color3.fromHSV(h, math.clamp(s * 0.8, 0, 1), math.max(v * 0.55, 0.15))
                    pcall(function()
                        TweenService:Create(Stroke, TweenInfo.new(1.4), { Color = c1 }):Play()
                    end)
                    task.wait(1.4)
                    if not Stroke or not Stroke.Parent then break end
                    pcall(function()
                        TweenService:Create(Stroke, TweenInfo.new(1.4), { Color = c2 }):Play()
                    end)
                    task.wait(1.4)
                end
            end)

            DropBtn.MouseEnter:Connect(function()
                if isSettingKeybind then return end
                TweenService:Create(DropBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = colPrimary(),
                    Size = UDim2.new(0, 86, 0, 86),
                }):Play()
            end)
            DropBtn.MouseLeave:Connect(function()
                if isSettingKeybind then return end
                TweenService:Create(DropBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = colBg(),
                    Size = UDim2.new(0, 80, 0, 80),
                }):Play()
            end)

            local dragging, dragStart, startPos, pressPos = false, nil, nil, nil
            DropBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    if _G._FH_GuiLocked then return end
                    dragging = true
                    dragStart = input.Position
                    startPos = DropBtn.Position
                    pressPos = input.Position
                    local conn
                    conn = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            if conn then conn:Disconnect() end
                        end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - dragStart
                    DropBtn.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end)
            DropBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    if pressPos and (input.Position - pressPos).Magnitude < 10 then
                        if not isSettingKeybind then
                            runDropBrainrot()
                        end
                    else
                        savePos()
                    end
                    pressPos = nil
                    dragging = false
                end
            end)
            DropBtn.MouseButton2Click:Connect(function()
                if isSettingKeybind then return end
                isSettingKeybind = true
                if KeyLabel then KeyLabel.Text = "..." end
                DropBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
            end)

            loadPos()
            wireInput()
        end

        function M.repaint()
            pcall(function()
                if M.btn then M.btn.BackgroundColor3 = colBg() end
                if refs.stroke then refs.stroke.Color = colPrimary() end
                if refs.mainLbl then refs.mainLbl.TextColor3 = colText() end
                if KeyLabel then KeyLabel.TextColor3 = colDim() end
            end)
        end

        function M.set(on, skipSave)
            on = on and true or false
            M.enabled = on
            if on then
                if not M.gui or not M.gui.Parent then build() end
                if M.gui then M.gui.Enabled = true end
                M.repaint()
            else
                if M.gui then M.gui.Enabled = false end
                isSettingKeybind = false
            end
            if not skipSave then
                pcall(function()
                    if setToggleSaved then setToggleSaved("Drop Brainrot", on) end
                end)
                pcall(function()
                    if Config then
                        Config.set("drop_brainrot_visible", on)
                        if Config.flush then Config.flush() end
                    end
                end)
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.run(force)
            pcall(runDropBrainrot, force)
        end

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                if M.gui then M.gui:Destroy() end
                if inputConn then inputConn:Disconnect() end
            end)
        end)

        return M
    end)()

    _G.CyutsudHubAllGear = (function()
        local M = { enabled = false, _saved = {} }
        local GEAR_TOGGLES = {
            "Leave on Steal",
            "Auto Reset On Balloon",
            "Instant Steal Panel V2",
            "Admin Spammer",
            "Quick Admin Panel",
            "Command Cooldowns",
            "Defense Panel",
            "Allow Friends",
            "Intruder Alarm",
            "ESP Allow Disallow",
        }

        -- Categories that become empty when gear toggles are hidden
        local EMPTY_SECTIONS = {
            "Instant Steal",
            "Admin Panel",
        }

        -- Visible ONLY when All Gear is ON
        local DUEL_TOGGLES = {
            "TP Brainrot",
            "Drop Brainrot",
        }
        local DUEL_SECTIONS = {
            "Duel",
        }

        local GEAR_GUI_NAMES = {
            "PanelGui_Instant Steal V2",
            "PanelGui_Instant Steal",
            "PanelGui_Cyutsud Admin Spammer",
            "PanelGui_Flux Admin Spammer",
            "AdminSpammerStandalone",
            "PanelGui_Command Cooldowns",
            "PanelGui_Admin Panel",
            "PanelGui_CyutsudQuickPanel",
            "PanelGui_FluxQuickPanel",
            "PanelGui_Cyutsud Defense",
            "PanelGui_Defense",
            "PanelGui_Flux Defense",
            "AllowFriendsGui",
        }

        local function getGuiParents()
            local parents = {}
            pcall(function()
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then table.insert(parents, h) end
                end
            end)
            pcall(function() table.insert(parents, game:GetService("CoreGui")) end)
            pcall(function()
                local lp = game:GetService("Players").LocalPlayer
                local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
                if pg then table.insert(parents, pg) end
            end)
            return parents
        end

        local function setToggleSafe(name, on, persist)
            on = on and true or false
            pcall(function()
                local reg = _G._CyutsudToggleReg
                local ctrl = reg and reg[name]
                if ctrl and ctrl.set then
                    pcall(function() ctrl.set(on, true) end)
                elseif type(setToggleUI) == "function" then
                    setToggleUI(name, on, true)
                end
            end)
            pcall(function()
                local map = {
                    ["Leave on Steal"] = function(v)
                        if _G.LeaveOnSteal and _G.LeaveOnSteal.set then _G.LeaveOnSteal.set(v) end
                    end,
                    ["Auto Reset On Balloon"] = function(v)
                        if _G.AutoResetOnBalloon and _G.AutoResetOnBalloon.set then
                            _G.AutoResetOnBalloon.set(v, true)
                        end
                    end,
                    ["Instant Steal Panel V2"] = function(v)
                        if _G.InstantStealV2 and _G.InstantStealV2.set then _G.InstantStealV2.set(v) end
                    end,
                    ["Admin Spammer"] = function(v)
                        if _G.AdminSpammer and _G.AdminSpammer.set then
                            pcall(function() _G.AdminSpammer.set(v, true) end)
                            pcall(function() _G.AdminSpammer.set(v) end)
                        end
                    end,
                    ["Quick Admin Panel"] = function(v)
                        if _G.QuickAdminPanel and _G.QuickAdminPanel.set then
                            pcall(function() _G.QuickAdminPanel.set(v, true) end)
                            pcall(function() _G.QuickAdminPanel.set(v) end)
                        end
                    end,
                    ["Command Cooldowns"] = function(v)
                        if _G.CommandCooldowns and _G.CommandCooldowns.set then
                            pcall(function() _G.CommandCooldowns.set(v, true) end)
                            pcall(function() _G.CommandCooldowns.set(v) end)
                        end
                    end,
                    ["Defense Panel"] = function(v)
                        if _G.DefensePanel and _G.DefensePanel.setVisible then
                            _G.DefensePanel.setVisible(v)
                        elseif _G.DefensePanel and _G.DefensePanel.set then
                            _G.DefensePanel.set(v)
                        end
                    end,
                    ["Allow Friends"] = function(v)
                        if _G.AllowFriends and _G.AllowFriends.set then _G.AllowFriends.set(v) end
                    end,
                    ["Intruder Alarm"] = function(v)
                        if _G.IntruderAlarm and _G.IntruderAlarm.set then _G.IntruderAlarm.set(v) end
                    end,
                    ["ESP Allow Disallow"] = function(v)
                        if _G.AllowDisallowESP and _G.AllowDisallowESP.set then
                            _G.AllowDisallowESP.set(v)
                        elseif _G.ESPAllowDisallow and _G.ESPAllowDisallow.set then
                            _G.ESPAllowDisallow.set(v)
                        end
                    end,
                }
                local fn = map[name]
                if fn then fn(on) end
            end)
            if persist then
                pcall(function()
                    if setToggleSaved then setToggleSaved(name, on) end
                end)
            end
        end

        local function getToggleState(name)
            local on = false
            pcall(function()
                if getToggleSaved then
                    on = getToggleSaved(name, false) and true or false
                end
            end)
            pcall(function()
                local reg = _G._CyutsudToggleReg
                if reg and reg[name] and reg[name].get then
                    on = reg[name].get() and true or false
                end
            end)
            return on
        end

        local _cardLayoutCache = {}
        local TOGGLE_CARD_H = 36

        local function setToggleCardVisible(name, visible)
            pcall(function()
                local reg = _G._CyutsudToggleReg
                local ctrl = reg and reg[name]
                if not ctrl then return end
                local card = ctrl.card
                if not card or not card.Parent then return end
                -- always keep a valid full size in cache (never height 0)
                local function ensureCache()
                    local curH = (card.Size and card.Size.Y and card.Size.Y.Offset) or 0
                    if not _cardLayoutCache[name] or not _cardLayoutCache[name].size
                        or ((_cardLayoutCache[name].size.Y.Offset or 0) < 8) then
                        local sz = card.Size
                        if curH < 8 then
                            sz = UDim2.new(1, -10, 0, TOGGLE_CARD_H)
                        end
                        _cardLayoutCache[name] = {
                            size = sz,
                            layoutOrder = card.LayoutOrder,
                        }
                    end
                end
                ensureCache()
                if visible then
                    local cached = _cardLayoutCache[name]
                    local sz = (cached and cached.size) or UDim2.new(1, -10, 0, TOGGLE_CARD_H)
                    if (sz.Y.Offset or 0) < 8 then
                        sz = UDim2.new(1, -10, 0, TOGGLE_CARD_H)
                    end
                    card.Size = sz
                    card.Visible = true
                    if cached and cached.layoutOrder ~= nil then
                        pcall(function() card.LayoutOrder = cached.layoutOrder end)
                    end
                else
                    ensureCache()
                    -- if current size is valid, refresh cache before collapse
                    local curH = (card.Size and card.Size.Y and card.Size.Y.Offset) or 0
                    if curH >= 8 then
                        _cardLayoutCache[name] = {
                            size = card.Size,
                            layoutOrder = card.LayoutOrder,
                        }
                    end
                    card.Visible = false
                    card.Size = UDim2.new(1, -10, 0, 0)
                end
            end)
        end

        local function applyToggleCardsVisibility(hide)
            for _, name in ipairs(GEAR_TOGGLES) do
                setToggleCardVisible(name, not hide)
            end
        end

        local _sectionSizeCache = {}

        local function setSectionVisible(title, visible)
            pcall(function()
                local reg = _G._CyutsudSectionReg or {}
                local f = reg[title] or reg[string.upper(title)]
                if not f or not f.Parent then
                    -- fallback: search by attribute
                    for _, scrollName in ipairs({"Main", "Visual", "Player", "Utils", "Config"}) do
                        -- scan all section frames
                    end
                    return
                end
                if visible then
                    f.Visible = true
                    local c = _sectionSizeCache[title]
                    if c and c.size then
                        pcall(function() f.Size = c.size end)
                    else
                        pcall(function()
                            f.Size = UDim2.new(1, -10, 0, 26)
                        end)
                    end
                else
                    if not _sectionSizeCache[title] then
                        _sectionSizeCache[title] = { size = f.Size }
                    end
                    f.Visible = false
                    pcall(function()
                        f.Size = UDim2.new(1, -10, 0, 0)
                    end)
                end
            end)
        end

        local function applyEmptySections(hide)
            for _, title in ipairs(EMPTY_SECTIONS) do
                setSectionVisible(title, not hide)
            end
            -- Also scan any section frame by attribute as backup
            pcall(function()
                local gui = _G._FH_CYUTSUD_GUI
                if not gui then return end
                for _, d in ipairs(gui:GetDescendants()) do
                    if d:IsA("Frame") and d:GetAttribute("NoxSectionTitle") then
                        local t = d:GetAttribute("NoxSectionTitle")
                        for _, empty in ipairs(EMPTY_SECTIONS) do
                            if t == empty or string.upper(t) == string.upper(empty) then
                                if hide then
                                    d.Visible = false
                                    d.Size = UDim2.new(1, -10, 0, 0)
                                else
                                    d.Visible = true
                                    d.Size = UDim2.new(1, -10, 0, 26)
                                end
                            end
                        end
                    end
                end
            end)
        end

        local function forceCloseGearGuis()
            local parents = getGuiParents()
            for _, parent in ipairs(parents) do
                for _, name in ipairs(GEAR_GUI_NAMES) do
                    pcall(function()
                        local g = parent:FindFirstChild(name)
                        if g then
                            if g:IsA("ScreenGui") then
                                g.Enabled = false
                            elseif g:IsA("GuiObject") then
                                g.Visible = false
                            end
                        end
                        for _, ch in ipairs(parent:GetChildren()) do
                            if ch.Name == name then
                                if ch:IsA("ScreenGui") then
                                    ch.Enabled = false
                                elseif ch:IsA("GuiObject") then
                                    ch.Visible = false
                                end
                            end
                        end
                    end)
                end
            end
            pcall(function()
                if _G.InstantStealV2 and _G.InstantStealV2.set then _G.InstantStealV2.set(false) end
            end)
            pcall(function()
                if _G.AdminSpammer and _G.AdminSpammer.set then _G.AdminSpammer.set(false) end
            end)
            pcall(function()
                if _G.QuickAdminPanel and _G.QuickAdminPanel.set then _G.QuickAdminPanel.set(false) end
            end)
            pcall(function()
                if _G.CommandCooldowns and _G.CommandCooldowns.set then _G.CommandCooldowns.set(false) end
            end)
            pcall(function()
                if _G.DefensePanel then
                    if _G.DefensePanel.setVisible then _G.DefensePanel.setVisible(false)
                    elseif _G.DefensePanel.set then _G.DefensePanel.set(false) end
                end
            end)
            pcall(function()
                if _G.AllowFriends and _G.AllowFriends.set then _G.AllowFriends.set(false) end
            end)
            pcall(function()
                if _G.IntruderAlarm and _G.IntruderAlarm.set then _G.IntruderAlarm.set(false) end
            end)
            pcall(function()
                if _G.AllowDisallowESP and _G.AllowDisallowESP.set then _G.AllowDisallowESP.set(false) end
            end)
            pcall(function()
                if _G._FH_AdminSpammerGui then
                    _G._FH_AdminSpammerGui.Enabled = false
                end
            end)
        end

        local function applyRagdollVisibility(hide)
            _G._CyutsudAllGearHideRagdoll = hide and true or false
            local function scan(parent)
                if not parent then return end
                for _, d in ipairs(parent:GetDescendants()) do
                    if d:IsA("GuiObject") then
                        local n = d.Name or ""
                        if n == "Act_Ragdoll_Self" or n == "Act_Ragdoll_tech" then
                            d.Visible = not hide
                            if hide then
                                pcall(function()
                                    if not d:GetAttribute("_CyutsudAG_Size") then
                                        d:SetAttribute("_CyutsudAG_Size", d.Size.Y.Offset)
                                    end
                                    d.Size = UDim2.new(d.Size.X.Scale, d.Size.X.Offset, 0, 0)
                                end)
                            else
                                pcall(function()
                                    local h = d:GetAttribute("_CyutsudAG_Size")
                                    if type(h) == "number" and h > 0 then
                                        d.Size = UDim2.new(d.Size.X.Scale, d.Size.X.Offset, 0, h)
                                    else
                                        d.Size = UDim2.new(1, -4, 0, 42)
                                    end
                                end)
                            end
                        end
                    end
                end
            end
            for _, p in ipairs(getGuiParents()) do
                pcall(scan, p)
            end
            if hide then
                _G._CyutsudAllGearBlockActions = {
                    ["Ragdoll Self"] = true,
                    ["Ragdoll tech"] = true,
                }
            else
                _G._CyutsudAllGearBlockActions = nil
            end
        end

        local function applyDuelVisibility(show)
            -- show=true only when All Gear ON
            show = show and true or false
            -- Force distinct layout orders so cards never stack on top of each other
            local orderBase = 5
            pcall(function()
                local sreg = _G._CyutsudSectionReg or {}
                local sec = sreg["Duel"] or sreg["DUEL"]
                if sec then
                    sec.LayoutOrder = orderBase
                    if show then
                        sec.Visible = true
                        sec.Size = UDim2.new(1, -10, 0, 26)
                    else
                        sec.Visible = false
                        sec.Size = UDim2.new(1, -10, 0, 0)
                    end
                end
            end)
            local duelOrders = {
                ["TP Brainrot"] = orderBase + 1,
                ["Drop Brainrot"] = orderBase + 2,
            }
            for _, name in ipairs(DUEL_TOGGLES) do
                pcall(function()
                    local reg = _G._CyutsudToggleReg
                    local ctrl = reg and reg[name]
                    if ctrl and ctrl.card then
                        ctrl.card.LayoutOrder = duelOrders[name] or orderBase + 1
                        -- pre-seed cache with valid size before show/hide
                        if not _cardLayoutCache[name] or ((_cardLayoutCache[name].size.Y.Offset or 0) < 8) then
                            _cardLayoutCache[name] = {
                                size = UDim2.new(1, -10, 0, TOGGLE_CARD_H),
                                layoutOrder = duelOrders[name] or orderBase + 1,
                            }
                        end
                    end
                end)
                setToggleCardVisible(name, show)
            end
            for _, title in ipairs(DUEL_SECTIONS) do
                setSectionVisible(title, show)
            end
            pcall(function()
                local gui = _G._FH_CYUTSUD_GUI
                if not gui then return end
                for _, d in ipairs(gui:GetDescendants()) do
                    if d:IsA("Frame") and d:GetAttribute("NoxSectionTitle") then
                        local t = d:GetAttribute("NoxSectionTitle")
                        for _, sec in ipairs(DUEL_SECTIONS) do
                            if t == sec or string.upper(tostring(t)) == string.upper(sec) then
                                d.LayoutOrder = orderBase
                                if show then
                                    d.Visible = true
                                    d.Size = UDim2.new(1, -10, 0, 26)
                                else
                                    d.Visible = false
                                    d.Size = UDim2.new(1, -10, 0, 0)
                                end
                            end
                        end
                    end
                end
            end)
            if not show then
                -- force close duel GUIs when All Gear OFF (skipSave visual only via silent)
                pcall(function()
                    if _G.TPBrainrot and _G.TPBrainrot.set then _G.TPBrainrot.set(false, true) end
                end)
                pcall(function()
                    if _G.DropBrainrot and _G.DropBrainrot.set then _G.DropBrainrot.set(false, true) end
                end)
                -- do NOT wipe saved toggle prefs — only force UI off silently without setToggleSaved
                pcall(function()
                    local reg = _G._CyutsudToggleReg
                    for _, name in ipairs(DUEL_TOGGLES) do
                        local ctrl = reg and reg[name]
                        if ctrl and ctrl.set then
                            -- silent path may still save in some toggles; prefer visual only
                            pcall(function()
                                if ctrl.get and ctrl.get() then
                                    ctrl.set(false, true)
                                end
                            end)
                        end
                    end
                end)
            end
        end

        function M.set(on)
            on = on and true or false
            if on == M.enabled then
                if on then
                    applyToggleCardsVisibility(true)
                    applyEmptySections(true)
                    forceCloseGearGuis()
                    applyRagdollVisibility(true)
                    applyDuelVisibility(true)
                else
                    applyDuelVisibility(false)
                end
                pcall(function()
                    if type(_G._CyutsudUpdateBannerTitle) == "function" then
                        _G._CyutsudUpdateBannerTitle(on)
                    end
                end)
                return
            end
            M.enabled = on
            if on then
                M._saved = {}
                for _, name in ipairs(GEAR_TOGGLES) do
                    M._saved[name] = getToggleState(name)
                    setToggleSafe(name, false, false)
                end
                -- snapshot duel states too (optional restore later)
                M._savedDuel = {}
                for _, name in ipairs(DUEL_TOGGLES) do
                    M._savedDuel[name] = getToggleState(name)
                end
                applyToggleCardsVisibility(true)
                applyEmptySections(true)
                forceCloseGearGuis()
                applyRagdollVisibility(true)
                applyDuelVisibility(true)
                -- restore duel toggles if they were on
                for _, name in ipairs(DUEL_TOGGLES) do
                    local want = M._savedDuel and M._savedDuel[name]
                    if want then
                        if name == "TP Brainrot" and _G.TPBrainrot and _G.TPBrainrot.set then
                            pcall(function() _G.TPBrainrot.set(true) end)
                        elseif name == "Drop Brainrot" and _G.DropBrainrot and _G.DropBrainrot.set then
                            pcall(function() _G.DropBrainrot.set(true) end)
                        end
                        pcall(function()
                            local reg = _G._CyutsudToggleReg
                            if reg and reg[name] and reg[name].set then
                                reg[name].set(true, true)
                            end
                        end)
                    end
                end
            else
                applyToggleCardsVisibility(false)
                applyEmptySections(false)
                applyRagdollVisibility(false)
                applyDuelVisibility(false) -- hide duel + close GUIs
                local saved = M._saved or {}
                for _, name in ipairs(GEAR_TOGGLES) do
                    local want = saved[name] and true or false
                    setToggleSafe(name, want, false)
                end
                M._saved = {}
                M._savedDuel = {}
            end
            pcall(function()
                if setToggleSaved then setToggleSaved("Cyutsud hub All Gear", on) end
            end)
            pcall(function()
                if Config then
                    Config.set("nox_hub_all_gear", on)
                    if Config.flush then Config.flush() end
                end
            end)
            -- Banner title: CYUTSUD HUB vs CYUTSUD HUB ALL GEAR
            pcall(function()
                if type(_G._CyutsudUpdateBannerTitle) == "function" then
                    _G._CyutsudUpdateBannerTitle(on)
                elseif _G._CyutsudBannerTitle and _G._CyutsudBannerTitle.Parent then
                    if on then
                        _G._CyutsudBannerTitle.Text = "CYUTSUD HUB ALL GEAR"
                        _G._CyutsudBannerTitle.TextSize = 16
                    else
                        _G._CyutsudBannerTitle.Text = "CYUTSUD HUB"
                        _G._CyutsudBannerTitle.TextSize = 20
                    end
                end
            end)
        end

        function M.isEnabled()
            return M.enabled
        end

        task.spawn(function()
            while true do
                task.wait(0.75)
                if M.enabled then
                    pcall(forceCloseGearGuis)
                    pcall(function() applyToggleCardsVisibility(true) end)
                    pcall(function() applyEmptySections(true) end)
                    pcall(function() applyRagdollVisibility(true) end)
                    pcall(function() applyDuelVisibility(true) end)
                else
                    pcall(function() applyDuelVisibility(false) end)
                end
            end
        end)

        -- hide Duel by default until All Gear is turned on
        task.defer(function()
            task.wait(0.4)
            if not M.enabled then
                pcall(function() applyDuelVisibility(false) end)
            end
        end)

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                if M.enabled then
                    applyToggleCardsVisibility(false)
                    applyEmptySections(false)
                    applyRagdollVisibility(false)
                    M.enabled = false
                end
            end)
        end)

        return M
    end)()


    local Main   = Nav("Main",   "Main")
    local Visual = Nav("Visual", "Visual")
    local Player = Nav("Player", "Player")
    local Utils  = Nav("Utils",  "Utils")
    local ConfigTab = Nav("Config", "Config")

    local noop = _G._CyutsudNoop or function(state) end
    _G._CyutsudNoop = noop

    Section(Main.scroll, "Stealing")
    Toggle(Main.scroll, "Auto Steal", nil, function(state)
        Steal.AutoStealEnabled = state and true or false
        if state then
            pcall(startAutoSteal)
            if _G._CyutsudProgressBar and _G._CyutsudProgressBar.setVisible then
                pcall(_G._CyutsudProgressBar.setVisible, true)
            elseif spFrame then
                spFrame.Visible = true
                if shadow then shadow.Visible = true end
            end
        else
            pcall(stopAutoSteal)
            if _G._CyutsudProgressBar and _G._CyutsudProgressBar.setVisible then
                pcall(_G._CyutsudProgressBar.setVisible, false)
            elseif spFrame then
                spFrame.Visible = false
                if shadow then shadow.Visible = false end
            end
        end
    end)
    Toggle(Main.scroll, "Steal Target", nil, function(state)
        if _G.StealTarget and _G.StealTarget.set then
            _G.StealTarget.set(state and true or false)
        else
            Steal.TargetEnabled = state and true or false
        end
    end)
    Toggle(Main.scroll, "Auto Giant Potion", nil, function(state)
        if _G.AutoBigPotion and _G.AutoBigPotion.set then
            _G.AutoBigPotion.set(state and true or false)
        elseif _G.AutoBigPotion and _G.AutoBigPotion.set then
            _G.AutoBigPotion.set(state and true or false)
        elseif _G._CyutsudSetGiantPotion then
            _G._CyutsudSetGiantPotion(state)
        end
    end)
    Toggle(Main.scroll, "Giant Potion Speed", nil, function(state)
        -- Toggle() already persists via setToggleSaved (same as Auto Steal)
        if _G.GiantPotionSpeed and _G.GiantPotionSpeed.set then
            _G.GiantPotionSpeed.set(state and true or false, true)
        else
            _G.giantSpeedRequested = state and true or false
        end
    end)
    task.defer(function()
        pcall(function()
            local want = false
            if getToggleSaved then
                want = getToggleSaved("Giant Potion Speed", false)
            elseif Config then
                want = Config.get("toggle:Giant Potion Speed", false) == true
                    or Config.get("giant_potion_speed", false) == true
                    or Config.get("gps_enabled", false) == true
            end
            if want then
                if _G.GiantPotionSpeed and _G.GiantPotionSpeed.set then
                    _G.GiantPotionSpeed.set(true, true)
                end
                if setToggleUI then setToggleUI("Giant Potion Speed", true, true) end
            end
        end)
    end)
    do
        local gpsDef = 34
        pcall(function()
            if Config then
                gpsDef = tonumber(Config.get("giantPotionSpeed", nil))
                    or tonumber(Config.get("slider:GPS Speed", nil))
                    or 34
            end
            if _G.GiantPotionSpeed and _G.GiantPotionSpeed.getSpeed then
                local s = _G.GiantPotionSpeed.getSpeed()
                if s then gpsDef = s end
            end
            gpsDef = math.clamp(tonumber(gpsDef) or 34, 1, 100)
        end)
        -- Slider controls Giant Potion Speed velocity (live)
        Slider(Main.scroll, "GPS Speed", 1, 100, gpsDef, function(v)
            v = math.clamp(tonumber(v) or 34, 1, 100)
            if _G.GiantPotionSpeed and _G.GiantPotionSpeed.setSpeed then
                _G.GiantPotionSpeed.setSpeed(v)
            else
                _G._CyutsudGPSSpeed = v
            end
            pcall(function()
                if Config then
                    Config.set("giantPotionSpeed", v)
                    Config.set("slider:GPS Speed", v)
                end
            end)
        end, 1, function(v)
            v = math.clamp(tonumber(v) or 34, 1, 100)
            if _G.GiantPotionSpeed and _G.GiantPotionSpeed.setSpeed then
                _G.GiantPotionSpeed.setSpeed(v)
            else
                _G._CyutsudGPSSpeed = v
            end
            pcall(function()
                if Config then
                    Config.set("giantPotionSpeed", v)
                    Config.set("slider:GPS Speed", v)
                    if Config.flush then Config.flush() end
                end
            end)
        end)
    end
    Toggle(Main.scroll, "Leave on Steal", nil, function(state)
        if _G.LeaveOnSteal and _G.LeaveOnSteal.set then
            _G.LeaveOnSteal.set(state and true or false)
        elseif _G.LeaveOnSteal and _G.LeaveOnSteal.set then
            _G.LeaveOnSteal.set(state and true or false)
        end
    end)

    Section(Main.scroll, "Instant Steal")
    Toggle(Main.scroll, "Instant Steal Panel V2", nil, function(state)
        if _G.InstantStealV2 and _G.InstantStealV2.set then
            _G.InstantStealV2.set(state and true or false)
        elseif _G.InstantStealV2 and _G.InstantStealV2.set then
            _G.InstantStealV2.set(state and true or false)
        end
    end)

    Section(Main.scroll, "Actions")
    Toggle(Main.scroll, "Actions Panel", nil, function(state)
        if _G.ActionsPanel and _G.ActionsPanel.set then
            _G.ActionsPanel.set(state and true or false)
        else
        end
    end)
    Toggle(Main.scroll, "Actions Panel Mobile", nil, function(state)
        if _G.ActionsPanelMobile and _G.ActionsPanelMobile.set then
            _G.ActionsPanelMobile.set(state and true or false)
        end
    end)

    Section(Visual.scroll, "Optimizer")
    Toggle(Visual.scroll, "FPS Boost", nil, function(state)
        if _G.FPSBooster and _G.FPSBooster.set then
            _G.FPSBooster.set(state and true or false)
        elseif _G.FPSBooster and _G.FPSBooster.set then
            _G.FPSBooster.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "Game Stretcher", nil, function(state)
        if _G.GameStretcher and _G.GameStretcher.set then
            _G.GameStretcher.set(state and true or false)
        elseif _G.GameStretcher and _G.GameStretcher.set then
            _G.GameStretcher.set(state and true or false)
        end
    end)
    do
        local stretchDef = 0.75
        local fovDef = 70
        pcall(function()
            if Config then
                stretchDef = tonumber(Config.get("gameStretcherFactor", nil) or Config.get("slider:Stretch Factor", 0.75)) or 0.75
                fovDef = tonumber(Config.get("cameraFOV", nil) or Config.get("slider:Camera FOV", 70)) or 70
            end
            if _G.GameStretcher then
                if _G.GameStretcher.getFactor then stretchDef = _G.GameStretcher.getFactor() or stretchDef end
                if _G.GameStretcher.getFOV then fovDef = _G.GameStretcher.getFOV() or fovDef end
            end
        end)
        stretchDef = math.clamp(tonumber(stretchDef) or 0.75, 0.1, 1.5)
        fovDef = math.clamp(tonumber(fovDef) or 70, 60, 120)

        Slider(Visual.scroll, "Stretch Factor", 0.1, 1.5, stretchDef, function(v)
            if _G.GameStretcher and _G.GameStretcher.setFactor then
                _G.GameStretcher.setFactor(v)
            elseif _G.GameStretcher and _G.GameStretcher.setFactor then
                _G.GameStretcher.setFactor(v)
            end
        end, 0.01, function(v)
            if _G.GameStretcher and _G.GameStretcher.setFactor then
                _G.GameStretcher.setFactor(v)
            end
            pcall(function()
                if Config then Config.set("gameStretcherFactor", v) end
            end)
        end)

        Slider(Visual.scroll, "Camera FOV", 60, 120, fovDef, function(v)
            if _G.GameStretcher and _G.GameStretcher.setFOV then
                _G.GameStretcher.setFOV(v)
            elseif _G.GameStretcher and _G.GameStretcher.setFOV then
                _G.GameStretcher.setFOV(v)
            else
                local cam = workspace.CurrentCamera
                if cam then pcall(function() cam.FieldOfView = v end) end
            end
        end, 1, function(v)
            if _G.GameStretcher and _G.GameStretcher.setFOV then
                _G.GameStretcher.setFOV(v)
            end
            pcall(function()
                if Config then Config.set("cameraFOV", v) end
            end)
        end)
    end
    Toggle(Visual.scroll, "Anti Bee", nil, function(state)
        if _G.AntiBee and _G.AntiBee.set then
            _G.AntiBee.set(state and true or false)
        end
    end)

    Section(Visual.scroll, "ESP")
    Toggle(Visual.scroll, "Player ESP", nil, function(state)
        if _G.PlayerESP and _G.PlayerESP.set then
            _G.PlayerESP.set(state and true or false)
        elseif _G.PlayerESP and _G.PlayerESP.set then
            _G.PlayerESP.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "Brainrot ESP", nil, function(state)
        if _G.BrainrotESP and _G.BrainrotESP.set then
            _G.BrainrotESP.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "Clone ESP", nil, function(state)
        if _G.CloneESP and _G.CloneESP.set then
            _G.CloneESP.set(state and true or false)
        elseif _G.CloneESP and _G.CloneESP.set then
            _G.CloneESP.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "Timer ESP", nil, function(state)
        if _G.TimerESP and _G.TimerESP.set then
            _G.TimerESP.set(state and true or false)
        elseif _G.TimerESP and _G.TimerESP.set then
            _G.TimerESP.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "Mine ESP", nil, function(state)
        if _G.MineESP and _G.MineESP.set then
            _G.MineESP.set(state and true or false)
        elseif _G.MineESP and _G.MineESP.set then
            _G.MineESP.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "AP Esp", nil, function(state)
        if _G.APESP and _G.APESP.set then
            _G.APESP.set(state and true or false)
        elseif _G.APESP and _G.APESP.set then
            _G.APESP.set(state and true or false)
        end
    end)
    Toggle(Visual.scroll, "ESP Allow Disallow", nil, function(state)
        if _G.AllowDisallowESP and _G.AllowDisallowESP.set then
            _G.AllowDisallowESP.set(state and true or false)
        end
    end)

    Section(Player.scroll, "Movement")
    Toggle(Player.scroll, "Anti AP", nil, function(state)
        if _G.AntiAdmin and _G.AntiAdmin.set then
            _G.AntiAdmin.set(state and true or false)
        elseif _G.AntiAdmin and _G.AntiAdmin.set then
            _G.AntiAdmin.set(state and true or false)
        end
    end)
    Toggle(Player.scroll, "Booster GUI", nil, function(state)
        if _G.BoosterGUI and _G.BoosterGUI.setVisible then
            _G.BoosterGUI.setVisible(state and true or false)
        end
    end)
    Toggle(Player.scroll, "Infinite Jump", nil, function(state)
        if _G.InfiniteJump and _G.InfiniteJump.set then
            _G.InfiniteJump.set(state and true or false)
        elseif _G.InfiniteJump and _G.InfiniteJump.set then
            _G.InfiniteJump.set(state and true or false)
        end
    end)
    Toggle(Player.scroll, "Carpet Speed", nil, function(state)
        if _G.CarpetSpeed and _G.CarpetSpeed.set then
            _G.CarpetSpeed.set(state and true or false)
        end
    end)
    Toggle(Player.scroll, "Auto Carpet Speed", nil, function(state)
        if _G.AutoCarpetSpeed and _G.AutoCarpetSpeed.set then
            _G.AutoCarpetSpeed.set(state and true or false)
        end
    end)
    do
        local csDef = 175
        pcall(function()
            if _G.CarpetSpeed and _G.CarpetSpeed.getSpeed then
                csDef = _G.CarpetSpeed.getSpeed() or 175
            elseif Config then
                csDef = tonumber(Config.get("carpetSpeed", 175)) or 175
            end
        end)
        Slider(Player.scroll, "Carpet SPD", 50, 250, csDef, function(v)
            if _G.CarpetSpeed and _G.CarpetSpeed.setSpeed then
                _G.CarpetSpeed.setSpeed(v)
            end
        end, 1, function(v)
            if _G.CarpetSpeed and _G.CarpetSpeed.setSpeed then
                _G.CarpetSpeed.setSpeed(v)
            end
            pcall(function()
                if Config then Config.set("carpetSpeed", v) end
            end)
        end)
    end

    Section(Player.scroll, "Exploit")
    Toggle(Player.scroll, "Auto Reset On Balloon", nil, function(state)
        if _G.AutoResetOnBalloon and _G.AutoResetOnBalloon.set then
            -- skipSave=true: Toggle() a deja persiste via setToggleSaved
            _G.AutoResetOnBalloon.set(state and true or false, true)
        end
    end)
    -- Restauration fiable apres chargement module
    task.defer(function()
        pcall(function()
            local want = false
            if getToggleSaved then
                want = getToggleSaved("Auto Reset On Balloon", false)
            elseif Config then
                want = Config.get("toggle:Auto Reset On Balloon", false) == true
            end
            if want and _G.AutoResetOnBalloon and _G.AutoResetOnBalloon.set then
                _G.AutoResetOnBalloon.set(true, true)
            end
        end)
    end)
    Toggle(Player.scroll, "Anti Turret", nil, function(state)
        if _G.AutoTurret and _G.AutoTurret.set then
            _G.AutoTurret.set(state and true or false)
        end
    end)
    Toggle(Player.scroll, "Aimbot", nil, function(state)
        if Aimbot and Aimbot.set then
            Aimbot.set(state and true or false)
        elseif Aimbot and Aimbot.set then
            Aimbot.set(state and true or false)
        end
    end)

    local FONTS_LIST = {
        { name = "Gotham Bold",   enum = Enum.Font.GothamBold },
        { name = "Gotham",        enum = Enum.Font.Gotham },
        { name = "Gotham Black",  enum = Enum.Font.GothamBlack },
        { name = "Source Sans",   enum = Enum.Font.SourceSansBold },
        { name = "Fredoka One",   enum = Enum.Font.FredokaOne },
        { name = "Cartoon",       enum = Enum.Font.Cartoon },
        { name = "Arcade",        enum = Enum.Font.Arcade },
        { name = "Code",          enum = Enum.Font.Code },
        { name = "Sci-Fi",        enum = Enum.Font.SciFi },
        { name = "Fantasy",       enum = Enum.Font.Fantasy },
        { name = "Highway",       enum = Enum.Font.Highway },
    }

    local function fontByName(n)
        for _, f in ipairs(FONTS_LIST) do
            if f.name == n then return f.enum end
        end
        return Enum.Font.GothamBold
    end

    local function applyFontEverywhere(fontEnum)
        if not fontEnum then return end
        local targets = {}
        pcall(function()
            if GUI then table.insert(targets, GUI) end
        end)
        pcall(function()
            if typeof(gethui) == "function" then
                local h = gethui()
                if h then table.insert(targets, h) end
            end
        end)
        pcall(function()
            local lp = Players.LocalPlayer
            local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
            if pg then table.insert(targets, pg) end
        end)
        pcall(function()
            table.insert(targets, game:GetService("CoreGui"))
        end)
        local seen = {}
        for _, root in ipairs(targets) do
            if root and not seen[root] then
                seen[root] = true
                pcall(function()
                    for _, d in ipairs(root:GetDescendants()) do
                        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                            local n = ""
                            pcall(function()
                                local sg = d:FindFirstAncestorOfClass("ScreenGui")
                                n = sg and sg.Name or ""
                            end)
                            if n == "CyutsudHub" or n == "CyutsudHub" or n:find("PanelGui_") or n == "StealProgressScreenGui"
                                or n == "CyutsudHubReopen" or n == "NoxLabelGui" or n == "CyutsudHubBanner"
                                or n == "CyutsudHubReopen" or n == "NoxLabelGui" then
                                pcall(function() d.Font = fontEnum end)
                            end
                        end
                    end
                end)
            end
        end
    end
    _G._CyutsudApplyHubFont = applyFontEverywhere

    local _savedFontName = "Gotham Bold"
    pcall(function()
        if Config then
            _savedFontName = Config.get("hubFont", "Gotham Bold") or "Gotham Bold"
        end
    end)
    _G.CyutsudHubSelectedFont = _savedFontName

    local function selectHubFont(name)
        if not name then return end
        _G.CyutsudHubSelectedFont = name
        pcall(function()
            if Config then Config.set("hubFont", name) end
        end)
        applyFontEverywhere(fontByName(name))
    end
    _G._CyutsudSelectHubFont = selectHubFont

    task.defer(function()
        task.wait(0.4)
        pcall(function() applyFontEverywhere(fontByName(_G.CyutsudHubSelectedFont or "Gotham Bold")) end)
    end)
    task.delay(1.6, function()
        pcall(function() applyFontEverywhere(fontByName(_G.CyutsudHubSelectedFont or "Gotham Bold")) end)
    end)

    Section(Utils.scroll, "Duel")
    do
        -- Force layout order so they never overlap
        local sec = _G._CyutsudSectionReg and (_G._CyutsudSectionReg["Duel"] or _G._CyutsudSectionReg["DUEL"])
        if sec then sec.LayoutOrder = 5 end
    end
    local _tpCtrl = Toggle(Utils.scroll, "TP Brainrot", nil, function(state)
        -- only usable when All Gear is ON
        if not (_G.CyutsudHubAllGear and _G.CyutsudHubAllGear.isEnabled and _G.CyutsudHubAllGear.isEnabled()) then
            if state then
                task.defer(function()
                    if setToggleUI then setToggleUI("TP Brainrot", false, true) end
                end)
            end
            return
        end
        if _G.TPBrainrot and _G.TPBrainrot.set then
            _G.TPBrainrot.set(state and true or false)
        end
        -- force persist (Toggle already saves, double-ensure)
        pcall(function()
            if setToggleSaved then setToggleSaved("TP Brainrot", state and true or false) end
        end)
    end)
    local _dropCtrl = Toggle(Utils.scroll, "Drop Brainrot", nil, function(state)
        if not (_G.CyutsudHubAllGear and _G.CyutsudHubAllGear.isEnabled and _G.CyutsudHubAllGear.isEnabled()) then
            if state then
                task.defer(function()
                    if setToggleUI then setToggleUI("Drop Brainrot", false, true) end
                end)
            end
            return
        end
        if _G.DropBrainrot and _G.DropBrainrot.set then
            _G.DropBrainrot.set(state and true or false)
        end
        pcall(function()
            if setToggleSaved then setToggleSaved("Drop Brainrot", state and true or false) end
        end)
    end)
    pcall(function()
        if _tpCtrl and _tpCtrl.card then
            _tpCtrl.card.LayoutOrder = 6
            _tpCtrl.card.Size = UDim2.new(1, -10, 0, 36)
        end
        if _dropCtrl and _dropCtrl.card then
            _dropCtrl.card.LayoutOrder = 7
            _dropCtrl.card.Size = UDim2.new(1, -10, 0, 36)
        end
    end)
    -- Masquer Duel tant que All Gear est OFF (apres cache taille valide)
    task.defer(function()
        task.wait(0.2)
        pcall(function()
            local allOn = _G.CyutsudHubAllGear and _G.CyutsudHubAllGear.isEnabled and _G.CyutsudHubAllGear.isEnabled()
            if allOn then return end
            local reg = _G._CyutsudToggleReg
            for i, name in ipairs({"TP Brainrot", "Drop Brainrot"}) do
                local ctrl = reg and reg[name]
                if ctrl and ctrl.card then
                    -- keep full size cached via Visible only after ensuring height
                    if (ctrl.card.Size.Y.Offset or 0) < 8 then
                        ctrl.card.Size = UDim2.new(1, -10, 0, 36)
                    end
                    ctrl.card.LayoutOrder = 5 + i
                    ctrl.card.Visible = false
                    ctrl.card.Size = UDim2.new(1, -10, 0, 0)
                end
            end
            local sreg = _G._CyutsudSectionReg
            local sec = sreg and (sreg["Duel"] or sreg["DUEL"])
            if sec then
                sec.LayoutOrder = 5
                sec.Visible = false
                sec.Size = UDim2.new(1, -10, 0, 0)
            end
        end)
    end)

    Section(Utils.scroll, "Admin Panel")
    Toggle(Utils.scroll, "Admin Spammer", nil, function(state)
        if _G.AdminSpammer and _G.AdminSpammer.set then
            _G.AdminSpammer.set(state and true or false)
        end
    end)
    Toggle(Utils.scroll, "Quick Admin Panel", nil, function(state)
        if _G.QuickAdminPanel and _G.QuickAdminPanel.set then
            _G.QuickAdminPanel.set(state and true or false)
        end
    end)
    Toggle(Utils.scroll, "Command Cooldowns", nil, function(state)
        if _G.CommandCooldowns and _G.CommandCooldowns.set then
            _G.CommandCooldowns.set(state and true or false)
        end
    end)

    -- Gummy Bypass: clear BlockTools/Web + delete GummyBear
    _G.GummyBypass = (function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local Player = Players.LocalPlayer

        local M = { enabled = false }
        local antiGummyRespawnGraceUntil = 0
        local childAddedConn = nil
        local charAddedConn = nil
        local loopRunning = false

        local function clearGummyToolBlockState(char)
            if not char then return end
            pcall(function()
                for _, inst in ipairs({ Player, char }) do
                    if inst then
                        if inst:GetAttribute("BlockTools") ~= nil then
                            inst:SetAttribute("BlockTools", false)
                        end
                        if inst:GetAttribute("Web") ~= nil then
                            inst:SetAttribute("Web", false)
                        end
                    end
                end
                if char:GetAttribute("BackpackReady") == false then
                    char:SetAttribute("BackpackReady", true)
                end
            end)
        end

        local function deleteGummyBears()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == "GummyBear" then
                    pcall(function() obj:Destroy() end)
                end
            end
        end

        local function stopLoops()
            loopRunning = false
            if childAddedConn then
                pcall(function() childAddedConn:Disconnect() end)
                childAddedConn = nil
            end
            if charAddedConn then
                pcall(function() charAddedConn:Disconnect() end)
                charAddedConn = nil
            end
        end

        local function startLoops()
            stopLoops()
            loopRunning = true

            charAddedConn = Player.CharacterAdded:Connect(function()
                task.wait(0.5)
                antiGummyRespawnGraceUntil = tick() + 1.5
            end)

            childAddedConn = Workspace.ChildAdded:Connect(function(child)
                if M.enabled and child.Name == "GummyBear" then
                    pcall(function() child:Destroy() end)
                end
            end)

            task.spawn(function()
                while loopRunning and M.enabled do
                    task.wait(0.1)
                    if not M.enabled then break end
                    local char = Player.Character
                    if char and tick() >= antiGummyRespawnGraceUntil then
                        clearGummyToolBlockState(char)
                    end
                end
            end)
        end

        function M.set(on)
            on = on and true or false
            M.enabled = on
            if on then
                deleteGummyBears()
                startLoops()
            else
                stopLoops()
            end
            -- Save is handled by Toggle() via setToggleSaved (same as Auto Steal)
        end

        function M.isEnabled()
            return M.enabled
        end

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                if M.set then M.set(false) end
            end)
        end)

        return M
    end)()

    -- PaintBall Bypass: block PaintballHitted UseItem OnClientEvent (Anti Paintball)
    _G.PaintBallBypass = (function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local M = {
            enabled = false,
            remote = nil,
            disabledConns = {},
        }

        local function resolveUseItemRemote()
            if M.remote and M.remote.Parent then
                return M.remote
            end
            M.remote = nil

            -- Prefer hub resolver if available
            if type(_G._FH_ResolveUseItemRemote) == "function" then
                local ok, r = pcall(_G._FH_ResolveUseItemRemote)
                if ok and typeof(r) == "Instance" and r:IsA("RemoteEvent") then
                    M.remote = r
                    return r
                end
            end

            -- Aimbot cache if present
            pcall(function()
                if Aimbot and type(Aimbot.findUseItemOnce) == "function" then
                    local r = Aimbot.findUseItemOnce()
                    if typeof(r) == "Instance" and r:IsA("RemoteEvent") then
                        M.remote = r
                    end
                end
            end)
            if M.remote then return M.remote end

            local ok, netFolder = pcall(function()
                return ReplicatedStorage:WaitForChild("Packages", 8):WaitForChild("Net", 8)
            end)
            if not ok or not netFolder then return nil end

            local getconns = (type(getconnections) == "function") and getconnections or nil
            local getconsts = (debug and type(debug.getconstants) == "function") and debug.getconstants
                or ((type(getconstants) == "function") and getconstants or nil)

            if getconns and getconsts then
                for _, r in ipairs(netFolder:GetChildren()) do
                    if r:IsA("RemoteEvent") then
                        local okC, conns = pcall(getconns, r.OnClientEvent)
                        if okC and type(conns) == "table" then
                            for _, c in ipairs(conns) do
                                if type(c.Function) == "function" then
                                    local okK, consts = pcall(getconsts, c.Function)
                                    if okK and type(consts) == "table" then
                                        for _, k in ipairs(consts) do
                                            if k == "PaintballHitted" then
                                                M.remote = r
                                                return r
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- Fallback by name
            for _, r in ipairs(netFolder:GetChildren()) do
                if r:IsA("RemoteEvent") and tostring(r.Name):find("UseItem", 1, true) then
                    M.remote = r
                    return r
                end
            end
            return nil
        end

        local function disableRemoteConns(remote)
            M.disabledConns = {}
            if not remote or type(getconnections) ~= "function" then return 0 end
            local n = 0
            local ok, conns = pcall(getconnections, remote.OnClientEvent)
            if ok and type(conns) == "table" then
                for _, conn in ipairs(conns) do
                    local disabled = false
                    pcall(function()
                        if conn.Function and conn.Disable then
                            conn:Disable()
                            disabled = true
                        end
                    end)
                    if not disabled then
                        pcall(function()
                            if conn.Disable then conn:Disable() disabled = true end
                        end)
                    end
                    if disabled then
                        table.insert(M.disabledConns, conn)
                        n = n + 1
                    end
                end
            end
            return n
        end

        local function enableRemoteConns()
            for _, conn in ipairs(M.disabledConns) do
                pcall(function()
                    if conn.Enable then conn:Enable() end
                end)
            end
            M.disabledConns = {}
        end

        local function enableAntiPaintball()
            task.spawn(function()
                local remote = resolveUseItemRemote()
                if remote then
                    local n = disableRemoteConns(remote)
                    pcall(function()
                        if showToast then
                            showToast("PaintBall Bypass ON (" .. tostring(n) .. ")", true)
                        end
                    end)
                else
                    pcall(function()
                        if showToast then
                            showToast("PaintBall remote not found", false)
                        end
                    end)
                end
            end)
        end

        local function disableAntiPaintball()
            enableRemoteConns()
        end

        function M.set(on, skipSave)
            on = on and true or false
            if on == M.enabled then
                if on then enableAntiPaintball() end
                return
            end
            M.enabled = on
            if on then
                enableAntiPaintball()
            else
                disableAntiPaintball()
            end
            if not skipSave then
                pcall(function()
                    if setToggleSaved then
                        setToggleSaved("PaintBall Bypass", on)
                    elseif Config then
                        Config.set("toggle:PaintBall Bypass", on)
                        local t = Config.get("toggles", {})
                        if type(t) ~= "table" then t = {} end
                        t["PaintBall Bypass"] = on
                        Config.set("toggles", t)
                        if Config.flush then Config.flush() end
                        if Config.save then Config.save() end
                    end
                end)
            end
        end

        function M.isEnabled()
            return M.enabled
        end

        table.insert(_G._FH_TEARDOWN, function()
            pcall(function()
                -- skipSave: do not overwrite saved toggle (same as Auto Steal)
                if M.set then M.set(false, true) end
            end)
        end)

        return M
    end)()

    Section(Utils.scroll, "Protection")
    Toggle(Utils.scroll, "Defense Panel", nil, function(state)
        if _G.DefensePanel and _G.DefensePanel.setVisible then
            _G.DefensePanel.setVisible(state and true or false)
        elseif _G.DefensePanel and _G.DefensePanel.setVisible then
            _G.DefensePanel.setVisible(state and true or false)
        end
    end)
    Toggle(Utils.scroll, "Intruder Alarm", nil, function(state)
        if _G.IntruderAlarm and _G.IntruderAlarm.set then
            _G.IntruderAlarm.set(state and true or false)
        elseif _G.IntruderAlarm and _G.IntruderAlarm.set then
            _G.IntruderAlarm.set(state and true or false)
        end
    end)
    -- Same save system as Auto Steal: Toggle() → setToggleSaved / getToggleSaved
    Toggle(Utils.scroll, "GummyBypass", "Bypass Gummy Bear (BlockTools / Web)", function(state)
        if _G.GummyBypass and _G.GummyBypass.set then
            _G.GummyBypass.set(state and true or false)
        end
    end)
    Toggle(Utils.scroll, "PaintBall Bypass", "Bypass Paintball hits / paint effects", function(state)
        if _G.PaintBallBypass and _G.PaintBallBypass.set then
            -- skipSave=true: Toggle() already called setToggleSaved
            _G.PaintBallBypass.set(state and true or false, true)
        end
    end)
    -- Ensure restore after module ready (same reliability as Auto Steal)
    task.defer(function()
        pcall(function()
            local want = false
            if getToggleSaved then
                want = getToggleSaved("PaintBall Bypass", false)
            elseif Config then
                want = Config.get("toggle:PaintBall Bypass", false) == true
                    or Config.get("paintball_bypass", false) == true
            end
            if want then
                if _G.PaintBallBypass and _G.PaintBallBypass.set then
                    _G.PaintBallBypass.set(true, true)
                end
                if setToggleUI then setToggleUI("PaintBall Bypass", true, true) end
            end
        end)
    end)

    Section(Utils.scroll, "Desync")
    Toggle(Utils.scroll, "Unwalk", nil, function(state)
        if _G.Unwalk and _G.Unwalk.set then
            _G.Unwalk.set(state and true or false)
        end
    end)

    -- Quick Grab: réduit HoldDuration des prompts sur TA base (0.1s)
    _G.QuickGrab = (function()
        local Workspace = game:GetService("Workspace")
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        local enabled = false
        local orig = {}
        local hooked = false

        local function isMyPlot(plot)
            if not plot or not plot:IsA("Model") then return false end
            local sign = plot:FindFirstChild("PlotSign")
            return sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled
        end

        local function inMyPlot(inst)
            if not inst or not inst.Parent then return false end
            local node = inst.Parent
            for _ = 1, 12 do
                if not node then return false end
                if node:IsA("Model") and node.Parent and node.Parent.Name == "Plots" then
                    return isMyPlot(node)
                end
                node = node.Parent
            end
            return false
        end

        local function installHook()
            if hooked then return end
            local ok, mt = pcall(getrawmetatable, game)
            if not ok or not mt then return end
            pcall(setreadonly, mt, false)
            local oldNewIndex = mt.__newindex
            local nc = newcclosure or function(f) return f end
            mt.__newindex = nc(function(self, key, value)
                if key == "HoldDuration"
                   and enabled
                   and typeof(self) == "Instance"
                   and self:IsA("ProximityPrompt")
                   and inMyPlot(self) then
                    value = 0.1
                end
                return oldNewIndex(self, key, value)
            end)
            pcall(setreadonly, mt, true)
            hooked = true
        end

        local function applyAll()
            local root = Workspace:FindFirstChild("Plots") or Workspace
            local stack = { root }
            local visited = 0
            while #stack > 0 do
                if not enabled then return end
                local cur = table.remove(stack)
                for _, d in ipairs(cur:GetChildren()) do
                    if d:IsA("ProximityPrompt") and inMyPlot(d) then
                        if orig[d] == nil then orig[d] = d.HoldDuration end
                        pcall(function() d.HoldDuration = 0.1 end)
                    end
                    table.insert(stack, d)
                end
                visited = visited + 1
                if visited % 50 == 0 then task.wait() end
            end
        end

        local M = {}
        function M.set(v)
            enabled = v and true or false
            if enabled then
                installHook()
                task.spawn(applyAll)
            else
                for p, o in pairs(orig) do
                    if p and p.Parent then pcall(function() p.HoldDuration = o end) end
                end
                orig = {}
            end
        end
        function M.isEnabled()
            return enabled
        end
        return M
    end)()

    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.QuickGrab and _G.QuickGrab.set then
                _G.QuickGrab.set(false)
            end
        end)
    end)

    _G.AllowFriends = (function()
        local LP = Players.LocalPlayer
        local M = {
            enabled = false,
            gui = nil,
            btn = nil,
            isDisallowed = false,
            cooldown = false,
        }

        local function colPrimary()
            if Theme and typeof(Theme.c1) == "Color3" then return Theme.c1 end
            return Color3.fromRGB(168, 85, 247)
        end
        local function colDeep()
            if T and typeof(T.BgDeep) == "Color3" then return T.BgDeep end
            return Color3.fromRGB(8, 6, 14)
        end
        local function colText()
            if T and typeof(T.Text) == "Color3" then return T.Text end
            return Color3.fromRGB(245, 240, 255)
        end

        local function fireAllFriendPanels()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return 0 end
            local count = 0
            for _, plot in ipairs(plots:GetChildren()) do
                local friendPanel = plot:FindFirstChild("FriendPanel", true)
                if friendPanel then
                    local main = friendPanel:FindFirstChild("Main")
                    local root = main or friendPanel
                    for _, obj in ipairs(root:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            pcall(function()
                                if fireproximityprompt then
                                    fireproximityprompt(obj)
                                end
                            end)
                            count = count + 1
                        end
                    end
                end
            end
            return count
        end

        local function paintBtn()
            if not M.btn then return end
            local primary = colPrimary()
            if M.isDisallowed then
                M.btn.Text = "Disallow Friends"
                M.btn.BackgroundColor3 = Color3.fromRGB(120, 40, 50)
                pcall(function()
                    local s = M.btn:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = Color3.fromRGB(0, 0, 0) end
                end)
            else
                M.btn.Text = "Allow Friends"
                M.btn.BackgroundColor3 = primary
                pcall(function()
                    local s = M.btn:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = Color3.fromRGB(0, 0, 0) end
                end)
            end
            local lum = 0.299 * M.btn.BackgroundColor3.R + 0.587 * M.btn.BackgroundColor3.G + 0.114 * M.btn.BackgroundColor3.B
            M.btn.TextColor3 = (lum > 0.55) and Color3.fromRGB(12, 6, 22) or Color3.fromRGB(255, 255, 255)
        end

        local function build()
            if M.gui and M.gui.Parent then return end
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui")
                local old = pg and pg:FindFirstChild("AllowFriendsGui")
                if old then old:Destroy() end
            end)
            pcall(function()
                if typeof(gethui) == "function" then
                    local h = gethui()
                    local old = h and h:FindFirstChild("AllowFriendsGui")
                    if old then old:Destroy() end
                end
            end)

            local gui = Instance.new("ScreenGui")
            gui.Name = "AllowFriendsGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 250
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Enabled = false
            M.gui = gui

            local parented = false
            pcall(function()
                if typeof(gethui) == "function" then
                    gui.Parent = gethui()
                    parented = gui.Parent ~= nil
                end
            end)
            if not parented then
                pcall(function()
                    gui.Parent = game:GetService("CoreGui")
                    parented = gui.Parent ~= nil
                end)
            end
            if not parented then
                local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
                if pg then gui.Parent = pg end
            end

            local btn = Instance.new("TextButton")
            btn.Name = "AllowFriendsBtn"
            btn.Size = UDim2.new(0, 168, 0, 40)
            btn.Position = UDim2.new(1, -180, 0, 12)
            btn.BackgroundColor3 = colPrimary()
            btn.BackgroundTransparency = 0.05
            btn.BorderSizePixel = 0
            btn.Text = "Allow Friends"
            btn.Font = Enum.Font.GothamBlack
            btn.TextSize = 13
            btn.TextColor3 = Color3.fromRGB(12, 6, 22)
            btn.AutoButtonColor = false
            btn.Active = true
            btn.ZIndex = 10
            btn.Parent = gui
            M.btn = btn
            do
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(1, 0)
                c.Parent = btn
            end
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.8
            stroke.Transparency = 0.05
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = btn

            local accent = Instance.new("Frame")
            accent.Name = "Accent"
            accent.Size = UDim2.new(1, -16, 0, 2)
            accent.Position = UDim2.new(0, 8, 1, -6)
            accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            accent.BackgroundTransparency = 0.75
            accent.BorderSizePixel = 0
            accent.ZIndex = 11
            accent.Parent = btn
            do
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(1, 0)
                c.Parent = accent
            end

            paintBtn()

            pcall(function()
                if loadGuiPosition and loadGuiPosition("AllowFriendsGui", btn) then return end
                if Config then
                    local positions = Config.get("positions", {}) or {}
                    local p = positions["AllowFriendsGui"]
                    if type(p) == "table" and #p >= 4 then
                        btn.Position = UDim2.new(p[1], p[2], p[3], p[4])
                    end
                end
            end)

            local wasDragged = false
            local cooldown = false
            btn.Activated:Connect(function()
                if wasDragged then return end
                if cooldown then return end
                cooldown = true
                M.isDisallowed = not M.isDisallowed
                paintBtn()
                btn.TextTransparency = 0.45
                local n = fireAllFriendPanels()
                pcall(function()
                    if showToast then
                        showToast(M.isDisallowed and "Disallow Friends" or "Allow Friends", true)
                    end
                end)
                task.delay(1, function()
                    cooldown = false
                    if btn and btn.Parent then btn.TextTransparency = 0 end
                end)
            end)

            local dragging, dragStart, startPos = false, nil, nil
            local function toV2(p)
                if p == nil then return Vector2.zero end
                if typeof(p) == "Vector2" then return p end
                if typeof(p) == "Vector3" then return Vector2.new(p.X, p.Y) end
                return Vector2.new(tonumber(p.X) or 0, tonumber(p.Y) or 0)
            end
            local function savePos()
                pcall(function()
                    if saveGuiPosition then
                        saveGuiPosition("AllowFriendsGui", btn)
                    end
                    if Config then
                        local positions = Config.get("positions", {}) or {}
                        if type(positions) ~= "table" then positions = {} end
                        local pos = btn.Position
                        positions["AllowFriendsGui"] = {
                            pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset,
                        }
                        Config.set("positions", positions)
                        if Config.flush then Config.flush() end
                    end
                end)
            end
            btn.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    wasDragged = false
                    dragging = true
                    dragStart = toV2(inp.Position)
                    startPos = btn.Position
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseMovement
                    and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                local d = toV2(inp.Position) - dragStart
                if d.Magnitude > 6 then wasDragged = true end
                btn.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    if wasDragged then savePos() end
                    task.delay(0.05, function() wasDragged = false end)
                end
            end)
        end

        function M.set(on)
            on = on and true or false
            M.enabled = on
            if on then
                if not M.gui or not M.gui.Parent then build() end
                if M.gui then M.gui.Enabled = true end
                paintBtn()
            else
                if M.gui then M.gui.Enabled = false end
            end
            pcall(function()
                if Config then
                    Config.set("allow_friends_visible", on)
                    Config.set("toggle:Allow Friends", on)
                end
            end)
        end

        function M.isEnabled()
            return M.enabled
        end

        function M.repaint()
            paintBtn()
        end

        task.defer(function()
            pcall(build)
            if M.gui then M.gui.Enabled = false end
        end)

        return M
    end)()

    table.insert(_G._FH_TEARDOWN, function()
        pcall(function()
            if _G.AllowFriends and _G.AllowFriends.set then
                _G.AllowFriends.set(false)
            end
        end)
    end)

    Section(Utils.scroll, "Other")
    Toggle(Utils.scroll, "Allow Friends", nil, function(state)
        if _G.AllowFriends and _G.AllowFriends.set then
            _G.AllowFriends.set(state and true or false)
        end
    end)
    Toggle(Utils.scroll, "Quick Grab", nil, function(state)
        if _G.QuickGrab and _G.QuickGrab.set then
            _G.QuickGrab.set(state and true or false)
        end
    end)

    Section(Utils.scroll, "Misc")
    Toggle(Utils.scroll, "Cyutsud hub All Gear", "OFF = normal · ON = retire gear list + ragdoll actions", function(state)
        if _G.CyutsudHubAllGear and _G.CyutsudHubAllGear.set then
            _G.CyutsudHubAllGear.set(state and true or false)
        end
    end)
    task.defer(function()
        pcall(function()
            local want = false
            if getToggleSaved then
                want = getToggleSaved("Cyutsud hub All Gear", false)
            elseif Config then
                want = Config.get("nox_hub_all_gear", false) == true
                    or Config.get("toggle:Cyutsud hub All Gear", false) == true
            end
            if want and _G.CyutsudHubAllGear and _G.CyutsudHubAllGear.set then
                _G.CyutsudHubAllGear.set(true)
            end
        end)
    end)

    Section(Utils.scroll, "Interface")
    do
        local card = Card(Utils.scroll, 36)
        local nameLbl = Lbl(card, "Font", 12, T.Text, Enum.Font.GothamBold)
        nameLbl.Size = UDim2.new(0, 50, 1, 0)
        nameLbl.Position = UDim2.new(0, 12, 0, 0)
        nameLbl.TextYAlignment = Enum.TextYAlignment.Center
        nameLbl.ZIndex = 5

        local selectedLbl = Lbl(card, _G.CyutsudHubSelectedFont or "Gotham Bold", 11, T.TextDim, Enum.Font.GothamBold)
        selectedLbl.Size = UDim2.new(1, -100, 1, 0)
        selectedLbl.Position = UDim2.new(0, 60, 0, 0)
        selectedLbl.TextYAlignment = Enum.TextYAlignment.Center
        selectedLbl.ZIndex = 5
        pcall(function()
            selectedLbl.Font = fontByName(_G.CyutsudHubSelectedFont or "Gotham Bold")
        end)

        local arrow = Lbl(card, "►", 12, T.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        arrow.Size = UDim2.new(0, 24, 1, 0)
        arrow.Position = UDim2.new(1, -28, 0, 0)
        arrow.TextYAlignment = Enum.TextYAlignment.Center
        arrow.ZIndex = 5

        local headerBtn = Instance.new("TextButton")
        headerBtn.Size = UDim2.new(1, 0, 1, 0)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.ZIndex = 6
        headerBtn.Parent = card

        local listCard = Instance.new("Frame")
        listCard.Name = "FontListCard"
        listCard.Size = UDim2.new(1, -10, 0, 0)
        listCard.BackgroundColor3 = T.Card
        listCard.BorderSizePixel = 0
        listCard.Visible = false
        listCard.ClipsDescendants = true
        listCard.ZIndex = 4
        listCard.Parent = Utils.scroll
        pcall(function() trackBgFrame(listCard, "Card") end)
        Corner(listCard, 12)
        Stroke(listCard, T.Line, 1, 0.4)

        local listScroll = Instance.new("ScrollingFrame")
        listScroll.Size = UDim2.new(1, 0, 1, 0)
        listScroll.BackgroundTransparency = 1
        listScroll.BorderSizePixel = 0
        listScroll.ScrollBarThickness = 3
        listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listScroll.ZIndex = 5
        listScroll.Parent = listCard
        local ll = Instance.new("UIListLayout")
        ll.Padding = UDim.new(0, 3)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Parent = listScroll
        Pad(listScroll, 6, 6, 6, 6)

        local expanded = false
        local fontBtns = {}

        local function paintFontBtns()
            local cur = _G.CyutsudHubSelectedFont or "Gotham Bold"
            selectedLbl.Text = cur
            pcall(function() selectedLbl.Font = fontByName(cur) end)
            for name, b in pairs(fontBtns) do
                if name == cur then
                    b.BackgroundColor3 = Theme.c1 or T.Primary
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BackgroundColor3 = T.Soft
                    b.TextColor3 = T.Text
                end
            end
        end

        local function setExpanded(on)
            expanded = on and true or false
            listCard.Visible = expanded
            arrow.Text = expanded and "▼" or "►"
            if expanded then
                listCard.Size = UDim2.new(1, -10, 0, 220)
            else
                listCard.Size = UDim2.new(1, -10, 0, 0)
            end
        end

        headerBtn.Activated:Connect(function()
            setExpanded(not expanded)
        end)

        for i, f in ipairs(FONTS_LIST) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 28)
            b.BackgroundColor3 = T.Soft
            b.BorderSizePixel = 0
            b.Text = f.name
            b.TextColor3 = T.Text
            b.TextSize = 12
            b.Font = f.enum
            b.AutoButtonColor = false
            b.LayoutOrder = i
            b.ZIndex = 6
            b.Parent = listScroll
            Corner(b, 8)
            b.Activated:Connect(function()
                selectHubFont(f.name)
                paintFontBtns()
                setExpanded(false)
            end)
            fontBtns[f.name] = b
        end
        paintFontBtns()

        pcall(function()
            local old = _G._CyutsudBroadcastTheme
            if type(old) == "function" then
            end
        end)
    end

    do
        local CARPETS = {
            "Flying Carpet",
            "Cupid's Wings",
            "Witch's Broom",
            "Waverider",
            "Santa's Sleigh",
        }

        local curName = _G.coreSelectedCarpet or _G.CyutsudHubSelectedCarpet or "Flying Carpet"
        pcall(function()
            if Config then
                local s = Config.get("selectedCarpet", nil)
                if type(s) == "string" and s ~= "" then curName = s end
            end
        end)
        _G.coreSelectedCarpet = curName
        _G.CyutsudHubSelectedCarpet = curName
        _G.CyutsudHubSelectedCarpet = curName

        local card = Card(Utils.scroll, 36)
        local nameLbl = Lbl(card, "Carpet", 12, T.Text, Enum.Font.GothamBold)
        nameLbl.Size = UDim2.new(0, 58, 1, 0)
        nameLbl.Position = UDim2.new(0, 12, 0, 0)
        nameLbl.TextYAlignment = Enum.TextYAlignment.Center
        nameLbl.ZIndex = 5

        local selectedLbl = Lbl(card, curName, 11, T.TextDim, Enum.Font.GothamBold)
        selectedLbl.Size = UDim2.new(1, -108, 1, 0)
        selectedLbl.Position = UDim2.new(0, 68, 0, 0)
        selectedLbl.TextYAlignment = Enum.TextYAlignment.Center
        selectedLbl.TextTruncate = Enum.TextTruncate.AtEnd
        selectedLbl.ZIndex = 5

        local arrow = Lbl(card, "►", 12, T.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        arrow.Size = UDim2.new(0, 24, 1, 0)
        arrow.Position = UDim2.new(1, -28, 0, 0)
        arrow.TextYAlignment = Enum.TextYAlignment.Center
        arrow.ZIndex = 5

        local headerBtn = Instance.new("TextButton")
        headerBtn.Size = UDim2.new(1, 0, 1, 0)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.ZIndex = 6
        headerBtn.Parent = card

        local listCard = Instance.new("Frame")
        listCard.Name = "CarpetListCard"
        listCard.Size = UDim2.new(1, -10, 0, 0)
        listCard.BackgroundColor3 = T.Card
        listCard.BorderSizePixel = 0
        listCard.Visible = false
        listCard.ClipsDescendants = true
        listCard.ZIndex = 4
        listCard.Parent = Utils.scroll
        pcall(function() trackBgFrame(listCard, "Card") end)
        Corner(listCard, 12)
        Stroke(listCard, T.Line, 1, 0.4)

        local listScroll = Instance.new("ScrollingFrame")
        listScroll.Size = UDim2.new(1, 0, 1, 0)
        listScroll.BackgroundTransparency = 1
        listScroll.BorderSizePixel = 0
        listScroll.ScrollBarThickness = 3
        listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listScroll.ZIndex = 5
        listScroll.Parent = listCard
        local ll = Instance.new("UIListLayout")
        ll.Padding = UDim.new(0, 3)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Parent = listScroll
        Pad(listScroll, 6, 6, 6, 6)

        local expanded = false
        local carpetBtns = {}

        local function paintCarpetBtns()
            local cur = _G.coreSelectedCarpet or "Flying Carpet"
            selectedLbl.Text = cur
            for name, b in pairs(carpetBtns) do
                if name == cur then
                    b.BackgroundColor3 = Theme.c1 or T.Primary
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BackgroundColor3 = T.Soft
                    b.TextColor3 = T.Text
                end
            end
        end

        local function setExpanded(on)
            expanded = on and true or false
            listCard.Visible = expanded
            arrow.Text = expanded and "▼" or "►"
            listCard.Size = expanded and UDim2.new(1, -10, 0, 160) or UDim2.new(1, -10, 0, 0)
        end

        local function selectCarpet(name)
            if not name then return end
            _G.coreSelectedCarpet = name
            _G.CyutsudHubSelectedCarpet = name
            _G.CyutsudHubSelectedCarpet = name
            pcall(function()
                if Config then
                    Config.set("selectedCarpet", name)
                    if Config.flush then Config.flush() end
                end
            end)
            pcall(function()
                if _G.coreConfig and _G.coreConfig.set then
                    _G.coreConfig:set("selectedCarpet", name)
                end
            end)
            paintCarpetBtns()
            setExpanded(false)
            pcall(function()
                if _G.equipCarpet then
                    _G.equipCarpet()
                elseif _G._CyutsudEquipCarpet then
                    _G._CyutsudEquipCarpet()
                end
            end)
        end
        _G._CyutsudSelectCarpet = selectCarpet

        headerBtn.Activated:Connect(function()
            setExpanded(not expanded)
        end)

        for i, name in ipairs(CARPETS) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 28)
            b.BackgroundColor3 = T.Soft
            b.BorderSizePixel = 0
            b.Text = name
            b.TextColor3 = T.Text
            b.TextSize = 12
            b.Font = Enum.Font.GothamBold
            b.AutoButtonColor = false
            b.LayoutOrder = i
            b.ZIndex = 6
            b.Parent = listScroll
            Corner(b, 8)
            b.Activated:Connect(function()
                selectCarpet(name)
            end)
            carpetBtns[name] = b
        end
        paintCarpetBtns()
    end

    Slider(Utils.scroll, "UI Size", 50, 200, 100, function(v)
        _UI.userPct = v
        _applyUiScale()
    end, 1, function(v)
        _UI.userPct = v
        _applyUiScale()
    end)

    -- Global menu transparency for the hub and its detached panels.
    -- Persist the chosen percentage so it survives closing/reopening the hub
    -- and re-executing the script (when the Config backend supports saving).
    -- 0 = original appearance; 90 = very transparent backgrounds/images.
    local _savedMenuTransparency = 0
    pcall(function()
        _savedMenuTransparency = tonumber(Config.get("slider:Menu Transparency", 0)) or 0
    end)
    _savedMenuTransparency = math.clamp(_savedMenuTransparency, 0, 90)
    local _menuTransparency = _savedMenuTransparency / 100
    local _transparencyPanelNames = {
        ["CyutsudHub"] = true,
        ["PanelGui_Actions"] = true,
        ["PanelGui_ActionsMobile"] = true,
        ["PanelGui_CyutsudQuickPanel"] = true,
        ["PanelGui_Cyutsud Admin Spammer"] = true,
        ["PanelGui_Flux Admin Spammer"] = true,
        ["AdminSpammerStandalone"] = true,
        ["PanelGui_StealTarget"] = true,
        ["PanelGui_Defender"] = true,
        ["PanelGui_Defense"] = true,
        ["PanelGui_Cyutsud Defense"] = true,
        ["PanelGui_Booster"] = true,
        ["PanelGui_Instant Steal"] = true,
        ["PanelGui_Instant Steal V2"] = true,
        ["PanelGui_Instant Steal V3"] = true,
        ["PanelGui_Admin Panel"] = true,
    }

    local function _applyMenuTransparency(obj)
        if not obj then return end
        pcall(function()
            if obj:IsA("GuiObject") then
                if obj:GetAttribute("_CyutsudBaseBgTransparency") == nil then
                    obj:SetAttribute("_CyutsudBaseBgTransparency", obj.BackgroundTransparency)
                end
                local base = obj:GetAttribute("_CyutsudBaseBgTransparency")
                obj.BackgroundTransparency = math.clamp(base + (1 - base) * _menuTransparency, 0, 1)
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if obj:GetAttribute("_CyutsudBaseImageTransparency") == nil then
                    obj:SetAttribute("_CyutsudBaseImageTransparency", obj.ImageTransparency)
                end
                local base = obj:GetAttribute("_CyutsudBaseImageTransparency")
                obj.ImageTransparency = math.clamp(base + (1 - base) * _menuTransparency, 0, 1)
            elseif obj:IsA("UIStroke") then
                if obj:GetAttribute("_CyutsudBaseStrokeTransparency") == nil then
                    obj:SetAttribute("_CyutsudBaseStrokeTransparency", obj.Transparency)
                end
                local base = obj:GetAttribute("_CyutsudBaseStrokeTransparency")
                obj.Transparency = math.clamp(base + (1 - base) * _menuTransparency, 0, 1)
            end
        end)
    end

    local function _getTransparencyRoots()
        local roots, seen = {}, {}
        local function addRoot(root)
            if root and not seen[root] then
                seen[root] = true
                table.insert(roots, root)
            end
        end
        addRoot(GUI)
        pcall(function()
            local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if pg then
                for _, child in ipairs(pg:GetChildren()) do
                    if _transparencyPanelNames[child.Name] then addRoot(child) end
                end
            end
        end)
        pcall(function()
            if type(gethui) == "function" then
                local hui = gethui()
                for _, child in ipairs(hui:GetChildren()) do
                    if _transparencyPanelNames[child.Name] then addRoot(child) end
                end
            end
        end)
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            for _, child in ipairs(coreGui:GetChildren()) do
                if _transparencyPanelNames[child.Name] then addRoot(child) end
            end
        end)
        return roots
    end

    local function _refreshAllMenuTransparency()
        for _, root in ipairs(_getTransparencyRoots()) do
            _applyMenuTransparency(root)
            for _, obj in ipairs(root:GetDescendants()) do
                _applyMenuTransparency(obj)
            end
        end
    end

    _refreshAllMenuTransparency()
    -- Keep detached panels in sync if they are opened after the slider is moved.
    pcall(function()
        local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            pg.DescendantAdded:Connect(function(obj)
                task.defer(function()
                    local root = obj
                    while root and root.Parent and not _transparencyPanelNames[root.Name] do
                        root = root.Parent
                    end
                    if root and _transparencyPanelNames[root.Name] then
                        _applyMenuTransparency(obj)
                    end
                end)
            end)
        end
    end)
    Slider(Utils.scroll, "Menu Transparency", 0, 90, _savedMenuTransparency, function(v)
        _menuTransparency = math.clamp(tonumber(v) or 0, 0, 90) / 100
        _refreshAllMenuTransparency()
        pcall(function() Config.set("slider:Menu Transparency", v) end)
    end, 1, function(v)
        _menuTransparency = math.clamp(tonumber(v) or 0, 0, 90) / 100
        _refreshAllMenuTransparency()
        pcall(function()
            Config.set("slider:Menu Transparency", v)
            if Config.flush then Config.flush() end
            if Config.save then Config.save() end
        end)
    end)

    Button(Utils.scroll, "Fast Leave", "Leave the current Roblox server", function()
        pcall(function() Players.LocalPlayer:Kick("Leaving game") end)
    end)
    Button(Utils.scroll, "Fast Rejoin", "Reconnect to this experience", function()
        local player = Players.LocalPlayer
        if not player then return end
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end)
    end)
    Button(Utils.scroll, "Fast Reset", "Reset your character", function()
        local player = Players.LocalPlayer
        local character = player and player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() humanoid.Health = 0 end) end
    end)
    Button(Utils.scroll, "Reset Gui", "Centre toutes les interfaces", function()
        local function centerGui(obj)
            if not obj or not obj.Parent then return end
            if not obj:IsA("GuiObject") then return end
            pcall(function()
                obj.AnchorPoint = Vector2.new(0.5, 0.5)
                obj.Position = UDim2.new(0.5, 0, 0.5, 0)
            end)
        end

        local function findNamed(name)
            local found = {}
            local parents = {}
            pcall(function()
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then table.insert(parents, h) end
                end
            end)
            pcall(function()
                table.insert(parents, game:GetService("CoreGui"))
            end)
            pcall(function()
                local lp = Players.LocalPlayer
                local pg = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
                if pg then table.insert(parents, pg) end
            end)
            pcall(function()
                if GUI then table.insert(parents, GUI) end
            end)
            for _, parent in ipairs(parents) do
                pcall(function()
                    local o = parent:FindFirstChild(name)
                    if o then table.insert(found, o) end
                    for _, d in ipairs(parent:GetDescendants()) do
                        if d.Name == name then
                            table.insert(found, d)
                        end
                    end
                end)
            end
            return found
        end

        local function centerScreenGui(sg)
            if not sg then return end
            pcall(function()
                local fr = sg:FindFirstChild("Frame")
                if fr and fr:IsA("GuiObject") then
                    centerGui(fr)
                    return
                end
                for _, ch in ipairs(sg:GetChildren()) do
                    if ch:IsA("Frame") or ch:IsA("ImageLabel") or ch:IsA("TextButton") then
                        centerGui(ch)
                    end
                end
            end)
        end

        pcall(function()
            if Root then
                centerGui(Root)
            end
        end)

        -- Ne pas reset la position du bouton CYUTSUD (ReopenBtn) : on le laisse où il est

        local panelNames = {
            "PanelGui_Actions",
            "PanelGui_ActionsMobile",
            "PanelGui_CyutsudQuickPanel",
            "PanelGui_Cyutsud Admin Spammer",
            "PanelGui_Command Cooldowns",
            "PanelGui_Booster",
            "PanelGui_Cyutsud Defense",
            "PanelGui_Defense",
            "PanelGui_Cyutsud Defense",
            "PanelGui_Instant Steal V2",
            "PanelGui_StealTarget",
            "PanelGui_Admin Panel",
        }
        for _, name in ipairs(panelNames) do
            for _, obj in ipairs(findNamed(name)) do
                if obj:IsA("ScreenGui") then
                    centerScreenGui(obj)
                elseif obj:IsA("GuiObject") then
                    centerGui(obj)
                end
            end
        end

        pcall(function()
            if Config then
                -- Préserve la position du bouton CYUTSUD si elle existe dans positions
                local positions = Config.get("positions", {}) or {}
                local reopenPos = nil
                if type(positions) == "table" then
                    reopenPos = positions["CyutsudHubReopen"] or positions["NoxReopenBtn"] or positions["reopen"]
                end
                local savedReopen = Config.get("reopen_pos", nil)

                Config.set("positions", {})
                if reopenPos then
                    local newPos = {}
                    newPos["CyutsudHubReopen"] = reopenPos
                    if positions["NoxReopenBtn"] then newPos["NoxReopenBtn"] = positions["NoxReopenBtn"] end
                    Config.set("positions", newPos)
                end
                -- Ne pas effacer reopen_pos
                if savedReopen ~= nil then
                    Config.set("reopen_pos", savedReopen)
                end
                Config.set("root_pos", nil)
                Config.set("actions_panel_pos", nil)
                Config.set("isv2_panel_pos", nil)
                if Config.flush then Config.flush() end
            end
        end)

        pcall(function()
            if showToast then showToast("GUI reset (center)", true) end
        end)
    end)

    Section(ConfigTab.scroll, "Save")
    Button(ConfigTab.scroll, "Save Config", "Force write config to disk", function()
        pcall(function()
            if Config then
                if Config.flush then Config.flush() end
                if Config.save then Config.save() end
            end
        end)
        pcall(function()
            if showToast then showToast("Config saved", true) end
        end)
    end)
    Button(ConfigTab.scroll, "Reload Config", "Re-read config from disk", function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local FILE = "CyutsudHub/config.json"
            local FILE_BAK = "CyutsudHub/config.bak.json"
            local function tryDecode(path)
                if isfile and readfile and isfile(path) then
                    local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
                    if ok and type(decoded) == "table" then return decoded end
                end
            end
            local d = tryDecode(FILE) or tryDecode(FILE_BAK)
            if d and Config then
                Config.data = d
                if _G._CyutsudReapplyToggles then
                    task.defer(function() pcall(_G._CyutsudReapplyToggles) end)
                end
                if showToast then showToast("Config reloaded", true) end
            else
                if showToast then showToast("No config file", false) end
            end
        end)
    end)

    Section(ConfigTab.scroll, "Export / Import")
    Button(ConfigTab.scroll, "Export Config", "Download config as .txt + clipboard", function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            if not Config or type(Config.data) ~= "table" then
                if showToast then showToast("No config data", false) end
                return
            end
            if Config.flush then pcall(function() Config.flush() end) end
            local ok, encoded = pcall(function()
                return HttpService:JSONEncode(Config.data)
            end)
            if not ok or type(encoded) ~= "string" or #encoded < 2 then
                if showToast then showToast("Encode failed", false) end
                return
            end
            local EXPORT_TXT = "CyutsudHub/config_export.txt"
            local EXPORT_JSON = "CyutsudHub/config_export.json" -- keep legacy for import compat
            pcall(function()
                if makefolder then
                    if not (isfolder and isfolder("CyutsudHub")) then makefolder("CyutsudHub") end
                end
            end)
            local wrote = false
            pcall(function()
                if writefile then
                    writefile(EXPORT_TXT, encoded)
                    wrote = true
                    pcall(function() writefile(EXPORT_JSON, encoded) end)
                end
            end)
            local clipped = false
            pcall(function()
                if setclipboard then
                    setclipboard(encoded)
                    clipped = true
                elseif toclipboard then
                    toclipboard(encoded)
                    clipped = true
                end
            end)
            local msg = "Exported"
            if wrote then msg = msg .. " → " .. EXPORT_TXT end
            if clipped then msg = msg .. " (+ clipboard)" end
            if showToast then showToast(msg, true) end
        end)
    end)
    Button(ConfigTab.scroll, "Import Config", "From CyutsudHub/config_export.txt", function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            if not Config then
                if showToast then showToast("Config unavailable", false) end
                return
            end
            local candidates = {
                "CyutsudHub/config_export.txt",
                "CyutsudHub/config_export.json",
                "CyutsudHub/import.json",
                "CyutsudHub/import.txt",
                "CyutsudHub/config.json",
            }
            local decoded = nil
            local used = nil
            for _, path in ipairs(candidates) do
                local okRead, body = pcall(function()
                    if isfile and isfile(path) and readfile then
                        return readfile(path)
                    end
                end)
                if okRead and type(body) == "string" and #body > 2 then
                    local okJ, data = pcall(function()
                        return HttpService:JSONDecode(body)
                    end)
                    if okJ and type(data) == "table" then
                        decoded = data
                        used = path
                        break
                    end
                end
            end
            if not decoded then
                if showToast then showToast("No import file found", false) end
                return
            end
            if type(Config.data) ~= "table" then Config.data = {} end
            for k, v in pairs(decoded) do
                Config.data[k] = v
            end
            Config._dirty = true
            pcall(function()
                if Config.flush then Config.flush() end
                if Config.save then Config.save() end
            end)
            task.defer(function()
                pcall(function()
                    if _G._CyutsudReapplyToggles then _G._CyutsudReapplyToggles() end
                end)
            end)
            if showToast then showToast("Imported: " .. tostring(used), true) end
        end)
    end)
    Button(ConfigTab.scroll, "Import Clipboard", "Paste JSON from clipboard", function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            if not Config then return end
            local body = nil
            pcall(function()
                if getclipboard then body = getclipboard() end
            end)
            if type(body) ~= "string" or #body < 2 then
                if showToast then showToast("Clipboard empty", false) end
                return
            end
            body = body:gsub("^```json%s*", ""):gsub("^```%s*", ""):gsub("%s*```$", "")
            local okJ, data = pcall(function()
                return HttpService:JSONDecode(body)
            end)
            if not okJ or type(data) ~= "table" then
                if showToast then showToast("Invalid JSON clipboard", false) end
                return
            end
            if type(Config.data) ~= "table" then Config.data = {} end
            for k, v in pairs(data) do
                Config.data[k] = v
            end
            Config._dirty = true
            pcall(function()
                if Config.flush then Config.flush() end
                if Config.save then Config.save() end
            end)
            task.defer(function()
                pcall(function()
                    if _G._CyutsudReapplyToggles then _G._CyutsudReapplyToggles() end
                end)
            end)
            if showToast then showToast("Imported from clipboard", true) end
        end)
    end)

    Section(ConfigTab.scroll, "Paste Config")
    do
        local boxCard = Instance.new("Frame")
        boxCard.Size = UDim2.new(1, -8, 0, 120)
        boxCard.BackgroundColor3 = T.Card
        boxCard.BorderSizePixel = 0
        boxCard.LayoutOrder = 50
        boxCard.Parent = ConfigTab.scroll
        pcall(function()
            if trackBgFrame then trackBgFrame(boxCard, "Card") end
        end)
        Corner(boxCard, 12)
        Stroke(boxCard, T.Line, 1, 0.8)

        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(1, -12, 0, 16)
        hint.Position = UDim2.new(0, 8, 0, 4)
        hint.BackgroundTransparency = 1
        hint.Text = "Colle ici le JSON d'une config"
        hint.TextColor3 = T.TextDim
        hint.Font = Enum.Font.Gotham
        hint.TextSize = 10
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.Parent = boxCard

        local input = Instance.new("TextBox")
        input.Name = "ConfigPasteBox"
        input.Size = UDim2.new(1, -12, 1, -28)
        input.Position = UDim2.new(0, 6, 0, 22)
        input.BackgroundColor3 = T.BgDeep or Color3.fromRGB(12, 10, 9)
        input.BorderSizePixel = 0
        input.ClearTextOnFocus = false
        input.MultiLine = true
        input.TextWrapped = true
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.TextYAlignment = Enum.TextYAlignment.Top
        input.Font = Enum.Font.Code
        input.TextSize = 11
        input.TextColor3 = T.Text
        input.PlaceholderText = '{"toggles":{...}, ...}'
        input.PlaceholderColor3 = T.TextDim
        input.Text = ""
        input.ZIndex = 5
        input.Parent = boxCard
        Corner(input, 8)
        do
            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 6)
            pad.PaddingBottom = UDim.new(0, 6)
            pad.PaddingLeft = UDim.new(0, 8)
            pad.PaddingRight = UDim.new(0, 8)
            pad.Parent = input
        end

        _G._CyutsudConfigPasteBox = input

        local function importFromText(raw)
            local HttpService = game:GetService("HttpService")
            if not Config then
                if showToast then showToast("Config unavailable", false) end
                return false
            end
            if type(raw) ~= "string" then
                if showToast then showToast("Empty text", false) end
                return false
            end
            raw = raw:gsub("^%s+", ""):gsub("%s+$", "")
            if #raw < 2 then
                if showToast then showToast("Empty text", false) end
                return false
            end
            raw = raw:gsub("^```json%s*", ""):gsub("^```%s*", ""):gsub("%s*```$", "")
            local okJ, data = pcall(function()
                return HttpService:JSONDecode(raw)
            end)
            if not okJ or type(data) ~= "table" then
                if showToast then showToast("JSON invalide", false) end
                return false
            end
            if type(Config.data) ~= "table" then Config.data = {} end
            for k, v in pairs(data) do
                Config.data[k] = v
            end
            Config._dirty = true
            pcall(function()
                if Config.flush then Config.flush() end
                if Config.save then Config.save() end
            end)
            task.defer(function()
                pcall(function()
                    if _G._CyutsudReapplyToggles then _G._CyutsudReapplyToggles() end
                end)
            end)
            if showToast then showToast("Config importée", true) end
            return true
        end

        Button(ConfigTab.scroll, "Import Pasted Config", "Import JSON from the box above", function()
            local box = _G._CyutsudConfigPasteBox
            local text = box and box.Text or ""
            importFromText(text)
        end)
    end

    Section(ConfigTab.scroll, "Danger")
    Button(ConfigTab.scroll, "Reset Full Config", "Reset ALL settings, toggles, panels", function()
        task.spawn(function()
            pcall(function()
                local reg = _G._CyutsudToggleReg
                if type(reg) == "table" then
                    for name, ctrl in pairs(reg) do
                        if ctrl and ctrl.set then
                            pcall(function() ctrl.set(false, false) end)
                        end
                    end
                end
            end)

            pcall(function()
                local cbs = _G._CyutsudToggleCallbacks
                if type(cbs) == "table" then
                    for name, cb in pairs(cbs) do
                        if type(cb) == "function" then
                            pcall(cb, false)
                        end
                    end
                end
            end)

            pcall(function()
                if _G.DefensePanel then
                    if _G.DefensePanel.setVisible then _G.DefensePanel.setVisible(false) end
                end
                if _G.InstantStealV2 and _G.InstantStealV2.set then _G.InstantStealV2.set(false) end
                if _G.BoosterGUI and _G.BoosterGUI.setVisible then _G.BoosterGUI.setVisible(false) end
                if _G.Booster and _G.Booster.set then _G.Booster.set(false) end
                if _G.StealTarget and _G.StealTarget.set then _G.StealTarget.set(false) end
                if _G.ActionsPanel and _G.ActionsPanel.setVisible then _G.ActionsPanel.setVisible(false) end
                if _G.ActionsPanel and _G.ActionsPanel.set then _G.ActionsPanel.set(false) end
                if _G.ActionsPanelMobile and _G.ActionsPanelMobile.set then _G.ActionsPanelMobile.set(false) end
                if _G.QuickAdminPanel and _G.QuickAdminPanel.set then _G.QuickAdminPanel.set(false) end
                if _G.AdminSpammer and _G.AdminSpammer.set then _G.AdminSpammer.set(false) end
                if _G.CommandCooldowns and _G.CommandCooldowns.set then _G.CommandCooldowns.set(false) end
                if _G.BrainrotESP and _G.BrainrotESP.set then _G.BrainrotESP.set(false) end
                if _G.PlayerESP and _G.PlayerESP.set then _G.PlayerESP.set(false) end
                if _G.CloneESP and _G.CloneESP.set then _G.CloneESP.set(false) end
                if _G.TimerESP and _G.TimerESP.set then _G.TimerESP.set(false) end
                if _G.MineESP and _G.MineESP.set then _G.MineESP.set(false) end
                if _G.APESP and _G.APESP.set then _G.APESP.set(false) end
                if _G.AllowDisallowESP and _G.AllowDisallowESP.set then _G.AllowDisallowESP.set(false) end
                if _G.Unwalk and _G.Unwalk.set then _G.Unwalk.set(false) end
                if _G.QuickGrab and _G.QuickGrab.set then _G.QuickGrab.set(false) end
                if _G.AntiAdmin and _G.AntiAdmin.set then _G.AntiAdmin.set(false) end
                if _G.AutoResetOnBalloon and _G.AutoResetOnBalloon.set then _G.AutoResetOnBalloon.set(false) end
                if _G.IntruderAlarm and _G.IntruderAlarm.set then _G.IntruderAlarm.set(false) end
                if _G.GummyBypass and _G.GummyBypass.set then _G.GummyBypass.set(false) end
                if _G.PaintBallBypass and _G.PaintBallBypass.set then _G.PaintBallBypass.set(false) end
                if _G.InfiniteJump and _G.InfiniteJump.set then _G.InfiniteJump.set(false) end
                if _G.CarpetSpeed and _G.CarpetSpeed.set then _G.CarpetSpeed.set(false) end
                if _G.AutoCarpetSpeed and _G.AutoCarpetSpeed.set then _G.AutoCarpetSpeed.set(false) end
                if _G.FPSBooster and _G.FPSBooster.set then _G.FPSBooster.set(false) end
                if Steal and Steal.AutoStealEnabled ~= nil then Steal.AutoStealEnabled = false end
                if HALF then
                    HALF.potion = false
                    HALF.autoWalk = false
                    HALF.autoTpOnAllow = false
                    HALF.autoTpOnUnlock = false
                end
            end)

            pcall(function()
                if Config then
                    Config.data = {}
                    Config._dirty = true
                end
            end)

            pcall(function()
                local HttpService = game:GetService("HttpService")
                local empty = "{}"
                pcall(function()
                    if makefolder and not (isfolder and isfolder("CyutsudHub")) then
                        makefolder("CyutsudHub")
                    end
                end)
                if writefile then
                    pcall(function() writefile("CyutsudHub/config.json", empty) end)
                    pcall(function() writefile("CyutsudHub/config.bak.json", empty) end)
                    pcall(function() writefile("CyutsudHub/config_export.json", empty) end)
                    pcall(function() writefile("CyutsudHub/config_export.txt", empty) end)
                end
                if Config then
                    Config.data = {}
                    Config._dirty = false
                    if Config.flush then pcall(function() Config.flush() end) end
                end
            end)

            pcall(function()
                if _G._CyutsudConfigPasteBox then
                    _G._CyutsudConfigPasteBox.Text = ""
                end
            end)

            pcall(function()
                if _UI then
                    _UI.userPct = 100
                    if _applyUiScale then _applyUiScale() end
                end
            end)

            pcall(function()
                if showToast then showToast("Full config reset", true) end
            end)
        end)
    end)

    do
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -8, 0, 36)
        info.BackgroundTransparency = 1
        info.Text = "Path: CyutsudHub/config.json\nExport: CyutsudHub/config_export.txt\nAuto-save every 2s"
        info.TextColor3 = T.TextDim
        info.Font = Enum.Font.Gotham
        info.TextSize = 10
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.TextWrapped = true
        info.LayoutOrder = 999
        info.Parent = ConfigTab.scroll
    end

    local Picker
    local __gIIFE_3 = (function()
        Picker = Instance.new("Frame")
        Picker.Size             = UDim2.new(0, 208, 0, 214)
        Picker.BackgroundColor3 = T.Side
        Picker.BorderSizePixel  = 0
        Picker.Visible          = false
        Picker.ZIndex           = 500
        Picker.Parent           = GUI
        _newScale(Picker)
        trackBgFrame(Picker, "Side")
        Corner(Picker, 10)
        GradStroke(Picker, 2, 0, 0)

        local PickerHdr = Instance.new("Frame")
        PickerHdr.Size             = UDim2.new(1, 0, 0, 24)
        PickerHdr.BackgroundColor3 = T.BgDeep
        PickerHdr.BorderSizePixel  = 0
        PickerHdr.ZIndex           = 101
        PickerHdr.Parent           = Picker
        trackBgFrame(PickerHdr, "BgDeep")
        Corner(PickerHdr, 10)

        local PickerHdrFill = Instance.new("Frame")
        PickerHdrFill.Size             = UDim2.new(1, 0, 0, 8)
        PickerHdrFill.Position         = UDim2.new(0, 0, 1, -8)
        PickerHdrFill.BackgroundColor3 = T.BgDeep
        PickerHdrFill.BorderSizePixel  = 0
        PickerHdrFill.ZIndex           = 101
        PickerHdrFill.Parent           = PickerHdr
        trackBgFrame(PickerHdrFill, "BgDeep")

        local PickerTitle = Lbl(PickerHdr, "Color Picker", 10, T.Text, Enum.Font.GothamBold)
        PickerTitle.Size           = UDim2.new(1, -30, 1, 0)
        PickerTitle.Position       = UDim2.new(0, 10, 0, 0)
        PickerTitle.TextYAlignment = Enum.TextYAlignment.Center
        PickerTitle.ZIndex         = 102

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size                   = UDim2.new(0, 20, 0, 20)
        CloseBtn.Position               = UDim2.new(1, -22, 0, 2)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Text                   = "x"
        CloseBtn.Font                   = Enum.Font.GothamBold
        CloseBtn.TextSize               = 12
        CloseBtn.TextColor3             = T.TextDim
        CloseBtn.AutoButtonColor        = false
        CloseBtn.ZIndex                 = 102
        CloseBtn.Parent                 = PickerHdr
        CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, F, {TextColor3 = T.Text}) end)
        CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, F, {TextColor3 = T.TextDim}) end)

        local SV = Instance.new("Frame")
        SV.Size             = UDim2.new(0, 158, 0, 124)
        SV.Position         = UDim2.new(0, 10, 0, 32)
        SV.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        SV.BorderSizePixel  = 0
        SV.ZIndex           = 101
        SV.Parent           = Picker
        Corner(SV, 10)

        local SatOverlay = Instance.new("Frame")
        SatOverlay.Size             = UDim2.new(1, 0, 1, 0)
        SatOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SatOverlay.BorderSizePixel  = 0
        SatOverlay.ZIndex           = 102
        SatOverlay.Parent           = SV
        Corner(SatOverlay, 10)
        local satGrad = Instance.new("UIGradient")
        satGrad.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
        satGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
        satGrad.Rotation = 0
        satGrad.Parent   = SatOverlay

        local ValOverlay = Instance.new("Frame")
        ValOverlay.Size             = UDim2.new(1, 0, 1, 0)
        ValOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ValOverlay.BorderSizePixel  = 0
        ValOverlay.ZIndex           = 103
        ValOverlay.Parent           = SV
        Corner(ValOverlay, 10)
        local valGrad = Instance.new("UIGradient")
        valGrad.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0))
        valGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        })
        valGrad.Rotation = 90
        valGrad.Parent   = ValOverlay

        local SVCursor = Instance.new("Frame")
        SVCursor.Size                   = UDim2.new(0, 10, 0, 10)
        SVCursor.AnchorPoint            = Vector2.new(0.5, 0.5)
        SVCursor.Position               = UDim2.new(1, 0, 0, 0)
        SVCursor.BackgroundTransparency = 1
        SVCursor.BorderSizePixel        = 0
        SVCursor.ZIndex                 = 104
        SVCursor.Parent                 = SV
        Corner(SVCursor, 10)
        Stroke(SVCursor, T.White, 2, 0)

        local HueBar = Instance.new("Frame")
        HueBar.Size             = UDim2.new(0, 18, 0, 124)
        HueBar.Position         = UDim2.new(0, 174, 0, 32)
        HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueBar.BorderSizePixel  = 0
        HueBar.ZIndex           = 101
        HueBar.Parent           = Picker
        Corner(HueBar, 10)

        local hueGrad = Instance.new("UIGradient")
        hueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,     Color3.fromRGB(255,   0,   0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255,   0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(  0, 255,   0)),
            ColorSequenceKeypoint.new(0.5,   Color3.fromRGB(  0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(  0,   0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255,   0, 255)),
            ColorSequenceKeypoint.new(1,     Color3.fromRGB(255,   0,   0)),
        })
        hueGrad.Rotation = 90
        hueGrad.Parent   = HueBar

        local HueCursor = Instance.new("Frame")
        HueCursor.Size                   = UDim2.new(1, 4, 0, 4)
        HueCursor.AnchorPoint            = Vector2.new(0.5, 0.5)
        HueCursor.Position               = UDim2.new(0.5, 0, 0, 0)
        HueCursor.BackgroundColor3       = T.White
        HueCursor.BorderSizePixel        = 0
        HueCursor.ZIndex                 = 102
        HueCursor.Parent                 = HueBar
        Corner(HueCursor, 12)
        Stroke(HueCursor, Color3.fromRGB(0, 0, 0), 1, 0.3)

        local ApplyBtn = Instance.new("TextButton")
        ApplyBtn.Size                   = UDim2.new(0, 182, 0, 44)
        ApplyBtn.Position               = UDim2.new(0, 10, 0, 162)
        ApplyBtn.BackgroundColor3       = Theme.c1
        ApplyBtn.BorderSizePixel        = 0
        ApplyBtn.Text                   = ""
        ApplyBtn.AutoButtonColor        = false
        ApplyBtn.ZIndex                 = 101
        ApplyBtn.Parent                 = Picker
        Corner(ApplyBtn, 12)
        local applyStroke = Stroke(ApplyBtn, T.White, 1.4, 0.3)
        ApplyBtn.MouseEnter:Connect(function() Tween(applyStroke, F, {Transparency = 0}) end)
        ApplyBtn.MouseLeave:Connect(function() Tween(applyStroke, F, {Transparency = 0.3}) end)

        local pickerState = {slot = 1, h = 0.75, s = 1, v = 0.97, pending = Theme.c1}

        local function updatePickerVisuals()
            local col = Color3.fromHSV(pickerState.h, pickerState.s, pickerState.v)
            pickerState.pending       = col
            SV.BackgroundColor3       = Color3.fromHSV(pickerState.h, 1, 1)
            SVCursor.Position         = UDim2.new(pickerState.s, 0, 1 - pickerState.v, 0)
            HueCursor.Position        = UDim2.new(0.5, 0, pickerState.h, 0)
            ApplyBtn.BackgroundColor3 = col
        end

        local function rgbToHsv(c)
            local r, g, b = c.R, c.G, c.B
            local mx = math.max(r, g, b)
            local mn = math.min(r, g, b)
            local d  = mx - mn
            local h  = 0
            if d > 0 then
                if mx == r then     h = ((g - b)/d) % 6
                elseif mx == g then h = ((b - r)/d) + 2
                else                h = ((r - g)/d) + 4 end
                h = h / 6
                if h < 0 then h = h + 1 end
            end
            local s = (mx > 0) and (d / mx) or 0
            return h, s, mx
        end

        local function openPicker(slot)
            pickerState.slot = slot
            local current = (slot == 1) and Theme.c1 or T.Bg
            pickerState.h, pickerState.s, pickerState.v = rgbToHsv(current)
            updatePickerVisuals()
            local guiSz = GUI.AbsoluteSize
            if isMobile then
                local px = math.max(4, math.floor((guiSz.X - 208) / 2))
                local py = math.max(4, math.floor((guiSz.Y - 214) / 2))
                Picker.Position = UDim2.new(0, px, 0, py)
            else
                local dot = (slot == 1) and Dot1 or Dot2
                local pos = dot.AbsolutePosition
                local px = math.max(8, math.min(pos.X - 100, guiSz.X - 216))
                local py = pos.Y + 24
                Picker.Position = UDim2.new(0, px, 0, py)
            end
            Picker.Visible = true
        end

        local function persistTheme()
            Config.set("theme_c1", { math.floor(Theme.c1.R*255+0.5), math.floor(Theme.c1.G*255+0.5), math.floor(Theme.c1.B*255+0.5) })
            Config.set("theme_c2", { math.floor(Theme.c2.R*255+0.5), math.floor(Theme.c2.G*255+0.5), math.floor(Theme.c2.B*255+0.5) })
            Config.set("theme_bg",  { math.floor(T.Bg.R*255+0.5),    math.floor(T.Bg.G*255+0.5),    math.floor(T.Bg.B*255+0.5)    })
        end

        local function applyLive()
            local col = pickerState.pending
            if pickerState.slot == 1 then
                -- Gamma-style accent apply
                Theme.c1 = col
                T.Primary = col
                T.Green = col
                if Dot1 then Dot1.BackgroundColor3 = col end
                if type(SetAccentColor) == "function" then
                    pcall(SetAccentColor, col)
                elseif type(Repaint) == "function" then
                    pcall(Repaint)
                end
            else
                -- Gamma-style background apply
                SetGuiColor(col)
                if Dot2 then Dot2.BackgroundColor3 = T.Bg end
            end
            persistTheme()
            pcall(function()
                if type(_G._CyutsudBroadcastTheme) == "function" then
                    _G._CyutsudBroadcastTheme()
                end
            end)
        end

        local function applyPicked()
            applyLive()
            persistTheme()
        end

        local function wireDot(btn, slot)
            if not btn then return end
            local function fire()
                pcall(openPicker, slot)
            end
            btn.Activated:Connect(fire)
            pcall(function()
                btn.MouseButton1Click:Connect(fire)
            end)
            pcall(function()
                btn.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                        fire()
                    end
                end)
            end)
        end
        wireDot(Dot1Btn, 1)
        wireDot(Dot2Btn, 2)
        -- Also allow clicking the frame itself
        pcall(function()
            if Dot1 then
                local b = Instance.new("TextButton")
                b.Name = "Dot1FrameHit"
                b.Size = UDim2.new(1, 0, 1, 0)
                b.BackgroundTransparency = 1
                b.Text = ""
                b.ZIndex = 62
                b.Parent = Dot1
                wireDot(b, 1)
            end
            if Dot2 then
                local b = Instance.new("TextButton")
                b.Name = "Dot2FrameHit"
                b.Size = UDim2.new(1, 0, 1, 0)
                b.BackgroundTransparency = 1
                b.Text = ""
                b.ZIndex = 62
                b.Parent = Dot2
                wireDot(b, 2)
            end
        end)
        CloseBtn.Activated:Connect(function() Picker.Visible = false end)
        ApplyBtn.Activated:Connect(applyPicked)

        local svDragging, hueDragging = false, false
        SV.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                svDragging = true
                local pos  = SV.AbsolutePosition
                local size = SV.AbsoluteSize
                pickerState.s = math.clamp((inp.Position.X - pos.X) / size.X, 0, 1)
                pickerState.v = 1 - math.clamp((inp.Position.Y - pos.Y) / size.Y, 0, 1)
                updatePickerVisuals(); applyLive()
            end
        end)
        SV.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then svDragging = false end
        end)
        HueBar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                hueDragging = true
                local pos  = HueBar.AbsolutePosition
                local size = HueBar.AbsoluteSize
                pickerState.h = math.clamp((inp.Position.Y - pos.Y) / size.Y, 0, 1)
                updatePickerVisuals(); applyLive()
            end
        end)
        HueBar.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then hueDragging = false end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            if svDragging then
                local pos  = SV.AbsolutePosition
                local size = SV.AbsoluteSize
                pickerState.s = math.clamp((inp.Position.X - pos.X) / size.X, 0, 1)
                pickerState.v = 1 - math.clamp((inp.Position.Y - pos.Y) / size.Y, 0, 1)
                updatePickerVisuals()
                applyLive()
            elseif hueDragging then
                local pos  = HueBar.AbsolutePosition
                local size = HueBar.AbsoluteSize
                pickerState.h = math.clamp((inp.Position.Y - pos.Y) / size.Y, 0, 1)
                updatePickerVisuals()
                applyLive()
            end
        end)
    end)()

    task.defer(function()
        pcall(function()
            local saved = Config and Config.get and Config.get("auto_giant_potion", false)
            if saved and _G.AutoBigPotion and _G.AutoBigPotion.set then
                _G.AutoBigPotion.set(true)
            end
        end)
    end)

    local function _CyutsudBroadcastTheme()
        local primary = (Theme and Theme.c1) or Color3.fromRGB(168, 85, 247)
        local bg = (T and T.Bg) or Color3.fromRGB(18, 16, 14)
        local deep = (T and T.BgDeep) or Color3.fromRGB(12, 10, 9)
        local card = (T and T.Card) or Color3.fromRGB(28, 24, 20)
        local soft = (T and T.Soft) or Color3.fromRGB(34, 28, 22)
        local text = (T and T.Text) or Color3.fromRGB(250, 245, 235)

        _G.coreTheme = _G.coreTheme or {}
        _G.coreTheme.primary = primary
        _G.coreTheme.secondary = text
        _G.coreTheme.bg = bg
        _G.coreTheme.card = card

        local modules = {
            _G.QuickAdminPanel, _G.AdminSpammer, _G.CommandCooldowns, _G.BoosterGUI,
            _G.TPBrainrot, _G.DropBrainrot,
            _G.ActionsPanel, _G.ActionsPanelMobile, _G.DefensePanel, _G.InstantStealV2, _G.StealTarget,
            _G.PlayerESP, _G.CloneESP, _G.TimerESP, _G.MineESP, _G.APESP, _G.BrainrotESP,
            _G.AllowDisallowESP, _G.AllowFriends, _G._FH_CD_Panel, _G.FPSBooster, _G.GameStretcher,
            _G.DiscordLabel,
        }
        for _, mod in ipairs(modules) do
            if type(mod) == "table" then
                if type(mod.repaint) == "function" then
                    pcall(mod.repaint)
                elseif type(mod.applyTheme) == "function" then
                    pcall(mod.applyTheme, primary, text)
                end
            end
        end

        -- Repaint all hub toggles to match current accent / bg theme
        pcall(function()
            local reg = _G._CyutsudToggleReg
            if type(reg) == "table" then
                for _, ctrl in pairs(reg) do
                    if type(ctrl) == "table" and type(ctrl.refreshTheme) == "function" then
                        pcall(ctrl.refreshTheme)
                    end
                end
            end
        end)
        pcall(function()
            if type(_G._CyutsudPaintBannerTheme) == "function" then
                _G._CyutsudPaintBannerTheme()
            end
        end)

        local names = {
            "PanelGui_Actions", "PanelGui_ActionsMobile", "PanelGui_CyutsudQuickPanel", "PanelGui_Cyutsud Admin Spammer",
            "PanelGui_Command Cooldowns", "PanelGui_Booster", "PanelGui_Cyutsud Defense",
            "PanelGui_Defense", "PanelGui_Cyutsud Defense", "PanelGui_Instant Steal V2",
            "PanelGui_StealTarget", "CyutsudHubBanner", "CyutsudHubReopen",
        }
        local parents = {}
        pcall(function()
            if type(gethui) == "function" then
                local h = gethui()
                if h then table.insert(parents, h) end
            end
        end)
        pcall(function() table.insert(parents, game:GetService("CoreGui")) end)
        pcall(function()
            local lp = Players.LocalPlayer
            local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
            if pg then table.insert(parents, pg) end
        end)
        pcall(function() if GUI then table.insert(parents, GUI) end end)

        local function recolorTree(root)
            if not root then return end
            pcall(function()
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("Frame") and (d.Name == "Frame" or d.Name == "Main") then
                        if d.BackgroundTransparency < 0.95 then
                            d.BackgroundColor3 = bg
                        end
                    end
                    if d:IsA("Frame") and (d.Name == "TitleBar" or d.Name == "Header" or d.Name == "CDHdr") then
                        d.BackgroundColor3 = deep
                    end
                    if d:IsA("UIGradient") then
                        pcall(function()
                            d.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, primary),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                            })
                        end)
                    end
                    if d:IsA("UIStroke") and not d:FindFirstChildOfClass("UIGradient") then
                        if d.Thickness and d.Thickness <= 2.5 then
                            pcall(function() d.Color = primary end)
                        end
                    end
                    if d:IsA("Frame") and (d.Name == "Badge" or d.Name == "Accent" or d.Name == "LogoBadge" or d.Name == "LogoBox") then
                        d.BackgroundColor3 = primary
                    end
                    if d:IsA("TextLabel") and d.Name ~= "StatusLabel" then
                        if d.Parent and (d.Parent.Name == "TitleBar" or d.Parent.Name == "Header") then
                            d.TextColor3 = text
                        end
                    end
                end
            end)
        end

        for _, parent in ipairs(parents) do
            for _, name in ipairs(names) do
                pcall(function()
                    local o = parent:FindFirstChild(name)
                    if o then
                        recolorTree(o)
                        if type(_G._CyutsudStyleLikeHub) == "function" then
                            local frame = o:IsA("ScreenGui") and (o:FindFirstChild("Frame") or o:FindFirstChildWhichIsA("Frame")) or o
                            if frame and frame:IsA("GuiObject") then
                                local tb = frame:FindFirstChild("TitleBar") or frame:FindFirstChild("Header") or frame:FindFirstChild("CDHdr")
                                _G._CyutsudStyleLikeHub(frame, tb)
                            end
                        end
                    end
                end)
            end
        end

        pcall(function()
            local rb = _G._FH_ReopenBtn
            if rb then
                rb.BackgroundColor3 = primary
                local lum = 0.299 * primary.R + 0.587 * primary.G + 0.114 * primary.B
                rb.TextColor3 = (lum > 0.55) and Color3.fromRGB(12, 6, 22) or Color3.fromRGB(255, 255, 255)
                for _, d in ipairs(rb:GetDescendants()) do
                    if d:IsA("UIStroke") then d.Color = primary end
                end
            end
        end)
        pcall(function()
            if PageTitle then PageTitle.TextColor3 = primary end
            if typeof(LogoBadge) == "Instance" then LogoBadge.BackgroundColor3 = primary end
            if Dot1 then Dot1.BackgroundColor3 = primary end
            if Dot2 then Dot2.BackgroundColor3 = bg end
        end)

        pcall(function()
            if GUI then
                local ban = GUI:FindFirstChild("CyutsudHubBanner")
                if ban then recolorTree(ban) end
            end
        end)
        pcall(function()
            if type(_G._CyutsudPaintBannerTheme) == "function" then
                _G._CyutsudPaintBannerTheme()
            end
        end)
    end
    _G._CyutsudBroadcastTheme = _CyutsudBroadcastTheme

    task.defer(function()
        task.wait(0.5)
        pcall(_CyutsudBroadcastTheme)
        pcall(function()
            if applyFontEverywhere then
                applyFontEverywhere(fontByName(_G.CyutsudHubSelectedFont or "Gotham Bold"))
            end
        end)
    end)


    task.defer(function()
        pcall(function()
            -- TP/Drop Brainrot only restore if All Gear is ON
            local allOn = false
            if getToggleSaved then allOn = getToggleSaved("Cyutsud hub All Gear", false)
            elseif Config then
                allOn = Config.get("nox_hub_all_gear", false) == true
                    or Config.get("toggle:Cyutsud hub All Gear", false) == true
            end
            if not allOn then return end
            task.wait(0.35)
            local wantTp = false
            if getToggleSaved then wantTp = getToggleSaved("TP Brainrot", false)
            elseif Config then wantTp = Config.get("tp_brainrot_visible", false) or Config.get("toggle:TP Brainrot", false) end
            if wantTp and _G.TPBrainrot and _G.TPBrainrot.set then
                _G.TPBrainrot.set(true)
            end
            local wantDrop = false
            if getToggleSaved then wantDrop = getToggleSaved("Drop Brainrot", false)
            elseif Config then wantDrop = Config.get("drop_brainrot_visible", false) or Config.get("toggle:Drop Brainrot", false) end
            if wantDrop and _G.DropBrainrot and _G.DropBrainrot.set then
                _G.DropBrainrot.set(true)
            end
        end)
    end)

    setPage(Main)
    task.defer(function() pcall(Repaint) end)

    task.spawn(function()
        for _ = 1, 25 do
            task.wait(0.12)
            local reg = _G._CyutsudToggleReg
            if reg and next(reg) then break end
        end
        task.wait(0.25)
        local n = 0
        pcall(function()
            if reapplyAllSavedToggles then
                n = reapplyAllSavedToggles() or 0
            elseif _G._CyutsudReapplyToggles then
                n = _G._CyutsudReapplyToggles() or 0
            end
        end)
        task.wait(1.0)
        pcall(function()
            local n2 = 0
            if reapplyAllSavedToggles then
                n2 = reapplyAllSavedToggles() or 0
            elseif _G._CyutsudReapplyToggles then
                n2 = _G._CyutsudReapplyToggles() or 0
            end
            if n2 > n then n = n2 end
        end)
        if n > 0 then
        end
    end)

    rootScale = Instance.new("UIScale")
    rootScale.Scale  = _UI.desiredScale
    rootScale.Parent = Root
    if Vis then Vis.rootScale = rootScale end
    pcall(function()
        if _G.__CyutsudBridge then _G.__CyutsudBridge.rootScale = rootScale end
    end)

    local POP_IN  = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local POP_OUT = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    visible = Config.get("hub_open", true)
    if not visible then
        Root.Visible    = false
        rootScale.Scale = 0
    end

    local curVisTween = nil
    setVisible = function(show)
        show = show and true or false
        if show == visible then
            if show and Root and not Root.Visible then
                Root.Visible = true
                if rootScale then rootScale.Scale = _UI.desiredScale or 1 end
            end
            return
        end
        visible = show
        if Vis then Vis.open = show end
        Config.set("hub_open", show)
        if curVisTween then pcall(function() curVisTween:Cancel() end) end
        if show then
            Root.Visible = true
            if rootScale then
                if rootScale.Scale < 0.01 then rootScale.Scale = (_UI.desiredScale or 1) * 0.85 end
                curVisTween = TweenService:Create(rootScale, POP_IN, {Scale = _UI.desiredScale or 1})
                curVisTween:Play()
            end
        else
            if Picker then Picker.Visible = false end
            if rootScale then
                curVisTween = TweenService:Create(rootScale, POP_OUT, {Scale = 0})
                local t = curVisTween
                t.Completed:Connect(function(state)
                    if state == Enum.PlaybackState.Completed and not visible then
                        Root.Visible = false
                    end
                end)
                t:Play()
            else
                Root.Visible = false
            end
        end
    end
    if Vis then
        Vis.set = setVisible
        Vis.open = visible
        Vis.rootScale = rootScale
    end
    _G._FH_SetVisible = setVisible
    _G._FH_Vis = Vis
    if _G.__CyutsudBridge then
        _G.__CyutsudBridge.setVisible = setVisible
        _G.__CyutsudBridge.visible = visible
        _G.__CyutsudBridge.rootScale = rootScale
        _G.__CyutsudBridge.Vis = Vis
    end

    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe and UserInputService:GetFocusedTextBox() then return end
        if inp.UserInputType == Enum.UserInputType.Keyboard
        and (inp.KeyCode == Enum.KeyCode.LeftControl
          or inp.KeyCode == Enum.KeyCode.RightControl) then
            setVisible(not visible)
        end
    end)

    do
        local function adopt(ch)
            if not ch or ch == UIRoot then return end
            if not ch:IsA("GuiObject") then return end
            if ch.Name == "NoxReopenBtn" or ch.Name == "CyutsudHubReopen" or ch.Name == "CyutsudHubBanner" then return end
            pcall(function() ch.Parent = UIRoot end)
        end
        task.defer(function()
            local children = GUI:GetChildren()
            for i, ch in ipairs(children) do
                pcall(adopt, ch)
                if i % 8 == 0 then task.wait() end
            end
        end)
        GUI.ChildAdded:Connect(function(ch) task.defer(adopt, ch) end)
    end

    task.defer(function()
        pcall(function()
            local want = Config and (Config.get("defense_panel_visible", false) or Config.get("toggle:Defense Panel", false))
            if want and _G.DefensePanel and _G.DefensePanel.setVisible then
                task.wait(0.2)
                _G.DefensePanel.setVisible(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("admin_spammer_visible", false)
                    or Config.get("toggle:Admin Spammer", false)
            end
            local toggles = Config and Config.get("toggles", {}) or {}
            if type(toggles) == "table" and toggles["Admin Spammer"] then want = true end
            if want and _G.AdminSpammer and _G.AdminSpammer.set then
                task.wait(0.3)
                _G.AdminSpammer.set(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("command_cooldowns_visible", false)
                    or Config.get("toggle:Command Cooldowns", false)
            end
            local toggles = Config and Config.get("toggles", {}) or {}
            if type(toggles) == "table" and toggles["Command Cooldowns"] then want = true end
            if want and _G.CommandCooldowns and _G.CommandCooldowns.set then
                task.wait(0.3)
                _G.CommandCooldowns.set(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("quick_admin_panel_visible", false)
                    or Config.get("toggle:Quick Admin Panel", false)
            end
            local toggles = Config and Config.get("toggles", {}) or {}
            if type(toggles) == "table" and toggles["Quick Admin Panel"] then want = true end
            if want and _G.QuickAdminPanel and _G.QuickAdminPanel.set then
                task.wait(0.25)
                _G.QuickAdminPanel.set(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("booster_gui_visible", false)
                    or Config.get("toggle:Booster GUI", false)
            end
            local toggles = Config and Config.get("toggles", {}) or {}
            if type(toggles) == "table" and toggles["Booster GUI"] then want = true end
            if want and _G.BoosterGUI and _G.BoosterGUI.setVisible then
                task.wait(0.2)
                _G.BoosterGUI.setVisible(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = Config and (Config.get("isv2_panel_visible", false) or Config.get("toggle:Instant Steal Panel V2", false))
            if want and _G.InstantStealV2 and _G.InstantStealV2.set then
                task.wait(0.25)
                _G.InstantStealV2.set(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("actions_panel_visible", false)
                    or Config.get("toggle:Actions Panel", false)
            end
            if want and _G.ActionsPanel and _G.ActionsPanel.set then
                task.wait(0.15)
                _G.ActionsPanel.set(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("actions_panel_mobile_visible", false)
                    or Config.get("toggle:Actions Panel Mobile", false)
            end
            local toggles = Config and Config.get("toggles", {}) or {}
            if type(toggles) == "table" and toggles["Actions Panel Mobile"] then want = true end
            if want and _G.ActionsPanelMobile and _G.ActionsPanelMobile.set then
                task.wait(0.2)
                _G.ActionsPanelMobile.set(true)
            end
        end)
    end)

    task.defer(function()
        pcall(function()
            local want = false
            if Config then
                want = Config.get("allow_friends_visible", false)
                    or Config.get("toggle:Allow Friends", false)
            end
            local toggles = Config and Config.get("toggles", {}) or {}
            if type(toggles) == "table" and toggles["Allow Friends"] then want = true end
            if want and _G.AllowFriends and _G.AllowFriends.set then
                task.wait(0.2)
                _G.AllowFriends.set(true)
            end
        end)
    end)



do
    local UIS = game:GetService("UserInputService")
    local LP = game:GetService("Players").LocalPlayer

    local function colorsNear(a, b)
        if typeof(a) ~= "Color3" or typeof(b) ~= "Color3" then return false end
        return math.abs(a.R - b.R) < 0.04
           and math.abs(a.G - b.G) < 0.04
           and math.abs(a.B - b.B) < 0.04
    end

    local function getSecondary()
        local p = Color3.fromRGB(168, 85, 247)
        local s = Color3.fromRGB(245, 240, 255)
        if _G.coreTheme and typeof(_G.coreTheme.primary) == "Color3" then
            p = _G.coreTheme.primary
        end
        if _G.coreTheme and typeof(_G.coreTheme.secondary) == "Color3" then
            s = _G.coreTheme.secondary
        end
        if Theme and typeof(Theme.c1) == "Color3" then
            p = Theme.c1
        end
        if colorsNear(p, s) then
            return Color3.fromRGB(255, 255, 255)
        end
        return s
    end

    local function getConfig()
        if type(Config) == "table" and Config.get then return Config end
        return _G.CyutsudHubConfig
    end

    local handles = {}

    local function paintHandle(handle)
        if handle and handle.Parent then
            handle.TextColor3 = getSecondary()
        end
    end

    local function attachResizeTriangle(frame, opts)
        if not frame or not frame:IsA("GuiObject") then return end
        if handles[frame] and handles[frame].Parent then return end
        opts = opts or {}

        local minW = opts.minW or 140
        local minH = opts.minH or 90
        local maxW = opts.maxW or 1000
        local maxH = opts.maxH or 1000
        local saveKey = opts.saveKey

        local sz = frame.AbsoluteSize
        if sz.X < 60 or sz.Y < 40 then return end

        local old = frame:FindFirstChild("_CyutsudResizeTriangle")
        if old then pcall(function() old:Destroy() end) end

        local handle = Instance.new("TextButton")
        handle.Name = "_CyutsudResizeTriangle"
        handle.Size = UDim2.new(0, 18, 0, 18)
        handle.Position = UDim2.new(1, -2, 1, -2)
        handle.AnchorPoint = Vector2.new(1, 1)
        handle.BackgroundTransparency = 1
        handle.BorderSizePixel = 0
        handle.Text = "◢"
        handle.Font = Enum.Font.GothamBold
        handle.TextSize = 13
        handle.TextColor3 = getSecondary()
        handle.TextTransparency = 0.1
        handle.AutoButtonColor = false
        handle.ZIndex = 1000
        handle.Parent = frame

        pcall(function()
            local cfg = getConfig()
            if not cfg then return end
            local key = saveKey
            if not key then
                local sg = frame
                while sg and not sg:IsA("ScreenGui") do sg = sg.Parent end
                key = sg and sg.Name
            end
            if not key then return end
            local sizes = cfg.get and cfg.get("panelSizes", {}) or {}
            if type(sizes) ~= "table" then sizes = {} end
            local s = sizes[key]
            if type(s) == "table" and s[1] and s[2] and s[1] > 50 and s[2] > 40 then
                local h = s[2]
                if key == "PanelGui_Instant Steal V2" and h > 220 then h = 200 end
                frame.Size = UDim2.new(0, s[1], 0, h)
            end
            local positions = cfg.get and cfg.get("positions", {}) or {}
            if type(positions) == "table" then
                local p = positions[key]
                if type(p) == "table" and #p >= 4 then
                    frame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                end
            end
        end)

        pcall(function()
            frame.ClipsDescendants = true
            for _, d in ipairs(frame:GetDescendants()) do
                if d:IsA("ScrollingFrame") then
                    d.ClipsDescendants = true
                end
            end
        end)

        local dragging = false
        local startPos, startSize

        handle.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                if _G._FH_GuiLocked then return end
                dragging = true
                startPos = inp.Position
                startSize = frame.AbsoluteSize
                handle.TextTransparency = 0
            end
        end)

        UIS.InputChanged:Connect(function(inp)
            if not dragging then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
                and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            if not frame or not frame.Parent then return end
            if _G._FH_GuiLocked then
                dragging = false
                return
            end
            local dx = inp.Position.X - startPos.X
            local dy = inp.Position.Y - startPos.Y
            local newW = math.clamp(startSize.X + dx, minW, maxW)
            local newH = math.clamp(startSize.Y + dy, minH, maxH)
            frame.Size = UDim2.new(0, newW, 0, newH)
        end)

        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                if not dragging then return end
                dragging = false
                handle.TextTransparency = 0.1
                pcall(function()
                    local cfg = getConfig()
                    if not cfg or not frame then return end
                    local key = saveKey
                    if not key then
                        local sg = frame
                        while sg and not sg:IsA("ScreenGui") do sg = sg.Parent end
                        key = (sg and sg.Name) or ("resize_" .. (frame.Name or "panel"))
                    end
                    local sizes = cfg.get and cfg.get("panelSizes", {}) or {}
                    if type(sizes) ~= "table" then sizes = {} end
                    sizes[key] = { frame.Size.X.Offset, frame.Size.Y.Offset }
                    if cfg.set then cfg.set("panelSizes", sizes) end
                    local positions = cfg.get and cfg.get("positions", {}) or {}
                    if type(positions) ~= "table" then positions = {} end
                    positions[key] = {
                        frame.Position.X.Scale, frame.Position.X.Offset,
                        frame.Position.Y.Scale, frame.Position.Y.Offset,
                    }
                    if cfg.set then cfg.set("positions", positions) end
                    if cfg.flush then pcall(function() cfg.flush() end) end
                    if cfg.save then pcall(function() cfg.save() end) end
                end)
            end
        end)

        handles[frame] = handle
        frame.Destroying:Connect(function()
            handles[frame] = nil
        end)
    end

    local function getMainFrame(gui)
        if not gui then return nil end
        local f = gui:FindFirstChild("Frame") or gui:FindFirstChild("Root")
        if f and f:IsA("GuiObject") then
            local a = f.AbsoluteSize
            if a.X >= 80 and a.Y >= 50 then return f end
        end
        local best, bestA = nil, 0
        for _, c in ipairs(gui:GetChildren()) do
            if c:IsA("GuiObject") and not c:IsA("ScreenGui") then
                local a = (c.AbsoluteSize.X * c.AbsoluteSize.Y) or 0
                if a > bestA and c.AbsoluteSize.X >= 80 and c.AbsoluteSize.Y >= 50 then
                    bestA = a
                    best = c
                end
            end
        end
        return best
    end

    local PANEL_NAMES = {
        ["PanelGui_StealTarget"] = true,
        ["PanelGui_Command Cooldowns"] = true,
        ["PanelGui_Booster"] = true,
        ["PanelGui_Actions"] = true,
        ["PanelGui_ActionsMobile"] = true,
        ["PanelGui_Instant Steal"] = true,
        ["PanelGui_Instant Steal V2"] = true,
        ["PanelGui_Admin Panel"] = true,
        ["PanelGui_Cyutsud Defense"] = true,
        ["PanelGui_Defense"] = true,
        ["PanelGui_Cyutsud Admin Spammer"] = true,
        ["PanelGui_CyutsudQuickPanel"] = true,
        ["PanelGui_FluxQuickPanel"] = true,
        ["PanelGui_Flux Admin Spammer"] = true,
        ["PanelGui_Flux Defense"] = true,
        StealProgressScreenGui = true,
    }

    local SKIP = {
        CyutsudHubReopen = true,
        FluxHubReopen = true,
    }

    local function scanAndAttach()
        local parents = {}
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then table.insert(parents, pg) end
        end)
        pcall(function()
            if type(gethui) == "function" then
                local h = gethui()
                if h then table.insert(parents, h) end
            end
        end)
        pcall(function()
            table.insert(parents, game:GetService("CoreGui"))
        end)

        for _, parent in ipairs(parents) do
            for _, gui in ipairs(parent:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    local name = gui.Name
                    if SKIP[name] then continue end

                    -- Main hub window (CyutsudHub ScreenGui -> Root)
                    if name == "CyutsudHub" or name == "FluxHub" then
                        local root = gui:FindFirstChild("Root")
                        if root and root:IsA("GuiObject") then
                            attachResizeTriangle(root, {
                                minW = 280, minH = 260, maxW = 900, maxH = 900,
                                saveKey = "CyutsudHub_Root",
                            })
                        end
                        continue
                    end

                    if PANEL_NAMES[name] or name:find("PanelGui_") == 1 then
                        local frame = getMainFrame(gui)
                        if frame then
                            if name == "StealProgressScreenGui" then
                                local cont = gui:FindFirstChild("Container") or frame
                                attachResizeTriangle(cont, { saveKey = name })
                            else
                                attachResizeTriangle(frame, { saveKey = name })
                            end
                        end
                    end
                end
            end
        end
    end

    if type(_G.CyutsudHubThemeListeners) ~= "table" then
        _G.CyutsudHubThemeListeners = {}
    end
    table.insert(_G.CyutsudHubThemeListeners, function()
        for _, h in pairs(handles) do
            paintHandle(h)
        end
    end)

    local oldBroadcast = _G._FluxBroadcastTheme
    _G._FluxBroadcastTheme = function(...)
        if type(oldBroadcast) == "function" then
            pcall(oldBroadcast, ...)
        end
        for _, h in pairs(handles) do
            paintHandle(h)
        end
    end

    _G._CyutsudAttachResize = attachResizeTriangle
    _G._FluxAttachResize = attachResizeTriangle

    task.spawn(function()
        for i = 1, 35 do
            task.wait(0.3)
            pcall(scanAndAttach)
        end
    end)

    local function watch(parent)
        if not parent then return end
        pcall(function()
            parent.ChildAdded:Connect(function(child)
                task.wait(0.2)
                if child:IsA("ScreenGui") then
                    pcall(scanAndAttach)
                end
            end)
        end)
    end

    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
    watch(pg)
    pcall(function()
        if type(gethui) == "function" then watch(gethui()) end
    end)
    pcall(function()
        watch(game:GetService("CoreGui"))
    end)
end


    end)

end)

-- Safe visual adjustments: preserve all text objects and their layout.
do
    local targetNames = {
        ["PanelGui_Defense"] = true,
        ["PanelGui_Cyutsud Defense"] = true,
        ["PanelGui_StealTarget"] = true,
        ["PanelGui_Booster"] = true,
        ["PanelGui_Cyutsud Admin Spammer"] = true,
        ["PanelGui_Flux Admin Spammer"] = true,
        ["AdminSpammerStandalone"] = true,
        ["PanelGui_Instant Steal V2"] = true,
        ["PanelGui_Actions"] = true,
        ["PanelGui_ActionsMobile"] = true,
        ["CyutsudHub"] = true,
    }

    local function adjustGui(gui)
        if not gui or not gui:IsA("ScreenGui") or not targetNames[gui.Name] then return end
        for _, obj in ipairs(gui:GetDescendants()) do
            -- Do not destroy UI instances: some scripts may use these as containers.
            if obj:IsA("Frame") and (obj.Name == "HubAccent" or obj.Name == "Accent" or obj.Name == "CyutsudMainAccentBar") then
                pcall(function()
                    obj.BackgroundTransparency = 1
                    if obj:IsA("Frame") then obj.BorderSizePixel = 0 end
                end)
            end

            -- Center title text only; do not change position, size, anchor, or visibility.
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local parent = obj.Parent
                local parentName = parent and string.lower(parent.Name) or ""
                local ownName = string.lower(obj.Name)
                local isTitle = ownName:find("title", 1, true)
                    or ownName:find("header", 1, true)
                    or ownName:find("heading", 1, true)
                    or parentName == "titlebar"
                    or parentName == "header"
                    or parentName == "topbar"
                    or parentName == "cdhdr"
                if isTitle then
                    pcall(function()
                        obj.TextXAlignment = Enum.TextXAlignment.Center
                        obj.TextYAlignment = Enum.TextYAlignment.Center
                    end)
                end
            end
        end
    end

    task.spawn(function()
        for _ = 1, 40 do
            pcall(function()
                local players = game:GetService("Players")
                local lp = players.LocalPlayer
                local pg = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
                if pg then for _, gui in ipairs(pg:GetChildren()) do adjustGui(gui) end end
                if type(gethui) == "function" then
                    local h = gethui()
                    if h then for _, gui in ipairs(h:GetChildren()) do adjustGui(gui) end end
                end
                local cg = game:GetService("CoreGui")
                for _, gui in ipairs(cg:GetChildren()) do adjustGui(gui) end
            end)
            task.wait(0.5)
        end
    end)
end


-- Keep only the Steal Target and Defense panel headings centered.
do
    local function centerTargetHeadings(root)
        if not root then return end
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local txt = string.lower((obj.Text or ""):gsub("%s+", " "):match("^%s*(.-)%s*$") or "")
                local parent = obj.Parent
                local parentName = parent and string.lower(parent.Name) or ""
                local gui = obj:FindFirstAncestorOfClass("ScreenGui")
                local guiName = gui and gui.Name or ""
                local isTargetTitle = (txt == "steal target" and (guiName == "PanelGui_StealTarget" or parentName == "titlebar"))
                    or ((txt == "defense" or txt == "defence") and (guiName == "PanelGui_Cyutsud Defense" or guiName == "PanelGui_Defense" or parentName == "titlebar"))
                if isTargetTitle then
                    pcall(function()
                        obj.TextXAlignment = Enum.TextXAlignment.Center
                        obj.TextYAlignment = Enum.TextYAlignment.Center
                        obj.Size = UDim2.new(1, 0, 1, 0)
                        obj.Position = UDim2.new(0, 0, 0, 0)
                    end)
                end
            end
        end
    end
    task.spawn(function()
        for _ = 1, 60 do
            pcall(function()
                local Players = game:GetService("Players")
                local lp = Players.LocalPlayer
                local pg = lp and lp:FindFirstChild("PlayerGui")
                if pg then centerTargetHeadings(pg) end
                if type(gethui) == "function" then centerTargetHeadings(gethui()) end
                centerTargetHeadings(game:GetService("CoreGui"))
            end)
            task.wait(0.5)
        end
    end)
end
