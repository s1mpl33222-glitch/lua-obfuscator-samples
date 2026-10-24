-- =====================================================================
-- ArHub Loader v8.3 | Classic layout + Cinematic intro + Auto-Unload
-- Roblox Luau (executor)  |  Toggle menu: RightShift
-- After a script executes successfully the loader fully unloads
-- (GUIs destroyed, every connection + loop stopped) so it costs 0 FPS.
-- =====================================================================

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local RunService   = game:GetService("RunService")
local StarterGui   = game:GetService("StarterGui")

local lp = Players.LocalPlayer
while not lp do task.wait() lp = Players.LocalPlayer end

-- single instance: unload any previous copy first
local genv = (getgenv and getgenv()) or _G
if genv.ArHubUnload then pcall(genv.ArHubUnload) end

-- =====================================================================
-- CONFIG
-- =====================================================================
local GAMES = {
    { name = "BloxStrike", url = "https://pastefy.app/p2i1jxPM/raw", match = {"bloxstrike", "blox strike"} },
    { name = "Dead Rails", url = "https://pastefy.app/LXM27HWc/raw", match = {"dead rails", "deadrails"} },
}
local DISCORD_URL    = "https://discord.gg/arhub"   -- << change to your invite
local VERSION        = "v8.3"
local TOGGLE_KEY     = Enum.KeyCode.RightShift
local AUTO_UNLOAD    = true    -- unload the loader after a successful execute
local UNLOAD_DELAY   = 0.9     -- seconds to show the "Loaded" toast first

-- =====================================================================
-- LIFETIME  (everything that can leak is tracked here)
-- =====================================================================
local running, unloaded = true, false
local conns, guis = {}, {}
local function bind(conn) table.insert(conns, conn) return conn end

-- =====================================================================
-- THEME + HELPERS
-- =====================================================================
local BODY, BOLD, BLACK, MONO = Enum.Font.Gotham, Enum.Font.GothamBold, Enum.Font.GothamBlack, Enum.Font.Code
local Q, D = Enum.EasingStyle, Enum.EasingDirection

local C = {
    bg = Color3.fromRGB(9, 9, 12),        bgPanel = Color3.fromRGB(16, 16, 20),
    card = Color3.fromRGB(22, 22, 27),    cardHover = Color3.fromRGB(30, 28, 34),
    accent = Color3.fromRGB(200, 16, 30), accentGlow = Color3.fromRGB(255, 45, 55),
    ember = Color3.fromRGB(255, 120, 40),
    text = Color3.fromRGB(240, 240, 245), dim = Color3.fromRGB(130, 130, 142),
    success = Color3.fromRGB(40, 210, 90), line = Color3.fromRGB(44, 44, 54),
    discord = Color3.fromRGB(88, 101, 242),
}

local function tween(inst, t, props, style, dir)
    local tw = TweenService:Create(inst, TweenInfo.new(t, style or Q.Quint, dir or D.Out), props)
    tw:Play()
    return tw
end
local function corner(inst, px)
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, px or 6) c.Parent = inst return c
end
local function stroke(inst, color, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color, s.Thickness, s.Transparency = color, thick or 1, transp or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end
local function grad(inst, seq, rot)
    local g = Instance.new("UIGradient") g.Color = seq g.Rotation = rot or 90 g.Parent = inst return g
end
local function mkBox(parent, props, class)
    local f = Instance.new(class or "Frame")
    f.BorderSizePixel = 0
    f.BackgroundColor3 = C.bg
    for k, v in pairs(props or {}) do f[k] = v end
    f.Parent = parent
    return f
end
local function mkText(parent, str, size, color, font, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency, l.BorderSizePixel = 1, 0
    l.Text, l.TextSize, l.TextColor3, l.Font = str, size, color, font or BODY
    l.TextXAlignment = Enum.TextXAlignment.Left
    for k, v in pairs(props or {}) do l[k] = v end
    l.Parent = parent
    return l
end
local function mkBtn(parent, props)
    local b = Instance.new("TextButton")
    b.BackgroundTransparency, b.BorderSizePixel, b.AutoButtonColor, b.Text = 1, 0, false, ""
    for k, v in pairs(props or {}) do b[k] = v end
    b.Parent = parent
    return b
end
local function randName() return (HttpService:GenerateGUID(false):gsub("%-", "")):sub(1, 12) end

local function mountGui(gui)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local ok = pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not ok or not gui.Parent then gui.Parent = lp:WaitForChild("PlayerGui") end
    table.insert(guis, gui)
end

local SFX_ID = 9114225343
local function sfx(vol, pitch)
    if unloaded then return end
    pcall(function()
        local s = Instance.new("Sound", SoundService)
        s.SoundId = "rbxassetid://" .. SFX_ID
        s.Volume, s.PlaybackSpeed = vol or 0.3, pitch or 1
        s:Play()
        task.delay(3, function() if s and s.Parent then s:Destroy() end end)
    end)
end

local function makeDraggable(handle, target, onTap)
    pcall(function() handle.Active = true end)
    local dragging, moved, start, origin, dragInput = false, false, nil, nil, nil
    bind(handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, moved, start, origin, dragInput = true, false, i.Position, target.Position, i
        end
    end))
    bind(UIS.InputChanged:Connect(function(i)
        if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = i.Position - start
            if d.Magnitude > 8 then moved = true end
            if moved then
                target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
            end
        end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            if not moved and onTap then onTap() end
        end
    end))
end

local function mkGlow(parent, color, size, layers, z)
    local holder = mkBox(parent, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z })
    for i = 1, layers do
        local f = mkBox(holder, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1 - (i - 1) / layers, 1 - (i - 1) / layers), BackgroundColor3 = color, BackgroundTransparency = 0.95, ZIndex = z })
        corner(f, 999)
    end
    return holder
end

local function emberField(parent, z, isAlive, rate)
    task.spawn(function()
        while isAlive() do
            local x = math.random()
            local e = mkBox(parent, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(x, 1.05),
                Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4)),
                BackgroundColor3 = (math.random() < 0.5) and C.ember or C.accentGlow, BackgroundTransparency = 0.2, ZIndex = z })
            corner(e, 4)
            local dur = 3 + math.random() * 4
            tween(e, dur, { Position = UDim2.fromScale(math.clamp(x + (math.random() - 0.5) * 0.35, 0, 1), -0.05), BackgroundTransparency = 1 }, Q.Sine)
            task.delay(dur + 0.1, function() if e.Parent then e:Destroy() end end)
            task.wait(rate * (0.5 + math.random()))
        end
    end)
end

-- one shared RenderStepped for every spinning border (disconnected on unload)
local spinners = {}
local function addSpinner(g, speed) table.insert(spinners, { g = g, s = speed or 60 }) end
bind(RunService.RenderStepped:Connect(function()
    local t = os.clock()
    for i = #spinners, 1, -1 do
        local sp = spinners[i]
        if sp.g.Parent then sp.g.Rotation = (t * sp.s) % 360 else table.remove(spinners, i) end
    end
end))

