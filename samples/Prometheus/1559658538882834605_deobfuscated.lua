-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v3 = unpack or table.unpack
pcall(function()
    if cleardrawcache then
        cleardrawcache()
    end
end)

if getgenv().ESP_DESTROY then
    pcall(getgenv().ESP_DESTROY)
end
t1.value4 = 301730660633
t1.value3 = "\238\vnt\169\027+#%\216H\143a@\185\140i\247\176\015-\bB\014\211"
t1.value5 = 22052108816441
t1.value8 = 3218102455221
t1.value6 = "\015\222a\194\156\231\024\224!\250"
t1.value7 = 9604913734385
t2.value1 = "AFTERMATH_ESP_RENDER_LOOP"
t2.value2 = game:GetService("RunService")
t1.value5 = "Wx\002\175\029"
t1.value2 = "pcall"
function t1.value3()
    t2.value2:UnbindFromRenderStep(t2.value1)
end
pcall(t1.value3)
t2.value3 = math.round
t2.value4 = math.floor
t2.value5 = math.min
local _math = math
t1.value8 = "\140\024l,2"
t1.value9 = 22523495862768
t2.value6 = _math.max
t2.value7 = math.clamp
t2.value8 = Vector2.new
t2.value9 = Vector3.new
t2.value10 = Color3.new
t2.value11 = Color3.fromHSV
t2.value12 = tonumber
t2.value13 = table.insert
t2.value14 = os.clock
local ESP_CFG = getgenv().ESP_CFG
if not ESP_CFG then
    t1.value11 = Color3.fromRGB(0, 220, 255)
    t1.value12 = Color3.fromRGB(255, 50, 50)
    ESP_CFG = {
		Enabled = true,
		ShowPlayers = true,
		ShowZombies = false,
		Names = true,
		Distance = true,
		Box = true,
		Healthbar = false,
		Skeleton = true,
		ShowSelf = false,
		PlayerColor = t1.value11,
		ZombieColor = t1.value12,
		TextSize = 14,
		MaxDistance = 10000
	}
end
t1.value1 = t1.value1
t1.value10 = "\146s\173\1940b\152"
t2.value15 = ESP_CFG
getgenv().ESP_CFG = t2.value15
t2.value16 = game:GetService("Workspace")
game:GetService("CollectionService")
t2.value17 = game:GetService("ReplicatedStorage")
t2.value18 = game:GetService("ReplicatedFirst")

local CurrentCamera = t2.value16.CurrentCamera
if not CurrentCamera then
    CurrentCamera = t2.value16:FindFirstChildOfClass("Camera")
end
t2.value19 = CurrentCamera
t2.value20 = {}
t2.value21 = {
	Head = true,
	Torso = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	UpperTorso = true,
	LowerTorso = true,
	LeftUpperArm = true,
	LeftLowerArm = true,
	LeftHand = true,
	RightUpperArm = true,
	RightLowerArm = true,
	RightHand = true,
	LeftUpperLeg = true,
	LeftLowerLeg = true,
	LeftFoot = true,
	RightUpperLeg = true,
	RightLowerLeg = true,
	RightFoot = true
}
t2.value22 = nil
t2.value23 = nil
t2.value24 = nil
t2.value25 = nil
function t2.value26()
    if not t2.value22 then
        pcall(function()
            t2.value22 = require(t2.value18:FindFirstChild("CustomMeshCharacter", true))
        end)
    end

    if not t2.value23 then
        pcall(function()
            t2.value23 = require(t2.value18:FindFirstChild("NPCSimulatorService.service", true))
        end)
    end

    if not t2.value24 then
        pcall(function()
            local CustomCharacter = t2.value17:FindFirstChild("CustomCharacter", true)

            if CustomCharacter then
                CustomCharacter = CustomCharacter:FindFirstChild("PlayerList")
            end

            t2.value24 = CustomCharacter

            if t2.value24 then
                t2.value24 = require(t2.value24)
            end
        end)
    end

    if not t2.value25 then
        pcall(function()
            local CustomCharacter = t2.value18:FindFirstChild("CustomCharacter", true)
            local v242 = CustomCharacter and CustomCharacter:FindFirstChild("CharacterController")

            t2.value25 = v242 and v242:FindFirstChild("CharacterPlugin")

            if t2.value25 then
                t2.value25 = require(t2.value25)
            end
        end)
    end
