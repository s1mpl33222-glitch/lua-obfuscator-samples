-- [[ UwU Premium AP — v20.4 FX OVERLOAD | Made by zPxnchiSkixlled ]]

if game.CoreGui:FindFirstChild("UwUPremiumAP") then game.CoreGui.UwUPremiumAP:Destroy() end

local Players           = cloneref and cloneref(game:GetService('Players')) or game:GetService('Players')
local ReplicatedStorage = cloneref and cloneref(game:GetService('ReplicatedStorage')) or game:GetService('ReplicatedStorage')
local UserInputService  = cloneref and cloneref(game:GetService('UserInputService')) or game:GetService('UserInputService')
local RunService        = cloneref and cloneref(game:GetService('RunService')) or game:GetService('RunService')
local TweenService      = cloneref and cloneref(game:GetService('TweenService')) or game:GetService('TweenService')
local Stats             = cloneref and cloneref(game:GetService('Stats')) or game:GetService('Stats')
local HttpService       = cloneref and cloneref(game:GetService('HttpService')) or game:GetService('HttpService')
local CoreGui           = cloneref and cloneref(game:GetService('CoreGui')) or game:GetService('CoreGui')

local function ShowError(txt)
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "UwU_ErrorReport"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 999999
        local ok = pcall(function() sg.Parent = CoreGui end)
        if not ok then sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
        local f = Instance.new("TextLabel")
        f.Size = UDim2.new(0.6, 0, 0, 180)
        f.Position = UDim2.new(0.2, 0, 0.25, 0)
        f.BackgroundColor3 = Color3.fromRGB(45, 12, 12)
        f.BackgroundTransparency = 0.05
        f.TextColor3 = Color3.fromRGB(255, 110, 110)
        f.TextWrapped = true
        f.TextSize = 12
        f.Font = Enum.Font.Gotham
        f.Text = "UWU PREMIUM ERROR\n\n" .. tostring(txt) .. "\n\n(manda un screenshot de esto)"
        f.BorderSizePixel = 0
        f.Parent = sg
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    end)
end

local RunOK, RunErr = xpcall(function()

local LocalPlayer = Players.LocalPlayer
local Alive = workspace:FindFirstChild("Alive") or workspace:WaitForChild("Alive")
local ParryHook = nil

-- // PARRY PATCH (BYPASS ANTICHEAT)
local _PARRY_PATCH = { keyTable = nil, transformFn = nil, netModule = nil, remoteId = nil, parryHash = nil, parryRemote = nil, ready = false }

pcall(function()
    local old_dinfo
    old_dinfo = hookfunction(getrenv().debug.info, function(f, t)
        if type(f) == "function" then return "[C]"
        elseif f == 4 and t == "s" then return "ReplicatedStorage.Controllers.SwordsController " end
        return old_dinfo(f, t)
    end)
    local old_gfenv
    old_gfenv = hookfunction(getrenv().getfenv, function(l)
        if l ~= nil and type(l) == "number" then
            if l >= 1 and l <= 10 then return old_gfenv(10) end
        end
        return old_gfenv(l)
    end)
end)

task.spawn(function()
    pcall(function()
        local Controllers = ReplicatedStorage:WaitForChild("Controllers", 15)
        if not Controllers then return end
        local SC
        for _, child in ipairs(Controllers:GetChildren()) do
            if child.Name:sub(1, 16) == "SwordsController" then SC = child break end
        end
        if not SC then return end
        local PRY = SC:WaitForChild("PRY", 15)
        if not PRY then return end
        local Parry_Function = require(PRY)
        local getupvals = debug.getupvalues or getupvalues
        if not getupvals then return end
        local ups = getupvals(Parry_Function)
        if not ups or #ups < 8 then return end
        _PARRY_PATCH.keyTable = ups[3]
        _PARRY_PATCH.transformFn = ups[4]
        _PARRY_PATCH.netModule = ups[6]
        _PARRY_PATCH.remoteId = ups[7]
        _PARRY_PATCH.parryHash = ups[8]
        pcall(function() _PARRY_PATCH.parryRemote = _PARRY_PATCH.netModule:RemoteEvent(_PARRY_PATCH.remoteId) end)
        if _PARRY_PATCH.parryRemote then _PARRY_PATCH.ready = true end
    end)
end)

function _PARRY_PATCH.fire(curveCFrame, screenPositions, mouseLocation)
    if not _PARRY_PATCH.ready then return false end
    local kt = _PARRY_PATCH.keyTable
    if not kt then return false end
    local currentKey = kt[1] and kt[1][kt[3]]
    if not currentKey then return false end
    local tok, transformed = pcall(_PARRY_PATCH.transformFn, currentKey, "TIME")
    if not tok or not transformed then
        tok, transformed = pcall(_PARRY_PATCH.transformFn, currentKey)
        if not tok or not transformed then return false end
    end
    local timeStr = tostring(math.floor(workspace:GetServerTimeNow() * 100))
    local tc = {}
    for i = 1, #timeStr do
        local ki = (i - 1) % #transformed + 1
        tc[i] = string.char(bit32.bxor((string.byte(timeStr, i) + i) % 256, string.byte(transformed, ki)))
    end
    pcall(function()
        _PARRY_PATCH.parryRemote:FireServer(_PARRY_PATCH.parryHash, currentKey, table.concat(tc), 0.5, curveCFrame, screenPositions, mouseLocation, false)
    end)
    return true
end

-- // System
local System = {
    __properties = {
        __autoparry_enabled = false, __animation_fix = false, __curve_mode = 1,
        __accuracy = 1, __divisor_multiplier = 1.1, __parried = false, __parries = 0,
        __first_parry_done = false, __connections = {}
    },
    __config = { __curve_names = {'Camera', 'Random', 'Accelerated', 'Backwards', 'Slow', 'High'} },
    ball = {}, player = {}, curve = {}, parry = {}, detection = {
        __ball_properties = { __aerodynamic_time = tick(), __last_warping = tick(), __lerp_radians = 0, __curving = tick() }
    }, autoparry = {}
}

local PF = nil
local SC = nil

pcall(function()
    if ReplicatedStorage:FindFirstChild("Controllers") then
        for _, child in ipairs(ReplicatedStorage.Controllers:GetChildren()) do
            if child.Name:match("^SwordsController%s*$") then SC = child end
        end
    end
    if LocalPlayer.PlayerGui:FindFirstChild("Hotbar") and LocalPlayer.PlayerGui.Hotbar:FindFirstChild("Block") then
        for _, v in next, getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated) do
            if SC and getfenv(v.Function).script == SC then PF = v.Function break end
        end
    end
end)

local function update_divisor()
    System.__properties.__divisor_multiplier = 0.75 + (System.__properties.__accuracy - 1) * (3 / 99)
end

function System.ball.get()
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return nil end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then ball.CanCollide = false return ball end
    end
    return nil
end

function System.ball.get_all()
    local balls_table = {}
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return balls_table end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then ball.CanCollide = false table.insert(balls_table, ball) end
    end
    return balls_table
end

function System.player.get_closest_to_cursor()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then return nil end
    local closest_player, minimal_dot = nil, -math.huge
    local camera = workspace.CurrentCamera
    local success, mouse_location = pcall(function() return UserInputService:GetMouseLocation() end)
    if not success then return nil end
    local ray = camera:ScreenPointToRay(mouse_location.X, mouse_location.Y)
    local pointer = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
    for _, player in pairs(Alive:GetChildren()) do
        if player ~= LocalPlayer.Character and player:FindFirstChild('HumanoidRootPart') then
            local direction = (player.HumanoidRootPart.Position - camera.CFrame.Position).Unit
            local dot = pointer.LookVector:Dot(direction)
            if dot > minimal_dot then minimal_dot = dot closest_player = player end
        end
    end
    return closest_player
end

function System.curve.get_cframe()
    local camera = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not root then return camera.CFrame end
    local targetPart = System.player.get_closest_to_cursor()
    if targetPart and targetPart:FindFirstChild('HumanoidRootPart') then targetPart = targetPart.HumanoidRootPart end
    local target_pos = targetPart and targetPart.Position or (root.Position + camera.CFrame.LookVector * 100)
    local curve_functions = {
        function() return camera.CFrame end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))) end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, 5, 0)) end,
        function() return CFrame.new(camera.CFrame.Position, root.Position + (root.Position - target_pos).Unit * 10000 + Vector3.new(0, 1000, 0)) end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, -9e18, 0)) end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, 9e18, 0)) end
    }
    return curve_functions[System.__properties.__curve_mode]()
end

function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera = workspace.CurrentCamera
    local success, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
    if not success then return end
    local vec2_mouse = {mouse.X, mouse.Y}
    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local s, sp = pcall(function() return camera:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if s then event_data[entity.Name] = sp end
            end
        end
    end
    local curve_cframe = System.curve.get_cframe()
    if not System.__properties.__first_parry_done then
        pcall(function()
            for _, connection in pairs(getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do connection:Fire() end
        end)
        System.__properties.__first_parry_done = true return
    end
    _PARRY_PATCH.fire(curve_cframe, event_data, vec2_mouse)
    if System.__properties.__animation_fix and PF then PF() end
    System.__properties.__parries = System.__properties.__parries + 1
    if ParryHook then pcall(ParryHook) end
    task.delay(0.5, function() if System.__properties.__parries > 0 then System.__properties.__parries = System.__properties.__parries - 1 end end)
end

function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    if PF then PF() end
    System.__properties.__parries = System.__properties.__parries + 1
    if ParryHook then pcall(ParryHook) end
    task.delay(0.5, function() if System.__properties.__parries > 0 then System.__properties.__parries = System.__properties.__parries - 1 end end)
end

function System.parry.execute_action() System.parry.execute() end

local function linear_predict(a, b, t) return a + (b - a) * t end

function System.detection.is_curved()
    local bp = System.detection.__ball_properties
    local ball = System.ball.get_all()[1]
    if not ball then return false end
    local zoomies = ball:FindFirstChild('zoomies')
    if not zoomies then return false end
    local vel = zoomies.VectorVelocity
    local dot = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit:Dot(vel.Unit)
    local speed = vel.Magnitude
    local dist = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
    local reach = dist / speed - (ping / 1000)
    local dist_thresh = 15 - math.min(dist / 1000, 15) + math.min(speed / 100, 40)
    if speed > 0 and reach > ping / 10 then dist_thresh = math.max(dist_thresh - 15, 15) end
    if dist < dist_thresh then return false end
    bp.__lerp_radians = linear_predict(bp.__lerp_radians, math.rad(math.asin(math.clamp(dot, -1, 1))), 0.8)
    if bp.__lerp_radians < 0.018 then bp.__last_warping = tick() end
    if (tick() - bp.__last_warping) < (reach / 1.5) then return true end
    if (tick() - bp.__curving) < (reach / 1.5) then return true end
    return dot < (0.5 - (ping / 1000))
end

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then System.__properties.__connections.__autoparry:Disconnect() end
    System.__properties.__connections.__autoparry = RunService.PreSimulation:Connect(function()
        if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
        local balls = System.ball.get_all()
        local one_ball = System.ball.get()
        for _, ball in pairs(balls) do
            if not ball then continue end
            local zoomies = ball:FindFirstChild('zoomies')
            if not zoomies then continue end
            ball:GetAttributeChangedSignal('target'):Once(function() System.__properties.__parried = false end)
            if System.__properties.__parried then continue end
            local ball_target = ball:GetAttribute('target')
            local vel = zoomies.VectorVelocity
            local dist = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local ping_thresh = math.clamp(ping / 10, 5, 17)
            local speed = vel.Magnitude
            local capped_speed = math.min(math.max(speed - 9.5, 0), 650)
            local speed_div = (2.4 + capped_speed * 0.002) * System.__properties.__divisor_multiplier
            local parry_acc = ping_thresh + math.max(speed / speed_div, 9.5)
            if one_ball and one_ball:GetAttribute('target') == LocalPlayer.Name and System.detection.is_curved() then continue end
            if ball_target == LocalPlayer.Name and dist <= parry_acc then
                if getgenv().AutoParryMode == "Keypress" then System.parry.keypress() else System.parry.execute_action() end
                System.__properties.__parried = true
            end
            local last = tick()
            repeat RunService.Stepped:Wait() until (tick() - last) >= 1 or not System.__properties.__parried
            System.__properties.__parried = false
        end
    end)
end

function System.autoparry.stop()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
        System.__properties.__connections.__autoparry = nil
    end
end

-- ═══════════════════════ UI ENGINE ═══════════════════════
local BASE = {
    Bg = Color3.fromRGB(120, 124, 145), BgTop = Color3.fromRGB(150, 155, 176),
    Sidebar = Color3.fromRGB(130, 134, 155), Card = Color3.fromRGB(178, 183, 202),
    CardHover = Color3.fromRGB(190, 194, 212), Track = Color3.fromRGB(70, 74, 92),
    Stroke = Color3.fromRGB(160, 165, 188), Sub = Color3.fromRGB(230, 233, 247),
}
local Theme = {
    Bg = BASE.Bg, BgTop = BASE.BgTop, Sidebar = BASE.Sidebar,
    Card = BASE.Card, CardHover = BASE.CardHover, Track = BASE.Track,
    Stroke = BASE.Stroke, Text = Color3.new(1, 1, 1), Sub = BASE.Sub,
    Inv = Color3.fromRGB(242, 244, 252), SubInv = Color3.fromRGB(78, 84, 112),
    Good = Color3.fromRGB(35, 165, 100), Warn = Color3.fromRGB(200, 140, 25),
    Danger = Color3.fromRGB(215, 65, 65),
}
local Brightness = 1
local ThemeLinks = {}
local Accent, Accent2 = Color3.fromRGB(124, 84, 255), Color3.fromRGB(178, 110, 255)
local AccentLinks, Dynamic = {}, {}
local ACCENT_PRESETS = {
    {Color3.fromRGB(124, 84, 255), Color3.fromRGB(178, 110, 255)},
    {Color3.fromRGB(40, 118, 255),  Color3.fromRGB(70, 195, 255)},
    {Color3.fromRGB(245, 70, 100),  Color3.fromRGB(255, 145, 70)},
    {Color3.fromRGB(22, 175, 115),  Color3.fromRGB(95, 225, 160)},
    {Color3.fromRGB(240, 155, 25),  Color3.fromRGB(255, 205, 95)},
    {Color3.fromRGB(240, 75, 155),  Color3.fromRGB(255, 135, 195)},
}
local AccentIndex = 1
local rainbowMode = false
local SwatchRefresh = nil
local SearchEntries = {}
local searchFocused = false
local SearchActiveFlag = false
local KeyBinds = {}
local anyListening = 0

local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function Corner(parent, r) return New("UICorner", {CornerRadius = UDim.new(0, r or 8)}, parent) end
local function Stroke(parent, c, th, tr) return New("UIStroke", {Color = c or Theme.Stroke, Thickness = th or 1, Transparency = tr or 0}, parent) end
local function Ease(t, s, d) return TweenInfo.new(t or 0.25, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out) end
local function Tween(o, ti, props) local t = TweenService:Create(o, ti, props) t:Play() return t end
local function Tint(obj, prop, alt) table.insert(AccentLinks, {o = obj, p = prop, alt = alt and true or false}) end
local function Hex(c) return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end

local function AnimateGradient(grad, speed, sat, val)
    task.spawn(function()
        while grad.Parent do
            pcall(function()
                local t = (os.clock() * (speed or 0.1)) % 1
                local kps = {}
                for i = 0, 6 do kps[#kps + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((t + i / 6) % 1, sat or 0.85, val or 1)) end
                grad.Color = ColorSequence.new(kps)
            end)
            RunService.RenderStepped:Wait()
        end
    end)
    return grad
end

local function ScaleC(c, f)
    return Color3.new(math.clamp(c.R * f, 0, 1), math.clamp(c.G * f, 0, 1), math.clamp(c.B * f, 0, 1))
end
local WHITE = Color3.new(1, 1, 1)
local DARK_TEXT = Color3.fromRGB(30, 33, 46)
local DARK_SUB = Color3.fromRGB(78, 82, 105)

local function ApplyBrightness(f)
    Brightness = math.clamp(f, 0.6, 1.6)
    local b = Brightness
    local bgF = 0.75 + 0.25 * b
    Theme.Bg = ScaleC(BASE.Bg, bgF)
    Theme.BgTop = ScaleC(BASE.BgTop, bgF)
    Theme.Sidebar = ScaleC(BASE.Sidebar, bgF)
    Theme.Card = ScaleC(BASE.Card, b)
    Theme.CardHover = ScaleC(BASE.CardHover, b)
    Theme.Track = ScaleC(BASE.Track, 0.8 + 0.2 * b)
    Theme.Stroke = ScaleC(BASE.Stroke, 0.85 + 0.15 * b)
    local lum = 0.299 * Theme.Card.R + 0.587 * Theme.Card.G + 0.114 * Theme.Card.B
    local k = math.clamp((lum - 0.52) / 0.1, 0, 1)
    Theme.Text = WHITE:Lerp(DARK_TEXT, k)
    Theme.Sub = BASE.Sub:Lerp(DARK_SUB, k)
    for _, fn in ipairs(ThemeLinks) do pcall(fn) end
end
ApplyBrightness(1)

local function ApplyAccent(c1, c2, instant)
    Accent, Accent2 = c1, c2 or c1
    for _, l in ipairs(AccentLinks) do
        pcall(function()
            if l.p == "Gradient" then l.o.Color = ColorSequence.new(Accent, Accent2)
            else
                local val = l.alt and Accent2 or Accent
                if instant then l.o[l.p] = val else Tween(l.o, Ease(0.35), {[l.p] = val}) end
            end
        end)
    end
    for _, fn in ipairs(Dynamic) do pcall(fn) end
end

local function Ripple(parent, x, y)
    local r = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, x, 0, y), Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(45, 50, 75), BackgroundTransparency = 0.86, BorderSizePixel = 0, ZIndex = 40}, parent)
    Corner(r, 300)
    local d = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 1.6
    Tween(r, Ease(0.5), {Size = UDim2.new(0, d, 0, d), BackgroundTransparency = 1})
    task.delay(0.55, function() r:Destroy() end)
