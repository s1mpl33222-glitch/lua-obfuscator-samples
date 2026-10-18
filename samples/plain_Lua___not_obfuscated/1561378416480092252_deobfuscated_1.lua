-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value7 = nil,
	value8 = {},
	value11 = "__index"
}
local t2 = {
	value1 = t1.value8
}
local value12 = {
	["__index"] = t2.value1,
	["__metatable"] = nil
}
t1.value7 = 22126428612671
t1.value12 = value12
t2.value2 = game:GetService("Players")
t1.value8 = 33503604964593
t1.value2 = "game"
value12 = game
t1.value9 = 32235748178594
t1.value2 = "GetService"
t1.value2 = value12.GetService
t1.value6 = 18063688655067
t1.value2 = t1.value2(value12, "TweenService")
t1.value5 = "\191!\129\1\180\1931\215\228\164\200\24\5r\152\253"
t1.value3 = "game"
t2.value3 = t1.value2
t1.value3 = game:GetService("UserInputService")
t2.value4 = t1.value3
t1.value3 = game
t1.value4 = t1.value3.GetService
t1.value8 = "%\11\161\5N\15\2\199\29t\23\209\200\202.Z\14"
t1.value4 = t1.value4(t1.value3, "RunService")
t2.value5 = t1.value4
value12 = game:GetService("ReplicatedStorage")

local Workspace = game:GetService("Workspace")

t1.value10 = "\144\2307s\131\167,\223s\28\129"
t1.value7 = "game"
t2.value6 = Workspace
Workspace = game
t1.value7 = Workspace.GetService
t1.value12 = "n\224\170{A\5e\188\247h\140"
t1.value7 = t1.value7(Workspace, "HttpService")
t2.value7 = t1.value7
t1.value5 = game:GetService("VirtualUser")
t1.value11 = "5\25[64\231"
t1.value6 = "game"
t2.value8 = t1.value5
t1.value6 = game:GetService("Debris")
t2.value9 = t1.value6
t1.value6 = t2.value2.LocalPlayer
t2.value10 = t1.value6
t1.value6 = t2.value6.CurrentCamera
t2.value11 = t1.value6
t1.value10 = t2.value10:WaitForChild("PlayerGui")
t2.value12 = t1.value10
Workspace = value12.WaitForChild
t1.value11 = 5
t1.value10 = Workspace
t1.value10 = t1.value10(value12, "Remotes", t1.value11)
t2.value13 = t1.value10
value12 = t2.value13
t1.value10 = value12
if value12 then
    t1.value10 = t2.value13:FindFirstChild("ShootGun")
end
t2.value14 = t1.value10
value12 = t2.value13
Workspace = t1.value1
t1.value10 = value12
if value12 then
    t1.value10 = t2.value13:FindFirstChild("Stab")
end
t2.value15 = t1.value10
value12 = t2.value13
t1.value10 = value12
if value12 then
    t1.value10 = t2.value13:FindFirstChild("ThrowHit")
end
t2.value16 = t1.value10
value12 = t2.value13
t1.value10 = value12
if value12 then
    t1.value10 = t2.value13:FindFirstChild("ThrowStart")
end
t2.value17 = t1.value10
t1.value10 = t2.value10.Idled
t1.value10:Connect(function()
    t2.value8:CaptureController()
    t2.value8:ClickButton2(Vector2.new())
end)

local result
value12, result = pcall(function()
    return game:GetService("CoreGui")
end)
t1.value10 = value12 and result and result or t2.value12
t1.value13 = "ipairs"
t1.value1 = Workspace
t2.value18 = t1.value10
t1.value10 = ipairs
value12 = { t2.value18, t2.value12 }

for _, v in t1.value10(value12) do
    v = v:FindFirstChild("MonochromeHubV2")

    if v then
        v:Destroy()
    end
end
t1 = function(p1, p2)
    local instance = Instance.new(p1)

    for k, v in pairs(p2) do
        instance[k] = v
    end

    return instance
end
function t2.value19(p3, p4, p5, p6)
    local Sound = Instance.new("Sound")

    Sound.SoundId = "rbxassetid://" .. tostring(p3)
    Sound.Volume = p5 or 1
    Sound.Looped = p6 or false
    Sound.Parent = p4 or t2.value6
    Sound:Play()

    if p6 then
        return Sound
    end

    t2.value9:AddItem(Sound, 5)

    return Sound
end
t2.value20 = {
	["GunCustomEnabled"] = false,
	["GunCooldown"] = 0.03,
	["KnifeCustomEnabled"] = false,
	["KnifeThrowSpeed"] = 1000,
	["KillAllEnabled"] = false,
	["KillAllDelay"] = 0.1,
	["KillAllMethod"] = "Default",
	["LagEnabled"] = false,
	["LagRemote"] = "ThrowHit",
	["LagDelay"] = 0.01,
	["LagBatch"] = 25,
	["AntiLagEnabled"] = false,
	["MovementEnabled"] = false,
	["MovementSpeed"] = 16,
	["MovementMode"] = "Normal",
	["BhopEnabled"] = false,
	["BhopBonus"] = 0,
	["SpinnerEnabled"] = false,
	["SpinnerSpeed"] = 30,
	["NoclipEnabled"] = false,
	["InfJumpEnabled"] = false,
	["JumpPowerEnabled"] = false,
	["JumpPowerValue"] = 50,
	["GravityValue"] = 196.2,
	["InvisibilityEnabled"] = false,
	["InvisibilityActive"] = false,
	["InvisibilityKeybind"] = Enum.KeyCode.Z,
	["GunAuraEnabled"] = false,
	["KnifeAuraEnabled"] = false,
	["KnifeAuraRange"] = 25,
	["HitboxEnabled"] = false,
	["HitboxSize"] = 2,
	["ESPEnabled"] = false,
	["ESPTeamCheck"] = true,
	["ESPColorName"] = "Red",
	["ESPColor"] = Color3.fromRGB(255, 50, 50),
	["FOVEnabled"] = false,
	["FOVValue"] = 70,
	["StretchEnabled"] = false,
	["StretchValue"] = 1,
	["FreezePlayersEnabled"] = false,
	["ShahedEnabled"] = false,
	["ShahedSpeed"] = 30,
	["ShahedMaxTime"] = 20,
	["ShahedRadius"] = 25,
	["Binds"] = {
		["ESP"] = Enum.KeyCode.E,
		["KillAll"] = Enum.KeyCode.K,
		["Speed"] = Enum.KeyCode.V,
		["Invisible"] = Enum.KeyCode.Z,
		["CloseHub"] = Enum.KeyCode.RightControl
	}
}
value12 = Color3.fromRGB(20, 20, 20)
Workspace = Color3.fromRGB(255, 255, 255)
result = Color3.fromRGB(255, 50, 50)

local color3 = Color3.fromRGB(50, 100, 255)
local color32 = Color3.fromRGB(255, 220, 50)
local color33 = Color3.fromRGB(255, 105, 180)
local color34 = Color3.fromRGB(255, 140, 0)
local color35 = Color3.fromRGB(50, 255, 100)
local color36 = Color3.fromRGB(160, 32, 240)
local color37 = Color3.fromRGB(0, 225, 255)
local color38 = Color3.fromRGB(128, 128, 128)
local color39 = Color3.fromRGB(139, 69, 19)

t2.value21 = nil
t2.value22 = {
	["Black"] = value12,
	["White"] = Workspace,
	["Red"] = result,
	["Blue"] = color3,
	["Yellow"] = color32,
	["Pink"] = color33,
	["Orange"] = color34,
	["Green"] = color35,
	["Purple"] = color36,
	["Cyan"] = color37,
	["Gray"] = color38,
	["Brown"] = color39
}
t2.value23 = {}
t2.value24 = nil
t2.value25 = nil
t2.value24 = 0
function t2.value26()
    if not (tick() - t2.value24 > 5) then
        return t2.value23
    end

    t2.value23 = {}

    for _, descendant in ipairs(t2.value6:GetDescendants()) do
        local isBasePart = descendant:IsA("BasePart")

        if isBasePart then
            isBasePart = descendant.Name:lower():find("pad")
        end

        if isBasePart then
            isBasePart = t2.value23
            table.insert(isBasePart, descendant)
        end
    end

    t2.value24 = tick()

    return t2.value23
end
function t2.value27(p7)
    if not p7 or (p7 == t2.value10 and true or not p7.Parent) then
        return false
    end

    local Team = p7.Team
    local Humanoid, v27, v28, Parent

    if not Team then
        if Team then
            return false
        else
            Team = p7.Character

            if Team and (Team.Parent and Team:IsDescendantOf(t2.value6)) then
                Humanoid = Team:FindFirstChildOfClass("Humanoid")
                v27 = not Humanoid
                v28 = Team:FindFirstChild("HumanoidRootPart")

                if v27 or (Humanoid.Health <= 0 or not (v28 and v28.Parent)) then
                    return false
                else
                    v27 = v28.Position

                    for _, v in ipairs(t2.value26()) do
                        if v then
                            Parent = v.Parent

                            if Parent then
                                Parent = (v27 - v.Position).Magnitude <= 130
                            end
                        else
                            Parent = v
                        end

                        if Parent then
                            return false
                        end
                    end

                    return true, v28, Humanoid, Team
                end

                return
            else
                return false
            end

            return
        end

        return
    end

    Team = t2.value10.Team

    if not Team then
        if Team then
            return false
        else
            Team = p7.Character

            if Team and (Team.Parent and Team:IsDescendantOf(t2.value6)) then
                Humanoid = Team:FindFirstChildOfClass("Humanoid")
                v27 = not Humanoid
                v28 = Team:FindFirstChild("HumanoidRootPart")

                if v27 or (Humanoid.Health <= 0 or not (v28 and v28.Parent)) then
                    return false
                else
                    v27 = v28.Position

                    for _, v in ipairs(t2.value26()) do
                        if v then
                            Parent = v.Parent

                            if Parent then
                                Parent = (v27 - v.Position).Magnitude <= 130
                            end
                        else
                            Parent = v
                        end

                        if Parent then
                            return false
                        end
                    end

                    return true, v28, Humanoid, Team
                end

                return
            else
                return false
            end

            return
        end

        return
    end

    Team = p7.Team == t2.value10.Team

    if Team then
        return false
    else
        Team = p7.Character

        if Team and (Team.Parent and Team:IsDescendantOf(t2.value6)) then
            Humanoid = Team:FindFirstChildOfClass("Humanoid")
            v27 = not Humanoid
            v28 = Team:FindFirstChild("HumanoidRootPart")

            if v27 or (Humanoid.Health <= 0 or not (v28 and v28.Parent)) then
                return false
            else
                v27 = v28.Position

                for _, v in ipairs(t2.value26()) do
                    if v then
                        Parent = v.Parent

                        if Parent then
                            Parent = (v27 - v.Position).Magnitude <= 130
                        end
                    else
                        Parent = v
                    end

                    if Parent then
                        return false
                    end
                end

                return true, v28, Humanoid, Team
            end

            return
        else
            return false
        end

        return
    end
end
t2.value28 = nil
function t2.value29(p8)
    local Character = t2.value10.Character
    local GetChildren, isTool

    if not Character then
        v49 = t2.value10:FindFirstChild("Backpack")

        if v49 and Character then
            GetChildren = v49.GetChildren

            for _, v in ipairs(GetChildren(v49)) do
                isTool = v:IsA("Tool")

                if isTool then
                    isTool = v.Name ~= "Shahed"
                end

                if isTool then
                    Character:EquipTool(v)

                    if not p8 then
                        return v
                    end
                end
            end

            return
        else
            return
        end

        return
    end

    Character = Character:FindFirstChildOfClass("Humanoid")

    local Backpack = t2.value10:FindFirstChild("Backpack")

    if Backpack and Character then
        GetChildren = Backpack.GetChildren

        for _, v in ipairs(GetChildren(Backpack)) do
            isTool = v:IsA("Tool")

            if isTool then
                isTool = v.Name ~= "Shahed"
            end

            if isTool then
                Character:EquipTool(v)

                if not p8 then
                    return v
                end
            end
        end

        return
    else
        return
    end
end
function t2.value30()
    t2.value29(true)
end
function t2.value31()
    local Character = t2.value10.Character

    if Character then
        Character = Character:FindFirstChildOfClass("Tool")

        local v45

        if Character then
            v45 = Character.Name ~= "Shahed"
        else
            v45 = Character
        end

        if v45 then
            return Character
        else
            return t2.value29(false)
        end

        return
    else
        return
    end