end
function t2.value27(p1, p2)
    local drawing = Drawing.new(p1)

    for k, v in pairs(p2) do
        local v12 = k

        if v12 ~= "Thickness" or v > 0 then
            drawing[v12] = v
        end
    end

    return drawing
end
function t2.value28(p3)
    local g122
    local v121
    local t26
    if p3:FindFirstChild("UpperTorso") ~= nil then
        local t3 = {
			p3:FindFirstChild("Head"),
			p3:FindFirstChild("UpperTorso")
		}
        local UpperTorso = p3:FindFirstChild("UpperTorso")
        local t4 = { p3:FindFirstChild("LowerTorso") }
        local t5 = {
			UpperTorso,
			v3(t4)
		}
        local UpperTorso2 = p3:FindFirstChild("UpperTorso")
        local t6 = { p3:FindFirstChild("LeftUpperArm") }
        local t7 = {
			UpperTorso2,
			v3(t6)
		}
        local LeftUpperArm = p3:FindFirstChild("LeftUpperArm")
        local t8 = { p3:FindFirstChild("LeftLowerArm") }
        local t9 = {
			LeftUpperArm,
			v3(t8)
		}
        local t10 = {
			p3:FindFirstChild("LeftLowerArm"),
			p3:FindFirstChild("LeftHand")
		}
        local UpperTorso3 = p3:FindFirstChild("UpperTorso")
        local t11 = { p3:FindFirstChild("RightUpperArm") }
        local t12 = {
			UpperTorso3,
			v3(t11)
		}
        local RightUpperArm = p3:FindFirstChild("RightUpperArm")
        local t13 = { p3:FindFirstChild("RightLowerArm") }
        local t14 = {
			RightUpperArm,
			v3(t13)
		}
        local RightLowerArm = p3:FindFirstChild("RightLowerArm")
        local t15 = { p3:FindFirstChild("RightHand") }
        local t16 = {
			RightLowerArm,
			v3(t15)
		}
        local LowerTorso = p3:FindFirstChild("LowerTorso")
        local t17 = { p3:FindFirstChild("LeftUpperLeg") }
        local t18 = {
			LowerTorso,
			v3(t17)
		}
        local LeftUpperLeg = p3:FindFirstChild("LeftUpperLeg")
        local t19 = { p3:FindFirstChild("LeftLowerLeg") }
        local t20 = {
			LeftUpperLeg,
			v3(t19)
		}
        local LeftLowerLeg = p3:FindFirstChild("LeftLowerLeg")
        local t21 = { p3:FindFirstChild("LeftFoot") }
        local t22 = {
			LeftLowerLeg,
			v3(t21)
		}
        local LowerTorso2 = p3:FindFirstChild("LowerTorso")
        local t23 = { p3:FindFirstChild("RightUpperLeg") }
        local t24 = {
			LowerTorso2,
			v3(t23)
		}
        local RightUpperLeg = p3:FindFirstChild("RightUpperLeg")
        local t25 = { p3:FindFirstChild("RightLowerLeg") }

        t26 = {
			t3,
			t5,
			t7,
			t9,
			t10,
			t12,
			t14,
			t16,
			t18,
			t20,
			t22,
			t24,
			{
				RightUpperLeg,
				v3(t25)
			},
			{
				p3:FindFirstChild("RightLowerLeg"),
				p3:FindFirstChild("RightFoot")
			}
		}
    else
        local Torso = p3:FindFirstChild("Torso")
        local t27 = {
			p3:FindFirstChild("Head"),
			Torso
		}
        local t28 = { p3:FindFirstChild("Left Arm") }
        local t29 = {
			Torso,
			v3(t28)
		}
        local t30 = { p3:FindFirstChild("Right Arm") }
        local t31 = {
			Torso,
			v3(t30)
		}
        local t32 = { p3:FindFirstChild("Left Leg") }

        t26 = {
			t27,
			t29,
			t31,
			{
				Torso,
				v3(t32)
			},
			{
				Torso,
				p3:FindFirstChild("Right Leg")
			}
		}
    end
    local t33 = {}
    local v115 = #t26
    local n1 = 1
    local v117 = n1 < 0
    local v118 = 1 - n1
    repeat

        v118 = n1 + v118
        local v120 = not v117 and v118 <= v115
        if v117 then
            v121 = true

            if v118 <= v115 then
                g122 = true
            end
        end
        if not g122 then
            v121 = v120
        end
        g122 = false
        if not v121 then
            return t33
        end
        local v123 = t26[v118]
        if v123[1] and v123[2] then
            t2.value13(t33, v123)
        end
    until not g119
