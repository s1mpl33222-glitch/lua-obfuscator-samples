--[[
    Frosted Loader

    loadstring(game:HttpGet("https://frosted.run/s/frosted"))()            -- every time
    loadstring(game:HttpGet("https://frosted.run/s/frosted"))("YOUR-KEY")  -- once, to activate

    This is the public loader. It holds no script code and no licence key: it reads your key
    from Frosted/key.txt in your executor's workspace and asks the server for the rest.
    Get your key from https://frosted.run/panel. Scripts are free for everyone on Saturday and Sunday.
]]

local ListGame = {
	--["GameId"] = "Game Name",
	["4827308727"] = "Havoc",
	["4762958317"] = "Sword Art: Eternity",
	["10764627709"] = "Huss Valley",
}

-- Games that only run in some of their places: the rest of that universe (a lobby, another
-- floor) gets a notice telling the user where to run it, never a kick.
local ListPlaces = {
	["4762958317"] = { [108438460215241] = true },
}
local ListHints = {
	["4762958317"] = "Sword Art: Eternity runs on Floor 1 only. The Link Start lobby and Floor 2 are not supported yet.",
}

-- Frosted's own SHA-256 / HMAC / ChaCha20, for the sealed handshake below. Inlined rather than
-- fetched so the loader needs no second download before it can even ask for the script, and
-- deliberately not the executor's own crypt library: see src/lua/wlcrypto.luau for why.
local Crypto = (function()
	-- Frosted's own crypto, in plain Luau, for the loader.
	--
	-- WHY ITS OWN AND NOT THE EXECUTOR'S. Executors disagree about what `crypt` offers: some have
	-- AES-CBC, some base64 only, some nothing, and several have shipped versions where `crypt.hash`
	-- returned the wrong thing. Depending on any of it means the licence handshake works on some
	-- executors and silently fails on others -- the exact failure this whole design is built to avoid.
	-- Three hundred lines of Lua that behave identically everywhere are worth more than a feature
	-- detection tree.
	--
	-- WHY CHACHA20 AND NOT AES. Measured, not assumed, on this machine's Luau:
	--     SHA-256 over 900 kB ........ 0.14 s
	--     ChaCha20 over 900 kB ....... 0.30 s
	-- AES in pure Lua is an order of magnitude worse, and the executors that expose a native AES
	-- disagree on mode, padding and encoding. ChaCha20 is a 20-round ARX cipher built from exactly the
	-- operations bit32 gives us, so one implementation covers every executor -- including the weak ones
	-- this system must never lock out.
	--
	-- These primitives are standard and checked against the published test vectors (RFC 6234 for
	-- SHA-256, RFC 4231 for HMAC, RFC 8439 for ChaCha20) in test/luacrypto.test.mjs, which runs this
	-- very file. Do not "optimise" anything here without re-running that suite: a cipher that is subtly
	-- wrong still produces bytes, and the only thing that notices is a customer who cannot load.

	local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
	local lsh, rsh, rrot = bit32.lshift, bit32.rshift, bit32.rrotate
	local byte, char, rep, sub, format = string.byte, string.char, string.rep, string.sub, string.format
	local concat, unpack = table.concat, table.unpack

	local M = {}

	-- ---------------------------------------------------------------- SHA-256

	local K256 = {
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
	}

	--- SHA-256 of a byte string, as 32 raw bytes.
	function M.sha256(msg)
		local h0, h1, h2, h3 = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
		local h4, h5, h6, h7 = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
		local len = #msg
		-- padding: 0x80, zeros to 56 mod 64, then the length in bits as a 64-bit big-endian number
		local bits = len * 8
		local hi = math.floor(bits / 0x100000000)
		local lo = bits % 0x100000000
		msg = msg .. "\128" .. rep("\0", (55 - len) % 64) .. char(
			band(rsh(hi, 24), 255), band(rsh(hi, 16), 255), band(rsh(hi, 8), 255), band(hi, 255),
			band(rsh(lo, 24), 255), band(rsh(lo, 16), 255), band(rsh(lo, 8), 255), band(lo, 255))

		local w = table.create and table.create(64) or {}
		for pos = 1, #msg, 64 do
			for i = 1, 16 do
				local p = pos + (i - 1) * 4
				local a, b, c, d = byte(msg, p, p + 3)
				w[i] = lsh(a, 24) + lsh(b, 16) + lsh(c, 8) + d
			end
			for i = 17, 64 do
				local v15, v2 = w[i - 15], w[i - 2]
				local s0 = bxor(rrot(v15, 7), rrot(v15, 18), rsh(v15, 3))
				local s1 = bxor(rrot(v2, 17), rrot(v2, 19), rsh(v2, 10))
				w[i] = band(w[i - 16] + s0 + w[i - 7] + s1, 0xFFFFFFFF)
			end
			local a, b, c, d, e, f, g, h = h0, h1, h2, h3, h4, h5, h6, h7
			for i = 1, 64 do
				local S1 = bxor(rrot(e, 6), rrot(e, 11), rrot(e, 25))
				local ch = bxor(band(e, f), band(bnot(e), g))
				local t1 = band(h + S1 + ch + K256[i] + w[i], 0xFFFFFFFF)
				local S0 = bxor(rrot(a, 2), rrot(a, 13), rrot(a, 22))
				local mj = bxor(band(a, b), band(a, c), band(b, c))
				local t2 = band(S0 + mj, 0xFFFFFFFF)
				h = g; g = f; f = e
				e = band(d + t1, 0xFFFFFFFF)
				d = c; c = b; b = a
				a = band(t1 + t2, 0xFFFFFFFF)
			end
			h0 = band(h0 + a, 0xFFFFFFFF); h1 = band(h1 + b, 0xFFFFFFFF)
			h2 = band(h2 + c, 0xFFFFFFFF); h3 = band(h3 + d, 0xFFFFFFFF)
			h4 = band(h4 + e, 0xFFFFFFFF); h5 = band(h5 + f, 0xFFFFFFFF)
			h6 = band(h6 + g, 0xFFFFFFFF); h7 = band(h7 + h, 0xFFFFFFFF)
		end

		local out = {}
		local hs = { h0, h1, h2, h3, h4, h5, h6, h7 }
		for i = 1, 8 do
			local v = hs[i]
			out[i] = char(band(rsh(v, 24), 255), band(rsh(v, 16), 255), band(rsh(v, 8), 255), band(v, 255))
		end
		return concat(out)
	end

	--- Lowercase hex of a byte string.
	function M.hex(s)
		local out = {}
		for i = 1, #s do out[i] = format("%02x", byte(s, i)) end
		return concat(out)
	end

	--- Bytes from lowercase or uppercase hex, or nil if it is not hex.
	function M.unhex(s)
		if #s % 2 ~= 0 or s:find("[^0-9a-fA-F]") then return nil end
		local out = {}
		for i = 1, #s, 2 do out[#out + 1] = char(tonumber(sub(s, i, i + 1), 16)) end
		return concat(out)
	end

	-- ---------------------------------------------------------------- HMAC-SHA256

	--- HMAC-SHA256, 32 raw bytes out. Keys longer than the 64-byte block are hashed first, per RFC 2104.
	function M.hmac(key, msg)
		if #key > 64 then key = M.sha256(key) end
		key = key .. rep("\0", 64 - #key)
		local inner, outer = {}, {}
		for i = 1, 64 do
			local k = byte(key, i)
			inner[i] = char(bxor(k, 0x36))
			outer[i] = char(bxor(k, 0x5c))
		end
		return M.sha256(concat(outer) .. M.sha256(concat(inner) .. msg))
	end

	-- ---------------------------------------------------------------- ChaCha20

	-- The eight quarter-rounds of one double round, as index quadruples (columns then diagonals).
	local QROUND = {
		{ 1, 5, 9, 13 }, { 2, 6, 10, 14 }, { 3, 7, 11, 15 }, { 4, 8, 12, 16 },
		{ 1, 6, 11, 16 }, { 2, 7, 12, 13 }, { 3, 8, 9, 14 }, { 4, 5, 10, 15 },
	}

	local function rotl(v, n)
		return band(bxor(lsh(v, n), rsh(v, 32 - n)), 0xFFFFFFFF)
	end

	local function le32(s, i)
		local a, b, c, d = byte(s, i, i + 3)
		return a + lsh(b, 8) + lsh(c, 16) + lsh(d, 24)
	end

	--- One 64-byte ChaCha20 block, written into `out` as 64 byte values.
	local function chachaBlock(st, out)
		local x = {
			st[1], st[2], st[3], st[4], st[5], st[6], st[7], st[8],
			st[9], st[10], st[11], st[12], st[13], st[14], st[15], st[16],
		}
		for _ = 1, 10 do
			for q = 1, 8 do
				local Q = QROUND[q]
				local a, b, c, d = Q[1], Q[2], Q[3], Q[4]
				x[a] = band(x[a] + x[b], 0xFFFFFFFF); x[d] = rotl(bxor(x[d], x[a]), 16)
				x[c] = band(x[c] + x[d], 0xFFFFFFFF); x[b] = rotl(bxor(x[b], x[c]), 12)
				x[a] = band(x[a] + x[b], 0xFFFFFFFF); x[d] = rotl(bxor(x[d], x[a]), 8)
				x[c] = band(x[c] + x[d], 0xFFFFFFFF); x[b] = rotl(bxor(x[b], x[c]), 7)
			end
		end
		for i = 1, 16 do
			local v = band(x[i] + st[i], 0xFFFFFFFF)
			local o = (i - 1) * 4
			out[o + 1] = band(v, 255)
			out[o + 2] = band(rsh(v, 8), 255)
			out[o + 3] = band(rsh(v, 16), 255)
			out[o + 4] = band(rsh(v, 24), 255)
		end
	end

	--- ChaCha20 (RFC 8439) over `data`: 32-byte key, 12-byte nonce, 32-bit starting counter.
	--- The cipher is its own inverse, so this both encrypts and decrypts.
	--- Chunked at 4 kB so string.char is never called with more arguments than it will take.
	function M.chacha20(key, nonce, counter, data)
		assert(#key == 32, "chacha20 key must be 32 bytes")
		assert(#nonce == 12, "chacha20 nonce must be 12 bytes")
		local st = {
			0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
			le32(key, 1), le32(key, 5), le32(key, 9), le32(key, 13),
			le32(key, 17), le32(key, 21), le32(key, 25), le32(key, 29),
			counter, le32(nonce, 1), le32(nonce, 5), le32(nonce, 9),
		}
		local ks = table.create and table.create(64) or {}
		local parts, np = {}, 0
		local total = #data
		local pos = 1
		while pos <= total do
			local stop = math.min(pos + 4095, total)
			local n = stop - pos + 1
			local b = { byte(data, pos, stop) }
			local done = 0
			local blockIndex = (pos - 1) // 64
			while done < n do
				st[13] = band(counter + blockIndex + (done // 64), 0xFFFFFFFF)
				chachaBlock(st, ks)
				local lim = math.min(64, n - done)
				for j = 1, lim do
					b[done + j] = bxor(b[done + j], ks[j])
				end
				done = done + 64
			end
			np = np + 1
			parts[np] = char(unpack(b, 1, n))
			pos = stop + 1
		end
		return concat(parts)
	end

	-- ---------------------------------------------------------------- base64 (decode only)

	local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local B64INV = {}
	for i = 1, 64 do B64INV[byte(B64, i)] = i - 1 end
	B64INV[byte("-")] = 62   -- accept url-safe, so a token can travel in a query string
	B64INV[byte("_")] = 63

	--- Bytes from base64 (standard or url-safe, padding optional), or nil if it is not base64.
	function M.unbase64(s)
		s = s:gsub("[=%s]", "")
		local out, no = {}, 0
		local acc, bits = 0, 0
		for i = 1, #s do
			local v = B64INV[byte(s, i)]
			if v == nil then return nil end
			acc = lsh(acc, 6) + v
			bits = bits + 6
			if bits >= 8 then
				bits = bits - 8
				no = no + 1
				out[no] = char(band(rsh(acc, bits), 255))
			end
		end
		return concat(out)
	end

	--- True only if both strings are the same length and every byte matches. Not constant time -- Luau
	--- gives no way to be, and nothing here is a secret an attacker gets to probe repeatedly: a wrong
	--- MAC means this device's own download was tampered with, and the answer is to fall back.
	function M.equal(a, b)
		if #a ~= #b then return false end
		local diff = 0
		for i = 1, #a do diff = bit32.bor(diff, bxor(byte(a, i), byte(b, i))) end
		return diff == 0
	end

	-- ---------------------------------------------------------------- the Frosted envelope

	--- The per-run content key, derived exactly as the server derives it. Everything that identifies
	--- this run is in here, so a key derived for another device, another handshake or another epoch
	--- produces different bytes and the MAC below fails.
	function M.deriveK(licenceKey, ep, hwid, cn, sn, ct)
		return M.hmac(licenceKey, "frosted/k1/" .. ep .. "|" .. hwid .. "|" .. cn .. "|" .. sn .. "|" .. ct)
	end

	--- Opens what /s/auth returned. `header` is the parsed first line, `body` the raw ciphertext.
	--- Returns the Lua source, or nil plus a reason -- and a reason always means "fall back to the
	--- plain path", never "show the user an error".
	function M.open(env, body, K, cn, sn)
		local nonce = sub(M.sha256(sn .. "|" .. cn), 1, 12)
		-- The seal MAC is checked BEFORE anything is decrypted: a wrong licence key, a wrong device or a
		-- replayed handshake fails here, loudly, instead of yielding plausible garbage.
		if not M.equal(env.smac, M.hmac(K, env.sealed .. env.pre .. "|" .. env.ep .. "|" .. cn .. "|" .. sn)) then
			return nil, "seal"
		end
		local CK = M.chacha20(K, nonce, 0, env.sealed)
		if #CK ~= 32 then return nil, "ck" end
		-- Encrypt-then-MAC: the body's integrity is checked before it is decrypted, let alone run.
		if not M.equal(env.bmac, M.hmac(M.hmac(CK, "frosted/mac/1"), body)) then
			return nil, "body"
		end
		-- The per-run prologue (the licence heartbeat and its lease token) rides at counter 1 under the
		-- same key and nonce as the seal, and is prepended to the payload it belongs to.
		local prologue = #env.pre > 0 and M.chacha20(K, nonce, 1, env.pre) or ""
		local bodyNonce = sub(M.sha256("frosted/epoch/" .. env.ep), 1, 12)
		return prologue .. M.chacha20(CK, bodyNonce, 1, body), nil
	end

	return M

end)()

local ARGS = {...}
local ORIGIN = "https://frosted.run"
local KEYFILE = "Frosted/key.txt"
local DEVICEFILE = "Frosted/device.txt"
-- Where those two lived before everything moved into the Frosted folder. Read once, moved over.
local OLD_KEYFILE = "frosted_key.txt"
local OLD_DEVICEFILE = "frosted_device.txt"
local Players = game:GetService("Players")

local function FrostedIntroBasic()

	local built, intro = pcall(function()
		local RunService = game:GetService("RunService")
		local TextService = game:GetService("TextService")
		local HttpService = game:GetService("HttpService")
		local camera = workspace.CurrentCamera
		local vp = camera and camera.ViewportSize or Vector2.new(1920, 1080)
		if vp.X < 50 or vp.Y < 50 then vp = Vector2.new(1920, 1080) end
		local W, H = vp.X, vp.Y
		local S = math.clamp(H / 1080, 0.5, 2)
		local rng = Random.new()
		local function r(a, b) return rng:NextNumber(a, b) end
		local now = os.clock

		local SNOW = Color3.fromRGB(244, 250, 255)
		local ICE = Color3.fromRGB(196, 230, 255)
		local ICE_MID = Color3.fromRGB(150, 205, 255)
		local ICE_DEEP = Color3.fromRGB(80, 160, 255)
		local NIGHT = Color3.fromRGB(4, 8, 16)

		local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
		local FONT_UI = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)

		local function new(class, props)
			local o = Instance.new(class)
			local parent = props.Parent
			props.Parent = nil
			for k, v in pairs(props) do o[k] = v end
			if parent then o.Parent = parent end
			return o
		end
		local function corner(o, scale) new("UICorner", { CornerRadius = UDim.new(scale or 1, 0), Parent = o }) end
		local function seq(points)
			local kp = {}
			for _, p in ipairs(points) do kp[#kp + 1] = NumberSequenceKeypoint.new(p[1], p[2]) end
			return NumberSequence.new(kp)
		end
		local function cseq(points)
			local kp = {}
			for _, p in ipairs(points) do kp[#kp + 1] = ColorSequenceKeypoint.new(p[1], p[2]) end
			return ColorSequence.new(kp)
		end
		local function clamp01(x) return x < 0 and 0 or (x > 1 and 1 or x) end
		local function outCubic(x) x = clamp01(x) return 1 - (1 - x) ^ 3 end
		local function outQuint(x) x = clamp01(x) return 1 - (1 - x) ^ 5 end
		local function inOut(x) x = clamp01(x) return x < 0.5 and 4 * x ^ 3 or 1 - (-2 * x + 2) ^ 3 / 2 end
		local function outBack(x)
			x = clamp01(x)
			local c1 = 1.9
			return 1 + (c1 + 1) * (x - 1) ^ 3 + c1 * (x - 1) ^ 2
		end
		local function lerp(a, b, t) return a + (b - a) * t end

		--------------------------------------------------------------- the stage
		local gui = new("ScreenGui", {
			Name = HttpService:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false,
			DisplayOrder = 2147483000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		})
		pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
		local parented = false
		if type(gethui) == "function" then parented = pcall(function() gui.Parent = gethui() end) end
		if not parented then
			pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
			parented = pcall(function() gui.Parent = game:GetService("CoreGui") end)
		end
		if not parented then gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

		local fxParent = camera or game:GetService("Lighting")
		local blur = new("BlurEffect", { Name = "FrostedIntroBlur", Size = 0, Parent = fxParent })
		local grade = new("ColorCorrectionEffect", { Name = "FrostedIntroGrade", Parent = fxParent })

		-- Every object that fades with the frost: { instance, property, base transparency }.
		local fading = {}
		local function fades(o, prop, base)
			fading[#fading + 1] = { o, prop, base }
			return o
		end
		local frostAlpha = 0   -- 0 = clear, 1 = fully frozen; the outro brings it back down

		local function layer(z)
			return new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = z, Parent = gui })
		end
		local glass = new("Frame", {
			Size = UDim2.fromScale(1, 1), BackgroundColor3 = ICE_MID, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1, Parent = gui,
		})
		local night = new("Frame", {
			Size = UDim2.fromScale(1, 1), BackgroundColor3 = NIGHT, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = gui,
		})
		-- darker toward the middle, so the word reads on any game
		new("UIGradient", { Transparency = seq({ { 0, 0.55 }, { 0.5, 0 }, { 1, 0.55 } }), Rotation = 90, Parent = night })
		local frostLayer = layer(3)
		local veinLayer = layer(4)
		local sparkLayer = layer(5)
		local snowLayer = layer(6)
		local wordLayer = layer(7)
		local burstLayer = layer(8)
		local flash = new("Frame", {
			Size = UDim2.fromScale(1, 1), BackgroundColor3 = SNOW, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 9, Parent = gui,
		})
		local shardLayer = layer(10)

		--------------------------------------------------------------- frost creeping in from the edges
		-- Soft edge bands, then a cloud of overlapping frost patches that appear from the edge inward.
		local edges = {}
		for side = 1, 4 do
			local f = new("Frame", { BackgroundColor3 = SNOW, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 1, Parent = frostLayer })
			new("UIGradient", {
				Rotation = ({ 0, 180, 90, -90 })[side],
				Color = cseq({ { 0, SNOW }, { 1, ICE } }),
				Transparency = seq({ { 0, 0.18 }, { 0.3, 0.55 }, { 0.65, 0.86 }, { 1, 1 } }),
				Parent = f,
			})
			edges[side] = f
		end
		local function layoutEdges(k)
			local dx, dy = W * 0.24 * k, H * 0.3 * k
			edges[1].Position, edges[1].Size = UDim2.fromOffset(0, 0), UDim2.fromOffset(dx, H)
			edges[2].Position, edges[2].Size = UDim2.fromOffset(W - dx, 0), UDim2.fromOffset(dx, H)
			edges[3].Position, edges[3].Size = UDim2.fromOffset(0, 0), UDim2.fromOffset(W, dy)
			edges[4].Position, edges[4].Size = UDim2.fromOffset(0, H - dy), UDim2.fromOffset(W, dy)
		end
		layoutEdges(0)

		local function edgeDist(x, y) return math.min(x, W - x, y, H - y) end
		local function edgePoint()
			-- a point near the border, denser toward the corners
			local side = rng:NextInteger(1, 4)
			local t = rng:NextNumber()
			t = t < 0.5 and (t * 2) ^ 1.6 / 2 or 1 - ((1 - t) * 2) ^ 1.6 / 2
			local depth = r(0, 1) ^ 2.2 * math.min(W, H) * 0.24
			if side == 1 then return depth, t * H end
			if side == 2 then return W - depth, t * H end
			if side == 3 then return t * W, depth end
			return t * W, H - depth
		end

		local patches = {}
		for i = 1, 150 do
			local x, y = edgePoint()
			local d = edgeDist(x, y)
			local sz = r(50, 190) * S * (1 - d / (math.min(W, H) * 0.4)) + 30 * S
			local p = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(sz, sz * r(0.6, 1)),
				Rotation = r(0, 180), BackgroundColor3 = rng:NextNumber() < 0.7 and SNOW or ICE, BackgroundTransparency = 1,
				BorderSizePixel = 0, ZIndex = 2, Parent = frostLayer,
			})
			corner(p)
			patches[i] = { o = p, base = r(0.8, 0.93), start = 0.05 + d / (math.min(W, H) * 0.24) * 0.9 + r(0, 0.25) }
		end

		--------------------------------------------------------------- ice crystals (branching veins)
		local segs = {}
		local MAX_SEGS = 560
		local SPEED = 430 * S
		local function branch(x, y, angle, len, depth, t0)
			if #segs >= MAX_SEGS or len < 6 * S then return end
			local thick = math.max(1, (0.7 + depth * 0.65) * S)
			local f = new("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(0, thick),
				Rotation = math.deg(angle), BackgroundColor3 = SNOW, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1,
				Parent = veinLayer,
			})
			new("UIGradient", { Transparency = seq({ { 0, 0 }, { 0.7, 0.25 }, { 1, 0.85 } }), Parent = f })
			local dur = len / SPEED
			local seg = { o = f, len = len, t0 = t0, dur = dur, base = 0.08 + (3 - depth) * 0.14, done = false }
			segs[#segs + 1] = seg
			fades(f, "BackgroundTransparency", seg.base)
			if depth <= 0 then return end
			local cx, cy = math.cos(angle), math.sin(angle)
			-- carry on from the tip, a little crooked
			branch(x + cx * len, y + cy * len, angle + math.rad(r(-18, 18)), len * r(0.55, 0.75), depth - 1, t0 + dur)
			-- and a pair of side shoots, the way frost feathers
			for _, sgn in ipairs({ -1, 1 }) do
				local f2 = r(0.3, 0.75)
				branch(x + cx * len * f2, y + cy * len * f2, angle + sgn * math.rad(r(38, 62)), len * r(0.35, 0.55), depth - 1, t0 + dur * f2)
			end
		end
		local perim = 2 * (W + H)
		local seeds = math.floor(perim / (175 * S))
		for i = 1, seeds do
			local d = (i - 1 + r(0, 0.8)) / seeds * perim
			local x, y, inward
			if d < W then x, y, inward = d, 0, math.pi / 2
			elseif d < W + H then x, y, inward = W, d - W, math.pi
			elseif d < 2 * W + H then x, y, inward = W - (d - W - H), H, -math.pi / 2
			else x, y, inward = 0, H - (d - 2 * W - H), 0 end
			-- near a corner the crystal grows diagonally out of it, longer
			local cornerNess = 1 - math.min(math.min(x, W - x) / (W * 0.18), math.min(y, H - y) / (H * 0.18), 1)
			local len = r(80, 170) * S * (1 + cornerNess * 0.9)
			branch(x, y, inward + math.rad(r(-35, 35)), len, 3, 0.08 + r(0, 0.45) * (1 - cornerNess * 0.7))
		end
		-- corner bursts
		for _, c in ipairs({ { 0, 0, 1, 1 }, { W, 0, -1, 1 }, { 0, H, 1, -1 }, { W, H, -1, -1 } }) do
			local base = math.atan2(c[4], c[3])
			for k = -2, 2 do
				branch(c[1], c[2], base + math.rad(k * 17 + r(-6, 6)), r(170, 260) * S, 3, 0.02 + math.abs(k) * 0.06)
			end
		end

		--------------------------------------------------------------- sparkles in the frost
		local sparks = {}
		for i = 1, 34 do
			local x, y = edgePoint()
			local sz = r(6, 16) * S
			local holder = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(sz, sz),
				BackgroundTransparency = 1, Rotation = r(0, 45), ZIndex = 1, Parent = sparkLayer,
			})
			local arms = {}
			for k = 0, 1 do
				local a = new("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
					Size = k == 0 and UDim2.new(1, 0, 0, math.max(1, S * 1.2)) or UDim2.new(0, math.max(1, S * 1.2), 1, 0),
					BackgroundColor3 = SNOW, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1, Parent = holder,
				})
				new("UIGradient", { Rotation = k * 90, Transparency = seq({ { 0, 1 }, { 0.5, 0 }, { 1, 1 } }), Parent = a })
				arms[#arms + 1] = a
			end
			sparks[i] = { arms = arms, w = r(1.5, 4), ph = r(0, 6.28), start = 0.5 + r(0, 1) }
		end

		--------------------------------------------------------------- falling snow (plus a few out-of-focus flakes up close)
		local flakes = {}
		for i = 1, 95 do
			local bokeh = i > 82
			local sz = bokeh and r(12, 26) * S or r(2, 6.5) * S
			local f = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(sz, sz), BackgroundColor3 = SNOW,
				BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = bokeh and 2 or 1, Parent = snowLayer,
			})
			corner(f)
			flakes[i] = {
				o = f, x = r(0, W), y = r(-H, H), vy = (bokeh and r(70, 120) or r(30, 110)) * S,
				amp = r(8, 30) * S, freq = r(0.4, 1.3), ph = r(0, 6.28),
				base = bokeh and r(0.82, 0.9) or r(0.15, 0.6),
			}
		end

		--------------------------------------------------------------- the wordmark
		local TEXT = "FROSTED"
		local TS = math.floor(math.min(W * 0.1, W * 0.84 / 5.7, 190 * S * 1.15))
		TS = math.max(TS, 40)
		local PAD = math.floor(TS * 0.3)
		local GAPW = TS * 0.045
		local widths, total = {}, 0
		for i = 1, #TEXT do
			local ch = TEXT:sub(i, i)
			local w
			pcall(function()
				local p = Instance.new("GetTextBoundsParams")
				p.Text, p.Font, p.Size, p.Width = ch, FONT, TS, 100000
				w = TextService:GetTextBoundsAsync(p).X
			end)
			if not w or w <= 0 then
				w = TextService:GetTextSize(ch, TS, Enum.Font.GothamBlack, Vector2.new(100000, 100000)).X
			end
			widths[i] = w
			total += w + (i > 1 and GAPW or 0)
		end
		local word = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.47),
			Size = UDim2.fromOffset(total, TS), BackgroundTransparency = 1, ZIndex = 1, Parent = wordLayer,
		})
		local wordScale = new("UIScale", { Scale = 1, Parent = word })

		local function label(parent, ch, z, props)
			local l = new("TextLabel", {
				BackgroundTransparency = 1, Size = UDim2.new(1, -PAD * 2, 1, -PAD * 2), Position = UDim2.fromOffset(PAD, PAD),
				Text = ch, FontFace = FONT, TextSize = TS, TextColor3 = SNOW, ZIndex = z, Parent = parent,
			})
			for k, v in pairs(props or {}) do l[k] = v end
			return l
		end

		local letters = {}
		local x = 0
		for i = 1, #TEXT do
			local ch, w = TEXT:sub(i, i), widths[i]
			local g = new("CanvasGroup", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x + w / 2, TS / 2),
				Size = UDim2.fromOffset(w + PAD * 2, TS + PAD * 2), BackgroundTransparency = 1, GroupTransparency = 1,
				ZIndex = 1, Parent = word,
			})
			local sc = new("UIScale", { Scale = 1.5, Parent = g })
			-- bloom: wide, faint strokes behind the glyph
			for k, th in ipairs({ 0.05, 0.1, 0.17 }) do
				local b = label(g, ch, 1, { TextColor3 = ICE_DEEP, TextTransparency = 0.6 })
				new("UIStroke", { Color = ICE_DEEP, Thickness = TS * th, Transparency = ({ 0.72, 0.85, 0.93 })[k], LineJoinMode = Enum.LineJoinMode.Round, Parent = b })
			end
			-- the ice block's depth: stacked copies sinking down and to the right
			for k = 6, 1, -1 do
				local t = k / 6
				label(g, ch, 2, {
					Position = UDim2.fromOffset(PAD + TS * 0.011 * k, PAD + TS * 0.014 * k),
					TextColor3 = Color3.fromRGB(lerp(78, 18, t), lerp(132, 40, t), lerp(210, 98, t)),
				})
			end
			-- the face: a cold vertical gradient with a bright rim
			local face = label(g, ch, 3)
			new("UIGradient", {
				Rotation = 90,
				Color = cseq({
					{ 0, Color3.fromRGB(252, 254, 255) }, { 0.4, Color3.fromRGB(200, 232, 255) },
					{ 0.52, Color3.fromRGB(162, 212, 255) }, { 0.8, Color3.fromRGB(196, 226, 255) }, { 1, Color3.fromRGB(122, 178, 246) },
				}),
				Parent = face,
			})
			new("UIStroke", { Color = Color3.fromRGB(236, 248, 255), Thickness = math.max(1, TS * 0.014), Transparency = 0.15, Parent = face })
			-- frosted streaks across the face
			local frost = label(g, ch, 4, { TextColor3 = SNOW })
			local kp, n = { { 0, r(0.55, 0.95) } }, 14
			for k = 1, n - 1 do kp[#kp + 1] = { k / n, r(0.5, 0.97) } end
			kp[#kp + 1] = { 1, r(0.55, 0.95) }
			new("UIGradient", { Rotation = r(25, 55), Transparency = seq(kp), Parent = frost })
			-- the light sweep
			local shine = label(g, ch, 5, { TextColor3 = Color3.new(1, 1, 1) })
			local shineGrad = new("UIGradient", {
				Rotation = 22, Offset = Vector2.new(-1.2, 0),
				Transparency = seq({ { 0, 1 }, { 0.42, 1 }, { 0.5, 0.05 }, { 0.58, 1 }, { 1, 1 } }),
				Parent = shine,
			})
			-- snow caps sitting on top of the glyph
			local caps = {}
			local lo, hi = 0.06, 0.94
			if ch == "O" or ch == "S" then lo, hi = 0.24, 0.76 end
			local count = math.max(2, math.floor(w / (TS * 0.12)))
			for k = 1, count do
				local s = TS * r(0.07, 0.12)
				local c = new("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.75),
					Position = UDim2.fromOffset(PAD + w * lerp(lo, hi, (k - 0.5) / count + r(-0.04, 0.04)), PAD + TS * ((ch == "O" or ch == "S") and 0.16 or 0.135) + r(-1, 1) * S),
					Size = UDim2.fromOffset(s * r(1.4, 2.1), s), BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 6, Parent = g,
				})
				corner(c)
				new("UIGradient", { Rotation = 90, Color = cseq({ { 0, Color3.new(1, 1, 1) }, { 1, ICE } }), Parent = c })
				local cs = new("UIScale", { Scale = 0, Parent = c })
				caps[#caps + 1] = { sc = cs, delay = r(0, 0.25) }
			end
			letters[i] = { g = g, sc = sc, shine = shineGrad, caps = caps, w = w, cx = x + w / 2, rot = r(-14, 14), start = 0.8 + (i - 1) * 0.085, landed = false }
			x += w + GAPW
		end

		-- a snowflake spinning inside the O
		local oL = letters[3]
		local flakeSize = TS * 0.3
		local flake = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(PAD + oL.w / 2, PAD + TS * 0.47),
			Size = UDim2.fromOffset(flakeSize, flakeSize), BackgroundTransparency = 1, ZIndex = 7, Parent = oL.g,
		})
		local flakeScale = new("UIScale", { Scale = 0, Parent = flake })
		local armT = math.max(1.5, TS * 0.026)
		for k = 0, 5 do
			local arm = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, armT, 0.5, 0),
				Rotation = k * 60, BackgroundColor3 = ICE, BorderSizePixel = 0, ZIndex = 7, Parent = flake,
			})
			corner(arm)
			for _, sgn in ipairs({ -1, 1 }) do
				new("Frame", {
					AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.42), Size = UDim2.new(0, armT * 0.85, 0.42, 0),
					Rotation = sgn * 42, BackgroundColor3 = ICE, BorderSizePixel = 0, ZIndex = 7, Parent = arm,
				})
			end
		end
		local hub = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(armT * 2.6, armT * 2.6),
			Rotation = 45, BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 8, Parent = flake,
		})
		corner(hub, 0.25)

		-- the streak of light across the word as the last letter lands
		local streak = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.47), Size = UDim2.fromOffset(0, math.max(2, 2.5 * S)),
			BackgroundColor3 = Color3.fromRGB(210, 238, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = wordLayer,
		})
		new("UIGradient", { Transparency = seq({ { 0, 1 }, { 0.5, 0 }, { 1, 1 } }), Parent = streak })

		-- status line and an ice progress bar under the word
		local underY = 0.47 + (TS * 0.5 + 34 * S) / H
		local status = new("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, underY), Size = UDim2.fromOffset(total, 20 * S),
			BackgroundTransparency = 1, FontFace = FONT_UI, TextSize = math.clamp(math.floor(15 * S), 11, 24),
			TextColor3 = ICE, TextTransparency = 1, Text = "", ZIndex = 1, Parent = wordLayer,
		})
		local barW = math.min(total * 0.42, 360 * S)
		local bar = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, underY, 30 * S), Size = UDim2.fromOffset(barW, math.max(2, 3 * S)),
			BackgroundColor3 = ICE, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1, Parent = wordLayer,
		})
		corner(bar)
		local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = SNOW, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = bar })
		corner(fill)
		new("UIGradient", { Color = cseq({ { 0, ICE_DEEP }, { 1, Color3.new(1, 1, 1) } }), Parent = fill })
		local function spaced(s)
			return (s:upper():gsub(".", "%0 "):gsub("%s+$", ""))
		end
		local statusText = "Loading"

		--------------------------------------------------------------- little ice chips when a letter lands
		local chips = {}
		local function burst(cx, cy, n)
			for _ = 1, n do
				local s = r(2, 5) * S
				local o = new("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(s, s * r(1, 2.2)), Rotation = r(0, 180),
					BackgroundColor3 = rng:NextNumber() < 0.5 and SNOW or ICE, BorderSizePixel = 0, ZIndex = 1, Parent = burstLayer,
				})
				local a = r(-math.pi, 0)
				local v = r(140, 380) * S
				chips[#chips + 1] = { o = o, x = cx, y = cy, vx = math.cos(a) * v, vy = math.sin(a) * v, spin = r(-540, 540), life = r(0.45, 0.8), age = 0 }
			end
		end

		--------------------------------------------------------------- the clock
		local t0 = now()
		local finishing, finishAt, finishedOk = false, nil, true
		local OUTRO = 1.05
		local MIN_HOLD = 2.75
		local cracks, shards = {}, {}
		local dead = false
		local conn
		local wcx, wcy = W / 2, H * 0.47

		local function cleanup()
			if dead then return end
			dead = true
			if conn then conn:Disconnect() end
			pcall(function() gui:Destroy() end)
			pcall(function() blur:Destroy() end)
			pcall(function() grade:Destroy() end)
		end

		local function startOutro()
			-- cracks race out from the word...
			for k = 1, 18 do
				local a = (k / 18) * math.pi * 2 + r(-0.12, 0.12)
				local px, py = wcx + math.cos(a) * total * 0.2, wcy + math.sin(a) * TS * 0.4
				local parts = {}
				local reach = math.sqrt(W * W + H * H) * r(0.35, 0.6)
				local left = reach
				while left > 0 do
					local l = math.min(left, r(60, 160) * S)
					a += r(-0.35, 0.35)
					local f = new("Frame", {
						AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(px, py), Size = UDim2.fromOffset(0, math.max(1, 2 * S)),
						Rotation = math.deg(a), BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 1, Parent = shardLayer,
					})
					parts[#parts + 1] = { o = f, len = l, at = (reach - left) / reach }
					px, py = px + math.cos(a) * l, py + math.sin(a) * l
					left -= l
				end
				cracks[#cracks + 1] = parts
			end
			-- ...and the sheet of ice breaks into shards that fly off the screen
			for _ = 1, 54 do
				local sx, sy = r(0, W), r(0, H)
				local w, h = r(40, 170) * S, r(20, 90) * S
				local o = new("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(sx, sy), Size = UDim2.fromOffset(w, h),
					Rotation = r(0, 180), BackgroundColor3 = ICE, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = shardLayer,
				})
				new("UIGradient", { Rotation = r(0, 180), Color = cseq({ { 0, Color3.new(1, 1, 1) }, { 1, ICE_MID } }), Transparency = seq({ { 0, 0.35 }, { 1, 0.75 } }), Parent = o })
				local stroke = new("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = math.max(1, S), Transparency = 1, Parent = o })
				local dx, dy = sx - wcx, sy - wcy
				local d = math.max(1, math.sqrt(dx * dx + dy * dy))
				local v = r(700, 1600) * S
				shards[#shards + 1] = { o = o, stroke = stroke, x = sx, y = sy, vx = dx / d * v, vy = dy / d * v - r(100, 300) * S, spin = r(-420, 420), rot = o.Rotation }
			end
		end

		local function step(dt)
			if dead then return end
			local t = now() - t0

			-- freeze: blur, a cold colour grade, the glass tint
			local fz = outCubic(t / 1.1)
			if finishing then
				local u = (now() - finishAt) / OUTRO
				frostAlpha = 1 - outCubic((u - 0.18) / 0.6)
				if u >= 1 then return cleanup() end
			else
				frostAlpha = fz
			end
			local fa = frostAlpha
			blur.Size = 22 * fa
			grade.Saturation = -0.55 * fa
			grade.Contrast = 0.1 * fa
			grade.Brightness = 0.03 * fa
			grade.TintColor = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(200, 226, 255), fa)
			glass.BackgroundTransparency = 1 - 0.14 * fa
			night.BackgroundTransparency = 1 - 0.5 * fa

			-- frost creeping in
			if not finishing then layoutEdges(outQuint(t / 1.7)) end
			for _, e in ipairs(edges) do e.BackgroundTransparency = 1 - fa end
			for _, p in ipairs(patches) do
				local k = outCubic((t - p.start) / 0.7)
				p.o.BackgroundTransparency = 1 - (1 - p.base) * k * fa
			end
			for _, s in ipairs(segs) do
				if not s.done then
					local k = outCubic((t - s.t0) / s.dur)
					s.o.Size = UDim2.fromOffset(s.len * k, s.o.Size.Y.Offset)
					s.o.BackgroundTransparency = k > 0 and s.base or 1
					if k >= 1 then s.done = true end
				end
			end
			if finishing then
				for _, f in ipairs(fading) do f[1][f[2]] = 1 - (1 - f[3]) * fa end
			end
			for _, s in ipairs(sparks) do
				local k = clamp01((t - s.start) / 0.5) * fa
				local tw = (0.5 + 0.5 * math.sin(t * s.w + s.ph)) ^ 6
				for _, a in ipairs(s.arms) do a.BackgroundTransparency = 1 - tw * k end
			end

			-- snow
			local sa = clamp01((t - 0.25) / 0.8) * fa
			for _, f in ipairs(flakes) do
				f.y += f.vy * dt
				if f.y > H + 30 then f.y, f.x = -30, r(0, W) end
				f.o.Position = UDim2.fromOffset(f.x + math.sin(t * f.freq + f.ph) * f.amp, f.y)
				f.o.BackgroundTransparency = 1 - (1 - f.base) * sa
			end

			-- letters drop in, land with a puff of ice, get their snow caps
			local wordFade = 0
			if finishing then
				local u = (now() - finishAt) / OUTRO
				wordFade = outCubic((u - 0.12) / 0.5)
				wordScale.Scale = 1 + 0.12 * outCubic(u)
			end
			local lastLanded = true
			for i, L in ipairs(letters) do
				local k = (t - L.start) / 0.62
				local e = outBack(k)
				L.sc.Scale = lerp(1.5, 1, e)
				L.g.Rotation = L.rot * (1 - outCubic(k))
				L.g.Position = UDim2.fromOffset(L.cx, TS / 2 - TS * 0.35 * (1 - outCubic(k)))
				L.g.GroupTransparency = 1 - clamp01(k * 2.2) * (1 - wordFade)
				if k >= 0.55 and not L.landed then
					L.landed = true
					burst(W / 2 - total / 2 + L.cx, H * 0.47 + TS * 0.36, 7)
				end
				if not L.landed then lastLanded = false end
				for _, c in ipairs(L.caps) do c.sc.Scale = outBack((t - L.start - 0.4 - c.delay) / 0.35) end
				-- a sweep of light along the word, every couple of seconds once it has formed
				local sweep = ((t - 2.0 - i * 0.05) % 2.4) / 0.9
				L.shine.Offset = Vector2.new(t > 2.0 and lerp(-1.2, 1.2, clamp01(sweep)) or -1.2, 0)
			end
			flakeScale.Scale = outBack((t - 1.25) / 0.5)
			flake.Rotation = t * 28

			-- the streak and the status once everything has landed
			local st = (t - 1.85) / 0.7
			streak.Size = UDim2.fromOffset(W * 0.95 * outCubic(st), streak.Size.Y.Offset)
			streak.BackgroundTransparency = 1 - 0.85 * (1 - clamp01(st)) * (st > 0 and 1 or 0) * (1 - wordFade)
			local ui = clamp01((t - 1.9) / 0.5) * (1 - wordFade)
			local dots = string.rep(".", math.floor(t * 2.5) % 4)
			status.Text = spaced(statusText) .. dots
			status.TextTransparency = 1 - 0.85 * ui
			bar.BackgroundTransparency = 1 - 0.18 * ui
			fill.BackgroundTransparency = 1 - ui
			local prog = finishing and 1 or (1 - math.exp(-t / 2.2)) * 0.9
			fill.Size = UDim2.fromScale(lerp(fill.Size.X.Scale, prog, clamp01(dt * 6)), 1)

			for i = #chips, 1, -1 do
				local c = chips[i]
				c.age += dt
				c.vy += 900 * S * dt
				c.x += c.vx * dt
				c.y += c.vy * dt
				c.o.Position = UDim2.fromOffset(c.x, c.y)
				c.o.Rotation += c.spin * dt
				c.o.BackgroundTransparency = clamp01(c.age / c.life)
				if c.age >= c.life then c.o:Destroy() table.remove(chips, i) end
			end

			-- outro: crack, flash, shatter
			if finishing then
				local u = (now() - finishAt) / OUTRO
				local ck = outCubic(u / 0.22)
				for _, parts in ipairs(cracks) do
					for _, p in ipairs(parts) do
						local k = clamp01((ck - p.at) / 0.35)
						p.o.Size = UDim2.fromOffset(p.len * outCubic(k), p.o.Size.Y.Offset)
						p.o.BackgroundTransparency = k > 0 and (0.1 + 0.9 * clamp01((u - 0.2) / 0.15)) or 1
					end
				end
				flash.BackgroundTransparency = u < 0.2 and 1 or 1 - 0.55 * (1 - outCubic((u - 0.2) / 0.3))
				if u >= 0.2 then
					local su = (u - 0.2) / 0.8
					for _, s in ipairs(shards) do
						s.vy += 1400 * S * dt
						s.x += s.vx * dt
						s.y += s.vy * dt
						s.rot += s.spin * dt
						s.o.Position = UDim2.fromOffset(s.x, s.y)
						s.o.Rotation = s.rot
						s.o.BackgroundTransparency = su < 0.05 and 0.3 or 0.3 + 0.7 * outCubic(su)
						s.stroke.Transparency = 0.25 + 0.75 * outCubic(su)
					end
				end
			end
		end

		conn = RunService.RenderStepped:Connect(function(dt)
			if dead then return end
			local ok, err = pcall(step, math.min(dt, 0.1))
			if not ok then
				warn("[Frosted] intro: " .. tostring(err))
				cleanup()
			end
		end)

		local api = {}
		function api:Status(text) statusText = tostring(text) end
		-- Holds until the wordmark has had its moment, then shatters the ice. Returns once it is gone.
		function api:Finish(ok)
			if dead then return end
			if not finishing then
				if ok ~= false then
					while not dead and now() - t0 < MIN_HOLD do task.wait() end
				end
				if dead then return end
				finishedOk = ok ~= false
				finishing, finishAt = true, now()
				startOutro()
			end
			local limit = now() + OUTRO + 1
			while not dead and now() < limit do task.wait() end
			cleanup()
		end
		api.Destroy = cleanup
		-- for rendering frames offline: swap the clock and step by hand
		function api._drive(clock) now = clock t0 = clock() return step end
		function api._outro() finishing, finishAt = true, now() startOutro() end
		return api
	end)
	if built then return intro end
	warn("[Frosted] intro skipped: " .. tostring(intro))
	return nil
end

local INTRO_VERSION = "29169752fb"
local INTRO_FILES = { "bloom.png", "cracks.png", "crystals.png", "flare.png", "frost.png", "letter1.png", "letter2.png", "letter3.png", "letter4.png", "letter5.png", "letter6.png", "letter7.png", "shards.png", "shine1.png", "shine2.png", "shine3.png", "shine4.png", "shine5.png", "shine6.png", "shine7.png", "snowflake.png", "soft.png", "sparkle.png" }
local INTRO_WORD = { w = 1272, h = 312, pad = 120, letters = { { 0, 198 }, { 198, 370 }, { 370, 581 }, { 581, 737 }, { 737, 901 }, { 901, 1062 }, { 1062, 1272 } } }

local function FrostedIntroRich(origin)
	if type(writefile) ~= "function" or type(isfile) ~= "function" or type(makefolder) ~= "function" then return nil end
	local getasset = getcustomasset or getsynasset
	if type(getasset) ~= "function" then return nil end

	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local ContentProvider = game:GetService("ContentProvider")
	local camera = workspace.CurrentCamera
	local t0real = os.clock()

	------------------------------------------------------------------ the freeze starts at once
	-- Blur and grade need no pictures, so they begin while the pictures load.
	local fxParent = camera or game:GetService("Lighting")
	local blur = Instance.new("BlurEffect")
	blur.Name = "FrostedIntroBlur"
	blur.Size = 0
	blur.Parent = fxParent
	local grade = Instance.new("ColorCorrectionEffect")
	grade.Name = "FrostedIntroGrade"
	grade.Parent = fxParent
	local preDead = false
	local preConn = RunService.RenderStepped:Connect(function()
		local k = math.clamp((os.clock() - t0real) / 1.2, 0, 1)
		k = 1 - (1 - k) ^ 3
		blur.Size = 20 * k
		grade.Saturation = -0.5 * k
		grade.TintColor = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(200, 226, 255), k)
	end)
	local function dropFx()
		if preDead then return end
		preDead = true
		preConn:Disconnect()
		pcall(function() blur:Destroy() end)
		pcall(function() grade:Destroy() end)
	end

	------------------------------------------------------------------ the pictures
	local dir = "Frosted/intro/" .. INTRO_VERSION .. "/"
	pcall(makefolder, "Frosted")
	pcall(makefolder, "Frosted/intro")
	pcall(makefolder, "Frosted/intro/" .. INTRO_VERSION)
	local ids, pending, failed = {}, #INTRO_FILES, false
	for _, name in ipairs(INTRO_FILES) do
		task.spawn(function()
			local path = dir .. name
			local ok = pcall(function() return isfile(path) end) and isfile(path)
			if not ok then
				local got, body = pcall(function() return game:HttpGet(origin .. "/intro/" .. name .. "?v=" .. INTRO_VERSION) end)
				if got and type(body) == "string" and body:sub(2, 4) == "PNG" then
					ok = pcall(writefile, path, body)
				end
			end
			if ok then
				local got, id = pcall(getasset, path)
				if got and type(id) == "string" and id ~= "" then ids[name] = id else failed = true end
			else
				failed = true
			end
			pending -= 1
		end)
	end
	-- A first run downloads ~4 MB; later runs read the cache and are ready at once. Waiting longer
	-- than this would hold the menu up, so past it the simple version plays instead (the downloads
	-- carry on and the next run has them).
	local deadline = os.clock() + 4
	while pending > 0 and not failed and os.clock() < deadline do task.wait() end
	if pending > 0 or failed then
		dropFx()
		return nil
	end

	local built, intro = pcall(function()
		local vp = camera and camera.ViewportSize or Vector2.new(1920, 1080)
		if vp.X < 50 or vp.Y < 50 then vp = Vector2.new(1920, 1080) end
		local W, H = vp.X, vp.Y
		local S = math.clamp(H / 1080, 0.5, 2.5)
		local rng = Random.new()
		local function r(a, b) return rng:NextNumber(a, b) end
		local now = os.clock

		local SNOW = Color3.fromRGB(244, 250, 255)
		local ICE = Color3.fromRGB(196, 230, 255)
		local NIGHT = Color3.fromRGB(3, 7, 15)

		local function new(class, props)
			local o = Instance.new(class)
			local parent = props.Parent
			props.Parent = nil
			for k, v in pairs(props) do o[k] = v end
			if parent then o.Parent = parent end
			return o
		end
		local function img(name, props)
			props.Image = ids[name]
			props.BackgroundTransparency = 1
			props.BorderSizePixel = 0
			if props.ImageTransparency == nil then props.ImageTransparency = 1 end
			return new("ImageLabel", props)
		end
		local function seq(points)
			local kp = {}
			for _, p in ipairs(points) do kp[#kp + 1] = NumberSequenceKeypoint.new(p[1], p[2]) end
			return NumberSequence.new(kp)
		end
		local function clamp01(x) return x < 0 and 0 or (x > 1 and 1 or x) end
		local function outCubic(x) x = clamp01(x) return 1 - (1 - x) ^ 3 end
		local function outQuint(x) x = clamp01(x) return 1 - (1 - x) ^ 5 end
		local function inCubic(x) x = clamp01(x) return x * x * x end
		local function outBack(x, c)
			x = clamp01(x)
			c = c or 1.7
			return 1 + (c + 1) * (x - 1) ^ 3 + c * (x - 1) ^ 2
		end
		local function lerp(a, b, t) return a + (b - a) * t end

		------------------------------------------------------------------ stage
		local gui = new("ScreenGui", {
			Name = HttpService:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false,
			DisplayOrder = 2147483000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		})
		pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
		local parented = false
		if type(gethui) == "function" then parented = pcall(function() gui.Parent = gethui() end) end
		if not parented then
			pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
			parented = pcall(function() gui.Parent = game:GetService("CoreGui") end)
		end
		if not parented then gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

		local z = 0
		local function layer()
			z += 1
			return new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = z, Parent = gui })
		end
		local function full(parent, name, zi)
			return img(name, {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Stretch, ZIndex = zi or 1, Parent = parent,
			})
		end

		local glass = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(150, 200, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1, Parent = gui })
		local night = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = NIGHT, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = gui })
		new("UIGradient", { Rotation = 90, Transparency = seq({ { 0, 0.35 }, { 0.47, 0 }, { 1, 0.35 } }), Parent = night })
		z = 2
		local frostL = layer()
		local frost = full(frostL, "frost.png")
		local crystals = full(frostL, "crystals.png", 2)
		local sparkL = layer()
		local snowL = layer()
		local bloomL = layer()
		local wordL = layer()
		local fxL = layer()
		local crackL = layer()
		local cracksImg = full(crackL, "cracks.png")
		local flash = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = SNOW, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = z + 1, Parent = gui })
		z += 1
		local shardL = layer()

		------------------------------------------------------------------ sparkles in the frost
		local function edgePoint(maxFrac)
			for _ = 1, 40 do
				local x, y = r(0, W), r(0, H)
				local d = math.min(x / W, (W - x) / W, y / H * 1.25, (H - y) / H * 1.25)
				if d < maxFrac and rng:NextNumber() < (1 - d / maxFrac) ^ 1.5 then return x, y end
			end
			return r(0, W), 4
		end
		local sparks = {}
		for i = 1, 46 do
			local x, y = edgePoint(0.13)
			local s = r(14, 42) * S
			local o = img("sparkle.png", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(s, s), Rotation = r(0, 90), ZIndex = 1, Parent = sparkL })
			sparks[i] = { o = o, w = r(1.2, 3.2), ph = r(0, 6.28), start = r(1.0, 2.2), s = s }
		end

		------------------------------------------------------------------ snow, flakes and bokeh
		local snow = {}
		local function addFlake(kind)
			local s, base, vy, name
			if kind == "dot" then s, base, vy, name = r(3, 8) * S, r(0.15, 0.55), r(45, 130), "soft.png"
			elseif kind == "flake" then s, base, vy, name = r(16, 34) * S, r(0.25, 0.55), r(55, 110), "snowflake.png"
			else s, base, vy, name = r(50, 120) * S, r(0.8, 0.9), r(30, 70), "soft.png" end
			local o = img(name, { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(s, s), ZIndex = kind == "bokeh" and 2 or 1, Parent = snowL })
			snow[#snow + 1] = {
				o = o, x = r(0, W), y = r(-H, H), vy = vy * S, amp = r(10, 40) * S, freq = r(0.3, 1.1), ph = r(0, 6.28),
				base = base, spin = kind == "flake" and r(-60, 60) or 0, rot = r(0, 60),
			}
		end
		for _ = 1, 130 do addFlake("dot") end
		for _ = 1, 14 do addFlake("flake") end
		for _ = 1, 12 do addFlake("bokeh") end

		------------------------------------------------------------------ the wordmark
		local k = math.min(W * 0.62 / INTRO_WORD.w, H * 0.34 / INTRO_WORD.h)
		local ww, wh = INTRO_WORD.w * k, INTRO_WORD.h * k
		local cy = 0.46
		local bloom = img("bloom.png", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, cy),
			Size = UDim2.fromOffset((INTRO_WORD.w + INTRO_WORD.pad * 2) * k * 1.05, (INTRO_WORD.h + INTRO_WORD.pad * 2) * k * 1.15),
			ZIndex = 1, Parent = bloomL,
		})
		local wordF = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, cy), Size = UDim2.fromOffset(ww, wh),
			BackgroundTransparency = 1, ZIndex = 1, Parent = wordL,
		})
		local wordScale = new("UIScale", { Parent = wordF })
		local L = {}
		for i, span in ipairs(INTRO_WORD.letters) do
			local lw = (span[2] - span[1]) * k
			local cx = (span[1] + span[2]) / 2 * k
			local holder = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, wh / 2), Size = UDim2.fromOffset(lw, wh),
				BackgroundTransparency = 1, ZIndex = 1, Parent = wordF,
			})
			local sc = new("UIScale", { Scale = 1.7, Parent = holder })
			local face = img("letter" .. i .. ".png", { Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = holder })
			-- the letter flashes white as it freezes, and later the light sweeps across it
			local shine = img("shine" .. i .. ".png", { Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = holder })
			local sweep = img("shine" .. i .. ".png", { Size = UDim2.fromScale(1, 1), ZIndex = 3, ImageTransparency = 0.25, Parent = holder })
			local grad = new("UIGradient", {
				Rotation = 20, Offset = Vector2.new(-1.5, 0),
				Transparency = seq({ { 0, 1 }, { 0.4, 1 }, { 0.5, 0.15 }, { 0.6, 1 }, { 1, 1 } }),
				Parent = sweep,
			})
			L[i] = {
				holder = holder, sc = sc, face = face, shine = shine, grad = grad, cx = cx,
				start = 1.0 + (i - 1) * 0.085, rot = r(-12, 12), landed = false,
			}
		end

		local flare = img("flare.png", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, cy), Size = UDim2.fromOffset(0, 70 * S), ZIndex = 1, Parent = fxL })
		local flare2 = img("flare.png", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, cy), Size = UDim2.fromOffset(0, 18 * S), ZIndex = 2, ImageColor3 = Color3.new(1, 1, 1), Parent = fxL })

		local underY = cy + (wh * 0.5 + 6 * S) / H
		local status = new("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, underY), Size = UDim2.fromOffset(ww, 26 * S),
			BackgroundTransparency = 1, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			TextSize = math.clamp(math.floor(19 * S), 13, 34), TextColor3 = ICE, TextTransparency = 1, Text = "", ZIndex = 2, Parent = wordL,
		})
		new("UIStroke", { Color = Color3.fromRGB(40, 110, 220), Thickness = 1, Transparency = 1, Parent = status })
		local barW = math.min(ww * 0.36, 380 * S)
		local bar = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, underY, 38 * S), Size = UDim2.fromOffset(barW, math.max(2, 3 * S)),
			BackgroundColor3 = Color3.fromRGB(150, 200, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = wordL,
		})
		new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
		local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = SNOW, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3, Parent = bar })
		new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
		new("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(90, 170, 255), Color3.new(1, 1, 1)), Parent = fill })
		local tip = img("soft.png", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(26 * S, 26 * S), ZIndex = 4, Parent = bar })

		local statusText = "Loading"
		local function spaced(s) return (s:upper():gsub(".", "%0 "):gsub("%s+$", "")) end

		------------------------------------------------------------------ ice chips
		local chips = {}
		local function burst(x, y, n)
			for _ = 1, n do
				local s = r(4, 11) * S
				local o = img("soft.png", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(s, s), ZIndex = 3, ImageTransparency = 0, Parent = fxL })
				local a = r(-math.pi * 0.95, -math.pi * 0.05)
				local v = r(160, 460) * S
				chips[#chips + 1] = { o = o, x = x + r(-20, 20) * S, y = y, vx = math.cos(a) * v, vy = math.sin(a) * v, life = r(0.5, 0.9), age = 0 }
			end
		end

		------------------------------------------------------------------ preload, so nothing pops in
		pcall(function()
			local list = {}
			for _, o in ipairs(gui:GetDescendants()) do if o:IsA("ImageLabel") then list[#list + 1] = o end end
			ContentProvider:PreloadAsync(list)
		end)

		------------------------------------------------------------------ the clock
		local t0 = now()
		local finishing, finishAt = false, nil
		local OUTRO, MIN_HOLD = 1.25, 3.1
		local shards = {}
		local dead = false
		local conn
		local wcx, wcy = W / 2, H * cy

		local function cleanup()
			if dead then return end
			dead = true
			if conn then conn:Disconnect() end
			pcall(function() gui:Destroy() end)
			dropFx()
		end
		preConn:Disconnect()
		-- the timeline picks the freeze up wherever the preload left it
		local freezeBase = math.clamp((os.clock() - t0real) / 1.2, 0, 1)

		local function startOutro()
			for _ = 1, 64 do
				-- most shards come from around the word, the rest from anywhere on the glass
				local nearWord = rng:NextNumber() < 0.55
				local sx = nearWord and wcx + r(-ww * 0.6, ww * 0.6) or r(0, W)
				local sy = nearWord and wcy + r(-wh * 0.9, wh * 0.9) or r(0, H)
				local s = r(50, 230) * S
				local o = img("shards.png", {
					AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(sx, sy), Size = UDim2.fromOffset(s, s),
					ImageRectSize = Vector2.new(256, 256), ImageRectOffset = Vector2.new(256 * rng:NextInteger(0, 7), 0),
					Rotation = r(0, 360), ImageTransparency = 0, ZIndex = 1, Parent = shardL,
				})
				local dx, dy = sx - wcx, sy - wcy
				local d = math.max(1, math.sqrt(dx * dx + dy * dy))
				local v = r(500, 1500) * S * (0.6 + d / (W * 0.5))
				shards[#shards + 1] = { o = o, x = sx, y = sy, vx = dx / d * v, vy = dy / d * v - r(150, 450) * S, spin = r(-400, 400), rot = o.Rotation, sc = r(0.85, 1.15), s = s }
			end
		end

		local function step(dt)
			if dead then return end
			local t = now() - t0
			local u = finishing and (now() - finishAt) / OUTRO or 0
			if finishing and u >= 1 then return cleanup() end

			-- how frozen the screen is: up during the intro, back down as the ice breaks
			local fa = lerp(freezeBase, 1, outCubic(t / 1.1))
			if finishing then fa *= 1 - outCubic((u - 0.1) / 0.55) end
			blur.Size = 20 * fa
			grade.Saturation = -0.5 * fa
			grade.Contrast = 0.08 * fa
			grade.TintColor = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(200, 226, 255), fa)
			glass.BackgroundTransparency = 1 - 0.1 * fa
			night.BackgroundTransparency = 1 - 0.7 * fa

			-- frost closes in from outside the screen; the ferns follow a beat later
			local grow = finishing and 1 + 0.14 * outCubic(u / 0.7) or 1
			local fk = outQuint(t / 1.6)
			frost.Size = UDim2.fromScale(lerp(1.32, 1, fk) * grow, lerp(1.32, 1, fk) * grow)
			frost.ImageTransparency = 1 - outCubic(t / 0.9) * fa
			local ck = outQuint((t - 0.25) / 1.7)
			crystals.Size = UDim2.fromScale(lerp(1.22, 1, ck) * grow, lerp(1.22, 1, ck) * grow)
			crystals.ImageTransparency = 1 - outCubic((t - 0.25) / 1.0) * fa

			for _, s in ipairs(sparks) do
				local a = clamp01((t - s.start) / 0.4) * fa
				local tw = (0.5 + 0.5 * math.sin(t * s.w + s.ph)) ^ 5
				s.o.ImageTransparency = 1 - tw * a
				s.o.Rotation += 20 * dt
				local sz = s.s * (0.6 + 0.6 * tw)
				s.o.Size = UDim2.fromOffset(sz, sz)
			end

			local sa = clamp01((t - 0.3) / 0.9) * fa
			for _, f in ipairs(snow) do
				f.y += f.vy * dt
				if f.y > H + 80 then f.y, f.x = -80, r(0, W) end
				f.rot += f.spin * dt
				f.o.Position = UDim2.fromOffset(f.x + math.sin(t * f.freq + f.ph) * f.amp, f.y)
				f.o.Rotation = f.rot
				f.o.ImageTransparency = 1 - (1 - f.base) * sa
			end

			-- the word
			local wf = finishing and outCubic((u - 0.06) / 0.4) or 0
			wordScale.Scale = finishing and 1 + 0.3 * inCubic(u / 0.5) or 1
			for i, l in ipairs(L) do
				local p = (t - l.start) / 0.72
				l.sc.Scale = lerp(1.7, 1, outBack(p, 1.4))
				l.holder.Rotation = l.rot * (1 - outCubic(p))
				l.holder.Position = UDim2.fromOffset(l.cx, wh / 2 - wh * 0.3 * (1 - outCubic(p)))
				l.face.ImageTransparency = 1 - clamp01(p * 2.5) * (1 - wf)
				if p >= 0.5 and not l.landed then
					l.landed = true
					l.landT = t
					burst(wcx - ww / 2 + l.cx, wcy + wh * 0.28, 9)
				end
				-- the white flash of the freeze, fading off the letter
				l.shine.ImageTransparency = l.landed and lerp(0.1, 1, outCubic((t - l.landT) / 0.55)) or 1
				-- a sweep of light along the word every few seconds
				local sw = ((t - 2.4 - i * 0.06) % 2.8) / 0.85
				l.grad.Offset = Vector2.new(t > 2.4 and lerp(-1.5, 1.5, clamp01(sw)) or -1.5, 0)
				l.grad.Parent.ImageTransparency = 0.2 + 0.8 * wf
			end
			local breathe = 0.5 + 0.5 * math.sin(t * 1.6)
			bloom.ImageTransparency = 1 - clamp01((t - 1.0) / 0.9) * (0.62 + 0.18 * breathe) * (1 - wf)

			-- the flare as the last letter lands
			local fl = (t - 1.6) / 0.9
			local fw = W * 1.15 * outCubic(fl)
			flare.Size = UDim2.fromOffset(fw, 70 * S)
			flare2.Size = UDim2.fromOffset(fw * 0.7, 18 * S)
			local fo = fl > 0 and (1 - clamp01(fl)) ^ 1.5 or 0
			flare.ImageTransparency = 1 - 0.85 * fo
			flare2.ImageTransparency = 1 - fo

			local ui = clamp01((t - 2.0) / 0.5) * (1 - wf)
			status.Text = spaced(statusText) .. string.rep(".", math.floor(t * 2.5) % 4)
			status.TextTransparency = 1 - 0.9 * ui
			status:FindFirstChildOfClass("UIStroke").Transparency = 1 - 0.5 * ui
			bar.BackgroundTransparency = 1 - 0.2 * ui
			fill.BackgroundTransparency = 1 - ui
			local prog = finishing and 1 or (1 - math.exp(-t / 2.4)) * 0.9
			local cur = lerp(fill.Size.X.Scale, prog, clamp01(dt * 6))
			fill.Size = UDim2.fromScale(cur, 1)
			tip.Position = UDim2.fromScale(cur, 0.5)
			tip.ImageTransparency = 1 - 0.85 * ui

			for i = #chips, 1, -1 do
				local c = chips[i]
				c.age += dt
				c.vy += 1100 * S * dt
				c.x += c.vx * dt
				c.y += c.vy * dt
				c.o.Position = UDim2.fromOffset(c.x, c.y)
				c.o.ImageTransparency = clamp01(c.age / c.life)
				if c.age >= c.life then c.o:Destroy() table.remove(chips, i) end
			end

			-- outro: the glass cracks, flashes, and falls apart
			if finishing then
				local ca = outCubic(u / 0.07)
				cracksImg.Size = UDim2.fromScale(lerp(0.9, 1, ca) * grow, lerp(0.9, 1, ca) * grow)
				cracksImg.ImageTransparency = u < 0.12 and 1 - ca or clamp01((u - 0.12) / 0.3)
				flash.BackgroundTransparency = u < 0.1 and 1 or 1 - 0.5 * (1 - outCubic((u - 0.1) / 0.35))
				if u >= 0.1 then
					local su = clamp01((u - 0.1) / 0.85)
					for _, s in ipairs(shards) do
						s.vy += 1700 * S * dt
						s.x += s.vx * dt
						s.y += s.vy * dt
						s.rot += s.spin * dt
						s.o.Position = UDim2.fromOffset(s.x, s.y)
						s.o.Rotation = s.rot
						s.o.ImageTransparency = outCubic(su) * 0.9 + (su > 0.9 and (su - 0.9) or 0)
					end
				else
					for _, s in ipairs(shards) do s.o.ImageTransparency = 1 end
				end
			end
		end

		conn = RunService.RenderStepped:Connect(function(dt)
			local ok, err = pcall(step, math.min(dt, 0.1))
			if not ok then
				warn("[Frosted] intro: " .. tostring(err))
				cleanup()
			end
		end)

		local api = {}
		function api:Status(text) statusText = tostring(text) end
		-- Holds until the wordmark has had its moment, then shatters the ice. Returns once it is gone.
		function api:Finish(ok)
			if dead then return end
			if not finishing then
				if ok ~= false then
					while not dead and now() - t0 < MIN_HOLD do task.wait() end
				end
				if dead then return end
				finishing, finishAt = true, now()
				startOutro()
			end
			local limit = now() + OUTRO + 1
			while not dead and now() < limit do task.wait() end
			cleanup()
		end
		api.Destroy = cleanup
		-- for testing: swap the clock and step frames by hand
		function api._drive(clock) now = clock t0 = clock() freezeBase = 0 return step end
		function api._outro() finishing, finishAt = true, now() startOutro() end
		return api
	end)
	if built then return intro end
	warn("[Frosted] intro skipped: " .. tostring(intro))
	dropFx()
	return nil
end

-- Places where a full-screen freeze would get someone killed. Havoc's raid place is blocked outright;
-- anywhere else in Havoc it plays only when the game says it is the hideout (shared.inHideout) and
-- no raid clock is running, and anything it cannot read counts as a raid.
local NO_INTRO_PLACES = {
	[16530963934] = true,   -- Havoc raid
}

local function FrostedIntroAllowed()
	if NO_INTRO_PLACES[game.PlaceId] then return false end
	if game.GameId == 4827308727 then
		local ok, inHideout = pcall(function() return getrenv().shared.inHideout end)
		if not ok or inHideout ~= true then return false end
		local okClock, clock = pcall(function() return game:GetService("Lighting"):GetAttribute("currentMinutes") end)
		if not okClock or clock ~= nil then return false end
	end
	return true
end

local function FrostedIntro(origin)
	local okEnv, env = pcall(function() return getgenv() end)
	if okEnv and type(env) == "table" and env.FrostedNoIntro then return nil end
	if not FrostedIntroAllowed() then return nil end
	local intro = FrostedIntroRich(origin)
	if intro then return intro end
	return FrostedIntroBasic()
end


-- The executor's own name and version, or nil if it does not say.
local function executorInfo()
	local ok, name, version = pcall(function()
		if type(identifyexecutor) == "function" then return identifyexecutor() end
		if type(getexecutorname) == "function" then return getexecutorname() end
		return nil
	end)
	if not ok or type(name) ~= "string" or name == "" then return nil, nil end
	if type(version) ~= "string" and type(version) ~= "number" then version = nil end
	return name:sub(1, 40), version and tostring(version):sub(1, 30) or nil
end

-- The executor's own HTTP call, which is the ONE thing that makes a device id possible: every
-- UNC/sUNC executor attaches its hardware-bound <Prefix>-Fingerprint header to a request() on its
-- own, and the stub cannot set or strip it. game:HttpGet does not trigger that, so request() is
-- tried first and HttpGet is only the fallback for the rare tool without it.
local function httpRequest()
	return (syn and syn.request) or http_request or request or (http and http.request)
end

local function urlEncode(s)
	local ok, out = pcall(function() return game:GetService("HttpService"):UrlEncode(s) end)
	return ok and out or ""
end

-- Scripts read this to queue the same loader across a server hop.
pcall(function() getgenv().FrostedOrigin = ORIGIN end)

-- Frosted's notification card. FrostedToast(title, text, kind, duration); kind is "Success",
-- "Info", "Warning" or "Error". With the menu loaded it hands over to the menu's own stack.
local FrostedToast = (function()
	local KINDS = {
		Success = { icon = "rbxassetid://88244323237265", color = Color3.fromRGB(96, 200, 132) },
		Info = { icon = "rbxassetid://120620848266512", color = Color3.fromRGB(98, 124, 210) },
		Warning = { icon = "rbxassetid://91165848022002", color = Color3.fromRGB(236, 184, 84) },
		Error = { icon = "rbxassetid://106305483906363", color = Color3.fromRGB(255, 92, 95) },
	}
	local DIV, BORDER = Color3.fromRGB(31, 31, 37), Color3.fromRGB(43, 43, 55)
	local TEXT, WHITE = Color3.fromRGB(123, 123, 150), Color3.fromRGB(255, 255, 255)
	local gui, stack

	local function make(class, props)
		local inst = Instance.new(class)
		for k, v in pairs(props) do
			if k ~= "Parent" then inst[k] = v end
		end
		inst.Parent = props.Parent
		return inst
	end

	local function font(weight)
		local ok, f = pcall(function() return Font.new("rbxassetid://12187365364", weight) end)
		return ok and f or nil
	end

	local function label(props)
		local l = make("TextLabel", props)
		l.BackgroundTransparency = 1
		l.TextSize = 13
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextYAlignment = Enum.TextYAlignment.Top
		local f = font(Enum.FontWeight.Medium)
		if f then l.FontFace = f else l.Font = Enum.Font.GothamMedium end
		return l
	end

	local function root()
		if gui and gui.Parent and stack and stack.Parent then return stack end
		gui = make("ScreenGui", {
			Name = "FrostedToasts", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 260,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		})
		local homes = {
			function() return gethui() end,
			function() return game:GetService("CoreGui") end,
			function() return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 5) end,
		}
		for _, home in ipairs(homes) do
			local ok = pcall(function() gui.Parent = home() end)
			if ok and gui.Parent then break end
		end
		if not gui.Parent then error("nowhere to put the toast") end
		stack = make("Frame", {
			Parent = gui, Name = "Stack", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -20, 1, -20), Size = UDim2.new(0, 360, 1, -40),
		})
		make("UIListLayout", {
			Parent = stack, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 12),
			HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		return stack
	end

	local count = 0
	local function show(title, text, kind, duration)
		local k = KINDS[kind] or KINDS.Info
		local parent = root()
		local TweenService = game:GetService("TweenService")
		count = count + 1

		local card = make("CanvasGroup", {
			Parent = parent, Name = "Toast", BackgroundTransparency = 1, GroupTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(0, 0, 0, 0), LayoutOrder = count,
		})
		-- The outline sits on a child inset by a pixel: a stroke on the group itself is clipped off.
		make("UIPadding", {
			Parent = card, PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1),
			PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1),
		})
		local face = make("Frame", {
			Parent = card, Name = "Face", BackgroundColor3 = DIV, BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(0, 0, 0, 0), ClipsDescendants = true,
		})
		make("UICorner", { Parent = face, CornerRadius = UDim.new(0, 4) })
		make("UIStroke", { Parent = face, Color = BORDER, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
		-- the kind's colour down the left edge
		make("Frame", {
			Parent = face, Name = "Strip", BackgroundColor3 = k.color, BorderSizePixel = 0,
			Size = UDim2.new(0, 3, 1, 0), ZIndex = 3,
		})
		local body = make("Frame", {
			Parent = face, Name = "Body", BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(0, 0, 0, 0),
		})
		make("UIPadding", {
			Parent = body, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 14),
		})
		make("UIListLayout", {
			Parent = body, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10),
			VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder,
		})
		make("ImageLabel", {
			Parent = body, Name = "Icon", BackgroundTransparency = 1, Size = UDim2.new(0, 14, 0, 14),
			Image = k.icon, ImageColor3 = k.color, ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1,
		})
		local words = make("Frame", {
			Parent = body, Name = "Words", BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(0, 250, 0, 0), LayoutOrder = 2,
		})
		make("UIListLayout", {
			Parent = words, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		label({
			Parent = words, Name = "Title", Text = title, TextColor3 = WHITE, LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 15), TextTruncate = Enum.TextTruncate.AtEnd,
		})
		-- a fixed width, so a long message wraps and every card in the stack lines up
		local msg = label({
			Parent = words, Name = "Text", Text = text, TextColor3 = TEXT, TextWrapped = true, LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 15),
		})
		-- Belt and braces: where automatic sizing came up short, size the text from its own bounds.
		task.delay(0.05, function()
			pcall(function()
				if msg.TextBounds.Y > msg.AbsoluteSize.Y + 1 then
					msg.Size = UDim2.new(1, 0, 0, math.ceil(msg.TextBounds.Y))
				end
			end)
		end)
		local timer = make("Frame", {
			Parent = face, Name = "Timer", BackgroundColor3 = k.color, BackgroundTransparency = 0.3, BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 2), ZIndex = 4,
		})

		local gone = false
		local function dismiss()
			if gone then return end
			gone = true
			pcall(function()
				TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 1 }):Play()
			end)
			task.delay(0.3, function() pcall(function() card:Destroy() end) end)
		end
		local click = make("TextButton", {
			Parent = face, Name = "Dismiss", BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0), ZIndex = 5,
		})
		click.MouseButton1Click:Connect(dismiss)

		TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
		TweenService:Create(timer, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) }):Play()
		task.delay(duration, dismiss)
	end

	return function(title, text, kind, duration)
		title, text = tostring(title or "Frosted"), tostring(text or "")
		duration = tonumber(duration) or 8
		local genv = (type(getgenv) == "function") and getgenv() or _G
		-- The menu is up: use its notifications, so there is one stack on screen and not two.
		local lib = genv.Starfied
		if type(lib) == "table" and type(lib.Notify) == "function" and not lib.Unloaded then
			local ok = pcall(lib.Notify, lib, { Title = title, Text = text, Type = kind or "Info", Duration = duration, Force = true })
			if ok then return end
		end
		local ok = pcall(show, title, text, kind, duration)
		if not ok then
			-- No way to draw: Roblox's own popup, so the message still arrives.
			pcall(function()
				game:GetService("StarterGui"):SetCore("SendNotification", { Title = title, Text = text, Duration = duration })
			end)
		end
	end
