-- leak by stev

local t1 = {}
local v2 = unpack or table.unpack
t1.value1 = game:GetService("Players")
t1.value2 = game:GetService("RunService")
t1.value3 = game:GetService("ReplicatedStorage")
t1.value4 = game:GetService("UserInputService")
t1.value5 = game:GetService("Workspace")
t1.value6 = game:GetService("CoreGui")

local ContextActionService = game:GetService("ContextActionService")

t1.value7 = game:GetService("Debris")
game:GetService("TweenService")
game:GetService("ProximityPromptService")
t1.value8 = game:GetService("Lighting")
t1.value9 = game:GetService("HttpService")
t1.value10 = t1.value1.LocalPlayer
t1.value11 = t1.value5.CurrentCamera
function t1.value12(p1)
    local ok, result = pcall(require, p1)

    if ok then
        return result
    end

    return nil
end
local value12 = t1.value12
local Modules = t1.value3:FindFirstChild("Modules")

if Modules then
    Modules = t1.value3.Modules.Core and t1.value3.Modules.Core.Util
end
if not value12(Modules) then
end
local value12_2 = t1.value12
local Modules2 = t1.value3:FindFirstChild("Modules")

if Modules2 then
    Modules2 = t1.value3.Modules.Game.UI and t1.value3.Modules.Game.UI.BuyPromptUI
end
if not value12_2(Modules2) then
end
local v8 = t1.value12(t1.value3:FindFirstChild("Modules") and (t1.value3.Modules.Game.Emotes and t1.value3.Modules.Game.Emotes.EmotesUI))

if not v8 then
    local t2 = {
		get = function()
    end,
		set = function()
    end,
		hook = function()
    end
	}
    local t3 = {
		set = function()
    end
	}

    v8 = {
		current_emote_playing = t2,
		enabled = t3
	}
end
t1.value13 = v8
local v11 = t1.value12(t1.value3:FindFirstChild("Modules") and (t1.value3.Modules.Game.Emotes and t1.value3.Modules.Game.Emotes.EmotesList))

if not v11 then
    v11 = {}
end
t1.value14 = v11
local v12 = t1.value12(t1.value3:FindFirstChild("Modules") and t1.value3.Modules.Core.UI)

if not v12 then
    v12 = {
		get = function()
        return nil
    end,
		on_click = function()
    end
	}
end
t1.value15 = v12
local v13 = t1.value12(t1.value3:FindFirstChild("Modules") and t1.value3.Modules.Core.Char)

if not v13 then
    local t4 = {
		get = function()
        return nil
    end
	}

    v13 = {
		get_hum = function()
        return nil
    end,
		current_char = t4
	}
end
t1.value16 = v13
local Remotes = t1.value3:WaitForChild("Remotes")

t1.value17 = Remotes:FindFirstChild("Send")
t1.value18 = Remotes:FindFirstChild("Get")
t1.value19 = t1.value3:FindFirstChild("Items")
t1.value20 = t1.value19 and t1.value19:FindFirstChild("melee")
t1.value21 = t1.value19 and t1.value19:FindFirstChild("gun")
t1.value22 = gethui or function()
    return t1.value6
end
t1.value23 = t1.value22():FindFirstChild("F3Hub_ESP_Container")

if not t1.value23 then
    t1.value23 = Instance.new("Folder")
    t1.value23.Name = "F3Hub_ESP_Container"
    t1.value23.Parent = t1.value22()
end
t1.value24 = {}
t1.value25 = false
t1.value26 = false
t1.value27 = false
t1.value28 = "Random"
t1.value29 = false
local _getgenv = getgenv
if not _getgenv then
    function _getgenv()
        return _G
    end
end
t1.value30 = _getgenv
function t1.value31()
    return t1.value30()
end
t1.value32 = "F3Hub/" .. game.PlaceId .. "/"
t1.value33 = t1.value32 .. "settings.json"
t1.value34 = t1.value32 .. "ui_state.json"
pcall(function()
    if not isfolder("F3Hub") then
        makefolder("F3Hub")
    end

    if not isfolder(t1.value32) then
        makefolder(t1.value32)
    end
end)

function t1.value35()
    local t5 = {}
    local _pairs = pairs

    for v140, v141 in _pairs(t1.value31()) do
        local v142 = v140
        local v143 = type(v141) ~= "function"

        if v143 then
            v143 = type(v141) ~= "table"

            if v143 then
                v143 = v142 ~= "PIGHUB_LOADED" and (v142 ~= "ACBYPASS" and v142 ~= "AimTarget")
            end
        end

        if v143 then
            _pairs = t5
            _pairs[v142] = v141
        end
    end

    pcall(function()
        writefile(t1.value33, t1.value9:JSONEncode(t5))
    end)
end
function t1.value36()
    if not isfile(t1.value33) then
        return false
    end

    local ok, result = pcall(function()
        local value9 = t1.value9
        local t6 = { readfile(t1.value33) }

        return value9:JSONDecode(v2(t6))
    end)
    local v146 = not ok

    if not v146 then
        v146 = type(result) ~= "table"
    end

    if v146 then
        return false
    end

    for k, v in pairs(result) do
        t1.value31()[k] = v
    end

    return true
end
function t1.value37()
    local v89 = t1.value31().AimAssist or false
    local v90 = t1.value31().EnemyGlow or false
    local v91 = t1.value31().NameESP or false
    local v92 = t1.value31().DistESP or false
    local v93 = t1.value31().BarESP or false
    local v94 = t1.value31().InvESP or false
    local v95 = t1.value31().ItemESP or false
    local v96 = t1.value31().SpeedCustom or false
    local v97 = t1.value31().JumpCustom or false
    local v98 = t1.value31().Snap or false
    local v99 = t1.value31().ItemDroppedGraber or false
    local v100 = t1.value31().InfStamina or false
    local v101 = t1.value31().AutoRespawn or false
    local v102 = t1.value31().HideName or false
    local v103 = t1.value31().AntiRagdoll or false
    local v104 = t1.value31().AntiDied or false
    local v105 = t1.value31().AntiAim or false
    local v106 = t1.value31().AutoHeal or false
    local v107 = t1.value31().SpeedBostVehicle or false
    local v108 = t1.value31().Wallbang or false
    local v109 = t1.value31().MultiShot or false
    local v110 = t1.value31().FriendIgnore or false
    local v111 = t1.value31().RainbowPov or false
    local v112 = t1.value31().AutomaticGun or false
    local v113 = t1.value31().Desync or false
    local v114 = t1.value31().BlacklistItem or false
    local v115 = t1.value31().PovSize or 150
    local v116 = t1.value31().SpeedValue or 1
    local v117 = t1.value31().JumpValue or 10
    local v118 = t1.value31().SnapAmount or 10
    local v119 = t1.value31().GrabRadius or 45
    local v120 = t1.value31().HealThreshold or 50
    local v121 = t1.value31().VehicleSpeedBost or 20
    local v122 = t1.value31().AimPart or "Random"
    local v123 = t1.value31().FOVMode or "Center"
    local v124 = t1.value31().FireRateGun or 1000
    local v125 = t1.value31().RecoilGun or 0.3
    local v126 = t1.value31().AccuracyGun or 1
    local v127 = t1.value31().DurabilityGun or 1000
    local v128 = t1.value31().BlacklistRarity or {}
    local v129 = t1.value31().ConfigName or ""
    local v130 = t1.value31().FriendJobId or ""
    local v131 = t1.value31().SitHeight or -1
    local v132 = t1.value31().HeadSnapAll or false
    local v133 = t1.value31().SnapZone or 20
    local v134 = t1.value31().FOVThickness or 0.3
    local v135 = t1.value31().AutoDoorLock or false
    local v136 = t1.value31().AutoJump or false
    local t7 = {
		AimAssist = v89,
		EnemyGlow = v90,
		NameESP = v91,
		DistESP = v92,
		BarESP = v93,
		InvESP = v94,
		ItemESP = v95,
		SpeedCustom = v96,
		JumpCustom = v97,
		Snap = v98,
		ItemDroppedGraber = v99,
		InfStamina = v100,
		AutoRespawn = v101,
		HideName = v102,
		AntiRagdoll = v103,
		AntiDied = v104,
		AntiAim = v105,
		AutoHeal = v106,
		SpeedBostVehicle = v107,
		Wallbang = v108,
		MultiShot = v109,
		FriendIgnore = v110,
		RainbowPov = v111,
		AutomaticGun = v112,
		Desync = v113,
		BlacklistItem = v114,
		PovSize = v115,
		SpeedValue = v116,
		JumpValue = v117,
		SnapAmount = v118,
		GrabRadius = v119,
		HealThreshold = v120,
		VehicleSpeedBost = v121,
		AimPart = v122,
		FOVMode = v123,
		FireRateGun = v124,
		RecoilGun = v125,
		AccuracyGun = v126,
		DurabilityGun = v127,
		BlacklistRarity = v128,
		ConfigName = v129,
		FriendJobId = v130,
		SitHeight = v131,
		HeadSnapAll = v132,
		SnapZone = v133,
		FOVThickness = v134,
		AutoDoorLock = v135,
		AutoJump = v136
	}

    pcall(function()
        writefile(t1.value34, t1.value9:JSONEncode(t7))
    end)
end
function t1.value38()
    if not isfile(t1.value34) then
        return false
    end

    local ok, result = pcall(function()
        local value9 = t1.value9
        local t8 = { readfile(t1.value34) }

        return value9:JSONDecode(v2(t8))
    end)
    local v151 = not ok

    if not v151 then
        v151 = type(result) ~= "table"
    end

    if v151 then
        return false
    end

    for k, v in pairs(result) do
        t1.value31()[k] = v
    end

    return true
end
t1.value30().Sky = false
t1.value30().SkyAmount = 1500
t1.value39 = false
t1.value40 = {}
t1.value41 = -25
t1.value42 = 8
t1.value43 = 0.01
t1.value44 = 20
t1.value45 = 0
t1.value46 = false
local color3 = Color3.fromRGB(160, 160, 160)
local color3_2 = Color3.fromRGB(120, 200, 255)
local color3_3 = Color3.fromRGB(51, 170, 255)
local color3_4 = Color3.fromRGB(0, 110, 255)
local color3_5 = Color3.fromRGB(0, 60, 200)
local color3_6 = Color3.fromRGB(0, 255, 255)

t1.value47 = {
	Common = color3,
	Uncommon = color3_2,
	Rare = color3_3,
	Epic = color3_4,
	Legendary = color3_5,
	Omega = color3_6
}
t1.value48 = nil
t1.value49 = {}
t1.value50 = false
t1.value51 = {}
t1.value52 = true
t1.value48 = nil
pcall(function()
    for __, v in ipairs(getgc(true)) do
        if typeof(v) == "table" and (rawget(v, "event") and rawget(v, "func")) then
            t1.value48 = v

            return
        end
    end
end)

function t1.value53(p2)
    if not p2 then
        return nil
    end

    local v159 = type(p2) == "number"

    if not v159 then
        v159 = type(p2) == "string" and tonumber(p2)
    end

    if v159 then
        return "rbxassetid://" .. tostring(p2)
    end

    local v160 = type(p2) == "string"

    if v160 then
        v160 = p2:find("rbxassetid://") or p2:find("http")
    end

    if v160 then
        return p2
    end

    return nil
end
t1.value54 = nil
pcall(function()
    if not t1.value19 then
        return
    end

    for __, child in ipairs(t1.value19:GetChildren()) do
        local _ipairs = ipairs

        for __, v165 in _ipairs(child:GetChildren()) do
            local v166 = v165:IsA("Tool")

            if not v166 then
                v166 = v165:IsA("Model")

                if not v166 then
                    v166 = v165:IsA("Configuration") or v165:IsA("Folder")
                end
            end

            if v166 then
                local v167 = v165:GetAttribute("DisplayName") or v165.Name
                local RarityName = v165:GetAttribute("RarityName")

                if not RarityName then
                    RarityName = v165:GetAttribute("Rarity") or "Common"
                end

                local ImageId = v165:GetAttribute("ImageId")

                if not ImageId then
                    ImageId = v165:GetAttribute("Icon") or v165:GetAttribute("Texture")
                end

                local v170 = t1.value53(ImageId)

                if not v170 then
                    local Handle = v165:FindFirstChild("Handle")

                    if Handle then
                        if Handle:IsA("MeshPart") and Handle.TextureID ~= "" then
                            v170 = t1.value53(Handle.TextureID)
                        else
                            local SpecialMesh = Handle:FindFirstChildOfClass("SpecialMesh")

                            if SpecialMesh and SpecialMesh.TextureId ~= "" then
                                v170 = t1.value53(SpecialMesh.TextureId)
                            end
                        end
                    end
                end

                local v173 = v170 or "rbxassetid://7072725737"
                local Name = v165.Name
                local t9 = {
					Name = v167,
					Rarity = RarityName,
					ImageId = v173,
					ToolName = Name
				}

                _ipairs = t1.value49
                _ipairs[v165.Name:lower()] = t9

                local v176 = v165:GetAttribute("ItemId") or v165:GetAttribute("Id")

                if v176 then
                    _ipairs = t1.value49
                    _ipairs[tostring(v176):lower()] = t9
                end
            end
        end
    end
end)

