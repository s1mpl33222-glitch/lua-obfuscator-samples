-- deobfuscated by SL | Source Leak | https://discord.gg/x7YbZeezpm

---@see https://discord.gg/hkQAMzyGum

local v1 = {}
local v2, v3, v4
local function getValue5()
    local v111
    if v3 or not v4 then
        return false
    else
        v111 = v2
    end
    local character = v111.Character
    v111 = character
    if character then
        v111 = character:FindFirstChildOfClass("Humanoid")
    end
    local backpack = v2:FindFirstChildOfClass("Backpack")
    local v112
    if character then
        v112 = character:FindFirstChild("BossSpear")
    else
        v112 = backpack
    end
    local fTD_Boss = workspace:FindFirstChild("FTD_Boss")
    local v113 = fTD_Boss and fTD_Boss:FindFirstChild("FTD_BossMosasaurus")
    local v114 = v111 ~= nil and 0 < v111.Health and v112 ~= nil and v113 ~= nil
    if v114 then
        return v113:FindFirstChild("B_Head", true) ~= nil
    else
        return v114
    end
end
local v5, v6, v7
local function getValue6()
    local v111 = v5 and not v3 and not v6
    if v111 then
        return not v7()
    else
        return v111
    end
end
local v8
local function getValue7()
    local v111 = v8 and not v3
    if v111 then
        return not v7()
    else
        return v111
    end
end
local function getValue8()
    local v111 = not v3
    if v111 then
        return v7()
    end
    return v111
end
local function processValues(v111)
end
local v9
local function computeValue2(v111, v112, v113, v114, v115, v116)
    local v117
    local function runProtected()
        if not pcall(function()
        end) then
            v9 = true
        end
        v117 = true
    end
    v117 = v112
    local v118
    if v117 then
        v112()
        v117 = false
        return false
    else
        v118 = workspace
    end
    v117 = v118.StreamingEnabled and not v9
    local v119, v120, v121
    if v117 then
        v117 = false
        v118 = math.min(v113 or 2, 2)
        v119 = os.clock(v116) + v118
        os.clock()
        v121 = v112()
        v120 = not v121
        if v120 then
            return false
        else
            v117 = v112(v118, v119, v120, v121)
            return v117
        end
    end
    v117 = not v112 or v112()
    return v117
end
local v10
local function processItems2()
    local v111 = v10.SpawnPoints or {}
    local v112, v113
    v112, v113 = next(v111, nil)
    local v114, v115, lower, lower2, pos
    if not (v112 == nil) then
        v114 = v112
        while true do
            v115 = type(v113) == "table" and v113.Name or ""
            lower = string.lower(tostring(v112))
            lower2 = string.lower(tostring(v115))
            if lower == "home" or lower == "plaza" or lower2 == "home" or lower2 == "plaza" then
                type(v113)
                pos = v113.Pos
                if typeof(pos) ~= "Vector3" then
                    v112, v113 = next(v111, v114)
                    if v112 ~= nil then
                        v114 = v112
                        continue
                    end
                    return nil
                end
                return pos
            end
            v112, v113 = next(v111, v114)
            if v112 ~= nil then
                v114 = v112
                continue
            end
            break
        end
    end
    return nil
end
local v11, v12
local function processItems3()
    local map = workspace:FindFirstChild("Map")
    local plaza
    local floor
    if map then
        plaza = map:FindFirstChild("Plaza")
        if plaza then
            floor = plaza:FindFirstChild("Floor")
        else
            return nil
        end
    else
        return nil
    end
    local v111, v112, v113, v114, v115
    while true do
        while true do
            if floor then
                v113 = "Model"
                v112 = floor
                v111 = floor:IsA("Model")
                if not v111 then
                    v113 = "BasePart"
                    v112 = floor
                    v111 = floor.IsA(v112, "BasePart")
                    goto __x8
                end
                goto __x8
            else
                return nil
            end
            ::__x6::
            v11 = v111
            v115 = "Model"
            v114 = floor
            v113 = floor.IsA
            do
                break
            end
            ::__x8::
            if v111 then
                v113 = floor
                v112 = floor.GetPivot(v113)
                v111 = v112.Position
                goto __x6
            else
                return nil
            end
        end
    end
    v113 = v113(v114, v115)
    local v116
    if not v113 then
        v111 = floor.CFrame
        v116 = floor.Size.Y / 2
        v114 = CFrame.new(0, v116, 0)
    elseif floor:FindFirstChildWhichIsA("BasePart", true) then
        v113, v114 = floor:GetBoundingBox()
        v111 = v113
        v116 = v114.Y / 2
        v114 = CFrame.new(0, v116, 0)
    else
        return nil
    end
    v12 = v111 * v114
    return floor
end
local function processItems4()
    if not v3 then
        while not v3 do
        end
    end
end
local v13
local function processItems5(v111)
    local v112 = v13
    v13 = nil
    local v113, root, v114, v115, v116
    if v112 then
        v113, root, v114 = pairs(v112.collisions)
        v115, v116 = v113(root, v114)
        if not (v115 == nil) then
            v114 = v115
            while true do
                if v115.Parent then
                    v115.CanCollide = v116
                end
                v115, v116 = v113(root, v114)
                if v115 ~= nil then
                    v114 = v115
                    continue
                end
                break
            end
        end
        root = v112.root
        return v111, v112, root.Parent, root, v115, v115, v116
    end
end
local v14, v15
local function processItems6(v111, parent, v112, v113)
    local v114
    local function isInstanceOf2(v122)
        local isA = v122:IsA("BasePart")
        local canCollide
        if isA then
            if v114.collisions[v122] == nil then
                canCollide = v122.CanCollide
                v114.collisions[v122] = canCollide
            end
            v122.CanCollide = false
            return
        else
            return v122, isA
        end
    end
    local function onDied()
    end
    local function onPreSimulation()
        local v122, v123, v124, v125
        if v13 == v114 then
            if not (v2.Character ~= v111 or not parent.Parent or v112.Health <= 0) then
                v14()
                v122, v123, v124 = pairs(v114.collisions)
                v125 = v122(v123, v124)
                if not (v125 == nil) then
                    v124 = v125
                    while true do
                        if v125:IsDescendantOf(v111) then
                            v125.CanCollide = false
                        else
                            v114.collisions[v125] = nil
                        end
                        v125 = v122(v123, v124)
                        if v125 ~= nil then
                            v124 = v125
                            continue
                        end
                        break
                    end
                end
                parent.AssemblyLinearVelocity = Vector3.zero
                parent.AssemblyAngularVelocity = Vector3.zero
                v123 = v114
                return v123.target, v123, Vector3, v125
            end
        end
    end
    v114 = v13 and v13.character ~= v111
    local v116, v117, v118, v119, v120
    if v114 then
        local v121 = {character = v111, root = parent, humanoid = v112, anchored = parent.Anchored}
        v121.collisions = {}
        v121.target = parent.CFrame
        v114 = v121
        v116, v117, v118 = ipairs(v111:GetDescendants())
        v119, v120 = v116(v117, v118)
        if not (v119 == nil) then
            v118 = v119
            while true do
                v119, v120 = v116(v117, v118)
                if v119 ~= nil then
                    v118 = v119
                    continue
                end
                break
            end
        end
        v114.added = v111.DescendantAdded:Connect(isInstanceOf2)
        v114.died = v112.Died:Connect(onDied)
        v114.attachment = Instance.new("Attachment")
        v114.attachment.Name = "IoneDigHold"
        v114.attachment.Parent = parent
        v114.positionLock = Instance.new("AlignPosition")
        v114.positionLock.Name = "IoneDigPosition"
        v117 = Enum.PositionAlignmentMode.OneAttachment
        v114.positionLock.Mode = v117
        v117 = v114.attachment
        v114.positionLock.Attachment0 = v117
        v114.positionLock.ApplyAtCenterOfMass = true
        v114.positionLock.RigidityEnabled = true
        v114.positionLock.MaxForce = 1000000
        v117 = parent.Position
        v114.positionLock.Position = v117
        v114.positionLock.Parent = parent
        v13 = v114
        v114.physics = game:GetService("RunService").PreSimulation:Connect(onPreSimulation)
    end
    v114 = v13
    v114.surface = CFrame.new(v113 + Vector3.new(0, 4, 3)) * parent.CFrame.Rotation
    parent.Anchored = false
    v114 = CFrame.new(v113 - Vector3.new(0, v15, 0)) * parent.CFrame.Rotation
    v13.target = v114
    v13.positionLock.Position = v114.Position
    v117 = v114 * parent.CFrame:ToObjectSpace(v111:GetPivot())
end
local function performTask4()
end
local function getValue9()
    local digSites = workspace:FindFirstChild("DigSites")
    if digSites then
        return digSites:GetChildren()
    else
        return {}
    end
end
local v16
local function getAttribute3()
    local v111, v112, v113
    v111, v112, v113 = ipairs(v16())
    local v114, v115
    v114, v115 = v111(v112, v113)
    local v116 = {}
    local island, v117
    if not (v114 == nil) then
        v113 = v114
        local v118 = {}
        while true do
            island = v115:GetAttribute("Island")
            if island ~= nil then
                v115:GetAttribute("SiteId")
                v117 = tostring(island)
                if not v118[v117] then
                    v118[v117] = true
                end
                v114, v115 = v111(v112, v113)
                if not (v114 == nil) then
                    v113 = v114
                    continue
                end
            else
                v114, v115 = v111(v112, v113)
                if v114 == nil then
                    break
                else
                    v113 = v114
                    continue
                end
            end
            return v116
        end
    end
    return v116
end
local function processItems7(v111)
    local function getAttribute2(v118, v119)
        local siteId = v118:GetAttribute("SiteId")
        local siteId2 = v119:GetAttribute("SiteId")
        if tonumber(siteId) and tonumber(siteId2) then
            return tonumber(siteId) < tonumber(siteId2)
        else
            return tostring(siteId) < tostring(siteId2)
        end
    end
    local v112, v113, v114
    v112, v113, v114 = ipairs(v16())
    local v115, v116
    v115, v116 = v112(v113, v114)
    local v117 = {}
    if not (v115 == nil) then
        v114 = v115
        while true do
            if v116:IsA("Model") or v116:IsA("BasePart") then
                v116:GetAttribute("SiteId")
                tostring(v116:GetAttribute("Island"))
                v116:GetAttribute("Busy")
                v115, v116 = v112(v113, v114)
                if not (v115 == nil) then
                    v114 = v115
                    continue
                end
            else
                v115, v116 = v112(v113, v114)
                if v115 == nil then
                    break
                else
                    v114 = v115
                    continue
                end
            end
            return v117
        end
    end
    return v117
