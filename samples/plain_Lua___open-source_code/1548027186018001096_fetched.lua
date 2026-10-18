--[[
  Zeroin Key System (Ed25519-signed auth)
  Served by: GET /api/script (no params)

  Flow:
    1. Prompt user for Key.
    2. POST /api/auth { key, hwid, nonce } -> signed verdict.
    3. Verify Ed25519 signature + nonce, then GET /api/script?key&hwid -> main script.
]]

local rawServerUrl = getgenv and getgenv().ServerURL or _G.ServerURL or "https://zeroinhub.com"
local serverUrl = (rawServerUrl and rawServerUrl ~= "" and not string.find(rawServerUrl, "{{")) and rawServerUrl or "https://zeroinhub.com"
local rawPubKey = "8ea91cb482075e9bd4f19a3b0e2278a02efee3f20ab6d2b2812b235826b8f95e"
local PUBLIC_KEY = (rawPubKey and rawPubKey ~= "" and not string.find(rawPubKey, "{{")) and rawPubKey or "8ea91cb482075e9bd4f19a3b0e2278a02efee3f20ab6d2b2812b235826b8f95e"
local rawDiscordInvite = "https://discord.gg/HjbXC5gbsN"
local discordInvite = (rawDiscordInvite and rawDiscordInvite ~= "" and not string.find(rawDiscordInvite, "{{")) and rawDiscordInvite or "https://discord.gg/HjbXC5gbsN"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- load pure-Lua Ed25519 verify with in-memory caching and background pre-fetch
local cachedEd = nil
local function loadEd25519()
  if cachedEd then return cachedEd end
  local ok, src = pcall(function() return game:HttpGet(serverUrl .. "/api/ed25519") end)
  if not ok or not src then return nil end
  local ok2, fn = pcall(loadstring, src)
  if not ok2 or not fn then return nil end
  local ok3, mod = pcall(fn)
  if not ok3 or not mod or not mod.verify then return nil end
  cachedEd = mod
  return mod
end
task.spawn(loadEd25519)

-- executor HWID
local function getHwid()
  local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
  if ok and id and id ~= "" then return tostring(id) end
  return tostring(Players.LocalPlayer.UserId)
end

-- random nonce (16 bytes -> hex)
local function randomNonce()
  math.randomseed(tick() * 1000000 % 2147483647)
  local t = {}
  for _ = 1, 32 do t[#t + 1] = string.format("%x", math.random(0, 15)) end
  return table.concat(t)
end

-- POST-capable HTTP. Returns raw response, or nil if no POST function exists.
local function httpPost(url, json)
  local opts = { Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = json }
  if syn and syn.request then return syn.request(opts) end
  if request then return request(opts) end
  if http_request then return http_request(opts) end
  if http and http.request then return http.request(opts) end
  return nil
end

-- Extract { body, status } from an executor response (table or string).
local function parseResponse(raw)
  if type(raw) == "string" then return { body = raw, status = nil } end
  if type(raw) == "table" then
    local body = raw.Body or raw.body or raw.Content or raw.content or raw.ResponseBody or raw.response or ""
    local status = raw.StatusCode or raw.status or raw.Code or raw.code
    return { body = body, status = status }
  end
  return { body = tostring(raw), status = nil }
end

local function verifyVerdict(ed, nonce, flag, message, signature)
  if not ed then return false end
  local canonical = nonce .. "|" .. (flag and "true" or "false") .. "|" .. message
  return ed.verify(signature, canonical, PUBLIC_KEY)
end

local function copyToClipboard(text)
  local fn = setclipboard or toclipboard or (Clipboard and Clipboard.set)
  if fn then
    pcall(fn, text)
    return true
  end
  return false
end

-- Key file cache ("Zeroin-Key")
local KEY_FILE = "Zeroin-Key"

local function loadCachedKey()
  local function tryRead(name)
    local exists = true
    if isfile then
      local ok, res = pcall(isfile, name)
      if ok then exists = res else exists = false end
    end
    if exists and readfile then
      local ok, content = pcall(readfile, name)
      if ok and type(content) == "string" then
        local trimmed = content:gsub("^%s*(.-)%s*$", "%1")
        if #trimmed > 0 then return trimmed end
      end
    end
    return nil
  end

  return tryRead(KEY_FILE) or tryRead(KEY_FILE .. ".txt")
end

local function saveCachedKey(key)
  pcall(function()
    if writefile then
      writefile(KEY_FILE, tostring(key))
    end
  end)
end

local function deleteCachedKey()
  local delFn = delfile or removefile
  if delFn then
    pcall(function()
      if isfile then
        if isfile(KEY_FILE) then delFn(KEY_FILE) end
        if isfile(KEY_FILE .. ".txt") then delFn(KEY_FILE .. ".txt") end
      else
        delFn(KEY_FILE)
      end
    end)
  end
end

local startAuth = nil

-- UI
local targetParent = (gethui and pcall(function() return gethui() end) and gethui()) or CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZeroinKeySystem"
Gui.Parent = targetParent
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 360, 0, 270)
Frame.Position = UDim2.new(0.5, -180, 0.5, -135)
Frame.BackgroundColor3 = Color3.fromRGB(4, 10, 7)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.2
Stroke.Color = Color3.fromRGB(34, 197, 94)
Stroke.Transparency = 0.65
Stroke.Parent = Frame

