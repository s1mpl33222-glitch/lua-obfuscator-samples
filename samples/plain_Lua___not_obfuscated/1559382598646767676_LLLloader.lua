-- IIIIIIIIII-HUB
-- Detecta el dispositivo y carga la edicion correspondiente.

local UIS = game:GetService("UserInputService")

if not game:GetService("RunService"):IsClient() then
    warn("IIIIIIIIII-HUB: this loader need to execute in client")
    return
end

local SCRIPT_URLS = {
    Mobile = "https://api.jnkie.com/api/v1/luascripts/public/ffe564b4000729161d1ee74d43a701c4a99ca8a14ecb6bf1e8dd591ab7d0886e/download",
    PC = "https://api.jnkie.com/api/v1/luascripts/public/c0d7433e85dd6105ffeac56e4bfc586be4323e120bda5d21ad6f39b9f5a2882c/download",
}

local function isMobileDevice()
    -- Touch-only es movil; un PC tactil conserva teclado o mouse y va por la edicion PC.
    return UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
end

local function fetchScript(url)
    local body
    local requestError

    local ok = pcall(function()
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and type(result) == "string" and result ~= "" then
            body = result
            return
        end

        local requestFunction = syn and syn.request or http_request or request
        if requestFunction then
            local response = requestFunction({Url = url, Method = "GET"})
            if response and response.Body then
                body = response.Body
                return
            end
        end

        requestError = result or "Return nil"
    end)

    if not ok or type(body) ~= "string" or body == "" then
        error("Could not download the UI from" .. url .. ": " .. tostring(requestError or "error desconocido"))
    end

    if type(loadstring) ~= "function" then
        error("This executor does not support loadstring.")
    end

    local chunk, compileError = loadstring(body)
    if not chunk then
        error("The downloaded UI has a compilation error:" .. tostring(compileError))
    end

    return chunk
end

local device = isMobileDevice() and "Mobile" or "PC"
local url = SCRIPT_URLS[device]

print("[IIIIIIIIII-HUB] Device detected:" .. device)

local ok, runtimeError = pcall(function()
    fetchScript(url)()
end)

if not ok then
    warn("[IIIIIIIIII-HUB] Could not load the edition " .. device .. ": " .. tostring(runtimeError))
end
