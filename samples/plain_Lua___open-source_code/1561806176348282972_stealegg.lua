local payloadUrl="https://synex.lat/loaders/stealegg.v35.payload.lua?t=1792520410.SDpUc92gW-q4pystEdga5G8X"
local reportForeign=true
local foreignCount=0
local reportUrl="https://synex.lat/api/loader-report/stealegg?token=eyJwIjoicmVwb3J0IiwicyI6InN0ZWFsZWdnIiwidiI6MzUsImlhdCI6MTc5MjQzNDAxMCwiZXhwIjoxNzkyNTIwNDEwfQ.-YR6-SjVExRZUOSzefAnnqNv8LFx839x8wZE56P8Z9I"
local telemetryUrl="https://synex.lat/api/telemetry/run"
local telemetryToken="eyJwIjoidGVsZW1ldHJ5IiwicyI6InN0ZWFsZWdnIiwidiI6MzUsImlhdCI6MTc5MjQzNDAxMCwiZXhwIjoxNzkyNTIwNDEwfQ.OoFqeZs9jOypNMS-5UfCet71GOGiodyfot-FjTC2Dqw"
local slug="stealegg"
local version=35
local chunkMarker="@Synex/"..slug.."/v"..version
local HttpService=game:GetService("HttpService")
local function urlencode(s)
  s=tostring(s or "")
  s=s:gsub("[^%w_%-%.~]",function(c) return string.format("%%%02X",string.byte(c)) end)
  return s
end
local function identify()
  local executor="Unknown"
  pcall(function() if identifyexecutor then executor=identifyexecutor() end end)
  return executor
end
local reportCount=0
local lastSent={}
local function __spawn(fn) pcall(function() if task and task.spawn then task.spawn(fn) else fn() end end) end
local function __delay(seconds,fn) pcall(function() if task and task.delay then task.delay(seconds,fn) end end) end
local function __pack(...) if table.pack then return table.pack(...) end local t={n=select('#',...)} for i=1,t.n do t[i]=select(i,...) end return t end
local function __unpack(t,a,b) if table.unpack then return table.unpack(t,a,b) end return unpack(t,a,b) end
-- Fire-and-forget HTTP for telemetry/reports. Prefers the executor's request API
-- (syn.request / http_request / request), which returns a response table instead
-- of throwing the noisy "HTTP Exception while yielding: Timeout was reached" that
-- game:HttpGet prints to console when the server is slow or unreachable. Falls
-- back to HttpGet only if no request API exists. Self-disables after a few
-- failures so a bad network can never keep spamming the console.
local __netFails=0
local __netDead=false
local function __http(url)
  if __netDead then return false end
  local ok=false
  pcall(function()
    local req=(syn and syn.request) or (http and http.request) or http_request or request
    if type(req)=="function" then
      ok=req({Url=url,Method="GET"})~=nil
    else
      game:HttpGet(url)
      ok=true
    end
  end)
  if not ok then __netFails=__netFails+1 if __netFails>=3 then __netDead=true end end
  return ok
end
local function playerInfo()
  local pid,pname="0",""
  pcall(function()
    local p=game:GetService("Players").LocalPlayer
    if p then pid=tostring(p.UserId) pname=tostring(p.Name) end
  end)
  return pid,pname
end
local function sendReport(kind,message,trace)
  if __netDead then return end
  local msg=string.sub(tostring(message or "Unknown error"),1,600)
  local tr=string.sub(tostring(trace or ""),1,1500)
  if kind~="success" then
    local key=kind..":"..msg
    local now=os.clock()
    if lastSent[key] and now-lastSent[key]<30 then return end
    if reportCount>=15 then return end
    lastSent[key]=now
    reportCount=reportCount+1
  end
  local executor=identify()
  local pid,pname=playerInfo()
  local params="kind="..urlencode(kind).."&message="..urlencode(msg).."&trace="..urlencode(tr).."&place_id="..urlencode(tostring(game.PlaceId)).."&job_id="..urlencode(tostring(game.JobId)).."&game_name="..urlencode(tostring(game.Name)).."&executor="..urlencode(tostring(executor)).."&version="..urlencode(tostring(version)).."&player_id="..urlencode(pid).."&player_name="..urlencode(pname)
  -- Non-blocking; prefers the request API so a slow server never prints a
  -- "while yielding: Timeout" error, and stops entirely after repeated failures.
  __spawn(function() __http(reportUrl.."&"..params) end)
end
-- Anonymous run analytics (online-now + execution counters). Never blocks the script.
local sessionKey=nil
pcall(function() sessionKey=HttpService:GenerateGUID(false) end)
local function sendTelemetry(ev)
  if telemetryUrl=="" or not sessionKey or __netDead then return end
  local userId="0"
  pcall(function()
    local p=game:GetService("Players").LocalPlayer
    if p then userId=tostring(p.UserId) end
  end)
  local params="e="..urlencode(ev).."&k="..urlencode(sessionKey).."&s="..urlencode(slug).."&p="..urlencode(tostring(game.PlaceId)).."&g="..urlencode(tostring(game.Name)).."&u="..urlencode(userId).."&x="..urlencode(identify())
   params=params.."&v="..urlencode(tostring(version))
   if telemetryToken~="" then params=params.."&t="..urlencode(telemetryToken) end
   __spawn(function() __http(telemetryUrl.."?"..params) end)