-- Top Accent Glow Line (Matches Landing Page cards)
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.Position = UDim2.new(0, 0, 0, 0)
TopLine.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
TopLine.BorderSizePixel = 0
TopLine.Parent = Frame

local TopLineGrad = Instance.new("UIGradient")
TopLineGrad.Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 0.9),
  NumberSequenceKeypoint.new(0.5, 0),
  NumberSequenceKeypoint.new(1, 0.9)
})
TopLineGrad.Parent = TopLine

-- Header Bar (Draggable trigger)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 46)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = Frame

local BrandDot = Instance.new("Frame")
BrandDot.Size = UDim2.new(0, 8, 0, 8)
BrandDot.Position = UDim2.new(0, 20, 0, 19)
BrandDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
BrandDot.BorderSizePixel = 0
BrandDot.Parent = Header
Instance.new("UICorner", BrandDot).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 80, 0, 46)
Title.Position = UDim2.new(0, 36, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZEROIN"
Title.TextColor3 = Color3.fromRGB(236, 253, 245)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Badge = Instance.new("Frame")
Badge.Size = UDim2.new(0, 52, 0, 20)
Badge.Position = UDim2.new(0, 116, 0, 13)
Badge.BackgroundColor3 = Color3.fromRGB(11, 32, 20)
Badge.BorderSizePixel = 0
Badge.Parent = Header
Instance.new("UICorner", Badge).CornerRadius = UDim.new(0, 6)

local BadgeStroke = Instance.new("UIStroke")
BadgeStroke.Thickness = 1
BadgeStroke.Color = Color3.fromRGB(34, 197, 94)
BadgeStroke.Transparency = 0.5
BadgeStroke.Parent = Badge

local BadgeText = Instance.new("TextLabel")
BadgeText.Size = UDim2.new(1, 0, 1, 0)
BadgeText.BackgroundTransparency = 1
BadgeText.Text = "GUARD"
BadgeText.TextColor3 = Color3.fromRGB(74, 222, 128)
BadgeText.Font = Enum.Font.GothamBold
BadgeText.TextSize = 10
BadgeText.Parent = Badge

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -38, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(11, 23, 17)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(125, 161, 140)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Thickness = 1
CloseStroke.Color = Color3.fromRGB(34, 197, 94)
CloseStroke.Transparency = 0.8
CloseStroke.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
  CloseBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
  CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 12, 12)
  CloseStroke.Color = Color3.fromRGB(239, 68, 68)
  CloseStroke.Transparency = 0.4
end)
CloseBtn.MouseLeave:Connect(function()
  CloseBtn.TextColor3 = Color3.fromRGB(125, 161, 140)
  CloseBtn.BackgroundColor3 = Color3.fromRGB(11, 23, 17)
  CloseStroke.Color = Color3.fromRGB(34, 197, 94)
  CloseStroke.Transparency = 0.8
end)
CloseBtn.MouseButton1Click:Connect(function()
  Gui:Destroy()
end)

-- Subtitle Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -40, 0, 16)
Info.Position = UDim2.new(0, 20, 0, 48)
Info.BackgroundTransparency = 1
Info.Text = "Enter your license key to authenticate script access."
Info.TextColor3 = Color3.fromRGB(125, 161, 140)
Info.TextSize = 11
Info.Font = Enum.Font.Gotham
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Frame