function t1.value55(p3)
    if not p3 then
        return nil
    end

    local v187 = p3.Name:lower()

    if t1.value49[v187] then
        return t1.value49[v187]
    end

    local DisplayName = p3:GetAttribute("DisplayName")

    if not DisplayName then
        DisplayName = p3:GetAttribute("Name") or p3.Name
    end

    local RarityName = p3:GetAttribute("RarityName")

    if not RarityName then
        RarityName = p3:GetAttribute("Rarity") or "Common"
    end

    local ImageId = p3:GetAttribute("ImageId")

    if not ImageId then
        ImageId = p3:GetAttribute("Icon") or p3:GetAttribute("Texture")
    end

    local v191 = t1.value53(ImageId)

    if not v191 then
        local Handle = p3:FindFirstChild("Handle")

        if Handle then
            if Handle:IsA("MeshPart") and Handle.TextureID ~= "" then
                v191 = t1.value53(Handle.TextureID)
            else
                local SpecialMesh = Handle:FindFirstChildOfClass("SpecialMesh")

                if SpecialMesh and SpecialMesh.TextureId ~= "" then
                    v191 = t1.value53(SpecialMesh.TextureId)
                end
            end
        end
    end

    local v194 = v191 or "rbxassetid://7072725737"
    local p3Name = p3.Name
    local t10 = {
		Name = DisplayName,
		Rarity = RarityName,
		ImageId = v194,
		ToolName = p3Name
	}

    t1.value49[v187] = t10

    return t10
end
function t1.value56()
    local PlayerGui = t1.value10:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return 0.15
    end

    local NetworkStats = PlayerGui:FindFirstChild("NetworkStats")

    if not NetworkStats then
        return 0.15
    end

    local PingLabel = NetworkStats:FindFirstChild("PingLabel")

    if not PingLabel then
        return 0.15
    end

    local PingLabelText = PingLabel.Text

    if type(PingLabelText) ~= "string" then
        return 0.15
    end

    local num = tonumber(PingLabelText:match("%d+"))

    if not num then
        return 0.15
    end

    local v182 = num / 1000

    if v182 < 0 or v182 > 1.5 then
        v182 = 0.15
    end

    return v182
end
t1.value54 = {}
function t1.value57(p4)
    for __, v in ipairs(t1.value54) do
        if v ~= "" and string.find(string.lower(p4), string.lower(v)) then
            return true
        end
    end

    return false
end
function t1.value58(__, __, __)
    return false
end
function t1.value59(p8)
    if not p8 then
        return nil
    end

    local t11 = {}

    if p8:FindFirstChild("Head") then
        table.insert(t11, p8.Head)
    end

    if p8:FindFirstChild("HumanoidRootPart") then
        table.insert(t11, p8.HumanoidRootPart)
    end

    if p8:FindFirstChild("UpperTorso") then
        table.insert(t11, p8.UpperTorso)
    end

    if #t11 > 0 then
        return t11[math.random(1, #t11)]
    end

    return p8:FindFirstChild("Head") or p8:FindFirstChild("HumanoidRootPart")
end
t1.value60 = true
t1.value61 = 120
t1.value62 = nil
function t1.value63()
    if not t1.value60 then
        return nil
    end
    local v212
    local value61 = t1.value61
    local vector2 = Vector2.new(t1.value11.ViewportSize.X / 2, t1.value11.ViewportSize.Y / 2)
    local CFramePosition = t1.value11.CFrame.Position
    for __, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value10 and player.Character then
            local Character = player.Character
            local Humanoid = Character:FindFirstChild("Humanoid")
            local v220 = t1.value59(Character)

            if Humanoid then
                Humanoid = Humanoid.Health > 0 and v220
            end

            if Humanoid then
                local Position = v220.Position
                local v222, v223 = t1.value11:WorldToViewportPoint(Position)

                if v223 then
                    local Magnitude = (Vector2.new(v222.X, v222.Y) - vector2).Magnitude

                    if Magnitude <= t1.value61 and not t1.value57(player.Name) and not t1.value58(CFramePosition, Position, Character) and Magnitude < value61 then
                        value61 = Magnitude
                        v212 = player
                    end
                end
            end
        end
    end

    return v212
end
function t1.value64(p9, p10)
    if not p9 then
        return Vector3.zero
    end

    local v204 = t1.value56() * 1.3
    local v205 = p10 and p10.AssemblyLinearVelocity

    if not v205 then
        v205 = Vector3.zero
    end

    if v205.Y < -100 then
        v205 = Vector3.new(v205.X, 0, v205.Z)
    end

    local v206 = p10 and p10.AssemblyAngularVelocity

    if not v206 then
        v206 = Vector3.zero
    end

    if v206.Y ~= 0 then
        local p10Position = p10.Position
        local v208 = p9.Position - p10Position
        local v209 = v206.Y * v204
        local v210 = math.cos(v209)
        local v211 = math.sin(v209)

        return p10Position + Vector3.new(v208.X * v210 - v208.Z * v211, v208.Y, v208.X * v211 + v208.Z * v210) + v205 * v204
    end

    return p9.Position + v205 * v204
end
function t1.value65()
    local Character = t1.value10.Character

    if Character then
        local GetChildren = Character.GetChildren

        for __, v in ipairs(GetChildren(Character)) do
            local v83 = v

            if pcall(function()
                return v83:IsA("Tool")
            end) and v83:IsA("Tool") then
                return v83
            end
        end
    end

    local Backpack = t1.value10:FindFirstChild("Backpack")

    if Backpack then
        local GetChildren = Backpack.GetChildren

        for __, v in ipairs(GetChildren(Backpack)) do
            local v88 = v

            if pcall(function()
                return v88:IsA("Tool")
            end) and v88:IsA("Tool") then
                return v88
            end
        end
    end

    return nil
end
function t1.value66(p11)
    if not p11 or not p11:IsA("Tool") then
        return false
    end

    local AmmoType = p11:GetAttribute("AmmoType")

    if AmmoType == "shotgun" or AmmoType == "shootgun" then
        return true
    end

    if p11.Name:lower():find("shotgun") or (p11.Name:lower():find("db") or p11.Name:lower():find("spas")) then
        return true
    end

    return false
end
t1.value67 = nil
if t1.value17 and t1.value17.FireServer then
    pcall(function()
        t1.value67 = hookfunction(t1.value17.FireServer, function(p12, ...)
            if p12 ~= t1.value17 then
                return t1.value67(p12, ...)
            end

            local value60 = t1.value60
            local t12 = { ... }

            if value60 then
                value60 = t12[2] == "shoot_gun" and (t1.value62 and t1.value62.Character)
            end

            if value60 then
                local Character = t1.value10.Character
                local v622 = Character and Character:FindFirstChild("Head")
                local v623 = t1.value59(t1.value62.Character)
                local HumanoidRootPart = t1.value62.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = t1.value62.Character:FindFirstChild("Humanoid")
                local v626 = v622

                if v622 then
                    v626 = v623 and HumanoidRootPart
                end

                if v626 then
                    local v627 = t1.value64(v623, HumanoidRootPart)
                    local Position = v622.Position
                    local v629 = t1.value65()

                    if not t1.value58(Position, v627, t1.value62.Character) then
                        t12[4] = CFrame.new(Position, v627)

                        local t13 = {}

                        if t1.value66(v629) then
                            local t14 = {}

                            for __ = 1, 6 do
                                local vector3 = Vector3.new((math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1)
                                local insert = table.insert
                                local vector3_2 = Vector3.new(0, 1, 0)

                                insert(t14, {
									[1] = {
										Instance = v623,
										Normal = vector3_2,
										Position = v627 + vector3
									}
								})

                                local Part = Instance.new("Part")

                                Part.Anchored = true
                                Part.CanCollide = false
                                Part.Size = Vector3.new(0.02, 0.02, (v627 + vector3 - Position).Magnitude)
                                Part.CFrame = CFrame.new(Position, v627 + vector3) * CFrame.new(0, 0, -Part.Size.Z / 2)
                                Part.Material = Enum.Material.Neon
                                Part.Transparency = 0.3
                                Part.Color = Color3.fromRGB(0, 170, 255)
                                Part.Parent = t1.value5
                                table.insert(t13, Part)
                                t1.value7:AddItem(Part, 1.2)
                            end

                            t12[5] = t14
                        else
                            local vector3 = Vector3.new(0, 1, 0)

                            t12[5] = {
								[1] = {
									[1] = {
										Instance = v623,
										Normal = vector3,
										Position = v627
									}
								}
							}

                            local Part = Instance.new("Part")

                            Part.Anchored = true
                            Part.CanCollide = false
                            Part.Size = Vector3.new(0.03, 0.03, (v627 - Position).Magnitude)
                            Part.CFrame = CFrame.new(Position, v627) * CFrame.new(0, 0, -Part.Size.Z / 2)
                            Part.Material = Enum.Material.Neon
                            Part.Transparency = 0.35
                            Part.Color = Color3.fromRGB(0, 170, 255)
                            Part.Parent = t1.value5
                            table.insert(t13, Part)
                            t1.value7:AddItem(Part, 1.5)
                        end

                        if Humanoid then
                            local Health = Humanoid.Health

                            spawn(function()
                                local timestamp = tick()

                                while tick() - timestamp < 0.35 do
                                    local v826 = Humanoid

                                    if v826 then
                                        v826 = Humanoid.Health < Health

                                        if not v826 then
                                            v826 = Humanoid.Health <= 0
                                        end
                                    end

                                    if v826 then
                                        for __, v in ipairs(t13) do
                                            if v and v.Parent then
                                                v.Color = Color3.fromRGB(0, 255, 255)
                                            end
                                        end

                                        return
                                    end

                                    task.wait(0.02)
                                end
                            end)
                        end
                    end
                end
            end

            if t1.value31().MultiShot then
                t1.value67(p12, unpack(t12))
            end

            return t1.value67(p12, unpack(t12))
        end)
    end)
end
t1.value68 = nil
pcall(function()
    t1.value68 = hookmetamethod(game, "__namecall", function(p13, ...)
        local t15 = { ... }
        local v642 = getnamecallmethod() == "FireServer"

        if v642 then
            v642 = p13.Name == "Network" and t15[1] == "shoot"
        end

        if v642 and t1.value31().AntiAim then
            local vector3 = Vector3.new(math.random(-50, 50), math.random(-10, 20), math.random(-50, 50))

            t15[3] = CFrame.new(t15[3].Position + vector3)
        end

        return t1.value68(p13, ...)
    end)
end)
t1.value69 = nil
t1.value70 = nil
pcall(function()
    t1.value69 = Drawing.new("Line")
    t1.value69.Thickness = 0.8
    t1.value69.Color = Color3.fromRGB(0, 170, 255)
    t1.value69.Transparency = 1
    t1.value69.Visible = false
    t1.value70 = {}

    for i = 1, 4 do
        t1.value70[i] = Drawing.new("Line")
        t1.value70[i].Color = Color3.fromRGB(0, 170, 255)
        t1.value70[i].Thickness = 1
        t1.value70[i].Visible = false
    end
end)
t1.value71 = {}
t1.value72 = false
t1.value73 = false
t1.value74 = false
t1.value75 = false
t1.value76 = 0.05
t1.value77 = false
t1.value78 = false
t1.value79 = 35
t1.value80 = false
t1.value81 = false
t1.value82 = nil
t1.value83 = 10
t1.value84 = nil
t1.value85 = 0
t1.value86 = false
t1.value87 = 1
t1.value88 = 0.4
t1.value89 = false
t1.value90 = nil
t1.value91 = false
function t1.value92()
    local v225 = t1.value16.get_hum()

    if not v225 then
        return false
    end

    if v225.Health <= 0 then
        return false
    end

    return v225:GetAttribute("HasBeenDowned") or v225:GetAttribute("IsDead")
end
t1.value93 = nil
local function v23(p14)
    if _ then
        pcall(function()
            _:Disconnect()
        end)
    end

    _ = t1.value2.RenderStepped:Connect(function()
        if t1.value75 then
            local Humanoid = p14:FindFirstChild("Humanoid")
            local HumanoidRootPart = p14:FindFirstChild("HumanoidRootPart")
            local v651 = Humanoid
            if Humanoid then
                v651 = HumanoidRootPart and Humanoid.MoveDirection.Magnitude > 0
            end
            if v651 then
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Humanoid.MoveDirection.Unit * t1.value76
            end
        end
    end)
end
function t1.value93()
    local v227 = t1.value16.current_char.get()

    if not v227 then
        return nil
    end

    return v227:FindFirstChild("HumanoidRootPart")
end
function t1.value94()
    local v239 = t1.value93()

    if not v239 then
        return
    end

    t1.value90 = v239.CFrame + Vector3.new(0, t1.value41, 0)
    v239.CFrame = t1.value90
end
function t1.value95()
    if t1.value89 then
        return
    end

    t1.value89 = true
    spawn(function()
        while t1.value89 and (t1.value25 and t1.value92()) do
            local v644 = t1.value16.get_hum()

            if v644 and v644.Health <= 0 then
                return
            end

            local v645 = t1.value93()

            if v645 and t1.value90 then
                local v646 = math.random() * 3.141592653589793 * 2
                local v647 = Vector3.new(math.cos(v646), 0, (math.sin(v646))) * t1.value42
                local v648 = t1.value90.Position + v647

                v645.CFrame = CFrame.new(v648)
                task.wait(0.04)
                v645.CFrame = t1.value90
            end

            task.wait(t1.value43)
        end
    end)
end
function t1.value96(...)
    if not t1.value48 or not t1.value48.func then
        return
    end

    local t16 = { ... }
    local _ipairs = ipairs

    for v243, v244 in _ipairs(t16) do
        local v245 = typeof(v244) == "Instance"

        if v245 then
            v245 = v244:IsA("Model") and #v244:GetChildren() == 0
        end

        if not v245 then
            continue
        end

        local DroppedItems = t1.value5:FindFirstChild("DroppedItems")

        if not DroppedItems then
            return
        end

        local Model = DroppedItems:FindFirstChildWhichIsA("Model")

        if not Model then
            return
        end

        _ipairs = t16
        _ipairs[v243] = Model
    end

    t1.value48.func = (t1.value48.func or 0) + 1

    local ok, result = pcall(function()
        if t1.value18 then
            local value18 = t1.value18
            local func = t1.value48.func
            local t17 = { unpack(t16) }

            return value18:InvokeServer(func, v2(t17))
        end
    end)

    if not ok then
        warn("[NetGet Error]", result)
    end

    return result
end
function t1.value97()
    if not t1.value39 then
        return
    end
    local DroppedItems = t1.value5:FindFirstChild("DroppedItems")
    if not DroppedItems then
        return
    end
    local v251 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")
    if not v251 then
        return
    end
    local timestamp = tick()
    local t18 = {}
    for v256, v257 in ipairs(DroppedItems:GetChildren()) do

        if v257:IsA("Model") then
            local BasePart = v257:FindFirstChildWhichIsA("BasePart")

            if BasePart and ((v251.Position - BasePart.Position).Magnitude <= 25 and timestamp - (t1.value40[v257] or 0) >= 0) then
                table.insert(t18, v257)
                t1.value40[v257] = timestamp
            end
        end
    end
    for __, v in ipairs(t18) do
        local v261 = v

        spawn(function()
            t1.value96("pickup_dropped_item", v261)
        end)
    end
end
function t1.value98(p15)
    local t19 = {}
    local Character = t1.value10.Character

    if not Character or not Character.PrimaryPart then
        return t19
    end

    local PrimaryPartPosition = Character.PrimaryPart.Position

    for __, player in ipairs(t1.value1:GetPlayers()) do
        local v236 = player

        if v236 ~= t1.value10 and (v236.Character and v236.Character.PrimaryPart) then
            local ok, result = pcall(function()
                return (v236.Character.PrimaryPart.Position - PrimaryPartPosition).Magnitude
            end)

            if ok then
                if result then
                    result = result <= p15
                end

                ok = result
            end

            if ok then
                table.insert(t19, v236)
            end
        end
    end

    return t19
end
function t1.value99(p16)
    if not p16 then
        return false
    end

    if p16.Name == "Fists" then
        return true
    end

    if t1.value20 and t1.value20:FindFirstChild(p16.Name) then
        local v229 = t1.value19 and t1.value19:FindFirstChild("throwable")

        if v229 and v229:FindFirstChild(p16.Name) then
            return false
        end

        return true
    end

    return false
end
function t1.value100()
    if not t1.value17 then
        return
    end
    local Character = t1.value10.Character
    if not Character or not Character.PrimaryPart then
        return
    end
    local v266 = t1.value65()
    if not v266 or not t1.value99(v266) then
        return
    end
    if Character ~= v266.Parent then
        return
    end
    local v267 = t1.value98(t1.value44)
    if #v267 == 0 then
        return
    end
    local PrimaryPartPosition = Character.PrimaryPart.Position
    local t20 = {}
    local t21 = {}
    for v273, v274 in ipairs(v267) do

        if v274.Character and v274.Character.PrimaryPart then
            local v275 = t1.value59(v274.Character)
            local PrimaryPart = v274.Character.PrimaryPart

            if v275 and PrimaryPart then
                local v277 = t1.value64(v275, PrimaryPart)

                table.insert(t20, v274)
                table.insert(t21, v277)
            end
        end
    end
    if #t20 == 0 then
        return
    end
    local v278 = t21[1]
    local t22 = {
		"melee_attack",
		v266,
		t20,
		CFrame.lookAt(PrimaryPartPosition, v278),
		0.75
	}
    pcall(function()
        if t1.value48 then
            t1.value48.event = (t1.value48.event or 0) + 1

            local value17 = t1.value17
            local event = t1.value48.event
            local t23 = { unpack(t22) }

            value17:FireServer(event, v2(t23))

            return
        end

        t1.value45 = (t1.value45 or 0) + 1
        t1.value17:FireServer(t1.value45, unpack(t22))
    end)
end
t1.value101 = nil
function t1.value101()
    local v262 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

    if not v262 then
        return
    end

    local Position = v262.Position
    local vector3 = Vector3.new(Position.X, Position.Y - t1.value83, Position.Z)

    v262.CFrame = CFrame.new(vector3)
    t1.value82 = vector3.Y
end
function t1.value102()
    if not t1.value81 then
        return
    end

    t1.value80 = not t1.value80

    if t1.value80 then
        t1.value101()

        return
    end

    t1.value82 = nil
end
t1.value103 = nil
t1.value104 = true
t1.value105 = {}
local color3_7 = Color3.fromRGB(160, 160, 160)
local color3_8 = Color3.fromRGB(120, 200, 255)
local color3_9 = Color3.fromRGB(51, 170, 255)
local color3_10 = Color3.fromRGB(0, 110, 255)
local color3_11 = Color3.fromRGB(0, 60, 200)
local color3_12 = Color3.fromRGB(0, 255, 255)

t1.value106 = {
	Common = color3_7,
	Uncommon = color3_8,
	Rare = color3_9,
	Epic = color3_10,
	Legendary = color3_11,
	Omega = color3_12
}
t1.value107 = {}
function getInventoryItemKey(p17)
    local FindFirstChild = p17.FindFirstChild
    local GetAttribute = p17.GetAttribute
    local v283 = FindFirstChild(p17, "Handle")
    local v284 = GetAttribute(p17, "RarityName") or "Common"

    if v283 then
        local SpecialMesh = v283:FindFirstChildOfClass("SpecialMesh")

        if SpecialMesh and SpecialMesh.MeshId ~= "" then
            return SpecialMesh.MeshId .. (SpecialMesh.TextureId or "" .. "_RARITY_" .. v284)
        end

        if v283:IsA("MeshPart") and v283.MeshId ~= "" then
            return v283.MeshId .. (v283.TextureID or "" .. "_RARITY_" .. v284)
        end
    end

    local v286 = p17:GetAttribute("ItemId") or (p17:GetAttribute("Id") or p17.Name)
    local v287 = v286

    if v286 then
        v287 = v286 ~= "" and v286 ~= p17.Name
    end

    if v287 then
        return "ITEMID_" .. v286 .. "_RARITY_" .. v284
    end

    return "NAME_" .. (p17:GetAttribute("DisplayName") or p17.Name .. "_" .. p17.Name .. "_RARITY_" .. v284)
end
function getInventoryWeaponInfo(p18)
    if not p18 or not p18:IsA("Tool") then
        return nil
    end

    return t1.value107[getInventoryItemKey(p18)]
end
function registerInventoryItems()
    if not t1.value19 then
        return
    end

    for __, child in ipairs(t1.value19:GetChildren()) do
        if child:IsA("Folder") then
            for __, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("Tool") then
                    local v293 = getInventoryItemKey(child2)

                    if v293 then
                        local value107 = t1.value107
                        local v295 = child2:GetAttribute("DisplayName") or child2.Name
                        local v296 = child2:GetAttribute("RarityName") or "Common"
                        local v297 = child2:GetAttribute("ImageId") or "rbxassetid://7072725737"
                        local child2Name = child2.Name

                        value107[v293] = {
							Name = v295,
							Rarity = v296,
							ImageId = v297,
							ToolName = child2Name
						}
                    end
                end
            end
        end
    end
end
t1.value108 = nil
pcall(registerInventoryItems)

function createBillboardForPlayer(p19)
    if p19 == t1.value10 then
        return
    end
    local Character = p19.Character
    if not Character then
        return
    end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return
    end
    if t1.value105[p19] then
        t1.value105[p19]:Destroy()
        t1.value105[p19] = nil
    end
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Adornee = HumanoidRootPart
    BillboardGui.Size = UDim2.new(0, 100, 0, 20)
    BillboardGui.StudsOffset = Vector3.new(0, -2.5, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Parent = Character
    local UIListLayout = Instance.new("UIListLayout", BillboardGui)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local t24 = {}
    for v307, v308 in ipairs({
		"Backpack",
		"StarterGear",
		"StarterPack"
	}) do

        local v309 = p19:FindFirstChild(v308)

        if v309 then
            for __, child in ipairs(v309:GetChildren()) do
                if child:IsA("Tool") and child.Name ~= "Fists" then
                    table.insert(t24, child)
                end
            end
        end
    end
    if Character then
        for __, child in ipairs(Character:GetChildren()) do
            if child:IsA("Tool") and child.Name ~= "Fists" then
                table.insert(t24, child)
            end
        end
    end
    for __, v in ipairs(t24) do
        local v316 = getInventoryWeaponInfo(v)

        if v316 then
            local ImageLabel = Instance.new("ImageLabel", BillboardGui)

            ImageLabel.Size = UDim2.new(0, 16, 0, 16)
            ImageLabel.BackgroundTransparency = 0.2
            ImageLabel.Image = v316.ImageId
            ImageLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
            Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 4)

            local UIStroke = Instance.new("UIStroke", ImageLabel)

            UIStroke.Color = t1.value106[v316.Rarity] or Color3.new(1, 1, 1)
            UIStroke.Thickness = 1.5
        end
    end
    t1.value105[p19] = BillboardGui
end
function destroyBillboard(p20)
    if t1.value105[p20] then
        t1.value105[p20]:Destroy()
        t1.value105[p20] = nil
    end
end
function updateAllPlayers()
    if not t1.value104 then
        for __, v in pairs(t1.value105) do
            v.Enabled = false
        end

        return
    end

    for __, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value10 then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                createBillboardForPlayer(player)
            else
                destroyBillboard(player)
            end
        end
    end
end
t1.value1.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.2)
        updateAllPlayers()
    end)
    task.wait(0.2)
    updateAllPlayers()
end)
t1.value1.PlayerRemoving:Connect(destroyBillboard)
spawn(function()
    while true do
        task.wait(1)
        updateAllPlayers()
    end
end)
t1.value4.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.X then
        t1.value104 = not t1.value104

        if t1.value104 then
            updateAllPlayers()

            return
        end

        for __, v in pairs(t1.value105) do
            v.Enabled = false
        end
    end
