local env = (type(getgenv) == "function" and getgenv()) or _G
env.SwagUserEspGen = (tonumber(env.SwagUserEspGen) or 0) + 1
local espGen = env.SwagUserEspGen

local ESP_URL = "https://swagfinder.net/api/script/esp"
local ROSTER_URL = "https://swagfinder.net/api/relay/users"
local QUEUE_SOURCE = [=[
task.spawn(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    local url = "https://swagfinder.net/api/script/esp"
    local src
    for _ = 1, 5 do
        pcall(function()
            src = game:HttpGet(url)
        end)
        if type(src) == "string" and string.find(src, "SwagUserEspGen", 1, true) then
            break
        end
        src = nil
        task.wait(0.4)
    end
    if type(src) ~= "string" then
        return
    end
    local loader = loadstring or load
    if type(loader) ~= "function" then
        return
    end
    local ok, fn = pcall(loader, src)
    if ok and type(fn) == "function" then
        task.spawn(fn)
    end
end)
]=]

local function exploitFn(name)
    if type(getgenv) == "function" then
        local genv = getgenv()
        if type(genv) == "table" and type(genv[name]) == "function" then
            return genv[name]
        end
    end
    if type(getfenv) == "function" then
        local ok, value = pcall(function()
            return getfenv()[name]
        end)
        if ok and type(value) == "function" then
            return value
        end
    end
    local value = rawget(_G, name)
    if type(value) == "function" then
        return value
    end
    return nil
end

local function queueSwagEsp()
    local queue = exploitFn("queue_on_teleport") or exploitFn("queueonteleport")
    if type(queue) ~= "function" then
        local syn = rawget(_G, "syn")
        if type(syn) == "table" then
            queue = syn.queue_on_teleport
        end
    end
    if type(queue) ~= "function" then
        local fluxus = rawget(_G, "fluxus")
        if type(fluxus) == "table" then
            queue = fluxus.queue_on_teleport
        end
    end
    if type(queue) ~= "function" then
        return
    end
    if env.SwagEspArmed == game.JobId then
        return
    end
    if pcall(queue, QUEUE_SOURCE) then
        env.SwagEspArmed = game.JobId
    end
end

queueSwagEsp()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local ACCENT = Color3.fromRGB(178, 255, 64)
local names = {}
local drawn = {}

local host
local function espHost()
    if host and host.Parent then
        return host
    end
    local parent
    pcall(function()
        local getui = rawget(_G, "gethui")
        if type(getui) == "function" then
            parent = getui()
        end
    end)
    if typeof(parent) ~= "Instance" then
        pcall(function()
            parent = game:GetService("CoreGui")
        end)
    end
    if typeof(parent) ~= "Instance" then
        parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    end
    local folder = Instance.new("Folder")
    folder.Name = "SwagUserEspHost"
    folder.Parent = parent
    host = folder
    return folder
end

local function alive()
    return env.SwagUserEspGen == espGen
end

env.SwagUserEspDrawing = true

local function clearEsp(player)
    local record = drawn[player]
    if not record then
        return
    end
    drawn[player] = nil
    pcall(function()
        if record.highlight then
            record.highlight:Destroy()
        end
    end)
    pcall(function()
        if record.billboard then
            record.billboard:Destroy()
        end
    end)
end

local function clearAll()
    for player in pairs(drawn) do
        clearEsp(player)
    end
end

