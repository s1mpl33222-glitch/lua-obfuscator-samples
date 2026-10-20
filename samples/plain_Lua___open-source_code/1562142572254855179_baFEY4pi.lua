-- KK888 HUB ส่วนที่ 1/3 : หลัก + แท็บตัวละคร 🏃
-- วิธีใช้: ก๊อปทั้งหมดในไฟล์นี้ ไปวางใน Delta แล้วกด Execute

local function showError(msg)
   local gui = Instance.new("ScreenGui")
   gui.Name = "KK888Error"
   gui.ResetOnSpawn = false
   local frame = Instance.new("Frame")
   frame.Size = UDim2.new(0.9, 0, 0.45, 0)
   frame.Position = UDim2.new(0.05, 0, 0.28, 0)
   frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
   frame.BorderSizePixel = 0
   frame.Parent = gui
   local label = Instance.new("TextLabel")
   label.Size = UDim2.new(1, -20, 1, -20)
   label.Position = UDim2.new(0, 10, 0, 10)
   label.BackgroundTransparency = 1
   label.TextColor3 = Color3.new(1, 1, 1)
   label.TextWrapped = true
   label.TextXAlignment = Enum.TextXAlignment.Left
   label.TextYAlignment = Enum.TextYAlignment.Top
   label.TextSize = 14
   label.Font = Enum.Font.Code
   label.Text = "KK888 PART1 ERROR:\n\n" .. tostring(msg)
   label.Parent = frame
   gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local ok, err = pcall(function()

------------------------------------------------
-- 1. โหลด Rayfield + สร้างหน้าต่าง
------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "KK888 HUB",
   Icon = 90480364141781,
   LoadingTitle = "KK888 HUB",
   LoadingSubtitle = "By ธันวา Shop",
   ShowText = "KK888 HUB",
   Theme = {
      TextColor = Color3.fromRGB(245, 228, 235),
      Background = Color3.fromRGB(16, 10, 16),
      Topbar = Color3.fromRGB(26, 16, 22),
      Shadow = Color3.fromRGB(10, 6, 10),
      NotificationBackground = Color3.fromRGB(22, 14, 18),
      NotificationActionsBackground = Color3.fromRGB(190, 70, 100),
      TabBackground = Color3.fromRGB(40, 24, 32),
      TabStroke = Color3.fromRGB(70, 40, 52),
      TabBackgroundSelected = Color3.fromRGB(190, 70, 100),
      TabTextColor = Color3.fromRGB(220, 190, 200),
      SelectedTabTextColor = Color3.fromRGB(255, 240, 245),
      ElementBackground = Color3.fromRGB(28, 18, 24),
      ElementBackgroundHover = Color3.fromRGB(36, 22, 30),
      SecondaryElementBackground = Color3.fromRGB(22, 14, 20),
      ElementStroke = Color3.fromRGB(60, 34, 44),
      SecondaryElementStroke = Color3.fromRGB(50, 28, 38),
      SliderBackground = Color3.fromRGB(60, 34, 44),
      SliderProgress = Color3.fromRGB(190, 70, 100),
      SliderStroke = Color3.fromRGB(220, 100, 130),
      ToggleBackground = Color3.fromRGB(30, 20, 26),
      ToggleEnabled = Color3.fromRGB(190, 70, 100),
      ToggleDisabled = Color3.fromRGB(80, 60, 68),
      ToggleEnabledStroke = Color3.fromRGB(220, 100, 130),
      ToggleDisabledStroke = Color3.fromRGB(100, 80, 88),
      ToggleEnabledOuterStroke = Color3.fromRGB(120, 70, 85),
      ToggleDisabledOuterStroke = Color3.fromRGB(60, 45, 52),
      DropdownSelected = Color3.fromRGB(36, 22, 30),
      DropdownUnselected = Color3.fromRGB(28, 18, 24),
      InputBackground = Color3.fromRGB(28, 18, 24),
      InputStroke = Color3.fromRGB(70, 40, 52),
      PlaceholderColor = Color3.fromRGB(150, 120, 130),
   },
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KK888HUB",
      FileName = "KK888HUBConfig"
   },
   KeySystem = false,
})

------------------------------------------------
-- 2. ตัวแปรกลาง (Part2/3 ใช้ร่วมกัน)
------------------------------------------------
_G.KK888Window = Window
_G.KK888Rayfield = Rayfield
_G.KK888W = Window
_G.KK888R = Rayfield
_G.KK888S = _G.KK888S or { Panic = false, Stealth = false, NoChat = false, Jitter = 0, MissChance = 0 }

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local S = _G.KK888S

do
   local TCS = game:GetService("TextChatService")
   local F = _G.KK888F or {}
   _G.KK888F = F
   F.hrp = function()
      local c = LocalPlayer.Character
      return c and c:FindFirstChild("HumanoidRootPart")
   end
   F.hum = function()
      local c = LocalPlayer.Character
      return c and c:FindFirstChildOfClass("Humanoid")
   end
   F.getChatChannel = function()
      local tc = TCS:FindFirstChild("TextChannels")
      return tc and tc:FindFirstChild("RBXGeneral")
   end
   F.chat = function(msg)
      if S.NoChat then return end
      pcall(function()
         local ch = F.getChatChannel()
         if ch then ch:SendAsync(msg) end
      end)
   end