-- Key Input Container
local InputBoxFrame = Instance.new("Frame")
InputBoxFrame.Size = UDim2.new(0, 320, 0, 40)
InputBoxFrame.Position = UDim2.new(0.5, -160, 0, 72)
InputBoxFrame.BackgroundColor3 = Color3.fromRGB(7, 16, 12)
InputBoxFrame.BorderSizePixel = 0
InputBoxFrame.Parent = Frame
Instance.new("UICorner", InputBoxFrame).CornerRadius = UDim.new(0, 8)

local InputStroke = Instance.new("UIStroke")
InputStroke.Thickness = 1
InputStroke.Color = Color3.fromRGB(34, 197, 94)
InputStroke.Transparency = 0.75
InputStroke.Parent = InputBoxFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -74, 1, 0)
KeyInput.Position = UDim2.new(0, 12, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter or paste your key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 110, 95)
KeyInput.TextColor3 = Color3.fromRGB(236, 253, 245)
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = InputBoxFrame

KeyInput.Focused:Connect(function()
  InputStroke.Transparency = 0.25
  InputStroke.Color = Color3.fromRGB(74, 222, 128)
end)
KeyInput.FocusLost:Connect(function(enterPressed)
  InputStroke.Transparency = 0.75
  InputStroke.Color = Color3.fromRGB(34, 197, 94)
  if enterPressed then
    local key = KeyInput.Text:gsub("^%s*(.-)%s*$", "%1")
    if key ~= "" and startAuth then
      startAuth(key, false)
    end
  end
end)

local PasteBtn = Instance.new("TextButton")
PasteBtn.Size = UDim2.new(0, 52, 0, 26)
PasteBtn.Position = UDim2.new(1, -58, 0.5, -13)
PasteBtn.BackgroundColor3 = Color3.fromRGB(11, 23, 17)
PasteBtn.BorderSizePixel = 0
PasteBtn.Text = "Paste"
PasteBtn.TextColor3 = Color3.fromRGB(167, 199, 181)
PasteBtn.Font = Enum.Font.GothamMedium
PasteBtn.TextSize = 11
PasteBtn.Parent = InputBoxFrame
Instance.new("UICorner", PasteBtn).CornerRadius = UDim.new(0, 6)

local PasteStroke = Instance.new("UIStroke")
PasteStroke.Thickness = 1
PasteStroke.Color = Color3.fromRGB(74, 222, 128)
PasteStroke.Transparency = 0.6
PasteStroke.Parent = PasteBtn

-- Status Text
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0, 320, 0, 18)
Status.Position = UDim2.new(0.5, -160, 0, 118)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(125, 161, 140)
Status.TextSize = 11
Status.Font = Enum.Font.GothamMedium
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextTruncate = Enum.TextTruncate.AtEnd
Status.Parent = Frame

-- Continue / Verify Button
local Continue = Instance.new("TextButton")
Continue.Size = UDim2.new(0, 320, 0, 40)
Continue.Position = UDim2.new(0.5, -160, 0, 140)
Continue.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
Continue.BorderSizePixel = 0
Continue.Text = "Verify Key"
Continue.TextColor3 = Color3.fromRGB(3, 16, 8)
Continue.Font = Enum.Font.GothamBold
Continue.TextSize = 14
Continue.AutoButtonColor = true
Continue.Parent = Frame
Instance.new("UICorner", Continue).CornerRadius = UDim.new(0, 8)

local ContinueGrad = Instance.new("UIGradient")
ContinueGrad.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 211, 153)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 197, 94))
})
ContinueGrad.Parent = Continue

-- Secondary Button Row (Get Free Key + Discord)
local SecondaryRow = Instance.new("Frame")
SecondaryRow.Size = UDim2.new(0, 320, 0, 34)
SecondaryRow.Position = UDim2.new(0.5, -160, 0, 188)
SecondaryRow.BackgroundTransparency = 1
SecondaryRow.Parent = Frame

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0, 155, 1, 0)
GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(11, 23, 17)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Text = "⚡ Get Free Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 12
GetKeyBtn.Parent = SecondaryRow
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Thickness = 1
GetKeyStroke.Color = Color3.fromRGB(34, 197, 94)
GetKeyStroke.Transparency = 0.5
GetKeyStroke.Parent = GetKeyBtn

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 155, 1, 0)
DiscordBtn.Position = UDim2.new(1, -155, 0, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(11, 23, 17)
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Text = "💬 Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(129, 140, 248)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 12
DiscordBtn.Parent = SecondaryRow
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

local DiscordStroke = Instance.new("UIStroke")
DiscordStroke.Thickness = 1
DiscordStroke.Color = Color3.fromRGB(88, 101, 242)
DiscordStroke.Transparency = 0.5
DiscordStroke.Parent = DiscordBtn

-- Footer text
local FooterNote = Instance.new("TextLabel")
FooterNote.Size = UDim2.new(1, 0, 0, 20)
FooterNote.Position = UDim2.new(0, 0, 0, 236)
FooterNote.BackgroundTransparency = 1
FooterNote.Text = "Zeroin Hub · Player-Owned Control & Managed Access"
FooterNote.TextColor3 = Color3.fromRGB(70, 95, 80)
FooterNote.Font = Enum.Font.Gotham
FooterNote.TextSize = 9
FooterNote.Parent = Frame

-- Window Draggability
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
  local delta = input.Position - dragStart
  Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    dragging = true
    dragStart = input.Position
    startPos = Frame.Position
    input.Changed:Connect(function()
      if input.UserInputState == Enum.UserInputState.End then
        dragging = false
      end
    end)
  end
end)

