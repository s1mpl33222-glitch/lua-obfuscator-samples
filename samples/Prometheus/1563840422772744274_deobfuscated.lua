-- This file was generated at discord.gg/syncrypt

local v201 = game:GetService("Players")
local v202 = game:GetService("TweenService")
local up26 = v202
v202 = v201.LocalPlayer
local up27 = "https://direct-link.net/6243065/YOy6U25jWLOb"
local v203 = {"SUNRISEIOhjsad9guioh2983787hySDCC!"}
local up28 = v203
local v210 = function(arg5_1, arg5_2, arg5_3)
    local v79, v80
    v79, v80 = "Instance", arg5_3
    v79 = (Instance.new(arg5_1))
    local v85 = pairs
    for v83, v86 in v85(arg5_2) do
        v85 = v86
        v79[v83] = v85
    end
    v79.Parent = v80
    return v79
end
local v205 = function(arg6_1)
    local v87, v88
    v87, v88 = arg6_1, "ipairs"
    local v89 = ipairs
    for v92, v93 in v89(up28) do
        if (v93 == v87) then
            v89 = true
            return v89
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
local v223 = Color3.fromRGB(10, 10, 12)
v208("Frame", {["Size"] = v220, ["BackgroundColor3"] = v223, ["BorderSizePixel"] = 0, ["ZIndex"] = 1}, up31)
v208 = up30
v220 = UDim2.fromOffset(350, 230)
v223 = UDim2.fromScale(0.5, 0.5)
local v227 = Vector2.new(0.5, 0.5)
local v230 = Color3.fromRGB(17, 17, 20)
local v209 = v208("Frame", {["Size"] = v220, ["Position"] = v223, ["AnchorPoint"] = v227, ["BackgroundColor3"] = v230, ["BorderSizePixel"] = 0, ["ZIndex"] = 2}, up31)
local up32 = v209
v209 = up30
local v221 = UDim.new(0, 14)
v209("UICorner", {["CornerRadius"] = v221}, up32)
v209 = up30
v221 = Color3.fromRGB(45, 45, 50)
v209("UIStroke", {["Color"] = v221, ["Thickness"] = 1}, up32)
v209 = up30
v221 = UDim2.new(0, 5, 1, 0)
local v224 = Color3.fromRGB(225, 55, 65)
v209("Frame", {["Size"] = v221, ["BackgroundColor3"] = v224, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v224 = UDim2.new(1, -45, 0, 28)
local v226 = UDim2.fromOffset(25, 18)
v230 = Enum.Font.GothamBold
local v237 = Color3.fromRGB(245, 245, 247)
local v240 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v224, ["Position"] = v226, ["Font"] = v230, ["Text"] = "KEY REQUIRED", ["TextColor3"] = v237, ["TextSize"] = 18, ["TextXAlignment"] = v240, ["ZIndex"] = 3}, up32)
v209 = up30
v224 = UDim2.new(1, -45, 0, 18)
v226 = UDim2.fromOffset(25, 44)
v230 = Enum.Font.Gotham
v237 = Color3.fromRGB(125, 125, 132)
v240 = Enum.TextXAlignment.Left
v209("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v224, ["Position"] = v226, ["Font"] = v230, ["Text"] = "Enter your key to unlock access", ["TextColor3"] = v237, ["TextSize"] = 11, ["TextXAlignment"] = v240, ["ZIndex"] = 3}, up32)
v209 = up30
v221 = UDim2.new(1, -50, 0, 43)
v224 = UDim2.fromOffset(25, 75)
v226 = Color3.fromRGB(11, 11, 13)
local v211 = v209("Frame", {["Size"] = v221, ["Position"] = v224, ["BackgroundColor3"] = v226, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v209 = up30
v223 = UDim.new(0, 9)
v209("UICorner", {["CornerRadius"] = v223}, v211)
v209 = up30
v223 = Color3.fromRGB(50, 50, 55)
v209("UIStroke", {["Color"] = v223, ["Thickness"] = 1}, v211)
v209 = up30
v227 = UDim2.new(1, -20, 1, 0)
v230 = UDim2.fromOffset(10, 0)
local v233 = Enum.Font.Gotham
local v238 = Color3.fromRGB(100, 100, 108)
local v242 = Color3.fromRGB(235, 235, 238)
local v213 = v209("TextBox", {["BackgroundTransparency"] = 1, ["Size"] = v227, ["Position"] = v230, ["Font"] = v233, ["PlaceholderText"] = "Enter access key...", ["PlaceholderColor3"] = v238, ["Text"] = "", ["TextColor3"] = v242, ["TextSize"] = 12, ["ClearTextOnFocus"] = false, ["ZIndex"] = 4}, v211)
local up33 = v213
v213 = function(arg7_1, arg7_2, arg7_3, arg7_4)
    local v94, v95, v96, v97, v103, v104, v105, v106, v108, v109, v110, v111, v112, v114, v115
    v94, v95 = "\239\212\021C\192{J\228\006 ", arg7_1
    local up1 = arg7_4
    v96, v97 = 26380217708540, "\006\240\195\246"
    local v98 = up30
    local v101 = UDim2.fromOffset
    v96, v106 = 38, "\171\027\024ڂ\149\210N"
    v94 = v101(arg7_3, v96)
    v97 = UDim2.fromOffset(arg7_2, 130)
    v106 = v98
    local v107 = up1
    v104, v103 = v107, v98
    if v107 then
        v104 = (Color3.fromRGB(215, 50, 60))
    end
    v105, v98 = v104, v103
    if not (v104) then
        v105 = (Color3.fromRGB(27, 27, 31))
    end
    v98, v109 = v106, "\162\144\140aq\143\190\193;ɼ\026Ec\160"
    v108, v112 = "\145\1428$\182\229]\244\138?.\163\136\186\"", 4414755735559
    v104, v110 = 0, 27917757379272
    v112 = Enum.Font.GothamBold
    v115, v114 = 33428813774030, "e~\164="
    local v113 = v98
    v115 = v98
    local v116 = up1
    v114 = v116
    if v116 then
        v114 = (Color3.fromRGB(255, 255, 255))
    end
    v111, v98 = v114, v115
    if not (v114) then
        v111 = (Color3.fromRGB(190, 190, 195))
    end
    local v122 = v113("TextButton", {["Size"] = v94, ["Position"] = v97, ["BackgroundColor3"] = v105, ["BorderSizePixel"] = v104, ["AutoButtonColor"] = false, ["Font"] = v112, ["Text"] = v95, ["TextColor3"] = v111, ["TextSize"] = 11, ["ZIndex"] = 3}, up32)
    local up2 = v122
    v98 = up30
    v96 = UDim.new(0, 9)
    v98("UICorner", {["CornerRadius"] = v96}, up2)
    v98 = up2.MouseEnter
    local v99 = function()
        local v160, v163, v170
        local v155 = up26
        local v157 = up2
        local v158 = TweenInfo.new(.15)
        local v159 = v155
        local v161 = v155
        local v164 = up1
        local v162 = v164
        if v164 then
            v162 = (Color3.fromRGB(235, 65, 75))
        end
        v160, v155 = v162, v159
        if not (v162) then
            v160 = (Color3.fromRGB(37, 37, 42))
        end
        v155, v163, v170 = v161, {["BackgroundColor3"] = v160}, "Create"
        v155:Create(v157, v158, v163):Play()
        return
    end
    v98:Connect(v99)
    v98 = up2.MouseLeave
    v99 = function()
        local v171, v176, v177, v179, v186
        local v172 = up26
        local v174 = up2
        local v175 = TweenInfo.new(.15)
        v171, v177 = v172, v172
        local v180 = up1
        local v178 = v180
        if v180 then
            v178 = (Color3.fromRGB(215, 50, 60))
        end
        v176, v172 = v178, v171
        if not (v178) then
            v176 = (Color3.fromRGB(27, 27, 31))
        end
        v186, v179, v172 = "Create", {["BackgroundColor3"] = v176}, v177
        v172:Create(v174, v175, v179):Play()
        return
    end
    v98:Connect(v99)

    return up2
end
local v219 = v213("COPY KEY LINK", 25, 145, false)
local v222 = v213("UNLOCK", 180, 145, true)
v220 = up30
local v234 = UDim2.new(1, -50, 0, 20)
local v236 = UDim2.fromOffset(25, 181)
v237 = Enum.Font.Gotham
v242 = Color3.fromRGB(225, 75, 80)
local v244 = Enum.TextXAlignment.Left
v221 = v220("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v234, ["Position"] = v236, ["Font"] = v237, ["Text"] = "", ["TextColor3"] = v242, ["TextSize"] = 11, ["TextXAlignment"] = v244, ["ZIndex"] = 3}, up32)
local up34 = v221
v223 = function(arg8_1, arg8_2)
    local v123, v125, v126
    up34.Text = arg8_1
    local v124 = up34
    v123, v126 = v124, v124
    local v127 = arg8_2
    if arg8_2 then
        v127 = (Color3.fromRGB(70, 200, 130))
    end
    v125, v124 = v127, v123
    if not (v127) then
        v125 = (Color3.fromRGB(225, 75, 80))
    end
    v126.TextColor3 = v125
    return
end
local up35 = v223
v227 = function()
    if setclipboard then
        setclipboard(up27)
        up35("Key link copied!", true)
    else
        up35("Clipboard not supported.", false)
    end
    return
end
v219.MouseButton1Click :Connect(v227)
v223 = v222.MouseButton1Click
v227 = function()
    local v148 = up29(up33.Text)
    if v148 then
        up35("Key accepted! Loading...", true)
        task.wait (.6)
        up31:Destroy()
    else
        up35("Invalid key.", false)
    end
    return
end
v223:Connect(v227)

return
