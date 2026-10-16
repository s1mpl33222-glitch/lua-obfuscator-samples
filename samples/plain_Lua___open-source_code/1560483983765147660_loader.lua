local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local CONFIG = {
    BACKEND_URL = "https://lua-hub-api.val.run",
    INSTALL_KEY = "inst_4b8e1a7d92c63f05ab71",
    OBSIDIAN_REPO = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/",
    NOTIFY_DURATION = 6,
    REFRESH_MARGIN = 900,
    UA = "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36",
}

local TOTAL_STEPS = 4

local NotifyState = { Library = nil, Gui = nil, Container = nil }

local function sessionStore()
    local env = getgenv and getgenv() or _G

    if type(env.__LUA_HUB_SESSION) ~= "table" then
        env.__LUA_HUB_SESSION = { token = nil, expiresAt = 0 }
    end

    return env.__LUA_HUB_SESSION
end

local function clearSession()
    local store = sessionStore()
    store.token = nil
    store.expiresAt = 0
end

local function ensureFallbackGui()
    if NotifyState.Gui and NotifyState.Gui.Parent then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LuaHubNotify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999999

    local ok = pcall(function()
        gui.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
    end)

    if not ok then
        gui.Parent = player:WaitForChild("PlayerGui")
    end

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.BackgroundTransparency = 1
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, -16, 0, 16)
    container.Size = UDim2.new(0, 320, 1, -32)
    container.Parent = gui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Parent = container

    NotifyState.Gui = gui
    NotifyState.Container = container
end