end

local function ClickRipple(el)
    el.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pcall(function() Ripple(el, input.Position.X - el.AbsolutePosition.X, input.Position.Y - el.AbsolutePosition.Y) end)
        end
    end)
end

local function MakeMagnetic(el, strength)
    pcall(function()
        local bp = el.Position
        local maxOff = strength or 3
        el.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                pcall(function()
                    local cx = el.AbsolutePosition.X + el.AbsoluteSize.X / 2
                    local cy = el.AbsolutePosition.Y + el.AbsoluteSize.Y / 2
                    local dx, dy = input.Position.X - cx, input.Position.Y - cy
                    el.Position = UDim2.new(
                        bp.X.Scale, bp.X.Offset + math.clamp(dx * 0.12, -maxOff, maxOff),
                        bp.Y.Scale, bp.Y.Offset + math.clamp(dy * 0.12, -maxOff, maxOff)
                    )
                end)
            end
        end)
        el.MouseLeave:Connect(function()
            pcall(function() Tween(el, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = bp}) end)
        end)
    end)
end

local function PingRing(parent)
    local ring = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -39, 0.5, 0), Size = UDim2.new(0, 50, 0, 26), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 25}, parent)
    Corner(ring, 300)
    local st = New("UIStroke", {Color = Accent, Thickness = 2, Transparency = 0.15}, ring)
    Tween(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 92, 0, 48)})
    Tween(st, TweenInfo.new(0.5), {Transparency = 1, Thickness = 1})
    task.delay(0.55, function() ring:Destroy() end)
end

local function RegisterSearch(name, desc, card)
    table.insert(SearchEntries, {name = tostring(name), desc = desc, card = card, page = card.Parent, searchOrder = #SearchEntries + 1, origOrder = card.LayoutOrder})
end

-- ═══════════ WINDOW ═══════════
local ScreenGui = New("ScreenGui", {Name = "UwUPremiumAP", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, CoreGui)

local soundEnabled = true
local uiSnd = New("Sound", {SoundId = "rbxasset://sounds/electronicpingshort.wav", Volume = 0.22}, ScreenGui)
local snapSnd = New("Sound", {SoundId = "rbxasset://sounds/snap.mp3", Volume = 0.28}, ScreenGui)
local function PlayClick(speed, vol)
    if not soundEnabled then return end
    pcall(function() uiSnd.PlaybackSpeed = speed or 1.5 uiSnd.Volume = vol or 0.22 uiSnd:Play() end)
end
local function PlaySnap(speed)
    if not soundEnabled then return end
    pcall(function() snapSnd.PlaybackSpeed = speed or 1.3 snapSnd:Play() end)
end

local Main = New("CanvasGroup", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 40), Size = UDim2.new(0, 560, 0, 400), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0, BorderSizePixel = 0, GroupTransparency = 0, ClipsDescendants = true}, ScreenGui)
Corner(Main, 20)
local BgGrad = New("UIGradient", {Color = ColorSequence.new(Theme.BgTop, Theme.Bg), Rotation = 90}, Main)
local MainStroke = Stroke(Main, Color3.new(1, 1, 1), 1.3, 0.3)
local BorderGrad = New("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 195, 225)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.5, 0.8), NumberSequenceKeypoint.new(1, 0.05)})}, MainStroke)
TweenService:Create(BorderGrad, TweenInfo.new(3.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0.4), {Offset = Vector2.new(0.85, 0)}):Play()

local uiScale = New("UIScale", {Scale = 0.92}, Main)
local userScale = 1
local function SetScale(v) userScale = v Tween(uiScale, Ease(0.25), {Scale = v}) end

task.spawn(function()
    while ScreenGui.Parent do
        if rainbowMode then
            pcall(function()
                local h = (os.clock() * 0.1) % 1
                ApplyAccent(Color3.fromHSV(h, 0.72, 1), Color3.fromHSV((h + 0.12) % 1, 0.72, 1), true)
            end)
        end
        task.wait(0.09)
    end
end)

local DepthFar  = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0}, Main)
local DepthMid  = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0}, Main)
local DepthNear = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0}, Main)

local function Drift(el, x1, y1, x2, y2, dur)
    task.spawn(function()
        while el.Parent do
            local ok = pcall(function()
                local t = TweenService:Create(el, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0, x1, 0, y1)})
                t:Play() t.Completed:Wait()
                local t2 = TweenService:Create(el, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0, x2, 0, y2)})
                t2:Play() t2.Completed:Wait()
            end)
            if not ok then break end
        end
    end)
end

local function MakeGlow(parent, x, y, size, baseT)
    local holder = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, x, 0, y), Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, parent)
    local c1 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Accent, BackgroundTransparency = baseT, BorderSizePixel = 0}, holder)
    Corner(c1, 300)
    local c2 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0.66, 0, 0.66, 0), BackgroundColor3 = Accent, BackgroundTransparency = baseT - 0.04, BorderSizePixel = 0}, holder)
    Corner(c2, 300)
    local c3 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0.38, 0, 0.38, 0), BackgroundColor3 = Accent2, BackgroundTransparency = baseT - 0.08, BorderSizePixel = 0}, holder)
    Corner(c3, 300)
    Tint(c1, "BackgroundColor3") Tint(c2, "BackgroundColor3") Tint(c3, "BackgroundColor3", true)
    return holder
end

do
    local AB1 = MakeGlow(DepthFar, 100, 90, 260, 0.93)
    local AB2 = MakeGlow(DepthFar, 460, 120, 230, 0.94)
    local AB3 = MakeGlow(DepthFar, 210, 330, 280, 0.94)
    Drift(AB1, 140, 120, 70, 55, 8)
    Drift(AB2, 420, 85, 495, 155, 11)
    Drift(AB3, 260, 365, 165, 295, 9)
    local Orb1 = MakeGlow(DepthMid, 40, 90, 200, 0.9)
    local Orb2 = MakeGlow(DepthMid, 520, 320, 230, 0.92)
    Drift(Orb1, 95, 130, -20, 45, 9)
    Drift(Orb2, 470, 270, 540, 360, 10)
end

for i = 1, 8 do
    local size = 2 + math.random(0, 3)
    local p = New("Frame", {Position = UDim2.new(math.random(5, 95) / 100, 0, math.random(8, 92) / 100, 0), Size = UDim2.new(0, size, 0, size), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.55 + math.random() * 0.3, BorderSizePixel = 0, ZIndex = 0}, DepthNear)
    Corner(p, 3)
    local sway = 10 + math.random(0, 25)
    TweenService:Create(p, TweenInfo.new(3 + math.random() * 4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, math.random() * 2), {Position = UDim2.new(p.Position.X.Scale, p.Position.X.Offset + sway, p.Position.Y.Scale, p.Position.Y.Offset)}):Play()
    TweenService:Create(p, TweenInfo.new(1.5 + math.random() * 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, math.random()), {BackgroundTransparency = 0.25 + math.random() * 0.2}):Play()
end

local Spotlight = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 300, 0, 300), BackgroundColor3 = Accent, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 0}, Main)
Corner(Spotlight, 300)
Tint(Spotlight, "BackgroundColor3")
TweenService:Create(Spotlight, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0), {BackgroundTransparency = 0.9}):Play()

local Flash = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 45, Visible = false}, Main)

-- ═══ EDGE PULSE (borde destella al parry) ═══
local EdgePulse = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 46, Visible = false}, Main)
Corner(EdgePulse, 20)
local EdgeStroke = New("UIStroke", {Color = Accent, Thickness = 2.5, Transparency = 1}, EdgePulse)
Tint(EdgeStroke, "Color")
local function FireEdgePulse()
    pcall(function()
        EdgePulse.Visible = true
        EdgeStroke.Transparency = 0.15
        EdgeStroke.Thickness = 4
        Tween(EdgeStroke, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1, Thickness = 1.5})
        task.delay(0.6, function() EdgePulse.Visible = false end)
    end)
end

-- ═══ SHOOTING STARS ═══
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(3 + math.random() * 5)
        pcall(function()
            local fl = math.random() > 0.5
            local sx, sy = fl and -30 or 590, math.random(10, 180)
            local ex, ey = fl and 590 or -30, sy + 90 + math.random(0, 90)
            local head = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, sx, 0, sy), Size = UDim2.new(0, 4, 0, 4), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 44}, Main)
            Corner(head, 3)
            local glow = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(2.6, 0, 2.6, 0), BackgroundColor3 = Accent, BackgroundTransparency = 0.75, BorderSizePixel = 0}, head)
            Corner(glow, 300)
            local tail = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, sx, 0, sy), Size = UDim2.new(0, 26, 0, 2.4), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.45, BorderSizePixel = 0, Rotation = math.deg(math.atan2(ey - sy, ex - sx))}, Main)
            Corner(tail, 2)
            local dur = 0.7 + math.random() * 0.4
            Tween(head, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0, ex, 0, ey), BackgroundTransparency = 1})
            Tween(glow, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            Tween(tail, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0, ex, 0, ey), Size = UDim2.new(0, 6, 0, 2.4), BackgroundTransparency = 1})
            task.delay(dur + 0.1, function() head:Destroy() tail:Destroy() end)
        end)
    end
