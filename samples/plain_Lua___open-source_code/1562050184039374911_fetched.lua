-- Octopus Hub Loader
local HUB = "https://www.octopushub.xyz"
local DISCORD_INVITE = "https://discord.gg/tAhMcb9gqb"
local GET_KEY_URL = HUB .. "/get-key"
local KEY_DIR = "OctopusHub"
local KEY_FILE = KEY_DIR .. "/license.key"
local FIXED_SLUG = nil
local MOBILE_MODE = false
local SCRIPT_OVERRIDE = nil
local PLACE_MAP = {
  [2788229376] = "hooduniversal",
  [75882626617183] = "danffa",
  [76583662972544] = "hooduniversal",
  [79360878607262] = "hooduniversal",
  [79824629083957] = "hooduniversal",
  [80811983015575] = "hooduniversal",
  [85002796582175] = "hooduniversal",
  [87115023272220] = "hooduniversal",
  [95942860977571] = "hooduniversal",
  [96689979021930] = "hooduniversal",
  [101056194411558] = "hooduniversal",
  [104097938617681] = "hooduniversal",
  [105403058959947] = "hooduniversal",
  [107778070777162] = "stealanegg",
  [111311535595882] = "hooduniversal",
  [111862645293891] = "hooduniversal",
  [112731528776884] = "knifeduels",
  [112898653189073] = "hooduniversal",
  [113315016621170] = "hooduniversal",
  [113476710204306] = "hooduniversal",
  [114806627761055] = "hooduniversal",
  [118198812210358] = "hooduniversal",
  [119777002525965] = "hooduniversal",
  [119865529165532] = "hooduniversal",
  [122577517724086] = "hooduniversal",
  [122868680533440] = "hooduniversal",
  [124635753504855] = "hooduniversal",
  [125468606634922] = "hooduniversal",
  [126165904502975] = "hooduniversal",
  [127682075866039] = "hooduniversal",
  [131796096293138] = "hooduniversal",
  [135160352253965] = "hooduniversal",
  [135734151565615] = "hooduniversal",
  [140294374760722] = "hooduniversal",
  [140503975300492] = "hooduniversal",
}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local DENIED = "Access denied."
local DEVICE_HWID = nil
local BOUND_HINT = " Get a new key at octopushub.xyz/get-key, or ask support to reset your device."

local function hasFileApi()
  return type(isfile) == "function"
    and type(readfile) == "function"
    and type(writefile) == "function"
    and type(makefolder) == "function"
    and type(isfolder) == "function"
end

local function notify(title, text, duration)
  duration = duration or 5
  pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = title,
      Text = text,
      Duration = duration,
    })
  end)
end

local function copyToClipboard(text)
  if type(setclipboard) == "function" then
    local ok = pcall(setclipboard, text)
    if ok then
      return true
    end
  end

  if type(toclipboard) == "function" then
    local ok = pcall(toclipboard, text)
    if ok then
      return true
    end
  end

  if syn and type(syn.write_clipboard) == "function" then
    local ok = pcall(syn.write_clipboard, text)
    if ok then
      return true
    end
  end

  return false
end

local function tryOpenBrowser(url)
  if syn and type(syn.open_browser) == "function" then
    local ok = pcall(syn.open_browser, url)
    if ok then
      return true
    end
  end

  if fluxus and type(fluxus.openbrowser) == "function" then
    local ok = pcall(fluxus.openbrowser, url)
    if ok then
      return true
    end
  end

  if type(openurl) == "function" then
    local ok = pcall(openurl, url)
    if ok then
      return true
    end
  end

  if http and type(http.open_url) == "function" then
    local ok = pcall(http.open_url, url)
    if ok then
      return true
    end
  end

  return false
end

local function openGetKeyPage(setStatus)
  local url = GET_KEY_URL

  if tryOpenBrowser(url) then
    notify("Octopus Hub", "Opening get-key page in your browser.")
    if setStatus then
      setStatus("Finish the free key checkpoint, then paste your key here.")
    end
    return
  end

  if copyToClipboard(url) then
    notify("Octopus Hub", "Get-key link copied to clipboard.")
    if setStatus then
      setStatus("Link copied. Open it, claim your key, then paste it here.")
    end
    return
  end

  notify("Octopus Hub", "Get key: " .. url, 8)
  if setStatus then
    setStatus("Open octopushub.xyz/get-key, then paste your key here.")
  end