end
t2.value29 = nil
function t2.value29(p4)
    t2.value26()
    local v59 = p4:FindFirstChild("ServerCollider") ~= nil
    local v60 = p4:FindFirstChild("Head") ~= nil
    if not v60 then
        v60 = p4:FindFirstChildOfClass("Humanoid") ~= nil

        if not v60 then
            v60 = p4:FindFirstChildOfClass("AnimationController") ~= nil
        end
    end
    if v59 or not v60 then
        return {
			IsIgnore = true
		}
    end
    local v61 = false
    local v62 = false
    local PlayerFromWorldCharacter
    local PlayerFromWorldCharacterName
    if t2.value22 ~= nil or t2.value23 ~= nil then
        local value22 = t2.value22

        if value22 then
            value22 = t2.value22.GetPlayerFromWorldCharacter
        end

        if value22 then
            PlayerFromWorldCharacter = t2.value22:GetPlayerFromWorldCharacter(p4)
        end

        local v65 = not PlayerFromWorldCharacter

        if v65 then
            v65 = t2.value24

            if v65 then
                v65 = t2.value24.GetPlayerFromCharacter
            end
        end

        if v65 then
            PlayerFromWorldCharacter = t2.value24:GetPlayerFromCharacter(p4)
        end

        if not PlayerFromWorldCharacter then
            PlayerFromWorldCharacter = game.Players:GetPlayerFromCharacter(p4)
        end

        if not PlayerFromWorldCharacter then
            PlayerFromWorldCharacter = game.Players:FindFirstChild(p4.Name)
        end

        local v66 = p4:FindFirstChild("HumanoidRootPart") or p4.PrimaryPart

        if v66 then
            v66 = v66:GetAttribute("CustomUUID")
        end

        if v66 then
            local value23 = t2.value23

            if value23 then
                value23 = t2.value23.NPCs

                if value23 then
                    value23 = t2.value23.NPCs[t2.value12(v66)]
                end
            end

            v66 = value23
        end

        if PlayerFromWorldCharacter then
            v61 = true
            PlayerFromWorldCharacterName = PlayerFromWorldCharacter.Name
        else
            if not v66 then
                return {
					IsIgnore = true,
					IsHoneypot = true
				}
            end

            v62 = true

            local v69 = v66.Type or "Zombie"

            if v69:sub(1, 2) == "AI" then
                v69 = v69:sub(3)
            end

            PlayerFromWorldCharacterName = v69:gsub("(%l)(%u)", "%1 %2")
        end
    else
        local value24 = t2.value24

        if value24 then
            value24 = t2.value24.GetPlayerFromCharacter
        end

        if value24 then
            PlayerFromWorldCharacter = t2.value24:GetPlayerFromCharacter(p4)
        end

        if not PlayerFromWorldCharacter then
            PlayerFromWorldCharacter = game.Players:GetPlayerFromCharacter(p4)
        end

        if not PlayerFromWorldCharacter then
            PlayerFromWorldCharacter = game.Players:FindFirstChild(p4.Name)
        end

        if PlayerFromWorldCharacter then
            v61 = true
            PlayerFromWorldCharacterName = PlayerFromWorldCharacter.Name
        else
            v62 = true
            PlayerFromWorldCharacterName = "Zombie"
        end
    end

    return {
		IsPlayer = v61,
		IsZombie = v62,
		IsHoneypot = false,
		Name = PlayerFromWorldCharacterName,
		PlayerObject = PlayerFromWorldCharacter
	}
