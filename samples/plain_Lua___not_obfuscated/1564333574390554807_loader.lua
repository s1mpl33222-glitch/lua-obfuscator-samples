
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local lp           = Players.LocalPlayer

local key = (getgenv and getgenv().script_key) or (getrenv and getrenv().script_key) or ""

if key == "" then
  error("[WarpahExploits] Set script_key dulu sebelum loadstring!")
  return
end

local function getExecutorName()
  if identifyexecutor then
    local ok, name = pcall(identifyexecutor)
    if ok and name then return tostring(name) end
  end
  if KRNL_LOADED then return "Krnl" end
  if syn then return "Synapse X" end
  if fluxus then return "Fluxus" end
  if DELTA_LOADED then return "Delta" end
  if isourclosure then return "Script-Ware" end
  if VELOCITY_LOADED then return "Velocity" end
  if Xeno then return "Xeno" end
  if XENO_LOADED then return "Xeno" end
  if getexecutorname then
    local ok, name = pcall(getexecutorname)
    if ok and name then return tostring(name) end
  end
  if http and http.request then return "Velocity/JJSploit" end
  if request then
    if DELTA_LOADED then return "Delta" end
    if Wave then return "Wave" end
    if isourclosure then return "Potassium/ScriptWare" end
    return "Unknown (request)" end
  return "Unknown"
end

local function httpRequest(url, method, headers, body)
  if http and http.request then
    local ok, res = pcall(http.request, {
      Url = url, Method = method,
      Headers = headers, Body = body
    })
    if ok and res then return res.Body end
  end
  if request then
    local ok, res = pcall(request, {
      Url = url, Method = method,
      Headers = headers, Body = body
    })
    if ok and res then return res.Body end
  end
  if syn and syn.request then
    local ok, res = pcall(syn.request, {
      Url = url, Method = method,
      Headers = headers, Body = body
    })
    if ok and res then return res.Body end
  end
  if KRNL_LOADED and http_request then
    local ok, res = pcall(http_request, {
      Url = url, Method = method,
      Headers = headers, Body = body
    })
    if ok and res then return res.Body end
  end
  local HttpService = game:GetService("HttpService")
  return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
end

local function getHWID()
  local ok, id = pcall(function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
  end)
  local baseId
  if ok and id and #id > 4 then
    baseId = id
  else
    baseId = tostring(lp.UserId).."_"..tostring(game.PlaceId)
  end
  return baseId.."_"..getExecutorName()
end

local RunService = game:GetService("RunService")

local LOGO_ID = "rbxassetid://77482003578660"
local WHITE = Color3.new(1, 1, 1)
local nsk = NumberSequenceKeypoint.new

local function make(class, props)
  local inst = Instance.new(class)
  local parent = props.Parent
  props.Parent = nil
  for k, v in pairs(props) do
    inst[k] = v
  end
  inst.Parent = parent
  return inst
end

local function tween(obj, time, props, style, dir, delay)
  local info = TweenInfo.new(time, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out, 0, false, delay or 0)
  local t = TweenService:Create(obj, info, props)
  t:Play()
  return t
end