end

local function openDiscordInvite(setStatus)
  local url = DISCORD_INVITE

  if tryOpenBrowser(url) then
    notify("Octopus Hub", "Opening Discord in your browser.")
    if setStatus then
      setStatus("Joined Discord? Use Get Key on the website for a free key.")
    end
    return
  end

  if copyToClipboard(url) then
    notify("Octopus Hub", "Discord invite copied to clipboard.")
    if setStatus then
      setStatus("Invite copied. Join Discord.")
    end
    return
  end

  notify("Octopus Hub", "Discord: " .. url, 8)
  if setStatus then
    setStatus("Join Discord for status and support.")
  end
end

local function enhanceLoadError(message)
  if type(message) ~= "string" or message == "" then
    return "Invalid or expired key."
  end

  if message:find("bound to another device", 1, true) then
    return message .. BOUND_HINT
  end

  if message:find("Device verification required", 1, true) then
    return message .. " Use a supported executor or get a new key at /get-key."
  end

  return message
end

local function protectGui(gui)
  if typeof(gui) ~= "Instance" then
    return
  end

  pcall(function()
    if gethui then
      gui.Parent = gethui()
      return
    end
  end)

  pcall(function()
    if syn and syn.protect_gui then
      syn.protect_gui(gui)
      gui.Parent = game:GetService("CoreGui")
      return
    end
  end)

  if gui.Parent == nil then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
  end
end

local function readSavedKey()
  if not hasFileApi() then
    return nil
  end

  if not isfile(KEY_FILE) then
    return nil
  end

  local ok, value = pcall(readfile, KEY_FILE)
  if not ok or type(value) ~= "string" then
    return nil
  end

  local trimmed = value:gsub("^%s+", ""):gsub("%s+$", "")
  if trimmed == "" then
    return nil
  end

  return trimmed
end

local function saveKey(key)
  if not hasFileApi() then
    return
  end

  pcall(function()
    if not isfolder(KEY_DIR) then
      makefolder(KEY_DIR)
    end
    writefile(KEY_FILE, key)
  end)
end

local function clearSavedKey()
  if not hasFileApi() then
    return
  end

  pcall(function()
    if isfile(KEY_FILE) then
      writefile(KEY_FILE, "")
    end
  end)
end

local function resolveSlug()
  if FIXED_SLUG then
    return FIXED_SLUG
  end
  return PLACE_MAP[game.PlaceId] or PLACE_MAP[game.GameId]
end

local function readHwid(value)
  if type(value) ~= "string" then
    return nil
  end

  local trimmed = value:gsub("^%s+", ""):gsub("%s+$", "")
  if trimmed == "" or #trimmed < 8 or #trimmed > 256 then
    return nil
  end

  return trimmed
end

local function getExecutorLabel()
  local ok, name, version = pcall(function()
    if type(identifyexecutor) == "function" then
      return identifyexecutor()
    end

    if type(getexecutorname) == "function" then
      return getexecutorname()
    end

    return nil
  end)

  if not ok then
    return nil
  end

  if type(name) == "string" and name ~= "" then
    if type(version) == "string" and version ~= "" then
      return name .. " " .. version
    end

    return name
  end

  return nil
end

local function executorNameLower()
  local label = getExecutorLabel()
  if type(label) == "string" and label ~= "" then
    return string.lower(label)
  end

  return ""
end

local function isDeltaExecutor()
  return executorNameLower():find("delta", 1, true) ~= nil
end

local function isMobileSession()
  if MOBILE_MODE then
    return true
  end

  if isDeltaExecutor() then
    return true
  end

  local ok, touch, keyboard = pcall(function()
    local uis = game:GetService("UserInputService")
    return uis.TouchEnabled, uis.KeyboardEnabled
  end)

  return ok and touch and not keyboard
end

