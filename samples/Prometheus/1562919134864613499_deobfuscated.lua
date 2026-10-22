-- This file was generated at discord.gg/syncrypt

local v201 = game:GetService("Players")
local v202 = game:GetService("TweenService")
local up26 = v202
v202 = v201.LocalPlayer
local up27 = "[https://link-target.net/9156048/DQMbizAvcbFu](https://link-target.net/9156048/DQMbizAvcbFu)"
local v203 = {"SUNRISEIOhjsad9guioh2983787hySDCC!"}
local up28 = v203
local v210 = function(arg5_1, arg5_2, arg5_3)
    local v115, v116
    v115, v116 = "Instance", arg5_3
    v115 = (Instance.new(arg5_1))
    local v121 = pairs
    for v119, v122 in v121(arg5_2) do
        v121 = v122
        v115[v119] = v121
    end
    v115.Parent = v116
    return v115
end
local v205 = function(arg6_1)
    local v123, v124
    v123, v124 = arg6_1, "ipairs"
    local v125 = ipairs
    for v128, v129 in v125(up28) do
        if (v129 == v123) then
            v125 = true
            return v125
        end
    end
    return false
end
local up29 = v205
local up30 = v210
local v208 = up30("ScreenGui", {["Name"] = "KeySystem", ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true}, v202:WaitForChild("PlayerGui"))
local up31 = v208
v208 = up30
local v220 = UDim2.fromScale(1, 1)
local v223 = Color3.fromRGB(7, 7, 10)
v208("Frame", {["Size"] = v220, ["BackgroundColor3"] = v223, ["BorderSizePixel"] = 0, ["ZIndex"] = 1}, up31)
v208 = up30
v220 = UDim2.fromOffset(390, 245)
v223 = UDim2.fromScale(0.5, 0.5)
local v227 = Vector2.new(0.5, 0.5)
local v230 = Color3.fromRGB(16, 15, 22)
local v209 = v208("Frame", {["Size"] = v220, ["Position"] = v223, ["AnchorPoint"] = v227, ["BackgroundColor3"] = v230, ["BorderSizePixel"] = 0, ["ZIndex"] = 2}, up31)
local up32 = v209
v209 = up30
local v222 = UDim.new(0, 14)
v209("UICorner", {["CornerRadius"] = v222}, up32)
v209 = up30
v222 = Color3.fromRGB(48, 43, 66)
v209("UIStroke", {["Color"] = v222, ["Thickness"] = 1}, up32)
v209 = up30
v222 = UDim2.new(1, 0, 0, 3)
local v224 = Color3.fromRGB(145, 85, 255)
v209("Frame", {["Size"] = v222, ["BackgroundColor3"] = v224, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v222 = UDim2.fromOffset(42, 42)
v224 = UDim2.fromOffset(24, 22)
local v226 = Color3.fromRGB(31, 24, 48)
local v211 = v209("Frame", {["Size"] = v222, ["Position"] = v224, ["BackgroundColor3"] = v226, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v223 = UDim.new(0, 11)
v209("UICorner", {["CornerRadius"] = v223}, v211)
v209 = up30
v223 = Color3.fromRGB(86, 57, 135)
v209("UIStroke", {["Color"] = v223, ["Thickness"] = 1}, v211)
v209 = up30
v227 = UDim2.fromScale(1, 1)
v226 = Enum.Font.GothamBold
local v236 = Color3.fromRGB(174, 125, 255)
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Font"] = v226, ["Text"] = "\226\156\166", ["TextColor3"] = v236, ["TextSize"] = 21, ["ZIndex"] = 4}, v211)
v209 = up30
v227 = UDim2.new(1, -85, 0, 25)
v230 = UDim2.fromOffset(78, 22)
local v233 = Enum.Font.GothamBold
local v238 = Color3.fromRGB(245, 243, 250)
local v241 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Position"] = v230, ["Font"] = v233, ["Text"] = "Key Verification", ["TextColor3"] = v238, ["TextSize"] = 17, ["TextXAlignment"] = v241, ["ZIndex"] = 3}, up32)
v209 = up30
v227 = UDim2.new(1, -85, 0, 20)
v230 = UDim2.fromOffset(78, 47)
v233 = Enum.Font.Gotham
v238 = Color3.fromRGB(135, 130, 145)
v241 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Position"] = v230, ["Font"] = v233, ["Text"] = "Unlock access to continue.", ["TextColor3"] = v238, ["TextSize"] = 11, ["TextXAlignment"] = v241, ["ZIndex"] = 3}, up32)
v209 = up30
v223 = UDim2.new(1, -48, 0, 42)
v227 = UDim2.fromOffset(24, 82)
v230 = Color3.fromRGB(10, 10, 14)
local v235 = Enum.Font.Gotham
local v240 = Color3.fromRGB(83, 79, 94)
local v247 = Color3.fromRGB(235, 232, 242)
local v212 = v209("TextBox", {["Size"] = v223, ["Position"] = v227, ["BackgroundColor3"] = v230, ["BorderSizePixel"] = 0, ["Font"] = v235, ["PlaceholderText"] = "Enter your access key", ["PlaceholderColor3"] = v240, ["Text"] = "", ["TextColor3"] = v247, ["TextSize"] = 12, ["ClearTextOnFocus"] = false, ["ZIndex"] = 3}, up32)
local up33 = v212
v212 = up30
v224 = UDim.new(0, 9)
v212("UICorner", {["CornerRadius"] = v224}, up33)
v212 = up30
v224 = Color3.fromRGB(48, 44, 58)
v212("UIStroke", {["Color"] = v224, ["Thickness"] = 1}, up33)
v212 = function(arg7_1, arg7_2, arg7_3, arg7_4)
    local v130, v131, v132, v134, v135, v141, v142, v145
    v130, v131, v132 = "\171\191\180\022\223#\212\199\181\244", arg7_1, 3289051891195
    local up1 = arg7_4
    local v133 = up30
    v134, v135 = 22498940365036, "\226\252&\r&\165\200\133\219\197"
    local v139 = UDim2.fromOffset
    v134, v142 = 38, "\158o\190\rG\222\007\248"
    v130 = v139(arg7_3, v134)
    local v138 = UDim2.fromOffset(arg7_2, 137)
    local v143 = up1
    v142 = v133
    v135 = v143
    if v143 then
        v135 = (Color3.fromRGB(132, 76, 230))
    end
    v133, v141 = v133, v135
    if not (v135) then
        v141 = (Color3.fromRGB(27, 25, 34))
    end
    v145, v135 = "\159(\017@8\134\211q\181\241\153U\186b\240", 0
    local v148 = Enum.Font.GothamBold
    local v152 = up1
    local v150 = v152
    if v152 then
        v150 = (Color3.fromRGB(255, 255, 255))
    end
    local v147 = v150
    if not (v150) then
        v147 = (Color3.fromRGB(185, 180, 195))
    end
    local v158 = v142("TextButton", {["Size"] = v130, ["Position"] = v138, ["BackgroundColor3"] = v141, ["BorderSizePixel"] = v135, ["AutoButtonColor"] = false, ["Font"] = v148, ["Text"] = v131, ["TextColor3"] = v147, ["TextSize"] = 10, ["ZIndex"] = 3}, up32)
    local up2 = v158
    v133 = up30
    v134 = UDim.new(0, 9)
    v133("UICorner", {["CornerRadius"] = v134}, up2)
    if (not up1) then
        v133 = up30
        v134 = Color3.fromRGB (48, 44, 58)
        v133("UIStroke", {["Color"] = v134, ["Thickness"] = 1}, up2)
    end
    v133 = up2.MouseEnter
    local v136 = function()
        local v49, v50, v52, v53, v55, v62
        local v47 = up26
        local v48 = up2
        v49, v50 = "TweenInfo", "gE\162"
        local v51 = TweenInfo.new(.15)
        v50, v53 = v47, v47
        local v56 = up1
        local v54 = v56
        if v56 then
            v54 = (Color3.fromRGB(153, 91, 250))
        end
        v52, v47 = v54, v50
        if not (v54) then
            v52 = (Color3.fromRGB(38, 35, 48))
        end
        v55, v47, v62 = {["BackgroundColor3"] = v52}, v53, "Create"
        v47:Create(v48, v51, v55):Play()
        return
    end
    v133:Connect(v136)
    v133 = up2.MouseLeave
    v136 = function()
        local v70, v78
        local v63 = up26
        local v65 = up2
        local v66 = TweenInfo.new(.15)
        local v68 = v63
        local v71 = up1
        local v69 = v71
        if v71 then
            v69 = (Color3.fromRGB(132, 76, 230))
        end
        local v67 = v69
        if not (v69) then
            v67 = (Color3.fromRGB(27, 25, 34))
        end
        v70, v78, v63 = {["BackgroundColor3"] = v67}, "Create", v68
        v63:Create(v65, v66, v70):Play()
        return
    end
    v133:Connect(v136)

    return up2
end
local v219 = v212("COPY LINK", 24, 165, false)
local v221 = v212("VERIFY KEY", 201, 165, true)
v220 = up30
local v234 = UDim2.new(1, -48, 0, 20)
v236 = UDim2.fromOffset(24, 185)
local v237 = Enum.Font.Gotham
local v242 = Color3.fromRGB(255, 95, 110)
local v244 = Enum.TextXAlignment.Left
v222 = v220("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v234, ["Position"] = v236, ["Font"] = v237, ["Text"] = "", ["TextColor3"] = v242, ["TextSize"] = 10, ["TextXAlignment"] = v244, ["ZIndex"] = 3}, up32)
local up34
v223 = function(arg8_1, arg8_2)
    local v160
    up34.Text = arg8_1
    local v159 = up34
    local v162 = v159
    local v161 = v159
    local v163 = arg8_2
    if arg8_2 then
        v163 = (Color3.fromRGB(92, 220, 155))
    end
    v160, v159 = v163, v161
    if not (v163) then
        v160 = (Color3.fromRGB(255, 95, 110))
    end
    v162.TextColor3 = v160
    return
end
up34 = v222
local up35 = v223
v223 = up30
v236 = UDim2.new(1, -48, 0, 15)
v238 = UDim2.fromOffset(24, 217)
local v239 = Enum.Font.Gotham
v247 = Color3.fromRGB(70, 66, 80)
local v246 = Enum.TextXAlignment.Left
v223("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v236, ["Position"] = v238, ["Font"] = v239, ["Text"] = "SECURE ACCESS  \226\128\162  KEY SYSTEM", ["TextColor3"] = v247, ["TextSize"] = 8, ["TextXAlignment"] = v246, ["ZIndex"] = 3}, up32)
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
v223 = v221.MouseButton1Click
v227 = function()
    local v184 = up29(up33.Text)
    if v184 then
        up35("Key verified. Loading...", true)
        task.wait (.6)
        up31:Destroy()
    else
        up35("Invalid key.", false)
    end
    return
end
v223:Connect(v227)

return
