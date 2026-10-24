local v8 = game:GetService("HttpService")
local v9 = "https://roblox-key-manager--nanijia76.replit.app/source/J5sX7DZcdC-fFaSYRurArVcm"
local function v10()
    local v16 = 0 - 0
    while true do
        if v16 == (0 - 0) then
            local v26 = 0 + 0
            while true do
                if v26 == (0 - 0) then
                    if type(gethwid) == "function" then
                        local v28 = 518 - (114 + 404)
                        local v29
                        local v30
                        while true do
                            if (488 - (106 + 382)) == v28 then
                                v29, v30 = pcall(gethwid)
                                if v29 and (v30 ~= nil) and (v30 ~= "") then
                                    return tostring(v30)
                                end
                                break
                            end
                        end
                    end
                    return game:GetService("RbxAnalyticsService"):GetClientId()
                end
            end
        end
    end
end
local function v11()
    local v17, v18 = pcall(function()
        return v8:RequestAsync({
            ["Url"] = v9,
            ["Method"] = "GET",
            ["Headers"] = {
                ["X-Token"] = "XPkngsyxrtlaPmtr-XH94At7dcRYWULi",
                ["X-PlaceId"] = tostring(game.PlaceId),
                ["X-HWID"] = v10(),
            },
        })
    end)
    if not v17 then
        warn("Secure Source request failed:", v18)
        return nil
    end
    if not v18.Success then
        local v25 = 411 - (306 + 105)
        while true do
            if 0 == v25 then
                local v27 = 0 - 0
                while true do
                    if v27 == (427 - (166 + 261)) then
                        warn("Secure Source rejected the request:", v18.Body)
                        return nil
                    end
                end
            end
        end
    end
    return v18.Body
end
local v12 = v11()
if v12 then
    local v20 = 1080 - (1020 + 60)
    local v21
    local v22
    while true do
        if v20 == (507 - (289 + 218)) then
            v21, v22 = loadstring(v12)
            if v21 then
                v21()
            else
                warn(v22)
            end
            break
        end
    end
end
task.spawn(function()
    while true do
        local v23 = 1344 - (1213 + 131)
        local v24
        while true do
            if v23 == (0 + 0) then
                v24 = 0 + 0
                while true do
                    if v24 == (0 + 0) then
                        task.wait(34 - 24)
                        v11()
                        break
                    end
                end
                break
            end
        end
    end
end)
