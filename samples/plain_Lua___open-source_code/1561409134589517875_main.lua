local AUTH_URL = "https://cloverhub.fun"

local HWID = nil
pcall(function() HWID = gethwid and gethwid() end)
if not HWID then
    pcall(function() HWID = syn and syn.get_hwid and syn.get_hwid() end)
end
if not HWID then
    pcall(function() HWID = game:GetService("RbxAnalyticsService"):GetClientId() end)
end
HWID = HWID or "unknown"

local SECRET_KEY = nil
pcall(function()
    SECRET_KEY = game:HttpGet(AUTH_URL .. "/api/internal-key")
end)
if not SECRET_KEY or SECRET_KEY == "" then
    SECRET_KEY = "c_auth_77a2"
end

local Lib = nil
pcall(function()
    Lib = loadstring(game:HttpGet(AUTH_URL .. "/api/script/cloverlib?key=" .. SECRET_KEY))()
end)

if not Lib then
    warn("[CLOVER] Failed to load CloverLib.")
    return
end

local Window = Lib.newWindow("CloverHUB", Vector2.new(480, 360), nil, nil, false, false)
local Tab = Window:addTab("Authentication", { sidebar = false })
local Sub = Tab:addSubTab("Access Gateway")

if Window.sidebar then Window.sidebar.Visible = false end
if Window.sidebarEdge then Window.sidebarEdge.Visible = false end
if Window.content then
    Window.content.Position = UDim2.new(0, 5, 0, 46)
    Window.content.Size = UDim2.new(1, -10, 1, -92)
end

local Group = Sub:addGroup("License Verification")

local savedKey = ""
pcall(function()
    if isfolder and isfolder("CloverHub") and isfile and isfile("CloverHub/Key.txt") then
        savedKey = readfile("CloverHub/Key.txt")
    end
end)

local userKey = _G.Key or _G.CloverKey
local activeKey = (userKey and userKey ~= "") and userKey or savedKey

if activeKey ~= "" then
    _G.Key = activeKey
    _G.CloverKey = activeKey
end

local KeyInput = Group:textbox("License Key", activeKey, "CLOVER-XXXX", function(v)
    _G.Key = v
    _G.CloverKey = v
    if writefile and isfolder then
        if not isfolder("CloverHub") then makefolder("CloverHub") end
        writefile("CloverHub/Key.txt", v)
    end
end)

local function notify(msg, ntype)
    if Window and Window.notify then
        Window:notify(msg, ntype)
    end
end

local function validate(key)
    if not key or key == "" then
        return notify("Please enter a key first!", "error")
    end

    notify("Authenticating...", "info")

    local function sendRequest()
        local safeKey = tostring(key or _G.CloverKey or "")
        local safeHWID = tostring(HWID or "")
        
        local payload = game:GetService("HttpService"):JSONEncode({
            key = safeKey,
            hwid = safeHWID,
            gameId = tonumber(game.GameId) or 0,
            placeId = tonumber(game.PlaceId) or 0
        })

        local req = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request
        if req then
            local success, res = pcall(function()
                return req({
                    Url = AUTH_URL .. "/api/validate",
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = payload
                })
            end)
            if success and res and res.Body and res.Body ~= "" then return true, res.Body end
            if success and res then return false, "Empty response" end
        end

        local fbOk, fbBody = pcall(function()
            return game:GetService("HttpService"):PostAsync(AUTH_URL .. "/api/validate", payload, Enum.HttpContentType.ApplicationJson)
        end)
        if fbOk and fbBody then return true, fbBody end
        return false, "Request failed"
    end

    local success, response = sendRequest()

    if success then
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(response) end)
        if ok and data.success then
            local tierMap = { standard = "Standard", boost = "Boost", premium = "Premium", beta = "Beta", admin = "Admin" }
            Window:setTier(tierMap[data.keyType] or "Standard")
            local keyType = data.keyType or "standard"
            _G.CloverKeyType = keyType
            _G.CloverKeyExpires = data.expiresAt

            local function runHub(scriptData)
                if not scriptData then notify("Server Error: Missing script payload.", "error"); return end
                local s, err = pcall(function()
                    local function b64d(data)
                        local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
                        data = string.gsub(data, '[^'..b..'=]', '')
                        return (data:gsub('.', function(x)
                            if (x == '=') then return '' end
                            local r,f='',(b:find(x)-1)
                            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
                            return r;
                        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
                            if (#x ~= 8) then return '' end
                            local c=0
                            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
                            return string.char(c)
                        end))
                    end
                    local decoded = (base64_decode or (crypt and crypt.base64decode) or (syn and syn.crypt.base64.decode) or b64d)(scriptData)
                    local result = {}
                    local keyLen = #key
                    local bxor = bit and bit.bxor or bit32 and bit32.bxor
                    for i = 1, #decoded do
                        local dataByte = string.byte(decoded, i)
                        local keyByte = string.byte(key, ((i - 1) % keyLen) + 1)
                        table.insert(result, string.char(bxor(dataByte, keyByte)))
                    end
                    local decrypted = table.concat(result)
                    local func, loadErr = loadstring(decrypted)
                    if not func then error("Failed to load decrypted script: " .. tostring(loadErr)) end
                    func()
                end)
                if not s then warn("[CLOVER] " .. tostring(err)) end
            end

            notify("Access Granted! Loading...", "success")
            task.wait(0.5)
            Window:Destroy()
            runHub(data.script)
        else
            notify(data and data.message or "Invalid Key or Session", "error")
        end
    else
        notify(response or "Connection Failed. Check your internet.", "error")
    end
end

Group:button("Login", function()
    local key = _G.Key or _G.CloverKey or KeyInput.Value or ""
    validate(key)
end, "Submit your license and join", Enum.TextXAlignment.Center, nil, "bg", Color3.fromRGB(10, 10, 10))

Group:button("Get Key", function()
    setclipboard(AUTH_URL)
    notify("Auth URL copied to clipboard!", "success")
end, "Copies link to key dashboard", Enum.TextXAlignment.Center, Color3.fromRGB(50, 150, 255), "bg", Color3.fromRGB(10, 10, 10))

Group:separator()

Group:button("Discord", function()
    setclipboard("https://discord.gg/ffhBhvncmQ")
    notify("Discord link copied!", "success")
end, nil, Enum.TextXAlignment.Center, Color3.fromRGB(88, 101, 242), "text")
Group:button("Close Hub", function()
    Window:Destroy()
end, nil, Enum.TextXAlignment.Center, Color3.fromRGB(255, 100, 100), "text")

if activeKey ~= "" then
    task.delay(0.5, function()
        validate(activeKey)
    end)
end
