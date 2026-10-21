local UIS = game:GetService("UserInputService")
FARM_RANGE = FARM_RANGE or 300
Range = Range or 100
ply = ply or game:GetService("Players")
Core = Core or {}
getgenv().Core = Core
do
  ply = game.Players
  plr = ply.LocalPlayer
  Root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  replicated = game:GetService("ReplicatedStorage")
  Lv = game.Players.LocalPlayer.Data.Level.Value
  TeleportService = game:GetService("TeleportService")
  TW = game:GetService("TweenService")
  Lighting = game:GetService("Lighting")
  Enemies = workspace.Enemies
  vim1 = game:GetService("VirtualInputManager")
  vim2 = game:GetService("VirtualUser")
  TeamSelf = plr.Team
  RunSer = game:GetService("RunService")
  Stats = game:GetService("Stats")
  Energy = plr.Character and plr.Character:FindFirstChild("Energy") and plr.Character.Energy.Value or 100
  BringConnections = {}
  BossList = {}
  MaterialList = {}
  NPCList = {}
  PlrList = {}
  shouldTween = false
  getgenv().OnFarm = false
  getgenv().AutoMaterial = false
  NextIs = false
  senth = false
  senth2 = false
  SoulGuitar = false
  KenTest = true
  debug = false
  Brazier1 = false
  Brazier2 = false
  Brazier3 = false
  Sec = 0.1
  ClickState = 0
  Num_self = 25
end

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
  table.insert(PlrList, v.Name)
end
game:GetService("Players").PlayerAdded:Connect(function(player)
  table.insert(PlrList, player.Name)
end)
game:GetService("Players").PlayerRemoving:Connect(function(player)
  local idx = table.find(PlrList, player.Name)
  if idx then table.remove(PlrList, idx) end
end)

-- Root updater on respawn
PrehisUser = {Find = false, Skills = false, DE = false}
plr.CharacterAdded:Connect(function(char)
  local hrp = char:WaitForChild("HumanoidRootPart", 15)
  if hrp then Root = hrp end
end)

repeat local start = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded() task.wait() until start
World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end
Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end

if World1 then BossList = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"}
elseif World2 then BossList = {"Diamond","Jeremy","Orbitus","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"}
elseif World3 then BossList = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Dough King","Longma","Soul Reaper","rip_indra True Form","Tyrant of the Skies"}
end
if World1 then MaterialList = {"Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"}
elseif World2 then MaterialList = {"Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang"}
elseif World3 then MaterialList = {"Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}
end
DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
RenMon = {"Snow Lurker","Arctic Warrior","Hidden Key","Awakened Ice Admiral"}
CursedTables = {["Mob"] = "Mythological Pirate",["Mob2"] = "Cursed Skeleton","Hell's Messenger",["Mob3"] = "Cursed Skeleton","Heaven's Guardian"}
Past = {"Part","SpawnLocation","Terrain","WedgePart","MeshPart"}
BartMon = {"Swan Pirate","Jeremy"}
CitizenTable = {"Forest Pirate","Captain Elephant"}
Human_v3_Mob = {"Fajita","Jeremy","Diamond"} AllBoats = {"Beast Hunter","Lantern","Guardian","Grand Brigade","Dinghy","Sloop","The Sentinel"}
mastery1 = {"Cookie Crafter"}
mastery2 = {"Reborn Skeleton"}
PosMsList = {["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625),["Pistol Billionaire"] = CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625),["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.76270294189453, -730.1290893554688),["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),["Venomous Assailant"] = CFrame.new(4902, 670, 39), ["Marine Commodore"] = CFrame.new(2401, 123, -7589),["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),["Fishman Raider"] = CFrame.new(-10941, 332, -8760),["Fishman Captain"] = CFrame.new(-11035, 332, -9087),["Forest Pirate"] = CFrame.new(-13446, 413, -7760),["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),["Living Zombie"] = CFrame.new(-10227, 421, 6161),["Demonic Soul"] = CFrame.new(-9579, 6, 6194),["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),["Peanut Scout"] = CFrame.new(-1993, 187, -10103),["Peanut President"] = CFrame.new(-2215, 159, -10474),["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),["Cake Guard"] = CFrame.new(-2024, 38, -12026),["Baking Staff"] = CFrame.new(-1932, 38, -12848),["Head Baker"] = CFrame.new(-1932, 38, -12848),["Cocoa Warrior"] = CFrame.new(95, 73, -12309),["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),["Sweet Thief"] = CFrame.new(116, 36, -12478),["Candy Rebel"] = CFrame.new(47, 61, -12889),["Ghost"] = CFrame.new(5251, 5, 1111)}
Remotes = {
    RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"], 
    RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}
EquipWeapon = function(text)
  if not text then return end
  if plr.Backpack:FindFirstChild(text) then
	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(text))
  end
end
weaponSc = function(weapon)
  for __in, v in pairs(plr.Backpack:GetChildren()) do
    if v:IsA("Tool") then
      if v.ToolTip == weapon then EquipWeapon(v.Name) end
    end
  end
end
Attack = {}
Attack.__index = Attack
Attack.Alive = function(model)
  if not model then return false end
  local Humanoid = model:FindFirstChild("Humanoid")
  local hrp = model:FindFirstChild("HumanoidRootPart")
  return Humanoid ~= nil and Humanoid.Health > 0 and hrp ~= nil
end
Attack.Pos = function(model,dist) return (Root.Position - model.Position).Magnitude <= dist end
Attack.Dist = function(model,dist) local hrp = model and model:FindFirstChild("HumanoidRootPart") return hrp and (Root.Position - hrp.Position).Magnitude <= dist or false end
Attack.DistH = function(model,dist) local hrp = model and model:FindFirstChild("HumanoidRootPart") return hrp and (Root.Position - hrp.Position).Magnitude > dist or false end
Attack.Kill = function(model,Succes)
  if model and Succes then
  local hrp = model:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",hrp.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped and Equipped:FindFirstChild("ToolTip") and Equipped.ToolTip or ""
  if ToolTip == "Blox Fruit" then _tp(hrp.CFrame * CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(hrp.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(180),0))end
  if RandomCFrame then task.wait(.5)_tp(hrp.CFrame * CFrame.new(0, 30, 25)) task.wait(.5)_tp(hrp.CFrame * CFrame.new(25, 30, 0)) task.wait(.5)_tp(hrp.CFrame * CFrame.new(-25, 30 ,0)) task.wait(.5)_tp(hrp.CFrame * CFrame.new(0, 30, 25)) task.wait(.5)_tp(hrp.CFrame * CFrame.new(-25, 30, 0))end
  end
end
Attack.Kill2 = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped and Equipped:FindFirstChild("ToolTip") and Equipped.ToolTip or ""
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,8) * CFrame.Angles(0,math.rad(180),0))end
  if RandomCFrame then task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
  end
end
Attack.KillSea = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  EquipWeapon(_G.SelectWeapon)
  local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
  local ToolTip = Equipped and Equipped:FindFirstChild("ToolTip") and Equipped.ToolTip or ""
  if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(90),0)) else notween(model.HumanoidRootPart.CFrame * CFrame.new(0,50,8)) task.wait(.85)notween(model.HumanoidRootPart.CFrame * CFrame.new(0,400,0)) task.wait(1)end
  end
end
Attack.Sword = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
  weaponSc("Sword")
  _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
  if RandomCFrame then task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) task.wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
  end
end
Attack.Mas = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
    if model.Humanoid.Health <= HealthM then
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
      local skillsToUse = _G.SelectedMasterySkills or {"Z", "X", "C", "V", "F"}
      for k, v in pairs(skillsToUse) do
          if type(k) == "number" then
              Useskills("Blox Fruit", v)
          elseif type(k) == "string" and v == true then
              Useskills("Blox Fruit", k)
          end
      end
    else
      weaponSc("Melee")
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
    end
  end
end
Attack.Masgun = function(model,Succes)
  if model and Succes then
  if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
  PosMon = model:GetAttribute("Locked").Position
  BringEnemy()
    if model.Humanoid.Health <= HealthM then
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,35,8))
      local skillsToUse = _G.SelectedMasterySkills or {"Z", "X", "C", "V", "F"}
      for k, v in pairs(skillsToUse) do
          if type(k) == "number" then
              Useskills("Gun", v)
          elseif type(k) == "string" and v == true then
              Useskills("Gun", k)
          end
      end
    else
      weaponSc("Melee")
      _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
    end
  end
end
statsSetings = function(Num, value)
  if Num == "Melee" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Melee",value)
    end
  elseif Num == "Defense" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Defense",value)
    end
  elseif Num == "Sword" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Sword",value)
    end
  elseif Num == "Gun" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Gun",value)
    end
  elseif Num == "Devil" then
    if plr.Data.Points.Value ~= 0 then
      replicated.Remotes.CommF_:InvokeServer("AddPoint","Demon Fruit",value)
    end
  end
end
BringEnemy = function(Mon)
    if not _B then return end
    if not Mon then 
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local closestDist = math.huge
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    Mon = enemy
                end
            end
        end
        if not Mon then return end
    end
    
    local AreaMob = false
    
    function Mobs(enemy)
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        return hum and root and hum.Health > 0, root, hum
    end

    function Network(part)
        if isnetworkowner then
            return isnetworkowner(part)
        end
        return part.ReceiveAge == 0 and not part.Anchored and part.Velocity.Magnitude > 0
    end
    
    pcall(function()
        if sethiddenproperty then 
            sethiddenproperty(plr, "SimulationRadius", math.huge)
        end
        
        local targetPos = Mon.HumanoidRootPart.Position
        
        for _, v in ipairs(workspace.Enemies:GetChildren()) do
            if v ~= Mon then
                local alive, root, hum = Mobs(v)
                if alive and v.Name == Mon.Name then
                    local distance = (root.Position - targetPos).Magnitude
                    if distance <= 3000 then
                        local bv = root:FindFirstChild("BodyVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.Name = "BodyVelocity"
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        
                        if distance <= 10 then
                            AreaMob = true
                        end
                        
                        if not AreaMob and Network(root) then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        
                        root.CanCollide = false
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                    end
                end
            end
        end
        
        if Mon and Mon:FindFirstChild("HumanoidRootPart") then
            Mon.HumanoidRootPart.CanCollide = false
            Mon.Humanoid.WalkSpeed = 0
            Mon.Humanoid.JumpPower = 0
        end
    end)
end

function IsSkillReady(weaponType, key)
    local plr = game.Players.LocalPlayer
    local toolName = nil
    for _, v in pairs(plr.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == weaponType then toolName = v.Name; break end
    end
    if not toolName then
        for _, v in pairs(plr.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == weaponType then toolName = v.Name; break end
        end
    end
    
    if toolName and plr.PlayerGui:FindFirstChild("Main") and plr.PlayerGui.Main:FindFirstChild("Skills") then
        local weaponFrame = plr.PlayerGui.Main.Skills:FindFirstChild(toolName)
        if weaponFrame then
            local skillFrame = weaponFrame:FindFirstChild(key)
            if skillFrame then
                local titleLabel = skillFrame:FindFirstChild("Title")
                if titleLabel and titleLabel:IsA("TextLabel") then
                    local r = titleLabel.TextColor3.R
                    if r < 0.5 then 
                        return false
                    end
                end
                local cd = skillFrame:FindFirstChild("Cooldown")
                if cd and (cd.Size.X.Scale > 0 or cd.AbsoluteSize.X > 0) then
                    return false
                end
                return true
            end
            return false
        end
    end
    return true
end

Useskills = function(weapon, skill)
  if weapon == "Melee" then
    weaponSc("Melee")
    if not IsSkillReady(weapon, skill) then return end
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    elseif skill == "C" then
      vim1:SendKeyEvent(true, "C", false, game);
      vim1:SendKeyEvent(false, "C", false, game);
    end
  elseif weapon == "Sword" then
    weaponSc("Sword")
    if not IsSkillReady(weapon, skill) then return end
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    end
  elseif weapon == "Blox Fruit" then
    weaponSc("Blox Fruit")
    if not IsSkillReady(weapon, skill) then return end
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    elseif skill == "C" then
      vim1:SendKeyEvent(true, "C", false, game);
      vim1:SendKeyEvent(false, "C", false, game);        
    elseif skill == "V" then
      vim1:SendKeyEvent(true, "V", false, game);
      vim1:SendKeyEvent(false, "V", false, game);
    elseif skill == "F" then
      vim1:SendKeyEvent(true, "F", false, game);
      vim1:SendKeyEvent(false, "F", false, game);
    elseif skill == "Y" then
      vim1:SendKeyEvent(true, "Y", false, game);
      vim1:SendKeyEvent(false, "Y", false, game);
    end
  elseif weapon == "Gun" then
    weaponSc("Gun")
    if not IsSkillReady(weapon, skill) then return end
    if skill == "Z" then
      vim1:SendKeyEvent(true, "Z", false, game);
      vim1:SendKeyEvent(false, "Z", false, game);
    elseif skill == "X" then
      vim1:SendKeyEvent(true, "X", false, game);
      vim1:SendKeyEvent(false, "X", false, game);
    end
  end
  if weapon == "nil" and skill == "Y" then
    vim1:SendKeyEvent(true, "Y", false, game);
    vim1:SendKeyEvent(false, "Y", false, game);
  end
end

local gg = getrawmetatable(game)
local old = gg.__namecall
setreadonly(gg, false)
gg.__namecall = newcclosure(function(...)
  local method = getnamecallmethod()
  local args = {...}    
    if tostring(method) == "FireServer" then
      if tostring(args[1]) == "RemoteEvent" then
        if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
          if (_G.FarmMastery_G and not SoulGuitar) or (_G.FarmMastery_Dev) or (_G.FarmBlazeEM) or (_G.Prehis_Skills) or (_G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials) or (_G.AimMethod and ABmethod == "Aim Player") or (_G.AimMethod and ABmethod == "Nearest Aim") then
            args[2] = MousePos
            return old(unpack(args))
          end
        end
      end
    end
  return old(...)
end)

GetNearestEnemy = function(a)
  local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  local best, bestDist
  for _, v in ipairs(workspace.Enemies:GetChildren()) do
    if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) then
      local hum, root = v:FindFirstChild("Humanoid"), v:FindFirstChild("HumanoidRootPart")
      if hum and root and hum.Health > 0 then
        local d = (root.Position - hrp.Position).Magnitude
        if not bestDist or d < bestDist then best, bestDist = v, d end
      end
    end
  end
  return best, bestDist
end

GetConnectionEnemies = function(a)
  local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  function search(folder)
    local best, bestDist
    for _, v in ipairs(folder:GetChildren()) do
      if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) then
        local hum = v:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 then
          local root = v:FindFirstChild("HumanoidRootPart")
          local d = (hrp and root) and (root.Position - hrp.Position).Magnitude or math.huge
          if not best or d < bestDist then best, bestDist = v, d end
        end
      end
    end
    return best
  end
  return search(workspace.Enemies) or search(replicated)
end

LowCpu = function()
  local decalsyeeted = true
  local g = game
  local w = g.Workspace
  local l = g.Lighting
  local t = w.Terrain
  t.WaterWaveSize = 0
  t.WaterWaveSpeed = 0
  t.WaterReflectance = 0
  t.WaterTransparency = 0
  l.GlobalShadows = false
  l.FogEnd = 9e9
  l.Brightness = 0
  settings().Rendering.QualityLevel = "Level01"
  for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
      v.Material = "Plastic"
      v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
      v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
      v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
      v.BlastPressure = 1
      v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
      v.Enabled = false
    elseif v:IsA("MeshPart") then
      v.Material = "Plastic"
      v.Reflectance = 0
      v.TextureID = 10385902758728957
    end
  end
  for i, e in pairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
      e.Enabled = false
    end
  end
end

CheckF = function()
  if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then return true end
end
CheckBoat = function()
  for i, v in pairs(workspace.Boats:GetChildren()) do
    if tostring(v.Owner.Value) == tostring(plr.Name) then
      return v    
    end;
  end;
  return false
end;
CheckEnemiesBoat = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "FishBoat") and v:FindFirstChild("Health").Value > 0 then
      return true    
    end;
  end;
  return false
end;
CheckPirateGrandBrigade = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade") and v:FindFirstChild("Health").Value > 0 then
      return true
    end
  end
  return false
end
CheckShark = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Shark" and Attack.Alive(v) then
      return true    
    end;
  end;
  return false
end;
CheckTerrorShark = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Terrorshark" and Attack.Alive(v) then
      return true    
    end;
  end;
  return false
end;
CheckPiranha = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if v.Name == "Piranha" and Attack.Alive(v) then
      return true    
    end;
  end;
  return false
end;
CheckFishCrew = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "Fish Crew Member" or v.Name == "Haunted Crew Member") and Attack.Alive(v) then
      return true    
    end;
  end;
  return false
end;
CheckHauntedCrew = function()
  for _,v in pairs(workspace.Enemies:GetChildren()) do
    if (v.Name == "Haunted Crew Member") and Attack.Alive(v) then
      return true    
    end;
  end;
  return false
end;
CheckSeaBeast = function()
  if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
    return true  
  end;
  return false
end;
CheckLeviathan = function()
  if workspace.SeaBeasts:FindFirstChild("Leviathan") then
    return true  
  end;
  return false
end;
UpdStFruit = function()
  for z,x in next, plr.Backpack:GetChildren() do
  StoreFruit = x:FindFirstChild("EatRemote", true)
    if StoreFruit then
      replicated.Remotes.CommF_:InvokeServer("StoreFruit",StoreFruit.Parent:GetAttribute("OriginalName"),
      plr.Backpack:FindFirstChild(x.Name))
    end
  end
end

GetNearestFruit = function()
  local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end
  local best, bestDist
  for _, x1 in pairs(workspace:GetChildren()) do
    if string.find(x1.Name, "Fruit") then
      local handle = x1:FindFirstChild("Handle")
      if handle and handle:IsA("BasePart") then
        local d = (handle.Position - hrp.Position).Magnitude
        if not bestDist or d < bestDist then best, bestDist = handle, d end
      end
    end
  end
  return best
end

collectFruits = function(Succes)
  if Succes then
    local Character = plr.Character
    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _,v1 in pairs(workspace:GetChildren()) do
      if string.find(v1.Name, "Fruit") then
        local handle = v1:FindFirstChild("Handle")
        if handle then handle.CFrame = hrp.CFrame end
      end
    end
  end
end

Getmoon = function()
  if World1 then
    return Lighting.FantasySky.MoonTextureId
  elseif World2 then
    return Lighting.FantasySky.MoonTextureId
  elseif World3 then
    return Lighting.Sky.MoonTextureId
  end
end

DropFruits = function()
  for _,v3 in next, plr.Backpack:GetChildren() do
    if string.find(v3.Name, "Fruit") then
      EquipWeapon(v3.Name) task.wait(.1)
      if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end EquipWeapon(v3.Name) plr.Character:FindFirstChild(v3.Name).EatRemote:InvokeServer("Drop")
    end
  end
  for a,b2 in pairs(plr.Character:GetChildren()) do
    if string.find(b2.Name, "Fruit") then EquipWeapon(b2.Name) task.wait(.1)
    if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end EquipWeapon(b2.Name) plr.Character:FindFirstChild(b2.Name).EatRemote:InvokeServer("Drop")
    end
  end
end

GetBP = function(v)
  return plr.Backpack:FindFirstChild(v) or plr.Character:FindFirstChild(v)
end

local InventoryCache = {t = 0, data = nil}
GetInventoryList = function()
  if InventoryCache.data and tick() - InventoryCache.t < 2 then return InventoryCache.data end
  local inv
  local ok, res = pcall(function() return replicated.Remotes.CommF_:InvokeServer("getInventory") end)
  if ok and type(res) == "table" then inv = res end
  if not inv then
    local ok2, res2 = pcall(function() return replicated.Remotes.CommF_:InvokeServer("getInventoryWeapons") end)
    if ok2 and type(res2) == "table" then inv = res2 end
  end
  inv = inv or {}
  InventoryCache.t = tick()
  InventoryCache.data = inv
  return inv
end

GetIn = function(Name)
  if plr.Character:FindFirstChild(Name) or plr.Backpack:FindFirstChild(Name) then return true end
  for _, v1 in pairs(GetInventoryList()) do
    if type(v1) == "table" and v1.Name == Name then
      return true
    end
  end
  return false
end

GetM = function(Name)
  if Name == "Bones" then
    local okB, bones = pcall(function() return replicated.Remotes.CommF_:InvokeServer("Bones", "Check") end)
    return (okB and tonumber(bones)) or 0
  end
  local ok, qty = pcall(function()
    local id = require(replicated.IdMap).Material[Name]
    if id then return require(replicated.Util.ItemReplication).Quantity.readClient(id) end
  end)
  if ok and tonumber(qty) then return tonumber(qty) end
  for _, tab in pairs(GetInventoryList()) do
    if type(tab) == "table" and tab.Type == "Material" and tab.Name == Name then
      return tab.Count
    end
  end
  return 0
end

GetWP = function(nametool)
  if (plr.Character and plr.Character:FindFirstChild(nametool)) or (plr.Backpack and plr.Backpack:FindFirstChild(nametool)) then
    return true
  end
  for _, v4 in pairs(GetInventoryList()) do
    if type(v4) == "table" and v4.Type == "Sword" and v4.Name == nametool then
      return true
    end
  end
  return false
end

local CDKCache = {t = 0, v = nil}
CDKProgress = function()
  if CDKCache.v and tick() - CDKCache.t < 0.4 then return CDKCache.v end
  local ok, res = pcall(function() return replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress") end)
  if ok and type(res) == "table" then
    CDKCache.v = res
    CDKCache.t = tick()
  end
  return CDKCache.v
end

getgenv().CDKDoorOpenedAt = nil
CDKEnsureDoor = function()
  if getgenv().CDKDoorOpenedAt then return true end
  if tick() - (getgenv().CDKDoorTry or 0) < 1 then return false end
  getgenv().CDKDoorTry = tick()
  local ok, r = pcall(function() return replicated.Remotes.CommF_:InvokeServer("CDKQuest","OpenDoor") end)
  if ok and tostring(r) == "opened" then
    getgenv().CDKDoorOpenedAt = tick()
    return true
  end
  pcall(function() replicated.Remotes.CommF_:InvokeServer("CDKQuest","OpenDoor",true) end)
  return false
end

getInfinity_Ability = function(Method, Var)
  if not Root then return end
  if Method == "Soru" and Var then
    for _,gc in next, getgc() do
      if plr.Character.Soru then
        if ((typeof(gc) == "function") and (getfenv(gc).script == plr.Character.Soru)) then
          for _, v in next, getupvalues(gc) do
            if (typeof(v) == "table") then
              repeat task.wait(Sec) v.LastUse = 0 until not Var or (plr.Character.Humanoid.Health <= 0)
            end
          end
        end
      end
    end    
  elseif Method == "Energy" and Var then
    plr.Character.Energy.Changed:connect(function()
      if Var then plr.Character.Energy.Value = Energy end 
    end)
  elseif Method == "Observation" and Var then
    local VisionRadius = plr.VisionRadius
    VisionRadius.Value = math.huge
  end
end

Hop = function()
  pcall(function()
    for count = math.random(1, math.random(40, 75)), 100 do
      local remote = replicated.__ServerBrowser:InvokeServer(count)
	  for _, v in next, remote do
	  if tonumber(v['Count']) < 12 then TeleportService:TeleportToPlaceInstance(game.PlaceId, _) end
	  end    
    end
  end)
end

local C = Instance.new("Part", workspace);
C.Size = Vector3.new(1, 1, 1);
C.Name = "Rip_Indra";
C.Anchored = true;
C.CanCollide = false;
C.CanTouch = false;
C.Transparency = 1;

for _, old in ipairs(workspace:GetChildren()) do
	if old.Name == C.Name and old ~= C then
		old:Destroy();
	end;
end;

local TPState = {Tween = nil, Target = nil};
getgenv().LastTPCall = 0;

task.spawn(function()
	while task.wait() do
		if C and C.Parent == workspace then
			if shouldTween then
				(getgenv()).OnFarm = true;
			else
				(getgenv()).OnFarm = false;
			end;
		else
			(getgenv()).OnFarm = false;
		end;
	end;
end);

task.spawn(function()
	local I = game.Players.LocalPlayer;
	repeat task.wait() until I.Character and I.Character.PrimaryPart;

	C.CFrame = I.Character.PrimaryPart.CFrame;

	while task.wait() do
		pcall(function()
			if not (C and C.Parent == workspace) then return end;
			local root = I.Character and I.Character.PrimaryPart;
			if (getgenv()).OnFarm then
				if not _G.WasOnFarm then _G.WasOnFarm = true end
				if root then
					if (root.Position - C.Position).Magnitude <= 200 then
						root.CFrame = CFrame.new(C.Position);
					else
						if TPState.Tween then TPState.Tween:Cancel() end;
						TPState.Target = nil;
						C.CFrame = root.CFrame;
					end;
				end;

				local e = I.Character;
				if e then
					for _, v in pairs(e:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = false;
						end;
					end;
				end;

			else
				if TPState.Tween and TPState.Tween.PlaybackState == Enum.PlaybackState.Playing then
					TPState.Tween:Cancel();
				end;
				TPState.Target = nil;
				if root then C.CFrame = root.CFrame end;
				if _G.WasOnFarm then
					_G.WasOnFarm = false
					local e = I.Character;
					if e then
						for _, v in pairs(e:GetChildren()) do
							if v:IsA("BasePart") then
								v.CanCollide = true;
							end;
						end;
					end;
				end
			end;
		end);
	end;
end);

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

sea1 = (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715)
sea2 = (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657)
sea3 = (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089)

local Settings = {
    ["Tween Speed"] = 200,
    ["Bypass Teleport"] = false,
    ["Up Y"] = false,
    ["Up Y When Low Health"] = false,
    ["Same Y"] = false
}

local newdao = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
local cframenpc = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)

function Convert_CFrame(x)
    if not x then return end
    if typeof(x) == "Vector3" then
        return CFrame.new(x)
    elseif typeof(x) == "CFrame" then
        return x
    elseif typeof(x) == "Model" then
        return x:GetPivot()
    elseif x.CFrame then
        return x.CFrame
    end
    return nil
end

function GetDistance(POS_1, POS_2, NO_Y)
    if POS_1 == nil then return 9e9 end
    
    local Character = LocalPlayer.Character
    if not Character then return 9e9 end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return 9e9
    end
    
    if POS_2 == nil then
        POS_2 = Character:FindFirstChild("HumanoidRootPart")
        if not POS_2 then return 9e9 end
    end
    
    local pos1 = Convert_CFrame(POS_1)
    local pos2 = Convert_CFrame(POS_2)
    
    if NO_Y then
        return (Vector3.new(pos1.X, 0, pos1.Z) - Vector3.new(pos2.X, 0, pos2.Z)).Magnitude
    else
        return (pos1.Position - pos2.Position).Magnitude
    end
end

function InArea(POS)
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin then return {Name = ""} end
    
    local pos = Convert_CFrame(POS)
    for i,v in next, WorldOrigin.Locations:GetChildren() do
        if v:FindFirstChild("Mesh") and (pos.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

function GetSpawnPoint(x)
    local Spawns = workspace:FindFirstChild("_WorldOrigin") 
        and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") 
        and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")
    if not Spawns then return end
    
    for i,v in next, Spawns:GetChildren() do
        if v:FindFirstChild("Part") and (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
end

function CheckLegendaryItems()
    function CheckItem(ITEM_NAME)
        for i,v in next, LocalPlayer.Backpack:GetChildren() do
            if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then 
                return v 
            end
        end
        for i,v in next, LocalPlayer.Character:GetChildren() do
            if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then 
                return v 
            end
        end
    end
    
    if CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1") then
        return true
    end
    return false
end

function WaitForHumanoid()
    local Character = LocalPlayer.Character
    if not Character then return nil end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then return Humanoid end
    
    local timeout = tick() + 5
    while tick() < timeout do
        Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then return Humanoid end
        task.wait(0.1)
    end
    return nil
end

function checkinventory(v)
    if v then
        for i, vl in pairs(GetInventoryList()) do
            if type(vl) == "table" and vl.Name == v then
                return true
            end
        end
    end
    return false
end

function getdis(a,b)
    b = b or LocalPlayer.Character.HumanoidRootPart.CFrame
    local _a = CFrame.new(a.X, b.Y, a.Z)
    local _b = CFrame.new(b.X,b.Y,b.Z)
    return (_a.Position - _b.Position).Magnitude
end

function CanBypassTeleport(x)
    local AreaName = InArea(x).Name
    if AreaName == "" then return false end
    
    if not Settings["Bypass Teleport"] 
        or AreaName:find("Dimension") 
        or AreaName:find("Submerged") 
        or AreaName == "Sealed Cavern" 
        or AreaName:lower():find("under") 
        or CheckLegendaryItems() then
        return false
    end
    
    if LocalPlayer.Data and LocalPlayer.Data.LastSpawnPoint and LocalPlayer.Data.LastSpawnPoint.Value == "SubmergedIsland" then 
        return false 
    end
    
    if GetDistance(x.Position) <= 3500 then
        return false
    end
    
    return true
end

function GetBypassCFrame(x)
    local Max = math.huge
    local Pos
    local Spawns = workspace._WorldOrigin.PlayerSpawns.Pirates:GetChildren()
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return nil end
    
    for i,v in next, Spawns do
        if v:FindFirstChild("Part") then
            if (x.Position - HRP.Position).Magnitude >= 3000 
            and GetSpawnPoint(v.Part) ~= GetSpawnPoint(HRP) 
            and (v.Part.Position - HRP.Position).Magnitude <= 10000 
            and (v.Part.Position - x.Position).Magnitude <= Max then
                Max = (v.Part.Position - x.Position).Magnitude
                Pos = v
            end
        end
    end
    return Pos
end

function BypassTP(Target)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = WaitForHumanoid()
    if not Humanoid or Humanoid.Health <= 0 then return end
    
    if CanBypassTeleport(Target) and GetBypassCFrame(Target) then
        local TargetTP = GetBypassCFrame(Target)
        if TargetTP and TargetTP:FindFirstChild("Part") then
            Character.LastSpawnPoint.Disabled = true
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetLastSpawnPoint", TargetTP.Name)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
            Character:PivotTo(TargetTP.Part.CFrame)
            Humanoid:ChangeState(15)
            
            repeat 
                task.wait() 
            until LocalPlayer.Character and WaitForHumanoid() and WaitForHumanoid().Health > 0
        end
    end
end

function totopofgreattree()
    if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741)) > 1500 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741))
        task.wait(0.3)
    end
    
    local targetCF = CFrame.new(28607.5352, 14896.5449, 106.011726)
    _tp(targetCF)
    
    repeat
        task.wait()
    until getdis(targetCF) <= 5
    
    task.wait(0.5)
    for i = 1, 4 do
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
    end
end

