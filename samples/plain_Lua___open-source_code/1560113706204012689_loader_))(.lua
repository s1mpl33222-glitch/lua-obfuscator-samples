-- Avatar Copier · Loader v1.6.0
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local LOADER_VERSION = "1.6.0"
local DISCORD_INVITE = "https://discord.gg/8bxXcn2Vfb"
local COPY_DISCORD_ON_START = true -- copies the invite to the clipboard and shows the toast
local TOAST_MIN_SECONDS = 3.2      -- the toast stays at least this long, even if loading is instant
local loaderStarted = os.clock()
local ENV = getgenv and getgenv() or _G
if ENV.__LYRA_AVATAR_LOADING then return end
ENV.__LYRA_AVATAR_LOADING = true

local C = {
  Base = Color3.fromRGB(19, 18, 29), Card = Color3.fromRGB(30, 28, 45), Raised = Color3.fromRGB(41, 37, 59),
  Accent = Color3.fromRGB(188, 167, 246), AccentDark = Color3.fromRGB(111, 88, 161), AccentLight = Color3.fromRGB(231, 220, 255),
  Text = Color3.fromRGB(244, 239, 255), Muted = Color3.fromRGB(201, 193, 223),
  Green = Color3.fromRGB(137, 221, 187), Red = Color3.fromRGB(244, 151, 171),
}
local FONT, FONT_BOLD = Enum.Font.GothamMedium, Enum.Font.GothamBold
pcall(function() FONT = Enum.Font.BuilderSansMedium; FONT_BOLD = Enum.Font.BuilderSansBold end)

local function new(class, props, parent)
  local inst = Instance.new(class)
  for key, value in pairs(props or {}) do inst[key] = value end
  inst.Parent = parent
  return inst
end
local function tween(inst, info, goal)
  local t = TweenService:Create(inst, info, goal)
  t:Play()
  return t
end
local function info(duration, style, direction)
  return TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
end
local function corner(inst, radius) return new("UICorner", {CornerRadius = radius or UDim.new(0, 12)}, inst) end

local function mount(gui)
  local candidates = {}
  pcall(function() candidates[#candidates + 1] = game:GetService("CoreGui") end)
  pcall(function() if gethui then candidates[#candidates + 1] = gethui() end end)
  pcall(function() candidates[#candidates + 1] = player:FindFirstChildOfClass("PlayerGui") end)
  for _, parent in ipairs(candidates) do
    if parent and pcall(function() gui.Parent = parent end) and gui.Parent == parent then return true end
  end
  return false
end

local function copyText(text)
  local fn = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
  if type(fn) ~= "function" then return false end
  return (pcall(fn, text))
end

local function headerValue(res, name)
  if not res then return nil end
  local headers = res.Headers or res.headers
  if type(headers) ~= "table" then return nil end
  local target = string.lower(name)
  for key, value in pairs(headers) do
    if type(key) == "string" and string.lower(key) == target then return value end
  end
  return nil
end

local function newLine(parent, x1, y1, x2, y2, thick, color)
  local dx, dy = x2 - x1, y2 - y1
  local line = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
    Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + thick * 0.5, thick),
    Rotation = math.deg((math.atan2 or math.atan)(dy, dx)), BackgroundColor3 = color, BorderSizePixel = 0,
  }, parent)
  corner(line, UDim.new(1, 0))
  return line
end

local toastGui, toastHolder, toast, toastStroke, toastShownAt
local toastClosed = false

local function pulse(badge, color)
  local ring = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0}, badge)
  corner(ring, UDim.new(1, 0))
  local stroke = new("UIStroke", {Color = color, Thickness = 2, Transparency = 0.25}, ring)
  tween(ring, info(0.9), {Size = UDim2.fromScale(1.6, 1.6)})
  tween(stroke, info(0.9, Enum.EasingStyle.Quad), {Transparency = 1})
  task.delay(1, function() pcall(function() ring:Destroy() end) end)
end

local function buildToast(copied)
  pcall(function()
    local shortLink = DISCORD_INVITE:gsub("^https?://", "")
    local tint = copied and C.Green or C.Accent
    toastGui = new("ScreenGui", {Name = "LyraToast", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 1000000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    toastHolder = new("Frame", {
      Name = "Toast", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -96), Size = UDim2.new(0.92, 0, 0, 68), BackgroundTransparency = 1,
    }, toastGui)
    new("UISizeConstraint", {MaxSize = Vector2.new(390, 68)}, toastHolder)
    corner(toastHolder, UDim.new(0, 20))
    toastStroke = new("UIStroke", {Color = C.Accent, Thickness = 1.2, Transparency = 1}, toastHolder)
    toast = new("CanvasGroup", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, GroupTransparency = 1}, toastHolder)
    corner(toast, UDim.new(0, 20))
    local toastBg = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, toast)
    new("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(52, 45, 80), Color3.fromRGB(32, 29, 50)), Rotation = 20}, toastBg)

    local badge = new("Frame", {Position = UDim2.fromOffset(14, 14), Size = UDim2.fromOffset(40, 40), BackgroundColor3 = tint, BackgroundTransparency = 0.82, BorderSizePixel = 0}, toast)
    corner(badge, UDim.new(1, 0))
    new("UIStroke", {Color = tint, Thickness = 1.5, Transparency = 0.5}, badge)
    local mark = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1}, badge)
    local markScale = new("UIScale", {Scale = 0}, mark)
    if copied then
      newLine(mark, 12, 21, 17.5, 26.5, 3.6, tint)
      newLine(mark, 17.5, 26.5, 28.5, 14.5, 3.6, tint)
    else
      new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "D", Font = FONT_BOLD, TextSize = 22, TextColor3 = tint}, mark)
    end

    new("TextLabel", {
      Position = UDim2.fromOffset(68, 12), Size = UDim2.new(1, -82, 0, 22), BackgroundTransparency = 1, Font = FONT_BOLD, TextSize = 16,
      Text = copied and "Discord invite copied!" or "Join our Discord", TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, toast)
    new("TextLabel", {
      Position = UDim2.fromOffset(68, 35), Size = UDim2.new(1, -82, 0, 20), BackgroundTransparency = 1, Font = FONT, TextSize = 13,
      Text = copied and (shortLink .. "  ·  paste it to join") or shortLink, TextColor3 = C.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, toast)

    mount(toastGui)
    toastShownAt = os.clock()
    tween(toastHolder, info(0.65, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, 0, 0, 20)})
    tween(toast, info(0.35, Enum.EasingStyle.Quad), {GroupTransparency = 0})
    tween(toastStroke, info(0.5, Enum.EasingStyle.Quad), {Transparency = 0.55})
    task.delay(0.3, function()
      if toastClosed then return end
      pcall(function() tween(markScale, info(0.5, Enum.EasingStyle.Back), {Scale = 1}) end)
    end)
    task.spawn(function()
      task.wait(0.35)
      while toast and toast.Parent and not toastClosed do
        pcall(pulse, badge, tint)
        task.wait(2)
      end
    end)
  end)