local function pressFx(btn)
    local sc = Instance.new("UIScale")
    sc.Parent = btn
    btn.MouseButton1Down:Connect(function() tween(sc, 0.08, { Scale = 0.96 }, Q.Quad) end)
    btn.MouseButton1Up:Connect(function() tween(sc, 0.25, { Scale = 1 }, Q.Back) end)
    btn.MouseLeave:Connect(function() tween(sc, 0.2, { Scale = 1 }, Q.Quad) end)
end

local function nudge(obj, px)
    local p = obj.Position
    task.spawn(function()
        for i = 1, 6 do
            obj.Position = UDim2.new(p.X.Scale, p.X.Offset + (i % 2 == 0 and px or -px) * (1 - i / 7), p.Y.Scale, p.Y.Offset)
            task.wait(0.03)
        end
        obj.Position = p
    end)
end

-- =====================================================================
-- CINEMATIC INTRO  (kept from v8.0)  -  click anywhere to skip
-- =====================================================================
local function playIntro(onDone)
    local gui = Instance.new("ScreenGui")
    gui.Name = randName()
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999
    pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
    mountGui(gui)

    -- hide Roblox's own UI (topbar, chat, etc.) so the intro covers the WHOLE screen
    local coreBackup = {}
    pcall(function()
        for _, t in ipairs(Enum.CoreGuiType:GetEnumItems()) do
            if t ~= Enum.CoreGuiType.All then coreBackup[t] = StarterGui:GetCoreGuiEnabled(t) end
        end
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end)
    local function restoreCore()
        pcall(function()
            for t, v in pairs(coreBackup) do StarterGui:SetCoreGuiEnabled(t, v) end
        end)
    end

    local skipped, alive, finished = false, true, false
    local bootConn, keyConn

    -- interruptible wait: ONLY for the main timeline. Looping effects must use task.wait,
    -- otherwise a skip makes them spin without yielding and freezes the client.
    local function w(t)
        local e = os.clock() + t
        while not skipped and running and os.clock() < e do task.wait() end
    end

    -- oversized black cover (behind everything) + the animated stage
    local cover = mkBox(gui, { Position = UDim2.fromOffset(-120, -120), Size = UDim2.new(1, 240, 1, 240),
        BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 0 })
    local stage = mkBox(gui, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 1 }, "CanvasGroup")
    local world = mkBox(stage, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, ZIndex = 2 })
    local dolly = Instance.new("UIScale")   -- slow cinematic push-in
    dolly.Parent = world
    tween(dolly, 8, { Scale = 1.1 }, Q.Sine)

    local function finish(fast)
        if finished then return end
        finished, alive = true, false
        if bootConn then bootConn:Disconnect() end
        if keyConn then keyConn:Disconnect() end
        local t = fast and 0.2 or 0.6
        tween(stage, t, { GroupTransparency = 1 })
        tween(cover, t, { BackgroundTransparency = 1 })
        task.delay(t + 0.05, function()
            restoreCore()
            if gui.Parent then gui:Destroy() end
            if onDone then onDone() end
        end)
    end
    local function bail() if skipped or not running then finish(true) return true end return false end

    local skipBtn = mkBtn(stage, { Size = UDim2.fromScale(1, 1), ZIndex = 600 })
    skipBtn.MouseButton1Click:Connect(function() skipped = true end)
    keyConn = UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space or i.KeyCode == Enum.KeyCode.Return then skipped = true end
    end)
    local skipHint = mkText(stage, "TAP TO SKIP", 9, C.dim, MONO, { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -14),
        Size = UDim2.fromOffset(200, 12), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 550, TextTransparency = 1 })
    tween(skipHint, 1, { TextTransparency = 0.5 })

    -- ------------------------------------------------------------------
    -- atmosphere layers
    -- ------------------------------------------------------------------
    local fx = mkBox(world, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.46, -22), Size = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1, ZIndex = 3 })
    local bloom = mkGlow(fx, C.accent, 900, 16, 3)
    bloom.Size = UDim2.fromOffset(0, 0)

    local rays = {}   -- slowly rotating light fan behind the logo
    for k = 0, 2 do
        local ray = mkBox(fx, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(1700, 34),
            Rotation = k * 60, BackgroundColor3 = C.accentGlow, BackgroundTransparency = 1, ZIndex = 4 })
        local g = grad(ray, ColorSequence.new(C.accentGlow, C.accentGlow), 0)
        g.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1) })
        tween(ray, 40, { Rotation = k * 60 + 360 }, Q.Linear)
        rays[#rays + 1] = ray
    end

    -- falling red hex rain (fades in during the boot phase)
    local rain = mkBox(world, { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 6, GroupTransparency = 1 }, "CanvasGroup")
    local COLS = 16
    for i = 1, COLS do
        local lines = {}
        for n = 1, 30 do lines[n] = string.format("%02X", math.random(0, 255)) end
        local xs = (i - 0.5) / COLS
        local col = mkText(rain, table.concat(lines, "\n"), 10, C.accent, MONO, { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(xs, -1),
            Size = UDim2.fromOffset(20, 600), TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Center,
            TextTransparency = 0.45, ZIndex = 6 })
        task.spawn(function()
            task.wait(math.random() * 2)
            while alive do
                local dur = 3 + math.random() * 3
                col.Position = UDim2.fromScale(xs, -0.9)
                tween(col, dur, { Position = UDim2.fromScale(xs, 1.05) }, Q.Linear)
                task.wait(dur)
            end
        end)
    end

    for _, side in ipairs({ 0, 1 }) do
        local v = mkBox(world, { AnchorPoint = Vector2.new(side, 0), Position = UDim2.fromScale(side, 0), Size = UDim2.fromScale(0.3, 1),
            BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 20 })
        local g = Instance.new("UIGradient")
        g.Rotation = side == 0 and 0 or 180
        g.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(1, 1) })
        g.Parent = v
    end
    local barTop = mkBox(stage, { Size = UDim2.fromScale(1, 0), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 400 })
    local barBot = mkBox(stage, { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 400 })

    local beam = mkBox(world, { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.93, ZIndex = 19 })
    task.spawn(function()
        while alive do
            beam.Position = UDim2.fromScale(0, -0.02)
            tween(beam, 2.4, { Position = UDim2.fromScale(0, 1.02) }, Q.Linear)
            task.wait(2.5)
        end
    end)

    local grain = {}   -- film grain
    for i = 1, 50 do
        grain[i] = mkBox(world, { Size = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.88, ZIndex = 18 })
    end
    task.spawn(function()
        while alive do
            for _, g in ipairs(grain) do g.Position = UDim2.fromScale(math.random(), math.random()) end
            task.wait(0.07)
        end
    end)
    emberField(world, 5, function() return alive and running end, 0.1)

    -- ------------------------------------------------------------------
    -- fx helpers
    -- ------------------------------------------------------------------
    local function shake(strength, dur)
        task.spawn(function()
            local e = os.clock() + dur
            while os.clock() < e and alive do
                local k = (e - os.clock()) / dur
                world.Position = UDim2.new(0.5, math.random(-strength, strength) * k, 0.5, math.random(-strength, strength) * k)
                task.wait()
            end
            world.Position = UDim2.fromScale(0.5, 0.5)
        end)
    end
    local glitchCols = { C.accentGlow, Color3.fromRGB(0, 235, 255), Color3.new(1, 1, 1) }
    local function glitchBurst(n)
        for _ = 1, n do
            local f = mkBox(world, { Position = UDim2.fromScale(math.random() * 0.4 - 0.1, math.random()),
                Size = UDim2.fromScale(0.4 + math.random() * 0.7, 0.004 + math.random() * 0.02),
                BackgroundColor3 = glitchCols[math.random(1, 3)], BackgroundTransparency = 0.45, ZIndex = 300 })
            task.delay(0.04 + math.random() * 0.08, function() if f.Parent then f:Destroy() end end)
        end
    end
    local flash = mkBox(stage, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, ZIndex = 500 })
    local function flashFx(a, t) flash.BackgroundTransparency = a tween(flash, t, { BackgroundTransparency = 1 }) end
    local function strobe(n)
        task.spawn(function()
            for _ = 1, n do
                if not alive then return end
                flash.BackgroundTransparency = 0.8
                task.wait(0.04)
                flash.BackgroundTransparency = 1
                task.wait(0.06 + math.random() * 0.08)
            end
        end)
    end
    local function radial(n, color, lmin, lmax)   -- crack / light lines bursting from the logo
        for i = 1, n do
            local ln = mkBox(fx, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 2),
                Rotation = (i / n) * 180 + math.random(-6, 6), BackgroundColor3 = color, ZIndex = 15 })
            tween(ln, 0.35, { Size = UDim2.fromOffset(math.random(lmin, lmax), 2) }, Q.Quart)
            task.delay(0.2, function() if ln.Parent then tween(ln, 0.45, { BackgroundTransparency = 1 }) end end)
            task.delay(0.8, function() if ln.Parent then ln:Destroy() end end)
        end
    end
    local function ringFx(delayT, thick)
        task.delay(delayT, function()
            if not alive then return end
            local ring = mkBox(fx, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 1, ZIndex = 60 })
            corner(ring, 999)
            local rs = stroke(ring, Color3.new(1, 1, 1), thick, 0)
            tween(ring, 0.9, { Size = UDim2.fromOffset(2200, 2200) }, Q.Quart)
            tween(rs, 0.9, { Transparency = 1 })
            task.delay(1, function() if ring.Parent then ring:Destroy() end end)
        end)
    end
    local function scramble(label, final, dur)   -- text decodes left -> right
        task.spawn(function()
            local chars, steps = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#@%&", 14
            for s = 1, steps do
                if not alive then return end
                local out = {}
                for i = 1, #final do
                    local c = final:sub(i, i)
                    if c == " " or s / steps > i / #final then out[i] = c
                    else local r = math.random(1, #chars) out[i] = chars:sub(r, r) end
                end
                label.Text = table.concat(out)
                task.wait(dur / steps)
            end
            label.Text = final
        end)
    end

    -- ------------------------------------------------------------------
    -- brand block (logo + tagline + drips + blood splatter)
    -- ------------------------------------------------------------------
    local brand = mkBox(world, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.46), Size = UDim2.fromOffset(340, 140),
        BackgroundTransparency = 1, ZIndex = 10 })
    local logo = mkBox(brand, { Size = UDim2.new(1, 0, 0, 96), BackgroundTransparency = 1, ZIndex = 10 })
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Parent = logo

    local word, letters = "ARHUB", {}
    for i = 1, #word do
        local ch = word:sub(i, i)
        local cell = mkBox(logo, { Size = UDim2.fromOffset(68, 96), BackgroundTransparency = 1, LayoutOrder = i, ZIndex = 10 })
        local function lbl(color, z)
            return mkText(cell, ch, 76, color, Enum.Font.Creepster, { Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, -1.5),
                TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = z, TextTransparency = 1 })
        end
        local gR, gC, main = lbl(Color3.fromRGB(255, 0, 40), 11), lbl(Color3.fromRGB(0, 230, 255), 11), lbl(Color3.new(1, 1, 1), 12)
        grad(main, ColorSequence.new(Color3.fromRGB(255, 85, 95), Color3.fromRGB(110, 0, 10)), 90)
        local st = stroke(main, Color3.fromRGB(30, 0, 2), 2, 1)
        letters[i] = { gR = gR, gC = gC, main = main, st = st }
    end

    local function jitter(n, amt)
        task.spawn(function()
            for _ = 1, n do
                if not alive then return end
                for _, l in ipairs(letters) do
                    l.gR.TextTransparency, l.gC.TextTransparency = 0.35, 0.35
                    l.gR.Position = UDim2.fromOffset(-math.random(2, amt), math.random(-2, 2))
                    l.gC.Position = UDim2.fromOffset(math.random(2, amt), math.random(-2, 2))
                end
                task.wait(0.04)
            end
            for _, l in ipairs(letters) do l.gR.TextTransparency, l.gC.TextTransparency = 1, 1 end
        end)
    end
    local function splat(i)
        for _ = 1, 3 do
            local s = math.random(6, 16)
            local d = mkBox(brand, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((i - 0.5) * 68 + math.random(-45, 45), math.random(15, 95)),
                Size = UDim2.fromOffset(0, 0), BackgroundColor3 = Color3.fromRGB(150, 0, 12), BackgroundTransparency = 0.25, ZIndex = 8 })
            corner(d, 999)
            tween(d, 0.25, { Size = UDim2.fromOffset(s, s) }, Q.Back)
            task.delay(1.4, function() if d.Parent then tween(d, 0.6, { BackgroundTransparency = 1 }) end end)
            task.delay(2.1, function() if d.Parent then d:Destroy() end end)
        end
    end
    local function slam(l, i, delayT)
        task.delay(delayT, function()
            if not alive then return end
            tween(l.main, 0.5, { Position = UDim2.fromScale(0, 0), TextTransparency = 0 }, Q.Bounce, D.Out)
            tween(l.st, 0.3, { Transparency = 0.15 })
            task.delay(0.2, function()
                if not alive then return end
                l.gR.Position, l.gC.Position = UDim2.fromScale(0, 0), UDim2.fromScale(0, 0)
                shake(8, 0.3) glitchBurst(3) splat(i) flashFx(0.9, 0.15)
                sfx(0.2, 0.5 + i * 0.04)
            end)
        end)
    end

    local tagline = mkText(brand, "", 12, C.dim, BOLD, { Position = UDim2.fromOffset(0, 106), Size = UDim2.new(1, 0, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 10 })
    local lineL = mkBox(brand, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(0.25, 0, 0, 114), Size = UDim2.fromOffset(0, 1), BackgroundColor3 = C.accent, ZIndex = 10 })
    local lineR = mkBox(brand, { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0.75, 0, 0, 114), Size = UDim2.fromOffset(0, 1), BackgroundColor3 = C.accent, ZIndex = 10 })
    local function drip(i, len)
        local d = mkBox(brand, { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset((i - 0.5) * 68, 78), Size = UDim2.fromOffset(4, 0),
            BackgroundColor3 = Color3.fromRGB(120, 0, 10), ZIndex = 9 })
        corner(d, 3)
        tween(d, 1.2, { Size = UDim2.fromOffset(4, len) }, Q.Sine, D.In)
        task.delay(1.6, function() if d.Parent then tween(d, 0.5, { BackgroundTransparency = 1 }) end end)
    end

    -- ------------------------------------------------------------------
    -- boot terminal
    -- ------------------------------------------------------------------
    local boot = mkBox(world, { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0.52), Size = UDim2.fromOffset(340, 142),
        BackgroundTransparency = 1, ZIndex = 30, GroupTransparency = 1 }, "CanvasGroup")
    local bootLines = { "mounting ar_engine core", "resolving game signatures", "handshake // arhub network", "compiling ui shaders", "calibrating renderer" }
    local lineLbls = {}
    for i = 1, #bootLines do
        lineLbls[i] = mkText(boot, "", 11, C.dim, MONO, { Position = UDim2.fromOffset(0, (i - 1) * 16), Size = UDim2.new(1, 0, 0, 14), RichText = true, ZIndex = 31 })
    end
    local barBg = mkBox(boot, { Position = UDim2.fromOffset(0, 90), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.bgPanel, ZIndex = 31 })
    corner(barBg, 3)
    stroke(barBg, C.line, 1, 0.4)
    local barFill = mkBox(barBg, { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accent, ZIndex = 32 })
    corner(barFill, 3)
    local shimmer = grad(barFill, ColorSequence.new({ ColorSequenceKeypoint.new(0, C.accent), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 150)),
        ColorSequenceKeypoint.new(1, C.accent) }), 0)
    task.spawn(function()
        while alive do
            shimmer.Offset = Vector2.new(-1, 0)
            tween(shimmer, 0.9, { Offset = Vector2.new(1, 0) }, Q.Sine, D.InOut)
            task.wait(1)
        end
    end)
    local statusLbl = mkText(boot, "AR ENGINE  ·  POWERING UP", 10, C.dim, MONO, { Position = UDim2.fromOffset(0, 104), Size = UDim2.new(0.8, 0, 0, 14), ZIndex = 31 })
    local pctLbl = mkText(boot, "0%", 10, C.text, MONO, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 104), Size = UDim2.fromOffset(60, 14),
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 31 })
    local welcomeLbl = mkText(boot, "", 10, C.accentGlow, MONO, { Position = UDim2.fromOffset(0, 126), Size = UDim2.new(1, 0, 0, 14), ZIndex = 31 })
    bootConn = RunService.RenderStepped:Connect(function()
        pctLbl.Text = math.floor(barFill.Size.X.Scale * 100 + 0.5) .. "%"
    end)

    -- ------------------------------------------------------------------
    -- timeline
    -- ------------------------------------------------------------------
    task.spawn(function()
        w(0.3) if bail() then return end
        tween(barTop, 1, { Size = UDim2.fromScale(1, 0.09) }, Q.Quart)
        tween(barBot, 1, { Size = UDim2.fromScale(1, 0.09) }, Q.Quart)

        for _ = 1, 2 do   -- heartbeat
            tween(bloom, 0.12, { Size = UDim2.fromOffset(280, 280) }, Q.Quad) sfx(0.28, 0.4)
            w(0.14)
            tween(bloom, 0.4, { Size = UDim2.fromOffset(0, 0) }, Q.Quad)
            w(0.32)
        end
        if bail() then return end

        strobe(3)
        tween(bloom, 2.5, { Size = UDim2.fromOffset(900, 900) }, Q.Sine)
        glitchBurst(5)
        for i, l in ipairs(letters) do slam(l, i, (i - 1) * 0.11) end
        w(1.15) if bail() then return end

        -- impact
        flashFx(0.45, 0.45) shake(16, 0.6) jitter(10, 8) glitchBurst(10) sfx(0.35, 0.4)
        radial(12, Color3.new(1, 1, 1), 260, 520)
        for _, r in ipairs(rays) do tween(r, 1.2, { BackgroundTransparency = 0 }, Q.Sine) end
        for _, i in ipairs({ 2, 3, 5 }) do drip(i, math.random(30, 60)) end
        scramble(tagline, "S C R I P T   H U B", 0.8)
        tween(lineL, 0.7, { Size = UDim2.fromOffset(40, 1) }, Q.Quart)
        tween(lineR, 0.7, { Size = UDim2.fromOffset(40, 1) }, Q.Quart)
        task.spawn(function()
            for _ = 1, 3 do
                w(0.3)
                if not alive then return end
                jitter(3, 4) glitchBurst(2)
            end
        end)
        w(1.4) if bail() then return end

        -- logo lifts, terminal + hex rain arrive
        tween(brand, 0.8, { Position = UDim2.fromScale(0.5, 0.3) }, Q.Quart, D.InOut)
        tween(fx, 0.8, { Position = UDim2.new(0.5, 0, 0.3, -22) }, Q.Quart, D.InOut)
        w(0.55) if bail() then return end
        tween(boot, 0.4, { GroupTransparency = 0 })
        tween(rain, 1, { GroupTransparency = 0.7 })
        for i, txt in ipairs(bootLines) do
            local lbl = lineLbls[i]
            for n = 1, #txt do
                if skipped or not running then break end
                lbl.Text = "<font color=\"#c8101e\">&gt;</font> " .. txt:sub(1, n)
                task.wait(0.012)
            end
            if bail() then return end
            lbl.Text = "<font color=\"#c8101e\">&gt;</font> " .. txt .. "  <font color=\"#28d25a\">OK</font>"
            tween(barFill, 0.3, { Size = UDim2.new(i / #bootLines, 0, 1, 0) }, Q.Quad)
            sfx(0.08, 1.15 + i * 0.07)
            glitchBurst(1)
            w(0.14)
        end
        if bail() then return end

        statusLbl.Text, statusLbl.TextColor3 = "READY", C.success
        shimmer.Enabled = false
        barFill.BackgroundColor3 = C.success
        sfx(0.28)
        local greet = "ACCESS GRANTED  ·  WELCOME " .. string.upper(lp.DisplayName)
        for n = 1, #greet do
            if skipped or not running then break end
            welcomeLbl.Text = greet:sub(1, n)
            task.wait(0.015)
        end
        w(0.3) if bail() then return end

        -- finale
        ringFx(0, 5) ringFx(0.15, 3) ringFx(0.3, 2)
        radial(16, C.accentGlow, 400, 900)
        flashFx(0, 0.8) shake(12, 0.45) glitchBurst(8) sfx(0.4, 0.8)
        tween(dolly, 0.7, { Scale = 1.5 }, Q.Quart, D.In)
        w(0.55)
        finish(false)
    end)
end

-- =====================================================================
-- MAIN UI  (classic ArHub layout: 3 tabs, expanding game cards, FAB)
-- =====================================================================
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "ArHubLoader"
loaderGui.ResetOnSpawn = false
loaderGui.IgnoreGuiInset = true
loaderGui.DisplayOrder = 998
loaderGui.Enabled = false
mountGui(loaderGui)

local menuOpen, introDone = false, false
local W, H = 420, 460

-- ambient red backdrop (pulses like the original, but only while the menu is open)
local backdrop = mkBox(loaderGui, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.accent, BackgroundTransparency = 1, ZIndex = 0 })
grad(backdrop, ColorSequence.new({ ColorSequenceKeypoint.new(0, C.accent), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(6, 6, 8)),
    ColorSequenceKeypoint.new(1, C.accent) }), 45)
task.spawn(function()
    while running do
        if menuOpen then
            tween(backdrop, 3.5, { BackgroundTransparency = 0.86 }, Q.Sine, D.InOut)
            task.wait(3.5)
            if menuOpen then tween(backdrop, 3.5, { BackgroundTransparency = 0.7 }, Q.Sine, D.InOut) end
            task.wait(3.5)
        else
            task.wait(0.3)
        end
    end
end)

-- ---------- window ----------
local window = mkBox(loaderGui, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H),
    BackgroundColor3 = C.bg, ZIndex = 1, Visible = false, GroupTransparency = 1 }, "CanvasGroup")