end)

-- ═══ TWINKLES ═══
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1.5 + math.random() * 3)
        pcall(function()
            local h = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, math.random(20, 540), 0, math.random(20, 380)), Size = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 1, ZIndex = 43}, Main)
            local sc = New("UIScale", {Scale = 0}, h)
            local hb = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.15, BorderSizePixel = 0}, h)
            Corner(hb, 1)
            local vb = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.15, BorderSizePixel = 0}, h)
            Corner(vb, 1)
            Tween(sc, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
            task.delay(0.35, function()
                pcall(function()
                    Tween(sc, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
                    Tween(hb, TweenInfo.new(0.35), {BackgroundTransparency = 1})
                    Tween(vb, TweenInfo.new(0.35), {BackgroundTransparency = 1})
                end)
            end)
            task.delay(0.8, function() h:Destroy() end)
        end)
    end
end)

-- ═══ CURSOR TRAIL ═══
task.spawn(function()
    local lastT, lastP = 0, Vector2.new(0, 0)
    while ScreenGui.Parent do
        pcall(function()
            local s = math.max(uiScale.Scale, 0.01)
            local m = UserInputService:GetMouseLocation()
            local lp = Vector2.new((m.X - Main.AbsolutePosition.X) / s, (m.Y - Main.AbsolutePosition.Y) / s)
            if lp.X > 0 and lp.X < Main.AbsoluteSize.X / s and lp.Y > 0 and lp.Y < Main.AbsoluteSize.Y / s then
                local now = os.clock()
                if now - lastT > 0.05 and (lp - lastP).Magnitude > 6 then
                    lastT, lastP = now, lp
                    local dot = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, lp.X, 0, lp.Y), Size = UDim2.new(0, 7, 0, 7), BackgroundColor3 = Accent, BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 42}, Main)
                    Corner(dot, 300)
                    Tween(dot, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 1, 0, 1), BackgroundTransparency = 1, Position = UDim2.new(0, lp.X, 0, lp.Y - 3)})
                    task.delay(0.5, function() dot:Destroy() end)
                end
            end
        end)
        RunService.RenderStepped:Wait()
    end
end)

-- Motor de movimiento (parallax + spotlight)
local spotTarget = Vector2.new(280, 200)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        pcall(function()
            local s = math.max(uiScale.Scale, 0.01)
            spotTarget = Vector2.new((input.Position.X - Main.AbsolutePosition.X) / s, (input.Position.Y - Main.AbsolutePosition.Y) / s)
        end)
    end
end)
task.spawn(function()
    local spot = Vector2.new(280, 200)
    local par = Vector2.new(0, 0)
    while ScreenGui.Parent do
        pcall(function()
            local sz = Main.AbsoluteSize
            if sz.X > 10 and sz.Y > 10 then
                local m = UserInputService:GetMouseLocation()
                local tx = math.clamp((m.X - (Main.AbsolutePosition.X + sz.X / 2)) / sz.X, -0.5, 0.5)
                local ty = math.clamp((m.Y - (Main.AbsolutePosition.Y + sz.Y / 2)) / sz.Y, -0.5, 0.5)
                par = par:Lerp(Vector2.new(tx, ty), 0.07)
                spot = spot:Lerp(spotTarget, 0.1)
                DepthFar.Position = UDim2.new(0, -par.X * 16, 0, -par.Y * 12)
                DepthMid.Position = UDim2.new(0, -par.X * 8, 0, -par.Y * 6)
                DepthNear.Position = UDim2.new(0, -par.X * 4, 0, -par.Y * 3)
                Spotlight.Position = UDim2.new(0, spot.X, 0, spot.Y)
            end
        end)
        RunService.RenderStepped:Wait()
    end
end)

local function Confetti(x, y, count)
    pcall(function()
        for i = 1, (count or 8) do
            local part = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, x, 0, y), Size = UDim2.new(0, 4 + math.random(0, 3), 0, 4 + math.random(0, 3)), BackgroundColor3 = (i % 2 == 0) and Accent or Accent2, BorderSizePixel = 0, ZIndex = 46, Rotation = math.random(0, 360)}, Main)
            Corner(part, 2)
            local ang = math.rad(math.random(0, 359))
            local dist = 26 + math.random(0, 34)
            Tween(part, TweenInfo.new(0.45 + math.random() * 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, x + math.cos(ang) * dist, 0, y + math.sin(ang) * dist), BackgroundTransparency = 1, Rotation = part.Rotation + math.random(-200, 200)})
            task.delay(0.8, function() part:Destroy() end)
        end
    end)
end

-- ═══════════ HEADER + LOGO ═══════════
local Header = New("Frame", {Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, ZIndex = 5}, Main)
local LogoHolder = New("Frame", {Position = UDim2.new(0, 15, 0.5, -18), Size = UDim2.new(0, 36, 0, 36), BackgroundTransparency = 1, ZIndex = 6}, Header)
local LogoScale = New("UIScale", {Scale = 0}, LogoHolder)

task.spawn(function()
    while LogoHolder.Parent do
        pcall(function()
            local t1 = TweenService:Create(LogoHolder, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 15, 0.5, -16)})
            t1:Play() t1.Completed:Wait()
            local t2 = TweenService:Create(LogoHolder, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 15, 0.5, -20)})
            t2:Play() t2.Completed:Wait()
        end)
    end
end)

local LogoGlowA = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(2.5, 0, 2.5, 0), BackgroundColor3 = Accent, BackgroundTransparency = 0.93, BorderSizePixel = 0}, LogoHolder)
Corner(LogoGlowA, 300)
local LogoGlowB = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1.75, 0, 1.75, 0), BackgroundColor3 = Accent, BackgroundTransparency = 0.89, BorderSizePixel = 0}, LogoHolder)
Corner(LogoGlowB, 300)
Tint(LogoGlowA, "BackgroundColor3") Tint(LogoGlowB, "BackgroundColor3")
TweenService:Create(LogoGlowA, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0), {BackgroundTransparency = 0.86}):Play()

local LogoRing = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1.4, 0, 1.4, 0), BackgroundTransparency = 1}, LogoHolder)
Corner(LogoRing, 300)
local RingStroke = New("UIStroke", {Color = Accent, Thickness = 1.6}, LogoRing)
local RingGrad = New("UIGradient", {Color = ColorSequence.new(Accent2, Accent), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.45, 0.9), NumberSequenceKeypoint.new(1, 0.5)})}, RingStroke)
Tint(RingGrad, "Gradient")
TweenService:Create(RingGrad, TweenInfo.new(3.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0), {Rotation = 360}):Play()

local Logo = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Accent, BorderSizePixel = 0}, LogoHolder)
Corner(Logo, 11)
local LogoGrad = New("UIGradient", {Color = ColorSequence.new(Accent, Accent2), Rotation = 45}, Logo)
Tint(LogoGrad, "Gradient")
TweenService:Create(LogoGrad, TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0), {Rotation = 405}):Play()
local LogoShine = New("Frame", {Size = UDim2.new(1, 0, 0.55, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.5, BorderSizePixel = 0}, Logo)
Corner(LogoShine, 11)
New("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)}), Rotation = 90}, LogoShine)
local LogoText = New("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "U", Font = Enum.Font.GothamBlack, TextSize = 19, TextColor3 = Color3.new(1, 1, 1)}, Logo)
New("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(228, 218, 255)), Rotation = 90}, LogoText)

local LogoBtn = New("TextButton", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1.7, 0, 1.7, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 8}, LogoHolder)
local logoSpinning = false
local function LogoPing()
    local ring = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 36, 0, 36), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 7}, LogoHolder)
    Corner(ring, 300)
    local st = New("UIStroke", {Color = Accent, Thickness = 2.2, Transparency = 0.05}, ring)
    Tween(ring, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 86, 0, 86)})
    Tween(st, TweenInfo.new(0.55), {Transparency = 1, Thickness = 1})
    task.delay(0.6, function() ring:Destroy() end)
end
LogoBtn.MouseEnter:Connect(function() if not logoSpinning then Tween(LogoScale, Ease(0.25, Enum.EasingStyle.Back), {Scale = 1.12}) end end)
LogoBtn.MouseLeave:Connect(function() if not logoSpinning then Tween(LogoScale, Ease(0.2), {Scale = 1}) end end)
LogoBtn.MouseButton1Click:Connect(function()
    if logoSpinning then return end
    logoSpinning = true
    PlayClick(1.9, 0.16)
    LogoPing()
    Tween(LogoScale, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.3})
    Logo.Rotation = 0
    Tween(Logo, TweenInfo.new(0.62, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 360})
    task.delay(0.13, function() Tween(LogoScale, Ease(0.42, Enum.EasingStyle.Back), {Scale = 1}) end)
    AccentIndex = AccentIndex % 7 + 1
    if AccentIndex == 7 then
        rainbowMode = true
        local h = (os.clock() * 0.1) % 1
        ApplyAccent(Color3.fromHSV(h, 0.72, 1), Color3.fromHSV((h + 0.12) % 1, 0.72, 1), true)
    else
        rainbowMode = false
        ApplyAccent(ACCENT_PRESETS[AccentIndex][1], ACCENT_PRESETS[AccentIndex][2])
    end
    if SwatchRefresh then pcall(SwatchRefresh) end
    task.delay(0.66, function() Logo.Rotation = 0 logoSpinning = false Tween(LogoScale, Ease(0.2), {Scale = 1}) end)
end)

local Title = New("TextLabel", {Position = UDim2.new(0, 70, 0, 9), Size = UDim2.new(0, 260, 0, 20), BackgroundTransparency = 1, Text = "UwU Premium", Font = Enum.Font.GothamBold, TextSize = 17, TextColor3 = Color3.new(1, 1, 1), TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}, Header)
AnimateGradient(New("UIGradient", {}, Title), 0.09, 0.9, 1)
New("UIStroke", {Color = Color3.fromRGB(55, 58, 82), Thickness = 1.1, Transparency = 0.6}, Title)

local StatusDot = New("Frame", {Position = UDim2.new(0, 63, 0, 35), Size = UDim2.new(0, 5, 0, 5), BackgroundColor3 = Accent, BorderSizePixel = 0}, Header)
Corner(StatusDot, 3)
Tint(StatusDot, "BackgroundColor3")
TweenService:Create(StatusDot, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0), {BackgroundTransparency = 0.55}):Play()
local HeaderSub = New("TextLabel", {Position = UDim2.new(0, 74, 0, 31), Size = UDim2.new(0, 320, 0, 13), BackgroundTransparency = 1, Text = "UwU Fix - zPxnchiSkixlled", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.SubInv, TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}, Header)

local function HeaderBtn(txt, x, hoverCol)
    local b = New("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, x, 0.5, 0), Size = UDim2.new(0, 29, 0, 29), BackgroundColor3 = Theme.Card, Text = txt, Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = Theme.Text, AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true}, Header)
    Corner(b, 15)
    local st = Stroke(b, Theme.Stroke, 1, 0.1)
    local bs = New("UIScale", {Scale = 1}, b)
    table.insert(ThemeLinks, function() b.BackgroundColor3 = Theme.Card st.Color = Theme.Stroke b.TextColor3 = Theme.Text end)
    b.MouseEnter:Connect(function() Tween(b, Ease(0.15), {BackgroundColor3 = hoverCol}) Tween(st, Ease(0.15), {Transparency = 0}) Tween(bs, Ease(0.25, Enum.EasingStyle.Back), {Scale = 1.1}) end)
    b.MouseLeave:Connect(function() Tween(b, Ease(0.25), {BackgroundColor3 = Theme.Card}) Tween(st, Ease(0.25), {Transparency = 0.1}) Tween(bs, Ease(0.2), {Scale = 1}) end)
    ClickRipple(b) MakeMagnetic(b, 3)
    return b
end
local MinBtn = HeaderBtn("-", -45, BASE.CardHover)
local CloseBtn = HeaderBtn("X", -11, Color3.fromRGB(205, 95, 100))

local TopGlow = New("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 54), Size = UDim2.new(0, 0, 0, 8), BackgroundColor3 = Accent, BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 3}, Main)
Corner(TopGlow, 4)
local TopGlowGrad = New("UIGradient", {Color = ColorSequence.new(Accent2, Accent), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 1)})}, TopGlow)
Tint(TopGlowGrad, "Gradient")
local TopLine = New("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 56), Size = UDim2.new(0, 0, 0, 2.5), BackgroundColor3 = Accent, BorderSizePixel = 0, ZIndex = 4}, Main)
local TopGrad = New("UIGradient", {Color = ColorSequence.new(Accent2, Accent), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.05), NumberSequenceKeypoint.new(1, 1)})}, TopLine)
Tint(TopGrad, "Gradient")
local BotGlow = New("Frame", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -10), Size = UDim2.new(0, 0, 0, 8), BackgroundColor3 = Accent, BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 3}, Main)
Corner(BotGlow, 4)
local BotGlowGrad = New("UIGradient", {Color = ColorSequence.new(Accent, Accent2), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 1)})}, BotGlow)
Tint(BotGlowGrad, "Gradient")
local BotLine = New("Frame", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2.5), Size = UDim2.new(0, 0, 0, 2.5), BackgroundColor3 = Accent, BorderSizePixel = 0, ZIndex = 4}, Main)
local BotGrad = New("UIGradient", {Color = ColorSequence.new(Accent, Accent2), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.05), NumberSequenceKeypoint.new(1, 1)})}, BotLine)
Tint(BotGrad, "Gradient")

