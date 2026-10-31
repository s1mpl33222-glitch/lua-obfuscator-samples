local function _0xdecode(s)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local d = ''
    s = string.gsub(s, '[^' .. b .. '=]', '')
    s = string.gsub(s, '.', function(x)
        if x == '=' then
            return ''
        end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
    end)
    d = string.gsub(s, '%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then
            return ''
        end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end)
    return d
end

-- Number obfuscation helpers
local _0xn1 = (function()
    return 5 * 5 * 4
end)() -- 100
local _0xn2 = (function()
    return 3 + 2
end)() -- 5
local _0xn3 = (function()
    return 2 ^ 10
end)() -- 1024
local _0xn4 = (function()
    return 16 * 16 - 1
end)() -- 255
local _0xn5 = (function()
    return 3 * 2
end)() -- 6
local _0xn6 = (function()
    return 4 * 2
end)() -- 8
local _0xn7 = (function()
    return 2 + 2
end)() -- 4
local _0xn8 = (function()
    return 3 - 2
end)() -- 1
local _0xn9 = (function()
    return 10 - 10
end)() -- 0
local _0xn10 = (function()
    return 2 * 2
end)() -- 4
local _0xn11 = (function()
    return 12 / 6
end)() -- 2
local _0xn12 = (function()
    return 15 / 5
end)() -- 3
local _0xn13 = (function()
    return 5 - 5
end)() -- 0
local _0xn14 = (function()
    return -1 + 1.05
end)() -- 0.05
local _0xn15 = (function()
    return -1 / 10
end)() -- -0.1
local _0xn16 = (function()
    return -1 / 20
end)() -- -0.05
local _0xn17 = (function()
    return 8 * 3
end)() -- 24
local _0xn18 = (function()
    return 9 / 2
end)() -- 4.5
local _0xn19 = (function()
    return 6 / 5
end)() -- 1.2
local _0xn20 = (function()
    return 320
end)() -- 320
local _0xn21 = (function()
    return 160
end)() -- 160
local _0xn22 = (function()
    return 10
end)() -- 10
local _0xn23 = (function()
    return 20
end)() -- 20
local _0xn24 = (function()
    return 30
end)() -- 30
local _0xn25 = (function()
    return 45
end)() -- 45
local _0xn26 = (function()
    return 260
end)() -- 260
local _0xn27 = (function()
    return 90
end)() -- 90
local _0xn28 = (function()
    return 16
end)() -- 16
local _0xn29 = (function()
    return 60
end)() -- 60
local _0xn30 = (function()
    return 12
end)() -- 12
local _0xn31 = (function()
    return 14
end)() -- 14
local _0xn32 = (function()
    return 50
end)() -- 50
local _0xn33 = (function()
    return 120
end)() -- 120
local _0xn34 = (function()
    return 70
end)() -- 70
local _0xn35 = (function()
    return 250
end)() -- 250
local _0xn36 = (function()
    return 0.5
end)() -- 0.5
local _0xn37 = (function()
    return 0.2
end)() -- 0.2
local _0xn38 = (function()
    return 0.25
end)() -- 0.25
local _0xn39 = (function()
    return 0.4
end)() -- 0.4
local _0xn40 = (function()
    return 0.8
end)() -- 0.8
local _0xn41 = (function()
    return 0.9
end)() -- 0.9
local _0xn42 = (function()
    return 25
end)() -- 25
local _0xn43 = (function()
    return 300
end)() -- 300

local _0x52a0d5 = { BulletSpread = { Enabled = true, Amount = _0xn9 } }
local _0x9ba38e