end
t2.value32 = "MonochromeHubV2_Config.json"
function t2.value33()
    if not writefile then
        return
    end

    local function v46()
        local t3 = {}

        for k, v in pairs(t2.value20) do
            local Name

            if typeof(v) == "EnumItem" then
                Name = v.Name
            else
                Name = false
            end

            local v51

            if Name then
                v51 = Name
            elseif typeof(v51) == "Color3" or not v51 then
                v51 = nil
            end

            t3[k] = v51
        end

        writefile(t2.value32, t2.value7:JSONEncode(t3))
    end

    pcall(v46)
end
function t2.value34()
    local readfile_ = readfile

    if readfile_ then
        readfile_ = isfile

        if readfile_ then
            readfile_ = isfile(t2.value32)
        end
    end

    if not readfile_ then
        return
    end

    local result2

    readfile_, result2 = pcall(function()
        return t2.value7:JSONDecode(unpack_({ readfile(t2.value32) }))
    end)

    if not readfile_ then
        if readfile_ then
            return result2
        else
            return
        end

        return
    end

    readfile_ = type(result2) == "table"

    if readfile_ then
        return result2
    else
        return
    end
end
function t2.value35(p9)
    if not p9 then
        return
    end

    local ESPColorName, v55, v56 = pairs(p9)

    while true do
        local v57

        v56, v57 = ESPColorName(v55, v56)

        if not v56 then
            break
        end

        if t2.value20[v56] ~= nil then
            local v58 = v56 == "InvisibilityKeybind"

            if v58 then
                v58 = type(v57) == "string"
            end

            if v58 then
                v57 = function()
                    t2.value20[v56] = Enum.KeyCode[v57]
                end
                pcall(v57)
            else
                t2.value20[v56] = v57
            end
        end
    end

    ESPColorName = t2.value20.ESPColorName

    if ESPColorName then
        ESPColorName = t2.value22[t2.value20.ESPColorName]
    end

    if not ESPColorName then
        return
    end

    t2.value20.ESPColor = t2.value22[t2.value20.ESPColorName]
end
t2.value28 = nil
t2.value36 = nil
t2.value37 = nil
t2.value38 = false
t2.value39 = nil
t2.value40 = nil
t2.value41 = nil
t2.value42 = nil
t2.value42 = nil
t2.value25 = 16
t2.value21 = nil
function t2.value43()
    t2.value38 = false

    if t2.value41 then
        task.cancel(t2.value41)
    end

    if t2.value42 then
        t2.value42:Disconnect()
        t2.value42 = nil
    end

    local function cameraSubject()
        t2.value10.ReplicationFocus = nil
    end

    pcall(cameraSubject)
    cameraSubject = t2.value20.InvisibilityActive

    if cameraSubject then
        cameraSubject = t2.value28
    end

    cameraSubject = cameraSubject or t2.value10.Character
    cameraSubject = cameraSubject and cameraSubject:FindFirstChildOfClass("Humanoid")

    if cameraSubject then
        cameraSubject.WalkSpeed = t2.value25
        t2.value11.CameraSubject = cameraSubject
        t2.value11.CameraType = Enum.CameraType.Custom
    end

    if t2.value40 then
        t2.value40:Destroy()
    end

    if t2.value39 then
        t2.value39:Destroy()
        t2.value39 = nil
    end

    if not t2.value21 then
        return
    end

    t2.value21:Destroy()
    t2.value21 = nil
end
function t2.value44()
    local InvisibilityActive = t2.value20.InvisibilityActive
    local isTool
    if not InvisibilityActive then
        InvisibilityActive = InvisibilityActive or t2.value10.Character

        if InvisibilityActive then
            for _, child in ipairs(InvisibilityActive:GetChildren()) do
                isTool = child:IsA("Tool")

                if isTool then
                    isTool = child.Name ~= "Shahed"
                end

                if isTool then
                    return child
                end
            end

            return t2.value29(false)
        else
            return
        end

        return
    end
    InvisibilityActive = t2.value28 or t2.value10.Character
    if InvisibilityActive then
        for _, child in ipairs(InvisibilityActive:GetChildren()) do
            isTool = child:IsA("Tool")

            if isTool then
                isTool = child.Name ~= "Shahed"
            end

            if isTool then
                return child
            end
        end

        return t2.value29(false)
    else
        return
    end
end
t2.value45 = nil
t2.value46 = nil
function t2.value47(_)
    if not t2.value38 then
        return
    end
end
function t2.value46()
    if t2.value20.ShahedEnabled then
        local Backpack = t2.value10:WaitForChild("Backpack", 5)

        if not Backpack then
            return
        end

        return
    else
        return
    end
end
function t2.value45()
    if t2.value38 then
        return
    end

    local InvisibilityActive = t2.value20.InvisibilityActive
    local Humanoid, HumanoidRootPart

    if not InvisibilityActive then
        InvisibilityActive = InvisibilityActive or t2.value10.Character

        if InvisibilityActive then
            Humanoid = InvisibilityActive:FindFirstChildOfClass("Humanoid")
            HumanoidRootPart = InvisibilityActive:FindFirstChild("HumanoidRootPart") or InvisibilityActive.PrimaryPart

            if not (Humanoid and HumanoidRootPart) then
                return
            end

            return
        else
            return
        end

        return
    end

    InvisibilityActive = t2.value28
    InvisibilityActive = InvisibilityActive or t2.value10.Character

    if InvisibilityActive then
        Humanoid = InvisibilityActive:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = InvisibilityActive:FindFirstChild("HumanoidRootPart") or InvisibilityActive.PrimaryPart

        if not (Humanoid and HumanoidRootPart) then
            return
        end

        return
    else
        return
    end
end
t2.value10.CharacterAdded:Connect(function(character)
    t2.value43()
    character:WaitForChild("Humanoid")
    task.wait(0.5)

    if not t2.value20.ShahedEnabled then
        return
    end

    t2.value46()
end)

function t2.value48()
end
function t2.value49(p10, p11)
    if p11 and p10 then
        local raycastParams = RaycastParams.new()

        raycastParams.FilterDescendantsInstances = { t2.value10.Character, t2.value28 }
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams = t2.value6:Raycast(p10, p11.Position - p10, raycastParams)

        local Instance_

        if raycastParams then
            Instance_ = raycastParams.Instance

            if not Instance_ then
                return Instance_
            end

            Instance_ = raycastParams.Instance:IsDescendantOf(p11.Parent)
        else
            Instance_ = raycastParams
        end

        return Instance_
    else
        return false
    end
end
t2.value50 = nil
function t2.value50()
    if t2.value36 then
        t2.value36:Disconnect()
    end

    if t2.value28 then
        t2.value28:Destroy()
        t2.value28 = nil
    end

    local Character = t2.value10.Character

    if not Character then
        t2.value37 = nil

        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    Character = Character:FindFirstChild("HumanoidRootPart")

    local value37

    if Character then
        value37 = t2.value37
    else
        value37 = Character
    end

    if value37 then
        Character.CFrame = t2.value37.CFrame
        value37 = Vector3.zero

        local vector3 = Vector3.zero

        Character.AssemblyLinearVelocity = value37
        Character.AssemblyAngularVelocity = vector3
    end

    if not Humanoid then
        t2.value37 = nil

        return
    end

    t2.value11.CameraSubject = Humanoid
    Humanoid.PlatformStand = false
    t2.value37 = nil
end
function t2.value51(p12)
    t2.value20.InvisibilityActive = p12
    t2.value48(p12)

    if p12 then
        local Character = t2.value10.Character

        if Character then
            t2.value30()
            task.wait(0.05)

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not (HumanoidRootPart and Humanoid) then
                return
            end

            return
        else
            return
        end

        return
    else
        return t2.value50()
    end
end
unpack_ = t2.value4.InputBegan
unpack_:Connect(function(p13, p14)
    if p14 or not (t2.value20.InvisibilityActive and t2.value37) then
        return
    end

    if not (p13.UserInputType == Enum.UserInputType.MouseButton1 or p13.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    local Character = t2.value10.Character

    if Character then
        Character = Character:FindFirstChildOfClass("Tool")
    end

    if not Character then
        return
    end

    local v80 = Character.Name:lower()

    if not (v80:find("gun") or (v80:find("\208\191\208\181\209\129\209\130") or (v80:find("\208\191\208\184\209\129\209\130\208\190\208\187\208\181\209\130") or (Character:GetAttribute("Cooldown") or t2.value14)))) then
        return
    end

    Character = t2.value4:GetMouseLocation()
    Character = t2.value11:ViewportPointToRay(Character.X, Character.Y)
    v80 = RaycastParams.new()
    v80.FilterDescendantsInstances = { t2.value10.Character, t2.value28 }
    v80.FilterType = Enum.RaycastFilterType.Exclude
    Character = t2.value6:Raycast(Character.Origin, Character.Direction * 1000, v80)

    if Character then
        v80 = Character.Instance
    else
        v80 = Character
    end

    if not v80 then
        return
    end

    Character = Character.Instance:FindFirstAncestorOfClass("Model")

    if Character then
        Character = t2.value2:GetPlayerFromCharacter(Character)
    end

    Character, v80 = t2.value27(Character)

    if Character then
        Character = t2.value49(t2.value37.Position, v80)

        if Character then
            Character = t2.value14
        end
    end

    if not Character then
        return
    end

    t2.value14:FireServer(t2.value37.Position, v80.Position, v80, v80.Position)
end)
t2.value10.CharacterRemoving:Connect(function()
    if not t2.value20.InvisibilityActive then
        return
    end

    t2.value20.InvisibilityActive = false
    t2.value50()
end)
t2.value52 = 0
t2.value4.JumpRequest:Connect(function()
    local n1 = 6110090
    if t2.value20.InfJumpEnabled then
        local InvisibilityActive = t2.value20.InvisibilityActive

        if InvisibilityActive then
            InvisibilityActive = t2.value28
        end

        InvisibilityActive = InvisibilityActive or t2.value10.Character

        if InvisibilityActive then
            InvisibilityActive = InvisibilityActive:FindFirstChildOfClass("Humanoid")
        end

        if InvisibilityActive then
            InvisibilityActive:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    if not t2.value20.BhopEnabled then
        return
    end
    n1 = t2.value20.InvisibilityActive
    if n1 then
        n1 = t2.value28

        if n1 then
            n1 = t2.value28:FindFirstChildOfClass("Humanoid")
        end
    end
    if not n1 then
        n1 = t2.value10.Character

        if n1 then
            n1 = t2.value10.Character:FindFirstChildOfClass("Humanoid")
        end
    end
    if not n1 then
        return
    end
    t2.value20.BhopBonus = t2.value20.BhopBonus + 3
    t2.value52 = tick()
end)
t2.value5.Stepped:Connect(function()
    if not t2.value20.NoclipEnabled then
        return
    end

    local InvisibilityActive = t2.value20.InvisibilityActive

    if InvisibilityActive then
        InvisibilityActive = t2.value28
    end

    InvisibilityActive = InvisibilityActive or t2.value10.Character

    if not InvisibilityActive then
        return
    end

    for _, descendant in ipairs(InvisibilityActive:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end)
t2.value53 = {}
unpack_ = function(p15, p16, p17)
    local UIStroke = Instance.new("UIStroke")

    for k, v in pairs({
		["Thickness"] = p16 or 1.2,
		["Transparency"] = p17 or 0.8,
		["Parent"] = p15
	}) do
        UIStroke[k] = v
    end

    local t4 = {
		["Color"] = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 15)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) }),
		["Parent"] = UIStroke
	}
    local UIGradient = Instance.new("UIGradient")

    for k, v in pairs(t4) do
        UIGradient[k] = v
    end

    t4 = t2.value53
    table.insert(t4, UIGradient)

    return UIStroke