corner(window, 16)
local winStroke = stroke(window, Color3.new(1, 1, 1), 1.6, 0)
do
    local sg = Instance.new("UIGradient")
    sg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.accentGlow), ColorSequenceKeypoint.new(0.35, Color3.fromRGB(38, 38, 46)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(38, 38, 46)), ColorSequenceKeypoint.new(1, C.accentGlow) })
    sg.Parent = winStroke
    addSpinner(sg, 45)
end
local uiScale = Instance.new("UIScale")
uiScale.Parent = window
local baseScale = 1
local function fitScale()
    local cam = workspace.CurrentCamera
    if not cam then return 1 end
    local vp = cam.ViewportSize
    return math.clamp(math.min(vp.X / (W + 120), vp.Y / (H + 90)), 0.55, 1)
end

local bgFill = mkBox(window, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 1 })
grad(bgFill, ColorSequence.new(Color3.fromRGB(20, 19, 25), Color3.fromRGB(8, 8, 10)), 90)
local topGlow = mkBox(window, { Size = UDim2.new(1, 0, 0, 120), BackgroundColor3 = C.accent, ZIndex = 2 })
grad(topGlow, ColorSequence.new(C.accentGlow, C.accent), 90).Transparency =
    NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 1) })

-- ---------- header ----------
local header = mkBox(window, { Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, ZIndex = 10 })
local title = mkText(header, "ARHUB", 22, Color3.new(1, 1, 1), BLACK, { Position = UDim2.fromOffset(16, 11), Size = UDim2.fromOffset(90, 24), ZIndex = 11 })
grad(title, ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 95, 105)), 0)
mkText(header, "SCRIPT LOADER  ·  " .. VERSION, 9, C.accent, BOLD, { Position = UDim2.fromOffset(16, 36), Size = UDim2.fromOffset(200, 12), ZIndex = 11 })

