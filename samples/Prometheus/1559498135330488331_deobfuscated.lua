-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local Players = game:GetService("Players")

t2.value1 = game:GetService("ReplicatedStorage")
t2.value2 = game:GetService("DataStoreService"):GetDataStore("VIPNameColor_v1")
t2.value3 = "Item1"
t2.value4 = {}
for _, v in ipairs({
	"yahayuk",
	"arie",
	"acaa",
	"phoenix",
	"happiness",
	"uti",
	"leon",
	"aqua",
	"arctic",
	"ocean",
	"frozen",
	"glacier",
	"frost",
	"blizzard",
	"galaxy",
	"starlight",
	"void",
	"abyss",
	"nebula",
	"cosmos",
	"celestial",
	"forest",
	"venom",
	"sakura",
	"emerald",
	"jungle",
	"moss",
	"bloom",
	"gold",
	"ruby",
	"cyber",
	"aurion",
	"neon",
	"diamond",
	"sapphire",
	"amethyst",
	"topaz",
	"icefire",
	"blood",
	"spectral",
	"toxic",
	"shadow",
	"lightning",
	"aurora",
	"sunset2",
	"midnight"
}) do
	t1.value1 = t2.value4
	t1.value1[v] = true
end
local VIPNameColorRemotes = t2.value1:FindFirstChild("VIPNameColorRemotes")

if not VIPNameColorRemotes then
	VIPNameColorRemotes = Instance.new("Folder")
	VIPNameColorRemotes.Name = "VIPNameColorRemotes"
	VIPNameColorRemotes.Parent = t2.value1
end
t2.value5 = VIPNameColorRemotes
local function v7(p1, p2)
	local p2_2 = t2.value5:FindFirstChild(p2)

	if p2_2 then
		return p2_2
	end

	local v16 = Instance.new(p1)

	v16.Name = p2
	v16.Parent = t2.value5

	return v16
end
local v8 = v7("RemoteFunction", "GetVIPNameColorStatus")
local v9 = v7("RemoteFunction", "SaveVIPNameColor")

t1.value1 = v7("RemoteFunction", "ResetVIPNameColor")
t2.value6 = v7("RemoteEvent", "NameColorUpdated")
t2.value7 = nil
t2.value8 = nil
t2.value8 = {}
t2.value9 = nil
t2.value10 = {}
t2.value7 = 5
t2.value11 = 10
t2.value9 = 5
function t2.value12(p3, p4, p5)
	local v36 = tostring(p3) .. "_" .. p4
	local timestamp = tick()
	local v38 = t2.value10[v36]

	if not v38 then
		t2.value10[v36] = {
			count = 1,
			t = timestamp
		}

		return true
	end

	if timestamp - v38.t >= t2.value9 then
		v38.count = 1
		v38.t = timestamp

		return true
	end

	local s1 = "count"

	v38[s1] = v38[s1] + 1

	return p5 >= v38.count or t2.value7
end
function t2.value13(p6)
	if not _G.ShopAPI then
		return false
	end

	local ok, result = pcall(_G.ShopAPI.OwnsItem, p6, t2.value3)

	if ok then
		ok = result == true
	end

	return ok
end
function t2.value14(p7)
	if t2.value8[p7] ~= nil then
		return t2.value8[p7]
	end

	local ok, result = pcall(function()
		return t2.value2:GetAsync("VIPColor_" .. p7)
	end)

	if ok then
		ok = type(result) == "table"
	end

	local t3

	if ok then
		local v28 = result.Name or false
		local v29 = result.Icon or false

		t3 = {
			Name = v28,
			Icon = v29
		}
	else
		t3 = {
			Name = false,
			Icon = false
		}

		local ok2, result2 = pcall(function()
			return t2.value2:GetAsync("Name_" .. p7)
		end)

		if ok2 then
			ok2 = type(result2) == "table"
		end

		if ok2 then
			t3.Name = result2
		end
	end

	t2.value8[p7] = t3

	return t3
end
function t2.value15(p8, p9)
	return t2.value14(p8)[p9 ~= "icon" and "Name" or "Icon"] or nil
end
function t2.value16(p10, p11)
	task.spawn(function()
		pcall(function()
			local value2 = t2.value2
			local v82 = "VIPColor_" .. p10
			local v83 = p11
			local SetAsync = value2.SetAsync
			local v85 = v83.Name or nil
			local v86 = p11.Icon or nil

			SetAsync(value2, v82, {
				Name = v85,
				Icon = v86
			})
		end)
	end)
end
function t2.value17(p12, p13, p14)
	local v45 = t2.value14(p12)

	v45[p13 ~= "icon" and "Name" or "Icon"] = p14
	t2.value8[p12] = v45
	t2.value16(p12, v45)