end
t2.value5.RenderStepped:Connect(function()
    local rotation = tick() * 100 % 360

    for _, v in ipairs(t2.value53) do
        v.Rotation = rotation
    end
end)
t2.value54 = ({
	["CreateWindow"] = function(_, p18)
    local function v96(child)
        local Character = t2.value10.Character

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        if not Character then
            Character = Character or Vector3.new(0, 10, 0)
            v117 = Character + Vector3.new(math.random(-5, 5), math.random(1, 5), math.random(-5, 5))

            return child == "ShootGun" and {
					Character,
					v117,
					t2.value6,
					v117
				} or (child == "ThrowStart" and { Character, (v117 - Character).Unit } or (child == "ThrowHit" and { t2.value6, v117 } or (child == "Stab" and { t2.value6 } or {})))
        end

        Character = Character.Position
        Character = Character or Vector3.new(0, 10, 0)

        local v98 = Character + Vector3.new(math.random(-5, 5), math.random(1, 5), math.random(-5, 5))

        return child == "ShootGun" and {
				Character,
				v98,
				t2.value6,
				v98
			} or (child == "ThrowStart" and { Character, (v98 - Character).Unit } or (child == "ThrowHit" and { t2.value6, v98 } or (child == "Stab" and { t2.value6 } or {})))
    end
    task.spawn(function()
        local value13 = t2.value13

        if value13 then
            value13 = t2.value13:FindFirstChild("ThrowStart")
        end

        value13 = {
				["ShootGun"] = t2.value14,
				["ThrowStart"] = value13,
				["ThrowHit"] = t2.value16,
				["Stab"] = t2.value15
			}

        while true do
            while t2.value20.LagEnabled do
                local Character = t2.value10.Character

                if Character then
                    Character = Character:FindFirstChildOfClass("Tool")
                end

                if Character then
                    Character = value13[t2.value20.LagRemote]

                    if Character then
                        local v101 = v96(t2.value20.LagRemote)

                        for _ = 1, t2.value20.LagBatch do
                            Character:FireServer(unpack(v101))
                        end
                    end
                end

                task.wait(t2.value20.LagDelay)
            end

            task.wait(0.2)
        end
    end)
    v96 = {
			["MaxObjectsPerSecond"] = 15,
			["DisablePhysics"] = true,
			["MuteSpamSounds"] = true,
			["Keywords"] = {
				"knife",
				"blade",
				"throw",
				"handle",
				"projectile",
				"tool"
			}
		}
    local n2 = 0
    local now = os.clock()
    local function v105(p19)
        local v106 = p19.Name:lower()

        for _, keyword in ipairs(v96.Keywords) do
            if v106:find(keyword) then
                return true
            end
        end

        return false
    end
    v96 = function(p20)
        local n3 = 9540607
        if not t2.value20.AntiLagEnabled then
            return
        end
        if os.clock() - now >= 1 then
            n2 = 0
            os.clock()
        end
        n3 = v96.MuteSpamSounds
        if n3 then
            n3 = p20:IsA("Sound")
        end
        if n3 and (n2 > v96.MaxObjectsPerSecond or v105(p20.Parent or p20)) then
            p20:Stop()
            p20.Volume = 0
            p20:Destroy()

            return
        end
        if not ((p20:IsA("BasePart") or p20:IsA("Model")) and v105(p20)) then
            return
        end
        n2 = n2 + 1
        if n2 > v96.MaxObjectsPerSecond then
            task.defer(function()
                local Parent = p20

                if Parent then
                    Parent = p20.Parent
                end

                if not Parent then
                    return
                end

                p20:Destroy()
            end)

            return
        end
        if not v96.DisablePhysics then
            return
        end
        if p20:IsA("BasePart") then
            p20.CanCollide = false
            p20.CanTouch = false
            p20.Massless = true

            return
        end
        for _, descendant in ipairs(p20:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.Massless = true
            end
        end
    end
    t2.value6.ChildAdded:Connect(v96)
    t2.value6.DescendantAdded:Connect(function(descendant)
        if not (descendant:IsA("BasePart") or (descendant:IsA("Sound") or descendant:IsA("Model"))) then
            return
        end

        v96(descendant)
    end)
    v96 = p18 or "MONO<b>HUB</b>"
    now = t1("ScreenGui", {
			["Name"] = "MonochromeHubV2",
			["ResetOnSpawn"] = false,
			["Parent"] = t2.value18
		})
    v105 = function(p21, p22)
        local v113

        if typeof(p22) == "table" then
            v113 = p22
        else
            v113 = false
        end

        local vector2 = Vector2.zero
        local vector22 = Vector2.zero
        local vector23 = Vector2.new(p21.Position.X.Offset, p21.Position.Y.Offset)
        local u117 = false
        local u118 = false

        for _, v in ipairs(v113 or { p22 or p21 }) do
            if v:IsA("GuiObject") then
                v.Active = true
            end

            v.InputBegan:Connect(function(input)
                if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    return
                end

                u117 = true
                u118 = false
                vector2 = Vector2.new(input.Position.X, input.Position.Y)
                vector22 = Vector2.new(p21.Position.X.Offset, p21.Position.Y.Offset)
            end)
        end

        t2.value4.InputChanged:Connect(function(input)
            local v121 = u117

            if v121 then
                v121 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
            end

            if not v121 then
                return
            end

            v121 = Vector2.new(input.Position.X, input.Position.Y) - vector2

            if v121.Magnitude > 5 then
                u118 = true
            end

            vector23 = vector22 + v121
        end)
        t2.value4.InputEnded:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                return
            end

            u117 = false
        end)
        t2.value5.RenderStepped:Connect(function(dt)
            local vector24 = Vector2.new(p21.Position.X.Offset, p21.Position.Y.Offset)

            if not (u117 or (vector24 - vector23).Magnitude > 0.1) then
                return
            end

            local v123 = vector23
            local v124 = dt * 14

            vector24 = vector24:Lerp(v123, (math.clamp(v124, 0, 1)))
            p21.Position = UDim2.new(p21.Position.X.Scale, vector24.X, p21.Position.Y.Scale, vector24.Y)
        end)

        return function()
            return u118
        end
    end
    local Frame = t1("Frame", {
			["Name"] = "FloatingInvisWindow",
			["Size"] = UDim2.new(0, 60, 0, 60),
			["Position"] = UDim2.new(0.05, 0, 0.4, 0),
			["BackgroundColor3"] = Color3.fromRGB(15, 15, 18),
			["BorderSizePixel"] = 0,
			["Active"] = true,
			["ZIndex"] = 999,
			["Visible"] = t2.value20.InvisibilityEnabled,
			["Parent"] = now
		})
    t1("UICorner", {
			["CornerRadius"] = UDim.new(0, 12),
			["Parent"] = Frame
		})
    unpack_(Frame, 1.5, 0.3)
    local TextButton = t1("TextButton", {
			["Size"] = UDim2.new(1, 0, 1, 0),
			["BackgroundTransparency"] = 1,
			["Text"] = "invisible",
			["TextColor3"] = Color3.fromRGB(255, 255, 255),
			["Font"] = Enum.Font.GothamBold,
			["TextSize"] = 9,
			["ZIndex"] = 1000,
			["Parent"] = Frame
		})
    local Frame2 = v105(Frame, { Frame, TextButton })
    TextButton.MouseButton1Click:Connect(function()
        if Frame2() then
            return
        else
            t2.value51(not t2.value20.InvisibilityActive)
            t2.value33()

            return
        end
    end)
    TextButton = t2.value34()
    if TextButton then
        Frame2 = t1("Frame", {
				["Name"] = "ConfigModal",
				["Size"] = UDim2.new(0, 320, 0, 210),
				["Position"] = UDim2.new(0.5, -160, 0.5, -105),
				["BackgroundColor3"] = Color3.fromRGB(16, 16, 20),
				["BorderSizePixel"] = 0,
				["ZIndex"] = 100,
				["Parent"] = now
			})
        v182 = Instance.new("UIScale")

        for k, v in pairs({
				["Scale"] = 0,
				["Parent"] = Frame2
			}) do
            v182[k] = v
        end

        t1("UICorner", {
				["CornerRadius"] = UDim.new(0, 12),
				["Parent"] = Frame2
			})
        unpack_(Frame2, 1.2, 0.4)
        t1("TextLabel", {
				["Size"] = UDim2.new(1, -20, 0, 26),
				["Position"] = UDim2.new(0, 10, 0, 8),
				["BackgroundTransparency"] = 1,
				["Text"] = "Load saved configuration?",
				["TextColor3"] = Color3.fromRGB(255, 255, 255),
				["Font"] = Enum.Font.GothamBold,
				["TextSize"] = 13,
				["ZIndex"] = 101,
				["Parent"] = Frame2
			})
        t1("TextLabel", {
				["Size"] = UDim2.new(1, -20, 0, 18),
				["Position"] = UDim2.new(0, 10, 0, 32),
				["BackgroundTransparency"] = 1,
				["Text"] = "A saved configuration file was detected:",
				["TextColor3"] = Color3.fromRGB(160, 160, 165),
				["Font"] = Enum.Font.Gotham,
				["TextSize"] = 10,
				["ZIndex"] = 101,
				["Parent"] = Frame2
			})
        v_u_183 = t1("TextButton", {
				["Size"] = UDim2.new(1, -24, 0, 28),
				["Position"] = UDim2.new(0, 12, 0, 55),
				["BackgroundColor3"] = Color3.fromRGB(24, 24, 30),
				["Text"] = "  View Settings List \226\150\188",
				["TextColor3"] = Color3.fromRGB(220, 220, 220),
				["Font"] = Enum.Font.GothamMedium,
				["TextSize"] = 10,
				["TextXAlignment"] = Enum.TextXAlignment.Left,
				["ZIndex"] = 101,
				["Parent"] = Frame2
			})
        t1("UICorner", {
				["CornerRadius"] = UDim.new(0, 6),
				["Parent"] = v_u_183
			})
        v_u_184 = t1("ScrollingFrame", {
				["Size"] = UDim2.new(1, -24, 0, 65),
				["Position"] = UDim2.new(0, 12, 0, 88),
				["BackgroundColor3"] = Color3.fromRGB(20, 20, 24),
				["BorderSizePixel"] = 0,
				["ZIndex"] = 102,
				["Visible"] = false,
				["ScrollBarThickness"] = 3,
				["Parent"] = Frame2
			})
        t1("UIListLayout", {
				["SortOrder"] = Enum.SortOrder.LayoutOrder,
				["Padding"] = UDim.new(0, 4),
				["Parent"] = v_u_184
			})

        local n4 = 0

        for k, v in pairs(TextButton) do
            t1("TextLabel", {
					["Size"] = UDim2.new(1, -10, 0, 16),
					["BackgroundTransparency"] = 1,
					["Text"] = " \226\128\162 " .. tostring(k) .. ": " .. tostring(v),
					["TextColor3"] = Color3.fromRGB(180, 180, 185),
					["Font"] = Enum.Font.Gotham,
					["TextSize"] = 9,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["ZIndex"] = 103,
					["Parent"] = v_u_184
				})
            n4 = n4 + 1
        end

        v_u_184.CanvasSize = UDim2.new(0, 0, 0, n4 * 20)

        local visible = false

        v_u_183.MouseButton1Click:Connect(function()
            visible = not visible
            v_u_184.Visible = visible
            v_u_183.Text = visible and "  Hide Settings List \226\150\178" or "  View Settings List \226\150\188"
        end)
        v_u_183 = t1("TextButton", {
				["Size"] = UDim2.new(0, 135, 0, 32),
				["Position"] = UDim2.new(0, 12, 1, -42),
				["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
				["Text"] = "Load",
				["TextColor3"] = Color3.fromRGB(0, 0, 0),
				["Font"] = Enum.Font.GothamBold,
				["TextSize"] = 11,
				["ZIndex"] = 101,
				["Parent"] = Frame2
			})
        t1("UICorner", {
				["CornerRadius"] = UDim.new(0, 8),
				["Parent"] = v_u_183
			})
        v_u_184 = t1("TextButton", {
				["Size"] = UDim2.new(0, 135, 0, 32),
				["Position"] = UDim2.new(1, -147, 1, -42),
				["BackgroundColor3"] = Color3.fromRGB(30, 30, 36),
				["Text"] = "Reset",
				["TextColor3"] = Color3.fromRGB(200, 200, 200),
				["Font"] = Enum.Font.GothamBold,
				["TextSize"] = 11,
				["ZIndex"] = 101,
				["Parent"] = Frame2
			})
        t1("UICorner", {
				["CornerRadius"] = UDim.new(0, 8),
				["Parent"] = v_u_184
			})
        t2.value3:Create(v182, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				["Scale"] = 1
			}):Play()

        local u134 = false

        Frame = function()
            t2.value35(TextButton)
            Frame.Visible = t2.value20.InvisibilityEnabled
            u134 = true
        end
        v_u_183.MouseButton1Click:Connect(Frame)
        v_u_184.MouseButton1Click:Connect(function()
            u134 = true
        end)

        while not u134 do
            task.wait(0.1)
        end

        t2.value3:Create(v182, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				["Scale"] = 0
			}):Play()
        task.wait(0.25)
        Frame2:Destroy()
    end
    Frame = t1("Frame", {
			["Name"] = "Notifications",
			["Size"] = UDim2.new(0, 220, 1, -20),
			["Position"] = UDim2.new(1, -230, 0, 15),
			["BackgroundTransparency"] = 1,
			["Parent"] = now
		})
    t1("UIListLayout", {
			["SortOrder"] = Enum.SortOrder.LayoutOrder,
			["VerticalAlignment"] = Enum.VerticalAlignment.Top,
			["Padding"] = UDim.new(0, 6),
			["Parent"] = Frame
		})
    Frame = function(p23, p24, p25)
        local v135 = p25 or 3

        task.spawn(function()
            local Frame3 = t1("Frame", {
					["Size"] = UDim2.new(1, 0, 0, 50),
					["Position"] = UDim2.new(1, 250, 0, 0),
					["BackgroundColor3"] = Color3.fromRGB(18, 18, 22),
					["BorderSizePixel"] = 0,
					["ClipsDescendants"] = true,
					["Parent"] = Frame
				})

            t1("UICorner", {
					["CornerRadius"] = UDim.new(0, 8),
					["Parent"] = Frame3
				})
            unpack_(Frame3, 1.2, 0.4)
            t1("TextLabel", {
					["Size"] = UDim2.new(1, -16, 0, 18),
					["Position"] = UDim2.new(0, 10, 0, 5),
					["BackgroundTransparency"] = 1,
					["Text"] = p23,
					["TextColor3"] = Color3.fromRGB(255, 255, 255),
					["Font"] = Enum.Font.GothamBold,
					["TextSize"] = 12,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["Parent"] = Frame3
				})
            t1("TextLabel", {
					["Size"] = UDim2.new(1, -16, 0, 18),
					["Position"] = UDim2.new(0, 10, 0, 21),
					["BackgroundTransparency"] = 1,
					["Text"] = p24,
					["TextColor3"] = Color3.fromRGB(170, 170, 175),
					["Font"] = Enum.Font.Gotham,
					["TextSize"] = 10,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["Parent"] = Frame3
				})

            local Frame4 = t1("Frame", {
					["Size"] = UDim2.new(1, -20, 0, 3),
					["Position"] = UDim2.new(0, 10, 1, -6),
					["BackgroundColor3"] = Color3.fromRGB(30, 30, 36),
					["BorderSizePixel"] = 0,
					["ClipsDescendants"] = true,
					["Parent"] = Frame3
				})

            Frame4 = t1("Frame", {
					["Size"] = UDim2.new(1, 0, 1, 0),
					["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
					["BorderSizePixel"] = 0,
					["Parent"] = Frame4
				})

            local value3 = t2.value3
            local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local t5 = {
					["Position"] = UDim2.new(0, 0, 0, 0)
				}

            value3.Create(value3, Frame3, tweenInfo, t5):Play()
            value3 = t2.value3
            tweenInfo = TweenInfo.new(v135, Enum.EasingStyle.Linear)
            t5 = {
					["Size"] = UDim2.new(0, 0, 1, 0)
				}
            value3.Create(value3, Frame4, tweenInfo, t5):Play()
            task.wait(v135)
            Frame4 = t2.value3
            value3 = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            tweenInfo = {
					["Position"] = UDim2.new(1, 250, 0, 0)
				}
            Frame4 = Frame4:Create(Frame3, value3, tweenInfo)
            Frame4:Play()
            Frame4.Completed:Connect(function()
                Frame3:Destroy()
            end)
        end)
    end
    TextButton = t1("Frame", {
			["Name"] = "MainFrame",
			["Size"] = UDim2.new(0, 520, 0, 350),
			["Position"] = UDim2.new(0.5, -260, 0.5, -175),
			["BackgroundColor3"] = Color3.fromRGB(14, 14, 16),
			["BorderSizePixel"] = 0,
			["ClipsDescendants"] = true,
			["Active"] = true,
			["Parent"] = now
		})
    Frame2 = t1("Frame", {
			["Name"] = "SnowContainer",
			["Size"] = UDim2.new(1, 0, 1, 0),
			["BackgroundTransparency"] = 1,
			["ClipsDescendants"] = true,
			["ZIndex"] = 1,
			["Parent"] = TextButton
		})
    local t6 = {}
    for i = 1, 25 do
        v189 = math.random(2, 3)
        v189 = t1("Frame", {
				["Size"] = UDim2.new(0, v189, 0, v189),
				["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
				["BackgroundTransparency"] = math.random(25, 65) / 100,
				["BorderSizePixel"] = 0,
				["ZIndex"] = 1,
				["Parent"] = Frame2
			})
        t1("UICorner", {
				["CornerRadius"] = UDim.new(1, 0),
				["Parent"] = v189
			})
        table.insert(t6, {
				["frame"] = v189,
				["x"] = math.random(),
				["y"] = math.random(),
				["speed"] = math.random(12, 32) / 1000,
				["sway"] = math.random(1, 3) / 100,
				["freq"] = math.random(2, 5)
			})
    end
    Frame2 = t2.value5.RenderStepped
    Frame2:Connect(function(p26)
        local now2 = tick()

        for _, v in ipairs(t6) do
            v.y = v.y + v.speed * p26 * 10

            if v.y > 1 then
                v178 = math.random()
                v.y = -0.05
                v.x = v178
            end

            local frame = v.frame
            local uDim2New = UDim2.new
            local x = v.x
            local v149 = now2 * v.freq

            frame.Position = uDim2New(x + math.sin(v149) * v.sway, 0, v.y, 0)
        end
    end)
    Frame2 = t1("UIScale", {
			["Scale"] = 0,
			["Parent"] = TextButton
		})
    t1("UICorner", {
			["CornerRadius"] = UDim.new(0, 12),
			["Parent"] = TextButton
		})
    unpack_(TextButton, 1.5, 0.3)
    local Frame3 = t1("Frame", {
			["Name"] = "TopBarDrag",
			["Size"] = UDim2.new(1, -70, 0, 35),
			["Position"] = UDim2.new(0, 0, 0, 0),
			["BackgroundTransparency"] = 1,
			["ZIndex"] = 2,
			["Parent"] = TextButton
		})
    local TextButton2 = t1("TextButton", {
			["Name"] = "ToggleCircle",
			["Size"] = UDim2.new(0, 46, 0, 46),
			["Position"] = UDim2.new(0, 20, 0.5, -23),
			["BackgroundColor3"] = Color3.fromRGB(20, 20, 25),
			["Text"] = "M",
			["TextColor3"] = Color3.fromRGB(255, 255, 255),
			["Font"] = Enum.Font.GothamBold,
			["TextSize"] = 18,
			["AutoButtonColor"] = false,
			["Active"] = true,
			["Visible"] = false,
			["Parent"] = now
		})
    local UIScale = Instance.new("UIScale")
    for k, v in pairs({
			["Scale"] = 0,
			["Parent"] = TextButton2
		}) do
        UIScale[k] = v
    end
    t1("UICorner", {
			["CornerRadius"] = UDim.new(1, 0),
			["Parent"] = TextButton2
		})
    unpack_(TextButton2, 1.5, 0.3)
    v105(TextButton2)
    UIScale = function(p27, p28)
        if p28 then
            TextButton.Visible = p27
            TextButton2.Visible = not p27
            Frame2.Scale = p27 and 1 or 0
            UIScale.Scale = p27 and 0 or 1

            return
        else
            if p27 then
                TextButton.Visible = true
                t2.value3:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
						["Scale"] = 0
					}):Play()
                task.wait(0.15)
                TextButton2.Visible = false
                t2.value3:Create(Frame2, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						["Scale"] = 1
					}):Play()

                return
            end

            return
        end
    end
    TextButton.Visible = true
    t2.value3:Create(Frame2, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			["Scale"] = 1
		}):Play()
    t6 = t1("Frame", {
			["Name"] = "TopControls",
			["Size"] = UDim2.new(0, 60, 0, 26),
			["Position"] = UDim2.new(1, -65, 0, 6),
			["BackgroundTransparency"] = 1,
			["ZIndex"] = 3,
			["Parent"] = TextButton
		})
    local TextButton3 = t1("TextButton", {
			["Size"] = UDim2.new(0, 24, 0, 24),
			["Position"] = UDim2.new(0, 0, 0, 0),
			["BackgroundColor3"] = Color3.fromRGB(25, 25, 30),
			["Text"] = "\226\128\148",
			["TextColor3"] = Color3.fromRGB(200, 200, 200),
			["Font"] = Enum.Font.GothamBold,
			["TextSize"] = 12,
			["Parent"] = t6
		})
    t1("UICorner", {
			["CornerRadius"] = UDim.new(0, 6),
			["Parent"] = TextButton3
		})
    t6 = t1("TextButton", {
			["Size"] = UDim2.new(0, 24, 0, 24),
			["Position"] = UDim2.new(0, 28, 0, 0),
			["BackgroundColor3"] = Color3.fromRGB(25, 25, 30),
			["Text"] = "\226\156\149",
			["TextColor3"] = Color3.fromRGB(255, 255, 255),
			["Font"] = Enum.Font.GothamBold,
			["TextSize"] = 10,
			["Parent"] = t6
		})
    t1("UICorner", {
			["CornerRadius"] = UDim.new(0, 6),
			["Parent"] = t6
		})
    TextButton3.MouseButton1Click:Connect(function()
        UIScale(false, false)
    end)
    TextButton2.MouseButton1Click:Connect(function()
        UIScale(true, false)
    end)
    t6.MouseButton1Click:Connect(function()
        t2.value3:Create(Frame2, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				["Scale"] = 0
			}):Play()
        task.wait(0.4)
        now:Destroy()
    end)
    now = t1("Frame", {
			["Name"] = "Sidebar",
			["Size"] = UDim2.new(0, 150, 1, 0),
			["BackgroundColor3"] = Color3.fromRGB(18, 18, 22),
			["BorderSizePixel"] = 0,
			["Active"] = true,
			["ZIndex"] = 2,
			["Parent"] = TextButton
		})
    v105(TextButton, { now, Frame3 })
    t1("UICorner", {
			["CornerRadius"] = UDim.new(0, 12),
			["Parent"] = now
		})
    unpack_(now, 1, 0.5)
    t1("TextLabel", {
			["Size"] = UDim2.new(1, -16, 0, 35),
			["Position"] = UDim2.new(0, 10, 0, 6),
			["BackgroundTransparency"] = 1,
			["Text"] = v96,
			["RichText"] = true,
			["TextColor3"] = Color3.fromRGB(255, 255, 255),
			["TextSize"] = 15,
			["Font"] = Enum.Font.GothamBold,
			["TextXAlignment"] = Enum.TextXAlignment.Left,
			["ZIndex"] = 3,
			["Parent"] = now
		})
    v96 = t1("Frame", {
			["Size"] = UDim2.new(1, -16, 0, 36),
			["Position"] = UDim2.new(0, 8, 1, -44),
			["BackgroundColor3"] = Color3.fromRGB(24, 24, 28),
			["ZIndex"] = 4,
			["Parent"] = now
		})
    t1("UICorner", {
			["CornerRadius"] = UDim.new(0, 8),
			["Parent"] = v96
		})
    unpack_(v96, 1, 0.6)
    v105 = t1("ImageLabel", {
			["Size"] = UDim2.new(0, 24, 0, 24),
			["Position"] = UDim2.new(0, 6, 0.5, -12),
			["BackgroundTransparency"] = 1,
			["Image"] = "rbxthumb://type=AvatarHeadShot&id=" .. t2.value10.UserId .. "&w=150&h=150",
			["ZIndex"] = 5,
			["Parent"] = v96
		})
    t1("UICorner", {
			["CornerRadius"] = UDim.new(1, 0),
			["Parent"] = v105
		})
    t1("TextLabel", {
			["Size"] = UDim2.new(1, -38, 1, 0),
			["Position"] = UDim2.new(0, 34, 0, 0),
			["BackgroundTransparency"] = 1,
			["Text"] = t2.value10.DisplayName or t2.value10.Name,
			["TextColor3"] = Color3.fromRGB(240, 240, 240),
			["TextSize"] = 10,
			["Font"] = Enum.Font.GothamBold,
			["TextXAlignment"] = Enum.TextXAlignment.Left,
			["TextTruncate"] = Enum.TextTruncate.AtEnd,
			["ZIndex"] = 5,
			["Parent"] = v96
		})
    v96 = t1("Frame", {
			["Size"] = UDim2.new(1, -16, 1, -135),
			["Position"] = UDim2.new(0, 8, 0, 45),
			["BackgroundTransparency"] = 1,
			["ZIndex"] = 3,
			["Parent"] = now
		})
    t1("UIListLayout", {
			["SortOrder"] = Enum.SortOrder.LayoutOrder,
			["Padding"] = UDim.new(0, 5),
			["Parent"] = v96
		})
    now = t1("Frame", {
			["Name"] = "ContentHolder",
			["Size"] = UDim2.new(1, -160, 1, -40),
			["Position"] = UDim2.new(0, 155, 0, 35),
			["BackgroundTransparency"] = 1,
			["ZIndex"] = 2,
			["Parent"] = TextButton
		})
    v105 = {
			["Notify"] = Frame,
			["ToggleHub"] = UIScale
		}
    Frame = {}
    local v156
    TextButton = function(p29)
        if v156 == p29 then
            return
        end
    end
    function v105.CreateTab(_, p30)
        local TextButton4 = t1("TextButton", {
				["Size"] = UDim2.new(1, 0, 0, 30),
				["BackgroundColor3"] = Color3.fromRGB(22, 22, 26),
				["Text"] = p30,
				["TextColor3"] = Color3.fromRGB(160, 160, 165),
				["TextSize"] = 11,
				["Font"] = Enum.Font.GothamMedium,
				["AutoButtonColor"] = false,
				["Active"] = true,
				["ZIndex"] = 3,
				["Parent"] = v96
			})

        t1("UICorner", {
				["CornerRadius"] = UDim.new(0, 6),
				["Parent"] = TextButton4
			})

        local ScrollingFrame = t1("ScrollingFrame", {
				["Size"] = UDim2.new(1, -8, 1, -8),
				["Position"] = UDim2.new(0, 4, 0, 4),
				["BackgroundTransparency"] = 1,
				["BorderSizePixel"] = 0,
				["ScrollBarThickness"] = 3,
				["ScrollBarImageColor3"] = Color3.fromRGB(255, 255, 255),
				["Visible"] = false,
				["ZIndex"] = 2,
				["AutomaticCanvasSize"] = Enum.AutomaticSize.Y,
				["CanvasSize"] = UDim2.new(0, 0, 0, 0),
				["Parent"] = now
			})

        t1("UIListLayout", {
				["SortOrder"] = Enum.SortOrder.LayoutOrder,
				["Padding"] = UDim.new(0, 6),
				["Parent"] = ScrollingFrame
			})
        Frame[p30] = {
				["Button"] = TextButton4,
				["Page"] = ScrollingFrame
			}
        TextButton4.MouseButton1Click:Connect(function()
            TextButton(p30)
        end)

        if not v156 then
            TextButton(p30)
        end

        TextButton4 = {}
        ScrollingFrame = function(p31)
            local t7 = {
					["Size"] = UDim2.new(1, -8, 0, p31 or 38),
					["BackgroundTransparency"] = 1,
					["ZIndex"] = 2,
					["Parent"] = ScrollingFrame
				}
            local Frame4 = Instance.new("Frame")

            for k, v in pairs(t7) do
                Frame4[k] = v
            end

            t7 = t1("Frame", {
					["Name"] = "Inner",
					["Size"] = UDim2.new(1, 0, 1, 0),
					["BackgroundColor3"] = Color3.fromRGB(22, 22, 26),
					["BorderSizePixel"] = 0,
					["Active"] = true,
					["ZIndex"] = 2,
					["Parent"] = Frame4
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(0, 8),
					["Parent"] = t7
				})

            return t7
        end

        function TextButton4.CreateKeybind(_, p32, p33, p34)
            local TextButton5 = ScrollingFrame(38)
            local Unknown = p33 or Enum.KeyCode.Unknown
            local u165 = false

            t1("TextLabel", {
					["Size"] = UDim2.new(0.6, 0, 1, 0),
					["Position"] = UDim2.new(0, 10, 0, 0),
					["BackgroundTransparency"] = 1,
					["Text"] = p32,
					["TextColor3"] = Color3.fromRGB(240, 240, 240),
					["TextSize"] = 11,
					["Font"] = Enum.Font.GothamMedium,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["ZIndex"] = 3,
					["Parent"] = TextButton5
				})
            TextButton5 = t1("TextButton", {
					["Size"] = UDim2.new(0.35, 0, 0, 22),
					["Position"] = UDim2.new(0.62, 0, 0.5, -11),
					["BackgroundColor3"] = Color3.fromRGB(32, 32, 38),
					["Text"] = Unknown.Name,
					["TextColor3"] = Color3.fromRGB(255, 255, 255),
					["Font"] = Enum.Font.Gotham,
					["TextSize"] = 10,
					["ZIndex"] = 3,
					["Parent"] = TextButton5
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(0, 5),
					["Parent"] = TextButton5
				})
            TextButton5.MouseButton1Click:Connect(function()
                u165 = true
                TextButton5.Text = "..."
            end)
            t2.value4.InputBegan:Connect(function(input, gameProcessed)
                local v166 = u165

                if v166 then
                    v166 = input.UserInputType == Enum.UserInputType.Keyboard
                end

                if v166 then
                    Unknown = input.KeyCode
                    TextButton5.Text = Unknown.Name

                    if p34 then
                        p34(Unknown, false)

                        return
                    else
                        return
                    end

                    return
                end

                v166 = not gameProcessed

                if v166 then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        v166 = input.KeyCode == Unknown
                    else
                        v166 = false
                    end
                end

                if not (v166 and p34) then
                    return
                end

                p34(Unknown, true)
            end)
        end
        function TextButton4.CreateToggle(_, p35, p36, p37)
            local TextButton5 = ScrollingFrame(40)
            local u168 = p36 or false

            t1("TextLabel", {
					["Size"] = UDim2.new(1, -60, 1, 0),
					["Position"] = UDim2.new(0, 10, 0, 0),
					["BackgroundTransparency"] = 1,
					["Text"] = p35,
					["TextColor3"] = Color3.fromRGB(240, 240, 240),
					["TextSize"] = 11,
					["Font"] = Enum.Font.GothamMedium,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["ZIndex"] = 3,
					["Parent"] = TextButton5
				})

            local Frame4 = t1
            local uDim2 = UDim2.new(0, 38, 0, 18)
            local uDim22 = UDim2.new(1, -48, 0.5, -9)
            local color310

            if u168 then
                color310 = Color3.fromRGB(255, 255, 255)
            end

            TextButton5 = Frame4("TextButton", {
					["Size"] = uDim2,
					["Position"] = uDim22,
					["BackgroundColor3"] = color310 or Color3.fromRGB(35, 35, 40),
					["Text"] = "",
					["Active"] = true,
					["ZIndex"] = 3,
					["Parent"] = TextButton5
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(1, 0),
					["Parent"] = TextButton5
				})
            Frame4 = t1
            uDim2 = UDim2.new(0, 12, 0, 12)

            if u168 then
                uDim22 = UDim2.new(1, -14, 0.5, -6)
            end

            uDim22 = uDim22 or UDim2.new(0, 2, 0.5, -6)

            if u168 then
                color310 = Color3.fromRGB(0, 0, 0)
            end

            Frame4 = Frame4("Frame", {
					["Size"] = uDim2,
					["Position"] = uDim22,
					["BackgroundColor3"] = color310 or Color3.fromRGB(180, 180, 180),
					["BorderSizePixel"] = 0,
					["ZIndex"] = 4,
					["Parent"] = TextButton5
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(1, 0),
					["Parent"] = Frame4
				})
            Frame4 = function(p38)
                local value3 = t2.value3
                local v174 = TextButton5
                local tweenInfo = TweenInfo.new(0.2)

                if p38 then
                    v222 = Color3.fromRGB(255, 255, 255)
                else
                    v222 = p38
                end

                local v222_ = v222 or Color3.fromRGB(35, 35, 40)

                value3.Create(value3, v174, tweenInfo, {
						["BackgroundColor3"] = v222_
					}):Play()
                value3 = t2.value3
                v174 = Frame4
                tweenInfo = TweenInfo.new(0.2)

                if p38 then
                    v222_ = UDim2.new(1, -14, 0.5, -6)
                else
                    v222_ = p38
                end

                v222_ = v222_ or UDim2.new(0, 2, 0.5, -6)

                if not p38 then
                    value3:Create(v174, tweenInfo, {
							["Position"] = v222_,
							["BackgroundColor3"] = p38 or Color3.fromRGB(180, 180, 180)
						}):Play()

                    return
                end

                p38 = Color3.fromRGB(0, 0, 0)
                value3:Create(v174, tweenInfo, {
						["Position"] = v222_,
						["BackgroundColor3"] = p38 or Color3.fromRGB(180, 180, 180)
					}):Play()
            end
            TextButton5.MouseButton1Click:Connect(function()
                u168 = not u168
                Frame4(u168)

                if not p37 then
                    return
                end

                p37(u168)
            end)

            return function(p39)
                u168 = p39
                Frame4(u168)
            end
        end
        function TextButton4.CreateSlider(_, p40, p41, p42, p43, p44)
            local Frame4 = ScrollingFrame(44)
            local v179 = math.clamp(p43 or p41, p41, p42)

            t1("TextLabel", {
					["Size"] = UDim2.new(0.5, 0, 0, 18),
					["Position"] = UDim2.new(0, 10, 0, 4),
					["BackgroundTransparency"] = 1,
					["Text"] = p40,
					["TextColor3"] = Color3.fromRGB(240, 240, 240),
					["TextSize"] = 11,
					["Font"] = Enum.Font.GothamMedium,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["ZIndex"] = 3,
					["Parent"] = Frame4
				})

            local TextBox = v179

            TextBox = t1("TextBox", {
					["Size"] = UDim2.new(0.3, 0, 0, 18),
					["Position"] = UDim2.new(0.7, -10, 0, 4),
					["BackgroundTransparency"] = 1,
					["Text"] = tostring(TextBox),
					["TextColor3"] = Color3.fromRGB(255, 255, 255),
					["TextSize"] = 11,
					["Font"] = Enum.Font.Gotham,
					["TextXAlignment"] = Enum.TextXAlignment.Right,
					["ClearTextOnFocus"] = false,
					["ZIndex"] = 4,
					["Parent"] = Frame4
				})
            Frame4 = t1("Frame", {
					["Size"] = UDim2.new(1, -20, 0, 6),
					["Position"] = UDim2.new(0, 10, 1, -12),
					["BackgroundColor3"] = Color3.fromRGB(35, 35, 42),
					["BorderSizePixel"] = 0,
					["Active"] = true,
					["ZIndex"] = 3,
					["Parent"] = Frame4
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(1, 0),
					["Parent"] = Frame4
				})

            local v180 = (v179 - p41) / (p42 - p41)

            v180 = t1("Frame", {
					["Size"] = UDim2.new(v180, 0, 1, 0),
					["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
					["BorderSizePixel"] = 0,
					["ZIndex"] = 4,
					["Parent"] = Frame4
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(1, 0),
					["Parent"] = v180
				})

            local u181 = false

            v180 = function(p45)
                local v183 = math.clamp(p45, p41, p42)
                local v184 = p42 - p41 > 20

                if v184 then
                    v184 = math.floor(v183)
                end

                if not v184 then
                    v183 = v183 * 100
                    v184 = math.floor(v183) / 100
                end

                TextBox.Text = tostring(v184)
                v183 = (v184 - p41) / (p42 - p41)
                v180.Size = UDim2.new(v183, 0, 1, 0)

                if not p44 then
                    return
                end

                p44(v184)
            end
            TextBox.FocusLost:Connect(function()
                local Text = TextBox.Text

                Text = tonumber(Text:match("-?%d+%.?%d*"))

                if Text then
                    v180(Text)

                    return
                else
                    Text = v179
                    TextBox.Text = tostring(Text)

                    return
                end
            end)
            TextBox = function(p46)
                local v185 = (p46.Position.X - Frame4.AbsolutePosition.X) / Frame4.AbsoluteSize.X

                v185 = math.clamp(v185, 0, 1)
                v180(p41 + (p42 - p41) * v185)
            end
            Frame4.InputBegan:Connect(function(input)
                if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    return
                end

                u181 = true
                TextBox(input)
            end)
            t2.value4.InputChanged:Connect(function(input)
                local v186 = u181

                if v186 then
                    v186 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
                end

                if not v186 then
                    return
                end

                TextBox(input)
            end)
            t2.value4.InputEnded:Connect(function(input)
                local _ = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
            end)
        end
        function TextButton4.CreateDropdown(_, p47, p48, p49, p50)
            local v188 = ScrollingFrame(38)
            local u189 = false
            local v190 = p49 or p48[1]
            t1("TextLabel", {
					["Size"] = UDim2.new(0.5, 0, 0, 38),
					["Position"] = UDim2.new(0, 10, 0, 0),
					["BackgroundTransparency"] = 1,
					["Text"] = p47,
					["TextColor3"] = Color3.fromRGB(240, 240, 240),
					["TextSize"] = 11,
					["Font"] = Enum.Font.GothamMedium,
					["TextXAlignment"] = Enum.TextXAlignment.Left,
					["ZIndex"] = 3,
					["Parent"] = v188
				})
            local TextButton5 = v190
            TextButton5 = t1("TextButton", {
					["Size"] = UDim2.new(0.42, 0, 0, 24),
					["Position"] = UDim2.new(0.55, 0, 0, 7),
					["BackgroundColor3"] = Color3.fromRGB(32, 32, 38),
					["Text"] = tostring(TextButton5) .. "  \226\150\188",
					["TextColor3"] = Color3.fromRGB(255, 255, 255),
					["Font"] = Enum.Font.Gotham,
					["TextSize"] = 10,
					["ZIndex"] = 3,
					["Parent"] = v188
				})
            t1("UICorner", {
					["CornerRadius"] = UDim.new(0, 5),
					["Parent"] = TextButton5
				})
            local ScrollingFrame2 = t1("ScrollingFrame", {
					["Size"] = UDim2.new(0.42, 0, 0, 0),
					["Position"] = UDim2.new(0.55, 0, 0, 34),
					["BackgroundColor3"] = Color3.fromRGB(28, 28, 34),
					["BorderSizePixel"] = 0,
					["Visible"] = false,
					["ZIndex"] = 10,
					["ScrollBarThickness"] = 2,
					["Parent"] = v188
				})
            t1("UIListLayout", {
					["SortOrder"] = Enum.SortOrder.LayoutOrder,
					["Parent"] = ScrollingFrame2
				})
            TextButton5.Text = tostring(v190) .. "  \226\150\188"
            if p50 then
                p50(v190)
            end
            local u194 = v190
            local n5 = 0
            for _, v in ipairs(p48) do
                local MouseButton1Click = t1("TextButton", {
						["Size"] = UDim2.new(1, 0, 0, 22),
						["BackgroundColor3"] = Color3.fromRGB(28, 28, 34),
						["Text"] = tostring(v),
						["TextColor3"] = Color3.fromRGB(200, 200, 200),
						["Font"] = Enum.Font.Gotham,
						["TextSize"] = 10,
						["ZIndex"] = 11,
						["Parent"] = ScrollingFrame2
					}).MouseButton1Click

                MouseButton1Click:Connect(function()
                    u194 = v

                    local v199 = u194

                    TextButton5.Text = tostring(v199) .. "  \226\150\188"

                    if not p50 then
                        v199 = ScrollingFrame2
                        u189 = false
                        v199.Visible = false
                        v188.Parent.Size = UDim2.new(1, -8, 0, 38)

                        return
                    end

                    p50(u194)
                    v199 = ScrollingFrame2
                    u189 = false
                    v199.Visible = false
                    v188.Parent.Size = UDim2.new(1, -8, 0, 38)
                end)
                n5 = n5 + 22
            end
            ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, n5)
            TextButton5.MouseButton1Click:Connect(function()
                u189 = not u189

                if u189 then
                    local v200 = #p48 * 22

                    v200 = math.min(v200, 110)

                    local v201 = ScrollingFrame2

                    v201 = ScrollingFrame2

                    local uDim2 = UDim2.new(0.42, 0, 0, v200)

                    v201.Visible = true
                    v201.Size = uDim2
                    v188.Parent.Size = UDim2.new(1, -8, 0, 40 + v200)

                    return
                else
                    ScrollingFrame2.Visible = false
                    v188.Parent.Size = UDim2.new(1, -8, 0, 38)

                    return
                end
            end)
        end

        return TextButton4
    end

    return v105