_0x9ba38e = hookfunction(math.random, function(...)
    local _0x5e1a0d = { ... }
    if checkcaller() then
        return _0x9ba38e(...)
    end
    if
        (#_0x5e1a0d == _0xn9)
        or (_0x5e1a0d[_0xn8] == _0xn16 and _0x5e1a0d[_0xn11] == _0xn14)
        or (_0x5e1a0d[_0xn8] == _0xn15)
        or (_0x5e1a0d[_0xn8] == _0xn16)
    then
        if _0x52a0d5.BulletSpread.Enabled then
            return _0x9ba38e(...) * (_0x52a0d5.BulletSpread.Amount / _0xn1)
        end
    end
    return _0x9ba38e(...)
end)

local Players = game:GetService(_0xdecode('UGxheWVycw=='))
local TweenService = game:GetService(_0xdecode('VHdlZW5TZXJ2aWNl'))
local UIS = game:GetService(_0xdecode('VXNlcklucHV0U2VydmljZQ=='))
local Lighting = game:GetService(_0xdecode('TGlnaHRpbmc='))
local CoreGui = game:GetService(_0xdecode('Q29yZUd1aQ=='))

local gui = Instance.new(_0xdecode('U2NyZWVuR3Vp'))
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Name = _0xdecode('U3ByZWFkVUk=')
gui.Parent = CoreGui

local blur = Instance.new(_0xdecode('Qmx1ckVmZmVjdA=='))
blur.Size = _0xn9
blur.Parent = Lighting

local loadingFrame = Instance.new(_0xdecode('RnJhbWU='))
loadingFrame.Size = UDim2.new(_0xn8, _0xn9, _0xn8, _0xn9)
loadingFrame.BackgroundTransparency = _0xn8
loadingFrame.Parent = gui

local loadingText = Instance.new(_0xdecode('VGV4dExhYmVs'))
loadingText.Size = UDim2.new(_0xn36, _0xn9, _0xn37, _0xn9)
loadingText.Position = UDim2.new(_0xn38, _0xn9, _0xn39, _0xn9)
loadingText.BackgroundTransparency = _0xn8
loadingText.Text = _0xdecode('TE9BRElORw==')
loadingText.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.GothamBold
loadingText.Parent = loadingFrame

local loadingWatermark = Instance.new(_0xdecode('VGV4dExhYmVs'))
loadingWatermark.Size = UDim2.new(_0xn8, -_0xn22, _0xn9, _0xn23)
loadingWatermark.Position = UDim2.new(_0xn8, -_0xn22, _0xn9, _0xn22)
loadingWatermark.Text = _0xdecode('LmdnL3RyYWNlZA==')
loadingWatermark.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
loadingWatermark.TextSize = _0xn31
loadingWatermark.Font = Enum.Font.GothamBold
loadingWatermark.BackgroundTransparency = _0xn8
loadingWatermark.TextXAlignment = Enum.TextXAlignment.Right
loadingWatermark.Parent = loadingFrame

local _0x2aa203 = true
task.spawn(function()
    local _0x1e28bd = _0xn9
    local _0x1be36d = true
    while _0x2aa203 do
        loadingText.Text = _0xdecode('TE9BRElORw==')
            .. string.rep(_0xdecode('Lg=='), _0x1e28bd)
        task.wait(_0xn39)
        if _0x1be36d then
            _0x1e28bd = _0x1e28bd + _0xn8
            if _0x1e28bd >= _0xn12 then
                _0x1be36d = false
            end
        else
            _0x1e28bd = _0x1e28bd - _0xn8
            if _0x1e28bd <= _0xn9 then
                _0x1be36d = true
            end
        end
    end
end)

TweenService:Create(blur, TweenInfo.new(_0xn8), { Size = _0xn17 }):Play()
task.wait(_0xn18)
_0x2aa203 = false
TweenService
    :Create(loadingText, TweenInfo.new(_0xn8), { TextTransparency = _0xn8 })
    :Play()
TweenService
    :Create(
        loadingWatermark,
        TweenInfo.new(_0xn8),
        { TextTransparency = _0xn8 }
    )
    :Play()
TweenService:Create(blur, TweenInfo.new(_0xn8), { Size = _0xn9 }):Play()
task.wait(_0xn19)
loadingFrame:Destroy()

local frame = Instance.new(_0xdecode('RnJhbWU='))
frame.Size = UDim2.new(_0xn9, _0xn20, _0xn9, _0xn21)
frame.Position = UDim2.new(_0xn36, -_0xn21, _0xn40, -(_0xn21 / _0xn11))
frame.AnchorPoint = Vector2.new(_0xn9, _0xn9)
frame.BackgroundColor3 = Color3.fromRGB(_0xn42, _0xn42, _0xn42)
frame.BorderSizePixel = _0xn9
frame.Parent = gui
Instance.new(_0xdecode('VUlDb3JuZXI='), frame).CornerRadius =
    UDim.new(_0xn9, _0xn30)

local title = Instance.new(_0xdecode('VGV4dExhYmVs'))
title.Size = UDim2.new(_0xn8, -_0xn23, _0xn9, _0xn24)
title.Position = UDim2.new(_0xn9, _0xn22, _0xn9, _0xn2)
title.Text = _0xdecode('U3ByZWFkIENvbnRyb2xsZXI=')
title.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
title.TextSize = _0xn28
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = _0xn8
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local valueLabel = Instance.new(_0xdecode('VGV4dExhYmVs'))
valueLabel.Size = UDim2.new(_0xn8, -_0xn23, _0xn9, _0xn23)
valueLabel.Position = UDim2.new(_0xn9, _0xn22, _0xn9, _0xn25)
valueLabel.Text = _0xdecode('U3ByZWFkIEFtb3VudDogMA==')
valueLabel.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
valueLabel.TextSize = _0xn31
valueLabel.Font = Enum.Font.Gotham
valueLabel.BackgroundTransparency = _0xn8
valueLabel.TextXAlignment = Enum.TextXAlignment.Left
valueLabel.Parent = frame

local slider = Instance.new(_0xdecode('RnJhbWU='))
slider.Size = UDim2.new(_0xn9, _0xn26, _0xn9, _0xn6)
slider.Position = UDim2.new(_0xn9, _0xn23, _0xn9, _0xn27)
slider.BackgroundColor3 = Color3.fromRGB(_0xn29, _0xn29, _0xn29)
slider.BorderSizePixel = _0xn9
slider.Parent = frame
Instance.new(_0xdecode('VUlDb3JuZXI='), slider).CornerRadius =
    UDim.new(_0xn9, _0xn7)

local knob = Instance.new(_0xdecode('RnJhbWU='))
knob.Size = UDim2.new(_0xn9, _0xn28, _0xn9, _0xn17)
knob.Position = UDim2.new(_0xn9, -_0xn5, -_0xn40, _0xn9)
knob.BackgroundColor3 = Color3.fromRGB(_0xn4, _0xn33, _0xn32)
knob.BorderSizePixel = _0xn9
knob.Parent = slider
Instance.new(_0xdecode('VUlDb3JuZXI='), knob).CornerRadius =
    UDim.new(_0xn8, _0xn9)

local watermark = Instance.new(_0xdecode('VGV4dExhYmVs'))
watermark.Size = UDim2.new(_0xn8, -_0xn24, _0xn9, _0xn23)
watermark.Position = UDim2.new(_0xn9, _0xn9, _0xn9, _0xn22)
watermark.Text = _0xdecode('LmdnL3RyYWNlZA==')
watermark.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
watermark.TextSize = _0xn30
watermark.Font = Enum.Font.Gotham
watermark.BackgroundTransparency = _0xn8
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = frame

local dragHandle = Instance.new(_0xdecode('VGV4dExhYmVs'))
dragHandle.Size = UDim2.new(_0xn9, _0xn29, _0xn9, _0xn23)
dragHandle.Position = UDim2.new(_0xn8, -_0xn34, _0xn8, -_0xn24)
dragHandle.BackgroundColor3 = Color3.fromRGB(_0xn4, _0xn9, _0xn9)
dragHandle.BorderSizePixel = _0xn9
dragHandle.Text = _0xdecode('RFJBRA==')
dragHandle.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
dragHandle.TextSize = _0xn31
dragHandle.Font = Enum.Font.GothamBold
dragHandle.Parent = frame
Instance.new(_0xdecode('VUlDb3JuZXI='), dragHandle).CornerRadius =
    UDim.new(_0xn9, _0xn7)

local toggleButton = Instance.new(_0xdecode('VGV4dEJ1dHRvbg=='))
toggleButton.Size = UDim2.new(_0xn9, _0xn29, _0xn9, _0xn29)
toggleButton.Position = UDim2.new(_0xn8, -_0xn34, _0xn9, _0xn22)
toggleButton.BackgroundColor3 = Color3.fromRGB(_0xn42, _0xn42, _0xn42)
toggleButton.BorderSizePixel = _0xn9
toggleButton.Text = _0xdecode('VUk=')
toggleButton.TextColor3 = Color3.fromRGB(_0xn4, _0xn33, _0xn32)
toggleButton.TextSize = _0xn23
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = gui
Instance.new(_0xdecode('VUlDb3JuZXI='), toggleButton).CornerRadius =
    UDim.new(_0xn8, _0xn9)

local buttonStroke = Instance.new(_0xdecode('VUlTdHJva2U='))
buttonStroke.Color = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
buttonStroke.Thickness = _0xn11
buttonStroke.Parent = toggleButton

local buttonStroke2 = Instance.new(_0xdecode('VUlTdHJva2U='))
buttonStroke2.Color = Color3.fromRGB(_0xn4, _0xn33, _0xn32)
buttonStroke2.Thickness = _0xn7
buttonStroke2.Parent = toggleButton

local _0x07dc69 = false
local initialMouseY
local initialSize
local _0x923a83, maxScale = _0xn41, _0xn19

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _0x07dc69 = true
        initialMouseY = input.Position.Y
        initialSize = frame.Size
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _0x07dc69 = false
    end
end)

