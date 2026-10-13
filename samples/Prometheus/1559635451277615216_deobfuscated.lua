-- This file was generated at discord.gg/syncrypt

local t1 = {}
if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
    game:GetService("CoreGui").ToraScript:Destroy()
end
local v2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v3 = v2:CreateWindow("Murder Duels")

task.spawn(function()
    local timestamp = tick()

    while task.wait() do
        if tick() - timestamp >= 1 then
            timestamp = tick()
            os.date(table.concat({
				"%H",
				"%M",
				"%S"
			}, ":"))
        end
    end
end)
t1.value1 = nil
t1.value2 = nil
t1.value1 = nil
local function v4()
    if t1.value1 then
        task.cancel(t1.value1)
    end

    if t1.value2 then
        t1.value2:Destroy()
    end

    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        local Character = player.Character

        if Character then
            Character = player.Character:FindFirstChild("GetReal")
        end

        if Character then
            player.Character.GetReal:Destroy()
        end
    end
end
function t1.value3()
    if t1.value2 then
        return
    end

    _G.FriendColor = Color3.fromRGB(0, 0, 255)
    _G.EnemyColor = Color3.fromRGB(255, 0, 0)
    _G.UseTeamColor = true

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    t1.value2 = Instance.new("Folder")
    t1.value2.Name = "ESP"
    t1.value2.Parent = game.CoreGui

    local BoxHandleAdornment = Instance.new("BoxHandleAdornment")

    BoxHandleAdornment.Name = "nilBox"
    BoxHandleAdornment.Size = Vector3.new(1, 2, 1)
    BoxHandleAdornment.Color3 = Color3.fromRGB(100, 100, 100)
    BoxHandleAdornment.Transparency = 0.7
    BoxHandleAdornment.ZIndex = 0
    BoxHandleAdornment.AlwaysOnTop = false
    BoxHandleAdornment.Visible = false

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "nilNameTag"
    BillboardGui.Enabled = false
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.StudsOffset = Vector3.new(0, 1.8, 0)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Tag"
    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, -50, 0, 0)
    TextLabel.Size = UDim2.new(0, 300, 0, 20)
    TextLabel.TextSize = 15
    TextLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    TextLabel.TextStrokeTransparency = 0.4
    TextLabel.Font = Enum.Font.SourceSansBold

    local function v13(p1)
        local _ = p1.Character

        repeat
            task.wait()
        until p1.Character

        local p1Name = t1.value2:FindFirstChild(p1.Name)

        if not p1Name then
            return
        end

        p1Name:ClearAllChildren()

        local clone = BoxHandleAdornment:Clone()

        clone.Adornee = p1.Character
        clone.Parent = p1Name

        local clone2 = BillboardGui:Clone()

        clone2.Parent = p1Name
        clone2.Enabled = true
        clone2.Adornee = p1.Character:FindFirstChild("Head")

        if clone2:FindFirstChild("Tag") then
            clone2.Tag.Text = p1.Name
            clone2.Tag.TextColor3 = p1.TeamColor.Color
        end

        clone.Color3 = p1.TeamColor.Color
    end

    for _, player in ipairs(Players:GetPlayers()) do
        (function(p2)
            local Folder = Instance.new("Folder")

            Folder.Name = p2.Name
            Folder.Parent = t1.value2
            p2.CharacterAdded:Connect(function()
                if _G.ESP then
                    v13(p2)
                end
            end)
            p2.CharacterRemoving:Connect(function()
                local Name = t1.value2:FindFirstChild(p2.Name)
                if Name then
                    Name:ClearAllChildren()
                end
            end)
            task.spawn(function()
                v13(p2)
            end)
        end)(player)
    end

    local function v16(p3, p4)
        if p3.Character then
            local GetReal = p3.Character:FindFirstChild("GetReal")

            if not GetReal then
                GetReal = Instance.new("Highlight")
                GetReal.Name = "GetReal"
                GetReal.Adornee = p3.Character
                GetReal.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                GetReal.Parent = p3.Character
            end

            GetReal.FillColor = p4
        end
    end

    t1.value1 = task.spawn(function()
        while _G.ESP do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local v74 = v16
                    local UseTeamColor = _G.UseTeamColor

                    if UseTeamColor then
                        UseTeamColor = player.TeamColor.Color
                    end

                    if not UseTeamColor then
                        UseTeamColor = LocalPlayer.TeamColor == player.TeamColor

                        if UseTeamColor then
                            UseTeamColor = _G.FriendColor
                        end

                        if not UseTeamColor then
                            UseTeamColor = _G.EnemyColor
                        end
                    end

                    v74(player, UseTeamColor)
                end
            end

            task.wait()
        end
    end)
end
v3:AddToggle({
	text = "Player ESP",
	flag = "toggle",
	state = false,
	callback = function(p5)
    _G.ESP = p5
    print("ESP:", p5)

    if p5 then
        t1.value3()

        return
    end

    v4()
end
})
local Players = game:GetService("Players")

t1.value4 = game:GetService("UserInputService")
t1.value5 = game:GetService("Workspace")

local RunService = game:GetService("RunService")

t1.value6 = t1.value5.CurrentCamera
t1.value7 = Players.LocalPlayer
_G.SilentAim = false
_G.Wallbang = false
_G.FOV_RADIUS = 150
t1.value8 = nil
t1.value9 = Drawing.new("Circle")
t1.value9.Color = Color3.fromRGB(0, 255, 0)
t1.value9.Thickness = 3
t1.value9.Filled = false
t1.value9.Transparency = 0.8
t1.value9.Visible = false
function t1.value10(p6, p7)
    if _G.Wallbang then
        return true
    end

    local CFramePosition = t1.value6.CFrame.Position
    local v24 = p6.Position - CFramePosition
    local raycastParams = RaycastParams.new()

    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {
		t1.value7.Character,
		p7,
		t1.value6
	}
    raycastParams.IgnoreWater = true

    return t1.value5:Raycast(CFramePosition, v24, raycastParams) == nil