local pill = mkBox(header, { Position = UDim2.fromOffset(112, 15), Size = UDim2.fromOffset(66, 18), BackgroundColor3 = C.card, ZIndex = 11 })
corner(pill, 9)
stroke(pill, C.success, 1, 0.65)
local pDot = mkBox(pill, { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = C.success, ZIndex = 12 })
corner(pDot, 3)
mkText(pill, "ONLINE", 8, C.text, MONO, { Position = UDim2.fromOffset(19, 0), Size = UDim2.fromOffset(44, 18), ZIndex = 12 })
task.spawn(function()
    while running do
        if menuOpen then
            tween(pDot, 0.7, { BackgroundTransparency = 0.7 }, Q.Sine, D.InOut) task.wait(0.75)
            tween(pDot, 0.7, { BackgroundTransparency = 0 }, Q.Sine, D.InOut) task.wait(0.75)
        else
            task.wait(0.3)
        end
    end
end)

local closeBtn = mkBtn(header, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(28, 28),
    BackgroundTransparency = 0, BackgroundColor3 = C.card, ZIndex = 11 })
corner(closeBtn, 9)
pressFx(closeBtn)
local xHold = mkBox(closeBtn, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ZIndex = 12 })
for _, rot in ipairs({ 45, -45 }) do
    mkBox(xHold, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 2), Rotation = rot, BackgroundColor3 = C.dim, ZIndex = 13 })
