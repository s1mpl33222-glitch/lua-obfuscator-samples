-- Zaxian Login Stub (publik). Script utama baru dikirim setelah key valid.
local HOST = "https://zaxian.zaxianws.workers.dev"
local HttpService = game:GetService("HttpService")
local KEYFILE = "ZaxianKey.txt"

local function deviceId()
    local id
    pcall(function() if gethwid then id = gethwid() end end)
    if not id or id == "" then pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end) end
    if not id or id == "" then
        pcall(function()
            if isfile and isfile("ZaxianDevice.txt") then id = readfile("ZaxianDevice.txt")
            else id = HttpService:GenerateGUID(false); writefile("ZaxianDevice.txt", id) end
        end)
    end
    return (tostring(id or "unknown"):gsub("[^%w%-]", ""))
end

local parent = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function() local o = parent:FindFirstChild("ZaxianLogin"); if o then o:Destroy() end end)
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "ZaxianLogin", false, 999
gui.Parent = parent

local function new(class, props, par)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = par
    return o
end
local box = new("Frame", {Size = UDim2.fromOffset(320, 318), Position = UDim2.new(0.5, -160, 0.5, -159), BackgroundColor3 = Color3.fromRGB(14, 13, 24), Active = true, Draggable = true}, gui)
new("UICorner", {CornerRadius = UDim.new(0, 14)}, box)
local st = new("UIStroke", {Thickness = 2, Color = Color3.new(1, 1, 1)}, box)
local g = new("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(96, 165, 255), Color3.fromRGB(168, 110, 255))}, st)
task.spawn(function() while gui.Parent do g.Rotation = (g.Rotation + 2) % 360; task.wait(0.03) end end)
new("TextLabel", {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.fromOffset(0, 14), BackgroundTransparency = 1, Text = "ZAXIAN", TextColor3 = Color3.fromRGB(150, 150, 255), TextSize = 28, Font = Enum.Font.GothamBlack}, box)
new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 52), BackgroundTransparency = 1, Text = "Masukkan key untuk melanjutkan", TextColor3 = Color3.fromRGB(128, 128, 160), TextSize = 12, Font = Enum.Font.Gotham}, box)
local input = new("TextBox", {Size = UDim2.new(1, -40, 0, 40), Position = UDim2.fromOffset(20, 84), BackgroundColor3 = Color3.fromRGB(26, 26, 43), Text = "", PlaceholderText = "ZX-XXXX-XXXX-XXXX", TextColor3 = Color3.new(1, 1, 1), PlaceholderColor3 = Color3.fromRGB(110, 110, 140), TextSize = 14, Font = Enum.Font.GothamMedium, ClearTextOnFocus = false}, box)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, input)
local msg = new("TextLabel", {Size = UDim2.new(1, -40, 0, 18), Position = UDim2.fromOffset(20, 130), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(240, 72, 84), TextSize = 12, Font = Enum.Font.GothamMedium}, box)
local btn = new("TextButton", {Size = UDim2.new(1, -40, 0, 40), Position = UDim2.fromOffset(20, 158), BackgroundColor3 = Color3.fromRGB(110, 120, 255), Text = "Masuk", TextColor3 = Color3.new(1, 1, 1), TextSize = 15, Font = Enum.Font.GothamBold, AutoButtonColor = true}, box)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, btn)
new("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(96, 165, 255), Color3.fromRGB(168, 110, 255))}, btn)

local gk = new("TextButton", {Size = UDim2.new(1, -40, 0, 36), Position = UDim2.fromOffset(20, 206), BackgroundColor3 = Color3.fromRGB(255, 200, 60), Text = "Get Key Gratis (2 jam)", TextColor3 = Color3.fromRGB(36, 26, 0), TextSize = 14, Font = Enum.Font.GothamBold, AutoButtonColor = true}, box)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, gk)
new("TextLabel", {Size = UDim2.new(1, -40, 0, 16), Position = UDim2.fromOffset(20, 250), BackgroundTransparency = 1, Text = "Link akan disalin, buka di browser", TextColor3 = Color3.fromRGB(128, 128, 160), TextSize = 11, Font = Enum.Font.Gotham}, box)
local dc = new("TextButton", {Size = UDim2.new(1, -40, 0, 30), Position = UDim2.fromOffset(20, 274), BackgroundColor3 = Color3.fromRGB(88, 101, 242), Text = "Join Discord (salin link)", TextColor3 = Color3.new(1, 1, 1), TextSize = 13, Font = Enum.Font.GothamBold, AutoButtonColor = true}, box)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, dc)
dc.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/PGSBJcuCd"); msg.TextColor3 = Color3.fromRGB(70, 224, 132); msg.Text = "Link Discord disalin!"
    else msg.Text = "https://discord.gg/PGSBJcuCd" end
end)
gk.MouseButton1Click:Connect(function()
    local link = HOST .. "/getkey"
    if setclipboard then setclipboard(link); msg.TextColor3 = Color3.fromRGB(70, 224, 132); msg.Text = "Link disalin! Buka di browser"
    else msg.Text = link end
end)

pcall(function() if isfile and isfile(KEYFILE) then input.Text = readfile(KEYFILE) end end)

local busy = false
local function go()
    if busy then return end
    local key = string.upper((input.Text:gsub("%s", "")))
    if #key < 10 then msg.Text = "Masukkan key dulu" return end
    busy, msg.Text, btn.Text = true, "", "Memeriksa..."
    local ok, body = pcall(function() return game:HttpGet(HOST .. "/load?t=" .. key .. "&d=" .. deviceId() .. "&p=" .. tostring(game.GameId) .. "&pl=" .. tostring(game.PlaceId)) end)
    if not ok then msg.Text = "Koneksi gagal, coba lagi"
    elseif body:sub(1, 6) == "--ERR:" then msg.Text = body:sub(7)
    else
        pcall(function() if writefile then writefile(KEYFILE, key) end end)
        getgenv().ZaxianToken, getgenv().ZaxianHost, getgenv().ZaxianDiscord = key, HOST, "https://discord.gg/PGSBJcuCd"
        gui:Destroy()
        local f, e = loadstring(body)
        if f then task.spawn(f) else warn("Zaxian: " .. tostring(e)) end
        return
    end
    busy, btn.Text = false, "Masuk"
end
btn.MouseButton1Click:Connect(go)
input.FocusLost:Connect(function(enter) if enter then go() end end)
if #input.Text >= 10 then go() end