end)()
pcall(function()
	local genv = (type(getgenv) == "function") and getgenv() or _G
	genv.FrostedToast = FrostedToast
end)

local function notify(text, kind)
	pcall(FrostedToast, "Frosted", text, kind or "Info", 12)
end

local function kick(title, detail)
	local player = Players.LocalPlayer
	if player then
		player:Kick("\n " .. title .. " \n\n" .. detail .. "\n\nGet Frosted: " .. ORIGIN)
	end
end

-- Feature-detect rather than assume. Executors disagree about which of these exist, and a
-- missing writefile must degrade to "activate every session", never to an error.
local function hasFS()
	return type(readfile) == "function"
		and type(writefile) == "function"
		and type(isfile) == "function"
end

-- Everything Frosted writes sits in one folder in the workspace. A file from before that is
-- MOVED in, not regenerated: copied, read back, and only then is the old one removed. The device
-- id matters most -- a fresh one would look like a second machine to the licence check.
local function ensureFolder()
	pcall(function()
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("Frosted") then
			makefolder("Frosted")
		end
	end)
end

local function adopt(old, new)
	pcall(function()
		if isfile(new) or not isfile(old) then return end
		local body = readfile(old)
		ensureFolder()
		writefile(new, body)
		if readfile(new) == body and type(delfile) == "function" then pcall(delfile, old) end
	end)