function requestentrance(pos)
    local tb = {}
    local targetPos = pos
    
    if typeof(pos) == "CFrame" then
        targetPos = pos.Position
    end
    
    if sea1 then
        tb = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif sea2 then
        tb = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    else
        tb = {
            ["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103),
            ["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793)
        }
        if not checkinventory("Valkyrie Helm") then
            return
        end
    end
    
    local x, y = nil, math.huge
    for i, v in pairs(tb) do
        local distance = (typeof(v) == "Vector3" and (v - targetPos).Magnitude) or (v.Position - targetPos).Magnitude
        if distance < y then
            y = distance
            x = v
        end
    end
    
    if x and y and y < getdis(pos) then
        pcall(function ()
            if _G.TweenCache then
                _G.TweenCache:Cancel()
            end
        end)
        
        if typeof(x) == "Vector3" 
            and x.X == 3024.1709 and x.Y == 2280.69434 and x.Z == -7325.12793
            and ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2 then
            totopofgreattree()
            task.wait(1)
        elseif y < getdis(pos) then
            local requestPos = typeof(x) == "Vector3" and x or x.Position
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", requestPos)
            task.wait(1)
        end
    end
end

_tp = function(target)
    local gg
    if typeof(target) == "Vector3" then
        gg = CFrame.new(target)
    elseif typeof(target) == "CFrame" then
        gg = target
    elseif typeof(target) == "Instance" then
        local ok, cf = pcall(function()
            if target:IsA("Model") then return target:GetPivot() end
            return target.CFrame
        end)
        gg = ok and cf or nil
    end

    if not gg then return end

    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    if not (C and C.Parent == workspace) then return end

    getgenv().LastTPCall = tick()
    shouldTween = true
    getgenv().OnFarm = true

    local running = TPState.Tween and TPState.Tween.PlaybackState == Enum.PlaybackState.Playing
    if running and TPState.Target and (TPState.Target - gg.Position).Magnitude < 1 then
        return TPState.Tween
    end

    -- pcall(function()
    --     if CanBypassTeleport(gg) then
    --         BypassTP(gg)
    --         task.wait(0.5)
    --     end
    -- end)

    -- pcall(function()
    --     requestentrance(gg)
    -- end)

    if sea3 and (getdis(gg.Position, newdao.Position) < 4000 or gg.Position.Y < -1000) then
        local hrp = plr.Character.HumanoidRootPart
        local inSub = (typeof(IsInSubmergedIsland) == "function" and IsInSubmergedIsland()) or (hrp.Position.Y < -1000)
        if not inSub then
            if getdis(cframenpc) > 15 then
                gg = cframenpc
            else
                local net = ReplicatedStorage.Modules.Net
                pcall(function()
                    net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
                    task.wait(0.5)
                    net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                end)
                task.wait(1)
                return
            end
        end
    end

    character = plr.Character
    rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not (C and C.Parent == workspace) then return end

    if TPState.Tween then TPState.Tween:Cancel() end
    C.CFrame = rootPart.CFrame
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Sit == true then
        C.CFrame = CFrame.new(C.Position.X, gg.Y, C.Position.Z)
    end

    local distance = (gg.Position - C.Position).Magnitude
    local speed = distance <= 15 and (getgenv().TweenSpeedNear or 180) or (getgenv().TweenSpeedFar or 150)
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(C, tweenInfo, {CFrame = CFrame.new(gg.Position)})

    TPState.Tween = tween
    TPState.Target = gg.Position
    tween:Play()

    return tween
end

old_tp = function(p) 
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = p 
    end
end

TeleportToTarget = function(targetCFrame)
    local tween = _tp(targetCFrame)
    if tween then
        tween.Completed:Wait()
    end
    task.wait(0.1)
end
notween = function(p) plr.Character.HumanoidRootPart.CFrame = p end

function BTP(p)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character.HumanoidRootPart
    local humanoid = player.Character.Humanoid
    local playerGui = player.PlayerGui.Main
    local targetPosition = p.Position
    local lastPosition = humanoidRootPart.Position
    repeat
        humanoid.Health = 0
        humanoidRootPart.CFrame = p
        playerGui.Quest.Visible = false
        if (humanoidRootPart.Position - lastPosition).Magnitude > 1 then
            lastPosition = humanoidRootPart.Position
            humanoidRootPart.CFrame = p
        end
        task.wait(0.5)
    until (p.Position - humanoidRootPart.Position).Magnitude <= 2000
end

task.spawn(function()
  while task.wait() do
    pcall(function()
      if _G.Auto_StartRaid or _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago  or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or (_G.TPNpc == true) or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or _G.FarmBoss or _G.AutoFarmAllBoss or _G.AutoFishSlap or _G.FarmTyrant or _G.FarmPhaBinh or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoAttackDoughKing or _G.StartEvent or _G.AutoMysticIsland or _G.AutoPlayerHunter or _G.SafeMode or _G.AutoKillMob or _G.AutoStartPrehistoric or _G.AutoUnHaki or _G.AutoAttackRipIndra or _G.AutoFarmIsland or _G.AutoFarmDungeon or _G.AutoFarmCandy or _G.AutoTP_Gift or _G.AutoTPGift or _G.AutoTPAndCollect or _G.MasterAutoLevel or _G.MasterAutoCandy or _G.TPFloor1 or _G.TPFloor2 or _G.TPFloor3 or _G.TPFloor4 or _G.AutoMagnetToken or (tick() - (getgenv().LastTPCall or 0)) < 0.35 then
        shouldTween = true
        if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
          local Noclip = Instance.new("BodyVelocity")
          Noclip.Name = "BodyClip"
          Noclip.Parent = plr.Character.HumanoidRootPart
          Noclip.MaxForce = Vector3.new(100000,100000,100000)
          Noclip.Velocity = Vector3.new(0,0,0)
        end        
      if not plr.Character:FindFirstChild("highlight") then
        local Test = Instance.new("Highlight")
        Test.Name = "highlight"
        Test.Enabled = true
        Test.FillColor = Color3.fromRGB(0,255,254)
        Test.OutlineColor = Color3.fromRGB(0,255,254)
        Test.FillTransparency = 0.5
        Test.OutlineTransparency = 0.2
        Test.Parent = plr.Character
      end
        for _, no in pairs(plr.Character:GetDescendants()) do if no:IsA("BasePart") then no.CanCollide = false end end
      else
        shouldTween = false
        if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy() end
        if plr.Character:FindFirstChild('highlight') then plr.Character:FindFirstChild('highlight'):Destroy() end	        
      end
    end)
  end
end)

QuestB = function()
    if World1 then
        if _G.FindBoss == "The Gorilla King" then
            bMon = "The Gorilla King"
            Qname = "JungleQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
        elseif _G.FindBoss == "Bobby" then
            bMon = "Bobby"
            Qname = "BuggyQuest1"
            Qdata = 3;
            PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
        elseif _G.FindBoss == "The Saw" then
            bMon = "The Saw"
            PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
        elseif _G.FindBoss == "Yeti" then
            bMon = "Yeti"
            Qname = "SnowQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
            PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
        elseif _G.FindBoss == "Mob Leader" then
            bMon = "Mob Leader"
            PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
        elseif _G.FindBoss == "Vice Admiral" then
            bMon = "Vice Admiral"
            Qname = "MarineQuest2"
            Qdata = 2;
            PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
            PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
        elseif _G.FindBoss == "Saber Expert" then
            bMon = "Saber Expert"
            PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564)
        elseif _G.FindBoss == "Warden" then
            bMon = "Warden"
            Qname = "ImpelQuest"
            Qdata = 1;
            PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961)
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Chief Warden" then
            bMon = "Chief Warden"
            Qname = "ImpelQuest"
            Qdata = 2;
            PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939)
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Swan" then
            bMon = "Swan"
            Qname = "ImpelQuest"
            Qdata = 3;
            PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812)
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Magma Admiral" then
            bMon = "Magma Admiral"
            Qname = "MagmaQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
            PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
        elseif _G.FindBoss == "Fishman Lord" then
            bMon = "Fishman Lord"
            Qname = "FishmanQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
        elseif _G.FindBoss == "Wysper" then
            bMon = "Wysper"
            Qname = "SkyExp1Quest"
            Qdata = 3;
            PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094)
            PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
        elseif _G.FindBoss == "Thunder God" then
            bMon = "Thunder God"
            Qname = "SkyExp2Quest"
            Qdata = 3;
            PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
            PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
        elseif _G.FindBoss == "Cyborg" then
            bMon = "Cyborg"
            Qname = "FountainQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
        elseif _G.FindBoss == "Ice Admiral" then
            bMon = "Ice Admiral"
            Qdata = nil;
            PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
            PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
        elseif _G.FindBoss == "Greybeard" then
            bMon = "Greybeard"
            Qdata = nil;
            PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
            PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
        end
    end;
    if World2 then
        if _G.FindBoss == "Diamond" then
            bMon = "Diamond"
            Qname = "Area1Quest"
            Qdata = 3;
            PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
            PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
        elseif _G.FindBoss == "Jeremy" then
            bMon = "Jeremy"
            Qname = "Area2Quest"
            Qdata = 3;
            PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
            PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
        elseif _G.FindBoss == "Orbitus" then
            bMon = "Orbitus"
            Qname = "MarineQuest3"
            Qdata = 3;
            PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031)
            PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
        elseif _G.FindBoss == "Don Swan" then
            bMon = "Don Swan"
            PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
        elseif _G.FindBoss == "Smoke Admiral" then
            bMon = "Smoke Admiral"
            Qname = "IceSideQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
            PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
        elseif _G.FindBoss == "Awakened Ice Admiral" then
            bMon = "Awakened Ice Admiral"
            Qname = "FrostQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)
            PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
        elseif _G.FindBoss == "Tide Keeper" then
            bMon = "Tide Keeper"
            Qname = "ForgottenQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)
            PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
        elseif _G.FindBoss == "Darkbeard" then
            bMon = "Darkbeard"
            Qdata = nil;
            PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
            PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
        elseif _G.FindBoss == "Cursed Captain" then
            bMon = "Cursed Captain"
            Qdata = nil;
            PosQBoss = CFrame.new(916.928589, 181.092773, 33422)
            PosB = CFrame.new(916.928589, 181.092773, 33422)
        elseif _G.FindBoss == "Order" then
            bMon = "Order"
            Qdata = nil;
            PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
            PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
        end
    end;
    if World3 then
        if _G.FindBoss == "Stone" then
            bMon = "Stone"
            Qname = "PiratePortQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
            PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
        elseif _G.FindBoss == "Hydra Leader" then
            bMon = "Hydra Leader"
            Qname = "VenomCrewQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(5211.021484375, 1004.35778859375, 758.1847534179688)
            PosB = CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)
        elseif _G.FindBoss == "Kilo Admiral" then
            bMon = "Kilo Admiral"
            Qname = "MarineTreeIsland"
            Qdata = 3;
            PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938)
            PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
        elseif _G.FindBoss == "Captain Elephant" then
            bMon = "Captain Elephant"
            Qname = "DeepForestIsland"
            Qdata = 3;
            PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875)
            PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
        elseif _G.FindBoss == "Beautiful Pirate" then
            bMon = "Beautiful Pirate"
            Qname = "DeepForestIsland2"
            Qdata = 3;
            PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
            PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
        elseif _G.FindBoss == "Cake Queen" then
            bMon = "Cake Queen"
            Qname = "IceCreamIslandQuest"
            Qdata = 3;
            PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
            PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
        elseif _G.FindBoss == "Longma" then
            bMon = "Longma"
            Qdata = nil;
            PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
            PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
        elseif _G.FindBoss == "Soul Reaper" then
            bMon = "Soul Reaper"
            Qdata = nil;
            PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
            PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
        end
    end
end

QuestBeta = function()
    local Neta = QuestB()
    return {
        [0] = _G.FindBoss,
        [1] = bMon,
        [2] = Qdata,
        [3] = Qname,
        [4] = PosB,
        [5] = PosQBoss,
    }  
end

local Quests = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests"))
local GuideModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule"))

local blacklistquest = {
    "MarineQuest",
    "BartiloQuest",
    "CitizenQuest",
    "Trainees"
}

CheckSea = function(b)
    if (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715) and b == 1 then
        return true
    elseif (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657) and b == 2 then
        return true
    elseif (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089) and b == 3 then
        return true
    end
    return false
end

GetQuestPointFromNPC = function(npcName)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    for _, npc in pairs(replicated.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    return nil
end

GetQuests = function()
    local lvl = plr.Data.Level.Value
    local LevelReq = 0
    local mmb = {}
    
    if lvl >= 700 and CheckSea(1) then
        mmb["Mob"] = "Galley Captain"
        mmb["NameQuest"] = "FountainQuest"
        mmb["ID"] = 2
        mmb["LevelReq"] = 700
    elseif lvl >= 1500 and CheckSea(2) then
        mmb["Mob"] = "Water Fighter"
        mmb["NameQuest"] = "ForgottenQuest"
        mmb["ID"] = 2
        mmb["LevelReq"] = 1450
    else
        for r, v in pairs(Quests) do
            for id, v1 in pairs(v) do
                local LvReq = v1.LevelReq
                for nguoi, tinh in pairs(v1.Task) do
                    if lvl >= LvReq and LevelReq <= LvReq and v1.Task[nguoi] > 1 and not table.find(blacklistquest, r) then
                        LevelReq = LvReq
                        mmb["Mob"] = nguoi
                        mmb["NameQuest"] = r
                        mmb["ID"] = id
                        mmb["LevelReq"] = LvReq
                    end
                end
            end
        end
    end
    
    return mmb
end

GetQuestPoint = function()
    if GuideModule and GuideModule.Data and GuideModule.Data.LastClosestNPC then
        return GetQuestPointFromNPC(GuideModule.Data.LastClosestNPC)
    end
    return nil
end

MaterialMon=function()
    local a=game.Players.LocalPlayer;
    local b=a.Character and a.Character:FindFirstChild("HumanoidRootPart")
    if not b then return end;
    shouldRequestEntrance=function(c,d)
        local e=(b.Position-c).Magnitude;
        if e>=d then replicated.Remotes.CommF_:InvokeServer("requestEntrance",c)end 
    end;
    if World1 then 
        if SelectMaterial=="Angel Wings"then MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}MPos=CFrame.new(-4698,845,-1912)SP="Default"local c=Vector3.new(-4607.82275,872.54248,-1667.55688)shouldRequestEntrance(c,10000)
        elseif SelectMaterial=="Leather + Scrap Metal"then MMon={"Brute","Pirate"}MPos=CFrame.new(-1145,15,4350)SP="Default"
        elseif SelectMaterial=="Magma Ore"then MMon={"Military Soldier","Military Spy","Magma Admiral"}MPos=CFrame.new(-5815,84,8820)SP="Default"
        elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"}MPos=CFrame.new(61123,19,1569)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,17000)end 
    elseif World2 then 
        if SelectMaterial=="Leather + Scrap Metal"then MMon={"Marine Captain"}MPos=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375)SP="Default"
        elseif SelectMaterial=="Magma Ore"then MMon={"Magma Ninja","Lava Pirate"}MPos=CFrame.new(-5428,78,-5959)SP="Default"
        elseif SelectMaterial=="Ectoplasm"then MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}MPos=CFrame.new(911.35827636719,125.95812988281,33159.5390625)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,18000)
        elseif SelectMaterial=="Mystic Droplet"then MMon={"Water Fighter"}MPos=CFrame.new(-3385,239,-10542)SP="Default"
        elseif SelectMaterial=="Radioactive Material"then MMon={"Factory Staff"}MPos=CFrame.new(295,73,-56)SP="Default"
        elseif SelectMaterial=="Vampire Fang"then MMon={"Vampire"}MPos=CFrame.new(-6033,7,-1317)SP="Default"end 
    elseif World3 then 
        if SelectMaterial=="Scrap Metal"then MMon={"Jungle Pirate","Forest Pirate"}MPos=CFrame.new(-11975.78515625,331.7734069824219,-10620.0302734375)SP="Default"
        elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Raider","Fishman Captain"}MPos=CFrame.new(-10993,332,-8940)SP="Default"
        elseif SelectMaterial=="Conjured Cocoa"then MMon={"Chocolate Bar Battler","Cocoa Warrior"}MPos=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625)SP="Default"
        elseif SelectMaterial=="Dragon Scale"then MMon={"Dragon Crew Archer","Dragon Crew Warrior"}MPos=CFrame.new(6594,383,139)SP="Default"
        elseif SelectMaterial=="Gunpowder"then MMon={"Pistol Billionaire"}MPos=CFrame.new(-84.8556900024414, 85.62061309814453, 6132.0087890625)SP="Default"
        elseif SelectMaterial=="Mini Tusk"then MMon={"Mythological Pirate"}MPos=CFrame.new(-13545,470,-6917)SP="Default"
        elseif SelectMaterial=="Demonic Wisp"then MMon={"Demonic Soul"}MPos=CFrame.new(-9495.6806640625,453.58624267578125,5977.3486328125)SP="Default"end 
    end 
end

QuestNeta = function()
    local questData = GetQuests()
    return {
        [1] = questData.Mob,           
        [2] = questData.ID,             
        [3] = questData.NameQuest,      
        [4] = questData.LevelReq,       
        [5] = questData.Mob,             
        [6] = GetQuestPoint()            
    }
end

-- ====================================================================
-- AUTOMATION HELPERS & BACKGROUND LOOPS (from original script)
-- ====================================================================

alreadyTeleported = false
teleporting = false

_G.CheckQuestVisible = function(p)
    p = p or game.Players.LocalPlayer
    local qUI = p.PlayerGui:FindFirstChild("Main") and p.PlayerGui.Main:FindFirstChild("Quest")
    local tUI = p.PlayerGui:FindFirstChild("TrackedQuestFrame")
    
    if qUI and qUI.Visible then
        local title = ""
        pcall(function() title = qUI.Container.QuestTitle.Title.Text end)
        return true, title
    elseif tUI and tUI.Enabled then
        local txt = ""
        pcall(function() txt = tUI.Frame.header.textLabel.Text end)
        if txt == "" then pcall(function() txt = tUI.Frame.header.textLabel.textLabel.Text end) end
        return true, txt
    end
    return false, ""
end

function IsInSubmergedIsland()
    local char = plr.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    return hrp.Position.Y < -1000
end

function GuiNode(...)
    local plr = game.Players.LocalPlayer
    local gui = plr.PlayerGui:FindFirstChild("Main")
    if not gui then return nil end
    local node = gui
    for _, name in ipairs({ ... }) do
        if not node then return nil end
        node = node:FindFirstChild(name)
    end
    return node
end

function GuiShown(...)
    if select('#', ...) == 1 and select(1, ...) == "Quest" then
        local plr = game.Players.LocalPlayer
        local tracked = plr.PlayerGui:FindFirstChild("TrackedQuestFrame")
        if tracked then
            local frame = tracked:FindFirstChild("Frame")
            if frame then
                return tracked.Enabled and frame.Visible
            end
        end
    end
    local node = GuiNode(...)
    return node ~= nil and node.Visible == true
end

function QuestText()
    local plr = game.Players.LocalPlayer
    local tracked = plr.PlayerGui:FindFirstChild("TrackedQuestFrame")
    if tracked then
        local frame = tracked:FindFirstChild("Frame")
        if frame and frame.Visible then
            local header = frame:FindFirstChild("header")
            local title = header and header:FindFirstChild("textLabel")
            if title and title:IsA("TextLabel") then
                return tostring(title.Text)
            end
        end
    end
    local node = GuiNode("Quest", "Container", "QuestTitle", "Title")
    if node then
        return tostring(node.Text)
    end
    return ""
end

function CheckHasQuest(npcName)
    if not npcName then return false end
    if not GuiShown("Quest") then return false end
    local qtext = QuestText()
    if qtext == "" then return false end
    return string.find(string.lower(qtext), string.lower(npcName), 1, true) ~= nil
end

function BFAcceptQuest(questName, questTier, npcName)
    if CheckHasQuest(npcName) then return true end

    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
    if not remote then return false end

    local success, result = pcall(function()
        return remote:InvokeServer("StartQuest", questName, questTier)
    end)

    if not success then
        return false
    end

    local deadline = os.clock() + 3
    repeat
        if CheckHasQuest(npcName) then return true end
        task.wait(0.25)
    until os.clock() >= deadline

    return CheckHasQuest(npcName)
end

-- Weapon auto selector loop
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ChooseWP == "Melee" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Gun" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                    end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _,v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                    end
                end
            end
        end)
    end
end)

-- Auto Farm Nearest loop
task.spawn(function()
  while task.wait() do
    pcall(function()
      if _G.AutoFarmNear then
        for i,v in pairs(workspace.Enemies:GetChildren()) do
          if v:FindFirstChild("Humanoid") or v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
              repeat task.wait() Attack.Kill(v,_G.AutoFarmNear) until not _G.AutoFarmNear or not v.Parent or v.Humanoid.Health <= 0
            end
          end
        end
      end
    end)
  end
end)

-- Auto Factory Raid loop
task.spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.AutoFactory then
        local v = GetConnectionEnemies("Core")
        if v then
          repeat task.wait()
            EquipWeapon(_G.SelectWeapon)
            _tp(CFrame.new(448.46756, 199.356781, -441.389252))
          until v.Humanoid.Health <= 0 or _G.AutoFactory == false
        else
          _tp(CFrame.new(448.46756, 199.356781, -441.389252))
        end
      end
    end)
  end
end)

-- Auto Pirate Castle Raid loop
task.spawn(function()
  local CFrameCastleRaid = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
  local CastleCenter = Vector3.new(-5539.3115234375, 313.800537109375, -2972.372314453125)
  while task.wait(Sec) do
    if _G.AutoRaidCastle then
      pcall(function()
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if (CastleCenter - hrp.Position).Magnitude <= 500 then
          local target, bestDist
          for _, v in pairs(workspace.Enemies:GetChildren()) do
            local hum, vroot = v:FindFirstChild("Humanoid"), v:FindFirstChild("HumanoidRootPart")
            if hum and vroot and hum.Health > 0 and (vroot.Position - CastleCenter).Magnitude <= 700 then
              local d = (vroot.Position - hrp.Position).Magnitude
              if not bestDist or d < bestDist then target, bestDist = v, d end
            end
          end
          if target then
            local giveUp = tick() + 30
            repeat task.wait() Attack.Kill(target,_G.AutoRaidCastle) until not _G.AutoRaidCastle or not target.Parent or target.Humanoid.Health <= 0 or tick() > giveUp
          else
            _tp(CFrameCastleRaid)
          end
        else
          _tp(CFrameCastleRaid)
        end
      end)
    end
  end
end)

-- Auto Ectoplasm loop
task.spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.AutoEctoplasm then
        local EctoTable = {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"}    
        local v = GetConnectionEnemies(EctoTable)
		if Attack.Alive(v) then
		  repeat task.wait() Attack.Kill(v, _G.AutoEctoplasm)until not _G.AutoEctoplasm or not v.Parent or v.Humanoid.Health <= 0		        
	    else
	      replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
	    end
      end
    end)
  end
end)

-- Auto Chest (Tween) loop
task.spawn(function()
  while task.wait(Sec) do
    if _G.AutoFarmChest then
      pcall(function()
        local CollectionService = game:GetService("CollectionService")
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()                
        if not Character then return end                
        local Position = Character:GetPivot().Position
        local Chests = CollectionService:GetTagged("_ChestTagged")      
        local Distance, Nearest = math.huge, nil  
        for i = 1, #Chests do
          local Chest = Chests[i]
          local Magnitude = (Chest:GetPivot().Position - Position).Magnitude        
          if not SelectedIsland or Chest:IsDescendantOf(SelectedIsland) then
            if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
              Distance = Magnitude
              Nearest = Chest
            end
          end
        end
      if Nearest then _tp(Nearest:GetPivot()) end
      end)
    end
  end
end)

-- Stop When Chalice loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
            pcall(function()
                if GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
                    _G.AutoFarmChest = false
                    _G.AutoChestBP = false
                end
            end)
        end
    end
end)

-- Auto Farm Berry loop
task.spawn(function()
  while task.wait(Sec) do
    if _G.AutoBerry then
      local CollectionService= game:GetService("CollectionService")
      local Players= game:GetService("Players")
      local Player = Players.LocalPlayer
      local BerryBush = CollectionService:GetTagged("BerryBush")      
      for i = 1, #BerryBush do
        local Bush = BerryBush[i]        
        for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
          if not BerryArray or table.find(BerryArray, BerryName) then           
            _tp(Bush.Parent:GetPivot())
            for i = 1, #BerryBush do
            local Bush = BerryBush[i]        
              for AttributeName, BerryName in pairs(Bush:GetChildren()) do
                if not BerryArray or table.find(BerryArray, BerryName) then
                  _tp(BerryName.WorldPivot)
                  fireproximityprompt(BerryName.ProximityPrompt,math.huge)
                end
              end
            end      
          end
        end
      end      
    end
  end
end)

-- Auto Farm Berry + Hop loop
task.spawn(function()
    while task.wait(Sec) do
        if _G.AutoBerryH then
            local CollectionService = game:GetService("CollectionService")
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local BerryBush = CollectionService:GetTagged("BerryBush")

            if #BerryBush == 0 then
                local TeleportService = game:GetService("TeleportService")
                local ServerList = {}
                local Success, Error = pcall(function()
                    ServerList = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                end)
                if Success and ServerList.data then
                    for _, Server in pairs(ServerList.data) do
                        if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                            break
                        end
                    end
                end
            else
                for i = 1, #BerryBush do
                    local Bush = BerryBush[i]
                    for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
                        if not BerryArray or table.find(BerryArray, BerryName) then
                            _tp(Bush.Parent:GetPivot())
                            for j = 1, #BerryBush do
                                local Bush2 = BerryBush[j]
                                for _, BerryChild in pairs(Bush2:GetChildren()) do
                                    if not BerryArray or table.find(BerryArray, BerryChild.Name) then
                                        _tp(BerryChild.WorldPivot)
                                        fireproximityprompt(BerryChild.ProximityPrompt, math.huge)
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

-- Auto Kill Mob loop
task.spawn(function()
    while task.wait() do
        if _G.AutoKillMob then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectMob) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == getgenv().SelectMob then
                            if v:FindFirstChild("Humanoid")
                            and v:FindFirstChild("HumanoidRootPart")
                            and v.Humanoid.Health > 0 then                                
                                repeat
                                    game:GetService("RunService").Heartbeat:Wait()
                                    Attack.Kill(v,_G.AutoKillMob)
                                until not _G.AutoKillMob or not v.Parent or v.Humanoid.Health <= 0                                
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- All Island Database
Sea1_Islands = {
    ["Pirates"] = {
        CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
        Mobs = {"Bandit"}
    },
    ["Marine"] = {
        CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
        Mobs = {"Trainee"}
    },
    ["Jungle"] = {
        CFrame = CFrame.new(-1600, 36, 150),
        Mobs = {"Monkey", "Gorilla"}
    },
    ["Pirate Village"] = {
        CFrame = CFrame.new(-1100, 4, 3850),
        Mobs = {"Pirate", "Brute"}
    },
    ["Desert"] = {
        CFrame = CFrame.new(1090, 7, 4370),
        Mobs = {"Desert Bandit", "Desert Officer"}
    },
    ["Frozen Village"] = {
        CFrame = CFrame.new(1200, 28, -1500),
        Mobs = {"Snow Bandit", "Snowman"}
    },
    ["Marine Fortress"] = {
        CFrame = CFrame.new(-4500, 20, 4250),
        Mobs = {"Chief Petty Officer"}
    },
    ["Skylands Lower"] = {
        CFrame = CFrame.new(-5000, 700, -2500),
        Mobs = {"Sky Bandit", "Dark Master"}
    },
    ["Prison"] = {
        CFrame = CFrame.new(4875, 6, 735),
        Mobs = {"Prisoner", "Dangerous Prisoner"}
    },
    ["Colosseum"] = {
        CFrame = CFrame.new(-1500, 60, -290),
        Mobs = {"Toga Warrior", "Gladiator"}
    },
    ["Magma Village"] = {
        CFrame = CFrame.new(-5200, 8, 8400),
        Mobs = {"Military Soldier", "Military Spy"}
    },
    ["Underwater City"] = {
        CFrame = CFrame.new(61160, 5, 1819),
        Mobs = {"Fishman Warrior", "Fishman Commando"}
    },
    ["Skylands Upper"] = {
        CFrame = CFrame.new(-7880, 5545, -380),
        Mobs = {"God's Guard", "Shanda", "Royal Squad", "Royal Soldier"}
    },
    ["Fountain City"] = {
        CFrame = CFrame.new(5258, 38, 4050),
        Mobs = {"Galley Pirate", "Galley Captain"}
    }
}
Core.Sea1_Islands = Sea1_Islands
getgenv().Sea1_Islands = Sea1_Islands

Sea2_Islands = {
    ["Kingdom of Rose"] = {
        CFrame = CFrame.new(600, 73, 1000),
        Mobs = {"Raider", "Mercenary", "Swan Pirate", "Factory Staff"}
    },
    ["Green Zone"] = {
        CFrame = CFrame.new(-2400, 73, -2700),
        Mobs = {"Marine Lieutenant", "Marine Captain"}
    },
    ["Graveyard Island"] = {
        CFrame = CFrame.new(-5500, 8, -700),
        Mobs = {"Zombie", "Vampire"}
    },
    ["Snow Mountain"] = {
        CFrame = CFrame.new(600, 400, -5300),
        Mobs = {"Snow Trooper", "Winter Warrior"}
    },
    ["Hot and Cold (Cold)"] = {
        CFrame = CFrame.new(-6000, 15, -4500),
        Mobs = {"Lab Subordinate", "Horned Warrior"}
    },
    ["Hot and Cold (Hot)"] = {
        CFrame = CFrame.new(-5400, 15, -5900),
        Mobs = {"Magma Ninja", "Lava Pirate"}
    },
    ["Cursed Ship"] = {
        CFrame = CFrame.new(923, 126, 32852),
        Mobs = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}
    },
    ["Ice Castle"] = {
        CFrame = CFrame.new(5500, 28, -6800),
        Mobs = {"Arctic Warrior", "Snow Lurker"}
    },
    ["Forgotten Island"] = {
        CFrame = CFrame.new(-3050, 237, -10150),
        Mobs = {"Sea Soldier", "Water Fighter"}
    }
}
Core.Sea2_Islands = Sea2_Islands
getgenv().Sea2_Islands = Sea2_Islands

Sea3_Islands = {
    ["Port Town"] = {
        CFrame = CFrame.new(-290, 7, 5300),
        Mobs = {"Pirate Millionaire", "Pistol Billionaire"}
    },
    ["Hydra Island"] = {
        CFrame = CFrame.new(5700, 600, 200),
        Mobs = {"Dragon Crew Warrior", "Dragon Crew Archer", "Female Islander", "Giant Islander"}
    },
    ["Great Tree"] = {
        CFrame = CFrame.new(2300, 25, -6400),
        Mobs = {"Marine Commodore", "Marine Rear Admiral"}
    },
    ["Floating Turtle"] = {
        CFrame = CFrame.new(-12500, 330, -7500),
        Mobs = {"Fishman Raider", "Fishman Captain", "Forest Pirate", "Mythological Pirate", "Jungle Pirate", "Musketeer Pirate"}
    },
    ["Haunted Castle"] = {
        CFrame = CFrame.new(-9500, 140, 5500),
        Mobs = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
    },
    ["Sea of Treats"] = {
        CFrame = CFrame.new(-2100, 38, -12000),
        Mobs = {"Peanut Scout", "Peanut President", "Ice Cream Chef", "Ice Cream Commander", "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker", "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief", "Candy Rebel", "Candy Pirate", "Snow Demon"}
    },
    ["Tiki Outpost"] = {
        CFrame = CFrame.new(-16200, 90, -17300),
        Mobs = {"Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Isle Champion"}
    },
    ["Submerged Island"] = {
        CFrame = CFrame.new(-3200, -10, -10000),
        Mobs = {"Reef Bandit", "Coral Pirate", "Sea Chanter", "Ocean Prophet", "High Disciple", "Grand Devotee"}
    }
}
Core.Sea3_Islands = Sea3_Islands
getgenv().Sea3_Islands = Sea3_Islands

-- Core.Island: auto-selects island table based on current world
Core.Island = World1 and Sea1_Islands or World2 and Sea2_Islands or World3 and Sea3_Islands or {}
IslandData = Core.Island
getgenv().IslandData = IslandData

Core.GetMobs = function()
    local mobs = {}
    local islandSource = IslandData or Core.Island or (World1 and Sea1_Islands or World2 and Sea2_Islands or World3 and Sea3_Islands) or {}
    for _, island in pairs(islandSource) do
        if island.Mobs then
            for _, mob in ipairs(island.Mobs) do
                if not table.find(mobs, mob) then
                    table.insert(mobs, mob)
                end
            end
        end
    end
    table.sort(mobs)
    return mobs
end
getgenv().GetMobs = Core.GetMobs

-- Auto Farm All Island loop
task.spawn(function()
    while task.wait(0.2) do
        if not _G.AutoFarmIsland then continue end
        if not _G.SelectIsland then continue end
        if not IslandData then continue end

        local island = IslandData[_G.SelectIsland]
        if not island then continue end

        local islandPos = island.CFrame
        local mobs = island.Mobs

        local MobMap = {}
        for _, name in ipairs(mobs) do
            MobMap[name] = true
        end

        local found = false

        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if MobMap[v.Name]
            and v:FindFirstChild("Humanoid")
            and v:FindFirstChild("HumanoidRootPart")
            and v.Humanoid.Health > 0 then

                found = true
                repeat
                    task.wait()
                    _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                    Attack.Kill(v, true)
                until not _G.AutoFarmIsland
                   or not v.Parent
                   or v.Humanoid.Health <= 0
            end
        end

        if not found then
            _tp(islandPos)
        end
    end
end)

