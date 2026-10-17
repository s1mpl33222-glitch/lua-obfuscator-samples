-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value5 = 12834712622936,
	value4 = 32235748178594
}
local game_ = game
t1.value3 = "f(~\18.\17\0250\196\230\208\255"
t1.value6 = 22367117977775
local t2 = {
	value1 = game_:GetService("Players"),
	value2 = game:GetService("TweenService")
}
t1.value5 = "\188&\136\217\239\1693\197\223\199"
t1.value8 = 25237642063336
game_ = game:GetService("RunService")
t2.value3 = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local game_2 = game
t1.value1 = game_2.GetService
t1.value4 = "n\149\220\252\209\186\181 \237\222 "
t1.value1 = t1.value1(game_2, "HttpService")
t1.value6 = "\156\203>p\171\148\"\221_4\140`Q\154\191"
t1.value7 = 4982196996368
t2.value4 = t1.value1
t1.value3 = game:GetService("TeleportService")
t2.value5 = t1.value3
t1.value3 = t2.value1.LocalPlayer
t2.value6 = t1.value3
t1.value3 = t2.value6
t1.value2 = t1.value3.WaitForChild
t1.value7 = "A\20S>)\234}\243\207"
t1.value2 = t1.value2(t1.value3, "PlayerGui")
t1.value3 = workspace.CurrentCamera
t2.value7 = t1.value3
t1.value6 = Color3.fromRGB
t1.value9 = 16
t1.value7 = 8
t1.value8 = t1.value6(t1.value7, t1.value9, 16)
t1.value9 = Color3.fromRGB(10, 22, 22)
game_2 = Color3.fromRGB(0, 188, 168)
local color3 = Color3.fromRGB(0, 188, 168)
local color32 = Color3.fromRGB(0, 110, 100)
local color33 = Color3.fromRGB(232, 184, 75)
local color34 = Color3.fromRGB(180, 210, 205)
local color35 = Color3.fromRGB(90, 130, 125)
local color36 = Color3.fromRGB(6, 14, 14)
local color37 = Color3.fromRGB(0, 0, 0)
local color38 = Color3.fromRGB(255, 255, 255)
local color39 = Color3.fromRGB(220, 70, 70)
local color310 = Color3.fromRGB(60, 130, 255)
local color311 = Color3.fromRGB(88, 101, 242)
t2.value8 = {
	["bg"] = t1.value8,
	["panel"] = t1.value9,
	["border"] = game_2,
	["teal"] = color3,
	["tealDim"] = color32,
	["gold"] = color33,
	["text"] = color34,
	["textDim"] = color35,
	["dark"] = color36,
	["black"] = color37,
	["white"] = color38,
	["red"] = color39,
	["blue"] = color310,
	["discord"] = color311
}
t2.value9 = "https://discord.gg/464V4jpwDf"
t2.value10 = {
	["ESPEnabled"] = false,
	["ESPTeamCheck"] = true,
	["ESPNames"] = true,
	["ESPHealth"] = true,
	["ESPDistance"] = false,
	["ESPProjectiles"] = false,
	["AimLock"] = false,
	["AimLockTeamCheck"] = true,
	["AimLockWallCheck"] = true,
	["AimLockPrediction"] = false,
	["AimLockPredictionAmount"] = 0.15,
	["AimLockFOV"] = 150,
	["AimLockSmooth"] = 0.3,
	["AimLockPart"] = "Head",
	["WalkSpeed"] = false,
	["WSpeed"] = 30,
	["JumpPower"] = false,
	["JPower"] = 60,
	["InfiniteJump"] = false,
	["Fly"] = false,
	["FlySpeed"] = 60,
	["Noclip"] = false,
	["AntiAFK"] = false
}
t2.value11 = {
	["myTeam"] = nil,
	["teams"] = {},
	["phase"] = "Unknown",
	["round"] = 0
}
t1.value3 = ReplicatedStorage:WaitForChild("Remotes", 10)
ReplicatedStorage = function()
    for k, team in pairs(t2.value11.teams) do
        for _, v in pairs(team.members or {}) do
            if v.userId == t2.value6.UserId then
                return k
            end
        end
    end

    return nil
end
game_2 = t1.value3 and t1.value3:FindFirstChild("MatchState")
if game_2 then
    game_2.OnClientEvent:Connect(function(p1)
        if type(p1) ~= "table" then
            return
        end

        if p1.teams then
            t2.value11.teams = p1.teams
            t2.value11.myTeam = ReplicatedStorage()
        end

        if p1.phase then
            t2.value11.phase = p1.phase
        end

        if not p1.round then
            return
        end

        t2.value11.round = p1.round
    end)
end
function t2.value12(p2)
    for k, team in pairs(t2.value11.teams) do
        for _, v in pairs(team.members or {}) do
            if v.userId == p2.UserId then
                return k
            end
        end
    end

    return nil
end
function t2.value13(p3, p4)
    if p3 == t2.value6 then
        return false
    else
        if p4 then
            local myTeam = t2.value11.myTeam
            local v27 = t2.value12(p3)

            return not (myTeam and v27) and true or myTeam ~= v27
        else
            return true
        end

        return
    end
end
function t2.value14(p5)
    for _, team in pairs(t2.value11.teams) do
        for _, v in pairs(team.members or {}) do
            if v.userId == p5.UserId then
                return v.alive == true
            end
        end
    end

    return nil
end
function t2.value15(p6, p7)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p7 or 10)
    UICorner.Parent = p6

    return UICorner
end
function t2.value16(p8, p9, p10)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p9 or t2.value8.border
    UIStroke.Thickness = p10 or 1
    UIStroke.Transparency = 0.6
    UIStroke.Parent = p8

    return UIStroke
end
function t2.value17(p11, p12)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = p12.font or Enum.Font.GothamMedium
    TextLabel.TextSize = p12.size or 13
    TextLabel.TextColor3 = p12.color or t2.value8.text
    TextLabel.Text = p12.text or ""
    TextLabel.Size = p12.sz or UDim2.new(1, 0, 0, 20)
    TextLabel.Position = p12.pos or UDim2.new(0, 0, 0, 0)
    TextLabel.TextXAlignment = p12.align or Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = p12.yalign or Enum.TextYAlignment.Center
    TextLabel.TextWrapped = true
    TextLabel.Parent = p11

    return TextLabel
end
function t2.value18(p13, p14, p15)
    return t2.value2:Create(p13, p14, p15):Play()
