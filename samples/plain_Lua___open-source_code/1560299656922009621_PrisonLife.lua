local Vind = loadstring(game:HttpGet("https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua"))()
local ts = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Cam = workspace.CurrentCamera

_G.InfJump = false
_G.Noclip = false
_G.AntiTase = false
_G.KillNotif = false
_G.WalkSpeedEnabled = false
_G.CustomWalkSpeed = 16
_G.JumpPowerEnabled = false
_G.CustomJumpPower = 50
_G.SilentAim = false
_G.AutoShoot = false
_G.WallCheck = true
_G.TargetPart = "Head"
_G.TargCrim = true
_G.TargGuard = true
_G.TargInmate = true
_G.FovSize = 250
_G.FastFire = false
_G.SpecTarget = nil

_G.EspChams = false
_G.EspBox = false
_G.EspTracers = false
_G.EspWeapon = false
_G.EspHealth = false

local Window = Vind:CreateWindow({
    Title = "AvHub - Prison Life",
    Subtitle = "AvHub",
    Icon = "rbxassetid://101597703020874",
    Size = UDim2.fromOffset(640, 455),
    MinSize = Vector2.new(500, 360),
    Draggable = true,
    Resizable = true,
    UseBlur = true,
    ToggleKeybind = Enum.KeyCode.Insert,
    TogglePosition = UDim2.fromOffset(20, 220),
})

local PlayerTab = Window:AddTab({ Name = "Player", Icon = "Lucide:user" })
local Visual = Window:AddTab({ Name = "Visual", Icon = "Lucide:eye" })

Window:AddTabLine()

local Combat = Window:AddTab({ Name = "Combat", Icon = "Lucide:swords" })
local GunGiver = Window:AddTab({ Name = "Gun Giver", Icon = "Lucide:download" })

Window:AddTabLine()

local Teleport = Window:AddTab({ Name = "Teleport", Icon = "Lucide:map-pin" })
local Spectate = Window:AddTab({ Name = "Spectate", Icon = "Lucide:eye" })
local Settings = Window:AddTab({ Name = "Settings", Icon = "Lucide:settings" })

PlayerTab:AddSection("WalkSpeed")
PlayerTab:AddToggle({
    Text = "Enable WalkSpeed",
    CurrentValue = false,
    Callback = function(v) _G.WalkSpeedEnabled = v end
})
PlayerTab:AddSlider({
    Text = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "spd",
    CurrentValue = 16,
    Callback = function(v) _G.CustomWalkSpeed = v end
})

PlayerTab:AddSection("JumpPower")
PlayerTab:AddToggle({
    Text = "Enable JumpPower",
    CurrentValue = false,
    Callback = function(v) _G.JumpPowerEnabled = v end
})
PlayerTab:AddSlider({
    Text = "JumpPower",
    Range = {50, 120},
    Increment = 1,
    Suffix = "jp",
    CurrentValue = 50,
    Callback = function(v) _G.CustomJumpPower = v end
})

Combat:AddSection("Character Cheats")
Combat:AddToggle({ Text = "Infinite Jump", CurrentValue = false, Callback = function(v) _G.InfJump = v end })
Combat:AddToggle({ Text = "Noclip (Tomato Bypass)", CurrentValue = false, Callback = function(v) _G.Noclip = v end })
Combat:AddToggle({ Text = "Anti-Tase (Immunity)", CurrentValue = false, Callback = function(v) _G.AntiTase = v end })

Combat:AddSection("Movement Speed")
Combat:AddToggle({ Text = "Enable Speed Modifier", CurrentValue = false, Callback = function(v) _G.WalkSpeedEnabled = v end })
Combat:AddSlider({
    Text = "WalkSpeed",
    Range = {16, 150},
    Increment = 1,
    Suffix = "spd",
    CurrentValue = 16,
    Callback = function(v) _G.CustomWalkSpeed = v end
})

