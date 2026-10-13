local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NiaH Hub🎴 | DOORS Engine V17.0",
   LoadingTitle = "NiaH Hub🎴",
   LoadingSubtitle = "By: NiaH🎴 • Exclusive Edition",
   ConfigurationSaving = { Enabled = true, FolderName = "NiaHHub", FileName = "Config" },
   Discord = { Enabled = false },
   KeySystem = false,
})

-- // SERVICES & STATE //
local Players, RunService, Workspace, Lighting, RS, Pps = game:GetService("Players"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Lighting"), game:GetService("ReplicatedStorage"), game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

local State = {
   AutoLibrary = false, AutoBreaker = false, AutoHeartbeat = false,
   EntityNotifier = true, AutoSeek = false, AntiEyes = false, AntiScreech = false, AntiDupe = false, AntiSnare = false,
   DoorESP = false, KeyESP = false, ItemESP = false, BookESP = false, GoldESP = false, ClosetESP = false, ESPDistance = 90,
   InstantInteract = false, AutoCollect = false, AutoOpenDrawers = false, AutoDoor = false, AutoUseKey = false,
   AutoCollectDistance = 16, AutoDrawerDistance = 7, AutoDoorDistance = 12,
   Fullbright = false, EnableSpeed = false, WalkSpeedVal = 16, Noclip = false
}

local Cache, ESPStorage = setmetatable({}, {__mode = "k"}), {}

-- // UTILS //
local function getPos(p)
   if not p or not p.Parent then return end
   local par = p.Parent
   return par:IsA("BasePart") and par.Position or par:IsA("Attachment") and par.WorldPosition or par:IsA("Model") and par:GetPivot().Position
end

local function getActiveRooms()
   local rooms, rf = {}, Workspace:FindFirstChild("CurrentRooms")
   if not rf then return rooms end
   local num = RS:FindFirstChild("GameData") and RS.GameData:FindFirstChild("LatestRoom") and RS.GameData.LatestRoom.Value
   if num then
      for i = num - 1, num + 1 do
         local r = rf:FindFirstChild(tostring(i))
         if r then table.insert(rooms, r) end
      end
   else
      local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then
         for _, r in ipairs(rf:GetChildren()) do
            local p = r.PrimaryPart or r:FindFirstChildWhichIsA("BasePart")
            if p and (p.Position - hrp.Position).Magnitude <= 100 then table.insert(rooms, r) end
         end
      end
   end
   return rooms
end

-- // ESP FUNCTIONS //
local function RemoveESP(inst)
   if ESPStorage[inst] then
      pcall(function()
         if ESPStorage[inst].hl then ESPStorage[inst].hl:Destroy() end
         if ESPStorage[inst].bg then ESPStorage[inst].bg:Destroy() end
      end)
      ESPStorage[inst] = nil
   end
end

local function ClearESPGroup(group)
   for inst, data in pairs(ESPStorage) do if data.Group == group then RemoveESP(inst) end end
end

local function CreateESP(part, inst, color, text, group)
   if not part or not inst or ESPStorage[inst] then return end
   local bg = Instance.new("BillboardGui")
   bg.Size, bg.AlwaysOnTop, bg.StudsOffset, bg.Adornee, bg.Parent = UDim2.new(0, 140, 0, 30), true, Vector3.new(0, 2.2, 0), part, part
   local txt = Instance.new("TextLabel")
   txt.Size, txt.BackgroundTransparency, txt.Text, txt.TextColor3, txt.TextSize, txt.Font, txt.Parent = UDim2.new(1,0,1,0), 1, text or inst.Name, color, 13, Enum.Font.SourceSansBold, bg
   local hl
   if inst:IsA("Model") or inst:IsA("BasePart") then
      hl = Instance.new("Highlight")
      hl.Adornee, hl.FillColor, hl.FillTransparency, hl.OutlineColor, hl.Parent = inst, color, 0.6, Color3.new(0,0,0), part
   end
   ESPStorage[inst] = {hl = hl, bg = bg, txt = txt, base = text or inst.Name, Group = group, Part = part}
end

-- // UI BUILDER //
local Tabs = {
   Auto = Window:CreateTab("⚡ Automations", 4483362458),
   Puzzle = Window:CreateTab("🧩 Solvers", 4483362458),
   Surv = Window:CreateTab("🛡️ Survival", 4483362458),
   Vis = Window:CreateTab("👁️ Visuals & ESP", 4483362458),
   Move = Window:CreateTab("🚀 Movement", 4483362458)
}

local function addT(tab, name, key, default)
   return tab:CreateToggle({Name = name, CurrentValue = default or false, Callback = function(v) State[key] = v end})
end
local function addS(tab, name, key, min, max, default, suffix)
   return tab:CreateSlider({Name = name, Range = {min, max}, Increment = 1, Suffix = suffix or "", CurrentValue = default, Callback = function(v) State[key] = v end})
end
local function addESP(tab, name, key, group)
   return tab:CreateToggle({Name = name, CurrentValue = false, Callback = function(v) State[key] = v if not v then ClearESPGroup(group) end end})
end

-- Automation Tab
addT(Tabs.Auto, "Auto-Open Doors", "AutoDoor")
addT(Tabs.Auto, "Auto-Equip & Unlock Doors", "AutoUseKey")
addS(Tabs.Auto, "Door Unlock Distance", "AutoDoorDistance", 5, 20, 12, "Studs")
addT(Tabs.Auto, "Auto-Open Drawers", "AutoOpenDrawers")
addS(Tabs.Auto, "Drawer Reach Distance", "AutoDrawerDistance", 3, 12, 7, "Studs")
addT(Tabs.Auto, "Auto-Collect Gold & Items", "AutoCollect")
addS(Tabs.Auto, "Collection Distance", "AutoCollectDistance", 5, 25, 16, "Studs")
addT(Tabs.Auto, "Instant Interaction", "InstantInteract")
addT(Tabs.Auto, "Auto Seek Helper", "AutoSeek")

-- Puzzles Tab
addT(Tabs.Puzzle, "Auto Library (Door 50)", "AutoLibrary")
addT(Tabs.Puzzle, "Auto Breaker Box (Door 100)", "AutoBreaker")
addT(Tabs.Puzzle, "Auto Heartbeat Minigame", "AutoHeartbeat")

-- Survival Tab
addT(Tabs.Surv, "Entity Alert Radar", "EntityNotifier", true)
addT(Tabs.Surv, "Anti-Eyes Protection", "AntiEyes")
addT(Tabs.Surv, "Anti-Screech Bypass", "AntiScreech")
addESP(Tabs.Surv, "Anti-Dupe Detector", "AntiDupe", "Dupe")
Tabs.Surv:CreateToggle({Name = "Anti-Snare Protection", CurrentValue = false, Callback = function(v)
   State.AntiSnare = v
   if v then
      for _, o in ipairs(Workspace:GetDescendants()) do
         if o.Name == "Snare" then for _, p in ipairs(o:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = false end end end
      end
   end
end})

-- Visuals Tab
addESP(Tabs.Vis, "Door ESP", "DoorESP", "Door")
addESP(Tabs.Vis, "Key & Lever ESP", "KeyESP", "Key")
addESP(Tabs.Vis, "Item Highlights ESP", "ItemESP", "Item")
addESP(Tabs.Vis, "Objective Book & Fuse ESP", "BookESP", "Objective")
addESP(Tabs.Vis, "Gold Pile & Chest ESP", "GoldESP", "Gold")
addESP(Tabs.Vis, "Safe Closet ESP", "ClosetESP", "Closet")
Tabs.Vis:CreateToggle({Name = "Fullbright Ambient Mode", CurrentValue = false, Callback = function(v)
   State.Fullbright = v
   Lighting.Brightness = v and 2 or 1
   Lighting.ClockTime = v and 14 or 12
   Lighting.FogEnd = v and 100000 or 1000
   Lighting.GlobalShadows = not v
end})

-- Movement Tab
addT(Tabs.Move, "Enable Custom WalkSpeed", "EnableSpeed")
addS(Tabs.Move, "WalkSpeed Multiplier", "WalkSpeedVal", 16, 28, 16, "Speed")
addT(Tabs.Move, "Noclip Pass-Through", "Noclip")

-- =========================================================================
-- CORE LOOPS & HANDLERS
-- =========================================================================

-- Main Automation Loop
task.spawn(function()
   while task.wait(0.25) do
      if State.AutoCollect or State.AutoOpenDrawers or State.AutoDoor or State.AutoUseKey then
         local char = LocalPlayer.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         local hum = char and char:FindFirstChild("Humanoid")
         if hrp then
            for _, room in ipairs(getActiveRooms()) do
               for _, prompt in ipairs(room:GetDescendants()) do
                  if prompt:IsA("ProximityPrompt") and prompt.Enabled and not Cache[prompt] then
                     local pos = getPos(prompt)
                     if pos then
                        local dist = (pos - hrp.Position).Magnitude
                        local pName = prompt.Parent and prompt.Parent.Name:lower() or ""
                        local act = prompt.ActionText:lower()
                        local obj = prompt.ObjectText:lower()
                        local isHide = pName:find("hide") or pName:find("wardrobe") or pName:find("bed") or act:find("hide")
                        
                        if not isHide then
                           local isLock = pName:find("lock") or act:find("unlock") or act:find("key")
                           local isDoor = pName:find("door") and not isLock
                           local isDrawer = pName:find("drawer") or pName:find("knob")
                           local isLoot = pName:find("gold") or pName:find("key") or pName:find("book") or act:find("take") or obj:find("key")

                           local triggered = false
                           if State.AutoUseKey and isLock and dist <= State.AutoDoorDistance then
                              local key = char:FindFirstChild("Key") or char:FindFirstChild("KeyItem") or LocalPlayer.Backpack:FindFirstChild("Key")
                              if key then
                                 if key.Parent == LocalPlayer.Backpack and hum then hum:EquipTool(key) end
                                 triggered = true
                              end
                           elseif State.AutoDoor and isDoor and dist <= State.AutoDoorDistance then
                              triggered = true
                           elseif State.AutoOpenDrawers and isDrawer and dist <= State.AutoDrawerDistance then
                              triggered = true
                           elseif State.AutoCollect and isLoot and dist <= State.AutoCollectDistance then
                              triggered = true
                           end

                           if triggered then
                              Cache[prompt] = true
                              fireproximityprompt(prompt)
                              task.delay(4, function() Cache[prompt] = nil end)
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end
end)

-- Solvers Loops
task.spawn(function()
   while task.wait(0.3) do
      if State.AutoLibrary then
         local r50 = Workspace:FindFirstChild("CurrentRooms") and Workspace.CurrentRooms:FindFirstChild("50")
         if r50 then
            for _, o in ipairs(r50:GetDescendants()) do
               if o.Name == "LiveHintBook" then
                  local p = o:FindFirstChildWhichIsA("ProximityPrompt")
                  if p and p.Enabled then fireproximityprompt(p) end
               end
            end
         end
      end
   end
end)

task.spawn(function()
   while task.wait(0.2) do
      if State.AutoBreaker then
         local bUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI:FindFirstChild("Breaker")
         if bUI and bUI.Visible and bUI:FindFirstChild("Frame") then
            for i = 1, 10 do
               local sw = bUI.Frame:FindFirstChild(tostring(i))
               if sw and sw:FindFirstChild("Enabled") and sw.Enabled.Visible then
                  local rem = RS:FindFirstChild("RemotesFolder") and RS.RemotesFolder:FindFirstChild("BreakerToggle")
                  if rem then rem:FireServer(i, true) end
               end
            end
         end
      end
   end
end)

task.spawn(function()
   while task.wait(0.1) do
      if State.AutoHeartbeat then
         local hb = LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI:FindFirstChild("Heartbeat")
         if hb and hb.Visible then
            local rem = RS:FindFirstChild("RemotesFolder") and RS.RemotesFolder:FindFirstChild("Heartbeat")
            if rem then rem:FireServer(true) end
         end
      end
   end
end)

-- Instant Interaction & Entity Notifier
Pps.PromptButtonHoldBegan:Connect(function(prompt) if State.InstantInteract then fireproximityprompt(prompt) end end)

Workspace.ChildAdded:Connect(function(child)
   if State.EntityNotifier and (child.Name:find("Rush") or child.Name:find("Ambush") or child.Name:find("Eyes") or child.Name:find("Screech") or child.Name:find("A60")) then
      Rayfield:Notify({Title = "🎴 ENTITY ALERT!", Content = child.Name:upper() .. " has spawned!", Duration = 4})
   end
end)

-- Auto Seek Chase Loop
task.spawn(function()
   while task.wait(0.1) do
      if State.AutoSeek then
         local char = LocalPlayer.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         if hrp and Workspace:FindFirstChild("CurrentRooms") then
            for _, r in ipairs(Workspace.CurrentRooms:GetChildren()) do
               if r:FindFirstChild("Path") or r.Name:find("Seek") then
                  local d = r:FindFirstChild("Door")
                  local dp = d and (d:FindFirstChild("Door") or d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart"))
                  if dp and (dp.Position - hrp.Position).Magnitude < 100 then
                     for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch, p.CanCollide = false, false end end
                     hrp.CFrame = hrp.CFrame:Lerp(dp.CFrame * CFrame.new(0, 0, -3), 0.25)
                  end
               end
            end
         end
      end
   end
end)

-- ESP Scanner Loop
task.spawn(function()
   while task.wait(2.0) do
      local char = LocalPlayer.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      if hrp then
         for _, r in ipairs(getActiveRooms()) do
            if State.DoorESP and r:FindFirstChild("Door") then
               local dp = r.Door:FindFirstChild("Door") or r.Door.PrimaryPart or r.Door:FindFirstChildWhichIsA("BasePart")
               if dp then CreateESP(dp, dp, Color3.fromRGB(0, 255, 128), "Door " .. r.Name, "Door") end
            end
            if State.KeyESP or State.ItemESP or State.GoldESP then
               for _, o in ipairs(r:GetDescendants()) do
                  local n = o.Name
                  if State.KeyESP and (n == "Key" or n == "KeyItem" or n == "LeverForDoor") then
                     local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart", true)
                     if p then CreateESP(p, o, Color3.fromRGB(255, 215, 0), n, "Key") end
                  elseif State.ItemESP and o:IsA("Model") and (n == "Lighter" or n == "Lockpick" or n == "Vitamins" or n == "Crucifix") then
                     local p = o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart", true)
                     if p then CreateESP(p, o, Color3.fromRGB(0, 191, 255), n, "Item") end
                  elseif State.GoldESP and (n == "GoldPile" or n == "ChestBox") then
                     local p = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart", true)
                     if p then CreateESP(p, o, Color3.fromRGB(255, 223, 0), "Gold", "Gold") end
                  end
               end
            end
         end
      end
   end
end)

-- Render Loop (Speed, Noclip, Anti-Eyes & ESP Update)
RunService.Heartbeat:Connect(function()
   local char = LocalPlayer.Character
   local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   if State.EnableSpeed and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = State.WalkSpeedVal end
   if State.Noclip then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
   if State.AntiEyes and Workspace:FindFirstChild("Eyes") then
      local cam = Workspace.CurrentCamera
      cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position - Vector3.new(0, 20, 0))
   end

   for inst, data in pairs(ESPStorage) do
      if not inst or not inst.Parent then RemoveESP(inst)
      elseif data.Part then
         local dist = (data.Part.Position - hrp.Position).Magnitude
         local visible = dist <= State.ESPDistance
         if data.bg then data.bg.Enabled = visible end
         if data.hl then data.hl.Enabled = visible end
         if visible and data.txt then data.txt.Text = data.base .. " [" .. math.floor(dist) .. "m]" end
      end
   end
end)

Rayfield:Notify({ Title = "NiaH Hub🎴 Loaded", Content = "Script fully operational. By: NiaH🎴", Duration = 3 })
Rayfield:LoadConfiguration()
