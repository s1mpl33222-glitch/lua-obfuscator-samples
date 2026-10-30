local API = "https://orvynauth.shop"
local SCRIPT_ID = "52e10be6da4fc3a08cfb94ab1ecc1fb4"
local nativePcall = pcall

local function trim(text)
    return (string.gsub(tostring(text or ""), "^%s*(.-)%s*$", "%1"))
end

local function send(fn, url)
    if type(fn) ~= "function" then return nil end
    local ok, answer = nativePcall(fn, { Url = url, Method = "GET" })
    if ok and type(answer) == "table" then
        local body = answer.Body or answer.body
        if type(body) == "string" and #body > 0 then return body end
    end
    return nil
end

local function get(url)
    local body = nil
    nativePcall(function() body = game:HttpGet(url) end)
    if type(body) ~= "string" or #body == 0 then
        nativePcall(function() body = game:HttpGetAsync(url) end)
    end
    if type(body) ~= "string" or #body == 0 then
        local shared = (getgenv and getgenv()) or _G
        if type(shared) == "table" then body = send(shared.request, url) or send(shared.http_request, url) end
    end
    if type(body) ~= "string" or #body == 0 then body = send(syn and syn.request, url) end
    if type(body) ~= "string" or #body == 0 then body = send(fluxus and fluxus.request, url) end
    if type(body) ~= "string" or #body == 0 then body = send(http and http.request, url) end
    if type(body) == "string" and #body > 0 then return trim(body) end
    return nil
end

local function isTicket(text)
    return type(text) == "string" and #text == 32 and not text:find("[^0-9a-f]")
end

local ticket = get(API .. "/api/v1/n/" .. SCRIPT_ID)
if not isTicket(ticket) then ticket = get(API .. "/api/v1/n/" .. SCRIPT_ID) end
if not isTicket(ticket) then
    if warn then warn("[Orvyn] Could not reach Orvyn. Check your connection and run it again.") end
    return
end

local source = get(API .. "/api/v1/l/" .. SCRIPT_ID .. "?n=" .. ticket)
if type(source) ~= "string" or #source == 0 then
    if warn then warn("[Orvyn] The loader did not download. Run it again in a moment.") end
    return
end

if source:find("/api/v1/n/", 1, true) then
    if warn then warn("[Orvyn] Could not verify this connection. Run it again in a moment.") end
    return
end

local run = loadstring or load
local chunk, err = run(source)
if not chunk then
    if warn then warn("[Orvyn] " .. tostring(err)) end
    return
end
chunk()
