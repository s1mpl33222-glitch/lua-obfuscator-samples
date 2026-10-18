

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local K = (getgenv and (getgenv().script_key or getgenv().Key)) or ""

local function H()
  local a, b
  pcall(function() a = game:GetService("RbxAnalyticsService"):GetClientId() end)
  if gethwid then pcall(function() b = gethwid() end) end
  local function ok(x)
    x = tostring(x or "")
    return #x >= 16
      and x:match("^[%w%%+%%/%%=%%:%%.%%-]+$") ~= nil
      and not x:lower():find("unknown", 1, true)
  end
  if ok(b) then return b
  elseif ok(a) then return a
  else return tostring(b or a or "unknown")
  end
end

local function kick(msg)
  warn("[renzo] " .. msg)
  LocalPlayer:Kick("[renzo] " .. msg)
end

local function E(s)
  return (tostring(s):gsub("[^%w%-_]", function(c)
    return string.format("%%%02X", string.byte(c))
  end))
end

local u = "https://renzoauth.lol/s"
  .. "?hwid="  .. E(H())
  .. "&place=" .. E(game.PlaceId)
  .. "&job="   .. E(game.JobId)
  .. "&exe="   .. E((identifyexecutor and identifyexecutor()) or "?")
  .. "&key="   .. E(K)


local function fetch(url)
  local rq = (syn and syn.request)
           or (http and http.request)
           or http_request
           or request
  for _ = 1, 3 do
    if rq then
      local ok, r = pcall(rq, { Url = url, Method = "GET" })
      if ok and type(r) == "table" then
        local b = r.Body or r.body
        if type(b) == "string" and #b > 0 then
          return b, r.StatusCode or r.statusCode or 200
        end
      end
    end
    local ok2, b = pcall(function() return game:HttpGet(url, true) end)
    if ok2 and type(b) == "string" and #b > 0 then
      -- HttpGet hides the status code; /s deny bodies start with warn("[renzo] ...
      local denied = b:match('^%s*warn%("%[skyr0%]')
      return b, denied and 403 or 200
    end
    local wt = (task and task.wait) or wait
    if wt then pcall(wt, 0.35) end
  end
  return nil, nil
end

local body, status = fetch(u)


if type(body) ~= "string" then
  kick("auth server unreachable - try again later")
  return
end


if status == 403 then
  local reason = body:match('^%s*warn%("%[skyr0%] (.-)")%s*$') or "access denied"
  kick(reason)
  return
end

if status == 502 then
  kick("script unavailable - try again later")
  return
end

local f, err = loadstring(body)
if not f then
  kick("script corrupted - re-download")
  return
end

return f()