end
function t2.value30(p5)
    local v24 = t2.value20[p5]
    if not v24 then
        return
    end
    v24.Drawings.Box:Remove()
    v24.Drawings.BoxOutline:Remove()
    v24.Drawings.Name:Remove()
    v24.Drawings.Distance:Remove()
    v24.Drawings.HealthBg:Remove()
    v24.Drawings.HealthBar:Remove()
    local v25 = #v24.Drawings.SkeletonLines
    local v26 = false
    local n2 = 0
    local g31
    local v30
    repeat

        n2 += 1
        local v29 = not v26 and n2 <= v25
        if v26 then
            v30 = true

            if n2 <= v25 then
                g31 = true
            end
        end
        if not g31 then
            v30 = v29
        end
        g31 = false
        if v30 then
            v24.Drawings.SkeletonLines[n2]:Remove()
        end
    until not g28
    t2.value20[p5] = nil
end
function t2.value31(p6)
    if t2.value20[p6] then
        return t2.value20[p6]
    end
    local v125 = t2.value29(p6)
    local v126 = not v125
    local g151
    local v150
    local g160
    local v159
    if not v126 then
        v126 = v125.IsIgnore or v125.IsHoneypot
    end
    if v126 then
        return nil
    end
    local v127 = v125.PlayerObject == game.Players.LocalPlayer
    if v127 then
        v127 = not t2.value15.ShowSelf
    end
    if v127 then
        return nil
    end
    local IsPlayer = v125.IsPlayer
    if IsPlayer then
        IsPlayer = t2.value15.PlayerColor
    end
    if not IsPlayer then
        IsPlayer = t2.value15.ZombieColor
    end
    local v129 = t2.value27("Square", {
		Thickness = 1,
		Color = IsPlayer,
		Filled = false,
		Visible = false
	})
    local value27 = t2.value27
    local v131 = t2.value10(0, 0, 0)
    local v132 = value27("Square", {
		Thickness = 3,
		Color = v131,
		Filled = false,
		Visible = false
	})
    local v133 = t2.value27("Text", {
		Size = t2.value15.TextSize,
		Color = IsPlayer,
		Center = true,
		Outline = true,
		Visible = false
	})
    local value27_2 = t2.value27
    local v135 = t2.value15.TextSize - 2
    local v136 = t2.value10(1, 1, 1)
    local v137 = value27_2("Text", {
		Size = v135,
		Color = v136,
		Center = true,
		Outline = true,
		Visible = false
	})
    local value27_3 = t2.value27
    local v139 = t2.value10(0, 0, 0)
    local v140 = value27_3("Square", {
		Thickness = 1,
		Color = v139,
		Filled = true,
		Visible = false
	})
    local value27_4 = t2.value27
    local v142 = t2.value10(0, 1, 0)
    local v143 = value27_4("Square", {
		Thickness = 1,
		Color = v142,
		Filled = true,
		Visible = false
	})
    local t34 = {
		Box = v129,
		BoxOutline = v132,
		Name = v133,
		Distance = v137,
		HealthBg = v140,
		HealthBar = v143,
		SkeletonLines = {}
	}
    local n3 = 15
    local v146 = false
    local n4 = 0
    repeat

        n4 = 1 + n4
        local v149 = not v146 and n4 <= n3
        if v146 then
            v150 = true

            if n4 <= n3 then
                g151 = true
            end
        end
        if not g151 then
            v150 = v149
        end
        g151 = false
        if v150 then
            t34.SkeletonLines[n4] = t2.value27("Line", {
				Thickness = 1,
				Color = IsPlayer,
				Visible = false
			})
        end
    until not g148
    local t35 = {}
    local children = p6:GetChildren()
    local v154 = #children
    local v155 = false
    local n5 = 0
    repeat

        n5 += 1
        local v158 = not v155 and n5 <= v154
        if v155 then
            v159 = true

            if n5 <= v154 then
                g160 = true
            end
        end
        if not g160 then
            v159 = v158
        end
        g160 = false
        if not v159 then
            local value20 = t2.value20
            local HumanoidRootPart = p6:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = p6.PrimaryPart

                if not HumanoidRootPart then
                    HumanoidRootPart = p6:FindFirstChild("Torso") or p6:FindFirstChild("UpperTorso")
                end
            end

            local States = p6:FindFirstChild("States")
            local Humanoid = p6:FindFirstChildOfClass("Humanoid")
            local v165 = t2.value28(p6)

            value20[p6] = {
				Drawings = t34,
				Data = v125,
				RootPart = HumanoidRootPart,
				States = States,
				Humanoid = Humanoid,
				VisualParts = t35,
				Bones = v165,
				LastUpdate = 0
			}

            return t2.value20[p6]
        end
        local v166 = children[n5]
        local v167 = v166:IsA("BasePart")
        if v167 then
            v167 = t2.value21[v166.Name]
        end
        if v167 then
            t2.value13(t35, v166)
        end
    until not g157