end
ReplicatedStorage = function(p16, p17)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, -40, 0, 1)
    Frame.Position = UDim2.new(0, 20, 0, p17)
    Frame.BackgroundColor3 = t2.value8.border
    Frame.BackgroundTransparency = 0.82
    Frame.BorderSizePixel = 0
    Frame.Parent = p16

    return Frame
end
t2.value19 = Instance.new("ScreenGui")
t2.value19.Name = "MunkeHubTribes"
t2.value19.ResetOnSpawn = false
t2.value19.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value19.IgnoreGuiInset = true
t2.value19.DisplayOrder = 999
pcall(function()
    t2.value19.Parent = game:GetService("CoreGui")
end)
if not t2.value19.Parent then
    t2.value19.Parent = t1.value2
end
t2.value20 = Instance.new("ScreenGui")
t2.value20.Name = "MunkeHubTribes_ESP"
t2.value20.ResetOnSpawn = false
t2.value20.IgnoreGuiInset = true
t2.value20.DisplayOrder = 998
pcall(function()
    t2.value20.Parent = game:GetService("CoreGui")
end)
if not t2.value20.Parent then
    t2.value20.Parent = t1.value2
end
t2.value21 = Instance.new("ScreenGui")
t2.value21.Name = "MunkeHubTribes_FOV"
t2.value21.ResetOnSpawn = false
t2.value21.IgnoreGuiInset = true
t2.value21.DisplayOrder = 997
pcall(function()
    t2.value21.Parent = game:GetService("CoreGui")
end)
if not t2.value21.Parent then
    t2.value21.Parent = t1.value2
end
game_2 = Instance
t1.value11 = 32558792899385
t1.value15 = "\18\147g\151\178\251\28*\24\233"
t2.value22 = game_2.new("Frame")
game_2 = t2.value22
color3 = Vector2.new
t1.value10 = 0.5
game_2.AnchorPoint = color3(t1.value10, 0.5)
game_2 = t2.value22
t1.value12 = "\n\169&"
t1.value16 = 5769111243390
color3 = UDim2.new
t1.value10 = 0.5
t1.value11 = 0.5
color3 = color3(t1.value10, 0, t1.value11, 0)
t1.value12 = "\25\234\242"
game_2.Position = color3
t2.value22.Size = UDim2.new(0, t2.value10.AimLockFOV * 2, 0, t2.value10.AimLockFOV * 2)
t1.value11 = 29203445200158
t2.value22.BackgroundTransparency = 1
game_2 = t2.value22
t1.value16 = 3985705191231
game_2.Active = false
game_2 = t2.value22
t1.value11 = 2709009499373
game_2.Visible = false
t2.value22.Parent = t2.value21
t2.value15(t2.value22, 9999)
t1.value17 = 20290493687016
game_2 = Instance.new("UIStroke")
game_2.Thickness = 2
t1.value12 = "\191E>\227"
t1.value11 = 24650873531606
game_2.Color = t2.value8.teal
game_2.Transparency = 0.4
t1.value11 = 8142647185103
game_2.Parent = t2.value22
function t1.value10(p18)
    if p18 then
        return p18:FindFirstChild(t2.value10.AimLockPart) or (p18:FindFirstChild("Head") or p18:FindFirstChild("HumanoidRootPart"))
    else
        return nil
    end
end
function t2.value23()
    local Character = t2.value6.Character

    if not Character then
        return Character
    end

    Character = Character:FindFirstChildOfClass("Humanoid")

    return Character
end
function t2.value24()
    local Character = t2.value6.Character

    if not Character then
        return Character
    end

    Character = Character:FindFirstChild("HumanoidRootPart")

    return Character
end
t2.value25 = t1.value10
t2.value26 = RaycastParams.new()
game_2 = t2.value26
color3 = Enum.RaycastFilterType.Exclude
t1.value13 = "\222\193C\2\2469j\"T\168{"
t1.value14 = ")9N\1759(\254\2527\234\170\150\222"
game_2.FilterType = color3
t2.value26.IgnoreWater = true
t2.value27 = nil
function t1.value11(p19)
    local Character = t2.value6.Character
    local Head

    if Character then
        Head = Character:FindFirstChild("Head") or Character:FindFirstChild("HumanoidRootPart")
    else
        Head = Character
    end

    if Head and p19 then
        t2.value26.FilterDescendantsInstances = { Character, p19.Parent }
        Character = Head.Position
        Head = p19.Position - Character

        return workspace:Raycast(Character, Head, t2.value26) == nil
    else
        return false
    end
end
function t1.value12()
    if t2.value10.AimLock then
        local mouseLocation = t2.value3:GetMouseLocation()
        local AimLockFOV = t2.value10.AimLockFOV
        local ipairs_ = ipairs
        local value1 = t2.value1
        local v44
        for _, player in ipairs_(value1:GetPlayers()) do
            local Character = t2.value13(player, t2.value10.AimLockTeamCheck)

            if Character then
                Character = player.Character
            end

            if Character then
                Character = player.Character:FindFirstChildOfClass("Humanoid")

                if Character then
                    Character = Character.Health > 0
                end

                if Character then
                    Character = t2.value14(player)

                    if Character == nil and true or Character == true then
                        Character = t2.value25(player.Character)

                        if Character then
                            local AimLockWallCheck = t2.value10.AimLockWallCheck

                            if AimLockWallCheck then
                                AimLockWallCheck = not t2.value27(Character)
                            end

                            if not AimLockWallCheck then
                                Character, AimLockWallCheck = t2.value7:WorldToViewportPoint(Character.Position)

                                if AimLockWallCheck then
                                    Character = (Vector2.new(Character.X, Character.Y) - mouseLocation).Magnitude

                                    if Character < AimLockFOV then
                                        v44 = player
                                        AimLockFOV = Character
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        return v44
    else
        return nil
    end
end
t2.value27 = t1.value11
function t2.value28(p20)
    if p20 then
        if t2.value10.AimLockPrediction then
            local AssemblyLinearVelocity = p20.AssemblyLinearVelocity or Vector3.zero

            if AssemblyLinearVelocity.Magnitude < 5 then
                return p20.Position
            else
                return p20.Position + AssemblyLinearVelocity * t2.value10.AimLockPredictionAmount
            end

            return
        else
            return p20.Position
        end

        return
    else
        return nil
    end
