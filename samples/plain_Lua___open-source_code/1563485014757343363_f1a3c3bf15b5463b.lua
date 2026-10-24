


if not getgenv().__panda_elc_f1a3c3bf15b5463b then
getgenv().__panda_elc_f1a3c3bf15b5463b = true
local jsonEncode = game:GetService("HttpService").JSONEncode
task.spawn(function()
    while task.wait(10) do
        local ok, err = pcall(function()
            request({
                Url = "https://vss.pandadevelopment.net/execute_information",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonEncode(game:GetService("HttpService"), {
                    slug_id = "f1a3c3bf15b5463b",
                    executor_name = identifyexecutor and identifyexecutor() or "Unknown",
                    hardware_id = gethwid and gethwid() or "",
                    job_id = tostring(game.JobId),
                    place_id = tostring(game.PlaceId),
                }),
            })
        end)
        if not ok then
            warn("[Panda VSS] Execute information failed:", err)
        end
    end
end)
end



-- Panda VSS Protected Script
-- This stub carries no data. Copying it is pointless.
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
do
  local req = (syn and syn.request)
    or (http and http.request)
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)
    or request
    or http_request
  if not req and game and game.HttpGet then
    req = function(t)
      local ok, res = pcall(game.HttpGet, game, t.Url)
      if ok then return { Body = res, StatusCode = 200 } end
      local code = tonumber(tostring(res):match("HTTP (%d+)"))
      return code and { StatusCode = code } or nil
    end
  end
  if not req then return lp:Kick("Panda VSS: Unsupported executor.") end
  if not loadstring then return lp:Kick("Panda VSS: Missing loadstring.") end

  if getrawmetatable then
    local okMt, mt = pcall(getrawmetatable, game)
    if okMt and mt then
      local di = debug and (debug.info or debug.getinfo)
      if di then
        local nc = rawget(mt, "__namecall")
        if nc and type(nc) == "function" then
          local ok, r = pcall(function()
            return (di(nc, "s") == "[C]")
              or (debug.getinfo and debug.getinfo(nc, "S").what == "C")
          end)
          if ok and not r then return lp:Kick("Panda VSS: Metatable tamper detected.") end
        end
      end
    end
  end

  -- identity: the server and Cloudflare both gzip a payload this size, and some
  -- executor HTTP stacks advertise gzip then hand Lua an undecodable body.
  local headers = {
    ["User-Agent"] = "Roblox/PandaVssLoader",
    ["Accept-Encoding"] = "identity",
  }

  local function fetch(url, what)
    local ok, res = pcall(req, { Url = url, Method = "GET", Headers = headers })
    if not ok or type(res) ~= "table" then
      return nil, "Network error reaching the script server (" .. what .. "). Check your connection and re-execute the loader."
    end
    local code = res.StatusCode or res.status_code or res.Status
    local body = res.Body or res.body or res.Response or res.response
    if code and code ~= 200 then
      if code == 403 then
        return nil, "Your executor was rejected by the script server (HTTP 403, " .. what .. "). It is sending a blocked User-Agent; try another executor."
      elseif code == 404 then
        return nil, "Session expired or already used (" .. what .. "). Re-execute; if running many accounts, launch fewer at once."
      elseif code == 429 then
        return nil, "Rate limited (" .. what .. "). Wait a minute, then re-execute the loader."
      end
      return nil, "Script server returned HTTP " .. tostring(code) .. " (" .. what .. "). Re-execute the loader."
    end
    if type(body) ~= "string" or #body < 4 then
      return nil, "Your executor returned no readable response body (" .. what .. "). Update your executor or try another one."
    end
    if body:sub(1, 2) == "--" then
      return nil, "Script server refused the request (" .. what .. "): " .. body:sub(1, 60)
    end
    return body
  end

  local prBody, prErr = fetch("https://vss.pandauth.com/virtual/_otp/12a7f4e41dbeb0b9883fb9b77345c449f5b89a165404814f", "payload")
  if not prBody then return lp:Kick("Panda VSS: " .. prErr) end
  local krBody, krErr = fetch("https://vss.pandauth.com/virtual/_otk/5e9496099eabaf2d1121ee8bc7bc387090d771192585f879", "key")
  if not krBody then return lp:Kick("Panda VSS: " .. krErr) end

  local function b64d(s)
    local alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local buf, bits, acc = {}, 0, 0
    for i = 1, #s do
      local v = alpha:find(s:sub(i,i), 1, true)
      if v then
        acc = acc * 64 + (v - 1); bits = bits + 6
        if bits >= 8 then
          bits = bits - 8
          local byte = math.floor(acc / 2^bits)
          table.insert(buf, string.char(byte))
          acc = acc - byte * 2^bits
        end
      end
    end
    return table.concat(buf)
  end
  local function xd(data, key)
    local out, prev = {}, 0
    local bxor = (bit32 and bit32.bxor) or (bit and bit.bxor) or function(a, b)
      local r, m = 0, 1
      for _ = 0, 7 do
        if math.floor(a/m)%2 ~= math.floor(b/m)%2 then r = r + m end
        m = m * 2
      end
      return r
    end
    for i = 1, #data do
      local c   = string.byte(data, i)
      local rk  = bxor(string.byte(key, (i-1) % #key + 1), prev) % 256
      local dec = bxor(c, rk)
      table.insert(out, string.char(dec))
      prev = c
    end
    return table.concat(out)
  end

  local dk   = b64d(krBody)
  local raw  = b64d(prBody)
  local code = xd(raw, dk)
  local fn, err = loadstring(code)
  if fn then
    if task and task.spawn then task.spawn(fn) else return fn() end
  else
    warn("[Panda VSS] Decryption error: " .. tostring(err))
    lp:Kick("Panda VSS: Script failed integrity check.")
  end
end