end)
task.wait(0.5)
updateAllPlayers()
t1.value109 = nil
t1.value110 = nil
function t1.value109(p21)
    if p21 and p21:IsA("ProximityPrompt") then
        p21.HoldDuration = t1.value87
        p21.MaxActivationDistance = 20
    end
end
function t1.value111(p22, p23)
    if not p22 or p22:GetAttribute("__AutoFinishBusy") then
        return
    end

    p22:SetAttribute("__AutoFinishBusy", true)
    pcall(function()
        if p22.InputHoldBegin then
            p22:InputHoldBegin()
        end
    end)
    pcall(function()
        if p22.HoldBegin then
            p22:HoldBegin()
        end
    end)
    pcall(function()
        if p22.Trigger then
            p22:Trigger()
        end
    end)
    task.wait(p23)
    pcall(function()
        if p22.InputHoldEnd then
            p22:InputHoldEnd()
        end
    end)
    pcall(function()
        if p22.HoldEnd then
            p22:HoldEnd()
        end
    end)
    p22:SetAttribute("__AutoFinishBusy", nil)
end
function t1.value112()
    local t25 = {}

    for __, child in ipairs(t1.value5:GetChildren()) do
        local player = t1.value1:GetPlayerFromCharacter(child)

        if player and not t1.value57(player.Name) then
            local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                local FinishPrompt = HumanoidRootPart:FindFirstChild("FinishPrompt")

                if FinishPrompt then
                    t1.value109(FinishPrompt)
                    table.insert(t25, FinishPrompt)
                end
            end
        end
    end

    return t25
end
function t1.value113()
    for __, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value10 and player.Character then
            local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                local FinishPrompt = HumanoidRootPart:FindFirstChild("FinishPrompt")

                if FinishPrompt then
                    t1.value109(FinishPrompt)
                end
            end
        end
    end
end
local function v30(p24)
    if p24 ~= t1.value10 then
        p24.CharacterAdded:Connect(function(character)
            character.DescendantAdded:Connect(function(descendant)
                local value86 = t1.value86

                if value86 then
                    value86 = descendant.Name == "FinishPrompt"

                    if value86 then
                        value86 = descendant:IsA("ProximityPrompt") and (descendant.Parent and descendant.Parent.Name == "HumanoidRootPart")
                    end
                end

                if value86 then
                    t1.value109(descendant)
                end
            end)
        end)
    end
end
function t1.value110(p25)
    if t1.value57(p25.Name) then
        return Color3.fromRGB(0, 255, 255)
    end

    local value60 = t1.value60

    if value60 then
        value60 = t1.value62 and p25 == t1.value62
    end

    if value60 then
        return Color3.fromRGB(0, 170, 255)
    end

    return Color3.fromRGB(255, 255, 255)
