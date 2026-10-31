-- Do not save this file.
-- Always use loadstring.
local h="cf183297bf6955ce42cb4df30a614a8e"
local a="https://luavify.dpdns.org"
local u=a.."/api/get-payload?hash=cf183297bf6955ce42cb4df30a614a8e&ts=1793434134&nonce=a29fc029-1206-4a25-ac03-0391eec02ba1&seal=88a73e6f5281a0db8299eec6f9072cea0baefa1ac5797647dd4ac327f131895a"
local k=""
pcall(function() if getgenv then k=tostring(getgenv().script_key or "") end end)
if k=="" then warn("[Luavify] A valid script key is required.") return end
local e=k
pcall(function() e=game:GetService("HttpService"):UrlEncode(k) end)
u=u.."&key="..e
local function get(x)
  local ok,b=pcall(function() return game:HttpGet(x) end)
  if ok and type(b)=="string" and #b>0 then return b end
  local r=(syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
  if r then
    ok,b=pcall(function() return r({Url=x,Method="GET"}) end)
    if ok and type(b)=="table" and b.StatusCode==200 and type(b.Body)=="string" then return b.Body end
  end
  return nil
end
local p=get(u)
if type(p)~="string" or p=="" or p:sub(1,1)=="<" or p:sub(1,8)=="Luavify:" then
  warn("[Luavify] Payload download failed or access was denied.")
  if type(p)=="string" and p~="" then warn("[Luavify] Server response: "..p:sub(1,240)) end
  return
end

-- A JSON error/wrapper must never be sent into loadstring as if it were Luau.
if p:match("^%s*{") then
  local okJson, decoded = pcall(function()
    return game:GetService("HttpService"):JSONDecode(p)
  end)
  if okJson and type(decoded)=="table" then
    local reason = decoded.error or decoded.message or decoded.detail or decoded.status
    warn("[Luavify] Server returned JSON instead of a Luau payload.")
    if reason then warn("[Luavify] Server says: "..tostring(reason):sub(1,240)) end
  else
    warn("[Luavify] Server returned text beginning with '{', not valid Luau.")
    warn("[Luavify] Response: "..p:sub(1,240))
  end
  return
end

local c=loadstring or load
if not c then warn("[Luavify] loadstring is unavailable.") return end
local f,err=c(p)
if not f then warn("[Luavify] Compile failed: "..tostring(err)) return end
local s=""
pcall(function() s=game:GetService("HttpService"):GenerateGUID(false) end)
if s=="" then s=tostring(math.random(100000000,999999999))..tostring(os.time()) end
local spawnFn=(task and task.spawn) or spawn
local waitFn=(task and task.wait) or wait
pcall(function()
  spawnFn(function()
    pcall(function() get(a.."/log-execution?hash="..h.."&sid="..s) end)
    while true do
      waitFn(60)
      pcall(function() get(a.."/api/heartbeat?hash="..h.."&sid="..s) end)
    end
  end)
end)
f()