local LUARMOR_ENDPOINT = "https://api.luarmor.net/files/v4/loaders/160986a03c7a35b1a6561f28e7e7e430.lua"
local FETCHING_TIMEOUT = getgenv().ERAHUBFETCHINGTIMEOUT or 30

function fetchScript()
    return game:HttpGet(LUARMOR_ENDPOINT)
end

function loadScript()
    local script = fetchScript()
    loadstring(script)()
end

function boot()
    print("Booting script")
    task.spawn(loadScript)

    task.delay(FETCHING_TIMEOUT, function()
        if not getgenv().__ERAHUBLOADED then
            boot()
        end
    end)
end

boot()