end
t2.value29 = t1.value12
t1.value14 = "y\228N\248"
t1.value15 = 12722700883748
t1.value12 = game_.RenderStepped
function t1.value13(_)
    if not t2.value10.AimLock then
        return
    end

    local Unit = t2.value29()

    if Unit then
        v71 = Unit.Character
    else
        v71 = Unit
    end

    if not v71 then
        return
    end

    Unit = t2.value25(Unit.Character)
    Unit = Unit and t2.value28(Unit)

    if not Unit then
        return
    end

    local Position = t2.value7.CFrame.Position

    Unit = (Unit - Position).Unit
    Unit = CFrame.new(Position, Position + Unit)
    Position = t2.value10.AimLockSmooth
    Position = math.clamp(Position, 0.05, 1)
    t2.value7.CFrame = t2.value7.CFrame:Lerp(Unit, Position)
end
t1.value12:Connect(t1.value13)
t1.value13 = {}
t1.value16 = "\177\243Q\220\239e"
function t1.value14(p21)
    p21.Box.Visible = false
    p21.Name.Visible = false
    p21.Dist.Visible = false
    p21.HealthBg.Visible = false
    p21.HealthBar.Visible = false
end
t1.value12 = {
	["pool"] = t1.value13,
	["active"] = {}
}
t2.value30 = t1.value12
function t1.value13(p22, p23, p24)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.RobotoMono
    TextLabel.TextSize = p24
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    TextLabel.Size = p23
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.Visible = false
    TextLabel.Active = false
    TextLabel.Parent = p22

    return TextLabel
end
t2.value31 = nil
t2.value31 = t1.value13
function t2.value32()
    local Frame = table.remove(t2.value30.pool)

    if Frame then
        Frame.Box.Visible = false
        Frame.Name.Visible = false
        Frame.Dist.Visible = false
        Frame.HealthBg.Visible = false
        Frame.HealthBar.Visible = false

        return Frame
    else
        Frame = Instance.new("Frame")
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.Visible = false
        Frame.Active = false
        Frame.Parent = t2.value20

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 1
        UIStroke.Parent = Frame

        local v55 = t2.value31(t2.value20, UDim2.new(0, 240, 0, 14), 12)
        local v56 = t2.value31(t2.value20, UDim2.new(0, 120, 0, 12), 10)
        local Frame2 = Instance.new("Frame")

        Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame2.BorderSizePixel = 0
        Frame2.Visible = false
        Frame2.Active = false
        Frame2.Parent = t2.value20

        local Frame3 = Instance.new("Frame")

        Frame3.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        Frame3.BorderSizePixel = 0
        Frame3.Visible = false
        Frame3.Active = false
        Frame3.Parent = t2.value20

        return {
			["Box"] = Frame,
			["Stroke"] = UIStroke,
			["Name"] = v55,
			["Dist"] = v56,
			["HealthBg"] = Frame2,
			["HealthBar"] = Frame3
		}
    end
end
function t2.value33(p25)
    if p25 then
        p25.Box.Visible = false
        p25.Name.Visible = false
        p25.Dist.Visible = false
        p25.HealthBg.Visible = false
        p25.HealthBar.Visible = false

        if #t2.value30.pool < 100 then
            local pool = t2.value30.pool

            table.insert(pool, p25)

            return
        else
            p25.Box:Destroy()
            p25.Name:Destroy()
            p25.Dist:Destroy()
            p25.HealthBg:Destroy()
            p25.HealthBar:Destroy()

            return
        end

        return
    else
        return
    end
end
t2.value34 = t1.value14
t1.value14 = game_.RenderStepped
function t1.value16()
    local v60 = t2.value24()

    if not v60 then
        for k, v in pairs(t2.value30.active) do
            t2.value33(v)
            t2.value30.active[k] = nil
        end

        return
    end

    local t3 = {}

    if not t2.value10.ESPEnabled then
        for k, v in pairs(t2.value30.active) do
            if not (t3[k] and k.Parent) then
                t2.value33(v)
                t2.value30.active[k] = nil
            end
        end

        return
    end

    local ipairs_ = ipairs
    local value1 = t2.value1

    for _, player in ipairs_(value1:GetPlayers()) do
        if player ~= t2.value6 then
            local ESPTeamCheck = t2.value10.ESPTeamCheck

            if ESPTeamCheck then
                ESPTeamCheck = not t2.value13(player, true)
            end

            if not ESPTeamCheck then
                ESPTeamCheck = player.Character

                if ESPTeamCheck then
                    local HumanoidRootPart = ESPTeamCheck:FindFirstChild("HumanoidRootPart")
                    local color = not HumanoidRootPart
                    local MaxHealth = ESPTeamCheck:FindFirstChildOfClass("Humanoid")

                    if not color and (MaxHealth and MaxHealth.Health > 0) and t2.value14(player) ~= false then
                        color = t2.value13(player, true)

                        if color then
                            color = t2.value8.red
                        end

                        color = color or t2.value8.blue

                        local Magnitude = (HumanoidRootPart.Position - v60.Position).Magnitude
                        local v75 = t2.value30.active[ESPTeamCheck]

                        if not v75 then
                            v75 = t2.value32()
                            t2.value30.active[ESPTeamCheck] = v75
                        end

                        t3[ESPTeamCheck] = true
                        ESPTeamCheck, HumanoidRootPart = t2.value7:WorldToViewportPoint(HumanoidRootPart.Position)

                        if HumanoidRootPart then
                            HumanoidRootPart = ESPTeamCheck.Z > 0
                        end

                        if HumanoidRootPart then
                            HumanoidRootPart = 3 * (1000 / math.max(Magnitude, 1))
                            HumanoidRootPart = math.clamp(HumanoidRootPart, 12, 220)

                            local v76 = HumanoidRootPart * 1.5

                            v75.Box.Size = UDim2.new(0, HumanoidRootPart, 0, v76)
                            v75.Box.Position = UDim2.new(0, ESPTeamCheck.X - HumanoidRootPart * 0.5, 0, ESPTeamCheck.Y - v76 * 0.5)
                            v75.Stroke.Color = color
                            v75.Box.Visible = true

                            if t2.value10.ESPNames then
                                v75.Name.Text = player.Name
                                v75.Name.TextColor3 = color
                                v75.Name.Position = UDim2.new(0, ESPTeamCheck.X - 120, 0, ESPTeamCheck.Y - v76 * 0.5 - 16)
                                v75.Name.Visible = true
                            else
                                v75.Name.Visible = false
                            end

                            if t2.value10.ESPDistance then
                                v75.Dist.Text = string.format("%dm", (math.floor(Magnitude)))
                                v75.Dist.TextColor3 = color
                                v75.Dist.Position = UDim2.new(0, ESPTeamCheck.X - 60, 0, ESPTeamCheck.Y + v76 * 0.5 + 2)
                                v75.Dist.Visible = true
                            else
                                v75.Dist.Visible = false
                            end

                            if t2.value10.ESPHealth then
                                local clamp = math.clamp

                                color = MaxHealth.Health
                                MaxHealth = MaxHealth.MaxHealth
                                clamp = clamp(color / math.max(MaxHealth, 1), 0, 1)
                                HumanoidRootPart = ESPTeamCheck.X - HumanoidRootPart * 0.5 - 6
                                v75.HealthBg.Size = UDim2.new(0, 4, 0, v76 + 2)
                                v75.HealthBg.Position = UDim2.new(0, HumanoidRootPart - 1, 0, ESPTeamCheck.Y - v76 * 0.5 - 1)
                                v75.HealthBg.Visible = true
                                color = v76 * clamp
                                v75.HealthBar.Size = UDim2.new(0, 4, 0, color)
                                v75.HealthBar.Position = UDim2.new(0, HumanoidRootPart, 0, ESPTeamCheck.Y + v76 * 0.5 - color)
                                ESPTeamCheck = v75.HealthBar
                                HumanoidRootPart = "BackgroundColor3"
                                color = clamp > 0.6

                                if color then
                                    color = Color3.fromRGB(0, 255, 0)
                                end

                                if not color then
                                    clamp = clamp > 0.3

                                    if clamp then
                                        clamp = Color3.fromRGB(255, 255, 0)
                                    end

                                    color = clamp or Color3.fromRGB(255, 0, 0)
                                end

                                ESPTeamCheck[HumanoidRootPart] = color
                                v75.HealthBar.Visible = true
                            else
                                v75.HealthBg.Visible = false
                                v75.HealthBar.Visible = false
                            end
                        else
                            t2.value34(v75)
                        end
                    end
                end
            end
        end
    end

    for k, v in pairs(t2.value30.active) do
        if not (t3[k] and k.Parent) then
            t2.value33(v)
            t2.value30.active[k] = nil
        end
    end