-- Tampilan sama persis dengan GUI loading di script menu (Warpah Pop):
-- kartu indigo, stroke gradien berputar, glow atas, sapuan cahaya, logo meluncur + ring + pulse,
-- teks ketik, divider ink, progress bar dengan shine + kepala kotak berputar.
local function createNotif(title, message, color, duration)
  duration = duration or 5
  color = color or Color3.fromRGB(0, 200, 80)

  local old = CoreGui:FindFirstChild("WarpahNotif")
  if old then old:Destroy() end

  local gui = make("ScreenGui", {
    Name = "WarpahNotif",
    ResetOnSpawn = false,
    DisplayOrder = 999,
    IgnoreGuiInset = true,
    Parent = CoreGui,
  })

  -- warna: dasar tema Warpah Pop, aksen mengikuti warna status notif
  local INK = Color3.fromRGB(7, 7, 31)
  local BG = Color3.fromRGB(15, 16, 56):Lerp(color, 0.08)
  local ITEM = BG:Lerp(color, 0.12)
  local TEXT = Color3.fromRGB(244, 241, 255)
  local SUB = Color3.fromRGB(182, 179, 224)
  local C2 = color:Lerp(WHITE, 0.4)
  local h, s, v = color:ToHSV()
  local C3 = Color3.fromHSV((h + 0.12) % 1, s, v)

  local CARD_W, CARD_H = 330, 150
  local SHOW_Y, HIDE_Y = 16, -(CARD_H + 20)

  local card = make("CanvasGroup", {
    Name = "Card",
    Size = UDim2.fromOffset(CARD_W, CARD_H),
    Position = UDim2.new(0.5, -CARD_W / 2, 0, HIDE_Y),
    BackgroundColor3 = BG,
    GroupTransparency = 1,
    Parent = gui,
  })
  make("UICorner", { CornerRadius = UDim.new(0, 18), Parent = card })
  local stroke = make("UIStroke", { Color = color, Thickness = 3, Transparency = 0.05, Parent = card })
  local strokeGrad = make("UIGradient", {
    Transparency = NumberSequence.new({ nsk(0, 0), nsk(0.5, 0.85), nsk(1, 0) }),
    Parent = stroke,
  })
  local cardScale = make("UIScale", { Scale = 0.9, Parent = card })

  local glow = make("Frame", {
    Size = UDim2.new(1, 0, 0, 80),
    BackgroundColor3 = color,
    BorderSizePixel = 0,
    Parent = card,
  })
  make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0.86, 1), Parent = glow })

  local sweep = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(-0.3, 0, 0.5, 0),
    Size = UDim2.new(0, 60, 2, 0),
    Rotation = 20,
    BackgroundColor3 = WHITE,
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = card,
  })
  make("UIGradient", {
    Transparency = NumberSequence.new({ nsk(0, 1), nsk(0.5, 0), nsk(1, 1) }),
    Parent = sweep,
  })

  -- logo
  local LX, LY = 44, 44

  local pulse = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(LX, LY),
    Size = UDim2.fromOffset(42, 42),
    BackgroundTransparency = 1,
    Parent = card,
  })
  make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = pulse })
  local pulseStroke = make("UIStroke", { Color = C3, Thickness = 2, Transparency = 1, Parent = pulse })

  local logoHolder = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(LX - 40, LY),
    Size = UDim2.fromOffset(42, 42),
    Rotation = -90,
    BackgroundColor3 = ITEM,
    Parent = card,
  })
  make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = logoHolder })
  make("UIStroke", { Color = INK, Thickness = 3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = logoHolder })
  local logo = make("ImageLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = LOGO_ID,
    ScaleType = Enum.ScaleType.Crop,
    Parent = logoHolder,
  })
  make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = logo })
  local logoScale = make("UIScale", { Scale = 0.6, Parent = logoHolder })

  local ring = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(LX, LY),
    Size = UDim2.fromOffset(52, 52),
    BackgroundTransparency = 1,
    Parent = card,
  })
  make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
  local ringStroke = make("UIStroke", { Color = C2, Thickness = 3, Transparency = 1, Parent = ring })
  local ringGrad = make("UIGradient", {
    Transparency = NumberSequence.new({ nsk(0, 0), nsk(0.4, 0), nsk(0.6, 1), nsk(1, 1) }),
    Parent = ringStroke,
  })

  -- teks
  local titleLabel = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(104, 20),
    Size = UDim2.new(1, -100, 0, 22),
    Text = title,
    MaxVisibleGraphemes = 0,
    TextColor3 = TEXT,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Parent = card,
  })
  local msgLabel = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(104, 44),
    Size = UDim2.new(1, -100, 0, 30),
    Text = message,
    TextColor3 = C2,
    TextTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
    Parent = card,
  })

  local divider = make("Frame", {
    Position = UDim2.fromOffset(18, 78),
    Size = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = INK,
    BorderSizePixel = 0,
    Parent = card,
  })

  -- progress (sama seperti loading: status kiri, persen kanan, bar di bawah)
  local holder = make("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 92),
    Size = UDim2.new(1, -36, 0, 40),
    Parent = card,
  })
  local status = make("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -50, 0, 16),
    Text = "",
    TextColor3 = TEXT,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    Parent = holder,
  })
  local percent = make("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.fromOffset(50, 16),
    Text = "0%",
    TextColor3 = C2,
    TextXAlignment = Enum.TextXAlignment.Right,
    Font = Enum.Font.Code,
    TextSize = 14,
    Parent = holder,
  })
  local bar = make("Frame", {
    Position = UDim2.fromOffset(0, 24),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = INK,
    BorderSizePixel = 0,
    Parent = holder,
  })
  make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
  make("UIStroke", { Color = INK, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bar })
  local fill = make("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = color,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = bar,
  })
  make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
  local shine = make("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.new(0, 70, 1, 0),
    BackgroundColor3 = C2,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Parent = fill,
  })
  make("UIGradient", {
    Transparency = NumberSequence.new({ nsk(0, 1), nsk(0.5, 0.2), nsk(1, 1) }),
    Parent = shine,
  })
  local head = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0, 0, 0.5, 0),
    Size = UDim2.fromOffset(16, 16),
    BackgroundColor3 = C2,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = bar,
  })
  make("UICorner", { CornerRadius = UDim.new(0, 5), Parent = head })
  make("UIStroke", { Color = INK, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = head })

  local t0 = os.clock()
  local conn
  conn = RunService.RenderStepped:Connect(function(dt)
    local t = os.clock() - t0
    ringGrad.Rotation = (ringGrad.Rotation + dt * 320) % 360
    strokeGrad.Rotation = (strokeGrad.Rotation + dt * 70) % 360

    -- sapuan cahaya tiap 2.4 detik
    local sw = (t % 2.4) / 1.2
    sweep.Position = UDim2.new(-0.3 + math.min(sw, 1) * 1.6, 0, 0.5, 0)

    -- gelombang denyut keluar dari logo
    local p = (t % 1.6) / 1.6
    local d = 42 + p * 26
    pulse.Size = UDim2.fromOffset(d, d)
    pulseStroke.Transparency = 0.3 + p * 0.7

    -- progress mengisi sesuai durasi
    local a = math.clamp(t / duration, 0, 1)
    local eased = a < 0.5 and 2 * a * a or 1 - ((-2 * a + 2) ^ 2) / 2
    fill.Size = UDim2.new(eased, 0, 1, 0)
    head.Position = UDim2.new(eased, 0, 0.5, 0)
    head.Rotation = eased * 360
    shine.Position = UDim2.new((t * 0.7) % 1.6, 0, 0, 0)
    percent.Text = math.floor(eased * 100 + 0.5) .. "%"

    local left = math.max(0, math.ceil(duration - t))
    status.Text = "Menutup dalam " .. left .. "s"
  end)
  gui.Destroying:Connect(function()
    if conn then conn:Disconnect() end
  end)

  -- masuk (urutan intro sama seperti loading)
  tween(card, 0.55, { Position = UDim2.new(0.5, -CARD_W / 2, 0, SHOW_Y) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
  tween(card, 0.4, { GroupTransparency = 0 }, Enum.EasingStyle.Quad)
  tween(cardScale, 0.55, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
  tween(logoHolder, 0.7, { Position = UDim2.fromOffset(LX, LY), Rotation = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0.15)
  tween(logoScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0.15)
  tween(ringStroke, 0.4, { Transparency = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.6)
  tween(titleLabel, 0.6, { Position = UDim2.fromOffset(86, 20) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.3)
  tween(msgLabel, 0.6, { Position = UDim2.fromOffset(86, 44), TextTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.6)
  tween(divider, 0.8, { Size = UDim2.new(1, -36, 0, 2) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.5)
  task.spawn(function()
    task.wait(0.3)
    local n = utf8.len(title) or #title
    for i = 1, n do
      if not titleLabel.Parent then return end
      titleLabel.MaxVisibleGraphemes = i
      task.wait(math.min(0.035, 0.6 / math.max(n, 1)))
    end
    titleLabel.MaxVisibleGraphemes = -1
  end)

  -- keluar
  task.delay(duration, function()
    if gui and gui.Parent then
      tween(logoScale, 0.25, { Scale = 1.15 }, Enum.EasingStyle.Quad)
      tween(card, 0.3, { GroupTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
      tween(cardScale, 0.35, { Scale = 1.05 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
      local out = tween(card, 0.35, { Position = UDim2.new(0.5, -CARD_W / 2, 0, HIDE_Y) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
      out.Completed:Connect(function() gui:Destroy() end)
    end
  end)

  return gui
end

-- Wrapper: format lama notif(title, msg, {r,g,b}, dur) tetap jalan
local function notif(title, msg, hex, dur)
  pcall(function()
    createNotif(title, msg, Color3.fromRGB(hex[1], hex[2], hex[3]), dur)
  end)
end


local ok, resp = pcall(function()
  local payload = HttpService:JSONEncode({
    key = key,
    hwid = getHWID(),
    executor = getExecutorName(),
    place_id = tostring(game.PlaceId),
    user_id = tostring(lp.UserId)
  })
  return httpRequest(
    "https://www.warpahexplo.asia/api/validate",
    "POST",
    { ["Content-Type"] = "application/json" },
    payload
  )
end)

if not ok then
  notif("Connection Error", "Gagal konek ke server. Cek internet atau server sedang down.", {255,150,0}, 8)
  error("[WarpahExploits] Connection error: "..tostring(resp))
  return
end

local _, r = pcall(function() return HttpService:JSONDecode(resp) end)
if not r then
  notif("Error", "Response server tidak valid.", {255,60,60}, 6)
  return
end

if r.status == "BANNED" then
  notif("Key Dibanned", r.message or "Key kamu telah dibanned. Hubungi admin di Discord.", {255,40,40}, 8)
  error("[WarpahExploits] BANNED") return
elseif r.status == "HWID_MISMATCH" then
  notif("HWID Mismatch", "Key terdaftar di perangkat lain. Minta reset HWID ke admin Discord.", {255,140,0}, 8)
  task.wait(2)
  pcall(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
  end)
  pcall(function()
    lp:Kick("[WarpahExploits] HWID Mismatch! Reset HWID via /resethwid di Discord WarpahExploits")
  end)
  error("[WarpahExploits] HWID_MISMATCH - Player kicked") return
elseif r.status == "EXPIRED" then
  notif("Key Expired", "Key kamu sudah kadaluarsa. Beli key baru di Discord WarpahExploits.", {255,140,0}, 8)
  error("[WarpahExploits] EXPIRED") return
elseif r.status == "RATE_LIMIT" then
  notif("Slow Down", "Terlalu banyak request. Tunggu beberapa detik lalu coba lagi.", {255,140,0}, 5)
  error("[WarpahExploits] RATE_LIMIT") return
elseif not r.success then
  notif("Key Tidak Valid", r.message or "Key tidak terdaftar. Pastikan key kamu benar.", {255,40,40}, 8)
  error("[WarpahExploits] INVALID") return
end

notif("Authenticated", "Key valid! Memuat script... Execution #"..tostring(r.executions or 0), {0,200,80}, 4)
local _guiEnd = os.clock() + 4.5
print("[WarpahExploits] Key valid | Exec #"..tostring(r.executions or 0))
getgenv()._warpah_token = r.token or ""
getgenv()._warpah_server = "https://www.warpahexplo.asia"
getgenv()._warpah_key = r.key or key
task.wait(0.3)

local _tkn = getgenv()._warpah_token or ""
local _key = getgenv()._warpah_key or ""
local _scriptUrl = "https://www.warpahexplo.asia/api/scripts/1792724583243_MENU-obfuscated__2_.lua?t=" .. _tkn .. "&k=" .. _key
local sOk, sErr = pcall(function()
  local code
  if request then
    local res = request({ Url = _scriptUrl, Method = "GET", Headers = { ["x-script-token"] = _tkn } })
    code = res and res.Body
  elseif http and http.request then
    local res = http.request({ Url = _scriptUrl, Method = "GET", Headers = { ["x-script-token"] = _tkn } })
    code = res and res.Body
  elseif syn and syn.request then
    local res = syn.request({ Url = _scriptUrl, Method = "GET", Headers = { ["x-script-token"] = _tkn } })
    code = res and res.Body
  else
    code = game:HttpGet(_scriptUrl, true)
  end
  if not code or #code < 10 then
    error("Script eror")
  end
  local _left = (_guiEnd or 0) - os.clock()
  if _left > 0 then task.wait(_left) end
  loadstring(code)()
end)
if not sOk then
  notif("Script Error", "Gagal load script: "..tostring(sErr), {255,60,60}, 8)
  warn("[WarpahExploits] Script error: "..tostring(sErr))
end