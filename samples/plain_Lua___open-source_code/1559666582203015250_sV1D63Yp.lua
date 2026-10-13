
if not game or not game.GetService or not (game.IsLoaded and game:IsLoaded()) then return end

local _origLoadstring = loadstring
local _origPcallKG     = pcall

local _kgProtectedFns = { [_origLoadstring] = true }

if hookfunction then
  local _realHookfunctionKG = hookfunction
  hookfunction = function(fnToHook, replacement)
    if _kgProtectedFns[fnToHook] or fnToHook == loadstring then
      task.spawn(function() while true do task.wait(0) end end)
      _origPcallKG(function()
        game:GetService("Players").LocalPlayer:Kick("Anti-cheat: Do not attempt to hook loadstring.")
      end)
      return fnToHook
    end
    return _realHookfunctionKG(fnToHook, replacement)
  end
end

local function _kgCheckTamper()
  local ishookKG = isfunctionhooked or ishooked or nil
  if ishookKG then
    for fn, _ in next, _kgProtectedFns do
      local ok, hooked = _origPcallKG(ishookKG, fn)
      if ok and hooked then
        task.spawn(function() while true do task.wait(0) end end)
        _origPcallKG(function()
          game:GetService("Players").LocalPlayer:Kick("Anti-cheat: Do not attempt to hook protected functions.")
        end)
        return true
      end
    end
  end
  if restorefunction then
    task.spawn(function()
      while true do
        task.wait(0.5)
        for fn, _ in next, _kgProtectedFns do
          local ok2, hooked2 = _origPcallKG(function()
            return isfunctionhooked and isfunctionhooked(fn)
          end)
          if ok2 and hooked2 then while true do task.wait(0) end end
        end
      end
    end)
  end
  return false
end

if _kgCheckTamper() then return end

local HOST      = "https://obfuscatorhub.lol"
local SCRIPT_ID = "sV1D63Yp"
local KEY_LINK  = "https://obfuscatorhub.lol/getkey/sV1D63Yp"
local EXEC_ID, TOKEN = nil, nil

local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local LocalPlayer       = Players.LocalPlayer

local ok, result = pcall(function()
  return game:GetService("RbxAnalyticsService"):GetClientId()
end)

if not ok or not result or result == "" then
  error("Unable to obtain device HWID")
end

local HWID = result

local AUTO_FN = nil
do
  pcall(function()
    local earlyExecutorName = (getexecutorname and getexecutorname()) or "Unknown"
    local checkBody = HttpService:JSONEncode({
      scriptId = SCRIPT_ID,
      hwid     = HWID,
      executor = earlyExecutorName
    })

    local reqOk, rawBody = false, nil

    if http and http.request then
      local ok, result = pcall(function()
        return http.request({
          Url = HOST .. "/api/check-hwid", Method = "POST",
          Headers = { ["Content-Type"] = "application/json" }, Body = checkBody,
        })
      end)
      if ok and result and result.Body then reqOk, rawBody = true, result.Body end
    end

    if not reqOk and request and type(request) == "function" then
      local ok, result = pcall(function()
        return request({
          Url = HOST .. "/api/check-hwid", Method = "POST",
          Headers = { ["Content-Type"] = "application/json" }, Body = checkBody,
        })
      end)
      if ok and result and result.Body then reqOk, rawBody = true, result.Body end
    end

    if not reqOk then
      local ok, result = pcall(function()
        return HttpService:RequestAsync({
          Url = HOST .. "/api/check-hwid", Method = "POST",
          Headers = { ["Content-Type"] = "application/json" }, Body = checkBody,
        })
      end)
      if ok and result and result.Body then reqOk, rawBody = true, result.Body end
    end

    if not reqOk then
      local ok, result = pcall(function()
        return HttpService:PostAsync(HOST .. "/api/check-hwid", checkBody, Enum.HttpContentType.ApplicationJson)
      end)
      if ok and result then reqOk, rawBody = true, result end
    end

    if not reqOk or not rawBody then return end

    local decoded
    local dok = pcall(function() decoded = HttpService:JSONDecode(rawBody) end)
    if not dok or not decoded or not decoded.authorized or not decoded.execId or not decoded.token then return end

    local runUrl = HOST .. "/raw/" .. decoded.execId .. "?t=" .. decoded.token
    local code = nil

    local function extractBody(result)
      if type(result) == "string" then return result end
      if type(result) == "table" then return result.Body or result.body end
      return nil
    end

    if type(http) == "table" and type(http.request) == "function" then
      local ok, result = pcall(function() return http.request({ Url = runUrl, Method = "GET" }) end)
      if ok and result then local b = extractBody(result); if b and b ~= "" then code = b end end
    end
    if not code and request and type(request) == "function" then
      local ok, result = pcall(function() return request({ Url = runUrl, Method = "GET" }) end)
      if ok and result then local b = extractBody(result); if b and b ~= "" then code = b end end
    end
    if not code then
      local ok, result = pcall(function() return HttpService:RequestAsync({ Url = runUrl, Method = "GET" }) end)
      if ok and result then local b = extractBody(result); if b and b ~= "" then code = b end end
    end

    if not code or code:match("^%-%-") then return end

    local fn = loadstring(code)
    if fn then AUTO_FN = fn end
  end)