end
function t1.value114(p26)
    if t1.value71[p26] then
        return
    end
    local drawing
    local drawing2
    local drawing3
    local drawing4
    local t26
    pcall(function()
        drawing = Drawing.new("Text")
        drawing.Size = 10
        drawing.Center = true
        drawing.Outline = true
        drawing.Color = Color3.fromRGB(255, 255, 255)
        drawing.Font = 2
        drawing2 = Drawing.new("Text")
        drawing2.Size = 9
        drawing2.Center = true
        drawing2.Outline = true
        drawing2.Color = Color3.fromRGB(200, 200, 200)
        drawing2.Font = 2
        drawing3 = Drawing.new("Square")
        drawing3.Filled = false
        drawing3.Thickness = 1
        drawing3.Color = Color3.fromRGB(0, 0, 0)
        drawing3.Transparency = 0.8
        drawing3.Visible = false
        drawing4 = Drawing.new("Square")
        drawing4.Filled = true
        drawing4.Transparency = 0.8
        drawing4.Visible = false
        t26 = {}

        for i = 1, 4 do
            local drawing5 = Drawing.new("Line")

            drawing5.Thickness = 1.2
            drawing5.Color = Color3.fromRGB(0, 170, 255)
            drawing5.Transparency = 1
            drawing5.Visible = false
            t26[i] = drawing5
        end
    end)
    local v351 = drawing
    local v352 = drawing2
    local v353 = drawing3
    local v354 = drawing4
    local v355 = t26 and t26[1]
    local v356 = t26
    if v356 then
        v356 = t26[2]
    end
    local t27 = {
		v351,
		v352,
		v353,
		v354,
		v355,
		v356,
		t26 and t26[3],
		t26 and t26[4]
	}
    local connection = t1.value2.RenderStepped:Connect(function()
        if not p26 or (not p26.Character or not p26.Character:FindFirstChild("HumanoidRootPart")) then
            for __, v in pairs(t27) do
                if v then
                    v.Visible = false
                end
            end

            return
        end

        local HumanoidRootPart = p26.Character.HumanoidRootPart
        local Humanoid = p26.Character:FindFirstChild("Humanoid")
        local n1 = 0

        if t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart") then
            n1 = (HumanoidRootPart.Position - t1.value10.Character.HumanoidRootPart.Position).Magnitude
        end

        local v667, v668 = t1.value11:WorldToViewportPoint(HumanoidRootPart.Position)

        if not v668 or v667.Z <= 0 then
            for __, v in pairs(t27) do
                if v then
                    v.Visible = false
                end
            end

            return
        end

        local v671 = t1.value110(p26)
        local X = v667.X
        local v673 = v667.Y - 8
        local value74 = t1.value74

        if value74 then
            value74 = Humanoid

            if Humanoid then
                value74 = Humanoid.Health > 0
            end
        end

        if value74 then
            local v675 = Humanoid.Health / math.max(Humanoid.MaxHealth, 1)
            local n2 = 30
            local n3 = 3
            local v678 = X - n2 / 2
            local v679 = v673 - n3 - 2

            if drawing3 then
                drawing3.Position = Vector2.new(v678 - 1, v679 - 1)

                local v680 = drawing3
                local new = Vector2.new
                local v682 = n3 + 2

                v680.Size = new(n2 + 2, v682)
                drawing3.Visible = true
            end

            if drawing4 then
                drawing4.Position = Vector2.new(v678, v679)
                drawing4.Size = Vector2.new(n2 * v675, n3)
                drawing4.Color = Color3.fromRGB(0, math.floor(70 + 185 * v675), 255)
                drawing4.Visible = true
            end

            v673 = v673 - n3 - 4
        else
            if drawing3 then
                drawing3.Visible = false
            end

            if drawing4 then
                drawing4.Visible = false
            end
        end

        if t1.value72 and drawing then
            drawing.Text = p26.Name
            drawing.Color = v671
            drawing.Position = Vector2.new(X, v673 - 10)
            drawing.Visible = true
        elseif drawing then
            drawing.Visible = false
        end

        if t1.value73 and drawing2 then
            drawing2.Text = string.format("[%d m]", (math.floor(n1)))
            drawing2.Position = Vector2.new(X, v667.Y + 14)
            drawing2.Visible = true
        elseif drawing2 then
            drawing2.Visible = false
        end

        local value29 = t1.value29

        if value29 then
            value29 = p26.Character and t26
        end

        if value29 then
            local v684 = p26.Character:FindFirstChild("Head") or HumanoidRootPart
            local v685, v686 = t1.value11:WorldToViewportPoint(v684.Position + Vector3.new(0, 1.8, 0))
            local v687, v688 = t1.value11:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))

            if v686 then
                v686 = v688 and (v685.Z > 0 and v687.Z > 0)
            end

            if v686 then
                local v689 = math.abs(v687.Y - v685.Y) * 0.5
                local v690 = (v685.X + v687.X) / 2
                local Y = v685.Y
                local Y2 = v687.Y
                local v693 = v690 - v689 / 2
                local v694 = v690 + v689 / 2

                t26[1].From = Vector2.new(v693, Y)
                t26[1].To = Vector2.new(v694, Y)
                t26[2].From = Vector2.new(v693, Y2)
                t26[2].To = Vector2.new(v694, Y2)
                t26[3].From = Vector2.new(v693, Y)
                t26[3].To = Vector2.new(v693, Y2)
                t26[4].From = Vector2.new(v694, Y)
                t26[4].To = Vector2.new(v694, Y2)

                for i = 1, 4 do
                    t26[i].Color = v671
                    t26[i].Visible = true
                end

                return
            end

            for i = 1, 4 do
                t26[i].Visible = false
            end

            return
        end

        if t26 then
            for i = 1, 4 do
                t26[i].Visible = false
            end
        end
    end)
    t1.value71[p26] = {
		conn = connection,
		drawings = t27
	}
end
t1.value108 = {}
pcall(function()
    for i = 1, 12 do
        t1.value108[i] = Drawing.new("Line")
        t1.value108[i].Visible = false
        t1.value108[i].Thickness = 1.5
    end
end)

function t1.value115(p27)
    if not p27 then
        for i = 1, 12 do
            local v364 = i

            if t1.value108[v364] then
                t1.value108[v364].Visible = false
            end
        end

        return
    end

    local vector2 = Vector2.new(t1.value11.ViewportSize.X / 2, t1.value11.ViewportSize.Y / 2)
    local color3_13 = Color3.fromHSV(tick() % 5 / 5, 1, 1)

    for i = 1, 12 do
        local v368 = i
        local v369 = math.rad((v368 - 1) * 30)
        local v370 = math.rad(v368 * 30)

        if t1.value108[v368] then
            t1.value108[v368].From = vector2 + Vector2.new(math.cos(v369) * t1.value61, math.sin(v369) * t1.value61)
            t1.value108[v368].To = vector2 + Vector2.new(math.cos(v370) * t1.value61, math.sin(v370) * t1.value61)
            t1.value108[v368].Color = color3_13
            t1.value108[v368].Visible = true
        end
    end
end
function t1.value116(p28)
    local Humanoid = p28:WaitForChild("Humanoid")

    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = 60
end
t1.value117 = nil
t1.value10.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    t1.value116(character)
end)

if t1.value10.Character then
    t1.value116(t1.value10.Character)
end;
(function()
    if t1.value117 then
        pcall(function()
            t1.value117:Disconnect()
        end)
    end

    t1.value117 = t1.value4.JumpRequest:Connect(function()
        if not t1.value77 then
            return
        end

        local v704 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

        if v704 and v704.Parent then
            t1.value78 = true
            task.delay(0.5, function()
                t1.value78 = false
            end)
        end
    end)
end)()
ContextActionService:BindAction("FlyUp", function(__, inputState, inputObject)
    if not t1.value77 then
        return Enum.ContextActionResult.Pass
    end

    if inputObject.UserInputType == Enum.UserInputType.Keyboard and inputObject.KeyCode == Enum.KeyCode.Space then
        if inputState == Enum.UserInputState.Begin then
            t1.value78 = true

            return Enum.ContextActionResult.Sink
        end

        if inputState == Enum.UserInputState.End then
            t1.value78 = false

            return Enum.ContextActionResult.Sink
        end
    end

    return Enum.ContextActionResult.Pass
end, false, Enum.KeyCode.Space)
t1.value2.RenderStepped:Connect(function()
    pcall(function()
        if t1.value60 then
            t1.value62 = t1.value63()
        else
            t1.value62 = nil
        end

        t1.value115(t1.value60)

        if t1.value60 and (t1.value62 and t1.value62.Character) then
            local Character = t1.value62.Character
            local Humanoid = Character:FindFirstChild("Humanoid")
            local v707 = t1.value59(Character)

            if Humanoid and (Humanoid.Health > 0 and v707) then
                local vector2 = Vector2.new(t1.value11.ViewportSize.X / 2, t1.value11.ViewportSize.Y / 2)
                local Position = v707.Position
                local v710, v711 = t1.value11:WorldToViewportPoint(Position)

                if v711 and not t1.value58(t1.value11.CFrame.Position, Position, Character) then
                    if t1.value69 then
                        t1.value69.Visible = true
                        t1.value69.From = vector2
                        t1.value69.To = Vector2.new(v710.X, v710.Y)
                        t1.value69.Color = Color3.fromRGB(0, 170, 255)
                        t1.value69.Thickness = 0.8
                    end

                    if t1.value70 then
                        local v712 = t1.value11:WorldToViewportPoint(v707.Position + Vector3.new(0, 0.4, 0))
                        local v713 = t1.value11:WorldToViewportPoint(v707.Position - Vector3.new(0, 0.4, 0))
                        local v714 = math.clamp((v712 - v713).Magnitude / 2, 6, 20)
                        local X = v710.X
                        local Y = v710.Y
                        local vector2_2 = Vector2.new(X, Y - v714)
                        local vector2_3 = Vector2.new(X, Y + v714)
                        local vector2_4 = Vector2.new(X - v714, Y)
                        local vector2_5 = Vector2.new(X + v714, Y)
                        local v721 = t1.value70[1]
                        local v722 = t1.value70[1]

                        v721.From = vector2_2
                        v722.To = vector2_5

                        local v723 = t1.value70[2]
                        local v724 = t1.value70[2]

                        v723.From = vector2_5
                        v724.To = vector2_3

                        local v725 = t1.value70[3]
                        local v726 = t1.value70[3]

                        v725.From = vector2_3
                        v726.To = vector2_4

                        local v727 = t1.value70[4]
                        local v728 = t1.value70[4]

                        v727.From = vector2_4
                        v728.To = vector2_2

                        for i = 1, 4 do
                            t1.value70[i].Visible = true
                        end
                    end
                else
                    if t1.value69 then
                        t1.value69.Visible = false
                    end

                    if t1.value70 then
                        for i = 1, 4 do
                            t1.value70[i].Visible = false
                        end
                    end
                end
            else
                if t1.value69 then
                    t1.value69.Visible = false
                end

                if t1.value70 then
                    for i = 1, 4 do
                        t1.value70[i].Visible = false
                    end
                end
            end
        else
            if t1.value69 then
                t1.value69.Visible = false
            end

            if t1.value70 then
                for i = 1, 4 do
                    t1.value70[i].Visible = false
                end
            end
        end

        if t1.value80 and t1.value82 then
            local v733 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

            if v733 then
                local Position = v733.Position

                if math.abs(Position.Y - t1.value82) > 0.05 then
                    v733.CFrame = CFrame.new(Position.X, t1.value82, Position.Z)
                end
            end
        end

        if t1.value77 and t1.value78 then
            local v735 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

            if v735 then
                v735.Velocity = Vector3.new(v735.Velocity.X, t1.value79, v735.Velocity.Z)
            end
        end
    end)
end)
t1.value2.Heartbeat:Connect(function()
    if t1.value30().Sky and (t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")) then
        local HumanoidRootPart = t1.value10.Character.HumanoidRootPart
        local HumanoidRootPartVelocity = HumanoidRootPart.Velocity
        local v379 = math.rad(tick() * 1500 % 360)
        local v380 = math.cos(v379) * t1.value30().SkyAmount
        local v381 = math.sin(v379) * t1.value30().SkyAmount
        local v382 = math.random(280, 480)

        HumanoidRootPart.Velocity = Vector3.new(v380, v382, v381)
        t1.value2.RenderStepped:Wait()
        HumanoidRootPart.Velocity = HumanoidRootPartVelocity
    end
end)
t1.value2.Heartbeat:Connect(function()
    if not t1.value25 then
        return
    end

    if t1.value92() then
        if t1.value93() and not t1.value90 then
            t1.value94()
        end

        t1.value95()

        return
    end

    if t1.value90 then
        local v383 = t1.value93()

        if v383 then
            v383.CFrame = t1.value90 + Vector3.new(0, -t1.value41, 0)
        end
    end
end)
t1.value2.Heartbeat:Connect(function()
    if not t1.value10.Character or not t1.value10.Character:FindFirstChild("HumanoidRootPart") then
        t1.value10.CharacterAdded:Wait()
    end

    pcall(t1.value97)
end)
t1.value10.CharacterAdded:Connect(v23)

if t1.value10.Character then
    v23(t1.value10.Character)
end
t1.value4.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Z and t1.value81 then
        t1.value102()
    end
end)
t1.value10.CharacterAdded:Connect(function()
    task.wait(1)
    task.wait(0.1)

    if t1.value91 then
        return
    end

    t1.value91 = true
    spawn(function()
        while t1.value91 do
            task.wait(t1.value88)

            if t1.value26 and (t1.value10.Character and t1.value10.Character.PrimaryPart) then
                pcall(t1.value100)
            end
        end
    end)
end)

if not t1.value91 then
    t1.value91 = true
    spawn(function()
        while t1.value91 do
            task.wait(t1.value88)

            if t1.value26 and (t1.value10.Character and t1.value10.Character.PrimaryPart) then
                pcall(t1.value100)
            end
        end
    end)
end
for __, player in ipairs(t1.value1:GetPlayers()) do
    v30(player)
end
t1.value1.PlayerAdded:Connect(v30)
spawn(function()
    while true do
        task.wait(t1.value88)

        if t1.value86 then
            for __, v in ipairs(t1.value112()) do
                local v388 = v

                spawn(function()
                    t1.value111(v388, t1.value87)
                end)
            end
        end
    end
end)

function t1.value118(p30)
    if p30 == t1.value10 then
        return
    end

    if not p30.Character then
        return
    end

    if t1.value51[p30] then
        t1.value51[p30]:Destroy()
        t1.value51[p30] = nil
    end

    if t1.value27 then
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "PlayerHighlight"
        Highlight.Adornee = p30.Character
        Highlight.FillColor = Color3.fromRGB(0, 170, 255)
        Highlight.OutlineColor = Color3.fromRGB(0, 170, 255)
        Highlight.Parent = t1.value5
        t1.value51[p30] = Highlight
    end