end
sendTelemetry("start")
__spawn(function()
  for _=1,120 do
    task.wait(120)
    if __netDead then break end
    sendTelemetry("beat")
  end
end)
local __fpid=playerInfo()
-- Fetch the payload. Prefer the executor's request API (quiet on a slow server,
-- returns the body directly) and fall back to HttpGet with identical behavior on
-- anything that isn't a clean 200 (keeps the existing token/error handling).
local function __fetch(url)
  local req=(syn and syn.request) or (http and http.request) or http_request or request
  if type(req)=="function" then
    local ok,r=pcall(req,{Url=url,Method="GET"})
    local body=r and (r.Body or r.body)
    local status=r and (r.StatusCode or r.status_code)
    if ok and type(body)=="string" and (status==nil or status==200) then return true,body end
  end
  return pcall(game.HttpGet,game,url)
end
local sourceOk,source=__fetch(payloadUrl.."&u="..urlencode(__fpid).."&pl="..urlencode(tostring(game.PlaceId)))
if not sourceOk then sendReport("loader_error",source,""); error(source,0) end
local function __cksum(s) local h=0 for i=1,#s do h=(h*257+string.byte(s,i))%1000000007 end return h end
if __cksum(source)~=510401976 then sendReport("integrity_error","payload checksum mismatch (expected 510401976)","") error("[Synex] Integrity check failed — the script was modified.",0) end
local chunk,compileError=loadstring(source,chunkMarker)
if not chunk then sendReport("compile_error",compileError,""); error(compileError,0) end
-- Roblox prints chunk names without the leading "@", e.g. Script 'Synex/slug/v3', Line 3
local traceMarker="Synex/"..slug.."/v"..version
local function ours(a,b)
  return string.find(tostring(a or ""),traceMarker,1,true)~=nil or string.find(tostring(b or ""),traceMarker,1,true)~=nil
end
pcall(function()
  game:GetService("ScriptContext").Error:Connect(function(message,trace)
    if ours(message,trace) then sendReport("runtime_error",message,trace) end
  end)
end)
-- Executors often run on threads ScriptContext.Error never sees; the console does.
pcall(function()
  local pending=nil
  local function flush()
    local p=pending
    pending=nil
    if not p then return end
    local stack=table.concat(p.stack,"\n")
    if ours(p.msg,stack) then sendReport("runtime_error",p.msg,stack)
    elseif reportForeign and foreignCount<3 then foreignCount=foreignCount+1 sendReport("foreign_activity",p.msg,stack) end
  end
  game:GetService("LogService").MessageOut:Connect(function(text,kind)
    if kind==Enum.MessageType.MessageError then
      flush()
      local entry={msg=text,stack={}}
      pending=entry
       __delay(0.6,function() if pending==entry then flush() end end)
    elseif pending and kind==Enum.MessageType.MessageInfo then
      if text=="Stack Begin" then return end
      if text=="Stack End" then flush() return end
      if #pending.stack<12 then table.insert(pending.stack,text) end
    end
  end)
end)
local lastTrace=""
local function traceError(err)
  if debug and debug.traceback then lastTrace=debug.traceback("",2) end
  return tostring(err)
end

-- Secret seed (session-seeding): sealed builds lifted their secrets out of the
-- payload; fetch the table here and hand it to the chunk as vararg #2. An offline
-- sandbox's faked HTTP never yields it, so the payload stays a hollow shell there.
local __seed=nil
do
  local __sok,__sbody=__fetch("https://synex.lat/loaders/stealegg.v35.seed.lua?t=1792520410.SDpUc92gW-q4pystEdga5G8X".."&u="..urlencode(__fpid).."&pl="..urlencode(tostring(game.PlaceId)))
  if not __sok then sendReport("loader_error","seed fetch failed",""); error("[Synex] Could not load (seed).",0) end
  local __sfn=loadstring(__sbody)
  if not __sfn then sendReport("loader_error","seed parse failed",""); error("[Synex] Could not load (seed).",0) end
  local __sok2,__stbl=pcall(__sfn)
  if not __sok2 or type(__stbl)~="table" then sendReport("loader_error","seed invalid",""); error("[Synex] Could not load (seed).",0) end
  __seed=__stbl
end
-- Loader guard handshake: passed only for versions built with the guard baked
-- in, so unguarded builds keep running exactly as before. A payload lifted and
-- run without this loader never receives it and refuses (see loaderGuardPrologue).
local __gk=nil
local result=__pack(xpcall(chunk,traceError,__gk,__seed))
if not result[1] then sendReport("runtime_error",result[2],lastTrace); error(result[2],0) end
sendReport("success","","")
return __unpack(result,2,result.n)