end
t1.value14:Connect(t1.value16)
t2.value35 = {}
t2.value36 = {}
t1.value14 = {}
t2.value37 = nil
t2.value37 = t1.value14
function t2.value38()
    local Frame = table.remove(t2.value37)

    if Frame then
        return Frame
    else
        Frame = Instance.new("Frame")
        Frame.BackgroundTransparency = 0.3
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = Vector2.new(0, 0.5)
        Frame.Visible = false
        Frame.Parent = t2.value20

        return Frame
    end
end
function t2.value39(p26)
    p26.Visible = false

    local value37 = t2.value37

    table.insert(value37, p26)
end
t1 = t1.value3 and t1.value3:FindFirstChild("CombatFX")
if t1 then
    t1.OnClientEvent:Connect(function(p27, p28)
        local v82 = p27 == "Projectile"

        if v82 then
            v82 = type(p28) == "table"
        end

        if v82 then
            v82 = p28.origin

            if not v82 then
                if v82 then
                    table.insert(t2.value35, {
						["origin"] = p28.origin,
						["velocity"] = p28.velocity,
						["shooter"] = p28.shooter,
						["kind"] = p28.kind,
						["spawnedAt"] = tick(),
						["key"] = p28.key
					})

                    if #t2.value35 > 50 then
                        table.remove(t2.value35, 1)

                        return
                    else
                        return
                    end

                    return
                else
                    return
                end

                return
            end

            v82 = p28.velocity

            if v82 then
                table.insert(t2.value35, {
					["origin"] = p28.origin,
					["velocity"] = p28.velocity,
					["shooter"] = p28.shooter,
					["kind"] = p28.kind,
					["spawnedAt"] = tick(),
					["key"] = p28.key
				})

                if #t2.value35 > 50 then
                    table.remove(t2.value35, 1)

                    return
                else
                    return
                end

                return
            else
                return
            end

            return
        else
            v82 = p27 == "ProjectileHit"

            if v82 then
                v82 = type(p28) == "table"
            end

            if not (v82 and p28.key) then
                return
            end

            for i, v in ipairs(t2.value35) do
                if v.key == p28.key then
                    table.remove(t2.value35, i)

                    return
                end
            end

            return
        end
    end)
