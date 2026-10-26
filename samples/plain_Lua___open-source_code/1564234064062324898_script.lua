local Drawing = Drawing

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))()
local win = lib:Window("W1lteGameYT Hub", Color3.fromRGB(44, 120, 224), Enum.KeyCode.P)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AdvanceTech = {}

AdvanceTech.Settings = {
    Aimbot = {
        Enabled = true,
        TeamCheck = "FFA",
        FOV = 120,
        ShowFOVCircle = true,
        Smoothing = 10,
        ActivationDelay = 0.07,
        ActivationKey = Enum.UserInputType.MouseButton2
    },
    Privacy = {
        AntiSpectate = true
    }
}

AdvanceTech.State = {
    Aimbot = {
        IsKeyDown = false,
        KeyDownTimestamp = 0
    },
    Privacy = {
        OriginalTransparencies = {}
    },
    UI = {
        IsVisible = true,
        FOVCircle = Drawing.new("Circle")
    }
}

function AdvanceTech:IsEnemy(player)
    if not player or player == LocalPlayer then return false end
    local check = self.Settings.Aimbot.TeamCheck
    if check == "FFA" or check == "Everyone" then return true end
    if check == "Team-Based" and player.Team ~= LocalPlayer.Team then return true end
    return false
end

function AdvanceTech:GetBestTarget()
    local bestTarget = nil
    local smallestMagnitude = self.Settings.Aimbot.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if self:IsEnemy(player) and character and humanoid and humanoid.Health > 0 then
            local targetPart = character:FindFirstChild("HumanoidRootPart")
            
            if targetPart then
                local aimPosition = targetPart.Position
                local screenPos, onScreen = Camera:WorldToScreenPoint(aimPosition)

                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < smallestMagnitude then
                        smallestMagnitude = distance
                        bestTarget = { AimPosition = aimPosition }
                    end
                end
            end
        end
    end
    return bestTarget
end

function AdvanceTech:RestoreAppearance()
    for part, transparency in pairs(self.State.Privacy.OriginalTransparencies) do
        if part and part.Parent then
            part.LocalTransparencyModifier = transparency
        end
    end
    self.State.Privacy.OriginalTransparencies = {}
end

function AdvanceTech:ApplyInvisibility()
    local character = LocalPlayer.Character
    if not character then return end

    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            if not self.State.Privacy.OriginalTransparencies[descendant] then
                self.State.Privacy.OriginalTransparencies[descendant] = descendant.LocalTransparencyModifier
            end
            descendant.LocalTransparencyModifier = 1
        end
    end
end

-- Main Tab
local mainTab = win:Tab("Main")
mainTab:Label("> Aimbot / Target Lock")
mainTab:Toggle("Enable Aimbot", AdvanceTech.Settings.Aimbot.Enabled, function(val) AdvanceTech.Settings.Aimbot.Enabled = val end)
mainTab:Slider("FOV Radius", 10, 500, AdvanceTech.Settings.Aimbot.FOV, function(val) AdvanceTech.Settings.Aimbot.FOV = val end)
mainTab:Slider("Aim Smoothing", 1, 50, AdvanceTech.Settings.Aimbot.Smoothing, function(val) AdvanceTech.Settings.Aimbot.Smoothing = val end)
mainTab:Slider("Activation Delay", 0, 50, AdvanceTech.Settings.Aimbot.ActivationDelay * 100, function(val) AdvanceTech.Settings.Aimbot.ActivationDelay = val / 100 end)
mainTab:Dropdown("Team Check", {"FFA", "Team-Based", "Everyone"}, function(val) AdvanceTech.Settings.Aimbot.TeamCheck = val end)
mainTab:Toggle("Show FOV Circle", AdvanceTech.Settings.Aimbot.ShowFOVCircle, function(val) AdvanceTech.Settings.Aimbot.ShowFOVCircle = val end)
mainTab:Label("Hold Right-Click to Activate Aimbot.")
mainTab:Label("Targeting is locked to Body.")

local circle = AdvanceTech.State.UI.FOVCircle
circle.Visible = false; circle.Thickness = 1; circle.Color = Color3.fromRGB(255, 255, 255); circle.Filled = false; circle.NumSides = 64

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        AdvanceTech.State.UI.IsVisible = not AdvanceTech.State.UI.IsVisible
        win.Enabled = AdvanceTech.State.UI.IsVisible
    end
    if input.UserInputType == AdvanceTech.Settings.Aimbot.ActivationKey then
        AdvanceTech.State.Aimbot.IsKeyDown = true
        AdvanceTech.State.Aimbot.KeyDownTimestamp = tick()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AdvanceTech.Settings.Aimbot.ActivationKey then
        AdvanceTech.State.Aimbot.IsKeyDown = false
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    AdvanceTech:RestoreAppearance()
end)

RunService:BindToRenderStep("AdvanceTechRender", Enum.RenderPriority.Camera.Value + 1, function()
    if AdvanceTech.Settings.Privacy.AntiSpectate then
        AdvanceTech:ApplyInvisibility()
    end

    local aimbot = AdvanceTech.Settings.Aimbot
    local aimbotState = AdvanceTech.State.Aimbot

    circle.Visible = aimbot.Enabled and aimbot.ShowFOVCircle and aimbotState.IsKeyDown
    if circle.Visible then
        circle.Position = UserInputService:GetMouseLocation()
        circle.Radius = aimbot.FOV
    end

    if aimbot.Enabled and aimbotState.IsKeyDown and (tick() - aimbotState.KeyDownTimestamp > aimbot.ActivationDelay) then
        local target = AdvanceTech:GetBestTarget()
        if target then
            local targetScreenPos, onScreen = Camera:WorldToScreenPoint(target.AimPosition)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local moveVector = Vector2.new(targetScreenPos.X - mousePos.X, targetScreenPos.Y - mousePos.Y)
                if mousemoverel then
                    mousemoverel(moveVector.X / aimbot.Smoothing, moveVector.Y / aimbot.Smoothing)
                end
            end
        end
    end
end)
