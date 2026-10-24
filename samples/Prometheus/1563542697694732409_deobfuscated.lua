-- This file was generated at discord.gg/syncrypt

local v201 = game:GetService("Players")
local v202 = game:GetService("TweenService")
local up26 = v202
v202 = v201.LocalPlayer
local up27 = "https://direct-link.net/6243065/YOy6U25jWLOb"
local v203 = {"IJSFHGODSFIJHOIJ@#&*()"}
local up28
local v205 = function(arg7_1)
    local v119 = ipairs
    local v120 = arg7_1
    for v123, v124 in v119(up28) do
        if (v124 == v120) then
            v119 = true
            return v119
        end
    end
    return false
end
up28 = v203
local v210 = function(arg8_1, arg8_2, arg8_3)
    local v126 = Instance
    local v130 = arg8_3
    v126 = v126.new(arg8_1)
    local v125 = v126
    local v131 = pairs
    for v128, v132 in v131(arg8_2) do
        v131 = v132
        v125[v128] = v131
    end
    v125.Parent = v130
    return v125
end
local up29 = v205
local up30 = v210
local v208 = up30("ScreenGui", {["Name"] = "KeySystem", ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true}, v202:WaitForChild("PlayerGui"))
local up31 = v208
v208 = up30
local v220 = UDim2.fromScale(1, 1)
local v222 = Color3.fromRGB(8, 8, 10)
v208("Frame", {["Size"] = v220, ["BackgroundColor3"] = v222, ["BackgroundTransparency"] = .1, ["BorderSizePixel"] = 0, ["ZIndex"] = 1}, up31)
v208 = up30
v220 = UDim2.fromOffset(365, 225)
v222 = UDim2.fromScale(0.5, 0.5)
local v227 = Vector2.new(0.5, 0.5)
local v231 = Color3.fromRGB(18, 18, 21)
local v209 = v208("Frame", {["Size"] = v220, ["Position"] = v222, ["AnchorPoint"] = v227, ["BackgroundColor3"] = v231, ["BorderSizePixel"] = 0, ["ZIndex"] = 2}, up31)
local up32 = v209
v209 = up30
local v223 = UDim.new(0, 9)
v209("UICorner", {["CornerRadius"] = v223}, up32)
v209 = up30
v223 = Color3.fromRGB(65, 48, 35)
v209("UIStroke", {["Color"] = v223, ["Thickness"] = 1}, up32)
v209 = up30
v223 = UDim2.new(1, 0, 0, 2)
local v224 = Color3.fromRGB(255, 145, 45)
v209("Frame", {["Size"] = v223, ["BackgroundColor3"] = v224, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v223 = UDim2.fromOffset(7, 7)
v224 = UDim2.fromOffset(24, 25)
local v226 = Color3.fromRGB(255, 145, 45)
local v211 = v209("Frame", {["Size"] = v223, ["Position"] = v224, ["BackgroundColor3"] = v226, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v222 = UDim.new(1, 0)
v209("UICorner", {["CornerRadius"] = v222}, v211)
v209 = up30
v227 = UDim2.new(1, -55, 0, 25)
v231 = UDim2.fromOffset(42, 16)
local v233 = Enum.Font.GothamBold
local v238 = Color3.fromRGB(245, 245, 247)
local v241 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Position"] = v231, ["Font"] = v233, ["Text"] = "Access Required", ["TextColor3"] = v238, ["TextSize"] = 17, ["TextXAlignment"] = v241, ["ZIndex"] = 3}, up32)
v209 = up30
v227 = UDim2.new(1, -48, 0, 18)
v231 = UDim2.fromOffset(24, 48)
v233 = Enum.Font.Gotham
v238 = Color3.fromRGB(145, 145, 152)
v241 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Position"] = v231, ["Font"] = v233, ["Text"] = "Enter your key below to continue.", ["TextColor3"] = v238, ["TextSize"] = 11, ["TextXAlignment"] = v241, ["ZIndex"] = 3}, up32)
v209 = up30
v222 = UDim2.new(1, -48, 0, 40)
v227 = UDim2.fromOffset(24, 77)
v231 = Color3.fromRGB(11, 11, 13)
local v235 = Enum.Font.Gotham
local v240 = Color3.fromRGB(105, 105, 112)
local v247 = Color3.fromRGB(240, 240, 242)
local v213 = v209("TextBox", {["Size"] = v222, ["Position"] = v227, ["BackgroundColor3"] = v231, ["BorderSizePixel"] = 0, ["Font"] = v235, ["PlaceholderText"] = "Paste access key...", ["PlaceholderColor3"] = v240, ["Text"] = "", ["TextColor3"] = v247, ["TextSize"] = 12, ["ClearTextOnFocus"] = false, ["ZIndex"] = 3}, up32)
local up33 = v213
v213 = up30
v224 = UDim.new(0, 7)
v213("UICorner", {["CornerRadius"] = v224}, up33)
v213 = up30
v224 = Color3.fromRGB(58, 48, 40)
v213("UIStroke", {["Color"] = v224, ["Thickness"] = 1}, up33)
v213 = function(arg9_1, arg9_2, arg9_3, arg9_4)
    local v133, v134, v138, v139, v140, v141, v144, v145, v147, v150, v151, v153, v154
    v133, v134 = "\181m20\151\239|\235kc", arg9_1
    local up1 = arg9_4
    local v135 = up30
    v138, v139, v140, v141 = 4414755735559, "v\195\244\176", 5361739139520, "X\150\0281\176£\n\247\243"
    local v142 = UDim2.fromOffset
    v140, v145 = 37, "\177{\145\\\169Q\197\192"
    v141 = v142(arg9_3, v140)
    v139 = UDim2.fromOffset(arg9_2, 130)
    v138 = v135
    local v146 = up1
    v145, v133 = v135, v146
    if v146 then
        v133 = (Color3.fromRGB(255, 145, 45))
    end
    v144, v135 = v133, v138
    if not (v133) then
        v144 = (Color3.fromRGB(26, 26, 30))
    end
    v135, v147, v151 = v145, "\211Tp\248H\252\195W§\016_E\018C", 1848209113948
    v151 = Enum.Font.GothamBold
    v154, v153 = 25777985433315, "S\216g\031"
    v154 = v135
    local v152 = v135
    local v155 = up1
    v153 = v155
    if v155 then
        v153 = (Color3.fromRGB(20, 15, 10))
    end
    v150, v135 = v153, v154
    if not (v153) then
        v150 = (Color3.fromRGB(205, 205, 210))
    end
    local v161 = v152("TextButton", {["Size"] = v141, ["Position"] = v139, ["BackgroundColor3"] = v144, ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Font"] = v151, ["Text"] = v134, ["TextColor3"] = v150, ["TextSize"] = 10, ["ZIndex"] = 3}, up32)
    local up2 = v161
    v135 = up30
    v140 = UDim.new(0, 7)
    v135("UICorner", {["CornerRadius"] = v140}, up2)
    v135 = up30
    v145 = up1
    v139, v140 = v145, v135
    if v145 then
        v139 = (Color3.fromRGB(255, 165, 80))
    end
    v135, v141 = v135, v139
    if not (v139) then
        v141 = (Color3.fromRGB(55, 55, 61))
    end
    v140("UIStroke", {["Color"] = v141, ["Thickness"] = 1}, up2)
    v135 = up2.MouseEnter
    local v136 = function()
        local v44, v45, v46, v47, v54
        local v40 = up26
        local v41 = up2
        local v43 = TweenInfo.new(.15)
        local v39 = v40
        local v48 = up1
        v45, v46 = v40, v48
        if v48 then
            v46 = (Color3.fromRGB(255, 165, 70))
        end
        v44, v40 = v46, v39
        if not (v46) then
            v44 = (Color3.fromRGB(40, 40, 45))
        end
        v54, v47, v40 = "Create", {["BackgroundColor3"] = v44}, v45
        v40:Create(v41, v43, v47):Play()
        return
    end
    v135:Connect(v136)
    v135 = up2.MouseLeave
    v136 = function()
        local v55, v56, v60, v61, v70
        v55, v56 = "TweenInfo", "#\245\182"
        local v57 = up26
        local v58 = up2
        local v63 = TweenInfo.new
        v56, v55 = "\213s\240\250\031\185\201\205TeD\197\226\162:\248", .15
        local v59 = v63(v55)
        v56, v61 = v57, v57
        local v64 = up1
        local v62 = v64
        if v64 then
            v62 = (Color3.fromRGB(255, 145, 45))
        end
        v57, v60 = v56, v62
        if not (v62) then
            v60 = (Color3.fromRGB(26, 26, 30))
        end
        v57, v63, v70 = v61, {["BackgroundColor3"] = v60}, "Create"
        v57:Create(v58, v59, v63):Play()
        return
    end
    v135:Connect(v136)

    return up2
end
local v219 = v213("COPY LINK", 24, 150, false)
local v221 = v213("VERIFY KEY", 191, 150, true)
v220 = up30
local v234 = UDim2.new(1, -48, 0, 20)
local v236 = UDim2.fromOffset(24, 178)
local v237 = Enum.Font.Gotham
local v242 = Color3.fromRGB(255, 100, 100)
local v244 = Enum.TextXAlignment.Left
v223 = v220("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v234, ["Position"] = v236, ["Font"] = v237, ["Text"] = "", ["TextColor3"] = v242, ["TextSize"] = 10, ["TextXAlignment"] = v244, ["ZIndex"] = 3}, up32)
local up34 = v223
local up35 = function(arg10_1, arg10_2)
    local v162, v164, v165
    up34.Text = arg10_1
    local v163 = up34
    v162, v165 = v163, v163
    local v166 = arg10_2
    if arg10_2 then
        v166 = (Color3.fromRGB(120, 220, 160))
    end
    v163, v164 = v162, v166
    if not (v166) then
        v164 = (Color3.fromRGB(255, 100, 100))
    end
    v165.TextColor3 = v164
    return
end
v227 = function()
    if setclipboard then
        setclipboard(up27)
        up35("Link copied to clipboard.", true)
    else
        up35("Clipboard not supported.", false)
    end
    return
end
v219.MouseButton1Click :Connect(v227)
v222 = v221.MouseButton1Click
v227 = function()
    local v187 = up29(up33.Text)
    if v187 then
        up35("Key verified. Loading...", true)
        task.wait (.6)
        up31:Destroy()
    else
        up35("Invalid key.", false)
    end
    return
end
v222:Connect(v227)

return
