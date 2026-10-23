-- trying to bypass or dumping any 0x6 protected script breaks ToS, DMCA enforced, every load is logged
local SID = "sc_c2549acd2029"
local API = "https://0x6auth.lol"
local EXPECT_HASH = "bfeea38b"
local function fnv1a(s)
  local h = 0x811C9DC5
  for i = 1, #s do
    h = bit32.bxor(h, s:byte(i))
    local lo = h % 65536
    local hi = math.floor(h / 65536)
    h = (lo * 0x01000193 + ((hi * 0x01000193) % 65536) * 65536) % 4294967296
  end
  return string.format("%08x", h)
end
local HW = nil
pcall(function()
  if typeof(gethwid) == "function" then HW = gethwid() end
  if (typeof(HW) ~= "string" or #HW < 4) and typeof(get_hwid) == "function" then HW = get_hwid() end
end)
if typeof(HW) == "string" then HW = HW:gsub("[^%w%-_]", "") end
if typeof(HW) ~= "string" or #HW < 4 then
  HW = "X" .. tostring(game.PlaceId)
end
local KEY = ""
if typeof(KEY) ~= "string" then KEY = "" end
if #KEY < 8 then
  local okg, g = pcall(function() return _G.__0x6k end)
  if okg and typeof(g) == "string" then KEY = g end
end
KEY = KEY:gsub("[^%w%-_]", "")
local keypart = ""
if typeof(KEY) == "string" and #KEY >= 8 then
  keypart = ',"key":"' .. KEY .. '"'
end
local function xorCrypt(data, key)
  local klen = #key
  local out = {}
  for i = 1, #data do
    local kb = key:byte(((i - 1) % klen) + 1)
    out[i] = string.char(bit32.bxor(data:byte(i), kb))
  end
  return table.concat(out)
end
local CACHE = "0x6_" .. SID .. "_stage.dat"
local stage = nil
pcall(function()
  if typeof(readfile) ~= "function" then return end
  local c = readfile(CACHE)
  if typeof(c) ~= "string" then return end
  local exp, mac, enc = c:match("^(%d+)|(%x+)|([%s%S]+)$")
  if exp and tonumber(exp) > os.time() then
    local code = xorCrypt(enc, HW .. SID)
    if mac == fnv1a(code .. HW .. SID) and fnv1a(code) == EXPECT_HASH then
      stage = code
    end
  end
end)
if typeof(stage) ~= "string" then
  local HDRS = { ["Content-Type"] = "application/json", ["X-0x6-Exec"] = "1", ["X-0x6-Ver"] = "s0" }
  local payload = '{"hwid":"' .. HW .. '","scriptId":"' .. SID .. '"' .. keypart .. '}'
  local res
  if request then
    local okr, r = pcall(request, {
      Url = API .. "/api/challenge", Method = "POST", Headers = HDRS, Body = payload,
    })
    if okr and typeof(r) == "table" then res = r.Body or r.body or r.Content or r.content end
  else
    local okc, r = pcall(game.HttpPost, game, API .. "/api/challenge", payload)
    if okc then
      if typeof(r) == "table" then r = r.Body or r.body or r.Content or r.content end
      res = r
    end
  end
  local chb
  if typeof(res) == "string" then chb = res:match('"challengeId":"(%x+)"') end
  if typeof(chb) ~= "string" then error("failed to load", 0) end
  local okf
  okf, stage = pcall(game.HttpGet, game,
    API .. "/s/" .. SID .. ".stage?cid=" .. chb .. "&hwid=" .. HW)
  if not okf or typeof(stage) ~= "string" then error("failed to load", 0) end
  pcall(function()
    if typeof(writefile) == "function" then
      local exp = os.time() + 86400
      local enc = xorCrypt(stage, HW .. SID)
      writefile(CACHE, exp .. "|" .. fnv1a(stage .. HW .. SID) .. "|" .. enc)
    end
  end)
end

if typeof(KEY) == "string" and #KEY >= 8 then
  local okg, g = pcall(getgenv)
  if okg and typeof(g) == "table" then g.__0x6k = KEY end
end
KEY = nil
local safe_ls = (typeof(clonefunction) == "function" and clonefunction(loadstring)) or loadstring
local run = safe_ls(stage)
stage = nil
pcall(function() collectgarbage("collect") end)
if typeof(run) ~= "function" then error("failed to load", 0) end
local okr, errr = xpcall(run, function(e) return tostring(e) end)
KEY = nil
if not okr then error(errr, 0) end
return function() end
