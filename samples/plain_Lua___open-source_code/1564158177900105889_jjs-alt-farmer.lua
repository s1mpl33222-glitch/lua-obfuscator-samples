-- RX GUARDIAN :: loader for jjs-alt-farmer
 -- keyless script — no key required, runs as-is
-- usage: loadstring(game:HttpGet("https://script-gatekeeper.redace069.workers.dev/api/load/jjs-alt-farmer"))()
 -- 0e1d38f5-7b3c-43c3-8a19-9ee76eaa1a119811b5a5

local v025ad579e = game:GetService("HttpService")
local vedb32bd82 = game:GetService("Players")
local v136589655 = game:GetService("MarketplaceService")

local v26e425ad1 = (syn and syn.request) or (http and http.request) or request or http_request
if not v26e425ad1 then
    return error("[RX Guardian] Environment does not support HTTP requests.")
end

 -- 8aff4b0c-0d53-4972-bfac-44365f661c01f19854ab

local vd6a2f2923 = "https://script-gatekeeper.redace069.workers.dev"
local v9ccf61866 = "jjs-alt-farmer"
local ve2908334d = vedb32bd82.LocalPlayer
local va9861e699 = (gethwid and gethwid()) or ("UID-" .. tostring(ve2908334d.UserId))

 -- 0138f697-7c60-4525-9b24-7a490c2a6c4c8d6ae59f

-- game identity: game.Name is the internal PLACE name (often arbitrary),
-- so report placeId + universeId and try the marketplace name for display
local va8ab6d7ed = game.PlaceId
local v656680b2d = game.GameId
local v717a699f2 = game.Name
local v23c1ce4b6 = nil
pcall(function()
    v23c1ce4b6 = v136589655:GetProductInfo(va8ab6d7ed)
end)
if type(v23c1ce4b6) == "table" and type(v23c1ce4b6.Name) == "string" and #v23c1ce4b6.Name > 0 then
    v717a699f2 = v23c1ce4b6.Name
end

local vc4b7a9a5a = {
    hwid = va9861e699,
    username = ve2908334d.Name,
    displayName = ve2908334d.DisplayName,
    userId = ve2908334d.UserId,
    gameId = v656680b2d,
    placeId = va8ab6d7ed,
    gameName = v717a699f2,
    jobId = game.JobId,
}

 -- dd42769e-e328-4a1c-bf70-e504dd12715e500e06d3

-- request helper with retry + backoff (network resilience)
local function vde31990f2(reqData, attempts)
    attempts = attempts or 3
    local lastErr = "no response"
    for i = 1, attempts do
        local ok, res = pcall(v26e425ad1, reqData)
        if ok and type(res) == "table" and res.StatusCode then
            return res
        end
        lastErr = tostring(res)
        if i < attempts then task.wait(0.5 * i) end
    end
    return { StatusCode = 0, Body = lastErr }
end

 -- 8f5c2810-7c69-4543-a286-3c895cb14a1057afc04d

local function v1ffb54baa(hexData, key)
    local keyBytes = { string.byte(key, 1, #key) }
    local keyLen = #keyBytes
    local bufferTable = {}
    local index = 1

    for hexByte in string.gmatch(hexData, "..") do
        local encryptedByte = tonumber(hexByte, 16)
        local keyByte = keyBytes[(index - 1) % keyLen + 1]
        table.insert(bufferTable, string.char(bit32.bxor(encryptedByte, keyByte)))
        index = index + 1
    end

    return table.concat(bufferTable)
end

 -- 5b6dfab1-e979-45fe-ade5-5cfb7f54a1d55a88e9a4
 
local v3b53e1d1e = vde31990f2({
    Url = vd6a2f2923 .. "/api/handshake",
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = v025ad579e:JSONEncode({
        key = "",
        hwid = va9861e699,
        scriptId = v9ccf61866,
        userInfo = vc4b7a9a5a,
    }),
})

if v3b53e1d1e.StatusCode ~= 200 then
    return warn("[RX Guardian] Auth failed (" .. tostring(v3b53e1d1e.StatusCode) .. "): " .. tostring(v3b53e1d1e.Body))
end

local vafcecc3d6 = v025ad579e:JSONDecode(v3b53e1d1e.Body)
local v404422028 = vafcecc3d6.token
local v52980f5fb = vafcecc3d6.xorKey

if not v404422028 or not v52980f5fb then
    return warn("[RX Guardian] Handshake response malformed — token or xorKey missing")
end

local vf3e961988 = vde31990f2({
    Url = vd6a2f2923 .. "/api/fetch-payload",
    Method = "POST",
    Headers = {
        ["Authorization"] = "Bearer " .. v404422028,
        ["X-HWID"] = va9861e699,
    },
})

if vf3e961988.StatusCode ~= 200 then
    return warn("[RX Guardian] Fetch failed (" .. tostring(vf3e961988.StatusCode) .. "): " .. tostring(vf3e961988.Body))
end

local v77af3545e = v1ffb54baa(vf3e961988.Body, v52980f5fb)

local ve73effa8f, v79a325fb8 = loadstring(v77af3545e)
if not ve73effa8f then
    return error("[RX Guardian] Execution error: " .. tostring(v79a325fb8))
end

print("[RX Guardian] access granted — executing payload")
 ve73effa8f()
 return function() end -- compat: old snippets with a trailing key argument still work