end
closeBtn.MouseEnter:Connect(function() tween(closeBtn, 0.2, { BackgroundColor3 = C.accent }) tween(xHold, 0.3, { Rotation = 90 }, Q.Back) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, 0.2, { BackgroundColor3 = C.card }) tween(xHold, 0.3, { Rotation = 0 }, Q.Back) end)

local scan = mkBox(window, { Position = UDim2.fromOffset(-120, 59), Size = UDim2.fromOffset(120, 2), BackgroundColor3 = C.accentGlow, ZIndex = 12 })
grad(scan, ColorSequence.new(C.accentGlow, Color3.new(0, 0, 0)), 0)
task.spawn(function()
    while running do
        if menuOpen then
            scan.Position = UDim2.fromOffset(-120, 59)
            tween(scan, 1.6, { Position = UDim2.fromOffset(W, 59) }, Q.Sine, D.InOut)
            task.wait(2.6)
        else
            task.wait(0.3)
        end
    end
end)
mkBox(window, { Position = UDim2.fromOffset(0, 60), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.line, ZIndex = 11 })
makeDraggable(header, window)

mkText(window, "RIGHTSHIFT  ·  TOGGLE MENU", 9, C.dim, MONO, { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -7),
    Size = UDim2.fromOffset(240, 12), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 11 })