end

local function hideToast()
  if not toast or toastClosed then return end
  toastClosed = true
  task.spawn(function()
    local remaining = TOAST_MIN_SECONDS - (os.clock() - (toastShownAt or 0))
    if remaining > 0 then task.wait(remaining) end
    pcall(function()
      tween(toastHolder, info(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -96)})
      tween(toast, info(0.4, Enum.EasingStyle.Quad), {GroupTransparency = 1})
      tween(toastStroke, info(0.4, Enum.EasingStyle.Quad), {Transparency = 1})
    end)
    task.wait(0.6)
    pcall(function() toastGui:Destroy() end)
  end)
end

local loaderGui, loaderCard, blur, shade, wrap, wrapStroke, cardScale, label, versionLabel, barFill, fillGradient
local renderConnection
local baseScale = 1
local closed = false
local progressTarget, progressShown = 0.06, 0
local lastStageAt = os.clock()
local labelToken = 0

local function buildLoader()
  pcall(function()
    loaderGui = new("ScreenGui", {Name = "LyraLoading", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    blur = new("BlurEffect", {Name = "LyraLoadingBlur", Size = 0}, Lighting)
    shade = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(8, 6, 13), BackgroundTransparency = 1, BorderSizePixel = 0}, loaderGui)

    pcall(function()
      local viewport = workspace.CurrentCamera.ViewportSize
      baseScale = math.clamp(math.min(viewport.X / 360, viewport.Y / 270), 0.8, 1.15)
    end)

    wrap = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(280, 208), BackgroundTransparency = 1}, shade)
    corner(wrap, UDim.new(0, 24))
    cardScale = new("UIScale", {Scale = baseScale * 0.9}, wrap)
    wrapStroke = new("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 1.4, Transparency = 1}, wrap)
    local strokeGradient = new("UIGradient", {Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, C.AccentDark), ColorSequenceKeypoint.new(0.5, C.AccentLight), ColorSequenceKeypoint.new(1, C.AccentDark),
    })}, wrapStroke)

    local card = new("CanvasGroup", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, GroupTransparency = 1}, wrap)
    corner(card, UDim.new(0, 24))
    local cardBg = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, card)
    new("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(50, 44, 78), Color3.fromRGB(28, 25, 44)), Rotation = 60}, cardBg)

    local ring = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 62), Size = UDim2.fromOffset(78, 78), BackgroundTransparency = 1}, card)
    corner(ring, UDim.new(1, 0))
    local ringStroke = new("UIStroke", {Color = C.Accent, Thickness = 3, Transparency = 0.05}, ring)
    new("UIGradient", {Transparency = NumberSequence.new({
      NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.85), NumberSequenceKeypoint.new(1, 1),
    })}, ringStroke)
    local badge = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 62), Size = UDim2.fromOffset(54, 54), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, card)
    corner(badge, UDim.new(0, 18))
    new("UIGradient", {Color = ColorSequence.new(C.AccentDark, C.Accent), Rotation = 45}, badge)
    local badgeScale = new("UIScale", {Scale = 1}, badge)
    new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "L", Font = FONT_BOLD, TextSize = 30, TextColor3 = C.Base}, badge)

    new("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 125), Size = UDim2.new(1, -24, 0, 26), BackgroundTransparency = 1, Text = "Avatar Copier", Font = FONT_BOLD, TextSize = 19, TextColor3 = C.Text}, card)
    label = new("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 154), Size = UDim2.new(1, -24, 0, 20), BackgroundTransparency = 1, Text = "Loading Avatar Copier…", Font = FONT, TextSize = 14, TextColor3 = C.Muted}, card)

    local track = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 177), Size = UDim2.new(1, -52, 0, 5), BackgroundColor3 = C.Raised, BorderSizePixel = 0, ClipsDescendants = true}, card)
    corner(track, UDim.new(1, 0))
    barFill = new("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, track)
    corner(barFill, UDim.new(1, 0))
    fillGradient = new("UIGradient", {Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, C.AccentDark), ColorSequenceKeypoint.new(0.4, C.Accent), ColorSequenceKeypoint.new(0.5, C.AccentLight),
      ColorSequenceKeypoint.new(0.6, C.Accent), ColorSequenceKeypoint.new(1, C.AccentDark),
    })}, barFill)

    versionLabel = new("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 195), Size = UDim2.new(1, -24, 0, 14), BackgroundTransparency = 1,
      Text = "Loader v" .. LOADER_VERSION .. " · Shield v2", Font = FONT, TextSize = 11, TextColor3 = C.Muted, TextTransparency = 0.35}, card)

    mount(loaderGui)

    local startedAt, timerAcc = os.clock(), 0
    renderConnection = RunService.RenderStepped:Connect(function(dt)
      if closed then return end
      local t = os.clock() - startedAt
      ring.Rotation = (ring.Rotation + dt * 330) % 360
      strokeGradient.Rotation = (t * 45) % 360
      badgeScale.Scale = 1 + math.sin(t * 2.4) * 0.025
      local creep = 0.07 * (1 - math.exp(-(os.clock() - lastStageAt) / 2.2))
      local goal = progressTarget >= 1 and 1 or math.min(progressTarget + creep, 0.97)
      progressShown = progressShown + (goal - progressShown) * math.min(1, dt * 7)
      barFill.Size = UDim2.fromScale(math.clamp(progressShown, 0, 1), 1)
      fillGradient.Offset = Vector2.new(((t * 0.9) % 2) - 1, 0)
      timerAcc = timerAcc + dt
      if timerAcc >= 0.1 then
        timerAcc = 0
        versionLabel.Text = string.format("Loader v%s · Shield v2 · %.1fs", LOADER_VERSION, os.clock() - loaderStarted)
      end
    end)

    tween(shade, info(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
    tween(blur, info(0.5), {Size = 16})
    tween(cardScale, info(0.6, Enum.EasingStyle.Back), {Scale = baseScale})
    tween(card, info(0.4, Enum.EasingStyle.Quad), {GroupTransparency = 0})
    tween(wrapStroke, info(0.6, Enum.EasingStyle.Quad), {Transparency = 0.55})
    loaderCard = card
  end)
end

local function setLabel(text)
  if not label or not label.Parent or label.Text == text then return end
  labelToken = labelToken + 1
  local token = labelToken
  tween(label, info(0.12, Enum.EasingStyle.Quad), {TextTransparency = 1})
  task.delay(0.12, function()
    if token ~= labelToken or not label or not label.Parent then return end
    label.Text = text
    label.Position = UDim2.new(0.5, 0, 0, 161)
    tween(label, info(0.3), {TextTransparency = 0, Position = UDim2.new(0.5, 0, 0, 154)})
  end)
end

local function stage(text, progress)
  pcall(function()
    if progress then progressTarget = math.max(progressTarget, progress) end
    lastStageAt = os.clock()
    setLabel(text)
  end)
end

local function closeLoader()
  ENV.__LYRA_AVATAR_LOADING = nil
  hideToast()
  if closed then return end
  closed = true
  pcall(function()
    if loaderCard then tween(loaderCard, info(0.4, Enum.EasingStyle.Quad), {GroupTransparency = 1}) end
    if cardScale then tween(cardScale, info(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = baseScale * 0.94}) end
    if wrapStroke then tween(wrapStroke, info(0.3, Enum.EasingStyle.Quad), {Transparency = 1}) end
    if shade then tween(shade, info(0.45, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}) end
    if blur then tween(blur, info(0.45), {Size = 0}) end
  end)
  task.delay(0.55, function()
    pcall(function() if renderConnection then renderConnection:Disconnect() end end)
    pcall(function() if loaderGui then loaderGui:Destroy() end end)
    pcall(function() if blur then blur:Destroy() end end)
    pcall(function()
      local leftover = Lighting:FindFirstChild("LyraLoadingBlur")
      if leftover then leftover:Destroy() end
    end)
  end)
end

local function fail(msg)
  pcall(function() fillGradient.Color = ColorSequence.new(C.Red) end)
  stage(msg, 1)
  task.wait(0.9)
  closeLoader()
  error("Avatar Copier: " .. msg, 0)
end

local httpRequest
local function send(opts, retries)
  local last
  for i = 1, (retries or 1) do
    local ok, res = pcall(httpRequest, opts)
    if ok and res then return res end
    last = res
    if i < (retries or 1) then task.wait(0.35 * i) end
  end
  return last
end

local function run()
  local copied = false
  if COPY_DISCORD_ON_START then copied = copyText(DISCORD_INVITE) end
  buildLoader()
  if COPY_DISCORD_ON_START then buildToast(copied) end

  local gameName = ""
  pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
  httpRequest = request or http_request or (syn and syn.request)
  if not httpRequest then fail("HTTP request unsupported [H01]") end
  local loadStarted = os.clock()
  local sessionBody = HttpService:JSONEncode({userId = player and player.UserId or 0, placeId = game.PlaceId or 0, gameName = gameName, jobId = game.JobId or "", loaderVersion = LOADER_VERSION})
  stage("Authenticating…", 0.28)
  local function openSession()
    local s = send({Url = "https://api.lyraez.lol/v1/session", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = sessionBody}, 2)
    if not s or (s.StatusCode or s.Status) ~= 201 then return nil end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, s.Body)
    if not ok or not data or not data.token then return nil end
    return data
  end
  local data = openSession()
  if not data then fail("Could not authenticate [S01]") end
  local function fetchPayload(session)
    return send({Url = "https://api.lyraez.lol/v1/payload", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({token = session.token})}, 1)
  end
  stage("Fetching protected script…", 0.58)
  local r = fetchPayload(data)
  if not r or (r.StatusCode or r.Status) ~= 200 then
    stage("Refreshing secure session…", 0.5)
    data = openSession()
    if not data then fail("Could not refresh session [S02]") end
    stage("Fetching protected script…", 0.62)
    r = fetchPayload(data)
  end
  if not r or (r.StatusCode or r.Status) ~= 200 then fail("Could not fetch protected payload [P02]") end
  local telemetryToken = headerValue(r, "x-lyra-telemetry")
  stage("Initializing protected build…", 0.84)
  local compile = loadstring or load
  local fn
  if compile then fn = compile(r.Body) end
  pcall(function() r.Body = nil end)
  r = nil
  if not fn then fail("Protected payload rejected [L03]") end
  local ok, result = pcall(fn)
  fn = nil
  stage(ok and "Ready" or "Initialization failed", 1)
  local loadMs = math.max(0, math.floor((os.clock() - loadStarted) * 1000))
  if telemetryToken then
    pcall(function() httpRequest({Url = "https://api.lyraez.lol/v1/telemetry", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({token = telemetryToken, ok = ok, loadMs = loadMs, loaderVersion = LOADER_VERSION})}) end)
  end
  if ok then task.wait(0.5) else task.wait(0.8) end
  closeLoader()
  if not ok then error(result) end
  return result
end

local okRun, out = pcall(run)
if not okRun then
  closeLoader()
  error(out, 0)
end
return out