-- Auto Farm Elite Hunter loop
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.FarmEliteHunt then
                local questVisible = GuiShown("Quest")
                local questTitle = QuestText()

                if not questVisible then
                    local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
                    if result == nil or string.find(tostring(result), "Cooldown") then
                        task.wait(10)
                        return
                    end
                    task.wait(1)
                else
                    local eliteName = nil
                    for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
                        if string.find(questTitle, name) then
                            eliteName = name
                            break
                        end
                    end

                    if eliteName then
                        local boss = nil

                        for _, v in pairs(replicated:GetChildren()) do
                            if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then
                                boss = v
                                break
                            end
                        end
                        if not boss then
                            for _, v in pairs(Enemies:GetChildren()) do
                                if v.Name == eliteName and Attack.Alive(v) then
                                    boss = v
                                    break
                                end
                            end
                        end

                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            repeat
                                task.wait()
                                Attack.Kill(boss, _G.FarmEliteHunt)
                            until not _G.FarmEliteHunt or not boss.Parent or boss.Humanoid.Health <= 0 or not GuiShown("Quest")
                        else
                            task.wait(5)
                        end
                    else
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            end
        end)
    end
end)

-- Auto Hop Server function
function HopServer()
	local Http = game:GetService("HttpService")
	local TPS = game:GetService("TeleportService")
	local PlaceID = game.PlaceId
	local Cursor = ""
	local foundServer = false

	repeat
		local success, result = pcall(function()
			return game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. Cursor)
		end)
		if success and result then
			local data = Http:JSONDecode(result)
			if data.data then
				for _, v in pairs(data.data) do
					if v.playing < v.maxPlayers and v.id ~= game.JobId then
						foundServer = true
						TPS:TeleportToPlaceInstance(PlaceID, v.id)
						break
					end
				end
				Cursor = data.nextPageCursor or ""
			end
		end
	until not Cursor or foundServer
end

-- Auto Farm Elite + Hop loop
task.spawn(function()
	while task.wait(1) do
		pcall(function()
			if _G.FarmEliteH then
				local questVisible = GuiShown("Quest")
				local questTitle = QuestText()
				
				if not questVisible then
					local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
					if result == nil or string.find(tostring(result), "Cooldown") then
						HopServer()
						return
					end
					task.wait(1)
				else
					local eliteName = nil
					for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
						if string.find(questTitle, name) then
							eliteName = name
							break
						end
					end

					if eliteName then
						local boss = nil
						for _, v in pairs(replicated:GetChildren()) do
							if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then
								boss = v
								break
							end
						end
						for _, v in pairs(workspace.Enemies:GetChildren()) do
							if v.Name == eliteName and Attack.Alive(v) then
								boss = v
								break
							end
						end

						if boss and boss:FindFirstChild("HumanoidRootPart") then
							_tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							repeat
								task.wait()
								Attack.Kill(boss, _G.FarmEliteH)
							until not _G.FarmEliteH or not boss.Parent or boss.Humanoid.Health <= 0 or not GuiShown("Quest")
						else
							task.wait(5)
							HopServer()
						end
					else
						replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
					end
				end
			end
		end)
	end
end)

-- Auto Attack Rip Indra loop
task.spawn(function()
  local ArenaEntrance = Vector3.new(-5097.93164, 316.447021, -3142.66602)
  local ArenaCF = CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781)
  local lastEntrance = 0
  while task.wait(Sec) do
    pcall(function()
      if _G.AutoRipIngay then
        local v = GetConnectionEnemies({"rip_indra", "rip_indra True Form"})
        if v then
          local giveUp = tick() + 120
          repeat task.wait() Attack.Kill(v,_G.AutoRipIngay) until not _G.AutoRipIngay or not v.Parent or v.Humanoid.Health <= 0 or tick() > giveUp
        else
          local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
          if hrp and (hrp.Position - ArenaCF.Position).Magnitude > 400 and tick() - lastEntrance > 5 then
            lastEntrance = tick()
            replicated.Remotes.CommF_:InvokeServer("requestEntrance", ArenaEntrance)
            task.wait(.1)
          end
          _tp(ArenaCF)
        end
      end
    end)
  end
end)

-- Auto Unlock Haki / AuraSkin helpers
AuraSkin = function(HakiID)
  local args = {[1] = {["StorageName"] = HakiID,["Type"] = "AuraSkin",["Context"] = "Equip"}};
  replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer(unpack(args));
end;
VaildColor = function(Part)
  if Part and Part.BrickColor then return (tostring(Part.BrickColor) == "Lime green") end;
end;
HakiCalculate = function(Part)
  local ID = {["Really red"] = "Pure Red";["Oyster"] = "Snow White";["Hot pink"] = "Winter Sky";};
  if Part and Part.BrickColor then return (ID[tostring(Part.BrickColor)])end;
end;

task.spawn(function()
  while task.wait(Sec) do
    if _G.AutoUnHaki then
      pcall(function()
        local Summoner = workspace.Map["Boat Castle"]:FindFirstChild("Summoner");
        if Summoner and Summoner:FindFirstChild("Circle") then 
          for i,v in pairs(Summoner:FindFirstChild("Circle"):GetChildren()) do 
            if v.Name == "Part" then 
            local TogglesPart = v:FindFirstChild("Part");
              if VaildColor(TogglesPart) == false then 
                AuraSkin(HakiCalculate(v));
                repeat task.wait() _tp(v.CFrame) until VaildColor(TogglesPart) == true or not _G.AutoUnHaki;
              end
            end            
          end
        end        
      end)
    end
  end
end)

-- Auto Cake Prince loop
task.spawn(function()
    while task.wait() do
        if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
            pcall(function()
                local player = game.Players.LocalPlayer
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local enemies = workspace.Enemies
                local cakeMap = workspace.Map:FindFirstChild("CakeLoaf")
                local bigMirror = cakeMap and cakeMap:FindFirstChild("BigMirror")
                if not root then return end

                if _G.AcceptQuestC and not _G.CheckQuestVisible(player) then
                    local questPos = CFrame.new(-1927.92, 37.8, -12842.54)
                    _tp(questPos)
                    while (questPos.Position - root.Position).Magnitude > 50 do
                        task.wait(0.2)
                    end
                    local randomQuest = math.random(1, 4)
                    local questData = {
                        [1] = {"StartQuest", "CakeQuest2", 2},
                        [2] = {"StartQuest", "CakeQuest2", 1},
                        [3] = {"StartQuest", "CakeQuest1", 1},
                        [4] = {"StartQuest", "CakeQuest1", 2}
                    }
                    pcall(function()
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[randomQuest]))
                    end)
                end

                if not cakeMap then
                    _tp(CFrame.new(-2077, 252, -12373))
                    task.wait(2)
                    return
                end

                if bigMirror and (bigMirror.Other.Transparency == 0 or enemies:FindFirstChild("Cake Prince")) then
                    local boss = GetConnectionEnemies("Cake Prince")
                    if boss then
                        repeat task.wait()
                            Attack.Kill2(boss, _G.Auto_Cake_Prince)
                        until not _G.Auto_Cake_Prince or not boss.Parent or boss.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(-2151.82, 149.32, -12404.91))
                    end
                else
                    local CakeMobs = {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}
                    local mob = GetConnectionEnemies(CakeMobs)
                    if mob then
                        repeat task.wait()
                            Attack.Kill(mob, _G.Auto_Cake_Prince)
                        until not _G.Auto_Cake_Prince or not mob.Parent or mob.Humanoid.Health <= 0 or (bigMirror and bigMirror.Other.Transparency == 0)
                    else
                        _tp(CFrame.new(-2077, 252, -12373))
                    end
                end
            end)
        end
    end
end)

-- Auto Summon Cake Prince loop
task.spawn(function()
    while task.wait(2) do
        if _G.AutoSpawnCP then
            pcall(function()
                local CommF = game.ReplicatedStorage.Remotes.CommF_
                local enemies = workspace.Enemies
                local bigMirror = workspace.Map.CakeLoaf:FindFirstChild("BigMirror")
                if not bigMirror then return end
                if enemies:FindFirstChild("Cake Prince") then return end
                if bigMirror.Other.Transparency == 0 then return end

                CommF:InvokeServer("CakePrinceSpawner", true)
            end)
        end
    end
end)

-- Auto Dough King Fully loop
task.spawn(function()
    while task.wait() do
        if _G.AutoDoughKing then
            pcall(function()
                if not workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        replicated.Remotes.CommF_:InvokeServer("CakeScientist", "Check")
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
                    end
                elseif workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        repeat
                            task.wait()
                            _tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363,0.149007782, -1.87902192e-08, 0.98883605,3.60619588e-08, 1, 1.35681812e-08,-0.98883605, 3.36376011e-08, 0.149007782))
                        until not getgenv().AutoDoughKing or (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363,0.149007782, -1.87902192e-08, 0.98883605,3.60619588e-08, 1, 1.35681812e-08,-0.98883605, 3.36376011e-08, 0.149007782)).Magnitude <= 5
                        EquipWeapon("Red Key")
                    end
                elseif GetConnectionEnemies("Dough King") then
                    local v = GetConnectionEnemies("Dough King")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.AutoDoughKing)
                        until not _G.AutoDoughKing or not v.Parent or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375))
                    end
                end
                if GetBP("Sweet Chalice") then
                    replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
                    _G.AutoAttackDoughKing = true
                else
                    _G.AutoAttackDoughKing = false
                end
                if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then
                    replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
                end
                if not plr.Backpack:FindFirstChild("God's Chalice")
                    or plr.Character:FindFirstChild("God's Chalice")
                then
                    _G.FarmEliteHunt = true
                else
                    _G.FarmEliteHunt = false
                end
                if GetM("Conjured Cocoa") <= 10 then
                    local v = GetConnectionEnemies{"Cocoa Warrior", "Chocolate Bar Battler"}
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.AutoDoughKing)
                        until _G.AutoDoughKing == false or not v.Parent or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(402.7189025878906, 81.06050109863281, -12259.54296875))
                    end
                end
            end)
        end
    end
end)

-- Auto Attack Dough King loop
task.spawn(function()
    while task.wait() do
        if _G.AutoAttackDoughKing then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat 
                        task.wait()
                        Attack.Kill(v,_G.AutoAttackDoughKing)
                    until not _G.AutoAttackDoughKing or not v.Parent or v.Humanoid.Health <= 0
                else
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
                end
            end)
        end
    end
end)

-- Auto Hop Dough King loop
task.spawn(function()
    while task.wait() do
        if _G.AutoHop_Dough then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat 
                        task.wait()
                        Attack.Kill(v, _G.AutoHop_Dough)
                    until not _G.AutoHop_Dough or not v.Parent or v.Humanoid.Health <= 0
                else
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
                    task.wait(2)
                    HopServer()
                end
            end)
        end
    end
end)

-- Auto Farm Bone loop
task.spawn(function()
    local player = game.Players.LocalPlayer
    local BonesTable = {
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Posessed Mummy"
    }
    local HauntedQuests = {
        {"HauntedQuest1", 1, "Reborn Skeleton", 1975},
        {"HauntedQuest1", 2, "Living Zombie", 2000},
        {"HauntedQuest2", 1, "Demonic Soul", 2025},
        {"HauntedQuest2", 2, "Posessed Mummy", 2050}
    }
    local BoneAreas = {
        CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125),
        PosMsList["Reborn Skeleton"],
        PosMsList["Living Zombie"],
        PosMsList["Demonic Soul"]
    }
    local areaIdx, arrivedAt = 1, nil

    function QuestWantedMob()
        local ok, text = pcall(function()
            local q = player.PlayerGui.Main.Quest
            if not q.Visible then return nil end
            return q.Container.QuestTitle.Title.Text
        end)
        if not ok or not text then return nil end
        text = string.lower(text)
        for _, q in ipairs(HauntedQuests) do
            local n = string.lower(q[3])
            if string.find(text, string.sub(n, 1, #n - 1), 1, true) then return q[3] end
        end
        return nil
    end

    while task.wait(0.5) do
        if not _G.AutoFarm_Bone then continue end

        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if _G.AcceptQuestB and not _G.CheckQuestVisible(player) then
                local questPos = CFrame.new(-9516.99316,172.01718,6078.46533)
                local giveUp = tick() + 45

                repeat
                    _tp(questPos)
                    task.wait(0.5)
                    root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                until not _G.AutoFarm_Bone
                   or not root
                   or (questPos.Position - root.Position).Magnitude <= 50
                   or tick() > giveUp

                if not _G.AutoFarm_Bone or not root or (questPos.Position - root.Position).Magnitude > 50 then return end

                local level = player.Data.Level.Value
                local eligible = {}
                for _, q in ipairs(HauntedQuests) do
                    if level >= q[4] then table.insert(eligible, q) end
                end
                if #eligible > 0 then
                    local q = eligible[math.random(1, #eligible)]
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", q[1], q[2])
                end
            end

            local wanted = QuestWantedMob()
            local bone = GetNearestEnemy(wanted and {wanted} or BonesTable)

            if bone then
                arrivedAt = nil
                local giveUp = tick() + 30
                repeat
                    task.wait()
                    Attack.Kill(bone, true)
                until not _G.AutoFarm_Bone
                   or not bone.Parent
                   or bone.Humanoid.Health <= 0
                   or tick() > giveUp
            elseif GetConnectionEnemies(wanted and {wanted} or BonesTable) then
                local far = GetConnectionEnemies(wanted and {wanted} or BonesTable)
                if far and far:FindFirstChild("HumanoidRootPart") then
                    _tp(far.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                end
            else
                local dest
                if wanted and PosMsList[wanted] then
                    dest = PosMsList[wanted]
                else
                    dest = BoneAreas[areaIdx]
                    if (dest.Position - root.Position).Magnitude <= 60 then
                        arrivedAt = arrivedAt or tick()
                        if tick() - arrivedAt > 5 then
                            areaIdx = areaIdx % #BoneAreas + 1
                            arrivedAt = nil
                        end
                    else
                        arrivedAt = nil
                    end
                end
                _tp(dest)
            end
        end)
    end
end)

-- Auto Soul Reaper loop
task.spawn(function()
  while task.wait(Sec) do
    if _G.AutoHytHallow then
      pcall(function()
        local v = GetConnectionEnemies("Soul Reaper")
	    if v then
          repeat task.wait() Attack.Kill(v,_G.AutoHytHallow) until v.Humanoid.Health <= 0 or _G.AutoHytHallow == false
        else
          if not GetBP("Hallow Essence") then
            repeat task.wait(.1)replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1)until _G.AutoHytHallow == false or GetBP("Hallow Essence")
          else
            repeat task.wait(.1) _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))until _G.AutoHytHallow == false or (plr.Character.HumanoidRootPart.CFrame == CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
		    EquipWeapon("Hallow Essence")
          end
        end
      end)
    end
  end
end)

-- Auto Random Bones loop
task.spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.Auto_Random_Bone then    
  	    repeat task.wait() replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) until not _G.Auto_Random_Bone
      end
    end)
  end
end)

-- Auto Try Luck Gravestone loop
task.spawn(function()
  while task.wait(Sec) do
    if _G.TryLucky then
      local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)
      if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then
        _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
	  elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then
	    replicated.Remotes.CommF_:InvokeServer("gravestoneEvent",1)
      end
    end
  end
end)

-- Auto Pray Gravestone loop
task.spawn(function()
  while task.wait(Sec) do
    if _G.Praying then
      local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)
      if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then
	    _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
      elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then
	    replicated.Remotes.CommF_:InvokeServer("gravestoneEvent",2)
      end
    end
  end
end)

-- Check Eyes helper
function Check_Eye()
    local e = workspace.Map.TikiOutpost.IslandModel
    local eyes = {
        e.Eye1,
        e.Eye2,
        e.IslandChunks.E.Eye3,
        e.IslandChunks.E.Eye4
    }

    local count = 0
    for _, eye in ipairs(eyes) do
        if eye and eye.Transparency ~= 1 then
            count = count + 1
        end
    end

    local isFull = (count == 4)
    return count, isFull
end

-- Auto Farm Tyrant loop
task.spawn(function()
    while task.wait(Sec) do
        if _G.FarmTyrant then
            pcall(function()
                if not plr.Character then return end
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local bossPos = Vector3.new(-16268.287, 152.616, 1390.773)
                
                if (hrp.Position - bossPos).Magnitude > 5 then
                    _tp(CFrame.new(bossPos))
                    repeat task.wait() until not _G.FarmTyrant or (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and (plr.Character.HumanoidRootPart.Position - bossPos).Magnitude <= 5)
                end

                local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    repeat
                        if not _G.FarmTyrant then break end
                        if Attack and Attack.Kill then
                            Attack.Kill(boss, _G.FarmTyrant)
                        end
                        task.wait()
                    until not _G.FarmTyrant or not boss.Parent or boss.Humanoid.Health <= 0
                    return
                end

                local mobList = {"Serpent Hunter","Skull Slayer","Isle Champion","Sun-kissed Warrior"}
                for _, mobName in ipairs(mobList) do
                    if not _G.FarmTyrant then break end
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if not _G.FarmTyrant then break end
                        if mob and mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            if (hrp.Position - mob.HumanoidRootPart.Position).Magnitude > 5000 then
                                _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                local t0 = tick()
                                repeat task.wait() hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") until not _G.FarmTyrant or not hrp or (hrp.Position - mob.HumanoidRootPart.Position).Magnitude <= 6 or tick() - t0 > 8
                            end
                            repeat
                                if not _G.FarmTyrant then break end
                                if Attack and Attack.Kill then
                                    Attack.Kill(mob, _G.FarmTyrant)
                                end
                                task.wait()
                            until not _G.FarmTyrant or not mob.Parent or mob.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- PhaBinh helpers & loop
function sendSkillKey(skillKey)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, skillKey, false, game)
    task.wait(0.05)
    virtualInputManager:SendKeyEvent(false, skillKey, false, game)
end

function equipAndUseSkill(toolType)
    local character = plr.Character
    local backpack = plr.Backpack
    if not (character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then return end

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = character
            task.wait(0.12)
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                if not _G.FarmPhaBinh then break end
                pcall(function() sendSkillKey(skill) end)
                task.wait(0.12)
            end
            item.Parent = backpack
            break
        end
    end
end

local PhaBinhPoints = {
    CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
    CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
    CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
    CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
    CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
    CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
    CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
    CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125),
}
Core.PhaBinhPoints = PhaBinhPoints

task.spawn(function()
    while task.wait(Sec) do
        if _G.FarmPhaBinh then
            pcall(function()
                if not (plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0) then return end

                for _, point in ipairs(PhaBinhPoints) do
                    if not _G.FarmPhaBinh then break end

                    _tp(point)

                    local arrived = false
                    local start = tick()
                    while tick() - start < 12 and not arrived and _G.FarmPhaBinh do
                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then break end
                        local dist = (hrp.Position - point.Position).Magnitude
                        if dist <= 3 then
                            arrived = true
                            break
                        end
                        task.wait(0.1)
                    end

                    if _G.FarmPhaBinh and arrived then
                        equipAndUseSkill("Melee")
                        equipAndUseSkill("Sword")
                        equipAndUseSkill("Gun")
                    end
                end
            end)
        end
    end
end)

-- Auto Material loop
task.spawn(function()
  function processEnemy(v, EnemyName)
    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
      if v.Name == EnemyName then repeat task.wait() Attack.Kill(v,getgenv().AutoMaterial) until not getgenv().AutoMaterial or not v.Parent or v.Humanoid.Health <= 0 end
    end
  end
  function handleEnemySpawns()
    for _, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
      for _, EnemyName in ipairs(MMon) do
        if string.find(v.Name, EnemyName) then
          if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude >= 10 then
            _tp(v.CFrame * Pos)
          end
        end
      end
    end
  end
  while task.wait() do
    if getgenv().AutoMaterial then
      pcall(function()
        if getgenv().SelectMaterial then MaterialMon(getgenv().SelectMaterial) _tp(MPos) end
        for _, EnemyName in ipairs(MMon) do
          for _, v in pairs(workspace.Enemies:GetChildren()) do processEnemy(v, EnemyName) end
        end
        handleEnemySpawns()
      end)
    end
  end
end)

-- Auto Farm Boss loop
task.spawn(function()
    while task.wait(Sec) do
        if _G.FarmBoss then
            pcall(function()
                local HasQuest = QuestBeta()[2] ~= nil and QuestBeta()[3] ~= nil
                local QuestTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

                if _G.AcceptQuestBoss and HasQuest then
                    if not string.find(QuestTitle, QuestBeta()[0]) then
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                    end

                    if plr.PlayerGui.Main.Quest.Visible == false then
                        _tp(QuestBeta()[5])
                        if (Root.Position - QuestBeta()[5].Position).Magnitude <= 5 then
                            replicated.Remotes.CommF_:InvokeServer("StartQuest", QuestBeta()[3], QuestBeta()[2])
                        end
                    elseif plr.PlayerGui.Main.Quest.Visible == true then
                        if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                            for i, v in pairs(workspace.Enemies:GetChildren()) do
                                if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                    if string.find(QuestTitle, QuestBeta()[0]) then
                                        repeat
                                            task.wait()
                                            Attack.Kill(v, _G.FarmBoss)
                                        until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                                    else
                                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        else
                            _tp(QuestBeta()[4])
                            if replicated:FindFirstChild(QuestBeta()[1]) then
                                _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            end
                        end
                    end
                else
                    if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                        for i, v in pairs(workspace.Enemies:GetChildren()) do
                            if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                repeat
                                    task.wait()
                                    Attack.Kill(v, _G.FarmBoss)
                                until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent
                            end
                        end
                    else
                        _tp(QuestBeta()[4])
                        if replicated:FindFirstChild(QuestBeta()[1]) then
                            _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Farm All Boss loop
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarmAllBoss then
            pcall(function()
                local player = game.Players.LocalPlayer
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = player.Character.HumanoidRootPart

                local nearestBoss, nearestDist = nil, math.huge

                for _, boss in pairs(workspace.Enemies:GetChildren()) do
                    if boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        if table.find(BossList, boss.Name) then
                            local dist = (hrp.Position - boss.HumanoidRootPart.Position).Magnitude
                            if dist < nearestDist then
                                nearestBoss = boss
                                nearestDist = dist
                            end
                        end
                    end
                end

                if nearestBoss and nearestBoss:FindFirstChild("HumanoidRootPart") then
                    local bossHRP = nearestBoss.HumanoidRootPart
                    local humanoid = nearestBoss.Humanoid

                    repeat
                        task.wait(0.1)
                        if not _G.AutoFarmAllBoss then break end

                        local targetCFrame = bossHRP.CFrame * CFrame.new(0, 5, 0)
                        if (hrp.Position - targetCFrame.Position).Magnitude > 100 then
                            player.Character:PivotTo(targetCFrame)
                        else
                            _tp(targetCFrame)
                        end

                        if Attack and typeof(Attack.Kill) == "function" then
                            Attack.Kill(nearestBoss, true)
                        end
                    until not nearestBoss.Parent or humanoid.Health <= 0 or not _G.AutoFarmAllBoss
                end
            end)
        end
    end
end)

-- Auto Mastery Fruits loop
RunSer.RenderStepped:Connect(function()
    pcall(function()
        if _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then
            for a,b in pairs(plr.PlayerGui.Notifications:GetChildren()) do
                if b.Name=="NotificationTemplate" and string.find(b.Text,"Skill locked!") then
                    b:Destroy()
                end
            end
        end
    end)
end)

task.spawn(function()
  while task.wait(Sec) do
    if _G.FarmMastery_Dev then
      pcall(function()
        if SelectIsland == "Cake" then         
          local v = GetConnectionEnemies(mastery1)
		  if v then		   
		    HealthM = v.Humanoid.MaxHealth * (_G.MasteryHealthPct or 70) / 100
		    repeat task.wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Mas(v,_G.FarmMastery_Dev)
		    until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent         		         		        
		  else
		    _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 
		  end
		elseif SelectIsland == "Bone" then
          local v = GetConnectionEnemies(mastery2)
		  if v then		
		    HealthM = v.Humanoid.MaxHealth * (_G.MasteryHealthPct or 70) / 100
		    repeat task.wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Mas(v,_G.FarmMastery_Dev)
		    until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent		        
		  else
		    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 		    
		  end
        end
      end)
    end
  end
end)

-- Auto Mastery Gun loop
task.spawn(function()
  while task.wait(Sec) do
    if _G.FarmMastery_G then
      pcall(function()
        if SelectIsland == "Cake" then
          local v = GetConnectionEnemies(mastery1)
		  if v then		      
		    HealthM = v.Humanoid.MaxHealth * (_G.MasteryHealthPct or 70) / 100
		    repeat task.wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Masgun(v,_G.FarmMastery_G)
		      local Modules = replicated:FindFirstChild("Modules")
              local Net = Modules:FindFirstChild("Net")
              local RE_ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")    
              if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then return end
              if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name == 'Skull Guitar' then
                SoulGuitar = true
		        plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);task.wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);task.wait(0.05)
                end
		      elseif plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name ~= 'Skull Guitar' then
		        SoulGuitar = false
		        RE_ShootGunEvent:FireServer(MousePos, { v.HumanoidRootPart })
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);task.wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);task.wait(0.05)
                end
		      end		            		
		    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent    
		    SoulGuitar = false     		         		        
		  else
		    _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 		    
	  	  end
		elseif SelectIsland == "Bone" then
          local v = GetConnectionEnemies(mastery2)
		  if v then		      
		    HealthM = v.Humanoid.MaxHealth * (_G.MasteryHealthPct or 70) / 100
		    repeat task.wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Masgun(v,_G.FarmMastery_G)
		      local Modules = replicated:FindFirstChild("Modules")
              local Net = Modules:FindFirstChild("Net")
              local RE_ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")    
              if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then return end
              if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name == 'Skull Guitar' then
                SoulGuitar = true
		        plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);task.wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);task.wait(0.05)
                end
		      elseif plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name ~= 'Skull Guitar' then
		        SoulGuitar = false
		        RE_ShootGunEvent:FireServer(MousePos, { v.HumanoidRootPart })
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);task.wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);task.wait(0.05)
                end
		      end		            		
		    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent    
		    SoulGuitar = false     		         		        
		  else
		    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
	  	  end
        end
      end)
    end
  end
end)

-- Auto Mastery Sword loop
task.spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.FarmMastery_S then
        if SelectIsland == "Cake" then
          for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do          
            if type(v) == "table" then
              if v.Type == "Sword" then
                SwordName = v.Name
                if tonumber(v.Mastery) >= 1 or tonumber(v.Mastery) <= 599 then
                  local v = GetConnectionEnemies(mastery1)
                  if GetBP(SwordName) then                    
		            if v then
                      repeat task.wait() Attack.Sword(v,_G.FarmMastery_S) until _G.FarmMastery_S == false or not v.Parent or v.Humanoid.Health <= 0		                  
		            else
		              _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 
		            end                    
                  else
                    replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName)   
                  end   
                elseif tonumber(v.Mastery) >= 600 then
                  if GetBP(SwordName) then return nil else replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName) end       
                end
                break
              end
            end         
          end
        elseif SelectIsland == "Bone" then
          for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do          
            if type(v) == "table" then
              if v.Type == "Sword" then
                SwordName = v.Name
                if tonumber(v.Mastery) >= 1 or tonumber(v.Mastery) <= 599 then
                  local v = GetConnectionEnemies(mastery2)
                  if GetBP(SwordName) then                    
		            if v then
                      repeat task.wait() Attack.Sword(v,_G.FarmMastery_S) until _G.FarmMastery_S == false or not v.Parent or v.Humanoid.Health <= 0		                  
		            else
		              _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
		            end                    
                  else
                    replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName)   
                  end   
                elseif tonumber(v.Mastery) >= 600 then
                  if GetBP(SwordName) then return nil else replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName) end       
                end
                break
              end
            end         
          end
        end
      end
    end)
  end
end)

-- ====================================================================
-- MAGNET EVENT (Update 30 / Magnet Token)
-- ====================================================================

local MagnetEvent = require(game.ReplicatedStorage.EventConfig.MagnetEvent26)

function IsMagnetEventActive()
    local now = workspace:GetServerTimeNow()
    local startAt = MagnetEvent.START_AT._Value
    local endAt = MagnetEvent.NO_MORE_GAMEPLAY_AT._Value
    return MagnetEvent.ENABLED and now >= startAt and now < endAt
end

_G.MagnetEventSpawnIndex = _G.MagnetEventSpawnIndex or 1

local MAGNET_BLACKLIST_ISLANDS = {
    ["sky"] = true,
    ["skyarea2"] = true,
    ["uppersky"] = true,
    ["upper sky"] = true,
    ["underwater city"] = true,
    ["fishman island"] = true,
    ["sewers"] = true,
    ["sewer gangs"] = true,
}
Core.MAGNET_BLACKLIST_ISLANDS = MAGNET_BLACKLIST_ISLANDS

local MAGNET_BLACKLIST_ENEMYSPAWNS = {}

function MagnetGetPos(obj)
    if not obj then return end
    if obj:IsA("BasePart") then return obj.Position end
    local ok, cf = pcall(function() return obj:GetPivot() end)
    return ok and typeof(cf) == "CFrame" and cf.Position or nil
end

function MagnetIsland(pos)
    local locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")
    if not locations then return "unknown" end
    local best, bestDist
    for _, loc in ipairs(locations:GetChildren()) do
        if loc:IsA("BasePart") then
            local d = (loc.Position - pos).Magnitude
            if not best or d < bestDist then
                best = loc.Name
                bestDist = d
            end
        end
    end
    return best and string.lower(best) or "unknown"
end

function MagnetSkipSpawn(spawnObj, island)
    local islandName = string.lower(tostring(island or ""))
    local spawnName = string.lower(tostring(spawnObj.Name or ""))
    local displayName = string.lower(tostring(spawnObj:GetAttribute("DisplayName") or ""))
    local raw = spawnName .. " " .. displayName

    if MAGNET_BLACKLIST_ISLANDS[islandName]
        or islandName:find("fishman", 1, true)
        or islandName:find("underwater", 1, true)
        or islandName:find("sewer", 1, true)
        or raw:find("boss", 1, true)
    then
        return true
    end
    return MAGNET_BLACKLIST_ENEMYSPAWNS[spawnName] or MAGNET_BLACKLIST_ENEMYSPAWNS[displayName]
end