end

-- The path to read: the new one, or the old one when the move could not be made.
local function located(new, old)
	adopt(old, new)
	if isfile(new) then return new end
	if isfile(old) then return old end
	return nil
end

local function readKey()
	if not hasFS() then return nil end
	local ok, body = pcall(function()
		local path = located(KEYFILE, OLD_KEYFILE)
		if path then return readfile(path) end
		return nil
	end)
	if not ok or type(body) ~= "string" then return nil end
	body = body:gsub("%s", "")
	if #body == 0 then return nil end
	return body
end

-- What device this is, as well as this executor can say. NOTHING here is private: an executor
-- device id, a random id this loader generated itself, and the Roblox account already visible to
-- every server you join. No disk contents, no machine details, no process list.
--
-- The server grades what it gets (a fingerprint header beats gethwid beats this saved id beats
-- nothing) and an executor that can supply none of it is NOT locked out -- it is identified by its
-- Roblox accounts instead. That trade is the point: a licence check that bricks a phone is worse
-- than one that is softer on a phone.
local function deviceId()
	local ok, id = pcall(function()
		if type(gethwid) == "function" then return gethwid() end
		if type(get_hwid) == "function" then return get_hwid() end
		return nil
	end)
	if ok and type(id) == "string" and #id > 0 and #id <= 256 then return id end
	return nil