end
game_.RenderStepped:Connect(function()
    local v86 = tick()
    for i = #t2.value35, 1, -1 do
        if v86 - t2.value35[i].spawnedAt > 5 then
            table.remove(t2.value35, i)
        end
    end
    if t2.value10.ESPProjectiles then
        local v88, v89, v90 = ipairs(t2.value35)
        local t4 = {}

        while true do
            local playerFromCharacter

            v90, playerFromCharacter = v88(v89, v90)

            if not v90 then
                break
            end

            local rotation = v86 - playerFromCharacter.spawnedAt
            local n1 = 55
            local v95 = playerFromCharacter.origin + playerFromCharacter.velocity * rotation + Vector3.new(0, -27.5 * rotation * rotation, 0)
            local v96, v97 = t2.value7:WorldToViewportPoint(v95)

            if v97 then
                v97 = v96.Z > 0
            end

            if v97 then
                v97 = t2.value36[v90]

                if not v97 then
                    v97 = t2.value38()
                    t2.value36[v90] = v97
                end

                rotation = v95 + playerFromCharacter.velocity * 0.05 + Vector3.new(0, -n1 * rotation * 0.05, 0)
                rotation, n1 = t2.value7:WorldToViewportPoint(rotation)

                if n1 then
                    n1 = rotation.X - v96.X
                    rotation = rotation.Y - v96.Y
                    v95 = n1 * n1 + rotation * rotation
                    v95 = math.sqrt(v95)
                    v95 = v95 < 1 and 1 or v95
                    rotation = math.atan2(rotation, n1)
                    rotation = math.deg(rotation)
                    n1 = false

                    local shooter = playerFromCharacter.shooter

                    if shooter then
                        shooter = playerFromCharacter.shooter.Parent
                    end

                    if shooter then
                        playerFromCharacter = t2.value1:GetPlayerFromCharacter(playerFromCharacter.shooter)

                        if playerFromCharacter then
                            n1 = t2.value13(playerFromCharacter, t2.value10.ESPTeamCheck)
                        end
                    end

                    v97.Size = UDim2.new(0, math.clamp(v95, 20, 400), 0, 2)
                    v97.Position = UDim2.new(0, v96.X, 0, v96.Y)
                    v97.Rotation = rotation
                    playerFromCharacter = "BackgroundColor3"

                    if n1 then
                        n1 = t2.value8.red
                    end

                    v97[playerFromCharacter] = n1 or t2.value8.blue
                    v97.Visible = true
                    t4[v90] = true
                end
            end
        end

        for k, v in pairs(t2.value36) do
            if not t4[k] then
                t2.value39(v)
                t2.value36[k] = nil
            end
        end

        return
    else
        for _, v in pairs(t2.value36) do
            t2.value39(v)
        end

        t2.value36 = {}

        return
    end
end)
t2.value40 = Instance.new("Frame")
t2.value40.Size = UDim2.new(0, 400, 0, 460)
t2.value40.Position = UDim2.new(0.5, -200, 0.5, -230)
t2.value40.BackgroundColor3 = t2.value8.panel
t2.value40.BorderSizePixel = 0
t2.value40.ClipsDescendants = true
t2.value40.Parent = t2.value19
t2.value15(t2.value40, 16)
t2.value16(t2.value40, t2.value8.border, 1)
t1 = Instance.new("Frame")
t1.Size = UDim2.new(1, 0, 1, 0)
t1.BackgroundColor3 = t2.value8.black
t1.BackgroundTransparency = 0.97
t1.BorderSizePixel = 0
t1.ZIndex = 10
t1.Parent = t2.value40
t2.value41 = t2.value17(t2.value40, {
	["text"] = "MunkeHub",
	["font"] = Enum.Font.GothamBold,
	["size"] = 26,
	["color"] = t2.value8.teal,
	["sz"] = UDim2.new(1, -180, 0, 36),
	["pos"] = UDim2.new(0, 20, 0, 12),
	["align"] = Enum.TextXAlignment.Left
})
task.spawn(function()
    while true do
        local t5 = {
			["TextTransparency"] = 0
		}

        t2.value18(t2.value41, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t5)
        task.wait(2)
        t5 = {
			["TextTransparency"] = 0.15
		}
        t2.value18(t2.value41, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t5)
        task.wait(2)
    end
end)
t2.value17(t2.value40, {
	["text"] = "Tribes 3v3",
	["font"] = Enum.Font.GothamMedium,
	["size"] = 10,
	["color"] = t2.value8.tealDim,
	["sz"] = UDim2.new(1, -180, 0, 16),
	["pos"] = UDim2.new(0, 22, 0, 42),
	["align"] = Enum.TextXAlignment.Left
})
t1 = Instance.new("TextButton")
t1.Size = UDim2.new(0, 74, 0, 26)
t1.Position = UDim2.new(1, -108, 0, 16)
t1.BackgroundColor3 = t2.value8.discord
t1.Text = "Discord"
t1.TextColor3 = Color3.new(1, 1, 1)
t1.Font = Enum.Font.GothamBold
t1.TextSize = 11
t1.BorderSizePixel = 0
t1.AutoButtonColor = false
t1.ZIndex = 20
t1.Parent = t2.value40
t2.value15(t1, 8)
t2.value16(t1, t2.value8.discord, 1)
game_2 = Instance.new("TextButton")
game_2.Size = UDim2.new(0, 26, 0, 26)
game_2.Position = UDim2.new(1, -28, 0, 16)
game_2.BackgroundColor3 = t2.value8.dark
game_2.Text = "\195\151"
game_2.TextColor3 = t2.value8.red
game_2.Font = Enum.Font.GothamBold
game_2.TextSize = 16
game_2.BorderSizePixel = 0
game_2.AutoButtonColor = false
game_2.ZIndex = 20
game_2.Parent = t2.value40
t2.value15(game_2, 8)
t2.value16(game_2, t2.value8.red, 1)
ReplicatedStorage(t2.value40, 62)
t2.value42 = Instance.new("Frame")
t2.value42.Size = UDim2.new(1, -20, 0, 32)
t2.value42.Position = UDim2.new(0, 10, 0, 70)
t2.value42.BackgroundTransparency = 1
t2.value42.Parent = t2.value40
ReplicatedStorage = Instance.new("UIListLayout")
ReplicatedStorage.FillDirection = Enum.FillDirection.Horizontal
ReplicatedStorage.Padding = UDim.new(0, 4)
ReplicatedStorage.SortOrder = Enum.SortOrder.LayoutOrder
ReplicatedStorage.Parent = t2.value42
t2.value43 = Instance.new("Frame")
t2.value43.Size = UDim2.new(1, -20, 1, -120)
t2.value43.Position = UDim2.new(0, 10, 0, 110)
t2.value43.BackgroundTransparency = 1
t2.value43.Parent = t2.value40
t2.value44 = {}
t2.value45 = {}
ReplicatedStorage = function(p29, p30)
    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 82, 0, 28)
    TextButton.BackgroundColor3 = t2.value8.dark
    TextButton.Text = p29
    TextButton.TextColor3 = t2.value8.textDim
    TextButton.Font = Enum.Font.GothamMedium
    TextButton.TextSize = 11
    TextButton.BorderSizePixel = 0
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 5
    TextButton.Parent = t2.value42
    t2.value15(TextButton, 8)

    local v105 = t2.value16(TextButton, t2.value8.tealDim, 1)
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = t2.value8.teal
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Visible = p30 == 1
    ScrollingFrame.ZIndex = 5
    ScrollingFrame.Parent = t2.value43

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    UIListLayout = Instance.new("UIPadding")
    UIListLayout.PaddingTop = UDim.new(0, 4)
    UIListLayout.PaddingLeft = UDim.new(0, 4)
    UIListLayout.PaddingRight = UDim.new(0, 4)
    UIListLayout.PaddingBottom = UDim.new(0, 4)
    UIListLayout.Parent = ScrollingFrame
    t2.value44[p29] = {
		["btn"] = TextButton,
		["stroke"] = v105
	}
    t2.value45[p29] = ScrollingFrame
    TextButton.MouseButton1Click:Connect(function()
        for k, v in pairs(t2.value44) do
            v.btn.TextColor3 = t2.value8.textDim
            v.stroke.Color = t2.value8.tealDim
            t2.value45[k].Visible = false
        end

        TextButton.TextColor3 = t2.value8.teal
        v105.Color = t2.value8.teal
        ScrollingFrame.Visible = true
    end)