end
}):CreateWindow("MONO<b>HUB</b>")
t1 = t2.value54:CreateTab("Gun")
unpack_ = t2.value54:CreateTab("Knife")
value12 = t2.value54:CreateTab("Player")
Workspace = t2.value54:CreateTab("Misc")
result = t2.value54:CreateTab("Visuals")
color3 = t2.value54:CreateTab("Binds")
color3:CreateKeybind("ESP", t2.value20.Binds.ESP, function(p51, p52)
    if p52 then
        t2.value20.ESPEnabled = not t2.value20.ESPEnabled

        return
    else
        t2.value20.Binds.ESP = p51
        t2.value33()

        return
    end
end)
color3:CreateKeybind("Kill All", t2.value20.Binds.KillAll, function(p53, p54)
    if p54 then
        t2.value20.KillAllEnabled = not t2.value20.KillAllEnabled

        return
    else
        t2.value20.Binds.KillAll = p53
        t2.value33()

        return
    end
end)
color3:CreateKeybind("Speed", t2.value20.Binds.Speed, function(p55, p56)
    if p56 then
        t2.value20.MovementEnabled = not t2.value20.MovementEnabled

        return
    else
        t2.value20.Binds.Speed = p55
        t2.value33()

        return
    end
end)
color3:CreateKeybind("Invisibility", t2.value20.Binds.Invisible, function(p57, p58)
    if p58 then
        t2.value51(not t2.value20.InvisibilityActive)

        return
    else
        t2.value20.Binds.Invisible = p57
        t2.value33()

        return
    end
end)
color3:CreateKeybind("Open/Close Hub", t2.value20.Binds.CloseHub, function(p59, p60)
    if p60 then
        t2.value54.ToggleHub(not t2.value18.MonochromeHubV2.MainFrame.Visible, true)

        return
    else
        t2.value20.Binds.CloseHub = p59
        t2.value33()

        return
    end
end)
t1:CreateToggle("Custom Gun", t2.value20.GunCustomEnabled, function(p61)
    t2.value20.GunCustomEnabled = p61
    t2.value33()
end)
t1:CreateSlider("Gun Cooldown", 0, 1, t2.value20.GunCooldown, function(p62)
    t2.value20.GunCooldown = p62
    t2.value33()
end)
t1:CreateToggle("Gun Aura", t2.value20.GunAuraEnabled, function(p63)
    t2.value20.GunAuraEnabled = p63
    t2.value33()
end)
unpack_:CreateToggle("Custom Knife", t2.value20.KnifeCustomEnabled, function(p64)
    t2.value20.KnifeCustomEnabled = p64
    t2.value33()
end)
unpack_:CreateSlider("Throw Speed", 500, 9999, t2.value20.KnifeThrowSpeed, function(p65)
    t2.value20.KnifeThrowSpeed = p65
    t2.value33()
end)
unpack_:CreateToggle("Knife Aura", t2.value20.KnifeAuraEnabled, function(p66)
    t2.value20.KnifeAuraEnabled = p66
    t2.value33()
end)
unpack_:CreateSlider("Knife Aura Range", 5, 100, t2.value20.KnifeAuraRange, function(p67)
    t2.value20.KnifeAuraRange = p67
    t2.value33()
end)
Workspace:CreateToggle("Kill All", t2.value20.KillAllEnabled, function(p68)
    t2.value20.KillAllEnabled = p68
    t2.value33()
end)
Workspace:CreateDropdown("Kill All Method", { "Default", "Lag" }, t2.value20.KillAllMethod, function(p69)
    t2.value20.KillAllMethod = p69
    t2.value33()
end)
Workspace:CreateSlider("Kill All Delay", 0.06, 0.3, t2.value20.KillAllDelay, function(p70)
    t2.value20.KillAllDelay = p70
    t2.value33()
end)
Workspace:CreateToggle("Server Lag", t2.value20.LagEnabled, function(p71)
    t2.value20.LagEnabled = p71
    t2.value33()
end)
Workspace:CreateToggle("Anti Lag", t2.value20.AntiLagEnabled, function(p72)
    t2.value20.AntiLagEnabled = p72
    t2.value33()
end)
Workspace:CreateDropdown("Select Remote", {
	"ThrowHit",
	"ThrowStart",
	"ShootGun",
	"Stab"
}, t2.value20.LagRemote, function(p73)
    t2.value20.LagRemote = p73
    t2.value33()
end)
Workspace:CreateSlider("Cooldown Send", 0.01, 0.5, t2.value20.LagDelay, function(p74)
    t2.value20.LagDelay = p74
    t2.value33()
end)
Workspace:CreateSlider("How Much Send", 1, 9999, t2.value20.LagBatch, function(p75)
    t2.value20.LagBatch = p75
    t2.value33()
end)
value12:CreateToggle("Movement", t2.value20.MovementEnabled, function(p76)
    t2.value20.MovementEnabled = p76
    t2.value33()
end)
value12:CreateSlider("Walk Speed", 0, 200, t2.value20.MovementSpeed, function(p77)
    t2.value20.MovementSpeed = p77
    t2.value33()
end)
value12:CreateToggle("Bhop", t2.value20.BhopEnabled, function(p78)
    t2.value20.BhopEnabled = p78

    if p78 then
        t2.value33()

        return
    end

    t2.value20.BhopBonus = 0
    t2.value33()
end)
value12:CreateDropdown("Movement Mode", { "Normal", "CFrame", "SafeWalk" }, t2.value20.MovementMode, function(p79)
    t2.value20.MovementMode = p79
    t2.value33()
end)
value12:CreateToggle("Noclip", t2.value20.NoclipEnabled, function(p80)
    t2.value20.NoclipEnabled = p80
    t2.value33()
end)
value12:CreateToggle("Infinite Jump", t2.value20.InfJumpEnabled, function(p81)
    t2.value20.InfJumpEnabled = p81
    t2.value33()
end)
value12:CreateToggle("Jump", t2.value20.JumpPowerEnabled, function(p82)
    t2.value20.JumpPowerEnabled = p82
    t2.value33()
end)
value12:CreateSlider("Jump Power", 50, 1000, t2.value20.JumpPowerValue, function(p83)
    t2.value20.JumpPowerValue = p83
    t2.value33()
end)
value12:CreateSlider("Gravity", 0, 500, t2.value20.GravityValue, function(p84)
    t2.value20.GravityValue = p84
    t2.value33()
end)
value12:CreateToggle("Invisibility", t2.value20.InvisibilityEnabled, function(p85)
    t2.value20.InvisibilityEnabled = p85

    local MonochromeHubV2 = t2.value18:FindFirstChild("MonochromeHubV2")

    if MonochromeHubV2 then
        MonochromeHubV2 = t2.value18.MonochromeHubV2:FindFirstChild("FloatingInvisWindow")
    end

    if not MonochromeHubV2 then
        MonochromeHubV2 = t2.value12:FindFirstChild("MonochromeHubV2")

        if MonochromeHubV2 then
            MonochromeHubV2 = t2.value12.MonochromeHubV2:FindFirstChild("FloatingInvisWindow")
        end
    end

    if MonochromeHubV2 then
        MonochromeHubV2.Visible = p85
    end

    if p85 then
        t2.value33()

        return
    end

    t2.value51(false)
    t2.value33()
end)
value12:CreateToggle("Spinner", t2.value20.SpinnerEnabled, function(p86)
    t2.value20.SpinnerEnabled = p86
    t2.value33()
end)
value12:CreateSlider("Spinner Speed", 1, 200, t2.value20.SpinnerSpeed, function(p87)
    t2.value20.SpinnerSpeed = p87
    t2.value33()
end)
result:CreateToggle("Freeze Players (Only u see)", t2.value20.FreezePlayersEnabled, function(p88)
    t2.value20.FreezePlayersEnabled = p88
    t2.value33()
end)
result:CreateToggle("Give Shahed", t2.value20.ShahedEnabled, function(p89)
    t2.value20.ShahedEnabled = p89

    if p89 then
        t2.value46()
    else
        t2.value43()

        local Backpack = t2.value10:FindFirstChild("Backpack")
        local Shahed

        if Backpack then
            Shahed = Backpack:FindFirstChild("Shahed")
        else
            Shahed = Backpack
        end

        if not Shahed then
            t2.value33()

            return
        end

        Backpack.Shahed:Destroy()
    end

    t2.value33()
end)
result:CreateSlider("Shahed Speed", 10, 100, t2.value20.ShahedSpeed, function(p90)
    t2.value20.ShahedSpeed = p90
    t2.value33()
end)
result:CreateSlider("Shahed Flight Time", 5, 60, t2.value20.ShahedMaxTime, function(p91)
    t2.value20.ShahedMaxTime = p91
    t2.value33()
end)
result:CreateSlider("Shahed Explosion Radius", 5, 50, t2.value20.ShahedRadius, function(p92)
    t2.value20.ShahedRadius = p92
    t2.value33()
end)
result:CreateToggle("Expand Hitbox", t2.value20.HitboxEnabled, function(p93)
    t2.value20.HitboxEnabled = p93
    t2.value33()
end)
result:CreateSlider("Hitbox Size", 0, 50, t2.value20.HitboxSize, function(p94)
    t2.value20.HitboxSize = p94
    t2.value33()
end)
result:CreateToggle("ESP", t2.value20.ESPEnabled, function(p95)
    t2.value20.ESPEnabled = p95
    t2.value33()
end)
result:CreateToggle("ESP Team Check", t2.value20.ESPTeamCheck, function(p96)
    t2.value20.ESPTeamCheck = p96
    t2.value33()
end)
result:CreateDropdown("ESP Color", {
	"Black",
	"White",
	"Red",
	"Blue",
	"Yellow",
	"Pink",
	"Orange",
	"Green",
	"Purple",
	"Cyan",
	"Gray",
	"Brown"
}, t2.value20.ESPColorName, function(p97)
    t2.value20.ESPColorName = p97
    t2.value20.ESPColor = t2.value22[p97] or Color3.fromRGB(255, 50, 50)
    t2.value33()
end)
result:CreateToggle("FOV", t2.value20.FOVEnabled, function(p98)
    t2.value20.FOVEnabled = p98
    t2.value33()
end)
result:CreateSlider("FOV Value", 1, 120, t2.value20.FOVValue, function(p99)
    t2.value20.FOVValue = p99
    t2.value33()
end)
result:CreateToggle("Stretch", t2.value20.StretchEnabled, function(p100)
    t2.value20.StretchEnabled = p100
    t2.value33()
end)
result:CreateSlider("Stretch Value", 0.2, 1.2, t2.value20.StretchValue, function(p101)
    t2.value20.StretchValue = p101
    t2.value33()
end)
t1 = t2.value5.RenderStepped
t1:Connect(function(p102)
    local InvisibilityActive = t2.value20.InvisibilityActive

    if InvisibilityActive then
        InvisibilityActive = t2.value28
    end

    InvisibilityActive = InvisibilityActive or t2.value10.Character

    if InvisibilityActive then
        local Humanoid = InvisibilityActive:FindFirstChildOfClass("Humanoid")

        InvisibilityActive = InvisibilityActive:FindFirstChild("HumanoidRootPart")

        if Humanoid and InvisibilityActive then
            local BhopEnabled = t2.value20.BhopEnabled

            if BhopEnabled then
                if Humanoid.FloorMaterial == Enum.Material.Air then
                    BhopEnabled = false
                else
                    BhopEnabled = tick() - t2.value52 > 0.3
                end
            end

            if BhopEnabled then
                t2.value20.BhopBonus = 0
            end

            BhopEnabled = t2.value20.MovementSpeed

            local BhopEnabled2 = t2.value20.BhopEnabled

            if BhopEnabled2 then
                BhopEnabled2 = t2.value20.BhopBonus
            end

            BhopEnabled = BhopEnabled + (BhopEnabled2 or 0)

            if t2.value20.MovementEnabled then
                if t2.value20.MovementMode == "Normal" or t2.value20.MovementMode == "SafeWalk" then
                    Humanoid.WalkSpeed = BhopEnabled
                else
                    BhopEnabled2 = t2.value20.MovementMode == "CFrame"

                    if BhopEnabled2 then
                        BhopEnabled2 = Humanoid.MoveDirection.Magnitude > 0
                    end

                    if BhopEnabled2 then
                        InvisibilityActive.CFrame = InvisibilityActive.CFrame + Humanoid.MoveDirection * (BhopEnabled * p102)
                    end
                end
            end

            if t2.value20.JumpPowerEnabled then
                InvisibilityActive = t2.value20.JumpPowerValue
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = InvisibilityActive
            end
        end
    end

    t2.value6.Gravity = t2.value20.GravityValue

    if t2.value20.FOVEnabled then
        t2.value11.FieldOfView = t2.value20.FOVValue
    end

    InvisibilityActive = t2.value20.StretchEnabled

    if InvisibilityActive then
        InvisibilityActive = t2.value20.StretchValue
    end

    if not InvisibilityActive then
        return
    end

    t2.value11.CFrame = t2.value11.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, t2.value20.StretchValue, 0, 0, 0, 1)
