-- GSX PROTECTOR | Entrega autenticada v1.8
local function fail(message)
    local text = "GSX PROTECTOR: " .. tostring(message)
    warn(text)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="GSX PROTECTOR", Text=text, Duration=12}) end)
    error(text, 0)
end
local contextOk, players, workspaceService = pcall(function()
    return game:GetService("Players"), game:GetService("Workspace")
end)
if not contextOk or not players or not players.LocalPlayer or not workspaceService then
    fail("execute no cliente Roblox com o jogador carregado.")
end
local requestFn = request or http_request or (syn and syn.request) or (http and http.request)
if type(requestFn) ~= "function" then fail("executor sem funcao request HTTP compativel.") end
local function send(options, stage)
    local ok, response = pcall(requestFn, options)
    if not ok then fail(stage .. ": falha de rede: " .. tostring(response)) end
    if type(response) ~= "table" then fail(stage .. ": resposta HTTP invalida.") end
    local status = tonumber(response.StatusCode or response.Status or response.status_code)
    if status ~= 200 then
        local headers = response.Headers or response.headers or {}
        local reason = "Consulte a ocorrencia no painel."
        if type(headers) == "table" then
            for name, value in pairs(headers) do
                if string.lower(tostring(name)) == "x-gsx-reason" then reason = tostring(value) end
            end
        end
        fail(stage .. ": HTTP " .. tostring(status or "desconhecido") .. ". " .. reason)
    end
    local body = response.Body or response.body
    if type(body) ~= "string" or body == "" then fail(stage .. ": resposta vazia.") end
    return body
end
local handshake = send({Url="https://gsx-protector.guizinz-creator-scripts.workers.dev/kE-_CKoV5lZv7p8G4WqWsw/session", Method="POST", Headers={Authorization="Bearer kE-_CKoV5lZv7p8G4WqWsw", Accept="application/json"}, Body=""}, "Autenticacao")
local ok, session = pcall(function() return game:GetService("HttpService"):JSONDecode(handshake) end)
if not ok or type(session) ~= "table" or type(session.token) ~= "string" then fail("resposta de autenticacao invalida.") end
local source = send({Url="https://gsx-protector.guizinz-creator-scripts.workers.dev/kE-_CKoV5lZv7p8G4WqWsw/payload", Method="GET", Headers={Authorization="Bearer " .. session.token, Accept="text/plain"}}, "Entrega")
local fn, err = loadstring(source)
if not fn then fail("erro ao carregar seu script: " .. tostring(err)) end
return fn()