function MagnetBuildPoints()
    local points = {}
    local grouped = {}
    local origin = workspace:FindFirstChild("_WorldOrigin")
    local spawns = origin and origin:FindFirstChild("EnemySpawns")
    if not spawns then return points end

    for _, spawnObj in ipairs(spawns:GetChildren()) do
        local pos = MagnetGetPos(spawnObj)
        if pos then
            local island = MagnetIsland(pos)
            local enemyName = tostring(spawnObj:GetAttribute("DisplayName") or spawnObj.Name or "")
            if enemyName ~= "" and not MagnetSkipSpawn(spawnObj, island) then
                grouped[island] = grouped[island] or {}
                grouped[island][enemyName] = grouped[island][enemyName] or {}
                grouped[island][enemyName][#grouped[island][enemyName] + 1] = pos
            end
        end
    end

    local islandNames = {}
    for island in pairs(grouped) do islandNames[#islandNames + 1] = island end
    table.sort(islandNames)

    for _, island in ipairs(islandNames) do
        local enemyGroups = grouped[island]
        local enemyNames = {}
        for enemyName in pairs(enemyGroups) do enemyNames[#enemyNames + 1] = enemyName end
        table.sort(enemyNames)

        local center
        local locs = origin and origin:FindFirstChild("Locations")
        if locs then
            for _, loc in ipairs(locs:GetChildren()) do
                if loc:IsA("BasePart") and string.lower(loc.Name) == island then
                    center = loc.Position
                    break
                end
            end
        end

        for _, enemyName in ipairs(enemyNames) do
            local spawnPoints = enemyGroups[enemyName]
            local base = spawnPoints[1]

            if #enemyNames > 1 then
                points[#points + 1] = {
                    Island = island,
                    Name = enemyName,
                    CFrame = CFrame.new(base + Vector3.new(0, 40, 0)),
                }
            else
                local dir = Vector3.new(1, 0, 0)
                if center then
                    local flat = Vector3.new(base.X - center.X, 0, base.Z - center.Z)
                    if flat.Magnitude > 0.01 then dir = flat.Unit end
                end
                local p1 = base + dir * 60
                local p2 = base - dir * 60
                points[#points + 1] = {
                    Island = island,
                    Name = enemyName,
                    CFrame = CFrame.new(p1 + Vector3.new(0, 40, 0)),
                }
                points[#points + 1] = {
                    Island = island,
                    Name = enemyName,
                    CFrame = CFrame.new(p2 + Vector3.new(0, 40, 0)),
                }
            end
        end
    end

    return points
end

function MagnetFindTarget()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local best, bestDist

    for _, mob in ipairs(enemies:GetChildren()) do
        if mob:IsA("Model")
            and (mob:GetAttribute("MagnetEnemy") == true or string.find(string.lower(mob.Name), "magnetized"))
            and mob:FindFirstChild("Humanoid")
            and mob.Humanoid.Health > 0
            and mob:FindFirstChild("HumanoidRootPart")
        then
            local dist = hrp and (mob.HumanoidRootPart.Position - hrp.Position).Magnitude or 0
            if not best or dist < bestDist then
                best = mob
                bestDist = dist
            end
        end
    end
    return best
end

function SetMagnetStatus(status)
    if _G.SetMagnetStatus then
        pcall(_G.SetMagnetStatus, status)
    end
end

function MagnetTravel(point)
    if not point or typeof(point.CFrame) ~= "CFrame" then
        return false
    end

    local player = game.Players.LocalPlayer
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    SetMagnetStatus("Patrolling - " .. tostring(point.Island))
    pcall(function() _tp(point.CFrame) end)

    local startTime = tick()
    while _G.AutoMagnetToken do
        local target = MagnetFindTarget()
        if target then
            return target
        end
        char = player.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        if (point.CFrame.Position - hrp.Position).Magnitude <= 15 then
            break
        end
        if tick() - startTime > 10 then break end
        task.wait(0.1)
    end

    if not _G.AutoMagnetToken then return false end

    SetMagnetStatus("Searching - " .. tostring(point.Island))
    local scanStart = tick()
    while _G.AutoMagnetToken and tick() - scanStart < 1 do
        local target = MagnetFindTarget()
        if target then
            return target
        end
        task.wait(0.05)
    end

    return MagnetFindTarget() or false
end

task.spawn(function()
    local magnetPoints = {}
    local pointIndex = 1
    local isFirstRun = true

    while task.wait() do
        if not _G.AutoMagnetToken then
            SetMagnetStatus("Idle")
            _G.MagnetEventSpawnIndex = pointIndex
            task.wait(1)
            continue
        end

        if isFirstRun or #magnetPoints == 0 then
            magnetPoints = MagnetBuildPoints()
            if #magnetPoints == 0 then
                task.wait(5)
                continue
            end
            pointIndex = (_G.MagnetEventSpawnIndex or 1)
            if pointIndex > #magnetPoints then pointIndex = 1 end
            isFirstRun = false
            _G.MagnetEventSpawnRoute = magnetPoints
        end

        local point = magnetPoints[pointIndex]
        if not point then
            pointIndex = 1
            point = magnetPoints[pointIndex]
        end

        local target = MagnetTravel(point)

        if target then
            SetMagnetStatus("Farming - " .. tostring(target.Name))
            repeat
                task.wait(0.1)
                if not target.Parent or not target:FindFirstChild("HumanoidRootPart") then break end
                _tp(target.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                Attack.Kill(target, _G.AutoMagnetToken)
            until not _G.AutoMagnetToken or not target or target.Humanoid.Health <= 0 or not target.Parent

            pointIndex = pointIndex + 1
            if pointIndex > #magnetPoints then pointIndex = 1 end
            _G.MagnetEventSpawnIndex = pointIndex
        else
            pointIndex = pointIndex + 1
            if pointIndex > #magnetPoints then pointIndex = 1 end
            _G.MagnetEventSpawnIndex = pointIndex
            task.wait(0.2)
        end
    end
end)

-- ====================================================================
-- SETTINGS & CONFIGURATION LOOPS
-- ====================================================================

Spawn(function()
    while Wait(1) do
        if _G.AutoHopServer then
            pcall(function()
                if not _G.HopTimer then
                    _G.HopTimer = tick()
                end

                if tick() - _G.HopTimer >= (_G.HopDelay or 1800) then
                    _G.HopTimer = tick()

                    if syn and syn.queue_on_teleport then
                        syn.queue_on_teleport(
                            "loadstring(game:HttpGet('https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Chest'))()"
                        )
                    end

                    game:GetService("TeleportService")
                        :Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
            end)
        end
    end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if Boud then
      local _HasBuso = {"HasBuso","Buso"}
  	  if not plr.Character:FindFirstChild(_HasBuso[1]) then replicated.Remotes.CommF_:InvokeServer(_HasBuso[2]) end
      end
    end)
  end
end)

spawn(function()
    while wait() do
        if getgenv().Observation then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end
end)

spawn(function()
  while wait(.2) do
    pcall(function()
      if _G.RaceClickAutov3 then
        repeat
          replicated.Remotes.CommE:FireServer("ActivateAbility") 
          wait(30)
        until not _G.RaceClickAutov3   
      end 
    end)
  end
end)

spawn(function()
  while wait(.2) do
    pcall(function()
      if _G.RaceClickAutov4 then
  	    if plr.Character:FindFirstChild("RaceEnergy") then
        if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then Useskills("nil","Y") end
        end        
      end 
    end)
  end
end)

spawn(function()
  while task.wait(Sec) do
    pcall(function()
	  if _G.Safemode then
  	  local Calc_Health = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100
  	  if Calc_Health < Num_self then shouldTween=true _tp(Root.CFrame * CFrame.new(0,500,0)) else shouldTween=false end
      end
    end)
  end
end)

local HitEffects = {"SlashHit", "CurvedRing", "SwordSlash", "SlashTail"}

task.spawn(function()
    while task.wait(Sec) do
        if _G.DestroyHit then
            pcall(function()
                for _, v in pairs(workspace["_WorldOrigin"]:GetChildren()) do
                    if table.find(HitEffects, v.Name) then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if RDeath then
	  if replicated.Effect.Container:FindFirstChild("Death") then replicated.Effect.Container.Death:Destroy() end
      if replicated.Effect.Container:FindFirstChild("Respawn") then replicated.Effect.Container.Respawn:Destroy() end
	  end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if RemoveDamage then
        replicated.Assets.GUI.DamageCounter.Enabled = false
        plr.PlayerGui.Notifications.Enabled = false
	  else
        replicated.Assets.GUI.DamageCounter.Enabled = true
        plr.PlayerGui.Notifications.Enabled = true
      end
    end)
  end
end)

spawn(function()
    while wait() do
        pcall(function()
            if getgenv().HopServerAdmin then
                for _, v in pairs(game.Players:GetPlayers()) do
                    local blacklist = {
                        "red_game43", "rip_indra", "Axiore", "Polkster", "wenlocktoad",
                        "Daigrock", "toilamvidamme", "oofficialnoobie", "Uzoth", "Azarth",
                        "arlthmetic", "Death_King", "Lunoven", "TheGreateAced", "rip_fud",
                        "drip_mama", "layandikit12", "Hingoi"
                    }
                    if table.find(blacklist, v.Name) then
                        Hop()
                    end
                end
            end
        end)
    end
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().NoClip then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Part") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

-- ====================================================================
-- STATS UPGRADE LOOPS
-- ====================================================================

spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Melee then statsSetings("Melee",pSats) end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Sword then statsSetings("Sword",pSats) end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Gun then statsSetings("Gun",pSats) end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_DevilFruit then statsSetings("Devil",pSats) end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
    if _G.Auto_Defense then statsSetings("Defense",pSats) end
    end)
  end
end)

-- ====================================================================
-- FISHING SYSTEM LOOPS & HELPERS
-- ====================================================================

task.spawn(function()
    while task.wait(2) do
        if _G.AutoBuyBait and _G.SelectedBait then
            pcall(function()
                replicated.Modules.Net["RF/Craft"]:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
end)

local FishReplicated = replicated:WaitForChild("FishReplicated", 10)
local FishingRequest = FishReplicated and FishReplicated:WaitForChild("FishingRequest", 10)
local FishConfig = FishReplicated and require(FishReplicated.FishingClient.Config)
local GetWaterHeight = require(replicated.Util.GetWaterHeightAtLocation)
local MaxFishDistance = FishConfig and FishConfig.Rod and FishConfig.Rod.MaxLaunchDistance or 100

local FishState = {bite = false, biteAt = 0, casting = false, castAt = 0, blockedSince = nil}

task.spawn(function()
    if not FishReplicated then return end
    local ok, remote = pcall(function() return FishReplicated:WaitForChild("FishingRemote", 15) end)
    if ok and remote then
        remote.OnClientEvent:Connect(function(who, eventName, ...)
            if who ~= plr then return end
            if eventName == "SpawnFishOnBob" then
                FishState.bite = true
                FishState.biteAt = tick()
            elseif eventName == "ResetBiting" then
                FishState.bite = false
            elseif eventName == "ReeledIn" then
                FishState.bite = false
                FishState.casting = false
            end
        end)
    end
end)

function FindCastTarget(Char, HRP, Tool)
    local ignore = {Char, workspace.Characters, workspace.Enemies}
    local waterHeight = GetWaterHeight(HRP.Position)
    local reach = (Tool:GetAttribute("MaxLaunchDistance") or MaxFishDistance) * (0.5 + 100 / 201)
    for _, angle in ipairs({0, 45, -45, 90, -90, 135, -135, 180}) do
        local dir = CFrame.Angles(0, math.rad(angle), 0) * HRP.CFrame.LookVector
        local _, hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(Char.Head.Position, dir * reach), ignore)
        local part, below = workspace:FindPartOnRayWithIgnoreList(Ray.new(hit + Vector3.new(0, 3, 0), Vector3.new(0, -500, 0)), ignore)
        if part or below.Y < waterHeight then
            local pos = Vector3.new(hit.X, math.max(below.Y, waterHeight), hit.Z)
            local valid = (part and game:GetService("CollectionService"):HasTag(part, FishConfig.WATER_BODY_TAG)) or pos.Y <= waterHeight
            if valid then
                HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Vector3.new(dir.X, 0, dir.Z))
                return pos
            end
        end
    end
    local _, hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(Char.Head.Position, HRP.CFrame.LookVector * reach), ignore)
    return Vector3.new(hit.X, math.max(hit.Y, waterHeight), hit.Z)
end

task.spawn(function()
    while task.wait(0.4) do
        if not _G.AutoFishing then
            FishState.casting = false
            FishState.bite = false
        else
            pcall(function()
                local Char = plr.Character
                local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
                local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
                if not HRP or not Hum or Hum.Health <= 0 then return end

                local Tool = Char:FindFirstChildOfClass("Tool")
                local wantName = _G.SelectedRod
                local wrongRod = Tool and wantName and Tool.Name ~= wantName and plr.Backpack:FindFirstChild(wantName)
                if not (Tool and Tool:FindFirstChild("FishingRodData")) or wrongRod then
                    local rod = wantName and plr.Backpack:FindFirstChild(wantName)
                    if not rod then
                        for _, t in ipairs(plr.Backpack:GetChildren()) do
                            if t:IsA("Tool") and t:FindFirstChild("FishingRodData") then rod = t break end
                        end
                    end
                    if rod then
                        FishState.casting = false
                        Hum:EquipTool(rod)
                        task.wait(0.6)
                    end
                    return
                end

                if FishState.bite or (FishState.casting and Tool:GetAttribute("ServerState") == "Biting") then
                    FishState.bite = false
                    FishingRequest:InvokeServer("Catching", true)
                    task.wait(_G.FishCatchDelay or math.random(35, 55) / 10)
                    FishingRequest:InvokeServer("Catch", 1, 0, math.random(80, 95) / 100)
                    FishState.casting = false
                    task.wait(1)
                    return
                end

                if FishState.casting then
                    if tick() - FishState.castAt > 25 then
                        pcall(function() FishingRequest:InvokeServer("ReeledIn") end)
                        FishState.casting = false
                    end
                    return
                end

                local State, ServerState = Tool:GetAttribute("State"), Tool:GetAttribute("ServerState")
                local busy = (State ~= nil and State ~= "ReeledIn") or (ServerState ~= nil and ServerState ~= "ReeledIn")
                if busy then
                    FishState.blockedSince = FishState.blockedSince or tick()
                    if tick() - FishState.blockedSince < 15 then return end
                else
                    FishState.blockedSince = nil
                end
                local bait = plr.Data.FishingData:GetAttribute("SelectedBait")
                if bait == nil or bait == "None" then return end

                local pos = FindCastTarget(Char, HRP, Tool)
                if not pos then return end
                FishingRequest:InvokeServer("StartCasting")
                task.wait(0.2)
                local bobberId, rejected = FishingRequest:InvokeServer("CastLineAtLocation", pos, 100, true)
                if bobberId and not rejected then
                    FishState.casting = true
                    FishState.castAt = tick()
                    FishState.blockedSince = nil
                end
            end)
        end
    end
end)

function HasQuest3()
    local questGui = plr.PlayerGui:FindFirstChild("Quest") or plr.PlayerGui:FindFirstChild("QuestGui")
    if questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") then
        return true
    end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFishingQuest then
            pcall(function()
                if not HasQuest3() then
                    replicated.Modules.Net["RF/JobsRemoteFunction"]:InvokeServer("FishingNPC", "Angler", "AskQuest")
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(5) do 
        if _G.AutoQuestComplete then
            pcall(function()
                replicated.Modules.Net["RF/JobsRemoteFunction"]:InvokeServer("FishingNPC", "FinishQuest")
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(5) do 
        if _G.AutoSellFish then
            pcall(function()
                replicated.Modules.Net["RF/JobsRemoteFunction"]:InvokeServer("FishingNPC", "SellFish")
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSkillZ then
            pcall(function()
                replicated.Modules.Net["RF/JobToolAbilities"]:InvokeServer("Z", true)
            end)
        end
    end
end)

-- ====================================================================
-- WORLD TRAVEL QUESTS (Sea 2 & Sea 3)
-- ====================================================================

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TravelDres then
        if plr.Data.Level.Value >= 700 then
          if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
            replicated.Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Detective")
		    EquipWeapon("Key")
		    repeat wait() _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) until not _G.TravelDres or (Root.Position == CFrame.new(1347.7124, 37.3751602, -1325.6488).Position)
	      elseif workspace.Map.Ice.Door.CanCollide == false and workspace.Map.Ice.Door.Transparency == 1 then
            if Enemies:FindFirstChild("Ice Admiral") then
              for _,xz in pairs(Enemies:GetChildren()) do
                if xz.Name == "Ice Admiral" and Attack.Alive(xz) then
              	  repeat task.wait() Attack.Kill(xz,_G.TravelDres) until _G.TravelDres == false or xz.Humanoid.Health <= 0
                  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                end
              end
            else
              _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))
            end
	      else
		    replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
	      end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoZou then
   	    if plr.Data.Level.Value >= 1500 then
          if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 3 then
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
              replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")
              if replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
                local v = GetConnectionEnemies("rip_indra")
                if v then
                  repeat wait() Attack.Kill(v,_G.AutoZou) until not _G.AutoZou or not v.Parent or v.Humanoid.Health <= 0
                  Check = 2
                  repeat wait()replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")until Check == 1                   
                else
                  replicated.Remotes.CommF_:InvokeServer("F_","ZQuestProgress","Check") wait(.1)
                  replicated.Remotes.CommF_:InvokeServer("F_","ZQuestProgress","Begin")
                end
              elseif replicated.Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 1 then
                replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")
              else
                local v = GetConnectionEnemies("Don Swan")
                if v then
                  repeat wait() Attack.Kill(v,_G.AutoZou)until not _G.AutoZou or not v.Parent or v.Humanoid.Health<=0                  
                else
                  repeat wait() _tp(CFrame.new(2288.802, 15.1870775, 863.034607)) until not _G.AutoZou or (Root.Position == CFrame.new(2288.802, 15.1870775, 863.034607).Position)
                  if (Root.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607)) then notween(CFrame.new(2288.802, 15.1870775, 863.034607)) end
                end
              end
            else
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
              TabelDevilFruitStore = {}
              TabelDevilFruitOpen = {}
              for i,v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
                for i1,v1 in pairs(v) do
                  if i1 == "Name" then table.insert(TabelDevilFruitStore,v1)end
                end
              end
              for i,v in next, game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
                if v.Price >= 1000000 then table.insert(TabelDevilFruitOpen,v.Name) end
              end
              for i,DevilFruitOpenDoor in pairs(TabelDevilFruitOpen) do
                for i1,DevilFruitStore in pairs(TabelDevilFruitStore) do
                  if DevilFruitOpenDoor == DevilFruitStore and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                    if not plr.Backpack:FindFirstChild(DevilFruitStore) then
                      replicated.Remotes.CommF_:InvokeServer("F_","LoadFruit",DevilFruitStore)
                    else
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","1")
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","2")
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","3")
                    end
                  end
                end
              end
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","1")
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","2")
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","3")
              end
            end
          else
            if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
              if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then                
                local v = GetConnectionEnemies("Swan Pirate")
                if v then
                  pcall(function() repeat wait() Attack.Kill(v,_G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false or plr.PlayerGui.Main.Quest.Visible == false end)                    
                else
                  _tp(CFrame.new(1057.92761, 137.614319, 1242.08069))
                end
              else
                _tp(CFrame.new(-456.28952, 73.0200958, 299.895966))
              end
            elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
              local v = GetConnectionEnemies("Jeremy")
              if v then
                repeat wait() Attack.Kill(v,_G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false
              else
                _tp(CFrame.new(2099.88159, 448.931, 648.997375))
              end
            elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
              repeat wait() _tp(CFrame.new(-1836, 11, 1714)) until not _G.AutoZou or (Root.Position == CFrame.new(-1836, 11, 1714).Position)
              if (Root.CFrame == CFrame.new(-1836, 11, 1714)) then notween(CFrame.new(-1836, 11, 1714))end
              notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
              wait(.1)
              notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
              wait(.1)
              notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
              wait(.1)
              notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
              wait(.1)
              notween(CFrame.new(-1869.54224, 15.987854, 1681.00659))
              wait(.1)
              notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
              wait(.1)
              notween(CFrame.new(-1819.26343, 14.795166, 1717.90625))
              wait(.1)
              notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
            end
          end
        end
      end
    end)
  end
end)

-- ====================================================================
-- TUSHITA, YAMA, SKULL GUITAR, CDK
-- ====================================================================

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Tushita then
        if workspace.Map.Turtle:FindFirstChild("TushitaGate") then
          if not GetBP("Holy Torch") then
            _tp(CFrame.new(5148.03613, 162.352493, 910.548218))
            wait(0.7)
          else
            EquipWeapon("Holy Torch")
            task.wait(1)
            repeat task.wait() _tp(CFrame.new(-10752, 417, -9366)) until not _G.Auto_Tushita or (CFrame.new(-10752, 417, -9366).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-11672, 334, -9474)) until not _G.Auto_Tushita or (CFrame.new(-11672, 334, -9474).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-12132, 521, -10655)) until not _G.Auto_Tushita or (CFrame.new(-12132, 521, -10655).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-13336, 486, -6985)) until not _G.Auto_Tushita or (CFrame.new(-13336, 486, -6985).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
            wait(.7)
            repeat task.wait() _tp(CFrame.new(-13489, 332, -7925)) until not _G.Auto_Tushita or (CFrame.new(-13489, 332, -7925).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
          end
        else
          local v = GetConnectionEnemies("Longma")
          if v then repeat task.wait() Attack.Kill(v,_G.Auto_Tushita) until v.Humanoid.Health <= 0 or not _G.Auto_Tushita or not v.Parent
          else 
          if replicated:FindFirstChild("Longma") then _tp(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0,40,0)) end
          end                     
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Yama then
	    if replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") < 30 then
	      _G.FarmEliteHunt = true
	    elseif replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") > 30 then
	      _G.FarmEliteHunt = false
	      if (workspace.Map.Waterfall.SealedKatana.Handle.Position-plr.Character.HumanoidRootPart.Position).Magnitude >= 20 then
            _tp(workspace.Map.Waterfall.SealedKatana.Handle.CFrame)
            local zx = GetConnectionEnemies("Ghost")
            if zx then
              repeat wait() Attack.Kill(zx,_G.Auto_Yama) until zx.Humanoid.Health <= 0 or not zx.Parent or not _G.Auto_Yama               
			  fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
            end
          end
	    end
      end
    end)
  end
end)

task.spawn(function()
  while wait() do
    if _G.Auto_Soul_Guitar then 
      pcall(function() 
        local v = GetConnectionEnemies("Living Zombie")
        if v then 
          v.HumanoidRootPart.CFrame = CFrame.new(-10138.3974609375, 138.6524658203125, 5902.89208984375)
          v.Head.CanCollide = false
          v.Humanoid.Sit = false
          v.HumanoidRootPart.CanCollide = false
          v.Humanoid.JumpPower = 0
          v.Humanoid.WalkSpeed = 0
          if v.Humanoid:FindFirstChild('Animator') then v.Humanoid:FindFirstChild('Animator'):Destroy() end
        end    
      end)
    end
  end
end)

function getT(num)
    local rotation
    if num == 1 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment1.Line.Rotation
    elseif num == 3 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment3.Line.Rotation
    elseif num == 4 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment4.Line.Rotation
    elseif num == 7 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment7.Line.Rotation
    elseif num == 10 then
        rotation = workspace.Map["Haunted Castle"].Tablet.Segment10.Line.Rotation
    end
    if rotation then
        return rotation.Z
    end
end

function getRT(num)
    local Trophy_Q = workspace.Map["Haunted Castle"].Trophies.Quest
    local Trophy_Pos
    for _, v in pairs(Trophy_Q:GetChildren()) do
        if num == 1 and v.Name == "Trophy1" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation
        elseif num == 2 and v.Name == "Trophy2" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation         
        elseif num == 3 and v.Name == "Trophy3" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation       
        elseif num == 4 and v.Name == "Trophy4" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation  
        elseif num == 5 and v.Name == "Trophy5" and v:FindFirstChild("Handle") then
            Trophy_Pos = v.Handle.Rotation     
        end          
        if Trophy_Pos then
            return Trophy_Pos.Z   
        end
    end
end

GetFirePlacard = function(Number,Side)
  if tostring(workspace.Map["Haunted Castle"]["Placard"..Number][Side].Indicator.BrickColor) ~= "Pearl" then
    fireclickdetector(workspace.Map["Haunted Castle"]["Placard"..Number][Side].ClickDetector)
  end
end

spawn(function()
  repeat task.wait() until _G.Auto_Soul_Guitar
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Soul_Guitar then
        if World3 then
          replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
          replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
          if replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check") == nil then
            _tp(CFrame.new(-8655.0166015625, 141.3166961669922, 6160.0224609375))
            replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Swamp == false then
             Quest1 = true;
             Quest2 = false;
             Quest3 = false;
             Quest4 = false;
             local v = GetConnectionEnemies("Living Zombie")
             if v then repeat task.wait() Attack.Kill(v,_G.Auto_Soul_Guitar) until not _G.Auto_Soul_Guitar or v.Humanoid.Health <= 0 or not v.Parent or workspace.Map["Haunted Castle"].SwampWater.Color ~= Color3.fromRGB(117, 0, 0)
             else _tp(CFrame.new(-10170.7275390625, 138.6524658203125, 5934.26513671875))
             end
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Gravestones == false then
             Quest1 = false;
             Quest2 = true;
             Quest3 = false;
             Quest4 = false;
             GetFirePlacard("7","Left")
             GetFirePlacard("6","Left")
             GetFirePlacard("5","Left")
             GetFirePlacard("4","Right")
             GetFirePlacard("3","Left")
             GetFirePlacard("2","Right")
             GetFirePlacard("1","Right")
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Ghost == false then
             replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
             replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost", true)
           elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Trophies == false then
             Quest1 = false;
             Quest2 = false;
             Quest3 = true;
             Quest4 = false;             
             _tp(CFrame.new(-9532.8232421875, 6.471667766571045, 6078.068359375))
             repeat wait()
               local z1 = getRT(1)
               local _z1 = getT(1)
               if z1 and _z1 then
                 fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector"))
               end
             until z1 == _z1
            repeat wait()
              local z2 = getRT(2)
              local _z2 = getT(3)
              if z2 and _z2 then
                fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment3:FindFirstChild("ClickDetector"))
              end
            until z2 == _z2
          repeat wait()
            local z3 = getRT(3)
            local _z3 = getT(4)
            if z3 and _z3 then
              fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment4:FindFirstChild("ClickDetector"))
            end
          until z3 == _z3
          repeat wait()
            local z4 = getRT(4)
            local _z4 = getT(7)
            if z4 and _z4 then
              fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment7:FindFirstChild("ClickDetector"))
            end
          until z4 == _z4
        repeat wait()
          local z5 = getRT(5)
          local _z5 = getT(10)
          if z5 and _z5 then
            fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment10:FindFirstChild("ClickDetector"))    
          end
        until z5 == _z5
        repeat wait()    
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment2:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment5:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment6:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment8:FindFirstChild("ClickDetector"))
          fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment9:FindFirstChild("ClickDetector"))       
        until workspace.Map["Haunted Castle"].Tablet.Segment2.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment5.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment6.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment8.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment9.Line.Rotation.Z == 0
          elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress","Check").Pipes == false then
            Quest1 = false;
            Quest2 = false;
            Quest3 = false;
            Quest4 = true;
           _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
		   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
		   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
		   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
	   	   _tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
		   fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
	       fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
	       fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoMatSoul and GetWP("Skull Guitar") == false then
	    if GetM("Bones") >= 500 and GetM("Ectoplasm") >= 250 and GetM("Dark Fragment") >= 1 then
	      replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy",true)
		else
		  if GetM("Ectoplasm") <= 250 then
		    if _G.AutoMatSoul and World2 then
		      local EctoTable = {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"}    
		      local xz = GetConnectionEnemies(EctoTable)
              if xz then repeat task.wait() Attack.Kill(xz, _G.AutoMatSoul)until not _G.AutoMatSoul or not xz.Parent or xz.Humanoid.Health <= 0
			  else replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
			  end
		    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
		    end
		  elseif GetM("Dark Fragment") < 1 then
		    if _G.AutoMatSoul and World2 then
		      local black = GetConnectionEnemies("Darkbeard")
		      if black then repeat task.wait()Attack.Kill(black, _G.AutoMatSoul)until not _G.AutoMatSoul or black.Humanoid.Health <= 0 or not black.Parent
		      else _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
		      end
		    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
			end
		     if not GetConnectionEnemies("Darkbeard") then Hop() end
	         elseif GetM("Bones") <= 500 then
		       if _G.AutoMatSoul and World3 then
			     local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}
			     local zx = GetConnectionEnemies(BonesTable)			   
	             if zx then repeat task.wait()Attack.Kill(zx, _G.AutoMatSoul)until not _G.AutoMatSoul or zx.Humanoid.Health <= 0 or not zx.Parent or zx.Humanoid.Health <= 0
				 else _tp(CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625))
			   end
		     else
		       replicated.Remotes.CommF_:InvokeServer("TravelZou")
		     end
		   end
	     end
	   end
    end)
  end
end)

spawn(function()    
  while wait(Sec) do
    pcall(function()
      if _G.CDK then
        if tick() - (getgenv().LastCDKBossKick or 0) > 3 then
          getgenv().LastCDKBossKick = tick()
          replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
          replicated.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
          replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Boss")
        end
        local v = GetConnectionEnemies("Cursed Skeleton Boss")
        if v then
          repeat wait()
            if plr.Character:FindFirstChild("Yama") or plr.Backpack:FindFirstChild("Yama") then EquipWeapon("Yama")
            elseif plr.Character:FindFirstChild("Tushita") or plr.Backpack:FindFirstChild("Tushita") then EquipWeapon("Tushita")                                    
            end _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
          until not _G.CDK or not v.Parent or v.Humanoid.Health <= 0                                
        else
          _tp(CFrame.new(-12318.193359375, 601.9518432617188, -6538.662109375)) wait(.5)
          _tp(workspace.Map.Turtle.Cursed.BossDoor.CFrame)
        end
      end
    end)
  end
end)

