--[[
     recommended version: v3.11
     note: you might have to disable the rage in the last level and kill the chicken yourself.
]]

local lua = api.register("Halloween Towers AutoFarm", "ragebot planner")
local library = api.ui.library
local toggles = library.Toggles

local services = { players = game:GetService("Players"), workspace = game:GetService("Workspace"), collection = game:GetService("CollectionService") }
local lp = services.players.LocalPlayer
local gameplay_utility = require(game:GetService("ReplicatedStorage").Modules.GameplayUtility)
local orbit_speed = 250
local melee_orbit_radius = 15
local orbit_lift = 15
local boss_lift = -15
local last_cf
local touched = setmetatable({}, { __mode = "k" })
local drops = setmetatable({}, { __mode = "k" })

local box = lua:box("main", "left", "tower auto farm")
box:AddToggle("tower_enabled", { Text = "enabled", Default = false, Callback = function(value)
    toggles.ragebot_enabled:SetValue(value)
    if value or not last_cf then return end
    local cf = last_cf
    last_cf = nil
    api.ragebot.desync(nil)
    task.delay(0.1, function()
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(cf.Position) * root.CFrame.Rotation end
    end)
end })
box:AddToggle("tower_heal", { Text = "auto heal", Default = true })
box:AddToggle("tower_ammo", { Text = "auto ammo", Default = true })

local function watch(part)
    if part.Name == "_drop" then drops[part] = true
    elseif part:IsA("Model") and part.Parent and part.Parent:IsA("BasePart") and part:FindFirstChild("Primary") then drops[part.Parent] = true end
end
local added = services.workspace.DescendantAdded:Connect(watch)
local removed = services.workspace.DescendantRemoving:Connect(function(part) drops[part] = nil end)
for _, part in services.workspace:GetChildren() do watch(part) end

local function get_tower() return services.workspace:FindFirstChild("Zombie Tower") or services.workspace:FindFirstChild("Gargoyle Tower") end
local function entities()
    local tower = get_tower()
    local holder = tower and tower:FindFirstChild("Entities")
    local list = holder and holder:GetChildren() or {}
    if tower then for _, d in services.collection:GetTagged("Entity") do if d:IsDescendantOf(tower) and d:FindFirstChildOfClass("Humanoid") then local already = false; for _, v in list do if v == d then already = true; break end end; if not already then table.insert(list, d) end end end end
    return list
end
local function is_he_gay(name)
    local low = name:lower()
    return low:find("skeleton") or low:find("ghost") or low:find("gargoyle") or low:find("grim") or low:find("reaper")
end
local function pick_target(origin)
    local best, best_part, best_d = nil, nil, math.huge
    local skel, skel_part, skel_d = nil, nil, math.huge
    for _, ent in entities() do
        local ep = ent:FindFirstChild("PinataHitbox") or ent:FindFirstChild("HitboxHead") or ent:FindFirstChild("HitboxBody") or ent:FindFirstChild("HumanoidRootPart") or ent:FindFirstChildWhichIsA("BasePart")
        if ep then
            local hum = ent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local offset = ep.Position - origin
                local d = offset:Dot(offset)
                if d < best_d then best_d, best, best_part = d, ent, ep end
                if is_he_gay(ent.Name) and d < skel_d then skel_d, skel, skel_part = d, ent, ep end
            end
        end
    end
    if skel_part then return skel, skel_part, skel_d end
    return best, best_part, best_d
end
local function is_melee(item)
    if type(item) ~= "table" then return false end
    local info = rawget(item, "Info")
    return info ~= nil and (rawget(info, "Class") == "Melee" or rawget(info, "Type") == "Melee")
end
local function fix_slots(fighter)
    local items = fighter and rawget(fighter, "Items")
    if type(items) ~= "table" then return end
    local second, third = items[2], items[3]
    if type(second) == "table" and is_melee(second) and not is_melee(third) then items[2], items[3] = third, second end
end
local function ammo_low(fighter)
    local items = fighter and rawget(fighter, "Items")
    if type(items) ~= "table" then return false end
    for _, item in items do
        if type(item) == "table" then
            local data = rawget(item, "Data"); local info = rawget(item, "Info")
            if data and info then
                local count = rawget(data, "Ammo"); local max = rawget(info, "MaxAmmo")
                if type(count) == "number" and type(max) == "number" and count < max then return true end
                local reserve = rawget(data, "AmmoReserve"); local max_reserve = rawget(info, "MaxAmmoReserve")
                if type(reserve) == "number" and type(max_reserve) == "number" and max_reserve > 0 and reserve < max_reserve then return true end
            end
        end
    end
    return false
end
local function touch(part, target) firetouchinterest(part, target, 0); firetouchinterest(part, target, 1) end

