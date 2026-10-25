-- Anti-tamper: refuse to run if loadstring/HttpGet have been hooked (a common
-- technique used to intercept and leak this script's source).
print("Kairsh")
local function _isGenuine(fn)
    if type(fn) ~= "function" then return false end
    local ok, isC = pcall(function() return iscclosure and iscclosure(fn) end)
    if ok and isC ~= nil then return isC end
    local ok2, what = pcall(function()
        if debug and debug.info then
            return debug.info(fn, "s")
        elseif debug and debug.getinfo then
            local info = debug.getinfo(fn)
            return info and info.what
        end
    end)
    if ok2 and what ~= nil then return what == "[C]" or what == "C" end
    return true
end

-- Behavioral canary: a hooked loadstring that logs/mocks instead of actually
-- compiling code (like a source-dumping hook) will fail to return the right
-- answer for a trivial expression. Catches hooks even on executors without
-- iscclosure/debug introspection.
local function _loadstringGenuine()
    if not _isGenuine(loadstring) then return false end
    local a, b = math.random(100, 999), math.random(100, 999)
    local ok, chunk = pcall(loadstring, "return " .. a .. " + " .. b)
    if not ok or type(chunk) ~= "function" then return false end
    local ok2, result = pcall(chunk)
    return ok2 and result == (a + b)
end

print("[Kairsh Studio] hub.lua started")
if not _isGenuine(loadstring) then print("[Kairsh Studio] loadstring genuine check failed") return end
if not _isGenuine(game.HttpGet) then print("[Kairsh Studio] HttpGet genuine check failed") return end
if not _loadstringGenuine() then print("[Kairsh Studio] loadstring math test failed") return end

-- Stronger hook detection. A dumper hooks loadstring/HttpGet (or game's
-- __namecall for game:HttpGet) with a C wrapper that logs and passes the call
-- through, which the checks above can't see. The executor can tell us
-- directly with isfunctionhooked(). (game's __namecall isn't checked: lots of
-- ordinary scripts hook it, and players running them were blocked.)
local function _hooked()
    local isHooked = (getgenv and getgenv().isfunctionhooked) or isfunctionhooked
    if type(isHooked) == "function" then
        local targets = { loadstring, game.HttpGet, game.HttpGetAsync, getgenv and getgenv().request,
            getgenv and getgenv().http_request }
        for _, fn in pairs(targets) do
            if type(fn) == "function" then
                local ok, h = pcall(isHooked, fn)
                if ok and h == true then return true end
            end
        end
    end
    return false
end

if _hooked() then
    local msg = "A script is hooking loadstring/HttpGet. Rejoin without other scripts, then run the loader again."
    warn("[Kairsh Studio] " .. msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Kairsh Studio", Text = msg, Duration = 10 })
    end)
    return
end


-- Load the auth GUI through a one-time link: the server hands out a token
-- that works once, for this IP, for 20 seconds, then is gone for good.
local _uid = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.UserId or 0
local _place = tostring(game.PlaceId or 0)
local _universe = tostring(game.GameId or 0)
print("[Kairsh Studio] Fetching one-time token for UID " .. tostring(_uid))
-- Retry empty/failed responses: the first request after a join can come
-- back empty (network still settling), which used to end the session.
local function _fetch(url, accept)
    local last = ""
    for attempt = 1, 4 do
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and type(res) == "string" and res ~= "" then
            last = res
            if not accept or accept(res) then return res end
        end
        if attempt < 4 then
            print("[Kairsh Studio] Empty or bad response, retrying (" .. attempt .. "/3)...")
            task.wait(attempt)
        end
    end
    return last
end

-- The loader link is single-use, so a refused one ("expired") can't be
-- retried as-is: mint a fresh token and try the whole exchange again.
local _gui_src, _tok = "", ""
for round = 1, 3 do
    _tok = _fetch("https://kairshstudio.com/loader.php?a=mint&u=" .. tostring(_uid)
            .. "&p=" .. _place .. "&v=" .. _universe,
        function(r) return r:match("^%x+$") and #r == 48 end)
    if type(_tok) ~= "string" or not _tok:match("^%x+$") or #_tok ~= 48 then break end
    print("[Kairsh Studio] Token received. Fetching loader (attempt " .. round .. "/3).")
    local ok, res = pcall(function()
        return game:HttpGet("https://kairshstudio.com/loader.php?t=" .. _tok .. "&u=" .. tostring(_uid))
    end)
    _gui_src = (ok and type(res) == "string") and res or ""
    -- A real loader is large; the server's refusals are short warn() lines.
    if #_gui_src > 2000 then break end
    print("[Kairsh Studio] Loader refused or empty, retrying with a new token...")
    task.wait(round)
end

if type(_tok) ~= "string" or not _tok:match("^%x+$") or #_tok ~= 48 then
    if _tok == "" then
        warn("[Kairsh Studio] No response from kairshstudio.com. Check your connection and run the loader again.")
        return
    end
    local f, err = loadstring(tostring(_tok))
    if f then pcall(f) else print("[Kairsh Studio] Could not compile server response: " .. tostring(err)) end
    return
end
if _gui_src == "" then
    warn("[Kairsh Studio] Couldn't download the loader. Run it again.")
    return
end
print("[Kairsh Studio] Received gui_loader source (length " .. tostring(#_gui_src) .. "). Executing...")
loadstring(_gui_src)()
print("[Kairsh Studio] gui_loader execution finished.")