end
RunService.RenderStepped:Connect(function()
    if _G.SilentAim then
        local MouseLocation = t1.value4:GetMouseLocation()
        t1.value9.Position = Vector2.new(MouseLocation.X, MouseLocation.Y)
        t1.value9.Radius = _G.FOV_RADIUS
        t1.value9.Visible = true
        local v27
        local FOV_RADIUS = _G.FOV_RADIUS
        local MouseLocation2 = t1.value4:GetMouseLocation()
        local Characters = t1.value5:FindFirstChild("Characters")
        local v31 = Characters and Characters:GetChildren() or t1.value5:GetChildren()
        for _, v in ipairs(v31) do
            local v34 = v:IsA("Model")

            if v34 then
                v34 = v ~= t1.value7.Character
            end

            if not v34 then
                continue
            end

            local Humanoid = v:FindFirstChildOfClass("Humanoid")

            if not (Humanoid and Humanoid.Health > 0) then
                continue
            end

            local MatchSide = t1.value7:GetAttribute("MatchSide")
            local MatchSide2 = v:GetAttribute("MatchSide")

            if MatchSide then
                MatchSide = MatchSide2 and MatchSide == MatchSide2
            end

            if MatchSide then
                local v38 = v:GetAttribute("BotMatchBot") ~= true

                if v38 then
                    v38 = v:GetAttribute("Decoy") ~= true
                end

                if v38 then
                    continue
                end
            end

            local v39 = v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart")

            if v39 then
                local v41, t2Result = t1.value6:WorldToViewportPoint(v39.Position)
                if t2Result then
                    local Magnitude = (Vector2.new(v41.X, v41.Y) - MouseLocation2).Magnitude

                    if Magnitude < FOV_RADIUS and t1.value10(v39, v) then
                        v27 = v39
                        FOV_RADIUS = Magnitude
                    end
                end
            end
        end
        t1.value8 = v27

        return
    end

    local value9 = t1.value9

    value9.Visible = false
    t1.value8 = value9
end)
t1.value11 = nil
t1.value11 = hookmetamethod(game, "__namecall", function(p8, ...)
    local v45 = getnamecallmethod()
    local v46 = not checkcaller()
    local t3 = { ... }

    if v46 then
        v46 = _G.SilentAim and t1.value8
    end

    if v46 then
        if v45 == "FireServer" then
            local v48 = p8.Name == "ThrowReplicate"

            if v48 then
                v48 = type(t3[1]) == "table"
            end

            if v48 then
                t3[1].target = t1.value8.Position

                return t1.value11(p8, unpack(t3))
            end

            local v49 = p8.Name == "ShootReplicate"

            if v49 then
                v49 = type(t3[1]) == "table"
            end

            if v49 then
                t3[1].hitInstance = t1.value8
                t3[1].hitPos = t1.value8.Position
                t3[1].to = t1.value8.Position
                t3[1].isCharacterHit = true

                local segments = t3[1].segments

                if segments then
                    segments = type(t3[1].segments) == "table"

                    if segments then
                        segments = #t3[1].segments > 0
                    end
                end

                if segments then
                    local v51 = t3[1].segments[#t3[1].segments]

                    v51.hitInstance = t1.value8
                    v51.hitPos = t1.value8.Position
                    v51.isCharacterHit = true
                end

                return t1.value11(p8, unpack(t3))
            end
        elseif v45 == "Fire" then
            local v52 = p8.Name == "SpawnKnife"

            if v52 then
                v52 = type(t3[1]) == "table"
            end

            if v52 then
                t3[1].target = t1.value8.Position

                return t1.value11(p8, unpack(t3))
            end

            local v53 = p8.Name == "SpawnBullet"

            if v53 then
                v53 = type(t3[1]) == "table"
            end

            if v53 then
                t3[1].hitInstance = t1.value8
                t3[1].hitPos = t1.value8.Position
                t3[1].to = t1.value8.Position
                t3[1].isCharacterHit = true

                local segments = t3[1].segments

                if segments then
                    segments = type(t3[1].segments) == "table"

                    if segments then
                        segments = #t3[1].segments > 0
                    end
                end

                if segments then
                    local v55 = t3[1].segments[#t3[1].segments]

                    v55.hitInstance = t1.value8
                    v55.hitPos = t1.value8.Position
                    v55.isCharacterHit = true
                end

                return t1.value11(p8, unpack(t3))
            end
        end
    end

    return t1.value11(p8, ...)
end)
v3:AddToggle({
	text = "Wallbang",
	flag = "wallbang_toggle",
	state = false,
	callback = function(p9)
    _G.Wallbang = p9
    print("Wallbang Status: ", p9)
end
})
v3:AddToggle({
	text = "Silent Aim",
	flag = "silent_aim_toggle",
	state = false,
	callback = function(p10)
    _G.SilentAim = p10
    print("Silent Aim Status: ", p10)
end
})
v3:AddSlider({
	text = "FOV Size",
	flag = "fov_slider",
	value = 150,
	min = 10,
	max = 800,
	callback = function(p11)
    _G.FOV_RADIUS = p11
    print("FOV Radius Updated: ", p11)
end
})
v3:AddLabel({
	text = "YouTube: Tora IsMe"
})
v2:Init()
