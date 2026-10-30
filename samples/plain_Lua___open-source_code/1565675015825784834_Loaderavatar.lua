
-- Avatar Changer | Auto-Update Loader

local SCRIPT_URL = "https://gist.githubusercontent.com/tommywiththeman/8a8a5fbbfc3e21c4d93e8d87ff67c990/raw/Avatarchanger.lua"

local success, err = pcall(function()
    local source = game:HttpGet(SCRIPT_URL)

    assert(source and #source > 0, "Failed to download script")

    local compiled, compileError = loadstring(source)
    assert(compiled, compileError or "Failed to compile script")

    compiled()
end)

if not success then
    warn("[Avatar Changer Loader] " .. tostring(err))
end