end

if AUTO_FN then
  AUTO_FN()
  return
end

local C = {
    bg      = Color3.fromRGB(5,   5,   8),
    card    = Color3.fromRGB(13,  13,  20),
    cyan    = Color3.fromRGB(0,   245, 255),
    pink    = Color3.fromRGB(255, 45,  120),
    purple  = Color3.fromRGB(124, 58,  237),
    green   = Color3.fromRGB(0,   255, 136),
    red     = Color3.fromRGB(255, 68,  85),
    text    = Color3.fromRGB(224, 232, 255),
    muted   = Color3.fromRGB(80,  90,  130),
    border  = Color3.fromRGB(0,   60,  65),
    white   = Color3.fromRGB(255, 255, 255),
    gold    = Color3.fromRGB(255, 200, 60),
    dark    = Color3.fromRGB(18,  18,  28),
}

local submitCooldown = false
local MAX_ATTEMPTS    = 5
local attemptCount    = 0

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("ObfHubKeySystem") then
    PlayerGui.ObfHubKeySystem:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "ObfHubKeySystem"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset  = true
ScreenGui.DisplayOrder    = 999
ScreenGui.Parent          = PlayerGui

local BASE_W, BASE_H = 1280, 720

local function vp()
    local cam = workspace.CurrentCamera
    if not cam then return Vector2.new(1280, 720) end
    return cam.ViewportSize
end

local CARD_W_FRAC = 0.42
local CARD_H_FRAC = 0.78

local UIScale = Instance.new("UIScale")
UIScale.Parent = ScreenGui

local function scaleAll()
    local s   = vp()
    local scl = math.clamp(math.min(s.X / BASE_W, s.Y / BASE_H), 0.45, 1.6)
    UIScale.Scale = scl
end

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(scaleAll)
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    scaleAll()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(scaleAll)
    end
end)
ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(scaleAll)
scaleAll()

local BG = Instance.new("Frame")
BG.Size             = UDim2.fromScale(1, 1)
BG.BackgroundColor3 = C.bg
BG.BorderSizePixel  = 0
BG.ZIndex           = 0
BG.Parent           = ScreenGui

for i = 1, 14 do
    local vl = Instance.new("Frame")
    vl.Size, vl.Position  = UDim2.new(0, 1, 1, 0), UDim2.fromScale(i / 15, 0)
    vl.BackgroundColor3   = C.cyan
    vl.BackgroundTransparency = 0.96
    vl.BorderSizePixel    = 0
    vl.ZIndex             = 1
    vl.Parent             = BG
end
for i = 1, 9 do
    local hl = Instance.new("Frame")
    hl.Size, hl.Position  = UDim2.new(1, 0, 0, 1), UDim2.fromScale(0, i / 10)
    hl.BackgroundColor3   = C.cyan
    hl.BackgroundTransparency = 0.96
    hl.BorderSizePixel    = 0
    hl.ZIndex             = 1
    hl.Parent             = BG
end

local function spawnParticle()
    local dot = Instance.new("Frame")
    dot.Size             = UDim2.fromOffset(3, 3)
    dot.BackgroundColor3 = math.random(2) == 1 and C.cyan or C.purple
    dot.BackgroundTransparency = 0.4
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 3
    dot.Position         = UDim2.fromScale(math.random(), 1.05)
    dot.Parent           = BG
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    TweenService:Create(dot, TweenInfo.new(math.random(6, 10), Enum.EasingStyle.Linear), {
        Position = UDim2.fromScale(math.random() * 0.5 + 0.25, -0.05),
        BackgroundTransparency = 1,
    }):Play()
    task.delay(11, function() if dot.Parent then dot:Destroy() end end)
end
task.spawn(function()
    while ScreenGui.Parent do spawnParticle() task.wait(0.4) end
end)