end

-- Failing that: one random id, written once, reused forever. Stable per install, trivially copied
-- -- which is fine, because what grants access is the owner APPROVING a device, never the id alone.
local function savedId()
	if not hasFS() then return nil end
	local ok, id = pcall(function()
		local path = located(DEVICEFILE, OLD_DEVICEFILE)
		if path then
			local body = readfile(path)
			if type(body) == "string" then
				body = body:gsub("%s", "")
				if #body >= 16 then return body end
			end
		end
		local fresh = ""
		for _ = 1, 32 do fresh = fresh .. string.format("%x", math.random(0, 15)) end
		ensureFolder()
		writefile(DEVICEFILE, fresh)
		return fresh
	end)
	if ok and type(id) == "string" and #id >= 16 then return id end
	return nil
end

-- TAMPER SIGNALS, and an honest account of what they are worth.
--
-- The payload is dumped by hooking the function that compiles it -- loadstring -- or the function
-- that downloads it. Both hooks are visible from inside Lua on most executors: a hooked function
-- stops being a C closure. So these three checks catch the ordinary, lazy case, which is most of it.
--
-- WHAT THEY CANNOT DO, stated plainly rather than discovered later: this code cannot verify ITSELF.
-- A rewritten stub reports whatever it likes, and an attacker who can hook loadstring can hook
-- iscclosure just as easily. Self-verification from inside the thing being verified is not a
-- solvable problem in plain Lua -- it needs the secret-bearing VM layer (Luraph), which is where
-- the plan puts it.
--
-- Therefore these are REPORTED, never acted on by the loader. The server records them, the admin
-- page shows them, and only the per-executor policy decides whether any of it refuses a run. A
-- false positive here must never cost a paying customer their script, and executors are strange
-- enough -- legitimately wrapping HttpGet, for instance -- that false positives are certain.
local function tamperFlags()
	local flags = {}
	local function isCClosure(fn)
		if type(fn) ~= "function" then return nil end
		if type(iscclosure) == "function" then
			local ok, v = pcall(iscclosure, fn)
			if ok and type(v) == "boolean" then return v end
		end
		-- No iscclosure: debug.info says where a function came from, and a C function has no source.
		if type(debug) == "table" and type(debug.info) == "function" then
			local ok, src = pcall(debug.info, fn, "s")
			if ok and type(src) == "string" then return src == "[C]" end
		end
		return nil
	end
	local function check(name, fn)
		if isCClosure(fn) == false then flags[#flags + 1] = name end
	end
	check("ls", loadstring)
	check("get", game.HttpGet)
	check("req", httpRequest())
	return table.concat(flags, ".")
end

local function robloxId()
	local player = Players.LocalPlayer
	local ok, id = pcall(function() return player and player.UserId end)
	if ok and type(id) == "number" and id > 0 then return string.format("%d", id) end
	return nil
end

-- An argument beats the stored key. That is how someone replaces a rotated or wrong key
-- without having to go and delete a file they cannot easily find.
--
-- What to tell the user about it is only decided here, in KEY_NOTE. It is SHOWN after the server
-- has accepted the key and the script has started: "key saved" over a refusal would be a lie.
local KEY_NOTE
local function getKey()
	local given = ARGS[1]
	if type(given) == "string" and #given > 0 then
		local key = given:gsub("%s", "")
		if hasFS() then
			ensureFolder()
			if pcall(writefile, KEYFILE, key) then
				KEY_NOTE = { "Key saved. Just run the plain loadstring from now on.", "Success" }
			else
				KEY_NOTE = { "Key accepted, but it could not be saved. You will need it again next time.", "Warning" }
			end
		else
			KEY_NOTE = { "Key accepted. This executor has no file access, so it is not saved.", "Warning" }
		end
		return key
	end
	return readKey()
end

local function Task()
	repeat task.wait() until game:IsLoaded() and Players.LocalPlayer

	local GameName = ListGame[tostring(game.GameId)]
	if not GameName then
		kick("Game Not Supported", "Game ID: " .. tostring(game.GameId))
		return false
	end

	local places = ListPlaces[tostring(game.GameId)]
	if places and not places[game.PlaceId] then
		local hint = ListHints[tostring(game.GameId)] or (GameName .. " is not supported in this place yet.")
		warn("[Frosted] " .. hint)
		notify(hint, "Warning")
		return false
	end

	-- The key travels in the query string because the only HTTP call every executor reliably
	-- provides is game:HttpGet, which cannot set headers. What matters is that the USER never
	-- types it into a URL.
	local key = getKey()
	-- Which executor this is (most expose identifyexecutor), so the site can see what its users run
	-- and which executors actually load it. Nothing else about the machine is sent.
	local query = {}
	if key then table.insert(query, "k=" .. key) end
	local xname, xver = executorInfo()
	if xname then
		table.insert(query, "x=" .. urlEncode(xname))
		table.insert(query, "xid=" .. urlEncode(xname:lower()))
	end
	if xver then table.insert(query, "xv=" .. urlEncode(xver)) end
	-- Device signals. The strongest one -- the executor's fingerprint header -- is attached by the
	-- executor itself on the request() path below and does not appear here.
	local hw = deviceId()
	if hw then table.insert(query, "hw=" .. urlEncode(hw)) end
	if not hw then
		local saved = savedId()
		if saved then table.insert(query, "pr=" .. urlEncode(saved)) end
	end
	local rb = robloxId()
	if rb then table.insert(query, "rb=" .. rb) end
	-- Reported, not enforced here: see tamperFlags above.
	local tf = tamperFlags()
	if tf ~= "" then table.insert(query, "tf=" .. urlEncode(tf)) end
	local qs = #query > 0 and ("?" .. table.concat(query, "&")) or ""
	local url = ORIGIN .. "/s/payload" .. qs

	-- SEALED DELIVERY (optional, server decides). Two extra calls: /s/sync for a single-use nonce and
	-- the server's clock, then /s/auth for a payload encrypted to THIS device and THIS handshake.
	--
	-- Everything here is best-effort on purpose. If the server has it switched off, if any field comes
	-- back wrong, if a MAC does not check out, if the executor has no request() -- the loader falls
	-- through to the plain /s/payload path below, which is the path that has always worked. A licence
	-- system that can fail CLOSED on a paying customer is worse than one that can be captured.
	local function sealedFetch()
		if not Crypto or not key then return nil end
		local req = httpRequest()
		if not req then return nil end          -- no headers, no fingerprint, no point
		local function get(u)
			local ok, res = pcall(req, { Url = u, Method = "GET" })
			if ok and type(res) == "table" and type(res.Body) == "string" then return res.Body end
			return nil
		end

		local sync = get(ORIGIN .. "/s/sync" .. qs)
		if type(sync) ~= "string" or not sync:find("FROSTEDsync", 1, true) then return nil end
		local f = {}
		for k, v in sync:gmatch("(%w+)=([^%s]+)") do f[k] = v end
		if f.sealed ~= "1" or not f.sn or not f.ep or not f.st or not f.hw then return nil end

		-- The client nonce: 32 hex characters of whatever randomness this executor can manage. It only
		-- has to be unpredictable to the server for one handshake.
		local cn = ""
		for _ = 1, 32 do cn = cn .. string.format("%x", math.random(0, 15)) end
		-- The server's own stamp is echoed back, so a wrong local clock is harmless.
		local ct = f.st
		local sig = Crypto.hex(Crypto.sha256("frosted/sig/1|" .. cn .. "|" .. key .. "|" .. ct ..
			"|" .. f.sn .. "|" .. f.ep .. "|" .. f.hw))

		local authUrl = ORIGIN .. "/s/auth" .. (qs == "" and "?" or (qs .. "&")) ..
			"cn=" .. cn .. "&ct=" .. ct .. "&sn=" .. f.sn .. "&sig=" .. sig
		local raw = get(authUrl)
		if type(raw) ~= "string" or #raw == 0 then return nil end
		-- A refusal comes back as Lua, not an envelope: hand it straight on, so "your access ended"
		-- still reaches the user instead of being swallowed as a failed handshake.
		if not raw:find("^FROSTEDv1 ") then
			if raw:find("[Frosted]", 1, true) then return raw end
			return nil
		end

		local nl = raw:find("\n", 1, true)
		if not nl then return nil end
		local env = {}
		for k, v in raw:sub(1, nl - 1):gmatch("(%w+)=([^%s]+)") do env[k] = v end
		local body = raw:sub(nl + 1)
		env.sealed = env.sealed and Crypto.unbase64(env.sealed)
		env.pre = env.pre and Crypto.unbase64(env.pre) or ""
		env.smac = env.smac and Crypto.unbase64(env.smac)
		env.bmac = env.bmac and Crypto.unbase64(env.bmac)
		if not env.sealed or not env.smac or not env.bmac or not env.ep then return nil end
		-- A body that arrived short was mangled on the way (some executors truncate): the MAC would
		-- catch it anyway, this just skips the work.
		if env.len and #body ~= tonumber(env.len) then return nil end

		local K = Crypto.deriveK(key, env.ep, f.hw, cn, f.sn, ct)
		local plain = Crypto.open(env, body, K, cn, f.sn)
		return plain
	end

	-- Two ways to download: game:HttpGet, and the executor's own request() as a second route. Some
	-- executors hand back a cut-off body for large downloads; the other route often does not.
	local function fetch(u, preferRequest)
		local req = httpRequest()
		local function viaRequest()
			if not req then return nil end
			local ok, res = pcall(req, { Url = u, Method = "GET" })
			if ok and type(res) == "table" and type(res.Body) == "string" then return res.Body end
			return nil
		end
		local function viaHttpGet()
			local ok, body = pcall(function() return game:HttpGet(u) end)
			if ok and type(body) == "string" then return body end
			return nil
		end
		-- request() first, always, because it is the call the executor attaches its fingerprint
		-- header to -- switching transport switches which device the server thinks this is. HttpGet
		-- is preferred only on the LAST attempt, when the alternative is not loading at all.
		if preferHttpGet then return viaHttpGet() or viaRequest() end
		return viaRequest() or viaHttpGet()
	end

	-- The payload ends with this line, so a download that lacks it was cut off on the way.
	local EOF_MARK = "-- FROSTED_BUNDLE_EOF"
	local function describe(body)
		if type(body) ~= "string" or #body == 0 then return "the download came back empty" end
		local head = body:sub(1, 40):gsub("%s+", " ")
		if body:sub(1, 1) == "<" then
			return "a web page came back instead of the script (a VPN, proxy or firewall may be blocking frosted.run)"
		end
		return ("got %d bytes, starting %q"):format(#body, head)
	end

	-- The screen freezes over while the script downloads (getgenv().FrostedNoIntro = true turns it off).
	-- Built on its own thread: a first run downloads the intro's pictures alongside the script.
	local intro, introReady = nil, false
	task.spawn(function()
		local ok, made = pcall(FrostedIntro, ORIGIN)
		if ok then intro = made end
		introReady = true
	end)
	local chunkToRun
	local success, result = pcall(function()
		local lastErr, lastBody
		-- The sealed path first, if this executor and this server both do it. Any problem at all and
		-- this returns nil, and the plain loop below runs exactly as it always has.
		local ok, sealed = pcall(sealedFetch)
		if ok and type(sealed) == "string" and #sealed > 0 then
			local chunk, err = loadstring(sealed)
			if chunk then chunkToRun = chunk return true end
			lastErr = err
		end
		for attempt = 1, 3 do
			-- Attempts 1 and 2 keep the same transport (and so the same device identity); only the
			-- third falls back to HttpGet, which some executors need for a large body.
			local body = fetch(url, attempt > 2)
			lastBody = body
			if type(body) == "string" and #body > 0 then
				local chunk, err = loadstring(body)
				-- A refusal (no key, expired, rotated) is short runnable Lua that explains itself and
				-- returns false; it compiles, so it runs here and never reaches the kick below.
				if chunk then chunkToRun = chunk return true end
				lastErr = err
				-- Complete but still not compiling is a real fault, not a bad download: retrying won't help.
				if body:find(EOF_MARK, -64, true) then
					error("the download did not compile (" .. tostring(err) .. ")", 0)
				end
			end
			if attempt < 3 then task.wait(1) end
		end
		error("the download was incomplete after 3 tries: " .. describe(lastBody)
			.. (lastErr and (" (" .. tostring(lastErr) .. ")") or ""), 0)
	end)

	-- The ice shatters first, then the menu (or the server's refusal) runs.
	local waitUntil = os.clock() + 6
	while not introReady and os.clock() < waitUntil do task.wait() end
	if intro then pcall(intro.Finish, intro, success) end
	if success and chunkToRun then
		local ran, res = pcall(chunkToRun)
		if ran then
			-- A refusal returns false. Anything else is the script, running on an accepted key.
			if res ~= false and KEY_NOTE then notify(KEY_NOTE[1], KEY_NOTE[2]) end
			return res
		end
		success, result = false, res
	end
	if not success then
		kick("Failed to Load Script", "Error: " .. tostring(result))
		return false
	end
	return result
end

-- Execute
return Task()