end
local v17
local function transformValue2(v111)
    local v112 = v14()
    if v112 then
        return v17 == v111
    else
        return v112
    end
end
local v18
local function processItems8(v111, v112, v113, v114, v115)
    local v116 = os.clock() + v111
    local v117 = v18(v112)
    while true do
        if v117 then
            os.clock(v115)
            v117 = v18(v112)
            continue
        else
            break
        end
    end
    return v18(v112)
end
local v19, v20, v21, v22
local function getAttribute4(v111, v112)
    local v113
    local function getValue4()
        local v128 = v18(v112)
        if v128 then
            return 0 < v113.Health
        else
            return v128
        end
    end
    local v114
    local function updateState2(v128)
        local v129
        if v114 then
            v129 = type(v128) ~= "table"
        end
    end
    local v115
    local function tryOperation7(v128, v129, v130)
        local invokeServer = v19.DigRequest:InvokeServer(v111:GetAttribute("SiteId"))
        v115 = invokeServer.session
        local v131, v132
        if not v18(v112) then
            return invokeServer
        else
            v114 = true
            v131 = os.clock(v130) + 8
            v132 = v18(v112)
            while true do
                if v132 then
                    os.clock()
                    v132 = v18(v112)
                    continue
                else
                    break
                end
            end
            return invokeServer, v131
        end
    end
    local v116, v117, v118, v119, v120, v121, v122, v123, v124
    while true do
        v113 = v18(v112)
        v116 = not v113
        if v116 then
            return v111, v112, v116, v113
        else
            v117 = "Busy"
            v113 = v111
            v116 = v111.GetAttribute
        end
        v116 = v116(v113, v117)
        while true do
            if v116 then
                return v111, v112, v116
            else
                v116 = v2.Character
                v113 = v116
                if v113 then
                    v117 = v116
                    v113 = v116.FindFirstChildOfClass
                    if v120 then
                        return v111, v112, v116, v113, v117, "Humanoid", v119
                    else
                        v114 = v119
                        v119.IsA(v114, "Tool")
                        v118 = not v117
                    end
                else
                    v117 = v116
                    if v117 then
                        v117 = v116.FindFirstChild
                        v118 = v2
                        v119 = v118
                        v118 = v118.FindFirstChildOfClass
                    else
                        v118 = not v117
                        goto __x61
                    end
                end
            end
            ::__x13::
            while true do
                v119 = v116:FindFirstChild("Shovel")
                if not v119 then
                    return v111, v112, v116, v113, v117, v118, v118
                end
            end
            v120 = not v119
            v115 = v115(v123, v124)
            tostring(v115)
            v114 = v21
            v115 = getValue4
            v114 = v114(v120, v115)
            v121 = not v114
            if v121 then
                return v111, v112, v116, v113, v117, v118, v119, v120, v121, v114
            else
                v114 = v111.Parent
                v114 = v111
                v111.GetAttribute(v114, "Busy")
                v114 = "Digging site "
                v115 = v111.GetAttribute
                v115 = v115(v111, "SiteId")
                tostring(v115)
                break
            end
            ::__x61::
            if v120 then
                return v111, v112, v116, v113, v117, v118, v119
            else
                v122 = "Tool"
                v114 = v119
                v121 = v119.IsA
            end
            if v117 then
                v117 = v116.FindFirstChild
            elseif not v117 then
                break
            end
            v118 = not v113
            if not v118 then
                v119 = v113.Health
                v120 = 0
                goto __x13
            end
            break
        end
        if v118 then
            return v111, v112, v116, v113, v117
        else
            v118 = v2
            v120 = "Backpack"
            v119 = v118
            v118 = v118.FindFirstChildOfClass
        end
    end
    v121 = v20
    v114 = "Under"
    local v125, v126, v127
    while true do
        if v121 ~= v114 then
            v114 = false
            v115 = CFrame
            v122 = v115.lookAt
            v115 = v120 + Vector3.new(0, 3, 3)
            v122 = v122(v115, v120 + Vector3.new(0, 3, 0))
        end
        v114 = Vector3
        v117.AssemblyLinearVelocity = v114.zero
        v117.AssemblyAngularVelocity = v114.zero
        v114 = v22
        v115 = v112
        v114 = v114(0.65, v112)
        v121 = not v114
        if v121 then
            return v111, v112, v116, v113, v117, v118, v119, v120, v121, v114
        else
            v114 = v111.Parent
            v121 = not v114
        end
        if not v121 then
            v114 = v111
            v111.GetAttribute(v114, "Busy")
            v114 = false
            v115 = nil
            v111:GetAttribute("SiteId")
            v124 = v19.DigResult.OnClientEvent
            v125 = v124
            v124 = v124.Connect
            v124 = v124(v125, updateState2)
            v125, v126 = pcall(tryOperation7)
            if not v125 then
                v127 = "Retrying: " .. tostring(v126)
            end
            return false
        end
    end
end
local v23
local function processItems9()
    local v111 = next
    local v112 = v23
    local v113, v114
    v113, v114 = next(v23, nil)
    local v115
    if not (v113 == nil) then
        if v113.Parent then
            v113.LocalTransparencyModifier = v114
        end
        v113, v114 = v111(v112, v113)
        v115 = v113
        while true do
            if v113.Parent then
                v113.LocalTransparencyModifier = v114
            end
            v113, v114 = v111(v112, v115)
            if v113 ~= nil then
                v115 = v113
                continue
            end
            break
        end
    end
end
local v24
local function processItems10(v111)
    v24 = v24 + v111
    local camera, character2, cFrame, v112, v113, v114, v115, v116, v117, v118, v119, v120
    if v24 >= 0.1 then
        v24 = 0
        camera = workspace.CurrentCamera
        character2 = v2.Character
        if not v14() then
            return v111, camera, character2
        else
            cFrame = camera.CFrame
            v113 = {}
            v116 = Vector3.new(0, 0, -25)
        end
        v114 = cFrame:PointToWorldSpace(v116)
        v115 = cFrame:PointToWorldSpace(Vector3.new(-8, 0, -25))
        v116 = cFrame:PointToWorldSpace(Vector3.new(8, 0, -25))
        v117 = cFrame:PointToWorldSpace(Vector3.new(0, 6, -25))
        v118 = cFrame:PointToWorldSpace(Vector3.new(0, -6, -25))
        v113[1] = v114
        v113[2] = v115
        v113[3] = v116
        v113[4] = v117
        v113[5] = v118
        v112 = v113
        v113 = character2:FindFirstChild("HumanoidRootPart")
        v114 = {}
        v115, v116, v117 = ipairs(camera:GetPartsObscuringTarget(v112, {[1] = character2}))
        v118, v119 = v115(v116, v117)
        if not (v118 == nil) then
            v117 = v118
            while true do
                if v119:IsA("BasePart") then
                    v114[v119] = true
                    v118, v119 = v115(v116, v117)
                    if not (v118 == nil) then
                        v117 = v118
                        continue
                    end
                else
                    v118, v119 = v115(v116, v117)
                    if v118 == nil then
                        break
                    else
                        v117 = v118
                        continue
                    end
                end
                break
            end
        end
        v115 = OverlapParams:new(v118, v118, v119)
        v115.FilterType = Enum.RaycastFilterType.Exclude
        v115.FilterDescendantsInstances = {[1] = character2}
        v116, v117, v118 = ipairs(workspace:GetPartBoundsInBox(cFrame, Vector3.new(4, 4, 4), v115))
        v119, v120 = v116(v117, v118)
        if v119 == nil then
            v119, v120 = next(v23, nil)
            v116 = next
            v117 = v114
            v118 = nil
        else
            v118 = v119
            while true do
                v114[v120] = true
                v119, v120 = next(v117, v118)
                if v119 == nil then
                    v116, v117, v118 = next(v23)
                    v119, v120 = v116(v117, v118)
                    v116 = next
                    v117 = v114
                    v118 = nil
                else
                    v114[v120] = true
                    v119, v120 = v116(v117, v119)
                    v118 = v119
                    continue
                end
                break
            end
        end
        v119 = next(v117, v118)
        if not (v119 == nil) then
            v118 = v119
            while true do
                if v23[v119] == nil then
                    v23[v119] = v119.LocalTransparencyModifier
                end
                v119.LocalTransparencyModifier = math.max(v23[v119], 0.8)
                v119 = next(v117, v118)
                if v119 ~= nil then
                    v118 = v119
                    continue
                end
                break
            end
        end
        return v111, camera, character2, cFrame, v112, v113, v114, v115, v116, v117, v119, v119
    end
end
local v25, v26
local function CallbackHandler(v111)
    if not (v26 or v3) then
        if v25 ~= v111 then
            v25 = v111
            v17 = v17 + 1
            return
        end
        return
    end
end
local function CallbackHandler2(v111)
    if v111 ~= "Normal" and v111 ~= "Under" then
        return
    elseif v111 ~= v20 then
        v20 = v111
        v17 = v17 + 1
        return v111
    else
        return
    end
end
local function CallbackHandler3(v111)
    v5 = v111
    v17 = v17 + 1
    if not v5 then
        return v111
    end
end
local v27
local function transformValue3(v111)
    local function performTask3()
    end
    if not (v3 or v27 == v111) then
        v27 = v111
        return
    end
end
local v28, v29
local function CallbackHandler4(v111, v112, v113, v119, ...)
    local v114
    local function checkCondition4()
    end
    local v115, v116, v117, v118
    while true do
        if not v3 then
            v115 = v29()
            v114 = v11
            if v114 then
                v11 = v114
                v114 = not v114
                return v115
            else
                v114 = v28(v113, v119, ...)
            end
            v11 = v114
            v114 = not v114
            if not v114 then
                v116 = v11 + Vector3.new(0, 80, 0)
            end
        end
        v117 = 0 + v118
        CFrame.new(0, v117, 0)
        v117 = v117.Set
        v118 = 2
    end