local function fallbackNotify(title, message, duration)
    ensureFallbackGui()

    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.ClipsDescendants = true
    card.BackgroundTransparency = 1

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(220, 60, 60)
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    stroke.Parent = card

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = tostring(title)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Parent = card

    local msgLabel = Instance.new("TextLabel")
    msgLabel.BackgroundTransparency = 1
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Text = tostring(message)
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
    msgLabel.TextSize = 12
    msgLabel.TextWrapped = true
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Position = UDim2.new(0, 0, 0, 20)
    msgLabel.Size = UDim2.new(1, 0, 0, 0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.Parent = card

    card.Parent = NotifyState.Container

    TweenService:Create(card, TweenInfo.new(0.25), {
        BackgroundTransparency = 0,
    }):Play()

    task.delay(math.max(1, tonumber(duration) or CONFIG.NOTIFY_DURATION), function()
        if not card.Parent then
            return
        end

        local tween = TweenService:Create(card, TweenInfo.new(0.25), {
            BackgroundTransparency = 1,
        })
        tween:Play()
        tween.Completed:Connect(function()
            card:Destroy()
        end)
    end)
end

local function notify(title, message, duration)
    local Library = NotifyState.Library

    if Library and type(Library.Notify) == "function" then
        local ok = pcall(function()
            Library:Notify({
                Title = tostring(title),
                Description = tostring(message),
                Duration = tonumber(duration) or CONFIG.NOTIFY_DURATION,
            })
        end)

        if ok then
            return
        end
    end

    fallbackNotify(title, message, duration)
end

local function notifyError(message, duration)
    notify("Lua Hub", message, duration)
end

local function urlEncode(value)
    local ok, encoded = pcall(function()
        return HttpService:UrlEncode(tostring(value))
    end)

    if ok and type(encoded) == "string" then
        return encoded
    end

    return tostring(value):gsub("[^%w%-%_%.%~]", function(char)
        return string.format("%%%02X", string.byte(char))
    end)
end

local function getRequestFunction()
    if type(getgenv) == "function" then
        local success, env = pcall(getgenv)

        if success and type(env) == "table" then
            if type(env.request) == "function" then
                return env.request
            end

            if type(env.http_request) == "function" then
                return env.http_request
            end
        end
    end

    if type(request) == "function" then
        return request
    end

    if type(http_request) == "function" then
        return http_request
    end

    return nil
end

local function getCompiler()
    if type(loadstring) == "function" then
        return loadstring
    end

    if type(getgenv) == "function" then
        local success, env = pcall(getgenv)

        if success and type(env) == "table" and type(env.loadstring) == "function" then
            return env.loadstring
        end
    end

    return nil
end

local function withUserAgent(headers)
    local merged = {}

    for key, value in pairs(headers or {}) do
        merged[key] = value
    end

    merged["User-Agent"] = merged["User-Agent"] or CONFIG.UA

    return merged
end

local function executorRequest(options)
    local requestFunction = getRequestFunction()

    if not requestFunction then
        return nil, nil, "executor sem request()"
    end

    local success, response = pcall(function()
        return requestFunction(options)
    end)

    if not success then
        return nil, nil, "request() lancou erro"
    end

    if type(response) ~= "table" then
        if type(response) == "string" and #response > 0 then
            return response, 200, nil, nil
        end

        return nil, nil, "request() devolveu " .. type(response)
    end

    local status = tonumber(
        response.StatusCode
        or response.Status
        or response.status
    ) or 0

    local body = response.Body or response.body

    if type(body) ~= "string" then
        body = body ~= nil and tostring(body) or ""
    end

    local headers = response.Headers or response.headers

    if type(headers) ~= "table" then
        headers = nil
    end

    return body, status, nil, headers
end

local function robloxGet(url)
    local separator = url:find("?", 1, true) and "&" or "?"
    local busted = url .. separator .. "_=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))

    local ok, response = pcall(function()
        return game:HttpGet(busted, true)
    end)

    if ok and type(response) == "string" and #response > 0 then
        return response
    end

    return nil, "game:HttpGet falhou"
end

local function parseJson(body)
    if type(body) ~= "string" or #body == 0 then
        return nil
    end

    local success, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if success and type(data) == "table" then
        return data
    end

    return nil
end

local function describeFailure(body, status, err)
    if status and status >= 400 then
        return "HTTP " .. tostring(status)
    end

    if type(body) == "string" and #body > 0 then
        local head = body:sub(1, 256):lower()

        if head:find("<html", 1, true) or head:find("<!doctype", 1, true) then
            return "resposta HTML (proxy/bloqueio)"
        end

        return "resposta nao-JSON"
    end

    return tostring(err or "sem resposta")
end

local function isChallenge(body)
    if type(body) ~= "string" then
        return false
    end

    local head = body:sub(1, 256):lower()

    return head:find("<html", 1, true) ~= nil or head:find("<!doctype", 1, true) ~= nil
end

local function isErrorBody(body)
    if type(body) ~= "string" or #body == 0 then
        return false
    end

    local data = parseJson(body)

    return type(data) == "table" and data.success == false
end

local function isScriptBody(body)
    if type(body) ~= "string" or #body == 0 then
        return false
    end

    if isChallenge(body) or isErrorBody(body) then
        return false
    end

    return true
end

local function headerValue(headers, name)
    if type(headers) ~= "table" then
        return nil
    end

    local wanted = name:lower()

    for key, value in pairs(headers) do
        if tostring(key):lower() == wanted then
            return tostring(value)
        end
    end

    return nil
end

local function apiRequest(method, path, headers, query)
    local url = CONFIG.BACKEND_URL .. path
    local lastBody, lastStatus, lastError

    if next(headers or {}) ~= nil then
        local body, status, err = executorRequest({
            Url = url,
            Method = method,
            Headers = withUserAgent(headers),
        })

        local data = parseJson(body)

        if data then
            return data, status, "header"
        end

        lastBody, lastStatus, lastError = body, status, err
    end

    if query and #query > 0 then
        local withQuery = url .. (url:find("?", 1, true) and "&" or "?") .. query
        local body, status, err = executorRequest({
            Url = withQuery,
            Method = method,
            Headers = withUserAgent(nil),
        })

        local data = parseJson(body)

        if data then
            return data, status, "query"
        end

        lastBody, lastStatus, lastError = body, status, err

        local robloxBody, robloxError = robloxGet(withQuery)
        local robloxData = parseJson(robloxBody)

        if robloxData then
            return robloxData, 200, "HttpGet"
        end

        lastBody = lastBody or robloxBody
        lastError = lastError or robloxError
    end

    return nil, describeFailure(lastBody, lastStatus, lastError)
end

local function authenticate()
    local data, status, transport = apiRequest(
        "POST",
        "/auth/session",
        { ["x-install-key"] = CONFIG.INSTALL_KEY },
        "key=" .. urlEncode(CONFIG.INSTALL_KEY)
    )

    if not data then
        return nil, "Falha ao autenticar (" .. tostring(status) .. ")"
    end

    if data.success ~= true or type(data.token) ~= "string" or #data.token == 0 then
        return nil, "Backend recusou a autenticacao (" .. tostring(status) .. ")"
    end

    local store = sessionStore()
    store.token = data.token
    store.expiresAt = os.time() + (tonumber(data.expiresIn) or 0)

    return data.token, nil, transport
end

local function refresh()
    local store = sessionStore()

    if type(store.token) ~= "string" or #store.token == 0 then
        return nil
    end

    local data = apiRequest(
        "POST",
        "/auth/refresh",
        { ["Authorization"] = "Bearer " .. store.token },
        "token=" .. urlEncode(store.token)
    )

    if data and data.success == true and type(data.token) == "string" then
        store.token = data.token
        store.expiresAt = os.time() + (tonumber(data.expiresIn) or 0)
        return data.token
    end

    clearSession()
    return nil
end

local function ensureSession(force)
    local store = sessionStore()
    local now = os.time()

    if not force and type(store.token) == "string" and #store.token > 0 then
        if store.expiresAt - now > CONFIG.REFRESH_MARGIN then
            return store.token, nil, "cache"
        end

        if store.expiresAt > now then
            local rotated = refresh()

            if rotated then
                return rotated, nil, "refresh"
            end
        end
    end

    clearSession()
    return authenticate()
end

local function fetchScriptText(placeId, token)
    local base = "/raw?placeId=" .. urlEncode(placeId)
    local lastReason = "sem resposta"

    do
        local body, status, err, headers = executorRequest({
            Url = CONFIG.BACKEND_URL .. base,
            Method = "GET",
            Headers = withUserAgent({ ["Authorization"] = "Bearer " .. token }),
        })

        if isScriptBody(body) then
            return body, headerValue(headers, "X-Place-Name"), "request+bearer"
        end

        lastReason = describeFailure(body, status, err)
    end

    do
        local body, status, err, headers = executorRequest({
            Url = CONFIG.BACKEND_URL .. base .. "&token=" .. urlEncode(token),
            Method = "GET",
            Headers = withUserAgent(nil),
        })

        if isScriptBody(body) then
            return body, headerValue(headers, "X-Place-Name"), "request+query"
        end

        lastReason = describeFailure(body, status, err)
    end

    do
        local body, err = robloxGet(CONFIG.BACKEND_URL .. base .. "&token=" .. urlEncode(token))

        if isScriptBody(body) then
            return body, nil, "HttpGet+query"
        end

        lastReason = describeFailure(body, nil, err)
    end

    return nil, nil, lastReason
end

local function getGameData(placeId)
    local token, authError = ensureSession(false)

    if not token then
        return nil, authError
    end

    local content, name, transport = fetchScriptText(placeId, token)

    if not content then
        task.wait(1.5)

        local freshToken = ensureSession(true) or token
        content, name, transport = fetchScriptText(placeId, freshToken)
    end

    if not content then
        local freshToken = ensureSession(false) or token

        local data, _status, jsonTransport = apiRequest(
            "GET",
            "/script",
            { ["Authorization"] = "Bearer " .. freshToken },
            "placeId=" .. urlEncode(placeId) .. "&token=" .. urlEncode(freshToken)
        )

        if data and data.allowed == true and type(data.content) == "string" and #data.content > 0 then
            return {
                name = type(data.name) == "string" and data.name or ("PlaceId " .. placeId),
                content = data.content,
                bytes = data.bytes,
            }, nil, tostring(jsonTransport) .. "+json"
        end

        return nil, "Falha ao falar com o backend (" .. tostring(transport) .. ")"
    end

    return {
        name = name or ("PlaceId " .. placeId),
        content = content,
        bytes = #content,
    }, nil, transport
end

local function loadObsidian()
    local url = CONFIG.OBSIDIAN_REPO .. "Library.lua"

    local body = executorRequest({
        Url = url,
        Method = "GET",
        Headers = withUserAgent(nil),
    })

    if type(body) ~= "string" or #body == 0 then
        body = robloxGet(url)
    end

    if type(body) ~= "string" or #body == 0 then
        return nil, "download falhou"
    end

    local compiler = getCompiler()

    if not compiler then
        return nil, "executor sem loadstring"
    end

    local chunk, compileError = compiler(body)

    if not chunk then
        return nil, "compilar: " .. tostring(compileError)
    end

    local success, library = pcall(chunk)

    if not success or type(library) ~= "table" then
        return nil, "inicializar: " .. tostring(library)
    end

    return library
end

local function main()
    local placeId = tostring(game.PlaceId)

    local compiler = getCompiler()

    if not compiler then
        notifyError("Executor sem loadstring.")
        return
    end

    local Library = loadObsidian()

    if Library then
        NotifyState.Library = Library
    end

    local Loading

    if Library then
        local ok, instance = pcall(function()
            return Library:CreateLoading({
                Title = "Lua Hub",
                Icon = 95816097006870,
                TotalSteps = TOTAL_STEPS,
            })
        end)

        if ok then
            Loading = instance
        end
    end

    local function setStep(step)
        if Loading then
            pcall(function()
                Loading:SetCurrentStep(step)
            end)
        end
    end

    local function addLabel(text)
        if Loading then
            pcall(function()
                Loading.Sidebar:AddLabel(text)
            end)
        end
    end

    local function cleanup()
        if Loading then
            pcall(function()
                Loading:Destroy()
            end)
        end
    end

    local function fail(message)
        notifyError(message)

        if Loading then
            pcall(function()
                Loading:ShowErrorPage(true)
                Loading:SetErrorMessage(tostring(message))
            end)
        end
    end

    setStep(1)

    if Loading then
        pcall(function()
            Loading:ShowSidebarPage(true)
            Loading.Sidebar:AddLabel("Usuario: " .. player.Name)
            Loading.Sidebar:AddLabel("PlaceId: " .. placeId)
        end)
    end

    setStep(2)

    print("[Lua Hub] ambiente -> request:", type(request), "| http_request:", type(http_request), "| HttpGet:", type(game.HttpGet), "| loadstring:", type(getCompiler()))

    local token, authError, transport = ensureSession(false)

    if not token then
        print("[Lua Hub] FALHA NA AUTENTICACAO:", tostring(authError))
        fail(authError or "Falha ao autenticar no backend.")
        return
    end

    print("[Lua Hub] autenticado via", tostring(transport))
    addLabel("Sessao autorizada (" .. tostring(transport) .. ")")

    setStep(3)

    local gameData, backendError, scriptTransport = getGameData(placeId)

    if not gameData then
        print("[Lua Hub] FALHA NO SCRIPT:", tostring(backendError))
        fail(backendError or "Falha ao contatar o backend.")
        return
    end

    print("[Lua Hub] script via", tostring(scriptTransport), "|", tostring(gameData.bytes), "bytes")

    addLabel("Jogo: " .. gameData.name)
    addLabel("Transporte: " .. tostring(scriptTransport))

    setStep(4)
    task.wait(0.2)

    local chunk, compileError = compiler(gameData.content)

    if not chunk then
        fail("Erro ao compilar o script: " .. tostring(compileError))
        return
    end

    cleanup()

    local executed, execError = pcall(chunk)

    if not executed then
        notifyError("Erro ao executar o script: " .. tostring(execError))
    end
end

task.spawn(function()
    local success, err = pcall(main)

    if not success then
        notifyError("Erro inesperado: " .. tostring(err))
    end
end)
