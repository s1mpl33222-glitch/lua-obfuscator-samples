-- Orvyn Auth loader - pentest


local GENV = (getgenv and getgenv()) or _G
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local API = "https://orvynauth.shop"
local SCRIPT_ID = "770378d850d8cd1d2e64f9b840fb0ff8"
local SCRIPT_NAME = "pentest"
local LOADER_VERSION = "1.0.2"
local ACCESS = "ffa"

local nativeLoadstring = loadstring
local nativeLoad = load
local nativeJson = HttpService.JSONDecode
local nativePcall = pcall
local nativeWarn = warn or print

local nativeHttpGet = nil
nativePcall(function()
    if game.HttpGet then nativeHttpGet = game.HttpGet end
    if not nativeHttpGet and game.HttpGetAsync then nativeHttpGet = game.HttpGetAsync end
end)

local WIRE = (function()

return function(P)
    local M = 4294967296
    local B13, M13 = 8192, 8191

    local BXOR = (P and P.bxor) or bit32.bxor
    local BAND = (P and P.band) or bit32.band
    local BNOT = (P and P.bnot) or bit32.bnot
    local CHAR = (P and P.char) or string.char
    local BYTE = (P and P.byte) or string.byte
    local SUB = (P and P.sub) or string.sub
    local UPPER = (P and P.upper) or string.upper
    local GSUB = (P and P.gsub) or string.gsub
    local REP = (P and P.rep) or string.rep
    local CONCAT = (P and P.concat) or table.concat
    local UNPK = (P and P.unpack) or string.unpack
    local PK = (P and P.pack) or string.pack

    
    
    
    local POW = {}
    for i = 0, 52 do POW[i] = 2 ^ i end

    
    
    
    
    
    
    
    local ROL = (P and P.rol) or (bit32 and (bit32.rol or bit32.lrotate)) or function(value, by)
        if by == 0 or by == 32 then return value % M end
        local low = value % POW[32 - by]
        return (low * POW[by] + (value - low) / POW[32 - by]) % M
    end
    local ROR = (P and P.ror) or (bit32 and (bit32.ror or bit32.rrotate)) or function(value, by)
        if by == 0 or by == 32 then return value % M end
        local high = value % POW[by]
        return (high * POW[32 - by] + (value - high) / POW[by]) % M
    end

    local SIGMA0, SIGMA1, SIGMA2, SIGMA3 = 0x61707865, 0x3320646e, 0x79622d32, 0x6b206574

    
    
    

    local B64 = nil
    local function b64Table()
        if B64 then return B64 end
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/-_"
        local map = {}
        for i = 1, 64 do map[SUB(alphabet, i, i)] = i - 1 end
        B64 = map
        return map
    end

    local function base64(text)
        if type(text) ~= "string" then return nil end
        local map = b64Table()
        local out, n = {}, 0
        local index, len = 1, #text
        while index <= len do
            local c1 = SUB(text, index, index)
            local c2 = SUB(text, index + 1, index + 1)
            local c3 = SUB(text, index + 2, index + 2)
            local c4 = SUB(text, index + 3, index + 3)
            local v1, v2 = map[c1], map[c2]
            if not v1 or not v2 then return nil end
            local v3, v4 = map[c3], map[c4]
            n = n + 1; out[n] = CHAR(v1 * 4 + v2 // 16)
            if v3 then
                n = n + 1; out[n] = CHAR((v2 % 16) * 16 + v3 // 4)
                if v4 then n = n + 1; out[n] = CHAR((v3 % 4) * 64 + v4) end
            end
            index = index + 4
        end
        return CONCAT(out)
    end

    local HEXT = nil
    local function hexTable()
        if HEXT then return HEXT end
        local digits = "0123456789abcdef"
        local map = {}
        for i = 0, 255 do
            local hi = i // 16 + 1
            local lo = i % 16 + 1
            local pair = SUB(digits, hi, hi) .. SUB(digits, lo, lo)
            local single = CHAR(i)
            map[pair] = single
            map[UPPER(pair)] = single
        end
        HEXT = map
        return map
    end

    
    
    local function unhex(text)
        if type(text) ~= "string" or #text % 2 ~= 0 then return nil end
        local map = hexTable()
        local out, n = {}, 0
        for start = 1, #text, 262144 do
            local piece = SUB(text, start, start + 262143)
            local decoded, matched = GSUB(piece, "..", map)
            
            if matched * 2 ~= #piece or #decoded ~= #piece // 2 then return nil end
            n = n + 1
            out[n] = decoded
        end
        return CONCAT(out)
    end

    
    
    

    local STATE = {}
    local STREAM = {}

    local function block()
        local s = STATE
        local x0, x1, x2, x3 = s[1], s[2], s[3], s[4]
        local x4, x5, x6, x7 = s[5], s[6], s[7], s[8]
        local x8, x9, x10, x11 = s[9], s[10], s[11], s[12]
        local x12, x13, x14, x15 = s[13], s[14], s[15], s[16]

        for _ = 1, 10 do
            x0 = (x0 + x4) % M; x12 = ROL(BXOR(x12, x0), 16)
            x8 = (x8 + x12) % M; x4 = ROL(BXOR(x4, x8), 12)
            x0 = (x0 + x4) % M; x12 = ROL(BXOR(x12, x0), 8)
            x8 = (x8 + x12) % M; x4 = ROL(BXOR(x4, x8), 7)

            x1 = (x1 + x5) % M; x13 = ROL(BXOR(x13, x1), 16)
            x9 = (x9 + x13) % M; x5 = ROL(BXOR(x5, x9), 12)
            x1 = (x1 + x5) % M; x13 = ROL(BXOR(x13, x1), 8)
            x9 = (x9 + x13) % M; x5 = ROL(BXOR(x5, x9), 7)

            x2 = (x2 + x6) % M; x14 = ROL(BXOR(x14, x2), 16)
            x10 = (x10 + x14) % M; x6 = ROL(BXOR(x6, x10), 12)
            x2 = (x2 + x6) % M; x14 = ROL(BXOR(x14, x2), 8)
            x10 = (x10 + x14) % M; x6 = ROL(BXOR(x6, x10), 7)

            x3 = (x3 + x7) % M; x15 = ROL(BXOR(x15, x3), 16)
            x11 = (x11 + x15) % M; x7 = ROL(BXOR(x7, x11), 12)
            x3 = (x3 + x7) % M; x15 = ROL(BXOR(x15, x3), 8)
            x11 = (x11 + x15) % M; x7 = ROL(BXOR(x7, x11), 7)

            x0 = (x0 + x5) % M; x15 = ROL(BXOR(x15, x0), 16)
            x10 = (x10 + x15) % M; x5 = ROL(BXOR(x5, x10), 12)
            x0 = (x0 + x5) % M; x15 = ROL(BXOR(x15, x0), 8)
            x10 = (x10 + x15) % M; x5 = ROL(BXOR(x5, x10), 7)

            x1 = (x1 + x6) % M; x12 = ROL(BXOR(x12, x1), 16)
            x11 = (x11 + x12) % M; x6 = ROL(BXOR(x6, x11), 12)
            x1 = (x1 + x6) % M; x12 = ROL(BXOR(x12, x1), 8)
            x11 = (x11 + x12) % M; x6 = ROL(BXOR(x6, x11), 7)

            x2 = (x2 + x7) % M; x13 = ROL(BXOR(x13, x2), 16)
            x8 = (x8 + x13) % M; x7 = ROL(BXOR(x7, x8), 12)
            x2 = (x2 + x7) % M; x13 = ROL(BXOR(x13, x2), 8)
            x8 = (x8 + x13) % M; x7 = ROL(BXOR(x7, x8), 7)

            x3 = (x3 + x4) % M; x14 = ROL(BXOR(x14, x3), 16)
            x9 = (x9 + x14) % M; x4 = ROL(BXOR(x4, x9), 12)
            x3 = (x3 + x4) % M; x14 = ROL(BXOR(x14, x3), 8)
            x9 = (x9 + x14) % M; x4 = ROL(BXOR(x4, x9), 7)
        end

        STREAM[1] = (x0 + s[1]) % M
        STREAM[2] = (x1 + s[2]) % M
        STREAM[3] = (x2 + s[3]) % M
        STREAM[4] = (x3 + s[4]) % M
        STREAM[5] = (x4 + s[5]) % M
        STREAM[6] = (x5 + s[6]) % M
        STREAM[7] = (x6 + s[7]) % M
        STREAM[8] = (x7 + s[8]) % M
        STREAM[9] = (x8 + s[9]) % M
        STREAM[10] = (x9 + s[10]) % M
        STREAM[11] = (x10 + s[11]) % M
        STREAM[12] = (x11 + s[12]) % M
        STREAM[13] = (x12 + s[13]) % M
        STREAM[14] = (x13 + s[14]) % M
        STREAM[15] = (x14 + s[15]) % M
        STREAM[16] = (x15 + s[16]) % M
    end

    local function wordAt(source, at)
        local a, b, c, d = BYTE(source, at, at + 3)
        return a + b * 256 + c * 65536 + d * 16777216
    end

    
    local function seed(key, nonce12, counter)
        local s = STATE
        s[1], s[2], s[3], s[4] = SIGMA0, SIGMA1, SIGMA2, SIGMA3
        for i = 0, 7 do s[5 + i] = wordAt(key, i * 4 + 1) end
        s[13] = counter
        for i = 0, 2 do s[14 + i] = wordAt(nonce12, i * 4 + 1) end
    end

    
    
    
    local function keystream(key, nonce12, counter)
        seed(key, nonce12, counter)
        block()
        local out, n = {}, 0
        for i = 1, 16 do
            local w = STREAM[i]
            n = n + 1
            out[n] = CHAR(w % 256, w // 256 % 256, w // 65536 % 256, w // 16777216 % 256)
        end
        return CONCAT(out)
    end

    local function chacha(key, nonce12, counter, data)
        seed(key, nonce12, counter)

        local out, n = {}, 0
        local at, len = 1, #data
        while at <= len do
            block()
            local stop = at + 63
            if stop > len then stop = len end
            local k = 1
            
            
            
            
            
            
            if UNPK and PK then
                while at + 15 <= stop do
                    local a, b, c, d = UNPK("<I4I4I4I4", data, at)
                    n = n + 1
                    out[n] = PK(
                        "<I4I4I4I4",
                        BXOR(STREAM[k], a),
                        BXOR(STREAM[k + 1], b),
                        BXOR(STREAM[k + 2], c),
                        BXOR(STREAM[k + 3], d)
                    )
                    at = at + 16
                    k = k + 4
                end
            end
            while at + 3 <= stop do
                local a, b, c, d = BYTE(data, at, at + 3)
                local w = BXOR(STREAM[k], a + b * 256 + c * 65536 + d * 16777216)
                n = n + 1
                out[n] = CHAR(w % 256, w // 256 % 256, w // 65536 % 256, w // 16777216 % 256)
                at = at + 4
                k = k + 1
            end
            
            
            while at <= stop do
                local w = STREAM[k]
                n = n + 1
                out[n] = CHAR(BXOR(BYTE(data, at), w % 256))
                STREAM[k] = w // 256
                at = at + 1
            end
            STATE[13] = (STATE[13] + 1) % M
        end
        return CONCAT(out)
    end

    local function hchacha(key, nonce16)
        
        
        local s = STATE
        s[1], s[2], s[3], s[4] = SIGMA0, SIGMA1, SIGMA2, SIGMA3
        for i = 0, 7 do s[5 + i] = wordAt(key, i * 4 + 1) end
        for i = 0, 3 do s[13 + i] = wordAt(nonce16, i * 4 + 1) end
        
        
        local x0, x1, x2, x3 = s[1], s[2], s[3], s[4]
        local x4, x5, x6, x7 = s[5], s[6], s[7], s[8]
        local x8, x9, x10, x11 = s[9], s[10], s[11], s[12]
        local x12, x13, x14, x15 = s[13], s[14], s[15], s[16]
        for _ = 1, 10 do
            x0 = (x0 + x4) % M; x12 = ROL(BXOR(x12, x0), 16)
            x8 = (x8 + x12) % M; x4 = ROL(BXOR(x4, x8), 12)
            x0 = (x0 + x4) % M; x12 = ROL(BXOR(x12, x0), 8)
            x8 = (x8 + x12) % M; x4 = ROL(BXOR(x4, x8), 7)

            x1 = (x1 + x5) % M; x13 = ROL(BXOR(x13, x1), 16)
            x9 = (x9 + x13) % M; x5 = ROL(BXOR(x5, x9), 12)
            x1 = (x1 + x5) % M; x13 = ROL(BXOR(x13, x1), 8)
            x9 = (x9 + x13) % M; x5 = ROL(BXOR(x5, x9), 7)

            x2 = (x2 + x6) % M; x14 = ROL(BXOR(x14, x2), 16)
            x10 = (x10 + x14) % M; x6 = ROL(BXOR(x6, x10), 12)
            x2 = (x2 + x6) % M; x14 = ROL(BXOR(x14, x2), 8)
            x10 = (x10 + x14) % M; x6 = ROL(BXOR(x6, x10), 7)

            x3 = (x3 + x7) % M; x15 = ROL(BXOR(x15, x3), 16)
            x11 = (x11 + x15) % M; x7 = ROL(BXOR(x7, x11), 12)
            x3 = (x3 + x7) % M; x15 = ROL(BXOR(x15, x3), 8)
            x11 = (x11 + x15) % M; x7 = ROL(BXOR(x7, x11), 7)

            x0 = (x0 + x5) % M; x15 = ROL(BXOR(x15, x0), 16)
            x10 = (x10 + x15) % M; x5 = ROL(BXOR(x5, x10), 12)
            x0 = (x0 + x5) % M; x15 = ROL(BXOR(x15, x0), 8)
            x10 = (x10 + x15) % M; x5 = ROL(BXOR(x5, x10), 7)

            x1 = (x1 + x6) % M; x12 = ROL(BXOR(x12, x1), 16)
            x11 = (x11 + x12) % M; x6 = ROL(BXOR(x6, x11), 12)
            x1 = (x1 + x6) % M; x12 = ROL(BXOR(x12, x1), 8)
            x11 = (x11 + x12) % M; x6 = ROL(BXOR(x6, x11), 7)

            x2 = (x2 + x7) % M; x13 = ROL(BXOR(x13, x2), 16)
            x8 = (x8 + x13) % M; x7 = ROL(BXOR(x7, x8), 12)
            x2 = (x2 + x7) % M; x13 = ROL(BXOR(x13, x2), 8)
            x8 = (x8 + x13) % M; x7 = ROL(BXOR(x7, x8), 7)

            x3 = (x3 + x4) % M; x14 = ROL(BXOR(x14, x3), 16)
            x9 = (x9 + x14) % M; x4 = ROL(BXOR(x4, x9), 12)
            x3 = (x3 + x4) % M; x14 = ROL(BXOR(x14, x3), 8)
            x9 = (x9 + x14) % M; x4 = ROL(BXOR(x4, x9), 7)
        end

        local words = { x0, x1, x2, x3, x12, x13, x14, x15 }
        local out, n = {}, 0
        for i = 1, 8 do
            local w = words[i]
            n = n + 1
            out[n] = CHAR(w % 256, w // 256 % 256, w // 65536 % 256, w // 16777216 % 256)
        end
        return CONCAT(out)
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    local B13 = 8192

    local POW = {}
    for i = 0, 25 do POW[i] = 2 ^ i end

    local R, S = {}, {}

    
    
    local function limbsOf(text, out)
        for i = 1, 11 do out[i] = 0 end
        for i = 1, 16 do
            local bit = (i - 1) * 8
            local limb = bit // 13 + 1
            local value = BYTE(text, i) * POW[bit % 13]
            out[limb] = out[limb] + value % B13
            out[limb + 1] = out[limb + 1] + value // B13
        end
    end

    
    local function clampR(key)
        local out = {}
        for i = 1, 16 do
            local value = BYTE(key, i)
            local index = i - 1
            if index == 3 or index == 7 or index == 11 or index == 15 then
                value = value % 16
            elseif index == 4 or index == 8 or index == 12 then
                value = value - value % 4
            end
            out[i] = CHAR(value)
        end
        return CONCAT(out)
    end

    local function equal(a, b)
        if type(a) ~= "string" or type(b) ~= "string" or #a ~= #b then return false end
        local diff = 0
        for i = 1, #a do diff = BXOR(diff, BYTE(a, i) - BYTE(b, i)) end
        return diff == 0
    end

    
    
    
    
    
    local function tagOf(key, aad, ct)
        local aadLength, ctLength = #aad, #ct

        limbsOf(clampR(key), R)
        local r1, r2, r3, r4, r5 = R[1], R[2], R[3], R[4], R[5]
        local r6, r7, r8, r9, r10 = R[6], R[7], R[8], R[9], R[10]
        
        
        local a1, a2, a3, a4, a5 = r1 * 5, r2 * 5, r3 * 5, r4 * 5, r5 * 5
        local a6, a7, a8, a9, a10 = r6 * 5, r7 * 5, r8 * 5, r9 * 5, r10 * 5

        limbsOf(SUB(key, 17, 32), S)
        local s1, s2, s3, s4, s5 = S[1], S[2], S[3], S[4], S[5]
        local s6, s7, s8, s9, s10 = S[6], S[7], S[8], S[9], S[10]

        local h0, h1, h2, h3, h4, h5, h6, h7, h8, h9 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        local trailer = CHAR(
            aadLength % 256, aadLength // 256 % 256, aadLength // 65536 % 256, aadLength // 16777216 % 256,
            0, 0, 0, 0,
            ctLength % 256, ctLength // 256 % 256, ctLength // 65536 % 256, ctLength // 16777216 % 256,
            0, 0, 0, 0
        )

        for phase = 1, 3 do
            local source, length
            if phase == 1 then
                source, length = aad, aadLength
            elseif phase == 2 then
                source, length = ct, ctLength
            else
                source, length = trailer, 16
            end

            local at = 1
            while at + 15 <= length do
                local w1, w2, w3, w4 = UNPK("<I4I4I4I4", source, at)
                
                
                local t = w1
                h0 = h0 + t % B13; t = t // B13
                h1 = h1 + t % B13; t = t // B13
                h2 = h2 + t
                t = w2 * 64
                h2 = h2 + t % B13; t = t // B13
                h3 = h3 + t % B13; t = t // B13
                h4 = h4 + t
                t = w3 * 4096
                h4 = h4 + t % B13; t = t // B13
                h5 = h5 + t % B13; t = t // B13
                h6 = h6 + t
                t = w4 * 32
                h7 = h7 + t % B13; t = t // B13
                h8 = h8 + t % B13; t = t // B13
                h9 = h9 + t
                
                h9 = h9 + 2048

                local d0 = h0 * r1 + h1 * a10 + h2 * a9 + h3 * a8 + h4 * a7 + h5 * a6 + h6 * a5 + h7 * a4 + h8 * a3 + h9 * a2
                local d1 = h0 * r2 + h1 * r1 + h2 * a10 + h3 * a9 + h4 * a8 + h5 * a7 + h6 * a6 + h7 * a5 + h8 * a4 + h9 * a3
                local d2 = h0 * r3 + h1 * r2 + h2 * r1 + h3 * a10 + h4 * a9 + h5 * a8 + h6 * a7 + h7 * a6 + h8 * a5 + h9 * a4
                local d3 = h0 * r4 + h1 * r3 + h2 * r2 + h3 * r1 + h4 * a10 + h5 * a9 + h6 * a8 + h7 * a7 + h8 * a6 + h9 * a5
                local d4 = h0 * r5 + h1 * r4 + h2 * r3 + h3 * r2 + h4 * r1 + h5 * a10 + h6 * a9 + h7 * a8 + h8 * a7 + h9 * a6
                local d5 = h0 * r6 + h1 * r5 + h2 * r4 + h3 * r3 + h4 * r2 + h5 * r1 + h6 * a10 + h7 * a9 + h8 * a8 + h9 * a7
                local d6 = h0 * r7 + h1 * r6 + h2 * r5 + h3 * r4 + h4 * r3 + h5 * r2 + h6 * r1 + h7 * a10 + h8 * a9 + h9 * a8
                local d7 = h0 * r8 + h1 * r7 + h2 * r6 + h3 * r5 + h4 * r4 + h5 * r3 + h6 * r2 + h7 * r1 + h8 * a10 + h9 * a9
                local d8 = h0 * r9 + h1 * r8 + h2 * r7 + h3 * r6 + h4 * r5 + h5 * r4 + h6 * r3 + h7 * r2 + h8 * r1 + h9 * a10
                local d9 = h0 * r10 + h1 * r9 + h2 * r8 + h3 * r7 + h4 * r6 + h5 * r5 + h6 * r4 + h7 * r3 + h8 * r2 + h9 * r1

                local carry = d0 // B13
                h0 = d0 - carry * B13
                d1 = d1 + carry; carry = d1 // B13; h1 = d1 - carry * B13
                d2 = d2 + carry; carry = d2 // B13; h2 = d2 - carry * B13
                d3 = d3 + carry; carry = d3 // B13; h3 = d3 - carry * B13
                d4 = d4 + carry; carry = d4 // B13; h4 = d4 - carry * B13
                d5 = d5 + carry; carry = d5 // B13; h5 = d5 - carry * B13
                d6 = d6 + carry; carry = d6 // B13; h6 = d6 - carry * B13
                d7 = d7 + carry; carry = d7 // B13; h7 = d7 - carry * B13
                d8 = d8 + carry; carry = d8 // B13; h8 = d8 - carry * B13
                d9 = d9 + carry; carry = d9 // B13; h9 = d9 - carry * B13
                
                h0 = h0 + carry * 5
                carry = h0 // B13
                h0 = h0 - carry * B13
                h1 = h1 + carry

                at = at + 16
            end

            local rest = length - at + 1
            if rest > 0 then
                for i = 0, rest - 1 do
                    local bit = i * 8
                    local value = BYTE(source, at + i) * POW[bit % 13]
                    local low = value % B13
                    local high = value // B13
                    local limb = bit // 13
                    if limb == 0 then
                        h0 = h0 + low
                        h1 = h1 + high
                    elseif limb == 1 then
                        h1 = h1 + low
                        h2 = h2 + high
                    elseif limb == 2 then
                        h2 = h2 + low
                        h3 = h3 + high
                    elseif limb == 3 then
                        h3 = h3 + low
                        h4 = h4 + high
                    elseif limb == 4 then
                        h4 = h4 + low
                        h5 = h5 + high
                    elseif limb == 5 then
                        h5 = h5 + low
                        h6 = h6 + high
                    elseif limb == 6 then
                        h6 = h6 + low
                        h7 = h7 + high
                    elseif limb == 7 then
                        h7 = h7 + low
                        h8 = h8 + high
                    else
                        h8 = h8 + low
                        h9 = h9 + high
                    end
                end
                
                
                h9 = h9 + 2048

                local d0 = h0 * r1 + h1 * a10 + h2 * a9 + h3 * a8 + h4 * a7 + h5 * a6 + h6 * a5 + h7 * a4 + h8 * a3 + h9 * a2
                local d1 = h0 * r2 + h1 * r1 + h2 * a10 + h3 * a9 + h4 * a8 + h5 * a7 + h6 * a6 + h7 * a5 + h8 * a4 + h9 * a3
                local d2 = h0 * r3 + h1 * r2 + h2 * r1 + h3 * a10 + h4 * a9 + h5 * a8 + h6 * a7 + h7 * a6 + h8 * a5 + h9 * a4
                local d3 = h0 * r4 + h1 * r3 + h2 * r2 + h3 * r1 + h4 * a10 + h5 * a9 + h6 * a8 + h7 * a7 + h8 * a6 + h9 * a5
                local d4 = h0 * r5 + h1 * r4 + h2 * r3 + h3 * r2 + h4 * r1 + h5 * a10 + h6 * a9 + h7 * a8 + h8 * a7 + h9 * a6
                local d5 = h0 * r6 + h1 * r5 + h2 * r4 + h3 * r3 + h4 * r2 + h5 * r1 + h6 * a10 + h7 * a9 + h8 * a8 + h9 * a7
                local d6 = h0 * r7 + h1 * r6 + h2 * r5 + h3 * r4 + h4 * r3 + h5 * r2 + h6 * r1 + h7 * a10 + h8 * a9 + h9 * a8
                local d7 = h0 * r8 + h1 * r7 + h2 * r6 + h3 * r5 + h4 * r4 + h5 * r3 + h6 * r2 + h7 * r1 + h8 * a10 + h9 * a9
                local d8 = h0 * r9 + h1 * r8 + h2 * r7 + h3 * r6 + h4 * r5 + h5 * r4 + h6 * r3 + h7 * r2 + h8 * r1 + h9 * a10
                local d9 = h0 * r10 + h1 * r9 + h2 * r8 + h3 * r7 + h4 * r6 + h5 * r5 + h6 * r4 + h7 * r3 + h8 * r2 + h9 * r1

                local carry = d0 // B13
                h0 = d0 - carry * B13
                d1 = d1 + carry; carry = d1 // B13; h1 = d1 - carry * B13
                d2 = d2 + carry; carry = d2 // B13; h2 = d2 - carry * B13
                d3 = d3 + carry; carry = d3 // B13; h3 = d3 - carry * B13
                d4 = d4 + carry; carry = d4 // B13; h4 = d4 - carry * B13
                d5 = d5 + carry; carry = d5 // B13; h5 = d5 - carry * B13
                d6 = d6 + carry; carry = d6 // B13; h6 = d6 - carry * B13
                d7 = d7 + carry; carry = d7 // B13; h7 = d7 - carry * B13
                d8 = d8 + carry; carry = d8 // B13; h8 = d8 - carry * B13
                d9 = d9 + carry; carry = d9 // B13; h9 = d9 - carry * B13
                h0 = h0 + carry * 5
                carry = h0 // B13
                h0 = h0 - carry * B13
                h1 = h1 + carry
            end
        end

        
        
        local carry = 5
        local g0 = h0 + carry; carry = g0 // B13; g0 = g0 - carry * B13
        local g1 = h1 + carry; carry = g1 // B13; g1 = g1 - carry * B13
        local g2 = h2 + carry; carry = g2 // B13; g2 = g2 - carry * B13
        local g3 = h3 + carry; carry = g3 // B13; g3 = g3 - carry * B13
        local g4 = h4 + carry; carry = g4 // B13; g4 = g4 - carry * B13
        local g5 = h5 + carry; carry = g5 // B13; g5 = g5 - carry * B13
        local g6 = h6 + carry; carry = g6 // B13; g6 = g6 - carry * B13
        local g7 = h7 + carry; carry = g7 // B13; g7 = g7 - carry * B13
        local g8 = h8 + carry; carry = g8 // B13; g8 = g8 - carry * B13
        local g9 = h9 + carry; carry = g9 // B13; g9 = g9 - carry * B13
        if carry > 0 then
            h0, h1, h2, h3, h4, h5 = g0, g1, g2, g3, g4, g5
            h6, h7, h8, h9 = g6, g7, g8, g9
        end

        
        local v0 = h0 + s1; carry = v0 // B13; v0 = v0 - carry * B13
        local v1 = h1 + s2 + carry; carry = v1 // B13; v1 = v1 - carry * B13
        local v2 = h2 + s3 + carry; carry = v2 // B13; v2 = v2 - carry * B13
        local v3 = h3 + s4 + carry; carry = v3 // B13; v3 = v3 - carry * B13
        local v4 = h4 + s5 + carry; carry = v4 // B13; v4 = v4 - carry * B13
        local v5 = h5 + s6 + carry; carry = v5 // B13; v5 = v5 - carry * B13
        local v6 = h6 + s7 + carry; carry = v6 // B13; v6 = v6 - carry * B13
        local v7 = h7 + s8 + carry; carry = v7 // B13; v7 = v7 - carry * B13
        local v8 = h8 + s9 + carry; carry = v8 // B13; v8 = v8 - carry * B13
        local v9 = h9 + s10 + carry; carry = v9 // B13; v9 = v9 - carry * B13

        
        local x0 = v0 + v1 * 8192 + v2 % 64 * 67108864
        local x1 = v2 // 64 % 128 + v3 % 8192 * 128 + v4 % 4096 * 1048576
        local x2 = v4 // 4096 + v5 * 2 + v6 * 16384 + v7 % 32 * 134217728
        local x3 = v7 // 32 + v8 * 256 + v9 % 2048 * 2097152

        return CHAR(
            x0 % 256, x0 // 256 % 256, x0 // 65536 % 256, x0 // 16777216 % 256,
            x1 % 256, x1 // 256 % 256, x1 // 65536 % 256, x1 // 16777216 % 256,
            x2 % 256, x2 // 256 % 256, x2 // 65536 % 256, x2 // 16777216 % 256,
            x3 % 256, x3 // 256 % 256, x3 // 65536 % 256, x3 // 16777216 % 256
        )
    end

    
    
    

    
    local function open(ct, keyB64, nonceB64, tagB64, aad)
        if not UNPK then return nil, "CLIENT" end

        local key = base64(keyB64)
        local nonce = base64(nonceB64)
        local tag = base64(tagB64)
        if not key or #key ~= 32 then return nil end
        if not nonce or #nonce ~= 24 then return nil end
        if not tag or #tag ~= 16 then return nil end

        local subkey = hchacha(key, SUB(nonce, 1, 16))
        local nonce12 = CHAR(0) .. CHAR(0) .. CHAR(0) .. CHAR(0) .. SUB(nonce, 17, 24)
        
        local polyKey = SUB(keystream(subkey, nonce12, 0), 1, 32)
        if not equal(tagOf(polyKey, tostring(aad or ""), ct), tag) then return nil end
        return chacha(subkey, nonce12, 1, ct)
    end

    return {
        open = open,
        unhex = unhex,
        base64 = base64,
        tagOf = tagOf,
        chacha = chacha,
        keystream = keystream,
        hchacha = hchacha,
    }
end

end)()({
    bxor = bit32 and bit32.bxor,
    band = bit32 and bit32.band,
    bnot = bit32 and bit32.bnot,
    lshift = bit32 and bit32.lshift,
    rshift = bit32 and bit32.rshift,
    bor = bit32 and bit32.bor,
    char = string.char,
    byte = string.byte,
    sub = string.sub,
    upper = string.upper,
    gsub = string.gsub,
    rep = string.rep,
    concat = table.concat,
    unpack = string.unpack,
    pack = string.pack,
})

local function note(text)
    nativePcall(function() nativeWarn("[Orvyn] " .. tostring(text)) end)
end

local function wallClock()
    local value = 0
    nativePcall(function() if tick then value = tick() end end)
    if value == 0 then
        nativePcall(function()
            local now = DateTime and DateTime.now and DateTime.now()
            if now then value = now.UnixTimestampMillis / 1000 end
        end)
    end
    if value == 0 then
        nativePcall(function()
            local space = game and game.GetService and game:GetService("Workspace")
            if space and space.GetServerTimeNow then value = space:GetServerTimeNow() end
        end)
    end
    if value == 0 then nativePcall(function() value = os.clock() end) end
    return value
end

local STARTED_AT = wallClock()

local nativeIscclosure = iscclosure
local nativeInfo = (debug and debug.info) or nil
local nativeGetinfo = (debug and debug.getinfo) or nil
local nativeGetupvalue = (debug and debug.getupvalue) or nil
local nativeGetupvalues = (debug and debug.getupvalues) or nil
local nativeGetupvaluesG = getupvalues

local function isNative(fn)
    if type(fn) ~= "function" then return false end
    if nativeIscclosure then
        local ok, closured = nativePcall(nativeIscclosure, fn)
        if ok and closured ~= nil then return closured end
    end
    if nativeInfo then
        local ok, src = nativePcall(nativeInfo, fn, "s")
        if ok and type(src) == "string" then return src == "[C]" or src == "=[C]" end
    end
    if nativeGetinfo then
        local ok, info = nativePcall(nativeGetinfo, fn, "S")
        if ok and type(info) == "table" then return info.what == "C" end
    end
    return true
end

local function upvalueCount(fn)
    if nativeInfo then
        local ok, count = nativePcall(nativeInfo, fn, "u")
        if ok and type(count) == "number" then return count end
    end
    if nativeGetinfo then
        local ok, info = nativePcall(nativeGetinfo, fn, "u")
        if ok then
            if type(info) == "number" then return info end
            if type(info) == "table" and type(info.nups) == "number" then return info.nups end
        end
    end
    return -1
end

local UPWITNESS = false
nativePcall(function()
    local generator = newcclosure
    if type(generator) ~= "function" then return end
    local box = { 1 }
    local made = generator(function() return box[1] end)
    if type(made) == "function" and upvalueCount(made) > 0 then UPWITNESS = true end
end)

local function wrapped(fn)
    if type(fn) ~= "function" then return false end
    if nativeIscclosure then
        local ok, closured = nativePcall(nativeIscclosure, fn)
        if not ok or closured ~= true then return false end
    end
    
    
    
    
    if nativeGetupvalue then
        local ok, name, value = nativePcall(nativeGetupvalue, fn, 1)
        if ok and (name ~= nil or value ~= nil) then return true end
    end
    if nativeGetupvalues then
        local ok, list = nativePcall(nativeGetupvalues, fn)
        if ok and type(list) == "table" and #list > 0 then return true end
    end
    if nativeGetupvaluesG then
        local ok, list = nativePcall(nativeGetupvaluesG, fn)
        if ok and type(list) == "table" and #list > 0 then return true end
    end
    
    
    
    
    
    if UPWITNESS and upvalueCount(fn) > 0 then return true end
    return false
end

local DEBUG_FIELDS = {
    { field = "getupvalue", fn = nativeGetupvalue },
    { field = "getupvalues", fn = nativeGetupvalues },
    { field = "setupvalue", fn = (debug and debug.setupvalue) or nil },
    { field = "setlocal", fn = (debug and debug.setlocal) or nil },
    { field = "getinfo", fn = nativeGetinfo },
    { field = "info", fn = nativeInfo },
}

local function debugReplaced()
    if type(debug) ~= "table" then return nil end
    for i = 1, #DEBUG_FIELDS do
        local entry = DEBUG_FIELDS[i]
        if type(entry.fn) == "function" then
            local live = nil
            nativePcall(function() live = debug[entry.field] end)
            if live ~= entry.fn then return "debug." .. entry.field end
        end
    end
    return nil
end

local PROBE_VALUE = nil
nativePcall(function() PROBE_VALUE = tostring(math.random(100000000, 2147483647)) end)

local function debugLies()
    local box = { value = PROBE_VALUE }
    local probe = function() return box.value end
    local count = 0
    if nativeInfo then
        local ok, value = nativePcall(nativeInfo, probe, "u")
        if ok and type(value) == "number" then count = value end
    end
    if count < 1 then return false end
    if nativeGetupvalue then
        local ok, name, value = nativePcall(nativeGetupvalue, probe, 1)
        if ok and name == nil and value == nil then return true end
    end
    if nativeGetupvalues then
        local ok, list = nativePcall(nativeGetupvalues, probe)
        if ok and type(list) == "table" and #list == 0 then return true end
    end
    return false
end

local function debugShadowed()
    if type(debug) ~= "table" or not UPWITNESS then return nil end
    for i = 1, #DEBUG_FIELDS do
        local entry = DEBUG_FIELDS[i]
        if entry.hard ~= false then
            local live = nil
            nativePcall(function() live = debug[entry.field] end)
            if type(live) == "function" and upvalueCount(live) > 0 then
                return "debug." .. entry.field
            end
        end
    end
    return nil
end

local function compiler()
    local list = { nativeLoadstring, nativeLoad, GENV and GENV.loadstring, GENV and GENV.load }
    for i = 1, #list do
        local fn = list[i]
        if type(fn) == "function" and isNative(fn) and not wrapped(fn) then return fn end
    end
    return nil
end

local function tampered()
    if nativeLoadstring ~= nil and (not isNative(nativeLoadstring) or wrapped(nativeLoadstring)) then return true end
    if nativeLoad ~= nil and (not isNative(nativeLoad) or wrapped(nativeLoad)) then return true end
    if GENV then
        if type(GENV.loadstring) == "function" and GENV.loadstring ~= nativeLoadstring and wrapped(GENV.loadstring) then return true end
        if type(GENV.load) == "function" and GENV.load ~= nativeLoad and wrapped(GENV.load) then return true end
    end
    return false
end

local CHANNELS = {
    { name = "bit32.bxor", hard = true, get = function() return bit32 and bit32.bxor end },
    { name = "string.char", hard = true, get = function() return string and string.char end },
    { name = "string.gsub", hard = true, get = function() return string and string.gsub end },
    { name = "string.sub", hard = true, get = function() return string and string.sub end },
    { name = "string.match", hard = true, get = function() return string and string.match end },
    { name = "table.concat", hard = true, get = function() return table and table.concat end },
    { name = "HttpService.JSONDecode", hard = false, get = function() return HttpService and HttpService.JSONDecode end },
}

local function channelAt(index)
    local fn = nil
    nativePcall(function() fn = CHANNELS[index].get() end)
    return fn
end

local function wrappedChannels()
    local hits = {}
    for i = 1, #CHANNELS do
        local fn = channelAt(i)
        if type(fn) == "function" and wrapped(fn) then
            hits[#hits + 1] = { name = CHANNELS[i].name, hard = CHANNELS[i].hard }
        end
    end
    return hits
end

local function joinNames(list)
    local text = ""
    for i = 1, #list do
        if i > 1 then text = text .. "," end
        text = text .. tostring(list[i])
    end
    return text
end

local BASELINE = {}

pcall(function()
    local capture = { nativeLoadstring, nativeLoad, GENV and GENV.loadstring, GENV and GENV.load }
    for i = 1, #capture do
        local fn = capture[i]
        if type(fn) == "function" then
            BASELINE[#BASELINE + 1] = { fn = fn, wrapped = wrapped(fn) }
        end
    end
    for i = 1, #CHANNELS do
        local fn = channelAt(i)
        if type(fn) == "function" then
            BASELINE[#BASELINE + 1] = {
                fn = fn,
                wrapped = wrapped(fn),
                hard = CHANNELS[i].hard,
                name = CHANNELS[i].name,
            }
        end
    end
end)

local function drifted()
    for i = 1, #BASELINE do
        local entry = BASELINE[i]
        if entry.hard ~= false and not entry.wrapped and wrapped(entry.fn) then return true end
    end
    return false
end

local function softDrift()
    local hits = {}
    for i = 1, #BASELINE do
        local entry = BASELINE[i]
        if entry.hard == false and not entry.wrapped and wrapped(entry.fn) then
            hits[#hits + 1] = entry.name
        end
    end
    return hits
end

local SEAL_TOKEN = ""
nativePcall(function()
    SEAL_TOKEN = tostring(math.random(100000000, 2147483647))
        .. ":" .. tostring((os and os.clock and os.clock()) or 0)
end)

local function sealText(list, token)
    local text = tostring(token or "")
    if type(list) ~= "table" then return text .. "|missing" end
    for i = 1, #list do
        local entry = list[i]
        if type(entry) == "table" then
            text = text
                .. "|" .. tostring(entry.fn)
                .. "," .. tostring(entry.get)
                .. "," .. tostring(entry.wrapped)
                .. "," .. tostring(entry.name)
                .. "," .. tostring(entry.hard)
        else
            text = text .. "|" .. tostring(entry)
        end
    end
    return text
end

local BASELINE_SEAL = sealText(BASELINE, SEAL_TOKEN)
local CHANNEL_SEAL = sealText(CHANNELS, SEAL_TOKEN)
local NATIVE_SEAL = sealText({ nativeLoadstring, nativeLoad, nativeHttpGet, nativePcall, nativeIscclosure, nativeGetupvalue, nativeGetupvalues, nativeInfo }, SEAL_TOKEN)

local DUMP_CHANNELS = { "writefile", "appendfile", "setclipboard", "toclipboard" }

local function dumpChannels()
    local hits = {}
    for i = 1, #DUMP_CHANNELS do
        local name = DUMP_CHANNELS[i]
        local fn = nil
        nativePcall(function() fn = GENV and GENV[name] end)
        if type(fn) ~= "function" then nativePcall(function() fn = _G and _G[name] end) end
        if type(fn) == "function" and wrapped(fn) then hits[#hits + 1] = name end
    end
    return hits
end

local function addFetch(list, fn)
    if type(fn) == "function" then list[#list + 1] = fn end
end

local fetchers = {}
addFetch(fetchers, nativeHttpGet)
addFetch(fetchers, syn and syn.request)
addFetch(fetchers, http_request)
addFetch(fetchers, fluxus and fluxus.request)
addFetch(fetchers, krnl and krnl.request)
addFetch(fetchers, request)
addFetch(fetchers, http and http.request)
addFetch(fetchers, http and http.get)
addFetch(fetchers, GENV and GENV.request)
addFetch(fetchers, GENV and GENV.http_request)

local function responseBody(response)
    if type(response) == "string" then return response end
    if type(response) ~= "table" then return nil end
    local body = response.Body or response.body or response.Content or response.content
    if type(body) == "string" and #body > 0 then return body end
    return nil
end

local function looksLikeJson(text)
    if type(text) ~= "string" then return false end
    local trimmed = text:match("^%s*(.-)%s*$") or ""
    if #trimmed == 0 then return false end
    local first = trimmed:sub(1, 1)
    return first == "{" or first == "["
end

local function httpGet(url, wantJson)
    local stray = nil

    local function accept(body)
        if type(body) ~= "string" or #body == 0 then return false end
        if wantJson and not looksLikeJson(body) then
            if not stray then stray = body end
            return false
        end
        return true
    end

    for i = 1, #fetchers do
        local fetcher = fetchers[i]
        
        
        if fetcher == nativeHttpGet then
            local ok, body = nativePcall(nativeHttpGet, game, url)
            if ok and accept(body) then return body end
            local okBound, bound = nativePcall(nativeHttpGet, url)
            if okBound and accept(bound) then return bound end
        else
            local done, response = nativePcall(fetcher, {
                Url = url,
                Method = "GET",
                Headers = { ["X-Orvyn-Client"] = "loader" },
            })
            local body = done and responseBody(response) or nil
            if accept(body) then return body end
            local donePlain, plain = nativePcall(fetcher, url)
            body = donePlain and responseBody(plain) or nil
            if accept(body) then return body end
        end
    end

    
    
    
    local okRequest, requestAnswer = nativePcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = { ["X-Orvyn-Client"] = "loader" },
        })
    end)
    if okRequest then
        local body = responseBody(requestAnswer)
        if accept(body) then return body end
    end

    local okService, serviceBody = nativePcall(function() return HttpService:GetAsync(url) end)
    if okService and accept(serviceBody) then return serviceBody end

    if wantJson then return nil end
    return stray
end

local function httpGetQuiet(url)
    local function accept(body)
        return type(body) == "string" and #body > 0 and looksLikeJson(body)
    end

    for i = 1, #fetchers do
        local fetcher = fetchers[i]
        if fetcher ~= nativeHttpGet then
            local done, response = nativePcall(fetcher, {
                Url = url,
                Method = "GET",
                Headers = { ["X-Orvyn-Client"] = "loader" },
            })
            local body = done and responseBody(response) or nil
            if accept(body) then return body end
        end
    end

    local okRequest, answer = nativePcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = { ["X-Orvyn-Client"] = "loader" },
        })
    end)
    if okRequest then
        local body = responseBody(answer)
        if accept(body) then return body end
    end

    if nativeHttpGet then
        local ok, body = nativePcall(nativeHttpGet, game, url)
        if ok and accept(body) then return body end
    end
    return nil
end

local function runSource(source, chunkName, onCompiled)
    local loaderFn = compiler() or nativeLoadstring or nativeLoad
    if type(loaderFn) ~= "function" then return false, "no compiler" end
    local ok, fn = nativePcall(loaderFn, source, chunkName or "=orvyn")
    if (not ok or type(fn) ~= "function") and GENV then
        local okEnv, envFn = nativePcall(loaderFn, source, chunkName or "=orvyn", "t", GENV)
        if okEnv and type(envFn) == "function" then ok, fn = okEnv, envFn end
    end
    if not ok or type(fn) ~= "function" then return false, tostring(fn) end
    
    
    if type(onCompiled) == "function" then nativePcall(onCompiled) end
    local ran, err = nativePcall(fn)
    if not ran then return false, tostring(err) end
    return true
end

local BAIT_HEAD = [[-- Orvyn protected chunk. Nothing here runs.
return nil
-- ]]

local BAIT_MAX = 1048576

local BAIT_FILL = "stop tryna crack orvyn "

local function makeBait(length)
    length = tonumber(length) or 0
    if length <= #BAIT_HEAD then return BAIT_HEAD end
    if length > BAIT_MAX then length = BAIT_MAX end
    local fill = length - #BAIT_HEAD
    
    
    local body = string.rep(BAIT_FILL, fill // #BAIT_FILL + 1)
    return BAIT_HEAD .. string.sub(body, 1, fill)
end

local function poison(length)
    local chunk = makeBait(length)
    
    
    
    local tried = {}
    local function baitThrough(fn)
        if type(fn) ~= "function" then return end
        for i = 1, #tried do
            if tried[i] == fn then return end
        end
        tried[#tried + 1] = fn
        nativePcall(fn, chunk, "=orvyn_p")
    end
    baitThrough(nativeLoadstring)
    baitThrough(nativeLoad)
    local shared = nil
    nativePcall(function() shared = GENV and GENV.loadstring end)
    baitThrough(shared)
end

local function poisonLater(length)
    if task and type(task.delay) == "function" then
        nativePcall(task.delay, 0.35, function() poison(length) end)
        return
    end
    if task and type(task.spawn) == "function" then
        nativePcall(task.spawn, function() poison(length) end)
        return
    end
    poison(length)
end

local function deviceIds()
    local out = {}
    local function add(value)
        local text = value and tostring(value) or ""
        text = text:gsub("%s+", "")
        if #text == 0 then return end
        for i = 1, #out do
            if out[i] == text then return end
        end
        if #out < 5 then out[#out + 1] = text end
    end

    if gethwid then nativePcall(function() add(gethwid()) end) end
    if syn and syn.get_hwid then nativePcall(function() add(syn.get_hwid()) end) end
    nativePcall(function()
        local analytics = game:GetService("RbxAnalyticsService")
        if analytics and analytics.GetClientId then add(analytics:GetClientId()) end
    end)
    if writefile and readfile then
        local file = ".orvyn_device"
        local saved = nil
        nativePcall(function()
            if isfile and isfile(file) then saved = readfile(file) end
        end)
        if saved and #saved > 0 then
            add(saved)
        else
            local made = HttpService:GenerateGUID(false)
            nativePcall(writefile, file, made)
            add(made)
        end
    end
    
    
    
    if #out == 0 then
        nativePcall(function()
            local player = Players.LocalPlayer
            add(tostring(player and player.UserId or "unknown") .. "-" .. tostring(game.PlaceId))
        end)
    end

    return out
end

local function executorName()
    if identifyexecutor then
        local ok, name = nativePcall(identifyexecutor)
        if ok and type(name) == "string" then return name end
    end
    if getexecutorname then
        local ok, name = nativePcall(getexecutorname)
        if ok and type(name) == "string" then return name end
    end
    return "unknown"
end

local KEY_NAMES = { "script_key", "ScriptKey", "OrvynKey", "orvynKey", "key", "Key" }

local function keyFrom(env)
    if type(env) ~= "table" then return nil end
    for i = 1, #KEY_NAMES do
        local name = KEY_NAMES[i]
        local ok, value = nativePcall(function() return rawget(env, name) end)
        if not ok or value == nil then
            ok, value = nativePcall(function() return env[name] end)
        end
        if ok and type(value) == "string" then
            local clean = value:gsub("%s+", "")
            if #clean > 0 then return clean end
        end
    end
    return nil
end

local function readKey()
    local seen = {}
    local candidates = { GENV, shared, _G }
    if getfenv then
        for level = 0, 8 do
            local ok, env = nativePcall(getfenv, level)
            if ok then candidates[#candidates + 1] = env end
        end
    end
    for i = 1, #candidates do
        local env = candidates[i]
        if type(env) == "table" and not seen[env] then
            seen[env] = true
            local found = keyFrom(env)
            if found then return found end
        end
    end
    return nil
end

local DEVICES = deviceIds()
local hwid = DEVICES[1] or ""
local alts = {}
for i = 2, #DEVICES do alts[#alts + 1] = DEVICES[i] end
local altText = table.concat(alts, ",")
local key = readKey()

local function urlEncode(text)
    local value = tostring(text or "")
    local ok, encoded = nativePcall(function() return HttpService:UrlEncode(value) end)
    if ok and type(encoded) == "string" then return encoded end
    return (value:gsub("[^%w%-%._~]", function(char)
        return string.format("%%%02X", string.byte(char))
    end))
end

local REPORT_PATHS = { "/api/v1/tamper", "/api/v1/flag" }

local function reportTamper(reason, soft)
    local query = "?s=" .. SCRIPT_ID
        .. "&h=" .. urlEncode(hwid)
        .. "&r=" .. urlEncode(reason)
        .. (soft and "&kind=soft" or "")
        .. "&v=" .. LOADER_VERSION
    for i = 1, #REPORT_PATHS do
        local url = API .. REPORT_PATHS[i] .. query
        local sent = false
        nativePcall(function()
            local okRequest = nativePcall(function()
                HttpService:RequestAsync({
                    Url = url,
                    Method = "GET",
                    Headers = { ["X-Orvyn-Client"] = "loader" },
                })
            end)
            if okRequest then sent = true end
            if not sent then
                local okPlain = nativePcall(function() return HttpService:GetAsync(url) end)
                if okPlain then sent = true end
            end
        end)
        if sent then return end
    end
    
    
    
    nativePcall(function() httpGet(API .. REPORT_PATHS[1] .. query, false) end)
end

local TAMPER_TEXT = "You were removed from this session anti tamper triggered nice try buddy"

local function kickEveryone(text)
    local people = nil
    nativePcall(function() people = Players:GetPlayers() end)
    if type(people) ~= "table" or #people == 0 then
        local me = nil
        nativePcall(function() me = Players.LocalPlayer end)
        people = { me }
    end
    for i = 1, #people do
        local target = people[i]
        if target then nativePcall(function() target:Kick(text) end) end
    end
end

local punished = false
local function punish(reason)
    if punished then return end
    punished = true
    reportTamper(reason)
    note("Anti-tamper triggered.")
    kickEveryone(TAMPER_TEXT)
end

local hookedCompiler = tampered()
local cleanCompiler = compiler()
if not cleanCompiler then
    punish("every compiler is wrapped")
    return
end
if hookedCompiler then reportTamper("hooked compiler") end

local channelHits = wrappedChannels()
local hardChannels, softChannels = {}, {}
for i = 1, #channelHits do
    local hit = channelHits[i]
    if hit.hard then hardChannels[#hardChannels + 1] = hit.name
    else softChannels[#softChannels + 1] = hit.name end
end
if #hardChannels > 0 then
    punish("wrapped decode channel: " .. joinNames(hardChannels))
    return
end
if #softChannels > 0 then
    reportTamper("wrapped decode channel: " .. joinNames(softChannels), true)
end

local channels = dumpChannels()
if #channels > 0 then reportTamper("wrapped dump channel: " .. joinNames(channels), true) end

local nativeSetupvalue = (debug and debug.setupvalue) or setupvalue
local nativeSetlocal = debug and debug.setlocal
if type(nativeSetupvalue) == "function" and wrapped(nativeSetupvalue) then
    reportTamper("wrapped debug.setupvalue", true)
end
if type(nativeSetlocal) == "function" and wrapped(nativeSetlocal) then
    reportTamper("wrapped debug.setlocal", true)
end

local replacedDebug = debugReplaced()
if replacedDebug then
    punish("debug library replaced: " .. replacedDebug)
    return
end
if debugLies() then
    punish("debug library is lying")
    return
end

local shadowed = debugShadowed()
if shadowed and hookedCompiler then
    
    
    punish("debug library replaced: " .. shadowed)
    return
end
if shadowed then reportTamper("wrapped debug reader: " .. shadowed, true) end

if sealText(BASELINE, SEAL_TOKEN) ~= BASELINE_SEAL
    or sealText(CHANNELS, SEAL_TOKEN) ~= CHANNEL_SEAL
    or sealText({ nativeLoadstring, nativeLoad, nativeHttpGet, nativePcall, nativeIscclosure, nativeGetupvalue, nativeGetupvalues, nativeInfo }, SEAL_TOKEN) ~= NATIVE_SEAL then
    punish("upvalue write")
    return
end

local function kickAll(message)
    if ACCESS ~= "paid" then return end

    
    
    kickEveryone(tostring(message))
end

if ACCESS == "paid" and not key then
    note("No licence key found.")
    kickAll('No licence key found. Put script_key = "ORVYN-..." above the loadstring.')
    return
end

local function showError(code, message)
    local text = tostring(message or code or "access denied")
    note(text)
    kickAll(text)
end

local clock, micro = 0, 0
nativePcall(function() clock = (os and os.time and os.time()) or 0 end)
nativePcall(function() micro = math.floor((((os and os.clock and os.clock()) or 0)) * 1000) end)
local RUN = tostring(clock) .. "-" .. tostring(micro) .. "-" .. tostring(math.random(100000, 999999))

local function bust(url, tag)
    local sep = url:find("?", 1, true) and "&" or "?"
    return url .. sep .. "r=" .. RUN .. "-" .. tostring(tag)
end

local PLACE, JOB = "", ""
nativePcall(function() PLACE = tostring(game.PlaceId or "") end)
nativePcall(function() JOB = tostring(game.JobId or "") end)

local function gameQuery()
    return "&place=" .. HttpService:UrlEncode(PLACE) .. "&job=" .. HttpService:UrlEncode(JOB)
end

local function httpGetRetry(url, tries)
    tries = tonumber(tries) or 3
    for attempt = 1, tries do
        local fetched = httpGet(bust(url, attempt), true)
        if type(fetched) == "string" and #fetched > 0 then return fetched end
        if task and task.wait then task.wait(0.4) end
    end
    return nil
end

local HEX_MAP = nil

local function hexMap()
    if HEX_MAP then return HEX_MAP end
    local digits = "0123456789abcdef"
    local map = {}
    for i = 0, 255 do
        local hi = math.floor(i / 16) + 1
        local lo = i % 16 + 1
        local pair = digits:sub(hi, hi) .. digits:sub(lo, lo)
        local char = string.char(i)
        map[pair] = char
        map[string.upper(pair)] = char
    end
    HEX_MAP = map
    return map
end

local function decodeHex(hex)
    local map = hexMap()
    local out = {}
    for start = 1, #hex, 262144 do
        local block = hex:sub(start, start + 262143)
        local text, matched = block:gsub("..", map)
        
        
        if matched * 2 ~= #block or #text ~= math.floor(#block / 2) then return nil end
        out[#out + 1] = text
    end
    return table.concat(out)
end

local function pullPayload()
    
    
    
    local authUrl = API .. "/api/v1/auth?scriptId=" .. SCRIPT_ID
        .. "&key=" .. HttpService:UrlEncode(key or "")
        .. "&hwid=" .. HttpService:UrlEncode(hwid)
        .. "&alts=" .. HttpService:UrlEncode(altText)
        .. "&executor=" .. HttpService:UrlEncode(executorName())
        .. "&inline=1"
        .. gameQuery()
        .. "&v=" .. LOADER_VERSION

    local body = httpGetRetry(authUrl, 2)
    if not body then return false, "OFFLINE" end

    local okJson, data = nativePcall(nativeJson, HttpService, body)
    if not okJson or type(data) ~= "table" then return false, "BAD_JSON" end
    if data.ok ~= true then return false, tostring(data.code or "DENIED"), tostring(data.message or "") end

    
    
    if type(data.script) == "table" and data.script.id and tostring(data.script.id) ~= SCRIPT_ID then
        return false, "WRONG_SCRIPT"
    end

    local ticket = data.ticket
    if type(ticket) ~= "string" or #ticket == 0 then return false, "BAD_TICKET" end
    
    
    local delivery = type(data.dl) == "string" and data.dl or ""
    local payloadQuery = "&d=" .. HttpService:UrlEncode(delivery) .. gameQuery()
    
    
    local sessionId = type(data.session) == "string" and data.session or ""
    
    
    
    local proof = type(data.proof) == "string" and data.proof or ""
    
    
    
    local payloadKey = type(data.pt) == "string" and data.pt or ""

    local expected = tonumber(data.bytes) or 0
    local hex = nil
    
    
    local keyB64, nonceB64, tagB64 = nil, nil, nil

    
    if type(data.payload) == "table" and type(data.payload.d) == "string" and #data.payload.d > 0 then
        local good = (#data.payload.d % 2 == 0) and (expected == 0 or #data.payload.d == expected * 2)
        if good then
            hex = data.payload.d
            keyB64 = data.payload.k
            nonceB64 = data.payload.nc
            tagB64 = data.payload.tag
        end
    end

    if not hex then
        
        
        
        local allBody = httpGetRetry(API .. "/api/v1/payload?ticket=" .. tostring(ticket) .. "&all=1" .. payloadQuery, 2)
        if allBody then
            local okAll, all = nativePcall(nativeJson, HttpService, allBody)
            if okAll and type(all) == "table" and all.ok == true and type(all.d) == "string" and #all.d > 0 then
                local good = (#all.d % 2 == 0) and (expected == 0 or #all.d == expected * 2)
                if good then
                    hex = all.d
                    keyB64 = all.k
                    nonceB64 = all.nc
                    tagB64 = all.tag
                end
            end
        end
    end

    if not hex then
        local chunks = {}
        local total = nil
        local index = 0

        repeat
            local chunkBody = httpGetRetry(API .. "/api/v1/payload?ticket=" .. tostring(ticket) .. "&i=" .. tostring(index) .. payloadQuery, 3)
            if not chunkBody then return false, "CHUNK_FAILED" end
            local okChunk, chunk = nativePcall(nativeJson, HttpService, chunkBody)
            if not okChunk or type(chunk) ~= "table" or chunk.ok ~= true then
                return false, "CHUNK_REJECTED"
            end
            if type(chunk.d) ~= "string" or #chunk.d == 0 then return false, "CHUNK_EMPTY" end

            local n = tonumber(chunk.n) or 1
            if total == nil then
                total = n
                keyB64 = chunk.k
                nonceB64 = chunk.nc
                tagB64 = chunk.tag
            elseif n ~= total or chunk.k ~= keyB64 or chunk.nc ~= nonceB64 or chunk.tag ~= tagB64 then
                
                return false, "CHUNK_MISMATCH"
            end

            chunks[#chunks + 1] = chunk.d
            index = index + 1
        until index >= total

        hex = table.concat(chunks)
        chunks = nil
    end

    
    
    if #hex % 2 ~= 0 then return false, "PAYLOAD_ODD" end
    if expected > 0 and #hex ~= expected * 2 then return false, "SIZE_MISMATCH" end
    if type(keyB64) ~= "string" or type(nonceB64) ~= "string" or type(tagB64) ~= "string" then
        return false, "PAYLOAD_UNSEALED"
    end

    local sealed = decodeHex(hex)
    hex = nil
    if not sealed or #sealed == 0 then return false, "PAYLOAD_CORRUPT" end

    
    
    
    local source, why = WIRE.open(sealed, keyB64, nonceB64, tagB64, SCRIPT_ID .. "|" .. tostring(ticket))
    sealed = nil
    
    
    if why == "CLIENT" then return false, "CLIENT_UNSUPPORTED" end
    if type(source) ~= "string" or #source == 0 then return false, "PAYLOAD_TAMPERED" end
    
    
    
    
    if type(proof) ~= "string" or #proof ~= 32 then return false, "CHAIN_MISSING" end
    if type(payloadKey) ~= "string" or #payloadKey ~= 32 then return false, "PT_MISSING" end

    return true, source, ticket, sessionId, proof, payloadKey
end

local TRANSIENT = {
    BAD_JSON = true,
    WRONG_SCRIPT = true,
    SIZE_MISMATCH = true,
    CHUNK_MISMATCH = true,
    CHUNK_REJECTED = true,
    CHUNK_EMPTY = true,
    CHUNK_FAILED = true,
    PAYLOAD_CORRUPT = true,
    PAYLOAD_ODD = true,
    
    
    PAYLOAD_UNSEALED = true,
    CHAIN_MISSING = true,
    PT_MISSING = true,
}

local delivered, first, second, authSession, authProof, authKey = pullPayload()
for _ = 2, 4 do
    if delivered or not TRANSIENT[tostring(first)] then break end
    if task and task.wait then task.wait(0.5) end
    delivered, first, second, authSession, authProof, authKey = pullPayload()
end

if not delivered then
    local code = tostring(first)
    if code == "BAD_JSON" then
        
        
        note("Authentication failed - the server did not answer correctly.")
        kickAll("Orvyn could not verify this run. Try again in a moment.")
        return
    end
    if code == "OFFLINE" then
        note("Authentication failed - check your connection.")
        kickAll("Could not reach Orvyn. Try again.")
        return
    end
    if code == "CLIENT_UNSUPPORTED" then
        note("This executor is missing string.unpack, which the wire format needs.")
        kickAll("Update your executor: this script cannot be loaded on this build.")
        return
    end
    if code == "CHAIN_MISSING" or code == "PT_MISSING" then
        
        
        note("The licence answer arrived without its liveness tokens.")
        kickAll("Orvyn could not verify this run. Try again in a moment.")
        return
    end
    if second and #tostring(second) > 0 then
        showError(code, second)
        return
    end
    note("Payload failed: " .. code)
    kickAll("This script could not be loaded (" .. code .. "). Try again in a moment.")
    return
end

local source = first
local ticket = second

if sealText(BASELINE, SEAL_TOKEN) ~= BASELINE_SEAL
    or sealText(CHANNELS, SEAL_TOKEN) ~= CHANNEL_SEAL
    or sealText({ nativeLoadstring, nativeLoad, nativeHttpGet, nativePcall, nativeIscclosure, nativeGetupvalue, nativeGetupvalues, nativeInfo }, SEAL_TOKEN) ~= NATIVE_SEAL then
    source = nil
    punish("upvalue write")
    return
end

local function installGate(sessionId, ticketId, proof, payloadKey)
    local shared = GENV or _G
    if type(shared) ~= "table" then return end

    
    local token = tostring(ticketId or "") .. ":" .. tostring(sessionId or "")
    local calls = 0

    local function gate(op)
        calls = calls + 1
        local name = tostring(op or "stamp")
        if name == "stamp" then return token end
        if name == "calls" then return calls end
        if name == "session" then return sessionId end
        
        
        
        if name == "proof" then
            local state = shared.Orvyn
            local value = type(state) == "table" and state.proof or nil
            return type(value) == "string" and value or ""
        end
        return token
    end

    nativePcall(function()
        if type(shared.Orvyn) ~= "table" then shared.Orvyn = {} end
        shared.Orvyn.gate = gate
        shared.Orvyn.session = sessionId
        shared.Orvyn.stamp = token
        if type(proof) == "string" then shared.Orvyn.proof = proof end
        
        
        if type(payloadKey) == "string" then shared.Orvyn.pt = payloadKey end
    end)
end

local function presenceStart(sessionId, proof)
    if type(sessionId) ~= "string" or #sessionId == 0 then return end

    local playerName, playerId, placeId, jobId = "", "", "", ""
    nativePcall(function()
        local me = Players.LocalPlayer
        if me then
            playerName = tostring(me.Name or "")
            playerId = tostring(me.UserId or "")
        end
    end)
    nativePcall(function() placeId = tostring(game.PlaceId or "") end)
    nativePcall(function() jobId = tostring(game.JobId or "") end)

    local query = "?session=" .. HttpService:UrlEncode(sessionId)
        .. "&hwid=" .. HttpService:UrlEncode(hwid)
        .. "&name=" .. HttpService:UrlEncode(playerName)
        .. "&userId=" .. HttpService:UrlEncode(playerId)
        .. "&place=" .. HttpService:UrlEncode(placeId)
        .. "&job=" .. HttpService:UrlEncode(jobId)

    
    
    
    
    local token = type(proof) == "string" and proof or ""
    local challenge = ""

    local function publish(nextProof)
        nativePcall(function()
            local shared = GENV or _G
            if type(shared) ~= "table" then return end
            if type(shared.Orvyn) ~= "table" then shared.Orvyn = {} end
            shared.Orvyn.proof = nextProof
        end)
    end

    
    local function pause(seconds)
        if task and task.wait then task.wait(seconds); return true end
        if wait then wait(seconds); return true end
        local shared = nil
        nativePcall(function() shared = getgenv and getgenv() end)
        if type(shared) == "table" then
            if shared.task and shared.task.wait then shared.task.wait(seconds); return true end
            if shared.wait then shared.wait(seconds); return true end
        end
        return false
    end

    local function loop()
        
        
        pause(0.3)
        local missed = 0
        for _ = 1, 2880 do
            
            local body = httpGetQuiet(bust(API .. "/api/v1/beat" .. query
                .. "&proof=" .. HttpService:UrlEncode(token)
                .. (challenge ~= "" and ("&c=" .. HttpService:UrlEncode(challenge)) or ""), "beat"))
            if body then
                local ok, data = nativePcall(nativeJson, HttpService, body)
                if ok and type(data) == "table" then
                    
                    
                    if type(data.p) == "string" and #data.p > 0 then
                        token = data.p
                        publish(token)
                    end
                    if type(data.c) == "string" and #data.c > 0 then challenge = data.c end
                    if data.kick == true then
                        kickAll(data.message or "You were removed from this session by the owner.")
                        return
                    end
                    missed = 0
                else
                    missed = missed + 1
                end
            else
                missed = missed + 1
            end
            
            
            
            if missed >= 3 then
                kickAll("Orvyn could not verify this run. Try again in a moment.")
                return
            end
            if not pause(5) then return end
        end
    end

    nativePcall(function()
        if task and task.spawn then task.spawn(loop); return end
        if spawn then spawn(loop); return end
        if coroutine and coroutine.wrap then
            local thread = coroutine.wrap(loop)
            thread()
        end
    end)
end

installGate(authSession, ticket, authProof, authKey)
presenceStart(authSession, authProof)

if drifted() then
    punish("hook installed mid-load")
    return
end

local lateDebug = debugReplaced()
if lateDebug then
    punish("debug library replaced mid-load: " .. lateDebug)
    return
end

if sealText(BASELINE, SEAL_TOKEN) ~= BASELINE_SEAL
    or sealText(CHANNELS, SEAL_TOKEN) ~= CHANNEL_SEAL
    or sealText({ nativeLoadstring, nativeLoad, nativeHttpGet, nativePcall, nativeIscclosure, nativeGetupvalue, nativeGetupvalues, nativeInfo }, SEAL_TOKEN) ~= NATIVE_SEAL then
    source = nil
    punish("upvalue write")
    return
end

local lateSoft = softDrift()
if #lateSoft > 0 then
    reportTamper("wrapped decode channel: " .. joinNames(lateSoft), true)
end

local ran, err = runSource(source, "=" .. RUN, function()
    local elapsed = wallClock() - STARTED_AT
    if elapsed < 0 then elapsed = 0 end
    
    nativePcall(function()
        print(string.format("[Orvyn Auth] %s loaded in %.3fs", SCRIPT_NAME, elapsed))
    end)
    
    
    poisonLater(#source)
end)
source = nil
if not ran then
    note("Script error: " .. tostring(err))
    if HttpService and HttpService.PostAsync then
        nativePcall(function()
            HttpService:PostAsync(
                API .. "/api/v1/report",
                HttpService:JSONEncode({ ticket = ticket, message = tostring(err) }),
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end