local function attachEsp(player)
    local character = player.Character
    if not character then
        return
    end
    local head = character:FindFirstChild("Head") or character:FindFirstChildWhichIsA("BasePart")
    if not head then
        return
    end
    local current = drawn[player]
    if current and current.highlight and current.highlight.Parent and current.highlight.Adornee == character and current.billboard and current.billboard.Parent then
        return
    end
    clearEsp(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "SwagUserEsp"
    highlight.Adornee = character
    highlight.FillColor = ACCENT
    highlight.OutlineColor = ACCENT
    highlight.FillTransparency = 0.62
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = espHost()
    local width = math.clamp(28 + (#player.Name * 7), 156, 240)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SwagUserEsp"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 10000
    billboard.Size = UDim2.fromOffset(width, 42)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.Parent = espHost()
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    card.Size = UDim2.fromScale(1, 1)
    card.Parent = billboard
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    local stroke = Instance.new("UIStroke")
    stroke.Color = ACCENT
    stroke.Thickness = 1
    stroke.Transparency = 0.35
    stroke.Parent = card
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(0, 3)
    title.Size = UDim2.new(1, 0, 0, 14)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextColor3 = ACCENT
    title.Text = "swag finder user"
    title.Parent = card
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(8, 18)
    nameLabel.Size = UDim2.new(1, -16, 0, 18)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    nameLabel.Text = player.Name
    nameLabel.Parent = card
    drawn[player] = { highlight = highlight, billboard = billboard }
end

local function addName(value)
    local name = string.lower(tostring(value or ""))
    if name ~= "" then
        names[name] = true
    end
end

local function readRoster(list)
    if type(list) ~= "table" then
        return
    end
    for _, user in ipairs(list) do
        if type(user) == "table" then
            addName(user.username)
        else
            addName(user)
        end
    end
end

local function httpGet(url)
    local function usable(value)
        if type(value) == "string" and string.sub(value, 1, 1) == "{" then
            return value
        end
        return nil
    end
    if type(game.HttpGet) == "function" then
        local ok, result = pcall(game.HttpGet, game, url)
        local body = ok and usable(result)
        if body then
            return body
        end
    end
    local plain = rawget(_G, "HttpGet") or rawget(_G, "httpget")
    if type(plain) == "function" then
        local ok, result = pcall(plain, url)
        local body = ok and usable(result)
        if body then
            return body
        end
    end
    local request = rawget(_G, "request") or rawget(_G, "http_request")
    if type(request) ~= "function" then
        local syn = rawget(_G, "syn")
        if type(syn) == "table" then
            request = syn.request
        end
    end
    if type(request) ~= "function" then
        local http = rawget(_G, "http")
        if type(http) == "table" then
            request = http.request
        end
    end
    if type(request) == "function" then
        local ok, response = pcall(request, { Url = url, Method = "GET" })
        if ok and type(response) == "table" then
            return usable(response.Body or response.body)
        end
    end
    return nil
end

local function fetchRoster()
    local body = httpGet(ROSTER_URL)
    if type(body) ~= "string" then
        return
    end
    local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body)
    if not ok or type(decoded) ~= "table" then
        return
    end
    local nextNames = {}
    local previous = names
    names = nextNames
    local function add(value)
        local name = string.lower(tostring(value or ""))
        if name ~= "" then
            names[name] = true
        end
    end
    local function read(list)
        if type(list) ~= "table" then
            return
        end
        for _, user in ipairs(list) do
            if type(user) == "table" then
                add(user.username)
            else
                add(user)
            end
        end
    end
    read(decoded.users)
    read(decoded.esp)
    if next(names) == nil then
        names = previous
    end
end

local function isSwag(player)
    local username = string.lower(player.Name)
    local display = string.lower(player.DisplayName or "")
    return names[username] or (display ~= "" and names[display])
end

local function refreshEsp()
    if not alive() then
        clearAll()
        return
    end
    local seen = {}
    for _, player in ipairs(Players:GetPlayers()) do
        seen[player] = true
        if player ~= LocalPlayer and isSwag(player) then
            pcall(attachEsp, player)
        else
            clearEsp(player)
        end
    end
    for player in pairs(drawn) do
        if not seen[player] then
            clearEsp(player)
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    clearEsp(player)
end)

task.spawn(function()
    while alive() do
        pcall(fetchRoster)
        pcall(refreshEsp)
        task.wait(5)
    end
    clearAll()
end)

task.spawn(function()
    while alive() do
        pcall(refreshEsp)
        task.wait(1)
    end
    clearAll()
end)