spawn(function()
  while wait() do
    pcall(function()
      if _G.CDK_YM then
        if not CDKEnsureDoor() then
          -- door not open yet; CDKEnsureDoor already asked the server (at most once per second)
        else
          if CDKProgress()["Finished"] == nil then
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
          elseif CDKProgress()["Finished"] == false then                        
            if tonumber(CDKProgress()["Evil"]) == -3 then
              QuestYama_1 = true QuestYama_2 = false QuestYama_3 = false
              repeat task.wait()
                if not workspace.Enemies:FindFirstChild("Forest Pirate") then
                  _tp(CFrame.new(-13223.521484375, 428.1938171386719, -7766.06787109375))
                else
                  local v = GetConnectionEnemies("Forest Pirate")
                  if v then _tp(workspace.Enemies:FindFirstChild("Forest Pirate").HumanoidRootPart.CFrame)end
                end
              until tonumber(CDKProgress()["Evil"]) == 1 or not _G.CDK_YM
            elseif tonumber(CDKProgress()["Evil"]) == -4 then
              QuestYama_1 = false QuestYama_2 = true QuestYama_3 = false
              for ix,HitMon in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
                for NameMonHaze, CFramePos in pairs(PosMsList) do
                  if string.find(NameMonHaze,HitMon.Name) and HitMon.Value > 0 then
                    if (CFramePos.Position - Root.Position).Magnitude <= 1000 and workspace.Enemies:FindFirstChild(NameMonHaze) then
                      for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 and v:FindFirstChild("HazeESP") then
                          repeat wait() Attack.Kill(v, _G.CDK_YM) until not _G.CDK_YM or tonumber(CDKProgress()["Evil"]) == 2 or not v:FindFirstChild("HazeESP") or v.Humanoid.Health <= 0
                        end
                      end
                    else   
                      _tp(CFramePos)                               
                    end
                  end
                end
              end
            elseif tonumber(CDKProgress()["Evil"]) == -5 then
              QuestYama_1 = false QuestYama_2 = false QuestYama_3 = true
              if workspace.Map:FindFirstChild("HellDimension") then
                if (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000 then
                  for gg,ez in pairs(workspace.Map.HellDimension.Exit:GetChildren()) do
                    if tonumber(gg) == 2 then
                      repeat task.wait() Root.CFrame = workspace.Map.HellDimension.Exit.CFrame until not _G.CDK_YM or tonumber(CDKProgress()["Evil"]) == 3
                    end
                  end
                  EquipWeapon(_G.SelectWeapon)
                  if tonumber(CDKProgress()["Evil"]) ~= 3 then
                  repeat task.wait()
                    repeat task.wait() 
                      _tp(workspace.Map.HellDimension.Torch1.Particles.CFrame) 
                      for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (workspace.Map.HellDimension.Torch1.Particles.Position - Root.Position).Magnitude < 5
                    wait(2) _G.T1Yama = true
                  until not _G.CDK_YM or _G.T1Yama or tonumber(CDKProgress()["Evil"]) == 3
                  repeat task.wait()
                    repeat task.wait()
                      _tp(workspace.Map.HellDimension.Torch2.Particles.CFrame) 
                      for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v)end
                      end
                    until (workspace.Map.HellDimension.Torch2.Particles.Position - Root.Position).Magnitude < 5
                    wait(2) _G.T2Yama = true
                  until _G.T2Yama or _G.CDK_YM == false or tonumber(CDKProgress()["Evil"]) == 3
                    repeat wait()
                      repeat task.wait() 
                        _tp(workspace.Map.HellDimension.Torch3.Particles.CFrame) 
                        for i, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                          if v:IsA("ProximityPrompt") then fireproximityprompt(v)end
                        end
                      until (workspace.Map.HellDimension.Torch3.Particles.Position - Root.Position).Magnitude < 5 
                      wait(2) _G.T3Yama = true
                    until _G.T3Yama or _G.CDK_YM == false or tonumber(CDKProgress()["Evil"]) == 3
                  end
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if (v:FindFirstChild("HumanoidRootPart").Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 300 then
                      if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 then
                        repeat task.wait() Attack.Kill(v,_G.CDK_YM) until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent or tonumber(CDKProgress()["Evil"]) == 3
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
  end
end)

spawn(function()
  while wait() do
    pcall(function()
      if _G.CDK_YM then
        if tonumber(CDKProgress()["Evil"]) == -5 then
          if not workspace.Map:FindFirstChild("HellDimension") or (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude > 1000 then
            local v = GetConnectionEnemies("Soul Reaper")
            if v then repeat task.wait()_tp(v.HumanoidRootPart.CFrame) until v.Humanoid.Health <= 0 or not _G.CDK_YM or not v.Parent or tonumber(CDKProgress()["Evil"]) == 3 or (workspace.Map:FindFirstChild("HellDimension") and (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000)
            elseif plr.Backpack:FindFirstChild("Hallow Essence") or plr.Character:FindFirstChild("Hallow Essence") then
            repeat _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) task.wait() until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8
            EquipWeapon("Hallow Essence")
            elseif replicated:FindFirstChild("Soul Reaper") and replicated:FindFirstChild("Soul Reaper").Humanoid.Health > 0 then
              _tp(replicated:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame)
            else
              if replicated.Remotes.CommF_:InvokeServer("Bones","Check") < 50 and not workspace.Enemies:FindFirstChild("Soul Reaper") and not replicated:FindFirstChild("Soul Reaper") and not workspace.Map:FindFirstChild("HellDimension") then
                if workspace.Enemies:FindFirstChild("Reborn Skeleton") or workspace.Enemies:FindFirstChild("Living Zombie") or workspace.Enemies:FindFirstChild("Demonic Soul") or workspace.Enemies:FindFirstChild("Posessed Mummy") then
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                      if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 then
                        repeat task.wait() Attack.Kill(v,_G.CDK_YM)until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent
                      end
                    end
                  end
                else
                  _tp(CFrame.new(-9515.2255859375, 164.0062255859375, 5785.38330078125))
                end
              else
                replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
              end
            end
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait() do
    pcall(function()
      if _G.CDK_TS then
        if not CDKEnsureDoor() then
          -- door not open yet; CDKEnsureDoor already asked the server (at most once per second)
        else
          if CDKProgress()["Finished"] == nil then
            replicated.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
          elseif CDKProgress()["Finished"] == false then
            if tonumber(CDKProgress()["Good"]) == -3 then
              QuestTushita_1 = true
              QuestTushita_2 = false
              QuestTushita_3 = false
              repeat wait() _tp(CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875)) until (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(CDKProgress()["Good"]) == 1
              if (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                wait(.5) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
              end
                wait(1) repeat wait() _tp(CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125)) until (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(CDKProgress()["Good"]) == 1
                if (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                wait(.5) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
                end
                  wait(1) repeat wait() _tp(CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625)) until (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(CDKProgress()["Good"]) == 1
                  if (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                    wait(.7) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"),"Check")
                    wait(.5) replicated.Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
                  end
                  wait(1)
                  elseif tonumber(CDKProgress()["Good"]) == -4 then
                    QuestTushita_1 = false
                    QuestTushita_2 = true
                    QuestTushita_3 = false
                    repeat wait()
                      _G.AutoRaidCastle = true
                    until not _G.CDK_TS or tonumber(CDKProgress()["Good"]) == 2 
                      _G.AutoRaidCastle = false         
                  elseif tonumber(CDKProgress()["Good"]) == -5 then
                    QuestTushita_1 = false
                    QuestTushita_2 = false
                    QuestTushita_3 = true
                    if workspace.Enemies:FindFirstChild("Cake Queen") then
                      for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == "Cake Queen" then
                          if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat wait()
                              Attack.Kill(v, _G.CDK_TS)
                            until not _G.CDK_TS or not v.Parent or v.Humanoid.Health <= 0 or tonumber(CDKProgress()["Good"]) == 3
                          end
                        end
                      end
                     elseif replicated:FindFirstChild("Cake Queen") and replicated:FindFirstChild("Cake Queen").Humanoid.Health > 0 then
                       _tp(replicated:FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                     else
                   if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.Map.HeavenlyDimension.Spawn.Position).Magnitude <= 1000 then
                     for i,v in pairs(workspace.Map.HeavenlyDimension.Exit:GetChildren()) do
                       Ex = i
                     end
                     if Ex == 2 then
                       repeat wait()
                         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.HeavenlyDimension.Exit.CFrame
                       until not _G.CDK_TS or tonumber(CDKProgress()["Good"]) == 3
                    end
                   repeat wait()
                     repeat wait() 
                       _tp(CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625)) 
                       for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                         if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                       end
                     until (CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5
                     wait(2)
                    _G.DoneT1 = true
                  until not _G.CDK_TS or _G.DoneT1
                  repeat wait()
                    repeat wait()
                      _tp(CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875)) 
                       for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                         if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                       end
                    until (CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5
                    wait(2) _G.DoneT2 = true
                  until _G.DoneT2 or _G.CDK_TS == false
                  repeat wait()
                    repeat task.wait() 
                      _tp(CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375)) 
                      for i, v in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                      end
                    until (CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5
                    wait(2) _G.DoneT3 = true
                  until _G.DoneT3 or _G.CDK_TS == false
                  for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if (v:FindFirstChild("HumanoidRootPart").Position - CFrame.new(-22695.7012, 5270.93652, 3814.42847, 0.11794927, 3.32185834e-08, 0.99301964, -8.73070718e-08, 1, -2.30819008e-08, -0.99301964, -8.3975138e-08, 0.11794927).Position).Magnitude <= 300 then
                      if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 then
                        repeat wait()
                          Attack.Kill(v, _G.CDK_TS)
                        until not _G.CDK_TS or v.Humanoid.Health <= 0 or not v.Parent                      
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
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.Tp_LgS then
      pcall(function()
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local best, bestDist
        for _, folder in ipairs({workspace:FindFirstChild("NPCs"), replicated:FindFirstChild("NPCs")}) do
          if folder then
            for _, v in ipairs(folder:GetChildren()) do
              if string.find(v.Name, "Legendary Sword Dealer", 1, true) then
                local ok, cf = pcall(function() return v:GetPivot() end)
                if ok then
                  local d = (cf.Position - hrp.Position).Magnitude
                  if not bestDist or d < bestDist then best, bestDist = cf, d end
                end
              end
            end
          end
        end
        if best then _tp(best) end
      end)
    end
  end
end)

-- ====================================================================
-- SWORDS & BOSSES AUTOMATION LOOPS
-- ====================================================================

spawn(function()
  while wait(Sec) do
    if _G.AutoPole then
      pcall(function()
        local v = GetConnectionEnemies("Thunder God")
	    if v then
          repeat task.wait() Attack.Kill(v, _G.AutoPole) until not _G.AutoPole or not v.Parent or v.Humanoid.Health <= 0
        else
          _tp(CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoPoleV2 then        
	   if not GetBP("Pole (1st Form)") then replicated.Remotes.CommF_:InvokeServer("LoadItem","Pole (1st Form)") end
	   if not GetBP("Pole (2nd Form)") then replicated.Remotes.CommF_:InvokeServer("LoadItem","Pole (2nd Form)") end      
	   if GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value <= 179 then _G.Level = true elseif GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value >= 180 then _G.Level = false end	   
	   if not GetBP("Rumble Fruit") then return end
	   if GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("Z") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("X") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("C") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("V") and GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("F") then
	     _G.SelectChip = nil
		 _G.Raiding = false
		 _G.Auto_Awakener = false
		if plr.Data.Fragments.Value >= 5000 then
          replicated.Remotes.CommF_:InvokeServer("Thunder God", "Talk") wait(Sec)
          replicated.Remotes.CommF_:InvokeServer("Thunder God", "Sure")
        end
        elseif replicated.Remotes.CommF_:InvokeServer("Awakener","Check") == nil or replicated.Remotes.CommF_:InvokeServer("Awakener","Check") == 0 then
          _G.SelectChip = "Rumble"
          local Buying = replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)
          if Buying then Buying:Stop() end
          _G.Raiding = true
          _G.Auto_Awakener = true
	    end	   
      end
    end)
  end
end)

spawn(function()
  while wait(.2) do
    pcall(function()
      if _G.AutoSaw then
        local v = GetConnectionEnemies("The Saw")
        if v then repeat task.wait() Attack.Kill(v, _G.AutoSaw)until _G.AutoSaw == false or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906))
        end
      end
    end)
  end
end)

spawn(function()
  while wait(.2) do
    pcall(function()
      if _G.AutoSaber and plr.Data.Level.Value >= 200 and not plr.Backpack:FindFirstChild("Saber") and not plr.Character:FindFirstChild("Saber") then
        if workspace.Map.Jungle.Final.Part.Transparency == 0 then
	      if workspace.Map.Jungle.QuestPlates.Door.Transparency == 0 then
		    if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 100 then
		      _tp(plr.Character.HumanoidRootPart.CFrame)
		      wait(0.5)
		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate1.Button.CFrame
		      wait(0.5)
		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate2.Button.CFrame
		      wait(0.5)
		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate3.Button.CFrame
	    	  wait(0.5)
		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate4.Button.CFrame
		      wait(0.5)
		      plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate5.Button.CFrame
		      wait(0.5) 
		    else
		      _tp(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279))
		    end
	      else
		    if workspace.Map.Desert.Burn.Part.Transparency == 0 then
		      if plr.Backpack:FindFirstChild("Torch") or plr.Character:FindFirstChild("Torch") then
		        EquipWeapon("Torch")
		        firetouchinterest(plr.Character.Torch.Handle,workspace.Map.Desert.Burn.Fire,0)
			    firetouchinterest(plr.Character.Torch.Handle,workspace.Map.Desert.Burn.Fire,1)
		   	    _tp(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))
		      else
		        _tp(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408))                    end
		      else
		        if replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") ~= 0 then
		          replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","GetCup")
			      wait(0.5)
			      EquipWeapon("Cup")
			      wait(0.5)
			      replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","FillCup",plr.Character.Cup)
			      wait(Sec)
			      replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") 
		        else
		 	      if replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == nil then
			        replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon")
		          elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 0 then
			        if workspace.Enemies:FindFirstChild("Mob Leader") or replicated:FindFirstChild("Mob Leader") then
			          _tp(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559))
			         for i,v in pairs(workspace.Enemies:GetChildren()) do
				       if v.Name == "Mob Leader" and Attack.Alive(v) then
				       repeat task.wait() Attack.Kill(v, _G.AutoSaber)until v.Humanoid.Health <= 0 or _G.AutoSaber == false
				       end
				     end
			       end
			     elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 1 then
			       replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon")
				   EquipWeapon("Relic")
				  _tp(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1, -5.79995607e-08, -0.481375456, 6.30572643e-08, 0.876514494))
				 end
			   end
			 end
		   end
		 else
	     if workspace.Enemies:FindFirstChild("Saber Expert") or replicated:FindFirstChild("Saber Expert") then
	       for _,v in pairs(workspace.Enemies:GetChildren()) do
		     if v.Name == "Saber Expert" and Attack.Alive(v) then
			   repeat task.wait() Attack.Kill(v, _G.AutoSaber) until v.Humanoid.Health <= 0 or _G.AutoSaber == false
		       if v.Humanoid.Health <= 0 then replicated.Remotes.CommF_:InvokeServer("ProQuestProgress","PlaceRelic") end		      
		      end
		    end
		  else
		    _tp(CFrame.new(-1401.85046, 29.9773273, 8.81916237, 0.85820812, 8.76083845e-08, 0.513301849, -8.55007443e-08, 1, -2.77243419e-08, -0.513301849, -2.00944328e-08, 0.85820812))
	      end
	    end
      end
    end)
  end
end)

spawn(function()
  while wait(.2) do
    if _G.AutoColShad then
      pcall(function()
        local v = GetConnectionEnemies("Cyborg")
	    if v then repeat task.wait()Attack.Kill(v, _G.AutoColShad)until _G.AutoColShad == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813))
        end
      end)
    end
  end
end)

spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.AutoGetUsoap then
	   for _, v in pairs(workspace.Characters:GetChildren()) do
          if v.Name ~= plr.Name then
            if v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and v.Parent and (Root.Position - v.HumanoidRootPart.Position).Magnitude <= 230 then
              repeat task.wait() EquipWeapon(_G.SelectWeapon) _tp(v.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2)) until _G.AutoGetUsoap == false or v.Humanoid.Health <= 0 or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid")
            end
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.Greybeard then
      pcall(function()
        if not GetWP("Bisento") then
          replicated.Remotes.CommF_:InvokeServer("BuyItem","Bisento")
        elseif GetWP("Bisento") then
          replicated.Remotes.CommF_:InvokeServer("LoadItem","Bisento")
          local v = GetConnectionEnemies("Greybeard")
          if v then repeat wait() Attack.Kill(v,_G.Greybeard)until _G.Greybeard == false or not v.Parent or v.Humanoid.Health <= 0
          else _tp(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375))
          end
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.WardenBoss then
      pcall(function()
        local v = GetConnectionEnemies("Chief Warden")
        if v then repeat wait() Attack.Kill(v,_G.WardenBoss) until _G.WardenBoss == false or not v.Parent or v.Humanoid.Health <= 0 
        else _tp(CFrame.new(5206.92578,0.997753382,814.976746,0.342041343,-0.00062915677,0.939684749,0.00191645394,0.999998152,-2.80422337e-05,-0.939682961,0.00181045406,0.342041939))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.MarinesCoat then
      pcall(function()
        local v = GetConnectionEnemies("Vice Admiral")
        if v then repeat wait() Attack.Kill(v, _G.MarinesCoat) until _G.MarinesCoat == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.SwanCoat then
      pcall(function()
        local v = GetConnectionEnemies("Swan")
        if v then repeat wait()Attack.Kill(v, _G.SwanCoat)until _G.SwanCoat == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812))
        end
      end)
    end
  end
end)

spawn(function()
  pcall(function()
    while wait(.1) do
      if _G.IceBossRen then
        local v = GetConnectionEnemies("Awakened Ice Admiral")
        if v then repeat task.wait()Attack.Kill(v,_G.IceBossRen)until _G.IceBossRen == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
        end
      end
    end
  end)
end)

spawn(function()
  while wait(.1) do
    pcall(function()
      if _G.KeysRen then
        if plr.Backpack:FindFirstChild(RenMon[3]) or plr.Character:FindFirstChild(RenMon[3]) then
          EquipWeapon(RenMon[3]) wait(.1)
          _tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
        else
          local v = GetConnectionEnemies(RenMon)
          if v then repeat task.wait() Attack.Kill(v,_G.KeysRen)until plr.Backpack:FindFirstChild(RenMon[3]) or _G.KeysRen == false or not v.Parent or v.Humanoid.Health <= 0
          else _tp(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(.1) do
    pcall(function()
      if _G.AutoTridentW2 then
        local v = GetConnectionEnemies("Tide Keeper")
        if v then repeat task.wait() Attack.Kill(v,_G.AutoTridentW2)until _G.AutoTridentW2 == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188))
        end
      end
    end)
  end
end)

spawn(function()
  while wait(.1) do
    pcall(function()
      if _G.LongsWord then
        local v = GetConnectionEnemies("Diamond")
        if v then repeat task.wait() Attack.Kill(v,_G.LongsWord)until _G.LongsWord == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
        end
      end
    end)
  end
end)

spawn(function()
  while wait(.1) do
    if _G.BlackSpikey then
      pcall(function()
        local v = GetConnectionEnemies("Jeremy")
        if v then repeat wait() Attack.Kill(v, _G.BlackSpikey)until _G.BlackSpikey == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.DarkBladev3 and World2 then
      if not GetBP("Dark Blade") then replicated.Remotes.CommF_:InvokeServer("LoadItem","Dark Blade") end
        if GetBP("Fist of Darkness") then
          if not workspace.Enemies:FindFirstChild("Darkbeard") then
            _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
          elseif GetConnectionEnemies("Darkbeard") and GetBP("Fist of Darkness") >= 1 then
            repeat wait() _tp(CFrame.new(-5719.36376953125, 48.50590515136719, -782.9759521484375)) until not _G.DarkBladev3 or (Root.Position == CFrame.new(-5719.36376953125, 48.50590515136719, -782.9759521484375).Position)
            fireclickdetector(workspace.Map.GraveIsland.Mountain.Rocks.Button.ClickDetector)
          end         
        else
          _G.AutoFarmChest = true;
        end        
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoEcBoss then
	    if GetM("Ectoplasm") >= 99 then
	      replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 3)	   
	    elseif GetM("Ectoplasm") <= 99 then
	      local v = GetConnectionEnemies("Cursed Captain")
	      if v then repeat wait()Attack.Kill(v, _G.AutoEcBoss) until not _G.AutoEcBoss or not v.Parent or v.Humanoid.Health <= 0
	      else
	        replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125)) wait(.5)
	        _tp(CFrame.new(916.928589, 181.092773, 33422))
	      end
	    end	
      end
    end)
  end
end)

spawn(function()
  while wait(.1) do
    if _G.Auto_Def_DarkCoat then
      pcall(function()
        if GetBP("Fist of Darkness") and not workspace.Enemies:FindFirstChild("Darkbeard") then          
          _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
        elseif GetConnectionEnemies("Darkbeard") then
          local v = GetConnectionEnemies("Darkbeard")          
		  if v then repeat wait()Attack.Kill(v,_G.Auto_Def_DarkCoat)until _G.Auto_Def_DarkCoat == false or not v.Parent or v.Humanoid.Health <= 0 end
        elseif not GetBP("Fist of Darkness") and not GetConnectionEnemies("Darkbeard") then
          repeat wait(.1) _G.AutoFarmChest = true until not _G.Auto_Def_DarkCoat or GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard") _G.AutoFarmChest = false
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.Auto_DonAcces then
      pcall(function()
        if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil and plr.Data.Level.Value >= 1500 then
          FruitPrice = {}
	      FruitStore = {}
		  for i,v in next,replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
		    if v.Price >= 1000000 then  
		     table.insert(FruitPrice,v.Name)
		    end
		  end
		  for i,v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
		    for _,x in pairs(v) do
		      if _ == "Name" then 
		        table.insert(FruitStore,x)
		      end
	        end
	          replicated.Remotes.CommF_:InvokeServer("Cousin","Buy")
	          for _,y in pairs(FruitPrice) do
		        for _,z in pairs(FruitStore) do
		          if y == z and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
		            _G.StoreF = false
			      if not plr.Backpack:FindFirstChild(FruitStore) then
			        replicated.Remotes.CommF_:InvokeServer("LoadFruit",tostring(y))
			      else
			        replicated.Remotes.CommF_:InvokeServer("TalkTrevor","1")
			        replicated.Remotes.CommF_:InvokeServer("TalkTrevor","2")
			        replicated.Remotes.CommF_:InvokeServer("TalkTrevor","3")
			      end
			    end
		      end 
		    end
		    if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
		      _G.StoreF = true
		      _G.Auto_DonAcces = false
		    end
	      end
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.2) do
    if _G.Auto_SwanGG then
      pcall(function()
        local v = GetConnectionEnemies("Don Swan")
        if v then repeat wait() Attack.Kill(v,_G.Auto_SwanGG)until _G.Auto_SwanGG == false or not v.Parent or v.Humanoid.Health <= 0
	    else _tp(CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoBigmom then
      pcall(function()
        local bx = GetConnectionEnemies("Cake Queen")
        if bx then repeat task.wait() Attack.Kill(bx, _G.AutoBigmom) until not _G.AutoBigmom or not bx.Parent or bx.Humanoid.Health <= 0
        else _tp(CFrame.new(-709.3132934570312, 381.6005859375, -11011.396484375))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Cavender then
        local v = GetConnectionEnemies("Beautiful Pirate")
	    if v then repeat wait() Attack.Kill(v,_G.Auto_Cavender)until not _G.Auto_Cavender or v.Humanoid.Health <= 0
	    else _tp(CFrame.new(5283.609375,22.56223487854,-110.78285217285))
	    end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TwinHook then
        local v = GetConnectionEnemies("Captain Elephant")
	    if v then repeat wait()Attack.Kill(v,_G.TwinHook)until not _G.TwinHook or v.Humanoid.Health <= 0
	    else
          replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)) wait(.2)
          _tp(CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125))
	    end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoSerpentBow then
      local v = GetConnectionEnemies("Hydra Leader")
      if v then	repeat wait() Attack.Kill(v,_G.AutoSerpentBow)until not _G.AutoSerpentBow or not v.Parent or v.Humanoid.Health <= 0
	  else _tp(CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547))
      end
    end
  end
end)

spawn(function()
  while wait(.2) do
    if _G.AutoKilo then
      pcall(function()
        local v = GetConnectionEnemies("Kilo Admiral")
        if v then repeat task.wait()Attack.Kill(v,_G.AutoKilo)until not _G.AutoKilo or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125))
        end
      end)
    end
  end
end)





spawn(function()
  while wait() do
    if _G.Tp_MasterA then
	  pcall(function()
	    for _,v in pairs(replicated.NPCs:GetChildren()) do
	    if v.Name == "Barista Cousin" then _tp(v.HumanoidRootPart.CFrame) end
        end   	   
	 end)
    end
  end
end)

spawn(function()
  pcall(function()
    while wait(Sec) do
      if _G.Auto_Rainbow_Haki then
        if plr.PlayerGui.Main.Quest.Visible == false then
          if _G.GetQFast then
            if plr.PlayerGui.Main.Quest.Visible == false then replicated.Remotes.CommF_:InvokeServer("HornedMan","Bet") end     
          else
            Rainbow1 = CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875)
            if (plr.Character.HumanoidRootPart.CFrame ~= Rainbow1) then
              _tp(Rainbow1)
            elseif (plr.Character.HumanoidRootPart.CFrame == Rainbow1) then
              wait(1)
              replicated.Remotes.CommF_:InvokeServer("HornedMan","Bet")
            end
          end
          elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
            local v = GetConnectionEnemies("Stone")
            if v then
              repeat wait() Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              _tp(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
            end
          elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
            local v = GetConnectionEnemies("Hydra Leader")
            if v then
              repeat task.wait()Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
              local framelong1 = Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625)
              local framelong2 = CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)
              if (plr.Character.HumanoidRootPart.CFrame.Position == framelong1) then _tp(framelong2)end
            end
          elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
            local v = GetConnectionEnemies("Kilo Admiral")
            if v then
              repeat task.wait()Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              _tp(CFrame.new(2877.61743, 423.558685, -7207.31006, -0.989591599, -0, -0.143904909, -0, 1.00000012, -0, 0.143904924, 0, -0.989591479))
            end
            elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
              local v = GetConnectionEnemies("Captain Elephant")
              if v then
                repeat task.wait() Attack.Kill(v,_G.Auto_Rainbow_Haki)until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
              else
              local gamergayror1 = Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)
              local gamergayror2 = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
              if (plr.Character.HumanoidRootPart.CFrame.Position ~= gamergayror1) then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
              elseif (plr.Character.HumanoidRootPart.CFrame.Position == gamergayror1) then
                _tp(gamergayror2)
              end
            end
        elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
          local v = GetConnectionEnemies("Captain Elephant")
          if v then
            repeat task.wait() Attack.Kill(v,_G.Auto_Rainbow_Haki) until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
          else
            replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
          end
        end                  
      end
    end    
  end)
end)

spawn(function()
  while wait(.2) do
    pcall(function()
      if _G.obsFarm then        
        replicated.Remotes.CommE:FireServer("Ken",true)
        if plr:GetAttribute("KenDodgesLeft") == 0 then
          KenTest = false
        elseif plr:GetAttribute("KenDodgesLeft") > 0 then
          replicated.Remotes.CommE:FireServer("Ken",true)
          KenTest = true
        end        
      end
    end)
  end
end)    

spawn(function()      
  while wait(.2) do
    pcall(function()
      if _G.obsFarm then
        if World1 then
          if workspace.Enemies:FindFirstChild("Galley Captain") then
            if KenTest then
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
              until _G.obsFarm == false or KenTest == false
            else
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(0,50,0)
              until _G.obsFarm == false or KenTest
            end
          else
            _tp(CFrame.new(5533.29785, 88.1079102, 4852.3916))
          end
        elseif World2 then
          if workspace.Enemies:FindFirstChild("Lava Pirate") then
            if KenTest then
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
              until _G.obsFarm == false or KenTest == false
            else
              repeat wait()
                plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(0,50,0)
              until _G.obsFarm == false or KenTest
            end
          else
            _tp(CFrame.new(-5478.39209, 15.9775667, -5246.9126))
          end
        elseif World3 then
          if workspace.Enemies:FindFirstChild("Venomous Assailant") then
            if KenTest then
              repeat wait()
                _tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(3,0,0))
              until _G.obsFarm == false or KenTest == false
            else
              repeat wait()
                _tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(0,50,0))
              until _G.obsFarm == false or KenTest
            end
          else
            _tp(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789))
          end
        end        
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoKenVTWO then
      pcall(function()
      local Kv2Pos1 = CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)
      local Kv2Pos2 = "Kuy"
      local Kv2Pos3 = CFrame.new(-10920.125, 624.20275878906, -10266.995117188)
      local Kv2Pos4 = CFrame.new(-13277.568359375, 370.34185791016, -7821.1572265625)
      local Kv2Pos5 = CFrame.new(-13493.12890625, 318.89553833008, -8373.7919921875)
	  if plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Defeat 50 Forest Pirates") then
	    local v = GetConnectionEnemies("Forest Pirate")
        if v then
	      repeat wait() Attack.Kill(v,_G.AutoKenVTWO) until not _G.AutoKenVTWO or v.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false
	    else
	      _tp(Kv2Pos4)
	    end
	  elseif plr.PlayerGui.Main.Quest.Visible == true then 
	    local v = GetConnectionEnemies("Captain Elephant")
	    if v then
          repeat wait() Attack.Kill(v,_G.AutoKenVTWO) until not _G.AutoKenVTWO or v.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false
	    else
	      _tp(Kv2Pos5)
	    end
	  elseif plr.PlayerGui.Main.Quest.Visible == false then
	    replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") wait(.1)
	    replicated.Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)
	  end
	  if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") == 2 then
	    _tp(CFrame.new(-12513.51953125, 340.1137390136719, -9873.048828125))
	  end
	  if not plr.Backpack:FindFirstChild("Fruit Bowl") or not plr.Character:FindFirstChild("Fruit Bowl") then
	  if not GetBP("Fruit Bowl") then   	    
	    if not GetBP("Apple") then
	      replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
	      for i,v in pairs(workspace:GetDescendants()) do
	        if v.Name == "Apple" then
	          v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10) wait()
		      firetouchinterest(plr.Character.HumanoidRootPart,v.Handle,0) wait()		    
	        end
	      end
	    elseif not GetBP("Banana") then
	      _tp(CFrame.new(2286.0078125,73.13391876220703,-7159.80908203125))
	      for i,v in pairs(workspace:GetDescendants()) do
	        if v.Name == "Banana" then
	          v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10) wait()
		      firetouchinterest(plr.Character.HumanoidRootPart,v.Handle,0) wait()		    
	        end
	      end	    
	    elseif not GetBP("Pineapple") then
	      _tp(CFrame.new(-712.8272705078125,98.5770492553711,5711.9541015625))
	      for i,v in pairs(workspace:GetDescendants()) do
	        if v.Name == "Pineapple" then
	          v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10) wait()
		      firetouchinterest(plr.Character.HumanoidRootPart,v.Handle,0) wait()		    
	        end
	      end	    
	    end	  
	  end  	    	    
	    if plr.Backpack:FindFirstChild("Banana") and plr.Backpack:FindFirstChild("Apple") and plr.Backpack:FindFirstChild("Pineapple") or plr:FindFirstChild("Banana") and plr:FindFirstChild("Apple") and plr:FindFirstChild("Pineapple") then
	      repeat wait() _tp(Kv2Pos1) until _G.AutoKenVTWO or plr.Character.HumanoidRootPart.CFrame == Kv2Pos1
		  replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")	    			 
	    end
	      if plr.Backpack:FindFirstChild("Fruit Bowl") or plr.Character:FindFirstChild("Fruit Bowl") then
	        if plr.Character.HumanoidRootPart.CFrame ~= Kv2Pos3 then _tp(Kv2Pos3)
		    elseif plr.Character.HumanoidRootPart.CFrame == Kv2Pos3 then
		      replicated.Remotes.CommF_:InvokeServer("KenTalk2","Start") wait(.1)
		      replicated.Remotes.CommF_:InvokeServer("KenTalk2","Buy")
	        end			 		    
	      end
	    end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do    
    pcall(function()
      if _G.Bartilo_Quest and Lv >= 850 then
      local Qbart = plr.PlayerGui.Main.Quest
        if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
          _G.Level = false
          if Qbart.Visible == true then
            local v = GetConnectionEnemies("Swan Pirate")
            if v then
              local x = GetConnectionEnemies(BartMon)
              if x then
                repeat task.wait()
                  if not string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirate")then replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                  else Attack.Kill(x,_G.Bartilo_Quest)end
                until _G.Bartilo_Quest == false or not x.Parent or x.Humanoid.Health <= 0 or Qbart.Visible == false or not x:FindFirstChild("HumanoidRootPart")                  
              end
            else
              _tp(CFrame.new(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468))
            end
          else
            repeat wait() 
              _tp(CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312))
            until (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 20 or _G.Bartilo_Quest == false
            if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then
              replicated.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest",1)
            end
          end
          elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
            _G.Level = false
            local je = GetConnectionEnemies("Jeremy")
            if je then
              repeat task.wait() Attack.Kill(je,_G.Bartilo_Quest) until _G.Bartilo_Quest == false or not je.Parent or je.Humanoid.Health <= 0 or Qbart.Visible == false or not je:FindFirstChild("HumanoidRootPart")                  
            else
              _tp(CFrame.new(2158.97412, 449.056244, 705.411682, -0.754199564, -4.17389057e-09, -0.656645238, -4.47752875e-08, 1, 4.50709301e-08, 0.656645238, 6.3393955e-08, -0.754199564))
            end
          elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
          repeat wait() _tp(CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456))until (CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 or _G.Bartilo_Quest == false
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
          wait(0.5)
          plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
          wait(2.5)
        end
      end
    end)
  end
end)

