-- This file was generated at discord.gg/syncrypt

local v201 = game:GetService("Players")
local v202 = game:GetService("TweenService")
local up26 = v202
v202 = v201.LocalPlayer
local up27 = "[https://link-target.net/9156048/DQMbizAvcbFu](https://link-target.net/9156048/DQMbizAvcbFu)"
local v203 = {"SUNRISEIOhjsad9guioh2983787hySDCC!"}
local up28
local v209 = function(arg5_1, arg5_2, arg5_3)
    local v86, v87
    v86, v87 = arg5_3, "Instance"
    v87 = (Instance.new(arg5_1))
    local v92 = pairs
    for v90, v93 in v92(arg5_2) do
        v92 = v93
        v87[v90] = v92
    end
    v87.Parent = v86
    return v87
end
local v205 = function(arg6_1)
    local v94, v95
    v94, v95 = "ipairs", arg6_1
    local v96 = ipairs
    for v99, v100 in v96(up28) do
        if (v100 == v95) then
            v96 = true
            return v96
        end
    end
    return false
end
up28 = v203
local up29 = v205
local up30 = v209
local v212 = up30("ScreenGui", {["Name"] = "KeySystem", ["ResetOnSpawn"] = false, ["IgnoreGuiInset"] = true}, v202:WaitForChild("PlayerGui"))
local up31 = v212
v212 = up30
local v220 = UDim2.fromScale(1, 1)
local v223 = Color3.fromRGB(232, 235, 241)
v212("Frame", {["Size"] = v220, ["BackgroundColor3"] = v223, ["BorderSizePixel"] = 0, ["ZIndex"] = 1}, up31)
v212 = up30
v220 = UDim2.fromOffset(390, 240)
v223 = UDim2.fromScale(0.5, 0.5)
local v227 = Vector2.new(0.5, 0.5)
local v230 = Color3.fromRGB(250, 251, 253)
local v208 = v212("Frame", {["Size"] = v220, ["Position"] = v223, ["AnchorPoint"] = v227, ["BackgroundColor3"] = v230, ["BorderSizePixel"] = 0, ["ZIndex"] = 2}, up31)
local up32 = v208
v208 = up30
local v222 = UDim.new(0, 18)
v208("UICorner", {["CornerRadius"] = v222}, up32)
v208 = up30
v222 = Color3.fromRGB(215, 219, 228)
v208("UIStroke", {["Color"] = v222, ["Thickness"] = 1}, up32)
v208 = up30
v222 = UDim2.fromOffset(64, 4)
local v224 = UDim2.fromOffset(24, 0)
local v226 = Color3.fromRGB(70, 135, 255)
local v210 = v208("Frame", {["Size"] = v222, ["Position"] = v224, ["BackgroundColor3"] = v226, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v208 = up30
v223 = UDim.new(0, 4)
v208("UICorner", {["CornerRadius"] = v223}, v210)
v208 = up30
v223 = UDim2.fromOffset(44, 44)
v227 = UDim2.fromOffset(24, 22)
v230 = Color3.fromRGB(232, 240, 255)
local v213 = v208("Frame", {["Size"] = v223, ["Position"] = v227, ["BackgroundColor3"] = v230, ["BorderSizePixel"] = 0, ["ZIndex"] = 3}, up32)
v208 = up30
v224 = UDim.new(0, 13)
v208("UICorner", {["CornerRadius"] = v224}, v213)
v208 = up30
v226 = UDim2.fromScale(1, 1)
v230 = Enum.Font.GothamBold
local v237 = Color3.fromRGB(70, 125, 245)
v208("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v226, ["Font"] = v230, ["Text"] = "\226\156\147", ["TextColor3"] = v237, ["TextSize"] = 20, ["ZIndex"] = 4}, v213)
v208 = up30
v226 = UDim2.new(1, -90, 0, 24)
local v233 = UDim2.fromOffset(80, 22)
local v234 = Enum.Font.GothamBold
local v239 = Color3.fromRGB(28, 31, 38)
local v242 = Enum.TextXAlignment.Left
v208("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v226, ["Position"] = v233, ["Font"] = v234, ["Text"] = "Verify Access", ["TextColor3"] = v239, ["TextSize"] = 17, ["TextXAlignment"] = v242, ["ZIndex"] = 3}, up32)
v208 = up30
v226 = UDim2.new(1, -90, 0, 18)
v233 = UDim2.fromOffset(80, 47)
v234 = Enum.Font.Gotham
v239 = Color3.fromRGB(130, 135, 145)
v242 = Enum.TextXAlignment.Left
v208("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v226, ["Position"] = v233, ["Font"] = v234, ["Text"] = "Enter your key to unlock the script.", ["TextColor3"] = v239, ["TextSize"] = 10, ["TextXAlignment"] = v242, ["ZIndex"] = 3}, up32)
v208 = up30
v226 = UDim2.new(1, -48, 0, 15)
v233 = UDim2.fromOffset(24, 76)
v234 = Enum.Font.GothamBold
v239 = Color3.fromRGB(100, 105, 115)
v242 = Enum.TextXAlignment.Left
v208("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v226, ["Position"] = v233, ["Font"] = v234, ["Text"] = "ACCESS KEY", ["TextColor3"] = v239, ["TextSize"] = 8, ["TextXAlignment"] = v242, ["ZIndex"] = 3}, up32)
v208 = up30
v224 = UDim2.new(1, -48, 0, 39)
v226 = UDim2.fromOffset(24, 92)
v233 = Color3.fromRGB(242, 244, 248)
local v236 = Enum.Font.Gotham
local v241 = Color3.fromRGB(155, 159, 168)
local v248 = Color3.fromRGB(35, 38, 45)
local v219 = v208("TextBox", {["Size"] = v224, ["Position"] = v226, ["BackgroundColor3"] = v233, ["BorderSizePixel"] = 0, ["Font"] = v236, ["PlaceholderText"] = "Paste your key here...", ["PlaceholderColor3"] = v241, ["Text"] = "", ["TextColor3"] = v248, ["TextSize"] = 11, ["ClearTextOnFocus"] = false, ["ZIndex"] = 3}, up32)
local up33 = v219
v219 = up30
v227 = UDim.new(0, 9)
v219("UICorner", {["CornerRadius"] = v227}, up33)
v219 = up30
v227 = Color3.fromRGB(218, 221, 229)
v219("UIStroke", {["Color"] = v227, ["Thickness"] = 1}, up33)
v219 = function(arg7_1, arg7_2, arg7_3, arg7_4)
    local v101, v102, v110, v111, v112, v113, v115, v116, v117, v118, v119, v120, v121, v122
    v101, v102 = 1901981926261, arg7_1
    local up1 = arg7_4
    local v103 = up30
    local v107 = UDim2.fromOffset
    v101, v113, v110 = 36, "\237\248\247\153\251\156\162\213", 146423595076
    local v106 = v107(arg7_3, v101)
    local v109 = UDim2.fromOffset(arg7_2, 141)
    v112, v113 = v103, v103
    local v114 = up1
    v110 = v114
    if v114 then
        v110 = (Color3.fromRGB(70, 125, 245))
    end
    v111, v103 = v110, v112
    if not (v110) then
        v111 = (Color3.fromRGB(238, 240, 244))
    end
    v119, v103, v116, v117, v120, v115 = 13781374818577, v113, "zD\211xB\252\225\1635\019\130N\004\162'", 32124270344815, 28840459252853, ";{\147\024\193\030g@?j\005\189\148\006\014"
    v119 = Enum.Font.GothamBold
    local v123 = up1
    v122, v121, v120 = v103, v123, v103
    if v123 then
        v121 = (Color3.fromRGB(255, 255, 255))
    end
    v118, v103 = v121, v122
    if not (v121) then
        v118 = (Color3.fromRGB(75, 80, 90))
    end
    local v129 = v120("TextButton", {["Size"] = v106, ["Position"] = v109, ["BackgroundColor3"] = v111, ["BorderSizePixel"] = 0, ["AutoButtonColor"] = false, ["Font"] = v119, ["Text"] = v102, ["TextColor3"] = v118, ["TextSize"] = 9, ["ZIndex"] = 3}, up32)
    local up2 = v129
    v103 = up30
    v101 = UDim.new(0, 9)
    v103("UICorner", {["CornerRadius"] = v101}, up2)
    if (not up1) then
        v103 = up30
        v101 = Color3.fromRGB (215, 219, 228)
        v103("UIStroke", {["Color"] = v101, ["Thickness"] = 1}, up2)
    end
    up2.MouseEnter:Connect(function()
        local v163, v171
        local v157 = up26
        local v158 = up2
        local v159 = TweenInfo.new(.15)
        local v161 = v157
        local v164 = up1
        local v162 = v164
        if v164 then
            v162 = (Color3.fromRGB(88, 140, 255))
        end
        local v160 = v162
        if not (v162) then
            v160 = (Color3.fromRGB(226, 229, 235))
        end
        v171, v163, v157 = "Create", {["BackgroundColor3"] = v160}, v161
        v157:Create(v158, v159, v163):Play()
        return
    end)
    up2.MouseLeave:Connect(function()
        local v177, v178, v179, v187
        local v172 = up26
        local v173 = up2
        local v175 = TweenInfo.new(.15)
        local v180 = up1
        v177, v178 = v172, v180
        if v180 then
            v178 = (Color3.fromRGB(70, 125, 245))
        end
        local v176 = v178
        if not (v178) then
            v176 = (Color3.fromRGB(238, 240, 244))
        end
        v179, v172, v187 = {["BackgroundColor3"] = v176}, v177, "Create"
        v172:Create(v173, v175, v179):Play()
        return
    end)

    return up2
end
local v221 = v219("COPY LINK", 24, 165, false)
v220 = v219("VERIFY KEY", 201, 165, true)
v222 = up30
local v235 = UDim2.new(1, -48, 0, 18)
v237 = UDim2.fromOffset(24, 183)
local v238 = Enum.Font.Gotham
local v243 = Color3.fromRGB(235, 75, 90)
local v245 = Enum.TextXAlignment.Left
v223 = v222("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v235, ["Position"] = v237, ["Font"] = v238, ["Text"] = "", ["TextColor3"] = v243, ["TextSize"] = 9, ["TextXAlignment"] = v245, ["ZIndex"] = 3}, up32)
local up34 = v223
v223 = up30
v236 = UDim2.new(1, -48, 0, 15)
v238 = UDim2.fromOffset(24, 211)
v239 = Enum.Font.Gotham
local v244 = Color3.fromRGB(170, 174, 182)
local v246 = Enum.TextXAlignment.Left
v223("TextLabel", {["BackgroundTransparency"] = 1, ["Size"] = v236, ["Position"] = v238, ["Font"] = v239, ["Text"] = "SECURE KEY SYSTEM  \226\128\162  READY", ["TextColor3"] = v244, ["TextSize"] = 7, ["TextXAlignment"] = v246, ["ZIndex"] = 3}, up32)
v224 = function(arg8_1, arg8_2)
    local v132, v133
    up34.Text = arg8_1
    v132, v133 = up34, arg8_2
    if arg8_2 then
        v133 = (Color3.fromRGB(45, 175, 105))
    end
    local v131 = v133
    if not (v133) then
        v131 = (Color3.fromRGB(235, 75, 90))
    end
    v132.TextColor3 = v131
    return
end
local up35 = v224
v224 = v221.MouseButton1Click
v226 = function()
    if setclipboard then
        setclipboard(up27)
        up35("Link copied to clipboard.", true)
    else
        up35("Clipboard not supported.", false)
    end
    return
end
v224:Connect(v226)
v224 = v220.MouseButton1Click
v226 = function()
    local v155 = up29(up33.Text)
    if v155 then
        up35("Key verified. Loading...", true)
        task.wait (.6)
        up31:Destroy()
    else
        up35("Invalid key.", false)
    end
    return
end
v224:Connect(v226)

return
