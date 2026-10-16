-- This file was generated at discord.gg/syncrypt

local v2 = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
v2.service = "Pleiadex"
v2.identifier = "1023559"
game:GetService("HttpService")
game:GetService("Players")
local function v3(p1)
    local v17 = p1

    if v17 then
        v17 = p1 ~= ""
    end

    if v17 then
        pcall(function()
            if writefile then
                writefile("PleiadexKey.txt", p1)
            end
        end)
    end
end
local v4 = loadstring(game:HttpGet("https://sirius.menu/gen2"))():CreateWindow({
	name = "Pleiadex - Blair",
	theme = "amethyst"
})
local v5 = v4:CreateTab({
	name = "Key System",
	icon = 0
})
local s1 = ""
v5:CreateSection({
	name = "Key Validation",
	icon = 0
})
local v7 = v5:CreateInput({
	name = "Enter Key",
	value = "",
	placeholder = "Enter your key here...",
	flag = "KeyInput",
	callback = function(p2)
    s1 = p2
end
})
local v8 = game.PlaceId ~= 6137321701
if v8 then
    v8 = game.PlaceId ~= 6348640020
end
if v8 then
    v4:Notify({
		title = "Game Not Supported",
		content = "Please execute the script in a Blair lobby or ingame.",
		duration = 3
	})
    task.wait(3)
    v4:Unload()
end
v5:CreateButton({
	name = "Validate Key",
	callback = function()
    local v20 = s1

    if v20 then
        v20 = s1 ~= ""
    end

    if v20 then
        local ok, result = pcall(v2.check_key, s1)

        if not ok then
            local v23 = v4
            local v24 = "Could not validate your key: " .. tostring(result)

            v23:Notify({
					title = "Validation Error",
					content = v24,
					duration = 5
				})

            return
        end

        if result and result.valid then
            v3(s1)
            getgenv().SCRIPT_KEY = s1
            v4:Notify({
					title = "Success",
					content = "Your key is valid. Redirecting...",
					duration = 5
				})

            local ok2, result2 = pcall(function()
                loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/e92454125e152b05a012e312ab07c54822a8bad8f9c999d17ef690df232a54d7/download"))()
            end)

            if not ok2 then
                local v27 = v4
                local v28 = "The Blair script could not be loaded: " .. tostring(result2)

                v27:Notify({
						title = "Load Error",
						content = v28,
						duration = 5
					})
            end

            task.wait(2)
            v4:Unload()

            return
        end

        v4:Notify({
				title = "Invalid Key",
				content = "Your key is invalid.",
				duration = 5
			})

        return
    end

    v4:Notify({
			title = "Error",
			content = "Enter your key first!",
			duration = 3
		})
end
})
v5:CreateSection({
	name = "-- Links --",
	icon = 0
})
v5:CreateButton({
	name = "Get Key Here",
	callback = function()
    setclipboard("https://jnkie.com/get-key/pleiadex")
    v4:Notify({
			title = "Link Copied",
			content = "Link has been copied to your clipboard!",
			duration = 5
		})
end
})
v5:CreateButton({
	name = "Join Discord Server",
	description = "Join the Pleiadex Discord server for updates, support, and announcements.",
	callback = function()
    setclipboard("https://discord.gg/USNPq8XkMS")
    v4:Notify({
			title = "Link Copied",
			content = "The Invite Link has been copied to your clipboard!",
			duration = 5
		})
end
})
local v9 = (function()
    local _isfile = isfile

    if _isfile then
        _isfile = isfile("PleiadexKey.txt")
    end

    if _isfile then
        return readfile("PleiadexKey.txt")
    end

    return nil
end)()
if v9 then
    v7:Set(v9)
    s1 = v9
    v4:Notify({
		title = "Saved Key Found",
		content = "Validating saved key...",
		duration = 3
	})

    local ok, result = pcall(v2.check_key, s1)

    if not ok then
        local v12 = "Could not validate the saved key: " .. tostring(result)

        v4:Notify({
			title = "Validation Error",
			content = v12,
			duration = 5
		})
    elseif result and result.valid then
        getgenv().SCRIPT_KEY = s1
        v4:Notify({
			title = "Success",
			content = "Saved key was valid! Redirecting...",
			duration = 5
		})

        local ok3, result3 = pcall(function()
            loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/e92454125e152b05a012e312ab07c54822a8bad8f9c999d17ef690df232a54d7/download"))()
        end)

        if not ok3 then
            local v15 = "The Blair script could not be loaded: " .. tostring(result3)

            v4:Notify({
				title = "Load Error",
				content = v15,
				duration = 5
			})
        end

        task.wait(2)
        v4:Unload()
    else
        (function()
            if isfile("PleiadexKey.txt") then
                pcall(function()
                    delfile("PleiadexKey.txt")
                end)
            end
        end)()
        v4:Notify({
			title = "Invalid Key",
			content = "Saved key was invalid. Get a new key.",
			duration = 5
		})
    end
end