task.spawn(function()
    while ScreenGui.Parent do
        TopGrad.Offset = Vector2.new(-1, 0) TopGlowGrad.Offset = Vector2.new(-1, 0) BotGrad.Offset = Vector2.new(-1, 0) BotGlowGrad.Offset = Vector2.new(-1, 0)
        local ok = pcall(function()
            local a = TweenService:Create(TopGrad, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)})
            local b = TweenService:Create(TopGlowGrad, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)})
            local c = TweenService:Create(BotGrad, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)})
            local d = TweenService:Create(BotGlowGrad, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)})
            a:Play() b:Play() c:Play() d:Play() a.Completed:Wait()
        end)
        if not ok then break end
    end
end)

-- ═══════════ SIDEBAR ═══════════
local Sidebar = New("Frame", {Position = UDim2.new(0, 12, 0, 64), Size = UDim2.new(0, 148, 0, 292), BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 0.15, BorderSizePixel = 0}, Main)
Corner(Sidebar, 14)
Stroke(Sidebar, Color3.new(1, 1, 1), 1, 0.55)
New("TextLabel", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -10), Size = UDim2.new(1, -28, 0, 12), BackgroundTransparency = 1, Text = "zPxnchiSkixlled", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.SubInv, TextXAlignment = Enum.TextXAlignment.Left}, Sidebar)
local TabHolder = New("Frame", {Position = UDim2.new(0, 10, 0, 12), Size = UDim2.new(1, -20, 0, 0), BackgroundTransparency = 1, ZIndex = 2}, Sidebar)
New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, TabHolder)
local Indicator = New("Frame", {Position = UDim2.new(0, 10, 0, 12), Size = UDim2.new(0, 128, 0, 38), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 1}, Sidebar)
Corner(Indicator, 11)
Stroke(Indicator, Color3.new(1, 1, 1), 1, 0.5)
local IndBar = New("Frame", {Position = UDim2.new(0, 0, 0.5, -8), Size = UDim2.new(0, 3, 0, 16), BackgroundColor3 = Accent, BorderSizePixel = 0, ZIndex = 2}, Indicator)
Corner(IndBar, 2)
Tint(IndBar, "BackgroundColor3")

-- ═══════════ SEARCH BAR ═══════════
local SearchGlow = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 80), Size = UDim2.new(0, 380, 0, 46), BackgroundColor3 = Accent, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 4}, Main)
Corner(SearchGlow, 300)
Tint(SearchGlow, "BackgroundColor3")
local SearchBar = New("Frame", {Position = UDim2.new(0, 172, 0, 64), Size = UDim2.new(1, -184, 0, 32), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 5}, Main)
Corner(SearchBar, 16)
local SearchStroke = Stroke(SearchBar, Theme.Stroke, 1, 0.15)
local SearchIconHolder = New("Frame", {Position = UDim2.new(0, 11, 0.5, -8), Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1, ZIndex = 6}, SearchBar)
local SearchIconScale = New("UIScale", {Scale = 1}, SearchIconHolder)
local Lens = New("Frame", {Size = UDim2.new(0, 11, 0, 11), BackgroundTransparency = 1}, SearchIconHolder)
Corner(Lens, 300)
local LensStroke = New("UIStroke", {Color = Theme.Sub, Thickness = 1.8}, Lens)
local LensHandle = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 7, 0, 2.2), BackgroundColor3 = Theme.Sub, BorderSizePixel = 0, Rotation = 45, ZIndex = 6}, SearchIconHolder)
Corner(LensHandle, 1)
local SearchPlaceholder = New("TextLabel", {Position = UDim2.new(0, 36, 0, 0), Size = UDim2.new(1, -110, 1, 0), BackgroundTransparency = 1, Text = "Search features...  [/]", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, SearchBar)
local SearchBox = New("TextBox", {Position = UDim2.new(0, 36, 0, 0), Size = UDim2.new(1, -104, 1, 0), BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 7}, SearchBar)
local SearchCount = New("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -34, 0, 0), Size = UDim2.new(0, 90, 1, 0), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Center, Visible = false, ZIndex = 6}, SearchBar)
local SearchClear = New("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.new(0, 19, 0, 19), BackgroundColor3 = Theme.Track, Text = "X", Font = Enum.Font.GothamBlack, TextSize = 9, TextColor3 = Theme.Inv, AutoButtonColor = false, BorderSizePixel = 0, Visible = false, ZIndex = 6}, SearchBar)
Corner(SearchClear, 10)

table.insert(ThemeLinks, function()
    local iconCol = (searchFocused or SearchBox.Text ~= "") and Accent or Theme.Sub
    SearchBar.BackgroundColor3 = Theme.Card
    SearchStroke.Color = iconCol
    LensStroke.Color = iconCol
    LensHandle.BackgroundColor3 = iconCol
    SearchPlaceholder.TextColor3 = Theme.Sub
    SearchBox.TextColor3 = Theme.Text
    SearchCount.TextColor3 = Theme.Sub
    SearchClear.BackgroundColor3 = Theme.Track
    SearchClear.TextColor3 = Theme.Inv
end)

local function RefreshSearchStyle()
    local active = searchFocused or SearchBox.Text ~= ""
    Tween(SearchStroke, Ease(0.2), {Color = active and Accent or Theme.Stroke, Transparency = active and 0 or 0.15})
    Tween(SearchGlow, Ease(0.25), {BackgroundTransparency = active and 0.86 or 1})
    Tween(LensStroke, Ease(0.2), {Color = active and Accent or Theme.Sub})
    Tween(LensHandle, Ease(0.2), {BackgroundColor3 = active and Accent or Theme.Sub})
end

SearchBox.Focused:Connect(function()
    searchFocused = true
    RefreshSearchStyle()
    Tween(SearchIconScale, Ease(0.35, Enum.EasingStyle.Back), {Scale = 1.35})
    task.delay(0.35, function() Tween(SearchIconScale, Ease(0.25), {Scale = 1}) end)
end)
SearchBox.FocusLost:Connect(function() searchFocused = false RefreshSearchStyle() end)
SearchClear.MouseButton1Click:Connect(function() PlayClick(1.3) SearchBox.Text = "" end)

-- ═══════════ CONTENT ═══════════
local Scroll = New("ScrollingFrame", {Position = UDim2.new(0, 172, 0, 104), Size = UDim2.new(1, -184, 0, 252), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(85, 90, 118), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y}, Main)
New("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 8)}, Scroll)

-- ═══════════ TOASTS ═══════════
local ToastHolder = New("Frame", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -24), Size = UDim2.new(0, 320, 0, 300), BackgroundTransparency = 1}, ScreenGui)
New("UIListLayout", {Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Center}, ToastHolder)

local function Toast(title, msg, color)
    pcall(function()
        local col = color or Accent
        local root = New("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundTransparency = 1}, ToastHolder)
        local grp = New("CanvasGroup", {Position = UDim2.new(0, 0, 0, 28), Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.05, BorderSizePixel = 0, GroupTransparency = 1, ClipsDescendants = true}, root)
        Corner(grp, 12)
        Stroke(grp, Theme.Stroke, 1, 0.1)
        local ic = New("Frame", {Position = UDim2.new(0, 12, 0.5, -13), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = col, BorderSizePixel = 0}, grp)
        Corner(ic, 13)
        New("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = tostring(title):sub(1, 1), Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = Color3.new(1, 1, 1)}, ic)
        New("TextLabel", {Position = UDim2.new(0, 48, 0, 10), Size = UDim2.new(1, -60, 0, 16), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, grp)
        New("TextLabel", {Position = UDim2.new(0, 48, 0, 28), Size = UDim2.new(1, -60, 0, 14), BackgroundTransparency = 1, Text = msg, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left}, grp)
        local prog = New("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = col, BorderSizePixel = 0}, grp)
        Tween(prog, TweenInfo.new(2.6, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
        Tween(grp, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
        task.delay(2.6, function()
            Tween(grp, Ease(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1, Position = UDim2.new(0, 0, 0, 14)})
            task.delay(0.32, function() root:Destroy() end)
        end)
    end)
end

-- ═══════════ TAB ICONS ═══════════
local function MakeTabIcon(kind, holder)
    local parts, partsDark = {}, {}
    local function P(props, round, dark)
        local f = New("Frame", props, holder)
        f.BorderSizePixel = 0
        if round then Corner(f, round) end
        table.insert(dark and partsDark or parts, f)
        return f
    end
    if kind == "swords" then
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 17, 0, 2.6), BackgroundColor3 = Theme.SubInv, Rotation = 45}, 2)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 17, 0, 2.6), BackgroundColor3 = Theme.SubInv, Rotation = -45}, 2)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 6.3, 0, 17.7), Size = UDim2.new(0, 6.5, 0, 2.2), BackgroundColor3 = Theme.SubInv, Rotation = -45}, 2)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 17.7, 0, 17.7), Size = UDim2.new(0, 6.5, 0, 2.2), BackgroundColor3 = Theme.SubInv, Rotation = 45}, 2)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 4.7, 0, 19.3), Size = UDim2.new(0, 4.5, 0, 2.2), BackgroundColor3 = Theme.SubInv, Rotation = 45}, 2)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 19.3, 0, 19.3), Size = UDim2.new(0, 4.5, 0, 2.2), BackgroundColor3 = Theme.SubInv, Rotation = -45}, 2)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 3, 0, 3), BackgroundColor3 = Theme.SubInv, Rotation = 45}, 1)
    else
        for i = 1, 8 do
            local ang = math.rad((i - 1) * 45 - 90)
            P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12 + math.cos(ang) * 10.4, 0, 12 + math.sin(ang) * 10.4), Size = UDim2.new(0, 3.1, 0, 4.4), BackgroundColor3 = Theme.SubInv, Rotation = (i - 1) * 45}, 1.2)
        end
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 14.8, 0, 14.8), BackgroundColor3 = Theme.SubInv}, 300)
        local hole = P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 6.4, 0, 6.4), BackgroundColor3 = Theme.SubInv, BackgroundTransparency = 1}, 300)
        local ring = New("UIStroke", {Color = Theme.SubInv, Thickness = 1.4}, hole)
        table.insert(partsDark, ring)
        P({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(0, 3.4, 0, 3.4), BackgroundColor3 = Theme.SubInv}, 2)
    end
    local function setCol(c)
        local cDark = Color3.new(c.R * 0.62, c.G * 0.62, c.B * 0.62)
        for _, p in ipairs(parts) do p.BackgroundColor3 = c end
        for _, p in ipairs(partsDark) do
            if p:IsA("UIStroke") then p.Color = cDark else p.BackgroundColor3 = cDark end
        end
    end
    return setCol
end

-- ═══════════ PAGES ═══════════
local Pages, TabButtons = {}, {}
local currentTab = 0

local function SelectTab(i)
    currentTab = i
    Flash.Visible = true
    Flash.BackgroundTransparency = 0.88
    Tween(Flash, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    Tween(Indicator, Ease(0.45, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 10, 0, 12 + (i - 1) * 44)})
    for idx, page in ipairs(Pages) do
        if idx == i then
            page.frame.Visible = true
            page.frame.GroupTransparency = 1
            page.frame.Position = UDim2.new(0, 14, 0, 0)
            Tween(page.frame, Ease(0.4, Enum.EasingStyle.Quint), {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
            for ci, card in ipairs(page.cards) do
                card.GroupTransparency = 1
                task.delay(0.05 + ci * 0.045, function()
                    if page.frame.Visible and currentTab == idx and not SearchActiveFlag then
                        Tween(card, Ease(0.3, Enum.EasingStyle.Quint), {GroupTransparency = 0})
                    end
                end)
            end
        elseif page.frame.Visible then
            page.frame.Visible = false
        end
    end
    for idx, t in ipairs(TabButtons) do
        Tween(t.label, Ease(0.25), {TextColor3 = idx == i and Theme.Text or Theme.SubInv})
        if t.setCol then t.setCol(idx == i and Accent or Theme.SubInv) end
    end
end

local function NewPage(name, iconKind)
    local page = {cards = {}}
    page.frame = New("CanvasGroup", {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, GroupTransparency = 1}, Scroll)
    New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, page.frame)
    local n = 0
    page.ord = function() n = n + 1 return n end
    local idx = #Pages + 1
    local b = New("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = idx}, TabHolder)
    local icoHolder = New("Frame", {Position = UDim2.new(0, 12, 0, 7), Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 1}, b)
    local setIconCol = MakeTabIcon(iconKind, icoHolder)
    local txt = New("TextLabel", {Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -42, 1, 0), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.SubInv, TextXAlignment = Enum.TextXAlignment.Left}, b)
    table.insert(Dynamic, function() if idx == currentTab then setIconCol(Accent) end end)
    b.MouseEnter:Connect(function()
        Tween(txt, Ease(0.18), {Position = UDim2.new(0, 46, 0, 0), TextColor3 = idx == currentTab and Theme.Text or Color3.fromRGB(50, 55, 78)})
        Tween(icoHolder, Ease(0.18), {Position = UDim2.new(0, 15, 0, 7)})
    end)
    b.MouseLeave:Connect(function()
        Tween(txt, Ease(0.22), {Position = UDim2.new(0, 42, 0, 0), TextColor3 = idx == currentTab and Theme.Text or Theme.SubInv})
        Tween(icoHolder, Ease(0.22), {Position = UDim2.new(0, 12, 0, 7)})
    end)
    b.MouseButton1Click:Connect(function() PlayClick(1.45) if SearchActiveFlag then SearchBox.Text = "" end SelectTab(idx) end)
    table.insert(Pages, page)
    table.insert(TabButtons, {label = txt, setCol = setIconCol})
    return page
end

-- ═══════════ SEARCH LOGIC ═══════════
local SearchPage = New("CanvasGroup", {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, GroupTransparency = 0}, Scroll)
New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, SearchPage)