local function resolveLoadSlug()
  local slug = resolveSlug()
  if slug == "hooduniversal" and isMobileSession() then
    return "hooduniversal-mobile"
  end
  return slug
end

local MOBILE_HWID_ALLOWLIST = {
  delta = true,
}

local function readMobileDeviceToken()
  local providers = {
    function()
      if type(getdeviceid) == "function" then
        return getdeviceid()
      end
    end,
    function()
      if type(get_device_id) == "function" then
        return get_device_id()
      end
    end,
    function()
      if type(getandroidid) == "function" then
        return getandroidid()
      end
    end,
    function()
      if type(get_android_id) == "function" then
        return get_android_id()
      end
    end,
    function()
      if type(getuniqueid) == "function" then
        return getuniqueid()
      end
    end,
    function()
      if Delta and type(Delta.GetDeviceId) == "function" then
        return Delta.GetDeviceId()
      end
    end,
  }

  for _, provider in ipairs(providers) do
    local ok, value = pcall(provider)
    if ok and type(value) == "string" and value ~= "" then
      return value:gsub("^%s+", ""):gsub("%s+$", "")
    end
  end

  return "unknown"
end

local function getMobileFallbackHwid()
  if not isMobileSession() then
    return nil
  end

  local execLower = executorNameLower()
  local allowed = false

  for name in pairs(MOBILE_HWID_ALLOWLIST) do
    if execLower:find(name, 1, true) then
      allowed = true
      break
    end
  end

  if not allowed then
    return nil
  end

  local uid = LocalPlayer and LocalPlayer.UserId or 0
  local token = readMobileDeviceToken()
  return readHwid("delta:" .. tostring(uid) .. ":" .. token)
end

local function getDeviceHwid()
  -- Prefer UNC globals used by Potassium, Wave, Volt, Madium, Real, etc.
  local providers = {
    function()
      if type(gethwid) == "function" then
        return gethwid()
      end
    end,
    function()
      if type(get_hwid) == "function" then
        return get_hwid()
      end
    end,
    function()
      if type(get_user_identifier) == "function" then
        return get_user_identifier()
      end
    end,
    -- Legacy Synapse-era / rare aliases (Synapse Z may still expose syn.*)
    function()
      if syn and type(syn.gethwid) == "function" then
        return syn.gethwid()
      end
    end,
    function()
      if syn and type(syn.get_hwid) == "function" then
        return syn.get_hwid()
      end
    end,
    function()
      if type(gethwid_string) == "function" then
        return gethwid_string()
      end
    end,
    function()
      if type(getdeviceid) == "function" then
        return getdeviceid()
      end
    end,
    function()
      if type(get_device_id) == "function" then
        return get_device_id()
      end
    end,
    function()
      if Delta and type(Delta.GetDeviceId) == "function" then
        return Delta.GetDeviceId()
      end
    end,
  }

  for _, provider in ipairs(providers) do
    local ok, value = pcall(provider)
    if ok then
      local hwid = readHwid(value)
      if hwid then
        return hwid
      end
    end
  end

  return getMobileFallbackHwid()
end

local function destroyKeyGui()
  local function scan(parent)
    for _, child in ipairs(parent:GetChildren()) do
      if child:IsA("ScreenGui") and child.Name == "OctopusHubKey" then
        child:Destroy()
      end
    end
  end

  pcall(function()
    if gethui then
      scan(gethui())
    end
  end)

  pcall(function()
    scan(game:GetService("CoreGui"))
  end)

  pcall(function()
    scan(LocalPlayer:WaitForChild("PlayerGui"))
  end)
end

local function executorRequest(url, method, headers, body)
  local requestFn = (syn and syn.request)
    or (http and http.request)
    or (fluxus and fluxus.request)
    or request
    or http_request

  if type(requestFn) ~= "function" then
    return nil
  end

  local payload = {
    Url = url,
    Method = method or "GET",
    Headers = headers,
  }

  if type(body) == "string" then
    payload.Body = body
  end

  local ok, response = pcall(function()
    return requestFn(payload)
  end)

  if not ok or type(response) ~= "table" then
    return nil
  end

  return {
    status = tonumber(response.StatusCode) or 0,
    body = type(response.Body) == "string" and response.Body or "",
  }