end;
(function()
    for __, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value10 and not t1.value71[player] then
            t1.value114(player)
        end
    end

    t1.value1.PlayerAdded:Connect(function(player)
        if player ~= t1.value10 then
            player.CharacterAdded:Connect(function()
                task.wait(0.2)

                if not t1.value71[player] then
                    t1.value114(player)
                end
            end)
        end
    end)
    t1.value1.PlayerRemoving:Connect(function(player)
        if t1.value71[player] then
            for __, v in pairs(t1.value71[player].drawings) do
                local v703 = v

                pcall(function()
                    if v703 and v703.Destroy then
                        v703:Destroy()

                        return
                    end

                    if v703 and v703.Remove then
                        v703:Remove()
                    end
                end)
            end

            if t1.value71[player].conn then
                pcall(function()
                    t1.value71[player].conn:Disconnect()
                end)
            end

            t1.value71[player] = nil
        end
    end)
end)()
t1.value119 = nil
t1.value119 = nil
t1.value120 = nil
pcall(function()
    t1.value119 = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if t1.value119 then
    pcall(function()
        local value119 = t1.value119
        local color3_14 = Color3.fromRGB(0, 170, 255)
        local color3_15 = Color3.fromRGB(0, 0, 0)
        local color3_16 = Color3.fromRGB(0, 60, 120)
        local _Color3 = Color3
        local AddTheme = value119.AddTheme
        local v400 = _Color3.fromRGB(235, 245, 255)

        AddTheme(value119, {
			Name = "Black Ghost",
			Accent = color3_14,
			Background = color3_15,
			Outline = color3_16,
			Text = v400
		})
        t1.value119:SetTheme("Black Ghost")
    end)
    pcall(function()
        local value119 = t1.value119
        local CreateWindow = value119.CreateWindow
        local uDim2 = UDim2.fromOffset(780, 560)
        local F3 = Enum.KeyCode.F3

        t1.value120 = CreateWindow(value119, {
			Title = "Bart Hub | .gg/StevCommunity",
			Icon = "rbxassetid://0",
			Author = "Free Script 🔫",
			Folder = "F3HUB_CONFIG",
			Size = uDim2,
			Theme = "Black Ghost",
			Transparent = true,
			Resizable = true,
			KeyCode = F3
		})

        if t1.value120 then
            local value120 = t1.value120
            local color3_17 = Color3.fromHex("#00aaff")

            value120:Tag({
				Title = "v2.2",
				Color = color3_17,
				Radius = 10
			})
        end
    end)
end
local function v33(__, __)
end
local function v34(p33, p34)
    if t1.value120 then
        return t1.value120:Tab({
			Title = p33,
			Icon = p34
		})
    end

    return {
		Section = function()
    end,
		Toggle = function()
        return {}
    end,
		Slider = function()
        return {}
    end,
		Button = function()
        return {}
    end,
		Input = function()
        return {}
    end,
		Dropdown = function()
        return {}
    end,
		Divider = function()
    end
	}
end
local v35 = v34("COMBAT", "crosshair")

v35:Section({
	Title = "SILENT AIM"
})
v33("SilentAim", (v35:Toggle({
	Title = "Silent Aim",
	Desc = "Automatically locks onto targets",
	Default = true,
	Callback = function(p35)
    t1.value60 = p35
    t1.value62 = nil
end
})))
v35:Dropdown({
	Title = "Lock Part",
	Desc = "Select the part to aim at",
	Values = { "Random" },
	Default = "Random",
	Callback = function(p36)
    t1.value28 = p36
end
})
local Slider = v35.Slider
local t28 = {
	Min = 20,
	Max = 800,
	Default = t1.value61
}
v33("FOVRadius", (Slider(v35, {
	Title = "FOV Radius",
	Desc = "Adjust the Dodecagon FOV size",
	Step = 1,
	Value = t28,
	Callback = function(p37)
    t1.value61 = tonumber(p37) or 120
end
})))
v35:Input({
	Title = "Safe Friends",
	Desc = "Enter names to ignore (space separated)",
	Value = "",
	InputIcon = "shield-check",
	Type = "Input",
	Placeholder = "Enter player names...",
	Callback = function(p38)
    t1.value54 = {}
    for v417 in string.gmatch(p38, "%S+") do

        table.insert(t1.value54, v417)
    end
    for __, player in ipairs(t1.value1:GetPlayers()) do
        if t1.value71[player] and (t1.value71[player].drawings and t1.value71[player].drawings[1]) then
            local v420 = t1.value71[player].drawings[1]
            local v421 = t1.value57(player.Name) and Color3.fromRGB(0, 255, 255)

            if not v421 then
                v421 = Color3.fromRGB(255, 255, 255)
            end

            v420.Color = v421
        end
    end
end
})
v35:Divider()
v35:Section({
	Title = "VEHICLE SYSTEM"
})
v35:Button({
	Title = "Bring Vehicle",
	Desc = "Teleports your vehicle to you",
	Callback = function()
    pcall(function()
        local HumanoidRootPart = (t1.value10.Character or t1.value10.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
        local v737 = false
        local Vehicles = t1.value5:WaitForChild("Vehicles")
        local GetChildren = Vehicles.GetChildren
        for v742, v743 in pairs(GetChildren(Vehicles)) do

            if v743:IsA("Model") then
                local OwnerUserId = v743:GetAttribute("OwnerUserId")

                if OwnerUserId and OwnerUserId == t1.value10.UserId then
                    local cFrame = CFrame.new(math.random(-5, 5), 3, math.random(-15, -5))

                    if v743.PrimaryPart then
                        v743:SetPrimaryPartCFrame(HumanoidRootPart.CFrame * cFrame)
                    else
                        local BasePart = v743:FindFirstChildWhichIsA("BasePart")

                        if BasePart then
                            BasePart.CFrame = HumanoidRootPart.CFrame * cFrame
                        end
                    end

                    v737 = true
                end
            end
        end
        if t1.value119 then
            local value119 = t1.value119
            local v748 = v737 and "Vehicle Brought!"

            if not v748 then
                v748 = "Vehicle Not Found"
            end

            value119:Notify({
					Title = v748,
					Duration = 2
				})
        end
    end)
end
})
local v38 = v34("VEHICLE", "car")

v38:Section({
	Title = "VEHICLE CONTROLS"
})
v38:Button({
	Title = "Explode Occupied Vehicle",
	Desc = "Explode current vehicle",
	Callback = function()
    pcall(function()
        local _require = require
        local Modules3 = t1.value3:FindFirstChild("Modules")

        if Modules3 then
            Modules3 = t1.value3.Modules.Game.VehicleSystem and t1.value3.Modules.Game.VehicleSystem.Vehicle
        end

        local v751 = _require(Modules3)
        local _require2 = require
        local Modules4 = t1.value3:FindFirstChild("Modules")

        if Modules4 then
            Modules4 = t1.value3.Modules.Core and t1.value3.Modules.Core.Net
        end

        local v754 = _require2(Modules4)

        if v751 and v754 then
            local v755 = v751.get_current_vehicle()

            if v755 then
                local model = v755.model

                if model then
                    v754.send("explode_vehicle", model)

                    if t1.value119 then
                        t1.value119:Notify({
								Title = "Vehicle Exploded!",
								Duration = 2
							})

                        return
                    end
                end
            elseif t1.value119 then
                t1.value119:Notify({
						Title = "No vehicle occupied",
						Duration = 2
					})
            end
        end
    end)
end
})
local v39 = v34("WEAPON", "layers")

v39:Section({
	Title = "GUN MODS"
})
t1.value30().FireRateValue = 1000
t1.value30().AccuracyValue = 1
t1.value30().RecoilValue = 0
t1.value30().Durability = 999999999
t1.value30().Auto = true
t1.value30().automatic = true
t1.value30().AutoValue = true
t1.value30().GunModsAutoApply = false
function t1.value121(p39)
    if not p39 or not p39:IsA("Tool") then
        return false
    end

    if t1.value21 and t1.value21:FindFirstChild(p39.Name) then
        return true
    end

    local reload_time = p39:GetAttribute("reload_time")

    if not reload_time then
        reload_time = p39:GetAttribute("AmmoType") or p39:GetAttribute("fire_rate") ~= nil
    end

    return reload_time
end
t1.value2.Heartbeat:Connect(function()
    if not t1.value30().GunModsAutoApply then
        return
    end
    local Character = t1.value10.Character
    if not Character then
        return
    end
    local Backpack = t1.value10:FindFirstChild("Backpack")
    for v429, v430 in ipairs(Character:GetChildren()) do

        local v431 = v430

        if v431:IsA("Tool") and t1.value121(v431) then
            pcall(function()
                local v757 = v431

                if not v757 or not t1.value121(v757) then
                    return
                end

                pcall(function()
                    v757:SetAttribute("fire_rate", t1.value30().FireRateValue)
                    v757:SetAttribute("accuracy", t1.value30().AccuracyValue)
                    v757:SetAttribute("Recoil", t1.value30().RecoilValue)
                    v757:SetAttribute("Durability", t1.value30().Durability)
                    v757:SetAttribute("automatic", t1.value30().AutoValue)
                    v757:SetAttribute("reload_time", 0)
                    v757:SetAttribute("range", 1e999)
                end)
            end)
        end
    end
    if Backpack then
        local GetChildren = Backpack.GetChildren

        for __, v in ipairs(GetChildren(Backpack)) do
            local v435 = v

            if v435:IsA("Tool") and t1.value121(v435) then
                pcall(function()
                    local v758 = v435

                    if not v758 or not t1.value121(v758) then
                        return
                    end

                    pcall(function()
                        v758:SetAttribute("fire_rate", t1.value30().FireRateValue)
                        v758:SetAttribute("accuracy", t1.value30().AccuracyValue)
                        v758:SetAttribute("Recoil", t1.value30().RecoilValue)
                        v758:SetAttribute("Durability", t1.value30().Durability)
                        v758:SetAttribute("automatic", t1.value30().AutoValue)
                        v758:SetAttribute("reload_time", 0)
                        v758:SetAttribute("range", 1e999)
                    end)
                end)
            end
        end
    end
end)

local t29 = {
	Min = 0,
	Max = 10,
	Default = 0
}
v39:Slider({
	Title = "Recoil",
	Step = 0.1,
	Value = t29,
	Callback = function(p40)
    t1.value30().RecoilValue = p40
end
})
local Slider2 = v39.Slider
local t30 = {
	Min = 100,
	Max = 3000,
	Default = 1000
}
Slider2(v39, {
	Title = "Fire Rate",
	Step = 100,
	Value = t30,
	Callback = function(p41)
    t1.value30().FireRateValue = p41
end
})
local Slider3 = v39.Slider
local t31 = {
	Min = 0,
	Max = 1,
	Default = 1
}
Slider3(v39, {
	Title = "Accuracy",
	Step = 0.01,
	Value = t31,
	Callback = function(p42)
    t1.value30().AccuracyValue = p42
end
})
v39:Toggle({
	Title = "Auto Mod Gun",
	Desc = "Apply mods to all guns automatically",
	Icon = "check",
	Type = "Checkbox",
	Value = false,
	Callback = function(p43)
    t1.value30().automatic = p43
    t1.value30().GunModsAutoApply = p43

    if p43 then
        p43 = t1.value119
    end

    if p43 then
        t1.value119:Notify({
				Title = "Auto Mod Enabled",
				Duration = 2
			})
    end
end
})
v39:Button({
	Title = "Apply Now",
	Desc = "Apply mods to current weapons",
	Callback = function()
    local n4 = 0
    local Character = t1.value10.Character
    local Backpack = t1.value10:FindFirstChild("Backpack")

    if Character then
        local GetChildren = Character.GetChildren

        for __, v in ipairs(GetChildren(Character)) do
            if v:IsA("Tool") and t1.value121(v) then
                if not (not v or not t1.value121(v)) then
                    pcall(function()
                        v:SetAttribute("fire_rate", t1.value30().FireRateValue)
                        v:SetAttribute("accuracy", t1.value30().AccuracyValue)
                        v:SetAttribute("Recoil", t1.value30().RecoilValue)
                        v:SetAttribute("Durability", t1.value30().Durability)
                        v:SetAttribute("automatic", t1.value30().AutoValue)
                        v:SetAttribute("reload_time", 0)
                        v:SetAttribute("range", 1e999)
                    end)
                end

                n4 += 1
            end
        end
    end

    if Backpack then
        for __, child in ipairs(Backpack:GetChildren()) do
            if child:IsA("Tool") and t1.value121(child) then
                if not (not child or not t1.value121(child)) then
                    pcall(function()
                        child:SetAttribute("fire_rate", t1.value30().FireRateValue)
                        child:SetAttribute("accuracy", t1.value30().AccuracyValue)
                        child:SetAttribute("Recoil", t1.value30().RecoilValue)
                        child:SetAttribute("Durability", t1.value30().Durability)
                        child:SetAttribute("automatic", t1.value30().AutoValue)
                        child:SetAttribute("reload_time", 0)
                        child:SetAttribute("range", 1e999)
                    end)
                end

                n4 += 1
            end
        end
    end

    if t1.value119 then
        local value119 = t1.value119
        local Notify = value119.Notify
        local v450 = "Modified " .. n4 .. " guns!"

        Notify(value119, {
				Title = "Applied",
				Content = v450,
				Duration = 2
			})
    end
end
})
v39:Section({
	Title = "MELEE AURA"
})
t1.value122 = {}
if t1.value20 then
    for __, child in ipairs(t1.value20:GetChildren()) do
        table.insert(t1.value122, child.Name)
    end
end
v39:Toggle({
	Title = "Melee Aura",
	Desc = "Auto melee attack nearby players",
	Default = false,
	Callback = function(p44)
    t1.value50 = p44
end
})
v33("AutoAttack_Enabled", (v39:Toggle({
	Title = "Auto Attack",
	Desc = "Auto attack nearby players",
	Default = false,
	Callback = function(p45)
    t1.value26 = p45
end
})))
local v47 = v34("ESP", "eye")

v47:Section({
	Title = "VISUALS"
})
v33("ItemESP", (v47:Toggle({
	Title = "Dropped Items ESP",
	Desc = "See items on the ground with icons",
	Default = true,
	Callback = function(p46)
    t1.value52 = p46

    if not p46 then
        for __, v in pairs(t1.value24) do
            if v and v.Parent then
                v:Destroy()
            end
        end

        t1.value24 = {}
    end
end
})))
v33("ESPBox", (v47:Toggle({
	Title = "ESP Box",
	Desc = "Show box around players",
	Default = false,
	Callback = function(p47)
    t1.value29 = p47
end
})))
v33("NameESP", (v47:Toggle({
	Title = "Name ESP",
	Desc = "Show player names",
	Default = false,
	Callback = function(p48)
    t1.value72 = p48
end
})))
v33("HealthESP", (v47:Toggle({
	Title = "Health ESP",
	Desc = "Show health bar",
	Default = false,
	Callback = function(p49)
    t1.value74 = p49
end
})))
v33("DistanceESP", (v47:Toggle({
	Title = "Distance ESP",
	Desc = "Show distance in meters",
	Default = false,
	Callback = function(p50)
    t1.value73 = p50
end
})))
v33("HighlightESP", (v47:Toggle({
	Title = "Highlight ESP",
	Desc = "Glow around players",
	Default = false,
	Callback = function(p51)
    t1.value27 = p51

    for __, player in ipairs(t1.value1:GetPlayers()) do
        t1.value118(player)
    end
end
})))
v33("InventoryESP", (v47:Toggle({
	Title = "Inventory ESP",
	Desc = "Show items players are holding",
	Default = true,
	Callback = function(p52)
    t1.value104 = p52

    if p52 then
        updateAllPlayers()

        return
    end

    for __, v in pairs(t1.value105) do
        if v then
            v.Enabled = false
        end
    end
end
})))
t1.value123 = false
t1.value124 = {}
t1.value125 = nil
t1.value125 = {
	{
		"Head",
		"UpperTorso"
	},
	{
		"UpperTorso",
		"LowerTorso"
	},
	{
		"UpperTorso",
		"LeftUpperArm"
	},
	{
		"LeftUpperArm",
		"LeftLowerArm"
	},
	{
		"LeftLowerArm",
		"LeftHand"
	},
	{
		"UpperTorso",
		"RightUpperArm"
	},
	{
		"RightUpperArm",
		"RightLowerArm"
	},
	{
		"RightLowerArm",
		"RightHand"
	},
	{
		"LowerTorso",
		"LeftUpperLeg"
	},
	{
		"LeftUpperLeg",
		"LeftLowerLeg"
	},
	{
		"LeftLowerLeg",
		"LeftFoot"
	},
	{
		"LowerTorso",
		"RightUpperLeg"
	},
	{
		"RightUpperLeg",
		"RightLowerLeg"
	},
	{
		"RightLowerLeg",
		"RightFoot"
	}
}
function t1.value126(p53)
    if t1.value124[p53] then
        return
    end

    local t32 = {}
    local connection = t1.value2.RenderStepped:Connect(function()
        if not t1.value123 or (not p53 or not p53.Character) then
            for __, v in pairs(t32) do
                if v then
                    v.Visible = false
                end
            end

            return
        end

        local Character = p53.Character
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        local v764 = not HumanoidRootPart

        if not v764 then
            v764 = not Humanoid

            if not v764 then
                v764 = Humanoid.Health <= 0
            end
        end

        if v764 then
            for __, v in pairs(t32) do
                if v then
                    v.Visible = false
                end
            end

            return
        end

        local v767 = t1.value62 == p53

        for i, v in ipairs(t1.value125) do
            local v770 = i
            local v771 = Character:FindFirstChild(v[1])
            local v772 = Character:FindFirstChild(v[2])

            if not t32[v770] then
                pcall(function()
                    t32[v770] = Drawing.new("Line")
                    t32[v770].Thickness = 1.8
                    t32[v770].Transparency = 0.85
                end)
            end

            local v773 = t32[v770]

            if v773 then
                local v774 = v767

                if v767 then
                    v774 = Color3.fromRGB(0, 170, 255)
                end

                v773.Color = v774 or Color3.fromRGB(255, 255, 255)

                if v771 and v772 then
                    local v775, v776 = t1.value11:WorldToViewportPoint(v771.Position)
                    local v777, v778 = t1.value11:WorldToViewportPoint(v772.Position)

                    if v776 then
                        if v778 then
                            v778 = v775.Z > 0 and v777.Z > 0
                        end

                        v776 = v778
                    end

                    if v776 then
                        v773.From = Vector2.new(v775.X, v775.Y)
                        v773.To = Vector2.new(v777.X, v777.Y)
                        v773.Visible = true
                    else
                        v773.Visible = false
                    end
                else
                    v773.Visible = false
                end
            end
        end
    end)

    t1.value124[p53] = {
		conn = connection,
		lines = t32
	}
end
function t1.value127(p54)
    if t1.value124[p54] then
        for __, v in pairs(t1.value124[p54].lines) do
            local v472 = v

            pcall(function()
                if v472 and v472.Remove then
                    v472:Remove()
                end
            end)
        end

        pcall(function()
            t1.value124[p54].conn:Disconnect()
        end)
        t1.value124[p54] = nil
    end
end
v33("SkeletonESP", (v47:Toggle({
	Title = "Skeleton ESP",
	Desc = "Show player skeletons (changes color when locked)",
	Default = false,
	Callback = function(p55)
    t1.value123 = p55

    if p55 then
        for __, player in ipairs(t1.value1:GetPlayers()) do
            if player ~= t1.value10 then
                t1.value126(player)
            end
        end

        return
    end

    for __, player in ipairs(t1.value1:GetPlayers()) do
        t1.value127(player)
    end
end
})))
t1.value1.PlayerAdded:Connect(function(player)
    if player ~= t1.value10 then
        player.CharacterAdded:Connect(function()
            task.wait(0.1)

            if t1.value123 then
                t1.value126(player)
            end
        end)

        if t1.value123 then
            t1.value126(player)
        end
    end
end)
t1.value1.PlayerRemoving:Connect(t1.value127)

local v48 = v34("CHARACTER", "user")

v48:Section({
	Title = "MOVEMENT"
})
v33("WalkSpeed", (v48:Toggle({
	Title = "Walk Speed",
	Desc = "Increase movement speed",
	Default = false,
	Callback = function(p56)
    t1.value75 = p56
end
})))
local Slider4 = v48.Slider
local t33 = {
	Min = 1,
	Max = 5,
	Default = 2
}
v33("SpeedMultiplier", (Slider4(v48, {
	Title = "Speed Multiplier",
	Desc = "Speed multiplier",
	Step = 0.5,
	Value = t33,
	Callback = function(p57)
    t1.value76 = p57 * 0.05
end
})))
v33("FlyJump", (v48:Toggle({
	Title = "Fly Jump",
	Desc = "Press space to fly",
	Default = false,
	Callback = function(p58)
    if not not p58 then
    end
end
})))
local Slider5 = v48.Slider
local t34 = {
	Min = 10,
	Max = 150,
	Default = 35
}
v33("FloatPower", (Slider5(v48, {
	Title = "Float Power",
	Desc = "Fly lift power",
	Step = 1,
	Value = t34,
	Callback = function(p59)
    t1.value79 = p59
end
})))
v33("AntiLock", (v48:Toggle({
	Title = "Anti Lock",
	Desc = "Rotate character quickly to avoid locks",
	Default = false,
	Callback = function(p60)
    t1.value30().Sky = p60

    if p60 then
        t1.value30().SkyAmount = 1500
    end
end
})))
v33("AutoSprint", (v48:Toggle({
	Title = "Infinite Stamina",
	Desc = "Stamina bar never decreases",
	Default = false,
	Callback = function(p61)
    t1.value46 = p61

    if p61 then
        pcall(function()
            local value12_3 = t1.value12
            local Modules5 = t1.value3:FindFirstChild("Modules")

            if Modules5 then
                Modules5 = t1.value3.Modules.Game and t1.value3.Modules.Game.Sprint
            end

            local v781 = value12_3(Modules5)

            if v781 then
                local consume_stamina = v781.consume_stamina
                local sprint_bar = getupvalue(consume_stamina, 2).sprint_bar

                if sprint_bar then
                    local update = sprint_bar.update

                    function sprint_bar.update(...)
                        return update(function()
                            return 1
                        end)
                    end

                    t1.value30().OriginalSprintUpdate = update
                    t1.value30().AutoSprintLoop = task.spawn(function()
                        while t1.value46 do
                            pcall(function()
                                if t1.value48 then
                                    t1.value48.event = (t1.value48.event or 0) + 1

                                    if t1.value17 then
                                        t1.value17:FireServer(t1.value48.event, "set_sprinting_1", true)
                                    end

                                    task.wait(0.5)
                                    t1.value48.event = (t1.value48.event or 0) + 1

                                    if t1.value17 then
                                        t1.value17:FireServer(t1.value48.event, "set_sprinting_1", false)
                                    end
                                end

                                task.wait(0.1)
                            end)
                        end

                        pcall(function()
                            if t1.value48 and t1.value17 then
                                t1.value48.event = (t1.value48.event or 0) + 1
                                t1.value17:FireServer(t1.value48.event, "set_sprinting_1", false)
                            end
                        end)
                    end)
                end
            end
        end)

        return
    end

    if t1.value30().AutoSprintLoop then
        task.cancel(t1.value30().AutoSprintLoop)
        t1.value30().AutoSprintLoop = nil
    end

    pcall(function()
        if t1.value48 and t1.value17 then
            t1.value48.event = (t1.value48.event or 0) + 1
            t1.value17:FireServer(t1.value48.event, "set_sprinting_1", false)
        end
    end)
    pcall(function()
        local v785 = t1.value12(t1.value3:FindFirstChild("Modules") and (t1.value3.Modules.Game and t1.value3.Modules.Game.Sprint))

        if v785 then
            local consume_stamina = v785.consume_stamina
            local sprint_bar = getupvalue(consume_stamina, 2).sprint_bar

            if sprint_bar and t1.value30().OriginalSprintUpdate then
                sprint_bar.update = t1.value30().OriginalSprintUpdate
                t1.value30().OriginalSprintUpdate = nil
            end
        end
    end)
end
})))
v33("AntiKill", (v48:Toggle({
	Title = "Anti Kill",
	Desc = "Teleport underground when downed",
	Default = false,
	Callback = function(p62)
    t1.value25 = p62
end
})))
v48:Divider()
v48:Section({
	Title = "PROTECTION & ATTRIBUTES"
})
v33("PickupItems", (v48:Toggle({
	Title = "Item Magnet",
	Desc = "Auto collect items on the ground",
	Default = false,
	Callback = function(p63)
    t1.value39 = p63
end
})))
v33("AntiRagdoll", (v48:Toggle({
	Title = "Anti Ragdoll",
	Desc = "Prevent character from ragdolling",
	Default = false,
	Callback = function(p64)
    if not p64 then
        return
    end

    pcall(function()
        local u788
        local v790, v791, v792 = ipairs(getgc(true))
        local g794
        local v793
        repeat
            v792, v793 = v790(v791, v792)

            if not v792 then
                g794 = true
            end

            if g794 then
                break
            end

            local v795 = typeof(v793) == "table"

            if v795 then
                v795 = rawget(v793, "event") and rawget(v793, "func")
            end
        until v795
        if not g794 then
            u788 = v793
        end
        if not u788 then
            return
        end
        spawn(function()
            while p64 do
                u788.event = (u788.event or 0) + 1

                if t1.value17 then
                    pcall(function()
                        t1.value17:FireServer(u788.event, "end_ragdoll_early")
                    end)
                end

                task.wait(0.3)

                if not p64 then
                    return
                end

                u788.event = (u788.event or 0) + 1

                if t1.value17 then
                    pcall(function()
                        t1.value17:FireServer(u788.event, "clear_ragdoll")
                    end)
                end

                task.wait(0.3)
            end
        end)
    end)
end
})))
local v53 = t1.value31().HideName or false
v33("HideName", (v48:Toggle({
	Title = "Hide Name",
	Desc = "Hide your name",
	Default = v53,
	Callback = function(p65)
    t1.value31().HideName = p65
    t1.value37()

    local Character = t1.value10.Character

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart and HumanoidRootPart:FindFirstChild("CharacterBillboardGui") then
            HumanoidRootPart.CharacterBillboardGui.Enabled = not p65
        end
    end
end
})))
v33("AutoRespawn", (v48:Toggle({
	Title = "Auto Respawn",
	Desc = "Click respawn button when dead",
	Default = false,
	Callback = function(p66)
    if not p66 then
        return
    end

    pcall(function()
        local u796
        local v798, v799, v800 = ipairs(getgc(true))
        local g802
        local v801
        repeat
            v800, v801 = v798(v799, v800)

            if not v800 then
                g802 = true
            end

            if g802 then
                break
            end

            local v803 = typeof(v801) == "table"

            if v803 then
                v803 = rawget(v801, "event") and rawget(v801, "func")
            end
        until v803
        if not g802 then
            u796 = v801
        end
        if not u796 then
            return
        end
        spawn(function()
            while p66 do
                local Character = t1.value10.Character
                local v832 = Character and Character:FindFirstChildOfClass("Humanoid")

                if v832 and v832.Health <= 0 then
                    task.wait(6)

                    if p66 then
                        u796.event = (u796.event or 0) + 1

                        if t1.value17 then
                            pcall(function()
                                t1.value17:FireServer(u796.event, "death_screen_request_respawn")
                            end)
                        end
                    end
                end

                task.wait(0.5)
            end
        end)
    end)
end
})))
v48:Divider()
v48:Section({
	Title = "SNAP UNDER MAP"
})
v33("SnapUnderMap", (v48:Toggle({
	Title = "Snap Under Map",
	Desc = "Teleport under the map to escape",
	Default = false,
	Callback = function(p67)
    t1.value81 = p67

    if t1.value81 then
        t1.value85 = t1.value85 + 1

        if t1.value85 < 2 then
            return
        end

        local v496 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

        t1.value84 = v496 and v496.Position.Y or nil
        t1.value80 = true
        t1.value101()

        return
    end

    t1.value80 = false
    t1.value84 = nil
end
})))
local t35 = {
	Min = 1,
	Max = 150,
	Default = 15
}
v33("SnapHeight", (v48:Slider({
	Title = "Snap Depth",
	Desc = "Distance under the map (1-150)",
	Step = 1,
	Value = t35,
	Callback = function(p68)
    t1.value83 = p68

    if t1.value80 then
        local v498 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

        if v498 and t1.value84 then
            local vector3 = Vector3.new(v498.Position.X, t1.value84 - t1.value83, v498.Position.Z)

            v498.CFrame = CFrame.new(vector3)

            local __ = vector3.Y
        end
    end
end
})))
local v55 = v34("PLAYER", "person-standing")

v55:Section({
	Title = "AUTO FINISH"
})
v33("AutoFinnish", (v55:Toggle({
	Title = "Auto Finish",
	Desc = "Automatically finish downed players",
	Default = false,
	Callback = function(p69)
    t1.value86 = p69

    if p69 then
        t1.value113()
    end
end
})))
v55:Divider()
v55:Section({
	Title = "AUTO HEAL"
})
t1.value128 = false
t1.value129 = 75
t1.value130 = 0
t1.value131 = false
function t1.value132()
    local Character = t1.value10.Character

    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        return
    end

    local GetPlayingAnimationTracks = Animator.GetPlayingAnimationTracks

    for __, v in pairs(GetPlayingAnimationTracks(Animator)) do
        v:Stop(0)
    end
end
function t1.value133()
    local Backpack = t1.value10:FindFirstChild("Backpack")

    if Backpack then
        local GetChildren = Backpack.GetChildren

        for __, v in pairs(GetChildren(Backpack)) do
            if v:IsA("Tool") and v:GetAttribute("HealthRestoreAmount") then
                return v
            end
        end
    end

    local Character = t1.value10.Character

    if Character then
        for __, child in pairs(Character:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("HealthRestoreAmount") then
                return child
            end
        end
    end

    return nil
end
function t1.value134(p70)
    if t1.value131 then
        return
    end

    t1.value130 = tick()

    local Character = t1.value10.Character

    if not Character then
        return
    end

    local Tool = Character:FindFirstChildOfClass("Tool")

    p70.Parent = Character
    task.wait()
    p70:Activate()
    t1.value132()
    task.wait(0.25)

    if Tool and Character == Tool.Parent then
        Tool.Parent = t1.value10.Backpack
    end
end
v33("AutoHeal", (v55:Toggle({
	Title = "Auto Use Health Item",
	Desc = "Use healing item when health is low",
	Default = false,
	Callback = function(p71)
    t1.value128 = p71
end
})))
local t36 = {
	Min = 10,
	Max = 99,
	Default = 75
}
v33("HPThreshold", (v55:Slider({
	Title = "HP Threshold (%)",
	Desc = "Health percentage to start healing",
	Step = 1,
	Value = t36,
	Callback = function(p72)
    t1.value129 = p72
end
})))
spawn(function()
    while true do
        task.wait(0.1)

        if t1.value128 then
            local Character = t1.value10.Character

            if Character then
                local Humanoid = Character:FindFirstChild("Humanoid")

                if Humanoid and Humanoid.Health < t1.value129 then
                    local v522 = t1.value133()

                    if v522 then
                        t1.value134(v522)
                    end
                end
            end
        end
    end
end)

local v57 = v34("BUY", "landmark")

v57:Section({
	Title = "BOOST FPS"
})
v57:Button({
	Title = "Boost FPS",
	Desc = "Disable lighting effects to increase FPS",
	Callback = function()
    pcall(function()
        local _ipairs = ipairs
        for __, v806 in _ipairs(t1.value8:GetChildren()) do
            local v807 = v806:IsA("Sky")

            if not v807 then
                v807 = v806:IsA("Atmosphere")

                if not v807 then
                    v807 = v806:IsA("BloomEffect")

                    if not v807 then
                        v807 = v806:IsA("SunRaysEffect")

                        if not v807 then
                            v807 = v806:IsA("ColorCorrectionEffect") or v806:IsA("DepthOfFieldEffect")
                        end
                    end
                end
            end

            if v807 then
                v806:Destroy()
            end
        end
        t1.value8.GlobalShadows = false
        t1.value8.Brightness = 0
        t1.value8.FogEnd = 9000000000
        t1.value8.EnvironmentDiffuseScale = 0
        t1.value8.EnvironmentSpecularScale = 0
        local Terrain = t1.value5:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end
        for __, descendant in ipairs(t1.value5:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Material = Enum.Material.Plastic
                descendant.Reflectance = 0
                descendant.CastShadow = false
                descendant.Color = Color3.fromRGB(100, 110, 130)
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Transparency = 1
            else
                local v811 = descendant:IsA("ParticleEmitter")

                if not v811 then
                    v811 = descendant:IsA("Trail") or descendant:IsA("Beam")
                end

                if v811 then
                    descendant.Enabled = false
                end
            end
        end
        if t1.value119 then
            t1.value119:Notify({
					Title = "Boost FPS ON",
					Duration = 2
				})
        end
    end)
end
})
local v58 = v34("MISC", "warehouse")

v58:Section({
	Title = "SERVER UTILITIES"
})
v58:Button({
	Title = "Copy Server ID",
	Desc = "Copy JobID to clipboard",
	Callback = function()
    local str = tostring(game.JobId)

    if setclipboard then
        setclipboard(str)

        if t1.value119 then
            t1.value119:Notify({
					Title = "Copied JobID!",
					Description = str,
					Duration = 3
				})

            return
        end
    elseif t1.value119 then
        t1.value119:Notify({
				Title = "Not Supported",
				Description = "Executor does not support setclipboard",
				Duration = 3
			})
    end
end
})
v58:Input({
	Title = "Server Hop by ID",
	Desc = "Enter JobID to server hop",
	Value = "",
	InputIcon = "send",
	Type = "Input",
	Placeholder = "Paste Server ID here...",
	Callback = function(p73)
    if not p73 or p73 == "" then
        return
    end

    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, p73, t1.value10)
    end)
end
})
v58:Button({
	Title = "Server Rejoin",
	Desc = "Rejoin the same server",
	Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, t1.value10)
end
})
v58:Button({
	Title = "Server Hop",
	Desc = "Find a new server",
	Callback = function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local ok, result = pcall(function()
        local v812 = HttpService
        local t37 = { game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100") }

        return v812:JSONDecode(v2(t37))
    end)
    if ok then
        ok = result and result.data
    end
    if ok then
        local t38 = {}
        for v532, v533 in pairs(result.data) do

            if v533.playing < v533.maxPlayers and v533.id ~= game.JobId then
                table.insert(t38, v533)
            end
        end
        if #t38 > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, t38[math.random(1, #t38)], t1.value10)
        end
    end
end
})
v58:Divider()
v58:Button({
	Title = "Claim All Quests",
	Desc = "Claim all quests automatically",
	Callback = function()
    spawn(function()
        pcall(function()
            local u833
            local v835, v836, v837 = ipairs(getgc(true))
            local g839
            local v838
            repeat
                v837, v838 = v835(v836, v837)

                if not v837 then
                    g839 = true
                end

                if g839 then
                    break
                end

                local v840 = typeof(v838) == "table"

                if v840 then
                    v840 = rawget(v838, "event") and rawget(v838, "func")
                end
            until v840
            if not g839 then
                u833 = v838
            end
            if not u833 then
                return
            end
            local QuestsScrollingFrame = t1.value10:WaitForChild("PlayerGui"):WaitForChild("Quests"):WaitForChild("QuestsHolder"):WaitForChild("QuestsScrollingFrame")
            for __, child in ipairs(QuestsScrollingFrame:GetChildren()) do
                local v844 = child

                if v844:IsA("Frame") or (v844:IsA("TextButton") or v844:IsA("ImageButton")) then
                    u833.func = (u833.func or 0) + 1

                    if t1.value18 then
                        pcall(function()
                            t1.value18:InvokeServer(u833.func, "claim_quest", v844.Name)
                        end)
                    end

                    task.wait(0.2)
                end
            end
        end)
    end)
end
})
v58:Divider()
local v59 = t1.value31().ItemDroppedGraber or false
v33("ItemDroppedGraber", (v58:Toggle({
	Title = "Item Drop Grabber",
	Desc = "Automatically collect items in a certain radius",
	Default = v59,
	Callback = function(p74)
    t1.value31().ItemDroppedGraber = p74
    t1.value37()

    if p74 then
        spawn(function()
            (function(p75)
                while t1.value31().ItemDroppedGraber do
                    pcall(function()
                        local Character = t1.value10.Character

                        if not Character or not Character.Parent then
                            return
                        end

                        local Position = Character:GetPivot().Position
                        local v855 = workspace:FindFirstChild("DroppedItems") or (workspace:FindFirstChild("Items") or workspace)

                        for __, child in ipairs(v855:GetChildren()) do
                            if child:IsA("Model") and (child:GetPivot().Position - Position).Magnitude <= p75 then
                                pcall(function()
                                    local _require = require
                                    local Modules6 = t1.value3:FindFirstChild("Modules")

                                    if Modules6 then
                                        Modules6 = t1.value3.Modules.Core and t1.value3.Modules.Core.Net
                                    end

                                    local v860 = _require(Modules6)

                                    if v860 then
                                        v860.send("pickup_item", child)
                                    end
                                end)
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)(t1.value31().GrabRadius or 45)
        end)
    end
end
})))
local v60 = t1.value31().GrabRadius or 45
local Slider6 = v58.Slider
local t39 = {
	Min = 10,
	Max = 100,
	Default = v60
}
v33("GrabRadius", (Slider6(v58, {
	Title = "Grab Radius (meters)",
	Desc = "Item collection radius",
	Step = 1,
	Value = t39,
	Callback = function(p76)
    t1.value31().GrabRadius = p76
    t1.value37()
end
})))
v58:Divider()
v58:Section({
	Title = "CONFIG MANAGEMENT"
})
local v63 = v34("UTILITIES", "users")

t1.value135 = nil
t1.value136 = false
t1.value137 = nil
t1.value138 = nil
t1.value139 = nil
t1.value140 = nil
function t1.value141()
    local t40 = {}

    for __, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value10 then
            table.insert(t40, player.Name)
        end
    end

    return t40
end
function t1.value142(p77)
    local v540 = p77

    if p77 then
        v540 = p77.Character and p77.Character:FindFirstChild("HumanoidRootPart")
    end

    if v540 then
        t1.value11.CameraSubject = p77.Character:FindFirstChild("Humanoid")
        t1.value135 = p77
    end
end
function t1.value143()
    if t1.value10.Character and t1.value10.Character:FindFirstChild("Humanoid") then
        t1.value11.CameraSubject = t1.value10.Character:FindFirstChild("Humanoid")
    end

    t1.value135 = nil
end
v63:Section({
	Title = "SPECTATE"
})
v63:Toggle({
	Title = "Spectate Players",
	Desc = "View the game from another player",
	Default = false,
	Callback = function(p78)
    t1.value136 = p78

    if p78 then
        if t1.value135 then
            t1.value142(t1.value135)

            return
        end
    else
        t1.value143()
    end
end
})
local v64 = t1.value141()
t1.value144 = v63:Dropdown({
	Title = "Spectate Player",
	Desc = "Choose a player to spectate",
	Values = v64,
	Value = nil,
	Callback = function(p79)
    local p79_2 = t1.value1:FindFirstChild(p79)

    if p79_2 and t1.value136 then
        t1.value142(p79_2)
    end
end
})
v63:Button({
	Title = "Refresh Lists",
	Desc = "Refresh the spectate and friends lists",
	Callback = function()
    if t1.value144 and t1.value144.Refresh then
        t1.value144:Refresh(t1.value141())
    end

    if friendListDropdown and friendListDropdown.Refresh then
        local _friendListDropdown = friendListDropdown
        local t41 = { t1.value141() }

        _friendListDropdown:Refresh(v2(t41))
    end
end
})
v63:Divider()
v63:Section({
	Title = "FRIENDS"
})
local Dropdown = v63.Dropdown
local v66 = t1.value141()
Dropdown(v63, {
	Title = "Friend List",
	Desc = "Ignore selected players in Aimbot",
	Values = v66,
	Multi = true,
	AllowNone = true,
	Value = {},
	Callback = function(p80)
    t1.value54 = {}

    for k, v in pairs(p80) do
        if v then
            table.insert(t1.value54, k)
        end
    end
end
})
v63:Divider()
v63:Section({
	Title = "MISC FEATURES"
})
t1.value145 = false
t1.value146 = 0
function t1.value147()
    local value12_4 = t1.value12
    local Modules7 = t1.value3:FindFirstChild("Modules")

    if Modules7 then
        Modules7 = t1.value3.Modules.Game and t1.value3.Modules.Game.Crates
    end

    return value12_4(Modules7)
end
local function v67(p81)
    t1.value145 = p81 == true
    t1.value146 = t1.value146 + 1

    local value146 = t1.value146
    local v553 = t1.value147()

    if not t1.value145 then
        pcall(function()
            local v814 = v553

            if v814 then
                v814 = v553.skipping and v553.skipping.set
            end

            if v814 then
                v553.skipping.set(false)
            end
        end)

        return
    end

    task.spawn(function()
        while t1.value145 and value146 == t1.value146 do
            task.wait(0.05)
            pcall(function()
                if v553 and (v553.class and v553.class.objects) then
                    for __, v in pairs(v553.class.objects) do
                        if v.states and (v.states.open and v.states.open.set) then
                            v.states.open.set(true)
                        end

                        if v553.skipping and v553.skipping.set then
                            v553.skipping.set(true)
                        end
                    end
                end

                if v553 and (v553.skip_spin and not v553.spinning.get()) then
                    v553.skip_spin()
                end
            end)
        end
    end)
end
v63:Toggle({
	Title = "Skip Animation",
	Desc = "Open crates faster",
	Default = false,
	Callback = function(p82)
    v67(p82)
end
})
function t1.value148()
    if t1.value137 then
        t1.value137:Destroy()
    end

    if t1.value138 then
        t1.value138:Disconnect()
    end

    if t1.value139 then
        t1.value139:Disconnect()
    end

    if t1.value140 then
        t1.value140:Disconnect()
    end
end
t1.value149 = nil
function t1.value149()
    local Character = t1.value10.Character

    if not Character then
        return
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local PositionY = HumanoidRootPart.Position.Y

    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, PositionY - 15, HumanoidRootPart.Position.Z)
    task.wait(0.2)
    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, PositionY, HumanoidRootPart.Position.Z)
end
function t1.value150()
    t1.value148()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SnapButtonGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = t1.value22()
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "SnapButton"
    TextButton.Position = UDim2.fromOffset(24, 135)
    TextButton.Size = UDim2.fromOffset(108, 42)
    TextButton.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    TextButton.BackgroundTransparency = 0.24
    TextButton.BorderSizePixel = 0
    TextButton.Text = "Snap\nReturn"
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 12
    TextButton.TextWrapped = true
    TextButton.Font = Enum.Font.GothamBold
    TextButton.AutoButtonColor = true
    TextButton.Active = true
    TextButton.ZIndex = 200
    TextButton.Parent = ScreenGui
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)
    local UIStroke = Instance.new("UIStroke", TextButton)
    UIStroke.Color = Color3.fromRGB(255, 55, 75)
    UIStroke.Thickness = 0.8
    UIStroke.Transparency = 0.25
    TextButton.MouseButton1Click:Connect(function()
        t1.value149()
    end)
    local u561 = false
    local u562
    local inputPosition
    local TextButtonPosition
    TextButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u561 = true
            inputPosition = input.Position
            TextButtonPosition = TextButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    u561 = false
                end
            end)
        end
    end)
    TextButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            u562 = input
        end
    end)
    t1.value4.InputChanged:Connect(function(input)
        if not u561 or input ~= u562 then
            return
        end

        local v818 = input.Position - inputPosition

        TextButton.Position = UDim2.new(TextButtonPosition.X.Scale, TextButtonPosition.X.Offset + v818.X, TextButtonPosition.Y.Scale, TextButtonPosition.Y.Offset + v818.Y)
    end)
