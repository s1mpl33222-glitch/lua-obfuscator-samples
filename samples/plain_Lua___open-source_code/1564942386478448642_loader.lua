local CFG = {
API     = "https://aurora-auth.pages.dev",
VER     = "1.2.0",
KEYDIR  = "AURORA",
KEYFILE = "AURORA/key.txt",
CLAIM_URL  = "https://aurora-auth.pages.dev/",
CLAIM_HOST = "aurora-auth.pages.dev",
}
if type(getgenv) ~= "function" then warn("[AURORA] 必须在注入器里运行") return end
local GENV = getgenv()
local _HttpGet = game.HttpGet
local _loadstr = loadstring
local function hasFn(n)
return type(rawget(_G, n)) == "function" or type(rawget(GENV, n)) == "function"
end
for _, n in ipairs({ "loadstring", "hookfunction", "getrawmetatable" }) do
if not hasFn(n) then warn("[AURORA] 缺少执行器函数：" .. n) return end
end
local HWID, httpPost
local REPORTED = {}
local function report(kind, detail)
if REPORTED[kind] then return end
REPORTED[kind] = true
pcall(function()
local srv = (getgenv and getgenv().AURORA_SERVER) or {}
local body = HttpService:JSONEncode({
key = tostring(srv.key or ""),
hwid = tostring(HWID or ""),
who = tostring((game:GetService("Players").LocalPlayer or {}).Name or ""),
kind = tostring(kind),
detail = tostring(detail or ""),
})
pcall(function() httpPost(CFG.API .. "/api/report", body) end)
end)
end
local function hijacked()
if loadstring ~= _loadstr or game.HttpGet ~= _HttpGet then
report("hook_global", "loadstring/HttpGet 被替换")
return true
end
local okC, canary = pcall(function() return _loadstr("return 42") end)
if not okC or type(canary) ~= "function" then
report("canary_fail", "loadstring 编译异常")
return true
end
local okR, val = pcall(canary)
if not okR or val ~= 42 then
report("canary_bad", "编译结果被篡改")
return true
end
if iscclosure and not iscclosure(_loadstr) then
report("ls_wrapped", "loadstring 被 Lua 包装")
return true
end
return false
end
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
HWID = "u" .. tostring(LP and LP.UserId or 0)
local function Create(class, props, children)
local inst = Instance.new(class); local parent = nil
if props then for k, v in pairs(props) do
if k == "Parent" then parent = v else pcall(function() inst[k] = v end) end
end end
if children then for _, c in ipairs(children) do c.Parent = inst end end
if parent then inst.Parent = parent end
return inst
end
local function Corner(p, r)
local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = p; return c
end
local function Stroke(p, color, thick, transp)
local s = Instance.new("UIStroke"); s.Color = color; s.Thickness = thick or 1
s.Transparency = transp or 0.4; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end
local function Tw(obj, time, props, style, dir)
if not obj or not obj.Parent then return end
local t = TweenService:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
t:Play(); return t
end
local function Spring(obj, props, speed)
if not obj or not obj.Parent then return end
local t = TweenService:Create(obj, TweenInfo.new(speed or 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
t:Play(); return t
end
local function GetParentGui()
local ok, h = pcall(function() return gethui and gethui() or nil end)
if ok and h then return h end
local pg = LP and LP:FindFirstChild("PlayerGui")
if not pg then
local ok2, p = pcall(function() return LP:WaitForChild("PlayerGui", 5) end)
if ok2 then pg = p end
end
return pg or game:GetService("CoreGui")
end
local function Label(parent, text, color, size)
return Create("TextLabel", { BackgroundTransparency = 1, Size = size or UDim2.new(1, 0, 1, 0),
Text = tostring(text or ""), TextColor3 = color or Color3.fromRGB(255, 255, 255), TextSize = 14,
Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Parent = parent })
end
local function OceanWave(targetGui, onPeak, onComplete)
if not targetGui then
if onPeak then pcall(onPeak) end
if onComplete then pcall(onComplete) end
return
end
local durIn, durFade = 0.55, 0.35
local waveGui = Instance.new("ScreenGui")
waveGui.Name = "AuroraWaveOverlay"; waveGui.ResetOnSpawn = false
waveGui.IgnoreGuiInset = true; waveGui.DisplayOrder = 2147483647
waveGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; waveGui.Parent = targetGui.Parent
local waveGroup = Instance.new("CanvasGroup")
waveGroup.Size = UDim2.fromScale(1, 1); waveGroup.BackgroundTransparency = 1; waveGroup.Parent = waveGui
local clipper = Instance.new("Frame")
clipper.Size = UDim2.new(0, 0, 1, 0); clipper.BackgroundTransparency = 1
clipper.BorderSizePixel = 0; clipper.ClipsDescendants = true; clipper.Parent = waveGroup
local ocean = Instance.new("Frame")
ocean.Size = UDim2.fromScale(1, 1); ocean.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ocean.BorderSizePixel = 0; ocean.Parent = clipper
local og = Instance.new("UIGradient")
og.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)); og.Rotation = 90; og.Parent = ocean
for i = 1, 28 do
local line = Instance.new("Frame")
line.Size = UDim2.new(0, 0, 0, 1); line.Position = UDim2.new(0, 0, (i - 1) / 28, 0)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.78 + math.random() * 0.15
line.BorderSizePixel = 0; line.Parent = clipper
local fw = 0.95 + math.random() * 0.05
local delay = math.random() * 0.08
task.delay(delay, function()
if line.Parent then
TweenService:Create(line, TweenInfo.new(math.max(durIn - delay, 0.1), Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{ Size = UDim2.new(fw, 0, 0, 1) }):Play()
end
end)
end
local edge = Instance.new("Frame")
edge.Size = UDim2.new(0, 3, 1, 0); edge.Position = UDim2.new(1, 0, 0, 0); edge.AnchorPoint = Vector2.new(1, 0)
edge.BackgroundColor3 = Color3.fromRGB(255, 255, 255); edge.BorderSizePixel = 0; edge.Parent = clipper
local es = Instance.new("UIStroke"); es.Color = Color3.fromRGB(255, 255, 255); es.Thickness = 22; es.Transparency = 0.55; es.Parent = edge
local glowF = Instance.new("Frame")
glowF.Size = UDim2.new(0, 160, 1, 0); glowF.Position = UDim2.new(1, 0, 0, 0); glowF.AnchorPoint = Vector2.new(1, 0)
glowF.BackgroundColor3 = Color3.fromRGB(255, 255, 255); glowF.BackgroundTransparency = 0.75
glowF.BorderSizePixel = 0; glowF.Parent = clipper
local phase1 = TweenService:Create(clipper, TweenInfo.new(durIn, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) })
phase1.Completed:Connect(function()
if onPeak then pcall(onPeak) end
TweenService:Create(waveGroup, TweenInfo.new(durFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 1 }):Play()
task.delay(durFade + 0.05, function()
if onComplete then pcall(onComplete) end
if waveGui and waveGui.Parent then waveGui:Destroy() end
end)
end)
phase1:Play()
end
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local B64IDX = {}
for i = 1, 64 do B64IDX[string.sub(B64, i, i)] = i - 1 end
local function b64decode(s)
s = string.gsub(s, "[^%w%+/=]", "")
local out, n = {}, 0
local buf, bits = 0, 0
for i = 1, #s do
local c = string.sub(s, i, i)
if c == "=" then break end
local v = B64IDX[c]
if v then
buf = buf * 64 + v
bits = bits + 6
while bits >= 8 do
bits = bits - 8
local b = math.floor(buf / 2 ^ bits) % 256
n = n + 1
out[n] = string.char(b)
end
if bits > 0 then
buf = buf % (2 ^ bits)
else
buf = 0
end
end
end
return table.concat(out, "", 1, n)
end
local function rc4(data, key)
local klen = #key
local S = table.create and table.create(256) or {}
for i = 0, 255 do S[i + 1] = i end
local j = 0
for i = 0, 255 do
j = (j + S[i + 1] + string.byte(key, (i % klen) + 1)) % 256
S[i + 1], S[j + 1] = S[j + 1], S[i + 1]
end
local out = table.create and table.create(#data) or {}
local a, b = 0, 0
local pos = 1
local total = #data
while pos <= total do
local stop = math.min(pos + 4095, total)
local bytes = { string.byte(data, pos, stop) }
for k = 1, #bytes do
a = (a + 1) % 256
b = (b + S[a + 1]) % 256
S[a + 1], S[b + 1] = S[b + 1], S[a + 1]
local z = S[((S[a + 1] + S[b + 1]) % 256) + 1]
out[pos + k - 1] = string.char(bit32.bxor(bytes[k], z))
end
pos = stop + 1
end
return table.concat(out, "", 1, total)
end
local function chacha20(key, nonce, data)
local band, bxor, rshift, lshift = bit32.band, bit32.bxor, bit32.rshift, bit32.lshift
local bor = bit32.bor
local function rotl(v, c) return bor(band(lshift(v, c), 0xFFFFFFFF), rshift(v, 32 - c)) end
local function q(s, a, b, c2, d)
s[a] = (s[a] + s[b]) % 4294967296; s[d] = rotl(bxor(s[d], s[a]), 16)
s[c2] = (s[c2] + s[d]) % 4294967296; s[b] = rotl(bxor(s[b], s[c2]), 12)
s[a] = (s[a] + s[b]) % 4294967296; s[d] = rotl(bxor(s[d], s[a]), 8)
s[c2] = (s[c2] + s[d]) % 4294967296; s[b] = rotl(bxor(s[b], s[c2]), 7)
end
local st = {0x61707865, 0x3320646e, 0x79622d32, 0x6b206574}
local function rd4(s, p)
local a2, b2, c3, d2 = string.byte(s, p, p + 3)
return a2 + b2 * 256 + c3 * 65536 + d2 * 16777216
end
for i2 = 0, 7 do st[5 + i2] = rd4(key, 1 + i2 * 4) end
st[13] = 0
st[14], st[15], st[16] = rd4(nonce, 1), rd4(nonce, 5), rd4(nonce, 9)
local out, off, ctr, n = {}, 1, 0, #data
local CH = 32768
while off <= n do
local buf = {}
while #buf < CH and off <= n do
ctr = ctr + 1
st[13] = ctr
local x = {}
for i2 = 1, 16 do x[i2] = st[i2] end
for _ = 1, 10 do
q(x, 1, 5, 9, 13);  q(x, 2, 6, 10, 14); q(x, 3, 7, 11, 15); q(x, 4, 8, 12, 16)
q(x, 1, 6, 11, 16); q(x, 2, 7, 12, 13); q(x, 3, 8, 9, 14);  q(x, 4, 5, 10, 15)
end
local ks = {}
for i2 = 1, 16 do ks[i2] = (x[i2] + st[i2]) % 4294967296 end
local bb = {}
for i2 = 1, 16 do
local v2 = ks[i2]
bb[#bb + 1] = string.char(v2 % 256, math.floor(v2 / 256) % 256,
math.floor(v2 / 65536) % 256, math.floor(v2 / 16777216) % 256)
end
local block = table.concat(bb)
local take = math.min(64, n - off + 1)
local chars = {}
for i2 = 1, take do
chars[i2] = string.char(bxor(string.byte(data, off + i2 - 1), string.byte(block, i2)))
end
buf[#buf + 1] = table.concat(chars)
off = off + take
end
out[#out + 1] = table.concat(buf)
end
return table.concat(out)
end
local function parsePayload(s)
local files = {}
local i = 1
local len = #s
while i <= len do
local a = string.find(s, "\31", i, true)
if not a then break end
local b = string.find(s, "\31", a + 1, true)
if not b then break end
local name = string.sub(s, i, a - 1)
local n = tonumber(string.sub(s, a + 1, b - 1))
if not n or n <= 0 or b + n > len then break end
files[#files + 1] = { name = name, code = string.sub(s, b + 1, b + n) }
i = b + n + 1
end
return files
end
local function httpGet(url)
local ok, res = pcall(function() return _HttpGet(game, url) end)
if not ok or type(res) ~= "string" then return nil, tostring(res) end
return res
end
httpPost = function(url, body)
local reqFn = rawget(GENV, "request") or rawget(_G, "request")
or rawget(GENV, "http_request") or rawget(_G, "http_request")
if type(reqFn) ~= "function" then return nil, "执行器不支持 POST" end
local ok, res = pcall(reqFn, {
Url = url,
Method = "POST",
Headers = { ["Content-Type"] = "application/json" },
Body = body,
})
if not ok then return nil, "请求异常" end
if type(res) ~= "table" then return nil, "返回格式异常" end
return { code = res.StatusCode or res.Status, body = res.Body or res.body or "" }
end
local function jsonDecode(s)
local ok, v = pcall(function() return HttpService:JSONDecode(s) end)
if ok then return v end
return nil
end
local function fsOk()
return type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"
end
local function loadKey()
if not fsOk() then return "" end
local ok, v = pcall(function()
if not isfile(CFG.KEYFILE) then return "" end
return readfile(CFG.KEYFILE) or ""
end)
if ok and type(v) == "string" then return (string.gsub(v, "%s+$", "")) end
return ""
end
local function saveKey(k)
if not fsOk() or type(k) ~= "string" or #k < 4 then return end
pcall(function()
if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder(CFG.KEYDIR) then
makefolder(CFG.KEYDIR)
end
writefile(CFG.KEYFILE, k)
end)
end
local ERR = {
KEY_INVALID = "密钥无效",
BANNED      = "该密钥已被封禁",
EXPIRED     = "密钥已过期",
HWID_LOCKED = "已绑定其他设备",
OUTDATED    = "版本过旧，请重新获取",
RATE_LIMIT  = "请求太频繁，稍等一会",
OFFLINE     = "无法连接服务器",
}
local function describe(code, extra)
local s = ERR[code] or ("校验失败：" .. tostring(code))
if extra and extra ~= "" then s = s .. "（" .. tostring(extra) .. "）" end
return s
end
local function doAuth(key)
local ok, body = pcall(function()
return HttpService:JSONEncode({ key = key, hwid = HWID, ver = CFG.VER })
end)
if not ok then return false, "OFFLINE", "JSON 编码失败" end
local res, err = httpPost(CFG.API .. "/api/auth", body)
if not res then return false, "OFFLINE", err end
if res.code == 429 then return false, "RATE_LIMIT" end
if not res.code or res.code < 200 or res.code >= 300 then
return false, "OFFLINE", "HTTP " .. tostring(res.code)
end
local data = jsonDecode(res.body)
if type(data) ~= "table" then return false, "OFFLINE", "返回无法解析" end
if not data.ok then return false, data.err or "KEY_INVALID", data.msg end
return true, data
end
local runFiles
local SEG_SEP = string.char(30)
local function fetchSegments(authData, key)
local ok, body = pcall(function()
return HttpService:JSONEncode({
k = key,
h = HWID,
t = tostring(authData.t or ""),
v = tostring(authData.kv or "1"),
})
end)
if not ok then return nil, "请求编码失败" end
local res, err = httpPost(CFG.API .. "/api/payload", body)
if not res then return nil, "下载失败（" .. tostring(err) .. "）" end
if res.code ~= 200 then
local j = jsonDecode(res.body)
local code2 = type(j) == "table" and j.err or ("HTTP " .. tostring(res.code))
return nil, "服务端拒绝：" .. tostring(code2)
end
local blob = res.body or ""
if #blob < 500 then return nil, "内容异常（" .. #blob .. " 字节）" end
local segs = {}
for seg in string.gmatch(blob, "[^" .. SEG_SEP .. "]+") do
segs[#segs + 1] = seg
end
blob = nil
if #segs == 0 then return nil, "分包解析失败" end
local expect = tonumber(authData.parts) or 0
if expect > 0 and #segs < expect then
return nil, "段数不足（至少 " .. expect .. "，实际 " .. #segs .. "）"
end
return segs
end
local KEYS = nil
local BUILD = nil
local function runSegment(segs, i, master, wm)
local blob = b64decode(segs[i])
segs[i] = nil
local nonce, ct = string.sub(blob, 1, 12), string.sub(blob, 13)
local hexKey = (KEYS and KEYS[i]) or nil
local plain
if hexKey and #hexKey == 64 then
local key = string.gsub(hexKey, "..", function(h) return string.char(tonumber(h, 16)) end)
plain = chacha20(key, nonce, ct)
else
plain = rc4(blob, master .. ":" .. i)
end
blob, ct = nil, nil
local files = parsePayload(plain)
plain = nil
if #files == 0 then return false, "第 " .. i .. " 段解密失败" end
local wmTag = tostring(wm) .. "@" .. tostring(os.date("%Y%m%d-%H%M"))
.. ((BUILD and BUILD ~= "") and ("@" .. tostring(BUILD)) or "")
for _, f in ipairs(files) do
f.code = string.gsub(f.code, "@@WM@@", wmTag)
if f.name == "main" then
f.code = "-- AURORA " .. wmTag .. "\n" .. f.code
end
f.wm  = wm
f.seg = i
end
local ok = runFiles(files)
files = nil
return ok
end
runFiles = function(files)
local n = 0
for i, f in ipairs(files) do
if hijacked() then warn("[AURORA] 检测到劫持，已中止") return false end
local chunk, err = _loadstr(f.code, "=" .. string.sub(tostring(f.wm or "K"), 1, 4) .. "_" .. tostring(f.seg or i))
f.code = nil
if not chunk then
warn("[AURORA] " .. f.name .. " 编译失败：" .. tostring(err))
else
task.spawn(function()
local ok, e = pcall(chunk)
if not ok then warn("[AURORA] " .. f.name .. " 运行出错：" .. tostring(e)) end
end)
n = n + 1
print("[AURORA] 已加载：" .. f.name)
end
if i < #files then task.wait(0.6) end
end
return n > 0
end
local function startWatch()
task.spawn(function()
task.wait(5)
while true do
if loadstring ~= _loadstr or game.HttpGet ~= _HttpGet then
warn("[AURORA] 关键函数被替换，已中止")
pcall(function()
if GENV.AURORA_V1 and GENV.AURORA_V1.Unload then GENV.AURORA_V1:Unload("hook") end
end)
return
end
task.wait(5)
end
end)
end
local TEXT = {
BRAND = "AURORA", LOGO = "A",
NAME = "AURORA",
PILL = "K E Y   S Y S T E M",
LABEL = "E N T E R   Y O U R   K E Y",
PLACEHOLDER = "输入密钥…",
VERIFY = "验证密钥",
BANNER_IDLE = "请输入你的密钥",
BANNER_ERR = "密钥错误",
BANNER_EMPTY = "请先输入密钥",
}
local NAME_TRANSPARENCY = 0.72
local CLR = {
Card    = Color3.fromRGB(11, 11, 14),
Edge    = Color3.fromRGB(216, 216, 228),
Split   = Color3.fromRGB(255, 255, 255),
Line    = Color3.fromRGB(64, 64, 74),
Input   = Color3.fromRGB(16, 16, 20),
Faint   = Color3.fromRGB(86, 86, 98),
White   = Color3.fromRGB(233, 233, 238),
Pure    = Color3.fromRGB(245, 245, 248),
Blurple = Color3.fromRGB(88, 101, 242),
Success = Color3.fromRGB(64, 200, 140),
Danger  = Color3.fromRGB(238, 96, 116),
}
local function RunKeySystem(prefill)
local gui = Create("ScreenGui", { Name = "AURORA_KEY", ResetOnSpawn = false, IgnoreGuiInset = true,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 99999, Parent = GetParentGui() })
local CW, CH = 500, 228
local HEAD, MIDX = 50, 280
local T0 = 0.45
local card = Create("Frame", { Size = UDim2.new(0, CW * 0.9, 0, CH * 0.9), Position = UDim2.new(0.5, -CW / 2, 0.5, -CH / 2 + 16),
BackgroundColor3 = CLR.Card, BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, Parent = gui })
Corner(card, 12)
local cardSk = Stroke(card, CLR.Edge, 1.5, 1)
Tw(card, 0.42, { Size = UDim2.new(0, CW, 0, CH), Position = UDim2.new(0.5, -CW / 2, 0.5, -CH / 2), BackgroundTransparency = 0 },
Enum.EasingStyle.Back, Enum.EasingDirection.Out)
Tw(cardSk, 0.42, { Transparency = 0.5 })
local dg, ds, cs = false, nil, nil
card.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dg = true; ds = i.Position; cs = card.Position
end
end)
UserInputService.InputChanged:Connect(function(i)
if dg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
local d = i.Position - ds
card.Position = UDim2.new(cs.X.Scale, cs.X.Offset + d.X, cs.Y.Scale, cs.Y.Offset + d.Y)
end
end)
UserInputService.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dg = false end
end)
local leftDots = Create("Frame", { Size = UDim2.new(0, MIDX, 0, CH - HEAD), Position = UDim2.new(0, 0, 0, HEAD),
BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 1, Parent = card })
local rightDots = Create("Frame", { Size = UDim2.new(0, CW - MIDX, 0, CH - HEAD), Position = UDim2.new(0, MIDX, 0, HEAD),
BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 1, Parent = card })
local hLine = Create("Frame", { Size = UDim2.new(0, 0, 0, 1), Position = UDim2.new(0, 0, 0, HEAD),
BackgroundColor3 = CLR.Split, BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 2, Parent = card })
local vLine = Create("Frame", { Size = UDim2.new(0, 1, 0, 0), Position = UDim2.new(0, MIDX, 0, HEAD),
BackgroundColor3 = CLR.Split, BackgroundTransparency = 0.9, BorderSizePixel = 0, ZIndex = 2, Parent = card })
local logo = Create("Frame", { Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0, 14, 0, 11),
BackgroundColor3 = CLR.Pure, BorderSizePixel = 0, ZIndex = 3, Parent = card })
Corner(logo, 7)
local logoL = Label(logo, TEXT.LOGO, Color3.fromRGB(13, 13, 16), UDim2.fromScale(1, 1))
logoL.TextXAlignment = Enum.TextXAlignment.Center; logoL.Font = Enum.Font.GothamBold; logoL.TextSize = 14; logoL.TextTransparency = 1
local title = Label(card, TEXT.BRAND, CLR.White, UDim2.new(0, 180, 0, 28))
title.Position = UDim2.new(0, 48, 0, 11); title.TextSize = 15; title.Font = Enum.Font.GothamBold
title.TextTransparency = 1; title.ZIndex = 3
local pill = Create("Frame", { Size = UDim2.fromOffset(80, 18), Position = UDim2.new(1, -114, 0, 15),
BackgroundColor3 = Color3.fromRGB(18, 18, 23), BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 3, Parent = card })
Corner(pill, 9)
local pillSk = Stroke(pill, CLR.Line, 1, 1)
local pillL = Label(pill, TEXT.PILL, CLR.Faint, UDim2.fromScale(1, 1))
pillL.TextXAlignment = Enum.TextXAlignment.Center; pillL.TextSize = 8; pillL.Font = Enum.Font.GothamBold; pillL.TextTransparency = 1
local closeB = Create("TextButton", { Size = UDim2.fromOffset(22, 22), Position = UDim2.new(1, -32, 0, 12),
BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 3, Parent = card })
local barA = Create("Frame", { Size = UDim2.fromOffset(9, 1.2), Position = UDim2.new(0.5, -4.5, 0.5, -0.6),
BackgroundColor3 = CLR.Faint, BackgroundTransparency = 1, BorderSizePixel = 0, Rotation = 45, Parent = closeB })
local barB = Create("Frame", { Size = UDim2.fromOffset(9, 1.2), Position = UDim2.new(0.5, -4.5, 0.5, -0.6),
BackgroundColor3 = CLR.Faint, BackgroundTransparency = 1, BorderSizePixel = 0, Rotation = -45, Parent = closeB })
closeB.MouseEnter:Connect(function() Tw(barA, 0.15, { BackgroundColor3 = CLR.White }); Tw(barB, 0.15, { BackgroundColor3 = CLR.White }) end)
closeB.MouseLeave:Connect(function() Tw(barA, 0.15, { BackgroundColor3 = CLR.Faint }); Tw(barB, 0.15, { BackgroundColor3 = CLR.Faint }) end)
closeB.MouseButton1Click:Connect(function() OceanWave(gui, function() gui:Destroy() end) end)
local lb1 = Label(card, TEXT.LABEL, CLR.Faint, UDim2.new(0, 244, 0, 14))
lb1.Position = UDim2.new(0, 18, 0, 60); lb1.TextSize = 9; lb1.Font = Enum.Font.GothamBold; lb1.TextTransparency = 1; lb1.ZIndex = 3
local inputH = Create("Frame", { Size = UDim2.new(0, 244, 0, 34), Position = UDim2.new(0, 18, 0, 78),
BackgroundColor3 = CLR.Input, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3, Parent = card })
Corner(inputH, 7); local inputSk = Stroke(inputH, CLR.Line, 1, 1)
local input = Create("TextBox", { Size = UDim2.new(1, -22, 1, 0), Position = UDim2.new(0, 11, 0, 0),
BackgroundTransparency = 1, Text = prefill or "", PlaceholderText = TEXT.PLACEHOLDER, PlaceholderColor3 = CLR.Faint,
TextColor3 = CLR.White, TextSize = 11, Font = Enum.Font.Code, ClearTextOnFocus = false, Parent = inputH })
input.Focused:Connect(function() Tw(inputSk, 0.2, { Color = CLR.Blurple, Transparency = 0.15 }) end)
local verifyB = Create("TextButton", { Size = UDim2.new(0, 244, 0, 32), Position = UDim2.new(0, 18, 0, 120),
BackgroundColor3 = CLR.Pure, BackgroundTransparency = 1, BorderSizePixel = 0, Text = TEXT.VERIFY,
TextColor3 = Color3.fromRGB(13, 13, 16), TextTransparency = 1, TextSize = 11,
Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 3, Parent = card })
Corner(verifyB, 7)
verifyB.MouseEnter:Connect(function() Tw(verifyB, 0.15, { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }) end)
verifyB.MouseLeave:Connect(function() Tw(verifyB, 0.15, { BackgroundColor3 = CLR.Pure }) end)
local banner = Create("Frame", { Size = UDim2.new(0, 244, 0, 32), Position = UDim2.new(0, 18, 0, 160),
BackgroundColor3 = CLR.Blurple, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = card })
Corner(banner, 7)
local bannerLbl = Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -90, 1, 0),
Position = UDim2.new(0, 12, 0, 0), Text = TEXT.BANNER_IDLE, TextColor3 = CLR.Pure,
TextTransparency = 1, TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Parent = banner })
local getKeyB = Create("TextButton", { Size = UDim2.new(0, 70, 0, 22), Position = UDim2.new(1, -78, 0.5, -11),
BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, BorderSizePixel = 0,
Text = "获取密钥", TextColor3 = Color3.fromRGB(13, 13, 16), TextSize = 10,
Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = banner })
Corner(getKeyB, 6)
local nameLbl = Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 204, 0, 56),
Position = UDim2.new(0, 288, 0, 96), Text = TEXT.NAME, TextColor3 = CLR.White,
TextScaled = true, TextWrapped = false, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
TextTransparency = 1, ZIndex = 3, Parent = card })
local function spawnDots(parent, w, h, count)
for _ = 1, count do
local dot = Create("Frame", { Size = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.55 + math.random() * 0.35, BorderSizePixel = 0, ZIndex = 1, Parent = parent })
Corner(dot, 2)
task.spawn(function()
while dot.Parent do
local sx = math.random(0, math.max(w - 4, 1))
local size = 1 + math.random()
local dur = 3.2 + math.random() * 4.5
dot.Size = UDim2.fromOffset(size, size)
dot.Position = UDim2.new(0, sx, 0, -6)
dot.BackgroundTransparency = 0.5 + math.random() * 0.4
TweenService:Create(dot, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
Position = UDim2.new(0, sx - math.random(14, 46), 0, h + 6)
}):Play()
task.wait(dur + math.random() * 2.5)
end
end)
end
end
task.delay(T0, function()
if not card.Parent then return end
spawnDots(leftDots, MIDX, CH - HEAD, 16)
spawnDots(rightDots, CW - MIDX, CH - HEAD, 14)
end)
task.delay(T0 + 0.05, function() if hLine.Parent then Tw(hLine, 0.42, { Size = UDim2.new(1, 0, 0, 1) }, Enum.EasingStyle.Quart) end end)
task.delay(T0 + 0.12, function()
if logo.Parent then Spring(logo, { Size = UDim2.fromOffset(28, 28) }, 0.4) end
if logoL.Parent then Tw(logoL, 0.28, { TextTransparency = 0 }) end
end)
task.delay(T0 + 0.18, function() if title.Parent then Tw(title, 0.32, { TextTransparency = 0 }) end end)
task.delay(T0 + 0.24, function()
if pill.Parent then Tw(pill, 0.28, { BackgroundTransparency = 0 }) end
if pillSk.Parent then Tw(pillSk, 0.28, { Transparency = 0.35 }) end
if pillL.Parent then Tw(pillL, 0.28, { TextTransparency = 0 }) end
if barA.Parent then Tw(barA, 0.28, { BackgroundTransparency = 0 }) end
if barB.Parent then Tw(barB, 0.28, { BackgroundTransparency = 0 }) end
end)
task.delay(T0 + 0.3, function()
if vLine.Parent then Tw(vLine, 0.45, { Size = UDim2.new(0, 1, 0, CH - HEAD - 12) }, Enum.EasingStyle.Quart) end
if lb1.Parent then Tw(lb1, 0.3, { TextTransparency = 0 }) end
end)
task.delay(T0 + 0.36, function()
if inputH.Parent then Tw(inputH, 0.3, { BackgroundTransparency = 0 }) end
if inputSk.Parent then Tw(inputSk, 0.3, { Transparency = 0.35 }) end
end)
task.delay(T0 + 0.42, function()
if verifyB.Parent then Tw(verifyB, 0.28, { BackgroundTransparency = 0, TextTransparency = 0 }) end
if nameLbl.Parent then Tw(nameLbl, 0.55, { TextTransparency = NAME_TRANSPARENCY }) end
end)
task.delay(T0 + 0.5, function()
if banner.Parent then Tw(banner, 0.28, { BackgroundTransparency = 0 }) end
if bannerLbl.Parent then Tw(bannerLbl, 0.28, { TextTransparency = 0 }) end
if getKeyB.Parent then Tw(getKeyB, 0.28, { BackgroundTransparency = 0.88, TextTransparency = 0 }) end
end)
local verified, busy = false, false
local function shake()
Tw(inputH, 0.07, { Position = UDim2.new(0, 25, 0, 78) }); task.wait(0.06)
Tw(inputH, 0.07, { Position = UDim2.new(0, 11, 0, 78) }); task.wait(0.06)
Tw(inputH, 0.1,  { Position = UDim2.new(0, 18, 0, 78) })
end
local function bannerFlash(msg, isOk)
if not banner.Parent then return end
bannerLbl.Text = msg
Tw(banner, 0.18, { BackgroundColor3 = isOk and CLR.Success or CLR.Danger })
if not isOk then
task.delay(1.8, function()
if banner.Parent and not verified then
Tw(banner, 0.35, { BackgroundColor3 = CLR.Blurple })
task.delay(0.36, function() if banner.Parent then bannerLbl.Text = TEXT.BANNER_IDLE end end)
end
end)
end
end
getKeyB.MouseButton1Click:Connect(function()
local copied = false
if type(setclipboard) == "function" then
copied = pcall(setclipboard, CFG.CLAIM_URL)
end
getKeyB.Text = copied and "已复制" or "手动输入"
bannerLbl.Text = "浏览器打开 " .. CFG.CLAIM_HOST
Tw(banner, 0.18, { BackgroundColor3 = CLR.Blurple })
task.delay(4, function()
if getKeyB.Parent then getKeyB.Text = "获取密钥" end
if bannerLbl.Parent and not verified and not busy then
bannerLbl.Text = TEXT.BANNER_IDLE
end
end)
end)
local function try()
if verified or busy then return end
local entered = input.Text:gsub("^%s+", ""):gsub("%s+$", ""):upper()
if entered == "" then bannerFlash(TEXT.BANNER_EMPTY); shake(); return end
busy = true
bannerLbl.Text = "验证中…"; Tw(banner, 0.2, { BackgroundColor3 = CLR.Blurple })
verifyB.Text = "验证中…"
task.spawn(function()
local ok, data, extra = doAuth(entered)
if not ok then
busy = false
verifyB.Text = TEXT.VERIFY
input.Text = ""
bannerFlash(describe(data, extra))
shake()
return
end
verified = true
saveKey(entered)
local _exp = tonumber(data.exp) or 0
GENV.AURORA_SERVER = {
key   = entered,
hwid  = HWID,
exp   = _exp,
level = (_exp == 0) and "perm" or "free",
plan  = tostring(data.plan or ""),
}
bannerLbl.Text = "验证成功 · 正在下载…"
Tw(banner, 0.2, { BackgroundColor3 = CLR.Success })
Tw(verifyB, 0.25, { BackgroundColor3 = CLR.Success, TextColor3 = CLR.Pure })
verifyB.Text = "已授权"
Spring(logo, { Size = UDim2.fromOffset(32, 32) }, 0.3)
bannerLbl.Text = "等待中…"
local segs, err2 = fetchSegments(data, entered)
if not segs then
verified = false
busy = false
verifyB.Text = TEXT.VERIFY
bannerFlash(tostring(err2), false)
return
end
local segCount = #segs
local master = tostring(data.k or "")
KEYS = type(data.ks) == "table" and data.ks or nil
BUILD = tostring(data.b or "")
local wm = tostring(data.wm or "UNKNOWN")
bannerLbl.Text = "准备就绪"
task.wait(0.1)
OceanWave(gui, function()
gui:Destroy()
end, function()
task.spawn(function()
task.wait(0.1)
for i = 1, segCount do
if hijacked() then
warn("[AURORA] 执行期间检测到劫持，已中止")
return
end
local okSeg, eSeg = runSegment(segs, i, master, wm)
if not okSeg then
warn("[AURORA] " .. tostring(eSeg))
break
end
task.wait(0.2 + math.random() * 0.12)
end
segs, master = nil, nil
startWatch()
end)
end)
end)
end
verifyB.MouseButton1Click:Connect(try)
input.FocusLost:Connect(function(enter) if enter then try() end end)
if prefill and prefill ~= "" then
task.delay(T0 + 0.9, function() if not verified and not busy then try() end end)
end
end
RunKeySystem(loadKey())
print("[AURORA] 启动器就绪 · " .. CFG.VER)