end

------------------------------------------------
-- 3. พื้นหลังรูปสุคุนะในหน้าต่าง UI 😈
------------------------------------------------
if _G.KK888S.UiBg == nil then _G.KK888S.UiBg = true end

task.spawn(function()
   task.wait(2)
   pcall(function()
      local gui = LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
      if not gui and gethui then
         gui = gethui():FindFirstChild("Rayfield")
      end
      if not gui then
         gui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
      end
      if gui then
         local main = gui:FindFirstChild("Main", true)
         if main and main:IsA("GuiObject") then
            local old = main:FindFirstChild("KK888UIBG")
            if old then old:Destroy() end
            local img = Instance.new("ImageLabel")
            img.Name = "KK888UIBG"
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Position = UDim2.new(0, 0, 0, 0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://90480364141781"
            img.ImageTransparency = 0.7
            img.ScaleType = Enum.ScaleType.Crop
            img.ZIndex = 1
            img.Visible = _G.KK888S.UiBg ~= false
            local corner = main:FindFirstChildOfClass("UICorner")
            if corner then
               local c = corner:Clone()
               c.Parent = img
            end
            img.Parent = main
            _G.KK888UIBG = img
         end
      end
   end)
end)

------------------------------------------------
-- 4. ปุ่มลอยเปิด/ปิด HUB สไตล์ Ruok HUB 📌
-- (ปุ่มนี้อยู่บนจอตลอด กด X/ซ่อน UI ยังไงก็แตะเปิดกลับมาได้)
------------------------------------------------
task.spawn(function()
   task.wait(2)
   pcall(function()
      local gui = LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
      if not gui and gethui then gui = gethui():FindFirstChild("Rayfield") end
      if not gui then gui = game:GetService("CoreGui"):FindFirstChild("Rayfield") end
      if not gui then return end

      -- ซ่อน prompt เดิมของ Rayfield ถาวร (ใช้ปุ่มลอยของเราแทน)
      local prompt = gui:FindFirstChild("Prompt")
      if prompt then
         prompt.Visible = false
         prompt:GetPropertyChangedSignal("Visible"):Connect(function()
            if prompt.Visible then prompt.Visible = false end
         end)
      end

      -- ลบปุ่มเก่าถ้ารันสคริปต์ซ้ำ
      local oldFloat = LocalPlayer.PlayerGui:FindFirstChild("KK888Float")
      if oldFloat then oldFloat:Destroy() end

      local floatGui = Instance.new("ScreenGui")
      floatGui.Name = "KK888Float"
      floatGui.ResetOnSpawn = false
      floatGui.IgnoreGuiInset = true
      floatGui.DisplayOrder = 1000
      floatGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

      local pill = Instance.new("TextButton")
      pill.Name = "KK888Pill"
      pill.Size = UDim2.new(0, 190, 0, 46)
      pill.Position = _G.KK888PillPos or UDim2.new(0.5, -95, 0, 60)
      pill.BackgroundColor3 = Color3.fromRGB(12, 8, 14)
      pill.BackgroundTransparency = 0.12
      pill.Text = ""
      pill.AutoButtonColor = false
      pill.Parent = floatGui

      local corner = Instance.new("UICorner")
      corner.CornerRadius = UDim.new(1, 0)
      corner.Parent = pill

      -- ขอบเรืองแสงชมพูแบบ Ruok HUB
      local stroke = Instance.new("UIStroke")
      stroke.Color = Color3.fromRGB(255, 90, 170)
      stroke.Thickness = 2.5
      stroke.Transparency = 0.15
      stroke.Parent = pill

      -- ไอคอนสุคุนะวงกลมด้านซ้าย
      local icon = Instance.new("ImageLabel")
      icon.Size = UDim2.new(0, 34, 0, 34)
      icon.Position = UDim2.new(0, 7, 0.5, -17)
      icon.BackgroundColor3 = Color3.fromRGB(26, 16, 22)
      icon.BackgroundTransparency = 0.2
      icon.Image = "rbxassetid://90480364141781"
      icon.ScaleType = Enum.ScaleType.Crop
      icon.Parent = pill
      local icorner = Instance.new("UICorner")
      icorner.CornerRadius = UDim.new(1, 0)
      icorner.Parent = icon
      local istroke = Instance.new("UIStroke")
      istroke.Color = Color3.fromRGB(255, 90, 170)
      istroke.Thickness = 1.5
      istroke.Transparency = 0.3
      istroke.Parent = icon

      -- ข้อความ KK888 HUB😈
      local label = Instance.new("TextLabel")
      label.Size = UDim2.new(1, -52, 1, 0)
      label.Position = UDim2.new(0, 48, 0, 0)
      label.BackgroundTransparency = 1
      label.Text = "KK888 HUB😈"
      label.TextColor3 = Color3.fromRGB(255, 235, 242)
      label.TextSize = 17
      label.Font = Enum.Font.GothamBold
      label.TextXAlignment = Enum.TextXAlignment.Left
      label.Parent = pill

      -- เอฟเฟกต์ขอบเรืองแสงกระพริบเบาๆ
      task.spawn(function()
         local ts = game:GetService("TweenService")
         while pill.Parent do
            pcall(function()
               ts:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                  { Transparency = 0.45 }):Play()
            end)
            task.wait(1.3)
            if not pill.Parent then break end
            pcall(function()
               ts:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                  { Transparency = 0.1 }):Play()
            end)
            task.wait(1.3)
         end
      end)

      -- แตะเบาๆ = เปิด/ปิด UI, ลาก = ย้ายตำแหน่ง
      local UIS2 = game:GetService("UserInputService")
      local dragging, dragStart, startPos, movedFar = false, nil, nil, false
      pill.InputBegan:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            movedFar = false
            dragStart = input.Position
            startPos = pill.Position
         end
      end)
      UIS2.InputChanged:Connect(function(input)
         if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 8 then movedFar = true end
            if movedFar then
               pill.Position = UDim2.new(
                  startPos.X.Scale, startPos.X.Offset + delta.X,
                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
         end
      end)
      UIS2.InputEnded:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
               dragging = false
               if movedFar then
                  _G.KK888PillPos = pill.Position
               else
                  pcall(function()
                     Rayfield:SetVisibility(not Rayfield:IsVisible())
                  end)
               end
            end
         end
      end)

      _G.KK888Pill = pill
   end)