end
function t2.value32(p7)
    p7.BoxOutline.Visible = false
    p7.Box.Visible = false
    p7.Name.Visible = false
    p7.Distance.Visible = false
    p7.HealthBg.Visible = false
    p7.HealthBar.Visible = false
    local SkeletonLines = p7.SkeletonLines
    local v15 = #SkeletonLines
    local n6 = 1
    local v17 = n6 < 0
    local v18 = 1 - n6
    local g22
    local v21
    repeat

        v18 += n6
        local v20 = not v17 and v18 <= v15
        if v17 then
            v21 = true

            if v18 <= v15 then
                g22 = true
            end
        end
        if not g22 then
            v21 = v20
        end
        g22 = false
        if not v21 then
            return
        end
        SkeletonLines[v18].Visible = false
    until not g19
end
function t2.value33(p8)
    local n7 = -1e999
    local n8 = -1e999
    local n9 = 1e999
    local n10 = 1e999
    local VisualParts = p8.VisualParts
    if not (#VisualParts > 0) then
        return nil, nil
    end
    local v38 = #VisualParts
    local v39 = false
    local n11 = 0
    local g44
    local v43
    repeat

        n11 += 1
        local v42 = not v39 and n11 <= v38
        if v39 then
            v43 = true

            if n11 <= v38 then
                g44 = true
            end
        end
        if not g44 then
            v43 = v42
        end
        g44 = false
        if not v43 then
            if n9 == math.huge then
                return nil, nil
            end

            return t2.value8(n9, n10), t2.value8(n7 - n9, n8 - n10)
        end
        local v45 = VisualParts[n11]
        local v46 = v45.Size.X * 0.5
        local v47 = v45.Size.Y * 0.5
        local v48 = v45.Size.Z * 0.5
        local CFrame = v45.CFrame
        local v50 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(-v46, -v47, -v48))
        local v51 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(v46, -v47, -v48))
        local v52 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(-v46, v47, -v48))
        local v53 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(v46, v47, -v48))
        local v54 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(-v46, -v47, v48))
        local v55 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(v46, -v47, v48))
        local v56 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(-v46, v47, v48))
        local v57 = t2.value19:WorldToViewportPoint(CFrame * t2.value9(v46, v47, v48))
        if v50.Z > 0 then
            n9 = t2.value5(n9, v50.X)
            n10 = t2.value5(n10, v50.Y)
            n7 = t2.value6(n7, v50.X)
            n8 = t2.value6(n8, v50.Y)
        end
        if v51.Z > 0 then
            n9 = t2.value5(n9, v51.X)
            n10 = t2.value5(n10, v51.Y)
            n7 = t2.value6(n7, v51.X)
            n8 = t2.value6(n8, v51.Y)
        end
        if v52.Z > 0 then
            n9 = t2.value5(n9, v52.X)
            n10 = t2.value5(n10, v52.Y)
            n7 = t2.value6(n7, v52.X)
            n8 = t2.value6(n8, v52.Y)
        end
        if v53.Z > 0 then
            n9 = t2.value5(n9, v53.X)
            n10 = t2.value5(n10, v53.Y)
            n7 = t2.value6(n7, v53.X)
            n8 = t2.value6(n8, v53.Y)
        end
        if v54.Z > 0 then
            n9 = t2.value5(n9, v54.X)
            n10 = t2.value5(n10, v54.Y)
            n7 = t2.value6(n7, v54.X)
            n8 = t2.value6(n8, v54.Y)
        end
        if v55.Z > 0 then
            n9 = t2.value5(n9, v55.X)
            n10 = t2.value5(n10, v55.Y)
            n7 = t2.value6(n7, v55.X)
            n8 = t2.value6(n8, v55.Y)
        end
        if v56.Z > 0 then
            n9 = t2.value5(n9, v56.X)
            n10 = t2.value5(n10, v56.Y)
            n7 = t2.value6(n7, v56.X)
            n8 = t2.value6(n8, v56.Y)
        end
        if v57.Z > 0 then
            n9 = t2.value5(n9, v57.X)
            n10 = t2.value5(n10, v57.Y)
            n7 = t2.value6(n7, v57.X)
            n8 = t2.value6(n8, v57.Y)
        end
    until not g41
