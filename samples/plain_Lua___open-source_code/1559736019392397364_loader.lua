_G.YSH_GAME = "loader"
_G.SNG_NONCE = "4fffb37c592b244e8d7640929e0dd4de447ce55b0a0ecdf0"
_G.SNG_POW_DIFF = 2
local function runVerifier()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer or not game.JobId or game.PlaceId == 0 or game.GameId == 0 then
        return
    end

    local originalPrint = print
    local observedLoadstring = loadstring
    local alreadyReported = false

    local SNG_API = "https://yisus-hub.vercel.app/api/script"

    local function safeString(value, maxLength)
        local text = tostring(value or "Unknown")
        text = text:gsub("[\r\n]", " ")
        return text:sub(1, maxLength or 180)
    end

    local function getRequestFunction()
        if type(request) == "function" then
            return request
        end
        if syn and type(syn.request) == "function" then
            return syn.request
        end
        if http and type(http.request) == "function" then
            return http.request
        end
        if fluxus and type(fluxus.request) == "function" then
            return fluxus.request
        end
        if type(_G.request) == "function" then
            return _G.request
        end
        if type(http_request) == "function" then
            return http_request
        end
        return nil
    end

    local function freezeAndKick(reason)
        if alreadyReported then
            return
        end
        alreadyReported = true

        task.spawn(function()
            while true do
                task.wait(0)
            end
        end)

        pcall(function()
            LocalPlayer:Kick("Security Error: " .. safeString(reason, 160))
        end)
    end

    local report
    local printGuard = function(...)
        local args = { ... }
        for _, value in ipairs(args) do
            if type(value) == "string" and string.find(value, "loadstring", 1, true) and string.find(value, "HttpGet", 1, true) then
                report("loadstring_dump_attempt")
                return
            end
        end
        return originalPrint(...)
    end

    print = printGuard

    local function checkLoadstringReplacement()
        if type(loadstring) ~= "function" then
            return "loadstring_missing"
        end

        if loadstring ~= observedLoadstring then
            return "loadstring_replaced_after_initialization"
        end

        local probeSource = "return 271828"
        local okCompile, compiled = pcall(loadstring, probeSource)
        if okCompile and type(compiled) == "function" then
            local okExecute, value = pcall(compiled)
            if not okExecute or value ~= 271828 then
                local isHooked = isfunctionhooked or ishooked
                if type(isHooked) == "function" then
                    local okHook, hooked = pcall(isHooked, loadstring)
                    if okHook and hooked then
                        return "loadstring_probe_failed"
                    end
                end
            end
        end

        return
    end

    local function checkTamper()
        local isHooked = isfunctionhooked or ishooked
        if type(isHooked) == "function" and type(observedLoadstring) == "function" then
            local ok, hooked = pcall(isHooked, observedLoadstring)
            if ok and hooked then
                return true
            end
        end
        return false
    end

    report = function(reason)
        freezeAndKick(reason)
    end

    local reason = checkLoadstringReplacement()
    if reason then
        report(reason)
        return
    end

    local tampered = checkTamper()
    if tampered then
        report("protected_function_hook_detected")
        return
    end

    if type(hookfunction) == "function" then
        local originalHookfunction = hookfunction
        hookfunction = function(fnToHook, replacement)
            if fnToHook == observedLoadstring or fnToHook == loadstring then
                report("loadstring_hook_attempt")
                return fnToHook
            end
            return originalHookfunction(fnToHook, replacement)
        end
    end

    task.spawn(function()
        while task.wait(5) do
            local periodicReason = checkLoadstringReplacement()
            if periodicReason then
                report(periodicReason)
                return
            end
            local periodicTampered = checkTamper()
            if periodicTampered then
                report("protected_function_hook_detected")
                return
            end
        end
    end)

    local function rrotate(x, n)
        return bit32.bor(bit32.rshift(x, n), bit32.lshift(x, 32 - n))
    end

    local function add32(a, b) return (a + b) % 0x100000000 end

    local K = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    }

    local function hashBytes(msg)
        local H = {
            0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
            0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
        }
        local bytes = {}
        for i = 1, #msg do bytes[i] = string.byte(msg, i) end
        local len = #bytes
        bytes[#bytes + 1] = 0x80
        while (#bytes % 64) ~= 56 do bytes[#bytes + 1] = 0 end
        local bits = len * 8
        for i = 1, 8 do bytes[#bytes + 1] = 0 end
        local n = #bytes
        local high = math.floor(bits / 0x100000000)
        local low = bits % 0x100000000
        bytes[n-7] = bit32.band(bit32.rshift(high, 24), 0xff)
        bytes[n-6] = bit32.band(bit32.rshift(high, 16), 0xff)
        bytes[n-5] = bit32.band(bit32.rshift(high, 8), 0xff)
        bytes[n-4] = bit32.band(high, 0xff)
        bytes[n-3] = bit32.band(bit32.rshift(low, 24), 0xff)
        bytes[n-2] = bit32.band(bit32.rshift(low, 16), 0xff)
        bytes[n-1] = bit32.band(bit32.rshift(low, 8), 0xff)
        bytes[n] = bit32.band(low, 0xff)

        for chunk = 1, #bytes, 64 do
            local W = {}
            for i = 0, 15 do
                local off = chunk + i * 4
                W[i] = bit32.bor(bit32.lshift(bytes[off], 24), bit32.bor(bit32.lshift(bytes[off+1], 16), bit32.bor(bit32.lshift(bytes[off+2], 8), bytes[off+3])))
            end
            for i = 16, 63 do
                local s0 = bit32.bxor(rrotate(W[i-15], 7), bit32.bxor(rrotate(W[i-15], 18), bit32.rshift(W[i-15], 3)))
                local s1 = bit32.bxor(rrotate(W[i-2], 17), bit32.bxor(rrotate(W[i-2], 19), bit32.rshift(W[i-2], 10)))
                W[i] = add32(add32(add32(W[i-16], s0), W[i-7]), s1)
            end
            local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
            for i = 0, 63 do
                local S1 = bit32.bxor(rrotate(e, 6), bit32.bxor(rrotate(e, 11), rrotate(e, 25)))
                local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
                local temp1 = add32(add32(add32(add32(h, S1), ch), K[i+1]), W[i])
                local S0 = bit32.bxor(rrotate(a, 2), bit32.bxor(rrotate(a, 13), rrotate(a, 22)))
                local maj = bit32.bxor(bit32.band(a, b), bit32.bxor(bit32.band(a, c), bit32.band(b, c)))
                local temp2 = add32(S0, maj)
                h = g; g = f; f = e; e = add32(d, temp1); d = c; c = b; b = a; a = add32(temp1, temp2)
            end
            H[1] = add32(H[1], a); H[2] = add32(H[2], b); H[3] = add32(H[3], c); H[4] = add32(H[4], d)
            H[5] = add32(H[5], e); H[6] = add32(H[6], f); H[7] = add32(H[7], g); H[8] = add32(H[8], h)
        end

        local out = {}
        for i = 1, 8 do
            out[#out+1] = bit32.band(bit32.rshift(H[i], 24), 0xff)
            out[#out+1] = bit32.band(bit32.rshift(H[i], 16), 0xff)
            out[#out+1] = bit32.band(bit32.rshift(H[i], 8), 0xff)
            out[#out+1] = bit32.band(H[i], 0xff)
        end
        local s = ""
        for i = 1, #out do s = s .. string.char(out[i]) end
        return s
    end

    local function bytesToHex(s)
        local hex = ""
        for i = 1, #s do hex = hex .. string.format("%02x", string.byte(s, i)) end
        return hex
    end

    local function sha256(msg)
        return bytesToHex(hashBytes(msg))
    end

    local function buildPowMessage(nonce, jobId, placeId, userId, gameId, counter)
        return nonce .. jobId .. tostring(placeId) .. tostring(userId) .. tostring(gameId) .. tostring(counter)
    end

    local function findProof(nonce, jobId, placeId, userId, gameId, difficulty)
        local powDiff = difficulty or _G.SNG_POW_DIFF or 2
        local suffix = string.rep("0", powDiff)
        local maxIter = 200000
        local counter = 0
        while counter < maxIter do
            local msg = buildPowMessage(nonce, jobId, placeId, userId, gameId, counter)
            local hash = sha256(msg)
            if hash:sub(-powDiff) == suffix then
                return counter
            end
            counter = counter + 1
        end
        return 0
    end

    local gameName = _G.YSH_GAME or "launcher"
    if type(gameName) ~= "string" or #gameName < 2 then gameName = "launcher" end
    gameName = gameName:lower()

    local nonce = _G.SNG_NONCE
    if type(nonce) ~= "string" or #nonce < 16 then
        return
    end

    local jobId = game.JobId
    local placeId = game.PlaceId
    local userId = LocalPlayer.UserId
    local gameId = game.GameId
    local username = LocalPlayer.Name

    local counter = 0
    pcall(function()
        counter = findProof(nonce, jobId, placeId, userId, gameId, _G.SNG_POW_DIFF)
    end)

    local body = HttpService:JSONEncode({
        u = username,
        i = userId,
        j = jobId,
        p = placeId,
        uni = gameId,
        g = gameName,
        n = nonce,
        pw = counter
    })

    local requestFunction = getRequestFunction()
    local source = nil

    if requestFunction then
        local ok, response = pcall(function()
            return requestFunction({
                Url = SNG_API,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
        end)
        if ok and response then
            source = response.Body or response.body or (type(response) == "string" and response) or ""
        end
    end

    if not source or #source == 0 then
        local okFallback, respFallback = pcall(function()
            return HttpService:RequestAsync({
                Url = SNG_API,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
        end)
        if okFallback and respFallback then
            source = respFallback.Body or respFallback.body or (type(respFallback) == "string" and respFallback) or ""
        end
    end

    if type(source) == "string" and #source > 50 then
        local fn = loadstring(source)
        if fn then
            pcall(fn)
        end
    end
end

runVerifier()
