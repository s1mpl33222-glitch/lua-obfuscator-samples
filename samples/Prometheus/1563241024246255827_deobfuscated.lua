-- This file was generated at discord.gg/syncrypt

local v201 = game:GetService("Players")
local v202 = game:GetService("TweenService")
local up26 = v202
v202 = v201.LocalPlayer
local up27 = "https://link-target.net/9156048/DQMbizAvcbFu"
local v203 = {"SUNRISEIOhjsad9guioh2983787hySDCC!"}
local v210 = function(arg4_1, arg4_2, arg4_3)
    local v80 = Instance
    local v82 = arg4_3
    v80 = v80.new(arg4_1)
    local v79 = v80
    local v85 = pairs
    for v83, v86 in v85(arg4_2) do
        v85 = v86
        v79[v83] = v85
    end
    v79.Parent = v82
    return v79
end
local up28 = v203
local v205 = function(arg5_1)
    local v88 = ipairs
    local v89 = arg5_1
    for v92, v93 in v88(up28) do
        if (v93 == v89) then
            v88 = true
            return v88
        end
    end
    return false
end
local up29 = v205
local up30 = v210
local v208 = up30("ScreenGui", {["Name"] = "KeySystem", ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true}, v202:WaitForChild("PlayerGui"))
local up31 = v208
v208 = up30
local v221 = UDim2.fromScale(1, 1)
local v220 = Color3.fromRGB(13, 13, 14)
v208("Frame", {["Size"] = v221, ["BackgroundColor3"] = v220, ["BorderSizePixel"] = 0, ["ZIndex"] = 1}, up31)
v208 = up30
v221 = UDim2.fromOffset(365, 225)
v220 = UDim2.fromScale(0.5, 0.5)
local v227 = Vector2.new(0.5, 0.5)
local v231 = Color3.fromRGB(20, 20, 21)
local v209 = v208("Frame", {["Size"] = v221, ["Position"] = v220, ["AnchorPoint"] = v227, ["BackgroundColor3"] = v231, ["BorderSizePixel"] = 0, ["ZIndex"] = 2}, up31)
local up32 = v209
v209 = up30
local v222 = UDim.new(0, 10)
v209("UICorner", {["CornerRadius"] = v222}, up32)
v209 = up30
v222 = Color3.fromRGB(42, 42, 44)
v209("UIStroke", {["Color"] = v222, ["Thickness"] = 1}, up32)
v209 = up30
v222 = UDim2.new(1, 0, 0, 2)
local v224 = Color3.fromRGB(255, 145, 45)
v209("Frame", {["Size"] = v222, ["BackgroundColor3"] = v224, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v222 = UDim2.fromOffset(8, 8)
v224 = UDim2.fromOffset(24, 24)
local v226 = Color3.fromRGB(255, 145, 45)
v209("Frame", {["Size"] = v222, ["Position"] = v224, ["BackgroundColor3"] = v226, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v222 = UDim.new(1, 0)
v209("UICorner", {["CornerRadius"] = v222}, up32:FindFirstChildOfClass("Frame"))
v209 = up30
v224 = UDim2.new(1, -55, 0, 25)
v226 = UDim2.fromOffset(42, 16)
v231 = Enum.Font.GothamBold
local v237 = Color3.fromRGB(240, 240, 240)
local v240 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v224, ["Position"] = v226, ["Font"] = v231, ["Text"] = "Access Required", ["TextColor3"] = v237, ["TextSize"] = 17, ["TextXAlignment"] = v240, ["ZIndex"] = 3}, up32)
v209 = up30
v224 = UDim2.new(1, -48, 0, 18)
v226 = UDim2.fromOffset(24, 48)
v231 = Enum.Font.Gotham
v237 = Color3.fromRGB(125, 125, 128)
v240 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v224, ["Position"] = v226, ["Font"] = v231, ["Text"] = "Enter your key below to continue.", ["TextColor3"] = v237, ["TextSize"] = 11, ["TextXAlignment"] = v240, ["ZIndex"] = 3}, up32)
v209 = up30
v222 = UDim2.new(1, -48, 0, 40)
v224 = UDim2.fromOffset(24, 77)
v226 = Color3.fromRGB(14, 14, 15)
local v234 = Enum.Font.Gotham
local v239 = Color3.fromRGB(90, 90, 94)
local v246 = Color3.fromRGB(235, 235, 235)
local v211 = v209("TextBox", {["Size"] = v222, ["Position"] = v224, ["BackgroundColor3"] = v226, ["BorderSizePixel"] = 0, ["Font"] = v234, ["PlaceholderText"] = "Paste access key...", ["PlaceholderColor3"] = v239, ["Text"] = "", ["TextColor3"] = v246, ["TextSize"] = 12, ["ClearTextOnFocus"] = false, ["ZIndex"] = 3}, up32)
local up33 = v211
v211 = up30
v220 = UDim.new(0, 7)
v211("UICorner", {["CornerRadius"] = v220}, up33)
v211 = up30
v220 = Color3.fromRGB(48, 48, 50)
v211("UIStroke", {["Color"] = v220, ["Thickness"] = 1}, up33)
v211 = function(arg6_1, arg6_2, arg6_3, arg6_4)
    local v94, v95, v96, v108, v109, v110, v111, v112, v113, v114
    v94, v95, v96 = 5361739139520, arg6_1, "v\195\244\176"
    local up1 = arg6_4
    local v98 = up30
    local v97 = UDim2.fromOffset(arg6_3, 37)
    v96 = UDim2.fromOffset(arg6_2, 130)
    local v107 = up1
    local v103 = v107
    if v107 then
        v103 = (Color3.fromRGB(255, 145, 45))
    end
    local v104 = v103
    if not (v103) then
        v104 = (Color3.fromRGB(30, 30, 31))
    end
    v112, v109 = 1848209113948, "q\180|\192\141\179\193\234\218\251j\n\0297j"
    v110, v98, v108 = 18350880022881, v98, "\211Tp\248H\252\195W§\016_E\018C"
    v112 = Enum.Font.GothamBold
    local v115 = v98
    local v116 = up1
    v114, v113 = v116, v98
    if v116 then
        v114 = (Color3.fromRGB(20, 20, 20))
    end
    v111, v98 = v114, v115
    if not (v114) then
        v111 = (Color3.fromRGB(190, 190, 192))
    end
    local v122 = v113("TextButton", {["Size"] = v97, ["Position"] = v96, ["BackgroundColor3"] = v104, ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Font"] = v112, ["Text"] = v95, ["TextColor3"] = v111, ["TextSize"] = 10, ["ZIndex"] = 3}, up32)
    local up2 = v122
    v98 = up30
    v94 = UDim.new(0, 7)
    v98("UICorner", {["CornerRadius"] = v94}, up2)
    up2.MouseEnter:Connect(function()
        local v171, v174, v181
        local v167 = up26
        local v168 = up2
        local v169 = TweenInfo.new(.15)
        local v172 = v167
        local v170 = v167
        local v175 = up1
        local v173 = v175
        if v175 then
            v173 = (Color3.fromRGB(255, 165, 70))
        end
        v171, v167 = v173, v170
        if not (v173) then
            v171 = (Color3.fromRGB(40, 40, 41))
        end
        v181, v167 = "Create", v172
        v181, v174 = v167.Create, {["BackgroundColor3"] = v171}
        v181 = v181(v167, v168, v169, v174)
        v181:Play()
        return
    end)
    up2.MouseLeave:Connect(function()
        local v182, v187, v189, v190, v197
        local v183 = up26
        local v184 = up2
        local v186 = TweenInfo.new(.15)
        local v188 = v183
        local v191 = up1
        v182, v189 = v183, v191
        if v191 then
            v189 = (Color3.fromRGB(255, 145, 45))
        end
        v183, v187 = v182, v189
        if not (v189) then
            v187 = (Color3.fromRGB(30, 30, 31))
        end
        v197, v183 = "Create", v188
        v197, v190 = v183.Create, {["BackgroundColor3"] = v187}
        v197 = v197(v183, v184, v186, v190)
        v197:Play()
        return
    end)

    return up2
end
local v213 = v211("COPY LINK", 24, 150, false)
local v219 = v211("VERIFY KEY", 191, 150, true)
local v223 = up30
local v233 = UDim2.new(1, -48, 0, 20)
local v235 = UDim2.fromOffset(24, 178)
local v236 = Enum.Font.Gotham
local v241 = Color3.fromRGB(255, 90, 90)
local v243 = Enum.TextXAlignment.Left
v221 = v223("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v233, ["Position"] = v235, ["Font"] = v236, ["Text"] = "", ["TextColor3"] = v241, ["TextSize"] = 10, ["TextXAlignment"] = v243, ["ZIndex"] = 3}, up32)
local up34
v222 = function(arg7_1, arg7_2)
    local v124, v125, v126
    up34.Text = arg7_1
    local v123 = up34
    v126, v124 = v123, v123
    local v127 = arg7_2
    if arg7_2 then
        v127 = (Color3.fromRGB(75, 205, 135))
    end
    v123, v125 = v124, v127
    if not (v127) then
        v125 = (Color3.fromRGB(255, 90, 90))
    end
    v126.TextColor3 = v125
    return
end
up34 = v221
local up35 = v222
v224 = function()
    if setclipboard then
        setclipboard(up27)
        up35("Link copied to clipboard.", true)
    else
        up35("Clipboard not supported.", false)
    end
    return
end
v213.MouseButton1Click :Connect(v224)
v222 = v219.MouseButton1Click
v224 = function()
    local v148 = up29(up33.Text)
    if v148 then
        up35("Key verified. Loading...", true)
        task.wait (.6)
        up31:Destroy()
    else
        up35("Invalid key.", false)
    end
    return
end
v222:Connect(v224)

return