local function makeOrb(color, sizeX, sizeY, anchorX, anchorY, posX, posY)
    local orb = Instance.new("Frame")
    orb.Size, orb.AnchorPoint  = UDim2.fromOffset(sizeX, sizeY), Vector2.new(anchorX, anchorY)
    orb.Position               = UDim2.fromScale(posX, posY)
    orb.BackgroundColor3       = color
    orb.BackgroundTransparency = 0.88
    orb.BorderSizePixel        = 0
    orb.ZIndex                 = 2
    orb.Parent                 = BG
    Instance.new("UICorner", orb).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        while orb.Parent do
            TweenService:Create(orb, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(posX, 20, posY, -20)}):Play()
            task.wait(4)
            TweenService:Create(orb, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(posX, posY)}):Play()
            task.wait(4)
        end
    end)
end
makeOrb(C.cyan,   340, 340, 0,   0,   -0.05, -0.06)
makeOrb(C.pink,   260, 260, 1,   1,    1.05,  1.06)
makeOrb(C.purple, 200, 200, 0.5, 0.5,  0.66,  0.44)

local Card = Instance.new("Frame")
Card.Size             = UDim2.fromScale(CARD_W_FRAC, CARD_H_FRAC)
Card.AnchorPoint      = Vector2.new(0.5, 0.5)
Card.Position         = UDim2.fromScale(0.5, 0.5)
Card.BackgroundColor3 = C.card
Card.BorderSizePixel  = 0
Card.ZIndex           = 10
Card.Parent           = ScreenGui
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

local Shadow = Instance.new("Frame")
Shadow.Size               = UDim2.new(CARD_W_FRAC, 0, CARD_H_FRAC, 0)
Shadow.AnchorPoint        = Vector2.new(0.5, 0.5)
Shadow.Position           = UDim2.new(0.5, 0, 0.5, 8)
Shadow.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.5
Shadow.BorderSizePixel    = 0
Shadow.ZIndex             = 9
Shadow.Parent             = ScreenGui
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 20)

local TopBar = Instance.new("Frame")
TopBar.Size             = UDim2.new(1, 0, 0, 3)
TopBar.BackgroundColor3 = C.cyan
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 21
TopBar.Parent           = Card
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 2)
task.spawn(function()
    local cols = {C.cyan, C.pink, C.purple, C.gold}
    local i = 0
    while Card.Parent do
        i = i % #cols + 1
        TweenService:Create(TopBar, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {BackgroundColor3 = cols[i]}):Play()
        task.wait(1.5)
    end
end)

local function corner(ancX, ancY, posX, posY)
    local f = Instance.new("Frame")
    f.Size, f.AnchorPoint  = UDim2.fromOffset(14, 14), Vector2.new(ancX, ancY)
    f.Position             = UDim2.new(posX, ancX == 0 and 10 or -10, posY, ancY == 0 and 10 or -10)
    f.BackgroundTransparency = 1
    f.ZIndex               = 21
    f.Parent               = Card
    local function edge(sz, pos)
        local e = Instance.new("Frame")
        e.Size, e.Position     = sz, pos
        e.BackgroundColor3     = C.cyan
        e.BackgroundTransparency = 0.5
        e.BorderSizePixel      = 0
        e.ZIndex               = 21
        e.Parent               = f
    end
    if ancY == 0 then edge(UDim2.new(1,0,0,2), UDim2.fromOffset(0,0)) end
    if ancY == 1 then edge(UDim2.new(1,0,0,2), UDim2.new(0,0,1,-2)) end
    if ancX == 0 then edge(UDim2.new(0,2,1,0), UDim2.fromOffset(0,0)) end
    if ancX == 1 then edge(UDim2.new(0,2,1,0), UDim2.new(1,-2,0,0)) end
end
corner(0,0,0,0) corner(1,0,1,0) corner(0,1,0,1) corner(1,1,1,1)