end)
------------------------------------------------
-- 5. แท็บตัวละคร 🏃
------------------------------------------------
local WalkEnabled, JumpEnabled = false, false
local WalkSpeedValue, JumpPowerValue = 16, 50
local Flying, FlySpeed = false, 50
local SpinEnabled, SpinSpeed = false, 30

-- Stealth Mode: ล็อกค่าไม่ให้เว่อร์เกินลิมิต
local function safe(v, limit)
   if S.Stealth then return math.min(v, limit) end
   return v
end

local function getCharacter()
   local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
   return char, char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
end

local function applySpeed()
   local _, humanoid = getCharacter()
   humanoid.WalkSpeed = WalkEnabled and safe(WalkSpeedValue, 250) or 16
end

local function applyJump()
   local _, humanoid = getCharacter()
   humanoid.JumpPower = JumpEnabled and safe(JumpPowerValue, 500) or 50
   humanoid.UseJumpPower = true
end

local function createFlyBodies(hrp)
   for _, c in ipairs(hrp:GetChildren()) do
      if c.Name == "KK888FlyV" or c.Name == "KK888FlyG" then c:Destroy() end
   end
   local bg = Instance.new("BodyGyro")
   bg.Name = "KK888FlyG"
   bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
   bg.P = 9e4
   bg.CFrame = hrp.CFrame
   bg.Parent = hrp
   local bv = Instance.new("BodyVelocity")
   bv.Name = "KK888FlyV"
   bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
   bv.Velocity = Vector3.zero
   bv.Parent = hrp
end

