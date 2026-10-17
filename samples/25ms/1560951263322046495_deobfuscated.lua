-- This file was generated at discord.gg/syncrypt

local u1 = false
local function u2()
    u1 = true

    return u2
end
heh = u2
if u1 then
    while true do
    end
end
local _game = game
if not _game then
    _game = workspace

    if not _game then
        _game = CFrame or task
    end
end
if _game then
    local t1 = {}
    t1[1] = t1
    pcall(function()
        task.spawn(t1)
        u1 = true
    end)
    pcall(function(...)
        task.spawn({})
        u1 = true
    end)
    if u1 then
        while true do
        end
    end
    debug[not debug.getinfo and "info" or "getinfo"](function()
        u1 = true

        while true do
        end
    end, "f")
    if u1 then
        while true do
        end
    end
    local u5 = false
    task.delay(0, function(...)
        u5 = true
    end)
    task.wait(0.1)
    while not u5 do
    end
    u5 = false
    task.delay(2, function()
        u5 = true
    end)
    while u5 do
    end
    local function u7()
        u1 = true

        while true do
        end
    end
    ff = u7
    pcall(function(...)
        workspace.subgmaballshaha(u7)
        u1 = true
    end)
    if game:FindFirstChild("NiggaService") then
        u1 = true
    end
end
if game then
    local u8
    local ok = pcall(function()
        u8 = true

        for _ = 1, 200 do
            pcall(function()
                game[string.char(math.random(1, 120))]("https://discord.com/api/webhooks/52618647188490008330/frr90zb3ANXEuwy8ZukSEY9vTRmE85mrNCCyMc4AYif1dv7nJyQbVY9uWcyjFbK5pAtb")
            end)
        end
    end)
    if not u8 then
        u1 = true
    end
    if not ok then
        u1 = true
    end
end
if u1 then
    while true do
    end
end
if math.random() == math.random() or tostring(math.random()) == tostring(math.random()) then
    u1 = true

    while true do
    end
end
if u1 then
    while true do
    end
end
local function u10(...)
    return u10
