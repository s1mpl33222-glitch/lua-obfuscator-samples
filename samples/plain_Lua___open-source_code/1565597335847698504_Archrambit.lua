--[[
    Knife only - auto-equip a "Keyrambit" skin (client-side, visual only)

    - Only the weapon named "Knife" is touched (case-insensitive, spaces ignored).
      Every other weapon uses the real game logic.
    - Looks through CosmeticLibrary for every Skin whose name contains KEYWORD
      ("keyrambit", spaces ignored) and equips one automatically.
    - Nothing is sent to the server, so only you see it.
    - Untested against the live game: if a module path or field name changed in an
      update, the pcall guards will print a warning instead of erroring.
]]

-- (wrapped in pcall so a failure here can never stop the Archrambit script below)
local frontOk, frontErr = pcall(function()

---------------------------------------------------------------- config
local KEYWORD = "keyrambit" -- any skin whose name contains this (case-insensitive, spaces ignored)
local PICK    = nil     -- optional: exact skin name to prefer, e.g. "Key Rambit"
---------------------------------------------------------------------------

local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local lp      = Players.LocalPlayer

local ctrl = lp.PlayerScripts:WaitForChild("Controllers", 10)
local mods = RS:WaitForChild("Modules", 10)

local enumLib = require(mods:WaitForChild("EnumLibrary", 10))
if enumLib then pcall(function() enumLib:WaitForEnumBuilder() end) end
local cosLib  = require(mods:WaitForChild("CosmeticLibrary", 10))
local datCtrl = require(ctrl:WaitForChild("PlayerDataController", 10))

local Cosmetics = cosLib.Cosmetics

---------------------------------------------------------------- helpers
local function wepName(w)
    if type(w) == "table" then w = w.Name end
    return w
end

local function isKnife(w)
    w = wepName(w)
    if type(w) ~= "string" then return false end
    return (w:lower():gsub("%s+", "")) == "knife"
end

local function isKeyName(n)
    return type(n) == "string" and (n:lower():gsub("%s+", "")):find(KEYWORD, 1, true) ~= nil
end

local function isKeySkin(n)
    local c = isKeyName(n) and Cosmetics[n]
    return c and c.Type == "Skin" or false
end

local function mkSkin(name)
    local base = Cosmetics[name]
    if not base then return nil end
    local d = {}
    for k, v in pairs(base) do d[k] = v end
    d.Name = name
    d.Type = d.Type or "Skin"
    d.Seed = d.Seed or math.random(1, 1000000)
    if enumLib then
        local ok, id = pcall(enumLib.ToEnum, enumLib, name)
        if ok and id then
            d.Enum = id
            d.ObjectID = d.ObjectID or id
        end
    end
    return d
end

---------------------------------------------------------------- find + pick the skin
local matches = {}
for name, c in pairs(Cosmetics) do
    if type(name) == "string" and c.Type == "Skin" and isKeyName(name) then
        table.insert(matches, name)
    end
end
table.sort(matches)

if #matches == 0 then
    warn("[Knife-Key] no skins containing '" .. KEYWORD .. "' found")
    return
end

local chosen = matches[1]
if PICK and isKeySkin(PICK) then chosen = PICK end

local knifeSkin = mkSkin(chosen)
print(("[Knife-Key] %d matching skin(s); equipping '%s'"):format(#matches, chosen))
print("[Knife-Key] matches: " .. table.concat(matches, ", "))

---------------------------------------------------------------- ownership (Knife + Keyrambit skins only)
for _, key in ipairs({ "OwnsCosmetic", "OwnsCosmeticNormally", "OwnsCosmeticUniversally", "OwnsCosmeticForWeapon" }) do
    local orig = cosLib[key]
    if type(orig) == "function" then
        cosLib[key] = function(self, inv, nm, wep, ...)
            if isKnife(wep) and isKeySkin(nm) then return true end
            return orig(self, inv, nm, wep, ...)
        end
    end
end

---------------------------------------------------------------- inventory view
local origGet = datCtrl.Get
datCtrl.Get = function(self, key, ...)
    local val = origGet(self, key, ...)
    if key == "CosmeticInventory" then
        local prx = {}
        if val then for k, v in pairs(val) do prx[k] = v end end
        return setmetatable(prx, {
            __index = function(_, k)
                if isKeySkin(k) then return true end
                return nil
            end,
        })
    end
    return val
end

---------------------------------------------------------------- loadout view (Knife only)
local origGetWep = datCtrl.GetWeaponData
datCtrl.GetWeaponData = function(self, wn, ...)
    local d = origGetWep(self, wn, ...)
    if not d then return nil end
    if isKnife(wn) and knifeSkin then
        local m = {}
        for k, v in pairs(d) do m[k] = v end
        m.Name = wn
        m.Skin = knifeSkin
        return m
    end
    return d
end

---------------------------------------------------------------- remotes (only swallow Knife + Keyrambit equips)
local fightCtrl
pcall(function() fightCtrl = require(ctrl:WaitForChild("FighterController", 10)) end)

if hookmetamethod and getnamecallmethod then
    local remotes  = RS:FindFirstChild("Remotes")
    local dataRem  = remotes and remotes:FindFirstChild("Data")
    local equipRem = dataRem and dataRem:FindFirstChild("EquipCosmetic")

    if equipRem then
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            if self == equipRem and getnamecallmethod() == "FireServer" then
                local a = { ... }
                local wn, ct, cn = a[1], a[2], a[3]
                if isKnife(wn) and ct == "Skin" and isKeySkin(cn) then
                    knifeSkin = mkSkin(cn)  -- user picked another Keyrambit skin in the UI
                    task.defer(function()
                        pcall(function() datCtrl.CurrentData:Replicate("WeaponInventory") end)
                    end)
                    return
                end
            end
            return old(self, ...)
        end)
    end
else
    warn("[Knife-Key] hookmetamethod not available; UI equips will still hit the server")
end

---------------------------------------------------------------- first-person viewmodel
local function applySkin(data, enumFn)
    if not (knifeSkin and data) then return end
    if enumFn then
        data[enumFn("Skin")] = knifeSkin
        data[enumFn("Name")] = knifeSkin.Name
    else
        data.Skin = knifeSkin
        data.Name = knifeSkin.Name
    end
end

local buildingWep
local cliItem
pcall(function()
    cliItem = require(lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
end)

if cliItem and cliItem._CreateViewModel then
    local origCVM = cliItem._CreateViewModel
    cliItem._CreateViewModel = function(self, vmRef, ...)
        local owner = self.ClientFighter and self.ClientFighter.Player
        buildingWep = (owner == lp) and self.Name or nil
        if owner == lp and isKnife(self.Name) then
            local dk = self:ToEnum("Data")
            if vmRef[dk] then
                applySkin(vmRef[dk], function(n) return self:ToEnum(n) end)
            elseif vmRef.Data then
                applySkin(vmRef.Data)
            end
        end
        local r = origCVM(self, vmRef, ...)
        buildingWep = nil
        return r
    end
end

pcall(function()
    local vmMod = lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
    if not vmMod then return end
    local CVM = require(vmMod)
    local origNew = CVM.new
    CVM.new = function(repData, cliItm, ...)
        local owner = cliItm.ClientFighter and cliItm.ClientFighter.Player
        local wn = buildingWep or cliItm.Name
        if owner == lp and isKnife(wn) and knifeSkin then
            local RC = require(RS.Modules.ReplicatedClass)
            local dk = RC:ToEnum("Data")
            repData[dk] = repData[dk] or {}
            repData[dk][RC:ToEnum("Skin")] = knifeSkin
        end
        return origNew(repData, cliItm, ...)
    end
end)

task.defer(function()
    pcall(function() datCtrl.CurrentData:Replicate("WeaponInventory") end)
end)

print("[Knife-Key] loaded")

end)
if not frontOk then warn("[Knife-Key] front block failed: " .. tostring(frontErr)) end




-- ===== GREEN ENFORCER (runs right after the unlocker, before the replacer) =====
-- Forces the knife green even when the unlocker rebuilds the viewmodel, so it
-- doesn't depend on the replacer matching an asset id.
local GREEN = Color3.fromRGB(110, 255, 140) -- change this to adjust the green
local GREEN_ALL_CAMERA = false -- true = tint EVERY mesh in your viewmodel (arms too)
pcall(function()
	local Players = game:GetService("Players")
	local lp = Players.LocalPlayer
	local ws = game:GetService("Workspace")
	local tinted = setmetatable({}, { __mode = "k" })

	local function nameHit(inst)
		local p = inst
		for _ = 1, 10 do
			if not p or p == ws then break end
			local n = p.Name:lower()
			if n:find("knife", 1, true) or n:find("rambit", 1, true) then return true end
			p = p.Parent
		end
		return false
	end

	local function inMine(inst)
		local cam = ws.CurrentCamera
		return (cam and inst:IsDescendantOf(cam)) or (lp.Character and inst:IsDescendantOf(lp.Character))
	end

	local function tint(inst)
		if tinted[inst] or not (inst:IsA("MeshPart") or inst:IsA("SpecialMesh")) then return end
		if not inMine(inst) then return end
		if not (GREEN_ALL_CAMERA or nameHit(inst)) then return end
		tinted[inst] = true
		local prop = inst:IsA("MeshPart") and "Color" or "VertexColor"
		local function set()
			pcall(function()
				if prop == "Color" then inst.Color = GREEN
				else inst.VertexColor = Vector3.new(GREEN.R, GREEN.G, GREEN.B) end
			end)
		end
		set()
		pcall(function() inst:GetPropertyChangedSignal(prop):Connect(set) end)
	end

	ws.DescendantAdded:Connect(function(d) task.defer(tint, d) end)
	task.spawn(function()
		while true do
			local cam = ws.CurrentCamera
			if cam then for _, d in ipairs(cam:GetDescendants()) do tint(d) end end
			if lp.Character then for _, d in ipairs(lp.Character:GetDescendants()) do tint(d) end end
			task.wait(0.5)
		end
	end)
end)

-- ===== ARCHRAMBIT SKIN =====

-- ArchRambit replacer (same engine as dragon_skin.lua)
-- The mesh + texture are downloaded from GitHub (raw links) on every run and cached
-- into your executor workspace, because getcustomasset needs a real file on disk.

local MESH_URL    = "https://raw.githubusercontent.com/mrbeanissohot/Archrambit/main/archrambiyt.mesh"
local TEXTURE_URL = "https://raw.githubusercontent.com/mrbeanissohot/Archrambit/main/arch_texture.png"

-- cache file names inside the executor workspace (created automatically)
local MESH_CACHE    = "Archrambit/archrambiyt.mesh"
local TEXTURE_CACHE = "Archrambit/arch_texture.png"

local CONFIG = [==[
{
  "replacement_rules": [
    { "name": "re", "replace_ids": [12482022259, 12482022363], "mode": "id", "enabled": true },
    { "name": "xd", "replace_ids": [105653154583773], "mode": "local", "enabled": true, "local_path": "Archrambit/archrambiyt.mesh" },
    { "name": "an", "replace_ids": [12613363718], "mode": "id", "enabled": true, "with_id": 18742841521 },
    { "name": "in / inspect", "replace_ids": [12613329711], "mode": "id", "enabled": true, "with_id": 18742879471 },
    { "name": "hravy", "replace_ids": [12613354440], "mode": "id", "enabled": true, "with_id": 18742868264 },
    { "name": "idle", "replace_ids": [12613190591], "mode": "id", "enabled": true, "with_id": 18742849437 },
    { "name": "sprint", "replace_ids": [12886796453], "mode": "id", "enabled": true, "with_id": 18742894186 }
  ]
}
]==]

-- which cache path comes from which link
local URL_FOR_PATH = {
	[MESH_CACHE]    = MESH_URL,
	[TEXTURE_CACHE] = TEXTURE_URL,
}

local SCALE = 1.45 -- size multiplier for the replaced mesh
local SCALE_BY_ID = {
	-- [12482022430] = 1.5,
}

local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")
local rules = HttpService:JSONDecode(CONFIG).replacement_rules
local lookup, cache, meshCache = {}, {}, {}
local registered, skipped, swapped = 0, 0, 0

local function parseId(v)
	return tonumber(tostring(v):match("(%d+)"))
end

-- download a raw link and save it to the workspace (binary-safe)
local function download(url, path)
	local body
	local req = request or http_request or (syn and syn.request) or (http and http.request)
	if req then
		local ok, res = pcall(req, { Url = url, Method = "GET" })
		if ok and res and res.Success ~= false and (res.StatusCode == nil or res.StatusCode == 200) then
			body = res.Body
		end
	end
	if not body then
		local ok, res = pcall(function() return game:HttpGet(url, true) end)
		if ok then body = res end
	end
	if not body or #body == 0 then return false end
	pcall(function()
		local folder = path:match("^(.*)/[^/]+$")
		if folder and makefolder and not isfolder(folder) then makefolder(folder) end
	end)
	local ok = pcall(writefile, path, body)
	return ok
end

local function loadAsset(path)
	if cache[path] then return cache[path] end
	local url = URL_FOR_PATH[path]
	if url then
		if not download(url, path) then
			warn("[Replacer] download failed: " .. url .. (isfile(path) and " (using cached copy)" or ""))
		end
	end
	for _ = 1, 5 do
		if isfile(path) then
			local ok, asset = pcall(getcustomasset, path)
			if ok and asset then
				cache[path] = asset
				return asset
			end
		end
		task.wait(0.3)
	end
	return nil
end

local function resolve(rule)
	if rule.mode == "local" then
		local asset = loadAsset(rule.local_path)
		if not asset then warn("[Replacer] failed to load: " .. rule.local_path) end
		return asset
	end
	if rule.with_id then return "rbxassetid://" .. rule.with_id end
	return ""
end

local function register(rule)
	if rule.type == "group" then
		for _, c in ipairs(rule.children or {}) do register(c) end
	elseif rule.enabled then
		local target = resolve(rule)
		if target == nil then skipped += 1 return end
		registered += 1
		for _, id in ipairs(rule.replace_ids) do
			local n = parseId(id)
			if n then lookup[n] = target end
		end
	end
end

for _, r in ipairs(rules) do register(r) end
print(("[Replacer] rules registered: %d, skipped: %d"):format(registered, skipped))

local TEXTURE = loadAsset(TEXTURE_CACHE)
if not TEXTURE then warn("[Replacer] texture not loaded: " .. TEXTURE_URL) end

-- Animation.AnimationId added: your with_id rules are animation swaps
local PROPS = {
	MeshPart = { "MeshId" },
	SpecialMesh = { "MeshId" },
	Animation = { "AnimationId" },
	Sound = { "SoundId" },
	Decal = { "Texture" },
	Texture = { "Texture" },
	ImageLabel = { "Image" },
	ImageButton = { "Image" },
}

local seen = setmetatable({}, { __mode = "k" })
local lastScaled = setmetatable({}, { __mode = "k" })

local function scaleMesh(inst, mult)
	local m = mult or SCALE
	if m == 1 then return end
	pcall(function()
		if inst:IsA("MeshPart") then
			local last = lastScaled[inst]
			if last and (inst.Size - last).Magnitude < 0.001 then return end
			local target = inst.Size * m
			inst.Size = target
			lastScaled[inst] = target
		elseif inst:IsA("SpecialMesh") then
			local last = lastScaled[inst]
			if last and (inst.Scale - last).Magnitude < 0.001 then return end
			local target = inst.Scale * m
			inst.Scale = target
			lastScaled[inst] = target
		end
	end)
end

local function hideMesh(inst)
	pcall(function()
		if inst:IsA("MeshPart") then
			inst.Transparency = 1
		elseif inst:IsA("SpecialMesh") then
			inst.Scale = Vector3.new(0, 0, 0)
		end
	end)
end

local function applyMesh(inst, asset)
	if inst:IsA("MeshPart") then
		local ok, err = pcall(function()
			local mp = meshCache[asset]
			if not mp then
				mp = AssetService:CreateMeshPartAsync(asset)
				meshCache[asset] = mp
			end
			inst:ApplyMesh(mp)
		end)
		if not ok then
			warn("[Replacer] ApplyMesh failed: " .. tostring(err))
			pcall(function() inst.MeshId = asset end)
		end
	else
		pcall(function() inst.MeshId = asset end)
	end
end

-- keep the new mesh's own proportions: uniform-fit its longest side to the
-- original part's longest side (ApplyMesh would otherwise stretch it into the old box)
local fitted = setmetatable({}, { __mode = "k" })
local function fitMesh(inst, asset, mult)
	if not inst:IsA("MeshPart") then
		scaleMesh(inst, mult)
		return
	end
	if not fitted[inst] then fitted[inst] = inst.Size end
	local ref = fitted[inst]
	task.spawn(function()
		task.wait(0.1)
		pcall(function()
			local mp = meshCache[asset]
			if not mp then return end
			local nat = mp.Size
			local f = math.max(ref.X, ref.Y, ref.Z) / math.max(nat.X, nat.Y, nat.Z)
			inst.Size = nat * f * (mult or SCALE)
		end)
	end)
end

-- FORCE GREEN: tint the swapped mesh and keep it green even if the game resets it
local watched = setmetatable({}, { __mode = "k" })

local function forceGreen(inst)
	pcall(function()
		if inst:IsA("MeshPart") then
			inst.Color = GREEN
		elseif inst:IsA("SpecialMesh") then
			inst.VertexColor = Vector3.new(GREEN.R, GREEN.G, GREEN.B)
		end
	end)
end

local function applyTexture(inst)
	local prop = inst:IsA("MeshPart") and "TextureID" or "TextureId"
	if TEXTURE then pcall(function() inst[prop] = TEXTURE end) end
	forceGreen(inst)
	for _, c in ipairs(inst:GetChildren()) do
		if c:IsA("SurfaceAppearance") then c:Destroy() end
	end
	if not watched[inst] then
		watched[inst] = true
		inst.ChildAdded:Connect(function(c)
			if c:IsA("SurfaceAppearance") then
				task.defer(function() pcall(function() c:Destroy() end) end)
			end
		end)
		pcall(function()
			inst:GetPropertyChangedSignal(prop):Connect(function()
				if TEXTURE and inst[prop] ~= TEXTURE then pcall(function() inst[prop] = TEXTURE end) end
			end)
		end)
		pcall(function()
			local cp = inst:IsA("MeshPart") and "Color" or "VertexColor"
			inst:GetPropertyChangedSignal(cp):Connect(function() forceGreen(inst) end)
		end)
	end
end

local function handle(inst, p)
	local ok, cur = pcall(function() return inst[p] end)
	if not ok then return end
	local id = parseId(cur)
	local new = id and lookup[id]
	if new == nil then return end

	swapped += 1
	if swapped <= 10 then
		print("[Replacer] swapped " .. inst.ClassName .. "." .. p .. " (" .. tostring(id) .. ")")
	end

	if p == "MeshId" then
		if new == "" then
			hideMesh(inst)
		else
			applyMesh(inst, new)
			fitMesh(inst, new, SCALE_BY_ID[id])
			applyTexture(inst)
		end
	else
		pcall(function() inst[p] = new end)
	end
end

local function apply(inst)
	local props = PROPS[inst.ClassName]
	if not props or seen[inst] then return end
	seen[inst] = true
	for _, p in ipairs(props) do
		handle(inst, p)
		pcall(function()
			inst:GetPropertyChangedSignal(p):Connect(function() handle(inst, p) end)
		end)
	end
end

local function scan()
	local n = 0
	for _, d in ipairs(game:GetDescendants()) do
		apply(d)
		n += 1
		if n % 2000 == 0 then task.wait() end
	end
end

scan()
game.DescendantAdded:Connect(apply)

task.spawn(function()
	while true do
		task.wait(5)
		scan()
	end
end)

print("[Replacer] loaded")