end
ReplicatedStorage("Aim", 1)
ReplicatedStorage("Visuals", 2)
ReplicatedStorage("Movement", 3)
ReplicatedStorage("Misc", 4)
t2.value44.Aim.btn.TextColor3 = t2.value8.teal
t2.value44.Aim.stroke.Color = t2.value8.teal
ReplicatedStorage = function(p31, p32)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, 0, 0, 22)
    Frame.BackgroundTransparency = 1
    Frame.Parent = p31
    t2.value17(Frame, {
		["text"] = p32,
		["font"] = Enum.Font.GothamBold,
		["size"] = 11,
		["color"] = t2.value8.gold,
		["sz"] = UDim2.new(1, 0, 1, 0),
		["pos"] = UDim2.new(0, 4, 0, 0)
	})

    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(1, -100, 0, 1)
    Frame2.Position = UDim2.new(0, 90, 0.5, 0)
    Frame2.BackgroundColor3 = t2.value8.tealDim
    Frame2.BackgroundTransparency = 0.5
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame
end
color3 = function(p33, p34, p35, p36)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = t2.value8.dark
    Frame.BackgroundTransparency = 0.4
    Frame.BorderSizePixel = 0
    Frame.Parent = p33
    t2.value15(Frame, 10)
    t2.value16(Frame, t2.value8.tealDim, 1)
    t2.value17(Frame, {
		["text"] = p34,
		["size"] = 12,
		["color"] = t2.value8.text,
		["sz"] = UDim2.new(1, -70, 1, 0),
		["pos"] = UDim2.new(0, 12, 0, 0)
	})

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 50, 0, 24)
    TextButton.Position = UDim2.new(1, -60, 0.5, -12)
    TextButton.BackgroundColor3 = t2.value8.dark
    TextButton.Text = p35 and "ON" or p35 or "OFF"

    local teal

    if p35 then
        teal = t2.value8.teal
    else
        teal = p35
    end

    TextButton.TextColor3 = teal or t2.value8.textDim
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 11
    TextButton.BorderSizePixel = 0
    TextButton.AutoButtonColor = false
    TextButton.Parent = Frame
    t2.value15(TextButton, 10)
    Frame = t2.value16

    if p35 then
        teal = t2.value8.teal
    else
        teal = p35
    end

    Frame = Frame(TextButton, teal or t2.value8.tealDim, 1)

    local u115 = p35 or false

    TextButton.MouseButton1Click:Connect(function()
        u115 = not u115
        TextButton.Text = u115 and "ON" or "OFF"

        local v116 = TextButton
        local teal2 = u115

        if teal2 then
            teal2 = t2.value8.teal
        end

        v116.TextColor3 = teal2 or t2.value8.textDim
        v116 = Frame
        teal2 = u115

        if teal2 then
            teal2 = t2.value8.teal
        end

        v116.Color = teal2 or t2.value8.tealDim

        if not p36 then
            return
        end

        p36(u115)
    end)
end
color32 = function(p37, p38, p39, p40, p41, p42)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, 0, 0, 54)
    Frame.BackgroundColor3 = t2.value8.dark
    Frame.BackgroundTransparency = 0.4
    Frame.BorderSizePixel = 0
    Frame.Parent = p37
    t2.value15(Frame, 10)
    t2.value16(Frame, t2.value8.tealDim, 1)
    t2.value17(Frame, {
		["text"] = p38,
		["size"] = 12,
		["color"] = t2.value8.text,
		["sz"] = UDim2.new(1, -70, 0, 18),
		["pos"] = UDim2.new(0, 12, 0, 6)
	})

    local v119 = t2.value17(Frame, {
		["text"] = tostring(p41),
		["size"] = 12,
		["color"] = t2.value8.gold,
		["sz"] = UDim2.new(0, 60, 0, 18),
		["pos"] = UDim2.new(1, -72, 0, 6),
		["align"] = Enum.TextXAlignment.Right
	})
    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(1, -24, 0, 16)
    Frame2.Position = UDim2.new(0, 12, 0, 30)
    Frame2.BackgroundColor3 = t2.value8.black
    Frame2.BackgroundTransparency = 0.5
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame
    t2.value15(Frame2, 8)
    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new((p41 - p39) / (p40 - p39), 0, 1, 0)
    Frame.BackgroundColor3 = t2.value8.teal
    Frame.BorderSizePixel = 0
    Frame.Parent = Frame2
    t2.value15(Frame, 8)

    local u121 = false

    Frame = function(p43)
        local v122 = math.clamp((p43 - Frame2.AbsolutePosition.X) / Frame2.AbsoluteSize.X, 0, 1)
        local v123 = p39 + v122 * (p40 - p39)

        v123 = math.floor(v123)
        Frame.Size = UDim2.new(v122, 0, 1, 0)
        v119.Text = tostring(v123)

        if not p42 then
            return
        end

        p42(v123)
    end
    Frame2.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u121 = true
        Frame(input.Position.X)
    end)
    t2.value3.InputChanged:Connect(function(input)
        local v124 = u121

        if v124 then
            v124 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if not v124 then
            return
        end

        Frame(input.Position.X)
    end)
    t2.value3.InputEnded:Connect(function(input)
        local _ = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
    end)

    if not p42 then
        return
    end

    p42(p41)
end
color33 = function(p44, p45, p46)
    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(1, 0, 0, 34)
    TextButton.BackgroundColor3 = t2.value8.dark
    TextButton.BackgroundTransparency = 0.4
    TextButton.Text = p45
    TextButton.TextColor3 = t2.value8.text
    TextButton.Font = Enum.Font.GothamMedium
    TextButton.TextSize = 12
    TextButton.BorderSizePixel = 0
    TextButton.AutoButtonColor = false
    TextButton.Parent = p44
    t2.value15(TextButton, 10)
    t2.value16(TextButton, t2.value8.tealDim, 1)
    TextButton.MouseButton1Click:Connect(p46 or function()
    end)

    return TextButton
