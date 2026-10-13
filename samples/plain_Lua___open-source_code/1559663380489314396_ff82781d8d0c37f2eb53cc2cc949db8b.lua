local Scripts = {
    [9908641400] = { id = "6fca2f9ab2ac9a5e430086ae5666150e", url = "https://bastiondev.org/api/loader/6fca2f9ab2ac9a5e430086ae5666150e", v = "v0.0.41-23" },
    [4931927012] = { id = "04db1fe1a93f2d9551329ebb36bf2370", url = "https://bastiondev.org/api/loader/04db1fe1a93f2d9551329ebb36bf2370", v = "v0.0.3-23" },
    [8558141897] = { id = "3bc887585852bd680da0c48125b6214b", url = "https://bastiondev.org/api/loader/3bc887585852bd680da0c48125b6214b", v = "v0.0.2-23" },
}
local Universal = nil

local S = Scripts[game.GameId] or Universal
if not S then return end

local DIR = "bst"
local fs = type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"
if fs and type(makefolder) == "function" then
    local exists = type(isfolder) == "function" and isfolder(DIR)
    if not exists then pcall(makefolder, DIR) end
end

local function httpget(u)
    local req = (syn and syn.request) or http_request or (http and http.request) or request
    if req then
        local ok, res = pcall(req, { Url = u, Method = "GET" })
        if ok and type(res) == "table" and type(res.Body) == "string" then return res.Body end
    end
    return game:HttpGet(u)
end

local function ensure(s)
    local file = DIR .. "/" .. s.id .. ".lua"
    local meta = DIR .. "/" .. s.id .. ".ver"
    if fs and isfile(file) and isfile(meta) then
        local ok, ver = pcall(readfile, meta)
        if ok and ver == s.v then
            local okf, src = pcall(readfile, file)
            if okf and type(src) == "string" and #src > 50 then return src end
        end
    end
    local src = httpget(s.url)
    if fs and type(src) == "string" and #src > 50 then
        pcall(writefile, file, src)
        pcall(writefile, meta, s.v)
    end
    return src
end

local src = ensure(S)
local chunk = src and loadstring(src)
if chunk then return chunk() end