local SearchEmpty = New("Frame", {Position = UDim2.new(0, 0, 0, 60), Size = UDim2.new(1, -14, 0, 150), BackgroundTransparency = 1, Visible = false, ZIndex = 20}, Scroll)
local SearchEmptyCircle = New("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(0, 56, 0, 56), BackgroundColor3 = Theme.Card, BorderSizePixel = 0}, SearchEmpty)
Corner(SearchEmptyCircle, 300)
Stroke(SearchEmptyCircle, Theme.Stroke, 1, 0.2)
New("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "?", Font = Enum.Font.GothamBlack, TextSize = 24, TextColor3 = Theme.Sub}, SearchEmptyCircle)
New("TextLabel", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 68), Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = "No results found", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Text}, SearchEmpty)
local SearchEmptyText = New("TextLabel", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 88), Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub}, SearchEmpty)

local function RestoreFromSearch(reshow)
    SearchActiveFlag = false
    for _, e in ipairs(SearchEntries) do
        if e.card.Parent ~= e.page then
            e.card.LayoutOrder = e.origOrder
            e.card.Parent = e.page
        end
        e.card.Visible = true
        if e.card:IsA("CanvasGroup") then e.card.GroupTransparency = 0 end
    end
    SearchPage.Visible = false
    SearchEmpty.Visible = false
    for _, page in ipairs(Pages) do page.frame.Visible = false end
    if reshow then SelectTab(currentTab) end
end

local function PerformSearch(text)
    text = tostring(text or "")
    if text == "" then
        if SearchActiveFlag then RestoreFromSearch(true) end
        SearchCount.Visible = false
        SearchClear.Visible = false
        SearchPlaceholder.Visible = true
        RefreshSearchStyle()
        return
    end
    local q = text:lower()
    if not SearchActiveFlag then
        SearchActiveFlag = true
        for _, page in ipairs(Pages) do page.frame.Visible = false end
        SearchPage.Visible = true
        SearchPage.GroupTransparency = 1
        Tween(SearchPage, Ease(0.3, Enum.EasingStyle.Quint), {GroupTransparency = 0})
    end
    local n = 0
    for _, e in ipairs(SearchEntries) do
        local match = e.name:lower():find(q, 1, true) or (e.desc and e.desc:lower():find(q, 1, true))
        if match then
            n = n + 1
            if e.card.Parent ~= SearchPage then
                e.card.LayoutOrder = e.searchOrder
                e.card.Parent = SearchPage
                e.card.Visible = true
                if e.card:IsA("CanvasGroup") then
                    e.card.GroupTransparency = 1
                    Tween(e.card, Ease(0.25, Enum.EasingStyle.Quint), {GroupTransparency = 0})
                end
            end
        else
            e.card.Visible = false
        end
    end
    SearchEmpty.Visible = (n == 0)
    SearchEmptyText.Text = 'Nothing matches "' .. text .. '"'
    SearchCount.Text = n .. " found"
    SearchCount.Visible = true
    SearchPlaceholder.Visible = false
    SearchClear.Visible = true
    RefreshSearchStyle()
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    pcall(function() PerformSearch(SearchBox.Text) end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if anyListening > 0 then return end
    if input.KeyCode == Enum.KeyCode.Slash then
        if not searchFocused and Main.Visible then
            SearchBox:CaptureFocus()
            task.defer(function() if SearchBox.Text == "/" then SearchBox.Text = "" end end)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if anyListening > 0 or searchFocused or gp then return end
    local fn = KeyBinds[input.KeyCode]
    if fn then pcall(fn) end
end)

local function shortKey(kc)
    if typeof(kc) ~= "EnumItem" then return "-" end
    local n = kc.Name
    n = n:gsub("Right", "R"):gsub("Left", "L"):gsub("Control", "Ctrl")
    if #n > 9 then n = n:sub(1, 9) end
    return n
end

-- ═══════════ COMPONENTS ═══════════
local function Card(page, h)
    local c = New("CanvasGroup", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.08, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = page.ord()}, page.frame)
    Corner(c, 12)
    local st = Stroke(c, Theme.Stroke, 1, 0.35)
    New("Frame", {Position = UDim2.new(0, 3, 0, 1), Size = UDim2.new(1, -6, 0, 1.5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 2}, c)
    local shine = New("Frame", {Position = UDim2.new(-0.35, 0, -0.6, 0), Size = UDim2.new(0.16, 0, 2.2, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Rotation = 16, ZIndex = 30}, c)
    Corner(shine, 200)
    table.insert(ThemeLinks, function() c.BackgroundColor3 = Theme.Card st.Color = Theme.Stroke end)
    c.MouseEnter:Connect(function()
        Tween(c, Ease(0.2), {BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 0})
        Tween(st, Ease(0.2), {Transparency = 0.05})
        shine.Position = UDim2.new(-0.35, 0, -0.6, 0)
        shine.BackgroundTransparency = 0.72
        Tween(shine, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1.3, 0, -0.6, 0)})
    end)
    c.MouseLeave:Connect(function()
        Tween(c, Ease(0.3), {BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.08})
        Tween(st, Ease(0.3), {Transparency = 0.35})
        Tween(c, Ease(0.35, Enum.EasingStyle.Back), {Rotation = 0})
    end)
    c.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            pcall(function()
                local dx = (input.Position.X - (c.AbsolutePosition.X + c.AbsoluteSize.X / 2)) / math.max(c.AbsoluteSize.X / 2, 1)
                c.Rotation = math.clamp(dx * 1.4, -1.4, 1.4)
            end)
        end
    end)
    table.insert(page.cards, c)
    return c
end

local function Toggle(page, name, desc, default, callback, keyDefault)
    local hasKey = keyDefault ~= nil
    local h = desc and 58 or 44
    local c = Card(page, h)
    RegisterSearch(name, desc, c)
    local labelW = hasKey and -146 or -84
    local nameLbl = New("TextLabel", {Position = UDim2.new(0, 14, 0, desc and 10 or 0), Size = UDim2.new(1, labelW, 0, desc and 16 or h), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = desc and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center}, c)
    if desc then
        New("TextLabel", {Position = UDim2.new(0, 14, 0, 29), Size = UDim2.new(1, labelW, 0, 14), BackgroundTransparency = 1, Text = desc, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left}, c)
    end
    local glow = New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -11, 0.5, 0), Size = UDim2.new(0, 56, 0, 33), BackgroundColor3 = Accent, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1}, c)
    Corner(glow, 17)
    Tint(glow, "BackgroundColor3")
    local switch = New("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.new(0, 50, 0, 26), BackgroundColor3 = Theme.Track, Text = "", AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2}, c)
    Corner(switch, 13)
    local sStroke = Stroke(switch, Theme.Stroke, 1, 0)
    local knob = New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, switch)
    Corner(knob, 10)
    local state = default and true or false
    local bindKey = keyDefault
    local kchip, kstroke, kscale = nil, nil, nil
    local listening, pulseTween = false, nil

    local function apply(dur)
        local ti = TweenInfo.new(dur or 0, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Tween(switch, ti, {BackgroundColor3 = state and Accent or Theme.Track})
        Tween(sStroke, ti, {Color = state and Accent or Theme.Stroke})
        Tween(glow, TweenInfo.new(dur or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = state and 0.78 or 1})
        Tween(knob, ti, {Position = UDim2.new(0, state and 27 or 3, 0.5, 0)})
    end
    apply(0)
    table.insert(Dynamic, function() apply(0) end)
    table.insert(ThemeLinks, function()
        nameLbl.TextColor3 = Theme.Text
        apply(0)
        if kchip then kchip.BackgroundColor3 = Theme.Track kchip.TextColor3 = Theme.Inv end
        if kstroke then kstroke.Color = Theme.Stroke end
    end)
    ClickRipple(switch)
    MakeMagnetic(switch, 3)

    local function performToggle(fromKey)
        state = not state
        apply(0.32)
        PlayClick(state and 1.7 or 1.25)
        if state then
            PingRing(c)
            pcall(function()
                local s = math.max(uiScale.Scale, 0.01)
                Confetti((c.AbsolutePosition.X - Main.AbsolutePosition.X + c.AbsoluteSize.X - 40) / s, (c.AbsolutePosition.Y - Main.AbsolutePosition.Y + c.AbsoluteSize.Y / 2) / s)
            end)
        end
        if fromKey and kchip then
            Tween(kchip, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundColor3 = Accent, TextColor3 = Color3.new(1, 1, 1)})
            task.delay(0.1, function() Tween(kchip, Ease(0.45), {BackgroundColor3 = Theme.Track, TextColor3 = Theme.Inv}) end)
        end
        callback(state)
    end

    switch.MouseButton1Click:Connect(function() performToggle(false) end)

    if hasKey then
        kchip = New("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -72, 0.5, 0), Size = UDim2.new(0, 52, 0, 24), BackgroundColor3 = Theme.Track, Text = shortKey(bindKey), Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.Inv, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 3}, c)
        Corner(kchip, 7)
        kstroke = Stroke(kchip, Theme.Stroke, 1, 0)
        kscale = New("UIScale", {Scale = 1}, kchip)
        kchip.MouseEnter:Connect(function() if not listening then Tween(kchip, Ease(0.15), {BackgroundColor3 = Theme.CardHover}) end end)
        kchip.MouseLeave:Connect(function() if not listening then Tween(kchip, Ease(0.25), {BackgroundColor3 = Theme.Track}) end end)
        local function stopListen()
            listening = false
            anyListening = math.max(anyListening - 1, 0)
            if pulseTween then pulseTween:Cancel() pulseTween = nil end
            Tween(kstroke, Ease(0.25), {Color = Theme.Stroke, Transparency = 0})
            kchip.Text = bindKey and shortKey(bindKey) or "-"
            Tween(kchip, Ease(0.25), {BackgroundColor3 = Theme.Track})
        end
        local function clearKey()
            if bindKey then KeyBinds[bindKey] = nil end
            bindKey = nil
            kchip.Text = "-"
        end
        local function setKey(kc)
            if bindKey then KeyBinds[bindKey] = nil end
            bindKey = kc
            if kc then
                KeyBinds[kc] = function() performToggle(true) end
                kchip.Text = shortKey(kc)
            else
                kchip.Text = "-"
            end
        end
        setKey(keyDefault)
        kchip.MouseButton1Click:Connect(function()
            if listening then stopListen() return end
            listening = true
            anyListening = anyListening + 1
            kchip.Text = "..."
            kstroke.Color = Accent
            pulseTween = TweenService:Create(kstroke, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.6})
            pulseTween:Play()
            PlayClick(1.9, 0.15)
            Toast("Keybind", "Press a key - Backspace removes - Esc cancels", Theme.Sub)
        end)
        kchip.MouseButton2Click:Connect(function()
            if listening then stopListen() end
            clearKey()
            PlayClick(1.0)
        end)
        UserInputService.InputBegan:Connect(function(input, gp)
            if not listening then return end
            if input.KeyCode == Enum.KeyCode.Escape then stopListen() return end
            if input.KeyCode == Enum.KeyCode.Backspace then
                stopListen() clearKey()
                Tween(kchip, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundColor3 = Theme.Warn, TextColor3 = Color3.new(1, 1, 1)})
                task.delay(0.12, function() Tween(kchip, Ease(0.4), {BackgroundColor3 = Theme.Track, TextColor3 = Theme.Inv}) end)
                PlayClick(1.0)
                return
            end
            if gp or input.KeyCode == Enum.KeyCode.Unknown then return end
            stopListen() setKey(input.KeyCode) PlayClick(1.8)
        end)
    end

    return {
        Set = function(v) if v == nil then return end state = v and true or false apply(0.15) callback(state) end,
        Get = function() return state end,
        SetKey = function(k) if hasKey and kchip then setKey(k) end end,
        GetKey = function() return bindKey end,
    }
end