spawn(function()	
  while wait(Sec) do
    pcall(function()
      if _G.CitizenQuest then
        if Lv >= 1800 and replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits == false then
          if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then
            local v = GetConnectionEnemies("Forest Pirate")
            if v then
              repeat task.wait() Attack.Kill(v,_G.CitizenQuest)until _G.CitizenQuest == false or not v.Parent or v.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false
            else
              _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
            end
          else
            _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
            if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - plr.Character.HumanoidRootPart.Position).Magnitude <= 30 then
              wait(1.5) replicated.Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)
            end
          end
        elseif Lv >= 1800 and replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss == false then
          local v = GetConnectionEnemies("Captain Elephant")
          if plr.PlayerGui.Main.Quest.Visible and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and plr.PlayerGui.Main.Quest.Visible == true then
            if v then
              repeat task.wait() Attack.Kill(v,_G.CitizenQuest) until _G.CitizenQuest == false or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
            else
              _tp(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))
            end
          else
            _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
            if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 4 then
              wait(1.5)
              replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")
            end
          end
        elseif Lv >= 1800 and replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") == 2 then
          _tp(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.DummyMan then
      pcall(function()
        if plr.PlayerGui.Main.Quest.Visible == false then	
          local xxx = {[1] = "ArenaTrainer"}
	      replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(xxx))
        else
          local v = GetConnectionEnemies("Training Dummy")
          if v then
		    repeat wait() Attack.Kill(v,_G.DummyMan) until not _G.DummyMan or not v.Parent or v.Humanoid.Health <= 0
	      else
	        _tp(CFrame.new(3688.005126953125, 12.746943473815918, 170.20953369140625))
	      end
	    end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_SuperHuman then
      local M_Beli = plr.Data.Beli.Value
	  local M_Frag = plr.Data.Fragments.Value
        if plr:FindFirstChild("WeaponAssetCache") then
          if not GetBP("Superhuman") then                    
            if not GetBP("Black Leg") then
            if (M_Beli >= 150000) then replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
            elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 299 then _G.Level = true elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 300 then _G.Level = false end                        
            if not GetBP("Electro") then
            if (M_Beli >= 500000) then replicated.Remotes.CommF_:InvokeServer("BuyElectro") end
            elseif GetBP("Electro") and GetBP("Electro").Level.Value < 299 then _G.Level = true elseif GetBP("Electro") and GetBP("Electro").Level.Value >= 300 then _G.Level = false end                        
            if not GetBP("Fishman Karate") then
            if (M_Beli >= 750000) then replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
            elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 299 then _G.Level = true elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 300 then _G.Level = false end                        
            if not GetBP("Dragon Claw") then
            if (M_Frag >= 1500) then replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end
            elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 299 then _G.Level = true elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 300 then _G.Level = false end
            replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")          
          end
        end        
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoDeathStep then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then  
          if not GetBP("Death Step") then          
            if not GetBP("Black Leg") then replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
            if GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("BuyDeathStep") _G.Level = false elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 399 then _G.Level = true end
            if GetBP("Black Leg") or GetBP("Black Leg").Level.Value >= 400 then
            if workspace.Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor.Transparency == 0 then            
              if GetBP("Library Key") then repeat wait() _tp(CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375)) until not _G.AutoDeathStep or (Root.Position == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position)
		        if (Root.CFrame == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375)) then replicated.Remotes.CommF_:InvokeServer("BuyDeathStep") end     
		        elseif not GetBP("Library Key") then
		          local v = GetConnectionEnemies("Awakened Ice Admiral")
		          if v then	repeat wait() Attack.Kill(v,_G.AutoDeathStep) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoDeathStep == false or GetBP("Library Key") or GetBP("Death Step")
	              else _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
	              end
		        end		    
              end
            end          
          end
        end
      end)
    end
  end
end)

spawn(function() 
  while wait(Sec) do
    if _G.Auto_SharkMan_Karate then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then  
          if not GetBP("Sharkman Karate") then          
            if not GetBP("Fishman Karate") then replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
            if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate") _G.Level = false elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 399 then _G.Level = true end
            if GetBP("Fishman Karate") or GetBP("Fishman Karate").Level.Value >= 400 then           
              if GetBP("Water Key") then
		        if string.find(replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate"), "keys") then  
			      if GetBP("Water Key") then
			        repeat wait() _tp(CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365)) until not _G.Auto_SharkMan_Karate or (Root.Position == CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365).Position)
	                replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
		          end
		        end
		      elseif not GetBP("Water Key") then
		        local v = GetConnectionEnemies("Tide Keeper")
		        if v then repeat wait() Attack.Kill(v,_G.Auto_SharkMan_Karate)until not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_SharkMan_Karate == false or GetBP("Water Key") or GetBP("Sharkman Karate")		
	            else _tp(CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625))
	            end
		      end		                  
            end          
          end
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.Auto_Electric_Claw then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then 
        if not GetBP("Electro") then replicated.Remotes.CommF_:InvokeServer("BuyElectro") end        
          if GetBP("Electro") and GetBP("Electro").Level.Value >= 400 then
            if replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start") == nil then notween(CFrame.new(-12548, 337, -7481)) end
            replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
          elseif GetBP("Electro") and GetBP("Electro").Level.Value < 400 then
            repeat _G.AutoFarm_Bone = true wait() until not _G.Auto_Electric_Claw or GetBP("Electric Claw") _G.AutoFarm_Bone = false
          end
        end       
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoDragonTalon then
      pcall(function()
        if plr:FindFirstChild("WeaponAssetCache") then 
        if not GetBP("Dragon Claw") then replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end        
          if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
          elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 400 then repeat _G.AutoFarm_Bone = true wait() until not _G.AutoDragonTalon or GetBP("Dragon Talon") _G.AutoFarm_Bone = false
          end         
        end
      end)
    end
  end
end)

spawn(function()
  while wait() do
    pcall(function()
      if _G.Auto_God_Human then
        if replicated.Remotes.CommF_:InvokeServer("BuyGodhuman",true) == "Bring me 20 Fish Tails, 20 Magma Ore, 10 Dragon Scales and 10 Mystic Droplets." then
          if GetM("Dragon Scale") == false or GetM("Dragon Scale") < 10 then
            if World3 then
              Lv = 1575
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelZou")
            end
          elseif GetM("Fish Tail") == false or GetM("Fish Tail") < 20 then
            if World3 then
              Lv = 1775
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelZou")
            end
          elseif GetM("Mystic Droplet") == false or GetM("Mystic Droplet") < 10 then
            if World2 then
              Lv = 1425
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
          elseif GetM("Magma Ore") == false or GetM("Magma Ore") < 20 then
            if World2 then
              Lv = 1175
              _G.Level = true
            else
              replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end  
          end
        elseif replicated.Remotes.CommF_:InvokeServer("BuyGodhuman",true) == 3 then
          return nil
        else
          replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.Snaguine then
      pcall(function()
        if not GetBP("Sanguine Art") then replicated.Remotes.CommF_:InvokeServer("Sanguine Art") end
        if not GetBP("Sanguine Art") then
          if GetM("Leviathan Heart") >= 1 then print("Completed!!")
          else
          if World3 then _G.DangerSc = "Lv Infinite" _G.SailBoats = true; else _G.SailBoats = false; end end
          if GetM("Vampire Fang") <= 19 then
            if World2 then
              local n = GetConnectionEnemies("Vampire")
              if n then repeat task.wait() Attack.Kill(n,_G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
              else _tp(CFrame.new(-6041.29248046875, 6.402710914611816, -1304.63330078125))
              end
            else
              replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
          end                                      
          if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") <= 19 then
            if World3 then
              local n = GetConnectionEnemies("Demonic Soul")
		      if n then repeat task.wait() Attack.Kill(n,_G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
              else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
              end
             else
               replicated.Remotes.CommF_:InvokeServer("TravelZou")
             end
           end
           if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") >= 20 and GetM("Dark Fragment") <= 1 then
             if World2 then
               local n = GetConnectionEnemies("Darkbeard")
		       if n then repeat task.wait() Attack.Kill(n,_G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
		      else _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
		      end
		    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
	        end
          end
        else replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")
        end
      end)
    end
  end
end)

spawn(function()
  while wait() do
    if _G.FindMirage then 
      pcall(function()
        if not workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island", true) then                
          local myBoat = CheckBoat()
          if not myBoat then
            local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
            TeleportToTarget(buyBoatCFrame)
            if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end
          else
            if plr.Character.Humanoid.Sit == false then
              local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
              _tp(boatSeatCFrame)
            else            
              repeat wait()
                local targetDestination = CFrame.new(-10000000, 31, 37016.25)
                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                  _tp(CFrame.new(-10000000, 150, 37016.25))
                else
                  _tp(CFrame.new(-10000000, 31, 37016.25))
                end
              until not _G.FindMirage or (targetDestination.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false plr.Character.Humanoid.Sit = false
            end
          end
        else
          _tp(workspace.Map:FindFirstChild("MysticIsland").Center.CFrame*CFrame.new(0,300,0))
        end
      end)
    end
  end
end)

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.AutoMysticIsland then
                for _, location in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
                    if location.Name == "Mirage Island" then
                        topos(location.CFrame * CFrame.new(0, 333, 0))
                    end
                end
            end
        end)
    end
end)

spawn(function()
  while wait(Sec) do
    if _G.HighestMirage then 
      pcall(function()
      if workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island",true) then _tp(workspace.Map:FindFirstChild("MysticIsland").Center.CFrame*CFrame.new(0,400,0))end
      end)
    end
  end
end)

spawn(function()
  pcall(function()
    while wait(0.1) do
      if _G.TPGEAR then
        for i,v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
          if v.Name == "Part" then
            if v.ClassName == "MeshPart" then _tp(v.CFrame) end
          end
        end
      end
    end
  end)
end)

spawn(function()
  pcall(function()
    while wait(Sec) do
      if _G.can then
        for i,v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
          if v.Name == "Part" then
            if v.ClassName == "MeshPart" then
              v.Transparency = 0
            else 
              v.Transparency = 1
            end
          end
        end
      end
    end
  end)
end)

spawn(function()
  while wait() do
    if _G.Addealer then
	  pcall(function()
	    for _,v in pairs(replicated.NPCs:GetChildren()) do
	    if v.Name == "Advanced Fruit Dealer" then _tp(v.HumanoidRootPart.CFrame) end
        end   	   
	 end)
    end
  end
end)

spawn(function()
  while wait(.2) do
    if _G.FarmChestM then
      pcall(function()
        if workspace.Map:FindFirstChild("MysticIsland").Chests:FindFirstChild("DiamondChest") or workspace.Map:FindFirstChild("MysticIsland").Chests:FindFirstChild("FragChest") then
          local CollectionService = game:GetService("CollectionService")
          local Players = game:GetService("Players")
          local Player = Players.LocalPlayer
          local Character = Player.Character or Player.CharacterAdded:Wait()                
          if not Character then return end                
          local Position = Character:GetPivot().Position
          local Chests = CollectionService:GetTagged("_ChestTagged")      
          local Distance, Nearest = math.huge, nil  
          for i = 1, #Chests do
            local Chest = Chests[i]
            local Magnitude = (Chest:GetPivot().Position - Position).Magnitude        
            if not SelectedIsland or Chest:IsDescendantOf(SelectedIsland) then
              if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
                Distance = Magnitude
                Nearest = Chest
              end
            end
          end
        if Nearest then _tp(Nearest:GetPivot()) end
        end
      end)
    end
  end
end)

function MoveCamtoMoon()
workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,Lighting:GetMoonDirection() + workspace.CurrentCamera.CFrame.Position)
plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position,Lighting:GetMoonDirection() + plr.Character.HumanoidRootPart.CFrame.Position)
end

task.spawn(function()
  while task.wait() do
    if LookM then
      MoveCamtoMoon()
      wait(.1)
      replicated.Remotes.CommE:FireServer("ActivateAbility")
    end
  end
end)

function MoveCamtoMoon()
    local moonDir = Lighting:GetMoonDirection()
    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDir)
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDir)
end

task.spawn(function()
    while task.wait(0.1) do
        if LookMV3 then
            MoveCamtoMoon()
            replicated.Remotes.CommE:FireServer("ActivateAbility")            
            UIS:SendKeyEvent(true, "T", false, game)
            wait(0.5)
            UIS:SendKeyEvent(false, "T", false, game)
        end
    end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Mink then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= 2 then
          if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
            replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
          elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
            if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
              _tp(workspace.Flower1.CFrame)
            elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
              _tp(workspace.Flower2.CFrame)
            elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
              local v = GetConnectionEnemies("Swan Pirate")
              if v then repeat wait() Attack.Kill(v,_G.Auto_Mink) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Mink == false
              else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))end            
            end        
          elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
	        replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
	      end
        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
          replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
		  _G.AutoFarmChest = true
	    else
	      _G.AutoFarmChest = false
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Human then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then
	     if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
		  replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
		elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
		  if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
		    _tp(workspace.Flower1.CFrame)
		  elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
		    _tp(workspace.Flower2.CFrame)
		  elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
		    local v = GetConnectionEnemies("Swan Pirate")
            if v then repeat wait() Attack.Kill(v,_G.Auto_Human) until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Human == false
		    else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))end
		  end
		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
		    replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
		  end
		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
		    replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
		  local v = GetConnectionEnemies(Human_v3_Mob[1])
          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           
	      else _tp(CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625))
		  end		      
		  local v = GetConnectionEnemies(Human_v3_Mob[2])
          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           
	      else _tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
		  end		      
		  local v = GetConnectionEnemies(Human_v3_Mob[3])
          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           
          else _tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
	      end		      		
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Skypiea then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then
	      if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
		    replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
		    if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
		      _tp(workspace.Flower1.CFrame)
		    elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
		      _tp(workspace.Flower2.CFrame)
		    elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
		      local v = GetConnectionEnemies("Swan Pirate")
		      if v then
			    repeat wait()Attack.Kill(v,_G.Auto_Skypiea)until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Skypiea == false
		      else
		        _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
		      end
		    end
	      elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
            replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
          end
		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
	        replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
	    elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
	      for i,v in pairs(game.Players:GetChildren()) do
            if v.Name ~= plr.Name and tostring(v.Data.Race.Value) == "Skypiea" then
		      repeat task.wait() _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,8,0) * CFrame.Angles(math.rad(-45),0,0))until v.Humanoid.Health <= 0 or _G.Auto_Skypiea == false
	        end
	      end
        end          
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Fish then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then
	      if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
		    replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
	        if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
		      _tp(workspace.Flower1.CFrame)
	        elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
	          _tp(workspace.Flower2.CFrame)
	        elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
	          local v = GetConnectionEnemies("Swan Pirate")
		      if v then
			    repeat wait()Attack.Kill(v,_G.Auto_Fish)until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Fish == false
	          else
		       _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
	          end
            end
	      elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
            replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
          end
        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
	      replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
	    elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
          warn("Sea Beast Soon")
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.Lver then
      pcall(function()
        for x,c in pairs(workspace.Map["Temple of Time"]:GetDescendants()) do
        if c.Name == "ProximityPrompt" then fireproximityprompt(c,math.huge)end
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AcientOne then
        local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}
	    for i=1,#BonesTable do
          if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
            vim1:SendKeyEvent(true, "Y", false, game)
            replicated.Remotes.CommF_:InvokeServer("UpgradeRace","Buy")
            _tp(CFrame.new(-8987.041015625, 215.862060546875, 5886.71044921875))
	      elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then
	        local v = GetConnectionEnemies(BonesTable)
	        if v then repeat wait() Attack.Kill(v, _G.AcientOne) until _G.AcientOne == false or v.Humanoid.Health <= 0 or not v.Parent
		    else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
		    end
	      end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TPDoor then
	    if tostring(plr.Data.Race.Value) == "Mink" then
          _tp(CFrame.new(29020.66015625, 14889.4267578125, -379.2682800292969))
	    elseif tostring(plr.Data.Race.Value) == "Fishman" then
          _tp(CFrame.new(28224.056640625, 14889.4267578125, -210.5872039794922))
	    elseif tostring(plr.Data.Race.Value) == "Cyborg" then
          _tp(CFrame.new(28492.4140625, 14894.4267578125, -422.1100158691406))
	    elseif tostring(plr.Data.Race.Value) == "Skypiea" then
          _tp(CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188))
	    elseif tostring(plr.Data.Race.Value) == "Ghoul" then
          _tp(CFrame.new(28672.720703125, 14889.1279296875, 454.5961608886719))
	    elseif tostring(plr.Data.Race.Value) == "Human" then
          _tp(CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938))
	    end
      end
    end)
  end
end)                   

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Complete_Trials then
        if tostring(plr.Data.Race.Value) == "Mink" then
          notween(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0,-20,0))
	   end
      end
    end)
  end
end)

GetSeaBeastTrial = function()
  if not workspace.Map:FindFirstChild("FishmanTrial") then return nil end
  if workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") then FishmanTrial = workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") end
  if FishmanTrial then
    for _,v in next, workspace.SeaBeasts:GetChildren() do
      if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - FishmanTrial.Position).Magnitude <= 1500 then
        if v.Health.Value > 0 then return v end
      end
    end
  end
end

spawn(function()
  while wait(Sec) do
    pcall(function() 
      if _G.Complete_Trials then
	    if tostring(plr.Data.Race.Value) == "Fishman" then
	      if GetSeaBeastTrial() then            
            repeat task.wait()
              spawn(function()_tp(CFrame.new(GetSeaBeastTrial().HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 300,GetSeaBeastTrial().HumanoidRootPart.Position.Z))end)
		      MousePos = GetSeaBeastTrial().HumanoidRootPart.Position
              Useskills("Melee","Z")
	          Useskills("Melee","X")
	          Useskills("Melee","C")
              wait(.1)
              Useskills("Sword","Z")
              Useskills("Sword","X")
              wait(.1)
              Useskills("Blox Fruit","Z")
              Useskills("Blox Fruit","X")
              Useskills("Blox Fruit","C")
              wait(.1)
              Useskills("Gun","Z")
              Useskills("Gun","X")
            until _G.Complete_Trials == false or not GetSeaBeastTrial()
          end          
	    end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Complete_Trials then
        if tostring(plr.Data.Race.Value) == "Cyborg" then
         _tp(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0,500,0))
   	   end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Complete_Trials then
        if tostring(plr.Data.Race.Value) == "Skypiea" then
          notween(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
  	   end
      end
    end)
  end
end)

spawn(function()
  while wait(.1) do   
    pcall(function()
      if _G.Complete_Trials then
	    if tostring(plr.Data.Race.Value) == "Human" or tostring(plr.Data.Race.Value) == "Ghoul" then	      
	      local TrialsTables = {"Ancient Vampire","Ancient Zombie"}
	      local v = GetConnectionEnemies(TrialsTables)
          if v then repeat wait() Attack.Kill(v, _G.Complete_Trials)until _G.Complete_Trials == false or not v.Parent or v.Humanoid.Health <= 0 end		
        end
      end
    end)
  end
end)

spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.Defeating then
	    for _, v in pairs(workspace.Characters:GetChildren()) do
          if v.Name ~= plr.Name then
            if v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and v.Parent and (Root.Position - v.HumanoidRootPart.Position).Magnitude <= 250 then
              repeat task.wait() EquipWeapon(_G.SelectWeapon) _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,0,15)) sethiddenproperty(plr, "SimulationRadius", math.huge)until _G.Defeating == false or v.Humanoid.Health <= 0 or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid")
            end
          end
        end
      end
    end)
  end
end)

function printBeltName(data) if type(data) == "table" and data.Quest["BeltName"] then return data.Quest["BeltName"] end end

spawn(function()
  while wait(Sec) do
    if _G.Dojoo then
      pcall(function()
        local args = {[1] = {["NPC"] = "Dojo Trainer",["Command"] = "RequestQuest"}}        
        local progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
        local NameBelt = printBeltName(progress)
        
        if debug == false and not progress and not NameBelt then
          _tp(CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875))
          debug = true
        elseif debug == true and (CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 50 then
          if NameBelt == "White" then
            local v = GetConnectionEnemies("Skull Slayer")
            if v then 
              repeat task.wait() 
                Attack.Kill(v, _G.Dojoo) 
                progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
              until not progress or not _G.Dojoo or not Attack.Alive(v)
            else 
              _tp(CFrame.new(-16759.58984375, 71.28376770019531, 1595.3399658203125))
            end
          elseif NameBelt == "Yellow" then
            repeat task.wait(1)
              _G.SeaBeast1 = true
              _G.TerrorShark = true
              _G.Shark = true
              _G.Piranha = true
              _G.MobCrew = true
              _G.FishBoat = true
              _G.SailBoats = true
              progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
            until not _G.Dojoo or not progress
            _G.SeaBeast1 = false
            _G.TerrorShark = false
            _G.Shark = false
            _G.Piranha = false
            _G.MobCrew = false
            _G.FishBoat = false
            _G.SailBoats = false               
          elseif NameBelt == "Green" then
            repeat task.wait(1)
              _G.SailBoats = true
              progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
            until not _G.Dojoo or not progress
            _G.SailBoats = false
          elseif NameBelt == "Purple" then
            repeat task.wait(1)
              _G.FarmEliteHunt = true
              progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
            until not _G.Dojoo or not progress
            _G.FarmEliteHunt = false
          elseif NameBelt == "Red" then
            repeat task.wait(1)
              _G.SailBoats = true
              _G.FishBoat = true
              progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
            until not _G.Dojoo or not progress
            _G.SailBoats = false
            _G.FishBoat = false                      
          elseif NameBelt == "Black" then
            repeat task.wait(1)              
              local pIsland = workspace.Map:FindFirstChild("PrehistoricIsland")
              if pIsland or workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then    
                _G.Prehis_Find = true                   
                if pIsland and pIsland:FindFirstChild("Core") and pIsland.Core:FindFirstChild("ActivationPrompt") and pIsland.Core.ActivationPrompt:FindFirstChild("ProximityPrompt",true) then
                  _G.Prehis_Skills = false
                  _G.Prehis_Find = true
                else
                  _G.Prehis_Skills = true
                  _G.Prehis_Find = false
                end
              else
                _G.Prehis_Find = true
                _G.Prehis_Skills = false
              end
              progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
            until not _G.Dojoo or not progress
            _G.Prehis_Find = PrehisUser.Find
            _G.Prehis_Skills = PrehisUser.Skills
          elseif NameBelt == "Orange" or NameBelt == "Blue" then
            return nil
          end
        end
        if not progress then
          debug = false
          local args = {[1] = {["NPC"] = "Dojo Trainer",["Command"] = "ClaimQuest"}}
          replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
        end
      end)
    end
  end
end)

checkQuesta = function()
  local a = {[1] = {["Context"] = "Check"}}
  local b = nil
  pcall(function()
    local c = {[1] = {["Context"] = "RequestQuest"}}
    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(c))
  end)
  local d, e = pcall(function()
    b = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(a))
  end)
  local f = false
  local g, h, i
  if b and b.Text then
    f = true
    local j = b.Text
    if string.find(tostring(j), "Defeat") then
      i = 1
      g = tonumber(string.sub(tostring(j), 8, 9))
      local k = {"Hydra Enforcer", "Venomous Assailant"}
      for l, m in pairs(k) do
        if string.find(j, m) then h = m; break end
      end
    elseif string.find(tostring(j), "Destroy") then
      g = 10
      i = 2
      h = nil
    end
  end
  return f, h, g, i
end

BackTODoJo = function()
  for a, b in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren()) do
    if b.Name == "NotificationTemplate" and string.find(b.Text, "Head back to the Dojo to complete more tasks") then
      return true
    end
  end
  return false
end

DragonMobClear = function(a, b, c)
  if workspace.Enemies:FindFirstChild(b) then
    for d, e in pairs(workspace.Enemies:GetChildren()) do
      if e.Name == b and Attack.Alive(e) then
        if a then Attack.Kill(e, a) end
      end
    end
  else
    _tp(c)
  end
end

GetQuestDracoLevel = function()
  local v371 = {[1] = {NPC = "Dragon Wizard", Command = "Upgrade"}}
  return replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371))
end

spawn(function()
  while wait() do 
    if _G.FarmBlazeEM then
      pcall(function()              
        local a,v,h,x = checkQuesta()                  
        if a == true and not BackTODoJo() then
          if x == 1 then
            if v == "Hydra Enforcer" or v == "Venomous Assailant" then            
              repeat wait()
                DragonMobClear(true, v, CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))
              until not _G.FarmBlazeEM or not a or BackTODoJo()                            
            end      
          elseif x == 2 then
            if workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true) then
              repeat wait()                
                spawn(function() _tp(workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).CFrame * CFrame.new(4,0,0)) end)
                if (workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position - Root.Position).Magnitude <= 200 then
                MousePos = workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position
                Useskills("Melee","Z")
	            Useskills("Melee","X")
	            Useskills("Melee","C")
                wait(.5)
                Useskills("Sword","Z")
                Useskills("Sword","X")
                wait(.5)
                Useskills("Blox Fruit","Z")
                Useskills("Blox Fruit","X")
                Useskills("Blox Fruit","C")
                wait(.5)
                Useskills("Gun","Z")
                Useskills("Gun","X")
                end
              until not _G.FarmBlazeEM or not a or BackTODoJo()
            end
          end
        else
          _tp(CFrame.new(5813, 1208, 884))
          DragonMobClear(false, nil, nil) 
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do 
    if _G.FarmBlazeEM then
      pcall(function()              
        if workspace.EmberTemplate:FindFirstChild("Part") then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.EmberTemplate.Part.CFrame        
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.UPGDrago then     
        if GetQuestDracoLevel() == false then
          return nil
        elseif GetQuestDracoLevel() == true then
          if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938).Position - Root.Position).Magnitude >= 300 then
            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));
          else
            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));
            local v371 = {[1] = {NPC = "Dragon Wizard",Command = "Upgrade"}};
            replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371));
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.DragoV1 then     
        if GetM("Dragon Egg") <= 0 then
        repeat wait()
          _G.Prehis_Find = true
          _G.Prehis_Skills = true
          _G.Prehis_DE = true
        until not _G.DragoV1 or GetM("Dragon Egg") >= 1
          _G.Prehis_Find = PrehisUser.Find
          _G.Prehis_Skills = PrehisUser.Skills
          _G.Prehis_DE = PrehisUser.DE
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoFireFlowers then
      local FireFlower = workspace:FindFirstChild("FireFlowers")
      local v = GetConnectionEnemies("Forest Pirate")
      if v then repeat wait() Attack.Kill(v,_G.AutoFireFlowers) until not _G.AutoFireFlowers or not v.Parent or v.Humanoid.Health <= 0 or FireFlower
      else _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
      end      
      if FireFlower then
        for i, v in pairs(FireFlower:GetChildren()) do
          if (v:IsA("Model") and v.PrimaryPart) then
            local FlowerPos = v.PrimaryPart.Position;
            local playerRoot = game.Players.LocalPlayer.Character.HumanoidRootPart.Position;
            local Magnited = (FlowerPos - playerRoot).Magnitude;
            if (Magnited <= 100) then
              vim1:SendKeyEvent(true, "E", false, game) wait(1.5) vim1:SendKeyEvent(false, "E", false, game)
            else
              _tp(CFrame.new(FlowerPos));
            end
          end
        end
      end
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.DragoV3 then     
        repeat wait()
          _G.DangerSc = "Lv Infinite"
          _G.SailBoats = true
          _G.TerrorShark = true
        until not _G.DragoV3
        _G.DangerSc = "Lv 1"
        _G.SailBoats = false
        _G.TerrorShark = false
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.Relic123 then
      pcall(function()
        if workspace.Map:FindFirstChild("DracoTrial") then
          replicated.Remotes.DracoTrial:InvokeServer()                  
          wait(.5)
          repeat wait() _tp(CFrame.new(-39934.9765625, 10685.359375, 22999.34375)) until not _G.Relic123 or (Root.Position == CFrame.new(-39934.9765625, 10685.359375, 22999.34375).Position)
          repeat wait() _tp(CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625)) until not _G.Relic123 or (Root.Position == CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625).Position)
          wait(2.5)
          repeat wait() _tp(CFrame.new(-39914.65625, 10685.384765625, 23000.177734375)) until not _G.Relic123 or (Root.Position == CFrame.new(-39914.65625, 10685.384765625, 23000.177734375).Position)
          repeat wait() _tp(CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375)) until not _G.Relic123 or (Root.Position == CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375).Position)
          wait(2.5)
          repeat wait() _tp(CFrame.new(-39908.5, 10685.4052734375, 22990.04296875)) until not _G.Relic123 or (Root.Position == CFrame.new(-39908.5, 10685.4052734375, 22990.04296875).Position)
          repeat wait() _tp(CFrame.new(-39609.5, 9376.400390625, 23472.94335975)) until not _G.Relic123 or (Root.Position == CFrame.new(-39609.5, 9376.400390625, 23472.94335975).Position) 
        else
          local drago = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
          if drago and drago:IsA("Part") then _tp(CFrame.new(drago.Position)) end        
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TrainDrago then
        local DragoM = {"Venomous Assailant","Hydra Enforcer"}
	    for i=1,#DragoM do
          if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
            vim1:SendKeyEvent(true, "Y", false, game)
            replicated.Remotes.CommF_:InvokeServer("UpgradeRace","Buy",2)
            _tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))
	      elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then
	        local v = GetConnectionEnemies(DragoM)
	        if v then repeat wait() Attack.Kill(v, _G.TrainDrago) until _G.TrainDrago == false or v.Humanoid.Health <= 0 or not v.Parent                    		
		    else _tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))
		    end
	      end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.TpDrago_Prehis then
      local v748 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport");
      if (v748 and v748:IsA("Part")) then _tp(CFrame.new(v748.Position)) end
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.BuyDrago then
      pcall(function()
        if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938).Position - Root.Position).Magnitude >= 300 then
          _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));
        else
          _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938));
          local v371 = {[1] = {NPC = "Dragon Wizard",Command = "DragonRace"}};
          replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v371));
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.DT_Uzoth then
      local Uz_POS = CFrame.new(5661.89014, 1211.31909, 864.836731, 0.811413169, -1.36805838e-08, -0.584473014, 4.75227395e-08, 1, 4.25682458e-08, 0.584473014, -6.23161966e-08, 0.811413169)
      _tp(Uz_POS)
      if (Uz_POS.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 25 then
        local ohTable1 = {["NPC"] = "Uzoth",["Command"] = "Upgrade"}
        replicated.Modules.Net["RF/InteractDragonQuest"]:InvokeServer(ohTable1)
      end
    end
  end
end)

task.spawn(function()
    local RF = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

    while task.wait(0.3) do
        if getgenv().AutoCraftVolcanic then
            pcall(function()
                RF:InvokeServer(
                    "PossibleHardcode",
                    "Volcanic Magnet"
                )
            end)

            getgenv().AutoCraftVolcanic = false
        end
    end
end)

spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Prehis_Find then
                local char = plr.Character
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then return end

                local Locations = workspace["_WorldOrigin"].Locations
                local prehistoricLoc = Locations:FindFirstChild("Prehistoric Island", true)

              
                if not prehistoricLoc then
                    local myBoat = CheckBoat()

                    
                    if not myBoat then
                        local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
                        TeleportToTarget(buyBoatCFrame)

                        if (buyBoatCFrame.Position - hrp.Position).Magnitude <= 10 then
                            replicated.Remotes.CommF_:InvokeServer(
                                "BuyBoat",
                                _G.SelectedBoat or "Guardian"
                            )
                        end
                        return
                    end

                  
                    if hum.Sit == false then
                        local seatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
                        _tp(seatCFrame)
                        return
                    end

                   
                    local seaCFrame = CFrame.new(-10000000, 31, 37016.25)
                    targetDestination = seaCFrame

                    if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                        _tp(CFrame.new(-10000000, 150, 37016.25))
                    else
                        _tp(seaCFrame)
                    end

               
                else
                    local stoneHead =
                        prehistoricLoc:FindFirstChild("HeadTeleport", true)
                        or prehistoricLoc:FindFirstChild("Teleport_Head", true)
                        or prehistoricLoc:FindFirstChild("Head", true)

                    if stoneHead then
                        local headCF = stoneHead.CFrame
                        local safePos =
                            headCF.Position
                            - headCF.LookVector * 40
                            + Vector3.new(0, 20, 0)

                        if (safePos - hrp.Position).Magnitude > 30 then
                            _tp(CFrame.new(safePos))
                        end
                    else
                        local islandPos = prehistoricLoc.CFrame.Position
                        local dir = (islandPos - hrp.Position).Unit
                        local safePos = islandPos - dir * 250 + Vector3.new(0, 60, 0)
                        _tp(CFrame.new(safePos))
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        if _G.AutoStartPrehistoric then
            pcall(function()
                local prehistoricIsland = workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island", true)
                if prehistoricIsland then
                    local pIslandMap = workspace.Map:FindFirstChild("PrehistoricIsland", true)
                    if pIslandMap and pIslandMap:FindFirstChild("Core") then
                        local promptPart = pIslandMap.Core:FindFirstChild("ActivationPrompt", true)
                        if promptPart and promptPart:FindFirstChild("ProximityPrompt") then
                            if plr:DistanceFromCharacter(promptPart.CFrame.Position) <= 150 then
                                fireproximityprompt(promptPart.ProximityPrompt, math.huge)
                                vim1:SendKeyEvent(true, "E", false, game)
                                wait(1.5)
                                vim1:SendKeyEvent(false, "E", false, game)
                            end
                            _tp(promptPart.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(0.3) do
        if _G.Prehis_Skills then
            pcall(function()
                local island = workspace.Map:FindFirstChild("PrehistoricIsland")
                if not island then return end

                for _, obj in pairs(island:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart"))
                        and obj.Name:lower():find("lava") then
                        obj:Destroy()
                    end
                end

                local core = island:FindFirstChild("Core")
                if core then
                    local lavaModel = core:FindFirstChild("InteriorLava")
                    if lavaModel then lavaModel:Destroy() end
                end

                local trialTeleport = island:FindFirstChild("TrialTeleport")
                for _, v in pairs(island:GetDescendants()) do
                    if v.Name == "TouchInterest"
                    and not (trialTeleport and v:IsDescendantOf(trialTeleport)) then
                        v.Parent:Destroy()
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(Sec) do
        if _G.Prehis_Skills then
            pcall(function()
                local golem = GetConnectionEnemies("Lava Golem")
                if golem and golem:FindFirstChild("Humanoid") then
                    repeat
                        wait(0.1)
                        Attack.Kill(golem, true)
                        golem.Humanoid:ChangeState(15)
                    until not _G.Prehis_Skills
                        or not golem.Parent
                        or golem.Humanoid.Health <= 0
                end
            end)
        end
    end
end)

spawn(function()
    while wait(Sec) do
        if _G.Prehis_Skills then
            pcall(function()
                local island = workspace.Map:FindFirstChild("PrehistoricIsland")
                if not island then return end

                local core = island:FindFirstChild("Core")
                if not core then return end

                local rocks = core:FindFirstChild("VolcanoRocks")
                if not rocks then return end

                for _, rock in pairs(rocks:GetChildren()) do
                    local layer = rock:FindFirstChild("VFXLayer")
                    local at0 = layer and layer:FindFirstChild("At0")
                    local glow = at0 and at0:FindFirstChild("Glow")

                    if glow and glow.Enabled then
                        repeat
                            wait(0.1)
                            _tp(layer.CFrame)

                            if plr:DistanceFromCharacter(layer.CFrame.Position) <= 150 then
                                MousePos = layer.CFrame.Position
                                Useskills("Melee","Z") wait(.4)
                                Useskills("Melee","X") wait(.4)
                                Useskills("Melee","C") wait(.4)
                                Useskills("Blox Fruit","Z") wait(.4)
                                Useskills("Blox Fruit","X") wait(.4)
                                Useskills("Blox Fruit","C")
                            end
                        until not _G.Prehis_Skills or not glow.Enabled
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(Sec or 0.1) do
        if _G.KillAuraFull then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                sethiddenproperty(plr, "SimulationRadius", math.huge)

                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                        local dist = (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist <= (Range or 100) and enemy.Humanoid.Health > 0 then
                            enemy.Humanoid.Health = 0
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy:BreakJoints()
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Prehis_DB then
        if workspace:FindFirstChild("DinoBone") then
          for i,v in pairs(workspace:GetChildren()) do
            if v.Name == "DinoBone" then _tp(v.CFrame) end
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Prehis_DE then
        local pIsland = workspace.Map:FindFirstChild("PrehistoricIsland")
        if pIsland and pIsland:FindFirstChild("Core") and pIsland.Core:FindFirstChild("SpawnedDragonEggs") then
          local egg = pIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg")
          if egg and egg:FindFirstChild("Molten") and egg.Molten:FindFirstChild("ProximityPrompt") then
            _tp(egg.Molten.CFrame)
            fireproximityprompt(egg.Molten.ProximityPrompt, 30)
          end
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.ResetPH then
        local v748 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport");
        if (v748 and v748:FindFirstChild("TouchInterest")) then
          -- once per completion, and only while the toggle is on (it used to kill the character every 0.1s)
          if tick() - (getgenv().LastPHReset or 0) > 10 then
            getgenv().LastPHReset = tick()
            plr.Character.Humanoid.Health = 0
          end
        else
          if workspace:FindFirstChild("DinoBone") then
            for i,v in pairs(workspace:GetChildren()) do
              if v.Name == "DinoBone" then _tp(v.CFrame) end
            end
          end
        end
      end
    end)
  end
end)

ListSeaBoat={"Guardian","PirateGrandBrigade","MarineGrandBrigade","PirateBrigade","MarineBrigade","PirateSloop","MarineSloop","Beast Hunter"}

ListSeaZone={"Lv 1","Lv 2","Lv 3","Lv 4","Lv 5","Lv 6","Lv Infinite"}

spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoPressW then
                local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
                if humanoid.Sit == true then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            for i, boat in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                for _, v in pairs(boat:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if getgenv().NoClipShip or getgenv().FindPrehistoric then
                            v.CanCollide = false
                        else
                            v.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)

spawn(function()
  while wait() do
    if _G.SailBoats then 
      pcall(function()        
        local myBoat = CheckBoat()
        if not myBoat and not(CheckShark()and _G.Shark or CheckTerrorShark()and _G.TerrorShark or CheckFishCrew()and _G.MobCrew or CheckPiranha()and _G.Piranha)and not(CheckEnemiesBoat()and _G.FishBoat)and not(CheckSeaBeast()and _G.SeaBeast1)and not(_G.PGB and CheckPirateGrandBrigade())and not(_G.HCM and CheckHauntedCrew())and not(_G.Leviathan1 and CheckLeviathan())then
          local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
          TeleportToTarget(buyBoatCFrame)
          if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end
        elseif myBoat and not(CheckShark()and _G.Shark or CheckTerrorShark()and _G.TerrorShark or CheckFishCrew()and _G.MobCrew or CheckPiranha()and _G.Piranha)and not(CheckEnemiesBoat()and _G.FishBoat)and not(CheckSeaBeast()and _G.SeaBeast1)and not(_G.PGB and CheckPirateGrandBrigade())and not(_G.HCM and CheckHauntedCrew())and not(_G.Leviathan1 and CheckLeviathan())then
          if plr.Character.Humanoid.Sit == false then
            local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
            _tp(boatSeatCFrame)
          else                         
            if _G.DangerSc == "Lv 1" then CFrameSelectedZone = CFrame.new(-21998.375, 30.0006084, -682.309143)
            elseif _G.DangerSc == "Lv 2" then CFrameSelectedZone = CFrame.new(-26779.5215, 30.0005474, -822.858032)
            elseif _G.DangerSc == "Lv 3" then CFrameSelectedZone = CFrame.new(-31171.957, 30.0001011, -2256.93774)
            elseif _G.DangerSc == "Lv 4" then CFrameSelectedZone = CFrame.new(-34054.6875, 30.2187767, -2560.12012)
            elseif _G.DangerSc == "Lv 5" then CFrameSelectedZone = CFrame.new(-38887.5547, 30.0004578, -2162.99023)
            elseif _G.DangerSc == "Lv 6" then CFrameSelectedZone = CFrame.new(-44541.7617, 30.0003204, -1244.8584)
            elseif _G.DangerSc == "Lv Infinite" then CFrameSelectedZone = CFrame.new(-10000000, 31, 37016.25)
            end           
            repeat wait() 
              if (not _G.FishBoat and CheckEnemiesBoat()) or (not _G.PGB and CheckPirateGrandBrigade()) or (not _G.TerrorShark and CheckTerrorShark()) then
                _tp(CFrameSelectedZone * CFrame.new(0,150,0))
              else
                _tp(CFrameSelectedZone)
              end           
            until _G.SailBoats==false or(CheckShark()and _G.Shark or CheckTerrorShark()and _G.TerrorShark or CheckFishCrew()and _G.MobCrew or CheckPiranha()and _G.Piranha)or CheckSeaBeast()and _G.SeaBeast1 or CheckEnemiesBoat()and _G.FishBoat or _G.Leviathan1 and CheckLeviathan() or _G.HCM and CheckHauntedCrew() or _G.PGB and CheckPirateGrandBrigade() or plr.Character:WaitForChild("Humanoid").Sit==false plr.Character.Humanoid.Sit = false
          end
        end
      end)
    end
  end
end)

spawn(function()while wait(Sec)do pcall(function()for a,b in pairs(workspace.Boats:GetChildren())do for c,d in pairs(workspace.Boats[b.Name]:GetDescendants())do if d:IsA("BasePart")then if _G.SailBoats or _G.Prehis_Find or _G.FindMirage or _G.SailBoat_Hydra or _G.AutofindKitIs then d.CanCollide=false else d.CanCollide=true end end end end end)end end)

spawn(function()
  while wait() do
    pcall(function()	
      if _G.Shark then local a={"Shark"}if CheckShark()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.Shark)until _G.Shark==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.TerrorShark then local a={"Terrorshark"}if CheckTerrorShark()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.KillSea(c,_G.TerrorShark)until _G.TerrorShark==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.Piranha then local a={"Piranha"}if CheckPiranha()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.Piranha)until _G.Piranha==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.MobCrew then local a={"Fish Crew Member"}if CheckFishCrew()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.MobCrew)until _G.MobCrew==false or not c.Parent or c.Humanoid.Health<=0 end end end end end                 
      if _G.HCM then local a={"Haunted Crew Member"}if CheckHauntedCrew()then for b,c in pairs(workspace.Enemies:GetChildren())do if table.find(a,c.Name)then if Attack.Alive(c)then repeat task.wait()Attack.Kill(c,_G.HCM)until _G.HCM==false or not c.Parent or c.Humanoid.Health<=0 end end end end end
      if _G.SeaBeast1 then if workspace.SeaBeasts:FindFirstChild("SeaBeast1")then for a,b in pairs(workspace.SeaBeasts:GetChildren())do if b:FindFirstChild("HumanoidRootPart")and b:FindFirstChild("Health")and b.Health.Value>0 then repeat task.wait()spawn(function()_tp(CFrame.new(b.HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y+200,b.HumanoidRootPart.Position.Z))end)if plr:DistanceFromCharacter(b.HumanoidRootPart.CFrame.Position)<=500 then AitSeaSkill_Custom=b.HumanoidRootPart.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.SeaBeast1==false or not b:FindFirstChild("HumanoidRootPart")or not b.Parent or b.Health.Value<=0 end end end end
      if _G.Leviathan1 then if workspace.SeaBeasts:FindFirstChild("Leviathan")then for a,b in pairs(workspace.SeaBeasts:GetChildren())do if b:FindFirstChild("HumanoidRootPart")and b:FindFirstChild("Leviathan Segment")and b:FindFirstChild("Health")and b.Health.Value>0 then repeat task.wait()spawn(function()_tp(CFrame.new(b.HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y+200,b.HumanoidRootPart.Position.Z))end)if plr:DistanceFromCharacter(b.HumanoidRootPart.CFrame.Position)<=500 then MousePos=b:FindFirstChild("Leviathan Segment").Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.Leviathan1==false or not b:FindFirstChild("HumanoidRootPart")or not b.Parent or b.Health.Value<=0 end end end end
      if _G.FishBoat then if CheckEnemiesBoat()then for a,b in pairs(workspace.Enemies:GetChildren())do if b:FindFirstChild("Health")and b.Health.Value>0 and b:FindFirstChild("VehicleSeat")then repeat task.wait()spawn(function()if b.Name=="FishBoat"then _tp(b.Engine.CFrame*CFrame.new(0,-50,-25))end end)if plr:DistanceFromCharacter(b.Engine.CFrame.Position)<=150 then AitSeaSkill_Custom=b.Engine.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.FishBoat==false or not b:FindFirstChild("VehicleSeat")or b.Health.Value<=0 end end end end
      if _G.PGB then if CheckPirateGrandBrigade()then for a,b in pairs(workspace.Enemies:GetChildren())do if b:FindFirstChild("Health")and b.Health.Value>0 and b:FindFirstChild("VehicleSeat")then repeat task.wait()spawn(function()if b.Name=="PirateBrigade"then _tp(b.Engine.CFrame*CFrame.new(0,-30,-10))elseif b.Name=="PirateGrandBrigade"then _tp(b.Engine.CFrame*CFrame.new(0,-50,-50))end end)if plr:DistanceFromCharacter(b.Engine.CFrame.Position)<=150 then AitSeaSkill_Custom=b.Engine.CFrame;MousePos=AitSeaSkill_Custom.Position;if CheckF()then weaponSc("Blox Fruit")Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")else Useskills("Melee","Z")Useskills("Melee","X")Useskills("Melee","C")wait(.1)Useskills("Sword","Z")Useskills("Sword","X")wait(.1)Useskills("Blox Fruit","Z")Useskills("Blox Fruit","X")Useskills("Blox Fruit","C")wait(.1)Useskills("Gun","Z")Useskills("Gun","X")end end until _G.PGB==false or not b:FindFirstChild("VehicleSeat")or b.Health.Value<=0 end end end end
    end)
  end
end)

spawn(function()
  while wait() do
    if _G.AutofindKitIs then 
      pcall(function()
        if not workspace["_WorldOrigin"].Locations:FindFirstChild("Kitsune Island", true) then                
          local myBoat = CheckBoat()
          if not myBoat then
            local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
            TeleportToTarget(buyBoatCFrame)
            if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end
          else
            if plr.Character.Humanoid.Sit == false then
              local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
              _tp(boatSeatCFrame)
            else
              local targetDestination = CFrame.new(-10000000, 31, 37016.25)              
              repeat wait() 
                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                  _tp(CFrame.new(-10000000, 150, 37016.25))
                else
                  _tp(CFrame.new(-10000000, 31, 37016.25))
                end
              until not _G.AutofindKitIs or (targetDestination.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or workspace["_WorldOrigin"].Locations:FindFirstChild("Kitsune Island") or plr.Character.Humanoid.Sit == false plr.Character.Humanoid.Sit = false
            end
          end
        else
          _tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame*CFrame.new(0,500,0))
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.tweenShrine then
      pcall(function()
      local kit_is = workspace.Map:FindFirstChild("KitsuneIsland") or game.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
      local shrineActive = kit_is:FindFirstChild("ShrineActive")
        if shrineActive then
          for _, v in next, shrineActive:GetDescendants() do
            if v:IsA("BasePart") and v.Name:find("NeonShrinePart") then
              replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
              repeat wait() _tp(v.CFrame * CFrame.new(0,2,0)) until _G.tweenShrine == false or not kit_is
            end
          end
        else
          _tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0,500,0))        
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.Collect_Ember then
      pcall(function()
        if workspace:WaitForChild("AttachedAzureEmber") or workspace:WaitForChild("EmberTemplate") then
        notween(workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)
        else
          _tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0,500,0))        
          replicated.Modules.Net["RF/KitsuneStatuePray"]:InvokeServer()
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.Trade_Ember then
      pcall(function()
        if workspace["_WorldOrigin"].Locations:FindFirstChild("Kitsune Island",true) then
          replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
        end
      end)
    end
  end
end)

spawn(function()
  while wait(.1) do
    if _G.FrozenTP then
      pcall(function()
      if workspace.Map:FindFirstChild("LeviathanGate") then _tp(workspace.Map.LeviathanGate.CFrame) replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLeviathanGate") end
      end)
    end
  end
end)

spawn(function()
  while wait() do
    if _G.SailBoat_Hydra then 
      pcall(function()        
        local myBoat = CheckBoat()
        if not myBoat then
          local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
          TeleportToTarget(buyBoatCFrame)
          if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end
        elseif myBoat then
          if plr.Character.Humanoid.Sit == false then
            local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
            _tp(boatSeatCFrame)
          else                         
            repeat wait() 
              if CheckEnemiesBoat() or CheckPirateGrandBrigade() or CheckTerrorShark() then
                _tp(CFrame.new(5433, 150, 290))
              else
                _tp(CFrame.new(5433, 35, 290))
              end           
            until _G.SailBoat_Hydra==false or plr.Character:WaitForChild("Humanoid").Sit==false plr.Character.Humanoid.Sit = false
          end
        end
      end)
    end
  end
end)

function isnil(thing)
    return (thing == nil)
end

function round(n)
    return math.floor(tonumber(n) + 0.5)
end

function formatNumber(number)
    local str = tostring(number)
    repeat
        local replaced, count = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        str = replaced
    until count == 0
    return str
end

function getFruitStock()
    local resultStr = "Advance Fruit Stock\n"
    local success, advanceFruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", true)
    end)

    if not success or not advanceFruits then
        resultStr = resultStr .. "- Error while retrieving data.\n"
    else
        local hasFruit = false
        for _, fruit in pairs(advanceFruits) do
            if fruit.OnSale then
                hasFruit = true
                resultStr = resultStr .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            resultStr = resultStr .. "- No fruit.\n"
        end
    end

    resultStr = resultStr .. "\nNormal Fruit Stock\n"
    local success2, normalFruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    end)

    if success2 and normalFruits then
        local hasFruit = false
        for _, fruit in pairs(normalFruits) do
            if fruit.OnSale then
                hasFruit = true
                resultStr = resultStr .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            resultStr = resultStr .. "- No fruit.\n"
        end
    else
        resultStr = resultStr .. "- Error while retrieving data.\n"
    end

    return resultStr
end