end

local function authHeaders(key, hwid, executor)
  local headers = {
    ["Accept"] = "*/*",
    ["Content-Type"] = "application/json",
    ["X-Octopus-Hwid"] = hwid,
    ["X-Octopus-Key"] = key,
  }

  if type(executor) == "string" and executor ~= "" then
    headers["X-Octopus-Executor"] = executor
  end

  if MOBILE_MODE or isMobileSession() then
    headers["X-Octopus-Platform"] = "mobile"
  end

  return headers
end

local function parseJsonBody(body)
  if type(body) ~= "string" or body == "" then
    return nil
  end

  local ok, decoded = pcall(function()
    return HttpService:JSONDecode(body)
  end)

  if ok and type(decoded) == "table" then
    return decoded
  end

  return nil
end

local function isDenied(body)
  if type(body) ~= "string" then
    return true
  end

  local trimmed = body:gsub("^%s+", ""):gsub("%s+$", "")

  if trimmed == "" then
    return true
  end

  if trimmed == DENIED then
    return true
  end

  -- Short error payloads only (avoid false positives on real script source).
  if #trimmed <= 240 then
    if trimmed:find(DENIED, 1, true) ~= nil then
      return true
    end

    if trimmed:sub(1, 1) == "{" then
      return true
    end

    local lower = string.lower(trimmed)
    if lower:find("<!doctype", 1, true) or lower:find("<html", 1, true) then
      return true
    end
  end

  return false
end

local function isScriptBody(body)
  if type(body) ~= "string" or #body < 32 then
    return false
  end

  if isDenied(body) then
    return false
  end

  local trimmed = body:gsub("^%s+", "")
  local lowerHead = string.lower(trimmed:sub(1, 64))
  if lowerHead:find("<!doctype", 1, true) or lowerHead:find("<html", 1, true) then
    return false
  end

  return true
end

local function isAuthFailure(message)
  if type(message) ~= "string" then
    return false
  end

  if message:find("Invalid or expired key", 1, true) then
    return true
  end

  if message:find("bound to another device", 1, true) then
    return true
  end

  if message:find("Device verification required", 1, true) then
    return true
  end

  return false
end

local function parseLoadError(body)
  if type(body) ~= "string" then
    return "Invalid or expired key."
  end

  local trimmed = body:gsub("^%s+", ""):gsub("%s+$", "")
  if trimmed == "" or trimmed == DENIED then
    return "Invalid or expired key."
  end

  if #trimmed <= 200 and not isDenied(trimmed) then
    return trimmed
  end

  if #trimmed <= 200 and trimmed:find("Device verification", 1, true) then
    return trimmed
  end

  if #trimmed <= 200 and trimmed:find("bound to another device", 1, true) then
    return trimmed
  end

  return "Invalid or expired key."
end

local function fetchViaHttpGet(url)
  local ok, body = pcall(function()
    return game:HttpGet(url, true)
  end)

  if not ok or type(body) ~= "string" then
    return false, "Could not reach Octopus Hub. Try again."
  end

  if isScriptBody(body) then
    return true, body
  end

  return false, parseLoadError(body)
end