local function Dropdown(page, name, options, default, callback)
    local optH, headerH = 30, 44
    local c = Card(page, headerH)
    RegisterSearch(name, nil, c)
    local label = New("TextLabel", {Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -215, 0, headerH), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center}, c)
    local valPill = New("Frame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -34, 0, 10), Size = UDim2.new(0, 132, 0, 24), BackgroundColor3 = Theme.Track, BorderSizePixel = 0, ZIndex = 3}, c)
    Corner(valPill, 12)
    local valPillStroke = Stroke(valPill, Theme.Stroke, 1, 0.15)
    local val = New("TextLabel", {Size = UDim2.new(1, -12, 1, 0), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Inv, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 4}, valPill)
    local chev = New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0, headerH / 2), Size = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 1, ZIndex = 3}, c)
    local chev1 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 4.5, 0, 5), Size = UDim2.new(0, 7.5, 0, 2.2), BackgroundColor3 = Theme.Sub, BorderSizePixel = 0, Rotation = -50, ZIndex = 3}, chev)
    Corner(chev1, 1)
    local chev2 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 9.5, 0, 5), Size = UDim2.new(0, 7.5, 0, 2.2), BackgroundColor3 = Theme.Sub, BorderSizePixel = 0, Rotation = 50, ZIndex = 3}, chev)
    Corner(chev2, 1)
    local sel = (default and table.find(options, default)) or 1
    val.Text = tostring(options[sel])
    local hilite = New("Frame", {Position = UDim2.new(0, 8, 0, headerH + 3), Size = UDim2.new(1, -16, 0, optH - 5), BackgroundColor3 = Accent, BackgroundTransparency = 0.86, BorderSizePixel = 0, ZIndex = 1}, c)
    Corner(hilite, 8)
    Tint(hilite, "BackgroundColor3")
    local optBtns, optTxts, optChecks, optBgs = {}, {}, {}, {}
    local function refreshOpts()
        for i, ob in ipairs(optBtns) do
            optTxts[i].TextColor3 = (i == sel) and Theme.Text or Theme.Sub
            if optChecks[i] then optChecks[i].sc.Scale = (i == sel) and 1 or 0 end
        end
        Tween(hilite, Ease(0.35, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 8, 0, headerH + 3 + (sel - 1) * optH)})
    end
    local open = false
    local setOpen
    for i, opt in ipairs(options) do
        local ob = New("TextButton", {Position = UDim2.new(0, 8, 0, headerH + 3 + (i - 1) * optH), Size = UDim2.new(1, -16, 0, optH - 5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 3}, c)
        Corner(ob, 8)
        local hbg = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Track, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2}, ob)
        Corner(hbg, 8)
        local otxt = New("TextLabel", {Position = UDim2.new(0, 11, 0, 0), Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1, Text = tostring(opt), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextTransparency = 1, ZIndex = 4}, ob)
        local chk = New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -11, 0.5, 0), Size = UDim2.new(0, 12, 0, 12), BackgroundTransparency = 1, ZIndex = 4}, ob)
        local chkScale = New("UIScale", {Scale = 0}, chk)
        local b1 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 3.5, 0, 7), Size = UDim2.new(0, 5.5, 0, 2), BackgroundColor3 = Accent, BorderSizePixel = 0, Rotation = 45, ZIndex = 4}, chk)
        Corner(b1, 1)
        local b2 = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 7.5, 0, 4), Size = UDim2.new(0, 8.5, 0, 2), BackgroundColor3 = Accent, BorderSizePixel = 0, Rotation = -55, ZIndex = 4}, chk)
        Corner(b2, 1)
        table.insert(optBtns, ob) table.insert(optTxts, otxt) table.insert(optBgs, hbg)
        table.insert(optChecks, {sc = chkScale, b1 = b1, b2 = b2})
        ob.MouseEnter:Connect(function() Tween(hbg, Ease(0.15), {BackgroundTransparency = 0.88}) Tween(otxt, Ease(0.18), {Position = UDim2.new(0, 15, 0, 0), TextColor3 = Theme.Text}) end)
        ob.MouseLeave:Connect(function() Tween(hbg, Ease(0.25), {BackgroundTransparency = 1}) Tween(otxt, Ease(0.22), {Position = UDim2.new(0, 11, 0, 0)}) refreshOpts() end)
        ob.MouseButton1Click:Connect(function()
            sel = i
            val.Text = tostring(options[i])
            refreshOpts()
            Tween(valPill, TweenInfo.new(0.1), {BackgroundColor3 = Accent})
            Tween(valPillStroke, TweenInfo.new(0.1), {Color = Accent, Transparency = 0})
            Tween(val, TweenInfo.new(0.1), {TextColor3 = Color3.new(1, 1, 1)})
            task.delay(0.18, function()
                Tween(valPill, Ease(0.4), {BackgroundColor3 = Theme.Track})
                Tween(valPillStroke, Ease(0.4), {Color = Theme.Stroke, Transparency = 0.15})
                Tween(val, Ease(0.4), {TextColor3 = Theme.Inv})
            end)
            if optChecks[i] then
                optChecks[i].sc.Scale = 0
                Tween(optChecks[i].sc, Ease(0.4, Enum.EasingStyle.Back), {Scale = 1.25})
                task.delay(0.18, function() Tween(optChecks[i].sc, Ease(0.2), {Scale = 1}) end)
            end
            PlayClick(1.65)
            callback(options[i])
            if open then setOpen(false) end
        end)
    end
    table.insert(ThemeLinks, function()
        label.TextColor3 = Theme.Sub valPill.BackgroundColor3 = Theme.Track valPillStroke.Color = Theme.Stroke val.TextColor3 = Theme.Inv
        chev1.BackgroundColor3 = Theme.Sub chev2.BackgroundColor3 = Theme.Sub
        for _, hbg in ipairs(optBgs) do hbg.BackgroundColor3 = Theme.Track end
        refreshOpts()
    end)
    table.insert(Dynamic, function() for _, ck in ipairs(optChecks) do ck.b1.BackgroundColor3 = Accent ck.b2.BackgroundColor3 = Accent end end)
    refreshOpts()
    setOpen = function(v)
        open = v
        Tween(c, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, v and (headerH + #options * optH + 10) or headerH)})
        Tween(chev, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = v and 180 or 0})
        Tween(chev1, Ease(0.3), {BackgroundColor3 = v and Accent or Theme.Sub})
        Tween(chev2, Ease(0.3), {BackgroundColor3 = v and Accent or Theme.Sub})
        for i, otxt in ipairs(optTxts) do
            if v then
                task.delay(0.04 + i * 0.035, function() otxt.Position = UDim2.new(0, 3, 0, 0) Tween(otxt, Ease(0.3, Enum.EasingStyle.Quint), {TextTransparency = 0, Position = UDim2.new(0, 11, 0, 0)}) end)
            else
                Tween(otxt, TweenInfo.new(0.1), {TextTransparency = 1})
            end
        end
    end
    local hit = New("TextButton", {Size = UDim2.new(1, 0, 0, headerH), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 6}, c)
    hit.MouseButton1Click:Connect(function() PlayClick(open and 1.15 or 1.35) setOpen(not open) end)
    return {
        Set = function(v) local i = table.find(options, v) if not i then return end sel = i val.Text = tostring(options[i]) refreshOpts() callback(options[i]) end,
        Get = function() return options[sel] end,
    }
end

local function Slider(page, name, min, max, default, suffix, decimals, callback)
    local c = Card(page, 88)
    RegisterSearch(name, nil, c)
    local nameLbl = New("TextLabel", {Position = UDim2.new(0, 14, 0, 12), Size = UDim2.new(1, -110, 0, 16), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, c)
    local Chip = New("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 9), AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 22), BackgroundColor3 = Theme.Track, Text = "", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Inv, BorderSizePixel = 0}, c)
    Corner(Chip, 11)
    New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, Chip)
    local chipScale = New("UIScale", {Scale = 1}, Chip)
    local chipStroke = Stroke(Chip, Theme.Stroke, 1, 0.1)
    local TrackArea = New("Frame", {Position = UDim2.new(0, 14, 0, 42), Size = UDim2.new(1, -28, 0, 24), BackgroundTransparency = 1}, c)
    local Glow = New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 16), BackgroundColor3 = Accent, BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 1}, TrackArea)
    Corner(Glow, 8)
    Tint(Glow, "BackgroundColor3")
    local Track = New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = Theme.Track, BorderSizePixel = 0, ZIndex = 2}, TrackArea)
    Corner(Track, 3)
    local Fill = New("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Accent, BorderSizePixel = 0, ZIndex = 3}, Track)
    Corner(Fill, 3)
    local fgrad = New("UIGradient", {Color = ColorSequence.new(Accent, Accent2)}, Fill)
    Tint(fgrad, "Gradient")
    local Shine = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 4}, Fill)
    Corner(Shine, 3)
    local ShineGrad = New("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.42, 1), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(0.58, 1), NumberSequenceKeypoint.new(1, 1)}), Offset = Vector2.new(-1, 0)}, Shine)
    local TicksHolder = New("Frame", {Position = UDim2.new(0, 0, 1, -6), Size = UDim2.new(1, 0, 0, 5), BackgroundTransparency = 1, ZIndex = 2}, TrackArea)
    local ticks = {}
    for i = 1, 9 do
        local tp = (i - 1) / 8
        local tk = New("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(tp, 0, 0, 0), Size = UDim2.new(0, 2, 0, 5), BackgroundColor3 = Theme.Track, BorderSizePixel = 0, ZIndex = 3}, TicksHolder)
        Corner(tk, 1)
        ticks[i] = {f = tk, p = tp}
    end
    local Handle = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5}, Track)
    Corner(Handle, 7)
    local hst = Stroke(Handle, Accent, 2, 0)
    Tint(hst, "Color")
    local InnerDot = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 5, 0, 5), BackgroundColor3 = Accent, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6}, Handle)
    Corner(InnerDot, 3)
    Tint(InnerDot, "BackgroundColor3")
    local Bubble = New("TextLabel", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0, 0, 0, -6), Size = UDim2.new(0, 44, 0, 22), BackgroundColor3 = Theme.Track, Text = "", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Inv, Visible = false, ZIndex = 8, BorderSizePixel = 0}, TrackArea)
    Corner(Bubble, 7)
    Stroke(Bubble, Theme.Stroke, 1, 0.2)
    New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 1, -1), Size = UDim2.new(0, 9, 0, 9), BackgroundColor3 = Theme.Track, BorderSizePixel = 0, Rotation = 45, ZIndex = 7}, Bubble)
    New("TextLabel", {Position = UDim2.new(0, 14, 1, -16), Size = UDim2.new(0, 50, 0, 12), BackgroundTransparency = 1, Text = tostring(min), Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left}, c)
    New("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 1, -16), Size = UDim2.new(0, 50, 0, 12), BackgroundTransparency = 1, Text = tostring(max), Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Right}, c)

    local dragging, hovering, lastClick = false, false, 0
    local lastValue = default
    local curP = 0

    table.insert(ThemeLinks, function()
        nameLbl.TextColor3 = Theme.Text
        Chip.BackgroundColor3 = Theme.Track Chip.TextColor3 = Theme.Inv
        Track.BackgroundColor3 = Theme.Track
        Bubble.BackgroundColor3 = Theme.Track Bubble.TextColor3 = Theme.Inv
        for _, tk in ipairs(ticks) do tk.f.BackgroundColor3 = (tk.p <= curP + 0.0001) and Accent or Theme.Track end
    end)

    local function fmt(v)
        if decimals and decimals > 0 then return string.format("%." .. decimals .. "f", v) end
        return tostring(math.floor(v + 0.5))
    end
    local function computePercent(x)
        return math.clamp((x - Track.AbsolutePosition.X) / math.max(Track.AbsoluteSize.X, 1), 0, 1)
    end
    local function percentToValue(p)
        local v = min + (max - min) * p
        if decimals and decimals > 0 then return math.floor(v * 10 ^ decimals + 0.5) / 10 ^ decimals end
        return math.floor(v + 0.5)
    end
    local function set(p, instant, smoothTime, style)
        p = math.clamp(p, 0, 1)
        curP = p
        local v = percentToValue(p)
        lastValue = v
        Chip.Text = fmt(v) .. (suffix or "")
        Bubble.Text = fmt(v)
        local ti
        if instant then ti = TweenInfo.new(0) elseif smoothTime then ti = TweenInfo.new(smoothTime, style or Enum.EasingStyle.Quint) else ti = TweenInfo.new(0.06) end
        Tween(Fill, ti, {Size = UDim2.new(p, 0, 1, 0)})
        Tween(Glow, ti, {Size = UDim2.new(p, 0, 0, 16)})
        Tween(Handle, ti, {Position = UDim2.new(p, 0, 0.5, 0)})
        Tween(Bubble, ti, {Position = UDim2.new(p, 0, 0, -6)})
        for _, tk in ipairs(ticks) do tk.f.BackgroundColor3 = (tk.p <= p + 0.0001) and Accent or Theme.Track end
        callback(v)
    end
    local function preview(p)
        p = math.clamp(p, 0, 1)
        Bubble.Visible = true
        Bubble.Text = fmt(percentToValue(p))
        Bubble.Position = UDim2.new(p, 0, 0, -6)
    end

    task.spawn(function()
        while ScreenGui.Parent do
            ShineGrad.Offset = Vector2.new(-1, 0)
            local ok = pcall(function()
                local tw = TweenService:Create(ShineGrad, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)})
                tw:Play() tw.Completed:Wait()
            end)
            if not ok then break end
            task.wait(0.7)
        end
    end)

    local Hit = New("Frame", {Position = UDim2.new(0, 0, 0, -8), Size = UDim2.new(1, 0, 1, 14), BackgroundTransparency = 1, ZIndex = 10}, TrackArea)
    Hit.MouseEnter:Connect(function()
        hovering = true
        if not dragging then
            Tween(Track, Ease(0.2), {Size = UDim2.new(1, 0, 0, 8)})
            Tween(Glow, Ease(0.2), {BackgroundTransparency = 0.6, Size = UDim2.new(curP, 0, 0, 18)})
            Tween(Handle, Ease(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 17, 0, 17)})
            Tween(Chip, Ease(0.2), {BackgroundTransparency = 1, TextTransparency = 1})
            Tween(chipStroke, Ease(0.2), {Transparency = 1})
        end
    end)
    Hit.MouseLeave:Connect(function()
        hovering = false
        if not dragging then
            Tween(Track, Ease(0.25), {Size = UDim2.new(1, 0, 0, 6)})
            Tween(Glow, Ease(0.25), {BackgroundTransparency = 0.78, Size = UDim2.new(curP, 0, 0, 16)})
            Tween(Handle, Ease(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, 14, 0, 14)})
            Bubble.Visible = false
            Tween(Chip, Ease(0.25), {BackgroundTransparency = 0, TextTransparency = 0})
            Tween(chipStroke, Ease(0.25), {Transparency = 0.1})
        end
    end)
    Hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local now = os.clock()
            if now - lastClick < 0.3 then
                lastClick = 0
                Bubble.Visible = true
                PlayClick(1.8, 0.15)
                set((default - min) / (max - min), false, 0.45)
                task.delay(0.6, function() if not dragging and not hovering then Bubble.Visible = false end end)
                return
            end
            lastClick = now
            dragging = true
            Bubble.Visible = true
            PlayClick(2, 0.12)
            Tween(Handle, Ease(0.18, Enum.EasingStyle.Back), {Size = UDim2.new(0, 20, 0, 20)})
            Tween(InnerDot, Ease(0.15), {BackgroundTransparency = 0})
            Tween(chipScale, Ease(0.2, Enum.EasingStyle.Back), {Scale = 1.1})
            set(computePercent(input.Position.X))
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not ScreenGui.Parent then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then set(computePercent(input.Position.X)) elseif hovering then preview(computePercent(input.Position.X)) end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            PlayClick(1.55, 0.12)
            Tween(Handle, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, hovering and 17 or 14, 0, hovering and 17 or 14)})
            Tween(InnerDot, Ease(0.2), {BackgroundTransparency = 1})
            Tween(chipScale, Ease(0.3, Enum.EasingStyle.Back), {Scale = 1})
            if not hovering then
                Tween(Track, Ease(0.25), {Size = UDim2.new(1, 0, 0, 6)})
                Tween(Glow, Ease(0.25), {BackgroundTransparency = 0.78, Size = UDim2.new(curP, 0, 0, 16)})
                Tween(Chip, Ease(0.25), {BackgroundTransparency = 0, TextTransparency = 0})
                Tween(chipStroke, Ease(0.25), {Transparency = 0.1})
                task.delay(0.4, function() if not dragging and not hovering then Bubble.Visible = false end end)
            end
        end
    end)
    set((default - min) / (max - min), true)
    return {
        Set = function(v) v = tonumber(v) if not v then return end set((math.clamp(v, min, max) - min) / (max - min)) end,
        Get = function() return lastValue end,
    }
