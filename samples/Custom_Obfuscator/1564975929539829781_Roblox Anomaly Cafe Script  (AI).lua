local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local espActive = false
local instantActive = false
local tpWalkActive = false
local tpWalkSpeed = 16
local fullbrightActive = false

local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

local originalPrompts = {}
local highlights = {}
local nameTags = {}
local textLabels = {}

local COLOR_ANOMALY = Color3.fromRGB(255, 30, 30)
local COLOR_NORMAL = Color3.fromRGB(0, 255, 100)
local COLOR_OTHER = Color3.fromRGB(0, 150, 255)

local Window = Rayfield:CreateWindow({
   Name = "Anomaly Cafe Hub",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Theme = "Amber"
})

local MainTab = Window:CreateTab("Main", 4483362458)
local InfoTab = Window:CreateTab("?", 4483362458)

task.spawn(function()
    while true do
        local rayfieldGui = CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
        if rayfieldGui then
            for _, obj in ipairs(rayfieldGui:GetDescendants()) do
                if obj:IsA("Frame") or obj:IsA("TextButton") then
                    if obj.Name == "Selected" or obj.Name == "Indicator" or obj.Name == "Slider" then
                        obj.BackgroundColor3 = Color3.fromRGB(255, 130, 0)
                    end
                elseif obj:IsA("UIStroke") then
                    obj.Color = Color3.fromRGB(255, 130, 0)
                elseif obj:IsA("TextLabel") and (obj.Name == "Title" or obj.Name == "TabTitle") then
                    obj.TextColor3 = Color3.fromRGB(255, 150, 30)
                end
            end
        end
        task.wait(1)
    end
end)

MainTab:CreateToggle({
   Name = "ESP Highlight NPC",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      espActive = Value
      if not Value then
          for _, hl in pairs(highlights) do if hl then hl:Destroy() end end
          for _, tag in pairs(nameTags) do if tag then tag:Destroy() end end
          highlights = {}
          nameTags = {}
          textLabels = {}
      end
   end,
})

MainTab:CreateToggle({
   Name = "Instant Click",
   CurrentValue = false,
   Flag = "InstantToggle",
   Callback = function(Value)
      instantActive = Value
      if not Value then
          for prompt, originalTime in pairs(originalPrompts) do
              if prompt and prompt.Parent then
                  prompt.HoldDuration = originalTime
              end
          end
      end
   end,
})

InfoTab:CreateToggle({
   Name = "Fullbright + No Fog",
   CurrentValue = false,
   Flag = "FullbrightToggle",
   Callback = function(Value)
      fullbrightActive = Value
      if not Value then
          Lighting.Brightness = defaultLighting.Brightness
          Lighting.ClockTime = defaultLighting.ClockTime
          Lighting.GlobalShadows = defaultLighting.GlobalShadows
          Lighting.Ambient = defaultLighting.Ambient
          Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
          Lighting.FogEnd = defaultLighting.FogEnd
          Lighting.FogStart = defaultLighting.FogStart
          
          for _, obj in ipairs(Lighting:GetChildren()) do
              if obj:IsA("Atmosphere") then
                  obj.Density = 0.395
              end
          end
      end
   end,
})

InfoTab:CreateSection("TPWalk")

InfoTab:CreateInput({
   Name = "TPWalk Speed",
   PlaceholderText = "                        Enter Speed Number Here                        ",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
          tpWalkSpeed = num
      end
   end,
})

InfoTab:CreateToggle({
   Name = "Toggle TPWalk",
   CurrentValue = false,
   Flag = "TpWalkToggle",
   Callback = function(Value)
      tpWalkActive = Value
   end,
})

task.spawn(function()
    while true do
        if instantActive then
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    if originalPrompts[prompt] == nil then
                        originalPrompts[prompt] = prompt.HoldDuration
                    end
                    prompt.HoldDuration = 0
                end
            end
        end
        task.wait(1)
    end
end)

RunService.RenderStepped:Connect(function()
    if fullbrightActive then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then
                obj.Density = 0
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(delta)
    if tpWalkActive then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and hrp and humanoid.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * tpWalkSpeed * delta * 2.5)
            end
        end
    end
end)

local function checkNPCColor(model)
    local name = model.Name:lower()

    if name:find("anomaly") or name == "anomaly customer" then
        return COLOR_ANOMALY
    elseif name:find("normal") or name == "normal customer" then
        return COLOR_NORMAL
    end

    return COLOR_OTHER
end

RunService.RenderStepped:Connect(function()
    if not espActive then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
            local color = checkNPCColor(obj)

            if not highlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Adornee = obj
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = color
                hl.OutlineColor = color
                hl.Parent = obj
                highlights[obj] = hl
            else
                highlights[obj].FillColor = color
                highlights[obj].OutlineColor = color
            end

            if not nameTags[obj] then
                local head = obj:FindFirstChild("Head") or obj.PrimaryPart
                if head then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESP_NameTag"
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = head

                    local textLab = Instance.new("TextLabel")
                    textLab.Size = UDim2.new(1, 0, 1, 0)
                    textLab.BackgroundTransparency = 1
                    textLab.Text = obj.Name
                    textLab.TextColor3 = color
                    textLab.TextStrokeTransparency = 0
                    textLab.TextSize = 12
                    textLab.Font = Enum.Font.GothamBold
                    textLab.Parent = billboard

                    nameTags[obj] = billboard
                    textLabels[obj] = textLab
                end
            else
                if textLabels[obj] then
                    textLabels[obj].TextColor3 = color
                end
            end
        end
    end
end)