end
color34 = t2.value45.Aim
ReplicatedStorage(color34, "AIM LOCK")
color3(color34, "Aim Lock (Camera)", false, function(p47)
    t2.value10.AimLock = p47
    t2.value22.Visible = p47
end)
color3(color34, "Team Check", true, function(p48)
    t2.value10.AimLockTeamCheck = p48
end)
color3(color34, "Wall Check", true, function(p49)
    t2.value10.AimLockWallCheck = p49
end)
color3(color34, "Prediction (Lead)", false, function(p50)
    t2.value10.AimLockPrediction = p50
end)
color32(color34, "Prediction Strength %", 5, 50, 15, function(p51)
    t2.value10.AimLockPredictionAmount = p51 / 100
end)
color32(color34, "Aim Lock FOV", 30, 500, 150, function(p52)
    t2.value10.AimLockFOV = p52
    t2.value22.Size = UDim2.new(0, p52 * 2, 0, p52 * 2)
end)
color32(color34, "Aim Smoothness %", 5, 100, 30, function(p53)
    t2.value10.AimLockSmooth = p53 / 100
end)
color33(color34, "Target: Head", function()
    t2.value10.AimLockPart = "Head"
end)
color33(color34, "Target: HumanoidRootPart", function()
    t2.value10.AimLockPart = "HumanoidRootPart"
end)
color33(color34, "Target: Torso", function()
    t2.value10.AimLockPart = "Torso"
end)
color34 = t2.value45.Visuals
ReplicatedStorage(color34, "PLAYER ESP")
color3(color34, "ESP Enabled", false, function(p54)
    t2.value10.ESPEnabled = p54
end)
color3(color34, "Team Check", true, function(p55)
    t2.value10.ESPTeamCheck = p55
end)
color3(color34, "Show Names", true, function(p56)
    t2.value10.ESPNames = p56
end)
color3(color34, "Show Health", true, function(p57)
    t2.value10.ESPHealth = p57
end)
color3(color34, "Show Distance", false, function(p58)
    t2.value10.ESPDistance = p58
end)
ReplicatedStorage(color34, "PROJECTILE ESP")
color3(color34, "Projectile ESP", false, function(p59)
    t2.value10.ESPProjectiles = p59
end)
color34 = t2.value45.Movement
ReplicatedStorage(color34, "SPEED")
color3(color34, "WalkSpeed", false, function(p60)
    t2.value10.WalkSpeed = p60

    local v127 = t2.value23()

    if not v127 then
        return
    end

    local s1 = "WalkSpeed"

    if p60 then
        p60 = t2.value10.WSpeed
    end

    v127[s1] = p60 or 16
end)
color32(color34, "WalkSpeed Value", 16, 200, 30, function(p61)
    t2.value10.WSpeed = p61

    local WalkSpeed = t2.value10.WalkSpeed and t2.value23()

    if not WalkSpeed then
        return
    end

    WalkSpeed.WalkSpeed = p61
end)
color3(color34, "JumpPower", false, function(p62)
    t2.value10.JumpPower = p62

    local v130 = t2.value23()

    if not v130 then
        return
    end

    v130.UseJumpPower = true

    local s2 = "JumpPower"

    if p62 then
        p62 = t2.value10.JPower
    end

    v130[s2] = p62 or 50
end)
color32(color34, "JumpPower Value", 50, 300, 60, function(p63)
    t2.value10.JPower = p63

    local JumpPower = t2.value10.JumpPower and t2.value23()

    if not JumpPower then
        return
    end

    JumpPower.UseJumpPower = true
    JumpPower.JumpPower = p63
end)
ReplicatedStorage(color34, "MOVEMENT")
color3(color34, "Infinite Jump", false, function(p64)
    t2.value10.InfiniteJump = p64
end)
color3(color34, "Fly", false, function(p65)
    t2.value10.Fly = p65
end)
color32(color34, "Fly Speed", 20, 200, 60, function(p66)
    t2.value10.FlySpeed = p66
end)
color3(color34, "Noclip", false, function(p67)
    t2.value10.Noclip = p67
end)
color32 = t2.value45.Misc
ReplicatedStorage(color32, "UTILITY")
color3(color32, "Anti-AFK", false, function(p68)
    t2.value10.AntiAFK = p68
end)
color33(color32, "Server Hop", function()
    local function v133()
        local v134 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

        return t2.value4:JSONDecode(game:HttpGet(v134))
    end

    local result

    v133, result = pcall(v133)

    if v133 and (result and result.data) then
        for _, v in ipairs(result.data) do
            local v138 = v.playing < v.maxPlayers

            if v138 then
                v138 = v.id ~= game.JobId
            end

            if v138 then
                t2.value5:TeleportToPlaceInstance(game.PlaceId, v.id, t2.value6)

                return
            end
        end

        return
    else
        return
    end
end)
color33(color32, "Rejoin Server", function()
    t2.value5:Teleport(game.PlaceId, t2.value6)
end)
color33(color32, "Unload Script", function()
    t2.value20:Destroy()
    t2.value21:Destroy()
    t2.value19:Destroy()
end)
t2.value46 = nil
t2.value47 = nil
t2.value48 = nil
t2.value40.InputBegan:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    t2.value46 = true
    t2.value47 = input.Position
    t2.value48 = t2.value40.Position
    input.Changed:Connect(function()
        if input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        t2.value46 = false
    end)
end)
t2.value3.InputChanged:Connect(function(input)
    local value46 = t2.value46

    if value46 then
        value46 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
    end

    if not value46 then
        return
    end

    value46 = input.Position - t2.value47
    t2.value40.Position = UDim2.new(t2.value48.X.Scale, t2.value48.X.Offset + value46.X, t2.value48.Y.Scale, t2.value48.Y.Offset + value46.Y)
end)
t2.value49 = Instance.new("TextButton")
t2.value49.Name = "MunkeHubReopen"
t2.value49.Size = UDim2.new(0, 54, 0, 54)
t2.value49.Position = UDim2.new(0, 20, 0.5, -27)
t2.value49.BackgroundColor3 = t2.value8.panel
t2.value49.Text = "M"
t2.value49.TextColor3 = t2.value8.teal
t2.value49.Font = Enum.Font.GothamBold
t2.value49.TextSize = 24
t2.value49.BorderSizePixel = 0
t2.value49.AutoButtonColor = false
t2.value49.Visible = false
t2.value49.Active = true
t2.value49.ZIndex = 5
t2.value49.Parent = t2.value19
t2.value15(t2.value49, 27)
t2.value16(t2.value49, t2.value8.teal, 2)
t2.value50 = nil
t2.value51 = nil
t2.value52 = nil
t2.value53 = nil
t2.value49.InputBegan:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    t2.value50 = true
    t2.value53 = false
    t2.value51 = input.Position
    t2.value52 = t2.value49.Position
    input.Changed:Connect(function()
        if input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        t2.value50 = false
    end)