end
v63:Toggle({
	Title = "Show Snap Button",
	Desc = "Show a draggable button to snap down and return",
	Default = false,
	Callback = function(p83)
    if p83 then
        t1.value150()

        return
    end

    t1.value148()
end
})
local v68 = v34("CONFIG", "settings"):Section({
	Title = "Config Management",
	Box = false,
	TextSize = 17,
	Opened = true
})
t1.value151 = v68:Code({
	Title = "",
	Code = "Loading config info..."
})
local function v69()
    local v566 = isfile(t1.value33)
    local t42 = {}
    local v568 = isfile(t1.value34)

    if v566 then
        table.insert(t42, "Config file: settings.json")
    else
        table.insert(t42, "No config file found")
    end

    if v568 then
        table.insert(t42, "UI state file: ui_state.json")
    else
        table.insert(t42, "No UI state file found")
    end

    if v566 or v568 then
        table.insert(t42, "\nLocation: " .. t1.value32)
    else
        table.insert(t42, "\nSet your settings then press 'Save Settings'")
    end

    t1.value151:SetCode(table.concat(t42, "\n"))
end
local Button = v68.Button
local color3_18 = Color3.fromHex("#00aaff")

Button(v68, {
	Title = "Save Settings",
	Desc = "Save current settings",
	Color = color3_18,
	Callback = function()
    t1.value35()
    t1.value37()
    v69()

    if t1.value119 then
        t1.value119:Notify({
				Title = "Saved!",
				Content = "Settings saved successfully",
				Duration = 2
			})
    end
end
})
local Button2 = v68.Button
local color3_19 = Color3.fromHex("#0077ff")

