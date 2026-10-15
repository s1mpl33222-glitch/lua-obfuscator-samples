if not game:IsLoaded() then
    game.Loaded:Wait()
end

local env = (getgenv and getgenv()) or _G

if env.__ZANJIHUB_LOADING then
    return
end

env.__ZANJIHUB_LOADING = true

local GAG = "https://raw.githubusercontent.com/jr0nzz/zanjihub/refs/heads/main/zanjihub.lua"
local RAP = "https://raw.githubusercontent.com/jr0nzz/zanjihub/refs/heads/main/rideapet.lua"
local SAE = "https://raw.githubusercontent.com/jr0nzz/zanjihub/refs/heads/main/stealanegg.lua"

local ROUTES = {
    [126884695634066] = GAG,
    [124977557560410] = GAG,
    [129954712878723] = GAG,
    [108890465381067] = GAG,

    [124216119978534] = RAP,
    [107778070777162] = SAE,
}

local ok, err = pcall(function()
    local url = ROUTES[game.PlaceId]

    if not url then
        error("Unsupported PlaceId: " .. game.PlaceId)
    end

    local source

    for i = 1, 3 do
        local success, result = pcall(game.HttpGet, game, url, true)

        if success and type(result) == "string" and #result > 0 then
            source = result
            break
        end

        task.wait(i * 0.5)
    end

    if not source then
        error("Failed to download script")
    end

    local chunk, compileError = loadstring(source)

    if not chunk then
        error(compileError)
    end

    chunk()
end)

env.__ZANJIHUB_LOADING = nil

if not ok then
    warn("[ZANJIHUB] " .. tostring(err))
end