Combat:AddSection("Guns")
Combat:AddToggle({ Text = "Fast Fire Rate", CurrentValue = false, Callback = function(v) _G.FastFire = v end })
Combat:AddToggle({ Text = "Kill Notifications", CurrentValue = false, Callback = function(v) _G.KillNotif = v end })

Combat:AddSection("Silent Aim & Targeting")
Combat:AddToggle({ Text = "Enable Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end })
Combat:AddToggle({ Text = "Auto Shoot (Inside FOV)", CurrentValue = false, Callback = function(v) _G.AutoShoot = v end })
Combat:AddToggle({ Text = "Wall Check", CurrentValue = true, Callback = function(v) _G.WallCheck = v end })
Combat:AddDropdown({
    Text = "Target Hit Part",
    Options = {"Head", "Torso", "Legs"},
    CurrentOption = {"Head"},
    Callback = function(Option) _G.TargetPart = Option[1] end,
})
Combat:AddSection("Team Filters")
Combat:AddToggle({ Text = "Target Criminals", CurrentValue = true, Callback = function(v) _G.TargCrim = v end })
Combat:AddToggle({ Text = "Target Guards", CurrentValue = true, Callback = function(v) _G.TargGuard = v end })
Combat:AddToggle({ Text = "Target Inmates", CurrentValue = true, Callback = function(v) _G.TargInmate = v end })

Combat:AddSection("FOV Circle")
Combat:AddToggle({ Text = "FOV Circle Visible", CurrentValue = false, Callback = function(v) if _G.FovCircleObj then _G.FovCircleObj.Visible = v end end })
Combat:AddSlider({
    Text = "FOV Circle Size",
    Range = {50, 500},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 250,
    Callback = function(v) _G.FovSize = v end,
})

Visual:AddSection("ESP Settings")
Visual:AddToggle({ Text = "Chams (Highlight)", CurrentValue = false, Callback = function(v) _G.EspChams = v end })
Visual:AddToggle({ Text = "Boxes", CurrentValue = false, Callback = function(v) _G.EspBox = v end })
Visual:AddToggle({ Text = "Tracers", CurrentValue = false, Callback = function(v) _G.EspTracers = v end })
Visual:AddToggle({ Text = "Weapon ESP", CurrentValue = false, Callback = function(v) _G.EspWeapon = v end })
Visual:AddToggle({ Text = "Health Bars", CurrentValue = false, Callback = function(v) _G.EspHealth = v end })

GunGiver:AddSection("Guard Room Guns")
local gunPositions = {
    ["MP5"] = Vector3.new(814, 104, 2230),
    ["Remington 870 (Guard)"] = Vector3.new(821, 104, 2230),
    ["M700 (Guard)"] = Vector3.new(836, 103, 2230),
    ["M4A1"] = Vector3.new(848, 103, 2229),
}
GunGiver:AddSection("Criminal Base Guns")
local gunPositionsCrim = {
    ["Remington 870 (Crim)"] = Vector3.new(-938, 98, 2040),
    ["AK-47"] = Vector3.new(-931, 98, 2039),
    ["M700 (Crim)"] = Vector3.new(-920, 100, 2038),
    ["FAL"] = Vector3.new(-903, 100, 2048),
}
local function getGunTeleport(pos)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local originalCFrame = hrp.CFrame
    hrp.CFrame = CFrame.new(pos)
    task.wait(0.2)
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") and obj.Parent and (obj.Parent.Position - pos).Magnitude < 5 then
                firetouchinterest(hrp, obj.Parent, 0)
                firetouchinterest(hrp, obj.Parent, 1)
            end
        end
    end)
    task.wait(4)
    hrp.CFrame = originalCFrame
end
for name, pos in pairs(gunPositions) do
    GunGiver:AddButton({ Text = "Guard: " .. name, Callback = function() getGunTeleport(pos) end })
end
for name, pos in pairs(gunPositionsCrim) do
    GunGiver:AddButton({ Text = "Crim: " .. name, Callback = function() getGunTeleport(pos) end })
end

Teleport:AddSection("Locations")
local function tp(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end
Teleport:AddButton({ Text = "Yard", Callback = function() tp(Vector3.new(775, 98, 2470)) end })
Teleport:AddButton({ Text = "Criminal Base", Callback = function() tp(Vector3.new(-943, 94, 2054)) end })
Teleport:AddButton({ Text = "Guard Tower", Callback = function() tp(Vector3.new(823, 131, 2588)) end })
Teleport:AddButton({ Text = "Exit Area Tower", Callback = function() tp(Vector3.new(477, 103, 2238)) end })
Teleport:AddButton({ Text = "Rooftop", Callback = function() tp(Vector3.new(898, 137, 2451)) end })
Teleport:AddButton({ Text = "Building", Callback = function() tp(Vector3.new(-290, 114, 2011)) end })

Spectate:AddSection("Player Spectator")
local pList = {}
local function refreshPlayerList()
    pList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(pList, p.Name) end
    end
    if #pList == 0 then table.insert(pList, "None") end
    return pList
end
refreshPlayerList()
local specDropdown = Spectate:AddDropdown({
    Text = "Target Player",
    Options = pList,
    CurrentOption = {pList[1]},
    Callback = function(opt) _G.SpecTarget = Players:FindFirstChild(opt[1]) end
})
Spectate:AddButton({
    Text = "Refresh Player List",
    Callback = function()
        local newList = refreshPlayerList()
        specDropdown:SetOptions(newList)
    end
})
Spectate:AddButton({
    Text = "Start Spectating",
    Callback = function()
        if _G.SpecTarget and _G.SpecTarget.Character and _G.SpecTarget.Character:FindFirstChild("Humanoid") then
            Cam.CameraSubject = _G.SpecTarget.Character.Humanoid
        end
    end
})
Spectate:AddButton({
    Text = "Teleport to Player",
    Callback = function()
        if _G.SpecTarget and _G.SpecTarget.Character and _G.SpecTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = _G.SpecTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})
Spectate:AddButton({
    Text = "Unspectate",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Cam.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
})

Settings:AddSection("UI")
Settings:AddButton({
    Text = "Unload UI",
    Callback = function() Window:Destroy() end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump then
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

RunService.Stepped:Connect(function()
    if _G.Noclip then
        pcall(function()
            local CharacterCollision = ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision")
            if CharacterCollision then
                CharacterCollision:Destroy()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                    for _, Connection in ipairs(getconnections(LocalPlayer.Character.Head:GetPropertyChangedSignal("CanCollide"))) do
                        Connection:Disable()
                    end
                end
            end
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end

    if _G.AntiTase then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child.Name == "Tased" or child.Name == "Ragdoll" then
                        child:Destroy()
                    end
                end
            end
        end)
    end

    if _G.WalkSpeedEnabled then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = _G.CustomWalkSpeed
            end
        end)
    end

    if _G.JumpPowerEnabled then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = _G.CustomJumpPower
            end
        end)
    end
end)

local function isTargetAllowed(p)
    if not p.Team or not LocalPlayer.Team then return true end
    if p.Team == LocalPlayer.Team then return false end
    local t = p.Team.Name
    if t:match("Criminal") and not _G.TargCrim then return false end
    if t:match("Guard") and not _G.TargGuard then return false end
    if (t:match("Inmate") or t:match("Prisoner")) and not _G.TargInmate then return false end
    return true
end

local function isvisible(targetpart)
    if not _G.WallCheck then return true end
    local character = LocalPlayer.Character
    if not character then return false end
    local origin = Cam.CFrame.Position
    local direction = (targetpart.Position - origin)
    local raycastparams = RaycastParams.new()
    raycastparams.FilterType = Enum.RaycastFilterType.Exclude
    raycastparams.FilterDescendantsInstances = {character, Cam}
    raycastparams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, raycastparams)
    if result then return result.Instance:IsDescendantOf(targetpart.Parent) end
    return true
end

local function getSelectedTargetPart(character)
    if not character then return nil end
    local partName = _G.TargetPart or "Head"
    if partName == "Head" then return character:FindFirstChild("Head")
    elseif partName == "Torso" then return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif partName == "Legs" then return character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("Right Leg") or character:FindFirstChild("LeftLeg") or character:FindFirstChild("HumanoidRootPart") end
    return character:FindFirstChild("Head")
end

local closesthitpart = nil
local function getclosestplayer()
    local closestpart = nil
    local closestdistance = _G.FovSize
    local screenCenter = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isTargetAllowed(player) then
            local character = player.Character
            if character then
                local targetPart = getSelectedTargetPart(character)
                local humanoid = character:FindFirstChild("Humanoid")
                if targetPart and humanoid and humanoid.Health > 0 then
                    local screenpos, onscreen = Cam:WorldToViewportPoint(targetPart.Position)
                    if onscreen and isvisible(targetPart) then
                        local distance = (Vector2.new(screenpos.X, screenpos.Y) - screenCenter).Magnitude
                        if distance <= _G.FovSize and distance < closestdistance then
                            closestdistance = distance
                            closestpart = targetPart
                        end
                    end
                end
            end
        end
    end
    return closestpart
end

RunService.Heartbeat:Connect(function()
    if _G.SilentAim or _G.AutoShoot then
        closesthitpart = getclosestplayer()
    else
        closesthitpart = nil
    end
end)

local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method, arguments = getnamecallmethod(), {...}
    if _G.SilentAim and self == workspace and not checkcaller() and method == "Raycast" then
        local hitpart = closesthitpart
        if hitpart then
            local origin = arguments[1]
            local direction = (hitpart.Position - origin).Unit * 1000
            arguments[1], arguments[2] = origin, direction
            return oldnamecall(self, unpack(arguments))
        end
    end
    return oldnamecall(self, unpack(arguments))
end))

RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and (tool:FindFirstChild("Handle") or tool:FindFirstChild("Muzzle")) then
            local isMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            if (_G.AutoShoot and closesthitpart) or (_G.FastFire and isMouseDown and closesthitpart) then
                local remote = workspace:FindFirstChild("ShootEvent", true) or ReplicatedStorage:FindFirstChild("ShootEvent", true)
                if remote then
                    remote:FireServer(tool, closesthitpart.Position, closesthitpart)
                end
            end
        end
    end)
end)

local TrackedESP = {}

local function getTeamColor(p)
    local t = p.Team and p.Team.Name or ""
    if t:match("Criminal") then return Color3.fromRGB(255, 30, 30)
    elseif t:match("Guard") then return Color3.fromRGB(30, 120, 255)
    elseif t:match("Inmate") or t:match("Prisoner") then return Color3.fromRGB(255, 140, 0) end
    return Color3.fromRGB(255, 255, 255)
end

local function createESP(player)
    if player == LocalPlayer then return end
    local esp = {
        Box = Drawing.new("Square"),
        Bg = Drawing.new("Square"),
        Bar = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Text = Drawing.new("Text"),
        Highlight = Instance.new("Highlight")
    }
    esp.Box.Visible = false; esp.Box.Filled = false; esp.Box.Thickness = 1.5
    esp.Bg.Visible = false; esp.Bg.Filled = true; esp.Bg.Color = Color3.new(0,0,0)
    esp.Bar.Visible = false; esp.Bar.Filled = true
    esp.Tracer.Visible = false; esp.Tracer.Thickness = 1
    esp.Text.Visible = false; esp.Text.Size = 12; esp.Text.Center = true; esp.Text.Outline = true
    esp.Highlight.Parent = CoreGui
    TrackedESP[player] = esp
