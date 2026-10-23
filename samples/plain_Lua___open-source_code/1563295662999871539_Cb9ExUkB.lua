--!strict

local function getAsset(url: string): string
	local success, result = pcall(function()
		if writefile and isfile and getcustomasset then
			local fileName = "mc_" .. tostring(#url % 100000) .. ".asset"

			if not isfile(fileName) then
				local data = game:HttpGet(url)
				if data and #data > 80 then
					writefile(fileName, data)
				end
			end

			local asset = getcustomasset(fileName)
			if asset and asset ~= "" then
				return asset
			end
		end

		return url
	end)

	return (success and result) or url
end

local Rules = {
	-- ====================== TEXTURA DEL MAPA ======================
	{ids = {7658055825}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/item_slot_3_blue_hollow.png"},

	-- ====================== SONIDOS ======================
	{ids = {17138490999}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/levelup.ogg"},
	{ids = {103035811146294}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/click.ogg"},
	{ids = {16810041280}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/villager/yes1.ogg"},
	{ids = {16810321565}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/villager/no1.ogg"},
	{ids = {16770456156, 16492958314}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/enderdragon/wings1.ogg"},
	{ids = {16537337310, 16537449730}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/orb.ogg"},
	{ids = {17826470563}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/note/pling.ogg"},
	{ids = {15109829804}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/headshot_silverfish_kill.ogg"},
	{ids = {18221725850, 18239670056, 18221726246}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/records/chirp.ogg"},
	{ids = {18239670367}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/zombie/say1.ogg"},
	{ids = {17026600996}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/anvil_land.ogg"},
	{ids = {16530229616}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/kill1_zombie_hurt.ogg"},
	{ids = {16530229541}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/kill2_ghast_death.ogg"},
	{ids = {16530229695}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/kill3_wither_death.ogg"},
	{ids = {99115398611290}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/note/pling.ogg"},
	{ids = {8483887957}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/chicken/say1.ogg"},
	{ids = {6384899588}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/music/menu/menu1.ogg"},
	{ids = {70643163489676}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/anvil_land.ogg"},
	{ids = {91547731028928}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/demote_anvil_break.ogg"},
	{ids = {138975587469438}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/levelup.ogg"},
	{ids = {17697682466, 17733314783}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/music/menu/menu2.ogg"},
	{ids = {177266782}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/wood_click.ogg"},
	{ids = {18525513345}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/note/bd.ogg"},
	{ids = {13110130082}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/successful_hit.ogg"},
	{ids = {17467242617}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/enderdragon/growl1.ogg"},
	{ids = {14812965418}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/molotov_idle_fire.ogg"},
	{ids = {14812827622}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/molotov_ignite.ogg"},
	{ids = {13455969017}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/rpg_explosion.ogg"},
	{ids = {16812389263}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/molotov_extinguish_fizz.ogg"},
	{ids = {114274252176516}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/portal_ambience.ogg"},
	{ids = {17259538274}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/note/pling.ogg"},
	{ids = {17769583566}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/pop.ogg"},
	{ids = {18221897857}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/wither/spawn.ogg"},
	{ids = {106551800007995}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/random/bow.ogg"},
	{ids = {114467311328776}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/mob/endermen/idle1.ogg"},
	{ids = {13160401062}, url = "https://66mods-assets.pages.dev/repos/InventivetalentDev/minecraft-assets/assets/minecraft/sounds/entity/player/attack/strong1.ogg"},
	{ids = {85163949920258}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/jumppad_place_slime.ogg"},
	{ids = {17835965985}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/jumppad_bounce_slime.ogg"},
	{ids = {82715240396507}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/crossbow_shoot1.ogg"},
	{ids = {112269321366473}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/crossbow_loading_start.ogg"},
	{ids = {76155503538875}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/crossbow_loading_end.ogg"},
	{ids = {13270206222, 13270206087}, url = "https://66mods-assets.pages.dev/repos/66buncer/Rivals-Pack-Assets/sniper_candidate_enderdragon_hit.ogg"},

	-- ====================== UI ======================
	{ids = {13220167337}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/item_slot_1_grey.png"},
	{ids = {13188242420}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/item_slot_2_red.png"},
	{ids = {13220167472}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/item_slot_3_blue.png"},
	{ids = {13188153054}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/item_slot_4_green.png"},
	{ids = {13188242287}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/item_slot_5_gold.png"},
	{ids = {17803962335}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/welcome.png"},
	{ids = {81461991645938}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/lvl_eye_new.png"},
	{ids = {99135525400251}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/ender_eye.png"},
	{ids = {133793956251748}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/arch.png"},
	{ids = {116941545385923}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/nem.png"},
	{ids = {8276600102}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/heart_hp.png"},
	{ids = {126928245743331}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/killfeed_headshot_skull.png"},

	-- X roja SOLO para botones de salir/cerrar
	{ids = {17838290166, 17619444538, 108220438104376}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_x.png"},

	{ids = {17838317115}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_plus.png"},
	{ids = {17562685319}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_back_arrow.png"},
	{ids = {113844621753627}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_next_arrow.png"},
	{ids = {17229230506}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_lock.png"},
	{ids = {18175187129, 17495953455}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_key.png"},
	{ids = {14641612286, 17619445191}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_gear_settings.png"},
	{ids = {17175095665}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/icon_trophy.png"},
	{ids = {16802957270}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/bone.png"},
	{ids = {133917828562858, 121503061771505}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/egg.png"},
	{ids = {108088064658436}, url = "https://raw.githubusercontent.com/66buncer/Rivals-Pack-Assets/main/arenamine.png"},
}

local IdMap: {[string]: string} = {}

for _, rule in ipairs(Rules) do
	local asset = getAsset(rule.url)

	for _, id in ipairs(rule.ids) do
		IdMap[tostring(id)] = asset
	end
end

local function apply(obj: Instance)
	if not obj then
		return
	end

	local function replace(property: string)
		local success, value = pcall(function()
			return obj[property]
		end)

		if not success or type(value) ~= "string" then
			return
		end

		local id = string.match(value, "%d+")
		if id and IdMap[id] then
			pcall(function()
				obj[property] = IdMap[id]
			end)
		end
	end

	if obj:IsA("Sound") then
		replace("SoundId")
	elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
		replace("Image")
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		replace("Texture")
	elseif obj:IsA("MeshPart") then
		replace("TextureID")
	end
end

task.wait(1.5)

for _, descendant in ipairs(game:GetDescendants()) do
	task.spawn(apply, descendant)
end

game.DescendantAdded:Connect(function(obj)
	task.defer(apply, obj)
end)

print("Script listo - X roja solo en botones de salir")