-- Do not save this file
-- Always use the loadstring
local cfg = {
    id = "aNFZ3mtBQi2HW6h7HINx5X4uCrLwv21S",
    requireKey = false,
    places = "",
    name = "Acid",
    cache = false,
    base = "https://lua.lystore.lol",
}
local FOLDER, VERSION = "lystore_content", "1"
local FILE = FOLDER .. "/init-" .. VERSION .. ".lua"

local function fetch(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 0 then return body end
    local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
    if req then
        local ok2, res = pcall(req, {Url = url, Method = "GET"})
        if ok2 and res and tonumber(res.StatusCode or res.Status or 0) == 200 and type(res.Body) == "string" then
            return res.Body
        end
    end
    return nil
end

-- 把初始化檔編譯成函式；檔案不完整或被截斷 (編譯失敗、太短) 就回傳 nil
local function loadInit(src)
    if type(src) ~= "string" or #src < 500 then return nil end
    local chunk = loadstring(src)
    if not chunk then return nil end
    local ok, initFn = pcall(chunk)
    if ok and type(initFn) == "function" then return initFn end
    return nil
end

local cached
pcall(function() cached = readfile(FILE) end)
local initFn = loadInit(cached)
if not initFn then
    local fresh = fetch(cfg.base .. "/init/" .. VERSION .. ".lua")
    initFn = loadInit(fresh)
    if initFn then
        pcall(makefolder, FOLDER)
        pcall(writefile, FILE, fresh)
    end
end
if not initFn then
    error("Failed to load the initializer, please try again")
end
return initFn(cfg)