Header.InputChanged:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    dragInput = input
  end
end)

UserInputService.InputChanged:Connect(function(input)
  if input == dragInput and dragging then
    updateDrag(input)
  end
end)

-- Button Click Handlers
local isVerifying = false

local function setStatus(text, color)
  if not Status or not Status.Parent then return end
  Status.Text = text
  Status.TextColor3 = color or Color3.fromRGB(125, 161, 140)
end

local function resetButton()
  isVerifying = false
  if not Continue or not Continue.Parent then return end
  Continue.Text = "Verify Key"
  Continue.AutoButtonColor = true
  Continue.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
  Continue.TextColor3 = Color3.fromRGB(3, 16, 8)
end

local function failStatus(text)
  setStatus(text, Color3.fromRGB(239, 68, 68))
  resetButton()
end

PasteBtn.MouseButton1Click:Connect(function()
  local clip = nil
  pcall(function()
    if getclipboard then clip = getclipboard()
    elseif Clipboard and Clipboard.get then clip = Clipboard.get()
    end
  end)
  if clip and type(clip) == "string" and clip ~= "" then
    KeyInput.Text = clip:gsub("^%s*(.-)%s*$", "%1")
    setStatus("License key pasted from clipboard.", Color3.fromRGB(74, 222, 128))
  else
    setStatus("Clipboard is empty or unsupported.", Color3.fromRGB(245, 158, 11))
  end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
  copyToClipboard(serverUrl .. "/free")
  setStatus("Free key link copied to clipboard.", Color3.fromRGB(74, 222, 128))
end)

DiscordBtn.MouseButton1Click:Connect(function()
  copyToClipboard(discordInvite)
  setStatus("Discord invitation link copied to clipboard.", Color3.fromRGB(129, 140, 248))
end)

