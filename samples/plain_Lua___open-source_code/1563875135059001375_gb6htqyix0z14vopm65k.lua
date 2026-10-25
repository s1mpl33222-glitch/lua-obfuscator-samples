local HttpGet = (syn and syn.request and function(u)
  local r = syn.request({Url=u, Method='GET', Headers={['X-Client']='executor'}})
  return r and r.Body
end) or (http and http.request and function(u)
  local r = http.request({Url=u, Method='GET', Headers={['X-Client']='executor'}})
  return r and r.Body
end) or (request and function(u)
  local r = request({Url=u, Method='GET', Headers={['X-Client']='executor'}})
  return r and (r.Body or r.body)
end) or (game and function(u)
  return game:HttpGet(u)
end)
if not HttpGet then error("no http") end
local url = "https://luacode.net/raw/gb6htqyix0z14vopm65k"
local src = HttpGet(url)
local function hub_compile(src, label)
  label = label or "hub"
  if type(src) ~= "string" or #src < 12 then
    error(label .. ": bad or empty response")
  end
  if src:sub(1, 1) == "<" then
    error(label .. ": got HTML, not Lua")
  end
  local fn, err
  if loadstring then
    fn, err = loadstring(src)
  else
    fn, err = load(src, label, "t")
  end
  if not fn then
    error(label .. ": " .. tostring(err))
  end
  return fn
end
local function hub_mix(key)
  local state = 18652613
  local i = 1
  while i <= #key do
    state = (state * 131 + string.byte(key, i)) % 2147483648
    i = i + 1
  end
  if state == 0 then state = 1 end
  return state
end
local function hub_xor8(a, b)
  local r = 0
  local m = 1
  local i = 1
  while i <= 8 do
    if a % 2 ~= b % 2 then r = r + m end
    a = math.floor(a / 2)
    b = math.floor(b / 2)
    m = m * 2
    i = i + 1
  end
  return r
end
local HUB_B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local HUB_MAP = {}
do
  local i = 1
  while i <= #HUB_B64 do
    HUB_MAP[string.byte(HUB_B64, i)] = i - 1
    i = i + 1
  end
