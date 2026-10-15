-- This file was generated at discord.gg/syncrypt

local t1 = {}
local v2 = unpack or table.unpack
local t2 = {}
if not game:IsLoaded() then
    game.Loaded:Wait()
end
t1.value1 = getgenv()
t1.value1.ChromaticaAutoMoveAimUntil = 0
t1.value1.ChromaticaAutoMoveAimTarget = nil
local v4 = not t1.value1.ChromaticaAutoMoveAimNamecallHookInstalled
if v4 then
    v4 = type(hookmetamethod) == "function" and type(getnamecallmethod) == "function"
end
if v4 then
    local u5
    local function v6(p1, ...)
        local v99 = getnamecallmethod()
        local t3 = { ... }
        local v101 = false

        if type(checkcaller) == "function" then
            local ok, result = pcall(checkcaller)

            v101 = ok and result or false
        end

        if not v101 and os.clock() <= (t1.value1.ChromaticaAutoMoveAimUntil or 0) then
            local ChromaticaAutoMoveAimTarget = t1.value1.ChromaticaAutoMoveAimTarget

            if ChromaticaAutoMoveAimTarget and ChromaticaAutoMoveAimTarget.Parent then
                if p1 == workspace and v99 == "Raycast" then
                    local v105 = t3[1]
                    local v106 = t3[2]

                    if typeof(v105) == "Vector3" and typeof(v106) == "Vector3" then
                        local v107 = ChromaticaAutoMoveAimTarget.Position - v105

                        if v107.Magnitude > 0 then
                            t3[2] = v107.Unit * math.max(v106.Magnitude, 1000)

                            return u5(p1, table.unpack(t3))
                        end
                    end
                else
                    local v108 = p1 == workspace

                    if v108 then
                        v108 = v99 == "FindPartOnRay"

                        if not v108 then
                            v108 = v99 == "FindPartOnRayWithIgnoreList" or v99 == "FindPartOnRayWithWhitelist"
                        end
                    end

                    if v108 then
                        local v109 = t3[1]

                        if typeof(v109) == "Ray" then
                            local Origin = v109.Origin
                            local v111 = ChromaticaAutoMoveAimTarget.Position - Origin

                            if v111.Magnitude > 0 then
                                t3[1] = Ray.new(Origin, v111.Unit * math.max(v109.Direction.Magnitude, 1000))

                                return u5(p1, table.unpack(t3))
                            end
                        end
                    else
                        local v112 = p1 == workspace.CurrentCamera

                        if v112 then
                            v112 = v99 == "ViewportPointToRay"

                            if not v112 then
                                v112 = v99 == "ScreenPointToRay"
                            end
                        end

                        if v112 then
                            local CurrentCamera = workspace.CurrentCamera

                            if CurrentCamera then
                                local CFramePosition = CurrentCamera.CFrame.Position
                                local v115 = ChromaticaAutoMoveAimTarget.Position - CFramePosition

                                if v115.Magnitude > 0 then
                                    return Ray.new(CFramePosition, v115.Unit * 1000)
                                end
                            end
                        end
                    end
                end
            end
        end

        return u5(p1, ...)
    end
    u5 = if type(newcclosure) ~= "function" then hookmetamethod(game, "__namecall", v6) else hookmetamethod(game, "__namecall", newcclosure(v6))
    t1.value1.ChromaticaAutoMoveAimNamecallHookInstalled = true
end
task.wait(0.1)
if getgenv().ChromaticaLibrary then
    pcall(function()
        getgenv().ChromaticaLibrary:Unload()
    end)
end
local s1 = "ChromaticaSession"
getgenv().ChromaticaSession = (getgenv().ChromaticaSession or 0) + 1
t1.value2 = getgenv().ChromaticaSession
t1.value3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
getgenv().ChromaticaLibrary = t1.value3
t1.value4 = t1.value3.Options
local Toggles = t1.value3.Toggles
t1.value5 = Toggles
t1.value6 = game:GetService("Players")
t1.value7 = game:GetService("ReplicatedStorage")
t1.value8 = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
t2[1] = { nil }
t2[1][1] = TweenService
t1.value9 = game:GetService("VirtualUser")
t1.value10 = t1.value6.LocalPlayer
if getgenv().ChromaticaAntiAFKConnection then
    pcall(function()
        getgenv().ChromaticaAntiAFKConnection:Disconnect()
    end)
end
local v10 = getgenv()
t2[12] = t1.value10.Idled:Connect(function()
    pcall(function()
        t1.value9:CaptureController()

        local value9 = t1.value9
        local t4 = { Vector2.new(0, 0) }

        value9:ClickButton2(v2(t4))
    end)
end)
v10.ChromaticaAntiAFKConnection = t2[12]
t1.value11 = nil
t1.value12 = false
t1.value13 = nil
t1.value14 = nil
t1.value15 = nil
local t5 = {}
local ok, result = pcall(function()
    return require(t1.value7.assets.config.Traits.traitConfig)
end)
t2[13] = result
if ok then
    t2[14] = type(t2[13])
    ok = t2[14] == "table"
end
if ok then
    t5 = t2[13]
end
local t6 = {}
t1.value16 = {}
for _, v in pairs(t5) do
    local v17 = type(v) == "table"

    if v17 then
        t2[15] = v.Enabled
        v17 = t2[15] ~= false

        if v17 then
            t2[16] = v.Id
            v17 = t2[16] ~= nil

            if v17 then
                t2[16] = s1
                t2[17] = type
                t2[18] = v.Name
                t2[19] = t2[17](t2[18])
                v17 = t2[19] == "string"

                if v17 then
                    t2[17] = v.Name
                    v17 = t2[17] ~= ""
                end

                s1 = t2[16]
            end
        end
    end

    if v17 then
        t2[20] = v.Id

        local vName = v.Name

        t1.value16[t2[20]] = vName

        local vName2 = v.Name

        t2[20] = v.Id;
        ({})[vName2] = t2[20]
        t2[20] = table.insert(t6, v.Name)
    end
end
table.sort(t6)
t2[2] = { nil }
t1.value17 = "Story"
t2[3] = { nil }
t2[4] = { nil }
t1.value18 = 1
t1.value19 = "Easy"
t1.value20 = 6
t1.value21 = false
t1.value22 = "Behind"
t1.value23 = 8
t1.value24 = 5
t1.value25 = 0
t2[4][1] = 85
t2[5] = { nil }
t1.value26 = nil
t1.value27 = nil
t1.value28 = nil
t1.value29 = 0
t2[2][1] = 0.08
t2[3][1] = 1.5
t1.value30 = nil
t1.value31 = nil
t1.value32 = nil
t2[5][1] = 18
t2[6] = { nil }
t2[7] = { nil }
t1.value33 = {
	["rbxassetid://131958743416355"] = true,
	["rbxassetid://99385727868022"] = true}
