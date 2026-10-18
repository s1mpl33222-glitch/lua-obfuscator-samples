-- Sydra
local function hooked(f)
    if type(f) ~= "function" then
        return false
    end

    -- only the executor's own hook check: some executors write these functions in Lua,
    -- so an iscclosure test would kick normal users
    if type(isfunctionhooked) == "function" then
        local ok, r = pcall(isfunctionhooked, f)

        if ok and r then
            return true
        end
    end

    return false
end

local checks = {
    loadstring,
    setclipboard,
    toclipboard,
    request,
    http_request,
    syn and syn.request,
    http and http.request
}

local okGet, httpGet = pcall(function()
    return game.HttpGet
end)

if okGet then
    table.insert(checks, httpGet)
end

for _, f in pairs(checks) do
    if hooked(f) then
        game:GetService("Players").LocalPlayer:Kick("Sydra: tampering detected")
        return
    end
end

local ok, src = pcall(function()
    return game:HttpGet("https://sydra.xyz/s/ca0601cf28868c287978c18e1295befbe0e9ef2c2c20e455")
end)

if not ok or type(src) ~= "string" or src:sub(1, 15) == "<!doctype html>" then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sydra",
            Text = "Could not load, try again.",
            Duration = 5
        })
    end)

    return
end

local fn = loadstring(src)

if fn then
    fn()
end