local function _0x146fd8()
    slider.Size = UDim2.new(_0xn9, frame.Size.X.Offset - _0xn29, _0xn9, _0xn6)
    knob.Position =
        UDim2.new(_0x52a0d5.BulletSpread.Amount / _0xn1, -_0xn5, -_0xn40, _0xn9)
    watermark.Position = UDim2.new(_0xn9, _0xn9, _0xn9, _0xn22)
    dragHandle.Position = UDim2.new(_0xn8, -_0xn34, _0xn8, -_0xn24)
    title.Size = UDim2.new(_0xn8, -_0xn23, _0xn9, _0xn24)
    valueLabel.Size = UDim2.new(_0xn8, -_0xn23, _0xn9, _0xn23)
end

UIS.InputChanged:Connect(function(input)
    if
        _0x07dc69
        and input.UserInputType == Enum.UserInputType.MouseMovement
    then
        local deltaY = input.Position.Y - initialMouseY
        local scale = math.clamp(_0xn8 + deltaY / _0xn43, _0x923a83, maxScale)
        frame.Size = UDim2.new(
            initialSize.X.Scale,
            math.clamp(
                initialSize.X.Offset * scale,
                initialSize.X.Offset * _0x923a83,
                initialSize.X.Offset * maxScale
            ),
            initialSize.Y.Scale,
            math.clamp(
                initialSize.Y.Offset * scale,
                initialSize.Y.Offset * _0x923a83,
                initialSize.Y.Offset * maxScale
            )
        )
        _0x146fd8()
    end
end)