UserInputService.JumpRequest:Connect(function()
   if JumpEnabled then
      local _, humanoid = getCharacter()
      humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

-- ปุ่มบินบนมือถือ (▲▼)
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "KK888FlyUI"
flyGui.ResetOnSpawn = false
flyGui.Enabled = false
flyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function makeFlyBtn(text, xPos)
   local b = Instance.new("TextButton")
   b.Size = UDim2.new(0, 70, 0, 70)
   b.Position = UDim2.new(1, xPos, 1, -180)
   b.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
   b.BackgroundTransparency = 0.3
   b.TextColor3 = Color3.new(1, 1, 1)
   b.TextSize = 30
   b.Text = text
   b.Parent = flyGui
   local held = false
   b.MouseButton1Down:Connect(function() held = true end)
   b.MouseButton1Up:Connect(function() held = false end)
   b.MouseLeave:Connect(function() held = false end)
   return function() return held end
end
local isUp = makeFlyBtn("▲", -180)
local isDown = makeFlyBtn("▼", -95)

local TabMain = Window:CreateTab("ตัวละคร 🏃", 4483362458)

TabMain:CreateSection("วิ่งไว (WalkSpeed)")
TabMain:CreateToggle({
   Name = "เปิด/ปิด วิ่งไว",
   CurrentValue = false,
   Callback = function(v)
      WalkEnabled = v
      applySpeed()
   end,
})
TabMain:CreateSlider({
   Name = "ความเร็ววิ่ง (1-10000)",
   Range = {1, 10000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v)
      WalkSpeedValue = v
      applySpeed()
   end,
})

TabMain:CreateSection("กระโดดสูง (High Jump) 🦘")
TabMain:CreateToggle({
   Name = "เปิด/ปิด กระโดดสูง",
   CurrentValue = false,
   Callback = function(v)
      JumpEnabled = v
      applyJump()
   end,
})
TabMain:CreateSlider({
   Name = "พลังกระโดด (1-10000)",
   Range = {1, 10000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v)
      JumpPowerValue = v
      applyJump()
   end,
})

TabMain:CreateSection("บิน (Fly) 🕊️")
TabMain:CreateToggle({
   Name = "เปิด/ปิด บิน",
   CurrentValue = false,
   Callback = function(v)
      Flying = v
      flyGui.Enabled = v
      local char = LocalPlayer.Character
      if char then
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if hrp then
            for _, c in ipairs(hrp:GetChildren()) do
               if c.Name == "KK888FlyV" or c.Name == "KK888FlyG" then c:Destroy() end
            end
            if v then createFlyBodies(hrp) end
         end
      end
   end,
})
TabMain:CreateSlider({
   Name = "ความเร็วบิน (1-500)",
   Range = {1, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v)
      FlySpeed = v
   end,
})

TabMain:CreateSection("หมุนตัว (Spin) 🌀")
TabMain:CreateToggle({
   Name = "เปิด/ปิด หมุนตัว",
   CurrentValue = false,
   Callback = function(v)
      SpinEnabled = v
   end,
})
TabMain:CreateSlider({
   Name = "ความเร็วหมุน (1-100)",
   Range = {1, 100},
   Increment = 1,
   CurrentValue = 30,
   Callback = function(v)
      SpinSpeed = v
   end,
})

TabMain:CreateSection("พื้นหลัง 😈")
TabMain:CreateToggle({
   Name = "พื้นหลังรูปสุคุนะ",
   CurrentValue = true,
   Callback = function(v)
      S.UiBg = v
      if _G.KK888UIBG then _G.KK888UIBG.Visible = v end
   end,
})

task.spawn(function()
   while true do
      RunService.RenderStepped:Wait()
      if SpinEnabled and not S.Panic then
         local sch = LocalPlayer.Character
         local shrp = sch and sch:FindFirstChild("HumanoidRootPart")
         if shrp then
            shrp.CFrame = shrp.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
         end
      end
      if Flying then
         local char = LocalPlayer.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         local humanoid = char and char:FindFirstChildOfClass("Humanoid")
         if hrp and humanoid then
            local bv = hrp:FindFirstChild("KK888FlyV")
            local bg = hrp:FindFirstChild("KK888FlyG")
            if bv and bg then
               local spd = safe(FlySpeed, 150)
               local move = humanoid.MoveDirection
               local dir = Vector3.new(move.X, 0, move.Z)
               if dir.Magnitude > 0.01 then dir = dir.Unit else dir = Vector3.zero end
               local up = 0
               if UserInputService:IsKeyDown(Enum.KeyCode.Space) or isUp() then up = 1 end
               if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or isDown() then up = -1 end
               if dir.Magnitude == 0 and up == 0 then
                  bv.Velocity = Vector3.zero
               else
                  bv.Velocity = (dir * spd) + Vector3.new(0, up * spd, 0)
               end
               bg.CFrame = workspace.CurrentCamera.CFrame
            end
         end
      end
   end
end)

LocalPlayer.CharacterAdded:Connect(function()
   task.wait(1)
   applySpeed()
   applyJump()
   if Flying then
      local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
      createFlyBodies(hrp)
   end
end)

end)

if not ok then
   showError(err)
else
   print("✅ KK888 ส่วนที่ 1 รันสำเร็จ → รันส่วนที่ 2 ต่อ")
end
-- KK888 HUB ส่วนที่ 2/3 : เอฟเฟค ✨ + รันสคริปต์ 📜
-- วิธีใช้: รันส่วนที่ 1 ก่อน แล้วก๊อปทั้งหมดนี้วางใน Delta กด Execute (ห้องเดิม ไม่ต้องออกเกม)