end)
task.spawn(function()
    while task.wait(0.2) do
        local Character = t2.value10.Character

        if Character then
            local GetChildren = Character.GetChildren

            for _, v in ipairs(GetChildren(Character)) do
                if v:IsA("Tool") then
                    local KnifeCustomEnabled = t2.value20.KnifeCustomEnabled

                    if KnifeCustomEnabled then
                        KnifeCustomEnabled = v:GetAttribute("ThrowSpeed")
                    end

                    if KnifeCustomEnabled then
                        KnifeCustomEnabled = t2.value20
                        v:SetAttribute("ThrowSpeed", KnifeCustomEnabled.KnifeThrowSpeed)
                    end

                    KnifeCustomEnabled = t2.value20.GunCustomEnabled

                    if KnifeCustomEnabled then
                        KnifeCustomEnabled = v:GetAttribute("Cooldown")
                    end

                    if KnifeCustomEnabled then
                        v:SetAttribute("Cooldown", t2.value20.GunCooldown)
                    end
                end
            end
        end
    end
end)
t2.value55 = {
	["R15"] = {
		{ "Head", "UpperTorso" },
		{ "UpperTorso", "LowerTorso" },
		{ "UpperTorso", "LeftUpperArm" },
		{ "LeftUpperArm", "LeftLowerArm" },
		{ "LeftLowerArm", "LeftHand" },
		{ "UpperTorso", "RightUpperArm" },
		{ "RightUpperArm", "RightLowerArm" },
		{ "RightLowerArm", "RightHand" },
		{ "LowerTorso", "LeftUpperLeg" },
		{ "LeftUpperLeg", "LeftLowerLeg" },
		{ "LeftLowerLeg", "LeftFoot" },
		{ "LowerTorso", "RightUpperLeg" },
		{ "RightUpperLeg", "RightLowerLeg" },
		{ "RightLowerLeg", "RightFoot" }
	},
	["R6"] = {
		{ "Head", "Torso" },
		{ "Torso", "Left Arm" },
		{ "Torso", "Right Arm" },
		{ "Torso", "Left Leg" },
		{ "Torso", "Right Leg" }
	}
}
t2.value56 = nil
t2.value56 = {}
function t2.value57(p103)
    if not t2.value56[p103] then
        return
    end

    for _, v in pairs(t2.value56[p103]) do
        v.Visible = false

        if v.Remove then
            v:Remove()
        end
    end

    t2.value56[p103] = nil