end
local function hub_b64(data)
  local n = #data
  local pad = 0
  if n >= 1 and string.byte(data, n) == 61 then pad = pad + 1 end
  if n >= 2 and string.byte(data, n - 1) == 61 then pad = pad + 1 end
  local outn = math.floor(n / 4) * 3 - pad
  if outn < 0 then error("script: bad payload") end
  if type(buffer) == "table" and type(bit32) == "table" and type(buffer.create) == "function" and type(buffer.tostring) == "function" then
    local dst = buffer.create(outn)
    local band = bit32.band
    local rshift = bit32.rshift
    local lshift = bit32.lshift
    local o = 0
    local i = 1
    while i <= n do
      local c1, c2, c3, c4 = string.byte(data, i, i + 3)
      i = i + 4
      local v1 = HUB_MAP[c1]
      local v2 = HUB_MAP[c2]
      if v1 == nil or v2 == nil then error("script: bad payload") end
      local v3 = 0
      local v4 = 0
      if c3 ~= nil and c3 ~= 61 then
        v3 = HUB_MAP[c3]
        if v3 == nil then error("script: bad payload") end
      end
      if c4 ~= nil and c4 ~= 61 then
        v4 = HUB_MAP[c4]
        if v4 == nil then error("script: bad payload") end
      end
      local acc = lshift(v1, 18) + lshift(v2, 12) + lshift(v3, 6) + v4
      buffer.writeu8(dst, o, band(rshift(acc, 16), 255))
      o = o + 1
      if c3 ~= nil and c3 ~= 61 then
        buffer.writeu8(dst, o, band(rshift(acc, 8), 255))
        o = o + 1
      end
      if c4 ~= nil and c4 ~= 61 then
        buffer.writeu8(dst, o, band(acc, 255))
        o = o + 1
      end
    end
    if o ~= outn then error("script: bad payload") end
    return buffer.tostring(dst)
  end
  local parts = {}
  local buf = {}
  local bn = 0
  local acc = 0
  local bits = 0
  local i = 1
  local function push(byte)
    bn = bn + 1
    buf[bn] = string.char(byte)
    if bn == 4096 then
      parts[#parts + 1] = table.concat(buf)
      buf = {}
      bn = 0
    end
  end
  while i <= n do
    local c = string.sub(data, i, i)
    i = i + 1
    if c == "=" then break end
    local v = HUB_MAP[string.byte(c)]
    if v == nil then error("script: bad payload") end
    acc = acc * 64 + v
    bits = bits + 6
    if bits >= 8 then
      bits = bits - 8
      push(math.floor(acc / (2 ^ bits)) % 256)
      acc = acc % (2 ^ bits)
    end
  end
  if bn > 0 then parts[#parts + 1] = table.concat(buf) end
  return table.concat(parts)
end
local function hub_open(blob, key)
  if type(blob) ~= "string" or string.sub(blob, 1, 4) ~= "HX1\n" then
    return nil
  end
  local cipher = hub_b64(string.sub(blob, 5))
  local state = hub_mix(key)
  local n = #cipher
  if type(buffer) == "table" and type(bit32) == "table" and type(buffer.create) == "function" and type(buffer.tostring) == "function" then
    local dst = buffer.create(n)
    local bxor = bit32.bxor
    local rshift = bit32.rshift
    local band = bit32.band
    local i = 1
    while i + 3 <= n do
      local b0, b1, b2, b3 = string.byte(cipher, i, i + 3)
      state = (state * 214013 + 2531011) % 2147483648
      buffer.writeu8(dst, i - 1, bxor(b0, band(rshift(state, 16), 255)))
      state = (state * 214013 + 2531011) % 2147483648
      buffer.writeu8(dst, i, bxor(b1, band(rshift(state, 16), 255)))
      state = (state * 214013 + 2531011) % 2147483648
      buffer.writeu8(dst, i + 1, bxor(b2, band(rshift(state, 16), 255)))
      state = (state * 214013 + 2531011) % 2147483648
      buffer.writeu8(dst, i + 2, bxor(b3, band(rshift(state, 16), 255)))
      i = i + 4
    end
    while i <= n do
      state = (state * 214013 + 2531011) % 2147483648
      buffer.writeu8(dst, i - 1, bxor(string.byte(cipher, i), band(rshift(state, 16), 255)))
      i = i + 1
    end
    return buffer.tostring(dst)
  end
  local parts = {}
  local buf = {}
  local bn = 0
  local i = 1
  while i <= n do
    state = (state * 214013 + 2531011) % 2147483648
    local kb = math.floor(state / 65536) % 256
    bn = bn + 1
    buf[bn] = string.char(hub_xor8(string.byte(cipher, i), kb))
    if bn == 4096 then
      parts[#parts + 1] = table.concat(buf)
      buf = {}
      bn = 0
    end
    i = i + 1
  end
  if bn > 0 then parts[#parts + 1] = table.concat(buf) end
  return table.concat(parts)
end
local plain = hub_open(src, "hub:" .. "gb6htqyix0z14vopm65k")
local hub_loader_token = "a38d0082321d1cf4b367202e67c93f87"
if type(getgenv) == "function" then
  local hub_ok, hub_env = pcall(getgenv)
  if hub_ok and type(hub_env) == "table" then
    hub_env.hub_loader_token = hub_loader_token
    hub_env.hub_loader_once = hub_loader_token
  end
end
if type(_G) == "table" then
  pcall(function()
    _G.hub_loader_token = hub_loader_token
    _G.hub_loader_once = hub_loader_token
  end)
end
if type(shared) == "table" then
  pcall(function()
    shared.hub_loader_token = hub_loader_token
    shared.hub_loader_once = hub_loader_token
  end)
end
if plain == nil then return hub_compile(src, "script")() end
return hub_compile(plain, "script")()
