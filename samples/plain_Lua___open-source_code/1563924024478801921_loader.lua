local HttpService = game:GetService("HttpService")
local request = (syn and syn.request) or (http and http.request) or http_request or request
if not request then return warn("executor ไม่รองรับ request") end

local base = "https://wreaperhubxyz.vercel.app"

local s = request({ Url = base .. "/api/session", Method = "POST" })
if not s or s.StatusCode ~= 200 then return warn("session failed") end
local session = HttpService:JSONDecode(s.Body).session

local r = request({
    Url = base .. "/api/source",
    Method = "GET",
    Headers = { ["x-reaperlayer-session"] = session }
})
if not r or r.StatusCode ~= 200 then return warn("source failed") end

local fn, err = loadstring(r.Body)
if not fn then return warn(err) end
fn()