end
t2.value2:BindToRenderStep(t2.value1, 1, function()
    local v168 = not t2.value19
    local g179
    local g181
    local v187
    local Drawings
    local Data
    local Magnitude
    local n14
    local n13
    local g215
    local g224
    local SkeletonLines
    local v235
    local v234
    local v233
    if not v168 then
        v168 = not t2.value19.Parent
    end
    if v168 then
        local CurrentCamera2 = t2.value16.CurrentCamera

        if not CurrentCamera2 then
            CurrentCamera2 = t2.value16:FindFirstChildOfClass("Camera")
        end

        t2.value19 = CurrentCamera2

        if not t2.value19 then
            return
        end
    end
    local game_assets = t2.value16:FindFirstChild("game_assets")
    local v171 = game_assets and game_assets:FindFirstChild("Entities")
    if not v171 then
        return
    end
    local t36 = {}
    local children = v171:GetChildren()
    local v174 = t2.value14()
    local CFramePosition = t2.value19.CFrame.Position
    local v176 = #children
    local v177 = false
    local n12 = 0
    repeat
        repeat
            if not g179 then
                while true do
                    while true do
                        local v186

                        repeat
                            n12 += 1

                            local v180 = not v177 and n12 <= v176
                            local v182

                            repeat
                                if not g181 and v177 then
                                    v182 = true

                                    if not (n12 <= v176) then
                                        g181 = true
                                    end
                                else
                                    g181 = false
                                    v182 = v180
                                end
                            until not g181

                            if not v182 then
                                for k, _ in pairs(t2.value20) do
                                    local v185 = k

                                    if not t36[v185] then
                                        t2.value30(v185)
                                    end
                                end

                                return
                            end

                            v186 = children[n12]
                            t36[v186] = true
                            v187 = t2.value20[v186] or t2.value31(v186)
                        until v187

                        local RootPart = v187.RootPart

                        if not RootPart or not RootPart.Parent then
                            t2.value30(v186)

                            continue
                        end

                        if v174 - v187.LastUpdate > 2 then
                            v187.Data = t2.value29(v186)
                            v187.LastUpdate = v174
                        end

                        Data = v187.Data
                        n13 = 100
                        Drawings = v187.Drawings
                        n14 = 100

                        local GetAttribute = v186.GetAttribute
                        local PrimaryPart = v186.PrimaryPart
                        local v195 = GetAttribute(v186, "Health")

                        if not v195 then
                            v195 = PrimaryPart

                            if PrimaryPart then
                                v195 = PrimaryPart:GetAttribute("Health")
                            end
                        end

                        local MaxHealth = v186:GetAttribute("MaxHealth")

                        if not MaxHealth then
                            if PrimaryPart then
                                PrimaryPart = PrimaryPart:GetAttribute("MaxHealth")
                            end

                            MaxHealth = PrimaryPart
                        end

                        if Data.PlayerObject then
                            if not v195 then
                                v195 = Data.PlayerObject:GetAttribute("Health")
                            end

                            if not MaxHealth then
                                MaxHealth = Data.PlayerObject:GetAttribute("MaxHealth")
                            end

                            if Data.PlayerObject == game.Players.LocalPlayer and t2.value25 then
                                v195 = v195 or t2.value25:GetHealth()

                                if not MaxHealth then
                                    MaxHealth = t2.value25:GetMaxHealth()
                                end
                            end
                        end

                        local States = v187.States

                        if States then
                            if not v195 then
                                v195 = States:GetAttribute("Health")
                            end

                            if not MaxHealth then
                                MaxHealth = States:GetAttribute("MaxHealth")
                            end
                        end

                        if v195 then
                            local v198 = t2.value12(v195)
                            local value12 = t2.value12

                            n14 = v198 or 100
                            n13 = value12(MaxHealth) or 100
                        else
                            local Humanoid = v187.Humanoid

                            if Humanoid then
                                Humanoid = v187.Humanoid.Parent
                            end

                            if Humanoid then
                                n14 = v187.Humanoid.Health
                                n13 = v187.Humanoid.MaxHealth
                            end
                        end

                        local v201 = not t2.value15.Enabled

                        if not v201 then
                            v201 = Data.IsIgnore

                            if not v201 then
                                v201 = n14 <= 0

                                if not v201 then
                                    v201 = Data.IsPlayer

                                    if v201 then
                                        v201 = not t2.value15.ShowPlayers
                                    end

                                    if not v201 then
                                        v201 = Data.IsZombie

                                        if v201 then
                                            v201 = not t2.value15.ShowZombies
                                        end
                                    end
                                end
                            end
                        end

                        if v201 then
                            t2.value32(Drawings)

                            continue
                        end

                        Magnitude = (CFramePosition - RootPart.Position).Magnitude

                        if Magnitude <= t2.value15.MaxDistance then
                            break
                        end

                        t2.value32(Drawings)
                    end

                    local v203, v204 = t2.value33(v187)

                    if not v203 then
                        t2.value32(Drawings)

                        continue
                    end

                    local v205 = t2.value8(t2.value3(v203.X), t2.value3(v203.Y))
                    local v206 = t2.value8(t2.value3(v204.X), t2.value3(v204.Y))

                    if t2.value15.Box then
                        Drawings.BoxOutline.Size = v206
                        Drawings.BoxOutline.Position = v205
                        Drawings.BoxOutline.Visible = true
                        Drawings.Box.Size = v206
                        Drawings.Box.Position = v205
                        Drawings.Box.Visible = true
                    else
                        Drawings.BoxOutline.Visible = false
                        Drawings.Box.Visible = false
                    end

                    if t2.value15.Names then
                        Drawings.Name.Text = Data.Name
                        Drawings.Name.Position = t2.value8(v205.X + v206.X / 2, v205.Y - Drawings.Name.TextBounds.Y - 2)
                        Drawings.Name.Visible = true
                    else
                        Drawings.Name.Visible = false
                    end

                    if t2.value15.Distance then
                        Drawings.Distance.Text = t2.value4(Magnitude) .. "m"
                        Drawings.Distance.Position = t2.value8(v205.X + v206.X / 2, v205.Y + v206.Y + 2)
                        Drawings.Distance.Visible = true
                    else
                        Drawings.Distance.Visible = false
                    end

                    if t2.value15.Healthbar then
                        local v207 = t2.value7(n14 / t2.value6(n13, 1), 0, 1)
                        local v208 = t2.value3(v206.Y * v207)
                        local v209 = t2.value8(v205.X - 3 - 6, v205.Y)

                        Drawings.HealthBg.Size = t2.value8(5, v206.Y + 2)
                        Drawings.HealthBg.Position = t2.value8(v209.X - 1, v209.Y - 1)
                        Drawings.HealthBg.Visible = true
                        Drawings.HealthBar.Size = t2.value8(3, v208)
                        Drawings.HealthBar.Position = t2.value8(v209.X, v209.Y + t2.value3(v206.Y - v208))
                        Drawings.HealthBar.Color = t2.value11(0.3 * v207, 1, 1)
                        Drawings.HealthBar.Visible = true
                    else
                        Drawings.HealthBg.Visible = false
                        Drawings.HealthBar.Visible = false
                    end

                    SkeletonLines = Drawings.SkeletonLines

                    if t2.value15.Skeleton then
                        break
                    end

                    local v211 = #SkeletonLines
                    local v212 = false
                    local n15 = 0

                    while true do
                        n15 += 1

                        local v214 = not v212 and n15 <= v211
                        local v216

                        repeat
                            if not g215 and v212 then
                                v216 = true

                                if not (n15 <= v211) then
                                    g215 = true
                                end
                            else
                                g215 = false
                                v216 = v214
                            end
                        until not g215

                        if not v216 then
                            break
                        end

                        SkeletonLines[n15].Visible = false
                    end
                end

                local Bones = v187.Bones
                local n16 = 1
                local v219 = #Bones
                local v220 = false
                local n17 = 0

                repeat

                    n17 += 1
                    local v223 = not v220 and n17 <= v219
                    local v225
                    repeat
                        if not g224 and v220 then
                            v225 = true

                            if not (n17 <= v219) then
                                g224 = true
                            end
                        else
                            g224 = false
                            v225 = v223
                        end
                    until not g224
                    if v225 then
                        local v226 = Bones[n17]
                        local v227, v228 = t2.value19:WorldToViewportPoint(v226[1].Position)
                        local v229, v230 = t2.value19:WorldToViewportPoint(v226[2].Position)
                        if v228 then
                            v228 = v230 and SkeletonLines[n16]
                        end
                        if v228 then
                            SkeletonLines[n16].From = t2.value8(t2.value3(v227.X), t2.value3(v227.Y))
                            SkeletonLines[n16].To = t2.value8(t2.value3(v229.X), t2.value3(v229.Y))

                            local v231 = SkeletonLines[n16]
                            local IsPlayer = Data.IsPlayer

                            if IsPlayer then
                                IsPlayer = t2.value15.PlayerColor
                            end

                            if not IsPlayer then
                                IsPlayer = t2.value15.ZombieColor
                            end

                            v231.Color = IsPlayer
                            SkeletonLines[n16].Visible = true
                            n16 += 1
                        end
                    end
                until not g222

                v233 = #SkeletonLines
                v234 = false
                v235 = n16 - 1
            end

            g179 = false
            v235 = 1 + v235

            local v236 = not v234 and v235 <= v233
            local v237

            if v234 then
                v237 = true

                if v235 <= v233 then
                    continue
                end
            end

            v237 = v236
        until v237

        SkeletonLines[v235].Visible = false
        g179 = true
    until not g179
end)
getgenv().ESP_TOGGLE = function()
    t2.value15.Enabled = not t2.value15.Enabled
end
getgenv().ESP_DESTROY = function()
    pcall(function()
        t2.value2:UnbindFromRenderStep(t2.value1)
    end)

    for k, _ in pairs(t2.value20) do
        t2.value30(k)
    end

    table.clear(t2.value20)
end
print("nigga")
