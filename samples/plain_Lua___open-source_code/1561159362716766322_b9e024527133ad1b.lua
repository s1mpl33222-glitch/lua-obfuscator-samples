-- [[ DreameAuth v2.0 - Secure Loader ]]
-- [[ ID: b9e024527133ad1b | Domain: https://dreameauth.xo.je ]]
local _wait = (task and task.wait) or wait or function() end
if game and game.IsLoaded and not game:IsLoaded() then local _w=0; while not game:IsLoaded() and _w<30 do _wait(0.1); _w=_w+1 end end

do local function _chk() 
local ok,g = pcall(function() return game end) if not ok or not g then return false end 
local ok_p,pl = pcall(function() return game:GetService("Players") end) if not ok_p or not pl then return false end 
return true end if not _chk() then return end end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then local _w=0; while not LocalPlayer and _w<30 do _wait(0.1); LocalPlayer=Players.LocalPlayer; _w=_w+1 end end

local SCRIPT_ID = "b9e024527133ad1b"
local IS_KEYLESS = true
local VERIFY_URL = "https://dreameauth.auth-c18.workers.dev/api/script"

local function safe_kick(reason)
    warn("[DreameAuth] " .. tostring(reason))
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "DreameAuth", Text = tostring(reason), Duration = 10 }) end)
    pcall(function() if setclipboard then setclipboard("") end if toclipboard then toclipboard("") end end)
    if LocalPlayer and LocalPlayer.Kick then
        pcall(function() LocalPlayer:Kick("DreameAuth: " .. tostring(reason)) end)
    end
    error("DreameAuth: " .. tostring(reason), 0)
end

local function get_executor()
    local name = "Unknown"
    pcall(function()
        if identifyexecutor then name = tostring(identifyexecutor())
        elseif getexecutorname then name = tostring(getexecutorname())
        elseif syn then name = "Synapse"
        elseif fluxus then name = "Fluxus"
        elseif KRNL_LOADED then name = "Krnl"
        end
    end)
    return name
end

local function get_hwid()
    local hwid = nil
    pcall(function()
        if gethwid then hwid = tostring(gethwid())
        elseif get_hwid then hwid = tostring(get_hwid())
        end
    end)
    if not hwid or #hwid < 4 then
        pcall(function()
            local a = game:GetService("RbxAnalyticsService")
            if a and a.GetClientId then hwid = tostring(a:GetClientId()) end
        end)
    end
    if not hwid or #hwid < 4 then
        local uid = (LocalPlayer and LocalPlayer.UserId) or 0
        local jid = (game and game.JobId) or "0"
        hwid = tostring(uid) .. "-" .. tostring(jid)
    end
    return hwid
end

local user_key = ""
pcall(function()
    user_key = (getgenv and getgenv().script_key) or script_key or (_G and _G.script_key) or (shared and shared.script_key) or (getfenv and getfenv().script_key) or ""
end)

if not IS_KEYLESS and (user_key == nil or user_key == "") then
    safe_kick("DreameAuth: No key provided! Please specify script_key before running.")
    return
end

local hwid = get_hwid()
local executor = get_executor()

local verify_url = VERIFY_URL .. "?script_id=" .. SCRIPT_ID .. "&key=" .. HttpService:UrlEncode(tostring(user_key)) .. "&hwid=" .. HttpService:UrlEncode(tostring(hwid)) .. "&executor=" .. HttpService:UrlEncode(tostring(executor))

local req_fn = (syn and syn.request) or (http and http.request) or request or http_request or (fluxus and fluxus.request)
local function _fetch(url)
    local res = nil
    pcall(function() res = game:HttpGet(url) end)
    if (not res or #res < 5 or res:find("Access Denied")) and req_fn then
        pcall(function()
            local r = req_fn({ Url = url, Method = "GET", Headers = { ["User-Agent"] = "Roblox/WinInet" } })
            if r and (r.StatusCode == 200 or not r.StatusCode) and r.Body then
                res = r.Body
            end
        end)
    end
    return res
end

local raw_resp = _fetch(verify_url)
local data = nil
pcall(function() data = HttpService:JSONDecode(raw_resp) end)
if not data or data.status ~= "ok" then
    local msg = (data and data.message) or "Authentication failed (response: " .. tostring(raw_resp):sub(1, 50) .. ")"
    safe_kick("DreameAuth: " .. msg)
    return
end

local token = data.token
local fetch_url = "https://dreameauth.auth-c18.workers.dev/api/obf/scripts/" .. SCRIPT_ID .. "?token=" .. tostring(token)
local obf_source = _fetch(fetch_url)
if not obf_source or #obf_source < 10 then
    safe_kick("DreameAuth: Failed to retrieve protected script payload.")
    return
end

local _clean_load = loadstring or (getgenv and getgenv().loadstring) or load
if not _clean_load then
    safe_kick("DreameAuth: Incompatible executor environment (loadstring missing)")
    return
end
local fn, compile_err = nil, nil
local _ok_load, _res_load = pcall(function() return _clean_load(obf_source) end)
if _ok_load and _res_load then
    fn = _res_load
else
    local _ok_load2, _res_load2 = pcall(function() return _clean_load(obf_source, "=DreameAuth") end)
    if _ok_load2 and _res_load2 then fn = _res_load2 else compile_err = _res_load or _res_load2 end
end
obf_source = nil
pcall(function() collectgarbage("collect") end)
if not fn then
    safe_kick("DreameAuth: Script load failed: " .. tostring(compile_err))
    return
end
local _run_ok, _run_err = pcall(fn)
if not _run_ok then
    warn("[DreameAuth] Script runtime error: " .. tostring(_run_err))
end
