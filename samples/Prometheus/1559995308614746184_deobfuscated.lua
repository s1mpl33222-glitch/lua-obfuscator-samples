-- This file was generated at discord.gg/syncrypt

local t1 = {}
local v2 = unpack or table.unpack
function t1.value1(p1, p2)
    local t2 = {}
    local Players = game:GetService("Players")

    t2.value1 = game:GetService("RunService")
    t2.value2 = game:GetService("ReplicatedStorage")
    t2.value3 = game:GetService("TweenService")
    t2.value4 = game:GetService("Lighting")
    t2.value5 = Players.LocalPlayer
    t2.value6 = p1:CreateWindow({
		Id = "SerpentHub_DOORS",
		Title = "SerpentHub",
		Subtitle = "serpent hub - doors script",
		Theme = "Default",
		Width = 650,
		Height = 460
	})
    p2.window = t2.value6
    t2.value7 = true
    t2.value8 = nil
    t2.value9 = {
		monsters = false,
		alerts = false,
		door = false,
		loot = false,
		coinsOnly = false,
		keys = false,
		lockers = false,
		fullbright = false,
		speed = false
	}

    local value9 = t2.value9
    local value9_2 = t2.value9
    local value9_3 = t2.value9
    local value9_4 = t2.value9
    local value9_5 = t2.value9

    value9.libraryESP = false
    value9_2.libraryCode = true
    value9_3.breakerESP = false
    value9_4.breakerHelper = false
    value9_5.fov = false
    t2.value10 = 20
    t2.value11 = {}
    t2.value12 = {}
    t2.value13 = setmetatable({}, {
		__mode = "k"
	})
    t2.value14 = {
		RushMoving = "Rush",
		AmbushMoving = "Ambush",
		Eyes = "Eyes",
		Lookman = "Eyes",
		BackdoorRush = "Blitz",
		BackdoorLookman = "Lookman",
		A60 = "A-60",
		A120 = "A-120",
		FigureRig = "Figure",
		FigureRagdoll = "Figure",
		Figure = "Figure",
		Seek = "Seek",
		SeekRig = "Seek",
		SeekMoving = "Seek",
		SeekMovingNewClone = "Seek",
		Screech = "Screech",
		Halt = "Halt",
		GiggleCeiling = "Giggle",
		GrumbleRig = "Grumble",
		Snare = "Snare",
		GloombatSwarm = "Gloombats",
		SallyMoving = "Sally",
		Groundskeeper = "Groundskeeper"
	}
    t2.value15 = {
		KeyObtain = "Key",
		ElectricalKeyObtain = "Electrical key",
		FuseObtain = "Fuse",
		LiveHintBook = "Book",
		LibraryHintPaper = "Hint paper",
		LiveBreakerPolePickup = "Breaker fuse",
		Lighter = "Lighter",
		Flashlight = "Flashlight",
		Candle = "Candle",
		Lockpick = "Lockpick",
		Vitamins = "Vitamins",
		Crucifix = "Crucifix",
		SkeletonKey = "Skeleton key",
		Bandage = "Bandage",
		Battery = "Battery",
		Batteries = "Batteries",
		Glowsticks = "Glowsticks",
		Bulklight = "Bulklight"
	}

    local color3 = Color3.fromRGB(142, 210, 255)
    local color3_2 = Color3.fromRGB(172, 161, 236)
    local color3_3 = Color3.fromRGB(255, 98, 115)
    local color3_4 = Color3.fromRGB(109, 220, 255)
    local color3_5 = Color3.fromRGB(138, 243, 184)
    local color3_6 = Color3.fromRGB(255, 215, 92)

    t2.value16 = {
		key = color3,
		locker = color3_2,
		monster = color3_3,
		door = color3_4,
		item = color3_5,
		gold = color3_6
	}
    t2.value17 = Instance.new("Folder")
    t2.value17.Name = "SerpentHub_LocalESP"
    t2.value17.Parent = workspace
    t2.value18 = Instance.new("ScreenGui")
    t2.value18.Name = "SerpentHub_Alerts"
    t2.value18.ResetOnSpawn = false
    t2.value18.DisplayOrder = 110
    t2.value18.Parent = t2.value5:WaitForChild("PlayerGui")
    t2.value19 = Instance.new("CanvasGroup")
    t2.value19.AnchorPoint = Vector2.new(0.5, 0)
    t2.value19.Position = UDim2.new(0.5, 0, 0, 15)
    t2.value19.Size = UDim2.new(0.85, 0, 0, 104)
    t2.value19.BackgroundColor3 = Color3.fromRGB(14, 10, 14)
    t2.value19.BackgroundTransparency = 0.12
    t2.value19.GroupTransparency = 1
    t2.value19.Visible = false
    t2.value19.Parent = t2.value18

    local UISizeConstraint = Instance.new("UISizeConstraint")

    UISizeConstraint.MaxSize = Vector2.new(400, 104)
    UISizeConstraint.Parent = t2.value19

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = t2.value19

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t2.value16.monster
    UIStroke.Transparency = 0.45
    UIStroke.Parent = t2.value19
    t2.value20 = Instance.new("TextLabel")
    t2.value20.BackgroundTransparency = 1
    t2.value20.Position = UDim2.fromOffset(14, 7)
    t2.value20.Size = UDim2.new(1, -28, 1, -14)
    t2.value20.Font = Enum.Font.GothamMedium
    t2.value20.TextSize = 14
    t2.value20.TextColor3 = Color3.fromRGB(255, 238, 237)
    t2.value20.TextWrapped = true
    t2.value20.Parent = t2.value19
    p2.artifacts = {
		t2.value17,
		t2.value18
	}
    t2.value21 = {}
    t2.value22 = nil
    t2.value23 = {
		Rush = "HIDE NOW",
		Ambush = "HIDE · can return",
		Blitz = "HIDE NOW",
		["A-60"] = "HIDE NOW",
		["A-120"] = "HIDE NOW",
		Eyes = "LOOK AWAY",
		Lookman = "LOOK AWAY",
		Screech = "LOOK AROUND",
		Figure = "STAY QUIET",
		Seek = "CHASE DETECTED",
		Giggle = "CHECK THE CEILING",
		Grumble = "KEEP YOUR DISTANCE"
	}
    t2.value24 = {
		Rush = 1,
		Ambush = 1,
		Blitz = 1,
		["A-60"] = 1,
		["A-120"] = 1,
		Screech = 2,
		Eyes = 2
	}

    function t2.value25()
        table.clear(t2.value21)

        if t2.value22 then
            t2.value22:Cancel()
        end

        t2.value19.Visible = false
        t2.value19.GroupTransparency = 1
    end
    function t2.value26()
        local v100 = not t2.value7
        if not v100 then
            v100 = not t2.value9.alerts
        end
        if v100 then
            return
        end
        local t3 = {}
        for v104, v105 in pairs(t2.value21) do

            if v105.expires <= os.clock() then
                t2.value21[v104] = nil
            else
                table.insert(t3, v105)
            end
        end
        table.sort(t3, function(p3, p4)
            local v371 = t2.value24[p3.name] or 3
            local v372 = t2.value24[p4.name] or 3

            if v371 ~= v372 then
                return v371 < v372
            end

            return p3.expires > p4.expires
        end)
        if #t3 == 0 then
            t2.value19.Visible = false

            return
        end
        local t4 = {}
        for i = 1, math.min(3, #t3) do
            local v108 = i
            local v109 = t3[v108]

            t4[v108] = string.upper(v109.name) .. ("  ·  " .. t2.value23[v109.name] or "ENTITY DETECTED")
        end
        t2.value20.Text = table.concat(t4, "\n")
        t2.value19.Size = UDim2.new(0.85, 0, 0, math.min(3, #t3) * 23 + 32)
        if not t2.value19.Visible then
            t2.value19.Visible = true
            t2.value19.GroupTransparency = 1

            if t2.value22 then
                t2.value22:Cancel()
            end

            t2.value22 = t2.value3:Create(t2.value19, TweenInfo.new(0.2), {
				GroupTransparency = 0
			})
            t2.value22:Play()
        end
    end

    local function v25(p5)
        local v111 = not t2.value7

        if not v111 then
            v111 = not t2.value9.alerts
        end

        if v111 then
            return
        end

        local v112 = p5:gsub(" detected$", "")
        local value21 = t2.value21
        local elapsed = os.clock()

        value21[v112] = {
			name = v112,
			expires = elapsed + 7
		}
        t2.value26()
        t2.value6:Notify(v112 .. " detected", 5)
    end
    local function v26(p6)
        return p6:IsA("Model") or p6:IsA("BasePart")
    end

    t2.value27 = {
		Wardrobe = true,
		Backdoor_Wardrobe = true,
		Rooms_Locker = true,
		Rooms_Locker_Fridge = true,
		Locker_Large = true,
		DrawerContainer = true,
		Drawer = true,
		Dresser = true,
		ChestBox = true,
		ChestBoxLocked = true
	}
    t2.value28 = {
		Wardrobe = true,
		Backdoor_Wardrobe = true,
		Rooms_Locker = true,
		Rooms_Locker_Fridge = true,
		Locker_Large = true
	}
    t2.value29 = {
		KeyObtain = true,
		ElectricalKeyObtain = true
	}

    function t2.value30(p7)
        local v120
        local v121
        while p7 and p7 ~= workspace do
            local v122 = t2.value14[p7.Name]

            if v122 then
                v122 = p7:IsA("Model") or p7:IsA("BasePart")
            end

            if v122 then
                v120 = p7
                v121 = t2.value14[p7.Name]
            end

            p7 = p7.Parent
        end

        return v120, v121
    end

    local function v27(p8)
        local GoldValue = p8:GetAttribute("GoldValue")

        if type(GoldValue) == "number" then
            return GoldValue
        end

        local GoldValue2 = p8:FindFirstChild("GoldValue")
        local v126 = GoldValue2

        if GoldValue2 then
            v126 = GoldValue2:IsA("IntValue")

            if not v126 then
                v126 = GoldValue2:IsA("NumberValue")
            end
        end

        if v126 then
            return GoldValue2.Value
        end
    end

    t2.value31 = {
		LiveHintBook = {
			"libraryItem",
			"Library book"
		},
		LibraryHintPaper = {
			"libraryItem",
			"Hint paper"
		},
		LibraryHintPaperHard = {
			"libraryItem",
			"Hint paper"
		},
		Padlock = {
			"libraryLock",
			"Library padlock"
		},
		LiveBreakerPolePickup = {
			"breakerPart",
			"Breaker part"
		},
		ElevatorBreaker = {
			"breakerPanel",
			"Breaker panel"
		}
	}
    t2.value16.libraryItem = Color3.fromRGB(161, 200, 255)
    t2.value16.libraryLock = t2.value16.libraryItem
    t2.value16.breakerPart = Color3.fromRGB(255, 204, 107)
    t2.value16.breakerPanel = t2.value16.breakerPart

    function t2.value32(p9)
        local v128 = not v26(p9)

        if not v128 then
            v128 = not p9:IsDescendantOf(workspace)

            if not v128 then
                v128 = p9:IsDescendantOf(t2.value17)
            end
        end

        if v128 then
            return
        end

        local v129, v130 = t2.value30(p9)

        if v129 then
            if v129 == p9 then
                return "monster", v130
            end

            return
        end

        local CurrentRooms = workspace:FindFirstChild("CurrentRooms")

        if not CurrentRooms or not p9:IsDescendantOf(CurrentRooms) then
            return
        end

        local v132 = t2.value31[p9.Name]

        if v132 then
            local p9Parent = p9.Parent

            if p9Parent then
                p9Parent = t2.value31[p9.Parent.Name]
            end

            if p9Parent then
                return
            end

            return v132[1], v132[2]
        end

        local v134 = v27(p9)

        if v134 and v134 <= 0 then
            return
        end

        if t2.value27[p9.Name] then
            if t2.value28[p9.Name] then
                return "locker", "Hiding spot"
            end

            if v134 then
                v134 = v134 > 0 and not p9:FindFirstChild("GoldPile", true)
            end

            if v134 then
                return "gold", "Coins inside"
            end

            return
        end

        local v135 = p9.Name == "GoldPile"

        if not v135 then
            if v134 then
                v134 = v134 > 0
            end

            v135 = v134
        end

        if v135 then
            local p9Parent = p9.Parent

            while p9Parent and p9Parent ~= workspace do
                if p9Parent.Name == "GoldPile" then
                    return
                end

                p9Parent = p9Parent.Parent
            end

            return "gold", "Coins"
        end

        if t2.value29[p9.Name] then
            return "key", t2.value15[p9.Name]
        end

        local v137 = t2.value15[p9.Name]

        if v137 then
            local v138 = p9:IsA("BasePart")

            if v138 then
                v138 = p9.Parent

                if v138 then
                    v138 = t2.value15[p9.Parent.Name]
                end
            end

            if v138 then
                return
            end

            local HidePrompt = p9:FindFirstChild("HidePrompt", true)

            if not HidePrompt then
                HidePrompt = p9:GetAttribute("LoadModule") == "Wardrobe"
            end

            if HidePrompt then
                return
            end

            local v140 = p9:FindFirstChild("ModulePrompt", true) or p9:FindFirstChild("PickupPrompt", true)
            local v141 = p9:GetAttribute("Pickup") == true

            if not v141 then
                if not v140 then
                    v140 = p9:IsA("Tool")
                end

                v141 = v140
            end

            if v141 then
                return "item", v137
            end
        end
    end
    function t2.value33()
        for k in pairs(t2.value12) do
            local v145 = t2.value12[k]

            if v145 then
                if v145.highlight then
                    v145.highlight:Destroy()
                end

                v145.billboard:Destroy()
                t2.value12[k] = nil
            end
        end
    end

    local function v28(p10)
        if not t2.value7 then
            return
        end

        local v147, v148 = t2.value32(p10)

        if not v147 then
            if t2.value11[p10] then
                t2.value11[p10] = nil

                local v149 = t2.value12[p10]

                if not v149 then
                    return
                end

                if v149.highlight then
                    v149.highlight:Destroy()
                end

                v149.billboard:Destroy()
                t2.value12[p10] = nil
            end

            return
        end

        t2.value11[p10] = {
			kind = v147,
			label = v148
		}

        local v150 = v147 == "monster"

        if v150 then
            v150 = t2.value9.alerts and not t2.value13[p10]
        end

        if v150 then
            t2.value13[p10] = true
            v25(v148 .. " detected")
        end
    end
    local function v29(p11)
        local p11Parent = p11.Parent

        for _ = 1, 9 do
            if not p11Parent or p11Parent == workspace then
                return ""
            end

            local p11ParentName = p11Parent.Name
            local v155 = p11ParentName == "DrawerContainer"

            if not v155 then
                v155 = p11ParentName == "Drawer"

                if not v155 then
                    v155 = p11ParentName == "ChestBox" or p11ParentName == "ChestBoxLocked"
                end
            end

            if v155 then
                return " · inside"
            end

            p11Parent = p11Parent.Parent
        end

        return ""
    end

    function t2.value34(p12, p13, p14)
        local v159 = t2.value12[p12]

        if v159 then
            v159.billboard.Adornee = p14
            v159.text.TextColor3 = t2.value16[p13.kind]

            if v159.highlight then
                v159.highlight.FillColor = t2.value16[p13.kind]
                v159.highlight.OutlineColor = t2.value16[p13.kind]
            end

            return v159
        end

        local Highlight = Instance.new("Highlight")

        Highlight.Name = "SerpentHighlight"
        Highlight.Adornee = p12
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillColor = t2.value16[p13.kind]
        Highlight.OutlineColor = t2.value16[p13.kind]
        Highlight.FillTransparency = 0.82
        Highlight.OutlineTransparency = 0.15
        Highlight.Parent = t2.value17

        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Name = "SerpentLabel"
        BillboardGui.Adornee = p14
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.fromOffset(220, 36)
        BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
        BillboardGui.MaxDistance = p13.kind ~= "monster" and 650 or 3000
        BillboardGui.Parent = t2.value18

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = t2.value16[p13.kind]
        TextLabel.TextStrokeColor3 = Color3.fromRGB(5, 5, 8)
        TextLabel.TextStrokeTransparency = 0.25
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 12
        TextLabel.TextWrapped = true
        TextLabel.Parent = BillboardGui

        local t5 = {
			highlight = Highlight,
			billboard = BillboardGui,
			text = TextLabel
		}

        t2.value12[p12] = t5

        return t5
    end
    function t2.value35()
        local num = tonumber(t2.value5:GetAttribute("CurrentRoom"))

        if num then
            return num
        end

        local GameData = t2.value2:FindFirstChild("GameData")
        local v166 = GameData and GameData:FindFirstChild("LatestRoom")

        if v166 then
            v166 = tonumber(v166.Value)
        end

        return v166 or nil
    end

    local function v30()
        local CurrentRooms = workspace:FindFirstChild("CurrentRooms")
        local v168 = t2.value35()

        if not CurrentRooms or not v168 then
            return
        end

        for _, v in ipairs({
			v168,
			v168 + 1
		}) do
            local t6 = { (tostring(v)) }
            local v172 = CurrentRooms:FindFirstChild(v2(t6))
            local v173 = v172

            if v172 then
                v173 = v172:FindFirstChild("Door")
            end

            local v174 = v173

            if v173 then
                v174 = v173:IsA("Model") or v173:IsA("BasePart")

                if v174 then
                    v174 = v173:GetAttribute("Opened") ~= true

                    if v174 then
                        v174 = v172:GetAttribute("Opened") ~= true
                    end
                end
            end

            if v174 then
                return v173
            end
        end
    end

    t2.value36 = nil
    t2.value37 = t2.value6:AddLabel({
		Text = "Waiting for loaded rooms…"
	})

    function t2.value38()
        local CurrentCamera = workspace.CurrentCamera
        local Character = t2.value5.Character
        local v177 = Character
        if Character then
            v177 = Character:FindFirstChild("HumanoidRootPart")
        end
        if v177 then
            v177 = v177.Position
        end
        if not v177 then
            if CurrentCamera then
                CurrentCamera = CurrentCamera.CFrame.Position
            end

            v177 = CurrentCamera
        end
        local v178 = t2.value9.door and v30()
        local value36 = t2.value36
        local v180 = v178 or nil
        if value36 and v180 ~= t2.value36 then
            local value36_2 = t2.value36
            local v182 = t2.value12[value36_2]

            if v182 then
                if v182.highlight then
                    v182.highlight:Destroy()
                end

                v182.billboard:Destroy()
                t2.value12[value36_2] = nil
            end
        end
        t2.value36 = v180
        local t7 = {}
        for v186, v187 in pairs(t2.value11) do

            local v188 = not v186.Parent

            if not v188 then
                v188 = not v186:IsDescendantOf(workspace)

                if not v188 then
                    v188 = false

                    if v187.kind ~= "monster" then
                        local CurrentRooms = workspace:FindFirstChild("CurrentRooms")

                        v188 = not (CurrentRooms and v186:IsDescendantOf(CurrentRooms))
                    end
                end
            end

            if v188 then
                local v190 = t2.value12[v186]

                if v190 then
                    if v190.highlight then
                        v190.highlight:Destroy()
                    end

                    v190.billboard:Destroy()
                    t2.value12[v186] = nil
                end

                t2.value11[v186] = nil
            else
                local v191, v192 = t2.value32(v186)

                if v191 then
                    v187.kind = v191
                    v187.label = v192
                end

                if v191 then
                    v191 = v187.kind == "monster"

                    if v191 then
                        v191 = t2.value9.monsters
                    end

                    if not v191 then
                        v191 = v187.kind == "gold"

                        if v191 then
                            v191 = t2.value9.loot
                        end

                        if not v191 then
                            v191 = v187.kind == "item"

                            if v191 then
                                v191 = t2.value9.loot

                                if v191 then
                                    v191 = not t2.value9.coinsOnly
                                end
                            end

                            if not v191 then
                                v191 = v187.kind == "key"

                                if v191 then
                                    v191 = t2.value9.keys

                                    if not v191 then
                                        v191 = t2.value9.breakerESP

                                        if v191 then
                                            v191 = v186.Name == "ElectricalKeyObtain"
                                        end
                                    end
                                end

                                if not v191 then
                                    v191 = v187.kind == "locker"

                                    if v191 then
                                        v191 = t2.value9.lockers
                                    end

                                    if not v191 then
                                        v191 = v187.kind == "libraryItem"

                                        if v191 then
                                            v191 = t2.value9.libraryESP

                                            if not v191 then
                                                v191 = t2.value9.loot

                                                if v191 then
                                                    v191 = not t2.value9.coinsOnly
                                                end
                                            end
                                        end

                                        if not v191 then
                                            v191 = v187.kind == "libraryLock"

                                            if v191 then
                                                v191 = t2.value9.libraryESP
                                            end

                                            if not v191 then
                                                v191 = v187.kind == "breakerPart"

                                                if v191 then
                                                    v191 = t2.value9.breakerESP

                                                    if not v191 then
                                                        v191 = t2.value9.loot

                                                        if v191 then
                                                            v191 = not t2.value9.coinsOnly
                                                        end
                                                    end
                                                end

                                                if not v191 then
                                                    v191 = v187.kind == "breakerPanel"

                                                    if v191 then
                                                        v191 = t2.value9.breakerESP
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if v191 then
                    local v193 = if not v186:IsA("BasePart") then if not v186:IsA("Model") then nil else v186.PrimaryPart or v186:FindFirstChildWhichIsA("BasePart", true) else v186

                    if v193 and v177 then
                        local Magnitude = (v193.Position - v177).Magnitude

                        if Magnitude <= (v187.kind ~= "monster" and 650 or 3000) then
                            local insert = table.insert
                            local v196 = v187.kind == "monster" and 1

                            if not v196 then
                                v196 = v187.kind ~= "key" and 3 or 2
                            end

                            insert(t7, {
								object = v186,
								entry = v187,
								part = v193,
								distance = Magnitude,
								priority = v196
							})
                        end
                    end
                end
            end
        end
        if v180 then
            local v197 = if not v180:IsA("BasePart") then if not v180:IsA("Model") then nil else v180.PrimaryPart or v180:FindFirstChildWhichIsA("BasePart", true) else v180

            if v197 and v177 then
                local insert = table.insert
                local Magnitude = (v197.Position - v177).Magnitude
                local t8 = {
					kind = "door",
					label = "Next door"
				}

                insert(t7, {
					object = v180,
					part = v197,
					distance = Magnitude,
					entry = t8,
					priority = 0
				})
            end
        end
        table.sort(t7, function(p15, p16)
            if p15.priority ~= p16.priority then
                return p15.priority < p16.priority
            end

            return p15.distance < p16.distance
        end)
        local t9 = {}
        for i = 1, math.min(80, #t7) do
            local v203 = i
            local v204 = t7[v203]

            t9[v204.object] = true

            local v205 = v203 <= 24

            if v205 then
                v205 = t2.value12[v204.object]

                if v205 then
                    v205 = not t2.value12[v204.object].highlight
                end
            end

            if v205 then
                local object = v204.object
                local v207 = t2.value12[object]

                if v207 then
                    if v207.highlight then
                        v207.highlight:Destroy()
                    end

                    v207.billboard:Destroy()
                    t2.value12[object] = nil
                end
            end

            local v208 = t2.value34(v204.object, v204.entry, v204.part)

            if v203 > 24 and v208.highlight then
                v208.highlight:Destroy()
                v208.highlight = nil
            end

            local label = v204.entry.label

            if v204.entry.kind == "gold" then
                local v210 = v27(v204.object)

                if type(v210) == "number" then
                    local v211 = t2.value27[v204.object.Name] and "Coins inside +"

                    if not v211 then
                        v211 = "Coins +"
                    end

                    label = v211 .. tostring(v210)
                end
            end

            local v212 = v204.entry.kind == "gold"

            if not v212 then
                v212 = v204.entry.kind == "item"
            end

            if v212 then
                label ..= v29(v204.object)
            end

            v208.text.Text = label .. " · " .. math.floor(v204.distance) .. " studs"
        end
        for k in pairs(t2.value12) do
            local v214 = k

            if not t9[v214] then
                local v215 = t2.value12[v214]

                if v215 then
                    if v215.highlight then
                        v215.highlight:Destroy()
                    end

                    v215.billboard:Destroy()
                    t2.value12[v214] = nil
                end
            end
        end
    end

    t2.value39 = nil
    t2.value40 = nil
    t2.value41 = nil
    t2.value42 = nil

    function t2.value43()
        if t2.value40 then
            t2.value40:Disconnect()
        end

        local value39 = t2.value39

        if value39 then
            value39 = t2.value39.Parent and t2.value41
        end

        if value39 then
            t2.value39.WalkSpeed = t2.value41
        end

        t2.value39 = nil
        t2.value41 = nil
        t2.value42 = nil
    end

    local function v31()
        local Character = t2.value5.Character
        local v218 = Character and Character:FindFirstChildOfClass("Humanoid")

        if not t2.value9.speed then
            if t2.value39 then
                t2.value43()
            end

            return
        end

        if v218 ~= t2.value39 then
            t2.value43()
            t2.value39 = v218

            if v218 then
                t2.value41 = v218.WalkSpeed
                v218:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    local value7 = t2.value7

                    if value7 then
                        value7 = t2.value39 == v218

                        if value7 then
                            value7 = v218.WalkSpeed ~= t2.value42
                        end
                    end

                    if value7 then
                        t2.value41 = v218.WalkSpeed
                    end
                end)
            end
        end

        local v219 = not v218

        if not v219 then
            v219 = v218.Health <= 0
        end

        if v219 then
            return
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local v221 = not HumanoidRootPart

        if not v221 then
            v221 = HumanoidRootPart.Anchored

            if not v221 then
                v221 = v218.PlatformStand or t2.value41 == 0
            end
        end

        if v221 then
            return
        end

        if v218.WalkSpeed ~= t2.value10 then
            v218.WalkSpeed = t2.value10
        end
    end

    local color3_7 = Color3.fromRGB(190, 190, 190)
    local color3_8 = Color3.fromRGB(190, 190, 190)

    t2.value44 = {
		Brightness = 2.5,
		Ambient = color3_7,
		OutdoorAmbient = color3_8,
		GlobalShadows = false,
		FogEnd = 100000,
		FogStart = 0
	}
    t2.value45 = nil
    t2.value46 = {}

    local function v34()
        if t2.value45 then
            for k, v in pairs(t2.value45) do
                t2.value4[k] = v
            end

            t2.value45 = nil
        end

        for k, v in pairs(t2.value46) do
            local v226 = k

            if v226.Parent then
                for k2, v3 in pairs(v) do
                    v226[k2] = v3
                end
            end
        end

        table.clear(t2.value46)
    end

    function t2.value47()
        local n1 = 13505244
        if not t2.value9.fullbright then
            if t2.value45 then
                v34()
            end

            return
        end
        if not t2.value45 then
            n1 = {}
            t2.value45 = n1

            for k in pairs(t2.value44) do
                t2.value45[k] = t2.value4[k]
            end
        end
        for v233, v234 in pairs(t2.value44) do

            if v234 ~= t2.value4[v233] then
                local v235 = t2.value4[v233]

                t2.value45[v233] = v235
                t2.value4[v233] = v234
            end
        end
        for _, v in ipairs({
			t2.value4,
			workspace.CurrentCamera
		}) do
            for _, child in ipairs(v:GetChildren()) do
                local t10
                if child:IsA("ColorCorrectionEffect") then
                    t10 = {
						Enabled = false
					}
                elseif child:IsA("Atmosphere") then
                    t10 = {
						Density = 0,
						Haze = 0
					}
                end
                if t10 then
                    t2.value46[child] = t2.value46[child] or {}

                    for k, v5 in pairs(t10) do
                        local v243 = k

                        if t2.value46[child][v243] == nil or v5 ~= child[v243] then
                            t2.value46[child][v243] = child[v243]
                        end

                        child[v243] = v5
                    end
                end
            end
        end
    end

    t2.value48 = {}
    t2.value49 = {}
    t2.value50 = {}
    t2.value51 = "_____"
    t2.value52 = nil
    t2.value53 = nil
    t2.value54 = nil
    t2.value55 = nil
    t2.value56 = {}
    t2.value57 = nil
    t2.value58 = nil
    t2.value59 = nil
    t2.value60 = nil
    t2.value61 = nil
    t2.value62 = 85
    t2.value8 = nil

    function t2.value63()
        if t2.value8 then
            local value8 = t2.value8

            pcall(function()
                if value8.camera.FieldOfView == value8.applied then
                    value8.camera.FieldOfView = value8.original
                end
            end)
            t2.value8 = nil
        end
    end

    local function v35()
        local v245 = not t2.value7

        if not v245 then
            v245 = t2.value6.Closing

            if not v245 then
                v245 = not t2.value9.fov
            end
        end

        if v245 then
            t2.value63()

            return
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            t2.value63()

            return
        end

        local value8 = t2.value8

        if value8 then
            value8 = CurrentCamera ~= t2.value8.camera
        end

        if value8 then
            t2.value63()
        end

        if not t2.value8 then
            local FieldOfView = CurrentCamera.FieldOfView

            t2.value8 = {
				camera = CurrentCamera,
				original = FieldOfView
			}
        elseif CurrentCamera.FieldOfView ~= t2.value8.applied then
            t2.value8.original = CurrentCamera.FieldOfView
        end

        t2.value8.applied = t2.value62
        CurrentCamera.FieldOfView = t2.value62
    end

    t2.value64 = Instance.new("Frame")
    t2.value64.Name = "SerpentPuzzleHUD"
    t2.value64.AnchorPoint = Vector2.new(1, 1)
    t2.value64.Position = UDim2.new(1, -14, 1, -20)
    t2.value64.Size = UDim2.new(0.85, 0, 0, 82)
    t2.value64.BackgroundColor3 = Color3.fromRGB(13, 16, 22)
    t2.value64.BackgroundTransparency = 0.12
    t2.value64.BorderSizePixel = 0
    t2.value64.Visible = false
    t2.value64.Parent = t2.value18

    local UISizeConstraint2 = Instance.new("UISizeConstraint")

    UISizeConstraint2.MaxSize = Vector2.new(290, 82)
    UISizeConstraint2.Parent = t2.value64

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 12)
    UICorner2.Parent = t2.value64
    t2.value65 = Instance.new("TextLabel")
    t2.value65.Position = UDim2.fromOffset(12, 8)
    t2.value65.Size = UDim2.new(1, -24, 1, -16)
    t2.value65.BackgroundTransparency = 1
    t2.value65.TextColor3 = Color3.fromRGB(225, 236, 255)
    t2.value65.Font = Enum.Font.GothamMedium
    t2.value65.TextSize = 13
    t2.value65.TextWrapped = true
    t2.value65.TextXAlignment = Enum.TextXAlignment.Left
    t2.value65.Parent = t2.value64

    function t2.value66()
        table.clear(t2.value48)
        table.clear(t2.value49)
        table.clear(t2.value50)
        t2.value51 = "_____"
        t2.value54 = nil
    end

    local function v38()
        for _, v in pairs({
			t2.value5.Character,
			t2.value5:FindFirstChild("Backpack")
		}) do
            local LibraryHintPaper = v:FindFirstChild("LibraryHintPaper")

            if not LibraryHintPaper then
                LibraryHintPaper = v:FindFirstChild("LibraryHintPaperHard")
            end

            if LibraryHintPaper then
                return LibraryHintPaper
            end
        end
    end

    function t2.value67()
        local CurrentRooms = workspace:FindFirstChild("CurrentRooms")
        local v257 = CurrentRooms
        if CurrentRooms then
            v257 = CurrentRooms:FindFirstChild("50")
        end
        local v258 = CurrentRooms ~= t2.value53
        if not v258 then
            v258 = v257 and v257 ~= t2.value52
        end
        if v258 then
            t2.value66()
        end
        local PlayerGui = t2.value5:FindFirstChild("PlayerGui")
        if PlayerGui then
            PlayerGui = PlayerGui:FindFirstChild("PermUI")
        end
        if PlayerGui then
            PlayerGui = PlayerGui:FindFirstChild("Hints")
        end
        if PlayerGui then
            for _, child in ipairs(PlayerGui:GetChildren()) do
                local v262 = not child:IsA("ImageLabel")

                if v262 then
                    v262 = not child:IsA("ImageButton")
                end

                local v263

                if v262 then
                    v263 = nil
                else
                    local ImageRectOffset = child.ImageRectOffset

                    v263 = if ImageRectOffset then tostring(ImageRectOffset.X) .. ":" .. tostring(ImageRectOffset.Y) else nil
                end

                local TextLabel = child:FindFirstChild("TextLabel")

                if TextLabel then
                    local v266 = TextLabel:IsA("TextLabel")

                    if v266 then
                        v266 = TextLabel.Text:match("^%s*(%d)%s*$")
                    end

                    TextLabel = v266
                end

                if v263 and TextLabel then
                    local v267 = t2.value50[v263]

                    if v267 and TextLabel == v267.digit then
                        v267.count = v267.count + 1

                        if v267.count >= 2 then
                            t2.value48[v263] = TextLabel
                        end
                    else
                        t2.value50[v263] = {
							digit = TextLabel,
							count = 1
						}

                        if t2.value48[v263] and TextLabel ~= t2.value48[v263] then
                            t2.value48[v263] = nil
                        end
                    end
                end
            end
        end
        local v268 = v38()
        if v268 then
            v268 = v268:FindFirstChild("UI")
        end
        if v268 then
            local t11 = {}
            for v272, v273 in ipairs(v268:GetChildren()) do

                local num = tonumber(v273.Name)
                local v275 = num

                if num then
                    v275 = num % 1 == 0

                    if v275 then
                        v275 = num >= 1 and num <= 5
                    end
                end

                if v275 then
                    local v276 = not v273:IsA("ImageLabel")

                    if v276 then
                        v276 = not v273:IsA("ImageButton")
                    end

                    local v277

                    if v276 then
                        v277 = nil
                    else
                        local ImageRectOffset = v273.ImageRectOffset

                        v277 = if ImageRectOffset then tostring(ImageRectOffset.X) .. ":" .. tostring(ImageRectOffset.Y) else nil
                    end

                    t11[num] = v277
                end
            end
            for k, v in pairs(t11) do
                t2.value49[k] = v
            end
        end
        local n2 = 0
        local t12 = {}
        for i = 1, 5 do
            local v284 = i
            local v285 = t2.value49[v284]

            if v285 then
                v285 = t2.value48[t2.value49[v284]]
            end

            t12[v284] = v285 or "_"

            if v285 then
                n2 += 1
            end
        end
        t2.value51 = table.concat(t12)
        local v286 = "Library code: " .. table.concat(t12, " ") .. "  (" .. n2 .. "/5)"
        if not next(t2.value49) then
            v286 ..= "\nPick up the hint paper first."
        end
        if t2.value60 then
            t2.value60:SetText(v286)
        end
        if n2 == 5 and t2.value54 ~= t2.value51 then
            t2.value6:Notify("Library code: " .. t2.value51, 7)
        end

        return v286
    end

    local function v39(p17)
        while p17 and p17 ~= workspace do
            if p17:IsA("GuiObject") and not p17.Visible then
                return false
            end

            if p17:IsA("SurfaceGui") and not p17.Enabled then
                return false
            end

            p17 = p17.Parent
        end

        return true
    end
    local function v40(p18)
        if p18 then
            p18 = p18:FindFirstChild("SurfaceGui")
        end

        if p18 then
            p18 = p18:FindFirstChild("Frame")
        end

        if p18 then
            p18 = p18:FindFirstChild("Code")
        end

        local v289 = not p18

        if not v289 then
            v289 = not p18:IsA("TextLabel") or not v39(p18)
        end

        if v289 then
            return
        end

        local v290 = p18.Text:gsub("<.->", ""):match("^%s*(.-)%s*$")

        if v290 == "" or #v290 > 12 then
            return
        end

        if v290 ~= t2.value55 then
            t2.value56[#t2.value56 + 1] = v290

            if #t2.value56 > 8 then
                table.remove(t2.value56, 1)
            end
        end

        return v290
    end

    function t2.value68()
        if not t2.value7 then
            return
        end
        local GameData = t2.value2:FindFirstChild("GameData")
        if GameData then
            GameData = GameData:FindFirstChild("LatestRoom")
        end
        if GameData then
            GameData = tonumber(GameData.Value)
        end
        if not GameData then
            GameData = t2.value35()
        end
        local v292 = GameData
        if GameData then
            v292 = t2.value57

            if v292 then
                v292 = GameData < t2.value57

                if v292 then
                    v292 = GameData <= 1
                end
            end
        end
        if v292 then
            t2.value66()
        end
        if not GameData then
            local _ = t2.value57
        end
        local v294
        if t2.value9.libraryCode then
            v294 = t2.value67()
        end
        local _workspace = workspace
        local CurrentRooms = _workspace:FindFirstChild("CurrentRooms")
        local v297 = CurrentRooms
        if CurrentRooms then
            v297 = CurrentRooms:FindFirstChild("100")
        end
        local breakerHelper = t2.value9.breakerHelper
        if breakerHelper then
            breakerHelper = v297 and v297:FindFirstChild("ElevatorBreaker", true)
        end
        local v299 = breakerHelper
        local v300 = v299 ~= t2.value58
        if not v300 then
            v300 = v299

            if v300 then
                v300 = not t2.value59
            end
        end
        if v300 then
            if t2.value59 then
                t2.value59:Disconnect()
                t2.value59 = nil
            end

            t2.value58 = nil
            t2.value55 = nil
            table.clear(t2.value56)

            local v301 = v299

            if v301 then
                v301 = v299:FindFirstChild("SurfaceGui")
            end

            if v301 then
                v301 = v301:FindFirstChild("Frame")
            end

            local v302 = v301 and v301:FindFirstChild("Code")

            _workspace = v299

            local v303 = v302

            if v302 then
                v303 = v302:IsA("TextLabel")
            end

            if v303 then
                v302:GetPropertyChangedSignal("Text"):Connect(function()
                    local value7 = t2.value7

                    if value7 then
                        value7 = t2.value9.breakerHelper
                    end

                    if value7 then
                        local v377 = v299

                        v40(v377)
                    end
                end)
            end
        end
        local n3 = 0
        local v305 = v297
        if v297 then
            v305 = t2.value9.breakerESP

            if not v305 then
                v305 = t2.value9.breakerHelper
            end
        end
        if v305 then
            for k, v in pairs(t2.value11) do
                local v308 = k
                local v309 = v.kind == "breakerPart"

                if v309 then
                    v309 = v308.Parent and v308:IsDescendantOf(v297)
                end

                if v309 then
                    n3 += 1
                end
            end
        end
        local v310 = v299 and v40(v299)
        local v311 = "Loaded breaker parts: " .. n3
        local v312 = if not v310 then v311 .. "\nInteract with the breaker panel to see its display." else v311 .. "\nDisplay: " .. v310
        if t2.value61 then
            t2.value61:SetText(v312)
        end
        t2.value64.Visible = false
        local libraryCode = t2.value9.libraryCode
        if libraryCode then
            libraryCode = GameData == 50

            if libraryCode then
                libraryCode = CurrentRooms and CurrentRooms:FindFirstChild("50")
            end
        end
        if libraryCode then
            t2.value65.Text = v294 or "Library: waiting for clues"
            t2.value64.Visible = true

            return
        end
        if t2.value9.breakerHelper and GameData == 100 then
            t2.value65.Text = v312
            t2.value64.Visible = true
        end
    end

    local function v41(p19, p20)
        local value6 = t2.value6
        local AddToggle = value6.AddToggle
        local v324 = t2.value9[p20] == true

        AddToggle(value6, {
			Name = p19,
			Default = v324,
			Callback = function(p21)
            if not t2.value7 then
                return
            end

            t2.value9[p20] = p21

            if p20 == "alerts" then
                if p21 then
                    for k, v in pairs(t2.value11) do
                        local v381 = k
                        local v382 = v.kind == "monster"

                        if v382 then
                            v382 = v381.Parent and not t2.value13[v381]
                        end

                        if v382 then
                            t2.value13[v381] = true
                            v25(v.label .. " detected")
                        end
                    end
                else
                    t2.value25()
                end
            end

            if p20 == "speed" and not p21 then
                t2.value43()
            end

            if p20 == "fullbright" then
                t2.value47()
            end

            if p20 == "fov" then
                v35()
            end

            local v383 = p20 == "libraryCode"

            if not v383 then
                v383 = p20 == "breakerHelper"

                if not v383 then
                    v383 = p20 == "breakerESP"
                end
            end

            if v383 then
                t2.value68()
            end

            t2.value38()
        end
		})
    end

    t2.value6:AddSection({
		Name = "Awareness"
	})
    v41("Monster ESP", "monsters")
    v41("Entity alerts", "alerts")
    v41("Next door ESP", "door")
    v41("Room keys ESP", "keys")
    v41("Hiding spots ESP", "lockers")
    v41("Fullbright", "fullbright")
    t2.value6:AddSection({
		Name = "Loot"
	})
    v41("Items & coins ESP", "loot")
    v41("Coins only", "coinsOnly")
    t2.value6:AddSection({
		Name = "Library · Room 50"
	})
    v41("Books / hint paper / padlock ESP", "libraryESP")
    v41("Remember symbols / library code", "libraryCode")
    t2.value60 = t2.value6:AddLabel({
		Text = "Library code: _ _ _ _ _",
		Height = 62
	})
    t2.value6:AddButton({
		Name = "Copy known library code",
		Callback = function()
        t2.value67()

        if not t2.value51:match("^%d%d%d%d%d$") then
            t2.value6:Notify("Code is incomplete", 4)

            return
        end

        if type(setclipboard) == "function" then
            setclipboard(t2.value51)
            t2.value6:Notify("Code copied", 3)

            return
        end

        t2.value6:Notify("Library code: " .. t2.value51, 7)
    end
	})
    t2.value6:AddButton({
		Name = "Enter known code near padlock",
		Callback = function()
        t2.value67()

        if not t2.value51:match("^%d%d%d%d%d$") then
            t2.value6:Notify("Find all five required clues and the hint paper first", 5)

            return
        end

        local CurrentRooms = workspace:FindFirstChild("CurrentRooms")
        local v315 = CurrentRooms and CurrentRooms:FindFirstChild("50")
        local v316 = v315 and v315:FindFirstChild("Padlock", true)

        if v316 then
            v316 = if not v316:IsA("BasePart") then if not v316:IsA("Model") then nil else v316.PrimaryPart or v316:FindFirstChildWhichIsA("BasePart", true) else v316
        end

        local Character = t2.value5.Character

        if Character then
            Character = t2.value5.Character:FindFirstChild("HumanoidRootPart")
        end

        local v318 = not Character

        if not v318 then
            v318 = not v316

            if not v318 then
                v318 = (Character.Position - v316.Position).Magnitude > 12
            end
        end

        if v318 then
            t2.value6:Notify("Move closer to the library padlock", 5)

            return
        end

        local RemotesFolder = t2.value2:FindFirstChild("RemotesFolder")

        if RemotesFolder then
            RemotesFolder = RemotesFolder:FindFirstChild("PL")
        end

        if not RemotesFolder or not RemotesFolder:IsA("RemoteEvent") then
            t2.value6:Notify("Padlock input unavailable in this game version", 5)

            return
        end

        RemotesFolder:FireServer(t2.value51)
        t2.value6:Notify("Known code submitted", 3)
    end
	})
    t2.value6:AddSection({
		Name = "Electrical room · Room 100"
	})
    v41("Breaker parts / key / panel ESP", "breakerESP")
    v41("Breaker display helper", "breakerHelper")
    t2.value61 = t2.value6:AddLabel({
		Text = "Enter room 100 to find the breaker parts and panel",
		Height = 72
	})
    t2.value6:AddLabel({
		Text = "The helper reads the panel display. It does not automatically solve the breaker puzzle.",
		Height = 52
	})
    t2.value6:AddSection({
		Name = "Camera"
	})
    v41("FOV override", "fov")
    t2.value6:AddSlider({
		Name = "Camera FOV",
		Min = 60,
		Max = 120,
		Default = 85,
		Step = 1,
		Callback = function(p22)
        t2.value62 = p22
        v35()
    end
	})
    t2.value6:AddSection({
		Name = "Player"
	})
    v41("Speed override", "speed")
    t2.value6:AddSlider({
		Name = "Walk speed",
		Min = 10,
		Max = 30,
		Default = 20,
		Step = 1,
		Callback = function(p23)
        t2.value10 = p23
    end
	})
    t2.value6:AddLabel({
		Tab = "Settings",
		Text = "Alerts detect spawned entities. Hidden loot is shown only when replicated.",
		Height = 70
	})
    t2.value69 = {}
    t2.value70 = 1
    t2.value71 = 0
    t2.value72 = nil
    t2.value72 = {}

    function t2.value73(p24)
        local v328 = not t2.value7

        if not v328 then
            v328 = t2.value72[p24]

            if not v328 then
                v328 = not (p24:IsA("Model") or p24:IsA("BasePart"))

                if not v328 then
                    v328 = p24:IsDescendantOf(t2.value17)
                end
            end
        end

        if v328 then
            return
        end

        t2.value72[p24] = true
        t2.value71 = t2.value71 + 1
        t2.value69[t2.value71] = p24
    end

    t2.value6:Track(workspace.DescendantAdded:Connect(function(descendant)
        t2.value73(descendant)

        local v330 = descendant:IsA("Model") or descendant:IsA("BasePart")

        if v330 then
            v330 = not descendant:IsDescendantOf(t2.value17)
        end

        if v330 then
            task.delay(0.4, function()
                local value7 = t2.value7

                if value7 then
                    value7 = descendant.Parent
                end

                if value7 then
                    local v385 = descendant

                    t2.value73(v385)
                end
            end)
        end
    end))
    t2.value6:Track(workspace.DescendantRemoving:Connect(function(descendant)
        if t2.value11[descendant] then
            t2.value11[descendant] = nil

            local v332 = t2.value12[descendant]

            if v332 then
                if v332.highlight then
                    v332.highlight:Destroy()
                end

                v332.billboard:Destroy()
                t2.value12[descendant] = nil
            end
        end

        if descendant == t2.value36 then
            local v333 = t2.value12[descendant]

            if not v333 then
                return
            end

            if v333.highlight then
                v333.highlight:Destroy()
            end

            v333.billboard:Destroy()
            t2.value12[descendant] = nil
        end
    end))
    t2.value74 = task.spawn(function()
        for i, descendant in ipairs(workspace:GetDescendants()) do
            if not t2.value7 then
                return
            end

            t2.value73(descendant)

            if i % 400 == 0 then
                task.wait()
            end
        end
    end)
    t2.value75 = -1e999

    function t2.value76(p25)
        local ok, result = pcall(p25)
        local v339 = not ok

        if v339 then
            v339 = os.clock() - t2.value75 > 8
        end

        if v339 then
            os.clock()
            warn("[SerpentHub DOORS] " .. tostring(result))
            t2.value6:Notify("Feature error: " .. tostring(result):sub(1, 150), 7)
        end
    end

    t2.value77 = 0
    t2.value78 = 0
    t2.value6:Track(t2.value1.Heartbeat:Connect(function(dt)
        local v341 = not t2.value7

        if not v341 then
            v341 = t2.value6.Closing
        end

        if v341 then
            return
        end

        t2.value76(v31)

        local v342 = t2.value77 + dt
        local v343 = t2.value78 + dt

        t2.value77 = v342
        t2.value78 = v343

        if t2.value77 < 0.2 then
            return
        end

        for _ = 1, 160 do
            if t2.value70 > t2.value71 then
                break
            end

            local value70 = t2.value70
            local v346 = t2.value69[value70]

            t2.value69[t2.value70] = nil
            t2.value70 = t2.value70 + 1
            t2.value72[v346] = nil

            if v346.Parent then
                v28(v346)
            end
        end

        if t2.value70 > t2.value71 then
            t2.value69 = {}
        end

        t2.value76(t2.value38)
        t2.value76(t2.value26)
        t2.value76(t2.value68)
        t2.value76(t2.value47)

        if t2.value78 >= 4 then
            local CurrentRooms = workspace:FindFirstChild("CurrentRooms")
            local v348 = t2.value35()

            if CurrentRooms then
                local GetChildren = CurrentRooms.GetChildren
                for v352, v353 in ipairs(GetChildren(CurrentRooms)) do

                    local num = tonumber(v353.Name)
                    local v355 = not v348

                    if not v355 then
                        if num then
                            num = math.abs(num - v348) <= 2
                        end

                        v355 = num
                    end

                    if v355 then
                        for _, descendant in ipairs(v353:GetDescendants()) do
                            t2.value73(descendant)
                        end
                    end
                end
                local n4 = 0
                for _ in pairs(t2.value12) do
                    n4 += 1
                end
                t2.value37:SetText(v348 and "Room " .. v348 or "Rooms loaded" .. " · " .. n4 .. " markers")

                return
            end

            t2.value37:SetText("Enter a run · waiting for CurrentRooms")
        end
    end))
    t2.value79 = "SerpentHub_DOORS_FOV"
    t2.value1:BindToRenderStep(t2.value79, Enum.RenderPriority.Camera.Value + 1, function()
        t2.value76(v35)
    end)
    t2.value6:OnDestroy(function()
        t2.value9.speed = false
        pcall(task.cancel, t2.value74)
        t2.value1:UnbindFromRenderStep(t2.value79)
        t2.value63()

        if t2.value59 then
            t2.value59:Disconnect()
            t2.value59 = nil
        end

        t2.value58 = nil
        t2.value55 = nil
        table.clear(t2.value56)
        t2.value43()
        v34()
        t2.value25()
        t2.value33()
        t2.value17:Destroy()
        t2.value18:Destroy()
        table.clear(t2.value11)
        table.clear(t2.value69)
        table.clear(t2.value72)
    end)

    return t2.value6
end
t1.value2 = "https://raw.githubusercontent.com/rayware/SerpentUI/refs/heads/main/ui"
t1.value3 = _G
local SerpentHub_DOORS_Session = t1.value3.SerpentHub_DOORS_Session
local v4 = type(SerpentHub_DOORS_Session) == "table"
if v4 then
    v4 = type(SerpentHub_DOORS_Session.Cancel) == "function"
end
if v4 then
    pcall(SerpentHub_DOORS_Session.Cancel)
end
local LocalPlayer = game:GetService("Players").LocalPlayer
assert(LocalPlayer, "[SerpentHub] Run this as a client script inside Roblox")
t1.value4 = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
assert(t1.value4, "[SerpentHub] PlayerGui is not ready; wait for the game to load")

local function v6(p26, p27, p28)
    local v45 = Instance.new(p26)
    local _pairs = pairs

    if not p28 then
        p28 = {}
    end

    for v47, v48 in _pairs(p28) do
        v45[v47] = v48
    end

    v45.Parent = p27

    return v45
end
return ((function()
    local t13 = {
		finished = false,
		cancelled = false,
		artifacts = {}
	}
    t1.value3.SerpentHub_DOORS_Session = t13
    local v50 = v6("ScreenGui", t1.value4, {
		Name = "SerpentHub_DOORS_Loading",
		ResetOnSpawn = false,
		DisplayOrder = 150
	})
    local v51 = v6
    local vector2 = Vector2.new(0.5, 0.5)
    local uDim2 = UDim2.fromScale(0.5, 0.5)
    local uDim2_2 = UDim2.new(0.9, 0, 0, 190)
    local color3 = Color3.fromRGB(17, 19, 25)
    local v56 = v51("Frame", v50, {
		AnchorPoint = vector2,
		Position = uDim2,
		Size = uDim2_2,
		BackgroundColor3 = color3,
		BorderSizePixel = 0
	})
    v6("UISizeConstraint", v56, {
		MaxSize = Vector2.new(410, 190)
	})
    v6("UICorner", v56, {
		CornerRadius = UDim.new(0, 15)
	})
    v6("UIStroke", v56, {
		Color = Color3.fromRGB(255, 113, 82),
		Transparency = 0.35
	})
    local v57 = v6
    local GothamBold = Enum.Font.GothamBold
    local color3_9 = Color3.new(1, 1, 1)
    local uDim2_3 = UDim2.fromOffset(16, 10)
    local uDim2_4 = UDim2.new(1, -60, 0, 30)
    local Left = Enum.TextXAlignment.Left
    v57("TextLabel", v56, {
		Text = "SerpentHub · DOORS",
		Font = GothamBold,
		TextSize = 19,
		TextColor3 = color3_9,
		BackgroundTransparency = 1,
		Position = uDim2_3,
		Size = uDim2_4,
		TextXAlignment = Left
	})
    local v63 = v6
    local Gotham = Enum.Font.Gotham
    local color3_10 = Color3.fromRGB(194, 203, 216)
    local uDim2_5 = UDim2.fromOffset(16, 46)
    local uDim2_6 = UDim2.new(1, -32, 0, 88)
    local Left2 = Enum.TextXAlignment.Left
    local Top = Enum.TextYAlignment.Top
    local v70 = v63("TextLabel", v56, {
		Text = "Downloading SerpentUI…",
		Font = Gotham,
		TextSize = 13,
		TextColor3 = color3_10,
		BackgroundTransparency = 1,
		Position = uDim2_5,
		Size = uDim2_6,
		TextWrapped = true,
		TextXAlignment = Left2,
		TextYAlignment = Top
	})
    local v71 = v6
    local GothamMedium = Enum.Font.GothamMedium
    local color3_11 = Color3.new(1, 1, 1)
    local uDim2_7 = UDim2.new(0, 16, 1, -42)
    local uDim2_8 = UDim2.new(0.5, -22, 0, 30)
    local color3_12 = Color3.fromRGB(45, 49, 62)
    local v77 = v71("TextButton", v56, {
		Text = "Retry",
		Font = GothamMedium,
		TextSize = 14,
		TextColor3 = color3_11,
		Position = uDim2_7,
		Size = uDim2_8,
		BackgroundColor3 = color3_12,
		Visible = false
	})
    v6("UICorner", v77, {
		CornerRadius = UDim.new(0, 8)
	})
    local v78 = v6
    local GothamMedium2 = Enum.Font.GothamMedium
    local color3_13 = Color3.new(1, 1, 1)
    local uDim2_9 = UDim2.new(0.5, 6, 1, -42)
    local uDim2_10 = UDim2.new(0.5, -22, 0, 30)
    local color3_14 = Color3.fromRGB(45, 49, 62)
    local v84 = type(readfile)
    local v85 = v78("TextButton", v56, {
		Text = "Local SerpentUI.lua",
		Font = GothamMedium2,
		TextSize = 12,
		TextColor3 = color3_13,
		Position = uDim2_9,
		Size = uDim2_10,
		BackgroundColor3 = color3_14,
		Visible = v84 == "function"
	})
    v6("UICorner", v85, {
		CornerRadius = UDim.new(0, 8)
	})
    local v86 = v6
    local Gotham2 = Enum.Font.Gotham
    local color3_15 = Color3.new(1, 1, 1)
    local uDim2_11 = UDim2.new(1, -42, 0, 7)
    local uDim2_12 = UDim2.fromOffset(34, 34)
    local v91 = v86("TextButton", v56, {
		Text = "×",
		Font = Gotham2,
		TextSize = 22,
		TextColor3 = color3_15,
		Position = uDim2_11,
		Size = uDim2_12,
		BackgroundTransparency = 1
	})
    local thread
    local thread2
    local u94 = false
    local n5 = 0
    local function v96(p29)
        local v361 = p29

        if p29 then
            v361 = p29 ~= coroutine.running()
        end

        if v361 then
            pcall(task.cancel, p29)
        end
    end
    local function v97()
        if t13.window then
            pcall(function()
                t13.window:Destroy(true)
            end)
            t13.window = nil
        end

        for _, v in ipairs(t13.artifacts) do
            local v364 = v

            pcall(function()
                v364:Destroy()
            end)
        end

        t13.artifacts = {}
    end
    function t13.Cancel()
        if t13.cancelled then
            return
        end

        t13.cancelled = true
        n5 += 1
        v96(thread)
        v96(thread2)
        v97()
        v50:Destroy()

        if t1.value3.SerpentHub_DOORS_Session == t13 then
            t1.value3.SerpentHub_DOORS_Session = nil
        end
    end
    local function v98(p30)
        if t13.cancelled then
            return
        end

        u94 = true
        v96(thread2)
        v97()
        v70.Text = "Could not start: " .. tostring(p30):sub(1, 240) .. "\nRetry, or use a local SerpentUI.lua."
        v77.Visible = true
        v85.Visible = type(readfile) == "function"
        warn("[SerpentHub DOORS startup] " .. tostring(p30))
    end
    local function v99(p31)
        n5 += 1

        local v367 = n5

        v96(thread)
        v96(thread2)
        v97()
        u94 = false
        v70.Text = not p31 and "Downloading SerpentUI…" or "Reading local SerpentUI.lua…"
        v77.Visible = false
        thread = task.defer(function()
            local ok, result = xpcall(function()
                assert(type(loadstring) == "function", "Executor has no loadstring support")

                local v392

                if p31 then
                    assert(type(readfile) == "function", "Executor has no readfile support")
                    v392 = readfile("SerpentUI.lua")
                else
                    v392 = game:HttpGet(t1.value2)
                end

                if t13.cancelled or v367 ~= n5 then
                    return
                end

                assert(type(v392) == "string" and #v392 > 0, "SerpentUI download was empty")
                v70.Text = "Starting SerpentUI…"

                local v393, v394 = loadstring(v392)

                assert(v393, "SerpentUI compile error: " .. tostring(v394))

                local v395 = v393({
					Demo = false
				})
                local _assert = assert
                local v397 = type(v395) == "table"

                if v397 then
                    v397 = type(v395.CreateWindow) == "function"
                end

                _assert(v397, "SerpentUI did not return CreateWindow")
                v70.Text = "Building DOORS controls…"

                return t1.value1(v395, t13)
            end, function(err)
                return (tostring(err))
            end)

            if t13.cancelled or v367 ~= n5 then
                return
            end

            if not ok then
                v98(result)

                return
            end

            t13.finished = true

            local v388 = thread2

            v96(v388)
            v50:Destroy()
        end)
        thread2 = task.defer(function()
            task.wait(25)

            local cancelled = t13.cancelled

            if not cancelled then
                cancelled = t13.finished

                if not cancelled then
                    cancelled = v367 ~= n5 or u94
                end
            end

            if cancelled then
                return
            end

            local _ = n5 + 1

            v96(thread)
            v98("Startup timed out after 25 seconds. Check executor HTTP support / GitHub access.")
        end)
    end
    v91.Activated:Connect(t13.Cancel)
    v77.Activated:Connect(function()
        if not t13.cancelled then
            v99(false)
        end
    end)
    v85.Activated:Connect(function()
        if not t13.cancelled then
            v99(true)
        end
    end)
    v50.Destroying:Connect(function()
        local v368 = not t13.finished

        if v368 then
            v368 = not t13.cancelled
        end

        if v368 then
            t13.Cancel()
        end
    end)
    v99(false)

    return t13
end)())