end
local v30, v31, v32, v33, v34
local function CallbackHandler5()
    local v111, v112, v113, v114, v115, v116
    local function checkCondition3()
        return not v3 and v33 == v111 and v17 == v112 and v31 == v113 and not v4 and v2.Character == v114 and v115.Parent ~= nil and 0 < v116.Health
    end
    v111 = v3
    local v117, v118, v119
    if not v111 then
        v33 = v33 + 1
        v111 = v33
        v114 = false
        v113 = v32
        v112 = v30
        if v112 then
            v114 = false
            v113 = v30
            v112 = v30.Set
        end
        v112 = v17
        v113 = v31
        v114 = v2.Character
        v115 = v114
        if v115 then
            v116 = v114
            v115 = v114:FindFirstChild("HumanoidRootPart")
            v116 = v114
            if v116 then
                v116 = v114:FindFirstChildOfClass("Humanoid")
            elseif not v115 or not v116 or v116.Health <= 0 then
                return v111, v112, v113, v114, v115
            else
                v21(v34.position, checkCondition3)
                v118 = v34.position
                v117 = CFrame.new(v118) * v115.CFrame.Rotation
                v119 = v117 * v115.CFrame:ToObjectSpace(v114:GetPivot())
                v115.AssemblyLinearVelocity = Vector3.zero
                v115.AssemblyAngularVelocity = Vector3.zero
                return v111, v112, v113, v114, v115, v116, v117
            end
        else
            v116 = v114
            if v116 then
                v116 = v114:FindFirstChildOfClass("Humanoid")
            elseif not v115 or not v116 or v116.Health <= 0 then
                return v111
            else
                v21(v34.position, checkCondition3)
                v118 = v34.position
                v117 = CFrame.new(v118) * v115.CFrame.Rotation
                v119 = v117 * v115.CFrame:ToObjectSpace(v114:GetPivot())
                v115.AssemblyLinearVelocity = Vector3.zero
                v115.AssemblyAngularVelocity = Vector3.zero
                return v111, v112, v113, v114, v115, v116, v117
            end
        end
        if not v115 or not v116 or v116.Health <= 0 then
            return v111, v112, v113, v114, v115, v116
        else
            v21(v34.position, checkCondition3)
            v118 = v34.position
            v117 = CFrame.new(v118) * v115.CFrame.Rotation
            v119 = v117 * v115.CFrame:ToObjectSpace(v114:GetPivot())
            v115.AssemblyLinearVelocity = Vector3.zero
            v115.AssemblyAngularVelocity = Vector3.zero
            return v111, v112, v113, v114, v115, v116, v117
        end
    end
end
local function CallbackHandler6(v111)
end
local function getValue10()
    local fTD_Boss2 = workspace:FindFirstChild("FTD_Boss")
    local fTD_BossMosasaurus
    if fTD_Boss2 then
        fTD_BossMosasaurus = fTD_Boss2:FindFirstChild("FTD_BossMosasaurus")
    end
    local v111 = fTD_BossMosasaurus
    if v111 then
        v111 = fTD_BossMosasaurus:FindFirstChild("B_Head", true)
    elseif not v111 then
        return nil
    else
        v111:IsA("Bone")
        v111:IsA("Attachment")
        v111:IsA("BasePart")
        v111:IsA("Model")
        return nil
    end
    if v111 then
        v111:IsA("Bone")
        v111:IsA("Attachment")
        v111:IsA("BasePart")
        v111:IsA("Model")
    end
    return nil
end
local v35
local function processItems11()
    local v111 = v35
    v35 = nil
    local v112, root2, v113, v114, v115
    if v111 then
        v112, root2, v113 = pairs(v111.collisions)
        v114, v115 = v112(root2, v113)
        if not (v114 == nil) then
            v113 = v114
            while true do
                if v114.Parent then
                    v114.CanCollide = v115
                end
                v114, v115 = v112(root2, v113)
                if v114 ~= nil then
                    v113 = v114
                    continue
                end
                break
            end
        end
        root2 = v111.root
        return v111, root2.Parent, root2, v114, v114, v115
    end
end
local function updateState3()
    v4 = false
end
local function CallbackHandler7(v111)
    local v112 = v111
    if v111 then
        v112 = not v3
    end
    v4 = v112
    if not v4 then
        return v111
    end
end
local v36, v37
local function processItems12(v111, v112, v113, v114, v115, v116, v132, ...)
    local v117
    local function isInstanceOf(v132)
        local isA2 = v132:IsA("BasePart")
        local canCollide2
        if isA2 then
            if v117.collisions[v132] == nil then
                canCollide2 = v132.CanCollide
                v117.collisions[v132] = canCollide2
            end
            v132.CanCollide = false
            return
        else
            return v132, isA2
        end
    end
    local v118 = v7()
    local v119 = v118
    if v118 then
        v119 = not v37
    end
    local v120 = {}
    local v121 = {}
    local v122, v123, v124, v125, v127, v128, v129, v130, v131
    if v119 then
        v17 = v17 + 1
        v31 = v31 + 1
        v37 = v118
        v119 = v2.Character
        v122 = v119
        if v122 then
            v122 = v119:FindFirstChild("HumanoidRootPart")
        else
            v123 = v119
            if v123 then
                v123 = v119:FindFirstChildOfClass("Humanoid")
                v124 = v4 and v36(v113, v114, v115, v116, v132, ...)
            else
                v124 = v4 and v36(v115, v116, v132, ...)
            end
            v125 = not v118 or not v122 or not v123
            if not v125 then
                v117 = v123.Health
                v125 = v117 <= 0
            end
            if not v125 then
                v125 = not v124
            end
            if v125 then
                return v118, v119, v122, v123, v124
            else
                v125 = v124 + Vector3.new(0, 3, 0)
                v117 = not v35
                if v117 then
                    v120.root = v122
                    v120.anchored = v122.Anchored
                    v120.collisions = v121
                    v117 = v120
                    v127, v128, v129 = ipairs(v119:GetDescendants())
                    v130, v131 = v127(v128, v129)
                    if not (v130 == nil) then
                        v129 = v130
                        while true do
                            v130, v131 = v127(v128, v129)
                            if v130 ~= nil then
                                v129 = v130
                                continue
                            end
                            break
                        end
                    end
                    v117.added = v119.DescendantAdded:Connect(isInstanceOf)
                    v117.attachment = Instance.new("Attachment")
                    v117.attachment.Name = "IoneBossHold"
                    v117.attachment.Parent = v122
                    v117.lock = Instance.new("AlignPosition")
                    v128 = Enum.PositionAlignmentMode.OneAttachment
                    v117.lock.Mode = v128
                    v128 = v117.attachment
                    v117.lock.Attachment0 = v128
                    v117.lock.ApplyAtCenterOfMass = true
                    v117.lock.RigidityEnabled = true
                    v117.lock.MaxForce = 1000000
                    v117.lock.Position = v125
                    v117.lock.Parent = v122
                    v122.Anchored = false
                    v129 = CFrame.new(v125) * v122.CFrame.Rotation * v122.CFrame:ToObjectSpace(v119:GetPivot())
                    v35 = v117
                    v117.lock.Position = v125
                    v117 = Vector3.zero
                    v122.AssemblyAngularVelocity = v117
                    return v118, v119, v122, v123, v124, v125, v117, Vector3
                else
                    v35.lock.Position = v125
                    v117 = Vector3.zero
                    v122.AssemblyAngularVelocity = v117
                    return
                end
            end
        end
    else
        v37 = v118
        v119 = v2.Character
        v122 = v119
        if v122 then
            v122 = v119:FindFirstChild("HumanoidRootPart")
        else
            v123 = v119
            if v123 then
                v123 = v119:FindFirstChildOfClass("Humanoid")
                v124 = v4 and v36(v113, v114, v115, v116, v132, ...)
            else
                v124 = v4 and v36(v116, v132, ...)
            end
            v125 = not v118 or not v122 or not v123
            if not v125 then
                v117 = v123.Health
                v125 = v117 <= 0
            end
            if not v125 then
                v125 = not v124
            end
            if v125 then
                return v118, v119, v122, v123, v124
            else
                v125 = v124 + Vector3.new(0, 3, 0)
                v117 = not v35
                if v117 then
                    v120.root = v122
                    v120.anchored = v122.Anchored
                    v120.collisions = v121
                    v117 = v120
                    v127, v128, v129 = ipairs(v119:GetDescendants())
                    v130, v131 = v127(v128, v129)
                    if not (v130 == nil) then
                        v129 = v130
                        while true do
                            v130, v131 = v127(v128, v129)
                            if v130 ~= nil then
                                v129 = v130
                                continue
                            end
                            break
                        end
                    end
                    v117.added = v119.DescendantAdded:Connect(isInstanceOf)
                    v117.attachment = Instance.new("Attachment")
                    v117.attachment.Name = "IoneBossHold"
                    v117.attachment.Parent = v122
                    v117.lock = Instance.new("AlignPosition")
                    v128 = Enum.PositionAlignmentMode.OneAttachment
                    v117.lock.Mode = v128
                    v128 = v117.attachment
                    v117.lock.Attachment0 = v128
                    v117.lock.ApplyAtCenterOfMass = true
                    v117.lock.RigidityEnabled = true
                    v117.lock.MaxForce = 1000000
                    v117.lock.Position = v125
                    v117.lock.Parent = v122
                    v122.Anchored = false
                    v129 = CFrame.new(v125) * v122.CFrame.Rotation * v122.CFrame:ToObjectSpace(v119:GetPivot())
                    v35 = v117
                    v117.lock.Position = v125
                    v117 = Vector3.zero
                    v122.AssemblyAngularVelocity = v117
                    return v118, v119, v122, v123, v124, v125, v117, Vector3
                else
                    v35.lock.Position = v125
                    v117 = Vector3.zero
                    v122.AssemblyAngularVelocity = v117
                    return
                end
            end
        end
    end
    if v119 then
        v123 = v119:FindFirstChildOfClass("Humanoid")
        v124 = v4 and v36(v113, v114, v115, v116, v132, ...)
    else
        v124 = v4 and v36(v114, v115, v116, v132, ...)
    end
    v125 = not v118 or not v122 or not v123
    if not v125 then
        v117 = v123.Health
        v125 = v117 <= 0
    end
    if not v125 then
        v125 = not v124
    end
    if v125 then
        return v118, v119, v122, v123, v124
    else
        v125 = v124 + Vector3.new(0, 3, 0)
        v117 = not v35
        if v117 then
            v120.root = v122
            v120.anchored = v122.Anchored
            v120.collisions = v121
            v117 = v120
            v127, v128, v129 = ipairs(v119:GetDescendants())
            v130, v131 = v127(v128, v129)
            if not (v130 == nil) then
                v129 = v130
                while true do
                    v130, v131 = v127(v128, v129)
                    if v130 ~= nil then
                        v129 = v130
                        continue
                    end
                    break
                end
            end
            v117.added = v119.DescendantAdded:Connect(isInstanceOf)
            v117.attachment = Instance.new("Attachment")
            v117.attachment.Name = "IoneBossHold"
            v117.attachment.Parent = v122
            v117.lock = Instance.new("AlignPosition")
            v128 = Enum.PositionAlignmentMode.OneAttachment
            v117.lock.Mode = v128
            v128 = v117.attachment
            v117.lock.Attachment0 = v128
            v117.lock.ApplyAtCenterOfMass = true
            v117.lock.RigidityEnabled = true
            v117.lock.MaxForce = 1000000
            v117.lock.Position = v125
            v117.lock.Parent = v122
            v122.Anchored = false
            v129 = CFrame.new(v125) * v122.CFrame.Rotation * v122.CFrame:ToObjectSpace(v119:GetPivot())
            v35 = v117
            v117.lock.Position = v125
            v117 = Vector3.zero
            v122.AssemblyAngularVelocity = v117
            return v118, v119, v122, v123, v124, v125, v117, Vector3
        else
            v35.lock.Position = v125
            v117 = Vector3.zero
            v122.AssemblyAngularVelocity = v117
            return
        end
    end