end)
t2.value3.InputChanged:Connect(function(input)
    if not t2.value50 then
        return
    end

    if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    local v140 = input.Position - t2.value51
    local X = v140.X

    X = math.abs(X) > 6

    if not X then
        X = v140.Y
        X = math.abs(X) > 6
    end

    if X then
        t2.value53 = true
    end

    t2.value49.Position = UDim2.new(t2.value52.X.Scale, t2.value52.X.Offset + v140.X, t2.value52.Y.Scale, t2.value52.Y.Offset + v140.Y)
end)
t2.value49.MouseButton1Click:Connect(function()
    if t2.value53 then
        return
    else
        t2.value49.Visible = false
        t2.value40.Visible = true
        t2.value40.BackgroundTransparency = 1
        t2.value40.Position = UDim2.new(0.5, -200, 0.5, -210)
        t2.value18(t2.value40, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			["BackgroundTransparency"] = 0,
			["Position"] = UDim2.new(0.5, -200, 0.5, -230)
		})

        return
    end
end)
function t2.value54()
    t2.value40.Visible = false
    t2.value49.Visible = true
end
unpack_ = function()
    t2.value49.Visible = false
    t2.value40.Visible = true
    t2.value40.BackgroundTransparency = 1
    t2.value40.Position = UDim2.new(0.5, -200, 0.5, -210)
    t2.value18(t2.value40, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		["BackgroundTransparency"] = 0,
		["Position"] = UDim2.new(0.5, -200, 0.5, -230)
	})
end
game_2.MouseButton1Click:Connect(t2.value54)
t2.value3.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode ~= Enum.KeyCode.RightShift then
        return
    end

    if t2.value40.Visible then
        t2.value54()

        return
    end

    unpack_()
end)
t1.MouseButton1Click:Connect(function()
    if setclipboard then
        pcall(setclipboard, t2.value9)

        return
    end

    if not toclipboard then
        return
    end

    pcall(toclipboard, t2.value9)
end)
game_.Stepped:Connect(function()
    if t2.value10.Noclip then
        local Character = t2.value6.Character

        if Character then
            for _, descendant in ipairs(Character:GetDescendants()) do
                local isBasePart = descendant:IsA("BasePart")

                if isBasePart then
                    isBasePart = descendant.CanCollide
                end

                if isBasePart then
                    descendant.CanCollide = false
                end
            end

            return
        else
            return
        end

        return
    else
        return
    end
end)
game_.Heartbeat:Connect(function()
    local v146 = t2.value23()

    if not v146 then
        return
    end

    local WalkSpeed = t2.value10.WalkSpeed

    if WalkSpeed then
        WalkSpeed = v146.WalkSpeed ~= t2.value10.WSpeed
    end

    if WalkSpeed then
        v146.WalkSpeed = t2.value10.WSpeed
    end

    if not t2.value10.JumpPower then
        return
    end

    v146.UseJumpPower = true

    if v146.JumpPower == t2.value10.JPower then
        return
    end

    v146.JumpPower = t2.value10.JPower
end)
t2.value3.JumpRequest:Connect(function()
    if not t2.value10.InfiniteJump then
        return
    end

    local v148 = t2.value23()

    if not v148 then
        return
    end

    v148:ChangeState(Enum.HumanoidStateType.Jumping)
end)
t2.value55 = nil
t2.value56 = nil
function t2.value57()
    local v149 = t2.value24()

    if v149 then
        t2.value55 = Instance.new("BodyVelocity")
        t2.value55.MaxForce = Vector3.new((1 / 0), (1 / 0), (1 / 0))
        t2.value55.Velocity = Vector3.zero
        t2.value55.Parent = v149
        t2.value56 = Instance.new("BodyGyro")
        t2.value56.MaxTorque = Vector3.new((1 / 0), (1 / 0), (1 / 0))
        t2.value56.P = 10000
        t2.value56.CFrame = v149.CFrame
        t2.value56.Parent = v149

        return
    else
        return
    end
end
function t2.value58()
    if t2.value55 then
        t2.value55:Destroy()
        t2.value55 = nil
    end

    if not t2.value56 then
        return
    end

    t2.value56:Destroy()
    t2.value56 = nil
end
game_.Heartbeat:Connect(function()
    if t2.value10.Fly then
        if not t2.value24() then
            return
        end

        if not t2.value55 then
            t2.value57()

            return
        end

        local vector3 = Vector3.zero
        local CFrame_ = t2.value7.CFrame

        if t2.value3:IsKeyDown(Enum.KeyCode.W) then
            vector3 = vector3 + CFrame_.LookVector
        end

        if t2.value3:IsKeyDown(Enum.KeyCode.S) then
            vector3 = vector3 - CFrame_.LookVector
        end

        if t2.value3:IsKeyDown(Enum.KeyCode.A) then
            vector3 = vector3 - CFrame_.RightVector
        end

        if t2.value3:IsKeyDown(Enum.KeyCode.D) then
            vector3 = vector3 + CFrame_.RightVector
        end

        if t2.value3:IsKeyDown(Enum.KeyCode.Space) then
            vector3 = vector3 + Vector3.new(0, 1, 0)
        end

        if t2.value3:IsKeyDown(Enum.KeyCode.LeftShift) then
            vector3 = vector3 - Vector3.new(0, 1, 0)
        end

        if not (vector3.Magnitude > 0) then
            t2.value55.Velocity = vector3 * t2.value10.FlySpeed
            t2.value56.CFrame = CFrame_

            return
        end

        vector3 = vector3.Unit
        t2.value55.Velocity = vector3 * t2.value10.FlySpeed
        t2.value56.CFrame = CFrame_

        return
    else
        if not t2.value55 then
            return
        end

        t2.value58()

        return
    end
end)
t2.value59 = Instance.new("VirtualUser")
t2.value59.Parent = t2.value1
task.spawn(function()
    while t2.value19.Parent do
        if t2.value10.AntiAFK then
            pcall(function()
                t2.value59:CaptureController()
            end)

            local function v152()
                t2.value59:ClickButton2(Vector2.new())
            end

            pcall(v152)
        end

        task.wait(60)
    end
end)
t2.value40.BackgroundTransparency = 1
t2.value40.Position = UDim2.new(0.5, -200, 0.5, -210)
t2.value18(t2.value40, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	["BackgroundTransparency"] = 0,
	["Position"] = UDim2.new(0.5, -200, 0.5, -230)
})
