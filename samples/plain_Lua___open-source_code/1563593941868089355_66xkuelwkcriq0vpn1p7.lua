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
if scirpt_key == nil or scirpt_key == "" then error("missing scirpt_key") end
local url = "https://luacode.net/raw/66xkuelwkcriq0vpn1p7?key=" .. tostring(scirpt_key)
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
local function hub_b64(data)
  local map = {}
  local i = 1
  while i <= #HUB_B64 do
    map[string.sub(HUB_B64, i, i)] = i - 1
    i = i + 1
  end
  local function push(parts, buf, n, byte)
    n = n + 1
    buf[n] = string.char(byte)
    if n == 4096 then
      parts[#parts + 1] = table.concat(buf)
      return {}, 0
    end
    return buf, n
  end
  local parts = {}
  local buf = {}
  local n = 0
  local acc = 0
  local bits = 0
  i = 1
  while i <= #data do
    local c = string.sub(data, i, i)
    i = i + 1
    if c == "=" then break end
    local v = map[c]
    if v == nil then error("script: bad payload") end
    acc = acc * 64 + v
    bits = bits + 6
    if bits >= 8 then
      bits = bits - 8
      local byte = math.floor(acc / (2 ^ bits))
      acc = acc % (2 ^ bits)
      buf, n = push(parts, buf, n, byte)
    end
  end
  if n > 0 then parts[#parts + 1] = table.concat(buf) end
  return table.concat(parts)
end
local function hub_open(blob, key)
  if type(blob) ~= "string" or string.sub(blob, 1, 4) ~= "HX1\n" then
    return nil
  end
  local cipher = hub_b64(string.sub(blob, 5))
  local state = hub_mix(key)
  local parts = {}
  local buf = {}
  local n = 0
  local i = 1
  while i <= #cipher do
    state = (state * 214013 + 2531011) % 2147483648
    local kb = math.floor(state / 65536) % 256
    n = n + 1
    buf[n] = string.char(hub_xor8(string.byte(cipher, i), kb))
    if n == 4096 then
      parts[#parts + 1] = table.concat(buf)
      buf = {}
      n = 0
    end
    i = i + 1
  end
  if n > 0 then parts[#parts + 1] = table.concat(buf) end
  return table.concat(parts)
end
local plain = hub_open(src, tostring(scirpt_key))
if plain == nil then return hub_compile(src, "script")() end
return hub_compile(plain, "script")()
