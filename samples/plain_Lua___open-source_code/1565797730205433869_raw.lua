local players, runService, userInputService, lighting, virtualUser, tweenService,
  textChatService, replicatedStorage, statsService, localPlayer, currentCamera, color, color2,
  color3, color4, color5, color6, color7, color8, v1, v4, v5, v6, gravity, v7, v8, v9, v10, v11,
  v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, anchored, v23, v24, v25,
  getStateEnabled, v26, v27, v28, v29, v31, v32, v44, v45, connect, bodyVelocity, connect2,
  theLynoxFlyGyro, v63, v64, v80, v83, f2, f3, f4, f5, f6, f7, f8, connect15, f10, connect16,
  f11, f12, f13, v171, v181, v182, v183, v201, v202, v218, v220, mainFrame, v221, v238, v242

players = game:GetService("Players")

runService = game:GetService("RunService")
userInputService = game:GetService("UserInputService")
lighting = game:GetService("Lighting")
virtualUser = game:GetService("VirtualUser")
tweenService = game:GetService("TweenService")
textChatService = game:GetService("TextChatService")
replicatedStorage = game:GetService("ReplicatedStorage")
statsService = game:GetService("Stats")
_G.LynoxPlayerListKickCars = nil
localPlayer = players.LocalPlayer
currentCamera = workspace.CurrentCamera
color = Color3.fromRGB(4, 4, 6)
color2 = Color3.fromRGB(4, 4, 6)
color3 = Color3.fromRGB(4, 4, 6)
color4 = Color3.fromRGB(12, 12, 15)
color5 = Color3.fromRGB(40, 40, 46)
color6 = Color3.fromRGB(225, 225, 233)
color7 = Color3.fromRGB(235, 235, 240)
color8 = Color3.fromRGB(115, 115, 126)
local count = 0
v1 = false
local theLynoxOptionAlerts, v2

