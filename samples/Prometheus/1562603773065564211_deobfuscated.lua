-- This file was generated at discord.gg/syncrypt

local v230, v234, v243, v245, v247
local v250, v252, v254, v258, v260, v262, v263, v264
local v228 = game:IsLoaded()
if (not v228) then
    game.Loaded:Wait()
end
task.wait(1)
local v225 = game:GetService("Players").LocalPlayer
local v229 = (game.PrivateServerId ~= "")
local v256 = v229
if not (v229) then
    v256 = (game.PrivateServerOwnerId ~= 0)
end
v229 = (v256 or ((#(game:GetService("Players"):GetPlayers())) <= 1))
if v229 then
    v225:Kick("script error. no remotes found, use it on public server.")
else
    print("Public server detected. Script authorized.")
end
local v227 = _G
if v227["__WaguriLoader_Running"] then
    return
else
    v229 = _G
    v229.__WaguriLoader_Running = true
    v229 = function(...)
        return
    end
    print = v229
    warn = v229
    error = v229
    v230 = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    local up24 = v230
    v230 = up24
    v243 = Color3.fromHex("#FF69B4")
    v245 = Color3.fromHex("#14060E")
    v250 = Color3.fromHex("#FF69B4")
    v252 = Color3.fromHex("#FFD6EE")
    v258 = Color3.fromHex("#CC8BAA")
    v260 = Color3.fromHex("#1A0010")
    v262 = Color3.fromHex("#3D0A25")
    v263 = Color3.fromHex
    v254 = v230.AddTheme
    v264 = v263("#FF69B4")
    v254(v230, {["Name"] = "Waguri", ["Accent"] = v243, ["Dialog"] = v245, ["Outline"] = v250, ["Text"] = v252, ["Placeholder"] = v258, ["Background"] = v260, ["Button"] = v262, ["Icon"] = v264})
    up24:SetTheme("Waguri")
    v254 = up24:CreateWindow({["Title"] = "Waguri Loader", ["Icon"] = "heart", ["Author"] = "@waguriii.wow", ["Folder"] = "WaguriLoader", ["Transparent"] = true, ["Theme"] = "Waguri"})
    local up25 = v254
    up25:ToggleTransparency(true)
    v234 = up25:Tab({["Title"] = "Loader", ["Icon"] = "heart"})
    v234:Select()
    v234:Paragraph({["Title"] = "WAGURI LOADER", ["Desc"] = "\226\154\160\239\184\143 CHECK THIS SCRIPT! \226\154\160\239\184\143\n\nIf this script doesn't look like the one you usually use,\nDO NOT USE IT! It might be a stealer or fake.\n\n\226\156\133 Only use scripts from @waguriii.wow\n\226\156\133 Official TikTok: @waguriii.wow\n\226\156\133 Official Discord link below\n\n\240\159\140\184 Follow for more scripts!", ["Color"] = "Red", ["Thumbnail"] = "https://www.roblox.com/asset-thumbnail/image?assetId=79189100950243&width=420&height=420&format=png", ["ThumbnailSize"] = 200})
    local up26 = false
    v254 = v234.Button
    v247 = function()
        local v84
        if up26 then
            up24:Notify({["Title"] = "Already Running!", ["Content"] = "Waguri is already running!", ["Duration"] = 2, ["Icon"] = "check"})

            return
        else
            up24:Notify({["Title"] = "Loading Waguri", ["Content"] = "Please wait...", ["Duration"] = 2, ["Icon"] = "loader"})
            task.wait(0.5)
            pcall(function()
                up24:Destroy()
                return
            end)
            v84 = function()
                up25:Destroy()
                return
            end
            pcall(v84)
            v84 = function()
                up25:Close()
                return
            end
            pcall(v84)
            v84 = function()
                local v66, v67
                local v64 = ipairs
                local v70 = game:GetService("CoreGui")
                local v69 = v70.GetChildren
                for v72, v69 in v64(v69(v70)) do
                    v67 = (v69.Name == "WindUI")
                    v66 = v67
                    if not (v67) then
                        v66 = (v69.Name == "WaguriLoader")
                    end
                    if v66 then
                        v69:Destroy()
                    end
                end
                return
            end
            pcall(v84)
            task.spawn(function()
                local v77 = function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/waguri-mm2/Murder-mystery-2/refs/heads/main/Waguri-mm2-lol"))()
                    return
                end
                pcall(v77)

                return
            end)

            return
        end
    end
    v254(v234, {["Title"] = "Execute Script", ["Icon"] = "play", ["Callback"] = v247})
    v254 = v234.Button
    v247 = function()
        setclipboard("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/Waguriiiii/Murder-mystery-2/refs/heads/main/Waguri.lua\"))()")
        up24:Notify({["Title"] = "Copied!", ["Content"] = "Script link copied!", ["Duration"] = 2, ["Icon"] = "check"})
        return
    end
    v254(v234, {["Title"] = "Copy Script Link", ["Icon"] = "copy", ["Callback"] = v247})
    v254 = v234.Button
    v247 = function()
        setclipboard("https://discord.gg/")
        up24:Notify({["Title"] = "Discord Invite", ["Content"] = "Link copied to clipboard!", ["Duration"] = 2, ["Icon"] = "check"})
        return
    end
    v254(v234, {["Title"] = "Join Discord", ["Icon"] = "users", ["Callback"] = v247})
    v247 = function()
        setclipboard("@waguriii.wow")
        up24:Notify({["Title"] = "TikTok Copied!", ["Content"] = "@waguriii.wow - follow me!", ["Duration"] = 2, ["Icon"] = "heart"})
        return
    end
    v234:Button({["Title"] = "Follow TikTok", ["Icon"] = "heart", ["Callback"] = v247})
    v254 = v234.Button
    v247 = function()
        up24:Notify({["Title"] = "\226\156\133 Authentic Script", ["Content"] = "This is the official Waguri loader!", ["Duration"] = 3, ["Icon"] = "check"})
        return
    end
    v254(v234, {["Title"] = "Verify Authenticity", ["Icon"] = "shield", ["Callback"] = v247})
    task.spawn(function()
        task.wait(0.5)
        up24:Notify({["Title"] = "Waguri Loader", ["Content"] = "Protected script \226\128\162 Follow @waguriii.wow", ["Duration"] = 3, ["Icon"] = "heart"})
        return
    end)
    v254 = v234.Button
    v247 = function()
        local v165 = function()
            up24:Destroy()
            return
        end
        pcall(v165)
        v165 = function()
            up25:Destroy()
            return
        end
        pcall(v165)
        v165 = function()
            up25:Close()
            return
        end
        pcall(v165)
        v165 = function()
            local v46, v47
            local v44 = ipairs
            local v49 = game:GetService("CoreGui")
            local v50 = v49.GetChildren
            for v52, v50 in v44(v50(v49)) do
                v47 = (v50.Name == "WindUI")
                v46 = v47
                if not (v47) then
                    v46 = (v50.Name == "WaguriLoader")
                end
                if v46 then
                    v50:Destroy()
                end
            end
            return
        end
        pcall(v165)

        return
    end
    v254(v234, {["Title"] = "Close Loader", ["Icon"] = "x", ["Callback"] = v247})

    return
end