t1.value34 = 0
t2[7][1] = 0.25
t2[8] = { nil }
t2[8][1] = 4
t1.value35 = false
t1.value36 = 0
t1.value37 = 20
t1.value38 = 40
t2[6][1] = 60
t1.value39 = false
t1.value40 = nil
t1.value41 = 0.25
t1.value42 = 0
t1.value43 = 0
t2[9] = { nil }
t1.value44 = 0
t1.value45 = 0
t1.value46 = 0
t1.value47 = 0
t1.value48 = 0
t1.value49 = 0
t1.value50 = 0
t1.value51 = 0.3
t1.value52 = 1
t2[9][1] = 5
t1.value53 = false
t1.value54 = nil
t1.value55 = 0
t1.value56 = nil
t1.value57 = {
	LiftPromptDelay = 0.35,
	ActiveLiftPrompt = nil,
	NextLiftAttempt = 0
}
t1.value58 = 0
t1.value59 = 0
t1.value60 = 0
t1.value61 = 0
t1.value62 = 1
t1.value63 = {}
t1.value64 = 0
t1.value65 = 0
t1.value66 = nil
t1.value67 = nil
t1.value68 = nil
t1.value69 = nil
t1.value70 = nil
t1.value71 = 1.8
t1.value72 = 6
t1.value73 = "Normal"
t1.value74 = 1
t1.value75 = {}
t1.value76 = 0
t1.value77 = 0
t1.value78 = nil
t1.value79 = nil
t1.value80 = nil
t1.value81 = nil
t1.value82 = 0
t1.value83 = 0.9
t1.value84 = 6
t2[10] = { nil }
t2[10][1] = {
	luffy = "Rubber Man",
	goku = "Cosmic Warrior",
	killua = "Thunder Prodigy",
	juuzou = "Twisted Agony",
	nagumo = "Kings Gambit",
	saber = "Lights of Divinity",
	guts = "Dragon Eclipse",
	alucard = "Immortal Sovereign",
	sukuna = "Cursed King",
	shanks = "Divine Emperor",
	miyabi = "Cataclysm",
	katakuri = "Mochi Commander"
}
local t7 = {
	Easy = 1,
	Medium = 2,
	Hard = 3,
	Nightmare = 4
}
t1.value85 = t7
local t8 = {
	["Spirit's Bathtub"] = "BathTub",
	["Shadow Gate"] = "ShadowGate"
}
local t9 = {
	BathTub = "Spirit's Bathtub",
	ShadowGate = "Shadow Gate"
}
local t10 = {
	Map = "BathTub",
	FixedDifficulty = 4,
	SelectedMap = "BathTub",
	Tilt = 5,
	MapIds = t8,
	MapNames = t9
}
t1.value86 = {
	Story = {
		Map = "Hxh"
	},
	Infinite = {
		Map = "Zzz"
	},
	Trials = {
		Map = "Trials",
		FixedDifficulty = 1
	},
	Raid = t10
}
t1.value87 = {
	3,
	4
}
t1.value88 = {
	1,
	2,
	5,
	6
}
t1.value89 = {}
function t1.value89.GetRandomRoom()
    if math.random(1, 100) <= 75 then
        return t1.value87[math.random(1, #t1.value87)]
    end

    return t1.value88[math.random(1, #t1.value88)]
end
local value3 = t1.value3
local _UDim2 = UDim2
local CreateWindow = value3.CreateWindow
local v27 = _UDim2.fromOffset(30, 30)
local uDim2 = UDim2.fromOffset(720, 600)
t1.value90 = CreateWindow(value3, {
	Title = "Chromatica",
	Icon = "https://www.roblox.com/asset/?id=5575337837",
	IconSize = v27,
	Footer = "Anime Zero",
	Size = uDim2,
	Center = true,
	AutoShow = true,
	Resizable = true,
	MobileButtonsSide = "Left",
	NotifySide = "Right",
	ShowCustomCursor = true
})
local value90 = t1.value90
if value90 then
    value90 = t1.value90.MainFrame
end
t1.value91 = value90
if t1.value91 and t1.value91.Size.X.Offset < 480 or t1.value91.Size.Y.Offset < 360 then
    local u30
    local Heartbeat = t1.value8.Heartbeat
    t2[26] = function()
        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local ViewportSize = CurrentCamera.ViewportSize
        local v118 = ViewportSize.X - 64
        local v119 = ViewportSize.Y - 64
        local v120 = v118 < 480

        if not v120 then
            v120 = v119 < 360
        end

        if v120 then
            return
        end

        local v121 = math.min(720, v118)
        local v122 = math.min(600, v119)

        t1.value3.OriginalMinSize = Vector2.new(math.min(480, v118), (math.min(360, v119)))
        t1.value3.MinSize = Vector2.new(math.min(256, v118), t1.value3.OriginalMinSize.Y)
        t1.value91.Size = UDim2.fromOffset(v121, v122)
        t1.value91.Position = UDim2.new(0.5, -v121 / 2, 0.5, -v122 / 2)
        pcall(function()
            t1.value90:SetSidebarWidth((math.ceil(v121 * 0.3)))
        end)

        if u30 then
            u30:Disconnect()
            u30 = nil
        end
    end
    u30 = Heartbeat:Connect(t2[26])
    t2[26] = t1.value3:GiveSignal(u30)
end
t1.value92 = "ChRmZe0_16!"
t1.value93 = "https://discord.gg/xtfTcgwW7X"
t1.value94 = "ChromaticaZeroKey.txt"
t1.value95 = false
if isfile and readfile then
    local ok2, result2 = pcall(function()
        if isfile(t1.value94) then
            return readfile(t1.value94)
        end
    end)

    if ok2 then
        ok2 = tostring(result2 or "") == t1.value92
    end

    if ok2 then
        t1.value95 = true
    end
end
t1.value96 = Instance.new("BindableEvent")
local v34 = t1.value90:AddKeyTab("Key System", "https://www.roblox.com/asset/?id=2017917249")
v34:AddLabel({
	Text = "Chromatica Zero",
	DoesWrap = true,
	Size = 18
})
v34:AddLabel({
	Text = "Enter the key to unlock Chromatica Zero.",
	DoesWrap = true
})
v34:AddLabel({
	Text = "The key is available in the Chromatica Discord.",
	DoesWrap = true
})
v34:AddButton({
	Text = "Copy Discord Invite",
	Func = function()
    local v123 = setclipboard or (toclipboard or set_clipboard)

    if type(v123) == "function" then
        local ok3 = pcall(v123, t1.value93)
        local value3_2 = t1.value3
        local v126 = ok3 and "Discord invite copied to clipboard." or "Failed to copy the Discord invite."

        value3_2:Notify({
				Title = "Chromatica Zero",
				Description = v126,
				Time = 3
			})

        return
    end

    local value3_3 = t1.value3
    local value93 = t1.value93

    value3_3:Notify({
			Title = "Chromatica Zero",
			Description = value93,
			Time = 6
		})
end
})
v34:AddKeyBox(function(p2)
    if p2 == t1.value92 then
        t1.value95 = true

        if writefile then
            pcall(function()
                writefile(t1.value94, t1.value92)
            end)
        end

        local t11 = {
			Title = "Chromatica Zero",
			Description = "Key accepted and saved.",
			Time = 3
		}

        t1.value3:Notify(t11)
        t1.value96:Fire()

        return
    end

    t1.value3:Notify({
		Title = "Chromatica Zero",
		Description = "Invalid key.",
		Time = 3
	})
end)
if not t1.value95 then
    t1.value96.Event:Wait()
end
t1.value96:Destroy()
v34:SetVisible(false)
local v35 = t1.value90:AddTab("Main", "https://www.roblox.com/asset/?id=5575337837")
local v36 = t1.value90:AddTab("Lobby", "https://www.roblox.com/asset/?id=4344982548")
local v37 = t1.value90:AddTab("Rolling", "https://www.roblox.com/asset/?id=2017917249")
local v38 = t1.value90:AddTab("Misc", "https://www.roblox.com/asset/?id=5575337837")
local v39 = t1.value90:AddTab("Nothing ever Happens", "https://www.roblox.com/asset/?id=5575337837")
local v40 = t1.value90:AddTab("UI Settings", "https://www.roblox.com/asset/?id=4344982548")
local t12 = {
	Main = v35,
	Lobby = v36,
	Rolling = v37,
	Misc = v38,
	["Nothing ever Happens"] = v39,
	["UI Settings"] = v40
}
local v42 = t12["Nothing ever Happens"]:AddGroupbox({
	Side = "Left",
	Name = "Nothing ever Happens"
})
v42:AddButton({
	Text = "a button that does nothing",
	Func = function()
    local SoundService = game:GetService("SoundService")
    local v132 = getgenv()
    if v132.ChromaticaNothingEverHappensCleanup then
        pcall(v132.ChromaticaNothingEverHappensCleanup)
        v132.ChromaticaNothingEverHappensCleanup = nil
    end
    local ChromaticaNothingEverHappens = SoundService:FindFirstChild("ChromaticaNothingEverHappens")
    if ChromaticaNothingEverHappens then
        ChromaticaNothingEverHappens:Stop()
        ChromaticaNothingEverHappens:Destroy()
    end
    local Sound = Instance.new("Sound")
    Sound.Name = "ChromaticaNothingEverHappens"
    Sound.SoundId = "rbxassetid://76806345377701"
    Sound.Volume = 10
    Sound.PlaybackSpeed = 0.08
    Sound.Parent = SoundService
    local t13 = {}
    local t14 = {}
    local t15 = {}
    local u138 = true
    local u139
    local u140
    local u141
    local u142
    local u143
    local u144
    local function v145(p3)
        if not u138 or (p3 == Sound or not p3:IsA("Sound")) then
            return
        end

        if t13[p3] == nil then
            t13[p3] = p3.Volume
        end

        if not t14[p3] then
            t14[p3] = p3:GetPropertyChangedSignal("Volume"):Connect(function()
                local v670 = not u138

                if not v670 then
                    v670 = t15[p3] or p3 == Sound
                end

                if v670 then
                    return
                end

                local p3Volume = p3.Volume

                if p3Volume ~= 0 then
                    t13[p3] = p3Volume
                end

                t15[p3] = true
                p3.Volume = 0
                t15[p3] = nil
            end)
        end

        t15[p3] = true
        p3.Volume = 0
        t15[p3] = nil
    end
    local function u146()
        if not u138 then
            return
        end

        u138 = false

        if u139 then
            u139:Disconnect()
            u139 = nil
        end

        if u140 then
            u140:Disconnect()
            u140 = nil
        end

        if u141 then
            u141:Disconnect()
            u141 = nil
        end

        for _, v in pairs(t14) do
            local v571 = v

            pcall(function()
                v571:Disconnect()
            end)
        end

        table.clear(t14)

        for k, v in pairs(t13) do
            local v574 = k
            local v575 = v

            if v574 and v574.Parent then
                pcall(function()
                    v574.Volume = v575
                end)
            end
        end

        table.clear(t13)
        table.clear(t15)

        if u142 then
            pcall(function()
                u142:Destroy()
            end)
            u142 = nil
            u143 = nil
            u144 = nil
        end

        if v132.ChromaticaNothingEverHappensCleanup == u146 then
            v132.ChromaticaNothingEverHappensCleanup = nil
        end
    end
    for _, descendant in ipairs(game:GetDescendants()) do
        v145(descendant)
    end
    u141 = game.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Sound") then
            v145(descendant)
        end
    end)
    v132.ChromaticaNothingEverHappensCleanup = u146
    u139 = Sound.Ended:Connect(u146)
    u140 = Sound.Stopped:Connect(u146)
    local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if PlayerGui then
        local ChromaticaNothingEverHappensGui = PlayerGui:FindFirstChild("ChromaticaNothingEverHappensGui")

        if ChromaticaNothingEverHappensGui then
            ChromaticaNothingEverHappensGui:Destroy()
        end

        u142 = Instance.new("ScreenGui")
        u142.Name = "ChromaticaNothingEverHappensGui"
        u142.IgnoreGuiInset = true
        u142.ResetOnSpawn = false
        u142.DisplayOrder = 1000
        u142.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        u142.Parent = PlayerGui
        u143 = Instance.new("Frame")
        u143.BackgroundColor3 = Color3.new(0, 0, 0)
        u143.BackgroundTransparency = 0
        u143.BorderSizePixel = 0
        u143.Size = UDim2.fromScale(1, 1)
        u143.ZIndex = 1
        u143.Parent = u142
        u144 = Instance.new("ImageLabel")
        u144.BackgroundTransparency = 1
        u144.AnchorPoint = Vector2.new(0, 0)
        u144.Position = UDim2.fromScale(0, 0)
        u144.Size = UDim2.fromScale(1, 1)
        u144.ScaleType = Enum.ScaleType.Stretch
        u144.ImageTransparency = 1
        u144.ZIndex = 2
        u144.Parent = u142
        task.spawn(function()
            local t16 = {
					108980713463377,
					121481329723943,
					108616269509904,
					139979277224363,
					70582996685325,
					114026406903286
				}
            local TweenService2 = game:GetService("TweenService")
            local n1 = 0

            while true do
                local v580 = u138

                if v580 then
                    v580 = Sound.Parent and (u144 and u144.Parent)
                end

                if not v580 then
                    break
                end

                local v581 = math.random(1, #t16)

                if #t16 > 1 and v581 == n1 then
                    v581 = v581 % #t16 + 1
                end

                n1 = v581
                u144.Image = string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", (tostring(t16[v581])))
                u144.ImageTransparency = 1

                local tween = TweenService2:Create(u144, TweenInfo.new(0.45), {
						ImageTransparency = 0
					})

                tween:Play()
                tween.Completed:Wait()

                local v583 = not u138

                if not v583 then
                    v583 = not u144 or not u144.Parent
                end

                if v583 then
                    return
                end

                task.wait(1.2)

                local v584 = not u138

                if not v584 then
                    v584 = not u144 or not u144.Parent
                end

                if v584 then
                    return
                end

                local tween2 = TweenService2:Create(u144, TweenInfo.new(0.45), {
						ImageTransparency = 1
					})

                tween2:Play()
                tween2.Completed:Wait()
                task.wait(0.2)
            end
        end)
    end
    Sound:Play()
end
})
v42:AddLabel({
	Text = "(lasts for 1 minute 40 seconds.) (turn audio on)",
	DoesWrap = true,
	Size = 12
})
local t17 = {
	Side = "Left",
	Name = "Auto Farm"
}
local v44 = t12.Main:AddGroupbox(t17)
local v45 = t12.Main:AddGroupbox({
	Side = "Left",
	Name = "Auto Moves"
})
local t18 = {
	Side = "Right",
	Name = "Game Misc"
}
local v47 = t12.Main:AddGroupbox(t18)
local t19 = {
	Side = "Right",
	Name = "Infinity"
}
local v49 = t12.Main:AddGroupbox(t19)
local v50 = t12.Main:AddGroupbox({
	Side = "Right",
	Name = "Safe Spot"
})
local v51 = t12.Lobby:AddGroupbox({
	Side = "Left",
	Name = "Lobby"
})
local v52 = t12.Lobby:AddGroupbox({
	Side = "Right",
	Name = "Auto Claim"
})
local v53 = t12.Lobby:AddGroupbox({
	Side = "Right",
	Name = "Player Detector"
})
local _game = game
local GetService = _game.GetService
t1.value97 = nil
t1.value98 = GetService(_game, "TeleportService")
t1.value99 = 114574503491412
t1.value100 = nil
t1.value101 = false
t1.value100 = false
t1.value102 = false
t1.value97 = {}
t1.value103 = nil
function t1.value104(p4)
    local t20 = {}

    for match in string.gmatch(tostring(p4 or ""), "[^,]+") do
        local v160 = match:gsub("^%s+", ""):gsub("%s+$", "")
        local v161 = string.lower(v160)

        if v161 ~= "" then
            t20[v161] = true
        end
    end

    t1.value97 = t20
end
function t1.value105(p5)
    if not p5 or p5 == t1.value10 then
        return true
    end

    local v152 = string.lower((tostring(p5.Name or "")))
    local v153 = string.lower((tostring(p5.DisplayName or "")))
    local v154 = t1.value97[v152]

    if not v154 then
        v154 = t1.value97[v153]
    end

    if v154 then
        return true
    end

    if t1.value100 then
        local ok4, result3 = pcall(function()
            return t1.value10:IsFriendsWith(p5.UserId)
        end)

        if ok4 and result3 then
            return true
        end
    end

    return false
end
function t1.value106()
    if game.PlaceId == t1.value99 or (t1.value102 or not t1.value101) then
        return
    end

    t1.value102 = true

    if not pcall(function()
        t1.value98:Teleport(t1.value99, t1.value10)
    end) then
        t1.value102 = false
    end
end
function t1.value107()
    local v162 = game.PlaceId == t1.value99

    if not v162 then
        v162 = not t1.value101 or t1.value102
    end

    if v162 then
        return
    end

    for _, player in ipairs(t1.value6:GetPlayers()) do
        if not t1.value105(player) then
            t1.value106()

            return
        end
    end
end
v53:AddToggle("PlayerDetector", {
	Text = "Leave If Player Joins",
	Default = false,
	Callback = function(p6)
    t1.value101 = p6 == true
    t1.value102 = false

    if t1.value101 and game.PlaceId ~= t1.value99 then
        task.defer(t1.value107)
    end
end
})
v53:AddToggle("PlayerDetectorIgnoreFriends", {
	Text = "Ignore Friends",
	Default = false,
	Callback = function(p7)
    t1.value100 = p7 == true
    t1.value102 = false

    if t1.value101 then
        task.defer(t1.value107)
    end
end
})
v53:AddInput("PlayerDetectorExcludedPlayers", {
	Default = "",
	Numeric = false,
	Finished = false,
	Text = "Excluded Players",
	Placeholder = "username1, username2",
	Callback = function(p8)
    t1.value104(p8)
    t1.value102 = false

    if t1.value101 then
        task.defer(t1.value107)
    end
end
})
t1.value103 = t1.value6.PlayerAdded:Connect(function(player)
    task.defer(function()
        local v586 = game.PlaceId == t1.value99

        if not v586 then
            v586 = not t1.value101 or t1.value102
        end

        if v586 then
            return
        end

        if not t1.value105(player) then
            t1.value106()
        end
    end)
end)
local t21 = {
	Side = "Left",
	Name = "Auto Roll"
}
t1.value3:OnUnload(function()
    t1.value101 = false
    t1.value102 = false

    if t1.value103 then
        t1.value103:Disconnect()
        t1.value103 = nil
    end
end)
local v57 = t12.Rolling:AddGroupbox(t21)
local v58 = t12.Rolling:AddGroupbox({
	Side = "Right",
	Name = "Trait Reroll"
})
local v59 = t12.Rolling:AddGroupbox({
	Side = "Right",
	Name = "Character Slots"
})
local v60 = t12.Misc:AddGroupbox({
	Side = "Left",
	Name = "Identity"
})
local v61 = t12.Misc:AddGroupbox({
	Side = "Right",
	Name = "Performance"
})
t1.value108 = 0
t1.value109 = 0
local t22 = {
	__mode = "k"
}
t1.value110 = 0
t1.value111 = setmetatable({}, t22)
t1.value112 = {
	"cold",
	"warm",
	"cry",
	"dry",
	"frío",
	"cálido",
	"llorar",
	"seco",
	"froid",
	"chaud",
	"pleurer",
	"sec",
	"kalt",
	"warm",
	"weinen",
	"trocken",
	"freddo",
	"caldo",
	"piangere",
	"asciutto",
	"frio",
	"quente",
	"chorar",
	"seco",
	"koud",
	"warm",
	"huilen",
	"droog",
	"kylmä",
	"lämmin",
	"itkeä",
	"kuiva",
	"külm",
	"soe",
	"nutma",
	"kuiv",
	"冷たい",
	"暖かい",
	"泣く",
	"乾いた"
}
t1.value113 = {
	"person",
	"hello",
	"tomorrow",
	"yesterday",
	"persona",
	"hola",
	"mañana",
	"ayer",
	"personne",
	"bonjour",
	"demain",
	"hier",
	"Person",
	"hallo",
	"morgen",
	"gestern",
	"persona",
	"ciao",
	"domani",
	"ieri",
	"pessoa",
	"olá",
	"amanhã",
	"ontem",
	"persoon",
	"hallo",
	"morgen",
	"gisteren",
	"henkilö",
	"hei",
	"huomenna",
	"eilen",
	"inimene",
	"tere",
	"homme",
	"eile",
	"人",
	"こんにちは",
	"明日",
	"昨日"
}
function t1.value114(p9, p10)
    for _, v in ipairs(p10) do
        if not p9 then
            return nil
        end

        p9 = if type(v) ~= "number" then p9:FindFirstChild(v) else p9:GetChildren()[v]
    end

    return p9
end
function t1.value115(p11, p12)
    if not p11 then
        return
    end

    local v179 = p11:IsA("TextLabel")

    if not v179 then
        v179 = p11:IsA("TextButton") or p11:IsA("TextBox")
    end

    if not v179 then
        return
    end

    if t1.value111[p11] == nil then
        t1.value111[p11] = p11.Text
    end

    p11.Text = tostring(p12)
end
function t1.value116()
    for k, v in pairs(t1.value111) do
        local v171 = k
        local v172 = v

        if v171 and v171.Parent then
            pcall(function()
                v171.Text = v172
            end)
        end
    end

    t1.value111 = setmetatable({}, {
		__mode = "k"
	})
end
function t1.value117()
    t1.value109 = t1.value109 % #t1.value112 + 1

    local value113 = t1.value113

    t1.value110 = t1.value110 % #value113 + 1

    local v181 = math.random(1, 999)
    local v182 = math.random(1, 999)

    if v182 == v181 then
        v182 = v182 % 999 + 1
    end

    local PlayerGui = t1.value10:FindFirstChild("PlayerGui")

    if PlayerGui then
        t1.value115(t1.value114(PlayerGui, {
			"UI Animation (Finished)",
			"Profile",
			"MainFrame",
			"Body",
			"Profile",
			"Body",
			"NameHolder",
			"DisplayName",
			"DisplayName"
		}), t1.value112[t1.value109])
        t1.value115(t1.value114(PlayerGui, {
			"UI Animation (Finished)",
			"Profile",
			"MainFrame",
			"Body",
			"Profile",
			"Body",
			"NameHolder",
			"Username"
		}), t1.value112[t1.value109])
    end

    local immobiliekal = workspace:FindFirstChild("immobiliekal")

    if not immobiliekal then
        immobiliekal = t1.value10.Character

        if not immobiliekal then
            immobiliekal = workspace:FindFirstChild(t1.value10.Name)
        end
    end

    if immobiliekal then
        t1.value115(t1.value114(immobiliekal, {
			"OverHead",
			"Main",
			"Level",
			"TxtShadow",
			"Txt"
		}), "Level " .. tostring(v181))
        t1.value115(t1.value114(immobiliekal, {
			"OverHead",
			"Main",
			"DisplayName",
			"TxtShadow",
			"Txt"
		}), t1.value113[t1.value110])
    end

    local v185 = t1.value6:FindFirstChild("monkeyt man") or t1.value10
    local v186 = v185 and v185:FindFirstChild("PlayerGui")

    if v186 then
        t1.value115(t1.value114(v186, {
			"UI Animation (Working)",
			"LobbyHUD",
			"Profile",
			"Main",
			"BarHolder",
			"Frame",
			3
		}), (tostring(v182)))
        t1.value115(t1.value114(v186, {
			"UI Animation (Working)",
			"LobbyHUD",
			"Profile",
			"Main",
			"TxtHolder",
			"Txt"
		}), t1.value113[t1.value110])
        t1.value115(t1.value114(v186, {
			"UI Animation (Working)",
			"LobbyHUD",
			"Profile",
			"Main",
			"TxtHolder",
			"Frame",
			"Txt"
		}), t1.value113[t1.value110])
    end
end
function t1.value118()
    t1.value108 = t1.value108 + 1

    local value108 = t1.value108

    task.spawn(function()
        while value108 == t1.value108 do
            if t1.value2 ~= getgenv().ChromaticaSession then
                return
            end

            if not t1.value5.HideIdentity or not t1.value5.HideIdentity.Value then
                return
            end

            pcall(t1.value117)
            task.wait(0.5)
        end
    end)
end
v60:AddToggle("HideIdentity", {
	Text = "Hide Identity",
	Default = false,
	Callback = function(p13)
    t1.value108 = t1.value108 + 1

    if p13 then
        t1.value118()

        return
    end

    t1.value116()
end
})
local _game2 = game
t1.value119 = nil
t1.value120 = _game2:GetService("Lighting")
t1.value121 = 0
t1.value122 = nil
t1.value123 = nil
t1.value119 = false
t1.value124 = nil
function t1.value124(p14)
    local v191 = p14:IsA("Texture")

    if not v191 then
        v191 = p14:IsA("Decal")

        if not v191 then
            v191 = p14:IsA("SurfaceAppearance")

            if not v191 then
                v191 = p14:IsA("ParticleEmitter")

                if not v191 then
                    v191 = p14:IsA("Trail")

                    if not v191 then
                        v191 = p14:IsA("Beam") or (p14:IsA("Smoke") or (p14:IsA("Fire") or p14:IsA("Sparkles")))
                    end
                end
            end
        end
    end

    return v191
end
t1.value125 = nil
function t1.value125(p15, p16)
    if not p15 or not p15.Parent then
        return
    end

    if t1.value124(p15) then
        pcall(function()
            p15:Destroy()
        end)

        return
    end

    if p15:IsA("MeshPart") then
        pcall(function()
            p15.TextureID = ""
        end)
    end

    if p15:IsA("BasePart") then
        pcall(function()
            p15.CastShadow = false
        end)
        pcall(function()
            p15.Reflectance = 0
        end)

        if p16 then
            pcall(function()
                p15.Material = Enum.Material.SmoothPlastic
            end)
            pcall(function()
                p15.MaterialVariant = ""
            end)
        end

        return
    end

    if p15:IsA("PostEffect") then
        pcall(function()
            p15:Destroy()
        end)

        return
    end

    if p16 then
        local v194 = p15:IsA("SpecialMesh")

        if not v194 then
            v194 = p15:IsA("Atmosphere")

            if not v194 then
                v194 = p15:IsA("Sky") or (p15:IsA("Clouds") or p15:IsA("Highlight"))
            end
        end

        if v194 then
            pcall(function()
                p15:Destroy()
            end)

            return
        end

        if p15:IsA("PointLight") or (p15:IsA("SpotLight") or p15:IsA("SurfaceLight")) then
            pcall(function()
                p15.Enabled = false
            end)
        end
    end
end
local function v64(p17)
    local descendants = workspace:GetDescendants()

    for i, v in ipairs(descendants) do
        pcall(t1.value125, v, p17)

        if i % 300 == 0 then
            task.wait()
        end
    end

    for _, child in ipairs(t1.value120:GetChildren()) do
        pcall(t1.value125, child, p17)
    end

    if p17 then
        pcall(function()
            t1.value120.GlobalShadows = false
        end)
        pcall(function()
            t1.value120.EnvironmentDiffuseScale = 0
        end)
        pcall(function()
            t1.value120.EnvironmentSpecularScale = 0
        end)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        if Terrain then
            pcall(function()
                Terrain.Decoration = false
            end)
            pcall(function()
                Terrain.WaterWaveSize = 0
            end)
            pcall(function()
                Terrain.WaterWaveSpeed = 0
            end)
            pcall(function()
                Terrain.WaterReflectance = 0
            end)
        end
    end
end
local t23 = {
	Text = "Disable 3D Render",
	Default = false,
	Callback = function(p18)
    t1.value119 = p18 == true
    pcall(function()
        t1.value8:Set3dRenderingEnabled(not t1.value119)
    end)
end
}
function t1.value126()
    if t1.value123 then
        t1.value123:Disconnect()
        t1.value123 = nil
    end

    local FPSBooster = t1.value5.FPSBooster

    if FPSBooster then
        FPSBooster = t1.value5.FPSBooster.Value
    end

    local v196 = not FPSBooster

    if v196 then
        v196 = not (t1.value5.SuperFPSBooster and t1.value5.SuperFPSBooster.Value)
    end

    if v196 then
        return
    end

    t1.value123 = workspace.DescendantAdded:Connect(function(descendant)
        task.defer(function()
            if t1.value2 ~= getgenv().ChromaticaSession then
                return
            end

            local v672 = t1.value5.SuperFPSBooster and t1.value5.SuperFPSBooster.Value
            local value5 = t1.value5

            if v672 or value5.FPSBooster and t1.value5.FPSBooster.Value then
                pcall(t1.value125, descendant, v672 == true)
            end
        end)
    end)
end
v61:AddToggle("Disable3DRender", t23)
v61:AddToggle("FPSBooster", {
	Text = "FPS Booster",
	Default = false,
	Callback = function(p19)
    if p19 then
        task.spawn(function()
            v64(false)
        end)
    end

    t1.value126()
end
})
v61:AddToggle("SuperFPSBooster", {
	Text = "Super FPS Booster",
	Default = false,
	Callback = function(p20)
    if p20 then
        task.spawn(function()
            v64(true)
        end)
    end

    t1.value126()
end
})
local function v66()
    if t1.value122 then
        return
    end

    t1.value122 = {
		Brightness = t1.value120.Brightness,
		ClockTime = t1.value120.ClockTime,
		FogEnd = t1.value120.FogEnd,
		FogStart = t1.value120.FogStart,
		GlobalShadows = t1.value120.GlobalShadows,
		Ambient = t1.value120.Ambient,
		OutdoorAmbient = t1.value120.OutdoorAmbient
	}
end
t1.value127 = nil
function t1.value127()
    pcall(function()
        t1.value120.Brightness = 2
        t1.value120.ClockTime = 14
        t1.value120.FogStart = 0
        t1.value120.FogEnd = 100000
        t1.value120.GlobalShadows = false
        t1.value120.Ambient = Color3.new(1, 1, 1)
        t1.value120.OutdoorAmbient = Color3.new(1, 1, 1)
    end)
end
function t1.value128()
    if not t1.value122 then
        return
    end

    local value122 = t1.value122

    t1.value122 = nil
    pcall(function()
        t1.value120.Brightness = value122.Brightness
        t1.value120.ClockTime = value122.ClockTime
        t1.value120.FogEnd = value122.FogEnd
        t1.value120.FogStart = value122.FogStart
        t1.value120.Ambient = value122.Ambient
        t1.value120.OutdoorAmbient = value122.OutdoorAmbient

        if not t1.value5.SuperFPSBooster or not t1.value5.SuperFPSBooster.Value then
            t1.value120.GlobalShadows = value122.GlobalShadows
        end
    end)
end
function t1.value129()
    t1.value121 = t1.value121 + 1

    local value121 = t1.value121

    v66()
    task.spawn(function()
        while value121 == t1.value121 do
            if t1.value2 ~= getgenv().ChromaticaSession then
                return
            end

            if not t1.value5.FullBright or not t1.value5.FullBright.Value then
                return
            end

            t1.value127()
            task.wait(0.5)
        end
    end)
end
v61:AddToggle("FullBright", {
	Text = "Full Bright",
	Default = false,
	Callback = function(p21)
    t1.value121 = t1.value121 + 1

    if p21 then
        t1.value129()

        return
    end

    t1.value128()
end
})
t1.value3:OnUnload(function()
    t1.value108 = t1.value108 + 1
    t1.value121 = t1.value121 + 1
    t1.value116()
    t1.value128()

    if t1.value119 then
        t1.value119 = false
        pcall(function()
            t1.value8:Set3dRenderingEnabled(true)
        end)
    end

    if t1.value123 then
        t1.value123:Disconnect()
        t1.value123 = nil
    end
end)
function t1.value89.GetCharacter()
    return t1.value10.Character
end
function t1.value89.GetCharacterRoot()
    local v209 = t1.value89.GetCharacter()

    if not v209 then
        return nil
    end

    return v209:FindFirstChild("HumanoidRootPart")
end
function t1.value89.GetHumanoid()
    local v210 = t1.value89.GetCharacter()

    if not v210 then
        return nil
    end

    return v210:FindFirstChildOfClass("Humanoid")
end
function t1.value89.GetHealthPercent()
    local v211 = t1.value89.GetHumanoid()

    if not v211 then
        return nil
    end

    if v211.MaxHealth <= 0 then
        return nil
    end

    return v211.Health / v211.MaxHealth * 100
end
function t1.value89.GetObjectCFrame(p22)
    if not p22 then
        return nil
    end

    if p22:IsA("BasePart") then
        return p22.CFrame
    end

    if p22:IsA("Attachment") then
        return p22.WorldCFrame
    end

    if p22:IsA("Model") then
        local ok5, result4 = pcall(function()
            return p22:GetPivot()
        end)

        if ok5 then
            return result4
        end
    end

    local BasePart = p22:FindFirstChildWhichIsA("BasePart", true)

    if BasePart then
        return BasePart.CFrame
    end

    return nil
end
function t1.value89.CancelMovementTween()
    if t1.value26 then
        pcall(function()
            t1.value26:Cancel()
        end)
    end

    t1.value26 = nil
    t1.value27 = nil
    t1.value28 = nil
    t1.value29 = 0
end
local v67 = t2[3]
local v68 = t2[2]
local v69 = t2[4]
local v70 = t2[1]
function t1.value89.TweenRootTo(p23, _)
    local v218 = t1.value89.GetCharacterRoot()

    if not v218 or typeof(p23) ~= "CFrame" then
        return false
    end

    local elapsed = os.clock()
    local p23Position = p23.Position
    local value26 = t1.value26

    if value26 then
        value26 = v218 == t1.value27

        if value26 then
            value26 = t1.value28

            if value26 then
                value26 = (t1.value28.Position - p23Position).Magnitude <= v67[1] and elapsed - t1.value29 < v68[1]
            end
        end
    end

    if value26 then
        return true
    end

    local Magnitude = (v218.Position - p23Position).Magnitude

    if Magnitude <= 0.15 then
        v218.AssemblyLinearVelocity = Vector3.zero
        v218.AssemblyAngularVelocity = Vector3.zero
        v218.CFrame = p23

        return true
    end

    if t1.value26 then
        pcall(function()
            t1.value26:Cancel()
        end)
    end

    v218.AssemblyLinearVelocity = Vector3.zero
    v218.AssemblyAngularVelocity = Vector3.zero

    local v223 = math.clamp(Magnitude / math.max(v69[1], 1), 0.05, 8)
    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = v218.CFrame

    local v225 = v70[1]:Create(CFrameValue, TweenInfo.new(v223, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Value = p23
	})

    t1.value26 = v225
    t1.value27 = v218
    t1.value28 = p23
    t1.value29 = elapsed
    v225.Completed:Connect(function(p25)
        if t1.value26 == v225 then
            if p25 == Enum.PlaybackState.Completed and v218.Parent then
                v218.AssemblyLinearVelocity = Vector3.zero
                v218.AssemblyAngularVelocity = Vector3.zero
                v218.CFrame = p23
            end

            t1.value26 = nil
            t1.value27 = nil
        end

        pcall(function()
            CFrameValue:Destroy()
        end)
    end)
    v225:Play()
    task.spawn(function()
        while true do
            local v589 = t1.value26 == v225

            if v589 then
                v589 = t1.value27 == v218 and v218.Parent
            end

            if not v589 then
                break
            end

            v218.AssemblyLinearVelocity = Vector3.zero
            v218.AssemblyAngularVelocity = Vector3.zero

            local Humanoid = v218.Parent:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid:Move(Vector3.zero, false)
            end

            v218.CFrame = CFrameValue.Value
            t1.value8.RenderStepped:Wait()
        end

        pcall(function()
            CFrameValue:Destroy()
        end)
    end)

    return true
end
function t1.value89.TeleportToObject(p26, p27)
    if not t1.value89.GetCharacterRoot() then
        return false
    end

    local v228 = t1.value89.GetObjectCFrame(p26)

    if not v228 then
        return false
    end

    if p27 == nil then
        p27 = 3
    end

    return t1.value89.TweenRootTo(v228 + Vector3.new(0, p27, 0))
end
function t1.value89.TeleportBehindObject(p28, p29)
    if not t1.value89.GetCharacterRoot() then
        return false
    end

    local v231 = t1.value89.GetObjectCFrame(p28)

    if not v231 then
        return false
    end

    local v232 = p29 or 3
    local Position = v231.Position
    local v234 = Position - v231.LookVector * v232

    return t1.value89.TweenRootTo(CFrame.new(v234, Position))
end
function t1.value89.GetEnemyRoot(p30)
    if not p30 then
        return nil
    end

    if p30:IsA("BasePart") then
        return p30
    end

    if not p30:IsA("Model") then
        return nil
    end

    local HumanoidRootPart = p30:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        HumanoidRootPart = p30:FindFirstChild("Torso") or (p30:FindFirstChild("UpperTorso") or (p30.PrimaryPart or p30:FindFirstChildWhichIsA("BasePart", true)))
    end

    return HumanoidRootPart
end
function t1.value89.IsEnemyAlive(p31)
    if not p31 or not p31.Parent then
        return false
    end

    local Humanoid = p31:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        return Humanoid.Health > 0
    end

    return t1.value89.GetEnemyRoot(p31) ~= nil
end
function t1.value89.GetNearestEnemy()
    local enemies = workspace:FindFirstChild("enemies")
    if not enemies then
        return nil
    end
    local v240 = t1.value89.GetCharacterRoot()
    if not v240 then
        return nil
    end
    local v241
    local GetChildren = enemies.GetChildren
    local n2 = 1e999
    for _, v in ipairs(GetChildren(enemies)) do
        if t1.value89.IsEnemyAlive(v) then
            local v246 = t1.value89.GetEnemyRoot(v)

            if v246 then
                local Magnitude = (v240.Position - v246.Position).Magnitude

                if Magnitude < n2 then
                    v241 = v
                    n2 = Magnitude
                end
            end
        end
    end

    return v241
end
function t1.value89.GetNearestRaidAdd()
    local enemies = workspace:FindFirstChild("enemies")
    if not enemies then
        return nil
    end
    local v249 = t1.value89.GetCharacterRoot()
    if not v249 then
        return nil
    end
    local v250
    local n3 = 1e999
    local _ipairs = ipairs
    for _, v254 in _ipairs(enemies:GetChildren()) do
        local v255 = v254.Name ~= "0"

        if v255 then
            v255 = not v254:FindFirstChild("Highlight") and t1.value89.IsEnemyAlive(v254)
        end

        if v255 then
            _ipairs = t1.value89.GetEnemyRoot

            local v256 = _ipairs(v254)

            if v256 then
                _ipairs = (v249.Position - v256.Position).Magnitude

                if _ipairs < n3 then
                    n3 = _ipairs
                    v250 = v254
                end
            end
        end
    end

    return v250
end
function t1.value89.HasRaidBossMesh(p32)
    if not p32 or p32.Name ~= "0" then
        return false
    end

    local Cube = p32:FindFirstChild("Cube")

    if not Cube then
        return false
    end

    if Cube:IsA("MeshPart") then
        return t1.value33[Cube.MeshId] == true
    end

    local SpecialMesh = Cube:FindFirstChildOfClass("SpecialMesh")

    if SpecialMesh then
        return t1.value33[SpecialMesh.MeshId] == true
    end

    return false
end
function t1.value89.IsIgrisBoss(p33)
    if not p33 then
        return false
    end

    local Asset = p33:FindFirstChild("Asset")

    return Asset ~= nil and Asset:FindFirstChild("Handle_Igris") ~= nil
end
function t1.value89.IsIgrisHighlightColor(p34)
    if typeof(p34) ~= "Color3" then
        return false
    end

    local v263 = math.floor(p34.R * 255 + 0.5) == 220

    if v263 then
        v263 = math.floor(p34.G * 255 + 0.5) == 20 and math.floor(p34.B * 255 + 0.5) == 40
    end

    return v263
end
function t1.value89.IsIgrisTargetable(p35)
    if not t1.value89.IsIgrisBoss(p35) or not t1.value89.IsEnemyAlive(p35) then
        return false
    end
    local GetDescendants = p35.GetDescendants
    local n4 = 0
    local v267
    for _, v in ipairs(GetDescendants(p35)) do
        if not v:IsA("Highlight") then
            continue
        end

        v267 = v
        n4 += 1

        if n4 > 1 then
            return false
        end
    end
    if n4 ~= 1 or not v267 then
        return false
    end
    local FillColor = v267.FillColor
    local v271 = math.floor(FillColor.R * 255 + 0.5) == 0
    if v271 then
        v271 = math.floor(FillColor.G * 255 + 0.5) == 170 and math.floor(FillColor.B * 255 + 0.5) == 220
    end
    local v272 = t1.value89.IsIgrisHighlightColor(FillColor)
    if not v272 then
        if not v271 then
            v271 = t1.value89.IsIgrisHighlightColor(v267.OutlineColor)
        end

        v272 = v271
    end

    return v272
end
function t1.value89.IsTargetableRaidBoss(p36)
    if t1.value89.IsIgrisBoss(p36) then
        return t1.value89.IsIgrisTargetable(p36)
    end

    return t1.value89.HasRaidBossMesh(p36)
end
local value89 = t1.value89
local v72 = t2[5]
function value89.GetRaidTargetDistance(p37)
    if t1.value89.IsIgrisBoss(p37) then
        return 8.3
    end

    if p37 then
        p37 = p37.Name == "0" and t1.value89.IsTargetableRaidBoss(p37)
    end

    if p37 then
        return v72[1]
    end

    return t1.value23
end
function t1.value89.IsRaidBlueIframe(p38)
    if not p38 or not p38.Parent then
        return false
    end

    local GetDescendants = p38.GetDescendants

    for _, v in ipairs(GetDescendants(p38)) do
        if not v:IsA("Highlight") then
            continue
        end

        local FillColor = v.FillColor
        local OutlineColor = v.OutlineColor
        local v281 = math.floor(FillColor.R * 255 + 0.5) == 70

        if v281 then
            v281 = math.floor(FillColor.G * 255 + 0.5) == 150 and math.floor(FillColor.B * 255 + 0.5) == 255
        end

        local v282 = math.floor(OutlineColor.R * 255 + 0.5) == 70

        if v282 then
            v282 = math.floor(OutlineColor.G * 255 + 0.5) == 150 and math.floor(OutlineColor.B * 255 + 0.5) == 255
        end

        if v281 or v282 then
            return true
        end
    end

    return false
end
function t1.value89.IsIgnoredHighlightedRaidBoss(p39)
    if t1.value89.IsIgrisBoss(p39) then
        return not t1.value89.IsIgrisTargetable(p39)
    end

    local v284 = p39

    if p39 then
        v284 = p39.Name == "0" and t1.value89.HasRaidBossMesh(p39)
    end

    if v284 then
        return t1.value89.IsRaidBlueIframe(p39)
    end

    return false
end
function t1.value89.GetNearestRaidEnemy()
    local enemies = workspace:FindFirstChild("enemies")
    if not enemies then
        return nil
    end
    local v286 = t1.value89.GetCharacterRoot()
    if not v286 then
        return nil
    end
    local _math = math
    local v288
    local GetChildren = enemies.GetChildren
    local huge = _math.huge
    for _, v in ipairs(GetChildren(enemies)) do
        if t1.value89.IsEnemyAlive(v) and not t1.value89.IsIgnoredHighlightedRaidBoss(v) then
            local v293 = t1.value89.GetEnemyRoot(v)

            if v293 then
                local Magnitude = (v286.Position - v293.Position).Magnitude

                if Magnitude < huge then
                    v288 = v
                    huge = Magnitude
                end
            end
        end
    end

    return v288
end
function t1.value89.GetSpecialRaidBoss()
    local enemies = workspace:FindFirstChild("enemies")

    if not enemies then
        return nil
    end

    local v296 = enemies:FindFirstChild("0")

    if not v296 then
        return nil
    end

    if not t1.value89.IsEnemyAlive(v296) then
        return nil
    end

    if not t1.value89.IsTargetableRaidBoss(v296) then
        return nil
    end

    if t1.value89.IsIgnoredHighlightedRaidBoss(v296) then
        return nil
    end

    return v296
end
function t1.value89.GetSilentMouseAimPart()
    local v297 = getgenv()
    local ChromaticaAutoMoveAimTarget = v297.ChromaticaAutoMoveAimTarget
    local v299 = os.clock() <= (v297.ChromaticaAutoMoveAimUntil or 0)
    if v299 then
        v299 = ChromaticaAutoMoveAimTarget and ChromaticaAutoMoveAimTarget.Parent
    end
    if v299 then
        return ChromaticaAutoMoveAimTarget
    end
    local value32 = t1.value32
    if value32 then
        value32 = t1.value32.Parent

        if value32 then
            value32 = not t1.value89.IsIgnoredHighlightedRaidBoss(t1.value32) and t1.value89.IsEnemyAlive(t1.value32)
        end
    end
    if value32 then
        local v301 = t1.value89.GetEnemyRoot(t1.value32)

        if v301 then
            return v301
        end
    end
    if t1.value30 and (t1.value30.Parent and t1.value89.IsEnemyAlive(t1.value30)) then
        local v302 = t1.value89.GetEnemyRoot(t1.value30)

        if v302 then
            return v302
        end
    end
    if t1.value31 and t1.value31.Parent then
        if t1.value31:IsA("BasePart") then
            return t1.value31
        end

        local BasePart = t1.value31:FindFirstChildWhichIsA("BasePart", true)

        if BasePart then
            return BasePart
        end
    end
    local RaidAutoFarm = t1.value5.RaidAutoFarm
    if RaidAutoFarm then
        RaidAutoFarm = t1.value5.RaidAutoFarm.Value
    end
    local v305 = if not RaidAutoFarm then t1.value89.GetNearestEnemy() else t1.value89.GetNearestRaidEnemy()
    if v305 then
        return t1.value89.GetEnemyRoot(v305)
    end

    return nil
end
t1.value130 = getgenv()
t1.value130.ChromaticaMouseAimObject = t1.value10:GetMouse()
t1.value130.ChromaticaMouseAimProvider = t1.value89.GetSilentMouseAimPart
if not t1.value130.ChromaticaMouseAimHookInstalled then
    local _hookmetamethod = hookmetamethod
    local _newcclosure = newcclosure

    if type(_hookmetamethod) == "function" then
        local u75
        local function v76(p40, p41)
            local v308 = getgenv()

            if p40 == v308.ChromaticaMouseAimObject then
                local ChromaticaMouseAimProvider = v308.ChromaticaMouseAimProvider

                if type(ChromaticaMouseAimProvider) == "function" then
                    local ok6, result5 = pcall(ChromaticaMouseAimProvider)
                    if ok6 then
                        ok6 = result5 and result5.Parent
                    end
                    if ok6 then
                        if p41 == "Hit" then
                            return result5.CFrame
                        end

                        if p41 == "Target" then
                            return result5
                        end

                        if p41 == "UnitRay" then
                            local CurrentCamera = workspace.CurrentCamera

                            if CurrentCamera then
                                local CFramePosition = CurrentCamera.CFrame.Position
                                local v314 = result5.Position - CFramePosition

                                if v314.Magnitude > 0 then
                                    return Ray.new(CFramePosition, v314.Unit * 1000)
                                end
                            end
                        end
                    end
                end
            end

            return u75(p40, p41)
        end
        u75 = if type(_newcclosure) ~= "function" then _hookmetamethod(game, "__index", v76) else _hookmetamethod(game, "__index", _newcclosure(v76))
        t1.value130.ChromaticaMouseAimHookInstalled = true
    end
end
t1.value3:OnUnload(function()
    if getgenv().ChromaticaSession == t1.value2 then
        t1.value130.ChromaticaMouseAimProvider = nil
        t1.value130.ChromaticaAutoMoveAimTarget = nil
        t1.value130.ChromaticaAutoMoveAimUntil = 0
    end
end)
function t1.value89.GetFarmCFrame(p42, p43)
    if t1.value22 == "Behind" then
        local v317 = p42.Position - p42.CFrame.LookVector * t1.value23

        return CFrame.new(v317, p42.Position)
    end

    if t1.value22 == "Below" then
        local v318 = p42.Position - Vector3.new(0, t1.value23, 0)

        return CFrame.new(v318, p42.Position)
    end

    if t1.value22 == "Above" then
        local v319 = p42.Position + Vector3.new(0, t1.value23, 0) - p42.CFrame.LookVector * 5

        return CFrame.new(v319, p42.Position)
    end

    if t1.value22 == "Orbit" then
        t1.value25 = t1.value25 + p43 * t1.value24

        local vector3 = Vector3.new(math.cos(t1.value25) * t1.value23, 0, math.sin(t1.value25) * t1.value23)
        local v321 = p42.Position + vector3

        return CFrame.new(v321, p42.Position)
    end

    return p42.CFrame
end
function t1.value89.GetRaidAboveCFrame(p44, p45)
    local v324 = p44.Position + Vector3.new(0, p45, 0) - p44.CFrame.LookVector * 5

    return CFrame.new(v324, p44.Position)
end
function t1.value89.GetRaidExit()
    local World = workspace:FindFirstChild("World")

    if not World then
        return nil
    end

    local Markers = World:FindFirstChild("Markers")

    if not Markers then
        return nil
    end

    return Markers:FindFirstChild("Exit")
end
function t1.value89.GetRaidExitPrompt()
    local v327 = t1.value89.GetRaidExit()

    if not v327 then
        return nil, nil
    end

    local ExitPrompt = v327:FindFirstChild("ExitPrompt", true)

    if ExitPrompt and ExitPrompt:IsA("ProximityPrompt") then
        return v327, ExitPrompt
    end

    local GetDescendants = v327.GetDescendants

    for _, v in ipairs(GetDescendants(v327)) do
        if v:IsA("ProximityPrompt") and v.Name == "ExitPrompt" then
            return v327, v
        end
    end

    return v327, nil
end
function t1.value89.GetRaidPromptTarget(p46)
    if not p46 then
        return nil
    end

    local p46Parent = p46.Parent

    while p46Parent and p46Parent ~= workspace do
        if p46Parent:IsA("Attachment") then
            return p46Parent
        end

        if p46Parent:IsA("BasePart") then
            return p46Parent
        end

        p46Parent = p46Parent.Parent
    end

    return nil
end
function t1.value89.UseRaidExitPrompt(p47)
    local v335 = not p47

    if not v335 then
        v335 = not p47.Parent or not p47.Enabled
    end

    if v335 then
        return false
    end

    if fireproximityprompt then
        pcall(function()
            fireproximityprompt(p47)
        end)

        return true
    end

    pcall(function()
        p47:InputHoldBegin()
        task.delay(math.max(p47.HoldDuration, 0) + 0.05, function()
            if p47 and (p47.Parent and p47.Enabled) then
                pcall(function()
                    p47:InputHoldEnd()
                end)
            end
        end)
    end)

    return true
end
function t1.value57.GetLiftPrompt()
    local World = workspace:FindFirstChild("World")
    local v337 = World and World:FindFirstChild("Markers")
    local v338 = v337 and v337:FindFirstChild("Lift")

    if not v338 then
        return nil, nil
    end

    local ProximityPrompt = v338:FindFirstChild("ProximityPrompt", true)

    if ProximityPrompt and ProximityPrompt:IsA("ProximityPrompt") then
        return v338, ProximityPrompt
    end

    return v338, nil
end
function t1.value57.UseLift()
    local enemies = workspace:FindFirstChild("enemies")

    if enemies then
        for _, child in ipairs(enemies:GetChildren()) do
            if t1.value89.IsEnemyAlive(child) then
                t1.value57.ActiveLiftPrompt = nil
                t1.value57.NextLiftAttempt = 0

                return false
            end
        end
    end

    local v343, v344 = t1.value57.GetLiftPrompt()
    local v345 = v344
    local v346 = not v343

    if not v346 then
        v346 = not v345

        if not v346 then
            v346 = not v345.Parent

            if not v346 then
                v346 = not v345:IsDescendantOf(workspace) or (not v345.Enabled or v345.MaxActivationDistance <= 0)
            end
        end
    end

    if v346 then
        t1.value57.ActiveLiftPrompt = nil
        t1.value57.NextLiftAttempt = 0

        return false
    end

    if v345 ~= t1.value57.ActiveLiftPrompt then
        t1.value57.ActiveLiftPrompt = v345
        t1.value57.NextLiftAttempt = 0
    end

    local elapsed = os.clock()

    if elapsed < t1.value57.NextLiftAttempt then
        return true
    end

    local LiftPromptDelay = t1.value57.LiftPromptDelay

    t1.value57.NextLiftAttempt = elapsed + LiftPromptDelay

    local v349 = t1.value89.GetRaidPromptTarget(v345)
    local v350 = t1.value89.GetCharacterRoot()
    local v351 = t1.value89.GetObjectCFrame(v349 or v343)
    local v352 = true

    if v350 and v351 then
        v352 = (v350.Position - v351.Position).Magnitude > math.max(v345.MaxActivationDistance - 1, 1)
    end

    if v352 then
        if v349 then
            t1.value89.TeleportToObject(v349, 0)
        else
            t1.value89.TeleportToObject(v343, 0)
        end
    end

    task.defer(function()
        task.wait(0.2)

        local v591 = t1.value57.ActiveLiftPrompt ~= v345

        if not v591 then
            v591 = not v345

            if not v591 then
                v591 = not v345.Parent

                if not v591 then
                    v591 = not v345:IsDescendantOf(workspace)

                    if not v591 then
                        v591 = not v345.Enabled or v345.MaxActivationDistance <= 0
                    end
                end
            end
        end

        if v591 then
            return
        end

        t1.value89.UseRaidExitPrompt(v345)
    end)

    return true
end
function t1.value89.GetRubbleTagText()
    local PlayerGui = t1.value10:FindFirstChild("PlayerGui")
    if not PlayerGui then
        return nil
    end
    local RubbleBar = PlayerGui:FindFirstChild("RubbleBar")
    if not RubbleBar then
        return nil
    end
    local Holder = RubbleBar:FindFirstChild("Holder")
    if not Holder then
        return nil
    end
    local Tag = Holder:FindFirstChild("Tag")
    if not Tag then
        return nil
    end
    local TagText
    if Tag:IsA("TextLabel") or (Tag:IsA("TextButton") or Tag:IsA("TextBox")) then
        TagText = Tag.Text
    elseif Tag:IsA("StringValue") then
        TagText = Tag.Value
    end
    if not TagText then
        return nil
    end
    local v358 = string.gsub(TagText, "^%s+", "")
    local v359 = string.gsub(v358, "%s+$", "")

    return string.upper(v359)
end
function t1.value89.IsRubbleBreakable()
    return t1.value89.GetRubbleTagText() == "[BREAK IT]"
end
function t1.value89.GetActiveBorderBlocker()
    local World = workspace:FindFirstChild("World")

    if not World then
        return nil
    end

    local Map = World:FindFirstChild("Map")

    if not Map then
        return nil
    end

    for i = 1, 4 do
        local v363 = Map:FindFirstChild("Border" .. i)

        if not v363 then
            continue
        end

        local Rubble = v363:FindFirstChild("Rubble")
        local Blocker = v363:FindFirstChild("Blocker")

        if Rubble and Blocker then
            return Blocker
        end
    end

    return nil
end
function t1.value89.GetEnemyCountText()
    local PlayerGui = t1.value10:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return nil
    end

    local RoundHUD = PlayerGui:FindFirstChild("RoundHUD")

    if not RoundHUD then
        return nil
    end

    local Container = RoundHUD:FindFirstChild("Container")

    if not Container then
        return nil
    end

    local TopPart = Container:FindFirstChild("TopPart")

    if not TopPart then
        return nil
    end

    local RemainingFrame = TopPart:FindFirstChild("RemainingFrame")

    if not RemainingFrame then
        return nil
    end

    local EnemyCount = RemainingFrame:FindFirstChild("EnemyCount")

    if not EnemyCount then
        return nil
    end

    if EnemyCount:IsA("TextLabel") or (EnemyCount:IsA("TextButton") or EnemyCount:IsA("TextBox")) then
        return EnemyCount.Text
    end

    local GetDescendants = EnemyCount.GetDescendants
    local _ipairs = ipairs

    for _, v375 in _ipairs(GetDescendants(EnemyCount)) do
        local v376 = v375:IsA("TextLabel")

        if not v376 then
            v376 = v375:IsA("TextButton") or v375:IsA("TextBox")
        end

        if v376 and (v375.Text and v375.Text ~= "") then
            return v375.Text
        end
    end

    return nil
end
function t1.value89.GetCurrentArea()
    local v377 = t1.value89.GetEnemyCountText()

    if not v377 then
        return nil
    end

    local num = tonumber((string.match(string.lower(v377), "area%s*(%d+)%s*/%s*5")))

    if not num then
        return nil
    end

    if num < 1 or num > 5 then
        return nil
    end

    return num
end
function t1.value89.GetCurrentInfiniteWave()
    local v379 = t1.value89.GetEnemyCountText()

    if not v379 then
        return nil
    end

    local num = tonumber((string.match(string.lower(v379), "wave%s*(%d+)")))

    if not num then
        return nil
    end

    if num < 1 or num > 999 then
        return nil
    end

    return num
end
function t1.value89.ResetCharacter()
    local Character = t1.value10.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        pcall(function()
            Humanoid.Health = 0
        end)
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end)
    end

    pcall(function()
        Character:BreakJoints()
    end)

    return true
end
function t1.value89.TeleportToArea(p48)
    local World = workspace:FindFirstChild("World")

    if not World then
        return false
    end

    local Areas = World:FindFirstChild("Areas")

    if not Areas then
        return false
    end

    local v386 = Areas:FindFirstChild(tostring(p48))

    if not v386 then
        return false
    end

    return t1.value89.TeleportToObject(v386, 3)
end
getgenv().ChromaticaBeginAutoMoveSilentAim = function()
    local v387 = t1.value89.GetSilentMouseAimPart()
    local v388 = getgenv()

    if v387 and v387.Parent then
        v388.ChromaticaAutoMoveAimTarget = v387
        v388.ChromaticaAutoMoveAimUntil = os.clock() + 0.45

        return true
    end

    v388.ChromaticaAutoMoveAimTarget = nil
    v388.ChromaticaAutoMoveAimUntil = 0

    return false
end
function t1.value89.TriggerAction(p49)
    local One
    if p49 == "Skill1" then
        One = Enum.KeyCode.One
    elseif p49 == "Skill2" then
        One = Enum.KeyCode.Two
    elseif p49 == "Skill3" then
        One = Enum.KeyCode.Three
    elseif p49 == "Skill4" then
        One = Enum.KeyCode.G
    elseif p49 == "Skill5" then
        One = Enum.KeyCode.Four
    end
    if type(getgenv().ChromaticaBeginAutoMoveSilentAim) == "function" then
        pcall(getgenv().ChromaticaBeginAutoMoveSilentAim)
    end
    if t1.value13 then
        local ok7, result6 = pcall(function()
            return t1.value13:GetAction(p49, "Idle")
        end)
        local v393 = result6

        if ok7 and v393 then
            local v394 = false

            if type(v393.PressedCallback) == "function" then
                v394 = pcall(v393.PressedCallback) or v394
            end

            if type(v393.ReleasedCallback) == "function" then
                task.delay(0.03, function()
                    if t1.value2 ~= getgenv().ChromaticaSession then
                        return
                    end

                    if type(v393.ReleasedCallback) == "function" then
                        pcall(v393.ReleasedCallback)
                    end
                end)
            end

            if v394 then
                return true
            end
        end
    end
    if One and pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")

        VirtualInputManager:SendKeyEvent(true, One, false, game)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(false, One, false, game)
    end) then
        return true
    end

    return false
end
function t1.value89.PerformM1()
    if t1.value89.TriggerAction("M1") then
        return
    end

    local performM1 = t1.value7:FindFirstChild("performM1")

    if not performM1 then
        return
    end

    pcall(function()
        performM1:FireServer(nil)
    end)
end
function t1.value89.CanUseAutoMoves()
    if t1.value39 then
        return false
    end

    if not t1.value5.AttackOnlyAtMobGate or not t1.value5.AttackOnlyAtMobGate.Value then
        return true
    end

    local value32 = t1.value32

    if value32 then
        value32 = not t1.value89.IsIgnoredHighlightedRaidBoss(t1.value32) and t1.value89.IsEnemyAlive(t1.value32)
    end

    if value32 then
        return true
    end

    if t1.value30 and t1.value89.IsEnemyAlive(t1.value30) then
        return true
    end

    if t1.value31 and (t1.value31.Parent and t1.value89.IsRubbleBreakable()) then
        return true
    end

    return false
end
function t1.value89.IsHisokaBoss(p50)
    local v399 = not p50

    if not v399 then
        v399 = not p50.Parent or not t1.value89.IsEnemyAlive(p50)
    end

    if v399 then
        return false
    end

    if p50.Name ~= "0" then
        return false
    end

    local Asset = p50:FindFirstChild("Asset")

    if not Asset then
        return false
    end

    local hisoka = Asset:FindFirstChild("hisoka")

    if not hisoka then
        return false
    end

    local Cube = hisoka:FindFirstChild("Cube")

    if not Cube then
        return false
    end

    return Cube:IsA("MeshPart") and Cube.MeshId == "rbxassetid://130634965084241"
end
function t1.value89.CanUseAutoUltimate()
    if not t1.value5.OnlyUltAtBosses or not t1.value5.OnlyUltAtBosses.Value then
        return true
    end

    if t1.value5.RaidAutoFarm and t1.value5.RaidAutoFarm.Value then
        local v403 = t1.value32 ~= nil

        if v403 then
            v403 = t1.value32.Parent ~= nil

            if v403 then
                v403 = not t1.value89.IsIgnoredHighlightedRaidBoss(t1.value32) and (t1.value89.IsEnemyAlive(t1.value32) and t1.value89.IsTargetableRaidBoss(t1.value32))
            end
        end

        return v403
    end

    if t1.value5.AutoFarm and t1.value5.AutoFarm.Value then
        return t1.value30 ~= nil and t1.value89.IsHisokaBoss(t1.value30)
    end

    return false
end
function t1.value89.GetEndScreenButton(p51)
    local PlayerGui = t1.value10:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return nil
    end

    local EndScreen = PlayerGui:FindFirstChild("EndScreen")

    if not EndScreen then
        return nil
    end

    local Holder = EndScreen:FindFirstChild("Holder")

    if not Holder then
        return nil
    end

    local ConstraintedHolder = Holder:FindFirstChild("ConstraintedHolder")

    if not ConstraintedHolder then
        return nil
    end

    local ButtonsHolder = ConstraintedHolder:FindFirstChild("ButtonsHolder")

    if not ButtonsHolder then
        return nil
    end

    local p51_2 = ButtonsHolder:FindFirstChild(p51)

    if not p51_2 then
        return nil
    end

    return p51_2:FindFirstChild("Button")
end
function t1.value89.IsGuiVisible(p52)
    if not p52 then
        return false
    end

    while p52 and p52 ~= t1.value10.PlayerGui do
        if p52:IsA("GuiObject") and not p52.Visible then
            return false
        end

        if p52:IsA("LayerCollector") and not p52.Enabled then
            return false
        end

        p52 = p52.Parent
    end

    return true
end
function t1.value89.PressGuiButton(p53)
    if not p53 then
        return false
    end

    if not p53:IsA("GuiButton") then
        return false
    end

    if not t1.value89.IsGuiVisible(p53) then
        return false
    end

    if firesignal then
        if getconnections then
            local ok8, result7 = pcall(getconnections, p53.Activated)

            if ok8 then
                ok8 = result7 and #result7 > 0
            end

            if ok8 then
                pcall(firesignal, p53.Activated)

                return true
            end

            local ok9, result8 = pcall(getconnections, p53.MouseButton1Click)

            if ok9 then
                ok9 = result8 and #result8 > 0
            end

            if ok9 then
                pcall(firesignal, p53.MouseButton1Click)

                return true
            end
        end

        pcall(firesignal, p53.Activated)

        return true
    end

    return false
end
function t1.value89.GetQueueJoinHitbox(p54)
    local Systems = workspace:FindFirstChild("Systems")

    if not Systems then
        return nil
    end

    local QuqueRooms = Systems:FindFirstChild("QuqueRooms")

    if not QuqueRooms then
        return nil
    end

    local t24 = { tostring(p54) }
    local v421 = QuqueRooms:FindFirstChild(v2(t24))

    if not v421 then
        return nil
    end

    return v421:FindFirstChild("JoinHitbox")
end
function t1.value89.EnterQueueRoom(p55)
    local v423 = t1.value89.GetCharacterRoot()

    if not v423 then
        return false
    end

    local v424 = t1.value89.GetQueueJoinHitbox(p55)

    if not v424 then
        return false
    end

    local v425 = t1.value89.GetObjectCFrame(v424)

    if not v425 then
        return false
    end

    t1.value89.CancelMovementTween()
    v423.AssemblyLinearVelocity = Vector3.zero
    v423.AssemblyAngularVelocity = Vector3.zero
    v423.CFrame = v425

    if firetouchinterest and v424:IsA("BasePart") then
        pcall(function()
            firetouchinterest(v423, v424, 0)
            task.wait(0.2)
            firetouchinterest(v423, v424, 1)
        end)
    end

    return true
end
function t1.value89.NextRollingRequestId()
    t1.value65 = t1.value65 % 65535 + 1

    return t1.value65
end
function t1.value89.StopRolling()
    t1.value64 = t1.value64 + 1
    t1.value66 = nil
    t1.value67 = nil
    t1.value68 = nil
end
local value89_2 = t1.value89
local v78 = t2[10]
function value89_2.IsStopCharacter(p56)
    local v428 = v78[1][p56]

    if not v428 then
        return false
    end

    return t1.value63[v428] == true
end
function t1.value89.BuyCharacterSlot(p57)
    if not t1.value11 or not t1.value11.unlockCharacterSlot then
        return
    end
    local NextRollingRequestId = t1.value89.NextRollingRequestId
    local u431 = NextRollingRequestId()
    pcall(function()
        t1.value11.unlockCharacterSlot:fire({
			slot = p57,
			requestId = u431
		})
    end)
end
function t1.value89.StartRolling()
    t1.value64 = t1.value64 + 1

    local value64 = t1.value64

    task.spawn(function()
        while value64 == t1.value64 do
            if t1.value2 ~= getgenv().ChromaticaSession then
                return
            end

            if not t1.value5.RollingAutoRoll or not t1.value5.RollingAutoRoll.Value then
                return
            end

            if not (not t1.value11 or not t1.value11.rollCharacter) then
                local value62 = t1.value62
                local v594 = t1.value89.NextRollingRequestId()
                t1.value66 = v594
                t1.value67 = value62
                t1.value68 = nil
                local value73 = t1.value73
                local u596 = value73 ~= "Lucky" and "rolls" or "luckySpins"
                if not pcall(function()
                    t1.value11.rollCharacter:fire({
						spinType = value73,
						paymentCurrency = u596,
						slot = value62,
						requestId = v594
					})
                end) then
                    t1.value5.RollingAutoRoll:SetValue(false)

                    return
                end
                local v598 = os.clock() + t1.value72
                while true do
                    local v599 = value64 == t1.value64

                    if v599 then
                        v599 = t1.value5.RollingAutoRoll

                        if v599 then
                            v599 = t1.value5.RollingAutoRoll.Value

                            if v599 then
                                v599 = not t1.value68 and v598 > os.clock()
                            end
                        end
                    end

                    if not v599 then
                        break
                    end

                    task.wait(0.2)
                end
                if value64 ~= t1.value64 then
                    return
                end
                if not t1.value5.RollingAutoRoll or not t1.value5.RollingAutoRoll.Value then
                    return
                end
                local value68 = t1.value68
                t1.value66 = nil
                t1.value67 = nil
                t1.value68 = nil
                if not value68 then
                    t1.value5.RollingAutoRoll:SetValue(false)

                    return
                end
                if not value68.success then
                    t1.value5.RollingAutoRoll:SetValue(false)

                    return
                end
                if t1.value89.IsStopCharacter(value68.character) then
                    t1.value5.RollingAutoRoll:SetValue(false)

                    return
                end
                local v601 = os.clock() + t1.value71
                while true do
                    local v602 = value64 == t1.value64

                    if v602 then
                        v602 = t1.value5.RollingAutoRoll and (t1.value5.RollingAutoRoll.Value and v601 > os.clock())
                    end

                    if not v602 then
                        break
                    end

                    task.wait(0.2)
                end

                continue
            end

            if t1.value12 then
                t1.value5.RollingAutoRoll:SetValue(false)

                return
            end

            task.wait(0.1)
        end
    end)
end
function t1.value89.NextTraitRerollRequestId()
    t1.value77 = t1.value77 % 65535 + 1

    return t1.value77
end
function t1.value89.StopTraitReroll()
    t1.value76 = t1.value76 + 1
    t1.value78 = nil
    t1.value79 = nil
    t1.value80 = nil
end
function t1.value89.HasTraitStopSelection()
    for _, v in pairs(t1.value75) do
        if v then
            return true
        end
    end

    return false
end
function t1.value89.IsStopTraitId(p58)
    local v437 = tonumber(p58) or p58
    local v438 = t1.value16[v437]

    if not v438 then
        return false
    end

    return t1.value75[v438] == true
end
function t1.value89.GetCharacterFromSlot(p59)
    if not t1.value14 or (not t1.value14.state or not t1.value14.state.UnlockedCharacters) then
        return nil
    end
    local v440 = t1.value14.state.UnlockedCharacters["Slot" .. tostring(p59)]
    if not v440 then
        return nil
    end
    local u441 = false
    local u442
    pcall(function()
        u441 = v440.Unlocked:get()
    end)
    if not u441 then
        return nil
    end
    pcall(function()
        u442 = v440.Character:get()
    end)
    if type(u442) ~= "string" or u442 == "" then
        return nil
    end

    return u442
end
function t1.value89.GetCurrentTraitId(p60)
    local v444 = not t1.value14
    if not v444 then
        v444 = not t1.value14.state or not t1.value14.state.CharactersData
    end
    if v444 then
        return nil
    end
    local v445 = t1.value14.state.CharactersData[p60]
    if not v445 or (not v445.TraitData or not v445.TraitData.Trait) then
        return nil
    end
    local success, result = pcall(function()
        return v445.TraitData.Trait:get()
    end)
    if not success then
        return nil
    end

    return tonumber(result) or result
end
function t1.value89.StartTraitReroll()
    t1.value76 = t1.value76 + 1

    local value76 = t1.value76

    task.spawn(function()
        local v603 = os.clock() + 10

        while true do
            local v604 = value76 == t1.value76

            if v604 then
                v604 = t1.value5.TraitAutoReroll

                if v604 then
                    v604 = t1.value5.TraitAutoReroll.Value

                    if v604 then
                        v604 = not t1.value14 and v603 > os.clock()
                    end
                end
            end

            if not v604 then
                break
            end

            task.wait(0.1)
        end

        if value76 ~= t1.value76 then
            return
        end

        if not t1.value14 then
            t1.value5.TraitAutoReroll:SetValue(false)

            return
        end

        if not t1.value89.HasTraitStopSelection() then
            t1.value5.TraitAutoReroll:SetValue(false)

            return
        end

        while value76 == t1.value76 do
            if t1.value2 ~= getgenv().ChromaticaSession then
                return
            end

            if not t1.value5.TraitAutoReroll or not t1.value5.TraitAutoReroll.Value then
                return
            end

            if not (not t1.value11 or not t1.value11.rollTrait) then
                if not t1.value89.HasTraitStopSelection() then
                    t1.value5.TraitAutoReroll:SetValue(false)

                    return
                end

                local v605 = t1.value89.GetCharacterFromSlot(t1.value74)

                if not v605 then
                    t1.value5.TraitAutoReroll:SetValue(false)

                    return
                end

                local v606 = t1.value89.GetCurrentTraitId(v605)

                if v606 and t1.value89.IsStopTraitId(v606) then
                    t1.value5.TraitAutoReroll:SetValue(false)

                    return
                end

                local v607 = t1.value83 - (os.clock() - t1.value82)
                local v608 = v607

                while true do
                    local v609 = v608 > 0

                    if v609 then
                        v609 = value76 == t1.value76

                        if v609 then
                            v609 = t1.value5.TraitAutoReroll and t1.value5.TraitAutoReroll.Value
                        end
                    end

                    if not v609 then
                        break
                    end

                    task.wait((math.min(v608, 0.05)))
                    v607 = t1.value83 - (os.clock() - t1.value82)
                    v608 = v607
                end

                if value76 ~= t1.value76 then
                    return
                end

                if not t1.value5.TraitAutoReroll or not t1.value5.TraitAutoReroll.Value then
                    return
                end

                local v610 = t1.value89.NextTraitRerollRequestId()

                t1.value78 = v610
                t1.value79 = v605
                t1.value80 = nil
                t1.value82 = os.clock()

                if not pcall(function()
                    t1.value11.rollTrait:fire({
						character = v605,
						requestId = v610
					})
                end) then
                    t1.value5.TraitAutoReroll:SetValue(false)

                    return
                end

                local v611 = os.clock() + t1.value84

                while true do
                    local v612 = value76 == t1.value76

                    if v612 then
                        v612 = t1.value5.TraitAutoReroll

                        if v612 then
                            v612 = t1.value5.TraitAutoReroll.Value

                            if v612 then
                                v612 = not t1.value80 and v611 > os.clock()
                            end
                        end
                    end

                    if not v612 then
                        break
                    end

                    task.wait(0.2)
                end

                if value76 ~= t1.value76 then
                    return
                end

                if not t1.value5.TraitAutoReroll or not t1.value5.TraitAutoReroll.Value then
                    return
                end

                local value80 = t1.value80

                t1.value78 = nil
                t1.value79 = nil
                t1.value80 = nil

                if not value80 then
                    t1.value5.TraitAutoReroll:SetValue(false)

                    return
                end

                if not value80.success then
                    t1.value5.TraitAutoReroll:SetValue(false)

                    return
                end

                if not t1.value89.IsStopTraitId(value80.traitId) then
                    continue
                end

                t1.value5.TraitAutoReroll:SetValue(false)

                return
            end

            if t1.value12 then
                t1.value5.TraitAutoReroll:SetValue(false)

                return
            end

            task.wait(0.1)
        end
    end)
end
v44:AddToggle("AutoFarm", {
	Text = "Auto Farm",
	Default = false,
	Callback = function(p61)
    if p61 then
        if t1.value5.RaidAutoFarm and t1.value5.RaidAutoFarm.Value then
            t1.value5.RaidAutoFarm:SetValue(false)

            return
        end
    else
        t1.value25 = 0
        t1.value30 = nil
        t1.value31 = nil
        t1.value89.CancelMovementTween()
    end
end
})
v44:AddToggle("TrialsAutoFarm", {
	Text = "Trials Auto Farm",
	Default = false,
	Callback = function(_)
    t1.value30 = nil
    t1.value31 = nil
    t1.value25 = 0
    t1.value57.ActiveLiftPrompt = nil
    t1.value57.NextLiftAttempt = 0
    t1.value89.CancelMovementTween()
end
})
v44:AddToggle("RaidAutoFarm", {
	Text = "Raid Auto Farm",
	Default = false,
	Callback = function(p63)
    if p63 and (t1.value5.AutoFarm and t1.value5.AutoFarm.Value) then
        t1.value5.AutoFarm:SetValue(false)
    end

    t1.value32 = nil
    t1.value35 = false
    t1.value36 = 0

    if not p63 then
        t1.value89.CancelMovementTween()
    end
end
})
v44:AddDropdown("FarmMethod", {
	Values = {
		"Behind",
		"Below",
		"Above",
		"Orbit"
	},
	Default = "Behind",
	Multi = false,
	Text = "Farm Method",
	Callback = function(p64)
    t1.value22 = p64

    if p64 ~= "Orbit" then
        t1.value25 = 0
    end
end
})
v44:AddSlider("FarmDistance", {
	Text = "Distance",
	Default = 8,
	Min = 1,
	Max = 30,
	Rounding = 1,
	Callback = function(p65)
    t1.value23 = p65
end
})
v44:AddSlider("OrbitSpeed", {
	Text = "Orbit Speed",
	Default = 5,
	Min = 1,
	Max = 20,
	Rounding = 1,
	Callback = function(p66)
    t1.value24 = p66
end
})
v45:AddToggle("AttackOnlyAtMobGate", {
	Text = "Attack Only At Mob/Gate",
	Default = false
})
v45:AddToggle("OnlyUltAtBosses", {
	Text = "Only Ult At Bosses",
	Default = false
})
local AddDivider = v45.AddDivider
local t26 = {
	Text = "Auto M1",
	Default = false
}
AddDivider(v45)
v45:AddToggle("AutoM1", t26)
v45:AddToggle("AutoSkill1", {
	Text = "Auto Skill 1",
	Default = false
})
v45:AddToggle("AutoSkill2", {
	Text = "Auto Skill 2",
	Default = false
})
v45:AddToggle("AutoSkill3", {
	Text = "Auto Skill 3",
	Default = false
})
v45:AddToggle("AutoUltimate", {
	Text = "Auto Ultimate",
	Default = false
})
v45:AddSlider("MoveDelay", {
	Text = "Move Delay",
	Default = 0.25,
	Min = 0.1,
	Max = 1,
	Rounding = 2,
	Callback = function(p67)
    t1.value41 = p67
end
})
v47:AddToggle("AutoRetry", {
	Text = "Auto Retry",
	Default = false
})
v47:AddToggle("AutoNextMap", {
	Text = "Auto Next Map",
	Default = false
})
v47:AddToggle("AutoLeave", {
	Text = "Auto Leave",
	Default = false
})
v49:AddInput("InfinityResetWave", {
	Default = "1",
	Numeric = true,
	Finished = false,
	Text = "Reset Wave",
	Callback = function(p68)
    local num = tonumber(p68)

    if not num then
        return
    end

    t1.value52 = math.clamp(math.floor(num), 1, 999)
    t1.value53 = false
    t1.value54 = nil
end
})
v49:AddToggle("InfinityAutoReset", {
	Text = "Auto Reset",
	Default = false,
	Callback = function()
    t1.value53 = false
    t1.value54 = nil
end
})
v50:AddToggle("SafeSpotEnabled", {
	Text = "Safe Spot",
	Default = false,
	Callback = function(p69)
    if not p69 then
        t1.value39 = false
        t1.value40 = nil
    end
end
})
v50:AddSlider("SafeSpotAwayHP", {
	Text = "TP Away HP %",
	Default = 20,
	Min = 1,
	Max = 99,
	Rounding = 0,
	Callback = function(p70)
    t1.value37 = math.floor(p70)
end
})
v50:AddSlider("SafeSpotReturnHP", {
	Text = "TP Back HP %",
	Default = 40,
	Min = 1,
	Max = 100,
	Rounding = 0,
	Callback = function(p71)
    t1.value38 = math.floor(p71)
end
})
v57:AddToggle("RollingAutoRoll", {
	Text = "Auto Roll",
	Default = false,
	Callback = function(p72)
    if p72 then
        t1.value89.StartRolling()

        return
    end

    t1.value89.StopRolling()
end
})
v57:AddToggle("RollingNormalSpins", {
	Text = "Normal Spins",
	Default = true,
	Callback = function(p73)
    if p73 then
        t1.value73 = "Normal"

        if t1.value5.RollingLuckySpins and t1.value5.RollingLuckySpins.Value then
            t1.value5.RollingLuckySpins:SetValue(false)
        end
    end
end
})
v57:AddToggle("RollingLuckySpins", {
	Text = "Lucky Spins",
	Default = false,
	Callback = function(p74)
    if p74 then
        t1.value73 = "Lucky"

        if t1.value5.RollingNormalSpins and t1.value5.RollingNormalSpins.Value then
            t1.value5.RollingNormalSpins:SetValue(false)
        end
    end
end
})
v57:AddDropdown("RollingSlot", {
	Values = {
		"Slot 1",
		"Slot 2",
		"Slot 3",
		"Slot 4"
	},
	Default = "Slot 1",
	Multi = false,
	Text = "Roll Slot",
	Callback = function(p75)
    t1.value62 = tonumber(string.match(p75, "%d+")) or 1
end
})
v57:AddDropdown("RollingStopCharacters", {
	Values = {
		"Rubber Man",
		"Cosmic Warrior",
		"Thunder Prodigy",
		"Twisted Agony",
		"Kings Gambit",
		"Lights of Divinity",
		"Dragon Eclipse",
		"Immortal Sovereign",
		"Cursed King",
		"Divine Emperor",
		"Cataclysm",
		"Mochi Commander"
	},
	Multi = true,
	Text = "Stop On Characters",
	Searchable = true,
	Callback = function(p76)
    t1.value63 = p76 or {}
end
})
if t1.value4.RollingStopCharacters then
    t1.value4.RollingStopCharacters:SetValue({})
end
v58:AddToggle("TraitAutoReroll", {
	Text = "Auto Trait Reroll",
	Default = false,
	Callback = function(p77)
    if p77 then
        t1.value89.StartTraitReroll()

        return
    end

    t1.value89.StopTraitReroll()
end
})
v58:AddDropdown("TraitRerollSlot", {
	Values = {
		"Slot 1",
		"Slot 2",
		"Slot 3",
		"Slot 4"
	},
	Default = "Slot 1",
	Multi = false,
	Text = "Trait Slot",
	Callback = function(p78)
    t1.value74 = tonumber(string.match(p78, "%d+")) or 1
end
})
v58:AddDropdown("TraitRerollStopTraits", {
	Values = t6,
	Multi = true,
	Text = "Stop On Traits",
	Searchable = true,
	Callback = function(p79)
    t1.value75 = p79 or {}
end
})
if t1.value4.TraitRerollStopTraits then
    t1.value4.TraitRerollStopTraits:SetValue({})
end
v59:AddButton({
	Text = "Buy Slot 2 - $25,000",
	Func = function()
    t1.value89.BuyCharacterSlot(2)
end
})
v59:AddButton({
	Text = "Buy Slot 3 - $100,000",
	Func = function()
    t1.value89.BuyCharacterSlot(3)
end
})
v59:AddButton({
	Text = "Buy Slot 4 - $1,000,000",
	Func = function()
    t1.value89.BuyCharacterSlot(4)
end
})
function t1.value57.GetHighestPlayableFloor()
    local v467 = os.clock() + 10
    while not t1.value14 and v467 > os.clock() do
        task.wait(0.1)
    end
    if not t1.value14 or (not t1.value14.state or (not t1.value14.state.achievements or not t1.value14.state.achievements.progress)) then
        return 1
    end
    local SeasonId
    pcall(function()
        local LeaderboardSeasonConfig = require(t1.value7.assets.config.LeaderboardSeasonConfig)

        if LeaderboardSeasonConfig and LeaderboardSeasonConfig.Season then
            SeasonId = LeaderboardSeasonConfig.Season.Id
        end
    end)
    if SeasonId == nil then
        return 1
    end
    local function v469(p80)

        local u616 = p80
        local n5 = 0
        pcall(function()
            local v674 = t1.value14.state.achievements.progress:get(u616)

            if v674 then
                n5 = tonumber(v674:get()) or 0
            end
        end)

        return n5
    end
    local v470 = "trials.s" .. tostring(SeasonId)

    return math.max(v469(v470 .. ".room"), (v469(v470 .. ".unlocked"))) + 1
end
function t1.value89.UpdateGamemodeOptions()
    if not t1.value4.QueueAct or not t1.value4.QueueDifficulty then
        return
    end

    if t1.value17 == "Story" then
        t1.value4.QueueAct:SetValues({
			"1",
			"2",
			"3"
		})
        t1.value4.QueueDifficulty:SetValues({
			"Easy",
			"Medium",
			"Hard",
			"Nightmare"
		})

        return
    end

    if t1.value17 == "Infinite" then
        t1.value18 = 1
        t1.value4.QueueAct:SetValues({ "1" })
        t1.value4.QueueAct:SetValue("1")
        t1.value4.QueueDifficulty:SetValues({
			"Easy",
			"Medium",
			"Hard",
			"Nightmare"
		})

        return
    end

    if t1.value17 == "Trials" then
        t1.value18 = 1
        t1.value19 = "Easy"
        t1.value4.QueueAct:SetValues({ "Auto Highest Floor" })
        t1.value4.QueueAct:SetValue("Auto Highest Floor")
        t1.value4.QueueDifficulty:SetValues({ "Easy" })
        t1.value4.QueueDifficulty:SetValue("Easy")

        return
    end

    if t1.value17 == "Raid" then
        t1.value19 = "Nightmare"
        t1.value4.QueueAct:SetValues({
			"Spirit's Bathtub",
			"Shadow Gate"
		})
        t1.value4.QueueAct:SetValue(t1.value86.Raid.MapNames[t1.value86.Raid.SelectedMap] or "Spirit's Bathtub")
        t1.value4.QueueDifficulty:SetValues({ "Nightmare" })
        t1.value4.QueueDifficulty:SetValue("Nightmare")
    end
end
function t1.value89.StartQueue(p81)
    if not t1.value5.QueueAutoJoin or not t1.value5.QueueAutoJoin.Value then
        return
    end

    if not t1.value11 or not t1.value11.createQuque then
        return
    end

    if not p81 then
        return
    end

    local v472 = t1.value86[t1.value17]

    if not v472 then
        return
    end

    local n6 = 0
    local n7 = 0
    local Map = v472.Map
    local value19 = t1.value19
    local v477 = t1.value85[value19] or 1

    if t1.value17 == "Story" then
        n6 = t1.value18
    elseif t1.value17 == "Trials" then
        n6 = 0
        n7 = t1.value57.GetHighestPlayableFloor()
        v477 = 1
        Map = "Trials"
    elseif t1.value17 == "Raid" then
        Map = v472.SelectedMap
        v477 = 4

        if not Map then
            Map = v472.Map
        end
    end

    local value20 = t1.value20
    local value21 = t1.value21
    local t27 = {
		gamemode = t1.value17,
		map = Map,
		chapter = n6,
		floor = n7,
		difficulty = v477,
		maxPlayers = value20,
		friendsOnly = value21,
		roomNumber = p81
	}

    if t1.value10:GetAttribute("QueueLeader") ~= true then
        pcall(function()
            t1.value11.createQuque:fire(t27)
        end)
    end

    local QueueInstantStart = t1.value5.QueueInstantStart

    if QueueInstantStart then
        QueueInstantStart = t1.value5.QueueInstantStart.Value

        if QueueInstantStart then
            QueueInstantStart = t1.value10:GetAttribute("QueueLeader") == true and (t1.value11.startQuqueNow and type(t1.value11.startQuqueNow.fire) == "function")
        end
    end

    if QueueInstantStart then
        pcall(function()
            t1.value11.startQuqueNow:fire()
        end)
    end
end
function t1.value89.LeaveQueue()
    t1.value56 = nil

    if not t1.value11 or not t1.value11.leaveQuque then
        return
    end

    pcall(function()
        t1.value11.leaveQuque:fire()
    end)
end
function t1.value89.TriggerAutoJoin()
    if not t1.value5.QueueAutoJoin or not t1.value5.QueueAutoJoin.Value then
        return
    end

    t1.value55 = t1.value55 + 1

    local value55 = t1.value55

    t1.value56 = nil
    task.spawn(function()
        while true do
            local v618 = not t1.value11

            if v618 then
                v618 = not t1.value12

                if v618 then
                    v618 = value55 == t1.value55

                    if v618 then
                        v618 = t1.value5.QueueAutoJoin

                        if v618 then
                            v618 = t1.value5.QueueAutoJoin.Value
                        end
                    end
                end
            end

            if not v618 then
                break
            end

            task.wait()
        end
        local v619 = value55 ~= t1.value55
        if not v619 then
            v619 = not t1.value5.QueueAutoJoin or (not t1.value5.QueueAutoJoin.Value or not t1.value11)
        end
        if v619 then
            return
        end
        local v620 = t1.value89.GetRandomRoom()
        t1.value56 = v620
        while true do
            local v622 = value55 == t1.value55

            if v622 then
                v622 = t1.value5.QueueAutoJoin

                if v622 then
                    v622 = t1.value5.QueueAutoJoin.Value and t1.value2 == getgenv().ChromaticaSession
                end
            end

            if not v622 then
                break
            end

            if t1.value10:GetAttribute("QueueLeader") ~= true then
                t1.value89.EnterQueueRoom(v620)
            end

            t1.value89.StartQueue(v620)
            task.wait(0.5)
        end
    end)
end
function t1.value89.ClaimAllQuests()
    local v483 = not t1.value11

    if not v483 then
        v483 = not t1.value11.claimQuestRewards or type(t1.value11.claimQuestRewards.fire) ~= "function"
    end

    if v483 then
        return false
    end

    t1.value59 = t1.value59 % 65535 + 1

    return pcall(function()
        t1.value11.claimQuestRewards:fire({
			requestId = t1.value59
		})
    end)
end
function t1.value89.StartAutoClaimAllQuests()
    t1.value58 = t1.value58 + 1

    local value58 = t1.value58

    task.spawn(function()
        while true do
            local v623 = t1.value58 == value58

            if v623 then
                v623 = t1.value2 == getgenv().ChromaticaSession

                if v623 then
                    v623 = t1.value5.AutoClaimAllQuests and t1.value5.AutoClaimAllQuests.Value
                end
            end

            if not v623 then
                break
            end

            t1.value89.ClaimAllQuests()
            task.wait(2)
        end
    end)
end
function t1.value89.ClaimAllAchievements()
    if not t1.value11 or (not t1.value11.claimAchievementRewards or type(t1.value11.claimAchievementRewards.fire) ~= "function") then
        return false
    end

    t1.value61 = t1.value61 % 65535 + 1

    return pcall(function()
        t1.value11.claimAchievementRewards:fire({
			requestId = t1.value61
		})
    end)
end
function t1.value89.StartAutoClaimAllAchievements()
    t1.value60 = t1.value60 + 1

    local value60 = t1.value60

    task.spawn(function()
        while true do
            local v624 = value60 == t1.value60

            if v624 then
                v624 = t1.value2 == getgenv().ChromaticaSession

                if v624 then
                    v624 = t1.value5.AutoClaimAllAchievements

                    if v624 then
                        v624 = t1.value5.AutoClaimAllAchievements.Value
                    end
                end
            end

            if not v624 then
                break
            end

            t1.value89.ClaimAllAchievements()
            task.wait(2)
        end
    end)
end
v51:AddDropdown("QueueGamemode", {
	Values = {
		"Story",
		"Infinite",
		"Raid",
		"Trials"
	},
	Default = 1,
	Multi = false,
	Text = "Gamemode",
	Callback = function(p82)
    t1.value17 = p82
    t1.value89.UpdateGamemodeOptions()
end
})
v51:AddDropdown("QueueAct", {
	Values = {
		"1",
		"2",
		"3"
	},
	Default = 1,
	Multi = false,
	Text = "Act / Raid Map",
	Callback = function(p83)
    if t1.value17 == "Raid" then
        t1.value86.Raid.SelectedMap = t1.value86.Raid.MapIds[p83] or t1.value86.Raid.SelectedMap

        return
    end

    if t1.value17 == "Trials" then
        return
    end

    t1.value18 = tonumber(p83) or 1
end
})
v51:AddDropdown("QueueDifficulty", {
	Values = {
		"Easy",
		"Medium",
		"Hard",
		"Nightmare"
	},
	Default = 1,
	Multi = false,
	Text = "Difficulty",
	Callback = function(p84)
    t1.value19 = p84
end
})
v51:AddSlider("QueueMaxPlayers", {
	Text = "Max Players",
	Default = 6,
	Min = 1,
	Max = 6,
	Rounding = 0,
	Callback = function(p85)
    t1.value20 = p85
end
})
v51:AddToggle("QueueFriendsOnly", {
	Text = "Friends Only",
	Default = false,
	Callback = function(p86)
    t1.value21 = p86
end
})
local t28 = {
	Text = "Instant Start",
	Default = false,
	Callback = function(p87)
    local v491 = not p87

    if not v491 then
        v491 = not t1.value11 or (not t1.value11.startQuqueNow or (type(t1.value11.startQuqueNow.fire) ~= "function" or t1.value10:GetAttribute("QueueLeader") ~= true))
    end

    if v491 then
        return
    end

    pcall(function()
        t1.value11.startQuqueNow:fire()
    end)
end
}
v51:AddDivider()
v51:AddToggle("QueueInstantStart", t28)
v51:AddToggle("QueueAutoJoin", {
	Text = "Auto Join",
	Default = false,
	Callback = function(p88)
    if p88 then
        t1.value89.TriggerAutoJoin()

        return
    end

    t1.value55 = t1.value55 + 1
    t1.value89.LeaveQueue()
end
})
v52:AddToggle("AutoClaimAllQuests", {
	Text = "Auto Claim All Quests",
	Default = false,
	Callback = function(p89)
    t1.value58 = t1.value58 + 1

    if p89 then
        t1.value89.StartAutoClaimAllQuests()
    end
end
})
v52:AddToggle("AutoClaimAllAchievements", {
	Text = "Auto Claim All Achievements",
	Default = false,
	Callback = function(p90)
    t1.value60 = t1.value60 + 1

    if p90 then
        t1.value89.StartAutoClaimAllAchievements()
    end
end
})
local v82 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
t1.value131 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()
t1.value132 = "Chromatica/AnimeZero/autosave_enabled.txt"
t1.value133 = "Chromatica/AnimeZero/autosave.json"
t1.value134 = "Chromatica/AnimeZero/settings/autosave.json"
t1.value135 = false
t1.value136 = false
v82:SetLibrary(t1.value3)
t1.value131:SetLibrary(t1.value3)
t1.value131:IgnoreThemeSettings()
t1.value131:SetIgnoreIndexes({
	"MenuKeybind",
	"AutoSave"
})
v82:SetFolder("Chromatica")
t1.value131:SetFolder("Chromatica/AnimeZero")
if makefolder and isfolder then
    pcall(function()
        if not isfolder("Chromatica") then
            makefolder("Chromatica")
        end

        if not isfolder("Chromatica/AnimeZero") then
            makefolder("Chromatica/AnimeZero")
        end
    end)
end
if isfile and readfile then
    pcall(function()
        if isfile(t1.value132) then
            t1.value135 = readfile(t1.value132) == "true"
        end
    end)

    if writefile then
        pcall(function()
            if isfile(t1.value133) and not isfile(t1.value134) then
                writefile(t1.value134, readfile(t1.value133))
            end
        end)
    end
end
local v83 = t12["UI Settings"]:AddGroupbox({
	Side = "Left",
	Name = "Menu"
})
local KeybindFrameVisible = t1.value3.KeybindFrame.Visible
v83:AddToggle("KeybindMenuOpen", {
	Text = "Open Keybind Menu",
	Default = KeybindFrameVisible,
	Callback = function(p91)
    t1.value3.KeybindFrame.Visible = p91
end
})
local ShowCustomCursor = t1.value3.ShowCustomCursor
v83:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = ShowCustomCursor,
	Callback = function(p92)
    t1.value3.ShowCustomCursor = p92
end
})
local AlwaysOnTop = t1.value90.AlwaysOnTop
v83:AddToggle("AlwaysOnTop", {
	Text = "Always On Top",
	Default = AlwaysOnTop,
	Callback = function(p93)
    t1.value90:SetAlwaysOnTop(p93)
end
})
v83:AddDropdown("NotificationSide", {
	Values = {
		"Left",
		"Right"
	},
	Default = "Right",
	Multi = false,
	Text = "Notification Side",
	Callback = function(p94)
    t1.value3:SetNotifySide(p94)
end
})
v83:AddDropdown("DPIDropdown", {
	Values = {
		"50%",
		"75%",
		"100%",
		"125%",
		"150%",
		"175%",
		"200%"
	},
	Default = "100%",
	Multi = false,
	Text = "DPI Scale",
	Callback = function(p95)
    local num = tonumber((p95:gsub("%%", "")))

    if num then
        t1.value3:SetDPIScale(num)
    end
end
})
local CornerRadius = t1.value3.CornerRadius
v83:AddSlider("UICornerSlider", {
	Text = "Corner Radius",
	Default = CornerRadius,
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(p96)
    t1.value90:SetCornerRadius(p96)
end
})
local value135 = t1.value135
v83:AddToggle("AutoSave", {
	Text = "Auto Save",
	Default = value135,
	Callback = function(p97)
    t1.value135 = p97

    if writefile then
        pcall(function()
            writefile(t1.value132, not p97 and "false" or "true")
        end)
    end

    if p97 then
        pcall(function()
            t1.value131:CheckFolderTree()
            t1.value131:Save("autosave")
        end)
    end
end
})
v83:AddDivider()
local AddLabel = v83.AddLabel
local t29 = {
	Default = "RightShift",
	NoUI = true,
	Text = "Menu keybind"
}
AddLabel(v83, "Menu bind"):AddKeyPicker("MenuKeybind", t29)
v83:AddButton("Unload", function()
    t1.value3:Unload()
end)
t1.value3.ToggleKeybind = t1.value4.MenuKeybind
t1.value131:BuildConfigSection(t12["UI Settings"])
v82:ApplyToTab(t12["UI Settings"])
function t1.value137()
    if not t1.value135 or t1.value136 then
        return
    end

    t1.value136 = true
    task.delay(0.1, function()
        t1.value136 = false

        if not t1.value135 then
            return
        end

        pcall(function()
            t1.value131:Save("autosave")
        end)
    end)