local blocked_params = OverlapParams.new(); blocked_params.FilterType = Enum.RaycastFilterType.Include
local safe_params = OverlapParams.new(); safe_params.FilterType = Enum.RaycastFilterType.Include
local function refresh_blocked()
    local blocked = {}
    for _, tag in services.collection:GetTags() do
        local low = tag:lower()
        if low == "outofboundspart" or low == "lava" or low == "hazard" or low == "killzone" then
            for _, inst in services.collection:GetTagged(tag) do
                if inst:IsA("BasePart") then blocked[#blocked+1] = inst end
                for _, d in inst:GetDescendants() do if d:IsA("BasePart") then blocked[#blocked+1] = d end end
            end
        end
    end
    for _, d in services.workspace:GetDescendants() do
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("lava") or n:find("hazard") or n:find("burn") or n:find("kill") then
                local found = false
                for _, b in blocked do if b == d then found = true; break end end
                if not found then blocked[#blocked+1] = d end
            end
        end
    end
    blocked_params.FilterDescendantsInstances = blocked
    local safe = {}
    for _, inst in services.collection:GetTagged("OutOfBoundsSafePart") do
        if inst:IsA("BasePart") then safe[#safe+1] = inst end
        for _, d in inst:GetDescendants() do if d:IsA("BasePart") then safe[#safe+1] = d end end
    end
    safe_params.FilterDescendantsInstances = safe
end
refresh_blocked()
local function is_blocked_strict(pos)
    local overlap = workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.new(4, 4, 4), blocked_params)
    if #overlap == 0 then return false end
    local safe_overlap = workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.new(4, 4, 4), safe_params)
    return #safe_overlap == 0
end
local function safe_cframe_for(pos, lift, health)
    local preferred = lift
    local candidates = {}
    local vals = { preferred, 5, 3, 1 }
    for _, v in vals do
        local found = false
        for _, c in candidates do if c == v then found = true; break end end
        if not found then candidates[#candidates+1] = v end
    end
    for _, l in candidates do
        local p = pos + Vector3.new(0, l, 0)
        if not is_blocked_strict(p) then return CFrame.new(p) end
    end
    return CFrame.new(pos)
end
local function advance(part)
    local tower = get_tower()
    if not tower then return end
    for _, trig in services.collection:GetTagged("MobTrigger") do
        if not touched[trig] and trig:IsDescendantOf(tower) then touched[trig] = true; touch(part, trig); return end
    end
end

local refresh_next = 0
function lua.step(dt, duel, status)
    local now_tick = tick()
    if now_tick > refresh_next then refresh_blocked(); refresh_next = now_tick + 1 end
    if not toggles.tower_enabled.Value then return "stop" end
    local char = lp.Character; if not char then return end
    local fighter = api.game.fighter(lp); fix_slots(fighter)
    local root = char:FindFirstChild("HumanoidRootPart")
    local part = char:FindFirstChild("HitboxBody") or root
    if not (root and part) then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local heal = toggles.tower_heal.Value and hum ~= nil and hum.Health > 0 and hum.Health < hum.MaxHealth
    local ammo = toggles.tower_ammo.Value and ammo_low(fighter)
    for drop in drops do
        if drop.CanTouch and drop:FindFirstChildOfClass("TouchTransmitter") then
            local want
            if drop:FindFirstChild("Weapon") then want = drop.Weapon
            elseif heal and drop:FindFirstChild("Health") then want = drop.Health
            elseif ammo and (drop:FindFirstChild("Ammo") or drop:FindFirstChild("AmmoBalanced")) then want = drop.Ammo or drop.AmmoBalanced
            else local model = drop:FindFirstChildOfClass("Model"); if model and model.Name ~= "Health" and model.Name ~= "Ammo" and model.Name ~= "AmmoBalanced" and model.Name ~= "Revive" then want = model end end
            if want then touch(part, drop) end
        end
    end
    local target_ent, target_part = pick_target(part.Position)
    if not target_part then advance(part); return end
    local is_chicken = target_ent.Name:lower():find("chicken")
    local lift = is_chicken and 0 or (is_he_gay(target_ent.Name) and boss_lift or orbit_lift)
    local base
    if is_chicken then
        base = target_part.Position
    else
        local angle = os.clock() * orbit_speed * 2 * math.pi
        base = target_part.Position + Vector3.new(math.cos(angle) * melee_orbit_radius, 0, math.sin(angle) * melee_orbit_radius)
    end
    local cf = safe_cframe_for(base, lift)
    last_cf = cf
    api.ragebot.desync(cf)
end

function lua.target(duel, item)
    if not toggles.tower_enabled.Value then api.ragebot.desync(nil); return nil end
    local char = lp.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local origin = root.Position
    local _, best_part, best_d = pick_target(origin)
    if not best_part then api.ragebot.desync(nil); return nil end
    return { player = lp, character = char, head = best_part, root = best_part, part = best_part, position = best_part.Position, distance = math.sqrt(best_d) }
end
api.ui.set("ragebot_weapon", "melee")
api.ui.set("ragebot_last_weapon", "melee")

lua.on_unload = function()
    added:Disconnect()
    removed:Disconnect()
    toggles.ragebot_enabled:SetValue(false)
end
lua:allow_manual(false)
lua:override()
