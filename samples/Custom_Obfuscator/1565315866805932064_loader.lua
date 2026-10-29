local _o0 = "\104\116\116\112\115\058\047\047\116\115\118\046\115\117\100\111\114\109\114\102\046\117\107"
local _o1 = "\050\048\050\054\049\048\050\056\046\049\055\053\050\050\055"
local STAGE2_SHA256 = "b27c4bccde29f619d7a02212da164831eba654a42ba1eef91e79888cc6b6a075"
local _o2 = false
local _o3 = "\047\097\112\105\047\118\049\047\115\116\097\103\101\050"
local _o4 = (function()
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
local game = game
local task = task
local pcall = pcall
local type = type
local tostring = tostring
local tonumber = tonumber
local ipairs = ipairs
local pairs = pairs
local math = math
local os = os
local string = string
local table = table
local debug = debug
local _o5 = debug and debug.info
local _o6 = debug and debug.getupvalue
local _o7 = warn
local _G = _G
local _o8 = loadstring
local _o9 = getgenv
local _o10 = getfenv
local _o11 = getrenv
local _o12 = getgc
local _o13 = isnewcclosure
local _o14 = islclosure
local _o15 = identifyexecutor
local _o16 = gethwid
local _o17 = get_hwid
local _o18 = syn
local _o19 = shared
local _o20 = scriptkey
local _o21 = string.gsub
local _o22 = string.match
local _o23 = string.sub
local _o24 = string.lower
local rawget = rawget
local _o25 = debug and debug.getregistry
local _o26 = game:GetService("\072\116\116\112\083\101\114\118\105\099\101")
local function _o27()
if type(_o9) == "\102\117\110\099\116\105\111\110" then
local ok, environment = pcall(_o9)
if ok and type(environment) == "\116\097\098\108\101" then
return environment
end
end
return nil
end
local _o28 = {}
local function _o29(name, fallback)
local cached = _o28[name]
if cached ~= nil then
if cached == false then
return nil
end
return cached
end
local value = fallback
if type(value) ~= "\102\117\110\099\116\105\111\110" then
local environment = _o27()
if environment and type(environment[name]) == "\102\117\110\099\116\105\111\110" then
value = environment[name]
elseif type(_G) == "\116\097\098\108\101" and type(_G[name]) == "\102\117\110\099\116\105\111\110" then
value = _G[name]
else
value = nil
end
end
_o28[name] = value or false
return value
end
local function _o30(message)
message = tostring(message)
if _o23(message, 1, 9) ~= "\091\084\115\118\072\117\098\093\032" then
message = "\091\084\115\118\072\117\098\093\032" .. message
end
pcall(function()
_o7(message)
end)
pcall(function()
game:GetService("\083\116\097\114\116\101\114\071\117\105"):SetCore("\083\101\110\100\078\111\116\105\102\105\099\097\116\105\111\110", {
Title = "\084\115\118\072\117\098",
Text = message,
Duration = 8,
})
end)
end
local function _o31(callback, what)
if type(_o5) ~= "\102\117\110\099\116\105\111\110" then
return nil
end
local ok, value = pcall(_o5, callback, what)
if ok then
return value
end
return nil
end
local function _o32(callback)
local source = _o31(callback, "\115")
if type(source) == "\115\116\114\105\110\103" then
return source
end
return nil
end
local function _o33(callback)
local name = _o31(callback, "\110")
if type(name) == "\115\116\114\105\110\103" and #name > 0 then
return _o24(name)
end
return nil
end
local function _o34(callback, limit)
local values = {}
if type(_o6) ~= "\102\117\110\099\116\105\111\110" then
return values
end
limit = limit or 24
for index = 1, limit do
local ok, name, value = pcall(_o6, callback, index)
if not ok or name == nil then
break
end
values[#values + 1] = { name = name, value = value }
end
return values
end
local function _o35(callback)
local ok, chunk = pcall(callback, "\114\101\116\117\114\110\032\049\049\044\032\034\084\115\118\072\117\098\034", "\061\084\115\118\072\117\098\046\067\097\110\097\114\121")
if not ok or type(chunk) ~= "\102\117\110\099\116\105\111\110" then
return false
end
local ran, first, second = pcall(chunk)
return ran and first == 11 and second == "\084\115\118\072\117\098"
end
local function _o36(callback)
local delivered = false
local reader = function()
if delivered then
return nil
end
delivered = true
return "\114\101\116\117\114\110\032\049\049\044\032\034\084\115\118\072\117\098\034"
end
local ok, chunk = pcall(callback, reader, "\061\084\115\118\072\117\098\046\067\097\110\097\114\121")
if not ok or type(chunk) ~= "\102\117\110\099\116\105\111\110" then
return false
end
local ran, first, second = pcall(chunk)
return ran and first == 11 and second == "\084\115\118\072\117\098"
end
local _o37 = {
load = true,
loadstring = true,
dostring = true,
}
local _o38 = {
base = true,
callback = true,
dostring = true,
fn = true,
func = true,
inner = true,
load = true,
loader = true,
loadstring = true,
old = true,
orig = true,
original = true,
raw = true,
real = true,
target = true,
wrapped = true,
}
local function _o39(callback)
local name = _o33(callback)
return name ~= nil and _o37[name] == true
end
local function _o40(callback)
local source = _o32(callback)
if source ~= nil then
return source == "\091\067\093"
end
if type(_o6) == "\102\117\110\099\116\105\111\110" then
local ok, name = pcall(_o6, callback, 1)
if ok then
return name == nil
end
end
return false
end
local function _o41(callback)
local detect = _o29("\105\115\108\099\108\111\115\117\114\101", _o14)
if type(detect) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(detect, callback)
if ok then
return value == true
end
end
return _o32(callback) ~= "\091\067\093"
end
local function _o42(callback)
local detect = _o29("\105\115\110\101\119\099\099\108\111\115\117\114\101", _o13)
if type(detect) ~= "\102\117\110\099\116\105\111\110" then
return false
end
local ok, value = pcall(detect, callback)
return ok and value == true
end
local function _o43(callback, trusted)
if type(callback) ~= "\102\117\110\099\116\105\111\110" then
return false
end
if _o42(callback) then
return false
end
if not _o40(callback) then
return false
end
if trusted ~= true and not _o39(callback) then
return false
end
return _o35(callback)
end
local function _o44(callback, trusted)
if type(callback) ~= "\102\117\110\099\116\105\111\110" then
return false
end
if not _o40(callback) then
return false
end
if trusted ~= true and not _o39(callback) then
return false
end
if callback ~= _o8 and not _o39(callback) then
return false
end
return _o36(callback)
end
local function _o45()
local result = {}
local seen = {}
local function add(value)
if type(value) == "\116\097\098\108\101" and not seen[value] then
seen[value] = true
result[#result + 1] = value
end
end
add(_o27())
add(_G)
add(_o19)
local getrenv = _o29("\103\101\116\114\101\110\118", _o11)
if type(getrenv) == "\102\117\110\099\116\105\111\110" then
local ok, environment = pcall(getrenv)
if ok then
add(environment)
end
end
if type(_o10) == "\102\117\110\099\116\105\111\110" then
for level = 0, 4 do
local ok, scope = pcall(_o10, level)
if ok then
add(scope)
end
end
end
if type(_o25) == "\102\117\110\099\116\105\111\110" then
local ok, registry = pcall(_o25)
if ok then
add(registry)
if type(registry) == "\116\097\098\108\101" then
for _, value in pairs(registry) do
if type(value) == "\116\097\098\108\101" then
add(value)
end
end
end
end
end
return result
end
local function _o46()
local candidates = {}
local by_callback = {}
local function remember(callback, trusted)
if type(callback) ~= "\102\117\110\099\116\105\111\110" then
return
end
local entry = by_callback[callback]
if entry then
if trusted == true then
entry.trusted = true
end
return
end
entry = { callback = callback, trusted = trusted == true }
by_callback[callback] = entry
candidates[#candidates + 1] = entry
end
local function harvest(container)
for _, field in ipairs({ "\108\111\097\100\115\116\114\105\110\103", "\108\111\097\100", "\100\111\115\116\114\105\110\103" }) do
local ok, value = pcall(rawget, container, field)
if ok then
remember(value, true)
end
end
end
for _, environment in ipairs(_o45()) do
harvest(environment)
end
remember(_o8, true)
local getgc = _o29("\103\101\116\103\099", _o12)
if type(getgc) == "\102\117\110\099\116\105\111\110" then
local ok, objects = pcall(getgc, true)
if ok and type(objects) == "\116\097\098\108\101" then
local count = #objects
if count > 40000 then
count = 40000
end
local inspected = 0
for index = 1, count do
local object = objects[index]
local kind = type(object)
if kind == "\116\097\098\108\101" then
if index <= 12000 then
harvest(object)
end
elseif kind == "\102\117\110\099\116\105\111\110" then
if _o41(object) then
if inspected < 12000 then
inspected = inspected + 1
for _, item in ipairs(_o34(object, 6)) do
if type(item.value) == "\102\117\110\099\116\105\111\110" then
local guessed = type(item.name) == "\115\116\114\105\110\103"
and _o38[_o24(item.name)] == true
remember(item.value, guessed)
end
end
end
elseif _o39(object) then
remember(object, false)
end
end
end
end
end
local cursor = 1
while cursor <= #candidates and cursor <= 64 do
local entry = candidates[cursor]
cursor = cursor + 1
if _o41(entry.callback) then
for _, item in ipairs(_o34(entry.callback, 24)) do
if type(item.value) == "\102\117\110\099\116\105\111\110" then
local guessed = type(item.name) == "\115\116\114\105\110\103"
and _o38[_o24(item.name)] == true
remember(item.value, entry.trusted == true or guessed)
end
end
end
end
local function choose(predicate)
for _, entry in ipairs(candidates) do
if entry.callback ~= _o8 and predicate(entry) then
return entry
end
end
for _, entry in ipairs(candidates) do
if entry.callback == _o8 and predicate(entry) then
return entry
end
end
return nil
end
local reader_entry = choose(function(entry)
return _o44(entry.callback, entry.trusted)
end)
if reader_entry then
return reader_entry.callback, true
end
local string_entry = choose(function(entry)
return _o43(entry.callback, entry.trusted)
end)
if string_entry then
return string_entry.callback, false
end
return nil, false
end
local _o47, _o48 = _o46()
if type(_o47) ~= "\102\117\110\099\116\105\111\110" then
_o30("\084\104\105\115\032\101\120\101\099\117\116\111\114\032\101\110\118\105\114\111\110\109\101\110\116\032\105\115\032\110\111\116\032\115\117\112\112\111\114\116\101\100\046\032\085\115\101\032\097\032\115\117\112\112\111\114\116\101\100\032\101\120\101\099\117\116\111\114\046")
return
end
local function _o49(source)
local delivered = false
return function()
if delivered then
return nil
end
delivered = true
return source
end
end
local function _o50()
if _o48 then
return _o36(_o47)
end
return _o35(_o47)
end
local function _o51(source, chunkname)
if type(source) ~= "\115\116\114\105\110\103" then
return nil, "\105\110\118\097\108\105\100\032\099\104\117\110\107"
end
if not _o50() then
return nil, "\112\114\111\116\101\099\116\101\100\032\108\111\097\100\101\114\032\105\115\032\117\110\097\118\097\105\108\097\098\108\101"
end
if _o48 then
return _o47(_o49(source), chunkname)
end
return _o47(source, chunkname)
end
local function _o52()
local candidates = {}
local environment = _o27()
if environment then
candidates[#candidates + 1] = environment.scriptkey
candidates[#candidates + 1] = environment.SCRIPTKEY
end
if type(_G) == "\116\097\098\108\101" then
candidates[#candidates + 1] = _G.scriptkey
candidates[#candidates + 1] = _G.SCRIPTKEY
end
candidates[#candidates + 1] = _o20
for _, value in ipairs(candidates) do
if type(value) == "\115\116\114\105\110\103" then
local cleaned = _o21(value, "\037\115\043", "")
if #cleaned > 0 then
return cleaned
end
end
end
return ""
end
local function _o53()
if type(_o16) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(_o16)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 0 then
return value, "\103\101\116\104\119\105\100"
end
end
if type(_o17) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(_o17)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 0 then
return value, "\103\101\116\095\104\119\105\100"
end
end
if type(_o18) == "\116\097\098\108\101" and type(_o18.get_hwid) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(_o18.get_hwid)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 0 then
return value, "\115\121\110\046\103\101\116\095\104\119\105\100"
end
end
local environment = _o27()
if environment then
if type(environment.gethwid) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(environment.gethwid)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 0 then
return value, "\103\101\116\103\101\110\118\040\041\046\103\101\116\104\119\105\100"
end
end
if type(environment.get_hwid) == "\102\117\110\099\116\105\111\110" then
local ok, value = pcall(environment.get_hwid)
if ok and type(value) == "\115\116\114\105\110\103" and #value > 0 then
return value, "\103\101\116\103\101\110\118\040\041\046\103\101\116\095\104\119\105\100"
end
end
if type(environment.hwid) == "\115\116\114\105\110\103" and #environment.hwid > 0 then
return environment.hwid, "\103\101\116\103\101\110\118\040\041\046\104\119\105\100"
end
end
local hwid_global = hwid
if type(hwid_global) == "\115\116\114\105\110\103" and #hwid_global > 0 then
return hwid_global, "\104\119\105\100"
end
local client_ok, client_id = pcall(function()
return game:GetService("\082\098\120\065\110\097\108\121\116\105\099\115\083\101\114\118\105\099\101"):GetClientId()
end)
if client_ok and type(client_id) == "\115\116\114\105\110\103" and #client_id >= 8 then
return "\099\108\105\101\110\116\058" .. client_id, "\082\098\120\065\110\097\108\121\116\105\099\115\083\101\114\118\105\099\101"
end
local player_ok, local_player = pcall(function()
return game:GetService("\080\108\097\121\101\114\115").LocalPlayer
end)
if player_ok and local_player ~= nil then
local user_ok, user_id = pcall(function()
return local_player.UserId
end)
if user_ok and type(user_id) == "\110\117\109\098\101\114" and user_id > 0 then
return "\097\099\099\111\117\110\116\058" .. tostring(user_id), "\076\111\099\097\108\080\108\097\121\101\114\046\085\115\101\114\073\100"
end
end
return nil, "\117\110\107\110\111\119\110"
end
local function _o54()
if type(_o15) == "\102\117\110\099\116\105\111\110" then
local ok, name = pcall(_o15)
if ok and name ~= nil then
return tostring(name)
end
end
if type(_o18) == "\116\097\098\108\101" and type(_o18.identifyexecutor) == "\102\117\110\099\116\105\111\110" then
local ok, name = pcall(_o18.identifyexecutor)
if ok and name ~= nil then
return tostring(name)
end
end
return "\117\110\107\110\111\119\110"
end
local _o55 = _o52()
if _o2 then
_o55 = ""
end
local _o56, _o57 = _o53()
local _o58 = ""
if type(_o56) == "\115\116\114\105\110\103" then
_o56 = _o21(_o56, "\094\037\115\043", "")
_o56 = _o21(_o56, "\037\115\043\036", "")
if #_o56 >= 4 then
local candidate = _o4.sha256_hex(_o56)
if #candidate == 64 and _o22(candidate, "\094\091\048\045\057\097\045\102\093\043\036") then
_o58 = candidate
end
end
end
local _o59 = _o54()
local function _o60(name, value)
local environment = _o27()
if environment then
environment[name] = value
end
if type(_G) == "\116\097\098\108\101" then
_G[name] = value
end
end
local function _o61()
if type(request) == "\102\117\110\099\116\105\111\110" then
return request
end
if type(http_request) == "\102\117\110\099\116\105\111\110" then
return http_request
end
if type(http) == "\102\117\110\099\116\105\111\110" then
return http
end
if type(http) == "\116\097\098\108\101" and type(http.request) == "\102\117\110\099\116\105\111\110" then
return http.request
end
if type(_o18) == "\116\097\098\108\101" and type(_o18.request) == "\102\117\110\099\116\105\111\110" then
return _o18.request
end
if type(fluxus) == "\116\097\098\108\101" and type(fluxus.request) == "\102\117\110\099\116\105\111\110" then
return fluxus.request
end
if type(krnl) == "\116\097\098\108\101" and type(krnl.request) == "\102\117\110\099\116\105\111\110" then
return krnl.request
end
local environment = _o27()
if environment then
if type(environment.request) == "\102\117\110\099\116\105\111\110" then
return environment.request
end
if type(environment.http_request) == "\102\117\110\099\116\105\111\110" then
return environment.http_request
end
if type(environment.http) == "\116\097\098\108\101" and type(environment.http.request) == "\102\117\110\099\116\105\111\110" then
return environment.http.request
end
end
return nil
end
local _o62 = _o61()
local Http = {}
Http.can_post = _o62 ~= nil or type(_o26.RequestAsync) == "\102\117\110\099\116\105\111\110"
function Http.request(options)
local url = options.Url or options.url
local method = options.Method or options.method or "\071\069\084"
local headers = options.Headers or options.headers or {}
local body = options.Body or options.body
local keep_error_body = options.ReturnBodyOnError == true
if _o62 then
local ok, response = pcall(_o62, {
Url = url,
Method = method,
Headers = headers,
Body = body,
})
if not ok or type(response) ~= "\116\097\098\108\101" then
return nil, "\110\101\116\119\111\114\107\032\114\101\113\117\101\115\116\032\102\097\105\108\101\100"
end
local status = tonumber(
response.StatusCode or response.Status or response.status or response.status_code
) or 200
local response_body = response.Body or response.body or response.Content or response.content
local response_headers = response.Headers or response.headers
if status < 200 or status >= 300 then
if keep_error_body and type(response_body) == "\115\116\114\105\110\103" and #response_body > 0 then
return response_body, "\072\084\084\080\032" .. tostring(status), response_headers, status
end
return nil, "\072\084\084\080\032" .. tostring(status), response_headers, status
end
if type(response_body) ~= "\115\116\114\105\110\103" or #response_body == 0 then
return nil, "\101\109\112\116\121\032\072\084\084\080\032\114\101\115\112\111\110\115\101", response_headers, status
end
return response_body, nil, response_headers, status
end
if type(_o26.RequestAsync) == "\102\117\110\099\116\105\111\110" then
local ok, response = pcall(function()
return _o26:RequestAsync({
Url = url,
Method = method,
Headers = headers,
Body = body,
})
end)
if ok and type(response) == "\116\097\098\108\101" then
local status = tonumber(response.StatusCode) or 200
local response_body = response.Body
local response_headers = response.Headers
if status >= 200 and status < 300 and type(response_body) == "\115\116\114\105\110\103" and #response_body > 0 then
return response_body, nil, response_headers, status
end
if keep_error_body and type(response_body) == "\115\116\114\105\110\103" and #response_body > 0 then
return response_body, "\072\084\084\080\032" .. tostring(status), response_headers, status
end
return nil, "\072\084\084\080\032" .. tostring(status), response_headers, status
end
end
if method ~= "\071\069\084" then
return nil, "\101\120\101\099\117\116\111\114\032\100\111\101\115\032\110\111\116\032\115\117\112\112\111\114\116\032\072\084\084\080\032\080\079\083\084"
end
local ok, response_body = pcall(function()
return game:HttpGet(url, true)
end)
if not ok or type(response_body) ~= "\115\116\114\105\110\103" or #response_body == 0 then
return nil, "\110\101\116\119\111\114\107\032\114\101\113\117\101\115\116\032\102\097\105\108\101\100"
end
return response_body, nil, nil, 200
end
function Http.get(url, headers)
return Http.request({ Url = url, Method = "\071\069\084", Headers = headers })
end
function Http.post_json(url, value, options)
options = options or {}
local headers = { ["\067\111\110\116\101\110\116\045\084\121\112\101"] = "\097\112\112\108\105\099\097\116\105\111\110\047\106\115\111\110" }
for name, header in pairs(options.Headers or {}) do
headers[name] = header
end
return Http.request({
Url = url,
Method = "\080\079\083\084",
Headers = headers,
Body = _o26:JSONEncode(value),
ReturnBodyOnError = options.ReturnBodyOnError,
})
end
local _o63, _o64 = Http.get(_o0 .. _o3 .. "\063\098\117\105\108\100\061" .. _o1)
if not _o63 then
_o30("\076\111\097\100\101\114\032\100\111\119\110\108\111\097\100\032\102\097\105\108\101\100\058\032" .. tostring(_o64))
return
end
if _o23(_o63, 1, 3) == "\239\187\191" then
_o63 = _o23(_o63, 4)
end
if not _o4.equals(_o4.sha256_hex(_o63), STAGE2_SHA256) then
_o30("\076\111\097\100\101\114\032\105\110\116\101\103\114\105\116\121\032\099\104\101\099\107\032\102\097\105\108\101\100\046\032\067\111\112\121\032\097\032\102\114\101\115\104\032\108\111\097\100\101\114\032\108\105\110\101\032\102\114\111\109\032\116\104\101\032\112\097\110\101\108\046")
return
end
local _o65, _o66 = pcall(_o51, _o63, "\061\084\115\118\072\117\098\046\083\116\097\103\101\050")
if not _o65 or type(_o66) ~= "\102\117\110\099\116\105\111\110" then
_o30("\076\111\097\100\101\114\032\099\111\109\112\105\108\101\032\101\114\114\111\114\058\032" .. tostring(_o66))
return
end
local _o67, _o68 = pcall(_o66)
if not _o67 or type(_o68) ~= "\102\117\110\099\116\105\111\110" then
_o30("\076\111\097\100\101\114\032\098\111\111\116\115\116\114\097\112\032\102\097\105\108\101\100\058\032" .. tostring(_o68))
return
end
local _o69, _o70 = pcall(_o68, {
api = _o0,
build = _o1,
key = _o55,
hwid = _o58,
hwid_source = _o57,
executor = _o59,
execute = _o51,
game = game,
task = task,
publish = _o60,
crypto = _o4,
http = Http,
})
if not _o69 then
_o30(_o70)
end