end

local function Keybind(page, name, default, callback)
    local c = Card(page, 44)
    RegisterSearch(name, nil, c)
    local label = New("TextLabel", {Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -120, 0, 44), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center}, c)
    local chip = New("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.new(0, 96, 0, 26), BackgroundColor3 = Theme.Track, Text = default.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Inv, AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true}, c)
    Corner(chip, 8)
    local cs = Stroke(chip, Theme.Stroke, 1, 0)
    local chs = New("UIScale", {Scale = 1}, chip)
    ClickRipple(chip)
    MakeMagnetic(chip, 3)
    local listening = false
    local pulseTween = nil
    local currentKey = default
    table.insert(ThemeLinks, function() label.TextColor3 = Theme.Text chip.BackgroundColor3 = Theme.Track chip.TextColor3 = Theme.Inv end)
    chip.MouseEnter:Connect(function() if not listening then Tween(chs, Ease(0.2, Enum.EasingStyle.Back), {Scale = 1.05}) end end)
    chip.MouseLeave:Connect(function() Tween(chs, Ease(0.2), {Scale = 1}) end)
    local function stopListen()
        listening = false
        anyListening = math.max(anyListening - 1, 0)
        if pulseTween then pulseTween:Cancel() pulseTween = nil end
        Tween(cs, Ease(0.25), {Color = Theme.Stroke, Transparency = 0})
        chip.Text = currentKey.Name
    end
    chip.MouseButton1Click:Connect(function()
        if listening then stopListen() return end
        listening = true
        anyListening = anyListening + 1
        chip.Text = "..."
        PlayClick(1.9, 0.15)
        cs.Color = Accent
        pulseTween = TweenService:Create(cs, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.6})
        pulseTween:Play()
        Toast("Keybind", "Press a key - Backspace resets - Esc cancels", Theme.Sub)
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if not listening then return end
        if input.KeyCode == Enum.KeyCode.Escape then stopListen() return end
        if input.KeyCode == Enum.KeyCode.Backspace then
            stopListen()
            currentKey = default
            chip.Text = default.Name
            Tween(chip, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundColor3 = Theme.Warn, TextColor3 = Color3.new(1, 1, 1)})
            task.delay(0.12, function() Tween(chip, Ease(0.4), {BackgroundColor3 = Theme.Track, TextColor3 = Theme.Inv}) end)
            PlayClick(1.0)
            callback(default)
            return
        end
        if gp or input.KeyCode == Enum.KeyCode.Unknown then return end
        stopListen()
        currentKey = input.KeyCode
        chip.Text = input.KeyCode.Name
        PlayClick(1.8)
        callback(input.KeyCode)
    end)
    return {
        Set = function(k)
            local kc = k
            if typeof(kc) ~= "EnumItem" then
                local ok, res = pcall(function() return Enum.KeyCode[tostring(k)] end)
                kc = ok and res or nil
            end
            if typeof(kc) ~= "EnumItem" then return end
            currentKey = kc
            chip.Text = kc.Name
            callback(kc)
        end,
        Get = function() return currentKey.Name end,
    }
end