end
t2.value2.PlayerRemoving:Connect(t2.value57)
t2.value5.RenderStepped:Connect(function()
    local v217, v218, v219, _, v221, v223, Line

    if not t2.value20.SpinnerEnabled then
        v342, v348, v355 = ipairs(t2.value2:GetPlayers())

        while true do
            v355, v350 = v342(v348, v355)

            if not v355 then
                break
            end

            v350, v217, v218, v218 = t2.value27(v350)

            if v350 then
                v217.Anchored = t2.value20.FreezePlayersEnabled

                if t2.value20.HitboxEnabled then
                    v350 = Vector3.new(t2.value20.HitboxSize, t2.value20.HitboxSize, t2.value20.HitboxSize)

                    if v217.Size ~= v350 then
                        v217.Size = v350
                    end

                    if v217.Transparency ~= 0.7 then
                        v217.Transparency = 0.7
                    end

                    if v217.CanCollide ~= false then
                        v217.CanCollide = false
                    end
                else
                    if v217.Size ~= Vector3.new(2, 2, 1) then
                        v217.Size = Vector3.new(2, 2, 1)
                    end

                    if v217.Transparency ~= 1 then
                        v217.Transparency = 1
                    end
                end
            end
        end

        if t2.value20.ESPEnabled then
            v342 = ipairs
            v348 = t2.value2

            for _, player in v342(v348:GetPlayers()) do
                v350, v217, v217, v217 = t2.value27(player)

                if v350 then
                    if not t2.value56[player] then
                        t2.value56[player] = {}
                    end

                    v350 = v217:FindFirstChild("UpperTorso") ~= nil

                    if v350 then
                        v350 = t2.value55.R15
                    end

                    v350 = v350 or t2.value55.R6

                    for i, v in ipairs(v350) do
                        v219 = v217:FindFirstChild(v[1])
                        v = v217:FindFirstChild(v[2])

                        if v219 and v then
                            v219, v221 = t2.value11:WorldToViewportPoint(v219.Position)
                            v, v223 = t2.value11:WorldToViewportPoint(v.Position)
                            Line = t2.value56[player][i]

                            if not Line then
                                Line = Drawing.new("Line")
                                Line.Thickness = 1.5
                                Line.Transparency = 1
                                t2.value56[player][i] = Line
                            end

                            if v221 and v223 then
                                Line.From = Vector2.new(v219.X, v219.Y)
                                Line.To = Vector2.new(v.X, v.Y)
                                Line.Color = t2.value20.ESPColor or Color3.fromRGB(255, 50, 50)
                                Line.Visible = true
                            else
                                Line.Visible = false
                            end
                        else
                            v = t2.value56[player]

                            if v then
                                v = t2.value56[player][i]
                            end

                            if v then
                                t2.value56[player][i].Visible = false
                            end
                        end
                    end
                else
                    t2.value57(player)
                end
            end

            return
        else
            for k in pairs(t2.value56) do
                t2.value57(k)
            end

            return
        end

        return
    end

    local InvisibilityActive = t2.value20.InvisibilityActive

    if InvisibilityActive then
        InvisibilityActive = t2.value28
    end

    InvisibilityActive = InvisibilityActive or t2.value10.Character

    if InvisibilityActive then
        InvisibilityActive = InvisibilityActive:FindFirstChild("HumanoidRootPart")
    end

    if not InvisibilityActive then
        InvisibilityActive, v348, v355 = ipairs(t2.value2:GetPlayers())

        while true do
            v355, v350 = InvisibilityActive(v348, v355)

            if not v355 then
                break
            end

            v350, v217, v218, v218 = t2.value27(v350)

            if v350 then
                v217.Anchored = t2.value20.FreezePlayersEnabled

                if t2.value20.HitboxEnabled then
                    v350 = Vector3.new(t2.value20.HitboxSize, t2.value20.HitboxSize, t2.value20.HitboxSize)

                    if v217.Size ~= v350 then
                        v217.Size = v350
                    end

                    if v217.Transparency ~= 0.7 then
                        v217.Transparency = 0.7
                    end

                    if v217.CanCollide ~= false then
                        v217.CanCollide = false
                    end
                else
                    if v217.Size ~= Vector3.new(2, 2, 1) then
                        v217.Size = Vector3.new(2, 2, 1)
                    end

                    if v217.Transparency ~= 1 then
                        v217.Transparency = 1
                    end
                end
            end
        end

        if t2.value20.ESPEnabled then
            InvisibilityActive = ipairs
            v348 = t2.value2

            for _, player in InvisibilityActive(v348:GetPlayers()) do
                v350, v217, v217, v217 = t2.value27(player)

                if v350 then
                    if not t2.value56[player] then
                        t2.value56[player] = {}
                    end

                    v350 = v217:FindFirstChild("UpperTorso") ~= nil

                    if v350 then
                        v350 = t2.value55.R15
                    end

                    v350 = v350 or t2.value55.R6

                    for i, v in ipairs(v350) do
                        v219 = v217:FindFirstChild(v[1])
                        v = v217:FindFirstChild(v[2])

                        if v219 and v then
                            v219, v221 = t2.value11:WorldToViewportPoint(v219.Position)
                            v, v223 = t2.value11:WorldToViewportPoint(v.Position)
                            Line = t2.value56[player][i]

                            if not Line then
                                Line = Drawing.new("Line")
                                Line.Thickness = 1.5
                                Line.Transparency = 1
                                t2.value56[player][i] = Line
                            end

                            if v221 and v223 then
                                Line.From = Vector2.new(v219.X, v219.Y)
                                Line.To = Vector2.new(v.X, v.Y)
                                Line.Color = t2.value20.ESPColor or Color3.fromRGB(255, 50, 50)
                                Line.Visible = true
                            else
                                Line.Visible = false
                            end
                        else
                            v = t2.value56[player]

                            if v then
                                v = t2.value56[player][i]
                            end

                            if v then
                                t2.value56[player][i].Visible = false
                            end
                        end
                    end
                else
                    t2.value57(player)
                end
            end

            return
        else
            for k in pairs(t2.value56) do
                t2.value57(k)
            end

            return
        end

        return
    end

    local CFrame_ = InvisibilityActive.CFrame
    local cFrame = CFrame.Angles
    local SpinnerSpeed = t2.value20.SpinnerSpeed

    InvisibilityActive.CFrame = CFrame_ * cFrame(0, math.rad(SpinnerSpeed), 0)
    InvisibilityActive, CFrame_, cFrame = ipairs(t2.value2:GetPlayers())

    while true do
        cFrame, SpinnerSpeed = InvisibilityActive(CFrame_, cFrame)

        if not cFrame then
            break
        end

        SpinnerSpeed, v217, v218, v218 = t2.value27(SpinnerSpeed)

        if SpinnerSpeed then
            v217.Anchored = t2.value20.FreezePlayersEnabled

            if t2.value20.HitboxEnabled then
                SpinnerSpeed = Vector3.new(t2.value20.HitboxSize, t2.value20.HitboxSize, t2.value20.HitboxSize)

                if v217.Size ~= SpinnerSpeed then
                    v217.Size = SpinnerSpeed
                end

                if v217.Transparency ~= 0.7 then
                    v217.Transparency = 0.7
                end

                if v217.CanCollide ~= false then
                    v217.CanCollide = false
                end
            else
                if v217.Size ~= Vector3.new(2, 2, 1) then
                    v217.Size = Vector3.new(2, 2, 1)
                end

                if v217.Transparency ~= 1 then
                    v217.Transparency = 1
                end
            end
        end
    end

    if t2.value20.ESPEnabled then
        InvisibilityActive = ipairs
        CFrame_ = t2.value2

        for _, player in InvisibilityActive(CFrame_:GetPlayers()) do
            SpinnerSpeed, v217, v217, v217 = t2.value27(player)

            if SpinnerSpeed then
                if not t2.value56[player] then
                    t2.value56[player] = {}
                end

                SpinnerSpeed = v217:FindFirstChild("UpperTorso") ~= nil

                if SpinnerSpeed then
                    SpinnerSpeed = t2.value55.R15
                end

                SpinnerSpeed = SpinnerSpeed or t2.value55.R6

                for i, v in ipairs(SpinnerSpeed) do
                    v219 = v217:FindFirstChild(v[1])
                    v = v217:FindFirstChild(v[2])

                    if v219 and v then
                        v219, v221 = t2.value11:WorldToViewportPoint(v219.Position)
                        v, v223 = t2.value11:WorldToViewportPoint(v.Position)
                        Line = t2.value56[player][i]

                        if not Line then
                            Line = Drawing.new("Line")
                            Line.Thickness = 1.5
                            Line.Transparency = 1
                            t2.value56[player][i] = Line
                        end

                        if v221 and v223 then
                            Line.From = Vector2.new(v219.X, v219.Y)
                            Line.To = Vector2.new(v.X, v.Y)
                            Line.Color = t2.value20.ESPColor or Color3.fromRGB(255, 50, 50)
                            Line.Visible = true
                        else
                            Line.Visible = false
                        end
                    else
                        v = t2.value56[player]

                        if v then
                            v = t2.value56[player][i]
                        end

                        if v then
                            t2.value56[player][i].Visible = false
                        end
                    end
                end
            else
                t2.value57(player)
            end
        end

        return
    else
        for k in pairs(t2.value56) do
            t2.value57(k)
        end

        return
    end
end)
t2.value58 = nil
t2.value58 = {}
function t2.value59()
    for _, v in ipairs(t2.value58) do
        local Parent

        if v then
            Parent = v.Parent
        else
            Parent = v
        end

        if Parent then
            v:Destroy()
        end
    end

    t2.value58 = {}
