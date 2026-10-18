--[[ AMwZ Speed Boost · Halloween · Normal + Carry (game reads 0 on carry) ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- ===== BG write =====
local BG_PATH = "AMwZ_SpeedHW_bg.jpg"
local function writeBg(parts)
    if type(writefile) ~= "function" then return end
    local b64 = table.concat(parts)
    local decoded
    pcall(function() if crypt and crypt.base64decode then decoded = crypt.base64decode(b64) end end)
    if not decoded then pcall(function() if base64_decode then decoded = base64_decode(b64) end end) end
    if not decoded then pcall(function() if base64 and base64.decode then decoded = base64.decode(b64) end end) end
    if not decoded then
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local data = b64:gsub("[^%w%+%/=]", "")
        local t = {}
        for i = 1, #data, 4 do
            local function ix(s)
                if not s or s == "" or s == "=" then return 0 end
                local p = alphabet:find(s, 1, true)
                return p and (p - 1) or 0
            end
            local n = ix(data:sub(i,i))*262144 + ix(data:sub(i+1,i+1))*4096 + ix(data:sub(i+2,i+2))*64 + ix(data:sub(i+3,i+3))
            t[#t+1] = string.char(math.floor(n/65536)%256)
            if data:sub(i+2,i+2) ~= "=" then t[#t+1] = string.char(math.floor(n/256)%256) end
            if data:sub(i+3,i+3) ~= "=" then t[#t+1] = string.char(n%256) end
        end
        decoded = table.concat(t)
    end
    if decoded and #decoded > 50 then pcall(writefile, BG_PATH, decoded) end
end
pcall(function()
    writeBg({
        "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"
    })
end)

local function getBg()
    local ok, a = pcall(function()
        if getcustomasset then return getcustomasset(BG_PATH) end
    end)
    return (ok and a) or ""
end
local BG = getBg()

-- ===== State =====
local State = {
    normalOn = false,
    carryOn = false,
    autoCarry = true, -- auto enable carry when holding brainrot
    normalSpeed = 60,
    carrySpeed = 28,
    _autoCarryLast = false,
}

local function char() return LP.Character end
local function hrp()
    local c = char()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function hum()
    local c = char()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function isCarrying()
    local c = char()
    if not c then return false end
    local carrying = false
    pcall(function()
        if LP:GetAttribute("Stealing") == true then carrying = true end
    end)
    if carrying then return true end
    for _, obj in ipairs(c:GetChildren()) do
        if obj:IsA("Tool") then
            local n = string.lower(obj.Name)
            if string.find(n, "brainrot", 1, true) or string.find(n, "animal", 1, true)
                or string.find(n, "brain", 1, true) or string.find(n, "steal", 1, true) then
                return true
            end
        else
            local n = string.lower(obj.Name)
            if string.find(n, "brainrot", 1, true) or string.find(n, "animal", 1, true)
                or string.find(n, "stolen", 1, true) or string.find(n, "held", 1, true) then
                return true
            end
        end
    end
    return false
end

local function getSpeed()
    if State.carryOn then
        return math.clamp(tonumber(State.carrySpeed) or 28, 1, 500)
    end
    if State.normalOn then
        return math.clamp(tonumber(State.normalSpeed) or 60, 1, 500)
    end
    return 0
end

-- ===== AMwZ velocity spoof (game reads 0 horizontal on carry) =====
do
    local st = (getgenv and getgenv()._AMwZVelHookState) or {
        hooked = false,
        v = Vector3.zero,
        root = nil,
        _oldIndex = nil,
    }
    if getgenv then getgenv()._AMwZVelHookState = st end

    getgenv()._AMwZSetFakeVel = function(v)
        if typeof(v) == "Vector3" then st.v = v end
    end

    getgenv()._AMwZGetRealVel = function(part)
        if not part then return Vector3.zero end
        local ok, v = pcall(function()
            if st._oldIndex then return st._oldIndex(part, "AssemblyLinearVelocity") end
            return part.AssemblyLinearVelocity
        end)
        if ok and typeof(v) == "Vector3" then return v end
        return Vector3.zero
    end

    -- apply real speed; when carryOn, game sees horizontal 0
    getgenv()._AMwZApplySpeed = function(root, dir, speed, forceZero)
        if not root or not root.Parent then return end
        if type(speed) ~= "number" or speed ~= speed or speed <= 0 then return end
        local y = 0
        pcall(function()
            if st._oldIndex then
                local rv = st._oldIndex(root, "AssemblyLinearVelocity")
                if typeof(rv) == "Vector3" then y = rv.Y end
            else
                y = root.AssemblyLinearVelocity.Y
            end
        end)
        if forceZero then
            st.v = Vector3.new(0, y, 0) -- game reads 0
        else
            -- normal: report real-ish for less conflicts
            if dir and dir.Magnitude > 0.05 then
                local u = dir.Unit
                st.v = Vector3.new(u.X * speed, y, u.Z * speed)
            else
                st.v = Vector3.new(0, y, 0)
            end
        end
        if dir and dir.Magnitude > 0.05 then
            local u = dir.Unit
            root.AssemblyLinearVelocity = Vector3.new(u.X * speed, y, u.Z * speed)
        else
            root.AssemblyLinearVelocity = Vector3.new(0, y, 0)
        end
    end

    task.defer(function()
        pcall(function()
            if st.hooked then return end
            if not (getrawmetatable and setreadonly and newcclosure) then return end
            local hasCC = type(checkcaller) == "function"
            local mt = getrawmetatable(game)
            if not mt then return end
            setreadonly(mt, false)
            local oldIndex = rawget(mt, "__index")
            local oldNewIndex = rawget(mt, "__newindex")
            st._oldIndex = oldIndex

            local function isOurRoot(t, k)
                local tk = tostring(k)
                if tk ~= "AssemblyLinearVelocity" and tk ~= "Velocity" then return false end
                if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
                local tn = t.Name
                if tn ~= "HumanoidRootPart" and tn ~= "Torso" and tn ~= "UpperTorso" then return false end
                local ch = LP.Character
                return ch ~= nil and t:IsDescendantOf(ch)
            end

            if type(oldIndex) == "function" or type(oldIndex) == "table" then
                mt.__index = newcclosure(function(self, key)
                    if (not hasCC) or (not checkcaller()) then
                        local ok, mine = pcall(isOurRoot, self, key)
                        if ok and mine then
                            return st.v
                        end
                    end
                    if type(oldIndex) == "function" then
                        return oldIndex(self, key)
                    end
                    return oldIndex[key]
                end)
            end

            if type(oldNewIndex) == "function" then
                mt.__newindex = newcclosure(function(self, key, value)
                    if (not hasCC) or (not checkcaller()) then
                        local ok, mine = pcall(isOurRoot, self, key)
                        if ok and mine then
                            st.v = value
                            return
                        end
                    end
                    return oldNewIndex(self, key, value)
                end)
            end

            setreadonly(mt, true)
            st.hooked = true
        end)
    end)

    LP.CharacterAdded:Connect(function(c)
        task.defer(function()
            local r = c:WaitForChild("HumanoidRootPart", 5)
            if r then st.root = r end
        end)
    end)
end

-- mutual exclusive toggles
local function setNormal(on)
    State.normalOn = on
    if on then State.carryOn = false end
end
local function setCarry(on)
    State.carryOn = on
    if on then State.normalOn = false end
end

-- move step
local function moveStep()
    if not (State.normalOn or State.carryOn) then return end
    local h = hum()
    local root = hrp()
    if not h or not root then return end
    if h.Sit or h.PlatformStand then return end
    local stt = h:GetState()
    if stt == Enum.HumanoidStateType.Physics or stt == Enum.HumanoidStateType.Ragdoll or stt == Enum.HumanoidStateType.Seated then
        return
    end
    local md = h.MoveDirection
    local spd = getSpeed()
    if spd <= 0 then return end
    local forceZero = State.carryOn -- game reads 0 only in carry mode
    if md.Magnitude > 0.05 then
        local flat = Vector3.new(md.X, 0, md.Z)
        if flat.Magnitude > 1e-4 then flat = flat.Unit end
        if getgenv and getgenv()._AMwZApplySpeed then
            getgenv()._AMwZApplySpeed(root, flat, spd, forceZero)
        else
            local y = root.AssemblyLinearVelocity.Y
            root.AssemblyLinearVelocity = Vector3.new(flat.X * spd, y, flat.Z * spd)
        end
    end
end
RunService.RenderStepped:Connect(moveStep)

-- Auto Carry (AMwZ): holding brainrot -> carry ON, drop -> back to previous
RunService.Heartbeat:Connect(function()
    if not State.autoCarry then
        State._autoCarryLast = false
        return
    end
    local carrying = isCarrying()
    if carrying == State._autoCarryLast then return end
    State._autoCarryLast = carrying
    if carrying then
        setCarry(true)
        if refreshUI then pcall(refreshUI) end
    else
        -- drop: leave carry, keep normal if it was on before only if user wants
        setCarry(false)
        if refreshUI then pcall(refreshUI) end
    end
end)


-- ===== UI =====
pcall(function()
    for _, p in ipairs({ CoreGui, PlayerGui }) do
        local o = p and p:FindFirstChild("AMwZ_SpeedHW")
        if o then o:Destroy() end
    end
    if gethui then
        local o = gethui():FindFirstChild("AMwZ_SpeedHW")
        if o then o:Destroy() end
    end
end)

local ORANGE = Color3.fromRGB(255, 130, 25)
local ORANGE2 = Color3.fromRGB(255, 170, 50)
local BG_C = Color3.fromRGB(12, 8, 4)
local CARD = Color3.fromRGB(22, 12, 6)
local TXT = Color3.fromRGB(255, 235, 210)
local MUTE = Color3.fromRGB(180, 130, 80)

local sg = Instance.new("ScreenGui")
sg.Name = "AMwZ_SpeedHW"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 230
pcall(function() sg.Parent = CoreGui end)
if not sg.Parent then sg.Parent = PlayerGui end

local W, H = 200, 290
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(W, H)
main.Position = UDim2.new(0, 16, 0.35, 0)
main.BackgroundColor3 = BG_C
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke", main)
stroke.Color = ORANGE
stroke.Thickness = 1.4
stroke.Transparency = 0.25
task.spawn(function()
    local t0 = tick()
    while main.Parent do
        local a = (math.sin((tick() - t0) * 2.2) + 1) * 0.5
        stroke.Transparency = 0.15 + a * 0.4
        task.wait(0.04)
    end
end)

-- background image
do
    local bg = Instance.new("ImageLabel")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundTransparency = 1
    bg.ImageTransparency = 0
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ZIndex = 0
    bg.Parent = main
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 14)
    if BG and BG ~= "" then bg.Image = BG end
    local glass = Instance.new("Frame")
    glass.Size = UDim2.fromScale(1, 1)
    glass.BackgroundColor3 = Color3.fromRGB(8, 4, 0)
    glass.BackgroundTransparency = 0.55
    glass.BorderSizePixel = 0
    glass.ZIndex = 1
    glass.Parent = main
    Instance.new("UICorner", glass).CornerRadius = UDim.new(0, 14)
end

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundTransparency = 1
header.ZIndex = 3

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "AMwZ Speed"
title.Font = Enum.Font.GothamBlack
title.TextSize = 15
title.TextColor3 = ORANGE2
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 4

local mini = Instance.new("TextButton", header)
mini.Size = UDim2.fromOffset(26, 26)
mini.Position = UDim2.new(1, -32, 0.5, -13)
mini.BackgroundColor3 = CARD
mini.Text = "–"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 14
mini.TextColor3 = TXT
mini.BorderSizePixel = 0
mini.ZIndex = 4
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 7)

local body = Instance.new("Frame", main)
body.Size = UDim2.new(1, -16, 1, -52)
body.Position = UDim2.fromOffset(8, 44)
body.BackgroundTransparency = 1
body.ZIndex = 3

local function row(y, h)
    local f = Instance.new("Frame", body)
    f.Size = UDim2.new(1, 0, 0, h or 36)
    f.Position = UDim2.fromOffset(0, y)
    f.BackgroundColor3 = CARD
    f.BackgroundTransparency = 0.25
    f.BorderSizePixel = 0
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", f)
    st.Color = ORANGE
    st.Thickness = 1
    st.Transparency = 0.55
    return f
end

local function makeSwitch(parent, label, get, set)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.fromOffset(10, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextColor3 = TXT
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 5

    local track = Instance.new("Frame", parent)
    track.Size = UDim2.fromOffset(36, 18)
    track.Position = UDim2.new(1, -44, 0.5, -9)
    track.BackgroundColor3 = get() and ORANGE or Color3.fromRGB(50, 30, 15)
    track.BorderSizePixel = 0
    track.ZIndex = 5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = get() and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = get() and Color3.fromRGB(20, 10, 0) or TXT
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hit = Instance.new("TextButton", parent)
    hit.Size = UDim2.fromScale(1, 1)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 7
    hit.MouseButton1Click:Connect(function()
        local v = not get()
        set(v)
        -- refresh both switches visual via refreshUI
        if refreshUI then refreshUI() end
    end)
    return track, knob
end

local function makeVal(parent, label, get, set)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.fromOffset(10, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextColor3 = MUTE
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 5
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.fromOffset(52, 22)
    box.Position = UDim2.new(1, -60, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(30, 16, 8)
    box.Text = tostring(get())
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.TextColor3 = ORANGE2
    box.ClearTextOnFocus = false
    box.BorderSizePixel = 0
    box.ZIndex = 5
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n and n > 0 then
            set(n)
            box.Text = tostring(n)
        else
            box.Text = tostring(get())
        end
    end)
    return box
end

local r1 = row(0, 36)
local r2 = row(42, 36)
local rAC = row(84, 36)
local r3 = row(126, 36)
local r4 = row(168, 36)

local tN, kN = makeSwitch(r1, "Speed Boost", function() return State.normalOn end, function(v)
    setNormal(v)
end)
local tC, kC = makeSwitch(r2, "Carry Speed", function() return State.carryOn end, function(v)
    setCarry(v)
end)
local tAC, kAC = makeSwitch(rAC, "Auto Carry", function() return State.autoCarry end, function(v)
    State.autoCarry = v
    State._autoCarryLast = false
    if not v then
        -- don't force carry off; user still can toggle manually
    end
end)
makeVal(r3, "Normal value", function() return State.normalSpeed end, function(v) State.normalSpeed = v end)
makeVal(r4, "Carry value", function() return State.carrySpeed end, function(v) State.carrySpeed = v end)

local tip = Instance.new("TextLabel", body)
tip.Size = UDim2.new(1, 0, 0, 28)
tip.Position = UDim2.fromOffset(0, 210)
tip.BackgroundTransparency = 1
tip.Text = "Auto: hold brainrot → carry\nCarry = game reads 0"
tip.Font = Enum.Font.Gotham
tip.TextSize = 10
tip.TextColor3 = MUTE
tip.TextXAlignment = Enum.TextXAlignment.Left
tip.ZIndex = 4

function refreshUI()
    tN.BackgroundColor3 = State.normalOn and ORANGE or Color3.fromRGB(50, 30, 15)
    kN.Position = State.normalOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    kN.BackgroundColor3 = State.normalOn and Color3.fromRGB(20, 10, 0) or TXT
    tC.BackgroundColor3 = State.carryOn and ORANGE or Color3.fromRGB(50, 30, 15)
    kC.Position = State.carryOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    kC.BackgroundColor3 = State.carryOn and Color3.fromRGB(20, 10, 0) or TXT
    if tAC and kAC then
        tAC.BackgroundColor3 = State.autoCarry and ORANGE or Color3.fromRGB(50, 30, 15)
        kAC.Position = State.autoCarry and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        kAC.BackgroundColor3 = State.autoCarry and Color3.fromRGB(20, 10, 0) or TXT
    end
end

local open = true
mini.MouseButton1Click:Connect(function()
    open = not open
    if open then
        body.Visible = true
        TweenService:Create(main, TweenInfo.new(0.2), { Size = UDim2.fromOffset(W, H) }):Play()
        mini.Text = "–"
    else
        body.Visible = false
        TweenService:Create(main, TweenInfo.new(0.2), { Size = UDim2.fromOffset(W, 40) }):Play()
        mini.Text = "+"
    end
end)

local drag, d0, p0
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag, d0, p0 = true, i.Position, main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - d0
        main.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)

-- intro anim
main.Size = UDim2.fromOffset(0, 0)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    Size = UDim2.fromOffset(W, H),
    BackgroundTransparency = 0.15,
}):Play()

print("[AMwZ Speed] Halloween · carry game reads 0")
