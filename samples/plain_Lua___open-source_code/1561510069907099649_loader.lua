local games = {
    [7211666966] = {
        name = "Tower Of Jump",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/TOJ"
    },
    [89469502395769] = {
        name = "Kick a Lucky Block",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/KALB"
    },
    [5496455308] = {
        name = "Tower FL",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/TowerFL"
    },
    [134208374070897] = {
        name = "Monochrome",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/Monochrome"
    },
    [138381251771774] = {
        name = "Drain the Lake",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/dtl"
    },
    [124216119978534] = {
        name = "Ride a Pet",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/RideAPet"
    },
    [126987974021910] = {
        name = "Illegal Soccer",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/IllegalSoccer"
    },
    [71704434889758] = {
        name = "Drive A Kukirin!",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/DriveAKukirin"
    },
    [118805555015549] = {
        name = "+1 Loot To Forge",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/LootToForge"
    }, 
    [118915549367482] = {
        name = "Dont Wake The Brainrots",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/dont%20wake%20the%20brainrots"
    },
    [136801880565837] = {
        name = "[FPS] Flick",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/flick"
    },
    [136407404714539] = {
        name = "Find the Brainrot [256]",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/findbrainrots"
    },
    [120135584963579] = {
        name = "Don't Steal the Bubu",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/dstb"
    },
    [118614517739521] = {
        name = "Blind Shot",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/blindshot"
    },
    [18799085098] = {
        name = "Hide or Die!",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/hideordie"
    },
    [130594398886540] = {
        name = "Garden Horizons",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/garden"
    },
    [131623223084840] = {
        name = "Escape Tsunami For Brainrots!",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/etfb"
    },
    [86362492050446] = {
        name = "Escape Tsunami For Brainrots!",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/etfb"
    },
    [111917342868480] = {
        name = "Escape Tsunami For Brainrots - Trading Plaza",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/eftb2"
    },
    [123960881422056] = {
        name = "Escape Tsunami For Brainrots - Arena",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub1/refs/heads/main/flick1"
    },
    [137629155365661] = {
        name = "Escape Tsunami For Brainrots!",
        url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/etfb"
    }
}

local StarterGui = game:GetService("StarterGui")
local currentPlaceId = game.PlaceId
local gameData = games[currentPlaceId]

local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title or "Mystrix Hub",
        Text = text,
        Duration = duration or 5,
    })
end

if gameData then
    local urlToLoad = gameData.url
    
    if currentPlaceId == 123960881422056 then
   
        local isFishing = false
        pcall(function()
            isFishing = workspace:WaitForChild("GameObjects", 5)
                :WaitForChild("PlaceSpecific", 5)
                :WaitForChild("tsunami_arena", 5)
                :WaitForChild("FishingArenaMap", 5) ~= nil
        end)
        if isFishing then
            urlToLoad = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub1/refs/heads/main/TOJ1"
        else
      
            local isMining = false
            pcall(function()
                isMining = workspace:WaitForChild("GameObjects", 5)
                    :WaitForChild("PlaceSpecific", 5)
                    :WaitForChild("tsunami_arena", 5)
                    :WaitForChild("MiningArenaMap", 5) ~= nil
            end)
            if isMining then
                urlToLoad = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub1/refs/heads/main/Blindshot"
            end
        end
    end

    notify("Mystrix Hub", "Loading script: " .. gameData.name .. ". Please wait", 3)
    
    local success, err = pcall(function()
        local scriptContent = game:HttpGet(urlToLoad)
        loadstring(scriptContent)()
    end)
    
    if success then
        notify("Mystrix Hub", "Script loaded successfully!", 3)
    else
        notify("Mystrix Hub", "Error loading script:\n" .. tostring(err), 8)
    end
else
    notify("Mystrix Hub", "Game not supported!\nPlace ID: " .. tostring(currentPlaceId) .. " Join our Discord for support: https://discord.gg/46JkThWjPB", 10)
end