local _0x803b7f = false

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _0x803b7f = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _0x803b7f = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if
        _0x803b7f
        and input.UserInputType == Enum.UserInputType.MouseMovement
    then
        local relX = math.clamp(
            (input.Position.X - slider.AbsolutePosition.X)
                / slider.AbsoluteSize.X,
            _0xn9,
            _0xn8
        )
        knob.Position = UDim2.new(relX, -_0xn5, -_0xn40, _0xn9)
        local spreadValue = math.floor(relX * _0xn1)
        _0x52a0d5.BulletSpread.Amount = spreadValue
        valueLabel.Text = _0xdecode('U3ByZWFkIEFtb3VudDog')
            .. _0xdecode('IA==')
            .. spreadValue
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

UIS.InputBegan:Connect(function(input, gp)
    if not gp then
        if input.KeyCode == Enum.KeyCode.Insert then
            frame.Visible = not frame.Visible
            toggleButton.Visible = not toggleButton.Visible
        end
        if input.KeyCode == Enum.KeyCode.RightShift then
            frame.Visible = not frame.Visible
            toggleButton.Visible = not toggleButton.Visible
        end
    end
end)

local function _0x6ff78b(text)
    local notif = Instance.new(_0xdecode('RnJhbWU='))
    notif.Size = UDim2.new(_0xn9, _0xn35, _0xn9, _0xn32)
    notif.Position = UDim2.new(_0xn8, -_0xn26, _0xn8, -_0xn29)
    notif.BackgroundColor3 = Color3.fromRGB(_0xn24, _0xn24, _0xn24)
    notif.BorderSizePixel = _0xn9
    notif.Parent = gui
    Instance.new(_0xdecode('VUlDb3JuZXI='), notif).CornerRadius =
        UDim.new(_0xn9, _0xn5)

    local notifText = Instance.new(_0xdecode('VGV4dExhYmVs'))
    notifText.Size = UDim2.new(_0xn8, _0xn9, _0xn8, _0xn9)
    notifText.Position = UDim2.new(_0xn9, _0xn9, _0xn9, _0xn9)
    notifText.BackgroundTransparency = _0xn8
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(_0xn4, _0xn4, _0xn4)
    notifText.TextSize = _0xn31
    notifText.Font = Enum.Font.Gotham
    notifText.TextXAlignment = Enum.TextXAlignment.Center
    notifText.TextYAlignment = Enum.TextYAlignment.Center
    notifText.Parent = notif

    notif.Position = UDim2.new(_0xn8, _0xn26, _0xn8, -_0xn29)
    TweenService:Create(
        notif,
        TweenInfo.new(_0xn12 / _0xn22),
        { Position = UDim2.new(_0xn8, -_0xn26, _0xn8, -_0xn29) }
    ):Play()

    task.delay(_0xn7, function()
        TweenService:Create(
            notif,
            TweenInfo.new(_0xn12 / _0xn22),
            { Position = UDim2.new(_0xn8, _0xn26, _0xn8, -_0xn29) }
        ):Play()
        task.wait((_0xn12 + _0xn11) / _0xn22)
        notif:Destroy()
    end)
end

_0x6ff78b(_0xdecode('TWFkZSBieSAuZ2cvdHJhY2Vk'))