end

local function removeESP(player)
    if TrackedESP[player] then
        for _, v in pairs(TrackedESP[player]) do
            pcall(function() v:Destroy() end)
            pcall(function() v:Remove() end)
        end
        TrackedESP[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(TrackedESP) do
        local char = player.Character
        local color = getTeamColor(player)
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local head = char.Head
            local hum = char.Humanoid
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude

            if dist <= 1000 and hum.Health > 0 then
                local headPos, headOnScreen = Cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos, legOnScreen = Cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local rootScreenPos, onScreen = Cam:WorldToViewportPoint(root.Position)

                if onScreen then
                    if _G.EspChams then
                        esp.Highlight.Enabled = true
                        esp.Highlight.Adornee = char
                        esp.Highlight.FillColor = color
                        esp.Highlight.FillTransparency = 0.4
                    else
                        esp.Highlight.Enabled = false
                    end

                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    local boxPos = Vector2.new(headPos.X - width / 2, headPos.Y)

                    if _G.EspBox then
                        esp.Box.Visible = true
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = boxPos
                        esp.Box.Color = color
                    else
                        esp.Box.Visible = false
                    end

                    if _G.EspTracers then
                        esp.Tracer.Visible = true
                        esp.Tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(rootScreenPos.X, boxPos.Y + height)
                        esp.Tracer.Color = color
                    else
                        esp.Tracer.Visible = false
                    end

                    if _G.EspWeapon then
                        local tool = char:FindFirstChildOfClass("Tool")
                        esp.Text.Visible = true
                        esp.Text.Text = tool and "["..tool.Name.."]" or "[None]"
                        esp.Text.Position = Vector2.new(rootScreenPos.X, boxPos.Y + height + 2)
                    else
                        esp.Text.Visible = false
                    end

                    if _G.EspHealth then
                        esp.Bg.Visible = true
                        esp.Bg.Size = Vector2.new(4, height)
                        esp.Bg.Position = Vector2.new(boxPos.X - 6, boxPos.Y)

                        local hpFrac = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local hpHeight = height * hpFrac
                        esp.Bar.Visible = true
                        esp.Bar.Size = Vector2.new(2, hpHeight)
                        esp.Bar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - hpHeight))
                        esp.Bar.Color = Color3.fromRGB(255 - (hpFrac * 255), hpFrac * 255, 0)
                    else
                        esp.Bg.Visible = false
                        esp.Bar.Visible = false
                    end
                else
                    esp.Box.Visible = false; esp.Bg.Visible = false; esp.Bar.Visible = false; esp.Tracer.Visible = false; esp.Text.Visible = false; esp.Highlight.Enabled = false
                end
            else
                esp.Box.Visible = false; esp.Bg.Visible = false; esp.Bar.Visible = false; esp.Tracer.Visible = false; esp.Text.Visible = false; esp.Highlight.Enabled = false
            end
        else
            esp.Box.Visible = false; esp.Bg.Visible = false; esp.Bar.Visible = false; esp.Tracer.Visible = false; esp.Text.Visible = false; esp.Highlight.Enabled = false
        end
    end
end)

local fov_circle = Drawing.new("Circle")
fov_circle.Transparency = 1
fov_circle.Filled = false
fov_circle.NumSides = 64
fov_circle.Thickness = 2.5
fov_circle.Visible = false
_G.FovCircleObj = fov_circle

RunService.PreRender:Connect(function()
    if fov_circle.Visible then
        fov_circle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
        fov_circle.Radius = _G.FovSize
        fov_circle.Color = Color3.fromRGB(170, 0, 255)
    end
end)

local Webhooks = loadstring(game:HttpGet("https://raw.githubusercontent.com/nonmex9-design/AvHub/refs/heads/main/Scripts/webhook"))()
Webhooks.Send(
	"AvHub Prison Life Execution Log 🕒",
	"4934475"
)