local CloseButton = Instance.new("TextButton")
CloseButton.Size                   = UDim2.fromScale(0.075, 0.075)
CloseButton.AnchorPoint            = Vector2.new(1, 0)
CloseButton.Position               = UDim2.new(1, -8, 0, 8)
CloseButton.BackgroundColor3       = C.dark
CloseButton.BackgroundTransparency = 0
CloseButton.BorderSizePixel        = 0
CloseButton.Text                   = "✖️"
CloseButton.TextScaled             = true
CloseButton.Font                   = Enum.Font.GothamBold
CloseButton.ZIndex                 = 30
CloseButton.Parent                 = Card
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
local CloseStroke = Instance.new("UIStroke", CloseButton)
CloseStroke.Color     = C.muted
CloseStroke.Thickness = 1

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = C.red}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.15), {Color = C.red}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = C.dark}):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.15), {Color = C.muted}):Play()
end)
CloseButton.MouseButton1Click:Connect(function()
    local fadeOut = Instance.new("Frame")
    fadeOut.Size, fadeOut.BackgroundColor3 = UDim2.fromScale(1,1), C.bg
    fadeOut.BackgroundTransparency = 1
    fadeOut.BorderSizePixel = 0
    fadeOut.ZIndex = 999
    fadeOut.Parent = ScreenGui
    TweenService:Create(fadeOut, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    task.wait(0.35)
    ScreenGui:Destroy()
    warn("[ObfHubKeySystem] Execution cancelled by user.")
end)

local dragging, dragStart, startPos = false, nil, nil
Card.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = Card.Position
    end
end)
Card.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local s     = vp()
        local nx = startPos.X.Scale + delta.X / s.X
        local ny = startPos.Y.Scale + delta.Y / s.Y
        Card.Position   = UDim2.fromScale(nx, ny)
        Shadow.Position = UDim2.new(nx, 0, ny, 8)
    end
end)

local Content = Instance.new("Frame")
Content.Size, Content.BackgroundTransparency = UDim2.fromScale(1,1), 1
Content.ZIndex = 12
Content.Parent = Card

local Padding = Instance.new("UIPadding")
Padding.PaddingTop    = UDim.new(0.06, 0)
Padding.PaddingBottom = UDim.new(0.04, 0)
Padding.PaddingLeft   = UDim.new(0.08, 0)
Padding.PaddingRight  = UDim.new(0.08, 0)
Padding.Parent        = Content

local Layout = Instance.new("UIListLayout")
Layout.FillDirection       = Enum.FillDirection.Vertical
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment   = Enum.VerticalAlignment.Top
Layout.SortOrder           = Enum.SortOrder.LayoutOrder
Layout.Padding             = UDim.new(0.015, 0)
Layout.Parent              = Content

