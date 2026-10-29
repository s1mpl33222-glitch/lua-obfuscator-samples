-- ======================================================
-- Vocational Blood Script (สคริปต์สายเลือดอาชีวะ)
-- UI Style: Modern Clean / Fluent Design
-- Executable on: Mobile & PC Executors
-- ======================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 สายเลือดอาชีวะ HUB | Vocational Script",
   LoadingTitle = "กำลังโหลดระบบอาชีวะ...",
   LoadingSubtitle = "by BIazeHTQ",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VocationalHubConfig",
      FileName = "VocationalBlood"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- ==================== [ TAB: MAIN FEATURES ] ====================
local MainTab = Window:CreateTab("หลัก / ต่อสู้", 4483362458) -- Title, Image

local SectionPVP = MainTab:CreateSection("ระบบต่อสู้ & ออโต้")

-- Auto Farm / Hitbox Multiplier
local HitboxEnabled = false
local HitboxSize = 10

local HitboxToggle = MainTab:CreateToggle({
   Name = "เปิดระบบ Hitbox ขยายระยะโจมตี",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
      HitboxEnabled = Value
      task.spawn(function()
         while HitboxEnabled do
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  pcall(function()
                     player.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                     player.Character.HumanoidRootPart.Transparency = 0.7
                     player.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                     player.Character.HumanoidRootPart.Material = Enum.Material.Neon
                     player.Character.HumanoidRootPart.CanCollide = false
                  end)
               end
            end
            task.wait(1)
         end
         -- Reset Hitbox เมื่อปิด
         if not HitboxEnabled then
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  pcall(function()
                     player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                     player.Character.HumanoidRootPart.Transparency = 1
                     player.Character.HumanoidRootPart.CanCollide = false
                  end)
               end
            end
         end
      end)
   end,
})

local HitboxSlider = MainTab:CreateSlider({
   Name = "ขนาด Hitbox",
   Range = {2, 50},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 10,
   Flag = "HitboxSize",
   Callback = function(Value)
      HitboxSize = Value
   end,
})

-- Auto Attack / Fast Attack
local FastAttack = false
MainTab:CreateToggle({
   Name = "โจมตีเร็ว / ตีกระจาย (Fast Attack)",
   CurrentValue = false,
   Flag = "FastAttack",
   Callback = function(Value)
      FastAttack = Value
      task.spawn(function()
         while FastAttack do
            local char = game.Players.LocalPlayer.Character
            if char then
               local tool = char:FindFirstChildOfClass("Tool")
               if tool then
                  tool:Activate()
               end
            end
            task.wait(0.1)
         end
      end)
   end,
})

-- Lock Target / ESP Aim Line
local LockTarget = nil
MainTab:CreateButton({
   Name = "ล็อคเป้าหมายผู้เล่นใกล้ที่สุด",
   Callback = function()
      local closestPlayer = nil
      local shortestDistance = math.huge
      for _, v in pairs(game.Players:GetPlayers()) do
         if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
               shortestDistance = dist
               closestPlayer = v
            end
         end
      end
      if closestPlayer then
         LockTarget = closestPlayer
         Rayfield:Notify({
            Title = "ล็อคเป้าสำเร็จ!",
            Content = "กำลังล็อคเป้า: " .. closestPlayer.DisplayName,
            Duration = 3,
            Image = 4483362458,
         })
         game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
      end
   end,
})


-- ==================== [ TAB: ESP & VISUALS ] ====================
local ESPTab = Window:CreateTab("มองเห็น (ESP)", 4483362458)

local ESPEnabled = false
ESPTab:CreateToggle({
   Name = "เปิด ESP มองเห็นชื่อและหลอดเลือดคนในแมพ",
   CurrentValue = false,
   Flag = "ESPName",
   Callback = function(Value)
      ESPEnabled = Value
      for _, player in pairs(game.Players:GetPlayers()) do
         if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if Value then
               if not player.Character.Head:FindFirstChild("VocationalESP") then
                  local bgui = Instance.new("BillboardGui", player.Character.Head)
                  bgui.Name = "VocationalESP"
                  bgui.Size = UDim2.new(0, 100, 0, 40)
                  bgui.StudsOffset = Vector3.new(0, 2, 0)
                  bgui.AlwaysOnTop = true

                  local txt = Instance.new("TextLabel", bgui)
                  txt.Size = UDim2.new(1, 0, 1, 0)
                  txt.BackgroundTransparency = 1
                  txt.TextColor3 = Color3.fromRGB(255, 50, 50)
                  txt.TextStrokeTransparency = 0
                  txt.TextSize = 14
                  txt.Text = player.Name .. "\n[HP: " .. math.floor(player.Character.Humanoid.Health) .. "]"
               end
            else
               if player.Character.Head:FindFirstChild("VocationalESP") then
                  player.Character.Head.VocationalESP:Destroy()
               end
            end
         end
      end
   end,
})

-- ==================== [ TAB: PLAYER MODS ] ====================
local PlayerTab = Window:CreateTab("ตัวละคร", 4483362458)

PlayerTab:CreateSlider({
   Name = "ความเร็วการเดิน (Speed)",
   Range = {16, 200},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "แรงกระโดด (Jump Power)",
   Range = {50, 300},
   Increment = 5,
   Suffix = " Jump",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "กระโดดกลางอากาศไม่จำกัด (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      _G.InfJump = Value
      game:GetService("UserInputService").JumpRequest:Connect(function()
         if _G.InfJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
         end
      end)
   end,
})

PlayerTab:CreateToggle({
   Name = "เดินทะลุกำแพง (Noclip)",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      _G.Noclip = Value
      game:GetService("RunService").Stepped:Connect(function()
         if _G.Noclip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
               if v:IsA("BasePart") then
                  v.CanCollide = false
               end
            end
         end
      end)
   end,
})

-- ==================== [ TAB: TELEPORT ] ====================
local CPTab = Window:CreateTab("วาร์ปจุดต่างๆ", 4483362458)

CPTab:CreateButton({
   Name = "วาร์ปไปหาผู้เล่น (เลือกในเซิร์ฟ)",
   Callback = function()
      -- ตัวอย่างวาร์ปไปหาคนใกล้ตัวที่สุด
      local target = nil
      for _, v in pairs(game.Players:GetPlayers()) do
         if v ~= game.Players.LocalPlayer and v.Character then
            target = v.Character.HumanoidRootPart
            break
         end
      end
      if target then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 3)
      end
   end,
})

-- แจ้งเตือนเมื่อโหลดสำเร็จ
Rayfield:Notify({
   Title = "สคริปต์พร้อมใช้งาน!",
   Content = "สคริปต์สายเลือดอาชีวะ โหลดสมบูรณ์แล้ว",
   Duration = 5,
   Image = 4483362458,
})
