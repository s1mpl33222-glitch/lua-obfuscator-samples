-- This file was generated at discord.gg/syncrypt

local spilledValues1 = {}
local unpackValues = unpack or table.unpack

local v1313, v1316, v1319, v1321, v1322, v1323, v1325, v1326, v1327, v1328, v1329, v1330, v1332, v1333, v1334, v1335

local v1338, v1339, v1340, v1341, v1342, v1343, v1344, v1345, v1346, v1347, v1348, v1349, v1350, v1351, v1352, v1355
local v1356, v1358, v1359, v1360, v1361
local v1362, v1363, v1364, v1368, v1369, v1370, v1371, v1372, v1373, v1374, v1375, v1376, v1377, v1378, v1380, v1381


local v1317 = getgenv().Key
if (v1317 ~= "Minarr") then
    return
else
    spilledValues1.value9 = Color3.fromRGB(255, 182, 193)
    spilledValues1.value10 = {"HumanoidRootPart"}
    v1327 = {["Hitpart"] = "HumanoidRootPart", ["Airpart"] = "HumanoidRootPart"}
    v1313 = {["Enabled"] = true, ["Lock Type"] = "Namecall", ["Prediction"] = .1, ["Parts"] = v1327, ["Offset"] = 0}
    v1321 = {["Jump Offset"] = 0, ["Fall Offset"] = 0}
    v1323 = {["Max Distance"] = 1000}
    v1325 = {["Enabled"] = true, ["Wall Check"] = true, ["KO Check"] = true, ["Forcefield Check"] = false, ["Team Check"] = false, ["Friend Check"] = false, ["Vehicle Check"] = false, ["Crew Check"] = false}
    spilledValues1.value1 = {["Enabled"] = true, ["Size"] = 150, ["Thickness"] = 2, ["Transparency"] = 0.5, ["Filled"] = false, ["Position"] = "Crosshair", ["CircleColor"] = spilledValues1.value9, ["SelectedParts"] = spilledValues1.value10, ["CurrentPart"] = "HumanoidRootPart", ["TargetAim"] = v1313, ["Offsets"] = v1321, ["SilentAim"] = v1323, ["Checks"] = v1325}
    local up80 = spilledValues1.value1
    spilledValues1.value3 = game:GetService("Players")
    local up81 = spilledValues1.value3
    spilledValues1.value4 = game:GetService("RunService")
    local up82 = spilledValues1.value4
    spilledValues1.value2 = game:GetService("UserInputService")
    local up83 = spilledValues1.value2
    spilledValues1.value6 = game:GetService("CoreGui")
    spilledValues1.value8 = game:GetService("GuiService")
    spilledValues1.value5 = game:GetService("HttpService")
    local up84 = spilledValues1.value5
    spilledValues1.value7 = game:GetService("TweenService")
    local up85 = spilledValues1.value7
    v1319 = game:GetService("Stats")
    local up86 = v1319
    v1319 = workspace.CurrentCamera
    local up87 = v1319
    v1319 = up81.LocalPlayer
    local up88 = v1319
    local up89 = "Minarr_Config.json"
    task.spawn(function()
        local v1235 = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/shakar60/RickWare.CC/refs/heads/main/Misc/Bypasses"))()
            return
        end
        pcall(v1235)

        return
    end)
    local up90
    spilledValues1.value9 = function()
        up90 = (loadstring(game:HttpGet("https://raw.githubusercontent.com/shakar60/scripts/refs/heads/main/Basic%20Drawing.lua"))())

        return
    end
    up90 = nil
    v1319 = (pcall(spilledValues1.value9)) and up90
    if v1319 then
        Drawing = up90
    end
    local up91 = function()
        pcall(function()
            writefile(up89, up84:JSONEncode(up80))

            return
        end)

        return
    end;
    (function()
        local v454, v455, v457, v460, v461
        local v453 = function()
            return isfile(up89)
        end
        local v456 = (pcall(v453)) and (isfile(up89))
        if v456 then
            v457 = pcall
            v455 = up84.JSONDecode
            v453 = up84
            v461 = readfile
            v456, v454 = v457(v455, v453, v461(up89))
            v455 = v456
            v456 = v455
            if v455 then
                v456 = ((type(v454)) == "table")
            end
            if v456 then
                v457 = pairs
                for v461, v460 in v457(v454) do
                    v457 = up80
                    v457[v461] = v460
                end
            end
        end
        return
    end)()
    local up92
    local up94 = "HumanoidRootPart"
    local up93 = (spilledValues1.value8:GetGuiInset())
    v1316 = RaycastParams.new()
    local up95 = v1316
    v1316 = up95
    v1322 = Enum.RaycastFilterType.Exclude
    v1316.FilterType = v1322
    v1321 = setmetatable({}, {["__mode"] = "v"})
    local up96 = v1321
    v1321 = {["Crosshair"] = nil}
    local up97 = v1321
    v1323 = function()
        local v464, v466, v468, v469, v471, v472, v474, v476, v477, v478, v480, v481, v482, v483, v485
        local v463 = up88
        if (not v463["PlayerGui"]) then
            return
        else
            v468 = ipairs
            v464 = up88.PlayerGui
            v466 = v464.GetChildren
            for v472, v466 in v468(v466(v464)) do
                v469 = v466.ClassName
                if not ((v469 ~= "ScreenGui"))then
                    v474 = v466.GetChildren
                    v468 = ipairs
                    for v471, v474 in v468(v474(v466)) do
                        v480 = (v474.ClassName ~= "Frame")
                        v481 = v480
                        if not (v480) then
                            v481 = ((v474.Name:lower()) ~= "aim")
                        end
                        if not (v481) then
                            v481 = (v474:GetChildren())
                            if not (((#v481) > 6))then
                                v468 = ipairs
                                for v478, v476 in v468(v481) do
                                    v477 = v476.Name:lower()
                                    v483 = (v477 == "top")
                                    v482 = v483
                                    if not (v483) then
                                        v485 = (v477 == "bottom")
                                        v483 = v485
                                        if not (v485) then
                                            v483 = (v477 == "right") or (v477 == "left")
                                        end
                                        v482 = v483
                                    end
                                    if v482 then
                                        v468 = up97
                                        v468.Crosshair = v474
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return
        end
    end
    local up98
    v1325 = function()
        up88.PlayerGui.ChildAdded:Connect(up98)
        up98()
        return
    end
    up98 = v1323
    pcall(v1325)
    local up99
    v1326 = function()
        up99 = (loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealXORA/Roblox/refs/heads/Main/Scripts%20/Utilities%20/Fetch%20Game%20Information.luau"))())

        return
    end
    up99 = nil
    pcall(v1326)
    v1326 = ((type(up99)) == "function") and (up99())
    v1323 = v1326
    if not (v1326) then
        v1323 = ((type(up99)) == "table") and up99 or {}
    end
    local up100 = v1323
    v1327 = up100
    if (not v1327["Creator"]) then
        v1323 = up100
        v1327 = {["Name"] = "Unknown"}
        v1323.Creator = v1327
    end
    v1327 = up100
    if (not v1327["Name"]) then
        v1323 = up100
        v1328 = tostring(game.PlaceId)
        v1323.Name = v1328
    end
    v1328 = Vector3.new(math.huge, math.huge, math.huge)
    v1341 = Enum.HumanoidStateType.Freefall
    v1343 = Enum.HumanoidStateType.Jumping
    v1344 = workspace.CurrentCamera
    v1348 = up88:GetMouse()
    v1349 = up80.TargetAim
    v1351 = up80.Offsets
    local up101 = {["NilVector"] = v1328, ["CurrentPos"] = nil, ["cachedEnemy"] = nil, ["cachedChar"] = nil, ["cachedHum"] = nil, ["cachedPart"] = nil, ["cachedPartName"] = nil, ["Freefall"] = v1341, ["Jumping"] = v1343, ["camera"] = v1344, ["Mouse"] = v1348, ["TargetAim"] = v1349, ["Offsets"] = v1351}
    v1323 = up101
    v1328 = up101.NilVector
    v1323.CurrentPos = v1328
    v1323 = up101
    v1328 = up101.TargetAim.Parts
    v1323.Parts = v1328
    v1328 = function(arg5_1)
        local v222 = arg5_1
        return (v222.Team == up88.Team) and (v222.Team ~= nil)
    end
    v1327 = function(arg6_1)
        local v231 = Silent
        local v232 = v231
        local v233 = arg6_1
        if v231 then
            v232 = ((v233 - Silent.Position ).Magnitude <= Silent.Radius)
        end
        return v232
    end
    local up102 = v1327
    local up103
    v1329 = function()
        local v242, v245, v248, v249, v250, v251, v252, v253, v254, v255, v256, v257, v258, v259, v260, v261
        local v262, v264
        local v271, v273, v274, v275
        local v243 = (not Silent)
        local v244 = v243
        if not (v243) then
            v244 = (not up80.Enabled)
        end
        if v244 then
            v250 = nil
            return v250
        else
            v250 = nil
            v242 = tonumber
            v243 = nil
            v242 = ((v242(up80.SilentAim ["Max Distance"])) or 1000)
            v245 = up80.Checks.Enabled
            v249 = up87.CFrame.Position
            v244 = ipairs
            v251 = up81
            v253 = v251.GetPlayers
            for v248, v252 in v244(v253(v251)) do
                if not ((v252 == up88))then
                    v253 = v252.Character
                    if not ((not v253))then
                        v258 = (v253:FindFirstChildOfClass("Humanoid"))
                        v259 = (v253:FindFirstChild("HumanoidRootPart"))
                        v257 = up94 or "HumanoidRootPart"
                        v244 = v253:FindFirstChild(v257)
                        v255 = v258
                        v262 = v244
                        if v258 then
                            v255 = (v259 and v262)
                        end
                        v244 = (not v255) or (v258.Health <= 0)
                        if not (v244) then
                            if v245 then
                                v257 = up80.Checks
                                if v257["KO Check"] then
                                    v257 = (v253:FindFirstChild("BodyEffects"))
                                    v244 = v257
                                    if v257 then
                                        v260 = v257:FindFirstChild("K.O")
                                        v255 = v260
                                        if not (v260) then
                                            v255 = (v257:FindFirstChild("Dead"))
                                        end
                                        v244 = v255
                                    end
                                    v254 = v244
                                    v244 = v254 and v254.Value
                                    if v244 then
                                        continue
                                    end
                                end
                                if v259["Anchored"] then
                                    continue
                                else
                                    v254 = up80.Checks["Forcefield Check"]
                                    v244 = v254
                                    if v254 then
                                        v244 = (v253:FindFirstChildOfClass("ForceField"))
                                    end
                                    if v244 then
                                        continue
                                    else
                                        v244 = up80.Checks["Team Check"] and (up103(v252))
                                        if v244 then
                                            continue
                                        else
                                            v257 = up80.Checks
                                            if v257["Friend Check"] then
                                                v244 = v252.UserId
                                                local up1 = v244
                                                if (up96[up1] == nil) then
                                                    up96[up1] = false
                                                    task.spawn(function()
                                                        up96[up1] = up88:IsFriendsWith(up1)

                                                        return
                                                    end)
                                                end
                                                if up96[up1] then
                                                    continue
                                                end
                                            end
                                            v244 = up80.Checks["Vehicle Check"] and v258.SeatPart
                                            if v244 then
                                                continue
                                            else
                                                v257 = up80.Checks
                                                if v257["Crew Check"] then
                                                    v255 = up88:FindFirstChild("DataFolder")
                                                    v244 = v255
                                                    if v255 then
                                                        v244 = (up88.DataFolder:FindFirstChild("Information"))
                                                    end
                                                    v257 = v244
                                                    v255 = v252:FindFirstChild("DataFolder")
                                                    v244 = v255
                                                    if v255 then
                                                        v244 = (v252.DataFolder:FindFirstChild("Information"))
                                                    end
                                                    v254 = v244
                                                    v244 = v257 and (v257:FindFirstChild("Crew"))
                                                    v255 = v244
                                                    v244 = v254 and (v254:FindFirstChild("Crew"))
                                                    v256 = v244
                                                    v244 = v255
                                                    if v255 then
                                                        v261 = v256
                                                        if v256 then
                                                            v271 = (v255.Value ~= "")
                                                            v264 = v271
                                                            if v271 then
                                                                v264 = (v255.Value == v256.Value)
                                                            end
                                                            v261 = v264
                                                        end
                                                        v244 = v261
                                                    end
                                                    if v244 then
                                                        continue
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            v244 = up87
                            v255 = v262.Position
                            v256 = {v244:WorldToViewportPoint(v255)}
                            v273 = v256[1]
                            if not ((not v256[2]))then
                                v274 = (Vector2.new(v273.X, v273.Y))
                                v254 = up102(v274)
                                if not ((not v254))then
                                    v244 = v245
                                    if v245 then
                                        v244 = up80.Checks["Wall Check"]
                                    end
                                    if v244 then
                                        v244 = up95
                                        v255 = up88.Character
                                        v244.FilterDescendantsInstances = {v255, v253}
                                        v257 = workspace:Raycast(v249, (v262.Position - v249), up95)
                                        if v257 then
                                            continue
                                        end
                                    end
                                    v275 = (v262.Position - v249).Magnitude
                                    if (v275 < v242) then
                                        v242 = v275
                                        v243 = v252
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return v243
        end
    end
    up103 = v1328
    local up104 = v1329
    v1329 = function()
        local v276, v279, v281, v282, v283, v284, v285, v286, v287, v288, v289, v290, v291, v292, v293, v295
        local v297, v298
        up92 = up104()
        local v278 = up92
        local v280 = (not v278) or (not v278.Character)
        if v280 then
            v280 = up101.CurrentPos
            v285 = up101
            if (v280 ~= v285["NilVector"]) then
                v276 = up101
                v279 = up101.NilVector
                v276.CurrentPos = v279
                v276 = up101
                v276.cachedEnemy = nil
                v276 = up101
                v276.cachedChar = nil
                v276 = up101
                v276.cachedHum = nil
                v276 = up101
                v276.cachedPart = nil
            end
            return
        else
            v276 = v278.Character
            v281 = up101
            v280 = v276
            v285 = (v278 ~= v281.cachedEnemy)
            v279 = v285
            if not (v285) then
                v279 = (v280 ~= up101.cachedChar)
            end
            if v279 then
                v276 = up101
                v276.cachedEnemy = v278
                v276 = up101
                v276.cachedChar = v280
                v276 = up101
                v285 = v280:FindFirstChildOfClass("Humanoid")
                v276.cachedHum = v285
                v276 = up101
                v276.cachedPart = nil
                v276 = up101
                v276.cachedPartName = nil
            end
            v279 = up101.cachedHum
            v285 = v279 and (v279:GetState())
            v281 = (v285 == up101.Freefall)
            v284 = v281
            if not (v281) then
                v284 = (v285 == up101.Jumping)
            end
            v282 = v284
            if v284 then
                v282 = up101.Parts.Airpart
            end
            v281 = v282
            if not (v282) then
                v281 = up101.Parts.Hitpart or "HumanoidRootPart"
            end
            v286 = up101
            if (v281 ~= v286["cachedPartName"]) then
                v282 = up101
                v282.cachedPartName = v281
                v282 = up101
                v286 = v280:FindFirstChild(v281)
                v282.cachedPart = v286
            end
            v282 = up101.cachedPart
            v283 = (not v282) or (not v282.Parent)
            if v283 then
                v283 = up101
                v287 = v280:FindFirstChild(v281)
                v283.cachedPart = v287
                v282 = up101.cachedPart
            end
            if (not v282) then
                v286 = up101
                v288 = up101.NilVector
                v286.CurrentPos = v288
                return
            else
                v286 = v282.Position
                v287 = v282.AssemblyLinearVelocity
                v291 = tonumber(up101.TargetAim.Prediction)
                v293 = up101
                v288 = (v291 or .1)
                v289 = (v293.TargetAim.Offset or 0)
                v290 = (v286.X + (v287.X * v288))
                v291 = ((v286.Y + (v287.Y * v288)) + v289)
                v292 = (v286.Z + (v287.Z * v288))
                v298 = up101
                if (v285 == v298["Jumping"]) then
                    v291 = (v291 + (up101.Offsets["Jump Offset"] or 0))
                else
                    v295 = up101
                    if (v285 == v295["Freefall"]) then
                        v291 = (v291 + (up101.Offsets["Fall Offset"] or 0))
                    end
                end
                v298 = up101
                v297 = Vector3.new(v290, v291, v292)
                v298.CurrentPos = v297
                return
            end
        end
    end
    v1330 = up82.Heartbeat
    v1332 = function()
        local v306 = (getrawmetatable(game))
        local up2 = v306.__index
        setreadonly(v306, false)
        v306.__index = newcclosure(function(arg89_1, arg89_2)
            local v1198, v1199, v1200, v1202, v1205, v1207
            local v1195 = arg89_1
            local v1196 = arg89_2
            local v1197 = checkcaller()
            if v1197 then
                v1198 = up2
                return v1198(v1195, v1196)
            else
                v1205 = (v1195 == up101.Mouse)
                v1197 = v1205
                if v1205 then
                    v1199 = up101.TargetAim.Enabled
                    v1205 = v1199
                    if v1199 then
                        v1200 = (up101.TargetAim["Lock Type"] == "Index")
                        v1199 = v1200
                        if v1200 then
                            v1202 = (up101.CurrentPos ~= up101.NilVector)
                            v1200 = v1202
                            if v1202 then
                                v1207 = up92
                                v1202 = v1207
                                if v1207 then
                                    v1202 = up92.Character
                                end
                                v1200 = v1202
                            end
                            v1199 = v1200
                        end
                        v1205 = v1199
                    end
                    v1197 = v1205
                end
                if v1197 then
                    if (v1196 == "Hit") then
                        v1198 = CFrame.new
                        v1205 = up101.CurrentPos
                        return v1198(v1205)
                    else
                        if (v1196 == "Target") then
                            v1205 = up101.cachedChar
                            v1197 = v1205
                            if v1205 then
                                v1205 = up101.cachedChar
                                v1199 = up101.cachedPartName or "HumanoidRootPart"
                                v1197 = (v1205:FindFirstChild(v1199))
                            end
                            v1197 = v1197 or (up2(v1195, v1196))

                            return v1197
                        end
                    end
                end
                v1198 = up2
                return v1198(v1195, v1196)
            end
        end)
        setreadonly(v306, true)

        return
    end
    v1330:Connect(v1329)
    pcall(v1332)
    v1332 = {["Bullets"] = true, ["D3RHooDMSOUEPoS233^++"] = true, ["D3RHooDMSOUEPoS233^+"] = true, ["DEAHOODMOUSEPOSx3"] = true, ["DEAHOODMOUSEPOSx3^3"] = true, ["DurrHooDmOsussePosition144125+*-"] = true, ["GetMousePos"] = true, ["MOUSE"] = true, ["MOUSEPOSUPDATEI12"] = true, ["MOUSEPOSUPDATEI2"] = true, ["MousePos"] = true, ["MousePosUpdate"] = true, ["MainEvent"] = true, ["MAINEVENT"] = true, ["Remotes"] = true, ["UpdateAim"] = true, ["UpdateAimingAt"] = true, ["UpdateMousePos"] = true, ["UpdateMousePosI"] = true, ["UpdateMousePosI2"] = true, ["^+"] = true, ["XEEHOODMOUSEPOSx3^3"] = true}
    v1335 = Vector3.new(math.huge, math.huge, math.huge)
    spilledValues1.value11 = up80.TargetAim
    v1338 = (up100.Creator.Name == "Da Hood Entertainment")
    v1340 = (up100.Creator.Name == "Dan FFA Entertainment")
    v1342 = workspace
    local up105 = {["ArgumenHash"] = v1332, ["NilVector"] = v1335, ["TargetAim"] = spilledValues1.value11, ["isDaHood"] = v1338, ["isDanFFA"] = v1340, ["workspace"] = v1342}
    local up106 = {}
    v1330 = next
    v1333 = up105.ArgumenHash
    v1334 = nil
    while true do
        v1334 = v1330(v1333, v1334)
        if not v1334 then
            break
        end
        spilledValues1.value11 = up106
        spilledValues1.value12 = v1334:lower()
        spilledValues1.value11[spilledValues1.value12] = true
    end
    v1330 = Vector3.new
    local up107 = v1330
    v1330 = up105.NilVector
    local up108 = v1330
    v1330 = math.random
    local up109 = v1330
    v1330 = type
    local up110 = v1330
    v1330 = typeof
    local up111 = v1330
    v1330 = debug.info
    local up112 = v1330
    v1339 = up105
    if v1339["isDaHood"] then
        pcall(function()
            local v1017 = (require(game:GetService("ReplicatedStorage"):WaitForChild("Modules", 5):WaitForChild("GunHandler", 5)))
            local v1015 = v1017 and v1017.getAim
            if v1015 then
                local up40 = v1017.getAim
                v1015 = function(arg95_1, arg95_2)
                    local v1255, v1267
                    local v1253 = up105
                    local v1254 = arg95_2
                    local v1257 = arg95_1
                    local v1261 = v1253.TargetAim.Enabled
                    local v1262 = v1261
                    if v1261 then
                        v1253 = (up105.TargetAim["Lock Type"] == "Namecall")
                        v1261 = v1253
                        if v1253 then
                            v1255 = up92
                            v1253 = v1255
                            if v1255 then
                                v1253 = (up101.CurrentPos ~= up108)
                            end
                            v1261 = v1253
                        end
                        v1262 = v1261
                    end
                    if v1262 then
                        v1261 = (up101.CurrentPos - v1257)
                        v1267 = v1261.Unit
                        v1262 = v1261.Magnitude
                        return v1267, v1262
                    else
                        v1267 = up40
                        return v1267(v1257, v1254)
                    end
                end
                v1017.getAim = v1015
            end
            return
        end)
    end
    v1340 = function()
        local v549, v550, v552, v554, v556, v557, v558, v559, v561, v563, v565
        local v548 = getnilinstances and getsenv
        if v548 then
            v549 = ipairs
            v550 = getnilinstances
            for v554, v550 in v549((v550()) or {}) do
                v552 = v550.ClassName
                if (v552 ~= "LocalScript") then
                    continue
                else
                    v556, v557 = pcall(getsenv, v550)
                    v558 = v557
                    v557 = (not v556)
                    v556 = v557
                    if not (v557) then
                        v565 = ((type(v558)) ~= "table")
                        v557 = v565
                        if not (v565) then
                            v557 = (not (rawget(v558, "mobileShiftLockMousePos")))
                        end
                        v556 = v557
                    end
                    if v556 then
                        continue
                    else
                        local up3 = v558._G
                        if up3 then
                            v556 = setmetatable
                            v559 = {}
                            v561 = function(arg1_1, arg1_2)
                                local v174, v176, v178, v179, v180, v182, v188, v189
                                local v171 = arg1_2
                                local v172 = v171
                                if v171 then
                                    v178 = ((type(v171)) == "string")
                                    v179 = v178
                                    if v178 then
                                        v174 = ((v171:lower()) == "mouse_position")
                                        v178 = v174
                                        if v174 then
                                            v176 = up80.TargetAim.Enabled
                                            v174 = v176
                                            if v176 then
                                                v180 = (up80.TargetAim["Lock Type"] == "Namecall")
                                                v176 = v180
                                                if v180 then
                                                    v182 = up92
                                                    v180 = v182
                                                    if v182 then
                                                        v180 = up92.Character
                                                    end
                                                    v176 = v180
                                                end
                                                v174 = v176
                                            end
                                            v178 = v174
                                        end
                                        v179 = v178
                                    end
                                    v172 = v179
                                end
                                if v172 then
                                    v188 = up92.Character
                                    v179 = up101.cachedPartName or "HumanoidRootPart"
                                    v179 = (v188:FindFirstChild(v179))
                                    if v179 then
                                        v189 = v179.Position
                                        return v189
                                    end
                                end
                                return up3[v171]
                            end
                            v563 = function(arg2_1, arg2_2, arg2_3)
                                local v194, v196, v198, v199, v200, v202, v208
                                local v190 = arg2_3
                                local v191 = arg2_2
                                local v192 = v191
                                if v191 then
                                    v198 = ((type(v191)) == "string")
                                    v199 = v198
                                    if v198 then
                                        v194 = ((v191:lower()) == "mouse_position")
                                        v198 = v194
                                        if v194 then
                                            v196 = up80.TargetAim.Enabled
                                            v194 = v196
                                            if v196 then
                                                v200 = (up80.TargetAim["Lock Type"] == "Namecall")
                                                v196 = v200
                                                if v200 then
                                                    v202 = up92
                                                    v200 = v202
                                                    if v202 then
                                                        v200 = up92.Character
                                                    end
                                                    v196 = v200
                                                end
                                                v194 = v196
                                            end
                                            v198 = v194
                                        end
                                        v199 = v198
                                    end
                                    v192 = v199
                                end
                                if v192 then
                                    v208 = up92.Character
                                    v199 = up101.cachedPartName or "HumanoidRootPart"
                                    v199 = (v208:FindFirstChild(v199))
                                    if v199 then
                                        rawset(up3, v191, v199.Position)

                                        return
                                    end
                                end
                                up3[v191] = v190
                                return
                            end
                            v557 = v556(v559, {["__index"] = v561, ["__newindex"] = v563})
                            v558._G = v557
                        end
                    end
                end
                break
            end
        end
        return
    end
    pcall(v1340)
    v1340 = function()
        local v572 = up100.Name
        local v573 = v572
        if v572 then
            v573 = (up100.Name:find("Flame Hood"))
        end
        if v573 then
            hookfunction(Ray.new, function(arg0_1, arg0_2)
                local v163, v164, v170
                local v153 = arg0_1
                local v155 = checkcaller()
                local v156 = arg0_2
                local v157 = (not v155)
                local v158 = v157
                if v157 then
                    v155 = (up80.TargetAim["Lock Type"] == "Namecall")
                    v157 = v155
                    if v155 then
                        v164 = up92
                        v155 = v164
                        if v164 then
                            v163 = ((up112(5, "n")) == "CastRay")
                            v164 = v163
                            if v163 then
                                v164 = (up101.CurrentPos ~= up108)
                            end
                            v155 = v164
                        end
                        v157 = v155
                    end
                    v158 = v157
                end
                if v158 then
                    v170 = Ray.new
                    v157 = ((up101.CurrentPos - v153).Unit * v156.Magnitude)

                    return v170(v153, v157)
                else
                    v170 = Ray.new
                    return v170(v153, v156)
                end
            end)
        end
        return
    end
    pcall(v1340)
    v1330 = pcall
    v1340 = function()
        local v582, v584
        local v578 = (getrawmetatable(game))
        local v576 = v578.__namecall
        local up4 = v576
        setreadonly(v578, false)
        local v579 = up105.isDaHood
        local v575 = v579
        if not (v579) then
            v584 = (up100.Creator.Name == "Hood Customs Entertainment")
            v579 = v584
            if not (v584) then
                v582 = (up100.Creator.Name == "Da Entertain")
                v584 = v582
                if not (v582) then
                    v584 = ((up100.Name:find("Flame Hood")) ~= nil)
                end
                v579 = v584
            end
            v575 = v579
        end
        local up5 = v575
        v576 = up105.workspace
        local up6 = v576
        v576 = up105.TargetAim
        local up7 = v576
        local up8 = up108
        v575 = newcclosure
        local v583 = function(arg70_1, ...)
            local v952, v953, v954, v955, v956, v957, v958, v959, v960, v961, v962
            local v948 = arg70_1
            local v950 = checkcaller
            local v951 = {...}
            local v949 = v950()
            if v949 then
                v950 = up4
                return v950(v948, unpackValues(v951))
            else
                v949 = up7["Lock Type"]
                if (v949 ~= "Namecall") then
                    v950 = up4
                    return v950(v948, unpackValues(v951))
                else
                    v952 = (getnamecallmethod())
                    if (v952 == "FireServer") then
                        v956 = up7.Enabled
                        v949 = v956
                        if v956 then
                            v954 = up92
                            v956 = v954
                            if v954 then
                                v957 = up92.Character
                                v954 = v957
                                if v957 then
                                    v954 = (up101.CurrentPos ~= up8)
                                end
                                v956 = v954
                            end
                            v949 = v956
                        end
                        if v949 then
                            v956 = {unpackValues(v951)}
                            v950 = ipairs
                            for v954, v958 in v950(v956) do
                                v957 = v954
                                v962 = ((up110(v958)) == "string") and up106[(v958:lower())]
                                if v962 then
                                    v950 = (v957 + 1)
                                    v962 = up101.CurrentPos
                                    v956[v950] = v962
                                    v950 = up4
                                    v959 = unpack
                                    return v950(v948, v959(v956))
                                end
                            end
                        end
                        v950 = up4
                        return v950(v948, unpackValues(v951))
                    else
                        v953 = up5
                        v956 = v953
                        if not (v953) then
                            v955 = (not v952)
                            v953 = v955
                            if not (v955) then
                                v953 = (not (v952:lower():find("cast")))
                            end
                            v956 = v953
                        end
                        if v956 then
                            v950 = up4
                            return v950(v948, unpackValues(v951))
                        else
                            v953 = up7.Enabled
                            v956 = v953
                            if v953 then
                                v955 = up92
                                v953 = v955
                                if v955 then
                                    v958 = up92.Character
                                    v955 = v958
                                    if v958 then
                                        v955 = (up101.CurrentPos ~= up8) and (v948 == up6)
                                    end
                                    v953 = v955
                                end
                                v956 = v953
                            end
                            if v956 then
                                v953 = v951[3]
                                v954 = v951[4]
                                v956 = v951[2]
                                v950 = v951[1]
                                v958 = up111
                                v955 = v950
                                v957 = v955
                                v962 = v958(v957)
                                if (v962 == "CFrame") then
                                    v957 = v957.Position
                                end
                                v958 = (up101.CurrentPos - v957).Unit
                                local up39
                                v961 = function()
                                    up39 = (getcallingscript())

                                    return
                                end
                                pcall(v961)
                                v961 = up39
                                v962 = v961
                                if v961 then
                                    v962 = (up39.Name:lower():find("shotgun"))
                                end
                                if v962 then
                                    v958 = (v958 + (up107(((up109(-5, 5)) * .01), ((up109(-5, 5)) * .01), ((up109(-5, 5)) * .01)))).Unit
                                end
                                v960 = (v958 * 10000)
                                v961 = (v952 == "Raycast") or (v952 == "Shapecast")
                                if v961 then
                                    v961 = up4
                                    return v961(v948, v955, v960, v953, v954)
                                else
                                    v961 = up4
                                    return v961(v948, v955, v956, v960, v954)
                                end
                            else
                                v956 = up4
                                return v956(v948, unpackValues(v951))
                            end
                        end
                    end
                end
            end
        end
        v578.__namecall = v575(v583)
        setreadonly(v578, true)

        return
    end
    v1330(v1340)
    v1339 = Instance.new("ScreenGui", spilledValues1.value6)
    local up113 = v1339
    v1339 = up113
    v1339.Name = "MinarrLiquidGlassUI"
    v1339 = up113
    v1339.ResetOnSpawn = false
    v1339 = up113
    v1339.IgnoreGuiInset = true
    v1340 = Instance.new("TextLabel", up113)
    local up114 = v1340
    v1340 = up114
    v1343 = UDim2.new(0, 32, 0, 32)
    v1340.Size = v1343
    v1340 = up114
    v1340.BackgroundTransparency = 1
    v1340 = up114
    v1340.Text = "🌸"
    v1340 = up114
    v1340.TextSize = 22
    v1340 = up114
    v1343 = Vector2.new(0.5, 0.5)
    v1340.AnchorPoint = v1343
    v1340 = up114
    v1340.Visible = false
    v1340 = up114
    v1340.ZIndex = 1000
    v1341 = Instance.new("Frame", up113)
    local up115 = v1341
    v1341 = up115
    v1347 = UDim2.new(0, 365, 0, 420)
    v1341.Size = v1347
    v1341 = up115
    v1347 = UDim2.new(0.5, -182, 0.5, -210)
    v1341.Position = v1347
    v1341 = up115
    v1347 = Color3.fromRGB(240, 215, 225)
    v1341.BackgroundColor3 = v1347
    v1341 = up115
    v1341.BackgroundTransparency = .2
    v1341 = up115
    v1341.Active = true
    v1341 = up115
    v1341.ClipsDescendants = true
    v1341 = up83.MouseIconEnabled
    local up116 = v1341
    local up117 = false
    local up118 = function()
        local v598, v600
        local v593 = (up83:GetMouseLocation())
        local v597 = up115.AbsolutePosition
        local v594 = up115.AbsoluteSize
        local v595 = (v593.X >= v597.X)
        local v591 = v595
        if v595 then
            v598 = (v593.X <= (v597.X + v594.X))
            v595 = v598
            if v598 then
                v600 = (v593.Y >= v597.Y)
                v598 = v600
                if v600 then
                    v598 = (v593.Y <= (v597.Y + v594.Y))
                end
                v595 = v598
            end
            v591 = v595
        end
        return v591
    end
    v1347 = up82.RenderStepped
    v1345 = function()
        local v615
        local v611 = (up83:GetMouseLocation())
        local v610 = up114
        local v613 = UDim2.new(0, v611.X, 0, v611.Y)
        v610.Position = v613
        local v612 = (up118())
        up114.Visible = v612
        if (v612 ~= up117) then
            if v612 then
                up116 = up83.MouseIconEnabled
                v613 = up83
                v613.MouseIconEnabled = false
            else
                v613 = up83
                v615 = up116
                v613.MouseIconEnabled = v615
            end
        end
        return
    end
    v1347:Connect(v1345)
    v1344 = Instance.new("UICorner", up115)
    v1346 = UDim.new(0, 20)
    v1344.CornerRadius = v1346
    v1344 = Instance.new("UIStroke", up115)
    v1346 = Color3.fromRGB(255, 255, 255)
    v1344.Color = v1346
    v1344.Transparency = .05
    v1344.Thickness = 2
    v1345 = Instance.new("UIStroke", up115)
    v1348 = Color3.fromRGB(255, 140, 185)
    v1345.Color = v1348
    v1345.Transparency = .35
    v1345.Thickness = 6
    v1346 = Enum.ApplyStrokeMode.Border
    v1345.ApplyStrokeMode = v1346
    v1346 = Instance.new("Frame", up115)
    local up119 = v1346
    v1346 = up119
    v1350 = UDim2.new(1, 0, 0, 45)
    v1346.Size = v1350
    v1346 = up119
    v1346.BackgroundTransparency = 1
    v1346 = up119
    v1346.ZIndex = 5
    local up120 = false
    local up121
    local up122
    up119.InputBegan:Connect(function(arg38_1)
        local v626, v627
        local up9 = arg38_1
        local v630 = (up9.UserInputType == Enum.UserInputType.MouseButton1)
        local v631 = v630
        if not (v630) then
            v631 = (up9.UserInputType == Enum.UserInputType.Touch)
        end
        if v631 then
            up120 = true
            up121 = up9.Position
            up122 = up115.Position
            v627 = up9.Changed
            v626 = function()
                local v1249 = up9.UserInputState
                local v1248 = Enum.UserInputState
                if (v1249 == v1248.End ) then
                    up120 = false
                end
                return
            end
            v627:Connect(v626)
        end
        return
    end)
    v1349 = up83.InputChanged
    v1352 = function(arg39_1)
        local v645, v647
        local v634 = up120
        local v635 = arg39_1
        local v636 = v634
        if v634 then
            v645 = (v635.UserInputType == Enum.UserInputType.MouseMovement)
            v634 = v645
            if not (v645) then
                v634 = (v635.UserInputType == Enum.UserInputType.Touch)
            end
            v636 = v634
        end
        if v636 then
            v634 = (v635.Position - up121)
            v647 = up115
            v645 = UDim2.new(up122.X.Scale, (up122.X.Offset + v634.X), up122.Y.Scale, (up122.Y .Offset + v634.Y))
            v647.Position = v645
        end
        return
    end
    v1349:Connect(v1352)
    local up125 = function(arg40_1, arg40_2, arg40_3, arg40_4, arg40_5)
        local up10 = arg40_1
        local up14 = arg40_2
        local up12 = arg40_3
        local up15 = arg40_4
        local up11 = arg40_5
        up10.MouseEnter:Connect(function()
            local v387 = up85
            local v388 = up10
            local v394 = TweenInfo.new
            local v390 = Enum.EasingStyle.Quart
            local v398 = Enum
            local v400 = v387.Create
            local v389 = v394(0.25, v390, v398.EasingDirection .Out)
            v390 = up12
            v400 = v400(v387, v388, v389, {["BackgroundColor3"] = v390, ["BackgroundTransparency"] = .1})
            v400:Play()
            if up15 then
                v387 = up85
                v388 = up15
                v389 = TweenInfo.new(0.25)
                v390 = up11
                v387:Create(v388, v389, {["Color"] = v390, ["Transparency"] = .05}):Play()
            end
            return
        end)
        local v651 = up10.MouseLeave
        local v656 = function()
            local v402 = up85
            local v403 = up10
            local v409 = TweenInfo.new
            local v406 = Enum.EasingStyle
            local v414 = v402.Create
            local v404 = v409(0.25, v406.Quart, Enum.EasingDirection.Out)
            local v405 = up14
            v414 = v414(v402, v403, v404, {["BackgroundColor3"] = v405, ["BackgroundTransparency"] = 0.25})
            v414:Play()
            if up15 then
                v402 = up85
                v414 = v402.Create
                v403 = up15
                v404 = TweenInfo.new(0.25)
                v405 = up14
                v414 = v414(v402, v403, v404, {["Color"] = v405, ["Transparency"] = 0.25})
                v414:Play()
            end
            return
        end
        v651:Connect(v656)

        return
    end
    local up124 = false
    v1351 = function(arg41_1, arg41_2, arg41_3)
        local v666 = (Instance.new("TextButton", up119))
        v666.Size = UDim2.new(0, 24, 0, 24)
        v666.Position = UDim2.new(1, arg41_2, 0, 10)
        v666.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
        v666.BackgroundTransparency = 0.25
        v666.Text = arg41_1
        v666.TextColor3 = Color3.fromRGB(120, 50, 75)
        v666.Font = Enum.Font.GothamBold
        v666.TextSize = 12
        v666.ZIndex = 10
        local v662 = Instance.new("UICorner", v666)
        v662.CornerRadius = UDim.new(0, 8)
        local v663 = (Instance.new("UIStroke", v666))
        v663.Color = Color3.fromRGB(255, 255, 255)
        v663.Transparency = 0.25
        up125(v666, (Color3.fromRGB(255, 220, 235)), (Color3.fromRGB(255, 190, 215)), v663, Color3.fromRGB(255, 255, 255))
        v666.MouseButton1Click:Connect(arg41_3)

        return v666
    end
    local up123 = 420
    v1355 = Instance.new("Frame", up115)
    local up126 = v1355
    v1355 = up126
    v1358 = UDim2.new(1, 0, 1, -70)
    v1355.Size = v1358
    v1355 = up126
    v1358 = UDim2.new(0, 0, 0, 45)
    v1355.Position = v1358
    v1355 = up126
    v1355.BackgroundTransparency = 1
    v1355 = up126
    v1355.ClipsDescendants = true
    v1358 = function()
        up113:Destroy()
        local v675 = up83
        v675.MouseIconEnabled = true
        if Silent then
            v675 = Silent
            v675.Visible = false
        end
        return
    end
    v1351("×", -30, v1358)
    v1356 = Instance.new("TextLabel", up115)
    local up127 = v1356
    v1356 = up127
    v1359 = UDim2.new(1, -20, 0, 20)
    v1356.Size = v1359
    v1356 = up127
    v1359 = UDim2.new(0, 10, 1, -25)
    v1356.Position = v1359
    v1356 = up127
    v1356.BackgroundTransparency = 1
    v1356 = up127
    v1356.Text = "Ping: ?ms | FPS: ?"
    v1356 = up127
    v1359 = Color3.fromRGB(110, 50, 75)
    v1356.TextColor3 = v1359
    v1356 = up127
    v1358 = Enum.Font.GothamMedium
    v1356.Font = v1358
    v1356 = up127
    v1356.TextSize = 11
    v1356 = up127
    v1358 = Enum.TextXAlignment.Center
    v1356.TextXAlignment = v1358
    v1356 = up127
    v1356.ZIndex = 10
    v1359 = function()
        if (not up124) then
            up123 = up115.AbsoluteSize.Y
        end
        up124 = (not up124)
        up126.Visible = (not up124)
        local v682 = up124
        local v680 = v682
        if v682 then
            v680 = (UDim2.new(0, up115.AbsoluteSize.X, 0, 45))
        end
        local v679 = v680
        if not (v680) then
            v679 = (UDim2.new(0, up115.AbsoluteSize.X, 0, up123))
        end
        local v683 = up85
        local v681 = up115
        local v686 = TweenInfo.new(.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        v683:Create(v681, v686, {["Size"] = v679}):Play()
        v683 = up85
        v681 = up127
        v686 = TweenInfo.new(.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        local v691 = up124
        local v689 = v691
        if v691 then
            v689 = (UDim2.new(0, 10, 0, 12))
        end
        local v687 = v689
        if not (v689) then
            v687 = (UDim2.new(0, 10, 1, -25))
        end
        local v693 = up124
        v691 = v693
        if v693 then
            v691 = (UDim2.new(0, 130, 0, 20))
        end
        v689 = v691
        if not (v691) then
            v689 = (UDim2.new(1, -20, 0, 20))
        end
        v683:Create(v681, v686, {["Position"] = v687, ["Size"] = v689}):Play()
        v683 = up127
        v687 = up124
        v686 = v687
        if v687 then
            v686 = Enum.TextXAlignment.Left
        end
        v681 = v686
        if not (v686) then
            v681 = Enum.TextXAlignment.Center
        end
        v683.TextXAlignment = v681
        minBtn.Text = up124 and "+" or "-"
        return
    end
    v1351("-", -58, v1359)
    v1358 = Instance.new("TextLabel", up119)
    local up128 = v1358
    v1358 = up128
    v1358.BackgroundTransparency = 1
    v1358 = up128
    v1358.Text = "Minarr • Silent Aim"
    v1358 = up128
    v1361 = Color3.fromRGB(90, 30, 55)
    v1358.TextColor3 = v1361
    v1358 = up128
    v1360 = Enum.Font.GothamBold
    v1358.Font = v1360
    v1358 = up128
    v1358.TextSize = 12
    v1358 = up128
    v1358.TextWrapped = true
    v1358 = up128
    v1360 = Enum.TextXAlignment.Left
    v1358.TextXAlignment = v1360
    v1358 = up128
    v1360 = Enum.TextYAlignment.Top
    v1358.TextYAlignment = v1360
    v1358 = up128
    v1358.ZIndex = 6
    v1359 = Instance.new("TextLabel", up119)
    local up129 = v1359
    v1359 = up129
    v1359.BackgroundTransparency = 1
    v1359 = up129
    v1359.Text = "by @3b2d"
    v1359 = up129
    v1362 = Color3.fromRGB(90, 30, 55)
    v1359.TextColor3 = v1362
    v1359 = up129
    v1359.TextTransparency = .4
    v1359 = up129
    v1361 = Enum.Font.GothamMedium
    v1359.Font = v1361
    v1359 = up129
    v1359.TextSize = 10
    v1359 = up129
    v1361 = Enum.TextXAlignment.Left
    v1359.TextXAlignment = v1361
    v1359 = up129
    v1361 = Enum.TextYAlignment.Top
    v1359.TextYAlignment = v1361
    v1359 = up129
    v1362 = UDim2.new(0, 0, 0, 18)
    v1359.Position = v1362
    v1359 = up129
    v1359.ZIndex = 6
    v1360 = Instance.new("Frame", up119)
    local up130 = v1360
    v1360 = up130
    v1360.BackgroundTransparency = 1
    v1360 = up130
    v1360.ZIndex = 6
    v1361 = Instance.new("UIListLayout", up130)
    v1362 = Enum.FillDirection.Horizontal
    v1361.FillDirection = v1362
    v1362 = Enum.HorizontalAlignment.Center
    v1361.HorizontalAlignment = v1362
    v1363 = UDim.new(0, 2)
    v1361.Padding = v1363
    v1362 = up115
    v1363 = v1362.GetPropertyChangedSignal
    v1360 = function()
        local v700 = up115.AbsoluteSize.X
        local v705 = math
        local v704 = (v700 - 75)
        v705 = v705.clamp((math.floor((v704 * .52))), 110, 180)
        local v701 = v705
        local v702 = ((v704 - v701) - 8)
        up128.Size = UDim2.new(0, (math.max(v702, 60)), 0, 18)
        up128.Position = UDim2.new(0, 8, 0, 2)
        up129.Size = UDim2.new(0, (math.max(v702, 60)), 0, 15)
        up129.Position = UDim2.new(0, 8, 0, 20)
        up130.Size = UDim2.new(0, v701, 0, 26)
        up130.Position = UDim2.new(0, ((8 + v702) + 4), 0, 9)

        return
    end
    v1363 = v1363(v1362, "AbsoluteSize")
    v1363:Connect(v1360)
    task.spawn(v1360)
    task.spawn(function()
        local up16 = 0
        local up17 = 0
        local up18 = 0
        local v715 = up82.RenderStepped
        local v720 = function(arg97_1)
            up17 = (up17 + 1)
            local v1271 = os.clock()
            if ((v1271 - up16) >= 1) then
                up18 = (math.floor(((up17 / (v1271 - up16)) + 0.5)))
            end
            local up56
            local v1279 = function()
                local v352 = up86:FindFirstChild("Network")
                local v347 = v352
                if v352 then
                    v347 = (v352:FindFirstChild("ServerStatsItem"))
                end
                local v349 = v347
                v347 = v349
                if v349 then
                    v347 = (v349:FindFirstChild("Data Ping"))
                end
                local v350 = v347
                if v350 then
                    up56 = (math.floor(((v350:GetValue()) + 0.5)))
                else
                    up56 = (math.floor((((up88:GetNetworkPing()) * 1000) + 0.5)))
                end
                return
            end
            up56 = "?"
            pcall(v1279)
            up127.Text = string.format("Ping: %sms | FPS: %d", (tostring(up56)), up18)

            return
        end
        v715:Connect(v720)

        return
    end)
    local up131 = {}
    v1362 = function(arg46_1)
        local v724 = Instance.new("ScrollingFrame", up126)
        local up19 = v724
        up19.Name = arg46_1
        up19.Size = UDim2.new(1, -14, 1, -5)
        up19.Position = UDim2.new(0, 8, 0, 0)
        up19.BackgroundTransparency = 1
        up19.BorderSizePixel = 0
        up19.ScrollBarThickness = 5
        up19.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 185)
        up19.ScrollBarImageTransparency = .2
        up19.CanvasSize = UDim2.new(0, 0, 0, 0)
        up19.Visible = false
        v724 = Instance.new("UIListLayout", up19)
        local up20 = v724
        up20.Padding = UDim.new(0, 8)
        up20.SortOrder = Enum.SortOrder.LayoutOrder
        v724 = up20:GetPropertyChangedSignal("AbsoluteContentSize")
        local v726 = function()
            up19.CanvasSize = UDim2.new(0, 0, 0, (up20.AbsoluteContentSize.Y + 15))

            return
        end
        v724:Connect(v726)

        return up19
    end
    v1364 = v1362("Main")
    local up132 = v1364
    v1364 = v1362("Checks")
    local up133 = v1364
    v1364 = v1362("Parts")
    local up134 = v1364
    v1364 = up132
    v1364.Visible = true
    v1368 = function(arg47_1)
        up132.Visible = (up132 == arg47_1)
        up133.Visible = (up133 == arg47_1)
        up134.Visible = (up134 == arg47_1)

        return
    end
    local up135 = v1368
    v1368 = function(arg48_1, arg48_2)
        local up21 = arg48_2
        local v744 = (Instance.new("TextButton", up130))
        v744.Size = UDim2.new(.32, 0, 1, 0)
        v744.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        v744.BackgroundTransparency = 0.25
        v744.Text = arg48_1
        v744.TextColor3 = Color3.fromRGB(100, 40, 65)
        v744.Font = Enum.Font.GothamMedium
        v744.TextSize = 9
        v744.TextWrapped = true
        v744.ZIndex = 6
        local v740 = Instance.new("UICorner", v744)
        v740.CornerRadius = UDim.new(0, 8)
        local v741 = (Instance.new("UIStroke", v744))
        v741.Color = Color3.fromRGB(255, 255, 255)
        v741.Transparency = .3
        up125(v744, (Color3.fromRGB(255, 255, 255)), (Color3.fromRGB(255, 210, 230)), v741, Color3.fromRGB(255, 255, 255))
        v744.MouseButton1Click:Connect(function()
            up135(up21)
            return
        end)

        return v744
    end
    v1368("Main", up132)
    v1368("Checks", up133)
    v1368("Parts", up134)
    v1370 = function(arg49_1, arg49_2, arg49_3, arg49_4)
        local up22 = arg49_3
        local v752 = Instance.new("TextButton", arg49_1)
        local up23 = v752
        up23.Size = UDim2.new(1, 0, 0, 38)
        up23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        up23.BackgroundTransparency = 0.25
        up23.Text = arg49_2
        up23.TextColor3 = Color3.fromRGB(100, 40, 65)
        up23.Font = Enum.Font.GothamMedium
        up23.TextSize = 13
        up23.TextWrapped = true
        up23.LayoutOrder = (arg49_4 or 0)
        table.insert(up131, {["Obj"] = up23, ["BaseSize"] = 13})
        local v753 = Instance.new("UICorner", up23)
        v753.CornerRadius = UDim.new(0, 10)
        v753 = Instance.new("UIStroke", up23)
        v753.Color = Color3.fromRGB(255, 255, 255)
        v753.Transparency = .3
        up125(up23, (Color3.fromRGB(255, 255, 255)), (Color3.fromRGB(255, 210, 230)), v753, Color3.fromRGB(255, 255, 255))
        up23.MouseButton1Click:Connect(function()
            up22(up23)
            return
        end)

        return up23
    end
    v1372 = function(arg50_1, arg50_2, arg50_3, arg50_4, arg50_5, arg50_6, arg50_7)
        local up24 = arg50_3
        local up25 = arg50_4
        local up27 = arg50_5
        local up26 = arg50_6
        local v770 = (Instance.new("Frame", arg50_1))
        v770.Size = UDim2.new(1, 0, 0, 52)
        v770.BackgroundTransparency = 1
        v770.LayoutOrder = (arg50_7 or 0)
        local v767 = Instance.new("TextLabel", v770)
        v767.Size = UDim2.new(1, -75, 0, 20)
        v767.Position = UDim2.new(0, 10, 0, 0)
        v767.BackgroundTransparency = 1
        v767.Text = (arg50_2 .. ":")
        v767.TextColor3 = Color3.fromRGB(100, 40, 65)
        v767.Font = Enum.Font.GothamMedium
        v767.TextSize = 13
        v767.TextWrapped = true
        v767.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(up131, {["Obj"] = v767, ["BaseSize"] = 13})
        local v768 = Instance.new("TextBox", v770)
        local up28 = v768
        up28.Size = UDim2.new(0, 65, 0, 20)
        up28.Position = UDim2.new(1, -75, 0, 0)
        up28.BackgroundTransparency = 0.5
        up28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local v766 = function(arg84_1)
            local v1140, v1142, v1143
            local v1137 = arg84_1
            if up26 then
                v1143 = string.format
                v1142 = "%.1f"
                return v1143(v1142, v1137)
            else
                v1143 = tostring
                v1142 = math.floor
                v1140 = (v1137 + 0.5)

                return v1143(v1142(v1140))
            end
        end
        local up29 = v766
        v766 = up28
        local v775 = up80[up24]
        v766.Text = up29(v775)
        up28.TextColor3 = Color3.fromRGB(100, 40, 65)
        up28.Font = Enum.Font.GothamBold
        up28.TextSize = 13
        up28.TextXAlignment = Enum.TextXAlignment.Right
        local v772 = Instance.new("UICorner", up28)
        v772.CornerRadius = UDim.new(0, 6)
        v772 = Instance.new("Frame", v770)
        local up30 = v772
        up30.Size = UDim2.new(1, -20, 0, 10)
        up30.Position = UDim2.new(0, 10, 0, 30)
        up30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        up30.BackgroundTransparency = .3
        v772 = Instance.new("UICorner", up30)
        v772.CornerRadius = UDim.new(1, 0)
        v772 = Instance.new("Frame", up30)
        local up31 = v772
        up31.Size = UDim2.new((math.clamp(((up80[up24] - up25) / (up27 - up25)), 0, 1)), 0, 1, 0)
        up31.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
        up31.BackgroundTransparency = .05
        v772 = Instance.new("UICorner", up31)
        v772.CornerRadius = UDim.new(1, 0)
        v766 = function(arg85_1)
            local v1146 = math.clamp(arg85_1, up25, up27)
            if up26 then
                v1146 = ((math.floor(((v1146 * 10) + 0.5))) / 10)
            else
                v1146 = (math.floor((v1146 + 0.5)))
            end
            up80[up24] = v1146
            up28.Text = up29(v1146)
            up31.Size = UDim2.new(((v1146 - up25) / (up27 - up25)), 0, 1, 0)
            up91()
            return
        end
        local up32 = v766
        v766 = up28.FocusLost
        local v776 = function()
            local v1160, v1165
            local v1166 = (tonumber(up28.Text))
            if v1166 then
                up32(v1166)
            else
                v1160 = up28
                v1165 = up29(up80[up24])
                v1160.Text = v1165
            end
            return
        end
        v766:Connect(v776)
        local up33 = false
        v766 = up30.InputBegan
        local v777 = function(arg87_1)
            local v1167, v1170, v1173
            local up47 = arg87_1
            local v1175 = (up47.UserInputType == Enum.UserInputType.MouseButton1)
            local v1176 = v1175
            if not (v1175) then
                v1176 = (up47.UserInputType == Enum.UserInputType.Touch)
            end
            if v1176 then
                up33 = true
                v1175 = math.clamp(((up47.Position.X - up30.AbsolutePosition.X) / up30.AbsoluteSize.X), 0, 1)
                v1170 = up27
                v1173 = up25
                up32((up25 + ((v1170 - v1173) * v1175)))
                v1176 = up47.Changed
                v1167 = function()
                    local v1011 = up47.UserInputState
                    local v1010 = Enum.UserInputState
                    if (v1011 == v1010["End"]) then
                        up33 = false
                    end
                    return
                end
                v1176:Connect(v1167)
            end
            return
        end
        v766:Connect(v777)
        v766 = up83.InputChanged
        v777 = function(arg88_1)
            local v1192
            local v1181 = arg88_1
            local v1182 = up33
            local v1183 = v1182
            if v1182 then
                v1192 = (v1181.UserInputType == Enum.UserInputType.MouseMovement)
                v1182 = v1192
                if not (v1192) then
                    v1182 = (v1181.UserInputType == Enum.UserInputType.Touch)
                end
                v1183 = v1182
            end
            if v1183 then
                v1183 = math.clamp(((v1181.Position.X - up30.AbsolutePosition.X) / up30.AbsoluteSize.X), 0, 1)
                up32((up25 + ((up27 - up25) * v1183)))
            end
            return
        end
        v766:Connect(v777)

        return v770
    end
    v1369 = function(arg51_1, arg51_2)
        local v788 = (Instance.new("Frame", arg51_1))
        v788.Size = UDim2.new(1, 0, 0, 16)
        v788.BackgroundTransparency = 1
        v788.LayoutOrder = (arg51_2 or 0)
        local v785 = Instance.new("Frame", v788)
        v785.Size = UDim2.new(1, 0, 0, 2)
        v785.Position = UDim2.new(0, 0, 0.5, -1)
        v785.BackgroundColor3 = Color3.fromRGB(255, 175, 205)
        v785.BackgroundTransparency = .2
        local v786 = Instance.new("UICorner", v785)
        v786.CornerRadius = UDim.new(1, 0)

        return v788
    end
    v1373 = function(arg52_1, arg52_2, arg52_3)
        local v795 = (Instance.new("Frame", arg52_1))
        v795.Size = UDim2.new(1, 0, 0, 38)
        v795.BackgroundTransparency = 1
        v795.LayoutOrder = (arg52_3 or 0)
        local v798 = Instance.new("TextLabel", v795)
        v798.Size = UDim2.new(1, -50, 1, 0)
        v798.Position = UDim2.new(0, 10, 0, 0)
        v798.BackgroundTransparency = 1
        v798.Text = arg52_2
        v798.TextColor3 = Color3.fromRGB(100, 40, 65)
        v798.Font = Enum.Font.GothamMedium
        v798.TextSize = 13
        v798.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(up131, {["Obj"] = v798, ["BaseSize"] = 13})
        local v799 = Instance.new("TextButton", v795)
        local up34 = v799
        up34.Size = UDim2.new(0, 36, 0, 24)
        up34.Position = UDim2.new(1, -46, 0.5, -12)
        up34.BackgroundColor3 = up80.CircleColor
        up34.Text = ""
        v799 = Instance.new("UICorner", up34)
        v799.CornerRadius = UDim.new(0, 6)
        v799 = Instance.new("UIStroke", up34)
        v799.Color = Color3.fromRGB(255, 255, 255)
        local v802 = Instance.new("Frame", up115)
        local up35 = v802
        up35.Size = UDim2.new(0, 180, 0, 130)
        up35.Position = UDim2.new(1, 10, 0, 0)
        up35.BackgroundColor3 = Color3.fromRGB(240, 215, 225)
        up35.Visible = false
        up35.ZIndex = 30
        v802 = Instance.new("UICorner", up35)
        v802.CornerRadius = UDim.new(0, 10)
        v802 = Instance.new("UIStroke", up35)
        v802.Color = Color3.fromRGB(255, 255, 255)
        local v806 = Color3.fromRGB(255, 182, 193)
        local v803 = Color3.fromRGB(255, 105, 180)
        local v804 = Color3.fromRGB(255, 0, 0)
        local v807 = Color3.fromRGB(255, 128, 0)
        local v808 = Color3.fromRGB(255, 255, 0)
        local v809 = Color3.fromRGB(0, 255, 0)
        local v810 = Color3.fromRGB(0, 255, 255)
        local v811 = Color3.fromRGB(0, 191, 255)
        local v812 = Color3.fromRGB(0, 0, 255)
        local v813 = Color3.fromRGB(138, 43, 225)
        local v814 = Color3.fromRGB(255, 0, 255)
        local v815 = Color3.fromRGB(255, 255, 255)
        local v816 = Color3.fromRGB(128, 128, 128)
        local v805 = {v806, v803, v804, v807, v808, v809, v810, v811, v812, v813, v814, v815, v816, Color3.fromRGB(0, 0, 0)}
        v806 = Instance.new("UIGridLayout", up35)
        v806.CellSize = UDim2.new(0, 28, 0, 28)
        v806.CellPadding = UDim2.new(0, 5, 0, 5)
        v806.HorizontalAlignment = Enum.HorizontalAlignment.Center
        v807 = Enum
        v806.VerticalAlignment = v807.VerticalAlignment.Center
        local v797 = ipairs
        for v807, v809 in v797(v805) do
            local up36 = v809
            v810 = Instance.new("TextButton", up35)
            v810.BackgroundColor3 = up36
            v810.Text = ""
            v810.ZIndex = 31
            v811 = Instance.new("UICorner", v810)
            v813 = UDim.new(0, 6)
            v811.CornerRadius = v813
            v797 = v810.MouseButton1Click
            v811 = v797.Connect
            v812 = function()
                up80.CircleColor = up36
                up34.BackgroundColor3 = up36
                up35.Visible = false
                up91()
                return
            end
            v809 = nil
            v811(v797, v812)
        end
        v797 = up34.MouseButton1Click
        v804 = function()
            up35.Visible = (not up35.Visible)

            return
        end
        v797:Connect(v804)

        return v795
    end
    v1371 = function(arg53_1, arg53_2, arg53_3, arg53_4)
        local up37 = arg53_3
        local v826 = (Instance.new("Frame", arg53_1))
        v826.Size = UDim2.new(1, 0, 0, 38)
        v826.BackgroundTransparency = 1
        v826.LayoutOrder = (arg53_4 or 0)
        local v823 = Instance.new("TextLabel", v826)
        v823.Size = UDim2.new(0.5, 0, 1, 0)
        v823.Position = UDim2.new(0, 10, 0, 0)
        v823.BackgroundTransparency = 1
        v823.Text = arg53_2
        v823.TextColor3 = Color3.fromRGB(100, 40, 65)
        v823.Font = Enum.Font.GothamMedium
        v823.TextSize = 13
        v823.TextWrapped = true
        v823.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(up131, {["Obj"] = v823, ["BaseSize"] = 13})
        local v824 = Instance.new("TextBox", v826)
        local up38 = v824
        up38.Size = UDim2.new(.45, 0, 1, 0)
        up38.Position = UDim2.new(0.5, 0, 0, 0)
        up38.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        up38.BackgroundTransparency = 0.25
        up38.Text = tostring(up80.TargetAim[up37])
        up38.TextColor3 = Color3.fromRGB(100, 40, 65)
        up38.ClearTextOnFocus = false
        up38.Font = Enum.Font.GothamMedium
        up38.TextSize = 13
        up38.TextWrapped = true
        table.insert(up131, {["Obj"] = up38, ["BaseSize"] = 13})
        v824 = Instance.new("UICorner", up38)
        v824.CornerRadius = UDim.new(0, 10)
        v824 = Instance.new("UIStroke", up38)
        v824.Color = Color3.fromRGB(255, 255, 255)
        v824.Transparency = .3
        local v822 = up38.FocusLost
        local v829 = function()
            local v316, v321
            local v322 = (tonumber(up38.Text))
            if v322 then
                v316 = up80.TargetAim
                v316[up37] = v322
                v316 = up38
                v321 = tostring(v322)
                v316.Text = v321
                up91()
            else
                v316 = up38
                v321 = tostring(up80.TargetAim[up37])
                v316.Text = v321
            end
            return
        end
        v822:Connect(v829)

        return v826
    end
    v1369(up132, 1)
    v1370(up132, ("Enabled: " .. up80.Enabled and "On" or "Off"), function(arg21_1)
        local v416 = up80
        local v417 = arg21_1
        local v420 = up80.Enabled
        v416.Enabled = (not v420)
        v416 = up80.TargetAim
        v416.Enabled = up80.Enabled
        v420 = up80.Enabled and "On" or "Off"
        v417.Text = ("Enabled: " .. v420)
        up91()
        return
    end, 2)
    v1370(up132, ("Lock Type: " .. up80.TargetAim["Lock Type"]), function(arg22_1)
        local v438
        local v435 = up80.TargetAim
        local v436 = arg22_1
        local v437 = v435["Lock Type"]
        if (v437 == "Namecall") then
            v438 = up80.TargetAim
            v438["Lock Type"] = "Index"
        else
            v438 = up80.TargetAim
            v438["Lock Type"] = "Namecall"
        end
        local v430 = up80.TargetAim["Lock Type"]
        v436.Text = ("Lock Type: " .. v430)
        up91()
        return
    end, 3)
    v1371(up132, "Prediction", "Prediction", 4)
    v1369(up132, 5)
    v1372(up132, "Circle Size", "Size", 30, 400, false, 6)
    v1372(up132, "Circle Thickness", "Thickness", 1, 15, false, 7)
    v1372(up132, "Transparency", "Transparency", 0, 1, true, 8)
    v1373(up132, "Circle Color", 9)
    v1370(up132, ("Filled: " .. up80.Filled and "On" or "Off"), function(arg56_1)
        local v847 = up80
        local v848 = arg56_1
        local v851 = up80.Filled
        v847.Filled = (not v851)
        v851 = up80.Filled and "On" or "Off"
        v848.Text = ("Filled: " .. v851)
        up91()
        return
    end, 10)
    v1370(up132, ("Position: " .. up80.Position), function(arg57_1)
        local v867 = {"Mouse", "Center", "Crosshair"}
        local v862 = ((table.find(v867, up80.Position)) or 1)
        up80.Position = v867[((v862 % (#v867)) + 1)]
        local v866 = up80.Position
        arg57_1.Text = ("Position: " .. v866)
        up91()
        return
    end, 11)
    v1375 = up100.Creator .Name
    local up136 = (v1375 == "Hood Customs Entertainment")
    v1377 = function()
        local v877
        local v873 = game:GetService("MarketplaceService")
        local v875 = game
        local v878 = v873:GetProductInfo(v875.PlaceId)
        v873 = v878
        if v878 then
            v877 = v878.Creator
            v875 = v877
            if v877 then
                v875 = (v878.Creator.Name == "Hood Customs Entertainment")
            end
            v873 = v875
        end
        if v873 then
            up136 = true
        end
        return
    end
    pcall(v1377)
    if up136 then
        local up137
        local up138 = "rbxassetid://70883871260184"
        local up139 = .1265
        local up141
        local up140 = false
        local up142
        v1381 = function()
            if up142 then
                up142:Stop()
                up142:Destroy()
                up142 = nil
            end
            if up141 then
                up141:Disconnect()
                up141 = nil
            end
            if up137 then
                up137:Disconnect()
                up137 = nil
            end
            return
        end
        spilledValues1.value15 = function()
            local v912 = up88.Character
            local v913 = v912
            if not (v912) then
                v913 = (up88.CharacterAdded:Wait())
            end
            v912 = v913
            v913 = "Humanoid"
            return v912:WaitForChild(v913)
        end
        up141 = nil
        up137 = nil
        local up143 = spilledValues1.value15
        local up144
        spilledValues1.value13 = function()
            up144()
            return
        end
        up144 = v1381
        local up145
        up145 = function()
            local v917, v918, v920, v921, v922
            if (not up140) then
                return
            else
                v918 = (up143())
                if (not v918) then
                    return
                else
                    up144()
                    v922 = (Instance.new("Animation"))
                    v922.AnimationId = up138
                    up142 = (v918:LoadAnimation(v922))
                    up142:Play(0, 1, 1)
                    v917 = up82.Heartbeat
                    v920 = function()
                        local v330, v332
                        local v331 = up142 and up140
                        if v331 then
                            v332 = up142
                            v330 = up139
                            v332.TimePosition = v330
                            up142:AdjustSpeed(0)
                        end
                        return
                    end
                    v917:Connect(v920)
                    v921 = function(arg14_1)
                        local v335 = up140
                        local v336 = arg14_1
                        local v337 = v335
                        if v335 then
                            v337 = up142 and (v336 ~= up142)
                        end
                        if v337 then
                            task.delay((.02 + ((math.random()) * .03)), up145)
                        end
                        return
                    end
                    v918.AnimationPlayed:Connect(v921)
                    return
                end
            end
        end
        local up146 = spilledValues1.value13
        v1369(up132, 12)
        v1370(up132, "God Mode: OFF", function(arg65_1)
            local v925 = arg65_1
            up140 = (not up140)
            if up140 then
                up145()
                v925.Text = "God Mode: ON"
            else
                up146()
                v925.Text = "God Mode: OFF"
            end
            return
        end, 13)
        spilledValues1.value13 = up88.CharacterAdded
        spilledValues1.value14 = function()
            task.wait(0.25)
            if up140 then
                up145()
            end
            return
        end
        spilledValues1.value13:Connect(spilledValues1.value14)
    end
    v1376 = up100.Creator.Name
    local up147 = (v1376 == "Da Hood Entertainment")
    pcall(function()
        local v895
        local v891 = game:GetService("MarketplaceService")
        local v893 = game
        local v896 = v891:GetProductInfo(v893.PlaceId)
        v891 = v896
        if v896 then
            v895 = v896.Creator
            v893 = v895
            if v895 then
                v893 = (v896.Creator.Name == "Da Hood Entertainment")
            end
            v891 = v893
        end
        if v891 then
            up147 = true
        end
        return
    end)
    if up147 then
        local up148 = false
        v1378 = function()
            local v1218 = up88.Character
            local v1219 = v1218
            if not (v1218) then
                v1219 = (up88.CharacterAdded:Wait())
            end
            local up48 = v1219
            local v1217 = up48:FindFirstChildOfClass("Humanoid")
            v1219 = v1217
            if not (v1217) then
                v1219 = (up48:WaitForChild("Humanoid", 10))
            end
            local up49 = v1219
            v1217 = up49.RootPart
            v1219 = v1217
            if not (v1217) then
                v1219 = (up48:WaitForChild("HumanoidRootPart", 10))
            end
            local up50 = v1219
            local v1222 = workspace.CurrentCamera
            local up52 = v1222
            local up51 = (up48:GetPivot())
            v1222 = up52.CFrame
            local up53 = v1222
            v1219 = up49
            v1222 = v1219.SeatPart
            local up55 = v1222
            local up54 = function()
                local v527, v528, v529, v530, v531, v532
                if (not up148) then
                    return
                else
                    v527 = up48
                    v528 = v527
                    if v527 then
                        v528 = up49 and up50
                    end
                    if (not v528) then
                        return
                    else
                        up48:PivotTo(up51)
                        v530 = up52
                        v530.CFrame = up53
                        v531 = up55
                        v528 = v531
                        if v531 then
                            v528 = up55.Parent
                        end
                        if v528 then
                            v530 = up48
                            v531 = up55.Parent
                            v532 = v531.GetPivot
                            v530:PivotTo(v532(v531))
                            task.spawn(function()
                                local v514, v515, v516, v522
                                while true do
                                    v514 = up148
                                    v515 = v514
                                    if v514 then
                                        v516 = up55
                                        v514 = v516
                                        if v516 then
                                            v522 = up55.Parent
                                            v516 = v522
                                            if v522 then
                                                v516 = (up55.Occupant == nil)
                                            end
                                            v514 = v516
                                        end
                                        v515 = v514
                                    end
                                    if v515 then
                                        task.spawn(up55.Sit , up55, up49)
                                        task.wait()
                                    else
                                        break
                                    end
                                end
                                return
                            end)
                        end
                        while true do
                            v531 = up148
                            v528 = v531
                            if v531 then
                                v528 = (up48:FindFirstChildOfClass("ForceField"))
                            end
                            if v528 then
                                v531 = function()
                                    replicatesignal(up88.ConnectDiedSignalBackend)

                                    return
                                end
                                pcall(v531)
                                task.wait()
                            else
                                break
                            end
                        end
                        up48:GetPivot()
                        v530 = up52.CFrame
                        up55 = up49.SeatPart
                        v529 = function()
                            replicatesignal(up88.Kill)

                            return
                        end
                        pcall(v529)
                        task.wait(1)

                        return
                    end
                end
            end
            v1222 = up88.CharacterAdded
            local v1223 = function(arg32_1)
                local v544
                local v536 = up148
                local v537 = arg32_1
                if (not v536) then
                    return
                else
                    up48 = v537
                    v544 = up48:FindFirstChildOfClass("Humanoid")
                    v536 = v544
                    if not (v544) then
                        v536 = (up48:WaitForChild("Humanoid", 10))
                    end
                    up49 = v536
                    v544 = up49.RootPart
                    if not (v544) then
                        up48:WaitForChild("HumanoidRootPart", 10)
                    end
                    up54()
                    return
                end
            end
            v1222:Connect(v1223)

            return
        end
        local up149 = v1378
        v1369(up132, 14)
        v1370(up132, "God Mode (Da Hood): OFF", function(arg91_1)
            up148 = (not up148)
            local v1227 = up148
            local v1229 = arg91_1
            if v1227 then
                v1229.Text = "God Mode (Da Hood): ON"
                up149()
            else
                v1229.Text = "God Mode (Da Hood): OFF"
            end
            return
        end, 15)
    end
    v1378 = up133
    v1374 = function(arg77_1, arg77_2, arg77_3, arg77_4)
        local v1030, v1031, v1032, v1033, v1035
        local v1023 = arg77_1
        local up42 = arg77_3
        local up41 = arg77_4
        local v1025 = ipairs
        for v1027, v1029 in v1025(arg77_2) do
            local up43 = v1029
            v1030 = Instance.new("TextButton", v1023)
            local up44 = v1030
            v1025 = up44
            v1032 = UDim2.new(1, 0, 0, 38)
            v1025.Size = v1032
            v1025 = up44
            v1032 = Color3.fromRGB(255, 255, 255)
            v1025.BackgroundColor3 = v1032
            v1025 = up44
            v1025.BackgroundTransparency = 0.25
            v1025 = up44
            v1032 = Color3.fromRGB(100, 40, 65)
            v1025.TextColor3 = v1032
            v1025 = up44
            v1031 = Enum.Font.GothamMedium
            v1025.Font = v1031
            v1025 = up44
            v1025.TextSize = 13
            v1025 = up44
            v1025.TextWrapped = true
            v1025 = table.insert
            v1031 = up131
            v1035 = up44
            v1025(v1031, {["Obj"] = v1035, ["BaseSize"] = 13})
            v1030 = Instance.new("UICorner", up44)
            v1032 = UDim.new(0, 10)
            v1030.CornerRadius = v1032
            v1030 = Instance.new("UIStroke", up44)
            v1032 = Color3.fromRGB(255, 255, 255)
            v1030.Color = v1032
            v1030.Transparency = .3
            up125(up44, (Color3.fromRGB(255, 255, 255)), (Color3.fromRGB(255, 210, 230)), v1030, Color3.fromRGB (255, 255, 255))
            local up45 = function()
                local v357, v358, v359, v365, v368
                if up41 then
                    v357 = up44
                    v368 = table.find
                    v365 = up42
                    v359 = (v368(up80[v365], up43)) and "✓ " or "○ "
                    v358 = (v359 .. up43)
                    v357.Text = v358
                else
                    v357 = up44
                    v359 = up80.Checks[up43] and "✓ " or "○ "
                    v358 = (v359 .. up43)
                    v357.Text = v358
                end
                return
            end
            up45()
            v1025 = up44.MouseButton1Click
            v1033 = function()
                local v371, v372, v374, v375, v376
                if up41 then
                    v376 = table.find
                    v374 = up42
                    v371 = (v376(up80[v374], up43))
                    if v371 then
                        if ((#up80[up42]) > 1) then
                            table.remove(up80[up42], v371)
                        end
                    else
                        v376 = table.insert
                        v375 = up42
                        v376(up80[v375], up43)
                    end
                else
                    v376 = up80.Checks
                    v372 = up43
                    v371 = (not up80.Checks[up43])
                    v376[v372] = v371
                end
                up45()
                up91()
                return
            end
            v1029 = nil
            v1025:Connect(v1033)
        end
        return
    end
    v1374(v1378, {"Wall Check", "KO Check", "Forcefield Check", "Team Check", "Friend Check", "Vehicle Check", "Crew Check"}, "Checks", false)
    v1374(up134, {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, "SelectedParts", true)
    v1378 = Instance.new("TextButton", up115)
    v1380 = UDim2.new(0, 40, 0, 40)
    v1378.Size = v1380
    v1380 = UDim2.new(1, -40, 1, -40)
    v1378.Position = v1380
    v1378.BackgroundTransparency = 1
    v1378.Text = "◢"
    v1380 = Color3.fromRGB(140, 70, 95)
    v1378.TextColor3 = v1380
    v1378.TextSize = 16
    v1378.ZIndex = 20
    local up150 = false
    local up151
    local up152
    v1378.InputBegan:Connect(function(arg78_1)
        local v1054
        local up46 = arg78_1
        local v1044 = (not up124)
        local v1045 = v1044
        if v1044 then
            v1054 = (up46.UserInputType == Enum.UserInputType.MouseButton1)
            v1044 = v1054
            if not (v1054) then
                v1044 = (up46.UserInputType == Enum.UserInputType.Touch)
            end
            v1045 = v1044
        end
        if v1045 then
            up150 = true
            up151 = up46.Position
            up152 = up115.AbsoluteSize
            up46.Changed:Connect(function()
                local v987 = up46.UserInputState
                local v986 = Enum.UserInputState
                if (v987 == v986.End ) then
                    up150 = false
                end
                return
            end)
        end
        return
    end)
    v1380 = up83.InputChanged
    v1381 = function(arg79_1)
        local v1060, v1061, v1063, v1065, v1067, v1068, v1070, v1071, v1072
        local v1057 = arg79_1
        local v1058 = up150
        local v1059 = v1058
        if v1058 then
            v1061 = (not up124)
            v1058 = v1061
            if v1061 then
                v1070 = (v1057.UserInputType == Enum.UserInputType.MouseMovement)
                v1061 = v1070
                if not (v1070) then
                    v1061 = (v1057.UserInputType == Enum.UserInputType.Touch)
                end
                v1058 = v1061
            end
            v1059 = v1058
        end
        if v1059 then
            v1072 = (v1057.Position - up151)
            v1059 = math
            v1058 = v1072
            v1059 = v1059.clamp((up152.X + v1058.X), 265, 700)
            v1071 = v1059
            v1061 = (math.clamp((up152.Y + v1058.Y), 260, 750))
            v1072 = up115
            v1070 = UDim2.new (0, v1071, 0, v1061)
            v1072.Size = v1070
            v1060 = math.clamp ((v1071 / 365), .7, 1.35)
            v1059 = ipairs
            for v1065, v1063 in v1059(up131) do
                v1067 = v1063.Obj
                v1059 = v1067
                if v1067 then
                    v1059 = v1063.Obj.Parent
                end
                if v1059 then
                    v1059 = v1063.Obj
                    v1068 = math.clamp((math.floor(((v1063.BaseSize * v1060) + 0.5))), 8, 16)
                    v1059.TextSize = v1068
                end
            end
        end
        return
    end
    v1380:Connect(v1381)
    v1380 = up82.RenderStepped
    v1381 = function()
        local v1081, v1082, v1084, v1086, v1088
        if (not Silent) then
            v1081 = function()
                return Drawing.new("Circle")
            end
            v1082, v1084 = pcall(v1081)
            v1082 = (not v1082) or (not v1084)
            if v1082 then
                return
            else
                Silent = v1084
            end
        end
        Silent.Visible = up80.Enabled
        Silent.Radius = up80.Size
        Silent.Thickness = up80.Thickness
        Silent.Filled = up80.Filled
        Silent.Transparency = up80.Transparency
        v1082 = Silent
        local v1085 = up80
        v1082.Color = v1085.CircleColor
        v1084 = up80.Position
        if (v1084 == "Crosshair") then
            v1084 = up97.Crosshair
            v1082 = v1084 and v1084.Visible
            if v1082 then
                v1081 = v1084.AbsolutePosition
                v1085 = v1084.AbsoluteSize
                v1082 = Silent
                v1088 = Vector2.new((v1081.X + (v1085.X * 0.5)), ((v1081.Y + (v1085.Y * 0.5)) + up93.Y))
                v1082.Position = v1088
            else
                v1082 = Silent
                v1086 = up83:GetMouseLocation()
                v1082.Position = v1086
            end
        else
            v1084 = up80.Position
            if (v1084 == "Center") then
                v1082 = Silent
                v1081 = (up87.ViewportSize / 2)
                v1082.Position = v1081
            else
                v1082 = Silent
                v1085 = up83:GetMouseLocation()
                v1082.Position = v1085
            end
        end
        return
    end
    v1380:Connect(v1381)

    return
end