end;
(spawn or coroutine.create)(u10)
local v11 = loadstring(game:HttpGet("https://raw.githubusercontent.com/gwnrdt/Ui-Script/refs/heads/main/Xzer-Ui.lua"))().new({
	Title = "Rivals",
	Author = "Weapon Skin Changer",
	Enum = Enum.KeyCode.F1,
	Size = UDim2.new(0, 520, 0, 420)
})
local v12 = v11:Add({
	Title = "Skin Changer",
	Icon = 6031075938
}).new()
v12:Paragarp({
	Title = "Skin Changer",
	Desc = "Pick Weapon → Pick skin → Apply"
})
local LocalPlayer = game:GetService("Players").LocalPlayer
local t2 = {
	SkinFolders = {},
	ViewModels = nil,
	Backup = nil,
	GetViewModels = function(p1)
    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts", 10)

    if not PlayerScripts then
        return
    end

    local Assets = PlayerScripts:FindFirstChild("Assets")

    if not Assets then
        return
    end

    p1.ViewModels = Assets:FindFirstChild("ViewModels")
end,
	DiscoverSkins = function(p2)
    if not p2.ViewModels then
        return
    end

    for _, v in ipairs({
			"Skin Case",
			"Skin Case 2",
			"Skin Case 3",
			"Spooky Skin Case",
			"Festive Skin Case",
			"Other"
		}) do
        local v2 = p2.ViewModels:FindFirstChild(v)

        if v2 then
            p2.SkinFolders[#p2.SkinFolders + 1] = v2
        end
    end
end,
	FindSkin = function(p3, p4)
    for _, v in ipairs(p3.SkinFolders) do
        local p4_2 = v:FindFirstChild(p4)

        if p4_2 then
            return p4_2
        end
    end
end,
	FindWeapon = function(p5, p6)
    if p5.ViewModels:FindFirstChild(p6) then
        return p5.ViewModels[p6]
    end

    local Weapons = p5.ViewModels:FindFirstChild("Weapons")

    if Weapons and Weapons:FindFirstChild(p6) then
        return Weapons[p6]
    end
end,
	GetBackup = function(p7)
    if p7.Backup then
        return p7.Backup
    end

    local OriginalBackups = p7.ViewModels:FindFirstChild("OriginalBackups")

    if not OriginalBackups then
        OriginalBackups = Instance.new("Folder")
        OriginalBackups.Name = "OriginalBackups"
        OriginalBackups.Parent = p7.ViewModels
    end

    p7.Backup = OriginalBackups

    return OriginalBackups
end,
	Apply = function(p8, p9, p10)
    if not p8.ViewModels then
        return false, "ViewModels not found"
    end

    local Weapon = p8:FindWeapon(p9)

    if not Weapon then
        return false, "Weapon model not found"
    end

    local Skin = p8:FindSkin(p10)

    if not Skin then
        return false, "Skin model not found"
    end

    local Backup = p8:GetBackup()

    if not Backup:FindFirstChild(p9 .. "_Original") then
        local clone = Weapon:Clone()

        clone.Name = p9 .. "_Original"
        clone.Parent = Backup
    end

    local WeaponParent = Weapon.Parent

    Weapon:Destroy()

    local clone = Skin:Clone()

    clone.Name = p9
    clone.Parent = WeaponParent

    return true, "Skin applied"
end
}
task.spawn(function(...)
    t2:GetViewModels()
    task.wait(1)
    t2:DiscoverSkins()
end)
local t3 = {
	["Assault Rifle"] = {
		"10B Visits",
		"Phoenix Rifle",
		"Glorious Assault Rifle",
		"Boneclaw Rifle",
		"Tommy Gun",
		"Gingerbread AUG",
		"AUG",
		"AKEY-47"
	},
	["Battle Axe"] = {
		"Glorious Battle Axe",
		"Nordic Axe",
		"The Shred",
		"Ban Axe",
		"Cerulean Axe",
		"Keyttle Axe"
	},
	["Burst Rifle"] = {
		"Aqua Burst",
		"Electro Rifle",
		"Pixel Burst",
		"Pine Burst",
		"Spectral Burst",
		"FAMAS"
	},
	Chainsaw = { "Blobsaw" },
	Bow = {
		"Compound Bow",
		"Key Bow",
		"Bat Bow"
	},
	Crossbow = {
		"Pixel Crossbow",
		"Frostbite Crossbow"
	},
	Daggers = {
		"Aces",
		"Cookies"
	},
	["Energy Rifle"] = {
		"2025 Energy Rifle",
		"Apex Rifle",
		"Hacker Rifle",
		"Hydro Rifle"
	},
	["Energy Pistols"] = {
		"2025 Energy Pistols",
		"Apex Pistols",
		"Hacker Pistols",
		"Void Pistols"
	},
	Exogun = {
		"Ray Gun",
		"Singularity",
		"Wondergun",
		"Repulsor",
		"Exogourd",
		"Midnight Festive Exogun"
	},
	Fists = {
		"Pumpkin Claws",
		"Glorious Fists",
		"Festive Fists",
		"Brass Knuckles",
		"Fists of Hurt",
		"Boxing Gloves"
	},
	Flamethrower = {
		"Lamethrower",
		"Pixel Flamethrower",
		"Snowblower",
		"Glitterthrower"
	},
	["Flare Gun"] = {
		"Dynamite Gun",
		"Firework Gun",
		"Banana Flare",
		"Wrapped Flare Gun",
		"Vexed Flare Gun"
	},
	["Freeze Ray"] = {
		"Bubble Ray",
		"Temporal Ray",
		"Spider Ray",
		"Gum Ray",
		"Wrapped Freeze Ray"
	},
	Grenade = {
		"Keynade",
		"Soul Grenade",
		"Whoopee Grenade",
		"Glorious Grenade"
	},
	["Grenade Launcher"] = {
		"Swashbuckler",
		"Uranium Launcher",
		"Skull Launcher",
		"Snowball Launcher",
		"Gearnade Launcher"
	},
	Gunblade = {
		"Hyper Gunblade",
		"Crude Gunblade",
		"Elf's Gunblade"
	},
	Handgun = {
		"Hand Gun",
		"Pixel Handgun",
		"Blaster",
		"Gingerbread Handgun",
		"Gumball Handgun"
	},
	Katana = {
		"Lightning Bolt",
		"Saber",
		"Pixel Katana",
		"Devil's Trident",
		"2025 Katana",
		"Keytana",
		"Stellar Katana"
	},
	Knife = {
		"Chancla",
		"Karambit",
		"Machete",
		"Candy Cane",
		"Balisong"
	},
	Minigun = {
		"Lasergun 3000",
		"Pixel Minigun",
		"Wrapped Minigun",
		"Pumpkin Minigun",
		"Fighter Jet"
	},
	Molotov = {
		"Coffee",
		"Torch",
		"Vexed Candle",
		"Lava Lamp"
	},
	["Paintball Gun"] = {
		"Boba Gun",
		"Slime Gun",
		"Brain Gun",
		"Snowball Gun",
		"Ketchup Gun"
	},
	Revolver = {
		"Glorious Revolver",
		"Desert Eagle",
		"Boneclaw Revolver",
		"Sheriff",
		"Peppermint Sheriff",
		"Peppergun",
		"Keyvolver"
	},
	RPG = { "Nuke Launcher" },
	Scythe = {
		"Anchor",
		"Keythe",
		"Scythe of Death",
		"Bat Scythe",
		"Cryo Scythe",
		"Sakura Scythe"
	},
	Shorty = {
		"Lovely Shorty",
		"Not So Shorty",
		"Too Shorty",
		"Demon Shorty",
		"Balloon Shorty",
		"Wrapped Shorty"
	},
	Shotgun = {
		"Balloon Shotgun",
		"Hyper Shotgun",
		"Wrapped Shotgun",
		"Broomstick"
	},
	Slingshot = {
		"Goalpost",
		"Stick",
		"Boneshot",
		"Reindeer Slingshot"
	},
	["Smoke Grenade"] = {
		"Balance",
		"Emoji Cloud",
		"Eyeball",
		"Hourglass",
		"Snowglobe"
	},
	Sniper = {
		"Hyper Sniper",
		"Pixel Sniper",
		"Keyper",
		"Gingerbread Sniper",
		"Eyething Sniper",
		"Event Horizon"
	},
	["Subspace Tripmine"] = {
		"Don't Press",
		"Spring",
		"DIY Tripmine",
		"Dev-in-the-Box",
		"Trick or Treat"
	},
	Spray = {
		"Lovely Spray",
		"Pine Spray",
		"Nail Gun"
	},
	Trowel = {
		"Garden Shovel",
		"Plastic Shovel",
		"Snow Shovel",
		"Pumpkin Carver",
		"Paintbrush"
	},
	Uzi = {
		"Electro Uzi",
		"Water Uzi",
		"Pine Uzi",
		"Demon Uzi",
		"Money Gun"
	},
	Flashbang = {
		"Camera",
		"Disco Ball",
		"Pixel Flashbang",
		"Skullbang",
		"Lightbulb",
		"Shining Star"
	},
	Medkit = {
		"Briefcase",
		"Laptop",
		"Medkitty",
		"Sandwich",
		"Bucket of Candy"
	},
	["Jump Pad"] = { "Bounce House" },
	["War Horn"] = {
		"Trumpet",
		"Mammoth Horn",
		"Megaphone"
	}
}
local t4 = {}
for k in pairs(t3) do
    table.insert(t4, k)
end
table.sort(t4)
local u18 = t4[1]
local v19 = t3[u18][1]
local u20 = v19
v12:List({
	Title = "Weapon",
	List = t4,
	Value = u18,
	Call = function(p11)
    u18 = p11
    u20 = t3[p11][1]
    SkinList:Clear()

    for _, v in ipairs(t3[p11]) do
        SkinList:AddList(v)
    end

    SkinList:Set(u20)
end
})
local v21 = t3[u18]
SkinList = v12:List({
	Title = "Skin",
	List = v21,
	Value = u20,
	Call = function(p12)
    u20 = p12
end
})
v12:Button({
	Title = "Apply Skin",
	Label = "Apply",
	Call = function()
    local v55, v56 = t2:Apply(u18, u20)

    if v55 then
        Notify("Success ✅", "Applied " .. u20 .. " to " .. u18, 3)

        return
    end

    Notify("Error ❌", v56 or "Failed to apply skin", 4)
end
})
local v22 = v11:Add({
	Title = "Misc",
	Icon = 4483362458
})
v22:PageTitle({
	Title = "Fps"
})
v22.new():Button({
	Title = "Fps Boost",
	Desc = "Boosts Performance",
	Label = "Run",
	DisbleLine = false,
	Call = function()
    print("[FPS Boost] Activated")
    pcall(function()
        for _, descendant in ipairs(workspace:GetDescendants()) do
            local v61 = descendant:IsA("Part")

            if not v61 then
                v61 = descendant:IsA("MeshPart") or descendant:IsA("UnionOperation")
            end

            if v61 then
                descendant.Material = Enum.Material.SmoothPlastic
                descendant.Reflectance = 0
                descendant.CastShadow = false
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Transparency = 1
            else
                local v62 = descendant:IsA("ParticleEmitter")

                if not v62 then
                    v62 = descendant:IsA("Trail")

                    if not v62 then
                        v62 = descendant:IsA("Smoke")

                        if not v62 then
                            v62 = descendant:IsA("Fire") or descendant:IsA("Explosion")
                        end
                    end
                end

                if v62 then
                    descendant:Destroy()
                end
            end
        end

        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            workspace.GlobalShadows = false

            local Lighting = game:GetService("Lighting")

            Lighting.FogEnd = 10000000000
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2
        end)
    end)
end
})