local function fetchScriptBody(slug, key, hwid)
  local executor = getExecutorLabel()
  local headers = authHeaders(key, hwid, executor)
  local ticketResponse = executorRequest(
    HUB .. "/api/load/ticket",
    "POST",
    headers,
    HttpService:JSONEncode({ slug = slug })
  )

  if not ticketResponse then
    return false, "Your executor does not support authenticated requests. Use a supported executor from Discord."
  end

  if ticketResponse.status == 429 then
    return false, "Too many requests. Wait a moment."
  end

  if ticketResponse.status ~= 200 then
    return false, parseLoadError(ticketResponse.body)
  end

  local payload = parseJsonBody(ticketResponse.body)
  local ticket = payload and payload.ticket
  if type(ticket) ~= "string" or ticket == "" then
    return false, "Could not reach Octopus Hub. Try again."
  end

  local loadHeaders = {
    ["Accept"] = "*/*",
    ["X-Octopus-Ticket"] = ticket,
  }

  if type(executor) == "string" and executor ~= "" then
    loadHeaders["X-Octopus-Executor"] = executor
  end

  if MOBILE_MODE or isMobileSession() then
    loadHeaders["X-Octopus-Platform"] = "mobile"
  end

  local response = executorRequest(HUB .. "/api/load/" .. slug, "GET", loadHeaders)

  if not response then
    return false, "Could not reach Octopus Hub. Try again."
  end

  if response.status == 200 and isScriptBody(response.body) then
    return true, response.body
  end

  if response.status == 429 then
    return false, "Too many requests. Wait a moment."
  end

  if response.status == 403 then
    return false, parseLoadError(response.body)
  end

  return false, "Could not reach Octopus Hub. Try again."
end

local function runScriptBody(body)
  task.spawn(function()
    notify("Octopus Hub", "Loading script...", 3)

    local chunk, compileErr = loadstring(body)
    if not chunk then
      notify("Octopus Hub", "Script compile error. See executor console.", 8)
      warn("[Octopus Hub] compile:", compileErr)
      return
    end

    local runOk, runErr = pcall(chunk)
    if runOk then
      notify("Octopus Hub", "Loaded successfully.", 5)
    else
      local msg = type(runErr) == "string" and runErr or "unknown error"
      if #msg > 140 then
        msg = msg:sub(1, 140) .. "..."
      end
      notify("Octopus Hub", "Script error: " .. msg, 8)
      warn("[Octopus Hub] run:", runErr)
    end
  end)
end

local function startWithKey(key)
  local slug = resolveLoadSlug()
  if not slug then
    return false, "This game is not supported yet."
  end

  local ok, bodyOrError = fetchScriptBody(slug, key, DEVICE_HWID)
  if not ok then
    return false, enhanceLoadError(bodyOrError)
  end

  if type(SCRIPT_OVERRIDE) == "string" and SCRIPT_OVERRIDE ~= "" then
    local overrideUrl = HUB .. SCRIPT_OVERRIDE
    local executor = getExecutorLabel()
    local overrideOk, overrideBody = fetchViaHttpGet(overrideUrl)
    if not overrideOk then
      local response = executorRequest(
        overrideUrl,
        "GET",
        authHeaders(key, DEVICE_HWID, executor)
      )
      if response and response.status == 200 and isScriptBody(response.body) then
        overrideOk = true
        overrideBody = response.body
      end
    end
    if not overrideOk or type(overrideBody) ~= "string" then
      return false, "Test script is unavailable."
    end
    pcall(function()
      local g = (getgenv and getgenv()) or _G
      if type(g) == "table" then
        g._ohKey = key
        g._ohHwid = DEVICE_HWID
      end
    end)
    runScriptBody(overrideBody)
    return true
  end

  pcall(function()
    local g = (getgenv and getgenv()) or _G
    if type(g) == "table" then
      g._ohKey = key
      g._ohHwid = DEVICE_HWID
    end
  end)
  runScriptBody(bodyOrError)
  return true
end

