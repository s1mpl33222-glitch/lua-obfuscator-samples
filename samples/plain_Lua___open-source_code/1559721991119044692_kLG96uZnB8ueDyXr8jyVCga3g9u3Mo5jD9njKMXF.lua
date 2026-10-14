-- AK Protection :: Keyed Loader
-- Script slug: kLG96uZnB8ueDyXr8jyVCga3g9u3Mo5jD9njKMXF
local AK_ENDPOINT = "https://ak-protection.lovable.app/api/public/redeem"
local AK_SLUG = "kLG96uZnB8ueDyXr8jyVCga3g9u3Mo5jD9njKMXF"

local HttpService = game:GetService("HttpService")

local function ak_hwid()
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok and id then return id end
    local ok2, id2 = pcall(function()
        if syn and syn.crypt and syn.crypt.random then return syn.crypt.random(32):gsub("%W",""):sub(1,32) end
        if identifyexecutor then return "exec-"..tostring(identifyexecutor()) end
        return tostring(tick())..tostring(math.random(1,1e9))
    end)
    return id2 or "unknown"
end

local function ak_httppost_raw(url, body)
    if syn and syn.request then
        local r = syn.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
        return r.StatusCode, r.Body
    elseif http and http.request then
        local r = http.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
        return r.StatusCode, r.Body
    elseif http_request then
        local r = http_request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
        return r.StatusCode, r.Body
    elseif request then
        local r = request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
        return r.StatusCode, r.Body
    else
        return 0, "no_http"
    end
end

local function ak_httppost(url, body)
    local ok, a, b = pcall(ak_httppost_raw, url, body)
    if not ok then return 0, "post_failed" end
    return a, b
end

local function ak_urlencode(s)
    return (tostring(s):gsub("[^%w%-%_%.%~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function ak_httpget(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and res then return 200, res end
    local ok2, res2 = pcall(function() return game:HttpGetAsync(url) end)
    if ok2 and res2 then return 200, res2 end
    return 0, "no_http"
end

local function redeem(key, hwid, player)
    local resp, status
    local body = HttpService:JSONEncode({slug = AK_SLUG, key = key, hwid = hwid, player = player})
    status, resp = ak_httppost(AK_ENDPOINT, body)
    if status ~= 200 or type(resp) ~= "string" or #resp == 0 then
        local url = AK_ENDPOINT
            .. "?slug=" .. ak_urlencode(AK_SLUG)
            .. "&key=" .. ak_urlencode(key)
            .. "&hwid=" .. ak_urlencode(hwid)
            .. "&player=" .. ak_urlencode(player)
        status, resp = ak_httpget(url)
    end
    if status ~= 200 then return nil, tostring(resp or ("http "..tostring(status))) end
    local ok, parsed = pcall(function() return HttpService:JSONDecode(resp) end)
    if not ok or not parsed then return nil, "bad_response" end
    if not parsed.ok then return nil, parsed.error or "denied" end
    return parsed.code, nil
end

local hwid = ak_hwid()
local player = ""
pcall(function() player = tostring(game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Name or "") end)

-- Try last-saved key first (per-executor persistence).
local savedKey
pcall(function()
    if readfile and isfile and isfile("AK_key_"..AK_SLUG..".txt") then
        savedKey = readfile("AK_key_"..AK_SLUG..".txt")
    end
end)

if savedKey and #savedKey > 0 then
    local code, err = redeem(savedKey, hwid, player)
    if code then
        local fn, e2 = loadstring(code)
        if fn then return fn() end
    end
end

-- Otherwise open a small key-entry UI.
local ok, ui = pcall(function()
    local Players = game:GetService("Players")
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "AK_Key_UI"
    gui.ResetOnSpawn = false
    gui.Parent = pg

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 360, 0, 200)
    frame.Position = UDim2.new(0.5, -180, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(10, 26, 22)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(34, 139, 90)
    stroke.Thickness = 2

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -20, 0, 34)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "AK PROTECTION"
    title.Font = Enum.Font.GothamBlack
    title.TextColor3 = Color3.fromRGB(120, 220, 160)
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", frame)
    sub.Size = UDim2.new(1, -20, 0, 20)
    sub.Position = UDim2.new(0, 10, 0, 42)
    sub.BackgroundTransparency = 1
    sub.Text = "Enter your key to run this script"
    sub.Font = Enum.Font.Gotham
    sub.TextColor3 = Color3.fromRGB(190, 220, 200)
    sub.TextSize = 13
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -20, 0, 40)
    box.Position = UDim2.new(0, 10, 0, 76)
    box.BackgroundColor3 = Color3.fromRGB(15, 40, 32)
    box.TextColor3 = Color3.fromRGB(230, 245, 235)
    box.PlaceholderText = "AK-XXXXX-XXXXX-XXXXX-XXXXX"
    box.PlaceholderColor3 = Color3.fromRGB(120, 160, 140)
    box.Font = Enum.Font.Code
    box.TextSize = 15
    box.ClearTextOnFocus = false
    box.Text = ""
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 126)
    btn.BackgroundColor3 = Color3.fromRGB(34, 160, 100)
    btn.TextColor3 = Color3.fromRGB(6, 20, 15)
    btn.Text = "Execute"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, -20, 0, 16)
    status.Position = UDim2.new(0, 10, 1, -22)
    status.BackgroundTransparency = 1
    status.Text = "Made by AK"
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(140, 190, 160)
    status.TextSize = 12

    return {frame=frame, box=box, btn=btn, status=status, gui=gui}
end)

if not ok then return end

ui.btn.MouseButton1Click:Connect(function()
    local key = tostring(ui.box.Text or ""):gsub("%s+","")
    if #key < 5 then ui.status.Text = "Enter a key" return end
    ui.status.Text = "Verifying..."
    local code, err = redeem(key, hwid, player)
    if not code then ui.status.Text = "Rejected: "..tostring(err) return end
    pcall(function() if writefile then writefile("AK_key_"..AK_SLUG..".txt", key) end end)
    ui.gui:Destroy()
    local fn, e = loadstring(code)
    if fn then fn() else warn("AK loader error: "..tostring(e)) end
end)