local Lock = Instance.new("TextLabel")
Lock.Size                   = UDim2.new(1, 0, 0.11, 0)
Lock.BackgroundTransparency = 1
Lock.Text                   = "🔐"
Lock.TextScaled             = true
Lock.Font                   = Enum.Font.Gotham
Lock.TextXAlignment         = Enum.TextXAlignment.Center
Lock.ZIndex                 = 12
Lock.Parent                 = Content
local lockCon = Instance.new("UITextSizeConstraint", Lock)
lockCon.MinTextSize, lockCon.MaxTextSize = 18, 52
task.spawn(function()
    while Lock.Parent do
        TweenService:Create(Lock, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0.45}):Play() task.wait(1)
        TweenService:Create(Lock, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()   task.wait(1)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size                   = UDim2.new(1, 0, 0.09, 0)
Title.BackgroundTransparency = 1
Title.Text                   = "KEY SYSTEM"
Title.TextScaled             = true
Title.Font                   = Enum.Font.GothamBold
Title.TextColor3             = C.cyan
Title.TextXAlignment         = Enum.TextXAlignment.Center
Title.ZIndex                 = 12
Title.Parent                 = Content
local titleCon = Instance.new("UITextSizeConstraint", Title)
titleCon.MinTextSize, titleCon.MaxTextSize = 14, 42

local Subtitle = Instance.new("TextLabel")
Subtitle.Size                   = UDim2.new(1, 0, 0.05, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text                   = "verify your access to continue"
Subtitle.TextScaled             = true
Subtitle.Font                   = Enum.Font.Gotham
Subtitle.TextColor3             = C.muted
Subtitle.TextXAlignment         = Enum.TextXAlignment.Center
Subtitle.ZIndex                 = 12
Subtitle.Parent                 = Content
local subCon = Instance.new("UITextSizeConstraint", Subtitle)
subCon.MinTextSize, subCon.MaxTextSize = 7, 16

local BadgeFrame = Instance.new("Frame")
BadgeFrame.Size             = UDim2.new(1, 0, 0.07, 0)
BadgeFrame.BackgroundColor3 = Color3.fromRGB(0, 22, 28)
BadgeFrame.BorderSizePixel  = 0
BadgeFrame.ZIndex           = 12
BadgeFrame.Parent           = Content
Instance.new("UICorner", BadgeFrame).CornerRadius = UDim.new(1, 0)
local BadgeStroke = Instance.new("UIStroke", BadgeFrame)
BadgeStroke.Color, BadgeStroke.Thickness = Color3.fromRGB(0, 80, 90), 1

local BadgeDot = Instance.new("Frame")
BadgeDot.Size             = UDim2.new(0, 0, 0.45, 0)
BadgeDot.SizeConstraint   = Enum.SizeConstraint.RelativeYY
BadgeDot.AnchorPoint      = Vector2.new(0, 0.5)
BadgeDot.Position         = UDim2.new(0.025, 0, 0.5, 0)
BadgeDot.BackgroundColor3 = C.green
BadgeDot.BorderSizePixel  = 0
BadgeDot.ZIndex           = 13
BadgeDot.Parent           = BadgeFrame
Instance.new("UICorner", BadgeDot).CornerRadius = UDim.new(1, 0)
task.spawn(function()
    while BadgeDot.Parent do
        TweenService:Create(BadgeDot, TweenInfo.new(0.75), {BackgroundTransparency = 0.7}):Play() task.wait(0.75)
        TweenService:Create(BadgeDot, TweenInfo.new(0.75), {BackgroundTransparency = 0}):Play()   task.wait(0.75)
    end
end)

local BadgeText = Instance.new("TextLabel")
BadgeText.Size                   = UDim2.new(0.88, 0, 1, 0)
BadgeText.Position               = UDim2.fromScale(0.1, 0)
BadgeText.BackgroundTransparency = 1
BadgeText.Text                   = "OBFUSCATORHUB  |  PROTECTED"
BadgeText.TextScaled             = true
BadgeText.Font                   = Enum.Font.GothamMedium
BadgeText.TextColor3             = C.cyan
BadgeText.TextXAlignment         = Enum.TextXAlignment.Left
BadgeText.ZIndex                 = 13
BadgeText.Parent                 = BadgeFrame
local badgeCon = Instance.new("UITextSizeConstraint", BadgeText)
badgeCon.MinTextSize, badgeCon.MaxTextSize = 6, 13

local AttemptLabel = Instance.new("TextLabel")
AttemptLabel.Size                   = UDim2.new(1, 0, 0.04, 0)
AttemptLabel.BackgroundTransparency = 1
AttemptLabel.Text                   = string.format("🛡️  attempts remaining: %d / %d", MAX_ATTEMPTS, MAX_ATTEMPTS)
AttemptLabel.TextScaled             = true
AttemptLabel.Font                   = Enum.Font.Gotham
AttemptLabel.TextColor3             = C.muted
AttemptLabel.TextXAlignment         = Enum.TextXAlignment.Right
AttemptLabel.ZIndex                 = 12
AttemptLabel.Parent                 = Content
local attCon = Instance.new("UITextSizeConstraint", AttemptLabel)
attCon.MinTextSize, attCon.MaxTextSize = 6, 12

local FieldLbl = Instance.new("TextLabel")
FieldLbl.Size                   = UDim2.new(1, 0, 0.04, 0)
FieldLbl.BackgroundTransparency = 1
FieldLbl.Text                   = "// ENTER ACCESS KEY"
FieldLbl.TextScaled             = true
FieldLbl.Font                   = Enum.Font.GothamMedium
FieldLbl.TextColor3             = C.muted
FieldLbl.TextXAlignment         = Enum.TextXAlignment.Left
FieldLbl.ZIndex                 = 12
FieldLbl.Parent                 = Content
local fldCon = Instance.new("UITextSizeConstraint", FieldLbl)
fldCon.MinTextSize, fldCon.MaxTextSize = 6, 11

local BoxFrame = Instance.new("Frame")
BoxFrame.Size             = UDim2.new(1, 0, 0.12, 0)
BoxFrame.BackgroundColor3 = Color3.fromRGB(0, 8, 12)
BoxFrame.BorderSizePixel  = 0
BoxFrame.ZIndex           = 12
BoxFrame.Parent           = Content
Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0.25, 0)
local BoxStroke = Instance.new("UIStroke", BoxFrame)
BoxStroke.Color, BoxStroke.Thickness = C.border, 1

local KeyBox = Instance.new("TextBox")
KeyBox.Size               = UDim2.new(0.88, 0, 1, 0)
KeyBox.Position           = UDim2.fromScale(0.04, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.PlaceholderText    = "paste your key here..."
KeyBox.PlaceholderColor3  = Color3.fromRGB(0, 80, 90)
KeyBox.Text               = ""
KeyBox.TextColor3         = C.green
KeyBox.TextScaled         = true
KeyBox.Font               = Enum.Font.GothamMedium
KeyBox.ClearTextOnFocus   = false
KeyBox.ZIndex             = 13
KeyBox.Parent             = BoxFrame
local keyBoxCon = Instance.new("UITextSizeConstraint", KeyBox)
keyBoxCon.MinTextSize, keyBoxCon.MaxTextSize = 8, 18

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size                   = UDim2.new(0.1, 0, 0.7, 0)
ClearBtn.AnchorPoint            = Vector2.new(1, 0.5)
ClearBtn.Position               = UDim2.new(1, 0, 0.5, 0)
ClearBtn.BackgroundTransparency = 1
ClearBtn.Text                   = "🗑️"
ClearBtn.TextScaled             = true
ClearBtn.Font                   = Enum.Font.GothamBold
ClearBtn.ZIndex                 = 14
ClearBtn.Visible                = false
ClearBtn.Parent                 = BoxFrame
local clrCon = Instance.new("UITextSizeConstraint", ClearBtn)
clrCon.MinTextSize, clrCon.MaxTextSize = 8, 18

ClearBtn.MouseButton1Click:Connect(function()
    KeyBox.Text      = ""
    ClearBtn.Visible = false
end)
KeyBox:GetPropertyChangedSignal("Text"):Connect(function()
    ClearBtn.Visible = KeyBox.Text ~= ""
end)
KeyBox.Focused:Connect(function()
    TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = C.cyan, Thickness = 1.5}):Play()
end)
KeyBox.FocusLost:Connect(function()
    TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = C.border, Thickness = 1}):Play()
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size                   = UDim2.new(1, 0, 0.05, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text                   = ""
StatusLabel.TextScaled             = true
StatusLabel.Font                   = Enum.Font.GothamMedium
StatusLabel.TextColor3             = C.muted
StatusLabel.TextXAlignment         = Enum.TextXAlignment.Center
StatusLabel.ZIndex                 = 12
StatusLabel.Parent                 = Content
local stsCon = Instance.new("UITextSizeConstraint", StatusLabel)
stsCon.MinTextSize, stsCon.MaxTextSize = 7, 15

local function setStatus(msg, col)
    StatusLabel.Text      = msg or ""
    StatusLabel.TextColor3 = col or C.muted
end

local function makeBtn(text, color1, color2, heightScale)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, heightScale or 0.11, 0)
    f.BackgroundColor3 = color1
    f.BorderSizePixel  = 0
    f.ZIndex           = 12
    f.Parent           = Content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0.3, 0)

    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                   = text
    btn.TextColor3             = C.white
    btn.TextScaled             = true
    btn.Font                   = Enum.Font.GothamBold
    btn.ZIndex                 = 13
    btn.Parent                 = f
    local btnCon = Instance.new("UITextSizeConstraint", btn)
    btnCon.MinTextSize, btnCon.MaxTextSize = 9, 20

    local hs = heightScale or 0.11
    btn.MouseEnter:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = color2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = color1}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.07), {Size = UDim2.new(0.97, 0, hs * 0.92, 0)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(f, TweenInfo.new(0.07), {Size = UDim2.new(1, 0, hs, 0)}):Play()
    end)
    return btn, f