end
local v38, v39, v40
local function processItems13()
    local fTD_Controllers, v111, v112, v113, v114, v115, v116, v117, v118, v119, v120
    if v40 then
        return v40
    else
        fTD_Controllers = v2.PlayerScripts:FindFirstChild("FTD_Controllers")
        v111 = fTD_Controllers
        if v111 then
            v112 = require(fTD_Controllers:FindFirstChild("BossController"))
        elseif not v111 then
            v112 = require(v111)
        else
            v112 = require(v111)
        end
        v113 = debug and debug.getupvalues or getupvalues
        if type(v113) ~= "function" then
            type(v112.ThrowAuto)
        end
        v114 = nil
        v116 = v113(v112.ThrowAuto)
        v115 = next
        v118, v119 = next(v116, nil)
        if not (v118 == nil) then
            v117 = v118
            v120 = type(v119)
            while true do
                if v120 == "function" then
                    if v114 then
                        v114 = v119
                        v118, v119 = v115(v116, v117)
                        if v118 == nil then
                            v38:WaitForChild("MosaBoss")
                        else
                            v117 = v118
                            v120 = type(v119)
                            continue
                        end
                    else
                        v114 = v119
                        v118, v119 = require(v116, v117)
                        if v118 == nil then
                            break
                        else
                            v117 = v118
                            v120 = type(v119)
                            continue
                        end
                    end
                else
                    v118, v119 = require(v116, v117)
                    if v118 == nil then
                        break
                    else
                        v117 = v118
                        v120 = type(v119)
                        continue
                    end
                end
                break
            end
        end
        v115 = require(v38:WaitForChild("MosaBoss"))
        if type(v115.ThrowCooldown) == "number" then
            v39 = math.max(0.1, v115.ThrowCooldown + 0.05)
        end
        v40 = v114
        return v114
    end