local function showError(msg)
   local gui = Instance.new("ScreenGui")
   gui.Name = "KK888Err"
   gui.ResetOnSpawn = false
   local frame = Instance.new("Frame")
   frame.Size = UDim2.new(0.9, 0, 0.4, 0)
   frame.Position = UDim2.new(0.05, 0, 0.3, 0)
   frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
   frame.BorderSizePixel = 0
   frame.Parent = gui
   local label = Instance.new("TextLabel")
   label.Size = UDim2.new(1, -20, 1, -20)
   label.Position = UDim2.new(0, 10, 0, 10)
   label.BackgroundTransparency = 1
   label.TextColor3 = Color3.new(1, 1, 1)
   label.TextWrapped = true
   label.TextXAlignment = Enum.TextXAlignment.Left
   label.TextYAlignment = Enum.TextYAlignment.Top
   label.TextSize = 14
   label.Font = Enum.Font.Code
   label.Text = "KK888 ERROR:\n\n" .. tostring(msg)
   label.Parent = frame
   gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local ok, err = pcall(function()

------------------------------------------------
-- ดึงตัวแปรกลาง (ซ่อมตัวเองได้ถ้า Part1 เป็นเวอร์ชันเก่า)
------------------------------------------------
local Window = _G.KK888W or _G.KK888Window
if not Window then error("❌ รันส่วนที่ 1 ก่อน!") end
local Rayfield = _G.KK888R or _G.KK888Rayfield

_G.KK888S = _G.KK888S or { Panic = false, Stealth = false, NoChat = false, Jitter = 0, MissChance = 0 }
local S = _G.KK888S

if not _G.KK888F then
   local TCS = game:GetService("TextChatService")
   local Plr0 = game:GetService("Players").LocalPlayer
   local FF = {}
   FF.hrp = function()
      local c = Plr0.Character
      return c and c:FindFirstChild("HumanoidRootPart")
   end
   FF.hum = function()
      local c = Plr0.Character
      return c and c:FindFirstChildOfClass("Humanoid")
   end
   FF.getChatChannel = function()
      local tc = TCS:FindFirstChild("TextChannels")
      return tc and tc:FindFirstChild("RBXGeneral")
   end
   FF.chat = function(msg)
      if S.NoChat then return end
      pcall(function()
         local ch = FF.getChatChannel()
         if ch then ch:SendAsync(msg) end
      end)
   end
   _G.KK888F = FF
end
local F = _G.KK888F
local hrp, hum, chat, getChatChannel = F.hrp, F.hum, F.chat, F.getChatChannel
local P = game:GetService("Players")
local Rs = game:GetService("RunService")
local Me = P.LocalPlayer

------------------------------------------------
-- แท็บ 2: เอฟเฟค ✨
------------------------------------------------
local T2 = Window:CreateTab("เอฟเฟค ✨", 4483362458)

T2:CreateSection("พาร์ทม่วง 💜")
local OE, OS, OP = false, 5, {}

T2:CreateToggle({
   Name = "พาร์ทม่วงหมุนรอบตัว",
   CurrentValue = false,
   Callback = function(v) OE = v end,
})
T2:CreateSlider({
   Name = "ความเร็วหมุน",
   Range = {1, 20},
   Increment = 1,
   CurrentValue = 5,
   Callback = function(v) OS = v end,
})
T2:CreateInput({
   Name = "เสกพาร์ทเพิ่ม (จำนวน)",
   PlaceholderText = "เช่น 8",
   RemoveTextAfterFocusLost = false,
   Callback = function(t)
      local n = tonumber(t)
      if n and n > 0 then
         for i = 1, math.floor(n) do
            local p = Instance.new("Part")
            p.Name = "KO"
            p.Shape = Enum.PartType.Ball
            p.Size = Vector3.new(1, 1, 1)
            p.Material = Enum.Material.Neon
            p.Color = Color3.fromRGB(170, 0, 255)
            p.Anchored = true
            p.CanCollide = false
            p.CanQuery = false
            p.Parent = workspace
            local gl = Instance.new("PointLight")
            gl.Color = Color3.fromRGB(170, 0, 255)
            gl.Range = 12
            gl.Brightness = 2
            gl.Parent = p
            table.insert(OP, p)
         end
         Rayfield:Notify({ Title = "KK888 HUB", Content = "เสกพาร์ทเพิ่มแล้ว ✅", Duration = 3 })
      end
   end,
})
T2:CreateButton({
   Name = "ล้างพาร์ททั้งหมด",
   Callback = function()
      for _, p in pairs(OP) do p:Destroy() end
      OP = {}
   end,
})

task.spawn(function()
   local a = 0
   while true do
      Rs.RenderStepped:Wait()
      if OE and not S.Panic and #OP > 0 then
         local h = hrp()
         if h then
            a = a + OS * 0.02
            for i, p in ipairs(OP) do
               if p.Parent then
                  local o = (i - 1) / #OP * 6.2832
                  p.CFrame = CFrame.new(h.Position + Vector3.new(
                     math.cos(a + o) * 6,
                     2 + math.sin(tick() * 2 + o) * 1.5,
                     math.sin(a + o) * 6))
               end
            end
         end
      end
   end
end)

T2:CreateSection("ออร่า ✨")
T2:CreateToggle({
   Name = "ออร่าม่วงดำ",
   CurrentValue = false,
   Callback = function(v)
      local h = hrp()
      if h then
         for _, c in pairs(h:GetChildren()) do
            if c.Name == "KA" then c:Destroy() end
         end
         if v then
            local a = Instance.new("Attachment")
            a.Name = "KA"
            a.Parent = h
            for _, cl in pairs({ Color3.fromRGB(170, 0, 255), Color3.fromRGB(10, 10, 10) }) do
               local e = Instance.new("ParticleEmitter")
               e.Color = ColorSequence.new(cl)
               e.Size = NumberSequence.new(1)
               e.Transparency = NumberSequence.new(0.4)
               e.Lifetime = NumberRange.new(1, 2)
               e.Rate = 30
               e.Speed = NumberRange.new(2, 5)
               e.SpreadAngle = Vector2.new(360, 360)
               e.Parent = a
            end
         end
      end
   end,
})

------------------------------------------------
-- แท็บ 3: รันสคริปต์ 📜
------------------------------------------------
local T3 = Window:CreateTab("รันสคริปต์ 📜", 4483362458)
local scode, srun, SavedFolder = "", false, "KK888Scripts"

local function startLoop()
   if srun then return end
   srun = true
   task.spawn(function()
      while srun do
         if S.Panic then srun = false break end
         if scode ~= "" then
            pcall(function() loadstring(scode)() end)
            chat("K8 SCRIPT😈")
         end
         task.wait(2)
      end
   end)
end

T3:CreateInput({
   Name = "ช่องวางสคริปต์",
   PlaceholderText = 'เช่น print("Hello")',
   RemoveTextAfterFocusLost = false,
   Callback = function(t) scode = t end,
})
T3:CreateButton({
   Name = "▶ รัน",
   Callback = function()
      if scode ~= "" then
         local o, e = pcall(function() loadstring(scode)() end)
         chat("K8 SCRIPT😈")
         Rayfield:Notify({ Title = "KK888 HUB", Content = o and "รันสำเร็จ ✅" or "พัง: " .. tostring(e), Duration = 4 })
      else
         Rayfield:Notify({ Title = "KK888 HUB", Content = "ยังไม่ได้วางสคริปต์ ❌", Duration = 3 })
      end
   end,
})
T3:CreateToggle({
   Name = "🔁 รันรัวๆ (ทุก 2 วิ)",
   CurrentValue = false,
   Callback = function(v)
      if v then startLoop() else srun = false end
   end,
})
T3:CreateButton({
   Name = "💬 ทดสอบพิมพ์แชท",
   Callback = function()
      chat("K8 TEST ✅")
      Rayfield:Notify({ Title = "KK888 HUB", Content = "ส่งข้อความทดสอบแล้ว ดูในแชทเกม", Duration = 4 })
   end,
})

T3:CreateSection("บันทึกสคริปต์ 💾")
pcall(function()
   if not isfolder(SavedFolder) then makefolder(SavedFolder) end
end)

local saveName = ""
T3:CreateInput({
   Name = "ชื่อสคริปต์ที่จะบันทึก",
   PlaceholderText = "เช่น flyscript",
   RemoveTextAfterFocusLost = false,
   Callback = function(t) saveName = t end,
})
T3:CreateButton({
   Name = "💾 บันทึกสคริปต์",
   Callback = function()
      if saveName ~= "" and scode ~= "" then
         pcall(function() writefile(SavedFolder .. "/" .. saveName .. ".txt", scode) end)
         Rayfield:Notify({ Title = "KK888 HUB", Content = "บันทึกแล้ว ✅", Duration = 3 })
      else
         Rayfield:Notify({ Title = "KK888 HUB", Content = "ใส่ชื่อและวางสคริปต์ก่อน ❌", Duration = 3 })
      end
   end,
})

local function listSaved()
   local list = {}
   pcall(function()
      for _, f in ipairs(listfiles(SavedFolder)) do
         local n = f:match("([^/\\]+)%.txt$")
         if n then table.insert(list, n) end
      end
   end)
   if #list == 0 then list = { "(ยังไม่มีสคริปต์)" } end
   return list
end

local firstSaved = listSaved()
local savedDropdown = T3:CreateDropdown({
   Name = "สคริปต์ที่บันทึกไว้",
   Options = firstSaved,
   CurrentOption = { firstSaved[1] },
   MultipleOptions = false,
   Callback = function(opt)
      local n = opt[1]
      if n ~= "(ยังไม่มีสคริปต์)" then
         local o, c = pcall(function() return readfile(SavedFolder .. "/" .. n .. ".txt") end)
         if o and c then
            scode = c
            Rayfield:Notify({ Title = "KK888 HUB", Content = "โหลดลงช่องรันแล้ว ✅", Duration = 3 })
         end
      end
   end,
})
T3:CreateButton({
   Name = "🔄 รีเฟรชรายชื่อ",
   Callback = function() savedDropdown:Refresh(listSaved()) end,
})

end)