Button2(v68, {
	Title = "Load Settings",
	Desc = "Load saved settings",
	Color = color3_19,
	Callback = function()
    local v569 = t1.value36()
    local v570 = t1.value38()

    v69()

    if v569 or v570 then
        if t1.value119 then
            t1.value119:Notify({
					Title = "Loaded!",
					Content = "Settings loaded successfully",
					Duration = 2
				})

            return
        end
    elseif t1.value119 then
        t1.value119:Notify({
				Title = "No Settings",
				Content = "No saved settings found",
				Duration = 2
			})
    end
end
})
local color3_20 = Color3.fromHex("#00e5ff")

v68:Button({
	Title = "Delete Settings",
	Desc = "Delete all config files",
	Color = color3_20,
	Callback = function()
    if t1.value119 then
        local value119 = t1.value119
        local v572 = "Are you sure you want to delete all config files?\n\n" .. "File: " .. t1.value33 .. "\n" .. "File: " .. t1.value34 .. "\n\nThis cannot be undone!"
        local t43 = {
				Title = "Cancel",
				Variant = "Secondary",
				Callback = function()
        end
			}
        local Popup = value119.Popup
        local t44 = {
				Title = "Delete",
				Variant = "Primary",
				Callback = function()
            local n5 = 0

            if isfile(t1.value33) then
                pcall(function()
                    delfile(t1.value33)
                    n5 += 1
                end)
            end

            if isfile(t1.value34) then
                pcall(function()
                    delfile(t1.value34)
                    n5 += 1
                end)
            end

            t1.value31().PIGHUB_LOADED = nil

            if n5 > 0 then
                if t1.value119 then
                    local value119_2 = t1.value119
                    local v821 = "Deleted " .. n5 .. " file(s)"

                    value119_2:Notify({
								Title = "Deleted!",
								Content = v821,
								Duration = 3
							})
                end

                v69()

                if t1.value119 then
                    t1.value119:Notify({
								Title = "Reload",
								Content = "Restart the script to reset settings",
								Duration = 3
							})
                end
            elseif t1.value119 then
                t1.value119:Notify({
							Title = "No Files",
							Content = "No config files to delete",
							Duration = 2
						})
            end
        end
			}

        Popup(value119, {
				Title = "Confirm Delete",
				Content = v572,
				Icon = "alert-triangle",
				Buttons = {
					t43,
					t44
				}
			})
    end
end
})
v69()
t1.value152 = nil
function t1.value152(p84)
    if p84 and p84:IsA("Tool") then
        pcall(function()
            p84:SetAttribute("Locked", true)
        end)
    end