end
if t1.value135 then
    pcall(function()
        t1.value131:Load("autosave")
    end)
else
    pcall(function()
        t1.value131:LoadAutoloadConfig()
    end)
end
task.delay(0.75, function()
    for k, v in pairs(t1.value5) do
        local v505 = v

        if k ~= "AutoSave" then
            pcall(function()
                local Changed = v505.Changed
                local u626 = Changed
                v505:OnChanged(function(p98)
                    if type(u626) == "function" then
                        pcall(u626, p98)
                    end

                    t1.value137()
                end)
            end)
        end
    end

    for k, v in pairs(t1.value4) do
        local v508 = v
        local v509 = k

        if v509 ~= "MenuKeybind" and not string.find(tostring(v509), "^SaveManager_") then
            pcall(function()
                local Changed = v508.Changed
                local u628 = Changed
                v508:OnChanged(function(p99)
                    if type(u628) == "function" then
                        pcall(u628, p99)
                    end

                    t1.value137()
                end)
            end)
        end
    end
end)
task.spawn(function()
    while t1.value2 == getgenv().ChromaticaSession and not t1.value3.Unloaded do
        task.wait(3)

        if t1.value135 then
            pcall(function()
                t1.value131:Save("autosave")
            end)
        end
    end
end)
t1.value3:OnUnload(function()
    if t1.value135 then
        pcall(function()
            t1.value131:Save("autosave")
        end)
    end
end)
local Heartbeat = t1.value8.Heartbeat
local v92 = t2[6]
t1.value138 = Heartbeat:Connect(function()
    if not t1.value5.SafeSpotEnabled or not t1.value5.SafeSpotEnabled.Value then
        t1.value39 = false
        t1.value40 = nil

        return
    end

    local v510 = t1.value89.GetCharacterRoot()
    local v511 = t1.value89.GetHealthPercent()

    if not v510 or not v511 then
        return
    end

    if not t1.value39 then
        if v511 <= t1.value37 then
            local value32

            if t1.value32 and (t1.value32.Parent and t1.value89.IsEnemyAlive(t1.value32)) then
                value32 = t1.value32
            else
                local value30 = t1.value30

                if value30 then
                    value30 = t1.value30.Parent and t1.value89.IsEnemyAlive(t1.value30)
                end

                value32 = if not value30 then if not (t1.value5.RaidAutoFarm and t1.value5.RaidAutoFarm.Value) then t1.value89.GetNearestEnemy() else t1.value89.GetNearestRaidEnemy() else t1.value30
            end

            if t1.value89.GetEnemyRoot(value32) then
                t1.value39 = true
                t1.value40 = {
					Return = v510.CFrame,
					Enemy = value32
				}

                return
            end
        end
    else
        if v511 >= t1.value38 then
            if t1.value40 and t1.value40.Return then
                t1.value89.TweenRootTo(t1.value40.Return)

                if (v510.Position - t1.value40.Return.Position).Magnitude <= 2 then
                    t1.value89.CancelMovementTween()
                    t1.value39 = false
                    t1.value40 = nil

                    return
                end
            else
                t1.value39 = false
                t1.value40 = nil
            end

            return
        end

        local value40 = t1.value40

        if value40 then
            value40 = t1.value40.Enemy
        end

        local v515 = not value40

        if not v515 then
            v515 = not value40.Parent or not t1.value89.IsEnemyAlive(value40)
        end

        if v515 then
            value40 = if not (t1.value5.RaidAutoFarm and t1.value5.RaidAutoFarm.Value) then t1.value89.GetNearestEnemy() else t1.value89.GetNearestRaidEnemy()

            if t1.value40 then
                t1.value40.Enemy = value40
            end
        end

        local v516 = t1.value89.GetEnemyRoot(value40)

        if v516 then
            local v517 = v516.Position + Vector3.new(0, v92[1], 0)

            t1.value89.TweenRootTo(CFrame.new(v517, v516.Position))
        end
    end
end)
t1.value139 = t1.value8.Heartbeat:Connect(function(dt)
    if t1.value39 then
        t1.value30 = nil
        t1.value31 = nil
        t1.value25 = 0

        return
    end

    if t1.value5.RaidAutoFarm and t1.value5.RaidAutoFarm.Value then
        t1.value25 = 0
        t1.value30 = nil
        t1.value31 = nil

        return
    end

    local v519 = t1.value5.TrialsAutoFarm and t1.value5.TrialsAutoFarm.Value
    local v520 = t1.value5.AutoFarm and t1.value5.AutoFarm.Value
    local v521 = not v519

    if v521 then
        v521 = not v520
    end

    if v521 then
        t1.value25 = 0
        t1.value30 = nil
        t1.value31 = nil

        return
    end

    if not t1.value89.GetCharacterRoot() then
        t1.value30 = nil
        t1.value31 = nil

        return
    end

    if v519 and t1.value57.UseLift() then
        t1.value30 = nil
        t1.value31 = nil
        t1.value25 = 0

        return
    end

    if t1.value30 and (t1.value30.Parent and t1.value89.IsEnemyAlive(t1.value30)) then
        local v522 = t1.value89.GetEnemyRoot(t1.value30)

        if v522 then
            if v519 then
                t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v522, t1.value23))

                return
            end

            t1.value89.TweenRootTo(t1.value89.GetFarmCFrame(v522, dt))

            return
        end
    end

    t1.value30 = nil

    local v523 = t1.value89.GetNearestEnemy()

    if v523 then
        local v524 = t1.value89.GetEnemyRoot(v523)

        if v524 then
            t1.value30 = v523
            t1.value31 = nil

            if v519 then
                t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v524, t1.value23))

                return
            end

            t1.value89.TweenRootTo(t1.value89.GetFarmCFrame(v524, dt))

            return
        end
    end

    if v519 then
        t1.value31 = nil
        t1.value25 = 0

        return
    end

    if t1.value89.IsRubbleBreakable() then
        local v525 = t1.value89.GetActiveBorderBlocker()

        if v525 then
            t1.value31 = v525
            t1.value89.TeleportBehindObject(v525, 3)

            return
        end
    end

    t1.value31 = nil

    local v526 = t1.value89.GetCurrentArea()

    if v526 then
        t1.value89.TeleportToArea(v526)
    end
