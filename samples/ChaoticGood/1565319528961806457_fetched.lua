local _o0 = "\104\116\116\112\115\058\047\047\116\115\118\046\115\117\100\111\114\109\114\102\046\117\107"
local CLIENT_SECRET = "xyOVLnJNVNbGGmQR-bM3HHY6Vs586eYqaU1a1-lnKd46UMkiQ6YmCybFC4l6wyho"
local RESPONSE_SECRET = "_YzqzMY8TOG0nWfDKH5yg6wEyeUcymwmrCakWa9-1BiqFQGarnlZKd1bc4mcv7iO"
local _o1 = (function()
local bit32 = bit32
local band = bit32.band
local bor = bit32.bor
local bxor = bit32.bxor
local bnot = bit32.bnot
local rrotate = bit32.rrotate
local rshift = bit32.rshift
local TWO32 = 4294967296
local BLOCK_SIZE = 64
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
local function add(...)
local total = 0
for index = 1, select("\035", ...) do
total = total + (select(index, ...) or 0)
end
return total % TWO32
end
local function u32be(value)
return string.char(
math.floor(value / 16777216) % 256,
math.floor(value / 65536) % 256,
math.floor(value / 256) % 256,
value % 256
)
end
local function read_u32be(input, index)
local b1, b2, b3, b4 = string.byte(input, index, index + 3)
return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function compress(state, block)
local w = {}
for index = 1, 16 do
w[index] = read_u32be(block, (index - 1) * 4 + 1)
end
for index = 17, 64 do
local x = w[index - 15]
local y = w[index - 2]
local s0 = bxor(rrotate(x, 7), rrotate(x, 18), rshift(x, 3))
local s1 = bxor(rrotate(y, 17), rrotate(y, 19), rshift(y, 10))
w[index] = add(w[index - 16], s0, w[index - 7], s1)
end
local a, b, c, d = state[1], state[2], state[3], state[4]
local e, f, g, h = state[5], state[6], state[7], state[8]
for index = 1, 64 do
local big_s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
local choose = bxor(band(e, f), band(bnot(e), g))
local temp1 = add(h, big_s1, choose, K[index], w[index])
local big_s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
local majority = bxor(band(a, b), band(a, c), band(b, c))
local temp2 = add(big_s0, majority)
h = g
g = f
f = e
e = add(d, temp1)
d = c
c = b
b = a
a = add(temp1, temp2)
end
state[1] = add(state[1], a)
state[2] = add(state[2], b)
state[3] = add(state[3], c)
state[4] = add(state[4], d)
state[5] = add(state[5], e)
state[6] = add(state[6], f)
state[7] = add(state[7], g)
state[8] = add(state[8], h)
end
local function sha256(message)
local length_bits = #message * 8
local padding = 55 - (#message % BLOCK_SIZE)
if padding < 0 then
padding = padding + BLOCK_SIZE
end
local data = message
.. "\128"
.. string.rep("\000", padding)
.. u32be(math.floor(length_bits / TWO32))
.. u32be(length_bits % TWO32)
local state = {
0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
}
for offset = 1, #data, BLOCK_SIZE do
compress(state, string.sub(data, offset, offset + BLOCK_SIZE - 1))
end
local digest = {}
for index = 1, 8 do
digest[index] = u32be(state[index])
end
return table.concat(digest)
end
local function hmac(key, message)
if #key > BLOCK_SIZE then
key = sha256(key)
end
key = key .. string.rep("\000", BLOCK_SIZE - #key)
local inner_pad, outer_pad = {}, {}
for index = 1, BLOCK_SIZE do
local byte = string.byte(key, index)
inner_pad[index] = string.char(bxor(byte, 0x36))
outer_pad[index] = string.char(bxor(byte, 0x5c))
end
return sha256(table.concat(outer_pad) .. sha256(table.concat(inner_pad) .. message))
end
local function to_hex(binary)
return (binary:gsub("\046", function(char)
return string.format("\037\048\050\120", string.byte(char))
end))
end
local function equals(left, right)
if type(left) ~= "\115\116\114\105\110\103" or type(right) ~= "\115\116\114\105\110\103" or #left ~= #right then
return false
end
local difference = 0
for index = 1, #left do
difference = bor(difference, bxor(string.byte(left, index), string.byte(right, index)))
end
return difference == 0
end
return {
sha256 = sha256,
sha256_hex = function(message)
return to_hex(sha256(message))
end,
hmac = hmac,
hmac_hex = function(key, message)
return to_hex(hmac(key, message))
end,
to_hex = to_hex,
equals = equals,
}
end)()
local _o2 = game:GetService("\080\108\097\121\101\114\115")
local _o3 = game:GetService("\072\116\116\112\083\101\114\118\105\099\101")
local _o4 = game:GetService("\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101")
local _o5 = 16
local _o6 = 300
local _o7 = Color3.fromRGB(6, 6, 7)
local _o8 = Color3.fromRGB(14, 14, 16)
local _o9 = Color3.fromRGB(34, 34, 39)
local _o10 = Color3.fromRGB(38, 38, 44)
local _o11 = Color3.fromRGB(245, 245, 247)
local _o12 = Color3.fromRGB(112, 112, 122)
local function _o13(parent, radius)
local item = Instance.new("\085\073\067\111\114\110\101\114")
item.CornerRadius = UDim.new(0, radius)
item.Parent = parent
return item
end
local function _o14(parent, color)
local item = Instance.new("\085\073\083\116\114\111\107\101")
item.Color = color
item.Thickness = 1
item.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
item.Parent = parent
return item
end
local function _o15(parent, properties)
local item = Instance.new("\084\101\120\116\076\097\098\101\108")
item.BackgroundTransparency = 1
item.BorderSizePixel = 0
item.Font = Enum.Font.GothamMedium
item.TextColor3 = _o11
item.TextSize = 12
item.TextXAlignment = Enum.TextXAlignment.Left
for name, value in pairs(properties) do
item[name] = value
end
item.Parent = parent
return item
end
local _o16 = 120
local _o17 = 600
local _o18 = 120
local function _o19(reason)
local player = _o2.LocalPlayer
if player then
pcall(function() player:Kick(tostring(reason)) end)
end
task.wait(0.5)
pcall(game.Shutdown, game)
end
local function _o20(message)
_o19("\091\084\115\118\072\117\098\093\032" .. tostring(message))
end
local function _o21()
local notes = {}
if type(pcall) ~= "\102\117\110\099\116\105\111\110" then
notes[#notes + 1] = "\112\099\097\108\108\032\114\101\112\108\097\099\101\100"
end
if type(_o3) ~= "\116\097\098\108\101" and type(_o3) ~= "\117\115\101\114\100\097\116\097" then
notes[#notes + 1] = "\072\116\116\112\083\101\114\118\105\099\101\032\117\110\097\118\097\105\108\097\098\108\101"
end
if type(debug) == "\116\097\098\108\101" and type(debug.getinfo) == "\102\117\110\099\116\105\111\110" and type(pcall) == "\102\117\110\099\116\105\111\110" then
local ok, info = pcall(debug.getinfo, 2, "\083")
if not ok or type(info) ~= "\116\097\098\108\101" or type(info.source) ~= "\115\116\114\105\110\103" then
notes[#notes + 1] = "\100\101\098\117\103\046\103\101\116\105\110\102\111\032\119\114\097\112\112\101\100"
end
end
return notes
end
local function _o22(env)
if env and type(env.key) == "\115\116\114\105\110\103" and #env.key > 0 then
return (env.key:gsub("\037\115\043", ""))
end
local environment = getgenv and getgenv() or {}
for _, name in ipairs({ "\115\099\114\105\112\116\107\101\121", "\083\067\082\073\080\084\075\069\089", "\107\101\121", "\108\105\099\101\110\115\101\107\101\121" }) do
local value = environment[name]
if type(value) == "\115\116\114\105\110\103" then
local cleaned = value:gsub("\037\115\043", "")
if #cleaned > 0 then return cleaned end
end
end
if type(_G) == "\116\097\098\108\101" then
for _, name in ipairs({ "\115\099\114\105\112\116\107\101\121", "\083\067\082\073\080\084\075\069\089", "\107\101\121", "\108\105\099\101\110\115\101\107\101\121" }) do
local value = _G[name]
if type(value) == "\115\116\114\105\110\103" then
local cleaned = value:gsub("\037\115\043", "")
if #cleaned > 0 then return cleaned end
end
end
end
if type(scriptkey) == "\115\116\114\105\110\103" then
return (scriptkey:gsub("\037\115\043", ""))
end
return ""
end
local function _o23(env)
if env and type(env.hwid) == "\115\116\114\105\110\103" and #env.hwid > 0 then
return env.hwid
end
local candidates = { gethwid, get_hwid }
for _, fn in ipairs(candidates) do
if type(fn) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(fn)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 3 then return value end
end
end
if type(syn) == "\116\097\098\108\101" and type(syn.get_hwid) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(syn.get_hwid)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 3 then return value end
end
if type(getgenv) == "\102\117\110\099\116\105\111\110" then
local environment = getgenv()
if type(environment.gethwid) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(environment.gethwid)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 3 then return value end
end
end
local okClient, clientId = pcall(function()
return game:GetService("\082\098\120\065\110\097\108\121\116\105\099\115\083\101\114\118\105\099\101"):GetClientId()
end)
if okClient and type(clientId) == "\115\116\114\105\110\103" and #clientId >= 8 then
return "\099\108\105\101\110\116\058" .. clientId
end
local okPlayer, localPlayer = pcall(function()
return _o2.LocalPlayer
end)
if okPlayer and localPlayer and localPlayer.UserId > 0 then
return "\097\099\099\111\117\110\116\058" .. tostring(localPlayer.UserId)
end
return nil
end
local function _o24()
if type(request) == "\102\117\110\099\116\105\111\110" then return request end
if type(http_request) == "\102\117\110\099\116\105\111\110" then return http_request end
if type(http) == "\116\097\098\108\101" and type(http.request) == "\102\117\110\099\116\105\111\110" then return http.request end
if type(http) == "\102\117\110\099\116\105\111\110" then return http end
if type(syn) == "\116\097\098\108\101" and type(syn.request) == "\102\117\110\099\116\105\111\110" then return syn.request end
if type(fluxus) == "\116\097\098\108\101" and type(fluxus.request) == "\102\117\110\099\116\105\111\110" then return fluxus.request end
if type(krnl) == "\116\097\098\108\101" and type(krnl.request) == "\102\117\110\099\116\105\111\110" then return krnl.request end
local environment = getgenv and getgenv() or {}
if type(environment.request) == "\102\117\110\099\116\105\111\110" then return environment.request end
if type(environment.http_request) == "\102\117\110\099\116\105\111\110" then return environment.http_request end
if type(environment.http) == "\116\097\098\108\101" and type(environment.http.request) == "\102\117\110\099\116\105\111\110" then return environment.http.request end
return nil
end
local function _o25()
local parts = {}
for index = 1, 12 do
parts[index] = string.format("\037\048\050\120", math.random(0, 255))
end
return table.concat(parts)
end
local function _o26(data)
if type(data) ~= "\116\097\098\108\101" or type(data.status) ~= "\115\116\114\105\110\103" or type(data.signature) ~= "\115\116\114\105\110\103" then
return nil
end
local canonical = string.format(
"\037\115\010\037\100\010\037\115\010\037\100\010\037\100",
data.status,
tonumber(data.expires_at) or 0,
tostring(data.session or ""),
tonumber(data.server_time) or 0,
tonumber(data.session_expires_at) or 0
)
if _o1.hmac_hex(RESPONSE_SECRET, canonical) ~= data.signature then
return nil
end
return data
end
local function _o27(key, hwid)
local send = _o24()
if not send then
return nil, "\116\104\105\115\032\101\120\101\099\117\116\111\114\032\100\111\101\115\032\110\111\116\032\115\117\112\112\111\114\116\032\072\084\084\080\032\114\101\113\117\101\115\116\115"
end
local timestamp = math.floor(os.time())
local nonce = _o25()
local signature = _o1.hmac_hex(CLIENT_SECRET, table.concat({ key, hwid, tostring(timestamp), nonce }, "\010"))
local body = _o3:JSONEncode({
key = key,
hwid = hwid,
timestamp = timestamp,
nonce = nonce,
signature = signature,
})
local ok, response = pcall(send, {
Url = _o0 .. "\047\097\112\105\047\118\049\047\097\117\116\104",
Method = "\080\079\083\084",
Headers = { ["\067\111\110\116\101\110\116\045\084\121\112\101"] = "\097\112\112\108\105\099\097\116\105\111\110\047\106\115\111\110" },
Body = body,
})
if not ok or type(response) ~= "\116\097\098\108\101" then
return nil, "\110\101\116\119\111\114\107\032\114\101\113\117\101\115\116\032\102\097\105\108\101\100"
end
local status = tonumber(response.StatusCode or response.Status) or 0
local raw = response.Body or response.body or ""
local decodedOk, decoded = pcall(function() return _o3:JSONDecode(raw) end)
if not decodedOk or type(decoded) ~= "\116\097\098\108\101" then
return nil, "\115\101\114\118\101\114\032\114\101\116\117\114\110\101\100\032\097\110\032\105\110\118\097\108\105\100\032\114\101\115\112\111\110\115\101"
end
local verified = _o26(decoded)
if not verified then
return nil, "\115\101\114\118\101\114\032\114\101\115\112\111\110\115\101\032\102\097\105\108\101\100\032\115\105\103\110\097\116\117\114\101\032\118\101\114\105\102\105\099\097\116\105\111\110"
end
if verified.status ~= "\079\075" then
return nil, tostring(verified.message or verified.status)
end
return verified
end
local function _o28(env)
local notes = _o21()
if #notes > 0 and type(env) == "\116\097\098\108\101" and type(env.notify) == "\102\117\110\099\116\105\111\110" and type(pcall) == "\102\117\110\099\116\105\111\110" then
pcall(env.notify, "\069\110\118\105\114\111\110\109\101\110\116\032\110\111\116\101\058\032" .. table.concat(notes, "\044\032"))
end
local key = _o22(env)
if key == "" then
_o20("\077\105\115\115\105\110\103\032\107\101\121\046\032\067\111\112\121\032\097\032\102\114\101\115\104\032\108\111\097\100\101\114\032\108\105\110\101\032\102\114\111\109\032\116\104\101\032\112\097\110\101\108\046")
return nil
end
if #key < 8 or #key > 80 or not key:match("\094\091\065\045\090\097\045\122\048\045\057\095\037\045\093\043\036") then
_o20("\084\104\105\115\032\108\105\099\101\110\115\101\032\107\101\121\032\105\115\032\110\111\116\032\118\097\108\105\100\046")
return nil
end
local rawHwid = _o23(env)
if type(rawHwid) ~= "\115\116\114\105\110\103" or #rawHwid < 4 then
_o20("\067\111\117\108\100\032\110\111\116\032\114\101\097\100\032\097\032\104\097\114\100\119\097\114\101\032\073\068\032\102\114\111\109\032\116\104\105\115\032\101\120\101\099\117\116\111\114\046")
return nil
end
local hwid = rawHwid
if #hwid ~= 64 or not hwid:match("\094\091\048\045\057\097\045\102\093\043\036") then
hwid = _o1.sha256_hex(hwid)
end
math.randomseed(os.time() + math.floor(os.clock() * 100000))
local session, errorMessage = _o27(key, hwid)
if not session then
_o20("\075\101\121\032\118\101\114\105\102\105\099\097\116\105\111\110\032\102\097\105\108\101\100\058\032" .. tostring(errorMessage))
return nil
end
return { key = key, hwid = hwid, session = session.session, expires_at = tonumber(session.session_expires_at) or 0 }
end
return {
Init = function(env)
local started_at = os.clock()
local identity = _o28(env)
if not identity then
return
end
if env and env.state then
env.state.authorized = true
env.state.session = identity.session
env.state.session_expires_at = identity.expires_at
end
task.spawn(function()
while true do
local remaining = identity.expires_at - os.time()
local delay = math.floor(remaining * 0.6)
if delay < _o16 then delay = _o16 end
if delay > _o17 then delay = _o17 end
task.wait(delay)
local renewed = _o27(identity.key, identity.hwid)
if renewed then
identity.session = renewed.session
identity.expires_at = tonumber(renewed.session_expires_at) or 0
if env and env.state then
env.state.session = identity.session
env.state.session_expires_at = identity.expires_at
end
end
end
end)
local player = _o2.LocalPlayer
if not player then
env.notify("\074\111\105\110\032\097\032\103\097\109\101\032\098\101\102\111\114\101\032\114\117\110\110\105\110\103\032\084\115\118\072\117\098\046")
return
end
local playerGui = player:WaitForChild("\080\108\097\121\101\114\071\117\105")
local previous = playerGui:FindFirstChild("\084\115\118\072\117\098\086\101\108\111\099\105\116\121")
if previous then
previous:Destroy()
end
local connections = {}
local value = _o5
local humanoid = player.Character and player.Character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
if humanoid then
value = math.clamp(math.floor(humanoid.WalkSpeed + 0.5), _o5, _o6)
end
local gui = Instance.new("\083\099\114\101\101\110\071\117\105")
gui.Name = "\084\115\118\072\117\098\086\101\108\111\099\105\116\121"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 80
gui.Parent = playerGui
local window = Instance.new("\070\114\097\109\101")
window.Name = "\087\105\110\100\111\119"
window.Size = UDim2.fromOffset(320, 164)
window.Position = UDim2.new(0.5, -160, 0.5, -82)
window.BackgroundColor3 = _o7
window.BorderSizePixel = 0
window.Parent = gui
_o13(window, 18)
_o14(window, _o9)
local wash = Instance.new("\085\073\071\114\097\100\105\101\110\116")
wash.Rotation = 90
wash.Color = ColorSequence.new(_o8, _o7)
wash.Parent = window
local close = Instance.new("\084\101\120\116\066\117\116\116\111\110")
close.Name = "\067\108\111\115\101"
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -34, 0, 10)
close.BackgroundTransparency = 1
close.Text = "\195\151"
close.TextSize = 17
close.Font = Enum.Font.GothamMedium
close.TextColor3 = _o12
close.AutoButtonColor = false
close.BorderSizePixel = 0
close.ZIndex = 3
close.Parent = window
_o15(window, {
Text = "\086\032\069\032\076\032\079\032\067\032\073\032\084\032\089",
Font = Enum.Font.GothamBold,
TextSize = 10,
TextColor3 = _o12,
Position = UDim2.fromOffset(18, 15),
Size = UDim2.fromOffset(200, 14),
})
local drag = Instance.new("\070\114\097\109\101")
drag.Name = "\068\114\097\103"
drag.Size = UDim2.new(1, 0, 0, 38)
drag.BackgroundTransparency = 1
drag.Active = true
drag.ZIndex = 2
drag.Parent = window
local valueLabel = _o15(window, {
Text = tostring(value),
Font = Enum.Font.GothamBold,
TextSize = 46,
Position = UDim2.fromOffset(16, 40),
Size = UDim2.fromOffset(180, 54),
})
_o15(window, {
Text = "\087\032\065\032\076\032\075\032\032\032\083\032\080\032\069\032\069\032\068",
Font = Enum.Font.GothamBold,
TextSize = 9,
TextColor3 = _o12,
Position = UDim2.fromOffset(19, 94),
Size = UDim2.fromOffset(200, 12),
})
local hitbox = Instance.new("\084\101\120\116\066\117\116\116\111\110")
hitbox.Name = "\083\108\105\100\101\114"
hitbox.Size = UDim2.fromOffset(284, 28)
hitbox.Position = UDim2.fromOffset(18, 118)
hitbox.BackgroundTransparency = 1
hitbox.Text = ""
hitbox.AutoButtonColor = false
hitbox.BorderSizePixel = 0
hitbox.Parent = window
local rail = Instance.new("\070\114\097\109\101")
rail.Size = UDim2.new(1, 0, 0, 3)
rail.Position = UDim2.new(0, 0, 0.5, -1)
rail.BackgroundColor3 = _o10
rail.BorderSizePixel = 0
rail.Parent = hitbox
_o13(rail, 99)
local fill = Instance.new("\070\114\097\109\101")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = _o11
fill.BorderSizePixel = 0
fill.Parent = rail
_o13(fill, 99)
local knob = Instance.new("\070\114\097\109\101")
knob.Size = UDim2.fromOffset(12, 12)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = _o11
knob.BorderSizePixel = 0
knob.ZIndex = 2
knob.Parent = rail
_o13(knob, 99)
local function apply()
local character = player.Character
local current = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
if current then
current.WalkSpeed = value
end
end
local function render()
local ratio = (value - _o5) / (_o6 - _o5)
fill.Size = UDim2.new(ratio, 0, 1, 0)
knob.Position = UDim2.new(ratio, 0, 0.5, 0)
valueLabel.Text = tostring(value)
end
local function set_from_x(x)
local ratio = math.clamp((x - hitbox.AbsolutePosition.X) / math.max(hitbox.AbsoluteSize.X, 1), 0, 1)
local next_value = math.floor(_o5 + (_o6 - _o5) * ratio + 0.5)
if next_value == value then
return
end
value = next_value
render()
apply()
end
render()
local sliding = false
hitbox.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = true
set_from_x(input.Position.X)
end
end)
local dragging = false
local dragOrigin = Vector2.zero
local pointerOrigin = Vector2.zero
drag.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragOrigin = window.AbsolutePosition
pointerOrigin = input.Position
end
end)
connections[#connections + 1] = _o4.InputChanged:Connect(function(input)
local kind = input.UserInputType
if kind ~= Enum.UserInputType.MouseMovement and kind ~= Enum.UserInputType.Touch then
return
end
if sliding then
set_from_x(input.Position.X)
elseif dragging then
local delta = input.Position - pointerOrigin
local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
local size = window.AbsoluteSize
local x = math.clamp(dragOrigin.X + delta.X, 0, math.max(0, viewport.X - size.X))
local y = math.clamp(dragOrigin.Y + delta.Y, 0, math.max(0, viewport.Y - size.Y))
window.Position = UDim2.fromOffset(x, y)
end
end)
connections[#connections + 1] = _o4.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = false
dragging = false
end
end)
connections[#connections + 1] = player.CharacterAdded:Connect(function(character)
local spawned = character:WaitForChild("\072\117\109\097\110\111\105\100", 10)
if spawned and spawned.Parent then
spawned.WalkSpeed = value
end
end)
local function destroy()
for _, connection in ipairs(connections) do
connection:Disconnect()
end
table.clear(connections)
gui:Destroy()
end
close.MouseEnter:Connect(function()
close.TextColor3 = _o11
end)
close.MouseLeave:Connect(function()
close.TextColor3 = _o12
end)
close.MouseButton1Click:Connect(destroy)
if env and type(env.notify) == "\102\117\110\099\116\105\111\110" then
env.notify(string.format("\084\115\118\072\117\098\032\108\111\097\100\101\100\032\105\110\032\037\046\050\102\115", os.clock() - started_at))
end
return { destroy = destroy }
end,
}