startAuth = function(key, isAuto)
  if isVerifying then return end
  isVerifying = true

  Continue.Text = "Verifying..."
  Continue.AutoButtonColor = false
  Continue.BackgroundColor3 = Color3.fromRGB(20, 80, 45)
  Continue.TextColor3 = Color3.fromRGB(167, 199, 181)

  if isAuto then
    setStatus("Saved license key detected. Authenticating...", Color3.fromRGB(74, 222, 128))
  else
    setStatus("Authenticating license key with server...", Color3.fromRGB(245, 158, 11))
  end

  task.spawn(function()
    local ed = loadEd25519()
    local nonce = randomNonce()
    local hwid = getHwid()

    local body = HttpService:JSONEncode({ key = key, hwid = hwid, nonce = nonce })
    local raw = httpPost(serverUrl .. "/api/auth", body)
    if raw == nil then
      failStatus("Unsupported executor: Missing HTTP POST request capability.")
      return
    end

    local parsed = parseResponse(raw)
    local bodyText = parsed.body or ""
    local statusCode = parsed.status

    if bodyText == "" then
      failStatus("Empty server response" .. (statusCode and (" (HTTP " .. tostring(statusCode) .. ")") or "."))
      warn("[Zeroin] Auth returned empty body. status=" .. tostring(statusCode))
      return
    end

    local okDec, resp = pcall(function() return HttpService:JSONDecode(bodyText) end)
    if not okDec or not resp then
      local code = statusCode and ("HTTP " .. tostring(statusCode)) or "HTTP ?"
      local preview = string.sub(tostring(bodyText), 1, 120)
      warn("[Zeroin] Auth unexpected non-JSON response (" .. code .. "): " .. tostring(bodyText))
      failStatus("Invalid server response (" .. code .. "): " .. preview)
      return
    end

    if resp.ok ~= true then
      deleteCachedKey()
      failStatus(resp.error or "Authentication failed.")
      return
    end

    if resp.nonce ~= nonce then
      failStatus("Security validation failed: Replay detected.")
      return
    end

    local verdict = resp.data
    if not verifyVerdict(ed, nonce, verdict.valid, verdict.message, resp.signature) then
      failStatus("Security validation failed: Invalid cryptographic signature.")
      return
    end

    if not verdict.valid then
      deleteCachedKey()
      failStatus(verdict.message or "Invalid license key.")
      return
    end

    -- Save verified key to cache
    saveCachedKey(key)

    setStatus("Authentication successful. Initializing script...", Color3.fromRGB(74, 222, 128))

    local placeId = tostring(game.PlaceId)
    local univId = tostring(game.GameId)
    local playerId = tostring(Players.LocalPlayer.UserId)
    local scriptUrl = serverUrl .. "/api/script?key=" .. key
      .. "&hwid=" .. hwid .. "&place_id=" .. placeId .. "&univ_id=" .. univId .. "&player_id=" .. playerId

    local function showError(errMsg)
      local ErrGui = Instance.new("ScreenGui")
      ErrGui.Name = "ZeroinError"
      ErrGui.Parent = targetParent
      ErrGui.ResetOnSpawn = false
      ErrGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      
      local EFrame = Instance.new("Frame")
      EFrame.Size = UDim2.new(0, 420, 0, 220)
      EFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
      EFrame.BackgroundColor3 = Color3.fromRGB(6, 10, 8)
      EFrame.BorderSizePixel = 0
      EFrame.ClipsDescendants = true
      EFrame.Parent = ErrGui
      Instance.new("UICorner", EFrame).CornerRadius = UDim.new(0, 12)

      local EStroke = Instance.new("UIStroke")
      EStroke.Thickness = 1.2
      EStroke.Color = Color3.fromRGB(239, 68, 68)
      EStroke.Transparency = 0.4
      EStroke.Parent = EFrame

      local ETopLine = Instance.new("Frame")
      ETopLine.Size = UDim2.new(1, 0, 0, 2)
      ETopLine.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
      ETopLine.BorderSizePixel = 0
      ETopLine.Parent = EFrame

      local ErrTitle = Instance.new("TextLabel")
      ErrTitle.Size = UDim2.new(1, -40, 0, 36)
      ErrTitle.Position = UDim2.new(0, 20, 0, 10)
      ErrTitle.Text = "Zeroin Hub · Execution Error"
      ErrTitle.TextColor3 = Color3.fromRGB(252, 165, 165)
      ErrTitle.Font = Enum.Font.GothamBold
      ErrTitle.TextSize = 16
      ErrTitle.TextXAlignment = Enum.TextXAlignment.Left
      ErrTitle.BackgroundTransparency = 1
      ErrTitle.Parent = EFrame

      local Desc = Instance.new("TextLabel")
      Desc.Size = UDim2.new(1, -40, 0, 32)
      Desc.Position = UDim2.new(0, 20, 0, 44)
      Desc.Text = "Please report this issue to our Discord support with a screenshot."
      Desc.TextColor3 = Color3.fromRGB(167, 199, 181)
      Desc.Font = Enum.Font.Gotham
      Desc.TextSize = 12
      Desc.TextXAlignment = Enum.TextXAlignment.Left
      Desc.BackgroundTransparency = 1
      Desc.Parent = EFrame

      local ErrBox = Instance.new("TextBox")
      ErrBox.Size = UDim2.new(1, -40, 0, 65)
      ErrBox.Position = UDim2.new(0, 20, 0, 80)
      ErrBox.Text = tostring(errMsg)
      ErrBox.TextColor3 = Color3.fromRGB(248, 113, 113)
      ErrBox.BackgroundColor3 = Color3.fromRGB(15, 8, 8)
      ErrBox.Font = Enum.Font.Code
      ErrBox.TextSize = 11
      ErrBox.TextWrapped = true
      ErrBox.TextEditable = false
      ErrBox.ClearTextOnFocus = false
      ErrBox.Parent = EFrame
      Instance.new("UICorner", ErrBox).CornerRadius = UDim.new(0, 8)

      local ErrActions = Instance.new("Frame")
      ErrActions.Size = UDim2.new(1, -40, 0, 34)
      ErrActions.Position = UDim2.new(0, 20, 0, 155)
      ErrActions.BackgroundTransparency = 1
      ErrActions.Parent = EFrame

      local CopyErrBtn = Instance.new("TextButton")
      CopyErrBtn.Size = UDim2.new(0, 180, 1, 0)
      CopyErrBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
      CopyErrBtn.BorderSizePixel = 0
      CopyErrBtn.Text = "Copy Error Details"
      CopyErrBtn.TextColor3 = Color3.fromRGB(252, 165, 165)
      CopyErrBtn.Font = Enum.Font.GothamBold
      CopyErrBtn.TextSize = 12
      CopyErrBtn.Parent = ErrActions
      Instance.new("UICorner", CopyErrBtn).CornerRadius = UDim.new(0, 6)

      local CloseErrBtn = Instance.new("TextButton")
      CloseErrBtn.Size = UDim2.new(0, 80, 1, 0)
      CloseErrBtn.Position = UDim2.new(1, -80, 0, 0)
      CloseErrBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 26)
      CloseErrBtn.BorderSizePixel = 0
      CloseErrBtn.Text = "Close"
      CloseErrBtn.TextColor3 = Color3.fromRGB(200, 220, 210)
      CloseErrBtn.Font = Enum.Font.GothamBold
      CloseErrBtn.TextSize = 12
      CloseErrBtn.Parent = ErrActions
      Instance.new("UICorner", CloseErrBtn).CornerRadius = UDim.new(0, 6)

      CopyErrBtn.MouseButton1Click:Connect(function()
        copyToClipboard(tostring(errMsg))
        CopyErrBtn.Text = "Copied to Clipboard"
        task.wait(2)
        CopyErrBtn.Text = "Copy Error Details"
      end)

      CloseErrBtn.MouseButton1Click:Connect(function()
        ErrGui:Destroy()
      end)
    end

    local isTampered = false
    if isfunctionhooked and (isfunctionhooked(loadstring) or isfunctionhooked(game.HttpGet)) then
      isTampered = true
    end

    if isTampered then
      Gui:Destroy()
      showError("Security Alert: Unauthorized function hook detected on core execution primitives.")
      return
    end

    setStatus("Downloading script payload...", Color3.fromRGB(74, 222, 128))
    Continue.Text = "Loading..."
    task.wait(0.05)

    local okGet, main = pcall(function() return game:HttpGet(scriptUrl) end)
    if not okGet or not main or main == "" then
      Gui:Destroy()
      showError("Network Error: Failed to retrieve script payload.\nDetails: " .. tostring(main))
      return
    end

    setStatus("Compiling script payload...", Color3.fromRGB(74, 222, 128))
    task.wait(0.05)

    local fn, err = loadstring(main)
    if not fn then
      Gui:Destroy()
      showError("Execution Error: Failed to compile script payload.\nDetails: " .. tostring(err))
      return
    end

    setStatus("Launching script...", Color3.fromRGB(74, 222, 128))
    Continue.Text = "Starting..."

    -- Destroy Keysystem GUI immediately
    pcall(function() Gui:Destroy() end)

    local authPayload = {
      valid = true,
      key = key,
      hwid = hwid,
      nonce = nonce,
      signature = resp.signature,
      message = (verdict and verdict.message) or "",
      publicKey = PUBLIC_KEY,
      verify = function(sig, canon, pk)
        return true
      end,
      timestamp = os.time(),
      sessionTime = tick(),
      serverUrl = serverUrl
    }

    task.spawn(fn, authPayload)

    -- Heartbeat Loop (starts after 60s)
    task.spawn(function()
      local HttpService = game:GetService("HttpService")
      while true do
        task.wait(60)
        pcall(function()
          local hbUrl = serverUrl .. "/api/heartbeat"
          local data = HttpService:JSONEncode({
            key = key,
            hwid = hwid,
            player_id = playerId,
            place_id = placeId
          })
          httpPost(hbUrl, data)
        end)
      end
    end)
  end)
end

Continue.MouseButton1Click:Connect(function()
  local key = KeyInput.Text:gsub("^%s*(.-)%s*$", "%1")
  if key == "" then
    setStatus("Please enter a valid license key.", Color3.fromRGB(239, 68, 68))
    return
  end
  startAuth(key, false)
end)

-- Auto-verify saved key from cache file ("Zeroin-Key")
local cachedKey = loadCachedKey()
if cachedKey and cachedKey ~= "" then
  KeyInput.Text = cachedKey
  task.spawn(function()
    startAuth(cachedKey, true)
  end)
end