local function Swatches(page)
    local c = Card(page, 70)
    RegisterSearch("Accent Color", "Pick the accent color - or click the U logo", c)
    New("TextLabel", {Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -30, 0, 16), BackgroundTransparency = 1, Text = "Accent Color", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, c)
    local row = New("Frame", {Position = UDim2.new(0, 14, 0, 34), Size = UDim2.new(1, -28, 0, 26), BackgroundTransparency = 1}, c)
    local swatches = {}
    local function refreshSizes()
        for j, s in ipairs(swatches) do Tween(s, Ease(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, j == AccentIndex and 26 or 20, 0, j == AccentIndex and 26 or 20)}) end
    end
    SwatchRefresh = refreshSizes
    local function pick(i, silent)
        AccentIndex = i
        if i == 7 then
            rainbowMode = true
            local h = (os.clock() * 0.1) % 1
            ApplyAccent(Color3.fromHSV(h, 0.72, 1), Color3.fromHSV((h + 0.12) % 1, 0.72, 1), true)
        else
            rainbowMode = false
            ApplyAccent(ACCENT_PRESETS[i][1], ACCENT_PRESETS[i][2])
        end
        refreshSizes()
        if not silent then
            PlayClick(1.65)
            if i == 7 then Toast("Theme", "Rainbow mode enabled", Color3.fromHSV((os.clock() * 0.1) % 1, 0.72, 1)) else Toast("Theme", "Accent color updated", ACCENT_PRESETS[i][1]) end
        end
    end
    for i, p in ipairs(ACCENT_PRESETS) do
        local s = New("TextButton", {Position = UDim2.new(0, (i - 1) * 34, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = p[1], Text = "", AutoButtonColor = false, BorderSizePixel = 0}, row)
        Corner(s, 11)
        New("UIGradient", {Color = ColorSequence.new(p[1], p[2]), Rotation = 45}, s)
        local ring = Stroke(s, Color3.fromRGB(70, 75, 100), 2, 1)
        s.MouseEnter:Connect(function() Tween(ring, Ease(0.15), {Transparency = 0.25}) end)
        s.MouseLeave:Connect(function() Tween(ring, Ease(0.25), {Transparency = 1}) end)
        s.MouseButton1Click:Connect(function() pick(i) end)
        MakeMagnetic(s, 2.5)
        table.insert(swatches, s)
    end
    do
        local s = New("TextButton", {Position = UDim2.new(0, 6 * 34, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Color3.new(1, 1, 1), Text = "", AutoButtonColor = false, BorderSizePixel = 0}, row)
        Corner(s, 11)
        AnimateGradient(New("UIGradient", {Rotation = 45}, s), 0.15, 0.85, 1)
        local ring = Stroke(s, Color3.fromRGB(70, 75, 100), 2, 1)
        s.MouseEnter:Connect(function() Tween(ring, Ease(0.15), {Transparency = 0.25}) end)
        s.MouseLeave:Connect(function() Tween(ring, Ease(0.25), {Transparency = 1}) end)
        s.MouseButton1Click:Connect(function() pick(7) end)
        MakeMagnetic(s, 2.5)
        table.insert(swatches, s)
    end
    refreshSizes()
    return {
        Set = function(i) pick(tonumber(i) or 1, true) end,
        Get = function() return AccentIndex end,
    }
end

local function Btn(page, name, callback)
    local b = New("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.08, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = page.ord(), ClipsDescendants = true}, page.frame)
    RegisterSearch(name, nil, b)
    Corner(b, 12)
    local bs = Stroke(b, Accent, 1, 0.4)
    Tint(bs, "Color")
    local lbl = New("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text}, b)
    local lblScale = New("UIScale", {Scale = 1}, lbl)
    table.insert(ThemeLinks, function() b.BackgroundColor3 = Theme.Card lbl.TextColor3 = Theme.Text end)
    b.MouseEnter:Connect(function() Tween(b, Ease(0.15), {BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 0}) Tween(bs, Ease(0.15), {Transparency = 0}) end)
    b.MouseLeave:Connect(function() Tween(b, Ease(0.25), {BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.08}) Tween(bs, Ease(0.25), {Transparency = 0.4}) end)
    b.MouseButton1Down:Connect(function() Tween(lblScale, TweenInfo.new(0.07), {Scale = 0.94}) end)
    b.MouseButton1Up:Connect(function() Tween(lblScale, Ease(0.3, Enum.EasingStyle.Back), {Scale = 1}) end)
    ClickRipple(b)
    b.MouseButton1Click:Connect(function() PlayClick(1.5) callback() end)
end

-- ═══════════ INTERACTIONS ═══════════
do
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local hidden = false
local toggleKey = Enum.KeyCode.RightShift
UserInputService.InputBegan:Connect(function(input, gp)
    if anyListening > 0 or searchFocused or gp then return end
    if input.KeyCode == toggleKey then
        hidden = not hidden
        if hidden then
            Tween(Main, Ease(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1})
            task.delay(0.26, function() if hidden then Main.Visible = false end end)
        else
            Main.Visible = true
            Tween(Main, Ease(0.3), {GroupTransparency = 0})
        end
    end
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MinBtn.Text = minimized and "+" or "-"
    PlayClick(1.4)
    Tween(Main, Ease(0.45, Enum.EasingStyle.Quint), {Size = minimized and UDim2.new(0, 560, 0, 56) or UDim2.new(0, 560, 0, 400)})
    Tween(uiScale, Ease(0.45, Enum.EasingStyle.Quint), {Scale = minimized and userScale * 0.9 or userScale})
end)

CloseBtn.MouseButton1Click:Connect(function()
    System.__properties.__autoparry_enabled = false
    System.autoparry.stop()
    PlayClick(1.0, 0.2)
    Tween(Main, Ease(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
    Tween(uiScale, Ease(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = userScale * 0.85})
    task.delay(0.32, function() ScreenGui:Destroy() end)
end)

-- ═══════════ STATUS BAR ═══════════
local StatusBar = New("Frame", {Position = UDim2.new(0, 12, 0, 362), Size = UDim2.new(1, -24, 0, 26), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.1, BorderSizePixel = 0}, Main)
Corner(StatusBar, 13)
Stroke(StatusBar, Color3.new(1, 1, 1), 1, 0.4)
local StatCenter = New("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, RichText = true, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Center}, StatusBar)

table.insert(ThemeLinks, function()
    Main.BackgroundColor3 = Theme.Bg
    BgGrad.Color = ColorSequence.new(Theme.BgTop, Theme.Bg)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Indicator.BackgroundColor3 = Theme.Card
    StatusBar.BackgroundColor3 = Theme.Card
    StatCenter.TextColor3 = Theme.Sub
    HeaderSub.TextColor3 = Theme.SubInv
end)

task.spawn(function()
    local frames, last = 0, os.clock()
    local renderConn = RunService.RenderStepped:Connect(function() frames = frames + 1 end)
    while ScreenGui.Parent do
        local now = os.clock()
        local fps = math.floor(frames / math.max(now - last, 0.001) + 0.5)
        frames, last = 0, now
        local ok, ping = pcall(function() return math.floor(Stats.Network.ServerStatsItem['Data Ping']:GetValue()) end)
        local a = Hex(Accent)
        local f
        if fps >= 55 then f = Hex(Theme.Good) elseif fps >= 30 then f = Hex(Theme.Warn) else f = "D94040" end
        StatCenter.Text = string.format('FPS <font color="#%s">%d</font>    ·    Ping <font color="#%s">%dms</font>', f, fps, a, ok and ping or 0)
        task.wait(0.5)
    end
    renderConn:Disconnect()
end)

-- ═══════════ WIRING ═══════════
getgenv().AutoParryMode = "Remote"
update_divisor()

local Combat = NewPage("Combat", "swords")
local Settings = NewPage("Settings", "gear")
local notifOn = false

local H_AP = Toggle(Combat, "Auto Parry", "Automatically parries the ball", false, function(v)
    System.__properties.__autoparry_enabled = v
    if v then System.autoparry.start() else System.autoparry.stop() end
    Toast("Auto Parry", v and "Enabled - watching the ball" or "Disabled", v and Theme.Good or Theme.Sub)
end, Enum.KeyCode.T)

local H_MODE = Dropdown(Combat, "Parry Mode", {"Remote", "Keypress"}, "Remote", function(v)
    getgenv().AutoParryMode = v
end)

local H_CURVE = Dropdown(Combat, "Curve Type", System.__config.__curve_names, "Camera", function(v)
    for i, n in ipairs(System.__config.__curve_names) do
        if n == v then System.__properties.__curve_mode = i break end
    end
end)

local H_ACC = Slider(Combat, "Parry Accuracy", 1, 100, 1, "", 0, function(v)
    System.__properties.__accuracy = v
    update_divisor()
end)

local H_ANIM = Toggle(Combat, "Animation Fix", "Shows the parry swing animation locally", false, function(v)
    System.__properties.__animation_fix = v
end, Enum.KeyCode.Y)

local H_NOTIF = Toggle(Combat, "Parry Notify", "Toast + sound + logo pulse on every parry", false, function(v)
    notifOn = v
end, Enum.KeyCode.U)

local H_BRIGHT = Slider(Settings, "Theme Brightness", 60, 160, 100, "%", 0, function(v)
    ApplyBrightness(v / 100)
end)
local H_SW = Swatches(Settings)
local H_SCALE = Slider(Settings, "UI Scale", 60, 140, 100, "%", 0, function(v) SetScale(v / 100) end)
local H_SND = Toggle(Settings, "UI Sounds", "Subtle click feedback sounds", true, function(v)
    soundEnabled = v
end)
local H_KEY = Keybind(Settings, "Toggle UI Key", Enum.KeyCode.RightShift, function(k) toggleKey = k end)

-- Config
local cfgDir, cfgName = "UwU", "UwU_PremiumAP.json"
local fsOk = (typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function" and typeof(isfolder) == "function" and typeof(makefolder) == "function")
local function cfgPath() return cfgDir .. "/" .. cfgName end
local function nameToKey(n)
    if type(n) ~= "string" or n == "" then return nil end
    local ok, kc = pcall(function() return Enum.KeyCode[n] end)
    if ok and typeof(kc) == "EnumItem" then return kc end
    return nil
end
local function SaveConfigFn()
    if not fsOk then Toast("Config", "Filesystem not available on this executor", Theme.Warn) return end
    local data = {
        bright = H_BRIGHT.Get(), ap = H_AP.Get(), mode = H_MODE.Get(), curve = H_CURVE.Get(),
        acc = H_ACC.Get(), anim = H_ANIM.Get(), notify = H_NOTIF.Get(), snd = H_SND.Get(),
        accent = H_SW.Get(), scale = H_SCALE.Get(), key = H_KEY.Get(),
        apkey = (H_AP.GetKey() and H_AP.GetKey().Name) or "",
        animkey = (H_ANIM.GetKey() and H_ANIM.GetKey().Name) or "",
        notifykey = (H_NOTIF.GetKey() and H_NOTIF.GetKey().Name) or "",
    }
    local ok = pcall(function()
        if not isfolder(cfgDir) then makefolder(cfgDir) end
        writefile(cfgPath(), HttpService:JSONEncode(data))
    end)
    if ok then PlaySnap(1.2) Toast("Config", "Saved to " .. cfgPath(), Theme.Good) else Toast("Config", "Failed to save config", Theme.Danger) end
end
local function LoadConfig(apply)
    if not fsOk then return false end
    local path = cfgPath()
    if not isfile(path) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" then return false end
    if not apply then return true end
    pcall(function() H_BRIGHT.Set(data.bright) end)
    pcall(function() H_SW.Set(data.accent) end)
    pcall(function() H_SCALE.Set(data.scale) end)
    pcall(function() H_KEY.Set(data.key) end)
    pcall(function() H_MODE.Set(data.mode) end)
    pcall(function() H_CURVE.Set(data.curve) end)
    pcall(function() H_ACC.Set(data.acc) end)
    pcall(function() H_ANIM.Set(data.anim) end)
    pcall(function() H_NOTIF.Set(data.notify) end)
    pcall(function() H_SND.Set(data.snd) end)
    if data.apkey ~= nil then pcall(function() H_AP.SetKey(nameToKey(data.apkey)) end) end
    if data.animkey ~= nil then pcall(function() H_ANIM.SetKey(nameToKey(data.animkey)) end) end
    if data.notifykey ~= nil then pcall(function() H_NOTIF.SetKey(nameToKey(data.notifykey)) end) end
    pcall(function() H_AP.Set(data.ap) end)
    return true
end

Btn(Settings, "Reset Position", function()
    Tween(Main, Ease(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, 0, 0.5, 0)})
    Toast("Window", "Position reset", Accent)
end)
Btn(Settings, "Save Config", function() SaveConfigFn() end)
Btn(Settings, "Test Notification", function() Toast("UwU Premium", "Notifications are working", Accent) end)

do
    local parryTotal, lastNotif, lastConfetti = 0, 0, 0
    ParryHook = function()
        parryTotal = parryTotal + 1
        if os.clock() - lastConfetti > 0.6 then
            lastConfetti = os.clock()
            FireEdgePulse()
            pcall(function()
                local s = math.max(uiScale.Scale, 0.01)
                Confetti((LogoHolder.AbsolutePosition.X - Main.AbsolutePosition.X + LogoHolder.AbsoluteSize.X / 2) / s, (LogoHolder.AbsolutePosition.Y - Main.AbsolutePosition.Y + LogoHolder.AbsoluteSize.Y / 2) / s, 6)
            end)
        end
        if not notifOn then return end
        Tween(LogoScale, TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.25})
        task.delay(0.09, function() Tween(LogoScale, Ease(0.35, Enum.EasingStyle.Back), {Scale = 1}) end)
        if os.clock() - lastNotif < 1.2 then return end
        lastNotif = os.clock()
        PlaySnap(1.35)
        Toast("Parry", string.format("Auto parry executed - total %d", parryTotal), Theme.Good)
    end
end

-- ═══════════ LOADING SCREEN ═══════════
local Loader = New("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, GroupTransparency = 0, ZIndex = 50, ClipsDescendants = true}, Main)
Corner(Loader, 20)
New("UIGradient", {Color = ColorSequence.new(Theme.BgTop, Theme.Bg), Rotation = 90}, Loader)

local LHolder = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.36, 0), Size = UDim2.new(0, 74, 0, 74), BackgroundTransparency = 1}, Loader)
local LScale = New("UIScale", {Scale = 0}, LHolder)
local LGlow = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(2.3, 0, 2.3, 0), BackgroundColor3 = Accent, BackgroundTransparency = 0.93, BorderSizePixel = 0}, LHolder)
Corner(LGlow, 300)
Tint(LGlow, "BackgroundColor3")
TweenService:Create(LGlow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0), {BackgroundTransparency = 0.87}):Play()
local LRing = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1.32, 0, 1.32, 0), BackgroundTransparency = 1}, LHolder)
Corner(LRing, 300)
local LRingStroke = New("UIStroke", {Color = Accent, Thickness = 2}, LRing)
local LRingGrad = New("UIGradient", {Color = ColorSequence.new(Accent2, Accent), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.45, 0.85), NumberSequenceKeypoint.new(1, 0.4)})}, LRingStroke)
Tint(LRingGrad, "Gradient")
TweenService:Create(LRingGrad, TweenInfo.new(1.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0), {Rotation = 360}):Play()
local LLogo = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Accent, BorderSizePixel = 0}, LHolder)
Corner(LLogo, 17)
local LLogoGrad = New("UIGradient", {Color = ColorSequence.new(Accent, Accent2), Rotation = 45}, LLogo)
Tint(LLogoGrad, "Gradient")
TweenService:Create(LLogoGrad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0), {Rotation = 405}):Play()
New("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "U", Font = Enum.Font.GothamBlack, TextSize = 38, TextColor3 = Color3.new(1, 1, 1)}, LLogo)

local LTitle = New("TextLabel", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.55, 0), Size = UDim2.new(0, 300, 0, 24), BackgroundTransparency = 1, Text = "UwU Premium", Font = Enum.Font.GothamBold, TextSize = 21, TextColor3 = Color3.new(1, 1, 1)}, Loader)
AnimateGradient(New("UIGradient", {}, LTitle), 0.09, 0.9, 1)
New("UIStroke", {Color = Color3.fromRGB(55, 58, 82), Thickness = 1.1, Transparency = 0.6}, LTitle)
New("TextLabel", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.608, 0), Size = UDim2.new(0, 300, 0, 14), BackgroundTransparency = 1, Text = "UwU Fix - zPxnchiSkixlled", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.SubInv}, Loader)

local LProg = New("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.70, 0), Size = UDim2.new(0, 300, 0, 64), BackgroundTransparency = 1}, Loader)
local LStatus = New("TextLabel", {Size = UDim2.new(0.6, 0, 0, 16), BackgroundTransparency = 1, Text = "Initializing", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.SubInv, TextXAlignment = Enum.TextXAlignment.Left}, LProg)
local LPct = New("TextLabel", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 90, 0, 16), BackgroundTransparency = 1, Text = "0%", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Right}, LProg)
local LBar = New("Frame", {Position = UDim2.new(0, 0, 0, 24), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = Theme.Track, BorderSizePixel = 0}, LProg)
Corner(LBar, 3)
local LFill = New("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Accent, BorderSizePixel = 0}, LBar)
Corner(LFill, 3)
Tint(New("UIGradient", {Color = ColorSequence.new(Accent, Accent2)}, LFill), "Gradient")
local LHint = New("TextLabel", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -18), Size = UDim2.new(0, 300, 0, 14), BackgroundTransparency = 1, Text = "click anywhere to skip", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.SubInv}, Loader)
TweenService:Create(LHint, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0), {TextTransparency = 0.6}):Play()
local LCredit = New("TextLabel", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -36), Size = UDim2.new(0, 400, 0, 15), BackgroundTransparency = 1, Text = 'Made by <font color="#7C54FF">zPxnchiSkixlled</font>', RichText = true, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(35, 39, 55), TextTransparency = 1}, Loader)
task.delay(0.5, function() Tween(LCredit, Ease(0.8), {TextTransparency = 0}) end)

local function PlayEntrance()
    SelectTab(1)
    Tween(Main, Ease(0.55, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, 0, 0.5, 0)})
    Tween(uiScale, Ease(0.6, Enum.EasingStyle.Back), {Scale = 1})
    task.delay(0.1, function()
        Tween(LogoScale, Ease(0.55, Enum.EasingStyle.Back), {Scale = 1})
        Tween(Title, Ease(0.6, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 62, 0, 9), TextTransparency = 0})
        Tween(HeaderSub, Ease(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0})
    end)
    Tween(TopLine, Ease(0.9, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 2.5)})
    Tween(BotLine, Ease(0.9, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 2.5)})
    task.delay(0.8, function() Toast("UwU Premium", "Loaded - press RightShift to hide", Accent) end)
    task.delay(2.4, function() Toast("Tip", "Click the logo to cycle colors - try rainbow", Accent) end)
    if LoadConfig(true) then
        task.delay(1.2, function() Toast("Config", "Settings restored from file", Theme.Good) end)
    end
end

local loaderDone = false
local function FinishLoader()
    if loaderDone then return end
    loaderDone = true
    Tween(LFill, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 1, 0)})
    LPct.Text = "100%"
    LStatus.Text = "Ready"
    Tween(LScale, Ease(0.3, Enum.EasingStyle.Back), {Scale = 1.12})
    task.delay(0.25, function()
        pcall(PlayEntrance)
        Tween(Loader, Ease(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
        task.delay(0.45, function() Loader:Destroy() end)
    end)
end

Loader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then FinishLoader() end
end)

task.spawn(function()
    Tween(LScale, Ease(0.6, Enum.EasingStyle.Back), {Scale = 1})
    local t0 = os.clock()
    local dur = 2.6
    local steps = {{0, "Initializing"}, {0.25, "Hooking parry patch"}, {0.5, "Bypassing anticheat"}, {0.72, "Building interface"}, {0.9, "Finishing up"}}
    while not loaderDone do
        local a = math.clamp((os.clock() - t0) / dur, 0, 1)
        local e = 1 - (1 - a) * (1 - a)
        LPct.Text = math.floor(e * 100 + 0.5) .. "%"
        Tween(LFill, TweenInfo.new(0.05), {Size = UDim2.new(e, 0, 1, 0)})
        for _, s in ipairs(steps) do if a >= s[1] then LStatus.Text = s[2] end end
        if a >= 1 then break end
        task.wait(0.03)
    end
    task.wait(0.35)
    FinishLoader()
end)

end, function(e)
    return debug.traceback(tostring(e))
end)

if not RunOK then
    warn("[UwU Premium] ERROR: " .. tostring(RunErr))
    print("[UwU Premium] ERROR: " .. tostring(RunErr))
    ShowError(RunErr)
end