spawn(function()
  while wait(5) do
    pcall(function()
      if not _G.Random_Auto then return end

      local spinnerWindow = plr.PlayerGui:FindFirstChild("SpinnerWindow")
      if spinnerWindow then
        local closeBtn = spinnerWindow:FindFirstChild("AboveSpinner")
          and spinnerWindow.AboveSpinner:FindFirstChild("Navigation")
          and spinnerWindow.AboveSpinner.Navigation:FindFirstChild("CloseButton")
        if closeBtn and closeBtn.Visible then
          pcall(function()
            for _, v in pairs(getconnections(closeBtn.Activated)) do
              if v.Function then v.Function() elseif v.Fire then v:Fire() end
            end
          end)
        end
      end

      if plr.Data.Level.Value < 50 then return end
      if RandomFruitCooldown and tick() < RandomFruitCooldown then return end

      local GachaClient = require(replicated.Controllers.GachaClient)
      local success, result1, result2 = pcall(function()
        return GachaClient.PurchaseGachaAsync("ZiolesGacha")
      end)

      if success and type(result2) == "table" then
        if result2.Cooldown and result2.Cooldown.TimeEnds then
          local timeRemaining = result2.Cooldown.TimeEnds - os.time()
          if timeRemaining > 0 then
            RandomFruitCooldown = tick() + timeRemaining
            return
          end
        end
        if result2.RequirementsMet == false then
          RandomFruitCooldown = tick() + 600
          return
        end
        if result1 == true then
          RandomFruitCooldown = tick() + 7200
        end
      end
    end)
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.DropFruit then
      pcall(function() DropFruits() end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.StoreF then
      pcall(function() UpdStFruit() end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.TwFruits then
      pcall(function()
        -- nearest real fruit pickup only (the old loop tweened to EVERY match in turn and aborted on the
        -- first workspace child with "Fruit" in its name that had no Handle)
        local handle = GetNearestFruit()
        if handle then _tp(handle.CFrame) end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    if _G.InstanceF then
      pcall(function() collectFruits(_G.InstanceF) end)
    end
  end
end)

spawn(function()
    pcall(function()
        while wait() do
            if getgenv().AutoBuyFruitSniper then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
            end
        end
    end)
end)

spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoGetFruit then
                local fruits = {
                    "Rocket-Rocket", "Spin-Spin", "Chop-Chop", "Spring-Spring", "Bomb-Bomb", "Smoke-Smoke",
                    "Spike-Spike", "Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark",
                    "Ghost-Ghost", "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Barrier-Barrier"
                }
                for _, fruit in ipairs(fruits) do
                    local args = {
                        [1] = "LoadFruit",
                        [2] = fruit
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.AutoChipBeli then
            pcall(function()
                if not GetBP("Special Microchip") then
                    replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.AutoChipFruit then
            pcall(function()
                if not GetBP("Special Microchip") then
                    local fruits = replicated.Remotes.CommF_:InvokeServer("GetFruits")
                    local cheapest = nil
                    for _, data in pairs(fruits) do
                        if data.Price <= 490000 then
                            cheapest = data.Name
                            break
                        end
                    end
                    if cheapest then
                        replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(cheapest))
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    end
                end
            end)
        end
    end
end)

IsRaidActive = function()
  local ok, active = pcall(function()
    if plr.PlayerGui.Main.TopHUDList.RaidTimer.Visible then return true end
    local a = plr:GetAttribute("IslandRaiding")
    return a ~= nil and a ~= false and a ~= ""
  end)
  return ok and active == true
end

task.spawn(function()
    local lastPress = 0
    while task.wait(0.5) do
        if not _G.Auto_StartRaid then continue end

        pcall(function()
            -- never start another raid while one is running, and not within 25s of the last press
            if IsRaidActive() or tick() - lastPress < 25 then return end
            if not GetBP("Special Microchip") then return end

            local labCF
            if World2 then
                labCF = CFrame.new(-6438.73535, 250.645355, -4501.50684)
            elseif World3 then
                labCF = CFrame.new(-5046, 314, -2960)
            end
            if not labCF then return end

            -- travel first (a single _tp keeps the tween alive); press the button only once we are standing there
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if (hrp.Position - labCF.Position).Magnitude > 30 then
                _tp(labCF)
                return
            end

            if World2 then
                fireclickdetector(workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
            else
                local button = workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                if button and button:FindFirstChild("ClickDetector") then
                    fireclickdetector(button.ClickDetector)
                end
            end
            lastPress = tick()
        end)
    end
end)

spawn(function()
    local locations = workspace["_WorldOrigin"].Locations
    local islandIdx = 1          -- island we are working on; only ever moves forward during a raid
    local wasActive = false
    local noEnemiesTick = 0
    local lockedRef = nil        -- position of the arena we are fighting in (set once we are really there)

    -- Several raids can exist at once (other players'), each with its own "Island N" parts, so
    -- FindFirstChild("Island N") may return somebody else's island. Take the one nearest to us / to our arena.
    function findIsland(i, ref)
        local best, bd
        for _, v in ipairs(locations:GetChildren()) do
            if v.Name == "Island " .. i then
                local d = (v.Position - ref).Magnitude
                if not bd or d < bd then best, bd = v, d end
            end
        end
        return best
    end

    while task.wait(0.3) do
        if not _G.Raiding then wasActive = false lockedRef = nil continue end

        pcall(function()
            -- Not in a raid: leave the character alone. (The old loop used RaidTimer.Visible only and, between
            -- raids, kept steering the character towards stale islands.)
            if not IsRaidActive() then
                wasActive = false
                lockedRef = nil
                noEnemiesTick = 0
                return
            end

            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            if hum.Sit or hum.PlatformStand or root.Anchored then return end

            -- a raid just started (or this toggle was switched on mid-raid): pick the starting island ONCE.
            -- The old code re-picked "the island nearest to the player" every tick, so while flying between
            -- islands the target flipped to the island after next and the character wandered off.
            if not wasActive then
                wasActive = true
                lockedRef = nil
                noEnemiesTick = 0
                islandIdx = 1
                local bestDist = 1500
                for i = 1, 5 do
                    local p = findIsland(i, root.Position)
                    if p then
                        local d = (root.Position - p.Position).Magnitude
                        if d < bestDist then bestDist = d islandIdx = i end
                    end
                end
            end

            local islandPos = findIsland(islandIdx, lockedRef or root.Position)
            if not islandPos then return end
            if not lockedRef and (root.Position - islandPos.Position).Magnitude <= 600 then
                lockedRef = islandPos.Position
            end

            if _G.KillAuraRaid and (islandIdx == 4 or islandIdx == 5) then
                sethiddenproperty(plr, "SimulationRadius", math.huge)
                for _, mob in ipairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                        local dist = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist <= 500 and mob.Humanoid.Health > 0 then
                            mob.Humanoid.Health = 0
                            mob.HumanoidRootPart.CanCollide = false
                            mob:BreakJoints()
                        end
                    end
                end
            end

            -- not at the island yet: go there first and do not count "no enemies" while travelling
            if (root.Position - islandPos.Position).Magnitude > 600 then
                noEnemiesTick = 0
                _tp(islandPos.CFrame * CFrame.new(0, 60, 0))
                return
            end

            local foundEnemies = false
            for _, mob in ipairs(workspace.Enemies:GetChildren()) do
                local eh = mob:FindFirstChild("Humanoid")
                local ehrp = mob:FindFirstChild("HumanoidRootPart")
                if eh and ehrp and eh.Health > 0 and (ehrp.Position - islandPos.Position).Magnitude < 800 then   -- was 450: a Flame User spawned 461 studs out and the raid stalled with 6 minutes left (islands are ~1500 apart)
                    foundEnemies = true
                    local giveUp = tick() + 25
                    repeat
                        task.wait()
                        Attack.Kill(mob, _G.Raiding)
                    -- also stop when the raid ended, otherwise the character keeps chasing a mob that is gone
                    until not _G.Raiding or not mob.Parent or eh.Health <= 0 or not IsRaidActive() or tick() > giveUp
                    if not _G.Raiding or not IsRaidActive() then return end
                end
            end

            if foundEnemies then
                noEnemiesTick = 0
            else
                noEnemiesTick = noEnemiesTick + 1
                if noEnemiesTick > 15 then
                    local nxt = findIsland(islandIdx + 1, lockedRef or islandPos.Position)
                    if nxt then
                        islandIdx = islandIdx + 1
                        noEnemiesTick = 0
                        _tp(nxt.CFrame * CFrame.new(0, 60, 0))
                    else
                        -- next island has not appeared yet: wait above this one
                        _tp(islandPos.CFrame * CFrame.new(0, 60, 0))
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while task.wait() do
        if _G.TpPly and _G.PlayersList then
            pcall(function()
                local target = game:GetService("Players"):FindFirstChild(_G.PlayersList)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    _tp(target.Character.HumanoidRootPart.CFrame)
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(0.1) do
        if SpectatePlys and _G.PlayersList then
            pcall(function()
                local target = game:GetService("Players"):FindFirstChild(_G.PlayersList)
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.Camera.CameraSubject = target.Character.Humanoid
                end
            end)
        end
    end
end)

function ListServers(cursor)
    local Http = game:GetService("HttpService")
    local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100" .. ((cursor and "&cursor=" .. cursor) or "")
    local ok, raw = pcall(function() return game:HttpGet(url) end)
    if ok and raw then
        local decodeOk, res = pcall(function() return Http:JSONDecode(raw) end)
        if decodeOk then return res end
    end
    return {data = {}}
end

function fetchServersData(placeId, limit)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=%d", placeId, limit or 100)
    local success, response = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet(url))
    end)
    if success and response and response.data then
        return response.data
    end
    return nil
end


local player = game.Players.LocalPlayer
function IsEntityAlive(entity)

    if not entity then return false end

    local humanoid = entity:FindFirstChild("Humanoid")

    return humanoid and humanoid.Health > 0

end
function GetEnemiesInRange(character, range)
    local targets = {}
    local playerPos = character:GetPivot().Position
    local players = game:GetService("Players"):GetPlayers()
    local enemies = game:GetService("Workspace").Enemies:GetChildren()

    for _, enemy in ipairs(enemies) do
        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
        if rootPart and IsEntityAlive(enemy) then
            local distance = (rootPart.Position - playerPos).Magnitude
            if distance <= range then
                table.insert(targets, enemy)
            end
        end
    end

    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= plr and otherPlayer.Character then
            local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and IsEntityAlive(otherPlayer.Character) then
                local distance = (rootPart.Position - playerPos).Magnitude
                if distance <= range then
                    table.insert(targets, otherPlayer.Character)
                end
            end
        end
    end

    return targets

end
function AttackNoCoolDown()

    local character = plr.Character

    if not character then return end

    local equippedWeapon = nil

    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            equippedWeapon = item
            break
        end
    end

    if not equippedWeapon then return end

    local enemiesInRange = GetEnemiesInRange(character, 60)

    if #enemiesInRange == 0 then return end

    local storage = game:GetService("ReplicatedStorage")

    local modules = storage:FindFirstChild("Modules")

    if not modules then return end

    local attackEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")

    local hitEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")

    if not attackEvent or not hitEvent then return end

    local targets, mainTarget = {}, nil

    for _, enemy in ipairs(enemiesInRange) do
        if not enemy:GetAttribute("IsBoat") then
            local HitboxLimbs = {"RightLowerArm", "RightUpperArm", "LeftLowerArm", "LeftUpperArm", "RightHand", "LeftHand"}
            local head = enemy:FindFirstChild(HitboxLimbs[math.random(#HitboxLimbs)]) or enemy.PrimaryPart
            if head then
                table.insert(targets, { enemy, head })
                mainTarget = head
            end
        end
    end

    if not mainTarget then return end

    attackEvent:FireServer(0)

    local playerScripts = plr:FindFirstChild("PlayerScripts")
    if not playerScripts then return end

    local localScript = playerScripts:FindFirstChildOfClass("LocalScript")

    while not localScript do
        playerScripts.ChildAdded:Wait()
        localScript = playerScripts:FindFirstChildOfClass("LocalScript")
    end

    local hitFunction

    if getsenv then
        local success, scriptEnv = pcall(getsenv, localScript)
        if success and scriptEnv then
            hitFunction = scriptEnv._G.SendHitsToServer
        end
    end

    local successFlags, combatRemoteThread = pcall(function()
        return require(modules.Flags).COMBAT_REMOTE_THREAD or false
    end)

    if successFlags and combatRemoteThread and hitFunction then
        hitFunction(mainTarget, targets)
    elseif successFlags and not combatRemoteThread then
        hitEvent:FireServer(mainTarget, targets)
    end

end
CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()
get_Monster=function()for a,b in pairs(workspace.Enemies:GetChildren())do local c=b:FindFirstChild("UpperTorso")or b:FindFirstChild("Head")if b:FindFirstChild("HumanoidRootPart",true)and c then if(b.Head.Position-plr.Character.HumanoidRootPart.Position).Magnitude<=50 then return true,c.Position end end end;for a,d in pairs(workspace.SeaBeasts:GetChildren())do if d:FindFirstChild("HumanoidRootPart")and d:FindFirstChild("Health")and d.Health.Value>0 then return true,d.HumanoidRootPart.Position end end;for a,d in pairs(workspace.Enemies:GetChildren())do if d:FindFirstChild("Health")and d.Health.Value>0 and d:FindFirstChild("VehicleSeat")then return true,d.Engine.Position end end end
Actived=function()local a=game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")for b,c in next,getconnections(a.Activated)do if typeof(c.Function)=='function'then getupvalues(c.Function)end end end
task.spawn(function()

  RunSer.Heartbeat:Connect(function()
    pcall(function()      
      if not _G.Seriality then return end      
      AttackNoCoolDown() 
      local Pretool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
      local ToolTip = Pretool.ToolTip
      local MobAura, Mon = get_Monster()      
      if ToolTip == "Blox Fruit" then
        if MobAura then           
          local LeftClickRemote = Pretool:FindFirstChild('LeftClickRemote');
          if LeftClickRemote then Actived() LeftClickRemote:FireServer(Vector3.new(0.01,-500,0.01),1,true);LeftClickRemote:FireServer(false)end
        end     		                         
      end      
    end)
  end)

end)
local FastAttackModule = {}
local HitRegistrationModule = {}
local MainController = {}

local GameService = game
local Players = GameService:GetService("Players")
local RunService = GameService:GetService("RunService")
local ReplicatedStorage = GameService:GetService("ReplicatedStorage")
local Workspace = GameService:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

function SafeWaitForChild(parent, childName)

    local success, result = pcall(function()
        return parent:WaitForChild(childName)
    end)

    return result

end

local Enemies = SafeWaitForChild(Workspace, "Enemies")
local Characters = SafeWaitForChild(Workspace, "Characters")
local Modules = SafeWaitForChild(ReplicatedStorage, "Modules")
local Net = SafeWaitForChild(Modules, "Net")

FastAttackModule.Rate = 0.000000002
FastAttackModule.Enabled = true

function FastAttackModule.IsAlive(target)

    local humanoid = target:FindFirstChild("Humanoid")

    if humanoid and humanoid.Health > 0 then
        return true
    end

    return false

end

function FastAttackModule.GetNearbyTargets(character, folder)

    local nearbyTargets = {}

    local characterPosition = character:GetPivot().Position

    local children = folder:GetChildren()

    for i = 1, #children do
        local target = children[i]
        local humanoid = target:FindFirstChild("Humanoid")
        local rootPart = target:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.Health > 0 then
            local distance = (rootPart.Position - characterPosition).Magnitude
            if distance <= 60 then
                table.insert(nearbyTargets, target)
            end
        end
    end

    return nearbyTargets

end

function FastAttackModule.GetTargetParts(targetList)

    local result = {}

    local count = #targetList

    for i = 1, count do
        local target = targetList[i]
        local head = target:FindFirstChild("Head") or target.PrimaryPart
        if head then
            table.insert(result, {target, head})
        end
    end

    return result

end

function FastAttackModule.GetAllTargets(character)

    local allTargets = {}

    local enemies = FastAttackModule.GetNearbyTargets(character, Enemies)

    local otherCharacters = FastAttackModule.GetNearbyTargets(character, Characters)

    for i = 1, #enemies do
        table.insert(allTargets, enemies[i])
    end

    for i = 1, #otherCharacters do
        table.insert(allTargets, otherCharacters[i])
    end

    return allTargets

end

function FastAttackModule.ExecuteFastAttack()

    local character = LocalPlayer.Character

    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")

    if not tool then return end

    local targets = FastAttackModule.GetAllTargets(character)

    if #targets < 1 then return end

    local targetParts = FastAttackModule.GetTargetParts(targets)

    if #targetParts < 1 then return end

    local attackRemote = Net["RE/RegisterAttack"]

    local hitRemote = Net["RE/RegisterHit"]

    attackRemote:FireServer(FastAttackModule.Rate)

    local targetHead = targetParts[1][2]

    hitRemote:FireServer(targetHead, targetParts)

end

local AttackRemoteTarget
local AttackRemoteId

function InitializeHitRegistration()

    local foldersToCheck = {
        ReplicatedStorage.Util,

        ReplicatedStorage.Common,

        ReplicatedStorage.Remotes,

        ReplicatedStorage.Assets,

        ReplicatedStorage.FX

    }

    for _, folder in ipairs(foldersToCheck) do
        local children = folder:GetChildren()
        
        for _, child in ipairs(children) do
            if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                AttackRemoteTarget = child
                AttackRemoteId = child:GetAttribute("Id")
            end
        end

        folder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                AttackRemoteTarget = child
                AttackRemoteId = child:GetAttribute("Id")
            end
        end)
    end

end

InitializeHitRegistration()

function HitRegistrationModule.Execute()

    local character = LocalPlayer.Character

    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart then return end

    local hitTargets = {}

    function ScanFolder(folder)
        local children = folder:GetChildren()
        for i = 1, #children do
            local target = children[i]
            local humanoid = target:FindFirstChild("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
                local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 60 then
                    local targetChildren = target:GetChildren()
                    for _, child in ipairs(targetChildren) do
                        if child:IsA("BasePart") then
                            table.insert(hitTargets, {target, child})
                        end
                    end
                end
            end
        end
    end

    ScanFolder(Enemies)

    ScanFolder(Characters)

    local tool = character:FindFirstChildOfClass("Tool")

    if #hitTargets > 0 and tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword") then
        local seed = Modules.Net.seed:InvokeServer()
        
        local attackRemote = Net["RE/RegisterAttack"]
        local hitRemote = Net["RE/RegisterHit"]
        
        attackRemote:FireServer()
        
        local targetHead = hitTargets[1][1]:FindFirstChild("Head")
        if not targetHead then return end

        hitRemote:FireServer(targetHead, hitTargets, {})
        
        if AttackRemoteTarget then
            local remoteCode = "RE/RegisterHit"
            local encryptionKey = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
            
            local encodedString = string.gsub(remoteCode, ".", function(char)
                return string.char(bit32.bxor(string.byte(char), encryptionKey))
            end)

            local finalId = bit32.bxor(AttackRemoteId + 909090, seed * 2)
            
            cloneref(AttackRemoteTarget):FireServer(
                encodedString,
                finalId,
                targetHead,
                hitTargets
            )
        end
    end

end

function DisableCameraShake()

    local cameraModule = require(ReplicatedStorage.Util.CameraShaker)

    cameraModule:Stop()

end

function StartMainLoops()

    task.spawn(function()
        while task.wait(FastAttackModule.Rate) do
            FastAttackModule.ExecuteFastAttack()
        end
    end)

    RunService.Heartbeat:Connect(function()
        pcall(HitRegistrationModule.Execute)
    end)

end

StartMainLoops()


task.spawn(function()
    while task.wait(Sec) do
        if _G.Level then
            pcall(function()
                local char = plr.Character or plr.CharacterAdded:Wait()
                local Root = char:WaitForChild("HumanoidRootPart")
                if not Root then return end

                local level = plr.Data.Level.Value
                local inSub = IsInSubmergedIsland()
                local isQuestVisible, QuestTitle = GuiShown("Quest"), QuestText()

                if World3 and level >= 2600 and not inSub then
                    local npcPos = cframenpc or CFrame.new(-16269.7041, 25.2288494, 1373.65955)
                    
                    if (Root.Position - npcPos.Position).Magnitude > 15 then
                        _tp(npcPos)
                        return
                    end

                    pcall(function()
                        local net = game:GetService("ReplicatedStorage").Modules.Net
                        net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer("AskKilledTikiBoss")
                        task.wait(0.5)
                        net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer("TravelToSubmergedIsland")
                    end)

                    local timeout = tick()
                    repeat 
                        task.wait(0.5)
                    until not _G.Level or IsInSubmergedIsland() or tick() - timeout > 10

                    return
                else

                    local questData = QuestNeta()
                    
                    if not questData or not questData[1] then
                        task.wait(1)
                        return
                    end
                    
                    local questActive = GuiShown("Quest") and CheckHasQuest(questData[5] or questData[1])

                    if GuiShown("Quest") and not questActive then
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                        task.wait(0.2)
                        return
                    end

                    if not questActive then
                      local questPos = questData[6]
                      if questPos then
                          _tp(questPos)
                          task.wait(2)
                          
                          if (Root.Position - questPos.Position).Magnitude <= 10 then
                              BFAcceptQuest(questData[3], questData[2], questData[5] or questData[1])
                          end
                      else
                          BFAcceptQuest(questData[3], questData[2], questData[5] or questData[1])
                      end
                      return
                    end

                    local enemyName = questData[1]
                    
                    local foundMob = false
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if string.find(v.Name, enemyName, 1, true) and Attack.Alive(v) then
                            local enemyRoot = v:FindFirstChild("HumanoidRootPart")
                            if enemyRoot then
                                foundMob = true
                                repeat
                                    task.wait(Sec)
                                    if not Attack.Alive(v) or not enemyRoot.Parent then break end
                                    _tp(enemyRoot.CFrame * CFrame.new(0, 20, 0))
                                    Attack.Kill(v, _G.Level)
                                    
                                    local isQVis = GuiShown("Quest")
                                    if not isQVis then
                                        break
                                    end
                                until not _G.Level or not v.Parent or not Attack.Alive(v)
                                break
                            end
                        end
                    end
                    
                    if not foundMob then
                        for _, v in pairs(replicated:GetChildren()) do
                            if string.find(v.Name, enemyName, 1, true) and Attack.Alive(v) then
                                local enemyRoot = v:FindFirstChild("HumanoidRootPart")
                                if enemyRoot then
                                    foundMob = true
                                    _tp(enemyRoot.CFrame * CFrame.new(0, 20, 0))
                                    break
                                end
                            end
                        end
                    end
                    
                    if not foundMob then
                        for _, spawnPoint in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                            if string.find(spawnPoint.Name, enemyName, 1, true) then
                                _tp(spawnPoint.CFrame * CFrame.new(0, 20, 0))
                                foundMob = true
                                break
                            end
                        end
                    end

                    if not foundMob and PosMon then
                        _tp(CFrame.new(PosMon) * CFrame.new(0, 20, 0))
                    end
                end
            end)
        else
            teleporting = false
            alreadyTeleported = false
        end
    end
end)

local plr = game:GetService('Players').LocalPlayer

local replicated = game:GetService("ReplicatedStorage")

spawn(function()

  while wait(Sec) do
    pcall(function()
      if _G.Auto_Awakener then
        replicated.Remotes.CommF_:InvokeServer("Awakener","Check")
        replicated.Remotes.CommF_:InvokeServer("Awakener","Awaken")
      end
    end)
  end

end)	

spawn(function()

    while task.wait(1) do  
        if getgenv().AutoBuyMicrochipLaw then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
            end)
        end
    end

end)

spawn(function()

    while task.wait(1) do  
        if getgenv().AutoStartLawRaids then
            pcall(function()
                fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end)
        end
    end

end)

spawn(function()

  while wait(Sec) do
    if _G.AutoLawKak then
      pcall(function()
        local v = GetConnectionEnemies("Order")
        if v then repeat task.wait() Attack.Kill(v, _G.AutoLawKak) until _G.AutoLawKak == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875))
        end
      end)
    end
  end

end)

local plr = game.Players.LocalPlayer

function GetHRP()

    local char = plr.Character

    return char and char:FindFirstChild("HumanoidRootPart")

end

spawn(function()

    while task.wait(0.15) do
        if not _G.AutoFarmDungeon then continue end

        pcall(function()
            local plr = game.Players.LocalPlayer
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end

            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if not _G.AutoFarmDungeon then break end

                local mh = mob:FindFirstChild("Humanoid")
                local mhrp = mob:FindFirstChild("HumanoidRootPart")

                if mh and mhrp and mh.Health > 0 then
                    local dist = (mhrp.Position - hrp.Position).Magnitude
                    if dist <= FARM_RANGE then
                        repeat
                            task.wait()
                            Attack.Kill(mob, true)
                        until not _G.AutoFarmDungeon
                            or not mob.Parent
                            or mh.Health <= 0
                    end
                end
            end
        end)
    end

end)

function GetCurrentFloor()

    local hrp = GetHRP()

    if not hrp then return end

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit and exit:FindFirstChild("Root") then
            if (hrp.Position - exit.Root.Position).Magnitude < 200 then
                return exit.Root
            end
        end
    end

end

task.spawn(function()

    while task.wait(0.3) do
        if not _G.TPFloor1 then
            tp1Done = false
            continue
        end

        if not tp1Done then
            local root = GetCurrentFloor()
            if root then
                root = root.CFrame * CFrame.new(0,3,0)
                GetHRP().CFrame = root
                tp1Done = true
            end
        end
    end

end)

task.spawn(function()

    while task.wait(0.3) do
        if not _G.TPFloor2 then
            tp2Done = false
            continue
        end

        if tp2Done then continue end

        local hrp = GetHRP()
        if not hrp then continue end

        for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
            local ent = floor:FindFirstChild("EntranceTeleporter")
            local ext = floor:FindFirstChild("ExitTeleporter")

            if ent and ext and ent:FindFirstChild("Root") and ext:FindFirstChild("Root") then
                if (hrp.Position - ent.Root.Position).Magnitude < 100 then
                    hrp.CFrame = ext.Root.CFrame * CFrame.new(0,3,0)
                    tp2Done = true
                    break
                end
            end
        end
    end

end)

function GetHighestFloor()

    local max

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local n = tonumber(floor.Name)
        if n and (not max or n > tonumber(max.Name)) then
            max = floor
        end
    end

    return max

end

task.spawn(function()

    while task.wait(0.3) do
        if not _G.TPFloor3 then
            tp3Done = false
            continue
        end

        if not tp3Done then
            local floor = GetHighestFloor()
            if floor and floor:FindFirstChild("ExitTeleporter")
            and floor.ExitTeleporter:FindFirstChild("Root") then

                GetHRP().CFrame =
                    floor.ExitTeleporter.Root.CFrame * CFrame.new(0,3,0)
                tp3Done = true
            end
        end
    end

end)

function GetNearestExit()

    local hrp = GetHRP()

    if not hrp then return end

    local nearest, dist = nil, math.huge

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit and exit:FindFirstChild("Root") then
            local d = (hrp.Position - exit.Root.Position).Magnitude
            if d < dist then
                dist = d
                nearest = exit.Root
            end
        end
    end

    return nearest

end

task.spawn(function()

    while task.wait(0.3) do
        if not _G.TPFloor4 then
            tp4Done = false
            continue
        end

        if not tp4Done then
            local root = GetNearestExit()
            if root then
                GetHRP().CFrame = root.CFrame * CFrame.new(0,3,0)
                tp4Done = true
            end
        end
    end

end)

local PlrList = {}   

spawn(function()

    while wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Aim Player" then
                local target = Players:FindFirstChild(getgenv().PlayersList)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if target.Team ~= plr.Team then
                        MousePos = target.Character.HumanoidRootPart.Position
                    end
                end
            end
        end)
    end

end)

spawn(function()

    while wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Nearest Aim" then
                local MaxDistance = math.huge
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= plr and v.Team ~= plr.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Distance = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < MaxDistance then
                            MaxDistance = Distance
                            MousePos = v.Character.HumanoidRootPart.Position
                        end
                    end
                end
            end
        end)
    end

end)

task.spawn(function()

    while task.wait(Sec) do
        pcall(function()
            if _G.AimCam then
                local camera = workspace.CurrentCamera
                closestplayer = function()
                    local dist = math.huge
                    local target = nil
                    for _, v in next, ply:GetPlayers() do
                        if v ~= plr then
                            if v.Character and v.Character:FindFirstChild("Head") and _G.AimCam and v.Character.Humanoid.Health > 0 then
                                local Mag = (v.Character.Head.Position - plr.Character.Head.Position).Magnitude
                                if Mag < dist then
                                    dist = Mag
                                    target = v
                                end
                            end
                        end
                    end
                    return target
                end
                repeat
                    task.wait()
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestplayer().Character.HumanoidRootPart.Position)
                until _G.AimCam == false or Mag > dist
            end
        end)
    end

end)

spawn(function()

    while task.wait(1) do
        if _G.AutoReceivePlayerQuest then
            pcall(function()
                -- only ask for a new target when there is no active player quest (it used to re-request every second)
                if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
                end
            end)
        end
    end

end)

spawn(function()

    local lastAbandon = 0

    while task.wait() do
        if _G.AutoPlayerHunter then
            -- the whole body is protected: it used to be bare, so one nil (target left / respawned) killed this
            -- loop thread for good and the toggle silently stopped working
            pcall(function()
                local Main = game.Players.LocalPlayer.PlayerGui.Main
                if Main.Quest.Visible == false then
                    task.wait(0.5)
                    if _G.AutoPlayerHunter then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
                    end
                else
                    local questText = Main.Quest.Container.QuestTitle.Title.Text
                    for _, target in pairs(game:GetService("Workspace").Characters:GetChildren()) do
                        if not _G.AutoPlayerHunter then break end
                        if target ~= game.Players.LocalPlayer.Character and string.find(questText, target.Name, 1, true) then
                            local killed, targetLeft = false, false
                            repeat
                                task.wait()
                                local hrp = target:FindFirstChild("HumanoidRootPart")
                                local hum = target:FindFirstChild("Humanoid")
                                if not target.Parent or not hrp or not hum then targetLeft = true break end
                                if hum.Health <= 0 then killed = true break end

                                if AutoHaki then AutoHaki() end
                                if EquipWeapon then EquipWeapon(_G.SelectWeapon) end
                                Useskill = true

                                _tp(hrp.CFrame * CFrame.new(1, 7, 3))

                                hrp.Size = Vector3.new(60, 60, 60)

                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            until _G.AutoPlayerHunter == false

                            Useskill = false
                            -- Reset the quest only when the target died or left. The old code abandoned the quest
                            -- every time the chase loop ended, including when the user had just switched it off.
                            -- (at most once per 5s: while the quest window is still up, a finished target would
                            -- otherwise be "finished" again every frame)
                            if (killed or targetLeft) and _G.AutoPlayerHunter and tick() - lastAbandon > 5 then
                                lastAbandon = tick()
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                            end
                        end
                    end
                end
            end)
        end
    end

end)

spawn(function()

    while task.wait(0.5) do
        if _G.AutoPvP then
            local playerGui = game.Players.LocalPlayer.PlayerGui
            if playerGui and playerGui.Main and playerGui.Main:FindFirstChild("PvpDisabled") then
                if playerGui.Main.PvpDisabled.Visible then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    end)
                end
            end
        end
    end

end)

spawn(function()

    while task.wait(0.1) do
        if _G.SafeMode then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local targetPos = hrp.CFrame * CFrame.new(0, 1000, 0)
                _tp(targetPos) 
            end
        end
    end

end)

local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local flying = false
local flySpeed = 50
local flyConnection
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local bg, bv

function updateControlsFromJoystick()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local move = hum.MoveDirection
        local camCF = workspace.CurrentCamera and workspace.CurrentCamera.CFrame
        if camCF and move.Magnitude > 0.05 then
            local rel = camCF:VectorToObjectSpace(move)
            ctrl.f = rel.Z < -0.1 and 1 or (rel.Z > 0.1 and -1 or 0)
            ctrl.b = 0
            ctrl.l = rel.X < -0.1 and -1 or 0
            ctrl.r = rel.X > 0.1 and 1 or 0
        else
            ctrl.f = 0; ctrl.b = 0; ctrl.l = 0; ctrl.r = 0
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and flying then
        if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1
        elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = -1
        elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = -1
        elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 1
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if flying then
        if input.KeyCode == Enum.KeyCode.W and ctrl.f == 1 then ctrl.f = 0
        elseif input.KeyCode == Enum.KeyCode.S and ctrl.b == -1 then ctrl.b = 0
        elseif input.KeyCode == Enum.KeyCode.A and ctrl.l == -1 then ctrl.l = 0
        elseif input.KeyCode == Enum.KeyCode.D and ctrl.r == 1 then ctrl.r = 0
        end
    end
end)

function setupMobileControls()

    local controlConnection

    controlConnection = RunService.Heartbeat:Connect(function()
        if flying then
            updateControlsFromJoystick()
        else
            if controlConnection then
                controlConnection:Disconnect()
            end
        end
    end)

end

function toggleFly(value)

    flying = value

    if flying then
        if not player.Character then return end
        
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local rootPart
        
        if player.Character:FindFirstChild("Torso") then
            rootPart = player.Character.Torso
        else
            rootPart = player.Character.UpperTorso
        end
        
        if not humanoid or not rootPart then return end
        
    
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
            end
        end
        
      
        local descendantAddedConnection
        descendantAddedConnection = player.Character.DescendantAdded:Connect(function(descendant)
            if flying and descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.Massless = true
            end
        end)
        
        bg = Instance.new("BodyGyro", rootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        
        bv = Instance.new("BodyVelocity", rootPart)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        humanoid.PlatformStand = true
        
        setupMobileControls()
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not player.Character then
                return
            end
            
      
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
            
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + 
                              ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - 
                              workspace.CurrentCamera.CoordinateFrame.p)) * flySpeed
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
            
            bg.cframe = workspace.CurrentCamera.CoordinateFrame
        end)
        
        
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
          
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Massless = false
                end
            end
            
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
        
        ctrl = {f = 0, b = 0, l = 0, r = 0}
    end

end
_G.toggleFly = toggleFly

function updateFlySpeed(value)

    flySpeed = value

end
_G.updateFlySpeed = updateFlySpeed

function NoCooldown()

    local dodgeScript = game.Players.LocalPlayer.Character:WaitForChild("Dodge")

    for i, v in next, getgc() do
        if typeof(v) == "function" then
            local funcEnv = getfenv(v)
            if funcEnv.script == dodgeScript then
                for i2, v2 in next, getupvalues(v) do
                    if tostring(v2) == "0.4" then
                        setupvalue(v, i2, 0)
                    end
                end
            end
        end
    end

end

spawn(function()

    while wait(.2) do
        pcall(function()
            if InfAblities then
                if not plr.Character.HumanoidRootPart:FindFirstChild("Agility") then
                    local agility = replicated.FX["Agility"]:Clone()
                    agility.Name = "Agility"
                    agility.Parent = plr.Character.HumanoidRootPart
                end
            else
                local ag = plr.Character.HumanoidRootPart:FindFirstChild("Agility") if ag then ag:Destroy() end
            end
        end)
    end

end)

spawn(function()

    while wait(Sec) do
        if _G.AcceptAlly then
            pcall(function()
                for _, v in pairs(ply:GetChildren()) do
                    if v.Name ~= plr.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("AcceptAlly", v.Name)
                    end
                end
            end)
        end
    end

end)

spawn(function()

  while wait(Sec) do
    if _G.TPNpc then
	 pcall(function()
       for __, v in pairs(replicated.NPCs:GetChildren()) do
       if v.Name == NPClist then _tp(v.HumanoidRootPart.CFrame) end
       end                	   	   
	 end)
    end
  end

end)

local replicated = game:GetService("ReplicatedStorage")

spawn(function()

  while wait(Sec) do
    pcall(function()
      if _G.PortalUnLock then        
         if Attack.Pos(CstlePos_Miti,8) then
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
         elseif Attack.Pos(Man3Pos_Miti,8) then
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
         elseif Attack.Pos(HydraPos_Miti,8) then                    
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5748.7587890625, 610.44982910156, -267.81704711914))
         elseif Attack.Pos(HydratoCastle,8) then                   
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
        end
      end
    end)
  end

end)

task.spawn(function()

  while task.wait() do
    if _G.daylightN then
      if _G.SelectDN == "Day" then
        Lighting.ClockTime = 12
      elseif _G.SelectDN == "Night" then
        Lighting.ClockTime = 0
      end
    end
  end

end)

spawn(function()

  while task.wait() do
    if _G.WalkWater then
      pcall(function()
	   if plr.Character and plr.Character:FindFirstChild("LeftFoot") then
	   local upval0 = replicated.Assets.Models.IceSpikes4:Clone()
        upval0.Parent = workspace
        upval0.Size = Vector3.new(3+math.random(10,12),1.7,3+math.random(10,12))
        upval0.Color = Color3.fromRGB(128,187,219)
        upval0.CFrame = CFrame.new(plr.Character.Head.Position.X,-3.8,plr.Character.Head.Position.Z)*CFrame.Angles((math.random()-0.5)*0.06, math.random()*7,(math.random()-0.5)*0.07)
        local var85={};
        var85.Size=Vector3.new(0,0.3,0)
        local var3=TW:Create(upval0,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),var85)
        var3.Completed:Connect(function()
          upval0:Destroy()
        end)
          var3:Play()
	    end	
      end)
    end
  end

end)

-- ==========================================
-- ESP SYSTEM
-- ==========================================
Number = Number or math.random(1, 1000000)
local TeamSelf = plr.Team

EspPly = function()
    for _,v in next, game.Players:GetChildren() do
        pcall(function()
            if not isnil(v.Character) then
                if PlayerEsp then
                    if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v.Character.Head)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Text = (v.Name ..' \n'.. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Team == TeamSelf then
                            name.TextColor3 = Color3.new(0,0,254)
                        else
                            name.TextColor3 = Color3.new(255,0,0)
                        end
                    else
                        if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                            v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                        end
                    end
                else
                    if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                        v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end
        end)
    end
end

LocationEsp = function() 
    for _,v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
        pcall(function()
            if IslandESP then 
                if (v.Name ~= "Sea") then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(98,252,252)
                        name.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end

DevEsp = function()
    for i,v in next, workspace:GetChildren() do
        pcall(function()
            if DevilFruitESP then
                if string.find(v.Name, "Fruit") then   
                    if not v.Handle:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v.Handle)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255,255,255)
                        name.Text = (v.Name ..' \n'.. round((plr.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    else
                        v.Handle['NameEsp'..Number].TextLabel.Text = ('[' ..v.Name ..']' ..'   \n'.. round((plr.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end)
    end
end

flowerEsp = function()
    for i,v in pairs(workspace:GetChildren()) do
        pcall(function()
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if FlowerESP then 
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(88, 214, 252)
                        if v.Name == "Flower1" then 
                            name.Text = ("Blue Flower" ..' \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        elseif v.Name == "Flower2" then
                            name.Text = ("Red Flower" ..' \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                else
                    if v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end   
        end)
    end
end

EventIslandEsp = function()
    for i, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
        pcall(function()
            if EspEventIsland then
                if (v.Name == "Mirage Island" or v.Name =="Prehistoric Island" or v.Name =="Kitsune Island") then
                    if not v:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", v)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M")
                    else
                        v.NameEsp.TextLabel.Text = v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M"
                    end
                end
            else
                if v:FindFirstChild("NameEsp") then
                    v:FindFirstChild("NameEsp"):Destroy()
                end
            end
        end)
    end
end

gearEsp = function()
    local mystic = workspace.Map:FindFirstChild("MysticIsland")
    if not mystic then return end   -- not spawned yet (this threw "attempt to index nil" every time)
    for _,v in pairs(mystic:GetDescendants()) do
        pcall(function()
            if ESPGear then
                if v.Name == "Part" and v.Material == Enum.Material.Neon then
                    if not v:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", v)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = ("Gear" .."   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3).. " M")
                    else
                        v["NameEsp"].TextLabel.Text =("Gear" .."   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3).. " M")
                    end
                end
            else
                if v:FindFirstChild("NameEsp") then
                    v:FindFirstChild("NameEsp"):Destroy()
                end
            end
        end)
    end
end

AdvanFruitEsp = function()
    if advanEsp then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Advanced Fruit Dealer" then
                if not workspace:FindFirstChild("Adv") then
                    Adv = Instance.new("Part")
                    Adv.Name = "Adv"
                    Adv.Transparency = 1
                    Adv.Size = Vector3.new(1,1,1)
                    Adv.Anchored = true
                    Adv.CanCollide = false
                    Adv.Parent = workspace
                    Adv.CFrame = v.HumanoidRootPart.CFrame    
                elseif workspace:FindFirstChild("Adv") then
                    if not Adv:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", Adv)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = Adv
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
                    else
                        Adv["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    
                    end                              
                end
            end
        end
    else
        if workspace:FindFirstChild("Adv") then
            workspace:FindFirstChild("Adv"):Destroy()
        end    
    end
end

HakiClorEsp = function()
    if ColorEsp then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Barista Cousin" then
                if not workspace:FindFirstChild("Gay") then
                    Gay = Instance.new("Part")
                    Gay.Name = "Gay"
                    Gay.Transparency = 1
                    Gay.Size = Vector3.new(1,1,1)
                    Gay.Anchored = true
                    Gay.CanCollide = false
                    Gay.Parent = workspace
                    Gay.CFrame = v.HumanoidRootPart.CFrame    
                elseif workspace:FindFirstChild("Gay") then
                    if not Gay:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", Gay)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = Gay
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
                    else
                        Gay["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    
                    end                              
                end
            end
        end
    else
        if workspace:FindFirstChild("Gay") then
            workspace:FindFirstChild("Gay"):Destroy()
        end    
    end
end

LegenSword = function()
    if LegenS then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Legendary Sword Dealer" then
                if not workspace:FindFirstChild("Lgd") then
                    Lgd = Instance.new("Part")
                    Lgd.Name = "Lgd"
                    Lgd.Transparency = 1
                    Lgd.Size = Vector3.new(1,1,1)
                    Lgd.Anchored = true
                    Lgd.CanCollide = false
                    Lgd.Parent = workspace
                    Lgd.CFrame = v.HumanoidRootPart.CFrame    
                elseif workspace:FindFirstChild("Lgd") then
                    if not Lgd:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", Lgd)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = Lgd
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
                    else
                        Lgd["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    
                    end                              
                end
            end
        end
    else
        if workspace:FindFirstChild("Lgd") then
            workspace:FindFirstChild("Lgd"):Destroy()
        end    
    end
end

ChestEsp = function()
    if ChestESP then
        local CollectionService = game:GetService("CollectionService")
        local Chests = CollectionService:GetTagged("_ChestTagged")        
        for _, Chest in ipairs(Chests) do
            pcall(function()
                local chestPos = Chest:GetPivot().Position
                local distanceMagnitude = (chestPos - plr.Character.Head.Position).Magnitude
                local sanitizedFullName = Chest:GetFullName():gsub("[^%w_]", "_")
                local existingEsp = Chest:FindFirstChild("ChestEspAttachment")                    
                
                if not existingEsp then
                    local attachment = Instance.new("Attachment")
                    attachment.Name = "ChestEspAttachment"
                    attachment.Parent = Chest
                    attachment.Position = Vector3.new(0, 3, 0)                     
                    
                    local nameEsp = Instance.new("BillboardGui")
                    nameEsp.Name = "NameEsp"
                    nameEsp.Size = UDim2.new(0, 200, 0, 30)
                    nameEsp.Adornee = attachment
                    nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)
                    nameEsp.AlwaysOnTop = true
                    nameEsp.Parent = attachment                        
                    
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Font = Enum.Font.Code
                    nameLabel.TextSize = 14
                    nameLabel.TextWrapped = true
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.TextYAlignment = Enum.TextYAlignment.Top
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextStrokeTransparency = 0.5
                    nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
                    nameLabel.Parent = nameEsp
                end
                
                local nameEsp = existingEsp and existingEsp:FindFirstChild("NameEsp")
                if nameEsp then
                    local displayDistance = math.floor(distanceMagnitude / 3)
                    local chestName = Chest.Name:gsub("Label", "")
                    nameEsp.TextLabel.Text = string.format("[%s] %d M", chestName, displayDistance)
                end
            end)
        end
    else
        for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
            local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
            if espAttachment then
                espAttachment:Destroy()
            end
        end
    end
end

berriesEsp = function()
    if BerryEsp then
        local CollectionService = game:GetService("CollectionService")
        local BerryBushes = CollectionService:GetTagged("BerryBush")
        for _, Bush in ipairs(BerryBushes) do
            pcall(function()
                local bushPosition = Bush.Parent:GetPivot().Position
                for _, BerryName in pairs(Bush:GetAttributes()) do
                    if BerryName then
                        local espPartName = "BerryEspPart_" .. BerryName .. "_" .. tostring(bushPosition)
                        local existingEsp = workspace:FindFirstChild(espPartName)
                        
                        if not existingEsp then
                            existingEsp = Instance.new("Part")
                            existingEsp.Name = espPartName
                            existingEsp.Transparency = 1
                            existingEsp.Size = Vector3.new(1, 1, 1)
                            existingEsp.Anchored = true
                            existingEsp.CanCollide = false
                            existingEsp.Parent = workspace
                            existingEsp.CFrame = CFrame.new(bushPosition)
                        end
                        
                        if not existingEsp:FindFirstChild("NameEsp") then
                            local nameEsp = Instance.new("BillboardGui", existingEsp)
                            nameEsp.Name = "NameEsp"
                            nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)
                            nameEsp.Size = UDim2.new(0, 200, 0, 30)
                            nameEsp.Adornee = existingEsp
                            nameEsp.AlwaysOnTop = true
                            
                            local nameLabel = Instance.new("TextLabel", nameEsp)
                            nameLabel.Font = Enum.Font.Code
                            nameLabel.TextSize = 14
                            nameLabel.TextWrapped = true
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.TextYAlignment = Enum.TextYAlignment.Top
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.TextStrokeTransparency = 0.5
                            nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
                        end
                        
                        local nameEsp = existingEsp:FindFirstChild("NameEsp")
                        local distance = (plr.Character.Head.Position - bushPosition).Magnitude / 3
                        if nameEsp then
                            nameEsp.TextLabel.Text = ('[' .. BerryName .. ']' .. " " .. math.round(distance) .. " M")
                        end
                    end
                end
            end)
        end
    else
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then
                v:Destroy()
            end
        end
    end
end

-- Export to Core table
Core.EspPly = EspPly
Core.LocationEsp = LocationEsp
Core.DevEsp = DevEsp
Core.flowerEsp = flowerEsp
Core.EventIslandEsp = EventIslandEsp
Core.gearEsp = gearEsp
Core.AdvanFruitEsp = AdvanFruitEsp
Core.HakiClorEsp = HakiClorEsp
Core.LegenSword = LegenSword
Core.ChestEsp = ChestEsp
Core.berriesEsp = berriesEsp