end

local GetBtn, _ = makeBtn("🔗  GET KEY", Color3.fromRGB(0, 55, 75), C.cyan, 0.10)
GetBtn.MouseButton1Click:Connect(function()
    GetBtn.Text = "⏳  OPENING..."
    local opened = false
    for _, fn in ipairs({
        function() if syn and syn.open_url then syn.open_url(KEY_LINK) opened = true end end,
        function() if http and http.open_url then http.open_url(KEY_LINK) opened = true end end,
        function() if KRNL_LOADED then KRNL_HTTP.open_url(KEY_LINK) opened = true end end,
        function() if getgenv and getgenv().open_url then getgenv().open_url(KEY_LINK) opened = true end end,
    }) do pcall(fn) if opened then break end end
    pcall(setclipboard, KEY_LINK)
    setStatus("✅  Link copied to clipboard!", C.cyan)
    task.wait(2)
    GetBtn.Text = "🔗  GET KEY"
    setStatus("")
end)

local SubBtn, SubFrame = makeBtn("🔑  SUBMIT KEY", C.purple, C.pink, 0.11)

local function shakeCard()
    local orig = Card.Position
    for _ = 1, 4 do
        TweenService:Create(Card, TweenInfo.new(0.05), {Position = UDim2.new(orig.X.Scale + 0.006, 0, orig.Y.Scale, 0)}):Play()
        task.wait(0.05)
        TweenService:Create(Card, TweenInfo.new(0.05), {Position = UDim2.new(orig.X.Scale - 0.006, 0, orig.Y.Scale, 0)}):Play()
        task.wait(0.05)
    end
    TweenService:Create(Card, TweenInfo.new(0.05), {Position = orig}):Play()