end)
local Heartbeat2 = t1.value8.Heartbeat
local v94 = t2[7]
local v95 = t2[8]
t1.value140 = Heartbeat2:Connect(function()
    if t1.value39 then
        t1.value32 = nil

        return
    end

    if not t1.value5.RaidAutoFarm or not t1.value5.RaidAutoFarm.Value then
        t1.value32 = nil
        t1.value35 = false
        t1.value36 = 0

        return
    end

    if not t1.value89.GetCharacterRoot() then
        t1.value32 = nil

        return
    end

    local elapsed = os.clock()
    local _, v529 = t1.value89.GetRaidExitPrompt()

    if v529 and (v529.Parent and v529.Enabled) then
        t1.value35 = true
        t1.value36 = 0
        t1.value32 = nil

        local v530 = t1.value89.GetRaidPromptTarget(v529)

        if v530 then
            t1.value89.TeleportToObject(v530, 0)
        end

        if elapsed - t1.value34 >= v94[1] then
            t1.value34 = elapsed
            t1.value89.UseRaidExitPrompt(v529)
        end

        return
    end

    if t1.value35 then
        t1.value35 = false
        t1.value36 = elapsed + v95[1]
        t1.value32 = nil

        return
    end

    if t1.value36 > 0 then
        if elapsed < t1.value36 then
            t1.value32 = nil

            return
        end

        t1.value36 = 0
    end

    local v531 = t1.value89.GetSpecialRaidBoss()

    if v531 then
        if t1.value89.IsIgrisTargetable(v531) then
            local v532 = t1.value89.GetEnemyRoot(v531)

            if v532 then
                t1.value32 = v531
                t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v532, t1.value89.GetRaidTargetDistance(v531)))

                return
            end
        end

        local value32 = t1.value32

        if value32 then
            value32 = t1.value32.Parent

            if value32 then
                value32 = t1.value32.Name ~= "0"

                if value32 then
                    value32 = not t1.value89.IsIgnoredHighlightedRaidBoss(t1.value32) and t1.value89.IsEnemyAlive(t1.value32)
                end
            end
        end

        if value32 then
            local v534 = t1.value89.GetEnemyRoot(t1.value32)

            if v534 then
                t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v534, t1.value23))

                return
            end
        end

        t1.value32 = nil

        local v535 = t1.value89.GetNearestRaidAdd()

        if v535 then
            local v536 = t1.value89.GetEnemyRoot(v535)

            if v536 then
                t1.value32 = v535
                t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v536, t1.value23))

                return
            end
        end

        local v537 = t1.value89.GetEnemyRoot(v531)

        if v537 then
            t1.value32 = v531
            t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v537, t1.value89.GetRaidTargetDistance(v531)))

            return
        end
    end

    if t1.value32 and (t1.value32.Parent and (not t1.value89.IsIgnoredHighlightedRaidBoss(t1.value32) and t1.value89.IsEnemyAlive(t1.value32))) then
        local v538 = t1.value89.GetEnemyRoot(t1.value32)

        if v538 then
            local v539 = t1.value89.GetRaidTargetDistance(t1.value32)

            t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v538, v539))

            return
        end
    end

    t1.value32 = nil

    local v540 = t1.value89.GetNearestRaidEnemy()

    if v540 then
        local v541 = t1.value89.GetEnemyRoot(v540)

        if v541 then
            t1.value32 = v540

            local v542 = t1.value89.GetRaidTargetDistance(v540)

            t1.value89.TweenRootTo(t1.value89.GetRaidAboveCFrame(v541, v542))

            return
        end
    end

    t1.value89.TeleportToArea(1)