end
t1 = function(p104, p105)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.fromRGB(255, 255, 255)
    Part.Size = Vector3.new(0.12, 0.12, (p104 - p105).Magnitude)
    Part.CFrame = CFrame.new(p104:Lerp(p105, 0.5), p105)
    Part.Parent = t2.value6

    local value58 = t2.value58

    table.insert(value58, Part)
end
unpack_ = t2.value10.CharacterAdded
unpack_:Connect(function()
    t2.value59()
end)

function t2.value60(p106)
    local InvisibilityActive = t2.value20.InvisibilityActive
    local HumanoidRootPart, raycastParams, v251, v252
    if not InvisibilityActive then
        InvisibilityActive = InvisibilityActive or t2.value10.Character
        v371 = p106.Character

        if InvisibilityActive and v371 then
            HumanoidRootPart = InvisibilityActive:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                HumanoidRootPart = HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
                raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = { InvisibilityActive, t2.value11 }
                InvisibilityActive = { v371:FindFirstChild("UpperTorso") or v371:FindFirstChild("Torso"), v371:FindFirstChild("HumanoidRootPart"), v371:FindFirstChild("Head") }

                for _, v in ipairs(InvisibilityActive) do
                    if v then
                        v251 = v.Position - HumanoidRootPart
                        v251 = t2.value6:Raycast(HumanoidRootPart, v251, raycastParams)

                        if v251 then
                            v252 = v251.Instance:IsDescendantOf(v371)
                        else
                            v252 = v251
                        end

                        if v252 then
                            return v, v251.Position, v251.Instance
                        end
                    end
                end

                return nil, nil, nil
            else
                return nil, nil, nil
            end

            return
        else
            return nil, nil, nil
        end

        return
    end
    InvisibilityActive = t2.value28 or t2.value10.Character
    local Character = p106.Character
    if InvisibilityActive and Character then
        HumanoidRootPart = InvisibilityActive:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart = HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
            raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = { InvisibilityActive, t2.value11 }
            InvisibilityActive = { Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso"), Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChild("Head") }

            for _, v in ipairs(InvisibilityActive) do
                if v then
                    v251 = v.Position - HumanoidRootPart
                    v251 = t2.value6:Raycast(HumanoidRootPart, v251, raycastParams)

                    if v251 then
                        v252 = v251.Instance:IsDescendantOf(Character)
                    else
                        v252 = v251
                    end

                    if v252 then
                        return v, v251.Position, v251.Instance
                    end
                end
            end

            return nil, nil, nil
        else
            return nil, nil, nil
        end

        return
    else
        return nil, nil, nil
    end
end
t2.value61 = 0
t2.value62 = 0.15
task.spawn(function()
    while true do
        if true then
        end

        task.wait(0.03)

        local GunAuraEnabled = t2.value20.GunAuraEnabled

        if GunAuraEnabled then
            GunAuraEnabled = not t2.value20.KillAllEnabled
        end

        if GunAuraEnabled then
            GunAuraEnabled = t2.value20.InvisibilityActive

            if GunAuraEnabled then
                GunAuraEnabled = t2.value28
            end

            GunAuraEnabled = GunAuraEnabled or t2.value10.Character

            if GunAuraEnabled then
                GunAuraEnabled = GunAuraEnabled:FindFirstChild("HumanoidRootPart")
            end

            local v259

            if GunAuraEnabled then
                v259 = tick() - t2.value61 >= t2.value62
            else
                v259 = GunAuraEnabled
            end

            if v259 then
                t2.value31()

                for _, player in ipairs(t2.value2:GetPlayers()) do
                    local v262, _, v264 = t2.value27(player)

                    if v262 then
                        v262 = v264.Health > 0
                    end

                    if v262 then
                        local v265

                        v265, v262, v264 = t2.value60(v265)

                        if v265 and v262 then
                            tick()
                            v259 = GunAuraEnabled.Position + Vector3.new(0, 1.5, 0)
                            t2.value19(139527135965700, GunAuraEnabled, 1, false)
                            t1(v259, v262)

                            if t2.value14 then
                                t2.value14:FireServer(v259, v262, v264, v262)
                            end

                            return
                        end
                    end
                end
            end
        end
    end
end)
t2.value63 = 0
t2.value64 = false
t2.value65 = nil
function t2.value66()
    local ipairs_ = ipairs
    local value2 = t2.value2
    local t8 = {}

    for _, player in ipairs_(value2:GetPlayers()) do
        local v271, v272 = t2.value27(player)

        if v271 then
            table.insert(t8, {
				["player"] = player,
				["root"] = v272
			})
        end
    end

    return t8
end
task.spawn(function()
    while true do
        local InvisibilityActive = t2.value20.InvisibilityActive

        if InvisibilityActive then
            InvisibilityActive = t2.value28
        end

        InvisibilityActive = InvisibilityActive or t2.value10.Character

        if InvisibilityActive and InvisibilityActive:FindFirstChild("HumanoidRootPart") then
            InvisibilityActive = InvisibilityActive.HumanoidRootPart

            local v274

            if t2.value20.KillAllEnabled then
                v403 = t2.value66()
                v274 = t2.value31()

                if v274 then
                    v274 = #v403 > 0
                end

                if v274 then
                    if t2.value20.KillAllMethod == "Lag" then
                        if not t2.value65 then
                            t2.value65 = tick()
                        end

                        if tick() - t2.value65 <= 1 then
                            if t2.value17 then
                                for _, v in ipairs(v403) do
                                    for i = 1, 67 do
                                        t2.value17:FireServer(InvisibilityActive.Position, (v.root.Position - InvisibilityActive.Position).Unit)
                                    end
                                end
                            end

                            task.wait(0.01)
                        else
                            if t2.value16 then
                                v403 = math.min(#v403, math.random(1, 4))
                                v274 = { table.unpack(v403) }

                                local t9 = {}

                                for i = 1, v403 do
                                    local v281 = math.random(1, #v274)
                                    local v282 = v274[v281]

                                    table.insert(t9, v282)
                                    table.remove(v274, v281)
                                end

                                for _, v in ipairs(t9) do
                                    v = v.root
                                    t2.value16:FireServer(v, v.Position)
                                end
                            end

                            task.wait(0.5)
                        end
                    else
                        t2.value65 = nil

                        if not t2.value64 then
                            t2.value63 = tick()
                            t2.value64 = true
                        end

                        if tick() - t2.value63 >= 0.3 then
                            for _, v in ipairs(v403) do
                                v = v.root

                                if t2.value20.KillAllEnabled then
                                    if t2.value16 then
                                        t2.value16:FireServer(v, v.Position)
                                    end

                                    if t2.value15 then
                                        t2.value15:FireServer(v)
                                    end

                                    if t2.value14 then
                                        t2.value14:FireServer(InvisibilityActive.Position, v.Position, v, v.Position)
                                    end
                                end
                            end
                        end

                        v403 = task.wait
                        v274 = t2.value20.KillAllDelay or 0.1
                        v403((math.clamp(v274, 0.06, 0.3)))
                    end
                else
                    t2.value64 = false
                    t2.value65 = nil
                    task.wait(0.1)
                end
            else
                t2.value64 = false
                t2.value65 = nil
                v403 = task.wait
                v274 = t2.value20.KillAllDelay or 0.1
                v403((math.clamp(v274, 0.06, 0.3)))
            end

            local KnifeAuraEnabled = t2.value20.KnifeAuraEnabled

            if KnifeAuraEnabled then
                KnifeAuraEnabled = not t2.value20.KillAllEnabled
            end

            if KnifeAuraEnabled then
                KnifeAuraEnabled = ipairs
                v274 = t2.value2

                for _, player in KnifeAuraEnabled(v274:GetPlayers()) do
                    local v290

                    player, v290 = t2.value27(player)

                    if player then
                        player = (v290.Position - InvisibilityActive.Position).Magnitude <= t2.value20.KnifeAuraRange
                    end

                    if player then
                        if t2.value16 then
                            t2.value16:FireServer(v290, v290.Position)
                        elseif t2.value15 then
                            t2.value15:FireServer(v290)
                        end
                    end
                end
            end
        else
            t2.value64 = false
            t2.value65 = nil
            task.wait(0.1)
        end
    end
end)