end
function t1.value153(p85)
    if not p85 then
        return
    end

    for __, child in ipairs(p85:GetChildren()) do
        t1.value152(child)
    end

    p85.ChildAdded:Connect(t1.value152)
end
function t1.value154()
    local Backpack = t1.value10:FindFirstChildOfClass("Backpack")

    if Backpack then
        t1.value153(Backpack)

        return
    end

    t1.value10.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            t1.value153(child)
        end
    end)
end
t1.value154()
t1.value10.CharacterAdded:Connect(function()
    task.wait(1)
    t1.value154()
end)
t1.value155 = nil
function t1.value155(p86)
    if not p86 then
        return
    end

    if p86:FindFirstChild("UnlocksAtText") then
        p86.UnlocksAtText.Visible = false
    end

    if p86:FindFirstChild("EmoteName") then
        p86.EmoteName.Visible = true
    end

    t1.value15.on_click(p86, function()
        local v823 = t1.value16.get_hum()

        if not v823 or v823.Health <= 0 then
            return
        end

        if t1.value13.current_emote_playing.get() == p86 then
            t1.value13.current_emote_playing.set(nil)
        else
            t1.value13.current_emote_playing.set(p86)
        end

        task.wait(0.12)
        t1.value13.enabled.set(false)
    end)
    t1.value13.current_emote_playing.hook(function(p87)
        if p86:FindFirstChild("EmoteEquipped") then
            p86.EmoteEquipped.Visible = p87 == p86
        end
    end)
end
function t1.value156()
    for __, v in pairs(t1.value14) do
        local vname = t1.value15.get("EmoteTemplate").Parent:FindFirstChild(v.name)

        t1.value155(vname)
    end
end
pcall(t1.value156)
t1.value10.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(t1.value156)
end)

function t1.value157(p88)
    local PickUpZone = p88:FindFirstChild("PickUpZone")

    if not PickUpZone then
        PickUpZone = p88:FindFirstChildWhichIsA("BasePart") or p88.PrimaryPart
    end

    if not PickUpZone then
        return nil
    end

    local v587 = t1.value55(p88)
    local v588 = v587 and t1.value47[v587.Rarity]

    if not v588 then
        v588 = Color3.fromRGB(160, 160, 160)
    end

    local v589 = v587

    if v587 then
        v589 = v587.ImageId
    end

    if not v589 then
        v589 = "rbxassetid://7072725737"
    end

    if v587 then
        v587 = v587.Name
    end

    if not v587 then
        v587 = p88.Name
    end

    local Amount = p88:GetAttribute("Amount")
    local _Instance = Instance
    local v592 = Amount or 1
    local v593 = _Instance.new("BillboardGui")

    v593.Name = "DroppedESP_" .. p88.Name
    v593.Adornee = PickUpZone
    v593.Size = UDim2.new(0, 100, 0, 20)
    v593.StudsOffset = Vector3.new(0, 1, 0)
    v593.AlwaysOnTop = true
    v593.Parent = t1.value23

    local Frame = Instance.new("Frame", v593)

    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1

    local UIListLayout = Instance.new("UIListLayout", Frame)

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 3)

    local Frame2 = Instance.new("Frame", Frame)

    Frame2.Size = UDim2.new(0, 18, 0, 18)
    Frame2.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    Frame2.BackgroundTransparency = 0.15
    Frame2.LayoutOrder = 1
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

    local UIStroke = Instance.new("UIStroke", Frame2)

    UIStroke.Color = v588
    UIStroke.Thickness = 1.5

    local ImageLabel = Instance.new("ImageLabel", Frame2)

    ImageLabel.Size = UDim2.new(1, -4, 1, -4)
    ImageLabel.Position = UDim2.new(0, 2, 0, 2)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = v589

    local Frame3 = Instance.new("Frame", Frame)

    Frame3.AutomaticSize = Enum.AutomaticSize.X
    Frame3.Size = UDim2.new(0, 0, 0, 16)
    Frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame3.BackgroundTransparency = 0.25
    Frame3.LayoutOrder = 2
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0.5, 0)

    local UIPadding = Instance.new("UIPadding", Frame3)

    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.PaddingRight = UDim.new(0, 6)

    local TextLabel = Instance.new("TextLabel", Frame3)

    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.new(0, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 10
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Text = v592 > 1 and v587 .. " x" .. tostring(v592) or v587

    return v593
end
function t1.value158()
    for k, v in pairs(t1.value24) do
        local v604 = k

        if not v604 or not v604.Parent then
            if v and v.Parent then
                v:Destroy()
            end

            t1.value24[v604] = nil
        end
    end
end
t1.value2.RenderStepped:Connect(function()
    t1.value158()

    if not t1.value52 then
        for __, v in pairs(t1.value24) do
            if v then
                v.Enabled = false
            end
        end

        return
    end

    local DroppedItems = t1.value5:FindFirstChild("DroppedItems")

    if not DroppedItems then
        return
    end

    local v608 = t1.value10.Character and t1.value10.Character:FindFirstChild("HumanoidRootPart")

    if not v608 then
        return
    end

    local _ipairs = ipairs

    for __, v611 in _ipairs(DroppedItems:GetChildren()) do
        local v612 = v611:IsA("Model")

        if v612 then
            v612 = v611.Name ~= "Money" and not v611:GetAttribute("Locked")
        end

        if v612 then
            local PickUpZone = v611:FindFirstChild("PickUpZone")

            if not PickUpZone then
                PickUpZone = v611:FindFirstChildWhichIsA("BasePart") or v611.PrimaryPart
            end

            if PickUpZone then
                if (PickUpZone.Position - v608.Position).Magnitude <= 800 then
                    if not t1.value24[v611] or not t1.value24[v611].Parent then
                        _ipairs = t1.value24
                        _ipairs[v611] = t1.value157(v611)
                    else
                        _ipairs = t1.value24[v611]
                        _ipairs.Enabled = true
                    end
                elseif t1.value24[v611] then
                    _ipairs = t1.value24[v611]
                    _ipairs.Enabled = false
                end
            end
        end
    end
end)

local v75 = v34("EXTRA", "star")

v75:Section({
	Title = "EXTRA FEATURES"
})
v75:Button({
	Title = "Extra Button",
	Desc = "You can edit this button as you like",
	Callback = function()
    if t1.value119 then
        t1.value119:Notify({
				Title = "Extra Button",
				Content = "Extra button pressed!",
				Duration = 2
			})
    end
end
})
print("[yupitactico huby | v2.2] Loaded Successfully")