-- ---------- tabs ----------
local TAB_NAMES = { "Scripts", "Community", "Info" }
local tabBar = mkBox(window, { Position = UDim2.fromOffset(0, 61), Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, ZIndex = 10 })
local tabW = (W - 32 - 8 * (#TAB_NAMES - 1)) / #TAB_NAMES
local indicator = mkBox(tabBar, { Position = UDim2.fromOffset(16, 7), Size = UDim2.fromOffset(tabW, 28), BackgroundColor3 = C.accent, ZIndex = 11 })
corner(indicator, 8)
grad(indicator, ColorSequence.new(C.accentGlow, C.accent), 90)
stroke(indicator, C.accentGlow, 1, 0.5)

local pages, tabButtons, currentTab = {}, {}, nil
local selectedRow, deselect, switchTab

local function createTab(name, i)
    local btn = mkBtn(tabBar, { Position = UDim2.fromOffset(16 + (i - 1) * (tabW + 8), 7), Size = UDim2.fromOffset(tabW, 28),
        Text = name, Font = BOLD, TextSize = 11, TextColor3 = C.dim, ZIndex = 12 })
    btn.MouseEnter:Connect(function() if currentTab ~= name then tween(btn, 0.15, { TextColor3 = C.text }) end end)
    btn.MouseLeave:Connect(function() if currentTab ~= name then tween(btn, 0.15, { TextColor3 = C.dim }) end end)

    local holder = mkBox(window, { Position = UDim2.fromOffset(0, 106), Size = UDim2.new(1, 0, 1, -130), BackgroundTransparency = 1,
        ZIndex = 10, Visible = false, GroupTransparency = 1 }, "CanvasGroup")
    local page = Instance.new("ScrollingFrame")
    page.BackgroundTransparency, page.BorderSizePixel = 1, 0
    page.Size = UDim2.fromScale(1, 1)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = C.accent
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ZIndex = 10
    page.Parent = holder
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    local pad = Instance.new("UIPadding")
    pad.PaddingTop, pad.PaddingBottom, pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 6), UDim.new(0, 10), UDim.new(0, 16), UDim.new(0, 16)
    pad.Parent = page

    pages[name], tabButtons[name] = holder, btn
    btn.MouseButton1Click:Connect(function() if currentTab ~= name then sfx(0.1, 1.3) end switchTab(name) end)
    return page
end

switchTab = function(name)
    if deselect then deselect() end
    currentTab = name
    for n, h in pairs(pages) do
        if n ~= name then h.Visible = false h.GroupTransparency = 1 end
    end
    for n, b in pairs(tabButtons) do tween(b, 0.2, { TextColor3 = (n == name) and C.text or C.dim }) end
    tween(indicator, 0.4, { Position = tabButtons[name].Position }, Q.Back)
    local h = pages[name]
    h.Visible = true
    h.Position = UDim2.fromOffset(0, 118)
    h.GroupTransparency = 1
    tween(h, 0.35, { Position = UDim2.fromOffset(0, 106), GroupTransparency = 0 }, Q.Quart)
end

local scriptPage = createTab("Scripts", 1)
local communityPage = createTab("Community", 2)
local infoPage = createTab("Info", 3)

-- ---------- toasts ----------
local toasts = {}
local function restack()
    for i, t in ipairs(toasts) do tween(t, 0.35, { Position = UDim2.new(0.5, 0, 0, 14 + (i - 1) * 50) }, Q.Back) end
end
local function showToast(msg, color, tag)
    if unloaded then return end
    color = color or C.accent
    local f = mkBox(loaderGui, { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -60), Size = UDim2.fromOffset(280, 40),
        BackgroundColor3 = C.bgPanel, ZIndex = 300, GroupTransparency = 1 }, "CanvasGroup")
    corner(f, 10)
    stroke(f, color, 1, 0.35)
    mkBox(f, { Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = color, ZIndex = 301 })
    local ic = mkBox(f, { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(22, 22), BackgroundColor3 = color, ZIndex = 301 })
    corner(ic, 11)
    mkText(ic, tag or "i", 11, Color3.new(1, 1, 1), BLACK, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 302 })
    mkText(f, msg, 11, C.text, BOLD, { Position = UDim2.fromOffset(46, 0), Size = UDim2.new(1, -56, 1, 0), ZIndex = 301 })
    local timer = mkBox(f, { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = color, ZIndex = 302 })
    table.insert(toasts, f)
    tween(f, 0.25, { GroupTransparency = 0 })
    restack()
    tween(timer, 2.6, { Size = UDim2.new(0, 0, 0, 2) }, Q.Linear)
    task.delay(2.7, function()
        local idx = table.find(toasts, f)
        if idx then table.remove(toasts, idx) end
        if not f.Parent then return end
        tween(f, 0.25, { GroupTransparency = 1 })
        task.delay(0.3, function() if f.Parent then f:Destroy() end end)
        restack()
    end)
end

local function ripple(btn)
    local r = mkBox(btn, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.6, ZIndex = 120 })
    corner(r, 999)
    tween(r, 0.55, { Size = UDim2.fromOffset(340, 340), BackgroundTransparency = 1 }, Q.Quad)
    task.delay(0.6, function() if r.Parent then r:Destroy() end end)
end

-- ---------- FAB (declared early so unload can hide it) ----------
local FAB = 40
local fab = mkBox(loaderGui, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 40, 0.5, 0), Size = UDim2.fromOffset(0, 0),
    BackgroundColor3 = C.bgPanel, ZIndex = 150, Visible = false })
corner(fab, 30)
do
    local fs = stroke(fab, Color3.new(1, 1, 1), 2, 0)
    local fg = Instance.new("UIGradient")
    fg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.accentGlow), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 48)),
        ColorSequenceKeypoint.new(1, C.accentGlow) })
    fg.Parent = fs
    addSpinner(fg, 120)
end
local fabLetter = mkText(fab, "A", 20, Color3.new(1, 1, 1), BLACK, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 151 })
grad(fabLetter, ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 90, 100)), 90)
local fabHit = mkBtn(fab, { Size = UDim2.fromScale(1, 1), ZIndex = 153 })
task.spawn(function()
    while running do
        if fab.Visible then
            local ring = mkBox(fab, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(FAB, FAB),
                BackgroundTransparency = 1, ZIndex = 149 })
            corner(ring, 999)
            local rs = stroke(ring, C.accentGlow, 2, 0.3)
            tween(ring, 1.6, { Size = UDim2.fromOffset(FAB + 36, FAB + 36) }, Q.Quad)
            tween(rs, 1.6, { Transparency = 1 })
            task.delay(1.7, function() if ring.Parent then ring:Destroy() end end)
        end
        task.wait(2.2)
    end
end)
fabHit.MouseEnter:Connect(function() tween(fab, 0.2, { Size = UDim2.fromOffset(FAB + 6, FAB + 6) }, Q.Back) end)
fabHit.MouseLeave:Connect(function() tween(fab, 0.2, { Size = UDim2.fromOffset(FAB, FAB) }, Q.Back) end)