end
t2.value18 = nil
function t2.value18(p15)
	if type(p15) ~= "table" then
		return false
	end

	for _, v in ipairs({
		"R",
		"G",
		"B"
	}) do
		local v20 = p15[v]
		local v21 = type(v20) ~= "number"

		if not v21 then
			v21 = v20 < 0 or v20 > 255
		end

		if v21 then
			return false
		end
	end

	return true
end
function t2.value19(p16)
	if type(p16) ~= "table" then
		return false, "Data tidak valid"
	end

	local v47 = p16.Mode ~= "rainbow"

	if v47 then
		v47 = p16.Mode ~= "gradient"

		if v47 then
			v47 = p16.Mode ~= "solid"
		end
	end

	if v47 then
		return false, "Mode tidak valid"
	end

	if p16.Mode == "gradient" and (type(p16.Preset) ~= "string" or not t2.value4[p16.Preset:lower()]) then
		return false, "Preset tidak valid"
	end

	if p16.Mode == "solid" and not t2.value18(p16.Color) then
		return false, "Warna tidak valid"
	end

	return true, "ok"
end
function v8.OnServerInvoke(player, p17)
	if not player or not player.Parent then
		return nil
	end

	local v50 = p17 or player

	if not v50 or not v50.Parent then
		return nil
	end

	if not t2.value12(player.UserId, "GetStatus", t2.value11) then
		local v51 = t2.value8[v50.UserId]
		local v52 = t2.value13(v50.UserId)
		local v53 = v51 and v51.Name or nil
		local v54 = v51 and v51.Icon or nil

		return {
			IsVIP = v52,
			Name = v53,
			Icon = v54,
			RateLimited = true
		}
	end

	if not t2.value13(v50.UserId) then
		return {
			IsVIP = false
		}
	end

	local v55 = t2.value15(v50.UserId, "name")
	local v56 = t2.value15(v50.UserId, "icon")

	return {
		IsVIP = true,
		Name = v55,
		Icon = v56
	}
end
function v9.OnServerInvoke(player, p18, p19)
	local v60 = not player

	if not v60 then
		v60 = not player.Parent
	end

	if v60 then
		return false, "Player tidak valid"
	end

	if not t2.value13(player.UserId) then
		return false, "Fitur ini khusus untuk VIP!"
	end

	local u61 = p19 ~= "icon" and "name" or "icon"

	if not t2.value12(player.UserId, "Save_" .. u61, t2.value7) then
		return false, "Terlalu banyak request!"
	end

	local v62, v63 = t2.value19(p18)

	if not v62 then
		return false, v63
	end

	local t4 = {
		Mode = p18.Mode
	}

	if p18.Mode == "gradient" then
		t4.Preset = p18.Preset:lower()
	elseif p18.Mode == "solid" then
		local v65 = math.floor(p18.Color.R)
		local v66 = math.floor(p18.Color.G)
		local v67 = math.floor(p18.Color.B)

		t4.Color = {
			R = v65,
			G = v66,
			B = v67
		}
	end

	t2.value17(player.UserId, u61, t4)
	pcall(function()
		t2.value6:FireAllClients(player, u61)
	end)

	return true, "Warna " .. (u61 ~= "icon" and "nama" or "ikon perangkat") .. " tersimpan!"
end
function t1.value1.OnServerInvoke(player, p20)
	local v70 = not player

	if not v70 then
		v70 = not player.Parent
	end

	if v70 then
		return false, "Player tidak valid"
	end

	if not t2.value13(player.UserId) then
		return false, "Fitur ini khusus untuk VIP!"
	end

	local u71 = p20 ~= "icon" and "name" or "icon"

	if not t2.value12(player.UserId, "Reset_" .. u71, t2.value7) then
		return false, "Terlalu banyak request!"
	end

	local v72 = t2.value14(player.UserId)

	v72[u71 ~= "icon" and "Name" or "Icon"] = false
	t2.value8[player.UserId] = v72
	t2.value16(player.UserId, v72)
	pcall(function()
		t2.value6:FireAllClients(player, u71)
	end)

	return true, "Warna " .. (u71 ~= "icon" and "nama" or "ikon perangkat") .. " direset ke default!"
end
function t2.value20(p21)
	local v74 = tostring(p21) .. "_"

	for k in pairs(t2.value10) do
		local v76 = k

		if v74 == v76:sub(1, #v74) then
			t2.value10[v76] = nil
		end
	end
end
Players.PlayerRemoving:Connect(function(player)
	if not player then
		return
	end

	t2.value8[player.UserId] = nil
	t2.value20(player.UserId)
end)
task.spawn(function()
	while true do
		task.wait(180)

		local timestamp = tick()

		for k, v in pairs(t2.value10) do
			if timestamp - v.t > t2.value9 * 10 then
				t2.value10[k] = nil
			end
		end
	end
end)