local function promptForKey(callback, initialError)
  destroyKeyGui()

  local frameW = 420
  local frameH = 280
  local btnH = 40
  local inputH = 42
  local noteH = 48

  if MOBILE_MODE or isMobileSession() then
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(360, 640)
    local inset = game:GetService("GuiService"):GetGuiInset()
    local usableW = math.max(280, viewport.X - inset.X)
    local usableH = math.max(320, viewport.Y - inset.Y)
    frameW = math.clamp(math.floor(usableW * 0.92), 280, 420)
    frameH = math.clamp(math.floor(usableH * 0.55), 260, 340)
    btnH = math.max(48, math.floor(frameH * 0.14))
    inputH = math.max(44, math.floor(frameH * 0.15))
    noteH = math.max(40, math.floor(frameH * 0.17))
  end

  local gui = Instance.new("ScreenGui")
  gui.Name = "OctopusHubKey"
  gui.ResetOnSpawn = false
  gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.DisplayOrder = 999

  local root = Instance.new("Frame")
  root.Name = "Root"
  root.AnchorPoint = Vector2.new(0.5, 0.5)
  root.Position = UDim2.fromScale(0.5, 0.5)
  root.Size = UDim2.fromOffset(frameW, frameH)
  root.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
  root.BorderSizePixel = 0
  root.Parent = gui

  local corner = Instance.new("UICorner")
  corner.CornerRadius = UDim.new(0, 12)
  corner.Parent = root

  local stroke = Instance.new("UIStroke")
  stroke.Color = Color3.fromRGB(88, 101, 242)
  stroke.Thickness = 1
  stroke.Parent = root

  local title = Instance.new("TextLabel")
  title.BackgroundTransparency = 1
  title.Position = UDim2.fromOffset(20, 18)
  title.Size = UDim2.new(1, -40, 0, 28)
  title.Font = Enum.Font.GothamBold
  title.Text = "Octopus Hub"
  title.TextColor3 = Color3.fromRGB(255, 255, 255)
  title.TextSize = 22
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.Parent = root

  local subtitle = Instance.new("TextLabel")
  subtitle.BackgroundTransparency = 1
  subtitle.Position = UDim2.fromOffset(20, 48)
  subtitle.Size = UDim2.new(1, -40, 0, 20)
  subtitle.Font = Enum.Font.Gotham
  subtitle.Text = "Enter your license key"
  subtitle.TextColor3 = Color3.fromRGB(170, 170, 190)
  subtitle.TextSize = 14
  subtitle.TextXAlignment = Enum.TextXAlignment.Left
  subtitle.Parent = root

  local note = Instance.new("TextLabel")
  note.BackgroundTransparency = 1
  note.Position = UDim2.fromOffset(20, 72)
  note.Size = UDim2.new(1, -40, 0, noteH)
  note.Font = Enum.Font.Gotham
  note.Text = "Get a free key at octopushub.xyz/get-key, then paste it below."
  note.TextColor3 = Color3.fromRGB(130, 130, 150)
  note.TextSize = 13
  note.TextWrapped = true
  note.TextXAlignment = Enum.TextXAlignment.Left
  note.TextYAlignment = Enum.TextYAlignment.Top
  note.Parent = root

  local input = Instance.new("TextBox")
  input.Name = "KeyInput"
  local inputY = 72 + noteH + 8
  input.Position = UDim2.fromOffset(20, inputY)
  input.Size = UDim2.new(1, -40, 0, inputH)
  input.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
  input.BorderSizePixel = 0
  input.ClearTextOnFocus = false
  input.Font = Enum.Font.Code
  input.PlaceholderText = "octopus_..."
  input.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
  input.Text = ""
  input.TextColor3 = Color3.fromRGB(255, 255, 255)
  input.TextSize = 15
  input.Parent = root

  local inputCorner = Instance.new("UICorner")
  inputCorner.CornerRadius = UDim.new(0, 8)
  inputCorner.Parent = input

  local inputPadding = Instance.new("UIPadding")
  inputPadding.PaddingLeft = UDim.new(0, 12)
  inputPadding.PaddingRight = UDim.new(0, 12)
  inputPadding.Parent = input

  local errorLabel = Instance.new("TextLabel")
  errorLabel.BackgroundTransparency = 1
  local errorY = inputY + inputH + 6
  errorLabel.Position = UDim2.fromOffset(20, errorY)
  errorLabel.Size = UDim2.new(1, -40, 0, 18)
  errorLabel.Font = Enum.Font.Gotham
  errorLabel.Text = ""
  errorLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
  errorLabel.TextSize = 13
  errorLabel.TextXAlignment = Enum.TextXAlignment.Left
  errorLabel.Parent = root

  local getKey = Instance.new("TextButton")
  local btnY = errorY + 22
  getKey.Position = UDim2.fromOffset(20, btnY)
  getKey.Size = UDim2.new(0.5, -24, 0, btnH)
  getKey.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
  getKey.BorderSizePixel = 0
  getKey.Font = Enum.Font.GothamBold
  getKey.Text = "Get Key"
  getKey.TextColor3 = Color3.fromRGB(220, 220, 235)
  getKey.TextSize = 16
  getKey.Parent = root

  local getKeyCorner = Instance.new("UICorner")
  getKeyCorner.CornerRadius = UDim.new(0, 8)
  getKeyCorner.Parent = getKey

  local getKeyStroke = Instance.new("UIStroke")
  getKeyStroke.Color = Color3.fromRGB(88, 101, 242)
  getKeyStroke.Thickness = 1
  getKeyStroke.Parent = getKey

  local submit = Instance.new("TextButton")
  submit.Position = UDim2.new(0.5, 4, 0, btnY)
  submit.Size = UDim2.new(0.5, -24, 0, btnH)
  submit.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
  submit.BorderSizePixel = 0
  submit.Font = Enum.Font.GothamBold
  submit.Text = "Continue"
  submit.TextColor3 = Color3.fromRGB(255, 255, 255)
  submit.TextSize = 16
  submit.Parent = root

  local submitCorner = Instance.new("UICorner")
  submitCorner.CornerRadius = UDim.new(0, 8)
  submitCorner.Parent = submit

  protectGui(gui)

  local busy = false

  local function setError(message)
    errorLabel.Text = message or ""
  end

  local function setStatus(message)
    errorLabel.TextColor3 = Color3.fromRGB(140, 200, 140)
    errorLabel.Text = message or ""
  end

  local function clearStatusTone()
    errorLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
  end

  if initialError then
    setError(initialError)
  end

  getKey.MouseButton1Click:Connect(function()
    openGetKeyPage(function(message)
      if message == "" then
        clearStatusTone()
        setError("")
        return
      end

      if message:find("copied", 1, true) then
        setStatus(message)
      else
        clearStatusTone()
        setError(message)
      end
    end)
  end)

  local function submitKey()
    if busy then
      return
    end

    local value = input.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then
      clearStatusTone()
      setError("Enter a key to continue.")
      return
    end

    busy = true
    submit.Text = "Checking..."
    clearStatusTone()
    setError("")

    task.spawn(function()
      local ok, err = callback(value)

      if ok then
        gui:Destroy()
        return
      end

      busy = false
      submit.Text = "Continue"
      clearStatusTone()
      setError(err or "Invalid or expired key.")
    end)
  end

  submit.MouseButton1Click:Connect(submitKey)

  input.FocusLost:Connect(function(enter)
    if enter then
      submitKey()
    end
  end)