-- ---------- UNLOAD ----------
local function unload()
    if unloaded then return end
    unloaded = true
    menuOpen = false
    if genv.ArHubUnload == unload then genv.ArHubUnload = nil end
    pcall(function()
        tween(window, 0.3, { GroupTransparency = 1 }, Q.Quad, D.In)
        tween(backdrop, 0.3, { BackgroundTransparency = 1 })
        fab.Visible = false
    end)
    task.delay(0.35, function()
        running = false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        table.clear(conns)
        table.clear(spinners)
        for _, g in ipairs(guis) do pcall(function() g:Destroy() end) end
        table.clear(guis)
        _G.ArHub_onIntroComplete = nil
    end)
end
genv.ArHubUnload = unload

-- ---------- PAGE: SCRIPTS ----------
local CARD_H, OPEN_H = 58, 108
local rowRefs = {}

deselect = function()
    if not selectedRow then return end
    local row = selectedRow
    selectedRow = nil
    tween(row, 0.3, { Size = UDim2.new(1, 0, 0, CARD_H), BackgroundColor3 = C.card }, Q.Quart)
    local s = row:FindFirstChildOfClass("UIStroke")
    if s then tween(s, 0.25, { Color = C.line }) end
    local chev = row:FindFirstChild("chev")
    if chev then tween(chev, 0.3, { Rotation = 0 }, Q.Back) end
end

local function selectGame(row)
    if selectedRow == row then deselect() return end
    deselect()
    selectedRow = row
    sfx(0.08, 1.4)
    tween(row, 0.35, { Size = UDim2.new(1, 0, 0, OPEN_H), BackgroundColor3 = C.cardHover }, Q.Back)
    local s = row:FindFirstChildOfClass("UIStroke")
    if s then tween(s, 0.25, { Color = C.accent }) end
    local chev = row:FindFirstChild("chev")
    if chev then tween(chev, 0.3, { Rotation = 90 }, Q.Back) end
end

for i, g in ipairs(GAMES) do
    local row = mkBox(scriptPage, { Size = UDim2.new(1, 0, 0, CARD_H), BackgroundColor3 = C.card, LayoutOrder = i, ZIndex = 103 }, "CanvasGroup")
    corner(row, 12)
    stroke(row, C.line, 1, 0)
    mkBox(row, { Size = UDim2.new(0, 4, 0, CARD_H), BackgroundColor3 = C.accent, ZIndex = 104 })
    local icon = mkBox(row, { Position = UDim2.fromOffset(16, 11), Size = UDim2.fromOffset(36, 36), BackgroundColor3 = C.accent, ZIndex = 104 })
    corner(icon, 10)
    grad(icon, ColorSequence.new(C.accentGlow, Color3.fromRGB(90, 0, 10)), 45)
    mkText(icon, g.name:sub(1, 1), 17, Color3.new(1, 1, 1), BLACK, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 105 })
    mkText(row, g.name, 14, C.text, BOLD, { Position = UDim2.fromOffset(62, 11), Size = UDim2.new(1, -140, 0, 16), ZIndex = 104 })
    local gDesc = mkText(row, "Select to view options", 10, C.dim, BODY, { Position = UDim2.fromOffset(62, 32), Size = UDim2.new(1, -140, 0, 14), ZIndex = 104 })
    mkText(row, ">", 16, C.dim, BOLD, { Name = "chev", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -22, 0, CARD_H / 2),
        Size = UDim2.fromOffset(20, 20), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 104 })

    local isCurrent, nameLower = false, game.Name:lower()
    for _, m in ipairs(g.match) do if nameLower:find(m, 1, true) then isCurrent = true break end end
    if isCurrent then
        local badge = mkBox(row, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -44, 0, 21), Size = UDim2.fromOffset(62, 16),
            BackgroundColor3 = C.success, BackgroundTransparency = 0.82, ZIndex = 104 })
        corner(badge, 8)
        stroke(badge, C.success, 1, 0.5)
        mkText(badge, "DETECTED", 8, C.success, MONO, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 105 })
        gDesc.Text, gDesc.TextColor3 = "Game detected", C.success
    end

    local shine = mkBox(row, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-0.3, 0, 0, CARD_H / 2), Size = UDim2.new(0.16, 0, 0, 160),
        Rotation = 20, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.93, ZIndex = 106 })
    local hit = mkBtn(row, { Size = UDim2.new(1, 0, 0, CARD_H), ZIndex = 107 })
    hit.MouseButton1Click:Connect(function() selectGame(row) end)
    hit.MouseEnter:Connect(function()
        if selectedRow ~= row then tween(row, 0.2, { BackgroundColor3 = C.cardHover }) end
        shine.Position = UDim2.new(-0.3, 0, 0, CARD_H / 2)
        tween(shine, 0.7, { Position = UDim2.new(1.3, 0, 0, CARD_H / 2) }, Q.Quad)
    end)
    hit.MouseLeave:Connect(function() if selectedRow ~= row then tween(row, 0.2, { BackgroundColor3 = C.card }) end end)

    local execBtn = mkBtn(row, { Position = UDim2.fromOffset(14, 68), Size = UDim2.new(1, -28, 0, 32), BackgroundTransparency = 0,
        BackgroundColor3 = C.accent, ZIndex = 108, ClipsDescendants = true })
    corner(execBtn, 9)
    pressFx(execBtn)
    stroke(execBtn, C.accentGlow, 1, 0.4)
    local fill = mkBox(execBtn, { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accentGlow, ZIndex = 109 })
    local execText = mkText(execBtn, "EXECUTE SCRIPT", 11, Color3.new(1, 1, 1), BOLD, { Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 110 })
    execBtn.MouseEnter:Connect(function() tween(execBtn, 0.15, { BackgroundColor3 = C.accentGlow }) end)
    execBtn.MouseLeave:Connect(function() tween(execBtn, 0.15, { BackgroundColor3 = C.accent }) end)

    local busy = false
    execBtn.MouseButton1Click:Connect(function()
        if busy or unloaded then return end
        busy = true
        ripple(execBtn)
        sfx(0.22)
        execText.Text = "LOADING..."
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = C.accentGlow
        tween(fill, 1.6, { Size = UDim2.new(0.88, 0, 1, 0) }, Q.Quad)
        task.spawn(function()
            local ok, err = pcall(function()
                local code = game:HttpGet(g.url)
                if not code or #code < 10 then error("Invalid payload") end
                local fn, compileErr = loadstring(code)
                if not fn then error(compileErr or "Compile error") end
                fn()
            end)
            if unloaded then return end
            tween(fill, 0.2, { Size = UDim2.new(1, 0, 1, 0) })
            task.wait(0.22)
            if ok then
                execText.Text = "LOADED"
                tween(fill, 0.25, { BackgroundColor3 = C.success })
                tween(row, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 44, 28) })
                sfx(0.25, 1.15)
                if AUTO_UNLOAD then
                    showToast("Loaded: " .. g.name .. "  -  unloading loader", C.success, "OK")
                    task.wait(UNLOAD_DELAY)
                    unload()
                    return
                end
                showToast("Loaded: " .. g.name, C.success, "OK")
                task.wait(0.9)
                tween(row, 0.5, { BackgroundColor3 = C.card })
                deselect()
            else
                execText.Text = "FAILED"
                tween(fill, 0.25, { BackgroundColor3 = Color3.fromRGB(110, 10, 20) })
                nudge(execBtn, 6)
                showToast("Error: " .. tostring(err):sub(1, 32), C.accentGlow, "!")
                task.wait(1.1)
            end
            tween(fill, 0.3, { Size = UDim2.new(0, 0, 1, 0) })
            execText.Text = "EXECUTE SCRIPT"
            busy = false
        end)
    end)

    rowRefs[#rowRefs + 1] = row
end

-- ---------- PAGE: COMMUNITY ----------
local function mkCard(parent, h, order, barColor)
    local card = mkBox(parent, { Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = C.card, LayoutOrder = order, ZIndex = 103 }, "CanvasGroup")
    corner(card, 12)
    stroke(card, C.line, 1, 0)
    mkBox(card, { Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = barColor, ZIndex = 104 })
    return card
end

local communityCard = mkCard(communityPage, 140, 1, C.discord)
mkText(communityCard, "Join the ArHub Community", 14, C.text, BOLD, { Position = UDim2.fromOffset(18, 12), Size = UDim2.new(1, -36, 0, 16), ZIndex = 104 })
mkText(communityCard, "Get support, report bugs and find new scripts. Tap below to copy the invite link.", 11, C.dim, BODY,
    { Position = UDim2.fromOffset(18, 34), Size = UDim2.new(1, -36, 0, 36), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 104 })
local discordBtn = mkBtn(communityCard, { Position = UDim2.fromOffset(18, 88), Size = UDim2.new(1, -36, 0, 36), BackgroundTransparency = 0,
    BackgroundColor3 = C.discord, ZIndex = 105, ClipsDescendants = true })
corner(discordBtn, 10)
pressFx(discordBtn)
stroke(discordBtn, Color3.fromRGB(130, 145, 255), 1, 0.3)
grad(discordBtn, ColorSequence.new(Color3.fromRGB(110, 124, 255), Color3.fromRGB(70, 82, 220)), 90)
local dText = mkText(discordBtn, "COPY DISCORD INVITE", 12, Color3.new(1, 1, 1), BOLD, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 106 })
discordBtn.MouseButton1Click:Connect(function()
    ripple(discordBtn)
    local cb = setclipboard or toclipboard or (syn and syn.write_clipboard) or writeclipboard
    if cb then
        pcall(cb, DISCORD_URL)
        showToast("Discord invite copied!", C.success, "OK")
        sfx(0.2)
        dText.Text = "COPIED!"
        task.delay(1.2, function() if dText.Parent then dText.Text = "COPY DISCORD INVITE" end end)
    else
        showToast("Clipboard unavailable", C.accentGlow, "!")
    end
end)
discordBtn.MouseEnter:Connect(function() tween(discordBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(120, 134, 255) }) end)
discordBtn.MouseLeave:Connect(function() tween(discordBtn, 0.15, { BackgroundColor3 = C.discord }) end)

