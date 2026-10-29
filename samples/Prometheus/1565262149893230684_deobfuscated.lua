-- This file was generated at discord.gg/syncrypt

local v202 = game:GetService("Players")
local v203 = game:GetService("TweenService")
local up26 = v203
v203 = v202.LocalPlayer
local up27 = "https://direct-link.net/6243065/YOy6U25jWLOb"
local v208 = function(arg8_1, arg8_2, arg8_3)
    local v115 = Instance
    local v116 = arg8_3
    v115 = v115.new(arg8_1)
    local v114 = v115
    local v120 = pairs
    for v118, v121 in v120(arg8_2) do
        v120 = v121
        v114[v118] = v120
    end
    v114.Parent = v116
    return v114
end
local v205 = {"SAIGFJHADOSIGSXVVBGSNMDIO"}
local up28
local v210 = function(arg9_1)
    local v122, v123
    v122, v123 = arg9_1, "ipairs"
    local v124 = ipairs
    for v127, v128 in v124(up28) do
        if (v128 == v122) then
            v124 = true
            return v124
        end
    end
    return false
end
up28 = v205
local up29 = v210
local up30 = v208
local v209 = up30("ScreenGui", {["Name"] = "KeySystem", ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true}, v203:WaitForChild("PlayerGui"))
local up31 = v209
v209 = up30
local v224 = UDim2.fromScale(1, 1)
local v225 = Color3.fromRGB(5, 5, 8)
v209("Frame", {["Size"] = v224, ["BackgroundColor3"] = v225, ["BorderSizePixel"] = 0, ["ZIndex"] = 1}, up31)
v209 = up30
v225 = UDim2.fromOffset(350, 245)
local v228 = UDim2.fromScale(0.5, 0.5)
local v230 = Vector2.new(0.5, 0.5)
local v234 = Color3.fromRGB(13, 13, 18)
local v211 = v209("Frame", {["Name"] = "Main", ["Size"] = v225, ["Position"] = v228, ["AnchorPoint"] = v230, ["BackgroundColor3"] = v234, ["BorderSizePixel"] = 0, ["ZIndex"] = 2, ["ClipsDescendants"] = true}, up31)
local up32 = v211
v211 = up30
local v223 = UDim.new(0, 12)
v211("UICorner", {["CornerRadius"] = v223}, up32)
v211 = up30
v223 = Color3.fromRGB(130, 80, 255)
v211("UIStroke", {["Color"] = v223, ["Transparency"] = .55, ["Thickness"] = 1}, up32)
v211 = up30
v223 = UDim2.new(1, 0, 0, 3)
local v222 = UDim2.fromOffset(0, 0)
local v227 = Color3.fromRGB(145, 85, 255)
v211("Frame", {["Size"] = v223, ["Position"] = v222, ["BackgroundColor3"] = v227, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v211 = up30
v222 = UDim2.new(1, -32, 0, 32)
v227 = UDim2.fromOffset(16, 18)
v230 = Enum.Font.GothamBold
local v237 = Color3.fromRGB(245, 240, 255)
local v240 = Enum.TextXAlignment.Left
v211("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v222, ["Position"] = v227, ["Font"] = v230, ["Text"] = "KEY SYSTEM", ["TextColor3"] = v237, ["TextSize"] = 21, ["TextXAlignment"] = v240, ["ZIndex"] = 3}, up32)
v211 = up30
v223 = UDim2.fromOffset(7, 7)
v222 = UDim2.fromOffset(327, 29)
v227 = Color3.fromRGB(150, 90, 255)
local v212 = v211("Frame", {["Size"] = v223, ["Position"] = v222, ["BackgroundColor3"] = v227, ["BorderSizePixel"] = 0, ["ZIndex"] = 4}, up32)
v211 = up30
v225 = UDim.new(1, 0)
v211("UICorner", {["CornerRadius"] = v225}, v212)
v211 = up30
v228 = UDim2.new(1, -32, 0, 20)
v230 = UDim2.fromOffset(16, 48)
local v233 = Enum.Font.Gotham
local v238 = Color3.fromRGB(125, 125, 140)
local v241 = Enum.TextXAlignment.Left
v211("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v228, ["Position"] = v230, ["Font"] = v233, ["Text"] = "Enter your key below to continue", ["TextColor3"] = v238, ["TextSize"] = 12, ["TextXAlignment"] = v241, ["ZIndex"] = 3}, up32)
v211 = up30
v225 = UDim2.new(1, -32, 0, 43)
v228 = UDim2.fromOffset(16, 82)
v230 = Color3.fromRGB(20, 20, 27)
local v216 = v211("Frame", {["Size"] = v225, ["Position"] = v228, ["BackgroundColor3"] = v230, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v211 = up30
v222 = UDim.new(0, 7)
v211("UICorner", {["CornerRadius"] = v222}, v216)
v211 = up30
v222 = Color3.fromRGB(70, 65, 90)
v211("UIStroke", {["Color"] = v222, ["Transparency"] = 0.25, ["Thickness"] = 1}, v216)
v211 = up30
v227 = UDim2.new(1, -20, 1, 0)
v233 = UDim2.fromOffset(10, 0)
v234 = Enum.Font.Gotham
local v239 = Color3.fromRGB(85, 85, 100)
local v246 = Color3.fromRGB(235, 230, 245)
local v221 = v211("TextBox", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Position"] = v233, ["Font"] = v234, ["PlaceholderText"] = "Paste key here...", ["PlaceholderColor3"] = v239, ["Text"] = "", ["TextColor3"] = v246, ["TextSize"] = 13, ["ClearTextOnFocus"] = false, ["ZIndex"] = 4}, v216)
local up33 = v221
v221 = function(arg10_1, arg10_2, arg10_3, arg10_4)
    local v129, v130, v133, v134, v137, v143, v144, v146, v147, v148, v150
    v129, v130 = "S\216g\031k\002iTd\026", arg10_1
    local up1 = arg10_4
    local v131 = up30
    v133, v134 = "\016\242\132", 25777985433315
    local v136 = UDim2.new
    v137, v134 = 0, 0
    v129 = v136(v134, arg10_3, v137, 40)
    v137 = UDim2.fromOffset(arg10_2, 140)
    local v142 = up1
    v133 = v142
    if v142 then
        v133 = (Color3.fromRGB(140, 80, 255))
    end
    local v139 = v133
    if not (v133) then
        v139 = (Color3.fromRGB(22, 22, 29))
    end
    v131, v143, v147 = v131, "&S<.\216R\226\205\194\231\163s\161\249k\217\005\001\193\183Д", 2752548783361
    v133, v144 = 0, "\235\170\020P\129CA\203Q\231Fs\028y\185"
    v147 = Enum.Font.GothamBold
    v150, v148 = v131, v131
    local v151 = up1
    local v149 = v151
    if v151 then
        v149 = (Color3.fromRGB(255, 255, 255))
    end
    v146, v131 = v149, v150
    if not (v149) then
        v146 = (Color3.fromRGB(205, 200, 215))
    end
    local v157 = v148("TextButton", {["Size"] = v129, ["Position"] = v137, ["BackgroundColor3"] = v139, ["BackgroundTransparency"] = v133, ["AutoButtonColor"] = false, ["Font"] = v147, ["Text"] = v130, ["TextColor3"] = v146, ["TextSize"] = 13, ["ZIndex"] = 3}, up32)
    local up2 = v157
    v131 = up30
    v134 = UDim.new(0, 7)
    v131("UICorner", {["CornerRadius"] = v134}, up2)
    v131 = up30
    local v140 = up1
    v137 = v140
    if v140 then
        v137 = (Color3.fromRGB(180, 140, 255))
    end
    v129 = v137
    if not (v137) then
        v129 = (Color3.fromRGB(65, 60, 80))
    end
    v131("UIStroke", {["Color"] = v129, ["Transparency"] = .35, ["Thickness"] = 1}, up2)
    up2.MouseEnter:Connect(function()
        local v43, v51
        local v36 = up26
        local v38 = up2
        local v39 = TweenInfo.new(.15)
        local v44 = up1
        local v42 = v44
        if v44 then
            v42 = (Color3.fromRGB(160, 105, 255))
        end
        local v40 = v42
        if not (v42) then
            v40 = (Color3.fromRGB(31, 29, 40))
        end
        v36, v51 = v36, "Create"
        v51, v43 = v36.Create, {["BackgroundColor3"] = v40}
        v51 = v51(v36, v38, v39, v43)
        v51:Play()
        return
    end)
    up2.MouseLeave:Connect(function()
        local v59, v67
        local v52 = up26
        local v54 = up2
        local v55 = TweenInfo.new(.15)
        local v57 = v52
        local v60 = up1
        local v58 = v60
        if v60 then
            v58 = (Color3.fromRGB(140, 80, 255))
        end
        local v56 = v58
        if not (v58) then
            v56 = (Color3.fromRGB(22, 22, 29))
        end
        v59, v67, v52 = {["BackgroundColor3"] = v56}, "Create", v57
        v52:Create(v54, v55, v59):Play()
        return
    end)

    return up2
end
local v220 = v221("COPY LINK", 16, 145, false)
v224 = v221("UNLOCK", 169, 165, true)
v223 = up30
local v235 = UDim2.new(1, -32, 0, 22)
v237 = UDim2.fromOffset(16, 193)
v238 = Enum.Font.Gotham
v246 = Color3.fromRGB(255, 130, 130)
local v245 = Enum.TextXAlignment.Left
v225 = v223("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v235, ["Position"] = v237, ["Font"] = v238, ["Text"] = "", ["TextColor3"] = v246, ["TextSize"] = 12, ["TextXAlignment"] = v245, ["ZIndex"] = 3}, up32)
local up34 = v225
local up35 = function(arg11_1, arg11_2)
    local v160, v162, v163
    local v158 = arg11_1
    local v159 = up34
    local v161 = v159
    v162, v163 = v159, arg11_2
    if arg11_2 then
        v163 = (Color3.fromRGB(145, 240, 180))
    end
    v160, v159 = v163, v162
    if not (v163) then
        v160 = (Color3.fromRGB(255, 120, 120))
    end
    v161.TextColor3 = v160
    up34.Text = v158
    return
end
v227 = function()
    if setclipboard then
        setclipboard(up27)
        up35("Key link copied!", true)
    else
        up35("Clipboard not supported.", false)
    end
    return
end
v220.MouseButton1Click :Connect(v227)
v224.MouseButton1Click:Connect(function()
    local v184 = up29(up33.Text)
    if v184 then
        up35("Key accepted! Loading script...", true)
        task.wait (.6)
        up31:Destroy()
    else
        up35("Invalid key. Try again.", false)
    end
    return
end)

return