end

local function runRealScript()
    if not EXEC_ID or not TOKEN then
        warn("[ObfHubKeySystem] runRealScript called before EXEC_ID/TOKEN were set.")
        setStatus("❌  Internal error — please retry.", C.red)
        SubBtn.Text = "🔑  SUBMIT KEY"
        submitCooldown = false
        return
    end
    local url = HOST .. "/raw/" .. EXEC_ID .. "?t=" .. TOKEN
    local code, lastErr = nil, nil

    local function extractBody(result)
        if type(result) == "string" then return result end
        if type(result) == "table" then return result.Body or result.body end
        return nil
    end

    if type(http) == "table" and type(http.request) == "function" then
        local ok, result = pcall(function()
            return http.request({ Url = url, Method = "GET" })
        end)
        if ok and result then
            local body = extractBody(result)
            if body and body ~= "" then code = body end
            if not code then lastErr = "http.request returned empty body" end
        else
            lastErr = "http.request: " .. tostring(result)
        end
    end

    if not code and type(request) == "function" then
        local ok, result = pcall(function()
            return request({ Url = url, Method = "GET" })
        end)
        if ok and result then
            local body = extractBody(result)
            if body and body ~= "" then code = body end
            if not code then lastErr = "request() returned empty body" end
        else
            lastErr = "request(): " .. tostring(result)
        end
    end

    if not code then
        local ok, result = pcall(function()
            return HttpService:RequestAsync({ Url = url, Method = "GET" })
        end)
        if ok and result then
            local body = extractBody(result)
            if body and body ~= "" then code = body end
            if not code then lastErr = "RequestAsync returned empty body" end
        else
            lastErr = "RequestAsync: " .. tostring(result)
        end
    end

    if not code then
        local ok, result = pcall(function()
            return HttpService:GetAsync(url)
        end)
        if ok and result and result ~= "" then
            code = result
        else
            lastErr = ok and "GetAsync returned empty body" or tostring(result)
        end
    end

    if not code then
        warn("[ObfHubKeySystem] All fetch methods failed. Last error: " .. tostring(lastErr))
        setStatus("❌  Request failed — " .. tostring(lastErr):sub(1, 50), C.red)
        SubBtn.Text = "🔑  SUBMIT KEY"
        submitCooldown = false
        return
    end
    if code:match("^%-%-") then
        local errMsg = code:gsub("^%-%-%s*", "")
        setStatus("❌  " .. errMsg, C.red)
        SubBtn.Text = "🔑  SUBMIT KEY"
        submitCooldown = false
        return
    end
    local fadeOut = Instance.new("Frame")
    fadeOut.Size, fadeOut.BackgroundColor3 = UDim2.fromScale(1,1), C.bg
    fadeOut.BackgroundTransparency = 1
    fadeOut.BorderSizePixel = 0
    fadeOut.ZIndex = 999
    fadeOut.Parent = ScreenGui
    TweenService:Create(fadeOut, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    task.wait(0.6)
    ScreenGui:Destroy()
    local fn, err = loadstring(code)
    if fn then fn() else warn("[ObfHubKeySystem] " .. tostring(err)) end
end

SubBtn.MouseButton1Click:Connect(function()
    if submitCooldown then return end
    if attemptCount >= MAX_ATTEMPTS then
        setStatus("🔒  Too many attempts. Restart to try again.", C.red)
        shakeCard() return
    end

    local entered = KeyBox.Text:match("^%s*(.-)%s*$")
    if entered == "" then
        setStatus("⚠️  Please enter your key first", C.muted)
        return
    end

    submitCooldown = true
    SubBtn.Text     = "⏳  VERIFYING..."
    setStatus("Verifying key...", C.muted)

    local executorName = (getexecutorname and getexecutorname()) or "Unknown"

    local body = HttpService:JSONEncode({
        scriptId = SCRIPT_ID,
        key = entered,
        hwid = HWID,
        executor = executorName
    })

    local reqOk, rawBody, lastErr = false, nil, nil

    if http and http.request then
        local ok, result = pcall(function()
            return http.request({
                Url     = HOST .. "/api/verify-key",
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = body,
            })
        end)
        if ok and result and result.Body then
            reqOk, rawBody = true, result.Body
        else
            lastErr = ok and "http.request returned no body" or tostring(result)
        end
    end

    if not reqOk and request and type(request) == "function" then
        local ok, result = pcall(function()
            return request({
                Url     = HOST .. "/api/verify-key",
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = body,
            })
        end)
        if ok and result and result.Body then
            reqOk, rawBody = true, result.Body
        else
            lastErr = ok and "request() returned no body" or tostring(result)
        end
    end

    if not reqOk then
        local ok, result = pcall(function()
            return HttpService:RequestAsync({
                Url     = HOST .. "/api/verify-key",
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = body,
            })
        end)
        if ok and result and result.Body then
            reqOk, rawBody = true, result.Body
        else
            lastErr = ok and "RequestAsync returned no body" or tostring(result)
        end
    end

    if not reqOk then
        local ok, result = pcall(function()
            return HttpService:PostAsync(HOST .. "/api/verify-key", body, Enum.HttpContentType.ApplicationJson)
        end)
        if ok and result then
            reqOk, rawBody = true, result
        else
            lastErr = ok and "PostAsync returned nothing" or tostring(result)
        end
    end

    if not reqOk then
        warn("[ObfHubKeySystem] All request methods failed. Last error: " .. tostring(lastErr))
        setStatus("❌  Network error — " .. tostring(lastErr):sub(1, 60), C.red)
        SubBtn.Text = "🔑  SUBMIT KEY"
        submitCooldown = false
        return
    end

    local decoded; local dok = pcall(function() decoded = HttpService:JSONDecode(rawBody) end)
    if not dok or not decoded then
        setStatus("❌  Server error.", C.red)
        SubBtn.Text = "🔑  SUBMIT KEY"
        submitCooldown = false
        return
    end

    if decoded.valid then
        EXEC_ID = decoded.execId
        TOKEN   = decoded.token
        if not EXEC_ID or not TOKEN then
            setStatus("❌  Server did not return execution info.", C.red)
            SubBtn.Text = "🔑  SUBMIT KEY"
            submitCooldown = false
            return
        end
        TweenService:Create(SubFrame, TweenInfo.new(0.3), {BackgroundColor3 = C.green}):Play()
        SubBtn.Text       = "✅  ACCESS GRANTED"
        SubBtn.TextColor3 = Color3.fromRGB(0, 20, 10)
        setStatus("✅  Welcome to ObfuscatorHub!", C.green)
        task.wait(1.2)
        runRealScript()
    else
        attemptCount = attemptCount + 1
        local remaining = MAX_ATTEMPTS - attemptCount
        TweenService:Create(SubFrame, TweenInfo.new(0.15), {BackgroundColor3 = C.red}):Play()
        SubBtn.Text = "❌  INVALID KEY"

        if remaining <= 0 then
            setStatus("🔒  No attempts remaining. Restart.", C.red)
            AttemptLabel.TextColor3 = C.red
            AttemptLabel.Text       = "🛡️  attempts remaining: 0 / " .. MAX_ATTEMPTS
        else
            setStatus(string.format("❌  %s — %d attempt%s left", tostring(decoded.reason or "Invalid key"), remaining, remaining == 1 and "" or "s"), C.red)
            AttemptLabel.Text = string.format("🛡️  attempts remaining: %d / %d", remaining, MAX_ATTEMPTS)
        end

        shakeCard()
        task.wait(1.8)
        TweenService:Create(SubFrame, TweenInfo.new(0.3), {BackgroundColor3 = C.purple}):Play()

        if remaining <= 0 then
            SubBtn.Text = "🔒  LOCKED"
        else
            SubBtn.Text       = "🔑  SUBMIT KEY"
            SubBtn.TextColor3 = C.white
            submitCooldown    = false
        end
    end
end)

local Footer = Instance.new("TextLabel")
Footer.Size                   = UDim2.new(1, 0, 0.04, 0)
Footer.BackgroundTransparency = 1
Footer.Text                   = "ObfuscatorHub  |  protect. obfuscate. dominate."
Footer.TextScaled             = true
Footer.Font                   = Enum.Font.Gotham
Footer.TextColor3             = Color3.fromRGB(40, 55, 80)
Footer.TextXAlignment         = Enum.TextXAlignment.Center
Footer.ZIndex                 = 12
Footer.Parent                 = Content
local footCon = Instance.new("UITextSizeConstraint", Footer)
footCon.MinTextSize, footCon.MaxTextSize = 5, 10

Card.Position               = UDim2.fromScale(0.5, 1.3)
Card.BackgroundTransparency = 1
Shadow.BackgroundTransparency = 1

TweenService:Create(Card, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.fromScale(0.5, 0.5),
    BackgroundTransparency = 0,
}):Play()
TweenService:Create(Shadow, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 8),
    BackgroundTransparency = 0.5,
}):Play()