-- ---------- PAGE: INFO ----------
local infoCard = mkCard(infoPage, 160, 1, C.accentGlow)
mkText(infoCard, "The Beginnings of ArHub", 14, C.text, BOLD, { Position = UDim2.fromOffset(18, 12), Size = UDim2.new(1, -36, 0, 16), ZIndex = 104 })
mkText(infoCard, "ArHub started as a simple passion project. We wanted a tool that was fast, reliable, and looked damn good while doing it. What you see today is months of refinement, breaking things, and rebuilding them better.\n\nWe don't cut corners. Enjoy the engine.",
    12, C.dim, BODY, { Position = UDim2.fromOffset(18, 36), Size = UDim2.new(1, -36, 0, 116), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 104 })

local unloadBtn = mkBtn(infoPage, { Size = UDim2.new(1, 0, 0, 36), LayoutOrder = 2, BackgroundTransparency = 0, BackgroundColor3 = C.card, ZIndex = 103 })
corner(unloadBtn, 10)
pressFx(unloadBtn)
local uStroke = stroke(unloadBtn, C.line, 1, 0)
mkText(unloadBtn, "UNLOAD LOADER", 11, C.dim, BOLD, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 104 })
unloadBtn.MouseEnter:Connect(function() tween(uStroke, 0.15, { Color = C.accent }) end)
unloadBtn.MouseLeave:Connect(function() tween(uStroke, 0.15, { Color = C.line }) end)
unloadBtn.MouseButton1Click:Connect(function() showToast("Unloading ArHub...", C.accent, "i") task.wait(0.5) unload() end)

-- ---------- open / close ----------
local function animateRows()
    for i, row in ipairs(rowRefs) do
        row.GroupTransparency = 1
        task.delay(0.12 + i * 0.07, function() if row.Parent then tween(row, 0.4, { GroupTransparency = 0 }, Q.Quart) end end)
    end
end

local function openMenu()
    if menuOpen or unloaded then return end
    menuOpen = true
    baseScale = fitScale()
    fab.Visible = false
    window.Visible = true
    window.GroupTransparency = 1
    window.Rotation = -3
    uiScale.Scale = baseScale * 0.82
    tween(window, 0.5, { GroupTransparency = 0, Rotation = 0 }, Q.Quart)
    tween(uiScale, 0.6, { Scale = baseScale }, Q.Back)
    switchTab("Scripts")
    animateRows()
    sfx(0.15)
end

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    deselect()
    tween(window, 0.25, { GroupTransparency = 1 }, Q.Quad, D.In)
    tween(uiScale, 0.25, { Scale = baseScale * 0.9 }, Q.Quad, D.In)
    tween(backdrop, 0.3, { BackgroundTransparency = 1 })
    sfx(0.12, 0.9)
    task.delay(0.27, function()
        if menuOpen or unloaded then return end
        window.Visible = false
        fab.Visible = true
        fab.Size = UDim2.fromOffset(0, 0)
        tween(fab, 0.45, { Size = UDim2.fromOffset(FAB, FAB) }, Q.Back)
    end)
end

closeBtn.MouseButton1Click:Connect(closeMenu)
makeDraggable(fabHit, fab, openMenu)
bind(UIS.InputBegan:Connect(function(i, gp)
    if gp or not introDone or unloaded then return end
    if i.KeyCode == TOGGLE_KEY then
        if menuOpen then closeMenu() else openMenu() end
    end
end))

-- =====================================================================
-- BOOT
-- =====================================================================
task.spawn(function()
    playIntro(function()
        if unloaded then return end
        introDone = true
        loaderGui.Enabled = true
        openMenu()
    end)
end)