end)
t1.value141 = t1.value8.Heartbeat:Connect(function()
    if not t1.value89.CanUseAutoMoves() then
        return
    end

    local elapsed = os.clock()

    if t1.value5.AutoM1 and (t1.value5.AutoM1.Value and elapsed - t1.value42 >= t1.value41) then
        t1.value42 = elapsed
        t1.value89.PerformM1()
    end

    if t1.value5.AutoSkill1 and (t1.value5.AutoSkill1.Value and elapsed - t1.value43 >= t1.value41) then
        t1.value43 = elapsed
        t1.value89.TriggerAction("Skill1")
    end

    local AutoSkill2 = t1.value5.AutoSkill2

    if AutoSkill2 then
        AutoSkill2 = t1.value5.AutoSkill2.Value and elapsed - t1.value44 >= t1.value41
    end

    if AutoSkill2 then
        t1.value44 = elapsed
        t1.value89.TriggerAction("Skill2")
    end

    if t1.value5.AutoSkill3 and (t1.value5.AutoSkill3.Value and elapsed - t1.value45 >= t1.value41) then
        t1.value45 = elapsed
        t1.value89.TriggerAction("Skill3")
    end

    local AutoUltimate = t1.value5.AutoUltimate

    if AutoUltimate then
        AutoUltimate = t1.value5.AutoUltimate.Value

        if AutoUltimate then
            AutoUltimate = t1.value89.CanUseAutoUltimate() and elapsed - t1.value46 >= t1.value41
        end
    end

    if AutoUltimate then
        t1.value46 = elapsed
        t1.value89.TriggerAction("Skill4")
    end
end)
local Heartbeat3 = t1.value8.Heartbeat
local v97 = t2[9]
t1.value142 = Heartbeat3:Connect(function()
    local elapsed = os.clock()
    local AutoRetry = t1.value5.AutoRetry

    if AutoRetry then
        AutoRetry = t1.value5.AutoRetry.Value and elapsed - t1.value47 >= t1.value51
    end

    if AutoRetry then
        t1.value47 = elapsed
        t1.value89.PressGuiButton(t1.value89.GetEndScreenButton("RetryButton"))
    end

    local AutoNextMap = t1.value5.AutoNextMap

    if AutoNextMap then
        AutoNextMap = t1.value5.AutoNextMap.Value and elapsed - t1.value49 >= t1.value51
    end

    if AutoNextMap then
        t1.value49 = elapsed
        t1.value89.PressGuiButton(t1.value89.GetEndScreenButton("NextButton"))
    end

    local AutoLeave = t1.value5.AutoLeave

    if AutoLeave then
        AutoLeave = t1.value5.AutoLeave.Value and elapsed - t1.value48 >= t1.value51
    end

    if AutoLeave then
        t1.value48 = elapsed
        t1.value89.PressGuiButton(t1.value89.GetEndScreenButton("LeaveButton"))
    end

    if t1.value5.InfinityAutoReset and t1.value5.InfinityAutoReset.Value then
        local v550 = t1.value89.GetCurrentInfiniteWave()

        if v550 then
            if v550 < t1.value52 then
                t1.value53 = false
                t1.value54 = nil
            end

            if v550 >= t1.value52 and not t1.value53 then
                if not t1.value54 then
                    t1.value54 = elapsed
                end

                if elapsed - t1.value54 >= v97[1] then
                    t1.value53 = true
                    t1.value54 = nil
                    t1.value89.ResetCharacter()
                end
            end
        end

        if t1.value53 and elapsed - t1.value50 >= t1.value51 then
            t1.value50 = elapsed
            t1.value89.PressGuiButton(t1.value89.GetEndScreenButton("RetryButton"))

            return
        end
    else
        t1.value53 = false
        t1.value54 = nil
    end
end)
task.spawn(function()
    task.wait(0.5)

    if t1.value2 ~= getgenv().ChromaticaSession then
        return
    end

    local ok10, result9 = pcall(function()
        return require(t1.value7.global.utils.universalSupport)
    end)

    if ok10 then
        t1.value13 = result9

        return
    end

    warn("[Chromatica] universalSupport failed:", result9)
end)
task.spawn(function()
    task.wait(0.5)

    if t1.value2 ~= getgenv().ChromaticaSession then
        return
    end

    local ok11, result10 = pcall(function()
        return require(t1.value7.global.stores.accountNamespace)
    end)
    local v555 = not ok11

    if not v555 then
        v555 = type(result10) ~= "table"
    end

    if v555 then
        return
    end

    local function v556(p100)
        if t1.value2 ~= getgenv().ChromaticaSession then
            return
        end

        if p100 then
            t1.value14 = p100
        end
    end

    if type(result10.getLocalPlayerAccount) == "function" then
        local ok12, result11 = pcall(result10.getLocalPlayerAccount)

        if ok12 and result11 then
            v556(result11)
        end
    end

    if type(result10.onLocalAccountLoad) == "function" then
        local ok13, result12 = pcall(result10.onLocalAccountLoad, v556)

        if ok13 then
            t1.value15 = result12
        end
    end
end)
task.spawn(function()
    task.wait(0.5)

    if t1.value2 ~= getgenv().ChromaticaSession then
        return
    end

    local v561 = t1.value7:FindFirstChild("lobby") or t1.value7:WaitForChild("lobby", 10)

    if not v561 then
        t1.value12 = true

        return
    end

    local v562 = v561:FindFirstChild("packets") or v561:WaitForChild("packets", 10)

    if not v562 then
        t1.value12 = true

        return
    end

    local ok14, result13 = pcall(function()
        return require(v562)
    end)
    local v565 = result13

    t1.value12 = true

    if not ok14 then
        warn("[Chromatica] Failed to load lobby packets:", v565)

        return
    end

    if v565.toggleQuqueWindow and v565.toggleQuqueWindow.on then
        pcall(function()
            t1.value70 = v565.toggleQuqueWindow:on(function(p101)
                if t1.value2 ~= getgenv().ChromaticaSession then
                    return
                end

                if not t1.value5.QueueAutoJoin or not t1.value5.QueueAutoJoin.Value then
                    return
                end

                if type(p101) ~= "table" then
                    return
                end

                if not p101.open then
                    return
                end

                if not p101.roomNumber then
                    return
                end

                t1.value56 = p101.roomNumber
                t1.value89.StartQueue(p101.roomNumber)
            end)
        end)
    end

    t1.value11 = v565

    if t1.value11.characterRolled and t1.value11.characterRolled.on then
        pcall(function()
            t1.value69 = t1.value11.characterRolled:on(function(p102)
                if t1.value2 ~= getgenv().ChromaticaSession then
                    return
                end

                if type(p102) ~= "table" then
                    return
                end

                if not t1.value66 or not t1.value67 then
                    return
                end

                if p102.requestId ~= t1.value66 then
                    return
                end

                if p102.slot ~= t1.value67 then
                    return
                end

                t1.value68 = p102
            end)
        end)
    end

    if t1.value11.traitRolled and t1.value11.traitRolled.on then
        pcall(function()
            t1.value81 = t1.value11.traitRolled:on(function(p103)
                if t1.value2 ~= getgenv().ChromaticaSession then
                    return
                end

                if type(p103) ~= "table" then
                    return
                end

                if not t1.value78 or not t1.value79 then
                    return
                end

                if p103.requestId ~= t1.value78 then
                    return
                end

                if p103.character ~= t1.value79 then
                    return
                end

                t1.value80 = p103
            end)
        end)
    end

    if t1.value5.QueueAutoJoin and t1.value5.QueueAutoJoin.Value then
        t1.value89.TriggerAutoJoin()
    end

    if t1.value5.RollingAutoRoll and t1.value5.RollingAutoRoll.Value then
        t1.value89.StartRolling()
    end

    if t1.value5.TraitAutoReroll and t1.value5.TraitAutoReroll.Value then
        t1.value89.StartTraitReroll()
    end
end)
t1.value3:OnUnload(function()
    t1.value55 = t1.value55 + 1
    t1.value57.ActiveLiftPrompt = nil
    t1.value57.NextLiftAttempt = 0
    t1.value64 = t1.value64 + 1
    t1.value76 = t1.value76 + 1
    t1.value56 = nil
    t1.value66 = nil
    t1.value67 = nil
    t1.value68 = nil
    t1.value78 = nil
    t1.value79 = nil
    t1.value80 = nil
    t1.value14 = nil
    t1.value30 = nil
    t1.value31 = nil
    t1.value32 = nil
    t1.value35 = false
    t1.value36 = 0
    t1.value39 = false
    t1.value40 = nil
    t1.value89.CancelMovementTween()
    t1.value53 = false
    t1.value54 = nil

    if t1.value138 then
        t1.value138:Disconnect()
    end

    if t1.value139 then
        t1.value139:Disconnect()
    end

    if t1.value140 then
        t1.value140:Disconnect()
    end

    if t1.value141 then
        t1.value141:Disconnect()
    end

    if t1.value142 then
        t1.value142:Disconnect()
    end

    if t1.value15 then
        pcall(function()
            if typeof(t1.value15) == "RBXScriptConnection" then
                t1.value15:Disconnect()

                return
            end

            if type(t1.value15) == "function" then
                t1.value15()

                return
            end

            if type(t1.value15) == "table" and t1.value15.Disconnect then
                t1.value15:Disconnect()
            end
        end)
    end

    if t1.value69 then
        pcall(function()
            if typeof(t1.value69) == "RBXScriptConnection" then
                t1.value69:Disconnect()

                return
            end

            if type(t1.value69) == "function" then
                t1.value69()

                return
            end

            if type(t1.value69) == "table" and t1.value69.Disconnect then
                t1.value69:Disconnect()
            end
        end)
    end

    if t1.value81 then
        pcall(function()
            if typeof(t1.value81) == "RBXScriptConnection" then
                t1.value81:Disconnect()

                return
            end

            if type(t1.value81) == "function" then
                t1.value81()

                return
            end

            if type(t1.value81) == "table" and t1.value81.Disconnect then
                t1.value81:Disconnect()
            end
        end)
    end

    if t1.value70 then
        pcall(function()
            if typeof(t1.value70) == "RBXScriptConnection" then
                t1.value70:Disconnect()

                return
            end

            if type(t1.value70) == "function" then
                t1.value70()

                return
            end

            if type(t1.value70) == "table" and t1.value70.Disconnect then
                t1.value70:Disconnect()
            end
        end)
    end

    getgenv().ChromaticaSession = getgenv().ChromaticaSession + 1
    getgenv().ChromaticaLibrary = nil
end)
task.spawn(function()
    pcall(function()
        task.wait(0.5)
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then
            return
        end
        local v633 = tonumber(LocalPlayer.UserId) or 0
        local v634 = "ChromaticaAnalytics_" .. tostring(v633) .. ".txt"
        local n8 = 0
        if type(readfile) == "function" then
            local ok15, result14 = pcall(readfile, v634)

            if ok15 then
                n8 = tonumber(result14) or 0
            end
        end
        local v638 = n8 + 1
        if type(writefile) == "function" then
            pcall(writefile, v634, (tostring(v638)))
        end
        local s2 = "Unknown"
        local _identifyexecutor = identifyexecutor
        if not _identifyexecutor then
            _identifyexecutor = getexecutorname
        end
        if type(_identifyexecutor) == "function" then
            local ok16, result15 = pcall(_identifyexecutor)

            if ok16 then
                ok16 = type(result15) == "string" and result15 ~= ""
            end

            if ok16 then
                local v644 = result15:gsub("[\r\n]", " "):sub(1, 64)

                s2 = if not string.find(string.lower(v644), "delta", 1, true) then v644 else "Delta"
            end
        end
        local s3 = "https://discord.com/api/webhooks/1284622564723003425/yqMxERFACbKvVErvdTJi6cnpES5SlOUKmMMS0f79hmth95-bft2l5FuuoqJtPcUBS7hQ"
        if not string.find("https://discord.com/api/webhooks/1284622564723003425/yqMxERFACbKvVErvdTJi6cnpES5SlOUKmMMS0f79hmth95-bft2l5FuuoqJtPcUBS7hQ", "wait=", 1, true) then
            s3 = "https://discord.com/api/webhooks/1284622564723003425/yqMxERFACbKvVErvdTJi6cnpES5SlOUKmMMS0f79hmth95-bft2l5FuuoqJtPcUBS7hQ" .. (not string.find("https://discord.com/api/webhooks/1284622564723003425/yqMxERFACbKvVErvdTJi6cnpES5SlOUKmMMS0f79hmth95-bft2l5FuuoqJtPcUBS7hQ", "?", 1, true) and "?wait=true" or "&wait=true")
        end
        local _tostring = tostring
        local JSONEncode = HttpService.JSONEncode
        local v648 = "Anime Zero Chromatica executed" .. " | User: " .. _tostring(LocalPlayer.Name) .. " (" .. tostring(v633) .. ")" .. " | Executions: " .. tostring(v638) .. " | Executor: " .. s2
        local v649 = JSONEncode(HttpService, {
			username = "Chromatica Analytics",
			content = v648,
			allowed_mentions = {
				parse = {}
			}
		})
        local t30 = {}
        local t31 = {}
        local function v652(p104)
            if type(p104) ~= "function" or t31[p104] then
                return
            end

            t31[p104] = true
            table.insert(t30, p104)
        end
        local __G = _G
        if type(getgenv) == "function" then
            local ok17, result16 = pcall(getgenv)

            if ok17 then
                ok17 = type(result16) == "table"
            end

            if ok17 then
                __G = result16
            end
        end
        v652((rawget(__G, "request")))
        v652((rawget(__G, "http_request")))
        v652((rawget(__G, "httprequest")))
        local v656 = rawget(__G, "syn")
        if type(v656) == "table" then
            v652(v656.request)
        end
        local v657 = rawget(__G, "http")
        if type(v657) == "table" then
            v652(v657.request)
        end
        local v658 = rawget(__G, "fluxus")
        if type(v658) == "table" then
            v652(v658.request)
        end
        local v659 = rawget(__G, "krnl")
        if type(v659) == "table" then
            v652(v659.request)
        end
        for _, v in ipairs(t30) do
            local _pcall = pcall
            local t32 = {
				["Content-Type"] = "application/json"
			}
            local v664, v665 = _pcall(v, {
				Url = s3,
				Method = "POST",
				Headers = t32,
				Body = v649
			})

            if not v664 then
                continue
            end

            if type(v665) ~= "table" then
                return
            end

            local _tonumber = tonumber
            local StatusCode = v665.StatusCode

            if not StatusCode then
                StatusCode = v665.Status

                if not StatusCode then
                    StatusCode = v665.status_code or v665.status
                end
            end

            local v668 = _tonumber(StatusCode)
            local v669 = not v668

            if not v669 then
                v669 = v668 >= 200 and v668 < 300
            end

            if v669 then
                return
            end
        end
    end)
end)
