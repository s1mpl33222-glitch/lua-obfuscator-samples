-- Mirrors Hub loader
-- Dedicated scripts are loaded when available.
-- Other games use Mirrors Hub Universal.

local scripts = {
    -- [FPS] Flick
    [136801880565837] = "https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20%5BFPS%5D%20Flick/flick.lua",
}

local universalUrl = "https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Universal/universal.lua"

local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 7,
        })
    end)
end

local function report(stage, detail)
    local message = tostring(detail or "Unknown error")

    warn(("[MIRRORS] %s failed: %s"):format(stage, message))

    notify(
        "Mirrors Hub error",
        stage .. " failed. Open the executor console for details."
    )
end

local function executeUrl(url, label)
    local downloaded, source = pcall(function()
        return game:HttpGet(url, true)
    end)

    if not downloaded then
        report(label .. " download", source)
        return false
    end

    if type(source) ~= "string" or source:match("^%s*$") then
        report(
            label .. " download",
            "Server returned an empty script"
        )
        return false
    end

    local compiled, chunk = pcall(loadstring, source)

    if not compiled or type(chunk) ~= "function" then
        report(
            label .. " compile",
            chunk or "loadstring is unavailable"
        )
        return false
    end

    local executed, runtimeError = pcall(chunk)

    if not executed then
        report(label .. " runtime", runtimeError)
        return false
    end

    return true
end

-- Wait until Roblox finishes loading.
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local placeId = game.PlaceId

-- Check for a dedicated Mirrors Hub script.
local dedicatedUrl = scripts[placeId]

if dedicatedUrl then
    notify(
        "Mirrors Hub",
        "Supported game detected. Loading dedicated script..."
    )

    local success = executeUrl(
        dedicatedUrl,
        "Dedicated script"
    )

    if not success then
        notify(
            "Mirrors Hub",
            "Dedicated script failed. Loading Universal fallback..."
        )

        executeUrl(
            universalUrl,
            "Universal fallback"
        )
    end
else
    -- No dedicated script available.
    -- Load the Universal script.
    notify(
        "Mirrors Hub",
        "Loading Mirrors Hub Universal..."
    )

    executeUrl(
        universalUrl,
        "Universal script"
    )
end