end

local function main()
  DEVICE_HWID = getDeviceHwid()
  if not DEVICE_HWID then
    local executorLabel = getExecutorLabel()
    local message
    if MOBILE_MODE or isMobileSession() then
      message = executorLabel
        and (executorLabel .. " on mobile could not resolve a device ID. Rejoin or update Delta.")
        or "Mobile executor does not support device verification yet."
    else
      message = executorLabel
        and (executorLabel .. " does not provide a device ID. Use a supported executor from Discord.")
        or "Your executor does not support device verification. Use a supported executor from Discord."
    end
    notify("Octopus Hub", message, 8)
    return
  end

  local slug = resolveLoadSlug()
  if not slug then
    notify("Octopus Hub", "This game is not supported yet. Check Discord for supported titles.", 8)
    return
  end

  local savedKey = readSavedKey()
  if savedKey then
    local ok, err = startWithKey(savedKey)
    if ok then
      return
    end

    -- Only wipe disk key on real auth/device failures — keep it through rate limits / outages.
    if isAuthFailure(err) then
      clearSavedKey()
      promptForKey(function(key)
        local loadOk, loadErr = startWithKey(key)
        if loadOk then
          saveKey(key)
          return true
        end

        return false, loadErr
      end, enhanceLoadError(err) or "Saved key no longer works. Enter a new key.")
      return
    end

    notify("Octopus Hub", err or "Could not reach Octopus Hub. Try again.", 8)
    return
  end

  promptForKey(function(key)
    local ok, err = startWithKey(key)
    if ok then
      saveKey(key)
      return true
    end

    return false, err
  end)
end

main()
