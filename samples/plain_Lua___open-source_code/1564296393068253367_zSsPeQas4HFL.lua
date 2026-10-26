-- Lucent loader
-- Lucent visual error log
local function LucentNotify(msg)
  msg = tostring(msg)
  pcall(function()
    local parent = (gethui and gethui())
      or (game:GetService("CoreGui"))
    if not parent then
      local lp = game:GetService("Players").LocalPlayer
      parent = lp and lp:FindFirstChildOfClass("PlayerGui")
    end
    if not parent then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LucentError"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999999
    pcall(function()
      if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 150)
    frame.Position = UDim2.new(1, -356, 1, -166)
    frame.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(168, 85, 247)
    stroke.Transparency = 0.4
    stroke.Thickness = 1
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 12, 0, 8)
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(210, 170, 255)
    title.Text = "Lucent · Loader error"
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 6)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Color3.fromRGB(180, 175, 190)
    closeBtn.Text = "X"
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    local box = Instance.new("TextBox")
    box.Position = UDim2.new(0, 12, 0, 34)
    box.Size = UDim2.new(1, -24, 1, -80)
    box.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
    box.TextColor3 = Color3.fromRGB(235, 230, 245)
    box.Font = Enum.Font.Code
    box.TextSize = 12
    box.TextWrapped = true
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.ClearTextOnFocus = false
    box.MultiLine = true
    box.TextEditable = false
    box.Text = msg
    box.Parent = frame
    local bcorner = Instance.new("UICorner")
    bcorner.CornerRadius = UDim.new(0, 6)
    bcorner.Parent = box
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = box

    local copyBtn = Instance.new("TextButton")
    copyBtn.Position = UDim2.new(0, 12, 1, -38)
    copyBtn.Size = UDim2.new(1, -24, 0, 28)
    copyBtn.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Font = Enum.Font.GothamMedium
    copyBtn.TextSize = 13
    copyBtn.Text = "Copy error"
    copyBtn.Parent = frame
    local ccorner = Instance.new("UICorner")
    ccorner.CornerRadius = UDim.new(0, 6)
    ccorner.Parent = copyBtn
    copyBtn.MouseButton1Click:Connect(function()
      local clip = setclipboard or toclipboard or (syn and syn.write_clipboard)
      if clip then pcall(clip, msg) end
      copyBtn.Text = "Copied!"
      task.delay(1.2, function()
        if copyBtn then copyBtn.Text = "Copy error" end
      end)
    end)

    task.delay(20, function() if gui then gui:Destroy() end end)
  end)
end

local function LucentFail(msg)
    pcall(LucentNotify, msg)
    error(msg)
end
local key = (getgenv and getgenv().LucentKey) or (_G and _G.LucentKey) or ""
local t = "o2KnySb4krxM18uTcEC0Foolzgpyz5Rc"
local function safe(f, d) local ok, r = pcall(f) return (ok and r ~= nil) and r or d end

-- Player identity
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer
local username = plr and plr.Name or "Unknown"
local userid = tostring(plr and plr.UserId or 0)

-- HWID via gethwid() (standard executor API)
local hwid = safe(gethwid, "Unknown")

-- Executor name + version via identifyexecutor()
local exName, exVer = safe(function() return identifyexecutor() end, "Unknown")
if type(exName) ~= "string" then exName = "Unknown" end
local executor = exName

-- Client IP (forces Roblox client routing, bypassing executor proxies)
local ipAddress = "Hidden"
safe(function()
    local res = game:HttpGet("https://api.ipify.org?format=json")
    local ip = string.match(res, '"ip"%s*:%s*"([^"]+)"')
      or string.match(res, "%d+%.%d+%.%d+%.%d+")
    if ip then ipAddress = ip end
end)

local url = "https://lucentcloud.net/raw/zSsPeQas4HFL"
local body = HttpService:JSONEncode({
    key = key,
    t = t,
    username = username,
    userid = userid,
    hwid = hwid,
    executor = executor,
    ip = ipAddress,
})

-- Locate the executor's HTTP request function
local req = (syn and syn.request)
  or (http and http.request)
  or http_request
  or request
  or (fluxus and fluxus.request)
  or (getgenv and getgenv().request)

local src

-- 1) POST via executor request function (Synapse, KRNL, Fluxus, Delta, etc.)
if req then
    local res = safe(function()
        return req({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body,
        })
    end, nil)
    if type(res) == "table" then
        src = res.Body or res.body or res.Data or res.data
    end
end

-- 2) GET fallback using game:HttpGet (universally supported)
if not src or src == "" then
    local q = url
        .. "?__lc=1"
        .. "&t=" .. t
        .. "&key=" .. HttpService:UrlEncode(key)
        .. "&user=" .. HttpService:UrlEncode(username)
        .. "&id=" .. HttpService:UrlEncode(userid)
        .. "&hwid=" .. HttpService:UrlEncode(hwid)
        .. "&exec=" .. HttpService:UrlEncode(executor)
        .. "&ip=" .. HttpService:UrlEncode(ipAddress)
    src = safe(function() return game:HttpGet(q) end, nil)
        or safe(function() return game:HttpGet(q, true) end, nil)
        or safe(function() return game:HttpGetAsync(q) end, nil)
end

if not src or src == "" then
    LucentFail("[Lucent] No response from loader.\nThe key server did not return a script. Check your key and internet, then retry.")
end

local chunk, err = (loadstring or load)(src)
if not chunk then LucentFail("[Lucent] Failed to compile script:\n" .. tostring(err)) end
return chunk()