local function makeTextLabel(text, text2)
  local playerGui = localPlayer:WaitForChild("PlayerGui")

  if not theLynoxOptionAlerts or not theLynoxOptionAlerts.Parent then
    theLynoxOptionAlerts = Instance.new("ScreenGui")
    theLynoxOptionAlerts.Name = "TheLynoxOptionAlerts"
    theLynoxOptionAlerts.ResetOnSpawn = false
    theLynoxOptionAlerts.IgnoreGuiInset = true
    theLynoxOptionAlerts.DisplayOrder = 10000
    theLynoxOptionAlerts.Parent = playerGui
  end

  count = count + 1
  local v3 = count

  if v2 and v2.Parent then
    v2:Destroy()
  end

  local optionNotification = Instance.new("Frame")
  v2 = optionNotification

  optionNotification.Name = "OptionNotification"
  optionNotification.AnchorPoint = Vector2.new(1, 1)
  optionNotification.Position = UDim2.new(1, 300, 1, -22)
  optionNotification.Size = UDim2.fromOffset(290, 58)
  optionNotification.BackgroundColor3 = color
  optionNotification.BackgroundTransparency = 0.05
  optionNotification.BorderSizePixel = 0
  optionNotification.Parent = theLynoxOptionAlerts

  local uiCorner = Instance.new("UICorner")
  uiCorner.CornerRadius = UDim.new(0, 10)
  uiCorner.Parent = optionNotification

  local uiStroke = Instance.new("UIStroke")
  uiStroke.Color = color5
  uiStroke.Thickness = 1.5
  uiStroke.Transparency = 0.1
  uiStroke.Parent = optionNotification

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(0, 4, 1, -18)
  frame.Position = UDim2.new(0, 7, 0, 7)
  frame.BackgroundColor3 = text2 == "ON" and color6 or color5
  frame.BorderSizePixel = 0
  frame.Parent = optionNotification

  local uiCorner2 = Instance.new("UICorner")
  uiCorner2.CornerRadius = UDim.new(1, 0)
  uiCorner2.Parent = frame

  local textLabel = Instance.new("TextLabel")
  textLabel.BackgroundTransparency = 1
  textLabel.Position = UDim2.new(0, 20, 0, 2)
  textLabel.Size = UDim2.new(1, -28, 1, -14)
  textLabel.Font = Enum.Font.GothamBold
  textLabel.Text = text2 and text .. "  •  " .. text2 or text
  textLabel.TextColor3 = text2 == "ON" and color6 or color7
  textLabel.TextSize = 13
  textLabel.TextWrapped = true
  textLabel.TextXAlignment = Enum.TextXAlignment.Left
  textLabel.Parent = optionNotification

  local progressTrack = Instance.new("Frame")
  progressTrack.Name = "ProgressTrack"
  progressTrack.AnchorPoint = Vector2.new(0, 1)
  progressTrack.Position = UDim2.new(0, 12, 1, -6)
  progressTrack.Size = UDim2.new(1, -24, 0, 3)
  progressTrack.BackgroundColor3 = color2
  progressTrack.BorderSizePixel = 0
  progressTrack.ClipsDescendants = true
  progressTrack.Parent = optionNotification

  local uiCorner3 = Instance.new("UICorner")
  uiCorner3.CornerRadius = UDim.new(1, 0)
  uiCorner3.Parent = progressTrack

  local frame2 = Instance.new("Frame")
  frame2.Size = UDim2.new(1, 0, 1, 0)
  frame2.BackgroundColor3 = color6
  frame2.BorderSizePixel = 0
  frame2.Parent = progressTrack

  local uiCorner4 = Instance.new("UICorner")
  uiCorner4.CornerRadius = UDim.new(1, 0)
  uiCorner4.Parent = frame2

  tweenService:Create(optionNotification, TweenInfo.new(
    0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out
  ), { Position = UDim2.new(1, -18, 1, -22) }):Play()

  tweenService:Create(frame2, TweenInfo.new(5, Enum.EasingStyle.Linear), {
    Size = UDim2.new(0, 0, 1, 0),
  }):Play()

  task.delay(5, function()
    if v3 ~= count or not optionNotification.Parent then
      return
    end

    tweenService:Create(optionNotification, TweenInfo.new(
      0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In
    ), {
      Position = UDim2.new(1, 300, 1, -22),
      BackgroundTransparency = 1,
    }):Play()

    tweenService:Create(textLabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
    tweenService:Create(frame, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    tweenService:Create(progressTrack, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    tweenService:Create(frame2, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    tweenService:Create(uiStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()

    task.delay(0.24, function()
      if optionNotification.Parent then
        optionNotification:Destroy()
      end

      if v2 == optionNotification then
        v2 = nil
      end
    end)
  end)
end

v4 = false
v5 = 50
v6 = 16
gravity = workspace.Gravity
v7 = false
v8 = false
v9 = false
v10 = false
v11 = false
v12 = false
v13 = false
v14 = false

v15 = {
  points = {},
  activeName = nil,
  activeCFrame = nil,
  refresh = nil,
  jumpPower = 50,
}

v16 = false
v17 = false
v18 = 60
v19 = false
v20 = false
v21 = 3
v22 = false
anchored = false
v23 = 0
v24 = 0
v25 = 0

do
  getStateEnabled = true
  v26 = {}
  v27 = {}
  v28 = false
  v29 = false
  local v30 = {}
  v31 = {}
  v32 = {}
  local lynoxVisualOverlay

  function getVisualOverlay()
    if lynoxVisualOverlay and lynoxVisualOverlay.Parent then
      return lynoxVisualOverlay
    else
      local playerGui2 = localPlayer:WaitForChild("PlayerGui")

      lynoxVisualOverlay = Instance.new("ScreenGui")
      lynoxVisualOverlay.Name = "LynoxVisualOverlay"
      lynoxVisualOverlay.ResetOnSpawn = false
      lynoxVisualOverlay.IgnoreGuiInset = true
      lynoxVisualOverlay.DisplayOrder = 1000
      lynoxVisualOverlay.Parent = playerGui2

      return lynoxVisualOverlay
    end
  end

  function getLynoxTeamColor(p1)
    local team = p1.Team

    if team then
      return team.TeamColor.Color
    end

    return p1.TeamColor.Color
  end

  function removeCheatLine(key)
    local v33 = v30[key]

    if v33 then
      v33:Destroy()
      v30[key] = nil
    end
  end

  function createCheatLine(key2)
    if key2 == localPlayer then
      return
    end

    if v30[key2] and v30[key2].Parent then
      return v30[key2]
    else
      local frame3 = Instance.new("Frame")
      frame3.Name = "CheatLine_" .. key2.Name
      frame3.AnchorPoint = Vector2.new(0.5, 0.5)
      frame3.BackgroundColor3 = getLynoxTeamColor(key2)
      frame3.BorderSizePixel = 0
      frame3.Size = UDim2.fromOffset(2, 10)
      frame3.ZIndex = 20
      frame3.Parent = getVisualOverlay()

      local uiCorner5 = Instance.new("UICorner")
      uiCorner5.CornerRadius = UDim.new(1, 0)
      uiCorner5.Parent = frame3

      v30[key2] = frame3
      return frame3
    end
  end

  function updateCheatLine(p2, p3)
    p3.BackgroundColor3 = getLynoxTeamColor(p2)
    local character = p2.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local v34 = not humanoidRootPart
    local currentCamera2 = workspace.CurrentCamera

    if v34 or not currentCamera2 then
      p3.Visible = false
      return
    else
      local v35, v36 = currentCamera2:WorldToViewportPoint(humanoidRootPart.Position)

      if not v36 or v35.Z <= 0 then
        p3.Visible = false
        return
      else
        local viewportSize = currentCamera2.ViewportSize
        local vector = Vector2.new(viewportSize.X * 0.5, viewportSize.Y - 8)
        local vector2 = Vector2.new(v35.X, v35.Y)
        local v37 = vector2 - vector
        local magnitude = v37.Magnitude

        if magnitude < 2 then
          p3.Visible = false
          return
        end

        p3.Visible = true

        p3.Position = UDim2.fromOffset(
          (vector.X + vector2.X) * 0.5, (vector.Y + vector2.Y) * 0.5
        )

        p3.Size = UDim2.fromOffset(2, magnitude)
        p3.Rotation = math.deg(math.atan2(v37.Y, v37.X)) + 90

        return
      end
    end
  end

  function clearCheatLines()
    for key3 in pairs(v30) do
      removeCheatLine(key3)
    end
  end
end

function enableCheatLines()
  v28 = true
  getVisualOverlay()

  for index, value in ipairs(players:GetPlayers()) do
    if value ~= localPlayer then
      createCheatLine(value)
    end
  end
end

function disableCheatLines()
  v28 = false
  clearCheatLines()
end

function toggleCheatLines(fn)
  if v28 then
    disableCheatLines()
  else
    enableCheatLines()
  end

  fn(v28)
end

function removeTracker(key4)
  local v38 = v31[key4]

  if v38 then
    v38:Destroy()
    v31[key4] = nil
  end

  local v39 = v32[key4]

  if v39 then
    v39:Destroy()
    v32[key4] = nil
  end
end

function createTracker(key5)
  if key5 == localPlayer then
    return
  else
    local character2 = key5.Character
    local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

    local head = character2
    head = character2 and character2:FindFirstChild("Head")

    local v40 = not character2
    local v41 = head

    if v40 or not humanoidRootPart2 or not v41 then
      return
    else
      removeTracker(key5)

      local lynoxTracker = Instance.new("Highlight")
      lynoxTracker.Name = "LynoxTracker"
      lynoxTracker.Adornee = character2
      lynoxTracker.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      lynoxTracker.FillColor = getLynoxTeamColor(key5)
      lynoxTracker.FillTransparency = 0.82
      lynoxTracker.OutlineColor = getLynoxTeamColor(key5)
      lynoxTracker.OutlineTransparency = 0
      lynoxTracker.Parent = character2

      v31[key5] = lynoxTracker

      local lynoxTrackerTag = Instance.new("BillboardGui")
      lynoxTrackerTag.Name = "LynoxTrackerTag"
      lynoxTrackerTag.Adornee = v41
      lynoxTrackerTag.Size = UDim2.fromOffset(150, 34)
      lynoxTrackerTag.StudsOffset = Vector3.new(0, 3.1, 0)
      lynoxTrackerTag.AlwaysOnTop = true
      lynoxTrackerTag.Parent = v41

      local textLabel2 = Instance.new("TextLabel")
      textLabel2.Size = UDim2.fromScale(1, 1)
      textLabel2.BackgroundTransparency = 1
      textLabel2.Text = "TRACKER  •  " .. key5.Name
      textLabel2.TextColor3 = getLynoxTeamColor(key5)
      textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      textLabel2.TextStrokeTransparency = 0.15
      textLabel2.Font = Enum.Font.GothamBold
      textLabel2.TextSize = 12
      textLabel2.Parent = lynoxTrackerTag

      v32[key5] = lynoxTrackerTag
      return
    end
  end
end

function updateLynoxTrackerColors()
  if not v29 then
    return
  end

  for key6, value2 in pairs(v31) do
    local character3 = key6.Character

    if not value2.Parent or value2.Adornee ~= character3 then
      if character3 and character3:FindFirstChild("Head")
        and character3:FindFirstChild("HumanoidRootPart") then
        createTracker(key6)
      else
        removeTracker(key6)
      end
    else
      local v42 = getLynoxTeamColor(key6)

      value2.FillColor = v42
      value2.OutlineColor = v42

      local v43 = v32[key6]

      local textLabel3 = v43
      textLabel3 = v43 and v43:FindFirstChildOfClass("TextLabel")

      if textLabel3 then
        textLabel3.TextColor3 = v42
      end
    end
  end
end

runService.RenderStepped:Connect(updateLynoxTrackerColors)

function enableTracker()
  v29 = true

  for index2, value3 in ipairs(players:GetPlayers()) do
    if value3 ~= localPlayer then
      createTracker(value3)
    end
  end
end

function disableTracker()
  v29 = false

  for key7 in pairs(v31) do
    removeTracker(key7)
  end

  for key8 in pairs(v32) do
    removeTracker(key8)
  end
end

function toggleTracker(fn2)
  if v29 then
    disableTracker()
  else
    enableTracker()
  end

  fn2(v29)
end

v44 = false

do
  userInputService.InputBegan:Connect(function(input, p4)
    local character4 = localPlayer.Character
    local humanoid = character4 and character4:FindFirstChildOfClass("Humanoid")
    local vehicleSeat = humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat")

    if p4
      and not (vehicleSeat
        and (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift
          or input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.E
          or input.KeyCode == Enum.KeyCode.Q)) then
      return
    end

    v26[input.KeyCode] = true

    if input.KeyCode == Enum.KeyCode.G and not p4 and not userInputService:GetFocusedTextBox()
      and not vehicleSeat then
      toggleFly(v45)
    end

    if not p4 and (input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.A)
      and connect then
      stopBackstab()
      makeTextLabel("Backstab", "OFF")
    end

    if input.KeyCode == Enum.KeyCode.T and not p4 then
      v19 = not v19

      if v19 then
        startCrawl()
      else
        stopCrawl()
      end
    end
  end)

  userInputService.InputEnded:Connect(function(input2) v26[input2.KeyCode] = false end)

  function getCharacter()
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
  end

  function getMoveDirection()
    local vector3 = Vector3.new(0, 0, 0)
    local cframe = currentCamera.CFrame

    if v26[Enum.KeyCode.W] then
      vector3 = vector3 + cframe.LookVector
    end

    if v26[Enum.KeyCode.S] then
      vector3 = vector3 - cframe.LookVector
    end

    if v26[Enum.KeyCode.A] then
      vector3 = vector3 - cframe.RightVector
    end

    if v26[Enum.KeyCode.D] then
      vector3 = vector3 + cframe.RightVector
    end

    if v26[Enum.KeyCode.Space] then
      vector3 = vector3 + Vector3.new(0, 1, 0)
    end

    if v26[Enum.KeyCode.LeftShift] then
      vector3 = vector3 - Vector3.new(0, 1, 0)
    end

    return vector3
  end

  function startFly(p5)
    local v46 = p5 or getCharacter()
    local humanoid2 = v46:WaitForChild("Humanoid")
    local humanoidRootPart3 = v46:WaitForChild("HumanoidRootPart")

    if theLynoxFlyGyro then
      theLynoxFlyGyro:Destroy()
      theLynoxFlyGyro = nil
    end

    humanoid2.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart3

    theLynoxFlyGyro = Instance.new("BodyGyro")
    theLynoxFlyGyro.Name = "TheLynoxFlyGyro"
    theLynoxFlyGyro.MaxTorque = Vector3.new(10000000, 10000000, 10000000)
    theLynoxFlyGyro.P = 50000
    theLynoxFlyGyro.D = 1000
    theLynoxFlyGyro.Parent = humanoidRootPart3

    connect2 = runService.RenderStepped:Connect(function()
      if not v4 or not bodyVelocity then
        return
      else
        local v47 = bodyVelocity
        local v48 = getMoveDirection()
        v47.Velocity = v48.Magnitude > 0 and v48.Unit * v5 or Vector3.new(0, 0, 0)

        if theLynoxFlyGyro and theLynoxFlyGyro.Parent then
          local currentCamera3 = workspace.CurrentCamera

          if currentCamera3 then
            local lookVector = currentCamera3.CFrame.LookVector
            local vector4 = Vector3.new(lookVector.X, 0, lookVector.Z)

            if vector4.Magnitude > 0.001 then
              theLynoxFlyGyro.CFrame = CFrame.lookAt(
                humanoidRootPart3.Position, humanoidRootPart3.Position + vector4.Unit,
                Vector3.new(0, 1, 0)
              )
            end
          end
        end

        return
      end
    end)
  end

  function stopFly()
    if connect2 then
      connect2:Disconnect()
      connect2 = nil
    end

    if bodyVelocity then
      bodyVelocity:Destroy()
      bodyVelocity = nil
    end

    if theLynoxFlyGyro then
      theLynoxFlyGyro:Destroy()
      theLynoxFlyGyro = nil
    end

    local character5 = localPlayer.Character

    if character5 then
      local humanoid3 = character5:FindFirstChildOfClass("Humanoid")

      if humanoid3 then
        humanoid3.PlatformStand = false
      end
    end
  end

  function toggleFly(p6)
    v4 = not v4

    if v4 then
      startFly()
    else
      stopFly()
    end

    if p6 then
      p6(v4)
    end

    if v45 and v45 ~= p6 then
      v45(v4)
    end
  end

  function getVehiclePart(p7)
    if not p7 or not p7:IsA("BasePart") then
      return nil
    else
      local assemblyRootPart = p7.AssemblyRootPart

      if assemblyRootPart and assemblyRootPart:IsA("BasePart") then
        return assemblyRootPart
      else
        local model = p7:FindFirstAncestorOfClass("Model")

        if model and model.PrimaryPart then
          return model.PrimaryPart
        end

        return p7
      end
    end
  end

  local v49, connect3

  function startVehicleFly()
    local character6 = localPlayer.Character
    local humanoid4 = character6 and character6:FindFirstChildOfClass("Humanoid")
    local v50, v51

    if not humanoid4 then
      return
    else
      local seatPart = humanoid4.SeatPart

      if not seatPart or not seatPart:IsA("VehicleSeat") then
        return
      end

      v50 = getVehiclePart(seatPart)

      if not v50 then
        return
      end

      if connect3 then
        connect3:Disconnect()
        connect3 = nil
      end

      v49 = v50
      v51 = math.atan2(-v50.CFrame.LookVector.X, -v50.CFrame.LookVector.Z)

      connect3 = runService.RenderStepped:Connect(function(delta)
        if not v17 then
          return
        else
          local character7 = localPlayer.Character
          local humanoid5 = character7 and character7:FindFirstChildOfClass("Humanoid")
          local seatPart2 = humanoid5 and humanoid5.SeatPart

          if not seatPart2 or not seatPart2:IsA("VehicleSeat") then
            stopVehicleFly()
            return
          else
            local v52 = getVehiclePart(seatPart2)

            if not v52 or not v52.Parent then
              stopVehicleFly()
              return
            else
              v50 = v52
              v49 = v52
              local cframe2 = currentCamera.CFrame
              local lookVector2 = cframe2.LookVector
              local vector5 = Vector3.new(cframe2.RightVector.X, 0, cframe2.RightVector.Z)

              if lookVector2.Magnitude > 0.001 then
                lookVector2 = lookVector2.Unit
              end

              if vector5.Magnitude > 0.001 then
                vector5 = vector5.Unit
              end

              local vector6 = Vector3.new(0, 0, 0)

              if v26[Enum.KeyCode.W] then
                vector6 = vector6 + lookVector2
              end

              if v26[Enum.KeyCode.S] then
                vector6 = vector6 - lookVector2
              end

              if v26[Enum.KeyCode.A] then
                vector6 = vector6 + Vector3.new(-vector5.X, 0, -vector5.Z)
              end

              if v26[Enum.KeyCode.D] then
                vector6 = vector6 + vector5
              end

              local v53 = 0

              if v26[Enum.KeyCode.Space] or v26[Enum.KeyCode.E] then
                v53 = v53 + 1
              end

              if v26[Enum.KeyCode.LeftShift] or v26[Enum.KeyCode.RightShift]
                or v26[Enum.KeyCode.Q] then
                v53 = v53 - 1
              end

              if vector6.Magnitude > 0.001 then
                vector6 = vector6.Unit
                v51 = math.atan2(-vector6.X, -vector6.Z)
              end

              local vector7 = Vector3.new(0, v53 * v18, 0)
              v52.AssemblyLinearVelocity = vector6 * v18 + vector7
              local cframe3 = CFrame.new(v52.Position)
              local cframe4 = CFrame.Angles(0, v51, 0)

              v52.CFrame = v52.CFrame:Lerp(cframe3 * cframe4, math.clamp(delta * 10, 0, 1))
              v52.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

              return
            end
          end
        end
      end)

      return
    end
  end

  function stopVehicleFly()
    if connect3 then
      connect3:Disconnect()
      connect3 = nil
    end

    if v49 and v49:IsA("BasePart") then
      v49.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
      v49.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    v49 = nil
  end
end

do
  local connect4

  function watchVehicleSeat(p8)
    local humanoid6 = p8:WaitForChild("Humanoid")

    if connect4 then
      connect4:Disconnect()
      connect4 = nil
    end

    connect4 = humanoid6.Seated:Connect(function(p9, p10)
      if not v17 then
        stopVehicleFly()
        return
      end

      if p9 and p10 and p10:IsA("VehicleSeat") then
        task.defer(startVehicleFly)
      else
        stopVehicleFly()
      end
    end)
  end

  function toggleVehicleFly(fn3)
    v17 = not v17

    if v17 then
      startVehicleFly()
    else
      stopVehicleFly()
    end

    fn3(v17)
  end

  local connect5

  function startCrawl()
    local v54 = getCharacter()
    v54:WaitForChild("Humanoid").AutoRotate = false

    connect5 = runService.Heartbeat:Connect(function()
      if not v19 then
        return
      else
        local character8 = localPlayer.Character

        if not character8 then
          return
        else
          local humanoidRootPart4 = character8:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart4 then
            return
          else
            local assemblyLinearVelocity = humanoidRootPart4.AssemblyLinearVelocity
            local v55 = { humanoidRootPart4.CFrame:ToEulerAnglesYXZ() }
            local vector8 = Vector3.new(0, 2, 0)

            humanoidRootPart4.CFrame = CFrame.new(humanoidRootPart4.Position - vector8)
              * CFrame.Angles(math.rad(-90), v55[2], 0)

            humanoidRootPart4.AssemblyLinearVelocity = Vector3.new(
              assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z
            )

            return
          end
        end
      end
    end)
  end

  function stopCrawl()
    if connect5 then
      connect5:Disconnect()
      connect5 = nil
    end

    local character9 = localPlayer.Character

    if character9 then
      local humanoid7 = character9:FindFirstChildOfClass("Humanoid")

      if humanoid7 then
        humanoid7.AutoRotate = true
      end

      local humanoidRootPart5 = character9:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart5 then
        local v56 = { humanoidRootPart5.CFrame:ToEulerAnglesYXZ() }

        humanoidRootPart5.CFrame = CFrame.new(humanoidRootPart5.Position + Vector3.new(0, 2, 0))
          * CFrame.Angles(0, v56[2], 0)
      end
    end
  end

  function toggleCrawl(fn4)
    v19 = not v19

    if v19 then
      startCrawl()
    else
      stopCrawl()
    end

    fn4(v19)
  end

  function getFlatMoveDirection()
    local cframe5 = currentCamera.CFrame
    local vector9 = Vector3.new(cframe5.LookVector.X, 0, cframe5.LookVector.Z)

    if vector9.Magnitude > 0 then
      vector9 = vector9.Unit
    end

    local vector10 = Vector3.new(cframe5.RightVector.X, 0, cframe5.RightVector.Z)

    if vector10.Magnitude > 0 then
      vector10 = vector10.Unit
    end

    local vector11 = Vector3.new(0, 0, 0)

    if v26[Enum.KeyCode.W] then
      vector11 = vector11 + vector9
    end

    if v26[Enum.KeyCode.S] then
      vector11 = vector11 - vector9
    end

    if v26[Enum.KeyCode.A] then
      vector11 = vector11 - vector10
    end

    if v26[Enum.KeyCode.D] then
      vector11 = vector11 + vector10
    end

    return vector11
  end

  function getSurfaceY(p11, p12, p13, p14)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = { p11 }
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycast = workspace:Raycast(p12, p13, raycastParams)
    return raycast and raycast.Position.Y or p14
  end

  local connect6

  function startCeilingWalk()
    local v57 = getCharacter()
    local humanoid8 = v57:WaitForChild("Humanoid")
    local humanoidRootPart6 = v57:WaitForChild("HumanoidRootPart")
    v22 = false

    humanoid8.Sit = false
    humanoid8.AutoRotate = false
    humanoid8.PlatformStand = true

    anchored = humanoidRootPart6.Anchored
    humanoidRootPart6.Anchored = true

    if connect6 then
      connect6:Disconnect()
      connect6 = nil
    end

    connect6 = runService.Heartbeat:Connect(function(delta2)
      local v58

      if not v20 then
        return
      else
        local character10 = localPlayer.Character

        if not character10 or not character10.Parent then
          return
        else
          local humanoidRootPart7 = character10:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart7 then
            return
          else
            local v59 = getFlatMoveDirection()
            local position = humanoidRootPart7.Position
            local z = position.Z
            local x = position.X
            local lookVector3 = currentCamera.CFrame.LookVector
            local vector12 = Vector3.new(lookVector3.X, 0, lookVector3.Z)

            if vector12.Magnitude > 0.001 then
              local unit = vector12.Unit
              v58 = math.atan2(-unit.X, -unit.Z)
            else
              v557, v58, v558 = humanoidRootPart7.CFrame:ToEulerAnglesYXZ()
            end

            if v59.Magnitude > 0.05 then
              local unit2 = v59.Unit
              x = x + unit2.X * v6 * math.min(delta2, 0.033333333333333)
              z = z + unit2.Z * v6 * math.min(delta2, 0.033333333333333)
            end

            local v60 = getSurfaceY(
              character10, Vector3.new(x, position.Y + 2, z), Vector3.new(0, 100, 0),
              position.Y + v21
            )

            local vector13 = Vector3.new(x, v60 - v21, z)

            humanoidRootPart7.CFrame = CFrame.new(vector13)
              * CFrame.Angles(math.rad(180), v58, 0)

            humanoidRootPart7.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart7.AssemblyAngularVelocity = Vector3.zero

            return
          end
        end
      end
    end)
  end

  function stopCeilingWalk()
    if connect6 then
      connect6:Disconnect()
      connect6 = nil
    end

    local character11 = localPlayer.Character

    if character11 then
      local humanoid9 = character11:FindFirstChildOfClass("Humanoid")

      if humanoid9 then
        humanoid9.AutoRotate = true
        humanoid9.PlatformStand = false
        humanoid9:ChangeState(Enum.HumanoidStateType.GettingUp)
      end

      local humanoidRootPart8 = character11:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart8 then
        humanoidRootPart8.Anchored = anchored
        local v61 = { humanoidRootPart8.CFrame:ToEulerAnglesYXZ() }

        local v62 = getSurfaceY(character11, Vector3.new(
          humanoidRootPart8.Position.X, humanoidRootPart8.Position.Y + 5,
          humanoidRootPart8.Position.Z
        ), Vector3.new(0, -100, 0), humanoidRootPart8.Position.Y - v21)

        humanoidRootPart8.CFrame = CFrame.new(
          humanoidRootPart8.Position.X, v62 + 3, humanoidRootPart8.Position.Z
        ) * CFrame.Angles(0, v61[2], 0)

        humanoidRootPart8.AssemblyLinearVelocity = Vector3.zero
        humanoidRootPart8.AssemblyAngularVelocity = Vector3.zero
      end
    end
  end
end

do
  function toggleSit(fn5)
    v22 = not v22
    local humanoid10 = getCharacter():FindFirstChildOfClass("Humanoid")

    if v22 then
      if v20 then
        v20 = false
        stopCeilingWalk()
      end

      if v63 then
        v63:Stop()
        v63 = nil
        v64 = nil
      end

      if humanoid10 then
        humanoid10.PlatformStand = false
        humanoid10.AutoRotate = true
        humanoid10.Sit = true
        humanoid10:ChangeState(Enum.HumanoidStateType.Seated)
      end
    elseif humanoid10 then
      humanoid10.Sit = false
      humanoid10:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    fn5(v22)
  end

  function toggleCeilingWalk(fn6)
    v20 = not v20

    if v20 then
      startCeilingWalk()
    else
      stopCeilingWalk()
    end

    fn6(v20)
  end

  local v65 = false
  local v66 = 0
  local v67 = math.rad(-90)
  local connect7, v68

  function startSideWalk()
    local v69 = getCharacter()
    local humanoid11 = v69:WaitForChild("Humanoid")
    local humanoidRootPart9 = v69:WaitForChild("HumanoidRootPart")

    humanoid11.AutoRotate = false
    humanoid11.PlatformStand = false
    humanoid11:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

    local v70, v71, v72 = humanoidRootPart9.CFrame:ToEulerAnglesYXZ()
    v66 = v71

    local animation = Instance.new("Animation")

    animation.AnimationId = "rbxassetid://"
      .. tostring(humanoid11.RigType == Enum.HumanoidRigType.R15 and 507777826 or 180426354)

    local v73, v74 = pcall(function() return humanoid11:LoadAnimation(animation) end)

    if v73 and v74 then
      v74.Priority = Enum.AnimationPriority.Action
      v74.Looped = true
      v68 = v74
    end

    runService:UnbindFromRenderStep("LynGUI_SideWalkCameraUpright")

    runService:BindToRenderStep("LynGUI_SideWalkCameraUpright", Enum.RenderPriority.Camera.Value + 1, function()
      if not v65 then
        return
      else
        local currentCamera4 = workspace.CurrentCamera

        if not currentCamera4 then
          return
        else
          local lookVector4 = currentCamera4.CFrame.LookVector

          if lookVector4.Magnitude > 0.001 then
            currentCamera4.CFrame = CFrame.lookAt(
              currentCamera4.CFrame.Position, currentCamera4.CFrame.Position + lookVector4,
              Vector3.yAxis
            )
          end

          return
        end
      end
    end)

    connect7 = runService.Heartbeat:Connect(function(delta3)
      if not v65 then
        return
      else
        local character12 = localPlayer.Character
        local humanoid12 = character12 and character12:FindFirstChildOfClass("Humanoid")

        local humanoidRootPart10 = character12
        humanoidRootPart10 = character12 and character12:FindFirstChild("HumanoidRootPart")

        local v75 = not humanoid12
        local v76 = humanoidRootPart10

        if v75 or not v76 then
          return
        else
          local unit3 = getFlatMoveDirection()
          local v77 = unit3.Magnitude > 0.05
          local x2 = v76.Position.X
          local z2 = v76.Position.Z

          if v77 then
            unit3 = unit3.Unit
            x2 = x2 + unit3.X * v6 * delta3
            z2 = z2 + unit3.Z * v6 * delta3
            v66 = math.atan2(-unit3.X, -unit3.Z)
          end

          local assemblyLinearVelocity2 = v76.AssemblyLinearVelocity

          local v78 = getSurfaceY(
            character12, Vector3.new(x2, v76.Position.Y + 3, z2), Vector3.new(0, -100, 0),
            v76.Position.Y - 1.4
          )

          local v79 = humanoid12.FloorMaterial ~= Enum.Material.Air
          local y = v76.Position.Y

          if v79 and assemblyLinearVelocity2.Y <= 1 then
            y = v78 + 1.4
          end

          local vector14 = Vector3.new(x2, y, z2)

          v76.CFrame = CFrame.new(vector14) * CFrame.Angles(0, v66, 0)
            * CFrame.Angles(math.rad(-90), 0, 0) * CFrame.Angles(0, v67, 0)

          v76.AssemblyLinearVelocity = Vector3.new(
            unit3.X * v6, assemblyLinearVelocity2.Y, unit3.Z * v6
          )

          v76.AssemblyAngularVelocity = Vector3.zero

          if v68 then
            if v77 and not v68.IsPlaying then
              v68:Play(0.1, 1, 1.2)
            elseif not v77 and v68.IsPlaying then
              v68:Stop(0.1)
            end
          end

          return
        end
      end
    end)
  end

  function stopSideWalk()
    if connect7 then
      connect7:Disconnect()
      connect7 = nil
    end

    runService:UnbindFromRenderStep("LynGUI_SideWalkCameraUpright")

    if v68 then
      v68:Stop()
      v68:Destroy()
      v68 = nil
    end

    local character13 = localPlayer.Character

    if character13 then
      local humanoid13 = character13:FindFirstChildOfClass("Humanoid")

      if humanoid13 then
        humanoid13.AutoRotate = true
        humanoid13.PlatformStand = false
      end

      local humanoidRootPart11 = character13:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart11 then
        humanoidRootPart11.CFrame = CFrame.new(humanoidRootPart11.Position + Vector3.new(0, 2, 0))
          * CFrame.Angles(0, v66, 0)

        humanoidRootPart11.AssemblyLinearVelocity = Vector3.zero
        humanoidRootPart11.AssemblyAngularVelocity = Vector3.zero
      end
    end
  end

  function toggleSideWalk(fn7)
    v65 = not v65

    if v65 then
      startSideWalk()
    else
      stopSideWalk()
    end

    fn7(v65)
  end

  localPlayer.CharacterAdded:Connect(function()
    if v65 then
      task.wait(0.5)

      if connect7 then
        connect7:Disconnect()
        connect7 = nil
      end

      runService:UnbindFromRenderStep("LynGUI_SideWalkCameraUpright")
      v68 = nil
      startSideWalk()
    end
  end)

  function playFireEffect(index3, index4)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(34, 211, 238)

    local magnitude2 = (index4 - index3).Magnitude

    part.Size = Vector3.new(0.3, 0.3, magnitude2)
    part.CFrame = CFrame.new(index3, index4) * CFrame.new(0, 0, -magnitude2 / 2)
    part.Parent = workspace

    tweenService:Create(part, TweenInfo.new(0.25), { Transparency = 1 }):Play()
    task.delay(0.25, function() part:Destroy() end)
  end
end

do
  function updateStatsLabel()
    if v80 then
      v80.Text = string.format("Tirs réussis: %d\nDégâts totaux: %d", v24, v25)
    end
  end

  local waitForChild

  task.spawn(function()
    waitForChild = replicatedStorage:WaitForChild("TheLynoxFireAbility", 15)

    if waitForChild then
      waitForChild.OnClientEvent:Connect(function(p15, index5, p16, p17, p18)
        if p15 == "hit" then
          v24 = v24 + 1
          v25 = v25 + index5
          updateStatsLabel()
          playFireEffect(p17, p18)
        elseif p15 == "hurt" then
          playFireEffect(p17, p18)
        end
      end)
    end
  end)

  function fireAtPlayer(p19)
    if not waitForChild then
      return
    else
      local v81 = os.clock()

      if v81 - v23 < 4 then
        return
      end

      v23 = v81
      waitForChild:FireServer(p19)
      return
    end
  end

  local v82 = false
  v83 = 30
  local v84 = 0

  function getNearestPlayerInRange(p20)
    local character14 = localPlayer.Character
    local humanoidRootPart12 = character14 and character14:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart12 then
      return nil
    else
      local v85 = p20
      local v86 = nil

      for index6, value4 in ipairs(players:GetPlayers()) do
        if value4 ~= localPlayer then
          local character15 = value4.Character

          local humanoidRootPart13 = character15
          humanoidRootPart13 = character15 and character15:FindFirstChild("HumanoidRootPart")

          local humanoid14 = character15
          humanoid14 = character15 and character15:FindFirstChildOfClass("Humanoid")

          if humanoidRootPart13 and humanoid14 and humanoid14.Health > 0 then
            local magnitude3 = (humanoidRootPart13.Position
              - humanoidRootPart12.Position).Magnitude

            if magnitude3 <= v85 then
              v85 = magnitude3
              v86 = value4
            end
          end
        end
      end

      return v86
    end
  end

  function getWeaponTool()
    local character16 = localPlayer.Character

    if not character16 then
      return nil
    else
      for index7, value5 in ipairs(character16:GetChildren()) do
        if value5:IsA("Tool") and value5.Name ~= "TPLynox" then
          return value5
        end
      end

      local backpack = localPlayer:FindFirstChildOfClass("Backpack")

      if backpack then
        for index8, value6 in ipairs(backpack:GetChildren()) do
          if value6:IsA("Tool") and value6.Name ~= "TPLynox" then
            return value6
          end
        end

        return nil
      end

      return nil
    end
  end

  function killAuraShoot(p21)
    local character17 = localPlayer.Character
    local humanoid15 = character17 and character17:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart14 = character17 and character17:FindFirstChild("HumanoidRootPart")
    local character18 = p21.Character
    local humanoidRootPart15 = character18 and character18:FindFirstChild("HumanoidRootPart")

    if not humanoid15 or not humanoidRootPart14 or not humanoidRootPart15
      or humanoid15.Health <= 0 then
      return
    else
      local v87 = getWeaponTool()

      if not v87 then
        return
      elseif v87.Parent ~= character17 then
        humanoid15:EquipTool(v87)
        return
      else
        local vector15 = Vector3.new(
          humanoidRootPart15.Position.X, humanoidRootPart14.Position.Y,
          humanoidRootPart15.Position.Z
        )

        if (vector15 - humanoidRootPart14.Position).Magnitude > 0.1 then
          humanoidRootPart14.CFrame = CFrame.lookAt(humanoidRootPart14.Position, vector15)
        end

        v87:Activate()
        return
      end
    end
  end

  local connect8

  function stopKillAura()
    if connect8 then
      connect8:Disconnect()
      connect8 = nil
    end
  end

  function startKillAura()
    stopKillAura()
    v84 = 0

    connect8 = runService.Heartbeat:Connect(function(delta4)
      if not v82 then
        return
      end

      v84 = v84 + delta4

      if v84 < 0.25 then
        return
      else
        v84 = 0
        local v88 = getNearestPlayerInRange(v83)

        if v88 then
          killAuraShoot(v88)
        end

        return
      end
    end)
  end

  function toggleKillAura(fn8)
    v82 = not v82

    if v82 then
      startKillAura()
    else
      stopKillAura()
    end

    fn8(v82)
  end
end

do
  function playEmote(p22, p23, backgroundColor3, backgroundColor32)
    local humanoid16 = getCharacter():WaitForChild("Humanoid")

    if v63 then
      v63:Stop()
    end

    if v64 then
      v64.BackgroundColor3 = backgroundColor3
    end

    local animation2

    if v64 == p23 then
      v63 = nil
      v64 = nil
      return
    else
      animation2 = Instance.new("Animation")
      animation2.AnimationId = "rbxassetid://" .. p22.id

      local v89, v90 = pcall(function() return humanoid16:LoadAnimation(animation2) end)

      if not v89 or not v90 then
        return
      end

      v90.Priority = Enum.AnimationPriority.Action
      v90.Looped = p22.looped ~= false
      v90:Play(0.1, 1, p22.speed)

      v63 = v90
      v64 = p23
      p23.BackgroundColor3 = backgroundColor32
      return
    end
  end

  function setWalkSpeed(p24)
    v6 = math.clamp(p24, 1, 200)
    return v6
  end

  function setGravity(p25)
    gravity = math.clamp(p25, 0, 500)
    workspace.Gravity = gravity
    return gravity
  end

  runService.Heartbeat:Connect(function()
    local character19 = localPlayer.Character
    local humanoid17 = character19 and character19:FindFirstChildOfClass("Humanoid")

    if humanoid17 then
      if humanoid17.WalkSpeed ~= v6 then
        humanoid17.WalkSpeed = v6
      end

      humanoid17.UseJumpPower = true

      if humanoid17.JumpPower ~= v15.jumpPower then
        humanoid17.JumpPower = v15.jumpPower
      end
    end
  end)

  local connect9

  function toggleInfiniteJump(fn9)
    v7 = not v7

    if v7 then
      connect9 = userInputService.JumpRequest:Connect(function()
        local character20 = localPlayer.Character
        local humanoid18 = character20 and character20:FindFirstChildOfClass("Humanoid")

        if humanoid18 then
          humanoid18:ChangeState(Enum.HumanoidStateType.Jumping)
        end
      end)
    elseif connect9 then
      connect9:Disconnect()
      connect9 = nil
    end

    fn9(v7)
  end

  local v91 = false
  local theLynoxFloatAttachment, theLynoxFloatForce

  function stopFloatForce()
    if theLynoxFloatForce then
      theLynoxFloatForce:Destroy()
      theLynoxFloatForce = nil
    end

    if theLynoxFloatAttachment then
      theLynoxFloatAttachment:Destroy()
      theLynoxFloatAttachment = nil
    end

    if v91 then
      v91 = false
      local character21 = localPlayer.Character

      local humanoid19 = character21
      humanoid19 = character21 and character21:FindFirstChildOfClass("Humanoid")

      if humanoid19 then
        humanoid19.AutoRotate = true
      end
    end
  end

  local y2

  function startFloatHold(p26, p27)
    if v10 or not v8 then
      return
    else
      y2 = p27.Position.Y
      v10 = true
      stopFloatForce()

      theLynoxFloatAttachment = Instance.new("Attachment")
      theLynoxFloatAttachment.Name = "TheLynoxFloatAttachment"
      theLynoxFloatAttachment.Parent = p27

      theLynoxFloatForce = Instance.new("VectorForce")
      theLynoxFloatForce.Name = "TheLynoxFloatForce"
      theLynoxFloatForce.Attachment0 = theLynoxFloatAttachment
      theLynoxFloatForce.RelativeTo = Enum.ActuatorRelativeTo.World
      theLynoxFloatForce.ApplyAtCenterOfMass = true
      theLynoxFloatForce.Parent = p27

      getStateEnabled = p26:GetStateEnabled(Enum.HumanoidStateType.Freefall)

      p26:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
      p26:ChangeState(Enum.HumanoidStateType.Running)
      p26.AutoRotate = false

      v91 = true
      local assemblyLinearVelocity3 = p27.AssemblyLinearVelocity

      p27.AssemblyLinearVelocity = Vector3.new(
        assemblyLinearVelocity3.X, 0, assemblyLinearVelocity3.Z
      )

      return
    end
  end

  local connect10, connect11

  function stopFloat()
    if connect11 then
      connect11:Disconnect()
      connect11 = nil
    end

    if connect10 then
      connect10:Disconnect()
      connect10 = nil
    end

    stopFloatForce()
    local character22 = localPlayer.Character

    local humanoid20 = character22
    humanoid20 = character22 and character22:FindFirstChildOfClass("Humanoid")

    if humanoid20 then
      humanoid20:SetStateEnabled(Enum.HumanoidStateType.Freefall, getStateEnabled)
    end

    v9 = false
    v10 = false
    y2 = nil
  end

  function startFloat()
    stopFloat()

    if not v8 then
      return
    end

    v9 = false
    v10 = false
    y2 = nil

    connect11 = userInputService.JumpRequest:Connect(function()
      if not v8 or v4 or v17 then
        return
      else
        local character23 = localPlayer.Character
        local humanoid21 = character23 and character23:FindFirstChildOfClass("Humanoid")

        local humanoidRootPart16 = character23
          and character23:FindFirstChild("HumanoidRootPart")

        if not humanoid21 or not humanoidRootPart16 then
          return
        end

        if v10 then
          v10 = false
          v9 = true
          y2 = nil
          stopFloatForce()
          humanoid21:SetStateEnabled(Enum.HumanoidStateType.Freefall, getStateEnabled)
          local assemblyLinearVelocity4 = humanoidRootPart16.AssemblyLinearVelocity

          humanoidRootPart16.AssemblyLinearVelocity = Vector3.new(
            assemblyLinearVelocity4.X, math.max(v15.jumpPower, 1), assemblyLinearVelocity4.Z
          )

          humanoid21:ChangeState(Enum.HumanoidStateType.Jumping)
        else
          v9 = true
        end

        return
      end
    end)

    connect10 = runService.Heartbeat:Connect(function()
      if not v8 then
        return
      else
        local character24 = localPlayer.Character
        local humanoid22 = character24 and character24:FindFirstChildOfClass("Humanoid")

        local humanoidRootPart17 = character24
          and character24:FindFirstChild("HumanoidRootPart")

        if not humanoid22 or not humanoidRootPart17 then
          return
        end

        if v4 or v17 then
          v9 = false
          v10 = false
          y2 = nil
          stopFloatForce()
          humanoid22:SetStateEnabled(Enum.HumanoidStateType.Freefall, getStateEnabled)
          return
        else
          local getState = humanoid22:GetState()
          local assemblyLinearVelocity5 = humanoidRootPart17.AssemblyLinearVelocity

          if v9 and not v10 and assemblyLinearVelocity5.Y <= 0
            and getState ~= Enum.HumanoidStateType.Landed
            and getState ~= Enum.HumanoidStateType.Running then
            startFloatHold(humanoid22, humanoidRootPart17)
            return
          elseif v10 then
            if not theLynoxFloatForce or not theLynoxFloatForce.Parent then
              startFloatHold(humanoid22, humanoidRootPart17)
              return
            else
              theLynoxFloatForce.Force = Vector3.new(0, humanoidRootPart17.AssemblyMass
                * workspace.Gravity, 0)

              if humanoid22:GetState() ~= Enum.HumanoidStateType.Running then
                humanoid22:ChangeState(Enum.HumanoidStateType.Running)
              end

              local moveDirection = humanoid22.MoveDirection
              local v92 = y2 - humanoidRootPart17.Position.Y
              local v93 = 0

              if math.abs(v92) > 0.15 then
                v93 = math.clamp(v92 * 8, -6, 6)
              end

              humanoidRootPart17.AssemblyLinearVelocity = Vector3.new(moveDirection.X
                * humanoid22.WalkSpeed, v93, moveDirection.Z
                * humanoid22.WalkSpeed)

              humanoidRootPart17.AssemblyAngularVelocity = Vector3.zero

              local vector16 = Vector3.new(moveDirection.X, 0, moveDirection.Z)

              if vector16.Magnitude > 0.1 then
                local cframe6 = CFrame.lookAt(
                  humanoidRootPart17.Position, humanoidRootPart17.Position + vector16.Unit
                )

                humanoidRootPart17.CFrame = humanoidRootPart17.CFrame:Lerp(cframe6, 0.25)
              end

              return
            end
          elseif getState == Enum.HumanoidStateType.Landed then
            v9 = false
            y2 = nil
            stopFloatForce()
          end
        end
      end
    end)
  end
end

do
  function toggleFloat(fn10)
    v8 = not v8

    if v8 then
      startFloat()
    else
      stopFloat()
    end

    fn10(v8)
  end

  local v94 = {}

  function setNoclipOnCharacter(p28, p29)
    if not p28 then
      return
    end

    for index9, value7 in ipairs(p28:GetDescendants()) do
      if value7:IsA("BasePart") then
        if p29 then
          if v94[value7] == nil then
            v94[value7] = value7.CanCollide
          end

          value7.CanCollide = false
        elseif v94[value7] ~= nil then
          value7.CanCollide = v94[value7]
          v94[value7] = nil
        end
      end
    end
  end

  local connect12, connect13

  function startNoclip()
    pcall(function()
      local scripts = replicatedStorage:FindFirstChild("Scripts")
      local characterCollision = scripts and scripts:FindFirstChild("CharacterCollision")

      if characterCollision then
        characterCollision:Destroy()
      end

      if type(getconnections) == "function" then
        local character25 = localPlayer.Character
        local head2 = character25 and character25:FindFirstChild("Head")

        if head2 then
          for index10, value8 in ipairs(getconnections(head2:GetPropertyChangedSignal("CanCollide"))) do
            local v95 = value8
            pcall(function() v95:Disable() end)
          end
        end
      end
    end)

    if connect12 then
      connect12:Disconnect()
      connect12 = nil
    end

    if connect13 then
      connect13:Disconnect()
      connect13 = nil
    end

    local function f1()
      if v14 then
        setNoclipOnCharacter(localPlayer.Character, true)
      end
    end

    f1()

    if runService.PreSimulation then
      connect12 = runService.PreSimulation:Connect(f1)
    else
      connect12 = runService.Stepped:Connect(f1)
    end

    connect13 = runService.Heartbeat:Connect(f1)
  end

  function stopNoclip()
    if connect12 then
      connect12:Disconnect()
      connect12 = nil
    end

    if connect13 then
      connect13:Disconnect()
      connect13 = nil
    end

    for key9, value9 in pairs(v94) do
      if key9.Parent then
        key9.CanCollide = value9
      end

      v94[key9] = nil
    end
  end

  function toggleNoclip(p30)
    v14 = not v14

    if v14 then
      startNoclip()
    else
      stopNoclip()
    end

    if p30 then
      p30(v14)
    end
  end

  function teleportToPlayer(p31)
    local humanoidRootPart18 = getCharacter():WaitForChild("HumanoidRootPart")
    local character26 = p31.Character
    local humanoidRootPart19 = character26 and character26:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart19 then
      humanoidRootPart18.CFrame = humanoidRootPart19.CFrame + Vector3.new(3, 0, 0)
    end
  end

  function teleportToCoordinates(p32, p33, p34)
    local v96 = getCharacter()
    v96:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(p32, p33, p34)
  end

  local connect14

  function stopClickTeleport()
    if connect14 then
      connect14:Disconnect()
      connect14 = nil
    end
  end

  function startClickTeleport()
    stopClickTeleport()

    connect14 = userInputService.InputBegan:Connect(function(input3, p35)
      if not v44 then
        return
      elseif p35 then
        return
      elseif input3.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
      else
        local unitRay = localPlayer:GetMouse().UnitRay
        local character27 = localPlayer.Character

        local humanoidRootPart20 = character27
          and character27:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart20 then
          return
        else
          local raycastParams2 = RaycastParams.new()
          raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
          raycastParams2.FilterDescendantsInstances = { character27 }

          local raycast2 = workspace:Raycast(
            unitRay.Origin, unitRay.Direction * 5000, raycastParams2
          )

          if not raycast2 then
            return
          end

          humanoidRootPart20.CFrame = CFrame.lookAt(
            raycast2.Position + raycast2.Normal * 3, raycast2.Position
          )

          humanoidRootPart20.AssemblyLinearVelocity = Vector3.zero
          humanoidRootPart20.AssemblyAngularVelocity = Vector3.zero

          return
        end
      end
    end)
  end
end

function toggleClickTeleport(fn11)
  v44 = not v44

  if v44 then
    startClickTeleport()
  else
    stopClickTeleport()
  end

  fn11(v44)
end

function jumpOnPlayer(p36)
  f8()

  if connect15 then
    connect15:Disconnect()
    connect15 = nil
  end

  f7()
  f2()
  f3()
  f4()
  f5()
  f6()
  local v97 = getCharacter()
  local humanoidRootPart21 = v97:WaitForChild("HumanoidRootPart")
  v97:WaitForChild("Humanoid").AutoRotate = true
  local v98 = os.clock()

  connect15 = runService.RenderStepped:Connect(function()
    if os.clock() - v98 > 2 then
      if connect15 then
        connect15:Disconnect()
        connect15 = nil
      end

      return
    else
      local character28 = p36.Character
      local head3 = character28 and character28:FindFirstChild("Head")

      if not head3 then
        if connect15 then
          connect15:Disconnect()
          connect15 = nil
        end

        return
      else
        local v99 = os.clock()
        local v100 = math.abs(math.sin((v99 - v98) * 8))
        humanoidRootPart21.CFrame = CFrame.new(head3.Position + Vector3.new(0, 4 + v100 * 3, 0))
        return
      end
    end
  end)
end

local function f9()
  if connect15 then
    connect15:Disconnect()
    connect15 = nil
  end
end

do
  local v101 = nil

  function f10()
    if connect16 then
      connect16:Disconnect()
      connect16 = nil
    end

    if v101 then
      v101:Stop()
      v101 = nil
    end

    local character29 = localPlayer.Character

    local humanoid23 = character29
    humanoid23 = character29 and character29:FindFirstChildOfClass("Humanoid")

    if humanoid23 then
      humanoid23.AutoRotate = true
    end
  end

  function blockAndDance(p37)
    f8()
    f10()
    f7()
    f9()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v102 = getCharacter()
    local humanoidRootPart22 = v102:WaitForChild("HumanoidRootPart")

    local humanoid24 = v102:WaitForChild("Humanoid")
    humanoid24.AutoRotate = false

    local animation3 = Instance.new("Animation")
    animation3.AnimationId = "rbxassetid://507771019"

    local v103, v104 = pcall(function() return humanoid24:LoadAnimation(animation3) end)

    if v103 and v104 then
      v104.Priority = Enum.AnimationPriority.Action
      v104.Looped = true
      v104:Play()

      v101 = v104
    end

    local v105 = os.clock()

    connect16 = runService.RenderStepped:Connect(function()
      if os.clock() - v105 > 20 then
        f10()
        return
      else
        local character30 = p37.Character

        local humanoidRootPart23 = character30
          and character30:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart23 then
          f10()
          return
        else
          local cframe7 = CFrame.new(0, 0.5, -2.5)

          humanoidRootPart22.CFrame = CFrame.new(
            (humanoidRootPart23.CFrame * cframe7).Position, humanoidRootPart23.Position
          )

          return
        end
      end
    end)
  end

  local connect17

  function f8()
    if connect17 then
      connect17:Disconnect()
      connect17 = nil
    end

    local character31 = localPlayer.Character
    local humanoid25 = character31 and character31:FindFirstChildOfClass("Humanoid")

    if humanoid25 then
      humanoid25.AutoRotate = true
    end
  end

  function spinAroundPlayer(p38)
    f8()
    f9()
    f7()
    f10()
    f11()
    f12()
    f13()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v106 = getCharacter()
    local humanoidRootPart24 = v106:WaitForChild("HumanoidRootPart")
    v106:WaitForChild("Humanoid").AutoRotate = false
    local v107 = os.clock()

    connect17 = runService.RenderStepped:Connect(function()
      if os.clock() - v107 > 3 then
        f8()
        return
      else
        local character32 = p38.Character

        local humanoidRootPart25 = character32
          and character32:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart25 then
          f8()
          return
        else
          local v108 = (os.clock() - v107) * 5 * math.pi * 2
          local v109 = math.cos(v108)
          local v110 = math.sin(v108)
          local vector17 = Vector3.new(v109 * 4, 1.5, v110 * 4)

          humanoidRootPart24.CFrame = CFrame.new(
            humanoidRootPart25.Position + vector17, humanoidRootPart25.Position
          )

          return
        end
      end
    end)
  end

  local connect18

  function f11()
    if connect18 then
      connect18:Disconnect()
      connect18 = nil
    end

    local character33 = localPlayer.Character
    local humanoid26 = character33 and character33:FindFirstChildOfClass("Humanoid")

    if humanoid26 then
      humanoid26.AutoRotate = true
    end
  end

  function circleAroundPlayer(p39)
    f8()
    f11()
    f7()
    f9()
    f10()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v111 = getCharacter()
    local humanoidRootPart26 = v111:WaitForChild("HumanoidRootPart")
    v111:WaitForChild("Humanoid").AutoRotate = false
    local v112 = os.clock()

    connect18 = runService.RenderStepped:Connect(function()
      if os.clock() - v112 > 20 then
        f11()
        return
      else
        local character34 = p39.Character

        local humanoidRootPart27 = character34
          and character34:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart27 then
          f11()
          return
        else
          local v113 = (os.clock() - v112) * 1.2 * math.pi * 2
          local v114 = math.cos(v113)
          local v115 = math.sin(v113)
          local vector18 = Vector3.new(v114 * 6, 0, v115 * 6)

          humanoidRootPart26.CFrame = CFrame.new(
            humanoidRootPart27.Position + vector18, humanoidRootPart27.Position
          )

          return
        end
      end
    end)
  end

  local connect19 = nil

  function f12()
    if connect19 then
      connect19:Disconnect()
      connect19 = nil
    end

    local character35 = localPlayer.Character
    local humanoid27 = character35 and character35:FindFirstChildOfClass("Humanoid")

    if humanoid27 then
      humanoid27.AutoRotate = true
    end
  end

  function shadowPlayer(p40)
    f8()
    f12()
    f7()
    f9()
    f10()
    f11()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v116 = getCharacter()
    local humanoidRootPart28 = v116:WaitForChild("HumanoidRootPart")
    v116:WaitForChild("Humanoid").AutoRotate = false
    local v117 = os.clock()

    connect19 = runService.RenderStepped:Connect(function(delta5)
      if os.clock() - v117 > 20 then
        f12()
        return
      else
        local character36 = p40.Character

        local humanoidRootPart29 = character36
          and character36:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart29 then
          f12()
          return
        else
          local position2 = humanoidRootPart28.Position

          local v118 = humanoidRootPart29.Position + humanoidRootPart29.CFrame.LookVector * -6
            - position2

          local v119 = math.min(22 * delta5, v118.Magnitude)
          local v120 = v118.Magnitude > 0.01 and position2 + v118.Unit * v119 or position2
          humanoidRootPart28.CFrame = CFrame.new(v120, humanoidRootPart29.Position)
          return
        end
      end
    end)
  end
end

do
  local connect20

  function f7()
    if connect20 then
      connect20:Disconnect()
      connect20 = nil
    end

    local character37 = localPlayer.Character
    local humanoid28 = character37 and character37:FindFirstChildOfClass("Humanoid")

    if humanoid28 then
      humanoid28.AutoRotate = true
    end
  end

  function backRidePlayer(p41)
    f8()
    f7()
    f9()
    f10()
    f11()
    f12()
    f13()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v121 = getCharacter()
    local humanoidRootPart30 = v121:WaitForChild("HumanoidRootPart")
    v121:WaitForChild("Humanoid").AutoRotate = false
    local v122 = os.clock()
    local cframe8 = CFrame.new(0, 1.8, 1.35)

    connect20 = runService.RenderStepped:Connect(function()
      if os.clock() - v122 > 20 then
        f7()
        return
      else
        local character38 = p41.Character

        local humanoidRootPart31 = character38
          and character38:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart31 then
          f7()
          return
        end

        humanoidRootPart30.CFrame = humanoidRootPart31.CFrame * cframe8
        return
      end
    end)
  end

  local connect21

  function f13()
    if connect21 then
      connect21:Disconnect()
      connect21 = nil
    end

    local character39 = localPlayer.Character
    local humanoid29 = character39 and character39:FindFirstChildOfClass("Humanoid")

    if humanoid29 then
      humanoid29.AutoRotate = true
    end
  end

  function mirrorPlayer(p42)
    f8()
    f13()
    f7()
    f9()
    f10()
    f11()
    f12()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v123 = getCharacter()
    local humanoidRootPart32 = v123:WaitForChild("HumanoidRootPart")
    v123:WaitForChild("Humanoid").AutoRotate = false

    connect21 = runService.RenderStepped:Connect(function()
      local character40 = p42.Character
      local humanoidRootPart33 = character40 and character40:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart33 then
        f13()
        return
      end

      humanoidRootPart32.CFrame = humanoidRootPart33.CFrame * CFrame.new(5, 0, 0)
    end)
  end

  local connect22 = nil

  function f2()
    if connect22 then
      connect22:Disconnect()
      connect22 = nil
    end

    local character41 = localPlayer.Character
    local humanoid30 = character41 and character41:FindFirstChildOfClass("Humanoid")

    if humanoid30 then
      humanoid30.AutoRotate = true
    end
  end

  function tpSpamAroundPlayer(p43)
    f8()
    f2()
    f7()
    f9()
    f10()
    f11()
    f12()
    f13()
    f3()
    f4()
    f5()
    f6()
    local v124 = getCharacter()
    local humanoidRootPart34 = v124:WaitForChild("HumanoidRootPart")
    v124:WaitForChild("Humanoid").AutoRotate = false
    local v125 = os.clock()
    local v126 = 0

    connect22 = runService.RenderStepped:Connect(function()
      if os.clock() - v125 > 15 then
        f2()
        return
      else
        local character42 = p43.Character

        local humanoidRootPart35 = character42
          and character42:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart35 then
          f2()
          return
        elseif os.clock() - v126 < 0.08 then
          return
        else
          v126 = os.clock()
          local v127 = math.random() * math.pi * 2
          local v128 = math.random()
          local v129 = math.cos(v127)
          local v130 = math.sin(v127)
          local vector19 = Vector3.new(v129 * 7, (v128 - 0.5) * 4, v130 * 7)

          humanoidRootPart34.CFrame = CFrame.new(
            humanoidRootPart35.Position + vector19, humanoidRootPart35.Position
          )

          return
        end
      end
    end)
  end

  local v131 = {}

  function buildCagePart()
    local theLynoxCageBar = Instance.new("Part")
    theLynoxCageBar.Size = Vector3.new(1, 6, 1)
    theLynoxCageBar.Anchored = true
    theLynoxCageBar.CanCollide = false
    theLynoxCageBar.CanQuery = false
    theLynoxCageBar.CanTouch = false
    theLynoxCageBar.Material = Enum.Material.Neon
    theLynoxCageBar.Color = Color3.fromRGB(139, 92, 246)
    theLynoxCageBar.Transparency = 0.15
    theLynoxCageBar.Name = "TheLynoxCageBar"
    theLynoxCageBar.Parent = workspace

    return theLynoxCageBar
  end

  local connect23

  function f3()
    if connect23 then
      connect23:Disconnect()
      connect23 = nil
    end

    for index11, value10 in ipairs(v131) do
      if value10 and value10.Parent then
        value10:Destroy()
      end
    end

    v131 = {}
  end

  function cageAroundPlayer(p44)
    f8()
    f3()
    f7()
    f9()
    f10()
    f11()
    f12()
    f13()
    f2()
    f4()
    f5()
    f6()
    local count2 = 0

    while true do
      count2 = 1 + count2

      if not (count2 <= 4) then
        break
      end

      v131[count2] = buildCagePart()
    end

    local v132 = os.clock()

    connect23 = runService.RenderStepped:Connect(function()
      if os.clock() - v132 > 25 then
        f3()
        return
      else
        local character43 = p44.Character

        local humanoidRootPart36 = character43
          and character43:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart36 then
          f3()
          return
        else
          local v133 = (os.clock() - v132) * 0.5

          for index12, value11 in ipairs(v131) do
            local v134 = v133 + (index12 - 1) * (math.pi / 2)
            local v135 = math.cos(v134)
            local v136 = math.sin(v134)
            local vector20 = Vector3.new(v135 * 5, 0, v136 * 5)
            value11.CFrame = CFrame.new(humanoidRootPart36.Position + vector20)
          end

          return
        end
      end
    end)
  end
end

do
  local v137 = 128777973
  local v138 = false
  local v139 = nil

  function f4()
    v138 = false

    if v139 then
      v139:Stop()
      v139 = nil
    end

    local character44 = localPlayer.Character

    local humanoid31 = character44
    humanoid31 = character44 and character44:FindFirstChildOfClass("Humanoid")

    if humanoid31 then
      humanoid31.AutoRotate = true
    end
  end

  function randomWaveAtPlayer(p45)
    f8()
    f4()
    f7()
    f9()
    f10()
    f11()
    f12()
    f13()
    f2()
    f3()
    f5()
    f6()
    v138 = true

    task.spawn(function()
      while v138 do
        task.wait(math.random(5, 10))

        if not v138 then
          break
        else
          local v140 = getCharacter()
          local humanoidRootPart37 = v140:WaitForChild("HumanoidRootPart")
          local humanoid32 = v140:WaitForChild("Humanoid")
          local character45 = p45.Character

          local humanoidRootPart38 = character45
            and character45:FindFirstChild("HumanoidRootPart")

          if not humanoidRootPart38 then
            f4()
            break
          else
            humanoid32.AutoRotate = false
            local cframe9 = CFrame.new(0, 0, -3)

            humanoidRootPart37.CFrame = CFrame.new(
              (humanoidRootPart38.CFrame * cframe9).Position, humanoidRootPart38.Position
            )

            local animation4 = Instance.new("Animation")
            animation4.AnimationId = "rbxassetid://" .. v137

            local v141, v142 = pcall(function() return humanoid32:LoadAnimation(animation4) end)

            if v141 and v142 then
              v142.Priority = Enum.AnimationPriority.Action
              v139 = v142

              v142:Play()
              v142.Stopped:Wait()

              v139 = nil
            else
              task.wait(1.5)
            end

            if v138 then
              humanoid32.AutoRotate = true
            end
          end
        end
      end
    end)
  end

  local connect24 = nil

  function f5()
    if connect24 then
      connect24:Disconnect()
      connect24 = nil
    end

    local character46 = localPlayer.Character
    local humanoid33 = character46 and character46:FindFirstChildOfClass("Humanoid")

    if humanoid33 then
      humanoid33.AutoRotate = true
    end
  end

  function jumpBesidePlayer(p46)
    f8()
    f5()
    f7()
    f6()
    f9()
    f10()
    f11()
    f12()
    f13()
    f2()
    f3()
    f4()
    local v143 = getCharacter()
    local humanoidRootPart39 = v143:WaitForChild("HumanoidRootPart")
    v143:WaitForChild("Humanoid").AutoRotate = false
    local v144 = os.clock()

    connect24 = runService.RenderStepped:Connect(function()
      if os.clock() - v144 > 20 then
        f5()
        return
      else
        local character47 = p46.Character

        local humanoidRootPart40 = character47
          and character47:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart40 then
          f5()
          return
        else
          local v145 = os.clock()
          local v146 = math.max(0, math.sin((v145 - v144) * 3.5 * math.pi))
          local cframe10 = CFrame.new(3.5, 0, 0)
          local vector21 = Vector3.new(0, v146 * 2.5, 0)

          humanoidRootPart39.CFrame = CFrame.new((humanoidRootPart40.CFrame * cframe10).Position
            + vector21, humanoidRootPart40.Position)

          return
        end
      end
    end)
  end

  local v147

  function f6()
    if v147 then
      v147:Stop()
      v147 = nil
    end

    local character48 = localPlayer.Character

    if character48 then
      local humanoid34 = character48:FindFirstChildOfClass("Humanoid")

      if humanoid34 then
        humanoid34.AutoRotate = true
      end
    end
  end

  function fakeDeathInFrontOf(p47)
    f8()
    f6()
    f7()
    f9()
    f10()
    f11()
    f12()
    f13()
    f2()
    f3()
    f4()
    f5()
    local v148 = getCharacter()
    local humanoidRootPart41 = v148:WaitForChild("HumanoidRootPart")
    local humanoid35 = v148:WaitForChild("Humanoid")
    local character49 = p47.Character
    local humanoidRootPart42 = character49 and character49:FindFirstChild("HumanoidRootPart")
    local animation5, v149

    if not humanoidRootPart42 then
      return
    else
      local position3 = (humanoidRootPart42.CFrame * CFrame.new(0, -2, -3)).Position
      local v150, v151, v152 = humanoidRootPart42.CFrame:ToEulerAnglesYXZ()
      humanoid35.AutoRotate = false
      humanoidRootPart41.CFrame = CFrame.new(position3) * CFrame.Angles(math.rad(-90), v151, 0)

      animation5 = Instance.new("Animation")
      animation5.AnimationId = "rbxassetid://181526230"

      local v153
      v153, v149 = pcall(function() return humanoid35:LoadAnimation(animation5) end)

      if v153 and v149 then
        v149.Priority = Enum.AnimationPriority.Action
        v149:Play()
        v147 = v149
      end

      task.delay(8, function()
        if v147 == v149 then
          f6()
          local v154 = { humanoidRootPart41.CFrame:ToEulerAnglesYXZ() }

          humanoidRootPart41.CFrame = CFrame.new(humanoidRootPart41.Position
              + Vector3.new(0, 2, 0))
            * CFrame.Angles(0, v154[2], 0)
        end
      end)

      return
    end
  end

  local v155, v156

  function stopBackstab()
    if connect then
      connect:Disconnect()
      connect = nil
    end

    if v155 then
      v155:Stop()
      v155 = nil
    end

    if v156 then
      v156:Destroy()
      v156 = nil
    end

    local character50 = localPlayer.Character

    local humanoid36 = character50
    humanoid36 = character50 and character50:FindFirstChildOfClass("Humanoid")

    if humanoid36 then
      humanoid36.AutoRotate = true
    end
  end

  function backstabPlayer(p48)
    f8()
    stopBackstab()
    f7()
    f9()
    f10()
    f11()
    f12()
    f13()
    f2()
    f3()
    f4()
    f5()
    f6()
    local v157 = getCharacter()
    local humanoidRootPart43 = v157:WaitForChild("HumanoidRootPart")

    local humanoid37 = v157:WaitForChild("Humanoid")
    humanoid37.AutoRotate = false

    local animation6 = Instance.new("Animation")

    animation6.AnimationId = "rbxassetid://"
      .. tostring(humanoid37.RigType == Enum.HumanoidRigType.R15 and 507777826 or 180426354)

    local v158, v159 = pcall(function() return humanoid37:LoadAnimation(animation6) end)

    if v158 and v159 then
      v159.Priority = Enum.AnimationPriority.Action
      v159.Looped = true
      v159:Play(0.05, 1, 2.2)

      v155 = v159
    end

    local v160 = {
      Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 200), Color3.fromRGB(255, 255, 255),
      Color3.fromRGB(255, 60, 60),
    }

    local backstabGlitch = Instance.new("Highlight")
    backstabGlitch.Name = "BackstabGlitch"
    backstabGlitch.Adornee = v157
    backstabGlitch.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    backstabGlitch.FillTransparency = 0.45
    backstabGlitch.OutlineTransparency = 0
    backstabGlitch.FillColor = v160[1]
    backstabGlitch.OutlineColor = v160[3]
    backstabGlitch.Parent = v157

    v156 = backstabGlitch
    local v161 = os.clock()
    local v162 = 0
    local zero = Vector3.zero
    local cframe11 = CFrame.new()

    connect = runService.RenderStepped:Connect(function()
      local character51 = p48.Character
      local humanoidRootPart44 = character51 and character51:FindFirstChild("HumanoidRootPart")
      local head4 = character51 and character51:FindFirstChild("Head")
      local humanoid38 = character51 and character51:FindFirstChildOfClass("Humanoid")

      if not humanoidRootPart44 or not head4 or not humanoid38 or humanoid38.Health <= 0 then
        stopBackstab()
        return
      else
        local v163 = os.clock()
        local v164 = v163 - v161

        if v164 >= 2 then
          local v165 = humanoidRootPart44.Position + humanoidRootPart44.CFrame.LookVector * -2.5
            + Vector3.new(0, 1, 0)

          humanoidRootPart43.CFrame = CFrame.lookAt(v165, Vector3.new(
            humanoidRootPart44.Position.X, v165.Y, humanoidRootPart44.Position.Z
          ))

          humanoidRootPart43.AssemblyLinearVelocity = Vector3.zero
          humanoidRootPart43.AssemblyAngularVelocity = Vector3.zero

          stopBackstab()
          return
        else
          if v163 - v162 > 0.045 then
            v162 = v163

            zero = Vector3.new(
              (math.random() - 0.5) * 1.4, (math.random() - 0.5) * 1.2,
              (math.random() - 0.5) * 1.4
            )

            if math.random() < 0.15 then
              zero = zero * 3
            end

            cframe11 = CFrame.Angles(
              (math.random() - 0.5) * 0.8,
              math.random() < 0.2 and math.random() * math.pi * 2 or 0,
              (math.random() - 0.5) * 0.8
            )

            backstabGlitch.FillColor = v160[math.random(1, #v160)]
            backstabGlitch.FillTransparency = 0.25 + math.random() * 0.5
          end

          local cframe12 = humanoidRootPart44.CFrame
          local lookVector5 = cframe12.LookVector
          local v166 = math.sin(v164 * 9)
          local v167 = math.cos(v164 * 4.5)
          local vector22 = Vector3.new(0, 3.3, 0)

          humanoidRootPart43.CFrame = CFrame.new(head4.Position + lookVector5 * -0.6 + vector22
              + lookVector5 * (v166 * 0.55) + cframe12.RightVector * (v167 * 0.25) + zero)
            * (cframe12 - cframe12.Position)
            * cframe11

          humanoidRootPart43.AssemblyLinearVelocity = Vector3.zero
          humanoidRootPart43.AssemblyAngularVelocity = Vector3.zero

          return
        end
      end
    end)
  end
end

do
  local v168 = 0
  local v169

  userInputService.InputBegan:Connect(function(input4, p49)
    if input4.UserInputType ~= Enum.UserInputType.MouseButton1 then
      return
    elseif p49 then
      return
    else
      local target = localPlayer:GetMouse().Target

      if not target then
        v169 = nil
        v168 = 0
        return
      else
        local model2 = target:FindFirstAncestorOfClass("Model")
        local getPlayerFromCharacter = model2 and players:GetPlayerFromCharacter(model2)

        if not getPlayerFromCharacter or getPlayerFromCharacter == localPlayer then
          v169 = nil
          v168 = 0
          return
        else
          local v170 = os.clock()

          if v169 == getPlayerFromCharacter and v170 - v168 <= 0.35 then
            v169 = nil
            v168 = 0
            task.spawn(backstabPlayer, getPlayerFromCharacter)
          else
            v169 = getPlayerFromCharacter
            v168 = v170
          end

          return
        end
      end
    end
  end)

  v171 = false

  function buildTPTool()
    local backpack2 = localPlayer:WaitForChild("Backpack")

    if backpack2:FindFirstChild("TPLynox") then
      return
    else
      local character52 = localPlayer.Character

      if character52 and character52:FindFirstChild("TPLynox") then
        return
      else
        local tpLynox = Instance.new("Tool")
        tpLynox.Name = "TPLynox"
        tpLynox.RequiresHandle = false
        tpLynox.CanBeDropped = false

        tpLynox.Activated:Connect(function()
          local getMouse = localPlayer:GetMouse()
          local position4 = getMouse.Hit and getMouse.Hit.Position

          if not position4 then
            return
          else
            local v172 = getCharacter()

            v172:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(position4
              + Vector3.new(0, 3, 0))

            return
          end
        end)

        tpLynox.Parent = backpack2

        return
      end
    end
  end

  function createTPTool()
    v171 = true
    buildTPTool()
  end

  function setCheckpoint(p50)
    local character53 = localPlayer.Character
    local humanoidRootPart45 = character53 and character53:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart45 then
      return false
    else
      local gsub = tostring(p50 or ""):gsub("^%s+", ""):gsub("%s+$", "")

      if gsub == "" then
        return false
      end

      v15.points[gsub] = humanoidRootPart45.CFrame
      v15.activeName = gsub
      v15.activeCFrame = humanoidRootPart45.CFrame

      if v15.refresh then
        v15.refresh()
      end

      return true
    end
  end

  function teleportToCheckpoint(key10)
    local v173 = v15.points[key10]

    if not v173 then
      return
    else
      local character54 = localPlayer.Character
      local humanoidRootPart46 = character54 and character54:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart46 then
        return
      end

      humanoidRootPart46.CFrame = v173
      humanoidRootPart46.AssemblyLinearVelocity = Vector3.zero
      humanoidRootPart46.AssemblyAngularVelocity = Vector3.zero

      return
    end
  end

  function respawnAtCheckpoint()
    if not v15.activeCFrame then
      return
    else
      local character55 = localPlayer.Character
      local humanoid39 = character55 and character55:FindFirstChildOfClass("Humanoid")

      if humanoid39 then
        humanoid39.Health = 0
      end

      return
    end
  end

  function selectCheckpoint(key11)
    local v174 = v15.points[key11]

    if not v174 then
      return
    end

    if v15.activeName == key11 then
      v15.activeName = nil
      v15.activeCFrame = nil
    else
      v15.activeName = key11
      v15.activeCFrame = v174
    end

    if v15.refresh then
      v15.refresh()
    end
  end

  function deleteCheckpoint(key12)
    v15.points[key12] = nil

    if v15.activeName == key12 then
      v15.activeName = nil
      v15.activeCFrame = nil
    end

    if v15.refresh then
      v15.refresh()
    end
  end

  function clearCheckpoints()
    table.clear(v15.points)

    v15.activeName = nil
    v15.activeCFrame = nil

    if v15.refresh then
      v15.refresh()
    end
  end
end

do
  _G.LynoxAutoEscapeEnabled = false
  _G.LynoxAutoEscapeArmed = true

  runService.Heartbeat:Connect(function()
    if not _G.LynoxAutoEscapeEnabled then
      return
    else
      local character56 = localPlayer.Character
      local humanoid40 = character56 and character56:FindFirstChildOfClass("Humanoid")

      local humanoidRootPart47 = character56
      humanoidRootPart47 = character56 and character56:FindFirstChild("HumanoidRootPart")

      local v175 = not humanoid40
      local v176 = humanoidRootPart47

      if v175 or not v176 or humanoid40.MaxHealth <= 0 or humanoid40.Health <= 0 then
        return
      else
        local v177 = humanoid40.Health / humanoid40.MaxHealth

        if v177 >= 0.7 then
          _G.LynoxAutoEscapeArmed = true
        end

        if v177 > 0.3 or not _G.LynoxAutoEscapeArmed then
          return
        else
          local autoESCAPE = v15.points.AUTO_ESCAPE

          if not autoESCAPE then
            return
          end

          _G.LynoxAutoEscapeArmed = false

          v176.CFrame = autoESCAPE
          v176.AssemblyLinearVelocity = Vector3.zero
          v176.AssemblyAngularVelocity = Vector3.zero

          makeTextLabel("Auto Escape : retour checkpoint", "ON")
          return
        end
      end
    end
  end)

  localPlayer.CharacterAdded:Connect(function() _G.LynoxAutoEscapeArmed = true end)
  local v178 = 0
  local v179 = 0
  local vector23 = Vector3.new()
  local v180 = false
  v181 = 60
  local vector24 = Vector3.new(0, 5, 15)

  function setFollowTarget(text3)
    v182 = text3

    if v183 then
      local v184 = v183
      v184.Text = text3 and "Suivi : " .. text3.Name or "Suivi : aucun"
    end
  end

  function onFreeCamInputBegan(p51)
    if not v11 then
      return
    end

    if p51.UserInputType == Enum.UserInputType.MouseButton2 then
      v180 = true
      userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
  end

  function onFreeCamInputEnded(p52)
    if p52.UserInputType == Enum.UserInputType.MouseButton2 then
      v180 = false
      userInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
  end

  local connect25, connect26, connect27

  function startFreeCam()
    currentCamera.CameraType = Enum.CameraType.Scriptable
    local v185, v186
    v179, v186, v185 = currentCamera.CFrame:ToEulerAnglesYXZ()
    v178 = v186
    vector23 = currentCamera.CFrame.Position
    connect26 = userInputService.InputBegan:Connect(onFreeCamInputBegan)
    connect27 = userInputService.InputEnded:Connect(onFreeCamInputEnded)

    connect25 = runService.RenderStepped:Connect(function(delta6)
      if not v11 then
        return
      else
        currentCamera.CameraType = Enum.CameraType.Scriptable

        if v180 and not v182 then
          local getMouseDelta = userInputService:GetMouseDelta()
          v178 = v178 - getMouseDelta.X * 0.003
          v179 = math.clamp(v179 - getMouseDelta.Y * 0.003, math.rad(-89), math.rad(89))
        end

        local v187 = getMoveDirection()

        if v182 then
          local character57 = v182.Character

          local humanoidRootPart48 = character57
            and character57:FindFirstChild("HumanoidRootPart")

          if humanoidRootPart48 then
            if v187.Magnitude > 0 then
              vector24 = vector24 + v187.Unit * v181 * delta6
            end

            vector23 = humanoidRootPart48.Position + vector24
            local v188 = humanoidRootPart48.Position - vector23

            if v188.Magnitude > 0.1 then
              local unit4 = v188.Unit
              v179 = math.asin(unit4.Y)
              v178 = math.atan2(-unit4.X, -unit4.Z)
            end
          elseif not v182.Parent then
            setFollowTarget(nil)
          end
        elseif v187.Magnitude > 0 then
          vector23 = vector23 + v187.Unit * v181 * delta6
        end

        local cframe13 = CFrame.Angles(0, v178, 0)
        local cframe14 = CFrame.Angles(v179, 0, 0)
        currentCamera.CFrame = CFrame.new(vector23) * (cframe13 * cframe14)
        return
      end
    end)
  end

  function stopFreeCam()
    setFollowTarget(nil)
    currentCamera.CameraType = Enum.CameraType.Custom

    if connect25 then
      connect25:Disconnect()
      connect25 = nil
    end

    if connect26 then
      connect26:Disconnect()
      connect26 = nil
    end

    if connect27 then
      connect27:Disconnect()
      connect27 = nil
    end

    v180 = false
    userInputService.MouseBehavior = Enum.MouseBehavior.Default
  end

  function focusFreeCamOnPlayer(p53)
    if not v11 then
      return
    else
      local character58 = p53.Character

      if not (character58 and character58:FindFirstChild("HumanoidRootPart")) then
        return
      end

      vector24 = Vector3.new(0, 5, 15)
      setFollowTarget(p53)
      return
    end
  end
end

do
  function toggleFreeCam(fn12)
    v11 = not v11

    if v11 then
      startFreeCam()
    else
      stopFreeCam()
    end

    fn12(v11)
  end

  function createESPTag(key13)
    local character59 = key13.Character

    if not character59 then
      return
    else
      local head5 = character59:FindFirstChild("Head")

      if not head5 then
        return
      end

      if v27[key13] and v27[key13].Parent then
        return
      else
        local espTag = Instance.new("BillboardGui")
        espTag.Name = "ESPTag"
        espTag.Adornee = head5
        espTag.Size = UDim2.new(0, 120, 0, 48)
        espTag.StudsOffset = Vector3.new(0, 1.2, 0)
        espTag.AlwaysOnTop = true
        espTag.Parent = head5

        local textLabel4 = Instance.new("TextLabel")
        textLabel4.Size = UDim2.new(1, 0, 0, 20)
        textLabel4.BackgroundTransparency = 1
        textLabel4.Text = key13.Name
        textLabel4.TextColor3 = color6
        textLabel4.Font = Enum.Font.GothamBold
        textLabel4.TextSize = 14
        textLabel4.TextStrokeTransparency = 0.5
        textLabel4.Parent = espTag

        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "DistanceLabel"
        distanceLabel.Size = UDim2.new(1, 0, 0, 16)
        distanceLabel.Position = UDim2.new(0, 0, 0, 20)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = ""
        distanceLabel.TextColor3 = color8
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.TextSize = 12
        distanceLabel.TextStrokeTransparency = 0.5
        distanceLabel.Parent = espTag

        local healthBack = Instance.new("Frame")
        healthBack.Name = "HealthBack"
        healthBack.Position = UDim2.new(0.1, 0, 0, 38)
        healthBack.Size = UDim2.new(0.8, 0, 0, 6)
        healthBack.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        healthBack.BorderSizePixel = 0
        healthBack.Parent = espTag

        local uiCorner6 = Instance.new("UICorner")
        uiCorner6.CornerRadius = UDim.new(0, 3)
        uiCorner6.Parent = healthBack

        local healthFill = Instance.new("Frame")
        healthFill.Name = "HealthFill"
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(80, 220, 100)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBack

        local uiCorner7 = Instance.new("UICorner")
        uiCorner7.CornerRadius = UDim.new(0, 3)
        uiCorner7.Parent = healthFill

        v27[key13] = espTag
        return
      end
    end
  end

  function removeESPTag(key14)
    local v189 = v27[key14]

    if v189 then
      v189:Destroy()
      v27[key14] = nil
    end
  end

  function enableESP()
    v12 = true

    for index13, value12 in ipairs(players:GetPlayers()) do
      if value12 ~= localPlayer then
        createESPTag(value12)
      end
    end
  end

  function disableESP()
    v12 = false

    for key15 in pairs(v27) do
      removeESPTag(key15)
    end
  end

  function toggleESP(fn13)
    if v12 then
      disableESP()
    else
      enableESP()
    end

    fn13(v12)
  end

  local v190 = { enabled = false, objects = {} }

  local v191 = {
    { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" },
    { "Torso", "Left Leg" }, { "Torso", "Right Leg" },
  }

  local v192 = {
    { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" }, { "UpperTorso", "LeftUpperArm" },
    { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" },
    { "RightLowerArm", "RightHand" }, { "LowerTorso", "LeftUpperLeg" },
    { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" },
    { "RightLowerLeg", "RightFoot" },
  }

  function destroySkeleton(key16)
    local v193 = v190.objects[key16]

    if v193 then
      for index14, value13 in ipairs(v193) do
        if value13.adornment then
          value13.adornment:Destroy()
        end
      end

      v190.objects[key16] = nil
    end
  end

  function createSkeleton(key17)
    if key17 == localPlayer then
      return
    else
      local character60 = key17.Character

      if not character60 then
        return
      else
        local humanoid41 = character60:FindFirstChildOfClass("Humanoid")

        if not humanoid41 then
          return
        else
          destroySkeleton(key17)
          local v194 = humanoid41.RigType == Enum.HumanoidRigType.R15 and v192 or v191
          local v195 = {}

          for index15, value14 in ipairs(v194) do
            local findFirstChild = character60:FindFirstChild(value14[1])
            local basePart = findFirstChild
            local findFirstChild2 = character60:FindFirstChild(value14[2])

            if findFirstChild then
              basePart = findFirstChild2 and findFirstChild:IsA("BasePart")
                and findFirstChild2:IsA("BasePart")
            end

            if basePart then
              local theLynoxSkeleton = Instance.new("BoxHandleAdornment")
              theLynoxSkeleton.Name = "TheLynoxSkeleton"
              theLynoxSkeleton.Adornee = findFirstChild
              theLynoxSkeleton.AlwaysOnTop = true
              theLynoxSkeleton.ZIndex = 10
              theLynoxSkeleton.Color3 = color6
              theLynoxSkeleton.Transparency = 0.15
              theLynoxSkeleton.Size = Vector3.new(0.09, 0.09, 0.1)
              theLynoxSkeleton.Parent = findFirstChild

              table.insert(v195, {
                adornment = theLynoxSkeleton,
                partA = findFirstChild,
                partB = findFirstChild2,
              })
            end
          end

          v190.objects[key17] = v195
          return
        end
      end
    end
  end

  function enableSkeletonESP()
    v190.enabled = true

    for index16, value15 in ipairs(players:GetPlayers()) do
      if value15 ~= localPlayer then
        createSkeleton(value15)
      end
    end
  end

  function disableSkeletonESP()
    v190.enabled = false

    for key18 in pairs(v190.objects) do
      destroySkeleton(key18)
    end
  end

  function toggleSkeletonESP(fn14)
    if v190.enabled then
      disableSkeletonESP()
    else
      enableSkeletonESP()
    end

    fn14(v190.enabled)
  end

  function hookSkeletonRespawn(p54)
    p54.CharacterAdded:Connect(function()
      if v190.enabled then
        task.wait(0.5)
        createSkeleton(p54)
      end
    end)
  end

  players.PlayerAdded:Connect(hookSkeletonRespawn)

  for index17, value16 in ipairs(players:GetPlayers()) do
    if value16 ~= localPlayer then
      hookSkeletonRespawn(value16)
    end
  end

  players.PlayerRemoving:Connect(function(player) destroySkeleton(player) end)

  runService.RenderStepped:Connect(function()
    if not v190.enabled then
      return
    end

    for key19, value17 in pairs(v190.objects) do
      for index18, value18 in ipairs(value17) do
        local adornment = value18.adornment
        local partA = value18.partA
        local v196 = not adornment
        local partB = value18.partB

        if not (v196 or not adornment.Parent or not partA or not partA.Parent or not partB
          or not partB.Parent) then
          local magnitude4 = (partB.Position - partA.Position).Magnitude

          if magnitude4 > 0.01 then
            local cframe15 = CFrame.lookAt(
              (partA.Position + partB.Position) * 0.5, partB.Position
            )

            adornment.CFrame = partA.CFrame:ToObjectSpace(cframe15)
            adornment.Size = Vector3.new(0.09, 0.09, magnitude4)
          end
        end
      end
    end
  end)
end

do
  function hookESPRespawn(p55)
    p55.CharacterAdded:Connect(function()
      if v12 then
        task.wait(0.5)
        createESPTag(p55)
      end
    end)
  end

  players.PlayerAdded:Connect(hookESPRespawn)

  for index19, value19 in ipairs(players:GetPlayers()) do
    if value19 ~= localPlayer then
      hookESPRespawn(value19)
    end
  end

  players.PlayerRemoving:Connect(removeESPTag)

  runService.Heartbeat:Connect(function()
    if not v12 then
      return
    else
      local character61 = localPlayer.Character
      local humanoidRootPart49 = character61 and character61:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart49 then
        return
      end

      for key20, value20 in pairs(v27) do
        local character62 = key20.Character

        local humanoidRootPart50 = character62
        humanoidRootPart50 = character62 and character62:FindFirstChild("HumanoidRootPart")

        local humanoid42 = character62
        local distanceLabel2 = value20:FindFirstChild("DistanceLabel")
        humanoid42 = character62 and character62:FindFirstChildOfClass("Humanoid")
        local healthBack2 = value20:FindFirstChild("HealthBack")

        local healthFill2 = healthBack2
        healthFill2 = healthBack2 and healthBack2:FindFirstChild("HealthFill")

        local v197 = ""

        if humanoid42 and healthFill2 and humanoid42.MaxHealth > 0 then
          local v198 = math.clamp(humanoid42.Health / humanoid42.MaxHealth, 0, 1)

          healthFill2.Size = UDim2.new(v198, 0, 1, 0)
          healthFill2.BackgroundColor3 = Color3.fromHSV(v198 * 0.33, 0.85, 0.95)

          v197 = string.format(" | %d HP", math.floor(humanoid42.Health))
        end

        if humanoidRootPart50 and distanceLabel2 then
          local v199 = math.floor((humanoidRootPart49.Position
            - humanoidRootPart50.Position).Magnitude)

          distanceLabel2.Text = string.format("%d studs%s", v199, v197)
        end
      end

      return
    end
  end)

  local v200 = {
    Brightness = lighting.Brightness,
    ClockTime = lighting.ClockTime,
    FogEnd = lighting.FogEnd,
    GlobalShadows = lighting.GlobalShadows,
    OutdoorAmbient = lighting.OutdoorAmbient,
    Ambient = lighting.Ambient,
  }

  local function f14()
    lighting.Brightness = 2
    lighting.ClockTime = 14
    lighting.FogEnd = 100000
    lighting.GlobalShadows = false
    lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    lighting.Ambient = Color3.fromRGB(200, 200, 200)
  end

  function toggleFullbright(p56)
    v16 = not v16

    if v16 then
      f14()
    else
      for key21, value21 in pairs(v200) do
        lighting[key21] = value21
      end
    end

    if p56 then
      p56(v16)
    end

    if v201 and v201 ~= p56 then
      v201(v16)
    end
  end

  userInputService.InputBegan:Connect(function(input5, p57)
    if p57 or userInputService:GetFocusedTextBox() then
      return
    end

    if input5.KeyCode == Enum.KeyCode.J then
      toggleFullbright(v201)
    end
  end)

  localPlayer.CharacterAdded:Connect(function()
    if v16 then
      task.defer(function()
        if v16 then
          f14()
        end
      end)

      task.delay(0.5, function()
        if v16 then
          f14()
        end
      end)
    end
  end)

  runService:BindToRenderStep("TheLynoxFullbright", Enum.RenderPriority.Last.Value, function()
    if v16 then
      f14()
    end
  end)
end

do
  v202 = false
  local v203 = {}
  local connect28 = nil

  local function f15()
    if connect28 then
      connect28:Disconnect()
      connect28 = nil
    end

    for key22, value22 in pairs(v203) do
      local v204 = key22
      local canTouch = value22

      if v204.Parent then
        pcall(function() v204.CanTouch = canTouch end)
      end

      v203[v204] = nil
    end
  end

  local v205 = {}
  local connect29, connect30

  local function f16()
    if connect29 then
      connect29:Disconnect()
      connect29 = nil
    end

    if connect30 then
      connect30:Disconnect()
      connect30 = nil
    end

    for index20, value23 in ipairs(v205) do
    end

    table.clear(v205)
  end

  local count3 = 0

  local function f17()
    count3 = count3 + 1
    local v206 = count3

    for index21, value24 in ipairs(v205) do
    end

    table.clear(v205)
    local character63 = localPlayer.Character
    local humanoid43, anchored2

    if not character63 then
      return
    else
      humanoid43 = character63:FindFirstChildOfClass("Humanoid")
      local humanoidRootPart51 = character63:FindFirstChild("HumanoidRootPart")

      if not humanoid43 or not humanoidRootPart51 then
        return
      else
        anchored2 = humanoidRootPart51.Anchored

        connect29 = connect29 or runService.Heartbeat:Connect(function()
          if not v202 or v206 ~= count3 then
            return
          else
            local character64 = localPlayer.Character

            if not character64 then
              return
            else
              local humanoidRootPart52 = character64:FindFirstChild("HumanoidRootPart")
              local humanoid44 = character64:FindFirstChildOfClass("Humanoid")

              if not humanoidRootPart52 or not humanoid44 then
                return
              else
                if humanoidRootPart52.AssemblyLinearVelocity.Magnitude > 100 then
                  humanoidRootPart52.AssemblyLinearVelocity = Vector3.zero
                end

                if humanoidRootPart52.AssemblyAngularVelocity.Magnitude > 50 then
                  humanoidRootPart52.AssemblyAngularVelocity = Vector3.zero
                end

                local position5 = humanoidRootPart52.Position
                local theLynoxAntiFlingLastPosition = humanoidRootPart52:GetAttribute("TheLynoxAntiFlingLastPosition")

                if theLynoxAntiFlingLastPosition then
                  if (position5 - theLynoxAntiFlingLastPosition).Magnitude > 50 then
                    humanoidRootPart52.CFrame = CFrame.new(theLynoxAntiFlingLastPosition)
                  end
                end

                humanoidRootPart52:SetAttribute(
                  "TheLynoxAntiFlingLastPosition", humanoidRootPart52.Position
                )

                if humanoidRootPart52.Anchored ~= anchored2 then
                  humanoidRootPart52.Anchored = anchored2
                end

                return
              end
            end
          end
        end)

        connect30 = connect30 or runService.RenderStepped:Connect(function()
          if not v202 or v206 ~= count3 then
            return
          else
            local character65 = localPlayer.Character
            local humanoidRootPart53 = character65 and character65:FindFirstChild("HumanoidRootPart")

            if not humanoidRootPart53 then
              return
            else
              if humanoidRootPart53.AssemblyLinearVelocity.Magnitude > 200 then
                humanoidRootPart53.AssemblyLinearVelocity = Vector3.zero
              end

              if humanoidRootPart53.AssemblyAngularVelocity.Magnitude > 100 then
                humanoidRootPart53.AssemblyAngularVelocity = Vector3.zero
              end

              local position6 = humanoidRootPart53.Position
              local theLynoxAntiFlingLastPos = humanoidRootPart53:GetAttribute("TheLynoxAntiFlingLastPos")

              if theLynoxAntiFlingLastPos and (position6 - theLynoxAntiFlingLastPos).Magnitude > 100 then
                humanoidRootPart53.CFrame = CFrame.new(theLynoxAntiFlingLastPos)
              end

              humanoidRootPart53:SetAttribute(
                "TheLynoxAntiFlingLastPos", humanoidRootPart53.Position
              )

              return
            end
          end
        end)

        for index22, value25 in ipairs(character63:GetDescendants()) do
          local v207 = value25

          if v207:IsA("BasePart") then
            v207:SetAttribute("TheLynoxOriginalAnchored", v207.Anchored)
            v207:SetAttribute("TheLynoxOriginalCanCollide", v207.CanCollide)
            v207:SetAttribute("TheLynoxOriginalMass", v207.AssemblyMass)

            local anchored3 = v207:GetPropertyChangedSignal("Anchored")

            table.insert(v205, anchored3:Connect(function()
              if v202 and v207.Parent then
                local theLynoxOriginalAnchored = v207:GetAttribute("TheLynoxOriginalAnchored")

                if theLynoxOriginalAnchored ~= nil and v207.Anchored ~= theLynoxOriginalAnchored then
                  v207.Anchored = theLynoxOriginalAnchored
                end
              end
            end))

            local canCollide = v207:GetPropertyChangedSignal("CanCollide")

            table.insert(v205, canCollide:Connect(function()
              if v202 and v207.Parent then
                local theLynoxOriginalCanCollide = v207:GetAttribute("TheLynoxOriginalCanCollide")

                if theLynoxOriginalCanCollide ~= nil
                  and v207.CanCollide ~= theLynoxOriginalCanCollide then
                  v207.CanCollide = theLynoxOriginalCanCollide
                end
              end
            end))
          end
        end

        local stateChanged = humanoid43.StateChanged

        table.insert(v205, stateChanged:Connect(function(p58, p59)
          if not v202 then
            return
          end

          if p59 == Enum.HumanoidStateType.Dead and humanoid43.Health > 0 then
            humanoid43:ChangeState(Enum.HumanoidStateType.Running)
          end
        end))

        return
      end
    end
  end

  local f18

  local function f19()
    for index23, value26 in ipairs(workspace:GetDescendants()) do
      f18(value26)
    end

    if not connect28 then
      connect28 = workspace.DescendantAdded:Connect(function(descendant)
        if v202 then
          f18(descendant)
        end
      end)
    end
  end

  function f18(key23)
    if not key23:IsA("VehicleSeat") then
      return
    end

    if v203[key23] == nil then
      v203[key23] = key23.CanTouch
    end

    key23.CanTouch = false
  end

  function toggleAntiFling(fn15)
    v202 = not v202

    if not v202 then
      f16()
      f15()
    else
      f17()
      f19()
    end

    fn15(v202)
  end

  localPlayer.CharacterAdded:Connect(function()
    if v202 then
      task.wait(0.5)
      f17()
    end
  end)
end

localPlayer.Idled:Connect(function()
  if not v13 then
    return
  end

  virtualUser:CaptureController()
  virtualUser:ClickButton2(Vector2.new())
end)

function toggleAntiAfk(fn16)
  v13 = not v13
  fn16(v13)
end

function sendChatMessage(p60)
  local rbxGeneral = textChatService.TextChannels
    and textChatService.TextChannels:FindFirstChild("RBXGeneral")

  if rbxGeneral then
    if pcall(function() rbxGeneral:SendAsync(p60) end) then
      return
    end

    pcall(function() localPlayer:Chat(p60) end)
    return
  end

  pcall(function() localPlayer:Chat(p60) end)
end

function resetCharacter()
  if localPlayer.Character then
    local humanoid45 = localPlayer.Character:FindFirstChildOfClass("Humanoid")

    if humanoid45 then
      humanoid45.Health = 0
    end
  end
end

localPlayer.CharacterAdded:Connect(function(character66)
  character66:WaitForChild("Humanoid").WalkSpeed = v6
  watchVehicleSeat(character66)

  if v4 then
    if connect2 then
      connect2:Disconnect()
      connect2 = nil
    end

    if bodyVelocity then
      bodyVelocity:Destroy()
      bodyVelocity = nil
    end

    startFly(character66)
  end

  if v171 then
    task.defer(buildTPTool)
  end

  if v14 then
    task.wait(0.2)
    setNoclipOnCharacter(character66, true)
  end

  local humanoidRootPart54

  if v15.activeCFrame then
    humanoidRootPart54 = character66:WaitForChild("HumanoidRootPart")
    task.wait(0.25)

    humanoidRootPart54.CFrame = v15.activeCFrame
    humanoidRootPart54.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    humanoidRootPart54.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    task.delay(0.5, function()
      if v15.activeCFrame and character66.Parent and humanoidRootPart54.Parent then
        humanoidRootPart54.CFrame = v15.activeCFrame
        humanoidRootPart54.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
      end
    end)
  end

  if v19 then
    stopCrawl()
    v19 = true
    startCrawl()
  end

  if v20 then
    stopCeilingWalk()
    v20 = true
    startCeilingWalk()
  end
end)

if localPlayer.Character then
  watchVehicleSeat(localPlayer.Character)
end

function corner(parent, p61)
  local uiCorner8 = Instance.new("UICorner")
  uiCorner8.CornerRadius = UDim.new(0, p61 or 8)
  uiCorner8.Parent = parent

  return uiCorner8
end

function padding(parent2, p62)
  local uiPadding = Instance.new("UIPadding")
  uiPadding.PaddingTop = UDim.new(0, p62)
  uiPadding.PaddingBottom = UDim.new(0, p62)
  uiPadding.PaddingLeft = UDim.new(0, p62)
  uiPadding.PaddingRight = UDim.new(0, p62)
  uiPadding.Parent = parent2
end

function stroke(parent3, color9, p63, p64)
  local uiStroke2 = Instance.new("UIStroke")
  uiStroke2.Color = color9
  uiStroke2.Thickness = p63 or 1
  uiStroke2.Transparency = p64 or 0
  uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  uiStroke2.Parent = parent3

  return uiStroke2
end

function newCard(parent4, layoutOrder, text4)
  local frame4 = Instance.new("Frame")
  frame4.Size = UDim2.new(1, 0, 0, 0)
  frame4.AutomaticSize = Enum.AutomaticSize.Y
  frame4.BackgroundTransparency = 1
  frame4.BorderSizePixel = 0
  frame4.LayoutOrder = layoutOrder
  frame4.Parent = parent4

  padding(frame4, 0)

  local uiListLayout = Instance.new("UIListLayout")
  uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
  uiListLayout.Padding = UDim.new(0, 5)
  uiListLayout.Parent = frame4

  local cardTitle = Instance.new("TextLabel")
  cardTitle.Name = "CardTitle"
  cardTitle.Size = UDim2.new(1, 0, 0, 19)
  cardTitle.BackgroundTransparency = 1
  cardTitle.Text = text4
  cardTitle.TextColor3 = color8
  cardTitle.Font = Enum.Font.GothamBold
  cardTitle.TextSize = 10
  cardTitle.TextXAlignment = Enum.TextXAlignment.Left
  cardTitle.LayoutOrder = 0
  cardTitle.Parent = frame4

  return frame4
end

function newSwitch(parent5, layoutOrder2, text5, p65)
  local textButton = Instance.new("TextButton")
  textButton.Size = UDim2.new(1, -8, 0, 49)
  textButton.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
  textButton.Text = ""
  textButton.AutoButtonColor = false
  textButton.Position = UDim2.fromOffset(4, 0)
  textButton.LayoutOrder = layoutOrder2
  textButton.Parent = parent5

  corner(textButton, 9)
  local v208 = stroke(textButton, Color3.fromRGB(120, 120, 130), 0.75, 1)

  local textLabel5 = Instance.new("TextLabel")
  textLabel5.Position = UDim2.fromOffset(13, 3)
  textLabel5.Size = UDim2.new(1, -80, 0, 20)
  textLabel5.BackgroundTransparency = 1
  textLabel5.Text = text5
  textLabel5.TextColor3 = color7
  textLabel5.Font = Enum.Font.Gotham
  textLabel5.TextSize = 12
  textLabel5.TextXAlignment = Enum.TextXAlignment.Left
  textLabel5.Parent = textButton

  local optionDescription = Instance.new("TextLabel")
  optionDescription.Name = "OptionDescription"
  optionDescription.Position = UDim2.fromOffset(13, 24)
  optionDescription.Size = UDim2.new(1, -84, 0, 15)
  optionDescription.BackgroundTransparency = 1
  optionDescription.Text = "Activer ou désactiver cette option"
  optionDescription.TextColor3 = color8
  optionDescription.Font = Enum.Font.Gotham
  optionDescription.TextSize = 10
  optionDescription.TextXAlignment = Enum.TextXAlignment.Left
  optionDescription.Parent = textButton

  local frame5 = Instance.new("Frame")
  frame5.AnchorPoint = Vector2.new(1, 0.5)
  frame5.Position = UDim2.new(1, -13, 0.5, 0)
  frame5.Size = UDim2.fromOffset(38, 20)
  frame5.BackgroundColor3 = Color3.fromRGB(39, 39, 44)
  frame5.BorderSizePixel = 0
  frame5.Parent = textButton

  corner(frame5, 10)

  local frame6 = Instance.new("Frame")
  frame6.Size = UDim2.fromOffset(14, 14)
  frame6.Position = UDim2.fromOffset(3, 3)
  frame6.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
  frame6.BorderSizePixel = 0
  frame6.Parent = frame5

  corner(frame6, 8)
  local v209 = false

  local function f20(p66)
    local v210 = v209 ~= p66
    v209 = p66

    tweenService:Create(frame5, TweenInfo.new(0.14), {
      BackgroundColor3 = p66 and Color3.fromRGB(228, 228, 235) or Color3.fromRGB(39, 39, 44),
    }):Play()

    tweenService:Create(frame6, TweenInfo.new(0.14), {
      Position = p66 and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3),
      BackgroundColor3 = p66 and Color3.fromRGB(18, 18, 21) or Color3.fromRGB(120, 120, 130),
    }):Play()

    if v210 and not v1 then
      makeTextLabel(text5, p66 and "ON" or "OFF")
    end
  end

  if p65 == toggleFly then
    v45 = f20
  end

  if p65 == toggleFullbright then
    v201 = f20
  end

  textButton.MouseEnter:Connect(function()
    textButton.BackgroundColor3 = Color3.fromRGB(16, 16, 19)

    tweenService:Create(v208, TweenInfo.new(0.13), {
      Color = Color3.fromRGB(150, 150, 160),
      Transparency = 0.36,
      Thickness = 0.75,
    }):Play()
  end)

  textButton.MouseLeave:Connect(function()
    textButton.BackgroundColor3 = Color3.fromRGB(9, 9, 12)

    tweenService:Create(v208, TweenInfo.new(0.13), {
      Color = Color3.fromRGB(120, 120, 130),
      Transparency = 1,
      Thickness = 0.75,
    }):Play()
  end)

  textButton.MouseButton1Click:Connect(function() p65(f20) end)

  return textButton
end

function newAction(p67, p68, p69, fn17)
  return newSwitch(p67, p68, p69, function(fn18)
    fn17()
    makeTextLabel(p69, nil)
    v1 = true
    fn18(true)

    task.delay(0.8, function()
      fn18(false)
      v1 = false
    end)
  end)
end

do
  function newStepper(parent6, layoutOrder3, text6, text7, p70, fn19)
    local frame7 = Instance.new("Frame")
    frame7.Size = UDim2.new(1, 0, 0, 32)
    frame7.BackgroundTransparency = 1
    frame7.LayoutOrder = layoutOrder3
    frame7.Parent = parent6

    local textLabel6 = Instance.new("TextLabel")
    textLabel6.Size = UDim2.new(0.5, 0, 1, 0)
    textLabel6.BackgroundTransparency = 1
    textLabel6.Text = text6
    textLabel6.TextColor3 = color7
    textLabel6.Font = Enum.Font.Gotham
    textLabel6.TextSize = 13
    textLabel6.TextXAlignment = Enum.TextXAlignment.Left
    textLabel6.Parent = frame7

    local textLabel7 = Instance.new("TextLabel")
    textLabel7.Position = UDim2.new(0.5, 0, 0, 0)
    textLabel7.Size = UDim2.new(0, 40, 1, 0)
    textLabel7.BackgroundTransparency = 1
    textLabel7.Text = tostring(text7)
    textLabel7.TextColor3 = color6
    textLabel7.Font = Enum.Font.GothamBold
    textLabel7.TextSize = 14
    textLabel7.Parent = frame7

    local v211 = text7

    local function makeTextButton(text8, p71, index24)
      local textButton2 = Instance.new("TextButton")
      textButton2.Position = UDim2.new(1, p71, 0, 2)
      textButton2.Size = UDim2.new(0, 28, 0, 28)
      textButton2.BackgroundColor3 = color5
      textButton2.Text = text8
      textButton2.TextColor3 = color7
      textButton2.Font = Enum.Font.GothamBold
      textButton2.TextSize = 16
      textButton2.AutoButtonColor = false
      textButton2.Parent = frame7

      corner(textButton2, 8)

      textButton2.MouseButton1Click:Connect(function()
        v211 = fn19(v211 + index24)
        textLabel7.Text = tostring(v211)
      end)
    end

    makeTextButton("-", -64, -p70)
    makeTextButton("+", -32, p70)
  end

  function newPlayerList(parent7, index25, fn20, p72)
    local playerSearch = Instance.new("TextBox")
    playerSearch.Name = "PlayerSearch"
    playerSearch.Size = UDim2.new(1, 0, 0, 30)
    playerSearch.BackgroundColor3 = color2
    playerSearch.Text = ""
    playerSearch.PlaceholderText = "Rechercher un joueur..."
    playerSearch.TextColor3 = color7
    playerSearch.PlaceholderColor3 = color8
    playerSearch.Font = Enum.Font.Gotham
    playerSearch.TextSize = 12
    playerSearch.ClearTextOnFocus = false
    playerSearch.LayoutOrder = index25
    playerSearch.Parent = parent7

    corner(playerSearch, 8)

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 0, 120)
    scrollingFrame.BackgroundColor3 = color2
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.ScrollBarImageColor3 = color5
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.LayoutOrder = index25 + 1
    scrollingFrame.Parent = parent7

    corner(scrollingFrame, 8)
    padding(scrollingFrame, 4)

    local uiListLayout2 = Instance.new("UIListLayout")
    uiListLayout2.SortOrder = Enum.SortOrder.Name
    uiListLayout2.Padding = UDim.new(0, 4)
    uiListLayout2.Parent = scrollingFrame

    local function makeTextButton2()
      for index26, value27 in ipairs(scrollingFrame:GetChildren()) do
        if value27:IsA("TextButton") then
          value27:Destroy()
        end
      end

      local v212 = string.lower(playerSearch.Text or "")

      for index27, value28 in ipairs(players:GetPlayers()) do
        local v213 = value28

        if v213 ~= localPlayer then
          local v214 = string.find(string.lower(v213.Name), v212, 1, true)
          local v215 = string.find(string.lower(v213.DisplayName), v212, 1, true)

          if v212 == "" or v214 or v215 then
            local textButton3 = Instance.new("TextButton")
            textButton3.Name = v213.Name
            textButton3.Size = UDim2.new(1, 0, 0, 28)
            textButton3.BackgroundColor3 = color5

            textButton3.Text = v213.DisplayName ~= v213.Name
                and v213.DisplayName .. "  @" .. v213.Name
              or v213.Name

            textButton3.TextColor3 = color7
            textButton3.Font = Enum.Font.Gotham
            textButton3.TextSize = 12
            textButton3.AutoButtonColor = false
            textButton3.Parent = scrollingFrame

            corner(textButton3, 6)

            textButton3.MouseEnter:Connect(function()
              tweenService:Create(textButton3, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(42, 42, 49),
              }):Play()
            end)

            textButton3.MouseLeave:Connect(function()
              tweenService:Create(textButton3, TweenInfo.new(0.1), {
                BackgroundColor3 = color5,
              }):Play()
            end)

            local v216 = 0

            textButton3.MouseButton1Click:Connect(function()
              if p72 then
                local v217 = os.clock()

                if v217 - v216 <= 0.35 then
                  v216 = 0
                  fn20(v213)
                  makeTextLabel("Cible : " .. v213.DisplayName, nil)
                else
                  v216 = v217
                end
              else
                fn20(v213)
                makeTextLabel("Cible : " .. v213.DisplayName, nil)
              end
            end)
          end
        end
      end
    end

    playerSearch:GetPropertyChangedSignal("Text"):Connect(makeTextButton2)
    makeTextButton2()

    players.PlayerAdded:Connect(makeTextButton2)
    players.PlayerRemoving:Connect(function() task.defer(makeTextButton2) end)
  end

  function newInfoLabel(parent8, layoutOrder4, text9, p73)
    local textLabel8 = Instance.new("TextLabel")
    textLabel8.Size = UDim2.new(1, 0, 0, p73 or 22)
    textLabel8.BackgroundTransparency = 1
    textLabel8.Text = text9
    textLabel8.TextColor3 = color6
    textLabel8.Font = Enum.Font.GothamBold
    textLabel8.TextSize = 13
    textLabel8.TextXAlignment = Enum.TextXAlignment.Left
    textLabel8.TextYAlignment = Enum.TextYAlignment.Top
    textLabel8.LayoutOrder = layoutOrder4
    textLabel8.Parent = parent8

    return textLabel8
  end

  v218 = {}
  local v219 = {}
  v220 = {}

  function selectTab(text10)
    v221 = text10

    if mainFrame then
      local parallaxPageHeading = mainFrame:FindFirstChild("ParallaxPageHeading")

      if parallaxPageHeading then
        parallaxPageHeading.Text = text10 == "Joueur" and "Main"
          or text10 == "VEHICLE PRO" and "Vehicule Pro" or text10
      end

      local parallaxQuickTabs = mainFrame:FindFirstChild("ParallaxQuickTabs")

      if parallaxQuickTabs then
        local v222 = {
          QuickGeneral = "Joueur",
          QuickVehicle = "VEHICLE PRO",
          QuickVisuals = "Visuel",
          QuickPlaces = "Téléport",
        }

        for index28, value29 in ipairs(parallaxQuickTabs:GetChildren()) do
          if value29:IsA("TextButton") then
            local v223 = v222[value29.Name] == text10

            value29.BackgroundColor3 = v223 and Color3.fromRGB(235, 235, 240)
              or Color3.fromRGB(13, 13, 16)

            value29.TextColor3 = v223 and Color3.fromRGB(15, 15, 18) or color8
          end
        end
      end
    end

    for key24, value30 in pairs(v218) do
      local v224 = key24 == text10
      local v225 = v219[key24]

      if value30 and v225 then
        value30.Visible = v224

        v225.TextColor3 = v224 and Color3.fromRGB(235, 235, 238)
          or Color3.fromRGB(142, 142, 150)

        local categoryText = v225:FindFirstChild("CategoryText")

        if categoryText then
          categoryText.TextColor3 = v224 and Color3.fromRGB(238, 238, 242)
            or Color3.fromRGB(135, 135, 145)

          categoryText.Font = Enum.Font.Gotham
          categoryText.TextStrokeTransparency = 1
        end

        local indicator = v225:FindFirstChild("Indicator")

        if indicator then
          indicator.Visible = false
        end

        v225.BackgroundColor3 = v224 and Color3.fromRGB(18, 18, 22) or color3
        local parallaxSelectionStroke = v225:FindFirstChild("ParallaxSelectionStroke")

        if parallaxSelectionStroke then
          tweenService:Create(
            parallaxSelectionStroke, TweenInfo.new(0.16, Enum.EasingStyle.Quad),
            { Transparency = 1, Thickness = 0.75 }
          ):Play()
        end

        tweenService:Create(v225, TweenInfo.new(0.15), {
          BackgroundColor3 = v224 and Color3.fromRGB(23, 23, 27) or color3,
        }):Play()
      end
    end
  end

  local v226 = {
    Recherche = 1,
    Joueur = 2,
    ["SAFETY+"] = 3,
    Mouvement = 4,
    Personnage = 5,
    Utilitaires = 6,
    ["Téléport"] = 7,
    ["Caméra"] = 8,
    Visuel = 9,
    AIM = 10,
    Backstab = 11,
    Troll = 12,
    ["Animation R6"] = 13,
    ["Animation R15"] = 14,
    ["VEHICLE PRO"] = 15,
    ["KICK Cars"] = 16,
    PERFORMANCE = 17,
    Tuto = 18,
    Commandes = 19,
    GUI = 20,
    GUN = 2,
    ["MAP LIMIT"] = 4,
  }

  local categorySidebar, frame8

  function newTab(index29, key25, p74)
    local layoutOrder5 = v226[key25] or 100 + index29
    local v227 = v218[key25] and v219[key25]
    local textButton4

    if v227 then
      v219[key25].LayoutOrder = layoutOrder5
      return v218[key25]
    else
      textButton4 = Instance.new("TextButton")
      textButton4.Size = UDim2.new(1, -14, 0, 37)
      textButton4.BackgroundColor3 = color3
      textButton4.Text = ""
      textButton4.TextColor3 = color8
      textButton4.Font = Enum.Font.Gotham
      textButton4.TextSize = 12
      textButton4.TextXAlignment = Enum.TextXAlignment.Left
      textButton4.AutoButtonColor = false
      textButton4.LayoutOrder = layoutOrder5
      textButton4.Parent = categorySidebar

      corner(textButton4, 9)

      local parallaxSelectionStroke2 = Instance.new("UIStroke")
      parallaxSelectionStroke2.Name = "ParallaxSelectionStroke"
      parallaxSelectionStroke2.Color = Color3.fromRGB(155, 155, 165)
      parallaxSelectionStroke2.Thickness = 0.75
      parallaxSelectionStroke2.Transparency = 1
      parallaxSelectionStroke2.Parent = textButton4

      local categoryText2 = Instance.new("TextLabel")
      categoryText2.Name = "CategoryText"
      categoryText2.BackgroundTransparency = 1
      categoryText2.Position = UDim2.fromOffset(15, 0)
      categoryText2.Size = UDim2.new(1, -23, 1, 0)
      categoryText2.Text = key25 == "VEHICLE PRO" and "Vehicule Pro" or tostring(key25)
      categoryText2.Font = Enum.Font.Gotham
      categoryText2.TextSize = 12
      categoryText2.TextColor3 = color8
      categoryText2.TextStrokeTransparency = 1
      categoryText2.TextXAlignment = Enum.TextXAlignment.Left
      categoryText2.Parent = textButton4

      local indicator2 = Instance.new("Frame")
      indicator2.Name = "Indicator"
      indicator2.Position = UDim2.new(0, 4, 0.5, -9)
      indicator2.Size = UDim2.new(0, 3, 0, 18)
      indicator2.BackgroundColor3 = color6
      indicator2.BorderSizePixel = 0
      indicator2.Visible = false
      indicator2.Parent = textButton4

      corner(indicator2, 2)

      local scrollingFrame2 = Instance.new("ScrollingFrame")
      scrollingFrame2.Size = UDim2.new(1, 0, 1, 0)
      scrollingFrame2.BackgroundTransparency = 1
      scrollingFrame2.BorderSizePixel = 0
      scrollingFrame2.ScrollBarThickness = 3
      scrollingFrame2.ScrollBarImageColor3 = color5
      scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
      scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
      scrollingFrame2.Visible = false
      scrollingFrame2.Parent = frame8

      local uiPadding2 = Instance.new("UIPadding")
      uiPadding2.PaddingLeft = UDim.new(0, 3)
      uiPadding2.PaddingRight = UDim.new(0, 12)
      uiPadding2.PaddingTop = UDim.new(0, 3)
      uiPadding2.PaddingBottom = UDim.new(0, 8)
      uiPadding2.Parent = scrollingFrame2

      local uiListLayout3 = Instance.new("UIListLayout")
      uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
      uiListLayout3.Padding = UDim.new(0, 5)
      uiListLayout3.Parent = scrollingFrame2

      v218[key25] = scrollingFrame2
      v219[key25] = textButton4

      textButton4.MouseButton1Click:Connect(function() selectTab(key25) end)

      textButton4.MouseEnter:Connect(function()
        local parallaxSelectionStroke3 = textButton4:FindFirstChild("ParallaxSelectionStroke")

        if parallaxSelectionStroke3 then
          tweenService:Create(parallaxSelectionStroke3, TweenInfo.new(0.13), {
            Transparency = 0.65,
            Thickness = 0.75,
          }):Play()
        end

        if v221 ~= key25 then
          tweenService:Create(textButton4, TweenInfo.new(0.12), {
            BackgroundColor3 = color4,
          }):Play()
        end
      end)

      textButton4.MouseLeave:Connect(function()
        local parallaxSelectionStroke4 = textButton4:FindFirstChild("ParallaxSelectionStroke")

        if parallaxSelectionStroke4 then
          tweenService:Create(parallaxSelectionStroke4, TweenInfo.new(0.13), {
            Transparency = 1,
          }):Play()
        end

        if v221 ~= key25 then
          tweenService:Create(textButton4, TweenInfo.new(0.12), {
            BackgroundColor3 = color3,
          }):Play()
        end
      end)

      return scrollingFrame2
    end
  end

  local theLynoxBotAdminGui

  function createBaseGUI()
    local playerGui3 = localPlayer:WaitForChild("PlayerGui")

    for index30, value31 in ipairs(v220) do
    end

    table.clear(v220)
    local theLynoxBotAdminGui2 = playerGui3:FindFirstChild("TheLynoxBotAdminGui")

    if theLynoxBotAdminGui2 then
      theLynoxBotAdminGui2:Destroy()
    end

    local lynGUIAlwaysVisible = playerGui3:FindFirstChild("LynGUI_AlwaysVisible")

    if lynGUIAlwaysVisible then
      lynGUIAlwaysVisible:Destroy()
    end

    theLynoxBotAdminGui = Instance.new("ScreenGui")
    theLynoxBotAdminGui.Name = "TheLynoxBotAdminGui"
    theLynoxBotAdminGui.ResetOnSpawn = false
    theLynoxBotAdminGui.IgnoreGuiInset = true
    theLynoxBotAdminGui.DisplayOrder = 9999
    theLynoxBotAdminGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    theLynoxBotAdminGui.Enabled = true
    theLynoxBotAdminGui.Parent = playerGui3

    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(680, 500)
    mainFrame.Position = UDim2.new(0.5, -340, 0.5, -250)
    mainFrame.BackgroundColor3 = color
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = true
    mainFrame.Parent = theLynoxBotAdminGui

    corner(mainFrame, 12)
    stroke(mainFrame, Color3.fromRGB(38, 38, 44), 0.8, 0.35)

    local lynGUIAlwaysVisible2 = Instance.new("ScreenGui")
    lynGUIAlwaysVisible2.Name = "LynGUI_AlwaysVisible"
    lynGUIAlwaysVisible2.ResetOnSpawn = false
    lynGUIAlwaysVisible2.IgnoreGuiInset = true
    lynGUIAlwaysVisible2.DisplayOrder = 10010
    lynGUIAlwaysVisible2.ZIndexBehavior = Enum.ZIndexBehavior.Global
    lynGUIAlwaysVisible2.Parent = playerGui3

    local lynGUIToggle = Instance.new("TextButton")
    lynGUIToggle.Name = "LynGUI_Toggle"
    lynGUIToggle.Size = UDim2.fromOffset(116, 36)
    lynGUIToggle.AnchorPoint = Vector2.new(0.5, 0.5)
    lynGUIToggle.Position = UDim2.fromScale(0.5, 0.075)
    lynGUIToggle.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    lynGUIToggle.BorderSizePixel = 0
    lynGUIToggle.AutoButtonColor = false
    lynGUIToggle.Text = "</>  LynGUI"
    lynGUIToggle.TextColor3 = Color3.fromRGB(236, 236, 241)
    lynGUIToggle.TextSize = 12
    lynGUIToggle.Font = Enum.Font.GothamMedium
    lynGUIToggle.ZIndex = 100
    lynGUIToggle.Parent = lynGUIAlwaysVisible2

    corner(lynGUIToggle, 18)

    local uiStroke3 = Instance.new("UIStroke")
    uiStroke3.Color = Color3.fromRGB(60, 60, 69)
    uiStroke3.Thickness = 0.8
    uiStroke3.Transparency = 0.2
    uiStroke3.Parent = lynGUIToggle

    lynGUIToggle.MouseEnter:Connect(function()
      lynGUIToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
      uiStroke3.Color = Color3.fromRGB(145, 145, 155)
    end)

    lynGUIToggle.MouseLeave:Connect(function()
      lynGUIToggle.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
      uiStroke3.Color = Color3.fromRGB(60, 60, 69)
    end)

    lynGUIToggle.Active = true

    local v228 = false
    local v229 = false
    local position7, position8

    lynGUIToggle.InputBegan:Connect(function(input6)
      if input6.UserInputType == Enum.UserInputType.MouseButton1
        or input6.UserInputType == Enum.UserInputType.Touch then
        v228 = true
        v229 = false
        position7 = input6.Position
        position8 = lynGUIToggle.Position
      end
    end)

    local inputChanged = userInputService.InputChanged

    table.insert(v220, inputChanged:Connect(function(p75)
      if not v228 or not position7 then
        return
      end

      if p75.UserInputType ~= Enum.UserInputType.MouseMovement
        and p75.UserInputType ~= Enum.UserInputType.Touch then
        return
      else
        local v230 = p75.Position - position7

        if v230.Magnitude > 5 then
          v229 = true
        end

        if v229 then
          lynGUIToggle.Position = UDim2.new(
            position8.X.Scale, position8.X.Offset + v230.X, position8.Y.Scale,
            position8.Y.Offset + v230.Y
          )
        end

        return
      end
    end))

    local inputEnded = userInputService.InputEnded

    table.insert(v220, inputEnded:Connect(function(p76)
      if p76.UserInputType == Enum.UserInputType.MouseButton1
        or p76.UserInputType == Enum.UserInputType.Touch then
        v228 = false
      end
    end))

    lynGUIToggle.MouseButton1Click:Connect(function()
      if v229 then
        v229 = false
        return
      end

      mainFrame.Visible = not mainFrame.Visible
    end)

    local parallaxWhiteParticles = Instance.new("Frame")
    parallaxWhiteParticles.Name = "ParallaxWhiteParticles"
    parallaxWhiteParticles.BackgroundTransparency = 1
    parallaxWhiteParticles.Size = UDim2.fromScale(1, 1)
    parallaxWhiteParticles.ClipsDescendants = true
    parallaxWhiteParticles.ZIndex = 1
    parallaxWhiteParticles.Parent = mainFrame

    local random = Random.new(1287)
    local v231 = {}

    for i = 1, 35 do
      local whiteDot = Instance.new("Frame")
      whiteDot.Name = "WhiteDot"
      whiteDot.Size = UDim2.fromOffset(i % 5 == 0 and 2 or 1, i % 5 == 0 and 2 or 1)
      whiteDot.Position = UDim2.fromScale(random:NextNumber(), random:NextNumber())
      whiteDot.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
      whiteDot.BackgroundTransparency = random:NextNumber(0.3, 0.78)
      whiteDot.BorderSizePixel = 0
      whiteDot.ZIndex = 1
      whiteDot.Parent = parallaxWhiteParticles

      v231[i] = {
        node = whiteDot,
        x = whiteDot.Position.X.Scale,
        y = whiteDot.Position.Y.Scale,
        speed = random:NextNumber(0.0016666666666667, 0.0053333333333333),
        drift = random:NextNumber(-0.001, 0.001),
      }
    end

    local connect31 = runService.RenderStepped:Connect(function(delta7)
      if not parallaxWhiteParticles.Parent then
        return
      end

      for index31, value32 in ipairs(v231) do
        value32.y = (value32.y + value32.speed * delta7 * 60) % 1
        value32.x = (value32.x + value32.drift * delta7 * 60) % 1
        value32.node.Position = UDim2.fromScale(value32.x, value32.y)
      end
    end)

    table.insert(v220, connect31)

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
    uiGradient.Rotation = 90
    uiGradient.Parent = mainFrame

    local frame9 = Instance.new("Frame")
    frame9.Size = UDim2.fromOffset(165, 66)
    frame9.BackgroundColor3 = color2
    frame9.BorderSizePixel = 0
    frame9.Parent = mainFrame

    corner(frame9, 9)

    local uiGradient2 = Instance.new("UIGradient")
    uiGradient2.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
    uiGradient2.Rotation = 0
    uiGradient2.Parent = frame9

    local frame10 = Instance.new("Frame")
    frame10.Size = UDim2.new(0, 1, 1, -30)
    frame10.Position = UDim2.fromOffset(165, 20)
    frame10.BorderSizePixel = 0
    frame10.BackgroundColor3 = Color3.new(1, 1, 1)
    frame10.Visible = false
    frame10.Parent = mainFrame

    local uiGradient3 = Instance.new("UIGradient")

    uiGradient3.Color = ColorSequence.new(
      Color3.fromRGB(35, 35, 40), Color3.fromRGB(35, 35, 40)
    )

    uiGradient3.Parent = frame10

    local textLabel9 = Instance.new("TextLabel")
    textLabel9.Size = UDim2.new(1, -12, 0, 29)
    textLabel9.Position = UDim2.fromOffset(54, 18)
    textLabel9.BackgroundTransparency = 1
    textLabel9.RichText = true
    textLabel9.Text = "LynoxBot"
    textLabel9.TextColor3 = color7
    textLabel9.Font = Enum.Font.GothamMedium
    textLabel9.TextSize = 15
    textLabel9.TextXAlignment = Enum.TextXAlignment.Left
    textLabel9.Parent = frame9

    local lynoxLogo = Instance.new("TextLabel")
    lynoxLogo.Name = "LynoxLogo"
    lynoxLogo.BackgroundTransparency = 1
    lynoxLogo.Position = UDim2.fromOffset(16, 21)
    lynoxLogo.Size = UDim2.fromOffset(34, 25)
    lynoxLogo.Text = "</>"
    lynoxLogo.Font = Enum.Font.Code
    lynoxLogo.TextSize = 19
    lynoxLogo.TextColor3 = Color3.fromRGB(220, 220, 225)
    lynoxLogo.TextXAlignment = Enum.TextXAlignment.Center
    lynoxLogo.Parent = frame9

    local textLabel10 = Instance.new("TextLabel")
    textLabel10.Size = UDim2.new(0, 0, 0, 0)
    textLabel10.Position = UDim2.new(0, 0, 0, 0)
    textLabel10.BackgroundTransparency = 1
    textLabel10.Text = "RShift to hide"
    textLabel10.TextColor3 = color8
    textLabel10.Font = Enum.Font.Gotham
    textLabel10.TextSize = 10
    textLabel10.TextXAlignment = Enum.TextXAlignment.Right
    textLabel10.Parent = frame9

    local textButton5 = Instance.new("TextButton")
    textButton5.Size = UDim2.new(0, 28, 0, 28)
    textButton5.Position = UDim2.fromOffset(626, 11)
    textButton5.BackgroundTransparency = 1
    textButton5.Text = "×"
    textButton5.TextColor3 = color8
    textButton5.Font = Enum.Font.GothamBold
    textButton5.TextSize = 15
    textButton5.Parent = mainFrame
    textButton5.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    local textButton6 = Instance.new("TextButton")
    textButton6.Size = UDim2.new(0, 28, 0, 28)
    textButton6.Position = UDim2.fromOffset(594, 11)
    textButton6.BackgroundTransparency = 1
    textButton6.Text = "-"
    textButton6.TextColor3 = color8
    textButton6.Font = Enum.Font.GothamBold
    textButton6.TextSize = 20
    textButton6.Parent = mainFrame

    textButton6.MouseButton1Click:Connect(function()
      mainFrame.Visible = not mainFrame.Visible
    end)

    local v232 = false
    local position9, position10

    local function f21(p77)
      if p77.UserInputType ~= Enum.UserInputType.MouseButton1
        and p77.UserInputType ~= Enum.UserInputType.Touch then
        return
      end

      v232 = true
      position9 = p77.Position
      position10 = mainFrame.Position
    end

    frame9.Active = true
    frame9.InputBegan:Connect(f21)

    local inputChanged2 = userInputService.InputChanged

    table.insert(v220, inputChanged2:Connect(function(p78)
      if not v232 then
        return
      end

      if p78.UserInputType ~= Enum.UserInputType.MouseMovement
        and p78.UserInputType ~= Enum.UserInputType.Touch then
        return
      end

      if not position9 or not position10 then
        return
      else
        local v233 = p78.Position - position9

        mainFrame.Position = UDim2.new(
          position10.X.Scale, position10.X.Offset + v233.X, position10.Y.Scale,
          position10.Y.Offset + v233.Y
        )

        return
      end
    end))

    local inputEnded2 = userInputService.InputEnded

    table.insert(v220, inputEnded2:Connect(function(p79)
      if p79.UserInputType == Enum.UserInputType.MouseButton1
        or p79.UserInputType == Enum.UserInputType.Touch then
        v232 = false
      end
    end))

    local inputBegan = userInputService.InputBegan

    table.insert(v220, inputBegan:Connect(function(p80, p81)
      if p81 then
        return
      end

      if p80.KeyCode == Enum.KeyCode.RightShift or p80.KeyCode == Enum.KeyCode.Minus then
        mainFrame.Visible = not mainFrame.Visible
      end
    end))

    local parallaxSideDivider = Instance.new("Frame")
    parallaxSideDivider.Name = "ParallaxSideDivider"
    parallaxSideDivider.Position = UDim2.fromOffset(165, 14)
    parallaxSideDivider.Size = UDim2.new(0, 1, 1, -28)
    parallaxSideDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
    parallaxSideDivider.BorderSizePixel = 0
    parallaxSideDivider.Visible = false
    parallaxSideDivider.Parent = mainFrame

    categorySidebar = Instance.new("ScrollingFrame")
    categorySidebar.Name = "CategorySidebar"
    categorySidebar.Size = UDim2.new(0, 154, 1, -125)
    categorySidebar.Position = UDim2.fromOffset(6, 78)
    categorySidebar.BackgroundColor3 = color3
    categorySidebar.BorderSizePixel = 0
    categorySidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    categorySidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    categorySidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    categorySidebar.ScrollBarThickness = 0
    categorySidebar.ScrollBarImageColor3 = color5
    categorySidebar.ClipsDescendants = true
    categorySidebar.Parent = mainFrame

    corner(categorySidebar, 0)
    padding(categorySidebar, 7)

    local uiListLayout4 = Instance.new("UIListLayout")
    uiListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout4.Padding = UDim.new(0, 3)
    uiListLayout4.Parent = categorySidebar

    local shiftHint = Instance.new("TextLabel")
    shiftHint.Name = "ShiftHint"
    shiftHint.Position = UDim2.new(0, 16, 1, -30)
    shiftHint.Size = UDim2.fromOffset(139, 19)
    shiftHint.BackgroundTransparency = 1
    shiftHint.Text = "[ RShift ]  to hide"
    shiftHint.TextColor3 = Color3.fromRGB(105, 105, 117)
    shiftHint.TextSize = 10
    shiftHint.Font = Enum.Font.Gotham
    shiftHint.TextXAlignment = Enum.TextXAlignment.Left
    shiftHint.Parent = mainFrame

    frame8 = Instance.new("Frame")
    frame8.Size = UDim2.new(1, -208, 1, -126)
    frame8.Position = UDim2.fromOffset(188, 114)
    frame8.BackgroundTransparency = 1
    frame8.ClipsDescendants = false
    frame8.Parent = mainFrame

    local parallaxPageHeading2 = Instance.new("TextLabel")
    parallaxPageHeading2.Name = "ParallaxPageHeading"
    parallaxPageHeading2.Position = UDim2.fromOffset(190, 16)
    parallaxPageHeading2.Size = UDim2.new(1, -210, 0, 25)
    parallaxPageHeading2.BackgroundTransparency = 1
    parallaxPageHeading2.Text = "Main"
    parallaxPageHeading2.TextColor3 = color7
    parallaxPageHeading2.Font = Enum.Font.GothamMedium
    parallaxPageHeading2.TextSize = 18
    parallaxPageHeading2.TextXAlignment = Enum.TextXAlignment.Left
    parallaxPageHeading2.Parent = mainFrame
    parallaxPageHeading2.Active = true
    parallaxPageHeading2.InputBegan:Connect(f21)



    local textLabel11 = Instance.new("TextLabel")
    textLabel11.Position = UDim2.fromOffset(190, 43)
    textLabel11.Size = UDim2.new(1, -210, 0, 17)
    textLabel11.BackgroundTransparency = 1
    textLabel11.Text = "General features"
    textLabel11.TextColor3 = color8
    textLabel11.Font = Enum.Font.Gotham
    textLabel11.TextSize = 11
    textLabel11.TextXAlignment = Enum.TextXAlignment.Left
    textLabel11.Parent = mainFrame
    textLabel11.Active = true
    textLabel11.InputBegan:Connect(f21)

    local parallaxQuickTabs2 = Instance.new("Frame")
    parallaxQuickTabs2.Name = "ParallaxQuickTabs"
    parallaxQuickTabs2.Position = UDim2.fromOffset(190, 67)
    parallaxQuickTabs2.Size = UDim2.fromOffset(280, 35)
    parallaxQuickTabs2.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
    parallaxQuickTabs2.Parent = mainFrame

    corner(parallaxQuickTabs2, 9)
    stroke(parallaxQuickTabs2, Color3.fromRGB(36, 36, 42), 1, 0)

    for index32, value33 in ipairs({
      { "General", "Joueur" }, { "Vehicle", "VEHICLE PRO" }, { "Visuals", "Visuel" },
      { "Places", "Téléport" },
    }) do
      local v234 = value33

      local textButton7 = Instance.new("TextButton")
      textButton7.Name = "Quick" .. v234[1]
      textButton7.Size = UDim2.fromOffset(66, 27)
      textButton7.Position = UDim2.fromOffset(4 + (index32 - 1) * 69, 4)

      textButton7.BackgroundColor3 = index32 == 1 and Color3.fromRGB(235, 235, 240)
        or Color3.fromRGB(13, 13, 16)

      textButton7.TextColor3 = index32 == 1 and Color3.fromRGB(15, 15, 18) or color8
      textButton7.Text = v234[1]
      textButton7.Font = Enum.Font.GothamMedium
      textButton7.TextSize = 11
      textButton7.Parent = parallaxQuickTabs2

      corner(textButton7, 7)
      textButton7.MouseButton1Click:Connect(function() selectTab(v234[2]) end)
    end

    table.clear(v218)
    table.clear(v219)

    v221 = nil
  end
end

runService.RenderStepped:Connect(function()
  if v28 then
    for index33, value34 in ipairs(players:GetPlayers()) do
      if value34 ~= localPlayer then
        updateCheatLine(value34, (createCheatLine(value34)))
      end
    end
  end

  if v29 then
    for index34, value35 in ipairs(players:GetPlayers()) do
      if value35 ~= localPlayer then
        local character67 = value35.Character

        local head6 = character67
        head6 = character67 and character67:FindFirstChild("Head")

        local humanoidRootPart55 = character67
        humanoidRootPart55 = character67 and character67:FindFirstChild("HumanoidRootPart")

        if character67 and head6 and humanoidRootPart55 then
          if not v31[value35] or not v31[value35].Parent then
            createTracker(value35)
          end

          local v235 = v32[value35]

          if v235 then
            local textLabel12 = v235:FindFirstChildOfClass("TextLabel")

            if textLabel12 then
              local character68 = localPlayer.Character

              local humanoidRootPart56 = character68

              humanoidRootPart56 = character68
                and character68:FindFirstChild("HumanoidRootPart")

              local v236 = humanoidRootPart56
                  and math.floor((humanoidRootPart55.Position
                    - humanoidRootPart56.Position).Magnitude)
                or 0

              textLabel12.Text = string.format("TRACKER  •  %s  •  %dm", value35.Name, v236)
            end
          end
        end
      end
    end
  end
end)

players.PlayerRemoving:Connect(function(player2)
  removeESPTag(player2)
  destroySkeleton(player2)
  removeCheatLine(player2)
  removeTracker(player2)
end)

local v237 = { kills = 0, deaths = 0, watched = {} }
v238 = nil

local function f22()
  if v238 and v238.Parent then
    v238.Text = string.format(
      "Kills : %d  |  Morts : %d  |  K/D : %.2f", v237.kills, v237.deaths,
      v237.kills / math.max(1, v237.deaths)
    )
  end
end

do
  local function f23(p82, p83)
    local waitForChild2 = p83:WaitForChild("Humanoid", 10)

    if not waitForChild2 then
      return
    end

    if v237.watched[waitForChild2] then
      return
    end

    v237.watched[waitForChild2] = true

    waitForChild2.Died:Connect(function()
      if p82 == localPlayer then
        v237.deaths = v237.deaths + 1
      end

      local creator = waitForChild2:FindFirstChild("creator")
        or waitForChild2:FindFirstChild("Creator")

      if creator and creator:IsA("ObjectValue") and creator.Value == localPlayer
        and p82 ~= localPlayer then
        v237.kills = v237.kills + 1
      end

      f22()
      v237.watched[waitForChild2] = nil
    end)
  end

  for index35, value36 in ipairs(players:GetPlayers()) do
    local v239 = value36
    v239.CharacterAdded:Connect(function(character69) task.spawn(f23, v239, character69) end)

    if v239.Character then
      task.spawn(f23, v239, v239.Character)
    end
  end

  players.PlayerAdded:Connect(function(player3)
    player3.CharacterAdded:Connect(function(character70)
      task.spawn(f23, player3, character70)
    end)
  end)
end

local v240 = false
local v241 = {}

local function f24()
  v240 = not v240
  local playerGui4 = localPlayer:FindFirstChildOfClass("PlayerGui")

  if v240 then
    table.clear(v241)

    if playerGui4 then
      for index36, value37 in ipairs(playerGui4:GetChildren()) do
        if value37:IsA("ScreenGui") and value37.Enabled then
          v241[value37] = true
          value37.Enabled = false
        end
      end
    end
  else
    for key26 in pairs(v241) do
      if key26 and key26.Parent then
        key26.Enabled = true
      end
    end

    table.clear(v241)
  end

  if v242 and v242.Parent then
    local v243 = v242
    v243.Text = v240 and "Photo Mode : ON (F8 pour quitter)" or "Photo Mode : OFF (F8)"
  end
end

userInputService.InputBegan:Connect(function(input7, p84)
  if input7.KeyCode == Enum.KeyCode.F8 and not userInputService:GetFocusedTextBox() then
    f24()
  end
end)

lynoxLowerGunEnabled = false
lynoxLowerGunOriginal = setmetatable({}, { __mode = "k" })

function lynoxApplyLowerGun(key27)
  if not key27 or not key27:IsA("Tool") then
    return
  end

  if not lynoxLowerGunOriginal[key27] then
    lynoxLowerGunOriginal[key27] = key27.Grip
  end

  key27.Grip = lynoxLowerGunOriginal[key27] * CFrame.Angles(math.rad(-75), 0, 0)
end

function lynoxRestoreLowerGun()
  for key28, value38 in pairs(lynoxLowerGunOriginal) do
    local v244 = key28
    local grip = value38

    if v244 and v244.Parent then
      pcall(function() v244.Grip = grip end)
    end
  end
end

function lynoxToggleLowerGun(p85)
  lynoxLowerGunEnabled = not lynoxLowerGunEnabled

  if lynoxLowerGunEnabled then
    local character71 = localPlayer.Character

    if character71 then
      for index37, value39 in ipairs(character71:GetChildren()) do
        if value39:IsA("Tool") then
          lynoxApplyLowerGun(value39)
        end
      end
    end
  else
    lynoxRestoreLowerGun()
  end

  if p85 then
    p85(lynoxLowerGunEnabled)
  end

  makeTextLabel("LOWER GUN (TEST)", lynoxLowerGunEnabled and "ON" or "OFF")
end

localPlayer.CharacterAdded:Connect(function(character72)
  character72.ChildAdded:Connect(function(child)
    if lynoxLowerGunEnabled and child:IsA("Tool") then
      task.defer(function()
        if lynoxLowerGunEnabled and child.Parent == character72 then
          lynoxApplyLowerGun(child)
        end
      end)
    end
  end)
end)

if localPlayer.Character then
  localPlayer.Character.ChildAdded:Connect(function(child2)
    if lynoxLowerGunEnabled and child2:IsA("Tool") then
      task.defer(function()
        if lynoxLowerGunEnabled and child2.Parent == localPlayer.Character then
          lynoxApplyLowerGun(child2)
        end
      end)
    end
  end)
end

lynoxGunPose = "NORMAL"
lynoxGunGripBase = setmetatable({}, { __mode = "k" })

lynoxGunPoses = {
  { "NORMAL", 0, 0, 0 }, { "BAISSEE", -75, 0, 0 }, { "TRES BASSE", -115, 0, 0 },
  { "LEVEE", 55, 0, 0 }, { "VERS LE CIEL", 90, 0, 0 }, { "VERS LE SOL", -90, 0, 0 },
  { "GAUCHE", 0, -75, 0 }, { "DROITE", 0, 75, 0 }, { "DIAGONALE HAUT GAUCHE", 45, -45, 0 },
  { "DIAGONALE HAUT DROITE", 45, 45, 0 }, { "DIAGONALE BAS GAUCHE", -45, -45, 0 },
  { "DIAGONALE BAS DROITE", -45, 45, 0 }, { "SUR LE COTE GAUCHE", 0, 0, -90 },
  { "SUR LE COTE DROIT", 0, 0, 90 }, { "RETOURNEE", 0, 0, 180 }, { "EPAULE", -30, 0, 60 },
}

function lynoxSetGunPose(p86, index38, index39, index40)
  lynoxGunPose = p86
  lynoxLowerGunEnabled = false
  local character73 = localPlayer.Character

  if character73 then
    for index41, value40 in ipairs(character73:GetChildren()) do
      if value40:IsA("Tool") then
        if not lynoxGunGripBase[value40] then
          lynoxGunGripBase[value40] = value40.Grip
        end

        value40.Grip = lynoxGunGripBase[value40]
          * CFrame.Angles(math.rad(index38), math.rad(index39), math.rad(index40))
      end
    end
  end

  makeTextLabel("GUN : " .. p86, "ON")
end

lynoxMapLimitEnabled = false
lynoxMapLimitMinY = 25
lynoxMapLimitMaxY = 155

function buildMapLimitUI()
  local v245 = newCard(newTab(21, "SAFETY+", ""), 3, "MAP LIMIT — PLAFOND ET SOL INVISIBLES")

  newInfoLabel(
    v245, 1,
    "Limite de hauteur locale sur toute la carte : minimum Y = 25, maximum Y = 155. Fonctionne avec Fly et la voiture conduite (carrosserie incluse). Limite locale, non serveur.",
    75
  )

  local mapLimitToggle = Instance.new("TextButton")
  mapLimitToggle.Name = "MapLimitToggle"
  mapLimitToggle.Size = UDim2.new(1, -16, 0, 42)
  mapLimitToggle.BackgroundColor3 = color5
  mapLimitToggle.TextColor3 = color7
  mapLimitToggle.Font = Enum.Font.GothamBold
  mapLimitToggle.TextSize = 13
  mapLimitToggle.Text = "MAP LIMIT : OFF"
  mapLimitToggle.Parent = v245

  local uiCorner9 = Instance.new("UICorner")
  uiCorner9.CornerRadius = UDim.new(0, 9)
  uiCorner9.Parent = mapLimitToggle

  mapLimitToggle.MouseButton1Click:Connect(function()
    lynoxMapLimitEnabled = not lynoxMapLimitEnabled

    mapLimitToggle.Text = lynoxMapLimitEnabled and "MAP LIMIT : ON (Y 25 - 155)"
      or "MAP LIMIT : OFF"

    mapLimitToggle.BackgroundColor3 = lynoxMapLimitEnabled and Color3.fromRGB(43, 105, 75)
      or color5

    makeTextLabel("MAP LIMIT", lynoxMapLimitEnabled and "ON" or "OFF")
  end)
end

function lynoxGetDrivenVehicle(p87)
  if not p87 or not p87:IsA("VehicleSeat") then
    return nil
  else
    local model3 = p87:FindFirstAncestorOfClass("Model")

    if not model3 or model3 == localPlayer.Character then
      return nil
    end

    return model3
  end
end

function lynoxClampVehicle(index42)
  local v246 = {}
  local v247 = -math.huge
  local huge = math.huge

  for index43, value41 in ipairs(index42:GetDescendants()) do
    if value41:IsA("BasePart") then
      table.insert(v246, value41)
      local v248 = value41.Size * 0.5
      local cframe16 = value41.CFrame

      local v249 = math.abs(cframe16.RightVector.Y) * v248.X
        + math.abs(cframe16.UpVector.Y) * v248.Y + math.abs(cframe16.LookVector.Y) * v248.Z

      huge = math.min(huge, value41.Position.Y - v249)
      v247 = math.max(v247, value41.Position.Y + v249)
    end
  end

  if #v246 == 0 then
    return
  else
    local v250 = 0

    if v247 - huge > lynoxMapLimitMaxY - lynoxMapLimitMinY then
      v250 = (lynoxMapLimitMinY + lynoxMapLimitMaxY) * 0.5 - (huge + v247) * 0.5
    elseif v247 > lynoxMapLimitMaxY then
      v250 = lynoxMapLimitMaxY - v247
    elseif huge < lynoxMapLimitMinY then
      v250 = lynoxMapLimitMinY - huge
    end

    if math.abs(v250) > 0.001 then
      index42:PivotTo(index42:GetPivot() + Vector3.new(0, v250, 0))

      for index44, value42 in ipairs(v246) do
        local assemblyLinearVelocity6 = value42.AssemblyLinearVelocity

        value42.AssemblyLinearVelocity = Vector3.new(
          assemblyLinearVelocity6.X, 0, assemblyLinearVelocity6.Z
        )
      end
    end

    return
  end
end

runService.Heartbeat:Connect(function()
  if not lynoxMapLimitEnabled then
    return
  else
    local character74 = localPlayer.Character
    local humanoidRootPart57 = character74 and character74:FindFirstChild("HumanoidRootPart")

    local humanoid46 = character74
    humanoid46 = character74 and character74:FindFirstChildOfClass("Humanoid")

    local v251 = not humanoidRootPart57
    local v252 = humanoid46

    if v251 or not v252 or v252.Health <= 0 then
      return
    else
      local v253 = lynoxGetDrivenVehicle(v252.SeatPart)

      if v253 then
        lynoxClampVehicle(v253)
        return
      else
        local position11 = humanoidRootPart57.Position
        local v254 = math.clamp(position11.Y, lynoxMapLimitMinY, lynoxMapLimitMaxY)

        if v254 ~= position11.Y then
          humanoidRootPart57.CFrame = CFrame.new(position11.X, v254, position11.Z)
            * humanoidRootPart57.CFrame.Rotation

          local assemblyLinearVelocity7 = humanoidRootPart57.AssemblyLinearVelocity

          humanoidRootPart57.AssemblyLinearVelocity = Vector3.new(
            assemblyLinearVelocity7.X, 0, assemblyLinearVelocity7.Z
          )
        end

        return
      end
    end
  end
end)

function buildGunUI()
  local v255 = newTab(11, "GUN", "")

  newInfoLabel(
    newCard(v255, 10, "GUN POSITIONS"), 1,
    "Equipe ton arme puis choisis une position. Les effets sont locaux : a verifier avec un deuxieme compte.",
    56
  )

  local function makeTextButton3(text11, p88, p89)
    local parent9 = newCard(v255, p89, text11)

    local textButton8 = Instance.new("TextButton")
    textButton8.Name = "Get" .. text11:gsub("[^%w]", "")
    textButton8.Size = UDim2.new(1, -8, 0, 37)
    textButton8.LayoutOrder = 1
    textButton8.BackgroundColor3 = color4
    textButton8.TextColor3 = color7
    textButton8.Text = "GET " .. text11
    textButton8.TextSize = 12
    textButton8.Font = Enum.Font.GothamBold
    textButton8.AutoButtonColor = true
    textButton8.Parent = parent9

    corner(textButton8, 8)
    stroke(textButton8, color5, 1, 0.4)

    textButton8.MouseButton1Click:Connect(function()
      local character75

      if textButton8:GetAttribute("Busy") then
        return
      else
        character75 = localPlayer.Character

        local humanoidRootPart58 = character75
          and character75:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart58 then
          return
        end

        textButton8:SetAttribute("Busy", true)

        task.spawn(function()
          local cframe17 = humanoidRootPart58.CFrame

          local v256, v257 = pcall(function()
            for j = 1, 3 do
              for index45, value43 in ipairs(p88) do
                if localPlayer.Character ~= character75 or not humanoidRootPart58.Parent then
                  return
                end

                humanoidRootPart58.CFrame = CFrame.new(value43)
                humanoidRootPart58.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart58.AssemblyAngularVelocity = Vector3.zero

                task.wait(0.05)
              end
            end
          end)

          if localPlayer.Character == character75 and humanoidRootPart58.Parent then
            humanoidRootPart58.CFrame = cframe17
            humanoidRootPart58.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart58.AssemblyAngularVelocity = Vector3.zero
          end

          textButton8:SetAttribute("Busy", false)

          if not v256 then
            warn("Weapon TP error: " .. tostring(v257))
          end
        end)

        return
      end
    end)
  end

  makeTextButton3("M4A1", { Vector3.new(848, 99, 2231), Vector3.new(848, 100, 2230) }, 1)

  makeTextButton3(
    "Remington 870", { Vector3.new(820, 99, 2231), Vector3.new(819, 100, 2230) }, 2
  )

  makeTextButton3("MP5", { Vector3.new(813, 99, 2231), Vector3.new(814, 100, 2230) }, 3)
  makeTextButton3("M700", { Vector3.new(835, 99, 2231), Vector3.new(835, 100, 2230) }, 4)

  local parent10 = newCard(v255, 11, "POSITIONS DE L'ARME")

  for index46, value44 in ipairs(lynoxGunPoses) do
    local v258 = value44

    local textButton9 = Instance.new("TextButton")
    textButton9.Name = "GunPose_" .. tostring(index46)
    textButton9.Size = UDim2.new(1, -8, 0, 37)
    textButton9.LayoutOrder = index46
    textButton9.BackgroundColor3 = color4
    textButton9.TextColor3 = color7
    textButton9.Text = v258[1]
    textButton9.TextSize = 12
    textButton9.Font = Enum.Font.GothamBold
    textButton9.AutoButtonColor = true
    textButton9.Parent = parent10

    corner(textButton9, 8)
    stroke(textButton9, color5, 1, 0.4)

    textButton9.MouseButton1Click:Connect(function()
      lynoxSetGunPose(v258[1], v258[2], v258[3], v258[4])
    end)
  end
end

localPlayer.CharacterAdded:Connect(function(character76)
  character76.ChildAdded:Connect(function(child3)
    if not child3:IsA("Tool") then
      return
    end

    task.defer(function()
      if lynoxGunPose == "NORMAL" then
        return
      end

      for index47, value45 in ipairs(lynoxGunPoses) do
        if value45[1] == lynoxGunPose then
          lynoxSetGunPose(value45[1], value45[2], value45[3], value45[4])
          break
        end
      end
    end)
  end)
end)

function buildPlayerUI()
  local v259 = newTab(1, "Joueur", "")

  local v260 = newCard(v259, 1, "PROFIL")
  v260.Size = UDim2.new(1, 0, 0, 116)
  v260.AutomaticSize = Enum.AutomaticSize.None

  local uiListLayout5 = v260:FindFirstChildOfClass("UIListLayout")

  if uiListLayout5 then
    uiListLayout5:Destroy()
  end

  local playerHead = Instance.new("ImageLabel")
  playerHead.Name = "PlayerHead"
  playerHead.Size = UDim2.new(0, 72, 0, 72)
  playerHead.Position = UDim2.new(0, 10, 0, 34)
  playerHead.BackgroundColor3 = color2
  playerHead.BorderSizePixel = 0
  playerHead.Parent = v260

  corner(playerHead, 36)

  local v261, image = pcall(function()
    return players:GetUserThumbnailAsync(
      localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150
    )
  end)

  if v261 then
    playerHead.Image = image
  end

  local displayName = Instance.new("TextLabel")
  displayName.Name = "DisplayName"
  displayName.Size = UDim2.new(1, -96, 0, 30)
  displayName.Position = UDim2.new(0, 94, 0, 38)
  displayName.BackgroundTransparency = 1
  displayName.Text = localPlayer.DisplayName
  displayName.TextColor3 = color7
  displayName.Font = Enum.Font.GothamBold
  displayName.TextSize = 17
  displayName.TextXAlignment = Enum.TextXAlignment.Left
  displayName.TextTruncate = Enum.TextTruncate.AtEnd
  displayName.Parent = v260

  local username = Instance.new("TextLabel")
  username.Name = "Username"
  username.Size = UDim2.new(1, -96, 0, 24)
  username.Position = UDim2.new(0, 94, 0, 68)
  username.BackgroundTransparency = 1
  username.Text = "@" .. localPlayer.Name
  username.TextColor3 = color8
  username.Font = Enum.Font.Gotham
  username.TextSize = 13
  username.TextXAlignment = Enum.TextXAlignment.Left
  username.TextTruncate = Enum.TextTruncate.AtEnd
  username.Parent = v260

  local v262 = newCard(v259, 2, "HEURE ET DATE")

  local v263 = newInfoLabel(v262, 1, "--:--:--", 30)
  v263.TextSize = 24

  local v264 = newInfoLabel(v262, 2, "", 22)
  v264.TextColor3 = color8
  v264.Font = Enum.Font.Gotham
  v264.TextSize = 14

  local v265 = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }

  local v266 = {
    "janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre",
    "octobre", "novembre", "décembre",
  }

  task.spawn(function()
    while v263.Parent do
      local t = os.date("*t")
      v263.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
      v264.Text = string.format("%s %d %s %d", v265[t.wday], t.day, v266[t.month], t.year)
      task.wait(0.5)
    end
  end)

  v238 = newInfoLabel(
    newCard(v259, 89, "KILL COUNTER"), 1, "Kills : 0  |  Morts : 0  |  K/D : 0.00", 32
  )

  f22()
  local v267 = newCard(v259, 90, "SESSION TIMER")
  local v268 = newInfoLabel(v267, 1, "Temps de jeu : 00:00:00", 32)
  local v269 = newCard(v259, 91, "PLAYER INSPECTOR")
  local v270 = newInfoLabel(v269, 1, "Selectionne un joueur ci-dessous", 28)
  local v271 = newInfoLabel(v269, 2, "Equipe : --", 25)
  local v272 = newInfoLabel(v269, 3, "PV : --", 25)
  local v273 = newInfoLabel(v269, 4, "Distance : --", 25)
  local v274

  local function f25()
    local v275 = v274

    if not v275 or v275.Parent ~= players then
      return
    else
      local character77 = v275.Character
      local humanoid47 = character77 and character77:FindFirstChildOfClass("Humanoid")
      local humanoidRootPart59 = character77 and character77:FindFirstChild("HumanoidRootPart")

      local humanoidRootPart60 = localPlayer.Character
        and localPlayer.Character:FindFirstChild("HumanoidRootPart")

      v270.Text = v275.DisplayName .. " (@" .. v275.Name .. ")"
      v271.Text = "Equipe : " .. (v275.Team and v275.Team.Name or "Neutre")

      v272.Text = "PV : "
        .. (humanoid47
            and math.floor(humanoid47.Health) .. " / " .. math.floor(humanoid47.MaxHealth)
          or "Indisponibles")

      v273.Text = "Distance : "
        .. (humanoidRootPart59
            and humanoidRootPart60
            and math.floor((humanoidRootPart59.Position - humanoidRootPart60.Position).Magnitude)
              .. " studs"
          or "Indisponible")

      return
    end
  end

  newPlayerList(v269, 5, function(p90)
    if not p90 or not p90:IsA("Player") then
      return
    end

    v274 = p90
    f25()
  end, false)

  task.spawn(function()
    while v269.Parent do
      if v274 then
        f25()
      end

      task.wait(0.5)
    end
  end)

  local v276 = os.clock()

  task.spawn(function()
    while v267.Parent do
      local v277 = math.floor(os.clock() - v276)

      if v268 and v268.Parent and v268:IsA("TextLabel") then
        v268.Text = string.format(
          "Temps de jeu : %02d:%02d:%02d", math.floor(v277 / 3600), math.floor(v277 / 60) % 60,
          v277 % 60
        )
      end

      task.wait(1)
    end
  end)
end

backwardVisualEnabled = false

function toggleBackwardVisual(fn21)
  backwardVisualEnabled = not backwardVisualEnabled
  fn21(backwardVisualEnabled)
end

do
  runService.Heartbeat:Connect(function()
    if not backwardVisualEnabled then
      return
    else
      local character78 = localPlayer.Character
      local humanoid48 = character78 and character78:FindFirstChildOfClass("Humanoid")
      local humanoidRootPart61 = character78 and character78:FindFirstChild("HumanoidRootPart")

      if humanoid48 and humanoidRootPart61 and humanoid48.MoveDirection.Magnitude > 0.1 then
        humanoidRootPart61.CFrame = CFrame.lookAt(humanoidRootPart61.Position, humanoidRootPart61.Position
          - humanoid48.MoveDirection)
      end

      return
    end
  end)

  function buildMovementUI()
    local v278 = newTab(2, "Mouvement", "")
    local v279 = newCard(v278, 1, "FLY")
    newSwitch(v279, 1, "Activer le vol (G)", toggleFly)

    newStepper(v279, 2, "Vitesse", v5, 10, function(p91)
      v5 = math.clamp(p91, 10, 300)
      return v5
    end)

    newStepper(newCard(v278, 2, "VITESSE DE MARCHE"), 1, "WalkSpeed", v6, 4, setWalkSpeed)
    newStepper(newCard(v278, 3, "GRAVITÉ"), 1, "Gravity", gravity, 10, setGravity)

    local v280 = newCard(v278, 4, "SAUT")

    newSwitch(v280, 1, "Saut infini", toggleInfiniteJump)
    newSwitch(v280, 2, "Float", toggleFloat)

    newStepper(v280, 3, "Puissance du saut", v15.jumpPower, 5, function(p92)
      v15.jumpPower = math.clamp(p92, 0, 300)
      return v15.jumpPower
    end)

    newSwitch(newCard(v278, 5, "COLLISIONS"), 1, "Noclip (traverser les murs)", toggleNoclip)
    local v281 = newCard(v278, 7, "MARCHER AU PLAFOND")
    newSwitch(v281, 1, "Activer (collé au plafond)", toggleCeilingWalk)

    newStepper(v281, 2, "Décalage", v21, 0.5, function(p93)
      v21 = math.clamp(p93, 0, 8)
      return v21
    end)

    local v282 = newCard(v278, 8, "VÉHICULE")
    newSwitch(v282, 1, "Vehicle Fly", toggleVehicleFly)

    newStepper(v282, 2, "Vitesse Fly", v18, 50, function(p94)
      v18 = math.clamp(p94, 10, 1000)
      return v18
    end)
  end

  function buildPersonnageUI()
    local v283 = newTab(3, "Personnage", "")

    newSwitch(
      newCard(v283, 1, "TOMBER DANS LE VIDE"), 1, "Tomber dans le vide (T)", toggleCrawl
    )

    newSwitch(
      newCard(v283, 2, "MARCHER SUR LE CÔTÉ (JAMBE / TORSE)"), 1,
      "Marcher sur le côté gauche", toggleSideWalk
    )

    newSwitch(
      newCard(v283, 3, "MARCHE ARRIÈRE VISUELLE"), 1, "Marcher en arrière (visuel)",
      toggleBackwardVisual
    )

    newSwitch(
      newCard(v283, 4, "S'ASSEOIR / SE RELEVER"), 1, "S'asseoir / Se relever", toggleSit
    )
  end

  function buildTeleportUI()
    local v284 = newTab(3, "Téléport", "")
    newPlayerList(newCard(v284, 1, "TÉLÉPORTER VERS UN JOUEUR"), 1, teleportToPlayer)

    newSwitch(
      newCard(v284, 2, "TÉLÉPORTATION AU CLIC"), 1,
      "Cliquer sur une porte / un mur / un objet = TP", toggleClickTeleport
    )

    local v285 = newCard(v284, 3, "TÉLÉPORTER EN X Y Z")

    local frame11 = Instance.new("Frame")
    frame11.Size = UDim2.new(1, 0, 0, 30)
    frame11.BackgroundTransparency = 1
    frame11.LayoutOrder = 1
    frame11.Parent = v285

    function newCoordBox(p95, placeholderText)
      local textBox = Instance.new("TextBox")
      textBox.Position = UDim2.new(p95, 0, 0, 0)
      textBox.Size = UDim2.new(0.32, 0, 1, 0)
      textBox.BackgroundColor3 = color2
      textBox.PlaceholderText = placeholderText
      textBox.Text = ""
      textBox.TextColor3 = color7
      textBox.PlaceholderColor3 = color8
      textBox.Font = Enum.Font.Gotham
      textBox.TextSize = 13
      textBox.ClearTextOnFocus = false
      textBox.Parent = frame11

      corner(textBox, 6)
      return textBox
    end

    local v286 = newCoordBox(0, "X")
    local v287 = newCoordBox(0.34, "Y")
    local v288 = newCoordBox(0.68, "Z")

    newAction(v285, 2, "Téléporter", function()
      teleportToCoordinates(
        tonumber(v286.Text) or 0, tonumber(v287.Text) or 0, tonumber(v288.Text) or 0
      )
    end)

    newAction(
      newCard(v284, 4, "OUTIL TPLYNOX (CLIC = TÉLÉPORTATION)"), 1, "Donner l'outil TPLynox",
      createTPTool
    )

    function v15.buildUI(p96)
      local v289 = newCard(p96, 5, "CHECKPOINTS NOMMÉS")

      local textBox2 = Instance.new("TextBox")
      textBox2.Size = UDim2.new(1, 0, 0, 32)
      textBox2.BackgroundColor3 = color2
      textBox2.Text = ""
      textBox2.PlaceholderText = "Nom : Spawn, Boss, Secret..."
      textBox2.TextColor3 = color7
      textBox2.PlaceholderColor3 = color8
      textBox2.Font = Enum.Font.Gotham
      textBox2.TextSize = 12
      textBox2.ClearTextOnFocus = false
      textBox2.LayoutOrder = 1
      textBox2.Parent = v289

      corner(textBox2, 8)

      newAction(v289, 2, "Créer ici", function()
        if setCheckpoint(textBox2.Text) then
          textBox2.Text = ""
        end
      end)

      local frame12 = Instance.new("Frame")
      frame12.Size = UDim2.new(1, 0, 0, 0)
      frame12.AutomaticSize = Enum.AutomaticSize.Y
      frame12.BackgroundTransparency = 1
      frame12.LayoutOrder = 3
      frame12.Parent = v289

      local checkpointListLayout = Instance.new("UIListLayout")
      checkpointListLayout.Name = "CheckpointListLayout"
      checkpointListLayout.SortOrder = Enum.SortOrder.LayoutOrder
      checkpointListLayout.Padding = UDim.new(0, 5)
      checkpointListLayout.Parent = frame12

      function v15.refresh()
        for index48, value46 in ipairs(frame12:GetChildren()) do
          if value46:IsA("Frame") then
            value46:Destroy()
          end
        end

        local v290 = {}

        for key29 in pairs(v15.points) do
          table.insert(v290, key29)
        end

        table.sort(v290, function(p97, p98) return string.lower(p97) < string.lower(p98) end)

        if #v290 == 0 then
          newInfoLabel(frame12, 1, "Aucun checkpoint sauvegardé.", 22).TextColor3 = color8
          return
        end

        for index49, value47 in ipairs(v290) do
          local v291 = value47

          local frame13 = Instance.new("Frame")
          frame13.Size = UDim2.new(1, 0, 0, 34)
          frame13.BackgroundColor3 = v291 == v15.activeName and color6 or color2
          frame13.BorderSizePixel = 0
          frame13.LayoutOrder = index49
          frame13.Parent = frame12

          corner(frame13, 8)

          local textButton10 = Instance.new("TextButton")
          textButton10.Size = UDim2.new(1, -140, 1, 0)
          textButton10.BackgroundTransparency = 1
          textButton10.Text = (v291 == v15.activeName and " " or " ") .. v291
          textButton10.TextColor3 = v291 == v15.activeName and color2 or color7
          textButton10.Font = Enum.Font.GothamBold
          textButton10.TextSize = 12
          textButton10.TextXAlignment = Enum.TextXAlignment.Left
          textButton10.Parent = frame13

          padding(textButton10, 8, 0, 0, 0)
          textButton10.MouseButton1Click:Connect(function() selectCheckpoint(v291) end)

          local textButton11 = Instance.new("TextButton")
          textButton11.Position = UDim2.new(1, -132, 0, 3)
          textButton11.Size = UDim2.new(0, 58, 0, 28)
          textButton11.BackgroundColor3 = color5
          textButton11.Text = "TP"
          textButton11.TextColor3 = color7
          textButton11.Font = Enum.Font.GothamBold
          textButton11.TextSize = 12
          textButton11.AutoButtonColor = false
          textButton11.Parent = frame13

          corner(textButton11, 7)
          textButton11.MouseButton1Click:Connect(function() teleportToCheckpoint(v291) end)

          local textButton12 = Instance.new("TextButton")
          textButton12.Position = UDim2.new(1, -68, 0, 3)
          textButton12.Size = UDim2.new(0, 62, 0, 28)
          textButton12.BackgroundColor3 = Color3.fromRGB(90, 45, 55)
          textButton12.Text = "X"
          textButton12.TextColor3 = color7
          textButton12.Font = Enum.Font.GothamBold
          textButton12.TextSize = 12
          textButton12.AutoButtonColor = false
          textButton12.Parent = frame13

          corner(textButton12, 7)
          textButton12.MouseButton1Click:Connect(function() deleteCheckpoint(v291) end)
        end
      end

      newAction(v289, 4, "RESPAWN AU CHECKPOINT", respawnAtCheckpoint)
      local v292 = newInfoLabel(v289, 5, "Checkpoint sélectionné : aucun", 22)
      local refresh = v15.refresh

      function v15.refresh()
        refresh()
        v292.Text = "Checkpoint sélectionné : " .. (v15.activeName or "aucun")
      end

      newAction(v289, 6, "Effacer tous les checkpoints", clearCheckpoints)
      v15.refresh()
    end

    v15.buildUI(v284)

    local v293 = newInfoLabel(newCard(v284, 5, "POSITION ACTUELLE"), 1, "X: 0 | Y: 0 | Z: 0")

    runService.Heartbeat:Connect(function()
      local character79 = localPlayer.Character
      local humanoidRootPart62 = character79 and character79:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart62 then
        local position12 = humanoidRootPart62.Position

        v293.Text = string.format(
          "X: %d | Y: %d | Z: %d", position12.X, position12.Y, position12.Z
        )
      end
    end)
  end

  function buildCameraUI()
    local v294 = newTab(4, "Caméra", "")
    local v295 = newCard(v294, 1, "FREE CAM")
    newSwitch(v295, 1, "Activer (clic droit = regarder)", toggleFreeCam)

    newStepper(v295, 2, "Vitesse", v181, 10, function(p99)
      v181 = math.clamp(p99, 10, 300)
      return v181
    end)

    v242 = newAction(newCard(v294, 3, "PHOTO MODE"), 1, "Photo Mode : OFF (F8)", f24)
    local v296 = newCard(v294, 2, "SUIVRE UN JOUEUR (FREE CAM ACTIVE)")
    newPlayerList(v296, 1, focusFreeCamOnPlayer)
    v183 = newInfoLabel(v296, 2, "Suivi : aucun")
    newAction(v296, 3, "Arrêter le suivi", function() setFollowTarget(nil) end)
  end

  local v297 = false
  local v298, connect32

  function lynoxRadarStop()
    v297 = false

    if connect32 then
      connect32:Disconnect()
      connect32 = nil
    end

    if v298 then
      v298:Destroy()
      v298 = nil
    end
  end

  function lynoxRadarStart()
    lynoxRadarStop()
    v297 = true

    local lynoxRadarV3 = Instance.new("ScreenGui")
    lynoxRadarV3.Name = "LynoxRadarV3"
    lynoxRadarV3.ResetOnSpawn = false
    lynoxRadarV3.DisplayOrder = 900
    lynoxRadarV3.Parent = localPlayer:WaitForChild("PlayerGui")

    v298 = lynoxRadarV3

    local frame14 = Instance.new("Frame")
    frame14.Size = UDim2.fromOffset(242, 290)
    frame14.AnchorPoint = Vector2.new(1, 0)
    frame14.Position = UDim2.new(1, -16, 0, 76)
    frame14.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
    frame14.BorderSizePixel = 0
    frame14.Active = true
    frame14.Parent = lynoxRadarV3

    Instance.new("UICorner", frame14).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", frame14).Color = Color3.fromRGB(85, 85, 95)

    local textButton13 = Instance.new("TextButton")
    textButton13.Size = UDim2.new(1, 0, 0, 34)
    textButton13.BackgroundTransparency = 1
    textButton13.Text = "  LYN OX  /  RADAR V3  [drag]"
    textButton13.TextColor3 = Color3.fromRGB(240, 240, 245)
    textButton13.Font = Enum.Font.GothamBold
    textButton13.TextSize = 12
    textButton13.TextXAlignment = Enum.TextXAlignment.Left
    textButton13.Parent = frame14

    local v299 = false
    local v300 = {}
    local inputBegan2 = textButton13.InputBegan
    local position13, position14, userInputType

    v300[#v300 + 1] = inputBegan2:Connect(function(p100)
      if p100.UserInputType == Enum.UserInputType.MouseButton1
        or p100.UserInputType == Enum.UserInputType.Touch then
        v299 = true
        position13 = p100.Position
        position14 = frame14.Position
        userInputType = p100.UserInputType
      end
    end)

    local inputEnded3 = userInputService.InputEnded

    v300[#v300 + 1] = inputEnded3:Connect(function(p101)
      if p101.UserInputType == userInputType then
        v299 = false
      end
    end)

    local inputChanged3 = userInputService.InputChanged

    v300[#v300 + 1] = inputChanged3:Connect(function(p102)
      if not v299 then
        return
      end

      if userInputType == Enum.UserInputType.MouseButton1
        and p102.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
      end

      if userInputType == Enum.UserInputType.Touch
        and p102.UserInputType ~= Enum.UserInputType.Touch then
        return
      else
        local v301 = p102.Position - position13

        frame14.Position = UDim2.new(
          position14.X.Scale, position14.X.Offset + v301.X, position14.Y.Scale,
          position14.Y.Offset + v301.Y
        )

        return
      end
    end)

    local frame15 = Instance.new("Frame")
    frame15.Position = UDim2.fromOffset(12, 36)
    frame15.Size = UDim2.fromOffset(218, 218)
    frame15.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    frame15.BorderSizePixel = 0
    frame15.ClipsDescendants = true
    frame15.Parent = frame14

    Instance.new("UICorner", frame15).CornerRadius = UDim.new(0, 7)
    Instance.new("UIStroke", frame15).Color = Color3.fromRGB(65, 65, 75)

    function line(position15, size)
      local frame16 = Instance.new("Frame")
      frame16.Position = position15
      frame16.Size = size
      frame16.BorderSizePixel = 0
      frame16.BackgroundColor3 = Color3.fromRGB(40, 43, 49)
      frame16.Parent = frame15
    end

    local count4 = 0

    while true do
      count4 = 1 + count4

      if not (count4 <= 3) then
        break
      end

      local v302 = count4

      line(UDim2.fromScale(v302 / 4, 0), UDim2.new(0, 1, 1, 0))
      line(UDim2.fromScale(0, v302 / 4), UDim2.new(1, 0, 0, 1))
    end

    local frame17 = Instance.new("Frame")
    frame17.Size = UDim2.fromScale(1, 1)
    frame17.BackgroundTransparency = 1
    frame17.Parent = frame15

    local v303 = {}

    local frame18 = Instance.new("Frame")
    frame18.Size = UDim2.fromOffset(9, 9)
    frame18.AnchorPoint = Vector2.new(0.5, 0.5)
    frame18.Position = UDim2.fromScale(0.5, 0.5)
    frame18.BackgroundColor3 = Color3.new(1, 1, 1)
    frame18.BorderSizePixel = 0
    frame18.ZIndex = 6
    frame18.Parent = frame15

    Instance.new("UICorner", frame18).CornerRadius = UDim.new(1, 0)

    local textLabel13 = Instance.new("TextLabel")
    textLabel13.Position = UDim2.fromOffset(12, 260)
    textLabel13.Size = UDim2.fromOffset(134, 23)
    textLabel13.BackgroundTransparency = 1
    textLabel13.TextColor3 = Color3.fromRGB(175, 175, 185)
    textLabel13.Font = Enum.Font.Gotham
    textLabel13.TextSize = 11
    textLabel13.TextXAlignment = Enum.TextXAlignment.Left
    textLabel13.Parent = frame14

    local v304 = 300

    local textButton14 = Instance.new("TextButton")
    textButton14.Size = UDim2.fromOffset(29, 22)
    textButton14.Position = UDim2.fromOffset(166, 260)
    textButton14.Text = "-"
    textButton14.Parent = frame14

    local textButton15 = Instance.new("TextButton")
    textButton15.Size = UDim2.fromOffset(29, 22)
    textButton15.Position = UDim2.fromOffset(201, 260)
    textButton15.Text = "+"
    textButton15.Parent = frame14

    for index50, value48 in ipairs({ textButton14, textButton15 }) do
      value48.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
      value48.TextColor3 = Color3.new(1, 1, 1)
      value48.Font = Enum.Font.GothamBold

      Instance.new("UICorner", value48).CornerRadius = UDim.new(0, 5)
    end

    local position16

    function coords(p103)
      local v305 = p103 - position16
      return 0.5 + v305.X / (v304 * 2), 0.5 + v305.Z / (v304 * 2)
    end

    function drawBuildings()
      frame17:ClearAllChildren()

      if not position16 then
        return
      else
        local v306 = {}

        for index51, value49 in ipairs(workspace:GetDescendants()) do
          if value49:IsA("BasePart") and value49.Anchored and value49.Transparency < 0.8
            and value49.Size.X >= 12 and value49.Size.Z >= 12 and value49.Size.Y >= 3
            and math.abs(value49.Position.X - position16.X) < v304
            and math.abs(value49.Position.Z - position16.Z) < v304 then
            v306[#v306 + 1] = value49
          end
        end

        table.sort(v306, function(index52, index53)
          return index52.Size.X * index52.Size.Z > index53.Size.X * index53.Size.Z
        end)

        for k = 1, math.min(#v306, 130) do
          local v307 = v306[k]
          local v308, v309 = coords(v307.Position)

          local frame19 = Instance.new("Frame")
          frame19.AnchorPoint = Vector2.new(0.5, 0.5)
          frame19.Position = UDim2.fromScale(v308, v309)

          frame19.Size = UDim2.fromScale(
            math.min(v307.Size.X / (2 * v304), 0.8), math.min(v307.Size.Z / (2 * v304), 0.8)
          )

          frame19.Rotation = -math.deg(math.atan2(
            v307.CFrame.RightVector.Z, v307.CFrame.RightVector.X
          ))

          frame19.BackgroundColor3 = Color3.fromRGB(82, 87, 96)
          frame19.BackgroundTransparency = 0.3
          frame19.BorderSizePixel = 0
          frame19.Parent = frame17
        end

        return
      end
    end

    textButton14.MouseButton1Click:Connect(function()
      v304 = math.min(1200, math.floor(v304 * 1.5))
      drawBuildings()
    end)

    textButton15.MouseButton1Click:Connect(function()
      v304 = math.max(80, math.floor(v304 / 1.5))
      drawBuildings()
    end)

    local v310 = 0

    connect32 = runService.Heartbeat:Connect(function(delta8)
      v310 = v310 + delta8

      if v310 < 0.15 then
        return
      else
        v310 = 0
        local character80 = localPlayer.Character

        local humanoidRootPart63 = character80
        humanoidRootPart63 = character80 and character80:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart63 then
          frame18.Visible = false
          return
        else
          if not position16 then
            position16 = humanoidRootPart63.Position
            task.defer(drawBuildings)
          end

          local v311, v312 = coords(humanoidRootPart63.Position)

          if v311 < 0.1 or v311 > 0.9 or v312 < 0.1 or v312 > 0.9 then
            position16 = humanoidRootPart63.Position
            v312 = 0.5
            v311 = 0.5
            task.defer(drawBuildings)
          end

          frame18.Visible = true
          frame18.Position = UDim2.fromScale(v311, v312)

          local count5 = 0
          local v313 = {}

          for index54, value50 in ipairs(players:GetPlayers()) do
            if value50 ~= localPlayer then
              local character81 = value50.Character

              local humanoidRootPart64 = character81

              humanoidRootPart64 = character81
                and character81:FindFirstChild("HumanoidRootPart")

              local humanoid49 = character81
              humanoid49 = character81 and character81:FindFirstChildOfClass("Humanoid")

              if humanoidRootPart64 and humanoid49 and humanoid49.Health > 0 then
                count5 = count5 + 1
                v313[value50] = true
                local frame20 = v303[value50]

                if not frame20 then
                  frame20 = Instance.new("Frame")
                  frame20.Size = UDim2.fromOffset(7, 7)
                  frame20.AnchorPoint = Vector2.new(0.5, 0.5)
                  frame20.BorderSizePixel = 0
                  frame20.ZIndex = 5
                  frame20.Parent = frame15

                  Instance.new("UICorner", frame20).CornerRadius = UDim.new(1, 0)
                  v303[value50] = frame20
                end

                local v314, v315 = coords(humanoidRootPart64.Position)

                frame20.Position = UDim2.fromScale(v314, v315)
                frame20.Visible = v314 >= 0 and v314 <= 1 and v315 >= 0 and v315 <= 1

                if value50.Team and localPlayer.Team and value50.Team == localPlayer.Team then
                  frame20.BackgroundColor3 = Color3.fromRGB(72, 210, 117)
                elseif value50.Neutral then
                  frame20.BackgroundColor3 = Color3.fromRGB(245, 203, 74)
                else
                  frame20.BackgroundColor3 = Color3.fromRGB(245, 88, 88)
                end
              end
            end
          end

          for key30, value51 in pairs(v303) do
            if not v313[key30] then
              value51:Destroy()
              v303[key30] = nil
            end
          end

          textLabel13.Text = "Zoom " .. v304 .. "  |  " .. count5 .. " joueurs"
          return
        end
      end
    end)

    lynoxRadarV3.Destroying:Connect(function()
      for index55, value52 in ipairs(v300) do
        value52:Disconnect()
      end
    end)
  end

  function toggleLynoxRadar(p104)
    if v297 then
      lynoxRadarStop()
    else
      lynoxRadarStart()
    end

    if p104 then
      p104(v297)
    end
  end

  function buildVisualUI()
    local v316 = newTab(5, "Visuel", "")

    newSwitch(newCard(v316, 1, "ESP (NOMS + DISTANCE)"), 1, "Activer l'ESP", toggleESP)

    newSwitch(
      newCard(v316, 2, "CHEAT LINES"), 1, "Lignes vers tous les joueurs", toggleCheatLines
    )

    newSwitch(
      newCard(v316, 3, "TRACKER"), 1, "Tracker joueurs (surbrillance + distance)", toggleTracker
    )

    newSwitch(
      newCard(v316, 4, "SKELETON ESP"), 1, "Voir le squelette à travers les murs",
      toggleSkeletonESP
    )

    newSwitch(
      newCard(v316, 6, "RADAR JOUEURS"), 1, "Radar V3 (zoom + equipes)", toggleLynoxRadar
    )

    newInfoLabel(
      newCard(v316, 5, "LUMINOSITÉ"), 1, "Fullbright est maintenant dans Utilitaires.", 40
    )
  end
end

local v317 = {}
local v318

local function f26()
  for index56, value53 in ipairs(v317) do
  end

  table.clear(v317)

  if v318 then
    v318:Destroy()
    v318 = nil
  end
end

do
  local v319

  function openLynoxKillPanel()
    local parent11 = v318 and v318.Parent

    local draggableWindow, v320, position17, position18, v321, frame21, textBox3,
      scrollingFrame3, textLabel14, f27

    if parent11 then
      v318.Enabled = true
      return
    else
      local playerGui5 = localPlayer:WaitForChild("PlayerGui")

      local lynoxKillPlayerPanel = Instance.new("ScreenGui")
      lynoxKillPlayerPanel.Name = "LynoxKillPlayerPanel"
      lynoxKillPlayerPanel.ResetOnSpawn = false
      lynoxKillPlayerPanel.IgnoreGuiInset = true
      lynoxKillPlayerPanel.DisplayOrder = 10002
      lynoxKillPlayerPanel.Parent = playerGui5

      v318 = lynoxKillPlayerPanel

      draggableWindow = Instance.new("Frame")
      draggableWindow.Name = "DraggableWindow"
      draggableWindow.Size = UDim2.fromOffset(390, 435)
      draggableWindow.Position = UDim2.new(0.5, -195, 0.5, -217)
      draggableWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
      draggableWindow.BorderSizePixel = 0
      draggableWindow.Active = true
      draggableWindow.Parent = lynoxKillPlayerPanel

      corner(draggableWindow, 12)
      stroke(draggableWindow, Color3.fromRGB(65, 65, 76), 1, 0)

      local frame22 = Instance.new("Frame")
      frame22.Size = UDim2.new(1, -84, 0, 46)
      frame22.BackgroundTransparency = 1
      frame22.Active = true
      frame22.Parent = draggableWindow

      local textLabel15 = Instance.new("TextLabel")
      textLabel15.Size = UDim2.new(1, -16, 1, 0)
      textLabel15.Position = UDim2.fromOffset(14, 0)
      textLabel15.BackgroundTransparency = 1
      textLabel15.Text = "LYNOXBOT  /  KILL PLAYER"
      textLabel15.TextColor3 = color7
      textLabel15.Font = Enum.Font.GothamBold
      textLabel15.TextSize = 15
      textLabel15.TextXAlignment = Enum.TextXAlignment.Left
      textLabel15.Parent = frame22

      v320 = false
      position17 = nil
      position18 = nil
      v321 = nil
      local inputBegan3 = frame22.InputBegan

      table.insert(v317, inputBegan3:Connect(function(p105)
        if p105.UserInputType == Enum.UserInputType.MouseButton1
          or p105.UserInputType == Enum.UserInputType.Touch then
          v320 = true
          position17 = p105.Position
          position18 = draggableWindow.Position
          v321 = p105
        end
      end))

      local inputChanged4 = userInputService.InputChanged

      table.insert(v317, inputChanged4:Connect(function(p106)
        if v320
          and (p106 == v321
            or v321 and v321.UserInputType == Enum.UserInputType.MouseButton1
              and p106.UserInputType == Enum.UserInputType.MouseMovement) then
          local v322 = p106.Position - position17

          draggableWindow.Position = UDim2.new(
            position18.X.Scale, position18.X.Offset + v322.X, position18.Y.Scale,
            position18.Y.Offset + v322.Y
          )
        end
      end))

      local inputEnded4 = userInputService.InputEnded

      table.insert(v317, inputEnded4:Connect(function(p107)
        if p107 == v321
          or v321 and v321.UserInputType == Enum.UserInputType.MouseButton1
            and p107.UserInputType == Enum.UserInputType.MouseButton1 then
          v320 = false
        end
      end))

      local function makeTextButton4(text12, p108, p109)
        local textButton16 = Instance.new("TextButton")
        textButton16.Size = UDim2.fromOffset(p109, 28)
        textButton16.Position = UDim2.new(1, p108, 0, 9)
        textButton16.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        textButton16.BorderSizePixel = 0
        textButton16.Text = text12
        textButton16.TextColor3 = color7
        textButton16.Font = Enum.Font.GothamBold
        textButton16.TextSize = 15
        textButton16.Parent = draggableWindow

        corner(textButton16, 6)
        return textButton16
      end

      local v323 = makeTextButton4("–", -75, 30)
      makeTextButton4("×", -40, 30).MouseButton1Click:Connect(f26)

      frame21 = Instance.new("Frame")
      frame21.Position = UDim2.fromOffset(12, 49)
      frame21.Size = UDim2.new(1, -24, 1, -61)
      frame21.BackgroundTransparency = 1
      frame21.Parent = draggableWindow

      v323.MouseButton1Click:Connect(function()
        frame21.Visible = not frame21.Visible

        draggableWindow.Size = frame21.Visible and UDim2.fromOffset(390, 435)
          or UDim2.fromOffset(390, 47)
      end)

      textBox3 = Instance.new("TextBox")
      textBox3.Size = UDim2.new(1, 0, 0, 36)
      textBox3.BackgroundColor3 = Color3.fromRGB(29, 29, 35)
      textBox3.BorderSizePixel = 0
      textBox3.PlaceholderText = "Rechercher un joueur..."
      textBox3.Text = ""
      textBox3.ClearTextOnFocus = false
      textBox3.TextColor3 = color7
      textBox3.PlaceholderColor3 = color8
      textBox3.Font = Enum.Font.Gotham
      textBox3.TextSize = 13
      textBox3.Parent = frame21

      corner(textBox3, 7)

      scrollingFrame3 = Instance.new("ScrollingFrame")
      scrollingFrame3.Position = UDim2.fromOffset(0, 45)
      scrollingFrame3.Size = UDim2.new(1, 0, 1, -137)
      scrollingFrame3.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
      scrollingFrame3.BorderSizePixel = 0
      scrollingFrame3.ScrollBarThickness = 4
      scrollingFrame3.AutomaticCanvasSize = Enum.AutomaticSize.Y
      scrollingFrame3.CanvasSize = UDim2.new()
      scrollingFrame3.Parent = frame21

      corner(scrollingFrame3, 7)

      local uiListLayout6 = Instance.new("UIListLayout")
      uiListLayout6.Padding = UDim.new(0, 5)
      uiListLayout6.Parent = scrollingFrame3

      textLabel14 = Instance.new("TextLabel")
      textLabel14.Position = UDim2.new(0, 0, 1, -83)
      textLabel14.Size = UDim2.new(1, 0, 0, 28)
      textLabel14.BackgroundTransparency = 1
      textLabel14.TextColor3 = color7
      textLabel14.TextSize = 12
      textLabel14.Font = Enum.Font.Gotham
      textLabel14.Text = "Cible : aucune"
      textLabel14.Parent = frame21

      local textButton17 = Instance.new("TextButton")
      textButton17.Size = UDim2.new(0.49, 0, 0, 43)
      textButton17.Position = UDim2.new(0, 0, 1, -48)
      textButton17.BackgroundColor3 = Color3.fromRGB(115, 45, 55)
      textButton17.Text = "KILL"
      textButton17.TextColor3 = color7
      textButton17.Font = Enum.Font.GothamBold
      textButton17.TextSize = 16
      textButton17.Parent = frame21

      corner(textButton17, 7)

      local textButton18 = Instance.new("TextButton")
      textButton18.Size = UDim2.new(0.49, 0, 0, 43)
      textButton18.Position = UDim2.new(0.51, 0, 1, -48)
      textButton18.BackgroundColor3 = Color3.fromRGB(45, 45, 54)
      textButton18.Text = "STOP"
      textButton18.TextColor3 = color7
      textButton18.Font = Enum.Font.GothamBold
      textButton18.TextSize = 16
      textButton18.Parent = frame21

      corner(textButton18, 7)

      textButton17.MouseButton1Click:Connect(function()
        textLabel14.Text = v319 and "Cible : " .. v319.Name .. "  |  Tir non connecté"
          or "Sélectionne un joueur"
      end)

      textButton18.MouseButton1Click:Connect(function()
        textLabel14.Text = "Arrêté | Tir non connecté"
      end)

      function f27()
        for index57, value54 in ipairs(scrollingFrame3:GetChildren()) do
          if value54:IsA("Frame") then
            value54:Destroy()
          end
        end

        local lower = textBox3.Text:lower()

        for index58, value55 in ipairs(players:GetPlayers()) do
          local v324 = value55

          if v324 ~= localPlayer
            and (lower == "" or v324.Name:lower():find(lower, 1, true)
              or v324.DisplayName:lower():find(lower, 1, true)) then
            local frame23 = Instance.new("Frame")
            frame23.Size = UDim2.new(1, -6, 0, 54)

            frame23.BackgroundColor3 = v319 == v324 and Color3.fromRGB(55, 48, 69)
              or Color3.fromRGB(33, 33, 40)

            frame23.BorderSizePixel = 0
            frame23.Parent = scrollingFrame3

            corner(frame23, 6)

            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Size = UDim2.fromOffset(40, 40)
            imageLabel.Position = UDim2.fromOffset(6, 7)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Parent = frame23

            corner(imageLabel, 6)

            task.spawn(function()
              local v325, image2 = pcall(function()
                return players:GetUserThumbnailAsync(
                  v324.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100
                )
              end)

              if v325 and imageLabel.Parent then
                imageLabel.Image = image2
              end
            end)

            local textLabel16 = Instance.new("TextLabel")
            textLabel16.Position = UDim2.fromOffset(52, 0)
            textLabel16.Size = UDim2.new(1, -145, 1, 0)
            textLabel16.BackgroundTransparency = 1
            textLabel16.Text = v324.DisplayName .. " (@" .. v324.Name .. ")"
            textLabel16.TextColor3 = color7
            textLabel16.Font = Enum.Font.Gotham
            textLabel16.TextSize = 12
            textLabel16.TextXAlignment = Enum.TextXAlignment.Left
            textLabel16.TextTruncate = Enum.TextTruncate.AtEnd
            textLabel16.Parent = frame23

            local textButton19 = Instance.new("TextButton")
            textButton19.Size = UDim2.fromOffset(80, 32)
            textButton19.Position = UDim2.new(1, -86, 0.5, -16)
            textButton19.BackgroundColor3 = Color3.fromRGB(65, 65, 77)
            textButton19.Text = v319 == v324 and "CHOISI" or "SELECT"
            textButton19.TextColor3 = color7
            textButton19.Font = Enum.Font.GothamBold
            textButton19.TextSize = 11
            textButton19.Parent = frame23

            corner(textButton19, 6)

            textButton19.MouseButton1Click:Connect(function()
              v319 = v324
              textLabel14.Text = "Cible : @" .. v324.Name
              f27()
            end)
          end
        end
      end

      local text13 = textBox3:GetPropertyChangedSignal("Text")
      table.insert(v317, text13:Connect(f27))
      local playerAdded = players.PlayerAdded
      table.insert(v317, playerAdded:Connect(f27))
      local playerRemoving = players.PlayerRemoving

      table.insert(v317, playerRemoving:Connect(function(p110)
        if v319 == p110 then
          v319 = nil
          textLabel14.Text = "Cible : aucune"
        end

        f27()
      end))

      f27()
      return
    end
  end

  local function makeScreenGui()
    local localPlayer2 = players.LocalPlayer
    local playerGui6 = localPlayer2:WaitForChild("PlayerGui")
    local lynoxPlayerListStandalone = playerGui6:FindFirstChild("LynoxPlayerListStandalone")

    if lynoxPlayerListStandalone then
      lynoxPlayerListStandalone:Destroy()
    end

    local lynoxPlayerListStandalone2 = Instance.new("ScreenGui")
    lynoxPlayerListStandalone2.Name = "LynoxPlayerListStandalone"
    lynoxPlayerListStandalone2.ResetOnSpawn = false
    lynoxPlayerListStandalone2.DisplayOrder = 9999
    lynoxPlayerListStandalone2.Parent = playerGui6

    local v326 = {}

    local function f28(p111, p112)
      local connect33 = p111:Connect(p112)
      table.insert(v326, connect33)
      return connect33
    end

    local function f29(p113, lynoxPlayerListStandalone3, p114)
      local instance = Instance.new(p113)

      for key31, value56 in pairs(p114 or {}) do
        instance[key31] = value56
      end

      instance.Parent = lynoxPlayerListStandalone3
      return instance
    end

    local color10 = Color3.fromRGB(12, 14, 18)
    local color11 = Color3.fromRGB(21, 23, 28)
    local color12 = Color3.fromRGB(29, 32, 38)
    local color13 = Color3.fromRGB(226, 228, 232)
    local color14 = Color3.fromRGB(153, 157, 166)

    local v327 = f29("Frame", lynoxPlayerListStandalone2, {
      Size = UDim2.fromOffset(326, 326),
      Position = UDim2.new(0.5, -163, 0.5, -163),
      BackgroundColor3 = color10,
      BorderSizePixel = 0,
      Active = true,
    })

    f29("UICorner", v327, { CornerRadius = UDim.new(0, 8) })
    f29("UIStroke", v327, { Color = Color3.fromRGB(77, 80, 86), Thickness = 1 })

    local v328 = f29("Frame", v327, {
      Position = UDim2.fromOffset(5, 4),
      Size = UDim2.new(1, -10, 0, 27),
      BackgroundTransparency = 1,
      Active = true,
    })

    f29("TextLabel", v328, {
      Position = UDim2.fromOffset(5, 0),
      Size = UDim2.new(1, -42, 1, 0),
      BackgroundTransparency = 1,
      Text = "PLAYERLIST",
      TextColor3 = color13,
      Font = Enum.Font.Code,
      TextSize = 12,
      TextXAlignment = Enum.TextXAlignment.Left,
    })

    local v329 = f29("TextButton", v328, {
      Position = UDim2.new(1, -27, 0, 2),
      Size = UDim2.fromOffset(23, 22),
      BackgroundColor3 = Color3.fromRGB(43, 46, 54),
      Text = "X",
      TextColor3 = color13,
      Font = Enum.Font.GothamBold,
      TextSize = 11,
      BorderSizePixel = 0,
    })

    f29("UICorner", v329, { CornerRadius = UDim.new(0, 4) })

    local v330 = f29("TextLabel", v327, {
      Position = UDim2.fromOffset(12, 32),
      Size = UDim2.new(1, -24, 0, 18),
      BackgroundTransparency = 1,
      Text = "PLAYERS / 0",
      TextColor3 = color14,
      Font = Enum.Font.Code,
      TextSize = 9,
      TextXAlignment = Enum.TextXAlignment.Left,
    })

    local v331 = f29("ScrollingFrame", v327, {
      Position = UDim2.fromOffset(8, 52),
      Size = UDim2.new(1, -16, 1, -60),
      BackgroundColor3 = Color3.fromRGB(16, 18, 22),
      BorderSizePixel = 0,
      ScrollBarThickness = 3,
      CanvasSize = UDim2.fromOffset(0, 0),
      AutomaticCanvasSize = Enum.AutomaticSize.Y,
      ScrollingDirection = Enum.ScrollingDirection.Y,
    })

    f29("UIListLayout", v331, {
      Padding = UDim.new(0, 3),
      SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local v332 = false
    local cameraSubject

    local function f30()
      if v332 then
        local currentCamera5 = workspace.CurrentCamera

        local humanoid50 = localPlayer2.Character
          and localPlayer2.Character:FindFirstChildOfClass("Humanoid")

        if currentCamera5 then
          currentCamera5.CameraSubject = humanoid50 or cameraSubject
        end
      end

      v332 = false
      cameraSubject = nil
    end

    local function f31(p115)
      if p115.TeamColor then
        return p115.TeamColor.Color
      end

      return Color3.fromRGB(82, 147, 215)
    end

    local v333

    local function f32()
      for index59, value57 in ipairs(v331:GetChildren()) do
        if value57:IsA("Frame") then
          value57:Destroy()
        end
      end

      local getPlayers = players:GetPlayers()
      v330.Text = "PLAYERS / " .. tostring(#getPlayers)

      table.sort(getPlayers, function(p116, p117)
        return p116.Name:lower() < p117.Name:lower()
      end)

      for index60, value58 in ipairs(getPlayers) do
        local v334 = value58
        local v335 = v333 == v334

        local v336 = f29("Frame", v331, {
          Size = UDim2.new(1, -4, 0, v335 and 235 or 31),
          BackgroundColor3 = v335 and Color3.fromRGB(18, 20, 25) or color12,
          BorderSizePixel = 0,
          LayoutOrder = index60,
        })

        f29("Frame", v336, {
          Size = UDim2.new(0, 3, 1, 0),
          BackgroundColor3 = f31(v334),
          BorderSizePixel = 0,
        })

        local v337 = f29("TextButton", v336, {
          Position = UDim2.fromOffset(6, 0),
          Size = UDim2.new(1, -7, 0, 31),
          BackgroundTransparency = 1,
          Text = "",
          AutoButtonColor = false,
        })

        f29("TextLabel", v337, {
          Position = UDim2.fromOffset(2, 2),
          Size = UDim2.new(1, -8, 0, 14),
          BackgroundTransparency = 1,
          Text = v334.DisplayName,
          TextColor3 = color13,
          Font = Enum.Font.Code,
          TextSize = 11,
          TextXAlignment = Enum.TextXAlignment.Left,
        })

        f29("TextLabel", v337, {
          Position = UDim2.fromOffset(2, 16),
          Size = UDim2.new(1, -8, 0, 12),
          BackgroundTransparency = 1,
          Text = "@" .. v334.Name,
          TextColor3 = color14,
          Font = Enum.Font.Code,
          TextSize = 9,
          TextXAlignment = Enum.TextXAlignment.Left,
        })

        f28(v337.MouseButton1Click, function()
          local canvasPosition = v331.CanvasPosition

          if v333 == v334 then
            v333 = nil
          else
            v333 = v334
          end

          f32()
          v331.CanvasPosition = canvasPosition
        end)

        if v335 then
          local v338 = f29("Frame", v336, {
            Position = UDim2.fromOffset(6, 33),
            Size = UDim2.new(1, -12, 1, -38),
            BackgroundColor3 = color11,
            BorderSizePixel = 0,
          })

          f29("UICorner", v338, { CornerRadius = UDim.new(0, 5) })

          local v339 = f29("ImageLabel", v338, {
            Position = UDim2.fromOffset(8, 9),
            Size = UDim2.fromOffset(50, 50),
            BackgroundColor3 = color10,
            Image = "",
          })

          f29("UICorner", v339, { CornerRadius = UDim.new(0, 5) })
          local character82 = v334.Character

          local humanoid51 = character82
          humanoid51 = character82 and v334.Character:FindFirstChildOfClass("Humanoid")

          local v340 = humanoid51
              and math.floor(humanoid51.Health) .. "/" .. math.floor(humanoid51.MaxHealth)
            or "N/A"

          f29("TextLabel", v338, {
            Position = UDim2.fromOffset(65, 7),
            Size = UDim2.new(1, -70, 0, 17),
            BackgroundTransparency = 1,
            Text = v334.DisplayName,
            TextColor3 = color13,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
          })

          f29("TextLabel", v338, {
            Position = UDim2.fromOffset(65, 24),
            Size = UDim2.new(1, -70, 0, 76),
            BackgroundTransparency = 1,
            Text = "Username: @" .. v334.Name .. "\nUser ID: " .. v334.UserId .. "\nTeam: "
              .. (v334.Team and v334.Team.Name or "None") .. "\nHealth: " .. v340
              .. "\nPrecision: 0.0%",
            TextColor3 = color14,
            Font = Enum.Font.Code,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
          })

          f29("TextLabel", v338, {
            Position = UDim2.fromOffset(8, 105),
            Size = UDim2.fromOffset(100, 13),
            BackgroundTransparency = 1,
            Text = "FLAGS:",
            TextColor3 = Color3.fromRGB(237, 93, 100),
            Font = Enum.Font.Code,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
          })

          local v341 = f29("TextLabel", v338, {
            Position = UDim2.fromOffset(8, 118),
            Size = UDim2.new(1, -16, 0, 29),
            BackgroundTransparency = 1,
            Text = "NONE",
            TextColor3 = color13,
            Font = Enum.Font.Code,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
          })

          task.spawn(function()
            local v342, image3 = pcall(function()
              return players:GetUserThumbnailAsync(
                v334.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150
              )
            end)

            if v342 and v339.Parent then
              v339.Image = image3
            end
          end)

          local function f33(text14, index61, color15, p118)
            local v343 = f29("TextButton", v338, {
              Position = UDim2.new(0.11 + index61 * 0.22, 0, 1, -39),
              Size = UDim2.new(0.2, 0, 0, 35),
              BackgroundColor3 = Color3.fromRGB(42, 45, 51),
              BorderSizePixel = 0,
              Text = text14,
              TextColor3 = color15,
              Font = Enum.Font.Code,
              TextSize = 11,
            })

            f29("UICorner", v343, { CornerRadius = UDim.new(0, 5) })
            f28(v343.MouseButton1Click, p118)
          end

          f33("FLING", 0, Color3.fromRGB(182, 155, 248), function()
            local v344, v345 = pcall(function()
              if type(_G.LynoxPlayerListKickCars) ~= "function" then
                return "Kick Cars unavailable"
              end

              return _G.LynoxPlayerListKickCars(v334)
            end)

            v341.Text = v344 and tostring(v345 or "FLING started") or tostring(v345)
          end)

          f33("KILL", 1, Color3.fromRGB(240, 115, 124), function()
            v341.Text = "KILL pending"
          end)

          f33("VIEW", 2, Color3.fromRGB(122, 194, 247), function()
            if v332 then
              f30()
              v341.Text = "VIEW OFF"
              return
            else
              local humanoid52 = v334.Character
                and v334.Character:FindFirstChildOfClass("Humanoid")

              local currentCamera6 = workspace.CurrentCamera

              if humanoid52 and currentCamera6 then
                cameraSubject = currentCamera6.CameraSubject
                currentCamera6.CameraSubject = humanoid52
                v332 = true
                v341.Text = "VIEW " .. v334.Name
              else
                v341.Text = "Target unavailable"
              end

              return
            end
          end)

          f33("TP", 3, Color3.fromRGB(120, 221, 167), function()
            local humanoidRootPart65 = localPlayer2.Character
              and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

            local humanoidRootPart66 = v334.Character
              and v334.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart65 and humanoidRootPart66 then
              humanoidRootPart65.CFrame = humanoidRootPart66.CFrame * CFrame.new(3, 0, 0)
              v341.Text = "TP " .. v334.Name
            else
              v341.Text = "Target unavailable"
            end
          end)
        end
      end
    end

    local v346 = false
    local position19, position20

    f28(v328.InputBegan, function(p119)
      if p119.UserInputType == Enum.UserInputType.MouseButton1
        or p119.UserInputType == Enum.UserInputType.Touch then
        v346 = true
        position19 = p119.Position
        position20 = v327.Position

        f28(p119.Changed, function()
          if p119.UserInputState == Enum.UserInputState.End then
            v346 = false
          end
        end)
      end
    end)

    f28(userInputService.InputChanged, function(p120)
      if v346
        and (p120.UserInputType == Enum.UserInputType.MouseMovement
          or p120.UserInputType == Enum.UserInputType.Touch) then
        local v347 = p120.Position - position19

        v327.Position = UDim2.new(
          position20.X.Scale, position20.X.Offset + v347.X, position20.Y.Scale,
          position20.Y.Offset + v347.Y
        )
      end
    end)

    f28(v329.MouseButton1Click, function()
      f30()

      for index62, value59 in ipairs(v326) do
      end

      lynoxPlayerListStandalone2:Destroy()
    end)

    f28(players.PlayerAdded, f32)

    f28(players.PlayerRemoving, function(p121)
      if v333 == p121 then
        f30()
        v333 = nil
      end

      task.defer(f32)
    end)

    f32()
  end

  function buildKillPlayerUI()
    local v348 = newCard(newTab(20, "GUI", ""), 1, "PLAYERLIST")

    newInfoLabel(
      v348, 1, "Ouvre la PlayerList dans une fenetre independante et deplacable.", 54
    )

    newAction(v348, 2, "OUVRIR LE GUI", function()
      local v349, v350 = pcall(makeScreenGui)

      if not v349 then
        warn("[LynoxBot PlayerList] " .. tostring(v350))
      end
    end)
  end

  function buildUtilitiesUI()
    local v351 = newTab(6, "Utilitaires", "")

    newSwitch(newCard(v351, 1, "ANTI-AFK"), 1, "Activer l'anti-AFK", toggleAntiAfk)
    newSwitch(newCard(v351, 9, "FULLBRIGHT"), 1, "Fullbright (J)", toggleFullbright)
    newSwitch(newCard(v351, 2, "ANTI FLING"), 1, "ANTI FLING", toggleAntiFling)

    newAction(newCard(v351, 4, "PERSONNAGE"), 1, "Se re-spawn", resetCharacter)

    newAction(
      newCard(v351, 7, "RECHARGER LE PANEL"), 1, "Recharger le panel maintenant",
      function() task.defer(reloadGUI) end
    )

    local v352 = newCard(v351, 8, "KILL AURA (ARME AUTO QUAND UN JOUEUR S'APPROCHE)")
    newSwitch(v352, 1, "Activer le Kill Aura", toggleKillAura)

    newStepper(v352, 2, "Portée (studs)", v83, 5, function(p122)
      v83 = math.clamp(p122, 5, 200)
      return v83
    end)

    local v353 = newInfoLabel(newCard(v351, 5, "SERVER INFO"), 1, [[
Joueurs: -
Ping: -
Session: -]], 56)

    v353.TextSize = 12

    local v354 = newInfoLabel(
      newCard(v351, 6, "RACCOURCIS CLAVIER"), 1,
      "⌨  RightShift / - : afficher ou masquer le panel\n  Fly : W A S D + Espace / Shift\n  Vehicle Fly : W A S D + Espace / Shift + E / Q\n  FreeCam : clic droit pour regarder",
      78
    )

    v354.TextColor3 = color7
    v354.Font = Enum.Font.Gotham
    v354.TextSize = 12

    local v355 = os.clock()
    local v356 = 0

    runService.Heartbeat:Connect(function(delta9)
      v356 = v356 + delta9

      if v356 < 1 then
        return
      else
        v356 = 0
        local getNetworkPing = localPlayer:GetNetworkPing()
        local v357 = math.floor(getNetworkPing * 1000)
        local v358 = math.floor(os.clock() - v355)

        v353.Text = string.format([[
Joueurs: %d/%d
Ping: %d ms
Session: %dm %ds]], #players:GetPlayers(), players.MaxPlayers, v357, math.floor(v358 / 60), v358 % 60)

        return
      end
    end)
  end

  function buildTrollUI()
    local v359 = newTab(7, "Troll", "")
    local v360 = newCard(v359, 0, "  TROLL ZONE  •  THELYNOXBOT")

    local trollIntroduction = Instance.new("TextLabel")
    trollIntroduction.Name = "TrollIntroduction"
    trollIntroduction.Size = UDim2.new(1, 0, 0, 44)
    trollIntroduction.BackgroundTransparency = 1
    trollIntroduction.TextColor3 = color7
    trollIntroduction.TextWrapped = true
    trollIntroduction.TextXAlignment = Enum.TextXAlignment.Left
    trollIntroduction.Font = Enum.Font.GothamMedium
    trollIntroduction.TextSize = 13
    trollIntroduction.Text = " Choisis un joueur dans chaque carte pour lancer l'action. Utilise Arrêter pour interrompre un effet."
    trollIntroduction.LayoutOrder = 1
    trollIntroduction.Parent = v360

    function styleTrollCard(p123, p124)
      p123.BackgroundColor3 = Color3.fromRGB(39, 32, 63)
      local uiStroke4 = p123:FindFirstChildOfClass("UIStroke")

      if uiStroke4 then
        uiStroke4.Color = p124 % 2 == 0 and color6 or color5
        uiStroke4.Transparency = 0.55
        uiStroke4.Thickness = 1.2
      end

      local cardTitle2 = p123:FindFirstChild("CardTitle")

      if cardTitle2 then
        cardTitle2.TextColor3 = p124 % 2 == 0 and color6 or Color3.fromRGB(197, 169, 255)
        cardTitle2.TextSize = 13
      end
    end

    styleTrollCard(v360, 0)

    local v361 = newCard(v359, 1, "SAUTER SUR LA TÊTE (2S)")
    newPlayerList(v361, 1, jumpOnPlayer)
    newAction(v361, 2, "Arrêter", f9)
    local v362 = newCard(v359, 2, "SE TP SUR SON DOS (20S)")
    newPlayerList(v362, 1, backRidePlayer)
    newAction(v362, 2, "Arrêter", f7)
    local v363 = newCard(v359, 3, "BLOQUER LA VUE + DANSE (20S)")
    newPlayerList(v363, 1, blockAndDance)
    newAction(v363, 2, "Arrêter", f10)
    local v364 = newCard(v359, 4, "CERCLE AUTOUR D'EUX (20S)")
    newPlayerList(v364, 1, circleAroundPlayer)
    newAction(v364, 2, "Arrêter", f11)
    local v365 = newCard(v359, 5, "OMBRE : LE SUIVRE À DISTANCE (20S)")
    newPlayerList(v365, 1, shadowPlayer)
    newAction(v365, 2, "Arrêter", f12)
    local v366 = newCard(v359, 6, "MIROIR : COPIER SES MOUVEMENTS")
    newPlayerList(v366, 1, mirrorPlayer)
    newAction(v366, 2, "Arrêter", f13)
    local v367 = newCard(v359, 7, "TP SPAM AUTOUR DE LUI (15S)")
    newPlayerList(v367, 1, tpSpamAroundPlayer)
    newAction(v367, 2, "Arrêter", f2)
    local v368 = newCard(v359, 8, "CAGE : 4 BLOCS AUTOUR DE LUI (25S)")
    newPlayerList(v368, 1, cageAroundPlayer)
    newAction(v368, 2, "Arrêter", f3)
    local v369 = newCard(v359, 9, "SALUEUR RANDOM (WAVE TOUTES LES 5-10S)")
    newPlayerList(v369, 1, randomWaveAtPlayer)
    newAction(v369, 2, "Arrêter", f4)
    local v370 = newCard(v359, 10, "SAUTEUR : SAUTE À CÔTÉ DE LUI (20S)")
    newPlayerList(v370, 1, jumpBesidePlayer)
    newAction(v370, 2, "Arrêter", f5)
    local v371 = newCard(v359, 11, "FAUX MORT DEVANT LUI (8S)")
    newPlayerList(v371, 1, fakeDeathInFrontOf)
    newAction(v371, 2, "Arrêter", f6)
    local v372 = newCard(v359, 12, "TIR (15 DÉGÂTS, COOLDOWN 4S)")
    newPlayerList(v372, 1, fireAtPlayer)
    local v373 = newCard(v359, 13, "SPIN (3S)")
    newPlayerList(v373, 1, spinAroundPlayer)
    newAction(v373, 2, "Arrêter", f8)
    local v374 = newCard(v359, 14, "STATISTIQUES DE TIR")
    v80 = newInfoLabel(v374, 1, "Tirs réussis: 0\nDégâts totaux: 0", 40)

    newAction(v374, 2, "Réinitialiser", function()
      v24 = 0
      v25 = 0
      updateStatsLabel()
    end)

    for index63, value60 in ipairs({
      v361, v362, v363, v364, v365, v366, v367, v368, v369, v370, v371, v372, v373, v374,
    }) do
      styleTrollCard(value60, index63)
    end
  end

  function buildBackstabUI()
    local v375 = newTab(8, "Backstab", "")

    newPlayerList(
      newCard(v375, 1, "BACKSTAB (AZERTY A / Q = DESCENDRE)"), 1, backstabPlayer, true
    )

    local v376 = newCard(v375, 2, "BLOQUER LA VUE + DANSE (20S)")
    newPlayerList(v376, 1, blockAndDance)
    newAction(v376, 2, "Arrêter", f10)
  end

  function buildEmotesUI()
    local color16 = Color3.fromRGB(17, 17, 21)
    local color17 = Color3.fromRGB(43, 43, 49)

    function createEmoteCard(parent12, text15, text16, layoutOrder6)
      local frame24 = Instance.new("Frame")
      frame24.Size = UDim2.new(1, 0, 0, 0)
      frame24.AutomaticSize = Enum.AutomaticSize.Y
      frame24.BackgroundColor3 = color4
      frame24.BorderSizePixel = 0
      frame24.LayoutOrder = layoutOrder6
      frame24.Parent = parent12

      corner(frame24, 10)
      stroke(frame24, Color3.fromRGB(39, 39, 46), 1, 0)
      padding(frame24, 10)

      local textLabel17 = Instance.new("TextLabel")
      textLabel17.Size = UDim2.new(1, 0, 0, 20)
      textLabel17.BackgroundTransparency = 1
      textLabel17.Text = text15 .. " (" .. #text16 .. ")"
      textLabel17.TextColor3 = color7
      textLabel17.Font = Enum.Font.GothamBlack
      textLabel17.TextSize = 14
      textLabel17.TextXAlignment = Enum.TextXAlignment.Left
      textLabel17.LayoutOrder = 0
      textLabel17.Parent = frame24

      local frame25 = Instance.new("Frame")
      frame25.Size = UDim2.new(1, 0, 0, 0)
      frame25.AutomaticSize = Enum.AutomaticSize.Y
      frame25.BackgroundTransparency = 1
      frame25.LayoutOrder = 1
      frame25.Parent = frame24

      local uiGridLayout = Instance.new("UIGridLayout")
      uiGridLayout.CellSize = UDim2.new(0.3, 0, 0, 38)
      uiGridLayout.CellPadding = UDim2.new(0, 6, 0, 7)
      uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
      uiGridLayout.Parent = frame25

      for index64, value61 in ipairs(text16) do
        local v377 = value61

        local textButton20 = Instance.new("TextButton")
        textButton20.Name = v377.name:gsub("%s+", ""):gsub("\n", "") .. "Button"
        textButton20.BackgroundColor3 = color16
        textButton20.Text = v377.name
        textButton20.TextColor3 = color7
        textButton20.Font = Enum.Font.GothamBold
        textButton20.TextSize = 12
        textButton20.TextWrapped = true
        textButton20.AutoButtonColor = false
        textButton20.LayoutOrder = index64
        textButton20.Parent = frame25

        corner(textButton20, 9)
        local v378 = stroke(textButton20, Color3.fromRGB(65, 65, 72), 1, 0.65)

        textButton20.MouseEnter:Connect(function()
          tweenService:Create(v378, TweenInfo.new(0.13), {
            Color = Color3.fromRGB(245, 245, 250),
            Transparency = 0,
            Thickness = 1.4,
          }):Play()
        end)

        textButton20.MouseLeave:Connect(function()
          tweenService:Create(v378, TweenInfo.new(0.13), {
            Color = Color3.fromRGB(65, 65, 72),
            Transparency = 0.65,
            Thickness = 1,
          }):Play()
        end)

        if v377.name:find("WARNING", 1, true) then
          local v379 = 0

          textButton20.MouseButton1Click:Connect(function()
            local v380 = os.clock()

            if v380 - v379 <= 0.45 then
              v379 = 0
              playEmote(v377, textButton20, color16, color17)
            else
              v379 = v380
            end
          end)
        else
          textButton20.MouseButton1Click:Connect(function()
            if v377.accessory then
              pcall(function()
                if setclipboard then
                  setclipboard(tostring(v377.id))
                end
              end)

              info(v377.name .. " : accessoire Roblox (ID " .. tostring(v377.id)
                .. "). Equipe-le via ton avatar Roblox ; ce bouton ne peut pas le jouer comme une danse.")

              textButton20.Text = "ID copie !"

              task.delay(1.5, function()
                if textButton20.Parent then
                  textButton20.Text = v377.name
                end
              end)
            else
              playEmote(v377, textButton20, color16, color17)
            end
          end)
        end
      end
    end

    createEmoteCard(newTab(9, "Animation R6", ""), "ANIMATION R6", {
      {
        name = "Head Throw",
        id = 35154961,
        speed = 1,
        looped = true,
      },
      {
        name = "Floating Head",
        id = 121572214,
        speed = 1,
        looped = true,
      },
      {
        name = "Crouch",
        id = 182724289,
        speed = 1,
        looped = true,
      },
      {
        name = "Floor Crawl",
        id = 282574440,
        speed = 1,
        looped = true,
      },
      {
        name = "Dino Walk",
        id = 204328711,
        speed = 1,
        looped = true,
      },
      {
        name = "Jumping Jacks",
        id = 429681631,
        speed = 1,
        looped = true,
      },
      {
        name = "Hero Jump",
        id = 184574340,
        speed = 1,
        looped = true,
      },
      {
        name = "Faint",
        id = 181526230,
        speed = 1,
        looped = true,
      },
      {
        name = "Floor Faint",
        id = 181525546,
        speed = 2,
        looped = true,
      },
      {
        name = "Super Faint",
        id = 181525546,
        speed = 0.5,
        looped = true,
      },
      {
        name = "Levitate",
        id = 313762630,
        speed = 1,
        looped = true,
      },
      {
        name = "Goofy Dance",
        id = 182491037,
        speed = 1,
        looped = true,
      },
      {
        name = "Dab",
        id = 183412246,
        speed = 1,
        looped = true,
      },
      {
        name = "Spinner",
        id = 188632011,
        speed = 2,
        looped = true,
      },
      {
        name = "Float Sit",
        id = 179224234,
        speed = 1,
        looped = true,
      },
      {
        name = "Weird Move",
        id = 215384594,
        speed = 1,
        looped = true,
      },
      {
        name = "Clone Illusion",
        id = 215384594,
        speed = 10000000,
        looped = true,
      },
      {
        name = "Glitch Levitate",
        id = 313762630,
        speed = 10000000,
        looped = true,
      },
      {
        name = "Spin Dance",
        id = 429730430,
        speed = 1,
        looped = true,
      },
      {
        name = "Moon Dance",
        id = 45834924,
        speed = 1,
        looped = true,
      },
      {
        name = "Spin Dance 2",
        id = 186934910,
        speed = 1,
        looped = true,
      },
      {
        name = "Bow Down",
        id = 204292303,
        speed = 3,
        looped = true,
      },
      {
        name = "Sword Slam",
        id = 204295235,
        speed = 1,
        looped = true,
      },
      {
        name = "Loop Slam",
        id = 204295235,
        speed = 10000,
        looped = true,
      },
      {
        name = "Mega Insane",
        id = 184574340,
        speed = 40,
        looped = true,
      },
      {
        name = "Super Punch",
        id = 126753849,
        speed = 3,
        looped = true,
      },
      {
        name = "Arm Turbine",
        id = 259438880,
        speed = 1000,
        looped = true,
      },
      {
        name = "Barrel Roll",
        id = 136801964,
        speed = 1,
        looped = true,
      },
      {
        name = "Scared",
        id = 180612465,
        speed = 1,
        looped = true,
      },
      {
        name = "Insane",
        id = 33796059,
        speed = 100000000,
        looped = true,
      },
      {
        name = "Arm Detach",
        id = 33169583,
        speed = 1,
        looped = true,
      },
      {
        name = "Sword Slice",
        id = 35978879,
        speed = 1,
        looped = true,
      },
      {
        name = "Insane Arms",
        id = 27432691,
        speed = 1,
        looped = true,
      },
      {
        name = "/EdanceOUH",
        id = 182435998,
        speed = 1,
        looped = true,
      },
      {
        name = "/Edance 2013",
        id = 182436842,
        speed = 1,
        looped = true,
      },
      {
        name = "/EdanceYAY",
        id = 182436935,
        speed = 1,
        looped = true,
      },
      {
        name = [[
Moving Dance
WARNING | DOUBLE CLICK]],
        id = 429703734,
        speed = 1,
        looped = true,
      },
      {
        name = [[
Full Punch
WARNING | DOUBLE CLICK]],
        id = 204062532,
        speed = 1,
        looped = true,
      },
      {
        name = [[
Full Swing
WARNING | DOUBLE CLICK]],
        id = 218504594,
        speed = 1,
        looped = true,
      },
      {
        name = "Laugh",
        id = 129423131,
        speed = 1,
        looped = true,
      },
      {
        name = "Cheer",
        id = 129423030,
        speed = 1,
        looped = true,
      },
      {
        name = "Point",
        id = 128853357,
        speed = 1,
        looped = true,
      },
      {
        name = "Wave",
        id = 128777973,
        speed = 1,
        looped = true,
      },
    }, 1)

    createEmoteCard(newTab(10, "Animation R15", ""), "ANIMATION R15", {
      {
        name = "Piano Hands",
        id = 16553163212,
        speed = 1,
        looped = true,
      },
      {
        name = "Wave",
        id = 12521004586,
        speed = 1,
        looped = true,
      },
      {
        name = "Point",
        id = 12521007694,
        speed = 1,
        looped = true,
      },
      {
        name = "/edanceOUH",
        id = 12521009666,
        speed = 1,
        looped = true,
      },
      {
        name = "Laugh",
        id = 12521018724,
        speed = 1,
        looped = true,
      },
      {
        name = "Cheer",
        id = 12521021991,
        speed = 1,
        looped = true,
      },
      {
        name = "/Edance2013",
        id = 507776043,
        speed = 1,
        looped = true,
      },
      {
        name = "Patrol",
        id = 1151231493,
        speed = 1,
        looped = true,
      },
      {
        name = "Cowboy",
        id = 1014421541,
        speed = 1,
        looped = true,
      },
      {
        name = "Sneaky",
        id = 1132510133,
        speed = 1,
        looped = true,
      },
      {
        name = "PopStar",
        id = 1212980338,
        speed = 1,
        looped = true,
      },
      {
        name = "Confident",
        id = 1070017263,
        speed = 1,
        looped = true,
      },
      {
        name = "SuperHero",
        id = 567356407,
        speed = 1,
        looped = true,
      },
      {
        name = "Zombie Attack",
        id = 708553116,
        speed = 1,
        looped = true,
      },
      {
        name = "Pull",
        id = 675025795,
        speed = 1,
        looped = true,
      },
      {
        name = "Fling Arms",
        id = 754656200,
        speed = 1,
        looped = true,
      },
      {
        name = "Spinner",
        id = 754658275,
        speed = 1,
        looped = true,
      },
      {
        name = "Rotate Slash",
        id = 675025570,
        speed = 1,
        looped = true,
      },
      {
        name = "Bend",
        id = 696096087,
        speed = 1,
        looped = true,
      },
    }, 1)
  end

  function buildCommandsUI()
    local v381 = newTab(1000, "Commandes", "⌨")

    function commandCard(p125, p126, p127)
      local v382 = newInfoLabel(newCard(v381, p125, p126), 1, table.concat(p127, "\n"), 0)
      v382.Font = Enum.Font.Gotham
      v382.TextSize = 12
      v382.TextColor3 = color7
      v382.TextWrapped = true
      v382.AutomaticSize = Enum.AutomaticSize.Y
      v382.Size = UDim2.new(1, 0, 0, 0)
    end

    commandCard(1, "COMMENT UTILISER", {
      "Ouvre le chat Roblox, écris une commande qui commence par une virgule et envoie-la.",
      "Exemple : ,speedlyn 50 — règle la vitesse de marche à 50.",
      "Ces messages peuvent être visibles par les autres joueurs.",
    })

    commandCard(2, "VOL ET DÉPLACEMENTS", {
      ",flylyn — activer/désactiver Fly", ",unflylyn — arrêter Fly",
      ",flyspeedlyn 80 — régler la vitesse Fly (10–300)",
      ",vehicleflylyn / ,unvehicleflylyn — Vehicle Fly",
      ",speedlyn 50 — régler la vitesse de marche",
      ",unspeedlyn — remettre la vitesse à 16", ",gravitylyn 100 — régler la gravité",
      ",ungravitylyn — remettre la gravité à 196.2",
      ",jumplyn / ,unjumplyn — saut infini",
      ",jumpowerlyn 80 — régler la puissance du saut",
      ",nocliplyn / ,unnocliplyn — traverser les collisions",
      ",floatlyn / ,unfloatlyn — flotter", ",crawllyn / ,uncrawllyn — ramper",
    })

    commandCard(3, "VISUEL ET CAMÉRA", {
      ",fullbrightlyn / ,unfullbrightlyn — Fullbright",
      ",freecamlyn / ,unfreecamlyn — Freecam", ",esplyn / ,unesplyn — ESP",
    })

    commandCard(4, "UTILITAIRES ET AUTRES", {
      ",antiafklyn / ,unantiafklyn — Anti-AFK",
      ",antiflinglyn / ,unantiflinglyn — Anti-Fling", ",unbackstablyn — arrêter Backstab",
      ",helplyn — rappel des commandes",
    })

    commandCard(5, "PERSONNAGE ET ANIMATIONS", {
      ",sitlyn / ,unsitlyn — s’asseoir / se relever",
      ",spinlyn / ,unspinlyn — tourner / arrêter",
      ",hiplyn 5 / ,unhiplyn — régler / restaurer la hauteur",
      ",invisiblelyn / ,visiblelyn — invisibilité locale ON/OFF",
      ",resetlyn — réinitialiser le personnage",
    })

    commandCard(6, "CAMÉRA ET AMBIANCE", {
      ",fovlyn 100 / ,unfovlyn — champ de vision",
      ",daylyn / ,nightlyn — éclairage jour / nuit",
      ",cleareffectslyn — désactiver les effets locaux",
    })

    commandCard(7, "POSITIONS ET INFORMATIONS", {
      ",coordslyn — afficher les coordonnées", ",saveposlyn — enregistrer une position",
      ",loadposlyn — revenir à la position enregistrée",
      ",fpslyn / ,unfpslyn — afficher / masquer les FPS",
      ",stopalllyn — arrêter plusieurs fonctions actives",
    })

    commandCard(8, "RACCOURCIS CLAVIER", {
      "J — Fullbright ON/OFF", "G — Fly ON/OFF", "A (clavier AZERTY) — arrêter Backstab",
      "T — ramper ON/OFF", "Maj droite ou - — ouvrir/fermer le menu",
    })
  end

  function buildTutorialUI()
    local v383 = newTab(999, "Tuto", "")

    function guideCard(p128, p129, p130)
      local v384 = newCard(v383, p128, p129)

      local v385 = newInfoLabel(v384, 1, p130, 0)
      v385.TextColor3 = color7
      v385.Font = Enum.Font.Gotham
      v385.TextSize = 12
      v385.TextWrapped = true
      v385.AutomaticSize = Enum.AutomaticSize.Y
      v385.Size = UDim2.new(1, 0, 0, 0)

      return v384
    end

    guideCard(
      75, "MAP LIMIT — PLAFOND INVISIBLE",
      "Ouvre MAP LIMIT, puis active ON. Ton personnage est maintenu entre Y = 25 et Y = 155, meme en Fly. Desactive OFF pour retirer la limite. Cette fonction agit uniquement sur ton client et peut etre corrigee par le serveur."
    )

    guideCard(
      1, "BIENVENUE — COMMENT UTILISER LE PANEL",
      "Le menu à gauche contient toutes les catégories. Clique sur un onglet, puis sur un bouton pour activer une fonction. Les boutons à bascule activent/désactivent une option ; les boutons d'action lancent une action ponctuelle. Les réglages avec + et - changent la valeur. Fais défiler le contenu vers le bas pour voir toutes les options."
    )

    guideCard(
      2, "RACCOURCIS CLAVIER — À RETENIR",
      "• RightShift ou - : afficher/masquer le panel.\n• T : activer/désactiver « Tomber dans le vide » (mode ramper). Le bouton correspondant dans Personnage permet aussi de le basculer.\n• Touche G : activer/désactiver Fly. Fly : W/A/S/D pour se déplacer, Espace pour monter, Shift gauche pour descendre.\n• Vehicle Fly : W/A/S/D, Espace ou E pour monter, Shift gauche/droite ou Q pour descendre.\n• FreeCam : maintenir le clic droit et déplacer la souris pour regarder. Les déplacements de FreeCam utilisent les commandes de mouvement prévues par le script."
    )

    guideCard(
      21, "COMMANDES RAPIDES — CLAVIER FRANÇAIS (AZERTY)",
      "• J : activer / désactiver Fullbright (Utilitaires).\n• Touche G : activer / désactiver Fly (Mouvement).\n• A physique (souvent KeyCode.Q) : arrêter Backstab lorsqu'il est actif.\n• T : activer / désactiver Tomber dans le vide (ramper).\n• Maj droite ou - : afficher / masquer le menu.\n• Fly : ZQSD / WASD selon les touches reconnues ; Espace = monter, Maj gauche = descendre.\n• Vehicle Fly : déplacements, E ou Espace = monter, Q ou Maj = descendre.\n• FreeCam : clic droit maintenu = regarder autour de soi.\nCes raccourcis ne fonctionnent pas pendant la saisie dans une zone de texte."
    )

    guideCard(
      22, "COMMANDES CHAT — THELYNOXBOT",
      "Écris dans le chat (commandes locales ; messages potentiellement visibles) :\n• ,flylyn / ,unflylyn : Fly ON/OFF.\n• ,flyspeedlyn 80 : vitesse du Fly (10 à 300).\n• ,fullbrightlyn / ,unfullbrightlyn : Fullbright ON/OFF.\n• ,speedlyn 32 / ,unspeedlyn : vitesse de marche / retour à 16.\n• ,gravitylyn 100 / ,ungravitylyn : gravité / retour à 196.2.\n• ,jumplyn / ,unjumplyn : saut infini ON/OFF.\n• ,jumpowerlyn 80 : puissance du saut (0 à 300).\n• ,nocliplyn / ,unnocliplyn : Noclip ON/OFF.\n• ,floatlyn / ,unfloatlyn : Float ON/OFF.\n• ,vehicleflylyn / ,unvehicleflylyn : Vehicle Fly ON/OFF.\n• ,freecamlyn / ,unfreecamlyn : Freecam ON/OFF.\n• ,esplyn / ,unesplyn : ESP ON/OFF.\n• ,antiafklyn / ,unantiafklyn : Anti-AFK ON/OFF.\n• ,antiflinglyn / ,unantiflinglyn : Anti-Fling ON/OFF.\n• ,crawllyn / ,uncrawllyn : ramper ON/OFF.\n• ,unbackstablyn : arrêter Backstab.\n• ,helplyn : rappel des commandes.\nSans nombre, speedlyn=32, gravitylyn=100, flyspeedlyn=80, jumpowerlyn=80."
    )

    guideCard(
      3, "JOUEUR",
      "• Profil : affiche ton avatar, ton nom et ton pseudo.\n• Heure et date : horloge et date locales.\n• Chronomètre de session : temps écoulé depuis le lancement du script (également dans l'en-tête)."
    )

    guideCard(
      4, "MOUVEMENT",
      "• Activer le vol (Fly) : touche G pour activer/désactiver ; active le vol ; règle sa vitesse avec +/-.\n• WalkSpeed : règle la vitesse de marche.\n• Gravity : règle la gravité utilisée par le jeu.\n• Saut infini : permet de relancer un saut en l'air. Float : active le flottement. Puissance du saut : ajuste la valeur.\n• Noclip : tente de traverser les murs.\n• Marcher au plafond : active/désactive le déplacement au plafond ; Décalage règle la distance. La rotation suit la direction de la caméra dans la version corrigée.\n• Vehicle Fly : vol en véhicule ; règle la vitesse avec +/-.\n• Les postures spéciales ont été déplacées dans Personnage."
    )

    guideCard(
      19, "PERSONNAGE — POSTURES",
      "• Tomber dans le vide : active le mode anciennement appelé Marcher sur le ventre, également accessible avec T.\n• Marcher sur le côté gauche : utilise le mode couché sur le côté (jambe et torse).\n• Marche arrière visuelle : oriente le personnage à l'opposé du déplacement.\n• S'asseoir / Se relever : alterne la position assise et debout.\n• Évite d'activer plusieurs postures simultanément ; désactive une posture avant de changer."
    )

    guideCard(
      5, "TÉLÉPORT",
      "• Téléporter vers un joueur : recherche un joueur puis clique sur son nom.\n• Téléportation au clic : active le mode puis clique sur une surface/objet visé pour tenter de s'y téléporter.\n• Téléporter en X Y Z : saisis les coordonnées puis clique sur Téléporter.\n• Outil TPLynox : crée l'outil de téléportation indiqué.\n• Checkpoints nommés : saisis un nom et crée un checkpoint à ta position ; sélectionne-le, utilise TP pour y aller, X pour le supprimer. Les boutons permettent aussi de respawn au checkpoint ou d'effacer tous les checkpoints.\n• Position actuelle : affiche les coordonnées X/Y/Z du personnage."
    )

    guideCard(
      6, "CAMÉRA",
      "• Free Cam : active/désactive la caméra libre ; règle sa vitesse. Le clic droit sert à regarder/déplacer l'orientation.\n• Spectate : sélectionne un joueur dans la liste pour suivre son personnage. « Arrêter spectate » restaure la caméra.\n• Orbite : tourne autour du joueur sélectionné lorsque le suivi est actif."
    )

    guideCard(
      7, "VISUEL",
      "• ESP : affiche les noms et distances des autres joueurs.\n• Cheat Lines : affiche des lignes vers les joueurs.\n• Tracker : surbrillance et distance des joueurs.\n• Skeleton ESP : affiche le squelette des personnages.\n• Fullbright : augmente la luminosité visuelle, touche J pour activer/désactiver.\n• AIM (après Visuel) : Crosshair, FOV, distance et visée assistée en maintenant le clic droit.\n• AIM : maintiens clic droit pour viser ; ajuste le rayon et la douceur.\n• Le mode AIM déplace seulement la caméra : il ne tire pas automatiquement."
    )

    guideCard(
      8, "UTILITAIRES",
      "• Anti-AFK : empêche certaines détections d'inactivité.\n• Anti Fling : tente de protéger le personnage contre les projections physiques.\n• Se re-spawn : réinitialise le personnage.\n• Server Info : joueurs connectés, ping et durée de session.\n• Recharger le panel : reconstruit l'interface.\n• Kill Aura : active l'action automatique configurée et règle sa portée avec +/-. Vérifie les règles de ton propre jeu avant de l'utiliser."
    )

    guideCard(
      9, "TROLL ET BACKSTAB",
      "• Dans Troll, sélectionne un joueur dans la liste pour lancer l'action associée : saut sur sa tête, se téléporter sur son dos, bloquer la vue/danser, tourner autour, le suivre à distance, copier ses mouvements, TP spam, cage, salut aléatoire, sauter à côté, faux mort, tir ou spin.\n• Quand un bouton « Arrêter » est présent, clique dessus pour arrêter l'effet correspondant. Les durées sont indiquées dans les titres.\n• Backstab : lance-le depuis le menu ou en double-cliquant sur un joueur. Sur clavier AZERTY, appuie sur A (détecté Q dans Roblox) pour arrêter le Backstab et descendre immédiatement, sans devoir mourir. L'autre option permet de bloquer la vue/danser ; utilise Arrêter pour interrompre cet effet."
    )

    guideCard(
      10, "ANIMATION R6 / ANIMATION R15",
      "Choisis l'onglet correspondant au rig de ton avatar (R6 ou R15), puis clique sur une animation pour la lancer. Certaines animations spéciales demandent un double-clic ; si une animation ne fonctionne pas, le rig ou les permissions/ressources du jeu peuvent ne pas être compatibles."
    )

    guideCard(
      11, " KICK CARS — COMMENT UTILISER",
      "• Va dans KICK Cars, puis utilise la barre de recherche pour trouver un joueur par son pseudo ou son nom affiché.\n• Clique sur le joueur dans la liste violette pour le sélectionner comme cible.\n• Monte dans une voiture avec un VehicleSeat, puis clique sur DÉMARRER pour lancer les charges vers la cible. La vitesse est fixée à 8000 et n'est pas modifiable.\n• Clique sur ARRÊTER pour stopper KICK Cars. Change de joueur dans la liste pour sélectionner une autre cible.\n• Le bouton SPAWN CARS te téléporte directement aux coordonnées X : 631, Y : 97, Z : 2502, même sans être assis dans une voiture.\n• Attention : les déplacements et collisions de voiture dépendent de la physique et de la propriété réseau Roblox. Les impacts sur les autres joueurs ne sont pas garantis avec un LocalScript seul."
    )

    guideCard(
      13, "CAMÉRA — NOUVELLES OPTIONS",
      "• Free Cam : déplace la caméra librement ; règle la vitesse dans la catégorie Caméra.\n• Spectate : sélectionne un joueur pour suivre sa caméra ; Arrêter spectate restaure la caméra du personnage.\n• Orbite : fait tourner le personnage autour du joueur sélectionné lorsque le spectate est actif.\n• Le mode Caméra véhicule se règle séparément dans VEHICLE PRO."
    )

    guideCard(
      14, "VEHICLE PRO — CONDUITE",
      "• Compteur vitesse : affiche la vitesse du véhicule dans un petit HUD.\n• Régulateur : active une vitesse cible, ajustable avec le réglage de vitesse.\n• Caméra véhicule : ajuste la caméra pendant la conduite.\n• Limite vitesse locale : configure la limite de vitesse appliquée par l'extension.\n• Les résultats peuvent dépendre du véhicule et de la physique du serveur."
    )

    guideCard(
      15, "PERFORMANCE — FPS, PING, JOUEURS",
      "• Afficher FPS / Ping / Joueurs : active le HUD de performances en haut à droite, légèrement décalé vers la gauche.\n• FPS : nombre approximatif d'images par seconde. Ping : latence réseau. Joueurs : effectif du serveur.\n• Mode FPS : réduit localement certains effets de particules et traînées.\n• Diagnostic : indique si le GUI, le Humanoid et la pièce principale du personnage sont présents."
    )

    guideCard(
      16, "SAFETY+ — ALERTES ET RÉPARATION",
      "• Alerte joueur proche : affiche une notification quand un joueur entre dans la zone détectée.\n• Alerte forte chute : avertit lors de certaines chutes.\n• Historique des dégâts : enregistre les baisses de PV observées localement ; le bouton affiche les dernières.\n• Rétablir caméra et marche : remet la caméra sur ton personnage et restaure la marche normale."
    )

    guideCard(
      17, "ORGANISATION DES ONGLETS",
      "Ordre du menu : Recherche, Joueur, SAFETY+, Mouvement, Personnage, Utilitaires, Téléport, Caméra, Visuel, AIM, Backstab, Troll, Animation R6, Animation R15, VEHICLE PRO, KICK Cars, puis les autres catégories en dessous.\nLes catégories PLAYER+, TP PRO et CUSTOMIZER restent supprimées. Les anciennes fonctions des autres onglets sont conservées."
    )

    guideCard(
      18, "SI UNE OPTION NE FONCTIONNE PAS",
      "Certaines fonctions dépendent du type de personnage (R6/R15), des collisions, du serveur et des permissions du jeu. Teste dans ton propre jeu Roblox Studio. Si le personnage reste bloqué après un mode de mouvement, désactive d'abord ce mode, puis réinitialise le personnage si nécessaire. Le tutoriel décrit les fonctions présentes dans cette version ; il ne garantit pas que chaque action soit prise en charge par tous les jeux."
    )

    guideCard(23, "RADAR V3 — CARTE ET ZOOM", [[
1. Ouvre Visuel > RADAR JOUEURS.
2. Active Radar V3 (zoom + equipes). Le radar remplace l'ancien affichage.
3. Utilise les boutons + et - du radar pour agrandir ou reduire la zone visible.
4. Le point de ton personnage se deplace avec toi ; les autres points representent les joueurs et leurs couleurs suivent les equipes.
5. Maintiens le clic gauche sur l'en-tete du radar pour le deplacer. Les contours des batiments sont approximatifs.
6. Desactive le switch dans Visuel pour masquer le radar.]])

    guideCard(
      24, "JOUEUR — SESSION TIMER",
      "Ouvre Joueur puis descends jusqu'a SESSION TIMER. Le compteur affiche heures, minutes et secondes depuis le lancement du script. Il avance automatiquement ; tu n'as rien a activer. Le compteur repart de zero au prochain lancement."
    )

    guideCard(25, "JOUEUR — PLAYER INSPECTOR", [[
1. Ouvre Joueur > PLAYER INSPECTOR et descends jusqu'a la liste.
2. Clique sur le pseudo du joueur que tu veux examiner.
3. Le panneau affiche son nom, son equipe, ses PV et sa distance en studs.
4. Les PV et la distance sont actualises automatiquement. Si le joueur quitte le serveur ou n'a pas de personnage, certaines valeurs peuvent etre indisponibles.
5. Pour changer de cible, clique simplement sur un autre joueur.]])

    guideCard(26, "SAFETY+ — ALERTE ENNEMI", [[
1. Ouvre SAFETY+ et active Alerte ennemi 30 studs.
2. Approche-toi d'un autre joueur vivant a moins de 30 studs : la notification doit apparaitre.
3. Elle disparait lorsque personne n'est a portee. Dans cette version, la detection peut aussi inclure les joueurs neutres.
4. Pour la deplacer, maintiens le clic gauche sur la notification ou sa poignee et fais-la glisser.
5. Desactive le switch pour couper l'alerte.]])

    guideCard(27, "SAFETY+ — ALERTE PV FAIBLES", [[
1. Ouvre SAFETY+ et active Alerte PV faibles (30%).
2. Quand ta vie est inferieure ou egale a 30 % de tes PV maximum, une notification s'affiche.
3. Elle indique tes PV et disparait lorsque tu recuperes assez de vie ou desactives l'option.
4. Maintiens le clic gauche sur la notification pour la deplacer.
5. Le bouton TESTER LES ALERTES affiche temporairement les deux notifications sans attendre une blessure ou un joueur proche : il teste l'affichage, pas la detection.]])

    guideCard(
      28, "KILL FEED — MORTS ET ELIMINATIONS",
      "Le Kill Feed fonctionne automatiquement : aucun bouton a activer dans cette version.\n• Vert : ton elimination, si le jeu permet d'identifier le tueur.\n• Rouge : tu es mort ; le tueur est affiche s'il est connu.\n• Blanc : un autre joueur est mort.\nLes notifications apparaissent environ 6 secondes en haut a droite, a gauche de la liste des joueurs. Si Prison Life ne donne pas l'auteur du kill, le message peut indiquer tueur inconnu. Une mort detectee ne prouve pas toujours un kill attribuable."
    )

    guideCard(
      30, "PHOTO MODE — CAMÉRA",
      "Ouvre Caméra et clique sur Photo Mode, ou appuie sur F8. Les interfaces ScreenGui locales sont masquées pour prendre une capture. Appuie de nouveau sur F8 pour réafficher les interfaces. Les éléments Roblox CoreGui et certains éléments du jeu peuvent rester visibles."
    )

    guideCard(
      31, "KILL COUNTER — JOUEUR",
      "Dans Joueur, consulte KILL COUNTER : kills, morts et ratio K/D depuis le lancement du script. Les morts sont comptées automatiquement. Un kill est compté seulement si le jeu marque le Humanoid de la victime avec un ObjectValue creator pointant vers toi ; sinon il ne peut pas être attribué de façon fiable."
    )

    guideCard(32, "SAFETY+ — AUTO ESCAPE", [[
1. Va dans un endroit sur et ouvre SAFETY+.
2. Clique SET CHECKPOINT pour enregistrer ta position.
3. Active Auto Escape (PV <= 30%).
4. Si ta vie descend a 30% ou moins, le script tente de te ramener au checkpoint.
5. CLEAR CHECKPOINT efface le point, TESTER LE RETOUR essaie la teleportation.
6. Le point reste en memoire apres une mort, mais pas apres un nouveau lancement du script. Le serveur peut refuser la teleportation.]])

    guideCard(
      29, "DEPLACER LES FENETRES ET UTILISER LES BOUTONS",
      "• Le menu principal et le petit bouton LynGUI peuvent etre deplaces via leurs zones de glissement.\n• Radar : glisse son en-tete. Alertes : glisse leur fond ou leur poignee lorsqu'elles sont visibles.\n• Un switch ON/OFF reste actif jusqu'a ce que tu recliques dessus ou relances le script selon la fonction.\n• Un bouton TEST lance seulement un apercu ; il n'active pas forcement la surveillance.\n• Les fonctions peuvent necessiter un personnage vivant, une equipe ou un objet charge dans le jeu."
    )
  end

  local v386 = false
  local v387 = 8000

  function kickRoot(p131)
    local character83 = p131 and p131.Character
    return character83 and character83:FindFirstChild("HumanoidRootPart")
  end

  function kickSeat()
    local character84 = localPlayer.Character
    local humanoid53 = character84 and character84:FindFirstChildOfClass("Humanoid")
    local seatPart3 = humanoid53 and humanoid53.SeatPart

    if seatPart3 and seatPart3:IsA("VehicleSeat") then
      return seatPart3
    end
  end

  local connect34, kickCarsToggle

  function stopKickCars()
    v386 = false

    if connect34 then
      connect34:Disconnect()
      connect34 = nil
    end

    local v388 = kickSeat()

    if v388 then
      v388.AssemblyLinearVelocity = Vector3.zero
      v388.AssemblyAngularVelocity = Vector3.zero
    end

    if kickCarsToggle and kickCarsToggle.Parent then
      kickCarsToggle.Text = "▶  GO  •  DÉMARRER"
      kickCarsToggle.BackgroundColor3 = color5
    end
  end

  local v389, v390

  function startKickCars()
    local v391 = kickSeat()
    local v392 = kickRoot(v389)

    if not v391 then
      v390.Text = "Assieds-toi dans un VehicleSeat."
      return
    end

    if not v392 then
      v390.Text = "Sélectionne un joueur présent."
      return
    end

    stopKickCars()
    v386 = true

    kickCarsToggle.Text = "■  STOP  •  ARRÊTER"
    kickCarsToggle.BackgroundColor3 = Color3.fromRGB(112, 55, 170)

    v390.Text = "12 grandes charges/s • puissance 8000"
    local v393 = 0
    local v394 = false
    local v395 = 0
    local v396 = 1

    connect34 = runService.Heartbeat:Connect(function(delta10)
      local v397 = kickSeat()
      local v398 = kickRoot(v389)

      if not v397 or not v398 then
        stopKickCars()

        if v390 and v390.Parent then
          v390.Text = "Arrêt : voiture ou cible absente."
        end

        return
      else
        v393 = v393 + delta10
        local v399 = os.clock()

        if v393 >= 0.08333333333333333 then
          v393 = 0
          local v400 = v398.Position - v398.CFrame.LookVector * 20 + Vector3.new(0, -0.9, 0)

          if math.random() < 0.99 then
            v397.AssemblyLinearVelocity = Vector3.zero
            v397.AssemblyAngularVelocity = Vector3.zero
            v397.CFrame = CFrame.lookAt(v400, v398.Position + Vector3.new(0, -0.9, 0))
          end

          v394 = math.random() < 0.8
          v396 = math.random(0, 1) == 0 and -1 or 1
          v395 = v399 + 0.08
        end

        local v401 = v398.Position + Vector3.new(0, -0.9, 0) - v397.Position

        if v401.Magnitude > 0.1 then
          v397.AssemblyLinearVelocity = v401.Unit * v387
        end

        if v394 and v399 < v395 then
          v397.AssemblyAngularVelocity = Vector3.new(0, v396 * 28, 0)
        else
          v397.AssemblyAngularVelocity = Vector3.zero
        end

        return
      end
    end)
  end

  localPlayer.CharacterRemoving:Connect(stopKickCars)

  players.PlayerRemoving:Connect(function(player4)
    if v389 == player4 then
      v389 = nil
      stopKickCars()
    end
  end)

  local vector25 = Vector3.new(631, 97, 2502)

  function teleportToSpawnCars()
    local character85 = localPlayer.Character
    local humanoid54 = character85 and character85:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart67 = character85 and character85:FindFirstChild("HumanoidRootPart")

    if not character85 or not humanoidRootPart67 or not humanoid54 or humanoid54.Health <= 0 then
      makeTextLabel("Personnage indisponible")
      return
    end

    if v386 then
      stopKickCars()
    end

    humanoid54.Sit = false
    character85:PivotTo(CFrame.new(vector25))

    humanoidRootPart67.AssemblyLinearVelocity = Vector3.zero
    humanoidRootPart67.AssemblyAngularVelocity = Vector3.zero

    makeTextLabel("Téléporté au Spawn Cars")
  end

  function _G.LynoxPlayerListKickCars(p132)
    if not p132 or p132.Parent ~= players then
      return "FLING : joueur indisponible"
    else
      local humanoid55 = localPlayer.Character
        and localPlayer.Character:FindFirstChildOfClass("Humanoid")

      if not humanoid55 or not humanoid55.SeatPart or not humanoid55.SeatPart:IsA("VehicleSeat") then
        return "FLING : assieds-toi dans une voiture"
      end

      if v386 then
        stopKickCars()
      end

      v389 = p132
      startKickCars()
      return v386 and "FLING actif sur " .. p132.Name or "FLING : impossible de demarrer"
    end
  end

  function buildKickCarsUI()
    stopKickCars()
    local v402 = newTab(11, "KICK Cars", "")
    local parent13 = newCard(v402, 1, "KICK CARS")

    function infoLabel(parent14, text17, layoutOrder7, p133, p134)
      local textLabel18 = Instance.new("TextLabel")
      textLabel18.Size = UDim2.new(1, 0, 0, p133 or 22)
      textLabel18.BackgroundTransparency = 1
      textLabel18.TextColor3 = p134 or color8
      textLabel18.Text = text17
      textLabel18.TextWrapped = true
      textLabel18.TextXAlignment = Enum.TextXAlignment.Left
      textLabel18.Font = Enum.Font.Gotham
      textLabel18.TextSize = 12
      textLabel18.LayoutOrder = layoutOrder7
      textLabel18.Parent = parent14

      return textLabel18
    end

    local kickCarsPlayerSearch = Instance.new("TextBox")
    kickCarsPlayerSearch.Name = "KickCarsPlayerSearch"
    kickCarsPlayerSearch.Size = UDim2.new(1, 0, 0, 30)
    kickCarsPlayerSearch.BackgroundColor3 = color2
    kickCarsPlayerSearch.BorderSizePixel = 0
    kickCarsPlayerSearch.TextColor3 = color7
    kickCarsPlayerSearch.PlaceholderColor3 = color8
    kickCarsPlayerSearch.PlaceholderText = "Rechercher un joueur..."
    kickCarsPlayerSearch.Text = ""
    kickCarsPlayerSearch.ClearTextOnFocus = false
    kickCarsPlayerSearch.Font = Enum.Font.Gotham
    kickCarsPlayerSearch.TextSize = 12
    kickCarsPlayerSearch.LayoutOrder = 1
    kickCarsPlayerSearch.Parent = parent13

    corner(kickCarsPlayerSearch, 8)

    local kickCarsPlayers = Instance.new("ScrollingFrame")
    kickCarsPlayers.Name = "KickCarsPlayers"
    kickCarsPlayers.Size = UDim2.new(1, 0, 0, 120)
    kickCarsPlayers.BackgroundColor3 = color2
    kickCarsPlayers.BorderSizePixel = 0
    kickCarsPlayers.ScrollBarThickness = 4
    kickCarsPlayers.ScrollBarImageColor3 = color5
    kickCarsPlayers.AutomaticCanvasSize = Enum.AutomaticSize.Y
    kickCarsPlayers.CanvasSize = UDim2.new(0, 0, 0, 0)
    kickCarsPlayers.LayoutOrder = 2
    kickCarsPlayers.Parent = parent13

    corner(kickCarsPlayers, 8)
    padding(kickCarsPlayers, 4)

    local uiListLayout7 = Instance.new("UIListLayout")
    uiListLayout7.SortOrder = Enum.SortOrder.Name
    uiListLayout7.Padding = UDim.new(0, 4)
    uiListLayout7.Parent = kickCarsPlayers

    function refreshKickList()
      if not kickCarsPlayers.Parent then
        return
      else
        for index65, value62 in ipairs(kickCarsPlayers:GetChildren()) do
          if value62:IsA("TextButton") or value62.Name == "EmptySearch" then
            value62:Destroy()
          end
        end

        local v403 = string.lower(kickCarsPlayerSearch.Text or "")

        for index66, value63 in ipairs(players:GetPlayers()) do
          local v404 = value63

          if v404 ~= localPlayer
            and (v403 == "" or string.find(string.lower(v404.Name), v403, 1, true)
              or string.find(string.lower(v404.DisplayName), v403, 1, true)) then
            local textButton21 = Instance.new("TextButton")
            textButton21.Name = v404.Name
            textButton21.Size = UDim2.new(1, 0, 0, 28)
            textButton21.BackgroundColor3 = color5
            textButton21.BorderSizePixel = 0
            textButton21.TextColor3 = color7

            textButton21.Text = v404.DisplayName ~= v404.Name
                and v404.DisplayName .. "  @" .. v404.Name
              or v404.Name

            textButton21.TextSize = 12
            textButton21.Font = Enum.Font.Gotham
            textButton21.AutoButtonColor = false
            textButton21.Parent = kickCarsPlayers

            corner(textButton21, 6)

            textButton21.MouseEnter:Connect(function()
              tweenService:Create(textButton21, TweenInfo.new(0.1), {
                BackgroundColor3 = color6,
              }):Play()
            end)

            textButton21.MouseLeave:Connect(function()
              tweenService:Create(textButton21, TweenInfo.new(0.1), {
                BackgroundColor3 = color5,
              }):Play()
            end)

            textButton21.MouseButton1Click:Connect(function()
              if v386 then
                stopKickCars()
              end

              v389 = v404
              makeTextLabel("Cible : " .. v404.DisplayName, nil)
            end)
          end
        end

        return
      end
    end

    kickCarsPlayerSearch:GetPropertyChangedSignal("Text"):Connect(refreshKickList)
    refreshKickList()
    local playerAdded2 = players.PlayerAdded
    table.insert(v220, playerAdded2:Connect(refreshKickList))
    local playerRemoving2 = players.PlayerRemoving
    table.insert(v220, playerRemoving2:Connect(function() task.defer(refreshKickList) end))
    local v405 = newCard(v402, 2, "CONTRÔLES")
    v387 = 8000
    infoLabel(v405, "Vitesse fixe : 8000  |  12 charges/s", 1, 22)

    kickCarsToggle = Instance.new("TextButton")
    kickCarsToggle.Name = "KickCarsToggle"
    kickCarsToggle.Size = UDim2.new(1, 0, 0, 36)
    kickCarsToggle.BackgroundColor3 = color5
    kickCarsToggle.BorderSizePixel = 0
    kickCarsToggle.TextColor3 = color7
    kickCarsToggle.Text = "DÉMARRER"
    kickCarsToggle.Font = Enum.Font.GothamBold
    kickCarsToggle.TextSize = 13
    kickCarsToggle.LayoutOrder = 2
    kickCarsToggle.Parent = v405

    corner(kickCarsToggle, 7)
    v390 = infoLabel(v405, "Prêt - physique locale", 3, 22)
    local v406 = newCard(v402, 3, "SPAWN CARS")
    infoLabel(v406, "X : 631   Y : 97   Z : 2502", 1, 22)

    local spawnCarsTeleport = Instance.new("TextButton")
    spawnCarsTeleport.Name = "SpawnCarsTeleport"
    spawnCarsTeleport.Size = UDim2.new(1, 0, 0, 36)
    spawnCarsTeleport.BackgroundColor3 = color5
    spawnCarsTeleport.BorderSizePixel = 0
    spawnCarsTeleport.TextColor3 = color7
    spawnCarsTeleport.Text = "SE TÉLÉPORTER AU SPAWN CARS"
    spawnCarsTeleport.Font = Enum.Font.GothamBold
    spawnCarsTeleport.TextSize = 12
    spawnCarsTeleport.LayoutOrder = 2
    spawnCarsTeleport.Parent = v406

    corner(spawnCarsTeleport, 7)
    spawnCarsTeleport.MouseButton1Click:Connect(teleportToSpawnCars)

    kickCarsToggle.MouseButton1Click:Connect(function()
      if v386 then
        stopKickCars()
        v390.Text = "Arrêté"
        makeTextLabel("KICK Cars", "OFF")
      else
        v387 = 8000
        startKickCars()

        if v386 then
          makeTextLabel("KICK Cars", "ON")
        end
      end
    end)
  end
end

do
  local localPlayer3 = players.LocalPlayer

  local v407 = {
    fov = 70,
    crosshair = false,
    showDistances = false,
    names = false,
    night = false,
    day = false,
    fog = false,
    lowFx = false,
    fps = false,
    proximity = false,
    aimEnabled = false,
    aimRadius = 1200,
    aimSmooth = 85,
    aimHolding = false,
    fallAlert = false,
    damageLog = false,
    spectator = nil,
    orbit = false,
    statue = false,
    backward = false,
    autoDance = false,
    ghost = false,
    cameraVehicle = false,
    cruise = false,
    cruiseSpeed = 40,
    maxVehicleSpeed = 110,
    shortcuts = true,
    positionHistory = {},
    healthEvents = {},
    fpsCount = 0,
    fpsTime = 0,
  }

  local v408 = {}

  function charParts()
    local character86 = localPlayer3.Character
    return character86, character86 and character86:FindFirstChildOfClass("Humanoid"), character86 and character86:FindFirstChild("HumanoidRootPart")
  end

  local v409

  function info(text18)
    if v409 and v409.Parent then
      v409.Text = text18
    end

    if type(makeTextLabel) == "function" then
      makeTextLabel(text18, nil)
    end
  end

  function btn(parent15, p135, text19, p136)
    local textButton22 = Instance.new("TextButton")
    textButton22.Name = "Extra_" .. p135
    textButton22.Size = UDim2.new(1, 0, 0, 34)
    textButton22.LayoutOrder = p135
    textButton22.BackgroundColor3 = color5
    textButton22.TextColor3 = color7
    textButton22.Text = text19
    textButton22.Font = Enum.Font.GothamBold
    textButton22.TextSize = 12
    textButton22.TextWrapped = true
    textButton22.Parent = parent15

    corner(textButton22, 8)

    textButton22.MouseButton1Click:Connect(function()
      local v410, v411 = pcall(p136, textButton22)

      if not v410 then
        warn("[Lynox Extension] " .. tostring(v411))
        info("Erreur : " .. tostring(v411))
      end
    end)

    return textButton22
  end

  function toggle(p137, p138, text20, key32, p139)
    return btn(p137, p138, text20 .. " : OFF", function(text21)
      v407[key32] = not v407[key32]

      text21.Text = text20 .. (v407[key32] and " : ON" or " : OFF")
      text21.BackgroundColor3 = v407[key32] and color6 or color5

      if p139 then
        p139(v407[key32])
      end
    end)
  end

  function step(p140, p141, p142, p143, p144, p145, p146, p147)
    local v412 = p143

    newStepper(p140, p141, p142, p143, p144, function(p148)
      v412 = math.clamp(p148, p145, p146)

      if p147 then
        p147(v412)
      end

      return v412
    end)
  end

  function page(p149, p150, p151)
    return newTab(p151, p149, p150)
  end

  function card(p152, p153, p154)
    return newCard(p152, p153, p154)
  end

  local theLynoxExtrasOverlay

  function hud()
    if theLynoxExtrasOverlay and theLynoxExtrasOverlay.Parent then
      return theLynoxExtrasOverlay
    end

    theLynoxExtrasOverlay = Instance.new("ScreenGui")
    theLynoxExtrasOverlay.Name = "TheLynoxExtrasOverlay"
    theLynoxExtrasOverlay.ResetOnSpawn = false
    theLynoxExtrasOverlay.IgnoreGuiInset = true
    theLynoxExtrasOverlay.DisplayOrder = 1001
    theLynoxExtrasOverlay.Parent = localPlayer3:WaitForChild("PlayerGui")

    return theLynoxExtrasOverlay
  end

  function hudLabel(p155, position21, size2, text22)
    local findFirstChild3 = hud():FindFirstChild(p155)

    if not findFirstChild3 then
      findFirstChild3 = Instance.new("TextLabel")
      findFirstChild3.Name = p155
      findFirstChild3.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
      findFirstChild3.BackgroundTransparency = 0.28
      findFirstChild3.TextColor3 = Color3.fromRGB(245, 245, 255)
      findFirstChild3.TextStrokeTransparency = 0.6
      findFirstChild3.Font = Enum.Font.GothamBold
      findFirstChild3.TextSize = 13
      findFirstChild3.Parent = hud()

      corner(findFirstChild3, 7)
    end

    findFirstChild3.Position = position21
    findFirstChild3.Size = size2
    findFirstChild3.Text = text22

    return findFirstChild3
  end

  function teleport(cframe18)
    local v413, v414, v415 = charParts()

    if v415 then
      table.insert(v407.positionHistory, 1, v415.CFrame)

      if #v407.positionHistory > 15 then
        table.remove(v407.positionHistory)
      end

      v415.CFrame = cframe18
    end
  end

  function choosePlayer(p156, p157, fn22)
    newPlayerList(p156, p157, function(p158)
      if p158 and p158 ~= localPlayer3 then
        fn22(p158)
      end
    end, false)
  end

  function buildLynoxExtras()
    p = page("AIM", "", 116)
    c = card(p, 1, "AIMBOT EXTERNE")

    btn(c, 1, "Lancer aimbot externe", function()
      if type(_G.LynoxLoadExternalAimbot) == "function" then
        info(_G.LynoxLoadExternalAimbot() and "Aimbot externe lance"
          or "Erreur de chargement aimbot")
      else
        info("Chargeur aimbot indisponible")
      end
    end)

    p = page("VEHICLE PRO", "", 113)
    c = card(p, 1, "CONDUITE")

    toggle(c, 1, "Compteur vitesse", "vehicleHud", function(visible)
      hudLabel(
        "LynoxVehicleSpeed", UDim2.new(0.5, -95, 1, -110), UDim2.fromOffset(190, 35),
        "Vehicule : --"
      ).Visible = visible
    end)

    toggle(c, 2, "Regulateur vitesse", "cruise")

    step(c, 3, "Vitesse regulateur", 40, 5, 10, 150, function(cruiseSpeed)
      v407.cruiseSpeed = cruiseSpeed
    end)

    toggle(c, 4, "Camera vehicule", "cameraVehicle")

    step(c, 5, "Limite vitesse locale", 110, 10, 20, 250, function(maxVehicleSpeed)
      v407.maxVehicleSpeed = maxVehicleSpeed
    end)

    p = page("Caméra", "", 114)
    c = card(p, 1, "FREE CAM")
    newSwitch(c, 1, "Activer Free Cam (clic droit = regarder)", toggleFreeCam)

    newStepper(c, 2, "Vitesse Free Cam", v181, 10, function(p159)
      v181 = math.clamp(p159, 10, 300)
      return v181
    end)

    c = card(p, 2, "SPECTATE / ORBITE")

    choosePlayer(c, 1, function(p160)
      v407.spectator = p160
      local humanoid56 = p160.Character and p160.Character:FindFirstChildOfClass("Humanoid")

      if humanoid56 and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraSubject = humanoid56
      end

      info("Spectate : " .. p160.Name)
    end)

    btn(c, 2, "Arreter spectate", function()
      v407.spectator = nil
      local v416, v417 = charParts()

      if v417 and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraSubject = v417
      end
    end)

    toggle(c, 3, "Orbite autour du spectate", "orbit")
    p = page("PERFORMANCE", "", 117)
    c = card(p, 1, "STATISTIQUES")

    toggle(c, 1, "Afficher FPS / Ping / Joueurs", "fps", function(visible2)
      hudLabel(
        "LynoxPerformance", UDim2.new(1, -370, 0, 12), UDim2.fromOffset(230, 35),
        "FPS : --"
      ).Visible = visible2
    end)

    toggle(c, 2, "Mode FPS (effets reduits)", "lowFx", function(p161)
      for index67, value64 in ipairs(workspace:GetDescendants()) do
        if value64:IsA("ParticleEmitter") or value64:IsA("Trail") then
          if p161 then
            value64:SetAttribute("LynoxOldEnabled", value64.Enabled)
            value64.Enabled = false
          else
            local lynoxOldEnabled = value64:GetAttribute("LynoxOldEnabled")

            if lynoxOldEnabled ~= nil then
              value64.Enabled = lynoxOldEnabled
              value64:SetAttribute("LynoxOldEnabled", nil)
            end
          end
        end
      end
    end)

    btn(c, 3, "Afficher diagnostic", function()
      local v418 = { charParts() }

      info("GUI : OK | Joueurs : " .. #players:GetPlayers() .. " | Humanoid : "
        .. tostring(v418[2] ~= nil) .. " | Root : " .. tostring(v418[3] ~= nil))
    end)

    c = card(p, 2, "STATUT EXTENSION")

    v409 = newInfoLabel(
      c, 1, "Extension chargee : AIM, Caméra, VEHICLE PRO, SAFETY+, PERFORMANCE", 42
    )

    local v419 = 0
    local v420 = 0
    local heartbeat = runService.Heartbeat
    local health

    table.insert(v408, heartbeat:Connect(function(index68)
      v407.fpsCount = v407.fpsCount + 1
      v407.fpsTime = v407.fpsTime + index68

      local v421, v422, v423 = charParts()

      if v422 then
        if v422.WalkSpeed ~= v6 then
          v422.WalkSpeed = v6
        end

        if v422.FloorMaterial ~= Enum.Material.Air then
          v407.extraJump = true
        end

        if v407.damageLog and health and v422.Health < health - 0.01 then
          table.insert(v407.healthEvents, 1, os.date("%H:%M:%S") .. " -" .. math.floor(health - v422.Health + 0.5)
            .. " PV")

          if #v407.healthEvents > 20 then
            table.remove(v407.healthEvents)
          end
        end

        health = v422.Health
      end

      if v407.fallAlert and v423 and v423.AssemblyLinearVelocity.Y < -95
        and os.clock() - v420 > 3 then
        v420 = os.clock()
        info("Attention : chute rapide !")
      end

      v419 = v419 + index68

      if v419 < 0.35 then
        return
      end

      v419 = 0
      local v424

      if v407.fps then
        local lynoxPerformance = hud():FindFirstChild("LynoxPerformance")

        if lynoxPerformance then
          v424 = "--"

          pcall(function()
            local dataPing = statsService.Network.ServerStatsItem["Data Ping"]
            v424 = math.floor(dataPing:GetValue())
          end)

          lynoxPerformance.Text = "FPS "
            .. (v407.fpsTime > 0 and math.floor(v407.fpsCount / v407.fpsTime + 0.5) or 0)
            .. " | Ping " .. tostring(v424) .. " | Joueurs " .. #players:GetPlayers()
        end
      end

      v407.fpsCount = 0
      v407.fpsTime = 0

      if v407.vehicleHud or v407.cruise or v407.cameraVehicle then
        local seatPart4 = v422 and v422.SeatPart
        local vehicleSeat2 = seatPart4 and seatPart4:IsA("VehicleSeat") and seatPart4 or nil

        if v407.vehicleHud then
          local lynoxVehicleSpeed = hud():FindFirstChild("LynoxVehicleSpeed")

          if lynoxVehicleSpeed then
            lynoxVehicleSpeed.Text = "Vitesse : "
              .. (vehicleSeat2
                  and math.floor(vehicleSeat2.AssemblyLinearVelocity.Magnitude + 0.5)
                or 0)
              .. " studs/s"
          end
        end

        if vehicleSeat2 and v407.cruise then
          local assemblyLinearVelocity8 = vehicleSeat2.AssemblyLinearVelocity
          local vector26 = Vector3.new(assemblyLinearVelocity8.X, 0, assemblyLinearVelocity8.Z)

          if vector26.Magnitude > 1 then
            local v425 = math.min(v407.cruiseSpeed, v407.maxVehicleSpeed)

            vehicleSeat2.AssemblyLinearVelocity = vector26.Unit * v425
              + Vector3.new(0, assemblyLinearVelocity8.Y, 0)
          end
        end

        if vehicleSeat2 and v407.cameraVehicle and workspace.CurrentCamera then
          workspace.CurrentCamera.FieldOfView = math.clamp(70
            + vehicleSeat2.AssemblyLinearVelocity.Magnitude / 8, 70, 100)
        end
      end

      if v407.showDistances or v407.names then
        local v426 = nil
        local v427 = 150

        if v423 then
          for index69, value65 in ipairs(players:GetPlayers()) do
            local character87 = value65.Character

            local humanoidRootPart68 = character87

            humanoidRootPart68 = character87
              and value65.Character:FindFirstChild("HumanoidRootPart")

            if value65 ~= localPlayer3 and humanoidRootPart68 then
              local magnitude5 = (v423.Position - humanoidRootPart68.Position).Magnitude

              if magnitude5 < v427 then
                v427 = magnitude5
                v426 = value65
              end
            end
          end
        end

        local v428 = hudLabel("LynoxNearest", UDim2.new(0.5, -100, 0, 90), UDim2.fromOffset(200, 28), v426
            and (v407.names and v426.DisplayName or "Joueur")
              .. (v407.showDistances and " : " .. math.floor(v427) .. " studs" or "")
          or "Aucun joueur proche")

        v428.Visible = true
      else
        local v429 = theLynoxExtrasOverlay

        local lynoxNearest = v429
        lynoxNearest = v429 and theLynoxExtrasOverlay:FindFirstChild("LynoxNearest")

        if lynoxNearest then
          lynoxNearest.Visible = false
        end
      end

      if v407.proximity and v423 and os.clock() - v420 > 5 then
        for index70, value66 in ipairs(players:GetPlayers()) do
          local character88 = value66.Character

          local humanoidRootPart69 = character88

          humanoidRootPart69 = character88
            and value66.Character:FindFirstChild("HumanoidRootPart")

          if value66 ~= localPlayer3 and humanoidRootPart69
            and (humanoidRootPart69.Position - v423.Position).Magnitude < 14 then
            v420 = os.clock()
            info("Joueur proche : " .. value66.Name)
            break
          end
        end
      end

      if v407.orbit and v407.spectator and v423 then
        local character89 = v407.spectator.Character

        local humanoidRootPart70 = character89

        humanoidRootPart70 = character89
          and v407.spectator.Character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart70 then
          local v430 = os.clock() * 1.5

          v423.CFrame = CFrame.lookAt(humanoidRootPart70.Position
            + Vector3.new(math.cos(v430) * 8, 2, math.sin(v430) * 8), humanoidRootPart70.Position)
        end
      end
    end))

    local characterAdded = localPlayer3.CharacterAdded

    table.insert(v408, characterAdded:Connect(function()
      v407.extraJump = false
      health = nil
    end))
  end
end

do
  local v431 = {}
  local v432 = {}

  function lynParts()
    local character90 = localPlayer.Character
    return character90, character90 and character90:FindFirstChildOfClass("Humanoid"), character90 and character90:FindFirstChild("HumanoidRootPart")
  end

  function lynChatMessage(p162)
    makeTextLabel("Commande Lyn", tostring(p162))
  end

  function lynSetInvisible(p163)
    local character91 = localPlayer.Character

    if not character91 then
      return
    end

    for index71, value67 in ipairs(character91:GetDescendants()) do
      if value67:IsA("BasePart") or value67:IsA("Decal") then
        if p163 then
          if v431[value67] == nil then
            v431[value67] = value67.LocalTransparencyModifier or 0
          end

          if value67:IsA("BasePart") then
            value67.LocalTransparencyModifier = 1
          end
        elseif value67:IsA("BasePart") then
          value67.LocalTransparencyModifier = v431[value67] or 0
        end
      end
    end

    if not p163 then
      table.clear(v431)
    end
  end

  local connect35

  function lynStopSpin()
    if connect35 then
      connect35:Disconnect()
      connect35 = nil
    end

    local v433, v434 = lynParts()

    if v434 then
      v434.AutoRotate = true
    end
  end

  local connect36, v435

  function lynStopFps()
    if connect36 then
      connect36:Disconnect()
      connect36 = nil
    end

    if v435 then
      v435:Destroy()
      v435 = nil
    end
  end

  local cframe19, hipHeight, fieldOfView

  function lynHandleExtraCommand(p164, p165)
    local v436, v437, v438 = lynParts()
    local textLabel19, v439, v440

    if p164 == "sitlyn" or p164 == "unsitlyn" then
      if v437 then
        v437.Sit = p164 == "sitlyn"
      end

      lynChatMessage(p164 .. " : OK")
      return true
    elseif p164 == "spinlyn" then
      lynStopSpin()

      if v438 and v437 then
        v437.AutoRotate = false

        connect35 = runService.Heartbeat:Connect(function(delta11)
          if not v438.Parent then
            lynStopSpin()
            return
          end

          v438.CFrame = v438.CFrame * CFrame.Angles(0, delta11 * math.rad(360), 0)
        end)
      end

      lynChatMessage(p164 .. " : OK")
      return true
    elseif p164 == "unspinlyn" then
      lynStopSpin()
      lynChatMessage(p164 .. " : OK")
      return true
    elseif p164 == "fovlyn" then
      local currentCamera7 = workspace.CurrentCamera

      if currentCamera7 then
        fieldOfView = fieldOfView or currentCamera7.FieldOfView
        currentCamera7.FieldOfView = math.clamp(tonumber(p165) or 100, 40, 120)
      end

      lynChatMessage(p164 .. " : OK")
      return true
    elseif p164 == "unfovlyn" then
      if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fieldOfView or 70
      end

      lynChatMessage(p164 .. " : OK")
      return true
    elseif p164 == "hiplyn" then
      if v437 then
        hipHeight = hipHeight or v437.HipHeight
        v437.HipHeight = math.clamp(tonumber(p165) or 5, 0, 25)
      end

      lynChatMessage(p164 .. " : OK")
      return true
    else
      if p164 == "unhiplyn" then
        if v437 then
          v437.HipHeight = hipHeight or 2
        end

        lynChatMessage(p164 .. " : OK")
        return true
      end

      if p164 == "daylyn" or p164 == "nightlyn" then
        lighting.ClockTime = p164 == "daylyn" and 14 or 0
        lynChatMessage(p164 .. " : OK")
        return true
      end

      if p164 == "invisiblelyn" or p164 == "visiblelyn" then
        lynSetInvisible(p164 == "invisiblelyn")
        lynChatMessage(p164 .. " : OK")
        return true
      elseif p164 == "resetlyn" then
        if v437 then
          v437.Health = 0
        end

        lynChatMessage(p164 .. " : OK")
        return true
      elseif p164 == "coordslyn" then
        if v438 then
          local position22 = v438.Position

          lynChatMessage(string.format(
            "X %.1f | Y %.1f | Z %.1f", position22.X, position22.Y, position22.Z
          ))
        end

        return true
      elseif p164 == "saveposlyn" then
        if v438 then
          cframe19 = v438.CFrame
        end

        lynChatMessage(p164 .. " : OK")
        return true
      elseif p164 == "loadposlyn" then
        if v438 and cframe19 then
          v438.CFrame = cframe19
          v438.AssemblyLinearVelocity = Vector3.zero

          lynChatMessage(p164 .. " : OK")
          return true
        end

        lynChatMessage("Aucune position enregistrée")
        return true
      elseif p164 == "fpslyn" then
        if not connect36 then
          local lynChatFPS = Instance.new("ScreenGui")
          lynChatFPS.Name = "LynChatFPS"
          lynChatFPS.ResetOnSpawn = false
          lynChatFPS.Parent = localPlayer:WaitForChild("PlayerGui")

          textLabel19 = Instance.new("TextLabel")
          textLabel19.Size = UDim2.fromOffset(115, 30)
          textLabel19.Position = UDim2.new(1, -130, 0, 55)
          textLabel19.BackgroundColor3 = Color3.fromRGB(52, 28, 79)
          textLabel19.TextColor3 = Color3.fromRGB(75, 235, 245)
          textLabel19.Font = Enum.Font.GothamBold
          textLabel19.TextSize = 15
          textLabel19.Parent = lynChatFPS

          v435 = lynChatFPS
          v439 = 0
          v440 = 0

          connect36 = runService.RenderStepped:Connect(function(delta12)
            v439 = v439 + delta12
            v440 = v440 + 1

            if v439 >= 0.5 then
              textLabel19.Text = "FPS : " .. math.floor(v440 / v439 + 0.5)
              v439 = 0
              v440 = 0
            end
          end)
        end

        lynChatMessage(p164 .. " : OK")
        return true
      elseif p164 == "unfpslyn" then
        lynStopFps()
        lynChatMessage(p164 .. " : OK")
        return true
      elseif p164 == "cleareffectslyn" then
        for index72, value68 in ipairs(workspace:GetDescendants()) do
          if value68:IsA("ParticleEmitter") or value68:IsA("Trail") or value68:IsA("Beam") then
            if v432[value68] == nil then
              v432[value68] = value68.Enabled
            end

            value68.Enabled = false
          end
        end

        lynChatMessage(p164 .. " : OK")
        return true
      else
        if p164 == "stopalllyn" then
          lynStopSpin()
          lynStopFps()
          lynSetInvisible(false)

          if v437 then
            v437.Sit = false
            v437.HipHeight = hipHeight or v437.HipHeight
          end

          if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = fieldOfView or 70
          end

          for index73, value69 in ipairs({
            { "fly", v4, stopFly }, { "vehicle", v17, stopVehicleFly },
            { "noclip", v14, stopNoclip }, { "float", v8, stopFloat },
            { "freecam", v11, stopFreeCam }, { "backstab", true, stopBackstab },
          }) do
          end

          if v16 then
            toggleFullbright(function() end)
          end

          setWalkSpeed(16)
          setGravity(196.2)

          for key33, value70 in pairs(v432) do
            if key33.Parent then
              key33.Enabled = value70
            end
          end

          table.clear(v432)
          lynChatMessage(p164 .. " : OK")
          return true
        end

        return false
      end
    end
  end

  local v441 = ""
  local v442 = 0

  function lynNotify(p166, p167)
    makeTextLabel(p166 .. " (chat)", p167)
  end

  function lynToggle(p168, fn23, fn24)
    fn23(function() end)
    lynNotify(p168, fn24() and "ON" or "OFF")
  end

  local v443 = {
    flylyn = { "Fly", toggleFly, function() return v4 end },
    fullbrightlyn = { "Fullbright", toggleFullbright, function() return v16 end },
    jumplyn = { "Saut infini", toggleInfiniteJump, function() return v7 end },
    nocliplyn = { "Noclip", toggleNoclip, function() return v14 end },
    floatlyn = { "Float", toggleFloat, function() return v8 end },
    vehicleflylyn = { "Vehicle Fly", toggleVehicleFly, function() return v17 end },
    freecamlyn = { "Freecam", toggleFreeCam, function() return v11 end },
    esplyn = { "ESP", toggleESP, function() return v12 end },
    antiafklyn = { "Anti-AFK", toggleAntiAfk, function() return v13 end },
    antiflinglyn = { "Anti-Fling", toggleAntiFling, function() return v202 end },
  }

  v443.crawllyn = { "Ramper", toggleCrawl, function() return v19 end }

  function onLynChatCommand(p169)
    if type(p169) ~= "string" then
      return
    else
      local v444, v445 = p169:lower():match("^%s*,([%a]+lyn)%s*(.-)%s*$")

      if not v444 then
        return
      else
        local v446 = p169 == v441
        local v447 = os.clock()

        if v446 and v447 - v442 < 0.35 then
          return
        end

        v441 = p169
        v442 = v447

        if v444 == "jumppowerlyn" then
          v444 = "jumpowerlyn"
        end

        if v444 == "helplyn" then
          lynNotify(
            "Commandes",
            "Voir la liste des commandes chat existantes ; + sit, spin, fov, hip, day, night, invisible, reset, coords, savepos, loadpos, fps, cleareffects, stopall"
          )

          return
        elseif v444 == "speedlyn" then
          local v448 = tonumber(v445)

          if not v448 then
            v448 = 32
          end

          lynNotify("WalkSpeed", tostring((setWalkSpeed(v448))))
          return
        elseif v444 == "unspeedlyn" then
          setWalkSpeed(16)
          lynNotify("WalkSpeed", "16")
          return
        elseif v444 == "gravitylyn" then
          local v449 = tonumber(v445)

          if not v449 then
            v449 = 100
          end

          lynNotify("Gravité", tostring(setGravity(v449)))
          return
        elseif v444 == "ungravitylyn" then
          lynNotify("Gravité", tostring(setGravity(196.2)))
          return
        elseif v444 == "flyspeedlyn" then
          v5 = math.clamp(tonumber(v445) or 80, 10, 300)
          lynNotify("Fly vitesse", tostring(v5))
          return
        elseif v444 == "jumpowerlyn" then
          v15.jumpPower = math.clamp(tonumber(v445) or 80, 0, 300)
          lynNotify("Puissance saut", tostring(v15.jumpPower))
          return
        elseif v444 == "unbackstablyn" then
          stopBackstab()
          lynNotify("Backstab", "OFF")
          return
        elseif lynHandleExtraCommand(v444, v445) then
          return
        else
          local unLyn = v444:match("^un(.+lyn)$")

          if unLyn and v443[unLyn] then
            local v450 = v443[unLyn]

            if v450[3]() then
              v450[2](function() end)
            end

            lynNotify(v450[1], "OFF")
            return
          else
            local v451 = v443[v444]

            if v451 then
              lynToggle(v451[1], v451[2], v451[3])
            end

            return
          end
        end
      end
    end
  end
end

localPlayer.Chatted:Connect(onLynChatCommand)

pcall(function()
  textChatService.SendingMessage:Connect(function(p170) onLynChatCommand(p170.Text) end)
end)

_G.LynoxSafetyV4 = { enemy = false, health = false, test = nil }

task.spawn(function()
  local v452, v453 = xpcall(function()
    local localPlayer4 = players.LocalPlayer
    local waitForChild3 = localPlayer4:WaitForChild("PlayerGui", 15)

    if not waitForChild3 then
      error("PlayerGui introuvable")
    end

    local lynoxSafetyV4 = waitForChild3:FindFirstChild("LynoxSafetyV4")

    if lynoxSafetyV4 then
      lynoxSafetyV4:Destroy()
    end

    local lynoxSafetyV42 = Instance.new("ScreenGui")
    lynoxSafetyV42.Name = "LynoxSafetyV4"
    lynoxSafetyV42.ResetOnSpawn = false
    lynoxSafetyV42.DisplayOrder = 10020
    lynoxSafetyV42.Parent = waitForChild3

    local function makeTextButton5(name, p171, color18)
      local frame26 = Instance.new("Frame")
      frame26.Name = name
      frame26.AnchorPoint = Vector2.new(0.5, 0)
      frame26.Position = UDim2.new(0.5, 0, 0, p171)
      frame26.Size = UDim2.fromOffset(350, 48)
      frame26.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
      frame26.BorderSizePixel = 0
      frame26.Visible = false
      frame26.Active = true
      frame26.Parent = lynoxSafetyV42

      Instance.new("UICorner", frame26).CornerRadius = UDim.new(0, 8)
      Instance.new("UIStroke", frame26).Color = Color3.fromRGB(55, 55, 60)

      local textLabel20 = Instance.new("TextLabel")
      textLabel20.Size = UDim2.new(1, -54, 1, 0)
      textLabel20.Position = UDim2.fromOffset(12, 0)
      textLabel20.BackgroundTransparency = 1
      textLabel20.TextColor3 = color18
      textLabel20.Font = Enum.Font.GothamBold
      textLabel20.TextSize = 12
      textLabel20.TextXAlignment = Enum.TextXAlignment.Left
      textLabel20.TextWrapped = true
      textLabel20.Text = ""
      textLabel20.Parent = frame26

      local textButton23 = Instance.new("TextButton")
      textButton23.Size = UDim2.fromOffset(42, 48)
      textButton23.Position = UDim2.new(1, -42, 0, 0)
      textButton23.Text = "⠿"
      textButton23.ZIndex = 3
      textButton23.TextSize = 22
      textButton23.TextColor3 = Color3.new(1, 1, 1)
      textButton23.BackgroundTransparency = 1
      textButton23.Parent = frame26

      local v454 = false
      local position23, position24

      local function f34(p172)
        if p172.UserInputType == Enum.UserInputType.MouseButton1
          or p172.UserInputType == Enum.UserInputType.Touch then
          v454 = true
          position23 = p172.Position
          position24 = frame26.Position
        end
      end

      textButton23.InputBegan:Connect(f34)
      frame26.InputBegan:Connect(f34)

      local connect37 = userInputService.InputChanged:Connect(function(input8)
        if v454
          and (input8.UserInputType == Enum.UserInputType.MouseMovement
            or input8.UserInputType == Enum.UserInputType.Touch) then
          local v455 = input8.Position - position23

          frame26.Position = UDim2.new(
            position24.X.Scale, position24.X.Offset + v455.X, position24.Y.Scale,
            position24.Y.Offset + v455.Y
          )
        end
      end)

      local connect38 = userInputService.InputEnded:Connect(function(input9)
        if input9.UserInputType == Enum.UserInputType.MouseButton1
          or input9.UserInputType == Enum.UserInputType.Touch then
          v454 = false
        end
      end)

      lynoxSafetyV42.Destroying:Connect(function()
        connect37:Disconnect()
        connect38:Disconnect()
      end)

      return frame26, textLabel20
    end

    local v456, v457 = makeTextButton5("NearbyPlayer", 12, Color3.fromRGB(255, 110, 110))
    local v458, v459 = makeTextButton5("LowHealth", 66, Color3.fromRGB(255, 190, 65))
    local v460 = 0

    function _G.LynoxSafetyV4.test()
      v460 = os.clock() + 6
      v457.Text = "TEST OK : detection joueurs active"
      v459.Text = "TEST OK : surveillance PV active"
      v456.Visible = true
      v458.Visible = true
    end

    _G.LynoxSafetyTest = _G.LynoxSafetyV4.test

    local v461 = 0

    local connect39 = runService.Heartbeat:Connect(function(delta13)
      local v462, v463 = pcall(function()
        v461 = v461 + delta13

        if v461 < 0.15 then
          return
        end

        v461 = 0

        if os.clock() < v460 then
          return
        else
          local character92 = localPlayer4.Character

          local humanoid57 = character92
          humanoid57 = character92 and character92:FindFirstChildOfClass("Humanoid")

          local humanoidRootPart71 = character92

          humanoidRootPart71 = character92
            and (character92:FindFirstChild("HumanoidRootPart") or character92.PrimaryPart)

          local v464 = _G.LynoxSafetyV4.health == true
          local v465 = _G.LynoxSafetyV4.enemy == true
          v458.Visible = false

          if v464 and humanoid57 then
            local v466 = math.max(0, humanoid57.Health)
            local v467 = math.max(1, humanoid57.MaxHealth)

            if v466 / v467 <= 0.3 then
              v458.Visible = true

              v459.Text = ("PV FAIBLES : %d / %d (%.0f%%)"):format(
                math.ceil(v466), math.ceil(v467), v466 / v467 * 100
              )
            end
          end

          v456.Visible = false

          if v465 and humanoidRootPart71 then
            local v468 = 30.00001
            local v469 = nil

            for index74, value71 in ipairs(players:GetPlayers()) do
              if value71 ~= localPlayer4 then
                local character93 = value71.Character

                local humanoidRootPart72 = character93

                humanoidRootPart72 = character93
                  and (character93:FindFirstChild("HumanoidRootPart") or character93.PrimaryPart)

                local humanoid58 = character93
                humanoid58 = character93 and character93:FindFirstChildOfClass("Humanoid")

                if humanoidRootPart72 and humanoid58 and humanoid58.Health > 0 then
                  local magnitude6 = (humanoidRootPart72.Position
                    - humanoidRootPart71.Position).Magnitude

                  if magnitude6 < v468 then
                    v468 = magnitude6
                    v469 = value71
                  end
                end
              end
            end

            if v469 then
              v456.Visible = true
              v457.Text = ("JOUEUR PROCHE : %s | %.0f studs"):format(v469.Name, v468)
            end
          end

          return
        end
      end)

      if not v462 then
        warn("[LynoxSafetyV4] " .. tostring(v463))

        if os.clock() >= v460 then
          v456.Visible = true
          v457.Text = "ERREUR SAFETY : voir F9"
        end
      end
    end)

    lynoxSafetyV42.Destroying:Connect(function() connect39:Disconnect() end)
    print("[LynoxSafetyV4] Demarre : activer les options dans SAFETY+")
  end, debug.traceback)

  if not v452 then
    warn("[LynoxSafetyV4] Initialisation impossible: " .. tostring(v453))
  end
end)

task.spawn(function()
  task.defer(function()
    local playerGui7 = localPlayer:WaitForChild("PlayerGui")
    local lynoxCommandConsole = playerGui7:FindFirstChild("LynoxCommandConsole")

    if lynoxCommandConsole then
      lynoxCommandConsole:Destroy()
    end

    local lynoxCommandConsole2 = Instance.new("ScreenGui")
    lynoxCommandConsole2.Name = "LynoxCommandConsole"
    lynoxCommandConsole2.ResetOnSpawn = false
    lynoxCommandConsole2.DisplayOrder = 10020
    lynoxCommandConsole2.Parent = playerGui7

    local commandInput = Instance.new("TextBox")
    commandInput.Name = "CommandInput"
    commandInput.AnchorPoint = Vector2.new(0.5, 0)
    commandInput.Position = UDim2.new(0.5, 0, 0, 48)
    commandInput.Size = UDim2.fromOffset(360, 36)
    commandInput.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
    commandInput.BorderSizePixel = 0
    commandInput.TextColor3 = Color3.fromRGB(240, 240, 245)
    commandInput.PlaceholderColor3 = Color3.fromRGB(155, 155, 165)
    commandInput.PlaceholderText = "F6 : commande (ex : ,flylyn)"
    commandInput.Text = ""
    commandInput.Font = Enum.Font.Gotham
    commandInput.TextSize = 13
    commandInput.ClearTextOnFocus = false
    commandInput.Visible = false
    commandInput.Parent = lynoxCommandConsole2

    Instance.new("UICorner", commandInput).CornerRadius = UDim.new(0, 8)

    local instance2 = Instance.new("UIStroke", commandInput)
    instance2.Color = Color3.fromRGB(75, 75, 85)
    instance2.Thickness = 1

    local connect40 = userInputService.InputBegan:Connect(function(input10, p173)
      if input10.KeyCode == Enum.KeyCode.F6 and not userInputService:GetFocusedTextBox() then
        commandInput.Visible = not commandInput.Visible

        if commandInput.Visible then
          commandInput:CaptureFocus()
        end
      elseif input10.KeyCode == Enum.KeyCode.Escape and commandInput.Visible then
        commandInput.Visible = false
        commandInput:ReleaseFocus()
      end
    end)

    commandInput.FocusLost:Connect(function(p174)
      if p174 then
        local text23 = commandInput.Text

        commandInput.Text = ""
        commandInput.Visible = false

        local v470, v471 = pcall(onLynChatCommand, text23)

        if not v470 then
          warn("[Lynox Command] " .. tostring(v471))
        end
      end
    end)

    lynoxCommandConsole2.Destroying:Connect(function() connect40:Disconnect() end)
  end)

  task.defer(function()
    local localPlayer5 = players.LocalPlayer
    local playerGui8 = localPlayer5:WaitForChild("PlayerGui")
    local lynoxKillFeed = playerGui8:FindFirstChild("LynoxKillFeed")

    if lynoxKillFeed then
      lynoxKillFeed:Destroy()
    end

    local lynoxKillFeed2 = Instance.new("ScreenGui")
    lynoxKillFeed2.Name = "LynoxKillFeed"
    lynoxKillFeed2.ResetOnSpawn = false
    lynoxKillFeed2.DisplayOrder = 10050
    lynoxKillFeed2.Parent = playerGui8

    local killFeedContainer = Instance.new("Frame")
    killFeedContainer.Name = "KillFeedContainer"
    killFeedContainer.AnchorPoint = Vector2.new(1, 0)
    killFeedContainer.Position = UDim2.new(1, -165, 0, 48)
    killFeedContainer.Size = UDim2.fromOffset(290, 210)
    killFeedContainer.BackgroundTransparency = 1
    killFeedContainer.Parent = lynoxKillFeed2

    local uiListLayout8 = Instance.new("UIListLayout")
    uiListLayout8.Padding = UDim.new(0, 5)
    uiListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout8.Parent = killFeedContainer

    local count6 = 0

    local function makeTextLabel2(text24, color19)
      local textLabel21

      if not lynoxKillFeed2.Parent then
        return
      else
        count6 = count6 + 1
        local v472 = count6

        textLabel21 = Instance.new("TextLabel")
        textLabel21.Name = "Kill_" .. v472
        textLabel21.Size = UDim2.new(1, 0, 0, 31)
        textLabel21.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
        textLabel21.BorderSizePixel = 0
        textLabel21.TextColor3 = color19
        textLabel21.Font = Enum.Font.GothamBold
        textLabel21.TextSize = 12
        textLabel21.TextXAlignment = Enum.TextXAlignment.Center
        textLabel21.TextTruncate = Enum.TextTruncate.AtEnd
        textLabel21.Text = text24
        textLabel21.LayoutOrder = -v472
        textLabel21.Parent = killFeedContainer

        Instance.new("UICorner", textLabel21).CornerRadius = UDim.new(0, 7)

        local instance3 = Instance.new("UIStroke", textLabel21)
        instance3.Color = Color3.fromRGB(72, 72, 79)
        instance3.Thickness = 1

        task.delay(6, function()
          if textLabel21.Parent then
            textLabel21:Destroy()
          end
        end)

        return
      end
    end

    local v473 = {}

    local function f35(waitForChild4)
      for index75, value72 in ipairs({
        "creator", "Creator", "killer", "Killer", "lastAttacker", "LastAttacker",
      }) do
        local findFirstChild4 = waitForChild4:FindFirstChild(value72)

        if findFirstChild4 and findFirstChild4:IsA("ObjectValue") and findFirstChild4.Value then
          local value73 = findFirstChild4.Value

          if value73:IsA("Player") then
            return value73
          elseif value73:IsA("Model") then
            local getPlayerFromCharacter2 = players:GetPlayerFromCharacter(value73)

            if getPlayerFromCharacter2 then
              return getPlayerFromCharacter2
            end
          end
        end
      end

      return nil
    end

    local function f36(p175, p176)
      local waitForChild5 = p176:WaitForChild("Humanoid", 10)
      local v474

      if not waitForChild5 then
        return
      else
        v474 = false

        local connect41 = waitForChild5.Died:Connect(function()
          if v474 then
            return
          else
            v474 = true
            local v475 = f35(waitForChild5)

            if v475 and v475 ~= p175 then
              if v475 == localPlayer5 then
                makeTextLabel2(
                  "ELIMINATION  |  Tu as tue " .. p175.DisplayName,
                  Color3.fromRGB(115, 240, 155)
                )
              elseif p175 == localPlayer5 then
                makeTextLabel2(
                  "TU ES MORT  |  Tue par " .. v475.DisplayName, Color3.fromRGB(255, 105, 105)
                )
              else
                makeTextLabel2(
                  v475.DisplayName .. "  >  " .. p175.DisplayName, Color3.fromRGB(220, 220, 225)
                )
              end
            elseif p175 == localPlayer5 then
              makeTextLabel2("TU ES MORT  |  Tueur inconnu", Color3.fromRGB(255, 105, 105))
            else
              makeTextLabel2(
                p175.DisplayName .. " est mort (tueur inconnu)", Color3.fromRGB(180, 180, 185)
              )
            end

            return
          end
        end)

        table.insert(v473, connect41)
        return
      end
    end

    local function f37(value74)
      local characterAdded2 = value74.CharacterAdded

      table.insert(
        v473, characterAdded2:Connect(function(p177) task.spawn(f36, value74, p177) end)
      )

      if value74.Character then
        task.spawn(f36, value74, value74.Character)
      end
    end

    for index76, value75 in ipairs(players:GetPlayers()) do
      f37(value75)
    end

    local playerAdded3 = players.PlayerAdded
    table.insert(v473, playerAdded3:Connect(f37))

    lynoxKillFeed2.Destroying:Connect(function()
      for index77, value76 in ipairs(v473) do
      end
    end)
  end)

  function buildTPMapsUI()
    local v476 = newCard(newTab(3.5, "TP MAPS", ""), 1, "MAP TELEPORTS")

    for index78, value77 in ipairs({
      { "CAFETERIA", 956, 99, 2330 }, { "GARDEN", 743, 97, 2543 },
      { "CRIMINALS BASE", -977, 93, 2162 }, { "GUARD ROOM", 854, 99, 2274 },
      { "CELLS", 916, 99, 2493 },
    }) do
      local v477 = value77

      newAction(v476, index78, v477[1], function()
        local character94 = localPlayer.Character

        local humanoidRootPart73 = character94
          and character94:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart73 then
          return
        end

        humanoidRootPart73.CFrame = CFrame.new(v477[2], v477[3], v477[4])
        humanoidRootPart73.AssemblyLinearVelocity = Vector3.zero
        humanoidRootPart73.AssemblyAngularVelocity = Vector3.zero
      end)
    end
  end

  function buildAll()
    createBaseGUI()
    local v478 = newTab(0, "Recherche", "")
    local parent16 = newCard(v478, 1, "RECHERCHER UNE OPTION")

    local globalOptionSearch = Instance.new("TextBox")
    globalOptionSearch.Name = "GlobalOptionSearch"
    globalOptionSearch.Size = UDim2.new(1, -4, 0, 38)
    globalOptionSearch.Position = UDim2.new(0, 2, 0, 0)
    globalOptionSearch.BackgroundColor3 = color2
    globalOptionSearch.BorderSizePixel = 0
    globalOptionSearch.ClearTextOnFocus = false
    globalOptionSearch.PlaceholderText = "Ex. : noclip, fly, vitesse..."
    globalOptionSearch.Text = ""
    globalOptionSearch.TextColor3 = color7
    globalOptionSearch.PlaceholderColor3 = color8
    globalOptionSearch.Font = Enum.Font.Gotham
    globalOptionSearch.TextSize = 13
    globalOptionSearch.TextXAlignment = Enum.TextXAlignment.Left
    globalOptionSearch.Parent = parent16

    corner(globalOptionSearch, 9)
    stroke(globalOptionSearch, color5, 1, 0.25)
    padding(globalOptionSearch, 10)

    local searchHint = Instance.new("TextLabel")
    searchHint.Name = "SearchHint"
    searchHint.Size = UDim2.new(1, -4, 0, 28)
    searchHint.BackgroundTransparency = 1
    searchHint.Text = "Tape un nom pour trouver une option dans toutes les catégories."
    searchHint.TextColor3 = color8
    searchHint.Font = Enum.Font.Gotham
    searchHint.TextSize = 11
    searchHint.TextWrapped = true
    searchHint.TextXAlignment = Enum.TextXAlignment.Left
    searchHint.LayoutOrder = 2
    searchHint.Parent = parent16

    local parent17 = newCard(v478, 2, "RÉSULTATS")

    local searchResults = Instance.new("Frame")
    searchResults.Name = "SearchResults"
    searchResults.Size = UDim2.new(1, 0, 0, 0)
    searchResults.AutomaticSize = Enum.AutomaticSize.Y
    searchResults.BackgroundTransparency = 1
    searchResults.LayoutOrder = 1
    searchResults.Parent = parent17

    local uiListLayout9 = Instance.new("UIListLayout")
    uiListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout9.Padding = UDim.new(0, 6)
    uiListLayout9.Parent = searchResults

    function clearSearchResults()
      for index79, value78 in ipairs(searchResults:GetChildren()) do
        if value78:IsA("GuiObject") and value78 ~= uiListLayout9 then
          value78:Destroy()
        end
      end
    end

    function refreshGlobalSearch()
      clearSearchResults()
      local v479 = string.lower(string.gsub(globalOptionSearch.Text or "", "^%s*(.-)%s*$", "%1"))

      if v479 == "" then
        searchHint.Text = "Tape un nom pour trouver une option dans toutes les catégories."
        return
      else
        local count7 = 0
        local v480 = {}

        for key34, value79 in pairs(v218) do
          local v481 = key34
          local v482 = value79

          if v481 ~= "Recherche" and v482 and v482.Parent then
            for index80, value80 in ipairs(v482:GetDescendants()) do
              if value80:IsA("TextLabel") or value80:IsA("TextButton") then
                local text25 = value80.Text or ""
                local v483 = string.gsub(text25, "<[^>]->", "")
                local v484 = string.lower(v483)

                if v484 ~= "" and string.find(v484, v479, 1, true) then
                  local parent18 = value80

                  while parent18.Parent and parent18.Parent ~= v482 do
                    parent18 = parent18.Parent
                  end

                  if parent18.Parent == v482 and not v480[parent18]
                    and parent18:IsA("GuiObject") then
                    v480[parent18] = true
                    count7 = count7 + 1

                    local textButton24 = Instance.new("TextButton")
                    textButton24.Name = "SearchResult_" .. tostring(count7)
                    textButton24.Size = UDim2.new(1, -2, 0, 34)
                    textButton24.BackgroundColor3 = Color3.fromRGB(73, 45, 120)
                    textButton24.BorderSizePixel = 0
                    textButton24.AutoButtonColor = false
                    textButton24.Text = "  " .. v481 .. "   ›   " .. string.sub(v483, 1, 54)
                    textButton24.TextColor3 = color7
                    textButton24.TextSize = 11
                    textButton24.Font = Enum.Font.GothamMedium
                    textButton24.TextWrapped = false
                    textButton24.TextXAlignment = Enum.TextXAlignment.Left
                    textButton24.TextTruncate = Enum.TextTruncate.AtEnd
                    textButton24.LayoutOrder = count7
                    textButton24.Parent = searchResults

                    corner(textButton24, 8)
                    stroke(textButton24, color5, 1.2, 0.05)

                    textButton24.MouseEnter:Connect(function()
                      tweenService:Create(textButton24, TweenInfo.new(0.12), {
                        BackgroundColor3 = Color3.fromRGB(96, 61, 153),
                      }):Play()
                    end)

                    textButton24.MouseLeave:Connect(function()
                      tweenService:Create(textButton24, TweenInfo.new(0.12), {
                        BackgroundColor3 = Color3.fromRGB(73, 45, 120),
                      }):Play()
                    end)

                    local v485 = parent18

                    textButton24.MouseButton1Click:Connect(function()
                      selectTab(v481)

                      task.defer(function()
                        local v486 = v485 and v485.Parent == v482
                        local backgroundColor33

                        if v486 then
                          local v487 = math.max(0, v485.AbsolutePosition.Y - v482.AbsolutePosition.Y
                              + v482.CanvasPosition.Y
                            - 10)

                          v482.CanvasPosition = Vector2.new(0, v487)
                          backgroundColor33 = v485.BackgroundColor3

                          if v485:IsA("Frame") then
                            v485.BackgroundColor3 = color5

                            task.delay(0.45, function()
                              if v485 and v485.Parent then
                                v485.BackgroundColor3 = backgroundColor33
                              end
                            end)
                          end
                        end
                      end)
                    end)

                    if count7 >= 40 then
                      break
                    end
                  end
                end
              end

              if count7 >= 40 then
                break
              end
            end
          end

          if count7 >= 40 then
            break
          end
        end

        searchHint.Text = count7 > 0
            and tostring(count7)
              .. " résultat(s) trouvé(s) — clique pour ouvrir la catégorie."
          or "Aucun résultat. Essaie un autre mot-clé."

        return
      end
    end

    globalOptionSearch:GetPropertyChangedSignal("Text"):Connect(refreshGlobalSearch)
    selectTab("Recherche")
    buildPlayerUI()
    buildKillPlayerUI()
    buildGunUI()
    buildMapLimitUI()
    buildTPMapsUI()
    buildMovementUI()
    buildPersonnageUI()
    buildTeleportUI()
    buildVisualUI()
    buildUtilitiesUI()
    buildTrollUI()
    buildKickCarsUI()
    buildBackstabUI()
    buildEmotesUI()
    buildTutorialUI()
    buildCommandsUI()
    buildLynoxExtras()
  end

  function reloadGUI()
    f26()
    local v488 = mainFrame
    local v489 = v221
    local position25 = v488 and mainFrame.Position
    local visible3 = mainFrame and mainFrame.Visible
    buildAll()

    if v489 and v218[v489] then
      selectTab(v489)
    end

    if position25 then
      mainFrame.Position = position25
    end

    if visible3 ~= nil then
      mainFrame.Visible = visible3
    end

    print("[TheLynoxBot] GUI rechargé")
  end

  buildAll()

  task.spawn(function()
    while true do
      task.wait(2)
      local playerGui9 = localPlayer:FindFirstChild("PlayerGui")

      if playerGui9 and not playerGui9:FindFirstChild("TheLynoxBotAdminGui") then
        reloadGUI()
      end
    end
  end)

  print("[TheLynoxBot] GUI chargé avec succès")
end)

function _G.LynoxLoadExternalAimbot()
  local v490, v491 = pcall(function()
    local httpsObjWearedevsNetS6a71e593ff2048b74c853df4Lua = game:HttpGet("https://obj.wearedevs.net/s/6a71e593ff2048b74c853df4.lua")
    local v492 = loadstring
    assert(type(v492) == "function", "loadstring indisponible")
    local v493, v494 = v492(httpsObjWearedevsNetS6a71e593ff2048b74c853df4Lua)
    assert(v493, v494)
    v493()
  end)

  if not v490 then
    warn("[Lynox] Aimbot externe non charge :", v491)
  end

  return v490
end

task.spawn(function()
  local v495, v496 = pcall(function()
    local v497, v498 = loadstring((game:HttpGet("https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua")))
    assert(v497, v498)
    v497()
  end)

  if not v495 then
    warn("[Lynox] Infinite Yield non charge :", v496)
  end
end)