if not ok then
   showError(err)
else
   print("✅ KK888 ส่วนที่ 2 รันสำเร็จ → รันส่วนที่ 3 ต่อ")
end
-- KK888 HUB ส่วนที่ 3/3 : ป้องกัน 🛡️ + Brookhaven 🏠 + Fling 🥶
-- วิธีใช้: รันส่วนที่ 1, 2 ก่อน แล้วก๊อปทั้งหมดนี้วางใน Delta กด Execute (ห้องเดิม ไม่ต้องออกเกม)

local function showError(msg)
   local gui = Instance.new("ScreenGui")
   gui.Name = "KK888Err"
   gui.ResetOnSpawn = false
   local frame = Instance.new("Frame")
   frame.Size = UDim2.new(0.9, 0, 0.4, 0)
   frame.Position = UDim2.new(0.05, 0, 0.3, 0)
   frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
   frame.BorderSizePixel = 0
   frame.Parent = gui
   local label = Instance.new("TextLabel")
   label.Size = UDim2.new(1, -20, 1, -20)
   label.Position = UDim2.new(0, 10, 0, 10)
   label.BackgroundTransparency = 1
   label.TextColor3 = Color3.new(1, 1, 1)
   label.TextWrapped = true
   label.TextXAlignment = Enum.TextXAlignment.Left
   label.TextYAlignment = Enum.TextYAlignment.Top
   label.TextSize = 14
   label.Font = Enum.Font.Code
   label.Text = "KK888 ERROR:\n\n" .. tostring(msg)
   label.Parent = frame
   gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local ok, err = pcall(function()

------------------------------------------------
-- ดึงตัวแปรกลาง (ซ่อมตัวเองได้ถ้า Part1 เป็นเวอร์ชันเก่า)
------------------------------------------------
local Window = _G.KK888W or _G.KK888Window
if not Window then error("❌ รันส่วนที่ 1 ก่อน!") end
local Rayfield = _G.KK888R or _G.KK888Rayfield

_G.KK888S = _G.KK888S or { Panic = false, Stealth = false, NoChat = false, Jitter = 0, MissChance = 0 }
local S = _G.KK888S

if not _G.KK888F then
   local TCS = game:GetService("TextChatService")
   local Plr0 = game:GetService("Players").LocalPlayer
   local FF = {}
   FF.hrp = function()
      local c = Plr0.Character
      return c and c:FindFirstChild("HumanoidRootPart")
   end
   FF.hum = function()
      local c = Plr0.Character
      return c and c:FindFirstChildOfClass("Humanoid")
   end
   FF.getChatChannel = function()
      local tc = TCS:FindFirstChild("TextChannels")
      return tc and tc:FindFirstChild("RBXGeneral")
   end
   FF.chat = function(msg)
      if S.NoChat then return end
      pcall(function()
         local ch = FF.getChatChannel()
         if ch then ch:SendAsync(msg) end
      end)
   end
   _G.KK888F = FF
end
local F = _G.KK888F
local hrp, hum, chat, getChatChannel = F.hrp, F.hum, F.chat, F.getChatChannel
local P = game:GetService("Players")
local Me = P.LocalPlayer

------------------------------------------------
-- แท็บ 4: ป้องกัน 🛡️
------------------------------------------------
local T4 = Window:CreateTab("ป้องกัน 🛡️", 4483362458)

T4:CreateToggle({
   Name = "Stealth Mode (ล็อกค่าไม่ให้เว่อร์)",
   CurrentValue = false,
   Callback = function(v) S.Stealth = v end,
})
T4:CreateParagraph({
   Title = "Stealth Mode คืออะไร",
   Content = "เปิดแล้วจะล็อกค่าวิ่ง/กระโดด/บินไม่ให้เกินลิมิตปลอดภัย (วิ่ง 250 / กระโดด 500 / บิน 150) กันโดนจับได้ว่าใช้สคริปต์",
})
T4:CreateToggle({
   Name = "ปิดข้อความ K8 ในแชท 🤫",
   CurrentValue = false,
   Callback = function(v) S.NoChat = v end,
})
T4:CreateSlider({
   Name = "สุ่มจังหวะสแปมคลาดเคลื่อน (0-0.10)",
   Range = {0, 0.10},
   Increment = 0.005,
   CurrentValue = 0,
   Callback = function(v) S.Jitter = v end,
})
T4:CreateSlider({
   Name = "โอกาสข้ามไม่สแปม % (0-30)",
   Range = {0, 30},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(v) S.MissChance = v / 100 end,
})
T4:CreateParagraph({
   Title = "Jitter / Miss Chance คืออะไร",
   Content = "ตัวสุ่มจังหวะสแปมแชทให้ดูเหมือนคนพิมพ์: Jitter สุ่มเวลาให้คลาดเคลื่อน ส่วน Miss Chance คือโอกาสข้ามไม่ส่งข้อความบ้าง (กันโดนจับ pattern)",
})
T4:CreateButton({
   Name = "🚨 PANIC ปิดทุกอย่าง",
   Callback = function()
      S.Panic = true
      local h = hum()
      if h then h.WalkSpeed = 16 h.JumpPower = 50 end
      local r = hrp()
      if r then
         for _, c in pairs(r:GetChildren()) do
            if c.Name == "KK888FlyV" or c.Name == "KK888FlyG" or c.Name == "KA" then
               c:Destroy()
            end
         end
      end
      for _, p in pairs(workspace:GetChildren()) do
         if p.Name == "KO" then p:Destroy() end
      end
      local pg = Me:FindFirstChildOfClass("PlayerGui")
      local fgui = pg and pg:FindFirstChild("KK888FlyUI")
      if fgui then fgui.Enabled = false end
      Rayfield:Notify({ Title = "KK888 HUB", Content = "🚨 ปิดทุกอย่างแล้ว", Duration = 3 })
      task.wait(1.5)
      pcall(function() Rayfield:Destroy() end)
   end,
})

------------------------------------------------
-- แท็บ 5: Brookhaven 🏠
------------------------------------------------
local T5 = Window:CreateTab("Brookhaven 🏠", 4483362458)

T5:CreateSection("เปิดเพลง 🎵")
T5:CreateButton({
   Name = "🎵 เปิดสคริปเพลง",
   Callback = function()
      local ok2 = pcall(function()
         loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-R4D-TROLL-NO-KEY-17625"))()
      end)
      Rayfield:Notify({
         Title = "KK888 HUB",
         Content = ok2 and "โหลดสคริปเพลงแล้ว 🎵" or "โหลดไม่สำเร็จ ❌ เช็กเน็ตแล้วลองใหม่",
         Duration = 3,
      })
   end,
})

T5:CreateSection("สแปมแชท 💬")
local spm, spon, sdly = "", false, 2
T5:CreateInput({
   Name = "ข้อความสแปม",
   PlaceholderText = "เช่น เกรียนมาแล้ววว",
   RemoveTextAfterFocusLost = false,
   Callback = function(t) spm = t end,
})
T5:CreateSlider({
   Name = "สแปมทุกกี่วิ (ยิ่งน้อยยิ่งเร็ว)",
   Range = {0.2, 10},
   Increment = 0.1,
   CurrentValue = 2,
   Callback = function(v) sdly = v end,
})
T5:CreateToggle({
   Name = "💬 สแปมแชท",
   CurrentValue = false,
   Callback = function(v)
      spon = v
      if v then
         if spm == "" then
            Rayfield:Notify({ Title = "KK888 HUB", Content = "พิมพ์ข้อความก่อน ❌", Duration = 3 })
            spon = false
            return
         end
         task.spawn(function()
            while spon do
               if S.Panic then spon = false break end
               if math.random() >= S.MissChance then
                  pcall(function()
                     local ch = getChatChannel()
                     if ch then ch:SendAsync(spm) end
                  end)
               end
               task.wait(math.max(0.2, sdly + (math.random() * 2 - 1) * S.Jitter * 20))
            end
         end)
      end
   end,
})

T5:CreateSection("วาร์ป 🌀")
local tnm = ""
T5:CreateInput({
   Name = "ชื่อคนที่จะวาร์ป",
   PlaceholderText = "เช่น thanwa",
   RemoveTextAfterFocusLost = false,
   Callback = function(t) tnm = t:lower() end,
})
T5:CreateButton({
   Name = "🌀 วาร์ปไปหา",
   Callback = function()
      if tnm == "" then
         Rayfield:Notify({ Title = "KK888 HUB", Content = "พิมพ์ชื่อก่อน ❌", Duration = 3 })
         return
      end
      for _, p in pairs(P:GetPlayers()) do
         if p.Name:lower():find(tnm, 1, true) or p.DisplayName:lower():find(tnm, 1, true) then
            local t = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            local h = hrp()
            if t and h then
               h.CFrame = t.CFrame + Vector3.new(0, 0, 4)
               Rayfield:Notify({ Title = "KK888 HUB", Content = "วาร์ปแล้ว 🌀", Duration = 3 })
            end
            break
         end
      end
   end,
})

------------------------------------------------
-- แท็บ 6: Fling 🥶
------------------------------------------------
local T6 = Window:CreateTab("Fling🥶", 4483362458)
T6:CreateParagraph({
   Title = "🥶 Fling",
   Content = "กดปุ่มด้านล่างเพื่อเปิดสคริปต์ Fling (dropkick GUI)",
})
T6:CreateButton({
   Name = "🥶 เปิดสคริป Fling",
   Callback = function()
      local ok2 = pcall(function()
         loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-dropkick-(kickgui)-r15-229511"))()
      end)
      Rayfield:Notify({
         Title = "KK888 HUB",
         Content = ok2 and "โหลดสคริป Fling แล้ว 🥶" or "โหลดไม่สำเร็จ ❌ เช็กเน็ตแล้วลองใหม่",
         Duration = 3,
      })
   end,
})

Rayfield:LoadConfiguration()

end)

------------------------------------------------
-- โหลดเสร็จ: แจ้งเตือน + เสียง
------------------------------------------------
if not ok then
   showError(err)
else
   print("✅ KK888 HUB ครบทุกส่วน โหลดสำเร็จ")
   pcall(function()
      local rf = _G.KK888R or _G.KK888Rayfield
      if rf then
         rf:Notify({ Title = "KK888 HUB", Content = "✅ โหลดสคริปครบทุกส่วนแล้ว!", Duration = 5 })
      end
   end)
   pcall(function()
      local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
      local snd = Instance.new("Sound")
      snd.Name = "KK888Done"
      snd.SoundId = "rbxassetid://137783553081376"
      snd.Volume = 1
      snd.Parent = pg
      snd:Play()
      game:GetService("Debris"):AddItem(snd, 5)
   end)
end