end
local v41, v42, v43
local function runProtected2(v111, v112, v113, v117, ...)
    local v114
    v114 = 0
    local v115, v116
    if not v3 then
        if v42() then
            v116 = os.clock(v113)
            local __cont1 = false
            while true do
                if v114 <= v116 then
                    v114 = os.clock() + v39
                    v115, v116 = pcall(function(v117, v118, v119, v120, v132, ...)
                        local character3 = v2.Character
                        local v121 = character3
                        local v122
                        if character3 then
                            v121 = character3:FindFirstChildOfClass("Humanoid")
                            if not v121 or v121.Health <= 0 then
                                return character3, v121
                            else
                                v122 = v38:GetAttribute("BossState")
                            end
                        else
                            v122 = not v121 or v121.Health <= 0 or v38:GetAttribute("BossState")
                        end
                        local backpack2, v123, v124, v125, v126, v127, v128, v129, v130, v131
                        if v122 ~= "Fight" then
                            return character3, v121, v122
                        else
                            v122 = character3:FindFirstChild("BossSpear")
                            backpack2 = v2:FindFirstChildOfClass("Backpack")
                            v122 = v122 or backpack2
                            if not v122 then
                                return character3, v121, v122, backpack2
                            else
                                v124 = v122:IsA("Tool")
                                if v122.Parent ~= character3 then
                                    return character3, v121, v122, backpack2
                                else
                                    v123 = v36(v124)
                                    v124 = workspace.CurrentCamera
                                    if not v123 or not v124 then
                                        return character3, v121, v122, backpack2, v123
                                    else
                                        v125, v126 = v124:WorldToViewportPoint(v123)
                                        if not v126 then
                                            return character3, v121, v122, backpack2, v123, v124, v125, v126
                                        else
                                            v127 = v43(v120, v132, ...)
                                            v129 = v42(v120, v132, ...)
                                            v128 = not v129
                                            if not v128 then
                                                v130 = v125.X
                                                v131 = v125.Y
                                                Vector2.new(v130, v131)
                                                v129 = os.clock(v119)
                                                v128 = v129 + v39
                                                v114 = v128
                                            end
                                            return character3, v121, v122, backpack2, v123, v124, v125, v126, v127, v128, v129
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    if not v115 then
                        v41 = false
                    end
                    v116 = v3
                    if not v3 then
                        v42(v112, v113, v117, ...)
                        os.clock(v113)
                        break
                    end
                    if __cont1 then
                        break
                    end
                else
                    v116 = task
                    local __brk4 = false
                    while true do
                        while true do
                            v116 = v3
                            if not v116 then
                                v42(v112, v113, v117, ...)
                                v116 = os.clock(v113)
                                __cont1 = true
                                break
                            end
                            __brk4 = true
                            if __cont1 then
                                break
                            end
                            break
                        end
                        if __cont1 then
                            break
                        end
                        if __brk4 then
                            break
                        end
                        v116 = task
                    end
                end
                if __cont1 then
                    __cont1 = false
                    continue
                end
                break
            end
        end
    end
end
local v44, v45
local function processItems14()
    local fTD_Nests = workspace:FindFirstChild("FTD_Nests")
    local v111 = ipairs
    local v112, v113
    if fTD_Nests then
        v111, v112, v113 = v111(fTD_Nests:GetChildren())
    else
        v111, v112, v113 = v111({})
    end
    local v114, v115
    v114, v115 = v111(v112, v113)
    local v116 = {}
    local v117, nestCenter, v118, v119, v120, rarity
    if not (v114 == nil) then
        v113 = v114
        local v121 = {}
        while true do
            v117 = v115:GetAttribute("Id")
            nestCenter = v115:FindFirstChild("NestCenter")
            if v117 ~= nil and nestCenter then
                nestCenter:IsA("BasePart")
                nestCenter:FindFirstChildOfClass("ProximityPrompt")
                v118 = tostring(v117)
                if not v121[v118] then
                    v121[v118] = true
                    v120 = tostring
                    rarity = v115:GetAttribute("Rarity")
                    if rarity then
                        v119 = v118 .. " - " .. tostring(rarity)
                    else
                        v119 = v118 .. " - " .. v120("Unknown")
                    end
                    v44[v119] = v118
                    v45[v118] = v119
                end
                v114, v115 = v111(v112, v113)
                if not (v114 == nil) then
                    v113 = v114
                    continue
                end
            else
                v114, v115 = v111(v112, v113)
                if v114 == nil then
                    break
                else
                    v113 = v114
                    continue
                end
            end
            return v116
        end
    end
    return v116
end
local v46
local function processItems15()
    local v111, v112, v113
    v111, v112, v113 = ipairs(v46)
    local v114
    x1, v114 = v111(v112, v113)
    if not (x1 == nil) then
        v113 = x1
        while true do
            x1, v114 = v111(v112, v113)
            if x1 ~= nil then
                v113 = x1
                continue
            end
            break
        end
    end
    return {}
end
local v47
local function CallbackHandler8(v111)
    local v112, v113, v114, v115, v116, v117
    if not v47 then
        v46 = {}
        v112, v113, v114 = ipairs({})
        v115, v116 = v112(v113, v114)
        if not (v115 == nil) then
            v114 = v115
            while true do
                v117 = v44[v116]
                if v117 then
                    table.find(v46, v117)
                    v115, v116 = v112(v113, v114)
                    if v115 == nil then
                        v114 = v115
                    else
                        v114 = v115
                        continue
                    end
                else
                    v115, v116 = v112(v113, v114)
                    if v115 == nil then
                        break
                    else
                        v114 = v115
                        continue
                    end
                end
                v112 = v31 + 1
                v31 = v112
                return v111, v112, 1, v114, v115, v116
            end
        end
        v112 = v31 + 1
        v31 = v112
        return v111, v112, 1, v115, v115, v116
    end
end
local v48, v49, v50
local function runProtected3(v111, v112, v113, v114, v115, v116, v124, ...)
    local v117, v118, v119, v120, v121, v122, v123
    if not v3 then
        v117 = v3
        while true do
            if not v117 then
                v117 = v48(v112, v113, v114, v115, v116, v124, ...)
                v118, v119, v120 = ipairs(v50(v116, v124, ...))
                v121, v122 = v118(v119, v120)
                if not (v121 == nil) then
                    v120 = v121
                    while true do
                        if not table.find(v117, v122) then
                            v121, v122 = v118(v119, v120)
                            if not (v121 == nil) then
                                v120 = v121
                                continue
                            end
                        else
                            v121, v122 = v118(v119, v120)
                            if v121 == nil then
                                break
                            else
                                v120 = v121
                                continue
                            end
                        end
                        break
                    end
                end
                v118 = #v117 ~= #v49
                if not v118 then
                    v119, v120, v121 = ipairs(v117)
                    v122, v123 = v119(v120, v121)
                    if v122 == nil then
                        return
                    end
                    if v49[v122] ~= v123 then
                        v49 = v117
                        v119, v120 = pcall(tryOperation5)
                        v47 = false
                        return
                    end
                    v122, v123 = pcall(v120, v122)
                    if not (v122 == nil) then
                        v121 = v122
                        while true do
                            if v49[v122] ~= v123 then
                                v118 = true
                            else
                                v122, v123 = pcall(v120, v121)
                                if v122 == nil then
                                    break
                                else
                                    v121 = v122
                                    continue
                                end
                            end
                            if v118 then
                                v49 = v117
                                v119, v120 = pcall(tryOperation5)
                                v47 = false
                                return
                            end
                            return
                        end
                    end
                    return
                end
                if v118 then
                    v49 = v117
                    v119, v120 = pcall(tryOperation5)
                    v47 = false
                    return
                end
                break
            end
            return
        end
    end
end
local v51
local function updateState4()
    v51 = nil
    v6 = false
    v31 = v31 + 1
end
local v52
local function computeValue3(v111, species, id, v113)
    local v114, v115, v116
    if v111 == "Stole" then
        local v117 = {}
        v115 = v117
        v117.id = id
        v117.species = species
        v116 = tonumber(v113)
        if v116 then
            v115.leash = v116
        else
            v115.leash = 200
        end
        v115.attempts = 0
        v116 = os.clock()
        v115.receivedAt = v116
        v51 = v115
        return v111, species, id, v113, v115, v115, v116
    elseif v111 == "Escaped" or v111 == "Caught" or v111 == "Dropped" then
        v51 = nil
        v6 = false
        v115 = os.clock()
        v114 = v115 + (v111 == "Escaped" and 0.15 or 1)
        v52 = v114
        return v111, species, id, v113, v114, v115
    else
        return
    end
end
local v53
local function processItems16(v111, v112, v113, v135, ...)
    local v114
    local function getValue3()
        local v135 = v53()
        if v135 then
            return 0 < v114.Health
        else
            return v135
        end
    end
    local v115, v116
    local function checkCondition2(v135)
        local v136 = v135 - v115
        local v137 = v136.X
        local v138 = v136.Z
        return v116 <= Vector3.new(v137, 0, v138).Magnitude
    end
    local v117, v118, v120, v122, v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, v133
    do
        local v134 = {}
        v117 = v51
        while true do
            while true do
                do
                    local shouldExit = false
                    if v117 then
                        v118 = v117.receivedAt + 0.1
                        if os.clock() < v118 then
                            if not v53(v113, v135, ...) then
                                return
                            end
                            if v51 == v117 then
                                v114 = math
                                v120 = v114.min
                                v114 = 0.05
                                v115 = os.clock
                                v115 = v115()
                                v115 = v118 - v115
                                v120 = v120(0.05, v115)
                                os.clock(v112, v113, v135, ...)
                                v126 = v127 + v128
                                v127 = v130
                                v123 = v123(v124, v126 + v127, v124)
                                v122 = nil + v123
                                v124 = CFrame.new(v122)
                                v130 = v130 * v131
                                v127 = v127(v128, v129, v130)
                                v126 = v115 + v127
                                v129 = v126
                                v130 = nil
                                v131 = 2
                                v128 = v21(v129, nil, 2)
                                v127 = not v128
                                if not v127 then
                                    v122 = v122 + v124
                                    if 0 < v124 then
                                        if v122 + v124 <= v123 then
                                            v126 = v122 * math.pi
                                            v125 = v126 / 2
                                            if not v126 then
                                                v124[1] = v125
                                                v124[2] = v126
                                                v123 = v124
                                            end
                                            v117.nextAttempt = v123 + v124
                                            if not v117.warned then
                                                v117.warned = true
                                                return
                                            end
                                            return
                                        else
                                            break
                                        end
                                    elseif v123 > v122 + v124 then
                                        break
                                    else
                                        v126 = v122 * math.pi
                                        v125 = v126 / 2
                                        if not v126 then
                                            v124[1] = v125
                                            v124[2] = v126
                                            v123 = v124
                                        end
                                        v117.nextAttempt = v123 + v124
                                        if not v117.warned then
                                            v117.warned = true
                                            return
                                        end
                                        return
                                    end
                                end
                                break
                            end
                            if shouldExit then
                                break
                            end
                            return
                        else
                            v120 = v53(v113, v135, ...)
                        end
                        if not (not v120 or v122) then
                            v123 = true
                            v124 = v134
                        end
                    end
                    v122 = not v123
                    v131 = v123 / 16
                    break
                end
            end
            v132 = v133.sin
            v133 = v126
            v132 = v132(v126)
            v132 = v132 * v127
        end
        return
    end
end
local v54, v55
local function getValue11()
    local function performTask2()
    end
    local v111, v112
    local function updateState()
        v111.HoldDuration = v112
    end
    v111 = v54
    v112 = v55
    v54 = nil
    v55 = nil
    if v111 then
        return
    end
end
local function CallbackHandler9(v111)
    v8 = not v3 and v111
    v31 = v31 + 1
    if not v8 then
        v6 = false
        return v111
    else
        return
    end
end
local function processItems17(v111, v112, v116, ...)
    local v113
    local function findChild(v116, v117, v118, v119, v120, v125, ...)
        local clock
        local function getValue2()
            local v125 = v53()
            if v125 then
                return 0 < clock.Health
            else
                return v125
            end
        end
        local v121 = v113
        local carrying, receivedAt, v122, v123, v124
        while true do
            if not v121 then
                return v2.PlayerScripts:FindFirstChild("FTD_Controllers")
            else
                carrying = v113.Carrying()
                v121 = v51 and not carrying
                clock = os.clock(v120)
                v122 = v51
                receivedAt = v122.receivedAt
                v123 = v124.Carrying()
                while true do
                    if v123 then
                        return carrying, v121, nil, clock, receivedAt, v122, nil, nil, nil, nil, nil, nil, nil
                    end
                    v123 = v53(v117, v118, v119, v120, v125, ...)
                    if v123 then
                        v124 = v31
                        break
                    end
                    if v123 then
                        v53(v117, v118, v119, v120, v125, ...)
                        return carrying, v121, nil, clock, receivedAt, v122, nil, nil, nil, nil, nil, nil, nil
                    else
                        return
                    end
                end
            end
            v53(v117, v118, v119, v120, v125, ...)
        end
    end
    v113 = nil
    local v114, v115
    if not v3 then
        if v53() then
            v114 = pcall
            local __cont1 = false
            while true do
                v114, v115 = v114(findChild)
                v6 = v8 and v51 ~= nil
                if not v114 then
                    v6 = false
                    v8 = false
                end
                v114 = not v3
                if v114 then
                    v53(v112, v116, ...)
                    break
                end
                if __cont1 then
                    __cont1 = false
                    continue
                end
                break
            end
        end
    end
end
local v56
local function runProtected4()
    local v111
    local function transformValue(v134)
        local v135 = tostring(v134) == ""
        v135 = os:clock(tostring(v134))
        local v136 = v56
        local v137 = tostring(v134)
        local v138 = v56[v137] or 0
        if v135 < v138 then
            return v134, v135, v138, v136, v137
        else
            v135 = v111
            v138 = tostring(v134)
            v135[v138] = v134
            return v134, v135, v138
        end
    end
    local function computeValue(v134, v135, v136)
        return v134, v135, v136, true, "number"
    end
    local HttpService, v112
    local function checkCondition(v134, v135)
        if tonumber(v134) then
            tonumber(v135)
            return tonumber(v134) < tonumber(v135)
        else
            return tostring(v134) < tostring(v135)
        end
    end
    local v113, v114, v115
    local function processItems()
        local v134, v135, v136
        v134, v135, v136 = ipairs(v114(v115))
        local v137
        x3, v137 = v134(v135, v136)
        local v138, v139, v140
        if not (x3 == nil) then
            v136 = x3
            while true do
                if type(v137.Function) == "function" then
                    v138 = v113(v137.Function)
                    x4, v140 = next(v138, nil)
                    if not (x4 == nil) then
                        v139 = x4
                        while true do
                            x4, v140 = next(v138, v139)
                            if x4 ~= nil then
                                v139 = x4
                                continue
                            end
                            break
                        end
                    end
                    x3, v137 = v134(v135, v136)
                    if not (x3 == nil) then
                        v136 = x3
                        continue
                    end
                else
                    x3, v137 = v134(v135, v136)
                    if x3 == nil then
                        break
                    else
                        v136 = x3
                        continue
                    end
                end
                return
            end
        end
    end
    local v116, v117, v118, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, mouseButton1Click
    do
        local v129 = {}
        local v130 = {}
        while true do
            while true do
                while true do
                    while true do
                        while true do
                            do
                                local shouldExit = false
                                while true do
                                    do
                                        local v131 = {}
                                        v111 = v131
                                        local v132 = {}
                                        v116 = v132
                                        v117 = transformValue
                                        v118 = computeValue
                                        v114 = "HttpService"
                                        v113 = game
                                        HttpService = game:GetService("HttpService")
                                        v113 = ipairs
                                        v113, v114, v119 = ipairs(v2:GetDescendants())
                                        v113 = v113
                                        v114 = v114
                                        v120, v112 = v113(v114, v119)
                                        if not (v120 == nil) then
                                            v119 = v120
                                            while true do
                                                v121 = v112.Parent
                                                v122 = false
                                                v123 = 1
                                                v124 = 5
                                                v125 = 1
                                                v126 = not v121
                                                if not v126 then
                                                    v127 = v2
                                                    v126 = v121 == v2
                                                end
                                                if v126 then
                                                    v125 = "EggId"
                                                    shouldExit = true
                                                    break
                                                else
                                                    v127 = v121.Name
                                                    v126 = string.lower(v127)
                                                    while true do
                                                        v128 = "eggs"
                                                        v127 = v126 == "eggs"
                                                        if not v127 then
                                                            v128 = "egginventory"
                                                            v127 = v126 == "egginventory"
                                                        end
                                                        if v127 then
                                                            v122 = true
                                                            break
                                                        else
                                                            v121 = v121.Parent
                                                            v123 = v123 + v125
                                                            if 0 < v125 then
                                                                if v123 + v125 <= v124 then
                                                                    v126 = not v121
                                                                    if not v126 then
                                                                        v127 = v2
                                                                        v126 = v121 == v2
                                                                    end
                                                                    if v126 then
                                                                        v125 = "EggId"
                                                                        v123 = v112:GetAttribute("EggId")
                                                                        v124 = nil
                                                                    else
                                                                        v127 = v121.Name
                                                                        v126 = string.lower(v127)
                                                                        continue
                                                                    end
                                                                else
                                                                    break
                                                                end
                                                            elseif v124 > v123 + v125 then
                                                                break
                                                            else
                                                                v126 = not v121
                                                            end
                                                        end
                                                        goto __x3
                                                    end
                                                    v123 = v112:GetAttribute("EggId")
                                                    v124 = nil
                                                end
                                                ::__x3::
                                                if v123 ~= v124 then
                                                    if v122 then
                                                        v112:GetAttribute("Species")
                                                        v127 = "Id"
                                                        v112:GetAttribute("Id")
                                                        v126 = "StringValue"
                                                        v125 = v112
                                                        v124 = v112:IsA("StringValue")
                                                    else
                                                        v126 = "StringValue"
                                                        v125 = v112
                                                        v124 = v112.IsA(v125, "StringValue")
                                                        while true do
                                                            if v124 then
                                                                v122 = false
                                                                v123 = 1
                                                                v124 = 5
                                                                v125 = 1
                                                                v126 = not v121
                                                                if v126 then
                                                                    v125 = "EggId"
                                                                    shouldExit = true
                                                                    break
                                                                else
                                                                    v127 = string
                                                                    v126 = v127.lower
                                                                end
                                                                break
                                                            else
                                                                v126 = v112
                                                                v125 = v112.GetAttribute
                                                                v124 = v124(v125, v126)
                                                                continue
                                                            end
                                                        end
                                                    end
                                                elseif v122 then
                                                    v127 = "Species"
                                                    v125 = v112:GetAttribute("Species")
                                                    v126 = nil
                                                    v124 = v125 ~= nil
                                                else
                                                    v126 = "StringValue"
                                                    v125 = v112
                                                    v124 = v112:IsA("StringValue")
                                                end
                                                if v124 then
                                                    string.lower(v112.Name)
                                                    v124, v125 = pcall(function()
                                                        return HttpService:JSONDecode(v112.Value)
                                                    end)
                                                    v126 = v118
                                                    v127 = v125
                                                    v128 = true
                                                    v115 = 0
                                                    v120, v112 = v113(v114, v119)
                                                    if v120 == nil then
                                                        v119 = v120
                                                    else
                                                        v119 = v120
                                                        continue
                                                    end
                                                else
                                                    v120, v112 = v113(v114, v119)
                                                    if v120 == nil then
                                                        break
                                                    else
                                                        v119 = v120
                                                        continue
                                                    end
                                                end
                                                break
                                            end
                                            if shouldExit then
                                                break
                                            end
                                        end
                                        v113 = next
                                        v113 = v113
                                        v114 = v2:GetAttributes()
                                        v120, v112 = next(v114, nil)
                                        do
                                            local shouldExit2 = false
                                            if v120 == nil then
                                                v113 = debug
                                                if v113 then
                                                    v114 = debug
                                                    v113 = debug.getupvalues
                                                end
                                                if not v113 then
                                                    v113 = getupvalues
                                                end
                                                v114 = getconnections
                                                v119 = v2
                                                v112 = "PlayerGui"
                                            else
                                                v119 = v120
                                                v122 = v120
                                                v121 = string.lower(v120)
                                                while true do
                                                    v123 = "eggs"
                                                    v122 = v121 == "eggs"
                                                    if not v122 then
                                                        v123 = "egginventory"
                                                        v122 = v121 == "egginventory"
                                                    end
                                                    if not v122 then
                                                        v123 = "inventory"
                                                        v122 = v121 == "inventory"
                                                    end
                                                    if v122 then
                                                        type(v112)
                                                        v122, v123 = pcall(function()
                                                            return HttpService:JSONDecode(v112)
                                                        end)
                                                        v124 = v118
                                                        v125 = v123
                                                        v126 = v121 ~= "inventory"
                                                        v127 = 0
                                                        v120, v112 = v113(v114, v119)
                                                        if not (v120 == nil) then
                                                            v119 = v120
                                                            v122 = v120
                                                            v121 = string.lower(v120)
                                                            continue
                                                        end
                                                    else
                                                        v120, v112 = v113(v114, v119)
                                                        if not (v120 == nil) then
                                                            v119 = v120
                                                            v122 = string
                                                            v121 = v122.lower
                                                            v124 = v124(v125, v126)
                                                            if v124 then
                                                                v126 = "TextButton"
                                                            else
                                                                v122 = v123
                                                                goto __x20
                                                            end
                                                        end
                                                        break
                                                    end
                                                    v113 = debug
                                                    if v113 then
                                                        v114 = debug
                                                        v113 = debug.getupvalues
                                                    end
                                                    if not v113 then
                                                        v113 = getupvalues
                                                    end
                                                    v114 = getconnections
                                                    v119 = v2
                                                    v112 = "PlayerGui"
                                                    shouldExit2 = true
                                                    break
                                                end
                                                if shouldExit2 then
                                                    break
                                                end
                                                v119 = v120
                                                v113 = debug
                                                if v113 then
                                                    v114 = debug
                                                    v113 = v114.getupvalues
                                                end
                                            end
                                        end
                                        v119 = v119:FindFirstChildOfClass(v112)
                                        if v119 then
                                            v112 = type(v114)
                                            v121 = "function"
                                            v120 = v112 == "function"
                                            if v120 then
                                                v120, v112, v121 = ipairs(next, v119, nil)
                                                v112 = v112
                                                v122, v123 = v120(v112, v121)
                                                if not (v122 == nil) then
                                                    v121 = v122
                                                    while true do
                                                        if v123:IsA("GuiButton") then
                                                            v123:IsA("TextButton")
                                                            v124 = v123.Text
                                                            v115 = true
                                                            if string.find(string.lower(v123.Name .. " " .. v124), "incubate", 1, true) then
                                                                v115 = v123.Activated
                                                                mouseButton1Click = v123.MouseButton1Click
                                                                v130[1] = v115
                                                                v130[2] = mouseButton1Click
                                                                v125, v126, v127 = ipairs(v130)
                                                                v128, v115 = v125(v126, v127)
                                                                if not (v128 == nil) then
                                                                    v127 = v128
                                                                    while true do
                                                                        v128, v115 = v125(v126, v127)
                                                                        if v128 ~= nil then
                                                                            v127 = v128
                                                                            continue
                                                                        end
                                                                        break
                                                                    end
                                                                end
                                                            end
                                                            v122, v123 = v120(v112, v121)
                                                            if not (v122 == nil) then
                                                                v121 = v122
                                                                continue
                                                            end
                                                        else
                                                            v122, v123 = v120(v112, v121)
                                                            if v122 == nil then
                                                                break
                                                            else
                                                                v121 = v122
                                                                continue
                                                            end
                                                        end
                                                        break
                                                    end
                                                end
                                                v120 = v129
                                                v112, v121, v122 = next(v111)
                                            end
                                            v112 = v112
                                            v123, v124 = v112(v121, v122)
                                            if not (v123 == nil) then
                                                v122 = v123
                                                while true do
                                                    v123, v124 = v112(v121, v122)
                                                    if v123 ~= nil then
                                                        v122 = v123
                                                        continue
                                                    end
                                                    break
                                                end
                                            end
                                        else
                                            local v133 = {}
                                            v120 = v133
                                            v112, v121, v122 = pairs(v111)
                                            v112 = v112
                                            v123, v124 = v112(v121, v122)
                                            if not (v123 == nil) then
                                                v122 = v123
                                                goto __x20
                                            end
                                        end
                                        v112 = v120[1]
                                        return
                                    end
                                end
                                if shouldExit then
                                    break
                                end
                                if v124 then
                                    v124 = v117
                                    v127 = "Id"
                                end
                                v122 = v120
                                v121 = v121(v120)
                                v124, v125 = v124(v125)
                                while true do
                                    if v124 then
                                        v127 = v125
                                        v128 = true
                                        v115 = 0
                                    else
                                        v126 = v121 ~= v127
                                        v127 = 0
                                        v119 = nil
                                        v125 = v125(v126, 0, v128, v115)
                                        if v125 then
                                            v128 = v130
                                        else
                                            v122, v123 = v120(v112, v121)
                                            if v122 == nil then
                                                v120 = v129
                                                v112 = pairs
                                                v112, v121, v122 = next(v111)
                                                v112 = v112
                                                v123, v124 = v112(v121, v122)
                                                if v123 == nil then
                                                    v122 = v123
                                                    goto __x39
                                                else
                                                    v126 = v126(0)
                                                end
                                                v123, v124 = v112(v121, v122)
                                                if v123 ~= nil then
                                                    v126 = v112
                                                    v125 = v112.GetAttribute
                                                end
                                                v122 = v123
                                                goto __x39
                                            else
                                                v121 = v122
                                                v126 = "GuiButton"
                                                v125 = v123
                                                v124 = v123.IsA
                                                goto __x39
                                            end
                                        end
                                        break
                                    end
                                    ::__x39::
                                    v112 = table.sort
                                    v121 = v120
                                    v122 = checkCondition
                                    v126 = v127.lower
                                    v127 = v121.Name
                                    v126 = v126(v127)
                                    v125 = v123(v112.Name)
                                    v124 = v125 == "eggs"
                                    if v124 then
                                        v124, v125 = pcall(tryOperation4)
                                        continue
                                    else
                                        v120, v112 = v113(v114, v119)
                                        if v120 == nil then
                                            v119 = v120
                                        else
                                            v119 = v120
                                            v121 = v112.Parent
                                        end
                                    end
                                end
                                ::__x20::
                                v125 = table.insert
                                v126 = v120
                                v127 = v124
                            end
                            v123 = v112:GetAttribute(v125)
                            if v123 ~= nil then
                                v124 = v112
                                v123 = v112.GetAttribute
                            else
                                v124 = v122
                            end
                            v120, v112 = v113(v114, v119)
                            if v120 == nil then
                                v119 = v120
                            else
                                v122 = v121 == v123
                            end
                            break
                        end
                    end
                end
                v122 = v123 == v124
                v128 = 1
            end
            v122 = v120
            v121 = v121(v120)
        end
    end
end
local v57
local function checkCondition5()
    local v111, v112
    v111, v112 = pcall(function()
        local playerScripts, v113, v114, v115
        if not v57 then
            playerScripts = v2:FindFirstChild("PlayerScripts")
            v113 = playerScripts and playerScripts:FindFirstChild("FTD_Controllers")
            v114 = v113
            if v114 then
                v114 = v113:FindFirstChild("HatcheryController")
            elseif not v114 then
                return true
            else
                v115 = require(v114)
                v57 = v115
                return v115:IsBusy(v114, v115)
            end
            if not v114 then
                return true
            else
                v115 = require(v114)
                v57 = v115
                return v115:IsBusy(v114, v115)
            end
        else
            return v57.IsBusy()
        end
    end)
end
local toggle
local function transformValue4(v111)
    local function performTask()
    end
    if not v3 and toggle then
        return
    end
end
local v58, v59
local function callback(v111)
    local v112 = v111
    if v111 then
        v112 = not v3
    end
    v58 = v112
    v59 = v59 + 1
    if not v58 then
        return v111
    end
end
local function processItems18(v111, v112, v119, ...)
    local v113, v114, v115
    local function getValue()
        if v115 == "Hatch" then
            return v114:InvokeServer("Hatch")
        else
            return v114:InvokeServer("Incubate", v113)
        end
    end
    local v117 = -1
    if not v3 then
        if v59 ~= -1 then
            v117 = v59
        end
        v7()
        if v59 ~= v117 then
            v117 = v59
        end
        v7(v112, v119, ...)
    else
        return
    end
    local v118
    while true do
        if not v3 then
            if v59 ~= v117 then
                break
            end
            v118 = v58
        else
            return
        end
        if v118 then
            v7(v112, v119, ...)
        end
    end
end
local function updateState5()
    v58 = false
    v59 = v59 + 1
    v6 = false
    v4 = false
    v51 = nil
    v8 = false
    v31 = v31 + 1
    v41 = false
    v5 = false
    v3 = true
    v17 = v17 + 1
end
local v60, v61
local function runProtected5(v111, v112, v120, ...)
    local v113, v114, v115, v116, v117, v118, v119
    while true do
        do
            local shouldExit = false
            while true do
                while true do
                    while true do
                        do
                            local shouldExit2 = false
                            do
                                local __brk6 = false
                                while true do
                                    v113 = not v3
                                    local __cont5 = false
                                    while true do
                                        if v113 then
                                            v113 = v3
                                            while true do
                                                if not v113 then
                                                    v113 = v60(v112, v120, ...)
                                                    v114 = v25
                                                    if v114 then
                                                        table.find(v113, v25)
                                                        v61 = v113
                                                        if not v25 and v61[1] then
                                                            v25 = v61[1]
                                                            v17 = v17 + 1
                                                        end
                                                        v26 = true
                                                        v115, v116 = pcall(function()
                                                        end)
                                                        shouldExit2 = true
                                                        break
                                                    end
                                                    if v114 then
                                                        v117 = v61
                                                        v114 = #v113 ~= #v117
                                                        v61 = v113
                                                        v116 = v25
                                                        v115 = not v116
                                                        if v115 then
                                                            v116 = v61
                                                            v115 = v116[1]
                                                            goto __x81
                                                        end
                                                        goto __x81
                                                    end
                                                    v114 = #v113 ~= #v61
                                                    if not v114 then
                                                        v115, v116, v117 = ipairs(v113)
                                                        v118, v119 = v115(v116, v117)
                                                        if v118 == nil then
                                                            v117 = v118
                                                        else
                                                            v117 = v118
                                                            while true do
                                                                if v61[v118] ~= v119 then
                                                                    break
                                                                else
                                                                    v118, v119 = v115(v116, v117)
                                                                    if v118 == nil then
                                                                        v117 = v118
                                                                        break
                                                                    else
                                                                        v117 = v118
                                                                        continue
                                                                    end
                                                                end
                                                            end
                                                        end
                                                        return not v3, v3, v115, v116, v117, v118, v119
                                                    end
                                                    if v114 then
                                                        v61 = v113
                                                        if not v25 and v61[1] then
                                                            v25 = v61[1]
                                                            v17 = v17 + 1
                                                        end
                                                        v26 = true
                                                        v115, v116 = pcall(tryOperation)
                                                        shouldExit2 = true
                                                        break
                                                    end
                                                    v113 = not v3
                                                    __cont5 = true
                                                    break
                                                end
                                                return
                                            end
                                            if shouldExit2 then
                                                break
                                            end
                                            if __cont5 then
                                                __cont5 = false
                                                continue
                                            end
                                            break
                                        end
                                        __brk6 = true
                                        break
                                    end
                                    if shouldExit2 then
                                        break
                                    end
                                    if __brk6 then
                                        break
                                    end
                                end
                                if shouldExit2 then
                                    break
                                end
                                return
                            end
                        end
                        ::__x47::
                        while true do
                            if not v113 then
                                v113 = v60(v112, v120, ...)
                                v114 = v25
                                if v114 then
                                    v117 = v25
                                    table.find(v113, v117)
                                    v115 = table
                                    if v115 then
                                        v26 = false
                                        return not v3, v3, v115, v61
                                    end
                                    shouldExit = true
                                    break
                                end
                                if v114 then
                                    v61 = v113
                                    v115, v116 = pcall(tryOperation)
                                    v26 = false
                                    return not v3, v3, v115, v116
                                end
                            end
                            return
                        end
                        if shouldExit then
                            break
                        end
                        ::__x81::
                        if v115 then
                            v116 = v61
                            v26 = v117
                            v114 = v3
                            v113 = not v3
                            if v113 then
                                v114 = 1
                                v113 = v3
                                goto __x47
                            end
                            return v113, v114, v116[1], v116
                        end
                        break
                    end
                    break
                end
                v26 = true
                v115, v116 = pcall(tryOperation)
            end
            if shouldExit then
                break
            end
        end
        v26 = true
        v17 = pcall + v61
    end
end
local v62, v63
local function runProtected6()
    local v111, v112
    v111 = {}
    v112 = {}
    local v113, v114, v115
    if not v3 then
        v113, v114 = pcall(function(v116, v117, v118, v135, ...)
            local v119, v120, v121, v122, clock2, v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, siteId3, v133, v134
            while true do
                do
                    local shouldExit = false
                    while true do
                        while true do
                            if v14() then
                                v119 = v25
                                if v119 then
                                    v119 = v17
                                    v120 = nil
                                    v121 = nil
                                    v122 = math.huge
                                    clock2 = os.clock()
                                    v123, v124, v125 = ipairs(v62(v25))
                                    v126, v127 = v123(v124, v125)
                                    if not (v126 == nil) then
                                        v125 = v126
                                        while true do
                                            v134 = "SiteId"
                                            v133 = v127
                                            siteId3 = v127:GetAttribute("SiteId")
                                            v128 = v25 .. ":" .. tostring(siteId3)
                                            v129 = v111[v128] or -math.huge
                                            v132 = v112
                                            v131 = v112[v128] or 0
                                            if v131 <= clock2 and v129 < v122 then
                                                v120 = v127
                                                v121 = v128
                                                v122 = v129
                                            end
                                            v126, v127 = v123(v124, v125)
                                            if v126 ~= nil then
                                                v125 = v126
                                                continue
                                            end
                                            break
                                        end
                                    end
                                    if v120 then
                                        v123 = false
                                        v124 = 1
                                        v126 = 1
                                        v125 = tonumber(3)
                                        if 1 > v125 then
                                            v124 = v18(v119)
                                        else
                                            v127 = not v18(v119)
                                            while true do
                                                if v127 then
                                                    v124 = v18(v119)
                                                else
                                                    v120:GetAttribute("Busy")
                                                    v130 = v119
                                                    v127, v128 = pcall(v63, v120, v130)
                                                    v129 = v127
                                                    if v129 then
                                                        shouldExit = true
                                                        break
                                                    end
                                                    if v129 then
                                                        v123 = true
                                                        v125 = v119
                                                        v124 = v18(v125)
                                                        goto __x19
                                                    else
                                                        v130 = v22
                                                        v131 = v124
                                                    end
                                                    v132 = v119
                                                    v130 = v130(v131, v119)
                                                    v129 = not v130
                                                    if v129 then
                                                        v124 = v18(v119)
                                                        goto __x19
                                                    else
                                                        v124 = v124 + v126
                                                        if 0 < v126 then
                                                            if v124 + v126 <= v125 then
                                                                goto __x4
                                                            else
                                                                v124 = v18(v119)
                                                                goto __x19
                                                            end
                                                        elseif v125 > v124 + v126 then
                                                            v124 = v18(v119)
                                                            goto __x19
                                                        else
                                                            goto __x4
                                                        end
                                                    end
                                                end
                                                break
                                            end
                                            if shouldExit then
                                                break
                                            end
                                        end
                                        if v124 then
                                            v111[v121] = os.clock()
                                            v124 = v112
                                            v126 = os.clock(v118)
                                            v125 = v126 + (v123 and 10 or 5)
                                            v124[v121] = v125
                                            return v119, v120, v121, v122, clock2, v123, v124, v125, v126
                                        else
                                            return v119, v120, v121, v122, clock2, v123, v124
                                        end
                                    else
                                        v124 = "Waiting for available loaded sites on " .. tostring(v25)
                                        return v119, v120, v121, v122, clock2
                                    end
                                end
                            else
                                v7()
                                return
                            end
                            if not v119 then
                                v7()
                            end
                            do
                                return
                            end
                            ::__x4::
                            v129 = v119
                            v128 = v18(v129)
                            v127 = not v128
                            if v127 then
                                v125 = v119
                                v124 = v18(v125)
                                goto __x19
                            end
                        end
                        if shouldExit then
                            break
                        end
                        v124 = v18(v119)
                        ::__x19::
                        if v124 then
                            v126 = os
                            v111[v121] = v126.clock()
                            v124 = v112
                            v126 = v126.clock
                            v126 = v126(v118, v135, ...)
                            v127 = v123
                            if v127 then
                                v125 = v126 + 10
                                v124[v121] = v125
                                return v119, v120, v121, v122, clock2, v123, v124, v125, v126
                            end
                            if not v127 then
                                v125 = v126 + 5
                                v124[v121] = v125
                                return v119, v120, v121, v122, clock2, v123, v124, v125, v126
                            end
                            v125 = v126 + v127
                            v124[v121] = v125
                            return v119, v120, v121, v122, clock2, v123, v124, v125, v126
                        else
                            return v119, v120, v121, v122, clock2, v123, v124
                        end
                    end
                    if shouldExit then
                        break
                    end
                end
            end
        end)
        v115 = not v113
        while true do
            if v115 then
                tostring(v114)
            end
            if not v3 then
                v113, v114 = pcall(getAttribute)
                v115 = not v113
                continue
            end
            break
        end
    end
end
v10 = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
v38 = game
v2 = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
local v64 = loadstring(v2)()
v19 = "Players"
v10 = game
v2 = game:GetService("Players").LocalPlayer
v19 = "ReplicatedStorage"
v10 = game
v38 = game:GetService("ReplicatedStorage")
v19 = "FTD"
v10 = v38
v38 = v38.WaitForChild(v10, "FTD")
v10 = require
v3 = "Config"
v5 = v38
v19 = v38:WaitForChild("Config")
v10 = require(v19)
v3 = "Remotes"
v5 = v38
v19 = v38:WaitForChild("Remotes")
v5 = false
v3 = false
v4 = false
v30 = nil
v8 = false
v58 = false
v6 = false
v7 = getValue5
v14 = getValue6
v53 = getValue7
v42 = getValue8
v54 = nil
v31 = 0
v39 = 1.1
v40 = nil
v25 = nil
v17 = 0
v20 = "Normal"
v15 = math.min
v13 = 4
local max = math.max
v9 = 0.5
v11 = v10.Dig.Range
v21 = tonumber(v11)
if v21 then
    v11 = 0.6
    v21 = v21 * 0.6
else
    v11 = 0.6
    v21 = 3.5999999999999996
end
max = max(0.5, v21)
v15 = v15(4, max)
v13 = nil
max = processValues
v9 = false
v21 = computeValue2
v11 = nil
v12 = nil
v28 = processItems2
v29 = processItems3
local v67, v68, v69, v70, v71, v72 = ...
v11 = processItems2(v68)
local characterRemoving
characterRemoving = v2.CharacterRemoving:Connect(performTask4)
local v75 = nil
local v76 = nil
local minHold = v10.Dig.MinHold
v62 = v10.Dig.MaxHold
v18 = 0.001
v16 = v62 - 0.001
v60 = 0.001
local v77, v78
do
    local shouldExit = false
    if not (minHold > v16) then
        v62 = v10.QualityFor
        v22 = minHold
        v18 = v10.MeterValue(minHold)
        local v109 = {}
        while true do
            v62 = v62(v18)
            v18 = "Perfect"
            if v62 == "Perfect" then
                v62 = v75 or minHold
                v75 = v62
                v76 = minHold
                minHold = minHold + v60
                if 0 < v60 then
                    if minHold + v60 <= v16 then
                        v62 = v10.QualityFor
                        v22 = minHold
                        v18 = v10.MeterValue(minHold)
                        continue
                    else
                        minHold = (v75 + v76) / 2
                        v16 = getValue9
                        v60 = getAttribute3
                        v63 = getAttribute4
                        v23 = v109
                        v109.Title = "Ione Hub"
                        v109.Author = "ss"
                        v109.Folder = "IoneHub"
                        v24 = 500
                        v78 = 360
                        v77 = UDim2.fromOffset(500, 360)
                    end
                elseif v16 > minHold + v60 then
                    minHold = (v75 + v76) / 2
                    v16 = getValue9
                    v60 = getAttribute3
                    v63 = getAttribute4
                    v23 = v109
                    v109.Title = "Ione Hub"
                    v109.Author = "ss"
                    v109.Folder = "IoneHub"
                    v24 = 500
                    v78 = 360
                    v77 = UDim2.fromOffset(500, 360)
                else
                    v62 = v10.QualityFor
                    v22 = minHold
                    v18 = v10.MeterValue(minHold)
                    continue
                end
            elseif v75 then
                break
            else
                minHold = minHold + v60
                if 0 < v60 then
                    if minHold + v60 <= v16 then
                        v62 = v10.QualityFor
                        v22 = minHold
                        v18 = v10.MeterValue(minHold)
                        continue
                    else
                        break
                    end
                elseif v16 > minHold + v60 then
                    break
                else
                    v62 = v10.QualityFor
                    v22 = minHold
                    v18 = v10.MeterValue(minHold)
                    continue
                end
            end
            shouldExit = true
            break
        end
        if shouldExit then
            break
        end
    end
    v16 = getValue9
    v60 = getAttribute3
    v62 = processItems7
    v18 = transformValue2
    v22 = processItems8
    v63 = getAttribute4
    v23 = v1
    v1.Title = "Ione Hub"
    v1.Author = "ss"
    v1.Folder = "IoneHub"
    v24 = 500
    v77 = UDim2.fromOffset(500, 360)
end
v23.Size = v77
v23.Theme = "Dark"
local createWindow = v64:CreateWindow(v23)
local v79 = {Title = "Dig"}
v24 = "shovel"
v79.Icon = "shovel"
v23 = createWindow
local tab = createWindow:Tab(v79)
v23 = {}
v24 = 0
v26 = game
v78 = game:GetService("RunService").RenderStepped
v61 = v78
v78 = v78.Connect(v61, processItems10)
v61 = v60(v69)
v25 = v61[1]
v26 = false
local v81 = {}
v27 = v81
v81.Title = "Island"
v81.Desc = "Select island for Auto Dig"
v81.Values = v61
v81.Value = v25
v81.Multi = false
v81.Callback = CallbackHandler
v32 = tab
tab:Dropdown(v81)
local v82 = {Title = "Dig Position"}
local v83
v36 = "Under"
v82.Values = {[1] = "Normal", [2] = "Under"}
v82.Value = "Normal"
v82.Multi = false
v82.Callback = CallbackHandler2
v32 = tab.Dropdown
local v84 = {Title = "Auto Dig", Desc = "", Value = false}
v84.Callback = CallbackHandler3
v27 = tab
v32 = tab:Toggle(v84)
v27 = nil
local v85 = {Title = "Teleports"}
v85.Icon = "map-pin"
v33 = createWindow
local tab2 = createWindow:Tab(v85)
v33 = 0
v35 = {}
local v87 = {}
local v88 = v87
v87.name = "Cretaceous"
local v89
v43 = 3.5
v88.position = Vector3.new(-1238, 3.5, -30)
v34 = v88
local v90 = {}
v37 = v90
v90.name = "Jurassic"
v43 = 270
v44 = -1340
v37.position = Vector3.new(270, 3.5, -1340)
v88 = v37
local v91 = {}
v89 = v91
v91.name = "Triassic"
v44 = 3.5
v45 = 696
v89.position = Vector3.new(904, 3.5, 696)
v37 = v89
local v92 = {}
v43 = v92
v92.name = "Cambrian"
v44 = 160
v45 = 3.5
v48 = 1168
v43.position = Vector3.new(160, 3.5, 1168)
v89 = v43
local v93 = {name = "Devonian"}
v45 = 700
v48 = 3.5
v49 = 2450
v44 = Vector3.new(700, 3.5, 2450)
v93.position = v44
v43 = v93
v35[1] = v34
v35[2] = v88
v35[3] = v37
v35[4] = v89
v35[5] = v93
local tab3
tab3, v83, v36 = ipairs(v35)
v36 = v36
v35, v34 = tab3(v83, v36)
if not (v35 == nil) then
    v36 = v35
    local v110 = {}
    while true do
        v110.Title = v34.name
        v44 = v34.name
        v110.Desc = "Teleport to " .. v44
        v43 = CallbackHandler5
        v110.Callback = CallbackHandler5
        v37 = tab2
        v35, v34 = tab3(v83, v36)
        if v35 ~= nil then
            v36 = v35
            continue
        end
        break
    end
end
v36 = v35
local v94 = {}
v36 = v94
v94.Title = "Boss"
v35 = "target"
v94.Icon = "target"
tab3 = createWindow:Tab(v94)
local v95 = {}
v34 = v95
v95.Title = "Auto Throw"
v95.Desc = "Use the normal harpoon throw aimed at the Mosasaurus"
v95.Value = false
v95.Callback = CallbackHandler6
v35 = tab3
tab3:Toggle(v95)
v36 = getValue10
v35 = nil
v34 = nil
local v96 = {}
v43 = v96
v96.Title = "Auto Fight Boss"
v96.Desc = "Auto teleport and automatically throw harpoon"
v96.Value = false
v96.Callback = CallbackHandler7
v34 = tab3:Toggle(v96)
v37 = false
v44 = "RunService"
v89 = game:GetService("RunService").Heartbeat
v43 = v89
v89 = v89.Connect(v43, processItems12)
v43 = processItems13
local v97 = {}
v45 = v97
v97.Title = "Nests"
v48 = "egg"
v97.Icon = "egg"
v44 = createWindow
local tab4 = createWindow:Tab(v97)
v44 = {}
v45 = {}
v48 = processItems14
v49 = processItems14(v72)
v46 = {}
local v98
v50, v47, v98 = ipairs(v49)
v50 = v50
v47 = v47
v51, v52 = v50(v47, v98)
if not (v51 == nil) then
    v98 = v51
    while true do
        v51, v52 = v50(v47, v98)
        if v51 ~= nil then
            v98 = v51
            continue
        end
        break
    end
end
v50 = processItems15
v47 = false
local v102 = {}
v52 = v102
v102.Title = "Nest Areas"
v102.Desc = "Select one or more loaded nest areas, must be near the island for it work (will be updated soon)"
v102.Values = v49
v52.Value = processItems15()
v52.Multi = true
v52.AllowNone = true
v52.Callback = CallbackHandler8
v51 = tab4
tab4:Dropdown(v52)
v51 = nil
v52 = 0
v2.CharacterRemoving:Connect(updateState4)
v55 = v19
v19:WaitForChild("NestEvent").OnClientEvent:Connect(computeValue3)
v55 = nil
local v103 = {}
v56 = v103
v103.Title = "Auto Steal Egg"
v103.Desc = "Steal eggs from selected areas"
v103.Value = false
v103.Callback = CallbackHandler9
v30 = tab4:Toggle(v103)
local v106 = {}
v56 = v106
v106.Title = "Hatchery"
v106.Icon = "egg"
v56 = {}
v59 = 0
v57 = nil
toggle = createWindow:Tab(v106):Toggle({
    Title = "Auto Hatch",
    Desc = "Incubate, and hatch automatically",
    Value = false,
    Callback = callback,
})

-- https://discord.gg/hkQAMzyGum